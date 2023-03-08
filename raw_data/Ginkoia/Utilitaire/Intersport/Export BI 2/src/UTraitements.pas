unit UTraitements;

interface

uses
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  FireDAC.Comp.Client,
  FireDAC.Stan.Option,
  System.Classes,
  System.Generics.Defaults,
  System.Generics.Collections,
  UItem,
  uLogFile;

type
  TEnumTypeTRaitement = (ett_ReInsertion, ett_Correction, ett_Recalcul, ett_Activation, ett_DesActivation, ett_Initialisation, ett_Exports, ett_FTPSend, ett_Validation, ett_MailSend);
  TSetTraitementTodo = set of TEnumTypeTRaitement;

type
  TTraitementThread = class(TThread)
  protected
    // pour le traitement
    FUseJeton : boolean;
    FListe : TItemDictionary<TDossierItem, TMagasinItem>;
    FWhatToDo : TSetTraitementTodo;
    // param ??
    FDateCorrection : TDate;
    FRepDestination : string;
    FDateValide : TDate;
    // pour la progression
    FDosProgress, FMagProgress, FItemProgress : TProgressBar;
    FLabelDosMag, FLabelEtapes : TLabel;
    FStepProgress : string;
    FNbMaxItem : integer;

    // fichier de suivit
    FValidationDate : TDate;
    FValidationMagasin : TDictionary<string, TDate>;

    // Nb jour de verification pour le CA
    FNbJourVerifCA : integer;

    // gestion de logs
    FLogs : TLogFile;
    FRapFileDelta : string;
    FRapFileInit : string;

    // propriétaire de la liste ???
    OwnListe : boolean;

    // gestion de la progression
    procedure InitProgressDossier();
    procedure InitProgressMagasin();
    procedure InitProgressItem();
    procedure ProgressItemMarquee();
    procedure ProgressItemStopMarquee();
    procedure ProgressStepDosMag();
    procedure ProgressStepEtapes();

    // recup de la date de validation
    function GetDateMagasin(Code : string) : TDate;
    procedure GetNetworkConnectInfo(out NomMachine, NomUtilisateur : string);

    // Gestion du fichier de suivit
    function DoGestionFichierSuivit() : boolean;
      function DoGetFichierSuivit(FileName : string) : boolean;
      function DoTraiteFichierSuivit(FileName : string) : boolean;

    // correction : Re insertion des lignes manquante
    function DoReInsert(Connexion : TFDConnection; Transaction : TFDTransaction; Dossier : TDossierItem) : boolean;
    // correction : Correction a date du dossier
    function DoCorrectionDate(Connexion : TFDConnection; Transaction : TFDTransaction; Dossier : TDossierItem; DateTrt : TDate) : boolean;

    // procedure de recalcul
    function DoRecalcul(Connexion : TFDConnection; Transaction : TFDTransaction; Dossier : TDossierItem) : boolean;
    // procedure d'activation magasin
    function DoActivate(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem; Activation : boolean) : boolean;
    // procedure d'initialisation
    function DoInitialisation(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem) : boolean;
    // procedure d'export !
    function DoExport(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem; DateDrnTrt : TDate; ZipFicName : string) : integer;
    // validation des lignes exporté !
    function DoValidation(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem; DateValide : TDate) : boolean;

    // Recuperation de la date de dernier mouvement
    function GetDateDernierMvt(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem) : TDate;
    // Recuperation du CA des X dernier jours
    function GetCAPeriode(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem) : Currency;

    // ecriture ...
    procedure WriteLineRapport(FileName : string; Dossier : TDossierItem; Magasin : TMagasinItem; NbLigne : integer; DateDrnMvt : TDate; CA : Currency; TrtOK : boolean; LibelleErr : string);
  public
    constructor Create(UseJeton : boolean; Liste : TItemDictionary<TDossierItem, TMagasinItem>; WhatToDo : TSetTraitementTodo;
                       DosProgress, MagProgress, ItemProgress : TProgressBar;
                       LabelDosMag, LabelEtapes : TLabel;
                       Logs : TLogFile;
                       CreateSuspended: Boolean = false); reintroduce;
    destructor Destroy(); override;

    property DateCorrection : TDate read FDateCorrection write FDateCorrection;
    property RepDestination : string read FRepDestination write FRepDestination;
    property DateValide : TDate read FDateValide write FDateValide;
    // retour ?
    property ReturnValue;
    // rapport ?
    property RapFileDelta : string read FRapFileDelta;
    property RapFileInit : string read FRapFileInit;
  end;

  TOtherThread = class(TTraitementThread)
  protected
    procedure Execute(); override;
  end;

  TExportThread = class(TTraitementThread)
  protected
    procedure Execute(); override;
  end;

implementation

uses
  Winapi.ActiveX,
  Winapi.Windows,
  System.Math,
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  System.Variants,
  System.Win.ComObj,
  System.Win.ComServ,
  IdFTP,
  IdFTPCommon,
  IdException,
  uSevenZip,
  uGestionBDD,
  ULectureIniFile,
  GestionJetonLaunch,
  GestionEMail,
  SelectList_Frm,
  UResourceString,
  USendFTP;

const
  // Accees BDD
  CST_LOGIN_BASE = 'sysdba';
  CST_PASSWORD_BASE = 'masterkey';
  // Gestion Jeton
  CST_JETON_TENTATIVE = 30;
  CST_JETON_DELAI = 5000;
  // corps de mail
  CST_EMAIL_REUSSIT = 'Bonsoir,' + sLineBreak + sLineBreak + 'Les exports se sont effectués correctement.' + sLineBreak + sLineBreak + 'Ceci est un message envoyé automatiquement par l''application ExportBI.exe (serveur %s).';
  CST_EMAIL_ECHEC = 'Bonsoir,' + sLineBreak + sLineBreak + 'Au moins une anomalie s''est produite lors de l''export.' + sLineBreak + 'Veuillez consulter le fichier de rapport pour plus de détails.' + sLineBreak + sLineBreak + 'Ceci est un message envoyé automatiquement par l''application ExportBI.exe (serveur %s).';


type
  TEnumResItem = (eri_NothingToDO, eri_OK, eri_KO);

{ TTraitementThread }

// gestion de la progression

procedure TTraitementThread.InitProgressDossier();
begin
  // progression
  FDosProgress.Position := 0;
  FDosProgress.Step := 1;
  FDosProgress.Max := FNbMaxItem;
  FMagProgress.Position := 0;
  FMagProgress.Step := 1;
  FMagProgress.Max := 1;
  FItemProgress.Position := 0;
  FItemProgress.Step := 1;
  FItemProgress.Max := 1;
end;

procedure TTraitementThread.InitProgressMagasin();
begin
  // progression
  FMagProgress.Position := 0;
  FMagProgress.Step := 1;
  FMagProgress.Max := FNbMaxItem;
  FItemProgress.Position := 0;
  FItemProgress.Step := 1;
  FItemProgress.Max := 1;
end;

procedure TTraitementThread.InitProgressItem();
begin
  FItemProgress.Style := pbstNormal;
  FItemProgress.Position := 0;
  FItemProgress.Step := 1;
  FItemProgress.Max := FNbMaxItem;
end;

procedure TTraitementThread.ProgressItemMarquee();
begin
  FItemProgress.Style := pbstMarquee;
end;

procedure TTraitementThread.ProgressItemStopMarquee();
begin
  FItemProgress.Style := pbstNormal;
  FItemProgress.Position := 0;
  FItemProgress.Step := 1;
  FItemProgress.Max := 1;
  FItemProgress.StepIt();
end;

procedure TTraitementThread.ProgressStepDosMag();
begin
  if Assigned(FLogs) then
    FLogs.Log(FStepProgress, logTrace);
  FLabelDosMag.Caption := FStepProgress;
end;

procedure TTraitementThread.ProgressStepEtapes();
begin
  if Assigned(FLogs) then
    FLogs.Log(FStepProgress, logTrace);
  FLabelEtapes.Caption := FStepProgress;
end;

// utilitaire

function TTraitementThread.GetDateMagasin(Code : string) : TDate;
begin
  if FValidationMagasin.ContainsKey(Code) then
    Result := FValidationMagasin[Code]
  else
    Result := FValidationDate;
end;

procedure TTraitementThread.GetNetworkConnectInfo(out NomMachine, NomUtilisateur : String);
var
  WshNetwork: olevariant;
begin
  try
    try
      WshNetwork := CreateoleObject('WScript.Network');
      NomMachine := WshNetwork.ComputerName;
      NomUtilisateur := WshNetwork.username;
    finally
      WshNetwork := Unassigned;
    end
  except
    NomMachine := '< Inconnue >';
    NomUtilisateur := '< Inconnu >';
  end;
end;


// Different traitement

function TTraitementThread.DoGestionFichierSuivit() : boolean;
var
  tmpFile : string;
begin
  Result := false;

  try
    // nom du fichier
    ForceDirectories(FRepDestination);
    tmpFile := FRepDestination + FormatDateTime('yyyymmdd.hhnnss.zzz.', Now()) + 'suivi_trans.csv';
    // traitement
    if not DoGetFichierSuivit(tmpFile) then
      Exit;
    if not DoTraiteFichierSuivit(tmpFile) then
      Exit;
    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]));
    end;
  end;
end;

function TTraitementThread.DoGetFichierSuivit(FileName : string) : boolean;
var
  IdFTP : TIdFTP;
  Server, Username, Password, Directory : string;
  Port : integer;
begin
  Result := false;

  try
    // lecture des info de config
    if not ReadIniFTP(Server, Username, Password, Directory, Port) then
      Raise Exception.Create(rs_ExceptionReadIni);

    try
      IdFTP := TIdFTP.Create(nil);
      IdFTP.Host := Server;
      IdFTP.Port := Port;
      IdFTP.Username := Username;
      IdFTP.Password := DecryptPasswd(Password);
      IdFTP.TransferType := ftBinary;

      IdFTP.Connect();
      if IdFTP.Connected then
      begin
        try
          IdFTP.Passive := True;
          if Trim(Directory) <> '' then
            IdFTP.ChangeDir(Directory);
          IdFTP.Get('suivi_trans.csv', FileName, True, False);
          // ok ?
          result := true;
        finally
          try
            IdFTP.Disconnect();
          except
            on e : EIdConnClosedGracefully do
              ;
            on e : Exception do
              Raise;
          end;
        end;
      end
      else
        Raise Exception.Create(rs_ExceptionConnectFTP);
    finally
      FreeAndNil(IdFTP);
    end;
  except
    on e : Exception do
    begin
      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]));
    end;
  end;
end;

function TTraitementThread.DoTraiteFichierSuivit(FileName : string) : boolean;
var
  tmpFile : TStringList;
  tmpLigne, tmpMagasin : string;
  tmpDate : TDate;
begin
  Result := false;

  try
    try
      tmpFile := TStringList.Create();
      tmpFile.LoadFromFile(FileName);

      for tmpLigne in tmpFile do
      begin
        if not ((Trim(tmpLigne) = '') or (tmpLigne[1] = '#')) then
        begin
          tmpMagasin := Copy(tmpLigne, 6, 9);
          tmpDate := StrToDate(Copy(tmpLigne, 21, 2) + '/' + Copy(tmpLigne, 19, 2) + '/' + Copy(tmpLigne, 15, 4));
          // Donne la date du dernier traitement réussi
          if Copy(tmpLigne, 1, 5) = '99999' then
            FValidationDate := tmpDate
          else
          begin
            if FValidationMagasin.ContainsKey(tmpMagasin) then
              FValidationMagasin[tmpMagasin] := Min(FValidationMagasin[tmpMagasin], tmpDate)
            else
              FValidationMagasin.Add(tmpMagasin, tmpDate);
          end;
        end;
      end;
    finally
      FreeAndNil(tmpFile);
    end;
    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]));
    end;
  end;
end;

function TTraitementThread.DoReInsert(Connexion : TFDConnection; Transaction : TFDTransaction; Dossier : TDossierItem) : boolean;
var
  Query : TFDQuery;
begin
  Result := false;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Bar de progression
    FNbMaxItem := 3;
    Synchronize(InitProgressItem);

    // Creation de la procedure
    Query.SQL.Add('create procedure TMP_ISFBI_CORRECTION_MVT');
    Query.SQL.Add('as');
    Query.SQL.Add('declare variable magid integer;');
    Query.SQL.Add('declare variable artid integer;');
    Query.SQL.Add('declare variable tgfid integer;');
    Query.SQL.Add('declare variable couid integer;');
    Query.SQL.Add('declare variable datemvt date;');
    Query.SQL.Add('declare variable mvttype integer;');
    Query.SQL.Add('declare variable magdest integer;');
    Query.SQL.Add('begin');
    Query.SQL.Add('/******************************************************************************/');
    Query.SQL.Add('/* Date        | Nom | Commentaire                                            */');
    Query.SQL.Add('/******************************************************************************/');
    Query.SQL.Add('/* 2014-08-11  | BP  | Procedure fait repassé dans le BI tous les mouvement   */');
    Query.SQL.Add('/*                     qui ont pas deja été ...                               */');
    Query.SQL.Add('/*                                                                            */');
    Query.SQL.Add('/******************************************************************************/');
    Query.SQL.Add('');
    Query.SQL.Add('  for select mvt_magid, mvt_artid, mvt_tgfid, mvt_couid, mvt_datex, mvt_type');
    Query.SQL.Add('      from agrmouvement');
    Query.SQL.Add('      where mvt_id != 0');
    Query.SQL.Add('        and not exists (select *');
    Query.SQL.Add('                        from isfmvtbitraite');
    Query.SQL.Add('                        where imt_magid = agrmouvement.mvt_magid and imt_idmvt = agrmouvement.mvt_idligne)');
    Query.SQL.Add('      into :magid, :artid, :tgfid, :couid, :datemvt, :mvttype do');
    Query.SQL.Add('  begin');
    Query.SQL.Add('    if (mvttype = 3) then');
    Query.SQL.Add('    begin');
    Query.SQL.Add('      /* Transfert Intermagasin */');
    Query.SQL.Add('      /* faire une deuxième ligne avec le magasin de destination */');
    Query.SQL.Add('      select ima_magdid from transfertim where ima_id = :identete into :magdest;');
    Query.SQL.Add('      execute procedure isfbi_addmvt(:magdest, :artid, :tgfid, :couid, :mvtdate);');
    Query.SQL.Add('    end');
    Query.SQL.Add('    execute procedure isfbi_addmvt(:magid, :artid, :tgfid, :couid, :datemvt);');
    Query.SQL.Add('  end');
    Query.SQL.Add('end;');
    Query.ExecSQL();
    Synchronize(FItemProgress.StepIt);
    // Execute de la procedure
    Query.SQL.Text := 'execute procedure TMP_ISFBI_CORRECTION_MVT;';
    Query.ExecSQL();
    Synchronize(FItemProgress.StepIt);
    // Drop de la procedure
    Query.SQL.Text := 'drop procedure TMP_ISFBI_CORRECTION_MVT;';
    Query.ExecSQL();
    Synchronize(FItemProgress.StepIt);

    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      e.Message := 'DoReInsert : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.DoCorrectionDate(Connexion : TFDConnection; Transaction : TFDTransaction; Dossier : TDossierItem; DateTrt : TDate) : boolean;
var
  Query : TFDQuery;
begin
  Result := false;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Bar de progression
    FNbMaxItem := 3;
    Synchronize(InitProgressItem);

    // Creation de la procedure
    Query.SQL.Add('create procedure ISFBI_RETRAITEMENT_BI(datetrt date)');
    Query.SQL.Add('as');
    Query.SQL.Add('declare variable mvtid integer;');
    Query.SQL.Add('declare variable magid integer;');
    Query.SQL.Add('declare variable artid integer;');
    Query.SQL.Add('declare variable tgfid integer;');
    Query.SQL.Add('declare variable couid integer;');
    Query.SQL.Add('declare variable mvtdate date;');
    Query.SQL.Add('begin');
    Query.SQL.Add('/******************************************************************************/');
    Query.SQL.Add('/* Date        | Nom | Commentaire                                            */');
    Query.SQL.Add('/* 2014-08-11  | BP  | Procedure fait repassé dans le BI tous les mouvement   */');
    Query.SQL.Add('/*                     depuis une certaine date                               */');
    Query.SQL.Add('/*                     Correction suite a betise du prestataire               */');
    Query.SQL.Add('/*                                                                            */');
    Query.SQL.Add('/******************************************************************************/');
    Query.SQL.Add('');
    Query.SQL.Add('  for select imt_idmvt, mvt_magid, mvt_artid, mvt_tgfid, mvt_couid, cast(mvt_date as date)');
    Query.SQL.Add('      from isfmvtbitraite join agrmouvement on mvt_idligne = imt_idmvt');
    Query.SQL.Add('      where imt_datetraite >= :datetrt');
    Query.SQL.Add('      into :mvtid, :magid, :artid, :tgfid, :couid, :mvtdate do');
    Query.SQL.Add('  begin');
    Query.SQL.Add('    if (mvtdate < (datetrt -1)) then');
    Query.SQL.Add('      update isfmvtbitraite set imt_datetraite = (:datetrt -2), imt_datevalide = (:datetrt -1), imt_fichier = ''toexpt'' where imt_idmvt = :mvtid;');
    Query.SQL.Add('    else');
    Query.SQL.Add('      update isfmvtbitraite set imt_fichier = ''todell'' where imt_idmvt = :mvtid;');
    Query.SQL.Add('    execute procedure isfbi_addmvt(:magid, :artid, :tgfid, :couid, :mvtdate);');
    Query.SQL.Add('  end');
    Query.SQL.Add('  delete from isfmvtbitraite where imt_fichier = ''todell'';');
    Query.SQL.Add('  update isfmvtbitraite set imt_fichier = null where imt_fichier = ''toexpt'';');
    Query.SQL.Add('end;');
    Query.ExecSQL();
    Synchronize(FItemProgress.StepIt);
    // Execute de la procedure
    Query.SQL.Text := 'execute procedure ISFBI_RETRAITEMENT_BI(' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTrt)) + ');';
    Query.ExecSQL();
    Synchronize(FItemProgress.StepIt);
    // Drop de la procedure
    Query.SQL.Text := 'drop procedure ISFBI_RETRAITEMENT_BI;';
    Query.ExecSQL();
    Synchronize(FItemProgress.StepIt);

    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      e.Message := 'DoCorrectionDate : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.DoRecalcul(Connexion : TFDConnection; Transaction : TFDTransaction; Dossier : TDossierItem) : boolean;
var
  Query : TFDQuery;
  nblig, res : integer;
begin
  Result := false;
  res := 0;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // nombre d'enreg !
    try
      Query.SQL.Text := 'select count(*) as nb from gentriggerdiff;';
      QUery.Open();
      if Query.Eof then
        nblig := 0
      else
        nblig := Query.Fields[0].AsInteger
    finally
      Query.Close();
    end;

    // Bar de progression
    FNbMaxItem := (nblig div 500) + Max(1, (nblig mod 500));
    Synchronize(InitProgressItem);

    // nouveau recalcul
    QUery.SQL.Text := 'execute procedure eai_trigger_pretraite;';
    Query.ExecSQL();
    // boucle de traitement
    repeat
      Query.SQL.Text := 'select retour from eai_trigger_differe(500);';
      try
        Query.Open();
        if Query.Eof then
          Raise Exception.Create(rs_ExceptionBoucleRecalcul)
        else
          res := Query.FieldByName('retour').AsInteger;
      finally
        Query.Close();
      end;
      Synchronize(FItemProgress.StepIt);
    until res = 0;

    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      e.Message := 'DoRecalcul : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.DoActivate(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem; Activation : boolean) : boolean;
var
  Query : TFDQuery;
begin
  Result := false;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Creation du paramètre
    Query.SQL.Text := 'execute procedure SM_CREER_PARAM(3, 67, ''Init du BI effectué'', '''', 0, 0, ' + IntToStr(Magasin.Id) + ', 0);';
    Query.ExecSQL();
    // modification du paramètre
    if Activation then
      Query.SQL.Text := 'update genparam set prm_float = 1 where prm_type = 3 and prm_code = 67 and prm_magid = ' + IntToStr(Magasin.Id) + ';'
    else
      Query.SQL.Text := 'update genparam set prm_float = 0 where prm_type = 3 and prm_code = 67 and prm_magid = ' + IntToStr(Magasin.Id) + ';';
    Query.ExecSQL();

    // Bar de progression
    Synchronize(ProgressItemStopMarquee);

    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      e.Message := 'DoActivate : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.DoInitialisation(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem) : boolean;
var
  Query : TFDQuery;
begin
  Result := false;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Initialisarion effective
    Query.SQL.Text := 'execute procedure ISFBI_MVTREINIT(' + IntToStr(Magasin.Id) + ');';
    Query.ExecSQL();
    // Creation du paramètre
    Query.SQL.Text := 'execute procedure sm_creer_param(3, 67, ''Init du BI effectué'', '''', 0, 1, ' + IntToStr(Magasin.Id) + ', 0);';
    Query.ExecSQL();
    // modification du paramètre
    Query.SQL.Text := 'update genparam set prm_string = '''', prm_integer = 0 where prm_type = 3 and prm_code = 67 and prm_magid = ' + IntToStr(Magasin.Id) + ';';
    Query.ExecSQL();
    // reset de la valeur du paramètre
    Magasin.IsInit := false;
    Magasin.DateInit := 0;
    Magasin.DateDrnTrt := 0;

    // Bar de progression
    Synchronize(ProgressItemStopMarquee);

    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      e.Message := 'DoInitialisation : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.DoExport(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem; DateDrnTrt : TDate; ZipFicName : string) : integer;

  function Complete(ANbCar: integer; AValue: string; ACar: char = ' '): string;
  begin
    if Length(AValue) >= ANbCar then
      Result := Copy(AValue, 1, ANbCar)
    else
    begin
      Result := AValue;
      while Length(Result) < ANbCar do
        Result := Result + ACar;
    end;
  end;

  function LComplete(ANbCar: integer; AValue: string; ACar: char = ' '): string;
  begin
    if Length(AValue) >= ANbCar then
      Result := Copy(AValue, 1, ANbCar)
    else
    begin
      Result := AValue;
      while Length(Result) < ANbCar do
        Result := ACar + Result;
    end;
  end;

var
  sLigne : string;
  sTicket : string;
  sPathFicMvt : string;     // Chemin vers le fichier mouvement à zipper
  sPathFicMvtSvg : string;  // Chemin vers le fichier mouvement à sauvegarder
  sPathFicSuiv : string;    // Chemin vers le fichier suivi à zipper
  sPathFicSuivSvg: string;  // Chemin vers le fichier suivi à sauvegarder
  dtMvtDateMin : TDateTime; // Date du mouvement le plus ancien
  dtMvtDateMax : TDateTime; // Date du mouvement le plus récent
  dtDateMax : TDateTime;    // Date d'extraction
  sStock : string;          // Variabl de stockage du stock en string
  txtFicDest : TextFile;    // Variable Fichier pour le fichier de sortie
  SevenZip : I7zOutArchive; // Interface de Zip
  tsResult: TStrings;
  que_Mouvements, que_Parametre : TFDQuery;
  NumFile : integer;
  svgZipeFile : string;
begin
  Result := 0;

  // Fichier Généré
  sPathFicMvt := FRepDestination + 'trans.csv';
  sPathFicSuiv := FRepDestination + 'trans_suivi.csv';
  // Nom de sauvegarde
  sPathFicMvtSvg := FRepDestination + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + StringReplace(Magasin.Code, '/', '_', [rfReplaceAll]) + '.trans.csv';
  sPathFicSuivSvg := FRepDestination + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + StringReplace(Magasin.Code, '/', '_', [rfReplaceAll]) + '.trans_suivi.csv';

  try
    try
      // tempo de la progressBar
      Synchronize(ProgressItemMarquee);

      que_Mouvements := GetNewQuery(Connexion, Transaction);
      que_Mouvements.SQL.Text := 'select * from isfbi_extract_mvt(' + QuotedStr(Magasin.Code) + ');';
      que_Mouvements.Open();

//      // init de la progressBAr
//      FNbMaxItem := que_Mouvements.RecordCount;
//      Synchronize(InitProgressItem);

      // Initialisation
      sStock := LComplete(8, que_Mouvements.FieldByName('STOCKCOUR').AsString, '0');
      dtMvtDateMin := que_Mouvements.FieldByName('DATEVAL').AsDateTime;
      dtMvtDateMax := que_Mouvements.FieldByName('DATEVAL').AsDateTime;
      if Frac(Now()) < 0.25 then
        dtDateMax := Trunc(Now()) - 1
      else
        dtDateMax := Trunc(Now());

      try
        // ouverture du fichier
        AssignFile(txtFicDest, sPathFicMvt);
        Rewrite(txtFicDest);

        // parcour des lignes
        while (not que_Mouvements.Eof) and (Magasin.Code = que_Mouvements.FieldByName('CODMAG').AsString) do
        begin
          // Un fichier par magasin
          sTicket := que_Mouvements.FieldByName('CODMAG').AsString
                   + FormatDateTime('HHMM', que_Mouvements.FieldByName('DATEVAL').AsDateTime)
                   + que_Mouvements.FieldByName('IDENTETE').AsString;

          sLigne := Complete(10, que_Mouvements.FieldByName('CODMAG').AsString) + ';'                                        // A    // 0
                  + Complete(36, sTicket) + ';'                                                          // Ticket           // B    // 1
                  + Complete(1, que_Mouvements.FieldByName('TRATYPE').AsString) + ';'                    // Type             // C    // 2
                  + Complete(1, 'N') + ';'                                                               // Service          // D    // 3
                  + Complete(3, 'GIN') + ';'                                                             // PROV             // E    // 4
                  + FormatDateTime('YYYYMMDD', que_Mouvements.FieldByName('DATEVAL').AsDateTime) + ';'   // Dateval          // F    // 5
                  + Complete(10, que_Mouvements.FieldByName('ARTCOL').AsString) + ';'                    // Col              // G    // 6
                  + Complete(20, que_Mouvements.FieldByName('ARTREFMRK').AsString) + ';'                 // Code modele      // H    // 7
                  + Complete(30, que_Mouvements.FieldByName('ARTNOM').AsString) + ';'                    // Lib modèle       // I    // 8
                  + Complete(20, que_Mouvements.FieldByName('ARTREFMRK').AsString) + ';'                 // Modèle fourn     // J    // 9
                  + Complete(3, que_Mouvements.FieldByName('COUCODE').AsString) + ';'                    // Code coul        // K    // 10
                  + Complete(30, que_Mouvements.FieldByName('COUNOM').AsString) + ';'                    // Lib coul         // L    // 11
                  + Complete(5, que_Mouvements.FieldByName('TGFNOM').AsString) + ';'                     // Taille Frn       // M    // 12
                  + Complete(5, '') + ';'                                                                // Index taille     // N    // 13
                  + Complete(5, que_Mouvements.FieldByName('TGSNOM').AsString) + ';'                     // Taille ref FR    // O    // 14
                  + Complete(15, que_Mouvements.FieldByName('SKU').AsString) + ';'                       // SKU              // P    // 15
                  + Complete(15, '') + ';'                                                               // Colis            // Q    // 16
                  + Complete(10, '') + ';'                                                               // Code fou         // R    // 17
                  + Complete(30, '') + ';'                                                               // Lib Fou          // S    // 18
                  + Complete(3, que_Mouvements.FieldByName('MRKCODE').AsString) + ';'                    // Code Mrk         // T    // 19
                  + Complete(30, que_Mouvements.FieldByName('MRKNOM').AsString) + ';'                    // Lib Mrk          // U    // 20
                  + Complete(6, que_Mouvements.FieldByName('ARTFEDAS').AsString) + ';'                   // Fedas            // V    // 21
                  + Complete(20, que_Mouvements.FieldByName('ARTCHRONO').AsString) + ';'                 // CategM           // W    // 22
                  + Complete(5, '') + ';'                                                                // Typpo            // X    // 23
                  + Complete(1, que_Mouvements.FieldByName('TDSC').AsString) + ';'                       // TDSC             // Y    // 24
                  + Complete(1, '') + ';'                                                                // Referencement    // Z    // 25
                  + Complete(8, que_Mouvements.FieldByName('QTETRANS').AsString) + ';'                                             // Qté              // AA   // 26
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPABHT').AsString, ',', '.', [rfReplaceAll])) + ';'  // PxAB             // AB   // 27
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPANHT').AsString, ',', '.', [rfReplaceAll])) + ';'  // PxAN             // AC   // 28
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPVBTTC').AsString, ',', '.', [rfReplaceAll])) + ';' // PxVB             // AD   // 29
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPVNTTC').AsString, ',', '.', [rfReplaceAll])) + ';' // PxVN             // AE   // 30
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPMP').AsString, ',', '.', [rfReplaceAll])) + ';'    // Pump             // AF   // 31
                  + LComplete(5, StringReplace(que_Mouvements.FieldByName('MVTTVA').AsString, ',', '.', [rfReplaceAll])) + ';'     // Tva              // AG   // 32
                  + Complete(3, 'EUR') + ';'                                                             // DEV              // AH   // 33
                  + Complete(6, '') + ';'                                                                // Surf tot         // AI   // 34
                  + Complete(6, '') + ';'                                                                // Surf vte         // AJ   // 35
                  + Complete(6, '') + ';'                                                                // Surf res         // AK   // 36
                  + LComplete(5, Magasin.Dossier.Code) + ';'                                             // Grp mag          // AL   // 37
                  + Complete(10, '') + ';'                                                               // Code mag Princ   // AM   // 38
                  + Complete(1, que_Mouvements.FieldByName('ARTTYPE').AsString) + ';'                    // Libre 1 (origine)// AN   // 39
                  + Complete(1, '') + ';'                                                                // Libre 2          // AO   // 40
                  + Complete(10, '') + ';'                                                               // Libre 3          // AP   // 41
                  + Complete(10, '') + ';'                                                               // Libre 4          // AQ   // 42
                  + Complete(1, '') + ';'                                                                // Statut           // AR   // 43
                  + FormatDateTime('YYYYMMDD', que_Mouvements.FieldByName('DATEVAL').AsDateTime) + ';'   // Date_trans       // AS   // 44
                  + FormatDateTime('YYYYMMDD', Now) + ';'                                                // Date remontée    // AT   // 45
                  + Complete(1, '') + ';'                                                                // Flag Trt         // AU   // 46
                  + Complete(8, '') + ';'                                                                // Date Trt         // AV   // 47
                  + LComplete(8, que_Mouvements.FieldByName('QTETRANS').AsString) + ';'                  // Qte BW           // AW   // 48
                  + Complete(8, '') + ';'                                                                // Date BW          // AY   // 49
                  + Complete(1, que_Mouvements.FieldByName('FLAG').AsString) + ';'                       // Flag             // AZ   // 50
                  + Complete(15, '') + ';';                                                              // Numéro carte fid         // 51
          WriteLn(txtFicDest, sLigne);
          // get des dates min et max
          dtMvtDateMin := Min(dtMvtDateMin, que_Mouvements.FieldByName('DATEVAL').AsDateTime);
          dtMvtDateMax := Max(dtMvtDateMax, que_Mouvements.FieldByName('DATEVAL').AsDateTime);
          // retour
          Inc(Result);
//          // suivant
//          Synchronize(FItemProgress.StepIt);
          que_Mouvements.Next();
        end;
      finally
        CloseFile(txtFicDest);
      end;

      // Fichier de controle
      try
        tsResult := TStringList.Create();
        if Magasin.IsInit then
        begin
          // magasin deja initialisé -> Fichier delta
          tsResult.Add('[Groupe]=' + Magasin.Dossier.Code);
          tsResult.Add('[ad_IP]=127.0.0.1');
          tsResult.Add('[Mag_P]=' + Magasin.Code);
          tsResult.Add('[Version]=BI_V2.1');
          tsResult.Add('[Date_suivi]=' + FormatDateTime('YYYYMMDD', DateDrnTrt));
          tsResult.Add('[Date_debut_extraction]=' + FormatDateTime('YYYYMMDD', dtMvtDateMin));
          tsResult.Add('[Date_max_extraction]=' + FormatDateTime('YYYYMMDD', dtDateMax));
          tsResult.Add('[Type_connexion]=2');
          tsResult.Add('[Nbr_ligne]=' + IntToStr(Result));
          tsResult.Add('[comparaison]=' + Magasin.Code + ';' + sStock + ';' + sStock + ';000');
          tsResult.Add('[Magasin]=' + Magasin.Code);
        end
        else
        begin
          // magasin pas encore initialisé -> Fichier d'init
          tsResult.Add('[Groupe]=' + Magasin.Dossier.Code);
          tsResult.Add('[ad_IP]=127.0.0.1');
          tsResult.Add('[Mag_P]=' + Magasin.Code);
          tsResult.Add('[debut_histo]=' + FormatDateTime('YYYYMMDD', dtMvtDateMin));
          tsResult.Add('[fin_histo]=' + FormatDateTime('YYYYMMDD', dtMvtDateMax));
          tsResult.Add('[Version]=BI_V2');
          tsResult.Add('[Nbr_ligne]=' + IntToStr(Result));
          tsResult.Add('[Magasin]=' + Magasin.Code);
          // Gestion du paramètre d'init
          try
            que_Parametre := GetNewQuery(Connexion, Transaction);
            que_Parametre.SQL.Text := 'execute procedure sm_creer_param(3, 67, ''Init du BI effectué'', ' + QuotedStr(FormatDateTime('dd/mm/yyyy', Trunc(Now))) + ', 1, 1, ' + IntToStr(Magasin.Id) + ', 0);';
            que_Parametre.ExecSQL();
            que_Parametre.SQL.Text := 'update genparam set prm_string = ' + QuotedStr(FormatDateTime('dd/mm/yyyy', Trunc(Now))) + ', prm_integer = 1 where prm_type = 3 and prm_code = 67 and prm_magid = ' + IntToStr(Magasin.Id) + ';';
            que_Parametre.ExecSQL();
          finally
            FreeAndNil(que_Parametre);
          end;
        end;
        tsResult.SaveToFile(sPathFicSuiv);
      finally
        FreeAndNil(tsResult);
      end;

      // est ce que le fichier existe deja ?
      if FIleExists(ZipFicName) then
      begin
        NumFile := 0;
        svgZipeFile := ChangeFileExt(ZipFicName, '.old.zip');
        while FIleExists(svgZipeFile) do
        begin
          Inc(NumFile);
          svgZipeFile := ChangeFileExt(ZipFicName, '.old-' + IntToStr(NumFile) + '.zip');
        end;
        MoveFile(PWideChar(ZipFicName), PWideChar(svgZipeFile))
      end;
      // Zipper les fichiers
      try
        SevenZip := CreateOutArchive(CLSID_CFormatZip);
        SevenZip.AddFiles(ExtractFilePath(sPathFicMvt), '', ExtractFileName(sPathFicMvt), false);
        SevenZip.AddFiles(ExtractFilePath(sPathFicSuiv), '', ExtractFileName(sPathFicSuiv), false);
        SevenZip.SaveToFile(ZipFicName);
      finally
        SevenZip := nil;
      end;

      // Sauvegarde des fichiers
      RenameFile(sPathFicSuiv, sPathFicSuivSvg);
      RenameFile(sPathFicMvt, sPathFicMvtSvg);

      Synchronize(ProgressItemStopMarquee);
    finally
      que_Mouvements.Close();
      FreeAndNil(que_Mouvements);
    end;
  except
    on e : Exception do
    begin
      e.Message := 'DoExport : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.DoValidation(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem; DateValide : TDate) : boolean;
var
  Query : TFDQuery;
begin
  Result := false;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Execute de la procedure
    Query.SQL.Text := 'execute procedure ISFBI_DOVALIDATE(' + QuotedStr(Magasin.Code) + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateValide)) + ');';
    Query.ExecSQL();

    // Bar de progression
    Synchronize(ProgressItemStopMarquee);

    // ok ?
    Result := true;
  except
    on e : Exception do
    begin
      e.Message := 'DoValidation : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.GetDateDernierMvt(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem) : TDate;
var
  Query : TFDQuery;
begin
  Result := 0;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Execute de la procedure
    Query.SQL.Text := 'select max(mvt_datex) as mvt_datex from agrmouvement where mvt_magidx = ' + IntToStr(Magasin.Id) + ';';
    Query.Open();
    if not Query.Eof then
      Result := Query.FieldByName('mvt_datex').AsDateTime;

    // Bar de progression
    Synchronize(ProgressItemStopMarquee);
  except
    on e : Exception do
    begin
      e.Message := 'GetDateDernierMvt : ' + e.Message;
      raise;
    end;
  end;
end;

function TTraitementThread.GetCAPeriode(Connexion : TFDConnection; Transaction : TFDTransaction; Magasin : TMagasinItem) : Currency;
var
  Query : TFDQuery;
begin
  Result := 0;

  try
    // tempo de la progressBar
    Synchronize(ProgressItemMarquee);

    Query := GetNewQuery(Connexion, Transaction);

    // Execute de la procedure
    Query.SQL.Text := 'select sum(mvt_pxunet * case when mvt_type = 1 then mvt_qte '
                    + '                             when mvt_type = 5 and (select typ_cod from negfacture join gentypcdv on typ_id = fce_typid where fce_id = agrmouvement.mvt_identete) not in (6, 902, 1001) then mvt_qte '
                    + '                             else 0 '
                    + '                        end) as montant '
                    + 'from agrmouvement '
                    + 'where mvt_kenabled = 1 '
                    + '  and mvt_magidx = ' + IntToStr(Magasin.Id) + ' '
                    + '  and mvt_id != 0 '
                    + '  and mvt_type in (1, 5) '
                    + '  and mvt_datex between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IncDay(Now(), -FNbJourVerifCA))) + ' and current_date;';
    Query.Open();
    if not Query.Eof then
      Result := Query.FieldByName('montant').AsCurrency;

    // Bar de progression
    Synchronize(ProgressItemStopMarquee);
  except
    on e : Exception do
    begin
      e.Message := 'GetCAPeriode : ' + e.Message;
      raise;
    end;
  end;
end;

procedure TTraitementThread.WriteLineRapport(FileName : string; Dossier : TDossierItem; Magasin : TMagasinItem; NbLigne : integer; DateDrnMvt : TDate; CA : Currency; TrtOK : boolean; LibelleErr : string);
var
  FichierRapport : TextFile;
  Line : string;
begin
  // enreg du rapport !!!
  // Serveur : Dossier.Serveur
  // code adherent : Magasin.Code
  // Date de dernier mouvement : DateDernierMvt
  // CA sur les X dernier jour : CAPeriode
  // etat des export : DosOk and MagOk
  // libelle d'erreur : LibelleErr

  // trim du messge
  LibelleErr := stringReplace(LibelleErr, #13#10, ' ', [rfReplaceAll]) ;
  LibelleErr := stringReplace(LibelleErr, #13, ' ', [rfReplaceAll]) ;
  LibelleErr := stringReplace(LibelleErr, #10, ' ', [rfReplaceAll]) ;

  // contruction de la chaine
  Line := '';
  if Assigned(Dossier) then
    Line := Line + Dossier.Serveur + ';' + Dossier.Code + ';' + Dossier.Nom + ';'
  else
    Line := Line + ';;;';
  if Assigned(Magasin) then
    Line := Line + Magasin.Code + ';' + Magasin.Nom + ';'
  else
    Line := Line + ';;';
  Line := Line + IntToStr(NbLigne) + ';'
               + FormatDateTime('yyyy-mm-dd', DateDrnMvt) + ';'
               + Format('%.2f', [CA]) + ';'
               + IfThen(TrtOK, 'oui', 'non') + ';'
               + LibelleErr;

  // ecriture
  try
    AssignFile(FichierRapport, FileName);
    Append(FichierRapport);
    Writeln(FichierRapport, Line);
  finally
    CloseFile(FichierRapport);
  end;
end;

// Creation/Destruction

constructor TTraitementThread.Create(UseJeton : boolean; Liste : TItemDictionary<TDossierItem, TMagasinItem>; WhatToDo : TSetTraitementTodo;
                                     DosProgress, MagProgress, ItemProgress : TProgressBar;
                                     LabelDosMag, LabelEtapes : TLabel;
                                     Logs : TLogFile;
                                     CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  // Paramètres
  FUseJeton := UseJeton;
  FListe := Liste;
  FWhatToDo := WhatToDo;
  // progression
  FDosProgress := DosProgress;
  FMagProgress := MagProgress;
  FItemProgress := ItemProgress;
  FLabelDosMag := LabelDosMag;
  FLabelEtapes := LabelEtapes;
  // Init variable interne
  FRapFileDelta := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + 'Logs') + 'Rapport_Delta_' + FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now()) + '.csv';
  FRapFileInit := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + 'Logs') + 'Rapport_Init_' + FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now()) + '.csv';
  FNbMaxItem := 1;
  // Init propriété
  FDateCorrection := IncDay(Now());
  FRepDestination := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + 'Extract') + FormatDateTime('yyyy' + PathDelim + 'mm' + PathDelim + 'dd' + PathDelim, Now());
  FDateValide := IncDay(Now());
  // Fichier de validation
  FValidationDate := IncDay(Now());
  FValidationMagasin := TDictionary<string, TDate>.Create();
  // Creation du logger
  FLogs := Logs;
  if not ReadIniVerifCA(FNbJourVerifCA) then
    FNbJourVerifCA := 30;
  // propriétaire de la liste ?
  OwnListe := not Assigned(FListe);
end;

destructor TTraitementThread.Destroy();
begin
  // liberation
  FreeAndNil(FValidationMagasin);
  // gestion de la progression !
  FNbMaxItem := 1;
  InitProgressDossier();
  FStepProgress := '';
  ProgressStepDosMag();
  ProgressStepEtapes();
  // liberration de la liste
  if OwnListe then
    FreeAndNil(FListe);
  inherited Destroy();
end;

{ TOtherThread }

procedure TOtherThread.Execute();
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Dossier : TDossierItem;
  Magasin : TMagasinItem;
  HasInit : boolean;
  DosOk, MagOk : TEnumResItem;
  LibelleErr : string;
  NbLigneExport : integer;
  DateDernierMvt : TDate;
  CAPeriode : Currency;
  {$REGION ' Gestion du jeton '}
  tpJeton : TTokenParams; // Record avec les paramètres pour les Jetons
  Token : TTokenManager;  // Classe de gestion du Jeton
  {$ENDREGION}
begin
  ReturnValue := 0;
  LibelleErr := '';
  HasInit := false;

  try
    CoInitialize(nil);

    FLogs.Log('', logTrace);
    FLogs.Log(rs_TraceStartThread, logTrace);
    FLogs.Log('', logTrace);

    if FListe.CountValues = 0 then
      ReturnValue := Min(ReturnValue, -6);

    try
      FLogs.Log(rs_TraceSeparateur, logTrace);
      FLogs.Log(rs_TraceGestionBase, logTrace);

      // progression
      FNbMaxItem := FListe.Count;
      Synchronize(InitProgressDossier);

      //=====================
      // Pour chaque dossiers
      for Dossier in FListe.Keys do
      begin
        // mais pourquoi ????
        if not Assigned(Dossier) then
          Continue;

        // gestion des dossier desactivé !
        if Dossier.Actif then
        begin
          DosOk := eri_OK;
          LibelleErr := '';
        end
        else
        begin
          DosOk := eri_NothingToDO;
          LibelleErr := rs_ErreurDossierInactif;
        end;
        Magasin := nil;
        NbLigneExport := 0;
        DateDernierMvt := 0;
        CAPeriode := 0;

        // progression
        FNbMaxItem := FListe[Dossier].Count;
        Synchronize(InitProgressMagasin);
        // label
        FStepProgress := Format(rs_CaptionDossier, [Dossier.Code, Dossier.Nom]);
        Synchronize(ProgressStepDosMag);

        try
          try
            if FUseJeton then
{$REGION '            Prise du jeton '}
            begin
              FStepProgress := rs_StepJeton;
              Synchronize(ProgressStepEtapes);
              try
                tpJeton := GetParamsToken(Dossier.Serveur, Dossier.FileName, CST_LOGIN_BASE, CST_PASSWORD_BASE);
                Token := TTokenManager.Create();
                Token.tryGetToken(StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]), tpJeton.sDatabaseWS, tpJeton.sSenderWS, CST_JETON_TENTATIVE, CST_JETON_DELAI);
                if Token.Acquired then
                  FLogs.Log(rs_LibDecalage + rs_NoErreur)
                else // Jeton non acquis
                begin
                  case Token.Reason of
                    TOKEN_OK            : raise Exception.Create(rs_ExceptionJetonOK);
                    TOKEN_OQP           : raise Exception.Create(rs_ExceptionJetonOQP);
                    TOKEN_ERR_CNX       : raise Exception.Create(rs_ExceptionJetonCNX);
                    TOKEN_ERR_PRM       : raise Exception.Create(rs_ExceptionJetonPRM);
                    TOKEN_ERR_HTTP      : raise Exception.Create(rs_ExceptionJetonHTTP);
                    TOKEN_ERR_INTERNAL  : raise Exception.Create(rs_ExceptionJetonINTERNAL);
                    TOKEN_ABORTED       : raise Exception.Create(rs_ExceptionJetonABORTED);
                    TOKEN_NEVER         : raise Exception.Create(rs_ExceptionJetonNEVER);
                    else                  raise Exception.Create(Format(rs_ExceptionJetonOTHER, [Token.Reason]));
                  end;
                end;
              except
                on e : Exception do
                begin
                  DosOk := eri_KO;
                  FLogs.Log(rs_LibDecalage + rs_HasErreur + ' ' + Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                  LibelleErr := e.Message;
                end;
              end;
            end;
{$ENDREGION}

            try
              // Connexion base de données
              Connexion := GetNewConnexion(Dossier.Serveur, Dossier.FileName, CST_LOGIN_BASE, CST_PASSWORD_BASE, false);
              Connexion.FetchOptions.Unidirectional := true;
              Connexion.Open();
              Transaction := GetNewTransaction(Connexion, false);

              // Traitements...

              if (ett_Recalcul in FWhatToDo) then
{$REGION '              Recalcul du dossier '}
              begin
                FStepProgress := rs_StepRecalcule;
                Synchronize(ProgressStepEtapes);
                if (DosOk = eri_OK) then
                begin
                  try
                    Transaction.StartTransaction();
                    if not DoRecalcul(Connexion, Transaction, Dossier) then
                      raise Exception.Create(rs_ExceptionRecalcule);
                    Transaction.Commit();
                  except
                    on e : Exception do
                    begin
                      Transaction.Rollback();
                      DosOk := eri_KO;
                      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                      LibelleErr := e.Message;
                    end;
                  end;
                end
                else
                  FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
              end;
{$ENDREGION}

              // Corrections...

              if (ett_ReInsertion in FWhatToDo) then
{$REGION '              Reinsertion des lignes manquantes '}
              begin
                FStepProgress := rs_StepReInsert;
                Synchronize(ProgressStepEtapes);
                if (DosOk = eri_OK) then
                begin
                  try
                    Transaction.StartTransaction();
                    if not DoReInsert(Connexion, Transaction, Dossier) then
                      raise Exception.Create(rs_ExceptionReInsert);
                    Transaction.Commit();
                  except
                    on e : Exception do
                    begin
                      Transaction.Rollback();
                      DosOk := eri_KO;
                      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                      LibelleErr := e.Message;
                    end;
                  end;
                end
                else
                  FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
              end;
{$ENDREGION}

              if (ett_Correction in FWhatToDo) then
{$REGION '              Correction a Date '}
              begin
                FStepProgress := rs_StepCorrectionDate;
                Synchronize(ProgressStepEtapes);
                if (DosOk = eri_OK) then
                begin
                  try
                    Transaction.StartTransaction();
                    if not DoCorrectionDate(Connexion, Transaction, Dossier, FDateCorrection) then
                      raise Exception.Create(rs_ExceptionCorrectionDate);
                    Transaction.Commit();
                  except
                    on e : Exception do
                    begin
                      Transaction.Rollback();
                      DosOk := eri_KO;
                      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                      LibelleErr := e.Message;
                    end;
                  end;
                end
                else
                  FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
              end;
{$ENDREGION}

              //=====================
              // Pour chaque magasins
              for Magasin in FListe[Dossier].List do
              begin
                // mais pourquoi ????
                if not Assigned(Magasin) then
                  Continue;

                if (DosOk = eri_OK) then
                begin
                  MagOk := eri_OK;
                  LibelleErr := '';
                end
                else
                  MagOk := eri_NothingToDO;
                NbLigneExport := 0;
                DateDernierMvt := 0;
                CAPeriode := 0;

                // label
                FStepProgress := Format(rs_CaptionMagasin, [Magasin.Code, Magasin.Nom, Dossier.Code, Dossier.Nom]);
                Synchronize(ProgressStepDosMag);

                try
                  if ((ett_Activation in FWhatToDo) or (ett_DesActivation in FWhatToDo)) then
{$REGION '                  Activation des magasins '}
                  begin
                    FStepProgress := rs_StepActivationMagasin;
                    Synchronize(ProgressStepEtapes);
                    if (DosOk = eri_OK) and (MagOk = eri_OK) then
                    begin
                      try
                        Transaction.StartTransaction();
                        if not DoActivate(Connexion, Transaction, Magasin, (ett_Activation in FWhatToDo)) then
                          raise Exception.Create(rs_ExceptionActivationMag);
                        Transaction.Commit();
                      except
                        on e : Exception do
                        begin
                          Transaction.Rollback();
                          MagOk := eri_KO;
                          FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                          LibelleErr := e.Message;
                        end;
                      end;
                    end
                    else
                      FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
                  end;
{$ENDREGION}

                  if (ett_Initialisation in FWhatToDo) then
{$REGION '                  Initialisation des magasins '}
                  begin
                    FStepProgress := rs_StepInitMagasin;
                    Synchronize(ProgressStepEtapes);
                    if (DosOk = eri_OK) and (MagOk = eri_OK) then
                    begin
                      try
                        Transaction.StartTransaction();
                        if not DoInitialisation(Connexion, Transaction, Magasin) then
                          raise Exception.Create(rs_ExceptionInitMagasin);
                        Transaction.Commit();
                      except
                        on e : Exception do
                        begin
                          Transaction.Rollback();
                          MagOk := eri_KO;
                          FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                          LibelleErr := e.Message;
                        end;
                      end;
                    end
                    else
                      FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
                  end;
{$ENDREGION}

                  if (ett_Validation in FWhatToDo) then
{$REGION '                  Validation des magasins '}
                  begin
                    FStepProgress := rs_StepValideMagasin;
                    Synchronize(ProgressStepEtapes);
                    if (DosOk = eri_OK) and (MagOk = eri_OK) then
                    begin
                      try
                        Transaction.StartTransaction();
                        if not DoValidation(Connexion, Transaction, Magasin, FDateValide) then
                          raise Exception.Create(rs_ExceptionInitMagasin);
                        Transaction.Commit();
                      except
                        on e : Exception do
                        begin
                          Transaction.Rollback();
                          MagOk := eri_KO;
                          FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                          LibelleErr := e.Message;
                        end;
                      end;
                    end
                    else
                      FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
                  end;
{$ENDREGION}
                except
                  on e : Exception do
                  begin
                    MagOk := eri_KO;
                    ReturnValue := Min(ReturnValue, -5);
                    FLogs.Log(Format(rs_ExceptionMagasin, [Dossier.Code, Dossier.Nom, Magasin.Code, Magasin.Nom, e.ClassName, e.Message]), logError);
                  end;
                end;
                // Ok ?
                if (MagOk = eri_KO) then
                  ReturnValue := Min(ReturnValue, -1);
                // progression
                Synchronize(FMagProgress.StepIt);
              end;
            finally
              FreeAndNil(Transaction);
              FreeAndNil(Connexion);
            end;
          finally
{$REGION '            Liberation du jeton '}
            if Assigned(Token) then
            begin
              FStepProgress := rs_StepFreeJeton;
              Synchronize(ProgressStepEtapes);
              FreeAndNil(Token); // Libération du jeton
            end;
{$ENDREGION}
          end;
        except
          on e : Exception do
          begin
            ReturnValue := Min(ReturnValue, -5);
            FLogs.Log(Format(rs_ExceptionDossier , [Dossier.Code, Dossier.Nom, e.ClassName, e.Message]), logError);
          end;
        end;
        // Ok ?
        if (DosOk = eri_KO) then
          ReturnValue := Min(ReturnValue, -2);
        // progression
        Synchronize(FDosProgress.StepIt);
      end;
    except
      on e : Exception do
      begin
        ReturnValue := Min(ReturnValue, -5);
        FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logError);
      end;
    end;
    FLogs.Log('', logTrace);
    FLogs.Log(rs_TraceEndOfThread, logTrace);
    FLogs.Log('', logTrace);
  finally
    CoUninitialize();
  end;
end;

{ TExportThread }

procedure TExportThread.Execute();
var
  FiltreDos, FiltreMag : string;
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Dossier : TDossierItem;
  Magasin : TMagasinItem;
  FicOk, HasInit : boolean;
  DosOk, MagOk : TEnumResItem;
  LibelleErr : string;
  NbLigneExport : integer;
  DateDernierMvt : TDate;
  CAPeriode : Currency;
  FichierRapport : TextFile;
  // fichier d'export
  ZipFicName : string;
  // envoie de mail
  Server, Username, Password, Sender : string;
  Port : integer;
  Securite : SecuriteMail;
  Destinataire : TStringList;
  // info serveur
  ServeurName, LoginName : string;
  {$REGION ' Gestion du jeton '}
  tpJeton : TTokenParams; // Record avec les paramètres pour les Jetons
  Token : TTokenManager;  // Classe de gestion du Jeton
  {$ENDREGION}
begin
  ReturnValue := 0;
  LibelleErr := '';
  HasInit := false;
  Destinataire := nil;

  try
    CoInitialize(nil);

    FLogs.Log('', logTrace);
    FLogs.Log(rs_TraceStartThread, logTrace);
    FLogs.Log('', logTrace);

    GetNetworkConnectInfo(ServeurName, LoginName);

    // gestion de la liste vide ...
    if Assigned(FListe) and ((FListe.Count = 0) or (FListe.CountValues = 0)) then
      FreeAndNil(FListe);
    if not Assigned(FListe) then
    begin
      OwnListe := true;
      FStepProgress := rs_CaptionGetListe;
      Synchronize(ProgressStepDosMag);
      FLogs.log(rs_InfoListeVide, logNotice);
      if not ReadIniFiltreDossier(FiltreDos) then
        FiltreDos := '';
      if not ReadIniFiltreMagasin(FiltreMag) then
        FiltreMag := '';
      FListe := GetListeDossierMagasin(nil, FLogs, false, false, FiltreDos + '', FiltreMag + '');
    end;

    try
      FStepProgress := rs_CaptionGestionSuivi;
      Synchronize(ProgressStepDosMag);
      // gestion du fichier de suivit
      FicOk := DoGestionFichierSuivit();
      if FicOk then
      begin
        FLogs.Log(rs_LibDecalage + rs_NoErreur, logTrace);
        FLogs.Log(Format(rs_LibDecalage + rs_TraceGestionSuiviDate, [FormatDateTime('yyyy-mm-dd', FValidationDate)]), logTrace);
        FicOk := FValidationDate >= Trunc(Now());
        if not FicOk then
        begin
          FLogs.Log(Format(rs_ErreurDateGlobale, [FormatDateTime('yyyy-mm-dd', FValidationDate)]), logError);
          LibelleErr := Format(rs_ErreurDateGlobale, [FormatDateTime('yyyy-mm-dd', FValidationDate)]);
          ReturnValue := Min(ReturnValue, -4);
        end;
      end
      else
      begin
        LibelleErr := rs_ErreurGetSuivi;
        ReturnValue := Min(ReturnValue, -3);
      end;

      // entete de fichier !
      try
        AssignFile(FichierRapport, FRapFileDelta);
        Rewrite(FichierRapport);
        Writeln(FichierRapport, Format(rs_EnteteFile, [FNbJourVerifCA]));
      finally
        CloseFile(FichierRapport);
      end;

      if FListe.Count < 1 then
      begin
        WriteLineRapport(FRapFileDelta, nil, nil, 0, 0, 0, false, rs_ErreurPasDeDossier);
        FLogs.Log(rs_ErreurPasDeDossier);
        LibelleErr := rs_ErreurPasDeDossier;
        ReturnValue := Min(ReturnValue, -6);
      end;

      FLogs.Log(rs_TraceSeparateur, logTrace);
      FLogs.Log(rs_TraceGestionExport, logTrace);

      // progression
      FNbMaxItem := FListe.Count;
      Synchronize(InitProgressDossier);

      //=====================
      // Pour chaque dossiers
      for Dossier in FListe.Keys do
      begin
        // mais pourquoi ????
        if not Assigned(Dossier) then
          Continue;

        // progression
        FNbMaxItem := FListe[Dossier].Count;
        Synchronize(InitProgressMagasin);
        // label
        FStepProgress := Format(rs_CaptionDossier, [Dossier.Code, Dossier.Nom]);
        Synchronize(ProgressStepDosMag);

        if Dossier.Actif then
        begin
          if FicOk then
          begin
            DosOk := eri_OK;
            LibelleErr := '';
          end
          else
            DosOk := eri_NothingToDO;
          Magasin := nil;
          NbLigneExport := 0;
          DateDernierMvt := 0;
          CAPeriode := 0;

          try
            try
              if FUseJeton then
{$REGION '              Prise du jeton '}
              begin
                FStepProgress := rs_StepJeton;
                Synchronize(ProgressStepEtapes);
                try
                  tpJeton := GetParamsToken(Dossier.Serveur, Dossier.FileName, CST_LOGIN_BASE, CST_PASSWORD_BASE);
                  Token := TTokenManager.Create();
                  Token.tryGetToken(StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]), tpJeton.sDatabaseWS, tpJeton.sSenderWS, CST_JETON_TENTATIVE, CST_JETON_DELAI);
                  if Token.Acquired then
                    FLogs.Log(rs_LibDecalage + rs_NoErreur)
                  else // Jeton non acquis
                  begin
                    case Token.Reason of
                      TOKEN_OK            : raise Exception.Create(rs_ExceptionJetonOK);
                      TOKEN_OQP           : raise Exception.Create(rs_ExceptionJetonOQP);
                      TOKEN_ERR_CNX       : raise Exception.Create(rs_ExceptionJetonCNX);
                      TOKEN_ERR_PRM       : raise Exception.Create(rs_ExceptionJetonPRM);
                      TOKEN_ERR_HTTP      : raise Exception.Create(rs_ExceptionJetonHTTP);
                      TOKEN_ERR_INTERNAL  : raise Exception.Create(rs_ExceptionJetonINTERNAL);
                      TOKEN_ABORTED       : raise Exception.Create(rs_ExceptionJetonABORTED);
                      TOKEN_NEVER         : raise Exception.Create(rs_ExceptionJetonNEVER);
                      else                  raise Exception.Create(Format(rs_ExceptionJetonOTHER, [Token.Reason]));
                    end;
                  end;
                except
                  on e : Exception do
                  begin
                    DosOk := eri_KO;
                    FLogs.Log(rs_LibDecalage + rs_HasErreur + ' ' + Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                    LibelleErr := e.Message;
                  end;
                end;
              end;
{$ENDREGION}

              try
                // Connexion base de données
                Connexion := GetNewConnexion(Dossier.Serveur, Dossier.FileName, CST_LOGIN_BASE, CST_PASSWORD_BASE, false);
                Transaction := GetNewTransaction(Connexion, false);
                Connexion.FetchOptions.Unidirectional := true;
                try
                  Connexion.Open();
                except
                  on e : Exception do
                  begin
                    ReturnValue := Min(ReturnValue, -5);
                    FLogs.Log(Format(rs_ExceptionDossier , [Dossier.Code, Dossier.Nom, e.ClassName, e.Message]), logError);
                    DosOk := eri_KO;
                    LibelleErr := rs_ErreurUnableToConnect;
                  end;
                end;

                // Traitements...

                if (ett_Recalcul in FWhatToDo) then
{$REGION '                Recalcul du dossier '}
                begin
                  FStepProgress := rs_StepRecalcule;
                  Synchronize(ProgressStepEtapes);
                  if (DosOk = eri_OK) then
                  begin
                    try
                      Transaction.StartTransaction();
                      if not DoRecalcul(Connexion, Transaction, Dossier) then
                        raise Exception.Create(rs_ExceptionRecalcule);
                      Transaction.Commit();
                    except
                      on e : Exception do
                      begin
                        Transaction.Rollback();
                        DosOk := eri_KO;
                        FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                        LibelleErr := e.Message;
                      end;
                    end;
                  end
                  else
                    FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);
                end;
{$ENDREGION}

                // pas de magasin ???
                if (FListe[Dossier].Count < 1) then
                begin
                  if DosOk = eri_OK then
                    WriteLineRapport(FRapFileDelta, Dossier, nil, 0, 0, 0, false, rs_ErreurPasDeMagasin)
                  else
                    WriteLineRapport(FRapFileDelta, Dossier, nil, 0, 0, 0, false, LibelleErr);
                end;

                //=====================
                // Pour chaque magasins
                for Magasin in FListe[Dossier].List do
                begin
                  // mais pourquoi ????
                  if not Assigned(Magasin) then
                    Continue;

                  // label
                  FStepProgress := Format(rs_CaptionMagasin, [Magasin.Code, Magasin.Nom, Dossier.Code, Dossier.Nom]);
                  Synchronize(ProgressStepDosMag);

                  if Magasin.Actif then
                  begin
                    if FicOk and (DosOk = eri_OK) then
                    begin
                      MagOk := eri_OK;
                      LibelleErr := '';
                    end
                    else
                      MagOk := eri_NothingToDO;
                    NbLigneExport := 0;
                    DateDernierMvt := 0;
                    CAPeriode := 0;
                    ZipFicName := FRepDestination + 'Trans_' + StringReplace(Magasin.Code, '/', '_', [rfReplaceAll]) + '_' + Magasin.Dossier.Code + '.zip';

                    if FicOk and (DosOk = eri_OK) and (MagOk = eri_OK) then
                    begin
                      try
{$REGION '                        Exports des données magasins '}
                        if Trim(Magasin.Code) = '' then
                        begin
                          MagOk := eri_KO;
                          FLogs.Log(rs_LibDecalage + rs_ErreurNoCodeAdh, logTrace);
                          LibelleErr := rs_ErreurNoCodeAdh;
                        end
                        else if not Magasin.IsInit then
                        begin
                          HasInit := true;
                          FLogs.Log(rs_LibDecalage + rs_ErreurInitTodo, logTrace);
                          LibelleErr := rs_ErreurInitTodo;
                        end
                        else
                        begin
                          FLogs.Log(rs_StepAskDoExport, logTrace);
                          if (GetDateMagasin(Magasin.Code) <= Magasin.DateDrnTrt) then
                          begin
                            MagOk := eri_KO;
                            FLogs.Log(rs_LibDecalage + rs_HasErreur + ' ' + rs_ErreurDateMagasin, logTrace);
                            FLogs.Log(rs_LibDecalage + Format(rs_ErreurDateMagasinDetail, [FormatDateTime('yyyy-mm-dd', GetDateMagasin(Magasin.Code)), FormatDateTime('yyyy-mm-dd', Magasin.DateDrnTrt)]), logTrace);
                            LibelleErr := rs_ErreurDateMagasin;
                          end
                          else
                          begin
                            FLogs.Log(rs_LibDecalage + rs_NoErreur, logTrace);
                            FStepProgress := rs_StepExportMagasin;
                            Synchronize(ProgressStepEtapes);
                            try
                              Transaction.StartTransaction();
                              NbLigneExport := DoExport(Connexion, Transaction, Magasin, GetDateMagasin(Magasin.Code), ZipFicName);
                              case NbLigneExport of
                                0 :
                                  begin
                                    FLogs.Log(rs_LibDecalage + rs_ErreurExportDone + ', ' + rs_ErreurNoData, logTrace);
                                    LibelleErr := rs_ErreurNoData;
                                  end;
                                else
                                  begin
                                    if NbLigneExport > 0 then
                                      FLogs.Log(rs_LibDecalage + rs_ErreurExportDone + ', ' + IntToStr(NbLigneExport) + rs_ErreurExportOK, logTrace)
                                    else
                                      raise Exception.Create(Format(rs_ExceptionExport, [NbLigneExport]));
                                  end;
                              end;
                              Transaction.Commit();
                            except
                              on e : Exception do
                              begin
                                Transaction.Rollback();
                                MagOk := eri_KO;
                                FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                                LibelleErr := e.Message;
                              end;
                            end;

                            if (MagOk = eri_OK) then
{$REGION '                            Envoie FTP '}
                            begin
                              FStepProgress := rs_StepSendFileFTP;
                              Synchronize(ProgressStepEtapes);
                              try
                                if FileExists(ZipFicName) then
                                begin
                                  if not SendFileFTP(ZipFicName) then
                                    raise Exception.Create(rs_ExceptionFtpSend);
                                end
                                else
                                  Flogs.Log(rs_ErreurNoFileToSend, logTrace);
                              except
                                on e : Exception do
                                begin
                                  MagOk := eri_KO;
                                  FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                                  LibelleErr := e.Message;
                                end;
                              end;
                            end;
{$ENDREGION}

                            if (MagOk = eri_OK) then
{$REGION '                            Validation des données exportées '}
                            begin
                              FStepProgress := rs_StepValideMagasin;
                              Synchronize(ProgressStepEtapes);
                              try
                                Transaction.StartTransaction();
                                if not DoValidation(Connexion, Transaction, Magasin, FDateValide) then
                                  raise Exception.Create(rs_ExceptionValidation);
                                Transaction.Commit();
                              except
                                on e : Exception do
                                begin
                                  Transaction.Rollback();
                                  MagOk := eri_KO;
                                  FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                                  LibelleErr := e.Message;
                                end;
                              end;
                            end;
{$ENDREGION}
                          end;
                        end;
{$ENDREGION}
                      except
                        on e : Exception do
                        begin
                          MagOk := eri_KO;
                          ReturnValue := Min(ReturnValue, -5);
                          FLogs.Log(Format(rs_ExceptionMagasin, [Dossier.Code, Dossier.Nom, Magasin.Code, Magasin.Nom, e.ClassName, e.Message]), logError);
                          LibelleErr := Format(rs_ExceptionMagasin, [Dossier.Code, Dossier.Nom, Magasin.Code, Magasin.Nom, e.ClassName, e.Message]);
                        end;
                      end;
                    end
                    else
                      FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);

{$REGION '                    Ecriture du rapport '}
                    // recup des info de verifications
                    FStepProgress := rs_StepGetDateLastMvt;
                    Synchronize(ProgressStepEtapes);
                    try
                      Transaction.StartTransaction();
                      DateDernierMvt := GetDateDernierMvt(Connexion, Transaction, Magasin);
                      Transaction.Commit();
                    except
                      on e : Exception do
                      begin
                        Transaction.Rollback();
                        DateDernierMvt := 0;
                        FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                      end;
                    end;
                    FStepProgress := rs_StepGetCAPeriode;
                    Synchronize(ProgressStepEtapes);
                    try
                      Transaction.StartTransaction();
                      CAPeriode := GetCAPeriode(Connexion, Transaction, Magasin);
                      Transaction.Commit();
                    except
                      on e : Exception do
                      begin
                        Transaction.Rollback();
                        CAPeriode := 0;
                        FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                      end;
                    end;

                    // pas de mouvement ??
                    if (DateDernierMvt = 0) and (NbLigneExport = 0) and (Trim(LibelleErr) = '') then
                      LibelleErr := rs_ErreurNoData;

                    // enreg du rapport !!!
                    FStepProgress := rs_StepWriteRapport;
                    Synchronize(ProgressStepEtapes);
                    WriteLineRapport(FRapFileDelta, Dossier, Magasin, NbLigneExport, DateDernierMvt, CAPeriode, FicOk and (DosOk = eri_OK) and (MagOk = eri_OK), LibelleErr);
{$ENDREGION}

                    // Ok ?
                    if (MagOk = eri_KO) then
                      ReturnValue := Min(ReturnValue, -1);
                  end
                  else
                    FLogs.Log(rs_ErreurMagasinInactif, logtrace);
                  // progression
                  Synchronize(FMagProgress.StepIt);
                end;
              finally
                FreeAndNil(Transaction);
                FreeAndNil(Connexion);
              end;
            finally
{$REGION '              Liberation du jeton '}
              if Assigned(Token) then
              begin
                FStepProgress := rs_StepFreeJeton;
                Synchronize(ProgressStepEtapes);
                FreeAndNil(Token); // Libération du jeton
              end;
{$ENDREGION}
            end;
          except
            on e : Exception do
            begin
              ReturnValue := Min(ReturnValue, -5);
              WriteLineRapport(FRapFileDelta, Dossier, Magasin, NbLigneExport, DateDernierMvt, CAPeriode, false, Format(rs_ExceptionDossier , [Dossier.Code, Dossier.Nom, e.ClassName, e.Message]));
              FLogs.Log(Format(rs_ExceptionDossier , [Dossier.Code, Dossier.Nom, e.ClassName, e.Message]), logError);
            end;
          end;
          // Ok ?
          if (DosOk = eri_KO) then
            ReturnValue := Min(ReturnValue, -2);
        end
        else
          FLogs.Log(rs_ErreurDossierInactif, logTrace);
        // progression
        Synchronize(FDosProgress.StepIt);
      end;

      // Gestion du mail...
      if (ett_MailSend in FWhatToDo) then
      begin
        try
          if ReadIniMail(Server, Username, Password, Sender, Port, Securite, Destinataire) then
          begin
            SendMail(Server, Port, Username, DecryptPasswd(Password), Securite,
                     Sender, Destinataire, 'Suivi BI Intersport - Delta', Format(IfThen(ReturnValue = 0, CST_EMAIL_REUSSIT, CST_EMAIL_ECHEC), [ServeurName]), FRapFileDelta);
          end;
        finally
          FreeAndNil(Destinataire);
        end;
      end;

      //======================================
      // Y a t'il des initialisation a faire ?
      if HasInit then
      begin
        FLogs.Log(rs_TraceSeparateur, logTrace);
        FLogs.Log(rs_TraceGestionInit, logTrace);

        try
          AssignFile(FichierRapport, FRapFileInit);
          Rewrite(FichierRapport);
          Writeln(FichierRapport, Format(rs_EnteteFile, [FNbJourVerifCA]));
        finally
          CloseFile(FichierRapport);
        end;

        // progression
        FNbMaxItem := FListe.Count;
        Synchronize(InitProgressDossier);

        //=====================
        // Pour chaque dossiers
        for Dossier in FListe.Keys do
        begin
          // mais pourquoi ????
          if not Assigned(Dossier) then
            Continue;

          // progression
          FNbMaxItem := FListe[Dossier].Count;
          Synchronize(InitProgressMagasin);
          // label
          FStepProgress := Format(rs_CaptionDossier, [Dossier.Code, Dossier.Nom]);
          Synchronize(ProgressStepDosMag);

          if Dossier.Actif then
          begin
            if FicOk then
            begin
              DosOk := eri_OK;
              LibelleErr := '';
              // gestion des dossier desactivé !
              if not Dossier.Actif then
              begin
                DosOk := eri_NothingToDO;
                LibelleErr := rs_ErreurDossierInactif;
              end;
            end
            else
              DosOk := eri_NothingToDO;
            Magasin := nil;
            NbLigneExport := 0;
            DateDernierMvt := 0;
            CAPeriode := 0;

            try
              try
                if FUseJeton then
{$REGION '                Prise du jeton '}
                begin
                  FLogs.Log('Prise du jeton...', logTrace);
                  try
                    tpJeton := GetParamsToken(Dossier.Serveur, Dossier.FileName, CST_LOGIN_BASE, CST_PASSWORD_BASE);
                    Token := TTokenManager.Create();
                    Token.tryGetToken(StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]), tpJeton.sDatabaseWS, tpJeton.sSenderWS, CST_JETON_TENTATIVE, CST_JETON_DELAI);
                    if not Token.Acquired then // Jeton non acquis
                    begin
                      case Token.Reason of
                        TOKEN_OK            : raise Exception.Create(rs_ExceptionJetonOK);
                        TOKEN_OQP           : raise Exception.Create(rs_ExceptionJetonOQP);
                        TOKEN_ERR_CNX       : raise Exception.Create(rs_ExceptionJetonCNX);
                        TOKEN_ERR_PRM       : raise Exception.Create(rs_ExceptionJetonPRM);
                        TOKEN_ERR_HTTP      : raise Exception.Create(rs_ExceptionJetonHTTP);
                        TOKEN_ERR_INTERNAL  : raise Exception.Create(rs_ExceptionJetonINTERNAL);
                        TOKEN_ABORTED       : raise Exception.Create(rs_ExceptionJetonABORTED);
                        TOKEN_NEVER         : raise Exception.Create(rs_ExceptionJetonNEVER);
                        else                  raise Exception.Create(Format(rs_ExceptionJetonOTHER, [Token.Reason]));
                      end;
                    end;
                  except
                    on e : Exception do
                    begin
                      DosOk := eri_KO;
                      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                      LibelleErr := e.Message;
                    end;
                  end;
                end;
{$ENDREGION}

                try
                  // Connexion base de données
                  Connexion := GetNewConnexion(Dossier.Serveur, Dossier.FileName, CST_LOGIN_BASE, CST_PASSWORD_BASE, false);
                  Connexion.FetchOptions.Unidirectional := true;
                  Connexion.Open();
                  Transaction := GetNewTransaction(Connexion, false);

                  //=====================
                  // Pour chaque magasins
                  for Magasin in FListe[Dossier].List do
                  begin
                    // mais pourquoi ????
                    if not Assigned(Magasin) then
                      Continue;

                    // label
                    FStepProgress := Format(rs_CaptionMagasin, [Magasin.Code, Magasin.Nom, Dossier.Code, Dossier.Nom]);
                    Synchronize(ProgressStepDosMag);

                    if magasin.Actif then
                    begin
                      if FicOk and (DosOk = eri_OK) then
                      begin
                        MagOk := eri_OK;
                        LibelleErr := '';
                      end
                      else
                        MagOk := eri_NothingToDO;
                      NbLigneExport := 0;
                      DateDernierMvt := 0;
                      CAPeriode := 0;
                      ZipFicName := FRepDestination + 'Trans_' + StringReplace(Magasin.Code, '/', '_', [rfReplaceAll]) + '_' + Magasin.Dossier.Code + '.zip';

                      // doit on faire une init ?
                      if not Magasin.IsInit then
                      begin
                        if FicOk and (DosOk = eri_OK) and (MagOk = eri_OK) then
                        begin
                          try
{$REGION '                            Exports des données magasins '}
                            if Trim(Magasin.Code) = '' then
                            begin
                              MagOk := eri_KO;
                              FLogs.Log(rs_LibDecalage + rs_ErreurNoCodeAdh, logTrace);
                              LibelleErr := rs_ErreurNoCodeAdh;
                            end
                            else
                            begin
                              FLogs.Log(rs_StepAskDoExport, logTrace);
                              if (GetDateMagasin(Magasin.Code) <= Magasin.DateDrnTrt) then
                              begin
                                MagOk := eri_KO;
                                FLogs.Log(rs_LibDecalage + rs_HasErreur + ' ' + rs_ErreurDateMagasin, logTrace);
                                FLogs.Log(rs_LibDecalage + Format(rs_ErreurDateMagasinDetail, [FormatDateTime('yyyy-mm-dd', GetDateMagasin(Magasin.Code)), FormatDateTime('yyyy-mm-dd', Magasin.DateDrnTrt)]), logTrace);
                                LibelleErr := rs_ErreurDateMagasin;
                              end
                              else
                              begin
                                FLogs.Log(rs_LibDecalage + rs_NoErreur, logTrace);
                                FStepProgress := rs_StepExportMagasin;
                                Synchronize(ProgressStepEtapes);
                                try
                                  Transaction.StartTransaction();
                                  NbLigneExport := DoExport(Connexion, Transaction, Magasin, GetDateMagasin(Magasin.Code), ZipFicName);
                                  case NbLigneExport of
                                    0 :
                                      begin
                                        FLogs.Log(rs_LibDecalage + rs_ErreurExportDone + ', ' + rs_ErreurNoData, logTrace);
                                        LibelleErr := rs_ErreurNoData;
                                      end;
                                    else
                                      begin
                                        if NbLigneExport > 0 then
                                          FLogs.Log(rs_LibDecalage + rs_ErreurExportDone + ', ' + IntToStr(NbLigneExport) + rs_ErreurExportOK, logTrace)
                                        else
                                          raise Exception.Create(Format(rs_ExceptionExport, [NbLigneExport]));
                                      end;
                                  end;
                                  Transaction.Commit();
                                except
                                  on e : Exception do
                                  begin
                                    Transaction.Rollback();
                                    MagOk := eri_KO;
                                    FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                                    LibelleErr := e.Message;
                                  end;
                                end;

                                if (MagOk = eri_OK) then
{$REGION '                                Envoie FTP '}
                                begin
                                  FStepProgress := rs_StepValideMagasin;
                                  Synchronize(ProgressStepEtapes);
                                  try
                                    if FileExists(ZipFicName) then
                                    begin
                                      if not SendFileFTP(ZipFicName) then
                                        raise Exception.Create(rs_ExceptionFtpSend);
                                    end
                                    else
                                      Flogs.Log(rs_ErreurNoFileToSend, logTrace);
                                  except
                                    on e : Exception do
                                    begin
                                      Transaction.Rollback();
                                      MagOk := eri_KO;
                                      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                                      LibelleErr := e.Message;
                                    end;
                                  end;
                                end;
{$ENDREGION}

                                if (MagOk = eri_OK) then
{$REGION '                                Validation des données exportées '}
                                begin
                                  FStepProgress := rs_StepValideMagasin;
                                  Synchronize(ProgressStepEtapes);
                                  try
                                    Transaction.StartTransaction();
                                    if not DoValidation(Connexion, Transaction, Magasin, FDateValide) then
                                      raise Exception.Create(rs_ExceptionValidation);
                                    Transaction.Commit();
                                  except
                                    on e : Exception do
                                    begin
                                      Transaction.Rollback();
                                      MagOk := eri_KO;
                                      FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                                      LibelleErr := e.Message;
                                    end;
                                  end;
                                end;
{$ENDREGION}
                              end;
                            end;
{$ENDREGION}
                          except
                            on e : Exception do
                            begin
                              MagOk := eri_KO;
                              ReturnValue := Min(ReturnValue, -5);
                              FLogs.Log(Format(rs_ExceptionMagasin, [Dossier.Code, Dossier.Nom, Magasin.Code, Magasin.Nom, e.ClassName, e.Message]), logError);
                              LibelleErr := Format(rs_ExceptionMagasin, [Dossier.Code, Dossier.Nom, Magasin.Code, Magasin.Nom, e.ClassName, e.Message]);
                            end;
                          end;
                        end
                        else
                          FLogs.Log(rs_LibDecalage + Format(rs_AlreadyError, [LibelleErr]), logTrace);

{$REGION '                        Ecriture du rapport '}
                        // recup des info de verifications
                        FStepProgress := rs_StepGetDateLastMvt;
                        Synchronize(ProgressStepEtapes);
                        try
                          Transaction.StartTransaction();
                          DateDernierMvt := GetDateDernierMvt(Connexion, Transaction, Magasin);
                          Transaction.Commit();
                        except
                          on e : Exception do
                          begin
                            Transaction.Rollback();
                            DateDernierMvt := 0;
                            FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                          end;
                        end;
                        FStepProgress := rs_StepGetCAPeriode;
                        Synchronize(ProgressStepEtapes);
                        try
                          Transaction.StartTransaction();
                          CAPeriode := GetCAPeriode(Connexion, Transaction, Magasin);
                          Transaction.Commit();
                        except
                          on e : Exception do
                          begin
                            Transaction.Rollback();
                            CAPeriode := 0;
                            FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logDebug);
                          end;
                        end;

                        // pas de mouvement ??
                        if (DateDernierMvt = 0) and (NbLigneExport = 0) and (Trim(LibelleErr) = '') then
                          LibelleErr := rs_ErreurNoData;

                        // enreg du rapport !!!
                        FStepProgress := rs_StepWriteRapport;
                        Synchronize(ProgressStepEtapes);
                        WriteLineRapport(FRapFileInit, Dossier, Magasin, NbLigneExport, DateDernierMvt, CAPeriode, FicOk and (DosOk = eri_OK) and (MagOk = eri_OK), LibelleErr);
{$ENDREGION}
                      end;
                      // Ok ?
                      if (MagOk = eri_KO) then
                        ReturnValue := Min(ReturnValue, -1);
                    end
                    else
                      FLogs.Log(rs_ErreurMagasinInactif, logTrace);
                    // progression
                    Synchronize(FMagProgress.StepIt);
                  end;
                finally
                  FreeAndNil(Transaction);
                  FreeAndNil(Connexion);
                end;
              finally
{$REGION '                Liberation du jeton '}
                if Assigned(Token) then
                begin
                  FStepProgress := rs_StepFreeJeton;
                  Synchronize(ProgressStepEtapes);
                  FreeAndNil(Token); // Libération du jeton
                end;
{$ENDREGION}
              end;
            except
              on e : Exception do
              begin
                DosOk := eri_KO;
                ReturnValue := Min(ReturnValue, -5);
                if (ett_Exports in FWhatToDo) then
                  WriteLineRapport(FRapFileInit, Dossier, Magasin, NbLigneExport, DateDernierMvt, CAPeriode, false, Format(rs_ExceptionDossier , [Dossier.Code, Dossier.Nom, e.ClassName, e.Message]));
                FLogs.Log(Format(rs_ExceptionDossier , [Dossier.Code, Dossier.Nom, e.ClassName, e.Message]), logError);
              end;
            end;
            // Ok ?
            if (DosOk = eri_KO) then
              ReturnValue := Min(ReturnValue, -2);
          end
          else
            FLogs.Log(rs_ErreurDossierInactif, logTrace);
          // progression
          Synchronize(FDosProgress.StepIt);
        end;

        // Gestion du mail...
        if (ett_MailSend in FWhatToDo) then
        begin
          try
            if ReadIniMail(Server, Username, Password, Sender, Port, Securite, Destinataire) then
            begin
              SendMail(Server, Port, Username, DecryptPasswd(Password), Securite,
                       Sender, Destinataire, 'Suivi BI Intersport - Init', Format(IfThen(ReturnValue = 0, CST_EMAIL_REUSSIT, CST_EMAIL_ECHEC), [ServeurName]), FRapFileInit);
            end;
          finally
            FreeAndNil(Destinataire);
          end;
        end;
      end;
    except
      on e : Exception do
      begin
        ReturnValue := Min(ReturnValue, -5);
        FLogs.Log(Format(rs_ExceptionBase, [e.ClassName, e.Message]), logError);
      end;
    end;
    FLogs.Log('', logTrace);
    FLogs.Log(rs_TraceEndOfThread, logTrace);
    FLogs.Log('', logTrace);
  finally
    CoUninitialize();
  end;
end;

end.

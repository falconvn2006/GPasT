unit Easycomptage_dm;

interface

uses
  SysUtils, Classes, DB, IBODataset, IB_Components,Variants,
  Main_Dm, uDefs, DateUtils,Forms, Math, Windows;

type
  TDm_EasyComptage = class(TDataModule)
    Que_GenParam: TIBOQuery;
    IbC_Config: TIB_Cursor;
    IbC_Temp: TIB_Cursor;

    procedure Que_GenParamAfterPost(DataSet: TDataSet);
    procedure Que_GenParamBeforeDelete(DataSet: TDataSet);
    procedure Que_GenParamBeforeEdit(DataSet: TDataSet);
    procedure Que_GenParamNewRecord(DataSet: TDataSet);
    procedure Que_GenParamUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
  
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Function IsParamExist(PRM_MAGID, PRM_TYPE, PRM_CODE : Integer) : Boolean;
    function GetConfig (PRM_MAGID : Integer) : TConfig;
    Function SaveConfigGENPARAM (PRM_MAGID : Integer) : Boolean;
    function SetTbFromTrancheList(Var tbTranche : TTrancheObList;dDateDebut,dDateFin : TDateTime;MAG_ID : integer) : Boolean;
    function IsDatabaseOpen : Boolean;
  end;

var
  Dm_EasyComptage: TDm_EasyComptage;

implementation

uses DlgStd_Frm;

{$R *.dfm}

function TDm_EasyComptage.GetConfig(PRM_MAGID : Integer): TConfig;
begin
  With Ibc_Config do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_STRING,PRM_FLOAT,PRM_INTEGER From GENPARAM');
    SQL.Add('join K on (K_ID = PRM_ID and K_Enabled = 1)');
    SQL.Add('Where PRM_MAGID = :PMagId');
    SQL.Add('and   PRM_TYPE = 3');
    SQL.Add('and   PRM_CODE = :PCode');
    ParamCheck := True;
    ParamByName('PMagId').AsInteger := PRM_MAGID;
    ParamByName('PCode').AsInteger  := 10200;
    Open;

    // récupération du répertoire de destination du fichier
    Result.DestPath := FieldByName('PRM_STRING').AsString;
    // Récupération du nombre de jours à garder avant suppression
    Result.Jours    := FieldByName('PRM_FLOAT').AsInteger;


    Close;
    ParamCheck := True;
    ParamByName('PMagId').AsInteger := PRM_MAGID;
    ParamByName('PCode').AsInteger  := 10201;
    Open;

    // récupération de la périodicité
    // -1 pour que la valeur corresponde avec le ItemIndex du rzRadioGroup
    Result.Periodicite := FieldByName('PRM_INTEGER').AsInteger - 1;
    Result.Heure       := 0;
    Result.Minutes     := 0;
    case Result.Periodicite of
      // Si périodicité 1 fois par jour
      0: Result.Heure   := StrToTime(FieldByName('PRM_STRING').AsString);
      // Si périodicité x fois par jour
      1: Result.Minutes := FieldByName('PRM_FLOAT').AsInteger;
    end;

    Close;

    // Récupère le paramètre de démarrage auto
    ParamByName('PMagId').AsInteger := PRM_MAGID;
    ParamByName('PCode').AsInteger  := 10202;
    Open();
    if RecordCount > 0 then
    begin
      Result.bDemarrageAuto   := (FieldByName('PRM_INTEGER').AsInteger = 1);
      Result.tHeureDemarrage  := FieldByName('PRM_FLOAT').AsFloat;
    end;
    Close();

    // Récupère le paramètre d'arrêt auto
    ParamByName('PMagId').AsInteger := PRM_MAGID;
    ParamByName('PCode').AsInteger  := 10203;
    Open();

    if RecordCount > 0 then
    begin
      Result.bArretAuto       := (FieldByName('PRM_INTEGER').AsInteger = 1);
      Result.tHeureArret      := FieldByName('PRM_FLOAT').AsFloat;
    end;
    Close();
  end;
end;

function TDm_EasyComptage.IsDatabaseOpen: Boolean;
begin
  Result := True;
  With Dm_Main do
  try
    if not Database.Connected then
      Database.Connect;
  Except on E:Exception do
    Result := False;
  end;
end;

function TDm_EasyComptage.IsParamExist(PRM_MAGID, PRM_TYPE,
  PRM_CODE: Integer): Boolean;
begin
  With Ibc_Config do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select count(PRM_ID) as Resultat From GenParam');
    SQL.Add('join k on (K_Id = PRM_ID and k_enabled = 1)');
    SQL.Add('Where PRM_MAGID = :PMagID');
    SQL.Add('and   PRM_TYPE  = :PType');
    SQL.Add('and   PRM_CODE  = :PCode');
    ParamCheck := True;
    ParamByName('PMagID').AsInteger := PRM_MAGID;
    ParamByName('PType').AsInteger  := PRM_TYPE;
    ParamByName('PCode').AsInteger  := PRM_CODE;
    Open;

    Result := (FieldByName('Resultat').AsInteger <> 0);
  end;
end;

procedure TDm_EasyComptage.Que_GenParamAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_EasyComptage.Que_GenParamBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete ( ( DataSet As TIBODataSet).KeyRelation,
  DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
  True ) then Abort;
end;

procedure TDm_EasyComptage.Que_GenParamBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit ( ( DataSet As TIBODataSet).KeyRelation,
  DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
  True ) then Abort;
end;

procedure TDm_EasyComptage.Que_GenParamNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_EasyComptage.Que_GenParamUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

function TDm_EasyComptage.SaveConfigGENPARAM(PRM_MAGID: Integer): Boolean;
begin
  Result := False;
  With Que_GenParam do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PMagId').AsInteger := PRM_MAGID;
    Open;

    Try
      if Locate('PRM_TYPE;PRM_CODE',VarArrayOf([3,10200]),[loCaseInsensitive]) then
      begin
        Edit;

        FieldByName('PRM_STRING').AsString := GCONFIGAPP.DestPath;
        FieldByName('PRM_FLOAT').AsInteger := GCONFIGAPP.Jours;

        Post;
      end
      else begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10200 : Le paramètre n''existe pas dans la base.', True, 0, 0 , 'Erreur 10200');
        Exit;
      end;
    Except on E:Exception do
      begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10200 :' + E.Message,True,0,0,'Erreur 10200');
        Exit;
      end;
    end; // try

    Try
      if Locate('PRM_TYPE;PRM_CODE',VarArrayOf([3,10201]),[loCaseInsensitive]) then
      begin
        Edit;
        // Ajout de +1 pour que dans la base de données on voit 1 et 2
        // car la groupbox retourne 0 et 1
        FieldByName('PRM_INTEGER').AsInteger := GCONFIGAPP.Periodicite + 1;

        case GCONFIGAPP.Periodicite of
          0: begin
            FieldByName('PRM_STRING').AsString := FormatDateTime('hh:mm',GCONFIGAPP.Heure);
            FieldByName('PRM_FLOAT').AsInteger := 0;
          end;
          1: begin
            FieldByName('PRM_FLOAT').AsInteger := GCONFIGAPP.Minutes;
            FieldByName('PRM_STRING').AsString := '00:00';
          end;
        end; // case
        Post;
      end
      else begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10201 : Le paramètre n''existe pas dans la base.', True, 0, 0 , 'Erreur 10201');
        Exit;
      end;
    Except on E:Exception do
      begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10201 :' + E.Message,True,0,0,'Erreur 10201');
        Exit;
      end;
    end; // Try


    // Enregistrement des paramètres de démarrage auto
    try
      if Locate('PRM_TYPE;PRM_CODE,PRM_MAGID', VarArrayOf([3, 10202, PRM_MAGID]), []) then
      begin
        Edit();
        FieldByName('PRM_FLOAT').AsFloat      := TimeOf(GCONFIGAPP.tHeureDemarrage);
        FieldByName('PRM_INTEGER').AsInteger  := IfThen(GCONFIGAPP.bDemarrageAuto, 1, 0);
        Post();
      end
      else begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10202 : Le paramètre n''existe pas dans la base.', True, 0, 0, 'Erreur 10202');
        Exit;
      end;
    except
      on E: Exception do
      begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10202 :' + E.Message, True, 0, 0, 'Erreur 10202');
        Exit;
      end;
    end;

    // Enregistrement des paramètres d'arrêt auto
    try
      if Locate('PRM_TYPE;PRM_CODE,PRM_MAGID', VarArrayOf([3, 10203, PRM_MAGID]), []) then
      begin
        Edit();
        FieldByName('PRM_FLOAT').AsFloat      := TimeOf(GCONFIGAPP.tHeureArret);
        FieldByName('PRM_INTEGER').AsInteger  := IfThen(GCONFIGAPP.bArretAuto, 1, 0);
        Post();
      end
      else begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10203 : Le paramètre n''existe pas dans la base.', True, 0, 0, 'Erreur 10203');
        Exit;
      end;
    except
      on E: Exception do
      begin
        InfoMessHP('Erreur lors de l''enregistrement des données 10203 :' + E.Message,True, 0, 0, 'Erreur 10203');
        Exit;
      end;
    end;

  end; // With
  Result := True;
end;

function TDm_EasyComptage.SetTbFromTrancheList(var tbTranche: TTrancheObList;
  dDateDebut, dDateFin: TDateTime; MAG_ID: integer): Boolean;
var
  PeriodeTranche : TPeriodeTranche;
  sCodeAdh : String;
  dDateEnCours : TDateTime;
  iTrancheEnCours : Integer;
begin
  Result := True;
  try
    // récupération du code Adherent du magasin
    With IbC_Temp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select MAG_CODEADH From GENMAGASIN');
      SQL.Add('Where MAG_ID = :PMagId');
      ParamCheck := True;
      ParamByName('PMagId').AsInteger := MAG_ID;
      Open;

      sCodeAdh := FieldByName('MAG_CODEADH').AsString;
    end;

    dDateEnCours := dDateDebut;

    while dDateEnCours <= dDateFin do
    begin
      iTrancheEnCours := CalculTranche(dDateEnCours);
      tbTranche.Add(TExportFile.Create);

      With IbC_Temp do
      begin
        PeriodeTranche := CalculPeriode(dDateEnCours,iTrancheEnCours);
        // récupération du nombre de tickets
        Close;
        SQL.Clear;
        SQL.Add('SELECT COUNT(*) AS RESULTAT');
        SQL.Add('FROM CSHTICKET');
        SQL.Add('  JOIN K KTKE ON (KTKE.K_ID = TKE_ID AND KTKE.K_ENABLED = 1)');
        SQL.Add('  JOIN CSHSESSION ON (SES_ID = TKE_SESID)');
        SQL.Add('  JOIN GENPOSTE ON (SES_POSID = POS_ID)');
        SQL.Add('WHERE POS_MAGID = :PMAGID');
        SQL.Add('  AND KTKE.K_UPDATED BETWEEN :PDEBUT AND :PFIN');   
        SQL.Add('  AND KTKE.K_UPDATED <= (TKE_DATE + (14.0 / 24.0))');
        ParamCheck := True;
        ParamByName('PMagId').AsInteger  := MAG_ID;
        ParamByName('PDebut').AsDateTime := PeriodeTranche.dDateDebut;
        ParamByName('PFin').AsDateTime   := PeriodeTranche.dDateFin;
        Open;

        tbTranche[tbTranche.Count -1].sCodePDV := sCodeAdh;
        tbTranche[tbTranche.Count -1].iNTranche := iTrancheEnCours;
        tbTranche[tbTranche.Count -1].sDateJour := FormatDateTime('YYYYMMDD',dDateEnCours);
        tbTranche[tbTranche.Count -1].iNbTickets := FieldByName('Resultat').AsInteger;

        // récupération du CA sans les bons d'achats
        Close;
        SQL.Clear;
        SQL.Add('SELECT SUM(TKL_PXNN * TKL_QTE) AS RESULTAT');
        SQL.Add('FROM CSHTICKETL');
        SQL.Add('  JOIN K KTKL ON (KTKL.K_ID = TKL_ID AND KTKL.K_ENABLED = 1)');
        SQL.Add('  JOIN CSHTICKET ON (TKE_ID = TKL_TKEID)');
        SQL.Add('  JOIN K KTKE ON (KTKE.K_ID = TKE_ID AND KTKE.K_ENABLED = 1)');
        SQL.Add('  JOIN CSHSESSION ON (SES_ID = TKE_SESID)');
        SQL.Add('  JOIN K KSES ON (KSES.K_ID = SES_ID AND KSES.K_ENABLED = 1)');
        SQL.Add('  JOIN GENPOSTE ON (SES_POSID = POS_ID)');
        SQL.Add('WHERE POS_MAGID = :PMAGID');
        SQL.Add('  AND KTKE.K_UPDATED BETWEEN :PDEBUT AND :PFIN');   
        SQL.Add('  AND KTKE.K_UPDATED <= (TKE_DATE + (14.0 / 24.0))');
        ParamCheck := True;
        ParamByName('PMagId').AsInteger  := MAG_ID;
        ParamByName('PDebut').AsDateTime := PeriodeTranche.dDateDebut;
        ParamByName('PFin').AsDateTime   := PeriodeTranche.dDateFin;
        Open;
        if FieldByName('Resultat').IsNotNull then
          tbTranche[tbTranche.Count -1].fCA := FieldByName('Resultat').AsCurrency
        else
          tbTranche[tbTranche.Count -1].fCA := 0;

        // récupération du nombre de vendeur
        Close;
        SQL.Clear;
        SQL.Add('SELECT DISTINCT(TKL_USRID)');
        SQL.Add('FROM CSHTICKETL');
        SQL.Add('  JOIN K KTKL ON (KTKL.K_ID = TKL_ID AND KTKL.K_ENABLED = 1)');
        SQL.Add('  JOIN CSHTICKET ON (TKE_ID = TKL_TKEID)');
        SQL.Add('  JOIN K KTKE ON (KTKE.K_ID = TKE_ID AND KTKE.K_ENABLED = 1)');
        SQL.Add('  JOIN CSHSESSION ON (SES_ID = TKE_SESID)');
        SQL.Add('  JOIN GENPOSTE ON (SES_POSID = POS_ID)');
        SQL.Add('WHERE POS_MAGID = :PMAGID');
        SQL.Add('  AND KTKE.K_UPDATED BETWEEN :PDEBUT AND :PFIN');
        SQL.Add('  AND KTKE.K_UPDATED <= (TKE_DATE + (14.0 / 24.0))');
        ParamCheck := True;
        ParamByName('PMagId').AsInteger  := MAG_ID;
        ParamByName('Pdebut').AsDateTime := PeriodeTranche.dDateDebut;
        ParamByName('Pfin').AsDateTime   := PeriodeTranche.dDateFin;
        Open;

        tbTranche[tbTranche.Count -1].iNbVendeur := 0;
        while not EOF do
        begin
          inc(tbTranche[tbTranche.Count -1].iNbVendeur);
          Next;
        end;
      end; // with

      OutputDebugString(PChar(Format('Export de la tranche %d du %s terminé.',
        [iTrancheEnCours, FormatDateTime('dd/mm/yyyy hh:nn', dDateEnCours)])));

      dDateEnCours := IncMinute(dDateEnCours,15);

      Application.processMessages;
    end; // While
  Except on E:Exception do
    begin
      Dm_Main.Database.Disconnect;
      Result := False;
    end;
  end;
end;

end.


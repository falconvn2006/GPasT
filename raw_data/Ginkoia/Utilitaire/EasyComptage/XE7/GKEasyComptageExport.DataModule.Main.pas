unit GKEasyComptageExport.DataModule.Main;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.DateUtils,
  Data.DB,
  Vcl.Forms,
  Vcl.ExtCtrls,
  FireDAC.Phys.IBDef,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.IB,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  UMapping,
  GKEasyComptageExport.Ressources,
  GKEasyComptageExport.Methodes,
  GKEasyComptageExport.Thread.Connexion,
  GKEasyComptageExport.Thread.Traitement;

type
  TDataModuleMain = class(TDataModule)
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    FDConnection: TFDConnection;
    QueIni: TFDQuery;
    QueParam: TFDQuery;
    TimArretAuto: TTimer;
    TimTraitement: TTimer;
    QueModule: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    QueNbTickets: TFDQuery;
    QueChiffreAffaire: TFDQuery;
    QueNbVendeurs: TFDQuery;
    QueCodeAdherant: TFDQuery;
    StrProcPrUpdateK: TFDStoredProc;
    QueIniPOS_ID: TIntegerField;
    QueIniPOS_NOM: TStringField;
    QueIniPOS_INFO: TStringField;
    QueIniPOS_MAGID: TIntegerField;
    QueIniPOS_COMPTA: TStringField;
    QueIniMAG_NOM: TStringField;
    QueIniMAG_ENSEIGNE: TStringField;
    QueIniMAG_ID: TIntegerField;
    QueIniMAG_TVTID: TIntegerField;
    QueIniSOC_NOM: TStringField;
    QueIniSOC_ID: TIntegerField;
    QueIniMAG_MTAID: TIntegerField;
    QueIniMAG_CODEADH: TStringField;
    QueParamPRM_ID: TIntegerField;
    QueParamPRM_STRING: TStringField;
    QueParamPRM_FLOAT: TFloatField;
    QueParamPRM_INTEGER: TIntegerField;
    QueModuleUGG_ID: TIntegerField;
    QueCodeAdherantMAG_CODEADH: TStringField;
    QueNbTicketsRESULTAT: TIntegerField;
    QueChiffreAffaireRESULTAT: TFloatField;
    QueNbVendeursRESULTAT: TIntegerField;
    TransMiseAJour: TFDTransaction;
    procedure TimTraitementTimer(Sender: TObject);
    procedure TimArretAutoTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnectionAfterDisconnect(Sender: TObject);
    procedure FDConnectionAfterConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FDateDebut      : TDateTime;
    FDateFin        : TDateTime;
    FMagId          : Integer;
  public
    { Déclarations publiques }
    FFermeture        : Boolean;
    ThreadConnexion   : TThreadConnexion;
    ThreadTraitement  : TThreadTraitement;
    function ParametreExiste(const AMagId, AType, ACode: Integer): Boolean;
    function RecupereMagId(const ANomPoste, ANomMag: string): Integer;
    function GetParamString(const AMagId, AType, ACode: Integer): String;
    function GetParamFloat(const AMagId, AType, ACode: Integer): Double;
    function GetParamInteger(const AMagId, AType, ACode: Integer): Integer;
    function SetGenParam(const AMagId, AType, ACode: Integer; const AString: string): Boolean; overload;
    function SetGenParam(const AMagId, AType, ACode: Integer; const AFloat: Double): Boolean; overload;
    function SetGenParam(const AMagId, AType, ACode: Integer; const AInteger: Integer): Boolean; overload;
    function AModule(const AMagId: Integer; const AModule: String): Boolean;
    procedure LancerTraitement(const ADateDebut, ADateFin: TDateTime; const AMagId: Integer);
    procedure FinThreadConnexion(Sender: TObject);
    procedure FinTraitement(Sender: TObject);
  end;

var
  DataModuleMain    : TDataModuleMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  GKEasyComptageExport.Form.Main;

{$R *.dfm}

{ TDataModuleMain }

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
  // Enregistre l'heure de lancement du programme
  HeureLancement  := Now();
  FFermeture      := False;
end;

procedure TDataModuleMain.DataModuleDestroy(Sender: TObject);
begin
  if FDConnection.Connected then
    FDConnection.Close();
end;

function TDataModuleMain.ParametreExiste(const AMagId, AType,
  ACode: Integer): Boolean;
begin
  Result := False;
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    Result := not(QueParam.IsEmpty);
  finally
    QueParam.Close();
  end;
end;

function TDataModuleMain.RecupereMagId(const ANomPoste,
  ANomMag: string): Integer;
begin
  Result := 0;
  try
    QueIni.ParamByName('NOMPOSTE').AsString       := ANomPoste;
    QueIni.ParamByName('NOMMAG').AsString         := ANomMag;
    QueIni.Open();

    if not(QueIni.IsEmpty) then
      Result := QueIni.FieldByName('MAG_ID').AsInteger;
  finally
    QueIni.Close();
  end;
end;

procedure TDataModuleMain.TimArretAutoTimer(Sender: TObject);
begin
  // Arrête le programme quand l'heure est passée
  if GCONFIGAPP.bArretAuto
    and (CompareTime(Time(), GCONFIGAPP.tHeureArret) = GreaterThanValue)
    and not(FindCmdLineSwitch('PARAM') and (MinutesBetween(HeureLancement, Now()) < 15)) then
  begin
    if Assigned(ThreadTraitement) then
    begin
      if not(ThreadTraitement.Finished) then
      begin
        FFermeture  := True;
        ThreadTraitement.Terminate();
      end
      else begin
        Application.Terminate();
      end;
    end
    else begin
      Application.Terminate();
    end;
  end;
end;

procedure TDataModuleMain.TimTraitementTimer(Sender: TObject);
var
  Periode: TPeriodeTranche;
begin
  // Vérifie que le traitement est bien à effectuer
  if CompareDateTime(GCONFIGAPP.dNextAction, Now()) = GreaterThanValue then
    Exit;

  if MapGinkoia.Backup
    or MapGinkoia.LiveUpdate
    or MapGinkoia.MajAuto
    or MapGinkoia.Script then
  begin
    Journaliser(RS_ERR_TRAITEMENT_QUIT, NivArret);
    Application.Terminate();
  end;

  // Désactive les traitements
  TimTraitement.Enabled           := False;
  FormMain.BtnParametrage.Enabled := False;
  FormMain.BtnQuitter.Enabled     := False;
  FormMain.LblProchain.Enabled    := False;
  FormMain.LblHeure.Enabled       := False;
  FormMain.TrayTache.IconIndex    := 1;

  // Configuration des dates pour le traitement
  case GCONFIGAPP.Periodicite of
    // Si périodicité 1 fois par jour
    0: begin
      Periode.dDateDebut  := StartOfTheDay(GCONFIGAPP.dNextAction);
      Periode.dDateFin    := RecodeMilliSecond(EndOfTheDay(GCONFIGAPP.dNextAction), 0);
    end;
    // Si périodicité x fois par jour
    1: begin
      Periode.dDateDebut  := IncMinute(GCONFIGAPP.dPrevAction, -15);
      Periode.dDateFin    := IncMinute(GCONFIGAPP.dNextAction, -15);
    end;
  end;

  // Démarre le thread du traitement
  LancerTraitement(Periode.dDateDebut, Periode.dDateFin, ParamsConnexion.MagId);
end;

function TDataModuleMain.GetParamString(const AMagId, AType,
  ACode: Integer): String;
begin
  Result := '';
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    if not(QueParam.IsEmpty) then
      Result := QueParam.FieldByName('PRM_STRING').AsString;
  finally
    QueParam.Close();
  end;
end;

function TDataModuleMain.GetParamFloat(const AMagId, AType,
  ACode: Integer): Double;
begin
  Result := 0;
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    if not(QueParam.IsEmpty) then
      Result := QueParam.FieldByName('PRM_FLOAT').AsFloat;
  finally
    QueParam.Close();
  end;
end;

function TDataModuleMain.GetParamInteger(const AMagId, AType,
  ACode: Integer): Integer;
begin
  Result := 0;
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    if not(QueParam.IsEmpty) then
      Result := QueParam.FieldByName('PRM_INTEGER').AsInteger;
  finally
    QueParam.Close();
  end;
end;

function TDataModuleMain.SetGenParam(const AMagId, AType, ACode: Integer; const AString: string): Boolean;
begin
  Result := False;
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    if not(QueParam.IsEmpty) then
    begin
      QueParam.Edit();
      QueParam.FieldByName('PRM_STRING').AsString           := AString;
      if QueParam.Modified then
        QueParam.Post()
      else
        QueParam.Cancel();
      StrProcPrUpdateK.ParamByName('K_ID').AsInteger        := QueParam.FieldByName('PRM_ID').AsInteger;
      StrProcPrUpdateK.ParamByName('SUPRESSION').AsInteger  := 0;
      StrProcPrUpdateK.ExecProc();
      Result := True;
    end;
  finally
    StrProcPrUpdateK.Close();
    QueParam.Close();
  end;
end;

function TDataModuleMain.SetGenParam(const AMagId, AType, ACode: Integer; const AFloat: Double): Boolean;
begin
  Result := False;
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    if not(QueParam.IsEmpty) then
    begin
      QueParam.Edit();
      QueParam.FieldByName('PRM_FLOAT').AsFloat             := AFloat;
      if QueParam.Modified then
        QueParam.Post()
      else
        QueParam.Cancel();
      StrProcPrUpdateK.ParamByName('K_ID').AsInteger        := QueParam.FieldByName('PRM_ID').AsInteger;
      StrProcPrUpdateK.ParamByName('SUPRESSION').AsInteger  := 0;
      StrProcPrUpdateK.ExecProc();
      Result := True;
    end;
  finally
    StrProcPrUpdateK.Close();
    QueParam.Close();
  end;
end;

function TDataModuleMain.SetGenParam(const AMagId, AType, ACode: Integer; const AInteger: Integer): Boolean;
begin
  Result := False;
  try
    QueParam.ParamByName('MAGID').AsInteger := AMagId;
    QueParam.ParamByName('TYPE').AsInteger  := AType;
    QueParam.ParamByName('CODE').AsInteger  := ACode;
    QueParam.Open();
    if not(QueParam.IsEmpty) then
    begin
      QueParam.Edit();
      QueParam.FieldByName('PRM_INTEGER').AsInteger         := AInteger;
      if QueParam.Modified then
        QueParam.Post()
      else
        QueParam.Cancel();
      StrProcPrUpdateK.ParamByName('K_ID').AsInteger        := QueParam.FieldByName('PRM_ID').AsInteger;
      StrProcPrUpdateK.ParamByName('SUPRESSION').AsInteger  := 0;
      StrProcPrUpdateK.ExecProc();
      Result := True;
    end;
  finally
    StrProcPrUpdateK.Close();
    QueParam.Close();
  end;
end;

function TDataModuleMain.AModule(const AMagId: Integer; const AModule: String): Boolean;
begin
  // Vérifie si le magasin a le module demandé
  Result := False;
  try
    QueModule.ParamByName('MAGID').AsInteger  := AMagId;
    QueModule.ParamByName('NOM').AsString     := AModule;
    QueModule.Open();

    Result := not(QueModule.IsEmpty);
  finally
    QueModule.Close();
  end;
end;

procedure TDataModuleMain.LancerTraitement(const ADateDebut, ADateFin: TDateTime; const AMagId: Integer);
var
  OblBoCaisse   : TOblBoCaisse;
  bTraitementOk : Boolean;
begin
  FDateDebut  := ADateDebut;
  FDateFin    := ADateFin;
  FMagId      := AMagId;

  // Vérifie que le thread n'est pas démarré
  if Assigned(ThreadConnexion) then
  begin
    if not(ThreadConnexion.Finished) then
      ThreadConnexion.Terminate();
  end;

  Journaliser(RS_INF_TH_CONNECT_D);
  ThreadConnexion                 := TThreadConnexion.Create(True);
  ThreadConnexion.FDConnection    := DataModuleMain.FDConnection;
  ThreadConnexion.ParamsConnexion := ParamsConnexion;
  ThreadConnexion.OnTerminate     := FinThreadConnexion;
  ThreadConnexion.FreeOnTerminate := True;
  ThreadConnexion.Start();
end;

procedure TDataModuleMain.FDConnectionAfterConnect(Sender: TObject);
begin
  FormMain.StbStatut.Panels[1].Text := RS_INF_CONNECTE;
end;

procedure TDataModuleMain.FDConnectionAfterDisconnect(Sender: TObject);
begin
  FormMain.StbStatut.Panels[1].Text := RS_INF_DECONNECTE;
end;

procedure TDataModuleMain.FinThreadConnexion(Sender: TObject);
var
  OblBoCaisse   : TOblBoCaisse;
  bTraitementOk : Boolean;
begin
  Journaliser(RS_INF_TH_CONNECT_F);

  if Assigned(ThreadTraitement) then
  begin
    if not(ThreadTraitement.Finished) then
    begin
      Exit;
    end;
  end;

  // Effectue le traitement pour ajouter les nouvelles lignes
  FormMain.StbStatut.Panels[0].Text     := Format(RS_INFO_TRAITEMENT,
    [FormatDateTime('DD/MM/YYYY hh:mm:ss', FDateDebut),
      FormatDateTime('DD/MM/YYYY hh:mm:ss', FDateFin), '', -1]);
  Journaliser(RS_INF_TH_TRAIT_D);
  ThreadTraitement                      := TThreadTraitement.Create(True);
  ThreadTraitement.Configuration        := GCONFIGAPP;
  ThreadTraitement.Fichier              := IncludeTrailingPathDelimiter(GCONFIGAPP.DestPath) + 'BoCaisse.txt';
  ThreadTraitement.DateDebut            := FDateDebut;
  ThreadTraitement.DateFin              := FDateFin;
  ThreadTraitement.EffacerDatesInf      := True;
  ThreadTraitement.MagId                := FMagId;
  ThreadTraitement.QueCodeAdherant      := @QueCodeAdherant;
  ThreadTraitement.QueNbTickets         := @QueNbTickets;
  ThreadTraitement.QueChiffreAffaire    := @QueChiffreAffaire;
  ThreadTraitement.QueNbVendeurs        := @QueNbVendeurs;
  ThreadTraitement.OnTerminate          := FinTraitement;
  ThreadTraitement.FreeOnTerminate      := True;
  ThreadTraitement.Start();
end;

procedure TDataModuleMain.FinTraitement(Sender: TObject);
begin
  Journaliser(RS_INF_TH_TRAIT_F);

  // Fermeture le la connexion à la base de données
  FDConnection.Close();

  // Ferme le programme au besoin
  if FFermeture then
    Application.Terminate();

  // Mise à jour des timers
  if TThreadTraitement(Sender).TraitementOk then
    Journaliser(RS_INF_TH_TRAIT_S)
  else
    Journaliser(RS_INF_TH_TRAIT_E);

  // Réactive les composants
  Journaliser(RS_INFO_TRAIT_TERMINE);
  Journaliser(Format(RS_INFO_TRAIT_PROCHAIN, [FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction)]));
  FormMain.LblHeure.Caption         := FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction);
  FormMain.StbStatut.Panels[0].Text := RS_INFO_TRAIT_TERMINE;
  TimTraitement.Enabled             := True;
  FormMain.BtnParametrage.Enabled   := True;
  FormMain.BtnQuitter.Enabled       := True;
  FormMain.LblProchain.Enabled      := True;
  FormMain.LblHeure.Enabled         := True;
  FormMain.TrayTache.IconIndex      := 0;
end;

end.

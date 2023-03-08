unit GKEasyComptage.DataModule.Main;

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
  GKEasyComptage.Ressources,
  GKEasyComptage.Methodes,
  GKEasyComptage.Thread.Traitement;

type
  TDataModuleMain = class(TDataModule)
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    FDConnection: TFDConnection;
    TimTraitement: TTimer;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    StrProcPrUpdateK: TFDStoredProc;
    TransMiseAJour: TFDTransaction;
    QueParam: TFDQuery;
    QueParamPRM_ID: TIntegerField;
    QueParamPRM_STRING: TStringField;
    QueParamPRM_FLOAT: TFloatField;
    QueParamPRM_INTEGER: TIntegerField;
    procedure TimTraitementTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnectionAfterDisconnect(Sender: TObject);
    procedure FDConnectionAfterConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDConnectionError(ASender: TObject;
      const AInitiator: IFDStanObject; var AException: Exception);
  private
    { Déclarations privées }
    // FMagId          : Integer;
  public
    { Déclarations publiques }
    FFermeture        : Boolean;
    // ThreadConnexion   : TThreadConnexion;
    ThreadTraitement  : TThreadTraitement;
    function ParametreExiste(const AMagId, AType, ACode: Integer): Boolean;
    function RecupereMagId(const ANomPoste, ANomMag: string): Integer;
    function RecupereMagCode(const AMagId: integer): string;
    function RecupereGUID(): string;
    function CodeAdh(const AMagId: Integer): string;
    function GetParamString(const AMagId, AType, ACode: Integer): String;
    function GetParamFloat(const AMagId, AType, ACode: Integer): Double;
    function GetParamInteger(const AMagId, AType, ACode: Integer): Integer;
    function SetGenParam(const AMagId, AType, ACode: Integer; const AString: string): Boolean; overload;
    function SetGenParam(const AMagId, AType, ACode: Integer; const AFloat: Double): Boolean; overload;
    function SetGenParam(const AMagId, AType, ACode: Integer; const AInteger: Integer): Boolean; overload;
    function AModule(const AMagId: Integer; const AModule: String): Boolean;
    procedure LancerTraitement();
    procedure FinTraitement(Sender: TObject);
  end;

var
  DataModuleMain    : TDataModuleMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  GKEasyComptage.Form.Main;

{$R *.dfm}

{ TDataModuleMain }

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
  // Enregistre l'heure de lancement du programme
  // HeureLancement  := Now();
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


function TDataModuleMain.AModule(const AMagId: Integer; const AModule: String): Boolean;
var IbQuery:TFDQuery;
begin
  Result := False;
  IbQuery:=TFDQuery.Create(Self);
  try
    IbQuery.Connection:=FDConnection;
    IbQuery.SQL.Clear;

    IbQuery.SQL.Add('SELECT UGG_ID');
    IbQuery.SQL.Add('FROM UILGRPGINKOIAMAG');
    IbQuery.SQL.Add('  JOIN K KUGM ON (K_ID = UGM_ID AND K_ENABLED = 1)');
    IbQuery.SQL.Add('  JOIN UILGRPGINKOIA ON (UGG_ID = UGM_UGGID)');
    IbQuery.SQL.Add('  JOIN K KUGG ON (K_ID = UGG_ID AND K_ENABLED = 1)');
    IbQuery.SQL.Add('WHERE UGG_ID <> 0');
    IbQuery.SQL.Add('  AND UGG_NOM = :NOM');
    IbQuery.SQL.Add('  AND UGM_MAGID = :MAGID;');

    IbQuery.ParamByName('MAGID').AsInteger  := AMagId;
    IbQuery.ParamByName('NOM').AsString     := AModule;
    IbQuery.Open();
    Result := not(IbQuery.IsEmpty);
  finally
    IbQuery.Close();
    IbQuery.Free;
  end;
end;

function TDataModuleMain.CodeAdh(const AMagId: Integer): string;
var IbQuery:TFDQuery;
begin
  Result := '';
  IbQuery:=TFDQuery.Create(Self);
  try
    IbQuery.Connection:=FDConnection;
    IbQuery.SQL.Clear;
    IbQuery.close();
    IbQuery.Sql.Clear;
    IbQuery.SQL.Add('SELECT MAG_CODEADH FROM GENMAGASIN WHERE MAG_ID = :MAGID');
    IbQuery.ParamByName('MAGID').AsInteger  := AMagId;
    IbQuery.Open();
    If not(IbQuery.IsEmpty)
      then
          result:=IbQuery.Fields[0].AsString;
  finally
    IbQuery.Close();
    IbQuery.Free;
  end;
end;


function TDataModuleMain.RecupereMagId(const ANomPoste, ANomMag: string): Integer;
var IbQuery:TFDQuery;
begin
  Result := 0;
  IbQuery:=TFDQuery.Create(Self);
  try
    IbQuery.Connection:=FDConnection;
    IbQuery.SQL.Clear;
    IbQuery.SQL.Add('SELECT GENPOSTE.*, MAG_NOM, MAG_ENSEIGNE, MAG_ID, MAG_TVTID, SOC_NOM, SOC_ID, MAG_MTAID,');
    IbQuery.SQL.Add('  MAG_CODEADH ');
    IbQuery.SQL.Add(' FROM GENPOSTE');
    IbQuery.SQL.Add('  JOIN K ON (K_ID = POS_ID AND K_ENABLED = 1)');
    IbQuery.SQL.Add('  JOIN GENMAGASIN ON (MAG_ID = POS_MAGID)');
    IbQuery.SQL.Add('  JOIN GENSOCIETE ON (SOC_ID = MAG_SOCID)');
    IbQuery.SQL.Add(' WHERE UPPER(POS_NOM) = UPPER(:NOMPOSTE) ');
    IbQuery.SQL.Add('  AND UPPER(MAG_NOM) = UPPER(:NOMMAG)    ');
    IbQuery.ParamByName('NOMPOSTE').AsString       := ANomPoste;
    IbQuery.ParamByName('NOMMAG').AsString         := ANomMag;
    IbQuery.Open();
    if not(IbQuery.IsEmpty) then
      Result := IbQuery.FieldByName('MAG_ID').AsInteger;
  finally
    IbQuery.Close();
    IbQuery.Free;
  end;
end;

function TDataModuleMain.RecupereMagCode(const AMagId: integer): string;
var IbQuery:TFDQuery;
begin
  Result := '';
  IbQuery:=TFDQuery.Create(Self);
  try
    IbQuery.Connection:=FDConnection;
    IbQuery.SQL.Clear;
    IbQuery.SQL.Add('select mag_code from genmagasin where mag_id=:MAGID');
    IbQuery.ParamByName('MAGID').AsInteger := AMagId;
    IbQuery.Open();
    if not(IbQuery.IsEmpty) then
      Result := IbQuery.FieldByName('mag_code').AsString;
  finally
    IbQuery.Close();
    IbQuery.Free;
  end;
end;

function TDataModuleMain.RecupereGUID(): string;
var IbQuery:TFDQuery;
begin
  Result := '';
  IbQuery:=TFDQuery.Create(Self);
  try
    IbQuery.Connection:=FDConnection;
    IbQuery.SQL.Clear;
    IbQuery.SQL.Add('select bas_guid FROM genparambase INNER JOIN genbases ON par_string = bas_ident WHERE par_nom = ''IDGENERATEUR''');
    IbQuery.Open();
    if not(IbQuery.IsEmpty) then
      Result := IbQuery.FieldByName('bas_guid').AsString;
  finally
    IbQuery.Close();
    IbQuery.Free;
  end;
end;

procedure TDataModuleMain.TimTraitementTimer(Sender: TObject);
begin
  // Vérifie que le traitement est bien à effectuer
  if CompareDateTime(GCONFIGAPP.dNextAction, Now()) = GreaterThanValue then
      begin
         If (Frac(Now())>Frac(GCONFIGAPP.tHeureArret))
            then
                begin
                     FormMain.TimerClose.Enabled:=true;
                end;
          Exit;
      end;

  FormMain.StbStatut.Panels[2].text := 'Running...';
  TimTraitement.Enabled             := False;

  // --------------------------------------
  // If Mapping then Application.Terminate();

  // Désactive les traitements
  FormMain.BtnParametrage.Enabled := False;
  FormMain.BtnQuitter.Enabled     := False;
  FormMain.LblProchain.Enabled    := False;
  FormMain.LblHeure.Enabled       := False;
  FormMain.TrayTache.IconIndex    := 1;

  // Démarre le thread du traitement
  LancerTraitement();
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



procedure TDataModuleMain.LancerTraitement();
//var bTraitementOk : Boolean;
begin
  try
    ThreadTraitement                      := TThreadTraitement.Create(FDConnection, GCONNEXION, GCONFIGAPP);
    FormMain.StbStatut.Panels[0].Text     := RS_INFO_TRAITEMENT;
    ThreadTraitement.OnTerminate          := FinTraitement;
    ThreadTraitement.FreeOnTerminate      := True;
    ThreadTraitement.Start();
    Journaliser(RS_INF_TH_TRAIT_D);
  except on E:Exception do
      // rien
  end;
end;

procedure TDataModuleMain.FDConnectionAfterConnect(Sender: TObject);
begin
  FormMain.StbStatut.Panels[1].Text := RS_INF_CONNECTE;
end;

procedure TDataModuleMain.FDConnectionAfterDisconnect(Sender: TObject);
begin
   FormMain.StbStatut.Panels[1].Text := RS_INF_DECONNECTE;
end;


procedure TDataModuleMain.FDConnectionError(ASender: TObject;
  const AInitiator: IFDStanObject; var AException: Exception);
begin
   Journaliser(AException.Message, NivErreur);
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
//  if TThreadTraitement(Sender).TraitementOk then
//    Journaliser(RS_INF_TH_TRAIT_S)
//  else
//    Journaliser(RS_INF_TH_TRAIT_E);

  GCONFIGAPP.dNextAction := CalculNextAction();

  ThreadTraitement:=nil;

  // Réactive les composants
  // Journaliser(FormMain.StbStatut.Panels[0].Text );
  Journaliser(Format(RS_INFO_TRAIT_PROCHAIN, [FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction)]));
  FormMain.LblHeure.Caption         := FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction);

  TimTraitement.Enabled             := True;
  FormMain.StbStatut.Panels[2].text := 'En Marche';

  FormMain.BtnParametrage.Enabled   := True;
  FormMain.BtnQuitter.Enabled       := True;
  FormMain.LblProchain.Enabled      := True;
  FormMain.LblHeure.Enabled         := True;
  FormMain.TrayTache.IconIndex      := 0;

  If (Frac(Now())>Frac(GCONFIGAPP.tHeureArret))
    then
      begin
         FormMain.TimerClose.Enabled:=true;
      end;


end;

end.

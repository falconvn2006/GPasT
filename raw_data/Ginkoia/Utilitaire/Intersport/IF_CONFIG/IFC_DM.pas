unit IFC_DM;

interface

uses
  SysUtils, Classes, IB_Components, IBODataset, IB_Access, DB, Dialogs, ComCtrls, Forms,
  DBClient, Provider, IFC_Type, ShellApi, windows, IFC_CFGParams, Controls, MidasLib;

type
  TDM_IFC = class(TDataModule)
    IboDbMag: TIBODatabase;
    IBOTransDbM: TIBOTransaction;
    Que_DOSSIERS: TIBOQuery;
    Que_Tmp: TIBOQuery;
    Que_LstMag: TIBOQuery;
    iboDbCheck: TIBODatabase;
    Que_DbMTmp: TIBOQuery;
    cds_LstMag: TClientDataSet;
    cds_LstMagMAG_ID: TIntegerField;
    cds_LstMagMAGASIN: TStringField;
    cds_LstMagVILLE: TStringField;
    cds_LstMagADR_EMAIL: TStringField;
    cds_LstMagGroupe: TStringField;
    cds_LstMagNumero: TStringField;
    cds_LstMagUSR_ID: TIntegerField;
    cds_LstMagUSR_NOM: TStringField;
    Que_lstUsr: TIBOQuery;
    Que_lstUsrUSR_ID: TIntegerField;
    Que_lstUsrUSR_USERNAME: TStringField;
    Que_ListGarantie: TIBOQuery;
    Que_ListTypeComptable: TIBOQuery;
    Que_ListTVA: TIBOQuery;
    Que_ListTVATVA_TAUX: TIBOFloatField;
    Que_ListTVATVA_ID: TIntegerField;
    Que_Domaine: TIBOQuery;
    Que_LstAxes: TIBOQuery;
    dsp_lstAxes: TDataSetProvider;
    cds_AxeUnivers: TClientDataSet;
    cds_AxeFedas: TClientDataSet;
    cds_AxeUniversUNI_ID: TIntegerField;
    cds_AxeUniversUNI_NOM: TStringField;
    cds_AxeFedasUNI_ID: TIntegerField;
    cds_AxeFedasUNI_NOM: TStringField;
    Que_DomaineACT_ID: TIntegerField;
    Que_DomaineACT_NOM: TStringField;
    Que_LstAxesUNI_ID: TIntegerField;
    Que_LstAxesUNI_NOM: TStringField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Function ConnectToDbMag(APath : String) : Boolean;
    function ConnectToDbCheck( APath : String) : Boolean;

    function GetGenParamInfo(PRM_TYPE, PRM_CODE, PRM_MAGID : Integer) : String;
    function GetGenParamInteger(PRM_TYPE, PRM_CODE, PRM_MAGID : Integer) : Integer;
    function SetGenParamInfo(PRM_TYPE, PRM_CODE, PRM_MAGID : Integer;PRM_INFO : String) : Boolean;
    function SetGenParamInteger(PRM_TYPE, PRM_CODE, PRM_MAGID : Integer;PRM_INTEGER : INTEGER) : Boolean;
    // Gestion de la mise à jour de ou des tables
    function UpdateIbDatabase: Boolean;

    function DoCheckMag(APb : TProgressBar) : Boolean;

    function GetDbMagParam_Data(APRM_TYPE : Integer) : String; 
    function SetDbMagParam_Data(APRM_TYPE : Integer;APRM_DATA : String) : Boolean;

    function ShowCFGParams : Integer;

    function UpDateMagADH (AMAG_ID : Integer;ANEW_MAGCODEADH : String) : Boolean;
  end;

var
  DM_IFC: TDM_IFC;

implementation

{$R *.dfm}

{ TDM_DbMAG }

function TDM_IFC.UpdateIbDatabase: Boolean;
var
  LstField, lstTable : TStringList;
  bRestart : Boolean;
begin
  bRestart := False;
  Result := True;
  // ----------------------------
  // Mise à jour DOSSIERS
  // ----------------------------
  With Que_DbMTmp do
  try
    LstField := TStringList.Create;

    Close;
    SQL.Clear;
    SQL.Add('Select * from DOSSIERS');
    SQL.Add('Where DOS_ID = -1');
    Open;
    // Récupération de la liste des champs
    GetFieldNames(lstField);
    Close;

    if (lstField.IndexOf('DOS_MAILMODE') = -1) or (lstField.IndexOf('DOS_MAILSENDTO') = -1) then
    begin
      // création des champs
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_MAILMODE INTEGER DEFAULT 0');
      IboDbMag.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_MAILSENDTO VARCHAR(128)');
      IboDbMag.Commit;

      // Initialisation des champs
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('UPDATE DOSSIERS Set DOS_MAILMODE = 0');
      IboDbMag.Commit;

      bRestart := True;
    end;

    // -------------------------------
    // Mise à jour DOSSIER 30-03-2012
    // Pour BI
    // -------------------------------
    if (LstField.IndexOf('DOS_ACTIFBI') = -1) then
    begin
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_ACTIFBI INTEGER DEFAULT 0');
      IboDbMag.Commit;

      // Initialisation des champs
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('UPDATE DOSSIERS Set DOS_ACTIFBI = 0');
      IboDbMag.Commit;

      bRestart := True;
    end;

    // -------------------------------
    // Mise à jour DOSSIER 05/04/2012
    // Pour BI
    // -------------------------------
    if (LstField.IndexOf('DOS_CODEGROUPEBI') = -1) then
    begin
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_CODEGROUPEBI VARCHAR(6)');
      IboDbMag.Commit;

      bRestart := True;
    end;

    // -------------------------------
    // Mise à jour dossier 16/04/2012
    // Ajout ID MDC
    // -------------------------------
    if LstField.IndexOf('DOS_IDMDC') = -1 then
    begin
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_IDMDC VARCHAR(64)');
      IboDbMag.Commit;

      bRestart := True;
    end;

    // ---------------------------------
    // Mise à jour dossier 11/04/2013
    // Ajout Date de dernier traitement
    // ---------------------------------

    if LstField.IndexOf('DOS_LAST') = -1  then
    begin
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_LAST TIMESTAMP');
      IboDbMag.Commit;

      bRestart := True;
    end;

  finally
    LstField.Free;
  end;

  // ----------------------------
  // Mise à jour / Création PARAMS
  // ----------------------------
  lstTable := TStringList.Create;
  With Que_DbMTmp do
  Try
    // Récupération de la liste des tables
    Close;
    SQL.Clear;
    SQL.Add('select distinct RDB$RELATION_NAME from rdb$RELATION_FIELDS');
    SQL.Add('where RDB$VIEW_CONTEXT is null');
    SQL.Add('and RDB$SYSTEM_FLAG = 0;');
    Open;

    if Not Locate('RDB$RELATION_NAME','PARAMS',[loCaseInsensitive]) then
    begin
      // Création de la table
      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('CREATE TABLE PARAMS (PRM_ID INTEGER NOT NULL,PRM_TYPE SMALLINT,PRM_DATA VARCHAR(255) COLLATE NONE);');
//      IboDbMag.ExecSQL('ALTER TABLE PARAMS ADD PRIMARY KEY (PRM_ID);');
      IboDbMag.ExecSQL('CREATE GENERATOR PARAMS_PRM_ID_GEN');
      IboDbMag.Commit;

      IboDbMag.StartTransaction;
      IboDbMag.ExecSQL('SET GENERATOR PARAMS_PRM_ID_GEN TO 0');
      IboDbMag.ExecSQL('CREATE TRIGGER BI_PARAMS_PRM_ID FOR PARAMS ACTIVE BEFORE INSERT POSITION 0' +
                       ' AS BEGIN IF (NEW.PRM_ID IS NULL) THEN NEW.PRM_ID = GEN_ID(PARAMS_PRM_ID_GEN, 1); END');
      IboDbMag.Commit;

      // Création de l'enregistrement Password (PRM_TYPE 1)
      IboDbMag.StartTransaction;
      Close;
      SQL.Clear;
      SQL.Add('Insert into PARAMS(PRM_TYPE, PRM_DATA)');
      SQL.Add('Values(:PPRMTYPE, :PPRMDATA)');
      ParamCheck := True;
      ParamByName('PPRMTYPE').AsInteger := 1;
      ParamByName('PPRMDATA').AsString := DoCryptPass('ginkoia');
      ExecSQL;
      IboDbMag.Commit;

      bRestart := True;
    end;

    Que_DOSSIERS.Close;
    Que_DOSSIERS.Open;

  Finally
  lstTable.Free;
  End;

  if bRestart then
  begin
    Showmessage('La base de données a été mise à jour. Redémarrage de l''aplication');
    ShellExecute(0,'OPEN',PWideChar(ParamStr(0)),nil,PWideChar(ExtractFilePath(ParamStr(0))),SW_SHOW);
    Application.Terminate;
  end;

end;

function TDM_IFC.UpDateMagADH(AMAG_ID : Integer;ANEW_MAGCODEADH: String): Boolean;
var
  MAG_ID : Integer;
begin
  With Que_Tmp do
  begin
    Que_Tmp.IB_Transaction.StartTransaction;
    Close;
    SQL.Clear;
    SQL.Add('Update GENMAGASIN SET');
    SQL.Add('  MAG_CODEADH = :PCODEADH');
    SQL.Add('Where MAG_ID = :PMAGID');
    ParamCheck := True;
    ParamByName('PCODEADH').AsString := ANEW_MAGCODEADH;
    ParamByName('PMAGID').AsInteger := AMAG_ID;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PPRMID,0);');
    ParamCheck := True;
    ParamByName('PPRMID').AsInteger := AMAG_ID;
    ExecSQL;
    Que_Tmp.IB_Transaction.Commit;

  end;
end;

function TDM_IFC.ConnectToDbCheck(APath: String): Boolean;
begin
  Result := False;
  With iboDbCheck do
  begin
    Disconnect;
    DatabaseName := APath;
    try
      Connect;
      Result := Connected;
    Except on E:Exception do
      raise Exception.Create('Erreur de connexion à la base de données :' + E.Message);
    End;
  end;
end;

function TDM_IFC.ConnectToDbMag(APath: String): Boolean;
begin
  Result := False;

  if Trim(APath) = '' then
  begin
    ShowMessage('Configuration du chemin d''accès à la base de données de configuration nécessaire');
    if ShowCFGParams = mrOk then
    begin
      Result := ConnectToDbMag(IniCfg.Database);
      Exit;
    end;
  end;

  With IboDbMag do
  begin
    Disconnect;
    DatabaseName := APath;
    Try
      Connect;
      Result := Connected;

      Que_DOSSIERS.Close;
      Que_DOSSIERS.Open;
    Except on E:Exception do
      Showmessage('Erreur de connexion à la base de données : ' + E.Message);
    End;
  end;
end;

function TDM_IFC.DoCheckMag(APb: TProgressBar): Boolean;
begin
  Que_DOSSIERS.First;
  while not Que_DOSSIERS.Eof do
  begin
    if ((Trim(Que_DOSSIERS.FieldByName('DOS_GROUPE').AsString) = '') Or
         (Trim(Que_DOSSIERS.FieldByName('DOS_NUM').AsString)= '')) then
    begin
      If ConnectToDbCheck(Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString) then
      begin
        IboDbMag.StartTransaction;
        try
          With Que_DbMTmp do
          begin
            close;
            SQL.Clear;
            SQL.Add('Update Dossiers Set');
            SQL.Add('Where DOS_ID = :PDOSID');

            if (Trim(Que_DOSSIERS.FieldByName('DOS_GROUPE').AsString) = '') then
            begin
              SQL.Insert(1,'  DOS_GROUPE = :PDOSGROUPE');
              ParamCheck := True;
              ParamByName('PDOSGROUPE').AsString := GetGenParamInfo(12,9,Que_DOSSIERS.FieldByName('DOS_MAGID').AsInteger);
            end;

            if (Trim(Que_DOSSIERS.FieldByName('DOS_NUM').AsString)= '') then
            begin
              if SQL.Count > 2 then
                SQL.Insert(1,',');
              SQL.Insert(1, 'DOS_NUM = :PDOSNUM');
              ParamCheck := True;
              ParamByName('PDOSNUM').AsString := GetGenParamInfo(12,10,Que_DOSSIERS.FieldByName('DOS_MAGID').AsInteger);
            end;
            ParamByName('PDOSID').AsInteger := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
            ExecSQL;
          end; // with
//              if (Trim(Que_DOSSIERS.FieldByName('DOS_GROUPE').AsString) = '') then
//                Que_DOSSIERS.FieldByName('DOS_GROUPE').AsString := GetGenParamInfo(12,9,Que_DOSSIERS.FieldByName('DOS_MAGID').AsInteger);
//              if  (Trim(Que_DOSSIERS.FieldByName('DOS_NUM').AsString)= '') then
//                  Que_DOSSIERS.FieldByName('DOS_NUM').AsString := GetGenParamInfo(12,10,Que_DOSSIERS.FieldByName('DOS_MAGID').AsInteger);
//              Que_DOSSIERS.Post;
          IboDbMag.Commit;
        Except on E:Exception do
          IboDbMag.Rollback;
        end; //try/except
      end; // if
    end; // if

    Que_DOSSIERS.Next;
    Apb.Position := Que_DOSSIERS.RecNo * 100 DIV Que_DOSSIERS.RecordCount;
    Application.ProcessMessages;
  end; // while

  Que_DOSSIERS.Refresh;
end;

function TDM_IFC.GetDbMagParam_Data(APRM_TYPE: Integer): String;
begin
  With Que_DbMTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select PRM_DATA from PARAMS');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('PRM_DATA').AsString
    else
      raise Exception.Create(Format('Paramètre inéxistant %d',[APRM_TYPE]));
  end;
end;

function TDM_IFC.GetGenParamInfo(PRM_TYPE, PRM_CODE,
  PRM_MAGID: Integer): String;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INFO From GenParam');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := PRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := PRM_CODE;
    ParamByName('PPRMMAGID').AsInteger := PRM_MAGID;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('PRM_INFO').AsString
    else
      raise Exception.Create(Format('Paramètre inéxistant : (%d/%d/%d)',[PRM_TYPE,PRM_CODE,PRM_MAGID]));
  end;
end;

function TDM_IFC.GetGenParamInteger(PRM_TYPE, PRM_CODE,
  PRM_MAGID: Integer): Integer;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INTEGER From GenParam');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := PRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := PRM_CODE;
    ParamByName('PPRMMAGID').AsInteger := PRM_MAGID;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('PRM_INTEGER').AsInteger
    else
      raise Exception.Create(Format('Paramètre inéxistant : (%d/%d/%d)',[PRM_TYPE,PRM_CODE,PRM_MAGID]));
  end;
end;

function TDM_IFC.SetDbMagParam_Data(APRM_TYPE: Integer;
  APRM_DATA: String): Boolean;
begin
  Result := False;
  With Que_DbMTmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('UPDATE PARAMS Set');
    SQL.Add('  PRM_DATA = :PPRMDATA');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    ParamCheck := True;
    ParamByName('PPRMDATA').AsString := APRM_DATA;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    ExecSQL;

    Result := True;
  Except on E:Exception do
    raise Exception.Create(Format('Enregistrement paramètre %d : %s',[APRM_TYPE, E.Message]));
  end;
end;

function TDM_IFC.SetGenParamInfo(PRM_TYPE, PRM_CODE, PRM_MAGID: Integer;
  PRM_INFO: String): Boolean;
var
  PRM_ID : Integer;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_ID From GenParam');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := PRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := PRM_CODE;
    ParamByName('PPRMMAGID').AsInteger := PRM_MAGID;
    Open;

    if RecordCount > 0 then
      PRM_ID := FieldByName('PRM_ID').AsInteger
    else
      raise Exception.Create(Format('Paramètre inéxistant : (%d/%d/%d)',[PRM_TYPE,PRM_CODE,PRM_MAGID]));

    Close;
    SQL.Clear;
    SQL.Add('Update GenParam set');
    SQL.Add(' PRM_INFO = :PPRMINFO');
    SQL.Add('Where PRM_ID = :PPRMID');
    ParamCheck := True;
    ParamByName('PPRMINFO').AsString := PRM_INFO;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PPRMID,0);');
    ParamCheck := True;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;
  end;
end;

function TDM_IFC.SetGenParamInteger(PRM_TYPE, PRM_CODE, PRM_MAGID,
  PRM_INTEGER: INTEGER): Boolean;
var
  PRM_ID : Integer;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_ID From GenParam');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := PRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := PRM_CODE;
    ParamByName('PPRMMAGID').AsInteger := PRM_MAGID;
    Open;

    if RecordCount > 0 then
      PRM_ID := FieldByName('PRM_ID').AsInteger
    else
      raise Exception.Create(Format('Paramètre inéxistant : (%d/%d/%d)',[PRM_TYPE,PRM_CODE,PRM_MAGID]));

    Close;
    SQL.Clear;
    SQL.Add('Update GenParam set');
    SQL.Add(' PRM_INTEGER = :PPRMINTEGER');
    SQL.Add('Where PRM_ID = :PPRMID');
    ParamCheck := True;
    ParamByName('PPRMINTEGER').AsInteger := PRM_INTEGER;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PPRMID,0);');
    ParamCheck := True;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;
  end;
end;

function TDM_IFC.ShowCFGParams: Integer;
begin
  With Tfrm_CFGParams.Create(Self) do
  try
    Result := ShowModal;
  finally
    Release;
  end;
end;

end.

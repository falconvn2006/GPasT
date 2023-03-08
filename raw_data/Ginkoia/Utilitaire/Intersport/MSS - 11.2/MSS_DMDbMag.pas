unit MSS_DMDbMag;

interface

uses
  SysUtils, Classes, IB_Components, IBODataset, IB_Access, DB, Dialogs, ComCtrls, Forms,
  DBClient, Provider, MSS_Type, Mss_CFGParams, controls;

type
  TDM_DbMAG = class(TDataModule)
    IboDbMag: TIBODatabase;
    IBOTransDbM: TIBOTransaction;
    Que_DOSSIERS: TIBOQuery;
    Que_Tmp: TIBOQuery;
    Que_LstMag: TIBOQuery;
    iboDbCheck: TIBODatabase;
    Que_DbMTmp: TIBOQuery;
    Que_LstMagMAG_ID: TIntegerField;
    Que_LstMagMAGASIN: TStringField;
    Que_LstMagVILLE: TStringField;
    Que_LstMagADR_EMAIL: TStringField;
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

    function DoCheckMag(APb : TProgressBar) : Boolean;

    function GetDbMagParam_Data(APRM_TYPE : Integer) : String; 
    function SetDbMagParam_Data(APRM_TYPE : Integer;APRM_DATA : String) : Boolean;

    function ShowModalCFG : Integer;
  end;

var
  DM_DbMAG: TDM_DbMAG;

implementation

{$R *.dfm}

{ TDM_DbMAG }

function TDM_DbMAG.ConnectToDbCheck(APath: String): Boolean;
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

function TDM_DbMAG.ConnectToDbMag(APath: String): Boolean;
begin
  Result := False;
//
//  if trim(APath) = '' then
//  begin
//    showmessage('Veuillez configurer la base de données de configuration');
//    if ShowModalCFG = mrOk then
//    begin
//      Result := ConnectToDbMag(APath);
//    end;
//    Exit;
//  end;

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
      Showmessage('Erreur de connexion à la base de données Dossiers :' + E.Message);
    End;
  end;
end;

function TDM_DbMAG.DoCheckMag(APb: TProgressBar): Boolean;
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

function TDM_DbMAG.GetDbMagParam_Data(APRM_TYPE: Integer): String;
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

function TDM_DbMAG.GetGenParamInfo(PRM_TYPE, PRM_CODE,
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

function TDM_DbMAG.GetGenParamInteger(PRM_TYPE, PRM_CODE,
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

function TDM_DbMAG.SetDbMagParam_Data(APRM_TYPE: Integer;
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

function TDM_DbMAG.SetGenParamInfo(PRM_TYPE, PRM_CODE, PRM_MAGID: Integer;
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

function TDM_DbMAG.SetGenParamInteger(PRM_TYPE, PRM_CODE, PRM_MAGID,
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

function TDM_DbMAG.ShowModalCFG: Integer;
begin
  With Tfrm_CFGParams.Create(nil) do
  try
    BorderStyle := bsSingle;
    Parent := nil;
    Result := ShowModal;
  finally
    Release;
  end;
end;

end.

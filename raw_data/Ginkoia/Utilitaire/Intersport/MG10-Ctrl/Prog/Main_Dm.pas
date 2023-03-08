unit Main_Dm;

interface

uses
  Windows, SysUtils, Classes, IB_Components, IBODataset, IB_Access, DB, Forms;

type
  TThreadRecalculStk = Class(TThread)
  private
    dDebut: DWord;
    iMaxProgress: integer;
    iProgress: integer;
    sEtat: string;
    sDuree: string;

    procedure InitFrm;
    procedure UpdateFrm(AFait, AReste: integer);

  public
    sError: string;

    constructor Create;
    procedure Execute; override;
  end;

  TDm_Main = class(TDataModule)
    DatabaseOri: TIBODatabase;
    Trans_Ori: TIBOTransaction;
    DatabaseDst: TIBODatabase;
    Trans_Dst: TIBOTransaction;
    Que_OriMag: TIBOQuery;
    Que_OriMagMAG_ID: TIntegerField;
    Que_OriMagMAG_CODEADH: TStringField;
    Que_OriMagMAG_NOM: TStringField;
    Que_OriMagMAG_ENSEIGNE: TStringField;
    Que_DstMag: TIBOQuery;
    Que_DstMagMAG_ID: TIntegerField;
    Que_DstMagMAG_CODEADH: TStringField;
    Que_DstMagMAG_NOM: TStringField;
    Que_DstMagMAG_ENSEIGNE: TStringField;
    Trans_MajOri: TIBOTransaction;
    Trans_MajDst: TIBOTransaction;
    Que_PrcCB: TIBOQuery;
    Que_OriParamMag: TIBOQuery;
    Que_OriParamMagMAG_ID: TIntegerField;
    Que_OriParamMagMAG_CODEADH: TStringField;
    Que_OriParamMagMAG_NOM: TStringField;
    Que_OriParamMagGCL_NOM: TStringField;
    Que_OriParamMagGCC_NOM: TStringField;
    Que_OriParamMagGCL_ID: TIntegerField;
    Que_OriParamMagGCC_ID: TIntegerField;
    Query: TIBOQuery;
    Que_DstParamMag: TIBOQuery;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    IntegerField2: TIntegerField;
    StringField3: TStringField;
    IntegerField3: TIntegerField;
    StringField4: TStringField;
    Que_OriParamMagGCP_ID: TIntegerField;
    Que_OriParamMagGCP_NOM: TStringField;
    Que_DstParamMagGCP_ID: TIntegerField;
    Que_DstParamMagGCP_NOM: TStringField;

    procedure Que_OriMagBeforeClose(DataSet: TDataSet);
    procedure Que_DstMagBeforeClose(DataSet: TDataSet);
    procedure Que_DstMagUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_OriMagUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_OriMagAfterPost(DataSet: TDataSet);
    procedure Que_DstMagAfterPost(DataSet: TDataSet);

  private
    procedure UpdateCodeAdhMag(AOrigine: boolean; AMagID: integer; ACodeAdh, ANom, AEnseigne: string);
//    function MajGrpPump(AId: integer; AGroupe: string): integer;

  public
    function IsProcedureExists(AProcName: string): boolean;
    procedure GrantProcedure(AProcName: string; AOkGinkoia: boolean);
    procedure PassageScript(AText: string);

    procedure ConnexionOri(ABase: string);
    procedure ConnexionDst(ABase: string);

    function GetVersionOri: string;
    function GetOriCntStkReCalc: integer;
    function GetVersionDst: string;

    function GetGroupesClient(const bOrigine: Boolean): Boolean;
    function GetGroupesCompteClient(const bOrigine: Boolean): Boolean;
    function GetGroupesDePump(const bOrigine: Boolean): Boolean;
    function ValiderParamMagasin(const bOrigine: Boolean; const nIDMag: Integer; nIDGroupeClient, nIDGroupeCompteClient, nIDGroupeDePump: Integer; const sGroupeClient, sGroupeCompteClient, sGroupeDePump: String): Boolean;

    procedure GrpPumpAuto;
    procedure AffectationGrpPump(AMagId, AMpuId, AGcpID: integer; ANomGrp: string);
    function AjoutModifGrpPump(AGcpId: integer; ANomGrp: string): integer;
  end;

var
  Dm_Main: TDm_Main;

implementation

uses
  MajStk_Frm;

{$R *.dfm}

{ TDm_Main }

function TDm_Main.IsProcedureExists(AProcName: string): boolean;
var
  QueTmp: TIBOQuery;
begin
  Result := false;
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DatabaseOri;
    QueTmp.IB_Transaction := Trans_Ori;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select * from RDB$procedures');
    QueTmp.SQL.Add(' where RDB$procedure_name='+QuotedStr(AProcName));
    QueTmp.Open;
    QueTmp.First;
    Result := not(QueTmp.Eof);
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

// si AOkGinkoia est à false, c'est repl qui est pris en compte
procedure TDm_Main.GrantProcedure(AProcName: string; AOkGinkoia: boolean);
var
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DatabaseOri;
    QueTmp.IB_Transaction := Trans_Ori;
    Trans_Ori.StartTransaction;
    try
      QueTmp.ParamCheck := false;
      QueTmp.SQL.Clear;
      if AOkGinkoia then
        QueTmp.SQL.Add('GRANT EXECUTE ON PROCEDURE '+AProcName+' TO GINKOIA')
      else
        QueTmp.SQL.Add('GRANT EXECUTE ON PROCEDURE '+AProcName+' TO REPL');
      QueTmp.ExecSQL;
      Trans_Ori.Commit;
    except
      on E:Exception do
      begin
        Trans_Ori.Rollback;
        E.Message := 'GrantProcedure-> '+E.Message;
        raise;
      end;
    end;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

// passe le script (présent dans le fichier)
procedure TDm_Main.PassageScript(AText: string);
var
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DatabaseOri;
    QueTmp.IB_Transaction := Trans_Ori;
    Trans_Ori.StartTransaction;
    try
      QueTmp.ParamCheck := false;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Text := AText;
      QueTmp.ExecSQL;
      Trans_Ori.Commit;
    except
      on E:Exception do
      begin
        Trans_Ori.Rollback;
        E.Message := 'PassageScript-> '+E.Message;
        raise;
      end;
    end;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

procedure TDm_Main.ConnexionOri(ABase: string);
//var
//  QueTmp: TIBOQuery;
begin
  // retourne la version de la base
  DatabaseOri.Connected := false;
  DatabaseOri.Username := 'GINKOIA';
  DatabaseOri.Password := 'ginkoia';
  DatabaseOri.DatabaseName := AnsiString(ABase);
  DatabaseOri.Connected := true;
end;

function TDm_Main.GetVersionOri: string;
var
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DatabaseOri;
    QueTmp.IB_Transaction := Trans_Ori;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select * from genversion order by ver_date');
    QueTmp.Open;
    QueTmp.Last;
    Result := QueTmp.fieldbyname('VER_VERSION').AsString;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

function TDm_Main.GetGroupesClient(const bOrigine: Boolean): Boolean;
begin
  Result := True;
  if bOrigine then
  begin
    Query.IB_Connection := Dm_Main.DatabaseOri;
    Query.IB_Transaction := Trans_Ori;
  end
  else
  begin
    Query.IB_Connection := Dm_Main.DatabaseDst;
    Query.IB_Transaction := Trans_Dst;
  end;

  // Recherche des groupes client.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select GCL_ID, GCL_NOM, lower(GCL_NOM) as TRI');
  Query.SQL.Add('from GENGESTIONCLT');
  Query.SQL.Add('join K on (K_ID = GCL_ID and K_ENABLED = 1)');
  Query.SQL.Add('where GCL_ID <> 0');
  Query.SQL.Add('order by TRI');
  try
    Query.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la recherche des groupes client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
      Result := False;
      Exit;
    end;
  end;
end;

function TDm_Main.GetGroupesCompteClient(const bOrigine: Boolean): Boolean;
begin
  Result := True;
  if bOrigine then
  begin
    Query.IB_Connection := Dm_Main.DatabaseOri;
    Query.IB_Transaction := Trans_Ori;
  end
  else
  begin
    Query.IB_Connection := Dm_Main.DatabaseDst;
    Query.IB_Transaction := Trans_Dst;
  end;

  // Recherche des groupes compte client.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select GCC_ID, GCC_NOM, lower(GCC_NOM) as TRI');
  Query.SQL.Add('from GENGESTIONCLTCPT');
  Query.SQL.Add('join K on (K_ID = GCC_ID and K_ENABLED = 1)');
  Query.SQL.Add('where GCC_ID <> 0');
  Query.SQL.Add('order by TRI');
  try
    Query.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la recherche des groupes compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
      Result := False;
      Exit;
    end;
  end;
end;

function TDm_Main.GetGroupesDePump(const bOrigine: Boolean): Boolean;
begin
  Result := True;
  if bOrigine then
  begin
    Query.IB_Connection := Dm_Main.DatabaseOri;
    Query.IB_Transaction := Trans_Ori;
  end
  else
  begin
    Query.IB_Connection := Dm_Main.DatabaseDst;
    Query.IB_Transaction := Trans_Dst;
  end;

  // Recherche des groupes de pump.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select GCP_ID, GCP_NOM, lower(GCP_NOM) as TRI');
  Query.SQL.Add('from GENGESTIONPUMP');
  Query.SQL.Add('join K on (K_ID = GCP_ID and K_ENABLED = 1)');
  Query.SQL.Add('where GCP_ID <> 0');
  Query.SQL.Add('order by TRI');
  try
    Query.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la recherche des groupes de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
      Result := False;
      Exit;
    end;
  end;
end;

function TDm_Main.ValiderParamMagasin(const bOrigine: Boolean; const nIDMag: Integer; nIDGroupeClient, nIDGroupeCompteClient, nIDGroupeDePump: Integer; const sGroupeClient, sGroupeCompteClient, sGroupeDePump: String): Boolean;
var
  nID: Integer;
begin
  Result := False;
  if bOrigine then
  begin
    Query.IB_Connection := Dm_Main.DatabaseOri;
    Query.IB_Transaction := Trans_MajOri;
  end
  else
  begin
    Query.IB_Connection := Dm_Main.DatabaseDst;
    Query.IB_Transaction := Trans_MajDst;
  end;

  Query.IB_Transaction.StartTransaction;

  // ------------------------------------------------------ Gestion groupe client. ------------------------------------------------------
  if nIDGroupeClient = -1 then
  begin
    // Nouveau K.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select ID from pr_newk(''GENGESTIONCLT'')');
    try
      Query.Open;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la récupération d''un nouveau K a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    nIDGroupeClient := Query.Fields[0].AsInteger;

    // Création du nouveau groupe client.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('insert into GENGESTIONCLT');
    Query.SQL.Add('values(:GCLID, :GCLNOM)');
    try
      Query.ParamByName('GCLID').AsInteger := nIDGroupeClient;
      Query.ParamByName('GCLNOM').AsString := sGroupeClient;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la création du nouveau groupe client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end
  else if sGroupeClient <> '' then
  begin
    // Maj groupe client.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update GENGESTIONCLT');
    Query.SQL.Add('set GCL_NOM = :GCLNOM');
    Query.SQL.Add('where GCL_ID = :GCLID');
    try
      Query.ParamByName('GCLNOM').AsString := sGroupeClient;
      Query.ParamByName('GCLID').AsInteger := nIDGroupeClient;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj du groupe client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      Query.ParamByName('ID').AsInteger := nIDGroupeClient;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj K du groupe client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end;

  // Recherche de la liaison groupe client.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select MGC_ID');
  Query.SQL.Add('from GENMAGGESTIONCLT');
  Query.SQL.Add('join K on (K_ID = MGC_ID and K_ENABLED = 1)');
  Query.SQL.Add('where MGC_MAGID = :MAGID');
  try
    Query.ParamByName('MAGID').AsInteger := nIDMag;
    Query.Open;
  except
    on E: Exception do
    begin
      Query.IB_Transaction.Rollback;
      Application.MessageBox(PChar('Erreur :  la recherche de la liaison groupe client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
  if not Query.IsEmpty then
  begin
    nID := Query.FieldByName('MGC_ID').AsInteger;

    // Maj liaison groupe client.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update GENMAGGESTIONCLT');
    Query.SQL.Add('set MGC_GCLID = :GCLID');
    Query.SQL.Add('where MGC_ID = :MGCID');
    try
      Query.ParamByName('GCLID').AsInteger := nIDGroupeClient;
      Query.ParamByName('MGCID').AsInteger := nID;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj de la liaison groupe client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      Query.ParamByName('ID').AsInteger := nID;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj K de la liaison groupe client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end;

  // --------------------------------------------------- Gestion groupe compte client. ---------------------------------------------------
  if nIDGroupeCompteClient = -1 then
  begin
    // Nouveau K.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select ID from pr_newk(''GENGESTIONCLTCPT'')');
    try
      Query.Open;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la récupération d''un nouveau K a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    nIDGroupeCompteClient := Query.Fields[0].AsInteger;

    // Création du nouveau groupe compte client.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('insert into GENGESTIONCLTCPT');
    Query.SQL.Add('values(:GCCID, :GCCNOM)');
    try
      Query.ParamByName('GCCID').AsInteger := nIDGroupeCompteClient;
      Query.ParamByName('GCCNOM').AsString := sGroupeCompteClient;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la création du nouveau groupe compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end
  else if sGroupeCompteClient <> '' then
  begin
    // Maj groupe compte client.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update GENGESTIONCLTCPT');
    Query.SQL.Add('set GCC_NOM = :GCCNOM');
    Query.SQL.Add('where GCC_ID = :GCCID');
    try
      Query.ParamByName('GCCNOM').AsString := sGroupeCompteClient;
      Query.ParamByName('GCCID').AsInteger := nIDGroupeCompteClient;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj du groupe compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      Query.ParamByName('ID').AsInteger := nIDGroupeCompteClient;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj K du groupe compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end;

  // Recherche de la liaison groupe compte client.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select MCC_ID');
  Query.SQL.Add('from GENMAGGESTIONCLTCPT');
  Query.SQL.Add('join K on (K_ID = MCC_ID and K_ENABLED = 1)');
  Query.SQL.Add('where MCC_MAGID = :MAGID');
  try
    Query.ParamByName('MAGID').AsInteger := nIDMag;
    Query.Open;
  except
    on E: Exception do
    begin
      Query.IB_Transaction.Rollback;
      Application.MessageBox(PChar('Erreur :  la recherche de la liaison groupe compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
  if not Query.IsEmpty then
  begin
    nID := Query.FieldByName('MCC_ID').AsInteger;

    // Maj liaison groupe compte client.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update GENMAGGESTIONCLTCPT');
    Query.SQL.Add('set MCC_GCCID = :GCCID');
    Query.SQL.Add('where MCC_ID = :MCCID');
    try
      Query.ParamByName('GCCID').AsInteger := nIDGroupeCompteClient;
      Query.ParamByName('MCCID').AsInteger := nID;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj de la liaison groupe compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      Query.ParamByName('ID').AsInteger := nID;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj K de la liaison groupe compte client a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end;

  // --------------------------------------------------- Gestion groupe de pump. ---------------------------------------------------
  if nIDGroupeDePump = -1 then
  begin
    // Nouveau K.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select ID from pr_newk(''GENGESTIONPUMP'')');
    try
      Query.Open;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la récupération d''un nouveau K a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    nIDGroupeDePump := Query.Fields[0].AsInteger;

    // Création du nouveau groupe de pump.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('insert into GENGESTIONPUMP');
    Query.SQL.Add('values(:GCPID, :GCPNOM)');
    try
      Query.ParamByName('GCPID').AsInteger := nIDGroupeDePump;
      Query.ParamByName('GCPNOM').AsString := sGroupeDePump;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la création du nouveau groupe de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end
  else if sGroupeDePump <> '' then
  begin
    // Maj groupe de pump.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update GENGESTIONPUMP');
    Query.SQL.Add('set GCP_NOM = :GCPNOM');
    Query.SQL.Add('where GCP_ID = :GCPID');
    try
      Query.ParamByName('GCPNOM').AsString := sGroupeDePump;
      Query.ParamByName('GCPID').AsInteger := nIDGroupeDePump;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj du groupe de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      Query.ParamByName('ID').AsInteger := nIDGroupeDePump;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj K du groupe de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end;

  // Recherche de la liaison groupe de pump.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select MPU_ID');
  Query.SQL.Add('from GENMAGGESTIONPUMP');
  Query.SQL.Add('join K on (K_ID = MPU_ID and K_ENABLED = 1)');
  Query.SQL.Add('where MPU_MAGID = :MAGID');
  try
    Query.ParamByName('MAGID').AsInteger := nIDMag;
    Query.Open;
  except
    on E: Exception do
    begin
      Query.IB_Transaction.Rollback;
      Application.MessageBox(PChar('Erreur :  la recherche de la liaison groupe de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
  if not Query.IsEmpty then
  begin
    nID := Query.FieldByName('MPU_ID').AsInteger;

    // Maj liaison groupe de pump.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update GENMAGGESTIONPUMP');
    Query.SQL.Add('set MPU_GCPID = :GCPID');
    Query.SQL.Add('where MPU_ID = :MPUID');
    try
      Query.ParamByName('GCPID').AsInteger := nIDGroupeDePump;
      Query.ParamByName('MPUID').AsInteger := nID;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj de la liaison groupe de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      Query.ParamByName('ID').AsInteger := nID;
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        Query.IB_Transaction.Rollback;
        Application.MessageBox(PChar('Erreur :  la maj K de la liaison groupe de pump a échoué !' + #13#10 + E.Message), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
  end;

  Query.IB_Transaction.Commit;
  Result := True;
end;

function TDm_Main.GetOriCntStkReCalc: integer;
var
  QueTmp: TIBOQuery;
  NBasID: integer;
begin
  Result := 0;
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DatabaseOri;
    QueTmp.IB_Transaction := Trans_Ori;

    // table GENTRIGGER
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select count(*) as NBRE from GENTRIGGER');
    QueTmp.SQL.Add(' where tri_id<>0');
    QueTmp.Open;
    Result := Result+QueTmp.FieldByName('NBRE').AsInteger;
    QueTmp.Close;

    // table ARTRECALCUL - BaseID
    NBasID := -1;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('SELECT MIN(BAS_ID) as BASID');
    QueTmp.SQL.Add('FROM GENBASES JOIN K ON (K_ID=BAS_ID AND K_ENABLED =1)');
    QueTmp.SQL.Add('WHERE BAS_IDENT=(SELECT PAR_STRING FROM GENPARAMBASE WHERE PAR_NOM='+QuotedStr('IDGENERATEUR')+')');
    QueTmp.Open;
    NBasID := QueTmp.Fieldbyname('BASID').AsInteger;
    if NBasID=0 then
      NBasID := -1;
    // table ARTRECALCUL
    QueTmp.Close;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select count(distinct(rec_artid)) as NBRE  from ARTRECALCULE');
    QueTmp.SQL.Add('where (REC_ID<>0) and ((REC_QUOI=0) OR (REC_QUOI<> '+inttostr(NBasID)+'))');
    QueTmp.Open;
    Result := Result+QueTmp.FieldByName('NBRE').AsInteger;
    QueTmp.Close;

  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

procedure TDm_Main.Que_DstMagAfterPost(DataSet: TDataSet);
begin
  UpdateCodeAdhMag(false, Que_DstMag.FieldByName('MAG_ID').AsInteger,
                          Que_DstMag.FieldByName('MAG_CODEADH').AsString,
                          Que_DstMag.FieldByName('MAG_NOM').AsString,
                          Que_DstMag.FieldByName('MAG_ENSEIGNE').AsString);
end;

procedure TDm_Main.Que_DstMagBeforeClose(DataSet: TDataSet);
begin
  Que_DstMag.CancelUpdates;
  Que_DstMag.CommitUpdates;
end;

procedure TDm_Main.Que_DstMagUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
//
end;

procedure TDm_Main.Que_OriMagAfterPost(DataSet: TDataSet);
begin
  UpdateCodeAdhMag(true, Que_OriMag.FieldByName('MAG_ID').AsInteger,
                         Que_OriMag.FieldByName('MAG_CODEADH').AsString,
                         Que_OriMag.FieldByName('MAG_NOM').AsString,
                         Que_OriMag.FieldByName('MAG_ENSEIGNE').AsString);
end;

procedure TDm_Main.Que_OriMagBeforeClose(DataSet: TDataSet);
begin
  Que_OriMag.CancelUpdates;
  Que_OriMag.CommitUpdates;
end;

procedure TDm_Main.Que_OriMagUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
//
end;

procedure TDm_Main.UpdateCodeAdhMag(AOrigine: boolean; AMagID: integer;
  ACodeAdh, ANom, AEnseigne: string);
var
  QueUdp: TIB_Cursor;
begin
  QueUdp := TIB_Cursor.Create(Self);
  try
    if AOrigine then
    begin
      QueUdp.IB_Connection := DatabaseOri;
      QueUdp.IB_Transaction := Trans_MajOri;
    end
    else
    begin
      QueUdp.IB_Connection := DatabaseDst;
      QueUdp.IB_Transaction := Trans_MajDst;
    end;
    QueUdp.SQL.Clear;
    QueUdp.SQL.Add('update GENMAGASIN set');
    if not(AOrigine) then
    begin
      QueUdp.SQL.Add('       MAG_NOM='+QuotedStr(ANom)+',');
      QueUdp.SQL.Add('       MAG_ENSEIGNE='+QuotedStr(AEnseigne)+',');
    end;
    QueUdp.SQL.Add('       MAG_CODEADH='+QuotedStr(ACodeAdh));
    QueUdp.SQL.Add(' where MAG_ID='+inttostr(AMagID));
    QueUdp.IB_Transaction.StartTransaction;
    try
      QueUdp.Execute;
      QueUdp.Close;

      QueUdp.SQL.Clear;
      QueUdp.SQL.Add('execute procedure PR_UPDATEK('+inttostr(AMagID)+',0)');
      QueUdp.Execute;
      QueUdp.Close;

      QueUdp.IB_Transaction.Commit;
    except
      QueUdp.IB_Transaction.Rollback;
      raise;
    end;
  finally
    QueUdp.Close;
    FreeAndNil(QueUdp);
  end;
end;

procedure TDm_Main.AffectationGrpPump(AMagId, AMpuId, AGcpID: integer; ANomGrp: string);
var
  QueUdp: TIB_Cursor;
  GcpId: integer;
  MpuId: integer;
begin
  GcpId := AGcpId;
  MpuID := AMpuID;
  QueUdp := TIB_Cursor.Create(Self);
  try
    QueUdp.IB_Connection := DatabaseDst;
    QueUdp.IB_Transaction := Trans_MajDst;

    QueUdp.IB_Transaction.StartTransaction;
    try
      // crée le groupe de pump si besoin
      if GcpId=0 then
      begin
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('select ID from PR_NEWK(''GENGESTIONPUMP'')');
        QueUdp.Open;
        GcpId := QueUdp.FieldByName('ID').AsInteger;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('INSERT INTO GENGESTIONPUMP (GCP_ID,GCP_NOM)');
        QueUdp.SQL.Add('VALUES ('+inttostr(GcpId)+','+QuotedStr(ANomGrp)+')');
        QueUdp.Execute;
        QueUdp.Close;
      end;

      if MpuID=0 then
      begin
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('select ID from PR_NEWK(''GENMAGGESTIONPUMP'')');
        QueUdp.Open;
        MpuId := QueUdp.FieldByName('ID').AsInteger;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('INSERT INTO GENMAGGESTIONPUMP(MPU_ID,MPU_MAGID,MPU_GCPID)');
        QueUdp.SQL.Add('VALUES ('+inttostr(MpuId)+','+inttostr(AMagId)+','+inttostr(GcpId)+')');
        QueUdp.Execute;
        QueUdp.Close;
      end
      else
      begin
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('execute procedure PR_UPDATEK('+inttostr(MpuID)+',0)');
        QueUdp.Execute;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('UPDATE GENMAGGESTIONPUMP SET');
        QueUdp.SQL.Add('       MPU_MAGID='+inttostr(AMagId)+',');
        QueUdp.SQL.Add('       MPU_GCPID='+inttostr(GcpID));
        QueUdp.SQL.Add(' where MPU_ID='+inttostr(MpuID));
        QueUdp.Execute;
        QueUdp.Close;
      end;
      QueUdp.IB_Transaction.Commit;
    except
      QueUdp.IB_Transaction.Rollback;
      raise;
    end;

  finally
    QueUdp.Close;
    FreeAndNil(QueUdp);
  end;
end;

function TDm_Main.AjoutModifGrpPump(AGcpId: integer; ANomGrp: string): integer;
var
  QueUdp: TIB_Cursor;
  GcpId: integer;
begin
  Result := 0;
  GcpId := AGcpId;
  QueUdp := TIB_Cursor.Create(Self);
  try
    QueUdp.IB_Connection := DatabaseDst;
    QueUdp.IB_Transaction := Trans_MajDst;

    QueUdp.IB_Transaction.StartTransaction;
    try
      if GcpId=0 then
      begin
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('select ID from PR_NEWK(''GENGESTIONPUMP'')');
        QueUdp.Open;
        GcpId := QueUdp.FieldByName('ID').AsInteger;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('INSERT INTO GENGESTIONPUMP (GCP_ID,GCP_NOM)');
        QueUdp.SQL.Add('VALUES ('+inttostr(GcpId)+','+QuotedStr(ANomGrp)+')');
        QueUdp.Execute;
        QueUdp.Close;
      end
      else
      begin
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('execute procedure PR_UPDATEK('+inttostr(GcpId)+',0)');
        QueUdp.Execute;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('UPDATE GENGESTIONPUMP SET');
        QueUdp.SQL.Add('       GCP_NOM='+QuotedStr(ANomGrp));
        QueUdp.SQL.Add(' where GCP_ID='+inttostr(GcpID));
        QueUdp.Execute;
        QueUdp.Close;
      end;

      QueUdp.IB_Transaction.Commit;
      Result := GcpId;
    except
      QueUdp.IB_Transaction.Rollback;
      raise;
    end;

  finally
    QueUdp.Close;
    FreeAndNil(QueUdp);
  end;
end;

procedure TDm_Main.GrpPumpAuto;
var
  QueSel: TIBOQuery;
  QueUdp: TIB_Cursor;
  GcpId: integer;
  MagId: integer;
  MpuId: integer;
begin
  QueSel := TIBOQuery.Create(Self);
  QueUdp := TIB_Cursor.Create(Self);

  try
    QueSel.IB_Connection := DatabaseDst;
    QueSel.IB_Transaction := Trans_MajDst;
    QueUdp.IB_Connection := DatabaseDst;
    QueUdp.IB_Transaction := Trans_MajDst;

    // test s'il y en a pas au moins un
    QueSel.Close;
    QueSel.SQL.Clear;
    QueSel.SQL.Add('select GCP_ID from GENGESTIONPUMP');
    QueSel.SQL.Add('  join k on k_id=gcp_id and k_enabled=1');
    QueSel.SQL.Add(' where GCP_ID<>0');
    QueSel.Open;
    if QueSel.RecordCount>0 then
      exit;
    QueSel.Close;

    QueUdp.IB_Transaction.StartTransaction;
    try
      // crée le groupe de pump
      QueUdp.SQL.Clear;
      QueUdp.SQL.Add('select ID from PR_NEWK(''GENGESTIONPUMP'')');
      QueUdp.Open;
      GcpId := QueUdp.FieldByName('ID').AsInteger;
      QueUdp.Close;
      QueUdp.SQL.Clear;
      QueUdp.SQL.Add('INSERT INTO GENGESTIONPUMP (GCP_ID,GCP_NOM)');
      QueUdp.SQL.Add('VALUES ('+inttostr(GcpId)+','+QuotedStr('GROUPE PRINCIPALE')+')');
      QueUdp.Execute;
      QueUdp.Close;

      // affectation du groupe de pump sur chaque mag
      QueSel.Close;
      QueSel.SQL.Clear;
      QueSel.SQL.Add('SELECT MAG_ID FROM GENMAGASIN');
      QueSel.SQL.Add('  JOIN K ON K_ID=MAG_ID AND K_ENABLED=1');
      QueSel.SQL.Add('WHERE MAG_ID<>0');
      QueSel.Open;
      QueSel.First;
      while not(QueSel.Eof) do
      begin
        MagId := QueSel.FieldByName('MAG_ID').AsInteger;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('select ID from PR_NEWK(''GENMAGGESTIONPUMP'')');
        QueUdp.Open;
        MpuId := QueUdp.FieldByName('ID').AsInteger;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('INSERT INTO GENMAGGESTIONPUMP(MPU_ID,MPU_MAGID,MPU_GCPID)');
        QueUdp.SQL.Add('VALUES ('+inttostr(MpuId)+','+inttostr(MagId)+','+inttostr(GcpId)+')');
        QueUdp.Execute;
        QueUdp.Close;
        QueSel.Next;
      end;

      QueUdp.IB_Transaction.Commit;
    except
      QueUdp.IB_Transaction.Rollback;
      raise;
    end;

  finally
    QueSel.Close;
    FreeAndNil(QueSel);
    QueUdp.Close;
    FreeAndNil(QueUdp);
  end;
end;

{function TDm_Main.MajGrpPump(AId: integer; AGroupe: string): integer;
var
  QueUdp: TIB_Cursor;
begin
  QueUdp := TIB_Cursor.Create(Self);
  try
    QueUdp.IB_Connection := DatabaseDst;
    QueUdp.IB_Transaction := Trans_MajDst;

    QueUdp.IB_Transaction.StartTransaction;
    try
      if AId=0 then // insert
      begin
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('select ID from PR_NEWK(''GENGESTIONPUMP'')');
        QueUdp.Open;
        Result := QueUdp.FieldByName('ID').AsInteger;
        QueUdp.Close;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('INSERT INTO GENGESTIONPUMP (GCP_ID,GCP_NOM)');
        QueUdp.SQL.Add('VALUES ('+inttostr(Result)+','+QuotedStr(AGroupe)+')');
        QueUdp.Execute;
        QueUdp.Close;
      end
      else
      begin    // update
        Result := AId;
        QueUdp.SQL.Clear;
        QueUdp.SQL.Add('update GENGESTIONPUMP set');
        QueUdp.SQL.Add(' GCP_NOM='+QuotedStr(AGroupe));
        QueUdp.SQL.Add('where GCP_ID='+inttostr(AId));
        QueUdp.Execute;
        QueUdp.Close;
      end;
    except
      QueUdp.IB_Transaction.Rollback;
      raise;
    end;
  finally
    QueUdp.Close;
    FreeAndNil(QueUdp);
  end;
end;  }

function TDm_Main.GetVersionDst: string;
var
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DatabaseDst;
    QueTmp.IB_Transaction := Trans_Dst;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select * from genversion order by ver_date');
    QueTmp.Open;
    QueTmp.Last;
    Result := QueTmp.fieldbyname('VER_VERSION').AsString;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

procedure TDm_Main.ConnexionDst(ABase: string);
//var
//  QueTmp: TIBOQuery;
begin
  // retourne la version de la base
  DatabaseDst.Connected := false;
  DatabaseDst.Username := 'GINKOIA';
  DatabaseDst.Password := 'ginkoia';
  DatabaseDst.DatabaseName := AnsiString(ABase);
  DatabaseDst.Connected := true;
end;

{ TThreadRecalculStk }

constructor TThreadRecalculStk.Create;
begin
  inherited Create(true);
  sError := '';
  FreeOnTerminate := true;
end;

procedure TThreadRecalculStk.Execute;
var
  QueTabTrig: TIB_Cursor;
  QueArtRecal: TIB_Cursor;
  QueBnRecal: TIB_Cursor;
  QueActiveTrig: TIB_Cursor;
  Total: integer;
  Retour: integer;
  EtatTrigger: integer;
  NBasID: integer;
  Reste: integer;
begin
  inherited;
  EtatTrigger := 0;

  sError := '';
  QueTabTrig := TIB_Cursor.Create(nil);
  QueArtRecal := TIB_Cursor.Create(nil);
  QueBnRecal := TIB_Cursor.Create(nil);
  QueActiveTrig := TIB_Cursor.Create(nil);
  try
    QueTabTrig.IB_Connection := Dm_Main.DatabaseOri;
    QueTabTrig.IB_Transaction := Dm_Main.Trans_Ori;

    QueArtRecal.IB_Connection := Dm_Main.DatabaseOri;
    QueArtRecal.IB_Transaction := Dm_Main.Trans_Ori;

    QueBnRecal.IB_Connection := Dm_Main.DatabaseOri;
    QueBnRecal.IB_Transaction := Dm_Main.Trans_Ori;

    QueActiveTrig.IB_Connection := Dm_Main.DatabaseOri;
    QueActiveTrig.IB_Transaction := Dm_Main.Trans_Ori;

    try
      try
        // Sauvegarde etat de l'activation du trigger (lecture du Gen_ID)
        with QueActiveTrig, SQL do
        begin
          Close;
          Clear;
          Add('SELECT GEN_ID(GENTRIGGER,0) as ETAT FROM RDB$DATABASE');
          Open;
          EtatTrigger := fieldbyname('ETAT').AsInteger;
          Close;
        end;

        // query de recalcul de stock
        with QueBnRecal, SQL do
        begin
          Close;
          Clear;
          Add('Select RETOUR from BN_TRIGGERDIFFERE');
        end;

        // table GENTRIGGER
        QueTabTrig.SQL.Clear;
        QueTabTrig.SQL.Add('select count(*) as NBRE from GENTRIGGER');
        QueTabTrig.SQL.Add(' where tri_id<>0');
        QueTabTrig.Open;
        Total := QueTabTrig.FieldByName('NBRE').AsInteger;
        QueTabTrig.Close;

        // table ARTRECALCUL - BaseID
        NBasID := -1;
        QueArtRecal.SQL.Clear;
        QueArtRecal.SQL.Add('SELECT MIN(BAS_ID) as BASID');
        QueArtRecal.SQL.Add('FROM GENBASES JOIN K ON (K_ID=BAS_ID AND K_ENABLED =1)');
        QueArtRecal.SQL.Add('WHERE BAS_IDENT=(SELECT PAR_STRING FROM GENPARAMBASE WHERE PAR_NOM='+QuotedStr('IDGENERATEUR')+')');
        QueArtRecal.Open;
        NBasID := QueArtRecal.Fieldbyname('BASID').AsInteger;
        if NBasID=0 then
          NBasID := -1;
        // table ARTRECALCUL
        QueArtRecal.Close;
        QueArtRecal.SQL.Clear;
        QueArtRecal.SQL.Add('select count(distinct(rec_artid)) as NBRE  from ARTRECALCULE');
        QueArtRecal.SQL.Add('where (REC_ID<>0) and ((REC_QUOI=0) OR (REC_QUOI<> '+inttostr(NBasID)+'))');
        QueArtRecal.Open;
        Total := Total+QueArtRecal.FieldByName('NBRE').AsInteger;
        QueArtRecal.Close;

        iProgress := 0;
        iMaxProgress := Total;
        InitFrm;

        // active le trigger
        with QueActiveTrig, SQL do
        begin
          Dm_Main.Trans_Ori.StartTransaction;
          Clear;
          Add('execute procedure BN_ACTIVETRIGGER(1)');
            ExecSQL;
          Close;
          Dm_Main.Trans_Ori.Commit;
        end;

        Dm_Main.Trans_Ori.StartTransaction;
        Retour := 1;
        while Retour<>0 do
        begin
          // recalcul
          QueBnRecal.Open;
          Retour := QueBnRecal.FieldByName('RETOUR').AsInteger;
          QueBnRecal.Close;
          Dm_Main.Trans_Ori.Commit;
          Dm_Main.Trans_Ori.StartTransaction;
          // compte le reste
          // 1: table GENTRIGGER
          QueTabTrig.Open;
          Reste := QueTabTrig.FieldByName('NBRE').AsInteger;
          QueTabTrig.Close;
          // 2: table ARTRECALCUL
          QueArtRecal.Open;
          Reste := Reste+QueArtRecal.FieldByName('NBRE').AsInteger;
          QueArtRecal.Close;
          iProgress := Total-Reste;
          UpdateFrm(iProgress, Reste);
        end;
      finally
        // desactive le Trigger s'il ne l'était pas à l'origine de nouveau par sécurité
        with QueActiveTrig, SQL do
        begin
          if Dm_Main.Trans_Ori.InTransaction then
            Dm_Main.Trans_Ori.Commit;
          if EtatTrigger = 1 then
          begin
            Dm_Main.Trans_Ori.StartTransaction;
            Clear;
            Add('execute procedure BN_ACTIVETRIGGER(0)');
            try
              ExecSQL;
            except
            end;
            Close;
            EtatTrigger := 0;
            if Dm_Main.Trans_Ori.InTransaction then
              Dm_Main.Trans_Ori.Commit;
          end;
        end; // with
      end; // finally
      if Dm_Main.Trans_Ori.InTransaction then
        Dm_Main.Trans_Ori.Commit;
    except
      on E:Exception do
      begin
        if Dm_Main.Trans_Ori.InTransaction then
          Dm_Main.Trans_Ori.Rollback;
        sError := E.Message;
      end;
    end;

  finally
    QueTabTrig.Close;
    FreeAndNil(QueTabTrig);
    QueArtRecal.Close;
    FreeAndNil(QueArtRecal);
    QueBnRecal.Close;
    FreeAndNil(QueBnRecal);
    QueActiveTrig.Close;
    FreeAndNil(QueActiveTrig);
  end;
end;

procedure TThreadRecalculStk.InitFrm;
begin
  dDebut := GetTickCount;
  sEtat := '('+inttostr(iProgress)+' / '+inttostr(iMaxProgress)+')';
  sDuree := '';
  Frm_MajStk.Lab_Etat.Caption := sEtat;
  Frm_MajStk.Lab_Duree.Caption := sDuree;
  Frm_MajStk.pb_Etat.Position := 0;
  Frm_MajStk.pb_Etat.Max := iMaxProgress;
end;

procedure TThreadRecalculStk.UpdateFrm(AFait, AReste: integer);
var
  Delai: DWord;
  Sec: DWord;
  Mn: DWord;
  Heu: DWord;
begin
  sEtat := '('+inttostr(iProgress)+' / '+inttostr(iMaxProgress)+')';
  sDuree := '';
  if AFait>0 then
  begin
    Delai := (GetTickCount-dDebut);
    Delai := Round((Delai/AFait)*AReste);
    Delai := Delai div 1000;
    Sec := Delai mod 60;
    Delai := Trunc(Delai/60);
    Mn := Delai mod 60;
    Delai := Trunc(Delai/60);
    Heu :=Delai;
    if Heu<>0 then
    begin
      sDuree := inttostr(heu)+' heure';
      if Heu>1 then
        sDuree := sDuree+'s';

      sDuree := sDuree+' '+inttostr(Mn);
    end
    else if Mn<>0 then
    begin
      sDuree := inttostr(Mn)+' minute';
      if Mn>1 then
        sDuree := sDuree+'s';

      Sec := Round(Sec/15)*15;
      sDuree := sDuree+' '+inttostr(Sec);
    end
    else if Sec<>0 then
    begin
      Sec := Round(Sec/5)*5;
      sDuree := inttostr(Sec)+' seconde';
      if Sec>1 then
        sDuree := sDuree+'s';
    end;
  end;

  Frm_MajStk.Lab_Etat.Caption := sEtat;
  Frm_MajStk.Lab_Duree.Caption := sDuree;
  Frm_MajStk.pb_Etat.Position := iProgress;
end;

end.

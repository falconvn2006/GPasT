unit Main_Dm;

interface

uses
  SysUtils, Classes, DB, DBClient, IB_Components, IBODataset, IB_Access;

type
  TDm_Main = class(TDataModule)
    cds_Proc: TClientDataSet;
    DataBase: TIBODatabase;
    Transaction: TIBOTransaction;
    cds_Param: TClientDataSet;
    cds_ParamNum: TIntegerField;
    cds_ParamNom: TStringField;
    cds_ParamTipe: TIntegerField;
    cds_ParamValString: TStringField;
    cds_ParamValInteger: TIntegerField;
    cds_ParamValFloat: TFloatField;
    cds_ParamValDateTime: TDateTimeField;
    cds_ParamTxtTipe: TStringField;
    cds_EntreeIn: TClientDataSet;
    cds_SortieOut: TClientDataSet;
    cds_ParamFicProc: TStringField;
    cds_ParamSaisi: TIntegerField;
    cds_ProcOrdre: TIntegerField;
    cds_ProcFicProc: TStringField;
    cds_ProcFicCsv: TStringField;
    cds_ProcOkGrantGinkoia: TIntegerField;
    cds_ProcOkGrantRepl: TIntegerField;
    cds_ProcOkDropAfterExport: TIntegerField;
    cds_ProcRecupParam: TBooleanField;
    cds_ProcvIn: TIntegerField;
    cds_ProcvOut: TIntegerField;
    cds_ProcvInFait: TIntegerField;
    cds_ProcActif: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure cds_ParamCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    ReperBase: string;               // repertoire de l'exe
    ListeNomExport: TStringList;     // liste des noms d'export
    ListeNomReper: TStringList;      // liste des répertoires de recherche

    // passe le script (présent dans le fichier)
    procedure PassageScript(AText: string);

    // si AOkGinkoia est à false, c'est repl qui est pris en compte
    procedure GrantProcedure(AProcName: string; AOkGinkoia: boolean);
    function IsProcedureExists(AProcName:string): boolean;

    // connexion à la base
    procedure DoConnexion(ADatabaseName: string);
  end;

var
  Dm_Main: TDm_Main;

implementation

{$R *.dfm}

procedure TDm_Main.cds_ParamCalcFields(DataSet: TDataSet);
var
  sTmp: string;
begin
  case cds_Param.FieldByName('Tipe').AsInteger of
    1: sTmp := 'String';
    2: sTmp := 'Integer';
    3: sTmp := 'Float';
    4: sTmp := 'DateTime';
  else
    sTmp := '';
  end;
  cds_Param.FieldByName('TxtTipe').AsString := sTmp;
end;

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin
  // repertoire de l'exe
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  // liste des noms d'export
  ListeNomExport := TStringList.Create;

  // liste des répertoires de recherche
  ListeNomReper := TStringList.Create;

  Dm_Main.cds_Proc.Open;
end;

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(ListeNomExport);
  FreeAndNil(ListeNomReper);
end;

// passe le script (présent dans le fichier)
procedure TDm_Main.PassageScript(AText: string);
var
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DataBase;
    QueTmp.IB_Transaction := transaction;
    transaction.StartTransaction;
    try
      QueTmp.ParamCheck := false;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Text := AText;
      QueTmp.ExecSQL;
      transaction.Commit;
    except
      on E:Exception do
      begin
        transaction.Rollback;
        E.Message := 'PassageScript-> '+E.Message;
        raise;
      end;
    end;
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
    QueTmp.IB_Connection := DataBase;
    QueTmp.IB_Transaction := transaction;
    transaction.StartTransaction;
    try
      QueTmp.ParamCheck := false;
      QueTmp.SQL.Clear;
      if AOkGinkoia then
        QueTmp.SQL.Add('GRANT EXECUTE ON PROCEDURE '+AProcName+' TO GINKOIA')
      else
        QueTmp.SQL.Add('GRANT EXECUTE ON PROCEDURE '+AProcName+' TO REPL');
      QueTmp.ExecSQL;
      transaction.Commit;
    except
      on E:Exception do
      begin
        transaction.Rollback;
        E.Message := 'GrantProcedure-> '+E.Message;
        raise;
      end;
    end;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

function TDm_Main.IsProcedureExists(AProcName: string): boolean;
var
  QueTmp: TIBOQuery;
begin
  Result := false;
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := DataBase;
    QueTmp.IB_Transaction := transaction;
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

// connexion à la base
procedure TDm_Main.DoConnexion(ADatabaseName: string);
begin
  DataBase.Disconnect;
  try
    DataBase.DatabaseName := AnsiString(ADatabaseName);
    DataBase.Connect;
  except
    on E:Exception do
    begin
      E.Message := 'Pb connexion à la base: '+E.Message;
      Raise;
    end;
  end;
end;

end.

unit Base.Dados;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, Midaslib;

type
  TBaseDados = class(TDataModule)
    ADOConnectionUsuario: TADOConnection;
    CdsAx1: TClientDataSet;
    DspAx1: TDataSetProvider;
    QryAx1: TADOQuery;
    DscAx1: TDataSource;
    ADOConnectionNovoSchema: TADOConnection;
    CdsAx2: TClientDataSet;
    DspAx2: TDataSetProvider;
    QryAx2: TADOQuery;
    DscAx2: TDataSource;
    CdsAx3: TClientDataSet;
    DspAx3: TDataSetProvider;
    QryAx3: TADOQuery;
    DscAx3: TDataSource;
  private
    { Private declarations }
  public
    function ConectarNovoSchema(Banco, Usuario, Senha: string): Boolean;
    function ConectarUsuario(Banco, Usuario, Senha: string): Boolean;
    { Public declarations }
  end;

var
  BaseDados: TBaseDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TBaseDados.ConectarNovoSchema(Banco, Usuario, Senha: string): Boolean;
begin
  // Tenta conectar-se ao banco de dados
  try
    ADOConnectionNovoSchema.Close;

    ADOConnectionNovoSchema.ConnectionString :=
        'Provider=OraOLEDB.Oracle.1;'
      + 'Data Source=' + Banco + ';'
      + 'Persist Security Info=True';

    ADOConnectionNovoSchema.Open(Usuario, Senha);

    Result := ADOConnectionNovoSchema.Connected;
  except
    on e:exception do
    begin
      Result := False;
    end;
  end;
end;

function TBaseDados.ConectarUsuario(Banco, Usuario, Senha: string): Boolean;
begin
  // Tenta conectar-se ao banco de dados
  try
    ADOConnectionUsuario.Close;

    ADOConnectionUsuario.ConnectionString :=
        'Provider=OraOLEDB.Oracle.1;'
      + 'Data Source=' + Banco + ';'
      + 'Persist Security Info=True';

    ADOConnectionUsuario.Open(Usuario, Senha);

    Result := ADOConnectionUsuario.Connected;
  except
    on e:exception do
    begin
      Result := False;
    end;
  end;
end;

end.

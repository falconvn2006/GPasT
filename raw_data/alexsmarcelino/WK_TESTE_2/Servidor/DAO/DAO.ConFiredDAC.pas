unit DAO.ConFiredDAC;

interface

uses
  DAO.Conexao, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, FireDAC.DApt;


type
  TFireDacConexao = class(TInterfacedObject,IConexao)
  private
    FConexao: TFDConnection;
    FPhysPG: TFDPhysPgDriverLink;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IConexao;
    function Connection: TObject;
  end;

implementation

uses
  System.SysUtils;

{ TFireDacConexao }

function TFireDacConexao.Connection: TObject;
begin
  Result := FConexao;
end;

constructor TFireDacConexao.Create;
begin
  FConexao := TFDConnection.Create(Nil);
  FPhysPG := TFDPhysPgDriverLink.Create(Nil);
  FPhysPG.VendorLib := 'C:\alexs\WK_TESTE\Servidor\Win32\Debug\libpq.dll';
  FConexao.Params.DriverID := 'PG';
  FConexao.Params.Database := 'wk_teste';
  FConexao.Params.UserName := 'postgres';
  FConexao.Params.Password := 'postgres';
  FConexao.Connected := True;
end;

destructor TFireDacConexao.Destroy;
begin
  FreeAndNil(FConexao);
  FreeAndNil(FPhysPG);
  inherited;
end;

class function TFireDacConexao.New: IConexao;
begin
  Result := Self.Create;
end;

end.

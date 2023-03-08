unit udm;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type

  { TDM }

  TDM = class(TDataModule)
    Conexao: TZConnection;
    ZQuery1: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    function FormataCNPJ(CNPJ : string): string;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

Function TDM.FormataCNPJ(CNPJ : string): string;
begin
  Result := Copy(CNPJ,1,2)+'.'+Copy(CNPJ,3,3)+'.'+Copy(CNPJ,6,3)+'/'+Copy(CNPJ,9,4)+'-'+Copy(CNPJ,13,2);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  local : String;
begin
  local := ExtractFilePath(Paramstr(0));
  {$ifdef horse_cgi}
     Conexao.LibraryLocation := local + 'libfbclient.so';
  {$else}
     Conexao.LibraryLocation := local + 'fbclient.dll';
  {$endif}

  try
    Conexao.Connected := true;
  except on ex:exception do
    raise Exception.Create('Erro ao acessar o banco: ' + ex.Message);
  end;

end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  Conexao.Connected := False;
end;

end.


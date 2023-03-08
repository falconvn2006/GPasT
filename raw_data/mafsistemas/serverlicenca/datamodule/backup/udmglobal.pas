unit udmglobal;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type

  { TDMGlobal }

  TDMGlobal = class(TDataModule)
    Conexao: TZConnection;
    ZQuery1: TZQuery;
  private

  public
     procedure ConectarBanco;
  end;

var
  DMGlobal: TDMGlobal;

implementation

{$R *.lfm}

{ TDMGlobal }

procedure TDMGlobal.ConectarBanco;
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
end.


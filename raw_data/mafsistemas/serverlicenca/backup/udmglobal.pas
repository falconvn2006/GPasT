unit udmglobal;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type

  { TDMGlobal }

  TDMGlobal = class(TDataModule)
    Conexao: TZConnection;
    qry: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  private

  public
     procedure ConectarBanco;
  end;

var
  DMGlobal: TDMGlobal;

implementation

{$R *.lfm}

{ TDMGlobal }

procedure TDMGlobal.DataModuleCreate(Sender: TObject);
begin
end;

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
end;
end.


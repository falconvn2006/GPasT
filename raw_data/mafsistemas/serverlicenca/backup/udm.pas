unit uDM;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDM }

  TDM = class(TDataModule)
    Conexao: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

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
end;

end.


unit uWMSInventaire;

interface

uses
  uFTPFiles, Classes, uLog;

type
  TWMSInventaireFile = class(TCustomFTPGetFile)
  private
    const FCopyDirectory: string = 'C:\Ginkoia\Data\';
  protected
    procedure DoUpdateBDD; override;

    function CheckFileEntete: boolean; override;
  public
  end;

implementation

uses
  Windows, SysUtils, uCustomFTPManager;

{ TWMSInventaireFile }

function TWMSInventaireFile.CheckFileEntete: boolean;
begin

end;

procedure TWMSInventaireFile.DoUpdateBDD;
begin
  if ForceDirectories(FCopyDirectory) then
    MoveFile( PChar(getFilePath), PChar(FCopyDirectory) );
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_INVENTAIRE', ftGet, '', '', TWMSInventaireFile);
  TCustomFTPManager.RegisterKnownFile('WMS_INVENTAIRE_2', ftGet, '', '', TWMSInventaireFile);

end.

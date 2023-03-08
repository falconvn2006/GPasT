unit UZip;

interface

uses
   StdCtrls, ComCtrls, VCLUnZip, VCLZip,
   SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  TZip = class(TObject)
  protected
    FOnProgress: TTotalPercentDone;
    Zip: TVCLZip;
  public
    constructor Create(Owner: TComponent);
    destructor Destroy; override;
    procedure Unzip(Quoi, Ou: string; Pssw : String = '');
    property OnProgress: TTotalPercentDone read FOnProgress write FOnProgress;
  end;


implementation

constructor TZip.Create(Owner: TComponent);
begin
  inherited Create;
  Zip := TVCLZip.Create(Owner);
  Zip.OverwriteMode := Always;
  Zip.DoAll := True;
  Zip.DoProcessMessages := False;
  Zip.RetainAttributes := False;
  Zip.PackLevel := 9;
  Zip.ZipAction := zaReplace;
  Zip.RecreateDirs := true;
  Zip.RelativePaths := true;
  Zip.ReplaceReadOnly := true;
end;

destructor TZip.Destroy;
begin
  Zip.Free;
  inherited;
end;

procedure TZip.Unzip(Quoi, Ou: string; Pssw : String = '');
begin
  if assigned(FOnProgress) then
     Zip.OnTotalPercentDone := FOnProgress
  else
    Zip.OnTotalPercentDone := nil ;
  zip.DestDir := Ou;
  zip.ZipName := Quoi;
  zip.RootDir := ChangeFileExt(ExtractFileName(quoi), '');
  zip.Password := Pssw ;
  zip.unzip;
end;



end.


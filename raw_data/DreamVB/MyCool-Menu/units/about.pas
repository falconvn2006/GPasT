unit about;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    lblCpyToStay: TLabel;
    mnuOK: TButton;
    imgAbout: TImage;
    lblInfo: TLabel;
    lblTitle: TLabel;
    lblVer: TLabel;
    procedure mnuOKClick(Sender: TObject);
  private

  public

  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

{ TfrmAbout }

procedure TfrmAbout.mnuOKClick(Sender: TObject);
begin
  Close;
end;

end.

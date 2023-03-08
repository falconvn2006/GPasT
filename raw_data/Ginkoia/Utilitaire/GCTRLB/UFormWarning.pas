unit UFormWarning;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, ExtCtrls, cxControls, cxContainer,
  cxEdit, cxLabel, StdCtrls, cxButtons, cxGraphics, cxLookAndFeels,
  dxGDIPlusClasses;

type
  TFormWarning = class(TForm)
    imgError: TImage;
    pbottom: TPanel;
    Panel1: TPanel;
    Bevel1: TBevel;
    Button2: TcxButton;
    BEXIT: TcxButton;
    ErrorMsg: TcxLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BEXITClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Repeindre;    
  end;

var
  FormWarning: TFormWarning;

implementation

{$R *.dfm}

Uses UCommun, MainForm, UDataModule;

procedure TFormWarning.Button2Click(Sender: TObject);
begin
     Close;
end;

procedure TFormWarning.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     VAR_GLOB.RappelWarningExit:=VAR_GLOB.RappelWarningExit+1;
     Action:=CaFree;
     FormWarning:=nil;
end;

procedure TFormWarning.FormCreate(Sender: TObject);
var SysMenu: hMenu;
Begin
     SysMenu := GetSystemMenu(Handle, false);
     DeleteMenu(SysMenu, sc_close, mf_ByCommand);
     DeleteMenu(SysMenu, sc_move, mf_ByCommand);
     DeleteMenu(SysMenu, sc_size, mf_ByCommand);
end;

procedure TFormWarning.Repeindre;
begin
     If VAR_GLOB.RappelWarningExit>0 then
        begin
             lbRAPPEL.Caption:=Format('Rappel N°%0.d',[VAR_GLOB.RappelWarningExit]);
             lbRAPPEL.Visible:=true;
        end;
end;

procedure TFormWarning.BEXITClick(Sender: TObject);
begin
     If (MessageDlgWithFocus(
            'Alpiprodia va se terminer immédiatement :'+#13+#10+
            'Voulez-vous continuer ?',
                mtWarning, [mbYes, mbNo], mbNo, 0)=mrYes)
        then
            begin
                 Application.Terminate;
            end;
end;

end.

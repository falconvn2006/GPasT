unit PASSWORD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Vcl.Buttons;

type
  TFormPASSWORD = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    teSession: TEdit;
    tePASSWORD: TEdit;
    BVALIDER: TBitBtn;
    BANNULER: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFERMERClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BVALIDERClick(Sender: TObject);
    procedure BANNULERClick(Sender: TObject);
  private
    procedure VALIDER;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormPASSWORD: TFormPASSWORD;

implementation

uses UCommun, Frm_Main;

{$R *.dfm}

procedure TFormPASSWORD.FormCreate(Sender: TObject);
begin
     Randomize;
     teSession.Text:=IntToStr(Random(900)+1);
end;

procedure TFormPASSWORD.Valider;
begin
     // Controle du mot de passe
     If tePASSWORD.Text=''
        then
            begin
                 // FormUVISUOBJECT.JvBalloonHint.ActivateHint(cxMaskEditPASSWORD,'Veuillez saisir un mot de passe');
                 tePASSWORD.SetFocus;
                 Exit;
            end;
     If (Controle_PASSWORD(teSession.Text,tePASSWORD.Text)) then
       begin
            Main_Frm.UserLevel:=ServiceDeveloppement;
       end
     else
        begin
            Main_Frm.UserLevel:=ServiceClient;
        end;
     Close;
end;

procedure TFormPASSWORD.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Action := CaFree;
end;

procedure TFormPASSWORD.BANNULERClick(Sender: TObject);
begin
     Close;
end;

procedure TFormPASSWORD.BFERMERClick(Sender: TObject);
begin
     Close;
end;

procedure TFormPASSWORD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If (Key=VK_Escape) or (Key=VK_F11) then Close;
     If (Key=VK_Return) then VALIDER;
end;

procedure TFormPASSWORD.BVALIDERClick(Sender: TObject);
begin
     Valider;
end;

end.

unit ServerPrin_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrm_ServerPrin = class(TForm)
    pnl_bas: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    pnl_main: TPanel;
    lbl_ServerPrin: TLabel;
    edt_ServerPrin: TEdit;
    lbl_LetterDir: TLabel;
    cbbLetterDir: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ServerPrin: TFrm_ServerPrin;

implementation

{$R *.dfm}

procedure TFrm_ServerPrin.FormCreate(Sender: TObject);
var
  a : Char;
begin
//**** Les lettres des disques ****//
  cbbLetterDir.Clear;
  for a := 'A' to 'Z' do
    cbbLetterDir.Items.Add(a);
  //*********************************//
end;

end.

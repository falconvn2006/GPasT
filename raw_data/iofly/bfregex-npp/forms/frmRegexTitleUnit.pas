unit frmRegexTitleUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  plugin, NppForms;

type
  TfrmRegexTitle = class(TNppForm)
    edRegexTitle: TEdit;
    Label1: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegexTitle: TfrmRegexTitle;

implementation

{$R *.dfm}

procedure TfrmRegexTitle.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if (Key = Char(vk_escape)) then begin  // #27
      self.ModalResult:=mrCancel;
      self.CloseModal;
  end
  else if (Key = Char(vk_return))  then begin  // #27
      self.ModalResult:=mrOk;
      self.CloseModal;
  end
end;

end.

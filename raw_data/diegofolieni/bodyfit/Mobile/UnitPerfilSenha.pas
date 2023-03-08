unit UnitPerfilSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFrmPerfilSenha = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Rectangle1: TRectangle;
    EditSenha: TEdit;
    EditConfirmaSenha: TEdit;
    recBtnLogin: TRectangle;
    BtnSalvar: TSpeedButton;
    procedure imgFecharClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfilSenha: TFrmPerfilSenha;

implementation

{$R *.fmx}

uses DataModule.Global, uSession;

procedure TFrmPerfilSenha.BtnSalvarClick(Sender: TObject);
begin
  if(EditSenha.Text <> EditConfirmaSenha.Text)then
  begin
    ShowMessage('As senhas não conferem, digite novamente!');
    exit;
  end;

  try
    dmGlobal.EditarSenhaOnline(TSession.ID_USUARIO, EditSenha.Text);

    Close;
  except
    on E:Exception do
      ShowMessage('Erro ao alterar senha: ' + E.Message);
  end;
end;

procedure TFrmPerfilSenha.imgFecharClick(Sender: TObject);
begin
  Close;
end;

end.

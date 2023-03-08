unit UnitPerfilCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFrmPerfilCad = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Rectangle4: TRectangle;
    BtnSalvar: TSpeedButton;
    Rectangle1: TRectangle;
    EditNome: TEdit;
    EditEmail: TEdit;
    procedure imgFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfilCad: TFrmPerfilCad;

implementation

{$R *.fmx}

uses DataModule.Global, uSession, UnitPrincipal;

procedure TFrmPerfilCad.BtnSalvarClick(Sender: TObject);
begin
  try
    dmGlobal.EditarUsuarioOnline(TSession.ID_USUARIO, EditNome.Text, EditEmail.Text);
    dmGlobal.EditarUsuario(EditNome.Text, EditEmail.Text);

    TSession.NOME  := EditNome.Text;
    TSession.Email := EditEmail.Text;

    FrmPrincipal.lblNome.Text := TSession.NOME;

    Close;
  except
    on E:Exception do
      ShowMessage('Erro ao salvar dados do usuário: ' + E.Message);
  end;
end;

procedure TFrmPerfilCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmPerfilCad := nil;
end;

procedure TFrmPerfilCad.FormShow(Sender: TObject);
begin
  try
    dmGlobal.ListarUsuario;
    EditNome.Text  := dmGlobal.qryUsuario.FieldByName('nome' ).AsString;
    EditEmail.Text := dmGlobal.qryUsuario.FieldByName('email').AsString;
  except
    on E:Exception do
      ShowMessage('Erro ao carregar dados do usuário: ' + E.Message);
  end;
end;

procedure TFrmPerfilCad.imgFecharClick(Sender: TObject);
begin
  Close;
end;

end.

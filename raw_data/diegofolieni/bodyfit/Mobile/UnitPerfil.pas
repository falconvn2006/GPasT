unit UnitPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmPerfil = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    rectMeusDados: TRectangle;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    rectDesconectar: TRectangle;
    Image3: TImage;
    Image4: TImage;
    Label2: TLabel;
    rectAlterarSenha: TRectangle;
    Image5: TImage;
    Image6: TImage;
    Label3: TLabel;
    Label4: TLabel;
    procedure rectMeusDadosClick(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure rectAlterarSenhaClick(Sender: TObject);
    procedure rectDesconectarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfil: TFrmPerfil;

implementation

{$R *.fmx}

uses UnitPerfilCad, UnitPerfilSenha, DataModule.Global, UnitLogin,
  UnitPrincipal;

procedure TFrmPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmPerfil := nil;
end;

procedure TFrmPerfil.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPerfil.rectMeusDadosClick(Sender: TObject);
begin
  if not(Assigned(FrmPerfilCad))then
    Application.CreateForm(TFrmPerfilCad, FrmPerfilCad);
  FrmPerfilCad.Show;
end;

procedure TFrmPerfil.rectDesconectarClick(Sender: TObject);
begin
  try
    dmGlobal.Logout;

    if(not Assigned(FrmLogin))then
      Application.CreateForm(TFrmLogin, FrmLogin);

    Application.MainForm := FrmLogin;

    FrmLogin.Show;
    FrmPrincipal.Close;
    Close;
  except
    on E:Exception do
      ShowMessage('Erro ao desconectar: ' + E.Message);
  end;
end;

procedure TFrmPerfil.rectAlterarSenhaClick(Sender: TObject);
begin
  if not(Assigned(FrmPerfilSenha))then
    Application.CreateForm(TFrmPerfilSenha, FrmPerfilSenha);
  FrmPerfilSenha.Show;
end;

end.

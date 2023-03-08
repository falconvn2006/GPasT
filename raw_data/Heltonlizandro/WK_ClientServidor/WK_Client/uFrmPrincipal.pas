unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmMenuPadrao, Vcl.Menus, uFrmPadrao,
  Vcl.ComCtrls;

type
  TFrmPrincipal = class(TFrmMenuPadrao)
    MenuPrincipal: TMainMenu;
    Cadastro1: TMenuItem;
    Clientes1: TMenuItem;
    procedure Clientes1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses F_Funcao, uFrmCadPessoa;


procedure TFrmPrincipal.Clientes1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TFrmCadPessoa, FrmCadPessoa);
  FrmCadPessoa.ShowModal;
  FrmCadPessoa.Free;
end;

end.

unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TfPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Contato1: TMenuItem;
    Pesquisa1: TMenuItem;
    procedure Contato1Click(Sender: TObject);
    procedure Pesquisa1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.dfm}

uses uCadastro, uPesquisa, uDM;

procedure TfPrincipal.Contato1Click(Sender: TObject);
begin
   fCadastro := TfCadastro.Create(self);
   fCadastro.ShowModal;
end;

procedure TfPrincipal.FormShow(Sender: TObject);
begin
 DM.Conexao.Connected:=true;
end;

procedure TfPrincipal.Pesquisa1Click(Sender: TObject);
begin
   fPesquisa := TfPesquisa.Create(self);
   fPesquisa.ShowModal;
end;

end.

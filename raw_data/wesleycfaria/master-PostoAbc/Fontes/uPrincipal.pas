unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DBXpress, DB, SqlExpr;

type
  TfPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    anques1: TMenuItem;
    Bombas1: TMenuItem;
    Movimentos1: TMenuItem;
    Abastecimentos1: TMenuItem;
    Relatrios1: TMenuItem;
    Abastecimentos2: TMenuItem;
    SQLConnection1: TSQLConnection;
    procedure anques1Click(Sender: TObject);
    procedure Bombas1Click(Sender: TObject);
    procedure Abastecimentos1Click(Sender: TObject);
    procedure Abastecimentos2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses CadastroTanque, CadastroBomba, MovimentoAbastecimento,
  RelatorioAbastecimento;

{$R *.dfm}

procedure TfPrincipal.anques1Click(Sender: TObject);
begin
  if (fCadastroTanque = nil) then
  begin
    Application.CreateForm(TfCadastroTanque, fCadastroTanque);
  end;

  fCadastroTanque.Show();
end;

procedure TfPrincipal.Bombas1Click(Sender: TObject);
begin
  if (fCadastroBomba = nil) then
  begin
    Application.CreateForm(TfCadastroBomba, fCadastroBomba);
  end;

  fCadastroBomba.Show();
end;

procedure TfPrincipal.Abastecimentos1Click(Sender: TObject);
begin
  if (fMovimentoAbastecimento = nil) then
  begin
    Application.CreateForm(TfMovimentoAbastecimento, fMovimentoAbastecimento);
  end;

  fMovimentoAbastecimento.Show();
end;

procedure TfPrincipal.Abastecimentos2Click(Sender: TObject);
begin
  if (fRelatorioAbastecimento = nil) then
  begin
    Application.CreateForm(TfRelatorioAbastecimento, fRelatorioAbastecimento);
  end;

  fRelatorioAbastecimento.Show();
end;

end.

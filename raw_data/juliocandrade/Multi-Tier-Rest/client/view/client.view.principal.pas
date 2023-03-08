unit client.view.principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmPrincipal = class(TForm)
    pnlPrincipal: TPanel;
    pnlMenu: TPanel;
    btnPessoas: TSpeedButton;
    btnPessoasLote: TSpeedButton;
    btnSair: TSpeedButton;
    pnlTop: TPanel;
    lblPage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnPessoasLoteClick(Sender: TObject);
    procedure btnPessoasClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
    procedure AplicarEstilo;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  client.model.principal,
  client.view.pessoas,
  client.view.pessoas.lote, client.view.Style;

{$R *.dfm}

procedure TfrmPrincipal.AplicarEstilo;
begin
  pnlTop.Color := COR_TEMA;
  pnlPrincipal.Color := COR_FUNDO;
  pnlMenu.Color := COR_FUNDO_MENU
end;

procedure TfrmPrincipal.btnPessoasClick(Sender: TObject);
begin
  frmPessoas.Show;
end;

procedure TfrmPrincipal.btnPessoasLoteClick(Sender: TObject);
begin
  frmPessoasLote.Show;
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Halt;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  AplicarEstilo;
  dmPrincipal.ServerURL('http://localhost:3000');
end;

end.

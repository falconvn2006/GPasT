unit FinanceiroPessoal.View.CadastroPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.WinXPanels, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList;

type
  TfrmCadastroPadrao = class(TForm)
    pnlPrincipal: TCardPanel;
    CardCadastro: TCard;
    CardPesquisa: TCard;
    pnlPesquisa: TPanel;
    pnlPesquisaBotoes: TPanel;
    pnlGrid: TPanel;
    DBGrid1: TDBGrid;
    edtPesquisa: TEdit;
    Label1: TLabel;
    btnPesquisar: TButton;
    ImageList1: TImageList;
    btnIncluir: TButton;
    btinAlterar: TButton;
    btnExcluir: TButton;
    btnImprimir: TButton;
    btnSair: TButton;
    Panel1: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure btnIncluirClick(Sender: TObject);
    procedure btinAlterarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    procedure ChamaCardCadastro;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroPadrao: TfrmCadastroPadrao;

implementation

{$R *.dfm}

procedure TfrmCadastroPadrao.btinAlterarClick(Sender: TObject);
begin
  ChamaCardCadastro;
end;

procedure TfrmCadastroPadrao.btnIncluirClick(Sender: TObject);
begin
  ChamaCardCadastro;
end;

procedure TfrmCadastroPadrao.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroPadrao.ChamaCardCadastro;
begin
  pnlPrincipal.ActiveCard := CardCadastro;
end;

end.

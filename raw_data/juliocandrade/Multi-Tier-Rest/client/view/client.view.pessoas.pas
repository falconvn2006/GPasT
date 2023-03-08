unit client.view.pessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.WinXPanels,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls, client.controller.interfaces;

type
  TTypeOperacao = (toNull, toIncluir, toAlterar);
  TfrmPessoas = class(TForm)
    pnlPrincipal: TPanel;
    pnlTop: TPanel;
    lblPage: TLabel;
    pnlBody: TPanel;
    CardPanel1: TCardPanel;
    cardGrid: TCard;
    pnlGridTop: TPanel;
    btnNovo: TSpeedButton;
    btnAtualizar: TSpeedButton;
    pnlCardBody: TPanel;
    pnlGridBottom: TPanel;
    lblRegistros: TLabel;
    pnlGrid: TPanel;
    gridDados: TDBGrid;
    cardCadastro: TCard;
    pnlCadastroBody: TPanel;
    pnlCadastroCampos: TPanel;
    StackPessoa: TStackPanel;
    Label1: TLabel;
    edtID: TEdit;
    Label2: TLabel;
    edtNatureza: TEdit;
    Label3: TLabel;
    edtPrimeiroNome: TEdit;
    pnlCadastroBottom: TPanel;
    btnSalvar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnFecharCadastro: TSpeedButton;
    Label4: TLabel;
    edtSegundoNome: TEdit;
    edtDocumento: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtCEP: TEdit;
    DataSource: TDataSource;
    stackEnderecoIntegracao: TStackPanel;
    Label7: TLabel;
    edtUF: TEdit;
    Label8: TLabel;
    edtCidade: TEdit;
    Label9: TLabel;
    edtBairro: TEdit;
    Label10: TLabel;
    edtLogradouro: TEdit;
    Label11: TLabel;
    edtComplemento: TEdit;
    btnFecharTela: TSpeedButton;
    procedure btnAtualizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDadosDblClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharCadastroClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharTelaClick(Sender: TObject);
  private
    { Private declarations }
    FTypeOperacao : TTypeOperacao;
    FController : iController;
    procedure AplicarEstilo;
    procedure LimparCampos;
    procedure Pesquisar;
    procedure PreencherCampos;
  public
    { Public declarations }
  end;

var
  frmPessoas: TfrmPessoas;

implementation

{$R *.dfm}

uses
  client.model.principal,
  client.view.Style,
  client.controller.factory;

{ Tfrm }

procedure TfrmPessoas.AplicarEstilo;
begin
  pnlTop.Color := COR_TOPO_CADASTRO;
  pnlPrincipal.Color := COR_FUNDO;
  pnlGrid.Color := COR_FUNDO_MENU;
end;

procedure TfrmPessoas.btnAtualizarClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmPessoas.btnExcluirClick(Sender: TObject);
begin
  FController
    .Pessoa
      .Entity
        .ID(edtID.Text)
      .&End
      .Services
        .Excluir;

  CardPanel1.ActiveCard := CardGrid;
  Pesquisar;
end;

procedure TfrmPessoas.btnFecharCadastroClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := CardGrid;

end;

procedure TfrmPessoas.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  FTypeOperacao := toIncluir;
  CardPanel1.ActiveCard := CardCadastro;
end;

procedure TfrmPessoas.btnSalvarClick(Sender: TObject);
begin
  FController
    .Pessoa
      .Entity
        .Natureza(edtNatureza.Text)
        .Documento(edtDocumento.Text)
        .PrimeiroNome(edtPrimeiroNome.Text)
        .SegundoNome(edtSegundoNome.Text)
        .CEP(edtCEP.Text)
        .UF(edtUF.Text)
        .Cidade(edtCidade.Text)
        .Bairro(edtBairro.Text)
        .Logradouro(edtLogradouro.Text)
        .Complemento(edtComplemento.Text);

  case FTypeOperacao of
    toIncluir: FController.Pessoa.Services.Inserir;
    toAlterar: FController.Pessoa.Entity.ID(edtID.Text).&End.Services.Alterar;
  end;
  CardPanel1.ActiveCard := CardGrid;
  Pesquisar;
end;

procedure TfrmPessoas.FormCreate(Sender: TObject);
begin
  AplicarEstilo;
  FTypeOperacao := toNull;
  FController := TController.New;
end;

procedure TfrmPessoas.FormShow(Sender: TObject);
begin
  CardPanel1.ActiveCard := cardGrid;
  Pesquisar;
end;

procedure TfrmPessoas.gridDadosDblClick(Sender: TObject);
begin
  PreencherCampos;
  FTypeOperacao := toAlterar;
  CardPanel1.ActiveCard := CardCadastro;
end;

procedure TfrmPessoas.LimparCampos;
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(ComponentCount) do
  begin
    if Components[Contador] is TCustomEdit then
      TCustomEdit(Components[Contador]).Clear
  end;
end;

procedure TfrmPessoas.Pesquisar;
var
  s : string;
begin
  dmPrincipal.Pesquisar;
  s := 's';
  if DataSource.DataSet.RecordCount = 1 then
    s := '';

  lblRegistros.Caption := Format('%d registro%s encontrado%s', [DataSource.DataSet.RecordCount, s, s]);
end;

procedure TfrmPessoas.PreencherCampos;
begin
  edtId.Text := datasource.DataSet.FieldByName('id').AsString;
  edtNatureza.Text := datasource.DataSet.FieldByName('natureza').AsString;
  edtDocumento.Text := datasource.DataSet.FieldByName('documento').AsString;
  edtPrimeiroNome.Text := datasource.DataSet.FieldByName('primeironome').AsString;
  edtSegundoNome.Text := datasource.DataSet.FieldByName('segundonome').AsString;
  edtCEP.Text := datasource.DataSet.FieldByName('endereco.cep').AsString;

  edtUF.Text := datasource.DataSet.FieldByName('enderecointegracao.uf').AsString;
  edtCidade.Text := datasource.DataSet.FieldByName('enderecointegracao.cidade').AsString;
  edtBairro.Text := datasource.DataSet.FieldByName('enderecointegracao.bairro').AsString;
  edtLogradouro.Text := datasource.DataSet.FieldByName('enderecointegracao.logradouro').AsString;
  edtComplemento.Text := datasource.DataSet.FieldByName('enderecointegracao.complemento').AsString;
end;

procedure TfrmPessoas.btnFecharTelaClick(Sender: TObject);
begin
  Close;
end;

end.

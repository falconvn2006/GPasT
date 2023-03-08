unit client.view.pessoas.lote;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.WinXPanels,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  client.controller.interfaces;

type
  TTypeOperacao = (toNull, toIncluir, toAlterar);
  TfrmPessoasLote = class(TForm)
    pnlPrincipal: TPanel;
    pnlTop: TPanel;
    lblPage: TLabel;
    pnlBody: TPanel;
    CardPanel1: TCardPanel;
    cardGrid: TCard;
    pnlGridTop: TPanel;
    btnNovo: TSpeedButton;
    btnEnviar: TSpeedButton;
    pnlCardBody: TPanel;
    pnlGridBottom: TPanel;
    lblRegistros: TLabel;
    pnlGrid: TPanel;
    cardCadastro: TCard;
    pnlCadastroBody: TPanel;
    pnlCadastroCampos: TPanel;
    StackPessoa: TStackPanel;
    Label1: TLabel;
    edtID: TEdit;
    Label2: TLabel;
    edtNatureza: TEdit;
    Label3: TLabel;
    edtDocumento: TEdit;
    Label5: TLabel;
    edtPrimeiroNome: TEdit;
    Label4: TLabel;
    edtSegundoNome: TEdit;
    Label6: TLabel;
    edtCEP: TEdit;
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
    pnlCadastroBottom: TPanel;
    btnSalvar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnFechar: TSpeedButton;
    DataSource: TDataSource;
    btnFecharTela: TSpeedButton;
    listPessoas: TListView;
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnFecharTelaClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure listPessoasDblClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
  private
    { Private declarations }
    FTypeOperacao : TTypeOperacao;
    FController : iController;
    procedure AplicarEstilo;
    procedure LimparCampos;
    procedure AdcionarItemGrid(id : Integer);
    procedure RemoverItemGrid;
    procedure AtualizarItemGrid;
    procedure PreencherCampos;
    procedure AtualizarLabelRegistros;
    procedure LimparGrid;
  public
    { Public declarations }
  end;

var
  frmPessoasLote: TfrmPessoasLote;

implementation

uses
  client.controller.factory,
  client.view.Style;

{$R *.dfm}

procedure TfrmPessoasLote.AplicarEstilo;
begin
  pnlTop.Color := COR_TOPO_CADASTRO;
  pnlPrincipal.Color := COR_FUNDO;
  pnlGrid.Color := COR_FUNDO_MENU;
end;

procedure TfrmPessoasLote.AtualizarItemGrid;
var
  LList : TListItem;
begin
  LList := listPessoas.Selected;
  LList.SubItems[0] := edtNatureza.Text;
  LList.SubItems[1] := edtDocumento.Text;
  LList.SubItems[2] := edtPrimeiroNome.Text;
  LList.SubItems[3] := edtSegundoNome.Text;

  LList.SubItems[4] := edtCEP.Text;

  LList.SubItems[5] := edtUF.Text;
  LList.SubItems[6] := edtCidade.Text;
  LList.SubItems[7] := edtBairro.Text;
  LList.SubItems[8] := edtLogradouro.Text;
  LList.SubItems[9] := edtComplemento.Text;
end;

procedure TfrmPessoasLote.AtualizarLabelRegistros;
var
  S : String;
begin
  s := 's';
  if listPessoas.GetCount = 1 then
    s := '';

  lblRegistros.Caption := Format('%d registro%s para enviar', [listPessoas.GetCount, s]);
end;

procedure TfrmPessoasLote.btnEnviarClick(Sender: TObject);
begin
  FController
    .Pessoa
      .Services
        .InserirLote;
  LimparGrid;
  ShowMessage('Registros enviados com sucesso.');
end;

procedure TfrmPessoasLote.btnExcluirClick(Sender: TObject);
var
  LIDItem : Integer;
begin
  LIDItem := StrToInt(edtID.Text);

  FController
    .Pessoa
      .Lista
        .RemoverPessoa(LIDItem);

  RemoverItemGrid;
  CardPanel1.ActiveCard := CardGrid;
end;

procedure TfrmPessoasLote.btnFecharClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := CardGrid;
end;

procedure TfrmPessoasLote.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  FTypeOperacao := toIncluir;
  CardPanel1.ActiveCard := CardCadastro;
end;

procedure TfrmPessoasLote.btnSalvarClick(Sender: TObject);
var
  LIDItem : Integer;
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
    toIncluir:
    begin
      LIDItem := FController.Pessoa.Lista.AdicionarPessoa;
      AdcionarItemGrid(LIDItem);
    end;
    toAlterar:
    begin
      LIDItem := StrToInt(listPessoas.Selected.Caption);
      FController.Pessoa.Lista.AtualizarPessoa(LIDItem);
      AtualizarItemGrid;
    end;
  end;

  CardPanel1.ActiveCard := CardGrid;
end;

procedure TfrmPessoasLote.FormCreate(Sender: TObject);
begin
  FController := TController.New;
  AtualizarLabelRegistros;
  AplicarEstilo;
end;

procedure TfrmPessoasLote.LimparCampos;
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(ComponentCount) do
  begin
    if Components[Contador] is TCustomEdit then
      TCustomEdit(Components[Contador]).Clear
  end;
end;

procedure TfrmPessoasLote.LimparGrid;
begin
  FController
    .Pessoa
      .Lista
      .LimparLista;
  ListPessoas.Clear;
  AtualizarLabelRegistros;
end;

procedure TfrmPessoasLote.listPessoasDblClick(Sender: TObject);
begin
  if not Assigned(listPessoas.Selected) then
    exit;

  PreencherCampos;
  FTypeOperacao := toAlterar;
  CardPanel1.ActiveCard := CardCadastro;
end;

procedure TfrmPessoasLote.AdcionarItemGrid(id : Integer);
var
  LList : TListItem;
begin
  LList := listPessoas.Items.Add;
  LList.Caption := id.ToString;
  LList.SubItems.Add(edtNatureza.Text);
  LList.SubItems.Add(edtDocumento.Text);
  LList.SubItems.Add(edtPrimeiroNome.Text);
  LList.SubItems.Add(edtSegundoNome.Text);

  LList.SubItems.Add(edtCEP.Text);

  LList.SubItems.Add(edtUF.Text);
  LList.SubItems.Add(edtCidade.Text);
  LList.SubItems.Add(edtBairro.Text);
  LList.SubItems.Add(edtLogradouro.Text);
  LList.SubItems.Add(edtComplemento.Text);
  AtualizarLabelRegistros
end;

procedure TfrmPessoasLote.PreencherCampos;
begin
  edtId.Text := listPessoas.Selected.Caption;
  edtNatureza.Text := listPessoas.Selected.SubItems[0];
  edtDocumento.Text := listPessoas.Selected.SubItems[1];
  edtPrimeiroNome.Text := listPessoas.Selected.SubItems[2];
  edtSegundoNome.Text := listPessoas.Selected.SubItems[3];
  edtCEP.Text := listPessoas.Selected.SubItems[4];

  edtUF.Text := listPessoas.Selected.SubItems[5];
  edtCidade.Text := listPessoas.Selected.SubItems[6];
  edtBairro.Text := listPessoas.Selected.SubItems[7];
  edtLogradouro.Text := listPessoas.Selected.SubItems[8];
  edtComplemento.Text := listPessoas.Selected.SubItems[9];
end;

procedure TfrmPessoasLote.RemoverItemGrid;
begin
  listPessoas.DeleteSelected;
  AtualizarLabelRegistros
end;

procedure TfrmPessoasLote.btnFecharTelaClick(Sender: TObject);
begin
  Close;
end;

end.

unit frmProdutosCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCadastro, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TformProdutosCadastro = class(TformCadastro)
    LabelNameProdutos: TLabel;
    DBEditNomeProduto: TDBEdit;
    LabelValor: TLabel;
    DBEditValorProduto: TDBEdit;
    DBRadioGroup1: TDBRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConsultaClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure dsCadastroStateChange(Sender: TObject);
    procedure dsCadastroDataChange(Sender: TObject; Field: TField);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formProdutosCadastro:  TformProdutosCadastro;

implementation

{$R *.dfm}

uses dmProdutos, frmProdutosConsulta;



procedure TformProdutosCadastro.btnCancelarClick(Sender: TObject);
begin
  inherited;
  dtmProdutos.Cancelar;
end;


procedure TformProdutosCadastro.btnConsultaClick(Sender: TObject);
begin
  inherited;
  formProdutosConsulta := TformProdutosConsulta.Create(self);
  try
    dtmProdutos.fdqConsulta.Close;
    dtmProdutos.fdqConsulta.Open;
    if formProdutosConsulta.ShowModal = mrOk then
    begin
      dtmProdutos.cdsCadastro.Refresh;
      dtmProdutos.cdsCadastro.Locate('idProduto', dtmProdutos.fdqConsultaidProduto.AsInteger, []); // id desejado
    end;
  finally
    FreeAndNil(formProdutosConsulta);
  end;
end;

procedure TformProdutosCadastro.btnExcluirClick(Sender: TObject);
begin
  inherited;
  dtmProdutos.Excluir;
end;


procedure TformProdutosCadastro.btnGravarClick(Sender: TObject);
begin
  inherited;
  dtmProdutos.Gravar;
end;

procedure TformProdutosCadastro.btnNovoClick(Sender: TObject);
begin
  inherited;
  dtmProdutos.Novo;
end;


procedure TformProdutosCadastro.dsCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  // chamada ao eventos já existente para não precisar redigitar.
  dsCadastroStateChange(Sender);
end;

procedure TformProdutosCadastro.dsCadastroStateChange(Sender: TObject);
begin
  inherited;
  // permite habilitar ou desabilitar conforme operação que está sendo realizada.
  btnNovo.Enabled := not (dsCadastro.DataSet.State in dsEditModes);
  btnGravar.Enabled := dsCadastro.DataSet.State in dsEditModes;
  btnCancelar.Enabled := dsCadastro.DataSet.State in dsEditModes;
  btnExcluir.Enabled := not (dsCadastro.DataSet.State in dsEditModes)
end;



end.

unit frmFuncionariosCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCadastro, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TformFuncionariosCadastro = class(TformCadastro)
    LabelNameProdutos: TLabel;
    DBEditNomeFunc: TDBEdit;
    LabelCPFFunc: TLabel;
    DBEditValorFunc: TDBEdit;
    DBEdit1: TDBEdit;
    LabelTelFun: TLabel;
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
  formFuncionariosCadastro:  TformFuncionariosCadastro;

implementation

{$R *.dfm}

uses dmFuncionarios, frmFuncionariosConsulta;



procedure TformFuncionariosCadastro.btnCancelarClick(Sender: TObject);
begin
  inherited;
  dtmFuncionarios.Cancelar;
end;


procedure TformFuncionariosCadastro.btnConsultaClick(Sender: TObject);
begin
  inherited;
  formFuncionariosConsulta := TformFuncionariosConsulta.Create(self);
  try
    dtmFuncionarios.fdqConsulta.Close;
    dtmFuncionarios.fdqConsulta.Open;
    if formFuncionariosConsulta.ShowModal = mrOk then
    begin
      dtmFuncionarios.cdsCadastro.Refresh;
      dtmFuncionarios.cdsCadastro.Locate('idFuncionario', dtmFuncionarios.fdqConsultaidFuncionario.AsInteger, []); // id desejado
    end;
  finally
    FreeAndNil(formFuncionariosConsulta);
  end;
end;

procedure TformFuncionariosCadastro.btnExcluirClick(Sender: TObject);
begin
  inherited;
  dtmFuncionarios.Excluir;
end;


procedure TformFuncionariosCadastro.btnGravarClick(Sender: TObject);
begin
  inherited;
  dtmFuncionarios.Gravar;
end;

procedure TformFuncionariosCadastro.btnNovoClick(Sender: TObject);
begin
  inherited;
  dtmFuncionarios.Novo;
end;


procedure TformFuncionariosCadastro.dsCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  // chamada ao eventos já existente para não precisar redigitar.
  dsCadastroStateChange(Sender);
end;

procedure TformFuncionariosCadastro.dsCadastroStateChange(Sender: TObject);
begin
  inherited;
  // permite habilitar ou desabilitar conforme operação que está sendo realizada.
  btnNovo.Enabled := not (dsCadastro.DataSet.State in dsEditModes);
  btnGravar.Enabled := dsCadastro.DataSet.State in dsEditModes;
  btnCancelar.Enabled := dsCadastro.DataSet.State in dsEditModes;
  btnExcluir.Enabled := not (dsCadastro.DataSet.State in dsEditModes)
end;



end.

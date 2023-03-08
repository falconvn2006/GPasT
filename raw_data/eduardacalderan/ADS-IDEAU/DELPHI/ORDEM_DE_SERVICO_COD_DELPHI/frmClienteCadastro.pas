unit frmClienteCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCadastro, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TformCadastro2 = class(TformCadastro)
    LabelNameCliente: TLabel;
    DBEdit1: TDBEdit;
    LabelCPF: TLabel;
    DBEdit2: TDBEdit;
    LabelTelefone: TLabel;
    DBEdit3: TDBEdit;
    LabelEndereco: TLabel;
    DBEdit4: TDBEdit;
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
  formCadastro2: TformCadastro2;

implementation

{$R *.dfm}

uses dmCliente, frmClienteConsulta;



procedure TformCadastro2.btnCancelarClick(Sender: TObject);
begin
  inherited;
  dtmClientes.Cancelar;
end;


procedure TformCadastro2.btnConsultaClick(Sender: TObject);
begin
  inherited;
  formConsulta2 := TformConsulta2.Create(self);
  try
    dtmClientes.fdqConsulta.Close;
    dtmClientes.fdqConsulta.Open;
    if formConsulta2.ShowModal = mrOk then
    begin
      dtmClientes.cdsCadastro.Refresh;
      dtmClientes.cdsCadastro.Locate('idCliente', dtmClientes.fdqConsultaidcliente.AsInteger, []); // id desejado
    end;
  finally
    FreeAndNil(formConsulta2);
  end;
end;

procedure TformCadastro2.btnExcluirClick(Sender: TObject);
begin
  inherited;
  dtmClientes.Excluir;
end;


procedure TformCadastro2.btnGravarClick(Sender: TObject);
begin
  inherited;
  dtmClientes.Gravar;
end;

procedure TformCadastro2.btnNovoClick(Sender: TObject);
begin
  inherited;
  dtmClientes.Novo;
end;


procedure TformCadastro2.dsCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  // chamada ao eventos já existente para não precisar redigitar.
  dsCadastroStateChange(Sender);
end;

procedure TformCadastro2.dsCadastroStateChange(Sender: TObject);
begin
  inherited;
  // permite habilitar ou desabilitar conforme operação que está sendo realizada.
  btnNovo.Enabled := not (dsCadastro.DataSet.State in dsEditModes);
  btnGravar.Enabled := dsCadastro.DataSet.State in dsEditModes;
  btnCancelar.Enabled := dsCadastro.DataSet.State in dsEditModes;
  btnExcluir.Enabled := not (dsCadastro.DataSet.State in dsEditModes)
end;

end.

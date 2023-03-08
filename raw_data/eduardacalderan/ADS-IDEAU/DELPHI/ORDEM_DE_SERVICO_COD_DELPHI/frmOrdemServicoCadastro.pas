unit frmOrdemServicoCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCadastroDetalhe, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls;

type
  TformOrdemServicoCadastro = class(TformCadastroDetalhe)
    Label1: TLabel;
    DBEditIDOS: TDBEdit;
    Label2: TLabel;
    DBEditEmissao: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    DBEditValorTotal: TDBEdit;
    DBLookupComboBoxCliente: TDBLookupComboBox;
    LabelStatus: TLabel;
    DBLookupComboBoxStatus: TDBLookupComboBox;
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConsultaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formOrdemServicoCadastro: TformOrdemServicoCadastro;

implementation

{$R *.dfm}

uses dmOrdemServico, frmOrdemServicoConsulta;

procedure TformOrdemServicoCadastro.btnCancelarClick(Sender: TObject);
begin
  inherited;
  dtmOrdemServico.Cancelar;
end;

procedure TformOrdemServicoCadastro.btnConsultaClick(Sender: TObject);
begin
  inherited;
  formOrdemServicoConsulta := TformOrdemServicoConsulta.Create(self);
  try
    dtmOrdemServico.fdqConsulta.Close;
    dtmOrdemServico.fdqConsulta.Open;
    if formOrdemServicoConsulta.ShowModal = mrOk then
    begin
      dtmOrdemServico.cdsCadastro.Refresh;
      dtmOrdemServico.cdsCadastro.Locate('idOs', dtmOrdemServico.fdqConsultaidOS.AsInteger, []);
    end;
  finally
    FreeAndNil(formOrdemServicoConsulta);
  end;
end;

procedure TformOrdemServicoCadastro.btnExcluirClick(Sender: TObject);
begin
  inherited;
  dtmOrdemServico.Excluir;
end;

procedure TformOrdemServicoCadastro.btnGravarClick(Sender: TObject);
begin
  inherited;
  dtmOrdemServico.Gravar;
end;

procedure TformOrdemServicoCadastro.btnNovoClick(Sender: TObject);
begin
  inherited;
  dtmOrdemServico.Novo;
end;

end.

unit U_CadastroClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, U_FormMain, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask;

type
  Tfrm_CadClientes = class(Tfrm_Principal)
    fd_QueryCadastroCONTROLE_CLIENTES: TIntegerField;
    fd_QueryCadastroRAZAO_SOCIAL: TStringField;
    fd_QueryCadastroFANTASIA: TStringField;
    fd_QueryCadastroCPF_CNPJ: TStringField;
    fd_QueryCadastroTIPO_FJ: TStringField;
    fd_QueryCadastroNOME: TStringField;
    fd_QueryCadastroEMAIL: TStringField;
    fd_QueryCadastroSITE: TStringField;
    fd_QueryCadastroBAIRRO: TStringField;
    fd_QueryCadastroENDERECO: TStringField;
    fd_QueryCadastroCOMPLEMENTO: TStringField;
    fd_QueryCadastroNUMERO: TStringField;
    fd_QueryCadastroIE_RG: TStringField;
    lb_controle: TLabel;
    txt_controle: TDBEdit;
    Label2: TLabel;
    txt_razao: TDBEdit;
    Label3: TLabel;
    txt_fantasia: TDBEdit;
    Label4: TLabel;
    txt_CNPJCPF: TDBEdit;
    cbbox_tipopessoa: TDBComboBox;
    Label5: TLabel;
    Label6: TLabel;
    txt_nome: TDBEdit;
    Label7: TLabel;
    txt_email: TDBEdit;
    Label8: TLabel;
    txt_site: TDBEdit;
    Label9: TLabel;
    txt_endereco: TDBEdit;
    Label10: TLabel;
    txt_bairro: TDBEdit;
    Label11: TLabel;
    txt_complemento: TDBEdit;
    Label12: TLabel;
    txt_numero: TDBEdit;
    Label13: TLabel;
    txt_ierg: TDBEdit;
    fd_QueryCadastroDT_EXCLUIDO: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_CadClientes: Tfrm_CadClientes;

implementation

{$R *.dfm}

procedure Tfrm_CadClientes.btn_gravarClick(Sender: TObject);
begin
  inherited;
  txt_controle.Enabled     := false;
  txt_razao.Enabled        := false;
  txt_fantasia.Enabled     := false;
  txt_CNPJCPF.Enabled      := false;
  txt_nome.Enabled         := false;
  txt_email.Enabled        := false;
  txt_site.Enabled         := false;
  txt_endereco.Enabled     := false;
  txt_bairro.Enabled       := false;
  txt_complemento.Enabled  := false;
  txt_numero.Enabled       := false;
  txt_ierg.Enabled         := false;
  cbbox_tipopessoa.Enabled := false;

  txt_controle.Clear;
  txt_controle.Clear;
  txt_razao.Clear;
  txt_fantasia.Clear;
  txt_CNPJCPF.Clear;
  txt_nome.Clear;
  txt_email.Clear;
  txt_site.Clear;
  txt_endereco.Clear;
  txt_bairro.Clear;
  txt_complemento.Clear;
  txt_numero.Clear;
  txt_ierg.Clear;
  //cbbox_tipopessoa.Clear;
end;

procedure Tfrm_CadClientes.btn_novoClick(Sender: TObject);
begin
  inherited;
  //txt_controle.Enabled     := true;
  txt_razao.Enabled        := true;
  txt_fantasia.Enabled     := true;
  txt_CNPJCPF.Enabled      := true;
  txt_nome.Enabled         := true;
  txt_email.Enabled        := true;
  txt_site.Enabled         := true;
  txt_endereco.Enabled     := true;
  txt_bairro.Enabled       := true;
  txt_complemento.Enabled  := true;
  txt_numero.Enabled       := true;
  txt_ierg.Enabled         := true;
  cbbox_tipopessoa.Enabled := true;

end;

procedure Tfrm_CadClientes.FormCreate(Sender: TObject);
begin
  inherited;
  txt_controle.Enabled     := false;
  txt_razao.Enabled        := false;
  txt_fantasia.Enabled     := false;
  txt_CNPJCPF.Enabled      := false;
  txt_nome.Enabled         := false;
  txt_email.Enabled        := false;
  txt_site.Enabled         := false;
  txt_endereco.Enabled     := false;
  txt_bairro.Enabled       := false;
  txt_complemento.Enabled  := false;
  txt_numero.Enabled       := false;
  txt_ierg.Enabled         := false;
  cbbox_tipopessoa.Enabled := false;

  txt_controle.Clear;
  txt_controle.Clear;
  txt_razao.Clear;
  txt_fantasia.Clear;
  txt_CNPJCPF.Clear;
  txt_nome.Clear;
  txt_email.Clear;
  txt_site.Clear;
  txt_endereco.Clear;
  txt_bairro.Clear;
  txt_complemento.Clear;
  txt_numero.Clear;
  txt_ierg.Clear;
  //cbbox_tipopessoa.Clear;


end;

end.

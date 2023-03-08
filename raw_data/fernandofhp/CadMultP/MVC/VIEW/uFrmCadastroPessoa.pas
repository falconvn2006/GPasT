unit uFrmCadastroPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls, Control.Pessoa,
  Model.Pessoa, Datasnap.DBClient, Lib.Biblioteca, Model.Endereco,
  Model.Endereco.Integracao;

type
  TfrmCadastroPessoa = class(TForm)
    Panel1: TPanel;
    edtChaveBusca: TLabeledEdit;
    btnPesqisar: TBitBtn;
    dbgridLista: TDBGrid;
    Panel3: TPanel;
    ProgBar: TProgressBar;
    cdLista: TClientDataSet;
    dsLista: TDataSource;
    btnSair: TBitBtn;
    Panel4: TPanel;
    edtIdPessoa: TLabeledEdit;
    edtFlNatureza: TLabeledEdit;
    edtNomePrimeiro: TLabeledEdit;
    edtNomeSegundo: TLabeledEdit;
    dtpRegistro: TDateTimePicker;
    Label1: TLabel;
    Panel2: TPanel;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnDel: TBitBtn;
    btnAlt: TBitBtn;
    btnAdd: TBitBtn;
    Label2: TLabel;
    edtDsDocumento: TLabeledEdit;
    dbgridEnder: TDBGrid;
    Label3: TLabel;
    cdEnderecos: TClientDataSet;
    dsEnderecos: TDataSource;
    edtEnderecoDsCEP: TLabeledEdit;
    edtUF: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    edtComplemento: TLabeledEdit;
    btnItegarcaoCEP: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesqisarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dsListaDataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAltClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnPesquisarEnderecosClick(Sender: TObject);
    procedure dsEnderecosDataChange(Sender: TObject; Field: TField);
    procedure edtEnderecoDsCEPExit(Sender: TObject);
  private
    procedure Pesquisar;
    procedure PesquisarEnderecos;
    procedure CarregarDadosPessoa;
    procedure CarregaDadosEndereco;
    procedure PreencherCamposIntegracao;
    procedure CarregarDadosIntegarcao;
    procedure PreencheControles;
    procedure AlimentaDadosPessoa;
    procedure AlimentaDadosEndereco;
    procedure AlimentaDadosIntegracao;
    procedure AdicionarPessoa;
    procedure AlterarPessoa;
    procedure ExcluirPessoa;
    procedure LimparControles;
    procedure GravarInclusao;
    procedure GravarEdicao;
    procedure HabilitarCampos(Valor: Boolean);
    procedure HabilitarBotoes;
    procedure TravarMira(Alvo: TWinControl);
  public
    Operacao: TOperacao;
    Pessoa: TPessoa;
    Endereco: TEndereco;
    Integracao: TEnderecoIntegracao;
    procedure InicilizaConfiguracoes;
  end;

var
  frmCadastroPessoa: TfrmCadastroPessoa;

implementation

{$R *.dfm}

uses Control.Endereco, Control.Endereco.Integracao, Lib.EnderecoViaCep;

procedure TfrmCadastroPessoa.AdicionarPessoa;
begin
  LimparControles;
  Operacao := opIncluir;
  HabilitarBotoes;
  HabilitarCampos(True);
  TravarMira(edtFlNatureza);
end;

procedure TfrmCadastroPessoa.AlimentaDadosEndereco;
begin
  Endereco.IdPessoa := Pessoa.IdPessoa;
  Endereco.DsCEP := Trim(edtEnderecoDsCEP.Text);
end;

procedure TfrmCadastroPessoa.AlimentaDadosIntegracao;
begin
  Integracao.IdEndereco := Endereco.IdEndereco;
  Integracao.DsUF := Trim(edtUF.Text);
  Integracao.NmCidade := Trim(edtCidade.Text);
  Integracao.NmBairro := Trim(edtBairro.Text);
  Integracao.NmLogradouro := Trim(edtLogradouro.Text);
  Integracao.DsComplemento := Trim(edtComplemento.Text);
end;

procedure TfrmCadastroPessoa.AlimentaDadosPessoa;
begin
  Pessoa.IdPessoa := StrToIntDef(edtIdPessoa.Text, -1);
  Pessoa.FlNatureza := StrToIntDef(edtFlNatureza.Text, 1);
  Pessoa.DsDocumento := Trim(edtDsDocumento.Text);
  Pessoa.NmPrimeiro := Trim(edtNomePrimeiro.Text);
  Pessoa.NmSegundo := Trim(edtNomeSegundo.Text);
  Pessoa.DtRegistro := dtpRegistro.Date;
end;

procedure TfrmCadastroPessoa.AlterarPessoa;
begin
  Operacao := opAlterar;
  HabilitarBotoes;
  HabilitarCampos(True);
  TravarMira(edtFlNatureza);
end;

procedure TfrmCadastroPessoa.btnPesquisarEnderecosClick(Sender: TObject);
begin
  PesquisarEnderecos;
end;

procedure TfrmCadastroPessoa.btnAddClick(Sender: TObject);
begin
  AdicionarPessoa;
end;

procedure TfrmCadastroPessoa.btnAltClick(Sender: TObject);
begin
  CarregarDadosPessoa;
  AlterarPessoa;
end;

procedure TfrmCadastroPessoa.btnCancelarClick(Sender: TObject);
begin
  Operacao := opVer;
  CarregarDadosPessoa;
  HabilitarBotoes;
  HabilitarCampos(False);
end;

procedure TfrmCadastroPessoa.btnDelClick(Sender: TObject);
begin
  ExcluirPessoa;
end;

procedure TfrmCadastroPessoa.btnGravarClick(Sender: TObject);
var
  IdPessoa: Integer;
begin
  IdPessoa := StrToIntDef(edtIdPessoa.Text, -1);

  case Operacao of
    opVer:
      begin
        Beep;
        Exit
      end;
    opIncluir:
      begin
        GravarInclusao;
      end;
    opAlterar:
      begin
        GravarEdicao;
      end;
  end;
  Operacao := opVer;
  CarregarDadosPessoa;
  HabilitarBotoes;
  HabilitarCampos(False);
  Pesquisar;
  cdLista.Locate('IDPESSOA', IdPessoa, []);

end;

procedure TfrmCadastroPessoa.btnPesqisarClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmCadastroPessoa.btnSairClick(Sender: TObject);
begin
  if (fsModal in Self.FormState) then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    Close;
  end;
end;

procedure TfrmCadastroPessoa.CarregaDadosEndereco;
begin
  if (not cdEnderecos.IsEmpty) then
  begin
    edtEnderecoDsCEP.Text := cdEnderecos.FieldByName('DSCEP').AsString;
    Endereco.IdEndereco := cdEnderecos.FieldByName('IDENDERECO').AsInteger;

    edtUF.Text := cdEnderecos.FieldByName('DSUF').AsString;
    edtCidade.Text := cdEnderecos.FieldByName('NMCIDADE').AsString;
    edtBairro.Text := cdEnderecos.FieldByName('NMBAIRRO').AsString;
    edtLogradouro.Text := cdEnderecos.FieldByName('NMLOGRADOURO').AsString;
    edtComplemento.Text := cdEnderecos.FieldByName('DSCOMPLEMENTO').AsString;

  end;
end;

procedure TfrmCadastroPessoa.CarregarDadosIntegarcao;
var
  Motor: TCtrlIntegracao;
begin
  Motor := TCtrlIntegracao.Create;
  try
    Motor.CarregarDados(Endereco.IdEndereco, Integracao);
  finally
    FreeAndNil(Motor);
  end;
end;

procedure TfrmCadastroPessoa.CarregarDadosPessoa;
var
  Motor: TCtrlPessoa;
  IdPessoa: Integer;
begin
  if (not cdLista.IsEmpty) then
  begin
    IdPessoa := cdLista.FieldByName('IDPESSOA').AsInteger;
    Motor := TCtrlPessoa.Create;
    try
      Motor.CarregarDados(IdPessoa, Self.Pessoa);
    finally
      FreeAndNil(Motor);
    end;

    PreencheControles;
  end;
end;

procedure TfrmCadastroPessoa.dsEnderecosDataChange(Sender: TObject;
  Field: TField);
begin
  CarregaDadosEndereco;
  CarregarDadosIntegarcao;
  CarregarDadosIntegarcao;
end;

procedure TfrmCadastroPessoa.dsListaDataChange(Sender: TObject; Field: TField);
begin
  CarregarDadosPessoa;
  PesquisarEnderecos;
  HabilitarBotoes;
end;

procedure TfrmCadastroPessoa.edtEnderecoDsCEPExit(Sender: TObject);
var
  _rEndereco: TEnderecoCEP;
  CEP: string;
begin
  CEP := SimplificarCEP(edtEnderecoDsCEP.Text);
  if (edtEnderecoDsCEP.Text <> EmptyStr) and (ValidarCEP(CEP)) then
  begin
    edtLogradouro.Clear;
    edtBairro.Clear;
    edtCidade.Clear;
    edtUF.Clear;

    _rEndereco := TEnderecoCEP.Create(CEP);
    try
      edtLogradouro.Text := _rEndereco.Logradouro;
      edtBairro.Text := _rEndereco.Bairro;
      edtCidade.Text := _rEndereco.Cidade;
      edtUF.Text := _rEndereco.UF;
    finally
      _rEndereco.Free;
    end;
  end;
end;

procedure TfrmCadastroPessoa.ExcluirPessoa;
const
  Msg = 'ATENÇÃO!!!' + #13 + 'ESTA AÇÃO É IRREVERSÍVEL' + #13 +
    'TEM CERTEZA EM EXCLUIR ESTE REGISTRO?';
var
  Seguir: Boolean;
  Motor: TCtrlPessoa;
  IdPessoa: Integer;
begin
  Seguir := (MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);
  if (Seguir) then
  begin
    if (not cdLista.IsEmpty) then
    begin
      IdPessoa := cdLista.FieldByName('IDPESSOA').AsInteger;
      Motor := TCtrlPessoa.Create;
      try
        Motor.Excluir(IdPessoa);
        Pesquisar;
      finally
        FreeAndNil(Motor);
      end;
    end;
  end;
end;

procedure TfrmCadastroPessoa.FormCreate(Sender: TObject);
begin
  Pessoa := TPessoa.Create;
  Endereco := TEndereco.Create;
  Integracao := TEnderecoIntegracao.Create;
end;

procedure TfrmCadastroPessoa.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Pessoa);
  FreeAndNil(Endereco);
  FreeAndNil(Integracao);
end;

procedure TfrmCadastroPessoa.FormShow(Sender: TObject);
begin
  InicilizaConfiguracoes;
end;

procedure TfrmCadastroPessoa.GravarEdicao;
var
  Motor: TCtrlPessoa;
begin
  AlimentaDadosPessoa;
  AlimentaDadosEndereco;
  AlimentaDadosIntegracao;
  if (Pessoa.ValidarCampos and Endereco.ValidarCampos) then
  begin
    Motor := TCtrlPessoa.Create;
    try
      Motor.Alterar(Pessoa, Endereco, Integracao);
    finally
      FreeAndNil(Motor);
    end;
  end
  else
  begin
    raise Exception.Create
      ('OS CAMPOS MARCADOS COM * (ASTERISCO) SÃO OBRIGATÓRIOS');
  end;
end;

procedure TfrmCadastroPessoa.GravarInclusao;
var
  Motor: TCtrlPessoa;
begin
  AlimentaDadosPessoa;
  AlimentaDadosEndereco;
  AlimentaDadosIntegracao;
  Pessoa.IdPessoa := -1;
  if (Pessoa.ValidarCampos and Endereco.ValidarCampos) then
  begin
    Motor := TCtrlPessoa.Create;
    try
      Motor.Inserir(Pessoa, Endereco);
    finally
      FreeAndNil(Motor);
    end;
  end
  else
  begin
    raise Exception.Create
      ('OS CAMPOS MARCADOS COM * (ASTERISCO) SÃO OBRIGATÓRIOS');
  end;
end;

procedure TfrmCadastroPessoa.HabilitarCampos(Valor: Boolean);
begin
  edtIdPessoa.Enabled := Valor;
  edtFlNatureza.Enabled := Valor;
  edtDsDocumento.Enabled := Valor;
  edtNomePrimeiro.Enabled := Valor;
  edtNomeSegundo.Enabled := Valor;
  dtpRegistro.Enabled := Valor;
end;

procedure TfrmCadastroPessoa.HabilitarBotoes;
begin
  case Operacao of
    opVer:
      begin
        btnGravar.Enabled := False;
        btnCancelar.Enabled := False;

        btnAdd.Enabled := True;
        dbgridLista.Enabled := True;
        if (not cdLista.IsEmpty) then
        begin
          btnAlt.Enabled := True;
          btnDel.Enabled := True;
        end
        else
        begin
          btnAlt.Enabled := False;
          btnDel.Enabled := False;
        end;
      end;
    opIncluir:
      begin
        btnGravar.Enabled := True;
        btnCancelar.Enabled := True;

        btnAdd.Enabled := False;
        btnAlt.Enabled := False;
        btnDel.Enabled := False;
        dbgridLista.Enabled := False;
      end;
    opAlterar:
      begin
        btnGravar.Enabled := True;
        btnCancelar.Enabled := True;

        btnAdd.Enabled := False;
        btnAlt.Enabled := False;
        btnDel.Enabled := False;
        dbgridLista.Enabled := False;
      end;
  end;
end;

procedure TfrmCadastroPessoa.InicilizaConfiguracoes;
begin
  LimparControles;
  Operacao := opVer;
  HabilitarCampos(False);
  HabilitarBotoes;
  dtpRegistro.Date := TDate(Now);
end;

procedure TfrmCadastroPessoa.LimparControles;
begin
  edtIdPessoa.Text := '0';
  edtFlNatureza.Text := EmptyStr;
  edtNomePrimeiro.Text := EmptyStr;
  edtDsDocumento.Text := EmptyStr;
  edtNomeSegundo.Text := EmptyStr;
  dtpRegistro.Date := -1;
end;

procedure TfrmCadastroPessoa.Pesquisar;
var
  Motor: TCtrlPessoa;
begin
  Motor := TCtrlPessoa.Create;
  try
    Motor.Barra := ProgBar;
    Motor.Pesquisar(edtChaveBusca.Text, cdLista);
  finally
    FreeAndNil(Motor);
  end;
end;

procedure TfrmCadastroPessoa.PesquisarEnderecos;
var
  Motor: TCtrlEndereco;
begin
  if (Pessoa.IdPessoa > 0) then
  begin
    Motor := TCtrlEndereco.Create;
    try
      Motor.Barra := ProgBar;
      Motor.Pesquisar(Pessoa.IdPessoa, cdEnderecos);
    finally
      FreeAndNil(Motor);
    end;
  end;
end;

procedure TfrmCadastroPessoa.PreencheControles;
begin
  edtIdPessoa.Text := IntToStr(Pessoa.IdPessoa);
  edtFlNatureza.Text := IntToStr(Pessoa.FlNatureza);
  edtDsDocumento.Text := Pessoa.DsDocumento;
  edtNomePrimeiro.Text := Pessoa.NmPrimeiro;
  edtNomeSegundo.Text := Pessoa.NmSegundo;
  dtpRegistro.Date := Pessoa.DtRegistro;
end;

procedure TfrmCadastroPessoa.PreencherCamposIntegracao;
begin
  edtUF.Text := Integracao.DsUF;
  edtCidade.Text := Integracao.NmCidade;
  edtBairro.Text := Integracao.NmBairro;
  edtLogradouro.Text := Integracao.NmLogradouro;
  edtComplemento.Text := Integracao.DsComplemento;
end;

procedure TfrmCadastroPessoa.TravarMira(Alvo: TWinControl);
begin
  if (Self.Visible and Alvo.CanFocus) then
  begin
    Alvo.SetFocus;
  end;
end;

end.

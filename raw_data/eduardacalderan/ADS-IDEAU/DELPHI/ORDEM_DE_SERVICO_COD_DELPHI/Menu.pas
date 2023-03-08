unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TFrmMenu = class(TForm)
    MainMenu1: TMainMenu;
    Clientes1: TMenuItem;
    CadastroCliente: TMenuItem;
    CadastroProduto: TMenuItem;
    CadastroFuncionrio: TMenuItem;
    Consultar1: TMenuItem;
    ConsultaCliente1: TMenuItem;
    ConsultaProduto1: TMenuItem;
    ConsultaFuncionrio2: TMenuItem;
    OrdemServico: TMenuItem;
    NovaOrdemdeServio1: TMenuItem;

    procedure CadastroFuncionrioClick(Sender: TObject);
    procedure ConsultaFuncionrio2Click(Sender: TObject);
    procedure CadastroClienteClick(Sender: TObject);

    procedure CadastroProdutoClick(Sender: TObject);
    procedure ConsultaProduto1Click(Sender: TObject);
    procedure ConsultaCliente1Click(Sender: TObject);
    procedure NovaOrdemdeServio1Click(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMenu: TFrmMenu;

implementation

{$R *.dfm}

uses frmFuncionariosCadastro, frmProdutosCadastro, frmClienteCadastro, dmFuncionarios, dmProdutos, dmCliente, frmFuncionariosConsulta, frmProdutosConsulta, frmClienteConsulta, dmOrdemServico, frmOrdemServicoCadastro, frmOrdemServicoConsulta;




procedure TFrmMenu.CadastroFuncionrioClick(Sender: TObject);
begin
     dtmFuncionarios := TdtmFuncionarios.Create(self);
  try
    formFuncionariosCadastro := TformFuncionariosCadastro.Create(self);
    try
      formFuncionariosCadastro.ShowModal;
    finally
      FreeAndNil(formFuncionariosCadastro);
    end;
  finally
    FreeAndNil(dtmFuncionarios);
  end;
end;


procedure TFrmMenu.ConsultaFuncionrio2Click(Sender: TObject);
begin
                              dtmFuncionarios := TdtmFuncionarios.Create(self);
  try
    formFuncionariosConsulta := TformFuncionariosConsulta.Create(self);
    try
      formFuncionariosConsulta.ShowModal;
    finally
      FreeAndNil(formFuncionariosConsulta);
    end;
  finally
    FreeAndNil(dtmFuncionarios);
  end;
end;

procedure TFrmMenu.CadastroProdutoClick(Sender: TObject);
begin
     dtmProdutos := TdtmProdutos.Create(self);
  try
    formProdutosCadastro := TformProdutosCadastro.Create(self);
    try
      formProdutosCadastro.ShowModal;
    finally
      FreeAndNil(formProdutosCadastro);
    end;
  finally
    FreeAndNil(dtmProdutos);
  end;
end;

procedure TFrmMenu.ConsultaProduto1Click(Sender: TObject);
begin
       dtmProdutos := TdtmProdutos.Create(self);
  try
    formProdutosConsulta := TformProdutosConsulta.Create(self);
    try
      formProdutosConsulta.ShowModal;
    finally
      FreeAndNil(formProdutosConsulta);
    end;
  finally
    FreeAndNil(dtmProdutos);
  end;
end;

procedure TFrmMenu.NovaOrdemdeServio1Click(Sender: TObject);
begin
      dtmOrdemServico := TdtmOrdemServico.Create(self);
  try
    formOrdemServicoCadastro := TformOrdemServicoCadastro.Create(self);
    try
      formOrdemServicoCadastro.ShowModal;
    finally
      FreeAndNil(formOrdemServicoCadastro);
    end;
  finally
    FreeAndNil(dtmOrdemServico);
  end;
end;

procedure TFrmMenu.CadastroClienteClick(Sender: TObject);
begin

   dtmClientes := TdtmClientes.Create(self);
  try
    formCadastro2 := TformCadastro2.Create(self);
    try
      formCadastro2.ShowModal;
    finally
      FreeAndNil(formCadastro2);
    end;
  finally
    FreeAndNil(dtmClientes);
  end;
end;

procedure TFrmMenu.ConsultaCliente1Click(Sender: TObject);
begin
     dtmClientes := TdtmClientes.Create(self);
  try
    formConsulta2 := TformConsulta2.Create(self);
    try
      formConsulta2.ShowModal;
    finally
      FreeAndNil(formConsulta2);
    end;
  finally
    FreeAndNil(dtmClientes);
  end;
end;


end.

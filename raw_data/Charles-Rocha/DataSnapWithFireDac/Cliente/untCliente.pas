unit untCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DBXDataSnap,
  IPPeerClient, Data.DBXCommon, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, Datasnap.DBClient, Datasnap.DSConnect, Data.SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Menus;

type
  TfrmCliente = class(TForm)
    MainMenu1: TMainMenu;
    Iniciar1: TMenuItem;
    Conectar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Cadastro1: TMenuItem;
    Inserir1: TMenuItem;
    Editar1: TMenuItem;
    N2: TMenuItem;
    Deletar1: TMenuItem;
    CadastraremLote1: TMenuItem;
    pnlPrincipal: TPanel;
    pnlGrid: TPanel;
    dbgPessoa: TDBGrid;
    pnlTotalRegistros: TPanel;
    lblTotalRegistros: TLabel;
    EndereoIntegrao1: TMenuItem;
    N3: TMenuItem;
    procedure cdsPessoaAfterPost(DataSet: TDataSet);
    procedure Sair1Click(Sender: TObject);
    procedure Deletar1Click(Sender: TObject);
    procedure CadastrarEmLote1Click(Sender: TObject);
    procedure Inserir1Click(Sender: TObject);
    procedure Conectar1Click(Sender: TObject);
    procedure Editar1Click(Sender: TObject);
    procedure AtualizaGrid;
    procedure EndereoIntegrao1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ChecarConexao: boolean;
  end;

var
  frmCliente: TfrmCliente;

implementation

{$R *.dfm}

uses ClientClassesUnit1, ClientModuleUnit1, untConectar, untEditar, untInserir;

procedure TfrmCliente.AtualizaGrid;
begin
  with ClientModule1 do
  begin
    SQLConnection1.Connected := false;
    SQLConnection1.Close;
    cdsPessoa.Close;
    SQLConnection1.Connected := true;
    cdsPessoa.Open;
  end;
  frmCliente.lblTotalRegistros.Caption := 'Total de registros: ' + IntToStr(ClientModule1.cdsPessoa.RecordCount);
end;

procedure TfrmCliente.CadastrarEmLote1Click(Sender: TObject);
var
  sPathFile: string;
begin
  if not frmCliente.ChecarConexao then
    exit;
  sPathFile := ExtractFileName(Application.Name) + 'lista-pessoas.csv';
  try
    ClientModule1.ServerMethods1Client.CadastramentoEmLote(sPathFile);
    AtualizaGrid;
    Application.MessageBox('Cadastramento em Lote realizado com sucesso','Aviso',mb_Ok+mb_IconExclamation);
  except
    on E:Exception do
    begin
      Application.MessageBox(PChar('Erro encontrado: ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
    end;
  end;
end;

procedure TfrmCliente.cdsPessoaAfterPost(DataSet: TDataSet);
begin
  ClientModule1.cdsPessoa.ApplyUpdates(0);
end;

function TfrmCliente.ChecarConexao: boolean;
begin
  Result := true;
  if not ClientModule1.SQLConnection1.Connected then
  begin
    Application.MessageBox('Não está conectado' + #13 +
                           'Realizar conexão em Iniciar > Conexão','Aviso',mb_Ok+mb_IconExclamation);
    Result := false;
  end;
end;

procedure TfrmCliente.Conectar1Click(Sender: TObject);
begin
  frmConectar.ShowModal;
end;

procedure TfrmCliente.Deletar1Click(Sender: TObject);
var
  idPessoa: integer;
begin
  if not frmCliente.ChecarConexao then
    exit;
  idPessoa := ClientModule1.cdsPessoaidpessoa.AsInteger;
  ClientModule1.ServerMethods1Client.Delete(idPessoa);
  AtualizaGrid;
end;

procedure TfrmCliente.Editar1Click(Sender: TObject);
begin
  frmEditar.ShowModal;
end;

procedure TfrmCliente.EndereoIntegrao1Click(Sender: TObject);
begin
  if not frmCliente.ChecarConexao then
    exit;

  if not ClientModule1.cdsPessoa.IsEmpty then
    try
      ClientModule1.ServerMethods1Client.EnderecoIntegracao;
      Application.MessageBox('Endereço Integração realizado com sucesso','Aviso',mb_Ok+mb_IconExclamation);
    except
      on E:Exception do
      begin
        Application.MessageBox(PChar('Erro encontrado: ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
      end;
    end
  else
    Application.MessageBox('A tabela está vazia. Execute primeiro o Cadastro em Lote' + #13 +
                           'ou Insira registros manualmente em Cadastro > Inserir','Aviso',mb_Ok+mb_IconExclamation);
end;

procedure TfrmCliente.Inserir1Click(Sender: TObject);
begin
  frmInserir.ShowModal;
end;

procedure TfrmCliente.Sair1Click(Sender: TObject);
begin
  Close;
end;

end.

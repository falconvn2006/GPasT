unit dmConexao;

// Observações importantes:
// - Data Module para conexão (apenas um desses por projeto.
// - Carga das configuração de acesso através de arquivo (conexao.ini) na pasta do aplicativo.
// - Atenção a estrutura de um arquivo ini.

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, System.IniFiles, Vcl.Forms,
  Vcl.Dialogs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdtmConexao = class(TDataModule)
    FDConnection: TFDConnection;
    fdqProxId: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     function getProxId(tabela: string; campo: string): integer;
  end;

var
  dtmConexao: TdtmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses mensagens;

{$R *.dfm}

procedure TdtmConexao.DataModuleCreate(Sender: TObject);
var
  arquivo: TIniFile;
begin
  arquivo := TIniFile.Create('.\conexao.ini');
  with arquivo do
  try
    FDConnection.Connected := False;
    FDConnection.Params.Clear;
    FDConnection.Params.Add('DriverID=MySQL');
    FDConnection.Params.Add('Server=' + arquivo.ReadString('conexao','server',''));
    FDConnection.Params.Add('Database=' + arquivo.ReadString('conexao','database',''));
    FDConnection.Params.Add('User_Name=' + arquivo.ReadString('conexao','user',''));
    FDConnection.Params.Add('Password=' + arquivo.ReadString('conexao','password',''));
    FDConnection.Connected := True;
  except
    if not FDConnection.Connected then
    begin
      ShowMessage(ERRO_AO_CONECTAR_BD);
      Application.Terminate;
    end;
  end;
end;

{ Função para determinar o próximo id - autoincremento via código - sem concorrência}
function TdtmConexao.getProxId(tabela, campo: string): integer;
begin
  with fdqProxId do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select ifnull(max(' + campo + '), 0) +1 id ' +
               '  from ' + tabela;
    Open;
    result := fdqProxId.Fields[0].AsInteger;
  end;
end;

end.

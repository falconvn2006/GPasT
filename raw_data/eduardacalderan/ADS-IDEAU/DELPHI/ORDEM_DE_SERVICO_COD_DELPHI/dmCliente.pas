unit dmCliente;

interface

uses
  System.SysUtils, System.Classes, dmCadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TdtmClientes = class(TdtmCadastro)
    fdqConsultaidCliente: TFDAutoIncField;
    fdqConsultanome: TStringField;
    fdqConsultacpf: TStringField;
    fdqConsultatelefone: TIntegerField;
    fdqConsultaendereço: TStringField;
    cdsCadastroidCliente: TAutoIncField;
    cdsCadastronome: TStringField;
    cdsCadastrocpf: TStringField;
    cdsCadastrotelefone: TIntegerField;
    cdsCadastroendereço: TStringField;
    procedure cdsCadastroNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmClientes: TdtmClientes;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dmConexao;

{$R *.dfm}



procedure TdtmClientes.cdsCadastroNewRecord(DataSet: TDataSet);
begin
  inherited;
  // encontrar próximo id da tabela cidade
  cdsCadastroidCliente.AsInteger := dtmConexao.getProxId('cliente', 'idCliente');
end;

end.

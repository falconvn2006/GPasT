unit dmFuncionarios;

interface

uses
  System.SysUtils, System.Classes, dmCadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TdtmFuncionarios = class(TdtmCadastro)
    cdsCadastroidFuncionario: TAutoIncField;
    fdqCadastroidFuncionario: TFDAutoIncField;
    fdqCadastronome: TStringField;
    fdqCadastrocpf: TStringField;
    fdqCadastrotelefone: TStringField;
    fdqConsultaidFuncionario: TFDAutoIncField;
    fdqConsultanome: TStringField;
    fdqConsultacpf: TStringField;
    fdqConsultatelefone: TStringField;
    procedure cdsCadastroNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmFuncionarios: TdtmFuncionarios;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dmConexao;

{$R *.dfm}

procedure TdtmFuncionarios.cdsCadastroNewRecord(DataSet: TDataSet);
begin
  inherited;
  // encontrar próximo id da tabela cidade
  cdsCadastroidFuncionario.AsInteger := dtmConexao.getProxId('funcioario', 'idFuncionario');
end;

end.

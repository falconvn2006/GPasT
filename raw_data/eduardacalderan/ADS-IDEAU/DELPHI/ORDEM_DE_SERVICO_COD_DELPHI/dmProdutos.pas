unit dmProdutos;

interface

uses
  System.SysUtils, System.Classes, dmCadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TdtmProdutos = class(TdtmCadastro)
    cdsCadastroidProduto: TIntegerField;
    cdsCadastronome: TStringField;
    cdsCadastrovalor: TBCDField;
    cdsCadastrotipo: TStringField;
    fdqConsultaidProduto: TIntegerField;
    fdqConsultanome: TStringField;
    fdqConsultavalor: TBCDField;
    fdqConsultatipo: TStringField;


    procedure cdsCadastroNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmProdutos: TdtmProdutos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dmConexao;

{$R *.dfm}

procedure TdtmProdutos.cdsCadastroNewRecord(DataSet: TDataSet);
begin
  inherited;
  // encontrar próximo id da tabela cidade
  cdsCadastroidProduto.AsInteger := dtmConexao.getProxId('produtos', 'idProdutos');
end;

end.

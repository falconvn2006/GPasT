unit dmCadastroDetalhe;

// Observações Importantes:
// - Data Module que será herdado para os cadastros com detalhes.
// - Colocar SQL no cadastro e no detalhe

interface

uses
  System.SysUtils, System.Classes, dmCadastro, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Datasnap.DBClient, Datasnap.Provider, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdtmCadastroDetalhe = class(TdtmCadastro)
    fdqDetalhe: TFDQuery;
    dsCadastro: TDataSource;
    cdsDetalhe: TClientDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmCadastroDetalhe: TdtmCadastroDetalhe;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

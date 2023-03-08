unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef, FireDAC.Comp.UI,
  FireDAC.Phys.MySQL, DBAccess, Uni, MemDS, UniProvider, MySQLUniProvider;

type
  TDM = class(TDataModule)
    UniConnection1: TUniConnection;
    UniTransaction1: TUniTransaction;
    UniDataSource1: TUniDataSource;
    MySQLUniProvider1: TMySQLUniProvider;
    UniTable2: TUniTable;
    UniTable2id_fun: TIntegerField;
    UniTable2nome_fun: TStringField;
    UniDataSource2: TUniDataSource;
    UniTable3: TUniTable;
    UniDataSource3: TUniDataSource;
    UniTable3id_consulta: TIntegerField;
    UniTable3nome_fun: TStringField;
    UniTable3nome_prod: TStringField;
    UniTable3id_prod: TIntegerField;
    UniTable3data_pega: TDateField;
    UniTable3quant_prod: TIntegerField;
    UniTable3id_retirada: TIntegerField;
    UniTable4: TUniTable;
    UniDataSource4: TUniDataSource;
    UniTable1: TUniTable;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}



end.

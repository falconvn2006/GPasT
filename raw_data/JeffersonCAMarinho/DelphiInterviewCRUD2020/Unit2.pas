unit Unit2;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule2 = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADODataSet1: TADODataSet;
    ADOTable1: TADOTable;
    ADOTable1COD_CLI: TIntegerField;
    ADOTable1NOME: TStringField;
    ADOTable1SOBRENOME: TStringField;
    ADODataSet1COD_PROD: TIntegerField;
    ADODataSet1DESCRICAO: TStringField;
    ADODataSet1QTD: TIntegerField;
    ADODataSet1UN_MEDIDA: TStringField;
    ADODataSet2: TADODataSet;
    ADODataSet2COD_VEND_IT: TIntegerField;
    ADODataSet2COD_PROD: TIntegerField;
    ADODataSet2DESCRICAO: TStringField;
    ADODataSet2VALOR: TFloatField;
    ADODataSet2QTD: TIntegerField;
    ADODataSet2DATA: TWideStringField;
    ADODataSet3: TADODataSet;
    ADODataSet3COD_VEND: TIntegerField;
    ADODataSet3COD_PROD: TIntegerField;
    ADODataSet3DESCRICAO: TStringField;
    ADODataSet3VALOR: TFloatField;
    ADODataSet3QTD: TIntegerField;
    ADODataSet3DATA: TWideStringField;
    ADODataSet4: TADODataSet;
    ADODataSet4COD_CLI: TIntegerField;
    ADODataSet4NOME: TStringField;
    ADODataSet4SOBRENOME: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

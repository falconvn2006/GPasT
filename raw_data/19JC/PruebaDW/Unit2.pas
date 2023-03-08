unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXMSSQL, Data.DBXOdbc, Data.DB,
  Data.SqlExpr, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls,
  Data.Win.ADODB;

type
  TFrmDataConection = class(TForm)
    DataSource1: TDataSource;
    ADOTable1: TADOTable;
    ADOTable2: TADOTable;
    DataSource2: TDataSource;
    ADOTable3: TADOTable;
    DataSource3: TDataSource;
    ADOTable4: TADOTable;
    DataSource4: TDataSource;
    ADOTable3Numero: TIntegerField;
    ADOTable3Producto: TStringField;
    ADOTable3Cantidad: TIntegerField;
    ADOTable3Valor: TIntegerField;
    ADOTable4Producto: TStringField;
    ADOTable4Nombre_Producto: TStringField;
    ADOTable4Valor: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDataConection: TFrmDataConection;

implementation

{$R *.dfm}

end.

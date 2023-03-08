unit BAR54;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, DB, ADODB;

type
  TRProductos = class(TQuickRep)
    QRBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRLabel1: TQRLabel;
    lbfecha: TQRLabel;
    QRBand2: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel3: TQRLabel;
    QRBand3: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText4: TQRDBText;
    QRBand5: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    QRGroup1: TQRGroup;
    QRDBText5: TQRDBText;
    QProductos: TADOQuery;
    QProductosCodigo: TWideStringField;
    QProductosNombre: TWideStringField;
    QProductosPrecio: TBCDField;
    QProductosCategoria: TWideStringField;
    QProductosProductoID: TAutoIncField;
    QProductosExistencia: TFloatField;
    dsProductos: TDataSource;
    QRBand4: TQRBand;
    QRExpr1: TQRExpr;
    QProductoscosto: TBCDField;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel6: TQRLabel;
  private

  public

  end;

var
  RProductos: TRProductos;

implementation

uses BAR05;

{$R *.DFM}

end.

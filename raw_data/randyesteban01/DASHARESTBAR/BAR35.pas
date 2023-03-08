unit BAR35;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, DB, ADODB;

type
  TRVentas = class(TQuickRep)
    QRBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRLabel1: TQRLabel;
    lbfecha: TQRLabel;
    QRBand2: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRBand3: TQRBand;
    QVentas: TADOQuery;
    QVentasNombre: TWideStringField;
    QVentasFacturaID: TIntegerField;
    QVentasFecha: TDateTimeField;
    QVentasExento: TBCDField;
    QVentasGrabado: TBCDField;
    QVentasItbis: TBCDField;
    QVentasDescuento: TBCDField;
    QVentasPropina: TBCDField;
    QVentasTotal: TBCDField;
    QVentasEstatus: TWideStringField;
    QVentasNCF: TWideStringField;
    QVentasCuadrada: TBooleanField;
    QVentasrnc: TWideStringField;
    QVentasCliente: TWideStringField;
    QVentasCajaID: TIntegerField;
    QVentasCajeroID: TIntegerField;
    QVentasHora: TDateTimeField;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRBand4: TQRBand;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRExpr1: TQRExpr;
    QRExpr2: TQRExpr;
    QRExpr3: TQRExpr;
    QRExpr4: TQRExpr;
    QRExpr5: TQRExpr;
    QRExpr6: TQRExpr;
    QRBand5: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
  private

  public

  end;

var
  RVentas: TRVentas;

implementation

uses BAR04;

{$R *.DFM}

end.

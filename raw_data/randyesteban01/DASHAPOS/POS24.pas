unit POS24;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, DB, ADODB;

type
  TRTicket = class(TQuickRep)
    QRBand1: TQRBand;
    QEmpresa: TADOQuery;
    QEmpresaemp_codigo: TIntegerField;
    QEmpresaemp_nombre: TStringField;
    QEmpresaemp_direccion: TStringField;
    QEmpresaemp_localidad: TStringField;
    QEmpresaemp_rnc: TStringField;
    QEmpresaemp_telefono: TStringField;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QFormaPago: TADOQuery;
    QFormaPagocaja: TIntegerField;
    QFormaPagousu_codigo: TIntegerField;
    QFormaPagofecha: TDateTimeField;
    QFormaPagoticket: TIntegerField;
    QFormaPagoforma: TStringField;
    QFormaPagopagado: TBCDField;
    QFormaPagodevuelta: TBCDField;
    QFormaPagoempresa: TIntegerField;
    QFormaPagocredito: TStringField;
    QFormaPagocliente: TIntegerField;
    QFormaPagobanco: TStringField;
    QFormaPagodocumento: TStringField;
    QTicket: TADOQuery;
    QTicketusu_codigo: TIntegerField;
    QTicketfecha: TDateTimeField;
    QTicketcaja: TIntegerField;
    QTicketticket: TIntegerField;
    QTickettotal: TBCDField;
    QTicketdescuento: TBCDField;
    QTicketNCF_Fijo: TStringField;
    QTicketNCF_Secuencia: TBCDField;
    QTicketitbis: TBCDField;
    QTicketnombre: TStringField;
    QTicketrnc: TStringField;
    QTicketstatus: TStringField;
    QTicketNCF: TStringField;
    QTicketmov_numero: TIntegerField;
    QTicketNCF_Tipo: TIntegerField;
    QTicketfecha_hora: TDateTimeField;
    QTicketBoletos: TIntegerField;
    QTicketsupervisor: TIntegerField;
    QTicketsorteo: TIntegerField;
    QTicketdomicilio: TStringField;
    QDetalle: TADOQuery;
    QDetalleusu_codigo: TIntegerField;
    QDetallefecha: TDateTimeField;
    QDetalleticket: TIntegerField;
    QDetallesecuencia: TIntegerField;
    QDetallehora: TStringField;
    QDetalleproducto: TIntegerField;
    QDetalledescripcion: TStringField;
    QDetallecantidad: TBCDField;
    QDetalleprecio: TBCDField;
    QDetalleempaque: TStringField;
    QDetalleitbis: TBCDField;
    QDetalleCosto: TBCDField;
    QDetalleValor: TFloatField;
    QDetallecaja: TIntegerField;
    QDetallePrecioItbis: TFloatField;
    QDetalleCalcItbis: TFloatField;
    QDetalleExcento: TStringField;
    QDetalledescuento: TBCDField;
    QDetalledevuelta: TBCDField;
    QDetalleTotalDescuento: TFloatField;
    QDetalleTotalPrecio: TFloatField;
    QDetalleRealizo_Oferta: TStringField;
    QDetalleOferta: TBCDField;
    dsTicket: TDataSource;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRDBText8: TQRDBText;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRDBText9: TQRDBText;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRSysData1: TQRSysData;
    QTicketusu_nombre: TStringField;
    QRDBText10: TQRDBText;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRDBText11: TQRDBText;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRDBText12: TQRDBText;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRDBText13: TQRDBText;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRDBText14: TQRDBText;
    QRBand2: TQRBand;
    QRLabel22: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRBand3: TQRBand;
    QRDBText15: TQRDBText;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    procedure QTicketCalcFields(DataSet: TDataSet);
  private

  public

  end;

var
  RTicket: TRTicket;

implementation

uses POS01;

{$R *.DFM}

procedure TRTicket.QTicketCalcFields(DataSet: TDataSet);
begin
  QTicketNCF.Value := QTicketNCF_Fijo.Value+FormatFloat('00000000',QTicketNCF_Secuencia.Value);
end;

end.

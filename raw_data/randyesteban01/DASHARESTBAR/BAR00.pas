unit BAR00;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, DBGrids, DB, ADODB, DIMime,
  Mask, ToolEdit, CurrEdit, cxControls, cxContainer, cxEdit, cxCheckBox, Printers,
  vmaxFiscal, iFiscal, OCXFISLib_TLB, uJSON, OleCtrls, Tfhkaif, Math,
  Winsock, DateUtils, jpeg, DBCtrls, QuerySearchDlgADO;

type
  TfrmPOS = class(TForm)
    Timer1: TTimer;
    pnIzquierdo: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    lbtotal: TLabel;
    Panel2: TPanel;
    lbmesa: TLabel;
    DBGrid1: TDBGrid;
    pnAbajo: TPanel;
    lbfechahora: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbexento: TLabel;
    lbdescuento: TLabel;
    lbitbis: TLabel;
    lbsubtotal: TLabel;
    Panel5: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    pnDerecho: TPanel;
    pnCentral: TPanel;
    Panel9: TPanel;
    lbempresa: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    btteclado: TSpeedButton;
    btcash: TSpeedButton;
    btcredito: TSpeedButton;
    bttarjeta: TSpeedButton;
    btncf: TSpeedButton;
    btimprimir: TSpeedButton;
    btopciones: TSpeedButton;
    btrestacat: TSpeedButton;
    btsumacat: TSpeedButton;
    bthome: TSpeedButton;
    lbcatactual: TStaticText;
    pncat1: TPanel;
    pncat2: TPanel;
    pncat3: TPanel;
    pncat4: TPanel;
    pncat5: TPanel;
    Shape1: TShape;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    lbcat1: TStaticText;
    lbcat2: TStaticText;
    lbcat3: TStaticText;
    lbcat4: TStaticText;
    lbcat5: TStaticText;
    lbpanelactual1: TShape;
    lbprod1: TStaticText;
    lbprod2: TStaticText;
    lbprod3: TStaticText;
    lbprod4: TStaticText;
    lbprod5: TStaticText;
    lbprod6: TStaticText;
    lbprod7: TStaticText;
    lbprod8: TStaticText;
    lbprod9: TStaticText;
    lbprod10: TStaticText;
    lbprod11: TStaticText;
    lbprod12: TStaticText;
    lbprod13: TStaticText;
    lbprod14: TStaticText;
    lbprod15: TStaticText;
    lbprod16: TStaticText;
    lbprod17: TStaticText;
    lbprod18: TStaticText;
    lbprod19: TStaticText;
    lbprod20: TStaticText;
    lbprod21: TStaticText;
    lbprod22: TStaticText;
    lbprod23: TStaticText;
    lbprod24: TStaticText;
    lbprod25: TStaticText;
    Label17: TLabel;
    lbpropina: TLabel;
    Panel12: TPanel;
    bt7: TSpeedButton;
    bt4: TSpeedButton;
    bt1: TSpeedButton;
    bt8: TSpeedButton;
    bt5: TSpeedButton;
    bt2: TSpeedButton;
    bt9: TSpeedButton;
    bt6: TSpeedButton;
    bt3: TSpeedButton;
    btdelete: TSpeedButton;
    bthold: TSpeedButton;
    bt0: TSpeedButton;
    btok: TSpeedButton;
    btdescuento: TSpeedButton;
    btclear: TSpeedButton;
    Panel13: TPanel;
    btprior: TSpeedButton;
    btnext: TSpeedButton;
    btbuscaproducto: TSpeedButton;
    edproducto: TEdit;
    Panel14: TPanel;
    lbprod26: TStaticText;
    Panel15: TPanel;
    lbprod27: TStaticText;
    Panel16: TPanel;
    lbprod28: TStaticText;
    Panel42: TPanel;
    lbprod29: TStaticText;
    Panel43: TPanel;
    lbprod30: TStaticText;
    Panel44: TPanel;
    lbprod31: TStaticText;
    Panel45: TPanel;
    lbprod32: TStaticText;
    Panel46: TPanel;
    lbprod33: TStaticText;
    Panel47: TPanel;
    lbprod34: TStaticText;
    Panel48: TPanel;
    lbprod35: TStaticText;
    Panel49: TPanel;
    lbprod36: TStaticText;
    Panel50: TPanel;
    lbprod37: TStaticText;
    Panel51: TPanel;
    lbprod38: TStaticText;
    Panel52: TPanel;
    lbprod39: TStaticText;
    Panel53: TPanel;
    lbprod40: TStaticText;
    Panel54: TPanel;
    lbprod41: TStaticText;
    Panel55: TPanel;
    lbprod42: TStaticText;
    Panel56: TPanel;
    lbprod43: TStaticText;
    Panel57: TPanel;
    lbprod44: TStaticText;
    Panel58: TPanel;
    lbprod45: TStaticText;
    Panel59: TPanel;
    lbprod46: TStaticText;
    Panel60: TPanel;
    lbprod47: TStaticText;
    Panel61: TPanel;
    lbprod48: TStaticText;
    Panel62: TPanel;
    lbprod49: TStaticText;
    pncat6: TPanel;
    lbcat6: TStaticText;
    pncat7: TPanel;
    lbcat7: TStaticText;
    Panel65: TPanel;
    btsuma: TSpeedButton;
    btresta: TSpeedButton;
    SpeedButton26: TSpeedButton;
    pncat8: TPanel;
    lbcat8: TStaticText;
    Panel64: TPanel;
    lbprod50: TStaticText;
    Panel66: TPanel;
    lbprod51: TStaticText;
    Panel67: TPanel;
    lbprod52: TStaticText;
    Panel68: TPanel;
    lbprod53: TStaticText;
    Panel69: TPanel;
    lbprod54: TStaticText;
    Panel70: TPanel;
    lbprod55: TStaticText;
    Panel71: TPanel;
    lbprod56: TStaticText;
    QDetalle: TADOQuery;
    QProductos: TADOQuery;
    dsDetalle: TDataSource;
    Image6: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    Image37: TImage;
    Image38: TImage;
    Image39: TImage;
    Image40: TImage;
    Image41: TImage;
    Image42: TImage;
    Image43: TImage;
    Image44: TImage;
    Image45: TImage;
    Image46: TImage;
    Image47: TImage;
    Image48: TImage;
    Image49: TImage;
    Image50: TImage;
    Image51: TImage;
    Image52: TImage;
    Image53: TImage;
    Image54: TImage;
    Image55: TImage;
    Image56: TImage;
    dsProductos: TDataSource;
    QIngredientes: TADOQuery;
    QOferta: TADOQuery;
    QOfertaProductoID: TIntegerField;
    QOfertaCantidadVendida: TFloatField;
    QOfertaCantidadOferta: TFloatField;
    QOfertaPrecioOferta: TBCDField;
    QOfertaOfertaID: TIntegerField;
    QFactura: TADOQuery;
    btmesas: TSpeedButton;
    Image57: TImage;
    lbUsuario: TLabel;
    lbrnc: TStaticText;
    QForma: TADOQuery;
    QFormaCajeroID: TIntegerField;
    QFormaFacturaID: TIntegerField;
    QFormaCajaID: TIntegerField;
    QFormaDetalleID: TIntegerField;
    QFormaForma: TWideStringField;
    QFormaMonto: TBCDField;
    QFormaDevuelta: TBCDField;
    QFormaTipo_Tarjeta: TWideStringField;
    QFormaAutorizacion: TWideStringField;
    QFormaNumero_Tarjeta: TWideStringField;
    QFormaBanco: TWideStringField;
    Memo1: TMemo;
    adoComandaC: TADOQuery;
    btnImpComanda: TSpeedButton;
    pnMSG: TPanel;
    lblMsg: TLabel;
    Timer_Msg: TTimer;
    adoComandaD: TADOQuery;
    adoComandaDComandaID: TIntegerField;
    adoComandaDSecuencia: TIntegerField;
    adoComandaDProductoID: TIntegerField;
    adoComandaDCantidad: TFloatField;
    adoComandaDDescripcion: TWideStringField;
    adoComandaDNota: TWideStringField;
    adoComandaDIDPrinter: TIntegerField;
    adoComandaDImpreso: TBooleanField;
    adoComandaCComandaID: TIntegerField;
    adoComandaCCajaID: TIntegerField;
    adoComandaCCajeroID: TIntegerField;
    adoComandaCFacturaID: TIntegerField;
    adoComandaCMesaID: TIntegerField;
    adoComandaCFecha: TDateTimeField;
    adoComandaCHora: TDateTimeField;
    adoComandaCTiempo_en_cosina: TFloatField;
    adoComandaCstatus: TWideStringField;
    btliberarmesa: TSpeedButton;
    dsFactura: TDataSource;
    QDetalleTotal: TADOQuery;
    QDetalleTotalsubTotal: TFloatField;
    btCombinado: TSpeedButton;
    QProductosProductoID: TAutoIncField;
    QProductosNombre: TWideStringField;
    QProductosExistencia: TFloatField;
    QProductosPrecio: TFloatField;
    QProductosCosto: TBCDField;
    QProductosItbis: TBooleanField;
    QProductosActualizarExistencia: TBooleanField;
    QProductosImagen: TWideStringField;
    QProductosOfertaDesde: TDateTimeField;
    QProductosOfertaHasta: TDateTimeField;
    QProductosOfertaPrecio: TFloatField;
    QProductosOfertaDescuento: TBCDField;
    QProductosImpresoraRemota: TBooleanField;
    QDetalleFacturaID: TIntegerField;
    QDetalleProductoID: TIntegerField;
    QDetalleNombre: TWideStringField;
    QDetalleCantidad: TFloatField;
    QDetallePrecio: TBCDField;
    QDetalleItbis: TBooleanField;
    QDetalleDetalleID: TIntegerField;
    QDetalleIngrediente: TBooleanField;
    QDetalleCantidadIngredientes: TIntegerField;
    QDetalleDescuento: TBCDField;
    QDetalleCajeroID: TIntegerField;
    QDetalleVisualizar: TBooleanField;
    QDetalleImprimir: TBooleanField;
    QDetalleCajaID: TIntegerField;
    QDetalleCosto: TBCDField;
    QDetalleRecargo: TBCDField;
    QDetalleMontoItbis: TBCDField;
    QDetalleimprimir_comanda: TBooleanField;
    QDetalleComanda_Impreso: TBooleanField;
    QDetallediv_grupo: TWideStringField;
    QDetallediv_Pago: TIntegerField;
    QFacturaCajeroID: TIntegerField;
    QFacturaFacturaID: TIntegerField;
    QFacturaFecha: TDateTimeField;
    QFacturaExento: TBCDField;
    QFacturaGrabado: TBCDField;
    QFacturaItbis: TBCDField;
    QFacturaPropina: TBCDField;
    QFacturaTotal: TBCDField;
    QFacturaEstatus: TWideStringField;
    QFacturaSupervisorID: TIntegerField;
    QFacturaNombre: TWideStringField;
    QFacturaMesaID: TIntegerField;
    QFacturaHold: TBooleanField;
    QFacturaLlevar: TBooleanField;
    QFacturaCredito: TBooleanField;
    QFacturaPagado: TBCDField;
    QFacturaNCF: TWideStringField;
    QFacturaDescuento: TBCDField;
    QFacturaCuadrada: TBooleanField;
    QFacturaCajaID: TIntegerField;
    QFacturarnc: TWideStringField;
    QFacturaHora: TDateTimeField;
    QFacturaTipoNCF: TIntegerField;
    QFacturaConItbis: TBooleanField;
    QFacturaConPropina: TBooleanField;
    QFacturanota: TMemoField;
    QFacturaimprimeNCF: TBooleanField;
    QFacturaDecuentoGlobal: TBooleanField;
    QFacturaUnificada: TIntegerField;
    QDetalleValor: TFloatField;
    QDetalleTotalDescuento: TFloatField;
    QDetalleConItbis: TStringField;
    QIngredientesProductoID: TIntegerField;
    QIngredientesIngredienteID: TIntegerField;
    QIngredientesProductoIngrediente: TIntegerField;
    QIngredientesCantidad: TFloatField;
    QIngredientesPrecio: TBCDField;
    QIngredientesImprimir: TBooleanField;
    QIngredientesNombre: TWideStringField;
    QIngredientesCodigo: TWideStringField;
    QIngredientesVisualizar: TBooleanField;
    QIngredientesCosto: TBCDField;
    QIngredientesActualizarExistencia: TBooleanField;
    QFacturaConbinado: TBooleanField;
    dsForma: TDataSource;
    btnHabitaciones: TSpeedButton;
    qNCFAdm: TADOQuery;
    qFormaPag: TADOQuery;
    qEjecutar: TADOQuery;
    QProductospro_itbis: TCurrencyField;
    QDetalleSubTotal: TCurrencyField;
    QDetalleTotalItbis: TCurrencyField;
    CkCantidad: TcxCheckBox;
    Label2: TLabel;
    lbGrabado: TLabel;
    QProductosPrecio2: TCurrencyField;
    QProductosPrecio3: TCurrencyField;
    QProductosPrecio4: TCurrencyField;
    CkDividirCta: TcxCheckBox;
    edtCliente: TEdit;
    QFacturaAbierta: TBooleanField;
    QFacturaAbiertaPor: TStringField;
    QDetalleimprimir_comanda2: TBooleanField;
    QProductosImpresoraRemota2: TBooleanField;
    pnMsgImpresion: TPanel;
    lblWait: TLabel;
    QFacturaRecargo: TCurrencyField;
    QFacturaemp_codigo: TIntegerField;
    QFacturasuc_codigo: TIntegerField;
    QDetallesuc_codigo: TIntegerField;
    QDetalleemp_codigo: TIntegerField;
    QFormaemp_codigo: TIntegerField;
    QFormasuc_codigo: TIntegerField;
    Edit1: TEdit;
    ckConItbis: TcxCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btsumacatClick(Sender: TObject);
    procedure btrestacatClick(Sender: TObject);
    procedure lbcat1Click(Sender: TObject);
    procedure lbcat2Click(Sender: TObject);
    procedure lbcat3Click(Sender: TObject);
    procedure lbcat4Click(Sender: TObject);
    procedure lbcat5Click(Sender: TObject);
    procedure bt1Click(Sender: TObject);
    procedure bt2Click(Sender: TObject);
    procedure bt3Click(Sender: TObject);
    procedure bt0Click(Sender: TObject);
    procedure bt4Click(Sender: TObject);
    procedure bt5Click(Sender: TObject);
    procedure bt6Click(Sender: TObject);
    procedure bt7Click(Sender: TObject);
    procedure bt8Click(Sender: TObject);
    procedure bt9Click(Sender: TObject);
    procedure btclearClick(Sender: TObject);
    procedure btdeleteClick(Sender: TObject);
    procedure btopcionesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbcat6Click(Sender: TObject);
    procedure lbcat7Click(Sender: TObject);
    procedure lbcat8Click(Sender: TObject);
    procedure bthomeClick(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure lbprod1Click(Sender: TObject);
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure QDetalleAfterPost(DataSet: TDataSet);
    procedure DBGrid1Enter(Sender: TObject);
    procedure btpriorClick(Sender: TObject);
    procedure btnextClick(Sender: TObject);
    procedure btsumaClick(Sender: TObject);
    procedure btrestaClick(Sender: TObject);
    procedure QDetalleAfterDelete(DataSet: TDataSet);
    procedure btbuscaproductoClick(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QDetalleNewRecord(DataSet: TDataSet);
    procedure QDetalleBeforePost(DataSet: TDataSet);
    procedure QDetalleFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure btokClick(Sender: TObject);
    procedure btholdClick(Sender: TObject);
    procedure btcashClick(Sender: TObject);
    procedure btmesasClick(Sender: TObject);
    procedure btncfClick(Sender: TObject);
    procedure edproductoKeyPress(Sender: TObject; var Key: Char);
    procedure bttarjetaClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure btcreditoClick(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure btdescuentoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnImpComandaClick(Sender: TObject);
    procedure dsDetalleDataChange(Sender: TObject; Field: TField);
    procedure adoComandaDNewRecord(DataSet: TDataSet);
    procedure btliberarmesaClick(Sender: TObject);
    procedure btCombinadoClick(Sender: TObject);
    procedure btnHabitacionesClick(Sender: TObject);
    procedure ADOBeforeConnect(Sender: TObject);
    procedure QFacturaAfterDelete(DataSet: TDataSet);
    procedure QFacturaAfterPost(DataSet: TDataSet);
    procedure QFormaBeforePost(DataSet: TDataSet);
    procedure CkCantidadClick(Sender: TObject);
    procedure QFacturaNewRecord(DataSet: TDataSet);
    procedure CurrencyEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure CkDividirCtaClick(Sender: TObject);
    procedure QFacturaBeforePost(DataSet: TDataSet);
    procedure QDetalleTotalBeforeOpen(DataSet: TDataSet);
    procedure QFormaNewRecord(DataSet: TDataSet);
    procedure ckConItbisClick(Sender: TObject);
  private
    Bookmark : TBookmark;
    vl_mesa : Integer;
    vl_cuenta : Boolean;

    function  getActivaComanda(ID: integer): boolean;
    procedure ImpComanda(ID:integer;reimprimir:boolean =false);
    procedure ImpComanda2(ID:integer;reimprimir:boolean =false);
    procedure setImprimeComanda(const aIDFactura: integer);
    procedure impArchivoTxt(var vFile: TextFile; vNombrePrt:string);
//procedure PrintStrings(Strings: TStrings);
    function getSecuencia(ID: integer): integer;
    function getProducto_IDPrinter(ID: integer): integer;
    function getProducto_NamePrinter(ID: integer): string;

    { Private declarations }
  public
    { Public declarations }
    UltCategoria, CatActual, TipoNCF : Integer;
    Precio, TExento, TItbis, TPropina, TGrabado, TDescuento, Total, MPagado, Devuelta, TRecargo ,v_TotalPagado: Double;
    Totaliza, ckPropina, combinado, ckItbis, ckNCF : Boolean;
    vl_precio, primercampo, rnc, razon_social, vBuscaProd, vl_impresora2, vl_impresoraN, actbalance, titulo_cuenta : string;

    Procedure BuscaCategorias;
    Procedure BuscarProducto(Cat : integer);
    Procedure Totalizar;
    Procedure SeleccionaImagen(Nom : String);
    Procedure SeleccionaTitulo(Nom, Cod : String);
    Procedure SeleccionaProducto(Cod : String);
    Procedure BuscaOferta;
    Procedure NuevoTicket;
    Procedure ActualizaExistencia (Operacion : String);
    Procedure ImpTicket;
    function ImprimeTicketFiscal():boolean;
    function ImpTicketFiscalEpson(ImpFiscal:TImpresora):boolean;
    function ImpTicketVmaxFiscal(ImpFiscal:TImpresora):boolean;
    function ImpTicketFiscalBixolon(ImpFiscal:TImpresora):boolean;
    function ImprimeCtaTicketNoFiscalEpson(ImpFiscal:TImpresora):boolean;
    Procedure IniTicket;
    procedure pnabrircaja;
    function liberarMesa(mesaID: string): boolean;
    function validaDivisionCuenta(facturaID: string):boolean;
    function GetComputerName: string;
    function ImprimeCtaTicketNoFiscal():boolean;
    function ImprimeCtaTicketNoFiscalBixolon(ImpFiscal:TImpresora):boolean;
    function getPrinterFiscalBixolonStatus: boolean;
    procedure CargarCategorias();
  end;

Const
  DMes : array[1..12] of String = ('Enero','Febrero','Marzo',
                                  'Abril','Mayo','Junio',
                                  'Julio','Agosto','Septiembre',
                                  'Octubre','Noviembre','Diciembre');

  NumeroMes : array[1..12] of integer = (31,29,31,30,31,30,31,31,30,31,30,31);



var
  frmPOS: TfrmPOS;
  ItbisIncluido:boolean;
  Respuesta, gError: Boolean;
  Categorias : array[1..32] of String;
  NombreCat  : array[1..32] of String;
  BgColorCat : array[1..32] of String;
  FgColorCat : array[1..32] of String;
  Productos  : array[1..56] of String;
  NomProd    : array[1..56] of String;
  puedeAbrirCaja:boolean;
  MontoDevuelta :Double;
  facturarconItbis : boolean;

 formapago:array[0..13] of string = ('Efectivo','Cheque','Tarjeta',
                                      'Tarjeta Debito','Tarjeta Propia','Cupon','Otros 1','Otros 2',
                                      'Otros 3','Otros 4','Nota de Credito','Exoneracion ITBIS',
                                      'Comprobante Cancelados','Exoneracion ITBIS en NC');


implementation

uses BAR02, BAR04, BAR08, BAR09, BAR01, BAR15, BAR16, BAR17,
  BAR18, BAR28, BAR30, BAR32, BAR33, BAR34, BAR14, BAR41, BAR68,
  BAR38, BAR70;

{$R *.dfm}

  function IntToBinRec(valor,digitos:integer):string;
 begin
  if digitos=0 then
   result:=''
  else
  begin
   if (valor AND (1 shl (digitos-1)))>0 then
    result:='1'+IntToBinRec(valor,digitos-1)
   else
    result:='0'+IntToBinRec(valor,digitos-1)
  end;
end;

procedure TfrmPOS.Timer1Timer(Sender: TObject);
begin
  lbfechahora.Caption := datetimetostr(now);
  CurrencyString := '';
end;

function TfrmPOS.getSecuencia(ID:integer):integer ;
begin
  With dm.Query1 do begin
    Close;
    Sql.Clear;
    Sql.Add('Select max(secuencia) as maximo From ComandaD Where ComandaID = '+IntToStr(ID));
    open;
    if not IsEmpty then
      result := FieldByName('maximo').AsInteger + 1
    else
      Result :=1;
    close;
  end;
end;

function TfrmPOS.getProducto_NamePrinter(ID:integer):string ;
begin
  With dm.Query1 do begin
    Close;
    Sql.Clear;
    Sql.Add('Select nombre_printer From Printer_remoto Where IDPrinter = '+IntToStr(ID));
    open;
    if not IsEmpty then
      result := FieldByName('nombre_printer').AsString
    else
      Result :='';
    close;
  end;
end;

function TfrmPOS.getProducto_IDPrinter(ID:integer):integer ;
begin
  With dm.Query1 do begin
    Close;
    Sql.Clear;
    Sql.Add('Select IDPrinter From Productos Where pro_codigo = '+IntToStr(ID));
    open;
    if not IsEmpty then
      result := FieldByName('IDPrinter').AsInteger
    else
      Result :=0;
    close;
  end;
end;


function TfrmPOS.getActivaComanda(ID:integer):boolean ;
var x:Integer;
begin
  With dm.Query1 do begin
    x := 0;
    Close;
    Sql.Clear;
    SQL.Add('select count(*) as  Total from Factura_Items');
    Sql.Add('Where Comanda_Impreso = 0') ;
    Sql.Add('and FacturaID = '+IntToStr(ID));
    Sql.Add('and imprimir_comanda = 1');
    open;
      x := x + FieldByName('Total').AsInteger;
    Close;
    Sql.Clear;
    SQL.Add('select count(*) as  Total from Factura_Items');
    Sql.Add('Where Comanda_Impreso = 0') ;
    Sql.Add('and FacturaID = '+IntToStr(ID));
    Sql.Add('and imprimir_comanda2 = 1');
    open;
      x := x + FieldByName('Total').AsInteger;
  end;

  Result := x > 0;

end;

procedure TfrmPOS.ImpComanda(ID:integer;reimprimir:boolean =false);
var
 vMemo:TMemo;
 F,F2: TextFile;
 FileName,Tmp, vPath_printer:String;
 sTemp1,sTemp2:String;
 sIDComanda:Integer;
 x:byte;
 mesa:String;
  procedure CreaArchivoImpresion(aPuerto:String);
  begin
    AssignFile(F2,'.\ImpOrden.bat');
    if not FileExists('.\ImpOrden.bat') then
      rewrite(F2)
    else
      Append(F2);
      Writeln(F2, 'type .\'+FileName +'.txt > '+aPuerto);
      try
        Flush(F2);
      except
       ;
      end;
      CloseFile(F2);
    end;
begin
  WinExec('del .\*.txt',0);

  //-[borra el archivo maestro .bat]
  if FileExists('.\ImpOrden.bat') then
    DeleteFile('.\ImpOrden.bat');

  sTemp1:='';  sTemp2:='';
  //-[Abre la tabla de comanda con el numero de factura que esta abierto.]
  sIDComanda:=0;
  With adoComandaC do begin //--[0]
    Close;
    Parameters.ParamByName('IDFactura').Value := ID;
    Open;
  end;

  if adoComandaC.IsEmpty then
    exit;

  sIDComanda:=adoComandaC['ComandaID'];

  mesa:='';

  if dm.adoMultiUso.State <> dsinactive then {Esta validacion es para evitar errores de programacion - fernando 20170628}
     begin
       MessageDlg('ERROR - [900] Contacte a Soporte Tecnico del DASHA',mtError,[mbok],0);
       Exit;
     end
  else
  With dm.adoMultiUso do begin
    Close;
    Sql.Clear;
    sql.Add('select nombre from mesas Where mesaid = '+IntToStr(adoComandaCMesaID.value));
    open;
    if not IsEmpty then
      mesa:=dm.adoMultiUso['nombre']
    else
      mesa:='DIRECTA';
    Close;
  end;

  if dm.adoMultiUso.State <> dsinactive then {Esta validacion es para evitar errores de programacion - fernando 20170628}
     begin
       MessageDlg('ERROR - [900] Contacte a Soporte Tecnico del DASHA',mtError,[mbok],0);
       Exit;
     end
  else
  With dm.adoMultiUso do begin //--[0]
    Close;
    SQL.Clear;
    SQL.Add('SELECT distinct a.IDPrinter,pr.Path_printer,pr.nombre_printer From  ComandaD a,Printer_remoto pr');
    Sql.Add('Where a.ComandaID = '+IntToStr(sIDComanda));
    sql.add('and a.IDPrinter = pr.IDPrinter');
    Sql.add('and not a.IDPrinter = 0');
    Open;

    if dm.adoMultiUso.IsEmpty then //Si esta vacio se sale.
     begin
      dm.adoMultiUso.Close;
      exit;
     end;
    dm.adoMultiUso.First;
    While not dm.adoMultiUso.Eof do begin //--[0.1]
      vPath_printer := fieldbyname('nombre_printer').AsString;
      FileName := '.\ORDEN_'+IntToStr(ID)+'_PRINTER_'+
                  IntToStr(dm.adoMultiUso['IDPrinter']);
      if FileExists('.\ORDEN_'+IntToStr(ID)+'_PRINTER_'+
                  IntToStr(dm.adoMultiUso['IDPrinter'])) then
      DeleteFile('.\ORDEN_'+IntToStr(ID)+'_PRINTER_'+
                  IntToStr(dm.adoMultiUso['IDPrinter']));

        WinExec('del .\*.txt',0);

      //-[abre tabla con el detalle.]
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('SELECT b.ComandaID, b.Secuencia,b.ProductoID,');
      dm.Query1.SQL.Add('b.cantidad,b.descripcion,b.Impreso From  ComandaD b ');
      dm.Query1.SQL.Add('Where b.ComandaID = '+IntToStr(adoComandaC['ComandaID']));
      dm.Query1.SQL.Add('and b.IDPrinter = '+IntToStr(dm.adoMultiUso['IDPrinter']));
      if not reimprimir then
        dm.Query1.SQL.Add('and b.Impreso = 0') else
        dm.Query1.SQL.Add('and b.Impreso = 1');

      dm.Query1.Open;

      if not dm.Query1.IsEmpty then //-[Si no encuentra registro para imprimir entonces se sale]
        begin  //--[0.1.1]

          //--[Lee la tabla con la informacion de la comanda hasta el final y la envia al architov txt]
          dm.Query1.First;
          AssignFile(F, FileName+'.txt');
          Rewrite(F);
          Writeln(F,dm.SetCentralizar('*** COMANDA ***'));
          Writeln(F,' ');
          Writeln(F,' ');
          Writeln(F,' ');
          sTemp1:='';
          sTemp2:='';
                           //dm.PAD('0','L',2,IntToStr(Diav))
         /// sTemp1:= 'MOZO NO. : '+dm.PAD(' ','R',5,IntToStr(adoComandaC['camareroID']));
          sTemp2:= 'MESA : '+dm.PAD(' ','L',5,mesa);
          Writeln(F,sTemp1+sTemp2);
          Writeln(F,' ');
          sTemp1:= 'FECHA : '+dm.PAD(' ','R',10,FormatDateTime('dd/mm/yyyy',adoComandaC['Fecha']));
          sTemp2:= '  HORA : '+dm.PAD(' ','R',8,FormatDateTime('hh:mm:ss AM/PM',adoComandaC['hora']));
          Writeln(F,sTemp1+sTemp2);
          Writeln(F,' ');
          Writeln(F,'UNIDAD  DESCRIPCION');
          Writeln(F,'----------------------------------------');

          While not dm.Query1.Eof do begin
            sTemp1:= '';
            sTemp1:= dm.PAD(' ','L',6,formatFloat(',,,0.00',dm.Query1['cantidad']));
            Writeln(F, sTemp1+' '+dm.Query1['descripcion']);
            dm.Query1.Edit;
            dm.Query1['impreso']:=true;

            dm.Query1.Post;
            dm.Query1.UpdateBatch;
            dm.Query1.next;
          end;
         Writeln(F,'----------------------------------------');
          if  reimprimir then
            Writeln(F,'Impreso por : '+lbUsuario.Caption+CRLF+
                      'Fecha :'+FormatDateTime('dd/mm/yyyy hh:mm:ss am/pm',now));

          for x:=1 to 10 do
            Writeln(F,'.');

          CloseFile(F);
//          impArchivoTxt(F,vPath_printer);
          //--[Crea archivo con orden de impresion]

          CreaArchivoImpresion(dm.adoMultiUso['Path_printer']);

        end;//--[0.1.1]

      dm.adoMultiUso.Next;
    end; //--[0.1]
    dm.adoMultiUso.Close;
  end; //--[0]

  winexec(pchar('.\ImpOrden.bat'),0);
end;


procedure TfrmPOS.setImprimeComanda(Const aIDFactura:integer);
var
  idComand:Integer;
begin
  idComand :=0;
  With adoComandaC do begin //--[0]
    Close;
    Parameters.ParamByName('IDFactura').Value := aIDFactura;
    Open;
    //--[si la tabla esta vacia busca el proximo numero]
   if IsEmpty then begin
    {if dm.adoMultiUso.State <> dsinactive then {Esta validacion es para evitar errores de programacion - fernando 20170628}
     {  begin
         MessageDlg('ERROR - [900] Contacte a Soporte Tecnico del DASHA',mtError,[mbok],0);
         Exit;
       end
    else
     begin }
      dm.adoMultiUso.Close;
      dm.adoMultiUso.SQL.Clear;
      dm.adoMultiUso.SQL.Add('select max(ComandaID) as maximo');
      dm.adoMultiUso.SQL.Add('from ComandaC');
      dm.adoMultiUso.Open;


      //--[Si el valor maximo es un nulo entonces ASIGNA EL VALOR 1]
      if not VarIsNull(dm.adoMultiUso['maximo']) then
         idComand := dm.adoMultiUso.FieldByName('maximo').AsInteger + 1
      else idComand := 1;


      adoComandaC.Insert;
      adoComandaC.FieldByName('ComandaID').AsInteger :=  idComand;
      adoComandaC['FacturaID'] := QFacturaFacturaID.Value; //inserta la factura
      adoComandaC['Fecha']:=QFacturaFecha.Value ;
      adoComandaC['Hora']:= now;
      dm.adoMultiUso.Close;

     END
    else
      adoComandaC.Edit;


    if adoComandaC.State in [ dsinsert,dsEdit] then
      begin
        //--[Asigna valores a la tabla de comanda]

        adoComandaC['cajaID']    := QFacturaCajaID.Value;
        adoComandaC['cajeroID']  := QFacturaCajeroID.Value;
        adoComandaC['mesaID']    := QFacturaMesaID.Value;
        ///adoComandaC['camareroID']:= QFacturaCamareroID.Value;
        Post;
        UpdateBatch;
      end;

  end; //--[0]

  //--[Inserta informacion en el detalle de la comanda]
  With adoComandaD do begin
    Close;
    Parameters.ParamByName('id').Value :=idComand;
    Open;
  end;

  Bookmark := QDetalle.GetBookmark;
  QDetalle.DisableControls;
  QDetalle.First;
  while not QDetalle.Eof do begin
    //Si tiene imprimir comanda tomar la impresora Definida- Jhonattan Gomez 2021-10-04
    if (QDetalleimprimir_comanda.Value = True) and
       (QDetalleComanda_Impreso.Value = False) then
       begin
         adoComandaD.Insert;
         adoComandaDComandaID.Value   := adoComandaCComandaID.Value;
         adoComandaDSecuencia.Value   := getSecuencia(adoComandaCComandaID.Value);
         adoComandaDProductoID.Value  := QDetalleProductoID.Value;
         adoComandaDCantidad.Value    := QDetalleCantidad.Value;
         adoComandaDDescripcion.Value := QDetalleNombre.Value;
         adoComandaDImpreso.Value     := false;
         adoComandaDNota.Value        := '';
         adoComandaDIDPrinter.Value   := getProducto_IDPrinter(QDetalleProductoID.Value);
         adoComandaD.Post;
         adoComandaD.UpdateBatch;

         //Buscamos el nombre de la impresora
         vl_impresoraN := getProducto_NamePrinter(adoComandaDIDPrinter.Value);

         With DM.Query1 do begin
           close;
           Sql.clear;
           Sql.Add('Update Factura_Items set Comanda_Impreso = 1 ');
           sql.add('Where CajaID = '+IntToStr(QDetalleCajaID.value));
           sql.add('and CajeroID = '+IntToStr(QDetalleCajeroID.value));
           sql.add('and FacturaID = '+IntToStr(QDetalleFacturaID.value));
           sql.add('and DetalleID = '+IntToStr(QDetalleDetalleID.value));
           sql.add('and ProductoID = '+IntToStr(QDetalleProductoID.value));
           SQL.Add('and imprimir_comanda = 0');
           ExecSQL
         end;
       QDetalle.Edit;
       QDetalleComanda_Impreso.Value := True;
       QDetalle.Post;

       end;

    //Si tiene imprimir comanda 2  seleccionar la impresora Jhonattan Gomez 2021-10-04
    if (QDetalleimprimir_comanda2.Value = True) and
       (QDetalleComanda_Impreso.Value = False) then
       begin
         {Application.CreateForm(TFrmSeleccionarImpresora,FrmSeleccionarImpresora);
         FrmSeleccionarImpresora.ShowModal;
         IF FrmSeleccionarImpresora.Acepto = 1 THEN BEGIN
         vl_impresora2 :=  '\\'+GetComputerName+'\'+FrmSeleccionarImpresora.ComboBox1.Text;
         vl_impresoraN :=  FrmSeleccionarImpresora.ComboBox1.Text;}
         adoComandaD.Insert;
         adoComandaDComandaID.Value   := adoComandaCComandaID.Value;
         adoComandaDSecuencia.Value   := getSecuencia(adoComandaCComandaID.Value);
         adoComandaDProductoID.Value  := QDetalleProductoID.Value;
         adoComandaDCantidad.Value    := QDetalleCantidad.Value;
         adoComandaDDescripcion.Value := QDetalleNombre.Value;
         adoComandaDImpreso.Value     := false;
         adoComandaDNota.Value        := '';
         adoComandaDIDPrinter.Value   := 0;
         adoComandaD.Post;
         adoComandaD.UpdateBatch;


         With DM.Query1 do begin
           close;
           Sql.clear;
           Sql.Add('Update Factura_Items set Comanda_Impreso = 1 ');
           sql.add('Where CajaID = '+IntToStr(QDetalleCajaID.value));
           sql.add('and CajeroID = '+IntToStr(QDetalleCajeroID.value));
           sql.add('and FacturaID = '+IntToStr(QDetalleFacturaID.value));
           sql.add('and DetalleID = '+IntToStr(QDetalleDetalleID.value));
           sql.add('and ProductoID = '+IntToStr(QDetalleProductoID.value));
           SQL.Add('and imprimir_comanda2 = 0');
           ExecSQL
         end;
       QDetalle.Edit;
       QDetalleComanda_Impreso.Value := True;
       QDetalle.Post;
       end;
    QDetalle.Next;
  END;

  if adoComandaD.Locate('IDPrinter','0',[]) then begin
         Application.CreateForm(TFrmSeleccionarImpresora,FrmSeleccionarImpresora);
         FrmSeleccionarImpresora.ShowModal;
         IF FrmSeleccionarImpresora.Acepto = 1 THEN BEGIN
         vl_impresora2 :=  '\\'+GetComputerName+'\'+FrmSeleccionarImpresora.ComboBox1.Text;
         vl_impresoraN :=  FrmSeleccionarImpresora.ComboBox1.Text;
         end;
       FrmSeleccionarImpresora.Release;
       end;

  QDetalle.UpdateBatch;

  if adoComandaD.RecordCount > 0 then
    begin
       try
         Timer_Msg.Enabled :=true;
         pnMSG.Visible := Timer_Msg.Enabled ;
         if adoComandaDImpreso.Value = False then BEGIN
         ImpComanda(QFacturaFacturaID.Value);
         IF vl_impresoraN <> '' THEN 
         ImpComanda2(QFacturaFacturaID.Value);
         end;
         vl_impresora2 := '';
         vl_impresoraN := '';
       finally
         Timer_Msg.Enabled := false;
         pnMSG.Visible := Timer_Msg.Enabled ;
       end;
    end;
  adoComandaC.close;
  adoComandaD.Close;
//   QDetalle.Refresh;
  QDetalle.First;
  QDetalle.GotoBookmark(Bookmark);
  QDetalle.EnableControls;
end;

 procedure TfrmPOS.CargarCategorias();
 var
  a, BgColor, FgColor : integer;
 begin
     //Categorias
  BuscaCategorias;

  for a:= 1 to 8 do
  begin
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption    := Categorias[a];
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := clWhite;
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color      := clBlue;

    if FgColorCat[a] <> '' then
    begin
      FgColor := StringToColor(FgColorCat[a]);
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := FgColor;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := FgColor;
    end;
    if BgColorCat[a] <> '' then
    begin
      BgColor := StringToColor(BgColorCat[a]);
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := BgColor;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := BgColor;
    end;
  end;

  UltCategoria := 8;
  CatActual    := 1;
  lbcatactual.Caption := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat1;
  BuscarProducto(CatActual);
 end   ;



procedure TfrmPOS.FormCreate(Sender: TObject);
var
  a, BgColor, FgColor : integer;
begin
  titulo_cuenta := '*** PRE-CUENTA ***';
  ckNCF := true;

  ckItbis := DM.QParametrosRestBar_FactConItbis.value;// true;
  ckConItbis.Checked:=  ckItbis ;
  ckPropina := False;
  lbrnc.Caption  := 'COMPROBANTE CONSUMIDOR FINAL';
  lbmesa.Caption := 'FACTURA DIRECTA';
  lbUsuario.Caption := frmMain.Nombre;
  lbEmpresa.Caption := dm.QEmpresaNombre.Value;
  CurrencyString := '';
  TipoNCF := 1;
  rnc := '';
  razon_social := '';
  QDetalle.Open;
  QDetalleTotal.Open;

  lbfechahora.Caption := datetimetostr(now);
  btteclado.Caption   := 'F3'+#13+'TECLADO';
  btcash.Caption      := 'F4'+#13+'CASH';
  bttarjeta.Caption   := 'F5'+#13+'TARJETA';
  btcredito.Caption   := 'F6'+#13+'CREDITO';
  btncf.Caption       := 'F7'+#13+'NCF';
  btmesas.Caption     := 'F9'+#13+'MESAS';
  btopciones.Caption  := 'F10'+#13+'OPCIONES';
  btCombinado.Caption := 'F11-PAGO'+#13+'COMBINADO';
  btliberarmesa.Caption     := 'F12'+#13+'LIBERAR'+#13+'MESAS';
   //Categorias
  BuscaCategorias;

  for a:= 1 to 8 do
  begin
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption    := Categorias[a];
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := clWhite;
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color      := clBlue;

    if FgColorCat[a] <> '' then
    begin
      FgColor := StringToColor(FgColorCat[a]);
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := FgColor;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := FgColor;
    end;
    if BgColorCat[a] <> '' then
    begin
      BgColor := StringToColor(BgColorCat[a]);
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := BgColor;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := BgColor;
    end;
  end;

  UltCategoria := 8;
  CatActual    := 1;
  lbcatactual.Caption := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat1;
  BuscarProducto(CatActual);

  (frmPOS.FindComponent('StaticText'+inttostr(1)) as TStatictext).Caption    := '...';

  dm.ADOBar.Connected := True;
end;

procedure TfrmPOS.btsumacatClick(Sender: TObject);
var
  a, BgColor, FgColor : integer;
begin
  if UltCategoria < 32 then
  begin
    //Categorias
    for a := 1 to 8 do
    begin
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption := Categorias[UltCategoria+a];
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := clWhite;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := clWhite;
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := clBlue;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := clBlue;

      if FgColorCat[UltCategoria+a] <> '' then
      begin
        FgColor := StringToColor(FgColorCat[UltCategoria+a]);
        (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := FgColor;
        (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := FgColor;
      end;
      if BgColorCat[UltCategoria+a] <> '' then
      begin
        BgColor := StringToColor(BgColorCat[UltCategoria+a]);
        (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := BgColor;
        (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := BgColor;
      end;

    end;
    UltCategoria := UltCategoria + 8;

    CatActual := UltCategoria - 7;
//    CatActual := UltCategoria - 7;
    lbcatactual.Caption := NombreCat[CatActual];
    lbpanelactual1.Parent := pncat1;
    BuscarProducto(CatActual);
  end;
end;

procedure TfrmPOS.btrestacatClick(Sender: TObject);
var
  a, b, BgColor, FgColor : integer;
begin
  if UltCategoria > 8 then
  begin
    //Categorias
    UltCategoria := UltCategoria - 8;
    b := 8;
    for a := 1 to 8 do
    begin
      b := b - 1;
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption := Categorias[UltCategoria-b];
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := clWhite;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := clWhite;
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := clBlue;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := clBlue;

      if FgColorCat[UltCategoria-a] <> '' then
      begin
        FgColor := StringToColor(FgColorCat[UltCategoria-a]);
        (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := FgColor;
        (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := FgColor;
      end;
      if BgColorCat[UltCategoria-a] <> '' then
      begin
        BgColor := StringToColor(BgColorCat[UltCategoria-a]);
        (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := BgColor;
        (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := BgColor;
      end;

    end;

    CatActual := UltCategoria - 7;
    lbcatactual.Caption := NombreCat[CatActual];
    lbpanelactual1.Parent := pncat1;
    BuscarProducto(CatActual);
  end;
end;

procedure TfrmPOS.lbcat1Click(Sender: TObject);
begin
  CatActual := UltCategoria-7;
  lbcatactual.Caption   := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat1;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.lbcat2Click(Sender: TObject);
begin
  CatActual := UltCategoria-6;
  lbcatactual.Caption   := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat2;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.lbcat3Click(Sender: TObject);
begin
  CatActual := UltCategoria-5;
  lbcatactual.Caption   := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat3;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.lbcat4Click(Sender: TObject);
begin
  CatActual := UltCategoria-4;
  lbcatactual.Caption   := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat4;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.lbcat5Click(Sender: TObject);
begin
  CatActual := UltCategoria-3;
  lbcatactual.Caption   := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat5;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.bt1Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '1';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt2Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '2';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt3Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '3';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt0Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '0';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt4Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '4';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt5Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '5';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt6Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '6';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt7Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '7';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt8Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '8';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.bt9Click(Sender: TObject);
begin
  edproducto.Text     := edproducto.text + '9';
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.btclearClick(Sender: TObject);
begin
  edproducto.Text := '';
end;

procedure TfrmPOS.btdeleteClick(Sender: TObject);
begin
  edproducto.Text := copy(edproducto.text,1,length(edproducto.text)-1);
  edproducto.SelStart := length(edproducto.text);
end;

procedure TfrmPOS.btopcionesClick(Sender: TObject);
begin
  Application.CreateForm(tfrmOpciones, frmOpciones);
  frmOpciones.ShowModal;
  frmOpciones.Release;
end;

procedure TfrmPOS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f2  then btbuscaproductoClick(Self);
  if key = vk_f3  then bttecladoClick(Self);
  if (key = vk_f4) and (btcash.Enabled) then btcashClick(Self);
  if (key = vk_f5) and (bttarjeta.Enabled)  then bttarjetaClick(Self);
  if (key = vk_f7) and (btncf.Enabled)  then btncfClick(Self);
  if (key = vk_f6) and (btcredito.Enabled)  then btcreditoClick(Self);
  if key = vk_f8  then btimprimirClick(Self);
  if key = vk_f9  then btmesasClick(Self);
  if key = vk_f10 then btopcionesClick(Self);
  if key = vk_f11 then btCombinadoClick(Self);
 
end;

procedure TfrmPOS.BuscarProducto(Cat: integer);
var
  a, BgColor, FgColor : integer;
begin
  //Buscando productos de la catagoria seleccionada
    dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select pro_nombre Nombre, Linea1, Linea2, Linea3, BgColor, FgColor, Imagen from Productos');
  dm.Query1.SQL.Add('where CategoriaID = :cat and CategoriaID>0');
  dm.Query1.SQL.Add('order by isnull(OrdenCategoria,999999) asc, pro_codigo');
  dm.Query1.Parameters.ParamByName('cat').Value := Cat;
  dm.Query1.Open;
  for a:=1 to 56 do
  begin
    Productos[a] := '';
    NomProd[a]   := '';
    (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Visible := True;
    (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Caption := Productos[a];
    (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Font.Color := clBlack;
    (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Color      := clWhite;
    (frmPOS.FindComponent('image'+inttostr(a)) as TImage).Visible := False;
    (frmPOS.FindComponent('image'+inttostr(a)) as TImage).Picture := nil;
    (frmPOS.FindComponent('image'+inttostr(a)) as TImage).OnClick := Image6Click;
  end;

  a := 1;
  dm.Query1.DisableControls;
  dm.Query1.First;
  while not dm.Query1.EOF do
  begin
    Productos[a] := dm.Query1.FieldByName('Linea1').AsString + #13 +
                    dm.Query1.FieldByName('Linea2').AsString + #13 +
                    dm.Query1.FieldByName('Linea3').AsString;

    NomProd[a] := dm.Query1.FieldByName('Nombre').AsString;

    (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Caption := Productos[a];
    if FileExists(dm.Query1.FieldByName('Imagen').AsString) then
    begin
      (frmPOS.FindComponent('image'+inttostr(a)) as TImage).Picture.LoadFromFile(dm.Query1.FieldByName('Imagen').AsString);
      (frmPOS.FindComponent('image'+inttostr(a)) as TImage).BringToFront;
      (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Visible := False;
      (frmPOS.FindComponent('image'+inttostr(a)) as TImage).Visible := True;
    end;

    if not dm.Query1.FieldByName('FgColor').IsNull then
    begin
      FgColor := StringToColor(dm.Query1.FieldByName('FgColor').AsString);
      (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Font.Color := FgColor;
    end;
    if not dm.Query1.FieldByName('BgColor').IsNull then
    begin
      BgColor := StringToColor(dm.Query1.FieldByName('BgColor').AsString);
      (frmPOS.FindComponent('lbprod'+inttostr(a)) as TStatictext).Color := BgColor;
    end;

    a := a + 1;
    dm.Query1.Next;
  end;
  dm.Query1.enablecontrols;

end;

procedure TfrmPOS.BuscaCategorias;
var
  a, BgColor, FgColor : integer;
begin
  //Buscando Catagorias
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select Nombre, Linea1, Linea2, Linea3, BgColor, FgColor from Categorias');
  dm.Query1.SQL.Add('order by CategoriaID');
  dm.Query1.Open;

  //Limpia las categoria
  for a:=1 to 32 do
  begin
    Categorias[a] := '*';
    NombreCat[a]  := '';
    BgColorCat[a] := '';
    FgColorCat[a] := '';
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption := Categorias[a];
  end;

  a := 1;
  dm.Query1.DisableControls;
  while not dm.Query1.EOF do
  begin
    Categorias[a] := dm.Query1.FieldByName('Linea1').AsString + #13 +
                    dm.Query1.FieldByName('Linea2').AsString + #13 +
                    dm.Query1.FieldByName('Linea3').AsString;

    NombreCat[a]  := dm.Query1.FieldByName('Nombre').AsString;
    BgColorCat[a] := dm.Query1.FieldByName('BgColor').AsString;
    FgColorCat[a] := dm.Query1.FieldByName('FgColor').AsString;

    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption := Categorias[a];

    a := a + 1;
    dm.Query1.Next;
  end;
  dm.Query1.enablecontrols;

end;

procedure TfrmPOS.lbcat6Click(Sender: TObject);
begin
  CatActual := UltCategoria-2;
  lbcatactual.Caption := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat6;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.lbcat7Click(Sender: TObject);
begin
  CatActual := UltCategoria-1;
  lbcatactual.Caption := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat7;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.lbcat8Click(Sender: TObject);
begin
  CatActual := UltCategoria;
  lbcatactual.Caption := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat8;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.bthomeClick(Sender: TObject);
var
  a, FgColor, BgColor : integer;
begin
  //Categorias
  for a := 1 to 8 do
  begin
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption    := Categorias[a];
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := clWhite;
    (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color      := clBlue;
    (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color      := clWhite;
    (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color           := clBlue;

    if FgColorCat[a] <> '' then
    begin
      FgColor := StringToColor(FgColorCat[a]);
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := FgColor;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := FgColor;
    end;
    if BgColorCat[a] <> '' then
    begin
      BgColor := StringToColor(BgColorCat[a]);
      (frmPOS.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := BgColor;
      (frmPOS.FindComponent('pncat'+inttostr(a)) as TPanel).Color := BgColor;
    end;
  end; 

  UltCategoria := 8;
  CatActual    := 1;
  lbcatactual.Caption := NombreCat[CatActual];
  lbpanelactual1.Parent := pncat1;
  BuscarProducto(CatActual);
end;

procedure TfrmPOS.SpeedButton26Click(Sender: TObject);
var
  a, posicion, BgColor, FgColor : integer;
begin
  Application.CreateForm(tfrmSeleccionaCategoria, frmSeleccionaCategoria);
  for a := 1 to 32 do
  begin
    (frmSeleccionaCategoria.FindComponent('lbcat'+inttostr(a)) as TStatictext).Caption := Categorias[a];
    (frmSeleccionaCategoria.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := clWhite;
    (frmSeleccionaCategoria.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color      := clBlue;
    (frmSeleccionaCategoria.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color      := clWhite;
    (frmSeleccionaCategoria.FindComponent('pncat'+inttostr(a)) as TPanel).Color           := clBlue;

    if FgColorCat[a] <> '' then
    begin
      FgColor := StringToColor(FgColorCat[a]);
      (frmSeleccionaCategoria.FindComponent('lbcat'+inttostr(a)) as TStatictext).Font.Color := FgColor;
      (frmSeleccionaCategoria.FindComponent('pncat'+inttostr(a)) as TPanel).Font.Color := FgColor;
    end;
    if BgColorCat[a] <> '' then
    begin
      BgColor := StringToColor(BgColorCat[a]);
      (frmSeleccionaCategoria.FindComponent('lbcat'+inttostr(a)) as TStatictext).Color := BgColor;
      (frmSeleccionaCategoria.FindComponent('pncat'+inttostr(a)) as TPanel).Color := BgColor;
    end;
  end;

  frmSeleccionaCategoria.ShowModal;

  bthomeClick(Self);
  if (frmSeleccionaCategoria.Cat > 8) and (frmSeleccionaCategoria.Cat <= 16) then
    btsumacatClick(Self)
  else if (frmSeleccionaCategoria.Cat > 16) and (frmSeleccionaCategoria.Cat <= 24) then
  begin
    btsumacatClick(Self);
    btsumacatClick(Self);
  end
  else if (frmSeleccionaCategoria.Cat > 24) and (frmSeleccionaCategoria.Cat <= 32) then
  begin
    btsumacatClick(Self);
    btsumacatClick(Self);
    btsumacatClick(Self);
  end;

  if frmSeleccionaCategoria.Cat > 24 then     {20170824}
    posicion := frmSeleccionaCategoria.Cat - 24
  else
  if frmSeleccionaCategoria.Cat > 16 then     {20170823}
    posicion := frmSeleccionaCategoria.Cat - 16
  else                                         
  if frmSeleccionaCategoria.Cat > 8 then
    posicion := frmSeleccionaCategoria.Cat - 8
  else
    posicion := frmSeleccionaCategoria.Cat;

  if posicion = 1 then lbcat1Click(Self)
  else if posicion = 2 then lbcat2Click(Self)
  else if posicion = 3 then lbcat3Click(Self)
  else if posicion = 4 then lbcat4Click(Self)
  else if posicion = 5 then lbcat5Click(Self)
  else if posicion = 6 then lbcat6Click(Self)
  else if posicion = 7 then lbcat7Click(Self)
  else if posicion = 8 then lbcat8Click(Self);

  frmSeleccionaCategoria.Release;
end;

procedure TfrmPOS.lbprod1Click(Sender: TObject);
begin
  SeleccionaTitulo((Sender as TStaticText).Name, copy((Sender as TStaticText).Caption,1,2));
end;

procedure TfrmPOS.QDetalleCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
Venta := 0;
NumItbis := 0;

if QDetalleProductoID.Text <> '' then begin
dm.Query1.Close;
dm.Query1.SQL.Clear;
dm.Query1.SQL.Add('select (cast(case when p.pro_itbis = ''S'' and pro_montoitbis > 0  then pro_montoitbis else 0 end as numeric(18,2))/100)+1 pro_itbis');
dm.Query1.SQL.Add('from Productos P');
dm.Query1.SQL.Add('inner join Parametros PA on p.emp_codigo = pa.emp_codigo');
dm.Query1.SQL.Add('where pro_codigo = '+QDetalleProductoID.Text);
dm.Query1.Open;
NumItbis := DM.Query1.fieldbyname('pro_itbis').Value;
end
else
NumItbis := 0;



  if (NumItbis > 0) and (QDetalleItbis.Value = True) and (ckItbis = True) then
  begin
    IF (DM.QParametrospar_itbisincluido.Value = 'True') and (QDetalleItbis.Value = True) then
    Venta    := (QDetallePrecio.value)*QDetalleCantidad.Value else
    Venta    := QDetallePrecio.value*QDetalleCantidad.Value;
    QDetalleConItbis.Value := 'G';
  end
  else
  if (NumItbis > 0) and (ckItbis = False)  then
  begin
    IF (DM.QParametrospar_itbisincluido.Value = 'True') and (ckItbis = False) then
    Venta    := (QDetallePrecio.value)*QDetalleCantidad.Value else
    Venta    := QDetallePrecio.value*QDetalleCantidad.Value;
    QDetalleConItbis.Value := 'E';
  end
  else
  begin
    Venta    := (QDetallePrecio.value*QDetalleCantidad.Value);
    QDetalleConItbis.Value := 'E';
  end;
  QDetalleTotalDescuento.Value := (Venta * QDetalleDescuento.Value)/100;
  QDetalleSubTotal.Value := Venta;
  //if ckItbis = True then
  QDetalleTotalItbis.Value := (Venta-QDetalleTotalDescuento.Value) * (NumItbis-1);
  //else
  //QDetalleTotalItbis.Value := 0;

  QDetalleValor.Value := Round(Venta - QDetalleTotalDescuento.Value + QDetalleTotalItbis.Value);



end;

procedure TfrmPOS.Totalizar;
var
  t : TBookmark;
  SubTotal : Double;
begin
  if Totaliza then
  begin
    TExento  := 0;
    TItbis   := 0;
    TPropina := 0;
    TGrabado := 0;
    TDescuento := 0;
    Total    :=   0;
    SubTotal := 0;
    t := QDetalle.GetBookmark;
    QDetalle.DisableControls;
    QDetalle.First;
    while not QDetalle.Eof do
    begin
    if not QDetalleIngrediente.Value then
    begin
    if (QDetalleItbis.Value) and (ckItbis = True) then
    TGrabado := TGrabado + QDetalleSubTotal.Value
    else
    TExento  := TExento  + QDetalleSubTotal.Value;
    end;
{verificar descueto 20170420}
      tDescuento := tDescuento + QDetalleTotalDescuento.Value;
      SubTotal := SubTotal + QDetalleSubTotal.Value; //+ QDetalleMontoItbis.Value;

   if ckPropina then
    begin
      if QFacturaMesaID.Value > 0 then
        TPropina := ((SubTotal) * dm.QEmpresaPropina.Value)/100
      else
        TPropina := 0;
    end;

    if frmpos.ckItbis then begin
      if QDetalleMontoItbis.Value > 0 then
      TItbis := TItbis + QDetalleTotalItbis.Value;
    end;
    QDetalle.Next;
    end;

    QDetalle.First;
    QDetalle.GotoBookmark(t);
    QDetalle.EnableControls;

    if QFacturaDecuentoGlobal.Value then begin
    if TDescuento > 0 then begin
    QFactura.Edit;
    QFacturaDescuento.Value := TDescuento;
    QFactura.Post;
    end;
    end;
    if frmpos.ckItbis = false then begin
      TItbis:=0.0;
    end ;
    Total := (TGrabado+TExento + TItbis + TPropina) - tDescuento;
    QFactura.Edit;
    QFacturaExento.Value    := TExento;
    QFacturaGrabado.Value   := TGrabado;
    if ckItbis then
    QFacturaItbis.Value     := TItbis else
    QFacturaItbis.Value     := 0;
    QFacturaPropina.Value   := TPropina;
    QFacturaTotal.Value     := Total;
{determinar si el descuento es global o por items 20170420}
   if not QFacturaDecuentoGlobal.Value then {si el descuento es global deja la}
       QFacturaDescuento.Value := TDescuento;{cantidad digitada por el usuario}
    QFacturaConItbis.AsBoolean   := ckItbis;
    QFacturaConPropina.AsBoolean := ckPropina;
    QFacturaimprimeNCF.AsBoolean := ckNCF;
    QFactura.Post;
    QFactura.UpdateBatch;

    lbitbis.Caption     := FormatCurr('#,0.00',TItbis);
    lbexento.Caption    := FormatCurr('#,0.00',TExento);
    lbGrabado.Caption   := FormatCurr('#,0.00',TGrabado);
    lbpropina.Caption   := FormatCurr('#,0.00',TPropina);
    lbsubtotal.Caption  := FormatCurr('#,0.00',SubTotal);
  //  lbdescuento.Caption := FormatCurr('#,0.00',QFacturaDescuento.value);
    lbdescuento.Caption := FormatCurr('#,0.00',TDescuento);
    lbtotal.Caption     := FormatCurr('#,0.00',Total);
  end;
end;

procedure TfrmPOS.QDetalleAfterPost(DataSet: TDataSet);
begin
  Totalizar;
end;

procedure TfrmPOS.DBGrid1Enter(Sender: TObject);
begin
  edproducto.SetFocus;
end;

procedure TfrmPOS.btpriorClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Bof then
  begin
    QDetalle.Prior;
    while (QDetalleIngrediente.Value) and (Not QDetalle.Bof) do
    begin
      QDetalle.Prior;
    end;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmPOS.btnextClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Eof then
  begin
    QDetalle.Next;
    while QDetalleIngrediente.Value do
    begin
      if Not QDetalle.Eof then
        QDetalle.Next
      else
      begin
        if QDetalleIngrediente.Value then
        begin
          btpriorClick(Self);
        end;
      end;
    end;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmPOS.btsumaClick(Sender: TObject);
begin
  Totaliza := True;
  if QDetalle.RecordCount > 0 then
  begin
    QProductos.Close;
    QProductos.Parameters.ParamByName('nom').Value := QDetalleNombre.Value;
    QProductos.Open;

    QDetalle.Edit;
    QDetalleCantidad.Value := QDetalleCantidad.Value + 1;
    QDetalle.Post;
    QDetalle.UpdateBatch;
    Totalizar;

    if QProductosActualizarExistencia.Value then
    begin
      //Actualizando Existencia
      dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QProductosProductoID.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
    end;

    if QDetalleCantidadIngredientes.Value > 0 then
    begin
      QIngredientes.DisableControls;
      QIngredientes.First;
      while not QIngredientes.Eof do
      begin
        if QIngredientesActualizarExistencia.Value then
        begin
          //Actualizando Existencia
          dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
        end;

        QIngredientes.Next;
      end;
      QIngredientes.EnableControls;
    end;
  end;
end;

procedure TfrmPOS.btrestaClick(Sender: TObject);
var
  a : Integer;
begin
If QDetalleComanda_Impreso.AsBoolean = false then
   begin {1}
     Totaliza := True;
     if QDetalleCantidad.AsFloat > 1 then
        begin {2}
          QProductos.Close;
          QProductos.Parameters.ParamByName('nom').Value := QDetalleNombre.Value;
          QProductos.Open;        

          QDetalle.Edit;
          QDetalleCantidad.Value := QDetalleCantidad.Value - 1;
          QDetalle.Post;
          QDetalle.UpdateBatch;

          if QDetalleCantidadIngredientes.Value > 0 then
          begin
            QIngredientes.DisableControls;
            QIngredientes.First;
            while not QIngredientes.Eof do
            begin
              if QIngredientesActualizarExistencia.Value then
              begin
                //Actualizando Existencia
                dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;

              end;
              QIngredientes.Next;
            end;
            QIngredientes.EnableControls;

            for a := 1 to QDetalleCantidadIngredientes.Value do
            begin
              QDetalle.Delete;
            end;
          end;

          if QProductosActualizarExistencia.Value then
             begin
            //Actualizando Existencia
              dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
             end;
        end  //--fin 2--------------
      else
        begin
          if QDetalle.RecordCount > 0 then
             begin {3}
              if QDetalleCantidadIngredientes.AsFloat > 0 then
                 begin
                 QProductos.Close;
                 QProductos.Parameters.ParamByName('nom').Value := QDetalleNombre.Value;
                 QProductos.Open;

                  QIngredientes.DisableControls;
                  QIngredientes.First;
                  while not QIngredientes.Eof do
                  begin
                    if QIngredientesActualizarExistencia.Value then
                       begin
                  //Actualizando Existencia
                dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
                       end;
                    QIngredientes.Next;
                  end;
                  QIngredientes.EnableControls;

          //        for a := 1 to QDetalleCantidadIngredientes.Value do
            //        begin
              //        QDetalle.Delete;
          //          end;
                 end;

              if QProductosActualizarExistencia.Value then
                 begin
              //Actualizando Existencia
                  dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
                 end;

              QDetalle.Delete;
              QDetalle.UpdateBatch;
             end; {3 fin}
        end;
   end {1 fin}
else
  if QDetalle.RecordCount > 0 then
  begin
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    if frmAcceso.Acepto = 1 then
    begin
      dm.Query1.close;
      dm.Query1.sql.clear;
      dm.Query1.sql.add('select usu_codigo UsuarioID, usu_nombre Nombre, usu_supervisor Supervisor, usu_cajero Cajero, usu_camarero Camarero, usu_status Estatus');

      {if (copy(frmAcceso.edclave.Text,1,1) = ';') or (copy(frmAcceso.edclave.Text,1,1) = 'Ñ') then
      begin
        dm.Query1.sql.add('from usuarios where tarjetaSupervisorID = :cla');
        dm.Query1.Parameters.parambyname('cla').Value := copy(frmAcceso.edclave.Text,2,10);
      end
      else
      begin}
        dm.Query1.sql.add('from Usuarios where usu_Clave = :cla');
          dm.Query1.Parameters.parambyname('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);
      end;

      dm.Query1.open;
      if dm.Query1.recordcount = 0 then
      begin
        showmessage('ESTE USUARIO NO EXISTE');
        edproducto.SetFocus;
      end
      else if dm.Query1.FieldbyName('Estatus').AsString <> 'ACT' then
      begin
        showmessage('ESTE USUARIO NO ESTA ACTIVO');
        edproducto.SetFocus;
      end
      else if not dm.Query1.FieldbyName('Supervisor').AsBoolean then
      begin
        showmessage('ESTE USUARIO NO ES SUPERVISOR');
        edproducto.SetFocus;
      end
      else
      begin
        frmAcceso.Release;
        Totaliza := True;
        if QDetalleCantidad.AsFloat > 1 then
        begin
          QProductos.Close;
          QProductos.Parameters.ParamByName('nom').Value := QDetalleNombre.Value;
          QProductos.Open;

          QDetalle.Edit;
          QDetalleCantidad.Value := QDetalleCantidad.Value - 1;
          QDetalle.Post;
          QDetalle.UpdateBatch;

          if QDetalleCantidadIngredientes.Value > 0 then
          begin
            QIngredientes.DisableControls;
            QIngredientes.First;
            while not QIngredientes.Eof do
            begin
              if QIngredientesActualizarExistencia.Value then
              begin
                //Actualizando Existencia
                dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
              end;

              QIngredientes.Next;
            end;
            QIngredientes.EnableControls;

            for a := 1 to QDetalleCantidadIngredientes.Value do
            begin
              QDetalle.Delete;
            end;
          end;

          if QProductosActualizarExistencia.Value then
          begin
            //Actualizando Existencia
            dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QDetalleProductoID.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
          end;
        end
        else
        begin
          if QDetalle.RecordCount > 0 then
          begin
            if QDetalleCantidadIngredientes.AsFloat > 0 then
            begin
              QProductos.Close;
              QProductos.Parameters.ParamByName('nom').Value := QDetalleNombre.Value;
              QProductos.Open;

              QIngredientes.DisableControls;
              QIngredientes.First;
              while not QIngredientes.Eof do
              begin
                if QIngredientesActualizarExistencia.Value then
                begin
                  //Actualizando Existencia
                  dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
                end;

                QIngredientes.Next;
              end;
              QIngredientes.EnableControls;

              for a := 1 to QDetalleCantidadIngredientes.Value do
              begin
                QDetalle.Delete;
              end;
            end;

            if QProductosActualizarExistencia.Value then
            begin
              //Actualizando Existencia
              dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
            end;

            QDetalle.Delete;
            QDetalle.UpdateBatch;
          end;
        end;
      end;
    end;
  end;

procedure TfrmPOS.QDetalleAfterDelete(DataSet: TDataSet);
begin
  Totalizar;
end;

procedure TfrmPOS.btbuscaproductoClick(Sender: TObject);
var
  t : TBookmark;
  Cant : Double;
  Valor, Decimal, FormaTicketPeso, Cantidad : String;
  digitos, digitos_entero, digitos_decimal : integer;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select par_digitos_precio_pesar, par_forma_ticket_peso, par_digitos_entero, par_digitos_decimal, RestBar_FactConItbis');
  dm.Query1.SQL.Add('from parametros where emp_codigo = :emp');
  dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
  dm.Query1.Open;
  digitos         := dm.Query1.FieldByName('par_digitos_precio_pesar').AsInteger;
  FormaTicketPeso := dm.Query1.FieldByName('par_forma_ticket_peso').AsString;
  digitos_entero  := dm.Query1.FieldByName('par_digitos_entero').AsInteger;
  digitos_decimal := dm.Query1.FieldByName('par_digitos_decimal').AsInteger;
  ckItbis         := ckConItbis.Checked;//dm.Query1.FieldByName('RestBar_FactConItbis').AsBoolean;

  Application.CreateForm(tfrmBuscarProducto, frmBuscarProducto);
  frmBuscarProducto.ShowModal;

  if frmBuscarProducto.Acepto = 1 then
  begin


    Totaliza := False;
    NuevoTicket;

    QProductos.Close;
    QProductos.Parameters.ParamByName('nom').Value := frmBuscarProducto.QProductosNombre.Value;
    QProductos.Open;


    QDetalle.DisableControls;
    QDetalle.Append;
    QDetalleProductoID.Value := QProductosProductoID.Value;
    QDetalleNombre.Value     := QProductosNombre.Value;
    QDetalleCantidad.Value   := 1;
    if ((vl_precio = '') or (vl_precio = 'Precio1')) then
    QDetallePrecio.Value     := QProductosPrecio.Value;
    if vl_precio = 'Precio2' then
    QDetallePrecio.Value     := QProductosPrecio2.Value;
    if vl_precio = 'Precio3' then
    QDetallePrecio.Value     := QProductosPrecio3.Value;
    if vl_precio = 'Precio4' then
    QDetallePrecio.Value     := QProductosPrecio4.Value;
    BuscaOferta;
    QDetalleItbis.Value      := QProductosItbis.Value;
    QDetalleImprimir.Value   := True;
    QDetalleVisualizar.Value := True;
    QDetalleCajaID.Value     := 1;
    QDetalleCosto.Value      := QProductosCosto.Value;
    QDetalleimprimir_comanda.Value := QProductosImpresoraRemota.Value;
    QDetalleimprimir_comanda2.Value := QProductosImpresoraRemota2.Value;
    QDetalle.Post;
    QDetalle.UpdateBatch;

    if QProductosActualizarExistencia.Value then
    begin
      //Actualizando Existencia
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - '+FormatCurr('#,0.00',QDetalleCantidad.Value));
      dm.Query1.SQL.Add('where pro_codigo = :pro');
      dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - '+FormatCurr('#,0.00',QDetalleCantidad.Value));
      dm.Query1.SQL.Add('where pro_codigo = :pro and emp_codigo = '+DM.QEmpresaEmpresaID.Text+' and alm_codigo = (select top 1 par_invalmacen from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
      dm.Query1.Parameters.ParamByName('pro').Value := QDetalleProductoID.Value;
      dm.Query1.ExecSQL;
      end;

    QDetalle.Last;
    t := QDetalle.GetBookmark;

    Cant := 0;
    while not QIngredientes.Eof do
    begin
      QDetalle.Append;
      QDetalleProductoID.Value  := QIngredientesProductoIngrediente.Value;
      QDetalleNombre.Value      := QIngredientesNombre.Value;
      QDetalleCantidad.Value    := QIngredientesCantidad.Value;
      QDetalleIngrediente.Value := True;
      QDetalleVisualizar.Value  := QIngredientesVisualizar.Value;
      QDetalleImprimir.Value    := QIngredientesImprimir.Value;
      QDetalleCajaID.Value      := 1;
      QDetallePrecio.Value      := 0;
      QDetalleCosto.Value       := QIngredientesCosto.Value;
      QDetalle.Post;

      if QIngredientesActualizarExistencia.Value then
      begin
        //Actualizando Existencia
                dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad + :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
      end;

      Cant := Cant + 1;

      QIngredientes.Next;
    end;
    QDetalle.GotoBookmark(t);

    QDetalle.Edit;
    QDetalleCantidadIngredientes.Value := Round(Cant);
    QDetalle.Post;
    QDetalle.Last;
    QDetalle.EnableControls;
    QDetalle.UpdateBatch;

    Totaliza := True;
    Totalizar;
  end;

  frmBuscarProducto.Release;

end;

procedure TfrmPOS.SeleccionaImagen(Nom: String);
var
  Cod : String;
  t : TBookmark;
  Cant : Integer;
begin
  if Trim(Nom) <> '' then
  begin
    Cod := copy(Nom, 6, length(Nom)-5);
    QProductos.Close;
    QProductos.Parameters.ParamByName('nom').Value := NomProd[StrToInt(Cod)];
    QProductos.Open;

    NuevoTicket;

    QIngredientes.Close;
    QIngredientes.Open;

    QDetalle.DisableControls;
    QDetalle.Append;
    QDetalleProductoID.Value := QProductosProductoID.Value;
    QDetalleNombre.Value     := QProductosNombre.Value;
    QDetalleCantidad.Value   := 1;
    if ((vl_precio = '') or (vl_precio = 'Precio1')) then
    QDetallePrecio.Value     := QProductosPrecio.Value;
    if vl_precio = 'Precio2' then
    QDetallePrecio.Value     := QProductosPrecio2.Value;
    if vl_precio = 'Precio3' then
    QDetallePrecio.Value     := QProductosPrecio3.Value;
    if vl_precio = 'Precio4' then
    QDetallePrecio.Value     := QProductosPrecio4.Value;
    BuscaOferta;
    QDetalleItbis.Value      := QProductosItbis.Value;
    QDetalleImprimir.Value   := True;
    QDetalleVisualizar.Value := True;
    QDetalleimprimir_comanda.Value := QProductosImpresoraRemota.Value;
    QDetalleimprimir_comanda2.Value := QProductosImpresoraRemota2.Value;
    QDetalleCajaID.Value     := 1;
    QDetalleCosto.Value      := QProductosCosto.Value;
    QDetalle.Post;

    if QProductosActualizarExistencia.Value then
    begin
      //Actualizando Existencia
      dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
    end;

    QDetalle.Last;
    t := QDetalle.GetBookmark;

    Cant := 0;
    while not QIngredientes.Eof do
    begin
      QDetalle.Append;
      QDetalleProductoID.Value  := QIngredientesProductoIngrediente.Value;
      QDetalleNombre.Value      := QIngredientesNombre.Value;
      QDetalleCantidad.Value    := QIngredientesCantidad.Value;
      QDetalleIngrediente.Value := True;
      QDetalleVisualizar.Value  := QIngredientesVisualizar.Value;
      QDetalleImprimir.Value    := QIngredientesImprimir.Value;
      QDetalleCajaID.Value      := 1;
      QDetallePrecio.Value      := 0;
      QDetalleCosto.Value       := QIngredientesCosto.Value;
      QDetalle.Post;

      if QIngredientesActualizarExistencia.Value then
      begin
        //Actualizando Existencia
        dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
      end;

      Cant := Cant + 1;

      QIngredientes.Next;
    end;
    QDetalle.GotoBookmark(t);
    QDetalle.Edit;
    QDetalleCantidadIngredientes.Value := Cant;
    QDetalle.Post;
    QDetalle.EnableControls;

    QDetalle.UpdateBatch;

    Totaliza := True;

    Totalizar;
  end;
end;

procedure TfrmPOS.Image6Click(Sender: TObject);
begin
  SeleccionaImagen((Sender as TImage).Name);
end;

procedure TfrmPOS.SeleccionaTitulo(Nom, Cod: String);
var
  vCod : String;
  t : TBookmark;
  Cant : Integer;
begin
if Trim(Cod) <> '' then begin
    Totaliza := False;
    vCod := copy(Nom, 7, length(Nom)-6);

    NuevoTicket;

    QProductos.Close;
    QProductos.Parameters.ParamByName('nom').Value := NomProd[StrToInt(vCod)];
    QProductos.Open;

    QIngredientes.Close;
    QIngredientes.Open;

    QDetalle.DisableControls;
    QDetalle.Append;
    QDetalleProductoID.Value := QProductosProductoID.Value;
    QDetalleNombre.Value     := QProductosNombre.Value;
    QDetalleCantidad.Value   := 1;
    if ((vl_precio = '') or (vl_precio = 'Precio1')) then
    QDetallePrecio.Value     := QProductosPrecio.Value;
    if vl_precio = 'Precio2' then
    QDetallePrecio.Value     := QProductosPrecio2.Value;
    if vl_precio = 'Precio3' then
    QDetallePrecio.Value     := QProductosPrecio3.Value;
    if vl_precio = 'Precio4' then
    QDetallePrecio.Value     := QProductosPrecio4.Value;
    BuscaOferta;
    QDetalleItbis.Value      := QProductosItbis.Value;
    QDetalleImprimir.Value    := QIngredientesImprimir.Value;
    QDetalleVisualizar.Value := True;
    QDetalleCajaID.Value     := 1;
    QDetalleCosto.Value      := QProductosCosto.Value;
    QDetalleimprimir_comanda.Value := QProductosImpresoraRemota.Value;
    QDetalleimprimir_comanda2.Value := QProductosImpresoraRemota2.Value;
    QDetalle.Post;
    QDetalle.UpdateBatch;

    

    if QProductosActualizarExistencia.Value then
    begin
      //Actualizando Existencia
                dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QProductosProductoID.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
    end;

    QDetalle.Last;
    t := QDetalle.GetBookmark;

    Cant := 0;
    while not QIngredientes.Eof do
    begin
      QDetalle.Append;
      QDetalleProductoID.Value  := QIngredientesProductoIngrediente.Value;
      QDetalleNombre.Value      := QIngredientesNombre.Value;
      QDetalleCantidad.Value    := QIngredientesCantidad.Value;
      QDetalleIngrediente.Value := True;
      QDetalleVisualizar.Value  := QIngredientesVisualizar.Value;
      QDetalleImprimir.Value    := QIngredientesImprimir.Value;
      QDetalleCajaID.Value      := 1;
      QDetallePrecio.Value      := 0;
      QDetalleCosto.Value       := QIngredientesCosto.Value;
      QDetalleimprimir_comanda.Value := QProductosImpresoraRemota.Value;
      QDetalleimprimir_comanda2.Value := QProductosImpresoraRemota2.Value;
      QDetalle.Post;

      if QIngredientesActualizarExistencia.Value then
      begin
        //Actualizando Existencia
        dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QProductosProductoID.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
      end;

      Cant := Cant + 1;

      QIngredientes.Next;
    end;
    QDetalle.GotoBookmark(t);

    QDetalle.Edit;
    QDetalleCantidadIngredientes.Value := Cant;
    QDetalle.Post;
    QDetalle.EnableControls;
    QDetalle.UpdateBatch;

    Totaliza := True;
    Totalizar;
end;
end;

procedure TfrmPOS.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if QDetalleIngrediente.Value then
  begin
     DBGrid1.canvas.font.Name  := 'Arial';
     DBGrid1.canvas.font.Size  := 6;
     DBGrid1.canvas.font.Color := clBlue;
     if Datacol >= 1 then
        DBGrid1.canvas.font.Color := clWhite
     else
     DBGrid1.canvas.font.Color := clBlue;
     DBGrid1.DefaultDrawcolumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfrmPOS.BuscaOferta;
var
  Prec : Double;
begin
  if (DateOf(Date) >= QProductosOfertaDesde.Value) and (DateOf(Date) <= QProductosOfertaHasta.Value) then
  begin
    if QProductosOfertaDescuento.Value > 0 then
      QDetalleDescuento.Value := QProductosOfertaDescuento.Value
    else if QProductosOfertaPrecio.Value > 0 then
      QDetallePrecio.Value := QProductosOfertaPrecio.Value
    else
    begin
      QOferta.Close;
      QOferta.Open;
      if QOferta.RecordCount > 0 then
      begin
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select sum(Cantidad) as cant from Factura_Items');
        //dm.Query1.SQL.Add('
      end;
    end;
  end;
end;

procedure TfrmPOS.NuevoTicket;
begin
  if not QFactura.Active then
  begin
    QFactura.Close;
    QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
    QFactura.Parameters.ParamByName('fac').Value := -1;
    QFactura.Parameters.ParamByName('caja').Value := 1;
    QFactura.Open;

    QForma.Close;
    QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
    QForma.Parameters.ParamByName('fac').Value := -1;
    QForma.Parameters.ParamByName('caja').Value := 1;
    QForma.Open;
  end;

  if QFactura.RecordCount = 0 then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(FacturaID) as maximo');
    dm.Query1.SQL.Add('from Factura_RestBar');
    dm.Query1.SQL.Add('where CajaID = 1');
    dm.Query1.Open;

    TipoNCF := 1;
    razon_social := '';
    rnc := '';
    lbrnc.Caption  := 'COMPROBANTE CONSUMIDOR FINAL';
    lbmesa.Caption := 'FACTURA DIRECTA';
    Devuelta := 0;
    MPagado  := 0;
    vl_precio := '';
    QFactura.Append;
    if not frmMain.Camarero then
      QFacturaCajeroID.Value := frmMain.Usuario
    else
      QFacturaCajeroID.Value := 0;
    QFacturaFacturaID.Value  := dm.Query1.FieldByName('maximo').AsInteger + 1;
    QFacturaFecha.Value      := Date;
    QFacturaExento.Value     := 0;
    QFacturaGrabado.Value    := 0;
    QFacturaItbis.Value      := 0;
    QFacturaPropina.Value    := 0;
    QFacturaTotal.Value      := 0;
    QFacturaEstatus.Value    := 'ABI';
    //QFacturaCamareroID.Value := 0;
    QFacturaHold.Value       := False;
    QFacturaLlevar.Value     := False;
    QFacturaCredito.Value    := False;
    QFacturaPagado.Value     := 0;
    QFacturaDescuento.Value  := 0;
    QFacturaCuadrada.Value   := False;
    QFacturaCajaID.Value     := 1;
    QFacturaConItbis.AsBoolean   := ckItbis;
    QFacturaConPropina.AsBoolean := False;
    QFacturaimprimeNCF.AsBoolean := ckNCF;
    QFacturaDecuentoGlobal.Value := False;
    QFactura.Post;

  end;
end;

procedure TfrmPOS.QDetalleNewRecord(DataSet: TDataSet);
begin
  QDetalleCajeroID.Value  := QFacturaCajeroID.Value;
  QDetalleFacturaID.Value := QFacturaFacturaID.Value;
  QDetalleCajaID.Value    := 1;
  QDetallediv_Pago.Value  := 0;
  QDetalleComanda_Impreso.Value := false;
  QDetalleemp_codigo.Value := frmMain.vp_cia;
  QDetallesuc_codigo.Value := frmMain.vp_suc;

end;

procedure TfrmPOS.ActualizaExistencia(Operacion: String);
begin
end;

procedure TfrmPOS.QDetalleBeforePost(DataSet: TDataSet);
begin
  if QDetalle.State = dsInsert then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(DetalleID) as maximo');
    dm.Query1.SQL.Add('from Factura_Items');
    dm.Query1.SQL.Add('where CajeroID = :caj');
    dm.Query1.SQL.Add('and FacturaID = :fac');
    dm.Query1.SQL.Add('and cajaid = :caja');
    if not frmMain.Camarero then
      dm.Query1.Parameters.ParamByName('caj').Value := frmMain.Usuario
    else
      dm.Query1.Parameters.ParamByName('caj').Value := 0;
    dm.Query1.Parameters.ParamByName('fac').Value := QFacturaFacturaID.Value;
    dm.Query1.Parameters.ParamByName('caja').Value := 1;
    dm.Query1.Open;

    QDetalleDetalleID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
end;

  //if ckItbis = True then begin
  QDetalleMontoItbis.Value := QDetalleTotalItbis.Value;
  QDetalleItbis.Value := ckItbis;
 // end
 // else
 // begin
 // QDetalleMontoItbis.Value := 0;
 // QDetalleItbis.Value := False;
 // end;

end;

procedure TfrmPOS.QDetalleFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if QDetalleVisualizar.Value then Accept := True else Accept := False;
end;

procedure TfrmPOS.btokClick(Sender: TObject);
begin
  if Trim(edproducto.Text) <> '' then
  begin
    SeleccionaProducto(edproducto.Text);
    edproducto.Text := '';
  end;
end;

procedure TfrmPOS.SeleccionaProducto(Cod: String);
var
  vCod : String;
  t : TBookmark;
  Cant : Double;
  Valor, Cantidad, Decimal, FormaTicketPeso : String;
  digitos, digitos_entero, digitos_decimal : integer;
  prodBalanza : Boolean;
begin
  qEjecutar.Close;
  qEjecutar.SQL.Clear;
  qEjecutar.SQL.Add('select par_digitos_precio_pesar, par_forma_ticket_peso, par_digitos_entero, par_digitos_decimal');
  qEjecutar.SQL.Add('from parametros where emp_codigo = :emp');
  qEjecutar.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
  qEjecutar.Open;
  digitos         := qEjecutar.FieldByName('par_digitos_precio_pesar').AsInteger;
  FormaTicketPeso := qEjecutar.FieldByName('par_forma_ticket_peso').AsString;
  digitos_entero  := qEjecutar.FieldByName('par_digitos_entero').AsInteger;
  digitos_decimal := qEjecutar.FieldByName('par_digitos_decimal').AsInteger;

   if Trim(Cod) <> '' then
  begin
    Totaliza := False;

    NuevoTicket;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select pro_nombre Nombre from Productos');
    dm.Query1.SQL.Add('where pro_roriginal = :cod');
    dm.Query1.Parameters.ParamByName('cod').Value := Cod;
    dm.Query1.Open;
    if not dm.Query1.IsEmpty then prodBalanza := False;
    if DM.Query1.IsEmpty then begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select pro_nombre Nombre from Productos');
    dm.Query1.SQL.Add('where pro_roriginal = :cod');
    dm.Query1.Parameters.ParamByName('cod').Value := Copy(Cod,1,digitos);
    dm.Query1.Open;
    if not dm.Query1.IsEmpty then prodBalanza := True;
    end;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTE CODIGO NO EXISTE',mtError,[mbok],0);
      edproducto.SetFocus;
    end
    else
    begin
      QProductos.Close;
      QProductos.Parameters.ParamByName('nom').Value := dm.Query1.FieldByName('Nombre').AsString;
      QProductos.Open;

      QIngredientes.Close;
      QIngredientes.Open;

      QDetalle.DisableControls;
      QDetalle.Append;
      QDetalleProductoID.Value := QProductosProductoID.Value;
      QDetalleNombre.Value     := QProductosNombre.Value;
      if QProductos.RecordCount > 0 then
      begin
        if digitos_entero > 0 then
        begin
          if prodBalanza = False then
          QDetalleCantidad.Value := 1 else
          begin
          Cantidad    := copy(Cod,digitos+1,digitos_entero);
          Decimal     := copy(Cod,digitos+digitos_entero+1,2);
          Valor := Cantidad+'.'+Decimal;
          QDetalleCantidad.Value := StrToCurr(Valor);
          if ((vl_precio = '') or (vl_precio = 'Precio1')) then
          QDetallePrecio.Value     := QProductosPrecio.Value;
          if vl_precio = 'Precio2' then
          QDetallePrecio.Value     := QProductosPrecio2.Value;
          if vl_precio = 'Precio3' then
          QDetallePrecio.Value     := QProductosPrecio3.Value;
          if vl_precio = 'Precio4' then
          QDetallePrecio.Value     := QProductosPrecio4.Value;
          end;
        end
        else
        begin
          Cantidad    := copy(Cod,8,3);
          Decimal     := copy(Cod,11,2);
          Valor := Cantidad+'.'+Decimal;
          QDetalleCantidad.Value := StrToCurr(Valor);
          if ((vl_precio = '') or (vl_precio = 'Precio1')) then
         QDetallePrecio.Value     := QProductosPrecio.Value;
         if vl_precio = 'Precio2' then
         QDetallePrecio.Value     := QProductosPrecio2.Value;
         if vl_precio = 'Precio3' then
         QDetallePrecio.Value     := QProductosPrecio3.Value;
         if vl_precio = 'Precio4' then
         QDetallePrecio.Value     := QProductosPrecio4.Value;

        end;
        end;

      //QDetalleCantidad.Value   := 1;
      if ((vl_precio = '') or (vl_precio = 'Precio1')) then
      QDetallePrecio.Value     := QProductosPrecio.Value;
      if vl_precio = 'Precio2' then
      QDetallePrecio.Value     := QProductosPrecio2.Value;
      if vl_precio = 'Precio3' then
      QDetallePrecio.Value     := QProductosPrecio3.Value;
      if vl_precio = 'Precio4' then
      QDetallePrecio.Value     := QProductosPrecio4.Value;
      BuscaOferta;
      QDetalleItbis.Value      := QProductosItbis.Value;
      QDetalleImprimir.Value   := True;
      QDetalleVisualizar.Value := True;
      QDetalleimprimir_comanda.Value := QProductosImpresoraRemota.Value;
      QDetalleimprimir_comanda2.Value := QProductosImpresoraRemota2.Value;
      QDetalleCajaID.Value     := 1;
      QDetalleCosto.Value      := QProductosCosto.Value;
      QDetalle.Post;
      QDetalle.UpdateBatch;

      if QProductosActualizarExistencia.Value then
      begin
        //Actualizando Existencia
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
        dm.Query1.SQL.Add('where pro_codigo = :pro');
        dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
        dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
        dm.Query1.Parameters.ParamByName('pro').Value  := QDetalleProductoID.Value;
        dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
        dm.Query1.ExecSQL;
      end;

      QDetalle.Last;
      t := QDetalle.GetBookmark;

      Cant := 0;
      while not QIngredientes.Eof do
      begin
        QDetalle.Append;
        QDetalleProductoID.Value  := QIngredientesProductoIngrediente.Value;
        QDetalleNombre.Value      := QIngredientesNombre.Value;
        QDetalleCantidad.Value    := QIngredientesCantidad.Value;
        QDetalleIngrediente.Value := True;
        QDetalleVisualizar.Value  := QIngredientesVisualizar.Value;
        QDetalleImprimir.Value    := QIngredientesImprimir.Value;
        QDetalleCajaID.Value      := 1;
        QDetallePrecio.Value      := 0;
        QDetalleCosto.Value       := QIngredientesCosto.Value;
        QDetalle.Post;

        if QIngredientesActualizarExistencia.Value then
        begin
          //Actualizando Existencia
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('update Productos set Existencia = Existencia - :can');
          dm.Query1.SQL.Add('where ProductoID = :pro');
          dm.Query1.Parameters.ParamByName('can').Value := QIngredientesCantidad.Value;
          dm.Query1.Parameters.ParamByName('pro').Value := QIngredientesProductoIngrediente.Value;
          dm.Query1.ExecSQL;
        end;

        Cant := Cant + 1;

        QIngredientes.Next;
      end;
      QDetalle.GotoBookmark(t);

      QDetalle.Edit;
      QDetalleCantidadIngredientes.Value := round(Cant);
      QDetalle.Post;
      QDetalle.EnableControls;
      QDetalle.UpdateBatch;

      Totaliza := True;
      Totalizar;
      edproducto.Text;
    end;
  end;
end;

procedure TfrmPOS.btholdClick(Sender: TObject);
begin
  //bloquear mesas con productos
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st ');
        dm.Query1.SQL.Add('where MESAID IN ');
        DM.Query1.SQL.Add('(select MesaID from Factura_RestBar WHERE ESTATUS = ''ABI'' AND MESAID > 0 and total > 0 AND HOLD = 1)');
        dm.Query1.Parameters.ParamByName('st').Value   := 'ABI';
        dm.Query1.ExecSQL;

        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st ');
        dm.Query1.SQL.Add('where MESAID NOT IN ');
        DM.Query1.SQL.Add('(select MesaID from Factura_RestBar WHERE ESTATUS = ''ABI'' AND MESAID > 0 and total > 0 AND HOLD = 1)');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.ExecSQL;


  if Total <> 0 then
  begin
    UltCategoria := 8;
    CatActual    := 1;
    lbcatactual.Caption := NombreCat[CatActual];
    lbpanelactual1.Parent := pncat1;
    BuscarProducto(CatActual);

    QFactura.Edit;
    QFacturaHold.Value    := True;
    QFacturarnc.Value     := rnc;
    if not CkDividirCta.Checked then
    QFacturaNombre.Value  := razon_social;
    if (CkDividirCta.Checked) and (edtCliente.Text = '') then begin
    ShowMessage('Debes indicar el cliente....');
    edtCliente.SetFocus;
    Exit;
    end;
    if (CkDividirCta.Checked) and (edtCliente.Text <> '') then begin
    QFacturaNombre.Text := edtCliente.Text;
    edtCliente.Clear;
    edtCliente.SetFocus;
    end;
    QFacturaTipoNCF.Value := TipoNCF;
    if not CkDividirCta.Checked then
    lbmesa.Caption        := 'FACTURA DIRECTA';
    QFacturaConItbis.Value   := ckItbis;
    if QFacturaMesaID.Value > 0 then
    ckPropina  := true else
    ckPropina  := False;
    QFacturaConPropina.Value := ckPropina;
    QFacturaimprimeNCF.Value := ckNCF;
    QFacturaCajaID.Value     := 1;
    //QFactura.Parameters.ParamByName('caja').Value := 1;

    QFactura.Post;

    rnc := '';
    razon_social := '';

    TExento    := 0;
    TItbis     := 0;
    TPropina   := 0;
    TGrabado   := 0;
    TDescuento := 0;
    Total      := 0;

    lbtotal.Caption     := '0.00';
    lbpropina.Caption   := '0.00';
    lbGrabado.Caption   := '0.00';
    lbsubtotal.Caption  := '0.00';
    lbdescuento.Caption := '0.00';
    lbitbis.Caption     := '0.00';
    lbexento.Caption    := '0.00';

    //Liberar registro de bloqueo
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('set dateformat ymd update Factura_RestBar set Abierta = 0, AbiertaPor = NULL, AbiertaDesde = ''1900-01-01'' where facturaid ='+QFacturaFacturaID.Text+' and hold = 1 AND AbiertaDesde IS NOT NULL');
    DM.Query1.ExecSQL;

    QFactura.Close;
    QFactura.Parameters.ParamByName('caj').Value  := frmMain.Usuario;
    QFactura.Parameters.ParamByName('fac').Value  := -1;
    QFactura.Parameters.ParamByName('caja').Value := 1;
    QFactura.Open;

    QForma.Close;
    QForma.Parameters.ParamByName('caj').Value  := frmMain.Usuario;
    QForma.Parameters.ParamByName('fac').Value  := -1;
    QForma.Parameters.ParamByName('caja').Value := 1;
    QForma.Open;

    QDetalle.Close;
    QDetalle.Parameters.ParamByName('caj').Value  := frmMain.Usuario;
    QDetalle.Parameters.ParamByName('fac').Value  := -1;
    QDetalle.Parameters.ParamByName('caja').Value := 1;
    QDetalle.Open;

    QDetalleTotal.Close;
    QDetalleTotal.Open;

    QIngredientes.Open;


    TipoNCF := 1;
    lbrnc.Caption  := 'COMPROBANTE CONSUMIDOR FINAL';
    if not CkDividirCta.Checked then begin
    lbmesa.Caption := 'FACTURA DIRECTA';
    edtCliente.Clear;
    edtCliente.Visible := False;
    CkDividirCtaClick(Sender);
    CkDividirCta.Enabled := False;
    vl_mesa := 0;
    end;
    ckItbis := DM.QParametrosRestBar_FactConItbis.value;// true;
    ckConItbis.Checked:=  ckItbis ;

    edproducto.SetFocus;
  end
  else
  begin
    vl_mesa := 0;
    Application.CreateForm(tfrmHold, frmHold);
    if not frmMain.Camarero then
    begin
      frmHold.QFacturas.Close;
      frmHold.QFacturas.SQL.Clear;
      {frmHold.QFacturas.SQL.Add('declare @caja int');
      frmHold.QFacturas.SQL.Add('set @caja = :caj');
      frmHold.QFacturas.SQL.Add('select f.FacturaID, f.Fecha, ');
      frmHold.QFacturas.SQL.Add('RTRIM(m.Nombre)+ISNULL(CASE WHEN ISNULL(F.NOMBRE,"")<> "" THEN "/" +RTRIM(F.NOMBRE) END,'') NOMBRE,');
      frmHold.QFacturas.SQL.Add('f.Total, f.CajeroID, f.CajaID, f.Abierta, f.AbiertaPor');
      frmHold.QFacturas.SQL.Add('from Factura_RestBar f');
      frmHold.QFacturas.SQL.Add('left outer join Mesas m on (f.MesaID = m.MesaID)');
      frmHold.QFacturas.SQL.Add('where f.Hold = 1 and (f.CajeroID = @caja or f.CajeroID = 0)');
      frmHold.QFacturas.SQL.Add('and f.CajaID = @caja and f.estatus <> "ANU"');
      frmHold.QFacturas.SQL.Add('order by f.Fecha');}
      frmHold.QFacturas.SQL.Add(frmHold.qQuery.SQL.GetText);
      frmHold.QFacturas.Parameters.ParamByName('caj').DataType := ftInteger;
      frmHold.QFacturas.Parameters.ParamByName('caj').Value  := frmMain.Usuario;
      
      frmHold.QFacturas.Parameters.ParamByName('caja').DataType := ftInteger;
      frmHold.QFacturas.Parameters.ParamByName('caja').Value := 1;
    end
    else
    begin
      frmHold.QFacturas.Parameters.ParamByName('caj').Value  := frmMain.Usuario;
      frmHold.QFacturas.Parameters.ParamByName('caja').Value := 1;
    end  ;
    //frmHold.QFacturas.Parameters.ParamByName('caj').Value := 1;
    frmHold.QFacturas.Open;
    frmHold.QDetalle.Open;

    frmHold.ShowModal;
    if frmHold.Acepto = 1 then
    begin
      Totaliza := False;
      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value  := frmHold.QFacturasCajeroID.Value;
      QFactura.Parameters.ParamByName('fac').Value  := frmHold.QFacturasFacturaID.Value;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;
      vl_mesa := QFacturaMesaID.Value;
      
      ckItbis := QFacturaConItbis.Value;
      ckConItbis.Checked := ckItbis;
     // ckConItbisClick(self);

      //ckConItbis.Checked:=  ckItbis ;

      if QFacturaMesaID.Value > 0 then
      if QFacturaConPropina.Value = False then begin
      QFactura.Edit;
      QFacturaConPropina.Value := True;
      QFactura.Post;
      QFactura.UpdateBatch();
      end;

      DM.Query1.Close;
      DM.Query1.SQL.Clear;
      DM.Query1.SQL.Add('update Factura_RestBar set Abierta = 1, AbiertaPor = :AbiertaPor, AbiertaDesde = getdate() where facturaid = :ID and hold = 1');
      dm.Query1.Parameters.ParamByName('AbiertaPor').DataType := ftString;
      dm.Query1.Parameters.ParamByName('ID').DataType := ftInteger;
      dm.Query1.Parameters.ParamByName('AbiertaPor').Value := QuotedStr(lbUsuario.Caption+'/'+GetComputerName);
      dm.Query1.Parameters.ParamByName('ID').Value         := QFacturaFacturaID.Value;
      DM.Query1.ExecSQL;

        //bloquear mesas con productos
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st ');
        dm.Query1.SQL.Add('where MESAID IN ');
        DM.Query1.SQL.Add('(select MesaID from Factura_RestBar WHERE ESTATUS = ''ABI'' AND MESAID > 0 AND HOLD = 1)');
        dm.Query1.Parameters.ParamByName('st').Value   := 'ABI';
        dm.Query1.ExecSQL;   

      ckPropina := QFacturaConPropina.Value;
      ckNCF     := QFacturaimprimeNCF.Value;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value  := QFacturaCajeroID.Value;
      QDetalle.Parameters.ParamByName('fac').Value  := QFacturaFacturaID.Value;
      QDetalle.Parameters.ParamByName('caja').Value := QFacturaCajaID.Value;
      QDetalle.Open;

      QDetalleTotal.Close;
      QDetalleTotal.Open;

    QDetalle.Edit;
    QDetalle.Post;
    QDetalle.UpdateBatch;

    Totaliza := True;
    Totalizar;

      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value  := QFacturaCajeroID.Value;
      QForma.Parameters.ParamByName('fac').Value  := QFacturaFacturaID.Value;
      QForma.Parameters.ParamByName('caja').Value := QFacturaCajaID.Value;
      QForma.Open;

      QIngredientes.Open;

      TipoNCF := QFacturaTipoNCF.Value;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
      dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
      dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
      dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
      dm.Query1.Open;

      razon_social := QFacturaNombre.Value;
      rnc := QFacturarnc.Value;

      lbrnc.Caption  := dm.Query1.FieldbyName('Nombre').AsString + #13 +
          razon_social + #13 + rnc;

      if QFacturaMesaID.Value > 0 then begin
        lbmesa.Caption := 'ATENDIENDO MESA #' + frmHold.QFacturasNombre.Value;
        vl_mesa := QFacturaMesaID.Value;
      exit;
      end
      else begin
        lbmesa.Caption := 'FACTURA DIRECTA';
      end;
      edproducto.SetFocus;       



    end;
  end;




  //Buscar PRecio si tiene mesa
      if QFacturaMesaID.Value > 0 then begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select isnull(precio,''Precio1'') Precio from areas');
      dm.Query1.SQL.Add('where areaid in');
      dm.Query1.SQL.Add('(select areaid from Mesas where MesaID = '+QuotedStr(QFacturaMesaID.Text)+')');
      dm.Query1.Open;
      vl_precio := dm.Query1.FieldByname('Precio').Value;
      end;


 //Recargar Categorias
 CargarCategorias();
end;

procedure TfrmPOS.btcashClick(Sender: TObject);
begin
if validaDivisionCuenta(QDetalleFacturaID.AsString) then
   ShowMessage('Esta factura tiene Divisiones de Cuenta, Verifique...')
else
  if Total > 0 then
  begin
    Application.CreateForm(tfrmCash, frmCash);
    frmCash.Total := Total;
    frmCash.Monto := 0;
    frmCash.Devuelta := frmCash.Total - frmCash.Monto;
    frmCash.lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+FormatCurr('#,0.00',frmCash.Devuelta);
    frmCash.ShowModal;
    if frmCash.Facturo = 1 then
    begin
      QDetalle.DisableControls;
      QDetalle.First;
      while not QDetalle.Eof do
      begin
        QDetalle.Edit;
        QDetalleCajeroID.Value := frmMain.Usuario;
        QDetalle.Post;
        QDetalle.Next;
      end;
      QDetalle.First;
      QDetalle.EnableControls;
      QDetalle.UpdateBatch;

      QFactura.Edit;
      QFacturaHold.Value    := False;
      QFacturaEstatus.Value := 'FAC';
      QFacturarnc.Value     := rnc;
      QFacturaNombre.Value  := razon_social;
      QFacturaHora.Value    := Now;
      QFacturaFecha.Value   := Date;
      QFacturaTipoNCF.Value := TipoNCF;
      QFacturaConItbis.Value   := ckItbis;
      QFacturaConPropina.Value := ckPropina;
      QFacturaimprimeNCF.Value := ckNCF;
      QFacturaCajeroID.Value   := frmMain.Usuario;

      //Insertando Forma de Pago
      //Buscando el id del pago
      QForma.Insert;
      QFormaCajeroID.Value  := QFacturaCajeroID.Value;
      QFormaFacturaID.Value := QFacturaFacturaID.Value;
      QFormaCajaID.Value    := QFacturaCajaID.Value;
      QFormaMonto.Value     := frmCash.Monto;
      QFormaDevuelta.Value  := frmCash.Devuelta;
      QFormaForma.Value     := 'Efectivo';
      QForma.Post;
      QForma.UpdateBatch;

      MPagado  := frmCash.Monto;
      Devuelta := frmCash.Devuelta;

      //Buscando comprobante
      if TipoNCF = 1 then
      begin
        QFacturarnc.Clear;
      end;

      if QFacturaimprimeNCF.Value then
      begin
      qNCFAdm.Close;
      qNCFAdm.Parameters.ParamByName('tipo').Value := TipoNCF;
      qNCFAdm.Parameters.ParamByName('emp').Value  := DM.QEmpresaEmpresaID.Value;
      qNCFAdm.Open;
      if qNCFAdm.RecordCount > 0 then
      begin
        QFacturaNCF.Value := qNCFAdm.FieldByName('NCF').Value + FormatFloat('00000000', qNCFAdm.FieldByName('Sec').AsInteger);

        if ImpresoraFiscal.IDPrinter = 0 then
        dm.ADOBar.Execute('update NCF set NCF_Secuencia = NCF_Secuencia + 1 where ncf_fijo = case when '+IntToStr(TipoNCF)+' = 1 then ''B02'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 2 then ''B01'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 3 then ''B15'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 4 then ''B14'' end '+
                                                                                            'and emp_codigo ='+IntToStr(DM.QEmpresaEmpresaID.Value)) else
      dm.ADOBar.Execute('update NCF set NCF_Secuencia = NCF_Secuencia + 1 where ncf_fijo = case when '+IntToStr(TipoNCF)+' = 1 then ''00000000B02'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 2 then ''00000000B01'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 3 then ''00000000B15'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 4 then ''00000000B14'' end '+
                                                                                            'and emp_codigo ='+IntToStr(DM.QEmpresaEmpresaID.Value));

      end;
      end;
      QFactura.Post;



      if vl_mesa > 0 then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.SQL.Add('AND estatus IN (''ABI'')  ');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
       end;

      //Imprimiendo
      vl_cuenta := False;
      case ImpresoraFiscal.IDPrinter of
      0:ImpTicket;
      1,2,3,4,5:begin
      ImpresoraFiscal.isPrinterError := not ImprimeTicketFiscal();
      if ImpresoraFiscal.isPrinterError then
      exit;
      end;
      end;

      TExento    := 0;
      TItbis     := 0;
      TPropina   := 0;
      TGrabado   := 0;
      TDescuento := 0;
      Total      := 0;

      lbtotal.Caption     := '0.00';
      lbpropina.Caption   := '0.00';
      lbGrabado.Caption   := '0.00';
      lbsubtotal.Caption  := '0.00';
      lbdescuento.Caption := '0.00';
      lbitbis.Caption     := '0.00';
      lbexento.Caption    := '0.00';

      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QFactura.Parameters.ParamByName('fac').Value := -1;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;


      ckPropina  := False;
      

      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QForma.Parameters.ParamByName('fac').Value := -1;
      QForma.Parameters.ParamByName('caja').Value := 1;
      QForma.Open;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QDetalle.Parameters.ParamByName('fac').Value := -1;
      QDetalle.Parameters.ParamByName('caja').Value := 1;
      QDetalle.Open;

      QDetalleTotal.Close;
      QDetalleTotal.Open;

      Application.CreateForm(tfrmDevuelta, frmDevuelta);
      frmDevuelta.lbdevuelta.Caption := frmCash.lbdevuelta.Caption;
      frmDevuelta.ShowModal;
      frmDevuelta.Release;

      lbmesa.Caption := 'FACTURA DIRECTA';
      TipoNCF := 1;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
      dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
      dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
      dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
      dm.Query1.Open;
      lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString;

      rnc := '';
      razon_social := '';

    end;
    frmCash.Release;
    edproducto.SetFocus;
  end;
  ckItbis := DM.QParametrosRestBar_FactConItbis.value;// true;
  ckConItbis.Checked:=  ckItbis ;
end;

procedure TfrmPOS.btmesasClick(Sender: TObject);
begin
  //bloquear mesas con productos
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st ');
        dm.Query1.SQL.Add('where MESAID IN ');
        DM.Query1.SQL.Add('(select MesaID from Factura_RestBar WHERE ESTATUS = ''ABI'' AND MESAID > 0 and total > 0 AND HOLD = 1)');
        dm.Query1.Parameters.ParamByName('st').Value   := 'ABI';
        dm.Query1.ExecSQL;

        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st ');
        dm.Query1.SQL.Add('where MESAID NOT IN ');
        DM.Query1.SQL.Add('(select MesaID from Factura_RestBar WHERE ESTATUS = ''ABI'' AND MESAID > 0 and total > 0 AND HOLD = 1)');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.ExecSQL;


  Application.CreateForm(tfrmSeleccionMesa, frmSeleccionMesa);
  frmSeleccionMesa.ShowModal;
  
  if frmSeleccionMesa.MesaID > 0 then
  begin

    NuevoTicket;
    QFactura.Edit;
    QFacturaMesaID.Value := frmSeleccionMesa.MesaID;
    vl_mesa := frmSeleccionMesa.MesaID;
    QFacturaConItbis.Value   := ckItbis;
    QFacturaConPropina.Value := True;
    QFacturaimprimeNCF.Value := ckNCF;
    QFactura.Post;
    QFactura.UpdateBatch();
    ckPropina := True;
    frmPOS.vl_precio := frmSeleccionMesa.QAreasPrecio.Value;

    DM.ADOBar.Execute('UPDATE MESAS SET ESTATUS = '+QuotedStr('ABI')+' WHERE MESAID ='+QFacturaMesaID.Text);

    lbmesa.Caption := 'ATENDIENDO MESA: '+frmSeleccionMesa.NMesa;
    CkDividirCta.Checked := False;
    CkDividirCta.Enabled := True;

    Totalizar;
    btliberarmesa.Enabled := true;
  end;
  frmSeleccionMesa.Release;
end;

procedure TfrmPOS.btncfClick(Sender: TObject);
begin
  Application.CreateForm(tfrmNCF, frmNCF);
  frmNCF.ShowModal;
  if frmNCF.Acepto = 1 then
  begin
    TipoNCF := frmNCF.Comprobante;
    razon_social := frmNCF.nombre;
    rnc := frmNCF.rnc;
    frmNCF.Release;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
    dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
    dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
    dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
    dm.Query1.Open;
    lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString + #13 +
      razon_social + #13 + rnc;
  end;
end;

procedure TfrmPOS.edproductoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if Trim(edproducto.Text) <> '' then
    begin
      SeleccionaProducto(Trim(edproducto.Text));
      edproducto.Text := '';
    end;
  end;
end;

procedure TfrmPOS.bttarjetaClick(Sender: TObject);
begin
if validaDivisionCuenta(QDetalleFacturaID.AsString) then
   ShowMessage('Esta factura tiene Divisiones de Cuenta, Verifique...')
else
  if Total > 0 then
  begin
    Application.CreateForm(tfrmTarjeta, frmTarjeta);
    frmTarjeta.ShowModal;

    if frmTarjeta.Acepto = 1 then
    begin
      QDetalle.DisableControls;
      QDetalle.First;
      while not QDetalle.Eof do
      begin
        QDetalle.Edit;
        QDetalleCajeroID.Value := frmMain.Usuario;
        QDetalle.Post;
        QDetalle.Next;
      end;
      QDetalle.First;
      QDetalle.EnableControls;
      QDetalle.UpdateBatch;

      QFactura.Edit;
      QFacturaHold.Value    := False;
      QFacturaEstatus.Value := 'FAC';
      QFacturarnc.Value     := rnc;
      QFacturaNombre.Value  := razon_social;
      QFacturaHora.Value    := Now;
      QFacturaFecha.Value   := Date;
      QFacturaTipoNCF.Value := TipoNCF;
      QFacturaConItbis.Value   := ckItbis;
      QFacturaConPropina.Value := ckPropina;
      QFacturaimprimeNCF.Value := ckNCF;
      QFacturaCajeroID.Value   := frmMain.Usuario;

      //Insertando Forma de Pago
      QForma.Insert;
      QFormaCajeroID.Value  := QFacturaCajeroID.Value;
      QFormaFacturaID.Value := QFacturaFacturaID.Value;
      QFormaCajaID.Value    := QFacturaCajaID.Value;
      QFormaMonto.Value     := Total;
      QFormaDevuelta.Value  := 0;
      QFormaForma.Value     := 'Tarjeta';
      QFormaTipo_Tarjeta.Value   := frmTarjeta.ComboBox1.Text;
      QFormaAutorizacion.Value   := frmTarjeta.edautorizacion.Text;
      QFormaNumero_Tarjeta.Value := frmTarjeta.edtarjeta.Text;
      QFormaBanco.Value          := frmTarjeta.DBLookupComboBox1.Text;
      QForma.Post;
      QForma.UpdateBatch;

     {if frmPOS.QFacturaimprimeNCF.Value then
      begin
      qEjecutar.Close;
      qEjecutar.SQL.Clear;
      qEjecutar.SQL.Add('select isnull(NCF_Secuencia,0) sec,NCF_FIJO NCF from ncf');
      qEjecutar.SQL.Add('where ncf_fijo = case when :tipo = 1 then '+QuotedStr('B02'));
			qEjecutar.SQL.Add('                   	  when :tipo = 2 then '+QuotedStr('B01'));
			qEjecutar.SQL.Add('                   	  when :tipo = 3 then '+QuotedStr('B15'));
			qEjecutar.SQL.Add('                   	  when :tipo = 4 then '+QuotedStr('B14'));
			qEjecutar.SQL.Add('END');
      qEjecutar.Parameters.ParamByName('tipo').Value := frmPOS.TipoNCF;
      qEjecutar.Open;
      if qEjecutar.RecordCount > 0 then
      begin
        frmPOS.QFacturaNCF.Value := qEjecutar.FieldByName('NCF').Value + FormatFloat('00000000', qEjecutar.FieldByName('Sec').AsInteger);

        qEjecutar.Close;
        qEjecutar.SQL.Clear;
        qEjecutar.SQL.Add('update NCF set NCF_Secuencia = NCF_Secuencia + 1 ');
        qEjecutar.SQL.Add('where ncf_fijo = case when :tipo = 1 then '+QuotedStr('B02'));
			  qEjecutar.SQL.Add('                   	  when :tipo = 2 then '+QuotedStr('B01'));
			  qEjecutar.SQL.Add('                   	  when :tipo = 3 then '+QuotedStr('B15'));
			  qEjecutar.SQL.Add('                   	  when :tipo = 4 then '+QuotedStr('B14'));
        qEjecutar.SQL.Add('END');
        qEjecutar.Parameters.ParamByName('tipo').Value := frmPOS.TipoNCF;
        qEjecutar.ExecSQL;
      end;
      end;
      }

      if QFacturaimprimeNCF.Value then
      begin
      qNCFAdm.Close;
      qNCFAdm.Parameters.ParamByName('tipo').Value := TipoNCF;
      qNCFAdm.Parameters.ParamByName('emp').Value  := DM.QEmpresaEmpresaID.Value;
      qNCFAdm.Open;
      if qNCFAdm.RecordCount > 0 then
      begin
        QFacturaNCF.Value := qNCFAdm.FieldByName('NCF').Value + FormatFloat('00000000', qNCFAdm.FieldByName('Sec').AsInteger);

        dm.ADOBar.Execute('update NCF set NCF_Secuencia = NCF_Secuencia + 1 where ncf_fijo = case when '+IntToStr(TipoNCF)+' = 1 then ''B02'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 2 then ''B01'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 3 then ''B15'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 4 then ''B14'' end '+
                                                                                            'and emp_codigo ='+IntToStr(DM.QEmpresaEmpresaID.Value));
      end;
      end;
      QFactura.Post;


      if vl_mesa > 0 then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.SQL.Add('AND estatus IN (''ABI'')');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
      end;

      //Imprimiendo
      vl_cuenta := False;
      ImpTicket;

      TExento    := 0;
      TItbis     := 0;
      TPropina   := 0;
      TGrabado   := 0;
      TDescuento := 0;
      Total      := 0;
      ckPropina  := False;


      lbtotal.Caption     := '0.00';
      lbpropina.Caption   := '0.00';
      lbGrabado.Caption   := '0.00';
      lbsubtotal.Caption  := '0.00';
      lbdescuento.Caption := '0.00';
      lbitbis.Caption     := '0.00';
      lbexento.Caption    := '0.00';

      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QFactura.Parameters.ParamByName('fac').Value := -1;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;

      

      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QForma.Parameters.ParamByName('fac').Value := -1;
      QForma.Parameters.ParamByName('caja').Value := 1;
      QForma.Open;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QDetalle.Parameters.ParamByName('fac').Value := -1;
      QDetalle.Parameters.ParamByName('caja').Value := 1;
      QDetalle.Open;

      QDetalleTotal.Close;
      QDetalleTotal.Open;
      
      lbmesa.Caption := 'FACTURA DIRECTA';

      lbmesa.Caption := 'FACTURA DIRECTA';
      TipoNCF := 1;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
      dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
      dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
      dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
      dm.Query1.Open;
      lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString;

      rnc := '';
      razon_social := '';
    end;
    frmTarjeta.Release;
    edproducto.SetFocus;
  end;
  ckItbis := DM.QParametrosRestBar_FactConItbis.value;// true;
  ckConItbis.Checked:=  ckItbis ;

end;

procedure TfrmPOS.ImpTicket;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8, s9 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos, a, x : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis, codigoabre, Mesa : String;
begin
  if not FileExists( '.\puerto.ini') then
  begin
    assignfile(arch, '.\puerto.ini');
    rewrite(arch);
    writeln(arch,'PRN');
  end
  else
  begin
    assignfile(arch, '.\puerto.ini');
    reset(arch);
    readln(arch, Puerto);
  end;
  closefile(arch);

  assignfile(arch, '.\imp.bat');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, 'type '+ '.\fac.txt > '+Puerto);
  closefile(arch);

  assignfile(arch, '.\fac.txt');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, dm.centro(dm.QEmpresaNombre.Value));
  memo1.Lines.Clear;
  memo1.Lines.Add(dm.QEmpresaDireccion.Value);
  for a := 0 to memo1.Lines.Count-1 do
  begin
    writeln(arch, dm.centro(memo1.lines[a]));
  end;
  writeln(arch, dm.centro(dm.QEmpresaTelefono.Value));
  writeln(arch, dm.centro('RNC:'+dm.QEmpresaRNC.Value));
  writeln(arch, ' ');

  if not QFacturamesaid.Value > 0 then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    dm.Query1.SQL.Add('from Mesas m, Areas a');
    dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
    dm.Query1.SQL.Add('and m.mesaid = :cod');
    dm.Query1.SQL.Add('order by m.MesaID');
    dm.Query1.Parameters.ParamByName('cod').Value := QFacturamesaid.Value;
    dm.Query1.Open;

    writeln(arch,'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
  end;

  if QForma.RecordCount > 0 then
  begin
    writeln(arch, dm.centro('*** F A C T U R A ***'));
    if QFacturaCredito.Value then
       writeln(arch, dm.centro('* C R E D I T O *'));

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
    dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
    dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
    dm.Query1.Parameters.ParamByName('tipo').Value := QFacturaTipoNCF.Value;
    dm.Query1.Open;

    writeln(arch, dm.Centro(dm.Query1.FieldByName('Nombre').AsString));
  end
  else
    writeln(arch, dm.centro('*** C U E N T A ***'));

  writeln(arch, ' ');

  dm.Query1.close;
  dm.Query1.SQL.clear;
  dm.Query1.SQL.add('select usu_nombre Nombre from usuarios');
  dm.Query1.SQL.add('where usu_codigo = :usu');
  dm.Query1.Parameters.parambyname('usu').Value := frmMain.Usuario;
  dm.Query1.open;

  writeln(arch, 'Fecha .: '+DateToStr(Date)+' Factura: '+formatfloat('0000000000',QFacturaFacturaID.value));
  writeln(arch, 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(Now));
  writeln(arch, 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring);

  if not QFacturamesaid.IsNull then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    dm.Query1.SQL.Add('from Mesas m, Areas a');
    dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
    dm.Query1.SQL.Add('and m.mesaid = :cod');
    dm.Query1.SQL.Add('order by m.MesaID');
    dm.Query1.Parameters.ParamByName('cod').Value := QFacturamesaid.Value;
    dm.Query1.Open;

    writeln(arch, 'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
  end;

  if QFacturaNombre.Value <> '' then
  begin
    writeln(arch, 'Cliente: '+QFacturaNombre.Value);
    if Trim(QFacturarnc.Value) <> '' then
      writeln(arch, 'RNC ...: '+QFacturarnc.Value);
  end;

  if QFacturaNombre.Value = '' then
  begin
    writeln(arch, 'Cliente: [CLIENTE CONTADO]');
    if Trim(QFacturarnc.Value) <> '' then
      writeln(arch, 'RNC ...: '+QFacturarnc.Value);
  end;

  if QFacturaNCF.Value <> '' then
    writeln(arch, 'NCF    : '+QFacturaNCF.Value);

  //buscar vencimiento
      with qEjecutar do begin
      Close;
      sql.Clear;
      SQL.Add('select FechaVenc ');
      sql.Add('from NCF ');
      sql.Add('where VerificaVenc = 1');
      sql.Add('and NCF_Fijo   = LEFT(:NCF,3)');
      Parameters.ParamByName('NCF').Value        := QFacturaNCF.Text;
      Open;
      if not IsEmpty then
      writeln(arch,'Fecha Venc.: '+FieldByName('FechaVenc').text);
      end;
      writeln(arch,'');



  writeln(arch, '----------------------------------------');
  writeln(arch, 'CANT.       DESCRIPCION            TOTAL');
  writeln(arch, '----------------------------------------');
  TFac := 0;
  MontoItbis := 0;
  QDetalle.DisableControls;
  QDetalle.First;
  while not QDetalle.eof do
  begin
    s := '';
    FillChar(s, 5-length(FormatCurr('#,0.00',QDetalleCantidad.value)),' ');
    s1 := '';
    FillChar(s1, 10-length(trim(FormatCurr('#,0.00',QDetalleValor.value))), ' ');
    s2 := '';
    FillChar(s2, 22-length(copy(trim(QDetalleNombre.value),1,22)),' ');
    s3 := '';
    FillChar(s3, 8-length(trim(FormatCurr('#,0.00',QDetallePrecio.value))),' ');
    s4 := '';
    FillChar(s4, 8-length(trim(FormatCurr('#,0.00',(QDetallePrecio.value * QDetalleCantidad.Value)))),' ');

    if QDetalleItbis.value then
      lbitbis := 'G'
    else
      lbitbis := 'E';
    IF QDetalleIngrediente.Value then begin {fernando}
       IF QDetalleVisualizar.Value then
       writeln(arch, s+FormatCurr('#,0.00',QDetalleCantidad.value)+' '+
                  lbitbis+' '+copy(trim(QDetalleNombre.value),1,22)+s2+s1+FormatCurr('#,0.00',QDetalleSubTotal.value));
       end
    else
       writeln(arch, s+FormatCurr('#,0.00',QDetalleCantidad.value)+' '+
                  lbitbis+' '+copy(trim(QDetalleNombre.value),1,22)+s2+s1+FormatCurr('#,0.00',QDetalleSubTotal.value));

    TFac := TFac + QDetalleValor.value;
    if QDetalleComanda_Impreso.Value = False then begin
      QDetalle.Edit;
      QDetalleComanda_Impreso.Value := True;
      QDetalle.Post;
      QDetalle.UpdateBatch;
    end;
    QDetalle.next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
  writeln(arch, '                       -----------------');
  tCambio := Devuelta;

  s := '';
  FillChar(s, 10-length(trim(FormatCurr('#,0.00',MontoItbis-TFac))), ' ');
  s2:= '';
  FillChar(s2, 10-length(trim(FormatCurr('#,0.00',tCambio))), ' ');
  s3:= '';
  FillChar(s3, 10-length(trim(FormatCurr('#,0.00',QFacturaItbis.value))), ' ');
  s4:= '';
  FillChar(s4, 10-length(trim(FormatCurr('#,0.00',QFacturaTotal.value))), ' ');
  s5:= '';
  FillChar(s5, 10-length(trim(FormatCurr('#,0.00',QFacturaPropina.value))), ' ');
   //fernando
  s8:= '';
  FillChar(s8, 10-length(trim(FormatCurr('#,0.00',QFacturaDescuento.value))), ' ');
  s9:= '';
  FillChar(s9, 10-length(trim(FormatCurr('#,0.00',QDetalleSubTotal.Value))), ' ');
   //fin

  writeln(arch,'                   Sub-Total: '+s9+FormatCurr('#,0.00',QFacturaGrabado.value+QFacturaExento.Value));
  if (QFacturaDescuento.Value) > 0 then
     writeln(arch,'                   Descuento: '+s8+FormatCurr('#,0.00',QFacturaDescuento.value));
  if QForma.RecordCount > 0 then
  begin
    writeln(arch, ' ');
    writeln(arch,'                   Itbis    : '+s3+FormatCurr('#,0.00',QFacturaItbis.value));
    writeln(arch,'                   10% Ley  : '+s5+FormatCurr('#,0.00',QFacturaPropina.value));
    writeln(arch, ' ');
    writeln(arch,'               * * TOTAL    : '+s4+FormatCurr('#,0.00',QFacturaTotal.value));


///Formas de Pago Jhonattan Gomez 20191116_1123
    {writeln(arch,'                   Recibido : '+s1+FormatCurr('#,0.00',MPagado]));
    writeln(arch,'                   Cambio   : '+s2+FormatCurr('#,0.00',tCambio]));}
    qFormaPag.Close;
    qFormaPag.SQL.Clear;
    qFormaPag.SQL.Add('select forma, sum(monto) monto, isnull(sum(case when devuelta < 0 then 0 else Devuelta end),0) devuelta ');
    qFormaPag.SQL.Add('from RestBar_Factura_Forma_Pago');
    qFormaPag.SQL.Add('where FacturaID = :num and CajeroID = :Cajeroid');
    qFormaPag.SQL.Add('group by forma');
    qFormaPag.Parameters.ParamByName('num').Value := QFacturaFacturaID.Value;
    qFormaPag.Parameters.ParamByName('Cajeroid').Value := QFacturaCajeroID.Value;
    qFormaPag.Open;

    writeln(arch, ' ');
    qFormaPag.DisableControls;
    qFormaPag.First;
    tCambio:= 0;
    while not qFormaPag.Eof do
    begin
    s2:= '';
    FillChar(s2, 27-length(trim(qFormaPag.FieldByName('forma').asstring)), ' ');
    s3:= '';
    FillChar(s3, 10-length(trim(FormatCurr('#,0.00',qFormaPag.FieldByName('monto').Value))), ' ');
    writeln(arch,s2+trim(qFormaPag.FieldByName('forma').asstring)+' :'+s3+FormatCurr('#,0.00',qFormaPag.FieldByName('monto').Value));
    tCambio := tCambio + qFormaPag.FieldByName('devuelta').AsFloat;
    qFormaPag.Next;
    end;
    qFormaPag.EnableControls;
    s1:= '';
    FillChar(s1, 10-length(trim(FormatCurr('#,0.00',tCambio))), ' ');
    writeln(arch,'                  CAMBIO    :' +s1+FormatCurr('#,0.00',tCambio));

    if qFormaPag.FieldByName('forma').asstring = 'Tarjeta' then
    begin
       MPagado :=  QFacturaTotal.Value;
       tCambio :=  0;
    end;

    writeln(arch,'');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)))), ' ');
      writeln(arch,'                    Dólares : '+s6+FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)))), ' ');
      writeln(arch,'                    Euros   : '+s7+FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)));
    end;

    if QFacturaCredito.Value then
    begin
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, '--------------------------');
      writeln(arch, 'Firma del Cliente');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, '--------------------------');
      writeln(arch, 'Firma del Supervisor');
    end;
  end
  else
  begin
    writeln(arch, ' ');
    writeln(arch,'                    Itbis   : '+s3+FormatCurr('#,0.00',QFacturaItbis.value));
    writeln(arch,'                    10% Ley : '+s5+FormatCurr('#,0.00',QFacturaPropina.value));
//    if (QFacturaDescuento.Value > 0) then
//    writeln(arch,'                   Descuento: '+s8+FormatCurr('#,0.00',QFacturaDescuento.value));
    writeln(arch, ' ');
    writeln(arch,'               * * TOTAL    : '+s4+FormatCurr('#,0.00',QFacturaTotal.value));
    writeln(arch, ' ');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)))), ' ');
      writeln(arch,'                    Dólares : '+s6+FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)))), ' ');
      writeln(arch,'                    Euros   : '+s7+FormatCurr('#,0.00',(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)));
    end;
  end;
  writeln(arch, ' ');
  writeln(arch, dm.centro(dm.QEmpresaMensaje1.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje2.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje3.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje4.AsString));
  writeln(arch, ' ');
  writeln(arch, dm.centro('<< COPYRIGHT DASHA RESTBAR 809-240-5197 >>'));
  for x:=1 to 7 do begin
  writeln(arch, ' ');
  end;


  //Abre Caja
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := DM.QEmpresaEmpresaID.Value;
  dm.Query1.Open;
  codigoabre := dm.Query1.FieldByName('codigo_abre_caja').AsString;

  if codigoabre = 'Termica' then
  writeln(arch,chr(27)+chr(109));

  IF vl_cuenta =  False THEN
  pnabrircaja;

  closefile(Arch);
  winexec(pchar({ExtractFilePath(Application.ExeName)+}'.\imp.bat'),0);
end;

function TfrmPOS.ImprimeCtaTicketNoFiscal: boolean;
begin


  case ImpresoraFiscal.IDPrinter of
        1 : {EPSON (TMU-220)} result := ImprimeCtaTicketNoFiscalEpson(ImpresoraFiscal);
        2 : {CITIZEN ( CT-S310 )}  result := ImpTicketVmaxFiscal(ImpresoraFiscal);
        //3 : {CITIZEN (GSX-190)}    ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
        //4 : {STAR (TSP650FP)}      ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
        5 : {Bixolon SRP-350iiHG}  result := ImprimeCtaTicketNoFiscalBixolon(ImpresoraFiscal);
  end;
end;

procedure TfrmPOS.btimprimirClick(Sender: TObject);
begin
  vl_cuenta := True;
if validaDivisionCuenta(QDetalleFacturaID.AsString) then
   ShowMessage('Esta factura tiene Divisiones de Cuenta, Verifique...')
else
  if Total > 0 then
   titulo_cuenta := '*** PRE-CUENTA ***';

   case ImpresoraFiscal.IDPrinter of
   0:ImpTicket;
   1,2,3,4:ImpresoraFiscal.isPrinterError := not ImprimeCtaTicketNoFiscal;
   end;

btholdClick(nil);
end;

procedure TfrmPOS.btcreditoClick(Sender: TObject);
begin
if validaDivisionCuenta(QDetalleFacturaID.AsString) then
   ShowMessage('Esta factura tiene Divisiones de Cuenta, Verifique...')
else
  if Total > 0 then
  begin
    Application.CreateForm(tfrmNombreCliente, frmNombreCliente);
    frmNombreCliente.ShowModal;
    if frmNombreCliente.Acepto = 1 then
    begin
      QDetalle.DisableControls;
      QDetalle.First;
      while not QDetalle.Eof do
      begin
        QDetalle.Edit;
        QDetalleCajeroID.Value := frmMain.Usuario;
        QDetalle.Post;
        QDetalle.Next;
      end;
      QDetalle.First;
      QDetalle.EnableControls;
      QDetalle.UpdateBatch;

      QFactura.Edit;
      QFacturaHold.Value    := False;
      QFacturaEstatus.Value := 'FAC';
      QFacturarnc.Value     := rnc;
      QFacturaNombre.Value  := razon_social;
      QFacturaHora.Value    := Now;
      QFacturaFecha.Value   := Date;
      QFacturaTipoNCF.Value := TipoNCF;
      QFacturaCredito.Value := True;
      QFacturaNombre.Value  := frmNombreCliente.edcliente.Text;
      QFacturaConItbis.Value   := ckItbis;
      QFacturaConPropina.Value := ckPropina;
      QFacturaimprimeNCF.Value := ckNCF;
      QFacturaCajeroID.Value   := frmMain.Usuario;
      actbalance := 'True';

      //Insertando Forma de Pago
      QForma.Insert;
      QFormaCajeroID.Value  := QFacturaCajeroID.Value;
      QFormaFacturaID.Value := QFacturaFacturaID.Value;
      QFormaCajaID.Value    := QFacturaCajaID.Value;
      QFormaMonto.Value     := 0;
      QFormaDevuelta.Value  := 0;
      QFormaForma.Value     := 'Credito';
      QForma.Post;
      QForma.UpdateBatch;

       if QFacturaimprimeNCF.Value then
      begin
      qNCFAdm.Close;
      qNCFAdm.Parameters.ParamByName('tipo').Value := TipoNCF;
      qNCFAdm.Parameters.ParamByName('emp').Value  := DM.QEmpresaEmpresaID.Value;
      qNCFAdm.Open;
      if qNCFAdm.RecordCount > 0 then
      begin
        QFacturaNCF.Value := qNCFAdm.FieldByName('NCF').Value + FormatFloat('00000000', qNCFAdm.FieldByName('Sec').AsInteger);

        dm.ADOBar.Execute('update NCF set NCF_Secuencia = NCF_Secuencia + 1 where ncf_fijo = case when '+IntToStr(TipoNCF)+' = 1 then ''B02'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 2 then ''B01'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 3 then ''B15'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 4 then ''B14'' end '+
                                                                                            'and emp_codigo ='+IntToStr(DM.QEmpresaEmpresaID.Value));
      end;
      end;
      
      QFactura.Post;


      if vl_mesa > 0 then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.SQL.Add('AND estatus IN (''ABI'')');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
      end;

      //Imprimiendo
      vl_cuenta := False;
      ImpTicket;

      TExento    := 0;
      TItbis     := 0;
      TPropina   := 0;
      TGrabado   := 0;
      TDescuento := 0;
      Total      := 0;
      ckPropina  := False;

      lbtotal.Caption     := '0.00';
      lbpropina.Caption   := '0.00';
      lbGrabado.Caption   := '0.00';
      lbsubtotal.Caption  := '0.00';
      lbdescuento.Caption := '0.00';
      lbitbis.Caption     := '0.00';
      lbexento.Caption    := '0.00';

      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QFactura.Parameters.ParamByName('fac').Value := -1;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;

      
      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QForma.Parameters.ParamByName('fac').Value := -1;
      QForma.Parameters.ParamByName('caja').Value := 1;
      QForma.Open;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QDetalle.Parameters.ParamByName('fac').Value := -1;
      QDetalle.Parameters.ParamByName('caja').Value := 1;
      QDetalle.Open;

      QDetalleTotal.Close;
      QDetalleTotal.Open;
      
      lbmesa.Caption := 'FACTURA DIRECTA';

      lbmesa.Caption := 'FACTURA DIRECTA';
      TipoNCF := 1;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
      dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
      dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
      dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
      dm.Query1.Open;
      lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString;

      rnc := '';
      razon_social := '';
    end;
    frmNombreCliente.Release;
    edproducto.SetFocus;
     ckItbis := DM.QParametrosRestBar_FactConItbis.value;// true;
  ckConItbis.Checked:=  ckItbis ;
  end;
end;

procedure TfrmPOS.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    edproducto.Text := frmTeclado.edteclado.Text;
  frmTeclado.Release;
end;

procedure TfrmPOS.btdescuentoClick(Sender: TObject);
begin
 if frmPOS.QDetalle.RecordCount > 0 then
  begin
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    if frmAcceso.Acepto = 1 then
    begin
      dm.Query1.close;
      dm.Query1.sql.clear;
      dm.Query1.sql.add('select usu_codigo UsuarioID, usu_nombre Nombre, usu_supervisor Supervisor, usu_cajero Cajero, usu_camarero Camarero, usu_status Estatus');

      {if (copy(frmAcceso.edclave.Text,1,1) = ';') or (copy(frmAcceso.edclave.Text,1,1) = 'Ñ') then
      begin
        dm.Query1.sql.add('from usuarios where tarjetaSupervisorID = :cla');
        dm.Query1.Parameters.parambyname('cla').Value := copy(frmAcceso.edclave.Text,2,10);
      end
      else
      begin}
        dm.Query1.sql.add('from Usuarios where usu_Clave = :cla');
        dm.Query1.Parameters.parambyname('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);
      
      dm.Query1.open;
      if dm.Query1.recordcount = 0 then
      begin
        showmessage('ESTE USUARIO NO EXISTE')
      end
      else if dm.Query1.FieldbyName('Estatus').AsString <> 'ACT' then
      begin
        showmessage('ESTE USUARIO NO ESTA ACTIVO');
      end
      else if not dm.Query1.FieldbyName('Supervisor').AsBoolean then
      begin
        showmessage('ESTE USUARIO NO ES SUPERVISOR');
      end
      else
      begin
        Application.CreateForm(tfrmDescuento, frmDescuento);
        frmPos.QDetalle.Edit;
        frmPos.QFactura.Edit;
        frmDescuento.ShowModal;
        if frmDescuento.Acepto = 1 then
        begin
          case frmDescuento.ckDescuentoGlobal.Checked of
            false : begin
                      frmPOS.QFactura.Post;
                      frmPOS.QDetalle.Post;
                      frmPOS.QDetalle.UpdateBatch;
                      frmPOS.Totalizar;
                    end;
            true  : begin
                      frmPOS.QFactura.Post;
                      frmPOS.QDetalle.Cancel;
                      frmPOS.Totalizar;
                    end;
          end;
        end
        else
           begin
            frmPOS.QDetalle.Cancel;
            frmPOS.QFactura.Cancel;
           end;
        end;
 {         if frmPOS.QFactura.State in [dsedit,dsinsert] then
             begin
              frmPOS.QFactura.Post;
              frmPOS.QFactura.UpdateBatch;
             end
          else
            frmPos.QFactura.Cancel;
          if frmPOS.QDetalle.State in [dsedit,dsinsert] then
             begin
              frmPOS.QDetalle.Post;
              frmPOS.QDetalle.UpdateBatch;
             end
          //frmPOS.Totalizar;
          else
            frmPos.QDetalle.Cancel;
        end; //}
        frmDescuento.Release;
      end;
   // end;
    frmAcceso.Release;
  end;
end;

procedure TfrmPOS.FormActivate(Sender: TObject);
begin
  btcash.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  bttarjeta.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  btcredito.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  btncf.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  btdescuento.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);

  dm.getParametrosPrinterFiscal();
end;

procedure TfrmPOS.btnImpComandaClick(Sender: TObject);
begin
  if getActivaComanda(QFactura['FacturaID']) then   begin
  setImprimeComanda(QFactura['FacturaID']);
  //ImpComanda(QFacturaFacturaID.Value);
    end
  else
    begin
     // if dm.adoMultiUso.State <> dsinactive then {Esta validacion es para evitar errores de programacion - fernando 20170628}
       //  begin
         //  MessageDlg('ERROR - [900] Contacte a Soporte Tecnico del DASHA',mtError,[mbok],0);
           //Exit;
        // end
      //else

      With dm.adoMultiUso do begin
        Close;
        Sql.Clear;
        Sql.add('Select count(*) as total From ComandaC a,ComandaD b ');
        SQL.Add('Where a.FacturaID = :ID');
        SQL.Add('  and a.ComandaID = b.ComandaID');
        SQL.Add('  and b.Impreso = 1');
        Parameters.ParamByName('ID').Value := QFacturaFacturaID.Value;
        Open;
        if FieldByName('total').Value > 0 then
          begin
            close;
            if dm.Confirme(MSG_COMANDA_REIMPRESION) then begin
              ImpComanda(QFacturaFacturaID.Value,True);
              IF vl_impresoraN <> '' THEN
              ImpComanda2(QFacturaFacturaID.Value,True);
              end;
              end
              else
          close;
      end;

    end; //fin del else
    btholdClick(nil);
end;

procedure TfrmPOS.dsDetalleDataChange(Sender: TObject; Field: TField);
begin
   btnImpComanda.Enabled := ((dsDetalle.DataSet.State = dsBrowse) and
      (dsDetalle.DataSet.RecordCount > 0 ));
end;

procedure TfrmPOS.adoComandaDNewRecord(DataSet: TDataSet);
begin
  //daset['']:=
end;

procedure TfrmPOS.btliberarmesaClick(Sender: TObject);
begin
  {
if (QFactura.Active)and(QFactura.RecordCount > 0) then
  if(Trim(lbtotal.Caption) = '0.00') and (QFacturaMesaID.Value <> 0) then begin
    if liberarMesa(QFacturaMesaID.AsString) then
       begin
         QFactura.Delete;
         QFactura.close;
         QFactura.Open;
         Total := 0;
         lbmesa.Caption := '';
       end;
    end
    else
    ShowMessage('Para liberar la mesa no deben haber productos.....');
   }

end;

function TfrmPOS.liberarMesa(mesaID: string): boolean;
var Qtemp: TADOQuery;
begin
  Result := false;
  Qtemp := TADOQuery.Create(self);
  with Qtemp,SQL do
    begin
      Connection := QDetalle.Connection;
      close;
      clear;
      Add('update Mesas set Estatus='+QuotedStr('DISP')+' where MesaID='+mesaID);
      try
        ExecSQL;
      finally
        Result := true;
      end;
    end;
  Qtemp.Free;
end;

procedure TfrmPOS.btCombinadoClick(Sender: TObject);
begin
if validaDivisionCuenta(QDetalleFacturaID.AsString) then
   ShowMessage('Esta factura tiene Divisiones de Cuenta, Verifique...')
else
  if Total > 0 then
  begin
    Application.CreateForm(TfrmCombinado, frmCombinado);
    frmCombinado.Total := Total;
    frmCombinado.Monto := QFacturaPagado.Value;
//OLD    frmCombinado.Monto := 0;
    frmCombinado.Devuelta := frmCombinado.Total - frmCombinado.Monto;
    frmCombinado.lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+FormatCurr('#,0.00',frmCombinado.Devuelta);
    frmCombinado.ShowModal;

    if frmCombinado.Facturo = 1 then
    Begin {20170421}
      QFactura.Edit;
      QFacturaHold.Value    := False;
      QFacturaEstatus.Value := 'FAC';
      QFacturarnc.Value     := rnc;
      QFacturaNombre.Value  := razon_social;
      QFacturaHora.Value    := Now;
      QFacturaFecha.Value   := Date;
      QFacturaTipoNCF.Value := TipoNCF;
      QFacturaConItbis.Value   := ckItbis;
      QFacturaConPropina.Value := ckPropina;
      QFacturaimprimeNCF.Value := ckNCF;
      QFacturaCajeroID.Value   := frmMain.Usuario;




       if QFacturaimprimeNCF.Value then
      begin
      qNCFAdm.Close;
      qNCFAdm.Parameters.ParamByName('tipo').Value := TipoNCF;
      qNCFAdm.Parameters.ParamByName('emp').Value  := DM.QEmpresaEmpresaID.Value;
      qNCFAdm.Open;
      if qNCFAdm.RecordCount > 0 then
      begin
        QFacturaNCF.Value := qNCFAdm.FieldByName('NCF').Value + FormatFloat('00000000', qNCFAdm.FieldByName('Sec').AsInteger);

        dm.ADOBar.Execute('update NCF set NCF_Secuencia = NCF_Secuencia + 1 where ncf_fijo = case when '+IntToStr(TipoNCF)+' = 1 then ''B02'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 2 then ''B01'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 3 then ''B15'''+
                                                                                            'when '+IntToStr(TipoNCF)+' = 4 then ''B14'' end '+
                                                                                            'and emp_codigo ='+IntToStr(DM.QEmpresaEmpresaID.Value));
      end;
      end;

      QFactura.Post;

      DM.ADOBar.Execute('update Factura_RestBar set conbinado = 1 where facturaid = '+QFacturaFacturaID.Text);

      MPagado  := frmCombinado.Monto;
      Devuelta := frmCombinado.Devuelta;

     if vl_mesa > 0 then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.SQL.Add('AND estatus IN (''ABI'') AND MESAID NOT IN ');
        DM.Query1.SQL.Add('(SELECT mesaid FROM Factura_RestBar WHERE Estatus = ''ABI'' and mesaid > 0)');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
      end;

      //Imprimiendo
      vl_cuenta := False;
      ImpTicket;

      TExento    := 0;
      TItbis     := 0;
      TPropina   := 0;
      TGrabado   := 0;
      TDescuento := 0;
      Total      := 0;
      ckPropina  := False;

      lbtotal.Caption     := '0.00';
      lbpropina.Caption   := '0.00';
      lbGrabado.Caption   := '0.00';
      lbsubtotal.Caption  := '0.00';
      lbdescuento.Caption := '0.00';
      lbitbis.Caption     := '0.00';
      lbexento.Caption    := '0.00';

      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QFactura.Parameters.ParamByName('fac').Value := -1;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;

      
      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QForma.Parameters.ParamByName('fac').Value := -1;
      QForma.Parameters.ParamByName('caja').Value := 1;
      QForma.Open;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QDetalle.Parameters.ParamByName('fac').Value := -1;
      QDetalle.Parameters.ParamByName('caja').Value := 1;
      QDetalle.Open;

      QDetalleTotal.Close;
      QDetalleTotal.Open;

      lbmesa.Caption := 'FACTURA DIRECTA';

      lbmesa.Caption := 'FACTURA DIRECTA';
      TipoNCF := 1;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
      dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
      dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
      dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
      dm.Query1.Open;
      lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString;

      rnc := '';
      razon_social := '';
    end;  {fin 20170421}
  end;
  frmCombinado.Release;
  edproducto.SetFocus;
  ckItbis := DM.QParametrosRestBar_FactConItbis.value;// true;
  ckConItbis.Checked:=  ckItbis ;
end;

procedure TfrmPOS.IniTicket;
begin
      TExento    := 0;
      TItbis     := 0;
      TPropina   := 0;
      TGrabado   := 0;
      TDescuento := 0;
      Total      := 0;
      ckPropina  := False;
      ckItbis    := DM.QParametrosRestBar_FactConItbis.value;//True;

      lbtotal.Caption     := '0.00';
      lbpropina.Caption   := '0.00';
      lbGrabado.Caption   := '0.00';
      lbsubtotal.Caption  := '0.00';
      lbdescuento.Caption := '0.00';
      lbitbis.Caption     := '0.00';
      lbexento.Caption    := '0.00';

      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QFactura.Parameters.ParamByName('fac').Value := -1;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;

      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QForma.Parameters.ParamByName('fac').Value := -1;
      QForma.Parameters.ParamByName('caja').Value := 1;
      QForma.Open;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      QDetalle.Parameters.ParamByName('fac').Value := -1;
      QDetalle.Parameters.ParamByName('caja').Value := 1;
      QDetalle.Open;

      QDetalleTotal.Close;
      QDetalleTotal.Open;
{
      Application.CreateForm(tfrmDevuelta, frmDevuelta);
      frmDevuelta.lbdevuelta.Caption := frmCash.lbdevuelta.Caption;
      frmDevuelta.ShowModal;
      frmDevuelta.Release;
}
      lbmesa.Caption := 'FACTURA DIRECTA';
      TipoNCF := 1;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
      dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
      dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
      dm.Query1.Parameters.ParamByName('tipo').Value := TipoNCF;
      dm.Query1.Open;
      lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString;

      rnc := '';
      razon_social := '';

end;

function TfrmPOS.validaDivisionCuenta(facturaID: string): boolean;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select div_grupo from factura_items where div_Pago = 1 and facturaID = :facturaID');
  dm.Query1.Parameters.ParamByName('facturaID').Value := facturaID;
  dm.Query1.Open;
  Result := not dm.Query1.IsEmpty;
end;

procedure TfrmPOS.impArchivoTxt(var vfile:TextFile; vNombrePrt:string);
var text : string;
    Prn  : TextFile;
    pr   : TPrinter;
begin
pr := TPrinter.Create;
//  ShowMessage(pr.Printers.Names[pr.Printers.IndexOf(vNombrePrt)]);
  printer.PrinterIndex := pr.Printers.IndexOf(vNombrePrt);
  Reset(vfile);
  AssignPrn(Prn);//5Rewrite(Prn);
  try
    //5
    try
    while not Eof(vfile) do
      begin
       // ReadLn(vfile, text);
        writeln(Prn, text);
      end;
//    Writeln(Prn,#27+#109); //secuencia de corte
    finally
      CloseFile(Prn);
    end;
    except on EInOutError do MessageDlg('Error al imprimir la comanda', mtError, [mbOk], 0);
  end;
  CloseFile(vfile);
pr.Free;
end;

procedure TfrmPOS.btnHabitacionesClick(Sender: TObject);
begin
    Application.CreateForm(tFrmHabitaciones, FrmHabitaciones);
    FrmHabitaciones.Showmodal;
    FrmHabitaciones.release;

end;

procedure TfrmPOS.ADOBeforeConnect(Sender: TObject);
var
  ar : textfile;
  db : string;
begin

end;

procedure TfrmPOS.QFacturaAfterDelete(DataSet: TDataSet);
begin
QFactura.UpdateBatch;
end;

procedure TfrmPOS.QFacturaAfterPost(DataSet: TDataSet);
begin
QFactura.UpdateBatch;
end;

procedure TfrmPOS.pnabrircaja;
var
  arch : textfile;
  codigo, cod, abrir, puerto : string;
  a : integer;
  lista : tstrings;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := DM.QEmpresaEmpresaID.Value;
  dm.Query1.Open;
  codigo := dm.Query1.FieldByName('codigo_abre_caja').AsString;
  puerto := dm.Query1.FieldByName('Puerto').AsString;

  if codigo = 'FISCAL' then

  else
    begin
      if codigo = 'TMU' then
      begin
        assignfile(arch,'caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(27)+chr(112)+chr(0)+chr(25)+chr(250));
        closefile(arch);
      end
      else if codigo = 'Termica' then
      begin
        assignfile(arch,'caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(27)+chr(112)+chr(0)+chr(50)+chr(250));
        writeln(arch,chr(27)+chr(7));
        closefile(arch);
      end
      else if codigo = 'Star' then
      begin
        assignfile(arch,'caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(28));
        closefile(arch);
      end;


      assignfile(arch,'caja.bat');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch,'type caja.txt > '+puerto);
      closefile(arch);

      winexec('caja.bat',0);
    end;
  edproducto.SetFocus;

end;

procedure TfrmPOS.QFormaBeforePost(DataSet: TDataSet);
begin
with dm.Query1 do begin
Close;
SQL.Clear;
SQL.Add('select isnull(max(detalleid),0)+1 detalleid');
SQL.Add('from RestBar_Factura_Forma_Pago');
SQL.Add('where CajeroID = '+QFormaCajeroID.Text+' and CajaID = '+QFormaCajaID.Text);
Open;
if IsEmpty then
QFormaDetalleID.Value := 1 else
QFormaDetalleID.Value := fieldbyname('detalleid').Value;
Close;
end;
end;

procedure TfrmPOS.CkCantidadClick(Sender: TObject);
begin
if CkCantidad.Checked then begin
//CurrencyEdit1.Visible := True;
if QDetalle.RecordCount > 0 then
//CurrencyEdit1.Value := QDetalleCantidad.Value;
//CurrencyEdit1.SetFocus;
Exit;
end
else
begin
//CurrencyEdit1.Visible := False;
end;
end;

procedure TfrmPOS.QFacturaNewRecord(DataSet: TDataSet);
begin
//CurrencyEdit1.Visible := False;
CkCantidad.Checked := False;
vl_mesa := 0;
QFacturaPropina.Value := 0;
ckPropina := False;
ckItbis   := ckConItbis.Checked; // DM.QParametrosRestBar_FactConItbis.value;//True;
ckNCF     := True;
QFacturaConItbis.Value := ckItbis;
QFacturaimprimeNCF.Value := True;
QFacturaNCF.Value := '';
QFacturaAbierta.Value := False;
QFacturaAbiertaPor.Value := '';
QFacturaCajeroID.Value := 0;
QFacturaemp_codigo.Value := frmMain.vp_cia;
QFacturasuc_codigo.Value := frmMain.vp_suc;
end;

procedure TfrmPOS.CurrencyEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
  Totaliza := True;
  if QDetalle.RecordCount > 0 then
  begin
    QProductos.Close;
    QProductos.Parameters.ParamByName('nom').Value := QDetalleNombre.Value;
    QProductos.Open;

    QDetalle.Edit;
   // QDetalleCantidad.Value := CurrencyEdit1.Value;
    QDetalle.Post;
    QDetalle.UpdateBatch;
    Totalizar;

    if QProductosActualizarExistencia.Value then
    begin
      //Actualizando Existencia
      dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QProductosProductoID.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
    end;
    CkCantidad.Checked := False;
   // CurrencyEdit1.Visible := False;

    if QDetalleCantidadIngredientes.Value > 0 then
    begin
      QIngredientes.DisableControls;
      QIngredientes.First;
      while not QIngredientes.Eof do
      begin
        if QIngredientesActualizarExistencia.Value then
        begin
          //Actualizando Existencia
          dm.Query1.Close;
                dm.Query1.SQL.Clear;
                dm.Query1.SQL.Add('update Productos set pro_existencia = pro_existencia - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro');
                dm.Query1.SQL.Add('update Existencias set exi_cantidad = exi_cantidad - :cant');
                dm.Query1.SQL.Add('where pro_codigo = :pro and alm_codigo = (select par_almacenventa from Parametros where emp_codigo = '+DM.QEmpresaEmpresaID.Text+')');
                dm.Query1.Parameters.ParamByName('pro').Value  := QIngredientesProductoIngrediente.Value;
                dm.Query1.Parameters.ParamByName('cant').Value := QIngredientesCantidad.Value * QDetalleCantidad.Value;
                dm.Query1.ExecSQL;
        end;

        QIngredientes.Next;
      end;
      QIngredientes.EnableControls;
    end;
  end;
end;
end;

procedure TfrmPOS.CkDividirCtaClick(Sender: TObject);
begin
if CkDividirCta.Checked = True then begin
  edtCliente.Clear;
  edtCliente.Visible := True;
  edtCliente.SetFocus;
end;

if not CkDividirCta.Checked = True then begin
  edtCliente.Clear;
  edtCliente.Visible := False;
  vl_mesa := 0;
  ckPropina := False;
end;

end;

procedure TfrmPOS.QFacturaBeforePost(DataSet: TDataSet);
begin
if vl_mesa > 0 then begin
QFacturaMesaID.Value := vl_mesa;
QFacturaConPropina.Value := True;
end
else
begin
vl_mesa := 0;
QFacturaMesaID.Value := vl_mesa;
QFacturaConPropina.Value := False;
end;


IF QFacturaItbis.Value > 0 THEN BEGIN
QFacturaConItbis.Value := True;
QFacturaimprimeNCF.Value := True;
end
ELSE
BEGIN
QFacturaConItbis.Value := False;
if not ckItbis then
QFacturaimprimeNCF.Value := False;
end;
end;


function TfrmPOS.GetComputerName: string;
var
    pcComputer: PChar;
    dwCSize: DWORD;
begin
    dwCSize := MAX_COMPUTERNAME_LENGTH + 1;
    GetMem(pcComputer, dwCSize);
    try
        if Windows.GetComputerName(pcComputer, dwCSize) then
            Result := pcComputer;
    finally
        FreeMem(pcComputer);
    end;

end;



procedure TfrmPOS.QDetalleTotalBeforeOpen(DataSet: TDataSet);
begin
{QDetalleTotal.Parameters.ParamByName('CajeroID').Value  := QFacturaCajeroID.Value;
QDetalleTotal.Parameters.ParamByName('CajaID').Value    := QFacturaCajaID.Value;
QDetalleTotal.Parameters.ParamByName('FacturaID').Value := QFacturaFacturaID.Value;
}
end;

procedure TfrmPOS.ImpComanda2(ID: integer; reimprimir: boolean);
var
 vMemo:TMemo;
 F,F2: TextFile;
 FileName,Tmp, vPath_printer:String;
 sTemp1,sTemp2:String;
 sIDComanda:Integer;
 x:byte;
 mesa:String;
  procedure CreaArchivoImpresion(aPuerto:String);
  begin
    AssignFile(F2,'.\ImpOrden_'+vl_impresoraN+'.bat');
    if not FileExists('.\ImpOrden_'+vl_impresoraN+'.bat') then
      rewrite(F2)
    else
      Append(F2);
      Writeln(F2, 'type '+FileName +'.txt > '+vl_impresora2);
      try
        Flush(F2);
      except
       ;
      end;
      CloseFile(F2);
    end;
begin
  //-[borra el archivo maestro .bat]
  if FileExists('.\ImpOrden_'+vl_impresoraN+'.bat') then
    DeleteFile('.\ImpOrden_'+vl_impresoraN+'.bat');

  sTemp1:='';  sTemp2:='';
  //-[Abre la tabla de comanda con el numero de factura que esta abierto.]
  sIDComanda:=0;
  With adoComandaC do begin //--[0]
    Close;
    Parameters.ParamByName('IDFactura').Value := ID;
    Open;
  end;

  if adoComandaC.IsEmpty then
    exit;

  sIDComanda:=adoComandaC['ComandaID'];

  mesa:='';

  if dm.adoMultiUso.State <> dsinactive then {Esta validacion es para evitar errores de programacion - fernando 20170628}
     begin
       MessageDlg('ERROR - [900] Contacte a Soporte Tecnico del DASHA',mtError,[mbok],0);
       Exit;
     end
  else
  With dm.adoMultiUso do begin
    Close;
    Sql.Clear;
    sql.Add('select nombre from mesas Where mesaid = '+IntToStr(adoComandaCMesaID.value));
    open;
    if not IsEmpty then
      mesa:=dm.adoMultiUso['nombre']
    else
      mesa:='DIRECTA';
    Close;
  end;

  if dm.adoMultiUso.State <> dsinactive then {Esta validacion es para evitar errores de programacion - fernando 20170628}
     begin
       MessageDlg('ERROR - [900] Contacte a Soporte Tecnico del DASHA',mtError,[mbok],0);
       Exit;
     end
  else

   vPath_printer := vl_impresoraN;
      FileName := '.\ORDEN_'+IntToStr(ID)+'_PRINTER_'+vl_impresoraN;
      if FileExists('.\'+FileName+'.txt') then
      DeleteFile(('.\'+FileName+'.txt'));

      //-[abre tabla con el detalle.]
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('SELECT b.ComandaID, b.Secuencia,b.ProductoID,');
      dm.Query1.SQL.Add('b.cantidad,b.descripcion,b.Impreso From  ComandaD b ');
      dm.Query1.SQL.Add('Where b.ComandaID = '+IntToStr(adoComandaC['ComandaID']));
      dm.Query1.SQL.Add('and b.IDPrinter = 0');
      if not reimprimir then
        dm.Query1.SQL.Add('and b.Impreso = 0') else
        dm.Query1.SQL.Add('and b.Impreso = 1');

      dm.Query1.Open;

      if not dm.Query1.IsEmpty then //-[Si no encuentra registro para imprimir entonces se sale]
        begin  //--[0.1.1]
          //--[Lee la tabla con la informacion de la comanda hasta el final y la envia al architov txt]
          dm.Query1.First;
          AssignFile(F, FileName+'.txt');
          Rewrite(F);
          Writeln(F,dm.SetCentralizar('*** COMANDA ***'));
          Writeln(F,' ');
          Writeln(F,' ');
          Writeln(F,' ');
          sTemp1:='';
          sTemp2:='';
                           //dm.PAD('0','L',2,IntToStr(Diav))
         /// sTemp1:= 'MOZO NO. : '+dm.PAD(' ','R',5,IntToStr(adoComandaC['camareroID']));
          sTemp2:= 'MESA : '+dm.PAD(' ','L',5,mesa);
          Writeln(F,sTemp1+sTemp2);
          Writeln(F,' ');
          sTemp1:= 'FECHA : '+dm.PAD(' ','R',10,FormatDateTime('dd/mm/yyyy',adoComandaC['Fecha']));
          sTemp2:= '  HORA : '+dm.PAD(' ','R',8,FormatDateTime('hh:mm:ss AM/PM',adoComandaC['hora']));
          Writeln(F,sTemp1+sTemp2);
          Writeln(F,' ');
          Writeln(F,'UNIDAD  DESCRIPCION');
          Writeln(F,'----------------------------------------');

          While not dm.Query1.Eof do begin
            sTemp1:= '';
            sTemp1:= dm.PAD(' ','L',6,formatFloat(',,,0.00',dm.Query1['cantidad']));
            Writeln(F, sTemp1+' '+dm.Query1['descripcion']);
            dm.Query1.Edit;
            dm.Query1['impreso']:=true;

            dm.Query1.Post;
            dm.Query1.UpdateBatch;
            dm.Query1.next;
          end;
          Writeln(F,'----------------------------------------');
          if  reimprimir then
            Writeln(F,'Impreso por : '+lbUsuario.Caption+CRLF+
                      'Fecha :'+FormatDateTime('dd/mm/yyyy hh:mm:ss am/pm',now));

          for x:=1 to 5 do
            Writeln(F,'.');

          //Abre Caja
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
          dm.Query1.SQL.Add('where caja = :caj');
          dm.Query1.Parameters.ParamByName('caj').Value := DM.QEmpresaEmpresaID.Value;
          dm.Query1.Open;
          if dm.Query1.FieldByName('codigo_abre_caja').AsString = 'Termica' then
          writeln(F,chr(27)+chr(109));




          CloseFile(F);
//          impArchivoTxt(F,vPath_printer);
          //--[Crea archivo con orden de impresion]

          CreaArchivoImpresion(vl_impresora2);
          winexec(pchar('.\ImpOrden_'+vl_impresoraN+'.bat'),0);
        end;//--[0.1.1]

      Next
    end; //--[0.1]

var
  err: integer;



function TfrmPOS.ImprimeTicketFiscal():boolean;
begin
  {puedeAbrirCaja :=false;
  //Verifica a ver si tiene pago efetivo
  QFormaPago.DisableControls;
  QFormaPago.First;
  while not QFormaPago.Eof do
  begin
    if QFormaPagoforma.AsString = 'EFE' then
      puedeAbrirCaja :=true;
    QFormaPago.Next;
  end;
  QFormaPago.EnableControls;

 // if puedeAbrirCaja then
 //   OpenCashDrawerFiscal(ImpresoraFiscal);

 // Sleep(1000);
    //Envia la factura a la impresora
   }

  result := false;

  case ImpresoraFiscal.IDPrinter of
    1 : {EPSON (TMU-220)} result := ImpTicketFiscalEpson(ImpresoraFiscal);
    2 : {CITIZEN ( CT-S310 )}  result := ImpTicketVmaxFiscal(ImpresoraFiscal);
    3 : {CITIZEN (GSX-190)}    result := ImpTicketVmaxFiscal(ImpresoraFiscal);
    4 : {STAR (TSP650FP)}      result := ImpTicketVmaxFiscal(ImpresoraFiscal);
    5 : {Bixolon SRP-350iiHG}  result := ImpTicketFiscalBixolon(ImpresoraFiscal);
  end;
end;


function TfrmPOS.ImpTicketFiscalEpson(ImpFiscal:TImpresora):boolean;
var
   copias, a: integer;
  arch : textfile;
  puerto : string;
  DriverFiscal1 : TDriverFiscal;
  dgeneral, rgeneral : boolean;
  sMontoFaltante, sMontoDevuelta:String;
  vMontoFaltante, MontoItbis:Double;
  sMontoaPagar,sPropina:Double;
begin
  sPropina:=0;
  vMontoFaltante:=0;
  sMontoFaltante:=''; sMontoDevuelta:='';
  result :=false;
  copias := 0;
  if MessageDlg('Desea una copia de la factura?', mtConfirmation, [mbyes, mbno], 0) = mryes then
    copias := 1;

  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';
  try
    AssignFile(arch, 'puerto.ini');
    System.reset(arch);
    readln(arch, puerto);
    closefile(arch);

    err := DriverFiscal1.IF_OPEN(puerto, 9600);

    if (err < 0 ) then
      begin
        Application.MessageBox(pchar('Error : No hay comunicacion con el printer'+#13+#10+
                                     'Impresion cancelada'),'Aviso',
                                     MB_OK+MB_ICONSTOP);
        exit;
      end;



    if err <> 0 then
    begin
      err:=DriverFiscal1.IF_ERROR2(12);
      if  ( err > 0) then begin
        Application.MessageBox(pchar('Se requiere un cierre Z'+#13+#10+
                                     'Impresion cancelada'),'Aviso',
                                     MB_OK+MB_ICONSTOP);
        exit;
      end;
    end;

     if QForma.RecordCount > 0 then
    begin //--[001]--
      if QFacturaTipoNCF.Value = 1 then //consumidor final
        err := DriverFiscal1.IF_WRITE('@TicketOpen|A|0001|'+FormatFloat('000', QFacturaCajaID.Value)+'|'+QFacturaNCF.AsString+
                                      '||||P|'+inttostr(copias))
      else
        if QFacturaTipoNCF.Value = 2 then //con Valor Fiscal
          err := DriverFiscal1.IF_WRITE('@TicketOpen|B|0001|'+FormatFloat('000', QFacturaCajaID.Value)+'|'+
                 QFacturaNCF.AsString+'|'+QFacturaNombre.AsString+'|'+QFacturarnc.AsString+'||P|'+inttostr(copias))
        else
          if QFacturaTipoNCF.Value = 3 then //Gubernamental
            err := DriverFiscal1.IF_WRITE('@TicketOpen|B|0001|'+FormatFloat('000', QFacturaCajaID.Value)+'|'+
                   QFacturaNCF.AsString+'|'+QFacturaNombre.AsString+'|'+QFacturarnc.AsString+'||P|'+inttostr(copias))
          else
            if QFacturaTipoNCF.Value = 4 then //Regimen Especial
              err := DriverFiscal1.IF_WRITE('@TicketOpen|F|0001|'+FormatFloat('000', QFacturaCajaID.Value)+'|'+
                     QFacturaNCF.AsString+'|'+QFacturaNombre.AsString+'|'+QFacturarnc.AsString+'||P|'+inttostr(copias));
    end; //--[001]--

    //Verificando Descuento y Recargdo General
    dgeneral := true;
    rgeneral := true;

    QDetalle.DisableControls;
    QDetalle.First;
    while not QDetalle.eof do
    begin
      if QDetalleDescuento.Value = 0 then dgeneral := false;
      if QDetalleRecargo.Value = 0 then rgeneral := false;
      QDetalle.next;
    end;

    QDetalle.First;
    While not QDetalle.eof do
    begin  //--[002]--
     dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select isnull(pro_montoitbis,0) as pro_montoitbis from productos where emp_codigo = 1 and pro_codigo = :pro');
          dm.Query1.Parameters.ParamByName('pro').Value := QDetalleProductoID.Value;
          dm.Query1.Open;
          MontoItbis := dm.Query1.FieldByName('pro_montoitbis').AsFloat;

    err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalleNombre.value),1,22)+'|'+
                                     QDetalleCantidad.AsString+'|'+
                                     floattostr(QDetallePrecio.value)+'|'+
                                     FloatToStr(MontoItbis));
      if QDetalledescuento.Value > 0 then
      begin
        if not dgeneral then
        begin
          err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalleNombre.value),1,22)+'|'+
                                         QDetallecantidad.AsString+'|'+
                                         floattostr(QDetalleTotalDescuento.Value)+'|'+
                                         FloatToStr(MontoItbis)+'|D');
        end;
      end;

      if QDetallerecargo.Value > 0 then
      begin
        if not rgeneral then
        begin
          err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalleNombre.value),1,22)+'|'+
                                         QDetallecantidad.AsString+'|'+
                                         floattostr(QDetallerecargo.Value)+'|'+
                                         FloatToStr(MontoItbis)+'|d');
        end;
      end;
      QDetalle.next;
    end; //--[002]--
    QDetalle.First;
    QDetalle.EnableControls;

    err := DriverFiscal1.IF_WRITE('@TicketSubtotal|P');

    if QFacturaDescuento.AsFloat > 0 then
    begin
      if dgeneral then
        err := DriverFiscal1.IF_WRITE('@TicketReturnRecharge|Descuento|'+
                                       floattostr(QFacturaDescuento.AsFloat)+'|D');
    end;

    sPropina :=0;
    if QFacturaPropina.AsFloat > 0 then
      begin //--[00*1]
        err := DriverFiscal1.IF_WRITE('@TicketTip|'+floattostr(QFacturaPropina.AsFloat));

        //Si la impresora no esta en modo factfood entonces agrega el monto del cargo de manera manual
        if err <> 0 then
          begin
            sPropina := QFacturaPropina.Value;
            err := DriverFiscal1.IF_WRITE('@TicketReturnRecharge|% LEY|'+floattostr(QFacturaPropina.AsFloat)+'|R');
          end;
      end; //--[00*1]

    if QFacturaRecargo.AsFloat > 0 then
    begin
      if rgeneral then
        err := DriverFiscal1.IF_WRITE('@TicketReturnRecharge|Recargo|'+floattostr(QFacturaRecargo.AsFloat)+'|R');
    end;

    v_TotalPagado:=0;
    sMontoaPagar:=0;
    QForma.DisableControls;
    QForma.First;
    While not QForma.Eof do
    begin
      sMontoaPagar:= QFormaMonto.Value;
      v_TotalPagado:= v_TotalPagado + QFormaMonto.Value;
                       {1-Efectivo
                        2-Cheque
                        3-Tarjeta Credito
                        4-Tarjeta Debito
                        5-Tarjeta propia
                        6-Cupon
                        7-Otros 1
                        8-Otros 2
                        9-Otros 3
                        10-Otros 4
                        11-Nota de Creditos
                        12-Exoneracion ITBIS
                        13-Comprobantes Cancelados
                       }
      if QFormaForma.AsString = 'Efectivo' then
        err := DriverFiscal1.IF_WRITE('@TicketPayment|1|'+floattostr(sMontoaPagar))
      else
        if QFormaForma.AsString = 'Cheque' then
          err := DriverFiscal1.IF_WRITE('@TicketPayment|2|'+floattostr(sMontoaPagar))
        else
          if QFormaForma.AsString = 'Tarjeta' then
            err := DriverFiscal1.IF_WRITE('@TicketPayment|3|'+floattostr(sMontoaPagar))
          else
            if QFormaForma.AsString = 'Bono' then
              err := DriverFiscal1.IF_WRITE('@TicketPayment|6|'+floattostr(sMontoaPagar))
            else
              if QFormaForma.AsString = 'Credito' then
                err := DriverFiscal1.IF_WRITE('@TicketPayment|7|'+floattostr(QFacturaTotal.AsFloat))
              else
                if QFormaForma.AsString = 'Nota CR' then
                  err := DriverFiscal1.IF_WRITE('@TicketPayment|11|'+floattostr(sMontoaPagar));
       sMontoaPagar:=0;
      QForma.Next;
    end;
    QForma.EnableControls;


  //    01  Monto restante por pagar
  //    02  Monto del vuelto

    MontoDevuelta:=0;
    sMontoFaltante :=DriverFiscal1.IF_READ(1) ;
    sMontoDevuelta :=DriverFiscal1.IF_READ(2) ;

    if sMontoFaltante <> '' then
      vMontoFaltante:= (StrToFloat(sMontoFaltante)* 0.01);

    if vMontoFaltante > 0 then
      err := DriverFiscal1.IF_WRITE('@TicketPayment|8|'+FloatToStr(vMontoFaltante));

    err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Cajero: '+lbUsuario.Caption);
    err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Caja  : '+QFacturaCajaID.AsString);
    err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Factura #: '+QFacturaFacturaID.AsString);

    if QFormaForma.AsString = 'Credito' then
      begin
        err := DriverFiscal1.IF_WRITE('@TicketFiscalText|FACTURA A CREDITO A NOMBRE DE');
        err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+QFacturaNombre.AsString);
      end
    else
      if ((QFacturaTipoNCF.Value = 1) and (trim(razon_social) <> '')) then
        err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Nombre   : '+QFacturaNombre.AsString);

    err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+' ');

    for a := 1 to 34 do
    begin
      if length(trim(dm.QEmpresa.FieldByName('Mensaje'+inttostr(a)).AsString)) > 0 then
        err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+copy(dm.QEmpresa.FieldByName('Mensaje'+inttostr(a)).AsString,1,40));
    end;

    err := DriverFiscal1.IF_WRITE('@TicketClose');
    err := DriverFiscal1.IF_WRITE('@PaperFeed|1');
    err := DriverFiscal1.IF_WRITE('@PaperCut|P');
    err := DriverFiscal1.IF_WRITE('@OpenDrawer|1');
    err := DriverFiscal1.IF_CLOSE;

    try
      MontoDevuelta:= (StrToFloat(sMontoDevuelta)* 0.01);
    except
      MontoDevuelta:=0;
    end;

    result :=true;
  finally
    DriverFiscal1.Destroy;
  end;
end;

var
    sPrecio,sDescuento:double;

function TfrmPOS.ImpTicketVMAXFiscal(ImpFiscal:TImpresora):boolean;
var
  pro_codigo, Unidad,Und_Medida_Real : string;
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, trecargo : Double;
  Puntos, a : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
   copias, ln: integer;
 // err, copias, ln: integer;
 tipoNcf:integer;
  DriverFiscal1 : TvmaxFiscal;
  x:byte;
  dgeneral, rgeneral : boolean;
  porcItbis:double;
  v_diferencia:Double;
  sAjuste,v_TotalPagado :double;

begin
  result :=false;
  v_diferencia:=0;
  v_TotalPagado:=0;

  tipoNcf:=0;
  ItbisIncluido :=dm.QEmpresaPrecioIncluyeItbis.value = 'S'; //  dm.QParametrospar_itbisincluido.Value = 'True';
  sDescuento:=0;
  Copias :=ImpFiscal.Copia;

  if not Assigned(DriverFiscal1) then
    DriverFiscal1 := TvmaxFiscal.Create();

  try
    err := DriverFiscal1.OpenPort(ImpFiscal.Puerto, ImpFiscal.Velocidad );
    if (err <> SUCCESS ) then
      begin
        ShowMessage('Error : No hay comunicacion con el printer'+#13+#10+
        'Impresion cancelada');
        exit;
      end
    else
    begin //--[0]--
          //DriverFiscal1.AbrirCajonDinero();
      //aqui debes de pedir status

     case QFacturaTipoNCF.Value of
          //consumidor final
        1:  err := DriverFiscal1.AbrirCF(copias,0, 0, '0001', QFacturaCajaID.AsString, QFacturaNCF.AsString, '', '', '');
            //con Valor Fiscal
        2:  err := DriverFiscal1.AbrirCF(copias,1, 0, '0001', QFacturaCajaID.AsString, QFacturaNCF.AsString, Trim(Copy(QFacturaNombre.AsString,1,40)), QFacturarnc.AsString, '');
            //Gubernamental
        3:  err := DriverFiscal1.AbrirCF(copias,100, 0, '0001', QFacturaCajaID.AsString, QFacturaNCF.AsString, Trim(Copy(QFacturaNombre.AsString,1,40)), QFacturarnc.AsString, '');
            //Regimen Especial
        4:  err := DriverFiscal1.AbrirCF(copias,101, 0, '0001', QFacturaCajaID.AsString, QFacturaNCF.AsString, Trim(Copy(QFacturaNombre.AsString,1,40)), QFacturarnc.AsString, '');
      end; //fin case

      If err = SUCCESS Then
      begin //--[1]--
        sPrecio  :=0;
        trecargo :=0;

        //Verificando Descuento y Recargdo General
        dgeneral := true;
        rgeneral := true;

        QDetalle.DisableControls;
        QDetalle.First;
        while not QDetalle.eof do
        begin
          if QDetalleDescuento.Value = 0 then dgeneral := false;
          if QDetalleRecargo.Value = 0 then rgeneral := false;

          QDetalle.next;
        end;

        QDetalle.First;
        while not QDetalle.eof do begin
          porcItbis :=0;
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select case when pro_itbis = '+QuotedStr('S')+' then 1 else 0 end itbis from productos where pro_codigo = :pro');
          dm.Query1.Parameters.ParamByName('pro').Value := QDetalleProductoID.Value;
          dm.Query1.Open;
          if not dm.Query1.IsEmpty then
            if (dm.Query1.FieldByName('Itbis').Value = True ) then
              porcItbis := dm.QEmpresaItbis.value;
          dm.Query1.close;

          sPrecio := QDetallePrecio.value;
          sDescuento := QDetalleTotalDescuento.Value;

          if porcItbis > 0 then
          begin //*0*
            if (ItbisIncluido = true) then
              begin    ///[0]

                if (ImpresoraFiscal.Precioconitbis = 'N') then
                  begin
                  //saca el itbis del precio y del descuento
                   sPrecio := (QDetallePRECIO.value -
                                QDetalledescuento.Value) /
                                        (1+(porcItbis/100));

                   sDescuento := (QDetalleTotalDescuento.Value /
                                       (1+ (porcItbis/100)) );
                  end
                else
                  begin
                    {sPrecio := RFactura.QDetalleDET_PRECIO.value  /
                         //               (1+(RFactura.QDetalleDET_ITBIS.Value/100));

                    //sPrecio := ((sPrecio - RFactura.QDetalleTotalDescuento.Value) *
                                 (1+ (RFactura.QDetalleDET_ITBIS.Value/100))) ; }
                  /// if  (QDetalleTotalDescuento.Value > 0) then
                  /// sDescuento := (QDetalleTotalDescuento.Value *
                  //                     (1+ (porcItbis/100)) );

                  end;
              end ///[0]//fin Itbis Incluidos
            else //itbis no incluido
              begin
                //Agrega el itbis al precio si la impresora lo requiere
                if ((ImpresoraFiscal.Precioconitbis = 'S') and (ItbisIncluido = false)) then
                  begin
                    sPrecio := (QDetallePRECIO.value *
                                (1+(porcItbis/100)));
                   //El Descuento tiene que sumarle el itbis, cuando la impresora lo requiera
                   sDescuento := (QDetalleTotalDescuento.Value *
                                       (1+ (porcItbis/100)) );
                  end;
              end ;
          end; // *0*
       /// **************************
       err := DriverFiscal1.ItemCF(0, '','','','','','','',pro_codigo,Unidad,
                                   copy(trim(QDetalleNombre.value),1,35),
                                   QDetallecantidad.value,
                                   sPrecio,
                                   porcItbis);

          //--[Imprime Descuentos]--
          if ( sDescuento > 0 )  then
          begin
            err := DriverFiscal1.ItemCF(2, '','','','','','','','','',
                                      FormatFloat(',,,0.00',QDetalledescuento.value)+'% DESC. ITEMS ',
                                      QDetallecantidad.value,
                                      sDescuento,
                                      porcItbis);

          end;
          //--[No hay recargo por Items]--

          trecargo := trecargo + QDetallerecargo.AsFloat;

          QDetalle.next;
        end;
        QDetalle.First;
        QDetalle.EnableControls;
      end;  //--[1]--

      //--[Aplica descuento general]--
     // if ((QTicketporc_desc_gral.AsFloat > 0)) then
     //   err := DriverFiscal1.DescRecGlobal(0,'Descuento',QTicketTdesc_gral.Value);

     //aPLICA PROPINA
     //  OJO poner
     // if QFacturaPropina.AsFloat > 0 then
     //    err := DriverFiscal1.IF_WRITE('@TicketTip|'+floattostr(QFacturaPropina.AsFloat));


      //--[Aplica cargos general]--
      if ((trecargo > 0) ) then
        err := DriverFiscal1.DescRecGlobal(1,'Recargo',trecargo);

      err := DriverFiscal1.getSubtotalCF();


      QForma.DisableControls;
      QForma.First;
      while not QForma.Eof do
      begin
        v_TotalPagado := v_TotalPagado + QFormaMonto.Value;
        if QFormaForma.AsString = 'Tarjeta' then
          err := DriverFiscal1.PagoCF(0, 3,QFormaMonto.Value)
        else
          if QFormaForma.AsString = 'Cheque' then
            err := DriverFiscal1.PagoCF(0, 2, QFormaMonto.Value)
          else
            if QFormaForma.AsString = 'Nota CR' then
              begin
                err := DriverFiscal1.PagoCF(0, 10, QFormaMonto.Value);
                // err := DriverFiscal1.IF_WRITE('@TicketPayment|11|'+floattostr(QFormaPagopagado.AsFloat));
              end
            else if QFormaForma.AsString = 'Credito' then
        begin
          err := DriverFiscal1.PagoCF(0, 5,QFormaMonto.Value);
          //err := DriverFiscal1.IF_WRITE('@TicketPayment|7|'+floattostr(QFormaPagopagado.AsFloat));
        end
        else if QFormaForma.AsString = 'Bono' then
        begin
           err := DriverFiscal1.PagoCF(0, 7,QFormaMonto.Value );
          //err := DriverFiscal1.IF_WRITE('@TicketPayment|6|'+floattostr(QFormaPagopagado.AsFloat));
        end
        else if QFormaForma.AsString = 'OBO' then
        begin
          err := DriverFiscal1.PagoCF(0, 8, QFormaMonto.Value);
         // err := DriverFiscal1.IF_WRITE('@TicketPayment|8|'+floattostr(QFormaPagopagado.AsFloat));
        end
        else if QFormaForma.AsString = 'Efectivo' then
        begin
         // err := DriverFiscal1.IF_WRITE('@TicketPayment|1|'+floattostr(QFormaPagopagado.Value));
          err := DriverFiscal1.PagoCF(0, 1,QFormaMonto.Value)
        end;

        QForma.Next;
      end;
      QForma.EnableControls;

                //Ajusta el pago
      if ( DriverFiscal1.SubTotal > v_TotalPagado ) then
        begin
          sAjuste := (DriverFiscal1.SubTotal - v_TotalPagado);
            if (sAjuste > 0)  then
              err := DriverFiscal1.PagoCF(0, 8,sAjuste,' ' );
        end;



  if QFormaForma.AsString = 'Credito' then
  begin
      err := DriverFiscal1.LineaComentario('');
      err := DriverFiscal1.LineaComentario('Cajero : '+lbUsuario.Caption);
      err := DriverFiscal1.LineaComentario('Caja   : '+QFacturaCajaID.AsString);
      err := DriverFiscal1.LineaComentario('Ticket : '+QFacturaFacturaID.AsString);
      err := DriverFiscal1.LineaComentario('FACTURA A CREDITO A NOMBRE DE');
      if (QFacturaTipoNCF.Value = 1) and (trim(QFacturanombre.AsString) <> '') then
        err := DriverFiscal1.LineaComentario('Nombre : '+copy(trim(QFacturaNombre.AsString),1,40));

  end
  else
  begin
      err := DriverFiscal1.LineaComentario('Cajero : '+lbUsuario.Caption);
      err := DriverFiscal1.LineaComentario('Caja   : '+QFacturaCajaID.AsString);
      err := DriverFiscal1.LineaComentario('Ticket : '+QFacturaFacturaID.AsString);

    if QFacturaTipoNCF.Value = 1 then
    begin
      if trim(razon_social) <> '' then
      begin
        err := DriverFiscal1.LineaComentario('@TicketFiscalText|Nombre   : '+QFacturaNombre.AsString);
      end;
    end;
  end;

  for a := 1 to 34 do
  begin
    if length(trim(dm.QEmpresa.FieldByName('Mensaje'+inttostr(a)).AsString)) > 0 then
      err := DriverFiscal1.LineaComentario(copy(dm.QEmpresa.FieldByName('Mensaje'+inttostr(a)).AsString,1,40));
  end;

      DriverFiscal1.CerrarCF();
      result :=true;
    end; //--[0]--
  finally
    DriverFiscal1.ClosePort();
    DriverFiscal1.Destroy;
    Application.ProcessMessages();
  end;

end;




function TfrmPOS.ImprimeCtaTicketNoFiscalEpson(ImpFiscal:TImpresora):boolean;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos, a, ln, pg, cantpg : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis : String;
  err: integer;
  puerto : string;
  DriverFiscal1 : TDriverFiscal;
begin
  result :=false;

  AssignFile(arch, 'puerto.ini');
  System.reset(arch);
  readln(arch, puerto);
  closefile(arch);

  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';
  try
  err := DriverFiscal1.IF_OPEN(puerto, 9600);
  err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');

  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaNombre.Value));

  memo1.Lines.Clear;
  memo1.Lines.Add(dm.QEmpresaDireccion.Value);
  for a := 0 to memo1.Lines.Count-1 do
  begin
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(memo1.lines[a]));
  end;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaTelefono.Value));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('RNC:'+dm.QEmpresaRNC.Value));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(titulo_cuenta));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');

  dm.Query1.close;
  dm.Query1.SQL.clear;
  dm.Query1.SQL.add('select Nombre from usuarios');
  dm.Query1.SQL.add('where UsuarioID = :usu');
  dm.Query1.Parameters.parambyname('usu').Value := frmMain.Usuario;
  dm.Query1.open;

  pg := 1;
  cantpg := QDetalle.RecordCount;

  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Fecha .: '+DateToStr(QFacturaFecha.Value)+' Factura: '+formatfloat('0000000000',QFacturaFacturaID.value));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(QFacturaHora.AsDateTime));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring);

  {if cantpg > 30 then
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Pagina : '+inttostr(pg)+' de '+inttostr(Round(cantpg/30)));}

  if not QFacturamesaid.IsNull then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    dm.Query1.SQL.Add('from Mesas m, Areas a');
    dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
    dm.Query1.SQL.Add('and m.mesaid = :cod');
    dm.Query1.SQL.Add('order by m.MesaID');
    dm.Query1.Parameters.ParamByName('cod').Value := QFacturamesaid.Value;
    dm.Query1.Open;

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
  end;

  if QFacturaNombre.Value <> '' then
  begin
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Cliente: '+QFacturaNombre.Value);
    if Trim(QFacturarnc.Value) <> '' then
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'RNC ...: '+QFacturarnc.Value);
  end;

  if QFacturaNCF.Value <> '' then
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'NCF    : '+QFacturaNCF.Value);

  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '----------------------------------------');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'CANT.       DESCRIPCION            TOTAL');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '----------------------------------------');
  TFac := 0;
  MontoItbis := 0;
  QDetalle.DisableControls;
  QDetalle.First;
  ln := 1;
  while not QDetalle.eof do
  begin
    if ln > 84 then
    begin
      //Si es una nueva página
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '* CONTINUA EN LA OTRA PAGINA *');
      ln := 1;
      err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|N');
      err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');
      pg := pg + 1;

      {memo1.Lines.Clear;
      memo1.Lines.Add(dm.QEmpresaDireccion.Value);
      for a := 0 to memo1.Lines.Count-1 do
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(memo1.lines[a]));
      end;
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaTelefono.Value));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('RNC:'+dm.QEmpresaRNC.Value));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('*** PRE-CUENTA ***'));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');

      dm.Query1.close;
      dm.Query1.SQL.clear;
      dm.Query1.SQL.add('select Nombre from usuarios');
      dm.Query1.SQL.add('where UsuarioID = :usu');
      dm.Query1.Parameters.parambyname('usu').Value := frmMain.Usuario;
      dm.Query1.open;

      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Fecha .: '+DateToStr(QFacturaFecha.Value)+' Factura: '+formatfloat('0000000000',QFacturaFacturaID.value));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(QFacturaHora.AsDateTime));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring);
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Pagina : '+inttostr(pg)+' de '+inttostr(Round(cantpg/30)));

      if not QFacturamesaid.IsNull then
      begin
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
        dm.Query1.SQL.Add('from Mesas m, Areas a');
        dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
        dm.Query1.SQL.Add('and m.mesaid = :cod');
        dm.Query1.SQL.Add('order by m.MesaID');
        dm.Query1.Parameters.ParamByName('cod').Value := QFacturamesaid.Value;
        dm.Query1.Open;

        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
      end;

      if QFacturaNombre.Value <> '' then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Cliente: '+QFacturaNombre.Value);
        if Trim(QFacturarnc.Value) <> '' then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'RNC ...: '+QFacturarnc.Value);
      end;

      if QFacturaNCF.Value <> '' then
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'NCF    : '+QFacturaNCF.Value);

      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '----------------------------------------');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'CANT.       DESCRIPCION            TOTAL');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '----------------------------------------');}
    end;
    s := '';
    FillChar(s, 5-length(format('%n',[QDetalleCantidad.value])),' ');
    s1 := '';
    FillChar(s1, 10-length(trim(FORMAT('%n',[QDetalleValor.value]))), ' ');
    s2 := '';
    FillChar(s2, 22-length(copy(trim(QDetalleNombre.value),1,22)),' ');
    s3 := '';
    FillChar(s3, 8-length(trim(FORMAT('%n',[QDetallePrecio.value]))),' ');
    s4 := '';
    FillChar(s4, 8-length(trim(FORMAT('%n',[QDetallePrecio.value * QDetalleCantidad.Value]))),' ');

    if QDetalleItbis.value = True then
      lbitbis := 'G'
    else
      lbitbis := 'E';

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ s+format('%n',[QDetalleCantidad.value])+' '+
                  lbitbis+' '+copy(trim(QDetalleNombre.value),1,22)+s2+s1+format('%n',[QDetalleValor.value]));

    TFac := TFac + QDetalleValor.value;
    ln := ln + 1;
    QDetalle.next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '                       -----------------');
  tCambio := Devuelta;

  s := '';
  FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
  s1:= '';
  FillChar(s1, 10-length(trim(FORMAT('%n',[MPagado]))), ' ');
  s2:= '';
  FillChar(s2, 10-length(trim(FORMAT('%n',[tCambio]))), ' ');
  s3:= '';
  FillChar(s3, 10-length(trim(FORMAT('%n',[QFacturaItbis.Value]))), ' ');
  s4:= '';
  FillChar(s4, 10-length(trim(FORMAT('%n',[QFacturaTotal.Value]))), ' ');
  s5:= '';
  FillChar(s5, 10-length(trim(FORMAT('%n',[QFacturaPropina.Value]))), ' ');
  s7:= '';
  FillChar(s7, 10-length(trim(FORMAT('%n',[TFac]))), ' ');
  s8:= '';
  FillChar(s8, 10-length(trim(FORMAT('%n',[QFacturaDescuento.Value]))), ' ');

  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    SubTotal: '+s7+format('%n',[TFac]));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                   Descuento: '+s8+format('%n',[QFacturaDescuento.Value]));
  if QForma.RecordCount > 0 then
  begin
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Recibido: '+s1+format('%n',[MPagado]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Cambio  : '+s2+format('%n',[tCambio]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Itbis   : '+s3+format('%n',[QFacturaItbis.Value]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    10% Ley : '+s5+format('%n',[QFacturaPropina.Value]));

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Dólares : '+s6+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Euros   : '+s7+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]));
    end;

    if QFacturaCredito.Value = True then
    begin
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '--------------------------');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Firma del Cliente');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '--------------------------');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Firma del Supervisor');
    end;
  end
  else
  begin
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Itbis   : '+s3+format('%n',[QFacturaItbis.Value]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    10% Ley : '+s5+format('%n',[QFacturaPropina.Value]));

    s7:= '';
    FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value)]))), ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Total   : '+s7+format('%n',[(QFacturaTotal.Value)]));

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Dólares : '+s6+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                    Euros   : '+s7+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]));
    end;
  end;

  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.centro(dm.QEmpresaMensaje1.AsString));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.centro(dm.QEmpresaMensaje2.AsString));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.centro(dm.QEmpresaMensaje3.AsString));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.centro(dm.QEmpresaMensaje4.AsString));


  err := DriverFiscal1.IF_WRITE('@PaperCut|P');
  err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|C');
  err := DriverFiscal1.IF_CLOSE;
  result := true;
  finally
    DriverFiscal1.Destroy;
  end;
end;

function TfrmPOS.ImpTicketFiscalBixolon(ImpFiscal: TImpresora): boolean;
Var arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, trecargo : Double;
  Puntos : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
  pro_codigo:String;
  v_TotalImp :Double;
  v_TotalPagado:Double;
  copias, ln: integer;

  dgeneral, rgeneral : boolean;

  Stat, Err, X: Integer;
  Credito : Boolean;
  //-----------------------

  sAjuste:Double;
  sMontoPagado : Double;
  sPorcDescGral:Double;
  sStringTmp:String;
  sPrecio:double;
  vord:byte;
  Unidad:string;
  sDescuento:Double;
  DescRecGlobal :Double;
  porcItbis:double;
  a : Word;
  StrTmp:String;
begin
  result :=false;


  if not getPrinterFiscalBixolonStatus() then
    begin
      ShowMessage('Impresora NO conectada');
      exit;
    end;

  try

    Copias := ImpresoraFiscal.Copia;
    v_TotalPagado:=0;
    ItbisIncluido :=dm.QEmpresaPrecioIncluyeItbis.value = 'S'; //  dm.QParametrospar_itbisincluido.Value = 'True';
    Credito := False;
    StrTmp := trim(QFacturaNCF.Value);


    dm.Query1.close;
    dm.Query1.SQL.clear;
    dm.Query1.SQL.add('select Nombre from usuarios');
    dm.Query1.SQL.add('where UsuarioID = :usu');
    dm.Query1.Parameters.parambyname('usu').Value := frmMain.Usuario;
    dm.Query1.open;

   //pg := 1;
    //cantpg := QDetalle.RecordCount;

    //apertura
    case QFacturaTipoNCF.Value of
      1:SendCmd(Stat, Err, PChar('/0'));    //Factura Para Consumidor Final
      2:SendCmd(Stat, Err, PChar('/1'));     //Factura Para Crédito Fiscal
      3:SendCmd(Stat, Err, PChar('/1'));     ////Gubernamental
      4:SendCmd(Stat, Err, PChar('/4'));    ////Regimen Especial (Factura Para Crédito Fiscal con Exoneración ITBIS)
    end;

    SendCmd(Stat, Err,PCHAR('80¡ '+titulo_cuenta));
    SendCmd(Stat, Err,PCHAR('80 '+'Fecha .: '+DateToStr(QFacturaFecha.Value)+' Cuenta: '+formatfloat('0000000000',QFacturaFacturaID.value)));
    SendCmd(Stat, Err,PCHAR('80 '+'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(QFacturaHora.AsDateTime)));
    SendCmd(Stat, Err,PCHAR('80 '+'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring));

    {if cantpg > 30 then
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Pagina : '+inttostr(pg)+' de '+inttostr(Round(cantpg/30)));}

    if not QFacturamesaid.IsNull then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
      dm.Query1.SQL.Add('from Mesas m, Areas a');
      dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
      dm.Query1.SQL.Add('and m.mesaid = :cod');
      dm.Query1.SQL.Add('order by m.MesaID');
      dm.Query1.Parameters.ParamByName('cod').Value := QFacturamesaid.Value;
      dm.Query1.Open;

      SendCmd(Stat, Err,PCHAR('80 '+'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString));
    end;

  if QFacturaNombre.Value <> '' then
  begin
    SendCmd(Stat, Err,PCHAR('80 '+ 'Cliente: '+QFacturaNombre.Value));
    if Trim(QFacturarnc.Value) <> '' then
      SendCmd(Stat, Err,PCHAR('80 '+ 'RNC ...: '+QFacturarnc.Value));
  end;

  if QFacturaNCF.Value <> '' then
    SendCmd(Stat, Err,PCHAR('80 '+ 'NCF    : '+QFacturaNCF.Value));

  SendCmd(Stat, Err,PCHAR('80 '+ '-------------------------------------------------------'));
  SendCmd(Stat, Err,PCHAR('80* '+'CANT.'));
  SendCmd(Stat, Err,PCHAR('80* '+'DESCRIPCION                                     VALOR'));
  SendCmd(Stat, Err,PCHAR('80 '+ '-------------------------------------------------------'));
  TFac := 0;
  MontoItbis := 0;
  QDetalle.DisableControls;
  QDetalle.First;
  ln := 1;
  while not QDetalle.eof do
  begin
    StrTmp :='';
    if QDetalleItbis.value = True then
      lbitbis := 'G'
    else
      lbitbis := 'E';

    StrTmp :=  format('%n',[QDetalleCantidad.value]) + ' x ' + format('%n',[QDetallePrecio.value]) ;
    SendCmd(Stat, Err,PCHAR('80 '+  StrTmp));
    //busca descripcion y monto
    StrTmp :=dm.PAD(' ','L',15,FormatFloat(',,,0.00',QDetalleValor.value));
    StrTmp := dm.PAD(' ','R',39,copy(trim(QDetalleNombre.value),1,39)) + StrTmp +' '+lbitbis;
    SendCmd(Stat, Err,PCHAR('80 '+  StrTmp));
    TFac := TFac + QDetalleValor.value;
    ln := ln + 1;
    QDetalle.next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;

  SendCmd(Stat, Err,PCHAR('80 '+ '-------------------------------------------------------'));
  tCambio := Devuelta;

  s := '';
  FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
  s1:= '';
  FillChar(s1, 10-length(trim(FORMAT('%n',[MPagado]))), ' ');
  s2:= '';
  FillChar(s2, 10-length(trim(FORMAT('%n',[tCambio]))), ' ');
  s3:= '';
  FillChar(s3, 10-length(trim(FORMAT('%n',[QFacturaItbis.Value]))), ' ');
  s4:= '';
  FillChar(s4, 10-length(trim(FORMAT('%n',[QFacturaTotal.Value]))), ' ');
  s5:= '';
  FillChar(s5, 10-length(trim(FORMAT('%n',[QFacturaPropina.Value]))), ' ');
  s7:= '';
  FillChar(s7, 10-length(trim(FORMAT('%n',[TFac]))), ' ');
  s8:= '';
  FillChar(s8, 10-length(trim(FORMAT('%n',[QFacturaDescuento.Value]))), ' ');


  SendCmd(Stat, Err,PCHAR('80 '+  '                                   SubTotal: '+s7+format('%n',[TFac])));
  SendCmd(Stat, Err,PCHAR('80 '+  '                                  Descuento: '+s8+format('%n',[QFacturaDescuento.Value])));
  if QForma.RecordCount > 0 then
  begin
    SendCmd(Stat, Err,PCHAR('80 '+  '                                 Recibido: '+s1+format('%n',[MPagado])));
    SendCmd(Stat, Err,PCHAR('80 '+  '                                 Cambio  : '+s2+format('%n',[tCambio])));
    SendCmd(Stat, Err,PCHAR('80 '+  ' '));
    SendCmd(Stat, Err,PCHAR('80 '+  '                                 Itbis   : '+s3+format('%n',[QFacturaItbis.Value])));
    if QFacturaPropina.Value > 0 then
      SendCmd(Stat, Err,PCHAR('80 '+  '                                 10% Ley : '+s5+format('%n',[QFacturaPropina.Value])));

    SendCmd(Stat, Err,PCHAR('80 '+   ' '));
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
      SendCmd(Stat, Err,PCHAR('80 '+  '                                  Dólares : '+s6+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)])));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
      SendCmd(Stat, Err,PCHAR('80 '+  '                                  Euros   : '+s7+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)])));
    end;

    if QFacturaCredito.Value = True then
    begin
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80! '+   '--------------------------'));
      SendCmd(Stat, Err,PCHAR('80! '+   'Firma del Cliente'));
      SendCmd(Stat, Err,PCHAR('80 '+  ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80! '+   '--------------------------'));
      SendCmd(Stat, Err,PCHAR('80! '+   'Firma del Supervisor'));
    end;
  end
  else
  begin
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Itbis   : '+s3+format('%n',[QFacturaItbis.Value])));
    if QFacturaPropina.Value > 0 then
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   10% Ley : '+s5+format('%n',[QFacturaPropina.Value])));

    s7:= '';
    FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value)]))), ' ');
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Total   : '+s7+format('%n',[(QFacturaTotal.Value)])));

   SendCmd(Stat, Err,PCHAR('80 '+   ' '));
     if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Dólares : '+s6+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)])));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Euros   : '+s7+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)])));
    end;
  end;

  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje1.AsString)));
  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje2.AsString)));
  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje3.AsString)));
  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje4.AsString)));

    ///   SendCmd(Stat, Err,'7');
    SendCmd(Stat, Err,PCHAR('81'));
    // For X := 1 To Copias Do
    //   SendCmd(Stat, Err, PChar('RU'));

    result :=true;

  finally
    CloseFpctrl;
  end;

end;

function TfrmPOS.ImprimeCtaTicketNoFiscalBixolon(
  ImpFiscal: TImpresora): boolean;

Var arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, trecargo : Double;
  Puntos : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
  pro_codigo:String;
  v_TotalImp :Double;
  v_TotalPagado:Double;
  copias, ln: integer;

  dgeneral, rgeneral : boolean;

  Stat, Err, X: Integer;
  Credito : Boolean;
  //-----------------------

  sAjuste:Double;
  sMontoPagado : Double;
  sPorcDescGral:Double;
  sStringTmp:String;
  sPrecio:double;
  vord:byte;
  Unidad:string;
  sDescuento:Double;
  DescRecGlobal :Double;
  porcItbis:double;
  a : Word;
  StrTmp:String;
begin
  result :=false;


  if not getPrinterFiscalBixolonStatus() then
    begin
      ShowMessage('Impresora NO conectada');
      exit;
    end;

  try

    Copias := ImpresoraFiscal.Copia;
    v_TotalPagado:=0;
    ItbisIncluido :=dm.QEmpresaPrecioIncluyeItbis.value = 'S'; //  dm.QParametrospar_itbisincluido.Value = 'True';
    Credito := False;
    StrTmp := trim(QFacturaNCF.Value);


    dm.Query1.close;
    dm.Query1.SQL.clear;
    dm.Query1.SQL.add('select Nombre from usuarios');
    dm.Query1.SQL.add('where UsuarioID = :usu');
    dm.Query1.Parameters.parambyname('usu').Value := frmMain.Usuario;
    dm.Query1.open;

   //pg := 1;
    //cantpg := QDetalle.RecordCount;

    //apertura
    SendCmd(Stat, Err, PChar('/6'));

    SendCmd(Stat, Err,PCHAR('80¡ '+titulo_cuenta));
    SendCmd(Stat, Err,PCHAR('80 '+'Fecha .: '+DateToStr(QFacturaFecha.Value)+' Cuenta: '+formatfloat('0000000000',QFacturaFacturaID.value)));
    SendCmd(Stat, Err,PCHAR('80 '+'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(QFacturaHora.AsDateTime)));
    SendCmd(Stat, Err,PCHAR('80 '+'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring));

    {if cantpg > 30 then
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Pagina : '+inttostr(pg)+' de '+inttostr(Round(cantpg/30)));}

    if not QFacturamesaid.IsNull then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
      dm.Query1.SQL.Add('from Mesas m, Areas a');
      dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
      dm.Query1.SQL.Add('and m.mesaid = :cod');
      dm.Query1.SQL.Add('order by m.MesaID');
      dm.Query1.Parameters.ParamByName('cod').Value := QFacturamesaid.Value;
      dm.Query1.Open;

      SendCmd(Stat, Err,PCHAR('80 '+'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString));
    end;

  if QFacturaNombre.Value <> '' then
  begin
    SendCmd(Stat, Err,PCHAR('80 '+ 'Cliente: '+QFacturaNombre.Value));
    if Trim(QFacturarnc.Value) <> '' then
      SendCmd(Stat, Err,PCHAR('80 '+ 'RNC ...: '+QFacturarnc.Value));
  end;

  if QFacturaNCF.Value <> '' then
    SendCmd(Stat, Err,PCHAR('80 '+ 'NCF    : '+QFacturaNCF.Value));

  SendCmd(Stat, Err,PCHAR('80 '+ '-------------------------------------------------------'));
  SendCmd(Stat, Err,PCHAR('80* '+'CANT.'));
  SendCmd(Stat, Err,PCHAR('80* '+'DESCRIPCION                                     VALOR'));
  SendCmd(Stat, Err,PCHAR('80 '+ '-------------------------------------------------------'));
  TFac := 0;
  MontoItbis := 0;
  QDetalle.DisableControls;
  QDetalle.First;
  ln := 1;
  while not QDetalle.eof do
  begin
    StrTmp :='';
    if QDetalleItbis.value = True then
      lbitbis := 'G'
    else
      lbitbis := 'E';

    StrTmp :=  format('%n',[QDetalleCantidad.value]) + ' x ' + format('%n',[QDetallePrecio.value]) ;
    SendCmd(Stat, Err,PCHAR('80 '+  StrTmp));
    //busca descripcion y monto
    StrTmp :=dm.PAD(' ','L',15,FormatFloat(',,,0.00',QDetalleValor.value));
    StrTmp := dm.PAD(' ','R',39,copy(trim(QDetalleNombre.value),1,39)) + StrTmp +' '+lbitbis;
    SendCmd(Stat, Err,PCHAR('80 '+  StrTmp));
    TFac := TFac + QDetalleValor.value;
    ln := ln + 1;
    QDetalle.next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;

  SendCmd(Stat, Err,PCHAR('80 '+ '-------------------------------------------------------'));
  tCambio := Devuelta;

  s := '';
  FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
  s1:= '';
  FillChar(s1, 10-length(trim(FORMAT('%n',[MPagado]))), ' ');
  s2:= '';
  FillChar(s2, 10-length(trim(FORMAT('%n',[tCambio]))), ' ');
  s3:= '';
  FillChar(s3, 10-length(trim(FORMAT('%n',[QFacturaItbis.Value]))), ' ');
  s4:= '';
  FillChar(s4, 10-length(trim(FORMAT('%n',[QFacturaTotal.Value]))), ' ');
  s5:= '';
  FillChar(s5, 10-length(trim(FORMAT('%n',[QFacturaPropina.Value]))), ' ');
  s7:= '';
  FillChar(s7, 10-length(trim(FORMAT('%n',[TFac]))), ' ');
  s8:= '';
  FillChar(s8, 10-length(trim(FORMAT('%n',[QFacturaDescuento.Value]))), ' ');


  SendCmd(Stat, Err,PCHAR('80 '+  '                                   SubTotal: '+s7+format('%n',[TFac])));
  SendCmd(Stat, Err,PCHAR('80 '+  '                                  Descuento: '+s8+format('%n',[QFacturaDescuento.Value])));
  if QForma.RecordCount > 0 then
  begin
    SendCmd(Stat, Err,PCHAR('80 '+  '                                 Recibido: '+s1+format('%n',[MPagado])));
    SendCmd(Stat, Err,PCHAR('80 '+  '                                 Cambio  : '+s2+format('%n',[tCambio])));
    SendCmd(Stat, Err,PCHAR('80 '+  ' '));
    SendCmd(Stat, Err,PCHAR('80 '+  '                                 Itbis   : '+s3+format('%n',[QFacturaItbis.Value])));
    if QFacturaPropina.Value > 0 then
      SendCmd(Stat, Err,PCHAR('80 '+  '                                 10% Ley : '+s5+format('%n',[QFacturaPropina.Value])));

    SendCmd(Stat, Err,PCHAR('80 '+   ' '));
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
      SendCmd(Stat, Err,PCHAR('80 '+  '                                  Dólares : '+s6+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)])));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
      SendCmd(Stat, Err,PCHAR('80 '+  '                                  Euros   : '+s7+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)])));
    end;

    if QFacturaCredito.Value = True then
    begin
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80! '+   '--------------------------'));
      SendCmd(Stat, Err,PCHAR('80! '+   'Firma del Cliente'));
      SendCmd(Stat, Err,PCHAR('80 '+  ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80 '+   ' '));
      SendCmd(Stat, Err,PCHAR('80! '+   '--------------------------'));
      SendCmd(Stat, Err,PCHAR('80! '+   'Firma del Supervisor'));
    end;
  end
  else
  begin
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Itbis   : '+s3+format('%n',[QFacturaItbis.Value])));
    if QFacturaPropina.Value > 0 then
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   10% Ley : '+s5+format('%n',[QFacturaPropina.Value])));

    s7:= '';
    FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value)]))), ' ');
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Total   : '+s7+format('%n',[(QFacturaTotal.Value)])));

   SendCmd(Stat, Err,PCHAR('80 '+   ' '));
     if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Dólares : '+s6+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)])));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
  SendCmd(Stat, Err,PCHAR('80 '+  '                                   Euros   : '+s7+format('%n',[(QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)])));
    end;
  end;

  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje1.AsString)));
  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje2.AsString)));
  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje3.AsString)));
  SendCmd(Stat, Err,PCHAR('80 '+ dm.centro(dm.QEmpresaMensaje4.AsString)));

    ///   SendCmd(Stat, Err,'7');
    SendCmd(Stat, Err,PCHAR('81'));
    // For X := 1 To Copias Do
    //   SendCmd(Stat, Err, PChar('RU'));

    result :=true;

  finally
    CloseFpctrl;
  end;
end;

function TfrmPOS.getPrinterFiscalBixolonStatus: boolean;
begin
 OpenFpctrl(PChar(PuertoSerial[ImpresoraFiscal.Puerto -1]));
  ImpresoraFiscal.isConected := CheckFprinter();
  Respuesta := ImpresoraFiscal.isConected;
  result := ImpresoraFiscal.isConected;
end;

procedure TfrmPOS.QFormaNewRecord(DataSet: TDataSet);
begin
QFormaemp_codigo.Value := frmMain.vp_cia;
QFormasuc_codigo.Value := frmMain.vp_suc;

end;

procedure TfrmPOS.ckConItbisClick(Sender: TObject);
begin
 ckItbis := ckConItbis.Checked;
 if not QDetalleProductoID.IsNull then Totalizar;
end;

end.


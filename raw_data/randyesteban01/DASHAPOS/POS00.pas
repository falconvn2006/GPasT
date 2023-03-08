unit POS00;

interface
 (*
  Cambios en base de datos.  para el pos

   Alter table montos_ticket add
     tfa_codigo int default 0 not null,
     tip_codigo int,
     cli_codigo int default 0 not null ,
     ven_codigo integer default 0 not null,
     tk_porcomision numeric(6,3) not null default 0,
     tk_Monto_comision numeric(15,2) default 0 not null,
     tk_conitbis varchar(5) default 'False' not null,
     TK_abono numeric(15,2) default 0 not null

   ;


 *)
 
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, DBGrids, Buttons, DB, ADODB, Winsock,
  DIMime, DateUtils, OleCtrls,  Math, jpeg, Mask, DBCtrls,
  QuerySearchDlgADO, IdBaseComponent, IdComponent, IdIPWatch, dxmdaset,
  IBCustomDataSet, ActnList, OposScale_CCO_TLB, OposScanner_CCO_TLB,
  uJSON, OCXFISLib_TLB, vmaxFiscal, iFiscal, Tfhkaif;


const
   CM_RESTORE = WM_USER + $1000;

type
  TClientes = class
  private
    FIDCliente: integer;
    FRNC: String;
    FTipoNCF: Word;

    function getRazonSocial: String;
    procedure setIDCliente(const Value: integer);
  public
    property ID :integer read FIDCliente write setIDCliente;
    property RNC: String read FRNC write FRNC;
    property Nombre : String read getRazonSocial;
    property TipoNCF :Word read FTipoNCF write  FTipoNCF;
    procedure Clear;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  private

  end;

  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    StaticText10: TStaticText;
    edproducto: TEdit;
    Panel4: TPanel;
    pnefectivo: TPanel;
    pncheque: TPanel;
    pncombinado: TPanel;
    pnunidad: TPanel;
    pnNCF: TPanel;
    pncliente: TPanel;
    pnbuscaprod: TPanel;
    pnborrar: TPanel;
    pncancelatk: TPanel;
    pncuadre: TPanel;
    pnabrircaja: TPanel;
    pnreimprimir: TPanel;
    pnalunatk: TPanel;
    pndescuento: TPanel;
    pndeposito: TPanel;
    pnprecio: TPanel;
    pnreporte: TPanel;
    pncredito: TPanel;
    pncopia: TPanel;
    Panel25: TPanel;
    pnsalir: TPanel;
    Panel29: TPanel;
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
    dsDetalle: TDataSource;
    Timer1: TTimer;
    QTicketnombre: TStringField;
    QTicketrnc: TStringField;
    Query1: TADOQuery;
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
    QTicketstatus: TStringField;
    QTicketNCF: TStringField;
    StaticText1: TStaticText;
    edcantidad: TEdit;
    lbund: TStaticText;
    QTicketmov_numero: TIntegerField;
    QTicketNCF_Tipo: TIntegerField;
    QOferta: TADOQuery;
    QOfertaprecio: TBCDField;
    QTicketfecha_hora: TDateTimeField;
    ProcNCF: TADOStoredProc;
    QOfertaporciento: TBCDField;
    QOfertaregalar: TStringField;
    Query2: TADOQuery;
    QTicketBoletos: TIntegerField;
    QCuadre: TADOQuery;
    QCuadrefecha: TDateTimeField;
    QCuadrecaja: TIntegerField;
    QCuadreusu_codigo: TIntegerField;
    QCuadreefectivo_cajero: TBCDField;
    QCuadrecheque_cajero: TBCDField;
    QCuadretarjeta_cajero: TBCDField;
    QCuadreefectivo_total: TBCDField;
    QCuadrecheque_total: TBCDField;
    QCuadretarjeta_total: TBCDField;
    QCuadreefectivo_asignado: TBCDField;
    QCuadrefecha_hora: TDateTimeField;
    QCuadrebonosclub_total: TBCDField;
    QCuadrebonosotros_total: TBCDField;
    dsFormaPago: TDataSource;
    QTicketsupervisor: TIntegerField;
    dsTicket: TDataSource;
    pntemporal: TPanel;
    pndomicilio: TPanel;
    QTicketdomicilio: TStringField;
    lpatrocinador: TListBox;
    QTicketemp_codigo: TIntegerField;
    QTicketsorteo: TStringField;
    QTicketgrabado: TBCDField;
    QTicketexento: TBCDField;
    Memo1: TMemo;
    Image4: TImage;
    Search: TQrySearchDlgADO;
    QTicketven_codigo: TIntegerField;
    QTicketporciento_com: TBCDField;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    edcaja: TStaticText;
    Label9: TLabel;
    edcajero: TStaticText;
    lbitbis: TLabel;
    Label5: TLabel;
    edticket: TStaticText;
    Label7: TLabel;
    edfecha: TStaticText;
    Label8: TLabel;
    edhora: TStaticText;
    Label12: TLabel;
    btVendedor: TSpeedButton;
    tVendedor: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    btBuscaCli: TSpeedButton;
    Label14: TLabel;
    dbRnc: TDBEdit;
    Label17: TLabel;
    DBEdit11: TDBEdit;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    Label10: TLabel;
    DBEdit3: TDBEdit;
    SpeedButton1: TSpeedButton;
    QTicketTK_CONITBIS: TStringField;
    QTicketTK_abono: TBCDField;
    QTickettfa_codigo: TIntegerField;
    QTickettip_codigo: TIntegerField;
    Label18: TLabel;
    bttiponcf: TSpeedButton;
    ttiponcf: TEdit;
    QTicketcli_codigo: TIntegerField;
    adoClientes: TADOQuery;
    edTipoNCF: TEdit;
    edIDVEND: TEdit;
    edIDClte: TEdit;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    edDescVolumen: TEdit;
    QTickettk_Monto_Comision: TBCDField;
    QSerie: TADOQuery;
    pSerie: TPanel;
    QSerieser_secuencia: TIntegerField;
    QSerieser_numero: TStringField;
    QSerieproducto: TIntegerField;
    QSerieticket: TIntegerField;
    QSerietic_secuencia: TIntegerField;
    QDatos: TADOQuery;
    QTicketcli_telefono: TStringField;
    QTicketcli_direccion: TStringField;
    QTicketcli_Descuento: TCurrencyField;
    QTickettksorteo: TCurrencyField;
    QTicketusuario_original: TIntegerField;
    QTicketticket_original: TIntegerField;
    QTicketcaja_original: TIntegerField;
    QTicketDevuelto: TCurrencyField;
    QTicketCuadre: TIntegerField;
    QTickettelefono_domicilio: TStringField;
    QTicketnombre_domicilio: TStringField;
    QTicketmon_nif: TStringField;
    QTicketporc_desc_gral: TCurrencyField;
    QTicketTdesc_gral: TCurrencyField;
    QTicketNIF: TStringField;
    pntarjeta: TPanel;
    boton17: TStaticText;
    boton18: TStaticText;
    boton19: TStaticText;
    boton20: TStaticText;
    boton16: TStaticText;
    boton15: TStaticText;
    boton14: TStaticText;
    boton13: TStaticText;
    boton9: TStaticText;
    boton10: TStaticText;
    boton11: TStaticText;
    boton12: TStaticText;
    boton8: TStaticText;
    boton6: TStaticText;
    boton5: TStaticText;
    boton2: TStaticText;
    boton1: TStaticText;
    boton3: TStaticText;
    boton4: TStaticText;
    StaticText5: TStaticText;
    StaticText4: TStaticText;
    StaticText3: TStaticText;
    StaticText2: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    boton7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText14: TStaticText;
    StaticText13: TStaticText;
    StaticText12: TStaticText;
    StaticText11: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText18: TStaticText;
    StaticText22: TStaticText;
    StaticText21: TStaticText;
    StaticText20: TStaticText;
    StaticText19: TStaticText;
    lbtotal: TStaticText;
    lblCantProd: TLabel;
    MDDetalles: TdxMemData;
    MDDetallesusu_codigo: TIntegerField;
    MDDetallesfecha: TDateTimeField;
    MDDetallesticket: TIntegerField;
    MDDetallessecuencia: TIntegerField;
    MDDetalleshora: TStringField;
    MDDetallesproducto: TIntegerField;
    MDDetallesdescripcion: TStringField;
    MDDetallescantidad: TCurrencyField;
    MDDetallesprecio: TCurrencyField;
    MDDetallesempaque: TStringField;
    MDDetallesitbis: TCurrencyField;
    MDDetallesCosto: TCurrencyField;
    MDDetallesValor: TCurrencyField;
    MDDetallesPrecioItbis: TCurrencyField;
    MDDetallesCalcItbis: TCurrencyField;
    MDDetallesExcento: TStringField;
    MDDetallesdescuento: TCurrencyField;
    MDDetallesDevuelta: TCurrencyField;
    MDDetallesTotalDescuento: TCurrencyField;
    MDDetallesTotalPrecio: TCurrencyField;
    MDDetallesRealizo_Oferta: TStringField;
    MDDetallesOferta: TCurrencyField;
    MDDetallesPatrocinador: TStringField;
    MDDetallesfam_codigo: TIntegerField;
    MDDetallesdep_codigo: TIntegerField;
    MDDetallessup_codigo: TIntegerField;
    MDDetallesger_codigo: TIntegerField;
    MDDetallesgon_codigo: TIntegerField;
    MDDetallescol_codigo: TIntegerField;
    MDDetallesmar_codigo: TIntegerField;
    MDDetallesRecargo: TCurrencyField;
    MDDetallespro_serializado: TStringField;
    qDetalle: TADOQuery;
    qDetalleusu_codigo: TIntegerField;
    qDetallefecha: TDateTimeField;
    qDetalleticket: TIntegerField;
    qDetallesecuencia: TIntegerField;
    qDetallehora: TStringField;
    qDetalleproducto: TIntegerField;
    qDetalledescripcion: TStringField;
    qDetallecantidad: TBCDField;
    qDetalleprecio: TBCDField;
    qDetalleempaque: TStringField;
    qDetalleitbis: TBCDField;
    qDetalleCosto: TBCDField;
    qDetallecaja: TIntegerField;
    qDetalledescuento: TBCDField;
    qDetalledevuelta: TBCDField;
    qDetalleRealizo_Oferta: TStringField;
    qDetalleOferta: TBCDField;
    qDetallePatrocinador: TStringField;
    qDetallefam_codigo: TIntegerField;
    qDetalledep_codigo: TIntegerField;
    qDetallesup_codigo: TIntegerField;
    qDetalleger_codigo: TIntegerField;
    qDetallegon_codigo: TIntegerField;
    qDetallecol_codigo: TIntegerField;
    qDetallemar_codigo: TIntegerField;
    qDetallerecargo: TBCDField;
    qDetallepro_serializado: TStringField;
    qDetalleTotalDescuento: TCurrencyField;
    qDetallePrecioItbis: TCurrencyField;
    qDetalleValor: TCurrencyField;
    qDetalleCalcItbis: TCurrencyField;
    qDetalleTotalPrecio: TCurrencyField;
    qDetalleExcento: TStringField;
    qDetallealm_codigo: TIntegerField;
    qSecuencia: TADOQuery;
    qSecuencianum: TIntegerField;
    dbedtemp_codigo: TDBEdit;
    actlst1: TActionList;
    actBuscarPeso: TAction;
    QFormaPagofor_veriphone_desc: TStringField;
    qImpCardNet: TADOQuery;
    oposscale1: TOPOSScale;
    pnMsgImpresion: TPanel;
    lblWait: TLabel;
    OPOSScanner1: TOPOSScanner;
    MDLista: TdxMemData;
    MDListaLProducto: TIntegerField;
    dsMDLista: TDataSource;
    Image2: TImage;
    lblEstado: TLabel;
    lblStatusPrinter: TLabel;
    tmVerificaPuerto: TTimer;
    qVerVentaGobierno: TADOQuery;
    qCantComboInespre: TADOQuery;
    qDetalleemp_codigo: TIntegerField;
    qDetallesuc_codigo: TIntegerField;
    QFormaPagoemp_codigo: TIntegerField;
    QFormaPagosuc_codigo: TIntegerField;
    QTicketsuc_codigo: TIntegerField;
    procedure pnsalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure edproductoKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1Enter(Sender: TObject);
    procedure pnclienteClick(Sender: TObject);
    procedure pnefectivoClick(Sender: TObject);
    procedure pntarjetaClick(Sender: TObject);
    procedure pnchequeClick(Sender: TObject);
    procedure pncombinadoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pncancelatkClick(Sender: TObject);
    procedure pnalunatkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnborrarClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure pnbuscaprodClick(Sender: TObject);
    procedure pnNCFClick(Sender: TObject);
    procedure QTicketCalcFields(DataSet: TDataSet);
    procedure pnreimprimirClick(Sender: TObject);
    procedure pnabrircajaClick(Sender: TObject);
    PROCEDURE pnabrircaja2;
    procedure edcantidadKeyPress(Sender: TObject; var Key: Char);
    procedure pncuadreClick(Sender: TObject);
    procedure pncreditoClick(Sender: TObject);
    procedure Panel25Click(Sender: TObject);
    procedure boton1Click(Sender: TObject);
    procedure pndescuentoClick(Sender: TObject);
    procedure pnunidadClick(Sender: TObject);
    procedure pnreporteClick(Sender: TObject);
    procedure pnprecioClick(Sender: TObject);
    procedure pncopiaClick(Sender: TObject);
    procedure pndepositoClick(Sender: TObject);
    procedure pndomicilioEnter(Sender: TObject);
    procedure pntemporalClick(Sender: TObject);
    procedure dsTicketStateChange(Sender: TObject);
    procedure pndomicilioClick(Sender: TObject);
    procedure btVendedorClick(Sender: TObject);
    procedure QTicketNewRecord(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure bttiponcfClick(Sender: TObject);
    procedure btBuscaCliClick(Sender: TObject);
    procedure DBEdit13KeyPress(Sender: TObject; var Key: Char);
    procedure edTipoNCFKeyPress(Sender: TObject; var Key: Char);
    procedure edTipoNCFChange(Sender: TObject);
    procedure edIDVENDKeyPress(Sender: TObject; var Key: Char);
    procedure edIDClteKeyPress(Sender: TObject; var Key: Char);
    procedure edIDVENDChange(Sender: TObject);
    procedure edIDClteChange(Sender: TObject);
    procedure edIDClteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pSerieClick(Sender: TObject);
    procedure QSerieAfterInsert(DataSet: TDataSet);
    procedure QSerieNewRecord(DataSet: TDataSet);
    procedure QDetalleAfterPost(DataSet: TDataSet);
    procedure MDDetallesCalcFields(DataSet: TDataSet);
    procedure actBuscarPesoExecute(Sender: TObject);
    procedure QTicketBeforePost(DataSet: TDataSet);
    procedure qDetalleBeforePost(DataSet: TDataSet);
    procedure VerificarVentasInespre;
    procedure VerificarMasUnCombo;
    procedure qDetalleBeforeDelete(DataSet: TDataSet);
    procedure qDetalleBeforeEdit(DataSet: TDataSet);
    procedure tmVerificaPuertoTimer(Sender: TObject);
    procedure qDetalleNewRecord(DataSet: TDataSet);
    procedure QFormaPagoNewRecord(DataSet: TDataSet);




  private
      Pregunta : String;
      TipoLector : Integer;

      puedeAbrirCaja:boolean;
    puertoFiscalOpen:boolean;

    procedure GuardarNIF(NIF: String);


    //procedure OpenCashDrawerFiscal;
    procedure getParametros(empresa: integer);
    procedure getCliente(_ID: Integer);
    procedure setValoresDefault;
    function  getNextTicket(aCaja, fNumeracion: word): integer;
    function  getDescPorRangoVta(IDEmpresa:integer; aTotalVenta:double):double;
    procedure setAplicaDesc(porc: double);
    procedure AplicaDescPorRangoVta(const atotal: double);
    function getDescProducto(idCompania, idProducto: Integer): Double;
    function  Producto_sin_Serializar(const key : string):boolean;{20170703}
    function GetLocalIp: string;

    procedure ImpTicketCardNet;
    Procedure ImpTicketFiscalCardNet(aCopia:byte = 0);
    procedure ImpTicketVmaxFiscalCardNet(aPuerto:Integer = 1;
                                  aVelocidad : Integer = 9600;
                                  aCopia:byte = 0;
                                  aTipo:String = 'P';
                                  aPrinter_usa_Precioconitbis:string = 'N');

    function GetProducto:Integer;
    function getPrinterFiscalBixolonStatus: boolean;
    { Private declarations }
  public
    SelCajero, SelCondi, facturar : boolean;
    TipoComprobante,err, empcomprobante  : integer;
    vp_verifone : Boolean;
    vMultiUso:String;

    LPagado, NombreCliente, rncCliente, tarjetaclub, credito, primercampo, ncf_tarjeta, PrecioCaja,
    UltProd, codigo_abre_caja, PuertoDisplay, ImprimeCredito, Termica, Patrocinador, ClaveEmp,
    ClaveTemp, Reimprimiendo, PrecioEmp,  VerPrecio, SeleccionTipo, Redondea, IPCaja, PrecioClie : string;
    MPagado, Precio, porciento,PorcRangoVenta,PorcientoClte, TotalVenta, Aumento: double;
    empresa, cliente, MovTicket, forma_numeracion, almacen, CantBoletos, empresainv, empcaja,
    SeleccionCliente, SeleccionEmpresa, vp_suc : integer;
    Comision, PorcFijo, MontoFijo : double;

    Cajero, FormatoImp, Dias, CodMov, Intervalo, FPagoIni, copias, caja, TipoFac, Vendedor, accion : integer;
    PuertoImp, TraerFormaPago, actbalance, FactPendiente, FactVencida,
    TieneVencido, Vencidos, Cuotas, CtaCliente, VerLimite,
    PrecioII,PantallaDevolver, Devuelta, Recibido, PermiteAbonar, NombreOtro, CtaCaja, ModificaNombre, intereses,
    FactDebajoCosto, FactDebajoMinimo, ConItbis, ImprimeEncaqbezado, SelRNC, MedidaAlmacen, CtaTipoFactura, CodigoLector,
    vl_respverifone, vl_tarjeta, Puerto2 : string;
    Debitos, Creditos : Double;
    Vendedor_Asociado_a_Clte :boolean ;
    procedure BuscaProducto(producto : string);
    procedure BuscaProducto2(producto : string);
    procedure Totaliza;
    procedure TicketNuevo(const default:boolean = false);
    procedure InsertaProducto;
    procedure ImpTicket;
    procedure ImpTicketRifa;
    procedure ImpTicketNorma201806;
//    Procedure ImpTicketFiscal;
  //  Procedure Reimprimir;
    procedure SeleccionaBoton(bt : TObject);
    procedure Boletos;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RestoreRequest(var message: TMessage); message CM_RESTORE;
    procedure IniciaDisplay;
    procedure Display(vTotal : Double; Descrip : String);
    procedure DisplayTotal;
    procedure DisplayEliminando;
    procedure DisplayProductoEliminado(vProd : string; vPrecio : string);
    procedure DisplayDevuelta(recibido, devuelta : double);
    procedure ImprimeDomicilio(empdomicilio : integer; ncfdomicilio, cliente : string);

    function ImprimeTicketFiscal(ImpresoraFiscal:TImpresora):boolean;
    Procedure ImpTicketFiscalEpson(ImpresoraFiscal:TImpresora);
    procedure ImpTicketVMAXFiscal(ImpresoraFiscal:TImpresora);
    procedure ImpTicketFiscalBixolon(ImpresoraFiscal:TImpresora);
    function getPregunta_x_Impresion(value: String): boolean;
    procedure OpenCashDrawerFiscal(vPrinterFiscal:TImpresora);
  end;

var
  frmMain: TfrmMain;
  Clientes:  TClientes;
  EnterKeyChar: Char = chr(13);
  Respuesta,gError: Boolean;
  puertoCaja:Byte;
  err: integer;
  ln: integer;
  ItbisIncluido:boolean;
  vPorc_Desc_Gral:Double;
  vImpresora_TItbis,vTotalImpresoraFiscal:double;
  v_TotalPagado:Double;

implementation

uses POS01, POS03, POS04, POS05, POS06, POS07, POS08, POS09, POS10, POS11,
  POS12, POS13, POS14, POS15, POS16, POS17, POS19, POS20, POS18, POS21,
  POS24, POS25, POS22, PVENTA185, POS27, CurrEdit;

{$R *.dfm}

const
  SQLFormaNumeracion1 = 'Select usu_codigo, fecha, caja, ticket,total,'+
                        'descuento, NCF_Fijo, NCF_Secuencia,itbis,nombre,'+
                        'rnc, status, mov_numero,NCF_Tipo,fecha_hora,'+
                        'Boletos, supervisor,sorteo,domicilio,emp_codigo,'+
                        'grabado, exento,ven_codigo,porciento_com,TK_CONITBIS,'+
                        'tfa_codigo,tip_codigo,TK_abono,cli_codigo '+
                        'From montos_ticket ' +
                        'Where caja   = :caj and ticket = :tik ' +
                        '  and fecha = convert(datetime, :fec, 105)'+
                        '  and usu_codigo = :usu';


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

procedure TfrmMain.setValoresDefault();
begin
  lpatrocinador.Items.Clear;
  ttiponcf.Text := '';
  tVendedor.Text := '';
  edTipoNCF.Text :='';
  edIDVEND.Text :='';
  edIDClte.Text :='';
  PorcientoClte:=0;
  Aumento := 0;
  edDescVolumen.Visible:=false;
  SeleccionTipo := '';
  SeleccionCliente := 0;
  SeleccionEmpresa := 0;
  lbund.Caption := 'UNIDAD';
  Reimprimiendo := 'N';
  TipoComprobante := 1;

  edTipoNCF.Text := IntToStr(TipoComprobante );
  //edTipoNCFKeyPress(nil,EnterKeyChar);

  LPagado := '';
  MPagado := 0;
  tarjetaclub   := '';
  credito       := 'False';
  cliente       := 0;
  MovTicket     := 0;
  UltProd := '';
  lbitbis.Caption := '0.00';
  lbtotal.Caption := '0.00';
  NombreCliente:= 'CLIENTE DE CONTADO' ;
  boton2.Color := $00FF8000;
end;


function TfrmMain.getNextTicket(aCaja:word; fNumeracion:word):integer;
begin
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select isnull(max(ticket),0)+1 as maximo');
  Query1.SQL.Add('from montos_ticket');
  Query1.SQL.Add('where caja = :caj');
  if fNumeracion = 1 then
  begin
    Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
    Query1.SQL.Add('and usu_codigo = :usu');
    Query1.Parameters.ParamByName('fec').DataType := ftDate;
    Query1.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
    Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
  end;
  Query1.Parameters.ParamByName('caj').Value    := aCaja;
  Query1.Open;
  result := Query1.FieldByName('maximo').AsInteger;
  Query1.Close;
end;


procedure TfrmMain.getParametros(empresa:integer);
begin
 (* With dm.adoMultiUso do begin  //1
    Close;
    Sql.Clear;
    sql.add('select * From parametros Where emp_codigo = :empresa');
    Parameters.ParamByName('empresa').Value := empresa;
    Open;
    if not IsEmpty then begin //2
      if not VarIsNull(dm.adoMultiUso['PAR_TFACODIGO']) then
        edTipo.Text := IntToStr(dm.adoMultiUso['PAR_TFACODIGO']);

      if (edTipo.Text <> '') then begin //2.1
        Close;
        Sql.Clear();
        sql.add('select * from tiposfactura Where emp_codigo = :empresa ');
        sql.add(' and tfa_codigo = :codigo');
        Parameters.ParamByName('empresa').Value := empresa;
        Parameters.ParamByName('codigo').Value := StrToInt(edTipo.Text);
        open;
        if not IsEmpty then begin //2.1.1
          if not VarIsNull(dm.adoMultiUso['ven_codigo']) then
            edVendedor.Text := IntToStr(dm.adoMultiUso['ven_codigo']);

          if not VarIsNull(dm.adoMultiUso['tfa_cliente']) then
            NombreCliente :=  dm.adoMultiUso.fieldbyname('tfa_cliente').asstring;
          getTipoFactura(StrToInt(edTipo.Text));
          getVendedor(StrToInt(edVendedor.Text));
        end; //2.1.1
      end; //2.1

    end;//2
  end; //1
  *)
end;


Procedure Valores_Iniciales;
Begin
                                          {Formato de Fecha del sistema }
  {ShortDateFormat := 'dd-MM-yyyy';
  DateSeparator := '-';
  TimeAMString := 'AM';
  TimePMString := 'PM';
  CurrencyDecimals := 2;
  CurrencyString   := '';
                                          {Nombres cortos de los dias }
  {ShortDayNames[01]     := 'Dom';
  ShortDayNames[02]     := 'Lun';
  ShortDayNames[03]     := 'Mar';
  ShortDayNames[04]     := 'Mie';
  ShortDayNames[05]     := 'Jue';
  ShortDayNames[06]     := 'Vie';
  ShortDayNames[07]     := 'Sab';
                                          {Nombres largos de los dias }
  {LongDayNames[01]     := 'Domingo';
  LongDayNames[02]     := 'Lunes';
  LongDayNames[03]     := 'Martes';
  LongDayNames[04]     := 'Miércoles';
  LongDayNames[05]     := 'Jueves';
  LongDayNames[06]     := 'Viernes';
  LongDayNames[07]     := 'Sabado';
                           {Nombres cortos de los meses (Solo los que varian) }
  {ShortMonthNames[01]  := 'Ene';
  ShortMonthNames[04]  := 'Abr';
  ShortMonthNames[08]  := 'Ago';
  ShortMonthNames[12]  := 'Dic';
                                          {Nombres largos de los meses }
  {LongMonthNames[01]   := 'Enero';
  LongMonthNames[02]   := 'Febrero';
  LongMonthNames[03]   := 'Marzo';
  LongMonthNames[04]   := 'Abril';
  LongMonthNames[05]   := 'Mayo';
  LongMonthNames[06]   := 'Junio';
  LongMonthNames[07]   := 'Julio';
  LongMonthNames[08]   := 'Agosto';
  LongMonthNames[09]   := 'Septiembre';
  LongMonthNames[10]   := 'Octubre';
  LongMonthNames[11]   := 'Noviembre';
  LongMonthNames[12]   := 'Diciembre';}
end;

function GetIPFromHost
(var HostName, IPaddr, WSAErr: string): Boolean; 
type 
  Name = array[0..100] of Char; 
  PName = ^Name;
var 
  HEnt: pHostEnt;
  HName: PName; 
  WSAData: TWSAData; 
  i: Integer; 
begin 
  Result := False;     
  if WSAStartup($0101, WSAData) <> 0 then begin
    WSAErr := 'Winsock is not responding."'; 
    Exit; 
  end; 
  IPaddr := ''; 
  New(HName); 
  if GetHostName(HName^, SizeOf(Name)) = 0 then
  begin 
    HostName := StrPas(HName^); 
    HEnt := GetHostByName(HName^);
    for i := 0 to HEnt^.h_length - 1 do 
     IPaddr :=
      Concat(IPaddr,
      IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.'); 
    SetLength(IPaddr, Length(IPaddr) - 1);
    Result := True; 
  end
  else begin 
   case WSAGetLastError of
    WSANOTINITIALISED:WSAErr:='WSANotInitialised'; 
    WSAENETDOWN      :WSAErr:='WSAENetDown'; 
    WSAEINPROGRESS   :WSAErr:='WSAEInProgress'; 
   end; 
  end; 
  Dispose(HName);
  WSACleanup; 
end;

procedure TfrmMain.AplicaDescPorRangoVta(const atotal:double);
begin
  //Estas linea verifica si la venta esta dentro del rango del porcentaje
  //para hacer descuentos especial
  if ((dm.QParametrospar_aplica_desc_por_rango_venta.value = 'True') and
     (atotal > 0)) then
  begin
    PorcRangoVenta := getDescPorRangoVta(dm.QParametrosEMP_CODIGO.Value,atotal);
    if (PorcRangoVenta  > 0 ) then
      begin
        setAplicaDesc(PorcRangoVenta);
        totaliza;
        edDescVolumen.Text := FormatFloat(',,,0.00',PorcRangoVenta);
        edDescVolumen.Visible:=true;
        edDescVolumen.BringToFront;
      end;
  end;
end;

function TfrmMain.getDescPorRangoVta(IDEmpresa:integer; aTotalVenta:double):double ;
begin
  result := 0;
  With dm.adoMultiUso do begin
    Close;
    sql.Clear();
    sql.add('Select top 1 porciento  From Rango_Descuento_Ventas ');
    sql.add('Where :valor between Desde and hasta');
    sql.add(' and  emp_codigo = :ID');
    Parameters.ParamByName('valor').Value := atotalVenta;
    Parameters.ParamByName('id').Value := IDEmpresa;
    open;
    if not IsEmpty then
      result := dm.adoMultiUso['porciento']
    else
      begin
        Close;
        sql.Clear();
        sql.add('Select IsNull(MAX(porciento),0) porc from Rango_Descuento_Ventas ');
        sql.add(' Where Hasta <=  :valor ');
        Parameters.ParamByName('valor').Value := atotalVenta;
        open;
        if not IsEmpty then
         result := dm.adoMultiUso['porc'];
      end;
  end;
end;

function TfrmMain.getDescProducto(idCompania:integer;
                                  idProducto:Integer):Double ;
begin
  result := 0;
  With  dm.adoMultiUso do begin
    Close;
    Sql.Clear();
    sql.add('Select pro_descmax from productos Where emp_codigo = :emp');
    sql.add(' and pro_codigo = :id');
    Parameters.ParamByName('emp').Value := idCompania;
    Parameters.ParamByName('id').Value := idProducto;
    open;
    if not IsEmpty then
      result := dm.adoMultiUso['pro_descmax'];
    close;  

  end;
end;

procedure TfrmMain.setAplicaDesc(porc:double);
var
  Descuento_Maximo : Double;
begin
  QDetalle.DisableControls;
  QDetalle.First;
  while not QDetalle.Eof do
  begin
    
    Descuento_Maximo := getDescProducto(QTicketemp_codigo.Value,QDetalleproducto.value );
    if (Descuento_Maximo > 0) then begin
      QDetalle.Edit;
      if (porc > Descuento_Maximo)  then
        QDetalledescuento.Value := Descuento_Maximo
      else
        QDetalledescuento.Value := porc;

      QDetalle.Post;
    end; // fin desc > 0
    QDetalle.Next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
  QDetalle.Post;
end;

procedure TfrmMain.Totaliza;
var
  nValor, nEntero : String;
  Descuento, Itbis, SubTotal, Total, Sub, tgrabado, texento, trecargo : Double;
begin
  Descuento := 0;
  Itbis     := 0;
  SubTotal  := 0;
  Total     := 0;
  tgrabado  := 0;
  texento   := 0;
  trecargo  := 0;
  QDetalle.DisableControls;
  QDetalle.First;
  TotalVenta := 0;
  lpatrocinador.Items.Clear;
  while not QDetalle.Eof do
  begin
    {if QDetalleitbis.Value > 0 then
      Sub    := (QDetalleprecio.Value / ((QDetalleitbis.Value/100)+1))
    else
      Sub    := QDetalleprecio.Value;

    if QDetallecantidad.Value <0 then Sub := Sub * -1;

    SubTotal := SubTotal + Sub;


    if QDetalleitbis.Value > 0 then
        Itbis  := Itbis + (((Sub * QDetalleitbis.Value)/100));

    Total := Total + QDetalleValor.Value;}

    Descuento := Descuento + QDetalleTotalDescuento.Value * QDetallecantidad.Value;
    SubTotal := SubTotal + (StrToFloat(format('%10.4F',[QDetallePrecioItbis.Value])) * QDetallecantidad.Value);

    if TipoComprobante <> 4 then
      Itbis := StrToFloat(format('%10.4F',[Itbis])) + (StrToFloat(format('%10.4F',[QDetalleCalcItbis.Value])) * QDetallecantidad.Value);

    Total := Total + StrToFloat(format('%10.2F',[QDetalleValor.Value]));
    if QDetallePatrocinador.Value = 'True' then
    begin
      if lpatrocinador.Items.Count = 0 then
        lpatrocinador.Items.add(QDetalleproducto.AsString);
    end;

    if QDetalleitbis.Value > 0 then
      tgrabado := tgrabado + QDetallePrecioItbis.Value * QDetallecantidad.Value;

    trecargo := trecargo + QDetallerecargo.Value;

    QDetalle.Next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
  //Total := StrToFloat(format('%10.4F',[SubTotal])) + Itbis;

  //lbsubtotal.Caption := format('%n',[SubTotal]);

  if Redondea = 'True' then
  begin
    //entre 0.01 and 0.49
    if (Frac(StrToFloat(Format('%10.2F',[Total]))) >= StrToFloat(Format('%10.2F',[0.01]))) and
    (Frac(StrToFloat(Format('%10.2F',[Total]))) <= StrToFloat(Format('%10.2F',[0.50]))) then
    begin
      nEntero := Copy(FloatToStr(Total), 1,Pos('.',FloatToStr(Total))-1);
      nValor  := nEntero;
      Total    := strtofloat(nValor);
    end;

    //entre 0.51 and 0.99
    if (Frac(StrToFloat(Format('%10.2F',[Total]))) >= StrToFloat(Format('%10.2F',[0.51]))) and
    (Frac(StrToFloat(Format('%10.2F',[Total]))) <= StrToFloat(Format('%10.2F',[0.99]))) then
    begin
      nEntero := Copy(FloatToStr(Total), 1,Pos('.',FloatToStr(Total))-1);
      nValor  := (FloatToStr((strtofloat(nEntero)+1)))+'.00';
      Total    := strtofloat(nValor);
    end;
  end;

  //Total := Total;

  lbitbis.Caption    := format('%n',[Itbis]);
  lbtotal.Caption    := format('%n',[Total]);

  QTicket.Edit;
  QTickettotal.Value := Total;
  QTicketitbis.Value := StrToFloat(format('%10.4F',[Itbis]));
  QTicketdescuento.Value := Descuento;
  QTicketgrabado.Value := tgrabado;
  QTicketexento.Value  := Total - (tgrabado + Itbis);
  if not VarIsNull(QTicketporciento_com.Value) then
    QTickettk_Monto_Comision.Value :=  ((Total - Itbis) * (QTicketporciento_com.Value/100));
  QTicket.Post;
  QTicket.UpdateBatch;

  TotalVenta := Total;
end;

procedure TfrmMain.pnsalirClick(Sender: TObject);
begin
  DM.Query1.Close;
  DM.Query1.SQL.Clear;
  DM.Query1.SQL.Add('select * from montos_ticket where status = ''TMP'' AND USU_CODIGO = '+IntToStr(dm.Usuario));
  DM.Query1.SQL.Add('AND FECHA BETWEEN CAST(CAST(GETDATE() AS CHAR(11)) AS DATETIME) AND GETDATE()');
  DM.Query1.OPEN;
  if DM.Query1.RecordCount > 0 then
  begin
    MessageDlg('NO PUEDE SALIR DEL SISTEMA CON PRODUCTOS EN HOLD O FACTURAS TEMPORALES...'+CHAR(13)+
    'DEBE SER AUTORIZADO POR UN SUPERVISOR...',mtWarning,[mbOK],0);
    DisplayEliminando;
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      DisplayTotal;
      edproducto.SetFocus;
      EXIT;
    end
    else
    begin
    if messagedlg('ESTA SEGURO QUE DESEA SALIR DEL SISTEMA?',mtconfirmation, [mbyes,mbno],0) = mryes then
    application.terminate else abort;
    end;
    end
    else
    begin
    DM.Query1.Close;
  DM.Query1.SQL.Clear;
  DM.Query1.SQL.Add('select * from montos_ticket where status = ''ABI'' AND USU_CODIGO = '+IntToStr(dm.Usuario));
  DM.Query1.SQL.Add('AND FECHA BETWEEN CAST(CAST(GETDATE() AS CHAR(11)) AS DATETIME) AND GETDATE()');
  DM.Query1.OPEN;
  if DM.Query1.RecordCount > 0 then
  begin
    MessageDlg('NO PUEDE SALIR DEL SISTEMA CON PRODUCTOS EN HOLD...'+CHAR(13)+
    'DEBE SER AUTORIZADO POR UN SUPERVISOR...',mtWarning,[mbOK],0);
    DisplayEliminando;
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      DisplayTotal;
      edproducto.SetFocus;
    end
    else
    begin
    if messagedlg('ESTA SEGURO QUE DESEA SALIR DEL SISTEMA?',mtconfirmation, [mbyes,mbno],0) = mryes then
    application.terminate else abort;
    end;
    end
    else
    begin
    if messagedlg('ESTA SEGURO QUE DESEA SALIR DEL SISTEMA?',mtconfirmation, [mbyes,mbno],0) = mryes then
    application.terminate else abort;
end;
end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Host, IP, Err: string;
  Sem  : THandle;
begin
  MDLista.Close;
  MDLista.Open;

  Sem := CreateSemaphore(nil,0,1,'DASHA POS');
  if ((Sem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS)) then
  begin
    CloseHandle( Sem );
    ShowMessage('Este programa ya se está ejecutando...');
    Halt;
  end;
  edcaja.Caption :='0';
  if dm.ADOSIGMA.Connected then
    dm.ADOSIGMA.Connected :=false;
  comision:=0;



  Clientes:=TClientes.Create(self);
  dm.QEmpresa.Open;

  //verificando el código del RNC
  if Trim(MimeEncodeString(dm.QEmpresaemp_rnc.AsString)) <> dm.QEmpresacode_rnc.AsString then
    begin
      MessageDlg('USTED NO TIENE AUTORIZACION PARA UTILIZAR ESTE SISTEMA,'+#13+
                 'COMUNIQUESE URGENTEMENTE CON EL PROVEEDOR',mtError,[mbok],0);
      Application.Terminate;
    end
  else
    begin //[0]
      Valores_Iniciales;
      edfecha.Caption := DateToStr(DM.getFechaServidor);
      edhora.Caption  := TimeToStr(DM.getFechaServidor2);
      //CurrencyString     := '';
      //CurrencyDecimals   := 2;

    if GetIPFromHost(Host, IP, Err) then
    begin //[1]
      IPCaja := IP;
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select ip,caja, primer_campo, porciento, forma_numeracion, emp_codigo,');
      dm.Query1.SQL.Add('imprime_credito, Precio_Emp, ncf_tarjeta, Precio, alm_codigo, codigo_abre_caja, Redondea,');
      dm.Query1.SQL.Add('puerto_display, Termica, clave_empaque, clave_temporal, Verifica_Precio, suc_codigo from Cajas_IP');
      dm.Query1.SQL.Add('where ip = :ip or upper(ip) = :host');
      dm.Query1.Parameters.ParamByName('ip').Value := IP;
      dm.Query1.Parameters.ParamByName('host').Value := UpperCase(Host);
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin //[2]
        IPCaja           :=dm.Query1.FieldByName('ip').asString;
        Redondea         := dm.Query1.FieldByName('Redondea').asString;
        VerPrecio        := dm.Query1.FieldByName('Verifica_Precio').asString;
        ClaveEmp         := dm.Query1.FieldByName('clave_empaque').asString;
        ClaveTemp        := dm.Query1.FieldByName('clave_temporal').asString;
        Termica          := dm.Query1.FieldByName('Termica').asString;
        ImprimeCredito   := dm.Query1.FieldByName('imprime_credito').asString;
        empcaja          := dm.Query1.FieldByName('emp_codigo').AsInteger;
        empresa          := empcaja;
        vp_suc           := dm.Query1.FieldByName('suc_codigo').AsInteger;
        almacen          := dm.Query1.FieldByName('alm_codigo').AsInteger;

        PrecioCaja       := dm.Query1.FieldByName('Precio').asString;
        if (PrecioCaja = '') then
        begin
          Application.MessageBox('Debe de especificar un precion el campo precio/unida/Emp en la caja','Aviso',MB_OK+MB_ICONSTOP);
          Application.Terminate;
        end;

        PrecioCaja       := dm.Query1.FieldByName('Precio').asString;
        PrecioEmp        := dm.Query1.FieldByName('Precio_Emp').asString;
        edcaja.Caption   := dm.Query1.FieldByName('caja').asString;
        primercampo      := dm.Query1.FieldByName('primer_campo').asString;
        porciento        := dm.Query1.FieldByName('porciento').AsFloat;
        forma_numeracion := dm.Query1.FieldByName('forma_numeracion').AsInteger;
        ncf_tarjeta      := dm.Query1.FieldByName('primer_campo').asString;
        codigo_abre_caja := dm.Query1.FieldByName('codigo_abre_caja').asString;
        PuertoDisplay    := dm.Query1.FieldByName('puerto_display').asString;

        //if dm.Query1.FieldByName('primer_campo').asString = 'P' then
        frmMain.ActiveControl := edproducto;

        Application.CreateForm(tfrmAcceso, frmAcceso);
        frmAcceso.lbtitulo.Caption := 'Digite la clave del Cajero';
        frmAcceso.ShowModal;

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select par_invempresa from parametros where emp_codigo = :emp');
        dm.Query1.Parameters.ParamByName('emp').Value := empcaja;
        dm.Query1.Open;
        empresainv := dm.Query1.FieldByName('par_invempresa').AsInteger;

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select usu_nombre, usu_codigo');
        dm.Query1.SQL.Add('from usuarios');
        dm.Query1.SQL.Add('where usu_clave = :cla');
        dm.Query1.sql.add('and usu_status = '+QuotedStr('ACT'));
        dm.Query1.Parameters.ParamByName('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);;
        dm.Query1.Open;
        while (dm.Query1.RecordCount = 0) and (frmAcceso.acepto <> 0) do
        begin
          frmAcceso.ShowModal;
          dm.Query1.Close;
          dm.Query1.Parameters.ParamByName('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);
          dm.Query1.Open;
        end;

        if frmAcceso.acepto = 0 then
          Application.Terminate;




        if (PrecioCaja = '') then
        begin
          Application.MessageBox('Debe de especificar un precion el campo precio/unida/Emp en la caja','Aviso',MB_OK+MB_ICONSTOP);
          Application.Terminate;
        end;

        dm.Usuario       := dm.Query1.FieldByName('usu_codigo').AsInteger;
        dm.NomUsuario    := dm.Query1.FieldByName('usu_nombre').AsString;
        edcajero.Caption := dm.NomUsuario;

         dm.adoMultiUso.Close;
         dm.adoMultiUso.SQL.Clear;
         dm.adoMultiUso.SQL.Add('select Max(fecha_hora)fecha from montos_ticket where caja = :caja and usu_codigo = :usu');
         dm.adoMultiUso.SQL.Add('having Max(fecha_hora)>getdate()');
         dm.adoMultiUso.Parameters.ParamByName('caja').Value := StrToInt(edcaja.Caption);
         dm.adoMultiUso.Parameters.ParamByName('usu').Value  := dm.Usuario;
         dm.adoMultiUso.Open;
         if DM.adoMultiUso.RecordCount>0  then begin
         MessageDlg('ESTE COMPUTADOR TIENE UNA FECHA/HORA MENOR QUE LA ULTIMA TRANSACCION FAVOR VERIFICAR LA FECHA/HORA',
         mtWarning,[mbOK],0);
         Application.Terminate;
         end;

        frmAcceso.Destroy;


        if not dm.QParametros.Active then
          begin
            dm.QParametros.Parameters.ParamByName('EMP_CODIGO').Value := empcaja;
            dm.QParametros.open;
          end;

          dm.getParametrosPrinterFiscal();
          //if not DM.adoMultiUso.FieldByName('IDPrinter').IsNull then
          //Impresora.IDPrinter := DM.adoMultiUso.FieldByName('IDPrinter').Value;

        if Impresora.IDPrinter = 5 then   //Muestra informacion printer bixolon
          Impresora.isConected := getPrinterFiscalBixolonStatus();

        lblEstado.Visible := Impresora.IDPrinter = 5;
        lblStatusPrinter.Visible := Impresora.IDPrinter = 5;

        tmVerificaPuerto.Enabled := true;

        copias:= Impresora.Copia;


        //Verificando si hay un ticket abierto
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select top 1 ticket from montos_ticket');
        dm.Query1.SQL.Add('where fecha = convert(datetime, :fec, 105)');
        dm.Query1.SQL.Add('and usu_codigo = :usu');
        dm.Query1.SQL.Add('and caja = :caj');
        dm.Query1.SQL.Add('and status = '+QuotedStr('ABI'));
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := dm.getFechaServidor;
        dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
        dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        dm.Query1.Open;


        setValoresDefault();
        dm.getParametrosPrinterFiscal;
        Vendedor_Asociado_a_Clte:=false;
        if dm.Query1.RecordCount > 0 then
        begin   //[3]
          QTicket.Close;
          if forma_numeracion = 1 then
          begin
            QTicket.SQL.Clear;
            QTicket.SQL.Add(SQLFormaNumeracion1);
            QTicket.Parameters.ParamByName('fec').DataType := ftDate;
            QTicket.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
            QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
          end;
          QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
          QTicket.Parameters.ParamByName('tik').Value    := dm.Query1.FieldByName('ticket').AsInteger;
          QTicket.Open;
          edticket.Caption := QTicketticket.AsString;

          if not QTicketNCF_Tipo.IsNull then
            TipoComprobante := QTicketNCF_Tipo.value;
          credito       := 'False';

          QDetalle.Close;
          if forma_numeracion = 1 then
          begin
            QDetalle.SQL.Clear;
            QDetalle.SQL.Add('select usu_codigo, fecha, ticket, secuencia,');
            QDetalle.SQL.Add('hora, producto, descripcion, cantidad, precio,');
            QDetalle.SQL.Add('empaque, itbis, Costo, caja, descuento,');
            QDetalle.SQL.Add('devuelta, Realizo_Oferta, Oferta,');
            QDetalle.SQL.Add('Patrocinador, fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo,');
            QDetalle.SQL.Add('col_codigo, mar_codigo');
            QDetalle.SQL.Add('from ticket');
            QDetalle.SQL.Add('where caja = :caj');
            QDetalle.SQL.Add('and ticket = :tik');
            QDetalle.SQL.Add('and fecha = convert(datetime, :fec, 105)');
            QDetalle.SQL.Add('and usu_codigo = :usu');
            QDetalle.SQL.Add('order by secuencia desc');
            QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
            QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
            QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
          end;
          QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
          QDetalle.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
          QDetalle.Open;

          QFormaPago.Close;
          if forma_numeracion = 1 then
          begin
            QFormaPago.SQL.Clear;
            QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
            QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
            QFormaPago.SQL.Add('from formas_pago_ticket');
            QFormaPago.SQL.Add('where caja = :caj');
            QFormaPago.SQL.Add('and ticket = :tik');
            QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
            QFormaPago.SQL.Add('and usu_codigo = :usu');
            QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
            QFormaPago.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
            QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
          end;
          QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
          QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
          QFormaPago.Open;

          totaliza;

        end  //[3]
        else
        begin  //[4]
         TicketNuevo();
         DM.getParametrosPrinterFiscal;
          end; //[4]

      end //[2]
      else
      begin
        MessageDlg('No existen una caja asociada con esta direccion IP: '+IP,mtError,[mbok],0);
        Application.Terminate;
      end;
    end; //[1]
    end;

with dm.QQuery,sql do {20170705}
begin
  Close;
  Clear;  
  Add('IF object_id('+ QuotedStr('tempdb.dbo.#TicSerie')+') IS NULL');
  Add(' begin');
  Add('CREATE TABLE #TicSerie ( ');
  Add('[ser_secuencia] [int] NULL ,');
  Add('[ticket] [int] NULL ,');
  Add('[tic_secuencia] [int] NULL ,');
  Add('[producto] [int] not NULL ,');
  Add('[ser_numero] [varchar] (30) not NULL');
  Add(' , PRIMARY KEY (producto ASC, ser_numero ASC))');   
  Add(' end begin delete from #TicSerie; end');
  ExecSQL;
  Clear;
end;

OPOSScanner1.Enabled := True;


end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  ar : textfile;
begin
  try
    if not FileExists('hora.bat') then
    begin
      assignfile(ar,'hora.bat');
      {I-}
      rewrite(ar);
      {I+}
      writeln(ar,'net time \\servidor /set /y');
      closefile(ar);
    end;
    if FileExists('hora.bat') then
      winexec('hora.bat',0);
  except
  end;

  edfecha.Caption := DateToStr(DM.getFechaServidor);
  edhora.Caption  := TimeToStr(DM.getFechaServidor2);
  Valores_Iniciales;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not QDetalle.Active then
  begin
    boton2.Color := $00FF8000;
    IniciaDisplay;
    if forma_numeracion = 1 then
    begin
      QDetalle.Close;
      QDetalle.SQL.Clear;
      QDetalle.SQL.Add('select');
      QDetalle.SQL.Add('usu_codigo, fecha, ticket, secuencia,');
      QDetalle.SQL.Add('hora, producto, descripcion, cantidad, precio, Patrocinador,');
      QDetalle.SQL.Add('empaque, itbis, Costo, caja, descuento, devuelta, Realizo_Oferta, Oferta,');
      QDetalle.SQL.Add('Patrocinador, fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo,');
      QDetalle.SQL.Add('col_codigo, mar_codigo');
      QDetalle.SQL.Add('from ticket');
      QDetalle.SQL.Add('where caja = :caj');
      QDetalle.SQL.Add('and ticket = :tik');
      QDetalle.SQL.Add('and fecha = convert(datetime, :fec, 105)');
      QDetalle.SQL.Add('and usu_codigo = :usu');
      QDetalle.SQL.Add('order by secuencia desc');
      QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
      QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
      QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
    end;

    QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
    QDetalle.Parameters.ParamByName('tik').Value    := -1;
    QDetalle.Open;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select b.boton, p.pro_nombre from botones_caja b, productos p');
    dm.Query1.SQL.Add('where b.producto = p.pro_codigo and p.emp_codigo = :emp');
    dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
    dm.Query1.Open;
    dm.Query1.DisableControls;
    while not dm.Query1.Eof do
    begin
      (FindComponent(dm.Query1.FieldByName('boton').AsString) as TStaticText).Caption :=
                                              dm.Query1.FieldByName('pro_nombre').AsString;
      dm.Query1.Next;
    end;
    dm.Query1.EnableControls;
  end
  else
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select b.boton, p.pro_nombre from botones_caja b, productos p');
    dm.Query1.SQL.Add('where b.producto = p.pro_codigo and p.emp_codigo = :emp');
    dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
    dm.Query1.Open;
    dm.Query1.DisableControls;
    while not dm.Query1.Eof do
    begin
      (FindComponent(dm.Query1.FieldByName('boton').AsString) as TStaticText).Caption :=
                                              dm.Query1.FieldByName('pro_nombre').AsString;
      dm.Query1.Next;
    end;
    dm.Query1.EnableControls;
  end;

MDLista.Close;
MDLista.Open;
IF qDetalle.RecordCount >  0 THEN BEGIN
qDetalle.First;
WHILE NOT qDetalle.Eof DO BEGIN
  MDLista.Append;
  MDListaLProducto.Value := qDetalleproducto.Value;
  MDLista.Post;
  qDetalle.Next;
end;
end;
end;



procedure TfrmMain.BuscaProducto(producto: string);
var
  Valor, Decimal, FormaTicketPeso, Cant : String;
  digitos, digitos_entero, digitos_decimal : integer;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select par_digitos_precio_pesar, par_forma_ticket_peso, par_digitos_entero, par_digitos_decimal');
  dm.Query1.SQL.Add('from parametros where emp_codigo = :emp');
  dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
  dm.Query1.Open;
  digitos         := dm.Query1.FieldByName('par_digitos_precio_pesar').AsInteger;
  FormaTicketPeso := dm.Query1.FieldByName('par_forma_ticket_peso').AsString;
  digitos_entero  := dm.Query1.FieldByName('par_digitos_entero').AsInteger;
  digitos_decimal := dm.Query1.FieldByName('par_digitos_decimal').AsInteger;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio2, pro_display,pro_serializado,');
  dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
 // if lbund.Caption = 'UNIDAD' THEN
 // DM.Query1.SQL.Add('pro_precio1,') ELSE
 // DM.Query1.SQL.Add('pro_precio2 pro_precio1,');
  DM.Query1.SQL.Add('pro_precio1,');
  dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, pro_cantempaque, pro_existempaque, pro_costoempaque, isnull(pro_detallado,''False'') Detallado from productos');
  if primercampo = 'L' then
    dm.Query1.SQL.Add('where pro_roriginal like '+QuotedStr('%'+edproducto.Text))
  else
  begin
    dm.Query1.SQL.Add('where pro_roriginal = :pro');
    dm.Query1.Parameters.ParamByName('pro').Value := producto;
  end;
  dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
  dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    if FormaTicketPeso = 'M' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio2, pro_display,pro_serializado,');
      if lbund.Caption = 'UNIDAD' THEN
      DM.Query1.SQL.Add('pro_precio1,') ELSE
      DM.Query1.SQL.Add('pro_precio2 pro_precio1,');
      dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
      dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, isnull(pro_detallado,''False'') Detallado  from productos');
      dm.Query1.SQL.Add('where pro_roriginal = :pro');
      dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
      dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,1,6);
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin
        if digitos = 3 then
        begin
          Valor := copy(producto,7,3);
          Decimal := copy(producto,10,3);
          Valor := Valor+'.'+Decimal;
          Precio := StrToFloat(Valor);
        end
        else if digitos = 4 then
        begin
          Valor := copy(producto,7,4);
          Decimal := copy(producto,11,3);
          Valor := Valor+'.'+Decimal;
          Precio := StrToFloat(Valor);
        end;
      end;
    end
    else if FormaTicketPeso = 'C' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio2, pro_display,pro_serializado,');
      if lbund.Caption = 'UNIDAD' THEN
      DM.Query1.SQL.Add('pro_precio1,') ELSE
      DM.Query1.SQL.Add('pro_precio2 pro_precio1,');
      dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
      dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, isnull(pro_detallado,''False'') Detallado  from productos');
      dm.Query1.SQL.Add('where pro_roriginal = :pro');
      dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      if digitos = 0 then
         dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,2,6)
      else
         dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,1,digitos);

      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin
        if digitos_entero > 0 then
        begin
          Cant    := copy(producto,digitos+1,digitos_entero);
          Decimal := copy(producto,digitos+digitos_entero+1,2);
          Valor := Cant+'.'+Decimal;
          edcantidad.text := Valor;
          Precio := dm.Query1.FieldByName('pro_precio1').AsFloat;
        end
        else
        begin
          Cant    := copy(producto,8,3);
          Decimal := copy(producto,11,2);
          Valor := Cant+'.'+Decimal;
          edcantidad.Text := Valor;
          //Precio := dm.Query1.FieldByName('pro_precio1').AsFloat * StrToFloat(Valor);
          Precio := dm.Query1.FieldByName('pro_precio1').AsFloat;
        end;
      end
    end
    else if FormaTicketPeso = 'T' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio2, pro_display,pro_serializado,');
      DM.Query1.SQL.Add('pro_precio1,');
      dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
      dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, isnull(pro_detallado,''False'') Detallado  from productos');
      dm.Query1.SQL.Add('where pro_roriginal = :pro');
      dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,1,6);
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin
        if digitos = 3 then
        begin
          Valor := copy(producto,7,3);
          Decimal := copy(producto,10,3);
          Valor := Valor+'.'+Decimal;
          edcantidad.Text := StrToFloat(Valor) / dm.Query1.FieldByName('pro_precio1').Value;
          {if PrecioClie <> '' then
          Precio := dm.Query1.FieldByName(PrecioClie).Value else}
          Precio := dm.Query1.FieldByName('pro_precio1').Value;
        end
        else if digitos = 4 then
        begin
          Valor := copy(producto,7,4);
          Decimal := copy(producto,11,3);
          Valor := Valor+'.'+Decimal;
          edcantidad.Text := StrToFloat(Valor) / dm.Query1.FieldByName('pro_precio1').Value;
          {if PrecioClie <> '' then
          Precio := dm.Query1.FieldByName(PrecioClie).Value else}
          Precio := dm.Query1.FieldByName('pro_precio1').Value;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.QDetalleCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
  if QDetalleITBIS.value > 0 then
  begin
    NumItbis := strtofloat(format('%10.2f',[(QDetalleITBIS.value/100)+1]));
    Venta    := strtofloat(format('%10.4f',[(QDetallePRECIO.value+QDetallerecargo.AsFloat)/NumItbis]));

    if QDetalledescuento.Value = 0 then
    begin
      QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                   strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

      QDetalleTotalPrecio.Value := strtofloat(format('%10.4f',[Venta])) +
                      strtofloat(format('%10.2f',[QDetalleCalcItbis.value]));
      QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
      QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                   strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                   strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
    end
    else
    begin
      QDetalleTotalDescuento.Value := (QDetallePRECIO.value * QDetalledescuento.Value) / 100;
      Venta := strtofloat(format('%10.4f',[(QDetallePRECIO.value - QDetalleTotalDescuento.Value)/NumItbis]));
      //Venta := strtofloat(format('%10.4f',[QDetallePRECIO.value/NumItbis]));

      QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                   strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

      QDetalleTotalPrecio.Value := strtofloat(format('%10.4f',[Venta])) +
                      strtofloat(format('%10.2f',[QDetalleCalcItbis.value]));
      QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
      QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                   strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                   strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
    end;
  end
  else
  begin
    Venta := strtofloat(format('%10.2f',[QDetallePRECIO.value+QDetallerecargo.AsFloat]));

    QDetalleTotalDescuento.Value := (Venta * QDetalledescuento.Value) / 100;
    Venta := Venta - QDetalleTotalDescuento.Value;

    QDetalleValor.value       := strtofloat(format('%10.2f',[(Venta)*QDetalleCANTIDAD.value]));
    QDetalleTotalPrecio.Value := strtofloat(format('%10.2f',[Venta])) +
                    strtofloat(format('%10.4f',[QDetalleCalcItbis.value]));
    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleCalcItbis.value   := 0;
  end;
  //QDetalleValor.Value := QDetalleprecio.Value * QDetallecantidad.Value;

  if QDetalleitbis.Value >0 then
    QDetalleExcento.Value := ''
  else
    QDetalleExcento.Value := 'E';
end;

procedure TfrmMain.edproductoKeyPress(Sender: TObject; var Key: Char);
var
  Prec : string;
  digitos : Integer;
begin
if ((key = #13) and (Sender = edproducto)) then
  begin
    Precio := 0;
    BuscaProducto(edproducto.Text);
    if trim(edproducto.Text) = '' then edproducto.Text := 'VARIOS';
     //Prec := InputBox('Precio','Precio','');
        if trim(Prec) <> '' then
        begin
          Precio := StrToFloat(Prec);
          UltProd := edproducto.Text;
          InsertaProducto;
        end
        else
          edproducto.Text := '';

    //UltProd := edproducto.Text;

    //BuscaProducto(edproducto.Text);
   // if dm.Query1.FieldByName('pro_servicio').AsString <> 'True' then
      InsertaProducto;
   { else
    begin
      Application.CreateForm(tfrmAcceso, frmAcceso);
      frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
      frmAcceso.ShowModal;
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select usu_codigo, clave from clave_supervisor_caja');
      dm.Query1.SQL.Add('where clave = :cla');
      dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
      dm.Query1.Open;
      if dm.Query1.RecordCount = 0 then
      begin
        MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
        edproducto.SetFocus;
      end
      else
      begin
        Prec := InputBox('Precio','Precio','');
        if trim(Prec) <> '' then
        begin
          Precio := StrToFloat(Prec);
          UltProd := edproducto.Text;
          InsertaProducto;
        end
        else
          edproducto.Text := '';
      end;
      edproducto.SetFocus;
    end;
    key := #0;
  end;       }
  end;
  if key = #27 then
  begin
    edcantidad.SetFocus;
    key := #0;
  end;
end;
{if TipoLector = 1 then begin
  if (key in [#8,'0'..'9']) and not (Key = #8) then begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select * from productos where emp_codigo = :paremp and pro_roriginal LIKE ');
  DM.Query1.Parameters.ParamByName('paremp').Value := DM.QParametrosPAR_INVEMPRESA.Value;
  DM.Query1.Parameters.ParamByName('pro').Value := edproducto.Text;
  DM.Query1.Open;
  if DM.Query1.RecordCount > 0 then
  if Sender = edproducto then
  keybd_event(VK_RETURN,0,0,0);
  end
  else
  if ((key = #13) and  (Sender = edproducto)) then
  begin
    Precio := 0;
    BuscaProducto(edproducto.Text);
    if trim(edproducto.Text) = '' then edproducto.Text := 'VARIOS';
     //Prec := InputBox('Precio','Precio','');
        if trim(Prec) <> '' then
        begin
          Precio := StrToFloat(Prec);
          UltProd := edproducto.Text;
          InsertaProducto;
        end
        else
        edproducto.Text := '';

    //UltProd := edproducto.Text;

    //BuscaProducto(edproducto.Text);
   // if dm.Query1.FieldByName('pro_servicio').AsString <> 'True' then
      InsertaProducto;
   { else
    begin
      Application.CreateForm(tfrmAcceso, frmAcceso);
      frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
      frmAcceso.ShowModal;
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select usu_codigo, clave from clave_supervisor_caja');
      dm.Query1.SQL.Add('where clave = :cla');
      dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
      dm.Query1.Open;
      if dm.Query1.RecordCount = 0 then
      begin
        MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
        edproducto.SetFocus;
      end
      else
      begin
        Prec := InputBox('Precio','Precio','');
        if trim(Prec) <> '' then
        begin
          Precio := StrToFloat(Prec);
          UltProd := edproducto.Text;
          InsertaProducto;
        end
        else
          edproducto.Text := '';
      end;
      edproducto.SetFocus;
    end;
    key := #0;
  end;       }
 { end;
end
else
begin
 if ((key = #13) and  (Sender = edproducto)) then
  begin
    Precio := 0;
    BuscaProducto(edproducto.Text);
    if trim(edproducto.Text) = '' then edproducto.Text := 'VARIOS';
     //Prec := InputBox('Precio','Precio','');
        if trim(Prec) <> '' then
        begin
          Precio := StrToFloat(Prec);
          UltProd := edproducto.Text;
          if MDLista.RecordCount >  0 then begin
          if ((MDLista.Locate('LProducto',IntToStr(GetProducto),[])) and
          (dm.QParametrosPAR_FACREPITEPROD.Value = 'False')) then
          begin
          //MessageDlg('ESTE PRODUCTO ESTA INCLUIDO EN ESTA FACTURA',mtError,[mbok],0);
            qDetalle.Locate('Producto',IntToStr(GetProducto),[]);
            qDetalle.Edit;
            qDetallecantidad.Value := qDetallecantidad.Value + 1;
            qDetalle.Post;
            qDetalle.UpdateBatch;
            //Abort;
          end
          else
          begin
          InsertaProducto;
          end;
          end
          else
          InsertaProducto;
        end
        else
        edproducto.Text := '';
      if MDLista.RecordCount >  0 then begin
          if ((MDLista.Locate('LProducto',IntToStr(GetProducto),[])) and
          (dm.QParametrosPAR_FACREPITEPROD.Value = 'False')) then
          begin
          //MessageDlg('ESTE PRODUCTO ESTA INCLUIDO EN ESTA FACTURA',mtError,[mbok],0);
            qDetalle.Locate('Producto',IntToStr(GetProducto),[]);
            qDetalle.Edit;
            qDetallecantidad.Value := qDetallecantidad.Value + 1;
            qDetalle.Post;
            qDetalle.UpdateBatch;
            //Abort;
          end
          else
          begin
          InsertaProducto;
          end;
          end
          else
          InsertaProducto;
end;
end;

  if key = #27 then
  begin
    edcantidad.SetFocus;
    key := #0;
  end;
end;
 }



procedure TfrmMain.DBGrid1Enter(Sender: TObject);
begin
//  if primercampo = 'P' then
//    edproducto.SetFocus;
end;

procedure TfrmMain.pnclienteClick(Sender: TObject);
begin
  btBuscaCliClick(nil);

 (*  Application.CreateForm(tfrmSeleccionCliente, frmSeleccionCliente);
  frmSeleccionCliente.ShowModal;
  if frmSeleccionCliente.Seleccion = 1 then
  begin
   //OJO  edcliente.Caption := frmSeleccionCliente.edcliente.Text;
    if frmSeleccionCliente.Tipo = 'CRE' then
    begin                                                                        
      Aumento := frmSeleccionCliente.QClientesAumento.Value;
      SeleccionTipo := frmSeleccionCliente.Tipo;
      SeleccionCliente := frmSeleccionCliente.QClientescli_codigo.Value;
      SeleccionEmpresa := frmSeleccionCliente.QClientesemp_codigo.Value;
    end
    else if frmSeleccionCliente.Tipo = 'CON' then
    begin                                                                        
      Aumento := 0;
      SeleccionTipo := frmSeleccionCliente.Tipo;
      NombreCliente := frmSeleccioncliente.edcliente.Text;
      if frmSeleccioncliente.QClientes.Active then
        cliente := frmSeleccioncliente.QClientescli_codigo.Value;
      if QTicket.RecordCount > 0 then
      begin
        QTicket.Edit;
        QTicketnombre.Value := NombreCliente;
        QTicket.Post;
      end;
    end;
  end;
  frmSeleccionCliente.Release; *)
end;



procedure TfrmMain.pnefectivoClick(Sender: TObject);
var
  ncf_fijo : string;
begin
//VerificarVentasInespre;
//VerificarMasUnCombo;


  if Producto_sin_Serializar(EmptyStr) then
     begin
      ShowMessage('HAY PRODUCTOS SERIALIZADOS SIN SERIALIZAR, Verifique...');
      Exit;
     end;
  totaliza;
  AplicaDescPorRangoVta(QTickettotal.Value);

  if QTickettotal.Value <= 0 then
    begin
      MessageDlg('NO HAY MONTO QUE COBRAR, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      edproducto.SetFocus;
    end
  else
    begin
      if (TipoComprobante <> 1) and (Trim(QTicketrnc.Value) = '') then
        begin
         MessageDlg('DEBE DIGITAR EL RNC, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
         dbRnc.SetFocus;
        end
      else
        begin
          Application.CreateForm(tfrmEfectivo, frmEfectivo);


      TipoComprobante := QTickettip_codigo.Value;

      //buscando la empresa que tiene la caja en ese momento
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select emp_codigo from cajas_ip where ip = :ip ');
        dm.Query1.Parameters.ParamByName('ip').Value := IPCaja;
        dm.Query1.Open;
        empcomprobante := dm.Query1.FieldByName('emp_codigo').Value;


      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select top 1 cli_codigo from cliente_club');
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
        tarjetaclub := InputBox('TARJETA CLUB','TARJETA CLUB','');

      if tarjetaclub <> '' then
      begin
        dm.query1.close;
        dm.query1.sql.clear;
        dm.query1.sql.add('select cli_nombre, cli_apellido, cli_balance_ptos');
        dm.query1.sql.add('from Cliente_Club');
        dm.query1.sql.add('Where cli_carnet_club = :tar');
        dm.query1.Parameters.ParamByName('tar').Value := Trim(tarjetaclub);
        dm.query1.Open;
        if dm.query1.RecordCount > 0 then
        begin
          frmEfectivo.lbTarjeta.caption := dm.query1.fieldbyname('cli_nombre').asstring+' '+
                                            dm.query1.fieldbyname('cli_apellido').asstring+#13+
                                            'Puntos : ' + Format('%10.2F',[dm.query1.fieldbyname('cli_balance_ptos').AsFloat]);
        end;
      end;

      frmEfectivo.lbtotal.Caption := lbtotal.Caption;
      frmEfectivo.total := Qtickettotal.value;
      frmEfectivo.lbsubtotal.Caption := format('%n',[Qtickettotal.value]);

      //eliminando notas de credito colocadas
      {dm.query1.close;
      dm.query1.sql.clear;
      dm.query1.sql.add('delete from formas_pago_ticket');
      dm.query1.sql.add('where caja = :caj');
      dm.query1.sql.add('and usu_codigo = :usu');
      dm.query1.sql.add('and fecha = convert(datetime, :fec, 105)');
      dm.query1.sql.add('and ticket = :tik');
      dm.query1.Parameters.ParamByName('fec').DataType := ftDate;
      dm.query1.Parameters.ParamByName('fec').Value    := Date;
      dm.query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      dm.query1.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
      dm.query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
      dm.query1.ExecSQL;}
      //************

      //buscando devolucion
      application.CreateForm(tfrmDevoluciones, frmDevoluciones);
      frmEfectivo.devolucion := 0;
      if QFormaPago.Active then
      begin
        QFormaPago.First;
        while not QFormaPago.Eof do
        begin
          if QFormaPagoforma.Value = 'DEV' then
            frmEfectivo.devolucion := frmEfectivo.devolucion + QFormaPagopagado.Value;
          QFormaPago.Next;
        end;
        QFormaPago.First;
      end;
      frmDevoluciones.Release;
      frmEfectivo.lbdevolucion.Caption := format('%n',[frmEfectivo.devolucion]);
      frmEfectivo.lbsubtotal.Caption := format('%n',[frmEfectivo.total-frmEfectivo.devolucion]);

      frmEfectivo.ShowModal;
      if (frmEfectivo.Facturo = 1) and (frmEfectivo.edrecibido.Text <> '') then
      begin
        Boletos;
        QTicket.Edit;
        QTicketBoletos.Value  := CantBoletos;
        QTicketNCF_Tipo.Value := TipoComprobante;
        QTicketstatus.Value   := 'FAC';
        if tarjetaclub <> '' then
          QTicketsorteo.Value := tarjetaclub;

        ProcNCF.Parameters[4].Value := null;
        ProcNCF.Parameters[5].Value := null;

         //buscando la empresa que tiene la caja en ese momento
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select emp_codigo from cajas_ip where ip = :ip ');
        dm.Query1.Parameters.ParamByName('ip').Value := IPCaja;
        dm.Query1.Open;
        empcomprobante := dm.Query1.FieldByName('emp_codigo').Value;

        if TipoComprobante = 1 then
        begin
          {//Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj ');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select NCF_Fijo, NCF_Secuencia from ncf_ticket with (HOLDLOCK)');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.Open;

            if not Query1.FieldByName('NCF_Fijo').IsNull then
            begin
              QTicketNCF_Fijo.Value      := Query1.FieldByName('NCF_Fijo').Value;
              QTicketNCF_Secuencia.Value := Query1.FieldByName('NCF_Secuencia').Value;
            end;
          end
          else
          begin }
            ProcNCF.Close;
            ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
            ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
            ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
            ProcNCF.ExecProc;

            if ProcNCF.Parameters[4].Value <> null then
            begin
              QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
              QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
            end;

        end
        else
        begin
          ProcNCF.Close;
          ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
          ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
          ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
          ProcNCF.ExecProc;

          if not VarIsNull(ProcNCF.Parameters[4].Value) then
          begin
            QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
            QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
          end;

        end;

        if QTicket.State in [dsinsert, dsedit] then begin
        QTicket.Post;
       QTicket.UpdateBatch;
       end;

//Serie fernando
if not QSerie.IsEmpty then
with dm.QQuery,sql do
begin
  Close;
  Clear;
  Add('delete from TicSerie');
  Add('where ticket = :tik');
  Add(' ');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('update #TicSerie set ');
  Add('ticket = :tik');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('insert into TicSerie (ser_secuencia,ticket,producto,ser_numero,tic_secuencia) ');
  Add(' select ser_secuencia,ticket,producto,ser_numero,tic_secuencia from #TicSerie ');
  ExecSQL;
end;
//fin serie

        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;

        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
        QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QFormaPago.Open;

        if frmEfectivo.edrecibido.Text <> '' then begin
        QFormaPago.Append;
        QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
        QFormaPagousu_codigo.Value := dm.Usuario;
        QFormaPagofecha.Value      := DM.getFechaServidor;
        QFormaPagoticket.Value     := QTicketticket.Value;
        QFormaPagoforma.Value      := 'EFE';
        QFormaPagopagado.Value     := StrToFloat(frmEfectivo.edrecibido.Text);
        QFormaPagodevuelta.Value   := (StrToFloat(frmEfectivo.edrecibido.Text) + frmEfectivo.devolucion) - QTickettotal.Value;
        QFormaPagocredito.Value    := 'False';
        if cliente > 0 then QFormaPagocliente.Value    := cliente;
        QFormaPago.Post;
        QFormaPago.UpdateBatch;

        MPagado := (StrToFloat(frmEfectivo.edrecibido.Text) + frmEfectivo.devolucion);


        if TipoComprobante = 1 then
        begin
          //Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('update ncf_ticket set NCF_Secuencia = NCF_Secuencia + 1');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.ExecSQL;
          end;
        end;

        LPagado := 'EFE';

        if Trim(tarjetaclub) <> '' then
        begin
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('EXECUTE PR_ACUMULA_PUNTOS :emp, :TARJETA, :MONTO');
          Query1.Parameters.ParamByName('emp').Value     := 1;
          Query1.Parameters.ParamByName('tarjeta').Value := tarjetaclub;
          Query1.Parameters.parambyname('monto').Value   := QTickettotal.Value;
          Query1.ExecSQL;
        end;

        if Puerto2 = 'E'  then
        pnabrircaja2;
        if Puerto2 = 'T'  then
        pnabrircaja2;

        Application.CreateForm(tfrmDevuelta, frmDevuelta);
        frmDevuelta.recibido := StrToFloat(frmEfectivo.edrecibido.Text);
        frmDevuelta.devuelta := (StrToFloat(frmEfectivo.edrecibido.Text)+frmEfectivo.devolucion) - QTickettotal.Value;
        frmDevuelta.lbdevuelta.Caption := Format('%n',[(StrToFloat(frmEfectivo.edrecibido.Text)+frmEfectivo.devolucion) - QTickettotal.Value]);

        frmDevuelta.ShowModal;
        frmDevuelta.Release;
        end;




        if Impresora.IDPrinter >  0 then
        ImprimeTicketFiscal(Impresora) else
        begin
        if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;
        end;

        if Reimprimiendo = 'N' then
        ImpTicketRifa;

        if Reimprimiendo = 'N' then
        begin
        if Credito = 'True' then
        begin
           MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);
           //dm.Imp40Columnas(arch);
           winexec('imp.bat',0);
        end;
      end;


      frmEfectivo.Release;

        TicketNuevo(true);
        IniciaDisplay;
        edproducto.SetFocus();

      end;
      end;

     end;

 // end;

end;

procedure TfrmMain.TicketNuevo(const default:boolean = false);
begin
if default then
    setValoresDefault();

  ProcNCF.Parameters[4].Value := null;
  ProcNCF.Parameters[5].Value := null;

  edticket.Caption := IntToStr(getNextTicket(StrToInt(edcaja.Caption),forma_numeracion));

  QTicket.Close;
  if forma_numeracion = 1 then
  begin
    QTicket.SQL.Clear;
    QTicket.SQL.Add(SQLFormaNumeracion1);
    QTicket.Parameters.ParamByName('fec').DataType := ftDate;
    QTicket.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
    QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
  end;

  QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
  QTicket.Parameters.ParamByName('tik').Value    := StrToInt(edticket.Caption);
  QTicket.Open;
  QTicket.Append;

  QDetalle.Close;
  if forma_numeracion = 1 then
  begin
    QDetalle.SQL.Clear;
    QDetalle.SQL.Add('select usu_codigo, fecha, ticket, secuencia,');
    QDetalle.SQL.Add('hora, producto, descripcion, cantidad, precio,');
    QDetalle.SQL.Add('empaque, itbis, Costo, caja, descuento,');
    QDetalle.SQL.Add('devuelta, Realizo_Oferta, Oferta,');
    QDetalle.SQL.Add('Patrocinador, fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo,');
    QDetalle.SQL.Add('col_codigo, mar_codigo, suc_codigo, emp_codigo');
    QDetalle.SQL.Add('from ticket');
    QDetalle.SQL.Add('where caja = :caj');
    QDetalle.SQL.Add('and ticket = :tik');
    QDetalle.SQL.Add('and fecha = convert(datetime, :fec, 105)');
    QDetalle.SQL.Add('and usu_codigo = :usu');
    QDetalle.SQL.Add('order by secuencia desc');
    QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
    QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
    QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
  end;
  QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
  QDetalle.Parameters.ParamByName('tik').Value    := StrToInt(edticket.Caption); //Query1.FieldByName('maximo').AsInteger;
  QDetalle.Open;

  QFormaPago.Close;
  if forma_numeracion = 1 then
  begin
    QFormaPago.SQL.Clear;
    QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
    QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento, suc_codigo, emp_codigo');
    QFormaPago.SQL.Add('from formas_pago_ticket');
    QFormaPago.SQL.Add('where caja = :caj');
    QFormaPago.SQL.Add('and ticket = :tik');
    QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
    QFormaPago.SQL.Add('and usu_codigo = :usu');
    QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
    QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
    QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
  end;
  QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
  QFormaPago.Parameters.ParamByName('tik').Value    := StrToInt(edticket.Caption); //Query1.FieldByName('maximo').AsInteger;
  QFormaPago.Open;

  //IniciaDisplay;
end;

procedure TfrmMain.pntarjetaClick(Sender: TObject);
var
  ncf : integer;
  ncf_fijo : string;
begin
//VerificarVentasInespre;
//VerificarMasUnCombo;

  if Producto_sin_Serializar(EmptyStr) then
     begin
      ShowMessage('HAY PRODUCTOS SERIALIZADOS SIN SERIALIZAR, Verifique...');
      Exit;
     end;
  totaliza;
  AplicaDescPorRangoVta(QTickettotal.Value);

  if QTickettotal.Value <= 0 then
  begin
    MessageDlg('NO HAY MONTO QUE COBRAR, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    if (TipoComprobante <> 1) and (Trim(QTicketrnc.Value) = '') then
    begin
      MessageDlg('DEBE DIGITAR EL RNC, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      dbRnc.SetFocus;
    end
    else
    begin

      TipoComprobante := QTickettip_codigo.Value;

      Application.CreateForm(tfrmTarjeta, frmTarjeta);

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select top 1 cli_codigo from cliente_club');
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
        tarjetaclub := InputBox('TARJETA CLUB','TARJETA CLUB','');

      if tarjetaclub <> '' then
      begin
        dm.query1.close;
        dm.query1.sql.clear;
        dm.query1.sql.add('select cli_nombre, cli_apellido, cli_balance_ptos');
        dm.query1.sql.add('from Cliente_Club');
        dm.query1.sql.add('Where cli_carnet_club = :tar');
        dm.query1.Parameters.ParamByName('tar').Value := Trim(tarjetaclub);
        dm.query1.Open;
        if dm.query1.RecordCount > 0 then
        begin
          frmTarjeta.lbTarjeta.caption := dm.query1.fieldbyname('cli_nombre').asstring+' '+
                                            dm.query1.fieldbyname('cli_apellido').asstring+#13+
                                            'Puntos : ' + Format('%10.2F',[dm.query1.fieldbyname('cli_balance_ptos').AsFloat]);

        end;
      end;

      frmTarjeta.lbtotal.Caption := FormatFloat(',,,0.00',Qtickettotal.value); // lbtotal.Caption;
      frmTarjeta.lbitbis.Caption := lbitbis.Caption;
      frmTarjeta.total := Qtickettotal.value;

      //eliminando notas de credito colocadas
      {dm.query1.close;
      dm.query1.sql.clear;
      dm.query1.sql.add('delete from formas_pago_ticket');
      dm.query1.sql.add('where caja = :caj');
      dm.query1.sql.add('and usu_codigo = :usu');
      dm.query1.sql.add('and fecha = convert(datetime, :fec, 105)');
      dm.query1.sql.add('and ticket = :tik');
      dm.query1.Parameters.ParamByName('fec').DataType := ftDate;
      dm.query1.Parameters.ParamByName('fec').Value    := Date;
      dm.query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      dm.query1.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
      dm.query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
      dm.query1.ExecSQL;}
      //************

      //buscando devolucion
      application.CreateForm(tfrmDevoluciones, frmDevoluciones);
      frmTarjeta.devolucion := 0;
      if QFormaPago.Active then
      begin
        QFormaPago.First;
        while not QFormaPago.Eof do
        begin
          if QFormaPagoforma.Value = 'DEV' then
            frmTarjeta.devolucion := frmTarjeta.devolucion + QFormaPagopagado.Value;
          QFormaPago.Next;
        end;
        QFormaPago.First;
      end;
      frmDevoluciones.Release;
      frmTarjeta.lbdevolucion.Caption := format('%n',[frmTarjeta.devolucion]);
      frmTarjeta.lbsubtotal.Caption := format('%n',[frmTarjeta.total-frmTarjeta.devolucion]);
      
      frmTarjeta.edMonto.text := FloatToStr (frmTarjeta.total-frmTarjeta.devolucion);

      frmTarjeta.ShowModal;
      if (frmTarjeta.Facturo = 1) and (frmTarjeta.edMonto.Text <> '') then
      begin
        Boletos;
        QTicket.Edit;
        QTicketBoletos.Value  := CantBoletos;
        QTicketNCF_Tipo.Value := TipoComprobante;
        QTicketstatus.Value := 'FAC';
        if tarjetaclub <> '' then
          QTicketsorteo.Value := tarjetaclub;

        ProcNCF.Parameters[4].Value := null;
        ProcNCF.Parameters[5].Value := null;

         //buscando la empresa que tiene la caja en ese momento
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select emp_codigo from cajas_ip where ip = :ip ');
        dm.Query1.Parameters.ParamByName('ip').Value := IPCaja;
        dm.Query1.Open;
        empcomprobante := dm.Query1.FieldByName('emp_codigo').Value;

        if TipoComprobante = 1 then
        begin
          {//Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj ');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select NCF_Fijo, NCF_Secuencia from ncf_ticket with (HOLDLOCK)');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.Open;

            if not Query1.FieldByName('NCF_Fijo').IsNull then
            begin
              QTicketNCF_Fijo.Value      := Query1.FieldByName('NCF_Fijo').Value;
              QTicketNCF_Secuencia.Value := Query1.FieldByName('NCF_Secuencia').Value;
            end;
          end
          else
          begin }
            ProcNCF.Close;
            ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
            ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
            ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
            ProcNCF.ExecProc;

            if ProcNCF.Parameters[4].Value <> null then
            begin
              QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
              QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
            end;

        end
        else
        begin
          ProcNCF.Close;
          ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
          ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
          ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
          ProcNCF.ExecProc;

          if not VarIsNull(ProcNCF.Parameters[4].Value) then
          begin
            QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
            QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
          end;

        end;

        if QTicket.State in [dsEdit, dsInsert] then begin
        QTicket.Post;
        QTicket.UpdateBatch;
        end;




        //Serie fernando
if not QSerie.IsEmpty then
with dm.QQuery,sql do
begin
  Close;
  Clear;
  Add('delete from TicSerie');
  Add('where ticket = :tik');
  Add(' ');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('update #TicSerie set ');
  Add('ticket = :tik');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('insert into TicSerie (ser_secuencia,ticket,producto,ser_numero,tic_secuencia) ');
  Add(' select ser_secuencia,ticket,producto,ser_numero,tic_secuencia from #TicSerie ');
  ExecSQL;
end;
//fin serie

        if TipoComprobante = 1 then
        begin
          //Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('update ncf_ticket set NCF_Secuencia = NCF_Secuencia + 1');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.ExecSQL;
          end;
        end;

        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QFormaPago.Open;

        QFormaPago.Append;
        QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
        QFormaPagousu_codigo.Value := dm.Usuario;
        QFormaPagofecha.Value      := DM.getFechaServidor;
        QFormaPagoticket.Value     := QTicketticket.Value;
        QFormaPagoforma.Value      := 'TAR';
        QFormaPagopagado.Value     := StrToFloat(frmTarjeta.edMonto.Text);
        QFormaPagodevuelta.Value   := 0;
        QFormaPagocredito.Value    := 'False';
        if cliente > 0 then QFormaPagocliente.Value    := cliente;
        QFormaPagodocumento.Value  := frmTarjeta.edtarjeta.Text;
        if vl_respverifone <> '' THEN
        QFormaPagofor_veriphone_desc.Value  := vl_respverifone;
        QFormaPago.Post;
        QFormaPago.UpdateBatch;

        MPagado := QTickettotal.Value;

        LPagado := 'TAR';

        if Trim(tarjetaclub) <> '' then
        begin
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('EXECUTE PR_ACUMULA_PUNTOS :emp, :TARJETA, :MONTO');
          Query1.Parameters.ParamByName('emp').Value     := 1;
          Query1.Parameters.ParamByName('tarjeta').Value := tarjetaclub;
          Query1.Parameters.parambyname('monto').Value   := QTickettotal.Value;
          Query1.ExecSQL;
        end;

         if Impresora.IDPrinter >  0 then
        ImprimeTicketFiscal(Impresora) else
        begin
        if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;
        end;

  //    if Length(vl_respverifone)> 180 then begin
  //    if Impresora.IDPrinter = 0 then ImpTicketCardNet;

  //    CASE Impresora.IDPrinter OF
   //                     1 : {EPSON (TMU-220)}      ImpTicketFiscalCardNet(impresora.copia);
		 //						        2 : {CITIZEN ( CT-S310 )}  ImpTicketVmaxFiscalCardNet(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
			 //					        3 : {CITIZEN (GSX-190)}    ImpTicketVmaxFiscalCardNet(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
         //               4 : {STAR (TSP650FP)}      ImpTicketVmaxFiscalCardNet(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
           //             //5 : {Bixolon SRP-350iiHG}  ImpTicketFiscalBixolon(Impresora);
      //end;
      //end;}

        if Reimprimiendo = 'N' then
        ImpTicketRifa;

        if Reimprimiendo = 'N' then
        begin
        if Credito = 'True' then
        begin
           MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);
           //dm.Imp40Columnas(arch);
           winexec('imp.bat',0);
        end;
      end;


      if Puerto2 = 'T'  then
      pnabrircaja2;


        //ImpTicketFiscal;
        //ImpTicketNorma201806;
        TicketNuevo(true);
        IniciaDisplay;
        edproducto.SetFocus();
      end;
      frmTarjeta.Release;
    end;
  end;
  end;
//end;

procedure TfrmMain.pnchequeClick(Sender: TObject);
var
  ncf : integer;
  ncf_fijo : string;
begin
//VerificarVentasInespre;
//VerificarMasUnCombo;

  if Producto_sin_Serializar(EmptyStr) then
     begin
      ShowMessage('HAY PRODUCTOS SERIALIZADOS SIN SERIALIZAR, Verifique...');
      Exit;
     end;
  totaliza;
  AplicaDescPorRangoVta(QTickettotal.Value);

  if QTickettotal.Value <= 0 then
  begin
    MessageDlg('NO HAY MONTO QUE COBRAR, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    if (TipoComprobante <> 1) and (Trim(QTicketrnc.Value) = '') then
    begin
      MessageDlg('DEBE DIGITAR EL RNC, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      dbRnc.SetFocus;
    end
    else
    begin
      Application.CreateForm(tfrmCheque, frmCheque);

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select top 1 cli_codigo from cliente_club');
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
        tarjetaclub := InputBox('TARJETA CLUB','TARJETA CLUB','');

      if tarjetaclub <> '' then
      begin
        dm.query1.close;
        dm.query1.sql.clear;
        dm.query1.sql.add('select cli_nombre, cli_apellido, cli_balance_ptos');
        dm.query1.sql.add('from Cliente_Club');
        dm.query1.sql.add('Where cli_carnet_club = :tar');
        dm.query1.Parameters.ParamByName('tar').Value := Trim(tarjetaclub);
        dm.query1.Open;
        if dm.query1.RecordCount > 0 then
        begin
          frmCheque.lbTarjeta.caption := dm.query1.fieldbyname('cli_nombre').asstring+' '+
                                            dm.query1.fieldbyname('cli_apellido').asstring+#13+
                                            'Puntos : ' + Format('%10.2F',[dm.query1.fieldbyname('cli_balance_ptos').AsFloat]);

        end;
      end;

      frmCheque.lbtotal.Caption := lbtotal.Caption;
      frmCheque.total := Qtickettotal.value;

      //eliminando notas de credito colocadas
      {dm.query1.close;
      dm.query1.sql.clear;
      dm.query1.sql.add('delete from formas_pago_ticket');
      dm.query1.sql.add('where caja = :caj');
      dm.query1.sql.add('and usu_codigo = :usu');
      dm.query1.sql.add('and fecha = convert(datetime, :fec, 105)');
      dm.query1.sql.add('and ticket = :tik');
      dm.query1.Parameters.ParamByName('fec').DataType := ftDate;
      dm.query1.Parameters.ParamByName('fec').Value    := Date;
      dm.query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      dm.query1.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
      dm.query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
      dm.query1.ExecSQL;}
      //************

      //buscando devolucion
      application.CreateForm(tfrmDevoluciones, frmDevoluciones);
      frmCheque.devolucion := 0;
      if QFormaPago.Active then
      begin
        QFormaPago.First;
        while not QFormaPago.Eof do
        begin
          if QFormaPagoforma.Value = 'DEV' then
            frmCheque.devolucion := frmCheque.devolucion + QFormaPagopagado.Value;
          QFormaPago.Next;
        end;
        QFormaPago.First;
      end;
      frmDevoluciones.Release;
      frmCheque.lbdevolucion.Caption := format('%n',[frmCheque.devolucion]);
      frmCheque.lbsubtotal.Caption := format('%n',[frmCheque.total-frmCheque.devolucion]);

      frmCheque.ShowModal;
      if (frmCheque.Facturo = 1) and (frmCheque.edMonto.Text <> '') then
      begin
        Boletos;
        QTicket.Edit;
        QTicketBoletos.Value  := CantBoletos;
        QTicketNCF_Tipo.Value := TipoComprobante;
        QTicketstatus.Value := 'FAC';
        if tarjetaclub <> '' then
          QTicketsorteo.Value := tarjetaclub;

        ProcNCF.Parameters[4].Value := null;
        ProcNCF.Parameters[5].Value := null;

         //buscando la empresa que tiene la caja en ese momento
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select emp_codigo from cajas_ip where ip = :ip ');
        dm.Query1.Parameters.ParamByName('ip').Value := IPCaja;
        dm.Query1.Open;
        empcomprobante := dm.Query1.FieldByName('emp_codigo').Value;

        if TipoComprobante = 1 then
        begin
          {//Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj ');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select NCF_Fijo, NCF_Secuencia from ncf_ticket with (HOLDLOCK)');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.Open;

            if not Query1.FieldByName('NCF_Fijo').IsNull then
            begin
              QTicketNCF_Fijo.Value      := Query1.FieldByName('NCF_Fijo').Value;
              QTicketNCF_Secuencia.Value := Query1.FieldByName('NCF_Secuencia').Value;
            end;
          end
          else
          begin }
            ProcNCF.Close;
            ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
            ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
            ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
            ProcNCF.ExecProc;

            if ProcNCF.Parameters[4].Value <> null then
            begin
              QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
              QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
            end;

        end
        else
        begin
          ProcNCF.Close;
          ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
          ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
          ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
          ProcNCF.ExecProc;

          if not VarIsNull(ProcNCF.Parameters[4].Value) then
          begin
            QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
            QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
          end;

        end;

        if QTicket.State in [dsEdit, dsInsert] then begin
        QTicket.Post;
        QTicket.UpdateBatch;
        end;
        
//Serie fernando
if not QSerie.IsEmpty then
with dm.QQuery,sql do
begin
  Close;
  Clear;
  Add('delete from TicSerie');
  Add('where ticket = :tik');
  Add(' ');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('update #TicSerie set ');
  Add('ticket = :tik');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('insert into TicSerie (ser_secuencia,ticket,producto,ser_numero,tic_secuencia) ');
  Add(' select ser_secuencia,ticket,producto,ser_numero,tic_secuencia from #TicSerie ');
  ExecSQL;
end;
//fin serie

        if TipoComprobante = 1 then
        begin
          //Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('update ncf_ticket set NCF_Secuencia = NCF_Secuencia + 1');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.ExecSQL;
          end;
        end;
      
        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QFormaPago.Open;

        QFormaPago.Append;
        QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
        QFormaPagousu_codigo.Value := dm.Usuario;
        QFormaPagofecha.Value      := DM.getFechaServidor;
        QFormaPagoticket.Value     := QTicketticket.Value;
        QFormaPagoforma.Value      := 'CHE';
        QFormaPagopagado.Value     := StrToFloat(frmCheque.edMonto.Text);
        QFormaPagodevuelta.Value   := (StrToFloat(frmCheque.edMonto.Text) + frmCheque.devolucion) - QTickettotal.Value;
        QFormaPagocredito.Value    := 'False';
        if cliente > 0 then QFormaPagocliente.Value    := cliente;
        QFormaPagodocumento.Value  := frmCheque.edcheque.Text;
        QFormaPago.Post;
        QFormaPago.UpdateBatch;

        MPagado := StrToFloat(frmCheque.edMonto.Text);

        LPagado := 'CHE';

        if Trim(tarjetaclub) <> '' then
        begin
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('EXECUTE PR_ACUMULA_PUNTOS :emp, :TARJETA, :MONTO');
          Query1.Parameters.ParamByName('emp').Value     := 1;
          Query1.Parameters.ParamByName('tarjeta').Value := tarjetaclub;
          Query1.Parameters.parambyname('monto').Value   := QTickettotal.Value;
          Query1.ExecSQL;
        end;

        //pnabrircajaClick(Self);

        if Puerto2 = 'T'  then
        pnabrircaja2;

        Application.CreateForm(tfrmDevuelta, frmDevuelta);
        frmDevuelta.recibido := StrToFloat(frmCheque.edMonto.Text);
        frmDevuelta.devuelta := (StrToFloat(frmCheque.edMonto.Text) + frmCheque.devolucion) - QTickettotal.Value;
        frmDevuelta.lbdevuelta.Caption := Format('%n',[(StrToFloat(frmCheque.edMonto.Text) + frmCheque.devolucion) - QTickettotal.Value]);

        frmDevuelta.ShowModal;
        frmDevuelta.Release;

         if Impresora.IDPrinter >  0 then
        ImprimeTicketFiscal(Impresora) else
        begin
        if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;
        end;




        if Reimprimiendo = 'N' then
        ImpTicketRifa;

        if Reimprimiendo = 'N' then
        begin
        if Credito = 'True' then
        begin
           MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);
           //dm.Imp40Columnas(arch);
           winexec('imp.bat',0);
        end;
      end;


      if Puerto2 = 'T'  then
      pnabrircaja2;


        //ImpTicketNorma201806;
        TicketNuevo(true);
        IniciaDisplay;
        edproducto.SetFocus();
      end;
      frmCheque.Release;
    end;
  end;
  end;
//end;

procedure TfrmMain.pncombinadoClick(Sender: TObject);
var
  ncf: integer;
  ncf_fijo : string;
  MDevuelta : double;
  num, diasvence, periodo, sec, descuentocxc : integer;
  vence : tdatetime;
  ano, mes, dia : word;
begin
//VerificarVentasInespre;
//VerificarMasUnCombo;

  if Producto_sin_Serializar(EmptyStr) then
     begin
      ShowMessage('HAY PRODUCTOS SERIALIZADOS SIN SERIALIZAR, Verifique...');
      Exit;
     end;
  totaliza;
  AplicaDescPorRangoVta(QTickettotal.Value);

  if QTickettotal.Value <= 0 then
  begin
    MessageDlg('NO HAY MONTO QUE COBRAR, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    if (TipoComprobante <> 1) and (Trim(QTicketrnc.Value) = '') then
    begin
      MessageDlg('DEBE DIGITAR EL RNC, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      dbRnc.SetFocus;
    end
    else
    begin
      Application.CreateForm(tfrmCombinado, frmCombinado);

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select top 1 cli_codigo from cliente_club');
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
        tarjetaclub := InputBox('TARJETA CLUB','TARJETA CLUB','');

      if tarjetaclub <> '' then
      begin
        dm.query1.close;
        dm.query1.sql.clear;
        dm.query1.sql.add('select cli_nombre, cli_apellido, cli_balance_ptos');
        dm.query1.sql.add('from Cliente_Club');
        dm.query1.sql.add('Where cli_carnet_club = :tar');
        dm.query1.Parameters.ParamByName('tar').Value := Trim(tarjetaclub);
        dm.query1.Open;
        if dm.query1.RecordCount > 0 then
        begin
          frmCombinado.lbTarjeta.caption := dm.query1.fieldbyname('cli_nombre').asstring+' '+
                                            dm.query1.fieldbyname('cli_apellido').asstring+#13+
                                            'Puntos : ' + Format('%10.2F',[dm.query1.fieldbyname('cli_balance_ptos').AsFloat]);
        end;
      end;

      frmCombinado.Total := QTickettotal.Value;
      frmCombinado.lbtotal.Caption := lbtotal.Caption;
      frmCombinado.lbitbis.Caption := lbitbis.Caption;
      frmCombinado.ShowModal;
      if (frmCombinado.Facturo = 1) and (frmCombinado.lbpendiente.Caption = '0.00') then 
      begin
        Boletos;
        QTicket.Edit;
        QTicketBoletos.Value  := CantBoletos;
        QTicketNCF_Tipo.Value := TipoComprobante;
        QTicketstatus.Value := 'FAC';
        if tarjetaclub <> '' then
          QTicketsorteo.Value := tarjetaclub;

        ProcNCF.Parameters[4].Value := null;
        ProcNCF.Parameters[5].Value := null;

         //buscando la empresa que tiene la caja en ese momento
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select emp_codigo from cajas_ip where ip = :ip ');
        dm.Query1.Parameters.ParamByName('ip').Value := IPCaja;
        dm.Query1.Open;
        empcomprobante := dm.Query1.FieldByName('emp_codigo').Value;

        if TipoComprobante = 1 then
        begin
          {//Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj ');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select NCF_Fijo, NCF_Secuencia from ncf_ticket with (HOLDLOCK)');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.Open;

            if not Query1.FieldByName('NCF_Fijo').IsNull then
            begin
              QTicketNCF_Fijo.Value      := Query1.FieldByName('NCF_Fijo').Value;
              QTicketNCF_Secuencia.Value := Query1.FieldByName('NCF_Secuencia').Value;
            end;
          end
          else
          begin }
            ProcNCF.Close;
            ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
            ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
            ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
            ProcNCF.ExecProc;

            if ProcNCF.Parameters[4].Value <> null then
            begin
              QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
              QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
            end;

        end
        else
        begin
          ProcNCF.Close;
          ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
          ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
          ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
          ProcNCF.ExecProc;

          if not VarIsNull(ProcNCF.Parameters[4].Value) then
          begin
            QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
            QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
          end;

        end;


        if QTicket.State in [dsEdit, dsInsert] then begin
        QTicket.Post;
        QTicket.UpdateBatch;
        end;

//Serie fernando
if not QSerie.IsEmpty then
with dm.QQuery,sql do
begin
  Close;
  Clear;
  Add('delete from TicSerie');
  Add('where ticket = :tik');
  Add(' ');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('update #TicSerie set ');
  Add('ticket = :tik');
  Parameters.ParamByName('tik').Value := QTicketticket.Value;
  ExecSQL;
  Close;
  Clear;
  Add('insert into TicSerie (ser_secuencia,ticket,producto,ser_numero,tic_secuencia) ');
  Add(' select ser_secuencia,ticket,producto,ser_numero,tic_secuencia from #TicSerie ');
  ExecSQL;
end;
//fin serie
        
        if TipoComprobante = 1 then
        begin
          //Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('update ncf_ticket set NCF_Secuencia = NCF_Secuencia + 1');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.ExecSQL;
          end;
        end;

        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.SQL.Add('order by forma desc');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QFormaPago.Open;

        {MPagado := StrToFloat(frmCombinado.edrecibido.Text) + StrToFloat(frmCombinado.edtarjeta.Text) +
                   StrToFloat(frmCombinado.edcheque.Text) + StrToFloat(frmCombinado.edBonoClub.Text) +
                   StrToFloat(frmCombinado.edBonoOtro.Text) + StrToFloat(frmCombinado.edCredito.Text);}

        MPagado := frmCombinado.edrecibido.Value + frmCombinado.edtarjeta.Value +
                   frmCombinado.edcheque.Value   + frmCombinado.edBonoClub.Value +
                   frmCombinado.edBonoOtro.Value + frmCombinado.edCredito.Value;

        MDevuelta := MPagado - QTickettotal.Value;

        if frmCombinado.edtarjeta.Value <> 0 then
        begin
          LPagado := LPagado + ',TAR';
          QFormaPago.Append;
          QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
          QFormaPagousu_codigo.Value := dm.Usuario;
          QFormaPagofecha.Value      := DM.getFechaServidor;
          QFormaPagoticket.Value     := QTicketticket.Value;
          QFormaPagoforma.Value      := 'TAR';
          QFormaPagopagado.Value     := frmCombinado.edtarjeta.Value;
          if cliente > 0 then QFormaPagocliente.Value    := cliente;
          QFormaPagodevuelta.Value   := 0;
          QFormaPagocredito.Value    := 'False';
          QFormaPagodocumento.Value  := vl_tarjeta;
          QFormaPagofor_veriphone_desc.Value := vl_respverifone;
          QFormaPago.Post;
          //MPagado := MPagado + StrToFloat(frmCombinado.edtarjeta.Text);
        end;

        if frmCombinado.edcheque.Value <> 0 then
        begin
          LPagado := LPagado + ',CHE';
          QFormaPago.Append;
          QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
          QFormaPagousu_codigo.Value := dm.Usuario;
          QFormaPagofecha.Value      := DM.getFechaServidor;
          QFormaPagoticket.Value     := QTicketticket.Value;
          QFormaPagoforma.Value      := 'CHE';
          QFormaPagopagado.Value     := frmCombinado.edcheque.Value;
          if MDevuelta < QFormaPagopagado.Value then
          begin
            QFormaPagodevuelta.Value := MDevuelta;
            MDevuelta := 0;
          end
          else
            QFormaPagodevuelta.Value := 0;
          QFormaPagocredito.Value    := 'False';
          QFormaPagodocumento.Value  := '';
          QFormaPago.Post;
          //MPagado := MPagado + StrToFloat(frmCombinado.edcheque.Text);
        end;

        if frmCombinado.edCredito.Value <> 0 then
        begin
          LPagado := LPagado + ',CRE';
          QFormaPago.Append;
          QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
          QFormaPagousu_codigo.Value := dm.Usuario;
          QFormaPagofecha.Value      := DM.getFechaServidor;
          QFormaPagoticket.Value     := QTicketticket.Value;
          QFormaPagoforma.Value      := 'CRE';
          QFormaPagopagado.Value     := frmCombinado.edCredito.Value;
          QFormaPagodevuelta.Value   := 0;
          QFormaPagocredito.Value    := 'True';
          QFormaPagocliente.Value    := cliente;
          QFormaPagoempresa.Value    := empresa;
          QFormaPagodocumento.Value  := '';
          QFormaPago.Post;

          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('select isnull(max(mov_numero),0) as maximo');
          Query1.sql.add('from movimientos where emp_codigo = :emp');
          Query1.sql.add('and mov_tipo = '+#39+'TK'+#39);
          Query1.Parameters.parambyname('emp').Value := empresa;
          Query1.open;
          MovTicket := query1.FieldByName('maximo').AsInteger + 1;

          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('select max(mov_secuencia) as maximo');
          Query1.sql.add('from movimientos where emp_codigo = :emp');
          Query1.sql.add('and mov_tipo = '+#39+'TK'+#39);
          Query1.Parameters.parambyname('emp').Value := empresa;
          Query1.open;
          num := query1.FieldByName('maximo').AsInteger + 1;

          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('select cpa_dias from condiciones');
          Query1.sql.add('where emp_codigo = '+inttostr(empresa));
          Query1.sql.add('and cpa_codigo in (select cpa_codigo from clientes');
          Query1.sql.add('where emp_Codigo = :emp and cli_codigo = :cli)');
          Query1.Parameters.ParamByName('emp').Value := empresa;
          Query1.Parameters.ParamByName('cli').Value := cliente;
          Query1.Open;
          diasvence := query1.FieldByName('cpa_dias').AsInteger;

          vence := Date + diasvence;

          //Inseretando en movimientos
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('insert into movimientos(emp_codigo,suc_codigo,');
          Query1.sql.add('mov_tipo, mov_numero, mov_fecha, mov_monto,');
          Query1.sql.add('mov_abono, mov_status, cli_codigo, ');
          Query1.sql.add('mov_secuencia, fac_forma, tfa_codigo, MOV_FECHAVENCE, mon_codigo, mov_tasa)');
          Query1.sql.add('values (:emp, 1,'+#39+'TK'+#39+', :num, :fecha, :total,');
          Query1.sql.add('0, '+#39+'PEN'+#39+', :cliente, :sec, '+#39+'X'+#39+', 0, :vence, 1, 1)');
          Query1.Parameters.parambyname('cliente').Value := cliente;
          Query1.Parameters.parambyname('fecha').Value   := date;
          Query1.Parameters.parambyname('total').Value   := frmCombinado.edCredito.Value;
          Query1.Parameters.parambyname('emp').Value     := empresa;
          Query1.Parameters.parambyname('num').Value     := MovTicket;
          Query1.Parameters.parambyname('sec').Value     := num;
          Query1.Parameters.parambyname('vence').Value   := vence;
          Query1.ExecSQL;

          //actualizando balance del cliente
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('update clientes set cli_balance = cli_balance + :monto');
          Query1.sql.add('where cli_codigo = :cliente');
          Query1.sql.add('and emp_codigo = :compania');
          Query1.Parameters.parambyname('cliente').Value  := cliente;
          Query1.Parameters.parambyname('monto').Value    := frmCombinado.edCredito.Value;
          Query1.Parameters.parambyname('compania').Value := empresa;
          Query1.ExecSQL;

          QTicket.Edit;
          QTicketmov_numero.Value := MovTicket;
          //QTicketemp_codigo.value := empresa;
          QTicket.Post;
          QTicket.UpdateBatch;

          //Si es un empleado
          if not frmClientes.QClientesemp_numero.IsNull then
          begin
            Query1.close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select par_tipo_descuento_cxc from Param_RHumanos where emp_codigo = :emp');
            Query1.Parameters.ParamByName('emp').Value := empresa;
            Query1.Open;
            descuentocxc := Query1.FieldByName('par_tipo_descuento_cxc').AsInteger;

            decodedate(QTicketfecha.Value+diasvence, ano, mes, dia);

            if dia <= 15 then periodo := 1 else periodo := 2;

            Query1.close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select isnull(max(des_codigo),0) as maximo from descuentos where emp_codigo = :emp');
            Query1.Parameters.ParamByName('emp').Value := empresa;
            Query1.Open;
            sec := query1.FieldByName('maximo').AsInteger + 1;

            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('insert into descuentos (emp_codigo,des_codigo,emp_numero,tde_codigo,des_fecha,des_valor,');
            Query1.SQL.Add('des_fijo_variable,des_porcentual,des_interes,des_cuotas,');
            Query1.SQL.Add('des_periodo_descuento,des_monto_pagado,des_cuotas_pagadas,des_status)');
            Query1.SQL.Add('values (:emp, :sec, :num, :des, :fec, :val,');
            Query1.SQL.Add(QuotedStr('V')+','+QuotedStr('False')+',0,0,');
            Query1.SQL.Add(inttostr(periodo)+',0,0,'+QuotedStr('EMI')+')');
            Query1.Parameters.ParamByName('emp').Value    := empresa;
            Query1.Parameters.ParamByName('sec').Value    := sec;
            Query1.Parameters.ParamByName('num').Value    := frmClientes.QClientesemp_numero.Value;
            Query1.Parameters.ParamByName('des').Value    := descuentocxc;
            Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value+diasvence;
            Query1.Parameters.ParamByName('fec').DataType := ftdate;
            Query1.Parameters.ParamByName('val').Value    := frmCombinado.edCredito.Value;
            Query1.ExecSQL;
          end;
          frmClientes.Release;
        end;

        if frmCombinado.edBonoClub.Value <> 0 then
        begin
          LPagado := 'BOC';
          QFormaPago.Append;
          QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
          QFormaPagousu_codigo.Value := dm.Usuario;
          QFormaPagofecha.Value      := DM.getFechaServidor;
          QFormaPagoticket.Value     := QTicketticket.Value;
          QFormaPagoforma.Value      := 'BOC';
          QFormaPagopagado.Value     := frmCombinado.edBonoClub.Value;
          QFormaPagodevuelta.Value   := 0;
          QFormaPagocredito.Value    := 'False';
          QFormaPagodocumento.Value  := '';
          QFormaPago.Post;
          //MPagado := MPagado + StrToFloat(frmCombinado.edBonoClub.Text);
        end;

        if frmCombinado.edBonoOtro.Value <> 0 then
        begin
          LPagado := 'OBO';
          QFormaPago.Append;
          QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
          QFormaPagousu_codigo.Value := dm.Usuario;
          QFormaPagofecha.Value      := DM.getFechaServidor;
          QFormaPagoticket.Value     := QTicketticket.Value;
          QFormaPagoforma.Value      := 'OBO';
          QFormaPagopagado.Value     := frmCombinado.edBonoOtro.Value;
          QFormaPagodevuelta.Value   := 0;
          QFormaPagocredito.Value    := 'False';
          QFormaPagodocumento.Value  := '';
          QFormaPago.Post;
          //MPagado := MPagado + StrToFloat(frmCombinado.edBonoOtro.Text);
        end;

        if frmCombinado.edrecibido.Value <> 0 then
        begin
          LPagado := ',EFE';
          QFormaPago.Append;
          QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
          QFormaPagousu_codigo.Value := dm.Usuario;
          QFormaPagofecha.Value      := DM.getFechaServidor;
          QFormaPagoticket.Value     := QTicketticket.Value;
          if cliente > 0 then QFormaPagocliente.Value    := cliente;
          QFormaPagoforma.Value      := 'EFE';
          QFormaPagopagado.Value     := frmCombinado.edrecibido.Value;
          if MDevuelta < QFormaPagopagado.Value then
          begin
            QFormaPagodevuelta.Value := MDevuelta;
            MDevuelta := 0;
          end
          else
            QFormaPagodevuelta.Value := 0;

          QFormaPagocredito.Value    := 'False';
          QFormaPagodocumento.Value  := '';
          QFormaPago.Post;
          //MPagado := MPagado + StrToFloat(frmCombinado.edrecibido.Text);
        end;

        QFormaPago.UpdateBatch;

        if Trim(tarjetaclub) <> '' then
        begin
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('EXECUTE PR_ACUMULA_PUNTOS :emp, :TARJETA, :MONTO');
          Query1.Parameters.ParamByName('emp').Value     := 1;
          Query1.Parameters.ParamByName('tarjeta').Value := tarjetaclub;
          Query1.Parameters.parambyname('monto').Value   := QTickettotal.Value -
                                frmCombinado.edBonoOtro.Value + frmCombinado.edBonoClub.Value;
          Query1.ExecSQL;
        end;

        //pnabrircajaClick(Self);


        //pnabrircajaClick(Self);


        if Impresora.IDPrinter >  0 then
        ImprimeTicketFiscal(Impresora) else
        begin
        if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;
        end;

        if Puerto2 = 'E'  then
        pnabrircaja2;
        if Puerto2 = 'T'  then
        pnabrircaja2;

        if Reimprimiendo = 'N' then
        ImpTicketRifa;

        if Reimprimiendo = 'N' then
        begin
        if Credito = 'True' then
        begin
           MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);
           //dm.Imp40Columnas(arch);
           winexec('imp.bat',0);
        end;
      end;




        Application.CreateForm(tfrmDevuelta, frmDevuelta);
        frmDevuelta.recibido := frmCombinado.edrecibido.Value + frmCombinado.edtarjeta.Value +
                                frmCombinado.edcheque.Value + frmCombinado.edBonoClub.Value +
                                frmCombinado.edBonoOtro.Value + frmCombinado.edCredito.Value;
        frmDevuelta.devuelta := frmCombinado.edrecibido.Value + frmCombinado.edtarjeta.Value +
                                frmCombinado.edcheque.Value + frmCombinado.edBonoClub.Value +
                                frmCombinado.edBonoOtro.Value + frmCombinado.edCredito.Value - QTickettotal.Value;

        frmDevuelta.lbdevuelta.Caption := Format('%n',[frmCombinado.edrecibido.Value + frmCombinado.edtarjeta.Value +
                                                        frmCombinado.edcheque.Value + frmCombinado.edBonoClub.Value +
                                                        frmCombinado.edBonoOtro.Value + frmCombinado.edCredito.Value -
                                                        QTickettotal.Value]);
        frmDevuelta.ShowModal;
        frmDevuelta.Release;
        //ImpTicketNorma201806;

        {if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;
         }

      if Puerto2 = 'T'  then
      pnabrircaja2;

        TicketNuevo(true);
        IniciaDisplay;
        edproducto.SetFocus();
      end;
      frmCombinado.Release;
    end;
  end;
  end;
//end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = 86) then pnreporteClick(Self);

  if (ssAlt in Shift) and (key = 83) then pSerieClick(Self);

  if (ssCtrl in Shift) and (key = 66) then
  begin
    pnborrarClick(Self);
    edproducto.Text := '';
  end;

  if (ssCtrl in Shift) and (key = 67) then
  begin
    pncancelatkClick(Self);
    edproducto.Text := '';
  end;

  if (ssCtrl in Shift) and (key = 68) then
  begin
    pndomicilioClick(Self);
    edproducto.Text := '';
  end;

  if (ssCtrl in Shift) and (key = 70) then
  begin
    pnprecioClick(Self);
    edproducto.Text := '';
  end;

  if (ssCtrl in Shift) and (key = 84) and (QTicket.State = dsInsert) then pntemporalClick(Self);
  if (ssCtrl in Shift) and (key = 71) and (QTicket.State <> dsInsert) then pntemporalClick(Self);

  if key = VK_MULTIPLY then
  begin
    edproducto.Text := '';
    pndepositoClick(Self);
  end;

  if key = 33     then pnunidadClick(Self);
  if key = 34     then pndescuentoClick(Self);
  if key = 191 then
  begin
    pncopiaClick(Self);
    edproducto.Text := '';
  end;
  if key = vk_f1  then pncuadreClick(Self);
  if key = vk_f2  then pnefectivoClick(Self);
  if key = vk_f3  then pntarjetaClick(Self);
  if key = vk_f4  then pnchequeClick(Self);
  if key = vk_f5  then pncombinadoClick(Self);
  if key = vk_f6  then pnbuscaprodClick(Self);
  if key = vk_f7  then pnNCFClick(Self);
  if key = vk_f8  then pncreditoClick(Self);
  if key = vk_f9  then pnreimprimirClick(Self);
  if key = vk_f10 then pnalunatkClick(Self);
  if key = vk_f11 then pnabrircajaClick(Self);
  if key = vk_f12 then pnclienteClick(Self);

  //Botones
  if (ssAlt in Shift) and (key = 65) then boton1Click(boton1);
  if (ssAlt in Shift) and (key = 66) then boton1Click(boton2);
  if (ssAlt in Shift) and (key = 67) then boton1Click(boton3);
  if (ssAlt in Shift) and (key = 68) then boton1Click(boton4);
  if (ssAlt in Shift) and (key = 69) then boton1Click(boton5);
  if (ssAlt in Shift) and (key = 70) then boton1Click(boton6);
  if (ssAlt in Shift) and (key = 71) then boton1Click(boton7);
  if (ssAlt in Shift) and (key = 72) then boton1Click(boton8);
  if (ssAlt in Shift) and (key = 73) then boton1Click(boton9);
  if (ssAlt in Shift) and (key = 74) then boton1Click(boton10);
  if (ssAlt in Shift) and (key = 75) then boton1Click(boton11);
  if (ssAlt in Shift) and (key = 76) then boton1Click(boton12);
  if (ssAlt in Shift) and (key = 77) then boton1Click(boton13);
  if (ssAlt in Shift) and (key = 78) then boton1Click(boton14);
  if (ssAlt in Shift) and (key = 79) then boton1Click(boton15);
  if (ssAlt in Shift) and (key = 80) then boton1Click(boton16);
  if (ssAlt in Shift) and (key = 81) then boton1Click(boton17);
  if (ssAlt in Shift) and (key = 82) then boton1Click(boton18);
  if (ssAlt in Shift) and (key = 83) then boton1Click(boton19);
  if (ssAlt in Shift) and (key = 84) then boton1Click(boton20);
end;

procedure TfrmMain.pncancelatkClick(Sender: TObject);
var
  supervisor : integer;
begin
  if QTickettotal.Value > 0 then
  begin
    if MessageDlg('ESTA SEGURO QUE DESEA CANCELAR ESTA FACTURA COMPLETA?',mtConfirmation,[mbYes,mbno],0) = mryes then
    begin
      Application.CreateForm(tfrmAcceso, frmAcceso);
      frmAcceso.ShowModal;
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select usu_codigo, clave from clave_supervisor_caja');
      dm.Query1.SQL.Add('where clave = :cla');
      DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
      dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
      dm.Query1.Open;
      if dm.Query1.RecordCount = 0 then
      begin
        MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
        edproducto.SetFocus;
      end
      else
      begin
        supervisor := dm.Query1.FieldByName('usu_codigo').AsInteger;

        QTicket.Edit;
        QTicketsupervisor.Value := supervisor;
        QTicket.Post;
        QTicket.UpdateBatch;

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('execute pr_cancela_ticket :usu, :caj, :fec, :tik');
        dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
        dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
        dm.Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        dm.Query1.ExecSQL;

        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
        QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QFormaPago.Open;

        QFormaPago.Append;
        QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
        QFormaPagousu_codigo.Value := dm.Usuario;
        QFormaPagofecha.Value      := DM.getFechaServidor;
        QFormaPagoticket.Value     := QTicketticket.Value;
        QFormaPagoforma.Value      := 'EFE';
        QFormaPagopagado.Value     := 0;
        QFormaPagodevuelta.Value   := 0;
        QFormaPagocredito.Value    := 'False';
        QFormaPago.Post;
        QFormaPago.UpdateBatch;

        lbund.Caption := 'UNIDAD';
        SeleccionTipo := '';
        SeleccionCliente := 0;
        SeleccionEmpresa := 0;
        Aumento := 0;
        cliente := 0;

        if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;


        //ImpTicketNorma201806;
        TicketNuevo(true);

      end;
      frmAcceso.Release;
    end
    else
      edproducto.SetFocus;
  end
  else
    edproducto.SetFocus;
end;

procedure TfrmMain.pnalunatkClick(Sender: TObject);
begin
  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
  frmAcceso.ShowModal;
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select usu_codigo, clave from clave_supervisor_caja');
  dm.Query1.SQL.Add('where clave = :cla');
  DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
  dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    Application.CreateForm(tfrmAnular, frmAnular);
    frmAnular.supervisor := dm.Query1.FieldByName('usu_codigo').AsInteger;
    frmAnular.btimprimir.Visible := False;
    frmAnular.QTicket.Close;
    frmAnular.QTicket.SQL.Add('order by fecha desc, ticket desc');
    frmAnular.QTicket.Parameters.ParamByName('usu').Value     := dm.Usuario;
    frmAnular.QTicket.Parameters.ParamByName('fec1').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec1').Value    := frmAnular.hora1.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').Value    := frmAnular.hora2.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('caj').Value     := StrToInt(edcaja.Caption);
    frmAnular.QTicket.Open;
    frmAnular.ShowModal;
    frmAnular.Release;
    edproducto.SetFocus;
  end;
  frmAcceso.Release;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if QTickettotal.Value >0 then
    Abort;
  Clientes.Free();
  dm.ADOSIGMA.Connected :=false;  
end;

procedure TfrmMain.pnborrarClick(Sender: TObject);
var
  prod : integer;
  codigo : string;
  t : TBookmark;
begin
  if QTickettotal.Value > 0 then
  begin
    DisplayEliminando;
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      DisplayTotal;
      edproducto.SetFocus;
    end
    else
    begin
      Application.CreateForm(tfrmEliminar, frmEliminar);
      if forma_numeracion = 1 then
      begin
        frmEliminar.QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      frmEliminar.QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
      frmEliminar.QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
      frmEliminar.QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
      frmEliminar.QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      frmEliminar.QDetalle.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
      frmEliminar.QDetalle.Open;
      frmEliminar.ShowModal;
      if frmEliminar.Elimino = 1 then
      begin
        QDetalle.Locate('producto', frmEliminar.QDetalleproducto.Value,[]);

        Query1.Close;
        Query1.SQL.Clear;
        Query1.SQL.Add('select pro_roriginal from productos');
        Query1.SQL.Add('where emp_codigo = :emp');
        Query1.SQL.Add('and pro_codigo = :cod');
        Query1.Parameters.ParamByName('emp').Value := empresainv;
        Query1.Parameters.ParamByName('cod').Value := frmEliminar.QDetalleproducto.Value;
        Query1.Open;
        Codigo := Query1.FieldByName('pro_roriginal').AsString;
        BuscaProducto(codigo);

        Query1.Close;
        Query1.SQL.Clear;
        Query1.SQL.Add('select isnull(max(secuencia),0)+1 as maximo');
        Query1.SQL.Add('from ticket where caja = :caj');
        Query1.SQL.Add('and ticket = :tik');
        if forma_numeracion = 1 then
        begin
          Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          Query1.SQL.Add('and usu_codigo = :usu');
          Query1.Parameters.ParamByName('fec').DataType := ftDate;
          Query1.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;

        Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        Query1.Open;

        QDetalle.Append;
        QDetallesecuencia.Value   := Query1.FieldByName('maximo').AsInteger;
        QDetalleticket.Value      := QTicketticket.Value;
        QDetallecaja.Value        := StrToInt(edcaja.Caption);
        QDetalleusu_codigo.Value  := dm.Usuario;
        QDetallefecha.Value       := QTicketfecha.Value;
        QDetalleproducto.Value    := frmEliminar.QDetalleproducto.Value;
        QDetalledescripcion.Value := frmEliminar.QDetalledescripcion.Value;
        QDetallecantidad.Value    := frmEliminar.cantidad * -1;
        //QDetalleitbis.Value       := dm.Query1.FieldByName('pro_montoitbis').AsFloat;

        {if dm.Query1.FieldByName('pro_itbis').AsString = 'S' then
          QDetalleitbis.Value     := 16
        else
          QDetalleitbis.Value     := 0;}

        QDetalleCosto.Value       := dm.Query1.FieldByName('pro_costo').AsFloat;
        QDetalleprecio.Value      := frmEliminar.QDetalleprecio.Value;
        QDetalle.Post;
        QDetalle.UpdateBatch;

        Totaliza;
        AplicaDescPorRangoVta(QTickettotal.Value);

        edproducto.Text := '';
        
        DisplayTotal;
      end
      else if frmEliminar.Elimino = 2 then
      begin
        QDetalle.DisableControls;
        QDetalle.Close;
        QDetalle.Open;
        QDetalle.First;
        QDetalle.EnableControls;

        Totaliza;
         AplicaDescPorRangoVta(QTickettotal.Value);
        edproducto.Text := '';

        DisplayTotal;
      end;

      frmEliminar.Release;
    end;
    frmAcceso.Release;
  end
  else
    edproducto.SetFocus;
end;

procedure TfrmMain.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if QDetallecantidad.Value < 0 then
  begin
    DBGrid1.Canvas.Font.Color := clRed;
    DBGrid1.Canvas.Font.Style := DBGrid1.Canvas.Font.Style + [fsStrikeOut];
  end;
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmMain.pnbuscaprodClick(Sender: TObject);
var
  palabra, palabra1, palabra2 : string;
begin
  if Trim(edproducto.Text) <> '' then
  begin
    Precio := 0;
    if pos(' ',edproducto.text) > 0 then
    begin
      palabra1 := copy(edproducto.Text,1,pos(' ',edproducto.text));
      palabra2 := copy(edproducto.Text, pos(' ',edproducto.Text)+1,length(edproducto.Text));
      palabra := '%'+trim(palabra1)+'%'+' '+'%'+trim(palabra2)+'%'
    end
    else
    begin
      palabra1 := edproducto.Text;
      palabra := '%'+trim(palabra1)+'%';
    end;

    if PrecioClie <> '' then
    PrecioCaja := PrecioClie;

    Application.CreateForm(tfrmBuscaProducto, frmBuscaProducto);
    frmBuscaProducto.Precio := PrecioCaja;
    frmBuscaProducto.QProductos.SQL.Clear;
    frmBuscaProducto.QProductos.SQL.Add('select p.pro_nombre,');
    if lbund.Caption <> 'EMPAQUE' THEN
    frmBuscaProducto.QProductos.SQL.Add('p.pro_precio1') ELSE
    frmBuscaProducto.QProductos.SQL.Add('p.pro_precio2 pro_precio1');
    frmBuscaProducto.QProductos.SQL.Add(', e.exi_cantidad, p.pro_precio2, p.pro_codigo, p.pro_roriginal, p.pro_precio3, p.pro_precio4');
    frmBuscaProducto.QProductos.SQL.Add('from productos p, existencias e');
    frmBuscaProducto.QProductos.SQL.Add('where p.pro_codigo = e.pro_codigo');
    frmBuscaProducto.QProductos.SQL.Add('and p.emp_codigo = :emp');
    frmBuscaProducto.QProductos.SQL.Add('and e.alm_codigo = :alm');
    frmBuscaProducto.QProductos.SQL.Add('and p.pro_status <> '+QuotedStr('INA'));
    frmBuscaProducto.QProductos.SQL.Add('and e.emp_codigo = '+DM.QEmpresaemp_codigo.Text);
    frmBuscaProducto.QProductos.SQL.Add('and p.pro_nombre like '+QuotedStr(palabra));
    frmBuscaProducto.QProductos.SQL.Add('order by p.pro_nombre');
    frmBuscaProducto.QProductos.Parameters.ParamByName('emp').Value := empresainv;
    frmBuscaProducto.QProductos.Open;
    frmBuscaProducto.ShowModal;
    if frmBuscaProducto.Selec = 1 then
    begin
      edproducto.Text := frmBuscaProducto.QProductospro_roriginal.Value;
      UltProd := edproducto.Text;
      BuscaProducto(edproducto.Text);
      InsertaProducto;
    end
    else
      edproducto.Text := '';
    frmBuscaProducto.Release;
  end;
end;

procedure TfrmMain.InsertaProducto;
var
  Prec : String;
  Costo : Double;
begin
  if not QTicket.Active then
   TicketNuevo(false);
  if not (QTicket.State in [dsEdit,dsInsert] ) then
    QTicket.Edit;

  //BuscaProducto(Trim(edproducto.Text));
  if dm.Query1.RecordCount > 0 then
  begin
{  if ((Patrocinador = '') or (Patrocinador = 'False')) and
     not (dm.Query1.FieldByName('pro_patrocinador').IsNull) then
      Patrocinador := dm.Query1.FieldByName('pro_patrocinador').AsString;
 }
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select isnull(max(secuencia),0)+1 as maximo');
    Query1.SQL.Add('from ticket where caja = :caj');
    Query1.SQL.Add('and ticket = :tik');

    if forma_numeracion = 1 then
    begin
      Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
      Query1.SQL.Add('and usu_codigo = :usu');
      Query1.Parameters.ParamByName('fec').DataType := ftDate;
      Query1.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
      Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
    end;
    Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
    Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
    Query1.Open;

    if Precio = 0 then
    begin         
      if lbund.Caption = 'UNIDAD' then
            Precio := dm.Query1.FieldByName('pro_'+PrecioCaja).AsFloat
      else
            Precio := dm.Query1.FieldByName('pro_'+PrecioEMP).AsFloat;
    //  end;

    // if PrecioCaja = 'Precio1' then
    //  begin
    //    if lbund.Caption = 'UNIDAD' then
    //     Precio := dm.Query1.FieldByName('pro_precio1').AsFloat
    //    else
    //      Precio := dm.Query1.FieldByName('pro_precio1').AsFloat;
    //  end
    //  else
    //  begin
    //      if lbund.Caption = 'UNIDAD' then
    //        Precio := dm.Query1.FieldByName('pro_'+PrecioCajaUP).AsFloat
    //      else
    //        Precio := dm.Query1.FieldByName('pro_'+PrecioEMPUP).AsFloat;
    //      end;
    end;

    if trim(edcantidad.Text) = '' then edcantidad.Text := '1';

    Costo := dm.Query1.FieldByName('pro_costo').AsFloat;
    if Precio = 0 then
    begin
      Prec   := InputBox('Precio','Precio:','');
      if Trim(Prec) = '' then Prec := '0';
      Precio := StrToFloat(Prec);
      Costo := Precio/1.20;
    end;
    if Precio >= 0 then
    begin
      QDetalle.First;
      QDetalle.Append;
      qDetallehora.Value         := FormatDateTime('hh:mm',dm.getFechaServidor);
      qDetallealm_codigo.Value   := almacen;
      QDetallepro_serializado.Value:= dm.Query1.FieldByName('pro_serializado').AsString;
      QDetallesup_codigo.Value   := dm.Query1.FieldByName('sup_codigo').AsInteger;
      QDetallemar_codigo.Value   := dm.Query1.FieldByName('mar_codigo').AsInteger;
      QDetalledep_codigo.Value   := dm.Query1.FieldByName('dep_codigo').AsInteger;
      QDetallefam_codigo.Value   := dm.Query1.FieldByName('fam_codigo').AsInteger;
      QDetalleger_codigo.Value   := dm.Query1.FieldByName('ger_codigo').AsInteger;
      QDetallegon_codigo.Value   := dm.Query1.FieldByName('gon_codigo').AsInteger;
      QDetallecol_codigo.Value   := dm.Query1.FieldByName('col_codigo').AsInteger;
      QDetalleitbis.Value        := dm.Query1.FieldByName('pro_montoitbis').AsFloat;

      QDetallesecuencia.Value    := Query1.FieldByName('maximo').AsInteger;
      QDetalleticket.Value       := QTicketticket.Value;
      QDetallecaja.Value         := StrToInt(edcaja.Caption);
      QDetalleusu_codigo.Value   := dm.Usuario;
      QDetallefecha.Value        := QTicketfecha.Value;
      QDetalleproducto.Value     := dm.Query1.FieldByName('pro_codigo').AsInteger;
      QDetallePatrocinador.Value := dm.Query1.FieldByName('pro_patrocinador').AsString;
      if Length(trim(dm.Query1.FieldByName('pro_display').AsString)) > 0  then
        QDetalledescripcion.Value := dm.Query1.FieldByName('pro_display').AsString
      else
        QDetalledescripcion.Value := dm.Query1.FieldByName('pro_nombre').AsString;
      if dm.Query1.FieldByName('Detallado').Value = 'True' then
      QDetallecantidad.Value    := StrToFloat(Trim(edcantidad.Text)) else
      begin
      if ((Trunc(StrToFloat(Trim(edcantidad.Text))) < 1)) then begin
      edcantidad.Text := '1';
      ShowMessage('ESTE PRODUCTO NO SE VENDE DETALLADO, FAVOR REVISAR...');
      qDetalle.Delete;
      Exit;
      end
      else
      if (((StrToFloat(Trim(edcantidad.Text))/(Trunc(StrToFloat(Trim(edcantidad.Text)))))) < 1) or
      ((((StrToFloat(Trim(edcantidad.Text))/(Trunc(StrToFloat(Trim(edcantidad.Text)))))) > 1) and
       (((StrToFloat(Trim(edcantidad.Text))/(Trunc(StrToFloat(Trim(edcantidad.Text)))))) < 2))
      then BEGIN
      edcantidad.Text := '1';
      ShowMessage('ESTE PRODUCTO NO SE VENDE DETALLADO, FAVOR REVISAR...');
      qDetalle.Delete;
      Exit;
      end
      else
      QDetallecantidad.Value    := Trunc(StrToFloat(Trim(edcantidad.Text)));
      end;

      {if dm.Query1.FieldByName('pro_itbis').AsString = 'S' then
        QDetalleitbis.Value     := 16
      else
        QDetalleitbis.Value     := 0;}

      QDetalleCosto.Value       := Costo;
      QDetalleOferta.Value      := 0;
      QDetalleRealizo_Oferta.Value := 'N';

      if lbund.Caption = 'UNIDAD' then
      begin
        QOferta.Close;
        QOferta.Parameters.ParamByName('emp').Value    := empresainv;
        QOferta.Parameters.ParamByName('fec').DataType := ftDate;
        QOferta.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
        QOferta.Parameters.ParamByName('pro').Value    := dm.Query1.FieldByName('pro_codigo').AsInteger;
        //QOferta.Parameters.ParamByName('can').Value    := StrToFloat(edcantidad.Text);
        QOferta.Parameters.ParamByName('can').Value    := 1;
        QOferta.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
        QOferta.Parameters.ParamByName('usu').Value    := dm.Usuario;
        QOferta.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QOferta.Open;
        if (QOferta.RecordCount > 0) then
        begin
          if QOfertaprecio.Value > 0 then
          begin
            QDetalleprecio.Value    := QOfertaprecio.Value;
            QDetalledescuento.Value := 0;
            //QDetalledescuento.Value := 100 - ((QOfertaprecio.Value*100)/Precio);
            //Precio := QOfertaprecio.Value;
          end
          else if QOfertaporciento.Value > 0 then
          begin
            QDetalleprecio.Value    := QOfertaprecio.Value;
            //QDetalledescuento.Value := 0;
            QDetalledescuento.Value := QOfertaporciento.Value;
            //Precio :=  Precio - ((Precio*QDetalledescuento.Value)/100);
          end
          else if QOfertaregalar.Value = 'S' then
          begin
            QDetalledescuento.Value := 0;
            QDetalleprecio.Value    := 0;
            QDetalleOferta.Value    := 1;
            QDetalleRealizo_Oferta.Value := 'S';

            //actualizando detalle del ticket con oferta = 'S'
            Query2.SQL.Clear;
            Query2.SQL.Add('update ticket');
            Query2.SQL.Add('set Realizo_Oferta = '+QuotedStr('S')+',');
            Query2.SQL.Add('Oferta = :can');
            Query2.SQL.Add('where fecha = convert(datetime, :fec, 105)');
            Query2.SQL.Add('and usu_codigo = :usu');
            Query2.SQL.Add('and caja = :caj');
            Query2.SQL.Add('and ticket = :tik');
            Query2.SQL.Add('and producto = :pro');
            Query2.SQL.Add('and Realizo_Oferta = '+QuotedStr('N'));
            Query2.Parameters.ParamByName('can').Value    := StrToFloat(Trim(edcantidad.Text));
            Query2.Parameters.ParamByName('fec').DataType := ftDate;
            Query2.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
            Query2.Parameters.ParamByName('usu').Value    := dm.Usuario;
            Query2.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
            Query2.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
            Query2.Parameters.ParamByName('pro').Value    := dm.Query1.FieldByName('pro_codigo').AsInteger;
            Query2.ExecSQL;
          end;
        end;
      end;

      if TipoComprobante = 4 then //Regimen Especial
      begin
        if QDetalleitbis.Value > 0 then
          Precio := Precio/((QDetalleitbis.value/100)+1);
      end;

        QDetalleprecio.Value := Precio + ((Precio * porciento/100));

      if Aumento > 0 then
        QDetalleprecio.Value := Precio + ((Precio * Aumento/100));

    {  if QOfertaregalar.Value = 'S' then
        begin
          QDetalledescuento.Value := 0;
          QDetalleprecio.Value    := 0;
          QDetalleOferta.Value    := 1;
          QDetalleRealizo_Oferta.Value := 'S';
        end
      else
        if QOfertaprecio.Value > 0 then
           begin
             QDetalleprecio.Value    := QOfertaprecio.Value;
             QDetalledescuento.Value := 0;
           end
        else
          if (PorcientoClte > 0) then  //aplica porciento de cliente si lo hay.
            QDetalledescuento.Value := PorcientoClte;
             }
       if QDetallecantidad.IsNull then
       begin
       QDetallecantidad.Value := 1;
       edcantidad.Text := '1';
       end;

      QDetalle.Post;
      QDetalle.UpdateBatch;


      if QDetallepro_serializado.Value = 'S' then
         pSerieClick(self);

      QDetalle.DisableControls;
      QDetalle.Close;
      if forma_numeracion = 1 then
      begin
        QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
        QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
        QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      QDetalle.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
      QDetalle.Open;
      QDetalle.EnableControls;

      Totaliza;
     AplicaDescPorRangoVta(QTickettotal.Value);
      Display(QDetalleValor.Value, QDetalledescripcion.Value);
    end
    else
      MessageDlg('MERCANCIA SIN PRECIO, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);

    edcantidad.Text := '1';
  end
  else
  begin
    Beep;
    MessageDlg('ESTE PRODUCTO NO EXISTE, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);


  end;
  edproducto.Text := '';

  edproducto.SetFocus;
end;


procedure TfrmMain.pnNCFClick(Sender: TObject);
var
  rnc, nombre : string;
  a : integer;
  valido : boolean;
begin
  if QTickettotal.Value > 0 then
  begin
    Application.CreateForm(tfrmNCF, frmNCF);
    frmNCF.ShowModal;
    TipoComprobante := frmNCF.ncf;

    
    if TipoComprobante <> 1 then
    begin
    { OJO  if TipoComprobante = 2 then edncf.Caption := 'VALIDO PARA CREDITO FISCAL'
      else if TipoComprobante = 3 then edncf.Caption := 'COMPROBANTE GUBERNAMENTAL'
      else if TipoComprobante = 4 then edncf.Caption := 'COMPROBANTE REGIMEN ESPECIAL';
     }
      valido := true;
      rnc := InputBox('RNC del Cliente','RNC:',rnc);
      rnc := Trim(rnc);
      for a := 1 to length(rnc) do
      begin
        if (copy(rnc,a,1) <> '0') and (copy(rnc,a,1) <> '1') and
        (copy(rnc,a,1) <> '2') and (copy(rnc,a,1) <> '3') and
        (copy(rnc,a,1) <> '4') and (copy(rnc,a,1) <> '5') and
        (copy(rnc,a,1) <> '6') and (copy(rnc,a,1) <> '7') and
        (copy(rnc,a,1) <> '8') and (copy(rnc,a,1) <> '9') then
        begin
          valido := false;
          break;
        end;
      end;

      if not valido then
        MessageDlg('DEBE DIGITAR UN RNC VALIDO, SIN GUIONES U OTROS SIGNOS, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0)
      else
        if length(rnc) < 9 then
          MessageDlg('DEBE DIGITAR UN RNC VALIDO, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0)
        else
          begin
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select razon_social from rnc');
        dm.Query1.SQL.Add('where rnc_cedula = :rnc');
        dm.Query1.Parameters.ParamByName('rnc').Value := rnc;
        dm.Query1.Open;
        if dm.Query1.RecordCount > 0 then
          nombre := dm.Query1.FieldByName('razon_social').AsString
        else
          nombre := '';

        edTipoNCF.Text := IntToStr(TipoComprobante);
          
        if trim(nombre) = '' then
        begin
          rnc := '';
          TipoComprobante := 1;
        //OJO   edncf.Caption := 'COMPROBANTE CONSUMIDOR FINAL';
          MessageDlg('EL CLIENTE NO EXISTE, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
        end
        else                      // ojo inicia debe dar valores defaul y cuando cobra debe de hacerlo otra vez no cuando entra productos
        begin
          QTicket.Edit;
          QTicketrnc.Value    := rnc;
          QTicketnombre.Value := nombre;
          QTicket['tip_codigo'] := TipoComprobante;
          QTicket.Post;
          QTicket.UpdateBatch;
         // OJO  edcliente.Caption := nombre;

          if TipoComprobante = 4 then //Regimen Especial
          begin
            QTicket.Edit;
            QTicketitbis.Value := 0;
            QTicket.Post;
           QTicket.UpdateBatch;

            QDetalle.DisableControls;
            QDetalle.first;
            while not QDetalle.Eof do
            begin
              QDetalle.Edit;
              if QDetalleitbis.Value > 0 then
              begin
                QDetalleprecio.Value := RoundTo(QDetalleprecio.Value/((QDetalleITBIS.value/100)+1), -2);
                QDetalleITBIS.Value  := 0;
              end;
              QDetalle.Post;
              QDetalle.Next;
            end;
            QDetalle.EnableControls;
            QDetalle.UpdateBatch;
            Totaliza;
             AplicaDescPorRangoVta(QTickettotal.Value);
          end;
          Application.CreateForm(tfrmInformacionNCF, frmInformacionNCF);
          frmInformacionNCF.ShowModal;
          frmInformacionNCF.Release;
        end;
      end;
    end;
    frmNCF.Release;
  END;
end;

procedure TfrmMain.ImpTicket;
var
  arch, ptocaja : textfile;
  s, s1, s2,s22, s3, s4, s5 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
begin

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select par_ticket_itbis from parametros');
      dm.Query1.SQL.Add('where emp_codigo = :emp');
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      dm.Query1.Open;
      ImpItbis := dm.Query1.FieldByName('par_ticket_itbis').AsString;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Puerto, codigo_abre_caja, codigo_abre_caja_tipo Puerto2 from cajas_IP');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
      dm.Query1.Open;
      Puerto := DM.Query1.FieldByName('Puerto').AsString;
      Puerto2 := DM.Query1.FieldByName('Puerto2').AsString;





      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('SELECT EMP_NOMBRE, EMP_DIRECCION, EMP_LOCALIDAD, emp_telefono, emp_rnc');
      dm.Query1.SQL.Add('FROM EMPRESAS');
      dm.Query1.SQL.Add('WHERE emp_codigo = '+QTicketemp_codigo.Text);
      DM.Query1.Open;

      assignfile(arch,'.\imp.bat');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch, 'type .\rep.txt > '+Puerto);
      closefile(arch);

      assignfile(arch,'.\rep.txt');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch, dm.centro(dm.Query1.fieldbyname('emp_nombre').Value));
      writeln(arch, dm.centro(dm.Query1.fieldbyname('emp_direccion').Value));
      writeln(arch, dm.centro(dm.Query1.fieldbyname('EMP_LOCALIDAD').Value));
      writeln(arch, dm.centro(dm.Query1.fieldbyname('EMP_TELEFONO').Value));
      writeln(arch, dm.centro('RNC:'+dm.Query1.fieldbyname('EMP_RNC').Value));
      writeln(arch, ' ');
      writeln(arch, dm.centro('*** F A C T U R A ***'));
      if Credito = 'True' then
         writeln(arch, dm.centro('* C R E D I T O *'));

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select ncf_nombre from ncf_ticket_tipodoc');
      dm.Query1.SQL.Add('where ncf_numero = :tipo');
      dm.Query1.Parameters.ParamByName('tipo').Value := QTicketNCF_Tipo.Value;
      dm.Query1.Open;

      writeln(arch, dm.Centro(dm.Query1.FieldByName('ncf_nombre').AsString));
      writeln(arch, ' ');

      dm.Query1.close;
      dm.Query1.SQL.clear;
      dm.Query1.SQL.add('select usu_nombre from usuarios');
      dm.Query1.SQL.add('where usu_codigo = :usu');
      dm.Query1.Parameters.parambyname('usu').Value := dm.Usuario;
      dm.Query1.open;

      writeln(arch, 'Fecha   .: '+DateToStr(QTicketfecha.Value)+' Factura: '+formatfloat('0000000000',QTicketticket.value));
      writeln(arch, 'Caja   ..: '+formatfloat('000',strtofloat(edCaja.Caption))+'        Hora ..: '+timetostr(QTicketfecha_hora.Value));
      writeln(arch, 'Cajera/O : '+formatfloat('000',dm.Usuario)+' '+dm.query1.fieldbyname('usu_nombre').asstring);

      if Credito = 'True' then
         writeln(arch, 'Doc Cr   : '+IntToStr(MovTicket));

      if QTicketnombre.Value <> '' then
      begin
        writeln(arch, 'Cliente: '+QTicketnombre.Value);
        if Trim(QTicketrnc.Value) <> '' then
          writeln(arch, 'RNC .....: '+QTicketrnc.Value);
      end;

      if QTicketNCF.Value <> '' then
        writeln(arch,'NCF .....: '+QTicketNCF.Value);
      //buscar vencimiento
      with QDatos do begin
      Close;
      sql.Clear;
      SQL.Add('select top 1 FechaVenc ');
      sql.Add('from NCF ');
      sql.Add('where VerificaVenc = 1 and emp_codigo = :emp_codigo');
      sql.Add('and NCF_Fijo   = :NCF_Fijo');
      sql.Add('ORDER BY FECHAVENC');
      Parameters.ParamByName('emp_codigo').Value := QTicketemp_codigo.Value;
      Parameters.ParamByName('NCF_Fijo').Value   := QTicketNCF_Fijo.Text;
      Open;
      if not IsEmpty then
      writeln(arch,'Fecha Venc.: '+FieldByName('FechaVenc').text);
      end;

      if Trim(TarjetaClub) <> '' then
      begin
         Query1.close;
         Query1.sql.clear;
         Query1.sql.add('select cli_nombre, cli_apellido from cliente_club');
         Query1.sql.add('where cli_carnet_club = :tar');
         Query1.Parameters.ParamByName('tar').Value := Trim(TarjetaClub);
         Query1.Open;
         writeln(arch, Query1.FieldByName('cli_nombre').AsString+' '+
                       Query1.FieldByName('cli_apellido').AsString);
      end;

      writeln(arch, '----------------------------------------');

      {if ImpItbis = 'True' then
        writeln(arch, 'CANT.   DESCRIPCION      ITBIS     TOTAL')
      else
        writeln(arch, 'CANT.       DESCRIPCION            TOTAL');
       }

       if ImpItbis = 'True' then
        writeln(arch, 'CANT. PREC  DESCRIPCION  ITBIS     TOTAL')
      else
        writeln(arch, 'CANT. PREC  DESCRIPCION            TOTAL');

      writeln(arch, '----------------------------------------');
      TFac := 0;
      MontoItbis := 0;
      while not QDetalle.eof do
      begin
        s := '';
        FillChar(s, 5-length(Trim(qDetallecantidad.Text)),' ');
        s1 := '';
        FillChar(s1, 10-length(trim(FORMAT('%n',[QDetalleValor.value]))), ' ');
        s2 := '';


        {if ImpItbis = 'True' then begin
          FillChar(s2, 10-length(copy(trim(QDetalledescripcion.value),1,10)),' ');
          end
        else begin
          FillChar(s2, 22-length(copy(trim(QDetalledescripcion.value),1,22)),' ');
          end;}

        s3 := '';
        FillChar(s3, 10-length(trim(FORMAT('%n',[QDetallePrecioItbis.value]))),' ');
        s4 := '';
        FillChar(s4, 10-length(trim(FORMAT('%n',[QDetalleCalcItbis.value * QDetallecantidad.Value]))),' ');
        //FillChar(s4, 8-length(trim(FORMAT('%n',[QDetalleitbis.value])+'%')),' ');

        s5 := '';
        FillChar(s5, 20-length(Trim(qDetallecantidad.Text)+
                        ' X '+format('%n',[qDetalleprecio.value])),' ');

        lbitbis := 'E';
        {if QDetalleitbis.value > 0 then
        begin
           MontoItbis := QDetalleitbis.value;//MontoItbis + (QDetalleCalcItbis.value * QDetallecantidad.Value);
           lbitbis := ' ';
        end;}
        if ImpItbis = 'True' then
        begin
          MontoItbis := MontoItbis + (QDetalleCalcItbis.value * QDetallecantidad.Value);
          writeln(arch, Trim(qDetallecantidad.Text)+
                        ' X '+format('%n',[qDetalleprecio.value])+s5+S4+FORMAT('%n',[QDetalleCalcItbis.value * QDetallecantidad.Value])+s1+
                        format('%n',[QDetalleValor.value]));
          if Length(QDetalledescripcion.value)<=40 then
          writeln(arch,copy(trim(QDetalledescripcion.value),1,40));
          if Length(QDetalledescripcion.value)>40 then begin
          writeln(arch,copy(trim(QDetalledescripcion.value),1,40));
          writeln(arch,copy(trim(QDetalledescripcion.value),41,80));
          end;


        end
        else begin
          writeln(arch, Trim(qDetallecantidad.Text)+' X '+
                        format('%n',[qDetalleprecio.value])+
                        lbitbis+' '+s5+S4+format('%n',[QDetalleValor.value]));
         if Length(QDetalledescripcion.value)<=40 then
          writeln(arch,copy(trim(QDetalledescripcion.value),1,40));
          if Length(QDetalledescripcion.value)>40 then begin
          writeln(arch,copy(trim(QDetalledescripcion.value),1,40));
          writeln(arch,copy(trim(QDetalledescripcion.value),41,80));
          end;

         end;
        TFac := TFac + QDetalleValor.value;
        QDetalle.next;
      end;
      writeln(arch, '                   ---------------------');
      tCambio := (QTickettotal.Value-MPagado);
      if Credito = 'True' then
      begin
         if QFormaPago.Locate('forma','EFE',[]) then
         begin
           MPagado := QFormaPagopagado.Value-QFormaPagodevuelta.Value;
           tCambio := (QTickettotal.Value-QFormaPagopagado.Value-MPagado)
         end
         else
         begin
           MPagado := 0;
           tCambio := 0;
         end;
      end;

      if QTicketstatus.Value = 'TMP' THEN BEGIN
      MPagado := 0;
      tCambio := 0;
      end;


      s := '';
      FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
      s1:= '';
      FillChar(s1, 10-length(trim(FORMAT('%n',[MPagado]))), ' ');
      s2:= '';
      FillChar(s2, 10-length(trim(FORMAT('%n',[tCambio*-1]))), ' ');
      s3:= '';
      FillChar(s3, 10-length(trim(FORMAT('%n',[MontoItbis]))), ' ');
      s4:= '';
      FillChar(s4, 10-length(trim(FORMAT('%n',[TFac]))), ' ');


      writeln(arch,'                   Total    : '+s4+format('%n',[QTickettotal.Value]));
      writeln(arch,'                   Recibido : '+s1+format('%n',[MPagado]));
      writeln(arch,'                   Cambio   : '+s2+format('%n',[tCambio*-1]));
      writeln(arch, ' ');

      {Query1.close;
      Query1.SQL.clear;
      Query1.SQL.add('select itbis, sum((((((precio*cantidad)/((itbis/100)+1)))-(((precio*cantidad)/((itbis/100)+1))*(Descuento/100))) * itbis)/100) as monto');
      Query1.SQL.add('from ticket where fecha = :fec and usu_codigo = :usu and caja = :caj and ticket = :tik');
      Query1.SQL.add('and itbis > 0 group by itbis order by 1');
      Query1.Parameters.ParamByName('fec').DataType := ftDate;
      Query1.Parameters.ParamByName('fec').Value := QTicketfecha.Value;
      Query1.Parameters.ParamByName('usu').Value := QTicketusu_codigo.Value;
      Query1.Parameters.ParamByName('caj').Value := QTicketcaja.Value;
      Query1.Parameters.ParamByName('tik').Value := QTicketticket.Value;
      Query1.Open;
      while not Query1.Eof do
      begin
        s3:= '';
        FillChar(s3, 10-length(trim(FORMAT('%n',[Query1.FieldByName('monto').AsFloat]))), ' ');
        writeln(arch,'                   Itbis '+formatfloat('00',Query1.FieldByName('itbis').AsFloat)+
                    '%: '+s3+format('%n',[Query1.FieldByName('monto').AsFloat]));
        Query1.Next;
      end;
      if Query1.RecordCount > 1 then
      begin
        s3:= '';
        FillChar(s3, 10-length(trim(FORMAT('%n',[QTicketitbis.AsFloat]))), ' ');
        writeln(arch, '                   ---------------------');
        writeln(arch, '                   Total Itb: '+s3+FORMAT('%n',[QTicketitbis.AsFloat]));
        writeln(arch, ' ');
      end
      else if Query1.RecordCount = 1 then writeln(arch, ' ');
       }
      writeln(arch,'                    Itbis   : '+s3+format('%n',[MontoItbis]));

      writeln(arch, '----Forma de Pago----');
      QFormaPago.First;
      MPagado := 0;
      while not QFormaPago.Eof do
      begin
        s := '';
        FillChar(s, 10-length(trim(FORMAT('%n',[QFormaPagopagado.Value]))), ' ');

        if QFormaPagoFORMA.Value <> 'CRE' then
          MPagado := MPagado + QFormaPagopagado.Value;;

        if QFormaPagoFORMA.Value = 'EFE' then
          Forma := 'Efectivo .: '
        else if QFormaPagoFORMA.Value = 'TAR' then
          Forma := 'Tarjeta ..: '
        else if QFormaPagoFORMA.Value = 'CHE' then
          Forma := 'Cheque ...: '
        else if QFormaPagoFORMA.Value = 'DEV' then
          Forma := 'Nota de CR: '
        else if QFormaPagoFORMA.Value = 'BOC' then
          Forma := 'Club .....: '
        else if QFormaPagoFORMA.Value = 'OBO' then
          Forma := 'Ot. Bono .: '
        else if QFormaPagoFORMA.Value = 'CRE' then
          Forma := 'Credito ..: ';

        writeln(arch, Forma+s+Format('%n',[QFormaPagopagado.Value]));
        QFormaPago.Next;
      end;

      writeln(arch, ' ');

      if Credito = 'True' then
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
      writeln(arch, ' ');
      writeln(arch, ' ');
      if QDetalle.RecordCount > 0 then
      writeln(arch, 'Cantidad Articulos '+FormatCurr('#,0',QDetalle.RecordCount));
      writeln(arch, ' ');
      writeln(arch, ' ');

      Query1.close;
      Query1.SQL.clear;
      Query1.SQL.add('select PAR_TKMENSAJE1,PAR_TKMENSAJE2,PAR_TKMENSAJE3,');
      Query1.SQL.add('PAR_TKMENSAJE4,PAR_TKCLAVEDELETE,PAR_TKCLAVEMODIFICA');
      Query1.SQL.add('from parametros where emp_codigo = :emp');
      Query1.Parameters.ParamByName('emp').Value := empresainv;
      Query1.open;

      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE1').AsString));
      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE2').AsString));
      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE3').AsString));
      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE4').AsString));
      writeln(arch, ' ');

      if Trim(TarjetaClub) <> '' then
      begin
        Query1.close;
        Query1.SQL.clear;
        Query1.SQL.add('select par_punto_principal');
        Query1.SQL.add('FROM PARAMETROS');
        Query1.SQL.add('WHERE emp_codigo = :emp');
        Query1.Parameters.ParamByName('emp').Value := empresainv;
        Query1.Open;
        PuntosPrinc := Query1.fieldbyname('par_punto_principal').Value;
        FactorPrin  := (100/PuntosPrinc);
        Puntos      := trunc(QTickettotal.Value / FactorPrin);

        Query1.close;
        Query1.SQL.clear;
        Query1.SQL.add('select cli_balance_ptos from cliente_club');
        Query1.SQL.add('where cli_carnet_club = :tar');
        Query1.Parameters.parambyname('tar').Value := Trim(TarjetaClub);
        Query1.open;

        writeln(arch,'ESTA FACTURA ACUMULA '+inttostr(Puntos)+' Puntos.');
        writeln(arch,'USTED TIENE '+trim(Format('%10.2F',[query1.fieldbyname('cli_balance_ptos').asfloat]))+' ptos. en Total');
      end;

      if QTicketdescuento.Value > 0 then
      begin
        writeln(arch, ' ');
        writeln(arch, '    DESCUENTO APLICADO EN PRODUCTOS');
        writeln(arch, '----------------------------------------');
        writeln(arch, 'CANT DESCRIPCION               DESCUENTO');
        writeln(arch, '----------------------------------------');
        QDetalle.First;
        TFac := 0;
        while not QDetalle.eof do
        begin
          if QDetalledescuento.value > 0 then
          begin
            if QDetalleitbis.value > 0 then
            begin
              NumItbis := strtofloat(format('%10.2f',[(QDetalleitbis.value/100)+1]));
              Venta    := strtofloat(format('%10.4f',[(QDetalleprecio.value)/NumItbis]));

              TotalDescuento := ((Venta * QDetalledescuento.Value) / 100) * QDetallecantidad.Value;
            end
            else
            begin
              Venta := strtofloat(format('%10.2f',[QDetalleprecio.value]));
              TotalDescuento := ((Venta * QDetalledescuento.Value) / 100) * QDetallecantidad.Value;
            end;

            s := '';
            FillChar(s, 4-length(floattostr(QDetallecantidad.value)),' ');
            s1 := '';
            FillChar(s1, 8-length(trim(FORMAT('%n',[QDetalleValor.value]))), ' ');
            s2 := '';
            FillChar(s2, 28-length(copy(trim(QDetalledescripcion.value),1,28)),' ');
            s3 := '';
            FillChar(s3, 8-length(trim(FORMAT('%n',[QDetallePrecioItbis.value]))),' ');
            s4 := '';
            FillChar(s4, 8-length(trim(FORMAT('%n',[TotalDescuento]))),' ');


            writeln(arch, floattostr(QDetallecantidad.value)+s+
                          copy(trim(QDetalledescripcion.value),1,28)+s2+s4+FORMAT('%n',[TotalDescuento]));

            TFac := TFac + TotalDescuento;
          end;
          QDetalle.next;
        end;
        s := '';
        FillChar(s, 14-length(trim(format('%n',[TFac]))),' ');

        writeln(arch, '----------------------------------------');
        writeln(arch, 'TOTAL DESCUENTO           '+s+format('%n',[TFac]));
      end;

      if CantBoletos > 0 then
      begin
        writeln(arch, ' ');
        writeln(arch, '----------------------------------------');
        writeln(arch, '      CANTIDAD DE BOLETOS GANADOS');
        writeln(arch, '----------------------------------------');
        writeln(arch, dm.Centro(IntToStr(CantBoletos)));
      end;

      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');

     
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_ip');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
      dm.Query1.Open;
      codigoabre := dm.Query1.FieldByName('codigo_abre_caja').AsString;


      if codigoabre = 'Termica' then
        writeln(arch,chr(27)+chr(109));

      closefile(Arch);
      //dm.Imp40Columnas(arch);
      winexec('.\imp.bat',0);



      if Reimprimiendo = 'N' then
      begin
        if Credito = 'True' then
        begin
           MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);
         winexec('.\imp.bat',0);
        end;
      end;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select * from formas_pago_ticket');
      dm.Query1.SQL.Add('where isnull(for_veriphone_desc,'+QuotedStr('')+')<>'+QuotedStr(''));
      DM.Query1.SQL.Add('and ticket = :tik and fecha = :fec and forma = '+QuotedStr('TAR'));
      DM.Query1.SQL.Add('and usu_codigo = :usu and caja = :caj');
      DM.Query1.Parameters.ParamByName('tik').DataType := ftInteger;
      DM.Query1.Parameters.ParamByName('fec').DataType := ftDate;
      DM.Query1.Parameters.ParamByName('usu').DataType := ftInteger;
      DM.Query1.Parameters.ParamByName('caj').DataType := ftInteger;

      DM.Query1.Parameters.ParamByName('tik').Value := QTicketticket.Value;
      DM.Query1.Parameters.ParamByName('fec').Value := QTicketfecha.Value;
      DM.Query1.Parameters.ParamByName('usu').Value := QTicketusu_codigo.Value;
      DM.Query1.Parameters.ParamByName('caj').Value := QTicketcaja.Value;
      DM.Query1.Open;

      IF DM.Query1.IsEmpty THEN vp_verifone := False ELSE vp_verifone := True;

      if vp_verifone = True then begin
      CASE Impresora.IDPrinter OF
                        0 : {NORMAL}               ImpTicketCardNet;
                        1 : {EPSON (TMU-220)}      ImpTicketFiscalCardNet(impresora.copia);
								        2 : {CITIZEN ( CT-S310 )}  ImpTicketVmaxFiscalCardNet(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
								        3 : {CITIZEN (GSX-190)}    ImpTicketVmaxFiscalCardNet(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
                        4 : {STAR (TSP650FP)}      ImpTicketVmaxFiscalCardNet(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
                        //5 : {Bixolon SRP-350iiHG}  ImpTicketFiscalBixolon(Impresora);
      end;
      end;


     
    end;

procedure TfrmMain.QTicketCalcFields(DataSet: TDataSet);
begin
QTicketNCF.Value := QTicketNCF_Fijo.Value+FormatFloat('00000000',QTicketNCF_Secuencia.Value);
end;

procedure TfrmMain.pnreimprimirClick(Sender: TObject);
begin
  if QTickettotal.Value > 0 then
  begin
    MessageDlg('DEBE COMPLETAR EL TICKET ANTES, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      edproducto.SetFocus;
    end
    else
    begin
      Reimprimiendo := 'S';
      Application.CreateForm(tfrmAnular, frmAnular);
      frmAnular.Caption := 'REIMPRIMIR TICKET';
      frmAnular.btanular.Visible := False;

      frmAnular.QTicket.SQL.Add('order by fecha desc, ticket desc');
      frmAnular.QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
      frmAnular.QTicket.Parameters.ParamByName('fec1').DataType := ftDateTime;
      frmAnular.QTicket.Parameters.ParamByName('fec1').Value    := frmAnular.hora1.DateTime;
      frmAnular.QTicket.Parameters.ParamByName('fec2').DataType := ftDateTime;
      frmAnular.QTicket.Parameters.ParamByName('fec2').Value    := frmAnular.hora2.DateTime;
      frmAnular.QTicket.Parameters.ParamByName('caj').Value     := StrToInt(edcaja.Caption);
      frmAnular.QTicket.Open;
      frmAnular.ShowModal;

      if frmAnular.Imprimir = 1 then
      begin
        QTicket.DisableControls;
        QTicket.Close;
        if forma_numeracion = 1 then
        begin
          QTicket.SQL.Clear;
          QTicket.SQL.Add(SQLFormaNumeracion1);
          QTicket.Parameters.ParamByName('fec').DataType := ftDate;
          QTicket.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
          QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        QTicket.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
        QTicket.Open;
        MovTicket := QTicketmov_numero.Value;

        QDetalle.DisableControls;
        QDetalle.Close;
        if forma_numeracion = 1 then
        begin
          QDetalle.SQL.Clear;
          QDetalle.SQL.Add('select usu_codigo, fecha, ticket, secuencia,');
          QDetalle.SQL.Add('hora, producto, descripcion, cantidad, precio,');
          QDetalle.SQL.Add('empaque, itbis, Costo, caja, descuento,');
          QDetalle.SQL.Add('devuelta, Realizo_Oferta, Oferta,');
          QDetalle.SQL.Add('Patrocinador, fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo,');
          QDetalle.SQL.Add('col_codigo, mar_codigo');
          QDetalle.SQL.Add('from ticket');
          QDetalle.SQL.Add('where caja = :caj');
          QDetalle.SQL.Add('and ticket = :tik');
          QDetalle.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QDetalle.SQL.Add('and usu_codigo = :usu');
          QDetalle.SQL.Add('order by secuencia desc');
          QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
          QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        QDetalle.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
        QDetalle.Open;

        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
        QFormaPago.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
        QFormaPago.Open;

        if QFormaPago.Locate('forma','CRE',[]) then credito := 'True' else credito := 'False';

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select sum(pagado) as pagado from formas_pago_ticket');
        dm.Query1.SQL.Add('where caja = :caj');
        dm.Query1.SQL.Add('and ticket = :tik');
        if forma_numeracion = 1 then
        begin
          dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          dm.Query1.SQL.Add('and usu_codigo = :usu');
          dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
          dm.Query1.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
          dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        dm.Query1.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
        dm.Query1.Open;
        MPagado := dm.Query1.FieldByName('pagado').AsFloat;

        QTicket.EnableControls;
        QDetalle.EnableControls;

        Boletos;
        if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;


        TicketNuevo(true);
        //ImpTicketNorma201806;
        IniciaDisplay;
      end;
      frmAnular.Release;
      edproducto.SetFocus;
    end;
    frmAcceso.Release;
  end;
end;


procedure TfrmMain.pnabrircajaClick(Sender: TObject);
var
  arch : textfile;
  codigo, cod, abrir: string;
  a : integer;
  lista : tstrings;
begin
Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    puedeAbrirCaja := dm.Query1.RecordCount > 0;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      DisplayTotal;
      edproducto.SetFocus;
    end
    else
    begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
  dm.Query1.Open;
  codigo := dm.Query1.FieldByName('codigo_abre_caja').AsString;
  puerto := dm.Query1.FieldByName('Puerto').AsString;

  if Impresora.IDPrinter = 1 then begin
  if puedeAbrirCaja then
  OpenCashDrawerFiscal(Impresora)
  end
  else
    begin
      if codigo = 'TMU' then
      begin
        assignfile(arch,'.\caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(27)+chr(112)+chr(0)+chr(25)+chr(250));
        closefile(arch);
      end
      else if codigo = 'Termica' then
      begin
        assignfile(arch,'.\caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(27)+chr(112)+chr(0)+chr(50)+chr(250));
        writeln(arch,chr(27)+chr(7));
        closefile(arch);
      end
      else if codigo = 'Star' then
      begin
        assignfile(arch,'.\caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(28));
        closefile(arch);
      end;


      assignfile(arch,'.\caja.bat');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch,'type .\caja.txt > '+puerto);
      closefile(arch);

      winexec('.\caja.bat',0);
    end;
  edproducto.SetFocus;

end;
end;



procedure TfrmMain.edcantidadKeyPress(Sender: TObject; var Key: Char);

begin
  if key = #13 then
  begin
    if (Pos('.',edCantidad.text) = 0) and (Length(edCantidad.Text) > 3) then
    begin
      edCantidad.Text := '1';
      key := #0;
      edCantidad.SetFocus;
    end
    else
    begin
      edproducto.SetFocus;
      key := #0;
    end;
end;
end;

procedure TfrmMain.pncuadreClick(Sender: TObject);
begin
  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
  frmAcceso.ShowModal;
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
  dm.Query1.SQL.Add('where clave = :cla');
  DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
  dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    Application.CreateForm(tfrmCuadre, frmCuadre);
    frmCuadre.caja := StrToInt(edcaja.Caption);
    frmCuadre.ShowModal;
    frmCuadre.Release;
  end;
end;

procedure TfrmMain.pncreditoClick(Sender: TObject);
var
  ano, mes, dia : word;
  num, diasvence, periodo, sec, descuentocxc : integer;
  vence : tdatetime;
  ncf_fijo, tdo : string;
  
begin
  if QTickettotal.Value > 0 then
  begin
    if (TipoComprobante <> 1) and (Trim(QTicketrnc.Value) = '') then
    begin
      MessageDlg('DEBE DIGITAR EL RNC, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      edproducto.SetFocus;
    end
    else
    begin
      Query1.close;
      Query1.sql.clear;
      Query1.sql.add('select par_genera_puntos_credito from parametros');
      Query1.sql.add('where emp_codigo = '+IntToStr(QTicketemp_codigo.Value));
      Query1.Open;
      if Query1.FieldByName('par_genera_puntos_credito').AsString = 'True' then
      begin
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select top 1 cli_codigo from cliente_club');
        dm.Query1.Open;
        if dm.Query1.RecordCount > 0 then
          tarjetaclub := InputBox('TARJETA CLUB','TARJETA CLUB','');

      end;

      Application.CreateForm(tfrmClientes, frmClientes);
      frmClientes.total := QTickettotal.value;
      if SeleccionTipo = 'CRE' then
      begin
        frmClientes.ActiveControl := frmClientes.DBGrid1;
        frmClientes.QClientes.Close;
        frmClientes.QClientes.SQL.Clear;
        frmClientes.QClientes.SQL.Add('select');
        frmClientes.QClientes.SQL.Add('distinct emp_codigo, cli_codigo, cli_nombre, cli_rnc, cli_cedula, cli_direccion,cli_localidad,');
        frmClientes.QClientes.SQL.Add('isnull(cli_limite,0) as cli_limite, cli_balance, emp_numero, cli_telefono, tfa_codigo,');
        frmClientes.QClientes.SQL.Add('cli_facturarbce, cli_facturarvencida, Aumento');
        frmClientes.QClientes.SQL.Add('from clientes');
        frmClientes.QClientes.SQL.Add('where cli_codigo = '+IntToStr(SeleccionCliente));
        frmClientes.QClientes.SQL.Add('and emp_codigo = '+IntToStr(SeleccionEmpresa));
        frmClientes.QClientes.SQL.Add('order by cli_nombre');
        frmClientes.QClientes.Open;
      end;
      frmClientes.ShowModal;
      credito := 'False';
      if frmClientes.Seleccion = 1 then
      begin
        empresa := frmClientes.QClientesemp_codigo.Value;
        cliente := frmClientes.QClientescli_codigo.Value;
        NombreCliente := frmClientes.QClientescli_nombre.Value;
        if Trim(frmClientes.qclientescli_rnc.Value) <> '' then
          rncCliente  := frmClientes.qclientescli_rnc.Value
        else
          rncCliente  := frmClientes.QClientescli_cedula.Value;

        QTicket.Edit;
        QTicketNCF_Tipo.Value := TipoComprobante;
        QTicketnombre.Value   := NombreCliente;
        QTicketrnc.Value      := rncCliente;
        QTicketstatus.Value   := 'FAC';
        if tarjetaclub <> '' then
          QTicketsorteo.Value := tarjetaclub;

       //buscando la empresa que tiene la caja en ese momento
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select emp_codigo from cajas_ip where ip = :ip ');
      dm.Query1.Parameters.ParamByName('ip').Value := IPCaja;
      dm.Query1.Open;
      //empresa := dm.Query1.FieldByName('emp_codigo').Value;
      //empcaja := dm.Query1.FieldByName('emp_codigo').Value;
      empcomprobante := dm.Query1.FieldByName('emp_codigo').Value;
      
        {if empcomprobante > 0 then
        QTicketemp_codigo.value := empcomprobante else
        QTicketemp_codigo.Value := dm.QEmpresaemp_codigo.Value;
         }


        if TipoComprobante = 1 then
        begin
          //Verificando si tiene comprobante especifico para esa caja
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select count(*) as cantidad from ncf_ticket where caja = :caj');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.Open;
          if Query1.FieldByName('cantidad').AsInteger > 0 then
          begin
            Query1.Close;
            Query1.SQL.Clear;
            Query1.SQL.Add('select NCF_Fijo, NCF_Secuencia from ncf_ticket with (HOLDLOCK)');
            Query1.SQL.Add('where caja = :caj');
            Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
            Query1.Open;

            if not Query1.FieldByName('NCF_Fijo').IsNull then
            begin
              QTicketNCF_Fijo.Value      := Query1.FieldByName('NCF_Fijo').Value;
              QTicketNCF_Secuencia.Value := Query1.FieldByName('NCF_Secuencia').Value;
            end;
          end
          else
          begin
            ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
            ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
            ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
            ProcNCF.ExecProc;

            if ProcNCF.Parameters[4].Value <> null then
            begin
              QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
              QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
            end;
          end;
        end
        else
        begin
          ProcNCF.Parameters.ParamByName('@empcomprobante').Value := empcomprobante;
          ProcNCF.Parameters.ParamByName('@tipo').Value := TipoComprobante;
          ProcNCF.Parameters.ParamByName('@caja').Value := StrToInt(edcaja.Caption);
          ProcNCF.ExecProc;

          if ProcNCF.Parameters[4].Value <> null then
          begin
            QTicketNCF_Fijo.Value      := ProcNCF.Parameters[4].Value;
            QTicketNCF_Secuencia.Value := ProcNCF.Parameters[5].Value;
          end;
        end;

        QTicket.Post;
       QTicket.UpdateBatch;

        QFormaPago.Close;
        if forma_numeracion = 1 then
        begin
          QFormaPago.Close;
          QFormaPago.SQL.Clear;
          QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
          QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
          QFormaPago.SQL.Add('from formas_pago_ticket');
          QFormaPago.SQL.Add('where caja = :caj');
          QFormaPago.SQL.Add('and ticket = :tik');
          QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
          QFormaPago.SQL.Add('and usu_codigo = :usu');
          QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
          QFormaPago.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
          QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
        end;
        QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
        QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        QFormaPago.Open;

        QFormaPago.Append;
        QFormaPagocaja.Value       := StrToInt(edcaja.Caption);
        QFormaPagousu_codigo.Value := dm.Usuario;
        QFormaPagofecha.Value      := DM.getFechaServidor;
        QFormaPagoticket.Value     := QTicketticket.Value;
        QFormaPagoforma.Value      := 'CRE';
        QFormaPagopagado.Value     := QTickettotal.Value;
        QFormaPagodevuelta.Value   := 0;
        QFormaPagocredito.Value    := 'True';
        QFormaPagocliente.Value    := cliente;
        QFormaPagoempresa.Value    := empresa;
        QFormaPago.Post;
        QFormaPago.UpdateBatch;

        if TipoComprobante = 1 then
        begin
          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('update ncf_ticket set NCF_Secuencia = NCF_Secuencia + 1');
          Query1.SQL.Add('where caja = :caj');
          Query1.Parameters.ParamByName('caj').Value := StrToInt(Trim(edcaja.Caption));
          Query1.ExecSQL;
        end;

        credito := 'True';
        decodedate (date, ano, mes, dia);

        Query1.close;
        Query1.sql.clear;
        Query1.sql.add('select isnull(max(mov_numero),0) as maximo');
        Query1.sql.add('from movimientos where emp_codigo = :emp');
        Query1.sql.add('and mov_tipo = '+#39+'TK'+#39);
        Query1.Parameters.parambyname('emp').Value := empresa;
        Query1.open;
        MovTicket := query1.FieldByName('maximo').AsInteger + 1;

        Query1.close;
        Query1.sql.clear;
        Query1.sql.add('select max(mov_secuencia) as maximo');
        Query1.sql.add('from movimientos where emp_codigo = :emp');
        Query1.sql.add('and mov_tipo = '+#39+'TK'+#39);
        Query1.Parameters.parambyname('emp').Value := empresa;
        Query1.open;
        num := query1.FieldByName('maximo').AsInteger + 1;

        Query1.close;
        Query1.sql.clear;
        Query1.sql.add('select cpa_dias from condiciones');
        Query1.sql.add('where emp_codigo = '+inttostr(empresa));
        Query1.sql.add('and cpa_codigo in (select cpa_codigo from clientes');
        Query1.sql.add('where emp_Codigo = :emp and cli_codigo = :cli)');
        Query1.Parameters.ParamByName('emp').Value := empresa;
        Query1.Parameters.ParamByName('cli').Value := cliente;
        Query1.Open;
        diasvence := query1.FieldByName('cpa_dias').AsInteger;

        vence := DM.getFechaServidor + diasvence;

        //Inseretando en movimientos
        Query1.close;
        Query1.sql.clear;
        Query1.sql.add('insert into movimientos(emp_codigo,suc_codigo,');
        Query1.sql.add('mov_tipo, mov_numero, mov_fecha, mov_monto,');
        Query1.sql.add('mov_abono, mov_status, cli_codigo, ');
        Query1.sql.add('mov_secuencia, fac_forma, tfa_codigo, MOV_FECHAVENCE, mon_codigo, mov_tasa)');
        Query1.sql.add('values (:emp, :suc,'+#39+'TK'+#39+', :num, :fecha, :total,');
        Query1.sql.add('0, '+#39+'PEN'+#39+', :cliente, :sec, '+#39+'X'+#39+', 0, :vence, 1, 1)');
        Query1.Parameters.parambyname('cliente').Value := cliente;
        Query1.Parameters.parambyname('fecha').Value   := DM.getFechaServidor;
        Query1.Parameters.parambyname('total').Value   := QTickettotal.Value;
        Query1.Parameters.parambyname('emp').Value     := QTicketemp_codigo.Value;
        Query1.Parameters.parambyname('suc').Value     := QTicketsuc_codigo.Value;
        Query1.Parameters.parambyname('num').Value     := MovTicket;
        Query1.Parameters.parambyname('sec').Value     := num;
        Query1.Parameters.parambyname('vence').Value   := vence;
        Query1.ExecSQL;

        //actualizando balance del cliente
        Query1.close;
        Query1.sql.clear;
        Query1.sql.add('update clientes set cli_balance = cli_balance + :monto');
        Query1.sql.add('where cli_codigo = :cliente');
        Query1.sql.add('and emp_codigo = :compania');
        Query1.Parameters.parambyname('cliente').Value  := cliente;
        Query1.Parameters.parambyname('monto').Value    := QTickettotal.Value;
        Query1.Parameters.parambyname('compania').Value := empresa;
        Query1.ExecSQL;

        QTicket.Edit;
        QTicketmov_numero.Value := MovTicket;
        QTicket.Post;
       QTicket.UpdateBatch;

        //Si es un empleado
        if not frmClientes.QClientesemp_numero.IsNull then
        begin
          Query1.close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select par_tipo_descuento_cxc from Param_RHumanos where emp_codigo = :emp');
          Query1.Parameters.ParamByName('emp').Value := empresa;
          Query1.Open;
          descuentocxc := Query1.FieldByName('par_tipo_descuento_cxc').AsInteger;

          decodedate(QTicketfecha.Value+diasvence, ano, mes, dia);

          if dia <= 15 then periodo := 1 else periodo := 2;

          Query1.close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select isnull(max(des_codigo),0) as maximo from descuentos where emp_codigo = :emp');
          Query1.Parameters.ParamByName('emp').Value := empresa;
          Query1.Open;
          sec := query1.FieldByName('maximo').AsInteger + 1;

          Query1.Close;
          Query1.SQL.Clear;
          Query1.SQL.Add('insert into descuentos (emp_codigo,des_codigo,emp_numero,tde_codigo,des_fecha,des_valor,');
          Query1.SQL.Add('des_fijo_variable,des_porcentual,des_interes,des_cuotas,');
          Query1.SQL.Add('des_periodo_descuento,des_monto_pagado,des_cuotas_pagadas,des_status,mov_tipo,mov_numero)');
          Query1.SQL.Add('values (:emp, :sec, :num, :des, :fec, :val,');
          Query1.SQL.Add(QuotedStr('V')+','+QuotedStr('False')+',0,0,');
          Query1.SQL.Add(inttostr(periodo)+',0,0,'+QuotedStr('EMI')+',:tip, :mov)');
          Query1.Parameters.ParamByName('emp').Value    := empresa;
          Query1.Parameters.ParamByName('sec').Value    := sec;
          Query1.Parameters.ParamByName('num').Value    := frmClientes.QClientesemp_numero.Value;
          Query1.Parameters.ParamByName('des').Value    := descuentocxc;
          Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value+diasvence;
          Query1.Parameters.ParamByName('fec').DataType := ftdate;
          Query1.Parameters.ParamByName('val').Value    := QTickettotal.Value;
          Query1.Parameters.ParamByName('tip').Value    := 'TK';
          Query1.Parameters.ParamByName('mov').Value    := MovTicket;
          Query1.ExecSQL;
        end;

        if Trim(tarjetaclub) <> '' then
        begin
          Query1.close;
          Query1.sql.clear;
          Query1.sql.add('select par_genera_puntos_credito from parametros');
          Query1.sql.add('where emp_codigo = 1');
          Query1.Open;
          if Query1.FieldByName('par_genera_puntos_credito').AsString = 'True' then
          begin
            Query1.close;
            Query1.sql.clear;
            Query1.sql.add('EXECUTE PR_ACUMULA_PUNTOS :emp, :TARJETA, :MONTO');
            Query1.Parameters.ParamByName('emp').Value     := 1;
            Query1.Parameters.ParamByName('tarjeta').Value := tarjetaclub;
            Query1.Parameters.parambyname('monto').Value   := QTickettotal.Value;
            Query1.ExecSQL;
          end;
        end;

        if ImprimeCredito = 'True' then ImpTicket
        else
          MessageDlg('DEBE PASAR POR SERVICIO AL CLIENTE PARA IMPRIMIR LA FACTURA',mtInformation,[mbok],0);

        //pnabrircajaClick(Self);

        TicketNuevo(true);
        IniciaDisplay;
      end;
      frmClientes.Release;
    end;
  end;
  edproducto.SetFocus;
end;

procedure TfrmMain.Panel25Click(Sender: TObject);
begin
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      edproducto.SetFocus;
    end
    else
    begin
      Application.CreateForm(tfrmConfig, frmConfig);
      frmConfig.ShowModal;
      frmConfig.Release;
    end;
end;

procedure TfrmMain.SeleccionaBoton(bt: TObject);
begin
  if Trim((bt as TStaticText).Caption) <> '' then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select p.pro_roriginal from botones_caja b, productos p');
    dm.Query1.SQL.Add('where boton = '+QuotedStr((bt as TStaticText).Name));
    dm.Query1.SQL.Add('and b.producto = p.pro_codigo');
    dm.Query1.SQL.Add('and p.emp_codigo = :emp');
    dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
    dm.Query1.Open;

    Precio := 0;
    edproducto.Text := dm.Query1.FieldByName('pro_roriginal').AsString;
    UltProd := edproducto.Text;
    BuscaProducto(edproducto.Text);
    if MDLista.RecordCount >  0 then begin
    if ((MDLista.Locate('LProducto',IntToStr(GetProducto),[])) and
      (dm.QParametrosPAR_FACREPITEPROD.Value = 'False')) then
      begin
        //MessageDlg('ESTE PRODUCTO ESTA INCLUIDO EN ESTA FACTURA',mtError,[mbok],0);
        qDetalle.Locate('Producto',IntToStr(GetProducto),[]);
        qDetalle.Edit;
        qDetallecantidad.Value := qDetallecantidad.Value + 1;
        qDetalle.Post;
        qDetalle.UpdateBatch;
        //Abort;
      end
      else
      begin
      InsertaProducto;
      end;
      end
      else
      InsertaProducto;
  end
  else
    edproducto.SetFocus;
end;

procedure TfrmMain.boton1Click(Sender: TObject);
begin
  SeleccionaBoton(Sender);
end;

procedure TfrmMain.pndescuentoClick(Sender: TObject);
var
  t : TBookmark;
begin
  if QTickettotal.Value > 0 then
  begin
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
    dm.Query1.SQL.Add('where clave = :cla');
    DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      edproducto.SetFocus;
    end
    else
    begin
      Application.CreateForm(tfrmDesccuento, frmDesccuento);
      frmDesccuento.QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
      frmDesccuento.QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
      frmDesccuento.QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
      frmDesccuento.QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      frmDesccuento.QDetalle.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
      frmDesccuento.QDetalle.Open;
      frmDesccuento.ShowModal;

      t := QDetalle.GetBookmark;
      QDetalle.DisableControls;
      QDetalle.Close;
      QDetalle.Open;
      QDetalle.GotoBookmark(t);
      QDetalle.EnableControls;

      Totaliza;

      frmDesccuento.Release;
       AplicaDescPorRangoVta(QTickettotal.Value);
    end;
    frmAcceso.Release;
  end
  else
    edproducto.SetFocus;
end;

procedure TfrmMain.pnunidadClick(Sender: TObject);
var
  realizar : boolean;
begin
  realizar := true;
  if ClaveEmp = 'True' then
  begin
    realizar := false;
    Application.CreateForm(tfrmAcceso, frmAcceso);
    frmAcceso.ShowModal;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select c.clave, u.usu_autoriza_venta_emp');
    dm.Query1.SQL.Add('from clave_supervisor_caja c, usuarios u');
    dm.Query1.SQL.Add('where c.clave = :cla');
    DM.Query1.SQL.Add('and U.usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
    dm.Query1.SQL.Add('and c.usu_codigo = u.usu_codigo');
    dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
    dm.Query1.Open;
    if dm.Query1.RecordCount = 0 then
    begin
      MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
      DisplayTotal;
      edproducto.SetFocus;
    end
    else if dm.Query1.FieldByName('usu_autoriza_venta_emp').AsString <> 'True' then
    begin
      MessageDlg('ESTE SUPERVISOR NO TIENE ACCESO A FACTURAR POR EMPAQUE',mtError,[mbok],0);
      DisplayTotal;
      edproducto.SetFocus;
    end
    else
      realizar := true;
  end;
  if realizar then
  begin
    if lbund.Caption = 'UNIDAD' then
      lbund.Caption := 'EMPAQUE'
    else
      lbund.Caption := 'UNIDAD';
  end;
  //end;
end;

procedure TfrmMain.pnreporteClick(Sender: TObject);
var
  arch, ptocaja : textfile;
  TotalDesgloce : Double;
  s, s1, s2 : array[0..100] of char;
begin
  {Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
  frmAcceso.ShowModal;
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
  dm.Query1.SQL.Add('where clave = :cla');
  dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
    edproducto.SetFocus;
  end
  else
  begin
    Application.CreateForm(tfrmReporteVentas, frmReporteVentas);
    frmReporteVentas.ShowModal;
    frmReporteVentas.Release;
  end;}
  edproducto.Text := '';
  Application.CreateForm(tfrmDesgloce, frmDesgloce);
  frmDesgloce.ShowModal;
  TotalDesgloce := 0;
  frmDesgloce.QMontos.First;
  frmDesgloce.QMontos.First;
  while not frmDesgloce.QMontos.Eof do
  begin
    TotalDesgloce := TotalDesgloce + frmDesgloce.QMontosValor.Value;
    frmDesgloce.QMontos.Next;
  end;
  if frmDesgloce.grabo = 1 then
  begin
    if TotalDesgloce > 0 then
    begin
      assignfile(arch,'contar.bat');
      {I-}
      rewrite(arch);
      {I+}

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select puerto from cajas_IP');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := StrToInt(edCaja.Caption);
      dm.Query1.Open;
      Puerto := dm.Query1.FieldByName('puerto').AsString;

      writeln(arch, 'type contar.txt > '+Puerto);
      closefile(arch);

      assignfile(arch,'contar.txt');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
      writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
      writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
      writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
      writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
      writeln(arch, ' ');
      writeln(arch, dm.centro('CONTEO DE EFECTIVO'));
      writeln(arch, ' ');
      writeln(arch, 'Fecha  : '+DateToStr(DM.getFechaServidor));
      writeln(arch, 'Cajero : '+edCajero.Caption);
      writeln(arch, 'Caja   : '+edCaja.Caption);
      writeln(arch, '');
      writeln(arch, '---------------------------------------');
      writeln(arch, '   M O N T O  CANTIDAD   V A L O R ');
      writeln(arch, '---------------------------------------');
      frmDesgloce.QMontos.First;
      while not frmDesgloce.QMontos.Eof do
      begin
        s := '';
        FillChar(s, 12-length(Format('%n',[frmDesgloce.QMontosmonto.AsFloat])),' ');
        s1 := '';
        FillChar(s1, 5-length(IntToStr(frmDesgloce.QMontoscantidad.AsInteger)),' ');
        s2 := '';
        FillChar(s2, 12-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat])),' ');

        writeln(arch, s+Format('%n',[frmDesgloce.QMontosmonto.AsFloat])+' '+s1+
               IntToStr(frmDesgloce.QMontoscantidad.AsInteger)+'        '+s2+
               Format('%n',[frmDesgloce.QMontosValor.AsFloat]));

        frmDesgloce.QMontos.Next;
      end;
      frmDesgloce.QMontos.First;
      s := '';
      FillChar(s, 27-length(Format('%n',[TotalDesgloce])),' ');

      writeln(arch, '---------------------------------------');
      writeln(arch, 'T O T A L  '+s+Format('%n',[TotalDesgloce]));
      writeln(arch, '');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, '____________________________');
      writeln(arch, 'Cajero');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, '____________________________');
      writeln(arch, 'Entregado por');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');

      closefile(arch);
      winexec('contar.bat',0);
    end;
  end;
  frmDesgloce.Release;
  edproducto.Text := '';
  edproducto.SetFocus;
end;


procedure TfrmMain.pnprecioClick(Sender: TObject);
var
  Prec : string;
begin
  if VerPrecio = 'True' then
  begin
    application.createform(tfrmVerPrecio, frmVerPrecio);
    frmVerPrecio.ShowModal;
    if frmVerPrecio.facturar = true then
    begin
      edproducto.Text := frmVerPrecio.prod;

      Precio := 0;
      BuscaProducto(edproducto.Text);
      InsertaProducto;
    end;
    frmVerPrecio.Release;
  end;
  //edproducto.SetFocus;
end;

procedure TfrmMain.Boletos;
var
  BolMonto, BolMontoPat : Double;
  BolCant, BolCantPat  : Integer;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select isnull(par_boletos_monto,0) as monto,');
  dm.Query1.SQL.Add('isnull(par_boletos_cantidad,0) as cantidad,');
  dm.Query1.SQL.Add('isnull(par_boletos_monto_patrocinador,0) as monto_pat,');
  dm.Query1.SQL.Add('isnull(par_boletos_cantidad_patrocinador,0) as cantidad_pat');
  dm.Query1.SQL.Add('from parametros where emp_codigo = :emp');
  dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
  dm.Query1.Open;
  BolMonto := dm.Query1.FieldByName('monto').AsFloat;
  BolCant  := dm.Query1.FieldByName('cantidad').AsInteger;
  BolMontoPat := dm.Query1.FieldByName('monto_pat').AsFloat;
  BolCantPat  := dm.Query1.FieldByName('cantidad_pat').AsInteger;
  CantBoletos := 0;
  if BolCant > 0 then
  begin
    if QTickettotal.Value >= BolMonto then
    begin
      CantBoletos := Trunc(QTickettotal.Value / BolMonto);
      if (BolCantPat > 0) and (lpatrocinador.Items.Count > 0) then
      begin
        if lpatrocinador.Items.Count <= CantBoletos then
          CantBoletos := CantBoletos+lpatrocinador.Items.Count
        else
          CantBoletos := CantBoletos+CantBoletos;
      end;
    end;
  end;
end;

procedure TfrmMain.pncopiaClick(Sender: TObject);
begin
  if Trim(UltProd) <> '' then
  begin
    edproducto.Text := UltProd;
    BuscaProducto(UltProd);
    InsertaProducto;
  end;
  edproducto.Text := '';
  Application.ProcessMessages;
  edproducto.SetFocus;
end;

procedure TfrmMain.pndepositoClick(Sender: TObject);
var
  arch, ptocaja : textfile;
  TotalDesgloce : Double;
  s, s1, s2 : array[0..100] of char;
begin
  edproducto.Text := '';
  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
  frmAcceso.ShowModal;
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
  dm.Query1.SQL.Add('where clave = :cla');
  dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
  end
  else
  begin
    Application.CreateForm(tfrmDesgloce, frmDesgloce);
    frmDesgloce.ShowModal;
    TotalDesgloce := 0;
    frmDesgloce.QMontos.First;
    frmDesgloce.QMontos.First;
    while not frmDesgloce.QMontos.Eof do
    begin
      TotalDesgloce := TotalDesgloce + frmDesgloce.QMontosValor.Value;
      frmDesgloce.QMontos.Next;
    end;
    if frmDesgloce.grabo = 1 then
    begin
      if TotalDesgloce > 0 then
      begin
        QCuadre.Close;
        QCuadre.Parameters.ParamByName('caj').Value := StrToInt(edcaja.Caption);
        QCuadre.Parameters.ParamByName('usu').Value := dm.Usuario;
        QCuadre.Parameters.ParamByName('fec').DataType := ftDate;
        QCuadre.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
        QCuadre.Open;
        if QCuadre.RecordCount > 0 then
          QCuadre.Edit
        else
        begin
          QCuadre.Insert;
          QCuadrefecha.Value := DM.getFechaServidor;
          QCuadrecaja.Value  := StrToInt(edcaja.Caption);
          QCuadreusu_codigo.Value := dm.Usuario;
          QCuadrefecha_hora.Value := DM.getFechaServidor2;
        end;
        QCuadrefecha_hora.Value := DM.getFechaServidor2;
        QCuadreefectivo_asignado.Value := TotalDesgloce;
        QCuadrecheque_cajero.Value     := 0;
        QCuadreefectivo_cajero.Value   := 0;
        QCuadretarjeta_cajero.Value    := 0;
        QCuadreefectivo_total.Value    := 0;
        QCuadrecheque_total.Value      := 0;
        QCuadretarjeta_total.Value     := 0;
        QCuadrebonosclub_total.Value   := 0;
        QCuadrebonosotros_total.Value  := 0;
        QCuadre.Post;
        QCuadre.UpdateBatch;

        assignfile(arch,'deposito.bat');
        {I-}
        rewrite(arch);
        {I+}

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select puerto from cajas_IP');
        dm.Query1.SQL.Add('where caja = :caj');
        dm.Query1.Parameters.ParamByName('caj').Value := StrToInt(edCaja.Caption);
        dm.Query1.Open;
        Puerto := dm.Query1.FieldByName('puerto').AsString;

        writeln(arch, 'type deposito.txt > '+Puerto);
        closefile(arch);

        assignfile(arch,'deposito.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
        writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
        writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
        writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
        writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
        writeln(arch, ' ');
        writeln(arch, dm.centro('DEPOSITO EN CAJA'));
        writeln(arch, ' ');
        writeln(arch, 'Fecha  : '+DateToStr(DM.getFechaServidor));
        writeln(arch, 'Cajero : '+edCajero.Caption);
        writeln(arch, 'Caja   : '+edCaja.Caption);
        writeln(arch, '');
        writeln(arch, '---------------------------------------');
        writeln(arch, '   M O N T O  CANTIDAD   V A L O R ');
        writeln(arch, '---------------------------------------');
        frmDesgloce.QMontos.First;
        while not frmDesgloce.QMontos.Eof do
        begin
          s := '';
          FillChar(s, 12-length(Format('%n',[frmDesgloce.QMontosmonto.AsFloat])),' ');
          s1 := '';
          FillChar(s1, 5-length(IntToStr(frmDesgloce.QMontoscantidad.AsInteger)),' ');
          s2 := '';
          FillChar(s2, 12-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat])),' ');

          writeln(arch, s+Format('%n',[frmDesgloce.QMontosmonto.AsFloat])+' '+s1+
                 IntToStr(frmDesgloce.QMontoscantidad.AsInteger)+'        '+s2+
                 Format('%n',[frmDesgloce.QMontosValor.AsFloat]));

          frmDesgloce.QMontos.Next;
        end;
        frmDesgloce.QMontos.First;
        s := '';
        FillChar(s, 27-length(Format('%n',[TotalDesgloce])),' ');

        writeln(arch, '---------------------------------------');
        writeln(arch, 'T O T A L  '+s+Format('%n',[TotalDesgloce]));
        writeln(arch, '');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, '____________________________');
        writeln(arch, 'Cajero');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, '____________________________');
        writeln(arch, 'Supervisor de Caja');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');
        writeln(arch, ' ');

        closefile(arch);
        winexec('deposito.bat',0);
      end;
    end;
    frmDesgloce.Release;
  end;
  frmAcceso.Release;
  edproducto.Text := '';
  edproducto.SetFocus;
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WinClassName := 'DASHA POS';
end;

procedure TfrmMain.RestoreRequest(var message: TMessage);
begin
   if IsIconic(Application.Handle) = TRUE then
     Application.Restore
   else
     Application.BringToFront;
end;

procedure TfrmMain.pndomicilioEnter(Sender: TObject);
begin
  edproducto.SetFocus;
end;

procedure TfrmMain.pntemporalClick(Sender: TObject);
var
  realizar : boolean;
begin
  if QDetalle.RecordCount = 0 then
  begin
    if QTickettotal.Value = 0 then
    begin
      realizar := true;
      if ClaveTemp = 'True' then
      begin
        realizar := false;
        Application.CreateForm(tfrmAcceso, frmAcceso);
        frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
        frmAcceso.ShowModal;
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
        dm.Query1.SQL.Add('where clave = :cla');
        DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
        dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
        dm.Query1.Open;
        if dm.Query1.RecordCount = 0 then
        begin
          MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
          edproducto.SetFocus;
        end
        else
          realizar := true;
      end;
      if realizar then
      begin
        Application.CreateForm(tfrmBuscaTemporal, frmBuscaTemporal);
        frmBuscaTemporal.QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
        frmBuscaTemporal.QTicket.Parameters.ParamByName('fec').DataType := ftDateTime;
        frmBuscaTemporal.QTicket.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
        frmBuscaTemporal.QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
        frmBuscaTemporal.QTicket.Open;
        if frmBuscaTemporal.QTicket.RecordCount = 0 then
          MessageDlg('NO HAY TICKETS GUARDADOS TEMPORALMENTE, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0)
        else
        begin
          frmBuscaTemporal.QDetalle.Open;
          frmBuscaTemporal.ShowModal;
          if frmBuscaTemporal.seleccion = 1 then
          begin
            QTicket.Close;
            if forma_numeracion = 1 then
            begin
              QTicket.Parameters.ParamByName('fec').DataType := ftDate;
              QTicket.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
              QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
            end;
            QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
            QTicket.Parameters.ParamByName('tik').Value    := frmBuscaTemporal.QTicketticket.Value;
            QTicket.Open;

            QTicket.Edit;
            QTicketstatus.Value := 'ABI';
            QTicket.Post;
          QTicket.UpdateBatch;

            edticket.Caption := QTicketticket.AsString;

            if not QTicketNCF_Tipo.IsNull then
              TipoComprobante := QTicketNCF_Tipo.AsInteger
            else
             TipoComprobante :=1;

            credito       := 'False';

            QDetalle.Close;
            if forma_numeracion = 1 then
            begin
              QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
              QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
              QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
            end;
            QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
            QDetalle.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
            QDetalle.Open;

            QFormaPago.Close;
            if forma_numeracion = 1 then
            begin
              QFormaPago.SQL.Clear;
              QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
              QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
              QFormaPago.SQL.Add('from formas_pago_ticket');
              QFormaPago.SQL.Add('where caja = :caj');
              QFormaPago.SQL.Add('and ticket = :tik');
              QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
              QFormaPago.SQL.Add('and usu_codigo = :usu');
              QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
              QFormaPago.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
              QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
            end;
            QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
            QFormaPago.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
            QFormaPago.Open;

            SeleccionTipo := '';
            SeleccionCliente := 0;
            SeleccionEmpresa := 0;
            Aumento := 0;
          // OJO   edcliente.Caption := '';
            cliente := 0;

            totaliza;
             AplicaDescPorRangoVta(QTickettotal.Value);
          end;
        end;
        frmBuscaTemporal.Release;
      end;
    end
    else
      MessageDlg('DEBE TERMINAR ESTA VENTA ANTES DE BUSCAR EL TICKET TEMPORAL,'+#13+
      'PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
  end
  else
  begin
    if QTickettotal.Value > 0 then
    begin
      realizar := true;
      if ClaveTemp = 'True' then
      begin
        realizar := false;
        Application.CreateForm(tfrmAcceso, frmAcceso);
        frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
        frmAcceso.ShowModal;
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select clave from clave_supervisor_caja');
        dm.Query1.SQL.Add('where clave = :cla');
        DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
        dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
        dm.Query1.Open;
        if dm.Query1.RecordCount = 0 then
        begin
          MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
          edproducto.SetFocus;
        end
        else
          realizar := true;
      end;
      if realizar then
      begin
        QTicket.Edit;
        QTicketstatus.Value := 'TMP';
        QTicket.Post;
     QTicket.UpdateBatch;

      if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;

      TicketNuevo(true);
     // ImpTicketNorma201806;
        IniciaDisplay;
      end;
    end;
    edproducto.SetFocus;
  end;

  edproducto.SetFocus;
end;

procedure TfrmMain.dsTicketStateChange(Sender: TObject);
begin
  if dsTicket.State = dsInsert then
    pntemporal.Caption := '[CTRL+T] BUSCAR TMP'
  else
    pntemporal.Caption := '[CTRL+G] GRABAR TMP';
end;

procedure TfrmMain.IniciaDisplay;
var
  arch : textfile;
begin
  try
   // RUTINA PARA INICIALIZAR EL DISPLAY
   assignfile(arch,'T.txt');
   rewrite(arch);
   writeln(arch, chr(27)+CHR(81)+CHR(65)+copy(dm.QEmpresaemp_nombre.AsString,1,18));
   writeln(arch, chr(27)+CHR(81)+CHR(66)+'TECNOLOGIA SIN LIMITES!!');
   closefile(Arch);

   assignfile(arch,'setea.bat');
   rewrite(arch);
   writeln(arch, 'mode '+PuertoDisplay+' 96,n,8,1');
   writeln(arch, 'type T.TXT > '+PuertoDisplay);

   closefile(arch);
   winexec('setea.bat',0);
   // RUTINA PARA INICIALIZAR EL DISPLAY
  except
  end;
end;

procedure TfrmMain.Display(vTotal : Double; Descrip : String);
var
  arch : textfile;
begin
  // RUTINA PARA EL DISPLAY
  assignfile(arch,'T.txt');
  rewrite(arch);
  writeln(arch, chr(27)+CHR(81)+CHR(65)+Descrip);
  writeln(arch, chr(27)+CHR(81)+CHR(66)+format('%n',[vTotal])+'      ' + format('%n',[TotalVenta]));
  closefile(Arch);

  assignfile(arch,'setea.bat');
  rewrite(arch);
  writeln(arch, 'type T.TXT > '+PuertoDisplay);
  closefile(arch);
  winexec('setea.bat',0);
  // RUTINA PARA EL DISPLAY

end;

procedure TfrmMain.DisplayTotal;
var
  arch : textfile;
begin
  // RUTINA PARA EL DISPLAY
  assignfile(arch,'T.txt');
  rewrite(arch);
  writeln(arch, chr(27)+CHR(81)+CHR(65)+'TOTAL A PAGAR');
  writeln(arch, chr(27)+CHR(81)+CHR(66)+'      '+Format('%n',[TotalVenta]));
  closefile(Arch);

  assignfile(arch,'setea.bat');
  rewrite(arch);
  writeln(arch, 'type T.TXT > '+PuertoDisplay);
  closefile(arch);
  winexec('setea.bat',0);
  // RUTINA PARA EL DISPLAY
end;

procedure TfrmMain.DisplayDevuelta(recibido, devuelta: double);
var
  arch : textfile;
begin
  // RUTINA PARA EL DISPLAY
  assignfile(arch,'T.txt');
  rewrite(arch);
  writeln(arch, chr(27)+CHR(81)+CHR(65)+'Recibido     '+Format('%n',[recibido]));
  writeln(arch, chr(27)+CHR(81)+CHR(66)+'Devuelta     '+Format('%n',[devuelta]));
  closefile(Arch);

  assignfile(arch,'setea.bat');
  rewrite(arch);
  writeln(arch, 'type T.TXT > '+PuertoDisplay);
  closefile(arch);
  winexec('setea.bat',0);
  // RUTINA PARA EL DISPLAY
end;

procedure TfrmMain.pndomicilioClick(Sender: TObject);
begin
  if QTickettotal.Value = 0 then
  begin
    Application.CreateForm(tfrmAnular, frmAnular);
    frmAnular.Llevar := true;
    frmAnular.Caption := 'DOMICILIO';
    frmAnular.btimprimir.Enabled := False;;
    frmAnular.QTicket.SQL.Add('order by fecha desc, ticket desc');
    frmAnular.QTicket.Parameters.ParamByName('usu').Value     := dm.Usuario;
    frmAnular.QTicket.Parameters.ParamByName('fec1').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec1').Value    := frmAnular.hora1.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').Value    := frmAnular.hora2.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('caj').Value     := StrToInt(edcaja.Caption);
    frmAnular.QTicket.Open;

    frmAnular.btanular.Visible := false;
    frmAnular.btimprimir.Visible := false;
    frmAnular.ShowModal;
    if frmAnular.seleccion = 1 then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select cli_nombre, cli_direccion, cli_localidad, cli_telefono');
      Query1.SQL.Add('from clientes where emp_codigo = :emp');
      Query1.SQL.Add('and cli_referencia = :ref');
      Query1.Parameters.ParamByName('emp').Value := frmAnular.empresa;
      Query1.Parameters.ParamByName('ref').Value := frmAnular.cliente;
      Query1.Open;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('update montos_ticket set domicilio = '+QuotedStr('True')+',');
      dm.Query1.SQL.Add('telefono_domicilio = :tel, nombre_domicilio = :nom');
      dm.Query1.SQL.Add('where usu_codigo = :usu');
      dm.Query1.SQL.Add('and caja = :caj');
      dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
      dm.Query1.SQL.Add('and ticket = :tik');
      dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
      dm.Query1.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
      dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      dm.Query1.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.AsInteger;
      dm.Query1.Parameters.ParamByName('tel').Value    := Query1.FieldByName('cli_telefono').AsString;
      dm.Query1.Parameters.ParamByName('nom').Value    := Query1.FieldByName('cli_nombre').AsString;
      dm.Query1.ExecSQL;

      ImprimeDomicilio(frmAnular.empresa, frmAnular.QTicketNCF.Value, frmAnular.cliente);

      MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA FACTURA',mtInformation,[mbok],0);

      //Imprimiendo la factura
      QTicket.DisableControls;
      QTicket.Close;
      if forma_numeracion = 1 then
      begin
        QTicket.SQL.Clear;
        QTicket.SQL.Add('select usu_codigo, fecha, caja, ticket,');
        QTicket.SQL.Add('total, descuento, NCF_Fijo, NCF_Secuencia,');
        QTicket.SQL.Add('itbis, nombre, rnc, status, mov_numero,');
        QTicket.SQL.Add('NCF_Tipo, fecha_hora, Boletos, supervisor,');
        QTicket.SQL.Add('sorteo, domicilio, emp_codigo, grabado, exento');
        QTicket.SQL.Add('from montos_ticket');
        QTicket.SQL.Add('where caja   = :caj');
        QTicket.SQL.Add('and ticket = :tik');
        QTicket.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        QTicket.SQL.Add('and usu_codigo = :usu');
        QTicket.Parameters.ParamByName('fec').DataType := ftDate;
        QTicket.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
        QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      QTicket.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      QTicket.Open;
      MovTicket := QTicketmov_numero.Value;

      QDetalle.DisableControls;
      QDetalle.Close;
      if forma_numeracion = 1 then
      begin
        QDetalle.SQL.Clear;
        QDetalle.SQL.Add('select usu_codigo, fecha, ticket, secuencia,');
        QDetalle.SQL.Add('hora, producto, descripcion, cantidad, precio,');
        QDetalle.SQL.Add('empaque, itbis, Costo, caja, descuento,');
        QDetalle.SQL.Add('devuelta, Realizo_Oferta, Oferta,');
        QDetalle.SQL.Add('Patrocinador, fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo,');
        QDetalle.SQL.Add('col_codigo, mar_codigo');
        QDetalle.SQL.Add('from ticket');
        QDetalle.SQL.Add('where caja = :caj');
        QDetalle.SQL.Add('and ticket = :tik');
        QDetalle.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        QDetalle.SQL.Add('and usu_codigo = :usu');
        QDetalle.SQL.Add('order by secuencia desc');
        QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
        QDetalle.Parameters.ParamByName('fec').Value    := DM.getFechaServidor;
        QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      QDetalle.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      QDetalle.Open;

      QFormaPago.Close;
      if forma_numeracion = 1 then
      begin
        QFormaPago.SQL.Clear;
        QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
        QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
        QFormaPago.SQL.Add('from formas_pago_ticket');
        QFormaPago.SQL.Add('where caja = :caj');
        QFormaPago.SQL.Add('and ticket = :tik');
        QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        QFormaPago.SQL.Add('and usu_codigo = :usu');
        QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
        QFormaPago.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
        QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
      QFormaPago.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      QFormaPago.Open;

      if QFormaPago.Locate('forma','CRE',[]) then credito := 'True' else credito := 'False';

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select sum(pagado) as pagado from formas_pago_ticket');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.SQL.Add('and ticket = :tik');
      if forma_numeracion = 1 then
      begin
        dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        dm.Query1.SQL.Add('and usu_codigo = :usu');
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
        dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      dm.Query1.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      dm.Query1.Open;
      MPagado := dm.Query1.FieldByName('pagado').AsFloat;

      QTicket.EnableControls;
      QDetalle.EnableControls;

      Boletos;

      if UpperCase(pregunta) = 'S' then
        if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
        ImpTicket;
        if UpperCase(pregunta) = 'N' then
        ImpTicket;


      lbund.Caption := 'UNIDAD';
      TicketNuevo;
     //ImpTicketNorma201806;
      SeleccionTipo := '';
      SeleccionCliente := 0;
      SeleccionEmpresa := 0;
      Aumento := 0;
      //edcliente.Caption := '';
      cliente := 0;
      IniciaDisplay;
    end;
    frmAnular.Release;
  end
  else
  begin
    MessageDlg('DEBE TERMINAR ESTA VENTA ANTES DE IMPRIMIR EL DOMICILIO,'+#13+
    'PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
  end;
end;


(*begin
  if QTickettotal.Value = 0 then
  begin
    Application.CreateForm(tfrmAnular, frmAnular);
    frmAnular.Llevar := true;
    frmAnular.Caption := 'DOMICILIO';
    frmAnular.btimprimir.Enabled := False;;
    frmAnular.QTicket.SQL.Add('order by fecha desc, ticket desc');
    frmAnular.QTicket.Parameters.ParamByName('usu').Value     := dm.Usuario;
    frmAnular.QTicket.Parameters.ParamByName('fec1').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec1').Value    := frmAnular.hora1.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').Value    := frmAnular.hora2.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('caj').Value     := StrToInt(edcaja.Caption);
    frmAnular.QTicket.Open;

    frmAnular.btanular.Visible := false;
    frmAnular.btimprimir.Visible := false;
    frmAnular.ShowModal;
    if frmAnular.seleccion = 1 then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select cli_nombre, cli_direccion, cli_localidad, cli_telefono');
      Query1.SQL.Add('from clientes where emp_codigo = :emp');
      Query1.SQL.Add('and cli_referencia = :ref');
      Query1.Parameters.ParamByName('emp').Value := frmAnular.empresa;
      Query1.Parameters.ParamByName('ref').Value := frmAnular.cliente;
      Query1.Open;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('update montos_ticket set domicilio = '+QuotedStr('True')+',');
      dm.Query1.SQL.Add('telefono_domicilio = :tel, nombre_domicilio = :nom');
      dm.Query1.SQL.Add('where usu_codigo = :usu');
      dm.Query1.SQL.Add('and caja = :caj');
      dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
      dm.Query1.SQL.Add('and ticket = :tik');
      dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
      dm.Query1.Parameters.ParamByName('fec').Value    := Date;
      dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      dm.Query1.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.AsInteger;
      dm.Query1.Parameters.ParamByName('tel').Value    := Query1.FieldByName('cli_telefono').AsString;
      dm.Query1.Parameters.ParamByName('nom').Value    := Query1.FieldByName('cli_nombre').AsString;
      dm.Query1.ExecSQL;

      ImprimeDomicilio(frmAnular.empresa, frmAnular.QTicketNCF.Value, frmAnular.cliente);

      MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA FACTURA',mtInformation,[mbok],0);

      //Imprimiendo la factura
      QTicket.DisableControls;
      QTicket.Close;
      if forma_numeracion = 1 then
      begin
        QTicket.SQL.Clear;
        QTicket.SQL.Add(SQLFormaNumeracion1);
        QTicket.Parameters.ParamByName('fec').DataType := ftDate;
        QTicket.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
        QTicket.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QTicket.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      QTicket.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      QTicket.Open;
      MovTicket := QTicketmov_numero.Value;

      QDetalle.DisableControls;
      QDetalle.Close;
      if forma_numeracion = 1 then
      begin
        QDetalle.SQL.Clear;
        QDetalle.SQL.Add('select usu_codigo, fecha, ticket, secuencia,');
        QDetalle.SQL.Add('hora, producto, descripcion, cantidad, precio,');
        QDetalle.SQL.Add('empaque, itbis, Costo, caja, descuento,');
        QDetalle.SQL.Add('devuelta, Realizo_Oferta, Oferta,');
        QDetalle.SQL.Add('Patrocinador, fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo,');
        QDetalle.SQL.Add('col_codigo, mar_codigo');
        QDetalle.SQL.Add('from ticket');
        QDetalle.SQL.Add('where caja = :caj');
        QDetalle.SQL.Add('and ticket = :tik');
        QDetalle.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        QDetalle.SQL.Add('and usu_codigo = :usu');
        QDetalle.SQL.Add('order by secuencia desc');
        QDetalle.Parameters.ParamByName('fec').DataType := ftDate;
        QDetalle.Parameters.ParamByName('fec').Value    := Date;
        QDetalle.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QDetalle.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      QDetalle.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      QDetalle.Open;

      QFormaPago.Close;
      if forma_numeracion = 1 then
      begin
        QFormaPago.SQL.Clear;
        QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
        QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
        QFormaPago.SQL.Add('from formas_pago_ticket');
        QFormaPago.SQL.Add('where caja = :caj');
        QFormaPago.SQL.Add('and ticket = :tik');
        QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        QFormaPago.SQL.Add('and usu_codigo = :usu');
        QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
        QFormaPago.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
        QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(edcaja.Caption));
      QFormaPago.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      QFormaPago.Open;

      if QFormaPago.Locate('forma','CRE',[]) then credito := 'True' else credito := 'False';

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select sum(pagado) as pagado from formas_pago_ticket');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.SQL.Add('and ticket = :tik');
      if forma_numeracion = 1 then
      begin
        dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        dm.Query1.SQL.Add('and usu_codigo = :usu');
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := frmAnular.QTicketfecha.Value;
        dm.Query1.Parameters.ParamByName('usu').Value    := dm.Usuario;
      end;
      dm.Query1.Parameters.ParamByName('caj').Value    := StrToInt(edcaja.Caption);
      dm.Query1.Parameters.ParamByName('tik').Value    := frmAnular.QTicketticket.Value;
      dm.Query1.Open;
      MPagado := dm.Query1.FieldByName('pagado').AsFloat;

      QTicket.EnableControls;
      QDetalle.EnableControls;

      Boletos;

      Reimprimir;


      TicketNuevo(true);
      IniciaDisplay;
    end;
    frmAnular.Release;
  end
  else
  begin
    MessageDlg('DEBE TERMINAR ESTA VENTA ANTES DE IMPRIMIR EL DOMICILIO,'+#13+
    'PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
  end;
end;*)

procedure TfrmMain.ImprimeDomicilio(empdomicilio : integer; ncfdomicilio, cliente : string);
var
  arch : textfile;
  HoraDomicilio : String;
begin
  HoraDomicilio := TimeToStr(Time);

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select puerto from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
  dm.Query1.Open;
  Puerto := dm.Query1.FieldByName('puerto').AsString;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select cli_nombre, cli_direccion, cli_localidad');
  dm.Query1.SQL.Add('from clientes where emp_codigo = :emp');
  dm.Query1.SQL.Add('and cli_referencia = :ref');
  dm.Query1.Parameters.ParamByName('emp').Value := empdomicilio;
  dm.Query1.Parameters.ParamByName('ref').Value := cliente;
  dm.Query1.Open;

  assignfile(arch,'imp.bat');
  rewrite(arch);
  writeln(arch, 'type rep.txt > '+Puerto);
  closefile(arch);

  assignfile(arch,'rep.txt');
  {I-}
  rewrite(arch);
  {I+}

  writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
  writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
  writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
  writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
  writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
  writeln(arch, ' ');
  writeln(arch, dm.centro('*** DOMICILIO ***'));
  writeln(arch, ' ');
  writeln(arch, 'Factura : '+copy(ncfdomicilio,16,4));
  writeln(arch, ' ');
  writeln(arch, 'Cliente : '+cliente);
  writeln(arch, '          '+dm.Query1.FieldByName('cli_nombre').AsString);
  writeln(arch, '          '+dm.Query1.FieldByName('cli_direccion').AsString);
  writeln(arch, '          '+dm.Query1.FieldByName('cli_localidad').AsString);
  writeln(arch, ' ');
  writeln(arch, 'Hora Empaque  : '+HoraDomicilio);
  writeln(arch, ' ');
  writeln(arch, 'No. de Bultos : ------------------------');
  writeln(arch, ' ');
  writeln(arch, 'Empacador     : ------------------------');
  writeln(arch, ' ');
  writeln(arch, 'Atendido por  : '+formatfloat('000',dm.Usuario)+' '+edcajero.Caption);
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  closefile(Arch);
  winexec('imp.bat',0);

  MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);

  assignfile(arch,'rep.txt');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
  writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
  writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
  writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
  writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
  writeln(arch, ' ');
  writeln(arch, dm.centro('*** DOMICILIO ***'));
  writeln(arch, ' ');
  writeln(arch, 'Factura : '+copy(ncfdomicilio,16,4));
  writeln(arch, ' ');
  writeln(arch, 'Hora Empaque  : '+HoraDomicilio);
  writeln(arch, ' ');
  writeln(arch, 'No. de Bultos : ------------------------');
  writeln(arch, ' ');
  writeln(arch, 'Empacador     : ------------------------');
  writeln(arch, ' ');
  writeln(arch, 'Atendido por  : '+formatfloat('000',dm.Usuario)+' '+edcajero.Caption);
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');

  closefile(Arch);
  winexec('imp.bat',0);
  
end;


procedure TfrmMain.DisplayEliminando;
var
  arch : textfile;
begin
  // RUTINA PARA EL DISPLAY
  assignfile(arch,'T.txt');
  rewrite(arch);
  writeln(arch, chr(27)+CHR(81)+CHR(65)+'ELIMINANDO PRODUCTO');
  writeln(arch, chr(27)+CHR(81)+CHR(66)+'ESPERE UN MOMENTO');
  closefile(Arch);

  assignfile(arch,'setea.bat');
  rewrite(arch);
  writeln(arch, 'type T.TXT > '+PuertoDisplay);
  closefile(arch);
  winexec('setea.bat',0);
  // RUTINA PARA EL DISPLAY
end;

procedure TfrmMain.DisplayProductoEliminado(vProd: string; vPrecio : string);
var
  arch : textfile;
begin
  // RUTINA PARA EL DISPLAY
  assignfile(arch,'T.txt');
  rewrite(arch);
  writeln(arch, chr(27)+CHR(81)+CHR(65)+'ELIMINO '+vProd);
  writeln(arch, chr(27)+CHR(81)+CHR(66)+'-'+vPrecio+'    '+Format('%n',[TotalVenta]));
  closefile(Arch);

  assignfile(arch,'setea.bat');
  rewrite(arch);
  writeln(arch, 'type T.TXT > '+PuertoDisplay);
  closefile(arch);
  winexec('setea.bat',0);
  // RUTINA PARA EL DISPLAY
end;


function IntToBin(Value: LongWord): string;
var
  i: Integer;
begin
  SetLength(Result, 32);
  for i := 1 to 32 do begin
    if ((Value shl (i-1)) shr 31) = 0 then begin
      Result[i] := '0'
    end else begin
      Result[i] := '1';
    end;
  end;
end;


{ TClientes }

procedure TClientes.Clear;
begin
  FIDCliente:=0;
  FRNC:='' ;
  FTipoNCF:=0;
end;

constructor TClientes.Create(AOwner: TComponent);
begin
  FIDCliente:=0;
  FRNC:='' ;
  FTipoNCF:=0;
end;

destructor TClientes.Destroy;
begin

  inherited;
end;

function TClientes.getRazonSocial: String;
begin
  result :='';
      dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select razon_social from rnc');
        dm.Query1.SQL.Add('where rnc_cedula = :rnc');
        dm.Query1.Parameters.ParamByName('rnc').Value := rnc;
        dm.Query1.Open;
        if dm.Query1.RecordCount > 0 then
          result := dm.Query1.FieldByName('razon_social').AsString;
        dm.query1.close;
end;

procedure TClientes.setIDCliente(const Value: integer);
begin
  FIDCliente := Value;
end;

procedure TfrmMain.btVendedorClick(Sender: TObject);
begin
  Search.AliasFields.clear;
  Search.AliasFields.add('Nombre');
  Search.AliasFields.add('Código');
  Search.Query.clear;
  Search.Query.add('select ven_nombre, ven_codigo');
  Search.Query.add('from vendedores');
  Search.Query.add('where emp_codigo = '+inttostr(dm.QEmpresaEMP_CODIGO.value));
  Search.ResultField := 'ven_Codigo';
  Search.Title := 'Listado de Vendedores';
  if Search.execute then
  begin
    edIDVEND.Text := Search.ValueField;
    edproducto.setfocus;
  end;
end;

procedure TfrmMain.QTicketNewRecord(DataSet: TDataSet);
var
  fecha :TDateTime;
begin
         dm.adoMultiUso.Close;
         dm.adoMultiUso.SQL.Clear;
         dm.adoMultiUso.SQL.Add('select Max(fecha_hora)fecha from montos_ticket where caja = :caja and usu_codigo = :usu');
         dm.adoMultiUso.SQL.Add('having Max(fecha_hora)>getdate()');
         dm.adoMultiUso.Parameters.ParamByName('caja').Value := StrToInt(edcaja.Caption);
         dm.adoMultiUso.Parameters.ParamByName('usu').Value  := dm.Usuario;
         dm.adoMultiUso.Open;
         if DM.adoMultiUso.RecordCount>0  then begin
         MessageDlg('ESTE COMPUTADOR TIENE UNA FECHA/HORA MENOR QUE LA ULTIMA TRANSACCION FAVOR VERIFICAR LA FECHA/HORA',
         mtWarning,[mbOK],0);
         Application.Terminate;
         end;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select puerto, Redondea, ISNULL(pregunta_imprimir,''N'')pregunta_imprimir, tipo_lector from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
  dm.Query1.Open;
  Puerto     := dm.Query1.FieldByName('puerto').AsString;
  pregunta   := dm.Query1.FieldByName('pregunta_imprimir').AsString;
  TipoLector := dm.Query1.FieldByName('tipo_lector').AsInteger;

  MDLista.Close;
  MDLista.Open;




  Fecha :=  dm.getFechaServidor2;
  QTicketstatus.Value     := 'ABI';
  QTicketticket.Value     := StrToInt(Trim(edticket.Caption));
  QTicketusu_codigo.Value := dm.Usuario;
  QTicketfecha.Value      := DM.getFechaServidor2;
  QTicketfecha_hora.Value := Fecha;
  QTicketcaja.Value       := StrToInt(Trim(edcaja.Caption));
  QTickettotal.Value      := 0;
  QTicketdescuento.Value  := 0;
  QTicketitbis.Value      := 0;
  QTicketnombre.Value     := NombreCliente;
  DataSet['porciento_com']:= comision;
  DataSet['tk_Monto_Comision']:=0;
  QTicket['tip_codigo']   := TipoComprobante;
  QTicket['ncf_tipo']     := TipoComprobante;



end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  application.createform(tfrmBuscaRNC, frmBuscaRNC);
  frmBuscaRNC.ShowModal;
  if frmBuscaRNC.seleccion = 1 then
  begin
    if not (QTicket.State = dsEdit) then
      QTicket.Edit;
    QTicketrnc.Value := frmBuscaRNC.QRNCrnc_cedula.Value;
  end;
  dbRnc.SetFocus;
end;


procedure TfrmMain.bttiponcfClick(Sender: TObject);
begin
  Search.AliasFields.clear;
  Search.AliasFields.add('Nombre');
  Search.AliasFields.add('Código');
  Search.Query.Clear;
  Search.Query.Add('select tip_nombre, tip_codigo');
  Search.Query.Add('from TipoNCF');
  Search.Query.Add('where emp_codigo = '+IntToStr(dm.QEmpresaEMP_CODIGO.Value));
  Search.ResultField := 'tip_codigo';
  Search.Title := 'Tipos de Comprobantes';
  if Search.execute then
  begin
    edTipoNCF.Text  := Search.ValueField;
    edproducto.SetFocus;
  end;
end;

procedure TfrmMain.getCliente(_ID:Integer);
var
  Cliente : integer;
begin
  adoClientes.Close();
  PorcientoClte :=0;
  TipoComprobante := 1;
  edTipoNCF.Text := IntToStr(TipoComprobante );
  edIDVEND.Text := '';

  QTicket.Edit;
  QTicketnombre.value     := NombreCliente;
  QTicketrnc.Value := '';

  if _ID < 1 then  exit;


    Query1.close;
    Query1.sql.clear;
    Query1.sql.add('select cli_codigo, cli_nombre, cli_balance, cli_referencia,');
    Query1.sql.add('cli_limite, cli_precio, cli_descuento, ven_codigo, cpa_codigo,');
    Query1.sql.add('cli_direccion, cli_localidad, cli_telefono, cli_fax, cli_facturarbce,');
    Query1.sql.add('cli_facturarvencida, cli_precio, cli_cuenta, pro_codigo,');
    Query1.sql.add('cli_factura_debajo_costo, cli_factura_debajo_minimo, tcl_codigo,');
    Query1.sql.add('cli_cedula, cli_rnc, tfa_codigo');
    Query1.sql.add('from clientes');
    Query1.sql.add('where emp_codigo = :emp');
    Query1.sql.add('and cli_Status = '+#39+'ACT'+#39);
    Query1.Parameters.parambyname('emp').Value := dm.QEmpresaEMP_CODIGO.value;

    if dm.QParametrosPAR_CODIGOCLIENTE.value = 'I' then
    begin
      Query1.sql.add('and cli_codigo = :cli');
      Query1.Parameters.parambyname('cli').Value := _ID;
    end
    else
    begin
      Query1.sql.add('and cli_referencia = :cli');
      Query1.Parameters.parambyname('cli').Value := _ID;
    end;
    Query1.open;

    if Query1.IsEmpty then
      begin

        Application.MessageBox('Cliente no encontrado','Aviso',MB_OK+MB_ICONSTOP);
        edIDClte.Text :='';
        exit;
      end;

    With adoClientes do begin
      Close;
      Parameters.ParamByName('emp_codigo').Value := dm.QEmpresaEMP_CODIGO.value;
      Parameters.ParamByName('cli_codigo').Value :=Query1['cli_codigo'];
      Open;
      //adoClientes['cli_codigo']
    end;

    if not Query1.fieldbyname('cli_descuento').IsNull then
      PorcientoClte    := Query1.fieldbyname('cli_descuento').AsFloat;
    CtaCliente       := Query1.fieldbyname('cli_cuenta').asstring;
    FactPendiente    := Query1.fieldbyname('cli_facturarbce').asstring;
    FactVencida      := Query1.fieldbyname('cli_facturarvencida').asstring;
    FactDebajoCosto  := Query1.fieldbyname('cli_factura_debajo_costo').asstring;
    FactDebajoMinimo := Query1.fieldbyname('cli_factura_debajo_minimo').asstring;
    if Query1.fieldbyname('tfa_codigo').AsInteger > 0 then
    begin

    if Query1.fieldbyname('cli_Precio').asstring <> 'Ninguno' then
      PrecioII := Query1.fieldbyname('cli_Precio').asstring
    else if not Query1.FieldByName('tcl_codigo').IsNull then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select tcl_precio from tipoclientes');
      dm.Query1.SQL.Add('where emp_codigo = :emp');
      dm.Query1.SQL.Add('and tcl_codigo = :tcl');
      dm.Query1.Parameters.ParamByName('emp').Value := dm.QEmpresaEMP_CODIGO.Value;
      dm.Query1.Parameters.ParamByName('tcl').Value := Query1.FieldByName('tcl_codigo').AsInteger;
      dm.Query1.Open;
      PrecioII := dm.Query1.FieldByName('tcl_precio').AsString;
    end;

    Cliente := Query1.fieldbyname('cli_codigo').asinteger;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select * from PR_BUSCA_VENCIDO (:emp, :cli, :fec)');
    dm.Query1.Parameters.ParamByName('emp').Value := dm.QEmpresaEMP_CODIGO.Value;
    dm.Query1.Parameters.ParamByName('cli').Value := Cliente;
    dm.Query1.Parameters.ParamByName('fec').Value := DM.getFechaServidor;
    dm.Query1.Open;
    Vencidos := dm.Query1.FieldByName('vencido').asstring;

    if (actbalance = 'True') and (VerLimite = 'True') and
    (StrToFloat(Format('%10.2f',[Query1.fieldbyname('cli_limite').asfloat])) = 0) then
    begin
      MessageDlg('ESTE CLIENTE NO TIENE LIMITE DE CREDITO ASIGNADO,'+#13+
                 'NO PUEDE REALIZARLE UNA FACTURA DE ESTE TIPO',mtError,[mbok],0);
      edIDClte.SetFocus;
    end
    else if (actbalance = 'True') and (VerLimite = 'True') and
    (StrToFLoat(Format('%10.2f',[Query1.fieldbyname('cli_limite').asfloat])) -
    StrToFLoat(Format('%10.2f',[Query1.fieldbyname('cli_balance').asfloat])) <= 0) then
    begin
      MessageDlg('ESTE CLIENTE NO TIENE LIMITE DE CREDITO DISPONIBLE,'+#13+
                 'NO PUEDE REALIZARLE UNA FACTURA DE ESTE TIPO',mtError,[mbok],0);
      edIDClte.SetFocus;
    end
    else if (actbalance = 'True') and (Query1.fieldbyname('cli_balance').asfloat > 0)
    and (FactPendiente = 'N') then
    begin
      MessageDlg('ESTE CLIENTE TIENE BALANCE PENDIENTE, Y NO'+#13+
                 'PUEDE REALIZARLE UNA FACTURA DE ESTE TIPO',mtError,[mbok],0);
      edIDClte.SetFocus;
    end
    else if (actbalance = 'True') and (Query1.fieldbyname('cli_balance').asfloat > 0)
    and (FactVencida = 'N') and (Vencidos = 'S') then
    begin
      MessageDlg('ESTE CLIENTE TIENE FACTURAS VENCIDAS, Y NO'+#13+
                 'PUEDE REALIZARLE UNA FACTURA DE ESTE TIPO',mtError,[mbok],0);
      edIDClte.SetFocus;
    end
    else
    begin
      //edTipo.Enabled := False;
     // btTipo.Enabled := False;
      if PrecioII = '' then
      begin
        if not Query1.fieldbyname('cli_Precio').IsNull then
          PrecioII := Query1.fieldbyname('cli_Precio').asstring
        else
          PrecioII := 'Precio1';
      end;

      FactPendiente                := Query1.fieldbyname('cli_facturarbce').asstring;
      FactVencida                  := Query1.fieldbyname('cli_facturarvencida').asstring;

      QTicket.Edit;

      QTicketnombre.Value        := Trim(Copy(Query1.fieldbyname('cli_nombre').asstring,1,80));
      QTicketcli_telefono.Value  := Query1.fieldbyname('cli_telefono').asstring;
      QTicketcli_direccion.Value := Trim(Copy(Query1.fieldbyname('cli_direccion').asstring,1,80));
      QTicketcli_Descuento.Value := Query1.fieldbyname('cli_Descuento').AsCurrency;
      QTicketcli_codigo.Value    := Query1.fieldbyname('cli_codigo').AsInteger;
      edIDVEND.Text              := Query1.fieldbyname('ven_codigo').AsString;
      if not ((Query1.fieldbyname('tfa_codigo').isnull) or
         (Trim(Query1.fieldbyname('tfa_codigo').asstring) = '')) then
        begin
          edTipoNCF.Text := IntToStr(Query1.fieldbyname('tfa_codigo').asinteger);
          //QTicketNCF_Tipo.Value :=  Query1.fieldbyname('tfa_codigo').asinteger;
          //QTickettip_codigo.Value :=Query1.fieldbyname('tfa_codigo').asinteger;
        end;

      if (Query1.fieldbyname('cli_rnc').isnull) or (Trim(Query1.fieldbyname('cli_rnc').asstring) = '') then
        QTicketrnc.Value := Query1.fieldbyname('cli_cedula').asstring
      else
        QTicketrnc.Value := Query1.fieldbyname('cli_rnc').asstring;



      //descuento                    := Query1.fieldbyname('cli_descuento').asfloat;
      {//if actbalance = 'True' then
      //  QFacturaCPA_CODIGO.Value     := Query1.fieldbyname('cpa_Codigo').asinteger
      else
        QFacturaCPA_CODIGO.Clear;
       }
      if not Query1.fieldbyname('ven_Codigo').IsNull then
        begin

         edIDVEND.Text := IntToStr(Query1.fieldbyname('ven_Codigo').asinteger);
         Vendedor_Asociado_a_Clte := true;
         // QTicketven_codigo.Value     := Query1.fieldbyname('ven_Codigo').asinteger;
          //getVendedor(QTicketven_codigo.value);
        end;
   end;
 end;

end;


procedure TfrmMain.btBuscaCliClick(Sender: TObject);
begin
  Search.AliasFields.clear;
  Search.AliasFields.Add('Nombre');
  Search.AliasFields.Add('Telefono');
  Search.AliasFields.Add('Cédula/RNC');
  Search.AliasFields.Add('Código');
  Search.Query.clear;
  Search.Query.add('select substring(cli_nombre,1,50) as cli_nombre, cli_telefono, cli_cedula, cli_codigo, cli_referencia, cli_precio');
  Search.Query.add('from clientes');
  Search.Query.add('where emp_codigo = '+inttostr(dm.QEmpresaEMP_CODIGO.value));
  Search.Query.add('and cli_Status = '+#39+'ACT'+#39);
  if dm.QParametrosPAR_CODIGOCLIENTE.value = 'I' then
    Search.ResultField := 'cli_codigo'
  else
    Search.ResultField := 'cli_referencia';
  Search.Title := 'Listado de clientes';
  if Search.execute then begin
    edIDClte.Text := search.valuefield;
  edproducto.SetFocus;
//-----------------------------------
    Query1.close;
    Query1.sql.clear;
    Query1.sql.add('select cli_codigo, cli_nombre, cli_balance, cli_referencia,');
    Query1.sql.add('cli_limite, cli_precio, isnull(cli_descuento,0) cli_descuento, ven_codigo, cpa_codigo,');
    Query1.sql.add('cli_direccion, cli_localidad, cli_telefono, cli_fax, cli_facturarbce,');
    Query1.sql.add('cli_facturarvencida, cli_precio, cli_cuenta, pro_codigo,');
    Query1.sql.add('cli_factura_debajo_costo, cli_factura_debajo_minimo, tcl_codigo,');
    Query1.sql.add('cli_cedula, cli_rnc, tfa_codigo, cli_telefono');
    Query1.sql.add('from clientes');
    Query1.sql.add('where emp_codigo = :emp');
    Query1.sql.add('and cli_Status = '+#39+'ACT'+#39);
    if dm.QParametrosPAR_CODIGOCLIENTE.value = 'I' then
    begin
      Query1.sql.add('and cli_codigo = :cli');
      Query1.Parameters.parambyname('cli').Value := strtoint(search.valuefield);
    end
    else
    begin
      Query1.sql.add('and cli_referencia = :cli');
      Query1.Parameters.parambyname('cli').Value := search.valuefield;
    end;
    Query1.Parameters.parambyname('emp').Value := dm.QEmpresaEMP_CODIGO.value;
    Query1.open;
    PrecioClie := Query1.fieldbyname('cli_precio').AsString;

     if Query1.fieldbyname('cli_Precio').asstring <> 'Ninguno' then
     PrecioClie := Query1.fieldbyname('cli_Precio').AsString
      else if not Query1.FieldByName('tcl_codigo').IsNull then
      begin
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select tcl_precio from tipoclientes');
        dm.Query1.SQL.Add('where emp_codigo = :emp');
        dm.Query1.SQL.Add('and tcl_codigo = :tcl');
        dm.Query1.Parameters.ParamByName('emp').Value := dm.QEmpresaemp_codigo.Value;
        dm.Query1.Parameters.ParamByName('tcl').Value := Query1.FieldByName('tcl_codigo').AsInteger;
        dm.Query1.Open;
        PrecioClie := dm.Query1.FieldByName('tcl_precio').AsString;
      end;

      QTicketnombre.Value        :=  Query1.fieldbyname('cli_nombre').asstring;
      QTicketcli_telefono.Value  :=  Query1.fieldbyname('cli_telefono').asstring;
      QTicketcli_direccion.Value :=  Query1.fieldbyname('cli_direccion').asstring;
      QTicketcli_Descuento.Value :=  Query1.fieldbyname('cli_descuento').Value;


//    QTicketnombre.value     := Query1.fieldbyname('cli_nombre').asstring;
end;

end;

procedure TfrmMain.DBEdit13KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    edproducto.SetFocus;
end;

procedure TfrmMain.edTipoNCFKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (Trim(edTipoNCF.Text) <> '')then
    begin
      with dm.adoMultiUsoII do begin
        Close;
        SQL.Clear;
        SQL.Add('select tip_nombre from TipoNCF');
        SQL.Add('where emp_codigo = :emp');
        SQL.Add('and tip_codigo = :tip');
        Parameters.ParamByName('emp').Value := dm.QEmpresaEMP_CODIGO.Value;
        Parameters.ParamByName('tip').Value  := StrToInt(edTipoNCF.Text);
        Open;
        if  RecordCount > 0 then
          begin
            TipoComprobante := StrToInt(edTipoNCF.Text);
            ttiponcf.Text := FieldByName('tip_nombre').AsString;

            if Visible then
              begin
                if not (QTicket.State in [dsInsert,dsEdit]) then
                  QTicket.Edit;
                QTickettip_codigo.Value := StrToInt(edTipoNCF.Text);
                QTicketNCF_Tipo.Value := StrToInt(edTipoNCF.Text);
                edproducto.SetFocus();
              end;

          end
        else
          if (Sender = edTipoNCF) then
            begin
              Application.MessageBox('Registro no encontrado','Aviso',
                                  MB_OK+MB_ICONSTOP);
              ttiponcf.Text:='';
              edTipoNCF.Text :='';
              edTipoNCF.SetFocus();
            end;

      end;
    end;
end;

procedure TfrmMain.edTipoNCFChange(Sender: TObject);

begin
  edTipoNCFKeyPress(Sender,EnterKeyChar);
end;

procedure TfrmMain.edIDVENDKeyPress(Sender: TObject; var Key: Char);
begin
  if (Trim(edIDVEND.Text) = '') then tVendedor.Text :='';

  if (key = #13) and (Trim(edIDVEND.Text) <> '')then
    begin //[0]
      Vendedor_Asociado_a_Clte := false; // esta variable es para no borrar al vendedor cuando borra al cliente
      edIDVEND.Text:=Trim(edIDVEND.Text);
      tVendedor.Text := '';
      With dm.adoMultiUso do begin
        close;
        sql.clear;
        sql.add('select ven_nombre, ven_comventa from vendedores');
        sql.add('where emp_Codigo = :emp');
        sql.add('and ven_Codigo = :ven');
        Parameters.parambyname('emp').Value := dm.QEmpresaEMP_CODIGO.value;
        Parameters.parambyname('ven').Value := StrToInt(edIDVEND.Text);
        open;
        if dm.adoMultiUso.recordcount > 0 then
          begin
            tVendedor.text := dm.adoMultiUso.fieldbyname('ven_nombre').asstring;
            Comision := dm.adoMultiUso.fieldbyname('ven_comventa').AsFloat;
            if Visible then
              begin
                if not (QTicket.State in [dsInsert,dsEdit]) then
                  QTicket.Edit;
                QTicketven_codigo.Value := StrToInt(edIDVEND.Text);
                
                QTicketporciento_com.Value := Comision;
                edproducto.SetFocus();
              end;
          end // recordcount > 0
        else
          if (Sender = edIDVEND) then
            begin
              Application.MessageBox('Registro no encontrado','Aviso',
                                  MB_OK+MB_ICONSTOP);
              tVendedor.Text := '';
              edIDVEND.Text :='';
              edIDVEND.SetFocus();
            end;
      end; //with

    end;//[0]
end;

procedure TfrmMain.edIDClteKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (Trim(edIDClte.Text) <> '') then
    begin
      edIDClte.Text := Trim(edIDClte.Text);
      getCliente(StrToInt(edIDClte.Text));
    end;
end;

procedure TfrmMain.edIDVENDChange(Sender: TObject);
begin

  edIDVENDKeyPress(Sender,EnterKeyChar);
end;

procedure TfrmMain.edIDClteChange(Sender: TObject);
begin
  edIDClteKeyPress(Sender,EnterKeyChar);
end;

procedure TfrmMain.edIDClteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if key = 27 then
    begin
      PorcientoClte :=0;
      TipoComprobante := 1;
      edTipoNCF.Text := IntToStr(TipoComprobante );
      edIDClte.Text :='';
      if not (QTicket.State in [dsInsert,dsEdit]) then
        QTicket.Edit;
      QTicketcli_codigo.Value := 0;
      QTicketnombre.Value :=  NombreCliente;
      QTicketrnc.Value :='';
      if Vendedor_Asociado_a_Clte then
       begin
         ttiponcf.Text := '';
         edIDVEND.Text :='';

         QTicketven_codigo.value:=0;
       end;

      adoClientes.Close;
      edTipoNCFKeyPress(Sender,EnterKeyChar);
    end;
end;

function TfrmMain.Producto_sin_Serializar(const key: string): boolean;
var  Puntero : TBookmark;
begin
  Result := false;
  QSerie.Close;
  QSerie.DataSource := dsDetalle;
  QSerie.Open;

  with QDetalle do
    begin
      Puntero := GetBookmark;
      DisableControls;
      First;
      while not eof do
      if fieldbyname('pro_serializado').Value = 'S' then
      begin
         QSerie.Filter := 'producto=' +QuotedStr(QDetalleproducto.AsString);
         QSerie.Filtered := true;
         Result := QDetallecantidad.AsInteger <> QSerie.RecordCount;
         QSerie.Filtered := false;
         QSerie.Filter := '';
         if Result then
              exit
         else
            Next;
      end
      else next;
    GotoBookmark(Puntero);
    EnableControls;
    end;
end;

procedure TfrmMain.pSerieClick(Sender: TObject);
var  Puntero : TBookmark;
begin
  if QDetalle.State in [dsinsert]then
     begin
       Puntero := QDetalle.GetBookmark;
       QDetalle.Post;
       QDetalle.GotoBookmark(Puntero);
     end;

  if QDetallecantidad.AsInteger > 0 then
  begin
    QSerie.Close;
    QSerie.DataSource := dsDetalle;
    QSerie.Open;
    Application.CreateForm(TfrmSerie, frmSerie);
    with frmSerie do
      begin
        DBText1.DataSource := dsDetalle;
        DBText2.DataSource := dsDetalle;
        DBText3.DataSource := dsDetalle;
//        dsMantSerie.DataSet:= QSerie;
        if ShowModal = mrAll then
           if QSerie.State in [dsEdit,dsInsert] then
              QSerie.Post;
      end;
    frmSerie.Release;
  end;
end;

procedure TfrmMain.QSerieAfterInsert(DataSet: TDataSet);
begin
  if DataSet.RecordCount = QDetallecantidad.AsInteger then
     begin
      DataSet.cancel;
      ShowMessage('A EXEDIDO LA CANTIDAD MAXIMA DE REGISTROS');
     end;
end;

procedure TfrmMain.QSerieNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ser_secuencia').Value := DataSet.RecordCount+1;
  DataSet.FieldByName('ticket').Value := QDetalle.Parameters.ParamByName('tik').value;
  DataSet.FieldByName('tic_secuencia').Value := QDetallesecuencia.value;
end;

procedure TfrmMain.ImpTicketNorma201806;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio, v_subtotal, v_itbis_sd, v_itbis_cd : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos : integer;
  NCF, Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis, codigoabre : String;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select puerto, Redondea, pregunta_imprimir from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
  dm.Query1.Open;
  Puerto   := dm.Query1.FieldByName('puerto').AsString;
  pregunta := dm.Query1.FieldByName('pregunta_imprimir').AsString;

  if UpperCase(pregunta) = 'S' then
  begin
    if MessageDlg('Desea imprimir el ticket?', mtConfirmation, [mbyes, mbno], 0) = mryes then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select par_ticket_itbis from parametros');
      dm.Query1.SQL.Add('where emp_codigo = :emp');
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      dm.Query1.Open;
      ImpItbis := dm.Query1.FieldByName('par_ticket_itbis').AsString;

      assignfile(arch,'imp.bat');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch, 'type rep.txt > '+Puerto);
      closefile(arch);

      assignfile(arch,'rep.txt');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
      writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
      writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
      writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
      writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
      writeln(arch, ' ');
      if Credito = 'True' then
         writeln(arch, dm.centro('FACTURA CREDITO')) ELSE
         writeln(arch, dm.centro('FACTURA CONTADO'));

     writeln(arch, 'Fecha .: '+DateToStr(DM.getFechaServidor)+'    Hora: '+timetostr(time));;
     NCF := Trim(QTicketNCF_Fijo.Text)+DM.FillCeros(QTicketNCF_Secuencia.Text,8);
     writeln(arch, 'NCF: '+NCF);


     with QDatos do begin
       Close;
       SQL.Clear;
       sql.Add('SELECT CAST(CAST(FECHAVENC AS CHAR(11)) AS DATETIME) FECHAVENC, NCF_Fijo FROM NCF WHERE RTRIM(NCF_Fijo) = SUBSTRING(:NCF,1,3)');
       Parameters.ParamByName('NCF').Value := Trim(QTicketNCF.Text);
       Open;
       IF ((NOT IsEmpty) and (FieldByName('NCF_Fijo').AsString = 'B01')) then
       writeln(arch, 'Vence: '+fieldbyname('FECHAVENC').text);
     end;

     if QTicketnombre.Value <> '' then
      begin
        writeln(arch, 'CLIENTE: '+QTicketnombre.Value);
        if Trim(QTicketrnc.Value) <> '' then
          writeln(arch, 'RNC: '+QTicketrnc.Value);
       end;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select ncf_nombre from ncf_ticket_tipodoc');
      dm.Query1.SQL.Add('where ncf_numero = :tipo');
      dm.Query1.Parameters.ParamByName('tipo').Value := QTicketNCF_Tipo.Value;
      dm.Query1.Open;
      writeln(arch, '----------------------------------------');
      writeln(arch, dm.Centro(dm.Query1.FieldByName('ncf_nombre').AsString));
      writeln(arch, '----------------------------------------');
      writeln(arch, 'DESCRIPCION           ITBIS        VALOR');
      writeln(arch, '----------------------------------------');
      TFac := 0;
      MontoItbis := 0;
      QDetalle.First;
      while not QDetalle.eof do
      begin
    v_subtotal := v_subtotal + (QDetalleprecio.value*QDetallecantidad.value);
    Tfac := Tfac + ((QDetalleprecio.value*QDetallecantidad.value) - QDetalledescuento.value);
    v_itbis_sd := v_itbis_sd + ((QDetalleprecio.Value*QDetallecantidad.Value)/(1+(QDetalleitbis.Value/100)))*(QDetalleitbis.Value/100);
    v_itbis_cd := v_itbis_cd + QDetalleCalcItbis.Value;


    Writeln(arch, format('%n',[QDetallecantidad.value])+' x '+format('%n',[QDetalleprecio.value]));


    if QDetalleitbis.value > 0 then lbitbis := ' ' else lbitbis := 'E';


    if Length(trim(QDetalledescripcion.value))>20 then begin
    writeln(arch, copy(trim(QDetalledescripcion.value),1,20)+
                  dm.FillSpaces(FormatCurr('#,0.00',((QDetalleprecio.Value*QDetallecantidad.Value)/(1+(QDetalleitbis.Value/100)))*(QDetalleitbis.Value/100)),8)+' '+
                  dm.FillSpaces(FormatCurr('#,0.00',(QDetalleprecio.Value*QDetallecantidad.Value)),9)+
                  ' '+lbitbis);
    writeln(arch, copy(trim(QDetalledescripcion.value),20,20));
    end;

    if Length(trim(QDetalledescripcion.value))<21 then begin
    writeln(arch, dm.FillSpacesLeft(trim(QDetalledescripcion.value),20)+
                  dm.FillSpaces(FormatCurr('#,0.00',((QDetalleprecio.Value*QDetallecantidad.Value)/(1+(QDetalleitbis.Value/100)))*(QDetalleitbis.Value/100)),8)+' '+
                    dm.FillSpaces(FormatCurr('#,0.00',(QDetalleprecio.Value*QDetallecantidad.Value)),9)+
                  lbitbis);
  end;
    QDetalle.next;
  end;
  writeln(arch, '                             -----------');
  writeln(arch, dm.FillSpacesLEFT('SUB-TOTAL',23)+
                  dm.FillSpaces(FormatCurr('#,0.00',v_itbis_sd),8)+' '+
                  dm.FillSpaces(FormatCurr('#,0.00',(v_subtotal)),9));
  writeln(arch, dm.FillSpacesLEFT('DESCUENTO',32)+
                  dm.FillSpaces(FormatCurr('#,0.00',QTicketdescuento.value),9));
  writeln(arch, dm.FillSpacesLEFT('SUB-TOTAL',23)+
                  dm.FillSpaces(FormatCurr('#,0.00',v_itbis_cd),8)+' '+
                  dm.FillSpaces(FormatCurr('#,0.00',(QTickettotal.Value)),9));
  writeln(arch, ' ');

writeln(arch, '                   ---------------------');
      tCambio := (QTickettotal.Value-MPagado);
      if Credito = 'True' then
      begin
         if QFormaPago.Locate('forma','EFE',[]) then
         begin
           MPagado := QFormaPagopagado.Value-QFormaPagodevuelta.Value;
           tCambio := (QTickettotal.Value-QFormaPagopagado.Value-MPagado)
         end
         else
         begin
           MPagado := 0;
           tCambio := 0;
         end;
      end;

      s := '';
      FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
      s1:= '';
      FillChar(s1, 10-length(trim(FORMAT('%n',[MPagado]))), ' ');
      s2:= '';
      FillChar(s2, 10-length(trim(FORMAT('%n',[tCambio*-1]))), ' ');
      s3:= '';
      FillChar(s3, 10-length(trim(FORMAT('%n',[MontoItbis]))), ' ');
      s4:= '';
      FillChar(s4, 10-length(trim(FORMAT('%n',[TFac]))), ' ');


      writeln(arch,'Total    : '+s4+format('%n',[QTickettotal.Value]));
      writeln(arch,'Recibido : '+s1+format('%n',[MPagado]));
      writeln(arch,'Cambio   : '+s2+format('%n',[tCambio*-1]));
      writeln(arch, ' ');

      writeln(arch, '----Forma de Pago----');
      QFormaPago.First;
      MPagado := 0;
      while not QFormaPago.Eof do
      begin
        s := '';
        FillChar(s, 10-length(trim(FORMAT('%n',[QFormaPagopagado.Value]))), ' ');

        if QFormaPagoFORMA.Value <> 'CRE' then
          MPagado := MPagado + QFormaPagopagado.Value;;

        if QFormaPagoFORMA.Value = 'EFE' then
          Forma := 'Efectivo .: '
        else if QFormaPagoFORMA.Value = 'TAR' then
          Forma := 'Tarjeta ..: '
        else if QFormaPagoFORMA.Value = 'CHE' then
          Forma := 'Cheque ...: '
        else if QFormaPagoFORMA.Value = 'DEV' then
          Forma := 'Nota de CR: '
        else if QFormaPagoFORMA.Value = 'BOC' then
          Forma := 'Club .....: '
        else if QFormaPagoFORMA.Value = 'OBO' then
          Forma := 'Ot. Bono .: '
        else if QFormaPagoFORMA.Value = 'CRE' then
          Forma := 'Credito ..: ';

        writeln(arch, Forma+s+Format('%n',[QFormaPagopagado.Value]));
        QFormaPago.Next;
      end;

      writeln(arch, ' ');

      if Credito = 'True' then
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
      writeln(arch, ' ');

      Query1.close;
      Query1.SQL.clear;
      Query1.SQL.add('select PAR_TKMENSAJE1,PAR_TKMENSAJE2,PAR_TKMENSAJE3,');
      Query1.SQL.add('PAR_TKMENSAJE4,PAR_TKCLAVEDELETE,PAR_TKCLAVEMODIFICA');
      Query1.SQL.add('from parametros where emp_codigo = :emp');
      Query1.Parameters.ParamByName('emp').Value := empresainv;
      Query1.open;

      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE1').AsString));
      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE2').AsString));
      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE3').AsString));
      writeln(arch, dm.centro(Query1.fieldbyname('PAR_TKMENSAJE4').AsString));
      writeln(arch, ' ');




      if Credito = 'True' then
         writeln(arch, 'Doc Cr : '+IntToStr(MovTicket));





      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
      dm.Query1.Open;
      codigoabre := dm.Query1.FieldByName('codigo_abre_caja').AsString;

      if codigoabre = 'Termica' then
        writeln(arch,chr(27)+chr(109));

      closefile(Arch);
      //dm.Imp40Columnas(arch);
      winexec('imp.bat',0);

      if Reimprimiendo = 'N' then
      begin
        if Credito = 'True' then
        begin
           MessageDlg('PRESIONE [ENTER] PARA IMPRIMIR LA COPIA',mtInformation,[mbok],0);
         //  dm.Imp40Columnas(arch);
        end;
      end;


    end;
  end;
  end;
function TfrmMain.GetLocalIp: string;
{var
   IPW: TIdIPWatch;
begin
  IpW := TIdIPWatch.Create(nil);
  try
    if IpW.LocalIP <> '' then
      Result := IpW.LocalIP;
  finally
    IpW.Free;
  end;}
type
  pu_long = ^u_long;
var
  varTWSAData : TWSAData;
  varPHostEnt : PHostEnt;
  varTInAddr : TInAddr;
  namebuf : Array[0..255] of char;
begin
  If WSAStartup($101,varTWSAData) <> 0 Then
  Result := 'No. IP Address'
  Else Begin
    gethostname(namebuf,sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := inet_ntoa(varTInAddr);
  End;
  WSACleanup;
end;


procedure TfrmMain.QDetalleAfterPost(DataSet: TDataSet);
begin
if QDetalle.RecordCount > 0 then
lblCantProd.Caption := 'Cant. '+FormatCurr('#,0',QDetalle.RecordCount);

if not qDetalleproducto.isnull then
begin
MDLista.Append;
MDListaLProducto.Value := qDetalleproducto.Value;
MDLista.Post;
end;


end;

procedure TfrmMain.MDDetallesCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
  if QDetalleITBIS.value > 0 then
  begin
    NumItbis := strtofloat(format('%10.2f',[(QDetalleITBIS.value/100)+1]));
    Venta    := strtofloat(format('%10.4f',[(QDetallePRECIO.value+QDetallerecargo.AsFloat)/NumItbis]));

    if QDetalledescuento.Value = 0 then
    begin
      QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                   strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

      QDetalleTotalPrecio.Value := strtofloat(format('%10.4f',[Venta])) +
                      strtofloat(format('%10.2f',[QDetalleCalcItbis.value]));
      QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
      QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                   strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                   strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
    end
    else
    begin
      QDetalleTotalDescuento.Value := (QDetallePRECIO.value * QDetalledescuento.Value) / 100;
      Venta := strtofloat(format('%10.4f',[(QDetallePRECIO.value - QDetalleTotalDescuento.Value)/NumItbis]));
      //Venta := strtofloat(format('%10.4f',[QDetallePRECIO.value/NumItbis]));

      QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                   strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

      QDetalleTotalPrecio.Value := strtofloat(format('%10.4f',[Venta])) +
                      strtofloat(format('%10.2f',[QDetalleCalcItbis.value]));
      QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
      QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                   strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                   strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
    end;
  end
  else
  begin
    Venta := strtofloat(format('%10.2f',[QDetallePRECIO.value+QDetallerecargo.AsFloat]));

    QDetalleTotalDescuento.Value := (Venta * QDetalledescuento.Value) / 100;
    Venta := Venta - QDetalleTotalDescuento.Value;

    QDetalleValor.value       := strtofloat(format('%10.2f',[(Venta)*QDetalleCANTIDAD.value]));
    QDetalleTotalPrecio.Value := strtofloat(format('%10.2f',[Venta])) +
                    strtofloat(format('%10.4f',[QDetalleCalcItbis.value]));
    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleCalcItbis.value   := 0;
  end;
  //QDetalleValor.Value := QDetalleprecio.Value * QDetallecantidad.Value;

  if QDetalleitbis.Value >0 then
    QDetalleExcento.Value := ''
  else
    QDetalleExcento.Value := 'E';

end;

procedure TfrmMain.ImpTicketRifa;
var
  arch, arch2, ptocaja : textfile;
  X,Y, I: Integer;
  ValorRifa : Double;
  Msg1, Msg2, Msg3, Msg4, Puerto, codigoabre, ValorRifaN : String;
begin

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
      dm.Query1.Open;
      Puerto := DM.Query1.FieldByName('Puerto').AsString;
      codigoabre := dm.Query1.FieldByName('codigo_abre_caja').AsString;
      dm.Query1.Close;




      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select (isnull(par_valor_punto,0)*isnull(par_punto_principal,0)*100) ValorRifa FROM parametros');
      dm.Query1.SQL.Add('where emp_codigo = :emp');
      dm.Query1.Parameters.ParamByName('emp').Value := empresa;
      dm.Query1.Open;
      ValorRifa := DM.Query1.FieldByName('ValorRifa').Value;
      ValorRifaN := FormatCurr('#,0.00',ValorRifa);
      dm.Query1.Close;
      if ValorRifa >=1 then begin
      Y := 0;
      Y := trunc(QTickettotal.Value/ValorRifa);

      qSecuencia.Close;
      qSecuencia.Parameters.ParamByName('X').Value := 1;
      qSecuencia.Parameters.ParamByName('Y').Value := Y;
      qSecuencia.Open;
      qSecuencia.First;

      if Y >= 1 then begin
      winexec('del .\*.txt',0);

      assignfile(arch2,'.\imprifa.bat');
      {I-}
      rewrite(arch2);
      while not qSecuencia.Eof do begin
      writeln(arch2, 'type .\reprifa_'+Format('%.5d',[qSecuencianum.Value])+'.txt > '+Puerto);


      assignfile(arch,'.\reprifa_'+Format('%.5d',[qSecuencianum.Value])+'.txt');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
      writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
      writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
      writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
      writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
      writeln(arch, ' ');
      writeln(arch, 'Por cada '+ValorRifaN);
      writeln(arch, '');
      writeln(arch, dm.centro('*** B O L E T O  R I F A ***'));
      writeln(arch, ' ');
      Msg2 := '';
      Msg2 := QTicketticket.Text+FormatDateTime('yyyymmdd',DM.getFechaServidor)+Format('%.5d',[qSecuencianum.Value]);
      writeln(arch, 'Boleto #'+MSG2);
      writeln(arch, ' ');
      writeln(arch, 'NOMBRE:___________________________________');
      writeln(arch, ' ');
      writeln(arch, 'CEDULA:___________________________________');
      writeln(arch, ' ');
      writeln(arch, 'TELEFONO:_________________________________');
      writeln(arch, ' ');

      writeln(arch, 'participa en la rifa');
      writeln(arch, ' ');
      Msg1 := FormatDateTime('dd/mm/yyyy hh:mm',DM.getFechaServidor2);
      writeln(arch, msg1);
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');
      writeln(arch, ' ');



      if codigoabre = 'Termica' then
        writeln(arch,chr(27)+chr(109));
      closefile(Arch);

      qSecuencia.Next;
      end;


      closefile(Arch2);
      winexec('.\imprifa.bat',0);
      end;

     { if qSecuencia.RecordCount > 0 then begin
      qSecuencia.First;
      while not qSecuencia.Eof do begin
      if FileExists('.\reprifa_'+Format('%.5d',[qSecuencianum.Value])+'.txt') then
      DeleteFile('.\reprifa_'+Format('%.5d',[qSecuencianum.Value])+'.txt');
      qSecuencia.Next;
      end;
      end; }
      end;
      end;


procedure TfrmMain.actBuscarPesoExecute(Sender: TObject);
var
pesoVariable:integer;
Peso,Resultado :Real;
lc_peso     :string;

begin
    oposscale1.Open('Zebra_Scale') ;
    oposscale1.ClaimDevice(1000);
    oposscale1.DeviceEnabled:=True;
    PesoVariable:=0;
    edCantidad.Text:='0';
    oposscale1.ReadWeight(pesovariable,1000) ;
    if pesoVariable<> 0 Then
      begin
      Peso:=  (Pesovariable/1000);
      edCantidad.Text:= Floattostr(peso);
      edproducto.SetFocus;
    end
    else
      Peso:=  1  ;
      edCantidad.Text:= Floattostr(peso);
      edproducto.SetFocus;

end;

procedure TfrmMain.BuscaProducto2(producto: string);
var
  Valor, Decimal, FormaTicketPeso, Cant : String;
  digitos, digitos_entero, digitos_decimal : integer;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select par_digitos_precio_pesar, par_forma_ticket_peso, par_digitos_entero, par_digitos_decimal');
  dm.Query1.SQL.Add('from parametros where emp_codigo = :emp');
  dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
  dm.Query1.Open;
  digitos         := dm.Query1.FieldByName('par_digitos_precio_pesar').AsInteger;
  FormaTicketPeso := dm.Query1.FieldByName('par_forma_ticket_peso').AsString;
  digitos_entero  := dm.Query1.FieldByName('par_digitos_entero').AsInteger;
  digitos_decimal := dm.Query1.FieldByName('par_digitos_decimal').AsInteger;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio1, pro_precio2, pro_display,pro_serializado,');
  dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
  dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, pro_cantempaque, pro_existempaque, pro_costoempaque, isnull(pro_detallado,''False'') Detallado from productos');
  if primercampo = 'L' then
    dm.Query1.SQL.Add('where pro_roriginal like '+QuotedStr('%'+edproducto.Text))
  else
  begin
    dm.Query1.SQL.Add('where pro_roriginal = :pro');
    dm.Query1.Parameters.ParamByName('pro').Value := producto;
  end;
  dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
  dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    if FormaTicketPeso = 'M' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio1, pro_precio2, pro_display,pro_serializado,');
      dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
      dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, isnull(pro_detallado,''False'') Detallado  from productos');
      dm.Query1.SQL.Add('where pro_roriginal = :pro');
      dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
      dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,1,6);
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin
        if digitos = 3 then
        begin
          CodigoLector := copy(producto,1,6);
          Valor := copy(producto,7,3);
          Decimal := copy(producto,10,3);
          Valor := Valor+'.'+Decimal;
          Precio := StrToFloat(Valor);
        end
        else if digitos = 4 then
        begin
          CodigoLector := copy(producto,1,6);
          Valor := copy(producto,7,4);
          Decimal := copy(producto,11,3);
          Valor := Valor+'.'+Decimal;
          Precio := StrToFloat(Valor);
        end;
      end;
    end
    else if FormaTicketPeso = 'C' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio1, pro_precio2, pro_display,pro_serializado,');
      dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
      dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, isnull(pro_detallado,''False'') Detallado  from productos');
      dm.Query1.SQL.Add('where pro_roriginal = :pro');
      dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      if digitos = 0 then
         dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,2,6)
      else
         dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,1,digitos);

      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin
        if digitos_entero > 0 then
        begin
          CodigoLector := copy(producto,1,digitos);
          Cant    := copy(producto,digitos+1,digitos_entero);
          Decimal := copy(producto,digitos+digitos_entero+1,2);
          Valor := Cant+'.'+Decimal;
          edcantidad.text := Valor;
          Precio := dm.Query1.FieldByName('pro_precio1').AsFloat;
        end
        else
        begin
          CodigoLector := copy(producto,1,7);
          Cant    := copy(producto,8,3);
          Decimal := copy(producto,11,2);
          Valor := Cant+'.'+Decimal;
          edcantidad.Text := Valor;
          //Precio := dm.Query1.FieldByName('pro_precio1').AsFloat * StrToFloat(Valor);
          Precio := dm.Query1.FieldByName('pro_precio1').AsFloat;
        end;
      end
    end
    else if FormaTicketPeso = 'T' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select pro_codigo, pro_costo, substring(pro_nombre,1,80) pro_nombre, pro_precio1, pro_precio2, pro_display,pro_serializado,');
      dm.Query1.SQL.Add('fam_codigo, dep_codigo, sup_codigo, ger_codigo, gon_codigo, col_codigo, mar_codigo, pro_montoitbis,');
      dm.Query1.SQL.Add('pro_existencia, pro_itbis, pro_precio3, pro_precio4, pro_patrocinador, isnull(pro_detallado,''False'') Detallado  from productos');
      dm.Query1.SQL.Add('where pro_roriginal = :pro');
      dm.Query1.SQL.Add('and emp_codigo = :emp and pro_status = '+QuotedStr('ACT'));
      dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
      dm.Query1.Parameters.ParamByName('pro').Value := copy(edProducto.text,1,6);
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then
      begin
        if digitos = 3 then
        begin
          CodigoLector := copy(producto,1,6);
          Valor := copy(producto,7,3);
          Decimal := copy(producto,10,3);
          Valor := Valor+'.'+Decimal;
          edcantidad.Text := StrToFloat(Valor) / dm.Query1.FieldByName('pro_precio1').Value;
          {if PrecioClie <> '' then
          Precio := dm.Query1.FieldByName(PrecioClie).Value else}
          Precio := dm.Query1.FieldByName('pro_precio1').Value;
        end
        else if digitos = 4 then
        begin
          CodigoLector := copy(producto,1,6);
          Valor := copy(producto,7,4);
          Decimal := copy(producto,11,3);
          Valor := Valor+'.'+Decimal;
          edcantidad.Text := StrToFloat(Valor) / dm.Query1.FieldByName('pro_precio1').Value;
          {if PrecioClie <> '' then
          Precio := dm.Query1.FieldByName(PrecioClie).Value else}
          Precio := dm.Query1.FieldByName('pro_precio1').Value;
        end;
      end;
  end;
  end
  else
  begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select * from productos where emp_codigo = :paremp and pro_roriginal =:pro');
  DM.Query1.Parameters.ParamByName('paremp').Value := DM.QParametrosPAR_INVEMPRESA.Value;
  DM.Query1.Parameters.ParamByName('pro').Value := edproducto.Text;
  DM.Query1.Open;
  if DM.Query1.RecordCount > 0 then
  CodigoLector := edproducto.Text else
  CodigoLector := '';

  end;

end;

procedure TfrmMain.ImpTicketCardNet;
var
  archCardNet, puertopeqCardNet : textfile;
  s, s1, s2, s3, s4, s5,s6 : array [0..20] of char;
  Tfac, Saldo : double;
  vp_puerto, lbitbis, impcodigo, parametro, Unidad, codigoabre : string;
  a,x : integer;
  b : myJSONItem;
begin
with qImpCardNet do begin
Close;
Parameters.ParamByName('emp').Value :=  QTicketemp_codigo.Value;
Parameters.ParamByName('tic').Value :=  QTicketticket.Value;
Parameters.ParamByName('fec').Value :=  QTicketfecha.Value;
Parameters.ParamByName('caj').Value :=  QTicketcaja.Value;
Parameters.ParamByName('usu').Value :=  QTicketusu_codigo.Value;
Open;
if qImpCardNet.RecordCount > 0 then begin

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then begin
      codigoabre := Trim(dm.Query1.fieldbyname('codigo_abre_caja').Value);
      vp_puerto     := Trim(dm.Query1.fieldbyname('puerto').Value);

  b := myJSONItem.Create;
  b.Code :=  qImpCardNet.fieldByName('JSON').Value;

  if FileExists('.\puerto.txt') then
  begin
    assignfile(puertopeqCardNet, '.\puerto.txt');
    reset(puertopeqCardNet);
    readln(puertopeqCardNet, vp_puerto);
  end
  else
    puerto := 'PRN';

  closefile(puertopeqCardNet);

  AssignFile(archCardNet, '.\impverifone.bat');
  rewrite(archCardNet);
  writeln(archCardNet, 'type .\tverifone.txt > '+vp_puerto);
  closefile(archCardNet);

  //Ticket Comercio
  AssignFile(archCardNet, '.\tverifone.txt');
  rewrite(archCardNet);
  parametro := qImpCardNet.fieldbyname('SUCURSAL').Text;
  writeln(archCardNet,dm.centro(parametro));
  writeln(archCardNet,dm.centro(qImpCardNet.FieldByName('DIRECCION').text));
  writeln(archCardNet,b['DataTime'].getStr);
  parametro := IntToStr(b['Transaction']['Reference'].getInt);
  writeln(archCardNet,'No. Trans.      : '+parametro);
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('REGISTRO DE LA TRANSACCION'));
  writeln(archCardNet,'No. de Terminal : '+b['TerminalID'].getStr);
  writeln(archCardNet,'ID Comerciante  : '+b['MerchantID'].getStr);
  writeln(archCardNet,'');
  writeln(archCardNet,'TARJETA         : ' +b['Card']['Product'].getStr);
  if not b['Transaction']['LoyaltyDeferredNumber'].isNull then 
  writeln(archCardNet,'TIPO COMPRA     : '+b['Transaction']['LoyaltyDeferredNumber'].getStr);
  parametro  := copy(b['Card']['CardNumber'].getStr,Length(b['Card']['CardNumber'].getStr)-3,Length(b['Card']['CardNumber'].getStr));
  writeln(archCardNet,'No. tarjeta     : '+parametro);
  writeln(archCardNet,'Modo Entrada    : '+b['Host']['Description'].getStr);
  writeln(archCardNet,'APROBADA        : EN LINEA');
  writeln(archCardNet,'Cliente         : '+copy(b['Card']['HolderName'].getStr,1,24));
  parametro := FormatCurr('#,0.00',qImpCardNet.FieldByName('montosinitbis').Value);
  writeln(archCardNet,'Monto RD$       : '+ parametro);
  parametro := FormatCurr('#,0.00',qImpCardNet.FieldByName('monto_itbis').Value);
  writeln(archCardNet,'Itbis RD$       : '+parametro);
  parametro := FormatCurr('#,0.00',qImpCardNet.FieldByName('monto').Value);
  writeln(archCardNet,'Total RD$       : '+parametro);
  writeln(archCardNet,'');
  writeln(archCardNet,DM.CENTRO('APROBADA'));
  writeln(archCardNet,'');
  writeln(archCardNet,'No de referencia: '+b['Transaction']['RetrievalReference'].getStr);
  writeln(archCardNet,'No Autorizacion : '+b['Transaction']['AuthorizationNumber'].getStr);
  writeln(archCardNet,'Fecha            : '+copy(b['Transaction']['DataTime'].getStr,1,23));
  writeln(archCardNet,'');
  writeln(archCardNet,'');
  writeln(archCardNet,dm.Centro('_________________________'));
  writeln(archCardNet,dm.centro(copy(b['Card']['HolderName'].getStr,1,24)));
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('***Original Comercio***'));
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('***FIN DOCUMENTO NO VENTA***'));
  for x:= 1 to 2 do begin
  writeln(archCardNet,'');
  end;

  if codigoabre = 'Termica' then
  writeln(archCardNet,chr(27)+chr(109));

  CloseFile(archCardNet);

 winexec('.\impverifone.bat',0);

 //Ticket Copia
  AssignFile(archCardNet, '.\tverifoneCopia.bat');
  rewrite(archCardNet);
  writeln(archCardNet, 'type .\tverifoneCopia.txt > '+vp_puerto);
  closefile(archCardNet);

  AssignFile(archCardNet, '.\tverifoneCopia.txt');
  rewrite(archCardNet);
  parametro := qImpCardNet.fieldbyname('SUCURSAL').Text;
  writeln(archCardNet,dm.centro(parametro));
  writeln(archCardNet,dm.centro(qImpCardNet.FieldByName('DIRECCION').text));
  writeln(archCardNet,b['DataTime'].getStr);
  //parametro := IntToStr(b['Transaction']['Reference'].getInt);
  //writeln(archCardNet,'No. Trans.      : '+parametro);
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('REGISTRO DE LA TRANSACCION'));
  //writeln(archCardNet,'No. de Terminal : '+b['TerminalID'].getStr);
  //writeln(archCardNet,'ID Comerciante  : '+b['MerchantID'].getStr);
  writeln(archCardNet,'');
  writeln(archCardNet,'TARJETA         : ' +b['Card']['Product'].getStr);
  //writeln(archCardNet,'TIPO COMPRA     : '+b['Transaction']['LoyaltyDeferredNumber'].getStr);
  parametro  := copy(b['Card']['CardNumber'].getStr,Length(b['Card']['CardNumber'].getStr)-3,Length(b['Card']['CardNumber'].getStr));
  writeln(archCardNet,'No. tarjeta     : '+parametro);
  writeln(archCardNet,'Modo Entrada    : '+b['Host']['Description'].getStr);
  writeln(archCardNet,'APROBADA        : EN LINEA');
  //writeln(archCardNet,'Cliente         : '+copy(b['Card']['HolderName'].getStr,1,24));
  //writeln(archCardNet,'');
  writeln(archCardNet,'');
  parametro := FormatCurr('#,0.00',qImpCardNet.FieldByName('montosinitbis').Value);
  writeln(archCardNet,'Monto RD$       : '+ parametro);
  parametro := FormatCurr('#,0.00',qImpCardNet.FieldByName('monto_itbis').Value);
  writeln(archCardNet,'Itbis RD$       : '+parametro);
  parametro := FormatCurr('#,0.00',qImpCardNet.FieldByName('monto').Value);
  writeln(archCardNet,'Total RD$       : '+parametro);
  //writeln(archCardNet,'');
  //writeln(archCardNet,'');
  writeln(archCardNet,DM.CENTRO('APROBADA'));
 // writeln(archCardNet,'');
 // writeln(archCardNet,'');
 // writeln(archCardNet,'No de referencia: '+b['Transaction']['RetrievalReference'].getStr);
  writeln(archCardNet,'No Autorizacion : '+b['Transaction']['AuthorizationNumber'].getStr);
  writeln(archCardNet,'Fecha            : '+copy(b['Transaction']['DataTime'].getStr,1,23));
 // writeln(archCardNet,'Hora             : '+trim(copy(b['Transaction']['DataTime'].getStr,12,20)));
  //writeln(archCardNet,'');
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('***Copia Cliente***'));
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('***FIN DOCUMENTO NO VENTA***'));

  for x:= 1 to 2 do begin
  writeln(archCardNet,'');
  end;

  if codigoabre = 'Termica' then
  writeln(archCardNet,chr(27)+chr(109));

  CloseFile(archCardNet);

 winexec('.\tverifoneCopia.bat',0);

 vl_respverifone := '';
 vl_tarjeta := '';


end;
end;
end;

end;

procedure TfrmMain.pnabrircaja2;
var
  arch : textfile;
  codigo, cod, abrir : string;
  a : integer;
  lista : tstrings;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select Puerto, codigo_abre_caja, codigo_abre_caja_tipo from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
  dm.Query1.Open;
  codigo := dm.Query1.FieldByName('codigo_abre_caja').AsString;
  puerto := dm.Query1.FieldByName('Puerto').AsString;
  puerto2 := dm.Query1.FieldByName('codigo_abre_caja_tipo').AsString;


  if codigo = 'FISCAL' then begin
  OpenCashDrawerFiscal(Impresora)
  end
  else
    begin
      if codigo = 'TMU' then
      begin
        assignfile(arch,'.\caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(27)+chr(112)+chr(0)+chr(25)+chr(250));
        closefile(arch);
      end
      else if codigo = 'Termica' then
      begin
        assignfile(arch,'.\caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(27)+chr(112)+chr(0)+chr(50)+chr(250));
        writeln(arch,chr(27)+chr(7));
        closefile(arch);
      end
      else if codigo = 'Star' then
      begin
        assignfile(arch,'.\caja.txt');
        {I-}
        rewrite(arch);
        {I+}
        writeln(arch,chr(28));
        closefile(arch);
      end;


      assignfile(arch,'.\caja.bat');
      {I-}
      rewrite(arch);
      {I+}
      writeln(arch,'type .\caja.txt > '+puerto);
      closefile(arch);

      winexec('.\caja.bat',0);
    end;
  edproducto.SetFocus;
end;

procedure TfrmMain.QTicketBeforePost(DataSet: TDataSet);
begin
QTicketfecha.AsDateTime := DM.getFechaServidor;
QTicketemp_codigo.Value := empcaja;
QTicketsuc_codigo.Value := vp_suc;

end;

procedure TfrmMain.qDetalleBeforePost(DataSet: TDataSet);
begin
qDetallefecha.AsDateTime := DM.getFechaServidor;
IF lbund.Caption = 'EMPAQUE' THEN
qDetalleempaque.Value := 'S' ELSE
qDetalleempaque.Value := 'N';
//Lista.Items.Delete(Lista.Items.IndexOf(IntToStr(QDetallePRO_CODIGO.Value)));

end;

procedure TfrmMain.VerificarVentasInespre;
begin
//BUSCAR SI SE VENDIO UN COMBO AL CIUDADADONO
if (dbRnc.Text <> '') and (qDetalle.RecordCount>0) then begin
qDetalle.DisableControls;
qDetalle.First;
WHILE NOT qDetalle.Eof DO BEGIN
with qVerVentaGobierno do begin
Close;
Parameters.ParamByName('emp').DataType := ftInteger;
Parameters.ParamByName('pro').DataType := ftInteger;
Parameters.ParamByName('ced').DataType := ftString;
Parameters.ParamByName('emp').Value := empresa;
Parameters.ParamByName('ced').Value := dbRnc.Text;
Parameters.ParamByName('pro').Value := qDetalleproducto.Value;
Open;
if qVerVentaGobierno.RecordCount > 0 then BEGIN
qDetalle.EnableControls;
MessageDlg('ESTE CIUDADANO YA ADQUIRIO SU COMBO DE INESPRE EL DIA DE HOY,'+Char(13)+
           'FAVOR REVISAR...',mtWarning,[mbOK],0);
Abort;
end;
qDetalle.Next;
end;
end;
qDetalle.EnableControls;
end;
end;

procedure TfrmMain.VerificarMasUnCombo;
var
  combocant : Double;
begin
combocant := 0;
//BUSCAR CANTIDAD VENDIO UN COMBO AL CIUDADADONO
if (dbRnc.Text <> '') and (qDetalle.RecordCount>0) then begin
qDetalle.DisableControls;
qDetalle.First;
WHILE NOT qDetalle.Eof DO BEGIN
with qCantComboInespre do begin
Close;
Parameters.ParamByName('emp').DataType := ftInteger;
Parameters.ParamByName('pro').DataType := ftInteger;
Parameters.ParamByName('emp').Value := empresa;
Parameters.ParamByName('pro').Value := qDetalleproducto.Value;
Open;
if qCantComboInespre.RecordCount > 0 then
combocant := combocant+ qDetallecantidad.VALUE;
qDetalle.Next;
end;
end;
IF combocant > 1 THEN BEGIN
qDetalle.EnableControls;
MessageDlg('ESTE CIUDADANO NO PUEDE ADQUIRIR MAS DE UN COMBO DE INESPRE EN EL DIA DE HOY,'+Char(13)+
           'FAVOR REVISAR...',mtWarning,[mbOK],0);
Abort;
end;
qDetalle.EnableControls;
end;

if (dbRnc.Text = '') and (qDetalle.RecordCount>0) then begin
combocant := 0;
qDetalle.DisableControls;
qDetalle.First;
WHILE NOT qDetalle.Eof DO BEGIN
with qCantComboInespre do begin
Close;
Parameters.ParamByName('emp').DataType := ftInteger;
Parameters.ParamByName('pro').DataType := ftInteger;
Parameters.ParamByName('emp').Value := empresa;
Parameters.ParamByName('pro').Value := qDetalleproducto.Value;
Open;
if qCantComboInespre.RecordCount > 0 then
combocant := combocant+ qDetallecantidad.VALUE;
qDetalle.Next;
end;
end;
IF combocant >= 1 THEN BEGIN
qDetalle.EnableControls;
MessageDlg('DEBES INDICAR LA CEDULA PARA ADQUIRIR UN COMBO DE INESPRE, EN EL DIA DE HOY'+Char(13)+
           'FAVOR REVISAR...',mtWarning,[mbOK],0);
Abort;
end;
qDetalle.EnableControls;
end;


end;


procedure TfrmMain.qDetalleBeforeDelete(DataSet: TDataSet);
begin
if MDLista.RecordCount >  0 then begin
if MDLista.Locate('LProducto',IntToStr(GetProducto),[]) then
MDLista.Delete;
end;
end;

procedure TfrmMain.qDetalleBeforeEdit(DataSet: TDataSet);
begin
if MDLista.RecordCount >  0 then begin
if MDLista.Locate('LProducto',IntToStr(GetProducto),[]) then
MDLista.Delete;
end;
end;

function TfrmMain.GetProducto: Integer;
begin
if edproducto.Text <> '' then begin
with DM.adoMultiUso do begin
Close;
SQL.Clear;
SQL.Add('SELECT isnull(PRO_CODIGO,0) producto FROM Productos where emp_codigo = :emp and pro_roriginal = :pro');
Parameters.ParamByName('emp').Value := DM.QParametrosPAR_INVEMPRESA.Value;
Parameters.ParamByName('pro').Value := edproducto.Text;
Open;
if FieldByName('producto').Value >  0 then
Result := FieldByName('producto').Value else
Result := 0;
end;
end
else
Result := 0;
end;
function TfrmMain.ImprimeTicketFiscal(
  ImpresoraFiscal: TImpresora): boolean;
begin
  puedeAbrirCaja :=false;
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
  gError:=false;

  if puedeAbrirCaja then
  OpenCashDrawerFiscal(ImpresoraFiscal);

 // Sleep(1000);
    //Envia la factura a la impresora

  case ImpresoraFiscal.IDPrinter of
    1 : {EPSON (TMU-220)} ImpTicketFiscalEpson(ImpresoraFiscal);
    2 : {CITIZEN ( CT-S310 )}  ImpTicketVmaxFiscal(ImpresoraFiscal);
    //3 : {CITIZEN (GSX-190)}    ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    //4 : {STAR (TSP650FP)}      ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    5 : {Bixolon SRP-350iiHG}  ImpTicketFiscalBixolon(Impresora);
  end;
  if gError then
    result := false
  else result := true;

end;

procedure TfrmMain.GuardarNIF(NIF: String);
begin
with DM.Query1 do
  begin
    close;
    SQL.Clear;
    SQL.Append('UPDATE montos_ticket SET NIF = :NIF');
    SQL.Append('where caja = :caj');
    SQL.Append('and ticket = :tik');
    Parameters.ParamByName('NIF').Value := NIF;
    Parameters.ParamByName('caj').Value := QTicketcaja.Value;
    Parameters.ParamByName('tik').Value := QTicketticket.Value;
    ExecSQL;
  end;
end;

procedure TfrmMain.ImpTicketFiscalEpson(ImpresoraFiscal: TImpresora);
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, trecargo : Double;
  Puntos, a : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
   copias: integer;
  DriverFiscal1 : TDriverFiscal;
  NIF:String;
  dgeneral, rgeneral : boolean;
  xCopias : byte;
  stringTMP,stringTMP2,stringTipoITBIS:String;
  x:byte;
  ///---reimpresion
procedure re_ImprimirTicketEpson;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos, pg, cantpg : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
  vTemporal:String;
  Devuelta:String;
  StatusFiscal:String;
  v_DescItems:String;
  DescItems:Double;
  vsubtotal_Itbis, vItbis :Double;
  vsubtotalDesc:double;
  vsubtotal:double;
  vImporte:Double;
  vTotalImpresoraFiscal:Double;
begin
  SetLength(arrayMultiUso, 17);


    err := DriverFiscal1.IF_WRITE('@GetInitData');
    arrayMultiUso[0] := DriverFiscal1.IF_READ(1);
    arrayMultiUso[1] := DriverFiscal1.IF_READ(2);
    arrayMultiUso[2] := DriverFiscal1.IF_READ(3);
    arrayMultiUso[3] := DriverFiscal1.IF_READ(4);

    err := DriverFiscal1.IF_WRITE('@GetFiscalFeatures');
    arrayMultiUso[4] := DriverFiscal1.IF_READ(1); //--Tauru
    arrayMultiUso[5] := DriverFiscal1.IF_READ(2); //
    arrayMultiUso[6] := DriverFiscal1.IF_READ(3); //3
    arrayMultiUso[7] := DriverFiscal1.IF_READ(4); //0
    arrayMultiUso[8] := DriverFiscal1.IF_READ(5); //0
    arrayMultiUso[9] := DriverFiscal1.IF_READ(6);
    arrayMultiUso[10] := DriverFiscal1.IF_READ(7);
    arrayMultiUso[11] := DriverFiscal1.IF_READ(8);
    arrayMultiUso[12] := DriverFiscal1.IF_READ(9);

    err := DriverFiscal1.IF_WRITE('@GetPrinterVersion');
    arrayMultiUso[13] := DriverFiscal1.IF_READ(1);  //Serie
    arrayMultiUso[14] := DriverFiscal1.IF_READ(2);  //id


    err := DriverFiscal1.IF_WRITE('@GetLastTicketStatus');
    arrayMultiUso[15] := DriverFiscal1.IF_READ(1);  //NIF
    //arrayMultiUso[17]
     Devuelta :=  DriverFiscal1.IF_READ(3);  //DEVUELTA

    err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');
    if (err <> 0) then
      begin
        err := DriverFiscal1.IF_ERROR1(0);  //verifica Mecanismo
        err := DriverFiscal1.IF_ERROR2(0);  //Verifica Controlador Fiscal

        StatusFiscal:=IntToBinRec(err,16);    //207
        if StatusFiscal[5] = '1' then
          Application.MessageBox('Se requiere un Cierre Z','Error',MB_OK+MB_ICONERROR);
      end
    else
      begin
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select par_ticket_itbis from parametros');
        dm.Query1.SQL.Add('where emp_codigo = :emp');
        dm.Query1.Parameters.ParamByName('emp').Value := empresainv;
        dm.Query1.Open;
        ImpItbis := dm.Query1.FieldByName('par_ticket_itbis').AsString;

        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'            *** COPIA DE DOCUMENTO FISCAL ***');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+arrayMultiUso[0]);
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'RNC '+arrayMultiUso[1]);
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+arrayMultiUso[2]);
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'            COMPROBANTE AUTORIZADO POR DGII');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+FormatDateTime('dd/mm/yyyy hh:mm:ss', QTicketfecha_hora.Value));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'NIF: '+NIF);
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'NCF: '+QTicketNCF.AsString);
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'-------------------------------------------------------');

        case QTicketNCF_Tipo.Value of
          1:err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'              FACTURA PARA CONSUMIDOR FINAL');
          2:err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'              FACTURA PARA CREDITO FISCAL');
          3:err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'              FACTURA PARA CREDITO FISCAL');
          4:err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'              FACTURA PARA CREDITO FISCAL');
        end;


        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'-------------------------------------------------------');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'DESCRIPCION                 ITBIS           VALOR');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'-------------------------------------------------------');

        //----IMPRIME iNICIO CUERPO
        dgeneral := false;
        rgeneral := false;

        QDetalle.DisableControls;
        QDetalle.First;
        trecargo := 0;
        vsubtotalDesc :=0;
        vsubtotal :=0;
        vsubtotal_Itbis:=0;

        while not QDetalle.eof do
        begin
          vImporte := 0;
          vItbis :=0;
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select isnull(pro_montoitbis,0) as pro_montoitbis from productos where emp_codigo = 1 and pro_codigo = :pro');
          dm.Query1.Parameters.ParamByName('pro').Value := QDetalleproducto.Value;
          dm.Query1.Open;
          MontoItbis := dm.Query1.FieldByName('pro_montoitbis').AsFloat;

          if MontoItbis >= 18 then
            stringTipoITBIS :='  I2'
          else
            if MontoItbis >= 16 then
              stringTipoITBIS :='  I1'
            else
              if MontoItbis >= 13 then
                stringTipoITBIS :='  I5'
              else
                if MontoItbis >= 11 then
                  stringTipoITBIS :='  I4'
                else
                  if MontoItbis >= 8 then
                    stringTipoITBIS :='  I3' ;

          vImporte := (QDetallePrecio.value * QDetallecantidad.value);
          vsubtotal := vsubtotal + vImporte;
          Msg3:=dm.PAD(' ','R',22,copy(trim(QDetalledescripcion.value),1,22));

          if QTicketNCF_Tipo.Value < 4 then
            begin //--[00]
              stringTMP := FormatFloat(',,,0.00', QDetallecantidad.value) + ' x '+
                           FormatFloat(',,,0.00', QDetallePrecio.value);

              if QDetalleCalcItbis.value > 0 then
                begin
                  vItbis :=  (QDetallePrecio.value * QDetallecantidad.value ) ;
                  vItbis :=   vItbis - (vItbis / (1 + (MontoItbis/100)));
                  vsubtotal_Itbis := vsubtotal_Itbis + vItbis;
                end
              else vItbis := 0;

              Msg1 :=dm.PAD(' ','L',15,FormatFloat(',,,0.00', vItbis));
              Msg2 :=dm.PAD(' ','L',15,FormatFloat(',,,0.00',vImporte));
            end //--[00] ----------------
          else if QTicketNCF_Tipo.Value = 4 then
            begin
              stringTMP := FormatFloat(',,,0.00', QDetallecantidad.value) + ' x '+
                           FormatFloat(',,,0.00', QDetallePrecio.value);

              Msg1 :=dm.PAD(' ','L',15,FormatFloat(',,,0.00', QDetalleCalcItbis.value));
              Msg2 :=dm.PAD(' ','L',15,FormatFloat(',,,0.00', (QDetallePrecio.value + ((QDetallePrecio.value*MontoItbis)/100) * QDetallecantidad.value)));
          end;

          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+stringTMP);
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+Msg3+Msg1+Msg2+stringTipoITBIS);

          if QDetalledescuento.Value > 0 then
          begin
              DescItems:= QDetalleTotalDescuento.Value; //// * ((MontoItbis /100)+1) ;
              stringTMP := FormatFloat(',,,0.00', QDetallecantidad.value) + ' x '+
                           FormatFloat(',,,0.00', DescItems);

              err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+stringTMP);

              DescItems := DescItems * QDetallecantidad.value;
              vsubtotalDesc := vsubtotalDesc + DescItems;
              if MontoItbis > 0 then
                vsubtotal_Itbis  := vsubtotal_Itbis - (DescItems - (DescItems / (1+(MontoItbis/100))));

              Msg1 :=FormatFloat(',,,0.00', (DescItems - (DescItems / (1+(MontoItbis/100))))) + '-';
              Msg1:= dm.PAD(' ','L',15,Msg1);

              Msg2 :=FormatFloat(',,,0.00', DescItems)+'-';
              Msg2:=dm.PAD(' ','L',15,Msg2);
              Msg3:=dm.PAD(' ','R',22,'   DESC. ('+FormatFloat(',,,0.00',QDetalleDESCUENTO.Value)+'%)');

              stringTMP2 := Msg3+ Msg1+Msg2+ stringTipoITBIS;
              err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+stringTMP2);

          end;
          QDetalle.next;
        end;
        QDetalle.First;
        QDetalle.EnableControls;

        //----IMPRIME fIN CUERPO
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'-------------------------------------------------------');

        Msg1:= dm.PAD(' ','L',15,FormatFloat(',,,0.00', vsubtotal_Itbis)) ; //--linea de impuestos
        Msg2:= dm.PAD(' ','L',15,FormatFloat(',,,0.00', vsubtotal -  vsubtotalDesc)) ;
        Msg3:= dm.PAD(' ','R',22,'Subtotal')+Msg1+Msg2;
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+Msg3);

        if QTicketdescuento.AsFloat > 0 then
          begin
               Msg3 :=FormatFloat(',,,0.00',QTicketTdesc_gral.AsFloat);
               Msg3:=dm.PAD(' ','R',37,'Descuento') +dm.PAD(' ','L',15,Msg3)+'-';
               err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+Msg3);
          end;

        if trecargo > 0 then
        begin
        end;

        Msg1 :=dm.PAD(' ','L',15,FormatFloat(',,,0.00',QTicketitbis.AsFloat));
        Msg2 :=dm.PAD(' ','L',15,FormatFloat(',,,0.00',QTickettotal.AsFloat));

        Msg3:=   dm.PAD(' ','R',22,'TOTAL')+Msg1+Msg2;
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+Msg3);

        Query1.close;
        Query1.SQL.clear;
        Query1.SQL.add('select PAR_TKMENSAJE1,PAR_TKMENSAJE2,PAR_TKMENSAJE3,');
        Query1.SQL.add('PAR_TKMENSAJE4,PAR_TKCLAVEDELETE,PAR_TKCLAVEMODIFICA');
        Query1.SQL.add('from parametros where emp_codigo = :emp');
        Query1.Parameters.ParamByName('emp').Value := empresainv;
        Query1.open;
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        QFormaPago.DisableControls;
        QFormaPago.First;
        while not QFormaPago.Eof do
        begin
          if QFormaPagoforma.AsString = 'TAR' then
          begin
             Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Tarjeta                              '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|3|'+floattostr(QFormaPagopagado.Value));
          end
          else if QFormaPagoforma.AsString = 'CHE' then
          begin
            Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Cheque                               '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|2|'+floattostr(QFormaPagopagado.Value));
          end
          else if QFormaPagoforma.AsString = 'DEV' then
          begin
            Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Devolucion                           '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|11|'+floattostr(QFormaPagopagado.AsFloat));
          end
          else if QFormaPagoforma.AsString = 'CRE' then
          begin
            Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Credito                              '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|7|'+floattostr(QFormaPagopagado.AsFloat));
          end
          else if QFormaPagoforma.AsString = 'BOC' then
          begin
            Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Cupon                                '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|6|'+floattostr(QFormaPagopagado.AsFloat));
          end
          else if QFormaPagoforma.AsString = 'OBO' then
          begin
            Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Otro 2                               '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|8|'+floattostr(QFormaPagopagado.AsFloat));
          end
          else if QFormaPagoforma.AsString = 'EFE' then
          begin
            Msg1 :=FormatFloat(',,,0.00', QFormaPagopagado.Value);
             Msg1:= Copy('               ',1,(15 - Length(Trim(Msg1))))+Msg1;
             err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Efectivo                             '+ Msg1);
            //err := DriverFiscal1.IF_WRITE('@TicketPayment|1|'+floattostr(QFormaPagopagado.Value));
          end;

          QFormaPago.Next;
        end;
        QFormaPago.EnableControls;
        Devuelta:= copy(devuelta, 1,Length(Devuelta)-2)+'.'+copy(devuelta, Length(Devuelta)-1,2) ;

        if ((Devuelta = '') or ( Devuelta = '.0') or (Devuelta = '0')) then
          Devuelta := '0.00';
         Msg1:= Copy('               ',1,(15 - Length(Trim(Devuelta))))+Devuelta;
         err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
         err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'CAMBIO                               '+Msg1);

         err := DriverFiscal1.IF_WRITE('@PaperFeed|1');

         err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Caja   : '+QTicketcaja.AsString);
         err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Cajero : '+edcajero.Caption);
         err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Ticket : '+QTicketticket.AsString);


        if (credito = 'True') then
          begin
            err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|TIPO FACT : CREDITO ');

            if trim(QTicketnombre.AsString) <> '' then
              err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Nombre : '+copy(trim(QTicketnombre.AsString),1,40));

            if trim(QTicketrnc.AsString) <> '' then
              err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|RNC : '+copy(trim(QTicketrnc.AsString),1,40));

            err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
            err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
            err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|     -------------------------');
            err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|            Firma Clte.');
          end
        else
          begin
            err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|TIPO FACT : CONTADO ');
             if trim(QTicketnombre.AsString) <> '' then
              err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|Nombre : '+copy(trim(QTicketnombre.AsString),1,40));

          end;

          err := DriverFiscal1.IF_WRITE('@PaperFeed|1');

        memo1.lines.Clear;
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select mensaje_ticket from parametros where emp_codigo = 1');
        dm.Query1.Open;
        Memo1.Lines.Text := dm.Query1.FieldByName('mensaje_ticket').Value;

        for ln := 0 to memo1.Lines.Count-1 do
        begin
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+copy(memo1.lines[ln],1,40));
        end;




        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'-------------------------------------------------------');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'NIF: '+NIF);
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+arrayMultiUso[13]+'               '+
                                       arrayMultiUso[14] +'          '+
                                       'V: '+arrayMultiUso[6]+'.'+arrayMultiUso[7]+arrayMultiUso[8]+'  '+arrayMultiUso[4]);
        ////err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'            *** FIN DOCUMENTO NO VENTA ***');
        err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|C');
    end;

 end;

  ///--fin re-impresion

  function getPrinterInfo():boolean;
  begin
    SetLength(arrayMultiUso, 17);
    err := DriverFiscal1.IF_WRITE('@GetTicketInfo');
    arrayMultiUso[0] := DriverFiscal1.IF_READ(5);

  end;

  function getPrinterError():boolean;
  begin
    result :=false;
    //err := DriverFiscal1.IF_ERROR1(0);  //verifica Mecanismo
      // Impresora.StatusControladorFiscal:=IntToBinRec(err,16);    //207

      err := 0;
      err := DriverFiscal1.IF_ERROR2(0);//Verifica Controlador Fiscal
      if (err <> 0) then
         Impresora.StatusControladorFiscal:=IntToBinRec(Err,16);    //207

       Impresora.StatusMecanismoFiscal :=IntToBinRec(err,16);

        if ((Impresora.StatusControladorFiscal[2] = '1') or (Impresora.StatusControladorFiscal[11] = '1') or (Impresora.StatusControladorFiscal[12] = '1')) then
          begin
             Application.MessageBox(pchar('Error en mecanismo de impresión'+#13+#12+'Verifique papel'),'Error',MB_OK+MB_ICONERROR);
            result :=true;
          end;

        if Impresora.StatusControladorFiscal[5] = '1' then
          begin
            gError:=true;
            Application.MessageBox('Se requiere un Cierre Z','Error',MB_OK+MB_ICONERROR);
            result :=true;
          end;
  end;

begin

  xCopias :=Impresora.Copia;
  copias := 0;

  //Obtener el puerto donde esta la caja registradora
  if getPregunta_x_Impresion(edCaja.Caption) then
    if MessageDlg('Desea copia de la factura ?', mtConfirmation, [mbyes, mbno], 0) = mryes then
      begin
        if Impresora.Copia > 0 then
          xCopias := Impresora.Copia
        else
          xCopias := 1;
      end
    else  xCopias := 0;

  if ((xCopias > 0 ) and ( Impresora.SustituirCopia = false)) then
    copias :=  xCopias;


  Puerto := PuertoSerial[Impresora.Puerto -1];
  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';

  try
    err := DriverFiscal1.IF_OPEN(puerto, Impresora.Velocidad);
    if (err <> 0 ) then
      begin
        gError:=true;
        ShowMessage('Error : No hay comunicacion con el printer'+#13+#10+
        'Impresion cancelada');
        exit;
      end;

    err := DriverFiscal1.IF_WRITE('@OpenDrawer|'+IntToStr(puertoCaja));
    if err <> 0 then
      if not getPrinterError() then exit;

    if QTicketNCF_Tipo.Value = 1 then //consumidor final
    begin
      err := DriverFiscal1.IF_WRITE('@TicketOpen|A|0001|'+FormatFloat('000', QTicketcaja.Value)+'|'+QTicketNCF.AsString+
           '||||P|'+inttostr(copias));
    end
    else if QTicketNCF_Tipo.Value = 2 then //con Valor Fiscal
    begin
      err := DriverFiscal1.IF_WRITE('@TicketOpen|B|0001|'+FormatFloat('000', QTicketcaja.Value)+'|'+
           QTicketNCF.AsString+'|'+Trim(Copy(QTicketnombre.AsString,1,40))+'|'+QTicketrnc.AsString+'||P|'+inttostr(copias));

    end
    else if QTicketNCF_Tipo.Value = 3 then //Gubernamental
    begin
      err := DriverFiscal1.IF_WRITE('@TicketOpen|B|0001|'+FormatFloat('000', QTicketcaja.Value)+'|'+
           QTicketNCF.AsString+'|'+Trim(Copy(QTicketnombre.AsString,1,40))+'|'+QTicketrnc.AsString+'||P|'+inttostr(copias));

    end
    else if QTicketNCF_Tipo.Value = 4 then //Regimen Especial
    begin
      err := DriverFiscal1.IF_WRITE('@TicketOpen|F|0001|'+FormatFloat('000', QTicketcaja.Value)+'|'+
           QTicketNCF.AsString+'|'+Trim(Copy(QTicketnombre.AsString,1,40))+'|'+QTicketrnc.AsString+'||P|'+inttostr(copias));

    end;

    if (err <> 0) then
      begin
        if not getPrinterError() then exit ;
      end
    else
      begin //--[0*0]--
       { Quitar
        dgeneral := true;
        rgeneral := true;

        QDetalle.DisableControls;
        QDetalle.First;
        while not QDetalle.eof do
        begin
          if QDetalledescuento.Value = 0 then dgeneral := false;
          if QDetallerecargo.Value = 0 then rgeneral := false;
          QDetalle.next;
        end;
        QDetalle.First;
        QDetalle.EnableControls;  }

        QDetalle.DisableControls;
        QDetalle.First;
        trecargo := 0;
        while not QDetalle.eof do
        begin
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select isnull(pro_montoitbis,0) as pro_montoitbis from productos where emp_codigo = 1 and pro_codigo = :pro');
          dm.Query1.Parameters.ParamByName('pro').Value := QDetalleproducto.Value;
          dm.Query1.Open;
          MontoItbis := dm.Query1.FieldByName('pro_montoitbis').AsFloat;

          if QTicketNCF_Tipo.Value < 4 then
          begin
            err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalledescripcion.value),1,22)+'|'+QDetallecantidad.AsString+'|'+
            floattostr(QDetallePrecio.value)+'|'+FloatToStr(MontoItbis));
          end
          else if QTicketNCF_Tipo.Value = 4 then
          begin
            err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalledescripcion.value),1,22)+'|'+QDetallecantidad.AsString+'|'+
            floattostr(RoundTo(QDetallePrecio.value + ((QDetallePrecio.value*MontoItbis)/100) ,-2) )+'|'+FloatToStr(MontoItbis));
          end;

          if QDetalledescuento.Value > 0 then
          begin
            ///if not dgeneral then
            begin
              err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalledescripcion.value),1,22)+'|'+QDetallecantidad.AsString+'|'+
              floattostr(QDetalleTotalDescuento.Value)+'|'+FloatToStr(MontoItbis)+'|D');
            end;
          end;

          if QDetallerecargo.Value > 0 then
          begin
            ////if not rgeneral then
            begin
              err := DriverFiscal1.IF_WRITE('@TicketItem|'+copy(trim(QDetalledescripcion.value),1,22)+'|'+QDetallecantidad.AsString+'|'+
              floattostr(QDetallerecargo.Value)+'|'+FloatToStr(MontoItbis)+'|d');
            end;
          end;

         /// trecargo := trecargo + QDetallerecargo.AsFloat;

          QDetalle.next;
        end;
        QDetalle.First;
        QDetalle.EnableControls;

        err := DriverFiscal1.IF_WRITE('@TicketSubtotal|P');

        if QTicketTdesc_gral.value > 0 then
          err := DriverFiscal1.IF_WRITE('@TicketReturnRecharge|Descuento|'+floattostr(QTicketTdesc_gral.AsFloat));


        ///poner recargo gra.  
        if trecargo > 0 then
        begin
          if rgeneral then
            err := DriverFiscal1.IF_WRITE('@TicketReturnRecharge|Recargo|'+floattostr(trecargo)+'|R');
        end;

        Query1.close;
        Query1.SQL.clear;
        Query1.SQL.add('select PAR_TKMENSAJE1,PAR_TKMENSAJE2,PAR_TKMENSAJE3,');
        Query1.SQL.add('PAR_TKMENSAJE4,PAR_TKCLAVEDELETE,PAR_TKCLAVEMODIFICA');
        Query1.SQL.add('from parametros where emp_codigo = :emp');
        Query1.Parameters.ParamByName('emp').Value := empresainv;
        Query1.open;

        v_TotalPagado:=0;
        QFormaPago.DisableControls;
        QFormaPago.First;
        while not QFormaPago.Eof do
        begin
          v_TotalPagado:= v_TotalPagado + QFormaPagopagado.Value;
          if QFormaPagoforma.AsString = 'CHE' then
            err := DriverFiscal1.IF_WRITE('@TicketPayment|2|'+floattostr(QFormaPagopagado.Value))
          else
            if QFormaPagoforma.AsString = 'TAR' then
              err := DriverFiscal1.IF_WRITE('@TicketPayment|3|'+floattostr(QFormaPagopagado.Value))
            else
              if QFormaPagoforma.AsString = 'TDB' then //Tarjeta DEBito
                err := DriverFiscal1.IF_WRITE('@TicketPayment|4|'+floattostr(QFormaPagopagado.Value))
              else
                if QFormaPagoforma.AsString = 'TPR' then //Tarjeta propia
                  err := DriverFiscal1.IF_WRITE('@TicketPayment|5|'+floattostr(QFormaPagopagado.Value))
                else
                  if QFormaPagoforma.AsString = 'BOC' then   ///CUPON (BONOS CLUB)
                    err := DriverFiscal1.IF_WRITE('@TicketPayment|6|'+floattostr(QFormaPagopagado.AsFloat)+'|Bonos Club')
                  else
                    if QFormaPagoforma.AsString = 'CRE' then   //OTROS 1(Venta a Creditos)
                      err := DriverFiscal1.IF_WRITE('@TicketPayment|7|'+floattostr(QFormaPagopagado.AsFloat)+'|Creditos')
                    else
                      if QFormaPagoforma.AsString = 'OBO' then  //OTROS 2 (OTRO)
                        err := DriverFiscal1.IF_WRITE('@TicketPayment|8|'+floattostr(QFormaPagopagado.AsFloat)+'|Otros')
                      else
                        if QFormaPagoforma.AsString = 'OTRO' then  //OTROS 3 (OTROS)
                          err := DriverFiscal1.IF_WRITE('@TicketPayment|9|'+floattostr(QFormaPagopagado.AsFloat))
                        else
                          if QFormaPagoforma.AsString = 'OTR4' then  //OTROS 4 (OTRO)
                            err := DriverFiscal1.IF_WRITE('@TicketPayment|10|'+floattostr(QFormaPagopagado.AsFloat))
                          else
                            if QFormaPagoforma.AsString = 'DEV' then  //NOTA DE CREDITOS
                              err := DriverFiscal1.IF_WRITE('@TicketPayment|11|'+floattostr(QFormaPagopagado.AsFloat))
                            else
                              if QFormaPagoforma.AsString = 'EFE' then
                                err := DriverFiscal1.IF_WRITE('@TicketPayment|1|'+floattostr(QFormaPagopagado.Value));

          QFormaPago.Next;
        end;
        QFormaPago.EnableControls;

        //Ajusta valores faltantes.
        vTotalImpresoraFiscal:=0;
        if err = 0 then
        begin
          vMultiUso := DriverFiscal1.IF_READ(1);
          if ((vMultiUso = '') or ( vMultiUso = '.0') or (vMultiUso = '0')) then
              vMultiUso := '0.00';

          vTotalImpresoraFiscal:= StrToFloat(vMultiUso);
          if (vTotalImpresoraFiscal > v_TotalPagado) then
            err := DriverFiscal1.IF_WRITE('@TicketPayment|7|'+floattostr(vTotalImpresoraFiscal)+'|Ajuste') ;
        end;


        if QTicketdescuento.Value > 0 then
        begin
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ ' ');
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ '    DESCUENTO APLICADO EN PRODUCTOS');
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ '----------------------------------------');
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ 'CANT DESCRIPCION               DESCUENTO');
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ '----------------------------------------');
          QDetalle.First;
          TFac := 0;
          while not QDetalle.eof do
          begin
            if QDetalledescuento.value > 0 then
            begin
              if QDetalleitbis.value > 0 then
              begin
                NumItbis := strtofloat(format('%10.2f',[(QDetalleitbis.value/100)+1]));
                Venta    := strtofloat(format('%10.4f',[(QDetalleprecio.value)/NumItbis]));

                TotalDescuento := ((Venta * QDetalledescuento.Value) / 100) * QDetallecantidad.Value;
              end
              else
              begin
                Venta := strtofloat(format('%10.2f',[QDetalleprecio.value]));
                TotalDescuento := ((Venta * QDetalledescuento.Value) / 100) * QDetallecantidad.Value;
              end;

              s := '';
              FillChar(s, 4-length(floattostr(QDetallecantidad.value)),' ');
              s1 := '';
              FillChar(s1, 8-length(trim(FORMAT('%n',[QDetalleValor.value]))), ' ');
              s2 := '';
              FillChar(s2, 28-length(copy(trim(QDetalledescripcion.value),1,28)),' ');
              s3 := '';
              FillChar(s3, 8-length(trim(FORMAT('%n',[QDetallePrecioItbis.value]))),' ');
              s4 := '';
              FillChar(s4, 8-length(trim(FORMAT('%n',[TotalDescuento]))),' ');


              err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ floattostr(QDetallecantidad.value)+s+
                            copy(trim(QDetalledescripcion.value),1,28)+s2+s4+FORMAT('%n',[TotalDescuento]));

              TFac := TFac + TotalDescuento;
            end;
            QDetalle.next;
          end;
          s := '';
          FillChar(s, 14-length(trim(format('%n',[TFac]))),' ');

          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ '----------------------------------------');
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ 'TOTAL DESCUENTO           '+s+format('%n',[TFac]));
        end;

         err := DriverFiscal1.IF_WRITE('@PaperFeed|1');
         err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Caja   : '+QTicketcaja.AsString);
         err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Cajero : '+edcajero.Caption);
         err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Ticket : '+QTicketticket.AsString);

        if (credito = 'True') then
          begin
            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|TIPO FACT : CREDITO ');

            if trim(QTicketnombre.AsString) <> '' then
              err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Nombre : '+copy(trim(QTicketnombre.AsString),1,40));

            if trim(QTicketrnc.AsString) <> '' then
              err := DriverFiscal1.IF_WRITE('@TicketFiscalText|RNC : '+copy(trim(QTicketrnc.AsString),1,40));

            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ ' ');
            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ ' ');
            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|     -------------------------');
            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|            Firma Clte.');
          end
        else
          begin
            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|TIPO FACT : CONTADO ');
             if trim(QTicketnombre.AsString) <> '' then
              err := DriverFiscal1.IF_WRITE('@TicketFiscalText|Nombre : '+copy(trim(QTicketnombre.AsString),1,40));

          end;
        err := DriverFiscal1.IF_WRITE('@PaperFeed|1');

        memo1.lines.Clear;

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select mensaje_ticket from parametros where emp_codigo = 1');
        dm.Query1.Open;

        if not dm.Query1.IsEmpty then
        begin
          err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+ ' ');
          Memo1.Lines.Clear();
          Memo1.Lines.Text := pchar( dm.Query1.FieldByName('mensaje_ticket').AsString);
          for ln := 0 to memo1.Lines.Count-1 do
            err := DriverFiscal1.IF_WRITE('@TicketFiscalText|'+copy(memo1.lines[ln],1,40));
        end;

        vImpresora_TItbis:=0;
        getPrinterInfo();
        vMultiUso := arrayMultiUso[0];
        if vMultiUso <> '' then
          begin
            vMultiUso:= copy(vMultiUso, 1,Length(vMultiUso)-2)+'.'+copy(vMultiUso, Length(vMultiUso)-1,2) ;
            if ((vMultiUso = '') or ( vMultiUso = '.0') or (vMultiUso = '0')) then
              vMultiUso := '0.00';
            vImpresora_TItbis:= StrToFloat(vMultiUso);
          end;

        err := DriverFiscal1.IF_WRITE('@PaperFeed|1');
        err := DriverFiscal1.IF_WRITE('@PaperCut|P');

         //err := DriverFiscal1.IF_WRITE('@PaperCut');
        err := DriverFiscal1.IF_WRITE('@TicketClose');
        err := DriverFiscal1.IF_WRITE('@GetLastTicketStatus');

        if (err = 0) then
         begin
          NIF:= DriverFiscal1.IF_READ(1);
          if NIF <> EmptyStr then
            begin


              QTicket.edit;

              QTicketnif.value := NIF;
              if vImpresora_TItbis > 0 then
               QTicketitbis.value := vImpresora_TItbis;
              QTicket.post;
              QTicket.UpdateBatch;
            end;
         end;
        //Application.MessageBox(PCHAR('NIF : '+MSG1),'Aviso',MB_OK);
        err := DriverFiscal1.IF_WRITE('@PaperFeed|1');
        err := DriverFiscal1.IF_WRITE('@PaperCut|P');

        if ((xCopias > 0 ) and ( Impresora.SustituirCopia = True)) then
          for x := 1 to xCopias do
           begin
             re_ImprimirTicketEpson;
            
           end;
      end;  //--[0*0]--


  err := DriverFiscal1.IF_CLOSE;
  finally
    DriverFiscal1.Destroy;
  end;
end;

function TfrmMain.getPregunta_x_Impresion(value:String): boolean;
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select puerto, Redondea, pregunta_imprimir,codigo_abre_caja from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := value;
  dm.Query1.Open;

  if (dm.Query1.FieldByName('puerto').AsString = 'COM1') then
    puertoCaja :=1
  else
    puertoCaja := 2;

  result := dm.Query1.FieldByName('pregunta_imprimir').AsString = 'S';
end;

procedure TfrmMain.ImpTicketVMAXFiscal(ImpresoraFiscal: TImpresora);
var
  pro_codigo, Unidad,Und_Medida_Real : string;
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, trecargo : Double;
  Puntos, a : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
   copias, ln: integer;
 // err, copias, ln: integer;
 tipoNcf:integer;
  DriverFiscal1 : TvmaxFiscal;
  x:byte;
  dgeneral, rgeneral : boolean;
  porcItbis:double;
  v_diferencia:Double;
  sAjuste,v_TotalPagado, sDescuento, sPrecio :double;

begin
  v_diferencia:=0;
  v_TotalPagado:=0;

  tipoNcf:=0;
  ItbisIncluido :=dm.QParametrospar_itbisincluido.Value = 'True';
   sDescuento:=0;
  Copias :=Impresora.Copia;

  //Obtener el puerto donde esta la caja registradora
  if getPregunta_x_Impresion(edCaja.Caption) then
    if MessageDlg('Desea copia de la factura ?', mtConfirmation, [mbyes, mbno], 0) = mryes then
      begin
        if Impresora.Copia > 0 then
          Copias := Impresora.Copia
        else
          Copias := 1;
      end
    else  Copias := 0;


  if not Assigned(DriverFiscal1) then
    DriverFiscal1 := TvmaxFiscal.Create();

  try
    err := DriverFiscal1.OpenPort(Impresora.Puerto, Impresora.Velocidad );
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

      case QTicketNCF_Tipo.Value of
          //consumidor final
        1:  err := DriverFiscal1.AbrirCF(copias,0, 0, '0001', QTicketcaja.AsString, QTicketNCF.AsString, '', '', '');
            //con Valor Fiscal
        2:  err := DriverFiscal1.AbrirCF(copias,1, 0, '0001', QTicketcaja.AsString, QTicketNCF.AsString, Trim(Copy(QTicketnombre.AsString,1,40)), QTicketrnc.AsString, '');
            //Gubernamental
        3:  err := DriverFiscal1.AbrirCF(copias,100, 0, '0001', QTicketcaja.AsString, QTicketNCF.AsString, Trim(Copy(QTicketnombre.AsString,1,40)), QTicketrnc.AsString, '');
            //Regimen Especial
        4:  err := DriverFiscal1.AbrirCF(copias,101, 0, '0001', QTicketcaja.AsString, QTicketNCF.AsString, Trim(Copy(QTicketnombre.AsString,1,40)), QTicketrnc.AsString, '');
      end; //fin case

      If err = SUCCESS Then
      begin //--[1]--
        sPrecio  :=0;
        trecargo :=0;
        QDetalle.DisableControls;
        QDetalle.First;

        while not QDetalle.eof do begin
          porcItbis :=0;
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select isnull(pro_montoitbis,0) as pro_montoitbis from productos where emp_codigo = 1 and pro_codigo = :pro');
          dm.Query1.Parameters.ParamByName('pro').Value := QDetalleproducto.Value;
          dm.Query1.Open;
          porcItbis := dm.Query1.FieldByName('pro_montoitbis').AsFloat;
          dm.Query1.close;

          sPrecio := QDetallePRECIO.value;
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
                                   copy(trim(QDetalledescripcion.value),1,35),
                                   QDetallecantidad.value,
                                   sPrecio,
                                   porcItbis);

        (* err := DriverFiscal1.ItemCF(0, '','','','','','','',pro_codigo,Unidad,
                copy(trim(QDetalledescripcion.value),1,35),
                        Trunc(QDetallecantidad.value * 100),
                   Trunc(sPrecio * 100),
                   Trunc( MontoItbis * 100));  *)

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

         (*******************

         if QTicketNCF_Tipo.Value < 4 then
          begin
            err := DriverFiscal1.ItemCF(0, '','','','','','','','','',
                   copy(trim(QDetalledescripcion.value),1,35),
                   Trunc(QDetallecantidad.value * 100),
                   Trunc(sPrecio * 100),
                   Trunc( MontoItbis * 100));

          end
          else if QTicketNCF_Tipo.Value = 4 then
          begin
            err := DriverFiscal1.ItemCF(0, '','','','','','','','','',
                           copy(trim(QDetalledescripcion.value),1,35),
                           Trunc(QDetallecantidad.value * 100),
                           Trunc((sPrecio + ((QDetallePrecio.value*MontoItbis)/100)) * 100),
                           Trunc( MontoItbis * 100));

          end;

          if ( sDescuento > 0 )  then
          begin
            err := DriverFiscal1.ItemCF(2, '','','','','','','','','',
                                      copy(trim(QDetalledescripcion.value),1,35),
                                      Trunc(QDetallecantidad.value * 100),
                                      Trunc(sDescuento * 100),
                                      Trunc( MontoItbis * 100));

          end;

          if ((QDetallerecargo.Value > 0) ) then
          begin
            err := DriverFiscal1.ItemCF(3, '','','','','','','','','',
                                      'CARGO POR ITEMS',
                                      Trunc(QDetallecantidad.value * 100),
                                      Trunc(QDetallerecargo.Value * 100),
                                      Trunc( MontoItbis * 100));
          end;   *)

          trecargo := trecargo + QDetallerecargo.AsFloat;

          QDetalle.next;
        end;
        QDetalle.First;
        QDetalle.EnableControls;
      end;  //--[1]--

      //--[Aplica descuento general]--
      if ((QTicketporc_desc_gral.AsFloat > 0)) then
        err := DriverFiscal1.DescRecGlobal(0,'Descuento',QTicketTdesc_gral.Value);

      //--[Aplica cargos general]--
      if ((trecargo > 0) ) then
        err := DriverFiscal1.DescRecGlobal(1,'Recargo',trecargo);

      Query1.close;
      Query1.SQL.clear;
      Query1.SQL.add('select PAR_TKMENSAJE1,PAR_TKMENSAJE2,PAR_TKMENSAJE3,');
      Query1.SQL.add('PAR_TKMENSAJE4,PAR_TKCLAVEDELETE,PAR_TKCLAVEMODIFICA');
      Query1.SQL.add('from parametros where emp_codigo = :emp');
      Query1.Parameters.ParamByName('emp').Value := empresainv;
      Query1.open;

      err := DriverFiscal1.getSubtotalCF();

      QFormaPago.DisableControls;
      QFormaPago.First;
      while not QFormaPago.Eof do
      begin
        v_TotalPagado := v_TotalPagado + QFormaPagopagado.Value;
        if QFormaPagoforma.AsString = 'TAR' then
          err := DriverFiscal1.PagoCF(0, 3, QFormaPagopagado.Value)
        else
          if QFormaPagoforma.AsString = 'CHE' then
            err := DriverFiscal1.PagoCF(0, 2, QFormaPagopagado.Value)
          else
            if QFormaPagoforma.AsString = 'DEV' then
              begin
                err := DriverFiscal1.PagoCF(0, 10, QFormaPagopagado.Value);
                // err := DriverFiscal1.IF_WRITE('@TicketPayment|11|'+floattostr(QFormaPagopagado.AsFloat));
              end
            else if QFormaPagoforma.AsString = 'CRE' then
        begin
          err := DriverFiscal1.PagoCF(0, 5,QFormaPagopagado.Value);
          //err := DriverFiscal1.IF_WRITE('@TicketPayment|7|'+floattostr(QFormaPagopagado.AsFloat));
        end
        else if QFormaPagoforma.AsString = 'BOC' then
        begin
           err := DriverFiscal1.PagoCF(0, 7,QFormaPagopagado.Value );
          //err := DriverFiscal1.IF_WRITE('@TicketPayment|6|'+floattostr(QFormaPagopagado.AsFloat));
        end
        else if QFormaPagoforma.AsString = 'OBO' then
        begin
          err := DriverFiscal1.PagoCF(0, 8, QFormaPagopagado.Value);
         // err := DriverFiscal1.IF_WRITE('@TicketPayment|8|'+floattostr(QFormaPagopagado.AsFloat));
        end
        else if QFormaPagoforma.AsString = 'EFE' then
        begin
         // err := DriverFiscal1.IF_WRITE('@TicketPayment|1|'+floattostr(QFormaPagopagado.Value));
          err := DriverFiscal1.PagoCF(0, 1,QFormaPagopagado.Value)
        end;

        QFormaPago.Next;
      end;
      QFormaPago.EnableControls;

                //Ajusta el pago
      if ( DriverFiscal1.SubTotal > v_TotalPagado ) then
        begin
          sAjuste := (DriverFiscal1.SubTotal - v_TotalPagado);
            if (sAjuste > 0)  then
              err := DriverFiscal1.PagoCF(0, 8,sAjuste,' ' );
        end;


   {   if QTicketdescuento.Value > 0 then
      begin
        err := DriverFiscal1.LineaComentario(' ');
        err := DriverFiscal1.LineaComentario('    DESCUENTO APLICADO EN PRODUCTOS');
        err := DriverFiscal1.LineaComentario('----------------------------------------');
        err := DriverFiscal1.LineaComentario('CANT DESCRIPCION               DESCUENTO');
        err := DriverFiscal1.LineaComentario('----------------------------------------');
        QDetalle.First;
        TFac := 0;
        while not QDetalle.eof do
        begin
          if QDetalledescuento.value > 0 then
          begin
            if QDetalleitbis.value > 0 then
            begin
              NumItbis := strtofloat(format('%10.2f',[(QDetalleitbis.value/100)+1]));
              Venta    := strtofloat(format('%10.4f',[(QDetalleprecio.value)/NumItbis]));

              TotalDescuento := ((Venta * QDetalledescuento.Value) / 100) * QDetallecantidad.Value;
            end
            else
            begin
              Venta := strtofloat(format('%10.2f',[QDetalleprecio.value]));
              TotalDescuento := ((Venta * QDetalledescuento.Value) / 100) * QDetallecantidad.Value;
            end;

            s := '';
            FillChar(s, 4-length(floattostr(QDetallecantidad.value)),' ');
            s1 := '';
            FillChar(s1, 8-length(trim(FORMAT('%n',[QDetalleValor.value]))), ' ');
            s2 := '';
            FillChar(s2, 28-length(copy(trim(QDetalledescripcion.value),1,28)),' ');
            s3 := '';
            FillChar(s3, 8-length(trim(FORMAT('%n',[QDetallePrecioItbis.value]))),' ');
            s4 := '';
            FillChar(s4, 8-length(trim(FORMAT('%n',[TotalDescuento]))),' ');


            err := DriverFiscal1.LineaComentario( floattostr(QDetallecantidad.value)+s+
                          copy(trim(QDetalledescripcion.value),1,28)+s2+s4+FORMAT('%n',[TotalDescuento]));

            TFac := TFac + TotalDescuento;
          end;
          QDetalle.next;
        end;
        s := '';
        FillChar(s, 14-length(trim(format('%n',[TFac]))),' ');

        err := DriverFiscal1.LineaComentario('----------------------------------------');
        err := DriverFiscal1.LineaComentario('TOTAL DESCUENTO           '+s+format('%n',[TFac]));
      end;  }

      err := DriverFiscal1.LineaComentario(' ');
      err := DriverFiscal1.LineaComentario('Cajero : '+inttostr(dm.Usuario)+' '+edcajero.Caption);
      err := DriverFiscal1.LineaComentario('Caja   : '+QTicketcaja.AsString);
      err := DriverFiscal1.LineaComentario('Ticket : '+QTicketticket.AsString);
      if (QTicketNCF_Tipo.Value = 1) and (trim(QTicketnombre.AsString) <> '') then
        err := DriverFiscal1.LineaComentario('Nombre : '+copy(trim(QTicketnombre.AsString),1,40));

      err := DriverFiscal1.LineaComentario(' ');
      memo1.lines.Clear;
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select mensaje_ticket from parametros where emp_codigo = 1');
      dm.Query1.Open;
      Memo1.Lines.Text := dm.Query1.FieldByName('mensaje_ticket').Value;

      for ln := 0 to memo1.Lines.Count-1 do
        err := DriverFiscal1.LineaComentario(copy(memo1.lines[ln],1,40));

      DriverFiscal1.CerrarCF();
    end; //--[0]--
  finally
    DriverFiscal1.ClosePort();
    DriverFiscal1.Destroy;
    Application.ProcessMessages();
  end;

end;

procedure TfrmMain.ImpTicketFiscalBixolon(ImpresoraFiscal: TImpresora);
Var arch, ptocaja : textfile;
  s, s1, s2, s3, s4 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, trecargo : Double;
  Puntos : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis, codigoabre, pregunta : String;
  pro_codigo:String;
  v_TotalImp :Double;

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
begin
//Showmessage('Estoy en Bixolon ---> 1');
  ItbisIncluido :=dm.QParametrospar_itbisincluido.Value = 'True';
  Copias := ImpresoraFiscal.Copia;
  Credito := False;

 {if not puertoFiscalOpen then   ///la velocidad es fija a 9600
    OpenFpctrl(PChar(Puerto));
  }

   if not getPrinterFiscalBixolonStatus() then
    begin
      ShowMessage('Impresora NO conectada');
      Abort;
    end;

  //Obtener el puerto donde esta la caja registradora
  if getPregunta_x_Impresion(edCaja.Caption) then
    if MessageDlg('Desea copia de la factura ?', mtConfirmation, [mbyes, mbno], 0) <> mryes then
      Copias := 0;
//Showmessage('Estoy en Bixolon ---> 2');
  if Trim(QTicketnombre.Value) <> '' Then
      SendCmd(Stat, Err, PChar('iS0'+Copy(QTicketnombre.Value, 0, 30)));
//    Showmessage('Estoy en Bixolon ---> 2.1');
    if Trim(QTicketrnc.Value) <> '' Then
      SendCmd(Stat, Err, PChar('iR0'+QTicketrnc.Value));
   //   Showmessage('Estoy en Bixolon ---> 2.2');
    //informacion del NCF
    SendCmd(Stat, Err, PChar('F'+QTicketNCF.Value));
//    Showmessage('Estoy en Bixolon ---> 2.3');
    //apertura de la factura
    case QTicketNCF_Tipo.Value of
      1:SendCmd(Stat, Err, PChar('/0'));    //Factura Para Consumidor Final
      2:SendCmd(Stat, Err, PChar('/1'));     //Factura Para Crédito Fiscal
      3:SendCmd(Stat, Err, PChar('/1'));     ////Gubernamental
      4:SendCmd(Stat, Err, PChar('/4'));    ////Regimen Especial (Factura Para Crédito Fiscal con Exoneración ITBIS)
    end;
  //   Showmessage('Estoy en Bixolon ---> 2.4');
  dgeneral := true;
  rgeneral := true;
//Showmessage('Estoy en Bixolon ---> 3');
 ///[Imprime detalle de ITEMS]
  QDetalle.DisableControls;
  QDetalle.First;
  trecargo := 0;
  //detalle de la factura
  while not QDetalle.eof do
  begin
      //  Showmessage('Estoy en Bixolon ---> 4');
          porcItbis :=0;
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select isnull(pro_montoitbis,0) as pro_montoitbis from productos where emp_codigo = 1 and pro_codigo = :pro');
          dm.Query1.Parameters.ParamByName('pro').Value := QDetalleproducto.Value;
          dm.Query1.Open;
          porcItbis := dm.Query1.FieldByName('pro_montoitbis').AsFloat;
          dm.Query1.close;

          sPrecio := QDetallePRECIO.value;
          sDescuento := QDetalleTotalDescuento.Value;
       //    Showmessage('Estoy en Bixolon ---> 5');
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
  // Showmessage('Estoy en Bixolon ---> 6');
    vord:= Trunc(porcItbis);
    case  vord of
      0:  SendCmd(Stat, Err, PChar(' '+ FormatFloat('0000000000', sPrecio * 100) + FormatFloat('00000000', QDetallecantidad.Value*100) + QDetalledescripcion.Value));
      8:  SendCmd(Stat, Err, PChar('#'+ FormatFloat('0000000000', sPrecio * 100) + FormatFloat('00000000', QDetallecantidad.Value*100) + QDetalledescripcion.Value));
     11:  SendCmd(Stat, Err, PChar('$'+ FormatFloat('0000000000', sPrecio * 100) + FormatFloat('00000000', QDetallecantidad.Value*100) + QDetalledescripcion.Value));
     13:  SendCmd(Stat, Err, PChar('%'+ FormatFloat('0000000000', sPrecio * 100) + FormatFloat('00000000', QDetallecantidad.Value*100) + QDetalledescripcion.Value));
     16:  SendCmd(Stat, Err, PChar('!'+ FormatFloat('0000000000', sPrecio * 100) + FormatFloat('00000000', QDetallecantidad.Value*100) + QDetalledescripcion.Value));
     18:  SendCmd(Stat, Err, PChar('"'+ FormatFloat('0000000000', sPrecio * 100) + FormatFloat('00000000', QDetallecantidad.Value*100) + QDetalledescripcion.Value));
    end;
  //  Showmessage('Estoy en Bixolon ---> 7');

     if ( sDescuento > 0 )  then
      SendCmd(Stat, Err, PChar('p-'+ FormatFloat('0000', QDetalledescuento.value*100)));


    if QDetallerecargo.Value > 0 then
      SendCmd(Stat, Err, PChar('p+'+ FormatFloat('0000', QDetallerecargo.Value*100)));

    trecargo := trecargo + QDetallerecargo.AsFloat;
   //  Showmessage('Estoy en Bixolon ---> 8');
    QDetalle.next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
    //   Showmessage('Estoy en Bixolon ---> 10');
  //--[Aplica descuento general]--
  if ((QTicketporc_desc_gral.AsFloat > 0)) then
    SendCmd(Stat, Err, PChar('p*'+ FormatFloat('0000', QTicketporc_desc_gral.AsFloat*100)));
 //   Showmessage('Estoy en Bixolon ---> 11');
  if trecargo > 0 then
  begin
    if rgeneral then
      SendCmd(Stat, Err, PChar('p#'+ FormatFloat('0000', QTicketdescuento.AsFloat*100)));
   //   Showmessage('Estoy en Bixolon ---> 12');
  end;

  //pide subtotal
  ///SendCmd(Stat, Err,'3');
  v_TotalImp :=0;
 //     Showmessage('Estoy en Bixolon ---> 13');
  v_TotalImp := getTotalaPagar(); //Pide total al printer
 // Showmessage('Estoy en Bixolon ---> 13.1');
  if (v_TotalImp = -1) then
    begin
      SendCmd(stat, err, '7');
      Showmessage('Un error ah ocurrido, impresion cancelada');
      exit;
    end;
 //  Showmessage('Estoy en Bixolon ---> 14');
   
  Query1.close;
  Query1.SQL.clear;
  Query1.SQL.add('select PAR_TKMENSAJE1,PAR_TKMENSAJE2,PAR_TKMENSAJE3,');
  Query1.SQL.add('PAR_TKMENSAJE4,PAR_TKCLAVEDELETE,PAR_TKCLAVEMODIFICA');
  Query1.SQL.add('from parametros where emp_codigo = :emp');
  Query1.Parameters.ParamByName('emp').Value := empresainv;
  Query1.open;
  puedeAbrirCaja :=false;
  v_TotalPagado:=0;
  QFormaPago.DisableControls;
  QFormaPago.First;
//  Showmessage('Estoy en Bixolon ---> 15');
  while not QFormaPago.Eof do
  begin
    v_TotalPagado:= v_TotalPagado + QFormaPagopagado.Value;
        {
            ‘01’ = EFECTIVO       ‘02’ = CHEQUE   ‘03’ = TJTA. DE CRED.
            ‘04’ = TJTA. DE DEB.  ‘05’ = NOTA DE  CREDITO
            ‘06’ = CUPON          ‘07’ = VENTA A CREDITO   ‘08’ = OTROS 1
            ‘09’ = OTROS 2        ‘10’ = OTROS 3
        }
    if QFormaPagoforma.AsString = 'CHE' then   //CHEQUE
      SendCmd(Stat, Err, PChar('202'+FormatFloat('000000000000', QFormaPagopagado.Value*100)))
    else
      if QFormaPagoforma.AsString = 'TAR' then   //TJTA. DE CRED.
        SendCmd(Stat, Err, PChar('203'+FormatFloat('000000000000', QFormaPagopagado.Value*100)))
      else
        if QFormaPagoforma.AsString = 'TDB' then  //TJTA. DE DEB.
          SendCmd(Stat, Err, PChar('204'+FormatFloat('000000000000', QFormaPagopagado.Value*100)))
        else
          if QFormaPagoforma.AsString = 'DEV' then     //devolucion - NOTA DE  CREDITO
            SendCmd(Stat, Err, PChar('205'+FormatFloat('000000000000', QFormaPagopagado.Value*100)))
          else
            if QFormaPagoforma.AsString = 'BOC' then   //CUPON
              SendCmd(Stat, Err, PChar('206'+FormatFloat('000000000000', QFormaPagopagado.Value*100)))
            else
             if QFormaPagoforma.AsString = 'CRE' then      //VENTA A CREDITO
               begin
                 SendCmd(Stat, Err, PChar('207'+FormatFloat('000000000000', QFormaPagopagado.Value*100)));
                 copias := copias + 1;
                 Credito := True;
               end
             else
              if QFormaPagoforma.AsString = 'OBO' then ///OTROS 1
                SendCmd(Stat, Err, PChar('208'+FormatFloat('000000000000', QFormaPagopagado.Value*100)))
              else
                if QFormaPagoforma.AsString = 'EFE' then     //EFECTIVO
                begin
                  SendCmd(Stat, Err, PChar('201'+FormatFloat('000000000000', QFormaPagopagado.Value*100)));
                  puedeAbrirCaja :=true;
                end;
    QFormaPago.Next;
  end;
 // Showmessage('Estoy en Bixolon ---> 16');
 if ((v_TotalImp > 0 ) and (v_TotalPagado <> v_TotalImp)) then
   begin
      if (v_TotalImp > v_TotalPagado) then
      begin  //Esta rutina es para poder ajustar el pago faltante
        v_TotalPagado := v_TotalImp - v_TotalPagado;
        SendCmd(Stat, Err, PChar('208'+FormatFloat('000000000000', v_TotalPagado*100)));
      end;
     ///  SendCmd(Stat, Err, PChar('101'));
   end;


  ////-----> lentitud
 // SendCmd(Stat, Err, PChar('101'));

  //if puedeAbrirCaja then
  //  SendCmd(Stat, Err, PChar(UTF8Encode('0')));

  QFormaPago.EnableControls;

  SendCmd(Stat, Err, PChar('@ '));
  if QTicketNCF_Tipo.Value = 1 then
    if trim(QTicketnombre.AsString) <> '' then
      SendCmd(Stat, Err, PChar('@Nombre : '+copy(trim(QTicketnombre.AsString),1,40)));
      //       Showmessage('Estoy en Bixolon ---> 13');
  SendCmd(Stat, Err, PChar('@Cajero : '+inttostr(dm.Usuario)+' '+edcajero.Caption));
  SendCmd(Stat, Err, PChar('@Caja   : '+QTicketcaja.AsString));
  SendCmd(Stat, Err, PChar('@Ticket : '+QTicketticket.AsString));
  SendCmd(Stat, Err, PChar('@ '));

  if Credito Then
  Begin
    SendCmd(Stat, Err, PChar('@ '));
    SendCmd(Stat, Err, PChar('@ '));
    SendCmd(Stat, Err, PChar('@ '));
    SendCmd(Stat, Err, PChar('@               _________________________'));
    SendCmd(Stat, Err, PChar('@							       Firma Cliente       '));
    SendCmd(Stat, Err, PChar('@ '));
  End;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select mensaje_ticket from parametros where emp_codigo = 1');
  dm.Query1.Open;

  if not dm.Query1.IsEmpty then
  begin
    Memo1.Lines.Clear();
    SendCmd(Stat, Err, PChar('@ '));
    Memo1.Lines.Text := pchar( dm.Query1.FieldByName('mensaje_ticket').AsString);
    for ln := 0 to memo1.Lines.Count-1 do
      SendCmd(Stat, Err, PChar('@'+copy(memo1.lines[ln],1,40)));
  end;



  SendCmd(Stat, Err, PChar('199'));

  For X := 1 To Copias Do
    SendCmd(Stat, Err, PChar('RU'));

  GuardarNIF(UltimoNIF);

 /// CloseFpctrl;
end;



function TfrmMain.getPrinterFiscalBixolonStatus: boolean;
begin
  if not Impresora.isConected then   ///la velocidad es fija a 9600
    OpenFpctrl(PChar(PuertoSerial[Impresora.Puerto -1]));

  Impresora.isConected := CheckFprinter();
  Respuesta := Impresora.isConected;

  if Not Impresora.isConected then
  begin
    lblStatusPrinter.Caption := 'OFF';
    lblStatusPrinter.Font.Color := clRed;
  end
  else
    begin
      lblStatusPrinter.Caption := 'ON'  ;
      lblStatusPrinter.Font.Color := clGreen;
    end;

  result := Impresora.isConected;

end;

procedure TfrmMain.tmVerificaPuertoTimer(Sender: TObject);
begin

  if Impresora.IDPrinter = 5 then
    if ((dsDetalle.DataSet.Active = true) and
        (dsDetalle.DataSet.RecordCount = 0)) then
    begin
      tmVerificaPuerto.Enabled := false;
      Impresora.isConected := getPrinterFiscalBixolonStatus();
      tmVerificaPuerto.Enabled := true;
    end;
end;


procedure TfrmMain.ImpTicketFiscalCardNet(aCopia: byte);
var
  arch, ptocaja, puertopeq : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos, a, ln, pg, cantpg : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis : String;
  err, x: integer;
  parametro, codigoabre, StatusFiscal : string;
  DriverFiscal1 : TDriverFiscal;
  b : myJSONItem;
begin

with qImpCardNet do begin
Close;
Parameters.ParamByName('emp').Value :=  QTicketemp_codigo.Value;
Parameters.ParamByName('tic').Value :=  QTicketticket.Value;
Parameters.ParamByName('fec').Value :=  QTicketfecha.Value;
Parameters.ParamByName('caj').Value :=  QTicketcaja.Value;
Parameters.ParamByName('usu').Value :=  QTicketusu_codigo.Value;
Open;
end;
  if ((aCopia > 0 ) and ( Impresora.SustituirCopia = true)) then
    copias := 0
  else
    copias := aCopia;

///  copias := aCopia;
 //// if ckcopia.Checked then copias := 1;


  if FileExists('.\puerto.ini') then
  begin
    assignfile(puertopeq, '.\puerto.ini');
    reset(puertopeq);
    readln(puertopeq, puerto);
  end
  else
    puerto := 'COM1';


  codigoabre := Trim(DM.QParametrosPAR_CODIGO_ABRE_CAJA.Value);

  b := myJSONItem.Create;
  b.Code :=  qImpCardNet.fieldByName('JSON').Value;

  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';

  try
    err := DriverFiscal1.IF_OPEN(puerto, 9600);

    if (err < 0 ) then
      begin
        ShowMessage('Error : No hay comunicacion con el printer'+#13+#10+
        'Impresion cancelada');
        exit;
      end;

  //Obtiene los datos de fiscalización
    err := DriverFiscal1.IF_WRITE('@GetInitData');
    //Obtiene las características fiscales
    err := DriverFiscal1.IF_WRITE('@GetFiscalFeatures');
    //Obtiene los datos de serialización
    err := DriverFiscal1.IF_WRITE('@GetPrinterVersion');

   //Retorna los valores de respuesta del último comprobante cerrado
    err := DriverFiscal1.IF_WRITE('@GetLastTicketStatus');
    //arrayMultiUso[17]

    err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');
    if (err <> 0) then
      begin
        err := DriverFiscal1.IF_ERROR1(0);  //verifica Mecanismo
        err := DriverFiscal1.IF_ERROR2(0);  //Verifica Controlador Fiscal

        StatusFiscal:=IntToBinRec(err,16);    //207
        if StatusFiscal[5] = '1' then
          Application.MessageBox('Se requiere un Cierre Z','Error',MB_OK+MB_ICONERROR);
      end
    else
      begin

  parametro := qImpCardNet.fieldbyname('SUCURSAL').Text;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(parametro));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(parametro));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+b['DataTime'].getStr);
  parametro := IntToStr(b['Transaction']['Reference'].getInt);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No. Trans.      : '+parametro);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('REGISTRO DE LA TRANSACCION'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No. de Terminal : '+b['TerminalID'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'ID Comerciante  : '+b['MerchantID'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TARJETA         : ' +b['Card']['Product'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TIPO COMPRA     : '+b['Transaction']['LoyaltyDeferredNumber'].getStr);
  parametro  := copy(b['Card']['CardNumber'].getStr,Length(b['Card']['CardNumber'].getStr)-3,Length(b['Card']['CardNumber'].getStr));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No. tarjeta     : '+parametro);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Modo Entrada    : '+b['Host']['Description'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'APROBADA        : EN LINEA');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Cliente         : '+copy(b['Card']['HolderName'].getStr,1,24));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Monto RD$       : '+qImpCardNet.FieldByName('montosinitbis').text);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Tax   RD$       : '+qImpCardNet.FieldByName('monto_itbis').text);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Total RD$       : '+qImpCardNet.FieldByName('monto').text);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+DM.CENTRO('APROBADA'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No de referencia: '+b['Transaction']['RetrievalReference'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No Autorizacion : '+b['Transaction']['AuthorizationNumber'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Fecha            : '+copy(b['Transaction']['DataTime'].getStr,1,10));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Hora             : '+trim(copy(b['Transaction']['DataTime'].getStr,12,20)));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.Centro('_________________________'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(copy(b['Card']['HolderName'].getStr,1,24)));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('***Original Comercio***'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('***FIN DOCUMENTO NO VENTA***'));
  for x:= 1 to 12 do begin
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  end;

  if codigoabre = 'Termica' then
  err := DriverFiscal1.IF_WRITE('@PaperCut|P');

  err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|C');
  err := DriverFiscal1.IF_CLOSE;


  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';

  
    err := DriverFiscal1.IF_OPEN(puerto, 9600);

    if (err < 0 ) then
      begin
        ShowMessage('Error : No hay comunicacion con el printer'+#13+#10+
        'Impresion cancelada');
        exit;
      end;

  //Obtiene los datos de fiscalización
    err := DriverFiscal1.IF_WRITE('@GetInitData');
    //Obtiene las características fiscales
    err := DriverFiscal1.IF_WRITE('@GetFiscalFeatures');
    //Obtiene los datos de serialización
    err := DriverFiscal1.IF_WRITE('@GetPrinterVersion');

   //Retorna los valores de respuesta del último comprobante cerrado
    err := DriverFiscal1.IF_WRITE('@GetLastTicketStatus');
    //arrayMultiUso[17]

    err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');
    if (err <> 0) then
      begin
        err := DriverFiscal1.IF_ERROR1(0);  //verifica Mecanismo
        err := DriverFiscal1.IF_ERROR2(0);  //Verifica Controlador Fiscal

        StatusFiscal:=IntToBinRec(err,16);    //207
        if StatusFiscal[5] = '1' then
          Application.MessageBox('Se requiere un Cierre Z','Error',MB_OK+MB_ICONERROR);
      end
    else
    begin
  //Copia Ccliente

  parametro := qImpCardNet.fieldbyname('SUCURSAL').Text;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(parametro));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(parametro));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+b['DataTime'].getStr);
  parametro := IntToStr(b['Transaction']['Reference'].getInt);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No. Trans.      : '+parametro);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('REGISTRO DE LA TRANSACCION'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No. de Terminal : '+b['TerminalID'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'ID Comerciante  : '+b['MerchantID'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TARJETA         : ' +b['Card']['Product'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TIPO COMPRA     : '+b['Transaction']['LoyaltyDeferredNumber'].getStr);
  parametro  := copy(b['Card']['CardNumber'].getStr,Length(b['Card']['CardNumber'].getStr)-3,Length(b['Card']['CardNumber'].getStr));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No. tarjeta     : '+parametro);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Modo Entrada    : '+b['Host']['Description'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'APROBADA        : EN LINEA');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Cliente         : '+copy(b['Card']['HolderName'].getStr,1,24));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Monto RD$       : '+qImpCardNet.FieldByName('montosinitbis').text);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Tax   RD$       : '+qImpCardNet.FieldByName('monto_itbis').text);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Total RD$       : '+qImpCardNet.FieldByName('monto').text);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+DM.CENTRO('APROBADA'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No de referencia: '+b['Transaction']['RetrievalReference'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'No Autorizacion : '+b['Transaction']['AuthorizationNumber'].getStr);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Fecha            : '+copy(b['Transaction']['DataTime'].getStr,1,10));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Hora             : '+trim(copy(b['Transaction']['DataTime'].getStr,12,20)));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.Centro('***COPIA CLIENTE***'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('***FIN DOCUMENTO NO VENTA***'));
  for x:= 1 to 12 do begin
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  end;

  if codigoabre = 'Termica' then
  err := DriverFiscal1.IF_WRITE('@PaperCut|P');

  err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|C');
  err := DriverFiscal1.IF_CLOSE;
end;

end;
  finally
    DriverFiscal1.Destroy;
  end;
end;


procedure TfrmMain.ImpTicketVmaxFiscalCardNet(aPuerto, aVelocidad: Integer;
  aCopia: byte; aTipo, aPrinter_usa_Precioconitbis: string);
var
  arch, puertopeq : textfile;
  s, s1, s2, s3, s4, s5 : array [0..20] of char;
  Tfac, Saldo : double;
  lbitbis, impcodigo, pro_codigo, Unidad,Und_Medida_Real : string;
  a : integer;
  sPrecio, sDescuento, sDecuentoItbis:Double;
  DescRecGlobal :Double;
  err, copias, x: integer;
  DriverFiscal1 : TvmaxFiscal;
  TipoNCF:byte;
  NombreCajero,TipoFactura,NombreVendedor :string;
  ItbisIncluido:boolean;
  sAjuste:Double;
  sMontoPagado : Double;
  sPorcDescGral:Double;
  sTmp,sStringTmp:String;
  parametro, sNombreCliente,srncCliente:String;
  b : myJSONItem;
begin
with qImpCardNet do begin
Close;
Parameters.ParamByName('emp').Value :=  QTicketemp_codigo.Value;
Parameters.ParamByName('tic').Value :=  QTicketticket.Value;
Parameters.ParamByName('fec').Value :=  QTicketfecha.Value;
Parameters.ParamByName('caj').Value :=  QTicketcaja.Value;
Parameters.ParamByName('usu').Value :=  QTicketusu_codigo.Value;
Open;
end;
 copias := 0;

 if not Assigned(DriverFiscal1) then
  DriverFiscal1 := TvmaxFiscal.Create();

  try
    pnMsgImpresion.visible :=true;
    lblWait.Caption:='Buscando puerto, espere...';
    Application.ProcessMessages();
    err := DriverFiscal1.OpenPort(aPuerto, aVelocidad);
    if (err <> SUCCESS ) then
      begin
        ShowMessage('Error : No hay comunicacion con el printer'+#13+#10+
        'Impresion cancelada');
        exit;
      end
    else begin //--[0]--
      lblWait.Caption:='Procesando Impresion, Espere...';
      Application.ProcessMessages();

  If err = SUCCESS then begin //--[1]--
  b := myJSONItem.Create;
  b.Code :=  qImpCardNet.fieldByName('JSON').Value;
  err := DriverFiscal1.AbrirNoFiscal(copias,0, 0, '0001', IntToStr(QTicketticket.Value), QTicketnombre.Text, QTicketrnc.Text);

  //Ticket Comercio
  parametro := qImpCardNet.fieldbyname('SUCURSAL').Text;
  err :=  DriverFiscal1.LineaComentario( dm.centro(parametro));
  err :=  DriverFiscal1.LineaComentario( dm.centro(qImpCardNet.FieldByName('DIRECCION').text));
  err :=  DriverFiscal1.LineaComentario( b['DataTime'].getStr);
  parametro := IntToStr(b['Transaction']['Reference'].getInt);
  err :=  DriverFiscal1.LineaComentario( 'No. Trans.      : '+parametro);
  err :=  DriverFiscal1.LineaComentario( '');
  err :=  DriverFiscal1.LineaComentario( dm.centro('REGISTRO DE LA TRANSACCION'));
  err :=  DriverFiscal1.LineaComentario( 'No. de Terminal : '+b['TerminalID'].getStr);
  err :=  DriverFiscal1.LineaComentario( 'ID Comerciante  : '+b['MerchantID'].getStr);
  err :=  DriverFiscal1.LineaComentario( '');
  err :=  DriverFiscal1.LineaComentario( 'TARJETA         : ' +b['Card']['Product'].getStr);
  err :=  DriverFiscal1.LineaComentario( 'TIPO COMPRA     : '+b['Transaction']['LoyaltyDeferredNumber'].getStr);
  parametro  := copy(b['Card']['CardNumber'].getStr,Length(b['Card']['CardNumber'].getStr)-3,Length(b['Card']['CardNumber'].getStr));
  err :=  DriverFiscal1.LineaComentario( 'No. tarjeta     : '+parametro);
  err :=  DriverFiscal1.LineaComentario( 'Modo Entrada    : '+b['Host']['Description'].getStr);
  err :=  DriverFiscal1.LineaComentario( 'APROBADA        : EN LINEA');
  err :=  DriverFiscal1.LineaComentario( 'Cliente         : '+copy(b['Card']['HolderName'].getStr,1,24));
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( 'Monto RD$       : '+qImpCardNet.FieldByName('montosinitbis').text);
  err :=  DriverFiscal1.LineaComentario( 'Tax   RD$       : '+qImpCardNet.FieldByName('monto_itbis').text);
  err :=  DriverFiscal1.LineaComentario( 'Total RD$       : '+qImpCardNet.FieldByName('monto').text);
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( DM.CENTRO('APROBADA'));
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( 'No de referencia: '+b['Transaction']['RetrievalReference'].getStr);
  err :=  DriverFiscal1.LineaComentario( 'No Autorizacion : '+b['Transaction']['AuthorizationNumber'].getStr);
  err :=  DriverFiscal1.LineaComentario( 'Fecha            : '+copy(b['Transaction']['DataTime'].getStr,1,10));
  err :=  DriverFiscal1.LineaComentario( 'Hora             : '+trim(copy(b['Transaction']['DataTime'].getStr,12,20)));
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( dm.Centro('_________________________'));
  err :=  DriverFiscal1.LineaComentario( dm.centro(copy(b['Card']['HolderName'].getStr,1,24)));
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( dm.centro('***Original Comercio***'));
  err :=  DriverFiscal1.LineaComentario( ' ');
  err :=  DriverFiscal1.LineaComentario( dm.centro('***FIN DOCUMENTO NO VENTA***'));
  for x:= 1 to 12 do begin
  err :=  DriverFiscal1.LineaComentario( ' ');
  end;

  lblWait.Caption:='Imprimiendo ticket CardNet, espere...';
  Application.ProcessMessages();
  DriverFiscal1.CerrarNoFiscal();
 end;
 end;
 finally
    lblWait.Caption:='Cerrando puerto';
    Application.ProcessMessages();
    DriverFiscal1.ClosePort();
    DriverFiscal1.Destroy;

    Timer1.Enabled :=false;
    lblWait.Caption:='';
    pnMsgImpresion.visible :=false;
    Application.ProcessMessages();
  end;




end;


procedure TfrmMain.OpenCashDrawerFiscal(vPrinterFiscal: TImpresora);
var
  puerto:String;
  err: integer;

  procedure Epson();
  var
    DriverFiscal1 : TDriverFiscal;
  begin
    DriverFiscal1 := TDriverFiscal.Create(Self);
    DriverFiscal1.SerialNumber := '27-0163848-435';
    try
      err := DriverFiscal1.IF_OPEN(puerto, vPrinterFiscal.Velocidad);
      err := DriverFiscal1.IF_WRITE('@OpenDrawer|'+IntToStr(puertoCaja));
      err := DriverFiscal1.IF_CLOSE;
    finally
      DriverFiscal1.Destroy;
    end;
  end;

  procedure Tecnologia_Tfhkaif();
   //cubre las BIXOLON/HKA80
   Var
     Stat: Integer;
     Respuesta: Boolean;
  begin
    OpenFpctrl(PChar(Puerto));
    try
      Respuesta := CheckFprinter();
      if Not Respuesta then
        begin
          ShowMessage('Impresora NO conectada, no es posible abrir Gaveta');
          Abort;
        end;
      SendCmd(Stat, Err, PChar(UTF8Encode('0')));

      puertoFiscalOpen :=Respuesta;
    finally
      CloseFpctrl;
    end;
  end;

begin

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select puerto, Redondea, pregunta_imprimir from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := edCaja.Caption;
  dm.Query1.Open;

  if (dm.Query1.FieldByName('puerto').AsString = 'COM1') then
    puertoCaja :=1
  else
    puertoCaja := 2;
  Puerto := PuertoSerial[Impresora.Puerto -1];
  //Puerto := PuertoSerial[Impresora.Puerto];
  puertoFiscalOpen :=false;
  case vPrinterFiscal.IDPrinter of
    1 : {EPSON (TMU-220)} Epson();
    // 2 : {CITIZEN ( CT-S310 )}  ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    // 3 : {CITIZEN (GSX-190)}    ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    //4 : {STAR (TSP650FP)}      ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    5 : {Bixolon SRP-350iiHG}  Tecnologia_Tfhkaif();
  end;
end;

procedure TfrmMain.qDetalleNewRecord(DataSet: TDataSet);
begin
qDetalleemp_codigo.Value := empcaja;
qDetallesuc_codigo.Value := vp_suc;
end;

procedure TfrmMain.QFormaPagoNewRecord(DataSet: TDataSet);
begin
QFormaPagoemp_codigo.Value := empcaja;
QFormaPagosuc_codigo.Value := vp_suc;
end;

end.


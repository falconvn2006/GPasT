unit BAR04;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, IBDatabase, IBCustomDataSet, IBQuery, DBXpress,
  SqlExpr, Provider, DBClient, DBLocal, IBUpdateSQL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, ADODB, ImgList,
  DIMime, magwmi, magsubs1, WinSvc,vmaxFiscal,WinSock,iFiscal, uLkJSON,
  OCXFISLib_TLB;

type
  TDM = class(TDataModule)
    ADOBar: TADOConnection;
    Query1: TADOQuery;
    QEmpresa: TADOQuery;
    dsEmpresa: TDataSource;
    adoMultiUso: TADOQuery;
    QEmpresaEmpresaID: TAutoIncField;
    QEmpresaNombre: TWideStringField;
    QEmpresaRNC: TWideStringField;
    QEmpresaDireccion: TWideStringField;
    QEmpresaTelefono: TWideStringField;
    QEmpresaFax: TWideStringField;
    QEmpresaWebsite: TWideStringField;
    QEmpresaCorreo: TWideStringField;
    QEmpresaMensaje1: TWideStringField;
    QEmpresaMensaje2: TWideStringField;
    QEmpresaMensaje3: TWideStringField;
    QEmpresaMensaje4: TWideStringField;
    QEmpresaItbis: TBCDField;
    QEmpresaPropina: TBCDField;
    QEmpresaTasaUS: TBCDField;
    QEmpresaTasaEU: TBCDField;
    QEmpresaFecha: TDateTimeField;
    QEmpresaMensaje5: TWideStringField;
    QEmpresaMensaje6: TWideStringField;
    QEmpresaMensaje7: TWideStringField;
    QEmpresaMensaje8: TWideStringField;
    QEmpresaMensaje9: TWideStringField;
    QEmpresaMensaje10: TWideStringField;
    QEmpresaMensaje11: TWideStringField;
    QEmpresaMensaje12: TWideStringField;
    QEmpresaMensaje13: TWideStringField;
    QEmpresaMensaje14: TWideStringField;
    QEmpresaMensaje15: TWideStringField;
    QEmpresaMensaje16: TWideStringField;
    QEmpresaMensaje17: TWideStringField;
    QEmpresaMensaje18: TWideStringField;
    QEmpresaMensaje19: TWideStringField;
    QEmpresaMensaje20: TWideStringField;
    QEmpresaMensaje21: TWideStringField;
    QEmpresaMensaje22: TWideStringField;
    QEmpresaMensaje23: TWideStringField;
    QEmpresaMensaje24: TWideStringField;
    QEmpresaMensaje25: TWideStringField;
    QEmpresaMensaje26: TWideStringField;
    QEmpresaMensaje27: TWideStringField;
    QEmpresaMensaje28: TWideStringField;
    QEmpresaMensaje29: TWideStringField;
    QEmpresaMensaje30: TWideStringField;
    QEmpresaMensaje31: TWideStringField;
    QEmpresaMensaje32: TWideStringField;
    QEmpresaMensaje33: TWideStringField;
    QEmpresaMensaje34: TWideStringField;
    QEmpresaMensaje35: TWideStringField;
    QEmpresaMensaje36: TWideStringField;
    QEmpresaMensaje37: TWideStringField;
    QEmpresaMensaje38: TWideStringField;
    QEmpresaMensaje39: TWideStringField;
    QEmpresaMensaje40: TWideStringField;
    QEmpresaCortapapel: TWideStringField;
    QParametros: TADOQuery;
    QParametrosEMP_CODIGO: TIntegerField;
    QParametrosPAR_ALMACENVENTA: TIntegerField;
    QParametrosPAR_CODIGOCLIENTE: TStringField;
    QParametrosPAR_CODIGOPRODUCTO: TStringField;
    QParametrosPAR_FACFORMA: TStringField;
    QParametrosPAR_FORMATODES: TIntegerField;
    QParametrosPAR_FORMATODEV: TIntegerField;
    QParametrosPAR_FORMATONC: TIntegerField;
    QParametrosPAR_FORMATOND: TIntegerField;
    QParametrosPAR_FORMATORC: TIntegerField;
    QParametrosPAR_FORMATORI: TIntegerField;
    QParametrosPAR_ITBIS: TBCDField;
    QParametrosPAR_MOVNDE: TIntegerField;
    QParametrosPAR_TFACODIGO: TIntegerField;
    QParametrosPAR_TIPOPRECIO: TStringField;
    QParametrosPAR_CONTROLAMAXIMO: TStringField;
    QParametrosPAR_CONTROLAMINIMO: TStringField;
    QParametrosPAR_DEBAJOCOSTO: TStringField;
    QParametrosPAR_COMBOCOTIZACION: TStringField;
    QParametrosPAR_COMBOIMPDETALLE: TStringField;
    QParametrosPAR_COMBOREBAJA: TStringField;
    QParametrosPAR_VENDIGITOSLOTE: TIntegerField;
    QParametrosPAR_VENPERMITIR: TStringField;
    QParametrosPAR_VENVERIFICA: TStringField;
    QParametrosPAR_CONTEOLIMPIA: TStringField;
    QParametrosPAR_PREDESCGLOBAL: TStringField;
    QParametrosPAR_PREDESCRIP1: TStringField;
    QParametrosPAR_PREDESCRIP2: TStringField;
    QParametrosPAR_PREDESCRIP3: TStringField;
    QParametrosPAR_PREDESCRIP4: TStringField;
    QParametrosPAR_FACANULA: TStringField;
    QParametrosPAR_FACDIASANULA: TIntegerField;
    QParametrosPAR_FACDIASMODIFICA: TIntegerField;
    QParametrosPAR_FACDISPONIBLE: TStringField;
    QParametrosPAR_FACMODIFICA: TStringField;
    QParametrosPAR_FACSELPRECIO: TStringField;
    QParametrosPAR_FACTEMPORAL: TStringField;
    QParametrosPAR_DEVDIAS: TIntegerField;
    QParametrosPAR_DEVEFECTIVO: TStringField;
    QParametrosPAR_FORMATOCUADRE: TIntegerField;
    QParametrosPAR_AHORA1: TDateTimeField;
    QParametrosPAR_AHORA2: TDateTimeField;
    QParametrosPAR_BHORA1: TDateTimeField;
    QParametrosPAR_BHORA2: TDateTimeField;
    QParametrosPAR_FACMODPRECIO: TStringField;
    QParametrosPAR_FORMATOCON: TIntegerField;
    QParametrosPAR_CAJA: TStringField;
    QParametrosPAR_IMPCODIGOBARRA: TStringField;
    QParametrosCPA_CODIGOCLIENTE: TIntegerField;
    QParametrosPAR_LIMITEINICIAL: TBCDField;
    QParametrosPAR_MOVCK: TIntegerField;
    QParametrosPAR_MOVCARGO: TIntegerField;
    QParametrosPAR_PRECIOLETRA_0: TStringField;
    QParametrosPAR_PRECIOLETRA_1: TStringField;
    QParametrosPAR_PRECIOLETRA_2: TStringField;
    QParametrosPAR_PRECIOLETRA_3: TStringField;
    QParametrosPAR_PRECIOLETRA_4: TStringField;
    QParametrosPAR_PRECIOLETRA_5: TStringField;
    QParametrosPAR_PRECIOLETRA_6: TStringField;
    QParametrosPAR_PRECIOLETRA_7: TStringField;
    QParametrosPAR_PRECIOLETRA_8: TStringField;
    QParametrosPAR_PRECIOLETRA_9: TStringField;
    QParametrosPAR_NUEVOUSADO: TStringField;
    QParametrosPAR_TEXTOBARRA1: TStringField;
    QParametrosPAR_TEXTOBARRA2: TStringField;
    QParametrosPAR_TEXTOBARRA3: TStringField;
    QParametrosPAR_TEXTOBARRA4: TStringField;
    QParametrosPAR_TEXTOBARRA5: TStringField;
    QParametrosPAR_OPC5TALINEA: TStringField;
    QParametrosPAR_TEXTOBARRA6: TStringField;
    QParametrosPAR_OPC1RALINEA: TStringField;
    QParametrosPAR_PREGUNTAPEQ: TStringField;
    QParametrosPAR_IGUALAREF: TStringField;
    QParametrosPAR_ITBISDEFECTO: TStringField;
    QParametrosPAR_FPADESEM: TIntegerField;
    QParametrosPAR_FACBAJARLINEA: TStringField;
    QParametrosPAR_FACTOTALIZAPIE: TStringField;
    QParametrosPAR_FACREPITEPROD: TStringField;
    QParametrosPAR_DEBAJOPRECIO: TStringField;
    QParametrosPAR_FACCONITBIS: TStringField;
    QParametrosPAR_FACESCALA: TStringField;
    QParametrosPAR_FACMEDIDA: TStringField;
    QParametrosPAR_PRECIOEMP: TStringField;
    QParametrosPAR_PRECIOUND: TStringField;
    QParametrosPAR_FISICOSOLOLLENO: TStringField;
    QParametrosPAR_DEVFORMA: TStringField;
    QParametrosPAR_FORMATOCOT: TIntegerField;
    QParametrosPAR_INVMOSTRARVENCE: TStringField;
    QParametrosPAR_VERIMAGEN: TStringField;
    QParametrosPAR_TKMENSAJE1: TStringField;
    QParametrosPAR_TKMENSAJE2: TStringField;
    QParametrosPAR_TKMENSAJE3: TStringField;
    QParametrosPAR_TKMENSAJE4: TStringField;
    QParametrosPAR_TKCLAVEDELETE: TStringField;
    QParametrosPAR_TKCLAVEMODIFICA: TStringField;
    QParametrosPAR_COMBINAORIGINAL: TStringField;
    QParametrosPAR_COMBINAFABRIC: TStringField;
    QParametrosPAR_TKCLAVECREDITO: TStringField;
    QParametrosPAR_TKCLAVECANCELA: TStringField;
    QParametrosPAR_INVEMPRESA: TIntegerField;
    QParametrosPAR_INVALMACEN: TIntegerField;
    QParametrosMON_CODIGO: TIntegerField;
    QParametrosPAR_SOLGENERACHEQUE: TStringField;
    QParametrospar_invprecioconduce: TStringField;
    QParametrospar_mailservidor: TStringField;
    QParametrospar_mailcorreo: TStringField;
    QParametrospar_mailusuario: TStringField;
    QParametrospar_mailclave: TStringField;
    QParametrospar_mailpuerto: TStringField;
    QParametrospar_itbisincluido: TStringField;
    QParametroscaj_codigo: TIntegerField;
    QParametrospar_domicilio: TStringField;
    QParametrospar_monto_domicilio: TBCDField;
    QParametrospar_copias_domicilio: TIntegerField;
    QParametrospar_beneficio: TBCDField;
    QParametrospar_tkclavereimprime: TStringField;
    QParametrospar_igualartelefonocliente: TStringField;
    QParametrospar_valor_punto: TBCDField;
    QParametrospar_punto_principal: TBCDField;
    QParametrospar_punto_depen: TBCDField;
    QParametrospar_redondeo: TStringField;
    QParametrospar_barra_header: TMemoField;
    QParametrospar_fac_preimpresa: TStringField;
    QParametrospar_preciound_m: TStringField;
    QParametrospar_precioemp_m: TStringField;
    QParametrospar_fac_oferta: TStringField;
    QParametrospar_nombre_familia: TStringField;
    QParametrospar_nombre_depto: TStringField;
    QParametrospar_nombre_color: TStringField;
    QParametrospar_nombre_marca: TStringField;
    QParametrospar_inv_compra_centro_costo: TStringField;
    QParametrospar_imprime_logo: TStringField;
    QParametrospar_arch_copiar_colector: TStringField;
    QParametrospar_arch_recibe_colector: TStringField;
    QParametrospar_delimitador_envia: TStringField;
    QParametrospar_delimitador_recibe: TStringField;
    QParametrospar_modifica_fecha_factura: TStringField;
    QParametrospar_pago_mayor_balance: TStringField;
    QParametrospar_nota_orden_servicio: TMemoField;
    QParametrospar_controlar: TStringField;
    QParametrospar_formato_preimpreso: TStringField;
    QParametrospar_usuario_cuadra: TStringField;
    QParametrospar_inv_entrada_modifica_precio: TStringField;
    QParametrospar_movtk: TStringField;
    QParametrospar_visualizadesc: TStringField;
    QParametrospar_visualiza_selectivo: TStringField;
    QParametrospar_cantidad_primero: TStringField;
    QParametrospar_busqueda_porciento: TStringField;
    QParametrospar_busqueda_cxp: TStringField;
    QParametrospar_moneda_local: TIntegerField;
    QParametrospar_envio: TMemoField;
    QParametrospar_nota_cotizacion: TMemoField;
    QParametrospar_almacendevolucion: TIntegerField;
    QParametrospar_boletos_monto: TBCDField;
    QParametrospar_boletos_cantidad: TIntegerField;
    QParametrospar_ticket_itbis: TStringField;
    QParametrospar_ftp_site: TStringField;
    QParametrospar_ftp_usuario: TStringField;
    QParametrospar_ftp_password: TStringField;
    QParametrospar_ftp_ruta: TStringField;
    QParametrospar_empresa_1: TIntegerField;
    QParametrospar_empresa_2: TIntegerField;
    QParametrospar_porciento_empresa_1: TBCDField;
    QParametrospar_porciento_empresa_2: TBCDField;
    QParametrospar_empresa_porciento_comprobante: TIntegerField;
    QParametrospar_dividir_facturacion: TStringField;
    QParametrospar_modifica_precio_automatico: TStringField;
    QParametrospar_inv_forma_inventario: TStringField;
    QParametrospar_visualizar_cant_empaque: TStringField;
    QParametrospar_imprimir_calculo_empaque: TStringField;
    QParametrospar_inv_transferencia_auto: TStringField;
    QParametrospar_boletos_monto_patrocinador: TBCDField;
    QParametrospar_boletos_cantidad_patrocinador: TIntegerField;
    QParametrospar_busqueda_dejar_ultimo: TStringField;
    QParametrospar_compras_visualiza_diferencia: TStringField;
    QParametrospar_genera_puntos_credito: TStringField;
    QParametrospar_inv_unidad_medida: TStringField;
    QParametrospar_numerofactura_tipo: TStringField;
    QParametrospar_facturarcero: TStringField;
    QParametrospar_textobarra7: TStringField;
    QParametrospar_opc6talinea: TStringField;
    QParametrospar_opc7malinea: TStringField;
    QParametrosIdioma: TStringField;
    QParametrospar_compras_valores_aut: TStringField;
    QParametrospar_aplica_desc_por_rango_venta: TStringField;
    QParametrospar_inv_imprime_comentario: TStringField;
    QParametrospar_periodo_caducidad: TStringField;
    QParametrospar_cantidad_caducidad: TIntegerField;
    QParametrospar_imprimir_sin_detalle_RI: TStringField;
    QParametroscot_dias_valides: TIntegerField;
    QParametrospar_validar_serie_en_inventario: TStringField;
    QParametrospar_impresora_boleto: TStringField;
    QParametrosPAR_SUC_NCF: TIntegerField;
    QParametrospar_busq_incrementada: TBooleanField;
    QParametrospar_busq_por_referencia: TBooleanField;
    QParametrospar_envio_maxivo_fact: TBooleanField;
    QParametrosPAR_MORA_DIAS_GRACIA: TIntegerField;
    QParametrosPAR_MORA_PORC: TCurrencyField;
    QParametrosPAR_MORA_DIAS_APLICAR: TIntegerField;
    QParametrosPAR_CODIGO_ABRE_CAJA: TStringField;
    QParametrospar_imprimir_con_detalle_prod: TBooleanField;
    QParametrospar_cotizacion_notif: TBooleanField;
    QParametrosPar_Envio_Rec_Estadocta: TBooleanField;
    QParametrosPar_Envio_Rec_Correo: TBooleanField;
    QParametrosPar_Envio_Conduce_Correo: TBooleanField;
    QParametrosPar_Envio_Cotiz_Correo: TBooleanField;
    QParametrospar_treporte_peso: TIntegerField;
    QParametrosPAR_IMPCODBARRAFAM: TBooleanField;
    QParametrospar_banca_apuestas: TBooleanField;
    QEmpresaPrecioIncluyeItbis: TStringField;
    QParametrosRestBar_FactConItbis: TBooleanField;
    procedure ADOBarAfterConnect(Sender: TObject);
    procedure ADOBarBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure QEmpresaAfterOpen(DataSet: TDataSet);
  public
    { Public declarations }
    function Confirme(const msg: String): boolean;
    function PAD(Mchar, Alineacion: char; tamano: Integer;
      Numero: String): string;
    function SetCentralizar(Const aValue:String;aSize : Smallint = 40):String;
    function  Centro (Texto : String) : String;
    function LPad(pCadena: string; pLong: word; pRelleno: string = ' '): string;
    function RPad(pCadena: string; pLong: word; pRelleno: string = ' '): string;
    function GetPcName: string;
    function getParametrosPrinterFiscal: boolean;
    function getSecuencia(Tabla, Campo: string): Integer;
  end;

var
  DM: TDM;
  ImpresoraFiscal :TImpresora;

  TerminaEjecucion:boolean = true;
  sFormaPagoEfectivo:boolean = false;
  Stat, Err: Integer;
  PCNombre,IP :String;
Const
  ConnectionStringPlus =  ';User ID=randy;password=dayelcris';
CRLF = #$D#$A;
  MSG_COMANDA_REIMPRESION='Todos los productos de la comanda ya fueron impreso'+CRLF+CRLF+
                          'Seguro que deseas Re-Imprimir la comanda ?';

implementation

uses BAR03;

{$R *.dfm}

function TDM.SetCentralizar(Const aValue:String;aSize : Smallint = 40):String;
var
  sStr  : String;
  sSize,Linea : Smallint;

begin
  sStr   :='';
  sSize  :=(aSize - Length(Trim(aValue))) div 2;
  for Linea := 1 to sSize do
    sStr :=sStr+' ';
  Result := sStr+Trim(aValue);
end;

Function Tdm.PAD(Mchar,Alineacion:char;tamano:Integer;Numero:String):string;
{**-[Esta función es para rellenar una cadena con un valor recibido a un
     tamaño dado recibe como parámetro lo sigte :
     Mchar:Es un carater cualquiera.
     Tamaño :Es el tamaño al cual sera combertida la cadena
     Número :Es la cadena enviada
     Tiene como resultado una cadena con el tamaño dado < S >  ]-**}

var S:String;
begin
  ///Numero :=Copy(aCero,1,(Tamano - Length(Trim(Numero))))+Numero;

  Alineacion :=UpCase(Alineacion);
  S:=Numero;
  while (Length(S) < Tamano) and not (Alineacion = 'C') do begin
    case  Alineacion of
      'L':S:=Mchar+S;
      'R':S:=S+Mchar;
    end;
  end;
  if  (Alineacion = 'C') then
       s:=SetCentralizar(Mchar);
  Result:=S;
end;

function TDM.Confirme(const msg:String):boolean ;
begin
  result:=false;
  try
    Application.CreateForm(tfrmConfirm, frmConfirm);
    frmConfirm.lbtitulo.Caption :=msg;
    frmConfirm.ShowModal;
    result:= frmConfirm.accion = 'S';
  finally
    frmConfirm.release;
  end;
end;


procedure TDM.ADOBarAfterConnect(Sender: TObject);
begin
  QEmpresa.Close;
  QEmpresa.Open;
end;

function TDM.Centro(Texto: String): String;
var
  a : integer;
  l : String;
begin
  l := '';
  for a := 1 to Trunc((42 - length(trim(texto))) / 2) do
  begin
    l := l + ' ';
  end;
  Result := l + trim(texto);
end;

procedure TDM.ADOBarBeforeConnect(Sender: TObject);
var
  ar : textfile;
  db : string;
begin
  assignfile(ar, '.\DashaSQL.ini');
  reset(ar);
  read(ar, db);
  ADOBar.ConnectionString := db+ConnectionStringPlus;
  closefile(ar);
end;

function TDM.LPad(pCadena: string; pLong: word; pRelleno: string): string;
begin
result := pCadena;

while Length(result) < pLong do
result := pRelleno + result;

if Length(pCadena) <= pLong then
result := Copy(result, 1, pLong);

end;

function TDM.RPad(pCadena: string; pLong: word; pRelleno: string): string;
begin
result := pCadena;

while Length(result) < pLong do
result := result+pRelleno;

if Length(pCadena) <= pLong then
result := Copy(result, 1, pLong);

end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
dm.QEmpresa.Close;
DM.QEmpresa.Open;
end;

procedure TDM.QEmpresaAfterOpen(DataSet: TDataSet);
begin
QParametros.Close;
QParametros.Open;
end;

function  tdm.getParametrosPrinterFiscal():boolean ;
begin
 ///if not Assigned(Impresora) then
  ImpresoraFiscal:=TImpresora.create(nil);

  With dm.adoMultiUso do begin
    Close;
    Sql.clear();
    sql.add('Select pc.nombre_pc,pc.idPrinter,pc.Puerto,pc.Velocidad,');
    sql.Add('       pc.cntCopia,pr.Nombre,pr.Tipo, pc.SUSTIRUIR_COPIA,');
    sql.Add('(select TOP 1 case when par_itbisincluido = ''False'' then ''N'' else ''S'' end from Parametros where emp_codigo = '+QuoteNull(QEmpresaEmpresaID.Text)+') PrecioIncluyeItbis');
    sql.Add('From Printer_en_PC pc , Printers pr ');
    sql.Add('Where pc.idPrinter = pr.IDPrinter');
    sql.add('And pc.nombre_pc = :nombrepc');
    Parameters.ParamByName('nombrepc').value := GetPcName;
    //Parameters.ParamByName('ip').value := IP ;
    open;
    if not IsEmpty then
      begin //1
        With ImpresoraFiscal do begin
          NombrePC  := dm.adoMultiUso['nombre_pc'];
          IDPrinter := dm.adoMultiUso['idPrinter'];
          Nombre    := dm.adoMultiUso['Nombre'];
          Puerto    := StrToInt(copy(dm.adoMultiUso['Puerto'],4,length(dm.adoMultiUso['Puerto']) ));
          Velocidad := dm.adoMultiUso['Velocidad'];
          Tipo      := dm.adoMultiUso['Tipo'];
          Copia     := dm.adoMultiUso['cntCopia'];
          Precioconitbis := dm.adoMultiUso['PrecioIncluyeItbis'];
          esFiscal  := true;
          SustituirCopia :=  dm.adoMultiUso['SUSTIRUIR_COPIA'] = 'True';
        end;
      end // 1

  end;

  result := ImpresoraFiscal.IDPrinter > 0;
 end;

function TDM.GetPcName: string;
var
  Buffer: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  Size: Cardinal;
begin
  FillChar(Buffer,Sizeof(Buffer),0);
  Size:= Sizeof(Buffer);
  if GetComputerName(Buffer,Size) then
    Result:= String(PChar(@Buffer))
  else
    Result:= '';

end;

function TDM.getSecuencia(Tabla, Campo: string): Integer;
//----[Esta funcion sirve para buscar el proximo numero secuencia de cualquier tabla]----
Const
  SQLsecuencia ='Select IsNull(max(%s + 1),1) ID From %s ';
var
  aNumero:Integer;
Begin

  With adoMultiUso do Begin {0}
    Close;
    Sql.Clear;
    Sql.Add(format(SQLsecuencia,[Campo,Tabla]));
    Open;
    try
      aNumero :=StrToInt(fieldbyName('ID').AsString);
      Result := aNumero ;
    except
      Result :=1;
    end;
    Close;
  end;{0}
end;

end.

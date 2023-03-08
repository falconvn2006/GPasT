unit POS01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, IBDatabase, IBCustomDataSet, IBQuery, DBXpress,
  SqlExpr, Provider, DBClient, DBLocal, IBUpdateSQL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, ADODB, ImgList,
  DIMime, magwmi, magsubs1, frxExportXLS, frxClass, frxExportPDF, frxDBSet,
  QRExport, QRPDFFilt, WinSvc,vmaxFiscal,WinSock,iFiscal, uLkJSON;

type
  TDM = class(TDataModule)
    ADOSIGMA: TADOConnection;
    Query1: TADOQuery;
    QEmpresa: TADOQuery;
    QEmpresaemp_codigo: TIntegerField;
    QEmpresaemp_nombre: TStringField;
    QEmpresaemp_direccion: TStringField;
    QEmpresaemp_localidad: TStringField;
    QEmpresaemp_telefono: TStringField;
    QEmpresaemp_fax: TStringField;
    QEmpresaemp_rnc: TStringField;
    QEmpresacode_rnc: TStringField;
    adoMultiUso: TADOQuery;
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
    QParametrospar_inv_imprime_comentario: TStringField;
    QParametrosmensaje_ticket: TMemoField;
    adoMultiUsoII: TADOQuery;
    QParametrospar_aplica_desc_por_rango_venta: TStringField;
    QQuery: TADOQuery;
    QParametrosPAR_CODIGO_ABRE_CAJA: TStringField;
    QParametrospar_Marca_Printer: TStringField;
    QParametrospar_puerto_Printer: TStringField;
    QParametrospar_velocidad_Printer: TIntegerField;
    procedure ADOSIGMABeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure GrabaLogCardNet(emp, suc, usu, facticket:Integer;resultado, tipo, tipofacticket:String;monto,itbis:Double);
    function RPad(pCadena: string; pLong: word; pRelleno: string = ' '): string;
    function LPad(pCadena: string; pLong: word; pRelleno: string = ' '): string;
  private

    { Private declarations }
  public
    Usuario : integer;
    NomUsuario, Puerto, Puerto2 : string;
    function  Centro (Texto : String) : String;
    function getFechaServidor: TDatetime;
    function getFechaServidor2: TDatetime;
    function validaSerie(vPro_codigo,vSer_numero: string):boolean;
    procedure Imp40Columnas(const vARCH: TextFile);
    Function FillSpaces(cVar:String;nLen:Integer):String;
    Function FillCeros(cVar:String;nLen:Integer):String;
    Function FillSpacesLeft(cVar:String;nLen:Integer):String;
    Function GetIPAddress():String;
    function QuitarPuntosDecimal(Value:Double):String ;
    function PAD(Mchar, Alineacion: char; tamano: Integer;Numero: String): string;
    function getParametrosPrinterFiscal: String;

  end;

var
   DM: TDM;
  Impresora :TImpresora;
  PCNombre,IP :String;
  dirTmp:String;
implementation

uses printers;

{$R *.dfm}

{ TDM }

function TDM.getFechaServidor():TDatetime ;
begin
  with dm.adoMultiUso do begin
    Close;
    Sql.clear;
    sql.add('SELECT CAST(CAST(GETDATE() AS CHAR(11)) AS DATETIME) FECHA');
    open;
    if not IsEmpty then
      Result :=dm.adoMultiUso['fecha'];
  end;
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

procedure TDM.ADOSIGMABeforeConnect(Sender: TObject);
var
  ar : textfile;
  db : string;
begin
  assignfile(ar, '.\dashasql.ini');
  reset(ar);
  read(ar, db);
  db := db + ';User ID=randy;password=dayelcris';
  ADOSigma.ConnectionString := db;
  closefile(ar);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ADOSIGMA.Connected := false;
end;

function TDM.validaSerie(vPro_codigo, vSer_numero: string): boolean;
begin
  result:= false;
  with QQuery, sql do
  begin
    close;
    clear;
    if vSer_numero <> EmptyStr then
       begin
        Add('select Documento,ser_numero FROM ');
        Add('  ( SELECT ('+QuotedStr('CONDUCE -')+ ' + CAST(dbo.Conduce_Serie.con_numero as varchar)) as Documento,ser_numero FROM Conduce_Serie');
        Add('    UNION ');
        Add('    SELECT ('+QuotedStr('FACTURA -')+ ' + CAST(dbo.FacSerie.fac_numero as varchar)) as Documento,ser_numero FROM FacSerie )as a');
        Add('WHERE a.ser_numero ='+QuotedStr(vSer_numero));
        Open;
        if not IsEmpty then
           ShowMessage('SERIE UTILIZADA EN EL DOCUMENTO : '+Fieldbyname('Documento').AsString);
       end;
    close;
    clear;
    Add('select * FROM Productos_Serie AS a  ');
    Add('where not a.ser_numero in ');
    Add('  ( SELECT Conduce_Serie.ser_numero FROM Conduce_Serie');
    Add('    UNION ');
    Add('    SELECT FacSerie.ser_numero FROM FacSerie )');
    Add('  and a.pro_codigo ='+vPro_codigo);
    Add('  and a.ser_numero ='+QuotedStr(vSer_numero));
    Open;
    Result := not IsEmpty;
    close;
  end;
end;

procedure TDM.Imp40Columnas(const vARCH: TextFile);
var puertopeq,
    Prn       : textfile;
    text      : string;
    pr        : TPrinter;
begin
  if FileExists('puerto.txt') then
  begin
    assignfile(puertopeq, 'puerto.txt');
    reset(puertopeq);
    readln(puertopeq, puerto);
    closefile(puertopeq);
  end
  else
    puerto := 'PRN';
//----------------------------------
  pr := TPrinter.Create;
  printer.PrinterIndex := pr.Printers.IndexOf(puerto);
  Reset(vARCH);
  AssignPrn(Prn);
  try
    Rewrite(Prn);
    try
    while not Eof(vARCH) do
      begin
        ReadLn(vARCH, text);
        writeln(Prn, text);
      end;
    finally
      CloseFile(Prn);
    end;
    except on EInOutError do MessageDlg('Error al imprimir el Documento', mtError, [mbOk], 0);
  end;
  CloseFile(vARCH);
pr.Free;
end;

function TDM.FillSpaces(cVar: String; nLen: Integer): String;
begin
Result:=StringOfChar(' ',nLen - Length(cVar))+cVar;
end;

function TDM.FillSpacesLeft(cVar: String; nLen: Integer): String;
begin
Result:=cVar+StringOfChar(' ',nLen - Length(cVar));
end;

function TDM.FillCeros(cVar: String; nLen: Integer): String;
begin
Result:=StringOfChar('0',nLen - Length(cVar))+cVar;
end;

function TDM.GetIPAddress: String;
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
    //Result := 'IP Address: '+inet_ntoa(varTInAddr);
  End;
  WSACleanup;

end;

function TDM.QuitarPuntosDecimal(Value: Double): String;
var
  ValorDoubleTxt:String;
  ParteEntera  ,ParteDecimal :String;
begin
  ValorDoubleTxt := Format('%.2f', [Value]);
  ParteEntera:= copy(ValorDoubleTxt,0,pos('.',ValorDoubleTxt)-1);
  ParteDecimal:= copy(ValorDoubleTxt,pos('.',ValorDoubleTxt)+1,length(ValorDoubleTxt));
  result :=  ParteEntera+ParteDecimal;

end;

function TDM.getFechaServidor2: TDatetime;
begin
  with dm.adoMultiUso do begin
    Close;
    Sql.clear;
    sql.add('SELECT GETDATE() FECHA');
    open;
    if not IsEmpty then
      Result :=dm.adoMultiUso['FECHA'];
  end;

end;

function TDM.PAD(Mchar, Alineacion: char; tamano: Integer;
  Numero: String): string;
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
  while Length(S) < Tamano do begin
    if Alineacion = 'L' then
      S:=Mchar+S
    else if Alineacion = 'R' then
      S:=S+Mchar
    else if Alineacion = 'C' then
      S:=S;
  end;

  Result:=S;

end;

function TDM.getParametrosPrinterFiscal: String;
begin
  ///if not Assigned(Impresora) then
    Impresora:=TImpresora.create(nil);

  With dm.adoMultiUso do begin
    Close;
    Sql.clear();
    sql.add('Select pc.nombre_pc,pc.idPrinter,pc.Puerto,pc.Velocidad,');
    sql.Add('       pc.cntCopia,pr.Nombre,pr.Tipo,pr.Precioconitbis, pc.sustiruir_copia ');
    sql.Add('From Printer_en_PC pc , Printers pr ');
    sql.Add('Where pc.idPrinter = pr.IDPrinter');
    sql.add('And ((pc.nombre_pc = :nombrepc) or (pc.nombre_pc = :ip)) ');
    Parameters.ParamByName('nombrepc').value := GetCompName;;
    Parameters.ParamByName('ip').value := GetIPAddress;;
    open;
    if not IsEmpty then
      begin //1
        With Impresora do begin
          NombrePC  := dm.adoMultiUso['nombre_pc'];
          IDPrinter := dm.adoMultiUso['idPrinter'];
          Nombre    := dm.adoMultiUso['Nombre'];
          Puerto    := StrToInt(copy(dm.adoMultiUso['Puerto'],4,length(dm.adoMultiUso['Puerto']) ));
          Velocidad := dm.adoMultiUso['Velocidad'];
          Tipo      := dm.adoMultiUso['Tipo'];
          Precioconitbis := dm.adoMultiUso['Precioconitbis'];
          Copia     := dm.adoMultiUso['cntCopia'];
          esFiscal  := true;
          SustituirCopia :=  dm.adoMultiUso['sustiruir_copia'] = 'True';
        end;
      end // 1
    else
      begin   //2
        if not QParametrospar_Marca_Printer.IsNull then
          begin //--[2.1]--
            Close;
            Sql.clear();
            sql.add('Select IDPrinter,Nombre,Tipo,Precioconitbis From Printers');
				    sql.add('Where IDPrinter = :ID ');
            Parameters.ParamByName('ID').value := dm.QParametrospar_Marca_Printer.Value;

            open;
            if not IsEmpty then begin  //--[2.1.1]--
              With Impresora do begin
                IDPrinter := 0;//dm.adoMultiUso['idPrinter'];
                Nombre := dm.adoMultiUso['Nombre'];
                Tipo      := dm.adoMultiUso['Tipo'];
                Precioconitbis := dm.adoMultiUso['Precioconitbis'];
                Copia     := 0; //dm.adoMultiUso['cntCopia'];
                esFiscal  := true;

                if not dm.QParametrospar_puerto_Printer.IsNull then
                  Puerto := StrToInt(Copy(dm.QParametrospar_puerto_Printer.value,4,1));
                if not dm.QParametrospar_velocidad_Printer.IsNull then
                  Velocidad := dm.QParametrospar_velocidad_Printer.value ;
              end;
            end; //--[2.1.1]--
          end;  //--[2.1]--

        end; //2
      end;

end;

procedure TDM.GrabaLogCardNet(emp, suc, usu, facticket:Integer;resultado, tipo, tipofacticket:String;monto,itbis:Double);
begin
with adoMultiUso do begin
  Close;
  SQL.Clear;
  SQL.Add('INSERT INTO adLogVeriphone');
  SQL.Add('select :emp, :suc, :usu, getdate(), :tipo, :monto, :itbis, :num, :tipofacticket, :result');
  Parameters.ParamByName('emp').DataType    := ftInteger;
  Parameters.ParamByName('suc').DataType    := ftInteger;
  Parameters.ParamByName('usu').DataType    := ftInteger;
  Parameters.ParamByName('tipo').DataType   := ftString;
  Parameters.ParamByName('monto').DataType  := ftCurrency;
  Parameters.ParamByName('itbis').DataType  := ftCurrency;
  Parameters.ParamByName('num').DataType    := ftInteger;
  Parameters.ParamByName('tipofacticket').DataType := ftString;
  Parameters.ParamByName('result').DataType := ftString;
  Parameters.ParamByName('emp').Value       := emp;
  Parameters.ParamByName('suc').Value       := suc;
  Parameters.ParamByName('usu').Value       := usu;
  Parameters.ParamByName('tipo').Value      := tipo;
  Parameters.ParamByName('monto').Value     := monto;
  Parameters.ParamByName('itbis').Value     := itbis;
  Parameters.ParamByName('num').Value       := facticket;
  Parameters.ParamByName('tipofacticket').Value := tipofacticket;
  Parameters.ParamByName('result').Value    := resultado;
  ExecSQL;
end;
end;

function TDM.RPad(pCadena: string; pLong: word; pRelleno: string): string;
begin
{Inicialización}
result := pCadena;

while Length(result) < pLong do
result := result + pRelleno;

{Como el resultado podría tener más de "pLong" caracteres, lo recortamos.}
if Length(pCadena) <= pLong then
result := Copy(result, 1, pLong);
end;

function TDM.LPad(pCadena: string; pLong: word; pRelleno: string): string;
begin
{Inicialización}
result := pCadena;

while Length(result) < pLong do
result := pRelleno + result;

{Como el resultado podría tener más de "pLong" caracteres, lo recortamos.}
if Length(pCadena) <= pLong then
result := Copy(result, 1, pLong);
end;

end.

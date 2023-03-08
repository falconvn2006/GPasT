unit POS08;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, Buttons, Grids, DBGrids, DB, ADODB,
  ECRti_Framework_TLB, uJSON;

type
  TfrmAnular = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    btanular: TSpeedButton;
    DBGrid1: TDBGrid;
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
    dsTicket: TDataSource;
    QTicketNCF: TStringField;
    btimprimir: TSpeedButton;
    fecha: TDateTimePicker;
    fecha2: TDateTimePicker;
    hora1: TDateTimePicker;
    hora2: TDateTimePicker;
    btdomicilio: TSpeedButton;
    QTicketemp_codigo: TIntegerField;
    qImpCardNet: TADOQuery;
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure QTicketCalcFields(DataSet: TDataSet);
    procedure btanularClick(Sender: TObject);
    procedure dsTicketDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImpTicketCardNet;
  private
    { Private declarations }
    core : TCore;
      result : string;
      response: String;

      ipLocal: string;
      ipRemote: String;

      timeout : Integer;
      portLocal: Integer;
      portRemote: Integer;
      Host:Integer;
      ReferenceNumber:Integer;
      amount, tax : Double;
  public
    { Public declarations }
    Imprimir, supervisor, seleccion, empresa : integer;
    cliente : string;
    Llevar, vp_veriphone : boolean;
  end;

var
  frmAnular: TfrmAnular;

implementation

uses POS01, POS23;

{$R *.dfm}

procedure TfrmAnular.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAnular.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
  if (key = vk_f1) and (btanular.Visible)   then btanularClick(Self);
  if (key = vk_f2) and (btimprimir.Visible) then btimprimirClick(Self);
end;

procedure TfrmAnular.QTicketCalcFields(DataSet: TDataSet);
begin
  if not QTicketNCF_Fijo.IsNull then
    QTicketNCF.Value := QTicketNCF_Fijo.Value + FormatFloat('00000000',QTicketNCF_Secuencia.value)
  else
    QTicketNCF.Value := '';
end;

procedure TfrmAnular.btanularClick(Sender: TObject);
var
  a : myJSONItem;

  tamount, ttax, othertax : Integer;
begin
  if MessageDlg('ESTA SEGURO QUE DESEA ANULAR ESTE TICKET?',mtConfirmation,[mbyes,mbno],0) = mryes then
  begin
        dm.Query1.Close;
        DM.Query1.SQL.Clear;
        DM.Query1.SQL.Add('SELECT pagado');
        DM.Query1.SQL.Add('from formas_pago_ticket fp');
        DM.Query1.SQL.Add('where caja = :caj');
        dm.Query1.SQL.Add('and usu_codigo = :usu');
        dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        dm.Query1.SQL.Add('and ticket = :tik and forma = '+QuotedStr('TAR'));
        dm.Query1.Parameters.ParamByName('usu').Value    := QTicketusu_codigo.Value;
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
        dm.Query1.Parameters.ParamByName('caj').Value    := QTicketcaja.Value;
        dm.Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        dm.Query1.Open;

        amount          := dm.Query1.fieldbyname('pagado').Value*100;
        tax             := amount *0.18;
        othertax        := 0;

        tamount := StrToInt(dm.QuitarPuntosDecimal(amount));
        Ttax    := StrToInt(dm.QuitarPuntosDecimal(tax));




    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('update montos_ticket');
    dm.Query1.SQL.Add('set supervisor = :sup');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
    dm.Query1.SQL.Add('and ticket = :tik');
    dm.Query1.Parameters.ParamByName('sup').Value    := supervisor;
    dm.Query1.Parameters.ParamByName('usu').Value    := QTicketusu_codigo.Value;
    dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
    dm.Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
    dm.Query1.Parameters.ParamByName('caj').Value    := QTicketcaja.Value;
    dm.Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
    dm.Query1.ExecSQL;



    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('execute pr_anula_ticket :usu, :caj, :fec, :tik');
    dm.Query1.Parameters.ParamByName('usu').Value    := QTicketusu_codigo.Value;
    dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
    dm.Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
    dm.Query1.Parameters.ParamByName('caj').Value    := QTicketcaja.Value;
    dm.Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
    dm.Query1.ExecSQL;

    if vp_veriphone = True then begin
    //Anular Trasaccion en Veriphone
        dm.Query1.Close;
        DM.Query1.SQL.Clear;
        DM.Query1.SQL.Add('SELECT for_veriphone_desc JSON');
        DM.Query1.SQL.Add('from formas_pago_ticket fp');
        DM.Query1.SQL.Add('where caja = :caj');
        dm.Query1.SQL.Add('and usu_codigo = :usu');
        dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        dm.Query1.SQL.Add('and ticket = :tik and forma = '+QuotedStr('TAR'));
        dm.Query1.Parameters.ParamByName('usu').Value    := QTicketusu_codigo.Value;
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
        dm.Query1.Parameters.ParamByName('caj').Value    := QTicketcaja.Value;
        dm.Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        dm.Query1.Open;
        if NOT DM.Query1.FieldByName('JSON').IsNull then begin
        a               := myJSONItem.Create;
        a.Code          := DM.Query1.FieldByName('JSON').Value;
        Host            := StrToInt(a['Host']['Value'].getStr);
        ReferenceNumber := StrToInt(a['Transaction']['Reference'].getStr);
        response := core.Initialice;
        response := core.ProcessAnnulment(Host,ReferenceNumber);
        dm.query1.close;
        //emp, suc, usu, facticket:Integer;resultado, tipo, tipofacticket:String;monto,itbis:Double
        dm.GrabaLogCardNet(DM.QEmpresaemp_codigo.Value,1,dm.Usuario,QTicketticket.Value,response,'A','T',amount,tax);
        if Length(response)>=35 then begin
        DM.Query1.SQL.Add('update formas_pago_ticket');
        DM.Query1.SQL.Add('set for_veriphone_devolucion = :response');
        DM.Query1.SQL.Add('where caja = :caj');
        dm.Query1.SQL.Add('and usu_codigo = :usu');
        dm.Query1.SQL.Add('and fecha = convert(datetime, :fec, 105)');
        dm.Query1.SQL.Add('and ticket = :tik and forma = '+QuotedStr('TAR'));
        dm.Query1.Parameters.ParamByName('usu').Value    := QTicketusu_codigo.Value;
        dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
        dm.Query1.Parameters.ParamByName('fec').Value    := QTicketfecha.Value;
        dm.Query1.Parameters.ParamByName('caj').Value    := QTicketcaja.Value;
        dm.Query1.Parameters.ParamByName('tik').Value    := QTicketticket.Value;
        dm.Query1.Parameters.ParamByName('response').DataType := ftString;
        dm.Query1.Parameters.ParamByName('response').Value := response;
        dm.Query1.ExecSQL;

        ImpTicketCardNet;


        end
        else
        ShowMessage('LA TRASACCION NO SE ENCONTRO EN EL VERIPHONE, POSIBLE CIERRE EJECUTADO...');
        end;

    Close;
    end;
  end;
end;

procedure TfrmAnular.dsTicketDataChange(Sender: TObject; Field: TField);
begin
  btanular.Visible := (QTicket.RecordCount > 0) and (not Llevar);
end;

procedure TfrmAnular.FormCreate(Sender: TObject);
begin
  fecha.Date  := Date-1;
  fecha2.Date := Date;
  hora1.Date  := Date-1;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('08:00:00');
  hora2.Time  := StrToTime('23:59:59');
  Imprimir := 0;


WITH dm.adoMultiUso do begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT IP, PORTCAJA, PORTPOS, TIMEOUT, CAJA FROM VerifoneEnCaja WHERE CAJA ='+QuotedStr(DM.GetIPAddress));
  Open;
  IF not IsEmpty THEN
  BEGIN
  vp_veriphone := True;
  core := TCore.Create(Self);

  ipLocal     := DM.adoMultiUso.FieldByName('CAJA').Text;
  portLocal   := DM.adoMultiUso.FieldByName('PORTCAJA').Value;
  ipRemote    := DM.adoMultiUso.FieldByName('IP').Text;
  portRemote  := DM.adoMultiUso.FieldByName('PORTPOS').Value;
  timeout     := DM.adoMultiUso.FieldByName('TIMEOUT').Value;

  result := core.SetTimeOut(timeOut);
  result := core.SetLocalEndPoint(ipLocal, portLocal);
  result := core.SetRemoteEndPoint(ipRemote, portRemote);
end
else
begin
vp_veriphone := False;
end;
end;
end;

procedure TfrmAnular.btimprimirClick(Sender: TObject);
begin
  Imprimir := 1;
  Close;
end;

procedure TfrmAnular.FormActivate(Sender: TObject);
begin
  btanular.Visible    := (not Llevar) and (btimprimir.Visible = false);
  btimprimir.Visible  := (not Llevar) and (btanular.Visible = false);
  btdomicilio.Visible := (Llevar) and (btanular.Visible = false) and (btimprimir.Visible = false);
end;

procedure TfrmAnular.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
  begin
    if Llevar then
    begin
      Application.CreateForm(tfrmDomicilio, frmDomicilio);
      frmDomicilio.ShowModal;
      seleccion := frmDomicilio.seleccion;
      empresa   := frmDomicilio.QClientesemp_codigo.AsInteger;
      cliente   := frmDomicilio.QClientescli_referencia.AsString;
      frmDomicilio.Release;
      if seleccion = 1 then
        Close;
    end;
  end;
end;

procedure TfrmAnular.ImpTicketCardNet;
var
  archCardNet, puertopeqCardNet : textfile;
  s, s1, s2, s3, s4, s5,s6 : array [0..20] of char;
  Tfac, Saldo : double;
  vp_puerto, lbitbis, impcodigo, parametro, Unidad, codigoabre, puerto : string;
  a,x : integer;
  b : myJSONItem;
begin
if Length(response) >= 35 then begin

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Puerto, codigo_abre_caja from cajas_IP');
      dm.Query1.SQL.Add('where caja = :caj');
      dm.Query1.Parameters.ParamByName('caj').Value := QTicketcaja.Value;
      dm.Query1.Open;
      if dm.Query1.RecordCount > 0 then begin
      codigoabre := Trim(dm.Query1.fieldbyname('codigo_abre_caja').Value);
      vp_puerto     := Trim(dm.Query1.fieldbyname('puerto').Value);
      end;

  if FileExists('.\puerto.txt') then
  begin
    assignfile(puertopeqCardNet, '.\puerto.txt');
    reset(puertopeqCardNet);
    readln(puertopeqCardNet, vp_puerto);
  end
  else
    puerto := 'PRN';

 with qImpCardNet do begin
Close;
Parameters.ParamByName('emp').Value :=  QTicketemp_codigo.Value;
Parameters.ParamByName('tic').Value :=  QTicketticket.Value;
Parameters.ParamByName('fec').Value :=  QTicketfecha.Value;
Parameters.ParamByName('caj').Value :=  QTicketcaja.Value;
Parameters.ParamByName('usu').Value :=  QTicketusu_codigo.Value;
Open;
if qImpCardNet.RecordCount > 0 then begin
b := myJSONItem.Create;
b.Code :=  qImpCardNet.fieldByName('JSON').Value;


  //Ticket Devuelto
  AssignFile(archCardNet, '.\tveriphoneDevolucion.bat');
  rewrite(archCardNet);
  writeln(archCardNet, 'type .\tveriphoneDevolucion.txt > '+vp_puerto);
  closefile(archCardNet);

  AssignFile(archCardNet, '.\tveriphoneDevolucion.txt');
  rewrite(archCardNet);
  parametro := qImpCardNet.fieldbyname('SUCURSAL').Text;
  writeln(archCardNet,dm.centro(parametro));
  writeln(archCardNet,dm.centro(qImpCardNet.FieldByName('DIRECCION').text));
  writeln(archCardNet,b['DataTime'].getStr);
  //parametro := IntToStr(b['Transaction']['Reference'].getInt);
  //writeln(archCardNet,'No. Trans.      : '+parametro);
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('REGISTRO DE LA DEVOLUCION'));
  //writeln(archCardNet,'No. de Terminal : '+b['TerminalID'].getStr);
  //writeln(archCardNet,'ID Comerciante  : '+b['MerchantID'].getStr);
  writeln(archCardNet,'');
  writeln(archCardNet,'TARJETA         : ' +b['Card']['Product'].getStr);
  //writeln(archCardNet,'TIPO COMPRA     : '+b['Transaction']['LoyaltyDeferredNumber'].getStr);
  parametro  := copy(b['Card']['CardNumber'].getStr,Length(b['Card']['CardNumber'].getStr)-3,Length(b['Card']['CardNumber'].getStr));
  writeln(archCardNet,'No. tarjeta     : '+parametro);
  writeln(archCardNet,'Modo Entrada    : '+b['Host']['Description'].getStr);
  writeln(archCardNet,'ANULADA         : OK');
  //writeln(archCardNet,'Cliente         : '+copy(b['Card']['HolderName'].getStr,1,24));
  //writeln(archCardNet,'');
  writeln(archCardNet,'');
  parametro := FormatCurr('#,0.00',(amount-tax)/100);
  writeln(archCardNet,'Monto RD$       : '+ parametro);
  parametro := FormatCurr('#,0.00',tax/100);
  writeln(archCardNet,'Itbis RD$       : '+parametro);
  parametro := FormatCurr('#,0.00',amount/100);
  writeln(archCardNet,'Total RD$       : '+parametro);
  //writeln(archCardNet,'');
  //writeln(archCardNet,'');
  //writeln(archCardNet,DM.CENTRO(c['Messages'].getStr));
 // writeln(archCardNet,'');
 // writeln(archCardNet,'');
 // writeln(archCardNet,'No de referencia: '+b['Transaction']['RetrievalReference'].getStr);
  writeln(archCardNet,'No Autorizacion : '+b['Transaction']['AuthorizationNumber'].getStr);
  PARAMETRO := FormatDateTime('dd/mm/yyyy hh:mm:ss',Now);
  writeln(archCardNet,'Fecha            : '+parametro);
 // writeln(archCardNet,'Hora             : '+trim(copy(b['Transaction']['DataTime'].getStr,12,20)));
  //writeln(archCardNet,'');
  writeln(archCardNet,'');
  writeln(archCardNet,dm.centro('***FIN DOCUMENTO NO VENTA***'));

  for x:= 1 to 2 do begin
  writeln(archCardNet,'');
  end;

  if codigoabre = 'Termica' then
  writeln(archCardNet,chr(27)+chr(109));

  CloseFile(archCardNet);

 winexec('.\tveriphoneDevolucion.bat',0);


 end;

end;
end;
end;

end.

unit BAR02;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, DIMime, StdCtrls, DB, ADODB;

type
  TfrmOpciones = class(TForm)
    btclose: TSpeedButton;
    bthold: TSpeedButton;
    btreimprimir: TSpeedButton;
    btdrawer: TSpeedButton;
    btimpuestos: TSpeedButton;
    btdesembolso: TSpeedButton;
    btlogout: TSpeedButton;
    btdescuento: TSpeedButton;
    Memo1: TMemo;
    btunifmesa: TSpeedButton;
    btDividirCuenta: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    qFormaPag: TADOQuery;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btlogoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btholdClick(Sender: TObject);
    procedure btdesembolsoClick(Sender: TObject);
    procedure btdescuentoClick(Sender: TObject);
    procedure btreimprimirClick(Sender: TObject);
    procedure btimpuestosClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btunifmesaClick(Sender: TObject);
    procedure btDividirCuentaClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    vl_cuenta : Boolean;
  public
    { Public declarations }
    Procedure ImpTicket;
    Procedure ImpTicketNew;
    Procedure ImpDesembolso;
    procedure pnabrircaja;
  end;

var
  frmOpciones: TfrmOpciones;

implementation

uses BAR03, BAR00, BAR34, BAR14, BAR04, BAR38, BAR01, BAR39, BAR40,
  Math, BAR52, BAR15, BAR55, BAR17, BAR16;

{$R *.dfm}

procedure TfrmOpciones.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOpciones.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btholdClick(Self);
  if key = vk_f3 then btreimprimirClick(Self);
  if (key = vk_f5) and (btimpuestos.Enabled) then btimpuestosClick(Self);
  if (key = vk_f6) and (btdesembolso.Enabled) then btdesembolsoClick(Self);
  if (key = vk_f7) and (btdescuento.Enabled) then btdescuentoClick(Self);
  if (key = vk_f8) and (btunifmesa.Enabled) then btunifmesaClick(Self);
  if key = vk_f10 then btlogoutClick(Self);
end;

procedure TfrmOpciones.btlogoutClick(Sender: TObject);
begin
  if frmPOS.Total = 0 then
  begin
    DM.ADOBar.Execute('UPDATE MESAS SET ESTATUS = '+QuotedStr('DISP')+' WHERE MESAID IN (SELECT MESAID FROM factura_restbar where estatus = ''ABI'' AND TOTAL = 0)');


    Application.CreateForm(tfrmConfirm, frmConfirm);
    frmConfirm.lbtitulo.Caption := 'Está seguro que desea salir del Sistema?';
    frmConfirm.ShowModal;
    if frmConfirm.accion = 'S' then
    begin
      frmConfirm.Release;
      frmPOS.Close;
      Close;
    end
    else
    begin
      frmConfirm.Release;
      abort;
    end;
  end;
end;

procedure TfrmOpciones.FormCreate(Sender: TObject);
begin
  btclose.Caption  := 'F1'+#13+'SALIR';
  bthold.Caption   := 'F2'+#13+'HOLD';
  btlogout.Caption := 'F10'+#13+'DESCONECTAR';
  btdesembolso.Caption := 'F6'+#13+'DESEMBOLSO';
  btreimprimir.Caption := 'F3'+#13+'REIMPRIMIR';
  btdrawer.Caption := 'F4'+#13+'DRAWER';
  btimpuestos.Caption := 'F5'+#13+'IMPUESTOS';
  btdescuento.Caption := 'F7'+#13+'DESCUENTO';
  btunifmesa.Caption := 'F8'+#13+'UNIFICAR MESA';
  btDividirCuenta.Caption := 'F9'+#13+'DIVIDIR CUENTA';
  if frmPOS.QFactura.Active then
  begin
    frmPOS.Total := frmPOS.QFacturaTotal.Value;
    btlogout.Enabled := (frmPOS.QFacturaTotal.Value = 0);
  end;
end;

procedure TfrmOpciones.btholdClick(Sender: TObject);
begin
  frmPOS.btholdClick(Self);
  frmOpciones.Close;
end;

procedure TfrmOpciones.btdesembolsoClick(Sender: TObject);
var
  maximo : integer;
begin
{ 2017 06 26
  if frmPOS.QDetalle.RecordCount > 0 then
  begin }
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
        Application.CreateForm(tfrmDesembolso, frmDesembolso);
        frmDesembolso.ShowModal;
        if frmDesembolso.Acepto = 1 then
           begin
    //Creando el desembolso
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select isnull(max(DesembolsoID),0) as maximo from RestBar_Desembolso');
          dm.Query1.Open;
          maximo := dm.Query1.FieldByName('maximo').AsInteger + 1;

          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('insert into RestBar_Desembolso (DesembolsoID, Fecha, CajeroID, Monto, Concepto, Estatus, CajaID)');
          dm.Query1.SQL.Add('values (:des, :fec, :usu, :mto, :con, :est, :caj)');
          dm.Query1.Parameters.ParamByName('des').Value := maximo;
          dm.Query1.Parameters.ParamByName('fec').Value := Now;
          dm.Query1.Parameters.ParamByName('usu').Value := frmMain.Usuario;
          dm.Query1.Parameters.ParamByName('mto').Value := strToFloat(frmDesembolso.edmonto.Text);
          dm.Query1.Parameters.ParamByName('con').Value := frmDesembolso.edconcepto.Text;
          dm.Query1.Parameters.ParamByName('est').Value := 'EMI';
          dm.Query1.Parameters.ParamByName('caj').Value := 1;
          dm.Query1.ExecSQL;

          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select * from RestBar_Desembolso where DesembolsoID = :des');
          dm.Query1.Parameters.ParamByName('des').Value := maximo;
          dm.Query1.Open;

          ImpDesembolso;
          end;
      end;
  frmAcceso.Release;
end;

procedure TfrmOpciones.btdescuentoClick(Sender: TObject);
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

procedure TfrmOpciones.btreimprimirClick(Sender: TObject);
begin
  Application.CreateForm(tfrmBuscaFactura, frmBuscaFactura);
  frmBuscaFactura.ShowModal;
  vl_cuenta := False;
  if frmBuscaFactura.acepto = 1 then
   ImpTicketNew;
  frmBuscaFactura.Release;

{  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.ShowModal;
  if frmAcceso.Acepto = 1 then
  begin
    dm.Query1.close;
    dm.Query1.sql.clear;
    dm.Query1.sql.add('select UsuarioID, Nombre, Supervisor, Cajero, Camarero, Estatus');

    if (copy(frmAcceso.edclave.Text,1,1) = ';') or (copy(frmAcceso.edclave.Text,1,1) = 'Ñ') then
    begin
      dm.Query1.sql.add('from usuarios where tarjetaSupervisorID = :cla');
      dm.Query1.Parameters.parambyname('cla').Value := copy(frmAcceso.edclave.Text,2,10);
    end
    else
    begin
      dm.Query1.sql.add('from Usuarios where Clave = :cla');
      dm.Query1.Parameters.parambyname('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);
    end;

    dm.Query1.open;
    if dm.Query1.recordcount = 0 then
    begin
      showmessage('ESTE USUARIO NO EXISTE')
    end
    else if dm.Query1.FieldbyName('Estatus').AsString <> 'ACT' then
    begin
      showmessage('ESTE USUARIO NO ESTA ACTIVO');
    end
    else if dm.Query1.FieldbyName('Supervisor').AsBoolean <> True then
    begin
      showmessage('ESTE USUARIO NO ES SUPERVISOR');
    end
    else
    begin
      Application.CreateForm(tfrmBuscaFactura, frmBuscaFactura);
      frmBuscaFactura.ShowModal;
      if frmBuscaFactura.acepto = 1 then
        ImpTicket;
      frmBuscaFactura.Release;
    end;
  end; //}
end;

procedure TfrmOpciones.ImpTicket;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5,s6,s7 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, MPagado : Double;
  Puntos, a : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis : String;
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

  assignfile(arch,'.\imp.bat');
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

  if frmBuscaFactura.QForma.RecordCount > 0 then
  begin
    writeln(arch, dm.centro('*** F A C T U R A ***'));
    if frmBuscaFactura.QFacturaCredito.Value then
       writeln(arch, dm.centro('* C R E D I T O *'));

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
    dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
    dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
    dm.Query1.Parameters.ParamByName('tipo').Value := frmBuscaFactura.QFacturatiponcf.Value;
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

  writeln(arch, 'Fecha .: '+DateToStr(frmBuscaFactura.QFacturaFecha.Value)+' Factura: '+formatfloat('0000000000',frmBuscaFactura.QFacturaFacturaID.value));
  writeln(arch, 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(frmBuscaFactura.QFacturaHora.AsDateTime));
  writeln(arch, 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring);

  if not frmBuscaFactura.QFacturamesaid.IsNull then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    dm.Query1.SQL.Add('from Mesas m, Areas a');
    dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
    dm.Query1.SQL.Add('and m.mesaid = :cod');
    dm.Query1.SQL.Add('order by m.MesaID');
    dm.Query1.Parameters.ParamByName('cod').Value := frmBuscaFactura.QFacturamesaid.Value;
    dm.Query1.Open;

    writeln(arch, 'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
  end;

  if frmBuscaFactura.QFacturaNombre.Value <> '' then
  begin
    writeln(arch, 'Cliente: '+frmBuscaFactura.QFacturaNombre.Value);
    if Trim(frmBuscaFactura.QFacturarnc.Value) <> '' then
      writeln(arch, 'RNC ...: '+frmBuscaFactura.QFacturarnc.Value);
  end;

    if frmBuscaFactura.QFacturaNombre.Value = '' then
  begin
    writeln(arch, 'Cliente: [CLIENTE CONTADO]');
    if Trim(frmBuscaFactura.QFacturarnc.Value) <> '' then
      writeln(arch, 'RNC ...: '+frmBuscaFactura.QFacturarnc.Value);
  end;

   //buscar vencimiento
      with frmPOS.qEjecutar do begin
      Close;
      sql.Clear;
      SQL.Add('select FechaVenc ');
      sql.Add('from NCF ');
      sql.Add('where VerificaVenc = 1');
      sql.Add('and NCF_Fijo   = LEFT(:NCF,3)');
      Parameters.ParamByName('NCF').Value        := frmBuscaFactura.QFacturaNCF.Text;
      Open;
      if not IsEmpty then
      writeln(arch,'Fecha Venc.: '+FieldByName('FechaVenc').text);
      end;
      writeln(arch,'');


  if frmBuscaFactura.QFacturaNCF.Value <> '' then
    writeln(arch, 'NCF    : '+frmBuscaFactura.QFacturaNCF.Value);

  writeln(arch, '----------------------------------------');
  writeln(arch, 'CANT.       DESCRIPCION            TOTAL');
  writeln(arch, '----------------------------------------');
  TFac := 0;
  MontoItbis := 0;
  frmBuscaFactura.QDetalle.DisableControls;
  frmBuscaFactura.QDetalle.First;
  while not frmBuscaFactura.QDetalle.eof do
  begin
    s := '';
    FillChar(s, 5-length(format('%n',[frmBuscaFactura.QDetalleCantidad.value])),' ');
    s1 := '';
    FillChar(s1, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QDetalleValor.value]))), ' ');
    s2 := '';
    FillChar(s2, 22-length(copy(trim(frmBuscaFactura.QDetalleNombre.value),1,22)),' ');
    s3 := '';
    FillChar(s3, 8-length(trim(FORMAT('%n',[frmBuscaFactura.QDetallePrecio.value ]))),' ');
    s4 := '';
    FillChar(s4, 8-length(trim(FORMAT('%n',[(frmBuscaFactura.QDetallePrecio.value * frmBuscaFactura.QDetalleCantidad.Value)]))),' ');

    if frmBuscaFactura.QDetalleItbis.value then
      lbitbis := 'G'
    else
      lbitbis := 'E';

    IF frmBuscaFactura.QDetalleIngrediente.Value then begin {fernando}
       IF frmBuscaFactura.QDetalleVisualizar.Value then
       writeln(arch, s+format('%n',[frmBuscaFactura.QDetalleCantidad.value])+' '+
                  lbitbis+' '+copy(trim(frmBuscaFactura.QDetalleNombre.value),1,22)+s2+s1+format('%n',[frmBuscaFactura.QDetalleValor.value-frmBuscaFactura.QDetalleMontoItbis.Value]));
       end
    else
       writeln(arch, s+format('%n',[frmBuscaFactura.QDetalleCantidad.value])+' '+
                  lbitbis+' '+copy(trim(frmBuscaFactura.QDetalleNombre.value),1,22)+s2+s1+format('%n',[frmBuscaFactura.QDetalleValor.value]));

    TFac := TFac + frmBuscaFactura.QDetalleValor.value;
    frmBuscaFactura.QDetalle.next;
  end;
  frmBuscaFactura.QDetalle.First;
  frmBuscaFactura.QDetalle.EnableControls;
  writeln(arch, '                       -----------------');
  tCambio := frmBuscaFactura.QFormaDevuelta.Value;

  s := '';
  FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
  s1:= '';
  FillChar(s1, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QFormaMonto.Value]))), ' ');
  s2:= '';
  FillChar(s2, 10-length(trim(FORMAT('%n',[tCambio]))), ' ');
  s3:= '';
  FillChar(s3, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QFacturaItbis.Value]))), ' ');
  s4:= '';
  FillChar(s4, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QFacturaTotal.Value]))), ' ');
  s5:= '';
  FillChar(s5, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QFacturaPropina.Value]))), ' ');

  s6:= '';
  FillChar(s6, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QDetalleTotalessubTotal.Value]))), ' ');
  s7:= '';
  FillChar(s7, 10-length(trim(FORMAT('%n',[frmBuscaFactura.QFacturaDescuento.Value
                                          +frmBuscaFactura.QDetalleTotalesdescuentoTotal.Value]))), ' ');
        { Fernando }
  writeln(arch,'                   Sub-Total: '+s6+format('%n',[frmBuscaFactura.QDetalleTotalessubTotal.Value]));
  if frmBuscaFactura.QForma.RecordCount > 0 then
  begin
    writeln(arch, ' ');
    writeln(arch,'                   Itbis    : '+s3+format('%n',[frmBuscaFactura.QFacturaItbis.Value]));
    writeln(arch,'                   10% Ley  : '+s5+format('%n',[frmBuscaFactura.QFacturaPropina.Value]));
    if (frmBuscaFactura.QFacturaDescuento.Value+frmBuscaFactura.QDetalleTotalesdescuentoTotal.Value > 0) then
    writeln(arch,'                   Descuento: '+s7+format('%n',[frmBuscaFactura.QFacturaDescuento.Value
                                                                 +frmBuscaFactura.QDetalleTotalesdescuentoTotal.Value]));
    writeln(arch, ' ');
    writeln(arch,'                   Total    : '+s4+format('%n',[frmBuscaFactura.QFacturaTotal.Value]));


///Formas de Pago Jhonattan Gomez 20191116_1123
    {writeln(arch,'                   Recibido : '+s1+format('%n',[MPagado]));
    writeln(arch,'                   Cambio   : '+s2+format('%n',[tCambio]));}
    qFormaPag.Close;
    qFormaPag.SQL.Clear;
    qFormaPag.SQL.Add('select forma, sum(monto) monto, isnull(sum(case when devuelta < 0 then 0 else Devuelta end),0) devuelta ');
    qFormaPag.SQL.Add('from RestBar_Factura_Forma_Pago');
    qFormaPag.SQL.Add('where FacturaID = :num');
    qFormaPag.SQL.Add('group by forma');
    qFormaPag.Parameters.ParamByName('num').Value :=frmBuscaFactura.QFacturaFacturaID.Value;
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
       MPagado :=  frmBuscaFactura.QFacturaTotal.Value;
       tCambio :=  0;
    end;

    writeln(arch,'');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
      writeln(arch,'                    Dólares : '+s6+format('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
      writeln(arch,'                    Euros   : '+s7+format('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]));
    end;

    if frmBuscaFactura.QFacturaCredito.Value then
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
    writeln(arch,'                    Itbis   : '+s3+format('%n',[frmBuscaFactura.QFacturaItbis.Value]));
    writeln(arch,'                    10% Ley : '+s5+format('%n',[frmBuscaFactura.QFacturaPropina.Value]));
//    if (QFacturaDescuento.Value > 0) then
//    writeln(arch,'                   Descuento: '+s8+format('%n',[QFacturaDescuento.Value]));
    writeln(arch, ' ');
    writeln(arch,'               * * TOTAL    : '+s4+format('%n',[frmBuscaFactura.QFacturaTotal.Value]));
    writeln(arch, ' ');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]))), ' ');
      writeln(arch,'                    Dólares : '+s6+format('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)]));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FORMAT('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]))), ' ');
      writeln(arch,'                    Euros   : '+s7+format('%n',[(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)]));
    end;
  end;
  writeln(arch, ' ');
  writeln(arch, dm.centro(dm.QEmpresaMensaje1.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje2.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje3.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje4.AsString));
  writeln(arch, ' ');
  writeln(arch, dm.centro('<< COPYRIGHT DASHA RESTBAR 809-240-5197 >>'));
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  //Corta el papel
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select PAR_CODIGO_ABRE_CAJA cortar from parametros where emp_codigo ='+DM.QEmpresaEmpresaID.Text);
  DM.Query1.Open;
  if dm.Query1.RecordCount > 0 then
  if DM.Query1.FieldByName('cortar').Text = 'Termica' then
    writeln(arch,chr(27)+chr(109));
  closefile(Arch);
  winexec(pchar({ExtractFilePath(Application.ExeName)+}'imp.bat'),0);
end;

procedure TfrmOpciones.btimpuestosClick(Sender: TObject);
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
      //end;

      dm.Query1.open;
      if dm.Query1.recordcount = 0 then
      begin
        showmessage('ESTE USUARIO NO EXISTE');
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
        Application.CreateForm(tfrmImpuestos, frmImpuestos);
        frmImpuestos.ShowModal;
        frmImpuestos.Release;
      end;
  frmAcceso.Release;
  end;
  end;
end;

procedure TfrmOpciones.FormActivate(Sender: TObject);
begin
  btdescuento.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  btimpuestos.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  btdrawer.Enabled := (frmMain.Supervisor) or (frmMain.Cajero);
  btdesembolso.Enabled := (frmMain.Supervisor);
  //if frmPOS.QFactura.Active then
  //   btunifmesa.Enabled := frmPOS.QFacturaMesaID.AsInteger <> 0;
end;

procedure TfrmOpciones.ImpDesembolso;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos, a : integer;
  Msg1, Msg2, Msg3, Msg4, Puerto, Forma, ImpItbis, lbItbis : String;
begin
  if not FileExists( 'puerto.ini') then
  begin
    assignfile(arch,  'puerto.ini');
    rewrite(arch);
    writeln(arch,'PRN');
  end
  else
  begin
    assignfile(arch, 'puerto.ini');
    reset(arch);
    readln(arch, Puerto);
  end;
  closefile(arch);

  assignfile(arch, 'imp.bat');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, 'type '+ 'des.txt > '+Puerto);
  closefile(arch);

  assignfile(arch, 'des.txt');
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
  writeln(arch, dm.centro('*** D E S E M B O L S O ***'));
  writeln(arch, ' ');

  writeln(arch, 'Fecha .: '+DateToStr(Date)+' Desembolso: '+formatfloat('0000000000',dm.Query1.FieldByName('DesembolsoID').AsFloat));
  writeln(arch, 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(Now));
  writeln(arch, 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+frmPOS.lbusuario.Caption);
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, 'CONCEPTO: '+dm.Query1.FieldByName('concepto').AsString);
  writeln(arch, 'MONTO   : $'+format('%n',[dm.Query1.FieldByName('monto').AsFloat]));
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, '__________________________________');
  writeln(arch, frmPOS.lbusuario.Caption);
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, '__________________________________');
  writeln(arch, 'Supervisor');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');

  closefile(Arch);
  winexec(pchar( 'imp.bat'),0);
end;

procedure TfrmOpciones.btunifmesaClick(Sender: TObject);
begin
  Application.CreateForm(TfrmUnifMesa, frmUnifMesa);
    with frmUnifMesa.QFacturas,SQL do
      begin
        Close;
        Clear;
        Add('select f.FacturaID, f.Fecha, m.Nombre, f.Total, f.CajeroID, f.CajaID, f.unificada, f.MesaID');
        Add('from Factura_restbar f left outer join Mesas m on (f.MesaID = m.MesaID)');
        Add('where f.Hold = 1 and (f.CajeroID = :caj or f.CajeroID = 0)');
        Add('and f.CajaID = :caja');
        Add('and f.FacturaID <> :FID');
        Add('order by f.Fecha'); 
        Parameters.ParamByName('FID').Value  := frmPOS.QFacturaFacturaID.Value;
        Parameters.ParamByName('caj').Value  := frmMain.Usuario;
        Parameters.ParamByName('caja').Value := 1;
        Open;
        frmUnifMesa.QDetalle.Open;
    end;

    frmUnifMesa.ShowModal;
    If frmUnifMesa.Acepto = 1 then
       begin
         close;
       end;
{    if frmUnifMesa.Acepto = 1 then
    begin
      Totaliza := False;

      QFactura.Close;
      QFactura.Parameters.ParamByName('caj').Value  := frmHold.QFacturasCajeroID.Value;
      QFactura.Parameters.ParamByName('fac').Value  := frmHold.QFacturasFacturaID.Value;
      QFactura.Parameters.ParamByName('caja').Value := 1;
      QFactura.Open;
      ckItbis   := QFacturaConItbis.Value;
      ckPropina := QFacturaConPropina.Value;

      QDetalle.Close;
      QDetalle.Parameters.ParamByName('caj').Value  := frmHold.QFacturasCajeroID.Value;
      QDetalle.Parameters.ParamByName('fac').Value  := frmHold.QFacturasFacturaID.Value;
      QDetalle.Parameters.ParamByName('caja').Value := 1;
      QDetalle.Open;

      QForma.Close;
      QForma.Parameters.ParamByName('caj').Value  := frmHold.QFacturasCajeroID.Value;
      QForma.Parameters.ParamByName('fac').Value  := frmHold.QFacturasFacturaID.Value;
      QForma.Parameters.ParamByName('caja').Value := 1;
      QForma.Open;

      QIngredientes.Open;

      TipoNCF := QFacturaTipoNCF.Value;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select Nombre from NCF where Tipo = :tip');
      dm.Query1.Parameters.ParamByName('tip').Value := TipoNCF;
      dm.Query1.Open;

      razon_social := QFacturaNombre.Value;
      rnc := QFacturarnc.Value;

      lbrnc.Caption  := dm.Query1.FieldbyName('Nombre').AsString + #13 +
          razon_social + #13 + rnc;

      if QFacturaMesaID.Value > 0 then
        lbmesa.Caption := 'ATENDIENDO MESA #' + frmHold.QFacturasNombre.Value
      else
        lbmesa.Caption := 'FACTURA DIRECTA';

      Totaliza := True;
      Totalizar;

      edproducto.SetFocus;
    end;
  end; //}
//fernando
end;

procedure TfrmOpciones.btDividirCuentaClick(Sender: TObject);
begin
{  if frmPOS.Total > 0 then
  begin
    Application.CreateForm(TfrmDividirPago, frmDividirPago);
    frmDividirPago.Facturo    := 0;
    frmDividirPago.vCajeroID  := frmPOS.QFacturaCajeroID.Value;
    frmDividirPago.vFacturaID := frmPOS.QFacturaFacturaID.Value;
    frmDividirPago.vCajaID    := frmPOS.QFacturaCajaID.Value;
    frmDividirPago.vTipoNCF   := frmPOS.QFacturaTipoNCF.Value;
    frmDividirPago.QDetalle.Close;
    frmDividirPago.QDetalle.Parameters.ParamByName('caj').Value  := frmDividirPago.vCajeroID;
    frmDividirPago.QDetalle.Parameters.ParamByName('fac').Value  := frmDividirPago.vFacturaID;
    frmDividirPago.QDetalle.Parameters.ParamByName('caja').Value := frmDividirPago.vCajaID;
    frmDividirPago.QDetalle.Open;
    frmDividirPago.qCuenta.Close;
    frmDividirPago.qCuenta.Parameters.ParamByName('CajeroID').Value  := frmDividirPago.vCajeroID;
    frmDividirPago.qCuenta.Parameters.ParamByName('FacturaID').Value  := frmDividirPago.vFacturaID;
    frmDividirPago.qCuenta.Parameters.ParamByName('CajaID').Value := frmDividirPago.vCajaID;
    frmDividirPago.qCuenta.Open;
    frmDividirPago.ShowModal;

    if frmDividirPago.Facturo = 1 then
    Begin {20170421}
 {     frmPOS.QFactura.Edit;
      frmPOS.QFacturaHold.Value    := True;
      frmPOS.QFacturarnc.Value     := frmPOS.rnc;
      frmPOS.QFacturaNombre.Value  := frmPOS.razon_social;
      frmPOS.QFacturaTipoNCF.Value := frmPOS.TipoNCF;
      frmPOS.lbmesa.Caption        := 'FACTURA DIRECTA';
      frmPOS.QFacturaConItbis.AsBoolean   := frmPOS.ckItbis;
      frmPOS.QFacturaConPropina.AsBoolean := frmPOS.ckPropina;
      frmPOS.QFacturaimprimeNCF.AsBoolean := frmPOS.ckNCF;
      frmPOS.QFactura.Post;
      frmPOS.IniTicket;
    end;


    frmPOS.edproducto.SetFocus;
    close;
  end;}
end;

procedure TfrmOpciones.SpeedButton4Click(Sender: TObject);
begin
if (frmPOS.QFactura.Active)and(frmPOS.QFactura.RecordCount > 0) then
  if(Trim(frmPOS.lbtotal.Caption) = '0.00') and (frmPOS.QFacturaMesaID.Value <> 0) then begin
    if frmPOS.liberarMesa(frmPOS.QFacturaMesaID.AsString) then
       begin
         frmPOS.QFactura.Delete;
         frmPOS.QFactura.close;
         frmPOS.QFactura.Open;
         frmPOS.Total := 0;
         frmPOS.ckPropina := False;
         frmPOS.lbmesa.Caption := '';
       end;
    end
    else
    ShowMessage('Para liberar la mesa no deben haber productos.....');

end;

procedure TfrmOpciones.SpeedButton3Click(Sender: TObject);
begin
IF MessageDlg('Desea liberar todas las facturas en Hold que no tienen montos?',mtConfirmation,[mbYes,mbno],0)=mryes then begin
DM.ADOBar.Execute('UPDATE MESAS SET ESTATUS = '+QuotedStr('DISP')+' WHERE MESAID IN (SELECT MESAID FROM factura_restbar where estatus = ''ABI'' AND TOTAL = 0)');
DM.ADOBar.Execute('DELETE factura_restbar where estatus = ''ABI'' AND TOTAL = 0');
end;
with frmPOS do begin
TExento    := 0;
      TItbis     := 0;
      TPropina   := 0;
      TGrabado   := 0;
      TDescuento := 0;
      Total      := 0;
      ckPropina  := False;
      ckItbis    := true;

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
end;

procedure TfrmOpciones.ImpTicketNew;
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8, s9 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento, MPagado : Double;
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

  if not frmBuscaFactura.QFacturamesaid.Value > 0 then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    dm.Query1.SQL.Add('from Mesas m, Areas a');
    dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
    dm.Query1.SQL.Add('and m.mesaid = :cod');
    dm.Query1.SQL.Add('order by m.MesaID');
    dm.Query1.Parameters.ParamByName('cod').Value := frmBuscaFactura.QFacturamesaid.Value;
    dm.Query1.Open;

    writeln(arch,'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
  end;

  if frmBuscaFactura.QForma.RecordCount > 0 then
  begin
    writeln(arch, dm.centro('*** F A C T U R A ***'));
    if frmBuscaFactura.QFacturaCredito.Value then
       writeln(arch, dm.centro('* C R E D I T O *'));

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
    dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
    dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
    dm.Query1.Parameters.ParamByName('tipo').Value := frmBuscaFactura.QFacturaTipoNCF.Value;
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

  writeln(arch, 'Fecha .: '+DateToStr(Date)+' Factura: '+formatfloat('0000000000',frmBuscaFactura.QFacturaFacturaID.value));
  writeln(arch, 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(Now));
  writeln(arch, 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+dm.query1.fieldbyname('Nombre').asstring);

  if not frmBuscaFactura.QFacturamesaid.IsNull then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    dm.Query1.SQL.Add('from Mesas m, Areas a');
    dm.Query1.SQL.Add('where m.AreaID = a.AreaID');
    dm.Query1.SQL.Add('and m.mesaid = :cod');
    dm.Query1.SQL.Add('order by m.MesaID');
    dm.Query1.Parameters.ParamByName('cod').Value := frmBuscaFactura.QFacturamesaid.Value;
    dm.Query1.Open;

    writeln(arch, 'Mesa ..: '+dm.Query1.FieldByName('nombre').AsString+', '+dm.Query1.FieldByName('Area').AsString);
  end;

  if frmBuscaFactura.QFacturaCliente.Value <> '' then
  begin
    writeln(arch, 'Cliente: '+frmBuscaFactura.QFacturaCliente.Value);
    if Trim(frmBuscaFactura.QFacturarnc.Value) <> '' then
      writeln(arch, 'RNC ...: '+frmBuscaFactura.QFacturarnc.Value);
  end;

  if frmBuscaFactura.QFacturaCliente.Value = '' then
  begin
    writeln(arch, 'Cliente: [CLIENTE CONTADO]');
    if Trim(frmBuscaFactura.QFacturarnc.Value) <> '' then
      writeln(arch, 'RNC ...: '+frmBuscaFactura.QFacturarnc.Value);
  end;

  if frmBuscaFactura.QFacturaNCF.Value <> '' then
    writeln(arch, 'NCF    : '+frmBuscaFactura.QFacturaNCF.Value);

  //buscar vencimiento
      with dm.Query1 do begin
      Close;
      sql.Clear;
      SQL.Add('select FechaVenc ');
      sql.Add('from NCF ');
      sql.Add('where VerificaVenc = 1');
      sql.Add('and NCF_Fijo   = LEFT(:NCF,3)');
      Parameters.ParamByName('NCF').Value        := frmBuscaFactura.QFacturaNCF.Text;
      Open;
      if not IsEmpty then
      writeln(arch,'Fecha Venc.: '+FieldByName('FechaVenc').text);
      end;
      writeln(arch,'');



  writeln(arch, '------------------------------------------');
  writeln(arch, 'CANT.       DESCRIPCION              TOTAL');
  writeln(arch, '------------------------------------------');
  TFac := 0;
  MontoItbis := 0;
  frmBuscaFactura.QDetalle.DisableControls;
  frmBuscaFactura.QDetalle.First;
  while not frmBuscaFactura.QDetalle.eof do
  begin
    s := '';
    FillChar(s, 5-length(FormatCurr('#,0.00',frmBuscaFactura.QDetalleCantidad.value)),' ');
    s1 := '';
    FillChar(s1, 12-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QDetalleValor.value))), ' ');
    s2 := '';
    FillChar(s2, 22-length(copy(trim(frmBuscaFactura.QDetalleNombre.value),1,22)),' ');
    s3 := '';
    FillChar(s3, 8-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QDetallePrecio.value))),' ');
    s4 := '';
    FillChar(s4, 8-length(trim(FormatCurr('#,0.00',(frmBuscaFactura.QDetallePrecio.value * frmBuscaFactura.QDetalleCantidad.Value)))),' ');

    if frmBuscaFactura.QDetalleItbis.value then
      lbitbis := 'G'
    else
      lbitbis := 'E';
    IF frmBuscaFactura.QDetalleIngrediente.Value then begin {fernando}
       IF frmBuscaFactura.QDetalleVisualizar.Value then
       writeln(arch, s+FormatCurr('#,0.00',frmBuscaFactura.QDetalleCantidad.value)+' '+
                  lbitbis+' '+copy(trim(frmBuscaFactura.QDetalleNombre.value),1,22)+s2+s1+FormatCurr('#,0.00',frmBuscaFactura.QDetalleSubTotal.value));
       end
    else
       writeln(arch, s+FormatCurr('#,0.00',frmBuscaFactura.QDetalleCantidad.value)+' '+
                  lbitbis+' '+copy(trim(frmBuscaFactura.QDetalleNombre.value),1,22)+s2+s1+FormatCurr('#,0.00',frmBuscaFactura.QDetalleSubTotal.value));

    TFac := TFac + frmBuscaFactura.QDetalleValor.value;
    frmBuscaFactura.QDetalle.next;
  end;
  frmBuscaFactura.QDetalle.First;
  frmBuscaFactura.QDetalle.EnableControls;
  writeln(arch, '                       -------------------');
  //tCambio := Devuelta;

  s := '';
  FillChar(s, 12-length(trim(FormatCurr('#,0.00',MontoItbis-TFac))), ' ');
  s2:= '';
  FillChar(s2, 12-length(trim(FormatCurr('#,0.00',tCambio))), ' ');
  s3:= '';
  FillChar(s3, 12-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QFacturaItbis.value))), ' ');
  s4:= '';
  FillChar(s4, 12-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QFacturaTotal.value))), ' ');
  s5:= '';
  FillChar(s5, 12-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QFacturaPropina.value))), ' ');
   //fernando
  s8:= '';
  FillChar(s8, 12-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QFacturaDescuento.value))), ' ');
  s9:= '';
  FillChar(s9, 10-length(trim(FormatCurr('#,0.00',frmBuscaFactura.QDetalleSubTotal.Value))), ' ');
   //fin

  writeln(arch,'                   Sub-Total: '+s9+FormatCurr('#,0.00',frmBuscaFactura.QFacturaGrabado.value+frmBuscaFactura.QFacturaExento.Value));
  if (frmBuscaFactura.QFacturaDescuento.Value) > 0 then
     writeln(arch,'                   Descuento: '+s8+FormatCurr('#,0.00',frmBuscaFactura.QFacturaDescuento.value));
  if frmBuscaFactura.QForma.RecordCount > 0 then
  begin
    writeln(arch, ' ');
    writeln(arch,'                   Itbis    : '+s3+FormatCurr('#,0.00',frmBuscaFactura.QFacturaItbis.value));
    writeln(arch,'                   10% Ley  : '+s5+FormatCurr('#,0.00',frmBuscaFactura.QFacturaPropina.value));
    writeln(arch, ' ');
    writeln(arch,'               * * TOTAL    : '+s4+FormatCurr('#,0.00',frmBuscaFactura.QFacturaTotal.value));


///Formas de Pago Jhonattan Gomez 20191116_1123
    {writeln(arch,'                   Recibido : '+s1+FormatCurr('#,0.00',MPagado]));
    writeln(arch,'                   Cambio   : '+s2+FormatCurr('#,0.00',tCambio]));}
    qFormaPag.Close;
    qFormaPag.SQL.Clear;
    qFormaPag.SQL.Add('select forma, sum(monto) monto, isnull(sum(case when devuelta < 0 then 0 else Devuelta end),0) devuelta ');
    qFormaPag.SQL.Add('from RestBar_Factura_Forma_Pago');
    qFormaPag.SQL.Add('where FacturaID = :num and CajeroID = :Cajeroid');
    qFormaPag.SQL.Add('group by forma');
    qFormaPag.Parameters.ParamByName('num').Value := frmBuscaFactura.QFacturaFacturaID.Value;
    qFormaPag.Parameters.ParamByName('Cajeroid').Value := frmBuscaFactura.QFacturaCajeroID.Value;
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
    FillChar(s3, 12-length(trim(FormatCurr('#,0.00',qFormaPag.FieldByName('monto').Value))), ' ');
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
       MPagado :=  frmBuscaFactura.QFacturaTotal.Value;
       tCambio :=  0;
    end;

    writeln(arch,'');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)))), ' ');
      writeln(arch,'                    Dólares : '+s6+FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 12-length(trim(FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)))), ' ');
      writeln(arch,'                    Euros   : '+s7+FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)));
    end;

    if frmBuscaFactura.QFacturaCredito.Value then
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
    writeln(arch,'                    Itbis   : '+s3+FormatCurr('#,0.00',frmBuscaFactura.QFacturaItbis.value));
    writeln(arch,'                    10% Ley : '+s5+FormatCurr('#,0.00',frmBuscaFactura.QFacturaPropina.value));
//    if (QFacturaDescuento.Value > 0) then
//    writeln(arch,'                   Descuento: '+s8+FormatCurr('#,0.00',QFacturaDescuento.value));
    writeln(arch, ' ');
    writeln(arch,'               * * TOTAL    : '+s4+FormatCurr('#,0.00',frmBuscaFactura.QFacturaTotal.value));
    writeln(arch, ' ');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      s6:= '';
      FillChar(s6, 10-length(trim(FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)))), ' ');
      writeln(arch,'                    Dólares : '+s6+FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaUS.Value)));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      s7:= '';
      FillChar(s7, 10-length(trim(FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)))), ' ');
      writeln(arch,'                    Euros   : '+s7+FormatCurr('#,0.00',(frmBuscaFactura.QFacturaTotal.Value/dm.QEmpresaTasaEU.Value)));
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
  winexec(pchar({ExtractFilePath(Application.ExeName)+}'imp.bat'),0);

end;

procedure TfrmOpciones.pnabrircaja;
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
  

end;

end.

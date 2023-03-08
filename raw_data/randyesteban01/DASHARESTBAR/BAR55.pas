unit BAR55;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, DBGrids, StdCtrls, DB, ADODB, ExtCtrls;

type
  TfrmDividirPago = class(TForm)
    btclose: TSpeedButton;
    btcredito: TSpeedButton;
    btcash: TSpeedButton;
    bttarjeta: TSpeedButton;
    Panel1: TPanel;
    btPrior: TSpeedButton;
    btNext: TSpeedButton;
    QDetalle: TADOQuery;
    dsDetalle: TDataSource;
    QDetalleNombre: TWideStringField;
    QDetalleCantidad: TFloatField;
    QDetallePrecio: TBCDField;
    QDetalleItbis: TBooleanField;
    QDetalleDetalleID: TIntegerField;
    QDetalleIngrediente: TBooleanField;
    QDetalleCantidadIngredientes: TIntegerField;
    QDetalleValor: TFloatField;
    QDetalleTotalDescuento: TFloatField;
    DBGrid3: TDBGrid;
    QDetallediv_Pago: TIntegerField;
    btSeleccionar: TSpeedButton;
    btimprimir: TSpeedButton;
    btncf: TSpeedButton;
    DBGrid1: TDBGrid;
    qCuenta: TADOQuery;
    dsCuenta: TDataSource;
    qCuentadiv_Grupo: TWideStringField;
    qCuentaValor: TFloatField;
    qCuentaTotalDescuento: TFloatField;
    QDetallediv_Grupo: TWideStringField;
    QDetalleCajeroID: TIntegerField;
    QDetalleFacturaID: TIntegerField;
    QDetalleCajaID: TIntegerField;
    Memo1: TMemo;
    QFactura: TADOQuery;
    btDivision: TSpeedButton;
    btresta: TSpeedButton;
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
    procedure btcloseClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btcreditoClick(Sender: TObject);
    procedure btcashClick(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btSeleccionarClick(Sender: TObject);
    procedure btncfClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure btDivisionClick(Sender: TObject);
    procedure dsDetalleDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bttarjetaClick(Sender: TObject);
    procedure dsCuentaDataChange(Sender: TObject; Field: TField);
    procedure btrestaClick(Sender: TObject);
  private
    qTemp : TADOQuery;
    vNombUsuario, vMesa, vArea : string;
    vRnc, vRazon_social ,lbrnc : string;
    function generarGrupo(vCajeroID,vFacturaID,vCajaID : integer):string;
    Procedure ImpTicket(vBtn: TSpeedButton; div_grupo:string; vSubTotalDiv ,vDescItems:double);
    Procedure ImpCuenta(div_grupo:string; vSubTotalCta ,vDescItems:double);
  public
    Total, Monto, Devuelta : Double;
    Facturo ,vCajeroID ,vFacturaID ,vCajaID ,vTipoNCF: integer;
  end;

var
  frmDividirPago: TfrmDividirPago;

implementation

uses BAR00, BAR04, BAR32, BAR16, BAR01, BAR28, BAR30;

{$R *.dfm}

procedure TfrmDividirPago.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDividirPago.btPriorClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Bof then
  begin
    QDetalle.Prior;
    while (QDetalleIngrediente.Value) and (Not QDetalle.Bof) do
    begin
      QDetalle.Prior;
      DBGrid3CellClick(nil);
    end;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmDividirPago.btNextClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Eof then
  begin
    QDetalle.Next;
    while QDetalleIngrediente.Value do
    begin
      if Not QDetalle.Eof then
      begin
        QDetalle.Next;
        DBGrid3CellClick(nil);
      end
      else
      begin
        if QDetalleIngrediente.Value then
        begin
          btNextClick(Self);
        end;
      end;
    end;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmDividirPago.FormCreate(Sender: TObject);
begin
  QFactura.Active := true;

  qTemp := TADOQuery.Create(Self);
  qTemp.Connection := QDetalle.Connection;
  btclose.Caption       := 'F1'+#13+'SALIR';
  btSeleccionar.Caption := 'F10'+#13+'SELECCIONAR';

  btcash.Caption        := 'F4'+#13+'CASH';
  bttarjeta.Caption     := 'F5'+#13+'TARJETA';
  btcredito.Caption     := 'F6'+#13+'CREDITO';
  btimprimir.Caption    := 'F8'+#13+'CUENTA';
  btDivision.Caption    := 'F9'+#13+'CREAR'+#13+'DIVISION';
  btresta.Caption       := 'ELIMINAR'+#13+'DIVISION';
  qCuenta.Active        := true;

//Usuario
  qTemp.close;
  qTemp.SQL.clear;
  qTemp.SQL.add('select usu_nombre Nombre from usuarios');
  qTemp.SQL.add('where usu_codigo = :usu');
  qTemp.Parameters.parambyname('usu').Value := frmMain.Usuario;
  qTemp.open;
  if qTemp.IsEmpty then
     vNombUsuario := ''
  else
    vNombUsuario := qTemp.fieldbyname('Nombre').asstring;

//mesa
  if not frmPOS.QFacturamesaid.IsNull then
  begin
    qTemp.Close;
    qTemp.SQL.Clear;
    qTemp.SQL.Add('select m.MesaID, m.Nombre, a.Nombre as Area, m.Estatus');
    qTemp.SQL.Add('from Mesas m, Areas a');
    qTemp.SQL.Add('where m.AreaID = a.AreaID');
    qTemp.SQL.Add('and m.mesaid = :cod');
    qTemp.SQL.Add('order by m.MesaID');
    qTemp.Parameters.ParamByName('cod').Value := frmPOS.QFacturamesaid.Value;
    qTemp.Open;
    if qTemp.IsEmpty then
       begin
        vMesa := '';
        vArea := '';
       end
    else begin
      vMesa := qTemp.fieldbyname('Nombre').asstring;
      vArea := qTemp.fieldbyname('Area').asstring;
    end;
  end;

qTemp.close;
end;

procedure TfrmDividirPago.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f4 then btcashClick(Self);
  if key = vk_f5 then bttarjetaClick(Self);
  if key = vk_f6 then btcreditoClick(Self);
  if key = vk_f7 then btncfClick(Self);
  if key = vk_f8 then btimprimirClick(Self);
  if key = vk_f9 then btDivisionClick(Self);
  if key = vk_f10 then btSeleccionarClick(Self);
//  if key = vk_f10 then btaceptarClick(Self);
  if key = vk_f11 then btPriorClick(Self);
  if key = vk_f12 then btNextClick(Self);
end;

procedure TfrmDividirPago.btcreditoClick(Sender: TObject);
begin
  if not qCuenta.IsEmpty then  begin
     ImpTicket(TSpeedButton(Sender), qCuentadiv_Grupo.Value,qCuentaValor.Value ,qCuentaTotalDescuento.Value);
     qCuenta.Active  := false;
     qCuenta.Active  := true;
     frmPOS.QDetalle.Active := false;
     frmPOS.QDetalle.Active := true;
  end;
end;

procedure TfrmDividirPago.btcashClick(Sender: TObject);
begin
  if not qCuenta.IsEmpty then  begin
     ImpTicket(btcash, qCuentadiv_Grupo.Value,qCuentaValor.Value ,qCuentaTotalDescuento.Value);
     qCuenta.Active  := false;
     qCuenta.Active  := true;
     frmPOS.QDetalle.Active := false;
     frmPOS.QDetalle.Active := true;
  end;
end;

procedure TfrmDividirPago.DBGrid3CellClick(Column: TColumn);
begin
  if Column.FieldName = 'div_Pago' then
  begin
    QDetalle.Edit;
    if QDetalle.FindField('div_Pago').AsInteger = 1 then
       QDetalle.FindField('div_Pago').AsInteger := 0
    else
       QDetalle.FindField('div_Pago').AsInteger := 1;
    QDetalle.Post;
    DBGrid3.Refresh; // quizás más bien un Repaint.... pero en fin.
  end;
  DBGrid3.SelectedIndex :=0;
end;

procedure TfrmDividirPago.DBGrid3DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Check: Integer;
  R: TRect;
begin
  if Column.FieldName = 'div_Pago' then
  begin
    DBGrid3.Canvas.FillRect(Rect);
    Check := 0;
    if QDetalle.FindField('div_Pago').AsInteger = 1 then Check := DFCS_CHECKED;
    R:=Rect;
    InflateRect(R,-2,-2); //Disminuye el tamaño del CheckBox
    DrawFrameControl(DBGrid3.Canvas.Handle,R,DFC_BUTTON, DFCS_BUTTONCHECK or Check);
  end;   
end;

procedure TfrmDividirPago.btSeleccionarClick(Sender: TObject);
begin
  DBGrid3CellClick(DBGrid3.Columns[3]);
end;

procedure TfrmDividirPago.btncfClick(Sender: TObject);
begin
  Application.CreateForm(TfrmNCF, frmNCF);
  frmNCF.ShowModal;
  if frmNCF.Acepto = 1 then
  begin
    vTipoNCF := frmNCF.Comprobante;
    vRazon_social := frmNCF.nombre;
    vRnc := frmNCF.rnc;
    frmNCF.Release;
{
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select nombre from ncf where tipo = :cod');
    dm.Query1.Parameters.ParamByName('cod').Value := vTipoNCF;
    dm.Query1.Open;
    lbrnc := dm.Query1.FieldByName('nombre').AsString + #13 +
      vRazon_social + #13 + vRnc;  //}
  end;
end;

procedure TfrmDividirPago.btimprimirClick(Sender: TObject);
begin
  if not qCuenta.IsEmpty then
     ImpCuenta(qCuentadiv_Grupo.Value,qCuentaValor.Value ,qCuentaTotalDescuento.Value);
end;

function TfrmDividirPago.generarGrupo(vCajeroID, vFacturaID,
  vCajaID: integer): string;
begin
  Result :='';
  with qTemp,sql do
    begin
      Close;
      Clear;
      Add('select count(div_Grupo) as nombre from Factura_Items');
      Add('Where CajeroID  = '+IntToStr(vCajeroID));
      Add('  and FacturaID = '+IntToStr(vFacturaID));
      Add('  and CajaID    = '+IntToStr(vCajaID));
      Add('group by div_Grupo');
      Open;
      if not IsEmpty then
         Result := 'division-'+IntToStr(RecordCount);
      Close;
    end;
end;

procedure TfrmDividirPago.ImpCuenta(div_grupo: string; vSubTotalCta ,vDescItems:double);
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6 : array[0..100] of char;
  a, NoDivision : integer;
  Puerto, lbItbis : String;
  TGrabado, TExento ,vMontoItbis ,vDescGlobal ,vTPropina ,vTotalFact
  ,vTDivDetalle ,vTFac ,vUsd ,vEur : Double;
begin
  NoDivision := StrToInt(copy(div_grupo,10,Length(div_grupo))); //NoDivision := StrToInt(copy(qCuentadiv_Grupo.AsString,10,Length(qCuentadiv_Grupo.AsString)));
  
  if not FileExists('puerto.ini') then
  begin
    assignfile(arch, 'puerto.ini');
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

  assignfile(arch,'imp.bat');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, 'type '+'fac.txt > '+Puerto);
  closefile(arch);

  assignfile(arch,'fac.txt');
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

  writeln(arch, dm.centro('*** C U E N T A ***'));

  writeln(arch, ' ');
  writeln(arch, 'Fecha .: '+DateToStr(Date)+' Factura: '+formatfloat('0000000000',frmPOS.QFacturaFacturaID.value)+'-'+inttostr(NoDivision));
  writeln(arch, 'Caja ..: '+formatfloat('000',strtofloat('1'))+'        Hora ..: '+timetostr(Now));
  writeln(arch, 'Cajero : '+formatfloat('000',frmMain.Usuario)+' '+vNombUsuario);

//mesa
  writeln(arch, 'Mesa ..: '+vMesa+', '+vArea);
  
  writeln(arch, '----------------------------------------');
  writeln(arch, 'CANT.       DESCRIPCION            TOTAL');
  writeln(arch, '----------------------------------------');
  vTDivDetalle:= 0;
  vTFac       := 0;
  vMontoItbis := 0;
  vTPropina   := 0;
  vTotalFact  := 0;
  frmPOS.QDetalle.DisableControls;
  frmPOS.QDetalle.First;
  while not frmPOS.QDetalle.eof do
  begin
{1} if frmPOS.QDetallediv_grupo.Value = div_grupo then
       begin
        s := '';
        FillChar(s, 5-length(format('%n',[frmPOS.QDetalleCantidad.value])),' ');
        s1 := '';
        FillChar(s1, 10-length(trim(FORMAT('%n',[frmPOS.QDetalleValor.value]))), ' ');
        s2 := '';
        FillChar(s2, 22-length(copy(trim(frmPOS.QDetalleNombre.value),1,22)),' ');
        s3 := '';
        FillChar(s3, 8-length(trim(FORMAT('%n',[frmPOS.QDetallePrecio.value]))),' ');
        s4 := '';
        FillChar(s4, 8-length(trim(FORMAT('%n',[frmPOS.QDetallePrecio.value * frmPOS.QDetalleCantidad.Value]))),' ');
        if frmPOS.QDetalleItbis.value then
           lbitbis := 'G'
        else
           lbitbis := 'E';

       IF frmPOS.QDetalleIngrediente.AsBoolean then begin //fernando
         IF frmPOS.QDetalleVisualizar.AsBoolean then
            writeln(arch, s+format('%n',[frmPOS.QDetalleCantidad.value])+' '+
                                        lbitbis+' '+copy(trim(frmPOS.QDetalleNombre.value),1,22)+s2+s1+format('%n',[frmPOS.QDetalleValor.value]));
           end
       else begin
         writeln(arch, s+format('%n',[frmPOS.QDetalleCantidad.value])+' '+
                                     lbitbis+' '+copy(trim(frmPOS.QDetalleNombre.value),1,22)+s2+s1+format('%n',[frmPOS.QDetalleValor.value]));
         if frmPOS.QDetalleItbis.Value then
            TGrabado := TGrabado + (frmPOS.QDetalleCantidad.Value * (frmPOS.QDetallePrecio.Value - frmPOS.QDetalleTotalDescuento.Value))
         else
            TExento  := TExento  + (frmPOS.QDetalleCantidad.Value * (frmPOS.QDetallePrecio.Value - frmPOS.QDetalleTotalDescuento.Value));

         end;
       vTDivDetalle := vTDivDetalle + frmPOS.QDetalleValor.value;

    end;
    frmPOS.QDetalle.next;
  end;   //end if 1

  frmPOS.QDetalle.First;
  frmPOS.QDetalle.EnableControls;

  with qTemp,sql do
    begin
      Close;
      Clear;
      Add('select sum(Cantidad * Precio) as Valor from Factura_Items');
      Add('Where CajeroID  = '+IntToStr(vCajeroID));
      Add('  and FacturaID = '+IntToStr(vFacturaID));
      Add('  and CajaID    = '+IntToStr(vCajaID));
      Add('');
      Open;
      if not IsEmpty then begin
         vTFac := Fields[0].Value;
      Close;
    end;
{    if frmPOS.QFacturaDecuentoGlobal.Value then begin
       vDescuento := vSubTotalDiv * (frmPOS.QFacturaDescuento.Value / vSubTotalFact);
       vMontoItbis:= ((vSubTotalDiv - vDescuento) * dm.QEmpresaItbis.Value)/100.0;
       vTPropina  := ((vSubTotalDiv - vDescuento) * dm.QEmpresaPropina.Value)/100.0;
       end
    else begin
       vDescuento := vDescItems;
       vMontoItbis:= (TGrabado * dm.QEmpresaItbis.Value)/100.0;
       vTPropina  := ((TGrabado + TExento) * dm.QEmpresaPropina.Value)/100.0;
       end;
    vTotalFact := vSubTotalDiv+vMontoItbis+vTPropina+vDescuento;
}
    if frmPOS.QFacturaDecuentoGlobal.Value then begin
       vDescGlobal:= vSubTotalCta * (frmPOS.QFacturaDescuento.Value / vTFac);
       vMontoItbis:= ((vSubTotalCta - vDescGlobal) * dm.QEmpresaItbis.Value)/100.0;
       vTPropina  := ((vSubTotalCta - vDescGlobal) * dm.QEmpresaPropina.Value)/100.0;
       end
    else begin
       vDescGlobal:= vDescItems;
       vMontoItbis:= (TGrabado * dm.QEmpresaItbis.Value)/100.0;
       vTPropina  := ((TGrabado + TExento) * dm.QEmpresaPropina.Value)/100.0;
       end;
    vTotalFact := vSubTotalCta+vMontoItbis+vTPropina+vDescGlobal;
    writeln(arch, '                       -----------------');

//------------formatos----------feramac ------
    s:= '';
    FillChar(s, 10-length(trim(FORMAT('%n',[vMontoItbis]))), ' ');
    s1:= '';
    FillChar(s1, 10-length(trim(FORMAT('%n',[vTotalFact]))), ' ');
    s2:= '';
    FillChar(s2, 10-length(trim(FORMAT('%n',[vTPropina]))), ' ');
    s3:= '';
    FillChar(s3, 10-length(trim(FORMAT('%n',[vDescGlobal]))), ' ');
    s4:= '';
    FillChar(s4, 10-length(trim(FORMAT('%n',[vSubTotalCta]))), ' ');
// -------------fin de los formatos -----------

    writeln(arch,'                   Sub-Total: '+s4+format('%n',[vSubTotalCta]));
    writeln(arch, ' ');
    writeln(arch,'                    Itbis   : '+s +format('%n',[vMontoItbis]));
    writeln(arch,'                    10% Ley : '+s2+format('%n',[vTPropina]));
    if (vDescGlobal > 0) then
    writeln(arch,'                   Descuento: '+s3+format('%n',[vDescGlobal]));
    writeln(arch, ' ');
    writeln(arch,'                   Total    : '+s1+format('%n',[vTotalFact]));
    writeln(arch, ' ');
    if dm.QEmpresaTasaUS.Value > 0 then
    begin
      vUsd := vTotalFact/dm.QEmpresaTasaUS.Value;
      s5:= '';
      FillChar(s5, 10-length(trim(FORMAT('%n',[vUsd]))), ' ');
      writeln(arch,'                    Dólares : '+s5+format('%n',[vUsd]));
    end;

    if dm.QEmpresaTasaEU.Value > 0 then
    begin
      vEur := vTotalFact/dm.QEmpresaTasaEU.Value;
      s6:= '';
      FillChar(s6, 10-length(trim(FORMAT('%n',[vEur]))), ' ');
      writeln(arch,'                    Euros   : '+s6+format('%n',[vEur]));
    end;

  writeln(arch, ' ');

  writeln(arch, dm.centro(dm.QEmpresaMensaje1.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje2.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje3.AsString));
  writeln(arch, dm.centro(dm.QEmpresaMensaje4.AsString));
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  //Corta el papel
  if not VarIsNull(dm.QEmpresaCortapapel.asString) then
    writeln(arch,dm.QEmpresaCortapapel.asString);
  closefile(Arch);
  winexec(pchar('imp.bat'),0);
  end; //end while
end;

procedure TfrmDividirPago.btDivisionClick(Sender: TObject);
var nombreGrupo : string;
begin
  if not QDetalle.IsEmpty then
     begin
       nombreGrupo := generarGrupo(QDetalle.Parameters.ParamByName('caj').Value,
                                   QDetalle.Parameters.ParamByName('fac').Value,
                                   QDetalle.Parameters.ParamByName('caja').Value);
       QDetalle.DisableControls;
       QDetalle.First;
       while not QDetalle.Eof do begin
       if QDetallediv_Pago.Value =1 then
          begin
            QDetalle.Edit;
            QDetallediv_Grupo.Value := nombreGrupo;
            QDetalle.Post;
          end;
          QDetalle.Next;
       end;
       QDetalle.First;
       QDetalle.EnableControls;
       QDetalle.UpdateBatch;
  end;
  QDetalle.Active := false;
  QDetalle.Active := true;
  qCuenta.Active  := false;
  qCuenta.Active  := true;
  frmPOS.QDetalle.Active := false;
    frmPOS.QDetalle.Parameters.ParamByName('caj').Value := vCajeroID;
    frmPOS.QDetalle.Parameters.ParamByName('fac').Value := vFacturaID;
    frmPOS.QDetalle.Parameters.ParamByName('caja').Value := vCajaID;
  frmPOS.QDetalle.Active := true;
  DBGrid1.SetFocus;
end;

procedure TfrmDividirPago.dsDetalleDataChange(Sender: TObject;
  Field: TField);
begin
  btDivision.Enabled := not dsDetalle.DataSet.IsEmpty;
end;

procedure TfrmDividirPago.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qTemp.Free;
  if qCuenta.RecordCount = 0 then Facturo := 0 ELSE Facturo:= 1;
end;

procedure TfrmDividirPago.ImpTicket(vBtn: TSpeedButton; div_grupo: string;
  vSubTotalDiv ,vDescItems: double);
  var
  arch, ptocaja : textfile;
  a : integer;
  s ,s1 ,s2 ,s3 ,s4 ,s5 ,s6 ,s7 ,s8 ,s9 : array[0..100] of char;
  Puerto ,lbitbis : string;
  vDescuento ,vSubTotalFact ,vMontoItbis ,vTPropina ,TGrabado ,TExento ,vTotalFact
    ,MPagado ,vUsd ,vEur , vMonto ,vDevuelta: double;
begin
  frmPOS.QDetalle.DisableControls;
  frmPOS.QDetalle.First;
  while not frmPOS.QDetalle.eof do
  begin
    if frmPOS.QDetallediv_grupo.Value = div_grupo then
       begin
         if frmPOS.QDetalleItbis.Value then
            TGrabado := TGrabado + (frmPOS.QDetalleCantidad.Value * (frmPOS.QDetallePrecio.Value - frmPOS.QDetalleTotalDescuento.Value))
         else
            TExento  := TExento  + (frmPOS.QDetalleCantidad.Value * (frmPOS.QDetallePrecio.Value - frmPOS.QDetalleTotalDescuento.Value));
       end;
    frmPOS.QDetalle.Next;
  end;
  frmPOS.QDetalle.First;
  frmPOS.QDetalle.EnableControls;

  with qTemp,sql do
    begin
      Close;
      Clear;
      Add('select sum(Cantidad * Precio) as Valor from Factura_Items');
      Add('Where CajeroID  = '+IntToStr(vCajeroID));
      Add('  and FacturaID = '+IntToStr(vFacturaID));
      Add('  and CajaID    = '+IntToStr(vCajaID));
      Open;
      if not IsEmpty then
         vSubTotalFact := Fields[0].Value;
      Close;
    end;

    if frmPOS.QFacturaDecuentoGlobal.Value then begin
       vDescuento := vSubTotalDiv * (frmPOS.QFacturaDescuento.Value / vSubTotalFact);
       vMontoItbis:= ((vSubTotalDiv - vDescuento) * dm.QEmpresaItbis.Value)/100.0;
       vTPropina  := ((vSubTotalDiv - vDescuento) * dm.QEmpresaPropina.Value)/100.0;
       end
    else begin
       vDescuento := vDescItems;
       vMontoItbis:= (TGrabado * dm.QEmpresaItbis.Value)/100.0;
       vTPropina  := ((TGrabado + TExento) * dm.QEmpresaPropina.Value)/100.0;
       end;

    vTotalFact := vSubTotalDiv+vMontoItbis+vTPropina+vDescuento;

    If vBtn = btcash then
       begin
        Application.CreateForm(tfrmCash, frmCash);
        frmCash.Total := qCuentaValor.Value;
        frmCash.Monto := 0;
        frmCash.Devuelta := frmCash.Total - frmCash.Monto;
        frmCash.lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[frmCash.Devuelta]);
        frmCash.ShowModal;
        if frmCash.Facturo = 1 then
           begin
            Facturo   := 1;
            vMonto    := frmCash.Monto;
            vDevuelta := frmCash.Devuelta;
           end;
      end;
    if vBtn = bttarjeta then
       begin
        Application.CreateForm(tfrmTarjeta, frmTarjeta);
        frmTarjeta.ShowModal;
        if frmTarjeta.Acepto = 1 then
           begin
            Facturo   := 1;
            vMonto    := qCuentaValor.Value;
            vDevuelta := 0;
           end;
       end;
    if vBtn = btcredito then
       begin
        Application.CreateForm(tfrmNombreCliente, frmNombreCliente);
        frmNombreCliente.ShowModal;
        if frmNombreCliente.Acepto = 1 then
           begin
            Facturo   := 1;
            vMonto    := 0;
            vDevuelta := 0;
           end;
       end;

    if Facturo = 1 {(frmCash.Facturo = 1) or (frmTarjeta.Acepto = 1) or (frmNombreCliente.Acepto = 1)} then
    begin{1}
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select max(FacturaID) as maximo');
      dm.Query1.SQL.Add('from Factura_RestBar');
      dm.Query1.SQL.Add('where CajaID = 1');
      dm.Query1.Open;

      IF (qCuenta.RecordCount = 1)  then
         begin
          QFactura.Close;
          QFactura.Parameters.ParamByName('caj').Value  := frmPOS.QFacturaCajeroID.Value;
          QFactura.Parameters.ParamByName('fac').Value  := frmPOS.QFacturaFacturaID.Value;
          QFactura.Parameters.ParamByName('caja').Value := frmPOS.QFacturaCajaID.Value;
          QFactura.Open;
          QFactura.Edit;
         end
      else begin
        QFactura.Append;
        QFacturaFacturaID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
        QFacturanota.Value := trim(QFacturanota.Value)+' - No.Factura : '+frmPOS.QFacturaFacturaID.AsString
                                                      +' - '+div_grupo;
      end;
      QFacturaHold.Value      := False;
      QFacturaEstatus.Value   := 'FAC';
            //Buscando comprobante
      QFacturaTipoNCF.Value   := vTipoNCF;
      if vTipoNCF = 1 then
         QFacturarnc.Clear
      else
         QFacturarnc.Value    := vRnc;

      QFacturaNombre.Value    := vRazon_social;
      QFacturaHora.Value      := Now;
      QFacturaFecha.Value     := Date;
      QFacturaConItbis.Value   := frmPOS.QFacturaConItbis.Value;
      QFacturaConPropina.Value := frmPOS.QFacturaConPropina.Value;
      QFacturaimprimeNCF.Value := frmPOS.QFacturaimprimeNCF.Value;
      if QFacturaimprimeNCF.Value then
      begin
      frmPOS.qNCFAdm.Close;
      frmPOS.qNCFAdm.Parameters.ParamByName('tipo').Value := vTipoNCF;
      frmPOS.qNCFAdm.Parameters.ParamByName('emp').Value  := DM.QEmpresaEmpresaID.Value;
      frmPOS.qNCFAdm.Open;
      if frmPOS.qNCFAdm.RecordCount > 0 then
      begin
        QFacturaNCF.Value := frmPOS.qNCFAdm.FieldByName('NCF').Value + FormatFloat('00000000', frmPOS.qNCFAdm.FieldByName('Sec').AsInteger);

      DM.ADOBar.Execute('update NCF set NCF_Secuencia = NCF_Secuencia + 1 where ncf_fijo = case when '+IntToStr(vTipoNCF)+' = 1 then ''B02'''+
                                                                                            'when '+IntToStr(vTipoNCF)+' = 2 then ''B01'''+
                                                                                            'when '+IntToStr(vTipoNCF)+' = 3 then ''B15'''+
                                                                                            'when '+IntToStr(vTipoNCF)+' = 4 then ''B14'' end '+
                                                                                            'and emp_codigo ='+IntToStr(DM.QEmpresaEmpresaID.Value));
      end;
      end;
      QFacturaCajeroID.Value   := frmMain.Usuario;
      QFacturaExento.Value     := TExento;
      QFacturaGrabado.Value    := TGrabado;
      QFacturaItbis.Value      := vMontoItbis;
      QFacturaPropina.Value    := vTPropina;
      QFacturaTotal.Value      := vTotalFact;
      QFacturaLlevar.Value     := frmPOS.QFacturaLlevar.Value;
      if vBtn = btcredito then
         begin
          QFacturaCredito.Value := True;
          QFacturaNombre.Value  := frmNombreCliente.edcliente.Text;
         end
      else
        QFacturaCredito.Value  := false;
      QFacturaPagado.Value     := vMonto;
      QFacturaDescuento.Value  := vDescuento;
      QFacturaCajaID.Value     := frmPOS.QFacturaCajaID.Value;
      QFacturamesaid.Value     := frmPOS.QFacturaMesaID.Value;
      QFacturaimprimeNCF.Value := frmPOS.QFacturaimprimeNCF.Value;
      QFacturaDecuentoGlobal.Value:= frmPOS.QFacturaDecuentoGlobal.Value;
      QFacturaUnificada.Value  := frmPOS.QFacturaUnificada.Value;
      if qCuenta.RecordCount = 0 then begin
      QFacturaHold.Value    := False;
      QFacturaEstatus.Value := 'FAC';
      end;
      QFactura.Post;
      QFactura.UpdateBatch;

      frmPOS.QDetalle.DisableControls;
      frmPOS.QDetalle.First;
      while not frmPOS.QDetalle.Eof do begin
        if  frmPOS.QDetallediv_grupo.asstring = div_grupo then
            begin
              IF (qCuenta.RecordCount = 1) and (QDetalle.RecordCount = 0) then
                 frmPOS.Totaliza := false
              else
                frmPOS.Totaliza := true;
              frmPOS.QDetalle.Edit;
              frmPOS.QDetalleCajeroID.Value := frmMain.Usuario;
              frmPOS.QDetalleFacturaID.Value:= QFacturaFacturaID.Value;
              frmPOS.QDetalleCajaID.Value   := QFacturaCajaID.Value;
              frmPOS.QDetalle.Post;
            end;
        frmPOS.QDetalle.Next;
      end;
      frmPOS.QDetalle.First;
      frmPOS.QDetalle.EnableControls;
      frmPOS.QDetalle.UpdateBatch;
      frmPOS.QDetalle.Active := false;
      frmPOS.QDetalle.Active := true;

      //Insertando Forma de Pago
      if vBtn = btcash then
         begin
          frmPOS.QForma.Insert;
          frmPOS.QFormaCajeroID.Value  := QFacturaCajeroID.Value;
          frmPOS.QFormaFacturaID.Value := QFacturaFacturaID.Value;
          frmPOS.QFormaCajaID.Value    := QFacturaCajaID.Value;
          frmPOS.QFormaDetalleID.Value := 1;
          frmPOS.QFormaMonto.Value     := vMonto;
          frmPOS.QFormaDevuelta.Value  := vDevuelta;
          frmPOS.QFormaForma.Value     := 'Efectivo';
          frmPOS.QForma.Post;
          frmPOS.QForma.UpdateBatch;
         end;

      if vBtn = bttarjeta then
         begin{1}
          frmPOS.QForma.Insert;
          frmPOS.QFormaCajeroID.Value  := QFacturaCajeroID.Value;
          frmPOS.QFormaFacturaID.Value := QFacturaFacturaID.Value;
          frmPOS.QFormaCajaID.Value    := QFacturaCajaID.Value;
          frmPOS.QFormaDetalleID.Value := 1;
          frmPOS.QFormaMonto.Value     := vMonto;
          frmPOS.QFormaDevuelta.Value  := vDevuelta;
          frmPOS.QFormaForma.Value     := 'Tarjeta';
          frmPOS.QFormaTipo_Tarjeta.Value   := frmTarjeta.ComboBox1.Text;
          frmPOS.QFormaAutorizacion.Value   := frmTarjeta.edautorizacion.Text;
          frmPOS.QFormaNumero_Tarjeta.Value := frmTarjeta.edtarjeta.Text;
          frmPOS.QFormaBanco.Value          := frmTarjeta.DBLookupComboBox1.Text;
          frmPOS.QForma.Post;
          frmPOS.QForma.UpdateBatch;
         end;

       if vBtn = btcredito then
         begin{1}
          frmPOS.QForma.Insert;
          frmPOS.QFormaCajeroID.Value  := QFacturaCajeroID.Value;
          frmPOS.QFormaFacturaID.Value := QFacturaFacturaID.Value;
          frmPOS.QFormaCajaID.Value    := QFacturaCajaID.Value;
          frmPOS.QFormaDetalleID.Value := 1;
          frmPOS.QFormaMonto.Value     := vMonto;
          frmPOS.QFormaDevuelta.Value  := vDevuelta;
          frmPOS.QFormaForma.Value     := 'Credito';
          frmPOS.QForma.Post;
          frmPOS.QForma.UpdateBatch;
         end;{1} 
      MPagado  := vMonto;
      Devuelta := vDevuelta;

      if (qCuenta.RecordCount = 1) and (QDetalle.RecordCount = 0) then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
      end;

      if (qCuenta.RecordCount = 1) and (QDetalle.RecordCount = 0) then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
      end;

   

//------------------la impresion de la fact----------------------------------------------------------
  if not FileExists('puerto.ini') then
  begin
    assignfile(arch, 'puerto.ini');
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

  assignfile(arch,'imp.bat');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, 'type '+'fac.txt > '+Puerto);
  closefile(arch);

  assignfile(arch,'fac.txt');
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

{2}if frmPOS.QForma.RecordCount > 0 then
  begin
    if QFacturaCredito.Value then
       writeln(arch, dm.centro('* C R E D I T O *'))
    else
       writeln(arch, dm.centro('*** F A C T U R A ***'));

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select tip_nombre Nombre from TipoNCF');
    dm.Query1.SQL.Add('where emp_codigo = :emp and tip_codigo = :tipo');
    dm.Query1.Parameters.ParamByName('emp').Value := DM.QEmpresaEmpresaID.Value;
    dm.Query1.Parameters.ParamByName('tipo').Value := QFacturaTipoNCF.Value;
    dm.Query1.Open;
    writeln(arch, dm.Centro(dm.Query1.FieldByName('Nombre').AsString));

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

  if QFacturaNCF.Value <> '' then
    writeln(arch, 'NCF    : '+QFacturaNCF.Value);
    writeln(arch, '----------------------------------------');
    writeln(arch, 'CANT.       DESCRIPCION            TOTAL');
    writeln(arch, '----------------------------------------');
//---------------------------------------
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('Select Cantidad ,(Cantidad * Precio) as Valor ,Nombre ,Precio ,Itbis ,Ingrediente ,Visualizar ,Nombre  ');
    dm.Query1.SQL.Add('From Factura_Items');
    dm.Query1.SQL.Add('Where CajeroID = :cajeroid and FacturaID = :facturaid and CajaID = :cajaid');
    dm.Query1.SQL.Add('Order by DetalleID');
    dm.Query1.Parameters.ParamByName('cajeroid').Value  := QFacturaCajeroID.Value;
    dm.Query1.Parameters.ParamByName('facturaid').Value := QFacturaFacturaID.Value;
    dm.Query1.Parameters.ParamByName('cajaid').Value    := QFacturaCajaID.Value;
    dm.Query1.Open;
//---------------------------------------
    dm.Query1.First;
    while not dm.Query1.eof do
      begin {3}
            s := '';
            FillChar(s, 5-length(format('%n',[dm.Query1.FieldByName('Cantidad').AsFloat])),' ');
            s1 := '';
            FillChar(s1, 10-length(trim(FORMAT('%n',[dm.Query1.FieldByName('valor').AsFloat]))), ' ');
            s2 := '';
            FillChar(s2, 22-length(copy(trim(dm.Query1.FieldByName('Nombre').AsString),1,22)),' ');
            s3 := '';
            FillChar(s3, 8-length(trim(FORMAT('%n',[dm.Query1.FieldByName('Precio').AsFloat]))),' ');
            s4 := '';
            FillChar(s4, 8-length(trim(FORMAT('%n',[dm.Query1.FieldByName('Precio').AsFloat * dm.Query1.FieldByName('Cantidad').AsFloat]))),' ');

            if dm.Query1.FieldByName('Itbis').AsBoolean then
               lbitbis := 'G'
            else
               lbitbis := 'E';
            IF dm.Query1.FieldByName('Ingrediente').AsBoolean then begin {fernando}
               IF dm.Query1.FieldByName('Visualizar').AsBoolean then
                  writeln(arch, s+format('%n',[dm.Query1.FieldByName('Cantidad').AsFloat])+' '+
                  lbitbis+' '+copy(trim(dm.Query1.FieldByName('Nombre').asstring),1,22)+s2+s1+format('%n',[dm.Query1.FieldByName('Valor').AsFloat]));
               end
            else
              writeln(arch, s+format('%n',[dm.Query1.FieldByName('Cantidad').AsFloat])+' '+
              lbitbis+' '+copy(trim(dm.Query1.FieldByName('Nombre').asstring),1,22)+s2+s1+format('%n',[dm.Query1.FieldByName('Valor').AsFloat]));
            dm.Query1.next;   
    end;{3}
        writeln(arch, '                       -----------------');
//        s := '';
//        FillChar(s, 10-length(trim(FORMAT('%n',[MontoItbis-TFac]))), ' ');
        s1:= '';
        FillChar(s1, 10-length(trim(FORMAT('%n',[MPagado]))), ' ');
        s2:= '';
        FillChar(s2, 10-length(trim(FORMAT('%n',[Devuelta]))), ' ');
        s3:= '';
        FillChar(s3, 10-length(trim(FORMAT('%n',[vMontoItbis]))), ' ');
        s4:= '';
        FillChar(s4, 10-length(trim(FORMAT('%n',[vTotalFact]))), ' ');
        s5:= '';
        FillChar(s5, 10-length(trim(FORMAT('%n',[vTPropina]))), ' ');
        s8:= '';
        FillChar(s8, 10-length(trim(FORMAT('%n',[vDescuento]))), ' ');
        s9:= '';
        FillChar(s9, 10-length(trim(FORMAT('%n',[vSubTotalDiv]))), ' ');

        writeln(arch,'                   Sub-Total: '+s9+format('%n',[vSubTotalDiv]));

        if frmPOS.QForma.RecordCount > 0 then
           begin
            writeln(arch, ' ');
            writeln(arch,'                   Itbis    : '+s3+format('%n',[vMontoItbis]));
            writeln(arch,'                   10% Ley  : '+s5+format('%n',[vTPropina]));
            if (QFacturaDescuento.Value) > 0 then
                writeln(arch,'                   Descuento: '+s8+format('%n',[vDescuento]));
            writeln(arch, ' ');
            writeln(arch,'                   Total    : '+s4+format('%n',[vTotalFact]));
            writeln(arch,'                   Recibido : '+s1+format('%n',[MPagado]));
            writeln(arch,'                   Cambio   : '+s2+format('%n',[vDescuento]));
            writeln(arch, ' ');
            writeln(arch, ' ');

            if dm.QEmpresaTasaUS.Value > 0 then
               begin
                vUsd := vTotalFact/dm.QEmpresaTasaUS.Value;
                s6:= '';
                FillChar(s6, 10-length(trim(FORMAT('%n',[vUsd]))), ' ');
                writeln(arch,'                    Dólares : '+s6+format('%n',[vUsd]));
               end;

            if dm.QEmpresaTasaEU.Value > 0 then
               begin
                vEur := vTotalFact/dm.QEmpresaTasaEU.Value;
                s7:= '';
                FillChar(s7, 10-length(trim(FORMAT('%n',[vEur]))), ' ');
                writeln(arch,'                    Euros   : '+s7+format('%n',[vEur]));
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

            writeln(arch, ' ');
            writeln(arch, dm.centro(dm.QEmpresaMensaje1.AsString));
            writeln(arch, dm.centro(dm.QEmpresaMensaje2.AsString));
            writeln(arch, dm.centro(dm.QEmpresaMensaje3.AsString));
            writeln(arch, dm.centro(dm.QEmpresaMensaje4.AsString));
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
            writeln(arch, ' ');
  //Corta el papel
            if not VarIsNull(dm.QEmpresaCortapapel.asString) then
               writeln(arch,dm.QEmpresaCortapapel.asString);
            closefile(Arch);
            winexec(pchar('imp.bat'),0);
  end
{2}end;
    end; {1}
end;

procedure TfrmDividirPago.bttarjetaClick(Sender: TObject);
begin
  if not qCuenta.IsEmpty then  begin
     ImpTicket(bttarjeta, qCuentadiv_Grupo.Value,qCuentaValor.Value ,qCuentaTotalDescuento.Value);
     qCuenta.Active  := false;
     qCuenta.Active  := true;
     frmPOS.QDetalle.Active := false;
     frmPOS.QDetalle.Active := true;
  end;
end;

procedure TfrmDividirPago.dsCuentaDataChange(Sender: TObject;
  Field: TField);
begin
  btcash.Enabled      := not dsCuenta.DataSet.IsEmpty;
  bttarjeta.Enabled   := not dsCuenta.DataSet.IsEmpty;
  btcredito.Enabled   := not dsCuenta.DataSet.IsEmpty;
  btimprimir.Enabled  := not dsCuenta.DataSet.IsEmpty;
  btncf.Enabled       := not dsCuenta.DataSet.IsEmpty;
end;

procedure TfrmDividirPago.btrestaClick(Sender: TObject);
var nombreGrupo : string;
begin
  nombreGrupo := qCuentadiv_Grupo.AsString;
  if (not qCuenta.IsEmpty) and (MessageDlg('Confirma eliminara la DIVISION : [ [  '+nombreGrupo+'  ] ]',mtConfirmation ,mbOKCancel,0)= mrOK) then
     begin
      with qTemp,sql do
        begin
          Close;
          Clear;
          Add('update factura_items set div_Grupo = NULL, div_Pago= 0');
          Add('Where div_Grupo  = '+QuotedStr(nombreGrupo));
          Add('  and FacturaID = '+IntToStr(vFacturaID));
          ExecSQL;
        end;
      QDetalle.Active := false;
      QDetalle.Active := true;
      qCuenta.Active  := false;
      qCuenta.Active  := true;
      frmPOS.QDetalle.Active := false;
      frmPOS.QDetalle.Parameters.ParamByName('caj').Value := vCajeroID;
      frmPOS.QDetalle.Parameters.ParamByName('fac').Value := vFacturaID;
      frmPOS.QDetalle.Parameters.ParamByName('caja').Value := vCajaID;
      frmPOS.QDetalle.Active := true;  //}
    end; 
end;

end.


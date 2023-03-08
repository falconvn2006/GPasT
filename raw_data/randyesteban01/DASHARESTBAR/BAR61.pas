unit BAR61;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, DBCtrls, StdCtrls, Buttons, ExtCtrls, Mask, Grids,
  DBGrids,DIMime;

type
  TfrmActEntradas = class(TForm)
    dsEntradas: TDataSource;
    QDetalle: TADOQuery;
    dsDetalle: TDataSource;
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Label1: TLabel;
    DBText1: TDBText;
    Label2: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    btRevisado: TSpeedButton;
    btAutorizado: TSpeedButton;
    dbtRealizado: TDBText;
    dbtRevisado: TDBText;
    dbtProveedor: TDBText;
    DBEdit2: TDBEdit;
    DBMemo1: TDBMemo;
    Panel3: TPanel;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel2: TPanel;
    btprior: TSpeedButton;
    btnext: TSpeedButton;
    btBorra: TSpeedButton;
    btbuscaproducto: TSpeedButton;
    QDetalleNombre: TWideStringField;
    QDetalleCosto: TBCDField;
    QDetalleDescuento: TBCDField;
    QDetalleItbis: TBCDField;
    DBGrid1: TDBGrid;
    QDetalleDetalleID: TAutoIncField;
    QDetalleProductoID: TIntegerField;
    QDetalleEntradaID: TIntegerField;
    btsuma: TSpeedButton;
    btresta: TSpeedButton;
    Label10: TLabel;
    DBText5: TDBText;
    QEntradas: TADOQuery;
    QEntradasEntradaID: TIntegerField;
    QEntradasFecha: TDateTimeField;
    QEntradasConcepto: TWideStringField;
    QEntradasRealizadoID: TIntegerField;
    QEntradasRealizadoPor: TWideStringField;
    QEntradasRevisadoID: TIntegerField;
    QEntradasRevisadoPor: TWideStringField;
    QEntradasProveedorID: TIntegerField;
    QEntradasProveedor: TWideStringField;
    QEntradasExento: TBCDField;
    QEntradasGrabado: TBCDField;
    QEntradasItbis: TBCDField;
    QEntradasDescuento: TBCDField;
    QEntradasTotal: TBCDField;
    QEntradasExistenciaAplicada: TBooleanField;
    QEntradassubTotal: TCurrencyField;
    QDetalleCantidad: TFloatField;
    procedure btcloseClick(Sender: TObject);
    procedure btpostClick(Sender: TObject);
    procedure QEntradas2CalcFields(DataSet: TDataSet);
    procedure dsEntradasDataChange(Sender: TObject; Field: TField);
    procedure btBorraClick(Sender: TObject);
    procedure btbuscaproductoClick(Sender: TObject);
    procedure QEntradas2NewRecord(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure btpriorClick(Sender: TObject);
    procedure btnextClick(Sender: TObject);
    procedure btsumaClick(Sender: TObject);
    procedure btRevisadoClick(Sender: TObject);
    procedure btrestaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1Exit(Sender: TObject);
    procedure btAutorizadoClick(Sender: TObject);
    procedure QEntradasCalcFields(DataSet: TDataSet);
    procedure QEntradasNewRecord(DataSet: TDataSet);
    procedure dsEntradasStateChange(Sender: TObject);
    procedure QDetalleAfterPost(DataSet: TDataSet);
    procedure QEntradasBeforePost(DataSet: TDataSet);
  private
    TExento, TItbis, TGrabado, TDescuento : Currency;
    procedure totaliza;
  public
    Grabo, vEntradaID : Integer;
    modoEdit : Boolean;
  end;

var
  frmActEntradas: TfrmActEntradas;

implementation

uses BAR14, BAR04, BAR09, BAR01, BAR62;

{$R *.dfm}

procedure TfrmActEntradas.btcloseClick(Sender: TObject);
begin
  if (modoEdit = false) and (not QDetalle.IsEmpty) then begin
     QDetalle.DisableControls;
     QDetalle.First;
     While not QDetalle.Eof do begin
       QDetalle.Delete;
       QDetalle.Next;
     end;
  end;
  QEntradas.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActEntradas.btpostClick(Sender: TObject);
begin
  if QEntradas.State in [dsedit,dsinsert] then
     QEntradas.Post;
  QEntradas.UpdateBatch;
  If QDetalle.State in [dsedit,dsInsert] then
     QDetalle.Post;
  QDetalle.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActEntradas.QEntradas2CalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('subTotal').AsCurrency := DataSet.FieldByName('Grabado').AsCurrency +DataSet.FieldByName('Exento').AsCurrency;
end;

procedure TfrmActEntradas.dsEntradasDataChange(Sender: TObject;
  Field: TField);
begin
  if Field = QEntradasRealizadoID then
     if field.AsInteger > 0 then
        dbtRealizado.DataField := 'RealizadoID'
     else
        dbtRealizado.DataField := 'RealizadoPor';

  if Field = QEntradasRevisadoID then
     if field.AsInteger > 0 then
        dbtRevisado.DataField := 'RevisadoID'
     else
        dbtRevisado.DataField := 'RevisadoPor';

  if Field = QEntradasProveedorID then
     if field.AsInteger > 0 then
        dbtProveedor.DataField := 'ProveedorID'
     else
        dbtProveedor.DataField := 'Proveedor';
end;

procedure TfrmActEntradas.btBorraClick(Sender: TObject);
begin
  QDetalle.Delete;
  totaliza;
end;

procedure TfrmActEntradas.btbuscaproductoClick(Sender: TObject);
var
  Cant : Integer;
begin
  Application.CreateForm(tfrmBuscarProducto, frmBuscarProducto);
  frmBuscarProducto.ShowModal;

  if frmBuscarProducto.Acepto = 1 then
  begin
    QDetalle.Insert;
    QDetalleEntradaID.Value   := vEntradaID;
    QDetalleProductoID.Value  := frmBuscarProducto.QProductosProductoID.Value;
    QDetalleNombre.Value      := frmBuscarProducto.QProductosNombre.Value;
    QDetalleCosto.Value       := frmBuscarProducto.QProductoscosto.Value;
    QDetalleItbis.Value       := frmBuscarProducto.QProductosmontoItbis.Value;
    QDetalleDescuento.Value   := 0;
    QDetalleCantidad.Value    := 1;
    QDetalle.Post;
    QDetalle.UpdateBatch;
    totaliza;
  end;
  frmBuscarProducto.Release;
end;

procedure TfrmActEntradas.QEntradas2NewRecord(DataSet: TDataSet);
begin
  QEntradasFecha.Value        := date;
  QEntradasRealizadoID.Value  := frmMain.Usuario;
  QEntradasEntradaID.Value    := vEntradaID;
  QEntradasItbis.Value        :=0;
  QEntradasDescuento.Value    :=0;
  QEntradasTotal.Value        :=0;
end;

procedure TfrmActEntradas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
  btbuscaproducto.Caption  := 'F3'+#13+'PRODUCTOS';
end;

procedure TfrmActEntradas.btpriorClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Bof then
  begin
    QDetalle.Prior;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmActEntradas.btnextClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Eof then
  begin
    QDetalle.Next;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmActEntradas.btsumaClick(Sender: TObject);
begin
  if QDetalle.RecordCount > 0 then
  begin
    QDetalle.Edit;
    QDetalleCantidad.Value := QDetalleCantidad.Value + 1;
    QDetalle.Post;
    QDetalle.UpdateBatch;
//    totaliza;
  end;
end;

procedure TfrmActEntradas.totaliza;
var
  t : TBookmark;
  SubTotal : Double;
begin
    TExento     := 0;
    TItbis      := 0;
    TGrabado    := 0;
    TDescuento  := 0;
    t           := QDetalle.GetBookmark;
    QDetalle.DisableControls;
    QDetalle.First;
    while not QDetalle.Eof do
    begin
      if QDetalleItbis.Value > 0 then
         TGrabado := TGrabado + (QDetalleCantidad.Value * (QDetalleCosto.Value - QDetalleDescuento.Value))
      else
         TExento  := TExento  + (QDetalleCantidad.Value * (QDetalleCosto.Value - QDetalleDescuento.Value));

{verificar descueto 20170420}
      tDescuento  := tDescuento + (QDetalleDescuento.Value * QDetallecantidad.Value);
      TItbis      := TItbis + (TGrabado * QDetalleItbis.Value)/100.0;
      SubTotal    := SubTotal + (TExento + TGrabado);
      QDetalle.Next;
    end;
    QDetalle.First;
    QDetalle.GotoBookmark(t);
    QDetalle.EnableControls;
    QEntradasExento.Value    := TExento;
    QEntradasGrabado.Value   := TGrabado;
    QEntradasItbis.Value     := TItbis;
    QEntradasDescuento.Value := tDescuento;
    QEntradasTotal.Value     := TGrabado + TExento + TItbis;
end;

procedure TfrmActEntradas.btRevisadoClick(Sender: TObject);
begin
  if QEntradas.state in [dsInsert,dsEdit] then
  begin
    Application.CreateForm(tfrmAcceso, frmAcceso);
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
        showmessage('ESTE USUARIO NO EXISTE');
        DBMemo1.SetFocus;
      end
      else if dm.Query1.FieldbyName('Estatus').AsString <> 'ACT' then
      begin
        showmessage('ESTE USUARIO NO ESTA ACTIVO');
        DBMemo1.SetFocus;
      end
      else if dm.Query1.FieldbyName('Supervisor').AsBoolean <> True then
      begin
        showmessage('ESTE USUARIO NO ES SUPERVISOR');
        DBMemo1.SetFocus;
      end
      else
        QEntradasRevisadoID.Value := dm.Query1.FieldbyName('UsuarioID').AsInteger;
    frmAcceso.Release;
 end;
 end;
end;

procedure TfrmActEntradas.btrestaClick(Sender: TObject);
begin
  if QDetalle.RecordCount > 0 then
  begin
    QDetalle.Edit;
    QDetalleCantidad.Value := QDetalleCantidad.Value - 1;
    QDetalle.Post;
    QDetalle.UpdateBatch;
//    totaliza;
  end;
end;

procedure TfrmActEntradas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
  if key = vk_f3 then btbuscaproductoClick(self);
  if key = vk_f11 then btpriorClick(Self);
  if key = vk_f12 then btnextClick(Self);
end;

procedure TfrmActEntradas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  If Grabo <> 1 then
     btcloseClick(self);
end;

procedure TfrmActEntradas.DBGrid1Exit(Sender: TObject);
begin
  if QDetalle.state in [dsInsert,dsEdit] then
     QDetalle.post;
  totaliza;
end;

procedure TfrmActEntradas.btAutorizadoClick(Sender: TObject);
begin             
  if QEntradas.state in [dsInsert,dsEdit] then
  begin
    Application.CreateForm(TfrmBuscarProveedor, frmBuscarProveedor);
    frmBuscarProveedor.ShowModal;
    if frmBuscarProveedor.Acepto = 1 then
       QEntradasProveedorID.Value := frmBuscarProveedor.QProveedoresProveedorID.AsInteger;
    frmBuscarProveedor.Release;
  end;
end;

procedure TfrmActEntradas.QEntradasCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('subTotal').AsCurrency := DataSet.FieldByName('Grabado').AsCurrency +DataSet.FieldByName('Exento').AsCurrency;
end;

procedure TfrmActEntradas.QEntradasNewRecord(DataSet: TDataSet);
begin
  QEntradasFecha.Value       := date;
  QEntradasRealizadoID.Value := frmMain.Usuario;
  QEntradasEntradaID.Value   := vEntradaID;
end;

procedure TfrmActEntradas.dsEntradasStateChange(Sender: TObject);
begin
  btbuscaproducto.Enabled := (QEntradas.Active) and (QDetalle.Active);
end;

procedure TfrmActEntradas.QDetalleAfterPost(DataSet: TDataSet);
begin
  totaliza;
end;

procedure TfrmActEntradas.QEntradasBeforePost(DataSet: TDataSet);
begin
if QEntradasExistenciaAplicada.IsNull then
QEntradasExistenciaAplicada.Value := False;
end;

end.

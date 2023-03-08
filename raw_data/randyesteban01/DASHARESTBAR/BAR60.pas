unit BAR60;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls, Grids,
  DBGrids,DIMime;

type
  TfrmActSalidas = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    QSalidas: TADOQuery;
    dsSalidas: TDataSource;
    Panel2: TPanel;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    DBText1: TDBText;
    btRevisado: TSpeedButton;
    btAutorizado: TSpeedButton;
    DBGrid1: TDBGrid;
    QDetalle: TADOQuery;
    dsDetalle: TDataSource;
    QDetalleProductoID: TIntegerField;
    QDetalleNombre: TWideStringField;
    btprior: TSpeedButton;
    btnext: TSpeedButton;
    Panel3: TPanel;
    btresta: TSpeedButton;
    btbuscaproducto: TSpeedButton;
    QDetalleDetalleID: TAutoIncField;
    QDetalleSalidaID: TIntegerField;
    dbtRealizado: TDBText;
    DBMemo1: TDBMemo;
    dbtRevisado: TDBText;
    dbtAutorizado: TDBText;
    QDetalleCantidad: TFloatField;
    QSalidasSalidaID: TIntegerField;
    QSalidasFecha: TDateTimeField;
    QSalidasConcepto: TMemoField;
    QSalidasRealizadoID: TIntegerField;
    QSalidasRealizadoPor: TIntegerField;
    QSalidasRevisadoID: TIntegerField;
    QSalidasRevisadoPor: TIntegerField;
    QSalidasAutorizadoID: TIntegerField;
    QSalidasAutorizadoPor: TIntegerField;
    procedure btcloseClick(Sender: TObject);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btbuscaproductoClick(Sender: TObject);
    procedure btpriorClick(Sender: TObject);
    procedure btnextClick(Sender: TObject);
    procedure btrestaClick(Sender: TObject);
    procedure QSalidasNewRecord(DataSet: TDataSet);
    procedure btRevisadoClick(Sender: TObject);
    procedure btAutorizadoClick(Sender: TObject);
    procedure dsSalidasStateChange(Sender: TObject);
    procedure dsSalidasDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    Grabo, vSalidaID : Integer;
    modoEdit : Boolean;
  end;

var
  frmActSalidas: TfrmActSalidas;

implementation

uses BAR09, BAR01, BAR14, BAR04;

{$R *.dfm}

procedure TfrmActSalidas.btcloseClick(Sender: TObject);
begin
  if modoEdit = false then begin
     QDetalle.DisableControls;
     QDetalle.First;
     While not QDetalle.Eof do begin
       QDetalle.Delete;
       QDetalle.Next;
     end;
  end;
  QSalidas.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActSalidas.btpostClick(Sender: TObject);
begin
  if QSalidas.State in [dsedit,dsinsert] then
     QSalidas.Post;
  QSalidas.UpdateBatch;
  If QDetalle.State in [dsedit,dsInsert] then
     QDetalle.Post;
  QDetalle.UpdateBatch;   
  Grabo := 1;
  Close;
end;

procedure TfrmActSalidas.FormCreate(Sender: TObject);
begin
  QDetalle.Active := true;
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
  btbuscaproducto.Caption  := 'F3'+#13+'PRODUCTOS';
end;

procedure TfrmActSalidas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
  if key = vk_f3 then btbuscaproductoClick(Self);
end;

procedure TfrmActSalidas.btbuscaproductoClick(Sender: TObject);
var
  t : TBookmark;
  Cant : Integer;
begin
  Application.CreateForm(tfrmBuscarProducto, frmBuscarProducto);
  frmBuscarProducto.ShowModal;

  if frmBuscarProducto.Acepto = 1 then
  begin
    QDetalle.DisableControls;
    QDetalle.Open;
    QDetalle.Insert;
    QDetalleSalidaID.Value   := vSalidaID;
    QDetalleProductoID.Value := frmBuscarProducto.QProductosProductoID.Value;
    QDetalleNombre.Value     := frmBuscarProducto.QProductosNombre.Value;
    QDetalleCantidad.Value   := 1;
    QDetalle.Post;
    QDetalle.UpdateBatch;   
    QDetalle.EnableControls;

    QDetalle.Close;
    QDetalle.Parameters.ParamByName('SalidaID').Value := vSalidaID;
    QDetalle.Open;
  end;
  frmBuscarProducto.Release;
end;

procedure TfrmActSalidas.btpriorClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Bof then
  begin
    QDetalle.Prior;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmActSalidas.btnextClick(Sender: TObject);
begin
  QDetalle.DisableControls;
  if not QDetalle.Eof then
  begin
    QDetalle.Next;
  end;
  QDetalle.EnableControls;
end;

procedure TfrmActSalidas.btrestaClick(Sender: TObject);
begin
  QDetalle.Delete;
end;

procedure TfrmActSalidas.QSalidasNewRecord(DataSet: TDataSet);
begin
  QSalidasFecha.Value       := date;
  QSalidasRealizadoID.Value := frmMain.Usuario;
  QSalidasSalidaID.Value    := vSalidaID;
end;

procedure TfrmActSalidas.btRevisadoClick(Sender: TObject);
begin
  if QSalidas.RecordCount > 0 then
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
      begin
        QSalidasRevisadoID.Value := dm.Query1.FieldbyName('UsuarioID').AsInteger;
      end;
    frmAcceso.Release;
 end;
 end;
end;

procedure TfrmActSalidas.btAutorizadoClick(Sender: TObject);
begin
  if QSalidas.RecordCount > 0 then
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
      begin
        QSalidasAutorizadoID.Value := dm.Query1.FieldbyName('UsuarioID').AsInteger;
      end;
    frmAcceso.Release;
 end;
 end;

end;

procedure TfrmActSalidas.dsSalidasStateChange(Sender: TObject);
begin
  btbuscaproducto.Enabled := (QSalidas.Active) and (QDetalle.Active);
end;

procedure TfrmActSalidas.dsSalidasDataChange(Sender: TObject;
  Field: TField);
begin
  if Field = QSalidasRealizadoID then
     if field.AsInteger > 0 then
        dbtRealizado.DataField := 'RealizadoID'
     else
        dbtRealizado.DataField := 'RealizadoPor';

  if Field = QSalidasRevisadoID then
     if field.AsInteger > 0 then
        dbtRevisado.DataField := 'RevisadoID'
     else
        dbtRevisado.DataField := 'RevisadoPor';

  if Field = QSalidasAutorizadoID then
     if field.AsInteger > 0 then
        dbtAutorizado.DataField := 'AutorizadoID'
     else
        dbtAutorizado.DataField := 'AutorizadoPor';
end;

end.

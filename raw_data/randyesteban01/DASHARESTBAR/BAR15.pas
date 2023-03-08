unit BAR15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, DB, ADODB, Grids, DBGrids, DIMime;

type
  TfrmHold = class(TForm)
    btclose: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btaceptar: TSpeedButton;
    QFacturas: TADOQuery;
    QFacturasFacturaID: TIntegerField;
    QFacturasFecha: TDateTimeField;
    QFacturasTotal: TBCDField;
    DBGrid1: TDBGrid;
    dsFacturas: TDataSource;
    DBGrid2: TDBGrid;
    QDetalle: TADOQuery;
    dsDetalle: TDataSource;
    QFacturasCajeroID: TIntegerField;
    QFacturasCajaID: TIntegerField;
    QFacturasNombre: TWideStringField;
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
    QFacturasAbierta: TBooleanField;
    QFacturasAbiertaPor: TStringField;
    qQuery: TADOQuery;
    IntegerField1: TIntegerField;
    DateTimeField1: TDateTimeField;
    BCDField1: TBCDField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    WideStringField1: TWideStringField;
    BooleanField1: TBooleanField;
    StringField1: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : Integer;
  end;

var
  frmHold: TfrmHold;

implementation

uses BAR04, BAR01, BAR00, BAR14;

{$R *.dfm}

procedure TfrmHold.FormCreate(Sender: TObject);
begin
  btclose.Caption   := 'F1'+#13+'SALIR';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
end;

procedure TfrmHold.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmHold.btaceptarClick(Sender: TObject);
begin
  if QFacturasAbierta.Value = True then begin
  if MessageDlg('Esta factura esta abierta por '+UpperCase(QFacturasAbiertaPor.Text)+char(13)+
              'Desea liberarla?',mtConfirmation,[mbYes,mbno],0)=mryes then begin
  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.ShowModal;
  if frmAcceso.Acepto = 1 then
  begin
    dm.Query1.close;
    dm.Query1.sql.clear;
    dm.Query1.sql.add('select usu_codigo UsuarioID, usu_nombre Nombre, usu_supervisor Supervisor, usu_cajero Cajero, usu_camarero Camarero, usu_status Estatus from Usuarios');
    dm.Query1.sql.add('where usu_Clave = :cla');
    dm.Query1.Parameters.parambyname('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);
    dm.Query1.open;
    if dm.Query1.recordcount = 0 then
    begin
      showmessage('ESTE USUARIO NO EXISTE');
    end
    else if dm.Query1.FieldbyName('Estatus').AsString <> 'ACT' then
    begin
      showmessage('ESTE USUARIO NO ESTA ACTIVO');
    end
    else
    if DM.Query1.FieldByName('Supervisor').Value = False then begin
      ShowMessage('Usted no es un Supervisor para liberar esta factura.....');
      Exit;
    end else
    if DM.Query1.FieldByName('Supervisor').Value = true then begin
    dm.ADOBar.Execute('set dateformat ymd update Factura_RestBar set Abierta = 0, AbiertaPor = NULL, AbiertaDesde = ''1900-01-01'' where facturaid ='+QFacturasFacturaID.Text+' and hold = 1 AND AbiertaDesde IS NOT NULL');
    Acepto := 1;
    Close;
    end;
    end;
    end;
    end else
  begin
  Acepto := 1;
  Close;
end;
end;

procedure TfrmHold.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
end;

procedure TfrmHold.FormActivate(Sender: TObject);
begin
  btaceptar.Enabled := QFacturas.RecordCount > 0;
end;

procedure TfrmHold.DBGrid2Enter(Sender: TObject);
begin
  DbGrid1.SetFocus;
end;

procedure TfrmHold.SpeedButton1Click(Sender: TObject);
begin
  if not QFacturas.Bof then QFacturas.Prior;
end;

procedure TfrmHold.SpeedButton2Click(Sender: TObject);
begin
  if not QFacturas.Eof then QFacturas.Next;
end;

procedure TfrmHold.DBGrid1DblClick(Sender: TObject);
begin
  btaceptarClick(self);
end;

end.

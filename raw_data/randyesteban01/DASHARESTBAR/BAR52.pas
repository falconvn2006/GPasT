unit BAR52;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, DB, ADODB, Grids, DBGrids;

type
  TfrmUnifMesa = class(TForm)
    btclose: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btaceptar: TSpeedButton;
    QFacturas: TADOQuery;
    QFacturasFacturaID: TIntegerField;
    QFacturasFecha: TDateTimeField;
    QFacturasTotal: TBCDField;
    dsFacturas: TDataSource;
    DBGrid2: TDBGrid;
    QDetalle: TADOQuery;
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
    dsDetalle: TDataSource;
    QFacturasCajeroID: TIntegerField;
    QFacturasCajaID: TIntegerField;
    QFacturasNombre: TWideStringField;
    QFacturasUnificada: TIntegerField;
    DBGrid3: TDBGrid;
    QFacturasMesaID: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3CellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : Integer;
  end;

var
  frmUnifMesa: TfrmUnifMesa;

implementation

uses BAR04, BAR01, BAR00, MaskUtils;

{$R *.dfm}

procedure TfrmUnifMesa.FormCreate(Sender: TObject);
begin
  btclose.Caption   := 'F1'+#13+'SALIR';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
end;

procedure TfrmUnifMesa.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmUnifMesa.btaceptarClick(Sender: TObject);
var Qtemp: TADOQuery;
begin
  Qtemp := TADOQuery.Create(self);
  Qtemp.Connection := QFacturas.Connection;
  QFacturas.DisableControls;
  QFacturas.First;
  while not QFacturas.Eof do begin
    If QFacturasUnificada.Value = 1 then
       with Qtemp,SQL do
          begin
            Close;
            Clear;
             Add('update Factura_Items set FacturaID= '+frmPOS.QFacturaFacturaID.AsString+
                ' ,CajeroID= '+frmPOS.QFacturaCajeroID.AsString+
                ' ,CajaID  = '+frmPOS.QFacturaCajaID.AsString+
                ' where FacturaID = '+QFacturasFacturaID.AsString+
                '   and CajeroID  = '+QFacturasCajeroID.AsString+
                '   and CajaID    = '+QFacturasCajaID.AsString);
            try
              ExecSQL;      
            finally
              frmPOS.liberarMesa(QFacturasMesaID.AsString);
            end;
            Close;
            Clear;
             Add('update Factura set Hold=false, exento=0, grabado=0, itbis=0, propina=0, total=0 '+
                ' where FacturaID = '+QFacturasFacturaID.AsString+
                '   and CajeroID  = '+QFacturasCajeroID.AsString+
                '   and CajaID    = '+QFacturasCajaID.AsString );
            try
              ExecSQL;
            finally 
            end;
          end;
    QFacturas.Next;
  end;

  Qtemp.Free;
  QFacturas.EnableControls;
  frmPOS.Totaliza := False;
  frmPOS.QDetalle.Close;
  frmPOS.QDetalle.Parameters.ParamByName('caj').Value  := frmPOS.QFacturaCajeroID.Value;
  frmPOS.QDetalle.Parameters.ParamByName('fac').Value  := frmPOS.QFacturaFacturaID.Value;
  frmPOS.QDetalle.Parameters.ParamByName('caja').Value := frmPOS.QFacturaCajaID.Value;
  frmPOS.QDetalle.Open;
  frmPOS.Totaliza := True;
  frmPOS.Totalizar;
  frmPOS.edproducto.SetFocus;
  Acepto := 1;
  Close;
end;

procedure TfrmUnifMesa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
end;

procedure TfrmUnifMesa.FormActivate(Sender: TObject);
begin
  btaceptar.Enabled := QFacturas.RecordCount > 0;
end;

procedure TfrmUnifMesa.DBGrid2Enter(Sender: TObject);
begin
  DBGrid3.SetFocus;
end;

procedure TfrmUnifMesa.SpeedButton1Click(Sender: TObject);
begin
  if not QFacturas.Bof then QFacturas.Prior;
end;

procedure TfrmUnifMesa.SpeedButton2Click(Sender: TObject);
begin
  if not QFacturas.Eof then QFacturas.Next;
end;

procedure TfrmUnifMesa.DBGrid3DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var 
  Check: Integer; 
  R: TRect; 
begin 
  if Column.FieldName = 'Unificada' then
  begin
    DBGrid3.Canvas.FillRect(Rect);
    Check := 0;
    if QFacturas.FindField('Unificada').AsInteger = 1 then Check := DFCS_CHECKED;
    R:=Rect;
    InflateRect(R,-2,-2); //Disminuye el tamaño del CheckBox
    DrawFrameControl(DBGrid3.Canvas.Handle,R,DFC_BUTTON, DFCS_BUTTONCHECK or Check);
  end;
end;

procedure TfrmUnifMesa.DBGrid3CellClick(Column: TColumn);
begin
  if Column.FieldName = 'Unificada' then
  begin
    QFacturas.Edit;
    if QFacturas.FindField('Unificada').AsInteger = 1 then
    QFacturas.FindField('Unificada').AsInteger := 0
    else
    QFacturas.FindField('Unificada').AsInteger := 1;
    QFacturas.Post;
    DBGrid3.Refresh; // quizás más bien un Repaint.... pero en fin.
  end;
  DBGrid3.SelectedIndex :=0;
end;

end.

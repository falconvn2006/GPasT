unit POS16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, DBGrids, DB, ADODB;

type
  TfrmDesccuento = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    btdescuento: TSpeedButton;
    QDetalle: TADOQuery;
    QDetalleusu_codigo: TIntegerField;
    QDetallefecha: TDateTimeField;
    QDetalleticket: TIntegerField;
    QDetallesecuencia: TIntegerField;
    QDetallehora: TStringField;
    QDetalleproducto: TIntegerField;
    QDetalledescripcion: TStringField;
    QDetallecantidad: TBCDField;
    QDetalleprecio: TBCDField;
    QDetalleempaque: TStringField;
    QDetalleitbis: TBCDField;
    QDetalleCosto: TBCDField;
    QDetalleValor: TFloatField;
    QDetallecaja: TIntegerField;
    QDetallePrecioItbis: TFloatField;
    QDetalleCalcItbis: TFloatField;
    QDetalleExcento: TStringField;
    dsDetalle: TDataSource;
    DBGrid1: TDBGrid;
    QDetalledescuento: TBCDField;
    QDetalleTotalDescuento: TFloatField;
    btmodificaprecio: TSpeedButton;
    btgeneral: TSpeedButton;
    btrecargo: TSpeedButton;
    QDetallerecargo: TBCDField;
    btrecargogeneral: TSpeedButton;
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btsalirClick(Sender: TObject);
    procedure btdescuentoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btmodificaprecioClick(Sender: TObject);
    procedure btgeneralClick(Sender: TObject);
    procedure btrecargoClick(Sender: TObject);
    procedure btrecargogeneralClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDesccuento: TfrmDesccuento;

implementation

uses POS01, POS00;

{$R *.dfm}

procedure TfrmDesccuento.QDetalleCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
  if QDetalleITBIS.value > 0 then
  begin
    NumItbis := strtofloat(format('%10.2f',[(QDetalleITBIS.value/100)+1]));
    Venta    := strtofloat(format('%10.4f',[(QDetallePRECIO.value)/NumItbis]));

    if QDetalledescuento.Value = 0 then
    begin
      QDetalleTotalDescuento.Value := 0;
      QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                   strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

      QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
      QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                   strtofloat(format('%10.2f',[QDetallerecargo.value]))+
                                   strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                   strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
    end
    else
    begin
      QDetalleTotalDescuento.Value := (Venta * QDetalledescuento.Value) / 100;
      Venta := strtofloat(format('%10.4f',[(QDetallePRECIO.value - QDetalleTotalDescuento.Value)/NumItbis]));

      QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                   strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

      QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
      QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                   strtofloat(format('%10.2f',[QDetallerecargo.value]))+
                                   strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                   strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
    end;
  end
  else
  begin
    Venta := strtofloat(format('%10.2f',[QDetallePRECIO.value]));
    QDetalleTotalDescuento.Value := (Venta * QDetalledescuento.Value) / 100;
    Venta := Venta - QDetalleTotalDescuento.Value;

    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleCalcItbis.value   := 0;
    QDetalleValor.value       := strtofloat(format('%10.2f',[(Venta+QDetallerecargo.Value)*QDetalleCANTIDAD.value]));
  end;
  //QDetalleValor.Value := QDetalleprecio.Value * QDetallecantidad.Value;

  if QDetalleitbis.Value >0 then
    QDetalleExcento.Value := ''
  else
    QDetalleExcento.Value := 'E';
end;

procedure TfrmDesccuento.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then btsalirClick(Self);
end;

procedure TfrmDesccuento.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDesccuento.btdescuentoClick(Sender: TObject);
var
  Desc : string;
begin
  Desc := InputBox('Descuento','Descuento','');
  if Trim(desc) = '' then Desc := '0';

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select isnull(f.fam_descuento,0) as maximo from familias f,');
  dm.Query1.SQL.Add('productos p where f.emp_codigo = p.emp_codigo');
  dm.Query1.SQL.Add('and f.fam_codigo = p.fam_codigo');
  dm.Query1.SQL.Add('and p.pro_codigo = :pro');
  dm.Query1.Parameters.ParamByName('pro').Value := Qdetalleproducto.value;
  dm.Query1.Open;
  if (dm.Query1.RecordCount = 0) or (dm.Query1.FieldByName('maximo').AsFloat = 0) then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select isnull(pro_descmax,0) as maximo from');
    dm.Query1.SQL.Add('productos where pro_codigo = :pro');
    dm.Query1.Parameters.ParamByName('pro').Value := Qdetalleproducto.value;
    dm.Query1.Open;
  end;

  if dm.Query1.FieldByName('maximo').AsFloat > 0 then
  begin
    if StrToFloat(Desc) > dm.Query1.FieldByName('maximo').AsFloat then
    begin
      MessageDlg('NO PUEDE DAR UN DESCUENTO MAYOR AL '+dm.Query1.FieldByName('maximo').AsString+'%',mtError,[mbok],0);
      DBGrid1.SetFocus;
    end
    else
    begin
      QDetalle.Edit;
      QDetalledescuento.Value := StrToFloat(Desc);
      QDetalle.Post;
      QDetalle.UpdateBatch;
      DBGrid1.SetFocus;
    end;
  end
  else
  begin
      QDetalle.Edit;
      QDetalledescuento.Value := StrToFloat(Desc);
      QDetalle.Post;
      QDetalle.UpdateBatch;
      DBGrid1.SetFocus;
  end;
end;

procedure TfrmDesccuento.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btmodificaprecioClick(Self);
  if key = vk_f2 then btdescuentoClick(Self);
  if key = vk_f3 then btgeneralClick(Self);
  if key = vk_f4 then btrecargoClick(Self);
  if key = vk_f5 then btrecargogeneralClick(Self);
end;

procedure TfrmDesccuento.btmodificaprecioClick(Sender: TObject);
var
  Prec, debajo : string;
  //itbis : double;
begin
  Prec := InputBox('Precio','Precio',FloatToStr(QDetalleprecio.Value));
  if Trim(Prec) = '' then Prec := '0';

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select par_debajocosto, par_itbis from parametros');
  dm.Query1.SQL.Add('where emp_codigo = :emp');
  dm.Query1.Parameters.ParamByName('emp').Value := frmMain.empresainv;
  dm.Query1.Open;
  debajo := dm.Query1.FieldByName('par_debajocosto').AsString;
  //itbis := dm.Query1.FieldByName('par_itbis').AsFloat;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select case pro_itbis when '+QuotedStr('S')+' then pro_costo+((pro_costo*pro_montoitbis)/100) else pro_costo end as pro_costo');
  dm.Query1.SQL.Add('from productos');
  dm.Query1.SQL.Add('where emp_codigo = :emp and pro_codigo = :pro');
  dm.Query1.Parameters.ParamByName('emp').Value := frmMain.empresainv;
  dm.Query1.Parameters.ParamByName('pro').Value := QDetalleproducto.Value;
  dm.Query1.Open;
  if (StrToFloat(Trim(Prec)) < dm.Query1.FieldbyName('pro_costo').AsFloat)
  and (debajo = 'False') then
  begin
    MessageDlg('NO PUEDE FACTURAR POR DEBAJO DEL COSTO',mtError,[mbok],0);
    DBGrid1.SetFocus;
  end
  else
  begin
    QDetalle.Edit;
    QDetalleprecio.Value := StrToFloat(Prec);
    QDetalle.Post;
    QDetalle.UpdateBatch;
    DBGrid1.SetFocus;
  end;
end;

procedure TfrmDesccuento.btgeneralClick(Sender: TObject);
var
  Desc : string;
begin
  Desc := InputBox('Descuento','% Descuento','');
  if Trim(desc) = '' then Desc := '0';
  QDetalle.DisableControls;
  QDetalle.First;
  while not QDetalle.Eof do
  begin
    QDetalle.Edit;
    QDetalledescuento.Value := StrToFloat(Desc);
    QDetalle.Post;
    QDetalle.Next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
  QDetalle.UpdateBatch;
end;

procedure TfrmDesccuento.btrecargoClick(Sender: TObject);
var
  Rec : string;
begin
  Rec := InputBox('Recargo','Recargo','');
  if Trim(rec) = '' then Rec := '0';
  QDetalle.Edit;
  QDetallerecargo.Value := StrToFloat(Rec);
  QDetalle.Post;
  QDetalle.EnableControls;
  QDetalle.UpdateBatch;
end;

procedure TfrmDesccuento.btrecargogeneralClick(Sender: TObject);
var
  rec : string;
begin
  rec := InputBox('Recargo','Recargo','');
  if Trim(rec) = '' then rec := '0';
  QDetalle.DisableControls;
  QDetalle.First;
  while not QDetalle.Eof do
  begin
    QDetalle.Edit;
    QDetallerecargo.Value :=  StrToFloat(rec);
    QDetalle.Post;
    QDetalle.Next;
  end;
  QDetalle.First;
  QDetalle.EnableControls;
  QDetalle.UpdateBatch;
end;

end.

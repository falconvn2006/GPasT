unit BAR58;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, Buttons, ExtCtrls, DB, ADODB;

type
  TfrmEntradas = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    btadd: TSpeedButton;
    DBGrid1: TDBGrid;
    QEntradas: TADOQuery;
    dsEntradas: TDataSource;
    QEntradasEntradaID: TAutoIncField;
    QEntradasFecha: TDateTimeField;
    QEntradasProveedorID: TIntegerField;
    QEntradasNombreProveedor: TWideStringField;
    QEntradasConcepto: TWideStringField;
    QEntradasExento: TBCDField;
    QEntradasGrabado: TBCDField;
    QEntradasItbis: TBCDField;
    QEntradasDescuento: TBCDField;
    QEntradasTotal: TBCDField;
    QEntradasRealizadoID: TIntegerField;
    QEntradasRealizadoPor: TWideStringField;
    QEntradasRevisadoID: TIntegerField;
    QEntradasRevisadoPor: TWideStringField;
    QEntradasExistenciaAplicada: TBooleanField;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure bteditClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure dsEntradasDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function aumentaExistendia(key: integer):Boolean;

  public
    { Public declarations }
  end;

var
  frmEntradas: TfrmEntradas;

implementation
uses BAR04, BAR61, BAR01; //, BAR63;
{$R *.dfm}

procedure TfrmEntradas.btcloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmEntradas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmEntradas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmEntradas.FormActivate(Sender: TObject);
begin
  if not QEntradas.Active then QEntradas.Open;
end;

procedure TfrmEntradas.bteditClick(Sender: TObject);
var
  t : TBookmark;
  vEntradaid: integer;
begin
  Application.CreateForm(TfrmActEntradas, frmActEntradas);
  frmActEntradas.modoEdit := true;
  frmActEntradas.vEntradaID := QEntradasEntradaID.Value;
  frmActEntradas.QEntradas.Parameters.ParamByName('EntradaID').Value := frmActEntradas.vEntradaID;
  frmActEntradas.QEntradas.Open;
  frmActEntradas.QEntradas.Edit;
  frmActEntradas.QDetalle.close;
  frmActEntradas.QDetalle.Parameters.ParamByName('EntradaID').Value := frmActEntradas.vEntradaID;
  frmActEntradas.QDetalle.Open;

  frmActEntradas.ShowModal;
  if frmActEntradas.Grabo = 1 then
  begin
    vEntradaid := frmActEntradas.QEntradasEntradaID.Value;
    t := frmActEntradas.QEntradas.GetBookmark;
    QEntradas.Close;
    QEntradas.Open;
    QEntradas.GotoBookmark(t);
    if (QEntradasEntradaID.AsInteger > 0) and (QEntradasRevisadoID.AsInteger > 0) then
       begin
        QEntradas.Edit;
        QEntradasExistenciaAplicada.AsBoolean := aumentaExistendia(vEntradaid);
        QEntradas.Post;
       end;
  end;
  frmActEntradas.Release;
end;

procedure TfrmEntradas.btaddClick(Sender: TObject);
var
  t : TBookmark;
  vEntradaid: integer;
begin
  Application.CreateForm(TfrmActEntradas, frmActEntradas);
  frmActEntradas.modoEdit := false;
  frmActEntradas.QEntradas.Active := true;
  if frmActEntradas.QEntradas.Active = true then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(EntradaID) as maximo');
    dm.Query1.SQL.Add('from entradas');
    dm.Query1.Open;
    if dm.Query1.IsEmpty then
       frmActEntradas.vEntradaID := 1
    else
       frmActEntradas.vEntradaID := dm.Query1.FieldByName('maximo').AsInteger + 1;
  end;
  frmActEntradas.QEntradas.close;
  frmActEntradas.QEntradas.Parameters.ParamByName('EntradaID').Value := -1;
  frmActEntradas.QEntradas.Open;
  frmActEntradas.QEntradas.Insert;

  frmActEntradas.QDetalle.close;
  frmActEntradas.QDetalle.Parameters.ParamByName('EntradaID').Value := -1;
  frmActEntradas.QDetalle.Open;

  frmActEntradas.ShowModal;

  if frmActEntradas.Grabo = 1 then
  begin
    vEntradaid := frmActEntradas.QEntradasEntradaID.AsInteger;
    t := frmActEntradas.QEntradas.GetBookmark;
    QEntradas.Close;
    QEntradas.Open;
    QEntradas.GotoBookmark(t);
    if (QEntradasEntradaID.AsInteger > 0) and (QEntradasRevisadoID.AsInteger > 0) then
       begin
        QEntradas.Edit;
        QEntradasExistenciaAplicada.AsBoolean := aumentaExistendia(vEntradaid);
        QEntradas.Post;
       end;

  end;
  frmActEntradas.Release;
end;

function TfrmEntradas.aumentaExistendia(key: integer): Boolean;
var vQry : TadoQuery;
begin
  Result := false;
  vQry := TADOQuery.Create(self);
  vQry.Connection := QEntradas.Connection;
  vQry.Close;
  vQry.SQL.Clear;
  vQry.SQL.Add('SELECT * FROM  Entradas_Detalle');
  vQry.SQL.Add('where EntradaID = '+IntToStr(key));
  vQry.SQL.Add('order by entradaID, DetalleID');
  vQry.Open;
  try
  with vQry do
  begin
    First;
    While not Eof do begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('update Productos set Existencia = Existencia+'+vQry.FieldByName('cantidad').asstring);
      dm.Query1.SQL.Add(',Costo='+vQry.FieldByName('Costo').asstring);
      dm.Query1.SQL.Add(',MontoItbis='+vQry.FieldByName('Itbis').asstring);
      dm.Query1.SQL.Add('where ProductoID = :pro');
      dm.Query1.Parameters.ParamByName('pro').Value := vQry.FieldByName('ProductoID').Value;
      dm.Query1.ExecSQL;
      Next;
    end;
  end;
  finally
    Result := true;
  end;
end;

procedure TfrmEntradas.dsEntradasDataChange(Sender: TObject;
  Field: TField);
begin
  btedit.Enabled  := not QEntradasExistenciaAplicada.AsBoolean;
end;

procedure TfrmEntradas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

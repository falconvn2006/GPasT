unit BAR59;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, Buttons, ExtCtrls, DB, ADODB;

type
  TfrmSalidas = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    btadd: TSpeedButton;
    DBGrid1: TDBGrid;
    QSalidas: TADOQuery;
    dsSalidas: TDataSource;
    QSalidasFecha: TDateTimeField;
    QSalidasRealizadoID: TIntegerField;
    QSalidasRealizadoPor: TWideStringField;
    QSalidasRevisadoID: TIntegerField;
    QSalidasRevisadoPor: TWideStringField;
    QSalidasAutorizadoID: TIntegerField;
    QSalidasAutorizadoPor: TWideStringField;
    QSalidasConcepto: TMemoField;
    QSalidasSalidaID: TIntegerField;
    QSalidasExistenciaRebajada: TBooleanField;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure bteditClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure dsSalidasDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function revajarExistendia(key: integer):Boolean;
  public
    { Public declarations }
  end;

var
  frmSalidas: TfrmSalidas;

implementation

uses BAR60, BAR04, BAR01;

{$R *.dfm}

procedure TfrmSalidas.btcloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmSalidas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmSalidas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmSalidas.FormActivate(Sender: TObject);
begin
  if not QSalidas.Active then QSalidas.Open;
end;

procedure TfrmSalidas.bteditClick(Sender: TObject);
var
  t : TBookmark;
  vSalidaID : integer;
begin
  Application.CreateForm(tfrmActSalidas, frmActSalidas);
  frmActSalidas.modoEdit  := true;
  frmActSalidas.vSalidaID := QSalidasSalidaID.Value;
  frmActSalidas.QSalidas.Parameters.ParamByName('SalidaID').Value := frmActSalidas.vSalidaID;
  frmActSalidas.QSalidas.Open;
  frmActSalidas.QSalidas.Edit;
  frmActSalidas.QDetalle.close;
  frmActSalidas.QDetalle.Parameters.ParamByName('SalidaID').Value := frmActSalidas.vSalidaID;
  frmActSalidas.QDetalle.Open;
  frmActSalidas.ShowModal;
  if frmActSalidas.Grabo = 1 then
  begin
    vSalidaID := frmActSalidas.QSalidasSalidaID.Value;
    t := QSalidas.GetBookmark;
    QSalidas.Close;
    QSalidas.Open;
    QSalidas.GotoBookmark(t);
    if (QSalidasRealizadoID.AsInteger > 0) and (QSalidasAutorizadoID.AsInteger > 0) then
       begin
        QSalidas.Edit;
        QSalidasExistenciaRebajada.AsBoolean := revajarExistendia(vSalidaID);
        QSalidas.Post;
       end;
  end;
  frmActSalidas.Release;
end;

procedure TfrmSalidas.btaddClick(Sender: TObject);
var
  t : TBookmark;
  vSalidaID : integer;
begin
  Application.CreateForm(TfrmActSalidas, frmActSalidas);
  frmActSalidas.modoEdit := false;
  frmActSalidas.QSalidas.Active := true;
  if frmActSalidas.QSalidas.Active = true then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(SalidaID) as maximo');
    dm.Query1.SQL.Add('from salidas');
    dm.Query1.Open;
    if dm.Query1.IsEmpty then
       frmActSalidas.vSalidaID := 1
    else
       frmActSalidas.vSalidaID := dm.Query1.FieldByName('maximo').AsInteger + 1;
  end;
  frmActSalidas.QSalidas.Parameters.ParamByName('SalidaID').Value := -1;
  frmActSalidas.QSalidas.Open;
  frmActSalidas.QSalidas.Insert;
  frmActSalidas.ShowModal; 

  if frmActSalidas.Grabo = 1 then
  begin
    vSalidaID := frmActSalidas.QSalidasSalidaID.Value;
    t := QSalidas.GetBookmark;
    QSalidas.Close;
    QSalidas.Open;
    QSalidas.GotoBookmark(t);
    if (QSalidasRealizadoID.AsInteger > 0) and (QSalidasAutorizadoID.AsInteger > 0) then
       begin
        QSalidas.Edit;
        QSalidasExistenciaRebajada.AsBoolean := revajarExistendia(vSalidaID);
        QSalidas.Post;
       end;
  end;
  frmActSalidas.Release;
end;

function TfrmSalidas.revajarExistendia(key: integer): Boolean;
var vQry : TadoQuery;
begin
  Result := false;
  vQry := TADOQuery.Create(self);
  vQry.Connection := QSalidas.Connection;
  vQry.Close;
  vQry.SQL.Clear;
  vQry.SQL.Add('SELECT * FROM  Salidas_Detalle');
  vQry.SQL.Add('where SalidaID = '+IntToStr(key));
  vQry.SQL.Add('order by salidaID, DetalleID');
  vQry.Open;
  try
  with vQry do
  begin
    First;
    While not Eof do begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('update Productos set Existencia = Existencia - '+vQry.FieldByName('cantidad').AsString);
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

procedure TfrmSalidas.dsSalidasDataChange(Sender: TObject; Field: TField);
begin
  btedit.Enabled  := not QSalidasExistenciaRebajada.AsBoolean;
end;

procedure TfrmSalidas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

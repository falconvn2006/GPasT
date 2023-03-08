unit BAR18;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, DBCtrls, DB, ADODB;

type
  TfrmSeleccionMesa = class(TForm)
    btclose: TSpeedButton;
    pncat2: TPanel;
    lbmesa2: TStaticText;
    pncat1: TPanel;
    lbmesa1: TStaticText;
    pncat3: TPanel;
    lbmesa3: TStaticText;
    pncat4: TPanel;
    lbmesa4: TStaticText;
    pncat6: TPanel;
    lbmesa6: TStaticText;
    pncat5: TPanel;
    lbmesa5: TStaticText;
    pncat7: TPanel;
    lbmesa7: TStaticText;
    pncat8: TPanel;
    lbmesa8: TStaticText;
    pncat10: TPanel;
    lbmesa10: TStaticText;
    pncat9: TPanel;
    lbmesa9: TStaticText;
    pncat11: TPanel;
    lbmesa11: TStaticText;
    pncat12: TPanel;
    lbmesa12: TStaticText;
    pncat14: TPanel;
    lbmesa14: TStaticText;
    pncat13: TPanel;
    lbmesa13: TStaticText;
    pncat15: TPanel;
    lbmesa15: TStaticText;
    pncat16: TPanel;
    lbmesa16: TStaticText;
    pncat17: TPanel;
    lbmesa17: TStaticText;
    pncat18: TPanel;
    lbmesa18: TStaticText;
    pncat19: TPanel;
    lbmesa19: TStaticText;
    pncat21: TPanel;
    lbmesa21: TStaticText;
    pncat20: TPanel;
    lbmesa20: TStaticText;
    pncat22: TPanel;
    lbmesa22: TStaticText;
    pncat23: TPanel;
    lbmesa23: TStaticText;
    pncat24: TPanel;
    lbmesa24: TStaticText;
    pncat25: TPanel;
    lbmesa25: TStaticText;
    pncat26: TPanel;
    lbmesa26: TStaticText;
    pncat28: TPanel;
    lbmesa28: TStaticText;
    pncat27: TPanel;
    lbmesa27: TStaticText;
    pncat29: TPanel;
    lbmesa29: TStaticText;
    pncat30: TPanel;
    lbmesa30: TStaticText;
    pncat31: TPanel;
    lbmesa31: TStaticText;
    pncat32: TPanel;
    lbmesa32: TStaticText;
    Panel1: TPanel;
    lbmesa33: TStaticText;
    Panel2: TPanel;
    lbmesa34: TStaticText;
    Panel3: TPanel;
    lbmesa35: TStaticText;
    DBLookupComboBox1: TDBLookupComboBox;
    QAreas: TADOQuery;
    QAreasAreaID: TAutoIncField;
    QAreasNombre: TWideStringField;
    dsAreas: TDataSource;
    QAreasPrecio: TStringField;
    Query1: TADOQuery;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLookupComboBox1Click(Sender: TObject);
    procedure lbmesa1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MesaID : Integer;
    NMesa : String;
    procedure BuscaMesa;
  end;

var
  frmSeleccionMesa: TfrmSeleccionMesa;

  Mesas : array[1..35] of String;
  NombreMesa  : array[1..35] of String;

implementation

uses BAR04, BAR00, BAR03;

{$R *.dfm}

procedure TfrmSeleccionMesa.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSeleccionMesa.BuscaMesa;
var
  a : integer;
begin
//Buscar Mesas Hold Liberarlas
  DM.Query1.Close;
  DM.Query1.SQL.Clear;
  DM.Query1.SQL.Add('UPDATE MESAS SET ESTATUS ='+QuotedStr('DISP'));
  DM.Query1.SQL.Add('WHERE AreaID = :area AND estatus IN (''ABI'') AND MESAID NOT IN ');
  DM.Query1.SQL.Add('(SELECT mesaid FROM Factura_RestBar WHERE Estatus = ''ABI'' and mesaid > 0)');
  dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
  DM.Query1.ExecSQL;



  //Buscando Mesas
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select MesaID, Nombre, Estatus from Mesas where AreaID = :area');
  dm.Query1.SQL.Add('and Estatus = '+QuotedStr('DISP'));
  dm.Query1.SQL.Add('order by MesaID');
  dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Open;
  for a:=1 to 35 do
  begin
    Mesas[a] := '';
    NombreMesa[a]  := '';
    (frmSeleccionMesa.FindComponent('lbmesa'+inttostr(a)) as TStatictext).Caption := Mesas[a];
  end;

  a := 1;
  dm.Query1.DisableControls;
  while not dm.Query1.EOF do
  begin
    Mesas[a] := dm.Query1.FieldByName('MesaID').AsString;
    NombreMesa[a]  := dm.Query1.FieldByName('Nombre').AsString;

    if dm.Query1.FieldByName('Estatus').AsString = 'ABI' then
    begin
      (frmSeleccionMesa.FindComponent('lbmesa'+inttostr(a)) as TStatictext).Color := clYellow;
      (frmSeleccionMesa.FindComponent('lbmesa'+inttostr(a)) as TStatictext).Font.Color := clBlack;
      (frmSeleccionMesa.FindComponent('lbmesa'+inttostr(a)) as TStatictext).Font.Style := [fsbold];
    end;

    (frmSeleccionMesa.FindComponent('lbmesa'+inttostr(a)) as TStatictext).Caption := NombreMesa[a];

    a := a + 1;
    dm.Query1.Next;
  end;
  dm.Query1.enablecontrols;
end;

procedure TfrmSeleccionMesa.FormCreate(Sender: TObject);
begin
  QAreas.Open;
  DBLookupComboBox1.KeyValue := QAreasAreaID.Value;
  BuscaMesa;
end;

procedure TfrmSeleccionMesa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
end;

procedure TfrmSeleccionMesa.DBLookupComboBox1Click(Sender: TObject);
begin
  BuscaMesa;
end;

procedure TfrmSeleccionMesa.lbmesa1Click(Sender: TObject);
var
  seleccion : string;
begin
  seleccion := 'S';
  if frmPOS.QFactura.Active then
  begin
    if frmPOS.QFactura.RecordCount > 0 then
    begin
      if (frmPOS.QFacturaMesaID.AsInteger > 0) or (not frmPOS.QFacturaMesaID.IsNull) then
      begin
        Application.CreateForm(tfrmConfirm, frmConfirm);
        frmConfirm.lbtitulo.Caption := 'DESEA CAMBIAR LA MESA?';
        frmConfirm.ShowModal;
        seleccion := frmConfirm.accion;
        if frmConfirm.accion = 'S' then
        begin
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('update Mesas set Estatus = :st');
          dm.Query1.SQL.Add('where MesaID = :mesa AND AreaID = :area AND estatus IN (''ABI'') AND MESAID NOT IN ');
          DM.Query1.SQL.Add('(SELECT mesaid FROM Factura_RestBar WHERE Estatus = ''ABI'' and mesaid > 0)');
          dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
          dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
          dm.Query1.Parameters.ParamByName('mesa').Value := frmPOS.QFacturaMesaID.Value;
          dm.Query1.ExecSQL;
          frmPOS.vl_precio := QAreasPrecio.Value;


          {dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select MesaID from Mesas');
          dm.Query1.SQL.Add('where Nombre = :mesa and AreaID = :area');
          dm.Query1.Parameters.ParamByName('mesa').Value := Trim((sender as TStatictext).Caption);
          dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
          dm.Query1.Open;
          MesaID := dm.Query1.FieldByName('MesaID').AsInteger;
          NMesa := Trim((sender as TStatictext).Caption);

          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('update Mesas set Estatus = :st');
          dm.Query1.SQL.Add('where MesaID = :mesa and AreaID = :area');
          dm.Query1.Parameters.ParamByName('st').Value   := 'ABI';
          dm.Query1.Parameters.ParamByName('mesa').Value := MesaID;
          dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
          dm.Query1.ExecSQL;}
        end;
      end;
    end;
  end;

  if seleccion = 'S' then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select MesaID from Mesas');
    dm.Query1.SQL.Add('where Nombre = :mesa and AreaID = :area');
    dm.Query1.Parameters.ParamByName('mesa').Value := Trim((sender as TStatictext).Caption);
    dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Open;
    MesaID := dm.Query1.FieldByName('MesaID').AsInteger;
    NMesa := Trim((sender as TStatictext).Caption);

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('update Mesas set Estatus = :st');
    dm.Query1.SQL.Add('where MesaID = :mesa and AreaID = :area');
    dm.Query1.Parameters.ParamByName('st').Value   := 'ABI';
    dm.Query1.Parameters.ParamByName('mesa').Value := MesaID;
    dm.Query1.Parameters.ParamByName('area').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.ExecSQL;
    frmPOS.vl_precio := QAreasPrecio.Value;

    //Cambiar los precios
    if frmPOS.QDetalle.RecordCount > 0 then begin
    frmPOS.QDetalle.DisableControls;
    frmPOS.QDetalle.First;
    while not frmPOS.QDetalle.Eof do begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select isnull(pro_precio1,0) precio1, isnull(pro_precio2,0) precio2, isnull(pro_precio3,0) precio3, isnull(pro_precio4,0) precio4 from productos');
    Query1.SQL.Add('where pro_codigo = '+QuotedStr(frmPOS.QDetalleProductoID.Text)+' and emp_codigo = '+QuotedStr(dm.QEmpresaEmpresaID.Text));
    Query1.Open;
    frmPOS.QDetalle.Edit;
    if ((frmPOS.vl_precio = '') or (frmPOS.vl_precio = 'Precio1')) then
    frmPOS.QDetallePrecio.Value     := Query1.fieldbyname('precio1').Value;
    if frmPOS.vl_precio = 'Precio2' then
    frmPOS.QDetallePrecio.Value     := Query1.fieldbyname('precio2').Value;
    if frmPOS.vl_precio = 'Precio3' then
    frmPOS.QDetallePrecio.Value     := Query1.fieldbyname('precio3').Value;
    if frmPOS.vl_precio = 'Precio4' then
    frmPOS.QDetallePrecio.Value     := Query1.fieldbyname('precio4').Value;
    frmPOS.QDetalle.Post;
    frmPOS.QDetalle.UpdateBatch;
    frmPOS.QDetalle.Next;
  end;
    frmPOS.QDetalle.EnableControls;
  end;

  end;

  Close;
end;

end.

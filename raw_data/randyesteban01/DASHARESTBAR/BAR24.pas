unit BAR24;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls;

type
  TfrmActMesas = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    QMesas: TADOQuery;
    dsMesas: TDataSource;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    QAreas: TADOQuery;
    dsAreas: TDataSource;
    QAreasAreaID: TAutoIncField;
    QAreasNombre: TWideStringField;
    Label2: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    QMesasMesaID: TIntegerField;
    QMesasNombre: TWideStringField;
    QMesasAreaID: TIntegerField;
    QMesasEstatus: TWideStringField;
    DBRadioGroup1: TDBRadioGroup;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QMesasNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActMesas: TfrmActMesas;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActMesas.btcloseClick(Sender: TObject);
begin
  QMesas.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActMesas.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActMesas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActMesas.btpostClick(Sender: TObject);
begin
  //Buscar Articulos en mesas
  if QMesasMesaID.Value > 0 then begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('SELECT TOP 1 MESAID FROM Factura_RestBar F');
  DM.Query1.SQL.Add('INNER JOIN Factura_Items FD ON F.FacturaID = FD.FacturaID');
  DM.Query1.SQL.Add('WHERE F.Estatus = ''ABI'' AND F.HOLD = ''True'' AND MesaID > 0 AND MESAID = '+QMesasMesaID.Text);
  dm.Query1.Open;
  IF DM.Query1.RecordCount > 0 THEN BEGIN
  ShowMessage('No se puede abrir la mesa ya que contiene productos....');
  Exit;
  end;
  end;
  QMesas.Post;
  QMesas.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActMesas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';

  QAreas.Open;
end;

procedure TfrmActMesas.QMesasNewRecord(DataSet: TDataSet);
begin
  QMesasEstatus.Value := 'DISP';
  QMesasAreaID.Value  := QAreasAreaID.Value;
end;

end.

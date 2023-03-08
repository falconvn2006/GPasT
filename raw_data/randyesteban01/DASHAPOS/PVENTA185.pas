unit PVENTA185;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, DB, ADODB;

type
  TfrmBuscaRNC = class(TForm)
    DBGrid1: TDBGrid;
    Label1: TLabel;
    edrazon: TEdit;
    BitBtn1: TBitBtn;
    QRNC: TADOQuery;
    QRNCrnc_cedula: TStringField;
    QRNCrazon_social: TStringField;
    QRNCnombre_comercial: TStringField;
    QRNCactividad_economica: TStringField;
    QRNCdireccion: TStringField;
    QRNCnumero: TStringField;
    QRNCurbanizacion: TStringField;
    QRNCtelefono: TStringField;
    QRNCestatus: TStringField;
    Memo1: TMemo;
    dsRNC: TDataSource;
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    seleccion : integer;
  end;

var
  frmBuscaRNC: TfrmBuscaRNC;

implementation

uses POS01;


{$R *.dfm}

procedure TfrmBuscaRNC.BitBtn1Click(Sender: TObject);
begin
  QRNC.Close;
  QRNC.SQL.Clear;
  QRNC.SQL := Memo1.Lines;
  QRNC.SQL.Add('where razon_social like '+QuotedStr(edrazon.Text+'%') );
  QRNC.SQL.Add('order by razon_social');
  QRNC.Open;
  DBGrid1.SetFocus;
end;

procedure TfrmBuscaRNC.DBGrid1DblClick(Sender: TObject);
begin
  seleccion := 1;
  close;
end;

procedure TfrmBuscaRNC.FormCreate(Sender: TObject);
begin
  seleccion := 0;
  memo1.lines := qrnc.sql;
end;

end.

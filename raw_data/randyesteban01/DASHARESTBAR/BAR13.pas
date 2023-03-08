unit BAR13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Buttons, StdCtrls, Mask, DBCtrls;

type
  TfrmOferta = class(TForm)
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    QOferta: TADOQuery;
    QOfertaProductoID: TIntegerField;
    QOfertaCantidadVendida: TFloatField;
    QOfertaCantidadOferta: TFloatField;
    QOfertaPrecioOferta: TBCDField;
    dsOferta: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label1: TLabel;
    DBEdit3: TDBEdit;
    QOfertaOfertaID: TIntegerField;
    procedure btcloseClick(Sender: TObject);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure QOfertaBeforePost(DataSet: TDataSet);
    procedure QOfertaNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    Prod : integer;
  end;

var
  frmOferta: TfrmOferta;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmOferta.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOferta.btpostClick(Sender: TObject);
begin
  QOferta.Post;
  QOferta.UpdateBatch;
  Close;
end;

procedure TfrmOferta.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

procedure TfrmOferta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f2  then btpostClick(Self);
end;

procedure TfrmOferta.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmOferta.QOfertaBeforePost(DataSet: TDataSet);
begin
  if QOferta.State = dsInsert then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(OfertaID) as maximo');
    dm.Query1.SQL.Add('from Ofertas');
    dm.Query1.SQL.Add('where ProductoID = :pro');
    dm.Query1.Parameters.ParamByName('pro').Value := Prod;
    dm.Query1.Open;
    QOfertaOfertaID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
  end;
end;

procedure TfrmOferta.QOfertaNewRecord(DataSet: TDataSet);
begin
  QOfertaProductoID.Value := Prod;
end;

end.

unit POS20;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, DB, ADODB, Buttons;

type
  TfrmVerPrecio = class(TForm)
    StaticText1: TStaticText;
    edproducto: TEdit;
    DBText1: TDBText;
    QProductos: TADOQuery;
    QProductospro_nombre: TStringField;
    QProductospro_precio1: TBCDField;
    DBText2: TDBText;
    dsProductos: TDataSource;
    btsalir: TBitBtn;
    btfacturar: TSpeedButton;
    procedure edproductoKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btsalirClick(Sender: TObject);
    procedure btfacturarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    facturar : boolean;
    prod : string;
  end;

var
  frmVerPrecio: TfrmVerPrecio;

implementation

uses POS01;

{$R *.dfm}

procedure TfrmVerPrecio.edproductoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    QProductos.Close;
    QProductos.Parameters.ParamByName('pro').Value := Trim(edproducto.Text);
    QProductos.Open;
    if QProductos.RecordCount = 0 then
      MessageDlg('ESTE PRODUCTO NO EXISTE',mtError,[mbok],0)
    else
      Prod := Trim(edproducto.Text);
      
    edproducto.SetFocus;
    edproducto.Text := '';
  end;
end;

procedure TfrmVerPrecio.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then close;
  if key = vk_f2     then btfacturarClick(self); 
end;

procedure TfrmVerPrecio.btsalirClick(Sender: TObject);
begin
  close;
end;

procedure TfrmVerPrecio.btfacturarClick(Sender: TObject);
begin
  facturar := true;
  close;
end;

procedure TfrmVerPrecio.FormCreate(Sender: TObject);
begin
  facturar := false;
end;

end.

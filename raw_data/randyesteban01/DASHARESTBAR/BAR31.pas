unit BAR31;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, DBGrids, DB, ADODB;

type
  TfrmReimpresion = class(TForm)
    btclose: TSpeedButton;
    DBGrid1: TDBGrid;
    QVentas: TADOQuery;
    QVentasNombre: TWideStringField;
    QVentasFacturaID: TIntegerField;
    QVentasFecha: TDateTimeField;
    QVentasExento: TBCDField;
    QVentasGrabado: TBCDField;
    QVentasItbis: TBCDField;
    QVentasDescuento: TBCDField;
    QVentasPropina: TBCDField;
    QVentasTotal: TBCDField;
    QVentasEstatus: TWideStringField;
    QVentasNCF: TWideStringField;
    QVentasCuadrada: TBooleanField;
    QVentasrnc: TWideStringField;
    QVentasCliente: TWideStringField;
    QVentasCajaID: TIntegerField;
    QVentasCajeroID: TIntegerField;
    QVentasHora: TDateTimeField;
    QVentasForma: TWideStringField;
    QVentasPagado: TBCDField;
    QVentasDevuelta: TBCDField;
    QVentastipo_Tarjeta: TWideStringField;
    QVentasAutorizacion: TWideStringField;
    QVentasNumero_Tarjeta: TWideStringField;
    QVentasBanco: TWideStringField;
    dsVentas: TDataSource;
    SpeedButton3: TSpeedButton;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReimpresion: TfrmReimpresion;

implementation

{$R *.dfm}

procedure TfrmReimpresion.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReimpresion.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
end;

procedure TfrmReimpresion.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1' + #13 + 'SALIR';
end;

end.

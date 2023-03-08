unit BAR70;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Printers, StdCtrls, Buttons, DB, ADODB;

type
  TFrmSeleccionarImpresora = class(TForm)
    btclose: TSpeedButton;
    btaceptar: TSpeedButton;
    ComboBox1: TComboBox;
    QPrinter_Remoto: TADOQuery;
    QPrinter_RemotoIDPRINTER: TAutoIncField;
    QPrinter_RemotoDescripcion: TWideStringField;
    QPrinter_RemotoPath_Printer: TWideStringField;
    QPrinter_Remotonombre_printer: TWideStringField;
    dsPrinterRemoto: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    function GetDefaultPrinter: string;
    function impresoraDefecto : string;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
     Acepto : Integer;

    { Public declarations }
  end;

var
  FrmSeleccionarImpresora: TFrmSeleccionarImpresora;

implementation

{$R *.dfm}

procedure TFrmSeleccionarImpresora.FormCreate(Sender: TObject);
var i,x: integer; default : string;  cc : integer ;
begin
ComboBox1.Clear;

{if not QPrinter_Remoto.Active then QPrinter_Remoto.Open;
While not QPrinter_Remoto.Eof do
begin
Combobox1.Items.Add(QPrinter_Remoto.Fields[1].Text);
QPrinter_Remoto.Next;
end;   }

for i := 0 to Printer.Printers.Count - 1 do
ComboBox1.Items.Add(Printer.Printers[i]);
default := impresoraDefecto;

 for cc := 0 to ComboBox1.Items.Count -1
  do
    if ComboBox1.Items [cc] =default
      then
        begin  ComboBox1.Itemindex := cc ;
          break ;
        end ;
end;

function TFrmSeleccionarImpresora.impresoraDefecto : string;
var impresora : string;

begin
  if (Printer.PrinterIndex > 0) then
  begin
   result := Printer.Printers [Printer.PrinterIndex];
    //result :=  impresora;
    end
  else
    Result := 'No hay impresora por defecto';
end;


function TFrmSeleccionarImpresora.GetDefaultPrinter: string;
var
  ResStr: array[0..255] of Char;
begin
  GetProfileString('Windows', 'device', '', ResStr, 255);
  Result := StrPas(ResStr);
end;

procedure TFrmSeleccionarImpresora.ListBox1DblClick(Sender: TObject);
begin
btaceptarClick(self);
end;

procedure TFrmSeleccionarImpresora.btaceptarClick(Sender: TObject);
begin
  Acepto := 1;
  Close;
end;

procedure TFrmSeleccionarImpresora.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TFrmSeleccionarImpresora.FormActivate(Sender: TObject);
begin
// if not QPrinter_Remoto.Active then QPrinter_Remoto.Open;
end;

end.

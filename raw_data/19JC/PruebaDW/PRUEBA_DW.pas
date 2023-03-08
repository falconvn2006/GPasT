unit PRUEBA_DW;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  Data.SqlExpr, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Menus;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    edtNum: TEdit;
    btnCalcular: TButton;
    edtResul: TEdit;
    Label2: TLabel;
    btnCalcularSal: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtNombre: TEdit;
    edtApellido: TEdit;
    edtHoras: TEdit;
    Crud: TTabSheet;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    TabSheet3: TTabSheet;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    DBGrid3: TDBGrid;
    DBNavigator3: TDBNavigator;
    DBGrid6: TDBGrid;
    DBNavigator6: TDBNavigator;
    procedure btnCalcularClick(Sender: TObject);
    procedure btnCalcularSalClick(Sender: TObject);
  private
    function Fibonacci(pInNumero,pInNumInic,pInNumFina,pInNumSuma,pInCont:integer;
                       pStCadena:String):String;
    procedure CalcularSalario(pStNombre,pStApellido:String;
                              pDoHoras:Double);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2;

{ TForm1 }

procedure TForm1.btnCalcularClick(Sender: TObject);
var
lInNumero:integer;
lStCadena:String;

begin
  try
     lInNumero:=StrToInt(edtNum.Text);
  Except
    raise Exception.Create('Por favor un numero valido');
  end;

   if not (lInNumero > 0) then
     raise Exception.Create('Numero debe ser mayor a 0');

    lStCadena:='';


    edtResul.Text := Fibonacci(lInNumero,1,1,0,1,lStCadena);
end;

procedure TForm1.btnCalcularSalClick(Sender: TObject);
var
lDoHoras:Double;

begin

  if  (edtNombre.Text = '') or (edtApellido.Text = '') or (edtHoras.Text = '') then
  raise Exception.Create('Los campos son obligatorios, por favor ingresar datos');

  try
    lDoHoras:=StrToFloat(edtHoras.Text);
  except
    raise Exception.Create('El valor debe ser numerico');
  end;

  if not (lDoHoras > 0) then
  raise Exception.Create('las horas ingresadas deben ser mayor a 0');

  CalcularSalario(edtNombre.Text,edtApellido.Text,lDoHoras);
end;

procedure TForm1.CalcularSalario(pStNombre, pStApellido: String;
  pDoHoras: Double);
var
  lDoResultado,lDoResta:double;
Const
  Cvalsal1=15000;
  Cvalsal2=19000;
begin
  if pDoHoras <= 35 then
    lDoResultado := Cvalsal1 * pDoHoras
  else
  begin
    lDoResta := pDoHoras - 35;
    lDoResultado := Cvalsal1 * 35;
    lDoResultado := lDoResultado + (lDoResta * Cvalsal2);
  end;

  ShowMessage('Al Empleado ' + pStNombre + ' ' + pStApellido +' se le debe pagar la suma de ' + FloatToStr(lDoResultado));
end;

function TForm1.Fibonacci(pInNumero,pInNumInic,pInNumFina,pInNumSuma,pInCont:integer;pStCadena:String): String;
begin
    if pInCont <= pInNumero then
    begin
      pInNumInic := pInNumfina;
      pInNumFina := pInNumSuma;
      pInNumSuma := pInNumInic + pInNumFina;

      pStCadena := pStCadena + IntToStr(pInNumSuma) + ', ';



    end;

    if pInCont < pInNumero then
    begin
      pInCont := pInCont+1 ;
      pStCadena := Fibonacci(pInNumero,pInNumInic,pInNumFina,pInNumSuma,pInCont,pStCadena);
    end;

    result := pStCadena;

end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, Unit2, pngimage, ExtCtrls, Menus, Vcl.Tabs,
  Vcl.DockTabSet, Vcl.CustomizeDlg, System.TypInfo, Soap.WebServExp,
  Soap.WSDLBind, Xml.XMLSchema, Soap.WSDLPub;

type
  TForm1 = class(TForm)
    Label3: TLabel;
    Image1: TImage;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Object1: TMenuItem;
    Links1: TMenuItem;
    N3: TMenuItem;
    GoTo1: TMenuItem;
    Replace1: TMenuItem;
    Find1: TMenuItem;
    N4: TMenuItem;
    PasteSpecial1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    N5: TMenuItem;
    Repeatcommand1: TMenuItem;
    Undo1: TMenuItem;
    Window1: TMenuItem;
    Show1: TMenuItem;
    Hide1: TMenuItem;
    N6: TMenuItem;
    ArrangeAll1: TMenuItem;
    Cascade1: TMenuItem;
    ile1: TMenuItem;
    NewWindow1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    SearchforHelpOn1: TMenuItem;
    Contents1: TMenuItem;
    Datos1: TMenuItem;
    Productos1: TMenuItem;
    Clientes1: TMenuItem;
    Empleados1: TMenuItem;
    Facturas1: TMenuItem;
    Proveedores1: TMenuItem;
    Image3: TImage;
    Label1: TLabel;
    Label5: TLabel;
    Config: TImage;
    Image2: TImage;
    Image4: TImage;
    Inventario1: TMenuItem;
    Crear1: TMenuItem;
    procedure Productos1Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Empleados1Click(Sender: TObject);
    procedure Facturas1Click(Sender: TObject);
    procedure Proveedores1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure HowtoUseHelp1Click(Sender: TObject);
    procedure SearchforHelpOn1Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure CloseAll(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoginWindowOpen(Sender: TObject);
    procedure Crear1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit3, Unit4, Unit5, Unit6, Unit7, Unit9, Unit10;

{$R *.dfm}

procedure TForm1.LoginWindowOpen(Sender: TObject);
begin
  Form10.Show;
  //Form1.Hide;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Constraints.MinWidth := 800;
  Constraints.MaxWidth := 800;
  Constraints.MinHeight := 660;
  Constraints.MaxHeight := 660;
//  Form10.Show;
//  Form1.Hide;
end;
procedure TForm1.CloseAll(Sender: TObject);
begin
  Form2.Close;
  Form3.Close;
  Form4.Close;
  Form5.Close;
  Form6.Close;
  Help.Close;
  Form9.Close;
end;

procedure TForm1.Crear1Click(Sender: TObject);
begin
	Form2.Show;
end;

procedure TForm1.Clientes1Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.Empleados1Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.Facturas1Click(Sender: TObject);
begin
  Form5.Show;
end;

procedure TForm1.HowtoUseHelp1Click(Sender: TObject);
begin
  Help.Show;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  Form9.Show;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  if MessageDlg('Estas seguro que deseas salir?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Form1.Close;
  end
  else
  begin
    // nothing lol
  end;

end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  Help.Show;
end;

procedure TForm1.Productos1Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Proveedores1Click(Sender: TObject);
begin
  Form6.Show;
end;

procedure TForm1.SearchforHelpOn1Click(Sender: TObject);
begin
  Help.Show;
end;

end.

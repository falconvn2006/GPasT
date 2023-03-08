unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, System.WideStrings, System.StrUtils, Winapi.MMSystem,
  Vcl.Menus;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    TextCitID: TEdit;
    TextName: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    TextID: TEdit;
    Label5: TLabel;
    TextDirection: TEdit;
    Label6: TLabel;
    TextMail: TEdit;
    Image2: TImage;
    Image8: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image1: TImage;
    Label7: TLabel;
    Edit2: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    ProductTax: TLabel;
    CheckBox1: TCheckBox;
    Label11: TLabel;
    TextPhone: TEdit;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ADOQuery1: TADOQuery;
    Image3: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Archivo1: TMenuItem;
    Borrar1: TMenuItem;
    Duplicar1: TMenuItem;
    Imprimir1: TMenuItem;
    Abrir1: TMenuItem;
    N2: TMenuItem;
    Ventana1: TMenuItem;
    Limpiar1: TMenuItem;
    Guardar1: TMenuItem;
    Ayuda1: TMenuItem;
    AyudaenLinea1: TMenuItem;
    AbrirelManual1: TMenuItem;
    N3: TMenuItem;
    Buscar1: TMenuItem;
    N4: TMenuItem;
    Cerrar1: TMenuItem;
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure NewIDQuery(Sender: TObject);
    procedure CleanAll(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
uses Unit1, Unit10;

{$R *.dfm}
procedure TForm3.FormCreate(Sender: TObject);
begin
	Form1.Hide;
	Form3.Hide;
	Form10.Show;
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
  CleanAll(NIL);
  Form3.Close;
  Form1.Show;
end;

procedure TForm3.NewIDQuery(Sender: TObject);
var
  NextID: Integer;
  SQL: string;
  Query: TADOQuery;
begin
	CleanAll(NIL);
  Query:=TADOQuery.Create(nil);
  Query.ConnectionString := Form3.ADOConnection1.ConnectionString;
  try
    SQL := 'SELECT MAX(CLId) + 1 AS NextID FROM Clientes';
    Query.SQL.Text := SQL;
    Query.Open;
    NextID := Query.FieldByName('NextID').AsInteger;
    TextID.Text := IntToStr(NextID);
  finally
    Query.Free;
    Playsound('SystemAsterisk',0, SND_ALIAS or SND_ASYNC);
    TextName.SetFocus;
  end;
end;

procedure TForm3.CleanAll(Sender: TObject);
begin
	TextID.Text := '';
  TextName.Text := '';
  TextCitID.Text := '';
  TextDirection.Text := '';
  TextPhone.Text := '';
  TextMail.Text := '';
end;
{procedure TForm3.Image3Click(Sender: TObject);
begin
var
  NextID: Integer;
  SQL: string('');
  Query: TADOQuery;
begin
	Query:=TADOQuery.Create(nil);
  Query.ConnectionString := Form3.ADOConnection1.ConnectionString;
	try
    SQL := 'SELECT MAX(CLId) + 1 AS NextID FROM Clientes';
    Query.SQL.Text := SQL;

    Query.Open;
    NextID := Query.FieldByName('NextID').AsInteger;

    TextID.Text := IntToStr(NextID);
  finally
  	Query.Free;

  end;
end;

end;}

procedure TForm3.Image8Click(Sender: TObject);
begin
  ADOTable1.Append;
  //ADOTable1.FieldByName('CLId').AsInteger := StrToInt(TextID.Text);
  ADOTable1.FieldByName('CLName').AsString := TextName.Text;
  ADOTable1.FieldByName('CLCitizenId').AsString := TextCitID.Text;
  ADOTable1.FieldByName('CLDirection').AsString := TextDirection.Text;
  ADOTable1.FieldByName('CLPhoneNumber').AsString := TextPhone.Text;
  ADOTable1.FieldByName('CLMail').AsString := TextMail.Text;
  ADOTable1.Post;
  CleanAll(NIL);
end;

end.

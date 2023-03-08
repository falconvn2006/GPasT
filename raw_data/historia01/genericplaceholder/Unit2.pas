unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls, Data.DB, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ProductName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    ProductBrand: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ProductTax: TLabel;
    Image2: TImage;
    CheckBox1: TCheckBox;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Edit3: TEdit;
    Label11: TLabel;
    Edit4: TEdit;
    Label12: TLabel;
    ComboBox1: TComboBox;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Edit5: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form2.Close;
  Form1.Show;
end;

procedure TForm2.Image2Click(Sender: TObject);
begin
  Form2.Close;
  Form1.Show;
end;

end.

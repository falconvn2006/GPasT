unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    ProductBrand: TEdit;
    ProductName: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    ProductFabDate: TEdit;
    Label6: TLabel;
    Image2: TImage;
    Image3: TImage;
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
    Label11: TLabel;
    Edit3: TEdit;
    Label12: TLabel;
    Edit4: TEdit;
    Label13: TLabel;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    ComboBox2: TComboBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    ComboBox4: TComboBox;
    Label17: TLabel;
    Edit6: TEdit;
    DateTimePicker2: TDateTimePicker;
    Edit5: TEdit;
    Label18: TLabel;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation
uses Unit1;

{$R *.dfm}

procedure TForm4.Image2Click(Sender: TObject);
begin
  Form4.Close;
  Form1.Show;
end;

end.

unit OrderEditorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.DBCtrls, Vcl.ExtCtrls, DataModuleUnit, Vcl.ComCtrls;

type
  TOrderEditor = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBText1: TDBText;
    Label4: TLabel;
    OrderDateTimePicker: TDateTimePicker;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure OrderDateTimePickerChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrderEditor: TOrderEditor;

implementation


{$R *.dfm}

procedure TOrderEditor.BitBtn1Click(Sender: TObject);
begin
  DataModule1.OrderTable.Post;
end;

procedure TOrderEditor.BitBtn2Click(Sender: TObject);
begin
  DataModule1.OrderTable.Cancel;
end;

procedure TOrderEditor.FormShow(Sender: TObject);
begin
  OrderDateTimePicker.DateTime := DataModule1.OrderTableo_datetime.Value;
end;

procedure TOrderEditor.OrderDateTimePickerChange(Sender: TObject);
begin
  DataModule1.OrderTableo_datetime.Value := OrderDateTimePicker.DateTime;
end;

end.

unit Unit2;

{$mode objfpc}{$H+}
{
       Criado por Amaury Carvalho (amauryspires@gmail.com), 2019
}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, MaskEdit, MegaIni;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    FileNameEdit1: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MaskEdit1: TMaskEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormShow(Sender: TObject);
var
  oIni: TMegaIni;
begin
  oIni := TMegaIni.Create;
  DirectoryEdit1.Directory := oIni.TempPath;
  FileNameEdit1.FileName := oIni.WGetPath;
  Edit1.Text := oIni.ImportURL;
  Edit2.Text := oIni.ImportFileName;
  if oIni.ImportMode = '0' then
    RadioButton1.Checked := True
  else
    RadioButton2.Checked := True;
  if oIni.BetsIgnoreLastHistory = 0 then
    CheckBox1.Checked := False
  else
    CheckBox1.Checked := True;
  MaskEdit1.Text := IntToStr(oIni.BetsMaxSearch);
  oIni.Free;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

procedure TForm2.FormDestroy(Sender: TObject);
begin

end;

procedure TForm2.Button1Click(Sender: TObject);
var
  oIni: TMegaIni;
begin
  oIni := TMegaIni.Create;

  oIni.TempPath := DirectoryEdit1.Directory;
  oIni.WGetPath := FileNameEdit1.FileName;
  oIni.ImportURL := Edit1.Text;
  oIni.ImportFileName := Edit2.Text;
  oIni.BetsMaxSearch := StrToInt(Trim(MaskEdit1.Text));
  if CheckBox1.Checked then
    oIni.BetsIgnoreLastHistory := 1
  else
    oIni.BetsIgnoreLastHistory := 0;
  if RadioButton1.Checked then
    oIni.ImportMode := '0'
  else
    oIni.ImportMode := '1';
  oIni.Save;

  oIni.Free;

  Close;
end;

end.



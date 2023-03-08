unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    BtnPrint: TButton;
    CheckBox1: TCheckBox;
    CbxPortType: TComboBox;
    CbxDevicePath: TComboBox;
    EdtDisplayPath: TEdit;
    EdtDevicePath: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BtnPrintClick(Sender: TObject);
    procedure CbxPortTypeChange(Sender: TObject);
    procedure CbxDevicePathChange(Sender: TObject);
    procedure EdtDisplayPathChange(Sender: TObject);
    procedure EdtDevicePathChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uPrinter, uDriverPrinter, uDevice, uHexToStr, fpjson, LConvEncoding;

{$R *.lfm}

{ TfrmMain }


procedure TfrmMain.BtnPrintClick(Sender: TObject);
var
  prt: IPrinter;
  PortType, DevicePath, Content: string;
begin
  PortType := CbxPortType.Items[CbxPortType.ItemIndex];
  if EdtDevicePath.Visible then
    DevicePath := EdtDevicePath.Text
  else
    DevicePath := TJSONString(CbxDevicePath.Items.Objects[CbxDevicePath.ItemIndex]).AsString;
  if CheckBox1.Checked then
    Content := UTF8ToCP936(HexToString(Memo1.Lines.Text))
  else
    Content := UTF8ToCP936(Memo1.Lines.Text);
  prt := TPrinterCreateFactory.CreatePrinter(PortType);
  prt.Print(DevicePath, Content);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  CbxPortType.Items.Clear;
  CbxPortType.Items.Add('-- 设备类型 --');
  CbxPortType.Items.Add('LPT');
  CbxPortType.Items.Add('COM');
  CbxPortType.Items.Add('USB');
  CbxPortType.Items.Add('DRIVER');
  CbxPortType.Items.Add('NETWORK');
  CbxPortType.ItemIndex := 0;

  CbxDevicePath.Items.Clear;
  CbxDevicePath.Items.Add('-- 选择设备 --');
  CbxDevicePath.ItemIndex := 0;

  Memo1.Lines.Clear;
  EdtDisplayPath.Text := EmptyStr;
  EdtDevicePath.Text := '192.168.53.250';
  EdtDevicePath.Visible := False;
  CbxDevicePath.Visible := True;
end;

procedure TfrmMain.CbxPortTypeChange(Sender: TObject);
var
  PRT: IPrinter;
  DeviceArray: IDeviceArray;
  Device: IDevice;
begin
  EdtDisplayPath.Text := EmptyStr;
  CbxDevicePath.Items.Clear;
  CbxDevicePath.Items.Add('-- 选择设备 --');
  if CbxPortType.ItemIndex <= 0 then
  begin
    CbxDevicePath.ItemIndex := 0;
    Exit;
  end;
  if CbxPortType.ItemIndex = 5 then
  begin
    CbxDevicePath.Visible := False;
    EdtDevicePath.Visible := True;
    EdtDevicePath.SelectAll;
    EdtDevicePath.SetFocus;
    Exit;
  end;
  CbxDevicePath.Visible := True;
  EdtDevicePath.Visible := False;
  if CbxPortType.ItemIndex = 3 then
  begin
    CbxDevicePath.Items.AddObject('-- 得实 --', TJSONString.Create('DASCOM'));
    CbxDevicePath.Items.AddObject('-- 实达 --', TJSONString.Create('START'));
    CbxDevicePath.Items.AddObject('-- 映美 --', TJSONString.Create('Jolimark'));
    CbxDevicePath.Items.AddObject('-- 爱普生 --', TJSONString.Create('EPSON'));
  end;
  PRT := TPrinterCreateFactory.CreatePrinter(CbxPortType.Items[CbxPortType.ItemIndex]);
  DeviceArray := PRT.GetAllPrinter;
  for Device in DeviceArray do
  begin
    CbxDevicePath.Items.AddObject(AnsiToUtf8(Device.DisplayName), TJSONString.Create(Device.DevicePath));
  end;
  CbxDevicePath.ItemIndex := 0;
end;

procedure TfrmMain.CbxDevicePathChange(Sender: TObject);
var
  jItem: TJSONString;
begin
  EdtDisplayPath.Text := EmptyStr;
  BtnPrint.Enabled := CbxDevicePath.ItemIndex > 0;
  if CbxDevicePath.ItemIndex > 0 then
  begin
    jItem := TJSONString(CbxDevicePath.Items.Objects[CbxDevicePath.ItemIndex]);
    EdtDisplayPath.Text := jItem.AsString;
  end;
end;

procedure TfrmMain.EdtDisplayPathChange(Sender: TObject);
begin
  BtnPrint.Enabled := EdtDisplayPath.Text <> EmptyStr;
end;

procedure TfrmMain.EdtDevicePathChange(Sender: TObject);
begin
  EdtDisplayPath.Text := EdtDevicePath.Text;
end;

end.

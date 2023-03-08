unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ToolWin, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    MasterData1: TMenuItem;
    ransaksiData1: TMenuItem;
    Reporting1: TMenuItem;
    Barang1: TMenuItem;
    Supplier1: TMenuItem;
    Customer1: TMenuItem;
    Unit1: TMenuItem;
    Pembelian1: TMenuItem;
    Penjualan1: TMenuItem;
    ReportPenjualan1: TMenuItem;
    ReportPembelian1: TMenuItem;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    Image1: TImage;
    User1: TMenuItem;
    ActionList1: TActionList;
    Barang: TAction;
    Supplier: TAction;
    Customer: TAction;
    UnitOfMeasurement: TAction;
    User: TAction;
    Pembelian: TAction;
    Penjualan: TAction;
    ReportPenjualan: TAction;
    ReportPembelian: TAction;
    ImageList1: TImageList;
    ToolButton11: TToolButton;
    procedure Barang1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure Customer1Click(Sender: TObject);
    procedure Unit1Click(Sender: TObject);
    procedure Pembelian1Click(Sender: TObject);
    procedure ReportPembelian1Click(Sender: TObject);
    procedure User1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Penjualan1Click(Sender: TObject);
    procedure ReportPenjualan1Click(Sender: TObject);
    procedure PenjualanExecute(Sender: TObject);
    procedure ReportPenjualanExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    vUsers : String;
    vUsername:String;
    function GetNumberSequencePO(sValue : String):String;
    function GetNumberSequenceSO(sValue : String):String;
  end;

var
  frmMain: TfrmMain;

implementation
 Uses UDM, UBarang, UCustomer, Usupplier, UUnit, UPembelian,UPurchaseReport,UUsers,ULogin,UPenjualan,USalesReport;
{$R *.dfm}
function TfrmMain.GetNumberSequencePO(sValue: string):String ;
begin
  //ambil store procedure
  DM.FDStoredProcPO.Close;
  DM.FDStoredProcPO.prepare;
  DM.FDStoredProcPO.StoredProcName :='POS.dbo.GetNumberSequence';
  DM.FDStoredProcPO.ParamByName('@Param').Value:= sValue;
  DM.FDStoredProcPO.Open;

  Result := DM.FDStoredProcPO.Fields[0].AsString;
end;
function TfrmMain.GetNumberSequenceSO(sValue: string):String ;
begin
  //ambil store procedure
  DM.FDStoredProcSO.Close;
  DM.FDStoredProcSO.prepare;
  DM.FDStoredProcSO.StoredProcName :='POS.dbo.GetNumberSequence';
  DM.FDStoredProcSO.ParamByName('@Param').Value:= sValue;
  DM.FDStoredProcSO.Open;

  Result := DM.FDStoredProcSO.Fields[0].AsString;
end;

procedure TfrmMain.Barang1Click(Sender: TObject);
begin
   if frmBarang = nil then
    begin
      Application.CreateForm(TfrmBarang,frmBarang);
      frmBarang.Show;
    end;

end;

procedure TfrmMain.Customer1Click(Sender: TObject);
begin
    if frmCustomer = nil then
    begin
      Application.CreateForm(TfrmCustomer,frmCustomer);
      frmCustomer.Show;
    end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
I : Integer;
begin
    for I := 0 to ActionList1.ActionCount - 1 do
    begin
      ActionList1.Actions[i].Visible := False;
    end;

     if frmLogin = nil then
    begin
      Application.CreateForm(TfrmLogin,frmLogin);
      frmLogin.Show;
    end;


end;

procedure TfrmMain.Pembelian1Click(Sender: TObject);
begin
  if frmPembelian = nil then
    begin
      Application.CreateForm(TfrmPembelian,frmPembelian);
      frmPembelian.Show;
    end;
end;

procedure TfrmMain.Penjualan1Click(Sender: TObject);
begin
     if frmPenjualan = nil then
    begin
      Application.CreateForm(TfrmPenjualan,frmPenjualan);
      frmPenjualan.Show;
    end;
end;

procedure TfrmMain.PenjualanExecute(Sender: TObject);
begin
     begin
     if frmPenjualan = nil then
    begin
      Application.CreateForm(TfrmPenjualan,frmPenjualan);
      frmPenjualan.Show;
    end;
end;
end;

procedure TfrmMain.ReportPembelian1Click(Sender: TObject);
begin
    if frmReportPurchase = nil then
    begin
      Application.CreateForm(TfrmReportPurchase,frmReportPurchase);
      frmReportPurchase.Show;
    end;
end;

procedure TfrmMain.ReportPenjualan1Click(Sender: TObject);
begin
 if frmReportSales = nil then
    begin
      Application.CreateForm(TfrmReportSales,frmReportSales);
      frmReportSales.Show;
    end;
end;

procedure TfrmMain.ReportPenjualanExecute(Sender: TObject);
begin
    if frmReportSales = nil then
    begin
      Application.CreateForm(TfrmReportSales,frmReportSales);
      frmReportSales.Show;
    end;

end;

procedure TfrmMain.Supplier1Click(Sender: TObject);
begin
  if frmSupplier = nil then
    begin
      Application.CreateForm(TfrmSupplier,frmSupplier);
      frmSupplier.Show;
    end;
end;

procedure TfrmMain.Unit1Click(Sender: TObject);
begin
if frmUnit = nil then
    begin
      Application.CreateForm(TfrmUnit,frmUnit);
      frmUnit.Show;
    end;
end;

procedure TfrmMain.User1Click(Sender: TObject);
begin
if frmUsers = nil then
    begin
      Application.CreateForm(TfrmUsers,frmUsers);
      frmUsers.Show;
    end;
end;

end.

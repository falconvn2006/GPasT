unit UPurchaseReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.ExtCtrls, RzPanel,
  Vcl.StdCtrls, Vcl.Mask, RzEdit, RzLabel, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, frxClass, frxDBSet;

type
  TfrmReportPurchase = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    RzBtnPrint: TRzBitBtn;
    RzBtnClose: TRzBitBtn;
    RzLabel1: TRzLabel;
    RzDateFrom: TRzDateTimeEdit;
    RzDateTo: TRzDateTimeEdit;
    RzLabel2: TRzLabel;
    DataSource1: TDataSource;
    frxDBDataset1: TfrxDBDataset;
    frxReport1: TfrxReport;
    FDQuReport: TFDQuery;
    procedure RzBtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzBtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReportPurchase: TfrmReportPurchase;

implementation
  Uses UDM,UPembelian;
{$R *.dfm}

procedure TfrmReportPurchase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  WindowState := wsMinimized;
  frmReportPurchase := Nil;
  Action := caFree;
end;

procedure TfrmReportPurchase.RzBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReportPurchase.RzBtnPrintClick(Sender: TObject);
var
wPath : String;
begin

  wPath := ExtractFilePath(Application.ExeName);
  with FDQuReport do
  begin
    sql.Clear;
    sql.Add('SELECT * from vPurchase where PURCHASEDATE BETWEEN :A AND :B');
    Params[0].AsDateTime := RzDateFrom.AsDateTime;
    Params[1].AsDateTime := RzDateTo.AsDateTime;
    open;
  end;

  with frxReport1 do
  begin
    LoadFromFile(wPath + 'rptPurchaseReport.fr3');
    TfrxMemoView(frxReport1.FindComponent('MemoPeriode')).Text := 'Periode : '+ FormatDateTime('dd/mm/yyyy',RzDateFrom.AsDateTime) + ' to '+FormatDateTime('dd/mm/yyyy',RzDateTo.AsDateTime);
    ShowReport();
  end;

end;

end.

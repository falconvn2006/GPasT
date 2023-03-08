unit UPenjualan;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTransaksiData, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, SMDBGrid, RzTabs, RzPanel, RzDBNav, Vcl.ExtCtrls,
  RzButton, frxClass, frxDBSet, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmPenjualan = class(TFrmTransaksiData)
    FDQueryDetailITEMID: TWideStringField;
    FDQueryDetailQTY: TFMTBCDField;
    FDQueryDetailUNIT: TWideStringField;
    FDQueryDetailPRICE: TFMTBCDField;
    FDQueryDetailLINEAMOUNT: TFMTBCDField;
    FDQueryDetailRECORDID: TLargeintField;
    FDQueryDetailTRANSDATE: TSQLTimeStampField;
    FDQueryDetailUSERID: TWideStringField;
    FDQueryHeaderSALESID: TWideStringField;
    FDQueryHeaderCUSTACCOUNT: TWideStringField;
    FDQueryHeaderSALESDATE: TDateField;
    FDQueryHeaderISPPN: TBooleanField;
    FDQueryHeaderTOTALAMOUNT: TFMTBCDField;
    FDQueryHeaderGRANDTOTAL: TFMTBCDField;
    FDQueryHeaderUSERID: TWideStringField;
    FDQueryHeaderTRANSDATE: TSQLTimeStampField;
    FDQueryHeaderTOPCODE: TWideStringField;
    FDQueryCustomer: TFDQuery;
    DsCustomer: TDataSource;
    RzPanel3: TRzPanel;
    RzBtnAddItem: TRzButton;
    FDQueryItem: TFDQuery;
    DsItem: TDataSource;
    FDQueryDetaillkItemName: TStringField;
    FDQueryHeaderlkCustomerName: TStringField;
    FDQueryDetailSALESID: TWideStringField;
    frxReport2: TfrxReport;
    frxDBDataset2: TfrxDBDataset;
    FDQuReport2: TFDQuery;
    DataSource2: TDataSource;
    BitBtnPrint: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FDQueryHeaderAfterInsert(DataSet: TDataSet);
    procedure FDQueryHeaderNewRecord(DataSet: TDataSet);
    procedure RzBtnAddItemClick(Sender: TObject);
    procedure FDQueryHeaderAfterScroll(DataSet: TDataSet);
    procedure FDQueryDetailAfterPost(DataSet: TDataSet);
    procedure FDQueryDetailQTYChange(Sender: TField);
    procedure FDQueryDetailPRICEChange(Sender: TField);
    procedure BitBtnPrintClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPenjualan: TFrmPenjualan;

implementation

{$R *.dfm}
Uses UDM, UCreateSO, UAddItem, UMain;

procedure TFrmPenjualan.BitBtnPrintClick(Sender: TObject);
var
wPath : String;
begin
  inherited;
  wPath := ExtractFilePath(Application.ExeName);
  with FDQuReport2 do
  begin
    sql.Clear;
    sql.Add('select * from vSales where SALESID =:A');
    Params[0].AsString := FDQueryHeaderSALESID.AsString;
    open;
  end;

  with frxReport2 do
    begin
      LoadFromFile(wPath + 'rptSalesOrder.fr3');

      ShowReport();
    end;
end;

procedure TFrmPenjualan.FDQueryDetailAfterPost(DataSet: TDataSet);
begin
  inherited;
  With DM.FDQuGlobal3 do
    begin
      sql.Clear;
      sql.Add('SELECT SUM (LINEAMOUNT) AS TOTAL FROM SALESDETAIL WHERE SALESID =:A');
      Params[0].AsString := FDQueryHeaderSALESID.AsString;
      open;
    end;

  With DM.FDQuGlobal4 do
    begin
      sql.Clear;
      sql.Add('UPDATE SALESHEADER SET TOTALAMOUNT =:A , GRANDTOTAL =:B WHERE SALESID =:C');
      Params[0].AsFloat := DM.FDQuGlobal3.FieldByName('TOTAL').AsFloat;
    if FDQueryHeaderISPPN.AsBoolean = True then
       Params[1].AsFloat := (DM.FDQuGlobal3.FieldByName('TOTAL').AsFloat * 0.11) + DM.FDQuGlobal3.FieldByName('TOTAL').AsFloat
    else Params[1].AsFloat := DM.FDQuGlobal3.FieldByName('TOTAL').AsFloat;
      Params[2].AsString := FDQueryHeaderSALESID.AsString;
      ExecSQL;
    end;

  FDQueryHeader.RefreshRecord();
end;

procedure TFrmPenjualan.FDQueryDetailPRICEChange(Sender: TField);
begin
  inherited;
  FDQueryDetailLINEAMOUNT.AsFloat := FDQueryDetailQTY.AsFloat * FDQueryDetailPRICE.AsFloat;
end;

procedure TFrmPenjualan.FDQueryDetailQTYChange(Sender: TField);
begin
  inherited;
  FDQueryDetailLINEAMOUNT.AsFloat := FDQueryDetailQTY.AsFloat * FDQueryDetailPRICE.AsFloat;
end;

procedure TFrmPenjualan.FDQueryHeaderAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DM.FDQueryGetRecordId.Active := True;
  FDQueryHeaderSALESDATE.AsDateTime := DM.FDQueryGetRecordId.FieldByName('TRANSDATE').AsDateTime;
  FDQueryHeaderTRANSDATE.AsDateTime := DM.FDQueryGetRecordId.FieldByName('TRANSDATE').AsDateTime;
  FDQueryHeaderTOTALAMOUNT.AsCurrency := 0;
  FDQueryHeaderGRANDTOTAL.AsCurrency := 0;
  FDQueryHeaderISPPN.AsBoolean := True;
  FDQueryHeaderUSERID.AsString := FrmMain.vUsers;
end;

procedure TFrmPenjualan.FDQueryHeaderAfterScroll(DataSet: TDataSet);
begin
  inherited;
  with FDQueryDetail do
    begin
      sql.Clear;
      sql.Add('SELECT * FROM SALESDETAIL WHERE SALESID =:SALESID');
      Params[0].AsString := FDQueryHeaderSALESID.AsString;
      Active := True;
    end;
end;



procedure TFrmPenjualan.FDQueryHeaderNewRecord(DataSet: TDataSet);
begin
  inherited;
  if FrmCreateSalesOrder = nil then
    begin
      Application.CreateForm(TFrmCreateSalesOrder, FrmCreateSalesOrder);
      FrmCreateSalesOrder.Show;
    end;
end;

procedure TFrmPenjualan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  WindowState := wsMinimized;
  FrmPenjualan := Nil;
  Action := caFree;
end;

procedure TFrmPenjualan.FormCreate(Sender: TObject);
begin
  inherited;
  with FDQueryHeader do
    begin
      sql.Clear;
      sql.Add('SELECT * FROM SALESHEADER');
      active := True;
    end;

  with FDQueryDetail do
    begin
      sql.Clear;
      sql.Add('SELECT * FROM SALESDETAIL');
      active := True;
    end;

  with FDQueryCustomer do
    begin
      sql.Clear;
      sql.Add('SELECT * FROM CUSTOMER');
      active := True;
    end;
end;

procedure TFrmPenjualan.RzBtnAddItemClick(Sender: TObject);
begin
  inherited;
  if frmAddItem = nil then
    begin
      Application.CreateForm(TfrmAddItem, frmAddItem);
      frmAddItem.vType := 'SO';
      frmAddItem.vSalesId := FDQueryHeaderSALESID.AsString;
      frmAddItem.Show;
    end;
end;

end.

unit UAddItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, SMDBGrid, RzButton;

type
  TfrmAddItem = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    SMDBGrid1: TSMDBGrid;
    FDQueryItem: TFDQuery;
    DsItem: TDataSource;
    DsAddItem: TDataSource;
    FDQueryAddItem: TFDQuery;
    FDQueryItemITEMID: TWideStringField;
    FDQueryItemITEMNAME: TWideStringField;
    FDQueryItemHARGABELI: TFMTBCDField;
    FDQueryItemHARGAJUAL: TFMTBCDField;
    FDQueryItemUNIT: TWideStringField;
    FDQueryItemMARK: TBooleanField;
    FDStoredAddItem: TFDStoredProc;
    FDStoredAddPurchase: TFDStoredProc;
    FDQueryAddItemITEMID: TWideStringField;
    FDQueryAddItemITEMNAME: TWideStringField;
    FDQueryAddItemHARGABELI: TFMTBCDField;
    FDQueryAddItemHARGAJUAL: TFMTBCDField;
    FDQueryAddItemUNIT: TWideStringField;
    FDQueryAddItemMARK: TBooleanField;
    RzBtnOK: TRzBitBtn;
    FDStoredAddSales: TFDStoredProc;
    RzBtnSalesDetail: TRzBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RzBtnSalesDetailClick(Sender: TObject);
    procedure RzBtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    vType,vPurchaseId,vSalesId: String;

  end;

var
  frmAddItem: TfrmAddItem;

implementation
Uses UDM,Upembelian,Upenjualan,UMain;
{$R *.dfm}

procedure TfrmAddItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 WindowState := wsMinimized;
  frmAddItem := Nil;
  Action := caFree;
end;

procedure TfrmAddItem.FormCreate(Sender: TObject);
begin
//ambil store procedure
  FDStoredAddItem.Close;
  FDStoredAddItem.prepare;
  FDStoredAddItem.StoredProcName :='POS.dbo.InsertSelectItem';
  FDStoredAddItem.ExecProc;

  with FDQueryItem do
  begin
    sql.Clear;
    sql.Add('SELECT * FROM SELECTITEM');
    Active := True;
  end;
end;

procedure TfrmAddItem.RzBtnOKClick(Sender: TObject);
begin
  With FDQueryAddItem do
  begin
    sql.Clear;
    sql.Add('SELECT * FROM SELECTITEM WHERE MARK =:MARK');
    Params[0].AsBoolean := True;
    open;
  end;
  if FDQueryAddItem.RecordCount > 0 then
  begin
      FDQueryAddItem.First;
      while NOT FDQueryAddItem.Eof do
      begin
        //insert ke table purchase detail
        with FDStoredAddPurchase do
        begin
            Close;
            Prepare;
            StoredProcName := 'POS.dbo.InsertPurchaseDetail';
            ParamByName('@UserId').AsString := frmMain.vUsers;
            ParamByName('@PurchaseId').AsString := vPurchaseId;
            ParamByName('@ItemId').AsString := FDQueryAddItem.FieldByName('ITEMID').AsString;
            ParamByName('@Qty').Value := 1.0 ;
            ParamByName('@Unit').AsString := FDQueryAddItem.FieldByName('UNIT').AsString;
            ParamByName('@Price').Value := FDQueryAddItem.FieldByName('HARGABELI').AsFloat;
            ParamByName('@LineAmount').Value := 1.0 * FDQueryAddItem.FieldByName('HARGABELI').AsFloat;
            ExecProc;
            SLEEP(20);
        end;
           FDQueryAddItem.Next;

      end;

       frmPembelian.FDQueryDetail.Refresh;

  end;
    Close;
end;

procedure TfrmAddItem.RzBtnSalesDetailClick(Sender: TObject);
begin
  With FDQueryAddItem do
  begin
    sql.Clear;
    sql.Add('SELECT * FROM SELECTITEM WHERE MARK =:MARK');
    Params[0].AsBoolean := True;
    open;
  end;
  if FDQueryAddItem.RecordCount > 0 then
  begin
      FDQueryAddItem.First;
      while NOT FDQueryAddItem.Eof do
      begin
        //insert ke table sales detail
        with FDStoredAddSales do
        begin
            Close;
            Prepare;
            StoredProcName := 'POS.dbo.InsertSalesDetail';
            ParamByName('@UserId').AsString := frmMain.vUsers;
            ParamByName('@SalesId').AsString := vSalesId;
            ParamByName('@ItemId').AsString := FDQueryAddItem.FieldByName('ITEMID').AsString;
            ParamByName('@Qty').Value := 1.0 ;
            ParamByName('@Unit').AsString := FDQueryAddItem.FieldByName('UNIT').AsString;
            ParamByName('@Price').Value := FDQueryAddItem.FieldByName('HARGABELI').AsFloat;
            ParamByName('@LineAmount').Value := 1.0 * FDQueryAddItem.FieldByName('HARGABELI').AsFloat;
            ExecProc;
            SLEEP(20);

        end;
              FDQueryAddItem.Next;
      end;


            frmPenjualan.FDQueryDetail.Refresh;

  end;
    Close;

end;

end.

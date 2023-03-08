unit UCreateSO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, RzPanel, RzRadChk, RzDBChk,
  Vcl.StdCtrls, Vcl.Mask, RzEdit, RzDBEdit, Vcl.DBCtrls, RzDBCmbo, RzLabel,
  Vcl.ExtCtrls;

type
  TFrmCreateSalesOrder = class(TForm)
    Panel1: TPanel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzDBLookupComboBox1: TRzDBLookupComboBox;
    RzDBDateTimeEdit1: TRzDBDateTimeEdit;
    RzDBCheckBox1: TRzDBCheckBox;
    RzPanel1: TRzPanel;
    btnCancel: TRzBitBtn;
    RzBitOK: TRzBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzBitOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCreateSalesOrder: TFrmCreateSalesOrder;

implementation

{$R *.dfm}
Uses UPenjualan, UDM, UMain;

procedure TFrmCreateSalesOrder.btnCancelClick(Sender: TObject);
begin
  FrmPenjualan.FDQueryHeader.Cancel;
end;

procedure TFrmCreateSalesOrder.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  WindowState := wsMinimized;
  FrmCreateSalesOrder := Nil;
  Action := caFree;
end;

procedure TFrmCreateSalesOrder.RzBitOKClick(Sender: TObject);
begin
  if FrmPenjualan.FDQueryHeaderCUSTACCOUNT.AsString = '' then
    begin
      ShowMessage ('Customer Name tidak boleh kosong..!');
      Abort;
    end;

    // Request Nomor PO dari Server
  FrmPenjualan.FDQueryHeaderSALESID.AsString := FrmMain.GetNumberSequenceSO('SALES');
  FrmPenjualan.FDQueryHeader.Post;

  Close;
end;

end.

unit BAR511;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB, DBCtrls,
  ComCtrls, ToolWin, Mask;

type
  TfrmConfImpFiscal = class(TForm)
    pcFormatosImpresion: TPageControl;
    tbsConfPrinter: TTabSheet;
    GroupBox19: TGroupBox;
    DBGrid7: TDBGrid;
    GroupBox20: TGroupBox;
    Label150: TLabel;
    Label151: TLabel;
    Label152: TLabel;
    DBEdit57: TDBEdit;
    dbeNombre: TDBEdit;
    DBRadioGroup23: TDBRadioGroup;
    DBRadioGroup24: TDBRadioGroup;
    GroupBox23: TGroupBox;
    btnAnterior: TBitBtn;
    btnProximo: TBitBtn;
    btnInsertar: TBitBtn;
    btnEditar: TBitBtn;
    btnBorrar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGrabar: TBitBtn;
    BitBtn15: TBitBtn;
    tbsConfPrinterPC: TTabSheet;
    ToolBar2: TToolBar;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    GroupBox21: TGroupBox;
    Label154: TLabel;
    Label155: TLabel;
    Label157: TLabel;
    Label156: TLabel;
    Label158: TLabel;
    pcname: TDBEdit;
    DBEdit127: TDBEdit;
    dblPrinters: TDBLookupComboBox;
    dbcPuerto: TDBComboBox;
    DBEdit126: TDBEdit;
    dbchksustiruir_copia: TDBCheckBox;
    GroupBox22: TGroupBox;
    DBGrid8: TDBGrid;
    dsPrinters: TDataSource;
    adoPrinters: TADOQuery;
    adoPrinterxPC: TADOQuery;
    adoPrinterxPCID: TAutoIncField;
    adoPrinterxPCNombre_PC: TStringField;
    adoPrinterxPCIDPrinter: TIntegerField;
    adoPrinterxPCPuerto: TStringField;
    adoPrinterxPCVelocidad: TIntegerField;
    adoPrinterxPCcntCopia: TIntegerField;
    adoPrinterxPCPrinterName: TStringField;
    dsadoPrinterxPC: TDataSource;
    btnSalir: TBitBtn;
    BitBtn1: TBitBtn;
    adoPrinterxPCsustiruir_copia: TStringField;
    procedure btcloseClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure adoPrinterxPCNewRecord(DataSet: TDataSet);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure dsadoPrinterxPCDataChange(Sender: TObject; Field: TField);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGrabarClick(Sender: TObject);
    procedure adoPrintersBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfImpFiscal: TfrmConfImpFiscal;

implementation

uses BAR04;




{$R *.dfm}

procedure TfrmConfImpFiscal.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfImpFiscal.btnSalirClick(Sender: TObject);
begin
  close();
end;

procedure TfrmConfImpFiscal.FormCreate(Sender: TObject);
begin
  adoPrinters.open;
  adoPrinterxPC.open;
end;

procedure TfrmConfImpFiscal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  adoPrinters.close;
  adoPrinterxPC.close;
end;

procedure TfrmConfImpFiscal.adoPrinterxPCNewRecord(DataSet: TDataSet);
begin
  DataSet['Velocidad']:=9600;
  DataSet['cntCopia']:=0;
  DataSet['sustiruir_copia']:='N';
end;

procedure TfrmConfImpFiscal.ToolButton15Click(Sender: TObject);
begin
  try
    adoPrinterxPC.Post;
  except
    raise;
  end;
end;

procedure TfrmConfImpFiscal.ToolButton9Click(Sender: TObject);
begin
 adoPrinterxPC.Prior();
end;

procedure TfrmConfImpFiscal.ToolButton10Click(Sender: TObject);
begin
adoPrinterxPC.Next();
end;

procedure TfrmConfImpFiscal.ToolButton11Click(Sender: TObject);
begin
  adoPrinterxPC.Insert();
  pcname.SetFocus();
end;

procedure TfrmConfImpFiscal.ToolButton12Click(Sender: TObject);
begin
  adoPrinterxPC.Edit();
  pcname.SetFocus()
end;

procedure TfrmConfImpFiscal.ToolButton13Click(Sender: TObject);
begin
 adoPrinterxPC.Delete();
end;

procedure TfrmConfImpFiscal.ToolButton14Click(Sender: TObject);
begin
  adoPrinterxPC.Cancel;
end;

procedure TfrmConfImpFiscal.dsadoPrinterxPCDataChange(Sender: TObject;
  Field: TField);
begin
  dbchksustiruir_copia.Visible := dsadoPrinterxPC.DataSet['cntCopia'] > 0;

end;

procedure TfrmConfImpFiscal.btnAnteriorClick(Sender: TObject);
begin
   adoPrinters.Prior;
end;

procedure TfrmConfImpFiscal.btnProximoClick(Sender: TObject);
begin
  adoPrinters.Next;
end;

procedure TfrmConfImpFiscal.btnEditarClick(Sender: TObject);
begin
 adoPrinters.Edit;
end;

procedure TfrmConfImpFiscal.btnCancelarClick(Sender: TObject);
begin
   adoPrinters.Cancel;
end;

procedure TfrmConfImpFiscal.btnGrabarClick(Sender: TObject);
begin
   if adoPrinters.State = dsInsert then
   adoPrinters['IDPrinter']:= dm.getSecuencia('Printers','IDPrinter');

 adoPrinters.Post;
end;

procedure TfrmConfImpFiscal.adoPrintersBeforeOpen(DataSet: TDataSet);
begin
adoPrinters.Parameters.ParamByName('emp_codigo').Value := DM.QEmpresaEmpresaID.Value;
end;

end.

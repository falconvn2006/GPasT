unit BAR64;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, DBCtrls, Mask;

type
  TfrmActClientes = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    QClientes: TADOQuery;
    dsClientes: TDataSource;
    QClientesClienteID: TAutoIncField;
    QClientesNombre: TWideStringField;
    QClientesDireccion: TMemoField;
    QClientesTelefono1: TWideStringField;
    QClientesTelefono2: TWideStringField;
    QClientesEstatus: TWideStringField;
    QClientesBalance: TBCDField;
    QClientesLimite: TBCDField;
    QClientesRNC: TWideStringField;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBMemo1: TDBMemo;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    DBEdit6: TDBEdit;
    Label8: TLabel;
    DBEdit7: TDBEdit;
    Label9: TLabel;
    DBEdit8: TDBEdit;
    Panel2: TPanel;
    DBComboBox1: TDBComboBox;
    Label5: TLabel;
    procedure btcloseClick(Sender: TObject);
    procedure btpostClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure QClientesNewRecord(DataSet: TDataSet);
  private
  public
    Grabo : Integer;
  end;

var
  frmActClientes: TfrmActClientes;

implementation

{$R *.dfm}

procedure TfrmActClientes.btcloseClick(Sender: TObject);
begin
  QClientes.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActClientes.btpostClick(Sender: TObject);
begin
  QClientes.Post;
  QClientes.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActClientes.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

procedure TfrmActClientes.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActClientes.QClientesNewRecord(DataSet: TDataSet);
begin
  QClientesLimite.Value   :=0;
  QClientesBalance.Value  :=0;
end;

end.

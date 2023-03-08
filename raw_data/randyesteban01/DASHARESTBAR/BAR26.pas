unit BAR26;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls;

type
  TfrmActEmpresa = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    QEmpresa: TADOQuery;
    QEmpresaEmpresaID: TAutoIncField;
    QEmpresaNombre: TWideStringField;
    QEmpresaRNC: TWideStringField;
    QEmpresaDireccion: TWideStringField;
    QEmpresaTelefono: TWideStringField;
    QEmpresaWebsite: TWideStringField;
    QEmpresaCorreo: TWideStringField;
    QEmpresaMensaje1: TWideStringField;
    QEmpresaMensaje2: TWideStringField;
    QEmpresaMensaje3: TWideStringField;
    QEmpresaMensaje4: TWideStringField;
    dsEmpresa: TDataSource;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    DBMemo1: TDBMemo;
    Label5: TLabel;
    DBEdit3: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    Label7: TLabel;
    DBEdit6: TDBEdit;
    QEmpresaFax: TWideStringField;
    GroupBox1: TGroupBox;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    QEmpresaItbis: TBCDField;
    Label8: TLabel;
    DBEdit11: TDBEdit;
    QEmpresaPropina: TBCDField;
    Label9: TLabel;
    DBEdit12: TDBEdit;
    QEmpresaTasaUS: TBCDField;
    QEmpresaTasaEU: TBCDField;
    Label10: TLabel;
    DBEdit13: TDBEdit;
    Label11: TLabel;
    DBEdit14: TDBEdit;
    GroupBox2: TGroupBox;
    DBEdit15: TDBEdit;
    Label12: TLabel;
    QEmpresaCortapapel: TWideStringField;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActEmpresa: TfrmActEmpresa;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActEmpresa.btcloseClick(Sender: TObject);
begin
  QEmpresa.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActEmpresa.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    if ActiveControl.ClassType <> TDBMemo then
    begin
      perform(wm_nextdlgctl, 0, 0);
      key := #0;
    end;
  end;
end;

procedure TfrmActEmpresa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActEmpresa.btpostClick(Sender: TObject);
begin
  QEmpresa.Post;
  QEmpresa.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActEmpresa.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

end.

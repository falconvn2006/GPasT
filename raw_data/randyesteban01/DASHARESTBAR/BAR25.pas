unit BAR25;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  TfrmEmpresa = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    QEmpresa: TADOQuery;
    dsEmpresa: TDataSource;
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
    QEmpresaTasaUS: TBCDField;
    QEmpresaTasaEU: TBCDField;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bteditClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmpresa: TfrmEmpresa;

implementation

uses BAR04, BAR12, BAR26, BAR01;

{$R *.dfm}

procedure TfrmEmpresa.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEmpresa.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
end;

procedure TfrmEmpresa.FormActivate(Sender: TObject);
begin
  if not QEmpresa.Active then QEmpresa.Open;
end;

procedure TfrmEmpresa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
end;

procedure TfrmEmpresa.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActEmpresa, frmActEmpresa);
  frmActEmpresa.QEmpresa.Parameters.ParamByName('emp').Value := QEmpresaEmpresaID.Value;
  frmActEmpresa.QEmpresa.Open;
  frmActEmpresa.QEmpresa.Edit;
  frmActEmpresa.ShowModal;
  if frmActEmpresa.Grabo = 1 then
  begin
    t := QEmpresa.GetBookmark;
    QEmpresa.Close;
    QEmpresa.Open;
    DM.QEmpresa.Close;
    DM.QEmpresa.Open;
    QEmpresa.GotoBookmark(t);
  end;
  frmActEmpresa.Release;
end;

procedure TfrmEmpresa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

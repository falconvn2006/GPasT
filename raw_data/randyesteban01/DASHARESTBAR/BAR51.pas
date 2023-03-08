unit BAR51;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  TfrmImpresoraRemota = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    QPrinter_Remoto: TADOQuery;
    dsPrinterRemoto: TDataSource;
    btadd: TSpeedButton;
    QPrinter_RemotoIDPRINTER: TAutoIncField;
    QPrinter_RemotoDescripcion: TWideStringField;
    QPrinter_RemotoPath_Printer: TWideStringField;
    QPrinter_Remotonombre_printer: TWideStringField;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bteditClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure dsPrinterRemotoDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImpresoraRemota: TfrmImpresoraRemota;

implementation

uses BAR40, BAR04, BAR50, BAR01;


{$R *.dfm}

procedure TfrmImpresoraRemota.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImpresoraRemota.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmImpresoraRemota.FormActivate(Sender: TObject);
begin
  if not QPrinter_Remoto.Active then QPrinter_Remoto.Open;
end;

procedure TfrmImpresoraRemota.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmImpresoraRemota.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActImpresoraRemota, frmActImpresoraRemota);
  frmActImpresoraRemota.QPrinter_Remoto.Parameters.ParamByName('cod').Value := QPrinter_RemotoIDprinter.Value;
  frmActImpresoraRemota.QPrinter_Remoto.Open;
  frmActImpresoraRemota.QPrinter_Remoto.Edit;
  frmActImpresoraRemota.ShowModal;
  if frmActImpresoraRemota.Grabo = 1 then
  begin
    t := QPrinter_Remoto.GetBookmark;
    QPrinter_Remoto.Close;
    QPrinter_Remoto.Open;
    QPrinter_Remoto.GotoBookmark(t);
  end;
  frmActImpresoraRemota.Release;
end;

procedure TfrmImpresoraRemota.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActImpresoraRemota, frmActImpresoraRemota);
  frmActImpresoraRemota.QPrinter_Remoto.Parameters.ParamByName('cod').Value := -1;
  frmActImpresoraRemota.QPrinter_Remoto.Open;
  frmActImpresoraRemota.QPrinter_Remoto.Insert;
  frmActImpresoraRemota.ShowModal;
  if frmActImpresoraRemota.Grabo = 1 then
  begin
    t := QPrinter_Remoto.GetBookmark;
    QPrinter_Remoto.Close;
    QPrinter_Remoto.Open;
    QPrinter_Remoto.GotoBookmark(t);
  end;
  frmActImpresoraRemota.Release;
end;

procedure TfrmImpresoraRemota.dsPrinterRemotoDataChange(Sender: TObject;
  Field: TField);
begin
  btedit.Enabled :=dsPrinterRemoto.DataSet.RecordCount > 0;
end;

procedure TfrmImpresoraRemota.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

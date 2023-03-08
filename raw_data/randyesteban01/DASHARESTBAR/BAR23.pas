unit BAR23;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  TfrmMesas = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    QMesas: TADOQuery;
    dsMesas: TDataSource;
    btadd: TSpeedButton;
    QMesasMesaID: TIntegerField;
    QMesasNombre: TWideStringField;
    QMesasArea: TWideStringField;
    QMesasEstatus: TWideStringField;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bteditClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMesas: TfrmMesas;

implementation

uses BAR04, BAR12, BAR24, BAR01;

{$R *.dfm}

procedure TfrmMesas.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMesas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmMesas.FormActivate(Sender: TObject);
begin
  if not QMesas.Active then QMesas.Open;
end;

procedure TfrmMesas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(Self);
end;

procedure TfrmMesas.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActMesas, frmActMesas);
  frmActMesas.QMesas.Parameters.ParamByName('cod').Value := QMesasMesaID.Value;
  frmActMesas.QMesas.Open;
  frmActMesas.QMesas.Edit;
  frmActMesas.ShowModal;
  if frmActMesas.Grabo = 1 then
  begin
    t := QMesas.GetBookmark;
    QMesas.Close;
    QMesas.Open;
    QMesas.GotoBookmark(t);
  end;
  frmActMesas.Release;
end;

procedure TfrmMesas.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActMesas, frmActMesas);
  frmActMesas.QMesas.Parameters.ParamByName('cod').Value := -1;
  frmActMesas.QMesas.Open;
  frmActMesas.QMesas.Insert;
  frmActMesas.ShowModal;
  if frmActMesas.Grabo = 1 then
  begin
    t := QMesas.GetBookmark;
    QMesas.Close;
    QMesas.Open;
    QMesas.GotoBookmark(t);
  end;
  frmActMesas.Release;
end;

procedure TfrmMesas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

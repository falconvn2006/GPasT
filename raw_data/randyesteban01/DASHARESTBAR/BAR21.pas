unit BAR21;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  TfrmAreas = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    QAreas: TADOQuery;
    dsAreas: TDataSource;
    btadd: TSpeedButton;
    QAreasAreaID: TAutoIncField;
    QAreasNombre: TWideStringField;
    QAreasPrecio: TStringField;
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
  frmAreas: TfrmAreas;

implementation

uses BAR04, BAR12, BAR22, BAR01;

{$R *.dfm}

procedure TfrmAreas.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAreas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmAreas.FormActivate(Sender: TObject);
begin
  if not QAreas.Active then QAreas.Open;
end;

procedure TfrmAreas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmAreas.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActAreas, frmActAreas);
  frmActAreas.QAreas.Parameters.ParamByName('cod').Value := QAreasAreaID.Value;
  frmActAreas.QAreas.Open;
  frmActAreas.QAreas.Edit;
  frmActAreas.ShowModal;
  if frmActAreas.Grabo = 1 then
  begin
    t := QAreas.GetBookmark;
    QAreas.Close;
    QAreas.Open;
    QAreas.GotoBookmark(t);
  end;
  frmActAreas.Release;
end;

procedure TfrmAreas.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActAreas, frmActAreas);
  frmActAreas.QAreas.Parameters.ParamByName('cod').Value := -1;
  frmActAreas.QAreas.Open;
  frmActAreas.QAreas.Insert;
  frmActAreas.ShowModal;
  if frmActAreas.Grabo = 1 then
  begin
    t := QAreas.GetBookmark;
    QAreas.Close;
    QAreas.Open;
    QAreas.GotoBookmark(t);
  end;
  frmActAreas.Release;
end;

procedure TfrmAreas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

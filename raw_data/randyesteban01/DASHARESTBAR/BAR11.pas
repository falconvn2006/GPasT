unit BAR11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  TfrmCategorias = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    QCategorias: TADOQuery;
    QCategoriasCategoriaID: TIntegerField;
    QCategoriasNombre: TWideStringField;
    QCategoriasLinea1: TWideStringField;
    QCategoriasLinea2: TWideStringField;
    QCategoriasLinea3: TWideStringField;
    QCategoriasBgColor: TWideStringField;
    QCategoriasFgColor: TWideStringField;
    dsCategorias: TDataSource;
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
  frmCategorias: TfrmCategorias;

implementation

uses BAR04, BAR12, BAR01;

{$R *.dfm}

procedure TfrmCategorias.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCategorias.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
end;

procedure TfrmCategorias.FormActivate(Sender: TObject);
begin
  if not QCategorias.Active then QCategorias.Open;
end;

procedure TfrmCategorias.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
end;

procedure TfrmCategorias.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActCategoria, frmActCategoria);
  frmActCategoria.QCategorias.Close;
  frmActCategoria.QCategorias.Parameters.ParamByName('cat').Value := QCategoriasCategoriaID.Value;
  frmActCategoria.QCategorias.Open;
  frmActCategoria.QCategorias.Edit;
  frmActCategoria.ShowModal;
  if frmActCategoria.Grabo = 1 then
  begin
    t := QCategorias.GetBookmark;
    QCategorias.Close;
    QCategorias.Open;
    QCategorias.GotoBookmark(t);
  end;
  frmActCategoria.Release;
end;

procedure TfrmCategorias.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

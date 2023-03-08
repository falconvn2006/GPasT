unit BAR19;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  TfrmUsuarios = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    QUsuarios: TADOQuery;
    dsUsuarios: TDataSource;
    QUsuariosUsuarioID: TAutoIncField;
    QUsuariosNombre: TWideStringField;
    QUsuariosClave: TWideStringField;
    QUsuariosEstatus: TWideStringField;
    QUsuariosSupervisor: TBooleanField;
    QUsuariosCajero: TBooleanField;
    QUsuariosCamarero: TBooleanField;
    btadd: TSpeedButton;
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
  frmUsuarios: TfrmUsuarios;

implementation

uses BAR20, BAR01;

{$R *.dfm}

procedure TfrmUsuarios.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuarios.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmUsuarios.FormActivate(Sender: TObject);
begin
  if not QUsuarios.Active then QUsuarios.Open;
end;

procedure TfrmUsuarios.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmUsuarios.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActUsuario, frmActUsuario);
  frmActUsuario.QTarjetaUsu.Open;
  frmActUsuario.QTarjetaSuper.Open;
  frmActUsuario.QUsuarios.close;
  frmActUsuario.QUsuarios.Parameters.ParamByName('usu').Value := QUsuariosUsuarioID.Value;
  frmActUsuario.QUsuarios.Open;
  frmActUsuario.QUsuarios.Edit;
  frmActUsuario.ShowModal;
  if frmActUsuario.Grabo = 1 then
  begin
    t := QUsuarios.GetBookmark;
    QUsuarios.Close;
    QUsuarios.Open;
    QUsuarios.GotoBookmark(t);
  end;
  frmActUsuario.Release;
end;

procedure TfrmUsuarios.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActUsuario, frmActUsuario);
  frmActUsuario.QTarjetaUsu.Open;
  frmActUsuario.QTarjetaSuper.Open;
  frmActUsuario.QUsuarios.Parameters.ParamByName('usu').Value := -1;
  frmActUsuario.QUsuarios.Open;
  frmActUsuario.QUsuarios.Insert;
  frmActUsuario.ShowModal;
  if frmActUsuario.Grabo = 1 then
  begin
    t := QUsuarios.GetBookmark;
    QUsuarios.Close;
    QUsuarios.Open;
    QUsuarios.GotoBookmark(t);
  end;
  frmActUsuario.Release;
end;

procedure TfrmUsuarios.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.

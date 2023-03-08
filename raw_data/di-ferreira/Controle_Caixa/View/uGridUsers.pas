unit uGridUsers;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Data.DB,
  uCadUsuario,
  Fnc_Utils,
  Controle.Caixa.Controller.Manager,
  Controle.Caixa.Controller.Manager.Interfaces;

type
  TFrmGridUsers = class(TForm)
    PanelTop: TPanel;
    PanelBody: TPanel;
    DBGUsuarios: TDBGrid;
    LblTitle: TLabel;
    BtnFechar: TSpeedButton;
    Panel3: TPanel;
    PanelFooter: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    PanelWrap: TPanel;
    PanelBackground: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure DBGUsuariosDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGUsuariosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGUsuariosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FControllerManager: iControllerManager;
  public
    procedure ListarUsuarios;
  end;

var
  FrmGridUsers: TFrmGridUsers;

implementation

type
  TDBGDefault = class(TDBGrid);
{$R *.dfm}

procedure TFrmGridUsers.BtnFecharClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmGridUsers.DBGUsuariosDblClick(Sender: TObject);
var
  pFormCad: TFrmCadUser;
begin
  if not DBGUsuarios.DataSource.DataSet.IsEmpty then
  begin
    pFormCad := TFrmCadUser.Create(nil);
    pFormCad.idUser := DBGUsuarios.DataSource
                                  .DataSet
                                  .FieldByName('ID')
                                  .AsInteger;
    pFormCad.ShowModal;
    if pFormCad.pResult then
    begin
      ListarUsuarios;
    end;
    pFormCad.Free;
  end;
end;

procedure TFrmGridUsers.DBGUsuariosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.Title.Caption = 'ADMINISTRADOR' then
    if Column.Field.AsInteger > 0 then
      DBGUsuarios.Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 5, 'SIM')
    else
      DBGUsuarios.Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 5, 'NÃO');
end;

procedure TFrmGridUsers.DBGUsuariosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if not DBGUsuarios.DataSource.DataSet.IsEmpty then
      if CCShowQuestion('Excluir?', 'Tem certeza que deseja excluir ' +
        DBGUsuarios.DataSource.DataSet.FieldByName('NOME').AsString + '?') then
        FControllerManager.Usuario.Remove(DBGUsuarios.DataSource.DataSet.FieldByName('ID')
          .AsInteger);
  end;
  ListarUsuarios;
end;

procedure TFrmGridUsers.FormCreate(Sender: TObject);
begin
  FControllerManager := TControllerManager.New;
end;

procedure TFrmGridUsers.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFrmGridUsers.FormShow(Sender: TObject);
begin
  ListarUsuarios;
end;

procedure TFrmGridUsers.ListarUsuarios;
begin
  DBGUsuarios.DataSource := FControllerManager.Usuario.FindAll.DataSource;
  TDBGDefault(DBGUsuarios).DefaultRowHeight := 30;
  TDBGDefault(DBGUsuarios).ClientHeight :=
    (30 * TDBGDefault(DBGUsuarios).RowCount) + 30;
end;

end.

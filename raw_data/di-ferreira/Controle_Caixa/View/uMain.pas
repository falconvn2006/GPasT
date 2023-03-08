unit uMain;

interface

uses
{(*}
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  uGridUsers,
  uMessage,
  Fnc_Utils,
  Vcl.Buttons,
  Controle.Caixa.Controller.Manager,
  Controle.Caixa.Controller.Manager.Interfaces,
  Manager.Types;
{*)}

type
  TFrmMain = class(TForm)
    pnlEntradas: TPanel;
    pnlTotal: TPanel;
    Label1: TLabel;
    lblEntradas: TLabel;
    Label2: TLabel;
    lblSaidas: TLabel;
    pnlSaidas: TPanel;
    Label3: TLabel;
    lblTotal: TLabel;
    PanelBackground: TPanel;
    PanelWrap: TPanel;
    PanelTop: TPanel;
    LblTitle: TLabel;
    BtnFechar: TSpeedButton;
    PanelBody: TPanel;
    Panel3: TPanel;
    PanelMenu: TPanel;
    BtnRegistros: TSpeedButton;
    BtnUsuarios: TSpeedButton;
    ContainerRegistros: TPanel;
    PanelRegistros: TPanel;
    BtnIncluirReg: TSpeedButton;
    BtnListarReg: TSpeedButton;
    ContainerUsuarios: TPanel;
    PanelUsuarios: TPanel;
    BtnIncluirUsuario: TSpeedButton;
    BtnListarUsuarios: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure LoadDashboard;
    procedure FormShow(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnRegistrosMouseEnter(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure BtnUsuariosMouseEnter(Sender: TObject);
    procedure ContainerRegistrosMouseEnter(Sender: TObject);
    procedure ContainerUsuariosMouseEnter(Sender: TObject);
    procedure BtnIncluirRegClick(Sender: TObject);
    procedure BtnListarRegClick(Sender: TObject);
    procedure BtnIncluirUsuarioClick(Sender: TObject);
    procedure BtnListarUsuariosClick(Sender: TObject);
  private
    FControllerManager: iControllerManager;
    pEntradas, pSaidas, pTotal: Double;
    procedure IncluirRegistro;
    procedure ListarRegistros;
    procedure IncluirUsuario;
    procedure ListarUsuarios;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses
  DM.Main, uCadastroRegistro, uGridRegistro, uCadUsuario;

procedure TFrmMain.BtnFecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.BtnIncluirRegClick(Sender: TObject);
begin
  IncluirRegistro;
end;

procedure TFrmMain.BtnIncluirUsuarioClick(Sender: TObject);
begin
  IncluirUsuario;
end;

procedure TFrmMain.BtnListarRegClick(Sender: TObject);
begin
  ListarRegistros;
end;

procedure TFrmMain.BtnListarUsuariosClick(Sender: TObject);
begin
  ListarUsuarios;
end;

procedure TFrmMain.BtnRegistrosMouseEnter(Sender: TObject);
begin
  ContainerRegistros.Visible := True;
  ContainerRegistros.Left := BtnRegistros.Left;
  ContainerUsuarios.Visible := False;
end;

procedure TFrmMain.BtnUsuariosMouseEnter(Sender: TObject);
begin
  ContainerRegistros.Visible := False;
  ContainerUsuarios.Visible := True;
  ContainerUsuarios.Left := BtnUsuarios.Left;
end;

procedure TFrmMain.ContainerRegistrosMouseEnter(Sender: TObject);
begin
  ContainerUsuarios.Visible := False;
end;

procedure TFrmMain.ContainerUsuariosMouseEnter(Sender: TObject);
begin
  ContainerRegistros.Visible := False;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FControllerManager := TControllerManager.New;
  LoadDashboard;
end;

procedure TFrmMain.FormMouseEnter(Sender: TObject);
begin
  ContainerRegistros.Visible := False;
  ContainerUsuarios.Visible := False;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  BtnUsuarios.Visible := DMMain.currentUser.ADMIN;
end;

procedure TFrmMain.IncluirRegistro;
var
  pFormCad: TFrmCadastro;
begin
  pFormCad := TFrmCadastro.Create(nil);
  pFormCad.ShowModal;
  if pFormCad.pResult then
  begin
    LoadDashboard;
  end;
  pFormCad.Free;
end;

procedure TFrmMain.IncluirUsuario;
var
  pFormCad: TFrmCadUser;
begin
  pFormCad := TFrmCadUser.Create(nil);
  try
    pFormCad.ShowModal;
  finally
    pFormCad.Free;
  end;
end;

procedure TFrmMain.ListarRegistros;
var
  pFormGrid: TFrmGridRegistro;
begin
  pFormGrid := TFrmGridRegistro.Create(nil);
  try
    pFormGrid.ShowModal;
  finally
    LoadDashboard;
    pFormGrid.Free;
  end;
end;

procedure TFrmMain.ListarUsuarios;
var
  pFormGrid: TFrmGridUsers;
begin
  pFormGrid := TFrmGridUsers.Create(nil);
  try
    pFormGrid.ShowModal;
  finally
    pFormGrid.Free;
  end;
end;

procedure TFrmMain.LoadDashboard;
begin
  pEntradas := FControllerManager.Caixa.Sum('VALOR').Where('ENTRADA', tpFilterOperator.Eq, '1').DataSource.DataSet.FieldByName('VALOR').AsFloat;
  pSaidas :=  FControllerManager.Caixa.Sum('VALOR').Where('ENTRADA', tpFilterOperator.Eq, '0').DataSource.DataSet.FieldByName('VALOR').AsFloat;

  pTotal := pEntradas - pSaidas;

  lblEntradas.Caption := 'R$' + CurrToStr(pEntradas);
  lblSaidas.Caption := 'R$' + CurrToStr(pSaidas);
  lblTotal.Caption := 'R$' + CurrToStr(pTotal);
end;

end.


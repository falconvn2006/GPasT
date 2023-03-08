unit UfrmHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.MultiView, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.Edit, UService.Imagem;

type
  TfrmHome = class(TForm)
    rectPrincipal: TRectangle;
    lytContainer: TLayout;
    rectSair: TRectangle;
    Label4: TLabel;
    imgNovaVisao: TImage;
    rectIniciar: TRectangle;
    Label1: TLabel;

    procedure rectSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rectIniciarClick(Sender: TObject);
  private
    { Private declarations }

    procedure IniciarSistema;

  public
    { Public declarations }
  end;

var
  frmHome: TfrmHome;
  // Precisamos iniciar a variavel Singleton aqui, ela vai persistir até a
  // o sistema ser encerrado.

implementation

uses
  UfrmSistema;

{$R *.fmx}

procedure TfrmHome.IniciarSistema;
begin
  if not Assigned(frmSistema) then
  begin
    Application.CreateForm(TfrmSistema, frmSistema);
  end;
  frmSistema.Show();
end;

procedure TfrmHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmHome := nil;
end;

// procedure TfrmHome.rectIniciarClick(Sender: TObject);
// begin
// Self.IniciarSistema;
// end;

procedure TfrmHome.rectIniciarClick(Sender: TObject);
begin
  Self.IniciarSistema;
end;

procedure TfrmHome.rectSairClick(Sender: TObject);
begin
  Self.Close;
end;

end.

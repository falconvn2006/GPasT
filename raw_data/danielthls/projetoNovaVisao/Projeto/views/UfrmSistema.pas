unit UfrmSistema;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ListBox, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  FMX.MultiView, UService.Imagem;

type
  TfrmSistema = class(TForm)
    rectPrincipal: TRectangle;
    btnMenu: TSpeedButton;
    lytContainer: TLayout;
    imgNovaVisao: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtCliente: TEdit;
    edtCaminhoIMG: TEdit;
    cmbVariacoes: TComboBox;
    btnBuscar: TButton;
    btnProcurar: TButton;
    rectAvancar: TRectangle;
    Label4: TLabel;
    MultiView1: TMultiView;
    Rectangle1: TRectangle;
    lytLogo: TLayout;
    imgLogo: TImage;
    lstMenu: TListBox;
    procedure rectAvancarClick(Sender: TObject);
  private
    { Private declarations }
    procedure btnProcurarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure lstMenuItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  public
    { Public declarations }
    procedure AbrirCadastro;
    procedure AbrirEnviar;
  end;

var
  frmSistema: TfrmSistema;

implementation

uses
  UUtils.Enum, UfrmEnviar, UfrmHome;

{$R *.fmx}
{ TForm2 }

procedure TfrmSistema.AbrirCadastro;
begin
  ShowMessage('Teste');
end;

procedure TfrmSistema.AbrirEnviar;
begin
  if not Assigned(frmEnviar) then
  begin
    Application.CreateForm(TfrmEnviar, frmEnviar);
  end;
  frmEnviar.Show();
  Self.Close;
end;

procedure TfrmSistema.btnBuscarClick(Sender: TObject);
begin
  // Buscar Cliente no Banco utilizando como referencia texto do edtCliente
end;

procedure TfrmSistema.btnProcurarClick(Sender: TObject);
var
  xImagem: TServiceImagem;
begin
  xImagem := TServiceImagem.Create;
  xImagem.CarregarImagem;
  edtCaminhoIMG.Text := xImagem.CaminhoImagem;

end;

procedure TfrmSistema.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmSistema := nil;
end;

procedure TfrmSistema.lstMenuItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin

  case TEnumMenu(Item.Index) of
    mnuHome:
      ShowMessage('home');
    mnuCadastrar:
      ShowMessage('cadastrar');
    mnuSair:
      Self.Close;
  end;

  MultiView1.HideMaster;
end;

procedure TfrmSistema.rectAvancarClick(Sender: TObject);
begin
 Self.AbrirEnviar;
end;

end.

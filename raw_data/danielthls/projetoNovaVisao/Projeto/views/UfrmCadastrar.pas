unit UfrmCadastrar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit;

type
  TfrmCadastro = class(TForm)
    rectPrincipal: TRectangle;
    lytContainer: TLayout;
    imgNovavisao: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    rectCadastrar: TRectangle;
    Label4: TLabel;
    rectVoltar: TRectangle;
    Label5: TLabel;
    edtNome: TEdit;
    edtCelular: TEdit;
    edtEmail: TEdit;
    procedure rectVoltarClick(Sender: TObject);
  private
    { Private declarations }
    procedure VoltarSistema;
  public
    { Public declarations }
  end;

var
  frmCadastro: TfrmCadastro;

implementation

uses
  UfrmSistema;

{$R *.fmx}
{ TfrmCadastro }

procedure TfrmCadastro.VoltarSistema;
begin
  if not Assigned(frmSistema) then
  begin
    Application.CreateForm(TfrmSistema, frmSistema);
  end;
  frmSistema.Show();
  Self.Close;;
end;

procedure TfrmCadastro.rectVoltarClick(Sender: TObject);
begin
  Self.VoltarSistema;
end;

end.

unit UfraTeam.Registry;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts;

type
  TfraTeamRegistry = class(TFrame)
    rectPrincipal: TRectangle;
    lytPrincipal: TLayout;
    Image1: TImage;
    lytBotoes: TLayout;
    rectNome: TRectangle;
    edtNome: TEdit;
    rectSalvar: TRectangle;
    Label1: TLabel;
    rectVoltar: TRectangle;
    Label2: TLabel;
    procedure rectSalvarClick(Sender: TObject);
    procedure rectVoltarClick(Sender: TObject);
  private
    procedure VoltarTela;
    procedure Registrar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fraTeamRegistry : TfraTeamRegistry;

implementation

{$R *.fmx}

uses
  UfraTeam,
  UEntity.Teams,
  UService.Intf,
  UService.Team;

{ TfraTeamRegistry }

procedure TfraTeamRegistry.rectSalvarClick(Sender: TObject);
begin
  Self.Registrar;
end;

procedure TfraTeamRegistry.rectVoltarClick(Sender: TObject);
begin
  Self.VoltarTela;
end;

procedure TfraTeamRegistry.Registrar;
var
  xServiceTeam : IService;
begin
  if Trim(edtNome.Text) = EmptyStr then
    raise Exception.Create('Informe o nome do time.');

  xServiceTeam := TServiceTeam.Create(
    TTeam.Create(Trim(edtNome.Text)));

  xServiceTeam.Registrar;
  Self.VoltarTela;
end;

procedure TfraTeamRegistry.VoltarTela;
begin
  if not Assigned(fraTeam) then
    fraTeam := TfraTeam.Create(Application);

  fraTeam.Align := TAlignLayout.Center;

  Self.Parent.AddObject(fraTeam);
  FreeAndNil(fraTeamRegistry)

end;

end.

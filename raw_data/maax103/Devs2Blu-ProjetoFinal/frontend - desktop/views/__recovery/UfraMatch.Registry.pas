unit UfraMatch.Registry;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.ListBox,

  UService.Intf;
type
  TfraMatchRegistry = class(TFrame)
    rectPrincipal: TRectangle;
    lytPrincipal: TLayout;
    Image1: TImage;
    lytBotoes: TLayout;
    rectHora: TRectangle;
    edtHora: TEdit;
    rectSalvar: TRectangle;
    Label1: TLabel;
    rectVoltar: TRectangle;
    Label2: TLabel;
    rectData: TRectangle;
    edtData: TEdit;
    lytTimes: TLayout;
    cmbTimeA: TComboBox;
    cmbTimeB: TComboBox;
    Label3: TLabel;
    rectTimeA: TRectangle;
    rectTimeB: TRectangle;
    procedure rectVoltarClick(Sender: TObject);
    procedure rectSalvarClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
  private
    FServiceTeam : IService;
    procedure VoltarTela;
    procedure CarregarTeams;
    procedure Registrar;
  public
    constructor Create(aOwner : TComponent); override;
  end;

var
  fraMatchRegistry : TfraMatchRegistry;

implementation

{$R *.fmx}

uses
  UfraMatch,
  UService.Team,
  UService.Match,
  UEntity.Teams,
  UEntity.Matchs;

{ TfraMatchRegistry }

procedure TfraMatchRegistry.CarregarTeams;
var
  xTeam : TTeam;
begin
  cmbTimeA.Items.Clear;
  cmbTimeB.Items.Clear;

  if not Assigned(FServiceTeam) then
    FServiceTeam := TServiceTeam.Create;

  FServiceTeam.Listar;
  for xTeam in TServiceTeam(FServiceTeam).Teams do
  begin
    cmbTimeA.Items.AddObject(xTeam.Name, xTeam);
    cmbTimeB.Items.AddObject(xTeam.Name, xTeam);
  end;
end;

constructor TfraMatchRegistry.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  self.CarregarTeams;
end;

procedure TfraMatchRegistry.FrameClick(Sender: TObject);
begin

end;

procedure TfraMatchRegistry.rectSalvarClick(Sender: TObject);
begin
  Self.Registrar;
end;

procedure TfraMatchRegistry.rectVoltarClick(Sender: TObject);
begin
  Self.VoltarTela;
end;

procedure TfraMatchRegistry.Registrar;
var
  xServiceMatch : IService;
  xHora : TTime;
  xData : TDate;
  xTimeAux : TTeam;
  xTimeA, xTimeB : TTeam;
begin
  if Trim(edtHora.Text) = EmptyStr then
    raise Exception.Create('Infome a hora da partida.');

  if Trim(edtData.Text) = EmptyStr then
    raise Exception.Create('Infome a data da partida.');

  if cmbTimeA.ItemIndex = -1 then
    raise Exception.Create('Infome o time A da partida.');

  if cmbTimeB.ItemIndex = -1 then
    raise Exception.Create('Infome o time B da partida.');

  if cmbTimeA.ItemIndex = cmbTimeB.ItemIndex then
    raise Exception.Create('Informe times diferentes para a partida.');

  xHora := StrToTime(Trim(edtHora.Text));
  xData := StrToDate(Trim(edtData.Text));

  xTimeAux := TTeam(cmbTimeA.Items.Objects[cmbTimeA.ItemIndex]);
  xTimeA := xTimeAux.Clone;

  xTimeAux := TTeam(cmbTimeB.Items.Objects[cmbTimeB.ItemIndex]);
  xTimeB := xTimeAux.Clone;

  xServiceMatch := TServiceMatch.Create(
    TMatch.Create(xData, xHora, xTimeA, xTimeB));

  xServiceMatch.Registrar;
  Self.VoltarTela;
end;

procedure TfraMatchRegistry.VoltarTela;
begin
  if not Assigned(fraMatch) then
    fraMatch := TfraMatch.Create(Application);

  fraMatch.Align := TAlignLayout.Center;

  Self.Parent.AddObject(fraMatch);
  FreeAndNil(fraMatchRegistry)
end;

end.

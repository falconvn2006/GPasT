unit UfraTeam;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,

  UEntity.Teams, UService.Team;

type
  TfraTeam = class(TFrame)
    rectPrincipal: TRectangle;
    lytPrincipal: TLayout;
    rectToolbar: TRectangle;
    rectNovo: TRectangle;
    rectExcluir: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    imgLogo: TImage;
    lstTimes: TListView;
    procedure rectNovoClick(Sender: TObject);
    procedure rectExcluirClick(Sender: TObject);
  private
    procedure AbrirTeamRegistry;
    procedure CarregarRegistros;
    procedure ExcluirRegistro;
    procedure PreencherTeams(aTeam : TTeam);
    { Private declarations }
  public
    constructor Create(aOwner : TComponent); override;
    { Public declarations }
  end;

var
  fraTeam : TfraTeam;

implementation

uses
  UfraTeam.Registry,
  UService.Intf;

{$R *.fmx}

{ TfraTeam }

procedure TfraTeam.AbrirTeamRegistry;
begin
  if not Assigned(fraTeamRegistry) then
    fraTeamRegistry := TfraTeamRegistry.Create(Application);

    fraTeamRegistry.Align := TAlignLayout.Center;

    Self.Parent.AddObject(fraTeamRegistry);
    FreeAndNil(fraTeam);
end;

procedure TfraTeam.CarregarRegistros;
var
  xServiceTeam: IService;
  xTeam : TTeam;
begin
  lstTimes.Items.Clear;

  xServiceTeam := TServiceTeam.Create;
  xServiceTeam.Listar;

  for xTeam in TServiceTeam(xServiceTeam).Teams do
    Self.PreencherTeams(xTeam);
end;

constructor TfraTeam.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Self.CarregarRegistros;
end;

procedure TfraTeam.ExcluirRegistro;
var
  xServiceTeam : IService;
  xTeam : TTeam;
  xItem : TListViewItem;
begin
  if lstTimes.ItemIndex = -1 then
    Exit;

  xItem := lstTimes.Items[lstTimes.ItemIndex];
  xTeam := TTeam.Create(xItem.Tag);

  xServiceTeam := TServiceTeam.Create(xTeam);
  try
    xServiceTeam.Excluir;
    ShowMessage('Registro excluído.');
  finally
    Self.CarregarRegistros
  end;
end;

procedure TfraTeam.PreencherTeams(aTeam: TTeam);
var
  xItem : TListViewItem;
begin
  xItem := lstTimes.Items.Add;
  xItem.Tag := aTeam.Id;

  TListItemText(xItem.Objects.FindDrawable('txtTime')).Text := aTeam.Name;
end;

procedure TfraTeam.rectExcluirClick(Sender: TObject);
begin
  Self.ExcluirRegistro;
end;

procedure TfraTeam.rectNovoClick(Sender: TObject);
begin
  Self.AbrirTeamRegistry;
end;

end.

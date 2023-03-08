unit UfraBet.Registry;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.ListBox,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView,

  UEntity.Matchs;

type
  TfraBetRegistry = class(TFrame)
    rectPrincipal: TRectangle;
    lytPrincipal: TLayout;
    Image1: TImage;
    lytBotoes: TLayout;
    rectSalvar: TRectangle;
    Label1: TLabel;
    rectVoltar: TRectangle;
    Label2: TLabel;
    lytTimes: TLayout;
    Label3: TLabel;
    rectTimeA: TRectangle;
    rectTimeB: TRectangle;
    edtTimeA: TEdit;
    edtTimeB: TEdit;
    lstPartidas: TListView;
    procedure rectVoltarClick(Sender: TObject);
    procedure rectSalvarClick(Sender: TObject);
  private
    procedure VoltarTela;
    procedure CarregarMatchs;
    procedure Registrar;
    procedure PreencherMatchs(const aMatch: TMatch);
  public
    constructor Create(aOwner : TComponent); override;
  end;

var
  fraBetRegistry : TfraBetRegistry;

implementation

{$R *.fmx}

uses

  UfraBet,
  UService.Team,
  UService.Match,
  UEntity.Bets,
  UService.Bet,
  UService.User.Authenticated, UService.Intf;

{ TfraBetRegistry }

procedure TfraBetRegistry.CarregarMatchs;
var
  xServiceMatch : IService;
  xMatch: TMatch;
begin
  lstPartidas.Items.Clear;

  xServiceMatch := TServiceMatch.Create;
  xServiceMatch.Listar;
  for xMatch in TServiceMatch(xServiceMatch).Matchs do
    Self.PreencherMatchs(xMatch);
end;

constructor TfraBetRegistry.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Self.CarregarMatchs;
end;

procedure TfraBetRegistry.PreencherMatchs(const aMatch: TMatch);
var
  xItem : TListViewItem;
const
  PARTIDA = '%s X %s - %s às %s';
begin
  xItem := lstPartidas.Items.Add;
  xItem.Tag := aMatch.Id;

  TListItemText(xItem.Objects.FindDrawable('txtPartida')).Text :=
    Format(PARTIDA,[
      aMatch.TeamA.Name,
      aMatch.TeamB.Name,
      DateToStr(aMatch.Date),
      TimeToStr(aMatch.Hour)
    ])
end;

procedure TfraBetRegistry.rectSalvarClick(Sender: TObject);
begin
  Self.Registrar;
end;

procedure TfraBetRegistry.rectVoltarClick(Sender: TObject);
begin
  Self.VoltarTela
end;

procedure TfraBetRegistry.Registrar;
var
  xServiceBet : IService;
  xBet: TBet;
  xMatch: TMatch;
  xUserAuthenticated : TUserAuthenticated;
begin
  if lstPartidas.ItemIndex < 0 then
    raise Exception.Create('Selecione uma partida');

  if Trim(edtTimeA.Text) = EmptyStr then
    raise Exception.Create('Informe o placar do time A');

  if Trim(edtTimeB.Text) = EmptyStr then
    raise Exception.Create('Informe o placar do time B');

  xMatch := TMatch.Create(lstPartidas.Items[lstPartidas.ItemIndex].Tag);
  xUserAuthenticated := TUserAuthenticated.GetInstance;

  xBet := TBet.Create(
    xMatch,
    StrToIntDef(Trim(edtTimeA.Text), 0),
    StrToIntDef(Trim(edtTimeB.Text), 0),
    xUserAuthenticated.User
  );

  xServiceBet := TServiceBet.Create(xBet);
  xServiceBet.Registrar;
  Self.VoltarTela;
end;

procedure TfraBetRegistry.VoltarTela;
begin
  if not Assigned(fraBet) then
    fraBet := TfraBet.Create(Application);

  fraBet.Align := TAlignLayout.Center;

  Self.Parent.AddObject(fraBet);
  FreeAndNil(fraBetRegistry)
end;

end.

unit UfraBet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,

  UEntity.Bets;

type
  TfraBet = class(TFrame)
    rectPrincipal: TRectangle;
    lytPrincipal: TLayout;
    rectToolbar: TRectangle;
    rectNovo: TRectangle;
    rectExcluir: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    imgLogo: TImage;
    lstPalpites: TListView;
    procedure rectExcluirClick(Sender: TObject);
    procedure rectNovoClick(Sender: TObject);
  private
    procedure CarregarRegistros;
    procedure AbrirBetRegistry;
    procedure PrepararListView(aBet: TBet);
    procedure ExcluirRegistro;
  public
    constructor Create(aOwner : TComponent); override;
  end;

var
  fraBet : TfraBet;

implementation

{$R *.fmx}

uses
  UService.Intf,
  UService.Bet,
  UEntity.Matchs,
  UfraBet.Registry,
  UService.User.Authenticated;

{ TfraBet }

procedure TfraBet.AbrirBetRegistry;
begin
  if not Assigned(fraBetRegistry) then
    fraBetRegistry := TfraBetRegistry.Create(Application);

  fraBetRegistry.Align := TAlignLayout.Center;

  Self.Parent.AddObject(fraBetRegistry);
  FreeAndNil(fraBet)
end;

procedure TfraBet.CarregarRegistros;
var
  xServiceBet : IService;
  xBet : TBet;
begin
  lstPalpites.Items.Clear;

  xServiceBet := TServiceBet.Create;
  xServiceBet.Listar;
  for xBet in TServiceBet(xServiceBet).Bets do
    Self.PrepararListView(xBet);
end;

constructor TfraBet.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Self.CarregarRegistros;
end;

procedure TfraBet.ExcluirRegistro;
var
  xServiceBet : IService;
  xBet: TBet;
  xItem: TListViewItem;
  xUserAuthenticated : TUserAuthenticated;
begin
  if lstPalpites.ItemIndex = -1 then
    Exit;

  xItem := lstPalpites.Items[lstPalpites.ItemIndex];

  xUserAuthenticated := TUserAuthenticated.GetInstance;
  if xItem.TagString <> xUserAuthenticated.User.Id.ToString then
    raise Exception.Create('Não é possível excluir o palpite de outro usuário.');

  xBet := TBet.Create(xItem.Tag);

  xServiceBet := TServiceBet.Create(xBet);
  try
    xServiceBet.Excluir;
    ShowMessage('Registro excluído com sucesso.')
  finally
    Self.CarregarRegistros;
  end;
end;

procedure TfraBet.PrepararListView(aBet: TBet);
var
  xItem : TListViewItem;
  xMatch : TMatch;
begin
  xItem := lstPalpites.Items.Add;
  xItem.Tag := aBet.Id;
  xItem.TagString := aBet.User.Id.ToString;
  xMatch := aBet.Match;

  TListItemText(xItem.Objects.FindDrawable('txtUsuario')).Text := aBet.User.Login;
  TListItemText(xItem.Objects.FindDrawable('txtHora')).Text := TimeToStr(xMatch.Hour);
  TListItemText(xItem.Objects.FindDrawable('txtData')).Text := DateToStr(xMatch.Date);
  TListItemText(xItem.Objects.FindDrawable('txtTimeA')).Text := xMatch.TeamA.Name;
  TListItemText(xItem.Objects.FindDrawable('txtTimeB')).Text := xMatch.TeamB.Name;
  TListItemText(xItem.Objects.FindDrawable('txtResultadoTimeA')).Text := aBet.ResultTeamA.ToString;
  TListItemText(xItem.Objects.FindDrawable('txtResultadoTimeB')).Text := aBet.ResultTeamB.ToString;
end;

procedure TfraBet.rectExcluirClick(Sender: TObject);
begin
  Self.ExcluirRegistro;
end;

procedure TfraBet.rectNovoClick(Sender: TObject);
begin
  Self.AbrirBetRegistry;
end;

end.

unit Form_Main;

interface

uses
  System.SysUtils, System.Classes, Vcl.ImgList, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.Dialogs, uTiles, uTile, uTileCustom;

type
  TMainForm = class(TForm)
    Pan_Footer: TPanel;
    Lab_Connected: TLabel;
    Lab_Uptime: TLabel;
    Pan_Header: TPanel;
    Img_AppIcon: TImage;
    Lab_AppCaption: TLabel;
    Image2: TImage;
    Btn_Signin: TButton;
    Button2: TButton;
    Button4: TButton;
    SBox_Tiles: TScrollBox;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Btn_SigninClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Lab_ConnectedDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure SBox_TilesResize(Sender: TObject);
    procedure Img_AppIconClick(Sender: TObject);
  private
    procedure OnClick(const Tile: TTileCustom);
    procedure LoadConfiguration;

  private
    FUid: String;
    function GetUid: String;
    procedure SetUid(const Value: String);
  public
    Tiles: TTiles;
    property Uid: String read GetUid write SetUid;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Winapi.Windows, Form_Signin, Form_Configuration, Form_Subscriptions,
  uConfiguration, Form_Detail, uTypes, Vcl.Clipbrd;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.Action1Execute(Sender: TObject);
begin
Button4.Click;
end;

procedure TMainForm.Btn_SigninClick(Sender: TObject);
begin
  Form_Signin.TSigninForm.Prompt;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  i: Integer;
begin
  if Form_Configuration.TConfigurationForm.Prompt then begin
    TConfiguration.Save;
    for i := 0 to Tiles.Tiles.Count - 1 do
      Tiles.Tiles[ i ].Repaint;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  Form_Subscriptions.TSubscriptionsForm.Prompt;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Tiles := TTiles.Create( SBox_Tiles );
  Tiles.OnClick := OnClick;
  Tiles.OnDblClick := OnDblClick;

  Self.Uid := '';
  if not Form_Signin.SignIn then
    TConfiguration.ClearSubscriptions;

  LoadConfiguration;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Tiles.Free;
end;

function TMainForm.GetUid: String;
begin
  Exit( FUid );
end;

procedure TMainForm.Img_AppIconClick(Sender: TObject);
var
  Tile: TTile;
  i: Integer;
begin
  for i := 0 to 0 do begin
    Tile := TTile.Create( Tiles, Random(1000).tostring, TTileType.mc, '', 1000 );
    Tile.Enabled := False;
    Tiles.Add( Tile );
  end;
end;

procedure TMainForm.Lab_ConnectedDblClick(Sender: TObject);
begin
  Clipboard.AsText := Uid;
end;

procedure TMainForm.LoadConfiguration;
var
  i: Integer;
  Tile: TTile;
begin
  for i := Low( TConfiguration.Subscriptions ) to High( TConfiguration.Subscriptions ) do begin
    // Reconnect
    TConfiguration.Subscriptions[ i ].Get( Self.Uid );
    Tile :=
      TTile.Create(
        Tiles,
        TConfiguration.Subscriptions[ i ].Tag,
        TConfiguration.Subscriptions[ i ].&Type,
        Self.Uid,
        TConfiguration.Subscriptions[ i ].Frequency
      );
    Tiles.Add( Tile );
    Tile.ForceUpdate;
  end;
end;

procedure TMainForm.OnClick(const Tile: TTileCustom);
var
  &Type: TTileType;
begin
  &Type := Tile.&Type;
  DetailForm := TDetailForm.Create( nil );
  DetailForm.Tile := Tile;
  DetailForm.Tile.Enabled := False;
  DetailForm.Tile.&Type := TTileTypeRec.Detail;
  try
    Tile.OnDetailChange := DetailForm.OnDetailChange;
    Tiles.OnDetailChange := DetailForm.OnDetailChange;
    Tile.ForceUpdate;
    DetailForm.Lab_AppCaption.Caption := Tile.Tag;
    DetailForm.ShowModal;
  finally
    Tile.&Type := &Type;
    Tile.Enabled := True;
    DetailForm.Free;
  end;
end;

procedure TMainForm.SBox_TilesResize(Sender: TObject);
begin
//  SBox_Tiles.AutoSize := True;
//  Tiles.AutoWrap := False;
//  Tiles.AutoSize := False;
//  Tiles.AutoWrap := True;
//  Tiles.AutoSize := True;
//  SBox_Tiles.AutoSize := False;
end;

procedure TMainForm.SetUid(const Value: String);
begin
  FUid := Value;
  if SameText( Trim( FUid ), '' ) then
    Lab_Connected.Caption := 'Déconnecté'
  else
    Lab_Connected.Caption := Format( 'Connecté: %s', [ FUid ] );
end;

end.

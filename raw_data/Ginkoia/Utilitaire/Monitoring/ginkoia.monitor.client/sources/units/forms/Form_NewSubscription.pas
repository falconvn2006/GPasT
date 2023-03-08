unit Form_NewSubscription;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  uSubscription, uTypes;

type
  TNewSubscriptionForm = class(TForm)
    Pan_Header: TPanel;
    Img_AppIcon: TImage;
    Lab_AppCaption: TLabel;
    Btn_Close: TImage;
    Pan_Buttons: TPanel;
    Btn_Subscribe: TButton;
    Btn_Update: TButton;
    ScrollBox1: TScrollBox;
    GPnl_Parametres: TGridPanel;
    Lab_Hostname: TLabel;
    Lab_Application: TLabel;
    Lab_Instance: TLabel;
    Lab_Module: TLabel;
    Lab_Reference: TLabel;
    Lab_Key: TLabel;
    Combo_Hostname: TComboBox;
    Combo_Application: TComboBox;
    Combo_Instance: TComboBox;
    Combo_Module: TComboBox;
    Combo_Reference: TComboBox;
    Combo_Key: TComboBox;
    Lab_Tag: TLabel;
    BEdt_Tag: TButtonedEdit;
    Lab_Server: TLabel;
    Combo_Server: TComboBox;
    Lab_Dossier: TLabel;
    Combo_Dossier: TComboBox;
    GridPanel1: TGridPanel;
    Lab_Frequency: TLabel;
    BEdt_Frequency: TButtonedEdit;
    Lab_Type: TLabel;
    Combo_Type: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Btn_SubscribeClick(Sender: TObject);
    { events }
    procedure OnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OnFieldChange(Sender: TObject);
    procedure Btn_UpdateClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
  private
    { Déclarations privées }
    FSubscription: TSubscription;
    procedure UpdateComboBoxes;
  public
    class function Prompt: Boolean; overload;
    class function Prompt(const Frequency, &Type, Tag, Hostname, Application,
      Instance, Server, Module, Dossier, Reference, Key: String): Boolean; overload;
    class function Prompt(var Subscription: TSubscription): Boolean; overload;
  end;

var
  NewSubscriptionForm: TNewSubscriptionForm;

function NewSubscription(const Frequency, &Type, Tag, Hostname, Application,
  Instance, Server, Module, Dossier, Reference, Key: String): Boolean;
function EditSubscription(const Frequency, &Type, Tag, Hostname, Application,
  Instance, Server, Module, Dossier, Reference, Key: String;
  const Index: Integer): Boolean;

implementation

{$R *.dfm}

uses Form_Main, Form_Subscriptions, uConfiguration, uSubscriptionDef,
  System.TypInfo, uTile;

function TryStrToFrequency(const S: String; out Value: TFrequency): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Exit( ( E = 0 ) and ( Value > 0 ) );
end;

function TryStrToTileTyle(const S: String; out Value: TTileType): Boolean;
var
  TileType: TTileType;
begin
  for TileType := Low( TTileType ) to High( TTileType ) do begin
    if SameText( S, TileTypeToString( TileType ) ) then begin
      Value := TileType;
      Exit( True );
    end;
  end;
  Exit( False );
end;

function IsUniqueTag(const S: String): Boolean;
var
  Subscription: TSubscription;
begin
  for Subscription in TConfiguration.Subscriptions do
    if SameText( S, Subscription.Tag ) then
      Exit( False );
  Exit( True );
end;

function IsSubscriptionDifferent(const Frequency, &Type, Tag, Hostname,
  Application, Instance, Server, Module, Dossier, Reference,
  Key: String; const Index: Integer): Boolean;
begin
  Exit(
    ( not Assigned( TConfiguration.Subscriptions[ Index ] ) )or
    ( TConfiguration.Subscriptions[ Index ].Frequency <> StrToInt( Frequency ) ) or
    ( TConfiguration.Subscriptions[ Index ].&Type <> StrToTileType( &Type ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Tag, Tag ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Hostname, Hostname ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Application, Application ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Instance, Instance ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Server, Server ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Module, Module ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Dossier, Dossier ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Reference, Reference ) ) or
    ( not SameText( TConfiguration.Subscriptions[ Index ].Key, Key ) )
  );
end;

function NewSubscription(const Frequency, &Type, Tag, Hostname, Application,
  Instance, Server, Module, Dossier, Reference, Key: String): Boolean;
var
  Subscription: TSubscription;
  vFrequency: TFrequency;
  vType: TTileType;
  Tile: TTile;
begin
  try
    if not TryStrToTileTyle( &Type, vType ) then
      Exit( False );

    if not TryStrToFrequency( Frequency, vFrequency ) then
      Exit( False );

    if not IsUniqueTag( Tag ) then
      Exit( False );

    Subscription := TSubscription.Get( MainForm.Uid, vFrequency, vType,
      Hostname, Application, Instance, Server, Module, Dossier, Reference, Key,
      Tag );
    try
      if not Assigned( Subscription ) then
        Exit( False );
      { success }
      Form_Subscriptions.NewSubscription( Subscription );
      TConfiguration.Add( Subscription );
      //
      Tile :=
        TTile.Create(
          MainForm.Tiles,
          Subscription.Tag,
          Subscription.&Type,
          MainForm.Uid,
          Subscription.Frequency
        );
      MainForm.Tiles.Add( Tile );
      Tile.ForceUpdate;
      Exit( True );
    finally
//      Subscription.Free
    end;
  except
    Exit( False );
  end;
end;

function EditSubscription(const Frequency, &Type, Tag, Hostname, Application,
  Instance, Server, Module, Dossier, Reference, Key: String;
  const Index: Integer): Boolean;
var
  Subscription: TSubscription;
  vFrequency: TFrequency;
  vType: TTileType;
begin
  try
    if not TryStrToTileTyle( &Type, vType ) then
      Exit( False );
    if not TryStrToFrequency( Frequency, vFrequency ) and ( vFrequency > 0 ) then
      Exit( False );

    if IsSubscriptionDifferent( Frequency, &Type, Tag, Hostname, Application,
      Instance, Server, Module, Dossier, Reference, Key, Index ) then begin
      Subscription := TSubscription.Get( MainForm.Uid, vFrequency, vType,
        Hostname, Application, Instance, Server, Module, Dossier, Reference, Key,
        Tag );
      try
        if not Assigned( Subscription ) then
          Exit( False );
        { success }
        TConfiguration.Subscriptions[ Index ].Free;
        TConfiguration.Subscriptions[ Index ] := Subscription;
        Form_Subscriptions.EditSubscription( Index, Subscription );
        MainForm.Tiles.Tiles[ Index ].Tag := Subscription.Tag;
        MainForm.Tiles.Tiles[ Index ].&Type := Subscription.&Type;
        MainForm.Tiles.Tiles[ Index ].IntervalMax:= Subscription.Frequency;
        MainForm.Tiles.Tiles[ Index ].ForceUpdate;
        Exit( True );
      finally
//        Subscription.Free;
      end;
    end;
  except
    Exit( False );
  end;
end;

procedure TNewSubscriptionForm.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TNewSubscriptionForm.Btn_SubscribeClick(Sender: TObject);
begin
  if NewSubscription( BEdt_Frequency.Text, Combo_Type.Text, BEdt_Tag.Text,
    Combo_Hostname.Text, Combo_Application.Text, Combo_Instance.Text,
    Combo_Server.Text, Combo_Module.Text, Combo_Dossier.Text,
    Combo_Reference.Text, Combo_Key.Text ) then
    ModalResult := mrOk
  else
    ShowMessage('error');
end;

procedure TNewSubscriptionForm.Btn_UpdateClick(Sender: TObject);
begin
  if EditSubscription( BEdt_Frequency.Text, Combo_Type.Text, BEdt_Tag.Text,
    Combo_Hostname.Text, Combo_Application.Text, Combo_Instance.Text,
    Combo_Server.Text, Combo_Module.Text, Combo_Dossier.Text,
    Combo_Reference.Text, Combo_Key.Text,
    TConfiguration.IndexOf( FSubscription ) ) then
    ModalResult := mrOk
  else
    ShowMessage('error');
end;

procedure TNewSubscriptionForm.FormCreate(Sender: TObject);
begin
  if Assigned( Vcl.Forms.Application.MainForm ) then
    case Vcl.Forms.Application.MainForm.WindowState of
      TWindowState.wsNormal: BoundsRect := Vcl.Forms.Application.MainForm.BoundsRect;
      TWindowState.wsMinimized, Twindowstate.wsMaximized: WindowState := Vcl.Forms.Application.MainForm.WindowState;
    end;
  OnFieldChange( nil );
  UpdateComboBoxes;
end;

procedure TNewSubscriptionForm.OnFieldChange(Sender: TObject);
var
  vFrequency: TFrequency;
begin
  // Required fields constraint
  Btn_Subscribe.Enabled :=
    Btn_Subscribe.Visible and
    not SameText( Trim( BEdt_Tag.Text ), '' ) and
    not SameText( Trim( BEdt_Frequency.Text ), '' ) and
    TryStrToFrequency( BEdt_Frequency.Text, vFrequency
  );

  Btn_Update.Enabled :=
    Btn_Update.Visible and
    not SameText( Trim( BEdt_Tag.Text ), '' ) and
    not SameText( Trim( BEdt_Frequency.Text ), '' ) and
    TryStrToFrequency( BEdt_Frequency.Text, vFrequency
  );
end;

procedure TNewSubscriptionForm.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: if Sender <> Btn_Subscribe then
                 Btn_Subscribe.Click;
    VK_ESCAPE: Close;
  end;
end;

class function TNewSubscriptionForm.Prompt(
  var Subscription: TSubscription): Boolean;
begin
  NewSubscriptionForm := TNewSubscriptionForm.Create( nil );
  try
    {$REGION 'GUI update'}
    NewSubscriptionForm.BEdt_Tag.ReadOnly := True;
    NewSubscriptionForm.Lab_AppCaption.Caption := 'Edition abonnement';
    NewSubscriptionForm.Btn_Subscribe.Visible := False;
    //
    NewSubscriptionForm.BEdt_Frequency.Text := IntToStr( Subscription.Frequency );
    NewSubscriptionForm.Combo_Type.ItemIndex := NewSubscriptionForm.Combo_Type.Items.IndexOf( TileTypeToString( Subscription.&Type ) );

    NewSubscriptionForm.BEdt_Tag.Text := Subscription.Tag;
    NewSubscriptionForm.Combo_Hostname.Text := Subscription.Hostname;
    NewSubscriptionForm.Combo_Application.Text := Subscription.Application;
    NewSubscriptionForm.Combo_Instance.Text := Subscription.Instance;
    NewSubscriptionForm.Combo_Server.Text := Subscription.Server;
    NewSubscriptionForm.Combo_Module.Text := Subscription.Module;
    NewSubscriptionForm.Combo_Dossier.Text := Subscription.Dossier;
    NewSubscriptionForm.Combo_Reference.Text := Subscription.Reference;
    NewSubscriptionForm.Combo_Key.Text := Subscription.Key;
    NewSubscriptionForm.OnFieldChange( nil );
    {$ENDREGION 'GUI update'}
    NewSubscriptionForm.FSubscription := Subscription;
    NewSubscriptionForm.ShowModal;
    if NewSubscriptionForm.ModalResult <> mrOk then
      Exit( False );
    { success }
    Exit( True );
  finally
    NewSubscriptionForm.Free;
  end;
end;

procedure TNewSubscriptionForm.UpdateComboBoxes;
var
  SubscriptionDef: TSubscriptionDef;
  Hostname, Application, Instance, Server, Module, Dossier, Reference, Key: string;
  Subscription: TSubscription;
begin
  SubscriptionDef := TSubscriptionDef.Get( MainForm.Uid );
  try
    if not Assigned( SubscriptionDef ) then
      Exit;
    for Hostname in SubscriptionDef.Hostnames do
      Combo_Hostname.Items.Add( Hostname );
    for Application in SubscriptionDef.Applications do
      Combo_Application.Items.Add( Application );
    for Instance in SubscriptionDef.Instances do
      Combo_Instance.Items.Add( Instance );
    for Server in SubscriptionDef.Serveurs do
      Combo_Server.Items.Add( Server );
    for Module in SubscriptionDef.Modules do
      Combo_Module.Items.Add( Module );
    for Dossier in SubscriptionDef.Dossiers do
      Combo_Dossier.Items.Add( Dossier );
    for Reference in SubscriptionDef.References do
      Combo_Reference.Items.Add( Reference );
    for Key in SubscriptionDef.Keys do
      Combo_Key.Items.Add( Key );
  finally
    SubscriptionDef.Free;
  end;
end;

class function TNewSubscriptionForm.Prompt: Boolean;
begin
  Exit( Prompt( '', '', '', '', '', '', '', '', '', '', '' ) );
end;

class function TNewSubscriptionForm.Prompt(const Frequency, &Type, Tag,
  Hostname, Application, Instance, Server, Module, Dossier, Reference,
  Key: String): Boolean;
begin
  NewSubscriptionForm := TNewSubscriptionForm.Create( nil );
  try
    {$REGION 'GUI update'}
    NewSubscriptionForm.BEdt_Tag.ReadOnly := False;
    NewSubscriptionForm.Lab_AppCaption.Caption := 'Nouvel abonnement';
    NewSubscriptionForm.Btn_Update.Visible := False;
    //
    NewSubscriptionForm.BEdt_Frequency.Text := Frequency;
    NewSubscriptionForm.Combo_Type.Text := &Type;
    NewSubscriptionForm.BEdt_Tag.Text := Tag;
    NewSubscriptionForm.Combo_Hostname.Text := Hostname;
    NewSubscriptionForm.Combo_Application.Text := Application;
    NewSubscriptionForm.Combo_Instance.Text := Instance;
    NewSubscriptionForm.Combo_Module.Text := Module;
    NewSubscriptionForm.Combo_Reference.Text := Reference;
    NewSubscriptionForm.Combo_Key.Text := Key;
    {$ENDREGION 'GUI update'}
    NewSubscriptionForm.FSubscription := nil;
    NewSubscriptionForm.ShowModal;
    if NewSubscriptionForm.ModalResult <> mrOk then
      Exit( False );
    { success }
    Exit( True );
    //Exit( NewSubscription( Tag, Hostname, Application, Instance, Module, Reference, Key ) );
  finally
    NewSubscriptionForm.Free;
  end;
end;

end.

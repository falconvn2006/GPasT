unit Form_Subscriptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uSubscription;

type
  TSubscriptionsForm = class(TForm)
    Pan_Header: TPanel;
    Img_AppIcon: TImage;
    Lab_AppCaption: TLabel;
    Btn_Close: TImage;
    ListV_Subscriptions: TListView;
    Pan_Buttons: TPanel;
    Btn_Delete: TButton;
    Btn_Add: TButton;
    Btn_Edit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_EditClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    { events }
    procedure OnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OnFieldChange(Sender: TObject);
    procedure ListV_SubscriptionsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListV_SubscriptionsDblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    class procedure Prompt; overload;
    class procedure Prompt(const Subscriptions: TArray< TSubscription >); overload;
    class procedure UpdateListView;
  end;

var
  SubscriptionsForm: TSubscriptionsForm;

procedure NewSubscription(const Subscription: TSubscription);
procedure DeleteSubscription(const Index: Cardinal);
procedure EditSubscription(const Index: Integer; const Subscription: TSubscription);

implementation

{$R *.dfm}

uses uConfiguration, Form_Signin, Form_NewSubscription, uTypes, Form_Main;

procedure NewSubscription(const Subscription: TSubscription);
var
  ListItem: TListItem;
begin
  SubscriptionsForm.ListV_Subscriptions.Items.BeginUpdate;
  ListItem := SubscriptionsForm.ListV_Subscriptions.Items.Add;
  ListItem.Caption := IntToStr( Subscription.Frequency );
  ListItem.SubItems.Add( TileTypeToString( Subscription.&Type ) );
  ListItem.SubItems.Add( Subscription.Tag );
  ListItem.SubItems.Add( Subscription.Hostname );
  ListItem.SubItems.Add( Subscription.Application );
  ListItem.SubItems.Add( Subscription.Instance );
  ListItem.SubItems.Add( Subscription.Server );
  ListItem.SubItems.Add( Subscription.Module );
  ListItem.SubItems.Add( Subscription.Dossier );
  ListItem.SubItems.Add( Subscription.Key );
  ListItem.SubItems.Add( Subscription.Reference );
  SubscriptionsForm.ListV_Subscriptions.Items.EndUpdate;
  SubscriptionsForm.OnFieldChange( nil );
end;

procedure DeleteSubscription(const Index: Cardinal);
begin
  SubscriptionsForm.ListV_Subscriptions.Items[ Index ].Delete;
  SubscriptionsForm.OnFieldChange( nil );
end;

procedure EditSubscription(const Index: Integer; const Subscription: TSubscription);
var
  ListItem: TListItem;
begin
  SubscriptionsForm.ListV_Subscriptions.Items.BeginUpdate;
  ListItem := SubscriptionsForm.ListV_Subscriptions.Items.Item[ Index ];
  ListItem.Caption := IntToStr( Subscription.Frequency );
  ListItem.SubItems.Clear;
  ListItem.SubItems.Add( TileTypeToString( Subscription.&Type ) );
  ListItem.SubItems.Add( Subscription.Tag );
  ListItem.SubItems.Add( Subscription.Hostname );
  ListItem.SubItems.Add( Subscription.Application );
  ListItem.SubItems.Add( Subscription.Instance );
  ListItem.SubItems.Add( Subscription.Server );
  ListItem.SubItems.Add( Subscription.Module );
  ListItem.SubItems.Add( Subscription.Dossier );
  ListItem.SubItems.Add( Subscription.Reference );
  ListItem.SubItems.Add( Subscription.Key );
  SubscriptionsForm.ListV_Subscriptions.Items.EndUpdate;
  SubscriptionsForm.OnFieldChange( nil );
end;

{ TSubscriptionsForm }

procedure TSubscriptionsForm.Btn_AddClick(Sender: TObject);
begin
  if Form_NewSubscription.TNewSubscriptionForm.Prompt then begin
    TConfiguration.Save;

  end;
end;

procedure TSubscriptionsForm.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TSubscriptionsForm.Btn_DeleteClick(Sender: TObject);
var
  i: Integer;
begin
  if not ( Btn_Delete.Enabled or ( ListV_Subscriptions.SelCount = 0 ) )  then
    Exit;
  //
  for i := 0 to ListV_Subscriptions.Items.Count - 1 do
    if ListV_Subscriptions.Items[ i ].Selected then begin
      TConfiguration.Delete( i );
      MainForm.Tiles.Tiles.Delete( i );
    end;
  ListV_Subscriptions.DeleteSelected;
  //
  TConfiguration.Save;
end;

procedure TSubscriptionsForm.Btn_EditClick(Sender: TObject);
var
  i: Integer;
begin
  if not ( Btn_Edit.Enabled or ( ListV_Subscriptions.SelCount = 0 ) )  then
    Exit;
  //
  for i := 0 to ListV_Subscriptions.Items.Count - 1 do
    if ListV_Subscriptions.Items[ i ].Selected then
      if Form_NewSubscription.TNewSubscriptionForm.Prompt( TConfiguration.Subscriptions[ i ] ) then begin
        MainForm.Tiles.Tiles[ i ].Enabled := False;
        try
          TConfiguration.Save;
        finally
          MainForm.Tiles.Tiles[ i ].Enabled := True;
        end;
      end;
end;

procedure TSubscriptionsForm.FormCreate(Sender: TObject);
begin
  if Assigned( Vcl.Forms.Application.MainForm ) then
    case Vcl.Forms.Application.MainForm.WindowState of
      TWindowState.wsNormal: BoundsRect := Vcl.Forms.Application.MainForm.BoundsRect;
      TWindowState.wsMinimized, Twindowstate.wsMaximized: WindowState := Vcl.Forms.Application.MainForm.WindowState;
    end;
  OnFieldChange( nil );
end;

procedure TSubscriptionsForm.ListV_SubscriptionsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  OnFieldChange( nil );
end;

procedure TSubscriptionsForm.ListV_SubscriptionsDblClick(Sender: TObject);
begin//
  if ListV_Subscriptions.SelCount = 0 then
    Btn_Add.Click
  else
    Btn_Edit.Click;
end;

procedure TSubscriptionsForm.OnFieldChange(Sender: TObject);
begin
  Btn_Delete.Enabled := ListV_Subscriptions.SelCount > 0;
  Btn_Edit.Enabled := ListV_Subscriptions.SelCount > 0;
//  ListV_Subscriptions.Enabled := ListV_Subscriptions.Items.Count > 0;
end;

procedure TSubscriptionsForm.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ADD: if Sender <> Btn_Add then Btn_Add.Click;
    VK_SUBTRACT, VK_DELETE: if Sender <> Btn_Delete then Btn_Delete.Click;
    VK_MULTIPLY: if Sender <> Btn_Edit then Btn_Edit.Click;
    VK_RETURN: if ListV_Subscriptions.SelCount = 0 then begin
                 if Sender <> Btn_Add then Btn_Add.Click
               end
               else begin
                   if Sender <> Btn_Edit then Btn_Edit.Click;
               end;
    VK_ESCAPE: Close;
  end;
end;

class procedure TSubscriptionsForm.Prompt(
  const Subscriptions: TArray< TSubscription >);
var
  Subscription: TSubscription;
  ListItem: TListItem;
begin
  SubscriptionsForm := TSubscriptionsForm.Create( nil );
  try
    {$REGION 'GUI update'}
    UpdateListView;
    {$ENDREGION 'GUI update'}
    SubscriptionsForm.ShowModal;
    if SubscriptionsForm.ModalResult <> mrOk then
      Exit;
    { success }
  finally
    SubscriptionsForm.Free;
  end;
end;

class procedure TSubscriptionsForm.UpdateListView;
var
  Subscription: TSubscription;
begin
  SubscriptionsForm.ListV_Subscriptions.Clear;
  SubscriptionsForm.ListV_Subscriptions.Items.BeginUpdate;
  for Subscription in TConfiguration.Subscriptions do
    NewSubscription( Subscription );
  SubscriptionsForm.ListV_Subscriptions.Items.EndUpdate;
end;

class procedure TSubscriptionsForm.Prompt;
begin
  if TConfiguration.Load then
    Prompt( TConfiguration.Subscriptions )
  else
    Prompt( [ ] );
end;

end.

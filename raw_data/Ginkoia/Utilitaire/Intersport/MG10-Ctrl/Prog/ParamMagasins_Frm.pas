unit ParamMagasins_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, AdvGlowButton, ExtCtrls, RzPanel, StdCtrls, Mask, RzEdit,
  RzDBEdit, RzCmboBx, DB, IBODataset, Generics.Collections, StrUtils, Types;

type
  TGroupeClient = class
    public
      ID: Integer;
      Nom: String;

      constructor Create(const nID: Integer; const sNom: String);
  end;

  TGroupeCompteClient = class
    public
      ID: Integer;
      Nom: String;

      constructor Create(const nID: Integer; const sNom: String);
  end;

  TGroupeDePump = class
    public
      ID: Integer;
      Nom: String;

      constructor Create(const nID: Integer; const sNom: String);
  end;

  TFrmParamMagasins = class(TForm)
    LabelMagasin: TLabel;
    LabelGroupeClient: TLabel;
    LabelGroupeCompteCLient: TLabel;
    PanelBoutons: TRzPanel;
    BtnValider: TAdvGlowButton;
    BtnAnnuler: TAdvGlowButton;
    ComboBoxGroupeClient: TRzComboBox;
    ComboBoxGroupeCompteClient: TRzComboBox;
    EditMagasin: TRzEdit;
    BtnNouveauGroupeClient: TAdvGlowButton;
    BtnNouveauGroupeCompteClient: TAdvGlowButton;
    EditGroupeClient: TRzEdit;
    EditGroupeCompteClient: TRzEdit;
    BtnRenommerGroupeClient: TAdvGlowButton;
    BtnRenommerGroupeCompteClient: TAdvGlowButton;
    LabelGroupeDePump: TLabel;
    ComboBoxGroupeDePump: TRzComboBox;
    BtnNouveauGroupeDePump: TAdvGlowButton;
    BtnRenommerGroupeDePump: TAdvGlowButton;
    EditGroupeDePump: TRzEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure BtnNouveauGroupeClientClick(Sender: TObject);
    procedure BtnRenommerGroupeClientClick(Sender: TObject);
    procedure BtnNouveauGroupeCompteClientClick(Sender: TObject);
    procedure BtnRenommerGroupeCompteClientClick(Sender: TObject);
    procedure BtnNouveauGroupeDePumpClick(Sender: TObject);
    procedure BtnRenommerGroupeDePumpClick(Sender: TObject);
    procedure BtnValiderClick(Sender: TObject);
    procedure BtnAnnulerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FOrigine, bNouveauGroupeCLient, bNouveauGroupeCompteClient, bNouveauGroupeDePump: Boolean;
    FID: Integer;

    FListeGroupesClient: TObjectList<TGroupeClient>;
    FListeGroupesCompteClient: TObjectList<TGroupeCompteClient>;
    FListeGroupesDePump: TObjectList<TGroupeDePump>;

  public
    constructor Create(AOwner: TComponent; ASource: TWinControl);   reintroduce;
    procedure Initialisations(const bOrigine: Boolean; const nID: Integer; const sNom: String; const nIDGroupeCLient, nIDGroupeCompteClient, nIDGroupeDePump: Integer);
  end;

var
  FrmParamMagasins: TFrmParamMagasins;

implementation

uses Main_Dm;

{ TGroupeClient }

constructor TGroupeClient.Create(const nID: Integer; const sNom: String);
begin
  ID := nID;
  Nom := sNom;
end;

{ TGroupeCompteClient }

constructor TGroupeCompteClient.Create(const nID: Integer; const sNom: String);
begin
  ID := nID;
  Nom := sNom;
end;

{ TGroupeDePump }

constructor TGroupeDePump.Create(const nID: Integer; const sNom: String);
begin
  ID := nID;
  Nom := sNom;
end;

{$R *.dfm}

constructor TFrmParamMagasins.Create(AOwner: TComponent; ASource: TWinControl);
var
  Position: TPoint;
begin
  inherited Create(AOwner);
  Position := ASource.Parent.ClientToScreen(Point(ASource.Left, ASource.Top));
  Left := Position.X + ((ASource.Width div 2) - (Width div 2));
  Top := Position.Y + ((ASource.Height div 2) - (Height div 2));
end;

procedure TFrmParamMagasins.FormCreate(Sender: TObject);
begin
  FListeGroupesClient := TObjectList<TGroupeClient>.Create;
  FListeGroupesCompteClient := TObjectList<TGroupeCompteClient>.Create;
  FListeGroupesDePump := TObjectList<TGroupeDePump>.Create;
  bNouveauGroupeCLient := False;      bNouveauGroupeCompteClient := False;
end;

procedure TFrmParamMagasins.Initialisations(const bOrigine: Boolean; const nID: Integer; const sNom: String; const nIDGroupeCLient, nIDGroupeCompteClient, nIDGroupeDePump: Integer);
var
  GroupeClient: TGroupeClient;
  GroupeCompteClient: TGroupeCompteClient;
  GroupeDePump: TGroupeDePump;
begin
  Caption := ' Modifier le paramétrage magasin ' + IfThen(bOrigine, 'origine', 'destination');
  FOrigine := bOrigine;
  FID := nID;
  EditMagasin.Text := sNom;

  // Liste des groupes client.
  ComboBoxGroupeClient.Clear;      FListeGroupesClient.Clear;      EditGroupeClient.Text := '';
  bNouveauGroupeCLient := False;
  if Dm_Main.GetGroupesClient(bOrigine) then
  begin
    if not Dm_Main.Query.IsEmpty then
    begin
      Dm_Main.Query.First;
      while not Dm_Main.Query.Eof do
      begin
        GroupeClient := TGroupeClient.Create(Dm_Main.Query.FieldByName('GCL_ID').AsInteger, Dm_Main.Query.FieldByName('GCL_NOM').AsString);
        ComboBoxGroupeClient.Items.AddObject(Dm_Main.Query.FieldByName('GCL_NOM').AsString, GroupeClient);
        FListeGroupesClient.Add(GroupeClient);

        if GroupeClient.ID = nIDGroupeCLient then
          ComboBoxGroupeClient.ItemIndex := Pred(ComboBoxGroupeClient.Count);

        Dm_Main.Query.Next;
      end;
    end;
  end;

  // Liste des groupes compte client.
  ComboBoxGroupeCompteClient.Clear;      FListeGroupesCompteClient.Clear;      EditGroupeCompteClient.Text := '';
  bNouveauGroupeCompteClient := False;
  if Dm_Main.GetGroupesCompteClient(bOrigine) then
  begin
    if not Dm_Main.Query.IsEmpty then
    begin
      Dm_Main.Query.First;
      while not Dm_Main.Query.Eof do
      begin
        GroupeCompteClient := TGroupeCompteClient.Create(Dm_Main.Query.FieldByName('GCC_ID').AsInteger, Dm_Main.Query.FieldByName('GCC_NOM').AsString);
        ComboBoxGroupeCompteClient.Items.AddObject(Dm_Main.Query.FieldByName('GCC_NOM').AsString, GroupeCompteClient);
        FListeGroupesCompteClient.Add(GroupeCompteClient);

        if GroupeCompteClient.ID = nIDGroupeCompteClient then
          ComboBoxGroupeCompteClient.ItemIndex := Pred(ComboBoxGroupeCompteClient.Count);

        Dm_Main.Query.Next;
      end;
    end;
  end;

  // Liste des groupes de pump.
  ComboBoxGroupeDePump.Clear;      FListeGroupesDePump.Clear;      EditGroupeDePump.Text := '';
  bNouveauGroupeDePump := False;
  if Dm_Main.GetGroupesDePump(bOrigine) then
  begin
    if not Dm_Main.Query.IsEmpty then
    begin
      Dm_Main.Query.First;
      while not Dm_Main.Query.Eof do
      begin
        GroupeDePump := TGroupeDePump.Create(Dm_Main.Query.FieldByName('GCP_ID').AsInteger, Dm_Main.Query.FieldByName('GCP_NOM').AsString);
        ComboBoxGroupeDePump.Items.AddObject(Dm_Main.Query.FieldByName('GCP_NOM').AsString, GroupeDePump);
        FListeGroupesDePump.Add(GroupeDePump);

        if GroupeDePump.ID = nIDGroupeDePump then
          ComboBoxGroupeDePump.ItemIndex := Pred(ComboBoxGroupeDePump.Count);

        Dm_Main.Query.Next;
      end;
    end;
  end;
end;

procedure TFrmParamMagasins.FormClick(Sender: TObject);
begin
  // Annulation de la création.
  bNouveauGroupeCLient := False;
  EditGroupeClient.Text := '';      EditGroupeClient.Hide;
  ComboBoxGroupeClient.Show;      BtnNouveauGroupeClient.Show;      BtnRenommerGroupeClient.Show;

  bNouveauGroupeCompteClient := False;
  EditGroupeCompteClient.Text := '';      EditGroupeCompteClient.Hide;
  ComboBoxGroupeCompteClient.Show;      BtnNouveauGroupeCompteClient.Show;      BtnRenommerGroupeCompteClient.Show;

  bNouveauGroupeDePump := False;
  EditGroupeDePump.Text := '';      EditGroupeDePump.Hide;
  ComboBoxGroupeDePump.Show;      BtnNouveauGroupeDePump.Show;      BtnRenommerGroupeDePump.Show;
end;

procedure TFrmParamMagasins.BtnNouveauGroupeClientClick(Sender: TObject);
begin
  bNouveauGroupeCLient := True;
  EditGroupeClient.Left := ComboBoxGroupeClient.Left;
  EditGroupeClient.Top := ComboBoxGroupeClient.Top;
  ComboBoxGroupeClient.Hide;      BtnNouveauGroupeClient.Hide;      BtnRenommerGroupeClient.Hide;
  EditGroupeClient.Text := '';
  EditGroupeClient.Show;
  EditGroupeClient.SetFocus;
end;

procedure TFrmParamMagasins.BtnRenommerGroupeClientClick(Sender: TObject);
begin
  bNouveauGroupeCLient := False;
  EditGroupeClient.Left := ComboBoxGroupeClient.Left;
  EditGroupeClient.Top := ComboBoxGroupeClient.Top;
  ComboBoxGroupeClient.Hide;      BtnNouveauGroupeClient.Hide;      BtnRenommerGroupeClient.Hide;
  if ComboBoxGroupeClient.ItemIndex > -1 then
    EditGroupeClient.Text := ComboBoxGroupeClient.Items[ComboBoxGroupeClient.ItemIndex]
  else
    EditGroupeClient.Text := '';
  EditGroupeClient.Show;
  EditGroupeClient.SetFocus;
end;

procedure TFrmParamMagasins.BtnNouveauGroupeCompteClientClick(Sender: TObject);
begin
  bNouveauGroupeCompteClient := True;
  EditGroupeCompteClient.Left := ComboBoxGroupeCompteClient.Left;
  EditGroupeCompteClient.Top := ComboBoxGroupeCompteClient.Top;
  ComboBoxGroupeCompteClient.Hide;      BtnNouveauGroupeCompteClient.Hide;      BtnRenommerGroupeCompteClient.Hide;
  EditGroupeCompteClient.Text := '';
  EditGroupeCompteClient.Show;
  EditGroupeCompteClient.SetFocus;
end;

procedure TFrmParamMagasins.BtnRenommerGroupeCompteClientClick(Sender: TObject);
begin
  bNouveauGroupeCompteClient := False;
  EditGroupeCompteClient.Left := ComboBoxGroupeCompteClient.Left;
  EditGroupeCompteClient.Top := ComboBoxGroupeCompteClient.Top;
  ComboBoxGroupeCompteClient.Hide;      BtnNouveauGroupeCompteClient.Hide;      BtnRenommerGroupeCompteClient.Hide;
  if ComboBoxGroupeCompteClient.ItemIndex > -1 then
    EditGroupeCompteClient.Text := ComboBoxGroupeCompteClient.Items[ComboBoxGroupeCompteClient.ItemIndex]
  else
    EditGroupeCompteClient.Text := '';
  EditGroupeCompteClient.Show;
  EditGroupeCompteClient.SetFocus;
end;

procedure TFrmParamMagasins.BtnNouveauGroupeDePumpClick(Sender: TObject);
begin
  bNouveauGroupeDePump := True;
  EditGroupeDePump.Left := ComboBoxGroupeDePump.Left;
  EditGroupeDePump.Top := ComboBoxGroupeDePump.Top;
  ComboBoxGroupeDePump.Hide;      BtnNouveauGroupeDePump.Hide;      BtnRenommerGroupeDePump.Hide;
  EditGroupeDePump.Text := '';
  EditGroupeDePump.Show;
  EditGroupeDePump.SetFocus;
end;

procedure TFrmParamMagasins.BtnRenommerGroupeDePumpClick(Sender: TObject);
begin
  bNouveauGroupeDePump := False;
  EditGroupeDePump.Left := ComboBoxGroupeDePump.Left;
  EditGroupeDePump.Top := ComboBoxGroupeDePump.Top;
  ComboBoxGroupeDePump.Hide;      BtnNouveauGroupeDePump.Hide;      BtnRenommerGroupeDePump.Hide;
  if ComboBoxGroupeDePump.ItemIndex > -1 then
    EditGroupeDePump.Text := ComboBoxGroupeDePump.Items[ComboBoxGroupeDePump.ItemIndex]
  else
    EditGroupeDePump.Text := '';
  EditGroupeDePump.Show;
  EditGroupeDePump.SetFocus;
end;

procedure TFrmParamMagasins.BtnValiderClick(Sender: TObject);
var
  nIDGroupeClient, nIDGroupeCompteClient, nIDGroupeDePump: Integer;
begin
  // Vérifications.
  nIDGroupeClient := -1;
  if(EditGroupeClient.Visible) and (EditGroupeClient.Text = '') then
  begin
    Application.MessageBox('Attention :  il faut saisir le nom du groupe client !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    EditGroupeClient.SetFocus;
    Exit;
  end;
  if(not EditGroupeClient.Visible) or (not bNouveauGroupeCLient) then
  begin
    if(ComboBoxGroupeClient.ItemIndex > -1) and (Assigned(ComboBoxGroupeClient.Items.Objects[ComboBoxGroupeClient.ItemIndex])) and (ComboBoxGroupeClient.Items.Objects[ComboBoxGroupeClient.ItemIndex] is TGroupeClient) then
      nIDGroupeClient := TGroupeClient(ComboBoxGroupeClient.Items.Objects[ComboBoxGroupeClient.ItemIndex]).ID;
  end;

  nIDGroupeCompteClient := -1;
  if(EditGroupeCompteClient.Visible) and (EditGroupeCompteClient.Text = '') then
  begin
    Application.MessageBox('Attention :  il faut saisir le nom du groupe compte client !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    EditGroupeCompteClient.SetFocus;
    Exit;
  end;
  if(not EditGroupeCompteClient.Visible) or (not bNouveauGroupeCompteClient) then
  begin
    if(ComboBoxGroupeCompteClient.ItemIndex > -1) and (Assigned(ComboBoxGroupeCompteClient.Items.Objects[ComboBoxGroupeCompteClient.ItemIndex])) and (ComboBoxGroupeCompteClient.Items.Objects[ComboBoxGroupeCompteClient.ItemIndex] is TGroupeCompteClient) then
      nIDGroupeCompteClient := TGroupeCompteClient(ComboBoxGroupeCompteClient.Items.Objects[ComboBoxGroupeCompteClient.ItemIndex]).ID;
  end;

  nIDGroupeDePump := -1;
  if(EditGroupeDePump.Visible) and (EditGroupeDePump.Text = '') then
  begin
    Application.MessageBox('Attention :  il faut saisir le nom du groupe de pump !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    EditGroupeDePump.SetFocus;
    Exit;
  end;
  if(not EditGroupeDePump.Visible) or (not bNouveauGroupeDePump) then
  begin
    if(ComboBoxGroupeDePump.ItemIndex > -1) and (Assigned(ComboBoxGroupeDePump.Items.Objects[ComboBoxGroupeDePump.ItemIndex])) and (ComboBoxGroupeDePump.Items.Objects[ComboBoxGroupeDePump.ItemIndex] is TGroupeDePump) then
      nIDGroupeDePump := TGroupeDePump(ComboBoxGroupeDePump.Items.Objects[ComboBoxGroupeDePump.ItemIndex]).ID;
  end;

  // Si validation.
  if Dm_Main.ValiderParamMagasin(FOrigine, FID, nIDGroupeClient, nIDGroupeCompteClient, nIDGroupeDePump, EditGroupeClient.Text, EditGroupeCompteClient.Text, EditGroupeDePump.Text) then
    ModalResult := mrOk;
end;

procedure TFrmParamMagasins.BtnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmParamMagasins.FormDestroy(Sender: TObject);
begin
  FListeGroupesClient.Free;
  FListeGroupesCompteClient.Free;
  FListeGroupesDePump.Free;
end;

end.


unit GSCFGSMMagasin_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DB, ComCtrls;

type
  TFsmMagasin = class(TForm)
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    Rgr_Type: TRadioGroup;
    cbo_User: TComboBox;
    txt_Numero: TEdit;
    Lab_Numero: TLabel;
    Lab_User: TLabel;
    Nbt_Suivant: TBitBtn;
    Pan_NomMagasin: TPanel;
    Gbx_ImportExport: TGroupBox;
    Chk_Import: TCheckBox;
    Chk_Export: TCheckBox;
    Pan_InventaireFiscal: TPanel;
    Lab_CourirExportINVART: TLabel;
    Lab_CourirOpeningInventory: TLabel;
    Dtp_CourirExportINVART: TDateTimePicker;
    Dtp_CourirOpeningInventory: TDateTimePicker;
    Rgr_CAFAffilie: TRadioGroup;
    Chk_CourirAutomation: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_SuivantClick(Sender: TObject);
    procedure cbo_UserKeyPress(Sender: TObject; var Key: Char);
    procedure Chk_CourirAutomationClick(Sender: TObject);
    procedure Rgr_TypeClick(Sender: TObject);
    procedure Rgr_CAFAffilieClick(Sender: TObject);
  private
    vgStrlIdUser : TStringList;

    procedure Initialiser;

    procedure AfficherInfo;
    procedure Enregistrer;
  private
    FIsAutomatized: Boolean;
  public
    property IsAutomatized: Boolean read FIsAutomatized write FIsAutomatized;
  end;

var
  FsmMagasin: TFsmMagasin;

implementation

uses GSCFGMain_DM, GSCFGSMDossier_Frm, uAutomatisationInventaireFiscal;

{$R *.dfm}


procedure TFsmMagasin.FormCreate(Sender: TObject);
begin
  Initialiser;
end;

procedure TFsmMagasin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  vgStrlIdUser.Clear;
  vgStrlIdUser.Free;

  Action := CaFree;
end;

procedure TFsmMagasin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = VK_Escape then
    Close;
end;

procedure TFsmMagasin.Initialiser;
begin
//CAF
  FIsAutomatized := Rgr_CAFAffilie.ItemIndex = 1;
//  FIsAutomatized := Rgr_Type.ItemIndex = 0;
  vgStrlIdUser := TStringList.Create;
  FsmDossier.RemplirComboBox(FMain_DM.Que_ListeUser, cbo_User, vgStrlIdUser);

  AfficherInfo;
end;

//------------------------------------------------------------------------------
//                                                               +-------------+
//                                                               |    OBJET    |
//                                                               +-------------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Bouton

procedure TFsmMagasin.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFsmMagasin.Nbt_PostClick(Sender: TObject);
begin
  Enregistrer;
  Close;
end;

procedure TFsmMagasin.Nbt_SuivantClick(Sender: TObject);
begin
  Enregistrer;

  if not FMain_DM.cds_Magasin.Eof then
  begin
    FMain_DM.cds_Magasin.Next;

    AfficherInfo;
  end;
end;

//CAF
procedure TFsmMagasin.Rgr_CAFAffilieClick(Sender: TObject);
begin
  FIsAutomatized := Rgr_CAFAffilie.ItemIndex = 1;
  Chk_CourirAutomationClick( nil );
  Pan_InventaireFiscal.Visible := FIsAutomatized;
  if FIsAutomatized = False then
    Chk_CourirAutomation.Checked := False;
end;
//

procedure TFsmMagasin.Rgr_TypeClick(Sender: TObject);
begin
//  FIsAutomatized := Rgr_Type.ItemIndex = 0;
//  Chk_CourirAutomationClick( nil );
//  Chk_CourirAutomation.Visible := FIsAutomatized;
//  Lab_CourirExportINVART.Visible := FIsAutomatized;
//  Dtp_CourirExportINVART.Visible:= FIsAutomatized;
//  Lab_CourirOpeningInventory.Visible:= FIsAutomatized;
//  Dtp_CourirOpeningInventory.Visible := FIsAutomatized;
//  if FIsAutomatized then
//    ClientHeight := 366
//  else
//    ClientHeight := 246;
end;

//------------------------------------------------------------------------------
//                                                                +------------+
//                                                                |   ACTION   |
//                                                                +------------+
//------------------------------------------------------------------------------

//------------------------------------------------------------> AfficherInfo

procedure TFsmMagasin.AfficherInfo;
var
  vIdUser : Integer;
  AIF: TAutomatisationInventaireFiscal;
begin
  with FMain_DM do
  begin
    Pan_NomMagasin.Caption := cds_MagasinNomMagasin.AsString;

    txt_numero.Text := cds_MagasinNUMERO.AsString;
    vIdUser         := cds_MagasinIdUtilisateur.AsInteger;

    cbo_User.ItemIndex := vgStrlIdUser.IndexOf(IntToStr(vIdUser));

    case TMagType(cds_MagasinType.AsInteger) of
      mtGoSport : begin // GoSport
        Rgr_Type.ItemIndex := 0;
      end;
      mtCourir  : begin // courrir
        Rgr_Type.ItemIndex := 1;
      end;
    end;
//CAF
    Case TMagMode(cds_MagasinMode.AsInteger) of
      mtAffilie : begin // Affilié
        Rgr_CAFAffilie.ItemIndex := 0;
        Pan_InventaireFiscal.Visible := False;
      end;
      mtCAF  : begin // CAF
        Rgr_CAFAffilie.ItemIndex := 1;
        Pan_InventaireFiscal.Visible := True;
      end;
      mtMandat : begin // Affilié
        Rgr_CAFAffilie.ItemIndex := 2;
        Pan_InventaireFiscal.Visible := False;
      end;
    End;
//
    Chk_Import.Checked := cds_Magasin.FieldByName('import').AsBoolean;
    Chk_Export.Checked := cds_Magasin.FieldByName('export').AsBoolean;

    if cds_Magasin.RecordCount = cds_Magasin.RecNo then
      Nbt_Suivant.Enabled := False
    else
      Nbt_Suivant.Enabled := True;


    AIF := TAutomatisationInventaireFiscal.Create;
    try
      Dtp_CourirExportINVART.DateTime := AIF.ExtractingDate.Values[ 'PRM_FLOAT' ];
      Dtp_CourirOpeningInventory.DateTime := AIF.OpeningInventory.Values[ 'PRM_FLOAT' ];
      {$REGION 'Hack: "Vous devez être en mode Showcheckbox pour définir cette date"'}
      if Dtp_CourirExportINVART.DateTime = 0 then
        Dtp_CourirExportINVART.DateTime := Dtp_CourirExportINVART.DateTime + 0.1;
      if Dtp_CourirOpeningInventory.DateTime = 0 then
        Dtp_CourirOpeningInventory.DateTime := Dtp_CourirOpeningInventory.DateTime + 0.1;
      {$ENDREGION 'Hack: "Vous devez être en mode Showcheckbox pour définir cette date"'}
      Chk_CourirAutomation.Checked := ( Dtp_CourirExportINVART.DateTime >= Date )
      or ( Dtp_CourirOpeningInventory.DateTime >= Date );
      Chk_CourirAutomationClick( nil );
    finally
      AIF.Free;
    end;
  end;
end;

//-------------------------------------------------------------> Enregistrer

procedure TFsmMagasin.cbo_UserKeyPress(Sender: TObject; var Key: Char);
begin
  Abort;
end;

procedure TFsmMagasin.Chk_CourirAutomationClick(Sender: TObject);
begin
  Lab_CourirExportINVART.Enabled := Chk_CourirAutomation.Checked;
  Dtp_CourirExportINVART.Enabled := Chk_CourirAutomation.Checked;
  Lab_CourirOpeningInventory.Enabled := Chk_CourirAutomation.Checked;
  Dtp_CourirOpeningInventory.Enabled := Chk_CourirAutomation.Checked;
end;

procedure TFsmMagasin.Enregistrer;
var
  AIF: TAutomatisationInventaireFiscal;
begin
  with FMain_DM do
  begin
    cds_Magasin.Edit;

    if txt_Numero.Text <> '' then
    begin
      cds_MagasinNUMERO.AsString := txt_numero.Text;
    end else
    begin
      ShowMessage('Le numéro du magasin est obligatoire');
      Exit;
    end;

    if cbo_user.ItemIndex < 0 then
    begin
      cds_MagasinIdUtilisateur.AsInteger := 0;
      cds_MagasinUtilisateur.AsString    := '';
    end
    else
    begin
      cds_MagasinIdUtilisateur.AsInteger := StrToInt(vgStrlIdUser.Strings[cbo_user.itemIndex]);
      cds_MagasinUtilisateur.AsString    := cbo_user.Text;
    end;

    if Rgr_Type.ItemIndex <> -1 then
    begin
      case Rgr_Type.ItemIndex of
        0: begin // courrir
          cds_MagasinType.AsInteger := Ord(mtGoSport) ;
        end;
        1: begin // GoSport
          cds_MagasinType.AsInteger := Ord(mtCourir) ;
        end;
      end;
      cds_MagasinLibelleType.AsString := rgr_Type.Items[rgr_Type.ItemIndex];
    end;

    cds_Magasin.FieldByName('import').AsBoolean := Chk_Import.Checked;
    cds_Magasin.FieldByName('export').AsBoolean := Chk_Export.Checked;
//CAF
    if Rgr_CAFAffilie.ItemIndex <> -1 then
    begin
      case Rgr_CAFAffilie.ItemIndex of
        0: begin // Affilié
          cds_MagasinMode.AsInteger := Ord(mtAffilie) ;
        end;
        1: begin // CAF
          cds_MagasinMode.AsInteger := Ord(mtCAF) ;
        end;
        2: begin // Mandat
          cds_MagasinMode.AsInteger := Ord(mtMandat) ;
        end;
      end;
      cds_MagasinLibelleMode.AsString := Rgr_CAFAffilie.Items[Rgr_CAFAffilie.ItemIndex];
//
      cds_MagasinLibelleType.AsString := rgr_Type.Items[rgr_Type.ItemIndex];
    end;


    cds_Magasin.Post;

    AIF := TAutomatisationInventaireFiscal.Create;
    try
      if AIF.Supported then
      begin
        if Chk_CourirAutomation.Checked then
        begin
          if Round( Dtp_CourirExportINVART.Date ) <> AIF.ExtractingDate.Values[ 'PRM_FLOAT' ] then begin
            AIF.ExtractingDate.Values[ 'PRM_FLOAT' ] := Round( Dtp_CourirExportINVART.Date );
            AIF.ExtractingDate.Values[ 'PRM_INTEGER' ] := 0;
          end;
          if Round( Dtp_CourirOpeningInventory.Date ) <> AIF.OpeningInventory.Values[ 'PRM_FLOAT' ] then begin
            AIF.OpeningInventory.Values[ 'PRM_FLOAT' ] := Round( Dtp_CourirOpeningInventory.Date );
            AIF.OpeningInventory.Values[ 'PRM_INTEGER' ] := 0;
          end;
        end
        else
        begin
          AIF.ExtractingDate.Values[ 'PRM_FLOAT' ] := 0;
          AIF.OpeningInventory.Values[ 'PRM_FLOAT' ] := 0;
        end;
      end;

    finally
      AIF.Free;
    end;
  end;
end;


end.

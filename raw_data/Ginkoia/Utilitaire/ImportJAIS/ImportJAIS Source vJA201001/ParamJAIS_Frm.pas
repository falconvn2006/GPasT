unit ParamJAIS_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,uTypes,uDefs,
  Dialogs, StdCtrls, ExtCtrls,  Buttons,
  MainJAIS_DM, wwDialog, wwidlg, wwLookupDialogRv, DB, wwdblook, Wwdbdlg,
  wwDBLookupComboDlgRv, dxGrClms, dxTL, dxDBCtrl, dxDBGrid, dxCntner, dxDBGridHP,
  dxDBTLCl;

type
  Tfrm_ParamJAIS = class(TForm)
    Pan_ClientMag: TPanel;
    Pan_BottomBTN: TPanel;
    Gbx_Mag: TGroupBox;
    Pan_TopGlobal: TPanel;
    Gbx_Global: TGroupBox;
    Lab_TVA: TLabel;
    DBLkDlg_tva: TwwDBLookupComboDlgRv;
    Lab_Garantie: TLabel;
    DBLkDlg_Garantie: TwwDBLookupComboDlgRv;
    Lab_TypeComptable: TLabel;
    DBLkDlg_TypeC: TwwDBLookupComboDlgRv;
    Lab_ArtCollection: TLabel;
    Lab_FournIntersport: TLabel;
    DBLkDlg_FournIS: TwwDBLookupComboDlgRv;
    Ds_Magasin: TDataSource;
    Pan_Magasin: TPanel;
    DBG_Magasin: TdxDBGridHP;
    DBG_MagasinSOC_ID: TdxDBGridMaskColumn;
    DBG_MagasinSOC_NOM: TdxDBGridMaskColumn;
    DBG_MagasinMAG_ID: TdxDBGridMaskColumn;
    DBG_MagasinMAG_ENSEIGNE: TdxDBGridMaskColumn;
    DBG_MagasinMAG_CODEADH: TdxDBGridMaskColumn;
    DBG_MagasinUSR_ID: TdxDBGridMaskColumn;
    Nbt_Valider: TBitBtn;
    Nbt_Annuler: TBitBtn;
    LK_USR: TwwLookupDialogRV;
    rb_Oui: TRadioButton;
    rb_Non: TRadioButton;
    Lab_TVAtxt: TLabel;
    DBG_MagasinUSR_USERNAME: TdxDBGridColumn;
    procedure FormCreate(Sender: TObject);
    procedure DBG_MagasinUSR_USERNAMEButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Nbt_ValiderClick(Sender: TObject);
    procedure DBG_MagasinDblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_ParamJAIS: Tfrm_ParamJAIS;

implementation

{$R *.dfm}

procedure Tfrm_ParamJAIS.DBG_MagasinDblClick(Sender: TObject);
begin
  DBG_MagasinUSR_USERNAMEButtonClick(Self,0);
end;

procedure Tfrm_ParamJAIS.DBG_MagasinUSR_USERNAMEButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
begin
  with DM_MainJAIS do
  begin
    if LK_USR.Execute then
    begin
      With cdsMagasin do
      begin
        Edit;
        FieldByName('USR_ID').AsInteger      := Que_ListUilUsers.FieldByName('USR_ID').AsInteger;
        FieldByName('USR_USERNAME').AsString := Que_ListUilUsers.FieldByName('USR_USERNAME').AsString;
        Post;
      end;
    end;
  end;
end;

procedure Tfrm_ParamJAIS.FormCreate(Sender: TObject);
begin
  With DM_MainJAIS do
  begin
    // Récupération des paramètres généraux
    With Que_ListTVA do
      if Locate('TVA_ID',GPARAMDEFAUT.TVA_ID,[loCaseInsensitive]) then
        DBLkDlg_tva.Text := FieldByName('TVA_TAUX').AsString;

    with Que_ListGarantie do
      if Locate('GAR_ID',GPARAMDEFAUT.GAR_ID,[loCaseInsensitive]) then
        DBLkDlg_Garantie.Text := FieldByName('GAR_NOM').AsString;

    With Que_ListTypeComptable do
      if Locate('TCT_ID',GPARAMDEFAUT.TCT_ID,[loCaseInsensitive]) then
        DBLkDlg_TypeC.Text := FieldByName('TCT_NOM').AsString;

    with Que_ListFournisseur do
      if Locate('FOU_ID',GPARAMDEFAUT.FOU_ID,[loCaseInsensitive]) then
        DBLkDlg_FournIS.Text := FieldByName('FOU_NOM').AsString;

    if GPARAMDEFAUT.Collection then
      rb_Oui.Checked := True
    else
      rb_Non.Checked := True;

    SetMajCds;
  end; // with
end;

procedure Tfrm_ParamJAIS.Nbt_ValiderClick(Sender: TObject);
var
  GenParam : TGenParam;
begin
  With DM_MainJAIS do
  Try
    IBOTransaction.StartTransaction;

    GenParam.PRM_TYPE  := 11;
    GenParam.PRM_MAGID := 0;
    GenParam.PRM_POS   := 0;
    GenParam.PRM_FLOAT := 0;

    // Sauvegarde des paramètres généraux
    With GenParam do
    begin
      PRM_CODE    := 1;
      PRM_STRING  := 'lire PRM_INTEGER=TVA_ID';
      PRM_INFO    := 'TVA par défaut';
      PRM_INTEGER := 0;
      With Que_ListTVA do
      if Locate('TVA_TAUX',DBLkDlg_tva.Text,[loCaseInsensitive]) then
        PRM_INTEGER := Que_ListTVA.FieldByName('TVA_ID').AsInteger;

      SetGenParam(GenParam);

      PRM_CODE    := 2;
      PRM_STRING  := 'lire PRM_INTEGER=GRA_ID';
      PRM_INFO    := 'Garantie par défaut';
      PRM_INTEGER := 0;
      With Que_ListGarantie do
      if Locate('GAR_NOM',DBLkDlg_Garantie.Text,[loCaseInsensitive]) then
        PRM_INTEGER := Que_ListGarantie.FieldByName('GAR_ID').AsInteger;

      SetGenParam(GenParam);

      PRM_CODE    := 3;
      PRM_STRING  := 'lire PRM_INTEGER=TCT_ID';
      PRM_INFO    := 'Type comptable par défaut';
      PRM_INTEGER := 0;
      With Que_ListTypeComptable do
      if Locate('TCT_NOM',DBLkDlg_TypeC.Text,[loCaseInsensitive]) then
        PRM_INTEGER := Que_ListTypeComptable.FieldByName('TCT_ID').AsInteger;

      SetGenParam(GenParam);

      PRM_CODE    := 5;
      PRM_STRING  := 'lire PRM_INTEGER=FOU_ID';
      PRM_INFO    := 'fournisseur intersport par défaut';
      PRM_INTEGER := 0;
      With Que_ListFournisseur do
      if Locate('FOU_NOM',DBLkDlg_FournIS.Text,[loCaseInsensitive]) then
        PRM_INTEGER := Que_ListFournisseur.FieldByName('FOU_ID').AsInteger;

      SetGenParam(GenParam);

      PRM_CODE    := 7;
      PRM_STRING  := 'lire PRM_INTEGER=1 ==> collection obligatoire';
      PRM_INFO    := 'Collection obligatoire';
      case rb_Oui.Checked of
        True : PRM_INTEGER := 1;
        False: PRM_INTEGER := 0;
      end;
      SetGenParam(GenParam);

      // Sauvegarde du paramètrage société
//      With cdsSociete do
//      begin
//        First;
//        PRM_CODE   := 4;
//        PRM_STRING := 'lire PRM_INTEGER=EXC_ID par SOCID';
//        PRM_INFO   := 'Exercice Commercial';
//        while not Eof do
//        begin
//          PRM_MAGID := FieldByName('SOC_ID').AsInteger;
//          PRM_INTEGER := FieldByName('EXE_ID').AsInteger;
//
//          SetGenParamByMagID(GenParam);
//          Next;
//        end;
//      end;

      // sauvegarde du paramétrages magasins
      With cdsMagasin do
      begin
        First;
        PRM_CODE   := 8;
        PRM_STRING := 'lire PRM_INTEGER=USR_ID / par MAGID';
        PRM_INFO   := 'Acheteur';
        while not EOF do
        begin
          PRM_MAGID := FieldByName('MAG_ID').AsInteger;
          PRM_INTEGER := FieldByName('USR_ID').AsInteger;

          SetGenParamByMagID(GenParam);
          Next;
        end;
      end;

      with GPARAMDEFAUT do
      begin
        TVA_ID := Que_ListTVA.FieldByName('TVA_ID').AsInteger;
        GAR_ID := Que_ListGarantie.FieldByName('GAR_ID').AsInteger;
        TCT_ID := Que_ListTypeComptable.FieldByName('TCT_ID').AsInteger;
        FOU_ID := Que_ListFournisseur.FieldByName('FOU_ID').AsInteger;
        Collection := rb_Oui.Checked;
      end;
      IBOTransaction.Commit;

      ModalResult := mrOk;
    end;
  Except on E:Exception do
    begin
      IBOTransaction.Rollback;
      ShowMessage(E.Message);
    end;
  end;
end;

end.

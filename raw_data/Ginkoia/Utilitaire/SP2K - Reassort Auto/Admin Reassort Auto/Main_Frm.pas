unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, RzPanel, dxGrClEx, dxDBTLCl,
  dxGrClms, dxTL, dxDBCtrl, dxDBGrid, dxCntner, dxDBGridHP, Boxes, PanBtnDbgHP,
  RzPanelRv, RzTabs, StdCtrls, RzLabel, Mask, RzEdit, RzDBEdit, RzDBBnEd,
  RzDBButtonEditRv, wwDialog, wwidlg, wwLookupDialogRv,StrUtils, wwdbedit,
  Wwdotdot, Wwdbcomb, wwDBComboBoxRv, DBCtrls, Grids, DBGrids,
  LMDBaseGraphicControl, IniCfg_Frm;

ResourceString
  RS_TXT_EFFLST   =  'Voulez vous effacer la liste des articles actuel ?';


type
  TFrm_Main = class(TForm)
    Pan_Btn: TRzPanel;
    SBtn_Quit: TLMDSpeedButton;
    Pgc_Main: TRzPageControl;
    Tab_Mag: TRzTabSheet;
    Tab_Art: TRzTabSheet;
    Tab_Mrk: TRzTabSheet;
    DBG_Mag: TdxDBGridHP;
    DBG_Magmag_id: TdxDBGridMaskColumn;
    DBG_Magmag_code: TdxDBGridMaskColumn;
    DBG_Magmag_nom: TdxDBGridMaskColumn;
    DBG_Magmag_ville: TdxDBGridMaskColumn;
    DBG_Magmag_actif: TdxDBGridCheckColumn;
    DBG_Magmag_dateactivation: TdxDBGridButtonColumn;
    DBG_Magmag_cheminbase: TdxDBGridExtLookupColumn;
    DBG_MagColumn8: TdxDBGridMaskColumn;
    RzPanelRv1: TRzPanelRv;
    Pan_Mag: TPanelDbg;
    Pan_Cmd: TRzPanel;
    Nbt_ins: TLMDSpeedButton;
    Nbt_modif: TLMDSpeedButton;
    DBG_Marques: TdxDBGridHP;
    RzPanelRv2: TRzPanelRv;
    RzPanel1: TRzPanel;
    Nbt_AjoutMrk: TLMDSpeedButton;
    Nbt_ModifMrk: TLMDSpeedButton;
    DBG_MarquesRAM_ID: TdxDBGridMaskColumn;
    DBG_MarquesRAM_MRKID: TdxDBGridMaskColumn;
    DBG_MarquesMRK_NOM: TdxDBGridMaskColumn;
    DBG_MarquesRAM_TRIGRAM: TdxDBGridMaskColumn;
    DBG_MarquesRAM_REPFTP: TdxDBGridMaskColumn;
    DBG_MarquesRAM_ACTIF: TdxDBGridCheckColumn;
    DBG_MarquesRAM_STK: TdxDBGridCheckColumn;
    DBG_MarquesRAM_VTE: TdxDBGridCheckColumn;
    RzPanelRv3: TRzPanelRv;
    RzPanel2: TRzPanel;
    Nbt_AjoutArt: TLMDSpeedButton;
    Nbt_ModifArt: TLMDSpeedButton;
    Pan_Haut: TRzPanel;
    Lab_: TRzLabel;
    LK_LstMrkRea: TwwLookupDialogRV;
    Chp_LstMrkRea: TRzDBButtonEditRv;
    DBG_LstArticle: TdxDBGridHP;
    DBG_LstArticleREA_ID: TdxDBGridMaskColumn;
    DBG_LstArticleREA_REF: TdxDBGridMaskColumn;
    DBG_LstArticleREA_LIB: TdxDBGridMaskColumn;
    DBG_LstArticleREA_TAILLE: TdxDBGridMaskColumn;
    DBG_LstArticleREA_COULEUR: TdxDBGridMaskColumn;
    DBG_LstArticleREA_DIV1: TdxDBGridMaskColumn;
    DBG_LstArticleREA_DIV2: TdxDBGridMaskColumn;
    DBG_LstArticleREA_EAN: TdxDBGridMaskColumn;
    Nbt_DeleteArt: TLMDSpeedButton;
    RzPanelRv4: TRzPanelRv;
    Nbt_ImportCsv: TLMDSpeedButton;
    RzPanelRv5: TRzPanelRv;
    Nbt_InitMrk: TLMDSpeedButton;
    Nbt_Parametrage: TLMDSpeedButton;
    procedure SBtn_QuitClick(Sender: TObject);
    procedure Nbt_insClick(Sender: TObject);
    procedure Nbt_modifClick(Sender: TObject);
    procedure Nbt_AjoutMrkClick(Sender: TObject);
    procedure Nbt_ModifMrkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Nbt_ImportCsvClick(Sender: TObject);
    procedure Chp_MarqueChange(Sender: TObject);
    procedure Pgc_MainChange(Sender: TObject);
    procedure Chp_LstMrkReaButtonClick(Sender: TObject);
    procedure Nbt_AjoutArtClick(Sender: TObject);
    procedure Nbt_ModifArtClick(Sender: TObject);
    procedure Nbt_DeleteArtClick(Sender: TObject);
    procedure DBG_MagDblClick(Sender: TObject);
    procedure Nbt_InitMrkClick(Sender: TObject);
    procedure Nbt_ParametrageClick(Sender: TObject);
  private
    { Déclarations privées }
    //Function Importation des articles depuis en csv
    Function ImportArticle(FichierArt:String; Var LstErr:TStringList):Boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

Uses
  Main_Dm, InsMag_frm, InsMarque_Frm, InsArt_Frm, ListeArtErr_Frm,
  ActiveMarque_Frm, InitDate_Frm;

{$R *.dfm}

procedure TFrm_Main.Chp_LstMrkReaButtonClick(Sender: TObject);
Var
  Id    : Integer;    //Sauvegarde la Id de la Marque en cours
begin
  Id  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
  If LK_LstMrkRea.Execute Then
    Begin
      //Raffraichi la liste
      Dm_Main.Que_LstArticle.Close;
      Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
      Dm_Main.Que_LstArticle.Open;
    End
  else
  Begin
    Dm_Main.Que_LstMrkRea.Locate('RAM_MRKID',Id,[]);
  End;
end;

procedure TFrm_Main.Chp_MarqueChange(Sender: TObject);
begin
  //Raffraichi la liste des articles
  Dm_Main.Que_LstArticle.Close;
  Dm_Main.Que_LstArticle.Open;
end;

procedure TFrm_Main.DBG_MagDblClick(Sender: TObject);
Var
  MagId   : Integer;
begin
  MagID := Dm_Main.Ds_mag.DataSet.FieldByName('mag_id').asInteger;
  ExecuteActiveMarque(MagId);
end;

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  //Force l'ouverture sur l'onglet Magasin
  Pgc_Main.ActivePage := Tab_Mag;
end;

procedure TFrm_Main.Nbt_AjoutArtClick(Sender: TObject);
begin
  //Ajout d'un article
  ExecuteFrm_InsArt(0);
  Dm_Main.Que_LstArticle.Close;
  Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
  Dm_Main.Que_LstArticle.Open;
end;

procedure TFrm_Main.Nbt_AjoutMrkClick(Sender: TObject);
begin
  //Ajout d'une marque
  ExecuteFrm_InsMarque(0);
  Dm_Main.Que_LstMarques.Close;
  Dm_Main.Que_LstMarques.Open;
end;

procedure TFrm_Main.Nbt_DeleteArtClick(Sender: TObject);
Var
  I         : Integer;          //Variable de boucle
begin
  //Efface les articles sélectionné
  for I := 0 to DBG_LstArticle.SelectedCount - 1 do
  Begin
    IF Dm_Main.Tbl_Article.Locate('REA_ID',DBG_LstArticle.GetValueByFieldName(DBG_LstArticle.SelectedNodes[i], 'REA_ID'),[]) then
    Begin
      Dm_Main.Tbl_Article.Delete;
    End;
  End;

  //Raffraichi la liste
  Dm_Main.Que_LstArticle.Close;
  Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
  Dm_Main.Que_LstArticle.Open;

end;

procedure TFrm_Main.Nbt_ImportCsvClick(Sender: TObject);
Var
  LstErr    : TStringList;    //Liste des articles n'ayant pas pu être ajouté
begin
  //Choix du fichier CSV
  LstErr  := TStringList.Create;
  try
    IF Dm_Main.OD_FileCsv.Execute Then
    Begin
      ImportArticle(Dm_Main.OD_FileCsv.FileName,LstErr);
    End;

    //Raffraichi la liste
    Dm_Main.Que_LstArticle.Close;
    Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
    Dm_Main.Que_LstArticle.Open;

    //Affiche la liste des articles non importés
    if LstErr.Count>0 then
    Begin
      ExecuteFrm_ListeArtErr(LstErr);
    End;
  finally
    LstErr.Free;
  end;
end;

procedure TFrm_Main.Nbt_InitMrkClick(Sender: TObject);
begin
  //Initialise le date d'activation de cette marque sur l'ensemble des magasins
  ExecuteFrm_InitDate;
end;

procedure TFrm_Main.Nbt_ModifMrkClick(Sender: TObject);
Var
  RAM_MRKID : Integer;    //Id de la marque en cours
begin
  RAM_MRKID := Dm_Main.Que_LstMarques.FieldByName('RAM_MRKID').asInteger;
  ExecuteFrm_InsMarque(RAM_MRKID);
  Dm_Main.Que_LstMarques.Close;
  Dm_Main.Que_LstMarques.Open;
  Dm_Main.QUe_LstMArques.Locate('RAM_MRKID',RAM_MRKID,[]);
end;

procedure TFrm_Main.Nbt_ParametrageClick(Sender: TObject);
var
  bRealodDatabase : Boolean;
begin
  IniCfg.AdoConnection := Dm_Main.ADOConnection;

  bRealodDatabase := False;

  bRealodDatabase := (IniCfg.ShowCfgInterface = mrOk);
  bRealodDatabase := bRealodDatabase or (Dm_Main.ADOConnection.ConnectionString <> IniCfg.MsSqlConnectionString);

  if bRealodDatabase then
    Dm_Main.OpenDatabase;

end;

procedure TFrm_Main.Pgc_MainChange(Sender: TObject);
begin
  if Pgc_Main.ActivePage = Tab_Art then
  Begin
    //Raffraichi la liste des marques
    Dm_Main.Que_LstMrkRea.Close;
    Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
    Dm_Main.Que_LstMrkRea.Open;
    Dm_Main.Que_LstArticle.Close;
    Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
    Dm_Main.Que_LstArticle.Open;
  End;
end;

procedure TFrm_Main.Nbt_insClick(Sender: TObject);
begin
  executeInsmag(0);
  dm_Main.ds_mag.dataset.Close;
  dm_Main.ds_mag.dataset.open;
end;

procedure TFrm_Main.Nbt_ModifArtClick(Sender: TObject);
Var
  REA_ID : Integer;    //Id de la marque en cours
begin
  //Ouvre la fenêtre sur l'article à modifier
  REA_ID := Dm_Main.Que_LstArticle.FieldByName('REA_ID').asInteger;
  ExecuteFrm_InsArt(REA_ID);

  //Raffraichi la liste
  Dm_Main.Que_LstArticle.Close;
  Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
  Dm_Main.Que_LstArticle.Open;

  //Positionne le curseur sur l'enregistrement modifié
  Dm_Main.Que_LstArticle.Locate('REA_ID',REA_ID,[]);
end;

procedure TFrm_Main.Nbt_modifClick(Sender: TObject);
var
  id:integer;
begin
  id:=Dm_Main.ds_mag.dataset.fieldbyname('mag_id').asinteger;
  executeInsmag(id);
  Dm_Main.ds_mag.dataset.Close;
  Dm_Main.ds_mag.dataset.open;
  Dm_Main.ds_mag.DataSet.Locate('mag_id',id,[]);
end;

procedure TFrm_Main.SBtn_QuitClick(Sender: TObject);
begin
  Close;
end;

Function TFrm_Main.ImportArticle(FichierArt:String; Var LstErr:TStringList):Boolean;
//Function Importation des articles depuis en csv
Var
  Donnees	  : TStringList;    //Charge le fichier csv
  InfoLigne : TStringList;    //Découpe la ligne en cours de traitement
  I,J       : Integer;        //Variable de boucle
  Chaine    : String;         //Variable de traitement des lignes
Begin

  //Effacement de la liste
  IF MessageDlg(RS_TXT_EFFLST,mtInformation,[mbYes,mbNo],0,mbNo)= mrYes THEN
  BEGIN
    Dm_Main.Que_LstArticle.First;
    while Not Dm_Main.Que_LstArticle.eof do
    Begin
      Dm_Main.Tbl_Article.Locate('REA_ID',Dm_Main.Que_LstArticle.FieldByName('REA_ID').asInteger,[]);
      Dm_Main.Tbl_Article.Delete;
      Dm_Main.Que_LstArticle.Next;
    End;
  END;

  //Raffraichi la liste
  Dm_Main.Que_LstArticle.Close;
  Dm_Main.Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
  Dm_Main.Que_LstArticle.Open;
  

  //Création des variables
  Donnees   := TStringList.Create;
  InfoLigne := TStringList.Create;

  //Chargement du csv
  Donnees.LoadFromFile(FichierArt);

  //Traitement des lignes de données
  for I := 1 to Donnees.Count - 1 do
    begin
      InfoLigne.Clear;
      InfoLigne.Delimiter := ';';
      InfoLigne.QuoteChar := '''';
      Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
      Chaine  := ReplaceStr(Chaine,';',''';''');
      Chaine  := Chaine + '''';
      
      InfoLigne.DelimitedText := Chaine;
      if Not Dm_Main.Que_LstArticle.Locate('REA_EAN',InfoLigne.Strings[6],[]) then
      Begin
        Dm_Main.Tbl_Article.Insert;
        Dm_Main.Tbl_Article.FieldByName('REA_REF').AsString     := InfoLigne.Strings[0];
        Dm_Main.Tbl_Article.FieldByName('REA_LIB').AsString     := InfoLigne.Strings[1];
        Dm_Main.Tbl_Article.FieldByName('REA_TAILLE').AsString  := InfoLigne.Strings[2];
        Dm_Main.Tbl_Article.FieldByName('REA_COULEUR').AsString := InfoLigne.Strings[3];
        Dm_Main.Tbl_Article.FieldByName('REA_DIV1').AsString    := InfoLigne.Strings[4];
        Dm_Main.Tbl_Article.FieldByName('REA_DIV2').AsString    := InfoLigne.Strings[5];
        Dm_Main.Tbl_Article.FieldByName('REA_EAN').AsString     := InfoLigne.Strings[6];
        Dm_Main.Tbl_Article.FieldByName('REA_MRKID').AsInteger  := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
        Dm_Main.Tbl_Article.Post;
      End
      Else
      BEGIN
        LstErr.Append(InfoLigne.Strings[0] + ' - ' + InfoLigne.Strings[1] + ' - ' + InfoLigne.Strings[6]);
      END;
    end;

  //Suppression des variables en mémoire
  Donnees.free;
  InfoLigne.Free;
End;

end.

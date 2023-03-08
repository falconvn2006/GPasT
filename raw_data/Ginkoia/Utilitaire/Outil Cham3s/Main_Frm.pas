unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin,
  dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinsdxBarPainter, dxBar, cxClasses, ExtCtrls, RzPanel, RzStatus, jpeg,
  RzBckgnd, RzTabs, StdCtrls, RzLabel, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, dximctrl, RzCmboBx, ImgList,
  LMDPNGImage, LMDBaseControl, LMDBaseGraphicControl, LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton,
  RzButton, RzRadChk, Mask, RzEdit, cxGridCustomPopupMenu, cxGridPopupMenu, Menus, RzTray, LMDCustomComponent,
  LMDWndProcComponent, LMDSysMenu, RzLstBox,Clipbrd, LMDControl, LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel,
  LMDCustomParentPanel, LMDCustomPanelFill, LMDPanelFill, RzRadGrp;

type
  TFrm_Main = class(TForm)
    Bm_MainMenu: TdxBarManager;
    Bm_MainMenuBar1: TdxBar;
    Dxb_AnalyseArtWeb: TdxBarButton;
    Dxb_DlCodeBarre: TdxBarButton;
    Dxb_ListeDispoArtWeb: TdxBarButton;
    Dxb_ListCodeBarreMmArt: TdxBarButton;
    Pan_BarStatus: TRzPanel;
    Stat_Bar: TRzStatusBar;
    Clk_Clock: TRzClockStatus;
    St_FStatus: TRzFieldStatus;
    Lim_ListeImage: TcxImageList;
    St_TextStatus: TRzStatusPane;
    Pan_fenetre: TRzPanel;
    Pgc_Main: TRzPageControl;
    Tab_Main: TRzTabSheet;
    RzBackground1: TRzBackground;
    Tab_AnalyseArtWeb: TRzTabSheet;
    Pan_PanAnalArtWeb: TRzPanel;
    Pan_AfficheAnalArtWeb: TRzPanel;
    cxGrid_AnalArtWeb: TcxGrid;
    cxGrid_AnalArtWebDBTableView1: TcxGridDBTableView;
    cxGrid_AnalArtWebDBTableView1RecId: TcxGridDBColumn;
    cxGrid_AnalArtWebDBTableView1ARF_CHRONO: TcxGridDBColumn;
    cxGrid_AnalArtWebDBTableView1ART_NOM: TcxGridDBColumn;
    cxGrid_AnalArtWebDBTableView1MRK_NOM: TcxGridDBColumn;
    cxGrid_AnalArtWebDBTableView1MRK_IDREF: TcxGridDBColumn;
    cxGrid_AnalArtWebDBTableView1ART_ID: TcxGridDBColumn;
    cxGrid_AnalArtWebLevel1: TcxGridLevel;
    Pan_1: TRzPanel;
    Lab_1: TRzLabel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView1RecId: TcxGridDBColumn;
    cxGrid1DBTableView1CBI_CB: TcxGridDBColumn;
    cxGrid1DBTableView1TGF_NOM: TcxGridDBColumn;
    cxGrid1DBTableView1COU_NOM: TcxGridDBColumn;
    cxGrid1DBTableView1GCS_NOM: TcxGridDBColumn;
    cxGrid1DBTableView1COU_ID: TcxGridDBColumn;
    cxGrid1DBTableView1TGF_ID: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    Pan_Info: TRzPanel;
    Pan_InfoArticle: TRzPanel;
    Nbt_RechargeAnalyse: TLMDSpeedButton;
    RzSeparator2: TRzSeparator;
    RzSeparator1: TRzSeparator;
    Pan_InfoArtcle: TRzPanel;
    Lab_InfoArticle: TRzLabel;
    Chp_Marque: TRzCheckBox;
    Chp_TailleCouleurCB: TRzCheckBox;
    Chp_CbTailleCouleurUnique: TRzCheckBox;
    Chp_FournOk: TRzCheckBox;
    Chp_NomenPrinR: TRzCheckBox;
    Chp_NomencPrinSync: TRzCheckBox;
    Chp_CouleurSynchro: TRzCheckBox;
    Chp_SiteEnLigne: TRzCheckBox;
    Tab_ArticleCodeBarre: TRzTabSheet;
    Pan_FenetreCbDouble: TRzPanel;
    Pan_GridCodeBarre: TRzPanel;
    Pan_titreCodeBarre: TRzPanel;
    Lab_TitreCodeBarre: TRzLabel;
    cxGrid_ArtCodeBarre: TcxGrid;
    cxGrid_ArtCodeBarreDBTableView1: TcxGridDBTableView;
    cxGrid_ArtCodeBarreLevel1: TcxGridLevel;
    Pan_InfCbDouble: TRzPanel;
    Pan_titreInfoArtCb: TRzPanel;
    Lab_InfoArtCb: TRzLabel;
    Chp_Chrono: TRzEdit;
    Lab_chrono: TRzLabel;
    Chp_ArtNom: TRzEdit;
    Lab_ArtNom: TRzLabel;
    Chp_MarqueDouble: TRzEdit;
    Lab_Marque: TRzLabel;
    Chp_FournisseurDouble: TRzEdit;
    Lab_Fournisseur: TRzLabel;
    RzSeparator3: TRzSeparator;
    RzSeparator4: TRzSeparator;
    Nbt_RechargeArtCodeBarreDouble: TLMDSpeedButton;
    Lab_NbCodeBarre: TRzLabel;
    Chp_NombreDouble: TRzEdit;
    Lab_CodeBarre: TRzLabel;
    Chp_TailleDouble: TRzEdit;
    Lab_Taille: TRzLabel;
    Chp_CouleurDouble: TRzEdit;
    Lab_Couleur: TRzLabel;
    Tab_ArtDispoWeb: TRzTabSheet;
    Pan_FenetreArticleDispoWeb: TRzPanel;
    Pan_gridListDispoWeb: TRzPanel;
    Pan_titreDispoWeb: TRzPanel;
    Lab_DispoWeb: TRzLabel;
    cxGrid_DispoWebDBTableView1: TcxGridDBTableView;
    cxGrid_DispoWebLevel1: TcxGridLevel;
    cxGrid_DispoWeb: TcxGrid;
    cxGrid_DispoWebDBTableView1RecId: TcxGridDBColumn;
    cxGrid_DispoWebDBTableView1ARF_CHRONO: TcxGridDBColumn;
    cxGrid_DispoWebDBTableView1ART_NOM: TcxGridDBColumn;
    cxGrid_DispoWebDBTableView1MRK_IDREF: TcxGridDBColumn;
    cxGrid_DispoWebDBTableView1MRK_NOM: TcxGridDBColumn;
    cxGrid_DispoWebDBTableView1TGF_NOM: TcxGridDBColumn;
    cxGrid_DispoWebDBTableView1COU_NOM: TcxGridDBColumn;
    Tab_CodeBarreMemeArt: TRzTabSheet;
    Pan_fentreCodeBarreDouble: TRzPanel;
    Pan_GridCodeBarreDouble: TRzPanel;
    Pan_titreCodeBarreDouble: TRzPanel;
    Lab_CodeBarreDouble: TRzLabel;
    cxGrid_CodeBarreDBTableView1: TcxGridDBTableView;
    cxGrid_CodeBarreLevel1: TcxGridLevel;
    cxGrid_CodeBarre: TcxGrid;
    cxGrid_ArticleCodeBarreDBTableView1: TcxGridDBTableView;
    cxGrid_ArticleCodeBarreLevel1: TcxGridLevel;
    cxGrid_ArticleCodeBarre: TcxGrid;
    cxGrid_CodeBarreDBTableView1RecId: TcxGridDBColumn;
    cxGrid_CodeBarreDBTableView1CBI_CB: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1RecId: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1ARF_ID: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1ARF_CHRONO: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1ART_NOM: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1MRK_NOM: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1MRK_IDREF: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1TGF_NOM: TcxGridDBColumn;
    cxGrid_ArticleCodeBarreDBTableView1COU_NOM: TcxGridDBColumn;
    Lab_Nomenclature: TRzLabel;
    Chp_Famille: TRzEdit;
    Chp_SousFamille: TRzEdit;
    Chp_Rayon: TRzEdit;
    PopupMenu_Grid: TPopupMenu;
    Rechargerlanalyse1: TMenuItem;
    Exporterlesdonnes1: TMenuItem;
    cxGridPopup_DoublonCBFourn: TcxGridPopupMenu;
    cxGridPopupGridDispo: TcxGridPopupMenu;
    PopupMenu_GridCodeBarre: TPopupMenu;
    Relancerlanalyse1: TMenuItem;
    cxGrid_ArtCodeBarreDBTableView1RecId: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1ART_ID: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1ARF_CHRONO: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1ART_NOM: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1MRK_IDREF: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1MRK_NOM: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1TGF_NOM: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1COU_NOM: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1TGF_ID: TcxGridDBColumn;
    cxGrid_ArtCodeBarreDBTableView1COU_ID: TcxGridDBColumn;
    Chp_ListeCodeBarre: TRzListBox;
    PopupMenu_CliqueDAnalArt: TPopupMenu;
    CopierleChronodumodle1: TMenuItem;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    CopierleChronodumodle2: TMenuItem;
    Lim_checkbox: TcxImageList;
    RzSeparator5: TRzSeparator;
    Lab_FiltreAtr: TRzLabel;
    Chp_FiltrArt: TRzComboBox;
    Filtremodle1: TMenuItem;
    Filtremodle2: TMenuItem;
    Filtremodle3: TMenuItem;
    RzTrayIcon1: TRzTrayIcon;
    PopupMenu_TrayIcon: TPopupMenu;
    Quitter1: TMenuItem;
    PopupMenu_CopieCB: TPopupMenu;
    Copierlecodebarre1: TMenuItem;
    Copierlecodebarre2: TMenuItem;
    PopupMenu_CbmemeArt: TPopupMenu;
    CopierChronoModele2: TMenuItem;
    PopupMenu_ChpListeCB: TPopupMenu;
    Copierlecodebarres1: TMenuItem;
    procedure FormShow(Sender: TObject);
    class procedure ExecuteFRM_Main(Affiche: Boolean; NomMag: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Dxb_AnalyseArtWebClick(Sender: TObject);
    procedure Tab_AnalyseArtWebShow(Sender: TObject);
    procedure cxGrid_AnalArtWebDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure Nbt_RechargeAnalyseClick(Sender: TObject);
    procedure cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure Dxb_DlCodeBarreClick(Sender: TObject);
    procedure Tab_ArticleCodeBarreShow(Sender: TObject);
    procedure cxGrid_ArtCodeBarreDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure Dxb_ListeDispoArtWebClick(Sender: TObject);
    procedure Dxb_ListCodeBarreMmArtClick(Sender: TObject);
    procedure cxGrid_CodeBarreDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure Rechargerlanalyse1Click(Sender: TObject);
    procedure Relancerlanalyse1Click(Sender: TObject);
    procedure Exporterlesdonnes1Click(Sender: TObject);
    procedure Tab_ArtDispoWebShow(Sender: TObject);
    procedure Tab_CodeBarreMemeArtShow(Sender: TObject);
    procedure CopierleChronodumodle1Click(Sender: TObject);
    procedure CopierleChronodumodle2Click(Sender: TObject);
    procedure Chp_FiltrArtChange(Sender: TObject);
    procedure Filtremodle1Click(Sender: TObject);
    procedure Filtremodle2Click(Sender: TObject);
    procedure Filtremodle3Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Copierlecodebarre1Click(Sender: TObject);
    procedure Copierlecodebarre2Click(Sender: TObject);
    procedure CopierChronoModele2Click(Sender: TObject);
    procedure Copierlecodebarres1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure rempliInfoFicheModele;
  public
    { Déclarations publiques }
    Magasin     : string;
    PosteConnec : string;
    MagID       : integer;
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  ChxMagasin_Frm,
  Patience_Frm,
  Main_Dm,
  ProgramResStr,
  Traitement;

{$R *.dfm}

procedure TFrm_Main.Chp_FiltrArtChange(Sender: TObject);
var
  WaitForm : TFrm_Patience;
begin
  //lors du changement on indique oui ou non on filtre
  if Chp_FiltrArt.ItemIndex = 1 then
  begin
    WaitForm := TFrm_Patience.Create(Self);
    WaitForm.Show;
    //Je test si le traitement n'a pas été fait
    with Dm_Main do
    begin
      St_FStatus.Caption := ChargementDonnee;
      Application.ProcessMessages;

      //on filtre parcours tous le memdArtWeb
      MemD_FiltreArtweb.Close;
      MemD_FiltreArtweb.Open;
      Dm_Main.MemD_AnalyseArtWeb.DisableControls;
      MemD_AnalyseArtWeb.First;

      //FiltreArtWeb(7765773);
      while not MemD_AnalyseArtWeb.Eof do
      begin
        FiltreArtWeb(MemD_AnalyseArtWebART_ID.AsInteger);
        MemD_AnalyseArtWeb.Next;
      end;

      MemD_AnalyseArtWeb.Close;
      MemD_AnalyseArtWeb.Open;
      MemD_AnalyseArtWeb.DisableControls;
      MemD_FiltreArtweb.First;

      while not MemD_FiltreArtweb.Eof do
      begin
        MemD_AnalyseArtWeb.Append;
        MemD_AnalyseArtWebARF_CHRONO.AsString :=  MemD_FiltreArtwebARF_CHRONO.AsString;
        MemD_AnalyseArtWebART_NOM.AsString    :=  MemD_FiltreArtwebART_NOM.AsString;
        MemD_AnalyseArtWebMRK_NOM.AsString    :=  MemD_FiltreArtwebMRK_NOM.AsString;
        MemD_AnalyseArtWebMRK_ID.AsInteger    :=  MemD_FiltreArtwebMRK_ID.AsInteger;
        MemD_AnalyseArtWebMRK_IDREF.AsInteger :=  MemD_FiltreArtwebMRK_IDREF.AsInteger;
        MemD_AnalyseArtWebART_ID.AsInteger    :=  MemD_FiltreArtwebART_ID.AsInteger;
        MemD_AnalyseArtWeb.Post;
        MemD_FiltreArtweb.Next;
      end;
      MemD_AnalyseArtWeb.First;
      MemD_AnalyseArtWeb.EnableControls;
    end;
    Dm_Main.MemD_AnalyseArtWeb.EnableControls;
    WaitForm.Destroy;
    St_FStatus.Caption    := '';
    St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtWeb.RecordCount)+ArtAfterFiltre;
  end;

  if Chp_FiltrArt.ItemIndex = 0 then
  begin
    //Clique sur l'analyse des articles web
    St_FStatus.Caption    := ChargementDonnee;
    Application.ProcessMessages;
    Screen.Cursor         := crSQLWait;
    RempliAnalyseArtWeb;
    Screen.Cursor         := crDefault;
    St_FStatus.Caption    := '';

    St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtWeb.RecordCount)+ModelesWeb;
  end;
end;

procedure TFrm_Main.CopierChronoModele2Click(Sender: TObject);
begin
  //Je mets le chrono dans le presse-papier
  Clipboard.AsText := Dm_Main.MemD_AnalyseCodeBarreDoubleArtARF_CHRONO.AsString;
end;

procedure TFrm_Main.CopierleChronodumodle1Click(Sender: TObject);
begin
  //Je mets le chrono dans le presse-papier
  if Pgc_Main.ActivePage = Tab_AnalyseArtWeb then
  begin
    Clipboard.AsText := Dm_Main.MemD_AnalyseArtWebARF_CHRONO.AsString;
  end;

  if Pgc_Main.ActivePage = Tab_CodeBarreMemeArt then
  begin
    Clipboard.AsText := Dm_Main.MemD_AnalyseCodeBarreDoubleArtARF_CHRONO.AsString;
  end;
end;

procedure TFrm_Main.CopierleChronodumodle2Click(Sender: TObject);
begin
  //Je mets le chrono dans le presse-papier
  if Pgc_Main.ActivePage = Tab_ArticleCodeBarre then
  begin
    Clipboard.AsText := Dm_Main.MemD_AnalyseArtCodeBarreARF_CHRONO.AsString;
  end;

  if Pgc_Main.ActivePage = Tab_ArtDispoWeb then
  begin
    Clipboard.AsText := Dm_Main.MemD_AnalyseArtDispoWebARF_CHRONO.AsString;
  end;
end;

procedure TFrm_Main.Copierlecodebarre1Click(Sender: TObject);
begin
  //procedure utiliser lors de la copie du code barre
  Clipboard.AsText := Dm_Main.MemD_TailleCouleurAnalyseArtWebCBI_CB.AsString;
end;

procedure TFrm_Main.Copierlecodebarre2Click(Sender: TObject);
begin
  //procedure utiliser lors de la copie du code barre
   Clipboard.AsText := Dm_Main.MemD_CodeBarreDoubleCBI_CB.AsString;
end;

procedure TFrm_Main.Copierlecodebarres1Click(Sender: TObject);
Var
  AButtonClique : TMouseButton;
begin
  //lors du clique sur la liste des code-barres copier les données vers le presse-papiers
  Clipboard.AsText := Chp_ListeCodeBarre.ItemCaption(Chp_ListeCodeBarre.ItemIndex);
  ShowMessage(Chp_ListeCodeBarre.ItemCaption(Chp_ListeCodeBarre.ItemIndex));
end;

procedure TFrm_Main.cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  //traitement à faire que sur le clique gauche de la souris
  if AButton = mbLeft then
  begin
    //lors du clique sur la cxGrid taille couleur
    Chp_CouleurSynchro.Checked        := VerifCouleurStatSync(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger);
    Chp_TailleCouleurCB.Checked       := VerifTailleCouleurCB(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger, Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger);
    Chp_CbTailleCouleurUnique.Checked := VerifCbFournUnique(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger, Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger);
    Chp_FournOk.Checked               := VerifFournOk(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger, Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger);
  end;
end;

procedure TFrm_Main.cxGrid_AnalArtWebDBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if AButton = mbLeft then
  begin
    //lors du clique sur la cxgrid qui va remplir la deuxieme cxgrid avec la taillecouleur
    RempliAnalyseArtWebTailleCouleur(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger);
    Chp_Marque.Checked                := VerifSynchroMarque(Dm_Main.MemD_AnalyseArtWebMRK_ID.AsInteger);
    Chp_NomenPrinR.Checked            := VerifNomenclatureRen(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger);
    Chp_NomencPrinSync.Checked        := VerifNomenClatureSync(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger);
    Chp_SiteEnLigne.Checked           := VerifSiteOk(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger);

    //on verifie que le filtre header n'est pas activer
    if not Filtremodle1.Checked then
    begin
      //Selectionne la 1er ligne de la grid taille couleur
      cxGrid1.SetFocus;
      Dm_Main.MemD_TailleCouleurAnalyseArtWeb.First;
      cxGrid1DBTableView1.DataController.SelectRows(0,1);

      Chp_CouleurSynchro.Checked        := VerifCouleurStatSync(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger);
      Chp_TailleCouleurCB.Checked       := VerifTailleCouleurCB(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger, Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger);
      Chp_CbTailleCouleurUnique.Checked := VerifCbFournUnique(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger, Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger);
      Chp_FournOk.Checked               := VerifFournOk(Dm_Main.MemD_AnalyseArtWebART_ID.AsInteger, Dm_Main.MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger,Dm_Main.MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger);
    end;
  end;
end;

procedure TFrm_Main.cxGrid_ArtCodeBarreDBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  //lors du clique sur une cellule
  if AButton = mbLeft then
  begin
    rempliInfoFicheModele;
  end;
end;

procedure TFrm_Main.cxGrid_CodeBarreDBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  //lors du clique on rempli le memData qui indique pour un code barre fournisseur la liste des articles qui y sont associer
  if AButton = mbLeft then
  begin
    RempliListeArtCodeBarre(Dm_Main.MemD_CodeBarreDoubleCBI_CB.AsString);
  end;
end;

procedure TFrm_Main.Dxb_AnalyseArtWebClick(Sender: TObject);
begin
//Je vérifie qu'une analyne n'a pas été déja faite pour une meilleur gestion des ressources
  if not Dm_Main.MemD_AnalyseArtWeb.IsEmpty then
  begin
    Tab_AnalyseArtWeb.PageControl.ActivePage := Tab_AnalyseArtWeb;
    Exit;
  end;

  //Clique sur l'analyse des articles web
  St_FStatus.Caption := ChargementDonnee;
  Application.ProcessMessages;
  Screen.Cursor      := crSQLWait;
  Dm_Main.MemD_AnalyseArtWeb.DisableControls;
  RempliAnalyseArtWeb;
  Dm_Main.MemD_AnalyseArtWeb.EnableControls;
  Screen.Cursor      := crDefault;
  St_FStatus.Caption := '';

  Tab_AnalyseArtWeb.PageControl.ActivePage := Tab_AnalyseArtWeb;

  St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtWeb.RecordCount)+ModelesWeb;
end;

procedure TFrm_Main.Dxb_DlCodeBarreClick(Sender: TObject);
begin
  //verification si l'analyse n'a pas été faite pour ne pas la relancer
  if not Dm_Main.MemD_AnalyseArtCodeBarre.IsEmpty then
  begin
    Tab_ArticleCodeBarre.PageControl.ActivePage := Tab_ArticleCodeBarre;
    Exit;
  end;

  //Clique pour lancer l'analyse des art avec code barre fournisseur en double
  St_FStatus.Caption := ChargementDonnee;
  Application.ProcessMessages;
  Screen.Cursor      := crSQLWait;
  RempliAnalyseArtCodeBarreDouble;
  Screen.Cursor      := crDefault;
  St_FStatus.Caption := '';
  //lors du clique on affiche la page qui liste les articles avec un code barre en double
  Tab_ArticleCodeBarre.PageControl.ActivePage := Tab_ArticleCodeBarre;
  Dm_Main.MemD_AnalyseArtCodeBarre.First;
  St_TextStatus.Caption                       := IntToStr(Dm_Main.MemD_AnalyseArtCodeBarre.RecordCount)+ModelesPlCbFourn;
  rempliInfoFicheModele;
end;

procedure TFrm_Main.Dxb_ListCodeBarreMmArtClick(Sender: TObject);
begin
  //je test si le traitement n'a pas déjà été fait
  if not Dm_Main.MemD_CodeBarreDouble.IsEmpty then
  begin
    Tab_CodeBarreMemeArt.PageControl.ActivePage := Tab_CodeBarreMemeArt;
    Exit;
  end;

  St_FStatus.Caption := ChargementDonnee;
  Application.ProcessMessages;
  Screen.Cursor      := crSQLWait;
  RempliListeCodeBarre;
  Screen.Cursor      := crDefault;
  St_FStatus.Caption := '';
  //lors du clique affiche le page controle qui liste les codes barres fournisseur en double
  Tab_CodeBarreMemeArt.PageControl.ActivePage := Tab_CodeBarreMemeArt;
  St_TextStatus.Caption                       := IntToStr(Dm_Main.MemD_CodeBarreDouble.RecordCount)+CodeBarreArt;
  Dm_Main.MemD_CodeBarreDouble.First;
end;

procedure TFrm_Main.Dxb_ListeDispoArtWebClick(Sender: TObject);
begin
  //je verifie si le traitement n'a pas déjà été fait
  if not Dm_Main.MemD_AnalyseArtDispoWeb.IsEmpty then
  begin
    Tab_ArtDispoWeb.PageControl.ActivePage := Tab_ArtDispoWeb;
    Exit;
  end;

  St_FStatus.Caption    := ChargementDonnee;
  Application.ProcessMessages;
  Screen.Cursor         := crSQLWait;
  RempliAnalyseArtNonDispo;
  Screen.Cursor         := crDefault;
  St_FStatus.Caption    := '';

  //lors du clique qui affiche la tab qui liste les non dispo sur les taille/couleur d'un article
  Tab_ArtDispoWeb.PageControl.ActivePage := Tab_ArtDispoWeb;
  Dm_Main.MemD_AnalyseArtDispoWeb.First;
  St_TextStatus.Caption                  := IntToStr(Dm_Main.MemD_AnalyseArtDispoWeb.RecordCount)+ModelesNonDispo;
end;

class procedure TFrm_Main.ExecuteFRM_Main(Affiche: Boolean; NomMag: string);
var
  Frm_FormMain: TFrm_Main;
begin
  //création de la fenètre
  Application.CreateForm(TFrm_Main, Frm_FormMain);

  if Affiche then
  begin
   // Frm_Main.Show;
   Frm_FormMain.Magasin := NomMag;
   Frm_FormMain.Show;
  end;
end;

procedure TFrm_Main.Exporterlesdonnes1Click(Sender: TObject);
begin
  //Export des données vers un fichier excel
  if Pgc_Main.ActivePage = Tab_ArticleCodeBarre then
  begin
    Screen.Cursor := crSQLWait;
    if not DirectoryExists(ExtractFilePath(Application.ExeName)+'\Export') then
    begin
     CreateDir(ExtractFilePath(Application.ExeName)+'\Export');
    end;
    Dm_Main.MemD_AnalyseArtCodeBarre.SaveToTextFile(ExtractFilePath(Application.ExeName)+'\Export\'+'Article-CodeBarre.xls');
    MessageDlg('Export des données terminé',mtInformation,[mbOK],0);
    Screen.Cursor := crDefault;
  end;

  if Pgc_Main.ActivePage = Tab_ArtDispoWeb then
  begin
    Screen.Cursor := crSQLWait;
    if not DirectoryExists(ExtractFilePath(Application.ExeName)+'\Export') then
    begin
     CreateDir(ExtractFilePath(Application.ExeName)+'\Export');
    end;
    Dm_Main.MemD_AnalyseArtDispoWeb.SaveToTextFile(ExtractFilePath(Application.ExeName)+'\Export\'+'Article-NonDispoWeb.xls');
    MessageDlg('Export des données terminé',mtInformation,[mbOK],0);
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Filtremodle1Click(Sender: TObject);
begin
  //filtre les fiches modèles
  if Filtremodle1.Checked then
  begin
    //Filtremodle1.Checked := True;
    cxGrid_AnalArtWebDBTableView1.FilterRow.GridView.Columns[1];
    cxGrid_AnalArtWebDBTableView1.FilterRow.Visible := True;
  end else
  begin
    //Filtremodle1.Checked := False;
    cxGrid_AnalArtWebDBTableView1.FilterRow.Visible := False;
  end;
end;

procedure TFrm_Main.Filtremodle2Click(Sender: TObject);
begin
  //filtre sur les modèle web , code qui active le filtre sur grid en fonction de la page control active
  if Pgc_Main.ActivePage = Tab_ArticleCodeBarre then
  begin
    if Filtremodle2.Checked then
    begin
      cxGrid_ArtCodeBarreDBTableView1.FilterRow.Visible :=  True;
    end else
    begin
      cxGrid_ArtCodeBarreDBTableView1.FilterRow.Visible := False;
    end;
  end;

  if Pgc_Main.ActivePage = Tab_ArtDispoWeb then
  begin
    if Filtremodle2.Checked then
    begin
      cxGrid_DispoWebDBTableView1.FilterRow.Visible :=  True;
    end else
    begin
      cxGrid_DispoWebDBTableView1.FilterRow.Visible := False;
    end;
  end;
end;

procedure TFrm_Main.Filtremodle3Click(Sender: TObject);
begin
  //activer ou désactiver le filtre sur les codes barres
  if Filtremodle3.Checked then
  begin
    cxGrid_CodeBarreDBTableView1.FilterRow.Visible := True;
  end else
  begin
    cxGrid_CodeBarreDBTableView1.FilterRow.Visible := False;
  end;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Code qui permet de fermer le fenetre
  Self.Free;
  Frm_ChxMagasin.Close;
  Application.Terminate;
end;

procedure TFrm_Main.FormShow(Sender: TObject);
Var
  P : Pointer;
begin
  //execution à l'affichage de la fenetre

  //positionnement de la fenetre au centre de lecran
  Self.Top  := (Screen.Height-Height) div 2;
  Self.Left := (Screen.Width-Width)   div 2;

  //recherche le magasin sur lequel on travail
  Dm_Main.Que_ChxMagasin.Close;
  Dm_Main.Que_ChxMagasin.ParamByName('MAG').AsString := '%'+Magasin+'%';
  Dm_Main.Que_ChxMagasin.Open;

  //remplie les champs par rapport au magasin sélectionner
  PosteConnec  := Dm_Main.Que_ChxMagasin.FieldByName('BAS_NOM').AsString;
  MagID        := Dm_Main.Que_ChxMagasin.FieldByName('BAS_MAGID').AsInteger;
  Self.Caption := 'Magasin : '+Magasin+' / '+PosteConnec;

  //Chargement des images
  Lim_ListeImage.GetBitmap(2,Rechargerlanalyse1.Bitmap);
  Lim_ListeImage.GetBitmap(2, Relancerlanalyse1.Bitmap);
  Lim_ListeImage.GetBitmap(5,Exporterlesdonnes1.Bitmap);
  Lim_ListeImage.GetBitmap(7,CopierleChronodumodle1.Bitmap);
  Lim_ListeImage.GetBitmap(7,CopierleChronodumodle2.Bitmap);

  Lim_ListeImage.GetBitmap(2,Nbt_RechargeAnalyse.Glyph);
  Lim_ListeImage.GetBitmap(2,Nbt_RechargeArtCodeBarreDouble.Glyph);

  Lim_ListeImage.GetBitmap(11,Dxb_ListCodeBarreMmArt.Glyph);
  Lim_ListeImage.GetBitmap(8,Dxb_AnalyseArtWeb.Glyph);
  Lim_ListeImage.GetBitmap(9,Dxb_DlCodeBarre.Glyph);
  Lim_ListeImage.GetBitmap(10,Dxb_ListeDispoArtWeb.Glyph);

  //Filtre sur les articles web
  Chp_FiltrArt.ItemIndex := 0;

  //je défini la fenetre actuel commme form principal
  P           := @Application.MainForm;
  Pointer(P^) := Self;

  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

procedure TFrm_Main.Nbt_RechargeAnalyseClick(Sender: TObject);
begin
  //Clique sur l'analyse des articles web
  St_FStatus.Hint    := ChargementDonnee;
  Screen.Cursor      := crSQLWait;
  RempliAnalyseArtWeb;
  Screen.Cursor      := crDefault;
  St_FStatus.Caption := '';
end;

procedure TFrm_Main.Quitter1Click(Sender: TObject);
begin
  //lors du clique droit sur la tray icon
  Self.Free;
  Frm_ChxMagasin.Close;
  Application.Terminate;
end;

procedure TFrm_Main.Rechargerlanalyse1Click(Sender: TObject);
begin
  //procedure qui recharge l'analyse
 if Pgc_Main.ActivePage = Tab_ArticleCodeBarre then
 begin
   RempliAnalyseArtCodeBarreDouble;
   Dm_Main.MemD_AnalyseArtCodeBarre.First;
 end;

  if Pgc_Main.ActivePage = Tab_ArtDispoWeb then
 begin
   RempliAnalyseArtNonDispo;
   Dm_Main.MemD_AnalyseArtDispoWeb.First;
 end;
end;

procedure TFrm_Main.Relancerlanalyse1Click(Sender: TObject);
begin
  //relance l'analyse des codes barres présents sur des articles différents
  RempliListeCodeBarre;
end;

procedure TFrm_Main.rempliInfoFicheModele;
begin
  //rempli les infos
  //lors du clique sur la grid qui liste les articles avec un code barre fournisseur en double
  Chp_Chrono.Text            := Dm_Main.MemD_AnalyseArtCodeBarreARF_CHRONO.AsString;
  Chp_ArtNom.Text            := Dm_Main.MemD_AnalyseArtCodeBarreART_NOM.AsString;
  Chp_MarqueDouble.Text      := Dm_Main.MemD_AnalyseArtCodeBarreMRK_NOM.AsString;
  Chp_FournisseurDouble.Text := GetFournisseur(Dm_Main.MemD_AnalyseArtCodeBarreART_ID.AsInteger);
  Chp_TailleDouble.Text      := Dm_Main.MemD_AnalyseArtCodeBarreTGF_NOM.AsString;
  Chp_CouleurDouble.Text     := Dm_Main.MemD_AnalyseArtCodeBarreCOU_NOM.AsString;

  //Pour l'affichage de la nomenclature
  GetNomenclature(Dm_Main.MemD_AnalyseArtCodeBarreART_ID.AsInteger);
  Chp_Famille.Text           := Dm_Main.MemD_GetNomenclatureFAM_NOM.AsString;
  Chp_SousFamille.Text       := Dm_Main.MemD_GetNomenclatureSSF_NOM.AsString;
  Chp_Rayon.Text             := Dm_Main.MemD_GetNomenclatureRAY_NOM.AsString;

  //pour l'affichage des codes-barres
  RempliLigneArtCodeBarreDouble(Dm_Main.MemD_AnalyseArtCodeBarreART_ID.AsInteger,Dm_Main.MemD_AnalyseArtCodeBarreTGF_ID.AsInteger,Dm_Main.MemD_AnalyseArtCodeBarreCOU_ID.AsInteger);
  Chp_NombreDouble.Text      := IntToStr(Dm_Main.MemD_LigneArtCodeBarre.RecordCount);
  //Remplissage de la liste des codes barres
  Chp_ListeCodeBarre.Clear;
  Dm_Main.MemD_LigneArtCodeBarre.First;

  while not Dm_Main.MemD_LigneArtCodeBarre.Eof do
  begin
    Chp_ListeCodeBarre.Add(Dm_Main.MemD_LigneArtCodeBarreCBI_CB.AsString);
    Dm_Main.MemD_LigneArtCodeBarre.Next;
  end;
end;

procedure TFrm_Main.Tab_AnalyseArtWebShow(Sender: TObject);
begin
  if Chp_FiltrArt.ItemIndex = 1 then
  begin
    St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtWeb.RecordCount)+ArtAfterFiltre;
  end else
  begin
    St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtWeb.RecordCount)+ModelesWeb;
  end;
end;

procedure TFrm_Main.Tab_ArtDispoWebShow(Sender: TObject);
begin
  St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtDispoWeb.RecordCount)+ModelesNonDispo;
end;

procedure TFrm_Main.Tab_ArticleCodeBarreShow(Sender: TObject);
begin
  St_TextStatus.Caption := IntToStr(Dm_Main.MemD_AnalyseArtCodeBarre.RecordCount)+ModelesPlCbFourn;
end;

procedure TFrm_Main.Tab_CodeBarreMemeArtShow(Sender: TObject);
begin
  St_TextStatus.Caption := IntToStr(Dm_Main.MemD_CodeBarreDouble.RecordCount)+CodeBarreArt;
end;

end.

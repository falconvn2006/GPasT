unit Main_Frm;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  ActiveX, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GinkoiaStyle_dm, AdvGlowButton, ExtCtrls, RzPanel,
  ComCtrls, vgPageControlRv, StdCtrls, FileCtrl, StrUtils, AdvDBComboBox,
  Grids,  DBCtrls, DateUtils,
  Main_Dm, Load_Frm, uClient, uRefArticle, uHistorique, uDefs, uCommon, DB,
  DBClient, Buttons, DBGrids, UVersion, AppEvnts, IBSQL, uBonRapprochement, uAtelier;

Const
  FileNotExist = $c7c7f6;
  FileExist = clWindow;  //TAlgolDialogForm

type
  TFrm_Main = class(TForm)
    Pan_Bottom: TRzPanel;
    Btn_Quitter: TAdvGlowButton;
    Lbl_BaseGinkoia: TLabel;
    Btn_Importer: TAdvGlowButton;
    Ed_BasePath: TEdit;
    Btn_BasePath: TAdvGlowButton;
    Lbl_Magasin: TLabel;
    Cb_Magasin: TComboBox;
    Btn_PtVirg: TAdvGlowButton;
    OD_OpenFic: TOpenDialog;
    Label1: TLabel;
    Cb_Provenance: TComboBox;
    Chk_TousMag: TCheckBox;
    Label2: TLabel;
    Ed_Dossier: TEdit;
    Lbl_GrpTarif: TLabel;
    Chk_PasDeRecalStk: TCheckBox;
    Btn_Mail: TAdvGlowButton;
    Rgr_NivMail: TRadioGroup;
    vgPageControlRv1: TvgPageControlRv;
    Tab_Clients: TTabSheet;
    lbl_ClientsPath: TLabel;
    lbl_ClientsCsv: TLabel;
    lbl_ComptesCsv: TLabel;
    lbl_FideliteCsv: TLabel;
    lbl_BonAchatsCsv: TLabel;
    chk_ChargementClients: TCheckBox;
    ed_ClientsPath: TEdit;
    btn_ClientsPath: TAdvGlowButton;
    ed_ClientsCsv: TEdit;
    btn_ClientsCsv: TAdvGlowButton;
    ed_ComptesCsv: TEdit;
    btn_ComptesCsv: TAdvGlowButton;
    Chk_InsererEnteteCli: TCheckBox;
    Chk_RetirePtVirgCli: TCheckBox;
    ed_FideliteCsv: TEdit;
    btn_FideliteCsv: TAdvGlowButton;
    btn_BonAchatsCsv: TAdvGlowButton;
    ed_BonAchatsCsv: TEdit;
    Tab_RefArticle: TTabSheet;
    lbl_MarqueCsv: TLabel;
    lbl_FournCsv: TLabel;
    lbl_ArticlePath: TLabel;
    lbl_GrTailleCsv: TLabel;
    lbl_FoumarqueCsv: TLabel;
    lbl_AxeNiveau1Csv: TLabel;
    lbl_AxeNiveau2Csv: TLabel;
    lbl_AxeCsv: TLabel;
    lbl_GrTailleLigCsv: TLabel;
    lbl_AxeNiveau3Csv: TLabel;
    lbl_AxeNiveau4Csv: TLabel;
    lbl_PrixAchatCsv: TLabel;
    lbl_CodeBarreCsv: TLabel;
    lbl_CouleurCsv: TLabel;
    lbl_ArticleCollectionCsv: TLabel;
    lbl_ArticleAxeCsv: TLabel;
    lbl_ArticleCsv: TLabel;
    lbl_CollectionCsv: TLabel;
    lbl_DomaineCommercialCsv: TLabel;
    lbl_GenreCsv: TLabel;
    lbl_PrixVenteCsv: TLabel;
    lbl_FouContactCsv: TLabel;
    lbl_ModeleDeprecieCsv: TLabel;
    lbl_FouConditionCsv: TLabel;
    lbl_PrixVenteIndicatifCsv: TLabel;
    lbl_ArtidealCsv: TLabel;
    lbl_OcTeteCsv: TLabel;
    lbl_OcDetailCsv: TLabel;
    lbl_OcLignesCsv: TLabel;
    lbl_OcMagCsv: TLabel;
    chk_ChargementArticle: TCheckBox;
    ed_ArticlePath: TEdit;
    ed_FournCsv: TEdit;
    ed_MarqueCsv: TEdit;
    btn_ArticlePath: TAdvGlowButton;
    btn_FournCsv: TAdvGlowButton;
    btn_MarqueCsv: TAdvGlowButton;
    ed_FoumarqueCsv: TEdit;
    btn_FoumarqueCsv: TAdvGlowButton;
    btn_GrTailleCsv: TAdvGlowButton;
    ed_GrTailleCsv: TEdit;
    btn_AxeNiveau2Csv: TAdvGlowButton;
    btn_AxeNiveau1Csv: TAdvGlowButton;
    btn_AxeCsv: TAdvGlowButton;
    btn_GrTailleLigCsv: TAdvGlowButton;
    ed_GrTailleLigCsv: TEdit;
    ed_AxeCsv: TEdit;
    ed_AxeNiveau2Csv: TEdit;
    ed_AxeNiveau1Csv: TEdit;
    btn_AxeNiveau3Csv: TAdvGlowButton;
    btn_AxeNiveau4Csv: TAdvGlowButton;
    ed_AxeNiveau4Csv: TEdit;
    ed_AxeNiveau3Csv: TEdit;
    btn_CodeBarreCsv: TAdvGlowButton;
    btn_PrixAchatCsv: TAdvGlowButton;
    btn_CouleurCsv: TAdvGlowButton;
    btn_ArticleCollectionCsv: TAdvGlowButton;
    btn_ArticleAxeCsv: TAdvGlowButton;
    btn_ArticleCsv: TAdvGlowButton;
    btn_CollectionCsv: TAdvGlowButton;
    ed_CollectionCsv: TEdit;
    ed_ArticleCsv: TEdit;
    ed_ArticleAxeCsv: TEdit;
    ed_ArticleCollectionCsv: TEdit;
    ed_CouleurCsv: TEdit;
    ed_CodeBarreCsv: TEdit;
    ed_PrixAchatCsv: TEdit;
    ed_DomaineCommercialCsv: TEdit;
    btn_DomaineCommercialCsv: TAdvGlowButton;
    ed_GenreCsv: TEdit;
    Btn_GenreCsv: TAdvGlowButton;
    ed_PrixVenteCsv: TEdit;
    btn_PrixVenteCsv: TAdvGlowButton;
    Chk_InsererEnteteArt: TCheckBox;
    Chk_RetirePtVirgArt: TCheckBox;
    btn_ModeleDeprecieCsv: TAdvGlowButton;
    btn_FouContactCsv: TAdvGlowButton;
    ed_ModeleDeprecieCsv: TEdit;
    ed_FouContactCsv: TEdit;
    ed_FouConditionCsv: TEdit;
    btn_FouConditionCsv: TAdvGlowButton;
    Ed_PrixVenteIndicatifCsv: TEdit;
    Btn_PrixVenteIndicatifCsv: TAdvGlowButton;
    ed_ArtidealCsv: TEdit;
    btn_ArtidealCsv: TAdvGlowButton;
    ed_OcTeteCsv: TEdit;
    ed_OcMagCsv: TEdit;
    ed_OcLignesCsv: TEdit;
    ed_OcDetailCsv: TEdit;
    btn_OcTeteCsv: TAdvGlowButton;
    btn_OcDetailCsv: TAdvGlowButton;
    btn_OcLignesCsv: TAdvGlowButton;
    btn_OcMagCsv: TAdvGlowButton;
    Tab_Historiques: TTabSheet;
    lbl_HistoriquesPath: TLabel;
    lbl_CaisseCsv: TLabel;
    lbl_ReceptionCsv: TLabel;
    lbl_ConsodivCsv: TLabel;
    lbl_TransfertCsv: TLabel;
    lbl_CommandesCsv: TLabel;
    lbl_RetourFouCsv: TLabel;
    btn_HistoriquesPath: TAdvGlowButton;
    btn_CaisseCsv: TAdvGlowButton;
    ed_CaisseCsv: TEdit;
    ed_HistoriquesPath: TEdit;
    ed_ReceptionCsv: TEdit;
    ed_ConsodivCsv: TEdit;
    ed_TransfertCsv: TEdit;
    ed_CommandesCsv: TEdit;
    btn_CommandesCsv: TAdvGlowButton;
    btn_TransfertCsv: TAdvGlowButton;
    btn_ConsodivCsv: TAdvGlowButton;
    btn_ReceptionCsv: TAdvGlowButton;
    chk_ChargementHistoriques: TCheckBox;
    Chk_InsererEnteteHis: TCheckBox;
    Chk_RetirePtVirgHis: TCheckBox;
    Bt_Recal: TAdvGlowButton;
    ed_RetourFouCsv: TEdit;
    btn_RetourFouCsv: TAdvGlowButton;
    Tab_Reprise: TTabSheet;
    lbl_RepriseCaisse: TLabel;
    lbl_RepriseClient: TLabel;
    lbl_RepriseCompte: TLabel;
    ed_RepriseCaisse: TEdit;
    Bt_Reprise: TAdvGlowButton;
    Chk_InsererEnteteReprise: TCheckBox;
    Chk_RetirePtVirgReprise: TCheckBox;
    Btn_RepriseCaisse: TAdvGlowButton;
    ed_RepriseClient: TEdit;
    Btn_RepriseClient: TAdvGlowButton;
    ed_RepriseCompte: TEdit;
    Btn_RepriseCompte: TAdvGlowButton;
    Bt_Chrono: TAdvGlowButton;
    btn_CClientsCsv: TAdvGlowButton;
    btn_CComptesCsv: TAdvGlowButton;
    btn_CFideliteCsv: TAdvGlowButton;
    btn_CBonAchatsCsv: TAdvGlowButton;
    btn_CFournCsv: TAdvGlowButton;
    btn_CMarqueCsv: TAdvGlowButton;
    btn_CFoumarqueCsv: TAdvGlowButton;
    btn_CGrTailleCsv: TAdvGlowButton;
    btn_CGrTailleLigCsv: TAdvGlowButton;
    btn_CDomaineCommercialCsv: TAdvGlowButton;
    btn_CAxeCsv: TAdvGlowButton;
    btn_CAxeNiveau1Csv: TAdvGlowButton;
    btn_CAxeNiveau2Csv: TAdvGlowButton;
    btn_CAxeNiveau3Csv: TAdvGlowButton;
    btn_CAxeNiveau4Csv: TAdvGlowButton;
    btn_CCollectionCsv: TAdvGlowButton;
    Btn_CGenreCsv: TAdvGlowButton;
    btn_CArticleCsv: TAdvGlowButton;
    btn_CArticleAxeCsv: TAdvGlowButton;
    btn_CArticleCollectionCsv: TAdvGlowButton;
    btn_CCouleurCsv: TAdvGlowButton;
    btn_CCodeBarreCsv: TAdvGlowButton;
    btn_CPrixAchatCsv: TAdvGlowButton;
    btn_CPrixVenteCsv: TAdvGlowButton;
    Btn_CPrixVenteIndicatifCsv: TAdvGlowButton;
    btn_CModeleDeprecieCsv: TAdvGlowButton;
    btn_CFouConditionCsv: TAdvGlowButton;
    btn_CArtidealCsv: TAdvGlowButton;
    btn_COcTeteCsv: TAdvGlowButton;
    btn_COcMagCsv: TAdvGlowButton;
    btn_COcLignesCsv: TAdvGlowButton;
    btn_COcDetailCsv: TAdvGlowButton;
    btn_CCaisseCsv: TAdvGlowButton;
    btn_CReceptionCsv: TAdvGlowButton;
    btn_CConsodivCsv: TAdvGlowButton;
    btn_CTransfertCsv: TAdvGlowButton;
    btn_CCommandesCsv: TAdvGlowButton;
    btn_CRetourFouCsv: TAdvGlowButton;
    Btn_CRepriseClient: TAdvGlowButton;
    Btn_CRepriseCompte: TAdvGlowButton;
    Btn_CRepriseCaisse: TAdvGlowButton;
    btn_CFouContactCsv: TAdvGlowButton;
    Btn_ReprisePath: TAdvGlowButton;
    Ed_ReprisePath: TEdit;
    Lab_ReprisePath: TLabel;
    Cb_TarVente: TComboBox;
    Chk_SecondImport: TCheckBox;
    Chk_Correction_TVA: TCheckBox;
    Lbl_AvoirCsv: TLabel;
    ed_AvoirCsv: TEdit;
    btn_AvoirCsv: TAdvGlowButton;
    btn_CAvoirCsv: TAdvGlowButton;
    btn_Correct_Avoir: TAdvGlowButton;
    Chk_GentriggerDiff: TCheckBox;
    btn_Correct_Lien: TAdvGlowButton;
    lbl_LienClientsCsv: TLabel;
    ed_LienClientsCsv: TEdit;
    btn_LienClientsCsv: TAdvGlowButton;
    btn_CLienClientCsv: TAdvGlowButton;
    ed_RepriseAvoir: TEdit;
    lbl_RepriseAvoir: TLabel;
    Btn_RepriseAvoir: TAdvGlowButton;
    Btn_CRepriseAvoir: TAdvGlowButton;
    ed_BonLivraisonCsv: TEdit;
    lbl_BonLivraison: TLabel;
    btn_BonLivraisonCsv: TAdvGlowButton;
    btn_CBonLivraisonCsv: TAdvGlowButton;
    ed_BonLivraisonLCsv: TEdit;
    lbl_BonLivraisonL: TLabel;
    btn_BonLivraisonLCsv: TAdvGlowButton;
    btn_CBonLivraisonLCsv: TAdvGlowButton;
    ed_BonLivraisonHistoCsv: TEdit;
    lbl_BonLivraisonHisto: TLabel;
    btn_BonLivraisonHistoCsv: TAdvGlowButton;
    btn_CBonLivraisonHistoCsv: TAdvGlowButton;
    lbl_RepriseBonLivraison: TLabel;
    ed_RepriseBonLivraison: TEdit;
    Btn_RepriseBonLivraison: TAdvGlowButton;
    Btn_CRepriseBonLivraison: TAdvGlowButton;
    lbl_RepriseBonLivraisonL: TLabel;
    ed_RepriseBonLivraisonL: TEdit;
    Btn_RepriseBonLivraisonL: TAdvGlowButton;
    Btn_CRepriseBonLivraisonL: TAdvGlowButton;
    ed_RepriseBonLivraisonHisto: TEdit;
    lbl_RepriseBonLivraisonHisto: TLabel;
    Btn_RepriseBonLivraisonHisto: TAdvGlowButton;
    Btn_CRepriseBonLivraisonHisto: TAdvGlowButton;
    Tab_BonRapprochement: TTabSheet;
    Chk_InsererEnteteBonR: TCheckBox;
    Chk_RetirePtVirgBonR: TCheckBox;
    LabelCheminBonRapprochement: TLabel;
    EditCheminBonRapprochement: TEdit;
    Btn_CheminBonRapprochement: TAdvGlowButton;
    LabelBonRapprochementCsv: TLabel;
    LabelBonRapprochementLienCsv: TLabel;
    LabelBonRapprochementTVACsv: TLabel;
    LabelBonRapprochementLigneReceptionCsv: TLabel;
    LabelBonRapprochementLigneRetourCsv: TLabel;
    EditBonRapprochementCsv: TEdit;
    EditBonRapprochementLienCsv: TEdit;
    EditBonRapprochementTVACsv: TEdit;
    EditBonRapprochementLigneReceptionCsv: TEdit;
    EditBonRapprochementLigneRetourCsv: TEdit;
    Btn_BonRapprochementCsv: TAdvGlowButton;
    Btn_CBonRapprochementCsv: TAdvGlowButton;
    Btn_BonRapprochementLienCsv: TAdvGlowButton;
    Btn_CBonRapprochementLienCsv: TAdvGlowButton;
    Btn_BonRapprochementTVACsv: TAdvGlowButton;
    Btn_CBonRapprochementTVACsv: TAdvGlowButton;
    Btn_BonRapprochementLigneReceptionCsv: TAdvGlowButton;
    Btn_CBonRapprochementLigneReceptionCsv: TAdvGlowButton;
    Btn_BonRapprochementLigneRetourCsv: TAdvGlowButton;
    Btn_CBonRapprochementLigneRetourCsv: TAdvGlowButton;
    chk_ChargementBonsRapprochement: TCheckBox;
    Tab_Atelier: TTabSheet;
    chk_ChargementAtelier: TCheckBox;
    Chk_InsererEnteteAtelier: TCheckBox;
    Chk_RetirePtVirgAtelier: TCheckBox;

    LabelCheminAtelier: TLabel;
    EditCheminAtelier: TEdit;
    Btn_CheminAtelier: TAdvGlowButton;
    LabelSavTauxHCsv: TLabel;
    LabelSavForfaitCsv: TLabel;
    LabelSavForfaitLCsv: TLabel;
    LabelSavPt1Csv: TLabel;
    LabelSavPt2Csv: TLabel;
    LabelSavTypMatCsv: TLabel;
    LabelSavTypeCsv: TLabel;
    LabelSavMatCsv: TLabel;
    LabelSavCbCsv: TLabel;
    LabelSavFicheeCsv: TLabel;
    LabelSavFicheLCsv: TLabel;
    LabelSavFicheArtCsv: TLabel;
    EditSavTauxHCsv: TEdit;
    EditSavForfaitCsv: TEdit;
    EditSavForfaitLCsv: TEdit;
    EditSavPt1Csv: TEdit;
    EditSavPt2Csv: TEdit;
    EditSavTypMatCsv: TEdit;
    EditSavTypeCsv: TEdit;
    EditSavMatCsv: TEdit;
    EditSavCbCsv: TEdit;
    EditSavFicheeCsv: TEdit;
    EditSavFicheLCsv: TEdit;
    EditSavFicheArtCsv: TEdit;
    Btn_SavTauxHCsv: TAdvGlowButton;
    Btn_SavForfaitCsv: TAdvGlowButton;
    Btn_SavForfaitLCsv: TAdvGlowButton;
    Btn_SavPt1Csv: TAdvGlowButton;
    Btn_SavPt2Csv: TAdvGlowButton;
    Btn_SavTypMatCsv: TAdvGlowButton;
    Btn_SavTypeCsv: TAdvGlowButton;
    Btn_SavMatCsv: TAdvGlowButton;
    Btn_SavCbCsv: TAdvGlowButton;
    Btn_SavFicheeCsv: TAdvGlowButton;
    Btn_SavFicheLCsv: TAdvGlowButton;
    Btn_SavFicheArtCsv: TAdvGlowButton;
    Btn_CSavTauxHCsv: TAdvGlowButton;
    Btn_CSavForfaitCsv: TAdvGlowButton;
    Btn_CSavForfaitLCsv: TAdvGlowButton;
    Btn_CSavPt1Csv: TAdvGlowButton;
    Btn_CSavPt2Csv: TAdvGlowButton;
    Btn_CSavTypMatCsv: TAdvGlowButton;
    Btn_CSavTypeCsv: TAdvGlowButton;
    Btn_CSavMatCsv: TAdvGlowButton;
    Btn_CSavCbCsv: TAdvGlowButton;
    Btn_CSavFicheeCsv: TAdvGlowButton;
    Btn_CSavFicheLCsv: TAdvGlowButton;
    Btn_CSavFicheArtCsv: TAdvGlowButton;
    chk_noBackup: TCheckBox;

    procedure Btn_QuitterClick(Sender: TObject);
    procedure Btn_BasePathClick(Sender: TObject);
    procedure btn_ClientsPathClick(Sender: TObject);
    procedure btn_ClientsCsvClick(Sender: TObject);
    procedure chk_ChargementClientsClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure chk_ChargementArticleClick(Sender: TObject);
    procedure chk_ChargementHistoriquesClick(Sender: TObject);
    procedure btn_ArticlePathClick(Sender: TObject);
    procedure btn_HistoriquesPathClick(Sender: TObject);
    procedure btn_FournCsvClick(Sender: TObject);
    procedure btn_ComptesCsvClick(Sender: TObject);
    procedure btn_MarqueCsvClick(Sender: TObject);
    procedure btn_FoumarqueCsvClick(Sender: TObject);
    procedure btn_GrTailleCsvClick(Sender: TObject);
    procedure btn_GrTailleLigCsvClick(Sender: TObject);
    procedure btn_AxeCsvClick(Sender: TObject);
    procedure btn_AxeNiveau1CsvClick(Sender: TObject);
    procedure btn_AxeNiveau2CsvClick(Sender: TObject);
    procedure btn_AxeNiveau3CsvClick(Sender: TObject);
    procedure btn_AxeNiveau4CsvClick(Sender: TObject);
    procedure btn_CollectionCsvClick(Sender: TObject);
    procedure btn_ArticleCsvClick(Sender: TObject);
    procedure btn_ArticleAxeCsvClick(Sender: TObject);
    procedure btn_ArticleCollectionCsvClick(Sender: TObject);
    procedure btn_CouleurCsvClick(Sender: TObject);
    procedure btn_CodeBarreCsvClick(Sender: TObject);
    procedure btn_PrixAchatCsvClick(Sender: TObject);
    procedure btn_CaisseCsvClick(Sender: TObject);
    procedure btn_ReceptionCsvClick(Sender: TObject);
    procedure btn_ConsodivCsvClick(Sender: TObject);
    procedure btn_TransfertCsvClick(Sender: TObject);
    procedure btn_CommandesCsvClick(Sender: TObject);
    procedure Btn_ImporterClick(Sender: TObject);
    procedure Cb_MagasinChange(Sender: TObject);
    procedure ed_Change(Sender: TObject);
    procedure btn_DomaineCommercialCsvClick(Sender: TObject);
    procedure Btn_GenreCsvClick(Sender: TObject);
    procedure AlgolDialogFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Btn_PtVirgClick(Sender: TObject);
    procedure btn_ModeleDeprecieCsvClick(Sender: TObject);
    procedure btn_FouContactCsvClick(Sender: TObject);
    procedure btn_FouConditionCsvClick(Sender: TObject);
    procedure Chk_TousMagClick(Sender: TObject);
    procedure Cb_ProvenanceChange(Sender: TObject);
    procedure Bt_RecalClick(Sender: TObject);
    procedure AlgolDialogFormDestroy(Sender: TObject);
    procedure Ed_DossierKeyPress(Sender: TObject; var Key: Char);
    procedure btn_RetourFouCsvClick(Sender: TObject);
    procedure Btn_PrixVenteIndicatifCsvClick(Sender: TObject);
    procedure btn_PrixVenteCsvClick(Sender: TObject);
    procedure Btn_RepriseCaisseClick(Sender: TObject);
    procedure Bt_RepriseClick(Sender: TObject);
    procedure Cb_TarVenteChange(Sender: TObject);
    procedure Btn_RepriseClientClick(Sender: TObject);
    procedure Btn_RepriseCompteClick(Sender: TObject);
    procedure Bt_ChronoClick(Sender: TObject);
    procedure Chk_PasDeRecalStkClick(Sender: TObject);
    procedure Btn_MailClick(Sender: TObject);
    procedure btn_OcDetailCsvClick(Sender: TObject);
    procedure btn_OcLignesCsvClick(Sender: TObject);
    procedure btn_OcMagCsvClick(Sender: TObject);
    procedure btn_OcTeteCsvClick(Sender: TObject);
    procedure btn_ArtidealCsvClick(Sender: TObject);
    procedure Rgr_NivMailClick(Sender: TObject);
    procedure btn_FideliteCsvClick(Sender: TObject);
    procedure btn_BonAchatsCsvClick(Sender: TObject);
    procedure btn_CClientsCsvClic(Sender: TObject);
    procedure btn_CComptesCsvClick(Sender: TObject);
    procedure btn_CFideliteCsvClick(Sender: TObject);
    procedure btn_CBonAchatsCsvClick(Sender: TObject);
    procedure btn_CFournCsvClick(Sender: TObject);
    procedure btn_CMarqueCsvClick(Sender: TObject);
    procedure btn_CFoumarqueCsvClick(Sender: TObject);
    procedure btn_CGrTailleCsvClick(Sender: TObject);
    procedure btn_CGrTailleLigCsvClick(Sender: TObject);
    procedure btn_CDomaineCommercialCsvClick(Sender: TObject);
    procedure btn_CAxeCsvClick(Sender: TObject);
    procedure btn_CAxeNiveau1CsvClick(Sender: TObject);
    procedure btn_CAxeNiveau2CsvClick(Sender: TObject);
    procedure btn_CAxeNiveau3CsvClick(Sender: TObject);
    procedure btn_CAxeNiveau4CsvClick(Sender: TObject);
    procedure btn_CCollectionCsvClick(Sender: TObject);
    procedure Btn_CGenreCsvClick(Sender: TObject);
    procedure btn_CArticleCsvClick(Sender: TObject);
    procedure btn_CArticleAxeCsvClick(Sender: TObject);
    procedure btn_CArticleCollectionCsvClick(Sender: TObject);
    procedure btn_CCouleurCsvClick(Sender: TObject);
    procedure btn_CCodeBarreCsvClick(Sender: TObject);
    procedure btn_CPrixAchatCsvClick(Sender: TObject);
    procedure btn_CPrixVenteCsvClick(Sender: TObject);
    procedure Btn_CPrixVenteIndicatifCsvClick(Sender: TObject);
    procedure btn_CModeleDeprecieCsvClick(Sender: TObject);
    procedure btn_CFouContactCsvClick(Sender: TObject);
    procedure btn_CFouConditionCsvClick(Sender: TObject);
    procedure btn_CArtidealCsvClick(Sender: TObject);
    procedure btn_COcTeteCsvClick(Sender: TObject);
    procedure btn_COcMagCsvClick(Sender: TObject);
    procedure btn_COcLignesCsvClick(Sender: TObject);
    procedure btn_COcDetailCsvClick(Sender: TObject);
    procedure btn_CCaisseCsvClick(Sender: TObject);
    procedure btn_CReceptionCsvClick(Sender: TObject);
    procedure btn_CConsodivCsvClick(Sender: TObject);
    procedure btn_CTransfertCsvClick(Sender: TObject);
    procedure btn_CCommandesCsvClick(Sender: TObject);
    procedure btn_CRetourFouCsvClick(Sender: TObject);
    procedure Btn_CRepriseClientClick(Sender: TObject);
    procedure Btn_CRepriseCompteClick(Sender: TObject);
    procedure Btn_CRepriseCaisseClick(Sender: TObject);
    procedure Btn_ReprisePathClick(Sender: TObject);
    procedure Chk_SecondImportClick(Sender: TObject);
    procedure btn_CAvoirCsvClick(Sender: TObject);
    procedure btn_AvoirCsvClick(Sender: TObject);
    procedure btn_Correct_AvoirClick(Sender: TObject);
    procedure btn_Correct_LienClick(Sender: TObject);
    procedure btn_LienClientsCsvClick(Sender: TObject);
    procedure btn_CLienClientCsvClick(Sender: TObject);
    procedure Btn_RepriseAvoirClick(Sender: TObject);
    procedure Btn_CRepriseAvoirClick(Sender: TObject);
    procedure btn_BonLivraisonCsvClick(Sender: TObject);
    procedure btn_CBonLivraisonCsvClick(Sender: TObject);
    procedure btn_BonLivraisonLCsvClick(Sender: TObject);
    procedure btn_CBonLivraisonLCsvClick(Sender: TObject);
    procedure btn_BonLivraisonHistoCsvClick(Sender: TObject);
    procedure btn_CBonLivraisonHistoCsvClick(Sender: TObject);
    procedure Btn_RepriseBonLivraisonClick(Sender: TObject);
    procedure Btn_RepriseBonLivraisonLClick(Sender: TObject);
    procedure Btn_RepriseBonLivraisonHistoClick(Sender: TObject);
    procedure Btn_CRepriseBonLivraisonHistoClick(Sender: TObject);
    procedure Btn_CRepriseBonLivraisonLClick(Sender: TObject);
    procedure Btn_CRepriseBonLivraisonClick(Sender: TObject);
    procedure Btn_CheminBonRapprochementClick(Sender: TObject);
    procedure Btn_BonRapprochementCsvClick(Sender: TObject);
    procedure Btn_CBonRapprochementCsvClick(Sender: TObject);
    procedure Btn_BonRapprochementLienCsvClick(Sender: TObject);
    procedure Btn_CBonRapprochementLienCsvClick(Sender: TObject);
    procedure Btn_BonRapprochementTVACsvClick(Sender: TObject);
    procedure Btn_CBonRapprochementTVACsvClick(Sender: TObject);
    procedure Btn_BonRapprochementLigneReceptionCsvClick(Sender: TObject);
    procedure Btn_CBonRapprochementLigneReceptionCsvClick(Sender: TObject);
    procedure Btn_BonRapprochementLigneRetourCsvClick(Sender: TObject);
    procedure Btn_CBonRapprochementLigneRetourCsvClick(Sender: TObject);
    procedure chk_ChargementBonsRapprochementClick(Sender: TObject);

    procedure Btn_CheminAtelierClick(Sender: TObject);
    procedure Btn_SavTauxHCsvClick(Sender: TObject);
    procedure Btn_CSavTauxHCsvClick(Sender: TObject);
    procedure Btn_SavForfaitCsvClick(Sender: TObject);
    procedure Btn_CSavForfaitCsvClick(Sender: TObject);
    procedure Btn_SavForfaitLCsvClick(Sender: TObject);
    procedure Btn_CSavForfaitLCsvClick(Sender: TObject);
    procedure Btn_SavPt1CsvClick(Sender: TObject);
    procedure Btn_CSavPt1CsvClick(Sender: TObject);
    procedure Btn_SavPt2CsvClick(Sender: TObject);
    procedure Btn_CSavPt2CsvClick(Sender: TObject);
    procedure Btn_SavTypMatCsvClick(Sender: TObject);
    procedure Btn_CSavTypMatCsvClick(Sender: TObject);
    procedure Btn_SavTypeCsvClick(Sender: TObject);
    procedure Btn_CSavTypeCsvClick(Sender: TObject);
    procedure Btn_SavMatCsvClick(Sender: TObject);
    procedure Btn_CSavMatCsvClick(Sender: TObject);
    procedure Btn_SavCbCsvClick(Sender: TObject);
    procedure Btn_CSavCbCsvClick(Sender: TObject);
    procedure Btn_SavFicheeCsvClick(Sender: TObject);
    procedure Btn_CSavFicheeCsvClick(Sender: TObject);
    procedure Btn_SavFicheLCsvClick(Sender: TObject);
    procedure Btn_CSavFicheLCsvClick(Sender: TObject);
    procedure Btn_SavFicheArtCsvClick(Sender: TObject);
    procedure Btn_CSavFicheArtCsvClick(Sender: TObject);
    procedure chk_ChargementAtelierClick(Sender: TObject);

  private
    obClient      : TClient;
    obRefArticle  : TRefArticle;
    obHistorique  : THistorique;
    obBonRapprochement: TBonRapprochement;
    obAtelier : TAtelier;
    bobClient: boolean;
    bobRefArticle: boolean;
    bobHistorique: boolean;
    bobBonRapprochement: Boolean;
    bobAtelier : Boolean;

    bError :boolean;
    EtatLanceCli: integer;
    EtatLanceArt: integer;
    EtatLanceHisto: integer;
    EtatLanceBonR: Integer;
    EtatLanceAtelier : Integer;
    ListeCodeAdh: TStringList;

    procedure DoRepClient(ADir: string);
    procedure DoRepArticle(ADir: string);
    procedure DoRepHisto(ADir: string);
    procedure DoRepReprise(ADir: string);
    procedure DoRepBonRapprochement(ADir: String);
    procedure DoRepAtelier(ADir: String);

    procedure OnTerminateobClient(Sender: TObject);
    procedure OnTerminateobRefArticle(Sender: TObject);
    procedure OnTerminateobHistorique(Sender: TObject);
    procedure OnTerminateobBonRapprochement(Sender: TObject);
    procedure OnTerminateobAtelier(Sender: TObject);

    procedure Poursuivre;

    procedure SetEtatFonction(aFonction : Integer;aEtat : Boolean);
    function GetPathCsv(aTitle : string):string;
    function GetDirCsv():string;

    function VerifPath(ed_Path : TEdit):Boolean;
    function GetProvenance: TImportProvenance;
    function GetVerrifGenTrigger: Boolean;
    procedure SetProvenance(const Value: TImportProvenance);
    procedure UpdateUI(const Provenance: TImportProvenance);
    property Provenance: TImportProvenance read GetProvenance write SetProvenance;

  public
    Log : TStringList;

    procedure AjouterLog(Texte:String; Err:Boolean = False);
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

uses
  uLog;

procedure TFrm_Main.Poursuivre;
begin
  if (EtatLanceCli<>-1) then
    exit;
  if (EtatLanceArt=0) then
  begin
    EtatLanceArt := 1;
    obRefArticle.Start;
  end;

  if (EtatLanceCli<>-1) or (EtatLanceArt<>-1) then
    exit;
  if (EtatLanceHisto=0) then
  begin
    EtatLanceHisto := 1;
    obHistorique.Start;
  end;

  if(EtatLanceCli <> -1) or (EtatLanceArt <> -1) or (EtatLanceHisto <> -1) then
    Exit;
  if(EtatLanceBonR = 0) then
  begin
    EtatLanceBonR := 1;
    obBonRapprochement.Start;
  end;

  if(EtatLanceCli <> -1) or (EtatLanceArt <> -1) or (EtatLanceHisto <> -1) or (EtatLanceBonR <> -1) then
    Exit;
  if(EtatLanceAtelier = 0) then
  begin
    EtatLanceAtelier := 1;
    obAtelier.Start;
  end;

  if(EtatLanceCli = -1) and (EtatLanceArt = -1) and (EtatLanceHisto = -1) and (EtatLanceBonR = -1) and (EtatLanceAtelier = -1) then
  begin
    Frm_Load.OkFermer := true;
    if not(bError) then
    begin
      Enabled := True;
      Application.ProcessMessages;
      Frm_Load.Hide;
      FreeAndNil(Frm_Load);
      Application.ProcessMessages;
      Application.CreateForm(TFrm_Load, Frm_Load);
      Application.ProcessMessages;
      if Dm_Main.NePasFaireLeStock then
        PostMessage(Handle, WM_CLOSE, 0, 0)
      else
        MessageDlg('Import réalisé avec succès !', mtInformation, [mbok], 0);
    end;
  end;
end;

procedure TFrm_Main.Rgr_NivMailClick(Sender: TObject);
begin
  Dm_Main.SetNivSend(Rgr_NivMail.ItemIndex);
end;

procedure TFrm_Main.OnTerminateobClient(Sender: TObject);
begin
  EtatLanceCli := -1;
  bobClient := false;

  if obClient.bError then
    bError := true;

  if bError then
    exit;

  Poursuivre;
end;

procedure TFrm_Main.OnTerminateobRefArticle(Sender: TObject);
begin
  EtatLanceArt := -1;
  bobRefArticle := false;

  if obRefArticle.bError then
    bError := true;

  if bError then
    exit;

  Poursuivre;
end;

procedure TFrm_Main.OnTerminateobHistorique(Sender: TObject);
begin
  EtatLanceHisto := -1;
  bobHistorique := false;

  if obHistorique.bError then
    bError := true;

  if bError then
    exit;

  Poursuivre;
end;

procedure TFrm_Main.OnTerminateobBonRapprochement(Sender: TObject);
begin
  EtatLanceBonR := -1;
  bobBonRapprochement := False;

  if obBonRapprochement.bError then
    bError := True;

  if bError then
    Exit;

  Poursuivre;
end;

procedure TFrm_Main.OnTerminateobAtelier(Sender: TObject);
begin
  EtatLanceAtelier := -1;
  bobAtelier := False;

  if obAtelier.bError then
    bError := True;

  if bError then
    Exit;

  Poursuivre;
end;

procedure TFrm_Main.Btn_MailClick(Sender: TObject);
begin
  SendEmail(Dm_Main.GetMailLst, '[Test Mail] - Transpo','Test Mail');
end;

procedure TFrm_Main.Btn_ReprisePathClick(Sender: TObject);
var
  sDir : string;
begin
  sDir := GetDirCsv;
  if sDir <> '' then
  begin
    Ed_ReprisePath.Text := sDir;
    DoRepReprise(sDir);
  end;
end;

procedure TFrm_Main.AjouterLog(Texte: String; Err: Boolean);
begin
  try
    if Err then
    begin
      AjouterLog('------------------------------------------------------------------');
      Log.Add(DateTimeToStr(Now) + '  ' + Texte);
      AjouterLog('------------------------------------------------------------------');
      ShowMessage('Erreur lors du traitement. Consulter les logs');
    end
    else
      Log.Add(DateTimeToStr(Now) + '  ' + Texte);

    Log.SaveToFile(Dm_Main.ReperSavID + 'Log_Couleur.log');
  except
  end;
end;

procedure TFrm_Main.AlgolDialogFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if bobClient then
    FreeAndNil(obClient);
  if bobRefArticle then
    FreeAndNil(obRefArticle);
  if bobHistorique then
    FreeAndNil(obHistorique);
  if bobBonRapprochement then
    FreeAndNil(obBonRapprochement);
  if bobAtelier then
    FreeAndNil(obAtelier);
end;

procedure TFrm_Main.AlgolDialogFormCreate(Sender: TObject);
begin
  uLog.Log.App := 'IS_mg10';
  uLog.Log.SendOnClose := True;
  uLog.Log.Deboublonage := True;
  uLog.Log.readIni();
  uLog.Log.saveIni();
  uLog.Log.Open;

  //Initialisation clients
  chk_ChargementClients.Checked := False;
  SetEtatFonction(1,False);

  //Initialisation référence article
  chk_ChargementArticle.Checked := False;
  SetEtatFonction(2,False);

  //Initialisation historique
  chk_ChargementHistoriques.Checked := False;
  SetEtatFonction(3,False);

  // État de lancement des importations
  EtatLanceCli := -1;
  EtatLanceArt := -1;
  EtatLanceHisto := -1;
  EtatLanceBonR := -1;
  EtatLanceAtelier := -1;
  bError := false;

  bobClient := false;
  bobRefArticle := false;
  bobHistorique := false;
  bobBonRapprochement := False;
  bobAtelier := False;

  Caption := Caption +' - Ver ' + GetNumVersionSoft();
  {$IFDEF DEBUG}
  Caption := Caption +' - DEBUG';
  {$ENDIF}

  ListeCodeAdh := TStringList.Create;

  vgPageControlRv1.TabIndex := 0;

  Dm_Main.InitMail;   //Pour l'envoi de mail.

  Log := TStringList.Create;
end;

procedure TFrm_Main.AlgolDialogFormDestroy(Sender: TObject);
begin
  FreeAndNil(ListeCodeAdh);
  FreeAndNil(Log);
end;

procedure TFrm_Main.Btn_BasePathClick(Sender: TObject);
var
  odTemp : TOpenDialog;
  iTmp: integer;
  bAlerte: boolean;
begin
  bAlerte := false;
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    odTemp.Execute;
    if odTemp.FileName <> '' then
      ed_BasePath.Text := odTemp.FileName;
  finally
    odTemp.Free;
  end;

  if ed_BasePath.Text <> '' then
  begin
    if not Dm_Main.OpenIBDatabase(ed_BasePath.Text) then
      ShowMessage('Problème de connexion à la base de données');

    // liste magasin
    Dm_Main.Que_ListeMag.Open;
    Dm_Main.Que_ListeMag.First;
    ListeCodeAdh.Clear;
    cb_Magasin.Clear;
    iTmp := -1;
    cb_Magasin.AddItem('Choisir le magasin', TObject(iTmp));
    ListeCodeAdh.Add('-1');
    while not Dm_Main.Que_ListeMag.Eof do
    begin
      cb_Magasin.AddItem(Dm_Main.Que_ListeMag.FieldByName('MAG_CODEADH').AsString+' - '+
                         Dm_Main.Que_ListeMag.FieldByName('MAG_NOM').AsString,
                  TObject(Dm_Main.Que_ListeMag.FieldByName('MAG_ID').AsInteger));
      ListeCodeAdh.Add(Dm_Main.Que_ListeMag.FieldByName('MAG_CODEADH').AsString);
      if Dm_Main.Que_ListeMag.FieldByName('MAG_CODEADH').AsString='' then
        bAlerte := true;
      Dm_Main.Que_ListeMag.Next;
    end;

    if cb_Magasin.Items.Count>0 then
    begin
      Provenance := ipUnderterminate;
      //cb_Provenance.ItemIndex := 0;
      cb_Magasin.ItemIndex := 0;
      Dm_Main.MagID := Integer(cb_Magasin.Items.Objects[cb_Magasin.ItemIndex]);
      Dm_Main.MagCodeAdh := ListeCodeAdh[cb_Magasin.ItemIndex];
    end;

    Cb_Magasin.Enabled := False;
    Chk_TousMag.Checked := True;

    // Liste groupe de tarif magasin
    Dm_Main.Que_TarVente.Open;
    Dm_Main.Que_TarVente.First;
    cb_TarVente.Clear;
    iTmp := -1;
    cb_TarVente.AddItem('Choisir le groupe de tarif...', TObject(iTmp));
    iTmp := 0;
    cb_TarVente.AddItem('<Aucun>', TObject(iTmp));
    while not Dm_Main.Que_TarVente.Eof do
    begin
      cb_TarVente.AddItem(Dm_Main.Que_TarVente.FieldByName('TVT_NOM').AsString, TObject(Dm_Main.Que_TarVente.FieldByName('TVT_ID').AsInteger));
      Dm_Main.Que_TarVente.Next;
    end;
    cb_TarVente.ItemIndex := 1;
    Cb_TarVente.Enabled := False;
  end;

  if bAlerte then
    MessageDlg('Attention: un des magasins n''a pas de code adhérent !', mtWarning, [mbok], 0);

  Dm_Main.DoDstGrpPump;
end;

procedure TFrm_Main.btn_BonAchatsCsvClick(Sender: TObject);
begin
  ed_BonAchatsCsv.Text := GetPathCsv('Choix du fichier BonAchats.csv');
end;

procedure TFrm_Main.btn_BonLivraisonCsvClick(Sender: TObject);
begin
  ed_BonLivraisonCsv.Text := GetPathCsv('Choix du fichier BonLivraison.csv');
end;

procedure TFrm_Main.btn_BonLivraisonHistoCsvClick(Sender: TObject);
begin
  ed_BonLivraisonHistoCsv.Text := GetPathCsv('Choix du fichier BonLivraisonHisto.csv');
end;

procedure TFrm_Main.btn_BonLivraisonLCsvClick(Sender: TObject);
begin
  ed_BonLivraisonLCsv.Text := GetPathCsv('Choix du fichier BonLivraisonL.csv');
end;

procedure TFrm_Main.btn_CaisseCsvClick(Sender: TObject);
begin
  ed_CaisseCsv.Text := GetPathCsv('Choix du fichier Caisse.csv');
end;

procedure TFrm_Main.btn_CArticleAxeCsvClick(Sender: TObject);
begin
  CreerFile(ed_ArticleAxeCsv.Text);
  VerifPath(ed_ArticleAxeCsv);
end;

procedure TFrm_Main.btn_CArticleCollectionCsvClick(Sender: TObject);
begin
  CreerFile(ed_ArticleCollectionCsv.Text);
  VerifPath(ed_ArticleCollectionCsv);
end;

procedure TFrm_Main.btn_CArticleCsvClick(Sender: TObject);
begin
  CreerFile(ed_ArticleCsv.Text);
  VerifPath(ed_ArticleCsv);
end;

procedure TFrm_Main.btn_CArtidealCsvClick(Sender: TObject);
begin
  CreerFile(ed_ArtidealCsv.Text);
  VerifPath(ed_ArtidealCsv);
end;

procedure TFrm_Main.btn_CAvoirCsvClick(Sender: TObject);
begin
  CreerFile(ed_AvoirCsv.Text);
  VerifPath(ed_AvoirCsv);
end;

procedure TFrm_Main.btn_CAxeCsvClick(Sender: TObject);
begin
  CreerFile(ed_AxeCsv.Text);
  VerifPath(ed_AxeCsv);
end;

procedure TFrm_Main.btn_CAxeNiveau1CsvClick(Sender: TObject);
begin
  CreerFile(ed_AxeNiveau1Csv.Text);
  VerifPath(ed_AxeNiveau1Csv);
end;

procedure TFrm_Main.btn_CAxeNiveau2CsvClick(Sender: TObject);
begin
  CreerFile(ed_AxeNiveau2Csv.Text);
  VerifPath(ed_AxeNiveau2Csv);
end;

procedure TFrm_Main.btn_CAxeNiveau3CsvClick(Sender: TObject);
begin
  CreerFile(ed_AxeNiveau3Csv.Text);
  VerifPath(ed_AxeNiveau3Csv);
end;

procedure TFrm_Main.btn_CAxeNiveau4CsvClick(Sender: TObject);
begin
  CreerFile(ed_AxeNiveau4Csv.Text);
  VerifPath(ed_AxeNiveau4Csv);
end;

procedure TFrm_Main.btn_CBonAchatsCsvClick(Sender: TObject);
begin
  CreerFile(ed_BonAchatsCsv.Text);
  VerifPath(ed_BonAchatsCsv);
end;

procedure TFrm_Main.btn_CBonLivraisonCsvClick(Sender: TObject);
begin
  CreerFile(ed_BonLivraisonCsv.Text);
  VerifPath(ed_BonLivraisonCsv);
end;

procedure TFrm_Main.btn_CBonLivraisonHistoCsvClick(Sender: TObject);
begin
  CreerFile(ed_BonLivraisonHistoCsv.Text);
  VerifPath(ed_BonLivraisonHistoCsv);
end;

procedure TFrm_Main.btn_CBonLivraisonLCsvClick(Sender: TObject);
begin
  CreerFile(ed_BonLivraisonLCsv.Text);
  VerifPath(ed_BonLivraisonLCsv);
end;

procedure TFrm_Main.btn_CCaisseCsvClick(Sender: TObject);
begin
  CreerFile(ed_CaisseCsv.Text);
  VerifPath(ed_CaisseCsv);
end;

procedure TFrm_Main.btn_CClientsCsvClic(Sender: TObject);
begin
  CreerFile(ed_ClientsCsv.Text);
  VerifPath(ed_ClientsCsv);
end;

procedure TFrm_Main.btn_CCodeBarreCsvClick(Sender: TObject);
begin
  CreerFile(ed_CodeBarreCsv.Text);
  CreerFile(ExtractFilePath(ed_CodeBarreCsv.Text) + 'All_CB.csv');
  VerifPath(ed_CodeBarreCsv);
end;

procedure TFrm_Main.btn_CCollectionCsvClick(Sender: TObject);
begin
  CreerFile(ed_CollectionCsv.Text);
  VerifPath(ed_CollectionCsv);
end;

procedure TFrm_Main.btn_CCommandesCsvClick(Sender: TObject);
begin
  CreerFile(ed_CommandesCsv.Text);
  VerifPath(ed_CommandesCsv);
end;

procedure TFrm_Main.btn_CComptesCsvClick(Sender: TObject);
begin
  CreerFile(ed_ComptesCsv.Text);
  VerifPath(ed_ComptesCsv);
end;

procedure TFrm_Main.btn_CConsodivCsvClick(Sender: TObject);
begin
  CreerFile(ed_ConsodivCsv.Text);
  VerifPath(ed_ConsodivCsv);
end;

procedure TFrm_Main.btn_CCouleurCsvClick(Sender: TObject);
begin
  CreerFile(ed_CouleurCsv.Text);
  VerifPath(ed_CouleurCsv);
end;

procedure TFrm_Main.btn_CDomaineCommercialCsvClick(Sender: TObject);
begin
  CreerFile(ed_DomaineCommercialCsv.Text);
  VerifPath(ed_DomaineCommercialCsv);
end;

procedure TFrm_Main.btn_CFideliteCsvClick(Sender: TObject);
begin
  CreerFile(ed_FideliteCsv.Text);
  VerifPath(ed_FideliteCsv);
end;

procedure TFrm_Main.btn_CFouConditionCsvClick(Sender: TObject);
begin
  CreerFile(ed_FouConditionCsv.Text);
  VerifPath(ed_FouConditionCsv);
end;

procedure TFrm_Main.btn_CFouContactCsvClick(Sender: TObject);
begin
  CreerFile(ed_FouContactCsv.Text);
  VerifPath(ed_FouContactCsv);
end;

procedure TFrm_Main.btn_CFoumarqueCsvClick(Sender: TObject);
begin
  CreerFile(ed_FoumarqueCsv.Text);
  VerifPath(ed_FoumarqueCsv);
end;

procedure TFrm_Main.btn_CFournCsvClick(Sender: TObject);
begin
  CreerFile(ed_FournCsv.Text);
  VerifPath(ed_FournCsv);
end;

procedure TFrm_Main.Btn_CGenreCsvClick(Sender: TObject);
begin
  CreerFile(ed_GenreCsv.Text);
  VerifPath(ed_GenreCsv);
end;

procedure TFrm_Main.btn_CGrTailleCsvClick(Sender: TObject);
begin
  CreerFile(ed_GrTailleCsv.Text);
  VerifPath(ed_GrTailleCsv);
end;

procedure TFrm_Main.btn_CGrTailleLigCsvClick(Sender: TObject);
begin
  CreerFile(ed_GrTailleLigCsv.Text);
  VerifPath(ed_GrTailleLigCsv);
end;

procedure TFrm_Main.btn_CLienClientCsvClick(Sender: TObject);
begin
  CreerFile(ed_LienClientsCsv.Text);
  VerifPath(ed_LienClientsCsv);
end;

procedure TFrm_Main.btn_ClientsCsvClick(Sender: TObject);
begin
  ed_ClientsCsv.Text := GetPathCsv('Choix du fichier Client.csv');
end;

procedure TFrm_Main.btn_CodeBarreCsvClick(Sender: TObject);
begin
  ed_CodeBarreCsv.Text := GetPathCsv('Choix du fichier Code_Barre.csv');
end;

procedure TFrm_Main.btn_CollectionCsvClick(Sender: TObject);
begin
   ed_CollectionCsv.Text := GetPathCsv('Choix du fichier Collection.csv');
end;

procedure TFrm_Main.btn_CommandesCsvClick(Sender: TObject);
begin
  ed_CommandesCsv.Text := GetPathCsv('Choix du fichier Commandes.csv');
end;

procedure TFrm_Main.btn_ComptesCsvClick(Sender: TObject);
begin
  ed_ComptesCsv.Text := GetPathCsv('Choix du fichier Comptes.csv');
end;

procedure TFrm_Main.btn_ConsodivCsvClick(Sender: TObject);
begin
  ed_ConsodivCsv.Text := GetPathCsv('Choix du fichier Consodiv.csv');
end;

procedure TFrm_Main.btn_Correct_AvoirClick(Sender: TObject);
var
  msg       : string;
  bContinue : Boolean;
//  iNumFile  : Integer;
//  tmpEdit   : TEdit;
//  LstParam  : TStringList;

  function AjoutEntete(ed_path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  var
    ij: integer;
    TmpListe: TStringList;
    sPremier: string;
    sLigne: string;
    bFaire: boolean;
  begin
    Result := false;

    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''éxiste pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
      exit;
    end;

    TmpListe := TStringList.Create;
    try
      bFaire := false;
      TmpListe.LoadFromFile(ed_Path.Text);
      sPremier := '';
      if TmpListe.Count>0 then
        sPremier := TmpListe[0];

      if Pos(';', sPremier)>0 then
        sPremier := Copy(sPremier, 1, pos(';', sPremier)-1);

      sPremier := UpperCase(sPremier);
      if High(tab_Col)>0 then
      begin
        if UpperCase(sPremier)<>UpperCase(tab_Col[0]) then
          bFaire := true;
      end;

      if bFaire then
      begin
        sLigne := '';
        for ij := 0 to High(tab_col) do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          sLigne := sLigne+tab_col[ij];
        end;
        if ARetirePtVirg then
          sLigne := sLigne+';';

        if TmpListe.Count>0 then
          TmpListe.Insert(0, sLigne)
        else
          TmpListe.Add(sLigne);

        TmpListe.SaveToFile(ed_Path.Text);
      end;
      Result := true;
    finally
      FreeAndNil(TmpListe);
    end;

  end;

  function Verification(ed_Path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  begin
    Result := False;
    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''éxiste pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
    end
    else
      if not VerifFormatFile(ed_Path.Text, tab_Col, ARetirePtVirg) then
      begin
        msg := 'Le format du fichier "' + nom_File + '" ne correspond pas. Merci de vous reporter à la documentation';
        MessageDlg(msg,mtError, mbOKCancel, 0);
      end
      else
        if not VerifFile(ed_Path.Text, tab_Col) then
        begin
          msg := 'Le fichier "' + nom_File + '" contient des caractères non autorisé. Merci de vous reporter à la documentation';
          MessageDlg(msg,mtError, mbOKCancel, 0);
        end
        else
          Result := True;
  end;
begin
  if not(Dm_Main.Database.Connected) then
  begin
    MessageDlg('Base de données non connecté !', mterror, [Mbok], 0);
    exit;
  end;

  if not(GetVerrifGenTrigger) then
  begin
    MessageDlg('La table GenTriggerDiff contient encore des données !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Provenance.ItemIndex<=0) then
  begin
    MessageDlg('Merci de choisir la provenance de l''import !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Magasin.ItemIndex<=0) and not(Chk_TousMag.Checked) then
  begin
    MessageDlg('Merci de choisir un magasin !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_TarVente.ItemIndex<=0) then
  begin
    MessageDlg('Merci la bascule Groupe de tarif magasin déjà migré !', mterror, [Mbok], 0);
    exit;
  end;

  if (Trim(Ed_Dossier.Text)='') then
  begin
    MessageDlg('Merci de définir un dossier !', mterror, [Mbok], 0);
    exit;
  end;

  if not(chk_ChargementClients.Checked)
       and not(chk_ChargementArticle.Checked)
       and not(chk_ChargementHistoriques.Checked) then
    exit;

  //Mail
  Dm_Main.SetSubjectMail(Ed_Dossier.Text);

  //Vérification des fichiers Clients
  if chk_ChargementClients.Checked then
  begin
    // insertion des Entetes si pas fait
    bContinue := true;
    if Chk_InsererEnteteCli.Checked then
    begin
      if not AjoutEntete(ed_ClientsCsv, Clients_COL, Clients_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
      if not AjoutEntete(ed_ComptesCsv, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
      if not AjoutEntete(ed_FideliteCsv, Fidelite_COL, Fidelite_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
      if not AjoutEntete(ed_BonAchatsCsv, BonAchats_COL, BonAchats_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
    end;
    if not(bContinue) then
      exit;

    // vérification des entête
    if not Verification(ed_ClientsCsv, Clients_COL, Clients_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
    if not Verification(ed_ComptesCsv, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
    if not Verification(ed_FideliteCsv, Fidelite_COL, Fidelite_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
    if not Verification(ed_BonAchatsCsv, BonAchats_COL, BonAchats_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
  end;

  Dm_Main.ReperSavID := Dm_Main.ReperBase+'Import\'+Trim(Ed_Dossier.Text)+'\';

  SysUtils.ForceDirectories(Dm_Main.ReperSavID);

  EtatLanceCli := -1;
  EtatLanceArt := -1;
  EtatLanceHisto := -1;
  EtatLanceBonR := -1;
  EtatLanceAtelier := -1;
  bError := false;

  if chk_ChargementClients.Checked then
    EtatLanceCli := 0;  // en attente

  if chk_ChargementClients.Checked then
  begin
    bobClient := true;
    obClient := TClient.Create(True, chk_ChargementClients.Checked, False, 1);
    obClient.OnTerminate := OnTerminateobClient;
    obClient.InitThread(Chk_RetirePtVirgCli.Checked, ed_ClientsCsv.Text,
      ed_ComptesCsv.Text, ed_FideliteCsv.Text, ed_BonAchatsCsv.Text, ed_LienClientsCsv.Text);
  end;

  Frm_Load.DoInit(EtatLanceCli, EtatLanceArt, EtatLanceHisto, EtatLanceBonR, EtatLanceAtelier);
  Frm_Load.Show;
  Frm_Load.OkFermer := false;
  Frm_Main.Enabled := False;
  Application.ProcessMessages;

  if chk_ChargementClients.Checked then
  begin
    EtatLanceCli := 1;   // en cours
    obClient.Start;
  end;
end;

procedure TFrm_Main.btn_Correct_LienClick(Sender: TObject);
var
  msg       : string;
  bContinue : Boolean;
//  iNumFile  : Integer;
//  tmpEdit   : TEdit;
//  LstParam  : TStringList;

  function AjoutEntete(ed_path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  var
    ij: integer;
    TmpListe: TStringList;
    sPremier: string;
    sLigne: string;
    bFaire: boolean;
  begin
    Result := false;

    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''éxiste pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
      exit;
    end;

    TmpListe := TStringList.Create;
    try
      bFaire := false;
      TmpListe.LoadFromFile(ed_Path.Text);
      sPremier := '';
      if TmpListe.Count>0 then
        sPremier := TmpListe[0];

      if Pos(';', sPremier)>0 then
        sPremier := Copy(sPremier, 1, pos(';', sPremier)-1);

      sPremier := UpperCase(sPremier);
      if High(tab_Col)>0 then
      begin
        if UpperCase(sPremier)<>UpperCase(tab_Col[0]) then
          bFaire := true;
      end;

      if bFaire then
      begin
        sLigne := '';
        for ij := 0 to High(tab_col) do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          sLigne := sLigne+tab_col[ij];
        end;
        if ARetirePtVirg then
          sLigne := sLigne+';';

        if TmpListe.Count>0 then
          TmpListe.Insert(0, sLigne)
        else
          TmpListe.Add(sLigne);

        TmpListe.SaveToFile(ed_Path.Text);
      end;
      Result := true;
    finally
      FreeAndNil(TmpListe);
    end;

  end;

  function Verification(ed_Path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  begin
    Result := False;
    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''éxiste pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
    end
    else
      if not VerifFormatFile(ed_Path.Text, tab_Col, ARetirePtVirg) then
      begin
        msg := 'Le format du fichier "' + nom_File + '" ne correspond pas. Merci de vous reporter à la documentation';
        MessageDlg(msg,mtError, mbOKCancel, 0);
      end
      else
        if not VerifFile(ed_Path.Text, tab_Col) then
        begin
          msg := 'Le fichier "' + nom_File + '" contient des caractères non autorisé. Merci de vous reporter à la documentation';
          MessageDlg(msg,mtError, mbOKCancel, 0);
        end
        else
          Result := True;
  end;
begin
  if not(Dm_Main.Database.Connected) then
  begin
    MessageDlg('Base de données non connecté !', mterror, [Mbok], 0);
    exit;
  end;

  if not(GetVerrifGenTrigger) then
  begin
    MessageDlg('La table GenTriggerDiff contient encore des données !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Provenance.ItemIndex<=0) then
  begin
    MessageDlg('Merci de choisir la provenance de l''import !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Magasin.ItemIndex<=0) and not(Chk_TousMag.Checked) then
  begin
    MessageDlg('Merci de choisir un magasin !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_TarVente.ItemIndex<=0) then
  begin
    MessageDlg('Merci la bascule Groupe de tarif magasin déjà migré !', mterror, [Mbok], 0);
    exit;
  end;

  if (Trim(Ed_Dossier.Text)='') then
  begin
    MessageDlg('Merci de définir un dossier !', mterror, [Mbok], 0);
    exit;
  end;

  if not(chk_ChargementClients.Checked)
       and not(chk_ChargementArticle.Checked)
       and not(chk_ChargementHistoriques.Checked) then
    exit;

  //Mail
  Dm_Main.SetSubjectMail(Ed_Dossier.Text);

  //Vérification des fichiers Clients
  if chk_ChargementClients.Checked then
  begin
    // insertion des Entetes si pas fait
    bContinue := true;
    if Chk_InsererEnteteCli.Checked then
    begin
      if not AjoutEntete(ed_ClientsCsv, Clients_COL, Clients_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
      if not AjoutEntete(ed_ComptesCsv, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
      if not AjoutEntete(ed_FideliteCsv, Fidelite_COL, Fidelite_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
      if not AjoutEntete(ed_BonAchatsCsv, BonAchats_COL, BonAchats_CSV, Chk_RetirePtVirgCli.Checked) then
        bContinue := false;
    end;
    if not(bContinue) then
      exit;

    // vérification des entête
    if not Verification(ed_ClientsCsv, Clients_COL, Clients_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
    if not Verification(ed_ComptesCsv, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
    if not Verification(ed_FideliteCsv, Fidelite_COL, Fidelite_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
    if not Verification(ed_BonAchatsCsv, BonAchats_COL, BonAchats_CSV, Chk_RetirePtVirgCli.Checked) then
      Exit;
  end;

  Dm_Main.ReperSavID := Dm_Main.ReperBase+'Import\'+Trim(Ed_Dossier.Text)+'\';

  SysUtils.ForceDirectories(Dm_Main.ReperSavID);

  EtatLanceCli := -1;
  EtatLanceArt := -1;
  EtatLanceHisto := -1;
  EtatLanceBonR := -1;
  EtatLanceAtelier := -1;
  bError := false;

  if chk_ChargementClients.Checked then
    EtatLanceCli := 0;  // en attente

  if chk_ChargementClients.Checked then
  begin
    bobClient := true;
    obClient := TClient.Create(True, chk_ChargementClients.Checked, False, 2);
    obClient.OnTerminate := OnTerminateobClient;
    obClient.InitThread(Chk_RetirePtVirgCli.Checked, ed_ClientsCsv.Text,
      ed_ComptesCsv.Text, ed_FideliteCsv.Text, ed_BonAchatsCsv.Text, ed_LienClientsCsv.Text);
  end;

  Frm_Load.DoInit(EtatLanceCli, EtatLanceArt, EtatLanceHisto, EtatLanceBonR, EtatLanceAtelier);
  Frm_Load.Show;
  Frm_Load.OkFermer := false;
  Frm_Main.Enabled := False;
  Application.ProcessMessages;

  if chk_ChargementClients.Checked then
  begin
    EtatLanceCli := 1;   // en cours
    obClient.Start;
  end;
end;

procedure TFrm_Main.btn_CouleurCsvClick(Sender: TObject);
begin
  ed_CouleurCsv.Text := GetPathCsv('Choix du fichier Couleur.csv');
end;

procedure TFrm_Main.btn_CPrixAchatCsvClick(Sender: TObject);
begin
  CreerFile(ed_PrixAchatCsv.Text);
  VerifPath(ed_PrixAchatCsv);
end;

procedure TFrm_Main.btn_CPrixVenteCsvClick(Sender: TObject);
begin
  CreerFile(ed_PrixVenteCsv.Text);
  VerifPath(ed_PrixVenteCsv);
end;

procedure TFrm_Main.Btn_CPrixVenteIndicatifCsvClick(Sender: TObject);
begin
  CreerFile(Ed_PrixVenteIndicatifCsv.Text);
  VerifPath(Ed_PrixVenteIndicatifCsv);
end;

procedure TFrm_Main.btn_CReceptionCsvClick(Sender: TObject);
begin
  CreerFile(ed_ReceptionCsv.Text);
  VerifPath(ed_ReceptionCsv);
end;

procedure TFrm_Main.Btn_CRepriseAvoirClick(Sender: TObject);
begin
  CreerFile(ed_RepriseAvoir.Text);
  VerifPath(ed_RepriseAvoir);
end;

procedure TFrm_Main.Btn_CRepriseBonLivraisonClick(Sender: TObject);
begin
  CreerFile(ed_RepriseBonLivraison.Text);
  VerifPath(ed_RepriseBonLivraison);
end;

procedure TFrm_Main.Btn_CRepriseBonLivraisonHistoClick(Sender: TObject);
begin
  CreerFile(ed_RepriseBonLivraisonHisto.Text);
  VerifPath(ed_RepriseBonLivraisonHisto);
end;

procedure TFrm_Main.Btn_CRepriseBonLivraisonLClick(Sender: TObject);
begin
  CreerFile(ed_RepriseBonLivraisonL.Text);
  VerifPath(ed_RepriseBonLivraisonL);
end;

procedure TFrm_Main.Btn_CRepriseCaisseClick(Sender: TObject);
begin
  CreerFile(ed_RepriseCaisse.Text);
  VerifPath(ed_RepriseCaisse);
end;

procedure TFrm_Main.Btn_CRepriseClientClick(Sender: TObject);
begin
  CreerFile(ed_RepriseClient.Text);
  VerifPath(ed_RepriseClient);
end;

procedure TFrm_Main.Btn_CRepriseCompteClick(Sender: TObject);
begin
  CreerFile(ed_RepriseCompte.Text);
  VerifPath(ed_RepriseCompte);
end;

procedure TFrm_Main.btn_CRetourFouCsvClick(Sender: TObject);
begin
  CreerFile(ed_RetourFouCsv.Text);
  VerifPath(ed_RetourFouCsv);
end;

procedure TFrm_Main.btn_CTransfertCsvClick(Sender: TObject);
begin
  CreerFile(ed_TransfertCsv.Text);
  VerifPath(ed_TransfertCsv);
end;

procedure TFrm_Main.btn_DomaineCommercialCsvClick(Sender: TObject);
begin
  ed_DomaineCommercialCsv.Text := GetPathCsv('Choix du fichier Domaine_Commercial.csv');
end;

procedure TFrm_Main.btn_FideliteCsvClick(Sender: TObject);
begin
  ed_FideliteCsv.Text := GetPathCsv('Choix du fichier Fidelite.csv');
end;

procedure TFrm_Main.btn_FouConditionCsvClick(Sender: TObject);
begin
  ed_FouConditionCsv.Text := GetPathCsv('Choix du fichier FouCondition.csv');
end;

procedure TFrm_Main.btn_FouContactCsvClick(Sender: TObject);
begin
  ed_FouContactCsv.Text := GetPathCsv('Choix du fichier FouContact.csv');
end;

procedure TFrm_Main.btn_FoumarqueCsvClick(Sender: TObject);
begin
  ed_FoumarqueCsv.Text := GetPathCsv('Choix du fichier Foumarque.csv');
end;

procedure TFrm_Main.btn_FournCsvClick(Sender: TObject);
begin
  ed_FournCsv.Text := GetPathCsv('Choix du fichier Fourn.csv');
end;

procedure TFrm_Main.Btn_GenreCsvClick(Sender: TObject);
begin
  ed_GenreCsv.Text := GetPathCsv('Choix du fichier Article_TrailleTrav.csv');
end;

procedure TFrm_Main.btn_GrTailleCsvClick(Sender: TObject);
begin
  ed_GrTailleCsv.Text := GetPathCsv('Choix du fichier Gr_Taille.csv');
end;

procedure TFrm_Main.btn_GrTailleLigCsvClick(Sender: TObject);
begin
  ed_GrTailleLigCsv.Text := GetPathCsv('Choix du fichier Gr_Taille_Lig.csv');
end;

procedure TFrm_Main.btn_MarqueCsvClick(Sender: TObject);
begin
  ed_MarqueCsv.Text := GetPathCsv('Choix du fichier Marque.csv');
end;

procedure TFrm_Main.btn_ModeleDeprecieCsvClick(Sender: TObject);
begin
  ed_ModeleDeprecieCsv.Text := GetPathCsv('Choix du fichier ModeleDeprecie.csv');
end;

procedure TFrm_Main.btn_OcDetailCsvClick(Sender: TObject);
begin
  ed_OcDetailCsv.Text := GetPathCsv('Choix du fichier OcDetail.csv');
end;

procedure TFrm_Main.btn_OcLignesCsvClick(Sender: TObject);
begin
  ed_OcLignesCsv.Text := GetPathCsv('Choix du fichier OcLignes.csv');
end;

procedure TFrm_Main.btn_OcMagCsvClick(Sender: TObject);
begin
  ed_OcMagCsv.Text := GetPathCsv('Choix du fichier OcMag.csv');
end;

procedure TFrm_Main.btn_OcTeteCsvClick(Sender: TObject);
begin
  ed_OcTeteCsv.Text := GetPathCsv('Choix du fichier OcTete.csv');
end;

procedure TFrm_Main.btn_PrixAchatCsvClick(Sender: TObject);
begin
  ed_PrixAchatCsv.Text := GetPathCsv('Choix du fichier Prix_Achat.csv');
end;

procedure TFrm_Main.btn_PrixVenteCsvClick(Sender: TObject);
begin
  Ed_PrixVenteCsv.Text := GetPathCsv('Choix du fichier Prix_Vente.csv');
end;

procedure TFrm_Main.Btn_PrixVenteIndicatifCsvClick(Sender: TObject);
begin
  Ed_PrixVenteIndicatifCsv.Text := GetPathCsv('Choix du fichier Prix_Vente_Indicatif.csv');
end;

procedure TFrm_Main.btn_AxeCsvClick(Sender: TObject);
begin
  ed_AxeCsv.Text := GetPathCsv('Choix du fichier Axe.csv');
end;

procedure TFrm_Main.btn_AxeNiveau1CsvClick(Sender: TObject);
begin
  ed_AxeNiveau1Csv.Text := GetPathCsv('Choix du fichier Axe_Niveau1.csv');
end;

procedure TFrm_Main.btn_AxeNiveau2CsvClick(Sender: TObject);
begin
  ed_AxeNiveau2Csv.Text := GetPathCsv('Choix du fichier Axe_Niveau2.csv');
end;

procedure TFrm_Main.btn_AxeNiveau3CsvClick(Sender: TObject);
begin
  ed_AxeNiveau3Csv.Text := GetPathCsv('Choix du fichier Axe_Niveau3.csv');
end;

procedure TFrm_Main.btn_AxeNiveau4CsvClick(Sender: TObject);
begin
  ed_AxeNiveau4Csv.Text := GetPathCsv('Choix du fichier Axe_Niveau4.csv');
end;

procedure TFrm_Main.btn_ArticleAxeCsvClick(Sender: TObject);
begin
  ed_ArticleAxeCsv.Text := GetPathCsv('Choix du fichier Article_Axe.csv');
end;

procedure TFrm_Main.btn_ArticleCollectionCsvClick(Sender: TObject);
begin
  ed_ArticleCollectionCsv.Text := GetPathCsv('Choix du fichier Article_Collection.csv');
end;

procedure TFrm_Main.btn_ArticleCsvClick(Sender: TObject);
begin
  ed_ArticleCsv.Text := GetPathCsv('Choix du fichier Article.csv');
end;

procedure TFrm_Main.btn_ReceptionCsvClick(Sender: TObject);
begin
  ed_ReceptionCsv.Text := GetPathCsv('Choix du fichier Reception.csv');
end;

procedure TFrm_Main.Btn_RepriseAvoirClick(Sender: TObject);
begin
  ed_RepriseAvoir.Text := GetPathCsv('Choix du fichier Reprise_Avoir.csv');
end;

procedure TFrm_Main.Btn_RepriseBonLivraisonClick(Sender: TObject);
begin
  ed_RepriseBonLivraison.Text := GetPathCsv('Choix du fichier Reprise_BonLivraison.csv');
end;

procedure TFrm_Main.Btn_RepriseBonLivraisonHistoClick(Sender: TObject);
begin
  ed_RepriseBonLivraisonHisto.Text := GetPathCsv('Choix du fichier Reprise_BonLivraisonHisto.csv');
end;

procedure TFrm_Main.Btn_RepriseBonLivraisonLClick(Sender: TObject);
begin
  ed_RepriseBonLivraisonL.Text := GetPathCsv('Choix du fichier Reprise_BonLivraisonL.csv');
end;

procedure TFrm_Main.Btn_RepriseCaisseClick(Sender: TObject);
begin
  ed_RepriseCaisse.Text := GetPathCsv('Choix du fichier Reprise_Caisse.csv');
end;

procedure TFrm_Main.Btn_RepriseClientClick(Sender: TObject);
begin
  ed_RepriseClient.Text := GetPathCsv('Choix du fichier Reprise_Client.csv');
end;

procedure TFrm_Main.Btn_RepriseCompteClick(Sender: TObject);
begin
  ed_RepriseCompte.Text := GetPathCsv('Choix du fichier Reprise_Compte.csv');
end;

procedure TFrm_Main.btn_RetourFouCsvClick(Sender: TObject);
begin
  ed_RetourFouCsv.Text := GetPathCsv('Choix du fichier RetourFou.csv');
end;

procedure TFrm_Main.btn_TransfertCsvClick(Sender: TObject);
begin
  ed_TransfertCsv.Text := GetPathCsv('Choix du fichier Transfert.csv');
end;

procedure TFrm_Main.Bt_ChronoClick(Sender: TObject);
var
  sFile: string;
  odTemp: TOpenDialog;
  TpListe: TStringList;
  LigneLecture: string;
  i: integer;
  iNumTable: integer;
  iNumBase: integer;
  iNumGene: integer;
  StProc_finalise_Chrono: TIBSQL;

  function AjoutEntete(AFile: string; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  var
    ij: integer;
    TmpListe: TStringList;
    sPremier: string;
    sLigne: string;
    bFaire: boolean;
  begin
    Result := false;

    TmpListe := TStringList.Create;
    try
      bFaire := false;
      TmpListe.LoadFromFile(AFile);
      sPremier := '';
      if TmpListe.Count>0 then
        sPremier := TmpListe[0];

      if Pos(';', sPremier)>0 then
        sPremier := Copy(sPremier, 1, pos(';', sPremier)-1);

      sPremier := UpperCase(sPremier);
      if High(tab_Col)>0 then
      begin
        if UpperCase(sPremier)<>UpperCase(tab_Col[0]) then
          bFaire := true;
      end;

      if bFaire then
      begin
        sLigne := '';
        for ij := 0 to High(tab_col) do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          sLigne := sLigne+tab_col[ij];
        end;
        if ARetirePtVirg then
          sLigne := sLigne+';';

        if TmpListe.Count>0 then
          TmpListe.Insert(0, sLigne)
        else
          TmpListe.Add(sLigne);

        TmpListe.SaveToFile(AFile);
      end;
      Result := true;
    finally
      FreeAndNil(TmpListe);
    end;
  end;

  function Verification(AFile: string; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  var
    msg: string;
  begin
    Result := False;
    if not VerifFormatFile(AFile, tab_Col, ARetirePtVirg) then
    begin
      msg := 'Le format du fichier "' + nom_File + '" ne correspond pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
    end
    else
      Result := True;
  end;

  function GetValueLstChrono(AChamp: string): string;
  begin
    Result := GetValueImp(AChamp, ListeChrono_COL, LigneLecture, Chk_RetirePtVirgReprise.Checked);
  end;

begin
  if not(Dm_Main.Database.Connected) then
  begin
    MessageDlg('Base de données non connecté !', mterror, [Mbok], 0);
    exit;
  end;

  sFile := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier texte|*.csv;*.txt|Tous|*.*';
    odTemp.Title := 'Finalisation Chrono';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    odTemp.FileName := 'ListeChrono.csv';
    if odTemp.Execute then
    begin
      Application.ProcessMessages;
      sFile := odTemp.FileName;
    end;
  finally
    FreeAndNil(odTemp);
  end;
  if (sFile='') or not(FileExists(sFile)) then
    exit;

  // insertion des Entetes si pas fait
  if Chk_InsererEnteteReprise.Checked then
  begin
    if not AjoutEntete(sFile, ListeChrono_COL, ListeChrono_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
  end;

  // vérification des entête
  if not Verification(sFile, ListeChrono_COL, ListeChrono_CSV, Chk_RetirePtVirgReprise.Checked) then
    Exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  TPListe := TStringList.Create;
  StProc_finalise_Chrono := TIBSQL.Create(nil);
  try
    Dm_Main.TransacHis.Active := false;
    Dm_Main.TransacHis.Active := true;
    with StProc_finalise_Chrono do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacHis;
      ParamCheck := True;
      SQL.Add('execute procedure MG10_FINALISE_CHRONO(:NUMTABLE,');
      SQL.Add('                                       :NUMBASE,');
      SQL.Add('                                       :NUMGENE)');
      Prepare;
    end;

    TPListe.LoadFromFile(sFile);
    for i := 2 to TPListe.Count do
    begin
      LigneLecture := TPListe[i-1];
      iNumTable := StrToIntDef(GetValueLstChrono('NUMTABLE'), 0);
      iNumBase := StrToIntDef(GetValueLstChrono('NUMBASE'), 0);
      iNumGene := StrToIntDef(GetValueLstChrono('NUMGENE'), 0);
      if not(Dm_Main.TransacHis.InTransaction) then
        Dm_Main.TransacHis.StartTransaction;
      try
        StProc_finalise_Chrono.Close;
        StProc_finalise_Chrono.ParamByName('NUMTABLE').AsInteger := iNumTable;
        StProc_finalise_Chrono.ParamByName('NUMBASE').AsInteger := iNumBase;
        StProc_finalise_Chrono.ParamByName('NUMGENE').AsInteger := iNumGene;
        StProc_finalise_Chrono.ExecQuery;
        StProc_finalise_Chrono.Close;
        Dm_Main.TransacHis.Commit;
      except
        on E:Exception do
        begin
          if (Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.Rollback;
          raise;
        end;
      end;

    end;


    MessageDlg('Terminé avec succès !', mtinformation, [mbok], 0);
  finally
    StProc_finalise_Chrono.Close;
    FreeAndNil(StProc_finalise_Chrono);
    FreeAndNil(TpListe);
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

end;

procedure TFrm_Main.Btn_PtVirgClick(Sender: TObject);
const
  MaxChargement = 4096;
var
  sFile: string;
  Donnees	  : TStringList;
  LstTmp    : TStringList;
  StreamMem : TMemoryStream;  // chargement en partie du fichier en memoire pour avoir l'entete
  StreamFil : TFileStream;    // fichier pour lecture
  Count     : Integer;
  bOk: boolean;
  i: integer;
  sLigne : string;
begin
  if OD_OpenFic.Execute then
  begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    Donnees := TStringList.Create;
    LstTmp := TStringList.Create;
    try
      bOk := true;
      // test sur une partie du fichier pour savoir s'il n'y a pas déjà des ;
      sFile := OD_OpenFic.FileName;
      StreamFil := TFileStream.Create(sFile, fmOpenRead);
      StreamMem := TMemoryStream.Create;
      try
        // on charge une partie seulement
        // c'est juste pour avoir l'entete, 4096 octet suffisent bien
        if StreamFil.Size<MaxChargement then
          Count := Integer(StreamFil.Size)
        else
          Count := MaxChargement;

        StreamFil.Seek(0, soFromBeginning);
        StreamMem.CopyFrom(StreamFil, Count);
        StreamMem.Seek(0, soFromBeginning);
        Donnees.LoadFromStream(StreamMem);
        if Donnees.Count>0 then
          Donnees.Delete(Donnees.Count-1);

        // test s'il y a déjà des ; partout
        for i := 1 to Donnees.Count do
        begin
          sLigne := Donnees[i-1];
          if (sLigne<>'') and (sLigne[Length(sLigne)]<>';') then
            bOk := false;
        end;
      finally
        FreeAndNil(StreamFil);
        FreeAndNil(StreamMem);
      end;

      // question poursuivre
      if bOk then
      begin
        if MessageDlg('Il semblerait avoir des ; à la fin de chaque ligne. Poursuivre ?',
                         mtConfirmation, [mbyes, mbno], 0, mbno)<>mrYes then
          exit;
      end;

      //transformation
      Donnees.Clear;
      Donnees.LoadFromFile(sFile);
      LstTmp.Clear;
      for i := 1 to Donnees.Count do
      begin
        sLigne := Donnees[i-1]+';';
        LstTmp.Add(sLigne);
      end;
      LstTmp.SaveToFile(sfile);

    finally
      FreeAndNil(LstTmp);
      FreeAndNil(Donnees);
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFrm_Main.Bt_RecalClick(Sender: TObject);
var
  LRet: integer;
  bOkBackup: boolean;
begin
  if not(Dm_Main.Database.Connected) then
  begin
    MessageDlg('Base de données non connecté !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Provenance.ItemIndex<=0) then
  begin
    MessageDlg('Merci de choisir la provenance de l''import !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Magasin.ItemIndex<=0) and not(Chk_TousMag.Checked) then
  begin
    MessageDlg('Merci de choisir un magasin !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_TarVente.ItemIndex<=0) then
  begin
    MessageDlg('Merci la bascule Groupe de tarif magasin déjà migré !', mterror, [Mbok], 0);
    exit;
  end;

  if (Trim(Ed_Dossier.Text)='') then
  begin
    MessageDlg('Merci de définir un dossier !', mterror, [Mbok], 0);
    exit;
  end;

//  if not(Dm_Main.OkDeGinkoia) and ((ed_ReceptionCsv.Text='') or not(FileExists(ed_ReceptionCsv.Text))) then
  if ( Provenance = ipInterSys ) and ( ( Trim( ed_ReceptionCsv.Text ) = '' ) or
    not( FileExists( ed_ReceptionCsv.Text ) ) ) then
  begin
    MessageDlg('Manque le fichier réception pour InterSys !', mterror, [Mbok], 0);
    exit;
  end;

  bOkBackup := false;
  lret := MessageDlg('Voulez-vous faire un backup-restore ?', mtConfirmation, [mbyes, mbno, mbCancel],0, mbno);
  case lret of
    mryes: bOkBackup := true;
    mrno: bOkBackup := false;
    mrCancel: exit;
  end;

  Dm_Main.ReperSavID := Dm_Main.ReperBase+'Import\'+Trim(Ed_Dossier.Text)+'\';
  SysUtils.ForceDirectories(Dm_Main.ReperSavID);

  btn_CReceptionCsvClick( nil );
  btn_CTransfertCsvClick( nil );
  btn_CCommandesCsvClick( nil );
  btn_CRetourFouCsvClick( nil );


  if Provenance <> ipOldGoSport then
    obHistorique := THistorique.Create( True,
                                        chk_ChargementHistoriques.Checked,
                                        True,
                                        False,
                                        Chk_Correction_TVA.Checked)
  else
    obHistorique := THistorique.Create( True,
                                        chk_ChargementHistoriques.Checked,
                                        True,
                                        False,
                                        False);

  obHistorique.bBackupRestore := bOkBackup;
  obHistorique.OnTerminate := OnTerminateobHistorique;
  if not(Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
    obHistorique.InitThread(true, ed_CaisseCsv.Text, ed_ReceptionCsv.Text, ed_ConsodivCsv.Text,
             ed_TransfertCsv.Text, ed_CommandesCsv.Text, ed_RetourFouCsv.Text, ed_AvoirCsv.Text,
             ed_BonLivraisonCsv.Text, ed_BonLivraisonLCsv.Text, ed_BonLivraisonHistoCsv.Text)
  else
    obHistorique.InitThread(true, '', '', '', '', '', '', '', '', '', '');
  EtatLanceHisto := 0;  // en attente
  Frm_Load.DoInit(EtatLanceCli, EtatLanceArt, EtatLanceHisto, EtatLanceBonR, EtatLanceAtelier);
  Frm_Load.Show;
  Frm_Load.OkFermer := False;
  Frm_Main.Enabled := False;
  Application.ProcessMessages;
  EtatLanceHisto := 1;   // en cours
  obHistorique.Start;

end;

procedure TFrm_Main.Bt_RepriseClick(Sender: TObject);
var
  sFileRepriseClient,
  sFileRepriseCompte,
  sFileRepriseCaisse,
  sFileRepriseAvoir,
  sFileRepriseBonLivraison,
  sFileRepriseBonLivraisonL,
  sFileRepriseBonLivraisonHisto : string;
  msg : string;
  LstParam  : TStringList;
  //bContinue: boolean;

  function AjoutEntete(ed_path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  var
    ij: integer;
    TmpListe: TStringList;
    sPremier: string;
    sLigne: string;
    bFaire: boolean;
  begin
    Result := false;

    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''éxiste pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
      exit;
    end;

    TmpListe := TStringList.Create;
    try
      bFaire := false;
      TmpListe.LoadFromFile(ed_Path.Text);
      sPremier := '';
      if TmpListe.Count>0 then
        sPremier := TmpListe[0];

      if Pos(';', sPremier)>0 then
        sPremier := Copy(sPremier, 1, pos(';', sPremier)-1);

      sPremier := UpperCase(sPremier);
      if High(tab_Col)>0 then
      begin
        if UpperCase(sPremier)<>UpperCase(tab_Col[0]) then
          bFaire := true;
      end;

      if bFaire then
      begin
        sLigne := '';
        for ij := 0 to High(tab_col) do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          sLigne := sLigne+tab_col[ij];
        end;
        if ARetirePtVirg then
          sLigne := sLigne+';';

        if TmpListe.Count>0 then
          TmpListe.Insert(0, sLigne)
        else
          TmpListe.Add(sLigne);

        TmpListe.SaveToFile(ed_Path.Text);
      end;
      Result := true;
    finally
      FreeAndNil(TmpListe);
    end;

  end;

  function Verification(ed_Path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  begin
    Result := False;
    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''éxiste pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
    end
    else
      if not VerifFormatFile(ed_Path.Text, tab_Col, ARetirePtVirg) then
      begin
        msg := 'Le format du fichier "' + nom_File + '" ne correspond pas. Merci de vous reporter à la documentation';
        MessageDlg(msg,mtError, mbOKCancel, 0);
      end
      else
        Result := True;
  end;
begin
  if not(Dm_Main.Database.Connected) then
  begin
    MessageDlg('Base de données non connecté !', mterror, [Mbok], 0);
    exit;
  end;

  if not(GetVerrifGenTrigger) then
  begin
    MessageDlg('La table GenTriggerDiff contient encore des données !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Provenance.ItemIndex<=0) then
  begin
    MessageDlg('Merci de choisir la provenance de l''import !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_Magasin.ItemIndex<=0) and not(Chk_TousMag.Checked) then
  begin
    MessageDlg('Merci de choisir un magasin !', mterror, [Mbok], 0);
    exit;
  end;

  if (cb_TarVente.ItemIndex<=0) then
  begin
    MessageDlg('Merci la bascule Groupe de tarif magasin déjà migré !', mterror, [Mbok], 0);
    exit;
  end;

  if (Trim(Ed_Dossier.Text)='') then
  begin
    MessageDlg('Merci de définir un dossier !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseClient := ed_RepriseClient.Text;
  if (sFileRepriseClient='') or not(FileExists(sFileRepriseClient)) then
  begin
    MessageDlg('Fichier Client manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseCompte := ed_RepriseCompte.Text;
  if (sFileRepriseCompte='') or not(FileExists(sFileRepriseCompte)) then
  begin
    MessageDlg('Fichier Compte manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseCaisse := ed_RepriseCaisse.Text;
  if (sFileRepriseCaisse='') or not(FileExists(sFileRepriseCaisse)) then
  begin
    MessageDlg('Fichier Caisse manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseAvoir := ed_RepriseAvoir.Text;
  if (sFileRepriseAvoir='') or not(FileExists(sFileRepriseAvoir)) then
  begin
    MessageDlg('Fichier Avoir manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseBonLivraison := ed_RepriseBonLivraison.Text;
  if (sFileRepriseBonLivraison='') or not(FileExists(sFileRepriseBonLivraison)) then
  begin
    MessageDlg('Fichier BonLivraison manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseBonLivraisonL := ed_RepriseBonLivraisonL.Text;
  if (sFileRepriseBonLivraisonL='') or not(FileExists(sFileRepriseBonLivraisonL)) then
  begin
    MessageDlg('Fichier BonLivraisonL manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  sFileRepriseBonLivraisonHisto := ed_RepriseBonLivraisonHisto.Text;
  if (sFileRepriseBonLivraisonHisto='') or not(FileExists(sFileRepriseBonLivraisonHisto)) then
  begin
    MessageDlg('Fichier BonLivraisonHisto manquant ou inexistant !', mterror, [Mbok], 0);
    exit;
  end;

  // insertion des Entetes si pas fait
  if Chk_InsererEnteteReprise.Checked then
  begin
    if not AjoutEntete(ed_RepriseClient, Clients_COL, Clients_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
    if not AjoutEntete(ed_RepriseCompte, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
    if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
    begin
      if not AjoutEntete(ed_RepriseCaisse, Caisse_2_COL, Caisse_CSV, Chk_RetirePtVirgReprise.Checked) then
        exit;
    end
    else
    begin
      if not AjoutEntete(ed_RepriseCaisse, Caisse_COL, Caisse_CSV, Chk_RetirePtVirgReprise.Checked) then
        exit;
    end;
    if not AjoutEntete(ed_RepriseAvoir, Avoir_COL, Avoir_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
    if not AjoutEntete(ed_RepriseBonLivraison, BonLivraison_COL, BonLivraison_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
    if not AjoutEntete(ed_RepriseBonLivraisonL, BonLivraisonL_COL, BonLivraisonL_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
    if not AjoutEntete(ed_RepriseBonLivraisonHisto, BonLivraisonHisto_COL, BonLivraisonHisto_CSV, Chk_RetirePtVirgReprise.Checked) then
      exit;
  end;

  // vérification des entête
  if not Verification(ed_RepriseClient, Clients_COL, Clients_CSV, Chk_RetirePtVirgReprise.Checked) then
    Exit;
  if not Verification(ed_RepriseCompte, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgReprise.Checked) then
    Exit;
  if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
  begin
    if not Verification(ed_RepriseCaisse, Caisse_2_COL, Caisse_CSV, Chk_RetirePtVirgReprise.Checked) then
      Exit;
  end
  else
  begin
    if not Verification(ed_RepriseCaisse, Caisse_COL, Caisse_CSV, Chk_RetirePtVirgReprise.Checked) then
      Exit;
  end;
  if not Verification(ed_RepriseAvoir, Avoir_COL, Avoir_CSV, Chk_RetirePtVirgReprise.Checked) then
    exit;
  if not Verification(ed_RepriseBonLivraison, BonLivraison_COL, BonLivraison_CSV, Chk_RetirePtVirgReprise.Checked) then
    exit;
  if not Verification(ed_RepriseBonLivraisonL, BonLivraisonL_COL, BonLivraisonL_CSV, Chk_RetirePtVirgReprise.Checked) then
    exit;
  if not Verification(ed_RepriseBonLivraisonHisto, BonLivraisonHisto_COL, BonLivraisonHisto_CSV, Chk_RetirePtVirgReprise.Checked) then
    exit;

  Dm_Main.ReperSavID := Dm_Main.ReperBase+'Import\'+Trim(Ed_Dossier.Text)+'\';
  SysUtils.ForceDirectories(Dm_Main.ReperSavID);


  //Backup des paramètres
  LstParam := TStringList.Create;
  try
    LstParam.Add('Voici la liste des paramètres choisi pour la reprise : ');
    LstParam.Add('Base ginkoia                : ' + Ed_BasePath.Text);
    LstParam.Add('Dossier                     : ' + Ed_Dossier.Text);
    LstParam.Add('Provenance import           : ' + Cb_Provenance.Text);
    LstParam.Add('Choix du magasin            : ' + Cb_Magasin.Text);
    LstParam.Add('Contient tous les magasins  : ' + OuiNon(Chk_TousMag.Checked));
    LstParam.Add('Second import               : ' + OuiNon(Chk_SecondImport.Checked));
    LstParam.Add('Pas de recalcul de stock    : ' + OuiNon(Chk_PasDeRecalStk.Checked));
    case Rgr_NivMail.ItemIndex of
      0: LstParam.Add('Niveau envoi des logs       : Aucun envoi.');
      1: LstParam.Add('Niveau envoi des logs       : Erreur.');
      2: LstParam.Add('Niveau envoi des logs       : Client - Article - Historique.');
      3: LstParam.Add('Niveau envoi des logs       : Toutes les étapes.');
    end;
    LstParam.SaveToFile(Dm_Main.ReperSavID + 'Param_Reprise_' + FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
  finally
    FreeAndNil(LstParam);
  end;

  // prepare l'historique
  EtatLanceCli := 0;
  EtatLanceArt := -1;
  EtatLanceHisto := 0;
  EtatLanceBonR := -1;
  EtatLanceAtelier := -1;
  bError := false;

  bobClient := true;
  obClient := TClient.Create(True, chk_ChargementClients.Checked, True, 0);
  obClient.OnTerminate := OnTerminateobClient;
  obClient.InitThread(Chk_RetirePtVirgReprise.Checked, sFileRepriseClient, sFileRepriseCompte, '', '', '');

  bobHistorique := true;
  obHistorique := THistorique.Create( True,
                                      True,
                                      false,
                                      true,
                                      Chk_Correction_TVA.Checked);
  obHistorique.OnTerminate := OnTerminateobHistorique;
  obHistorique.InitThread(Chk_RetirePtVirgReprise.Checked, sFileRepriseCaisse, '', '', '', '', '', sFileRepriseAvoir,
    sFileRepriseBonLivraison, sFileRepriseBonLivraisonL, sFileRepriseBonLivraisonHisto);

  Frm_Load.DoInit(EtatLanceCli, EtatLanceArt, EtatLanceHisto, EtatLanceBonR, EtatLanceAtelier);
  Frm_Load.Show;
  Frm_Load.OkFermer := false;
  Frm_Main.Enabled := False;
  Application.ProcessMessages;

  EtatLanceCli := 1;   // en cours
  obClient.Start;

end;

procedure TFrm_Main.btn_ClientsPathClick(Sender: TObject);
var
  sDir : string;
begin
  sDir := GetDirCsv;
  if sDir <> '' then
  begin
    ed_ClientsPath.Text := sDir;
    DoRepClient(sDir);
    // integration des articles ?
    if not(chk_ChargementArticle.Checked)
            and (MessageDlg('Intégrer les articles du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementArticle.Checked := true;
      ed_ArticlePath.Text := sDir;
      DoRepArticle(sDir);
    end;
    // integration des historiques ?
    if not(chk_ChargementHistoriques.Checked)
            and (MessageDlg('Intégrer l''historique du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementHistoriques.Checked := true;
      ed_HistoriquesPath.Text := sDir;
      DoRepHisto(sDir);
    end;

    if (Dm_Main.Provenance in [ipNosymag]) then
    begin
      // integration bons rapprochement ?
      if not(chk_ChargementBonsRapprochement.Checked)
              and (MessageDlg('Intégrer les bons de rappro du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
      begin
        chk_ChargementBonsRapprochement.Checked := true;
        EditCheminBonRapprochement.Text := sDir;
        DoRepBonRapprochement(sDir);
      end;

      // integration ateler ?
      if not(chk_ChargementAtelier.Checked)
              and (MessageDlg('Intégrer l''atelier du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
      begin
        chk_ChargementAtelier.Checked := true;
        EditCheminAtelier.Text := sDir;
        DoRepAtelier(sDir);
      end;
    end;
  end;
end;

procedure TFrm_Main.btn_CMarqueCsvClick(Sender: TObject);
begin
  CreerFile(ed_MarqueCsv.Text);
  VerifPath(ed_MarqueCsv);
end;

procedure TFrm_Main.btn_CModeleDeprecieCsvClick(Sender: TObject);
begin
  CreerFile(ed_ModeleDeprecieCsv.Text);
  VerifPath(ed_ModeleDeprecieCsv);
end;

procedure TFrm_Main.btn_COcDetailCsvClick(Sender: TObject);
begin
  CreerFile(ed_OcDetailCsv.Text);
  VerifPath(ed_OcDetailCsv);
end;

procedure TFrm_Main.btn_COcLignesCsvClick(Sender: TObject);
begin
  CreerFile(ed_OcLignesCsv.Text);
  VerifPath(ed_OcLignesCsv);
end;

procedure TFrm_Main.btn_COcMagCsvClick(Sender: TObject);
begin
  CreerFile(ed_OcMagCsv.Text);
  VerifPath(ed_OcMagCsv);
end;

procedure TFrm_Main.btn_COcTeteCsvClick(Sender: TObject);
begin
  CreerFile(ed_OcTeteCsv.Text);
  VerifPath(ed_OcTeteCsv);
end;

procedure TFrm_Main.btn_ArticlePathClick(Sender: TObject);
var
  sDir : string;
begin
  sDir := GetDirCsv;
  if sDir <> '' then
  begin
    ed_ArticlePath.Text := sDir;
    DoRepArticle(sDir);

    // integration des clients ?
    if not(chk_ChargementClients.Checked)
            and (MessageDlg('Intégrer les clients du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementClients.Checked := true;
      ed_ClientsPath.Text := sDir;
      DoRepClient(sDir);
    end;

    // integration des historiques ?
    if not(chk_ChargementHistoriques.Checked)
            and (MessageDlg('Intégrer l''historique du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementHistoriques.Checked := true;
      ed_HistoriquesPath.Text := sDir;
      DoRepHisto(sDir);
    end;

    if (Dm_Main.Provenance in [ipNosymag]) then
    begin
      // integration bons rapprochement ?
      if not(chk_ChargementBonsRapprochement.Checked)
              and (MessageDlg('Intégrer les bons de rappro du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
      begin
        chk_ChargementBonsRapprochement.Checked := true;
        EditCheminBonRapprochement.Text := sDir;
        DoRepBonRapprochement(sDir);
      end;

      // integration ateler ?
      if not(chk_ChargementAtelier.Checked)
              and (MessageDlg('Intégrer l''atelier du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
      begin
        chk_ChargementAtelier.Checked := true;
        EditCheminAtelier.Text := sDir;
        DoRepAtelier(sDir);
      end;
    end;
  end;
end;

procedure TFrm_Main.btn_ArtidealCsvClick(Sender: TObject);
begin
  ed_ArtidealCsv.Text := GetPathCsv('Choix du fichier Artideal.csv');
end;

procedure TFrm_Main.btn_AvoirCsvClick(Sender: TObject);
begin
  ed_AvoirCsv.Text := GetPathCsv('Choix du fichier Avoir.csv');
end;

procedure TFrm_Main.btn_HistoriquesPathClick(Sender: TObject);
var
  sDir : string;
begin
  sDir := GetDirCsv;
  if sDir <> '' then
  begin
    ed_HistoriquesPath.Text := sDir;
    DoRepHisto(sDir);

    // integration des clients ?
    if Tab_Clients.TabVisible and ( not( chk_ChargementClients.Checked ) )
            and (MessageDlg('Intégrer les clients du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementClients.Checked := true;
      ed_ClientsPath.Text := sDir;
      DoRepClient(sDir);
    end;

    // integration des articles ?
    if Tab_RefArticle.TabVisible and ( not( chk_ChargementArticle.Checked ) )
            and (MessageDlg('Intégrer les articles du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementArticle.Checked := true;
      ed_ArticlePath.Text := sDir;
      DoRepArticle(sDir);
    end;

    if (Dm_Main.Provenance in [ipNosymag]) then
    begin
      // integration bons rapprochement ?
      if Tab_BonRapprochement.TabVisible and (not(chk_ChargementBonsRapprochement.Checked))
              and (MessageDlg('Intégrer les bons de rappro du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
      begin
        chk_ChargementBonsRapprochement.Checked := true;
        EditCheminBonRapprochement.Text := sDir;
        DoRepBonRapprochement(sDir);
      end;

      // integration ateler ?
      if Tab_Atelier.TabVisible and (not(chk_ChargementAtelier.Checked))
              and (MessageDlg('Intégrer l''atelier du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
      begin
        chk_ChargementAtelier.Checked := true;
        EditCheminAtelier.Text := sDir;
        DoRepAtelier(sDir);
      end;
    end
  end;
end;

procedure TFrm_Main.Btn_ImporterClick(Sender: TObject);
var
  msg       : string;
  sTmpCB    : string;
  bContinue : Boolean;
  iNumFile  : Integer;
  tmpEdit   : TEdit;
  LstParam  : TStringList;
{$REGION 'Btn_ImporterClick'}
  function AjoutEntete(ed_path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  var
    ij: integer;
    TmpListe: TStringList;
    sPremier: string;
    sLigne: string;
    bFaire: boolean;
  begin
    Result := false;

    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''existe pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
      exit;
    end;

    TmpListe := TStringList.Create;
    try
      bFaire := false;
      TmpListe.LoadFromFile(ed_Path.Text);
      sPremier := '';
      if TmpListe.Count>0 then
        sPremier := TmpListe[0];

      if Pos(';', sPremier)>0 then
        sPremier := Copy(sPremier, 1, pos(';', sPremier)-1);

      sPremier := UpperCase(sPremier);
      if High(tab_Col)>0 then
      begin
        if UpperCase(sPremier)<>UpperCase(tab_Col[0]) then
          bFaire := true;
      end;

      if bFaire then
      begin
        sLigne := '';
        for ij := 0 to High(tab_col) do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          sLigne := sLigne+tab_col[ij];
        end;
        if ARetirePtVirg then
          sLigne := sLigne+';';

        if TmpListe.Count>0 then
          TmpListe.Insert(0, sLigne)
        else
          TmpListe.Add(sLigne);

        TmpListe.SaveToFile(ed_Path.Text);
      end;
      Result := true;
    finally
      FreeAndNil(TmpListe);
    end;

  end;

  function Verification(ed_Path: TEdit; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
  begin
    Result := False;
    if not VerifPath(ed_Path) then
    begin
      msg := 'Le fichier "' + nom_File + '" n''existe pas. Merci de vous reporter à la documentation';
      MessageDlg(msg,mtError, mbOKCancel, 0);
    end
    else
      if not VerifFormatFile(ed_Path.Text, tab_Col, ARetirePtVirg) then
      begin
        msg := 'Le format du fichier "' + nom_File + '" ne correspond pas. Merci de vous reporter à la documentation';
        MessageDlg(msg,mtError, mbOKCancel, 0);
      end
      else
        if not VerifFile(ed_Path.Text, tab_Col) then
        begin
          msg := 'Le fichier "' + nom_File + '" contient des caractères non autorisés. Merci de vous reporter à la documentation';
          MessageDlg(msg,mtError, mbOKCancel, 0);
        end
        else
          Result := True;
  end;
  {$ENDREGION}
begin
  try
    if not(Dm_Main.Database.Connected) then
    begin
      MessageDlg('Base de données non connecté !', mterror, [Mbok], 0);
      exit;
    end;

    if not(GetVerrifGenTrigger) then
    begin
      MessageDlg('La table GenTriggerDiff contient encore des données !', mterror, [Mbok], 0);
      exit;
    end;

    if (cb_Provenance.ItemIndex<=0) then
    begin
      MessageDlg('Merci de choisir la provenance de l''import !', mterror, [Mbok], 0);
      exit;
    end;

    if (cb_Magasin.ItemIndex<=0) and not(Chk_TousMag.Checked) then
    begin
      MessageDlg('Merci de choisir un magasin !', mterror, [Mbok], 0);
      exit;
    end;

    if (cb_TarVente.ItemIndex<=0) then
    begin
      MessageDlg('Merci la bascule Groupe de tarif magasin déjà migré !', mterror, [Mbok], 0);
      exit;
    end;

    if (Trim(Ed_Dossier.Text)='') then
    begin
      MessageDlg('Merci de définir un dossier !', mterror, [Mbok], 0);
      exit;
    end;

    if not(chk_ChargementClients.Checked)
         and not(chk_ChargementArticle.Checked)
         and not(chk_ChargementHistoriques.Checked)
         and not(chk_ChargementBonsRapprochement.Checked)
         and not(chk_ChargementAtelier.Checked) then
      exit;
  except
    on E:Exception do
    begin
      MessageDlg('erreur pré control :' + e.Message, mterror, [Mbok], 0);
      exit;
    end;
  end;


  //Mail
  Dm_Main.SetSubjectMail(Ed_Dossier.Text);

  try
    {$REGION 'Vérification des fichiers Clients'}
    try
      if chk_ChargementClients.Checked then
      begin
        // insertion des Entetes si pas fait
        bContinue := true;
        if Chk_InsererEnteteCli.Checked then
        begin
          if not AjoutEntete(ed_ClientsCsv, Clients_COL, Clients_CSV, Chk_RetirePtVirgCli.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_LienClientsCsv, LienClients_COL, LienClients_CSV, Chk_RetirePtVirgCli.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_ComptesCsv, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgCli.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_FideliteCsv, Fidelite_COL, Fidelite_CSV, Chk_RetirePtVirgCli.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_BonAchatsCsv, BonAchats_COL, BonAchats_CSV, Chk_RetirePtVirgCli.Checked) then
            bContinue := false;
        end;
        if not(bContinue) then
          exit;

        // vérification des entête
        if not Verification(ed_ClientsCsv, Clients_COL, Clients_CSV, Chk_RetirePtVirgCli.Checked) then
          Exit;
        if not Verification(ed_LienClientsCsv, LienClients_COL, LienClients_CSV, Chk_RetirePtVirgCli.Checked) then
          Exit;
        if not Verification(ed_ComptesCsv, Comptes_COL, Comptes_CSV, Chk_RetirePtVirgCli.Checked) then
          Exit;
        if not Verification(ed_FideliteCsv, Fidelite_COL, Fidelite_CSV, Chk_RetirePtVirgCli.Checked) then
          Exit;
        if not Verification(ed_BonAchatsCsv, BonAchats_COL, BonAchats_CSV, Chk_RetirePtVirgCli.Checked) then
          Exit;
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create('Clients :' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Vérification des fichiers RefArticle'}
    try
      if chk_ChargementArticle.Checked then
      begin
        // insertion des Entetes si pas fait
        bContinue := true;
        if Chk_InsererEnteteArt.Checked then
        begin
          if (Dm_Main.Provenance in [ipNosymag]) then
          begin
            if not AjoutEntete(ed_FournCsv, Fourn_2_COL, Fourn_CSV, Chk_RetirePtVirgArt.Checked) then
              bContinue := false;

            sTmpCB := ed_CodeBarreCsv.Text;
            ed_CodeBarreCsv.Text := ExtractFilePath(sTmpCB) + 'All_CB.csv';

            if not AjoutEntete(ed_CodeBarreCsv, CodeBarre_COL, CodeBarre_CSV, Chk_RetirePtVirgArt.Checked) then
              bContinue := false;

            ed_CodeBarreCsv.Text := sTmpCB;
          end
          else
          begin
            if not AjoutEntete(ed_FournCsv, Fourn_COL, Fourn_CSV, Chk_RetirePtVirgArt.Checked) then
              bContinue := false;
          end;

          if not AjoutEntete(ed_MarqueCsv, Marque_COL, Marque_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_FoumarqueCsv, Foumarque_COL, Foumarque_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_GrTailleCsv, GrTaille_COL, GrTaille_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_GrTailleLigCsv, GrTailleLig_COL, GrTailleLig_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_DomaineCommercialCsv, DomaineCommercial_COL, DomaineCommercial_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_AxeCsv, Axe_COL, Axe_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_AxeNiveau1Csv, AxeNiveau1_COL, AxeNiveau1_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_AxeNiveau2Csv, AxeNiveau2_COL, AxeNiveau2_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_AxeNiveau3Csv, AxeNiveau3_COL, AxeNiveau3_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_AxeNiveau4Csv, AxeNiveau4_COL, AxeNiveau4_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_CollectionCsv, Collection_COL, Collection_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_GenreCsv, Genre_COL, Genre_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if (Dm_Main.Provenance in [ipNosymag]) then
          begin
            if not AjoutEntete(ed_ArticleCsv, Article_2_COL, Article_CSV, Chk_RetirePtVirgArt.Checked) then
              bContinue := false;
          end
          else
          begin
            if not AjoutEntete(ed_ArticleCsv, Article_COL, Article_CSV, Chk_RetirePtVirgArt.Checked) then
              bContinue := false;
          end;
          if not AjoutEntete(ed_ArticleAxeCsv, ArticleAxe_COL, ArticleAxe_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_ArticleCollectionCsv, ArticleCollection_COL, ArticleCollection_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_CouleurCsv, Couleur_COL, Couleur_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_CodeBarreCsv, CodeBarre_COL, CodeBarre_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_PrixAchatCsv, Prix_Achat_COL, Prix_Achat_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_PrixVenteCsv, Prix_Vente_COL, Prix_Vente_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;

          if not(Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
          begin
            iNumFile := 0;
            tmpEdit := TEdit.Create(Self);
            try
              tmpEdit.Text := Ed_PrixVenteIndicatifCsv.Text;
              while FileExists(tmpEdit.Text) do
              begin
                if not AjoutEntete(tmpEdit, Prix_Vente_Indicatif_COL, Prix_Vente_Indicatif_CSV, Chk_RetirePtVirgHis.Checked) then
                  bContinue := false;
                Inc(iNumFile);
                tmpEdit.Text := StringReplace(tmpEdit.Text, ExtractFileName(tmpEdit.Text), 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
              end;
            finally
              tmpEdit.Free;
            end;
          end;

          if not AjoutEntete(ed_ModeleDeprecieCsv, ModeleDeprecie_COL, ModeleDeprecie_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_FouContactCsv, FouContact_COL, FouContact_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_FouConditionCsv, FouCondition_COL, FouCondition_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_ArtidealCsv, ArtIdeal_COL, ArtIdeal_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_OcTeteCsv, OcTete_COL, OcTete_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_OcMagCsv, OcMag_COL, OcMag_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_OcLignesCsv, OcLignes_COL, OcLignes_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
          if not AjoutEntete(ed_OcDetailCsv, OcDetail_COL, OcDetail_CSV, Chk_RetirePtVirgArt.Checked) then
            bContinue := false;
        end;
        if not(bContinue) then
          exit;

        // vérification des entête
        if (Dm_Main.Provenance in [ipNosymag]) then
        begin
          if not Verification(ed_FournCsv, Fourn_2_COL, Fourn_CSV, Chk_RetirePtVirgArt.Checked) then
            Exit;
        end
        else
        begin
          if not Verification(ed_FournCsv, Fourn_COL, Fourn_CSV, Chk_RetirePtVirgArt.Checked) then
            Exit;
        end;

        if not Verification(ed_MarqueCsv, Marque_COL, Marque_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_FoumarqueCsv, Foumarque_COL, Foumarque_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_GrTailleCsv, GrTaille_COL, GrTaille_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_GrTailleLigCsv, GrTailleLig_COL, GrTailleLig_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_DomaineCommercialCsv, DomaineCommercial_COL, DomaineCommercial_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_AxeCsv, Axe_COL, Axe_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_AxeNiveau1Csv, AxeNiveau1_COL, AxeNiveau1_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_AxeNiveau2Csv, AxeNiveau2_COL, AxeNiveau2_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_AxeNiveau3Csv, AxeNiveau3_COL, AxeNiveau3_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_AxeNiveau4Csv, AxeNiveau4_COL, AxeNiveau4_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_CollectionCsv, Collection_COL, Collection_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_GenreCsv, Genre_COL, Genre_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if (Dm_Main.Provenance in [ipNosymag]) then
        begin
          if not Verification(ed_ArticleCsv, Article_2_COL, Article_CSV, Chk_RetirePtVirgArt.Checked) then
            Exit;
        end
        else
        begin
          if not Verification(ed_ArticleCsv, Article_COL, Article_CSV, Chk_RetirePtVirgArt.Checked) then
            Exit;
        end;

        if not Verification(ed_ArticleAxeCsv, ArticleAxe_COL, ArticleAxe_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_ArticleCollectionCsv, ArticleCollection_COL, ArticleCollection_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_CouleurCsv, Couleur_COL, Couleur_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_CodeBarreCsv, CodeBarre_COL, CodeBarre_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_PrixAchatCsv, Prix_Achat_COL, Prix_Achat_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_PrixVenteCsv, Prix_Vente_COL, Prix_Vente_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;

        if not(Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
        begin
          iNumFile := 0;
          tmpEdit := TEdit.Create(Self);
          try
            tmpEdit.Text := Ed_PrixVenteIndicatifCsv.Text;
            while FileExists(tmpEdit.Text) do
            begin
              if not Verification(tmpEdit, Prix_Vente_Indicatif_COL, ExtractFileName(tmpEdit.Text), Chk_RetirePtVirgHis.Checked) then
                Exit;
              Inc(iNumFile);
              tmpEdit.Text := StringReplace(tmpEdit.Text, ExtractFileName(tmpEdit.Text), 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
            end;
          finally
            tmpEdit.Free;
          end;
        end;

        if not Verification(ed_ModeleDeprecieCsv, ModeleDeprecie_COL, ModeleDeprecie_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_FouContactCsv, FouContact_COL, FouContact_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_FouConditionCsv, FouCondition_COL, FouCondition_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_ArtidealCsv, ArtIdeal_COL, ArtIdeal_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_OcTeteCsv, OcTete_COL, OcTete_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_OcMagCsv, OcMag_COL, OcMag_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_OcLignesCsv, OcLignes_COL, OcLignes_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
        if not Verification(ed_OcDetailCsv, OcDetail_COL, OcDetail_CSV, Chk_RetirePtVirgArt.Checked) then
          Exit;
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create('Articles :' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Vérification des fichiers Historique'}
    try
      if chk_ChargementHistoriques.Checked then
      begin
        // insertion des Entetes si pas fait
        bContinue := true;
        if Chk_InsererEnteteHis.Checked then
        begin
          iNumFile := 0;
          tmpEdit := TEdit.Create(Self);
          try
            tmpEdit.Text := ed_CaisseCsv.Text;
            while FileExists(tmpEdit.Text) do
            begin
              if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
              begin
                if not AjoutEntete(tmpEdit, Caisse_2_COL, Caisse_CSV, Chk_RetirePtVirgHis.Checked) then
                  bContinue := false;
              end
              else
              begin
                if not AjoutEntete(tmpEdit, Caisse_COL, Caisse_CSV, Chk_RetirePtVirgHis.Checked) then
                  bContinue := false;
              end;
              Inc(iNumFile);
              tmpEdit.Text := StringReplace(tmpEdit.Text, ExtractFileName(tmpEdit.Text), 'caisse' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
            end;
          finally
            tmpEdit.Free;
          end;

          if not AjoutEntete(ed_ConsodivCsv, Consodiv_COL, Consodiv_CSV, Chk_RetirePtVirgHis.Checked) then
            bContinue := false;

          if (Dm_Main.Provenance <> ipOldGoSport) then
          begin
            iNumFile := 0;
            tmpEdit := TEdit.Create(Self);
            try
              tmpEdit.Text := ed_ReceptionCsv.Text;
              while FileExists(tmpEdit.Text) do
              begin
                if not AjoutEntete(tmpEdit, Reception_COL, Reception_CSV, Chk_RetirePtVirgHis.Checked) then
                  bContinue := false;
                Inc(iNumFile);
                tmpEdit.Text := StringReplace(tmpEdit.Text, ExtractFileName(tmpEdit.Text), 'reception' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
              end;
            finally
              tmpEdit.Free;
            end;

            if not AjoutEntete(ed_TransfertCsv, Transfert_COL, Transfert_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
            if not AjoutEntete(ed_CommandesCsv, Commandes_COL, Commandes_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
            if not AjoutEntete(ed_RetourFouCsv, RetourFou_COL, RetourFou_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
            if not AjoutEntete(ed_AvoirCsv, Avoir_COL, Avoir_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
            if not AjoutEntete(ed_BonLivraisonCsv, BonLivraison_COL, BonLivraison_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
            if not AjoutEntete(ed_BonLivraisonLCsv, BonLivraisonL_COL, BonLivraisonL_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
            if not AjoutEntete(ed_BonLivraisonHistoCsv, BonLivraisonHisto_COL, BonLivraisonHisto_CSV, Chk_RetirePtVirgHis.Checked) then
              bContinue := false;
          end;
        end;
        if not(bContinue) then
          exit;

        // vérification des entête
        iNumFile := 0;
        tmpEdit := TEdit.Create(Self);
        try
          tmpEdit.Text := ed_CaisseCsv.Text;
          while FileExists(tmpEdit.Text) do
          begin
            if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
            begin
              if not Verification(tmpEdit, Caisse_2_COL, ExtractFileName(tmpEdit.Text), Chk_RetirePtVirgHis.Checked) then
                Exit;
            end
            else
            begin
              if not Verification(tmpEdit, Caisse_COL, ExtractFileName(tmpEdit.Text), Chk_RetirePtVirgHis.Checked) then
                Exit;
            end;
            Inc(iNumFile);
            tmpEdit.Text := StringReplace(tmpEdit.Text, ExtractFileName(tmpEdit.Text), 'caisse' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
          end;
        finally
          tmpEdit.Free;
        end;

        if not Verification(ed_ConsodivCsv, Consodiv_COL, Consodiv_CSV, Chk_RetirePtVirgHis.Checked) then
          Exit;

        if (Dm_Main.Provenance <> ipOldGoSport) then
        begin
          iNumFile := 0;
          tmpEdit := TEdit.Create(Self);
          try
            tmpEdit.Text := ed_ReceptionCsv.Text;
            while FileExists(tmpEdit.Text) do
            begin
              if not Verification(tmpEdit, Reception_COL, ExtractFileName(tmpEdit.Text), Chk_RetirePtVirgHis.Checked) then
                Exit;
              Inc(iNumFile);
              tmpEdit.Text := StringReplace(tmpEdit.Text, ExtractFileName(tmpEdit.Text), 'reception' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
            end;
          finally
            tmpEdit.Free;
          end;

          if not Verification(ed_TransfertCsv, Transfert_COL, Transfert_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_CommandesCsv, Commandes_COL, Commandes_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_RetourFouCsv, RetourFou_COL, RetourFou_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_AvoirCsv, Avoir_COL, Avoir_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_BonLivraisonCsv, BonLivraison_COL, BonLivraison_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_BonLivraisonCsv, BonLivraison_COL, BonLivraison_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_BonLivraisonCsv, BonLivraison_COL, BonLivraison_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
        end;
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create('Historique :' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Vérification des fichiers bon de rapprochement.'}
    try
      if chk_ChargementBonsRapprochement.Checked then
      begin
        // Insertion des en-têtes si pas fait.
        bContinue := True;
        if Chk_InsererEnteteBonR.Checked then
        begin
          if not AjoutEntete(EditBonRapprochementCsv, BonRapprochement_COL, BonRapprochement_CSV, Chk_RetirePtVirgBonR.Checked) then
            bContinue := False;
          if not AjoutEntete(EditBonRapprochementLienCsv, BonRapprochementLien_COL, BonRapprochementLien_CSV, Chk_RetirePtVirgBonR.Checked) then
            bContinue := False;
          if not AjoutEntete(EditBonRapprochementTVACsv, BonRapprochementTVA_COL, BonRapprochementTVA_CSV, Chk_RetirePtVirgBonR.Checked) then
            bContinue := False;
          if not AjoutEntete(EditBonRapprochementLigneReceptionCsv, BonRapprochementLigneReception_COL, BonRapprochementLigneReception_CSV, Chk_RetirePtVirgBonR.Checked) then
            bContinue := False;
          if not AjoutEntete(EditBonRapprochementLigneRetourCsv, BonRapprochementLigneRetour_COL, BonRapprochementLigneRetour_CSV, Chk_RetirePtVirgBonR.Checked) then
            bContinue := False;
        end;
        if not bContinue then
          Exit;

        // Vérification des en-têtes.
        if not Verification(EditBonRapprochementCsv, BonRapprochement_COL, BonRapprochement_CSV, Chk_RetirePtVirgBonR.Checked) then
          Exit;
        if not Verification(EditBonRapprochementLienCsv, BonRapprochementLien_COL, BonRapprochementLien_CSV, Chk_RetirePtVirgBonR.Checked) then
          Exit;
        if not Verification(EditBonRapprochementTVACsv, BonRapprochementTVA_COL, BonRapprochementTVA_CSV, Chk_RetirePtVirgBonR.Checked) then
          Exit;
        if not Verification(EditBonRapprochementLigneReceptionCsv, BonRapprochementLigneReception_COL, BonRapprochementLigneReception_CSV, Chk_RetirePtVirgBonR.Checked) then
          Exit;
        if not Verification(EditBonRapprochementLigneRetourCsv, BonRapprochementLigneRetour_COL, BonRapprochementLigneRetour_CSV, Chk_RetirePtVirgBonR.Checked) then
          Exit;

        if not chk_ChargementHistoriques.Checked then
        begin
          MessageDlg('Attention :  l''import des bons de rapprochement nécessite l''import des réceptions et des retours fournisseur !', mtWarning, [mbok], 0);
          Exit;
        end
        else
        begin
          if not Verification(ed_ReceptionCsv, Reception_COL, ExtractFileName(ed_ReceptionCsv.Text), Chk_RetirePtVirgHis.Checked) then
            Exit;
          if not Verification(ed_RetourFouCsv, RetourFou_COL, RetourFou_CSV, Chk_RetirePtVirgHis.Checked) then
            Exit;
        end;
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create('Rapprochement :' + E.Message);
      end;
    end;
    {$ENDREGION}


    {$REGION 'Vérification des fichiers atelier'}
    try
      if chk_ChargementAtelier.Checked then
      begin
        // Insertion des en-têtes si pas fait.
        bContinue := True;
        if Chk_InsererEnteteAtelier.Checked then
        begin
          if not AjoutEntete(EditSavTauxHCsv, SavTauxH_COL, SavTauxH_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavForfaitCsv, SavForfait_COL, SavForfait_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavForfaitLCsv, SavForfaitL_COL, SavForfaitL_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavPt1Csv, SavPt1_COL, SavPt1_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavPt2Csv, SavPt2_COL, SavPt2_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavTypMatCsv, SavTypMat_COL, SavTypMat_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavTypeCsv, SavType_COL, SavType_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavMatCsv, SavMat_COL, SavMat_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavCbCsv, SavCb_COL, SavCb_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavFicheeCsv, SavFichee_COL, SavFichee_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavFicheLCsv, SavFicheL_COL, SavFicheL_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
          if not AjoutEntete(EditSavFicheArtCsv, SavFicheArt_COL, SavFicheArt_CSV, Chk_RetirePtVirgAtelier.Checked) then
            bContinue := False;
        end;
        if not bContinue then
          Exit;

        // Vérification des en-têtes.
        if not Verification(EditSavTauxHCsv, SavTauxH_COL, SavTauxH_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavForfaitCsv, SavForfait_COL, SavForfait_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavForfaitLCsv, SavForfaitL_COL, SavForfaitL_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavPt1Csv, SavPt1_COL, SavPt1_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavPt2Csv, SavPt2_COL, SavPt2_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavTypMatCsv, SavTypMat_COL, SavTypMat_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavTypeCsv, SavType_COL, SavType_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavMatCsv, SavMat_COL, SavMat_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavCbCsv, SavCb_COL, SavCb_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavFicheeCsv, SavFichee_COL, SavFichee_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavFicheLCsv, SavFicheL_COL, SavFicheL_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;
        if not Verification(EditSavFicheArtCsv, SavFicheArt_COL, SavFicheArt_CSV, Chk_RetirePtVirgAtelier.Checked) then
          Exit;

        if not chk_ChargementClients.Checked or not chk_ChargementArticle.Checked then
        begin
          MessageDlg('Attention :  l''import de l''atelier nécessite l''import des clients et des articles !', mtWarning, [mbok], 0);
          Exit;
        end;
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create('Atelier :' + E.Message);
      end;
    end;
    {$ENDREGION}
  except
    on E:Exception do
    begin
      MessageDlg('erreur verification fichier ' + e.Message, mterror, [Mbok], 0);
      exit;
    end;
  end;

  // création du répertoire de sauvegarde des ID créés
  // dernier répertoire
//  sTmp := ed_BasePath.Text;
//  sTmp := Copy(sTmp, 1, Length(sTmp)-Length(ExtractFileName(sTmp))-1);
//  sTmp := ExtractFileName(sTmp);
//  Dm_Main.ReperSavID := sTmp+' - ';
//  // nom magasin
//  sTmp := cb_Magasin.Items[cb_Magasin.ItemIndex];
//  // pas de caractère spéciaux: \/:*?"<>|
//  sTmp := StringReplace(sTmp, '\', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '/', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, ':', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '*', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '?', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '"', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '<', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '>', '_', [rfReplaceAll, rfIgnoreCase]);
//  sTmp := StringReplace(sTmp, '|', '_', [rfReplaceAll, rfIgnoreCase]);
//  Dm_Main.ReperSavID := Dm_Main.ReperSavID + sTmp;
//  Dm_Main.ReperSavID := Dm_Main.ReperBase+'Import\'+Dm_Main.ReperSavID+'\';

  try
    Dm_Main.ReperSavID := Dm_Main.ReperBase+'Import\'+Trim(Ed_Dossier.Text)+'\';

    if Chk_SecondImport.Checked then
    begin
      SysUtils.RenameFile(Dm_Main.ReperSavID + CouleurID, Dm_Main.ReperSavID + 'Old_' + CouleurID);
    end;

    SysUtils.ForceDirectories(Dm_Main.ReperSavID);

    EtatLanceCli := -1;
    EtatLanceArt := -1;
    EtatLanceHisto := -1;
    EtatLanceBonR := -1;
    EtatLanceAtelier := -1;
    bError := false;

    if chk_ChargementClients.Checked then
      EtatLanceCli := 0;  // en attente

    if chk_ChargementArticle.Checked then
      EtatLanceArt := 0;  // en attente

    if chk_ChargementHistoriques.Checked then
      EtatLanceHisto := 0;  // en attente

    if chk_ChargementBonsRapprochement.Checked then
      EtatLanceBonR := 0;   // En attente.

    if chk_ChargementAtelier.Checked then
      EtatLanceAtelier := 0;   // En attente.

    //Backup des paramètres
    LstParam := TStringList.Create;
    try
      LstParam.Add('Voici la liste des paramètres choisis pour la migration : ');
      LstParam.Add('Base ginkoia                : ' + Ed_BasePath.Text);
      LstParam.Add('Dossier                     : ' + Ed_Dossier.Text);
      LstParam.Add('Provenance import           : ' + Cb_Provenance.Text);
      LstParam.Add('Choix du magasin            : ' + Cb_Magasin.Text);
      LstParam.Add('Contient tous les magasins  : ' + OuiNon(Chk_TousMag.Checked));
      LstParam.Add('Second import               : ' + OuiNon(Chk_SecondImport.Checked));
      LstParam.Add('Pas de recalcul de stock    : ' + OuiNon(Chk_PasDeRecalStk.Checked));
      case Rgr_NivMail.ItemIndex of
        0: LstParam.Add('Niveau envoi des logs       : Aucun envoi.');
        1: LstParam.Add('Niveau envoi des logs       : Erreur.');
        2: LstParam.Add('Niveau envoi des logs       : Client - Article - Historique - Bon de rapprochement - Atelier.');
        3: LstParam.Add('Niveau envoi des logs       : Toutes les étapes.');
      end;
      LstParam.Add('Traiter Clients               :  ' + OuiNon(chk_ChargementClients.Checked));
      LstParam.Add('Traiter Articles              :  ' + OuiNon(chk_ChargementArticle.Checked));
      LstParam.Add('Traiter Historiques           :  ' + OuiNon(chk_ChargementHistoriques.Checked));
      LstParam.Add(' - Ne pas faire de backup     :  ' + OuiNon(chk_noBackup.Checked));
      LstParam.Add('Correction TVA Reception      :  ' + OuiNon(Chk_Correction_TVA.Checked));
      LstParam.Add('Traiter Bons de rapprochement :  ' + OuiNon(chk_ChargementBonsRapprochement.Checked));
      LstParam.Add('Traiter Atelier               :  ' + OuiNon(chk_ChargementAtelier.Checked));
      LstParam.SaveToFile(Dm_Main.ReperSavID + 'Param_Migration_' + FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    finally
      FreeAndNil(LstParam);
    end;

    if chk_ChargementClients.Checked then
    begin
      bobClient := true;
      obClient := TClient.Create(True, chk_ChargementClients.Checked, False, 0);
      obClient.OnTerminate := OnTerminateobClient;
      obClient.InitThread(Chk_RetirePtVirgCli.Checked, ed_ClientsCsv.Text,
        ed_ComptesCsv.Text, ed_FideliteCsv.Text, ed_BonAchatsCsv.Text, ed_LienClientsCsv.Text);
    end;

    if chk_ChargementArticle.Checked then
    begin
      bobRefArticle := true;
      obRefArticle := TRefArticle.Create(True, chk_ChargementArticle.Checked);
      obRefArticle.OnTerminate := OnTerminateobRefArticle;
      obRefArticle.InitThread(Chk_RetirePtVirgArt.Checked, ed_FournCsv.Text,
        ed_MarqueCsv.Text, ed_FoumarqueCsv.Text, ed_GrTailleCsv.Text,
        ed_GrTailleLigCsv.Text, ed_DomaineCommercialCsv.Text, ed_AxeCsv.Text,
        ed_AxeNiveau1Csv.Text, ed_AxeNiveau2Csv.Text, ed_AxeNiveau3Csv.Text,
        ed_AxeNiveau4Csv.Text, ed_CollectionCsv.Text, ed_GenreCsv.Text,
        ed_ArticleCsv.Text, ed_ArticleAxeCsv.Text, ed_ArticleCollectionCsv.Text,
        ed_CouleurCsv.Text, ed_CodeBarreCsv.Text, ed_PrixAchatCsv.Text,
        ed_PrixVenteCsv.Text, ed_PrixVenteIndicatifCsv.Text,
        ed_ModeleDeprecieCsv.Text, ed_FouContactCsv.Text, ed_FouConditionCsv.Text,
        ed_ArtidealCsv.Text,ed_OcTeteCsv.Text,ed_OcMagCsv.Text,
        ed_OcLignesCsv.Text, ed_OcDetailCsv.Text);
    end;

    if chk_ChargementHistoriques.Checked then
    begin
      bobHistorique := true;
      obHistorique := THistorique.Create( True,
                                          chk_ChargementHistoriques.Checked,
                                          false,
                                          false,
                                          Chk_Correction_TVA.Checked);
      obHistorique.noBackup := chk_noBackup.Checked;
      obHistorique.OnTerminate := OnTerminateobHistorique;
      obHistorique.InitThread(Chk_RetirePtVirgHis.Checked, ed_CaisseCsv.Text,
        ed_ReceptionCsv.Text, ed_ConsodivCsv.Text, ed_TransfertCsv.Text,
        ed_CommandesCsv.Text, ed_RetourFouCsv.Text, ed_AvoirCsv.Text,
        ed_BonLivraisonCsv.Text, ed_BonLivraisonLCsv.Text, ed_BonLivraisonHistoCsv.Text);
    end;

    if chk_ChargementBonsRapprochement.Checked then
    begin
      bobBonRapprochement := True;
      obBonRapprochement := TBonRapprochement.Create(True, chk_ChargementBonsRapprochement.Checked);
      obBonRapprochement.OnTerminate := OnTerminateobBonRapprochement;
      obBonRapprochement.InitThread(Chk_RetirePtVirgBonR.Checked, EditBonRapprochementCsv.Text, EditBonRapprochementLienCsv.Text, EditBonRapprochementTVACsv.Text, EditBonRapprochementLigneReceptionCsv.Text, EditBonRapprochementLigneRetourCsv.Text);
    end;

    if chk_ChargementAtelier.Checked then
    begin
      bobAtelier := True;
      obAtelier := TAtelier.Create(True, chk_ChargementAtelier.Checked);
      obAtelier.OnTerminate := OnTerminateobAtelier;
      obAtelier.InitThread(Chk_RetirePtVirgAtelier.Checked, EditSavTauxHCsv.Text, EditSavForfaitCsv.Text, EditSavForfaitLCsv.Text,
        EditSavPt1Csv.Text, EditSavPt2Csv.Text, EditSavTypMatCsv.Text, EditSavTypeCsv.Text, EditSavMatCsv.Text, EditSavCbCsv.Text,
        EditSavFicheeCsv.Text, EditSavFicheLCsv.Text, EditSavFicheArtCsv.Text);
    end;

    Frm_Load.DoInit(EtatLanceCli, EtatLanceArt, EtatLanceHisto, EtatLanceBonR, EtatLanceAtelier);
    Frm_Load.Show;
    Frm_Load.OkFermer := false;
    Frm_Main.Enabled := False;
    Application.ProcessMessages;

    if chk_ChargementClients.Checked then
    begin
      EtatLanceCli := 1;   // en cours
      obClient.Start;
    end;

    if (EtatLanceCli=-1) and chk_ChargementArticle.Checked then
    begin
      EtatLanceArt := 1;   // en cours
      obRefArticle.Start;
    end;

    if (EtatLanceCli=-1) and (EtatLanceArt=-1) and chk_ChargementHistoriques.Checked then
    begin
      EtatLanceHisto := 1;   // en cours
      obHistorique.Start;
    end;

    if(EtatLanceCli = -1) and (EtatLanceArt = -1) and (EtatLanceHisto = -1) and chk_ChargementBonsRapprochement.Checked then
    begin
      EtatLanceBonR := 1;   // En cours.
      obBonRapprochement.Start;
    end;

    if(EtatLanceCli = -1) and (EtatLanceArt = -1) and (EtatLanceHisto = -1) and (EtatLanceBonR = -1) and chk_ChargementAtelier.Checked then
    begin
      EtatLanceAtelier := 1;   // En cours.
      obAtelier.Start;
    end;
  except
    on E:Exception do
    begin
      MessageDlg('erreur post control :' + e.Message, mterror, [Mbok], 0);
      exit;
    end;
  end;
end;

procedure TFrm_Main.btn_LienClientsCsvClick(Sender: TObject);
begin
  ed_LienClientsCsv.Text := GetPathCsv('Choix du fichier LienClient.csv');
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.chk_ChargementClientsClick(Sender: TObject);
var
  bEtat : Boolean;
begin
  bEtat := chk_ChargementClients.Checked;
  SetEtatFonction(1,bEtat);
end;

procedure TFrm_Main.Cb_MagasinChange(Sender: TObject);
begin
  if cb_Magasin.ItemIndex <> -1 then
  begin
    Dm_Main.MagID := Integer(cb_Magasin.Items.Objects[cb_Magasin.ItemIndex]);
    Dm_Main.MagCodeAdh := ListeCodeAdh[cb_Magasin.ItemIndex];
  end;
end;

procedure TFrm_Main.Cb_ProvenanceChange(Sender: TObject);
begin
  // Récupération de la provenance de l'import
  Dm_Main.OkDeGinkoia := GetProvenance = ipGinkoia; // rétrocompatibilité
  Provenance := GetProvenance;
end;

procedure TFrm_Main.Cb_TarVenteChange(Sender: TObject);
begin
  if cb_TarVente.ItemIndex <> -1 then
  begin
    Dm_Main.TvtID := Integer(cb_TarVente.Items.Objects[cb_TarVente.ItemIndex]);
  end;
end;

procedure TFrm_Main.chk_ChargementArticleClick(Sender: TObject);
var
  bEtat : Boolean;
begin
  bEtat := chk_ChargementArticle.Checked;
  SetEtatFonction(2,bEtat);
end;

procedure TFrm_Main.chk_ChargementBonsRapprochementClick(Sender: TObject);
var
  bEtat: Boolean;
begin
  bEtat := chk_ChargementBonsRapprochement.Checked;
  SetEtatFonction(4, bEtat);

  if bEtat and (not chk_ChargementHistoriques.Checked) then
    MessageDlg('Attention :  l''import des bons de rapprochement nécessite l''import des réceptions et des retours fournisseur !', mtWarning, [mbok], 0);
end;

procedure TFrm_Main.chk_ChargementAtelierClick(Sender: TObject);
var
  bEtat: Boolean;
begin
  bEtat := chk_ChargementAtelier.Checked;
  SetEtatFonction(5, bEtat);

  if bEtat and ((not chk_ChargementClients.Checked) or (not chk_ChargementArticle.Checked)) then
    MessageDlg('Attention :  l''import de l''Atelier nécessite l''import des clients et des articles !', mtWarning, [mbok], 0);
end;

procedure TFrm_Main.chk_ChargementHistoriquesClick(Sender: TObject);
var
  bEtat : Boolean;
begin
  bEtat := chk_ChargementHistoriques.Checked;
  SetEtatFonction(3,bEtat);
end;

procedure TFrm_Main.Chk_PasDeRecalStkClick(Sender: TObject);
begin
  Dm_Main.NePasFaireLeStock := Chk_PasDeRecalStk.Checked;
  if Chk_PasDeRecalStk.Checked then
    MessageDlg('Le programme ne calculera pas le stock et s''arretera automatiquement après la transpo',
         mtWarning, [mbok],0);
end;

procedure TFrm_Main.Chk_SecondImportClick(Sender: TObject);
begin
  Dm_Main.SecondImport := Chk_SecondImport.Checked;
  if Chk_SecondImport.Checked then
    MessageDlg('Le programme importera les prix de vente, dans le tarif du magasin.',
         mtWarning, [mbok],0);
end;

procedure TFrm_Main.Chk_TousMagClick(Sender: TObject);
begin
  Dm_Main.OkTousMag := Chk_TousMag.Checked;
end;

procedure TFrm_Main.DoRepClient(ADir: string);
begin
  ed_ClientsCsv.Text      := ADir + Clients_CSV;
  ed_LienClientsCsv.Text  := ADir + LienClients_CSV;
  ed_ComptesCsv.Text      := ADir + Comptes_CSV;
  ed_FideliteCsv.Text     := ADir + Fidelite_CSV;
  ed_BonAchatsCsv.Text    := ADir + BonAchats_CSV;
end;

procedure TFrm_Main.DoRepArticle(ADir: string);
begin
  ed_FournCsv.Text              := ADir + Fourn_CSV;
  ed_MarqueCsv.Text             := ADir + Marque_CSV;
  ed_FoumarqueCsv.Text          := ADir + Foumarque_CSV;
  ed_GrTailleCsv.Text           := ADir + GrTaille_CSV;
  ed_GrTailleLigCsv.Text        := ADir + GrTailleLig_CSV;
  ed_AxeCsv.Text                := ADir + Axe_CSV;
  ed_DomaineCommercialCsv.Text  := ADir + DomaineCommercial_CSV;
  ed_AxeNiveau1Csv.Text         := ADir + AxeNiveau1_CSV;
  ed_AxeNiveau2Csv.Text         := ADir + AxeNiveau2_CSV;
  ed_AxeNiveau3Csv.Text         := ADir + AxeNiveau3_CSV;
  ed_AxeNiveau4Csv.Text         := ADir + AxeNiveau4_CSV;
  ed_CollectionCsv.Text         := ADir + Collection_CSV;
  ed_GenreCsv.Text              := ADir + Genre_CSV;
  ed_ArticleCsv.Text            := ADir + Article_CSV;
  ed_ArticleAxeCsv.Text         := ADir + ArticleAxe_CSV;
  ed_ArticleCollectionCsv.Text  := ADir + ArticleCollection_CSV;
  ed_CouleurCsv.Text            := ADir + Couleur_CSV;
  ed_CodeBarreCsv.Text          := ADir + CodeBarre_CSV;
  ed_PrixAchatCsv.Text          := ADir + Prix_Achat_CSV;
  ed_PrixVenteCsv.Text          := ADir + Prix_Vente_CSV;
  ed_PrixVenteIndicatifCsv.Text := ADir + Prix_Vente_Indicatif_CSV;
  ed_ModeleDeprecieCsv.Text     := ADir + ModeleDeprecie_CSV;
  ed_FouContactCsv.Text         := ADir + FouContact_CSV;
  ed_FouConditionCsv.Text       := ADir + FouCondition_CSV;
  ed_ArtidealCsv.Text           := ADir + ArtIdeal_CSV;
  ed_OcTeteCsv.Text             := ADir + OcTete_CSV;
  ed_OcMagCsv.Text              := ADir + OcMag_CSV;
  ed_OcLignesCsv.Text           := ADir + OcLignes_CSV;
  ed_OcDetailCsv.Text           := ADir + OcDetail_CSV;
end;

procedure TFrm_Main.DoRepHisto(ADir: string);
begin
  ed_CaisseCsv.Text       := ADir + Caisse_CSV;
  ed_ReceptionCsv.Text    := ADir + Reception_CSV;
  ed_ConsodivCsv.Text     := ADir + Consodiv_CSV;
  ed_TransfertCsv.Text    := ADir + Transfert_CSV;
  ed_CommandesCsv.Text    := ADir + Commandes_CSV;
  ed_RetourFouCsv.Text    := ADir + RetourFou_CSV;
  ed_AvoirCsv.Text        := ADir + Avoir_CSV;
  ed_BonLivraisonCsv.Text := ADir + BonLivraison_CSV;
  ed_BonLivraisonLCsv.Text  := ADir + BonLivraisonL_CSV;
  ed_BonLivraisonHistoCsv.Text  := ADir + BonLivraisonHisto_CSV;
end;

procedure TFrm_Main.DoRepReprise(ADir: string);
begin
  ed_RepriseCaisse.Text := ADir + RepriseCaisse_CSV;
  ed_RepriseClient.Text := ADir + RepriseClients_CSV;
  ed_RepriseCompte.Text := ADir + RepriseComptes_CSV;
  ed_RepriseAvoir.Text  := ADir + RepriseAvoir_CSV;
  ed_RepriseBonLivraison.Text       := ADir + RepriseBonLivraison_CSV;
  ed_RepriseBonLivraisonL.Text      := ADir + RepriseBonLivraisonL_CSV;
  ed_RepriseBonLivraisonHisto.Text  := ADir + RepriseBonLivraisonHisto_CSV;
end;

procedure TFrm_Main.DoRepBonRapprochement(ADir: String);
begin
  EditBonRapprochementCsv.Text := ADir + BonRapprochement_CSV;
  EditBonRapprochementLienCsv.Text := ADir + BonRapprochementLien_CSV;
  EditBonRapprochementTVACsv.Text := ADir + BonRapprochementTVA_CSV;
  EditBonRapprochementLigneReceptionCsv.Text := ADir + BonRapprochementLigneReception_CSV;
  EditBonRapprochementLigneRetourCsv.Text := ADir + BonRapprochementLigneRetour_CSV;
end;

procedure TFrm_Main.DoRepAtelier(ADir: String);
begin
  EditSavTauxHCsv.Text := ADir + SavTauxH_CSV;
  EditSavForfaitCsv.Text := ADir + SavForfait_CSV;
  EditSavForfaitLCsv.Text := ADir + SavForfaitL_CSV;
  EditSavPt1Csv.Text := ADir + SavPt1_CSV;
  EditSavPt2Csv.Text := ADir + SavPt2_CSV;
  EditSavTypMatCsv.Text := ADir + SavTypMat_CSV;
  EditSavTypeCsv.Text := ADir + SavType_CSV;
  EditSavMatCsv.Text := ADir + SavMat_CSV;
  EditSavCbCsv.Text := ADir + SavCb_CSV;
  EditSavFicheeCsv.Text := ADir + SavFichee_CSV;
  EditSavFicheLCsv.Text := ADir + SavFicheL_CSV;
  EditSavFicheArtCsv.Text := ADir + SavFicheArt_CSV;
end;

procedure TFrm_Main.Ed_DossierKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['\', '/', ':', '*', '?', '"', '<', '>',  '|']) then
    Key := chr(7);
end;

procedure TFrm_Main.ed_Change(Sender: TObject);
begin
  VerifPath(Sender As TEdit);
end;

function TFrm_Main.GetDirCsv: string;
var
  ActualDir: String;
begin
  ActualDir := 'D:\MigreData\';
  if SelectDirectory('Choix du répertoire', '', ActualDir) then
  begin
    if ActualDir <> '' then
    begin
      if RightStr(ActualDir,1) <> '\' then
      begin
        ActualDir := ActualDir + '\';
      end;
    end;
  end;
  Result := ActualDir;
end;

function TFrm_Main.GetPathCsv(aTitle: string): string;
var
  odTemp  : TOpenDialog;
begin
  Result := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier CSV Microsoft Office Excel|*.csv';
    odTemp.InitialDir := ed_ClientsPath.Text;
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    odTemp.Title := aTitle;
    odTemp.Execute;
    if odTemp.FileName <> '' then
      Result := odTemp.FileName;
  finally
    odTemp.Free;
  end;
end;

function TFrm_Main.GetProvenance: TImportProvenance;
begin
  Assert( Cb_Provenance.ItemIndex >= 0, Error_ProvenanceIsEmpty );
  Assert( Cb_Provenance.ItemIndex <= Ord ( High( TImportProvenance ) ), Format( Error_ProvenanceUncompleted, [ Cb_Provenance.Text ] ) );
  Result := TImportProvenance( Cb_Provenance.ItemIndex );
end;

function TFrm_Main.GetVerrifGenTrigger: Boolean;
begin
  if not Chk_GentriggerDiff.Checked then
  begin
    Dm_Main.Que_GENTRIGGER.Open;
    if Dm_Main.Que_GENTRIGGER.IsEmpty then
      Result := True      //Si la query est vide, aucun stock à recalculer.
    else
      Result := False;    //Stock à recalculer.
    Dm_Main.Que_GENTRIGGER.Close;
  end
  else
     Result := True;
end;

procedure TFrm_Main.SetEtatFonction(aFonction: Integer; aEtat: Boolean);
begin
  case aFonction of
    1:
      begin     //Pour les clients
        lbl_ClientsPath.Enabled := aEtat;
        ed_ClientsPath.Enabled  := aEtat;
        btn_ClientsPath.Enabled := aEtat;

        lbl_ClientsCsv.Enabled  := aEtat;
        ed_ClientsCsv.Enabled   := aEtat;
        btn_ClientsCsv.Enabled  := aEtat;

        lbl_LienClientsCsv.Enabled  := aEtat;
        ed_LienClientsCsv.Enabled   := aEtat;
        btn_LienClientsCsv.Enabled  := aEtat;

        lbl_ComptesCsv.Enabled  := aEtat;
        ed_ComptesCsv.Enabled   := aEtat;
        btn_ComptesCsv.Enabled  := aEtat;

        lbl_FideliteCsv.Enabled   := aEtat;
        ed_FideliteCsv.Enabled    := aEtat;
        btn_FideliteCsv.Enabled   := aEtat;

        lbl_BonAchatsCsv.Enabled  := aEtat;
        ed_BonAchatsCsv.Enabled   := aEtat;
        btn_BonAchatsCsv.Enabled  := aEtat;
      end;

    2:
      begin     //Pour les référence article
        lbl_ArticlePath.Enabled           := aEtat;
        ed_ArticlePath.Enabled            := aEtat;
        btn_ArticlePath.Enabled           := aEtat;

        lbl_FournCsv.Enabled              := aEtat;
        ed_FournCsv.Enabled               := aEtat;
        btn_FournCsv.Enabled              := aEtat;

        lbl_MarqueCsv.Enabled             := aEtat;
        ed_MarqueCsv.Enabled              := aEtat;
        btn_MarqueCsv.Enabled             := aEtat;

        lbl_FoumarqueCsv.Enabled          := aEtat;
        ed_FoumarqueCsv.Enabled           := aEtat;
        btn_FoumarqueCsv.Enabled          := aEtat;

        lbl_GrTailleCsv.Enabled           := aEtat;
        ed_GrTailleCsv.Enabled            := aEtat;
        btn_GrTailleCsv.Enabled           := aEtat;

        lbl_GrTailleLigCsv.Enabled        := aEtat;
        ed_GrTailleLigCsv.Enabled         := aEtat;
        btn_GrTailleLigCsv.Enabled        := aEtat;

        lbl_DomaineCommercialCsv.Enabled  := aEtat;
        ed_DomaineCommercialCsv.Enabled   := aEtat;
        btn_DomaineCommercialCsv.Enabled  := aEtat;

        lbl_AxeCsv.Enabled                := aEtat;
        ed_AxeCsv.Enabled                 := aEtat;
        btn_AxeCsv.Enabled                := aEtat;

        lbl_AxeNiveau1Csv.Enabled         := aEtat;
        ed_AxeNiveau1Csv.Enabled          := aEtat;
        btn_AxeNiveau1Csv.Enabled         := aEtat;

        lbl_AxeNiveau2Csv.Enabled         := aEtat;
        ed_AxeNiveau2Csv.Enabled          := aEtat;
        btn_AxeNiveau2Csv.Enabled         := aEtat;

        lbl_AxeNiveau3Csv.Enabled         := aEtat;
        ed_AxeNiveau3Csv.Enabled          := aEtat;
        btn_AxeNiveau3Csv.Enabled         := aEtat;

        lbl_AxeNiveau4Csv.Enabled         := aEtat;
        ed_AxeNiveau4Csv.Enabled          := aEtat;
        btn_AxeNiveau4Csv.Enabled         := aEtat;

        lbl_CollectionCsv.Enabled         := aEtat;
        ed_CollectionCsv.Enabled          := aEtat;
        btn_CollectionCsv.Enabled         := aEtat;

        lbl_GenreCsv.Enabled              := aEtat;
        ed_GenreCsv.Enabled               := aEtat;
        btn_GenreCsv.Enabled              := aEtat;

        lbl_ArticleCsv.Enabled            := aEtat;
        ed_ArticleCsv.Enabled             := aEtat;
        btn_ArticleCsv.Enabled            := aEtat;

        lbl_ArticleAxeCsv.Enabled         := aEtat;
        ed_ArticleAxeCsv.Enabled          := aEtat;
        btn_ArticleAxeCsv.Enabled         := aEtat;

        lbl_ArticleCollectionCsv.Enabled  := aEtat;
        ed_ArticleCollectionCsv.Enabled   := aEtat;
        btn_ArticleCollectionCsv.Enabled  := aEtat;

        lbl_CouleurCsv.Enabled            := aEtat;
        ed_CouleurCsv.Enabled             := aEtat;
        btn_CouleurCsv.Enabled            := aEtat;

        lbl_CodeBarreCsv.Enabled          := aEtat;
        ed_CodeBarreCsv.Enabled           := aEtat;
        btn_CodeBarreCsv.Enabled          := aEtat;

        lbl_PrixAchatCsv.Enabled          := aEtat;
        ed_PrixAchatCsv.Enabled           := aEtat;
        btn_PrixAchatCsv.Enabled          := aEtat;

        lbl_PrixVenteCsv.Enabled          := aEtat;
        ed_PrixVenteCsv.Enabled           := aEtat;
        btn_PrixVenteCsv.Enabled          := aEtat;

        lbl_PrixVenteIndicatifCsv.Enabled := aEtat;
        ed_PrixVenteIndicatifCsv.Enabled  := aEtat;
        Btn_PrixVenteIndicatifCsv.Enabled := aEtat;

        lbl_ModeleDeprecieCsv.Enabled     := aEtat;
        ed_ModeleDeprecieCsv.Enabled      := aEtat;
        btn_ModeleDeprecieCsv.Enabled     := aEtat;

        lbl_FouContactCsv.Enabled         := aEtat;
        ed_FouContactCsv.Enabled          := aEtat;
        btn_FouContactCsv.Enabled         := aEtat;

        lbl_FouConditionCsv.Enabled       := aEtat;
        ed_FouConditionCsv.Enabled        := aEtat;
        btn_FouConditionCsv.Enabled       := aEtat;

        lbl_ArtidealCsv.Enabled           := aEtat;
        ed_ArtidealCsv.Enabled            := aEtat;
        btn_ArtidealCsv.Enabled           := aEtat;

        lbl_OcTeteCsv.Enabled             := aEtat;
        ed_OcTeteCsv.Enabled              := aEtat;
        btn_OcTeteCsv.Enabled             := aEtat;

        lbl_OcMagCsv.Enabled              := aEtat;
        ed_OcMagCsv.Enabled               := aEtat;
        btn_OcMagCsv.Enabled              := aEtat;

        lbl_OcLignesCsv.Enabled           := aEtat;
        ed_OcLignesCsv.Enabled            := aEtat;
        btn_OcLignesCsv.Enabled           := aEtat;

        lbl_OcDetailCsv.Enabled           := aEtat;
        ed_OcDetailCsv.Enabled            := aEtat;
        btn_OcDetailCsv.Enabled           := aEtat;
      end;

    3:
      begin     //Pour l'historique
        lbl_HistoriquesPath.Enabled := aEtat;
        ed_HistoriquesPath.Enabled  := aEtat;
        btn_HistoriquesPath.Enabled := aEtat;

        lbl_CaisseCsv.Enabled       := aEtat;
        ed_CaisseCsv.Enabled        := aEtat;
        btn_CaisseCsv.Enabled       := aEtat;

        lbl_ReceptionCsv.Enabled    := aEtat;
        ed_ReceptionCsv.Enabled     := aEtat;
        btn_ReceptionCsv.Enabled    := aEtat;

        lbl_ConsodivCsv.Enabled     := aEtat;
        ed_ConsodivCsv.Enabled      := aEtat;
        btn_ConsodivCsv.Enabled     := aEtat;

        lbl_TransfertCsv.Enabled    := aEtat;
        ed_TransfertCsv.Enabled     := aEtat;
        btn_TransfertCsv.Enabled    := aEtat;

        lbl_CommandesCsv.Enabled    := aEtat;
        ed_CommandesCsv.Enabled     := aEtat;
        btn_CommandesCsv.Enabled    := aEtat;

        lbl_RetourFouCsv.Enabled    := aEtat;
        ed_RetourFouCsv.Enabled     := aEtat;
        btn_RetourFouCsv.Enabled    := aEtat;

        lbl_AvoirCsv.Enabled        := aEtat;
        ed_AvoirCsv.Enabled         := aEtat;
        btn_AvoirCsv.Enabled        := aEtat;

        lbl_BonLivraison.Enabled    := aEtat;
        ed_BonLivraisonCsv.Enabled  := aEtat;
        btn_BonLivraisonCsv.Enabled := aEtat;

        lbl_BonLivraisonL.Enabled     := aEtat;
        ed_BonLivraisonLCsv.Enabled   := aEtat;
        btn_BonLivraisonLCsv.Enabled  := aEtat;

        lbl_BonLivraisonHisto.Enabled     := aEtat;
        ed_BonLivraisonHistoCsv.Enabled   := aEtat;
        btn_BonLivraisonHistoCsv.Enabled  := aEtat;
      end;

    4:
      begin      // Bon de rapprochement.
        LabelCheminBonRapprochement.Enabled := aEtat;
        EditCheminBonRapprochement.Enabled := aEtat;
        Btn_CheminBonRapprochement.Enabled := aEtat;

        LabelBonRapprochementCsv.Enabled := aEtat;
        EditBonRapprochementCsv.Enabled := aEtat;
        Btn_BonRapprochementCsv.Enabled := aEtat;

        LabelBonRapprochementLienCsv.Enabled := aEtat;
        EditBonRapprochementLienCsv.Enabled := aEtat;
        Btn_BonRapprochementLienCsv.Enabled := aEtat;

        LabelBonRapprochementTVACsv.Enabled := aEtat;
        EditBonRapprochementTVACsv.Enabled := aEtat;
        Btn_BonRapprochementTVACsv.Enabled := aEtat;

        LabelBonRapprochementLigneReceptionCsv.Enabled := aEtat;
        EditBonRapprochementLigneReceptionCsv.Enabled := aEtat;
        Btn_BonRapprochementLigneReceptionCsv.Enabled := aEtat;

        LabelBonRapprochementLigneRetourCsv.Enabled := aEtat;
        EditBonRapprochementLigneRetourCsv.Enabled := aEtat;
        Btn_BonRapprochementLigneRetourCsv.Enabled := aEtat;
      end;

    5:
      begin     // Atelier
        LabelCheminAtelier.Enabled := aEtat;
        EditCheminAtelier.Enabled := aEtat;
        Btn_CheminAtelier.Enabled := aEtat;

        LabelSavTauxHCsv.Enabled := aEtat;
        EditSavTauxHCsv.Enabled := aEtat;
        Btn_SavTauxHCsv.Enabled := aEtat;

        LabelSavForfaitCsv.Enabled := aEtat;
        EditSavForfaitCsv.Enabled := aEtat;
        Btn_SavForfaitCsv.Enabled := aEtat;

        LabelSavForfaitLCsv.Enabled := aEtat;
        EditSavForfaitLCsv.Enabled := aEtat;
        Btn_SavForfaitLCsv.Enabled := aEtat;

        LabelSavPt1Csv.Enabled := aEtat;
        EditSavPt1Csv.Enabled := aEtat;
        Btn_SavPt1Csv.Enabled := aEtat;

        LabelSavPt2Csv.Enabled := aEtat;
        EditSavPt2Csv.Enabled := aEtat;
        Btn_SavPt2Csv.Enabled := aEtat;

        LabelSavTypMatCsv.Enabled := aEtat;
        EditSavTypMatCsv.Enabled := aEtat;
        Btn_SavTypMatCsv.Enabled := aEtat;

        LabelSavTypeCsv.Enabled := aEtat;
        EditSavTypeCsv.Enabled := aEtat;
        Btn_SavTypeCsv.Enabled := aEtat;

        LabelSavMatCsv.Enabled := aEtat;
        EditSavMatCsv.Enabled := aEtat;
        Btn_SavMatCsv.Enabled := aEtat;

        LabelSavCbCsv.Enabled := aEtat;
        EditSavCbCsv.Enabled := aEtat;
        Btn_SavCbCsv.Enabled := aEtat;

        LabelSavFicheeCsv.Enabled := aEtat;
        EditSavFicheeCsv.Enabled := aEtat;
        Btn_SavFicheeCsv.Enabled := aEtat;

        LabelSavFicheLCsv.Enabled := aEtat;
        EditSavFicheLCsv.Enabled := aEtat;
        Btn_SavFicheLCsv.Enabled := aEtat;

        LabelSavFicheArtCsv.Enabled := aEtat;
        EditSavFicheArtCsv.Enabled := aEtat;
        Btn_SavFicheArtCsv.Enabled := aEtat;
      end;
  end;
end;

procedure TFrm_Main.SetProvenance(const Value: TImportProvenance);
begin
  Assert( Ord( Value ) < Cb_Provenance.Items.Count, Error_ProvenanceIsEmpty );
  Assert( Cb_Provenance.ItemIndex <= Ord ( High( TImportProvenance ) ), Format( Error_ProvenanceUncompleted, [ Cb_Provenance.Text ] ) );

  Cb_Provenance.ItemIndex := Ord( Value );
  Dm_Main.Provenance := Value;
  UpdateUI( Value );
end;

procedure TFrm_Main.UpdateUI(const Provenance: TImportProvenance);
begin
  try
    Application.MainForm.Enabled := False;
    if Provenance = ipOldGoSport then
    begin
      vgPageControlRv1.ActivePage := Tab_Historiques;
    end;

    Tab_Clients.TabVisible                := Provenance <> ipOldGoSport;
    Tab_RefArticle.TabVisible             := Provenance <> ipOldGoSport;
    Tab_Reprise.TabVisible                := Provenance <> ipOldGoSport;
    Tab_BonRapprochement.TabVisible       := ((Provenance <> ipOldGoSport) and (Provenance <> ipGoSport));
    Tab_Atelier.TabVisible                := ((Provenance <> ipOldGoSport) and (Provenance <> ipGoSport));
    Lbl_GrpTarif.Visible                  := Provenance <> ipOldGoSport;
    Lbl_Magasin.Visible                   := Provenance <> ipOldGoSport;
    Cb_Magasin.Visible                    := Provenance <> ipOldGoSport;
    Cb_TarVente.Visible                   := Provenance <> ipOldGoSport;
    Chk_TousMag.Visible                   := Provenance <> ipOldGoSport;
    Chk_SecondImport.Visible              := Provenance <> ipOldGoSport;
    Chk_Correction_TVA.Visible            := Provenance <> ipOldGoSport;
    Chk_PasDeRecalStk.Visible             := Provenance <> ipOldGoSport;

    lbl_ReceptionCsv.Visible              := Provenance <> ipOldGoSport;
    ed_ReceptionCsv.Visible               := Provenance <> ipOldGoSport;
    btn_ReceptionCsv.Visible              := Provenance <> ipOldGoSport;
    btn_CReceptionCsv.Visible             := Provenance <> ipOldGoSport;
    lbl_TransfertCsv.Visible              := Provenance <> ipOldGoSport;
    ed_TransfertCsv.Visible               := Provenance <> ipOldGoSport;
    btn_TransfertCsv.Visible              := Provenance <> ipOldGoSport;
    btn_CTransfertCsv.Visible             := Provenance <> ipOldGoSport;
    lbl_CommandesCsv.Visible              := Provenance <> ipOldGoSport;
    ed_CommandesCsv.Visible               := Provenance <> ipOldGoSport;
    btn_CommandesCsv.Visible              := Provenance <> ipOldGoSport;
    btn_CCommandesCsv.Visible             := Provenance <> ipOldGoSport;
    lbl_RetourFouCsv.Visible              := Provenance <> ipOldGoSport;
    ed_RetourFouCsv.Visible               := Provenance <> ipOldGoSport;
    btn_RetourFouCsv.Visible              := Provenance <> ipOldGoSport;
    btn_CRetourFouCsv.Visible             := Provenance <> ipOldGoSport;
    lbl_AvoirCsv.Visible                  := Provenance <> ipOldGoSport;
    ed_AvoirCsv.Visible                   := Provenance <> ipOldGoSport;
    btn_AvoirCsv.Visible                  := Provenance <> ipOldGoSport;
    btn_CAvoirCsv.Visible                 := Provenance <> ipOldGoSport;
    lbl_BonLivraison.Visible              := Provenance <> ipOldGoSport;
    ed_BonLivraisonCsv.Visible            := Provenance <> ipOldGoSport;
    btn_BonLivraisonCsv.Visible           := Provenance <> ipOldGoSport;
    btn_CBonLivraisonCsv.Visible          := Provenance <> ipOldGoSport;
    lbl_BonLivraisonL.Visible             := Provenance <> ipOldGoSport;
    ed_BonLivraisonLCsv.Visible           := Provenance <> ipOldGoSport;
    btn_BonLivraisonLCsv.Visible          := Provenance <> ipOldGoSport;
    btn_CBonLivraisonLCsv.Visible         := Provenance <> ipOldGoSport;
    lbl_BonLivraisonHisto.Visible         := Provenance <> ipOldGoSport;
    ed_BonLivraisonHistoCsv.Visible       := Provenance <> ipOldGoSport;
    btn_BonLivraisonHistoCsv.Visible      := Provenance <> ipOldGoSport;
    btn_CBonLivraisonHistoCsv.Visible     := Provenance <> ipOldGoSport;

//    Btn_PtVirg.Visible                    := Provenance <> ipOldGoSport;
//    Btn_Mail.Visible                      := Provenance <> ipOldGoSport;
//    Btn_Importer.Visible                  := Provenance <> ipOldGoSport;
  finally
    Application.MainForm.Enabled := True;
  end;
end;

function TFrm_Main.VerifPath(ed_Path: TEdit): Boolean;
begin
  if not(FileExists(ed_Path.Text)) then
  begin
    ed_Path.Color := TColor(FileNotExist);
    result := False;
  end
  else
  begin
    ed_Path.Color := TColor(FileExist);
    result := True;
  end;
end;

procedure TFrm_Main.Btn_CheminBonRapprochementClick(Sender: TObject);
var
  sDir: String;
begin
  sDir := GetDirCsv;
  if sDir <> '' then
  begin
    EditCheminBonRapprochement.Text := sDir;
    DoRepBonRapprochement(sDir);

    // integration des clients ?
    if not(chk_ChargementClients.Checked)
            and (MessageDlg('Intégrer les clients du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementClients.Checked := true;
      ed_ClientsPath.Text := sDir;
      DoRepClient(sDir);
    end;

    // integration des articles ?
    if not(chk_ChargementArticle.Checked)
            and (MessageDlg('Intégrer les articles du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementArticle.Checked := true;
      ed_ArticlePath.Text := sDir;
      DoRepArticle(sDir);
    end;
    // integration des historiques ?
    if not(chk_ChargementHistoriques.Checked)
            and (MessageDlg('Intégrer l''historique du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementHistoriques.Checked := true;
      ed_HistoriquesPath.Text := sDir;
      DoRepHisto(sDir);
    end;

    // integration ateler ?
    if not(chk_ChargementAtelier.Checked)
            and (MessageDlg('Intégrer l''atelier du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementAtelier.Checked := true;
      EditCheminAtelier.Text := sDir;
      DoRepAtelier(sDir);
    end;
  end;
end;

procedure TFrm_Main.Btn_BonRapprochementCsvClick(Sender: TObject);
begin
  EditBonRapprochementCsv.Text := GetPathCsv('Choix du fichier ' + BonRapprochement_CSV);
end;

procedure TFrm_Main.Btn_CBonRapprochementCsvClick(Sender: TObject);
begin
  CreerFile(EditBonRapprochementCsv.Text);
  VerifPath(EditBonRapprochementCsv);
end;

procedure TFrm_Main.Btn_BonRapprochementLienCsvClick(Sender: TObject);
begin
  EditBonRapprochementLienCsv.Text := GetPathCsv('Choix du fichier ' + BonRapprochementLien_CSV);
end;

procedure TFrm_Main.Btn_CBonRapprochementLienCsvClick(Sender: TObject);
begin
  CreerFile(EditBonRapprochementLienCsv.Text);
  VerifPath(EditBonRapprochementLienCsv);
end;

procedure TFrm_Main.Btn_BonRapprochementTVACsvClick(Sender: TObject);
begin
  EditBonRapprochementTVACsv.Text := GetPathCsv('Choix du fichier ' + BonRapprochementTVA_CSV);
end;

procedure TFrm_Main.Btn_CBonRapprochementTVACsvClick(Sender: TObject);
begin
  CreerFile(EditBonRapprochementTVACsv.Text);
  VerifPath(EditBonRapprochementTVACsv);
end;

procedure TFrm_Main.Btn_BonRapprochementLigneReceptionCsvClick(Sender: TObject);
begin
  EditBonRapprochementLigneReceptionCsv.Text := GetPathCsv('Choix du fichier ' + BonRapprochementLigneReception_CSV);
end;

procedure TFrm_Main.Btn_CBonRapprochementLigneReceptionCsvClick(Sender: TObject);
begin
  CreerFile(EditBonRapprochementLigneReceptionCsv.Text);
  VerifPath(EditBonRapprochementLigneReceptionCsv);
end;

procedure TFrm_Main.Btn_BonRapprochementLigneRetourCsvClick(Sender: TObject);
begin
  EditBonRapprochementLigneRetourCsv.Text := GetPathCsv('Choix du fichier ' + BonRapprochementLigneRetour_CSV);
end;

procedure TFrm_Main.Btn_CBonRapprochementLigneRetourCsvClick(Sender: TObject);
begin
  CreerFile(EditBonRapprochementLigneRetourCsv.Text);
  VerifPath(EditBonRapprochementLigneRetourCsv);
end;

procedure TFrm_Main.Btn_CheminAtelierClick(Sender: TObject);
var
  sDir: String;
begin
  sDir := GetDirCsv;
  if sDir <> '' then
  begin
    EditCheminAtelier.Text := sDir;
    DoRepAtelier(sDir);

    // integration des clients ?
    if not(chk_ChargementClients.Checked)
            and (MessageDlg('Intégrer les clients du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementClients.Checked := true;
      ed_ClientsPath.Text := sDir;
      DoRepClient(sDir);
    end;

    // integration des articles ?
    if not(chk_ChargementArticle.Checked)
            and (MessageDlg('Intégrer les articles du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementArticle.Checked := true;
      ed_ArticlePath.Text := sDir;
      DoRepArticle(sDir);
    end;
    // integration des historiques ?
    if not(chk_ChargementHistoriques.Checked)
            and (MessageDlg('Intégrer l''historique du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementHistoriques.Checked := true;
      ed_HistoriquesPath.Text := sDir;
      DoRepHisto(sDir);
    end;

    // integration bons rapprochement ?
    if not(chk_ChargementBonsRapprochement.Checked)
            and (MessageDlg('Intégrer les bons de rappro du même répertoire ?', mtconfirmation, [mbyes, mbno], 0)=mryes) then
    begin
      chk_ChargementBonsRapprochement.Checked := true;
      EditCheminBonRapprochement.Text := sDir;
      DoRepBonRapprochement(sDir);
    end;
  end;
end;

procedure TFrm_Main.Btn_SavTauxHCsvClick(Sender: TObject);
begin
  EditSavTauxHCsv.Text := GetPathCsv('Choix du fichier ' + SavTauxH_CSV);
end;

procedure TFrm_Main.Btn_CSavTauxHCsvClick(Sender: TObject);
begin
  CreerFile(EditSavTauxHCsv.Text);
  VerifPath(EditSavTauxHCsv);
end;


procedure TFrm_Main.Btn_SavForfaitCsvClick(Sender: TObject);
begin
  EditSavForfaitCsv.Text := GetPathCsv('Choix du fichier ' + SavForfait_CSV);
end;

procedure TFrm_Main.Btn_CSavForfaitCsvClick(Sender: TObject);
begin
  CreerFile(EditSavForfaitCsv.Text);
  VerifPath(EditSavForfaitCsv);
end;

procedure TFrm_Main.Btn_SavForfaitLCsvClick(Sender: TObject);
begin
  EditSavForfaitLCsv.Text := GetPathCsv('Choix du fichier ' + SavForfaitL_CSV);
end;

procedure TFrm_Main.Btn_CSavForfaitLCsvClick(Sender: TObject);
begin
  CreerFile(EditSavForfaitLCsv.Text);
  VerifPath(EditSavForfaitLCsv);
end;

procedure TFrm_Main.Btn_SavPt1CsvClick(Sender: TObject);
begin
  EditSavPt1Csv.Text := GetPathCsv('Choix du fichier ' + SavPt1_CSV);
end;

procedure TFrm_Main.Btn_CSavPt1CsvClick(Sender: TObject);
begin
  CreerFile(EditSavPt1Csv.Text);
  VerifPath(EditSavPt1Csv);
end;

procedure TFrm_Main.Btn_SavPt2CsvClick(Sender: TObject);
begin
  EditSavPt2Csv.Text := GetPathCsv('Choix du fichier ' + SavPt2_CSV);
end;

procedure TFrm_Main.Btn_CSavPt2CsvClick(Sender: TObject);
begin
  CreerFile(EditSavPt2Csv.Text);
  VerifPath(EditSavPt2Csv);
end;

procedure TFrm_Main.Btn_SavTypMatCsvClick(Sender: TObject);
begin
  EditSavTypMatCsv.Text := GetPathCsv('Choix du fichier ' + SavTypMat_CSV);
end;

procedure TFrm_Main.Btn_CSavTypMatCsvClick(Sender: TObject);
begin
  CreerFile(EditSavTypMatCsv.Text);
  VerifPath(EditSavTypMatCsv);
end;

procedure TFrm_Main.Btn_SavTypeCsvClick(Sender: TObject);
begin
  EditSavTypeCsv.Text := GetPathCsv('Choix du fichier ' + SavType_CSV);
end;

procedure TFrm_Main.Btn_CSavTypeCsvClick(Sender: TObject);
begin
  CreerFile(EditSavTypeCsv.Text);
  VerifPath(EditSavTypeCsv);
end;

procedure TFrm_Main.Btn_SavMatCsvClick(Sender: TObject);
begin
  EditSavMatCsv.Text := GetPathCsv('Choix du fichier ' + SavMat_CSV);
end;

procedure TFrm_Main.Btn_CSavMatCsvClick(Sender: TObject);
begin
  CreerFile(EditSavMatCsv.Text);
  VerifPath(EditSavMatCsv);
end;

procedure TFrm_Main.Btn_SavCbCsvClick(Sender: TObject);
begin
  EditSavCbCsv.Text := GetPathCsv('Choix du fichier ' + SavCb_CSV);
end;

procedure TFrm_Main.Btn_CSavCbCsvClick(Sender: TObject);
begin
  CreerFile(EditSavCbCsv.Text);
  VerifPath(EditSavCbCsv);
end;

procedure TFrm_Main.Btn_SavFicheeCsvClick(Sender: TObject);
begin
  EditSavFicheeCsv.Text := GetPathCsv('Choix du fichier ' + SavFichee_CSV);
end;

procedure TFrm_Main.Btn_CSavFicheeCsvClick(Sender: TObject);
begin
  CreerFile(EditSavFicheeCsv.Text);
  VerifPath(EditSavFicheeCsv);
end;

procedure TFrm_Main.Btn_SavFicheLCsvClick(Sender: TObject);
begin
  EditSavFicheLCsv.Text := GetPathCsv('Choix du fichier ' + SavFicheL_CSV);
end;

procedure TFrm_Main.Btn_CSavFicheLCsvClick(Sender: TObject);
begin
  CreerFile(EditSavFicheLCsv.Text);
  VerifPath(EditSavFicheLCsv);
end;

procedure TFrm_Main.Btn_SavFicheArtCsvClick(Sender: TObject);
begin
  EditSavFicheArtCsv.Text := GetPathCsv('Choix du fichier ' + SavFicheArt_CSV);
end;

procedure TFrm_Main.Btn_CSavFicheArtCsvClick(Sender: TObject);
begin
  CreerFile(EditSavFicheArtCsv.Text);
  VerifPath(EditSavFicheArtCsv);
end;

end.


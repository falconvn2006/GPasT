//$Log:
// 97   Utilitaires1.96        05/10/2021 14:25:31    Antoine JOLY    Integnike
//      k_version passage en int64
// 96   Utilitaires1.95        27/03/2018 15:15:08    St?phan Duaux   CDC -
//      SP2K - Gestion int?gration des fiches Multi-Mono couleurs
// 95   Utilitaires1.94        21/02/2018 14:55:38    Thierry Fleisch
//      Modification IntegNike
// 94   Utilitaires1.93        22/12/2017 14:36:25    Ludovic MASSE   Ajout
//      sec_type
// 93   Utilitaires1.92        28/09/2017 10:20:55    Thierry Fleisch 17.1.0.9
//      : Modification du chemin par d?faut des BL auto
// 92   Utilitaires1.91        07/09/2017 13:19:32    Thierry Fleisch 17.1.0.7
//      : Ajout de s?curit?s sur le traitement des informations du BL
// 91   Utilitaires1.90        30/06/2017 11:22:16    Thierry Fleisch
//      v17.1.0.4: Correction 
//      - Probl?me ID Magasin 
//      - Positionnement mauvais fournisseur
//      - D?placement fichier int?gr?s dans le bon r?pertoire
//      - Multi execution
//      - Affichage quand aucun document ? traiter
// 90   Utilitaires1.89        15/03/2017 14:40:16    Thierry Fleisch rendu
//      Integnike + montoring
// 89   Utilitaires1.88        14/03/2017 15:01:29    Thierry Fleisch Rendu BL
//      Auto sans le monitoring
// 88   Utilitaires1.87        22/02/2017 11:24:12    Stanley Jasmin  SJ  22 02
//      2017 : Rendu
// 87   Utilitaires1.86        14/02/2017 13:58:43    Thierry Fleisch Rendu
//      d?but cdc bl auto
// 86   Utilitaires1.85        08/11/2016 15:37:01    Sylvain CORBELETTA mantis
//      #1931
//      La cr?ation des codes barres de type 1 se fait pour toutes les tailles
//      / Couleurs d'un article
// 85   Utilitaires1.84        24/03/2016 14:42:31    Ludovic MASSE   Mantis
//      973: R?f?rencement Interaxes - pour inteNike - test
// 84   Utilitaires1.83        11/12/2015 18:02:26    Lionel Plais    Mantis
//      1232?: Version 13.2.1.10?: Prend le secteur d'activit? de l'univers
//      obligatoire si la case "Pas de FEDAS" est coch?e et qu'il n'y a
//      effectivement pas de FEDAS.
// 83   Utilitaires1.82        27/04/2015 13:19:49    soustraitant    Mantis
//      973: R?f?rencement Interaxes - pour inteNike - test
// 82   Utilitaires1.81        27/04/2015 11:53:35    soustraitant    Mantis
//      973: R?f?rencement Interaxes - pour inteNike - test
// 81   Utilitaires1.80        10/02/2015 15:49:34    soustraitant   
//      Initiative 1134 : Impl?menter le r?f?rencement dynamique pour tous les
//      axes obligatoires - Prise en compte des articles fusionn?s
// 80   Utilitaires1.79        24/01/2014 16:16:58    Python Benoit  
//      Correction pour prendre en compte les magasin dom/tom avec TVA a 0.
// 79   Utilitaires1.78        16/01/2014 14:05:46    Python Benoit  
//      Correction sur les commandes.
// 78   Utilitaires1.77        15/01/2014 17:23:38    Python Benoit  
//      Correction de la gestiond e la TVA.
//      Passage en multiversion de base avec gestion de la nomenclature.
// 77   Utilitaires1.76        11/12/2013 14:49:29    Python Benoit   Message
//      d'erreur si le param?trage n'est pas fait.
// 76   Utilitaires1.75        31/10/2013 12:03:59    Python Benoit  
//      Correction d'une virgule
// 75   Utilitaires1.74        18/10/2013 10:49:03    Python Benoit   Gestion
//      du secteur dans la nomenclature.
// 74   Utilitaires1.73        16/10/2012 11:33:58    Thierry Fleisch
//      Correction du probl?me
// 73   Utilitaires1.72        24/11/2011 10:44:21    Christophe HENRAT N? de
//      version de IntegNike
// 72   Utilitaires1.71        21/11/2011 12:22:25    Christophe HENRAT
//      Int?gration mondovelo
// 71   Utilitaires1.70        17/02/2011 10:00:40    Loic G          Gestion
//      couleur 
// 70   Utilitaires1.69        14/02/2011 17:21:22    Loic G         
//      Correction pour ne pas int?grer les articles hors commande
// 69   Utilitaires1.68        03/02/2011 16:20:13    Thierry Fleisch
//      Correction probl?me desuzinge
// 68   Utilitaires1.67        21/01/2011 14:53:22    Thierry Fleisch
//      Correction en retirant l'exception indiquant que le code fedas n'existe
//      pas
// 67   Utilitaires1.66        14/01/2011 12:00:54    Thierry Fleisch Ajout de
//      la mise ? jour du CBI_LOC des codes ? barres d?j? existant
// 66   Utilitaires1.65        31/12/2010 14:13:43    Thierry Fleisch Evolution
//      du logiciel pour SP2000 janvier 2011
// 65   Utilitaires1.64        06/07/2010 11:18:02    Loic G          Ajout du
//      mvt de k sur l'update
// 64   Utilitaires1.63        06/07/2010 10:00:31    Loic G          Correction
// 63   Utilitaires1.62        28/06/2010 14:40:40    Loic G          Ajout
//      d'un traitement pour supprimer les accents des XML
// 62   Utilitaires1.61        24/06/2010 10:17:09    Loic G          Correction
// 61   Utilitaires1.60        17/06/2010 14:02:31    Loic G         
//      Correction du genre
// 60   Utilitaires1.59        17/06/2010 10:49:36    Loic G         
//      Modification du genre et du sexe
// 59   Utilitaires1.58        30/07/2009 14:14:28    Sandrine MEDEIROS Lorsque
//      l'on recherche si l'artcile existe, ignorer les archiv?s
// 58   Utilitaires1.57        30/07/2009 13:02:56    Sandrine MEDEIROS Code
//      pour EM le flag WEB, Activit? et Specifique
// 57   Utilitaires1.56        28/07/2009 15:24:49    Stan CHAUCHEPRAT stan :
//      cr?ation du prix de vente si inexistant.
// 56   Utilitaires1.55        28/07/2009 12:03:48    Sandrine MEDEIROS
//      Migration RAD Studio
// 55   Utilitaires1.54        11/03/2009 14:09:54    Sandrine MEDEIROS
//      Rajouter le crit?re pasFEDAS pour utiliser une autre NK (Espace
//      Montagne)
//      Correction creation du d?tail fournisseur
//      Maj du prix Catalogue si article d?ja existant
// 54   Utilitaires1.53        03/02/2009 15:42:18    Sandrine MEDEIROS Ne pas
//      selectionner OUI par defaut pour la recherche par chemin
// 53   Utilitaires1.52        03/02/2009 13:18:49    Sandrine MEDEIROS erreur
//      lors de l'int?gration des CB, rajouter les quotes
// 52   Utilitaires1.51        28/01/2009 14:12:11    Florent CHEVILLON lecture
//      du chemin dans le fichier ini pour renseigner la boite de dialogue de
//      s?lection du fichier
// 51   Utilitaires1.50        07/01/2009 16:34:56    Florent CHEVILLON
//      IntegreNike :
//      Permet de choisir la base de donn?e dans laquelle faire l'int?gration.
//      Si le parametre [LAME] CHEMIN=OUI dans l'ini d'IntegNike ouverture
//      d'une boite de dialogue
// 50   Utilitaires1.49        17/12/2008 11:05:33    Sandrine MEDEIROS
//      correction pour tester sur IDCOLORIS quand fluxJanvier2008
// 49   Utilitaires1.48        01/12/2008 14:22:30    Sandrine MEDEIROS
//      Correction pour Codetaille='0' au lieu de vide !!!
//      Contr?le pour anticiper correction SAGES SDI
// 48   Utilitaires1.47        02/07/2008 15:34:53    Sandrine MEDEIROS
//      Correction pour : Design + Num cde*cadence + GT Nike avec
//      String~Integer
// 47   Utilitaires1.46        06/06/2008 15:11:09    Sandrine MEDEIROS
//      correction
// 46   Utilitaires1.45        21/05/2008 12:18:53    Sandrine MEDEIROS gestion
//      PV ? Z?ro et GT de base abscente = cr?ation "Import SP2000 - id ref"
// 45   Utilitaires1.44        23/04/2008 12:10:36    Sandrine MEDEIROS
//      Correction pour la cr?ation des couleurs lorsqu'il n'y a pas de Cde
// 44   Utilitaires1.43        03/04/2008 16:11:53    Sandrine MEDEIROS
//      correction bug sur IDFOU et IDMRK vide
// 43   Utilitaires1.42        26/03/2008 21:59:38    Sandrine MEDEIROS code de
//      ART_GARID=2 pour int?gartion CDROM JA
// 42   Utilitaires1.41        18/02/2008 15:48:52    Sandrine MEDEIROS Ne pas
//      tester le prix ? 0? sur PVI
// 41   Utilitaires1.40        13/02/2008 14:51:50    Sandrine MEDEIROS Gestion
//      des Genres + Detection de la marque entre nouveau et ancien format
// 40   Utilitaires1.39        08/02/2008 12:29:22    Sandrine MEDEIROS Traiter
//      les fichiers FOU ? l'ancien format mais Fichier TAI au nouveau !!!
// 39   Utilitaires1.38        23/01/2008 22:56:27    Sandrine MEDEIROS gestion
//      du PVB
// 38   Utilitaires1.37        12/01/2008 00:53:36    Sandrine MEDEIROS flux
//      Janvier 2008
// 37   Utilitaires1.36        08/01/2008 19:24:07    Sandrine MEDEIROS Mise en
//      place des nouveaux formats
// 36   Utilitaires1.35        24/10/2007 16:23:24    Sandrine MEDEIROS forcer
//      des UPPERCASE sur les noms pour une comparaison plus juste Marque et
//      fournisseur
// 35   Utilitaires1.34        03/08/2007 08:27:48    pascal         
//      Modification pour erreur %d quand rejoue un packet
// 34   Utilitaires1.33        13/07/2007 18:08:05    Sandrine MEDEIROS
//      Correction pour CFOU et MARQUE vide dans le CDRom JA juillet 2008 pour
//      les marque LOTTO-UMBRO-TACCHINI, on analyse le nom du fichier pour
//      retrouver la marque... (fait et rendu par Sandrine)
// 33   Utilitaires1.32        13/07/2007 17:34:46    pascal         
//      Correction JA juillet 2007 pour arr?ter le traitement si fichier au
//      mauvais format + g?rer les idcoloris qui sont parfois des varchar et
//      non des integer + supprimer *couleur sur les ref fourn (rendu par
//      sandrine sur le poste de Pascal)
// 32   Utilitaires1.31        12/07/2007 09:25:38    pascal          Message
//      d'erreur quand ancien fichier
// 31   Utilitaires1.30        04/07/2007 15:28:17    pascal          nouveau
//      fichier sp2000
// 30   Utilitaires1.29        29/03/2007 12:49:50    pascal          rendu par
//      sandrine pendant que pascal ?tait malade
// 29   Utilitaires1.28        22/11/2006 12:01:06    Sandrine MEDEIROS
//      Correction sur la proc Importation (du fichier XML) pour MenArt
//      Creation de la function enreal qui transforme la ',' en '.'
// 28   Utilitaires1.27        28/07/2006 11:22:33    Sandrine MEDEIROS Dans
//      l'?tape de v?rification, mise en place d'un code erreur (RAISE
//      Exception ligne1458) si la taille n'existe pas.
//      Message de fin d'int?gration plus clair (ERREUR) en cas d'erreur
//      d'int?gartion
// 27   Utilitaires1.26        29/05/2006 10:51:31    Bruno NICOLAFRANSCECO
//      Ajout du coe article si import avec 2 code articles identiques
// 26   Utilitaires1.25        03/05/2006 14:39:30    pascal          Test si
//      la taille n'existe pas avant l'import
// 25   Utilitaires1.24        24/04/2006 10:32:23    pascal          Ajout
//      d'une v?rification de coh?rence entre le fichier des commandes et celui
//      des articles
// 24   Utilitaires1.23        21/04/2006 12:33:22    pascal          Ajout
//      d'un forcedirectories pour ?viter les erreurs quand un des rep n'existe
//      pas
// 23   Utilitaires1.22        19/04/2006 14:19:18    Bruno NICOLAFRANSCECO
//      correction trim sur lib article
// 22   Utilitaires1.21        14/04/2006 14:48:42    Sandrine MEDEIROS en
//      r?alit? &quote; s'?crit &quot;
// 21   Utilitaires1.20        14/04/2006 11:13:56    pascal          tentative
//      de correction
// 20   Utilitaires1.19        03/04/2006 08:25:28    Bruno NICOLAFRANSCECO
//      Param qte max article ? t?l?charger
// 19   Utilitaires1.18        24/03/2006 12:42:11    pascal         
//      Modification suite au probl?me des tailles travaill?es non pr?sentes
// 18   Utilitaires1.17        22/03/2006 17:13:19    pascal         
//      Modification pour les redescente FTP
// 17   Utilitaires1.16        13/03/2006 08:58:07    pascal         
//      Modification suite ? la perte du champ SSF_OF pour une raison que
//      j'ignore
// 16   Utilitaires1.15        09/03/2006 08:41:40    pascal         
//      modification pour rendre visible les rayons/familles/sous familles
// 15   Utilitaires1.14        16/02/2006 14:36:55    Bruno NICOLAFRANSCECO
//      detection des caract?re #0 ? #9
// 14   Utilitaires1.13        06/02/2006 16:39:31    pascal         
//      Correction pour ?viter la cr?ation des collections en double
// 13   Utilitaires1.12        06/02/2006 15:54:24    Bruno NICOLAFRANSCECO
//      modif 2 rep int?gration
// 12   Utilitaires1.11        18/01/2006 15:21:04    Bruno NICOLAFRANSCECO
//      modif suite mauvaise date liv dans CD
// 11   Utilitaires1.10        12/01/2006 11:45:07    Sandrine MEDEIROS Doc
//      poser dans C:\ginkoia\Bpl
// 10   Utilitaires1.9         12/01/2006 11:40:10    Sandrine MEDEIROS Rajout
//      de la connection des deux doc : aide + fedas
// 9    Utilitaires1.8         12/01/2006 10:57:36    Bruno NICOLAFRANSCECO
//      evoluion du module
// 8    Utilitaires1.7         09/01/2006 21:07:52    Bruno NICOLAFRANSCECO
//      modif visuelle+ajout onglet rapport
// 7    Utilitaires1.6         09/01/2006 15:53:52    pascal         
//      Modifications pour la fedas et le manque de sous famille
// 6    Utilitaires1.5         06/01/2006 12:28:19    pascal         
//      corrections divers pour bruno
// 5    Utilitaires1.4         06/01/2006 10:25:52    Bruno NICOLAFRANSCECO
//      coreection bug vu avec Pascal
// 4    Utilitaires1.3         03/01/2006 17:55:19    pascal          Modif
//      pour Fedas
// 3    Utilitaires1.2         22/11/2005 12:50:23    pascal          Ajout du
//      chemin par defaut
// 2    Utilitaires1.1         08/08/2005 09:03:14    pascal          Je ne me
//      rappel plus
// 1    Utilitaires1.0         27/04/2005 10:40:55    pascal          
//$
//$NoKeywords$
//
UNIT IntNikePrin_FRM;

INTERFACE

USES

  XMLCursor,
  ShellApi,
  StdXML_TLB,
  registry,
  Inifiles,
  ConfNike_frm,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  Menus,
  Db,
  dxmdaset,
  IBCustomDataSet,
  IBStoredProc,
  IBDatabase,
  IBQuery,
  LMDCustomComponent,
  LMDContainerComponent,
  LMDBaseDialog,
  LMDAboutDlg, xmldom, XMLIntf, msxmldom, XMLDoc, RzLabel,
  uIntNikeBL, uLog, uDefs, LMDOneInstance,
  uTransformationMultiVersMonoCouleur,
  uGestionBDD;

TYPE
  TGestion_K_Version = (tKNone, tKV32, tKV64);

  TFrm_IntNikePrin = CLASS(TForm)
    MainMenu1: TMainMenu;
    N1Fichier1: TMenuItem;
    Pb1: TProgressBar;
    Pb2: TProgressBar;
    Lab_Etat1: TLabel;
    Lab_etat2: TLabel;
    Button1: TButton;
    Button2: TButton;
    MemFou: TdxMemData;
    MemFouITEMID: TStringField;
    MemFouCFOU: TStringField;
    MemFouLFOU: TStringField;
    MenEntTail: TdxMemData;
    MenEntTailITEMID: TStringField;
    MenEntTailCTAI: TStringField;
    MenEntTailLTAI: TStringField;
    MenLigTail: TdxMemData;
    MenLigTailITEMID: TStringField;
    MenLigTailTAILLE: TStringField;
    MenArt: TdxMemData;
    MenArtITEMID: TStringField;
    MenArtLIBELLE: TStringField;
    MenArtCCOU: TStringField;
    MenArtCR1: TStringField;
    MenArtCFAM: TStringField;
    MenArtCSAI: TStringField;
    MenArtANNEE: TStringField;
    MenArtCTAI: TStringField;
    MenArtCFOU: TStringField;
    MenArtRFOU: TStringField;
    MenArtMARQUE: TStringField;
    MenArtLIBFRS: TStringField;
    MenArtFEDAS: TStringField;
    MenArtPA: TStringField;
    MenArtPV: TStringField;
    MenCB: TdxMemData;
    MenCBITEMID: TStringField;
    MenCBRFOU: TStringField;
    MenCBGESCOM: TStringField;
    MenCBLTAI: TStringField;
    MenCBBARRE: TStringField;
    MenEntCom: TdxMemData;
    MenEntComITEMID: TStringField;
    MenEntComNUMCDE: TStringField;
    MenEntComCFOU: TStringField;
    MenEntComDCDE: TStringField;
    MenEntComCMAG: TStringField;
    MenEntComDLIV: TStringField;
    MenEntComCSAI: TStringField;
    MenEntComANNEE: TStringField;
    MenEntComLLCLI: TStringField;
    MenEntComLADR1: TStringField;
    MenEntComLCPOS: TStringField;
    MenEntComLVILLES: TStringField;
    MenLigCom: TdxMemData;
    MenLigComITEMID: TStringField;
    MenLigComNUMCDE: TStringField;
    MenLigComRFOU: TStringField;
    MenLigComLTAIL: TStringField;
    MenLigComQTE: TStringField;
    MenLigComPA: TStringField;
    MenLigTailTRAVAIL: TIntegerField;
    MenEntTailVALIDE: TIntegerField;
    Data: TIBDatabase;
    Tran: TIBTransaction;
    IBST_NewKey: TIBStoredProc;
    QRY_Div: TIBQuery;
    Qry_Div2: TIBQuery;
    MenEntTailGTF_ID: TIntegerField;
    MenLigTailTGF_ID: TIntegerField;
    MemFouFOU_ID: TIntegerField;
    MemFouMRK_ID: TIntegerField;
    MenArtSSF_ID: TIntegerField;
    MenArtART_ID: TIntegerField;
    MenArtARF_ID: TIntegerField;
    MenArtFOU_ID: TIntegerField;
    MenArtMRK_ID: TIntegerField;
    MenArtGTF_ID: TIntegerField;
    IBST_CB: TIBStoredProc;
    MenEntComMAG_ID: TIntegerField;
    MenSSF: TdxMemData;
    MenSSFSSF_ID: TIntegerField;
    MenSSFSSF_NOM: TStringField;
    MenSSFSSF_FEDAS: TStringField;
    Rapports1: TMenuItem;
    OD_rapp: TOpenDialog;
    Docunmenations1: TMenuItem;
    Aide1: TMenuItem;
    FedassousExcel1: TMenuItem;
    MemD_ArtCol: TdxMemData;
    MemD_ArtColArt: TdxMemData;
    MemD_ArtColCOL_ID: TIntegerField;
    MemD_ArtColCOL_NOM: TStringField;
    MemD_ArtColArtCAR_ID: TIntegerField;
    MemD_ArtColArtCAR_ARTID: TIntegerField;
    MemD_ArtColArtCAR_COLID: TIntegerField;
    MenSSFSSF_OK: TIntegerField;
    MemD_Marque: TdxMemData;
    MemD_MarqueMARQUE: TStringField;
    MemD_MarqueMRK_ID: TIntegerField;
    MemD_Liais: TdxMemData;
    MemD_LiaisFOU_ID: TIntegerField;
    MemD_LiaisMRK_ID: TIntegerField;
    MemD_COU: TdxMemData;
    MemD_COUIDCOLORIS: TStringField;
    MemD_COUCODECOLORIS: TStringField;
    MemD_COUDESCRIPTIF: TStringField;
    MemD_COUITEMID: TStringField;
    MenLigComCODECOLORIS: TStringField;
    MemD_COUCOU_ID: TIntegerField;
    MemD_COUART_ID: TIntegerField;
    MenCBCODECOLORIS: TStringField;
    MenArtCATMAN: TStringField;
    MenCBARTICLEID: TStringField;
    MenLigComARTICLEID: TStringField;
    MenEntTailNOM: TStringField;
    MemFouIDMARQUE: TStringField;
    MemFouIDFOURNISSEUR: TStringField;
    MenLigTailCODETAILLE: TStringField;
    MenArtIDMARQUE: TStringField;
    MenArtIDFOURNISSEUR: TStringField;
    MenArtPANET: TStringField;
    MenArtCOLLECTION: TStringField;
    MenArtGENRESP2K: TStringField;
    MenArtREFERENCECENTRALE: TStringField;
    MenCBIDCOLORIS: TStringField;
    MenCBCODETAILLE: TStringField;
    MenEntComIDMARQUE: TStringField;
    MenEntComIDFOURNISSEUR: TStringField;
    MenLigComIDCOLORIS: TStringField;
    MenLigComCODETAILLE: TStringField;
    MenLigComPANET: TStringField;
    MemD_MarqueIDMARQUE: TStringField;
    MemFouMARQUE: TStringField;
    MemD_COUVALIDE: TIntegerField;
    MenArtGRE_ID: TIntegerField;
    MenArtPVI: TStringField;
    MemD_Genre: TdxMemData;
    MemD_GenreGRE_ID: TIntegerField;
    MemD_GenreGRE_NOM: TStringField;
    MemD_GenreGRE_SEXE: TIntegerField;
    AboutDlg_Main: TLMDAboutDlg;
    Apropos1: TMenuItem;
    OD_Base: TOpenDialog;
    MenArtWEB: TStringField;
    MenArtACTIVITE: TStringField;
    MenArtSPECIFICITE: TStringField;
    MemD_Web: TdxMemData;
    MemD_WebICL_ID: TIntegerField;
    MemD_WebICL_NOM: TStringField;
    MemD_ACTIVITE: TdxMemData;
    MemD_Specifique: TdxMemData;
    MemD_ACTIVITEICL_NOM: TStringField;
    MemD_SpecifiqueICL_ID: TIntegerField;
    MemD_SpecifiqueICL_NOM: TStringField;
    MemD_ACTIVITEICL_ID: TIntegerField;
    XML: TXMLDocument;
    MenCBCBI_LOC: TIntegerField;
    Que_GenImport: TIBQuery;
    MenArtMONDOVELO: TStringField;
    Lab_Version: TRzLabel;
    MenArtCOL_ID: TIntegerField;
    Inst_one: TLMDOneInstance;
    Que_isExistArt: TIBQuery;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Paramtrage1Click(Sender: TObject);
    PROCEDURE Traitement1Click(Sender: TObject);
    PROCEDURE Quitter1Click(Sender: TObject);
    PROCEDURE FormPaint(Sender: TObject);
    PROCEDURE Rapports1Click(Sender: TObject);
    PROCEDURE Aide1Click(Sender: TObject);
    PROCEDURE FedassousExcel1Click(Sender: TObject);
    PROCEDURE Apropos1Click(Sender: TObject);
  PRIVATE
    FVersionBase : integer;
    FGestion_K_VERSION : TGestion_K_Version;

    FluxJanvier2008: Boolean;
    FluxEM: Boolean;
    FUNCTION Traitement(rep: STRING): integer;
    FUNCTION Verif(S: STRING): Boolean;
    FUNCTION UneClef: Integer;
    PROCEDURE QRY(S: ARRAY OF STRING);
    PROCEDURE Importe(NOM: STRING);
    FUNCTION InsertK(Clef: Int64; Table: STRING): TStringList;
    PROCEDURE AjouteScr(Script: TstringList; S: ARRAY OF STRING);
    PROCEDURE AjouteScrQry(Script: TstringList; Table, Champs,
      Valeur: STRING; Valu: ARRAY OF CONST);
    PROCEDURE MajScrQry(Script: TstringList; Table, Champs: STRING; Valu: ARRAY OF CONST; Cle, CleValeur: STRING);
    FUNCTION AjoutCleScript(Script: TstringList; TABLE: STRING): Integer;
    PROCEDURE QRYEVO(Quoi, Table, Ref, Where: STRING);
    FUNCTION transforme(XML: IXMLCursor): TStringList;
    FUNCTION SexSport2000(Genre:String):Integer;
    function StrEnleveAccents(const S : String) : string;
    Procedure SupprAccent(Fichier:String);

    //Crée tous les codebarres de type 1 manquant pour les tailes couleurs d'un article
    procedure CreateMissingType1CB(AArticleId, AArfId: integer; Script: TstringList);
    // Récupère Le GUID et le MAGID
    procedure GetBaseInfo(out AGUID : string; out AMAGID : Integer);
    // Tester si le mode de gestion des couleurs de fiche article est mono ou multi couleur
    FUNCTION isModeGestionMonoCouleurActif() : Boolean;
    //tester si l article a deja été importé
    FUNCTION isExistArt(itemid : Integer) : Boolean;
    procedure Check_Mode_K_VERSION;
    function GetGestion_K_VERSION: TGestion_K_Version;


    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }


    LesFichiers: TstringList;
    QttMaxArt: Integer;

    RepXML, repxml1, repxml2, Lame, emplacement,
    RepBl : STRING;
    Labase: STRING;
    CPA_ID: Integer; // A paramètrer
    SAISON: Integer;
    TYP_ID: Integer;
    pasFEDAS: Integer;
    Resultat: TstringList;
    ParametrageAFaire: Boolean;

    property Gestion_K_VERSION: TGestion_K_Version read GetGestion_K_VERSION;
  END;



VAR
  Frm_IntNikePrin: TFrm_IntNikePrin;

IMPLEMENTATION

uses
  uManageCodeBarreType1;    

{$R *.DFM}

function ApplicationVersion: String;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize <> 0 then   // Les info de version sont inclues
  begin
    // On alloue de la mémoire pour un pointeur sur les info de version
    GetMem(VerInfo, VerInfoSize);
    // On récupère ces informations :
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    // On traite les informations ainsi récupérées
    with VerValue^ do
    begin
      Result := IntTostr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntTostr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;
    // On libère la place précédemment allouée
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

function TFrm_IntNikePrin.StrEnleveAccents(const S : String) : string;
var i:integer;
begin
 Result := S;
 i:=1;
 while i<=length(s) do
  begin
   case s[i] of 'À'..'Å'     : Result[i]:='A';
                'à'..'å'     : Result[i]:='a';
                'È'..'Ë'     : Result[i]:='E';
                'è'..'ë'     : Result[i]:='e';
                'Ì'..'Ï'     : Result[i]:='I';
                'ì'..'ï'     : Result[i]:='i';
                'Ò'..'Ö','Ø' : Result[i]:='O';
                'ò'..'ö','ø' : Result[i]:='o';
                'Ù'..'Ü'     : Result[i]:='U';
                'ù'..'ü'     : Result[i]:='u';
                'Š'          : Result[i]:='S';
                'š'          : Result[i]:='s';
                'Ç'          : Result[i]:='C';
                'ç'          : Result[i]:='c';
                'Ñ'          : Result[i]:='N';
                'ñ'          : Result[i]:='n';
                'Ð'          : Result[i]:='D';
                'Ÿ','Ý'      : Result[i]:='Y';
                'ý','ÿ'      : Result[i]:='y';
                'ð'          : Result[i]:='d';
                'ž'          : Result[i]:='z';
                'Ž'          : Result[i]:='Z';
                'Œ'    :begin
                         Result[i]:='O';
                         insert('E',Result,i+1);
                         inc(i);
                        end;
                'œ'    :begin
                         Result[i]:='o';
                         insert('e',Result,i+1);
                         inc(i);
                        end;
                'Æ'    :begin
                         Result[i]:='A';
                         insert('E',Result,i+1);
                         inc(i);
                        end;
                'æ'    :begin
                         Result[i]:='a';
                         insert('e',Result,i+1);
                         inc(i);
                        end;
                     end;
   inc(i);
   end;
end;

Procedure TFrm_IntNikePrin.SupprAccent(Fichier:String);
//Remplace les caracères avec accents par leurs homologues sans accent
Var
  F         : TextFile;     //Fichier à traiter
  ConvFile  : TStringList;  //Variable de conversion
  Line      : string;       //ligne en cour de traitement
  I         : Integer;      //Variable de boucle
Begin
  //Converti le format du xml
  XML.Active    := True;
  XML.LoadFromFile(Fichier);
  XML.Encoding  := 'ISO-8859-1';
  XML.SaveToFile(Fichier);

  //Remplace les accents
  ConvFile  := TStringList.Create;
  ConvFile.Clear;
  AssignFile(F,Fichier);
  Reset(F);
  while Not EOF(F) do
    Begin
      Readln(F,Line);
      Line  := StrEnleveAccents(Line);
      ConvFile.Append(Line);
    End;
  CloseFile(F);
  Rewrite(F);
  for I := 0 to ConvFile.Count - 1 do
    WriteLn(F,ConvFile.Strings[I]);
  CloseFile(F);
  ConvFile.free;
End;

FUNCTION TFrm_IntNikePrin.SexSport2000(Genre:String):Integer;
//Détermine le sexe du genre en fonction des spécificités sport 2000
Var
  Tab_GenreSport2000  : Array [0..1,0..9] of string;    //Tableau de genre/sexe sport 2000
  I                   : Integer;                   //Variable de boucle
Begin
  //Initialisation du tableau
  Tab_GenreSport2000[0,0] := 'HOMME';           Tab_GenreSport2000[1,0] := '1';
  Tab_GenreSport2000[0,1] := 'FEMME';           Tab_GenreSport2000[1,1] := '2';
  Tab_GenreSport2000[0,2] := 'ENFANT';          Tab_GenreSport2000[1,2] := '3';
  Tab_GenreSport2000[0,3] := 'UNISEXE';         Tab_GenreSport2000[1,3] := '1';
  Tab_GenreSport2000[0,4] := 'JUNIOR GARCON';   Tab_GenreSport2000[1,4] := '3';
  Tab_GenreSport2000[0,5] := 'JUNIOR FILLE';    Tab_GenreSport2000[1,5] := '3';
  Tab_GenreSport2000[0,6] := 'CADET';           Tab_GenreSport2000[1,6] := '3';
  Tab_GenreSport2000[0,7] := 'CADETTE';         Tab_GenreSport2000[1,7] := '3';
  Tab_GenreSport2000[0,8] := 'BEBE';            Tab_GenreSport2000[1,8] := '3';
  Tab_GenreSport2000[0,9] := 'BEBE FILLE';      Tab_GenreSport2000[1,9] := '3';

  //Recherche du sexe associé au genre (renvoie 0 si non trouvé)
  Result  := 0;
  for I := 0 to Length(Tab_GenreSport2000[0])-1 do
    if (UpperCase(Genre) = Tab_GenreSport2000[0,I]) then
      Begin
        Result  := StrToInt(Tab_GenreSport2000[1,I]);
        Break;
      End;
End;

PROCEDURE TFrm_IntNikePrin.FormCreate(Sender: TObject);
VAR
  ini: TInifile;
  reg: TRegistry;
  sTmp: string;
  i : Integer;
  bBaseFound : Boolean;
BEGIN
  // info de version
  sTmp := ApplicationVersion;
  AboutDlg_Main.Version := sTmp;
  if sTmp<>'' then
    sTmp := 'Ver. '+sTmp;
  Lab_Version.Caption := sTmp;

  DecimalSeparator := '.';
  lab_etat1.caption := '';
  lab_etat2.caption := '';
  ini := TiniFile.Create(changefileext(application.exename, '.ini'));
  //vérifier dans l'ini si mode de fonctionnement manuel ou automatique :
  //auto = base stcokée dans le registre
  //manuel = chemin renseigné par l'utilisateur
  Lame := ini.readstring('LAME', 'CHEMIN', 'NON');

  RepXML1 := ini.readstring('DEFAUT', 'REP1', 'C:\GESTIONJA_XML\');
  RepXML2 := ini.readstring('DEFAUT', 'REP2', 'C:\SagesSdiFtp\Reception\');
  RepBl   := ini.ReadString('DEFAUT','REPBL' ,'C:\GESTIONJA_XML\BLAuto\');
  QttMaxArt := ini.readInteger('DEFAUT', 'NBARTMAX', 1000);

  od_rapp.initialdir := repXml1;
  CPA_ID := ini.readInteger('DEFAUT', 'CPAID', 0);
  SAISON := ini.readInteger('DEFAUT', 'SAISON', 0);
  TYP_ID := ini.readInteger('DEFAUT', 'TYPID', 0);
  pasFEDAS := ini.readInteger('DEFAUT', 'pasFEDAS', 0);

  IF (trim(RepXML1) = '') OR (trim(RepXML2) = '') OR (trim(RepBl) = '') OR
    (CPA_ID = 0) OR
    (TYP_ID = 0) THEN
    ParametrageAFaire := true
  ELSE
    ParametrageAFaire := False;

  bBaseFound := False;
  if ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
      if Pos('-BASE:',UpperCase(ParamStr(i))) > 0 then
      begin
        emplacement := Copy(ParamStr(i),7,Length(ParamStr(i)));
        Data.DatabaseName := StringReplace(emplacement,'"','',[rfReplaceAll]);
        bBaseFound := True;
      end;
  end;

  //lab
  if not bBaseFound then
  begin
    IF (Lame = '') OR (UpperCase(Lame) = 'NON') THEN
    BEGIN
      reg := TRegistry.Create(KEY_READ);
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
      Labase := reg.ReadString('Base0');
      reg.closekey;
      reg.free;
      Data.DatabaseName := Labase;
    END
    ELSE IF UpperCase(Lame) = 'OUI' THEN
    BEGIN
      //lire le chemin
      emplacement := ini.readstring('LAME', 'EMPLACEMENT', 'C:\Ginkoia\Data\Ginkoia.ib');
      //régler les options
      IF NOT FileExists(emplacement) THEN
      BEGIN
        OD_Base.InitialDir := GetCurrentDir;
      END
      ELSE
      BEGIN
        OD_Base.InitialDir := ExtractFilePath(emplacement);
        OD_Base.Filename := ExtractFileName(emplacement);
      END;
      OD_Base.Options := [ofFileMustExist];
      //si un fichier est sélectionné
      IF OD_Base.Execute THEN
      BEGIN
        //recopier son nom
        Data.DatabaseName := OD_Base.FileName;
      END;
    END;
  end;
  ini.free;

  Caption := Caption + ' : ' + Data.DatabaseName;
END;

PROCEDURE TFrm_IntNikePrin.Paramtrage1Click(Sender: TObject);
VAR
  frm_ConfNike: Tfrm_ConfNike;
  ini: TInifile;
  I, j: Integer;
BEGIN
  Application.createform(Tfrm_ConfNike, frm_ConfNike);
  TRY
    frm_ConfNike.Chk_PasFEDAS.Checked := (pasFEDAS = 1);
    frm_ConfNike.edit1.text := RepXML1;
    frm_ConfNike.edit2.text := RepXML2;
    frm_ConfNike.Edit3.Text := RepBl;
    frm_confnike.chp_max.text := inttostr(QttMaxArt);
    Data.Open;
    
    QRYEVO('TYP_ID, TYP_LIB', 'GENTYPCDV', 'TYP_ID', 'TYP_CATEG=1 and TYP_ID<>0');
    frm_ConfNike.CB_TYPID.items.clear;
    Qry_div.first;
    J := 0;
    WHILE NOT Qry_div.Eof DO
    BEGIN
      i := Qry_div.Fields[0].AsInteger;
      IF i = TYP_ID THEN
        J := frm_ConfNike.CB_TYPID.items.Count;
      frm_ConfNike.CB_TYPID.items.AddObject(Qry_div.Fields[1].AsString, Pointer(i));
      Qry_div.Next;
    END;
    frm_ConfNike.CB_TYPID.ItemIndex := j;
    QRYEVO('CPA_ID, CPA_NOM', 'GENCDTPAIEMENT', 'CPA_ID', 'CPA_ID<>0');
    frm_ConfNike.CB_CPAID.items.clear;
    Qry_div.first;
    J := 0;
    WHILE NOT Qry_div.Eof DO
    BEGIN
      i := Qry_div.Fields[0].AsInteger;
      IF i = CPA_ID THEN
        J := frm_ConfNike.CB_CPAID.items.Count;
      frm_ConfNike.CB_CPAID.items.AddObject(Qry_div.Fields[1].AsString, Pointer(i));
      Qry_div.Next;
    END;
    frm_ConfNike.CB_CPAID.ItemIndex := j;
    Data.close;
    IF saison = 0 THEN
      frm_ConfNike.Rb_Ete.checked := true
    ELSE
      frm_ConfNike.Rb_Hiver.checked := true;

    IF frm_ConfNike.ShowModal = MrOk THEN
    BEGIN
      ini := TiniFile.Create(changefileext(application.exename, '.ini'));
      RepXML1 := frm_ConfNike.edit1.text;
      RepXML2 := frm_ConfNike.edit2.text;
      RepBl   := frm_ConfNike.Edit3.Text;

      QttMaxArt := strtoint(frm_ConfNike.chp_max.text);
      I := Integer(frm_ConfNike.CB_TYPID.items.Objects[frm_ConfNike.CB_TYPID.ItemIndex]);
      TYP_ID := I;
      I := Integer(frm_ConfNike.CB_CPAID.items.Objects[frm_ConfNike.CB_CPAID.ItemIndex]);
      CPA_ID := I;
      IF frm_ConfNike.Rb_Ete.checked THEN
        Saison := 0
      ELSE
        Saison := 1;
      IF frm_ConfNike.Chk_PasFEDAS.Checked THEN
        pasFEDAS := 1
      ELSE
        pasFEDAS := 0;
      ini.Writestring('DEFAUT', 'REP1', RepXML1);
      ini.Writestring('DEFAUT', 'REP2', RepXML2);
      ini.WriteString('DEFAUT','REPBL', RepBl);
      ini.WriteInteger('DEFAUT', 'CPAID', CPA_ID);
      ini.WriteInteger('DEFAUT', 'SAISON', SAISON);
      ini.WriteInteger('DEFAUT', 'TYPID', TYP_ID);
      ini.Writestring('DEFAUT', 'NBARTMAX', inttostr(QttMaxArt));
      ini.WriteInteger('DEFAUT', 'pasFEDAS', pasFEDAS);
      ini.free;
    END
    ELSE
    BEGIN
      IF sender = NIL THEN
      BEGIN
        Application.MessageBox('Impossible de faire tourner l''application si elle n''est pas paramétrée', 'Attention', Mb_Ok);
        Close;
      END;
    END;
  FINALLY
    frm_ConfNike.release;
  END;
  od_rapp.initialdir := repXml1;
END;

PROCEDURE TFrm_IntNikePrin.Quitter1Click(Sender: TObject);
BEGIN
  Close;
END;

FUNCTION TFrm_IntNikePrin.UneClef: Integer;
BEGIN
  IBST_NewKey.Prepare;
  IBST_NewKey.ExecProc;
  Result := IBST_NewKey.Parambyname('NEWKEY').AsInteger;
  IBST_NewKey.UnPrepare;
  IBST_NewKey.Close;
END;

PROCEDURE TFrm_IntNikePrin.QRY(S: ARRAY OF STRING);
VAR
  i: Integer;
BEGIN
  QRY_Div.Close;
  QRY_Div.sql.Clear;
  FOR i := 0 TO High(S) DO
    QRY_Div.sql.Add(S[i]);
  QRY_Div.Open;
END;

PROCEDURE TFrm_IntNikePrin.QRYEVO(Quoi, Table, Ref, Where: STRING);
BEGIN
  QRY_Div.Close;
  QRY_Div.sql.Clear;
  QRY_Div.sql.Add('SELECT ' + Quoi);
  IF ref <> '' THEN
    QRY_Div.sql.Add('From ' + Table + ' Join k on (K_ID=' + ref + ' and k_enabled=1)')
  ELSE
    QRY_Div.sql.Add('From ' + Table);
  IF where <> '' THEN
    QRY_Div.sql.Add('WHERE K_ID != 0 AND ' + where);
  QRY_Div.Open;
END;


//tester si l article a deja été importé
FUNCTION TFrm_IntNikePrin.isExistArt(itemid : Integer) : Boolean;
var
  iResultat : integer;
  bResultat : boolean;
begin
    iResultat := 0;
    bResultat := false;
    Que_isExistArt.Close;
    Que_isExistArt.paramByName('artidref').AsInteger := itemid;
    Que_isExistArt.Open;
    Que_isExistArt.First;
    if not (Que_isExistArt.Eof) then
    begin
       // la procedure stockee SP2K_ISEXIST_IMPORTED_FICHEMODELE retourne 1 si vrai, 0 si faux
       iResultat := Que_isExistArt.fieldbyname('isExist').AsInteger;
       if (iResultat=1)then
       begin
          bResultat := true;
       end
       else
       begin
          bResultat := false;
       end;
    Que_isExistArt.close;
    end;
    result := bResultat;
end;

// Tester si le parametre de gestion de mode mono couleur est activé
FUNCTION TFrm_IntNikePrin.isModeGestionMonoCouleurActif() : Boolean;
var
  paramValue : integer;
begin
  paramValue := 0;
  QRY(['Select * from genparam JOIN K ON K_ID = PRM_ID AND K_ENABLED=1 where PRM_CODE=1 and PRM_TYPE=31']);
  if (not QRY_Div.IsEmpty) then
  begin
      paramValue := QRY_Div.FieldByName('PRM_INTEGER').AsInteger;
      if (paramValue=1) then
      begin
          Result := true;
      end
      else
      begin
        Result := false;
      end;
  end
  else
  begin
     Result := false;
  end;
  QRY_Div.Close();
end;


FUNCTION TFrm_IntNikePrin.Verif(S: STRING): Boolean;

  PROCEDURE Insertion(table: TdxMemData; V: ARRAY OF STRING);
  VAR
    i: integer;
  BEGIN
    Table.Append;
    FOR i := 0 TO High(V) DO
      table.fields[i + 1].AsString := trim(V[i]);
    table.post;
  END;

  FUNCTION enreal(s: STRING): STRING;
  BEGIN
    WHILE pos(',', S) > 0 DO
      S[Pos(',', s)] := '.';
    result := s;
  END;

  PROCEDURE traiteFichier(S: STRING);
  VAR
    tsl: tstringlist;
    S1: STRING;
    i: integer;
  BEGIN
    tsl := tstringlist.create;
    tsl.loadfromfile(S);
    IF Copy(TSL[0], 1, length('<?xml version=')) = '<?xml version=' THEN
      tsl.delete(0);
    S1 := tsl.text;
    WHILE pos('&', S1) > 0 DO
    BEGIN
      I := pos('&', S1);
      IF (copy(S1, i, 4) <> '&lt;') AND
        (copy(S1, i, 4) <> '&gt;') AND
        (copy(S1, i, 5) <> '&amp;') AND
        (copy(S1, i, 2) <> '&#') AND
        (copy(S1, i, 7) <> '&quote;') AND
        (copy(S1, i, 6) <> '&quot;') THEN
      BEGIN
        delete(S1, i, 1);
        insert('¤ù¤amp;', S1, i);
      END
      ELSE
      BEGIN
        delete(S1, i, 1);
        insert('¤ù¤', S1, i);
      END;
    END;
    WHILE pos('¤ù¤', S1) > 0 DO
    BEGIN
      I := pos('¤ù¤', S1);
      delete(S1, i, 3);
      insert('&', S1, i);
    END;
    WHILE pos('"', S1) > 0 DO
    BEGIN
      I := pos('"', S1);
      delete(S1, i, 1);
      insert('&quot;', S1, i);
    END;

    WHILE pos('&quote;', S1) > 0 DO
    BEGIN
      I := pos('&quote;', S1);
      delete(S1, i, length('&quote;'));
      insert('&quot;', S1, i);
    END;

    WHILE pos(#0, S1) > 0 DO
    BEGIN
      I := pos(#0, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#1, S1) > 0 DO
    BEGIN
      I := pos(#1, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#2, S1) > 0 DO
    BEGIN
      I := pos(#2, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#3, S1) > 0 DO
    BEGIN
      I := pos(#3, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#4, S1) > 0 DO
    BEGIN
      I := pos(#4, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#5, S1) > 0 DO
    BEGIN
      I := pos(#5, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#6, S1) > 0 DO
    BEGIN
      I := pos(#6, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#7, S1) > 0 DO
    BEGIN
      I := pos(#7, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#8, S1) > 0 DO
    BEGIN
      I := pos(#8, S1);
      delete(S1, i, 1);
    END;

    tsl.text := S1;

    IF Copy(TSL[0], 1, length('<?xml version=')) <> '<?xml version=' THEN
      tsl.Insert(0, '<?xml version="1.0" encoding="ISO-8859-1"?>');
    tsl.SaveTofile(S);
    tsl.free;
  END;

VAR
  Document: IXMLCursor;
  PassXML: IXMLCursor;
  PassXML2: IXMLCursor;
  PassXML3: IXMLCursor;
  ITEMID: STRING;
  i: integer;
  ART: STRING;
  GTAIL: STRING;
  ok, TOC, PbTaille2008, Design: boolean;
  //FOU_ID: Integer;
  enl1: integer;
  enl2: integer;
  enl3: integer;
  tsl: TstringList;
  tsl2: TstringList;
  first: boolean;
  testtsl: tstringlist;
  testS: STRING;
  CFOU, IDMRK, IDFOUR, PVB, PV, PANet, TailleNom, CouNom: STRING;
  bIsModeMonoCouleur : Boolean;
  artFilePath, barFilePath, dcdFilePath : string;
  transformateurMultiMono : TTransformationMultiVersMonoCouleur ;
BEGIN
  bIsModeMonoCouleur := false;
  result := true;
  MemFou.Close;
  MemFou.Open;
  MenEntTail.Close;
  MenEntTail.Open;
  MenLigTail.Close;
  MenLigTail.Open;
  Resultat.Add('<H2><CENTER>' + 'Importation de ' + S + '</H2></CENTER>');
  Resultat.Add('<H3><CENTER>' + 'Le ' + DateTostr(Date) + '</H3></CENTER>');
  Document := TXMLCursor.Create;

  if FVersionBase > 11 then
  begin
    // gestion du paramétrage OBLIGATOIRE !!!
    // si ya pas alors ca marche pas !
    QRY_Div.Close();
//JB  Un seul domaine d’activité pour la centrale SPORT 2000
    QRY_Div.sql.Text := 'Select  ACT_ID, ACT_UNIID '
                      + 'from NKLACTIVITE		    			            join k on k_id = ACT_ID and k_enabled = 1 '
                      + 'join GENCENTRALE on CEN_ID = ACT_CENID  	join k on k_id = CEN_ID and k_enabled = 1 '
                      + 'join NKLUNIVERS  on UNI_ACTID = ACT_ID   join k on k_id = UNI_ID and k_enabled = 1 '
                      + 'where UNI_CENTRALE = CEN_CODE and CEN_CODE = 2 and UNI_NOM = ''FEDAS''';

//    QRY_Div.sql.Text := 'select act_id, act_uniid '
//                      + 'from nklactivite join k on k_id = act_id and k_enabled = 1 '
//                      + '  join gencentrale join k on k_id = cen_id and k_enabled = 1 on cen_id = act_cenid '
//                      + 'where cen_code = 2';
    try
      QRY_Div.Open();
      if QRY_Div.Eof or (QRY_Div.FieldByName('act_id').AsInteger = 0) or (QRY_Div.FieldByName('act_uniid').AsInteger = 0) then
      begin
        if pasFEDAS = 1 then
        begin     
          Resultat.Add('<FONT COLOR="red"><B>Les codes d''activité ne sont pas renseignés pour la centrale !</B></FONT><BR>');
            
          QRY_Div.SQL.Clear();         
          QRY_Div.SQL.Add('SELECT ACT_ID,');
          QRY_Div.SQL.Add('       ACT_UNIID,');
          QRY_Div.SQL.Add('       ACT_NOM,');
          QRY_Div.SQL.Add('       UNI_NOM');
          QRY_Div.SQL.Add('FROM NKLACTIVITE');
          QRY_Div.SQL.Add('  JOIN K KACT       ON (KACT.K_ID = ACT_ID AND KACT.K_ENABLED = 1)');
          QRY_Div.SQL.Add('  JOIN NKLUNIVERS   ON (UNI_ACTID = ACT_ID)');
          QRY_Div.SQL.Add('  JOIN K KUNI       ON (KUNI.K_ID = UNI_ID AND KUNI.K_ENABLED = 1)');
          QRY_Div.SQL.Add('WHERE UNI_OBLIGATOIRE = 1;');  
          
          QRY_Div.Open();   
          if QRY_Div.IsEmpty()
            or (QRY_Div.FieldByName('ACT_ID').AsInteger = 0)
            or (QRY_Div.FieldByName('ACT_UNIID').AsInteger = 0) then
          begin
            Resultat.Add('<font color="red"><b>La base n''a également pas d''univers obligatoire&nbsp;!</b></font><br />');
            Result := False;
          end
          else begin
            Resultat.Add(
              Format('<font color="blue"><b>Le secteur d''activité utilisé été "%0:s" sur l''univers "%1:s".</b></font><br />',
                [QRY_Div.FieldByName('ACT_NOM').AsString, QRY_Div.FieldByName('UNI_NOM').AsString])
            );
          end;          
        end
        else
        begin
          Resultat.Add('<FONT COLOR="red"><B>Les codes d''activité ne sont pas renseigné pour la centrale !</B></FONT><BR>');
          result := false;
        end;
      end;
    finally
      QRY_Div.Close();
    end;
  end;

   // pre traitement en cas de mode mono couleur actif
   bIsModeMonoCouleur := isModeGestionMonoCouleurActif();
   artFilePath := RepXML + 'ART_' + S + '.XML';
   barFilePath := RepXML + 'BAR_' + S + '.XML';
   dcdFilePath := RepXML + 'DCD_' + S + '.XML';
   IF (bIsModeMonoCouleur and fileExists(artFilePath) and fileExists(barFilePath) ) then
   BEGIN
       transformateurMultiMono.TransformerXmlMultiVersMonoCouleurs(artFilePath,barFilePath,dcdFilePath);
   END;


  {$REGION 'Recherche du fichier de fournisseur'}
  IF fileExists(RepXML + 'FOU_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des fournisseurs';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'FOU_' + S + '.XML');
    Document.Load(RepXML + 'FOU_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;

    // Sandrine 07-01-2008 : Identifier si c'est le nouveau format de fichier
    testtsl := TStringList.create;
    testtsl.LoadFromFile(RepXML + 'FOU_' + S + '.XML');
    FluxJanvier2008 := (pos('<IDMARQUE', testtsl.Text) <> 0);
    testtsl.free;

    CFOU := UPPERCASE(COPY(S, 1, pos('_', S) - 1));
    // Sandrine 07-01-2008 : Stocker dans MemFou les ID marque et Fou
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IF (TRIM(PassXML.GetValue('CFOU')) = '') THEN
        Insertion(MemFou, [PassXML.GetValue('ITEMID'), CFOU, CFOU, PassXML.GetValue('IDMARQUE'), PassXML.GetValue('IDFOURNISSEUR'), CFOU])
      ELSE
      BEGIN
        IF (TRIM(PassXML.GetValue('MARQUE')) = '') THEN
          Insertion(MemFou, [PassXML.GetValue('ITEMID'), PassXML.GetValue('CFOU'), PassXML.GetValue('LFOU'), PassXML.GetValue('IDMARQUE'), PassXML.GetValue('IDFOURNISSEUR'), PassXML.GetValue('CFOU')])
        ELSE
          Insertion(MemFou, [PassXML.GetValue('ITEMID'), PassXML.GetValue('CFOU'), PassXML.GetValue('LFOU'), PassXML.GetValue('IDMARQUE'), PassXML.GetValue('IDFOURNISSEUR'), PassXML.GetValue('MARQUE')]);
      END;
      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'FOU_' + S + '.XML' + ' N''existe pas Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  {$ENDREGION}

  {$REGION 'Recherche du fichier Taille'}
  IF fileExists(RepXML + 'TAI_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des tailles';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'TAI_' + S + '.XML');
    Document.Load(RepXML + 'TAI_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    PbTaille2008 := False;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      ITEMID := PassXML.GetValue('ITEMID');
      TailleNom := '';
      TailleNom := PassXML.GetValue('NOM');
      IF (TailleNom = '') THEN
      BEGIN
        TailleNom := 'IMPORT SP2000 - ' + ITEMID;
      END;
      // Sandrine 07-01-2008 : possibilité de travailler avec les grilles de tailles Ginkoia
      // FTH 2010-12-30 Modification de VALIDE à 1 pour créer toutes les tailles d'un article même s'il n'est pas commandé
      Insertion(MenEntTail, [ItemID, PassXML.GetValue('CTAI'), PassXML.GetValue('LTAI'), '1', TailleNom]);
      IF NOT (FluxJanvier2008 OR PbTaille2008) THEN
      BEGIN
        I := 1;
        testtsl := TStringList.create;
        testtsl.LoadFromFile(RepXML + 'TAI_' + S + '.XML');
        PbTaille2008 := (pos('<T' + Inttostr(i), testtsl.Text) = 0);
        testtsl.free;
        IF NOT PbTaille2008 THEN
        BEGIN
          WHILE PassXML.GetValue('T' + Inttostr(i)) <> '' DO
          BEGIN
            Insertion(MenLigTail, [ItemID, PassXML.GetValue('T' + Inttostr(i)), '0']);
            Inc(I);
          END;
        END;
      END;
      IF (FluxJanvier2008 OR PbTaille2008) THEN
      BEGIN
        PassXML3 := PassXML.Select('TAILLES');
        PassXML3 := PassXML3.Select('TAILLE');
        WHILE NOT PassXML3.eof DO
        BEGIN
          IF (PassXML3.GetValue('NOM') <> '') THEN
          BEGIN
            IF (PassXML3.GetValue('CODETAILLE') = '0') THEN
              Insertion(MenLigTail, [ItemID, PassXML3.GetValue('NOM'), '0', '0', ''])
            ELSE Insertion(MenLigTail, [ItemID, PassXML3.GetValue('NOM'), '0', '0', PassXML3.GetValue('CODETAILLE')])
          END;
          PassXML3.next;
        END
      END;
      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'TAI_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  {$ENDREGION}

  {$REGION 'Recherche du ficheir article'}
  MenArt.Close;
  MenArt.Open;
  MemD_COU.Close;
  MemD_COU.Open;
  IF fileExists(RepXML + 'ART_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des Articles';
    Lab_etat2.Update;
    testtsl := TStringList.create;
    testtsl.LoadFromFile(RepXML + 'ART_' + S + '.XML');
    IF pos('<COULEURS', testtsl.Text) = 0 THEN
    BEGIN
      testtsl.free;
      Application.MessageBox('Le fichier article est une ancienne version, veuillez le reconstruire avec le nouveau CD', 'Erreur', MB_OK);
      Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'ART_' + S + '.XML' + ' Est incorrect </B></FONT><BR>');
      result := false;
    END
    ELSE
    BEGIN
      // Sandrine 07-01-2008 : Identifier si le PVB existe ==> TOC
      TOC := (pos('<PVB', testtsl.Text) <> 0);
      // Sandrine 30-06-2008 : Gestion du DESIGN
      Design := (pos('<DESIGN', testtsl.Text) <> 0);
      // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
      FluxEM := (pos('<WEB', testtsl.Text) <> 0);
      testtsl.free;
      traiteFichier(RepXML + 'ART_' + S + '.XML');
      Document.Load(RepXML + 'ART_' + S + '.XML');
      PassXML := Document.Select('ITEM');
      pb2.Position := 0;
      pb2.Max := PassXML.Count;
      WHILE NOT PassXML.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        // Recupertration des couleurs
        PassXML2 := PassXML.Select('COULEURS');
        PassXML2 := PassXML2.Select('COULEUR');
        tsl := transforme(PassXML.select('*'));
        WHILE NOT PassXML2.eof DO
        BEGIN
          tsl2 := transforme(PassXML2.select('*'));
          CouNom := tsl2.Values['DESCRIPTIF'];
          // Sandrine 30-06-2008 : Gestion du DESIGN
          IF (Design AND (tsl2.Values['DESIGN'] <> '')) THEN
            CouNom := tsl2.Values['DESCRIPTIF'] + ' [' + tsl2.Values['DESIGN'] + ']';
          // FTH 2010-12-30 Ajout champ VALIDE = 1 pour que les couleurs soient générées même si elles ne sont pas commandées

          // LG Code couleur et description ok
          if (Trim(CouNom)<>'') and (Trim(tsl2.Values['IDCOLORIS'])<>'') then
          begin
            Insertion(MemD_COU, [tsl2.Values['IDCOLORIS'], tsl2.Values['CODECOLORIS'], CouNom, tsl.Values['ITEMID'],'1']);
          end;

          // LG Manque Description et Code couleur ok
          if (Trim(CouNom)='') and (Trim(tsl2.Values['IDCOLORIS'])<>'') then
          begin
            Insertion(MemD_COU, [tsl2.Values['IDCOLORIS'], tsl2.Values['CODECOLORIS'], tsl2.Values['CODECOLORIS'], tsl.Values['ITEMID'],'1']);
          end;

//          // LG Manque Description et Code couleur ok
//          if (Trim(CouNom)='') and (Trim(tsl2.Values['IDCOLORIS'])<>'') then
//          begin
//            Insertion(MemD_COU, [tsl2.Values['IDCOLORIS'], tsl2.Values['CODECOLORIS'], tsl2.Values['CODECOLORIS'], tsl.Values['ITEMID'],'1']);
//          end;

          // LG Manque Code couleur et Description ok
          if (Trim(CouNom)<>'') and (Trim(tsl2.Values['IDCOLORIS'])='') then
          begin
            Insertion(MemD_COU, [tsl2.Values['IDCOLORIS'], CouNom, CouNom, tsl.Values['ITEMID'],'1']);
          end;

          tsl2.free;
          PassXML2.Next;
        END;
        // à valider ???
        IF trim(tsl.Values['CFAM']) = '' THEN
          tsl.Values['CFAM'] := tsl.Values['CSAI'] + '/' + tsl.Values['ANNEE'];
        // ancien format la ref fourn est suivie de *Code_Couleur ==> faire le ménage !
        IF pos('*', tsl.Values['RFOU']) > 0 THEN
          tsl.Values['RFOU'] := Copy(tsl.Values['RFOU'], 1, pos('*', tsl.Values['RFOU']) - 1);
        IF (TRIM(tsl.Values['CFOU']) = '') THEN
          // Si pas de fournisseur cf. ligne 595 = lire le nom du fournisseur sur le nom du fichier
          tsl.Values['CFOU'] := CFOU;
        IF (TRIM(tsl.Values['MARQUE']) = '') THEN
          tsl.Values['MARQUE'] := CFOU;

        PV := enreal(tsl.Values['PV']);
        PVB := '0';
        IF (TOC AND (tsl.Values['PVB'] <> '') AND (NOT ((enreal(tsl.Values['PVB']) = '0') OR (enreal(tsl.Values['PVB']) = '1')))) THEN
        BEGIN
          PV := enreal(tsl.Values['PVB']);
          PVB := enreal(tsl.Values['PV']);
        END;

        IF NOT FluxJanvier2008 THEN
        BEGIN
          Insertion(MenArt, [tsl.Values['ITEMID'], tsl.Values['LIBELLE'],
            tsl.Values['CCOU'], tsl.Values['CR1'], tsl.Values['CFAM'],
              tsl.Values['CSAI'], tsl.Values['ANNEE'], tsl.Values['CTAI'],
              tsl.Values['CFOU'], tsl.Values['RFOU'], tsl.Values['MARQUE'],
              tsl.Values['LIBFRS'], tsl.Values['FEDAS'], tsl.Values['MONDOVELO'],
              enreal(tsl.Values['PA']), enreal(tsl.Values['PA']),
              PV, PVB,
              tsl.Values['CATMAN']]);
        END
        ELSE
        BEGIN
          PAnet := tsl.Values['PANET'];
          IF ((enreal(PAnet) = '0') OR (enreal(PAnet) = '1')) THEN
            PAnet := tsl.Values['PA'];
          IF NOT FluxEM THEN
          BEGIN
            Insertion(MenArt, [tsl.Values['ITEMID'], tsl.Values['LIBELLE'],
              tsl.Values['CCOU'], tsl.Values['CR1'], tsl.Values['CFAM'],
                tsl.Values['CSAI'], tsl.Values['ANNEE'], tsl.Values['CTAI'],
                tsl.Values['CFOU'], tsl.Values['RFOU'], tsl.Values['MARQUE'],
                tsl.Values['LIBFRS'], tsl.Values['FEDAS'], tsl.Values['MONDOVELO'],
                enreal(tsl.Values['PA']), enreal(PAnet),
                PV, PVB,
                tsl.Values['CATMAN'],
                tsl.Values['REFERENCECENTRALE'],
                tsl.Values['IDMARQUE'],
                tsl.Values['IDFOURNISSEUR'],
                tsl.Values['COLLECTION'],
                tsl.Values['GENRESP2K']]);
          END
          ELSE
          BEGIN // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
            Insertion(MenArt, [tsl.Values['ITEMID'], tsl.Values['LIBELLE'],
              tsl.Values['CCOU'], tsl.Values['CR1'], tsl.Values['CFAM'],
                tsl.Values['CSAI'], tsl.Values['ANNEE'], tsl.Values['CTAI'],
                tsl.Values['CFOU'], tsl.Values['RFOU'], tsl.Values['MARQUE'],
                tsl.Values['LIBFRS'], tsl.Values['FEDAS'], tsl.Values['MONDOVELO'],
                enreal(tsl.Values['PA']), enreal(PAnet),
                PV, PVB,
                tsl.Values['CATMAN'],
                tsl.Values['REFERENCECENTRALE'],
                tsl.Values['IDMARQUE'],
                tsl.Values['IDFOURNISSEUR'],
                tsl.Values['COLLECTION'],
                tsl.Values['GENRESP2K'],
                tsl.Values['WEB'],
                tsl.Values['ACTIVITE'],
                tsl.Values['SPECIFICITE']]);
          END;
        END;

        tsl.free;
        PassXML.next;
      END;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'ART_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  {$ENDREGION}

  {$REGION 'Rechercher Code à barres'}
  MenCB.Close;
  MenCB.Open;
  IF fileExists(RepXML + 'BAR_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des Codes Barres';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'BAR_' + S + '.XML');
    Document.Load(RepXML + 'BAR_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      tsl := transforme(PassXML.select('*'));
      IF tsl.values['BARRE'] <> '' THEN
      BEGIN
        IF NOT FluxJanvier2008 THEN
          Insertion(MenCB, [tsl.values['ITEMID'], tsl.values['RFOU'],
            tsl.values['GESCOM'], tsl.values['LTAI'], tsl.values['BARRE'],
              tsl.values['CODECOLORIS'], tsl.values['ARTICLEID']])
        ELSE
          Insertion(MenCB, [tsl.values['ITEMID'], tsl.values['RFOU'],
            tsl.values['GESCOM'], tsl.values['LTAI'], tsl.values['BARRE'],
              tsl.values['CODECOLORIS'], tsl.values['ARTICLEID'],
              tsl.values['IDCOLORIS'], tsl.values['CODETAILLE'],'2']); // FTH Ajout traitement CBI_LOC
      END;
      // FTH 2010-12-29
      IF tsl.values['BARREFRS'] <> '' THEN
      BEGIN
        IF NOT FluxJanvier2008 THEN
          Insertion(MenCB, [tsl.values['ITEMID'], tsl.values['RFOU'],
            tsl.values['GESCOM'], tsl.values['LTAI'], tsl.values['BARREFRS'],
              tsl.values['CODECOLORIS'], tsl.values['ARTICLEID']])
        ELSE
          Insertion(MenCB, [tsl.values['ITEMID'], tsl.values['RFOU'],
            tsl.values['GESCOM'], tsl.values['LTAI'], tsl.values['BARREFRS'],
              tsl.values['CODECOLORIS'], tsl.values['ARTICLEID'],
              tsl.values['IDCOLORIS'], tsl.values['CODETAILLE'],'3']);  // FTH Ajout traitement CBI_LOC
      END;

      PassXML.next;
      tsl.free;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'BAR_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  {$ENDREGION}

  {$REGION 'Entête Des commandes'}
  MenEntCom.Close;
  MenEntCom.Open;
  IF fileExists(RepXML + 'ECD_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des Entête de commande';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'ECD_' + S + '.XML');
    Document.Load(RepXML + 'ECD_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IDMRK := '';
      IDFOUR := '';
      IF FluxJanvier2008 THEN
      BEGIN
        IDMRK := PassXML.GetValue('IDMARQUE');
        IDFOUR := PassXML.GetValue('IDFOURNISSEUR');
      END;

      IF (TRIM(PassXML.GetValue('CFOU')) = '') THEN
        Insertion(MenEntCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          CFOU, PassXML.GetValue('DCDE'), PassXML.GetValue('CMAG'),
            PassXML.GetValue('DLIV'), PassXML.GetValue('CSAI'), PassXML.GetValue('ANNEE'),
            PassXML.GetValue('LLCLI'), PassXML.GetValue('LADR1'), PassXML.GetValue('LCPOS'),
            PassXML.GetValue('LVILLES')])
      ELSE IF ((IDMRK = '') AND (IDFOUR = '')) THEN
        Insertion(MenEntCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('CFOU'), PassXML.GetValue('DCDE'), PassXML.GetValue('CMAG'),
            PassXML.GetValue('DLIV'), PassXML.GetValue('CSAI'), PassXML.GetValue('ANNEE'),
            PassXML.GetValue('LLCLI'), PassXML.GetValue('LADR1'), PassXML.GetValue('LCPOS'),
            PassXML.GetValue('LVILLES')])
      ELSE
        Insertion(MenEntCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('CFOU'), PassXML.GetValue('DCDE'), PassXML.GetValue('CMAG'),
            PassXML.GetValue('DLIV'), PassXML.GetValue('CSAI'), PassXML.GetValue('ANNEE'),
            PassXML.GetValue('LLCLI'), PassXML.GetValue('LADR1'), PassXML.GetValue('LCPOS'),
            PassXML.GetValue('LVILLES'), IDMRK, IDFOUR]);

      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    { modification pour l'importation des articles seul
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'ECD_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false; }
  END;
  {$ENDREGION}

  {$REGION 'Lignes des commandes'}
  MenLigCom.Close;
  MenLigCom.Open;
  IF fileExists(RepXML + 'DCD_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des lignes de commande';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'DCD_' + S + '.XML');
    Document.Load(RepXML + 'DCD_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IF NOT FluxJanvier2008 THEN
      BEGIN
        Insertion(MenLigCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('RFOU'), PassXML.GetValue('LTAIL'),
            PassXML.GetValue('QTE'), enreal(PassXML.GetValue('PA')),
            PassXML.GetValue('CODECOLORIS'),
            PassXML.GetValue('ARTICLEID'),
            enreal(PassXML.GetValue('PA'))]);
      END
      ELSE
      BEGIN
        Insertion(MenLigCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('RFOU'), PassXML.GetValue('LTAIL'),
            PassXML.GetValue('QTE'), enreal(PassXML.GetValue('PA')),
            PassXML.GetValue('CODECOLORIS'),
            PassXML.GetValue('ARTICLEID'),
            PassXML.GetValue('PANET'),
            PassXML.GetValue('IDCOLORIS'),
            PassXML.GetValue('CODETAILLE')]);
      END;
      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    { modification pour l'importation des articles seul
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'DCD_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
    }
  END;
  {$ENDREGION}

  Document := NIL;

  {$REGION 'Retraitement des fichiers (Voir com dessous)'}
  IF result THEN
  BEGIN
    // retraitement des fichiers
    // faire sauter les articles qui n'appartiennenent pas a une commande (avec les codes barres)
    // marquer les tailles travaillées
    // supprimer les couleurs pas commandées
    resultat.add('Données présentes dans les fichiers d''importation<BR>');
    resultat.add('<PRE>');
    resultat.add(Format('%6d %s', [MemFou.RecordCount, 'Fournisseur(s)']));
    resultat.add(Format('%6d %s', [MenEntTail.RecordCount, 'Grille(s) de tailles']));
    resultat.add(Format('%6d %s', [MenArt.RecordCount, 'Article(s)']));
    resultat.add(Format('%6d %s', [MenCB.RecordCount, 'Code(s) Barre']));
    // modification pour les importations d'articles seuls
    IF fileExists(RepXML + 'ECD_' + S + '.XML') THEN
      resultat.add(Format('%6d %s', [MenEntCom.RecordCount, 'Commande(s)']));
    resultat.add('</PRE>');
    resultat.add('<P>');
    resultat.add('Vérifications des données');
    resultat.add('<PRE>');
    // modification pour les importations d'articles seuls
    IF fileExists(RepXML + 'ECD_' + S + '.XML') THEN
    BEGIN
      Lab_etat2.Caption := 'Traitement des Commandes ';
      Lab_etat2.Update;
      pb2.Position := 0;
      pb2.Max := MenEntCom.RecordCount;
      enl1 := 0;
      enl2 := 0;
      MenEntCom.First;
      WHILE NOT MenEntCom.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        QRYEVO('MAG_ID', 'GENMAGASIN', 'MAG_ID', 'MAG_CODEADH=' + QuotedStr(MenEntComCMAG.AsString));
        { pour les tests enlever l'accolade de fin pour ne pas tester le code Adh }

        IF qry_div.IsEmpty THEN
        BEGIN
          Application.MessageBox('Le code adhérent des fichiers n''est pas le code adhérent attendu', 'Erreur', Mb_ok);
          resultat.add('traitement interrompu par la présence d''un code adhérent inconnu');
          Resultat.Add('Importation avec problème');
          result := false;
          //EXIT;
          MenLigCom.First;
          WHILE NOT MenLigCom.eof DO
          BEGIN
            IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
            BEGIN
              MenLigCom.Delete;
              inc(enl1);
            END
            ELSE
              MenLigCom.Next;
          END;
          MenEntCom.delete;
        END
        ELSE {}
        BEGIN
          MenEntCom.Edit;
          MenEntComMAG_ID.Asinteger := qry_div.Fields[0].AsInteger;
          MenEntCom.Post;
          { plus de test sur le numéro de commande
                 QRYEVO('FOU_ID', 'ARTFOURN', 'FOU_ID', 'FOU_NOM=' + QuotedStr(MenEntComCFOU.AsString));
               if not qry_div.IsEmpty then
               begin
                  FOU_ID := qry_div.Fields[0].AsInteger;
                  QRYEVO('CDE_ID', 'COMBCDE', 'CDE_ID',
                     Format('CDE_FOUID=%d and CDE_NUMFOURN=%s', [FOU_ID, QuotedStr(MenEntComNUMCDE.AsString)]));
                  if not qry_div.IsEmpty then
                  begin
                     MenLigCom.First;
                     while not MenLigCom.eof do
                     begin
                        if MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString then
                        begin
                           MenLigCom.Delete;
                           Inc(enl2);
                        end
                        else
                           MenLigCom.Next;
                     end;
                     MenEntCom.delete;
                  end
                  else
                     MenEntCom.next;
               end
               else
               {}
          MenEntCom.next;
        END;
      END;
      IF enl1 > 0 THEN
        resultat.add(Format('%6d %s', [Enl1, 'commande(s) enlevée(s) car code adhérent inconnu']));
      IF enl2 > 0 THEN
        resultat.add(Format('%6d %s', [Enl2, 'commande(s) enlevée(s) car déjà présente(s)']));

      Lab_etat2.Caption := 'Traitement des articles ';
      Lab_etat2.Update;
      pb2.Position := 0;
      pb2.Max := MenArt.RecordCount;
      enl1 := 0;
      enl2 := 0;
      enl3 := 0;
      MenArt.first;
      first := true;
      WHILE NOT menart.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        // vérification que l'art est dans une ligne de commande
        ART := MenArtITEMID.AsString;
        GTAIL := MenArtCTAI.AsString;
        ok := false;
        MenLigCom.First;
        WHILE NOT MenLigCom.Eof DO
        BEGIN
          IF ART = MenLigComARTICLEID.AsString THEN
          BEGIN
            IF first OR (MenEntTailITEMID.AsString <> GTAIL) THEN
            BEGIN
              MenEntTail.First;
              WHILE NOT (MenEntTail.Eof) AND (MenEntTailITEMID.AsString <> GTAIL) DO
                MenEntTail.Next;
              IF (MenEntTailITEMID.AsString = GTAIL) THEN
              BEGIN
                MenEntTail.edit;
                MenEntTailVALIDE.AsInteger := 1;
                MenEntTail.Post;
              END;
            END;
            ok := True;
            MenLigTail.First;
            WHILE NOT (MenLigTail.eof) AND ((MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
              (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString)) DO
              MenLigTail.Next;

            IF (MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
              (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString) THEN
            BEGIN
              Application.MessageBox(Pchar('Article : ' + ART + ' dans la grille de taille ' + MenEntTailITEMID.AsString + ', la taille ' + MenLigComLTAIL.AsString + ' commandée n''existe pas'), 'Erreur', Mb_ok);
              resultat.add('traitement interrompu par la présence d''un code taille inconnu');
              resultat.add('Article : ' + ART + ' dans la grille de taille ' + MenEntTailITEMID.AsString + ', la taille ' + MenLigComLTAIL.AsString + ' commandée n''existe pas');
              Resultat.Add('Importation avec problème');
              result := false;

              EXIT;
            END;
            MenLigTail.edit;
            MenLigTailTRAVAIL.asinteger := 1;
            MenLigTail.Post;
            first := false;
            // Valider les couleurs commandée
            MemD_COU.First;
            IF FluxJanvier2008 AND (MenLigComIDCOLORIS.AsString <> '') THEN
              WHILE NOT (MemD_COU.Eof) AND
                ((MemD_COUITEMID.AsString <> ART) OR
                (MemD_COUIDCOLORIS.AsString <> MenLigComIDCOLORIS.AsString)) DO
                MemD_COU.next
            ELSE
              WHILE NOT (MemD_COU.eof) AND
                ((MemD_COUITEMID.AsString <> ART) OR (MemD_COUCODECOLORIS.AsString <> MenLigComCODECOLORIS.AsString)) DO
                MemD_COU.next;

            IF (MemD_COUITEMID.AsString <> ART) AND
              (MemD_COUCODECOLORIS.AsString <> MenLigComCODECOLORIS.AsString) THEN
            BEGIN
              Application.MessageBox(Pchar('Article : ' + ART + '  La couleur ' + MenLigComCODECOLORIS.AsString + ' commandée, n''existe pas en fiche article'), 'Erreur', Mb_ok);
              resultat.add('traitement interrompu par la présence d''un code couleur inconnu');
              resultat.add('Article : ' + ART + '  La couleur ' + MenLigComCODECOLORIS.AsString + ' commandée, n''existe pas en fiche article');
              Resultat.Add('Importation avec problème');
              result := false;

              EXIT;
            END;
            MemD_COU.edit;
            MemD_COUVALIDE.asinteger := 1;
            MemD_COU.Post;

          END;
          MenLigCom.Next;
        END;
        IF NOT ok THEN
        BEGIN
          // suppression des CB non utilisé
          MenCB.first;
          WHILE NOT MenCB.eof DO
          BEGIN
            IF MenCBRFOU.AsString = art THEN
            BEGIN
              MenCB.Delete;
              Inc(enl2);
            END
            ELSE
              MenCB.Next;
          END;
          // suppression des Couleurs non utilisé
          MemD_COU.First;
          WHILE NOT MemD_COU.eof DO
          BEGIN
            IF MemD_COUITEMID.AsString = art THEN
            BEGIN
              MemD_COU.Delete;
              Inc(enl3);
            END
            ELSE
              MemD_COU.Next;
          END;
          menart.Delete;
          Inc(enl1);
        END
        ELSE
        menart.Next;
      END;
      IF enl1 > 0 THEN
        resultat.add(Format('%6d %s', [Enl1, 'articles enlevés car inexistant dans une commande']));
      IF enl2 > 0 THEN
        resultat.add(Format('%6d %s', [Enl2, 'codes barres enlevés suite à la non prise en compte de l''article']));
      IF enl3 > 0 THEN
        resultat.add(Format('%6d %s', [Enl3, 'couleurs enlevés suite à la non prise en compte de l''article']));

      testtsl := tstringlist.create;
      Lab_etat2.Caption := 'Vérification des commandes ';
      Lab_etat2.Update;
      MenEntCom.First;
      first := true;
      pb2.Position := 0;
      pb2.Max := MenEntCom.RecordCount;
      WHILE NOT MenEntCom.Eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        MenLigCom.First;
        WHILE NOT MenLigCom.Eof DO
        BEGIN
          IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
          BEGIN
            // recherche de l'article
            MenArt.First;
            WHILE NOT (MenArt.eof) AND (MenArtITEMID.AsString <> MenLigComARTICLEID.AsString) DO
              MenArt.Next;
            // si pas trouvé sortie en erreur
            IF MenArtITEMID.AsString <> MenLigComARTICLEID.AsString THEN
            BEGIN
              IF first THEN
                resultat.add('<P>');
              testS := MenLigComRFOU.AsString + ';' + MenLigComNUMCDE.AsString;
              first := false;
              result := false;
              IF testtsl.indexof(testS) < 0 THEN
              BEGIN
                testtsl.add(testS);
                resultat.add('L''article ' + MenLigComRFOU.AsString + ' de la commande ' + MenLigComNUMCDE.AsString + ' n''existe pas');
              END;
            END;
          END;
          MenLigCom.next;
        END;
        MenEntCom.Next;
      END;
      testtsl.free;
      IF NOT result THEN
      BEGIN
        resultat.add('Impossible de continuer <br />');
        Resultat.Add('<b>Importation avec problème</b><br />');
        EXIT;
      END;
      Lab_etat2.Caption := 'Traitement des grilles de taille';
      Lab_etat2.Update;
      pb2.Position := 0;
      pb2.Max := MenEntTail.RecordCount;

// FTH 2010-12-30 Pour que toutes les tailles/Couleurs/CB se créent même s'ils ne sont pas dans une commande
//      MenEntTail.First;
//      enl1 := 0;
//      WHILE NOT MenEntTail.eof DO
//      BEGIN
//        pb2.Position := pb2.Position + 1;
//        IF MenEntTailVALIDE.AsInteger = 0 THEN
//        BEGIN
//          // supprimer les tailles associées
//          MenLigTail.First;
//          WHILE NOT MenLigTail.eof DO
//          BEGIN
//            IF MenLigTailITEMID.AsString = MenEntTailITEMID.AsString THEN
//              MenLigTail.delete
//            ELSE
//              MenLigTail.Next;
//          END;
//          MenEntTail.delete;
//          Inc(enl1);
//        END
//        ELSE
//          MenEntTail.next;
//      END;
//      IF enl1 > 0 THEN
//        resultat.add(Format('%6d %s', [Enl1, 'grille de taille enlevées car ne correspondant à aucun article en commande']));
      resultat.Add('</PRE>');

      resultat.add('<P>');
      resultat.add('Après nettoyage des fiches inutiles pour l''intégration<BR>');
      resultat.add('<PRE>');
      resultat.add(Format('%6d %s', [MemFou.RecordCount, 'Fournisseurs']));
      resultat.add(Format('%6d %s', [MenEntTail.RecordCount, 'Grilles de tailles']));
      resultat.add(Format('%6d %s', [MenArt.RecordCount, 'Articles']));
      resultat.add(Format('%6d %s', [MenCB.RecordCount, 'Codes Barre']));
      resultat.add(Format('%6d %s', [MenEntCom.RecordCount, 'Commande(s)']));
      resultat.add('</PRE>');
    END;
//  FTH 2010-12-30 Création systématique de toutes les couleurs
//    ELSE // Si pas de commande, créer toutes les couleurs
//    BEGIN
//      MemD_COU.First;
//      WHILE NOT (MemD_COU.eof) DO
//      BEGIN
//        MemD_COU.edit;
//        MemD_COUVALIDE.asinteger := 1;
//        MemD_COU.Post;
//
//        MemD_COU.next;
//      END;
   // END;

    resultat.add('<P>');
    IF MenArt.RecordCount > QttMaxArt THEN
    BEGIN
      resultat.add('traitement interrompu, pour des raisons de sauvegarde des données, nous ne pouvons intégrer que ' + Inttostr(QttMaxArt) + ' articles');
      Resultat.Add('Importation avec problème');
      result := false;
      EXIT;
    END;
    resultat.add('<BR>');
    IF result THEN
    BEGIN
      TRY
        Importe(S);
        Resultat.Add('Importation terminée avec succès');
      EXCEPT
        ON E: Exception DO
        BEGIN
          Resultat.Add('Importation avec problème<BR>');
          result := false;
          Resultat.Add(E.Message);
        END;
      END;
    END;
  END;
  {$ENDREGION}
END;

PROCEDURE TFrm_IntNikePrin.Traitement1Click(Sender: TObject);
VAR
  nbf, nbf2: integer;
  nomfic: STRING;
  ImportBL : TBLAuto;
  ImportRetour : Boolean;
BEGIN
  try
    Data.Open();

    // récupération GUID et MAG_ID
    GetBaseInfo(GREF,GMAGID);

    // Initialisation du log
    Log.App := 'IntegNike';
    Log.Ref := GREF;
    Log.Mag := IntToStr(GMAGID);
    Log.Open;
    Log.saveIni();


    Log.Log('MAIN', GREF, IntToStr(GMAGID), 'VERSION', GetNumVersionSoft ,logInfo);

    Log.Log('MAIN', GREF, IntToStr(GMAGID), 'STATUS', 'Démarrage traitement' ,logInfo, True);

    QRY_Div.SQL.Text := 'select ver_version from genversion order by ver_date desc rows 1;';
    QRY_Div.Open();
    if QRY_Div.Eof then
    begin
      MessageDlg('Version de la base non trouvé.', mtError, [mbOK], 0);
      QRY_Div.Close();
    end
    else
    begin
      FVersionBase := StrToInt(Copy(QRY_Div.FieldByName('ver_version').AsString, 1, Pos('.', QRY_Div.FieldByName('ver_version').AsString) -1));
      QRY_Div.Close();

      Resultat := TstringList.Create;

      Log.Log('MAIN', GREF, IntToStr(GMAGID), 'STATUS', 'Traitement Répertoire XML JA' ,logInfo, False);
      nbf := Traitement(repxml1); //*Repertoire outil JA XML*/
      Log.Log('MAIN', GREF, IntToStr(GMAGID), 'STATUS', 'Traitement Répertoire XML' ,logInfo, False);
      nbf2 := traitement(repxml2); //*Répertoire XML*/

      // TF: Mise en place nouveau traitement REPBL
      Log.Log('MAIN', GREF, IntToStr(GMAGID), 'STATUS', 'Traitement Répertoire BL' ,logInfo, False);
      ImportBL := TBLAuto.Create(Data);
      ImportBL.BLDirectory := RepBl;
      ImportBL.ImportBLAuto;
      ImportRetour := ImportBL.GenerationRapport(Resultat);

      // Sandrine : mise en place du code '-1' pour identifier une erreure
      IF (nbf = -1) OR (nbf2 = -1) THEN
        Application.MessageBox('ERREUR lors du Traitement', 'Intégration des documents', MB_OK)
      ELSE
      BEGIN
        IF ((nbf + nbf2) = 0) and not ImportRetour THEN
        begin
          Application.MessageBox('Aucun document à traiter', 'Intégration des documents', MB_OK);
          Exit;
        end
        ELSE
          Application.MessageBox('Traitement terminé', 'Intégration des documents', MB_OK);
      END;

      nomfic := FormatDateTime('YYYY"-"MM"-"DD" "HH"H"NN', now);
      Resultat.Savetofile(RepXML1 + nomfic + '.HTML');
      Resultat.free;
      ShellExecute(Application.handle, 'open', Pchar(RepXML1 + nomfic + '.HTML'), NIL, '', SW_SHOWDEFAULT);
    end;
  finally
    Data.Close();
    Close;
  end;
END;

FUNCTION TFrm_IntNikePrin.Traitement(rep: STRING): integer;
VAR
  f: Tsearchrec;

  i: Integer;
  s: STRING;
  ok: boolean;

BEGIN
  result := 0;
  repxml := rep;
  FluxJanvier2008 := False;
  FluxEM := False;
  //Supprime les accents des fichiers XML à Traiter
  forcedirectories(RepXML);
  IF FindFirst(RepXML + '*.XML', faAnyFile, F) = 0 THEN
  BEGIN
    REPEAT
      S := F.Name;
      SupprAccent(IncludeTrailingPathDelimiter(RepXML)+S);
    UNTIL FindNext(F) <> 0;
  END;

  // recherche les fichiers a traiter
  // le premier c'est FOU_xxx
  LesFichiers := TStringList.create;
  ok := true;
  forcedirectories(RepXML);
  IF FindFirst(RepXML + 'FOU*.XML', faAnyFile, F) = 0 THEN
  BEGIN
    REPEAT
      S := F.Name;
      SupprAccent(IncludeTrailingPathDelimiter(RepXML)+S);
      IF FileExists(RepXML + 'INTEGRES\' + S) THEN
      BEGIN
        IF Application.MessageBox(Pchar('Le fichier ' + S + ' a déjà été traité,'#10#13'êtes-vous sur de vouloir le traiter de nouveau ?'), 'Importation', MB_YESNO + MB_DEFBUTTON2) = mrno THEN
        BEGIN
          ok := false;
          BREAK;
        END;
      END;
      S := Copy(S, 5, 255);
      S := Copy(S, 1, Pos('.', S) - 1);
      LesFichiers.add(S);
    UNTIL FindNext(F) <> 0;
  END;
  FindClose(F);
  IF ok AND (LesFichiers.Count > 0) THEN
  BEGIN
    Resultat.Add('<HTML>');
    Resultat.Add('<head>');
    Resultat.Add('<title>' + 'Importation ' + Datetostr(Date) + '</title>');
    Resultat.Add('</head>');
    Resultat.Add('<body>');
    Resultat.Add('<FONT SIZE="-2">');
    Resultat.Add('Ce document est sauvegardé dans le répertoire de votre importation, il peut être imprimé par le menu fichier imprimer ou par la combinaison de touches CTRL-P<BR>');
    Resultat.Add('</FONT>');

    Pb1.Position := 0;
    pb1.Max := LesFichiers.Count;
    FOR i := 0 TO LesFichiers.Count - 1 DO
    BEGIN
      Pb1.position := i + 1;
      Lab_etat1.caption := 'Vérification de ' + LesFichiers[i];
      Lab_etat1.Update;

      IF Verif(LesFichiers[i]) THEN
      BEGIN
        ForceDirectories(RepXML + 'INTEGRES');
        DeleteFile(RepXML + 'INTEGRES\ART_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'ART_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\ART_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'INTEGRES\BAR_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'BAR_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\BAR_' + LesFichiers[i] + '.XML'));
        // modification pour les importations d'articles seul
        IF FileExists(RepXML + 'DCD_' + LesFichiers[i] + '.XML') THEN
        BEGIN
          DeleteFile(RepXML + 'INTEGRES\DCD_' + LesFichiers[i] + '.XML');
          MoveFile(Pchar(RepXML + 'DCD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\DCD_' + LesFichiers[i] + '.XML'));
        END;
        IF FileExists(RepXML + 'ECD_' + LesFichiers[i] + '.XML') THEN
        BEGIN
          DeleteFile(RepXML + 'INTEGRES\ECD_' + LesFichiers[i] + '.XML');
          MoveFile(Pchar(RepXML + 'ECD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\ECD_' + LesFichiers[i] + '.XML'));
        END;
        DeleteFile(RepXML + 'INTEGRES\FOU_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'FOU_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\FOU_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'INTEGRES\TAI_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'TAI_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\TAI_' + LesFichiers[i] + '.XML'));
        result := LesFichiers.count;
      END
      ELSE
      BEGIN
        ForceDirectories(RepXML + 'PROBLEMES');
        DeleteFile(RepXML + 'PROBLEMES\ART_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'ART_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\ART_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\BAR_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'BAR_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\BAR_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\DCD_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'DCD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\DCD_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\ECD_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'ECD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\ECD_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\FOU_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'FOU_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\FOU_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\TAI_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'TAI_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\TAI_' + LesFichiers[i] + '.XML'));
        result := -1;
      END;

      Resultat.Add('<P>');
    END;
    Resultat.Add('</body>');
    Resultat.Add('</HTML>');
    //        nomfic := FormatDateTime('YYYY"-"MM"-"DD" "HH"H"NN', now);
    //        Resultat.Savetofile(RepXML + nomfic + '.HTML');
    //        Resultat.free;
    //        ShellExecute(Application.handle, 'open', Pchar(RepXML + nomfic + '.HTML'), NIL, '', SW_SHOWDEFAULT);
  END;
  Lab_etat1.caption := '';
  Lab_etat1.Update;
  Pb1.Position := 0;

  LesFichiers.free;
END;

FUNCTION TFrm_IntNikePrin.InsertK(Clef: Int64; Table: STRING): TStringList;
BEGIN
  Table := Uppercase(Table);
  Qry_Div2.Close;
  WITH Qry_Div2.Sql DO
  BEGIN
    Clear;
    Add('SELECT KTB_ID FROM KTB Where KTB_NAME = ' + QuotedStr(table));
  END;
  Qry_Div2.Open;
  result := tstringList.create;
  result.Add('Insert Into K');
  result.Add(' (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
  result.Add(' VALUES ');
  result.Add(' (' + IntToStr(Clef) + ',' + IntToStr(Clef) + ',' + Qry_Div2.Fields[0].AsString + ',' + IntToStr(Clef) + ',1,-1,-1,Current_Date,0,''01/01/1980'',-1,Current_Date,' + IntToStr(Clef) + ',' + IntToStr(Clef) + ')');
  Qry_Div2.Close;
END;

PROCEDURE TFrm_IntNikePrin.AjouteScrQry(Script: TstringList; Table, Champs, Valeur: STRING; Valu: ARRAY OF CONST);
BEGIN
  AjouteScr(Script, ['INSERT INTO ' + Table + '(' + Champs + ') Values',
    Format('(' + Valeur + ')', Valu)]);
END;

PROCEDURE TFrm_IntNikePrin.MajScrQry(Script: TstringList; Table, Champs: STRING; Valu: ARRAY OF CONST; Cle, CleValeur: STRING);
BEGIN
  AjouteScr(Script, ['UPDATE ' + Table + ' SET ', Format(Champs, Valu),
    ' WHERE ' + Cle + '=' + CleValeur]);
  If Gestion_K_VERSION=TKV64 then
    AjouteScr(Script, ['UPDATE K SET K_Version = Gen_ID(VERSION_ID,1), KMA_LOCK_ID=Gen_ID(VERSION_ID,0), KSE_LOCK_ID=Gen_ID(VERSION_ID,0),KRH_ID=Gen_ID(VERSION_ID,0), K_UPDATED =CURRENT_TIMESTAMP WHERE K_ID=' + CleValeur])
  else
    AjouteScr(Script, ['UPDATE K SET K_Version = Gen_ID(General_Id,1), KMA_LOCK_ID=Gen_ID(General_Id,0), KSE_LOCK_ID=Gen_ID(General_Id,0),KRH_ID=Gen_ID(General_Id,0), K_UPDATED =CURRENT_TIMESTAMP WHERE K_ID=' + CleValeur]);
END;

PROCEDURE TFrm_IntNikePrin.AjouteScr(Script: TstringList; S: ARRAY OF STRING);
VAR
  i: integer;
BEGIN
  FOR i := 0 TO high(S) DO
    Script.add(S[i]);
  Script.Add('¤¤¤');
END;

FUNCTION TFrm_IntNikePrin.AjoutCleScript(Script: TstringList; TABLE: STRING): Integer;
VAR
  Pass: TstringList;
BEGIN
  Result := UneClef;
  Pass := InsertK(result, Table);
  Script.AddStrings(Pass);
  Pass.free;
  Script.Add('¤¤¤');
END;

procedure TFrm_IntNikePrin.Check_Mode_K_VERSION;
var
  QueTmp: TIBQuery;
  vK_ENABLED: string;
  vVERSION_ID: boolean;
  vDependance_VERSION_ID: boolean;
begin
  if (FGestion_K_VERSION = TKNone) then
  begin
    vK_ENABLED := 'int32';
    vVERSION_ID := false;
    vDependance_VERSION_ID := false;
    QueTmp := TIBQuery.Create(Self);
    try
      QueTmp.Database.DatabaseName := Data.DatabaseName;
        //----------------------------------------------
      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT r.RDB$RELATION_NAME,  ');
      QueTmp.SQL.Add('     r.RDB$FIELD_NAME,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_TYPE,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_SUB_TYPE,   ');
      QueTmp.SQL.Add('     f.RDB$FIELD_LENGTH      ');
      QueTmp.SQL.Add(' FROM RDB$RELATION_FIELDS r  ');
      QueTmp.SQL.Add(' JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME         ');
      QueTmp.SQL.Add(' WHERE r.RDB$RELATION_NAME=''K'' AND r.RDB$FIELD_NAME=''K_VERSION'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
      begin
        if QueTmp.FieldByName('RDB$FIELD_TYPE').asinteger = 16 then
          vK_ENABLED := 'int64'
        else
        begin
          FGestion_K_VERSION := TKV32;
          exit;
        end;
      end;
      QueTmp.close();

      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT * FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME=''VERSION_ID'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
        vVERSION_ID := true
      else
        exit;

      QueTmp.close;
      QueTmp.SQL.Clear;
      if (vVERSION_ID) then
      begin
        QueTmp.close;
        QueTmp.SQL.Clear;
        QueTmp.SQL.Add('SELECT * FROM RDB$DEPENDENCIES WHERE RDB$DEPENDED_ON_NAME=''VERSION_ID'' AND RDB$DEPENDENT_NAME=''PR_UPDATEK'' ');
        QueTmp.open();
        if not (QueTmp.eof) then
          vDependance_VERSION_ID := true
        else
          exit;
      end;
    
        // On peut également controler qu'il est dans sa tranche etc...
      QueTmp.close;
    finally
      if (vK_ENABLED = 'int64') and (vVERSION_ID) and (vDependance_VERSION_ID) then
        FGestion_K_VERSION := TKV64;

      QueTmp.Free;
    end;
  end;
end;

PROCEDURE TFrm_IntNikePrin.Importe(NOM: STRING);
VAR
  i, j, k: integer;
  TGT_ID: Integer;
  GTF_ID: Integer;
  Script: TstringList;
  FOU_ID, FOD_ID, MRK_ID: Integer;
  ACT_ID, SEC_ID, RAY_ID, FAM_ID, SSF_ID: Integer;
  UNI_ID: Integer;
  TVA_ID: Integer;
  TVA_TAUX : Double;
  TCT_ID: Integer;
  ART_ID, ARF_ID, ARX_ID, COU_ID: Integer;
  MAG_ID: Integer;
  TGF_ID: Integer;
  GRE_ID, SEXE, REFERENCECENTRALE: Integer;
  S: STRING;
  COL_ID: Integer;
//JB
  COL_IDMemo: Integer;
//
  CDE_ID: Integer;
  CDL_ID: Integer;
  Prix: Double;
  NumCDE, NumCDE_Fou: STRING;
  EXE_ID: Integer;
  DATE_COM: STRING;
  DATE_LIV: STRING;
  Chrono: STRING;
  Premier: STRING;
  Dernier: STRING;
  CC, CL: STRING;
  Ok: Boolean;
  LaMarque, UNI: STRING;
  remise, Px, PvI: Double;
  ARTIDREF, GTFIDREF: Integer;
  IDWeb, WebId, IdAct, IdSpec, ClaId, CitId: Integer;
  bFaireFedas: boolean;
  sIdMondovelo: string;  // c'est l'ID de la sous-famille importer
  IdMondovelo: integer;  // c'est l'ID de la sous-famille importer
  isExistFicheModele : boolean;
  iNbTAilBase, iNewTail, OldArtiID : Integer;
BEGIN
  Script := TstringList.Create;
  MenSSF.close;
  MenSSF.Open;
  MemD_Genre.close;
  MemD_Genre.Open;
  // Fabrication du script d'importation
  // Même ordre que Husky 1° grille de taille
  // recherche de la catégorie IMPORT SP2000
  QRY(['SELECT TGT_ID FROM PLXTYPEGT',
    ' join k on (K_id=TGT_ID and K_ENABLED=1)',
      'Where TGT_NOM = ''REFERENCEMENT''']);                     
  IF QRY_Div.IsEmpty THEN
  BEGIN
    QRY(['SELECT MAX(TGT_ORDREAFF)+10 FROM PLXTYPEGT',
      ' join k on (K_id=TGT_ID and K_ENABLED=1)']);
    TGT_ID := AjoutCleScript(Script, 'PLXTYPEGT');
    IF QRY_Div.fields[0].IsNull THEN
      AjouteScrQry(Script, 'PLXTYPEGT', 'TGT_ID,TGT_NOM,TGT_ORDREAFF', '%d,''REFERENCEMENT'',%s',
        [TGT_ID, '1'])
    ELSE
      AjouteScrQry(Script, 'PLXTYPEGT', 'TGT_ID,TGT_NOM,TGT_ORDREAFF', '%d,''REFERENCEMENT'',%s',
        [TGT_ID, QRY_Div.fields[0].AsString]);
  END
  ELSE
    TGT_ID := QRY_Div.fields[0].AsInteger;
  Lab_etat2.Caption := 'Création des grilles de tailles';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := MenEntTail.recordcount;

  // Ajout des grilles de tailles
  IF FluxJanvier2008 THEN
  BEGIN
    MenLigTail.First;
    WHILE NOT MenLigTail.eof DO
    BEGIN
      IF (MenLigTailCODETAILLE.AsString <> '') THEN
      BEGIN
        QRY(['SELECT TGF_ID, TGF_GTFID', 'From PLXTAILLESGF Join k on (K_ID=TGF_ID and K_ENABLED=1)',
          'WHERE TGF_ID<>0 and TGF_ID = ' + QuotedStr(UpperCase(MenLigTailCODETAILLE.AsString))]);
        IF NOT (Qry_div.IsEmpty) THEN
        BEGIN
          MenLigTail.edit;
          MenLigTailTGF_ID.Asinteger := qry_div.Fields[0].AsInteger;
          MenLigTail.Post;
          GTF_ID := qry_div.Fields[1].AsInteger;
          // mettre l'id de la Grille de taille
          MenEntTail.first;
          WHILE NOT MenEntTail.eof DO
          BEGIN
            IF (MenLigTailITEMID.AsString = MenEntTailITEMID.AsString) THEN
            BEGIN
              MenEntTail.Edit;
              MenEntTailGTF_ID.AsInteger := GTF_ID;
              MenEntTail.Post;
            END;
            MenEntTail.next;
          END;
        END;
      END;
      MenLigTail.next;
    END
  END;
  // dans tous les cas on refait un tour pour traiter tout ce qui ne rentre pas dans
  // les grilles Native Ginkoia ==> comme avant quoi !!
  MenEntTail.first;
  WHILE NOT MenEntTail.eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    // GRILLE DE TAILLE
    // Si GTF_ID n'est pas défini c'est que la grille est a crée
    IF ((MenEntTailGTF_ID.AsInteger = 0) OR (MenEntTailGTF_ID.asString = '')) THEN
    BEGIN
      QRY(['SELECT GTF_ID', 'From PLXGTF Join k on (K_ID=GTF_ID and K_ENABLED=1)',
        'WHERE GTF_ID<>0 and ((UPPER(GTF_NOM) = ' + QuotedStr(UpperCase(MenEntTailNOM.AsString)) + ') or (UPPER(GTF_NOM) CONTAINING ' + QuotedStr(UpperCase(MenEntTailITEMID.AsString)) + '))']);
      IF Qry_div.IsEmpty THEN
      BEGIN
        QRY(['SELECT MAX(GTF_ORDREAFF)+10 FROM PLXGTF',
          ' join k on (K_id=GTF_ID and K_ENABLED=1)']);
        GTF_ID := AjoutCleScript(Script, 'PLXGTF');
        // Sandrine : 2008 07 01 - tester si IDREF n'est pas un INTEGER
        TRY
          GTFIDREF := MenEntTailITEMID.AsInteger;
        EXCEPT
          GTFIDREF := 0;
        END;
        AjouteScrQry(Script, 'PLXGTF', 'GTF_ID, GTF_IDREF, GTF_NOM, GTF_TGTID, GTF_ORDREAFF, GTF_IMPORT',
          '%d,%d,%s,%d,%s,1', [GTF_ID, GTFIDREF, QuotedStr(UpperCase(MenEntTailNOM.AsString)), TGT_ID, QRY_Div.fields[0].AsString]);
      END
      ELSE GTF_ID := Qry_div.Fields[0].AsInteger;
      MenEntTail.Edit;
      MenEntTailGTF_ID.AsInteger := GTF_ID;
      MenEntTail.Post;
    END
    ELSE GTF_ID := MenEntTailGTF_ID.AsInteger;

    // TAILLE de la grille
    MenLigTail.First;
    QRYEVO('(MAX (TGF_ORDREAFF)+1)*10, Count(*)+1', 'PLXTAILLESGF', 'TGF_ID', format('TGF_GTFID=%d', [GTF_ID]));
    IF qry_div.Fields[0].IsNull THEN
      J := 10
    ELSE
      j := qry_div.Fields[0].AsInteger;
    IF qry_div.Fields[1].IsNull THEN
      K := 1
    ELSE
      K := qry_div.Fields[1].AsInteger;
    WHILE NOT MenLigTail.eof DO
    BEGIN
      // Si TGF_ID n'est pas défini c'est que la taille est a crée
      IF ((MenLigTailTGF_ID.AsInteger = 0) OR (MenLigTailTGF_ID.AsString = '')) THEN
      BEGIN
        IF MenLigTailITEMID.AsString = MenEntTailITEMID.AsString THEN
        BEGIN
          QRYEVO('TGF_ID', 'PLXTAILLESGF', 'TGF_ID',
            format('UPPER(TGF_NOM) =%s and TGF_GTFID=%d', [QuotedStr(UpperCase(MenLigTailTAILLE.AsString)), GTF_ID]));
          IF qry_div.isempty THEN
          BEGIN
            i := AjoutCleScript(Script, 'PLXTAILLESGF');
            AjouteScrQry(Script, 'PLXTAILLESGF',
              'TGF_ID,TGF_GTFID,TGF_IDREF,TGF_TGFID,TGF_NOM,TGF_CORRES,TGF_ORDREAFF,TGF_STAT',
              '%d,%d,0,%d,%s,'''',%d,%d',
              [i, GTF_ID, i, QuotedStr(UpperCase(MenLigTailTAILLE.AsString)), j, k]);
            inc(j, 10);
            inc(k);
            MenLigTail.edit;
            MenLigTailTGF_ID.Asinteger := i;
            MenLigTail.Post;
          END
          ELSE
          BEGIN
            MenLigTail.edit;
            MenLigTailTGF_ID.Asinteger := qry_div.Fields[0].AsInteger;
            MenLigTail.Post;
          END;
        END;
      END;
      MenLigTail.Next;
    END;
    MenEntTail.next;
  END;
  // Ajout des fournisseurs
  Lab_etat2.Caption := 'Création des fournisseurs';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := MemFou.recordcount;
  MemFou.First;
  MemD_Marque.Close;
  MemD_Marque.Open;
  MemD_Liais.close;
  MemD_Liais.open;
  WHILE NOT MemFou.Eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    FOU_ID := 0;
    IF FluxJanvier2008 THEN
    BEGIN  // ARTFOURN
      QRYEVO('IMP_GINKOIA', 'GENIMPORT', 'IMP_ID', 'IMP_NUM=4 and IMP_KTBID=-11111385 and IMP_REF=' + QuotedStr(UpperCase(MemFouIDFOURNISSEUR.AsString)));
      IF NOT (qry_div.isempty) THEN
      BEGIN
        FOU_ID := qry_div.Fields[0].AsInteger;
      END;
    END;
    IF (FOU_ID = 0) THEN
    BEGIN
      QRYEVO('FOU_ID', 'ARTFOURN', 'FOU_ID', 'UPPER(FOU_NOM)=' + QuotedStr(UpperCase(MemFouCFOU.AsString)));
      IF qry_div.isempty THEN
      BEGIN
        i := AjoutCleScript(Script, 'GENADRESSE');
        AjouteScrQry(Script, 'GENADRESSE',
          'ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT',
          '%d,'''',0,'''','''','''','''',''''', [i]);
        FOU_ID := AjoutCleScript(Script, 'ARTFOURN');
        AjouteScrQry(Script, 'ARTFOURN',
          'FOU_ID,FOU_IDREF,FOU_NOM,FOU_ADRID,FOU_TEL,FOU_FAX,FOU_EMAIL,FOU_REMISE,FOU_GROS,FOU_CDTCDE,FOU_CODE,FOU_TEXTCDE',
          '%d,1,%s,%d,'''','''','''',0,0,'''','''',''''',
          [FOU_ID, QuotedStr(UpperCase(MemFouCFOU.AsString)), i]);
        FOD_ID := AjoutCleScript(Script, 'ARTFOURNDETAIL');
        AjouteScrQry(Script, 'ARTFOURNDETAIL',
          'FOD_ID,FOD_FOUID,FOD_MAGID,FOD_FTOID,FOD_MRGID,FOD_CPAID',
          '%d,%d,0,0,0,0',
          [FOD_ID, FOU_ID]);
      END
      ELSE
        Fou_ID := qry_div.Fields[0].AsInteger;
      // Mettre à jour GENIMPORT
      IF FluxJanvier2008 THEN
      BEGIN  // ARTFOURN
        i := AjoutCleScript(Script, 'GENIMPORT');
        AjouteScrQry(Script, 'GENIMPORT',
          'IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM',
          '%d,-11111385,%d,%d,4',
          [i, FOU_ID, MemFouIDFOURNISSEUR.AsInteger]);
      END;
    END;

    MRK_ID := 0;
    LaMarque := UpperCase(MemFouMARQUE.AsString);
    IF FluxJanvier2008 THEN
    BEGIN  // ARTMARQUE
      QRYEVO('IMP_GINKOIA', 'GENIMPORT', 'IMP_ID', 'IMP_NUM=4 and IMP_KTBID=-11111392 and IMP_REF=' + QuotedStr(UpperCase(MemFouIDMARQUE.AsString)));
      IF NOT (qry_div.isempty) THEN
      BEGIN
        MRK_ID := qry_div.Fields[0].AsInteger;
        MemD_Marque.insert;
        MemD_MarqueMARQUE.AsString := LaMarque;
        MemD_MarqueMRK_ID.Asinteger := MRK_ID;
        MemD_MarqueIDMARQUE.AsString := MemFouIDMARQUE.AsString;
        MemD_Marque.post
      END;
    END;
    IF (MRK_ID = 0) THEN
    BEGIN
      IF (LaMarque = '') THEN
        LaMarque := UpperCase(MemFouCFOU.AsString);
      QRYEVO('MRK_ID', 'ARTMARQUE', 'MRK_ID', 'UPPER(MRK_NOM)=' + QuotedStr(LaMarque));
      IF qry_div.isempty THEN
      BEGIN
        MRK_ID := AjoutCleScript(Script, 'ARTMARQUE');
        AjouteScrQry(Script, 'ARTMARQUE',
          'MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE',
          '%d,1,%s,'''',''''',
          [MRK_ID, QuotedStr(LaMarque)]);
        MemD_Marque.insert;
        MemD_MarqueMARQUE.AsString := LaMarque;
        MemD_MarqueMRK_ID.Asinteger := MRK_ID;
        MemD_MarqueIDMARQUE.AsString := MemFouIDMARQUE.AsString;
        MemD_Marque.post
      END
      ELSE
      BEGIN
        MRK_ID := qry_div.Fields[0].AsInteger;
        MemD_Marque.first;
        WHILE NOT (MemD_Marque.eof) AND (UpperCase(MemD_MarqueMARQUE.AsString) <> LaMarque) DO
          MemD_Marque.next;
        IF MemD_Marque.eof THEN
        BEGIN
          MemD_Marque.insert;
          MemD_MarqueMARQUE.AsString := LaMarque;
          MemD_MarqueMRK_ID.Asinteger := MRK_ID;
          MemD_MarqueIDMARQUE.AsString := MemFouIDMARQUE.AsString;
          MemD_Marque.post
        END;
      END;
      // Mettre à jour GENIMPORT
      IF FluxJanvier2008 THEN
      BEGIN // ARTMARQUE
        i := AjoutCleScript(Script, 'GENIMPORT');
        AjouteScrQry(Script, 'GENIMPORT',
          'IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM',
          '%d,-11111392,%d,%d,4',
          [i, MRK_ID, MemFouIDMARQUE.AsInteger]);
      END;
    END;

    MemFou.edit;
    MemFouFOU_ID.AsInteger := FOU_ID;
    MemFouMRK_ID.AsInteger := MRK_ID;
    MemFou.Post;
    QRYEVO('FMK_ID', 'ARTMRKFOURN', 'FMK_ID', Format('FMK_FOUID=%d and FMK_MRKID=%d', [FOU_ID, MRK_ID]));
    IF qry_div.isempty THEN
    BEGIN
      // regarder si la marque est déja ref avec un fou principal
      QRYEVO('FMK_ID', 'ARTMRKFOURN', 'FMK_ID', Format('FMK_MRKID=%d AND FMK_PRIN=1', [MRK_ID]));
      IF qry_div.isempty THEN
      BEGIN
        i := AjoutCleScript(Script, 'ARTMRKFOURN');
        AjouteScrQry(Script, 'ARTMRKFOURN',
          'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
          '%d,%d,%d,1',
          [I, FOU_ID, MRK_ID]);
      END
      ELSE
      BEGIN
        i := AjoutCleScript(Script, 'ARTMRKFOURN');
        AjouteScrQry(Script, 'ARTMRKFOURN',
          'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
          '%d,%d,%d,0',
          [I, FOU_ID, MRK_ID]);
      END;
    END;
    MemD_Liais.insert;
    MemD_LiaisFOU_ID.AsInteger := FOU_ID;
    MemD_LiaisMRK_ID.AsInteger := MRK_ID;
    MemD_Liais.Post;

    MemFou.Next;
  END;

  // Création des paramétres

  QRY(['select tva_id, tva_taux from arttva join k on k_id = tva_id and k_enabled = 1 where tva_taux = (select dos_float from gendossier where dos_nom = ''TVA'') order by tva_id;']);
  TVA_ID := qry_div.FieldByName('tva_id').AsInteger;
  TVA_TAUX := qry_div.FieldByName('tva_taux').AsInteger;

  QRYEVO('TCT_ID', 'ARTTYPECOMPTABLE', 'TCT_ID', 'TCT_CODE=1');
  TCT_ID := qry_div.Fields[0].AsInteger;

  // recherche de l'univers
  if FVersionBase > 11 then
  begin
    QRY_Div.Close();
//JB  Un seul domaine d’activité pour la centrale SPORT 2000
    QRY_Div.sql.Text := 'Select ACT_ID, ACT_UNIID '
                      + 'from NKLACTIVITE		    			          join k on k_id = ACT_ID and k_enabled = 1 '
                      + 'join GENCENTRALE on CEN_ID = ACT_CENID join k on k_id = CEN_ID and k_enabled = 1 '
                      + 'join NKLUNIVERS  on UNI_ACTID = ACT_ID join k on k_id = UNI_ID and k_enabled = 1 '
                      + 'where UNI_CENTRALE = CEN_CODE and CEN_CODE = 2 and UNI_NOM = ''FEDAS''';

//    QRY_Div.sql.Text := 'select act_id, act_uniid '
//                      + 'from nklactivite join k on k_id = act_id and k_enabled = 1 '
//                      + '  join gencentrale join k on k_id = cen_id and k_enabled = 1 on cen_id = act_cenid '
//                      + 'where cen_code = 2';
    QRY_Div.Open();
    ACT_ID := QRY_Div.FieldByName('ACT_ID').AsInteger;
    UNI_ID := QRY_Div.FieldByName('ACT_UNIID').AsInteger;

    QRYEVO('SEC_ID', 'NKLSECTEUR', 'SEC_ID', 'SEC_NOM=''REFERENCEMENT''');
    IF qry_div.IsEmpty THEN
    BEGIN
      QRYEVO('MAX(SEC_ORDREAFF)+1', 'NKLSECTEUR', 'SEC_ID', '');
      i := qry_div.Fields[0].AsInteger;
      SEC_ID := AjoutCleScript(Script, 'NKLSECTEUR');
      AjouteScrQry(Script, 'NKLSECTEUR',
        'SEC_ID, SEC_UNIID, SEC_IDREF, SEC_NOM, SEC_ORDREAFF, SEC_VISIBLE, SEC_TYPE',
        '%d, %d, 0, ''REFERENCEMENT'', %d, 1, 1',
        [SEC_ID, UNI_ID, i]);
    END
    ELSE
      SEC_ID := qry_div.Fields[0].AsInteger;
  end
  else
  begin
    QRYEVO('DOS_STRING', 'GENDOSSIER', 'DOS_ID', 'DOS_NOM=''UNIVERS_REF''');
    UNI := '';
    UNI := qry_div.Fields[0].AsString;
    QRYEVO('UNI_ID', 'NKLUNIVERS', 'UNI_ID', 'UNI_NOM=' + QuotedStr(UNI));
    UNI_ID := qry_div.Fields[0].AsInteger;

    SEC_ID := 0;
  end;

  QRYEVO('RAY_ID', 'NKLRAYON', 'RAY_ID', Format('RAY_NOM = ''REFERENCEMENT'' AND RAY_SECID = %d', [SEC_ID]));
  IF qry_div.IsEmpty THEN
  BEGIN
    QRYEVO('MAX(RAY_ORDREAFF)+1', 'NKLRAYON', 'RAY_ID', '');
    i := qry_div.Fields[0].AsInteger;
    RAY_ID := AjoutCleScript(Script, 'NKLRAYON');
    AjouteScrQry(Script, 'NKLRAYON',
      'RAY_ID,RAY_UNIID,RAY_IDREF,RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID',
      '%d,%d,0,''REFERENCEMENT'',%d,1,%d', [RAY_ID, UNI_ID, i, SEC_ID]);
  END
  ELSE
    RAY_ID := qry_div.Fields[0].AsInteger;
  QRYEVO('FAM_ID', 'NKLFAMILLE', 'FAM_ID', Format('FAM_NOM = ''REFERENCEMENT'' AND FAM_RAYID = %d', [RAY_ID]));
  IF qry_div.IsEmpty THEN
  BEGIN
    QRYEVO('MAX(FAM_ORDREAFF)+1', 'NKLFAMILLE', 'FAM_ID', '');
    i := qry_div.Fields[0].AsInteger;
    FAM_ID := AjoutCleScript(Script, 'NKLFAMILLE');
    AjouteScrQry(Script, 'NKLFAMILLE',
      'FAM_ID,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID',
      '%d,%d,0,''REFERENCEMENT'',%d,1,0',
      [FAM_ID, RAY_ID, i]);
  END
  ELSE
    FAM_ID := qry_div.Fields[0].AsInteger;


  Lab_etat2.Caption := 'Création de la nomenclature';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := Menart.recordcount;
  // Pour chaque article vérification de la présence de la sous famille
  Menart.First;
  WHILE NOT Menart.Eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;

    // mondovelo
    bFaireFedas := true;
{JB
    sIdMondovelo := MenArtMONDOVELO.AsString;
    if sIdMondovelo<>'' then
    begin
      IdMondovelo := StrToIntDef(sIdMondovelo, 0);
      if IdMondovelo<>0 then
      begin  // NKLSSFAMILLE
        Que_GenImport.Close;
        Que_GenImport.paramByName('ID').AsString := inttostr(IdMondovelo);
        Que_GenImport.paramByName('NUM').AsInteger := 7;
        Que_GenImport.paramByName('KTBID').AsInteger := -11111359;
        Que_GenImport.Open;
        Que_GenImport.First;
        if not(Que_GenImport.Eof) then
        begin
          SSF_ID := Que_GenImport.fieldbyname('IMP_GINKOIA').AsInteger;
          bFaireFedas := false;
        end;
        Que_GenImport.Close;
      end;
    end;
}
    if bFaireFedas then
    begin
      // pas de code fedas  on cherche sur le nom de la sous famille
      IF trim(MenArtFEDAS.AsString) = '' THEN
      BEGIN
        MenSSF.first;
        WHILE NOT (MenSSF.eof) AND
          ((UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString))
          OR (MenSSFSSF_FEDAS.AsString <> '')) DO
          MenSSF.next;
        // pas de nom de ssfamille
        IF (UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString)) OR (MenSSFSSF_FEDAS.AsString <> '') THEN
        BEGIN
          QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_FAMID=%d AND SSF_NOM=%s', [FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString))]));
          IF qry_div.IsEmpty THEN
          BEGIN
            QRYEVO('MAX(SSF_ORDREAFF)+1', 'NKLSSFAMILLE', 'SSF_ID', '');
            i := qry_div.Fields[0].AsInteger;
            SSF_ID := AjoutCleScript(Script, 'NKLSSFAMILLE');
            AjouteScrQry(Script, 'NKLSSFAMILLE',
              'SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID',
              '%d,%d,0,%s,%d,1,0,%d,%d',
              [SSF_ID, FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString)), i, TVA_ID, TCT_ID]);
          END
          ELSE
            SSF_ID := qry_div.Fields[0].AsInteger;
          // Migartion : MenSSF.AppendRecord([null, SSF_ID, UpperCase(MenArtCFAM.AsString), '', 0]);
          MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), '', 0]);
        END
        ELSE
          SSF_ID := MenSSFSSF_ID.AsInteger;
      END
      ELSE // Il y a un code fedas ou ID NK Espace Montagne
      BEGIN
        SSF_ID := 0;
        MenSSF.first;
        WHILE NOT (MenSSF.eof) AND (MenSSFSSF_FEDAS.AsString <> MenArtFEDAS.AsString) DO
          MenSSF.next;
        IF MenSSFSSF_FEDAS.AsString <> MenArtFEDAS.AsString THEN
        BEGIN
          // trouver la référence FEDA
          QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_IDREF=%s', [MenArtFEDAS.AsString]));
          IF qry_div.IsEmpty THEN
          BEGIN
            // Si pas trouvé et "Autre Nomenclature" coché ==> Espace Montagne recherche directement SSF_ID
            IF (pasFEDAS = 1) THEN
            BEGIN
              QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_ID=%s', [MenArtFEDAS.AsString]));
              IF qry_div.IsEmpty THEN
                SSF_ID := 0
              ELSE
              BEGIN
                SSF_ID := qry_div.Fields[0].AsInteger;
                MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), MenArtFEDAS.AsString, 0]);
              END;
            END;
            IF (SSF_ID = 0) THEN
            BEGIN
              // Si pas trouvé regarde si la famille existe sans code fedas
              MenSSF.first;
              WHILE NOT (MenSSF.eof) AND ((UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString)) OR (MenSSFSSF_FEDAS.AsString <> '')) DO
                MenSSF.next;
              IF (UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString)) OR (MenSSFSSF_FEDAS.AsString <> '') THEN
              BEGIN
                QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_FAMID=%d AND SSF_NOM=%s', [FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString))]));
                IF qry_div.IsEmpty THEN
                BEGIN
                  QRYEVO('MAX(SSF_ORDREAFF)+1', 'NKLSSFAMILLE', 'SSF_ID', '');
                  i := qry_div.Fields[0].AsInteger;
                  SSF_ID := AjoutCleScript(Script, 'NKLSSFAMILLE');
                  AjouteScrQry(Script, 'NKLSSFAMILLE',
                    'SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID',
                    '%d,%d,0,%s,%d,1,0,%d,%d',
                    [SSF_ID, FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString)), i, TVA_ID, TCT_ID]);
                END
                ELSE
                  SSF_ID := qry_div.Fields[0].AsInteger;
                MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), '', 0]);
              END
              ELSE
                SSF_ID := MenSSFSSF_ID.AsInteger;
            END;
          END
          ELSE
          BEGIN
            SSF_ID := qry_div.Fields[0].AsInteger;
            MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), MenArtFEDAS.AsString, 0]);
          END;
        END
        ELSE
          SSF_ID := MenSSFSSF_ID.AsInteger;
      END;
    end; // bFaireFedas

    IF MenSSFSSF_OK.asinteger = 0 THEN
    BEGIN
      //Prob de visibilité des famille
      QRY_Div.Close;
      QRY_Div.sql.Clear;
      QRY_Div.sql.add('Select SSF_ID, FAM_ID, RAY_ID, SSF_VISIBLE, Fam_visible, RAY_visible');
      if FVersionBase > 11 then
        QRY_Div.sql.add(', sec_id, sec_visible');
      QRY_Div.sql.add('from NKLSSFAMILLE Join k on (k_id=SSF_ID and K_ENABLED=1)');
      QRY_Div.sql.add('join nklfamille on (fam_id=ssf_famid)');
      QRY_Div.sql.add('join nklrayon on (ray_id=fam_rayid)');
      if FVersionBase > 11 then
        QRY_Div.sql.add('join nklsecteur on (sec_id=ray_secid)');
      QRY_Div.sql.add('where SSF_ID<>0 and SSF_id=' + Inttostr(SSF_ID));
      if FVersionBase > 11 then
        QRY_Div.sql.add('and sec_uniid = ' + IntToStr(UNI_ID));
      QRY_Div.Open;
      IF NOT QRY_Div.IsEmpty THEN
      BEGIN
        IF QRY_Div.fields[3].AsInteger = 0 THEN
        BEGIN
          AjouteScr(Script, ['Update NKLSSFAMILLE set SSF_VISIBLE=1 where SSF_ID=' + QRY_Div.fields[0].AsString]);
          If Gestion_K_VERSION=TKV64 then
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(VERSION_ID,1) Where K_ID=' + QRY_Div.fields[0].AsString])
          else
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.fields[0].AsString]);
        END;
        IF QRY_Div.fields[4].AsInteger = 0 THEN
        BEGIN
          AjouteScr(Script, ['Update nklfamille set fam_VISIBLE=1 where fam_ID=' + QRY_Div.fields[1].AsString]);
          If Gestion_K_VERSION=TKV64 then
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(VERSION_ID,1) Where K_ID=' + QRY_Div.fields[1].AsString])
          else
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.fields[1].AsString]);
        END;
        IF QRY_Div.fields[5].AsInteger = 0 THEN
        BEGIN
          AjouteScr(Script, ['Update nklrayon set ray_VISIBLE=1 where ray_ID=' + QRY_Div.fields[2].AsString]);
          If Gestion_K_VERSION=TKV64 then
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(VERSION_ID,1) Where K_ID=' + QRY_Div.fields[2].AsString])
          else
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.fields[2].AsString]);
        END;
        if (FVersionBase > 11) and (QRY_Div.FieldByName('sec_visible').AsInteger = 0) THEN
        BEGIN
          AjouteScr(Script, ['Update nklsecteur set sec_VISIBLE=1 where sec_ID=' + QRY_Div.FieldByName('sec_id').AsString]);
          If Gestion_K_VERSION=TKV64 then
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(VERSION_ID,1) Where K_ID=' + QRY_Div.FieldByName('sec_id').AsString])
          else
            AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.FieldByName('sec_id').AsString]);
        END;
      END;
      MenSSF.edit;
      MenSSFSSF_OK.asinteger := 1;
      MenSSF.Post;
    END;

    //recherche du fournisseur
    FOU_ID := 0;
    IF (FluxJanvier2008 AND
      (MenArtIDFOURNISSEUR.AsString <> '') AND (MenArtIDFOURNISSEUR.AsInteger <> 0)) THEN
    BEGIN
      MemFou.First;
      WHILE NOT (MemFou.eof) AND (MemFouIDFOURNISSEUR.AsInteger <> MenArtIDFOURNISSEUR.AsINTEGER) DO
        MemFou.next;
      IF (MemFouIDFOURNISSEUR.AsInteger = MenArtIDFOURNISSEUR.AsINTEGER) THEN
        FOU_ID := MemFouFOU_ID.AsInteger;
    END;
    IF (FOU_ID = 0) THEN
    BEGIN
      MemFou.First;
      WHILE NOT (MemFou.eof) AND (UpperCase(MemFouCFOU.AsString) <> UpperCase(MenArtCFOU.AsString)) DO
        MemFou.next;
      IF UpperCase(MemFouCFOU.AsString) <> UpperCase(MenArtCFOU.AsString) THEN
      BEGIN
        RAISE Exception.Create('Incohérence entre le fichier des fournisseurs et celui des articles, pour l''artcile ' + MenArtRFOU.AsString + ' et pour le fournisseur ' + MenArtCFOU.AsString + ', traitement interrompu');
      END;
      FOU_ID := MemFouFOU_ID.AsInteger;
    END;

    // ICI faut rechercher si la MARQUE pour prendre le MRK_ID
    MRK_ID := 0;
    IF (FluxJanvier2008 AND
      (MenArtIDMARQUE.asString <> '') AND (MenArtIDMARQUE.AsInteger <> 0)) THEN
    BEGIN
      MemD_Marque.First;
      WHILE NOT (MemD_Marque.eof)
        AND (MemD_MarqueIDMARQUE.AsInteger <> MenArtIDMARQUE.AsINTEGER) DO
        MemD_Marque.next;
      IF (MemD_MarqueIDMARQUE.AsInteger = MenArtIDMARQUE.AsINTEGER) THEN
        MRK_ID := MemD_MarqueMRK_ID.AsInteger;
    END;
    IF (MRK_ID = 0) THEN
    BEGIN
      MemD_Marque.first;
      WHILE NOT (MemD_Marque.eof) AND (UpperCase(MemD_MarqueMARQUE.asString) <> UpperCase(MenArtMARQUE.AsString)) DO
        MemD_Marque.Next;
      IF UpperCase(MemD_MarqueMARQUE.asString) <> UpperCase(MenArtMARQUE.AsString) THEN
      BEGIN
        // SI on la trouve pas faut la créer
        // avec liaison au fou principal le fournisseur en cours
        QRYEVO('MRK_ID', 'ARTMARQUE', 'MRK_ID', 'MRK_NOM=' + QuotedStr(UpperCase(MenArtMARQUE.AsString)));
        IF qry_div.isempty THEN
        BEGIN
          MRK_ID := AjoutCleScript(Script, 'ARTMARQUE');
          AjouteScrQry(Script, 'ARTMARQUE',
            'MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE',
            '%d,1,%s,'''',''''',
            [MRK_ID, QuotedStr(UpperCase(MenArtMARQUE.AsString))]);
          i := AjoutCleScript(Script, 'ARTMRKFOURN');
          AjouteScrQry(Script, 'ARTMRKFOURN',
            'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
            '%d,%d,%d,1',
            [I, FOU_ID, MRK_ID]);
          MemD_Liais.insert;
          MemD_LiaisFOU_ID.AsInteger := FOU_ID;
          MemD_LiaisMRK_ID.AsInteger := MRK_ID;
          MemD_Liais.Post;

          // Mettre à jour GENIMPORT
          IF FluxJanvier2008 THEN
          BEGIN  // ARTMARQUE
            i := AjoutCleScript(Script, 'GENIMPORT');
            AjouteScrQry(Script, 'GENIMPORT',
              'IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM',
              '%d,-11111392,%d,%d,4',
              [i, MRK_ID, MenArtIDMARQUE.AsInteger]);
          END;
        END
        ELSE
          MRK_ID := qry_div.Fields[0].AsInteger;
        MemD_Marque.insert;
        MemD_MarqueMARQUE.AsString := UpperCase(MenArtMARQUE.AsString);
        MemD_MarqueMRK_ID.Asinteger := MRK_ID;
        MemD_MarqueIDMARQUE.AsString := MenArtIDMARQUE.AsString;
        MemD_Marque.post;
      END
      ELSE
        MRK_ID := MemD_MarqueMRK_ID.Asinteger;
    END;

    MemD_Liais.first;
    WHILE NOT (MemD_Liais.eof) AND ((MemD_LiaisFOU_ID.asinteger <> FOU_ID) OR (MemD_LiaisMRK_ID.asinteger <> MRK_ID)) DO
      MemD_Liais.Next;
    IF MemD_Liais.eof THEN
    BEGIN
      // Puis faut chercher la liaison FOU/MRK
      // SI on la trouve pas faut la créer
      QRYEVO('FMK_ID', 'ARTMRKFOURN', 'FMK_ID', Format('FMK_FOUID=%d and FMK_MRKID=%d', [FOU_ID, MRK_ID]));
      IF qry_div.isempty THEN
      BEGIN
        i := AjoutCleScript(Script, 'ARTMRKFOURN');
        AjouteScrQry(Script, 'ARTMRKFOURN',
          'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
          '%d,%d,%d,0',
          [I, FOU_ID, MRK_ID]);
      END;
      MemD_Liais.insert;
      MemD_LiaisFOU_ID.AsInteger := FOU_ID;
      MemD_LiaisMRK_ID.AsInteger := MRK_ID;
      MemD_Liais.Post;
    END;

    // rechercher la grille de taille
    MenEntTail.First;
    WHILE NOT (MenEntTail.eof) AND (UpperCase(MenEntTailITEMID.AsString) <> UpperCase(MenArtCTAI.AsString)) DO
      MenEntTail.Next;
    IF (UpperCase(MenEntTailITEMID.AsString) <> UpperCase(MenArtCTAI.AsString)) THEN
    BEGIN
      RAISE Exception.Create('Incohérence entre le fichier des tailles et celui des articles, pour l''artcile ' + MenArtRFOU.AsString + ' et pour la taille ' + MenArtCTAI.AsString + ', traitement interrompu');
    END;

    //Recherche du Genre
    GRE_ID := 0;
    SEXE := 0;
    MemD_Genre.First;
    WHILE NOT (MemD_Genre.eof) AND (UpperCase(MemD_GenreGRE_NOM.AsString) <> UpperCase(MenArtGENRESP2K.AsString)) DO
      MemD_Genre.Next;

    IF (UpperCase(MenArtGENRESP2K.AsString) = '') OR (UpperCase(MemD_GenreGRE_NOM.AsString) <> UpperCase(MenArtGENRESP2K.AsString)) THEN
      BEGIN
        //Identification du genre dans la table ArtGenre
        QRY(['SELECT GRE_ID,GRE_SEXE FROM ARTGENRE',
          ' join k on (K_id=GRE_ID and K_ENABLED=1)',
            'Where GRE_ID<>0 AND UPPER(GRE_NOM) = ' + QuotedStr(UpperCase(MenArtGENRESP2K.AsString))]);

        //Si le genre existe dans la table ArtGenre
        if Not QRY_Div.IsEmpty then
          Begin
            //On Contrôle du couple genre/sexe en fonction des spécificités de Sport 2000 et on corrige si ce n'est pas bon
            SEXE   := SexSport2000(MenArtGENRESP2K.AsString);
            GRE_ID := QRY_Div.fields[0].AsInteger;
            if ((QRY_Div.FieldByName('GRE_SEXE').AsInteger <> SEXE) and (SEXE<>0)) then
              Begin
                //Mise à jour du sexe
                AjouteScr(Script,['UPDATE ARTGENRE ' +
                                 'SET GRE_SEXE = '+IntToStr(SEXE)+' Where GRE_ID<>0 AND UPPER(GRE_NOM) = ' + QuotedStr(UpperCase(MenArtGENRESP2K.AsString))]);
                If Gestion_K_VERSION=TKV64 then
                  AjouteScr(Script, ['Update K Set K_Version=GEN_ID(VERSION_ID,1) Where K_ID=' + IntToStr(GRE_ID)])
                else
                  AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + IntToStr(GRE_ID)]);
              End;
            //On affecte le genre à l'artile
            MemD_Genre.insert;
            MemD_GenreGRE_ID.AsInteger := GRE_ID;
            MemD_GenreGRE_NOM.AsString := UpperCase(MenArtGENRESP2K.AsString);
            MemD_Genre.Post;
          End;


        //Le genre n'existe pas dans la table ArtGenre
        IF QRY_Div.IsEmpty THEN
          BEGIN
            //Recherche du genre dans le tableau Sport 2000.
            SEXE  := SexSport2000(MenArtGENRESP2K.AsString);

            //Recherche du sexe en fonction de la fedas s'il n'a pas été identifié dans le tableau sport 2000
            IF ((SEXE = 0) AND (UpperCase(MenArtFEDAS.AsString) <> '') AND (Length(MenArtFEDAS.AsString) = 6)) THEN
              BEGIN
                SEXE := StrToInt(Copy(MenArtFEDAS.AsString, 6, 1));
                CASE SEXE OF
                  0, 4, 7: SEXE := 1;
                  5, 8: SEXE := 2;
                  6, 9: SEXE := 3;
                END;
              END
            ELSE IF (SEXE = 0) then
              SEXE := 1;

            //Si le genre n'est pas renseigné on l'affecte en fonction du sexe de la fedas et de la table ArtGenre
            IF (UpperCase(MenArtGENRESP2K.AsString) = '') THEN
              BEGIN
                QRY(['SELECT MIN(GRE_ID) FROM ARTGENRE',
                  'join k on (K_id=GRE_ID and K_ENABLED=1)',
                    'Where GRE_ID<>0 AND GRE_SEXE = ' + IntToStr(SEXE)]);
                IF NOT QRY_Div.IsEmpty THEN
                  GRE_ID := QRY_Div.fields[0].AsInteger;
              END
            ELSE //Si le genre n'existe pas on le crée avec le sexe trouvé dans sport 2000 ou la fedas
              BEGIN
                GRE_ID := AjoutCleScript(Script, 'ARTGENRE');
                AjouteScrQry(Script, 'ARTGENRE', 'GRE_ID,GRE_IDREF,GRE_NOM,GRE_SEXE', '%d,1,%s,%d',
                  [GRE_ID, QuotedStr(UpperCase(MenArtGENRESP2K.AsString)), SEXE]);
                MemD_Genre.insert;
                MemD_GenreGRE_ID.AsInteger := GRE_ID;
                MemD_GenreGRE_NOM.AsString := UpperCase(MenArtGENRESP2K.AsString);
                MemD_Genre.Post;
              END
          END
      END
    ELSE
      GRE_ID := MemD_GenreGRE_ID.AsInteger;

    Menart.Edit;
    MenartSSF_ID.AsInteger := SSF_ID;
    MenArtFOU_ID.AsInteger := FOU_ID;
    MenArtMRK_ID.AsInteger := MRK_ID;
    MenArtGTF_ID.AsInteger := MenEntTailGTF_ID.AsInteger;
    MenArtGRE_ID.AsInteger := GRE_ID;
    Menart.Post;

    Menart.Next;
  END;

  QRYEVO('MAG_ID', 'GENMAGASIN', 'MAG_ID', 'MAG_ID<>0');
  MAG_ID := qry_div.Fields[0].AsInteger;

  // Création des articles
  Lab_etat2.Caption := 'Création des articles';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := Menart.recordcount;
  Menart.First;
  premier := '';
  dernier := '';
  // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
  // Recup du classement WEB
  WebId := 0;
  WHILE NOT Menart.Eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    // Article existe ?
    QRYEVO('ARF_ARTID, ARF_ID',
      'ARTREFERENCE JOIN ARTARTICLE ON (ART_ID=ARF_ARTID)', 'ARF_ID',
      Format('ARF_ARCHIVER=0 AND ART_REFMRK=%s and ART_MRKID=%d and ART_GTFID=%d', [QuotedStr(UpperCase(MenartRFOU.AsString)), MenArtMRK_ID.AsInteger, MenArtGTF_ID.AsInteger]));
    // nouveau test d existance (ancien: qry_div.IsEmpty  )
    isExistFicheModele := isExistArt(MenArtITEMID.AsInteger);
      //JB
    if not isExistFicheModele then
    BEGIN
      // Article fusionne existe ?
      QRYEVO('ARF_ARTID, ARF_ID',
        'ARTREFERENCE JOIN ARTARTICLE ON (ART_ID=ARF_ARTID)', 'ARF_ID',
        Format('ARF_ARCHIVER <> 0 AND ART_FUSARTID IS NOT NULL AND ART_FUSARTID > 0 AND ART_REFMRK=%s and ART_MRKID=%d and ART_GTFID=%d', [QuotedStr(UpperCase(MenartRFOU.AsString)), MenArtMRK_ID.AsInteger, MenArtGTF_ID.AsInteger]));
      IF not qry_div.IsEmpty
      THEN
      BEGIN
        ART_ID := qry_div.Fields[0].AsInteger;
        ARF_ID := qry_div.Fields[1].AsInteger;
        QRY(['Select O_ARTID FROM JB_RECHERCHE_ARTICLE_FUSIONNE(' + IntToStr(ART_ID) + ')']);
        ART_ID := qry_div.Fields[0].AsInteger;
      END;
    END
    ELSE
    BEGIN
      ART_ID := qry_div.Fields[0].AsInteger;
      ARF_ID := qry_div.Fields[1].AsInteger;
    END;
//
    // Traitement création article
    IF not isExistFicheModele THEN
    BEGIN
      QRY(['SELECT NEWNUM FROM ART_CHRONO']);
      Chrono := QRY_Div.Fields[0].AsString;
      IF Premier = '' THEN
        Premier := Chrono;
      Dernier := Chrono;

      // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
      // Recup du classement WEB
      IF FluxEM THEN
      BEGIN
        IdWeb := 0;
        // Classement Web
        IF (MenArtWEB.AsString = '1') AND (WebId = 0) THEN
        BEGIN
          MemD_WEB.open;
          MemD_WEB.first;
          WHILE NOT (MemD_WEB.eof) AND (UpperCase(MemD_WEBICL_NOM.AsString) <> 'WEB') DO
            MemD_WEB.next;
          IF (MemD_WEB.eof) AND (UpperCase(MemD_WEBICL_NOM.AsString) <> 'WEB') THEN
          BEGIN
            QRY(['select MIN(ICL_ID)',
              'from ARTCLASSEMENT',
                'join ARTCLAITEM on (cit_claid=cla_id)',
                'join ARTITEMC on (icl_id=cit_iclid)',
                'join k on (K_ID=ICL_ID and K_ENABLED=1)',
                'where CLA_TYPE=''ART'' and CLA_NUM=5 and UPPER(ICL_NOM)=''WEB''']);
            IF NOT QRY_Div.IsEmpty THEN
            begin
              WebId := QRY_Div.fields[0].AsInteger;
            end
            ELSE
            BEGIN
              // Recup du classement 5
              QRY(['select CLA_ID',
                'from ARTCLASSEMENT',
                  'join k on (K_ID=CLA_ID and K_ENABLED=1)',
                  'where CLA_TYPE=''ART'' and CLA_NUM=5']);
              IF NOT QRY_Div.IsEmpty THEN
                ClaID := QRY_Div.fields[0].AsInteger;

              WebId := AjoutCleScript(Script, 'ARTITEMC');
              AjouteScrQry(Script, 'ARTITEMC', 'ICL_ID,ICL_NOM', '%d,%s',
                [WebId, 'WEB']);

              CitId := AjoutCleScript(Script, 'ARTCLAITEM');
              AjouteScrQry(Script, 'ARTCLAITEM', 'CIT_ID,CIT_ICLID,CIT_CLAID', '%d,%d,%d',
                [CitId, WebId, ClaId]);
            END;
            MemD_WEB.insert;
            MemD_WEBICL_ID.AsInteger := WebId;
            MemD_WEBICL_NOM.AsString := 'WEB';
            MemD_WEB.Post;
          END
          ELSE
          BEGIN
            WebId := MemD_WEBICL_ID.AsInteger;
          END;
          IDWeb := WebId;
        END
        ELSE
        begin
          IF (MenArtWEB.AsString = '1') THEN IDWeb := WebId ELSE IDWeb := 0;
        end;

        // Classement Activite
        IdAct := 0;
        IF (MenArtACTIVITE.AsString <> '') THEN
        BEGIN
          MemD_ACTIVITE.open;
          MemD_ACTIVITE.first;
          WHILE NOT (MemD_ACTIVITE.eof) AND (UpperCase(MemD_ACTIVITEICL_NOM.AsString) <> UpperCase(MenArtACTIVITE.AsString)) DO
            MemD_ACTIVITE.next;
          IF (MemD_ACTIVITE.eof) AND (UpperCase(MemD_ACTIVITEICL_NOM.AsString) <> UpperCase(MenArtACTIVITE.AsString)) THEN
          BEGIN
            QRY(['select MIN(ICL_ID)',
              'from ARTCLASSEMENT',
                'join ARTCLAITEM on (cit_claid=cla_id)',
                'join ARTITEMC on (icl_id=cit_iclid)',
                'join k on (K_ID=ICL_ID and K_ENABLED=1)',
                'where CLA_TYPE=''ART'' and CLA_NUM=1 and UPPER(ICL_NOM)=' + QuotedStr(UpperCase(MenArtACTIVITE.AsString))]);
            IF NOT QRY_Div.IsEmpty THEN
              IdAct := QRY_Div.fields[0].AsInteger
            ELSE
            BEGIN
              // Recup du classement 1
              QRY(['select CLA_ID',
                'from ARTCLASSEMENT',
                  'join k on (K_ID=CLA_ID and K_ENABLED=1)',
                  'where CLA_TYPE=''ART'' and CLA_NUM=1']);
              IF NOT QRY_Div.IsEmpty THEN
                ClaID := QRY_Div.fields[0].AsInteger;

              IdAct := AjoutCleScript(Script, 'ARTITEMC');
              AjouteScrQry(Script, 'ARTITEMC', 'ICL_ID,ICL_NOM', '%d,%s',
                [IdAct, QuotedStr(MenArtACTIVITE.AsString)]);

              CitId := AjoutCleScript(Script, 'ARTCLAITEM');
              AjouteScrQry(Script, 'ARTCLAITEM', 'CIT_ID,CIT_ICLID,CIT_CLAID', '%d,%d,%d',
                [CitId, IdAct, ClaId]);
            END;
            MemD_ACTIVITE.insert;
            MemD_ACTIVITEICL_ID.AsInteger := IdAct;
            MemD_ACTIVITEICL_NOM.AsString := MenArtACTIVITE.AsString;
            MemD_ACTIVITE.Post;
          END
          ELSE IdAct := MemD_ACTIVITEICL_ID.AsInteger;
        END;

        // Calssement Spécifique
        IdSpec := 0;
        IF (MenArtSPECIFICITE.AsString <> '') THEN
        BEGIN
          MemD_Specifique.open;
          MemD_Specifique.first;
          WHILE NOT (MemD_Specifique.eof) AND (UpperCase(MemD_SpecifiqueICL_NOM.AsString) <> UpperCase(MenArtSPECIFICITE.AsString)) DO
            MemD_Specifique.next;
          IF (MemD_Specifique.eof) AND (UpperCase(MemD_SpecifiqueICL_NOM.AsString) <> UpperCase(MenArtSPECIFICITE.AsString)) THEN
          BEGIN
            QRY(['select MIN(ICL_ID)',
              'from ARTCLASSEMENT',
                'join ARTCLAITEM on (cit_claid=cla_id)',
                'join ARTITEMC on (icl_id=cit_iclid)',
                'join k on (K_ID=ICL_ID and K_ENABLED=1)',
                'where CLA_TYPE=''ART'' and CLA_NUM=3 and UPPER(ICL_NOM)=' + QuotedStr(UpperCase(MenArtSPECIFICITE.AsString))]);
            IF NOT QRY_Div.IsEmpty THEN
              IdSpec := QRY_Div.fields[0].AsInteger
            ELSE
            BEGIN
              // Recup du classement 3
              QRY(['select CLA_ID',
                'from ARTCLASSEMENT',
                  'join k on (K_ID=CLA_ID and K_ENABLED=1)',
                  'where CLA_TYPE=''ART'' and CLA_NUM=3']);
              IF NOT QRY_Div.IsEmpty THEN
                ClaID := QRY_Div.fields[0].AsInteger;

              IdSpec := AjoutCleScript(Script, 'ARTITEMC');
              AjouteScrQry(Script, 'ARTITEMC', 'ICL_ID,ICL_NOM', '%d,%s',
                [IdSpec, QuotedStr(MenArtSPECIFICITE.AsString)]);

              CitId := AjoutCleScript(Script, 'ARTCLAITEM');
              AjouteScrQry(Script, 'ARTCLAITEM', 'CIT_ID,CIT_ICLID,CIT_CLAID', '%d,%d,%d',
                [CitId, IdSpec, ClaId]);
            END;
              MemD_Specifique.insert;
            MemD_SpecifiqueICL_ID.AsInteger := IdSpec;
            MemD_SpecifiqueICL_NOM.AsString := MenArtSPECIFICITE.AsString;
            MemD_Specifique.Post;
          END
          ELSE IdSpec := MemD_SpecifiqueICL_ID.AsInteger;
        END
      END;

      ART_ID := AjoutCleScript(Script, 'ARTARTICLE');
      ARF_ID := AjoutCleScript(Script, 'ARTREFERENCE');
      if FVersionBase > 11 then
        ARX_ID := AjoutCleScript(Script, 'ARTRELATIONAXE');
      IF (MenArtREFERENCECENTRALE.AsString = '') THEN
        REFERENCECENTRALE := 0
      ELSE REFERENCECENTRALE := MenArtREFERENCECENTRALE.AsInteger;
      // Test ITEMID chez Nike c'est un varchar !!
      TRY
        ARTIDREF := MenArtITEMID.AsInteger;
      EXCEPT
        ARTIDREF := 0;
      END;
      if FVersionBase > 11 then
        AjouteScrQry(Script, 'ARTARTICLE',
          'ART_ID,ART_IDREF,ART_NOM,ART_ORIGINE,ART_DESCRIPTION,ART_MRKID,ART_REFMRK,' +
          'ART_SSFID,ART_PUB,ART_GTFID,ART_SESSION,ART_GREID,ART_THEME,ART_GAMME,' +
          'ART_CODECENTRALE,ART_TAILLES,ART_POS,ART_GAMPF,ART_POINT,ART_GAMPRODUIT,' +
          'ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,ART_CODEGS,ART_COMENT1,ART_COMENT2,' +
          'ART_COMENT3,ART_COMENT4,ART_COMENT5,' +
          'ART_CENTRALE, ART_ACTID,ART_CODECENTRALE',
          '%d,%d,%s,1,%s,%s,%s,' +
          '%d,0,%d,'''',%d,'''','''',' +
          ''''','''','''','''','''','''',' +
          '%d,%d,2,0,'''','''',' +
          '%s,%s,%s, ' +
          '2, %d, 2',
          [ART_ID, ARTIDREF, QuotedStr(MenArtLIBFRS.AsString), QuotedStr(MenArtLIBELLE.AsString), MenArtMRK_ID.AsString, QuotedStr(UpperCase(MenArtRFOU.AsString)),
          0, MenArtGTF_ID.AsInteger, MenArtGRE_ID.AsInteger, MenArtCATMAN.AsInteger, REFERENCECENTRALE, QuotedStr(MenArtLIBELLE.AsString),
          QuotedStr(MenArtLIBELLE.AsString), QuotedStr(MenArtFEDAS.AsString), ACT_ID])
      else
        AjouteScrQry(Script, 'ARTARTICLE',
          'ART_ID,ART_IDREF,ART_NOM,ART_ORIGINE,ART_DESCRIPTION,ART_MRKID,ART_REFMRK,' +
          'ART_SSFID,ART_PUB,ART_GTFID,ART_SESSION,ART_GREID,ART_THEME,ART_GAMME,' +
          'ART_CODECENTRALE,ART_TAILLES,ART_POS,ART_GAMPF,ART_POINT,ART_GAMPRODUIT,' +
          'ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,ART_CODEGS,ART_COMENT1,ART_COMENT2,' +
          'ART_COMENT3,ART_COMENT4,ART_COMENT5',
          '%d,%d,%s,1,%s,%s,%s,' +
          '%d,0,%d,'''',%d,'''','''',' +
          ''''','''','''','''','''','''',' +
          '%d,%d,2,0,'''','''',' +
          '%s,%s,%s',
          [ART_ID, ARTIDREF, QuotedStr(MenArtLIBFRS.AsString), QuotedStr(MenArtLIBELLE.AsString), MenArtMRK_ID.AsString, QuotedStr(UpperCase(MenArtRFOU.AsString)),
          MenArtSSF_ID.AsInteger, MenArtGTF_ID.AsInteger, MenArtGRE_ID.AsInteger, MenArtCATMAN.AsInteger, REFERENCECENTRALE, QuotedStr(MenArtLIBELLE.AsString), QuotedStr(MenArtLIBELLE.AsString), QuotedStr(MenArtFEDAS.AsString)]);
      AjouteScrQry(Script, 'ARTREFERENCE',
        'ARF_ID,ARF_ARTID,ARF_CATID,ARF_TVAID,ARF_TCTID,ARF_ICLID1,' +
        'ARF_ICLID2,ARF_ICLID3,ARF_ICLID4,ARF_ICLID5,ARF_CREE,' +
        'ARF_MODIF,ARF_CHRONO,ARF_DIMENSION,ARF_DEPRECIATION,' +
        'ARF_VIRTUEL,ARF_SERVICE,ARF_COEFT,ARF_STOCKI,ARF_VTFRAC,' +
        'ARF_CDNMT,ARF_CDNMTQTE,ARF_UNITE,ARF_CDNMTOBLI,ARF_GUELT,' +
        'ARF_CPFA,ARF_FIDELITE,ARF_ARCHIVER,ARF_FIDPOINT,ARF_FIDDEBUT,' +
        'ARF_FIDFIN,ARF_DEPTAUX,ARF_DEPDATE,ARF_DEPMOTIF,ARF_CGTID,' +
        'ARF_GLTMONTANT,ARF_GLTPXV,ARF_GLTMARGE,ARF_GLTDEBUT,ARF_GLTFIN,' +
        'ARF_MAGORG,ARF_CATALOG',
        '%d,%d,0,%d,%d,%d,' +
        '0,%d,0,%d,Current_Date,' +
        'Current_Date,%s,1,0,' +
        '0,0,0,0,0,' +
        '0,0,0,0,0,' +
        '0,1,0,0,Null,' +
        'Null,0,null,0,0,' +
        '0,0,0,Null,Null,' +
        '%d,0',
        [ARF_ID, ART_ID, TVA_ID, TCT_ID, Idact, IdSpec, Idweb, QuotedStr(Chrono), MAG_ID]);
      if FVersionBase > 11 then
      BEGIN
        AjouteScrQry(Script, 'ARTRELATIONAXE', 'ARX_ID, ARX_ARTID, ARX_SSFID', '%d, %d, %d', [ARX_ID, ART_ID, MenArtSSF_ID.AsInteger]);
//JB
        AjouteScr(Script, ['EXECUTE PROCEDURE JB_REFERENCEMENT_AUTO_2(' + IntToStr(ART_ID) + ')']);
//
      END;
      // Création des couleurs
      MemD_COU.first;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString <> MenartITEMID.AsString) DO
        MemD_COU.next;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString = MenartITEMID.AsString) DO
      BEGIN
  //      IF (MemD_COUVALIDE.AsInteger = 1) THEN
        BEGIN
          COU_ID := AjoutCleScript(Script, 'PLXCOULEUR');
          CC := MemD_COUCODECOLORIS.AsString;
          CL := MemD_COUDESCRIPTIF.AsString;
          AjouteScrQry(Script, 'PLXCOULEUR',
            'COU_ID,COU_ARTID,COU_IDREF,COU_GCSID,COU_CODE,COU_NOM',
            '%d,%d,%d,0,%s,%s',
            [COU_ID, ART_ID, -1, quotedStr(CC), quotedStr(CL)]);
          MemD_COU.Edit;
          MemD_COUCOU_ID.AsInteger := COU_ID;
          MemD_COUART_ID.AsInteger := ART_ID;
          MemD_COU.Post;
        END;
        MemD_COU.next;
      END;
      // Création du prix catalogue  (Attention à la mAJ si l'article Existe déja ligne: )
      i := AjoutCleScript(Script, 'TARCLGFOURN');
      IF ((MenArtPA.AsFloat = 0) OR (MenArtPA.AsFloat = 1)) THEN
      BEGIN
        IF (MenArtPA.AsFloat = 1) THEN
          Px := MenArtPA.AsFloat / 100
        ELSE Px := 0;
        RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix d''ACHAT est inexploitable ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      END;

      IF ((MenArtPANET.AsFloat = 0) OR (MenArtPANET.AsFloat = 1)) THEN
      BEGIN
        IF (MenArtPANET.AsFloat = 1) THEN
          Px := MenArtPANET.AsFloat / 100
        ELSE Px := 0;
        RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix d''ACHAT NET est ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      END;

      IF ((MenArtPVI.AsFloat = 0) OR (MenArtPVI.AsFloat = 1)) THEN
        PvI := 0
      ELSE PvI := MenArtPVI.AsFloat / 100;

      AjouteScrQry(Script, 'TARCLGFOURN',
        'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,' +
        'CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL',
        '%d,%d,%d,0,%.2f,%.2f,%.2f,0,0,0,0,1',
        [i, ART_ID, MenArtFOU_ID.AsInteger, MenArtPA.AsFloat / 100, MenArtPANET.AsFloat / 100, PvI]);

    END
    ELSE
    BEGIN //Si l'article existe, on ne recrée que les couleurs manquantes
      //MAJ du prix d'achat Catalogue
      MemD_COU.first;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString <> MenartITEMID.AsString) DO
        MemD_COU.next;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString = MenartITEMID.AsString) DO
      BEGIN
   //     IF (MemD_COUVALIDE.AsInteger = 1) THEN
        BEGIN
          //
          if trim(MemD_COUCODECOLORIS.AsString) = '' then
            QRYEVO('COU_ID', 'PLXCOULEUR', 'COU_ID', Format('COU_ARTID=%d and Upper(COU_NOM)=%s', [ART_ID, Quotedstr(UpperCase(MemD_COUDESCRIPTIF.AsString))]))
          else
            QRYEVO('COU_ID', 'PLXCOULEUR', 'COU_ID', Format('COU_ARTID=%d and COU_CODE=%s', [ART_ID, Quotedstr(MemD_COUCODECOLORIS.AsString)]));
          IF qry_div.IsEmpty THEN
          BEGIN
            COU_ID := AjoutCleScript(Script, 'PLXCOULEUR');
            CC := MemD_COUCODECOLORIS.AsString;
            CL := MemD_COUDESCRIPTIF.AsString;
            AjouteScrQry(Script, 'PLXCOULEUR',
              'COU_ID,COU_ARTID,COU_IDREF,COU_GCSID,COU_CODE,COU_NOM',
              '%d,%d,%d,0,%s,%s',
              [COU_ID, ART_ID, -1, quotedStr(CC), quotedStr(CL)]);
          END
          ELSE
            COU_ID := qry_div.Fields[0].AsInteger;
          MemD_COU.Edit;
          MemD_COUCOU_ID.AsInteger := COU_ID;
          MemD_COUART_ID.AsInteger := ART_ID;
          MemD_COU.Post;
        END;
        MemD_COU.next;
      END;

      // MAJ du prix catalogue
      IF ((MenArtPA.AsFloat <> 0) AND (MenArtPA.AsFloat <> 1)) THEN
      BEGIN
        IF ((MenArtPANET.AsFloat <> 0) AND (MenArtPANET.AsFloat <> 1)) THEN
        BEGIN
          IF ((MenArtPVI.AsFloat = 0) OR (MenArtPVI.AsFloat = 1)) THEN
            PvI := 0
          ELSE PvI := MenArtPVI.AsFloat / 100;

          // Recherche le Prix catalogue et faire la maj si le prix est différent
          QRYEVO('CLG_ID,CLG_PX',
            'TARCLGFOURN', 'CLG_ID',
            Format('CLG_ARTID=%d and CLG_FOUID=%d and CLG_TGFID=0', [ART_ID, MenArtFOU_ID.AsInteger]));
          IF qry_div.IsEmpty THEN
          BEGIN
            i := AjoutCleScript(Script, 'TARCLGFOURN');
            AjouteScrQry(Script, 'TARCLGFOURN',
              'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,' +
              'CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL',
              '%d,%d,%d,0,%.2f,%.2f,%.2f,0,0,0,0,1',
              [i, ART_ID, MenArtFOU_ID.AsInteger, MenArtPA.AsFloat / 100, MenArtPANET.AsFloat / 100, PvI]);
          END
          ELSE
          BEGIN
            i := qry_div.Fields[0].AsInteger;
            IF (qry_div.Fields[1].AsFloat <> (MenArtPA.AsFloat / 100)) THEN
            BEGIN
              IF ((MenArtPV.AsString = '') OR (MenArtPV.AsFloat = 0) OR (MenArtPV.AsFloat = 1)) THEN
              BEGIN
                Px := 0;
              END
              ELSE Px := MenArtPV.AsFloat / 100;

              MajScrQry(Script, 'TARCLGFOURN',
                'CLG_PX=%.2f, CLG_PXNEGO=%.2f, CLG_PXVI=%.2f',
                [MenArtPA.AsFloat / 100, MenArtPANET.AsFloat / 100, Px],
                'CLG_ID', IntToStr(i));
            END;
          END;
        END;
      END;

      // FTH 2010-12-29 Evolution
      QRYEVO('ART_NOM,ART_SSFID','ARTARTICLE','ART_ID',Format('ART_ID=%d',[ART_ID]));
      if not qry_div.IsEmpty then
      begin
          // FTH 2010-12-29 Maj du libellé de l'article s'il est différent
         if UpperCase(Trim(QRY_Div.FieldByName('ART_NOM').AsString)) <> UpperCase(Trim(MenArtLIBELLE.AsString)) then
           MajScrQry(Script,'ARTARTICLE','ART_NOM = %s',[QuotedStr(MenArtLIBELLE.AsString)],'ART_ID',IntToStr(ART_ID));
//JB
        IF FVersionBase > 11 THEN
        BEGIN
          // Recherche de la sous-famille exustante
          QRY(['SELECT w.ARX_ID , sf.SSF_ID',
              'FROM ARTRELATIONAXE w                           JOIN K ON k.k_id = w.ARX_ID AND k.k_enabled = 1',
              'JOIN NKLSSFAMILLE sf ON sf.SSF_ID = w.ARX_SSFID JOIN K ON k.k_id = sf.SSF_ID AND k.k_enabled = 1',
              'JOIN NKLFAMILLE f ON f.FAM_ID = sf.SSF_FAMID    JOIN K ON k.k_id = f.FAM_ID AND k.k_enabled = 1',
              'JOIN NKLRAYON y ON y.RAY_ID = f.FAM_RAYID       JOIN K ON k.k_id = y.RAY_ID AND k.k_enabled = 1',
              'JOIN NKLSECTEUR s ON s.SEC_ID = y.RAY_SECID     JOIN K ON k.k_id = s.SEC_ID AND k.k_enabled = 1',
              'JOIN NKLUNIVERS u on u.UNI_ID = s.SEC_UNIID     JOIN K ON k.k_id = u.UNI_ID AND k.k_enabled = 1',
              'WHERE u.UNI_ID = ' + IntToStr(UNI_ID),
              'AND w.ARX_ARTID = ' + IntToStr(ART_ID)]);
          IF NOT QRY_Div.IsEmpty THEN
          BEGIN
            // La sous-famille a-t-elle changée ?
            if QRY_Div.fields[1].AsInteger <> MenArtSSF_ID.AsInteger THEN
            BEGIN
              // remplacer la sous-famille
              MajScrQry(Script,'ARTRELATIONAXE','ARX_SSFID = %d',[MenArtSSF_ID.AsInteger],'ARX_ID',IntToStr(QRY_Div.fields[0].AsInteger));
              // Remettre à jour les liens inter axes
              AjouteScr(Script, ['EXECUTE PROCEDURE JB_REFERENCEMENT_AUTO_2(' + IntToStr(ART_ID) + ')']);
            END;
          END;
        END
        ELSE
        BEGIN
//
          // FTH 2010-12-30 Maj de la FEDAS si elle est différente
            // Récupération de l'id de la soufamille de l'article dans la base de données
          SSF_ID := QRY_Div.FieldByName('ART_SSFID').AsInteger;
            // récupération de l'id de la sousfamille des données du fichier xml
          QRYEVO('SSF_ID','NKLSSFAMILLE','SSF_ID',Format('SSF_IDREF = %s',[MenArtFEDAS.AsString]));
          if not Qry_Div.IsEmpty then
          begin
            if SSF_ID <> QRY_Div.FieldByName('SSF_ID').AsInteger then
              MajScrQry(Script,'ARTARTICLE','ART_SSFID = %d',[QRY_Div.FieldByName('SSF_ID').AsInteger],'ART_ID',IntToStr(ART_ID));
          end
          else begin
            // Vérification que cette FEDAS n'est pas nouvelle
            if MenSSF.Locate('SSF_FEDAS',MenArtFEDAS.AsString,[loCaseInsensitive]) then
              MajScrQry(Script,'ARTARTICLE','ART_SSFID = %d',[MenSSF.FieldByName('SSF_ID').AsInteger],'ART_ID',IntToStr(ART_ID));
  //          else
              // Ne devrait pas arriver si la fedas est à jour
  //            raise Exception.Create('Article : ' + MenArtRFOU.asstring + ' Mise à jour de la nomenclature FEDAS impossible ' + #13#10 +
  //                                   'Le code FEDAS n''existe pas : ' + MenArtFEDAS.AsString);
          end;
        END;
      end;
    END;

    //Stan
    // Maj du prix vente si prix de vente inexixtant
    // Recherche le Prix de vente, s'il  existe déjà ne rien faire
    QRYEVO('PVT_ID,PVT_PX',
      'TARPRIXVENTE', 'PVT_ID',
      Format('PVT_ARTID=%d  and PVT_TGFID=0 and PVT_TVTID=0', [ART_ID]));
    IF qry_div.IsEmpty THEN
    BEGIN
      // Maj du prix vente si prix de vente inexixtant
      IF ((MenArtPV.AsString = '') OR (MenArtPV.AsFloat = 0) OR (MenArtPV.AsFloat = 1)) THEN
      BEGIN
        IF (MenArtPV.AsString = '') THEN
          RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est VIDE ! Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
        IF (MenArtPV.AsFloat = 1) THEN
          Px := MenArtPV.AsFloat / 100
        ELSE Px := 0;
        RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est de ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      END;
      i := AjoutCleScript(Script, 'TARPRIXVENTE');
      AjouteScrQry(Script, 'TARPRIXVENTE',
        'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX',
        '%d,0,%d,0,%.2f',
        [i, ART_ID, MenArtPV.AsFloat / 100]);
    END;
    //Stan

    Menart.Edit;
    MenartART_ID.AsInteger := ART_ID;
    MenArtARF_ID.AsInteger := ARF_ID;
    Menart.Post;
    //Création de la collection si besoin
    IF FluxJanvier2008 THEN
      S := QuotedStr(UpperCase(MenArtCOLLECTION.AsString))
    ELSE
      S := QuotedStr(UpperCase(MenArtCSAI.AsString) + ' ' + UpperCase(MenArtANNEE.AsString));
    MemD_ArtCol.open;
    MemD_ArtCol.first;
    WHILE NOT (MemD_ArtCol.eof) AND (UpperCase(MemD_ArtColCOL_NOM.AsString) <> S) DO
      MemD_ArtCol.next;
    IF (MemD_ArtCol.eof) AND (UpperCase(MemD_ArtColCOL_NOM.AsString) <> S) THEN
    BEGIN
      QRYEVO('COL_ID', 'ARTCOLLECTION', 'COL_ID',
        Format('COL_ID<>0 AND UPPER(COL_NOM)=%s', [S]));
      IF qry_div.IsEmpty THEN
      BEGIN
        COL_ID := AjoutCleScript(Script, 'ARTCOLLECTION');
        AjouteScrQry(Script, 'ARTCOLLECTION', 'COL_ID,COL_NOM,COL_NOVISIBLE', '%d,%s,0', [COL_ID, S]);
      END
      ELSE
        COL_ID := qry_div.Fields[0].asInteger;
      MemD_ArtCol.AppendRecord([NIL, COL_ID, S]);
    END
    ELSE
      COL_ID := MemD_ArtColCOL_ID.asinteger;
//JB
    Menart.Edit;
    MenartCOL_ID.AsInteger := COL_ID;
    Menart.Post;
//
    MemD_ArtColArt.Open;
    MemD_ArtColArt.first;
    WHILE NOT (MemD_ArtColArt.eof) AND (
      (MemD_ArtColArtCAR_ARTID.AsInteger <> ART_ID) OR
      (MemD_ArtColArtCAR_COLID.AsInteger <> COL_ID)) DO
      MemD_ArtColArt.Next;
    IF (MemD_ArtColArt.eof) AND (
      (MemD_ArtColArtCAR_ARTID.AsInteger <> ART_ID) OR
      (MemD_ArtColArtCAR_COLID.AsInteger <> COL_ID)) THEN
    BEGIN
      QRYEVO('CAR_ID', 'ARTCOLART', 'CAR_ID',
        Format('CAR_ARTID=%d and CAR_COLID=%d', [ARt_ID, COL_ID]));
      IF qry_div.IsEmpty THEN
      BEGIN
        I := AjoutCleScript(Script, 'ARTCOLART');
        AjouteScrQry(Script, 'ARTCOLART', 'CAR_ID,CAR_ARTID,CAR_COLID', '%d,%d,%d', [i, ART_ID, COL_ID]);
      END
      ELSE i := qry_div.Fields[0].asInteger;
      MemD_ArtColArt.AppendRecord([NIL, i, ART_ID, COL_ID]);
    END;
    // Entete de la grille de taille
    MenEntTail.First;
    WHILE NOT MenEntTail.eof AND (MenEntTailITEMID.AsString <> MenArtCTAI.AsString) DO
      MenEntTail.Next;
    // Création des codes barres de l'article de type 1
    IF (MenEntTailITEMID.AsString = MenArtCTAI.AsString) THEN
    BEGIN
      //On vérifie qu'il ne manque pas des codes barres de type1 pour l'article
      //et on les crée s'ils manquent
      CreateMissingType1CB(ART_ID, ARF_ID, script);
    END
    ELSE
      RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' impossible de trouver la grille de taille : ' + MenArtCTAI.AsString + ' dans le fichier TAI_xx.xml');

    // Si le CB existe déjà on ne le prend pas
    MenCB.first;
    WHILE NOT MenCB.Eof DO
    BEGIN
      IF (trim(MenCBBARRE.AsString) = '') THEN
        MenCB.Delete
      ELSE IF (MenCBARTICLEID.AsString = MenArtITEMID.AsString) THEN
      BEGIN
        MEMD_COU.First;
        IF FluxJanvier2008 THEN
        BEGIN
          IF (MenCBIDCOLORIS.AsString <> '') THEN
            WHILE (NOT MEMD_COU.eof)
              AND ((MemD_COUART_ID.AsInteger <> ART_ID)
              OR (MenCBIDCOLORIS.AsString <> MemD_COUIDCOLORIS.AsString)) DO
              MEMD_COU.Next;
        END;
        IF (MenCBIDCOLORIS.AsString = '') THEN
          IF (MenCBCODECOLORIS.AsString <> '') THEN
            WHILE (NOT MEMD_COU.eof)
              AND ((MemD_COUART_ID.AsInteger <> ART_ID)
              OR (MenCBCODECOLORIS.AsString <> MemD_COUCODECOLORIS.AsString)) DO
              MEMD_COU.Next;

        IF (MemD_COUART_ID.AsInteger = ART_ID)
          AND (MenCBIDCOLORIS.AsString = MemD_COUIDCOLORIS.AsString)
          AND (MenCBCODECOLORIS.AsString = MemD_COUCODECOLORIS.AsString) THEN
        BEGIN
          COU_ID := MemD_COUCOU_ID.AsInteger;
          MenLigTail.first;
          WHILE NOT MenLigTail.eof DO
          BEGIN
            IF (MenLigTailITEMID.AsString = MenEntTailITEMID.AsString) THEN
            BEGIN
              IF FluxJanvier2008 AND (MenCBCODETAILLE.AsString <> '')
                AND (MenLigTailCODETAILLE.AsString = MenCBCODETAILLE.AsString) THEN
              BEGIN
                TGF_ID := MenLigTailTGF_ID.AsInteger;
                QRYEVO('CBI_ID', 'ARTCODEBARRE', 'CBI_ID',
                  Format('CBI_CB=%s and CBI_ARFID=%d', [QuotedStr(MenCBBARRE.AsString), ARF_ID]));
                IF qry_div.IsEmpty THEN
                BEGIN
                  // création du code barre
                  i := AjoutCleScript(Script, 'ARTCODEBARRE');
                  S := QuotedStr(MenCBBARRE.AsString);
                  AjouteScrQry(Script, 'ARTCODEBARRE',
                    'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC',
                    '%d,%d,%d,%d,%s,3,0,0,%d',
                    [i, ARF_ID, TGF_ID, COU_ID, s,MenCBCBI_LOC.AsInteger]);
                END
                ELSE BEGIN
                  // Mise à jour du code à barre
                  // Récupération du CBI_ID à mettre à jour si le CBI_LOC = 0
                  i := qry_div.FieldByName('CBI_ID').AsInteger;
                  QRYEVO('CBI_ID','ARTCODEBARRE','CBI_ID',Format('CBI_ID=%d and CBI_LOC = 0',[i]));
                  // est ce que le CBI_LOC
                  IF not qry_div.IsEmpty THEN
                  BEGIN
                    MajScrQry(Script,'ARTCODEBARRE','CBI_LOC = %d',[MenCBCBI_LOC.AsInteger],'CBI_ID',IntToStr(i));
                  END;
                END;
              END
              ELSE IF (MenLigTailTAILLE.AsString = MenCBLTAI.AsString) THEN
              BEGIN
                TGF_ID := MenLigTailTGF_ID.AsInteger;
                QRYEVO('CBI_ID', 'ARTCODEBARRE', 'CBI_ID',
                  Format('CBI_CB=%s and CBI_ARFID=%d', [QuotedStr(MenCBBARRE.AsString), ARF_ID]));
                IF qry_div.IsEmpty THEN
                BEGIN
                  // création du code barre
                  i := AjoutCleScript(Script, 'ARTCODEBARRE');
                  S := QuotedStr(MenCBBARRE.AsString);
                  AjouteScrQry(Script, 'ARTCODEBARRE',
                    'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC',
                    '%d,%d,%d,%d,%s,3,0,0,0',
                    [i, ARF_ID, TGF_ID, COU_ID, s]);
                END
              END
            END;
            MenLigTail.next;
          END
        END
      END;
      MenCB.Next;
    END;
    Menart.Next;
  END;
  IF premier <> '' THEN
  BEGIN
    IF dernier <> premier THEN
      resultat.add('Intégration des articles ' + premier + ' à ' + dernier + '<BR>')
    ELSE
      resultat.add('Intégration de l''article ' + premier + '<BR>');
  END
  ELSE
    resultat.add('Pas d''article à intégrer' + '<BR>');

  //Intégration des commandes
  IF MenEntCom.RecordCount > 0 THEN
  BEGIN
    QRYEVO('EXE_ID', 'GENEXERCICECOMMERCIAL', 'EXE_ID',
      Format('%s between EXE_DEBUT and EXE_FIN', [Quotedstr(FormatDatetime('MM/DD/YYYY', Date))]));
    IF QRY_Div.IsEmpty THEN
      QRYEVO('EXE_ID', 'GENEXERCICECOMMERCIAL', 'EXE_ID',
        'EXE_ID<>0 ORDER BY EXE_DEBUT DESC');
    EXE_ID := QRY_Div.Fields[0].AsInteger;
    Lab_etat2.Caption := 'Création des Commandes';
    Lab_etat2.Update;
    pb2.Position := 0;
    pb2.Max := MenEntCom.recordcount;
    MenEntCom.First;
    Premier := '';
    Dernier := '';
    WHILE NOT MenEntCom.Eof DO
    BEGIN
//JB
      COL_IDMemo := 0;
      MenLigCom.First;
      // On balaye les lignes de commande pour récupérer la collection
      WHILE NOT MenLigCom.Eof DO
      BEGIN
        IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
        BEGIN
          // recherche de l'article pour récupérer la Collection
          MenArt.First;
          WHILE NOT (MenArt.eof) AND (MenArtITEMID.AsString <> MenLigComARTICLEID.AsString) DO
            MenArt.Next;
          IF MenArtITEMID.AsString = MenLigComARTICLEID.AsString THEN
            COL_IDMemo := MenArtCOL_ID.AsInteger;
        END;
        MenLigCom.next;
      END;
//
      pb2.Position := pb2.Position + 1;
      Prix := 0;
      MenLigCom.First;
      WHILE NOT MenLigCom.Eof DO
      BEGIN
        IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
        BEGIN

          IF ((MenLigComPANET.AsFloat = 0) OR (MenLigComPANET.AsFloat = 1)) THEN
          BEGIN
            IF (MenLigComPANET.AsFloat = 1) THEN
              Px := MenLigComPANET.AsFloat / 100
            ELSE Px := 0;
            RAISE Exception.Create('Dans la commande n° ' + MenEntComNUMCDE.AsString + 'pour l''Artcile ' + MenLigComRFOU.asString + ' le prix d''ACHAT NET est ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
          END;

          IF ((MenArtPV.AsFloat = 0) OR (MenArtPV.AsFloat = 1)) THEN
          BEGIN
            IF (MenArtPV.AsFloat = 1) THEN
              Px := MenArtPV.AsFloat / 100
            ELSE Px := 0;
            RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est de ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
          END;

          Prix := prix + (MenLigComPANET.AsInteger / 100) * MenLigComQTE.AsInteger
        END;
        MenLigCom.next;
      END;

      // attention on trouve uniquement la marque !!
      MemFou.First;
      IF FluxJanvier2008 AND (MenEntComIDFOURNISSEUR.AsString <> '') THEN
        WHILE NOT (MemFou.EOF) AND (MenEntComIDFOURNISSEUR.AsString <> MemFouIDFOURNISSEUR.AsString) DO
          MemFou.Next
      ELSE
        WHILE NOT (MemFou.EOF) AND (MenEntComCFOU.AsString <> MemFouMARQUE.AsString) DO
          MemFou.Next;

      CDE_ID := AjoutCleScript(Script, 'COMBCDE');
      QRY(['SELECT NEWNUM FROM BC_NEWNUM']);
      NumCDE := QRY_Div.Fields[0].AsString;
      IF Premier = '' THEN
        Premier := NumCDE;
      Dernier := NumCDE;

      S := MenEntComDCDE.AsString;
      DATE_COM := QuotedStr(Copy(S, 5, 2) + '/' + Copy(S, 7, 2) + '/' + Copy(S, 1, 4));

      S := MenEntComDLIV.AsString;
      DATE_LIV := QuotedStr(Copy(S, 5, 2) + '/' + Copy(S, 7, 2) + '/' + Copy(S, 1, 4));

      //            IF nom = 'OPERATIONSP_NOEL 2006_2006' THEN date_liv := QuotedStr('11/01/2006');
      //            IF nom = 'OPERATIONSP_RENTREE DES CLUBS 06_2006' THEN date_liv := QuotedStr('08/01/2006');
      //            IF nom = 'OPERATIONSP_RENTREE DES CLASSES 06_2006' THEN date_liv := QuotedStr('07/01/2006');
      IF pos('*', MenEntComNUMCDE.AsString) <> 0 THEN
        NumCDE_Fou := Copy(MenEntComNUMCDE.AsString, 0, pos('*', MenEntComNUMCDE.AsString) - 1)
      ELSE NumCDE_Fou := MenEntComNUMCDE.AsString;

      AjouteScrQry(Script, 'COMBCDE',
        'CDE_ID,CDE_NUMERO,CDE_SAISON,CDE_EXEID,CDE_CPAID,' +
//JB
        'CDE_COLID,' +
//
        'CDE_MAGID,CDE_FOUID,CDE_NUMFOURN,CDE_DATE,CDE_REMISE,' +
        'CDE_TVAHT1,CDE_TVATAUX1,CDE_TVA1,CDE_TVAHT2,CDE_TVATAUX2,' +
        'CDE_TVA2,CDE_TVAHT3,CDE_TVATAUX3,CDE_TVA3,CDE_TVAHT4,' +
        'CDE_TVATAUX4,CDE_TVA4,CDE_TVAHT5,CDE_TVATAUX5,CDE_TVA5,' +
        'CDE_FRANCO,CDE_MODIF,CDE_LIVRAISON,CDE_OFFSET,CDE_REMGLO,' +
        'CDE_ARCHIVE,CDE_REGLEMENT,CDE_TYPID,CDE_NOTVA',
        '%d,%s,%d,%d,%d,' +
//JB
        '%d,' +
//
        '%s,%s,%s,%s,0,' +
        '%.2f,%.2f,%.2f,0,0,' +
        '0,0,0,0,0,' +
        '0,0,0,0,0,' +
        '1,0,%s,0,0,' +
        '0,Null, %d,0',
        [CDE_ID, QuotedStr(NumCDE), SAISON, EXE_ID, CPA_ID,
//JB
         COL_IDMemo,
//
         MenEntComMAG_ID.AsString, MemFouFOU_ID.AsString, QuotedStr(NumCDE_Fou), DATE_COM,
         Prix, TVA_TAUX, prix * TVA_TAUX / 100,
         DATE_LIV,
         TYP_ID]);

      OldArtiID := 0;
      MenLigCom.First;
      WHILE NOT MenLigCom.Eof DO
      BEGIN
        IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
        BEGIN
          // recherche de l'article
          MenArt.First;
          WHILE NOT (MenArt.eof) AND (MenArtITEMID.AsString <> MenLigComARTICLEID.AsString) DO
            MenArt.Next;
          // si pas trouvé sortie en erreur
          IF MenArtITEMID.AsString <> MenLigComARTICLEID.AsString THEN
          BEGIN
            RAISE Exception.Create('Incohérence entre le fichier des articles et celui des commandes pour la commande ' + MenLigComNUMCDE.AsString + ', traitement interrompu <br /> article ' + MenLigComRFOU.AsString + ' inexistant');
          END;
          ART_ID := MenArtART_ID.AsInteger;
          if OldArtiID <> ART_ID then
          begin
            OldArtiID  := ART_ID;
            iNewTail := 0;
            // Récupération du nombre de taille déjà enregisté pour ce modèle
            QRY([Format('SELECT COUNT(*) as NB FROM PLXTAILLESTRAV JOIN K ON K_ID = TTV_ID and K_ENABLED = 1 Where TTV_ARTID = %d',[ART_ID])]);
            iNbTAilBase := QRY_Div.FieldByName('nb').AsInteger;
          end;
          COL_ID := MenArtCOL_ID.AsInteger;
          MemD_COU.First;
          IF FluxJanvier2008 AND (MenLigComIDCOLORIS.AsString <> '') THEN
            WHILE NOT (MemD_COU.Eof) AND
              ((MemD_COUART_ID.AsInteger <> ART_ID) OR
              (MenLigComIDCOLORIS.AsString <> MemD_COUIDCOLORIS.AsString)) DO
              MemD_COU.next
          ELSE
            WHILE NOT (MemD_COU.Eof) AND
              ((MemD_COUART_ID.AsInteger <> ART_ID) OR
              (MenLigComCODECOLORIS.AsString <> MemD_COUCODECOLORIS.AsString)) DO
              MemD_COU.next;

          IF (MemD_COUART_ID.AsInteger <> ART_ID) OR
            (MenLigComCODECOLORIS.AsString <> MemD_COUCODECOLORIS.AsString) THEN
          BEGIN
            RAISE Exception.Create('Incohérence entre le fichier des articles et celui des commandes pour la commande ' + MenLigComNUMCDE.AsString + ', traitement interrompu <br /> article ' + MenLigComRFOU.AsString + ' couleur ' + MenLigComCODECOLORIS.AsString + ' inexistant');
          END;
          COU_ID := MemD_COUCOU_ID.AsInteger;
          // recherche de la grille de taille
          MenEntTail.First;
          WHILE NOT MenEntTail.eof
            AND (MenEntTailITEMID.AsString <> MenArtCTAI.AsString) DO
            MenEntTail.Next;
          // recherche de la taille
          IF (MenEntTailITEMID.AsString = MenArtCTAI.AsString) THEN
          BEGIN
            MenLigTail.first;
            IF FluxJanvier2008 AND (MenLigComCODETAILLE.AsString <> '') AND (MenLigComCODETAILLE.AsString <> '0') THEN
              WHILE NOT (MenLigTail.Eof) AND ((MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
                (MenLigTailCODETAILLE.AsString <> MenLigComCODETAILLE.AsString)) DO
                MenLigTail.Next
            ELSE
              WHILE NOT (MenLigTail.Eof) AND ((MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
                (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString)) DO
                MenLigTail.Next;
          END;
          IF (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString) THEN
          BEGIN
            RAISE Exception.Create('Incohérence entre le fichier des tailles et celui des commandes pour la commande ' + MenLigComNUMCDE.AsString + ', traitement interrompu <br /> article ' + MenLigComRFOU.AsString + ' taille ' + MenLigComLTAIL.AsString + ' incoherante');
          END;
          TGF_ID := MenLigTailTGF_ID.Asinteger;

          QRYEVO('TTV_ID', 'PLXTAILLESTRAV', 'TTV_ID',
            Format('TTV_ARTID=%d and TTV_TGFID=%d', [ART_ID, TGF_ID]));
          IF QRY_Div.isempty THEN
          BEGIN
            // vérification du nombre de tailles déja utilisées
            if (iNbTAilBase + iNewTail < 28) then
            begin
              i := AjoutCleScript(Script, 'PLXTAILLESTRAV');
              AjouteScrQry(Script, 'PLXTAILLESTRAV',
                'TTV_ID,TTV_ARTID,TTV_TGFID',
                '%d, %d, %d',
                [I, ART_ID, TGF_ID]);
              Inc(iNewTail);
            end;
          END;

          remise := 100 * (1 - ((MenLigComPANET.AsFloat / 100) / (MenLigComPA.AsFloat / 100)));
          CDL_ID := AjoutCleScript(Script, 'COMBCDEL');
          AjouteScrQry(Script, 'COMBCDEL',
            'CDL_ID,CDL_CDEID,CDL_ARTID,CDL_TGFID,CDL_COUID,' +
//JB
            'CDL_COLID,' +
//
            'CDL_QTE,CDL_PXCTLG,CDL_REMISE1,CDL_REMISE2,CDL_REMISE3,' +
            'CDL_PXACHAT,CDL_TVA,CDL_PXVENTE,CDL_OFFSET,CDL_LIVRAISON,' +
            'CDL_TARTAILLE,CDL_VALREMGLO',
            '%d,%d,%d,%d,%d,' +
//JB
            '%d,' +
//
            '%s,%.2f,%.2f,0,0,' +
            '%.2f,%.2f,%.2f,0,%s,' +
            '0,0',
            [CDL_ID, CDE_ID, ART_ID, TGF_ID, COU_ID,
//JB
             COL_ID,
//
             MenLigComQTE.AsString, MenLigComPA.AsFloat / 100, remise,
             MenLigComPANET.AsFloat / 100, TVA_TAUX, MenArtPV.AsFloat / 100, DATE_LIV]);
          MenLigCom.Delete;
        END
        ELSE
          MenLigCom.next;
      END;
      MenEntCom.Next;
    END;

    IF premier <> '' THEN
    BEGIN
      IF dernier <> premier THEN
        resultat.add('Intégration des commandes ' + premier + ' à ' + dernier + '<BR>')
      ELSE
        resultat.add('Intégration de la commande ' + premier + '<BR>');
    END
    ELSE
      resultat.add('Pas de commande à intégrer' + '<BR>');
  END
  ELSE
  BEGIN
    // pas de commande création des tailles travaillées pour tous les articles
    Lab_etat2.Caption := 'Finalisation des fiches articles';
    Lab_etat2.Update;
    pb2.Position := 0;
    pb2.Max := MenArt.recordcount;
    MenArt.first;
    OldArtiID := 0;
    WHILE NOT MenArt.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      ART_ID := MenArtART_ID.AsInteger;

      if OldArtiID <> ART_ID then
      begin
        OldArtiID  := ART_ID;
        iNewTail := 0;
        // Récupération du nombre de taille déjà enregisté pour ce modèle
        QRY([Format('SELECT COUNT(*) as NB FROM PLXTAILLESTRAV JOIN K ON K_ID = TTV_ID and K_ENABLED = 1 Where TTV_ARTID = %d',[ART_ID])]);
        iNbTAilBase := QRY_Div.FieldByName('nb').AsInteger;
      end;

      // recherche de la grille de taille
      MenEntTail.First;
      WHILE (NOT MenEntTail.eof) AND (MenEntTailITEMID.AsString <> MenArtCTAI.AsString) DO
        MenEntTail.Next;
      // recherche de la taille
      IF (MenEntTailITEMID.AsString = MenArtCTAI.AsString) THEN
      BEGIN
        MenLigTail.first;
        WHILE (NOT MenLigTail.eof) AND (MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) DO
          MenLigTail.Next;
        WHILE (NOT MenLigTail.eof) AND (MenLigTailITEMID.AsString = MenEntTailITEMID.AsString) DO
        BEGIN
          TGF_ID := MenLigTailTGF_ID.Asinteger;

          QRYEVO('TTV_ID', 'PLXTAILLESTRAV', 'TTV_ID',
            Format('TTV_ARTID=%d and TTV_TGFID=%d', [ART_ID, TGF_ID]));
          IF QRY_Div.isempty THEN
          BEGIN
            // vérification du nombre de tailles déja utilisées
            if (iNbTAilBase + iNewTail < 28) then
            begin
              i := AjoutCleScript(Script, 'PLXTAILLESTRAV');
              AjouteScrQry(Script, 'PLXTAILLESTRAV',
                'TTV_ID,TTV_ARTID,TTV_TGFID',
                '%d, %d, %d',
                [I, ART_ID, TGF_ID]);
              Inc(iNewTail);
            end;
          END;
          MenLigTail.Next;
        END;
      END;
      MenArt.next;
    END;
  END;
  IF Tran.InTransaction THEN
    tran.rollback;
  TRY
    Tran.StartTransaction;
    QRY_Div.Close;
    QRY_Div.Sql.Clear;
    Lab_etat2.Caption := 'Validation du travail';
    Lab_etat2.Update;
    //  Script.Savetofile(RepXML + Nom + '.SQL');
    pb2.Position := 0;
    pb2.Max := Script.Count;
    FOR i := 0 TO Script.Count - 1 DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IF Script[i] <> '¤¤¤' THEN
        QRY_Div.Sql.Add(Script[i])
      ELSE
      BEGIN
        QRY_Div.ExecSQL;
        QRY_Div.Sql.Clear;
      END;
    END;
  EXCEPT
    Script.free;
    Lab_etat2.Caption := '';
    Lab_etat2.Update;
    pb2.Position := 0;
    tran.Rollback;
    RAISE;
  END;
  tran.Commit;
  Script.free;
  Lab_etat2.Caption := '';
  Lab_etat2.Update;
  pb2.Position := 0;
END;

PROCEDURE TFrm_IntNikePrin.FormPaint(Sender: TObject);
BEGIN
  IF ParametrageAFaire THEN
  BEGIN
    ParametrageAFaire := False;
    Paramtrage1Click(NIL);
  END;
END;

procedure TFrm_IntNikePrin.GetBaseInfo(out AGUID: string; out AMAGID: Integer);
var
  Ident : string;
begin
  with Tibquery.Create(nil)do
  try
    Database := Data;

    Close;
    SQL.Clear;
    SQL.Add('Select PAR_STRING FROM GENPARAMBASE');
    SQL.Add('Where PAR_NOM = ''IDGENERATEUR''');
    Open;
    Ident := FieldByName('PAR_STRING').AsString;

    Close;
    SQL.Clear;
    SQL.Add('Select BAS_GUID, BAS_MAGID FROM GENBASES');
    SQL.Add('  Join K on K_ID = BAS_ID and K_Enabled = 1');
    SQL.Add('Where BAS_IDENT = :PIDENT');
    ParamCheck := True;
    ParamByName('PIDENT').AsString := Ident;
    Open;

    AGUID := FieldByName('BAS_GUID').AsString;
    AMAGID := FieldByName('BAS_MAGID').AsInteger;
  finally
    Free;
  end;
end;

function TFrm_IntNikePrin.GetGestion_K_VERSION: TGestion_K_Version;
begin
  if (FGestion_K_VERSION = TKNone) then
    Check_Mode_K_VERSION();

  Result := FGestion_K_VERSION;
end;

FUNCTION TFrm_IntNikePrin.transforme(XML: IXMLCursor): TStringList;
VAR
  s, ss: STRING;
BEGIN
  result := tstringlist.create;
  WHILE NOT XML.eof DO
  BEGIN
    S := XML.GetName;
    SS := XML.XML;
    Delete(SS, 1, length(S) + 2);
    delete(ss, pos('<', ss), length(ss));
    IF SS = '>' THEN
      SS := '';
    result.values[S] := SS;
    XML.next;
  END;
END;

PROCEDURE TFrm_IntNikePrin.Rapports1Click(Sender: TObject);

BEGIN
  IF od_rapp.Execute THEN ShellExecute(Application.handle, 'open', Pchar(od_rapp.filename), NIL, '', SW_SHOWDEFAULT);

END;

PROCEDURE TFrm_IntNikePrin.Aide1Click(Sender: TObject);
VAR
  PC: ARRAY[0..1024] OF char;
BEGIN
  IF FindExecutable(Pchar(ExtractFilePath(Application.EXEName) + 'Bpl\Referencement-Commande-SP2000.pdf'), '', PC) = 31 THEN
  BEGIN
    // install de Acrobat
    application.messagebox(
      '      Veuillez installer une version d''Acrobat Reader(TM) ' + #13 + #10 +
      ' Une version est disponible sur le CD d''installation de Ginkoia ',
      ' Avertissement...',
      MB_OK);
  END
  ELSE
  BEGIN
    IF ShellExecute(Application.handle, 'open', Pchar(ExtractFilePath(Application.EXEName) + 'Bpl\Referencement-Commande-SP2000.pdf'), NIL, '', SW_SHOWDEFAULT) = ERROR_FILE_NOT_FOUND THEN
    BEGIN
      application.messagebox(
        '      Le fichier n''est pas présent dans ce repertoire !',
        ' Erreur...',
        MB_OK);
    END;
  END;
  {
  IF application.Helpfile = '' THEN Exit;
  HRout_main.HelpContent;
  }
END;

PROCEDURE TFrm_IntNikePrin.FedassousExcel1Click(Sender: TObject);
VAR
  PC: ARRAY[0..1024] OF char;
BEGIN
  IF FindExecutable(Pchar(ExtractFilePath(Application.EXEName) + 'Bpl\CodeFedasSp2k.xls'), '', PC) = 31 THEN
  BEGIN
    // install de Acrobat
    application.messagebox(
      '      Veuillez installer une version d''Excel !',
      ' Avertissement...',
      MB_OK);
  END
  ELSE
  BEGIN
    IF ShellExecute(Application.handle, 'open', Pchar(ExtractFilePath(Application.EXEName) + 'Bpl\CodeFedasSp2k.xls'), NIL, '', SW_SHOWDEFAULT) = ERROR_FILE_NOT_FOUND THEN
    BEGIN
      application.messagebox(
        '      Le fichier n''est pas présent dans ce repertoire !',
        ' Erreur...',
        MB_OK);
    END;
  END;
  {
  IF application.Helpfile = '' THEN Exit;
  HRout_main.HelpContent;
  }
END;

PROCEDURE TFrm_IntNikePrin.Apropos1Click(Sender: TObject);
BEGIN
  AboutDlg_Main.Execute;
END;

procedure TFrm_IntNikePrin.CreateMissingType1CB(AArticleId, AArfId: integer; Script: TstringList);
var
  i: integer;
  id: integer;
  cb: string;
  art: TArticle;
  cbtype1list: TArticleCodeBarreType1Array;
begin
  art := TArticle.Create(AArticleId, AArfId);

  try
    // On parcours toutes les tailles lu dans le fichier TAI_....xml et on s'assure qu'elle
    // sont connues de l'article "art" en les lui ajoutant
    MenLigTail.first;
    while not MenLigTail.eof do
    begin
      art.AddTaille(MenLigTailTGF_ID.AsInteger, MenLigTailITEMID.AsString,
        MenLigTailTAILLE.AsString, MenLigTailTRAVAIL.AsInteger, MenLigTailCODETAILLE.AsString);
      MenLigTail.Next;
    end;

    // On parcours toutes les couleurs de l'article en cours lu dans fichier ART_....xml et on s'assure qu'elle
    // sont connues de l'article "art" en les lui ajoutant
    MEMD_COU.First;
    while (not MEMD_COU.eof) and (MemD_COUART_ID.AsInteger <> AArticleId) do
      MEMD_COU.Next;
    while (not MEMD_COU.eof) and (MemD_COUART_ID.AsInteger = AArticleId) do
    begin
      art.AddCouleur(MemD_COUCOU_ID.AsInteger, MemD_COUIDCOLORIS.AsString,
        MemD_COUCODECOLORIS.AsString, MemD_COUDESCRIPTIF.AsString,
        MemD_COUITEMID.AsString, MemD_COUVALIDE.AsInteger);
      MemD_COU.Next;
    end;

    //Récupération de la liste des code barres de type1 manquants
    cbtype1list := art.MissingType1CB;
    for i := 0 to Length(cbtype1list) - 1 do
    begin
      // création du code barre
      id := AjoutCleScript(Script, 'ARTCODEBARRE');
      IBST_CB.Prepare;
      IBST_CB.ExecProc;
      cb := QuotedStr(IBST_CB.Parambyname('NEWNUM').AsString);
      IBST_CB.UnPrepare;
      IBST_CB.Close;
      AjouteScrQry(Script, 'ARTCODEBARRE',
        'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC',
        '%d,%d,%d,%d,%s,1,0,0,0',
        [id, cbtype1list[i].ArfId, cbtype1list[i].TgfId, cbtype1list[i].CouId, cb]);
    end;
  finally
    FreeAndNil(art);
  end;
end;






END.


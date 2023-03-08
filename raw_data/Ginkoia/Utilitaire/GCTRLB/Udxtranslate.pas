unit UdxTranslate;

interface

uses ComCtrls, DBTables, Windows, Classes, iniFiles, Forms, DBClient, Dialogs,
  cxClasses, cxGridStrs, cxFilterControlStrs, cxFilterConsts, cxEditConsts,
  cxDataConsts, menus, Sysutils, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxEdit, cxDBData, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxImageComboBox, cxGridBandedTableView, cxGridDBBandedTableView,
  cxDBLookupComboBox, cxCurrencyEdit, StdCtrls, ActnList,Graphics,
  cxGridPopupMenuConsts,dxPsRes;

Procedure Chargement_Langue;
// Toutes les Resourcestring commence par un "F"  = En Français
resourcestring
  // Lié au Fichier cxGridStrs.pas (devexpress)
  // Racine scxGrid
  FscxGridNoDataInfoText = '<Aucune Donnée>';
  FscxGridColumnsQuickCustomizationHint = 'Cliquez ici pour afficher/cacher/déplacer des colonnes';
  FscxGridBandsQuickCustomizationHint = 'Cliquez ici pour afficher/cacher/déplacer des bandes';
  FscxGridRecursiveLevels = 'Vous ne pouvez pas créer des niveaux récursifs';
  FscxGridDeletingConfirmationCaption = 'Confirmation';
  FscxGridDeletingFocusedConfirmationText = 'Effacer l''enregistrement ?';
  FscxGridDeletingSelectedConfirmationText = 'Effacer tous les enregsitrements séléctionnés ?';
  FscxGridFilterIsEmpty = '<Filtre Vide>';
  FscxGridCustomizationFormCaption = 'Personnalisation';
  FscxGridCustomizationFormColumnsPageCaption = 'Colonnes';
  FscxGridGroupByBoxCaption = '(Pour grouper par un champs faites glisser ici son entête)';
  FscxGridFilterCustomizeButtonCaption = 'Personnaliser...';
  FscxGridCustomizationFormBandsPageCaption = 'Bandes';
  FscxGridConverterIntermediaryMissing = 'Missing an intermediary component!'#13#10'Please add a %s component to the form.';
  FscxGridConverterNotExistGrid = 'cxGrid n''esiste pas';
  FscxGridConverterNotExistComponent = 'Component does not exist';
  FscxGridConverterCantCreateStyleRepository = 'Can''t create the Style Repository';

  FscxImportErrorCaption = 'Erreur d''Importation';
  FscxNotExistGridView = 'Grid view n''existe pas';
  FscxNotExistGridLevel = 'Active grid level n''existe pas';
  FscxCantCreateExportOutputFile = 'Can''t create the export output file';
  FcxSEditRepositoryExtLookupComboBoxItem = 'ExtLookupComboBox|Represents an ultra-advanced lookup using the QuantumGrid as its drop down control';


  // Lié au fichier cxGridPopupMenuConsts.pas (devexpress)
  // Racine cxSGrid
  FcxSGridNone = 'Aucun';
  FcxSGridSortColumnAsc = 'Tri Croissant';
  FcxSGridSortColumnDesc = 'Tri Décroissant';
  FcxSGridClearSorting = 'Aucun Tri';
  FcxSGridGroupByThisField = 'Grouper par ce champs';
  FcxSGridGroupByBox = 'Groupemement';
  FcxSGridAlignmentSubMenu = 'Alignement';
  FcxSGridAlignLeft = 'Aligner à Gauche';
  FcxSGridAlignRight = 'Aligner à Droite';
  FcxSGridAlignCenter = 'Centrer';
  FcxSGridRemoveColumn = 'Enlever Cette Colonne';
  FcxSGridFieldChooser = 'Colonne...';
  FcxSGridBestFit = 'Ajuster';
  FcxSGridBestFitAllColumns = 'Ajuster (toutes les colonnes)';
  FcxSGridShowFooter = 'Pied';
  FcxSGridShowGroupFooter = 'Pied de Groupe';

  FcxSFilterOperatorContains = 'Contient';
  FcxSFilterOperatorDoesNotContain =  'Ne contient pas';
  FcxSFilterBoxAllCaption =  '(Tous)';
  FcxSFilterBoxCustomCaption =  '(Personnaliser...)';
  FcxSFilterBoxBlanksCaption = '(Vides)';
  FcxSFilterBoxNonBlanksCaption = '(Non Vides)';

  FcxSEditValueOutOfBounds            = 'Valeur hors plage';

  // date
  FcxSDatePopupToday                  = 'Aujourd''hui';
  FcxSDatePopupClear                  = 'Effacer';
  FcxSDateError                       = 'Date Invalide';

  FcxNavigator_DeleteRecordQuestion = 'Effacer l''enregistrement ?';

  // Lié au Fichier : dxPSRes.pas (devexpress)
  FsdxBtnOK              = 'OK';
  FsdxBtnOKAccelerated   = '&OK';
  FsdxBtnCancel          = 'Annuler';
  FsdxBtnClose           = 'Fermer';
  FsdxBtnApply           = 'Appliquer';
  FsdxBtnHelp            = 'Aide';
  FsdxBtnFix             = '&Fixe';
  FsdxBtnNew             = '&Nouveau...';
  FsdxBtnIgnore          = '&Ignorer';
  FsdxBtnYes             = '&Oui';
  FsdxBtnNo              = '&Non';
  FsdxBtnEdit            = '&Editer...';
  FsdxBtnReset           = '&Effacer';
  FsdxBtnAdd             = '&Ajouter';
  FsdxBtnAddComposition  = 'Ajouter une &Composition';
  FsdxBtnDefault         = '&Defaut...';
  FsdxBtnDelete          = '&Effacer...';
  FsdxBtnDescription     = '&Description...';
  FsdxBtnCopy            = '&Copier...';
  FsdxBtnYesToAll        = 'Oui à Tous';
  FsdxBtnRestoreDefaults = '&Paramètres par défaut';
  FsdxBtnRestoreOriginal = 'Restaurer l''&Original';
  FsdxBtnTitleProperties = 'Title Properties...';
  FsdxBtnProperties      = 'P&ropriétés...';
  FsdxBtnNetwork         = 'Réseau...';
  FsdxBtnBrowse          = '&Explorer...';
  FsdxBtnPageSetup       = 'Mise en Pa&ge...';
  FsdxBtnPrintPreview    = 'Print Pre&view...';
  FsdxBtnPreview         = 'Prévisualiser...';
  FsdxBtnPrint           = 'Imprimer...';
  FsdxBtnOptions         = '&Options...';
  FsdxBtnStyleOptions    = 'Options de Style...';
  FsdxBtnDefinePrintStyles = '&Definir les Styles...';
  FsdxBtnPrintStyles      = 'Imprimer les Styles';
  FsdxBtnBackground       = 'Arrière plan';
  FsdxBtnShowToolBar      = 'Montrer la barre d''outils';
  FsdxBtnDesign           = 'D&esigner...';
  FsdxBtnMoveUp           = 'Monter';
  FsdxBtnMoveDown         = 'Descendre';

  FsdxBtnMoreColors       = '&Plus de couleurs...';
  FsdxBtnFillEffects      = '&Effets de remplissage...';
  FsdxBtnNoFill           = '&Aucun remplissage';
  FsdxBtnAutomatic        = '&Automatique';
  FsdxBtnNone             = '&Aucun';
  
  FsdxBtnOtherTexture   = 'Autre Te&xture...';
  FsdxBtnInvertColors   = 'I&nverser les Couleurs';
  FsdxBtnSelectPicture  = 'Selectionner une Image...';
  
  FsdxEditReports             = 'Modifier l''Edition';
  FsdxComposition             = 'Composition';
  FsdxReportTitleDlgCaption   = 'Report Title';
  FsdxMode                    = '&Mode:';
  FsdxText                    = '&Texte';
  FsdxProperties              = '&Propriétés';
  FsdxAdjustOnScale           = '&Adjuster à l''échelle';
  FsdxTitleModeNone           = 'Aucun';
  FsdxTitleModeOnEveryTopPage = 'Sur chaque entête';
  FsdxTitleModeOnFirstPage    = 'Sur la première page';
  
  FsdxEditDescription         = 'Modifier la Description';
  FsdxRename                  = 'Renom&mer';
  FsdxSelectAll               = '&Tout Selectionner';
  
  FsdxAddReport               = 'Ajouter une Edition';
  FsdxAddAndDesignReport      = 'Ajouter et Construire une Edition...';
  FsdxNewCompositionCaption   = 'Nouvelle Composition';
  FsdxName                    = '&Nom:';
  FsdxCaption                 = '&Caption:';
  FsdxAvailableSources        = '&Available Source(s)';
  FsdxOnlyComponentsInActiveForm = 'Only Components in Active &Form';
  FsdxOnlyComponentsWithoutLinks = 'Only Components &without Existing ReportLinks';
  FsdxItemName                   = 'Nom';
  FsdxItemDescription = 'Description';

  FsdxConfirmDeleteItem = 'Do you want to delete next items: %s ?';
  FsdxAddItemsToComposition = 'Add Items to Composition';
  FsdxHideAlreadyIncludedItems = 'Hide Already &Included Items';
  FsdxAvailableItems = 'A&vailable Items';
  FsdxItems = '&Items';
  FsdxEnable = '&Enable';
  FsdxOptions = 'Options';
  FsdxShow = 'Show';
  FsdxPaintItemsGraphics = '&Paint Item Graphics';
  FsdxDescription = '&Description:';

  FsdxNewReport = 'Nouvelle Edition';
  
  FsdxOnlySelected = 'Only &Selected';
  FsdxExtendedSelect = '&Extended Select';
  FsdxIncludeFixed = '&Include Fixed';

  FsdxFonts = 'Polices';
  FsdxBtnFont = 'Po&lice...';
  FsdxBtnEvenFont = 'Police ligne &paire...';
  FsdxBtnOddFont = 'Police ligne i&mpaire...';
  FsdxBtnFixedFont = 'F&ixed Font...';
  FsdxBtnGroupFont = 'Police pour le Grou&pe...';
  FsdxBtnChangeFont = 'Modifier la Police...';

  FsdxFont = 'Police';
  FsdxOddFont = 'Odd Font';
  FsdxEvenFont = 'Even Font';
  FsdxPreviewFont = 'Preview Font';
  FsdxCaptionNodeFont = 'Level Caption Font';
  FsdxGroupNodeFont = 'Group Node Font';
  FsdxGroupFooterFont = 'Group Footer Font';
  FsdxHeaderFont = 'Police d''Entête';
  FsdxFooterFont = 'Police de Pied de Page';
  FsdxBandFont = 'Police pour la Bande';

  FsdxTransparent = '&Transparent';
  FsdxFixedTransparent = 'Fi&xed Transparent';
  FsdxCaptionTransparent = 'Caption Transparent';
  FsdxGroupTransparent = 'Groupe Transparent';
  
  FsdxGraphicAsTextValue = '(GRAPHIQUE)';
  FsdxColors = 'Couleurs';
  FsdxColor = 'Cou&leur:';
  FsdxOddColor = 'Cou&leur paire:';
  FsdxEvenColor = 'Couleur impaire:';
  FsdxPreviewColor = '&Voir la couleur:';
  FsdxBandColor = 'Couleur de la &Bande:';
  FsdxLevelCaptionColor = 'Le&vel Caption Color:';
  FsdxHeaderColor = 'Couleur d''Entête:';
  FsdxGroupNodeColor = 'Group &Node Color:';
  FsdxGroupFooterColor = '&Group Footer Color:';
  FsdxFooterColor = 'Couleur du Pied de Page:';
  FsdxFixedColor = 'F&ixed Color:';
  FsdxGroupColor = 'Grou&p Color:';
  FsdxCaptionColor = 'Caption Color:';
  FsdxGridLinesColor = 'Gri&d Line Color:';

  FsdxBands = '&Bandes';
  FsdxLevelCaptions = 'Levels &Caption';
  FsdxHeaders = 'Entêtes';
  FsdxFooters = 'Pied';
  FsdxGroupFooters = 'Pied de &Group';
  FsdxPreview = 'Prévisualiser';
  FsdxPreviewLineCount = 'Preview Line Coun&t:';
  FsdxAutoCalcPreviewLineCount = 'A&uto Calculate Preview Lines';
  
  FsdxGrid = 'Grid Lines';
  FsdxNodesGrid = 'Node Grid Lines';
  FsdxGroupFooterGrid = 'GroupFooter Grid Lines';

  FsdxStateImages = '&State Images';
  FsdxImages = '&Images';

  FsdxTextAlign = 'Alignement';
  FsdxTextAlignHorz = 'Hori&zontal';
  FsdxTextAlignVert = '&Vertical';
  FsdxTextAlignLeft = 'Gauche';
  FsdxTextAlignCenter = 'Centre';
  FsdxTextAlignRight = 'Droite';
  FsdxTextAlignTop = 'Haut';
  FsdxTextAlignVCenter = 'Centre';
  FsdxTextAlignBottom = 'Bas';
  FsdxBorderLines = '&Bordure';
  FsdxHorzLines = 'Lignes Hori&zontales';
  FsdxVertLines = 'Lignes &Verticales';
  FsdxFixedHorzLines = 'Lignes Horizontales Fixes';
  FsdxFixedVertLines = 'Lignes Verticales Fixes';
  FsdxFlatCheckMarks = 'F&lat CheckMarks';
  FsdxCheckMarksAsText = '&Display CheckMarks as Text';
  
  FsdxRowAutoHeight = 'Hauteur Automatique';
  FsdxEndEllipsis = '&EndEllipsis';

  FsdxDrawBorder = '&Dessiner les bordures';
  FsdxFullExpand = 'Tout déployer';
  FsdxBorderColor = 'Couleur de &Bordure:';
  FsdxAutoNodesExpand = 'A&uto Nodes Expand';
  FsdxExpandLevel = 'Développer niveau:';
  FsdxFixedRowOnEveryPage = 'Fixed Rows';

  FsdxDrawMode = '&Mode Dessin:';
  FsdxDrawModeStrict = 'Strict';
  FsdxDrawModeOddEven = 'Odd/Even Rows Mode';
  FsdxDrawModeChess = 'Chess Mode';
  FsdxDrawModeBorrow = 'Borrow From Source';
  
  Fsdx3DEffects = 'Effets 3D';
  FsdxUse3DEffects = 'Utiliser des Effets 3D';
  FsdxSoft3D = 'Sof&t3D';
  
  FsdxBehaviors = 'Comportements';
  FsdxMiscellaneous = 'Divers';
  FsdxOnEveryPage = 'Sur Chaque Page';
  FsdxNodeExpanding = 'Node Expanding';
  FsdxSelection = 'Selection';
  FsdxNodeAutoHeight = '&Node Auto Height';
  FsdxTransparentGraphics = '&Transparent Graphics';
  FsdxAutoWidth = 'Ajustement Automatique de la Largeur';
  
  FsdxDisplayGraphicsAsText = 'Display Graphic As &Text';
  FsdxTransparentColumnGraphics = '&Graphiques Transparents';

  FsdxBandsOnEveryPage = 'Bandes';
  FsdxHeadersOnEveryPage = 'Entêtes';
  FsdxFootersOnEveryPage = 'Pieds';
  FsdxGraphics = '&Graphiques';

  { Common messages }
  FsdxOutOfResources = 'Ressources Insuffisantes';
  FsdxFileAlreadyExists = 'Le fichier "%s" existe déjà.';
  FsdxConfirmOverWrite = 'Le fichier "%s" existe déjà. L''écraser ?';
  FsdxInvalidFileName = 'Nom de fichier invalide "%s"';
  FsdxRequiredFileName = 'Entrer un nom de fichier.';
  FsdxOutsideMarginsMessage =
    'Une ou plusieurs marges sont en dehors de la zone imprimable.' + #13#10 +
    'Voulez-vous continuer ?';
  FsdxOutsideMarginsMessage2 =
    'Une ou plusieurs marges sont en dehors de la zone imprimable.' + #13#10 +
    'Choose the Fix button to increase the appropriate margins.';
  FsdxInvalidMarginsMessage =
    'One or more margins are set to the invalid values.' + #13#10 +
    'Choose the Fix button to correct this problem.' + #13#10 +
    'Choose the Restore button to restore original values.';
  FsdxInvalidMargins = 'One or more margins has invalid values';
  FsdxOutsideMargins = 'One or more margins are set outside the printable area of the page';
  FsdxThereAreNowItemsForShow = 'There are no items in this view';

  { Color palette }

  { Color names }
  { FEF Dialog }
  { Pattern names }
  { Texture names }
  {...}
  FsdxWidth        = 'Largeur';
  FsdxHeight       = 'Hauteur';

  { Brush Dialog }
  FsdxBrushDlgCaption = 'Propriétés du pinceau';
  FsdxStyle           = '&Style:';

  { Enter New File Name dialog }
  { Define styles dialog }
  { Print device }
  { Edit AutoText Entries Dialog }
  { Print dialog }
  { PrintToFile Dialog }
  { Printer State }
  {...}
  FsdxMenuFileRebuild   = 'Reconstruire';
  FsdxMenuFileSave      = 'Enregi&strer';
  FsdxMenuFileSaveAs    = 'Enregi&strer sous...';
  FsdxMenuFileLoad      = 'Ouvrir';
  FsdxMenuFileExit      = 'Quitter';
  {...}

  FsdxMenuFile          = '&Fichier';
  FsdxMenuFileDesign    = '&Design...';
  FsdxMenuFilePrint     = 'Im&primer...';
  FsdxMenuFilePageSetup = 'Mise en page...';
  FsdxMenuPrintStyles   = 'Print Styles';
  FsdxMenuFileClose     = 'Fermer';
  FsdxMenuEdit          = '&Edition';
  FsdxMenuEditCut       = 'Couper';
  FsdxMenuEditCopy      = '&Copier';
  FsdxMenuEditPaste     = 'Coller';
  FsdxMenuEditDelete    = '&Effacer';
  FsdxMenuEditFind      = '&Rechercher...';
  FsdxMenuEditFindNext  = 'Suivant';
  FsdxMenuEditReplace   = '&Remplacer...';
  FsdxMenuLoad          = '&Ouvrir...';
  FsdxMenuPreview       = 'Pre&visualiser...';

  {...}
  
  FsdxMenuZoom              = '&Zoom';
  FsdxMenuZoomPercent100    = '100 %';
  FsdxMenuZoomPageWidth     = 'Largeur de Page';
  FsdxMenuZoomWholePage     = 'Toute la Page';
  FsdxMenuZoomTwoPages      = '&Deux Pages';
  FsdxMenuZoomFourPages     = '&Quatre Pages';
  FsdxMenuZoomMultiplyPages = '&Pages Multiples';
  FsdxMenuZoomWidenToSourceWidth  = 'Adapter à la largeur de la Source';
  FsdxMenuZoomSetup               = '&Paramètres...';

  FsdxMenuGotoPage = '&Aller';
  FsdxMenuGotoPageFirst = 'Pre&mière Page';
  FsdxMenuGotoPagePrev = 'Page &Précédente';
  FsdxMenuGotoPageNext = 'Page &Suivante';
  FsdxMenuGotoPageLast = '&Dernière Page';
  FsdxMenuActivePage = '&Page en cours:';

  FsdxMenuFormat = 'F&ormat';
  FsdxMenuFormatHeaderAndFooter = '&Entête and Pied';
  FsdxMenuFormatAutoTextEntries = '&Auto Text Entries...';
  FsdxMenuFormatDateTime = 'Date Et &Heure...';
  FsdxMenuFormatPageNumbering = 'Numérotation de Page...';
  FsdxMenuFormatPageBackground = 'Fon&d...';
  FsdxMenuFormatShrinkToPage = '&Ajuster à la Page';
  FsdxMenuShowEmptyPages = 'Voir les Pages Vides';
  FsdxMenuFormatHFBackground = 'Fond Entête/Pieds...';
  FsdxMenuFormatHFClear = 'Clear Text';
  FsdxMenuTools = '&Outils';
  FsdxMenuToolsCustomize = '&Personnalisation...';
  FsdxMenuToolsOptions = '&Options...';
  FsdxMenuHelp = '&Aide';
  FsdxMenuHelpTopics = 'Help &Topics...';
  FsdxMenuHelpAbout = '&A Propos...';
  FsdxMenuShortcutPreview = 'Prévisualisation';
  FsdxMenuShortcutAutoText = 'AutoText';
  FsdxMenuBuiltInMenus = 'Built-in Menus';
  FsdxMenuShortCutMenus = 'Raccourcis des Menus';
  FsdxMenuNewMenu = 'Nouveau Menu';

  { Hints }

  FsdxHintFileDesign = 'Design Report';
  FsdxHintFilePrint = 'Imprimer';
  FsdxHintFilePrintDialog = 'Print Dialog';
  FsdxHintFilePageSetup = 'Page Setup';
  FsdxHintFileExit = 'Fermer la prévisualisation';
  FsdxHintEditFind = 'Rechercher';
  FsdxHintEditFindNext = 'Suivant';
  FsdxHintEditReplace = 'Remplacer';
  FsdxHintInsertEditAutoTextEntries = 'Edit AutoText Entries';
  FsdxHintInsertPageNumber = 'Insérer le Numero de Page';
  FsdxHintInsertTotalPages = 'Insérer le Pombre de Pages';
  FsdxHintInsertPageOfPages = 'Insert Page Number of Pages';
  FsdxHintInsertDateTime = 'Insérer Date et Heure';
  FsdxHintInsertDate = 'Insérer la Date';
  FsdxHintInsertTime = 'Insérer l''Heure';
  FsdxHintInsertUserName = 'Insérer le Nom d''Utilisateur';
  FsdxHintInsertMachineName = 'Insérér le Nom d''Ordinateur';
  FsdxHintViewMargins = 'Voir les Marges';
  FsdxHintViewLargeButtons = 'View Large Buttons';
  FsdxHintViewMarginsStatusBar = 'View Margins Status Bar';
  FsdxHintViewPagesStatusBar = 'View Page Status Bar';
  FsdxHintViewPagesHeaders = 'View Page Header';
  FsdxHintViewPagesFooters = 'View Page Footer';
  FsdxHintViewSwitchToLeftPart = 'Switch to Left Header/Footer Part';
  FsdxHintViewSwitchToRightPart = 'Switch to Right Header/Footer Part';
  FsdxHintViewSwitchToCenterPart = 'Switch to Center Header/Footer Part';
  FsdxHintViewHFSwitchHeaderFooter = 'Basculer entête et pied de page';
  FsdxHintViewHFClose = 'Fermer';
  FsdxHintViewZoom = 'Zoom';
  FsdxHintZoomPercent100 = 'Zoom 100%';
  FsdxHintZoomPageWidth = 'Largeur de Page';
  FsdxHintZoomWholePage = 'Page Entière';
  FsdxHintZoomTwoPages = 'Deux Pages';
  FsdxHintZoomFourPages = 'Quatre Pages';
  FsdxHintZoomMultiplyPages = 'Multiple Pages';
  FsdxHintZoomWidenToSourceWidth = 'Widen To Source Width';
  FsdxHintZoomSetup = 'Parametrage du Facteur de Zoom';
  FsdxHintFormatDateTime = 'Format Date et Heure';
  FsdxHintFormatPageNumbering = 'Format Page Number';
  FsdxHintFormatPageBackground = 'Couleur de Page';
  FsdxHintFormatShrinkToPage = 'Fit To Page';
  FsdxHintFormatHFBackground = 'Header/Footer Background';
  FsdxHintFormatHFClear = 'Clear Header/Footer Text';
  FsdxHintGotoPageFirst = 'Première Page';
  FsdxHintGotoPagePrev = 'Page Précédente';
  FsdxHintGotoPageNext = 'Page Suivante';
  FsdxHintGotoPageLast = 'Dernière Page';
  FsdxHintActivePage = 'Page en cours';
  FsdxHintToolsCustomize = 'Personnaliser les barres d''outils';
  FsdxHintToolsOptions = 'Options';
  FsdxHintHelpTopics = 'Aide';
  FsdxHintHelpAbout = 'A Propos';
  FsdxPopupMenuLargeButtons = '&Large Buttons';
  FsdxPopupMenuFlatButtons = '&Flat Buttons';
  FsdxPaperSize = 'Taille du Papier:';
  FsdxStatus = 'Status:';
  FsdxStatusReady = 'Prêt';
  FsdxStatusPrinting = 'Impression en cours. %d page(s) effectuée(s)';
  FsdxStatusGenerateReport = 'Generating Report. Completed %d%%';
  FsdxHintDoubleClickForChangePaperSize = 'Double-Cliquer pour changer la taille du Papier';
  FsdxHintDoubleClickForChangeMargins = 'Double-Cliquer for changer la taille des Marges';

  { Date&Time Formats Dialog }
  FsdxDTFormatsCaption = 'Date et Heure';
  FsdxDTFormatsAvailableDateFormats = 'Formats Date Disponibles:';
  FsdxDTFormatsAvailableTimeFormats = 'Formats Heure Disponibles:';
  FsdxDTFormatsAutoUpdate = '&Mise à Jour Automatique';
  FsdxDTFormatsChangeDefaultFormat =
    'Voulez-vous changer la date et heure par défaut de "%s"  en "%s" ?';

  { PageNumber Formats Dialog }
  FsdxPNFormatsCaption = 'Format Numéro de Page';
  FsdxPageNumbering = 'Numération de Page';
  FsdxPNFormatsNumberFormat = '&Format Nombre :';
  FsdxPNFormatsContinueFromPrevious = '&Continuer depuis la Section Précédente';
  FsdxPNFormatsStartAt = 'Commencer à:';
  FsdxPNFormatsChangeDefaultFormat =
    'Voulez-vous changer la numérotation des pages pour "%s" ?';

  { Zoom Dialog }
  FsdxZoomDlgCaption = 'Zoom';
  FsdxZoomDlgZoomTo = ' Zoom à ';
  FsdxZoomDlgPageWidth = 'Largeur de Page';
  FsdxZoomDlgWholePage = 'Toutes les Pages';
  FsdxZoomDlgTwoPages = '&Deux Pages';
  FsdxZoomDlgFourPages = '&Quatre Pages';
  FsdxZoomDlgManyPages = '&Plusieurs Pages:';
  FsdxZoomDlgPercent = 'Pourc&entage:';
  FsdxZoomDlgPreview = ' Previsualisation ';
  FsdxZoomDlgFontPreview = ' 12pt Times New Roman ';
  FsdxZoomDlgFontPreviewString = 'AaBbCcDdEeXxYyZz';

  { Select page X x Y }
  FsdxPages = 'Pages';
  FsdxCancel = 'Annuler';

  { Preferences dialog }

  { Page Setup }
  FsdxCloneStyleCaptionPrefix = 'Copie (%d) de ';
  FsdxInvalideStyleCaption = 'The style name "%s" already exists. Please supply another name.';

  FsdxPageSetupCaption = 'Page Setup';
  FsdxStyleName = '&Nom du Style:';

  FsdxPage = '&Page';
  FsdxMargins = '&Marges';
  FsdxHeaderFooter = '&Entête/Pied';
  FsdxScaling = '&Mise à l''echelle';

  FsdxPaper = ' Papier ';
  FsdxPaperType = 'T&ype';
  FsdxPaperDimension = 'Dimension';
  FsdxPaperWidth = '&Largeur:';
  FsdxPaperHeight = 'H&auteur:';
  FsdxPaperSource = 'Paper so&urce';

  FsdxOrientation = ' Orientation ';
  FsdxPortrait = 'P&ortrait';
  FsdxLandscape = '&Paysage';
  FsdxPrintOrder = ' Ordre d''impression ';
  FsdxDownThenOver = '&Down, then over';
  FsdxOverThenDown = 'O&ver, then down';
  FsdxShading = ' Shading ';
  FsdxPrintUsingGrayShading = 'Print using &gray shading';

  FsdxCenterOnPage = 'Centrer sur la page';
  FsdxHorizontally = 'Hori&zontale';
  FsdxVertically = '&Verticale';

  FsdxHeader = 'Entête ';
  FsdxBtnHeaderFont = '&Police...';
  FsdxBtnHeaderBackground = '&Fond';
  FsdxFooter = 'Pied ';
  FsdxBtnFooterFont = 'Po&lice...';
  FsdxBtnFooterBackground = 'Fon&d';

  FsdxTop          = 'Haut:';
  FsdxLeft         = 'Gauche:';
  FsdxRight        = 'Droite:';
  FsdxBottom       = 'Bas:';
  FsdxHeader2      = 'Entête:';
  FsdxFooter2      = 'Pied:';

  FsdxAlignment = 'Alignement';
  FsdxVertAlignment = ' Alignement Vertical ';
  FsdxReverseOnEvenPages = '&Reverse on even pages';

  FsdxAdjustTo = '&Adjusté à:';
  FsdxFitTo = '&Fit To:';
  FsdxPercentOfNormalSize = '% normal size';
  FsdxPagesWideBy = 'page(s) &wide by';
  FsdxTall = '&tall';

  FsdxOf              = 'de';
  FsdxLastPrinted     = 'Dernier Imrpression ';
  FsdxFileName        = 'Nom du fichier ';
  FsdxFileNameAndPath = 'Nom du fichier et chemin ';
  FsdxPrintedBy       = 'Imprimé par';
  FsdxPrintedOn       = 'Imprimé sur ';
  FsdxCreatedBy       = 'Créé par ';
  FsdxCreatedOn       = 'Créé sur ';
  FsdxConfidential    = 'Confidentiel';

  { HF function }
  { Designer strings }

  { Months }

  FsdxJanuary  = 'Janvier';
  FsdxFebruary = 'Fevrier';
  FsdxMarch    = 'Mars';
  FsdxApril    = 'Avril';
  FsdxMay      = 'Mai';
  FsdxJune     = 'Juin';
  FsdxJuly     = 'Juillet';
  FsdxAugust   = 'Août';
  FsdxSeptember = 'Septembre';
  FsdxOctober   = 'Octobre';
  FsdxNovember  = 'Novembre';
  FsdxDecember  = 'Decembre';

  FsdxEast  = 'Est';
  FsdxWest  = 'Ouest';
  FsdxSouth = 'Sud';
  FsdxNorth = 'Nord';

  FsdxTotal = 'Total';

  { dxFlowChart }
  { dxOrgChart }
  { dxMasterView }
  { dxTreeList }
  { PS 2.3 }
  { Patterns common }
  { Excel edge patterns }
  { Excel fill patterns names}
  { cxSpreadSheet }
  { Designer strings }
  { Short names of month }
  { TreeView }
  { misc. }
  { Designer previews }
  { Localize if you want (they are used inside FormatReport dialog -> ReportPreview) }
  { PS 2.4 }
  { dxPrnDev.pas }
  { Grid 4 }
  { PS 3 }
  FsdxCopy = '&Copier';
  FsdxSave = '&Enregistrer...';
  FsdxBaseStyle = 'Style de Base';
  { shapes }
  { standard pattern names}
  { explorer }
   { (....) }
  FsdxMenuViewThumbnails = 'Mini&atures';
  FsdxMenuThumbnailsLarge = '&Grandes Miniatures';
  FsdxMenuThumbnailsSmall = '&Petites Miniatures';

  FsdxHintViewThumbnails = 'Voir Les Miniatures';
  FsdxHintThumbnailsLarge = 'Switch to large thumbnails';
  FsdxHintThumbnailsSmall = 'Switch to small thumbnails';

  FsdxMenuFormatTitle = 'T&itre...';
  FsdxHintFormatTitle = 'Format Report Title';

  FsdxHalf = 'Half';
  FsdxPredefinedFunctions = ' Predefined Functions '; // dxPgsDlg.pas
  FsdxZoomParameters = ' &Paramètres de Zoom';          // dxPSPrvwOpt.pas

  FsdxWrapData = '&Wrap Data';

  FsdxMenuShortcutExplorer = 'Explorer';
  FsdxExplorerToolBar = 'Explorer';

  FsdxMenuShortcutThumbnails = 'Miniatures';
  { TreeView New}
  FsdxButtons                = 'Boutons';
  { ListView }
  {....}

  FsdxMenuView          = '&Affichage';
  FsdxMenuViewMargins   = '&Marges';
  FsdxMenuViewFlatToolBarButtons   = '&Petites Icônes';
  FsdxMenuViewLargeToolBarButtons  = '&Grandes Icônes';
  FsdxMenuViewMarginsStatusBar     = 'Barre des M&arges';
  FsdxMenuViewPagesStatusBar       = 'Barre d''é&tat';
  FsdxMenuViewToolBars             = '&Barre d''outils';
  FsdxMenuViewPagesHeaders         = 'Entête de Page';
  FsdxMenuViewPagesFooters         = 'Pied de Page';
  FsdxMenuViewSwitchToLeftPart     = 'Basculer à Gauche';
  FsdxMenuViewSwitchToRightPart    = 'Basculer à Droite';
  FsdxMenuViewSwitchToCenterPart   = 'Basculer au Centre';
  FsdxMenuViewHFSwitchHeaderFooter = '&Voir Entête/Pied';
  FsdxMenuViewHFClose              = '&Fermer';


  FsdxPrintDialogCaption  = 'Impression';
  FsdxPrintDialogPrinter  = 'Imprimante :';
  FsdxPrintDialogName     = 'Nom :';
  FsdxPrintDialogStatus   = 'Etat :';
  FsdxPrintDialogType     = 'Type :';
  FsdxPrintDialogWhere    = 'Emplacement :';
  FsdxPrintDialogComment  = 'Commentaire :';
  FsdxPrintDialogPages    = '&Pages:';
  FsdxPrintDialogPrintToFile = 'Imprimer dans un fichier';
  FsdxPrintDialogPageRange   = 'Zone d''Impression';
  FsdxPrintDialogAll         = 'Tout';
  FsdxPrintDialogCurrentPage = 'Page courante';
  FsdxPrintDialogSelection   = 'Sélection';
  FsdxPrintDialogCopies      = 'Copies';

  FsdxLeftMargin    = 'Marge gauche';
  FsdxTopMargin     = 'Marge haut';
  FsdxRightMargin   = 'Marge droite';
  FsdxBottomMargin  = 'Marge basse';
  FsdxHeaderMargin  = 'Entête';
  FsdxFooterMargin  = 'Pied de page';

  FsdxUnitsInches      = '"';
  FsdxUnitsCentimeters = 'cm';
  FsdxUnitsMillimeters = 'mm';
  FsdxUnitsPoints      = 'pt';
  FsdxUnitsPicas       = 'pi';

  FsdxUnitsDefaultName = 'Défaut';
  FsdxUnitsInchesName = 'Pouces';
  FsdxUnitsCentimetersName = 'Centimetres';
  FsdxUnitsMillimetersName = 'Millimetres';
  FsdxUnitsPointsName = 'Points';
  FsdxUnitsPicasName = 'Picas';

  FsdxPrintPreview = 'Prévisualisation de l''Impression';
  FsdxReportDesignerCaption = 'Format de l''Edition';
  FsdxCompositionDesignerCaption = 'Constructeur d''Edition';

  FsdxComponentNotSupportedByLink = 'Le composant "%s" n''est pas supporté par TdxComponentPrinter';
  FsdxComponentNotSupported = 'Le composant "%s" n''est pas supporté par TdxComponentPrinter';
  FsdxPrintDeviceNotReady = 'L''imprimante n''est pas installée ou n''est pas prête';
  FsdxUnableToGenerateReport = 'Impossible de générer le rapport';
  FsdxPreviewNotRegistered = 'There is no registered preview form';
  FsdxComponentNotAssigned = '%s' + #13#10 + 'propriété de "composant" non affectée';
  FsdxPrintDeviceIsBusy = 'Imprimante occupée';
  FsdxPrintDeviceError = 'Printer has encountered error !';
  FsdxMissingComponent = 'Missing "Component" property';
  FsdxDataProviderDontPresent = 'There are no Links with Assigned Component in Composition';
  FsdxBuildingReport = 'Building report: Completed %d%%';                            // obsolete
  FsdxPrintingReport = 'Impression en cours: %d page(s). Appuyez sur Echap pour annuler'; // obsolete
  FsdxDefinePrintStylesMenuItem = 'Define Print &Styles...';
  FsdxAbortPrinting = 'Abandonner l''impression ?';
  FsdxStandardStyle = 'Style Standard';

  // --------------------------------------------

  FscxGridFilterRowInfoText = 'Cliquez ici pour ajouter un filtre';

  // Lié au fichier cxFilterConsts.pas (devexpress)

  FcxSFilterBoolOperatorAnd = 'ET';
  FcxSFilterBoolOperatorOr = 'OU';
  FcxSFilterBoolOperatorNotAnd = 'NON ET';
  FcxSFilterBoolOperatorNotOr = 'NON OU';
  FcxSFilterRootButtonCaption = 'Filtre';
  FcxSFilterAddCondition = 'Ajouter &Condition';
  FcxSFilterAddGroup = 'Ajouter un &Groupe';
  FcxSFilterRemoveRow = '&Supprimer la Ligne';
  FcxSFilterClearAll = '&Tout Nettoyer';
  FcxSFilterFooterAddCondition = 'cliquer ici pour ajouter une condition';
  FcxSFilterGroupCaption = 'appliquer les conditions suivantes';
  FcxSFilterRootGroupCaption = '<racine>';
  FcxSFilterControlNullString = '<vide>';
  FcxSFilterErrorBuilding = 'Impossible de construire le filtre';
  FcxSFilterDialogCaption = 'Personnalisation du filtre';
  FcxSFilterDialogInvalidValue = 'valeur interdite';
  FcxSFilterDialogUse = 'Utilisez';
  FcxSFilterDialogSingleCharacter = 'pour représenter chaque unique caractère';
  FcxSFilterDialogCharactersSeries = 'pour représenter chaque séquence de caractères';
  FcxSFilterDialogOperationAnd = 'ET';
  FcxSFilterDialogOperationOr = 'OU';
  FcxSFilterDialogRows = 'Montrer les lignes où:';
  FcxSFilterControlDialogCaption = 'Constructeur de Filtre';
  FcxSFilterControlDialogNewFile = 'sanstitre.flt';
  FcxSFilterControlDialogOpenDialogCaption = 'Ouvrir un filtre existant';
  FcxSFilterControlDialogSaveDialogCaption = 'Enregistrer le filtre actif';
  FcxSFilterControlDialogActionSaveCaption = '&Enregistrer...';
  FcxSFilterControlDialogActionOpenCaption = '&Ouvrir...';
  FcxSFilterControlDialogActionApplyCaption = '&Appliquer';
  FcxSFilterControlDialogActionOkCaption = 'OK';
  FcxSFilterControlDialogActionCancelCaption = 'Annuler';
  FcxSFilterControlDialogFileExt = 'flt';
  FcxSFilterControlDialogFileFilter = 'Filtres (*.flt)|*.flt';

  FcxSFilterOperatorEqual = 'égal à';
  FcxSFilterOperatorNotEqual = 'différent de';
  FcxSFilterOperatorLess = 'inférieur à';
  FcxSFilterOperatorLessEqual = 'inférieur ou égal à';
  FcxSFilterOperatorGreater = 'supérieur à';
  FcxSFilterOperatorGreaterEqual = 'supérieur ou égal à';
  FcxSFilterOperatorLike = 'comme';
  FcxSFilterOperatorNotLike = 'non comme';
  FcxSFilterOperatorBetween = 'entre';
  FcxSFilterOperatorNotBetween = 'non entre';
  FcxSFilterOperatorInList = 'dans';
  FcxSFilterOperatorNotInList = 'not in';

implementation

Procedure Chargement_Langue;
begin
  cxSetResourceString(@cxSEditValueOutOfBounds , FcxSEditValueOutOfBounds);
  cxSetResourceString(@cxSDatePopupToday , FcxSDatePopupToday);
  cxSetResourceString(@cxSDatePopupClear , FcxSDatePopupClear);
  cxSetResourceString(@cxSDateError , FcxSDateError);

  cxSetResourceString(@cxSFilterOperatorContains , FcxSFilterOperatorContains);
  cxSetResourceString(@cxSFilterOperatorDoesNotContain , FcxSFilterOperatorDoesNotContain);
  cxSetResourceString(@cxSFilterBoxAllCaption , FcxSFilterBoxAllCaption);
  cxSetResourceString(@cxSFilterBoxCustomCaption , FcxSFilterBoxCustomCaption);
  cxSetResourceString(@cxSFilterBoxBlanksCaption, FcxSFilterBoxBlanksCaption);
  cxSetResourceString(@cxSFilterBoxNonBlanksCaption, FcxSFilterBoxNonBlanksCaption);

  cxSetResourceString(@scxGridNoDataInfoText, FscxGridNoDataInfoText);

  cxSetResourceString(@cxSGridNone, FcxSGridNone);
  cxSetResourceString(@cxSGridSortColumnAsc, FcxSGridSortColumnAsc);
  cxSetResourceString(@cxSGridSortColumnDesc, FcxSGridSortColumnDesc);
  cxSetResourceString(@cxSGridClearSorting, FcxSGridClearSorting);

  cxSetResourceString(@cxSGridGroupByThisField, FcxSGridGroupByThisField);
  cxSetResourceString(@cxSGridGroupByBox, FcxSGridGroupByBox);
  cxSetResourceString(@cxSGridAlignmentSubMenu, FcxSGridAlignmentSubMenu);
  cxSetResourceString(@cxSGridAlignLeft, FcxSGridAlignLeft);
  cxSetResourceString(@cxSGridAlignRight, FcxSGridAlignRight);
  cxSetResourceString(@cxSGridAlignCenter, FcxSGridAlignCenter);
  cxSetResourceString(@cxSGridRemoveColumn, FcxSGridRemoveColumn);
  cxSetResourceString(@cxSGridFieldChooser, FcxSGridFieldChooser);
  cxSetResourceString(@cxSGridBestFit, FcxSGridBestFit);
  cxSetResourceString(@cxSGridBestFitAllColumns, FcxSGridBestFitAllColumns);
  cxSetResourceString(@cxSGridShowFooter, FcxSGridShowFooter);
  cxSetResourceString(@cxSGridShowGroupFooter, FcxSGridShowGroupFooter);

  cxSetResourceString(@scxGridRecursiveLevels, FscxGridRecursiveLevels);
  cxSetResourceString(@scxGridDeletingConfirmationCaption, FscxGridDeletingConfirmationCaption);
  cxSetResourceString(@scxGridDeletingFocusedConfirmationText, FscxGridDeletingFocusedConfirmationText);
  cxSetResourceString(@scxGridDeletingSelectedConfirmationText, FscxGridDeletingSelectedConfirmationText);
  cxSetResourceString(@scxGridFilterIsEmpty, FscxGridFilterIsEmpty);
  cxSetResourceString(@scxGridCustomizationFormCaption, FscxGridCustomizationFormCaption);
  cxSetResourceString(@scxGridCustomizationFormColumnsPageCaption,FscxGridCustomizationFormColumnsPageCaption);
  cxSetResourceString(@scxGridGroupByBoxCaption,FscxGridGroupByBoxCaption);
  cxSetResourceString(@scxGridFilterCustomizeButtonCaption,FscxGridFilterCustomizeButtonCaption);
  cxSetResourceString(@scxGridCustomizationFormBandsPageCaption,FscxGridCustomizationFormBandsPageCaption);
  cxSetResourceString(@scxGridConverterIntermediaryMissing,FscxGridConverterIntermediaryMissing);
  cxSetResourceString(@scxGridConverterNotExistGrid,FscxGridConverterNotExistGrid);
  cxSetResourceString(@scxGridConverterNotExistComponent,FscxGridConverterNotExistComponent);
  //     cxSetResourceString(@scxGridConverterCantCreateStyleRepository,FscxGridConverterCantCreateStyleRepository);
  cxSetResourceString(@scxImportErrorCaption,FscxImportErrorCaption);
  cxSetResourceString(@scxNotExistGridView,FscxNotExistGridView);
  cxSetResourceString(@scxNotExistGridLevel,FscxNotExistGridLevel);
  cxSetResourceString(@scxCantCreateExportOutputFile,FscxCantCreateExportOutputFile);
  cxSetResourceString(@cxSEditRepositoryExtLookupComboBoxItem,FcxSEditRepositoryExtLookupComboBoxItem);

  cxSetResourceString(@cxNavigator_DeleteRecordQuestion,FcxNavigator_DeleteRecordQuestion);


  // ----------- Composants autour de dxPrinter --------------------------- //
  cxSetResourceString(@sdxBtnOK                                         ,FsdxBtnOK                                );
  cxSetResourceString(@sdxBtnOKAccelerated                              ,FsdxBtnOKAccelerated                     );
  cxSetResourceString(@sdxBtnCancel                                     ,FsdxBtnCancel                            );
  cxSetResourceString(@sdxBtnClose                                      ,FsdxBtnClose                             );
  cxSetResourceString(@sdxBtnApply                                      ,FsdxBtnApply                             );
  cxSetResourceString(@sdxBtnHelp                                       ,FsdxBtnHelp                              );
  cxSetResourceString(@sdxBtnFix                                        ,FsdxBtnFix                               );
  cxSetResourceString(@sdxBtnNew                                        ,FsdxBtnNew                               );
  cxSetResourceString(@sdxBtnIgnore                                     ,FsdxBtnIgnore                            );
  cxSetResourceString(@sdxBtnYes                                        ,FsdxBtnYes                               );
  cxSetResourceString(@sdxBtnNo                                         ,FsdxBtnNo                                );
  cxSetResourceString(@sdxBtnEdit                                       ,FsdxBtnEdit                              );
  cxSetResourceString(@sdxBtnReset                                      ,FsdxBtnReset                             );
  cxSetResourceString(@sdxBtnAdd                                        ,FsdxBtnAdd                               );
  cxSetResourceString(@sdxBtnAddComposition                             ,FsdxBtnAddComposition                    );
  cxSetResourceString(@sdxBtnDefault                                    ,FsdxBtnDefault                           );
  cxSetResourceString(@sdxBtnDelete                                     ,FsdxBtnDelete                            );
  cxSetResourceString(@sdxBtnDescription                                ,FsdxBtnDescription                       );
  cxSetResourceString(@sdxBtnCopy                                       ,FsdxBtnCopy                              );
  cxSetResourceString(@sdxBtnYesToAll                                   ,FsdxBtnYesToAll                          );
  cxSetResourceString(@sdxBtnRestoreDefaults                            ,FsdxBtnRestoreDefaults                   );
  cxSetResourceString(@sdxBtnRestoreOriginal                            ,FsdxBtnRestoreOriginal                   );
  cxSetResourceString(@sdxBtnTitleProperties                            ,FsdxBtnTitleProperties                   );
  cxSetResourceString(@sdxBtnProperties                                 ,FsdxBtnProperties                        );
  cxSetResourceString(@sdxBtnNetwork                                    ,FsdxBtnNetwork                           );
  cxSetResourceString(@sdxBtnBrowse                                     ,FsdxBtnBrowse                            );
  cxSetResourceString(@sdxBtnPageSetup                                  ,FsdxBtnPageSetup                         );
  cxSetResourceString(@sdxBtnPrintPreview                               ,FsdxBtnPrintPreview                      );
  cxSetResourceString(@sdxBtnPreview                                    ,FsdxBtnPreview                           );
  cxSetResourceString(@sdxBtnPrint                                      ,FsdxBtnPrint                             );
  cxSetResourceString(@sdxBtnOptions                                    ,FsdxBtnOptions                           );
  cxSetResourceString(@sdxBtnStyleOptions                               ,FsdxBtnStyleOptions                      );
  cxSetResourceString(@sdxBtnDefinePrintStyles                          ,FsdxBtnDefinePrintStyles                 );
  cxSetResourceString(@sdxBtnPrintStyles                                ,FsdxBtnPrintStyles                       );
  cxSetResourceString(@sdxBtnBackground                                 ,FsdxBtnBackground                        );
  cxSetResourceString(@sdxBtnShowToolBar                                ,FsdxBtnShowToolBar                       );
  cxSetResourceString(@sdxBtnDesign                                     ,FsdxBtnDesign                            );
  cxSetResourceString(@sdxBtnMoveUp                                     ,FsdxBtnMoveUp                            );
  cxSetResourceString(@sdxBtnMoveDown                                   ,FsdxBtnMoveDown                          );
  cxSetResourceString(@sdxBtnMoreColors                                 ,FsdxBtnMoreColors                        );
  cxSetResourceString(@sdxBtnFillEffects                                ,FsdxBtnFillEffects                       );
  cxSetResourceString(@sdxBtnNoFill                                     ,FsdxBtnNoFill                            );
  cxSetResourceString(@sdxBtnAutomatic                                  ,FsdxBtnAutomatic                         );
  cxSetResourceString(@sdxBtnNone                                       ,FsdxBtnNone                              );
  cxSetResourceString(@sdxBtnOtherTexture                               ,FsdxBtnOtherTexture                      );
  cxSetResourceString(@sdxBtnInvertColors                               ,FsdxBtnInvertColors                      );
  cxSetResourceString(@sdxBtnSelectPicture                              ,FsdxBtnSelectPicture                     );
  cxSetResourceString(@sdxEditReports                                   ,FsdxEditReports                          );
  cxSetResourceString(@sdxComposition                                   ,FsdxComposition                          );
  cxSetResourceString(@sdxReportTitleDlgCaption                         ,FsdxReportTitleDlgCaption                );
  cxSetResourceString(@sdxMode                                          ,FsdxMode                                 );
  cxSetResourceString(@sdxText                                          ,FsdxText                                 );
  cxSetResourceString(@sdxProperties                                    ,FsdxProperties                           );
  cxSetResourceString(@sdxAdjustOnScale                                 ,FsdxAdjustOnScale                        );
  cxSetResourceString(@sdxTitleModeNone                                 ,FsdxTitleModeNone                        );
  cxSetResourceString(@sdxTitleModeOnEveryTopPage                       ,FsdxTitleModeOnEveryTopPage              );
  cxSetResourceString(@sdxTitleModeOnFirstPage                          ,FsdxTitleModeOnFirstPage                 );
  cxSetResourceString(@sdxEditDescription                               ,FsdxEditDescription                      );
  cxSetResourceString(@sdxRename                                        ,FsdxRename                               );
  cxSetResourceString(@sdxSelectAll                                     ,FsdxSelectAll                            );
  cxSetResourceString(@sdxAddReport                                     ,FsdxAddReport                            );
  cxSetResourceString(@sdxAddAndDesignReport                            ,FsdxAddAndDesignReport                   );
  cxSetResourceString(@sdxNewCompositionCaption                         ,FsdxNewCompositionCaption                );
  cxSetResourceString(@sdxName                                          ,FsdxName                                 );
  cxSetResourceString(@sdxCaption                                       ,FsdxCaption                              );
  cxSetResourceString(@sdxAvailableSources                              ,FsdxAvailableSources                     );
  cxSetResourceString(@sdxOnlyComponentsInActiveForm                    ,FsdxOnlyComponentsInActiveForm           );
  cxSetResourceString(@sdxOnlyComponentsWithoutLinks                    ,FsdxOnlyComponentsWithoutLinks           );
  cxSetResourceString(@sdxItemName                                      ,FsdxItemName                             );
  cxSetResourceString(@sdxItemDescription                               ,FsdxItemDescription                      );
  cxSetResourceString(@sdxConfirmDeleteItem                             ,FsdxConfirmDeleteItem                    );
  cxSetResourceString(@sdxAddItemsToComposition                         ,FsdxAddItemsToComposition                );
  cxSetResourceString(@sdxHideAlreadyIncludedItems                      ,FsdxHideAlreadyIncludedItems             );
  cxSetResourceString(@sdxAvailableItems                                ,FsdxAvailableItems                       );
  cxSetResourceString(@sdxItems                                         ,FsdxItems                                );
  cxSetResourceString(@sdxEnable                                        ,FsdxEnable                               );
  cxSetResourceString(@sdxOptions                                       ,FsdxOptions                              );
  cxSetResourceString(@sdxShow                                          ,FsdxShow                                 );
  cxSetResourceString(@sdxPaintItemsGraphics                            ,FsdxPaintItemsGraphics                   );
  cxSetResourceString(@sdxDescription                                   ,FsdxDescription                          );
  cxSetResourceString(@sdxNewReport                                     ,FsdxNewReport                            );
  cxSetResourceString(@sdxOnlySelected                                  ,FsdxOnlySelected                         );
  cxSetResourceString(@sdxExtendedSelect                                ,FsdxExtendedSelect                       );
  cxSetResourceString(@sdxIncludeFixed                                  ,FsdxIncludeFixed                         );
  cxSetResourceString(@sdxFonts                                         ,FsdxFonts                                );
  cxSetResourceString(@sdxBtnFont                                       ,FsdxBtnFont                              );
  cxSetResourceString(@sdxBtnEvenFont                                   ,FsdxBtnEvenFont                          );
  cxSetResourceString(@sdxBtnOddFont                                    ,FsdxBtnOddFont                           );
  cxSetResourceString(@sdxBtnFixedFont                                  ,FsdxBtnFixedFont                         );
  cxSetResourceString(@sdxBtnGroupFont                                  ,FsdxBtnGroupFont                         );
  cxSetResourceString(@sdxBtnChangeFont                                 ,FsdxBtnChangeFont                        );
  cxSetResourceString(@sdxFont                                          ,FsdxFont                                 );
  cxSetResourceString(@sdxOddFont                                       ,FsdxOddFont                              );
  cxSetResourceString(@sdxEvenFont                                      ,FsdxEvenFont                             );
  cxSetResourceString(@sdxPreviewFont                                   ,FsdxPreviewFont                          );
  cxSetResourceString(@sdxCaptionNodeFont                               ,FsdxCaptionNodeFont                      );
  cxSetResourceString(@sdxGroupNodeFont                                 ,FsdxGroupNodeFont                        );
  cxSetResourceString(@sdxGroupFooterFont                               ,FsdxGroupFooterFont                      );
  cxSetResourceString(@sdxHeaderFont                                    ,FsdxHeaderFont                           );
  cxSetResourceString(@sdxFooterFont                                    ,FsdxFooterFont                           );
  cxSetResourceString(@sdxBandFont                                      ,FsdxBandFont                             );
  cxSetResourceString(@sdxTransparent                                   ,FsdxTransparent                          );
  cxSetResourceString(@sdxFixedTransparent                              ,FsdxFixedTransparent                     );
  cxSetResourceString(@sdxCaptionTransparent                            ,FsdxCaptionTransparent                   );
  cxSetResourceString(@sdxGroupTransparent                              ,FsdxGroupTransparent                     );
  cxSetResourceString(@sdxGraphicAsTextValue                            ,FsdxGraphicAsTextValue                   );
  cxSetResourceString(@sdxColors                                        ,FsdxColors                               );
  cxSetResourceString(@sdxColor                                         ,FsdxColor                                );
  cxSetResourceString(@sdxOddColor                                      ,FsdxOddColor                             );
  cxSetResourceString(@sdxEvenColor                                     ,FsdxEvenColor                            );
  cxSetResourceString(@sdxPreviewColor                                  ,FsdxPreviewColor                         );
  cxSetResourceString(@sdxBandColor                                     ,FsdxBandColor                            );
  cxSetResourceString(@sdxLevelCaptionColor                             ,FsdxLevelCaptionColor                    );
  cxSetResourceString(@sdxHeaderColor                                   ,FsdxHeaderColor                          );
  cxSetResourceString(@sdxGroupNodeColor                                ,FsdxGroupNodeColor                       );
  cxSetResourceString(@sdxGroupFooterColor                              ,FsdxGroupFooterColor                     );
  cxSetResourceString(@sdxFooterColor                                   ,FsdxFooterColor                          );
  cxSetResourceString(@sdxFixedColor                                    ,FsdxFixedColor                           );
  cxSetResourceString(@sdxGroupColor                                    ,FsdxGroupColor                           );
  cxSetResourceString(@sdxCaptionColor                                  ,FsdxCaptionColor                         );
  cxSetResourceString(@sdxGridLinesColor                                ,FsdxGridLinesColor                       );
  cxSetResourceString(@sdxBands                                         ,FsdxBands                                );
  cxSetResourceString(@sdxLevelCaptions                                 ,FsdxLevelCaptions                        );
  cxSetResourceString(@sdxHeaders                                       ,FsdxHeaders                              );
  cxSetResourceString(@sdxFooters                                       ,FsdxFooters                              );
  cxSetResourceString(@sdxGroupFooters                                  ,FsdxGroupFooters                         );
  cxSetResourceString(@sdxPreview                                       ,FsdxPreview                              );
  cxSetResourceString(@sdxPreviewLineCount                              ,FsdxPreviewLineCount                     );
  cxSetResourceString(@sdxAutoCalcPreviewLineCount                      ,FsdxAutoCalcPreviewLineCount             );
  cxSetResourceString(@sdxGrid                                          ,FsdxGrid                                 );
  cxSetResourceString(@sdxNodesGrid                                     ,FsdxNodesGrid                            );
  cxSetResourceString(@sdxGroupFooterGrid                               ,FsdxGroupFooterGrid                      );
  cxSetResourceString(@sdxStateImages                                   ,FsdxStateImages                          );
  cxSetResourceString(@sdxImages                                        ,FsdxImages                               );
  cxSetResourceString(@sdxTextAlign                                     ,FsdxTextAlign                            );
  cxSetResourceString(@sdxTextAlignHorz                                 ,FsdxTextAlignHorz                        );
  cxSetResourceString(@sdxTextAlignVert                                 ,FsdxTextAlignVert                        );
  cxSetResourceString(@sdxTextAlignLeft                                 ,FsdxTextAlignLeft                        );
  cxSetResourceString(@sdxTextAlignCenter                               ,FsdxTextAlignCenter                      );
  cxSetResourceString(@sdxTextAlignRight                                ,FsdxTextAlignRight                       );
  cxSetResourceString(@sdxTextAlignTop                                  ,FsdxTextAlignTop                         );
  cxSetResourceString(@sdxTextAlignVCenter                              ,FsdxTextAlignVCenter                     );
  cxSetResourceString(@sdxTextAlignBottom                               ,FsdxTextAlignBottom                      );
  cxSetResourceString(@sdxBorderLines                                   ,FsdxBorderLines                          );
  cxSetResourceString(@sdxHorzLines                                     ,FsdxHorzLines                            );
  cxSetResourceString(@sdxVertLines                                     ,FsdxVertLines                            );
  cxSetResourceString(@sdxFixedHorzLines                                ,FsdxFixedHorzLines                       );
  cxSetResourceString(@sdxFixedVertLines                                ,FsdxFixedVertLines                       );
  cxSetResourceString(@sdxFlatCheckMarks                                ,FsdxFlatCheckMarks                       );
  cxSetResourceString(@sdxCheckMarksAsText                              ,FsdxCheckMarksAsText                     );
  cxSetResourceString(@sdxRowAutoHeight                                 ,FsdxRowAutoHeight                        );
  cxSetResourceString(@sdxEndEllipsis                                   ,FsdxEndEllipsis                          );
  cxSetResourceString(@sdxDrawBorder                                    ,FsdxDrawBorder                           );
  cxSetResourceString(@sdxFullExpand                                    ,FsdxFullExpand                           );
  cxSetResourceString(@sdxBorderColor                                   ,FsdxBorderColor                          );
  cxSetResourceString(@sdxAutoNodesExpand                               ,FsdxAutoNodesExpand                      );
  cxSetResourceString(@sdxExpandLevel                                   ,FsdxExpandLevel                          );
  cxSetResourceString(@sdxFixedRowOnEveryPage                           ,FsdxFixedRowOnEveryPage                  );
  cxSetResourceString(@sdxDrawMode                                      ,FsdxDrawMode                             );
  cxSetResourceString(@sdxDrawModeStrict                                ,FsdxDrawModeStrict                       );
  cxSetResourceString(@sdxDrawModeOddEven                               ,FsdxDrawModeOddEven                      );
  cxSetResourceString(@sdxDrawModeChess                                 ,FsdxDrawModeChess                        );
  cxSetResourceString(@sdxDrawModeBorrow                                ,FsdxDrawModeBorrow                       );
  cxSetResourceString(@sdx3DEffects                                     ,Fsdx3DEffects                            );
  cxSetResourceString(@sdxUse3DEffects                                  ,FsdxUse3DEffects                         );
  cxSetResourceString(@sdxSoft3D                                        ,FsdxSoft3D                               );
  cxSetResourceString(@sdxBehaviors                                     ,FsdxBehaviors                            );
  cxSetResourceString(@sdxMiscellaneous                                 ,FsdxMiscellaneous                        );
  cxSetResourceString(@sdxOnEveryPage                                   ,FsdxOnEveryPage                          );
  cxSetResourceString(@sdxNodeExpanding                                 ,FsdxNodeExpanding                        );
  cxSetResourceString(@sdxSelection                                     ,FsdxSelection                            );
  cxSetResourceString(@sdxNodeAutoHeight                                ,FsdxNodeAutoHeight                       );
  cxSetResourceString(@sdxTransparentGraphics                           ,FsdxTransparentGraphics                  );
  cxSetResourceString(@sdxAutoWidth                                     ,FsdxAutoWidth                            );
  cxSetResourceString(@sdxDisplayGraphicsAsText                         ,FsdxDisplayGraphicsAsText                );
  cxSetResourceString(@sdxTransparentColumnGraphics                     ,FsdxTransparentColumnGraphics            );
  cxSetResourceString(@sdxBandsOnEveryPage                              ,FsdxBandsOnEveryPage                     );
  cxSetResourceString(@sdxHeadersOnEveryPage                            ,FsdxHeadersOnEveryPage                   );
  cxSetResourceString(@sdxFootersOnEveryPage                            ,FsdxFootersOnEveryPage                   );
  cxSetResourceString(@sdxGraphics                                      ,FsdxGraphics                             );

  cxSetResourceString(@sdxOutOfResources                                ,FsdxOutOfResources                       );
  cxSetResourceString(@sdxFileAlreadyExists                             ,FsdxFileAlreadyExists                    );
  cxSetResourceString(@sdxConfirmOverWrite                              ,FsdxConfirmOverWrite                     );
  cxSetResourceString(@sdxInvalidFileName                               ,FsdxInvalidFileName                      );
  cxSetResourceString(@sdxRequiredFileName                              ,FsdxRequiredFileName                     );
  cxSetResourceString(@sdxOutsideMarginsMessage                         ,FsdxOutsideMarginsMessage                );
  cxSetResourceString(@sdxOutsideMarginsMessage2                        ,FsdxOutsideMarginsMessage2               );
  cxSetResourceString(@sdxInvalidMarginsMessage                         ,FsdxInvalidMarginsMessage                );
  cxSetResourceString(@sdxInvalidMargins                                ,FsdxInvalidMargins                       );
  cxSetResourceString(@sdxOutsideMargins                                ,FsdxOutsideMargins                       );
  cxSetResourceString(@sdxThereAreNowItemsForShow                       ,FsdxThereAreNowItemsForShow              );

  cxSetResourceString(@sdxWidth                                         ,FsdxWidth                                );
  cxSetResourceString(@sdxHeight                                        ,FsdxHeight                               );
  cxSetResourceString(@sdxBrushDlgCaption                               ,FsdxBrushDlgCaption                      );
  cxSetResourceString(@sdxStyle                                         ,FsdxStyle                                );
  cxSetResourceString(@sdxMenuFileRebuild                               ,FsdxMenuFileRebuild                      );
  cxSetResourceString(@sdxMenuFileSave                                  ,FsdxMenuFileSave                         );
  cxSetResourceString(@sdxMenuFileSaveAs                                ,FsdxMenuFileSaveAs                       );
  cxSetResourceString(@sdxMenuFileLoad                                  ,FsdxMenuFileLoad                         );
  cxSetResourceString(@sdxMenuFileExit                                  ,FsdxMenuFileExit                         );
  cxSetResourceString(@sdxMenuFile                                      ,FsdxMenuFile                             );
  cxSetResourceString(@sdxMenuFileDesign                                ,FsdxMenuFileDesign                       );
  cxSetResourceString(@sdxMenuFilePrint                                 ,FsdxMenuFilePrint                        );
  cxSetResourceString(@sdxMenuFilePageSetup                             ,FsdxMenuFilePageSetup                    );
  cxSetResourceString(@sdxMenuPrintStyles                               ,FsdxMenuPrintStyles                      );
  cxSetResourceString(@sdxMenuFileClose                                 ,FsdxMenuFileClose                        );
  cxSetResourceString(@sdxMenuEdit                                      ,FsdxMenuEdit                             );
  cxSetResourceString(@sdxMenuEditCut                                   ,FsdxMenuEditCut                          );
  cxSetResourceString(@sdxMenuEditCopy                                  ,FsdxMenuEditCopy                         );
  cxSetResourceString(@sdxMenuEditPaste                                 ,FsdxMenuEditPaste                        );
  cxSetResourceString(@sdxMenuEditDelete                                ,FsdxMenuEditDelete                       );
  cxSetResourceString(@sdxMenuEditFind                                  ,FsdxMenuEditFind                         );
  cxSetResourceString(@sdxMenuEditFindNext                              ,FsdxMenuEditFindNext                     );
  cxSetResourceString(@sdxMenuEditReplace                               ,FsdxMenuEditReplace                      );
  cxSetResourceString(@sdxMenuLoad                                      ,FsdxMenuLoad                             );
  cxSetResourceString(@sdxMenuPreview                                   ,FsdxMenuPreview                          );
  cxSetResourceString(@sdxMenuZoom                                      ,FsdxMenuZoom                             );
  cxSetResourceString(@sdxMenuZoomPercent100                            ,FsdxMenuZoomPercent100                   );
  cxSetResourceString(@sdxMenuZoomPageWidth                             ,FsdxMenuZoomPageWidth                    );
  cxSetResourceString(@sdxMenuZoomWholePage                             ,FsdxMenuZoomWholePage                    );
  cxSetResourceString(@sdxMenuZoomTwoPages                              ,FsdxMenuZoomTwoPages                     );
  cxSetResourceString(@sdxMenuZoomFourPages                             ,FsdxMenuZoomFourPages                    );
  cxSetResourceString(@sdxMenuZoomMultiplyPages                         ,FsdxMenuZoomMultiplyPages                );
  cxSetResourceString(@sdxMenuZoomWidenToSourceWidth                    ,FsdxMenuZoomWidenToSourceWidth           );
  cxSetResourceString(@sdxMenuZoomSetup                                 ,FsdxMenuZoomSetup                        );

  cxSetResourceString(@sdxMenuGotoPage                                 ,FsdxMenuGotoPage                         );
  cxSetResourceString(@sdxMenuGotoPageFirst                            ,FsdxMenuGotoPageFirst                    );
  cxSetResourceString(@sdxMenuGotoPagePrev                             ,FsdxMenuGotoPagePrev                     );
  cxSetResourceString(@sdxMenuGotoPageNext                             ,FsdxMenuGotoPageNext                     );
  cxSetResourceString(@sdxMenuGotoPageLast                             ,FsdxMenuGotoPageLast                     );
  cxSetResourceString(@sdxMenuActivePage                               ,FsdxMenuActivePage                       );
  cxSetResourceString(@sdxMenuFormat                                   ,FsdxMenuFormat                           );
  cxSetResourceString(@sdxMenuFormatHeaderAndFooter                    ,FsdxMenuFormatHeaderAndFooter            );
  cxSetResourceString(@sdxMenuFormatAutoTextEntries                    ,FsdxMenuFormatAutoTextEntries            );
  cxSetResourceString(@sdxMenuFormatDateTime                           ,FsdxMenuFormatDateTime                   );
  cxSetResourceString(@sdxMenuFormatPageNumbering                      ,FsdxMenuFormatPageNumbering              );
  cxSetResourceString(@sdxMenuFormatPageBackground                     ,FsdxMenuFormatPageBackground             );
  cxSetResourceString(@sdxMenuFormatShrinkToPage                       ,FsdxMenuFormatShrinkToPage               );
  cxSetResourceString(@sdxMenuShowEmptyPages                           ,FsdxMenuShowEmptyPages                   );
  cxSetResourceString(@sdxMenuFormatHFBackground                       ,FsdxMenuFormatHFBackground               );
  cxSetResourceString(@sdxMenuFormatHFClear                            ,FsdxMenuFormatHFClear                    );
  cxSetResourceString(@sdxMenuTools                                    ,FsdxMenuTools                            );
  cxSetResourceString(@sdxMenuToolsCustomize                           ,FsdxMenuToolsCustomize                   );
  cxSetResourceString(@sdxMenuToolsOptions                             ,FsdxMenuToolsOptions                     );
  cxSetResourceString(@sdxMenuHelp                                     ,FsdxMenuHelp                             );
  cxSetResourceString(@sdxMenuHelpTopics                               ,FsdxMenuHelpTopics                       );
  cxSetResourceString(@sdxMenuHelpAbout                                ,FsdxMenuHelpAbout                        );
  cxSetResourceString(@sdxMenuShortcutPreview                          ,FsdxMenuShortcutPreview                  );
  cxSetResourceString(@sdxMenuShortcutAutoText                         ,FsdxMenuShortcutAutoText                 );
  cxSetResourceString(@sdxMenuBuiltInMenus                             ,FsdxMenuBuiltInMenus                     );
  cxSetResourceString(@sdxMenuShortCutMenus                            ,FsdxMenuShortCutMenus                    );
  cxSetResourceString(@sdxMenuNewMenu                                  ,FsdxMenuNewMenu                          );

  cxSetResourceString(@sdxHintFileDesign                                ,FsdxHintFileDesign                       );
  cxSetResourceString(@sdxHintFilePrint                                 ,FsdxHintFilePrint                        );
  cxSetResourceString(@sdxHintFilePrintDialog                           ,FsdxHintFilePrintDialog                  );
  cxSetResourceString(@sdxHintFilePageSetup                             ,FsdxHintFilePageSetup                    );
  cxSetResourceString(@sdxHintFileExit                                  ,FsdxHintFileExit                         );
  cxSetResourceString(@sdxHintEditFind                                  ,FsdxHintEditFind                         );
  cxSetResourceString(@sdxHintEditFindNext                              ,FsdxHintEditFindNext                     );
  cxSetResourceString(@sdxHintEditReplace                               ,FsdxHintEditReplace                      );
  cxSetResourceString(@sdxHintInsertEditAutoTextEntries                 ,FsdxHintInsertEditAutoTextEntries        );
  cxSetResourceString(@sdxHintInsertPageNumber                          ,FsdxHintInsertPageNumber                 );
  cxSetResourceString(@sdxHintInsertTotalPages                          ,FsdxHintInsertTotalPages                 );
  cxSetResourceString(@sdxHintInsertPageOfPages                         ,FsdxHintInsertPageOfPages                );
  cxSetResourceString(@sdxHintInsertDateTime                            ,FsdxHintInsertDateTime                   );
  cxSetResourceString(@sdxHintInsertDate                                ,FsdxHintInsertDate                       );
  cxSetResourceString(@sdxHintInsertTime                                ,FsdxHintInsertTime                       );
  cxSetResourceString(@sdxHintInsertUserName                            ,FsdxHintInsertUserName                   );
  cxSetResourceString(@sdxHintInsertMachineName                         ,FsdxHintInsertMachineName                );
  cxSetResourceString(@sdxHintViewMargins                               ,FsdxHintViewMargins                      );
  cxSetResourceString(@sdxHintViewLargeButtons                          ,FsdxHintViewLargeButtons                 );
  cxSetResourceString(@sdxHintViewMarginsStatusBar                      ,FsdxHintViewMarginsStatusBar             );
  cxSetResourceString(@sdxHintViewPagesStatusBar                        ,FsdxHintViewPagesStatusBar               );
  cxSetResourceString(@sdxHintViewPagesHeaders                          ,FsdxHintViewPagesHeaders                 );
  cxSetResourceString(@sdxHintViewPagesFooters                          ,FsdxHintViewPagesFooters                 );
  cxSetResourceString(@sdxHintViewSwitchToLeftPart                      ,FsdxHintViewSwitchToLeftPart             );
  cxSetResourceString(@sdxHintViewSwitchToRightPart                     ,FsdxHintViewSwitchToRightPart            );
  cxSetResourceString(@sdxHintViewSwitchToCenterPart                    ,FsdxHintViewSwitchToCenterPart           );
  cxSetResourceString(@sdxHintViewHFSwitchHeaderFooter                  ,FsdxHintViewHFSwitchHeaderFooter         );
  cxSetResourceString(@sdxHintViewHFClose                               ,FsdxHintViewHFClose                      );
  cxSetResourceString(@sdxHintViewZoom                                  ,FsdxHintViewZoom                         );
  cxSetResourceString(@sdxHintZoomPercent100                            ,FsdxHintZoomPercent100                   );
  cxSetResourceString(@sdxHintZoomPageWidth                             ,FsdxHintZoomPageWidth                    );
  cxSetResourceString(@sdxHintZoomWholePage                             ,FsdxHintZoomWholePage                    );
  cxSetResourceString(@sdxHintZoomTwoPages                              ,FsdxHintZoomTwoPages                     );
  cxSetResourceString(@sdxHintZoomFourPages                             ,FsdxHintZoomFourPages                    );
  cxSetResourceString(@sdxHintZoomMultiplyPages                         ,FsdxHintZoomMultiplyPages                );
  cxSetResourceString(@sdxHintZoomWidenToSourceWidth                    ,FsdxHintZoomWidenToSourceWidth           );
  cxSetResourceString(@sdxHintZoomSetup                                 ,FsdxHintZoomSetup                        );
  cxSetResourceString(@sdxHintFormatDateTime                            ,FsdxHintFormatDateTime                   );
  cxSetResourceString(@sdxHintFormatPageNumbering                       ,FsdxHintFormatPageNumbering              );
  cxSetResourceString(@sdxHintFormatPageBackground                      ,FsdxHintFormatPageBackground             );
  cxSetResourceString(@sdxHintFormatShrinkToPage                        ,FsdxHintFormatShrinkToPage               );
  cxSetResourceString(@sdxHintFormatHFBackground                        ,FsdxHintFormatHFBackground               );
  cxSetResourceString(@sdxHintFormatHFClear                             ,FsdxHintFormatHFClear                    );
  cxSetResourceString(@sdxHintGotoPageFirst                             ,FsdxHintGotoPageFirst                    );
  cxSetResourceString(@sdxHintGotoPagePrev                              ,FsdxHintGotoPagePrev                     );
  cxSetResourceString(@sdxHintGotoPageNext                              ,FsdxHintGotoPageNext                     );
  cxSetResourceString(@sdxHintGotoPageLast                              ,FsdxHintGotoPageLast                     );
  cxSetResourceString(@sdxHintActivePage                                ,FsdxHintActivePage                       );
  cxSetResourceString(@sdxHintToolsCustomize                            ,FsdxHintToolsCustomize                   );
  cxSetResourceString(@sdxHintToolsOptions                              ,FsdxHintToolsOptions                     );
  cxSetResourceString(@sdxHintHelpTopics                                ,FsdxHintHelpTopics                       );
  cxSetResourceString(@sdxHintHelpAbout                                 ,FsdxHintHelpAbout                        );
  cxSetResourceString(@sdxPopupMenuLargeButtons                         ,FsdxPopupMenuLargeButtons                );
  cxSetResourceString(@sdxPopupMenuFlatButtons                          ,FsdxPopupMenuFlatButtons                 );
  cxSetResourceString(@sdxPaperSize                                     ,FsdxPaperSize                            );
  cxSetResourceString(@sdxStatus                                        ,FsdxStatus                               );
  cxSetResourceString(@sdxStatusReady                                   ,FsdxStatusReady                          );
  cxSetResourceString(@sdxStatusPrinting                                ,FsdxStatusPrinting                       );
  cxSetResourceString(@sdxStatusGenerateReport                          ,FsdxStatusGenerateReport                 );
  cxSetResourceString(@sdxHintDoubleClickForChangePaperSize             ,FsdxHintDoubleClickForChangePaperSize    );
  cxSetResourceString(@sdxHintDoubleClickForChangeMargins               ,FsdxHintDoubleClickForChangeMargins      );

  cxSetResourceString(@sdxDTFormatsCaption                              ,FsdxDTFormatsCaption                     );
  cxSetResourceString(@sdxDTFormatsAvailableDateFormats                 ,FsdxDTFormatsAvailableDateFormats        );
  cxSetResourceString(@sdxDTFormatsAvailableTimeFormats                 ,FsdxDTFormatsAvailableTimeFormats        );
  cxSetResourceString(@sdxDTFormatsAutoUpdate                           ,FsdxDTFormatsAutoUpdate                  );
  cxSetResourceString(@sdxDTFormatsChangeDefaultFormat                  ,FsdxDTFormatsChangeDefaultFormat         );
  cxSetResourceString(@sdxPNFormatsCaption                              ,FsdxPNFormatsCaption                     );
  cxSetResourceString(@sdxPageNumbering                                 ,FsdxPageNumbering                        );
  cxSetResourceString(@sdxPNFormatsNumberFormat                         ,FsdxPNFormatsNumberFormat                );
  cxSetResourceString(@sdxPNFormatsContinueFromPrevious                 ,FsdxPNFormatsContinueFromPrevious        );
  cxSetResourceString(@sdxPNFormatsStartAt                              ,FsdxPNFormatsStartAt                     );
  cxSetResourceString(@sdxPNFormatsChangeDefaultFormat                  ,FsdxPNFormatsChangeDefaultFormat         );

  cxSetResourceString(@sdxZoomDlgCaption                                ,FsdxZoomDlgCaption                       );
  cxSetResourceString(@sdxZoomDlgZoomTo                                 ,FsdxZoomDlgZoomTo                        );
  cxSetResourceString(@sdxZoomDlgPageWidth                              ,FsdxZoomDlgPageWidth                     );
  cxSetResourceString(@sdxZoomDlgWholePage                              ,FsdxZoomDlgWholePage                     );
  cxSetResourceString(@sdxZoomDlgTwoPages                               ,FsdxZoomDlgTwoPages                      );
  cxSetResourceString(@sdxZoomDlgFourPages                              ,FsdxZoomDlgFourPages                     );
  cxSetResourceString(@sdxZoomDlgManyPages                              ,FsdxZoomDlgManyPages                     );
  cxSetResourceString(@sdxZoomDlgPercent                                ,FsdxZoomDlgPercent                       );
  cxSetResourceString(@sdxZoomDlgPreview                                ,FsdxZoomDlgPreview                       );
  cxSetResourceString(@sdxZoomDlgFontPreview                            ,FsdxZoomDlgFontPreview                   );
  cxSetResourceString(@sdxZoomDlgFontPreviewString                      ,FsdxZoomDlgFontPreviewString             );
  cxSetResourceString(@sdxPages                                         ,FsdxPages                                );
  cxSetResourceString(@sdxCancel                                        ,FsdxCancel                               );
  cxSetResourceString(@sdxCloneStyleCaptionPrefix                       ,FsdxCloneStyleCaptionPrefix              );
  cxSetResourceString(@sdxInvalideStyleCaption                          ,FsdxInvalideStyleCaption                 );
  cxSetResourceString(@sdxPageSetupCaption                              ,FsdxPageSetupCaption                     );
  cxSetResourceString(@sdxStyleName                                     ,FsdxStyleName                            );
  cxSetResourceString(@sdxPage                                          ,FsdxPage                                 );
  cxSetResourceString(@sdxMargins                                       ,FsdxMargins                              );
  cxSetResourceString(@sdxHeaderFooter                                  ,FsdxHeaderFooter                         );
  cxSetResourceString(@sdxScaling                                       ,FsdxScaling                              );
  cxSetResourceString(@sdxPaper                                         ,FsdxPaper                                );
  cxSetResourceString(@sdxPaperType                                     ,FsdxPaperType                            );
  cxSetResourceString(@sdxPaperDimension                                ,FsdxPaperDimension                       );
  cxSetResourceString(@sdxPaperWidth                                    ,FsdxPaperWidth                           );
  cxSetResourceString(@sdxPaperHeight                                   ,FsdxPaperHeight                          );
  cxSetResourceString(@sdxPaperSource                                   ,FsdxPaperSource                          );
  cxSetResourceString(@sdxOrientation                                   ,FsdxOrientation                          );
  cxSetResourceString(@sdxPortrait                                      ,FsdxPortrait                             );
  cxSetResourceString(@sdxLandscape                                     ,FsdxLandscape                            );
  cxSetResourceString(@sdxPrintOrder                                    ,FsdxPrintOrder                           );
  cxSetResourceString(@sdxDownThenOver                                  ,FsdxDownThenOver                         );
  cxSetResourceString(@sdxOverThenDown                                  ,FsdxOverThenDown                         );
  cxSetResourceString(@sdxShading                                       ,FsdxShading                              );
  cxSetResourceString(@sdxPrintUsingGrayShading                         ,FsdxPrintUsingGrayShading                );
  cxSetResourceString(@sdxCenterOnPage                                  ,FsdxCenterOnPage                         );
  cxSetResourceString(@sdxHorizontally                                  ,FsdxHorizontally                         );
  cxSetResourceString(@sdxVertically                                    ,FsdxVertically                           );
  cxSetResourceString(@sdxHeader                                        ,FsdxHeader                               );
  cxSetResourceString(@sdxBtnHeaderFont                                 ,FsdxBtnHeaderFont                        );
  cxSetResourceString(@sdxBtnHeaderBackground                           ,FsdxBtnHeaderBackground                  );
  cxSetResourceString(@sdxFooter                                        ,FsdxFooter                               );
  cxSetResourceString(@sdxBtnFooterFont                                 ,FsdxBtnFooterFont                        );
  cxSetResourceString(@sdxBtnFooterBackground                           ,FsdxBtnFooterBackground                  );
  cxSetResourceString(@sdxTop                                           ,FsdxTop                                  );
  cxSetResourceString(@sdxLeft                                          ,FsdxLeft                                 );
  cxSetResourceString(@sdxRight                                         ,FsdxRight                                );
  cxSetResourceString(@sdxBottom                                        ,FsdxBottom                               );
  cxSetResourceString(@sdxHeader2                                       ,FsdxHeader2                              );
  cxSetResourceString(@sdxFooter2                                       ,FsdxFooter2                              );
  cxSetResourceString(@sdxAlignment                                     ,FsdxAlignment                            );
  cxSetResourceString(@sdxVertAlignment                                 ,FsdxVertAlignment                        );
  cxSetResourceString(@sdxReverseOnEvenPages                            ,FsdxReverseOnEvenPages                   );
  cxSetResourceString(@sdxAdjustTo                                      ,FsdxAdjustTo                             );
  cxSetResourceString(@sdxFitTo                                         ,FsdxFitTo                                );
  cxSetResourceString(@sdxPercentOfNormalSize                           ,FsdxPercentOfNormalSize                  );
  cxSetResourceString(@sdxPagesWideBy                                   ,FsdxPagesWideBy                          );
  cxSetResourceString(@sdxTall                                          ,FsdxTall                                 );
  cxSetResourceString(@sdxOf                                            ,FsdxOf                                   );
  cxSetResourceString(@sdxLastPrinted                                   ,FsdxLastPrinted                          );
  cxSetResourceString(@sdxFileName                                      ,FsdxFileName                             );
  cxSetResourceString(@sdxFileNameAndPath                               ,FsdxFileNameAndPath                      );
  cxSetResourceString(@sdxPrintedBy                                     ,FsdxPrintedBy                            );
  cxSetResourceString(@sdxPrintedOn                                     ,FsdxPrintedOn                            );
  cxSetResourceString(@sdxCreatedBy                                     ,FsdxCreatedBy                            );
  cxSetResourceString(@sdxCreatedOn                                     ,FsdxCreatedOn                            );
  cxSetResourceString(@sdxConfidential                                  ,FsdxConfidential                         );
  cxSetResourceString(@sdxJanuary                                       ,FsdxJanuary                              );
  cxSetResourceString(@sdxFebruary                                      ,FsdxFebruary                             );
  cxSetResourceString(@sdxMarch                                         ,FsdxMarch                                );
  cxSetResourceString(@sdxApril                                         ,FsdxApril                                );
  cxSetResourceString(@sdxMay                                           ,FsdxMay                                  );
  cxSetResourceString(@sdxJune                                          ,FsdxJune                                 );
  cxSetResourceString(@sdxJuly                                          ,FsdxJuly                                 );
  cxSetResourceString(@sdxAugust                                        ,FsdxAugust                               );
  cxSetResourceString(@sdxSeptember                                     ,FsdxSeptember                            );
  cxSetResourceString(@sdxOctober                                       ,FsdxOctober                              );
  cxSetResourceString(@sdxNovember                                      ,FsdxNovember                             );
  cxSetResourceString(@sdxDecember                                      ,FsdxDecember                             );
  cxSetResourceString(@sdxEast                                          ,FsdxEast                                 );
  cxSetResourceString(@sdxWest                                          ,FsdxWest                                 );
  cxSetResourceString(@sdxSouth                                         ,FsdxSouth                                );
  cxSetResourceString(@sdxNorth                                         ,FsdxNorth                                );
  cxSetResourceString(@sdxTotal                                         ,FsdxTotal                                );
  cxSetResourceString(@sdxCopy                                          ,FsdxCopy                                 );
  cxSetResourceString(@sdxSave                                          ,FsdxSave                                 );
  cxSetResourceString(@sdxBaseStyle                                     ,FsdxBaseStyle                            );


  cxSetResourceString(@sdxMenuViewThumbnails                            ,FsdxMenuViewThumbnails                   );
  cxSetResourceString(@sdxMenuThumbnailsLarge                           ,FsdxMenuThumbnailsLarge                  );
  cxSetResourceString(@sdxMenuThumbnailsSmall                           ,FsdxMenuThumbnailsSmall                  );
  cxSetResourceString(@sdxHintViewThumbnails                            ,FsdxHintViewThumbnails                   );
  cxSetResourceString(@sdxHintThumbnailsLarge                           ,FsdxHintThumbnailsLarge                  );
  cxSetResourceString(@sdxHintThumbnailsSmall                           ,FsdxHintThumbnailsSmall                  );
  cxSetResourceString(@sdxMenuFormatTitle                               ,FsdxMenuFormatTitle                      );
  cxSetResourceString(@sdxHintFormatTitle                               ,FsdxHintFormatTitle                      );
  cxSetResourceString(@sdxHalf                                          ,FsdxHalf                                 );
  cxSetResourceString(@sdxPredefinedFunctions                           ,FsdxPredefinedFunctions                  );
  cxSetResourceString(@sdxZoomParameters                                ,FsdxZoomParameters                       );
  cxSetResourceString(@sdxWrapData                                      ,FsdxWrapData                             );
  cxSetResourceString(@sdxMenuShortcutExplorer                          ,FsdxMenuShortcutExplorer                 );
  cxSetResourceString(@sdxExplorerToolBar                               ,FsdxExplorerToolBar                      );
  cxSetResourceString(@sdxMenuShortcutThumbnails                        ,FsdxMenuShortcutThumbnails               );

  cxSetResourceString(@sdxButtons                                       ,FsdxButtons                              );


  cxSetResourceString(@sdxMenuView                                      ,FsdxMenuView                             );
  cxSetResourceString(@sdxMenuViewMargins                               ,FsdxMenuViewMargins                      );
  cxSetResourceString(@sdxMenuViewFlatToolBarButtons                    ,FsdxMenuViewFlatToolBarButtons           );
  cxSetResourceString(@sdxMenuViewLargeToolBarButtons                   ,FsdxMenuViewLargeToolBarButtons          );
  cxSetResourceString(@sdxMenuViewMarginsStatusBar                      ,FsdxMenuViewMarginsStatusBar             );
  cxSetResourceString(@sdxMenuViewPagesStatusBar                        ,FsdxMenuViewPagesStatusBar               );
  cxSetResourceString(@sdxMenuViewToolBars                              ,FsdxMenuViewToolBars                     );
  cxSetResourceString(@sdxMenuViewPagesHeaders                          ,FsdxMenuViewPagesHeaders                 );
  cxSetResourceString(@sdxMenuViewPagesFooters                          ,FsdxMenuViewPagesFooters                 );
  cxSetResourceString(@sdxMenuViewSwitchToLeftPart                      ,FsdxMenuViewSwitchToLeftPart             );
  cxSetResourceString(@sdxMenuViewSwitchToRightPart                     ,FsdxMenuViewSwitchToRightPart            );
  cxSetResourceString(@sdxMenuViewSwitchToCenterPart                    ,FsdxMenuViewSwitchToCenterPart           );
  cxSetResourceString(@sdxMenuViewHFSwitchHeaderFooter                  ,FsdxMenuViewHFSwitchHeaderFooter         );
  cxSetResourceString(@sdxMenuViewHFClose                               ,FsdxMenuViewHFClose                      );
  cxSetResourceString(@sdxMenuFormat                                    ,FsdxMenuFormat                           );
  cxSetResourceString(@sdxMenuPreview                                   ,FsdxMenuPreview                          );
  cxSetResourceString(@sdxPrintDialogCaption                            ,FsdxPrintDialogCaption                   );
  cxSetResourceString(@sdxPrintDialogPrinter                            ,FsdxPrintDialogPrinter                   );
  cxSetResourceString(@sdxPrintDialogName                               ,FsdxPrintDialogName                      );
  cxSetResourceString(@sdxPrintDialogStatus                             ,FsdxPrintDialogStatus                    );
  cxSetResourceString(@sdxPrintDialogType                               ,FsdxPrintDialogType                      );
  cxSetResourceString(@sdxPrintDialogWhere                              ,FsdxPrintDialogWhere                     );
  cxSetResourceString(@sdxPrintDialogComment                            ,FsdxPrintDialogComment                   );
  cxSetResourceString(@sdxPrintDialogPages                              ,FsdxPrintDialogPages                     );
  cxSetResourceString(@sdxPrintDialogPrintToFile                        ,FsdxPrintDialogPrintToFile               );
  cxSetResourceString(@sdxPrintDialogPageRange                          ,FsdxPrintDialogPageRange                 );
  cxSetResourceString(@sdxPrintDialogAll                                ,FsdxPrintDialogAll                       );
  cxSetResourceString(@sdxPrintDialogCurrentPage                        ,FsdxPrintDialogCurrentPage               );
  cxSetResourceString(@sdxPrintDialogSelection                          ,FsdxPrintDialogSelection                 );
  cxSetResourceString(@sdxPrintDialogCopies                             ,FsdxPrintDialogCopies                    );
  cxSetResourceString(@sdxLeftMargin                                    ,FsdxLeftMargin                           );
  cxSetResourceString(@sdxTopMargin                                     ,FsdxTopMargin                            );
  cxSetResourceString(@sdxRightMargin                                   ,FsdxRightMargin                          );
  cxSetResourceString(@sdxBottomMargin                                  ,FsdxBottomMargin                         );
  cxSetResourceString(@sdxHeaderMargin                                  ,FsdxHeaderMargin                         );
  cxSetResourceString(@sdxFooterMargin                                  ,FsdxFooterMargin                         );
  cxSetResourceString(@sdxUnitsInches                                   ,FsdxUnitsInches                          );
  cxSetResourceString(@sdxUnitsCentimeters                              ,FsdxUnitsCentimeters                     );
  cxSetResourceString(@sdxUnitsMillimeters                              ,FsdxUnitsMillimeters                     );
  cxSetResourceString(@sdxUnitsPoints                                   ,FsdxUnitsPoints                          );
  cxSetResourceString(@sdxUnitsDefaultName                              ,FsdxUnitsDefaultName                     );
  cxSetResourceString(@sdxUnitsInchesName                               ,FsdxUnitsInchesName                      );
  cxSetResourceString(@sdxUnitsCentimetersName                          ,FsdxUnitsCentimetersName                 );
  cxSetResourceString(@sdxUnitsMillimetersName                          ,FsdxUnitsMillimetersName                 );
  cxSetResourceString(@sdxUnitsPointsName                               ,FsdxUnitsPointsName                      );
  cxSetResourceString(@sdxUnitsPicasName                                ,FsdxUnitsPicasName                       );

  cxSetResourceString(@sdxPrintPreview                                  ,FsdxPrintPreview                         );
  cxSetResourceString(@sdxReportDesignerCaption                         ,FsdxReportDesignerCaption                );
  cxSetResourceString(@sdxCompositionDesignerCaption                    ,FsdxCompositionDesignerCaption           );
  cxSetResourceString(@sdxComponentNotSupportedByLink                   ,FsdxComponentNotSupportedByLink          );
  cxSetResourceString(@sdxComponentNotSupported                         ,FsdxComponentNotSupported                );
  cxSetResourceString(@sdxPrintDeviceNotReady                           ,FsdxPrintDeviceNotReady                  );
  cxSetResourceString(@sdxUnableToGenerateReport                        ,FsdxUnableToGenerateReport               );
  cxSetResourceString(@sdxPreviewNotRegistered                          ,FsdxPreviewNotRegistered                 );
  cxSetResourceString(@sdxComponentNotAssigned                          ,FsdxComponentNotAssigned                 );
  cxSetResourceString(@sdxPrintDeviceIsBusy                             ,FsdxPrintDeviceIsBusy                    );
  cxSetResourceString(@sdxPrintDeviceError                              ,FsdxPrintDeviceError                     );
  cxSetResourceString(@sdxMissingComponent                              ,FsdxMissingComponent                     );
  cxSetResourceString(@sdxDataProviderDontPresent                       ,FsdxDataProviderDontPresent              );
  cxSetResourceString(@sdxBuildingReport                                ,FsdxBuildingReport                       );
  cxSetResourceString(@sdxPrintingReport                                ,FsdxPrintingReport                       );
  cxSetResourceString(@sdxDefinePrintStylesMenuItem                     ,FsdxDefinePrintStylesMenuItem            );
  cxSetResourceString(@sdxAbortPrinting                                 ,FsdxAbortPrinting                        );
  cxSetResourceString(@sdxStandardStyle                                 ,FsdxStandardStyle                        );

  // **********************************************************************************************************  //

  cxSetResourceString(@scxGridFilterRowInfoText                         ,FscxGridFilterRowInfoText                );
  cxSetResourceString(@scxGridColumnsQuickCustomizationHint             ,FscxGridColumnsQuickCustomizationHint    );
  cxSetResourceString(@scxGridBandsQuickCustomizationHint               ,FscxGridBandsQuickCustomizationHint      );
  cxSetResourceString(@cxSFilterOperatorEqual                           ,FcxSFilterOperatorEqual                  );
  cxSetResourceString(@cxSFilterOperatorNotEqual                        ,FcxSFilterOperatorNotEqual               );
  cxSetResourceString(@cxSFilterOperatorLess                            ,FcxSFilterOperatorLess                   );
  cxSetResourceString(@cxSFilterOperatorLessEqual                       ,FcxSFilterOperatorLessEqual              );
  cxSetResourceString(@cxSFilterOperatorGreater                         ,FcxSFilterOperatorGreater                );
  cxSetResourceString(@cxSFilterOperatorGreaterEqual                    ,FcxSFilterOperatorGreaterEqual           );
  cxSetResourceString(@cxSFilterOperatorLike                            ,FcxSFilterOperatorLike                   );
  cxSetResourceString(@cxSFilterOperatorNotLike                         ,FcxSFilterOperatorNotLike                );
  cxSetResourceString(@cxSFilterOperatorBetween                         ,FcxSFilterOperatorBetween                );
  cxSetResourceString(@cxSFilterOperatorNotBetween                      ,FcxSFilterOperatorNotBetween             );
  cxSetResourceString(@cxSFilterOperatorInList                          ,FcxSFilterOperatorInList                 );
  cxSetResourceString(@cxSFilterOperatorNotInList                       ,FcxSFilterOperatorNotInList              );
  cxSetResourceString(@cxSFilterBoolOperatorAnd                         ,FcxSFilterBoolOperatorAnd                );
  cxSetResourceString(@cxSFilterBoolOperatorOr                          ,FcxSFilterBoolOperatorOr                 );
  cxSetResourceString(@cxSFilterBoolOperatorNotAnd                      ,FcxSFilterBoolOperatorNotAnd             );
  cxSetResourceString(@cxSFilterBoolOperatorNotOr                       ,FcxSFilterBoolOperatorNotOr              );
  cxSetResourceString(@cxSFilterRootButtonCaption                       ,FcxSFilterRootButtonCaption              );
  cxSetResourceString(@cxSFilterAddCondition                            ,FcxSFilterAddCondition                   );
  cxSetResourceString(@cxSFilterAddGroup                                ,FcxSFilterAddGroup                       );
  cxSetResourceString(@cxSFilterRemoveRow                               ,FcxSFilterRemoveRow                      );
  cxSetResourceString(@cxSFilterClearAll                                ,FcxSFilterClearAll                       );
  cxSetResourceString(@cxSFilterFooterAddCondition                      ,FcxSFilterFooterAddCondition             );
  cxSetResourceString(@cxSFilterGroupCaption                            ,FcxSFilterGroupCaption                   );
  cxSetResourceString(@cxSFilterRootGroupCaption                        ,FcxSFilterRootGroupCaption               );
  cxSetResourceString(@cxSFilterControlNullString                       ,FcxSFilterControlNullString              );
  cxSetResourceString(@cxSFilterErrorBuilding                           ,FcxSFilterErrorBuilding                  );
  cxSetResourceString(@cxSFilterDialogCaption                           ,FcxSFilterDialogCaption                  );
  cxSetResourceString(@cxSFilterDialogInvalidValue                      ,FcxSFilterDialogInvalidValue             );
  cxSetResourceString(@cxSFilterDialogUse                               ,FcxSFilterDialogUse                      );
  cxSetResourceString(@cxSFilterDialogSingleCharacter                   ,FcxSFilterDialogSingleCharacter          );
  cxSetResourceString(@cxSFilterDialogCharactersSeries                  ,FcxSFilterDialogCharactersSeries         );
  cxSetResourceString(@cxSFilterDialogOperationAnd                      ,FcxSFilterDialogOperationAnd             );
  cxSetResourceString(@cxSFilterDialogOperationOr                       ,FcxSFilterDialogOperationOr              );
  cxSetResourceString(@cxSFilterDialogRows                              ,FcxSFilterDialogRows                     );
  cxSetResourceString(@cxSFilterControlDialogCaption                    ,FcxSFilterControlDialogCaption           );
  cxSetResourceString(@cxSFilterControlDialogNewFile                    ,FcxSFilterControlDialogNewFile           );
  cxSetResourceString(@cxSFilterControlDialogOpenDialogCaption          ,FcxSFilterControlDialogOpenDialogCaption );
  cxSetResourceString(@cxSFilterControlDialogSaveDialogCaption          ,FcxSFilterControlDialogSaveDialogCaption );
  cxSetResourceString(@cxSFilterControlDialogActionSaveCaption          ,FcxSFilterControlDialogActionSaveCaption );
  cxSetResourceString(@cxSFilterControlDialogActionOpenCaption          ,FcxSFilterControlDialogActionOpenCaption );
  cxSetResourceString(@cxSFilterControlDialogActionApplyCaption         ,FcxSFilterControlDialogActionApplyCaption);
  cxSetResourceString(@cxSFilterControlDialogActionOkCaption            ,FcxSFilterControlDialogActionOkCaption   );
  cxSetResourceString(@cxSFilterControlDialogActionCancelCaption        ,FcxSFilterControlDialogActionCancelCaption);
  cxSetResourceString(@cxSFilterControlDialogFileExt                    ,FcxSFilterControlDialogFileExt           );
  cxSetResourceString(@cxSFilterControlDialogFileFilter                 ,FcxSFilterControlDialogFileFilter        );

end;


end.



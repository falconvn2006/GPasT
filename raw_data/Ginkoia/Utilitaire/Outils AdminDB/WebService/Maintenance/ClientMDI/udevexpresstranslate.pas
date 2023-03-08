unit udevexpresstranslate;

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

/// En Français (Commence Par un F)
resourcestring
  FscxGridNoDataInfoText = '<Aucune Donnée>';

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
  FcxSGridShowFooter = 'Pieds';
  FcxSGridShowGroupFooter = 'Pieds de Groupe';

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

  // printing systeme
  FsdxBtnOK = 'OK';
  FsdxBtnCancel = 'Annuler';
  FsdxBtnClose = 'Fermer';
  FsdxPrintDialogCaption = 'Impression';
  FsdxPrintDialogPrinter = 'Imprimante :';
  FsdxPrintDialogName = 'Nom :';
  FsdxPrintDialogStatus = 'Etat :';
  FsdxPrintDialogType = 'Type :';
  FsdxPrintDialogWhere = 'Emplacement :';
  FsdxPrintDialogComment = 'Commentaire :';
  FsdxPrintDialogPrintToFile = 'Imprimer dans un fichier';
  FsdxPrintDialogPageRange = 'Zone d''Impression';

  FscxGridFilterRowInfoText= 'Cliquez ici pour ajouter un filtre';

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

  // FilterControlDialog
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

{
  FsdxPrintDialogAll = 'Tout';
  FsdxPrintDialogCurrentPage = 'Page courante';
  FsdxPrintDialogSelection = 'Sélection;
  FsdxPrintDialogPages = '';
  FsdxPrintDialogRangeLegend = '';
  FsdxPrintDialogCopies = 'Copies';
  FsdxPrintDialogNumberOfPages = '';
  FsdxPrintDialogNumberOfCopies = '';
  FsdxPrintDialogCollateCopies = '';
  FsdxPrintDialogAllPages = '';
  FsdxPrintDialogEvenPages = '';
  FsdxPrintDialogOddPages = '';
    FsdxPrintDialogPrintStyles = '';
    FsdxPrintDialogOpenDlgTitle = '';
    FsdxPrintDialogOpenDlgAllFiles = '';
    FsdxPrintDialogOpenDlgPrinterFiles = '';
    FsdxPrintDialogPageNumbersOutOfRange = '';
    FsdxPrintDialogInvalidPageRanges = '';
    FsdxPrintDialogRequiredPageNumbers = '';
    FsdxPrintDialogNoPrinters = '';
    FsdxPrintDialogInPrintingState = '';
    FsdxPrintDialogPSPaused = '';
    FsdxPrintDialogPSPendingDeletion = '';
    FsdxPrintDialogPSBusy = '';
    FsdxPrintDialogPSDoorOpen = '';
    FsdxPrintDialogPSError = '';
    FsdxPrintDialogPSInitializing = '';
    FsdxPrintDialogPSIOActive = '';
    FsdxPrintDialogPSManualFeed = '';
    FsdxPrintDialogPSNoToner = '';
    FsdxPrintDialogPSNotAvailable = '';
    FsdxPrintDialogPSOFFLine = '';
    FsdxPrintDialogPSOutOfMemory = '';
    FsdxPrintDialogPSOutBinFull = '';
    FsdxPrintDialogPSPagePunt = '';
    FsdxPrintDialogPSPaperJam = '';
    FsdxPrintDialogPSPaperOut = '';
    FsdxPrintDialogPSPaperProblem = '';
    FsdxPrintDialogPSPrinting = '';
    FsdxPrintDialogPSProcessing = '';
    FsdxPrintDialogPSTonerLow = '';
    FsdxPrintDialogPSUserIntervention = '';
    FsdxPrintDialogPSWaiting = '';
    FsdxPrintDialogPSWarningUp = '';
    FsdxPrintDialogPSReady = 'Prête';
    FsdxPrintDialogPSPrintingAndWaiting : String;
}

    FsdxMenuFile = 'Fichier';
    FsdxMenuFileRebuild = 'Reconstruire';
    FsdxMenuFileDesign = 'Design';
    FsdxMenuFilePrint = 'Imprimer...';
    FsdxMenuFilePageSetup = 'Mise en page';
//    FsdxMenuPrintStyles = '';
    FsdxMenuFileExit = 'Quitter';
    FsdxMenuEdit = 'Edition';

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

      cxSetResourceString(@sdxBtnOK , FsdxBtnOK );
      cxSetResourceString(@sdxBtnCancel , FsdxBtnCancel );
      cxSetResourceString(@sdxBtnClose ,  FsdxBtnClose );
      cxSetResourceString(@sdxPrintDialogCaption , FsdxPrintDialogCaption );
      cxSetResourceString(@sdxPrintDialogPrinter , FsdxPrintDialogPrinter );
      cxSetResourceString(@sdxPrintDialogName , FsdxPrintDialogName );
      cxSetResourceString(@sdxPrintDialogStatus , FsdxPrintDialogStatus );
      cxSetResourceString(@sdxPrintDialogType , FsdxPrintDialogType );
      cxSetResourceString(@sdxPrintDialogWhere , FsdxPrintDialogWhere );
      cxSetResourceString(@sdxPrintDialogComment , FsdxPrintDialogComment );
      cxSetResourceString(@sdxPrintDialogPrintToFile,  FsdxPrintDialogPrintToFile );
      cxSetResourceString(@sdxPrintDialogPageRange,  FsdxPrintDialogPageRange );

      cxSetResourceString(@sdxMenuFile, FsdxMenuFile);
      cxSetResourceString(@sdxMenuFileRebuild, FsdxMenuFileRebuild);
      cxSetResourceString(@sdxMenuFileDesign, FsdxMenuFileDesign);
      cxSetResourceString(@sdxMenuFilePrint, FsdxMenuFilePrint);
      cxSetResourceString(@sdxMenuFilePageSetup, FsdxMenuFilePageSetup);
//      cxSetResourceString(@sdxMenuPrintStyles,    FsdxMenuPrintStyles);
      cxSetResourceString(@sdxMenuFileExit,    FsdxMenuFileExit);
      cxSetResourceString(@sdxMenuEdit,    FsdxMenuEdit);

      cxSetResourceString(@scxGridFilterRowInfoText, FscxGridFilterRowInfoText);
      cxSetResourceString(@scxGridColumnsQuickCustomizationHint,FscxGridColumnsQuickCustomizationHint);
      cxSetResourceString(@scxGridBandsQuickCustomizationHint,FscxGridBandsQuickCustomizationHint);

      cxSetResourceString(@cxSFilterOperatorEqual,FcxSFilterOperatorEqual);
      cxSetResourceString(@cxSFilterOperatorNotEqual,FcxSFilterOperatorNotEqual);
      cxSetResourceString(@cxSFilterOperatorLess,FcxSFilterOperatorLess);
      cxSetResourceString(@cxSFilterOperatorLessEqual,FcxSFilterOperatorLessEqual);
      cxSetResourceString(@cxSFilterOperatorGreater,FcxSFilterOperatorGreater);
      cxSetResourceString(@cxSFilterOperatorGreaterEqual,FcxSFilterOperatorGreaterEqual);
      cxSetResourceString(@cxSFilterOperatorLike,FcxSFilterOperatorLike);
      cxSetResourceString(@cxSFilterOperatorNotLike,FcxSFilterOperatorNotLike);
      cxSetResourceString(@cxSFilterOperatorBetween,FcxSFilterOperatorBetween);
      cxSetResourceString(@cxSFilterOperatorNotBetween,FcxSFilterOperatorNotBetween);
      cxSetResourceString(@cxSFilterOperatorInList,FcxSFilterOperatorInList);
      cxSetResourceString(@cxSFilterOperatorNotInList,FcxSFilterOperatorNotInList);

      cxSetResourceString(@cxSFilterBoolOperatorAnd, FcxSFilterBoolOperatorAnd);
      cxSetResourceString(@cxSFilterBoolOperatorOr, FcxSFilterBoolOperatorOr);
      cxSetResourceString(@cxSFilterBoolOperatorNotAnd, FcxSFilterBoolOperatorNotAnd);
      cxSetResourceString(@cxSFilterBoolOperatorNotOr,  FcxSFilterBoolOperatorNotOr);
      cxSetResourceString(@cxSFilterRootButtonCaption, FcxSFilterRootButtonCaption);
      cxSetResourceString(@cxSFilterAddCondition,FcxSFilterAddCondition);
      cxSetResourceString(@cxSFilterAddGroup, FcxSFilterAddGroup);
      cxSetResourceString(@cxSFilterRemoveRow, FcxSFilterRemoveRow);
      cxSetResourceString(@cxSFilterClearAll,FcxSFilterClearAll);
      cxSetResourceString(@cxSFilterFooterAddCondition,FcxSFilterFooterAddCondition);
      cxSetResourceString(@cxSFilterGroupCaption,FcxSFilterGroupCaption);
      cxSetResourceString(@cxSFilterRootGroupCaption,FcxSFilterRootGroupCaption);
      cxSetResourceString(@cxSFilterControlNullString,cxSFilterControlNullString);

      cxSetResourceString(@cxSFilterErrorBuilding,FcxSFilterErrorBuilding);
      cxSetResourceString(@cxSFilterDialogCaption,FcxSFilterDialogCaption);
      cxSetResourceString(@cxSFilterDialogInvalidValue,FcxSFilterDialogInvalidValue);
      cxSetResourceString(@cxSFilterDialogUse,FcxSFilterDialogUse);
      cxSetResourceString(@cxSFilterDialogSingleCharacter,FcxSFilterDialogSingleCharacter);
      cxSetResourceString(@cxSFilterDialogCharactersSeries,FcxSFilterDialogCharactersSeries);
      cxSetResourceString(@cxSFilterDialogOperationAnd,FcxSFilterDialogOperationAnd);
      cxSetResourceString(@cxSFilterDialogOperationOr,FcxSFilterDialogOperationOr);
      cxSetResourceString(@cxSFilterDialogRows,FcxSFilterDialogRows);

        // FilterControlDialog

      cxSetResourceString(@cxSFilterControlDialogCaption,FcxSFilterControlDialogCaption);
      cxSetResourceString(@cxSFilterControlDialogNewFile,FcxSFilterControlDialogNewFile);
      cxSetResourceString(@cxSFilterControlDialogOpenDialogCaption,FcxSFilterControlDialogOpenDialogCaption);
      cxSetResourceString(@cxSFilterControlDialogSaveDialogCaption,FcxSFilterControlDialogSaveDialogCaption);
      cxSetResourceString(@cxSFilterControlDialogActionSaveCaption,FcxSFilterControlDialogActionSaveCaption);
      cxSetResourceString(@cxSFilterControlDialogActionOpenCaption,FcxSFilterControlDialogActionOpenCaption);
      cxSetResourceString(@cxSFilterControlDialogActionApplyCaption,FcxSFilterControlDialogActionApplyCaption);
      cxSetResourceString(@cxSFilterControlDialogActionOkCaption,FcxSFilterControlDialogActionOkCaption);
      cxSetResourceString(@cxSFilterControlDialogActionCancelCaption,FcxSFilterControlDialogActionCancelCaption);
      cxSetResourceString(@cxSFilterControlDialogFileExt,FcxSFilterControlDialogFileExt);
      cxSetResourceString(@cxSFilterControlDialogFileFilter,FcxSFilterControlDialogFileFilter);
end;


end.

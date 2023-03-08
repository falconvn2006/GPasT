UNIT GinkoiaResStr;

INTERFACE

  // les ressourcestring ont été enlevés car il y a conflit avec les composant RX  
const

  // Module STOCKIT pour EKOSPORT
  UILModuleEkoStockit = 'EKOSPORT';

  // Caisse - location
  RS_QRY_LOC_SuppOrga = 'Voulez-vous retirer l''organisme associé à la ligne de location ?';
  RS_TXT_LOC_RegFixHL = 'Hors limite';
  RS_ERR_LOC_NotType3 = 'Il est interdit de choisir le niveau "§0" pour un poids inférieur à 22 Kg';
  

  //--------------------------------------------------------------------------------
  // Module et permission Tableau de bord ISF
  //--------------------------------------------------------------------------------
  UILModuleISF      = 'menu -diriger & admin- Tableau de bord Intersport';
  UILModuleObjectif = 'menu -diriger & admin- Objectifs';
  UILModuleTblbISF  = 'TABLEAU BORD ISF';


  //--------------------------------------------------------------------------------
  // Module et permission Fusion de fiche article
  //--------------------------------------------------------------------------------
  UILModuleFusion   = 'menu - gérer les produits - Fusion de fiche modèle';
  UILModuleFusionMod= 'FUSION FICHE MODELE';
  
  //--------------------------------------------------------------------------------
  // Module et permission BL Fournisseurs automatique
  //--------------------------------------------------------------------------------
  UILMenuBLF        = 'menu - gérer les produits - BL Fournisseurs automatiques';
  UILModifBLF       = 'modifier - BL Fournisseurs automatiques';
  UILModifParamBLF  = 'modifier - BL Fournisseurs - Paramétrage de la gestion du RAL';
  UILModifAffectBLF = 'modifier - BL Fournisseurs - Affectation de réception';
  UILModuleBLF      = 'BL FOURNISSEUR ISF';
  
  //--------------------------------------------------------------------------------
  // Ressource string utilisé pour les droits
  //--------------------------------------------------------------------------------
  UILRecepPxAchatVoir = 'voir - PRIX ACHAT en RECEPTION';  //Droit en réception pour la visualisation des prix d'achat
  UILModifNomencWeb         = 'menu - modifier - NOMENCLATURE WEB';
  UILModifier_ControleEncaissement = 'modifier - Compta - CONTROLE ENCAISSEMENT';
  UILMenu_ControleEncaissement = 'menu -diriger & admin- Compta - CONTROLE ENCAISSEMENT';
  UilModif_FicheArticleLoc = 'modifier - location - FICHE ARTICLES';
  UILModifGrilleLoc     = 'modifier - LOCATION - GRILLE TARIFAIRE';
  UilCF_EtatStkDate = 'Contrôle Fiscal - ETAT STOCK A DATE';
  UilCF_AnaMvt      = 'Contrôle Fiscal - ANALYSE MOUVEMENT';
  UilCF_LstTktBDC   = 'Contrôle Fiscal - LISTE TICKET BDC';
  UilCF_LstFact     = 'Contrôle Fiscal - LISTE FACTURE';
  UilCF_TrfInterMag = 'Contrôle Fiscal - TRF INTERMAG FACTURE';
  UILRefDynGinParam     = 'menu - paramétrage - GESTION DES PRODUITS - Ref Dynamique';
  UILRefDynGinFichArt   = 'modifier - FICHE ARTICLE - Par référencement dynamique';
  UILRecepPxVteModif = 'modifier - PRIX VENTE en RECEPTION';
  UILRecepPxAchatModif = 'modifier - PRIX ACHAT en RECEPTION';
  UILRefSKMUse = 'menu - gérer les produits - REFERENCEMENT SKIMIUM';
  UILImpODLUse = 'menu - gérer les produits - IMPORT ODLO';
  UILDepotVenteParam    = 'menu - paramétrage - DEPOT VENTE';
  UILDepotVenteModif    = 'modifier - DEPOT VENTE - Gérer les contrats';
  UILDepotVenteModifMat = 'modifier - DEPOT VENTE - Gérer le matériel';
  UILEntrepotParam = 'menu - paramétrage - ENTREPOT';
  UILEntrepotGestPlacement = 'menu - Entrepôt - Gestion  des emplacements';
  UILEntrepotGestPicking = 'menu - Entrepôt - Réapprovisionnement de la zone Picking';
  UILEntrepotModif = 'modifier - ENTREPOT';
  UILTransIMWeb = 'menu - gérer les produits - TRANSF. INTER-MAGASINS WEB'; // remplace 'menu - gérer les produits - TRANSF. INTER-MAGASINS PLATEFORME'
  UILTransIMWebForceMajStock = 'modifier - TRANSF. IM WEB - Forcer la mise à jour du stock';
  UILTransIMWebAffEcart = 'modifier - TRANSF. IM WEB - Affichage des écarts';
  UILTransIMWebValidEcarts = 'modifier - TRANSF. IM WEB - Valider avec écarts/sans contrôle';
  UILForceClotureRapprochement = 'menu -diriger & admin- Compta - Forcer clôt. bon rapprochement';
  UILMenu_BeColTrace = 'menu -diriger & admin- ctrl des caisses – TRACE BE COLLECT OR';
  UILForcerControle_BonPrepa='modifier - BON DE PREPARATION - Forcer CONTROLER';
  UILAnnuler_ActionBonPrepa = 'modifier - BON DE PREPARATION - Annuler Action';
  UILMenu_VisuBonPrepra = 'menu - vendre - Bon de préparation';
  UILModifier_BonPrepra = 'modifier - BON DE PREPARATION';
  UILMenu_ParamBonPrepa = 'menu - paramétrage - BON PREPARATION';
  UILMenu_ListArtWeb = 'menu - gérer les produits - Web - Liste Art Web';
  UILLOCMODIFTARIF = 'modifier - location - TARIF';
  UILArticle_StatOC = 'menu - gérer les produits -gestion articles- STAT OP. COM';
  UILClient_AnalyseFidelite = 'menu - gérer la relation client - ANALYSE FIDELITE';
  UILMenu_EtatStockIdeal = 'menu - gérer les produits -analyse du stock- GESTION DU STOCK IDEAL';
  UILCaisse_paramBeCol = 'caisse - paramétrage - Paramétrage Be Collect or';
  UILMenu_Echeancier = 'menu -diriger & admin- Compta - Echéancier';
  UIL_AccesAPISOFT = 'Comptabilité : Accès à l''exportation APISOFT';
  UIL_AccesCEGID = 'Comptabilité : Accès à l''exportation PGI (CEGID)';
  UILMenu_RapComptable = 'menu -diriger & admin- Compta - Rapprochement Factures Fourn.';
  UILCaisse_MODIFBAFIDBOX = 'caisse - FIDBOX REPRISE MANUELLE DES BONS DE REDUCTION';
  uil_Atelier = 'menu - Atelier';
  uil_ParamAtelier = 'menu - Paramétrage - Atelier';
  UILModuleresa = 'RESERVATION CENTRALE';
  UILcaisse_ChequeCadeau = 'caisse - GESTION DES CHEQUES CADEAUX';
  UILCaisse_ParamFidbox = 'caisse - paramétrage - Paramètres FIDBOX';
  uil_IntegAuto = 'menu - location - INTEGRATIONS AUTOMATIQUES';
  uil_integautoParam = 'menu - location - PARAMETRAGE (INTEGRATION AUTOMATIQUE)';
  uil_PrevisionReservation = 'menu - location - Prévisionnel de réservation';
  UILMenu_GestionGroupeeClt = 'menu - gérer la relation client - GESTION GROUPEE DES CLIENTS';
  UILDedoublonnage = 'menu - gérer les produits -Référencement- Gestion doublons';
  UILImp_SP2000 = 'menu - gérer les produits -Import Sport 2000';
  UILNumCB = 'voir - fiche client - NUMERO CARTE DE PAIEMENT';
  UILMenu_LocAmortLot = 'menu - location - AMORTISSEMENTS PAR LOTS';
  UILMenu_ParamWebVente = 'menu - paramétrage - WEB VENTE';
  UILGestion_WebVente = 'gestion - WEB VENTE';
  UILMenu_Etiquettes = 'menu - paramétrage - ETIQUETTES';
  UIl_voir_ficheclient_hisloloc = 'voir - fiche client - HISTORIQUE DES LOCATIONS';
  UILMenu_TarifOC = 'menu - gérer les produits -gestion articles- TARIF OP. COM';
  UILMenu_ActiverTarifOC = 'menu - gérer les produits -gestion articles- Activer TOC';
  UILMenu_GestionTarifOC = 'menu - gérer les produits -gestion articles- Gestion TOC';
  UILMenu_AssAideTrsfMM = 'menu - gérer les produits - ASSISTANT D''AIDE TRF INTER-MAG';
  UILMenu_CltArch = 'menu - gérer la relation client - Liste clients archivés';
  UILMenu_JournalBA = 'menu -diriger & admin- ctrl de l''activité - RECAP. BONS ACHAT';
  UILMenu_ImpCesAmort = 'menu -diriger & admin- ctrl de l''activ. - Ed. Cession et Amort.';
  UILMenu_JouLoc = 'menu -diriger & admin- ctrl de l''activ. - Journal de location';
  UILMenu_EtatPark = 'menu -diriger & admin- ctrl de l''activ. - Etat des loc. en cours';
  UILMenu_TrfGebuco = 'menu -diriger & admin- Compta - Export GEBUCO';
  UILmodif_TRfBlFact = 'modifier - BL - TRANSFERER EN FACTURE';
  UILmodif_TRfDvDv = 'modifier - DEVIS - TRANSFERER EN DEVIS';
  UILmodif_TRfDvBl = 'modifier - DEVIS - TRANSFERER EN BL';
  UILmodif_TRfDvFact = 'modifier - DEVIS - TRANSFERER EN FACTURE';
  UILMenu_GestionGroupeArtLoc = 'menu - location - GESTION GROUPEE ARTICLES LOCATION';
  UILSuperArchi = 'modifier - location - fiche article - ARCHIVAGE EXCEPTIONNEL';
  UILMenu_CltGRDLivre = 'menu -diriger & admin- gestion des cptes clients - GRAND LIVRE';
  UILmodif_Lettrage = 'modifier - CLIENT - MODIFIER LE LETTRAGE DES COMPTES';
  UILGestion_REFERENCEMENT = 'gestion - REFERENCEMENT';
  UILMenu_RefMajPrixVente = 'menu - gérer les produits -Référencement- MAJ prix de vente';
  UILMenu_RefGestionNk = 'menu - gérer les produits -Référencement- Gestion nomenclature';
  UILMenu_Artsanscol = 'menu - gérer les produits -analyse du stock- ART. SANS COL.';
  UILMenu_ArtPlusCol = 'menu - gérer les produits -analyse du stock- ART. PLUSIEUR COL.';
  UILMenu_Colavecart = 'menu - gérer les produits -analyse du stock- COL. AVEC ART.';
  UILcaisse_GenerationBR = 'caisse - GENERATION BON DE RESERVATION';
  UILMenu_Depreciation = 'menu - gérer les produits -gestion articles- DEPRECIATION';
  UILMenu_LocRnonP = 'menu -diriger & admin- ctrl de l''activ. - LOC Rend. non payées';
  UILMenu_CdeVrac = 'menu - acheter - commandes - COMMANDES EN VRAC';
  UILMenu_RecepVrac = 'menu - gérer les produits - RECEPTIONS EN VRAC';
  UILVoir_VisuMagsRecepVrac = 'voir - TOUS LES MAGASINS - RECEPTIONS VRAC';
  UILMenu_LstDetArtLoc = 'menu -diriger & admin- Ed. Location - Liste dét. des articles';
  UILMenu_AnaDetParcLoc = 'menu -diriger & admin- Ed. Location - Analyse dét. du parc';
  UILMenu_CltRapido = 'menu - location - SAISIE RAPIDE FICHE CLIENT (LOCATION)';
  UILMenu_ClotCaisse = 'menu -diriger & admin- ctrl des caisses - CLOTURE CAISSE';
  UILMenu_AnaPerLoc = 'menu -diriger & admin- Ed. Location - Analyse périodique';
  UILMenu_CAPrevLoc = 'menu -diriger & admin- Ed. Location - CA Prévisionnel';
  UILMenu_AnalyseCALoc = 'menu -diriger & admin- Ed. Location - Analyse du CA';
  UILmodif_Reservation = 'modifier - LOCATION - MODIFIER LES FICHES DE RESERVATION';
  UILMenu_LocReservation = 'menu - location - GESTION RESERVATION LOCATION';
  UILMenu_AnalyseEnchaine = 'menu -diriger & admin- ctrl de l''activité - EDIT. ENCHAINEES';
  UILmodif_CarteBleu = 'modifier - LOCATION - N° CARTE BLEU';
  UILMenu_LocCarteMag = 'menu - location - CARTES MAGASIN';
  UILMenu_LocGestionTarif = 'menu - location - GESTION TARIF LOCATION';
  UILMenu_ParamGesArt = 'menu - paramétrage - GESTION DES PRODUITS';
  UILMenu_ParamGen = 'menu - paramétrage - PARAMETRAGE GENERAL';
  UILMenu_GesParamLoc = 'menu - paramétrage - PARAMETRAGE LOCATION';
  UILMenu_GesLocalModules = 'menu - paramétrage - GESTION MODULES VERSION';
  UILMenu_ListeDetailClt = 'menu - gérer la relation client - LISTE DETAILLEE CLIENTS';
  UILMenu_AnalyseTrsfMM = 'menu - gérer les produits - ANALYSE TRANSFERT INTER-MAGASINS';
  UILMenu_ListArtArchive = 'menu - gérer les produits -analyse du stock- LISTE ART. ARCHIVES';
  UILMenu_AnalyseConsoDiv = 'menu - gérer les produits -gestion articles- ANALYSE CONSO';
  UILMenu_RegulStock = 'menu - gérer les produits -gestion articles- REGUL. STOCK';
  UILMenu_GestGroupArt = 'menu - gérer les produits -gestion articles- GESTION GROUPE ART';
  UILMenu_Preco = 'menu - acheter - commandes - BLOC NOTE DE COMMANDE';
  UILMenu_Annulation = 'menu - acheter - commandes - GESTIONS DES ANNULATIONS';
  UILMenu_AnalyseNN1SF = 'menu -diriger & admin- ctrl de l''activité - ANALYSE N/N-1 MARQUE';
  UILMenu_AnalyseNN1 = 'menu -diriger & admin- ctrl de l''activité - ANALYSE N/N-1 SOUS FAMILLE';
  UILTrsfMMMAGSO = 'voir - TRANSFERT INTER MAG - LES AUTRES MAGASINS COMME ORIGINE';
  UILMenu_ANABAO = 'menu -diriger & admin- ctrl de l''activité - BONS ACHAT';
  //    UILLOCMODIFDETAIL='caisse - FONCTION DETAIL MODIFICATION DU BON DE LOCATION';
  UILLOCMODIFDETAIL = 'modifier - location - DETAIL DU BON LOCATION';
  //    UILLOCMODIFGLOBALE='caisse - MODIFICATION GLOBALE DU BON DE LOCATION';
  UILLOCMODIFGLOBALE = 'modifier - location - BON LOCATION GLOBAL';
  UILLOCANNULDIC = 'location - ANNULATION DU BON DE LOCATION';
  UILMENU_LOCINVENTAIRE = 'menu - location - INVENTAIRE';
  // UILMenu_RecapTVA = 'menu -diriger & admin- ctrl des caisses - RECAP. TVA';
  UILMenu_RecapTVA = 'menu -diriger & admin- ctrl des caisses - SYNTH. CA';
  UILMenu_SynthMvt = 'menu -diriger & admin- ctrl des caisses - SYNTHESE MOUVEMENTS';
  UILMenu_DetMvtMag = 'menu -diriger & admin- ctrl des caisses - DETAIL DES MOUVEMENTS';
  UILMENU_RETFOURN = 'menu - gérer les produits - RETOURS FOURNISSEURS';
  Uilmenu_FicheArticleLoc = 'menu - location - FICHE ARTICLES';
  Uilmenu_ControlePiccolink = 'menu - location - CONTROLE PICCOLINK';
  Uilmenu_EditionTarifLoc = 'menu - location - EDITION TARIF LOCATION';
  UILCaisse_TPE = 'caisse -TPE- VALIDATION DU TICKET MALGRE LA TRANSACTION ANNULEE';
  UILMenu_GesCoffre = 'menu -diriger & admin- Coffre - Gestion du coffre';
  UILMenu_HistoCoffre = 'menu -diriger & admin- Coffre - Historique du coffre';
  UILcaisse_GenerationBL = 'caisse - GENERATION BON DE LIVRAISON';
  UILclient_Analyse = 'menu - gérer la relation client -mailing- CONSTRUCTION';
  UILclient_Mailing = 'menu - gérer la relation client -mailing- GESTION DES MAILING';
  UILMenu_AnalyseVente = 'menu -diriger & admin- ctrl de l''activité - ANALYSE DES VENTES';
  UILReajustCompte = 'caisse - REAJUSTEMENT D''UN COMPTE CLIENT';
  UILSuper = 'SUPER';
  UILPxVentePreco = 'menu - gérer les produits - Prix de vente préconisés à date';

  UIL_ModuleReportMercier = 'REPORTING MERCIER';
  UILGestionEncours = 'modifier - CLIENT - Gestion de l''encours';

  //--------------------------------------------------------------------------------
  // Gestion des marques & fournisseurs
  //--------------------------------------------------------------------------------
  UIL_MRKCREATE = 'modifier - MARQUES';

  //--------------------------------------------------------------------------------
  // Nom des vieilles Permissions
  //--------------------------------------------------------------------------------

  // UILFct_Negoce = 'FCT-NEGOCE';
  // UILFct_GestCde = 'FCT-GESTION CDE';
  // UILmodif_NK = 'NOMENCLATURE - MODIFIER';
  // UILVisuMag = 'VISU MAG';
  // UILVisuMag_Stock = 'VISU MAG - STOCK';
  // UILmodif_Art = 'FICHE ARTICLE - MODIFIER';
  // UILachatVis_Art = 'FICHE ARTICLE - ACHAT VISIBLE';
  // UILmodif_Bcde = 'BON CDE - MODIFIER';
  // UILmodif_Recep = 'BON RECEPTION - MODIFIER';
  //UILmodif_TransMM = 'BON TRANSFERT - MODIFIER';
  UILsupligne = 'CAISSE - SUPLIGNE';
  UILsupticket = 'CAISSE - SUPTICKET';
  UILannulTicket = 'CAISSE - ANNULTICKET';
  UILOuvreTC = 'CAISSE - OUVTC';
  UILtiketNegatif = 'CAISSE - TICKETNEGATIF';
  UILremise = 'CAISSE - REMISE';
  UILmajCF = 'CAISSE - MAJCF';
  UILOdSession = 'CAISSE - OLDSESSION';
  UILtraining = 'CAISSE - TRAINING';

  //--------------------------------------------------------------------------------
  // Permissions de Modification - Création - Suppression
  //--------------------------------------------------------------------------------
  UILModif_BonBcde = 'modifier - BON DE COMMANDE';
  UILModif_BonRecep = 'modifier - BON DE RECEPTION';
  UILModif_TrsfMM = 'modifier - BON DE TRANSFERT INTER MAGASINS';
  UILModif_FicheArt = 'modifier - FICHE ARTICLE';
  UILModif_LaNK = 'modifier - NOMENCLATURE';
  UILModif_Fournisseur = 'modifier - FOURNISSEUR';
  UILModif_ConsoDiv = 'modifier - CONSO DIVERSES';
  UILModif_TarVente = 'modifier - TARIFS DE VENTE';
  UILModif_Clt = 'modifier - CLIENT';
  UILModif_Livr = 'modifier - BON DE LIVRAISON';
  UILModif_Devis = 'modifier - DEVIS';
  UILModif_Fact = 'modifier - FACTURE';
  UILModif_LocFicheArt = 'modifier - LOCATION - FICHES ARTICLES';

  //--------------------------------------------------------------------------------
  // Permissions de Visualisation de données
  //--------------------------------------------------------------------------------
  UILVoir_Tarif = 'voir - fiche article - ONGLET TARIF';
  UILVoir_Mags = 'voir - TOUS LES MAGASINS';
  UILVoir_StockMags = 'voir - TOUS LES MAGASINS - STOCK';

  //--------------------------------------------------------------------------------
  // Permissions de gestion de la CAISSE
  //--------------------------------------------------------------------------------
  UILCaisse_Cloturer = 'caisse -session- CLOTURER / PRELEVER';
  UILCaisse_SupprTik = 'caisse - SUPPRESSION D''UNE LIGNE DE TICKET';
  UILCaisse_EncTikNeg = 'caisse - ENCAISSEMENT D''UN TICKET NEGATIF';
  UILCaisse_AnnulTik = 'caisse - ANNULATION DU TICKET EN COURS';
  UILCaisse_SupprOldTik = 'caisse - SUPPRESSION D''UN ANCIEN TICKET';
  //    UILCaisse_VteSoldee = 'caisse - VENTE SOLDEE';
  //    UILCaisse_VtePromo = 'caisse - VENTE PROMO';
  UILCaisse_VteRemise = 'caisse - VENTE AVEC REMISE';
  UILCaisse_RetClient = 'caisse - RETOUR CLIENT';
  UILCaisse_FicheClient = 'caisse - CREATION MODIF FICHES CLIENTS';
  UILCaisse_ReajCF = 'caisse - REAJUSTEMENT D''UNE CARTE DE FIDELIETE';
  UILCaisse_Training = 'caisse - MODE TRAINING';
  UILCaisse_ParamModeEnc = 'caisse -session- PARAMETRAGE DES MODES D''ENCAISSEMENT';
  UILCaisse_OngletUtil = 'caisse - ONGLET UTILITAIRE';
  UILCaisse_OuvManu = 'caisse - OUVERTURE MANUELLE DU TIROIR';
  UILCaisse_SaisirDepense = 'caisse - SAISIR UNE DEPENSE';
  UILCaisse_RembClt = 'caisse - REMBOURSEMENT CLIENT';
  UILCaisse_Utilcaisse = 'caisse -activité- UTILISATION DE LA CAISSE';
  UILCaisse_Gestionsessions = 'caisse -activité- GESTION DES SESSIONS';
  UILCaisse_OuvertureSession = 'caisse -session- OUVERTURE DE SESSION';
  UILCaisse_ClotureSessions = 'caisse -session- CLOTURE DE SESSIONS';
  UILCaisse_HistoSessions = 'caisse -session- HISTORIQUE DES SESSIONS';
  UILCaisse_EditionJournaux = 'caisse -session- EDITION DES JOURNAUX';
  UILCaisse_VerifComptage = 'caisse - clôture de session - Vérifier le comptage';
  UILCaisse_PrelClot = 'caisse - clôture de session - Prélever / Clôturer';
  UILCaisse_ParamCaisse = 'caisse - paramétrage - Paramètres de la caisse';
  UILCaisse_ParamBtn = 'caisse - paramétrage - Paramétrage des boutons';
  UILCaisse_OkCreationMotif = 'caisse - CREATION MOTIF MODIFICATION DE TICKET';

  //--------------------------------------------------------------------------------
  // Permissions d'accès au menu de Ginkoia
  //--------------------------------------------------------------------------------
  UILMenu_TrfCompta = 'menu -diriger & admin- Compta - Transfert en comptabilité';
  UILMenu_ListeTik = 'menu -diriger & admin- ctrl des caisses - LISTE DES TICKETS';
  UILMenu_RecapCaisse = 'menu -diriger & admin- ctrl des caisses - EDITION RECAP.';
  UILMenu_JournalVte = 'menu -diriger & admin- ctrl de l''activité - JOURNAL DE VENTE';
  UILMenu_CAHorDate = 'menu -diriger & admin- ctrl de l''activité - CA HORAIRE/DATE';
  UILMenu_HitParade = 'menu -diriger & admin- ctrl de l''activité - HIT PARADE VENTES';
  UILMenu_AnalyseSynth = 'menu -diriger & admin- ctrl de l''activité - ANALYSE SYNTHETIQUE';
  UILMenu_CAVend = 'menu -diriger & admin- gestion du personnel - CA PAR VENDEUR';
  UILMenu_CAHorVend = 'menu -diriger & admin- gestion du personnel - CA HORAIRE/VENDEUR';
  UILMenu_CltSolde = 'menu -diriger & admin- gestion des cptes clients - CTRL SOLDES';
  UILMenu_Fourn = 'menu - acheter - FOURNISSEURS';
  UILMenu_Cde = 'menu - acheter - commandes - GESTION DES COMMANDES';
  UILMenu_CarnetCde = 'menu - acheter - commandes - ANALYSE DU CARNET DE COMMANDES';
  UILMenu_FicheArt = 'menu - gérer les produits -gestion articles- FICHES ARTICLES';
  UILMenu_ConsoDiv = 'menu - gérer les produits -gestion articles- CONSO DIVERSES';
  UILMenu_TarifVente = 'menu - gérer les produits -gestion articles- TARIFS VENTES/MAG';
  UILMenu_EtikDiff = 'menu - gérer les produits -gestion articles- ETIQUETTES DIFFER';
  UILMenu_EtatStock = 'menu - gérer les produits -analyse du stock- ETAT STOCK';
  UILMenu_EtatStockDate = 'menu - gérer les produits -analyse du stock- ETAT STOCK A DATE';
  UILMenu_EtatStockDetail = 'menu - gérer les produits -analyse du stock- ETAT STOCK DETAILLE';
  UILMenu_ListArtRef = 'menu - gérer les produits -analyse du stock- LISTE ARTICLES REF.';
  UILMenu_ListArtRefDetail = 'menu - gérer les produits -analyse du stock- LISTE DET. ART. REF';
  //    UILMenu_ListCtlg = 'menu - gérer les produits -analyse du stock- LISTE DU CATALOGUE';
  UILMenu_Recept = 'menu - gérer les produits - RECEPTION';
  UILMenu_TrsfMM = 'menu - gérer les produits - TRANSFERT INTER-MAGASINS';
  UILMenu_Inventaire = 'menu - gérer les produits - INVENTAIRE';
  UILMenu_Clt = 'menu - gérer la relation client - CLIENTS';
  UILMenu_Devis = 'menu - vendre - gestion du négoce - DEVIS';
  UILMenu_Livraison = 'menu - vendre - gestion du négoce - BONS DE LIVRAISON';
  UILMenu_Facture = 'menu - vendre - gestion du négoce - FACTURE';
  //    UILMenu_OrgEtps = 'menu - paramétrage - général - ORGANISATION DE L''ENTREPRISE';
  //    UILMenu_ParamTva = 'menu - paramétrage - général - TVA - TYPE COMPTABLE';
  //    UILMenu_ParamCompta = 'menu - paramétrage - général - Comptabilité';
  //    UILMenu_ParamExeComm = 'menu - paramétrage - général - EXERCICE COMMERCIAUX';
  //    UILMenu_ParamEtik = 'menu - paramétrage - général - ETIQUETTE';
  //    UILMenu_ParamNK = 'menu - paramétrage - gérer les produits - NOMENCLATURE';
  //    UILMenu_GrilleTaille = 'menu - paramétrage - gérer les produits - GRILLES DE TAILLES';
  //    UILMenu_ParamGenre = 'menu - paramétrage - gérer les produits - GENRES, GROUPES';
  //    UILMenu_ParamCF = 'menu - paramétrage - gérer la rel. client - PARAM FIDELISATION';
  //    UILMenu_ParamEncaiss = 'menu - paramétrage - vendre - MODE D''ENCAISSEMENT, COFFRE';
  //    UILMenu_EditNegoce = 'menu - paramétrage - vendre - REGL. EDITIONS DANS LE NEGOCE';
  //    UILMenu_PersoBarreOutil = 'menu - paramétrage - gestion utilisateurs - PERSO BARRE D''OUTIL';
  UILMenu_DroitUtil = 'menu - paramétrage - GESTION DES UTILISATEURS';
  UILMenu_AnalyseDetaillee = 'menu - gérer les produits -analyse du stock- ANALYSE DETAILLEE'; // @@ Bruno 20/06/2002
  UILMenu_RecapRecep = 'menu - gérer les produits - Récap. Réceptions par Fournisseur';
  //    UILclient_CarteBleu = 'Client-Location, Visu/Modif Numéro Carte Crédit';
  UILMenu_ImpEtiquetteFicheArt = 'menu - gérer les produits -gestion articles- Impression étiq.';
  UILMenu_ImpEtiquetteRecep = 'menu - gérer les produits - RECEPTION - Impression étiq.';

  //--------------------------------------------------------------------------------
  // Module et permission carte cadeau
  //--------------------------------------------------------------------------------
  UILModuleCRDSVS = 'CARTECADEAUSVS';
  UILMenuParamCRDSVS = 'menu - paramétrage - Carte cadeau SVS';
  UILCaisseCRDSVS = 'caisse - Achat/vente Carte cadeau SVS';

  //--------------------------------------------------------------------------------
  // Module et permission UCPA
  //--------------------------------------------------------------------------------
  UILModuleUCPA= 'UCPA';

  //--------------------------------------------------------------------------------
  // Module et permission Interclub
  //--------------------------------------------------------------------------------
  UILModuleInterclub = 'INTERFACE INTERCLUB';

  //Ressource string utilisé pour les boutons de la caisse
  Type00 = 'Ligne vide (Pas de fonction définie)';
  Type01 = 'Appel Client';
  Type02 = 'Suppression de la ligne courante';
  Type03 = 'Suppression du ticket en cours';
  Type04 = 'Qte +1';
  Type05 = 'Retour Article';
  Type06 = 'Acces au champ remise, qte, prix...';
  Type07 = 'Remise Article (Normale, Solde, Promo)';
  Type08 = 'Liste des pseudos articles';
  Type09 = 'Mode d''encaissement';
  Type10 = 'Mode d''encaissement Rapide';
  Type11 = 'Sous Total';
  Type12 = 'Compte Client';
  Type13 = 'Reste Du';
  Type14 = 'Bon Achat Interne';
  Type15 = 'Bon Achat Externe';
  Type16 = 'Règlement';
  Type17 = 'Versement d''avance';
  Type18 = 'Remboursement client';
  Type19 = 'Validation des modifs. De la fiche client';
  Type20 = 'Annulation des modifs. De la fiche client';
  Type21 = 'Mise en attente du client';
  Type22 = 'Appel d''un article précis';
  Type23 = 'Réédition du ticket';
  Type24 = 'Annulation d''un ancien ticket';
  Type25 = 'Correction des modes d''encaissement';
  Type26 = 'Ouverture du tiroir caisse';
  Type27 = 'Saisie d''une Dépense';
  Type28 = 'Ticket Carte fidélité';
  Type29 = 'Accès à la liste complète des boutons';
  Type30 = 'Impression d''une étiquette client';
  Type31 = 'Réajustement compte client';
  Type32 = 'Transfert caisse -> Bon de livraison';
  type33 = 'Liste des produits en location';
  type34 = 'Echanges';
  type35 = 'Retour';
  type36 = 'Retour Total';
  type37 = 'Retour à la voléé';
  type38 = 'Détail du produit';
  type39 = 'Suppression de la location courante';
  type40 = 'Abandon de la location';
  type41 = 'Acces à la fiche principale du client';
  type42 = 'Acces à la fiche divers du client';
  type43 = 'Acces à la fiche station du client';
  type44 = 'Classement des clients sur Bon de loacation';
  type45 = 'Mode training';
  Type46 = 'Rapport du mode Training';
  type47 = 'Impression directe du devis';
  type48 = 'Validation du ticket';
  type49 = 'Choix du Skiman';
  Type50 = 'Modification globale ou partielle d''un bon de location';
  type51 = 'Suppléments pour la location';
  Type52 = 'Paiement à la ligne d''une facture de location';
  type53 = 'Impression du détail du compte client';
  type54 = 'Impression d''un document de location de contrôle';
  type55 = 'Vente d''un article du parc location';
  Type56 = 'Caution';
  type57 = 'Bon de réservation';
  type58 = 'Détaxe';
  type59 = 'Remboursement de la TVA';
  type60 = 'Vider un portable de saisie';
  type61 = 'Chèques cadeaux';
  Type62 = 'Fiche client WEB';
  type63 = 'Bons d''achat divers';
  type64 = 'Détection des lots';
  Type65 = 'Trace Be Collect''or';
  Type66 = 'Dépôt Vente';
  Type67 = 'Scann Identité + Photo du document';
  Type68 = 'Scann Idendité';
  Type69 = 'Scann photo du document';
  Type70 = 'Visu photo du document';
  Type71 = 'FidMontagne';  
  Type72 = 'Solde FidMontagne';
  Type73 = 'Règlement facture';
  Type74 = 'Affectation d''un matériel identifié à la place d''un pseudo';
  Type75 = 'Annulation d''une ligne rendu';
  Type76 = 'Carte cadeaux SVS';
  Type77 = 'Consultation Solde CC SVS';
  Type78 = 'Fidélité Intersport';
  Type79 = 'Calcul de réglage fixation';

const

  // Messages relatifs aux filiales {GesParamWebFiliales_Frm}
  RS_TXT_FilDelFilNom         = 'de la filiale :';
  RS_TXT_FilAddErrChpManquant = 'La saisie du nom de la filiale et du pays est obligatoire';

  // Message lié au module StockIT pour EKOSPORT
  RS_TXT_ConfirmStockIT = 'Le fichier sera exporté et envoyé lors de la prochaine réplication automatique';

  // Message fiche gestion groupé des modèles Frm_ExpertArt
  Crit_Titre = 'Générer une liste de modèles' + #13#10 + 'selon des critères de sélection à définir...';
  Crit_AjouterModele = 'Ajouter des modèles à la liste en cours';
  Crit_CreerStandart = 'Créer une nouvelle liste standard de modèles';
  Crit_CreerArchive = 'Créer une nouvelle liste préparatoire d''archivage';
  Crit_ErrInterAxe = 'Charger les modèles qui ne respectent pas les relations inter-axes';
  Crit_ErrNoAxe = 'Charger les modèles non positionnés sur un axe obligatoire';

  // Message d'erreur fiche client
  ErrNoVilleClient = ' La saisie d''une ville est obligatoire';
  ErrNoCPClient = ' La saisie du code postal est obligatoire';
  ErrNoPrenomClient = ' La saisie du prénom est obligatoire';
  ErrNoPaysClient = ' La saisie du pays est obligatoire';
  ErrEncoursDepasse = 'L''encours maximum autorisé est dépassé (%6.2f€)';

  //--------------------------------------------------------------------------------
  //Message pour le MDE
  //--------------------------------------------------------------------------------
  ERR_MDE_ErreurPortCOm         = 'Erreur d''ouverture du port COM';
  ERR_MDE_DelaiDepasse          = 'Délai dépassé !';
  ERR_MDE_ErreurcheckSum        = 'Erreur CheckSum !';
  ERR_MDE_ErreurDeLecture       = 'Erreur de lecture !';
  ERR_MDE_AucunFichierARecupere = 'Aucun fichier à récupérer!';

  // Analyse
  RS_TXT_ANSE_ENCOURS = 'Une statistique est déjà en cours de calcul';
  RS_TXT_ANSE_STOCKCOURANTDET = 'Etat du stock courant (Détaillé)';
  RS_TXT_ANSE_STOCKCOURANT = 'Etat du stock courant';
  RS_TXT_ANSE_HITPARADE = 'Hit parade des ventes';
  RS_TXT_ANSE_ANVENTE = 'Analyse des ventes';
  RS_TXT_ANSE_ANDETAIL = 'Analyse détaillée';
  RS_TXT_ANSE_STKDATE = 'Stock à date';
  RS_TXT_ANSE_ANASYNTH = 'Analyse synthétique';

  //Fiche article
  RS_ERR_MRKFOURN       = 'La marque choisie n''est associée à aucun fournisseur.';
  RS_TXT_NOTAXE         = 'Vous devez d''abord positionner le modèle dans les axes.';

  //Grille de taille
  RS_TXT_NOVISIBLE      = '(Non visible)';
  RS_TXT_LABAFFVISIBLE  = 'Afficher les grilles Non visible';
  RS_TXT_LABMASKVISIBLE = 'Masquer les grilles Non visible';

  //Tarif SKU
  RS_QRY_SUPPRTARIF     = 'Êtes-vous sûr de vouloir supprimer les tarifs sélectionnés ?';
  RS_TXT_CTRLSUPPRTARIF = 'Vous ne pouvez pas supprimer le tarif de base du fournisseur principal'+#13+'ni le prix de base du tarif général de vente.';
  
  //UCPA
  RS_TXT_IMPORTCLT     = 'Intégration des stagiaires: ';
  RS_ERR_IMPORTCLT     = 'Erreur lors de l''intégration des données.';
  RS_TXT_IMPORTCLTOK   = '§0 nouveaux stagiaires ont été intégrés.';
  RS_TXT_IMPORT_NotFile= 'Aucun fichier à intégrer';
  RS_TXT_IMPORTSTAGE   = 'Intégration des stages: ';
  RS_TXT_IMPORTSTAGEOK = '§0 nouveaux stages ont été intégrés.';
  RS_TXT_STAGIAIREOK   = '§0 stagiaires ont été archivés.';
  RS_TXT_STAGIAIREARCH = '§0 stagiaires archivable ont un bon de location en cours.';
  RS_TXT_RAPPORTARCH   = 'Consulter le rapport pour plus d''information: ';
  RS_TXT_ARCHSTAGIAIRE = 'Archivage des stagiaires en cours...';
  RS_ERR_ARCHSTAGIAIRE = 'Erreur lors de l''archivage des stagiaires.';
  
  //Ressource string commune
  RS_TXT_COMMON_Oui       = 'Oui';
  RS_TXT_COMMON_Non       = 'Non';
  RS_TXT_COMMON_Erreur    = 'Erreur';
  RS_TXT_COMMON_ANALYSE   = 'Analyse %s';
  RS_TXT_COMMON_WARNING   = 'Attention';
  RS_TXT_COMMON_ANAEND    = 'Analyse terminée';
  RS_TXT_COMMON_CHARGEDATA= 'Chargement des données en cours...';
  RS_TXT_COMMON_INFO      = 'Information';
  RS_TXT_COMMON_REPLICERR = 'Réplication en cours ! Opération actuelle impossible, veuillez retenter plus tard';
  
  //Client My Twinner
  RS_TXT_TWINNER_CLT = 'Client My Twinner';

  // Contrôle cham3s
  RS_ERR_FICHART_NOTARTWEB  = 'Impossible d''activer ce modèle.';
  RS_ERR_FICHART_NOTMRKWEB  = 'La marque n''est pas référencée web.';
  RS_ERR_FICHART_NOTPREVTE2 = '(Voir Paramétrage\Paramétrage Web vente\Divers)';

  //Negoce facture
  CestDejaUnAvoir = 'Impossible la facture en cours est une facture d''avoir';
  PasDAvoirSiTransIM = 'Facture liée à un transfert intermag. Création d''avoir impossible !';

  //Reservation loc web
  LibIntegResaWeb = 'Voulez vous lancer le traitement d''intégrations des réservations web ?';
  LibErrImpEtiq   = 'Impossible d''accèder à l''imprimante.';

  // Type de document facture A4 :
  FactureA4 = 'Facture A4';
  LibRapFA4 = 'CaisseFactureA4.rtm';

  DatFidInvalide = 'Date de fidélité saisie invalide !';

  // Fiche article Modification Marque
  FichArtWarning = 'Attention';
  FicheArtChangeMrk = 'Vous allez modifer la marque du modèle, elle va être associée au fournisseur %s. Voulez vous continuer ?';

  // LG : Lecteur de carte bancaire
  RS_ERR_CAI_CaractIncorrect  = 'La chaine reçue contient des caractères incorrects.';

  RS_TXT_CMN_DOFILEINPROGRESS = 'Génération du fichier en cours, veuillez patienter...';
  RS_TXT_CMN_NODATANOFILE     = 'Il n''a y pas données correspondant à vos critères de recherche.' + #10#13 + 'Aucun fichier n''a été généré.';


  //BN Referencement sp2000
  Libsupcb = 'Suppression impossible, ce modèle est issu du référencement Sport 2000...';

  // TF
  RS_QRY_FICART_MAJTARIFCDERAL = 'Souhaitez vous mettre à jour le prix de vente dans les commandes ayant un reste à livrer ?';

  //LG - Libellé de Web de la fiche Expert article
  LibActGestArtWeb      = 'Activer la gestion Web des modèles';
  LibDesctGestArtWeb    = 'Désactiver la gestion Web des modèles';
  LibChxActArtWeb       = 'Activation/Désactivation de la gestion Web des modèles';

  //LG : Classement
  LibNotClass           = '                       Pas de classement'; //Ne pas supprimer l'espace pour l'ordre de tri

  //LG juin 2010 : Export admin fiscal
  FilterExpAdminFiscal = 'fichier administration fiscal|*.txt';

  //LG mai 2010 : Paramètre Web vente générique
  WebGenMqMag1        = 'Le magasin dont le stock doit être extrait est obligatoire.';
  WebGenExtractExit   = 'Ce magasin est déjà dans la liste d''extraction.';

  // FC Mars 2010 : Bons de rapprochement
  errDateEtNumObligatoire = 'Le numéro et la date de facture doivent être saisis';
  infoRapprochementEnCours = 'Rapprochement des lignes en cours, veuillez patienter ....';
  askRetourAutoBRapp = 'Souhaitez-vous mettre automatiquement à jour le bon de retour ?';
  infoRetourAutoBRappCree = 'Bon de retour §0 créé';
  errNoChangeFouBRapp = 'Impossible de modifier le fournisseur de ce bon de rapprochement lorsque la saisie est commencée';
  errNoChangeSocBRapp = 'Impossible de modifier la société de ce bon de rapprochement lorsque la saisie est commencée';
  errNoChangeMagBRapp = 'Impossible de modifier le magasin de ce bon de rapprochement lorsque la saisie est commencée';
  errNoChangeTitreBRapp = 'Modification impossible';
  askClotBRappEcart = 'Attention l''écart de prix entre le bon de rapprochement et les lignes rapprochées est important';
  askClotBRappEcartNo = 'Impossible de cloturer';
  askClotBRappEcartPlus = 'Voulez-vous tout de même le clôturer ?';
  infoClotBRapp = 'Le bon de rapprochement §0 a été clôturé';
  infoClotBRappDiff = 'Le bon de rapprochement §0 a été clôturé, malgré une différence de §1';
  infoClotBRappEcart = 'La clôture du bon de rapprochement §0 a été forcée, malgré un écart important de §1';
  infoNoDelRapproche = 'Impossible de supprimer une ligne rapprochée';
  infoNoRemoveBonRapproche = 'Impossible de retirer ce document du bon de rapprochement, car des lignes ont déjà été rapprochées';
  askRapprocheDocument = 'Souhaitez-vous rapprocher automatiquement les lignes de ce document ?';
  RecepRapproche = 'Rapprochée';
  infoBRappChronoNonTrouve = 'Bon de rapprochement inexistant';

  RcptAssocierCollection = 'Tous les modèles de la réception sont associés à la collection choisie ! ';
  BcdeAssocierCollection = 'Tous les modèles de la commande sont associés à la collection choisie ! ' ;
  errNoModifEnc ='Impossible de modifier ce type d''encaissement';
  errNoAnnuleBp = 'Vous n''êtes pas autorisé à annuler un bon de préparation.';

  ErrTitreTropDeBLPourUneFacture = 'Trop de BL pour une facture';
  ErrTropDeBLPourUneFacture = 'Trop de BL(%s) pour une seule facture pour %s ; max = %s';

  ErrRefManquante = 'La saisie de la référence du modèle est obligatoire';

  ChangeAxes = 'Confirmez le déplacement des modèles listés dans les axes sélectionnés';
  ActionAxes = 'Modèles placés dans la sous famille §0 pour l''axe §1';
  ActionAxesNonTraite = 'Modèle non modifié car dans un domaine d''activité différent';
  ActionAxesNonModifi = 'Modèle non modifié pour l''axe §0';
  ActionAxesDel = 'Axe §0 supprimé pour ce modèle';

  ActionAxePasChoisi = 'Vous n''avez pas choisi de positionnement pour l''axe §0.' + #13 + #10 +
                       'Souhaitez vous supprimer le positionnement des modèles dans cet axe ?';

  ActionAxePasChoisiPlus = 'Oui : Supprime cet axe pour les modèles choisis'  + #13 + #10 +
                           'Non : Le positionnement actuel dans cet axe sera conservé';


  //lab Bon Preparation
  errNoForcer = 'Vous n''êtes pas autorisé à forcer le contrôle';
  errNoBPExpeTermine = 'Veuillez completer les numéros de colis et réaliser les transmissions manquantes';
  errNoParamColis = 'Veuillez renseigner tous les champs';
  errNoBPNbColis = 'Veuillez indiquer le nombre de colis';
  errNoPoidsTotal = 'Veuillez indiquer le poids total';
  errNoGenerationFacture = 'Attention, la facture n''a pas été émise';
  errNoImprimante = 'L''imprimante paramétrée pour l''impression des bons de préparation ' + #13#10 + '( §0 ) n''est pas disponible';
  errNoExpeAction = 'Impossible d''expédier tant que le bon de préparation n''est pas controlé';
  errNoSupAction = 'Vous ne pouvez supprimer une action achevée';
  errNoControleAction = 'Impossible de contrôler tant qu''il reste une ou plusieurs actions à traiter';
  errNoSelect = 'Veuillez sélectionner une ou plusieurs lignes dans la liste';
  errNoAnnuleAction = 'Vous n''êtes pas autorisé à annuler une action.';
  errNoDirExiste = 'Répertoire manquant ou inexistant.';
  ErrNomFicObliger = 'Nom de fichier obligatoire';
  ErrExtNomFicObliger = 'Extention du nom du fichier obligatoire';
  ErrCodePointRetraitSoColissimo = 'Code point de retrait obligatoire pour SoColissimo Hors Domicile';
  ErrEMailObligSoColissimo = 'E-Mail obligatoire pour SoColissimo';
  ErrEMailInvalidSoColissimo = 'E-Mail invalide pour SoColissimo';
  ErrPostableInvalidSoColissimo = 'Le N° de portable doit commencer par 06 ou 07 et doit contenir 10 chiffres pour SoColissimo';
  AskRecupInfoSaisiParClient = 'Voulez-vous récupérer les informations saisies par le client ?';
  ErrAdr1Obligatoire = 'Adresse 1 obligatoire';
  ErrCPetVilleObligatoire = 'Code postal et ville obligatoire';
  ErrParamUrlInfoSaisiParClient = 'L''Url pour récupérer les informations saisies par le client n''est pas paramétré !';
  ErrPasDeCommandeWeb = 'Pas de commande Web trouvé !';
  ErrPasJoindreUrlInfoSaisiParClient = 'Impossible de joindre l''Url pour récupérer les informations saisies par le client';
  ErrAuCuneInfoClientTrouvé = 'Aucune information n''a été trouvé !'; 
  ErrExecutableFidMontagne = 'Executable FidMontagne.exe non trouvé';
  
  BonPrepaNoNomImprimante = 'Veuillez paramétrer l''imprimante par défaut dans : Paramétrage bon de préparation - Impression ';

  //lab 30/12/09 Bon Preparation suite
  BpListe = 'Liste des bons de préparation';
  BpListeControle = 'Liste des bons de préparation contrôlés';
  BpListePec = 'Liste des bons de préparation pris en charge';
  BpListeATraiter = 'Liste des bons de préparation à traiter';
  BpListeColis = 'Liste des colis du bon de préparation ';

  //lab 28/12/09 Trace Becol
  CbStatTicket = 'Liste des tickets de la carte ';
  //lab 21/12/09
  BeColKo = 'La liaison avec Be collect''or est interrompue temporairement...';

  //Loc Tarif de la garantie  en fonction des groupes de tarif
  locnogt = 'Impossible, les groupes de tarif ne sont pas définis...';

  //transfert bon prépa
  MultiBLTransBP = 'Les bons de livraisons sélectionnés vont être transférés en bon de préparation';
  OkBLTransBP = 'Le bon de livraison affiché à l''écran a été transféré en bon de préparation N° ';
  KoBLTransBP = 'Le bon de livraison affiché à l''écran n''a pas été transféré en bon de préparation. Veuillez vérifier s''il n''existe pas déjà.';

  warningCreerDansMags = 'Veuillez sélectionner le ou les magasins où vous allez créer la configuration actuellement affichée.';
  warningCopyToMags = 'Veuillez sélectionner le ou les magasins où vous allez recopier la configuration actuellement affichée.';
  warningCopyToMag = 'Veuillez sélectionner le magasin dans lequel vous allez recopier la configuration actuellement affichée.';

  // FC : WebVenteAtipic
  MessErrPathExportFact = 'Le chemin d''exports des factures en PDF est inaccessible, la facture ne sera pas envoyée sur le site WEB, vous devrez le faire manuellement';

  AucunLotTrouve = 'Aucun lot trouvé correspondant à votre saisie...';
  MsgNofindLot = 'Aucun lot trouvé...' + #13#10 + 'Si vous êtes persuadé que ce lot existe' + #13#10 + 'Vérifiez qu''il ne soit pas archivé !';
  MessNoSupCouleur = 'Impossible de supprimer une couleur associée à des données';
  CapOKArchi = 'AVEC Archivés';
  CapNOArchi = 'SANS Archivés';
  //lab 01/10/09 ParamCompta
  ConfirmerAffecterTousMags = 'Êtes vous sûr de vouloir remplacer le paramétrage ' + #13#10 + 'de tous les magasins par celui affiché ?';
  ErreurParamCompta = 'Vous devez faire répliquer votre serveur, les données sont manquantes dans votre base !';
  //lab 29/09/2009
  MessActiveQuelSite = 'Activer le site WEB §0 pour ce modèle ?';
  LotMessActiveQuelSite = 'Activer le site WEB §0 pour ce lot ?';
  LotMessDeleteQuelSite = 'Supprimer le site WEB §0 pour ce lot ?';
  // Lots dans négoce
  MessLotNonCB = 'Ce lot ne peut être ajouté par un code barre, car plusieurs tailles/couleurs sont possibles';

  //Lab 1037 Web vente
  Base0 = 'Action interdite car l''identifiant de base actif est 0';
  confirmerArtNonWeb = 'Confirmez que vous ne souhaitez plus gérer ce modèle sur le WEB.' + #13#10 + 'Les paramètres WEB du modèle seront désactivés.';
  confirmerLotNonWeb = 'Confirmez que vous ne souhaitez plus gérer ce lot sur le WEB.' + #13#10 + 'Les paramètres WEB de ce lot seront désactivés.';
  ManqueMagasinWeb = 'Veuillez paramétrer le magasin qui gère le WEB';
  ManqueParamDelai = 'Veuillez paramétrer les délais de livraison Web vente';
  //lab 1056 Module et droit des bons de préparaption
  errNoModifAction = 'Vous n''êtes pas autorisé à modifier une action.';
  errNonModifiable = 'Vous ne pouvez modifier un bon de préparation dans l''état "§0"';
  titreActionImpossible = 'Action impossible';
  ModulBonPrepa = 'BON PREPARATION';

  //lab 10/08/2009
  TipartPseudoWeb = 'Pseudo Web';
  paramConnexionAdminWebVente = 'Veuillez vérifier le paramétrage de l''administration des modèles web';
  errConnexionAdminWebVente = 'Erreur lorsque de la connection au site d''administration des modèles web';
  connexionImpossible = 'Connexion impossible';
  // FC : 27/07/2009
  MessDeleteWebSsfSec = 'Supprimer la sous-famille WEB §0 pour ce modèle ?';
  MessDeleteQuelSite = 'Supprimer le site WEB §0 pour ce modèle ?';
  MessSiteDejaActif = 'Le site WEB §0 est déjà actif pour ce modèle depuis le §1 ?';
  MessSiteReActive = 'Le site WEB §0 a été réactivé pour ce modèle.';
  MessDeleteWebSsfSecLot = 'Supprimer la sous-famille WEB §0 pour ce lot ?';
  MessDeleteQuelSiteLot = 'Supprimer le site WEB §0 pour ce lot ?';
  MessSiteDejaActifLot = 'Le site WEB §0 est déjà actif pour ce lot depuis le §1 ?';
  MessSiteReActiveLot = 'Le site WEB §0 a été réactivé pour ce lot.';

  LotDateLib = 'Liste des lots du §0 au §1  -  ';
  MessChargeLot = 'Chargement de la liste des lots...';
  LotTrouve = 'Attention, un ou plusieurs lots ont été détectés automatiquement.' + #13#10 + 'Le Total à payer a été réactualisé !';
  warningCopyMag = 'Attention, vous allez recopier le paramétrage d''un magasin dans la fenêtre ci-dessous.' + #13#10 + 'Sélectionnez maintenant le magasin qui servira de modèle.';
  LotNonDetecte = 'Pas de lot détecté pour ce ticket...';
  LotNonTrouve = 'Impossible, ce code Lot est inexistant...';
  LotNonValide = 'Impossible, ce code Lot n''est plus valide...';
  LotNonValideTC = 'Impossible, ce code Lot n''est pas utilisable avec un code barre...' + #13#10 + '(multiple Tailles/Couleurs)...';
  LotClassementNoDelete = 'Impossible de supprimer.'+#13#10+'Ce classement est attribué à au moins un lot !';
  ManqueLibelle = 'Veuillez renseigner le libellé du lot pour le ticket.';
  ManqueDesignation = 'Veuillez renseigner la désignation du lot.';
  NegFacLettrageNoModif = 'Le compte client associé à cette facture est lettré, la modification est désactivée.';
  NEG_ERR_FacRegleeNoModif = 'Cette facture est réglée, la modification est désactivée.';
  NEG_TXT_ModifImpossible = 'Modification impossible';

  BcdeMessageUC = 'Attention la quantité commandée n''est pas compatible avec l''unité de conditionnement (§0)';

  ErrCodeVide = 'Le code est obligatoire.';
  ErrDoublonTva = 'Ce code est déjà attribué à un taux de TVA identique.' + #13#10 + 'Veuillez saisir un code unique pour ce taux.';
  strRedemarrer = 'Veuillez redémarrer les applications GINKOIA ' + #13 + #10 + 'pour que les modifications soient prises en compte par celles-ci.';
  //message tout paramétrage
  modifParam = 'Les paramètres ont été changés.' + #13#10 + 'Voulez vous enregistrer ces modifications ?';
  //Messages paramétrage Sms
  errSms = 'Impossible d' + #39 + 'envoyer le SMS : ';
  ErrParamCptSms = 'Tous les paramètres du compte doivent être renseignés';
  ErrNoTelPort = 'Impossible d''envoyer un sms, numéro de portable du client inéxistant';

  OPNCom = 'Pas de port COM valide...';
  OPNLiaison = 'Pas de liason valide avec l''OPN-2001...';
  OPNVide = 'L''OPN ne contient pas de code barre...';

  // FC : 15/01/09
  StrMajAdrClient = 'L''adresse §0 à changé.' + #10#13 + 'Souhaitez vous mettre à jour l''adresse §1 du client ?';

  //lab 30/12/08
  cstIndiceVente = 'Indice de vente';
  //lab 09/11/08 Droit associer usr/mag
  recupererParamDroitAssocier = 'Vous devez répliquer : il vous manque des paramètres liés à votre version.';
  //lab 09/11/08 Droit associer usr/mag
  noDroitAssocier = 'Vous n''avez pas le droit d''association des utilisateurs aux magasins.' + #13#10 + 'Il est attribué à : ';
  //lab 09/11/08 Droit associer usr/mag
  attribuerDroitAssocier = 'Le droit d''association des utilisateurs aux magasins n''est pas attribué. Veuillez ouvrir la fenêtre de gestion du droit pour le configurer.';
  //lab 18/11/08 Filtre pseudo client
  clientPseudo = 'Impossible de créer ce document pour un magasin appartenant à la plateforme';
  //LAB 03/11/08 Visibilité éléments dans la nomenclature
  LabOCInactive = '( Peut être masqué car ne référence aucune OC active )';
  LabOCActive = 'Ne peut être masqué car référence au moins une OC active.';

  //LAB 15/07/08 FidNatTwinner Code barre Inexistant sur base nationale
  CbFidNatTwinnerInexistant = 'Le code barre n''existe pas sur la base nationale.';

  // FC : 07/10/2008 Bons de commande : message d'information
  StrChangerDateLivraisonPlus = 'Veuillez indiquer le nombre de jours à ajouter à aux dates de livraison';
  StrChangerDateLivraisonMoins = 'Veuillez indiquer le nombre de jours à retirer à aux dates de livraison';

  // FC : 07/10/2008 ajout d'un controle si la marque est déjà distribuée par un autre fournisseur
  // dans ce cas, on affiche un message qui contient le(s) fournisseur(s) déjà associés
  StrMarqueDejaDistribuee = 'Attention, cette marque est déjà distribuée par le(s) fournisseur(s) suivant(s)';

  //Fidélité Nationale Twinner
  CodeBarreFidNatTwinner = '29';

  // Stat OC
  StrImprimeStatOC = ' §0 ( Oération commerciale §1 )';

  // Analyse fidelité
  StrImprimeAnalyseFideliteJusquAu = 'Analyse fidélité jusqu''au §0, Groupe Client : §1, Groupe Fidélité : §2';
  StrImprimeAnalyseFideliteDuAu = 'Analyse fidélité du §0 au §1, Groupe Client : §2, Groupe Fidélité : §3';

  BAO_pasmen = 'Attention, le paramétrage des bons d''achats automatiques' +
    #10#13 + 'est incomplet...' +
    #10#13 +
    '(Paramétrage général/Bons d''achat/Onglet Mode encaissement)';
  BAO_DejaUtilTck = 'Ce bon d''achat a déjà été enregistré pour ce ticket...';
  BAO_PrisEnCompte = 'Le bon d''achat de §0 € est pris en compte.' + #10 + #13 + '(Onglet Encaissement)';
  BAO_PasValide = 'Ce bon d''achat n''est plus valide...';
  BAO_PasEncoreValide = 'Ce bon d''achat sera utilisable à partir du : ';
  BAO_DejaUtil = 'Ce bon d''achat est déjà utilisé...';
  BAO_Inexistant = 'Le bon d''achat est inexistant...';
  PasFicheWeb = '(La fiche client n''est pas accessible via Internet)';
  pasbonatelier = 'Le bon atelier SAV--' + '§0' + ' n''est pas transférable en caisse...';

  Ideal_RAZ = 'Confirmez vous la suppression de toutes les quantités pour ce modèle ?';
  Ideal_Init = 'Confirmez vous l''initialisation pour toutes les couleurs/tailles ?' + #10 + #13 +
    '(Quantité :"§0")';

  clipasbongroupe = 'Impossible, ce client n'' appartient pas à votre groupe de magasin...';
  fidboxpasmelange = 'Impossible, pas de cumul de bons en % et montant...';
  fidboxunseulpc = 'Impossible, un seul bon en pourcentage autorisé par ticket...';
  FIBDOXDEJAUTIL = 'Impossible, vous avez déjà utilisé ce bon dans le ticket...';
  FidboxPasCB = 'Impossible, votre client n''a pas un numéro de carte valide...';

  AtelierPasFiche = 'Impossible, la fiche atelier est inexistante...';
  AtelierPasBonEtat = 'Impossible, cette fiche n''est pas transférable en caisse';
  AtelierDejaCaisse = 'Impossible, cette fiche est déjà transférée en caisse';

  rappelAtelier = 'Souhaitez-vous transférer la fiche atelier en caisse?';
  ImpCC = 'Impression du chèque cadeau?';
  FBManquecorres = 'Attention la correspondance des modes d''encaissement'#10#13'pour la FIDBOX est imcompléte.'#10#13'(Ginkoia / Paramétrage général / Modes d''encaissement)';
  FBManqueparam = 'Attention les paramètres pour utiliser la FIDBOX sont incomplets...';
  FBNumeroutilise = 'Ce numéro de caisse est déjà attribué...';
  LibArrondiGinkoia = 'Gestion des arrondis pour les prix de vente';
  catInt_Sortie = 'Vous avez sélectionné des articles : Sortir sans valider ?';
  catInt_Avert = 'Vous avez sélectionné des articles : Annuler cette sélection ?';
  CatInt_Recup = 'Patienter pendant la récupération du catalogue ...';
  RefRech_IntMult = 'Intégration de vos articles...';

  UniquePasPoss2 = 'Impossible un autre mode de paiement est déja utilisé pour gérer la carte fidélité';

  LocEnCours = 'Attention, votre client à des locations en cours...';
  PasMultiSelTOC = 'Pour ce choix d''impression vous devez sélectionner une seule ligne...';
  EtktocTer = 'Vous pouvez maintenant choisir les étiquette TOC à imprimer...';

  PasBonCBCF = 'Impossible, ce code barre est déjà utilisé...';
  RefRech_ArtProbTaille = 'Le modèle ne possède pas de taille définie.'#10#13'Il ne peut donc pas être enregistré par l''application Ginkoia';
  RefRech_ArtProbCouleur = 'Le modèle ne possède pas de couleur définie.'#10#13'Il ne peut donc pas être enregistré par l''application Ginkoia';
  CF2000OCliCours = 'Impossible d''utiliser cette carte fidélité, vous avez déjà un client en cours';
  VOdejaVendu = 'Impossible, article déjà vendu dans le même ticket...';
  ClientArchiver = 'Attention, ce client était archivé, il est réactivé automatiquement' + #10#13 + 'mais pensez à vérifier sa fiche...';
  RefRech_Confirmation = 'Voulez-vous rechercher sur le site de votre centrale';
  RefRech_InitMrq = 'Initialisation des marques référencées en cours...';
  LocDejaEnLocPicco = 'Attention cet article est en attente de location dans le Piccolink...';
  InitOc = 'Attention, cette initialisation necessitera un nouveau paramètrage'#10#13'des offres commerciales.'#10#13'Souhaitez vous continuer le traitement?';
  PasCreditClient = 'Fonction Impossible, le bouton lié au paiement "Comptes clients" a été supprimé...';
  ModulSP2000 = 'IMPORT SP2000';
  ModulCollection = 'REF. COLLECTION';
  ModulRef = 'REFERENCEMENT';
  LocAutreMag = 'Impossible, cet article appartient à un bon de location d''un autre magasin...';
  ModulWebDyna = 'REFERENCEMENT DYNAMIQUE';
  RefRech_Conn = 'Connexion au site central';
  RefRech_AdhNok = 'Votre code d''adérent n''est pas valide';
  RefRech_ArtDjRec = 'Le modèle à déjà été récupéré par %s ' + #10#13 +
    'Vous devez répliquer pour y avoir accés';
  RefRech_ArtNonTrv = 'La référence demandée n''existe pas dans cette marque...'#10#13'(Dans la base de la centrale)';
  RefRech_Analys = 'Analyse et intégration de la fiche';
  RefRech_PrbRep = 'Votre réplication n''est pas à jour, recommencer après avoir répliqué';
  RefRech_PrbCrit = 'Problème d''intégration critique, veuillez prévenir la société GINKOIA';
  RefRech_PrbInt = 'Impossible de ce connecter au site central,'#10#13'Vérifier votre accés internet';

  RESOURCESTRING


  AmortlocConfSup = 'Confirmez-vous la suppression de l''opération sélectionnée?';
  Amortlottypevide = 'La saisie d''un type (Entrée/Sortie) est obligatoire...';
  Amortlotdatevide = 'La saisie d''une date est obligatoire...';
  AmortlotMotifvide = 'La saisie d''un motif est obligatoire...';
  AmortLotQteVide = 'La saisie d''une quantité est obligatoire...';

  RemiseLoc = 'caisse - location - SAISE D''UNE REMISE SUR LE TOTAL GENERAL';
  AnnulTckLocPasPossible = ' Il est impossible d''annuler un ticket lié à une facture de location...';

  ModulWebVente = 'WEB VENTE';

  EltronAnnul = 'Confirmez-vous l''arrêt de l''impression des étiquettes?';
  EltronEnCours = 'Impression des étiquettes en cours...';
  InitEltron = 'Initialisation de l''imprimante en cours...';
  msgATT = 'Attention : ces modifications ne seront enregistrées qu''à la validation finale de la fiche fournisseur !';

  HintExpertville = '[Double Clic ou F4] Ouvre l''expert de gestion des villes';

  ChargeVilles = 'Mise en place de l''expert de gestion des villes';
  msgVillePasPays = 'Vous n''avez pas défini de pays pour cette ville' + #13#10 +
    'Faut-il néanmoins accepter d''enregistrer ?';
  msgVillePasCP = 'Vous n''avez pas défini de code Postal pour cette ville' + #13#10 +
    'Faut-il néanmoins accepter d''enregistrer ?';
  msgNomVilleOblig = 'Impossible de valider' + #13#10 +
    'Il faut donner un nom à cette ville...';

  msgNoVille = 'Une ville sans nom significatif ne peut pas être sélectionnée ...';

  msgDoublonVilleetCp = 'Impossible de valider :' + #13#10 + '§0 §1 §2' + #13#10 +
    'Cette ville existe déjà dans votre fichier... ';
  msgDoublonVille = '§0 §1' + #13#10 +
    'Cette ville existe déjà !' + #13#10 +
    'Faut-il accepter le "doublon" ?';
  msgDoublonCP = '§0 §1' + #13#10 +
    'Ce code postal existe déjà !' + #13#10 +
    'Faut-il accepter le "doublon" ?';
  msgSupprVille = '§0 §1 §2' + #13#10 +
    'Confirmez la suppression de cette ville... ';

  MsgSupFSLoc = 'Confirmez que vous désirez que la sous-fiche sélectionnée' + #13#10 + '§0' + #13#10 +
    'ne soit plus associée à la fiche de location' + #13#10 + '§1';
  MsgSupFSLocPlus = 'La sous fiche ne sera pas supprimée mais deviendra "orpheline"...' + #13#10 +
    '( c''est à dire dire une sous-fiche sans fiche principale )';
  MsgModifstatLoc = 'Attention, vous avez modifié le statut et/ou la date de cession.' + #13#10 +
    'Que souhaitez vous faire avec la ou les sous-fiches associées ?';
  MsgArchsfLoc = 'Attention, vous avez archivé la fiche en cours.' + #13#10 +
    'Que souhaitez vous faire avec la ou les sous-fiches associées ?';
  MsgCessFichLoc = 'Comment souhaitez vous appliquer le prix de cession ?';
  MsgQuoiFaire = 'Que souhaitez-vous faire ?...';

  MessChargeArtLoc = 'Chargement de la liste des modèles...';

  MsgConfTousEnc = 'Confirmez le prélêvement automatique de tous les encaissements arrivés à échéance ? ';
  MsgConfEnc = 'Confirmez le prélêvement des encaissements sélectionnés ? ';

  MsgNeedSess = 'Vous n''avez sélectionné aucune session de caisse';

  HintDbg = '[Double Clic ou F8] Ouvre la fiche correspondant au modèle sélectionné';
  MsgGrand = 'Plus de 20000 lignes à afficher' + #13#10 +
    'Les temps de réponse vont être très lents' + #13#10 + 'lorsque vous vous déplacerez dans cet état !' + #13#10 +
    'Voulez-vous affiner votre sélection ? (Fortement recommandé)';

  CF2000OkClt = 'La carte fidélité est prise en compte pour le ticket en cours.';
  CF2000Okba = 'Le code du bon d''achat est enregistré,' + #13 + #10 +
    'n''oubliez de le déduire du ticket ...';
  CF2000BA = 'Impossible, un seul bon d''achat par ticket...';

  HintAffChxNeo = '[F7] Afficher / Masquer la zone de sélection... ( On/Off )';

  confcopie = 'Confirmez-vous la création d''une copie de ce modèle?';
  impsupetq = 'Impossible, c''est un modèle de référence Ginkoia...';
  confsupetq = 'Confirmez-vous la suppression du modèle d''étiquette en cours?';
  valeurincorrecte = 'Impossible, valeur incorrecte...';
  NoPossToc = 'Impossible d''ajouter ce modèle dans le bloc note des opérations commerciales !...' + #13 + #10 +
    '( Nota : ce bloc note n''accepte ni les modèles archivés ni les Pseudos... )';

  Etqdeborder = 'Impossible, le champ en cours déborderait de l''étiquette...';
  EtqConfSup = 'Confirmez-vous la suppression du champ en cours?';
  EtqPasDim = 'Impossible, vous n''avez pas encore dimensionné l''étiquette...';
  PasTypeImprimante = 'Le type imprimante est obligatoire !';

  MsgOkFincompage = 'Confirmez que vous souhaitez lancer le traitement de fin de comptage ...';
  msgNoInvSessToShow = 'On ne peut supprimer que des journaux correspondant à des vidages de portable ou des imports de stock réserve ...' + #13#10 +
    'Aucun journal de ce type n''a été enregistré dans cet inventaire ...';

  msgReactualiseEtat = 'L''état affiché a besoin d''être réactualisé...' + #13#10 +
    'Son rafraîchissement peut prendre quelques secondes,' + #13#10 +
    'mais vous garantit l''exactitude des données affichées.' + #13#10 +
    'Confirmez par OUI sa réactualisation...';
  msgReactualiseEtatPlus = #13#10 + 'NB : si vous effectuez des saisies manuelles, vous pouvez activer, dans l''écran de "Saisie de l''inventaire", la mise à jour automatique de cet état.';

  MsgInvQteSaisChange = 'Les écarts de ce modèle vont être réactualisés' + #13#10 +
    'car certaines saisies n''ont pas été répercutées...' + #13#10 +
    '( Il se peut qu''après cette mise à jour cette ligne d''écart ne soit plus illustrée... )';

  MsgInvClotDate = 'La date de démarque est le §0' + #13#10 +
    'Les écarts vont être valorisés au "pump" des modèles à cette date';

  MsgEcnjRefreshOblig = 'La mise à jour automatique des écarts n''est plus possible après un vidage de portable ou l''ajout d''un stock réserve' + #13#10 +
    'Il est indispensable de réactualiser cet état';
  CapDesole = 'Désolé...';
  msgNoCBFind = 'Aucun code à barre trouvé ...' + #13#10 + 'Avez-vous bien défini le périmètre de votre inventaire ?...';
  MsgNoPHLPossible = 'Impossible de connecter le PHL ...';

  HintECNJ1 = 'Double clic charge l''article en saisie ... ( F3 pour sélectionner plusieurs articles )';
  HintECNJ2 = 'Plusieurs écarts sélectionnés, vous ne pouvez que les accepter globalement';
  MessMajECNJ = 'Mise à jour des écarts...' + #13#10 + 'Le temps de mise à jour dépend de votre sélection ...';
  MsgAcceptGroup = 'Confirmez que vous souhaitez accepter les écarts' + #13#10 + 'des §0 lignes sélectionnées...';
  msgInvDoSaisAuto = 'Confirmer que ce modèle a bien été compté' + #13#10 + '"§0" sera ajouté en saisie manuelle de ce modèle...';
  CapInvSaisManu = 'Nouvelle session de saisie';
  msgVidRecaopInv = 'Confirmez que vous souhaitez réinitialiser (vider) le récapitulatif de saisie en cours';
  MsgInvImageStock = 'Création de l''image du stock relative à cet inventaire...' + #13#10 + 'Quelques secondes de patience Merci...';

  CstSecVerif = 'Vérification du serveur de secours';
  CstSecSession = 'Attention, des sessions sont ouvertes sur le poste de secours';
  CstSecImpConnect = 'Impossible de se connecter au serveur de secours';
  CstSecOuvBase = 'Ouverture de la base de données';
  CstSecProb1 = 'Attention, la sauvegarde pour les caisses autonomes semble déconnectée'#13#10'veuillez appeler la société GINKOIA SA pour régler votre problème';
  CstSecProb2 = 'Attention, la base de secours n''est pas à jour '#13#10'veuillez appeler la société GINKOIA SA pour régler votre problème';
  CstSecProb3 = 'Attention, Impossible de se connecter à la base principale, veuillez avertir votre responsable';
  CstSecOuvSec = 'Ouverture du serveur de secours';
  resapasVAd = 'Impossible, le paramétrage du mode de paiement' + #13 + #10 + 'pour les réservations est incomplet...';
  resacreditcompte = 'Le pré-paiement est validé, souhaitez-vous maintenant' + #13 + #10 +
    'créditer le compte du client ?';
  ResaPasSession = 'Impossible, vous n''avez pas de session de caisse ouverte...';
  MsgOCConfcopie = 'Confirmez-vous la duplication de l''opération commerciale en cours ?';
  MsgOCCopie = 'Duplication de l''opération commerciale en cours...';
  MsgOCConfSupprLNT = 'Confirmez-vous la suppression des lignes non traitées ?' + #13 + #10 +
    '(Prix de vente = Prix de vente OC)';
  MsqOCSupencours = 'Suppression des lignes non traitées...';
  hintOCI = 'Créer un nouveau tarif OC';
  hintOCD = 'Supprimer le tarif en cours';
  StkOc = 'Souhaitez-vous traiter les modèles ayant un stock nul ?';
  CreaOc = 'Création d''une opération commerciale';
  Valencours = 'Validation en cours...';
  Etktoc = 'Attention, des étiquettes normales (hors TOC) sont en attente d''impression.' + #10 + #13 +
    'Vous devez donc choisir dans un premier temps le modèle d''étiquette correspondant.';
  EtktocBis = 'L''impression suivante concernera les étiquettes des opérations commerciales.' + #10#13 + 'Veuillez choisir un modèle d''étiquette correspondant aux "TOC".';
  suppicco = 'Attention, l''article' + #13 + #10 + '§0' + #13 + #10 + 'n''est pas prévu dans le pack' + #13 + #10 +
    '§1.' + #13 + #10 + #13 + #10 + 'Voulez-vous appliquer un supplément?';

  CstMessOCAvertOuvre = 'L''opération commerciale §0 est en cours'#10#13'Supprimer l''avertissement';
  CstMessOCAvertFerme = 'L''opération commerciale §0 s''est terminée'#10#13'Supprimer l''avertissement';
  CstMessOCAvertSupp = 'Cette suppression est pour tous les postes, êtes-vous sûr ?';
  //************* RV le 19/10/2004
  MsqRecomptArt = 'Confirmez le recomptage complet de cet article !' + #13#10 +
    'Tous les comptages le concernant vont être supprimés et ses données réactualisées...' + #13#10 +
    '( L''état affiché à l''écran sera obligatoirement réactualisé lui aussi )';

  //*************
  msgNoDefPeriode = 'Impossible de référencer une opération commerciale dont la période d''activation n''est pas définie !...';
  MsgNbreSupprBN = '"§0" modèles ont été enlevés du bloc note...';
  msgDesacOcKur2 = 'Désolé de cette répétition...' + #13#10 +
    'Confirmez la désactivation de l''opération commerciale affichée ...' + #13#10 + #13#10 +
    'ATTENTION cette opération commerciale est active en ce moment !';
  msgDesacOcKur = 'Confirmez la désactivation de l''opération commerciale affichée ...' + #13#10 + #13#10 +
    'ATTENTION cette opération commerciale est active en ce moment !';
  msgDesacOc = 'Confirmez la désactivation de l''opération commerciale affichée ...';

  MsgSuppressionOC = 'Suppression de l''opération commerciale en cours ... ';
  msgSupprOcKur2 = 'Désolé de cette répétition...' + #13#10 +
    'Confirmez la suppression de l''opération commerciale affichée ...' + #13#10 + #13#10 +
    'ATTENTION cette opération commerciale est active en ce moment !';
  msgSupprOcKur = 'Confirmez-vous la suppression de l''opération commerciale affichée ?' + #13#10 + #13#10 +
    'ATTENTION cette opération commerciale est active en ce moment !';
  msgSupprOc = 'Confirmez-vous la suppression de l''opération commerciale affichée ?';

  MsgOcNoSelected = 'Aucun modèle sélectionné !...';
  MsgOcNoLotSelected = 'Aucun lot sélectionné !...';
  MsgNbreSuppr = '"§0" modèles ont été enlevés de cette opération commerciale...';
  MsgLotNbreSuppr = ' %d lots ont été enlevés de cette opération commerciale...';
  MsgOCConfSuppr = 'Confirmer la suppression des lignes sélectionnées...';
  MsgMajOC = 'Traitement des modèles sélectionnés...';
  MsgMajLotOC = 'Traitement des lots sélectionnés...';
  MsgNbreOCMaj = ' "§0" modèles de l''opération commerciale ont été mises à jour !';
  MsgNbreLotOCMaj = ' %d lots de l''opération commerciale ont été mises à jour !';
  CapRemRoApplik = 'Remise à appliquer sur le prix des modèles sélectionnés';
  CapRemRoApplikLot = 'Remise à appliquer sur le prix des lots sélectionnés';
  LibRemRoApplik = 'Remise sur le prix de vente habituel affiché...';
  CapOffsetRoApplik = 'Montant à déduire sur le prix des modèles sélectionnés';
  CapOffsetRoApplikLot = 'Montant à déduire sur le prix des lots sélectionnés';
  LibOffsetRoApplik = 'Montant à déduire du prix de vente habituel affiché...';
  CapFixeRoApplik = 'Prix fixe à appliquer aux modèles sélectionnés';
  CapFixeRoApplikLot = 'Prix fixe à appliquer aux lots sélectionnés';
  MsgAjouteOnOc = '§0 modèle(s) ont été rajouté(s) au tarif';

  LibRoundOC = 'Recalcul automatique des prix de l''OC';
  msgAuncunOC = 'Aucune opération commerciale existante' + #13#13 + '( autre que celle éventuellement affichée )';
  LabNoPeriode = 'Période non définie';

  MsgExisteOnOc = 'Ce modèle est déjà référencé dans l''opération commerciale !...';
  CapTitrePeriodeOC = 'Période de l''OC';
  MsgOCConfirmPermanent = 'Confirmez que cette opération commerciale est permanente...';
  //***************
  MessChargeSelOC = ' Mise à jour de la liste des modèles de l''opération commerciale...';

  MsgLotExisteOnOc = 'Ce lot est déjà référencé dans l''opération commerciale !...';

  MsgRefreshcloture = 'Une relecture des données est impérative avant de lancer la clôture !' + #13#10 +
    'Il est indispensable de vérifier et contrôler que les conditions de clôture sont bien remplies ' +
    'et qu''aucune nouvelle modification n''a été effectuée depuis un autre poste...';

  msgArchiveInvReserve = 'Faut-il archiver cet inventaire de réserve ?...' + #13#10 +
    'Un "stock de réserve" ne sert généralement qu''une fois, il est donc logique de l''archiver après intégration dans votre inventaire classique. ' +
    'S''il ne doit plus servir, cela peut éviter de l''intégrer par erreur dans un autre inventaire...';
  msgInvSRArchiveOK = 'L''inventaire de réserve a été archivé...';
  LabInvCloture = 'Clôturé';
  LabInvArchive = 'Archivé';
  msgInvDejaMisReserve = 'Le stock réserve "§0" a déjà été ajouté à cet inventaire !';
  Capclotstkreserve = 'Clôture d''un pré-inventaire';
  msgConfCloStkReserve = 'Confirmez la clôture du pré-inventaire';
  messInvMetreserve = 'Chargement du stock réserve en cours ...';
  msgNoSykReserveDispo = 'Aucun "Stock réserve" n''est actuellement disponible' + #13#10 +
    'Pour être disponible un inventaire réserve doit être clôturé mais non archivé';
  CapInvSaisReserve = 'Intégration de stock  réserve...';
  LabCtrlEcartActif = 'MaJ écarts active';
  LabCtrlEcartInActif = 'MaJ écarts inactive';
  msgInvPlusEcart = 'Après mis à jour des données, l''écart que vous aviez sélectionné n''est plus présent dans cette liste...';

  MsgChargeEtatSais = 'Chargement de la liste des modèles saisis' + #13#10 + 'Merci de patienter quelques secondes...';
  // 2 ligne modifiée
  GenerikRefresh = 'Réactualisation des données affichées...' + #13#10 + 'Merci de patienter quelques secondes...';
  MsgInvClotIsNJ = 'Impossible de clôturer cet inventaire  !' + #13#10 +
    'Il reste des écarts qui ne sont ni "ACCEPTES" ni "JUSTIFIES"...';

  LibLisStkSaisInv = 'Etat du stock saisi';
  MsgNofindart = 'Aucun modèle trouvé...' + #13#10 + 'Si vous êtes persuadé que ce modèle existe' + #13#10 + 'Vérifiez qu''il ne soit pas archivé !';
  LibReserve = 'Pré-inventaire';
  msgInvReservOuvert = 'Pré-inventaire ouvert';
  MsgNosupprInvClot = 'Il n''est pas possible de supprimer un inventaire clôturé' + #13#10 +
    'C''est quelque part un "historique" de démarque qu''il convient de garder...';
  CapInvSupprJournal = 'Type du journal à supprimer...';

  MessChargeSelInv = 'Mise à jour du périmètre de l''inventaire...' + #13#10 + 'Le chargement peut prendre quelques secondes si le périmètre défini est large...';

  MsgConfSupInvSais = 'Des saisies ont déjà été enregistrées dans cet inventaire...' + #13#10 +
    'Etes-vous sûr de vouloir le supprimer ?...' + #13#10 +
    'Attention : cette suppression est irréversible...';

  MsgConfSupInvOuvert = 'Cet inventaire à été ouvert...' + #13#10 +
    'Confirmez-vous cependant sa suppression ?...' + #13#10 +
    'Attention : cette suppression est irréversible...';
  MsgConfSupInvPerim = 'Vous avez déjà défini le périmètre de cet inventaire...' + #13#10 +
    'Confirmez-vous cependant sa suppression ?...' + #13#10 +
    'Attention : cette suppression est irréversible...';

  MsgConfSupInv = 'Confirmez la suppression de l''inventaire affiché à l''écran ....' + #13#10 +
    'Attention : cette suppression est irréversible...';
  MsgInvErrSuppr = 'Problème lors de la suppression de l''inventaire...';
  MsgInvOkSuppr = 'L''inventaire a bien été supprimé';
  LIbInvEdValo = 'Edition Valorisée des écarts';
  MsgInvClot2 = 'Confirmez la clôture de cet inventaire' + #13#10 +
    'LA DATE DE DEMARQUE EST BIEN LE §0';
  MsgInvClot1 = 'Confirmez la clôture de cet inventaire' + #13#10 +
    'Date de démarque : §0' + #13#10 +
    'La clôture de l''inventaire ne touche que le stock des modèles ayant une démarque "ACCEPTEE"';

  LibInvAcc = 'L''écart à accepter sera automatiquement calculé';
  LibInvJust = 'L''écart à justifier sera automatiquement calculé';
  HintInv2Clics = '[Double Clic] Sur une ligne modèle ouvre la fiche de ce modèle';
  MsgInvNoGoodEC = 'Vous devez saisir un écart de stock final différent de celui en cours...';
  MsgMajEcarts = 'Mise à jour des écarts d''inventaire...';
  CapInvAccept = 'Gestion d''un écart accepté';
  CapInvJustif = 'Gestion d''un écart justifié';
  CapInvVisu = 'Détail des écarts';
  MsgJustifOblig = 'La saisie du motif de justification est obligatoire...';
  MsgInvDoCloture = 'Confirmez le chargement' + #13#10 + 'des données de clôture de l''inventaire ...';
  MsgAfficherNJ = 'Confirmez le chargement' + #13#10 + 'des listes de gestion des écarts...';
  MasgChargeTCNC = 'Confirmez le chargement' + #13#10 + 'de la liste complète des Tailles/Couleurs non comptées...';
  MsgAfficherNC = 'Confirmez le chargement' + #13#10 + 'de la liste complète des modèles non comptés...';
  MsgAfficherPerim = 'Confirmez le chargement' + #13#10 + 'de la liste des modèles à inventorier...';
  MsgChargeNonComptes = 'Chargement en cours...' + #13#10 + 'Le chargement peut prendre quelques secondes si de nombreux modèles n''ont pas été comptés...';

  //-***********
  ConsoDivDuree = 'La validation du transfert est impossible sans durée d''amortissement...';
  CstPasDroitModule = 'Votre version ne contient pas ce module.'#10#13'Veuillez contacter le service commercial de GINKOIA SA pour plus d''informations';

  CstPatienCaisse = 'Veuillez patienter pendant l''initialisation et l''ouverture de la caisse';
  CstVilleCPDif = 'Une ville de ce nom existe avec un autre code postal : création';
  CstVillCPNone = 'Création de la ville sans code postal ';
  CstCpVilleNone = 'Création du code postal sans nom de ville';
  CstCltMemeRS = 'Attention, un client de même raison sociale existe déjà';
  CstCltMemeNom = 'Attention, un client de même nom existe déjà';

  DureeVoDepassee = 'La durée réelle de location est supérieure' + #13 + #10 + 'à la durée prévue par le voucher.' + #13 + #10 +
    'Souhaitez-vous appliquer un supplément?';
  CstMessLocArtSuppHisto = 'Attention, ce type de modification n''est pas reportée sur les sous fiches associées'#13#10 +
    'Si vous le désirez-vous pouvez reporter manuellement cette modification';
  PasPays = 'Attention, le pays n''est pas renseigné dans votre fiche magasin.' + #13 + #10 +
    'Les adresses des nouveaux clients risquent d''être incomplètes...';
  LibJFullInv = 'Journal de saisie complet';

  MessChargeFull = 'Chargement du journal...';
  MsgSupprNoPossSessOpen = 'Suppression impossible car cette session est ouverte dans l''onglet de saisie';
  MsgSessErrSuppr = 'Le journal de saisie n''a pas pu être supprimé...';
  MsgSessokSuppr = 'Journal de saisie supprimé !';
  MsgInvSupprSess = 'Confirmez la suppression de : §0' + #13#10 +
    'N° : §1 Zone : §2  Utilisateur : §3  Titre : §4' + #13#10#13#10 +
    'ATTENTION : Cette suppression est IRREVERSIBLE !' + #13#10 +
    '(Toute erreur de votre part vous obligera à refaire le travail)';
  MsgInvSupprSess2 = 'Confirmez la suppression de : §0' + #13#10 +
    'N° : §1 Zone : §2  Utilisateur : §3  Titre : §4' + #13#10 +
    'ATTENTION : Cette suppression est IRREVERSIBLE !' + #13#10#13#10 +
    '(Désolé mais une double confirmation est nécessaire...)';

  LibInvSessVidPortable = 'Session de saisie portable';
  LibInvSessReserve = 'Rajout de stock réserve';
  CapInvSupprJrnl = 'Suppression d''un journal de saisie';
  CapInvChxJournal = 'Type de journal de saisie à afficher...';
  MessEnregToutHP = 'Validation des quantités de tous les modèles notés "Hors Périmètre"...';
  CapHorsperim = 'Saisies hors périmètre de l''inventaire';
  MsgInvRajouteToutHP = 'Confirmez que toutes les quantités saisies pour les modèles de cette liste doivent bien être inventoriées...';
  MsgInvRajouteaRThp = 'Confirmez que les quantités saisies pour le modèle' + #13#10 + 'Chrono : §0' + #13#10 + '§1' + #13#10 + 'Doivent bien être inventoriées...';
  MsgConfCtrlVP = 'Confirmez que vous avez bien contrôlé et noté les erreurs de saisie correspondants à cette session de saisie !';
  MsgInvMankComent = 'La saisie du commentaire est obligatoire';
  InvLabNPE = '§0  Saisies hors périmètre';
  InvLabNRC = '§0  Saisies non reconnues';

  InvPbCauseCB = 'Code-barres non reconnu';
  InvPbCausePerim = 'Hors périmètre';
  InvPbCauseArchive = 'Modèle archivé';
  InvPbCausePalette = 'problème importation palette';

  MsgInvMankZone = 'La saisie du N° de zone est obligatoire !' + #13#10 +
    '( Le N° de zone doit être impérativement différent de "0" )';
  CapInvStkKour = 'Stock courant du modèle ( tient compte de TOUS les mouvements enregistrés )';
  CapInvSaisPortable = 'Vidage de portable...';
  //***

  LocPasPseudoBis = 'Pour un échange pseudo, vous devez vous positionner sur la ligne' + #13 + #10 + 'de l''article avant d''activer la fonction échange...';
  locPasPseudoVide = 'Pas d''échange avec les pseudos articles' + #13 + #10 + 'si le bon de location du client n''est pas chargé...';
  locPasPseudo = 'Pas d''échange avec les pseudos articles.';

  CstArtLocLMessEtatActuArt = 'Cette ligne correspond à l''état actuel de votre article et ne peut donc être supprimée';
  CstArtLocLMessConfSupHistTit = '  Suppression d''un historique';
  CstArtLocLMessConfSupHistMess = 'Etes-vous sûr de vouloir supprimer cette ligne d''historique';
  MsgChargePhl = 'Confirmez le chargement du PHL ?...';
  msgMin100Art = 'Le périmètre de votre inventaire contient moins de 100 références...' + #13#10 +
    'Faut-il continuer et ouvrir cet inventaire ?';
  msgPhlNoArtPerim = 'Le périmètre de l''inventaire est vide...';
  MsgNoErrVPInv = 'Tous les articles "bipés" sont corrects et ont pu être inventoriés !' + #13#10 + #13#10 +
    'Voulez-vous néanmoins voir le récapitulatif de saisie ?';

  InvSaisieVide = 'Vous n''avez saisi aucune quantité à inventorier...';
  MsgAjouArtPerim = 'Le modèle code chrono "§0"' + #13#10 + '§1' + #13#10 +
    'ne fait pas partie du périmètre de votre inventaire...' + #13#10 +
    'Faut-il l''accepter et l''ajouter au périmètre ?';

  CstErrDLL = 'Initialisation du portable impossible...' + #13#10 +
    '( la DLL "MDECOM32.dll" est introuvable... )';

  msgInvPerimOuvert = 'L''inventaire tournant est ouvert !' + #13#10'Vous pouvez rajouter des modèles au périmètre à inventorier mais afin d''éviter les malentendus vous ne pouvez pas en retirer...';
  msgInvOuvert = 'L''inventaire complet du magasin est ouvert !';

  msgInvVerifNbCbAjout = '"§0" modèles ont été rajoutés au périmètre de l''inventaire' + #13#10 +
    'Vérification de la possibilité de charger les PHL...' + #13#10 +
    'Merci de votre patience...';

  MsgInvNoRajout = 'Aucun modèle n''a été rajouté au périmètre de l''inventaire...' + #13#10 +
    '(Soit aucun n''a été trouvé soit ils étaient tous déjà pris en compte)';
  msgTestRapid = 'Vidage terminé' + #13#10'"§0 Bipages" d''étiquettes ont été enregistrés';

  msgInvVerifNbCb = 'Vérification de la possibilité de charger les PHL...' + #13#10 +
    'Cela peut prendre jusqu''à 2 à 3 minutes... Merci de votre patience !';
  msgPhlNoPossible = 'Le chargement des PHL n''est plus possible !' + #13#10 + 'Le nombre de codes à barres à gérer dépasse la capacité des PHL';
  msgPhlIsPossible = 'Le chargement des PHL est désormais possible !' + #13#10 + 'Le nombre de codes à barres à gérer ne dépasse plus la capacité des PHL';
  MsgInvArtExists = 'Ce modèle était déjà référencé dans le périmètre de l''inventaire...';
  msgPerimParPortable = '"§0" modèles enregistrés sur le portable ont été rajoutés au périmètre de l''inventaire';
  MsgInvNoValidart = 'Ce modèle ne peut pas être inventorié !' + #13#10 + 'Il s''agit soit d''un modèle archivé soit d''un PSEUDO';
  MessDeleteSelInv = 'Suppression du périmètre de l''inventaire des modèles sélectionnés...';
  msgSupPerim = 'Confirmez la suppression de(s) "§0" modèle(s) sélectionné(s)';
  CapYes = '&Oui';
  CapNo = '&Non';
  CapMerci = 'Merci de votre patience';

  HintOkDef = '[ Entrée ] Valider par défaut   [ Echap ] Abandon...';
  HintCancelDef = '[ Entrée / Echap ] Abandonner par défaut';
  LibOk = 'Fermer en validant';
  LibCancel = 'Fermer en abandonnant';

  HintDBGSelMode = '[F3 / MAJ+F3] Sélectionne / Désélectionne la ligne en cours et passe à la suivante';
  LibComplet = 'Tout le magasin';
  LibPartiel = 'Tournant';
  LibAjouArtInv = 'Ajouter des modèles';
  LibPerimInv = 'Définir le périmètre';
  LibTitreInv = ''; // obsolète, à supprimer v13
  LabTitreInv = ''; // obsolète, à supprimer v13

  MsgNoActiveInv = 'Aucun inventaire n''affiché à l''écran !' + #13#10 + 'Sélectionnez l''inventaire à gérer dans la liste des inventaires...';
  MsgNoTest = 'Vous n''avez pas confirmé que les outils de saisie avaient été testés avec succés !';
  MsgNoPerim = 'Avant toute chose, il est impératif' + #13#10 + 'de commencer par définir le périmètre de l''inventaire...';

  // *******
  CstExpAffSfPasPrinc = 'Vous n''avez pas de fiche principale dans votre sélection';
  CstExpAffSfPasOrph = 'Vous n''avez pas de fiche orpheline à affecter';
  CstExpAffSfPasEnr = 'Vous n''avez pas enregistré vos modifications. Annuler ?';
  CstExpAffSfSelPrin = 'Vous devez sélectionner des fiches principales';
  CstExpAffSfSelSFich = 'Vous devez sélectionner des sous-fiches';
  CstExpAffSfSelAutant = 'Vous devez sélectionner autant de fiches principales que de sous-fiches';
  CstExpAffSfPasAss = 'Vous n''avez fait aucune association, voulez-vous sortir ?';

  VoImpossible2 = 'La vente de cet article est impossible,' + #13 + #10 + 'sa date de cession est antérieure à la date de clôture...';
  VoImpossible1 = 'La vente d''un pseudo ou d''un article archivé est impossible...';
  BADateLib = 'Récapitulatif des bons d''achat du §0 au §1  -  ';
  PasAmortissement = 'La validation d''une fiche sans durée d''amortissement est impossible...';
  PastraitementSF = 'Sélection d''une sous fiche non-orpheline interdite...';

  CaisseEnConsult = 'Fonction impossible, la caisse est en consultation uniquement...';

  CstOuvCaisseJour = 'Les sessions de caisse ne peuvent porter sur plusieurs jours';
  CstOuvCaisseSemaine = 'Les sessions de caisse ne peuvent porter sur plusieurs semaines';
  CstOuvCaisseMois = 'Les sessions de caisse ne peuvent porter sur plusieurs mois';
  CstOuvImpossible = 'Vous devez fermer votre sessions en cours';

  CstMessCaisseOuv = 'Attention, vous avez des sessions ouvertes dans votre sélection';
  Cst_Ref_desArchive = 'Désarchivage';
  Cst_ref_desarchiveNbr = 'Voulez-vous désarchiver les §0 fiches ?';
  CltListArch = 'Liste des clients archivés';

  bapaspossible = 'Encaissement impossible !!!' + #13 + #10 + #13 + #10 +
    'Le montant des bons d''achats (§0€) ne doit pas dépasser' + #13 + #10 +
    'le total des §1 (§2€)...';
  PasPossibleBA = 'Opération impossible sur un ticket avec des bons d''achats...';

  CstGebucoInfo = 'Informations exportation GEBUCO';
  CstExportGebuco = 'Export GEBUCO du §0 au §1';
  CstQuestGebuco = 'Attention, pour la période du §0 au §1 :' + #10#13 +
    '  - Seuls les prix des Bons de réception seront modifiables.' + #10#13 +
    '  - Les retours fournisseurs seront clôturés.' + #10#13 +
    '  - Les transferts inter-magasins seront clôturés' + #10#13 +
    ' Confirmez-vous l''exportation ? ';

  // Gestion groupée des articles de location
  // ----------------------------------------
  ActionCessartloc = 'Cession d''un article de location';
  ActionCessartlocSF = 'Cession d''une sous-fiche de location';
  ActionArchLoc = 'Articles archivés';
  ActionArchLocSf = 'Fiches secondaires archivées';
  ActionRetirLocSf = 'Sous Fiches rendues "orphelines"';

  MsgGenerLocEtik = 'Confirmez la génération des étiquettes de location pour les "§0" articles de la liste...';
  Actioncat = 'Articles placés dans la Catégorie';
  ActionStatut = 'Articles définis avec le statut';
  ActionStatutSf = 'Sous Fiches définies avec le statut';
  ChangeCat = 'Confirmez le déplacement des articles listés vers la Catégorie' + #13 + #10 + '§0';
  ChangeStat = 'Confirmez le changement de statut des articles listés pour le statut' + #13 + #10 + '§0';
  categVide = '"Pas de Catégorie"';
  StatutVide = '"Pas de Statut"';
  // ----------------------------------------

  PasmodifPxcession = 'Vous devez saisir dans un premier temps la date de cession...';
  CstSynthCA = 'SYNTHESE DU CHIFFRE D''AFFAIRES';
  CstPeriode = 'Période du §0 au §1';
  CstSCA0 = 'Chiffre d''affaires';
  CstSCA1 = 'CAISSE VENTE';
  CstSCA2 = 'FACTURE VENTE';
  CstSCA2Bis = 'FACTURE RETROCESSION';
  CstSCA3 = 'TOTAL VENTE';
  CstSCA4 = 'CAISSE LOCATION';
  CstSCA5 = 'FACTURE T.O.';
  CstSCA6 = 'TOTAL LOCATION';
  CstSCA7 = 'CHIFFRE D''AFFAIRES BRUT';
  CstSCA10 = 'CHIFFRE D''AFFAIRES NET';
  CstSCA11 = 'Ventilation comptable';
  CstSCA11_1 = 'HT';
  CstSCA11_2 = 'TVA';
  CstSCA11_3 = 'TTC';
  CstSCA13 = 'TOTAL';
  CstSCA14 = 'Comptes clients';
  CstSCA14_1 = 'Règlements';
  CstSCA14_2 = 'Mises en cpte';
  CstSCA15 = 'Opérations saisies en caisse';
  CstSCA16 = 'Facturation';
  CstSCA18 = 'Réservations Internet';
  CstSCA19 = 'Régularisations clients';
  CstSCA19_1 = 'Profit';
  CstSCA19_2 = 'Perte';
  CstSCA20 = 'Régularisations comptes clients';
  CstSCA21 = 'Modes d''encaissement';
  CstSCA21_1 = 'Fond initial';
  CstSCA21_2 = 'Encaissement';
  CstSCA21_3 = 'Apport';
  CstSCA21_4 = 'Prélvts & Dép.';
  CstSCA21_5 = 'Solde';

  SuperArchi = 'Attention, ce modèle n''est pas archivable. Vous pouvez néanmoins' + #13 + #10 +
    'exceptionnellement l''archiver, mais cette opération peut mettre' + #13 + #10 +
    'en péril l''intégrité des calculs d''amortissements.' + #13 + #10 + #10 +
    'Confirmation de l''archivage?';
  Supfichartloc = 'Suppression impossible, la date d''achat est inférieure' + #13 + #10 + 'à la date de dernière clôture...';
  modifDtcession = 'Impossible, la date de cession ne peut pas être inférieure' + #13 + #10 + 'à la date de dernière clôture...';
  modifDtachat = 'Impossible, la date d''achat ne peut pas être inférieure' + #13 + #10 + 'à la date de dernière clôture...';

  RalGroupeOblig = 'Il faut cocher au moins un groupe !...' + #13 + #10 +
    '( Sans groupe défini, il ne peut pas avoir de réponse à votre demande )';
  CstLettrageNonSel = 'Vous devez sélectionner les lignes de comptes à lettrer...';
  CstImpGroupe = 'Impossible de lettrer un groupe, vous devez changez votre sélection.';
  CstImpLettre2Groupe = 'Impossible de lettrer des lignes de deux groupes différents...';
  CstLettrage = 'Lettrage';
  CstCreRegul = 'Voulez-vous lettrer ces écritures en créant une écriture de régularisation ?';
  CstCreLettrage = 'Voulez-vous lettrer ces écritures ?';
  CstImpLettreDejLettre = 'Impossible de lettrer des lignes déjà lettrées';

  MsgNoCanDep = 'Ce modèle n''a pas de stock !' + #13 + #10 + '( Seuls les modèles ayant du stock peuvent être dépréciés ! )';
  ConfSupgesRecep = 'Confirmez le bon [ §0 ]' + #13 + #10 + 'doit être retiré de la liste des documents ouverts... ';
  VOnonvalide = 'Ligne non valide pour une vente d''occasion';
  Puht = '  PU HT   ';
  Pxht = ' TOT HT   ';
  VenteDetaxee = 'VENTE DETAXEE';
  detaxeHT = '(Encaissement HT)';
  detaxeTTC = '(Encaissement TTC)';
  cstRbTVA = 'Remb.' + #13 + #10 + 'TVA';
  CST_ConnectSec = 'Voulez-vous vous connecter sur votre serveur de secours ?';
  BRImpossible = 'Impossible de générer un bon de réservation, le ticket est vide...';
  BLInserer = 'Veuillez insérer le bon de livraison à imprimer';
  BRInserer = 'Veuillez insérer le bon de réservation à imprimer';
  BLConfSuiteProbleme = 'Souhaitez-vous imprimer le bon de livraison';
  BRConfSuiteProbleme = 'Souhaitez-vous imprimer le bon de réservation';
  FTInserer = 'Veuillez insérer la facture à imprimer';
  FTConfSuiteProbleme = 'Souhaitez-vous imprimer la facture';

  Cst_Ref_Nk = 'Gestion de la nomenclature';
  Cst_Ref_NkHisto = 'Historique : Gestion de la nomenclature';
  Cst_Ref_NkSelSSF = 'Sélectionner la nouvelle sous famille';
  Cst_Ref_NkAffect = 'Affectation';
  Cst_Ref_NkAFFQUEST = 'Affecter la sous famille aux éléments sélectionnés ?';

  Cst_Ref_traite = 'Traité';
  Cts_Ref_Ignore = 'Ignoré';
  Cts_Ref_Valide = 'Validation';
  Cst_ref_etiquette = 'Etiquette';
  Cst_Ref_Ignorer = 'Ignorer';
  Cst_Ref_Annule = 'Annulation';
  Cst_Ref_Histo = 'Historiser avant le';
  Cst_Ref_Archive = 'Archivage';
  Cst_ref_archiveNbr = 'Voulez-vous archiver les §0 enregistrements ?';
  Cst_ref_AnnuleHisto = 'Voulez-vous annuler les actions déjà accomplies';
  Cst_Ref_Cancel = 'Annuler TOUTES vos modifications ?';
  Cst_Ref_Post = 'Valider vos modifications ?';
  Cst_Ref_Ignorer_Grp = 'Voulez-vous ignorer tout le groupe ?';
  Cst_ref_etiquette_Stk = 'Voulez-vous ré-etiqueter le stock ?';
  Cst_ref_valide_grp = 'Voulez-vous valider tous le groupe ?';
  Cst_Ref_Impossible = 'Impossible de changer d''onglet sans valider ou annuler';
  Cst_Ref_ChargPxGest = 'Chargement des prix de vente modifiés';
  Cst_Ref_ChargPxHist = 'Chargement de l''historique des prix de vente';
  Cst_Ref_PxGestTitre = 'Gestion de la mise à jour des prix de vente';
  Cst_Ref_PxHistTitre = 'Historique : mise à jour des prix de vente';
  Cst_Ref_TraitePx = 'Des mises à jour de prix du référencement sont en attente';
  Cst_Ref_TraiteNk = 'Des modèles sont masqués par le référencement';
  Cst_Ref_Traitement = 'Référencement : Traitements en attente';

  RESaPAsST = 'Impossible d''insérer un sous total dans un bon de réservation provenant de la caisse...';
  DejaTicketResa = 'Transfert impossible vous avez déjà des ventes en cours...';
  Dejaresa = 'Impossible, vous avez déjà importé une réservation dans ce ticket...';
  rappelResa = 'Souhaitez-vous transformer la réservation en une vente?';
  ConfFracDev2 = 'Confirmez l''enregistrement' + #13 + #10 + 'Docs générés en date du ';
  LabDateTrans = 'Date du document généré';

  Cst_TropCol = 'Attention, modifier trop de données peut entraîner des problèmes de réplication'#13#10 +
    'Voulez-vous continuer ?...';
  Cst_AssocierCol = 'Associer une collection';
  Cst_AssocierColQuestTous = 'Associer la collection à tous les modèles ?';
  Cst_AssocierColQuest = 'Associer la collection aux modèles sélectionnés ?';

  Cst_dissocierCol = 'Dissocier une collection';
  Cst_dissocierColQuest = 'Dissocier la collection des modèles sélectionnés ?';

  Cst_Charge_Artsanscol = 'Chargement des modèles sans collection';
  Cst_Charge_ArtPlusCol = 'Chargement des modèles avec plusieurs collections';
  Cst_Charge_Colavecart = 'Chargement des collections avec leurs modèles';

  NeedOneTail = 'If faut définir au moins une taille !...    ';
  TailexistModel = 'Cette taille fait déjà partie du modèle...    ';
  Only28Tail = 'Vous ne pouvez définir que 28 tailles au maximum...   ';

  SupModelTTV = 'Confirmez la suppression du modèle de tailles travaillées' + #123 + #10 + '§0';
  LabNomModelTTV = 'Nom du modèle';
  TitNomModelTTV = 'Nom du modèle de tailles travaillées';

  BRAccompte = 'Souhaitez-vous encaisser un acompte pour ce bon de réservation?';
  BRPasSousTotal = 'Impossible de générer un bon de résevation avec des sous totaux...';
  LibBR = 'Bon de reservation';
  cstresa = 'Bon de' + #13 + #10 + 'Reserv.';

  PlusRemiseGlob = 'Attention la remise globale est supprimée...';
  DureePrepMatos = 'Demander l''état du matériel à préparer sur plus d''une semaine risque d''être long ...' + #13 + #10 +
    '( Cela dépend bien entendu du nombre de réservations ... mais peut prendre plusieurs minutes en saison haute )' + #13 + #10 + #13 + #10 +
    'Faut-il continuer ?...';
  InsForNewTail = '[INS] [CTRL+INS] Ajoute une nouvelle taille [ Après ] [ Avant ]... celle sélectionnée';
  CreerGTF = 'Confirmez la création d''une nouvelle grille de tailles fournisseur....';
  SupCtrl = 'Je contrôle si cette suppression est possible...';

  ChargeDeprecie = 'Chargement de la liste des modèles dépréciés au cours des 3 derniers mois...';
  DatEtatDep = 'Etat des dépréciations au : §0';
  NoStockInDep = 'Le modèle que vous demandez à déprécier :' + #13 + #10 +
    'Code chrono : §0' + #13 + #10 +
    'Référence : §1' + #13 + #10 +
    'Désignation : §2' + #13 + #10 +
    'N''a pas de stock actuellement.' + #13 + #10 +
    'Voulez-vous néanmoins le déprécier ?';

  DejaDep = 'Vous avez déjà saisi une ligne de dépréciation pour ce modèle...';
  ConfSupDep = 'Confirmez la Suppression de la dépréciation sélectionnée ...' + #13 + #10 +
    'Code chrono du modèle : §0';

  DepNoSupTodo = 'Il n''y a aucune dépréciation à supprimer dans votre sélection de modèles...';
  DepDateTravTooBig = 'La date de travail ne peut pas être postérieure à aujourd''hui';
  DepDateTravTooSmall = 'Vous ne pouvez pas travailler au delà de 1 mois en arrière...';
  DepDateLivrTooBig = 'La date limite de livraison ne peut pas être postérieure à aujourd''hui...';
  DepMotifDef = 'Enregister [ §0 ]' + #13 + #10 + #13 + #10 + 'comme §1 par défaut au chargement du module sur ce poste de travail';
  NoArtToShow = 'Aucune modèle ne correspond à vos critères de sélection';
  TxDeprecie0 = 'Impossible de valider une dépréciation avec un Taux ' + #13 + #10 + 'inférieur ou égal 0.00% ... ';
  MajDeprecie = 'Enregistrement des dépréciations pour les modèles sélectionnés ... ';
  GenerikWork = 'Travail en cours';

  DifPlusque1 = 'Confirmez ce nouveau montant SVP...' + #13 + #10 + #13 + #10 +
    'Ancien montant TTC : §0' + #13 + #10 +
    'Nouveau montant TTC : §1';

  LocPackCategPasBonRL = 'Attention, la catégorie de l''article §0' + #13 + #10'n''est pas référencée dans le pack.' + #13 + #10 +
    'Souhaitez-vous tout de même accepter la location?';

  LocPackDejaSaisiRL = 'Impossible, vous avez plusieurs articles avec le type : §0';

  RLligneMauvaise = 'Une des lignes sélectionnées n''est pas compatible avec cette fonction...';
  Repriseligne = 'Souhaitez-vous intégrer les §0 ligne(s) sélectionnée(s) dans un pack?';
  CstMessChargeRnonP = 'Chargement de l''état des locations rendues, non payées...';
  CstTitreLocRnonP = 'Etat des locations rendues, non payées';

  CautionL1 = 'Le montant de la caution en cours est de §0';
  CautionL2 = 'La caution proposée pour les nouveaux articles est de §0';
  CautionL3 = 'Que souhaitez-vous faire?';
  cautionB1 = '&Rendre';
  CautionB2 = '&Ajouter automatiquement';
  cstcaution = 'Caution';
  clientpassage = 'Client de passage';
  MotPack = 'Pack';
  CstTitreLocPark_RETLOC = 'Articles en retard de location';
  CstEdEnch_RetLoc = 'Articles en retard de location';
  cstvo = 'Vente' + #13 + #10 + 'occas.';
  horsparc = 'Article hors parc location...';
  paramvo = 'Ce paramétrage sera disponible après réplication...';
  BLSoldedeb = 'COMPTE CLIENT DEBITEUR :';
  BLSoldeCre = 'COMPTE CLIENT CREDITEUR :';
  ReprisePL = 'Souhaitez-vous rappeler, pour ce client, les articles non sélectionnés' + #13 + #10 +
    'dans le paiement à la ligne?';
  Packauto = 'Pack automatique';
  AffMessNotDesarchTMM = 'Les transferts ayant été regroupés ne peuvent plus être désarchivés';
  CapContinuer = '&Continuer';
  CVracExistCadence = 'Impossible de valider cette ligne de commande :' + #13 + #10 +
    'La commande sélectionnée contient dejà une livraison en date du §0 pour ce modèle...' + #13 + #10 + #13 + #10 +
    'Proposez une autre cadence de livraison... ou Abandonnez...';
  YaDEsRetik = 'Il y a des étiquettes de "Ré-étiquettage de stock" en attente' + #13 + #10 +
    'Faut-il les imprimer ?...';
  NoRecepDispo = 'Il ne reste plus de réception ouverte && disponible chez ce fournisseur...   ';
  NoCdeDispo = 'Il ne reste plus de commande ouverte && disponible chez ce fournisseur...   ';
  MaskOptVracTxtHint = '[ALT+M] Afficher / Masquer le détail du tarif && de la zone de définition des options';
  MaskOptVracUnidimHint = '[ALT+M] Afficher / Masquer la zone de définition des options';
  NoSelRecep = 'Il n''y a aucun bon de réception ouvert pour recevoir cette livraison...';
  NoSelCde = 'Il n''y a aucun bon de commande ouvert pour récevoir cette ligne de commande...';
  ValidRecepVrac = 'Confirmez l''enregistrement de cette ligne' + #13#10 +
    'Dans le bon N° : §0 du §1 ' + #13 + #10 +
    'Magasin : §2';

  ResaPasDecat = 'Impossible de poursuivre...'#13 + #10 +
    'Ce type d''article n''a aucune catégorie de location associée !...' + #13 + #10 +
    '(Ce paramétrage est défini dans l''outil de gestion de la nomenclature)';

  CstLocEtatDetTit = 'Analyse détaillée du parc de location';
  CstLocEtatDetDisp = 'Dispo';
  CstLocEtatDetLoc = 'Loc';

  NoSupResaPaye = 'Vous ne pouvez pas supprimer une réservation "Pré Payée"';
  NoSupResaNlle = 'Vous ne pouvez pas supprimer une réservation Web sans l''avoir préalablement "Regardée"';
  NoSupResaAccepte = 'Vous ne pouvez pas supprimer une réservation "Acceptée"';

  CapOrga = 'Organisme';
  CapStatLoc = 'Statut de location';
  CapCategLoc = 'Catégorie de location';
  CapTipArtLoc = 'Type d''article';
  CapTipSelToc = 'Opé. commerciales';

  SupTransLine = 'Confirmez la suppression de la ligne de transfert sélectionnée...  ';
  CstImpTckEqui = 'Impossible si le ticket n''est pas équilibré';

  NoCritDefined = 'Aucun domaine de sélection n''est défini... ';
  LibPotentielTrans = 'Etude du potentiel de transfert Inter-Magasins ( Magasin d''origine §0 )';
  CapColumnStkMag = 'Stk Mag';
  NoTransTodo = 'Aucun transfert de modèle à générer selon les critères que vous avez défini';
  LibNoDomaine = 'Vous n''avez pas défini de domaine d''étude...   ';
  OneMagDestOblig = 'Il est impératif de sélectionner au moins 1 magasin de destination !';

  cstControleDoc = 'Contrôle' + #13 + #10 + 'Loc.';
  cstdetailcompte = 'Détail' + #13 + #10 + 'compte';
  dcDETAILCOMPTE = 'DETAIL DU COMPTE';
  dcREGLEMENT = 'REGLEMENT';
  NotAcceptTx0 = 'Le taux de transfert ne peut pas être égal à "0" !' + #13 + #10 +
    '( Rappel : un taux égal à "1" équivaut à pas de taux de transfert )';
  CapTauxTrans = 'Taux de transfert';
  LabTauxTrans = 'Taux de transfert à appliquer aux prochains modèles transférés';
  LibDetMatos = '§0 à préparer';

  CstLocEtatPer = 'Analyse de l''état périodique Périodes : §0 au §1, §2 au §3,  §4 au §5';
  CstLocEtatPerTot = 'Tot';
  CstLocEtatPerPAge = '%age';
  CstLocEtatPerDispo = 'Disponible';
  CstLocEtatPerPeriode = '§0 au §1';

  CstLocPrevCA = 'CA Prévisionnel ';
  RetourImpossiblePL = 'Retour Impossible pour ce modèle, la fonction ''Paiement à la Ligne'' est en cours...';
  PLAnnul = 'Annul. Paiement Ligne';
  AnnulPl = 'Souhaitez-vous annuler le paiement à la ligne?';
  FracReliquat = 'Lignes restantes...';


  CstLocAnaCA = 'Analyse du CA Location Périodes du §0 au §1 et du §2 au §3';
  DoPrintFracDev = 'Imprimer le rapport de transfert ?' + #13 + #10 +
    '( vivement conseillé... )';
  FracEncours = 'Transfert du devis en cours...' + #13 + #10 +
    'En fin de traitement ce devis sera clôturé';
  FracNoGener = 'Problème en cours de travail, le transfert n''a pas été effectué...';

  PbFracDev = 'Problème : Document non généré...';
  ConfFracDev = 'Confirmez l''enregistrement du travail à effectuer...';

  LibFracDoc = 'Document';
  LibFracVerDev = 'Transfert vers Devis';
  LibFracVerBL = 'Transfert vers Bon de Livraison';
  LibFracVerFac = 'Transfert vers Facture';

  NonDevUsed = 'Modification ou Suppression impossibles car cet "Item de transfert" est déjà utilisé';
  NonDevExist = 'Impossible : un "Item de transfert" porte déjà ce nom !...';

  PasSelectPL = 'Fonction impossible, vous avez sélectionné aucune ligne...';
  cstPL = 'Paiement' + #13 + #10 + 'Ligne';
  HintClearSel = 'Tout Désélectionner...';
  ConfirmChangeResa = 'Confirmez-vous mettre l''état :' + #13 + #10 + #13 + #10 + '§0' + #13 + #10 + #13 + #10 +
    'à toutes les réservations sélectionnées';

  SupResEncours = 'Suppression en cours...     ';
  LibResEdit = 'Modifier';
  SupprResaLoc = 'Confirmez la suppression de cette réservation ...' + #13 + #10 +
    'ATTENTION : cette SUPPRESSION est IRREVERSIBLE !...';

  etiqclientCB = 'Souhaitez-vous imprimer une étiquette code barre client?';
  locpasRV = 'Pas de retour à la volée sur les pseudos articles';
  dernierrendu = 'Dernier article rendu :';
  Retouralavolee = 'Retours à la volée';
  articlerendu = 'Saisir le code de l''article à rendre';

  NeedDetailResa = 'Impossible de valider une réservation sans ligne de détail associée à un client !';
  NosupprLastIdent = 'Impossible de supprimer cette ligne de réservation !' + #13 + #10 +
    'Une fiche de réservation doit avoir au moins une ligne de détail associée à un client...';
  SupprLineIdentResa = 'Confirmez la suppression de la ligne de réservation concernant la personne sélectionnée ...';
  RetModifResa = 'Attention : Vous ne voyez pas la fiche de réservation que vous venez de créer ou modifier...' + #13 + #10 +
    'car elle ne correspond pas à vos critères de sélection !';
  HintDbgIdentResa = '[Double Clic] Editer la ligne de réservation sélectionnée... ';
  AbandonIdentResa = 'Confirmer l''abandon de toutes les modifications éventuellement effectuées dans cette ligne de réservation ?...';
  NoResaToEdit = 'La ligne sélectionnée n''est pas une ligne de réservation !... ';
  ResaPerdQuest = 'Vous allez perdre toutes les modifications effectuées dans la liste des questions...' + #13 + #10 +
    'Confirmez cette décision SVP ....';
  NeedDataResa = 'Pour saisir la suite de votre fiche de réservation vous devez d''abord définir le champ §0! ...';
  LibResNeo = 'Nouveau';

  BtnAssur = 'Garantie';
  EchPicco = 'Echange Piccolink' + #13 + #10 +
    'L''article §0 n''est pas prévu dans le pack.' + #13 + #10 +
    'Souhaitez-vous appliquer un supplément?';

  NotNullPxBase = 'Le prix de base ne peut pas être à 0.00 ...' + #13 + #10 + 'lorsque certaines tailles ont déjà un prix défini non nul !';
  ForcePxBase = 'La saisie du prix de base du tarif est obligatoire...   ';

  newremiseorg = 'Souhaitez-vous appliquer la remise liée au nouvel organisme?';
  annulremorg = 'Souhaitez-vous annuler la remise?';
  ModifToutesLignes = 'Souhaitez-vous modifier toutes les lignes du bon de location?';
  Qsupplement = 'Attention, cet article ne correspond pas à la même offre commerciale. ' + #13 + #10 + 'Souhaitez-vous appliquer un supplément?';
  TctOblig = 'La définition du type comptable est obligatoire...';
  CaptionDetailticket = 'Détail du ticket';

  NeoGrptarLoc = 'Nouveau groupe de tarif';
  HintBtnSoveCmz = 'Sauver un modèle de configuration des lignes';
  HintFullCollapse = 'Fermer la liste (n''afficher que son 1er niveau de détail)';
  HintAutoHeight = 'Activer / Désactiver ... l''affichage complet du contenu des colonnes';

  ReafTransTarLoc = 'Réorganisation des tarifs...      ';
  TransTarifLoc = 'Confirmez le transfert du tarif sur l''offre commeriale' + #13 + #10 + '§0';

  cstsupp = 'Supplé-' + #13 + #10 + 'ment';
  AucunData = 'Aucun §0 défini';

  ErrNoDeletePerWeb = 'Vous ne pouvez pas supprimer les périodes importées depuis la centrale...';

  LibToOrig = 'T.O d''Origine';
  LibToTwinnerNotInited = 'Le paramétrage TO de votre centrale est incorrect...';

  BLNoTransThisDate = 'Aucun BL à transférer en facture sur cette période....';

  chronoExiste = 'Désolé mais le code chrono [§0] est déjà associé à un autre modèle...';
  PBParamLocTO = 'Impossible de définir le paramétrage T.O ... SVP prévenez GINKOIA SA !';
  capLocTo = 'Location TO';
  ArtUtilInterne = 'Ce PSEUDO Article est utilisé en interne par Ginkoia et ne peut être ni modifié ni supprimé...';

  CstEdEnch_Detmvt = ' Détail des mouvements';
  CstEdEnch_recTVA = ' Synthèse du chiffre d''affaires';
  CstEdEnch_SyntMvt = ' Synthèse des mouvements';
  CstEdEnch_JouCai = ' Edition du journal de caisse';
  CstEdEnch_LstTke = ' Liste des tickets';
  CstEdEnch_JrnVte = ' Journal des ventes';
  CstEdEnch_CAHorDa = ' CA horaire par date';
  CstEdEnch_JrnLoc = ' Journal des locations';
  CstEdEnch_EtatLoc = ' Etat des locations en cours';
  CstEdEnch_CesAmor = ' Edition des cessions et des amortissements';
  CstEdEnch_HitVte = ' Hit parade des ventes';
  CstEdEnch_CaVend = ' CA par vendeur';
  CstEdEnch_CaHorVend = ' CA horaire par vendeur';
  CstEdEnch_HistCff = ' Historique du coffre';


  PasTarifOrganisme = 'Le tarif pour l''offre commerciale §0' + #13 + #10 +
    'et l''organisme §1 n''existe pas.' + #13 + #10 +
    'C''est le tarif magasin qui est appliqué...';

  PasOrganisme = 'Pas d''organisme';

  CltArchive = 'On ne peut pas archiver un client possédant des membres';
  RegroupFin = 'Regroupement des bons de transfert terminé...    ';
  ArchivageFin = 'Archivage terminé...   ';
  LibRecap = 'Récapitulatif';
  RegroupEnCours = 'Regroupement des documents en cours...   ';
  ConfirmArchTrans = 'Confirmez l''archivage des bons de transfert sélectionnés ... ';
  DoingArchivage = 'Archivage des documents en cours ...    ';
  NoTransToRegroup = 'Il n''y a pas de regroupement de transfert à effectuer ... ';


  TransTailDevientNega = 'Attention : Magasin §0' + #13 + #10 + 'Le stock de cette Taille/Couleur est négatif';
  GesCouleursMagasin = '[F4] ou [Double clic] Pour définir la couleur à associer au magasin sélectionné';
  TransRapNoCb = 'Votre saisie ne correspond pas à un code à barre valide !... ';
  //****************************
  GlobEch = 'Attention, pour les articles échangés, vérifiez la cohérence' + #13 + #10 + 'des dates de sortie et de retour...';

  CstPortabPasLoc = 'Pas dans le parc';
  CstLocInvEtat = 'Ouverture Le §0';
  CstLocNew = 'L''ouverture d''un inventaire efface le précédent';
  CstLocDejaExistant = 'Le modèle est déjà saisi dans l''inventaire ...';
  CstLocInvBtEtat = 'Etat d''inventaire';
  CstLocInvBtSaisie = 'Saisie';
  CstLocInvOk = 'OK';
  CstLocInvPP = 'Pas dans le parc';
  CstLocInvLouecp = 'Loué et compté';
  CstLocInvPasCpt = 'Pas compté';

  cstRegulGlob = 'Global' + #13 + #10 + '[Alt+F7]';
  CltStatFid = 'Fidélité du client §0';
  CltStatBlNonFac = 'Liste des BL non facturés du client §0';
  CltStatCptClient = 'Compte du client §0';
  CltStatFacture = 'Liste des factures du client §0';
  CltStatDevis = 'Liste des devis du client §0';
  CltStatTicket = 'Liste des tickets du client §0';

  cstChoixSkiman = 'Skiman';
  CstDetailMvt = 'Détail des mouvements Magasin §0 du §1 au §2';
  CstSynthMvt = 'Synthèse des mouvements Magasin §0 du §1 au §2';
  CstRecapTva = 'Synthèse du chiffre d''affaires Magasin §0 du §1 au §2';

  InfoRndOFF = 'Arrondis INACTIFS';
  InfoRndON = 'Arrondis ACTIFS';

  HintCreTarAlone = '[[Double clic] ou [F4] Créer un tarif pour l''offre commerciale sélectionnée...';
  HintDbgRap = '[Double clic]ou [F4] Pour ouvrir la fiche du tarif sélectionné';
  HintMajRap = '[F5] Activer / Désactiver le mode MàJ rapide';
  MessKitTarloc = 'Confirmez que vous désirez quitter le module de gestion' + #13 + #10 + 'des paramètres de location...';

  RoundOn = 'Arrondis' + #13 + #10 + 'ON';
  RoundOff = 'Arrondis' + #13 + #10 + 'OFF';

  LibProduit = 'Offre commerciale';

  LibTarifLocVide = 'Tarif de Location';

  Locpasbontype = 'Echange impossible avec ce type d''article...';
  NoTipCatActif = 'Il faut définir au moins un type article !...' + #13 + #10 +
    'pour pouvoir associer des catégories...';

  NoCatLocDispo = 'Plus aucune catégorie disponible pour les types d''articles définis...';

  PrepareAnalVte = 'Recherche des articles vendus sur la période...';
  // 3 déplacées
  OrdreRay = 'Position du Rayon';
  OrdreFam = 'Position de la Famille';
  OrdreSF = 'Position de la S/Famille';

  CategInDyna = 'Impossible de supprimer ce type de catégorie, car vous venez de rajouter une catégorie qui le référence...';
  //************
  LibFicheSecond = 'Fiche secondaire';
  Affecteorpheline = 'Confirmez l''association de la fiche secondaire sélectionnée' + #13 + #10 + 'à la fiche de location §0';

  RetfNoDateRglt = 'Vous n''avez pas saisi la date de règlement de l''avoir...' + #13 + #10 +
    'Faut-il néanmoins clôturer ce bon de retour ?';

  ReftDocNotClot = '§0 documents de votre sélection n''ont pas pu être archivés car ils n''étaient pas clôturés ...';
  ImpNoDoc = 'Aucun document à imprimer... ';
  ImpDocVide = 'Aucune ligne à imprimer dans ce document !...';
  RetFOkArchive = 'Confirmez l''archivage du document affiché...';
  ReTFOkCloture = 'Confirmez la clôture du bon de Retour affiché... ' + #13 + #10 +
    '  ATTENTION : ce document ne sera plus modifiable ! ';

  RetNoArchive = 'Seuls les retours clôturés peuvent être archivés !';
  RetfTitreListe = '  Liste des retours fournisseurs';
  RetfLinexist = 'Il existe déjà une ligne de retour pour ce modèle ! ' + #13 + #10 +
    'Confirmez que vous désirez en ajouter une nouvelle...';
  HintGenEnEdit = '[F12] Enregistrer [ECHAP] Abandonner';
  RetfEdit = '[Suppr] Supprimer la ligne sélectionnée';
  RetfDelete = 'Confirmez la suppression du bon de retour affiché ...';
  RetFSupLin = 'Confirmez la suppression de la ligne de retour sélectionnée...';
  RetFNonModif = 'Un bon de retour clôturé ne peut être ni modifié ni supprimé ... ';

  // *************************************

  QuitPicco = 'Attention, si vous fermer cette application, les Piccolink' + #13 + #10 +
    'ne pourront plus fonctionner!' + #13 + #10 +
    'Confirmez-vous la fermeture ?';

  LibLabAnnulDJ = 'Annulation du retour avant §0';
  LibLabDJ = 'Retour avant §0';
  LibFormDtRetour = 'si retour avant §0';

  CdeRechChronoLoc = 'Le code chrono recherché... ' + #13 + #10 +
    'est celui d''une fiche secondaire de cet article...';

  CdeRechVide = 'Aucun article trouvé... ' + #13 + #10 +
    '( Si cet article existe il n''est pas accessible ici... )';

  LocartArchivable = 'Article archivé si coché';
  LocartNONArchivable = 'Article non archivable';

  AnnulTckTPE = 'Attention une transaction avec le TPE a déjà été enregistrée' + #10 + #13 +
    'pour ce ticket, il faudra l''annuler manuellement.';
  PasAnnulTPE = 'Attention, la transaction avec le TPE n''est pas annulée' + #13 + #13 +
    'automatiquement, il faudra effectuer cette opération  manuellement';
  PasNegatifTPE = 'Attention pas de transaction en négatif avec le TPE,' + #10 + #13 +
    'le ticket est néanmoins validé.';
  TPEDejaEnreg = 'Modification/Suppression impossible, la transaction avec le TPE est déjà enregistrée...';

  ValidDevis = 'Enregistrement du devis impossible, vous avez des opérations' + #13 + #10 + 'de caisse en cours...';
  ValidTicket = 'Validation du ticket impossible,' + #13 + #10 + 'la somme des modes de paiement est inférieure au montant du ticket...';

  cstFinTicket = 'Valid' + #13 + #10 + '[F12]';
  cstDevisLoc = 'Devis' + #13 + #10 + '[F5]';

  DevisLocInserer = 'Veuillez insérer le devis à imprimer';
  DevisLocSuiteInserer = 'Veuillez insérer la suite du devis à imprimer';

  FactLocInserer = 'Veuillez insérer la facture à imprimer';
  FactLocSuiteInserer = 'Veuillez insérer la suite de la facture à imprimer';

  ConfSuiteProblemeDevis = 'Souhaitez-vous imprimer le devis de location?';
  ConfSuiteProblemeFact = 'Souhaitez-vous imprimer la facture de location?';

  CshHistoCfrCOFPl = 'Versement coffre : §0';
  CshHistoCfrCOFMo = 'Vers le coffre : §0';
  CshHistoCfrBANPl = 'Versement Banque : §0';
  CshHistoCfrBANMo = 'Vers la Banque : §0';
  CshHistoCfrSES = 'Session : §0';
  CstTpeAttServ = 'Attente de réponses du serveur';
  CstTpeEnvDemServ = 'Envoie de la demande au serveur ';
  CstTpeErrConServ = 'Le serveur n''est pas lancé...   Tentative dans §0 s';
  CstTpeUtilise = 'Le TPE est actuellement utilisé Patienter...   Reconnexion dans §0 s';
  CstTpeServTraite = 'Le TPE prend en charge la demande : Patienter ... ';
  CstTpeServEchoue = 'La transaction a échouée ';
  CstTpeServRefu = 'La transaction est refusée par le TPE ';
  CstTpeTimeOut = 'Le TPE ne répond pas dans les temps ';
  CstTpeOk = 'Transaction acceptée ';
  CstTpeVerif = 'Vérification de la présence du TPE';
  CstTpeAttValid = 'Attente validation de l''action par le TPE';
  CstTpeLectureCarte = 'Insérer la carte, faire le code et valider la transaction';
  CstTpeLectureCheq = 'Insérer le chèque et valider la transaction';
  CstTPERecRep = 'Reception de la réponses du TPE';
  CstTpeLecRep = 'Lecture de la réponses du TPE';
  CstTpeAttFinCom = 'Attente de la fin de communication';
  CstTpeRequeteEchoue = 'Requete échoué';
  CstTpeTransactionEchoue = 'Transaction échoué';
  CstTPETrfInf = 'Demande Informations';
  CstTPETrfChkSum = 'Calcule CheckSum';
  CstTPETrfAcce = 'Accés TPE';
  CstTPETrfDecon = 'Déconnecté';
  CstTPETrfFermPort = 'Fermeture du port';
  CstTPETrfOuvPort = 'Ouverture du port';
  CstTPETrfEnvMess = 'Envoie du message';
  CstTPETrfRecClot = 'Réception Clôture';
  CstTPETrfRecChk = 'Réception CheckSum';
  CstTPETrfRecMess = 'Réception Message';
  CstTPETrfRecStx = 'Réception STX';
  CstTPETrfRecENQ = 'Réception ENQ';
  CstTPETrfRecAck = 'Réception ACK/NACK';
  CstTPETrfTimeOut = 'TIME OUT';
  CstTPETrfDecRep = 'Décode réponse TPE';
  CstTPETrfTpePres = 'Demande Si TPE présent ';
  CstTPETrfTpeUtil = 'Demande Si Utilisation TPE ';
  CstTPETrfTpeEtat = 'Demande Etat TPE ';
  CstTPETrfConnexion = 'Connexion de ';
  CstOui = 'OUI';
  CstNON = 'NON';
  CstCessionEtAmmortissement = 'Amortissements et Cessions au §0';
  ArchiveTrans = 'Confirmez l''archivage (ou désarchivage) des transferts sélectionnés...' + #13 + #10 +
    '( L''état d''archivage des transferts sélectionnés sera inversé )';
  TransArchNoVisible = 'Attention : les transferts archivés sont retirés de la liste...  ';
  RefreshListeTrans = 'Réactualisation de la liste des transferts...  ';

  CstInvTitreImpRecompt = ' Liste des modèles à recompter : inventaire num §0, §1';

  LibRoundTarLoc = 'Recalcul automatique du tarif de location';
  // *****************
  EpurTraining = 'Confirmez-vous la suppression du contenu du rapport du mode training?';
  Loctraining = 'Impossible,  vous avez un bon de location en cours...';

  LocDocArt = 'Art.';
  LocDocClient = 'Client';
  LocDocCateg = 'Categorie';
  LocDocFix = 'Fix.';
  ChangeNom = 'Attention, vous venez de modifier le nom d''un client référencé.' + #13 + #10 +
    'Confirmez-vous le changement du nom?';
  LocpassupligneEch = 'Suppression d''une ligne suivant un échange impossible...';
  locdocVte = 'TOTAL VENTES ET SERVICES';
  locdocPaye = 'PAYE CE JOUR';
  locdoctva = 'Dont TVA';
  locDocTotal = 'TOTAL LOCATION';
  LocdocDJP = 'TOTAL DEJA PAYE';
  LocdocRap = 'RESTE A PAYER';
  locdevis = 'Devis numero :';
  locnon = 'Non';
  LocDocGarantie = 'Gar.';
  LocDocPrix = 'Prix';
  LocDocNBJ = 'D.';
  LocDocSortie = 'Sortie';
  LocDocRetour = 'Retour';
  LocCode = 'Code';
  ValidConso = 'Confirmez l''enregistrement des consommations diverses' + #13 + #10 +
    'Type  : §0' + #13 + #10 +
    'Motif : §1';

  locpastarifbis = 'Attention vous n''avez pas de tarif défini pour cette offre à cette période...';
  LocDedegress = 'Souhaitez-vous continuer le tarif dégressif?';
  LocmemeArticle = 'Attention vous ne pouvez pas relouer le même article...';
  locPasEnLoc = 'Cet article n''est pas en location...';
  PasBonDoc = 'Cet article ne fait pas parti du bon de location en cours';
  LocPasEnCoursdeLoc = 'Cet article n''est pas en cours de location...';

  CstMessChargeLoc = 'Chargement du journal des locations...';
  CstJLocDateLib = 'Journal des locations du §0 au §1  -  ';
  CstJLocSess = 'Journal des locations, Poste §0 - Session No §1';
  CstEtatARTLoc = 'En Location';
  CstEtatARTRet = 'Retour';
  CstEtatARTEch = 'Echange';
  CstMessChargeLocPark = 'Chargement de l''état des locations...';
  CstTitreLocPark = 'Etat des locations en cours';

  locfacture = 'Facture n°';
  locBL = 'Bon de location n°';

  DelOrpha = 'Confirmez la suppression de la fiche orpheline' + #13 + #10 + '§0';
  CapSfOrpha = 'Sous-Fiche Orpheline';
  DefConsoLoc = 'Mise en location...';
  CapFichePrinLoc = 'Fiches Principales';
  CapFicheSecLoc = 'Fiches Secondaires orphelines';
  LibTransEnLoc = 'Codes Chronos des §0 de location générées : §1';
  F3Sel = '[F3] Sélectionner [MAJ F3] Dé-Sélectionner';
  PasEnLoc = 'Cet article n''est pas actuellement en location';
  LoueAClt = 'Loué au client';
  ConfSupCodacces = 'Attention : c''est ce code d''accès qui était imprimé sur vos étiquettes !' + #13 + #10 +
    'Confirmez que vous désirez effectivement le supprimer...';

  // RV 06-10-2003
  CstNbrFacLoc = 'Nombre de factures';
  CstCALoc = 'CHIFFRE D''AFFAIRES LOCATION';
  CstCAVente = 'CHIFFRE D''AFFAIRES  VENTE';

  SupTck = 'Confirmez-vous l''abandon du ticket en cours?';
  SupLoc = 'Confirmez-vous l''abandon du bon de location en cours?';

  SupTckLoc = 'Attention, l''abandon du ticket en cours, abandonnera' + #13 + #10 +
    'aussi le bon de location en cours.' + #13 + #10 +
    'Confrimez-vous l''abandon?';
  SupLocTck = 'Attention,l''abandon du bon de location en cours, abandonnera' + #13 + #10 +
    'aussi le ticket de vente en cours.' + #13 + #10 +
    'Confrimez-vous l''abandon?';

  LocValidDoc = 'Validation du bon de location ?';
  Locpassuplignepack = 'Suppression d''une ligne de pack impossible, il faut supprimer l''entête.';
  LocSupLCPack = 'Confirmez-vous la suppression complète du pack sélectionné?';

  HintBtnLoadCmz = 'Charger une configuration sauvegardée sur le disque...';

  btnSortie = 'Sorties';
  btnRetour = 'Retours';
  btnRien = 'Rien';
  btnTout = 'Tout';

  RecapVente = 'Vente';
  RecapCompte = 'Compte Client';
  RecapLoc = 'Location';

  TotLocation = 'Total des locations';
  LocPastarif = 'Attention, pas de tarif défini pour ce produit... ';
  LocPasRetourPck = 'Attention, retour impossible sur une entête ou un pied de pack...';
  LocPasAnnulRetourPck = 'Attention, annulation de retour impossible sur une entête ou un pied de pack...';
  cstpack = 'Pack' + #13 + #10 + 'F8';
  cstregroup = 'Classer';

  OdPerHint = 'Sélection : [Clic Gauche] Début Période [Clic Droit] Fin Période  - Clic Actif sur  : Jour, Semaine, Mois';
  OdPerHintYear = ' et Année';
  LabDureePeriode = '§0 Jour(s)';

  HeadProdRay = 'Offres commerciales du rayon';
  HeadProdFam = 'Offres commerciales de la famille';
  HeadProdSF = 'Offres commerciales de la S/Famille';

  HeadCatLocRay = 'Catégories du rayon';
  HeadCatLocFam = 'Catégories de la famille';
  HeadCatLocSF = 'Catégories de la S/Famille';

  StandardSupprLigne = 'Confirmez la suppression de l''enregistrement sélectionné';
  NoDeleteId0 = 'Cet enregistrement de base ne peut jamais être supprimé...';
  MakeOrphelines = '( Les sous-fiches associées ne seront pas supprimées mais rendues "orphelines"...)';
  DbleClicAffSF = '[Double Clic] Voir la sous-fiche sélectionnée';
  Rajoutorpheline = 'Confirmez le rattachement de la sous-fiche' + #13 + #10 + '§0' + #13 + #10 +
    'à la fiche en cours...';
  InsGenerik = 'Créer un nouvel élément : §0';
  DelGenerik = 'Supprimer l''élément sélectionné : §0';
  EditGenerik = 'Modifier l''élément sélectionné : §0';
  LabSousFiche = 'Sous-Fiche';
  AccessCodeCB = 'le code d''accès';
  DelCode = '[SUPPR]';
  InsCode = '[INS]';
  NodelCBInterne = 'Ce code est un code à barres interne généré par le programme !...' + #13 + #10 +
    'On ne peut pas le supprimer ... ( ''est notamment celui qui apparait sur les étiquettes )';
  CodeLocUnik = 'Un code d''accès doit être UNIQUE !' + #13 + #10 +
    'Le code [§0] a déjà été utilisé... ';
  HintPseudoLoc = '[INS] Créer un pseudo [Double Clic] Modifier [SUPPR] Supprimer ';
  NoChangeChrono = 'Le code chrono de ce modèle ne peut pas être modifié !...';
  SelectaTaille = 'Sélectionnez une taille ...';
  NoItemClasse = 'Il n''y a aucun §0 de défini dans votre paramétrage...';
  NoChangeBecauseTransfert = 'Non modifiable pour les articles transférés depuis la vente';
  ArriveDepuisConso = 'On ne peut pas supprimer un article transféré depuis la vente...';
  ClasLoc = 'Articles de Location';

  IntegCatCom = 'Vous ne pouvez pas retirer ce type d''article car il est utilisé par d''autres éléments liés à cette Sous-Famille';
  CanInsForAlone = '[Double clic] ou [F4] Crée le tarif de l''offre commerciale sélectionnée...';
  TarLocExist = 'Impossible d''enregistrer :' + #13 + #10 + '§0 a déjà un tarif défini avec ces caractéristiques' + #13 + #10 +
    '(Tarif magasin - Organisme - Période)';

  LabTarifLoc = 'Tarif de location';
  NoNameperiode = 'Il faut un nom à votre période !... ';

  NoNameMultiTar = 'Le nom du tarif magasin est obligatoire';
  LocProdNomOblig = 'Vous n''avez pas donné de nom à votre offre commerciale !...';

  GenerikNomOblig = 'La saisie de §0 est obligatoire';
  ConfDelDegress = 'Confirmez la suppression du modèle de dégressivité du tarif de location' + #13 + #10 + '§0';
  ConfDelTarif = 'Confirmez la suppression du tarif de location' + #13 + #10 + '§0';

  LabModelDegress = 'Modèle de Dégressivité de tarif';
  InsF2DelF12 = '[INS] Créer  [F2] Editer  [SUPPR] Supprimer  [F12] Enregistrer  [Echap] Abandonner';
  LocNomDegressOblig = 'Il faut un nom à votre modèle de dégressivité !... ';

  ConfDelAssCat = 'Confirmez que vous désirez retirer la catégorie §0 de cette S/Famille...';
  InsDelLocCatHint = '[INS] ou [Double Clic] Ajouter une catégorie  [SUPPR] Retire la catégorie pointée';

  NoTipCatLocDispo = 'Tous les types d''articles disponibles sont déjà sélectionnés...' + #13 + #10 +
    '( ou il n''y en a aucun de possible )';
  NoCategLocDispo = 'Toutes les catégories disponibles sont déjà sélectionnées...' + #13 + #10 +
    '( ou il n''y en a aucune de possible )';
  LocNoChangeTipCat = 'Impossible de changer le type d''article de cette catégorie car il y des offres commerciales définies...';

  DoubleClicSel = '[Double clic] ou [Ok] Sélectionne l''élément de la ligne sélectionnée...';
  ConfDelCat = 'Confirmez la suppression de cette catégorie';
  NoTipCateg = 'La définition d''un type d''article est obligatoire ...';
  NoCatGtf = 'La définition d''une Grille de tailles est obligatoire ...';
  LabElement = 'Elément';
  DElTipCatCom = 'Confirmez que ce type d''article n''est plus à associer à cette sous-famille...';
  HintPrintNk = 'Edition - Export de la nomenclature';
  HintPrintNkLoc = 'Edition - Export de la nomenclature de location';
  NoProdLoc = 'Aucune offre commerciale définie';
  ConfDelProdLoc = 'Confirmez la suppression de l''offre commerciale' + #13 + #10 + '§0';
  LocProdNoSuppr = 'Suppression IMPOSSIBLE : offre commerciale référencée...';

  IsPxvTTC = 'Prix de vente TTC';
  IsPxvHT = 'Prix de vente HT';
  //
  AfftarBase = 'Confirmez l''affichage du tarif de vente général...     ' + #13 + #10 +
    '( Ce tarif concernant tous vos modèles référencés, son affichage peut être assez long )     ';
  MajTarFichart = 'Le tarif d''ACHAT est différent de celui enregistré dans la fiche modèle...    ' + #13 + #10 +
    'Faut-il mettre à jour le tarif d''ACHAT de la fiche modèle ?' + #13 + #10 + #13 + #10 +
    '( REMARQUE : LE TARIF DE VENTE DU MAGASIN EST TOUJOURS MIS A JOUR !... )';

  AffecteTarVente = 'Confirmez que le tarif : §0' + #13 + #10 +
    'est à appliquer dans le magasin : §1';
  DeleteTarVente = 'Confirmez la suppression du tarif de vente "§0"' + #13 + #10 +
    '( ATTENTION : cette opération supprime tous les prix définis sur ce tarif )   ';
  DeleteTarVente2 = 'La suppression d''un tarif de vente est irréversible... ' + #13 + #10 +
    'Faut-il continuer ? ... ';
  NoTarVte = 'Aucun tarif de vente sélectionné !';
  InsF2Del = '[INS] Créer  [F2] Editer  [SUPPR] Supprimer';
  InsTarvte = 'Créer un nouveau tarif de vente';
  DelTarvte = 'Supprimer le tarif de vente sélectionné';
  EditTarVte = 'Modifier le nom du tarif de vente sélectionné';

  // rev 16 05 ***************************************************
  LocPackArticlepasbontype = 'Impossible ce pack n''accepte le type d''article (§0)';
  LocPackCategPasBon = 'Attention, la catégorie de cet article n''est pas référencée dans le pack.' + #13 + #10 +
    'Souhaitez-vous tout de même accepter la location?';
  LocPackDejaSaisi = 'Impossible, vous avez déjà saisi un article pour le type d''article : §0';

  cstSupLigneLoc = 'Sup Ligne';
  Locparamloc = 'Le paramétrage des heures de location est incomplet...';
  LocPasClient = 'Location impossible, vous n''avez pas de client en cours...';
  LocAutreClient = 'Impossible de changer de client, vous avez un bon de location en cours...';

  loclib0 = 'Veille';
  loclib1 = 'Matin';
  loclib2 = 'Après midi';
  loclib3 = 'Lendemain';

  CstPortabNonTrouve = 'L''article n''existe pas';
  CstPortabImprecis = 'Référence imprécise';
  CstPortabArchive = 'L''article est archivé';

  CstPortableVide = 'Intégration des articles terminée';
  CstPourlevidage = 'Veuillez enregistrer vos modifications avant de vider le portable';
  CstDebutVidage = 'Vidage du portable en cours...';
  CstErrCom = 'Le Port de communication n''est pas valide';

  //Bruno 05/05/2003

  LocHeureRetour = 'Impossible pour une location à la journée, il est plus de §0 ';
  LocHeureRetourBis = 'Attention le retour avant §0 est annulé...';

  LocDejaEnLoc = 'Attention cet article est déjà en location...';
  LocPasSorti = 'Impossible, cet article n''est pas en cours de location...';
  LocPasLoc = 'Impossible, vous n''avez pas de location en cours...';
  LocRetourTotal = 'Confirmez-vous le retour de toutes les locations en cours?';
  LocDejaPresent = 'Attention cet article est déjà présent dans le bon de location en cours...';
  locpassupligne = 'Impossible, cet article est déjà enregistré...';
  LocSupLC = 'Confirmez-vous la suppression de la location de cet article?';

  CstVersEncAEcheance = 'Versement des encaissements arrivés à échéance';
  CstPasencaissementAtt = 'Aucun encaissement en attente';

  CstInitInventaire = 'Initialisation du module inventaire en cours...';

  SupprCb = 'Confirmez la suppression du Code à Barres sélectionné';
  ExportCPT = 'Export comptable';
  ErrExportCpt = 'Liste des comptes en erreur';

  PasEnEuro = 'Cette partie du programme n''est accessible' + #13 + #10 +
    'que lorsque la devise active est la devise de travail définie...   ';
  CstCptFacture = 'Toutes les factures du §0 au §1' + #13 + #10 +
    'vont être clôturées !... Faut-il continuer ?';
  NoGoodDevise = 'IMPOSSIBLE d''accéder à votre demande' + #13 + #10 +
    'car la devise en cours n''est pas la devise de référence de vos données...   ';
  HintBtnPost = '[F12] Valider les modifications effectuées';
  CstHistoCoffre = 'Historique de §0 - §1 : du §2 au §3';
  CstCoffreDebut = 'Solde pour le §0';
  CstgestCoffre = 'Mouvement(s) du coffre';
  HintChpBtn = '[F4 ou Double Clic] Ouvre la liste des choix possibles...';
  CoffreChangeTab = 'Pour changer d''onglet il est d''abord nécessaire d''avoir enregistré les saisies en cours...';
  CptCltVide = 'Aucun compte client à afficher en rapport avec votre sélection...';
  LabVisuCptClt = 'Comptes clients au §0';
  CstCaVendHeureDateLib = 'Caisse : CA horaire par vendeur du §0 au §1  -  ';
  CstCaJourHeureDateLib = 'Caisse : CA horaire par jour du §0 au §1  -  ';

  VendeurOblig = 'Il faut cocher au moins un vendeur !...' + #13 + #10 +
    '( Sans vendeur défini il ne peut pas y avoir de réponse à votre demande )';

  VendIndefini = 'Vendeur non défini';
  LabTKl = 'Ticket';
  LTDateLib = 'Liste des Tickets du §0 au §1  -  ';
  DetailTKL = '[Double clic] Détail du ticket pointé';
  MessChargeLT = 'Chargement de la liste des tickets...';
  MessChargeCaVend = 'Chargement du CA par vendeur...';

  // RV le 28-04-2003
  CstPortableOk = 'Le portable s''est bien vidé, vous pouvez l''utiliser';

  CstInvAbandon = 'Abandonner la fin de comptage.';

  CstInvVide = 'actuellement, Vous n''avez aucun modèle dans l''inventaire';
  CstInvPlein = 'actuellement, Vous avez %s modèles dans l''inventaire';

  MessChargeJcaisse = 'Construction du journal de caisse...' + #13 + #10 + 'Merci de patienter le temps de sa mise en place...';
  ChxPosteOblig = 'Il faut cocher au moins un Poste !...' + #13 + #10 +
    '( Sans Poste défini il ne peut pas y avoir de réponse à votre demande )';

  MessChargeNN1 = 'Chargement de l''analyse N / N-1...';
  HintPreco = '[F5] Insérer le modèle de la ligne en cours dans le bloc note de pré-commande...';
  HintAffChx = '[F7] Afficher / Masquer la zone de sélection...';
  HintBrnPreco = '[F5] Insérer le modèle de la ligne en cours dans le bloc note de pré-commande...';
  HintBtnUndo = 'Remettre la configuration d''affichage par défaut';
  DoubleArt = '[Double clic] Ouvre la fiche du modèle pointé...';
  SelPeriode = '[Double Clic] Sélection de la période';
  TipPumpOblig = 'Vous n''avez sélectionné aucun mode de calcul de la marge !... ';
  TipVteOblig = 'Vous n''avez sélectionné aucun type de vente !... ';
  PanMessFiltre = 'Attention : si vous ne ciblez pas votre demande sur une sélection précise la construction de cette étude peut prendre plusieurs minutes ';
  RalMagOblig = 'Il faut cocher au moins un magasin !...' + #13 + #10 +
    '( Sans magasin défini il ne peut pas y avoir de réponse à votre demande )';
  RalDateLivOblig = 'Date de livraison obligatoire.';
  RalFournisseurOblig = 'Il faut sélectionner au moins un fournisseur !...' + #13 + #10 +
    '( Sans fournisseur défini il ne peut pas y avoir de réponse à votre demande )';
  RalEtatVide = 'L''état correspondant à votre sélection est vide ...';
  //   rv

  EtatVide = 'Aucune réponse pour l''état que vous avez demandé !' + #13#10 + 'Liste vide...';
  LocNkReserved = 'Suppression impossible : cet élément de la nomenclature ne peut pas être supprimé !...';
  YaProdDedans = 'Suppression impossible !... Il y a des offres commerciales référencées...';
  NKCapGesLoc = ' Gestion de la nomenclature de location...';
  NkLocCapListart = ' Nomenclature Loc & liste des offres commerciales...';
  NkLocCapNormal = 'Nomenclature de location';
  // rv 16/04/2002
  CstSaisieCodeBarre = 'Pour pouvoir saisir des codes barres ,' + #13 + #10 +
    'il faut d''abord valider [F12] ou abandonner la fiche en cours de saisie ';
  // Bruno 10/04/2003
  cstFichePrinc = 'Fiche' + #13 + #10 + '[F10]';
  cstFicheDivers = 'Divers' + #13 + #10 + '[F11]';
  cstFicheStation = 'Station' + #13 + #10 + '[F12]';


  TipConsoOblig = 'Vous n''avez sélectionné aucun type de consommation !...';
  NeedValidConso = 'Pour changer d''onglet il est d''abord nécessaire d''enregistrer ou abandonner la consommation en cours de saisie...';
  ArtDoArchive = 'Modèle(s) archivé(s)';
  ArtDejaArchive = 'Modèle(s) déjà archivé(s)';
  ArtCdeArchive = 'Modèle(s) non archivé(s) car présent(s) en commande non clôturée';
  ArtStkArchive = 'Modèle(s) non archivé(s) car en stock';
  CstARCYaDesCom = 'Modèle(s) non archivé(s) car présent(s) en commande non clôturée';
  CstARCYaDesDev = 'Modèle(s) non archivé(s) car présent(s) en devis non clôturé';
  CstArchivePasListe = 'Aucun Modèle ne peut être archivé dans votre sélection';
  CstARCYaDuStock = 'Modèle(s) non archivé(s) car en stock';
  CstARCWeb = 'Modèle(s) non archivé(s) car activé sur le web';
  // 11 lignes déplacées

  // RV 09/04/2003
  ChangeConfigCour = 'Confirmez le changement de NIVEAU UTILISATEUR du Magasin...  ' + #13 + #10 +
    'Niveau actuel : §0' + #13 + #10 + 'Nouveau niveau : §1';
  NomNiveauOblig = 'Le niveau d''activation du module est obligatoire';
  ConfirmDelModule = 'Confrmez la suppression du contrôle de module [ §0 ]';
  NomModuleOblig = 'Le nom du module est obligatoire...   ';

  // Bruno 04/04/2003

  cstProduit = 'Offre';
  cstEchange = 'Echange' + #13 + #10 + 'F12';
  cstRetourProduit = 'Retour' + #13 + #10 + 'F10';
  cstRetourTotal = 'Retour' + #13 + #10 + 'Total F9';
  cstRetourVolee = 'Retour' + #13 + #10 + 'Volee F11';
  cstDetailProduit = 'Détail' + #13 + #10 + 'F7';
  cstAbandon = 'Abandon' + #13 + #10 + 'Loc.';

  Location = 'Location';

  // RV 02-04-2003
  GenereTMPduFiltre = 'Recherche des modèles correspondant à vos critères de sélection...';
  TabNoNegaValue = 'La saisie de quantités négatives n''est pas autorisée...';
  TabToBigValue = 'Vous avez dû saisir un code à barre!... La quantité maximum autorisée est de "99 999"   ';

  ValidTransRap = 'Enregistrer la totalité des transferts rapides saisis ?...' + #13 + #10 +
    '( Les lignes avec une quantité à "0" ne seront pas prises en compte )';
  AbandonTransRap = 'Abandonner la totalité des transferts rapides saisis ?...';
  RvSupprLigne = 'Confirmez la suppression de la ligne sélectionnée...';

  // RV 18/03/2003
  ReorgAff = 'Réorganisation de l''affichage...   ';
  // ****************
  CsDevis = 'Devis';
  CsRal = 'Gestion des R.à.L';

  AffectCollec = 'A la validation finale tous les modèles ajoutés dans le document seront associés à la collection : §0';
  SupprColDef = 'Confirmez qu''à la validation finale' + #13 + #10 +
    'aucune collection ne doit être associée aux modèles ajoutés dans le document!...';
  //---------------
  CstCumulEnc = 'Cumul';
  CstClientDivers = 'Divers : (Client Non identifié)';

  ExpartArtTraites = 'Nombre d''informations traitées : §0     ';
  // 1 ligne déplacée
  ProcessArch = 'Confirmez l''archivage des modèles listés...';
  // RV 02/03/2003
  HintBtnGroupart = 'Activer / Désactiver le groupement sur les modèles';
  DefCritSel = 'Définissez les critères d''étude de l''analyse...';
  RalDoArch = 'Confirmez l''archivage demandé...';
  CarnetCdeNoExe = 'Lorsqu''aucun exercice commercial n''est défini,' + #13 + #10 +
    'seules les commandes NON CLOTUREES sont prises en compte...' + #13 + #10 + #13 + #10 +
    'Souhaitez-vous continuer ?...';

  TousFourn = 'Tous fournisseurs';
  RalFOURNOblig = 'Il est impératif de définir quels fournisseurs étudier !...';

  cstQte = 'QTE +1';
  cstSousTotal = 'S/ TOTAL';
  cstSupLigne = 'Sup Ligne' + #13 + #10 + 'courante';
  cstPseudo = 'Pseudo';
  cstSupTicket = 'Abandon' + #13 + #10 + 'TICKET';
  cstAttente = 'Attente';
  cstReglement = 'Règle' + #13 + #10 + 'ment [F7]';
  cstAcompte = 'Acompte';
  cstRembourser = 'Rembour' + #13 + #10 + 'ser [F9]';
  cstValid = 'Valid';
  cstAnnul = 'Annul';
  cstCf = 'Carte' + #13 + #10 + 'Fidelité';
  cstEtiqCB = 'Etiquette' + #13 + #10 + 'C.B.';
  cstReajust = 'Réajust' + #13 + #10 + 'Compte';
  cspBtnEspeces = 'Espèces';
  cspBtnCheques = 'Chèques';
  cspBtnCB = 'CB';
  cspBAI = 'B.Achat' + #13 + #10 + 'Interne';
  cspBAE = 'B.Achat' + #13 + #10 + 'Ext.';
  cspCPTCLI = 'Compte' + #13 + #10 + 'Client';
  cspResteDu = 'Reste' + #13 + #10 + 'du';
  cspAC = 'Autres' + #13 + #10 + 'cartes';
  cspVirement = 'Virement';
  cspCV = 'Chèques' + #13 + #10 + 'Vacances';
  cspRegul = 'Régul.' + #13 + #10 + 'Caisse';
  cspDepense = 'Dépense';
  cspReedition = 'Réédition' + #13 + #10 + 'TICKET';
  cspAnnulTCK = 'Annul.' + #13 + #10 + 'TICKET';
  cspTC = 'Ouvre' + #13 + #10 + 'tiroir';
  cspBL = 'Transfert' + #13 + #10 + 'B.L.';
  cspCD = 'Chèque' + #13 + #10 + 'Diff [F11]';
  cspAmex = ' AMEX' + #13 + #10 + ' [F10]';
  cspPNF = '   PNF';
  cspCCI = 'Carte Kdo' + #13 + #10 + 'Intersport';
  cspCadhoc = ' CADHOC';
  cspAurore = ' CARTE' + #13 + #10 + 'AURORE';
  cspBF = '   Bon' + #13 + #10 + '   FID';
  cspTG = '   TIR' + #13 + #10 + 'GROUPE';
  cspRemChq = 'Rbt' + #13 + #10 + 'Chèque';
  cspHAVAS = 'HAVAS';
  cspBonAccor = 'BON' + #13 + #10 + 'ACCOR';
  cspBEST = 'BEST';
  cspED = 'ELEGANCE ET' + #13 + #10 + 'DISTINCTION';
  cspCU = 'COMPLIMENT UNIVERSEL';
  cspSP = 'SHOPPING' + #13 + #10 + 'PASS';
  cspTI = 'TICKET' + #13 + #10 + 'INFINI';
  cspTH = 'TICKET' + #13 + #10 + 'HORIZON';
  cspKDO = 'KADEOS';
  cspBonKy = 'BON' + #13 + #10 + 'KYRIELLES';
  cspCC = 'CADO' + #13 + #10 + 'CHEQUE';
  cspCbCof = 'CARTE' + #13 + #10 + 'COFINAGA';
  cspSOC = 'SPIRIT OF' + #13 + #10 + 'CADEAU';
  cspCbKDO = 'CADO' + #13 + #10 + 'CARTE';
  cspCbKy = 'CARTE' + #13 + #10 + 'KYRIELLES';
  cspSB = 'Suite des' + #13 + #10 + 'boutons';

  RalSaisOblig = 'Il faut saisir au moins une saison !...' + #13 + #10 +
    '( Sans saison définie il ne peut pas y avoir de réponse à votre demande )';
  RalModifOblig = 'Il faut saisir au moins un statut !...' + #13 + #10 +
    '( Sans statut défini il ne peut pas y avoir de réponse à votre demande )';

  annulRapLine = '§0 Commande(s) annulé(es) et archivé(es)' + #13 + #10 +
    '§1 Commandes(s) partiellement annulé(es)' + #13 + #10 + #13 + #10 +
    'Désirez-vous imprimer un rapport d''annulation ?';

  annulRap = '§0 Commande(s) ont été annulées et archivées' + #13 + #10 + #13 + #10 +
    'Désirez-vous imprimer un rapport d''annulation ?';
  DbgRalHint = '[INS][Glisser-Déplacer] Copie la ligne en cours dans la sélection... [Double Clic][F4] Fiche modèle';
  DbgSelRalHint = '[SUPPR][Glisser-Déplacer] Supprime la ligne en cours de la sélection... [Double Clic][F4] Fiche modèle';

  // 4 ligne déplacées

  ValidRapidTrans = 'Enregistrement des §0 transferts saisis par code à barres...';
  // ************************
  CstCptProb = 'Problème sur le compte ';
  CstCptVente = 'Vente ';
  CstCptTVA = 'TVA ';
  CstCptCltdiv = 'CLT DIV';
  CstCptCltdivers = 'Client divers';
  CstCptClt = 'CLT ';
  CstCptInfo = 'Information exportation comptable';
  CstCptGeneraux = 'Les comptes généraux doivent être renseignés pour faire l''export comptable';
  CstCptSessions = 'Toutes les sessions de caisse doivent être fermées pour faire l''export comptable';
  CstCptRegCltDiv = 'Règlement Clt Div';
  CstCptVRS = 'VRS ';
  CstCptDepense = 'DEPENSE';
  CstCptIrrecouvrable = 'Client Irrécouvrable';
  CstCptTropPaye = 'Client trop payé';

  BonTransfert = 'Bon de transfert';
  RechSurNom = 'Chrono non trouvé... Rechercher sur le nom, la référence ?...';
  ValidExpertTrans = 'Confirmez l''enregistrement du transfert en cours...';
  CancelExpertTrans = 'Confirmez l''abandon du transfert en cours...';
  //------------------
  TransLabMagCoul = 'Stock avant transfert du Magasin §0 - Couleur §1';
  NoTransTailPossible = 'Magasin §0' + #13 + #10 + 'Il n''y a pas de stock à transférer pour cette Taille/Couleur!...';
  PlusDeTransTailPossible = 'Magasin §0' + #13 + #10 + 'Tout le stock de cette Taille/Couleur a déjà été réparti en transfert !...';
  TransTailPossibleIsNega = 'Magasin §0' + #13 + #10 + 'Le stock de cette Taille/Couleur ne doit pas devenir négatif' + #13 + #10 +
    'La quantité maximum que vous pouvez transférer est de [ §1 ]';

  UniColor = 'Unicolor';
  // ********************************* RV

  ConsoVide = 'Aucune consommation diverse à enregistrer...';
  ValidMajStk = 'Confirmez l''enregistrement du réajustement de stock' + #13 + #10 +
    'Motif : §0';
  NeoStock = 'Nouveau stock';

  DefConso = 'Motif de la consommation diverse...';
  MessSupTailleTTter = 'Impossible de supprimer cette taille,' + #13 + #10 + '   car elle a déjà été utilisée en gestion de ce modèle...';

  // Etiquettes

  RecepEtikMess = 'Valider le bouton correspondant à votre choix... ';
  RecepEtikP1 = 'ATTENTION CE MODELE EXISTE EN STOCK A UN PRIX DE VENTE DIFFERENT';
  RecepEtikP2 = 'SI VOUS choisissez d''étiqueter cette ligne de réception';
  RecepEtikP3 = 'Des étiquettes seront AUTOMATIQUEMENT IMPRIMEES pour le STOCK EXISTANT';

  //********************************************** déplacé

  CapNotEtik = 'Modèles pour lesquels aucune étiquette ne sera générée (pas de stock)...';
  CstPasDeTicket = 'Aucun ticket dans votre sélection';
  CstProbVersion = 'VOTRE POSTE N''EST PAS A JOUR'#10#13 +
    'Si c''est un portable : Lancer le Live-Update'#10#13 +
    'Si c''est un poste : vérifier que vous lancez Ginkoia à travers l''icône du bureau'#10#13#10#13 +
    'Autrement veuillez contacter la société GINKOIA SA';

  CapLab3mois = 'Après 3 mois il n''est plus possible d''ajouter de nouveaux modèles référencés ni de modifier ceux existants';
  InitGenerEtik = 'Génération de la liste des étiquettes à imprimer...';
  TitreEtikGener = ' Réimpression générique des étiquettes';
  ReinitPrecos = 'Confirmez la réinitialisation du bloc note de pré-commande...';
  SbtnOkPrecoHint0 = 'Quitter en enregistrant les modifications effectuées';
  SbtnOkPrecoHint1 = 'Commander le modèle pointé par la ligne en cours';
  NoArtprecoToImport = 'Aucun modèle distribué par ce fournisseur dans le bloc note de pré-commande...';
  PrecosHintGes = '[Suppr] Supprimer la ligne en cours';
  PrecosHintGesCde = '[Double clic] Sur une Qté sélectionne le modèle [Suppr] Supprimer la ligne en cours';
  PrecoDelart = 'du modèle ';
  PrecoDuBloc = 'du bloc note de pré-commande';
  NoPossPreco = 'Impossible d''ajouter ce modèle dans le bloc note de pré-commande !...' + #13 + #10 +
    '( Nota : ce bloc note n''accepte ni les modèles archivés ni les Pseudos... )';

  // RV 24/01/2003
  CapArtRef = 'Modèles non archivés';
  MessChargeArtRef = 'Chargement de la liste des modèles... ';

  VideselExpertArt = 'Confirmer la réinitialisation complète de la liste de sélection en cours...   ';
  Traitencours = 'Traitement des données en cours...';

  ToutPref = 'Ajouter tous les modèles de votre sélection à la liste préférentielle ?...';
  MetStkId = 'Affectation d''un stock idéal de';
  StkIdCap = ' Gestion du stock idéal...';
  StkIdLab = 'Stock idéal à affecter aux modèles listés';
  ConfStkId = 'Confirmez l''affectation d''un stock idéal de [ §0 ] aux modèles listés';

  ChangeClasse = 'Confirmez l''affectation §0 [§1] aux modèles listés';
  ActionClasse = 'modèles affectés §0';

  SClaVide = '"Pas de classe"';
  ChangeTCT = 'Confirmez l''affectation du type comptable §0 aux modèles listés';
  ActionTCT = 'Modèles affectés au taux de Type Comptable';

  OnPub = 'Activation de la coche "En Publicité"';
  OutPub = 'Désactivation de la coche "En Publicité"';

  MetPub = 'Confirmez qu''il faut ajouter "En Publicité" tous les modèles listés';
  RetirePub = 'Confirmez qu''il faut retirer la "Publicité" de tous les modèles listés';

  ChangeTVA = 'Confirmez l''affectation du taux de TVA §0 aux modèles listés';
  ActionTVA = 'Modèles affectés au taux de TVA';

  OnFid = 'Activation de la coche "En Fidélité"';
  OutFid = 'Désactivation de la coche "En Fidélité"';

  MetFidelite = 'Confirmez qu''il faut ajouter "En Fidélité" tous les modèles listés';
  RetireFidelite = 'Confirmez qu''il faut retirer la "Fidélité" de tous les modèles listés';

  ReinitCollec = 'Confirmez la réinitialisation de toutes les collections pour les modèles listés...';
  ReinitCollection = 'Réinitialisation de toutes les collections';
  ReinitGroupe = 'Confirmez la réinitialisation de tous les groupes pour les modèles listés...';
  ReinitGroupes = 'Réinitialisation de tous les groupes';
  ChangeGroupe = 'Confirmez l''affectation du groupe §0 aux modèles listés';
  SupprGroupe = 'Confirmez la suppression du groupe §0 pour les modèles listés';
  ActionGroupe = 'Modèles placés dans le groupe';
  ActionDelGroupe = 'Modèles retirés du groupe';

  ScatVide = '"Pas de Sous-Catégorie"';
  SGreVide = '"Pas de Genre"';

  ActionSF = 'Modèles placés dans la sous famille';
  ActionCollec = 'Modèles placés dans la collection';
  ActionDelCollec = 'Modèles enlevés de la collection';
  ActionGenre = 'Modèles affectés au genre';
  ActionScat = 'Modèles placés dans la Sous-Catégorie';
  ChangeSCat = 'Confirmez le déplacement des modèles listés vers la Sous-Catégorie' + #13 + #10 + '§0';
  ChangeGenre = 'Confirmez l''affectation du genre §0 aux modèles listés';
  ChangeCollec = 'Confirmez l''affectation de la collection §0 aux modèles listés';
  SupprCollec = 'Confirmez la suppression de la collection §0 pour les modèles listés';
  ChangeSF = 'Confirmez le déplacement des modèles listés vers la Sous-Famille' + #13 + #10 + '§0';
  CapNt = 'A ne pas traiter';
  CapPref = 'Préférentiels';

  YaSelPref = 'Faut-il conserver les modèles notés dans la liste "préférentielle" ?' + #13 + #10 +
    '( Ces modèles sont représentes sur un fond jaune )';

  ViderSelNT = 'Réinitialiser la liste des modèles "à ne pas traiter" ?...' + #13 + #10 +
    '( Ces modèles sont représentés sur un fond gris )';
  ChangeSfArtCap = ' Nouvelle Sous-Famille des modèles listés...';
  SupSelArt = 'Voulez-vous enlever de la sélection tous les modèles sélectionnés' + #13 + #10 +
    '( ou tous les modèles du groupe s''il s''agit d''une ligne de groupe )';

  ViderSelArt = 'La liste de sélection "préférentielle" permet de conserver' + #13 + #10 +
    'les modèles qu''elle identifie lors d''une nouvelle sélection générique...' + #13 + #10 +
    '( Ces modèles sont représentes sur un fond jaune )' + #13 + #10 + #13 + #10 +
    'Faut-il vider cette liste ?...';

  RienAAjouterSelArt = 'Aucun nouveeau modèle à ajouter à votre sélection !...';
  DejaSelArt = 'Ce modèle à déjà été rajouté à votre sélection...';
  SelMaxi900 = 'Vous ne pouvez avoir que 800 modèles "Préférentiels" dans votre sélection';
  SelMaxi900Del = 'Vous ne pouvez "Retirer" que 800 modèles au maximum à votre sélection';

  TipDev106 = 'Pour Information';
  NomSocOblig = 'La saisie du nom de la société est obligatoire...';
  DataStrObligatoire = 'Pour pouvoir enregistrer, la saisie d''une donnée significative est obligatoire...';
  // RV 31/12/2002

  NoDelDevCateg = 'Impossible de supprimer cette catégorie car elle est référencée dans un document !';

  AutoEnvoye = 'Voulez-vous que les (ou le) documents venant d''être imprimés soient notés comme "Expédiés" ?...  ';
  AnnulNotImprimed = 'Ce bon d''annulation n''a pas été imprimé !' + #13 + #10 +
    'Faut-il néanmoins l''accepter comme "Expédié" ?...';

  // Bruno 30/12/2002
  TOTALAfficheur = 'TOTAL';

  PrepListarchCde = 'Préparation de la liste des documents à archiver...';
  Enregencours = 'Enregistrement du document en cours...   ';
  // RV 17-12-2002
  ChargeNoSupGros = 'Suppression de la coche grossiste impossible...' + #13 + #10 +
    '(Chargement de la liste des modèles concernés )';
  MessNoSupCocheGros = 'Ce grossiste est déclaré comme fournisseur principal des modèles listés ci-dessous...' + #13 + #10 +
    'et la marque de ces articles n''est pas distribuée par lui !';

  SolutionArtSupGlos = '2 Solutions pour pouvoir décocher l''option "Grossiste" : ' + #13 + #10 +
    '1. Déclarer un autre fournisseur principal pour ces articles...' + #13 + #10 +
    '2. Déclarer les marques de ces articles comme distribuées par ce fournisseur...';

  CapListartPbSupGlos = 'suppression de la coche "Grossiste" impossible ...';

  IsFouPrinArt = 'Impossible : ce grossiste est noté comme fournisseur principal' + #13 + #10 +
    'des articles de marques qui ne sont pas notées comme distribuées par lui...';
  ISInCde = 'Impossible : ce grossiste a en commande (non clôturée)' + #13 + #10 +
    'des articles de marques qui ne sont pas notées comme distribuées par lui...';
  ISInRecep = 'Impossible : ce grossiste a en réception (non clôturée)' + #13 + #10 +
    'des articles de marques qui ne sont pas notées comme distribuées par lui...';
  ISInRetour = 'Impossible : ce grossiste a en retour fournisseur (non clôturée)' + #13 + #10 +
    'des articles de marques qui ne sont pas notées comme distribuées par lui...';
  ISInAnnul = 'Impossible : ce grossiste a en annulation de commande (non clôturée)' + #13 + #10 +
    'des articles de marques qui ne sont pas notées comme distribuées par lui...';

  //Bruno 16/12/2002
  ImpressionEnCours = 'Impression en cours...';

  AnulLineCde = 'Annulation partielle de commande';

  ConfirmAnnulLineCde = 'Confirmez l''annulation des §0 lignes de commande sélectionnées' + #13#10 +
    'ATTENTION : Une fois effectuée cette opération est irréversible !';

  AnnulTravEnCours = 'Impossible de changer d''onglet tant que vous n''avez pas Terminé où Abandonné le travail en cours';
  LibCdeNo = 'Cde N°';
  LibBaNo = 'Annul N°';
  LabPanSelLineAnnul = 'Lignes de Cde à annuler';

  // rv 12/12/2002
  CdeArchiveAuto = 'Il y a §0 commandes sans "Reste à Livrer...' + #13 + #10 +
    'Confirmer l''archivage de ces commandes...    ';
  NeedArchiveAnnul = 'Ce bon d''annulation est noté comme "Expédié" ... ' + #13 + #10 +
    'Faut-il l''archiver ? ';
  RalThereNonEnoye = 'Dans votre sélection il y a des documents notés comme' + #13 + #10 +
    'NON EXPEDIES' + #13 + #10 + 'Faut-il continuer l''archivage ?...';
  ArchivageRal = 'Archivage des bons d''annulation en cours...';

  AnnulTitreListe = '   Liste des bons d''Annulation';
  AnuIntLibCum = 'Global annulation';
  CdeAnnul = 'Génération des bons d''annulation en cours ...     ';
  CapBtnGenerRAL = 'Générer les annulations';
  CapBtnCloseAnnul = 'Terminer l''annulation';
  MessNumBonAnnul = 'Bon d''annulation N° ';
  GenerikCharge = 'Chargement en cours ...           ';

  // Ligne modifiées
  HintNextRec = '[Ctrl + N] Fiche suivante...';
  HintPriorRec = '[Ctrl + P] Fiche précédente...';
  //****************

  PastFromGlos = 'Copie des données en cours ...    ';
  NosupprpxBase = 'Le prix de base d''un article est obligatoire !' + #13 + #10 +
    'Suppression impossible ...';
  HintVideselAnnul = 'Abandonner toute la sélection en cours (la liste des commandes à annuler est réinitialisée)';
  HintVideselRap = 'Clôturer le rapport d''annulation...';

  LabPanSelAnnul = 'Commandes à annuler';
  LabRapAnnul = 'Rapport d''annulation';

  MessPbAnnul = 'Problème lors de l''annulation';
  LibAnulRal = 'Annulation des R.à.L';
  LibAnulCde = 'Annulation de le commande';

  NoRalAtraiter = 'Liste vide ... Aucune commande à traiter !';
  ConfirmAnnulCde = 'Confirmez l''annulation des §0 commandes sélectionnées' + #13#10 +
    'ATTENTION : Une fois effectuée cette opération est irréversible !';
  ConfirmAnnulCdePlus = 'Un bon d''annulation différent sera généré pour chacune des commandes traitées';

  ConfirmRalVidesel = 'Abandonner toute la sélection en cours ?...';
  LibExeCial = 'Exercice';

  //Bruno 28/11/2002
  TitListeTicket01 = 'Réédition d''un ticket';
  TitListeTicket02 = 'Annulation d''un ticket';
  TitListeTicket03 = 'Régularisation de caisse sur un ticket précis';
  TitListeTicket04 = 'Liste des tickets';
  ImpBandeControle = 'Impression de la bande contrôle?';
  ImpSession = 'SESSION No :';

  Session = 'Session n° ';
  Lignepasvalide = 'Validation impossible, vous n''êtes pas positionné sur une ligne de ticket...';

  // Hervé au 25-11-2002
  NomMagOblig = 'Le nom du magasin est obligatoire !...  ';
  NoAgsect = 'Une catégorie de ressource doit obligatoirement être associée à un type !...';
  AgCatUsed = 'Suppression impossible car cette catégorie est utilisée dans vos données...';
  AgSectHasCat = 'On ne peut pas supprimer un type de ressource ayant des catégories définies...';
  JzGen = 'Général';
  jzDeleteRes = 'Confirmez la suppression de la ressource sélectionnée ...' + #13 + #10 +
    'ATTENTION : cette opération est irréversible !...';
  HintResColor = '[F4] [CLIC] Ouvre la liste associée   [Flèche Haut/Bas] Fait défiler les choix possibles';
  NoRessName = 'Le nom de la ressource à gérer est obligatoire...';

  // Bruno 23/11/2002
  TrfBLImpossible = 'Traitement impossible, vous avez déjà réalisé des encaissements,' + #13 + #10 +
    'ou des opérations sur le compte de votre client...';

  CstProbTrfPort = 'Problème de transfert : tous les articles ne sont pas récupérés ' + #13#10 +
    '%s lignes d''articles transmises pour %s lignes d''articles attendues' + #13#10 +
    'Conserver quand même la saisie ?';
  // Pascal 20/11/2002
  CstAttention = ' Avertissement...';
  CstAcrobatMessage = '      Veuillez installer une version d''Acrobat Reader(TM) ' + #13 + #10 +
    ' Une version est disponible sur le CD d''installation de Ginkoia ';
  //Bruno 15/11/2002
  TransBL = 'Confirmez-vous le transfert en bon de livraison des articles en cours?';
  PasTransBL = 'Transfert impossible le ticket est vide...';

  // rv 14-11-2002

  TipDev102 = 'Fait';
  TipDev105 = 'Signé';
  TipDev108 = 'Sûr';

  YaKunFam = 'Chaque Rayon doit obligatoirement avoir au moins une Famille ...' + #13 + #10 +
    'Cette Famille ne peut être supprimée qu''en supprimant son Rayon...';
  YaKunSF = 'Chaque Famille doit obligatoirement avoir au moins une Sous-Famille ...' + #13 + #10 +
    'Cette Sous-Famille ne peut être supprimée qu''en supprimant sa Famille voire son Rayon...';

  YaArtDedans = 'Suppression impossible !... Il y a des articles référencés...';
  NKOrdre = ' [Ctrl + Flèche Haut/Bas] Remonter / Descendre l''élément dans sa liste';
  NkRayVersHaut = '[Ctrl+Flèche Haut] Déplacer le rayon d''un cran vers le haut dans la liste des rayons';
  NkRayVersBas = '[Ctrl+Flèche Bas] Déplacer le rayon d''un cran vers le bas dans la liste des rayons';
  NkFamVersHaut = '[Ctrl+Flèche Haut] Déplacer la famille d''un cran vers le haut dans la liste des familles';
  NkFamVersBas = '[Ctrl+Flèche Bas] Déplacer la famille d''un cran vers le bas dans la liste des familles';
  NkSFVersHaut = '[Ctrl+Flèche Haut] Déplacer la sous-famille d''un cran vers le haut dans la liste des sous-familles';
  NkSFVersBas = '[Ctrl+Flèche Bas] Déplacer la sous-famille d''un cran vers le bas dans la liste des sous-familles';

  LabArtVide = 'Peut être masqué car ne référence aucun article.';
  LabArtNoVide = 'Ne peut être masqué car référence des articles.';

  LibFooterNKGTS = ' [INS] Ajouter  [SUPPR] Supprimer  [Echap] Fermer';

  // BRUNO 13/11/2002
  BLNumero = 'Bon de livraison : ';
  // RV 12-11-2002
  CapTxtFactor = 'Texte associé au paiement par factor';
  TxtPmtFactor = 'Veuillez effectuer votre paiement directement à l’ordre de GARANT SCHUH qui le reçoit par subrogation';
  LabNkGinko = 'Nomenclature des articles';
  AlerteSelNK = 'Vérifiez la pertinence de votre sélection !...' + #13 + #10 +
    'Vous avez au moins une catégorie de famille sélectionnée' + #13 + #10 +
    'qui rend certains de vos choix de Rayons ou de Secteurs "Inopérants"...';

  DelCollec = 'Confirmez la suppression de la collection §0';
  NoGoodSexe = 'Pour les codes de sexe les valeurs permises sont :' + #13 + #10 +
    '1 = HOMME' + #13 + #10 +
    '2 = FEMME' + #13 + #10 +
    '3 = ENFANT';
  NoNameGRE = 'La saisie d''un nom de Genre est obligatoire...';
  NoNameCTF = 'La saisie d''un nom de Catégorie est obligatoire...';
  NoNameCAT = 'La saisie d''un nom de Sous-Catégorie est obligatoire...';
  NoNameSEC = 'La saisie d''un nom de Secteur est obligatoire...';
  NoNameGRP = 'La saisie d''un nom de Groupe est obligatoire...';
  NoNameCOL = 'La saisie d''un nom de Collection est obligatoire...';
  NoLibMrg = 'La saisie d''un mode de règlement est obligatoire...';
  NKCapGes = ' Gestion de la nomenclature des Rayons...';
  NoSecNk = '{ Secteur non défini... }';
  NoAxeDefini = '{ Axe non défini... }';
  NoActiviteDefini = '{ Domaine non défini... }';
  NoSecDefined = 'Cet expert n''est accessible que lorsque des secteurs sont définis !...';
  NoCTFDefined = 'Cet expert n''est accessible que lorsque des catégories de famille sont définies !...';


  ClasNeoItem = 'Créer un nouveau thème dans une classe';
  BeforeDElCla = 'Confirmez la suppression du thème de classement §0  ';
  NomClasseOblig = 'Il est indispensable de définir un nom de classement significatif...';
  NomThemeOblig = 'Il est indispensable de définir un nom de thème de classement significatif...';
  CreClas = 'Créer un nouveau thème dans la classe §0';
  ClasModifName = 'Modifier le nom du classement sélectionné';
  ClasModifItem = 'Modifier le nom du thème de classement sélectionné';
  ClasDeleteItem = 'Supprimer le thème de classement sélectionné';
  ClasArt = 'Articles';
  ClasClt = 'Clients Particuliers';
  ClasPro = 'Clients Professionnels';

  //Bruno 07/11/2002
  PasGroupeclient = 'Le paramétrage des groupes clients est inexistant...';
  PasGroupeCF = 'Le paramétrage des groupes clients fidélité est inexistant...';
  //Bruno 07/11/2002

  AffDetail = 'Vue Détaillée';
  AffSynth = 'Vue Synthétique';
  RecepCollecDef = 'Désirez-vous affecter automatiquement une "Collection" à tous les articles qui seront ajoutés dans ce Bon de Réception?...';
  ImpDevLib = ' Titre à imprimer sur le(s) document(s)';

  LibPeriodeOblig = 'La période d''étude n''a pas été définie ... ';
  LabDebetude = 'Depuis le §0';
  LabFinetude = 'Jusqu''au §0';
  AlerteMin = 'La période d''étude ne peut être antérieure à §0';
  AlerteMax = 'La période d''étude ne peut être postérieure à §0';
  AlerteDebSupFin = 'La date de début ne peut être postérieure à la date de fin !...   ';

  HintDate = '[F4] Ouvre le calendrier associé... [SUPPR] Vider la Date';
  CapDefFiltre = ' Conditions de filtrage définies...';
  TmpVide = 'Aucun article ne correspond aux conditions de filtrage définies !... ';
  cmbdropDown = '[F4] Ouvre la liste déroulante des choix possibles...';
  CapFRN = 'Fournisseur';
  ChargeFiltre = 'Chargement et initialisation des critères de filtrage...';

  //****************
  CstCltLstDet = 'Liste détaillée';
  CstCltLstDetWait = 'Attention l''affichage de cette liste prend du temps. Continuer ?';

  CapRay = 'Rayon';
  CapFam = 'Famille';
  CapSSF = 'S/Famille';
  DelDefFiltre = 'Supprimer tous les éléments sélectionnés ?...';
  PbgenerFiltre = 'Problème lors de la préparation du filtre ...';

  CapSid = 'Stock Idéal défini';
  CapFid = 'En Fidélité';
  CapMpx = 'Px Achat <> Taille';
  CapPVT = 'Tarif Magsin défini';
  CapFRC = 'Vente Fractionnée';

  CapCollection = 'Collection';
  CapGroupe = 'Groupe';
  CapFouPrin = 'Fournisseur';
  CapGTF = 'Grille de tailles';
  CapTVA = 'Taux de TVA';
  CapTCT = 'Type Comptable';
  CapTVT = 'Tarif de vente';
  CapGenre = 'Genre';
  CapArchive = 'Archivés';
  CapVirtuel = 'Pseudos';
  CapCatalogue = 'Catalogue Fournisseur';
  CapStN = 'Stock < 0';
  CapStP = 'Stock > 0';
  CapSt0 = 'Stock = 0';
  CapStk = 'Stock <> 0';

  SoveFltTit = ' Sauvegarder le filtre...';
  LabelSoveFlt = 'Donnez un nom à ce filtre';
  Nofiltertosave = 'Aucune définition de filtre à sauver ...     ';

  CapNk = 'Nomenclature';
  CapDomaine = 'Domaine commercial';
  CapAxe = 'Axe statistique';
  CapSecteur = 'Secteur';
  CapCateg = 'Catégorie';
  CapSousCateg = 'Sous Catégorie';
  CapMarque = 'Marque';

  HIntMemos = '[CTRL+ENTREE] Valide le champ... [Double Clic ou F4] Ouvre l''éditeur associé au champ';
  HIntMemosLS = '[ENTREE] Champ suivant... [Double Clic ou F4] Ouvre l''éditeur associé au champ';

  HintMemoRV = '[Double Clic] ou [F4] Ouvre l''éditeur de mémos associé';
  NegGarant = 'Code Garant';
  NegSumAcompte = 'Acompte';
  NegSumCdt = 'Conditions de règlement';
  NegSumNap = 'Net à Payer';
  NegSumSoitle = 'Soit le';

  MajFicMarques = 'Contrôle du fichier des marques' + #13 + #10 +
    'Quelques instants tout au plus...  Merci d''avance !';

  CdeRefreshToto = 'ATTENTION : ce contrôle n''est effectué que si vous avez ' + #13 + #10 +
    '   réellement constaté une anomalie dans le document ! ... ' + #13 + #10 +
    '   Faut-il procéder au contrôle ?';
  RefTotoFait = 'Contrôle et mise à jour des cumuls du document effectués...   ';

  //Pascal 29/10/2002
  CstSelectionDuAu = 'Votre sélection %s au %s';
  // RV 23-10-2002
  NegTetFactor = 'Code Garant';
  Negtetnum = 'Numéro';
  Negtetdate = 'Date';
  Negtetref = 'Référence';
  Negtetdes = 'Désignation';
  NegTetEmpl = 'Emplacement';
  Negtettva = 'TVA';
  Negtetqte = 'Qté';

  Negtetclt = 'Code Client';
  NegtetLabtva = 'N° TVA';
  Negtetcoul = 'Couleur';
  NegtetTail = 'Taille';
  NegtetRem = 'Rem';

  NegSumRemGlo = 'Remise globale';
  NegSumTvatx = 'Taux TVA';
  NegSumTvamt = 'Montant Tva';
  NegSumTvatoto = 'Totaux';

  NoGroupetoadd = 'Aucun groupe à ajouter à ce modèle...    ';
  NoCollectiontoadd = 'Aucune collection à ajouter à ce modèle...    ';

  DblClic = '[Double Clic]';
  LabMags = 'Magasin §0';
  LabArtMvt = 'Mouvements depuis la création du modèle';
  LabRecep = 'Réception';
  LabDocN = 'Doc N° :';
  LabQte = 'Qté :';
  LabStockA = 'Stock Aprés :';
  LabTransE = 'Transfert Entrant';
  LabTransS = 'Transfert Sortant';
  LabRetour = 'Retour Fournisseur';
  ArtPanStat = 'Période d''étude du §0 au §1';
  LabUnicolor = 'Unicolor';

  //Pascal 22/10/2002
  CltPart = 'PART';
  CltPro = 'PRO';
  CltStat = 'Historique d''achat de %s';
  CltStat2 = 'Statistique du client %s';
  CltList = 'Liste des clients';
  //Bruno 15/10/2002
  ChangTypCF_1 = 'Attention, vous venez de décocher le Type';
  ChangTypCF_2 = 'Cependant, vous avez';
  ChangTypCF_3 = 'clients qui l''utilisent.';
  ChangTypCF_4 = 'Si vous confirmez votre choix, vous devrez modifier manuellement' + #13 + #10 +
    'le type de la fidélité pour tous les clients concernés...';

  // RV 14/10/2002
  ArtPeriode1 = 'Période d''étude du §0 au §1';
  ChxArtDebEtude = 'Date de début d''étude';
  ArtDebEtude = 'Début d''étude';
  CapPrincipal = 'Principal';
  NoGoodPrefix = 'Le préfixe du code chrono doit obligatoirement être celui défini pour le magasin dorrespondant cet ordinateur...  ';
  NeedChrono = 'Vous n''avez pas défini un code chrono valide ...   ';
  NegMaxiLine = 'Impossible de valider cette ligne...' + #13 + #10 +
    'Elle dépasse le montant maximum possible ( TTC 910 000.00 )   ';
  HintDbgDoc2 = '[SUPPR] Supprimer la ligne [F2] Editer... la ligne en cours du document affiché';
  NoSelection = 'Aucune sélection en cours...    ';
  CapArtArch = 'Articles Archivés';
  AlerteStk = 'Le stock de cet article est négatif [§0]';
  AlerteStkIdeal = 'Le stock de cet article [§0] est inférieur au stock idéal [§1]';

  ImpdevTitle = ' Impression de Devis...';
  NegDateLim = 'Au delà de trois mois il n''est plus possible d''ajouter, de supprimer' + #13 + #10 +
    'ou de modifier les lignes se rapportant à des articles référencés...';

  // Bruno 10/10/2002
  MailDateValiditeIncoherente = 'La date de fin de validité est inférieure à la date de début...';

  // RV 04-10-2002
  NomModeleOblig = 'La saisie d''un nom de modèle est obligatoire !...';
  OuvreNeoModele = 'Nouveau modèle §0 créé [ N° : §1 ]' + #13 + #10 +
    'Voulez-vous afficher ce modèle à l''écran ?';
  CreaModele = ' Création d''un modèle...';
  NomCreaModele = 'Nom du nouveau modèle';

  NoLivrDev = 'La date de livraison prévue est obligatoire...';
  OpeNoRetour = '(ATTENTION : Cette opération est irréversible !...)';
  NegArchiveNoClot = 'Dans votre sélection, il y a des documents non clôturés !' + #13 + #10 +
    'Faut-il continuer et les archiver ?' + #13 + #10 +
    '( ATTENTION : l''archivage d''un document est IRREVERSIBLE !...)';

  // Bruno 03/10/2002
  MailClientDejaExistant = 'Ce client a déjà été sélectionné pour ce mailing...';
  MailDesiObligatoire = 'La saisie d''une désignation est obligatoire...';
  MailDateValidite = 'La saisie d''une date de validité est obligatoire...';

  // RV 26-09-2002
  HintFltPsc = 'Définir un filtre étendu...';
  LoadingFilter = 'Mise à jour filtre sur l''affichage des données ...';

  //@@Bruno  20/09/2002
  SupClientMailing = 'Confirmez-vous la suppression de ce client dans le mailing en cours?';

  // RV 20-09-2002
  YaKunItem = 'Chaque branche de la nomenclature doit avoir au moins 1 "enfant" ...' + #13 + #10 +
    'Pour suupprimer cet élément, il faut supprimer son "parent"...';
  HintDbgDoc = '[Ctrl+SUPPR] Supprimer la ligne [F2] Editer... la ligne en cours du document affiché';

  NkRayonUsed = 'Impossible de valider : il existe déjà un Rayon portant ce nom...';
  NkFamilleUsed = 'Impossible de valider : il existe déjà une Famille de ce Rayon portant ce nom...';
  NkSFamilleUsed = 'Impossible de valider : il existe déjà une Sous-Famille de cette Famille portant ce nom...';
  GesRayon = 'Rayon ...';
  GesFamille = 'Famille ...';
  GesSFamille = 'Sous-Famille ...';

  NegCmzMrkNOM = 'Marque';

  NoDelProjet = 'Suppression impossible, ce PROJET est utilisé dans vos données...';
  NoDelVille = 'Suppression impossible, cette VILLE est utilisée dans vos données...';
  NoDelPays = 'Suppression impossible, ce PAYS est utilisé dans vos données...';

  STDragGloNoPossible = 'Impossible d''importer un Sous-Total du glossaire' + #13 + #10 +
    'dans un Sous-Total du document!...';
  STGloIsInModele = 'Impossible d''importer ce modèle dans un Sous-Total' + #13 + #10 +
    'car il contient lui-même un Sous-Total !...';

  NegCapSousTot = 'Remise % && Montants du SOUS-TOTAL';
  NegCapValCom = 'Valeur affichée dans la ligne (NON prise en compte dans les totaux)';
  NoSupTetST = 'On ne peut pas supprimer un en-tête de Sous-Total...';
  LibEntetST = 'Entête de Sous-Total';

  NegLabPack = 'Sous-Total';

  //@@Bruno  19/09/2002
  GeneMail = 'Génération du mailing en cours';

  //@@Bruno  17/09/2002
  SupMailing = 'Confirmez-vous la suppression de ce mailing?';
  GenereMailing = 'Confirmez-vous la génération d''un mailing à partir de cette analyse client ?';
  ASK_MAILING_EXCLUSANSADR = 'Souhaitez-vous exclure du mailing les clients sans adresse ?';
  //@@Bruno 12/11/2002
  MontantMauvais = 'Le montant est erroné...';
  QteMauvais = 'La qté est erronnée...';
  RemiseMauvaise = 'Le taux de remise ne peut pas être supérieur à 100%...';
  PrixMauvais = 'Le prix est erroné...';

  // 3 lignes déplacées
  HintGenEdit = 'Si le champ dispose d''un bouton [Double-clic ou F4] déclenche l''action associée...';
  NegLabTitle = 'Ligne de groupe';

  NegNoArticleStk = 'La ligne en cours ne pointe sur aucun article...';
  InfoStkCour = ' Stock de l''article en cours...';
  F5Neg = '[F5] Afficher le Stock  ';
  VirtuelNoStock = 'Cet article est un "PSEUDO" et n''a donc pas de stock';
  NegAffStk = 'Chrono : §0' + #13 + #10 +
    'Référence : §1' + #13 + #10 +
    'Désignation : §2' + #13 + #10 +
    'Stock : §3';

  NegLabSousTot = 'Sous Total';

  // RV 27-28-2002
  LibAFact = 'Facture à générer';
  TransRapTitle = 'Rapport de transfert en facture...';
  DoingTransBL = 'Transfert des documents en cours ...';
  InitTransBL = 'Initialisation de l''expert de transfert...';
  LibIsClotured = 'Ce document est clôturé';
  LibIsNoModifed = 'Ce document a déjà été transféré';
  LibIsArchived = 'Ce document est archivé';
  LibNOTrans = 'Documents NON Transférables en facture';
  NoBlToTrans = 'Aucun document à transférer en facture !...';

  // RV 22/08/2002
  HistoRechVide = 'Historique de recherche vide...';
  MajFouPrin = 'Mise à jour nécessaire de votre fichier des marques...' + #13 + #10 +
    'Quelques instants tout au plus...  Merci d''avance !';

  // Pascal 20/08/2002
  HintEditInterne = 'Edition interne du document ...';
  // RV 19-08-2002

//   MajFicFod = 'Mise à jour nécessaire du format de votre fichier fournisseurs'+#13+#10+
//      'Quelques instants tout au plus...  Merci d''avance !';
  MajFicAdresse = 'Mise à jour nécessaire du format de votre fichier d''adresses' + #13 + #10 +
    'Quelques instants tout au plus...  Merci d''avance !';
  ModDevMajSelVide = 'Aucun document à réactualiser !' + #13 + #10 +
    '( Les lignes des groupes et les modèles archivés ne sont pas pris en compte... )';
  HintNkMode1 = '[Double clic] ou [F12]  Ouvre la fiche de l''article pointé dans la liste   [F4]  Sélection de la nomenclature';
  HintNkModex = '[Double clic] ou [F12]  Sélectionne l''article pointé dans la liste   [F4]  Sélection de la nomenclature';
  HintARTNk = 'Nomenclature...  [ECHAP] Fermer la nomenclature  [F4] Affiche les articles associés';

  // 7 lignes déplacées
  NkCapFourn = ' Nomenclature & liste des articles du fournisseur...';
  NkCapListart = ' Nomenclature & liste des articles...';
  NKCapNormal = ' Nomenclature...';

  HintNk = 'Nomenclature...  [ECHAP] Fermer la nomenclature';
  GenerAbon = 'Confirmer la génération de(s) "§0" facture(s) d''abonnement correspondant au(x) modèle(s) sélectionné(s)...';

  NeedParamimp = 'Avant d''imprimer ce document il est nécessaire' + #13 + #10 +
    'd''aller d''abord paramétrer vos impressions courrier...' + #13 + #10 + #13 + #10 +
    '[Menu : Paramétrage / Impressions Courrier]';

  ChxModelDev = 'Nouveau modèle de devis';
  NegCmzVendeur = 'Vendeur';
  NegCmzChrono = 'Code Chrono';
  NegCmzTaille = 'Taille';
  NegCmzCouleur = 'Couleur';
  NegCmzPxNet = 'Prix Unitaire Net';
  NegCmzMarge = 'Marge';

  GenerLAbon = 'Confirmer la génération de la facture d''abonnement correspondant au modèle affiché...';
  CapPxvHT = 'PxVte HT';
  CapPxvTTC = 'PxVte TTC';
  CapMtHT = 'Mt HT';
  CapMtTTC = 'Mt TTC';

  OnlyOneSelected = 'Cette fonction n''est pas possible lorsque plusieurs lignes sont sélectionnées !...';
  LbRecepModif = 'Bon de livraison modifiable';
  LbRecepClot = 'Bon de livraison clôturé (non modifiable)';
  LbRecepArch = 'Bon de livraison archivé (non modifiable)';

  // Bruno 13/08/2002
  AnalysePrealable = 'Analyse préalable en cours ...' + #10#13 +
    '(Quelques secondes de patience)';
  AnalyseMailing = 'Analyse en cours de construction';

  // Pascal
  CstArchiveChxDate = 'Date de dernier mouvement';
  CstArchiveSur = 'Etes-vous sur de vouloir archiver ces articles ?';
  CstArchive = 'Archivage des articles';
  CstArchiveEnCours = 'Archivage en cours patience ...';

  TitEdRal = 'Edition des restes à livrer';
  LibCdeNoLivr = 'Commande modifiable : aucune livraison encore enregistrée...';
  LibCdeNotModif = 'Commande non modifiable : "en cours de livraison"...';
  LibCdeArchive = 'Commande clôturée ( Pas de Reste à Livrer )...';
  CdeIntLibCum = 'Global commande';
  RalIntLibCum = 'Global R.à L';
  RecepIntLibCum = 'Global réception';
  LibArticle = 'Article';

  // Pascal 29/07/2002
  CstARCDansDate = 'Le dernier mouvement du modèle date du %s ' + #10#13 +
    '     Voulez-vous quand même l''archiver ?';

  // Pascal 23/07/2002
  CstCaisOuv = 'Ouverture par %s, le %s à %s';
  CstCaisFer = 'Fermeture par %s, le %s à %s';
  CstCaisFer2 = 'pas fermée';
  CstCANET = 'CHIFFRE D''AFFAIRES NET';
  CstJSESDet = 'Détail';
  CstJSESHT = 'HT';
  CstJSESTVA = 'TVA';
  CstJSESTTC = 'TTC';
  CstFondCais1 = 'GESTION DU FOND DE CAISSE';
  CstDepense = 'Dépenses';
  CstFondFinal = 'Fond final';
  CstMessCaisseFaux = 'La somme de votre journal de caisse est différente de zéro.'#13#10 +
    'Veuillez contacter l''assistance de GINKOIA SA afin que nous puissions intervenir.'#13#10 +
    'Cela ne vous empêche pas de travailler';
  CstCaiMagasin = 'Magasin %s';
  CstCaiPoste = 'Poste : ';
  CstSesOuv = 'Sessions ouvertes : ';
  JVLibSess = 'Poste §0 - Session No §1';

  // RV 22-07-2002
  NoEditCde = 'Cette commande n''est plus modifiable !...';
  CtrlCdeAbandon = 'Confirmez que vous ne désirez archiver aucune des commandes listées...';
  DelCdeImp = 'Ce document à été imprimé !...' + #13 + #10 +
    'Confirmez que vous désirez néanmoins le supprimer ...';
  CdeTipOblig = 'Le type de commande est obligatoire';
  ValidEnCours = 'Enregistrement en cours...';
  DebCdeDef = 'Monsieur' + #13 + #10 + 'Je vous remercie de bien vouloir enregistrer la commande suivante';
  FinCdeDef = 'Avec mes remerciements anticipés, je vous prie de recevoir Monsieur, mes salutations les meilleures';
  BasFactDef = '';
  RgltDef = 'En votre aimable règlement';

  // Bruno @@ 02/07/2002
  Cstdetail = 'Analyse détaillée du §0 au §1  -  ';

  //Bruno @@ 20/06/2002
  MessChargeAD = 'Analyse détaillée en construction...';
  AnaDetailleeStock = 'Stock';
  AnaDetailleeVentes = 'Ventes';
  AnaDetailleeMonnaie = '€';

  // RV @@28 10-07-2002
  LibDatLivr = 'Date de livraison';
  LibCadDelai = 'Livraison & Délai';
  // Pascal 15/07/2002
  NkSsCategorie = 'Sous Catégorie';
  // RV @@28 10-07-2002
  LibFranco = 'Franco';
  LibTel = 'Tél';
  LibFax = 'Fax';

  CtrlAfterToDay = 'Attention... Vous avez validé une date à venir! ... ' + #13 + #10 +
    '(N''oubliez pas de la corriger s''il s''agit d''une erreur...)';
  CtrlMinDateCdeDef = 'La date de livraison par défaut ne peut pas être antérieure à la date de commande!...';
  NoSupCollec = 'Cette collection ne peut pas étre supprimée car elle est référencée par des articles!...';
  CdeCollecDef = 'Désirez-vous affecter automatiquement une "Collection" à tous les articles qui seront ajoutés dans cette commande?...';
  CdeCopy = 'Confirmez que vous désirez générer une copie de la commande affichée';
  CdeCopyMag = #13 + #10 + 'pour le magasin "§0"';
  OkCdeCopy = 'Copie de commande effectuée...' + #13 + #10 +
    'La nouvelle commande à été générée avec le numéro "§0"';
  OnCopyCde = 'Copie de commande en cours...';
  OnParamCollec = 'Proposition de mise à jour des collections "Activée"';
  NotParamCollec = 'Proposition de mise à jour des collections "Désactivée"';
  // déplacées
  CdeRechVideCollec = 'Aucun article trouvé dans la collection demandée... ' + #13 + #10 +
    '(Si cet article existe, il n''est pas accessible dans le cadre de votre travail en cours..';

  CdeCadexist = '(Article chrono "§0") IMPOSSIBLE de valider la cadence de livraison définie pour cette ligne' + #13 + #10 +
    'car elle existe déjà dans la commande';

  // Pascal @@24 11/06/2002
  CstTabTaiMag1 = 'A Vendre %s';
  CstTabTaiMag2 = 'A Vendre ';
  CstTabTaiMag3 = 'Ventes %s';
  CstTabTaiMag4 = 'Ventes';
  CstTabTaiMag5 = 'Stock %s';
  CstTabTaiMag6 = 'RàL %s';
  CstTabTaiMag7 = 'RàL';
  CstTabArtDeb = 'Du %s';
  CstTabArtFin = 'Au %s';
  CstTabTaiCou1 = 'Stock de début';
  CstTabTaiCou2 = 'Achat';
  CstTabTaiCou3 = 'Rétro';
  CstTabTaiCou4 = 'Démarque';
  CstTabTaiCou5 = 'A Vendre';
  CstTabTaiCou6 = 'Ventes Normales';
  CstTabTaiCou7 = 'Ventes Promo';
  CstTabTaiCou8 = 'Ventes Soldées';
  CstTabTaiCou9 = 'Ventes Professionnelles';
  CstTabTaiCou10 = 'Ventes';
  CstTabTaiCou11 = 'Stock de Fin';
  CstTabTaiCou12 = 'RàL';
  CstTitTabTailCoul = 'Tableau de bord Taille/Couleur';
  CstTitTabTailMAG = 'Tableau de bord Taille/Magasin';

  // @@24 RV
  HintEditGenNoSuppr = '[Ins] Créer [F2] Editer';


  //Bruno @@ 29/05/2002
  AnnulPasPossible = ' Attention, annulation impossible,' + #13 + #10 + ' c''est un ticket de réajustement de compte...';

  // RV @@22 29/05/2002  3 lignes déplacées car modifiées
  FournMrkSup = 'Les Marques suivantes n''étant plus référencées dans la base ont été automatiquement supprimées';
  SupLienMrkCas1 = 'Suppression impossible...' + #13 + #10 + 'La marque distribuée n''aurait plus de fournisseur...';
  NegFacCroPro = 'En cours...';

  // Pascal @@22 28/05/2002
  MessChargeAnalVente = 'Chargement de l''analyse des ventes ...';
  CstAnalVente = 'Analyse des ventes du §0 au §1 ';
  CstAnalVenteCum = 'Analyse des ventes (cumul des magasins) du §0 au §1 ';
  // Bruno @@ 20 14/05/2002
  MotifObligatoire = 'La saisie d''un motif est obligatoire...';
  ReajustCompteLib = 'REAJUSTEMENT DU COMPTE CLIENT';

  // P.R. @@19
  MessNettoyAnalSynt = 'Vérification des articles...';

  //R.V @@17
      // 2 lignes déplacées
  HintEditDBG = '[Ins] Créer [F2] Editer [Ctrl+Suppr] Supprimer la ligne sélectionnée';

  SupprModFacture = 'Suppression de(s) modèle(s) de facture d''abonnement en cours...';
  LibDatFacAbon = 'Date de facturation';
  ConfCreModFac = 'Confirmez la création d''un modèle de facture d''abonnement' + #13 + #10 +
    'à partir de la facture en cours...';

  NoGenerAbon = 'Aucune facture d''abonnement à générer';
  SupprAbon = 'Confirmer la SUPPRESSION de(s) "§0" facture(s) d''abonnement sélectionnée(s)...';
  NoSupprAbon = 'Aucune facture d''abonnement à SUPPRIMER';

  GenerAbonFactures = 'Génération des factures d''abonnement en cours...';
  GenerAbonFacture = 'Génération de la facture d''abonnement...';
  GenerModFacture = 'Création d''un modèle de facture d''abonnement à partir de la facture affichée...';
  ModFactOk = 'Le modèle de facture d''abonnement "§0" a été généré' + #13 + #10 +
    'à partir de la facture "§1"';
  ModFactPb = 'Problème lors de la création du modèle à partir de la facture "§1"' + #13 + #10 +
    '(Le modèle n''a pas pu être généré...)';
  GenerFacAbonOk = 'Facture d''abonnement générée...';
  GenerFacAbonPB = 'Problème : Facture d''abonnement NON générée...';

  //R.V @@16
  MrkDelDist = 'Confirmez que le Fournisseur "§0"' + #13 + #10 +
    'n''est plus distributeur de cette marque...';
  MrkINSDist = 'Confirmez que le Fournisseur "§0"' + #13 + #10 +
    'est distributeur de cette marque...';

  ChargeArbreMrk = 'Chargement et mise à jour de la liste des marques...';
  SupprMarque = 'Confirmez la suppression de la marque "§0"...';
  CantSupMarque = 'La suppression de la marque "§0" est IMPOSSIBLE...' + #13 + #10 +
    'Elle est référencée par vos articles...';
  ManqueFouPrin = 'Il est indispensable de désigner le fournisseur principal de cette marque! ...';
  CancelMarque = 'Abandonner TOUTES les modifications effectuées sur cette Marque? ...';

  // 6 Lignes déplacées
  SupLienMrkCas2 = 'Vous n''avez pas défini de nouveau fournisseur principal pour cette marque...';
  SupLienMrkCas3 = 'Il y a des articles de cette marque en commande chez ce fournisseur...';
  SupFournCas1 = 'L''une des marques distribuées n''aura plus de fournisseur...';
  SupFournCas2 = 'Vous n''avez pas défini le nouveau fournisseur principal de l''une des marques...';
  SupFournCas3 = 'Il y a des articles de l''une des marques en commande chez ce fournisseur...';

  SupLienMrkCas4 = 'Il y a des articles de cette marque dans une réception "NON Clôturée" de ce fournisseur...';
  SupFournCas4 = 'Il y a des articles de l''une des marques dans une réception "NON Clôturée" de ce fournisseur...';
  SupLienMrkCas5 = 'Il y a des articles de cette marque dont ce fournisseur est noté comme étant "le fournisseur principal"...';
  SupFournCas5 = 'Il y a des articles de l''une des marques dont ce fournisseur est noté comme étant "le fournisseur principal"...';

  SupLienMrkCas6 = 'Il y a des articles de cette marque dans un retour "NON Clôturé" de ce fournisseur...';
  SupFournCas6 = 'Il y a des articles de l''une des marques dans un retour "NON Clôturé" de ce fournisseur...';
  SupLienMrkCas7 = 'Il y a des articles de cette marque dans une annulation de commande "NON Archivée" de ce fournisseur...';
  SupFournCas7 = 'Il y a des articles de l''une des marques dans une annulation de commande "NON Archivée" de ce fournisseur...';
  SupLienMrkCas0 = 'Impossible c''est le fournisseur principal de marque';

  FrnNoDistrib = 'Marque sans fournisseur';
  NapLib = 'Net à Payer';
  NapAvoirLib = 'Avoir Net';

  //P.R. @@16
  InfVersementCoffre = 'Versement au coffre ';
  { @@15 Modifié Hervé le 12/04/2002}
  CancelFourn = 'Abandonner toutes les modifications effectuées pour ce fournisseur ? ...';
  NoMoreMagDetFrn = 'Vous avez déjà défini les conditions particulières pour tous les magasins possibles...';
  MessPostFrnCt = 'Enregistrement de la fiche du contact fournisseur...';
  MessPostFrnDet = 'Enregistrement de la fiche de conditions particulières...';
  MessDelFrnCt = 'Confirmez la suppression de la fiche contact fournisseur à l''écran...';
  MessDelFrnDet = 'Confirmez la suppression de la fiche conditions particulières du fournisseur à l''écran...';
  MessCancelFrnCt = 'Abandonner les modifications en cours dans la fiche du contact ? ...';
  MessCancelFrnDet = 'Abandonner les modifications en cours dans les conditions particulières ? ...';

  // P.R. : 9/04/2002 : @@15 : ajout de la catégorie pour les factures
  CstCategorie9 = 'Ventes';

  { Modifié Hervé Le : 09/04/2002  -   Ligne(s) }
  HintDbgContactFrn = '[INS] Créer un contact chez ce fournisseur  [Suppr] Supprimer le contact affiché';
  HintDbgCdtFrn = '[INS] Créer les conditions spécifiques d''un magasin [Suppr] Supprimer les conditions affichées';
  LibComment = 'Commentaires';
  FrnContactDef = 'Contact Fournisseur';
  CapImpGlossaire = 'Edition du Glossaire';
  ListeDesMarques = 'Liste des marques';
  CapCreaMrk = 'Création d''une nouvelle Marque...';
  NomMrkExist = '"§0" : Nom de marque IMPOSSIBLE...' + #13 + #10 +
    'Il existe déjà une marque référencée portant nom ! ...';
  InputLabNeoMrk = 'Nom de la nouvelle marque...';
  DefCapInput = 'Boite de saisie...';
  DefLabInput = 'Votre saisie...';

  //22/03/2002 Bruno
  EtikCltTotal = 'Confirmez-vous, l''impression des étiquettes correspondant' + #13 + #10 + 'à la liste des clients en cours?';
  EtikCount = 'Etiquette';
  EtikCountS = 'Etiquettes';


  { Modifié Hervé Le : 26/03/2002  -   Ligne(s) }
  LibRecep = 'Bon de Réception';
  MessCreaLinkArt = 'Création de l''article et transfert' + #13 + #10 + 'dans le "§0"';
  ///Pascal 25/03/2002
  CstAffInventaire = 'Affichage de l''inventaire en cours, patience...';

  { Modifié Hervé Le : 19/03/2002  -   Ligne(s) }
  CreerMarqueDef = 'Faut-il créer une marque du même nom que celui de ce fournisseur ? ...' + #13 + #10 +
    '( Cette marque se nommerait donc "§0" )';

  SupMarqueDist = 'Retirer la marque "§0" comme marque distribuée par ce fournisseur ?...';
  GrosYaRal = 'Il reste des articles en commande chez ce fournisseur' + #13 + #10 +
    'pour une marque qui n''est pas distribuée par lui ! ...' + #13 + #10 +
    'Tant qu''il ne sera pas déclaré comme distributeur de cette marque,' + #13 + #10 +
    'il devra impérativement rester grossiste...';

  AjoutMrkSel = 'Confirmez l''ajout des marques sélectionnées comme étant distribuées par ce fournisseur...';
  HintDbgMrkFrn = '[INS] Ajouter des marques distribuées [Suppr] Si la marque pointée n''est plus distribuée';
  HintDbgMrkFrnNoEdit = '[Double-clic] Fiche de la marque pointée';

  HintRechFrn = '[F6] Liste des fournisseurs';

  SupFournAvort = ' La suppression ne peut pas être effectuée...';

  HintNeoFoudef = 'Sélectionner le Nouveau fournisseur par défaut de la marque "§0" ? ...';
  PbAdresseFourn = 'Problème avec l''adresse de ce fournisseur... Mise en édition impossible ! ...';
  NomFournExist = 'Deux fournisseurs ne peuvent être créés avec le même nom ! ...';
  PbCreaFourn = 'Problème en validation de ce nouveau fournisseur...' + #13 + #10 +
    'La création doit être abandonnée...';
  TxtEnLS = 'Texte en lecture seule';
  FourNoDel = 'Impossible de supprimer ce fournisseur...'#13 + #10 +
    'car vous avez déjà travaillé avec lui !)' + #13 + #10 +
    '(articles référencés, articles en commande... etc.)';

  { Modifié Hervé Le : 17/03/2002  -   Ligne(s) }

  LabProForma = 'Facture Pro Forma';
  MajTarModeles = 'Confirmez la réactualisation des prix des modèles sélectionnés... ';

  ModDevNoNeedMaj = 'Les prix sont à jour... ce modèle ne nécessite aucune réactualisation ! ...';
  ModDevNoNeedMajSel = 'Les prix sont à jour... aucune réactualisation n''a été nécessaire !...';
  ModDevMaj = 'Mise à jour des prix du modèle terminée... ';
  ModDevMajSel = 'Mise à jour des prix des modèles sélectionnés terminée... ';

  { Modifié Hervé Le : 11/03/2002  -   Ligne(s) }
  MessRecepRemRal = 'Cet article a été saisi en commande avec une remise de "§0"' + #13 + #10 +
    'différente de la remise par défaut du bon de réception (§1)' + #13 + #10 + #13 + #10 +
    'Faut-il forcer la remise par défaut du bon de réception ?';

  NewFilterMess = 'Mise en place du filtre avancé...';
  StopFilterMess = 'Suppression du filtre avancé... réaffichage des données...';
  NbtAdvFilterHint = 'Expert filtre avancé...';
  NegPxUHT = 'Px Unit HT';
  NegPxUTTc = 'Px Unit TTC';

  ConsoQteNega = 'Le stock est... ou va devenir négatif ! ... Continuer ?';

  DateDocMess = 'Votre document est à une date... "dans le futur" ! ...' + #13 + #10 +
    'Est-ce bien normal et faut-il l''accepter ? ... ';
  TitleExpertCat = ' Expert de gestion des catégories de familles';
  TitleExpertCat1 = ' Expert de gestion des catégories de Rayons';

  CNFCategorie0 = 'Retirer la famille "§0" de la liste des Catégories ? ...' + #13 + #10 +
    '(Cette Famille n''aura plus de Catégorie associée...)';
  CNFAffectCategorie = 'Placer la Famille "§0"' + #13 + #10 + 'Dans la Catégorie "§1" ? ...';

  CNFCangeCatFam = 'Déplacer la Famille "§0"' + #13 + #10 + 'de la Catégorie "§1"' + #13 + #10 +
    'vers la Catégorie "§2"';

  CNFCangeSecRay = 'Déplacer le Rayon "§0"' + #13 + #10 + 'du Secteur "§1"' + #13 + #10 + 'vers le Secteur "§2"';
  DbgRExpertSectHint = '[Ctrl + Flèche Droite] Affecte le rayon pointé au Secteur en cours [Suppr] Retire l''élément pointé';
  DbgSRExpertSectHint = '[Ctrl + Flèche Gauche] Retire le rayon pointé du Secteur [Drag && Drop] Pour réorganiser les Secteurs';

  DbgRExpertCatHint = '[Ctrl + Flèche Droite] Affecte la famille pointée à la Catégorie en cours [Suppr] Retire l''élément pointé';
  DbgSRExpertCatHint = '[Ctrl + Flèche Gauche] Retire la famille pointée de la Catégorie [Drag && Drop] Pour réorganiser les Catégories';
  DbgRExpertCatHint1 = '[Ctrl + Flèche Droite] Affecte le rayon pointé à la Catégorie en cours [Suppr] Retire l''élément pointé';
  DbgSRExpertCatHint1 = '[Ctrl + Flèche Gauche] Retire le rayon pointé de la Catégorie [Drag && Drop] Pour réorganiser les Catégories';

  ExpertSectTitre = 'Liste des secteurs avec leurs rayons associés';
  ExpertCatFamTitre = 'Liste des catégories';

  ExpertCarFamTitre = 'Liste de catégorie avec leurs familles associées';
  ChargeImpMess = 'Chargement de l''impression en cours...';
  LoadArtRay = 'Chargement de la liste des articles du rayon...';
  NkArtRefCap = 'Articles référencés';
  NkCatFournCap = 'Articles des catalogues fournisseurs';

  SupRelGtsNK = 'Confirmez la suppression de l''association de la grille statistique' + #13 + #10 +
    '"§0"' + #13 + #10 + 'à cette sous-famille...';
  NoSupGTSBaseNK = 'On ne peut pas supprimer l''association avec la grille statistique de base...';

  NkDefFam = 'NOUVELLE FAMILLE';
  NkDefSF = 'NOUVELLE SOUS-FAMILLE';

  DelNkRay = 'Confirmez la suppression du rayon "§0"';
  DelNkFam = 'Confirmez la suppression de la famille "§0"';
  DelNkSF = 'Confirmez la suppression de la sous-famille "§0"';

  DeleteNKRV = 'Problème lors de la suppression... le traitement est annulé !';

  NbtParamRech = 'Définir une collection pour l''outil de recherche...';
  ParamRechTout = 'Toutes collections';
  NkDetail = 'Détail de l''élément sélectionné';
  NkRefreshMess = 'Fermeture de l''outil de gestion de la nomenclature';
  NkGesCharge = 'Chargement de l''outil de gestion de la nomenclature...';
  NkChxArt = 'Liste des modèles selon la nomenclature...';
  NkRayon = 'Rayon';
  NkFamille = 'Famille';
  NkSSF = 'Sous-Famille';
  NkSecteur = 'Secteur';
  NkCategorie = 'Catégorie';

  NoNkDispo = 'Chaînage impossible' + #13 + #10 + 'tant que vous n''avez pas terminé le travail en cours...';

  NoNkSelected = 'Aucun élément sélectionné ! ...';
  NeedRayon = 'Il faut sélectionner un rayon ! ... ';
  NeedFamille = 'Il faut sélectionner une famille !... ';
  NeedSSF = 'Il faut sélectionner une sous-famille !... ';

  NkNoArt = 'Aucun modèle sélectionné! ...';
  FreeNk = 'Décharger la nomenclature de la mémoire ? ...';

  { Modifié Sandrine Le : 15/02/2002  -   Ligne(s) }
  GestDroit = 'Vous n''avez pas les droits suffisant pour accéder' + #13 + #10 +
    'à cette partie du programme' + #13 + #10 +
    'Contactez votre responsable !';

  { Modifié Sandrine Le : 11/02/2002  -   Ligne(s) }
  CapCmzMenuDo = 'Activer la personnalisation des barres outils';
  CapCmzMenuOff = 'DésActiver la personnalisation des barres outils';

  FinFiches = 'Fin du fichier...';
  debFiches = 'Début du fichier ...';
  NoGoodPeriode = 'La date de fin doit être postérieure à celle de début ! ...';
  FiltreReinit = 'Confirmer la suppression complète de toutes les conditions sélectionnées...';
  HintBtnDocSel = 'Ouvre le document pointé dans son module de gestion...';
  { Modifié BRUNO Le : 04/02/2002  -   Ligne(s) }
  EtiquetteEssai = 'Souhaitez-vous imprimer une étiquette d''essai?';
  SautEtiquette = 'Impossible, le nombre d''étiquette(s) à sauter doit être compris entre 0 et 20...';
  TitreEtikDiff = 'Impression des étiquettes différées';
  PasSelect = 'Impression impossible, vous n''avez pas sélectionné les lignes...' + #13 + #10 +
    'Le bouton en bas à gauche vous permet de tout sélectionner.';

  { Modifié RV Le : 04/02/2002  -   Ligne(s) }
  messClotEtArchDoc = 'Le document à l''écran n''est pas "clôturé"...' + #13 + #10 +
    'Faut-il le clôturer et l''archiver ? ...' + #13 + #10 +
    '(Attention : l''archivage est irréversible! ...)';

  MessArchDoc = 'Confirmer l''archivage du document affiché à l''écran' + #13 + #10 +
    '(Attention : l''archivage est irréversible! ...)';

  TitClotDoc = ' Clôture du document affiché...';
  TitArchDoc = ' Archivage du document affiché...';
  MessClotDoc = 'Confirmer la clôture du document affiché à l''écran' + #13 + #10 +
    '(Attention : la clôture est irréversible! ...)';

  LibVendeur = 'Affaire suivie par :';
  CapMagStk = ' Magasin qui sera déstocké...';
  CapMagDev = ' Aucun mouvement de stock...';
  { Modifié RV Le : 26/01/2002  -   Ligne(s) }
  LibConf = 'Confirmation';
  LibInfo = 'Information';
  DefOuiNon = 'Confirmez votre choix... ';
  CapDlgTransDev = 'Transfert du devis affiché...    ';
  CapDlgTransMod = 'Copie du modèle affiché...    ';
  LibModele = 'Modèle';
  OkDevTransModele = '"Le document "§0" N° §1 a été généré à partir du modèle affiché à l''écran...';
  OkDevTransNeoMod = 'Le modèle N° "§0" a été généré à partir du document affiché à l''écran...  ';

  ComentDevTrans = '* Transféré depuis le devis N° §0';
  ComentCopyDev = '* Copié depuis le devis N° §0';
  ComentDevTransMod = '* Copié depuis le modèle N° §0';

  PbTransDev = 'Problème lors du transfert du devis...' + #13 + #10 +
    '(Le transfert est abandonné...)';
  NoGoodParamTrans = 'Le paramétrage de Ginkoia est incomplet...' + #13 + #10 +
    'Impossible de procéder au transfert! ...';
  BLLib = 'Bon de livraison';
  DevLib = 'Devis';
  DoDevTransDoc = 'Confirmez le transfert en "§0" du Devis affiché à l''écran...   ';
  DoCopyModele = 'Confirmez la copie en "§0" du modèle affiché à l''écran...   ';
  DoCopyModMod = 'Confirmez la copie en "§0" du document affiché à l''écran...   ';

  OkDevTrans = 'Le devis affiché à l''écran a été transféré en "§0" N° §1   ';
  DoTransNoModele = '(après transfert le devis d''origine ne sera plus modifiable)';

  VendeurDef = 'Vendeur par défaut des nouvelles lignes';
  HintEdBtnCanClear = '[Double-clic ou F4] Liste associée [SUPPR] Vider le champ';
  CannotChangeTipModele = 'On ne peut pas changer le type d''un modèle...';
  DevTitreListe = 'Liste des devis';
  DevTitreMod = 'Liste des Modèles';
  NoSupprExportedDev = 'Suppression impossible !' + #13 + #10 +
    'Ce devis contient des lignes transférées dans un autre document! ...';
  NoSupprExportedLine = 'Suppression impossible !' + #13 + #10 +
    'Ligne de devis transférée dans un autre document...';
  ImpIntDev = 'Devis N° §0 - Client N° §1  §2';

  { Modifié RV Le : 22/01/2002  -   Ligne(s) }
  MrkDejaRef = 'Marque déjà référencée chez ce fournisseur...';
  MessOuvreRal = 'Mise en place du contrôle dans le "Reste à Livrer"...';
  MessChargeStkDetail = 'Chargement de la liste des articles détaillés...';
  MessChargeStk = 'Etat de stock en construction...';
  MessChargeCAHoraire = 'Chargement du C.A. horaire...';
  MessChargeCAVendeur = 'Chargement du C.A par vendeur...';
  MessChargeHitVte = 'Chargement du hit parade des ventes...';
  MessChargeJV = 'Chargement du journal des ventes...';
  MessChargeListeTKE = 'Chargement de la liste des tickets...';
  MessTransBL = 'Transfert des bons de livraison en facture...';
  MessSupTar = 'Suppression du tarif de vente...';
  MessChargeCatFourn = 'Chargement des articles du catalogue fournisseur...';
  MessChargeCptClt = 'Chargement des comptes clients...';
  MessChargeDemark = 'Chargement de la liste des démarques...';
  MessInitListDoc = 'Initialisation de la liste des documents...';
  MessChargeCarnetCde = 'Chargement du carnet de commandes...';
  MessChargeAnalSynt = 'Chargement de l''analyse synthétique...';
  MessChargeTar = 'Chargement du tarif de vente...';
  MessInvPortable = 'Patienter pendant l''intégration du portable... ';
  MessInvCreaImp = 'Création de l''impression en cours...';
  MessAjoutArtInv = 'Ajout des articles en cours...';
  MessVerifInv = 'Vérification en cours...';
  MessOuvreInv = 'Ouverture de l''inventaire en cours';
  { Modifié RV Le : 18/01/2002  -   Ligne(s) }
  HintVoirFiltre = 'Voir le filtre en cours';
  ArtStkCourTitle = 'Etat de stock courant';
  Crlf = #13 + #10;
  CaHoraireDateLib = 'CA Horaire par date';
  CaHoraireVendeurLib = 'CA Horaire par vendeur';

  { Modifié RV Le : 15/01/2002  -   Ligne(s) }
  TitleTabordBL = 'Bons de livraison en cours';
  { Modifié RV Le : 10/01/2002  -   Ligne(s) }
  LabPxv = 'Px Vente';
  LabPxvHT = 'PxVte HT';

  { Modifié RV Le : 07/01/2002  -   Ligne(s) }
  HintDbgDef = '[Maj+F11] Colonnes à leur largeur minimum';
  // Pascal 07/01/2001
  CstInvClotureNonOK = '    Erreur durant La clôture de l''inventaire   ' + #13 + #10 + #13 + #10 +
    '    Appeler GINKOIA SA pour résoudre votre problème ';

  LabDateStk = 'Editer l''état du stock au';

  StkDetailLib = 'Liste détaillée des articles au : §0';
  { Modifié Pascal 31/12/2001 }
  CstAnalSynth = 'Analyse synthétique du §0 au §1 ';
  CstAnalSynthCUM = 'Analyse synthétique (cumul des magasins) du §0 au §1 ';

  { Modifié RV Le : 04/01/2002  -   Ligne(s) }
  HintBasculeGrpFoot = 'Basculer les cumuls intermédiaires entre "pied" et "entête" de groupe';
  { Modifié RV Le : 31/12/2001  -   Ligne(s) }
  SupTarVente = 'Retirer l''article sélectionné de ce tarif de vente ? ... ';
  HintSumOnGroup = 'Afficher / Masquer les cumuls sur les lignes d''entête de groupe';
  HintAutoWidth = 'Ajustement automatique des colonnes "au mieux"';

  { Modifié RV Le : 26/12/2001  -   Ligne(s) }
  NoTouchTarBase = 'On ne peut ni modifier ni supprimer le tarif général ! ... ';
  SupTarVenteOk = 'Suppression du tarif de vente terminée...    ';
  TarVenteLinked = 'Impossible de supprimer ce tarif de vente car ' + #13 + #10 +
    'il est appliqué par un magasin! ... ';

  { Modifié RV Le : 24/12/2001  -   Ligne(s) }
  LabExporte = 'Exporté';
  LabInactif = 'Inactif';
  LabNoDoc = 'Aucun document';
  LabEnModif = 'En Modification';
  LabEnCrea = 'En création';
  LabArchive = 'Archivé et Clôturé';
  LabCloture = 'Clôturé';
  LabNonModif = 'Non Modifiable';
  LabCanModif = 'Modifiable';

  { Modifié RV Le : 19/12/2001  -   Ligne(s) }
  NoClient = 'Impossible de trouver ce client dans le fichier !    ';

  CstPassageEuro = ' ATTENTION, vous devez passer définitivement à l''Euro.'#13#10 +
    'Pour cela vos caisses doivent avoir leurs sessions clôturées.'#13#10 +
    '        De plus elles doivent être fermées.'#13#10#13#10 +
    ' Voulez-vous lancer le passage à l''Euro ? ';

  CstPassageEuro2 = 'Etes-vous sur de ne pas avoir oublié de clôturer vos sessions de caisse'#13#10 +
    'et de quitter le programme de caisse, ainsi que Ginkoia sur tous les autres postes.'#13#10#13#10 +
    'L''application Ginkoia de ce poste se refermera automatiquement après le passage à l''euro.'#13#10 +
    'Vous devrez la relancer.';

  { Modifié RV Le : 16/12/2001  -   Ligne(s) }
  PaysOblig = 'La saisie d''un nom de pays est obligatoire';
  VilleOblig = 'La saisie d''un nom de ville est obligatoire';

  { Modifié RV Le : 14/12/2001  -   Ligne(s) }
  CstTousMag = 'Tous Magasins';

  BLTransDeja = 'Bon de livraison déjà transféré en facture';
  { Modifié RV Le : 08/12/2001  -   Ligne(s) }
  RetroLIb = 'Rétrocession';
  FacRetroLib = 'Facture de rétrocession';
  LibHT = 'Px Vte HT';
  LibTTC = 'Px Vte TTC';
  LabTipTTC = 'Montant TTC';
  LabTipHT = 'Montant HT';

  { Modifié RV Le : 06/12/2001  -   Ligne(s) }
  LabDateRglt = 'Date de règlement';
  FacImpDateDef = 'En votre aimable règlement';
  BLTransNoProd = 'Ne peut être transféré en automatique ( Montant BL Nul )';
  NoImpDocVide = 'Document vide ! ... aucune ligne à imprimer. ';
  TransMultiAvorted = 'Problème lors du transfert d''un document, le transfert est annulé...    ';

  { Modifié RV Le : 03/12/2001  -   Ligne(s) }
  FactNoTip = 'Le type du document est obligatoire... ';
  NoCatalog = 'Aucun catalogue fournisseur disponible sur votre machine... ';
  NoSupportedUnidim = 'Fonctionnalité "Taille/Couleur" sans objet dans un univers qui n''en dispose pas! ... ';
  ListClient = 'Liste des clients';
  HintExpandLevel = 'Afficher les lignes de groupe suivant...';
  HintCollapseLevel = 'Afficher les lignes de groupe précédent...';

  { Modifié RV Le : 27/11/2001  -   Ligne(s) }
  NegSumMtTTC = 'Montant TTC';
  NegSumTotalTTC = 'Total TTC';
  NegSumMtHT = 'Montant HT';
  NegSumTotalHT = 'Total HT';

  NegEntetPxuTTC = 'PxU TTC';
  NegEntetPxuHT = 'PxU HT';
  NegEntetMtTTC = 'Mt TTC';
  NegEntetMtHT = 'Mt HT';

  DevisePays = 'FRF';
  DeviseEuro = '€'; //DeviseEuro = 'EUR';
  NoNegEuro = 'Désolé, mais on ne peut imprimer une facture que dans la monnaie de référence...    ';
  CoefNull = 'Attention : Prix de vente de base à "0"... ' + #13 + #10 +
    ' Faut-il l''accepter ? ... '#13 + #10;

  { Modifié RV Le : 25/11/2001  -   Ligne(s) }
  DocImp = 'Imprimer les §0 documents sélectionnés ? ... ';
  NoDocArticle = 'Aucun article en cours (affiché) dans la fiche article...   ';
  DocCloture = 'Confirmer la clôture de(s) §0 document(s) sélectionné(s)...    ';
  NoDocCloture = 'Aucun document à clôturer...      ';
  DocLineINEdit = 'Impossible de changer de page tant que la ligne en cours n''a pas été validée...    ';
  { Modifié Sandrine Le : 21/11/2001  -  2 Ligne(s) }
  CsBL = 'Bons de livraison';
  CsFacture = 'Factures';

  { Modifié RV Le : 20/11/2001  -   Ligne(s) }
  AfterToDay = 'Impossible de saisir une date postérieure à aujourd''hui! ... ';
  MaxToDay = 'Impossible de saisir une date antérieure à aujourd''hui!...    ';

  { Modifié RV Le : 15/11/2001  -   Ligne(s) }
  ArchivedDoc = 'Document archivé ! ... Il ne peut plus être ni modifié ni supprimé. ';
  CloturedDoc = 'Document clôturé !... Il ne peut plus être ni modifié ni supprimé.    ';
  NotModifDoc = 'Document non modifiable... ( ni "supprimable" )';
  NoSupprImportedLine = 'Impossible de supprimer une ligne importée depuis un Bon de Livraison ! ... ';
  NoSupprImportedFac = 'Impossible de supprimer cette facture ! ... ' + #13 + #10 +
    '   ( Elle contient des lignes importées depuis un Bon de Livraison ) ';

  FacLib = 'Facture';
  AvoirLib = 'Avoir';
  FacPbCptClt = 'Problème de mise à jour du compte client! ... ';
  ImpIntFac = 'Facture N° §0 - Client N° §1  §2';
  ImpIntBL = 'BL N° §0 - Client N° §1  §2';

  NoDocFound = 'Le document "§0" n''a pas été trouvé dans la liste des documents...     ';
  BLTransNoLine = 'Aucune ligne à transférer ! ...';

  // Pascal Le 6/11/2001
  CstInvAfficher = 'Appuyer sur le bouton afficher les articles pour pouvoir charger le PHL !';
  CstInvSUPNon = 'La suppression d''un inventaire n''est plus possible après sa clôture.';
  CstStckCourDate = 'Etat de stock au §0';

  { Modifié RV Le : 05/11/2001 }

  BLNOTrans = 'Aucun transfert à effectuer';
  BLTransEnFact = 'Transféré en facture';
  BlConfTrans = 'Confirmez le transfert en facture des bons de livraison sélectionnés...    ';
  BLPBLORSTRAns = 'Problème lors du transfert de ce bon de livraison en facture...';
  BLTransNoPoss = 'Transfert impossible...';
  NegCOmTransBL = 'Transfert du Bon de livraison N° ';
  DoBLTransFact = 'Confirmez le transfert du bon de livraison affiché en facture... ' + #13 + #10 +
    '   (Après transfert le bon de livraison ne sera plus modifiable)';
  BLKourOkTransFact = 'Le bon de livraison a été transféré dans la facture N° §0    ';
  BLKourNoTransFact = 'Problème lors du transfert de ce bon de livraison en facture...    ';
  BLTitreListe = 'Liste des bons de livraison';
  FacTitreListe = 'Liste des Factures';
  HintEditGen = '[Ins] Créer [F2] Editer [Suppr] Supprimer';

  ChpBtnComent = '[F4 ou Double-clic] Ouvre le bloc mémo de saisie associé';
  NegLabComent = 'Texte libre';
  NegLabArticle = 'Désignation';
  NoChangeBecauseModif = 'La modification de ce champ n''est possible ' + #13 + #10 +
    '   que lorsque le document est en création... ';
  NoChangeBecauseLines = 'La modification de ce champ n''est plus possible ' + #13 + #10 +
    '   lorsque des lignes existent dans le document... ';
  FactNoClt = 'La saisie d''un client est obligatoire !      ';
  FactNoMag = 'La saisie du magasin est obligatoire !      ';
  ConfDeleteDoc = 'Confirmer la SUPPRESSION du document en cours... ';

  // Pascal Le 9/11/2001
  CstStockTousMag = 'Stock détaillé tout magasin';
  // Pascal le 7/11/2001
  CstCaVendeurDateLib = 'CA par vendeur du §0 au §1  -  ';

  // Pascal le 6/11/2001
  CstInvRecompter = 'Recompter les articles de la liste ?';
  CstInvSupprimer = 'Ne pas recompter les articles de la liste et les sortir de l''inventaire ?';

  // Pascal le 6/11/2001
  CstInvAjoutArticle = 'Ajouter la sélection à l''inventaire ?';

  // Modifié Pascal le 02/11/2001
  CstFamille = 'Famille';
  CstSSFamille = 'Sous Famille';
  CstCategorie = 'Catégorie';
  CstGenre = 'Genre';

  { Modifié RV Le :  02/11/2001 }
  ConsodivList = 'Liste des consommations diverses en saisie...    ';
  EdEcartInv = 'Ecarts d''inventaire du §0 au §1  -  ';

  // Modifié Pascal le 31/10/2001
  CstInvClotureOK = 'La clôture de l''inventaire s''est bien passée';
  CstInvClotEnCours = 'Clôture de l''inventaire en cours';
  CstInvDemEnCours = 'Création de la démarque en cours';
  CstInvProblemePHL = 'Problème de réception sur le PHL';
  CstInvChargePHL = 'Chargement du PHL terminé';
  CstInvTousCompte = 'Aucun article n''a été mouvementé pendant l''inventaire'#13#10'                Rien n''est à recompter';
  CstInvARecompte =
    '   Les articles suivants ont été mouvementé pendant l''inventaire'#13#10 +
    'Vous devriez les recompter ou les supprimer pour que la clôture soit exacte';

  CstInvOuvOk = 'L''ouverture d''inventaire s''est bien passée.'#13#10'Vous pouvez maintenant commencer à travailler';
  CstInvTitreImpNC = ' Edition des non comptés inventaire num §0, §1';
  CstInvTitreImpEcart = ' Edition des écarts inventaire num §0, §1';
  CstInvTitreImpValo = ' Edition valorisée de l''inventaire num §0, §1';
  CstHistoTaille = 'Toutes tailles';
  CstHistoCoul = 'Toutes couleurs';

  { Modifié RV Le : 30/10/2001  -   Ligne(s) }
  NoDataVide = 'Impossible de valider sans une donnée significative! ... ';

  // Pascal 11/10/2001

  CstInvTousArt = 'Vous avez déjà ajouté tous les articles';
  CstInvTousArtConf = 'Etes-vous sur de vouloir ajouter tous les articles à l''inventaire ?';
  CstInvChoixNomenc = 'Choix d''une nomenclature pour l''inventaire';
  CstInvClot = 'Inventaire clôturé';
  CstInvOuv = 'Inventaire en cours';
  CstInvPrep = 'Préparation d''inventaire';
  CstInvQuestOuv = 'Etes-vous sur de vouloir ouvrir l''inventaire ?';
  CstInvZone = 'Zone Num : §0';
  CstInvAjoutUnArt = 'L''article n''est pas présent en inventaire, '#13#10'           Voulez-vous l''ajouter ?';
  CstInvImpAjoutUnArt = 'L''article n''est pas présent en inventaire, '#13#10'Impossible de l''ajouter pour un inventaire magasin ouvert';
  CstInvCorrection = 'Création d''une session de correction';
  CstInvRechVide = 'Aucun article trouvé... ( Vérifier s''il est en inventaire ) ';
  CstInvSupInv = 'ATTENTION la suppression est définitive et irrévocable. '#13#10'          Etes vous sur de vouloir supprimer ? ';
  CstInvRecep = 'Réception des données en cours';
  CstInvArtOk = ' OK ';
  CstInvArtNI = ' Pas en inventaire ';
  CstInvArtNT = ' Pas trouvé ';
  CstInvArtInd = ' Référence imprécise ';
  CstInvTitreImpINV = 'Inventaire Num : §0,   §1 ';
  CstInvTitreImpSES = 'Inventaire Num : §0, Session  §1 : §2 ';
  CstInvErreurZone = 'Veuillez saisir une zone ! ';
  CstInvCloture = ' Etes-vous sur de vouloir clôturer l''inventaire ?';
  CstInvAnnulSaisie = 'Voulez-vous annuler votre saisie ?';

  { Modifié RV Le : 20/10/2001  -   Ligne(s) }

  TitleHistoVente = 'Historique de vente de l''article - Chrono : ';
  TitleHistoMvt = 'Historique des mouvements de l''article - Chrono : ';
  TitleHistoRetro = 'Historique "Rétros et Démarques" de l''article - Chrono : ';

  // Hervé  6/10/2001
  HintcdvMM = 'Liste des consommations diverses depuis le :';
  HintBtnCopy = '[CTRL+P] ou [Clic Bouton "..."] Recopie la valeur de la fiche précédente';
  ErrFrnDelContact = 'Confirmez la suppression du contact sélectionné...   ';
  ErrNomContact = 'Un contact doit obligatoirement avoir un nom !... ';
  FrnCapDetail = 'Renseignements complémentaires';
  FrnNoDelSeul = 'Un fournisseur doit avoir au moins 1 marque distribuée...';
  FrnNoDelCde = 'Impossible de supprimer,     ' + #13 + #10 + '   il y a des commandes de cette marque chez ce fournisseur...      ';
  FrnNoDelRecep = 'Impossible de supprimer,     ' + #13 + #10 + '   il y a des réceptions de cette marque chez ce fournisseur...      ';
  FrnNoDelPrin = 'Impossible... car cette marque n''aurait plus de fournisseur principal!   ' + #13 + #10 +
    '   (Il suffit de lui associer un autre fournisseur principal)     ';

  errMajPvteRecep = 'Erreur lors de la mise à jour du prix de vente... ' + #13 + #10 +
    ' Il faudra aller le mettre à jour dans la fiche article. ' + #13 + #10 +
    ' SVP : Prévenez GINKOIA que vous avez eu ce message... Merci ';

  // Pascal 5/10/2001
  CstCategorie1 = 'Commandes';
  CstCategorie2 = 'Achats';
  CstCategorie3 = 'R à L';
  CstCategorie4 = 'Rétrocessions';
  CstCategorie5 = 'Ventes';
  CstCategorie6 = 'BL et prêts';
  CstCategorie7 = 'Démarque';
  //------------------------------

  MessSoon = 'C''est pour bientôt';
  FormatCumStk = 'Cumul Stock';
  FormatCumVal = 'Cumul Valeur';
  FormatCumPvte = 'Cumul Px Vente';
  // EAI

  ErrEAI = ' Une erreur à eu lieu lors de la réplication de vos données!' + #13 + #10 +
    ' Appelez GINKOIA en urgence !';
  ErrPush = ' Erreur lors de ENVOI du module : §0 ';
  ErrPull = ' Erreur lors de la RECEPTION du module : §0 ';
  Donnee = ' - Données "';
  DonneeEnvFin = '" envoyées !';
  DonneeRecFin = '" reçues !';
  Fin1 = 'Envoi terminé avec succès';
  Fin = 'Réception terminée avec succès';
  ErrFin1 = 'Echec lors de l' + #39 + 'envoi de vos données';
  ErrFin = 'Echec lors de la réception de vos données';

  //
  IniCreaArtSport = 'Article dimensionné (Tailles, couleurs)';
  IniCreaArtBrun = 'Article Normal';

  RecepConfRef = 'Confirmer le référencement de l''article catalogue référence "§0"... ';
  PbReferencement = 'Problème de référencement... impossible de continuer !     ';
  RecepLibRef = 'Réf catalogue :';

  // Boutons et Hints

  CapRayon = 'Rayons';
  CapMag = 'Magasin';
  CapCaNet = 'CA NET';
  CapCaBrut = 'CA BRUT';
  CapMrgV = 'Marge Valeur';
  CapCamv = 'C.A.M.V';

  CapCouleur = 'Couleur';
  CapChrono = 'Chrono';
  CapRef = 'Ref';
  CapArticle = 'Article';
  CapEte = 'Eté';
  CapHiver = 'Hiver';

  CapEnregSel = 'Enregistrer la sélection';
  CapEnregistrer = '&Enregistrer';
  CapFamilleDe = 'Familles de';
  CapLaNk = 'La Nomenclature';
  CapSfDe = 'Sous-Familles de';
  CapFermer = '&Fermer';
  CapQuitter = '&Quitter';
  CapCancel = '&Abandonner';
  HintDlgQuit = '[Echap] Quitter';
  HintDlgOkCancel = '[F12]  OK    [Echap]  Abandonner ';
  HintMemo = '[Maj+Flèche Haut] Champ précédent  [Maj+Flèche Bas] Champ Suivant';

  HintExpandNode = 'Ouvrir toutes les lignes du groupe de lignes sélectionné';
  HintCollapseNode = 'Fermer le groupe de lignes sélectionné';
  HintFullExpand = 'Ouvrir la liste à son niveau de détail maximum';

  HintBtnConvert = 'Changer la monnaie d''affichage...';
  HintBtnPreview = 'Afficher / Cacher la ligne de donnée supplémentaire';
  HintBtnPrintDbg = 'Imprimer la liste affichée';
  HintBtnSelMag = 'Liste de sélection des magasins... ';
  HintPeriodeEtude = 'Définir une période d''étude... ';
  HintBtnCmzDbg = 'Outil de configuration des lignes';
  HintBtnClearFilterDbg = '[F11] Réinitialiser le filtre actif dans les lignes...';
  HintBtnShowGroupPanel = 'Afficher / Cacher la zone d''affichage des groupes';
  HintBtnShowFooter = 'Afficher / Cacher les cumuls de fin des lignes';
  HintBtnShowFooterRow = 'Afficher / Cacher les cumuls intermédiaires des lignes';
  HintBtnExcelDbg = 'Exporter les lignes dans Excel (Excel est automatiquement ouvert)';
  HintBtnPopup = 'Menu des fonctions annexes  [Clic droit]';
  HintBtnRefresh = 'Rafraîchir les données affichées (Relecture des données sur le serveur)';
  HintBtnCancel = '[Echap]  Abandonner les modifications effectuées';
  HintBtnEdit = '[F2] Modifier le document affiché';
  HintBtnDelete = '[Suppr] Supprimer le document affiché';
  HintBtnInsert = '[Ins] Ouvrir un nouveau document';
  HintBtnPrintDoc = 'Imprimer le document affiché à l''écran';
  HintBtnQuitDlg = 'Fermer la liste [Echap]';
  HintGenerikFrm = '[F12] Enregistrer   [Echap] Abandonner   [F2] Modifier   [SUPPR] Supprimer';
  HintGenerikFrmNoSuppr = '[F2] Modifier   [F12] Enregistrer   [Echap] Abandonner';

  HintBtnCancelLine = '[Echap]  Abandonner les modifications effectuées dans la ligne';
  HintBtnPostLine = '[F12] Enregistrer les modifications effectuées dans la ligne';
  HintBtnEditLine = '[F2] Modifier le la ligne affichée';
  HintBtnDeleteLine = '[Suppr] Supprimer la ligne affichée';
  HintBtnInsertLine = '[Ins] Créer une nouvelle ligne';

  // Frm_Screen et Frm_Main

  OrgaParam = 'Paramétrage de Ginkoia';
  OrgaMenu = 'Menu de Ginkoia';
  DeLogin = 'retour à l' + #39 + 'utilisateur précédent : ';
  EtikAttente = ' étiquettes en attente';

  // CSreen
  CsGerProd = 'Gérer les produits';
  CsCdes = 'Commandes';
  CsFourn = 'Fournisseurs';
  CsRecep = 'Réception';
  CsTransMM = 'Transferts inter-magasins';
  CsInvent = 'Inventaires';
  CsClient = 'Clients';

  // Fichart
  SexeH = 'Homme';
  SexeF = 'Femme';
  SexeE = 'Enfant';
  ErrGenre = ' Ce genre n' + #39 + 'est pas valable!';
  ErrGroupe = ' Ce groupe n' + #39 + 'est pas valable!';
  ErrCollection = ' Cette collection n' + #39 + 'est pas valable!';
  ErrCatGuelt = ' Cette catégorie de Guelt n' + #39 + 'est pas valable!';

  FichartMagBtn = 'Magasins';

  CtrlJetons = 'Impossible d''ouvrir Ginkoia... ' + #13 + #10 +
    '   Nombre de postes autorisés dépassé... ';
  ErrPoste = 'Impossible d''ouvrir GINKOIA sans un nom de poste défini';
  ErrServeurPoste = 'Le serveur §0 ' + #13 + #10 + 'n' + #39 + 'a pas de poste défini !';
  NomTVT = 'Tarif général';
  NietConvert = 'On ne peut pas changer de devise lorsqu''une tâche est en édition... ';
  NietModifTTrav = 'On ne peut pas supprimer une taille travaillée ou une couleur ' + #13 + #10 +
    '   lorsqu''une commande, une réception ou un transfert sont en édition... ';
  NietDeleteArt = 'On ne peut pas supprimer un article ' + #13 + #10 +
    '   lorsqu''une commande, une réception ou un transfert sont en édition... ';
  TransNoStk = 'IMPOSSIBLE : cet article n''a jamais été référencé en stock... ';

  // Messages du module de dimension

  GtfMajData = 'Problème de mise à jour des données...  ';
  MessGTFREF = 'Impossible de supprimer une grille de tailles de référence...';
  MessGTFSup = 'Confirmez-vous la suppression de cette grille de tailles ?';
  MessSupIndGt = 'Impossible de supprimer une taille de référence...';
  MessGtfIndVid = 'Attention tous les libellés de tailles sont obligatoires...';
  MessModSup = 'Confirmer la suppression du modèle "§0"     ';

  MessLibGTS = 'Le libellé de la grille statistique est obligatoire...';
  MessGtfIndStat = 'Attention le numéro de la colonne de la grille statistique doit être compris entre 1 et 28...';
  MessGtfSupIND = 'Confirmez-vous la suppression de cette taille?';
  MessGTFSupEnfant = 'Impossible de supprimer une taille ayant des "sous-tailles" définies...   ' + #13 + #10 +
    '(Il faut commencer par supprimer toutes les sous-tailles)';
  MessValTT = 'Confirmez-vous la liste des nouvelles tailles travaillées?';
  MessNoSelTT = 'Vous n''avez pas sélectionné une taille...';
  MessGCSSupEnfant = 'Impossible de supprimer une couleur ayant des "sous-couleurs" définies...   ' + #13 + #10 +
    '(Il faut commencer par supprimer toutes les sous-couleurs)';
  MessSupTaille = 'Impossible de supprimer cette taille,' + #13 + #10 + '   car elle est présente dans les historiques...';
  MessSupTailleBis = 'Impossible de supprimer cette taille,' + #13 + #10 +
    '   car elle est présente dans les commandes clients...';
  MessSupTailleTT = 'Impossible de supprimer cette taille,' + #13 + #10 + '   car elle est présente dans les historiques...';
  MessSupTailleTTBis = 'Impossible de supprimer cette taille,' + #13 + #10 +
    '   car elle est présente dans les commandes clients...';
  MessSupCoul = 'Impossible de supprimer cette couleur,' + #13 + #10 + '   car elle est présente dans les historiques...';
  MessSupCoulBis = 'Impossible de supprimer cette couleur,' + #13 + #10 +
    '   car elle est présente dans les commandes clients...';
  MessCategVide = 'Le libellé de la catégorie est obligatoire';
  MessSupCoulStat = 'Confirmez-vous la suppression de cette couleur statistique?';
  MessLibCS = 'Attention le libellé de la couleur est obligatoire...';
  MessLibCou = 'Impossible d''enregistrer : code et libellé de couleur sont obligatoires...';

  TitreListePoste = 'Liste des Postes disponibles sur le serveur';

  // Nomenclature

  NkOrdreaff = 'Gestion de l''ordre d''affichage';
  NkFamDef = 'Famille par défaut';
  NkSfDef = 'Sous-Famille par défaut';

  BtnMRayon = ' [F2] Modifier le Rayon';
  BtnCRayon = ' [INSER] Créer un Rayon';
  BtnSRayon = ' [SUPPR] Supprimer le Rayon';
  BtnMFamille = ' [F2] Modifier la Famille';
  BtnCFamille = ' [INSER] Créer une Famille';
  BtnSFamille = ' [SUPPR] Supprimer la Famille';
  BtnMSSFamille = ' [F2] Modifier la Sous-Famille';
  BtnCSSFamille = ' [INSER] Créer une Sous-Famille';
  BtnSSSFamille = ' [SUPPR] Supprimer la Sous-Famille';
  UpRayon = '[Ctrl+flèche Haut] Déplacer le Rayon vers le haut';
  DownRayon = '[Ctrl+flèche Bas] Déplacer le Rayon vers le bas';
  UpFamille = '[Ctrl+flèche Haut] Déplacer la Famille vers le haut';
  DownFamille = '[Ctrl+flèche Bas] Déplacer la Famille vers le bas';
  UpSSFamille = '[Ctrl+flèche Haut] Déplacer la Sous-Famille vers le haut';
  DownSSFamille = '[Ctrl+flèche Bas] Déplacer la Sous-Famille vers le bas';

  TitreGesart = ' Gestion des articles';
  TitreGesVis = 'Visibilité de la Nomenclature';

  DefHint = ' Nomenclature';
  BtnCancelCap = 'Quitter';
  HintCancelCap = '[Echap] Quitter';
  HintAnnuler = '[Echap] Abandon';

  ErrSansUnivers = ' Cette application fonctionne sans Univers !';
  ErrSansTVA = ' Cette application fonctionne sans TVA par défaut !';
  INFUnivers = ' Cette application fonctionne sur l' + #39 + 'univers §0' + #13 + #10 + 'car §1 n' + #39 + 'est pas disponible !';

  ErrSansFamille = ' La Famille générique de ce Rayon est introuvable!';
  ErrSansSSFamille = ' La Sous-Famille générique de cette Famille est introuvable!';

  ErrNom = ' Ce nom n' + #39 + 'est pas valable!';
  ErrNomRayon = ' Ce nom de Rayon n' + #39 + 'est pas valable!';
  ErrNomFamille = ' Ce nom de Famille n' + #39 + 'est pas valable!';
  ErrNomSSFamille = ' Ce nom de Sous Famille n' + #39 + 'est pas valable!';

  ErrNiveau = ' Le niveau de l' + #39 + 'univers doit être compris 1 et 3 !';
  ErrUnivers = ' Cet Univers référence une nomenclature!';
  ErrSportLink = ' SportLink est la nomenclature de référence...' + #10 + #13 +
    ' Aucune modification n' + #39 + 'est autorisée!';
  ErrCatFamille = ' Cette catégorie est utilisée par une Famille!';
  ErrSecteur = ' Ce Secteur est utilisé par un Rayon!';
  ErrCategorie = ' Cette catégorie est utilisée par une Sous-Famille!';
  ErrTaux = ' Ce taux de TVA n' + #39 + 'est pas valable!';
  ErrTVA = ' Cette TVA est utilisée par une Sous-Famille!';
  ErrTCT = ' Ce type comptable est utilisée!';
  ErrTCTcode = ' Ce type comptable n' + #39 + 'a pas de code!';

  ErrManqueCatFamille = ' La catégorie n' + #39 + 'est pas définie!';
  ErrManqueSecteur = ' Le Secteur n' + #39 + 'est pas défini!';
  ErrManqueCategorie = ' La Catégorie n' + #39 + 'est pas définie!';
  ErrManqueTVA = ' La TVA n' + #39 + 'est pas définie!';
  ErrManqueTCT = ' Le type comptable d''achat et de vente n''est pas défini!';
  ErrManqueSSF = 'La Sous-Famille n' + #39 + 'est pas définie!';
  ErrManqueGTS = ' La Grille de tailles Statistique n' + #39 + 'est pas définie!';

  ErrSupprRayon = ' Au moins un Article référence une sous-famille de ce Rayon !';
  ErrSupprFamille =
    ' Au moins un Article référence une sous-famille de cette Famille!';
  ErrSupprSSFamille = ' Au moins un Article référence cette sous-famille!';

  ErrCle = ' Cette sélection est vide!';
  ErrNiveauCle = ' Aucun niveau cette sélection!';

  //    WARSuppr = ' Etes-vous sûr de vouloir supprimer §0 de votre Nomenclature ?';
  WARSupprSelection = ' Etes-vous sûr de vouloir supprimer la sélection "§0" ?';
  ErrDetruireSelection = ' Votre sélection référence des données qui ne sont plus valides,' + #10 + #13 +
    ' Elle est donc supprimée !';
  CNFModifSelection = ' Etes-vous sûr de vouloir modifier la sélection "§0" ?';
  INFRayonInvisible = ' Les Rayons ne sont pas visibles, modifiez leur visibilité pour pouvoir travailler !';

  CeRayon = 'ce Rayon';
  SsFamDefaut = 'Sous-Famille par défaut';
  CetteFamille = 'cette Famille';
  CetteSSFamille = 'cette Sous-Famille';

  // Test pour IdRef
  LeSecteur = 'Secteur';
  LaCentrale = 'la centrale';

  //Origine

  Dimension = 'Equipement de la personne';
  BrunBlanc = 'Hifi - Electroménagé - Informatique';

  // ExpertcatFamille_Dial

  CNFSecteur0 = 'Ne plus associer "§0" à aucune Catégorie ?';
  CNFAffectSecteur = 'Affecter "§0" à la Catégorie "§1" ?';
  SecteurCap = 'Les Catégories et leurs Rayons';
  FamilleCap = 'Les Rayons non affectés';
  AjoutHint = '[Alt+<--] Affecter le Rayon à la Catégorie.';
  SupprHint = '[Alt+-->] Retirer le Rayon de la Catégorie.';

  // ExpertCreationDial

  TitreC_Rayon = '  Création d' + #39 + 'un Rayon/Famille/Sous-Famille';
  TitreC_Famille = '  Création d' + #39 + 'une Famille/Sous-Famille';
  TitreC_SSFamille = '  Création d' + #39 + 'une Sous-Famille';
  TitreM_Rayon = '  Modification d' + #39 + 'un Rayon';
  TitreM_Famille = '  Modification d' + #39 + 'une Famille';
  TitreM_SSFamille = '  Modification d' + #39 + 'une Sous-Famille';

  MsgNomNK = 'de Nomenclature';

  // ExpertSecteur_Dial

  CNFSuperRayon0 = 'Retirer le Rayon "§0" de la liste des secteurs? ...' + #13 + #10 +
    '(Ce Rayon n''aura plus de Secteur associé...)';
  CNFAffectSuperRayon = 'Placer le Rayon "§0"' + #13 + #10 + 'Dans le Secteur ? " " ...';

  // Selection_Dial

  NkItemRadioRay = 'Sélectionner tous les Rayons contenant :';
  NkItemRadioFam = 'Sélectionner toutes les Familles contenant :';
  NkItemRadioSf = 'Sélectionner toutes les Sous-Familles contenant :';
  NkCeRayon = 'ce Rayon';
  NkCetteFam = 'cette Famille';
  NkCetteSf = 'cette Sous-Famille';

  CNFAbandonSelection = ' Si vous abandonnez maintenant votre sélection sera perdue.' + #13 + #10 +
    '  Etes-vous sûr de vouloir abandonner ?';
  CNFSupprFam = ' Attention des Familles de §0 sont déjà dans la sélection !' + #13 + #10 +
    ' Pour rajouter §0, il faut les enlever.';

  CNFSupprSSFam = ' Attention des Sous-Familles de §0 sont déjà dans la sélection !' + #13 + #10 +
    ' Pour rajouter §0, il faut les enlever.';
  CNFSupprFam_SSFam = ' Attention des Familles et des Sous-Familles de §0 sont déjà dans la sélection !' +
    #13 + #10 + ' Pour rajouter §0, il faut les enlever.';
  ErrRayon = ' Le Rayon de §0 est déjà sélectionné !';
  ErrFamille = ' La Famille de cette Sous-Famille est déjà sélectionnée !';
  WarSupprItem = ' Etes-vous sûr de vouloir enlever "§0" de la sélection !';
  WarViderListe = ' Etes-vous sûr de vouloir supprimer tous les éléments de la sélection!';

  // Bon de commande

  CdeSsGenre = 'Sans Genre';
  CdeListeVide = 'Liste de recherche vide...    ';
  CdeTitCritRech = 'Critère de recherche : ';
  CdeSaisLine = 'Saisie d''une ligne';
  CdeBcde = 'Bon de Commande';
  CdeOkModif = 'Modifiable';
  CdeNotModif = 'Non Modifiable';
  CdeCancelBcde = 'Abandonner toutes les modifications entreprises dans le document ? ' + #13 + #10 +
    'Toutes les modifications éventuellement faites dans les lignes seront abandonnées !';
  CdeCancelLine = 'Abandonner les modifications réalisées dans cette ligne ?   ';
  CdePostBcde = 'Enregistrer les modifications du document en cours ?    ';
  CdeTabloVide = 'Impossible de valider une ligne sans quantité saisie... ';
  cdeLineInModif = 'Pour pouvoir changer d''onglet,' + #13 + #10 +
    'il faut d''abord valider [F12] ou abandonner la ligne en cours de saisie ';

  CdePxBase = 'Prix de Base';
  CdeConfDelLine = 'Confirmer la suppression de la ligne sélectionnée...   ';
  CdeConfDelBcde = 'Confirmer la suppression complète du document affiché... ';
  CdeConfConfDelBcde = 'La suppression de ce document est irréversible !' + #13 + #10 +
    'Etes-vous bien certain de vouloir le supprimer ?   ';
  CdeFournOblig = 'La saisie du fournisseur est obligatoire! ... ';
  CdeMagOblig = 'La saisie du magasin est obligatoire!...    ';
  CdeExercice = 'La saisie de l''exercice commercial est obligatoire! ... ';
  CdeRgltOblig = 'La saisie des conditions de paiement est obligatoire!...   ';
  CdeOnlyOneSuppr = 'Plusieurs lignes sélectionnées...    ' + #13 + #10 +
    ' On ne peut supprimer qu''une seule ligne à la fois !     ';
  CdeNewBcde = 'Nlle Commande';
  CdeNewRecep = 'Nlle Réception';
  CdeNewTrans = 'Nx Transfert';
  CdeExerciceOblig = 'La saisie de l''exercice commercial est obligatoire...   ';
  CdeDateRglt = 'La date de règlement ne peut pas être antérieure à la date de livraison! ... ';

  CdeArchive = 'Confirmer l''archivage de(s) §0 document(s) sélectionné(s)...    ';
  CdeNoArchive = 'Aucun document à archiver... ';
  cdeVoirArch = '     Voir      archivés';
  cdeMaskArch = 'Masquer archivés';
  cdeVoirNM = '     Voir      Non modif';
  cdeMaskNM = 'Masquer Non Modif';
  cdeVoirClot = '     Voir      Clôturés';
  cdeMaskClot = 'Masquer Clôturés';
  BcdeHintBtnCancel = '[Echap] Ne pas créer une nouvelle ligne de commande pour cet article...';
  BcdeCapBtnMag1 = 'Afficher les autres &Magasins';
  BcdeCapBtnMag2 = 'Masquer les autres &Magasins';
  CarnetCdeLabMag = 'Carnet de commandes ';

  RechNoCollec = 'IMPOSSIBLE, aucune collection n''est sélectionnée... ';

  // FicheArticle

  MessExcel = ' Voulez-vous ouvrir Excel ?';
  InfExcel = ' Le fichier Excel §0 a été généré.';
  TipartPseudo = 'Pseudo';
  TipartRefSP2000 = 'Réf. SP2000';
  TipartCATMAN = 'CATMAN';
  TipartRef = 'Modèle';
  TipartCat = 'Catalogue';
  FartDelartCnf = 'de la fiche article - code chrono :';
  FartListeDes = 'Liste des';
  FartGarantie = 'GARANTIE CONSTRUCTEUR';
  TipartISF = 'Intersport';
  TipartMagISF = 'Modèle local';
  
  // ClassementDial

  ClasseTitle = ' Eléments du classement : ';
  ClasseDbgHint = '[INSER] Créer    [F2] Modifier    [SUPPR] Supprimer';

  ErrClassement = 'Ce nom de classement n' + #39 + 'est pas valide !';
  ErrItemClassement = 'Le nom n' + #39 + 'est pas valide !';
  ErrIntegrityArticle = 'Ce classement est utilisé par un article !';
  ErrIntegrityClient = 'Ce classement est utilisé par un client...';
  ErrClass0 = 'La suppression du classement "VIDE" n''est pas possible...';
  ErrLibClasse = 'Un classement ne peut être validé sans un nom significatif...';
  ClaDelItem = 'Confirmez la suppression du classement : §0   ';

  // Ficharticle

  FartRemPart = 'Outil de remplacement non encore implémenté';
  LaMarque = 'marque';

  ErrGarantie = 'Nom de garantie incorrect !';

  ErrDeleteGroupe = 'Suppression IMPOSSIBLE' + #13 + #10 + 'Le groupe "§0" est référencé par des articles !';
  ErrDeleteCollec = 'Suppression IMPOSSIBLE' + #13 + #10 + 'La collection "§0" est référencée par des articles !';
  ErrDeleteGarantie = 'Suppression IMPOSSIBLE' + #13 + #10 + 'La garantie "§0" est référencée par des articles !';
  ConfDelGroup = 'Confirmez la suppression du groupe :  §0     ';

  ErrCatGroupe = 'Nom de catégorie de groupe non valide !';
  ErrDeleteCatGroupe = 'Suppression IMPOSSIBLE' + #13 + #10 +
    'Catégorie de groupe "§0" référencée par un groupe !';

  RechVide = 'Aucune fiche trouvée';
  RechEof = 'Fin de la liste de recherche';
  RechBof = 'Début de la liste de recherche';
  RechFiltre = 'Impossible d''accéder à la fiche trouvée...' + #13#10 +
    'Vérifiez que vous n''avez pas un filtre en cours';
  OnRef = 'Référencement';
  OnIns = 'Création';
  ArtSupGroup = 'Supprimer le groupe "§0" pour cet article? ... ';
  ArtSupCollec = 'Supprimer la collection "§0" pour cet article ?...';

  ArtSupGarantie = 'Confirmez la suppression de la garantie §0';
  ErrEditGarantie = 'Le nom de cette garantie ne peut pas être modifié...';

  FartCBFNoValid = 'Code Barre fournisseur Non Valide ( ou déjà utilisé )...    ';

  Fart_dela = 'de la fiche article en cours...';
  FartCtrlCdmnt = 'Le champ conditionnement est décoché !          ' + #13 + #10 +
    #13 + #10 +
    'Un article ne peut être conditionné que si :   ' + #13 + #10 +
    '- L''unité est définie.' + #13 + #10 +
    '- La quantité de conditionnement est supérieure à 1';
  FartTdb = 'Prix de base';
  FartSupprTar = 'Confirmez la suppression du particulier de la taille affichée... ';
  FartNoGTaille = 'IMPOSSIBLE car aucune grille de tailles de sélectionnée... ';
  FartTarifExist = 'La taille §0 a déjà un tarif spécifique défini... ';
  FartErrMajTailles = 'Problème lors de la mise à jour du tarif ...     ' + #13 + #10 + 'Vos modifications sont abandonnées !';
  FartSupprTailBase = 'On ne peut pas supprimer le prix de base ! ... ';
  FartSupprTail = 'Pour supprimer des tailles travaillées' + #13 + #10 +
    'il faut commencer par la plus petite et descendre une à une...' + #13 + #10 +
    '( On ne peut supprimer ni la taille de base ni une taille intermédiaire )';
  FartAvortCrea = 'Création d''article impossible... ' + #13 + #10 +
    '  Problème de génération du prix de vente de base. ';
  TabachatStd = 'Tarif';
  TabachatCrea = 'Nouvel Article';
  FartNomartOblig = 'Le nom du modèle est obligatoire... ';
  FartFournOblig = 'La désignation d''un fournisseur est obligatoire ...     ';
  FartMarkOblig = 'La désignation d''une marque est obligatoire ...      ';
  FartCodeModeleOblig = 'Le code modèle doit contenir au moins trois caractères ...      ';
  FartCodeCouleurUnique = 'Le code couleur doit être unique dans le modèle ...      ';
  FartCodeCouleurTropCourt = 'Le code couleur doit contenir au moins trois caractères ...      ';
  FartArtCouleurCodeDefaut = 'UNI';
  FartArtCouleurNomDefaut = 'Unicolor';
  FartSsfOblig = 'La désignation d''un classement dans la nomenclature est obligatoire... ';
  FartGtOblig = 'La désignation d''une grille de tailles est obligatoire... ';
  FartFourCrea = 'Problème lors de l''initialisation du fournisseur... ';
  FartNeoFourn = 'Ajouter le fournisseur "§0" à la liste ' + #13 + #10 +
    'des fournisseurs de l''article en cours ? ';
  FartFournExist = 'Le fournisseur "§0" est déjà référencé par cet article...   ';
  FartFourn = 'Fournisseur';
  FartFPrin = 'Frn.Principal';
  CnfSupFourn = 'Confirmer la suppression du fournisseur "§0" ';
  FournSupPrin = 'Impossible de supprimer "§0" car c''est le fournisseur principal    ';
  FournDejaPrin = '"§0" est déjà le fournisseur principal...   ';
  ChangeFornPrin = 'Définir "§0" comme fournisseur principal ?   ';
  FartchangeSf = 'ATTENTION : Si vous venez de changer l''affectation nomenclature ' + #13 + #10 +
    ' de cet article, vérifiez que son affectation comptable et sa TVA conviennent toujours ! ';
  ArtRefMarque = ' Référence Marque : ';

  ErrCoefTheorique = 'Le coefficient théorique doit être supérieur à 0 !';
  CanModifHint =
    '[INS] Nouveau modèle [F2] Modifier [F12] Enregistrer [SUPPR] Supprimer le modèle [Clic Droit] Popup Menu';
  CannotModifHint = 'Fiche modèle';
  HintNotEditChpTaille = '[F4, Double Clic ou Bouton] Liste des tailles travaillées du modèle';
  HintInsertChpTaille = '[F4, Double Clic ou Bouton] Liste des grilles de tailles  [Suppr] Supprimer la grille de tailles sélectionnée';
  HintEditChpTaille = '[F4, Double Clic ou Bouton] Gestion des tailles travaillées du modèle';
  HintDesDbgs = '[INS] Ajouter un nouvel élément  [SUPPR] Supprimer l''élément sélectionné';
  HintEditFourn = 'Liste des fournisseurs référencés pour ce modèle    ';

  TitleStk = 'Etat de stock de l' + #39 + 'article - Chrono :';
  TitleRal = 'Reste à Livrer de l' + #39 + 'article - Chrono :';
  TitleStkMM = 'Etat de stock par magasin de l' + #39 + 'article - Chrono :';
  TitleRalMM = 'Reste à Livrer par magasin de l' + #39 + 'article - Chrono :';
  TitleHistoFourn = 'Historique d''achat de l''article - Chrono : ';

  MsgLKNotEdit = 'Vous n''êtes pas en édition ! Impossible de mettre à jour la fiche article... ';
  ChronoMess = ' Le préfixe n''est pas modifiable';
  SupprImgCap = ' Suppression de l''image associée';
  CopyImgCap = ' Association d''une image à l''article en cours';
  SupprImg = 'Supprimer l''image associée à l''article en cours ?';
  Fart_UnikChrono = 'Ce code chrono est déjà pris par un autre article... ';
  FartNoFourn = 'Avant de saisir le tarif il faut définir le fournisseur principal !    ';
  FartCoulGes = 'Gestion des couleurs de l''article';
  FartCoulVisu = 'Liste des couleurs définies pour l''article';
  FartSupprGT = 'La suppression de la grille de tailles va supprimer le tarif défini... ' + #13 + #10 +
    'Faut-il continuer ?';
  ErrPasMrk = 'Impossible de créer un article si aucune marque n''existe !';

  // Gesart_Frm

  ErrFermerFiche = 'Vous devez valider ou abandonner les modifications §0 !';

  FicheArticle = 'de la fiche Article';
  QuitHint = 'Quitter la gestion des articles';
  OutBarHint = 'Barre des fonctions';

  // Image_Frm
  ImageCap = ' Image de l''article : ';

  // Grilles de tailles

  MessQuitGTF = 'Attention, pour sortir vous devez VALIDER ou ABANDONNER  les modifications en cours...';
  MessOngletGTF = 'Attention, pour changer d''onglet vous devez    ' + #13 + #10 +
    ' VALIDER ou ABANDONNER  les modifications en cours...';
  MessGtfLibVid = 'Le nom de la grille de tailles est obligatoire...';
  MessNbtaille = 'Impossible de valider votre grille de tailles, elle ne contient pas de taille...';
  MessModLibGTF = 'Impossible de changer le libellé d''une grille de tailles de référence';
  MessModLibTail = 'Impossible de changer le libellé d''une taille de référence';
  MessModLibVid = 'Le nom du modèle est obligatoire...';
  MessMod28 = 'Impossible, le nombre de tailles travaillées est limité à 28...';
  GtfHintTailles = '[INS] Insérer une nouvelle taille   [CTRL+INS] Insérer une sous-taille';
  GtfNoDelete = 'IMPOSSIBLE de supprimer cette grille de tailles car elle est utilisée !...   ';
  GTSCannotDelete = 'IMPOSSIBLE de supprimer la grille de tailles statistique "§0" ' + #13 + #10 +
    ' car elle est référencée par une Sous-Famille.';

  GtfModeleHint = '[F3] Sélectionne la taille pointée  [Double Clic] Ajoute la taille pointée à la liste des tailles travaillées';
  GtfModeleHint2 = '[F3] Sélectionne la taille pointée  [Double Clic] Retire la taille pointée de la liste des tailles travaillées';
  MessModEnf = 'Impossible de déplacer cette "taille", car la taille parent n''est pas un sélectionnée...';
  MessGTSCancel = 'Abandonner les modifications effectuées dans la grille de tailles "§0"   ';
  GtsCreaChpOblig = 'Le nom et la catégorie doivent être obligatoirement renseignés! ... ';
  GtfManqueNom = 'Le nom de la taille doit être obligatoirement défini... ';
  GtfCancelWork = 'Abandonner tout le travail effectué sur cette grille de tailles ? ... ';

  MessSupCoulTer = 'Impossible de supprimer cette couleur,' + #13 + #10 + '   car elle est présente dans les commandes...';
  SelcoulDbg = '[F4] et [Double Clic] Exécuter la fonction associée au bouton';
  CoulFormHint = '[F12] OK  [Echap]  Abandonner';
  CoulOkGesFormHint = '[Ins] Créer [F2] Editer [Suppr] Supprimer [F4] Ouvrir liste';
  CoulStatOkGesFormHint = '[Ins] Créer [Ctrl+Ins] Sous-couleur [F2] Editer [F12] Ok';
  RecepModerOblig = 'La saisie du mode de règlement est obligatoire! ... ';

  // Marque_Frm

  messMARQUEGtf = 'Attention vous pouvez déplacer 100 tailles maximums à la fois...';

  // SelGt_Frm

  SelTTailO = 'La sélection d''au moins une taille travaillée est obligatoire... ';
  SelGTTitle = ' Sélection d''une grille de tailles et des tailles à travailler';

  // Fournisseurs
  FourNoVille = 'Attention pas de ville !!!';
  FourErrNoDelete = 'Impossible de supprimer ce fournisseur car il a des données associées     ';
  FourCnfDel = 'Etes-vous sûr de vouloir supprimer ce fournisseur?';
  ErrNoPaysListeFact = 'Vous devez obligatoirement renseigner le pays de cette ville §0';
  ErrNoPaysExprfourn = 'Vous devez obligatoirement renseigner le pays de cette ville §0';
  ErrNoVilleExprfourn = 'Vous devez obligatoirement renseigner la ville du fournisseur §0';
  ErrNomFournExprfourn = 'Le nom du fournisseur est obligatoire !';
  ErrMrkFournExprfourn = 'Vous devez associer au moins une marque à ce fournisseur';
  ErrNoPays = 'Vous n' + #39 + 'avez pas défini de pays pour cette ville §0';
  ErrNomFourn = 'Un fournisseur doit obligatoirement avoir un nom !';
  ErrMrkFourn = 'Vous devez associer au moins une marque à ce fournisseur';
  FourChangePrin = 'Le fournisseur principal de cette marque est    ' + #13 + #10 +
    '  " §0 "' + #13 + #10 +
    '  Faut-i le remplacer par' + #13 + #10 +
    '  " §1 " ?   ' + #13 + #10 + '   ';

  MessQuitFourn = 'Attention, pour sortir vous devez VALIDER ou ABANDONNER  les modifications en cours...';
  ErrMrkDel = 'Etes-vous sûr de vouloir enlever cette marque ?';

  // Etiquettes article

  EtqVidQte = 'Vider les quantités du tableau';
  EtqLoadQte = 'Recharger les quantités en stock';
  EtikVide = 'Aucune étiquette à imprimer...     ';
  NomTaille = 'Taille : ';
  NomTailleItalie = 'Taglia : ';
  NomImprimante = 'Vous devez choisir une imprimante !';

  // Bons de reception
  RecepRalFourn = 'Liste des RAL du fournisseur : ';
  RecepOkCloture = 'Confirmer la clôture du bon de réception affiché... ' + #13 + #10 +
    '  ATTENTION : ce document ne sera plus modifiable ! ';
  RecepArtExist = 'Cet article est déjà référencé dans le bon de réception ! ... ';
  RecepCadExist = '[ Chrono : "§0" ] Cette cadence est déjà référencée dans le bon de réception. ' + #13 + #10 +
    '   Faut-il compléter cette ligne avec les quantités restant à livrer ? ... ';
  RecepDateRglt = 'La date de règlement ne peut pas être antérieure à la date de livraison! ... ';
  RecepNoRal = 'Aucun reste à livrer chez ce fournisseur...     ';
  RecepNotModif = 'Clôturé';
  TransArtExist = '[ Chrono : "§0" ] Cet article est déjà référencé dans le bon de transfert ! ... ';
  TransIdemMag = 'Magasin d''origine et de destination doivent être différents ! ... ';
  CdeNoDocVide = 'Impossible de valider un " document " vide ! ... ';
  CdeNoChangeChp = 'Modification impossible lorsque le document a des lignes... ';
  TransOkCloture = 'Confirmer la clôture du bon de Transfert affiché ...   ' + #13 + #10 +
    '  ATTENTION : ce document ne sera plus modifiable ! ';
  CdeVR = 'Voir RAL';
  CdeNVR = 'Masquer RAL';
  CdeTitreListe = '  Liste des bons de commande';
  recepTitreListe = '   Liste des bons de réception';
  transTitreListe = '   Liste des bons de transfert';
  TransIsNega = 'ATTENTION : le stock de cette taille / couleur va devenir négative ! ... ';
  TransNoEdit = 'IMPOSSIBLE de modifier un bon de transfert au-delà de 30 jours ! ... ';
  TMMHintStkCour = 'Les transferts saisis ne seront pris en compte dans le stock affiché qu''après validation du bon... ';
  TMMHintStkDate = 'Le stock affiché est le stock à la date du bon "APRES LE TRANSFERT" ';
  TMMStkCour = 'Stock courant';
  TMMStkDate = 'Stock au';

  StkChkCoulS = 'Couleurs affichées';
  StkChkCoulM = 'Couleurs masquées';
  StkPPL = 'Etat de stock du magasin : ';
  PPStkHint = 'Paramétrage des colonnes à éditer';
  CmzEditDoc = 'Afficher / Masquer l''outil de configuration de l''édition';
  SbtnEditDoc = 'Imprimer le document';
  SelectLineBre = 'Vous devez sélectionner les lignes que vous voulez ré-étiquetter !';
  RecepCapFrmRal = ' Restes à livrer : ';

  RecepErrInitTab1 = 'Problème lors de la création de cette ligne de réception...';
  RecepErrInitTab2 = 'Cette ligne doit être abandonnée...';
  RecepErrInitTab3 = 'Réessayez une nouvelle fois et...';
  RecepErrInitTab4 = '        Merci de prévenir GINKOIA SA qu''il subsiste des problèmes lors de la     ';
  RecepErrInitTab5 = '        création de nouvelles lignes de réception.';

  // Edition de caisse

  JVTklDateLib = 'Journal des ventes du §0 au §1  -  ';
  HITParadeVte = 'Hit parade des ventes du §0 au §1  -  ';
  JVTkeDateLib = 'Liste des tickets du §0 au §1  -  ';
  JvTklSel = 'Sélection de magasins';
  FontCourierNew = 'Courier New';

  ConsoDivLib = 'Consommations diverses du §0 au §1  -  ';

  ChxDateJV = 'Période incorrecte ! ... Le date de fin ne peut être antérieure à celle de fin. ';
  ChxSessJV = 'Choix de session non valide ! ....    ';
  CHXDateJVMP = 'Le choix d''un magasin et d''un poste sont obligatoire... ';
  CptCltTit = 'Comptes clients  ';

  // Clients

  ErrNomClient = 'Vous devez obligatoirement spécifier un nom pour ce client';
  ErrNoAdrClient = ' La saisie d''une adresse est obligatoire';
  ErrCivClient = ' Vous devez spécifier une civilité pour ce client ';
  ErrRecheditClient = 'Vous ne pouvez pas effectuer une recherche sans valider la fiche en cours';

  // Etiquettes

  TitreEtikBR = ' Impression des étiquettes du Bon de Réception';
  EtikPlanche = 'Etiquette Planche';
  // Edit stkMag

  ArtStkTitle = 'Etat du stock';

  // Param

  ErrCtpAV = ' Au moins un compte doit être renseigné!';

  // Consos
  CdvOblig = ' La saisie du champ "§0" est obligatoire ! ... ';
  CdvNoPx = ' Le prix unitaire de cet article est à "0.00"... ' + #13 + #10 +
    '   (Il n''est certainement pas référencé en stock à cette date )' + #13 + #10 + #13 + #10 +
    '   Faut-il continuer et accepter cette opération ?';
  CdvCtrlDate = ' La date de cette opération ne peut pas être postérieure ' + #13 + #10 +
    '   à la date courante... ';
  CdvDelai = ' Cette opération n''est plus modifiable... ';
  HintConsodiv = 'Pour une nouvelle ligne de consommation... rechercher l''article     [F12] Enregistrer [Echap] Abandonner [F2] Modifier';

  // Ressourcesstring communes des applications
  // ******************************************

  // 29/01/2001 - Sandrine MEDEIROS - ajout Messages Classiques : WarAbandon, WarAbandonCreat, WarAbandonModif

  //--------------------------------------------------------------------------------
  // Messages d'erreurs BDD
  //--------------------------------------------------------------------------------

  ErrLectINI = 'Erreur de lecture du fichier d''initialisation';
  ErrConnect = 'Erreur de connection à la base de données';
  ErrTransaction = 'Mise à jour impossible de la base de donnée.' + #13 + #10 + '   Pas de transaction Active';
  ErrBD = 'Problème avec la base de données';
  ErrMajDB = 'Impossible de mettre à jour la base de données. Modifications annulées.';
  ErrCommit = 'Impossible de valider les informations dans la base de donnée';
  ErrRollback = 'Impossible d''annuler les informations dans la base de donnée';
  ErrGenId = 'Problème avec le générateur de clé de la base';
  ErrNoFieldDef = 'Pas de champ défini pour la table §0';
  ErrNoPkFieldDef = 'Pas de clé primaire définie pour la table §0';
  ErrNoPkFieldFound = 'La clé primaire §0 doit être présente dans la query';
  ErrNoDeleteNullRec = 'La suppression de cet enregistrement n''est pas autorisée    ';
  ErrNoEditNullRec = 'La modification de cet enregistrement n''est pas autorisée     ';
  ErrNoDeleteIntChk = 'Cet enregistrement étant référencé vous ne pouvez pas le supprimer    ' + #13 + #10 +
    '   (Le supprimer détruirait la cohérence de vos données)';
  ErrUsingScript = 'Utilisation incorrecte de script SQL';
  ErrNegativeTransac = 'Compteur de transaction négatif !    ' + #13 + #10 +
    'Prévenir GINKOIA SA en précisant bien le contexte dans lequel cela se produit    ';
  ErrToMuchTransac = 'Problème de gestion du compteur de transaction' + #13 + #10 +
    'Le signaler à GINKOIA en précisant bien le contexte dans lequel cela se produit.   ';

  errSQL803 = 'Doublon dans un identifiant unique. Mise à jour impossible.';
  errSQL625 = 'Champ obligatoire non défini. Mise à jour impossible.';
  errSQL = 'Erreur SQL n°§0.  Mise à jour impossible.';

  //--------------------------------------------------------------------------------
  // Messages d'erreurs ReportBuilder
  //--------------------------------------------------------------------------------

  ErrInitRap = 'Impossible d''initialiser le module Report Builder';
  ErrLoadReport = 'Impossible de charger le rapport §0';
  ErrDesignReport = 'Impossible de modifier le rapport §0';
  ErrArchivingtReport = 'Impossible d''archiver le rapport §0';
  ErrParamNotDefined = '< Non défini >';
  InfLoadingMessage = 'Veuillez patienter...';

  //--------------------------------------------------------------------------------
  // Messages d'erreurs UIL
  //--------------------------------------------------------------------------------

  ErrInitUil = 'Impossible d''initialiser le module Uil Security System';
  ErrLogin = 'Nom d''utilisateur ou mot de passe incorrect';
  ErrOverLoginActive = 'Un sur-login est déjà en cours';
  ErrOverLoginNotActive = 'Pas de sur_login actif';
  NoAcces = 'Vous n' + #39 + 'avez pas le droit d' + #39 + 'accéder aux §0.';
  LesPerm = 'Permissions';
  LesGroup = 'Groupes';
  RS_TXT_UIL_ErreurConfirmationCode = 'Erreur lors de la confirmation du mot de passe';

  //--------------------------------------------------------------------------------
  // Messages de gestion des pages
  //--------------------------------------------------------------------------------

  ErrPgTab = 'Changement d''onglet interdit' + #13 + #10 + '   tant que vous n''avez pas terminé le travail en cours...';
  ErrItemMenu = 'Fonction désactivée     ' + #13 + #10 + '   tant que le travail en cours n''est pas Enregistré ou Abandonné...';
  ErrFullPages = 'Impossible d''ouvrir un onglet de plus...     ' + #13 + #10 + '   Le maximum autorisé est atteint...';
  ErrTacheOpen = 'Vous ne pouvez pas quitter le programme       ' + #13 + #10 + '   tant qu''il reste des "onglets" ouverts...';
  ErrPgFc = 'Changement d''onglet interdit' + #13 + #10 + '   il reste du travail inachevé dans une page...';

  //--------------------------------------------------------------------------------
  // Messages Classiques
  //--------------------------------------------------------------------------------

  WarAbandon = 'Etes-vous sûr de vouloir abandonner le travail en cours ?';
  WarCancel = 'Etes-vous sûr de vouloir abandonner les modifications effectuées ?';
  WarAbandonCreat = 'Etes-vous sûr de vouloir abandonner votre création §0 ?';
  WarAbandonModif = 'Etes-vous sûr de vouloir abandonner votre modification §0 ?';
  WarSuppr = 'Confirmez la suppression §0 ... ';
  WarPost = 'Enregistrer le travail en cours ?';

  ErrIdRefCentrale = 'Cette §0 a été fournie par §1, elle n' + #39 + 'est pas modifiable !';
  ErrIdRefCentrale1 = 'Ce §0 a été fourni par §1, il n' + #39 + 'est pas modifiable !';

  //--------------------------------------------------------------------------------
  // Hints Standards
  //--------------------------------------------------------------------------------
  HintEditMemo1 = '[F4 ou Double Clic ou Bouton] Ouvre la zone d''édition associée au bouton';
  HintNoEditMemo1 = 'La zone d''édition n''est pas accessible';
  HintEditLookup1 = '[F4 ou Double Clic ou Bouton] Ouvre la liste associée au bouton  [Suppr] Effacer';
  HintNotEditLookup1 = 'La liste associée au bouton n''est pas accessible';
  HintEditCheck1 = 'Appuyer sur la barre d''espace ou cliquer pour inverser l''état de la coche';

  // Ressourcesstring communes des applications
  // ******************************************


  //****************************
  // Ressources de la caisse
  //****************************

      //28/02/2002 Bruno
  TrancheVide = 'Impossible, la correspondance entre la monnaie et les points est à zéro';

  // Pascal 27/02/2002
  CstProbSession = ' Vous avez un problème de clôture'#13#10 +
    'Veuillez noter le message d''erreur et appeler GINKOIA'#13#10 +
    'Cliquer sur OK pour visualiser le message d''erreur';
  // Pascal 18/02/2002
  CstPasVersement = 'Aucun type de versement n''a été sélectionné';
  CstPasCoffre = 'Aucun coffre n''a été sélectionné';
  CstPasBanque = 'Aucune banque n''a été sélectionnée';

  // Bruno 18/02/2001
  RegulGlob01 = 'Dans un premier temps, vous allez devoir choisir le ticket à corriger.' + #13 + #10 +
    ' ' + #13 + #10 +
    '   Ensuite, Vous pourrez intervenir directement sur les encaissements réalisés sur ce ticket.';

  RegulGlob03 = 'Confirmez-vous l''annulation de votre correction d''encaissement?';

  // Bruno 15/02/2002
  ClientPasPossible = 'Impossible d''appeler ce client en caisse...';

  // 15/02/2002 Correction
  CstPasDencaissement = 'Aucun encaissement de ce type n''existe dans la session';
  //15/02/2002
  CstLibVerifComptage = 'Comptage  : Pièce %4d    Montant %10.2n';
  CstTickNum = 'Ticket num ';

  // Pascal 11/02/2002
  CstPanMoy = 'Panier moyen';
  CstValeur = 'Valeur';
  CstQuantite = 'Quantité';
  CstVtProduit = 'Vente produit %s';
  CstVersAutoCoffre = 'VERSEMENTS AUTO AU COFFRE';
  CstVersAutoBQe = 'VERSEMENTS AUTO EN BANQUE';
  // Pascal le 7/02/2002
  CstDuAu = 'Du %s au %s';

  // Trié
  Pas2Caisse = 'Vous ne pouvez pas, sur un même poste, activer plusieurs fois le module ''Caisse Ginkoia''...';

  DejaClientEnCours = 'Attention vous ne pouvez pas appeler ce client, il est déjà en cours sur une autre caisse...';

  Aucuntrouve = 'Aucun article trouvé correspondant à votre saisie...';
  LibSousTotal = 'SOUS TOTAL';
  Question = 'Souhaitez-vous terminer' + #13 + #10 + 'le ticket en cours ?';
  LibTicketenCours = 'Impossible de quitter la caisse, vous avez un ticket en cours...';
  LibRapido = 'Impossible vous avez déjà effectué des opérations dans l''onglet ''Encaissement''...';
  PasSessionEnCours = 'Attention, il n''y a pas de session en cours...';
  PasClientEnCours = ' Impossible, vous n''avez pas de client en cours ';
  Acompte = 'Acompte';
  Reglement = 'Reglement du compte';
  TXT_ReglementFacture = 'Règlement facture';
  Remboursement = 'Remboursement';
  TestAppelClient = 'Impossible, il y a des opérations en cours pour le client actuel...';
  RenduPasPossible = 'Attention le ''Rendu de monnaie'' est interdit pour ce mode de paiement...';
  CompteBloque = 'Opération impossible, le compte du client est bloqué...';
  SoldeNonCrediteur = 'Opération impossible, le solde du compte client n''est pas créditeur...';
  CreditEpuise = 'Attention vous avez épuisé le crédit du compte...';
  OpeAnnule = 'Opération annulée, le reste à payer est nul...';
  TotAcoReg = 'TOTAL OPERATIONS CLIENT';
  TotVente = 'TOTAL DES VENTES';
  PasVendeur = 'Attention, votre caisse est paramétrée avec une gestion vendeur,' + #13 + #10 + 'mais vous n''avez pas créé de vendeur...';
  PasCaissier = 'Attention, votre caisse est paramétrée avec une gestion caissier,' + #13 + #10 + 'mais vous n''avez pas créé de caissier...';
  LibTicketVide = 'TICKET VIDE';
  LibTicketCours = 'TICKET EN COURS';
  TotalAPayer = 'TOTAL A PAYER';
  ARendre = 'A RENDRE';
  MoinsRemise = '  DONT REMISE : ';
  TotalVente = 'TOTAL DES VENTES';
  TotalEuros = '  (SOIT ';
  Euros = ' EUR)';
  ImpressionCheque = 'Insérez le chèque à imprimer pour un montant de ';
  PBLImpressionCheque = 'Problème lors de l''impression du chèque.' + #13 + #10 + ' Insérez le chèque à imprimer pour un montant de ';
  Caissier = 'CAISSIER : ';
  TermineLigne = 'Les boutons seront actifs lorsque la ligne en cours sera validée...';

  NomClient = 'Votre client doit avoir un nom ou un prénom !';
  TicketDuplicata = 'DUPLICATA';
  TicketenCoursBis = 'Opération impossible, vous avez un ticket en cours...';
  Le = 'Le ';
  Facture = 'FACTURE';
  ImpressionFacurette = 'Veuillez insérer le document à imprimer...';
  PblImpressionFacturette = 'Problème lors de l''impression.' + #13 + #10 + 'Veuillez insérer à nouveau le document...';
  ImpressionFacuretteSuite = 'Veuillez insérer le document suivant à imprimer...';
  PblImpressionFacturetteSuite = 'Problème lors de l''impression.' + #13 + #10 + 'Veuillez insérer à nouveau le document suivant...';

  FactureNumero = 'Facture Numero : ';
  LibCaissier = 'Caissier : ';
  LibVendeurCaisse = 'Vendeur  : ';
  AnnuationTck = 'ANNULATION DU TICKET NUMERO ';
  LbCorrectionMP = 'CORRECTION ENCAISSEMENT';
  LibCorrectionMP = 'Opération impossible, vous êtes en correction d''encaissement...';

  QuestionDepense = 'Confirmez-vous la saisie de dépense?';
  //Attention les champs qui suivent sont avec des espaces
  //C'est pour l'impression sur la TM, il faut toujours tenir compte
  //de la longueur des champs.
  CdArticle = 'ARTICLE   ';
  Desi = 'DESIGNATION ARTICLE                            ';
  Puttc = '  PU TTC  ';
  LibRemise = '  REMISE ';
  Qte = '  QTE ';
  PxTCC = ' TOT TTC  ';
  Ltaux = ' TAUX ';
  LTVA = '    TVA   ';
  LMHT = 'MONTANT HT';

  //Cloture de session

  InfLibelleTke = 'Encaissement Ticket N° ';
  InfNoEcheance = 'Disponible';
  InfTitreFond = 'Fond de caisse initial et mouvement d''argent';
  InfTitreEncaissement = 'Encaissements réalisés';
  InfEtatSesClotCtrl = 'Clôturée et contrôlée';
  InfEtatSesClotNoCtrl = 'Clôturée mais non contrôlée';
  InfEtatSesOuverte = 'Ouverte';
  ErrRecNotFound = 'Enregistrement non trouvé. Mise à jour impossible';

  InfApportFromSession = 'Fond Initial';
  InfRetraitToSession = 'Retrait vers la session n°';
  InfVersementBanque = 'Versement à la banque ';

  InfApportPoste = 'Apport en caisse : ';
  InfRetraitPoste = 'Retrait de la caisse : ';
  InfComptageGlobModeEnc = 'Comptage global d''un mode d''encaissement';
  InfComptageDetModeEnc = 'Comptage détaillé d''un mode d''encaissement';
  InfPrelevement = 'Saisie manuelle d''un prélèvement';

  //Gestion du coffre

  InfNoMagasin = 'Aucun magasin existant';
  InfNoCoffre = 'Aucun coffre existant';
  //InfNoEcheance = 'Disponible';

  InfCreditingCff = 'Créditer le coffre : ';
  InfDebitingCff = 'Débiter le coffre : ';

  //Journal de caisse

  TitleJC = 'Journal de Caisse';

  //Mode encaissement
  InfNewModeEnc = 'Nouveau mode d''encaissement';
  //InfNoMagasin = 'Aucun magasin existant';
  InfDetailDefini = '<Défini>';
  InfDetailIndefini = '<Indéfini>';

  //Ouverture de session
     //InfEtatSesClotCtrl   = 'Clôturée et contrôlée';
     //InfEtatSesClotNoCtrl = 'Cloturée mais non controlée';
     //InfEtatSesOuverte    = 'Ouverte';
  InfNumSession = ' - Session n° ';
  ErrNoPosteNoSession = 'Pas de poste ou de session sélectionnée';
  //InfNoEcheance        = 'Disponible';
  ErrOpenedSessionExists = 'Il existe déjà une session ouverte sur ce poste';
  ErrNoMoreThan1SessionCounted = 'Clôturez les sessions en cours sur ce poste avant d''en ouvrir une autre';
  //ErrRecNotFound       = 'Enregistrement non trouvé. Mise à jour impossible';
  //InfApportFromSession = 'Fond Initial';
  //InfRetraitToSession  = 'Retrait vers la session n°';

   //InfApportPoste = 'Apport en caisse : ';
   //InfRetraitPoste = 'Retrait de la caisse : ';

//Saisie des opérations

  ErrNoLibelle = 'Aucun libellé saisi';
  ErrInvalidAmount = 'Montant saisi incorrect';
  ErrNoModeEnc = 'Aucun mode d''encaissement sélectionné';
  ErrInvalidSource = 'Pas de source sélectionnée';
  ErrInvalidDest = 'Pas de destination sélectionnée';
  InfMontant = 'Montant en ';
  ErrInvalidQte = 'Nombre de pièces saisies incorrect';

  //General

      //PasCaissier = 'Attention, votre caisse est paramètrée avec une gestion caissier,' + #13 + #10 + 'mais vous n''avez pas créé de caissier...';
      //PasSessionEnCours = 'Attention, il n''y a pas de session en cours...';
  InitModeEncImpossible = 'Impossible, des modes de paiement existent déjà pour ce magasin...';
  Pascoffre = 'Vous devez au préalable créer un coffre pour ce magasin...';
  Pasbanque = 'Vous devez au préalable créer une banque pour ce magasin...';
  BtnDejaCree = 'Attention des boutons existent déjà, voulez-vous les supprimer?';
  CaisseEnCours = 'Impossible de clôturer la session, la caisse est encore ouverte';
  TMnonConnectee = ' L''imprimante ticket n''est pas allumée ou pas branchée...';
  TCnonConnecte = ' Le tiroir caisse n''est pas branché...';
  JourDifferentSessionL1 = ' Attention, il existe une session en cours ouverte le ';
  JourDifferentSessionL2 = 'Souhaitez-vous clôturer la session?';
  ConfAnnul = 'Confirmez-vous l''annulation de ce ticket?';
  DejaAnnule = 'Opération impossible, ce ticket est déjà annulé...';
  AnnulRegul = 'Annulation de la correction des encaissements en cours?';
  Pasledroit = 'Attention, vous n''avez pas les droits pour utiliser cette fonction...';
  TicketSimple = 'Ticket simple';
  TicketTVA = 'Ticket avec TVA';
  Facturet = 'Facturette';
  TicketSansPrix = 'Ticket sans prix';
  Noticket       = 'Pas de ticket'; 
  SupEncaissement = 'Confirmez-vous l''annulation de cet encaissement?';
  CaptionAnnul = 'Annulation d''un ticket';
  CaptionCptcli = 'Liste des tickets';
  CaptionRegul = 'Correction des encaissements';

  //Param Caisse
  Chrono = 'Code Chrono';
  RefFourn = 'Ref. Fournisseur';

  //Ticket Fidelite

  PointPrecedent = 'POINTS DEJA OBTENUS :';
  PointDuJour = 'ACQUIS CE JOUR :';
  PointTotal = 'TOTAL DES POINTS :';
  PointMontantL1 = 'EQUIVALENT A';
  PointMontantL2 = 'UN BON D''ACHAT DE :';
  MontantBA = 'VALEUR DU BON D''ACHAT :';
  NombreTicket = 'NOMBRE DE TICKETS :';
  PasdeCarteFidelite = 'Ce client n''a pas de carte de fidélité...';
  DAteDebut = 'CARTE OUVERTE LE :';
  PointObtenir = 'NOMBRE DE POINTS A OBTENIR :';
  BADispo = 'POINTS CUMULABLES JUSQU''AU';
  Utilisable = 'UTILISABLE JUSQU''AU';
  GenerationBAL1 = 'Votre client a droit à un Bon d''achat de';
  GenerationBAL2 = 'Souhaitez-vous le générer aujourd''hui?';
  BenefBA = 'Votre client bénéficie d''un bon d''achat de';
  ValiditeBA = 'valide jusqu''au';
  QuestionBenefBA = 'Est ce qu''il souhaite l''utiliser maintenant?';
  PasModeEncFidelite = 'Opération impossible, vous n''avez pas de mode d''encaissement avec le type ''Fidélité''';
  FidManuel = 'Points fidélités saisis manuellement, pas de liaison avec un ticket de caisse...';
  BaPasUtilise = 'Ce bon d''achat n''a pas été utilisé...';
  BonAchat = 'Bon d''achat';
  NewParamCF = 'La liste des bons d''achat va être recalculée sur la base du paramétrage que vous venez de saisir. ' +
    'Le paramétrage précédent va être effacé...' + #13#10#13#10 +
    'Faut-il continuer ?';
  BAImcomplet = 'Le paramétrage est incomplet...';

  LibTyp0 = 'Pas de carte fidélité';
  LibTypA = 'Type A (Nbre de passages)';
  LibTypB = 'Type B (Période)';
  LibTypC = 'Type C (Nbre de points)';

  //Compte client
  PositionCompte = 'POSITION DU COMPTE';
  SoldeCrediteur = 'SOLDE CREDITEUR :';
  SoldeDebiteur = 'SOLDE DEBITEUR :';

  //param caisse
  Bouton = 'Boutons';
  Grille = 'Grille';

  Centime = 'Centime';
  Decime = 'Decime';
  Unite = 'Unité';
  Dizaine = 'Dizaine';
  Centaine = 'Centaine';

  //Lib Btn Appel Client
  Creation = 'Création [INS]';
  Visu = 'Visu. [F2]';

  vente = 'Vente';
  Client = 'Client';
  Encaissement = 'Encaissement';
  Utilitaires = 'Utilitaires';
  BonLocA4 = 'Format A4 (2 Bon A5)';
  BonLocA5 = 'Format A5';
  BonLocA4Ident = 'Format A4 Trié par identité (2 Bon A5)';
  BonLocA5Ident = 'Format A5 Trié par identité';
  BonLocEtq     = 'Format Etiquette';

  Promo = 'Promo';
  Solde = 'Solde';
  Normale = 'Normale';

  PasTypeBouton = 'Attention vous n''avez pas sélectionné la fonction du bouton...';
  PasTypeRemise = 'Attention vous n''avez pas indiqué le type de la remise...';
  PasArticle = 'Attention vous n''avez pas indiqué l''article associé au bouton...';
  PasModeenc = 'Attention vous n''avez pas indiqué le mode d''encaissement associé au bouton...';
  AttTFDejaUtil = 'Attention, cette touche de fonction est déjà utilisée...';
  TfVide = 'Vide';
  ParamBtn = 'Attention cette opération rétablie les boutons d''origine.' + #13 + #10 +
    '   Souhaitez-vous poursuivre la réinitialisation?';
  QuitterBtn = 'Pour que les changements soient pris en compte, il faut fermer tous les tickets en cours.' + #13 + #10 +
    '   Lorsqu''il ne reste plus que l''onglet ''Ecran de contrôle'' vous pouvez réouvrir la caisse...';
  CopierBtn = 'Attention cette opération détruit les boutons existant et les remplace' + #13 + #10 +
    '   en prenant comme modèle une caisse que vous allez sélectionner ensuite.' + #13 + #10 +
    '   Souhaitez-vous poursuivre le traitement?';

  // Pascal 24/01/2002
  CstEditComptage = 'EDITION DU COMPTAGE';
  CstPostDate = '%s, Le %s';
  CstSession = 'Session Num %s';
  CstTitreImp1 = 'Encaissement       | Qte  |   Montant  ';
  CstTotalImp = 'TOTAL              |      |';
  CstDetailImp = 'Detail de %s';
  CstPiece = 'Piece Num %s';
  CstEditEnc = 'EDITION DES ENCAISSEMENTS';
  CstEditEncTitre = ' Edition des encaissements de la session';
  CstMontantCaption = 'Montant encaissé';
  CstTypeEnc1 = 'Apport initial';
  CstTypeEnc2 = 'Encaissement';
  CstTypeEnc3 = 'Prélèvement manuel';
  CstTypeEnc4 = 'Prélèvement automatique';
  CstTypeEnc5 = 'Versement à une session';

  CstLaBanque = 'LA BANQUE';
  CstLeCoffre = 'LE COFFRE';
  CstChequeEuro = 'CHEQUES EURO';
  CstEspeceFranc = 'ESPECES FRANCS';
  CstEspeceEuro = 'ESPECES EURO';
  CstEspece = 'ESPECES';
  CstCheque = 'CHEQUES';
  CstCBEuro = 'CB EURO';
  CstCarteBleu = 'CARTES BLEUES';
  cstBonAchInt = 'BON D''ACHAT INTERNE';
  cstBonAchExt = 'BON D''ACHAT EXTERNE';
  CstRemiseFidelite = 'REMISE CARTE FIDELITE';
  CstCompteClient = 'COMPTES CLIENTS';
  CstResteDu = 'RESTE DU';
  CstAutreCarte = 'AUTRES CARTES';
  CstVirement = 'VIREMENT';
  CstChequeVacance = 'CHEQUES VACANCES';
  CstClient = 'Clients';
  CstTicket = 'Ticket';
  CstRetour = 'Retour';
  CstEditerLe = 'EDITE LE %s';
  CstNbrTicket = 'Nombre de tickets';
  CstPanMoyVal = 'Panier Moyen en valeur';
  CstEnQuantite = '                    en Quantité';
  CstEnQte = '             en Qte';
  CstCA = 'CHIFFRE D''AFFAIRES';
  CstVenteProduit = '      Vente produit %s%%';
  CstVente = ' Vte %s%%';
  CstTVA1 = '      TVA %s%%';
  CstTVA2 = ' TVA %s%%';
  CstReglementClient = 'REGLEMENTS CLIENTS';
  CstCltDiv1 = '      Clients divers';
  CstCltDiv2 = ' Clt. div';
  CstRemise = 'REMISES';
  CstDestination = 'Destination';
  InfAjoutToSession = 'Versement session ';
  CstTotEnc = 'TOTAL ENCAISSE';
  CstVersCfr1 = 'VERSEMENTS AU COFFRE';
  CstVersCFr2 = 'VERSEMENTS COFFRE';
  CstVersBq1 = 'VERSEMENTS EN BANQUE';
  CstVersBq2 = 'VERSEMENTS BANQUE';
  CstFondCais2 = 'FOND DE CAISSE';
  CstEnc1 = '      Encaissements';
  CstEnc2 = ' Encaisse';
  CstSoldeEncaissement = '  Solde de l''encaissement : ';

  OKRegulGlob = 'Impossible, pour valider l''opération le solde doit être à zéro';
  // Wilfrid 23/12/2007
  MessChargeZoneDeChalandise = 'Chargement de l''analyse des zones de chalandises ...';
  //Wilfrid 07/01/2008
  TitreUniteFedas = 'Nomenclature FEDAS';
  CodeFedasInexistant = 'Le code Fedas est inexistant';
  LongueurFedasCode = 'La longueur du code FEDAS doit être de 6 caractères';

  // FTH : 07/10/2009
  msgNoMail = 'Aucune adresse email trouvée pour %s, veuillez la renseigner ';
  msgYNMailling = 'Etes vous sûr de vouloir envoyer un mailling au(x) %s client(s) sélectionné(s) ? ' + #13#10#13#10 +
    'Attention : les clients sans adresse mail ne seront pas traités';
  msgNoSelectedClient = 'Vous devez sélectionner au moins 1 client';
  msgNotEnoughSms = 'Vous n''avez pas assez de sms en reserve ! %s Restant - %s à envoyer';
  msgIsRemainSms = 'Il vous reste %s sms sur votre forfait';
  msgYNSms = 'Etes vous sûr de vouloir envoyer un Sms au(x) %s client(s) sélectionné(s) ? ' + #13#10#13#10 +
    'Attention : les clients sans numéro de portable ne seront pas traités';
  msgNoGsmFound = 'Aucun des clients sélectionnés n''a de numéro de portable renseigné';

  // FTH: 29/10/2009
  // ResCENTRAL****.*
  msgErrResCentSaveMailCFG = 'Erreur lors de l''enregistrement des données mail : ';
  msgErrResCentSaveIdenMag = 'Erreur lors de la sauvegarde des données identifiant magasin : ';
  msgErrResCentSaveOffComCFG = 'Erreur lors de l''enregistrement des données offres commerciales : ';
  msgErrResCentSavePoinTailCFG = 'Erreur lors de la sauvegarde des données pointures/tailles : ';

  msgErrResCentVerifAdrPrinc = 'Configuration %s : Veuillez saisir une adresse mail principale !!';
  msgErrResCentVerifPassWord = 'Configuration %s : Veuillez saisir un mot de passe !!';
  msgErrResCentVerifAdrMess = 'Configuration %s : Veuillez saisir une adresse de serveur de messagerie (Pop) !!';
  msgErrResCentVerifAdrMessSMTP = 'Configuration %s : Veuillez saisir une adresse de serveur de messagerie (SMTP) !!';

  CSH_TXT_AnnulLigne  = 'Annul. ligne';
  CSH_TXT_AnnulTicket = 'Abandon ticket';
  CSH_TXT_RetourCli   = 'Retour client';
  CSH_TXT_Remise      = 'Remise';

  CSH_TXT_ListeMotifSession = 'Liste motif de modification de tickets session N° %s';
  CSH_TXT_ListeMotifPeriode = 'Liste motif de modification de tickets du %s au %s';

  CSH_TXT_ExportBcdEnTxtOk = 'Le fichier %s a été généré avec succès '+#13#10+'dans le répertoire %s';
  CSH_TXT_ChargeExport = 'Chargement de l''export en cours...';

  CSH_ASK_CarteCBExpire = 'La carte bancaire est expirée !'+#13#10+'Continuez ?';

  INV_TXT_Tous = 'Tous';
  INV_TXT_ModeChargeEcart      = 'Mode de chargement des écarts';
  INV_CHX_ChargeEcartToutRayon = 'Charger les écarts avec tous les rayons';
  INV_CHX_ChargeEcartUnRayon   = 'Charger les écarts pour 1 rayon au choix';

  ModuleTranporteurGLS = 'TRANSPORTEUR GLS';
  
  INV_ASK_JustifieEcart = 'Confirmez que vous souhaitez justifier les écarts' + #13#10 + 'des %s lignes sélectionnées...';
  INV_TXT_JustifieEcart = 'Justifier les écarts';
  INV_TXT_ModifJustifie = 'Motif de Justification (Saisie obligatoire)';

  BP_ASK_ConfirmerRecupColis = 'Confirmer que vous voulez récupérer les N° de colis' + #13#10 + 'de Colissimo et/ou de So-Colissimo.';
  BP_ERR_MustConfigurerParamPoste = 'Veuillez paramétrer le transporteur Colissimo et/ou So-Colissimo.';
  BP_ERR_AucunFichierLaPosteTrouve = 'Aucun fichier d''importation n''a été trouvé';
  BP_TXT_AucunColisImporte = 'Aucun colis n''a été importé';

  STA_TXT_ChargementReporting = 'Chargement du reporting';
  RESA_TXT_AnalyseResaDispo = 'Analyse de réservation par catégorie d''article pour la période du %s au %s';
  RESA_ERR_AucuneResaPourCetteCateg = 'Aucune réservation pour cette catégorie';
  RESA_ERR_AuMoinsUnMagasin = 'Il faut cocher un magasin';
  RESA_ERR_IlNeFautQuUnMagasin = 'Il ne faut cocher qu''un seul magasin';

  COL_TXT_AvecLesNonActives = 'Avec les non actives';
  COL_TXT_SansLesNonActives = 'Sans les non actives';
  COL_TXT_AvecLesAnalysables = 'Avec les non analysables';
  COL_TXT_SansLesAnalysables = 'Sans les non analysables';
  COL_ERR_NomCollectionOblig = 'Le nom de la collection d''article est obligatoire !';
  
  RS_ERR_NomFichierInvalide = 'Un nom de fichier ne peut pas contenir les caratères suivants: \/:*?"<>|';

  TOC_TXT_Permanent = 'Permanent';
  SLIP_TXT_RetireDocument = 'Veuillez retirer le document';
  SLIP_TXT_InsertDocument = 'Veuillez insérer le document'; 
  
  PXPRECO_TXT_PxVenPrecoATraiter = 'Il y a un ou plusieurs tarifs de vente préconisés à traiter pour la période du %s au %s';
  PXPRECO_LstEtat_Propose = 'Tarifs proposés';
  PXPRECO_LstEtat_Accepte = 'Tarifs acceptés';
  PXPRECO_LstEtat_NoPropose = 'Tarifs à ne plus proposés';
  PXPRECO_LstEtat_MisAJour = 'Tarifs Mises à jour';
  PXPRECO_Grille_EtatPropose = 'Proposé';
  PXPRECO_Grille_EtatAccepte = 'Accepté';
  PXPRECO_Grille_EtatNoPropose = 'Plus proposé';
  PXPRECO_Grille_EtatPlusieurs = 'Plusieurs';
  PXPRECO_Grille_EtatMisAJour = 'Mise à jour';
  PXPRECO_ERR_FautUnTarif = 'Il faut au moins un tarif de sélectionné !';
  PXPRECO_ERR_FautUnEtat = 'Il faut au moins un état de sélectionné !';
  PXPRECO_ERR_AucunModelePropose = 'Aucun modèle n''a une proposition';
  PXPRECO_ASK_NePlusProposer = 'Ne plus proposer le tarif préconisé ?';
  PXPRECO_ASK_AppliquerDateEtPrixPreco = 'Appliquer la date et le prix préconisé ?';
  PXPRECO_ERR_DateDoitPlusGrandAujourdhui = 'La date doit être plus grande que la date du jour !';
  PXPRECO_ERR_TarifInvalide = 'Tarif invalide !';

  RS_TXT_PXPRECO_MajOK= 'Certains prix de vente ont été réactualisés, vérifiez l''étiquetage des modèles concernés.';
  RS_ERR_PXPRECO_MajNotOK= 'ATTENTION, des erreurs sont apparues lors de la mise à jour des prix de vente.';
  RS_TXT_PXPRECO_ConsultLst= 'Consulter la gestion des prix de vente préconisé à date pour obtenir la liste des articles concernés.';
  RS_TXT_PXPRECO_EnteteMaj= 'Mise à jour des tarifs de vente';
  RS_TXT_PXPRECO_EnteteAlerte= 'Changement des tarifs de vente planifiés';
  RS_TXT_PXPRECO_Alerte= 'Des changements de prix de vente sont planifiés entre le §0 et le §1.';
  RS_TXT_PXPRECO_RECEPTIMM= 'Mise à jour des prix de ventes immédiat.';
  RS_TXT_PXPRECO_RECEPTDIF= 'Mise à jour des prix de ventes différé à date.';
  RS_TXT_PXPRECO_DATEMAJ= 'Date de mise à jour';
  RS_TXT_PXPRECO_ModeMaj= 'Choisissez le mode de mise à jour.';
  RS_TXT_MISEAJOUR_ENCOURS = 'Mise à jour en cours...';
  RS_TXT_PXPRECO_ENTETEPRINT = 'Prix de vente préconisés à date';
  RS_TXT_PXPRECO_AjoutPxPreco = 'Ajouter un prix préconisé';
  RS_TXT_PXPRECO_AjoutPxDiffere = 'Ajouter un prix à une date différée';
  RS_TXT_PXPRECO_DatePreco = 'Date préconisée';
  RS_TXT_PXPRECO_PrixPreco = 'Prix préconisé';
  RS_TXT_PXPRECO_DateValide = 'Date validée';              
  RS_TXT_PXPRECO_PrixValide = 'Prix validé';
  RS_ERR_PXPRECO_NeedTarifGeneral = 'Veuillez au préalable, définir un tarif pour cette article';
  RS_ERR_PXPRECO_DateInvalide = 'La date doit être supérieure à la date du jour';
  RS_ERR_PXPRECO_PrixObligatoire = 'Prix Obligatoire';
  RS_ERR_PXPRECO_DatePrise = 'Il y a déjà un prix préconisé à cette date';
  RS_ERR_PXPRECO_TarifAuSKU = 'Des prix spécifiques sont présents à la taille/couleur' + #13#10 +
                              'Veuillez saisir un tarif préconisé et ' + #13#10 +
                              'passer par l''écran " Prix de vente préconisés à date "';
  RS_ERR_PXPRECO_NoTarifCoche = 'Aucun tarif n''est sélectionné';
  RS_ERR_PXPRECO_Rafraichir = 'Veuillez rafraîchir les données';

  RS_ERR_ImpossibleAvantDateMigration = 'Impossible de créer ou de modifier un document avant le %s.'+ #13#10+
                                        'Cette date étant la date de migration de du magasin';
  RS_ERR_DateDansUnExeComptableClot = 'Impossible de créer ou de modifier un document'+#13#10+
                                      'dont la date est dans un exercice comptable cloturé.';
  RS_ERR_DateInvalide = 'Date invalide !';

  RS_ERR_SocieteOblig = 'Société obligatoire !';
  RS_ERR_NomExeComptableOblig = 'Nom exercice comptable obligatoire !';
  RS_ERR_DateDebutObligatoire = 'Date de début obligatoire !';
  RS_ERR_DateFinObligatoire = 'Date de fin obligatoire !';
  RS_ERR_DateFinPlusPetitQueDebut = 'La date de fin doit être plus grande que celle du début !';
  RS_ASK_ClotureExeComptable = 'Vous ne pourrez plus saisir de document pendant cette période'+#13#10+
                               'si vous clôturé cet exercice comptable.'+#13#10+
                               'Etes-vous sûr de vouloir le clôturer ?';
  RS_ERR_DeleteImpossibleCarCloture = 'Impossible de supprimer ou de modifier un exercice comptable clôturé !';
  RS_ASK_SupprimerComptable = 'Etes-vous sûr de vouloir supprimer cet exercice comptable ?';

  RS_GENERIQUE_MODIF_ENREG = 'Voulez-vous enregistrer les modifications ?';

  RS_CAISSE_ERREUR_ENREG = 'Erreur lors de l''enregistrement du ticket.'#10#13'Vous devez resaisir la vente.';

IMPLEMENTATION

END.

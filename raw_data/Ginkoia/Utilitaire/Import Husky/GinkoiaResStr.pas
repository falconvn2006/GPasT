UNIT GinkoiaResStr;

INTERFACE

RESOURCESTRING
     //Bruno @@ 29/05/2002
     AnnulPasPossible=' Attention, annulation impossible,'+#13+#10+' c''est un ticket de réajustement de compte...';


    //Bruno @@ 20 14/05/2002
    Type31 = 'Réajustement compte client';
    MotifObligatoire = 'La saisie d''un motif est obligatoire...';
    ReajustCompteLib ='REAJUSTEMENT DU COMPTE CLIENT';
    UILReajustCompte = 'caisse - REAJUSTEMENT D''UN COMPTE CLIENT';

//R.V @@16
    MrkDelDist = 'Confirmez que le Fournisseur "§0"' + #13 + #10 +
        'n''est plus distributeur de cette marque...';
    MrkINSDist = 'Confirmez que le Fournisseur "§0"' + #13 + #10 +
        'est distributeur de cette marque...';

    ChargeArbreMrk = 'Chargement et mise à jour de la liste des marques...';
    SupprMarque = 'Confirmez la suppression de la marque "§0"...';
    CantSupMarque = 'La suppression de la marque "§0" est IMPOSSIBLE...' + #13 + #10 +
        'Elle est référencée par vos articles...';
    ManqueFouPrin = 'Il est indispensable de désigner le fournisseur principal de cette marque!...';
    CancelMarque = 'Abandonner TOUTES les modifications effectuées sur cette Marque?...';

    // 6 Lignes déplacées
    SupLienMrkCas1 = 'La marque distribuée n''aura plus de fournisseur...';
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
    FournMrkSup = 'Marque(s) supprimée(s)';
    NapLib = 'Net à Payer';
    NapAvoirLib = 'Avoir Net';

//P.R. @@16
    InfVersementCoffre = 'Versement au coffre ';
{ @@15 Modifié Hervé le 12/04/2002}
    CancelFourn = 'Abandonner TOUTES les modifications effectuées pour ce fournisseur?...';
    NoMoreMagDetFrn = 'Vous avez déjà défini les conditions particulières pour tous les magasins...';
    MessPostFrnCt = 'Enregistrement de la fiche du contact fournisseur...';
    MessPostFrnDet = 'Enregistrement de la fiche de conditions particulières...';
    MessDelFrnCt = 'Conrmimez la suppresion de la fiche contact fournisseur à l''écran...';
    MessDelFrnDet = 'Conrmimez la suppresion de la fiche conditions particulières du fournisseur à l''écran...';
    MessCancelFrnCt = 'Abandonner les modifications en cours dans la fiche du contact ?...';
    MessCancelFrnDet = 'Abandonner les modifications en cours dans les conditions particulières ?...';

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
        'Il existe déjà une marque référencée portant nom !...';
    InputLabNeoMrk = 'Nom de la nouvelle marque...';
    DefCapInput = 'Boite de saisie...';
    DefLabInput = 'Votre saisie...';

    //22/03/2002 Bruno
    EtikCltTotal = 'Confirmez vous, l''impression des étiquettes correspondant' + #13 + #10 + 'à la liste des clients en cours?';
    EtikCount = 'Etiquette';
    EtikCountS = 'Etiquettes';

    //07/03/2002 Bruno
    Type00 = 'Ligne vide (Pas de fonction définie)';
    Type30 = 'Impression d''une étiquette client';

{ Modifié Hervé Le : 26/03/2002  -   Ligne(s) }
    LibRecep = 'Bon de Réception';
    MessCreaLinkArt = 'Création de l''article et transfert' + #13 + #10 +
        'dans le "§0"';
///Pascal 25/03/2002
    CstAffInventaire = 'Affichage de l''inventaire en cours, patience...';

{ Modifié Hervé Le : 19/03/2002  -   Ligne(s) }
    CreerMarqueDef = 'Faut-il créer une marque du même nom que celui de ce fournisseur ?...' + #13 + #10 +
        '( Cette marque se nommerait donc "§0" )';

    SupMarqueDist = 'Confirmez que la marque "§0" ne doit plus être distribuée par ce fournisseur...';
    GrosYaRal = 'Il reste des articles en commande chez ce fournisseur' + #13 + #10 +
        'pour une marque qui n''est pas distribuée par lui !...' + #13 + #10 +
        'Tant qu''il ne sera pas déclaré comme distributeur de cette marque,' + #13 + #10 +
        'il devra impérativement rester grossiste...';

    AjoutMrkSel = 'Confirmez l''ajout des marques sélectionnées comme étant distribuées par ce fournisseur...';
    HintDbgMrkFrn = '[INS] Ajouter des marques distribuées [Suppr] Si la marque pointée n''est plus distribuée';
    HintDbgMrkFrnNoEdit = '[DoubleClic] Fiche de la marque pointée';

    HintRechFrn = '[F6] Liste des fournisseurs';

    SupFournAvort = ' La suppression ne peut être effectuée...';

    HintNeoFoudef = 'Sélectionner le Nouveau fournisseur par défaut de la marque "§0" ?...';
    PbAdresseFourn = 'Problème avec l''adresse de ce fournisseur ... Mise en édition impossible !...';
    NomFournExist = 'Deux fournisseurs ne peuvent être crées avec le même nom !...';
    PbCreaFourn = 'Problème en validation de ce nouveau fournisseur ...' + #13 + #10 +
        'La création doit être abandonnée...';
    TxtEnLS = 'Texte en lecture seule';
    FourNoDel = 'Impossible de supprimer ce fournisseur...'#13 + #10 +
        'car vous avez déjà travaillé avec lui !)' + #13 + #10 +
        '(articles référencés, articles en commande... etc.)';

{ Modifié Hervé Le : 17/03/2002  -   Ligne(s) }

    LabProForma = 'Facture Pro Forma';
    MajTarModeles = 'Confirmez la réactualisation des prix des modèles sélectionnés... ';

    ModDevNoNeedMaj = 'Les prix sont à jour... ce modèle ne nécessite aucune réactualisation !...';
    ModDevNoNeedMajSel = 'Les prix sont à jour... aucune réactualisation n''a été nécessaire !...';
    ModDevMaj = 'Mise à jour des prix du modèle terminée ... ';
    ModDevMajSel = 'Mise à jour des prix des modèles sélectinnés terminée ... ';

{ Modifié Hervé Le : 11/03/2002  -   Ligne(s) }
    MessRecepRemRal = 'Cet article a été saisi en commande avec une remise de "§0"' + #13 + #10 +
        'différente de la remise par défaut du bon de réception (§1)' + #13 + #10 + #13 + #10 +
        'Faut-il forcer la remise par défaut du bon de réception ?';

    NewFilterMess = 'Mise en place du filtre avancé ...';
    StopFilterMess = 'Suppression du filtre avancé... réaffichage des données...';
    NbtAdvFilterHint = 'Expert filtre avancé...';
    NegPxUHT = 'Px Unit HT';
    NegPxUTTc = 'Px Unit TTC';

    ConsoQteNega = 'Le stock est... ou va devenir négatif !... Continuer ?';

    DateDocMess = 'Votre document est à une date ... "dans le futur" !...' + #13 + #10 +
        'Est-ce bien normal et faut-il l''accepter ?... ';
    TitleExpertCat = ' Expert de gestion des catégories de familles';
    TitleExpertCat1 = ' Expert de gestion des catégories de Rayons';

    CNFCategorie0 = 'Retirer la famille "§0" de la liste des Catégories ?...' + #13 + #10 +
        '(Cette Famille n''aura plus de Catégorie associée...)';
    CNFAffectCategorie = 'Placer la Famille "§0"' + #13 + #10 +
        'dans la Catégorie "§1" ?...';

    CNFCangeCatFam = 'Déplacer la Famille "§0"' + #13 + #10 +
        'de la Catégorie "§1"' + #13 + #10 +
        'vers la Catégorie "§2"';

    CNFCangeSecRay = 'Déplacer le Rayon "§0"' + #13 + #10 +
        'du Secteur "§1"' + #13 + #10 +
        'vers le Secteur "§2"';
    DbgRExpertSectHint = '[Ctrl + Flêche Droite] Affecte le rayon pointé au Secteur en cours [Suppr] Retirer l''élément pointé';
    DbgSRExpertSectHint = '[Ctrl + Flêche Gauche] Retire le rayon pointé du Secteur  [Drag && Drop] Pour réorganiser les Secteurs';

    DbgRExpertCatHint = '[Ctrl + Flêche Droite] Affecte la famille pointée à la Catégorie en cours [Suppr] Retirer l''élément pointé';
    DbgSRExpertCatHint = '[Ctrl + Flêche Gauche] Retire la famille pointée de la Catégorie  [Drag && Drop] Pour réorganiser les Catégories';
    DbgRExpertCatHint1 = '[Ctrl + Flêche Droite] Affecte le rayon pointé à la Catégorie en cours [Suppr] Retirer l''élément pointé';
    DbgSRExpertCatHint1 = '[Ctrl + Flêche Gauche] Retire le rayon pointé de la Catégorie  [Drag && Drop] Pour réorganiser les Catégories';

    ExpertSectTitre = 'Liste des secteurs avec leurs rayons associés';
    ExpertCatFamTitre = 'Liste des catégories';

    ExpertCarFamTitre = 'Liste des catégorie avec leurs familles associées';
    ChargeImpMess = 'Chargement de l''impression en cours...';
    LoadArtRay = 'Chargement de la liste des articles du rayon ...';
    NkArtRefCap = 'Articles référencés';
    NkCatFournCap = 'Articles des catalogues fournisseurs';

    SupRelGtsNK = 'Confirmez la suppression de l''association de la grille statistique' + #13 + #10 +
        '"§0"' + #13 + #10 + 'à cette sous-famille...';
    NoSupGTSBaseNK = 'On ne peux pas supprimer l''association avec la grille statistique de base...';
    NKOrdre = ' [Ctrl + H ou B] Rémonter / Descendre l''élément dans sa liste';
    NkRayVersHaut = '[Ctrl+H] Déplacer le rayon d''un cran vers le haut dans la liste des rayons';
    NkRayVersBas = '[Ctrl+B] Déplacer le rayon d''un cran vers le bas dans la liste des rayons';
    NkFamVersHaut = '[Ctrl+H] Déplacer la famille d''un cran vers le haut dans la liste des familles';
    NkFamVersBas = '[Ctrl+B] Déplacer la famille d''un cran vers le bas dans la liste des familles';
    NkSFVersHaut = '[Ctrl+H] Déplacer la sous-famille d''un cran vers le haut dans la liste des sous-familles';
    NkSFVersBas = '[Ctrl+B] Déplacer la sous-famille d''un cran vers le bas dans la liste des sous-familles';

    YaKunItem = 'On ne peut pas supprimer directement le dernier "item" d''une branche de' + #13 + #10 +
        'la nomenclature (chaque branche doit avoir au moins 1 "enfant") ...' + #13 + #10 +
        'Il faut supprimer son "parent"...';

    NkDefFam = 'NOUVELLE FAMILLE';
    NkDefSF = 'NOUVELLE SOUS-FAMILLE';

    DelNkRay = 'Confirmez la suppression du rayon "§0"';
    DelNkFam = 'Confirmez la suppression de la famille "§0"';
    DelNkSF = 'Confirmez la suppression de la sous-famille "§0"';

    DeleteNKRV = 'Problème lors de la suppression... le traitement est annulé !';

    YaArtDedans = 'Suppression impossible car il y a des articles référencés...' + #13 + #10 +
        '(ou des articles des catalogues fournisseurs)';
    NbtParamRech = 'Définir une collection pour l''outil de rechereche...';
    ParamRechTout = 'Toutes collections';
    CdeRechVideCollec = 'Aucun article trouvé dans la collection active... ' + #13 + #10 +
        '(Cet article existe peut-être mais n''est pas accessible dans votre contexte de travail actuel )';
    NkDetail = 'Détail de l''élément sélectionné';
    HintNk = 'Nomenclature...  [ECHAP] Masquer la nomenclatuer';
    LabArtVide = '( Modifiable, ne contient aucun article )';
    LabArtNoVide = '( Non modifiable, contient des articles )';

    NkRefreshMess = 'Fermeture de l''outil de gestion de la nomenclature';
    NkGesCharge = 'Chargement de l''outil de gestion de la nomenclature...';
    NkChxArt = 'Liste des articles selon la nomenclature...';
    NKCapGes = ' Gestion de la nomenclature';
    NkRayon = 'Rayon';
    NkFamille = 'Famille';
    NkSSF = 'Sous-Famille';
    NkSecteur = 'Secteur';
    NkCategorie = 'Catégorie';

    NoNkDispo = 'Chaînage imposssible' + #13 + #10 + 'tant que vous n''avez pas terminé le travail en cours...';

    NoNkSelected = 'Aucun élément sélectionné !...';
    NeedRayon = 'Il faut sélectionner un rayon !... ';
    NeedFamille = 'Il faut sélectionner une famille !... ';
    NeedSSF = 'Il faut sélectionner une sous-famille !... ';

    NkNoArt = 'Aucun article sélectionné!...';
    NkCapFourn = ' Nomenclature : [Double clic] ou [F4] Exporte l''article pointé dans la liste...';
    NkCapListart = ' Nomenclature : [Double clic] ou [F4] Sur un article de la liste ouvre sa fiche...';
    NKCapNormal = ' Nomenclature Ginkoia';
    FreeNk = 'Décharger la nomenclature de la mémoire ?...';

{ Modifié Sandrine Le : 15/02/2002  -   Ligne(s) }
    GestDroit = 'Vous n''avez pas les droits suffisant pour accéder' + #13 + #10 +
        'à cette partie du programme' + #13 + #10 +
        'Contactez votre responsable !';

{ Modifié Sandrine Le : 11/02/2002  -   Ligne(s) }
    CapCmzMenuDo = 'Activer la personnalisation des barres outils';
    CapCmzMenuOff = 'DésActiver la personnalisation des barres outils';

    HintNextRec = 'Fiche suivante...';
    HintPriorRec = 'Fiche précédente...';

    FinFiches = 'Fin du fichier ...';
    debFiches = 'Début du fichier ...';
    NoGoodPeriode = 'La date de fin doit être postérieure à celle de début !...';
    FiltreReinit = 'Confirmer la suppression complête de toutes les conditions sélectionnées...';
    HintBtnDocSel = 'Ouvre le document pointé dans son module de gestion...';
{ Modifié BRUNO Le : 04/02/2002  -   Ligne(s) }
    EtiquetteEssai = 'Souhaitez vous imprimer une étiquette d''essai?';
    SautEtiquette = 'Impossible, le nombre d''étiquette(s) à sauter doit être compris entre 0 et 20...';
    TitreEtikDiff = 'Impression des étiquettes différées';
    PasSelect = 'Impression impossible, vous n''avez pas sélectionné les lignes...' + #13 + #10 +
        'Le bouton en bas à gauche vous permet de tous sélectionner.';

{ Modifié RV Le : 04/02/2002  -   Ligne(s) }
    messClotEtArchDoc = 'Le document à l''écran n''est pas "clôturé"...' + #13 + #10 +
        'Faut-il le clôturer et l''archiver ?...' + #13 + #10 +
        '(Attention : l''archivage est irréversible!...)';

    MessArchDoc = 'Confirmer l''archivage du document affiché à l''écran' + #13 + #10 +
        '(Attention : l''archivage est irréversible!...)';

    TitClotDoc = ' Clôture du document affiché...';
    TitArchDoc = ' Archivage du document affiché...';
    MessClotDoc = 'Confirmer la clôture du document affiché à l''écran' + #13 + #10 +
        '(Attention : la clôture est irréversible!...)';

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
        'Impossible de procéder au transfert!...';
    BLLib = 'Bon de livraison';
    DevLib = 'Devis';
    DoDevTransDoc = 'Confirmez le transfert en "§0" du Devis affiché à l''écran...   ';
    DoCopyModele = 'Confirmez la copie en "§0" du modèle affiché à l''écran...   ';
    DoCopyModMod = 'Confirmez la copie en "§0" du document affiché à l''écran...   ';

    OkDevTrans = 'Le devis affiché à l''écran a été transféré en "§0" N° §1   ';
    DoTransNoModele = '(aprés transfert le devis d''origine ne sera plus modifiable)';

    HintGenEdit = '[DoubleClic ou F4] Si champ avec "bouton", action associée au bouton';
    VendeurDef = 'Vendeur par défaut des nouvelles lignes';
    HintEdBtnCanClear = '[DoubleClic ou F4] Liste associée [SUPPR] Vider le champ';
    HIntMemosLS = '[ENTREE] Champ suivant... [Double Clic ou F4] Ouvrir l''afficheur du mémo';
    CannotChangeTipModele = 'On ne peut pas changer le type d''un modèle...';
    DevTitreListe = 'Liste des devis';
    DevTitreMod = 'Liste des Modèles';
    NoSupprExportedDev = 'Suppression impossible !' + #13 + #10 +
        'Ce devis contient des lignes transférées dans un autre document!...';
    NoSupprExportedLine = 'Suppression impossible !' + #13 + #10 +
        'Ligne de devis transférée dans un autre document...';
    ImpIntDev = 'Devis N° §0 - Client N° §1  §2';

{ Modifié RV Le : 22/01/2002  -   Ligne(s) }
    MrkDejaRef = 'Marque déjà référencée chez ce fournisseur...';
    MessOuvreRal = 'Mise en place du contrôle dans le "Reste à Livrer"...';
    MessChargeArtRef = 'Chargement de la liste des articles référencés....';
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
    MessVerifInv = 'Vérification en cours ...';
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
    MajTarFichart = 'Le prix d''achat est différent de celui de la fiche article...    ' + #13 + #10 +
        '   Faut-il mettre à jour cette dernière ?';

{ Modifié RV Le : 07/01/2002  -   Ligne(s) }
    HintDbgDef = '[Maj+F11] Colonnes à leur largeur minimum';
  // Pascal 07/01/2001
    CstInvClotureNonOK = '    Erreur durant La clôture de l''inventaire   ' + #13 + #10 + #13 + #10 +
        '    Appeler ALGOL pour résoudre votre problème ';
{ Modifié RV Le : 04/01/2002  -   Ligne(s) }
    NoGoodDevise = 'IMPOSSIBLE : la devise affichée n''est la devise de travail de vos données...   ';

    LabDateStk = 'Editer l''état du stock au';

    StkDetailLib = 'Liste détaillée des articles au : §0';
{ Modifié Pascal 31/12/2001 }
    CstAnalSynth = 'Analyse synthétique du §0 au §1  -  ';

{ Modifié RV Le : 04/01/2002  -   Ligne(s) }
    HintBasculeGrpFoot = 'Basculer les cumuls intermédiaires entre "pied" et "entête" de groupe';
{ Modifié RV Le : 31/12/2001  -   Ligne(s) }
    AfftarBase = 'Confirmez l''affichage du tarif de vente général...     ' + #13 + #10 +
        '  ( Ce tarif concernant tous vos articles référencés, son affichage peut être assez long )     ';
    SupTarVente = 'Retirer l''article sélectionné de ce tarif de vente ?...    ';
    HintSumOnGroup = 'Afficher / Masquer les cumuls sur les lignes d''entête de groupe';
    HintAutoWidth = 'Ajustement automatique des colonnes "au mieux"';

{ Modifié RV Le : 26/12/2001  -   Ligne(s) }
    NoTouchTarBase = 'On ne peut ni modifier ni supprimer le tarif général !...    ';
    AffecteTarVente = 'Confirmez que le tarif              ' + #13 + #10 + #13 + #10 +
        '   §0' + #13 + #10 + #13 + #10 + '   devient le tarif du magasin                        ' + #13 + #10 +
        #13 + #10 + '   §1' + #13 + #10;
    DeleteTarVente = 'Confirmez la suppression du tarif de vente "§0"    ' + #13 + #10 +
        '( ATTENTION : cette opération supprime le tarif de tous les articles concernés )   ';
    DeleteTarVente2 = 'La suppression d''un tarif de vente est irreversible...    ' + #13 + #10 +
        'Faut-il continuer ?...   ';
    SupTarVenteOk = 'Suppression du tarif de vente terminée...    ';
    TarVenteLinked = 'Impossible de supprimer ce tarif de vente car     ' + #13 + #10 +
        'il est appliqué par un magasin!... ';

{ Modifié RV Le : 24/12/2001  -   Ligne(s) }
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

    CstPassageEuro = '  ATTENTION, vous devez passer définitivement à l''Euro.'#13#10 +
        'Pour cela vos caisses doivent avoir leur sessions clôturées.'#13#10 +
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
    NoImpDocVide = 'Document vide !... aucune ligne à imprimer.    ';
    TransMultiAvorted = 'Problème lors du transfert d''un document, le transfert est annulé...    ';

{ Modifié RV Le : 03/12/2001  -   Ligne(s) }
    FactNoTip = 'Le type du document est obligatoire ...   ';
    NoCatalog = 'Aucun catalogue fournisseur disponible sur votre machine ...  ';
    NoSupportedUnidim = 'Fonctionnalité "Taille/Couleur" sans objet dans un univers qui n''en dispose pas!...     ';
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
    DeviseEuro = '€';
    NoNegEuro = 'Désolé, mais on ne peut imprimer une facture que dans la monnaie de référence...    ';
    CoefNull = 'Attention : Prix de vente de base à "0"...     ' + #13 + #10 +
        '   Faut-il l''accepter ?...     '#13 + #10;

{ Modifié RV Le : 25/11/2001  -   Ligne(s) }
    DocImp = 'Imprimer le §0 documents sélectionnés ?...     ';
    NegFacCroPro = 'N° à validation';
    NoDocArticle = 'Aucun article en cours (affiché) dans la fiche article...   ';
    DocCloture = 'Confirmer la clôture de(s) §0 document(s) sélectionné(s)...    ';
    NoDocCloture = 'Aucun document à clôturer...      ';
    DocLineINEdit = 'Impossible de changer de page tant que la ligne en cours n''a pas été validée...    ';
{ Modifié Sandrine Le : 21/11/2001  -  2 Ligne(s) }
    CsBL = 'Bons de livraison';
    CsFacture = 'Factures';

{ Modifié RV Le : 20/11/2001  -   Ligne(s) }
    RefTotoFait = 'Mise à jour des cumuls du document effectué...   ';
    AfterToDay = 'Impossible de saisir une date postérieure à aujourd''hui!...    ';
    MaxToDay = 'Impossible de saisir une date antérieure à aujourd''hui!...    ';

{ Modifié RV Le : 15/11/2001  -   Ligne(s) }
    CdeRefreshToto = 'ATTENTION : le recalcul n''est à exécuter que si vous avez    ' + #13 + #10 +
        '   une anomalie dans les cumuls affichés dans l''entête du document !...   ' + #13 + #10 +
        '   Ne confirmer que si vous êtes dans ce cas !';
    ArchivedDoc = 'Document archivé !... Il ne peut plus être ni modifié ni supprimé.    ';
    CloturedDoc = 'Document clôturé !... Il ne peut plus être ni modifié ni supprimé.    ';
    NotModifDoc = 'Document non modifiable... ( ni "supprimable" ).    ';
    NoSupprImportedLine = 'Impossible de supprimer une ligne importée depuis un Bon de Livraison !...   ';
    NoSupprImportedFac = 'Impossible de supprimer cette facture !...     ' + #13 + #10 +
        '   ( Elle contient des lignes importées depuis un Bon de Livraison )    ';

    FacLib = 'Facture';
    AvoirLib = 'Avoir';
    FacPbCptClt = 'Problème de mise à jour du compte client!...    ';
    ImpIntFac = 'Facture N° §0 - Client N° §1  §2';
    ImpIntBL = 'BL N° §0 - Client N° §1  §2';
    HintDbgDoc = '[F2] Editer  [SUPPR] Supprimer  [Double Clic] Editer ... la ligne en cours du document affiché';
    NoDocFound = 'Le document "§0" n''a pas été trouvé dans la liste des documents...     ';
    BLTransNoLine = 'Aucune ligne à tyransférer !...';
    NegLabTitle = 'Entête de groupe';

    // Pascal Le 6/11/2001
    CstInvAfficher = 'Appuyer sur le bouton afficher les articles pour pouvoir charger le PHL !';
    CstInvSUPNon = 'La suppression d''un inventaire n''est plus possible après sa clôture.';
    CstStckCourDate = 'Etat de stock au §0';

{ Modifié RV Le : 05/11/2001 }
    HIntMemos = '[CTRL+ENTREE] Pour valider le champ ... [Double Clic ou F4] Ouvrir l''éditeur associé';
    BLNOTrans = 'Aucun transfert à effectuer';
    BLTransEnFact = 'Transféré en facture';
    BlConfTrans = 'Confirmez le transfert en facture des bons de livraison sélectionnés...    ';
    BLPBLORSTRAns = 'Problème lors du transfert de ce bon de livraison en facture...';
    BLTransNoPoss = 'Transfert impossible ...';
    NegCOmTransBL = 'Transfert du Bon de livraison N° ';
    DoBLTransFact = 'Confirmez le transfert du bon de livraison affiché en facture...   ' + #13 + #10 +
        '   (aprés transfert le bon de livraison ne sera plus modifiable)';
    BLKourOkTransFact = 'Le bon de livraison a été transféré dans la facture N° §0    ';
    BLKourNoTransFact = 'Problème lors du transfert de ce bon de livraison en facture...    ';
    BLTitreListe = 'Liste des bons de livraison';
    FacTitreListe = 'Liste des Factures';
    HintEditGen = '[Ins] Créer [F2] Editer [Suppr] Supprimer';
    HintEditDBG = '[Ins] Créer [F2] Editer [Suppr] Supprimer la ligne sélectionnée';

    ChpBtnComent = '[F4 ou DoubleClic] Ouvre le bloc mémo de saisie associé';
    NegLabComent = 'Texte libre';
    NegLabArticle = 'Désignation';
    NoChangeBecauseModif = 'La modification de ce champ n''est possible      ' + #13 + #10 +
        '   que lorsque le document est en création...  ';
    NoChangeBecauseLines = 'La modification de ce champ n''est plus possible      ' + #13 + #10 +
        '   lorsque des lignes existent dans le document...  ';
    FactNoClt = 'La saisie d''un client est obligatoire !      ';
    FactNoMag = 'La saisie du magasin est obligatoire !      ';
    ConfDeleteDoc = 'Confirmer la SUPPRESSION du document en cours ...    ';

    // Pascal Le 9/11/2001
    CstStockTousMag = 'Stock détaillé tous magasin';
    // Pascal le 7/11/2001
    CstCaVendeurDateLib = 'CA par vendeur du §0 au §1  -  ';
    CstCaVendHeureDateLib = 'CA horaire par vendeur du §0 au §1  -  ';
    CstCaJourHeureDateLib = 'CA horaire par jour du §0 au §1  -  ';

    // Pascal le 6/11/2001
    CstInvRecompter = 'Recompter les articles de la liste ?';
    CstInvSupprimer = 'Ne pas recompter les articles de la liste et les sortir de l''inventaire ?';

    // Pascal le 6/11/2001
    CstInvAjoutArticle = 'Ajouter la selection à l''inventaire ?';

    // Modifié Pascal le 02/11/2001
    CstFamille = 'Famille';
    CstSSFamille = 'Sous-Famille';
    CstCategorie = 'Catégorie';
    CstGenre = 'Genre';

{ Modifié RV Le :  02/11/2001 }
    ConsodivList = 'Liste des consommations diverses en saisie...    ';
    EdEcartInv = 'Ecarts d''inventaire du §0 au §1  -  ';

    // Modifié Pascal le 31/10/2001
    CstInvClotureOK = 'La clôture de l''inventaire c''est bien passée';
    CstInvClotEnCours = 'Clôture de l''inventaire en cours';
    CstInvDemEnCours = 'Création de la démarque en cours';
    CstInvProblemePHL = 'Problème de récéption sur le PHL';
    CstInvChargePHL = 'Chargement du PHL terminé';
    CstInvTousCompte = 'Aucun article n''a était mouvementé pendant l''inventaire'#13#10'                Rien n''est à recompté';
    CstInvARecompte =
        '   Les articles suivant ont était mouvementé pendant l''inventaire'#13#10'Vous devez les recompter ou ils ne seront pas considéré dans la clôture';
    CstInvOuvOk = 'L''ouverture d''inventaire c''est bien passée.'#13#10'Vous pouvez maintenant commencer à travailler';
    CstInvTitreImpNC = ' Edition des non comptés inventaire num §0, §1';
    CstInvTitreImpEcart = ' Edition des écarts inventaire num §0, §1';
    CstInvTitreImpValo = ' Edition valorisée de l''inventaire num §0, §1';
    CstHistoTaille = 'Toutes tailles';
    CstHistoCoul = 'Toutes couleurs';

{ Modifié RV Le : 30/10/2001  -   Ligne(s) }
    NoDataVide = 'Impossible de valider sans une donnée significative!...    ';

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
    CstInvRechVide = 'Aucun article trouvé ... ( Vérifier s''il est en inventaire )   ';
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

    TitleHistoVente = 'Historiques de vente de l''article - Chrono : ';
    TitleHistoMvt = 'Historiques des mouvements de l''article - Chrono : ';
    TitleHistoRetro = 'Historiques "Rétros et Démarques" de l''article - Chrono : ';

// Hervé  6/10/2001
    HintcdvMM = 'Liste des consommations diverses depuis le :';
    HintBtnCopy = '[CTRL+P] ou [Clic Bouton "..."] Recopie la valeur de la fiche précédente';
    ErrFrnDelContact = 'Confirmez la suppression du contact sélectionné...   ';
    ErrNomContact = 'Un contact doit obligatoirement avoir un nom !... ';
    FrnCapDetail = 'Renseignements complémentaires';
    FrnNoDelSeul = 'Impossible, un fournisseur doit obligatoirement avoir une marque...   ';
    FrnNoDelCde = 'Impossible de supprimer,     ' + #13 + #10 + '   il y a des commandes de cette marque chez ce fournisseur...      ';
    FrnNoDelRecep = 'Impossible de supprimer,     ' + #13 + #10 + '   il y a des réceptions de cette marque chez ce fournisseur...      ';
    FrnNoDelPrin = 'Impossible... car cette marque n''aurait plus de fournisseur principal!   ' + #13 + #10 +
        '   (Il suffit de lui associer un autre fournisseur principal)     ';

    errMajPvteRecep = 'Erreur lors de la mise à jour du prix de vente... ' + #13 + #10 +
        ' Il faudra aller le mettre à jour dans la fiche article.   ' + #13 + #10 +
        ' SVP : prevenez Algol que vous avez eu ce message... Merci ';

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
        ' Appelez ALGOL en urgence !';
    ErrPush = ' Erreur lors de ENVOI du module : §0 ';
    ErrPull = ' Erreur lors de la RECEPTION du module : §0 ';
    Donnee = ' - Données "';
    DonneeEnvFin = '" envoyées !';
    DonneeRecFin = '" reçues !';
    Fin1 = 'Envoi terminé avec succés';
    Fin = 'Récéption terminé avec succés';
    ErrFin1 = 'Echec lors de l' + #39 + 'envoi de vos données';
    ErrFin = 'Echec lors de la récéption de vos données';

//
    IniCreaArtSport = 'Article dimensionné (Tailles, couleurs)';
    IniCreaArtBrun = 'Article Normal';

    RecepConfRef = 'Confirmer le référencement de l''article catalogue référence "§0" ...    ';
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
    CapPrincipal = 'Principal';
    CapQuitter = '&Quitter';
    CapCancel = '&Abandonner';
    HintDlgQuit = '[Echap] Quitter';
    HintDlgOkCancel = '[F12]  OK    [Echap]  Abandonner ';
    HintMemo = '[Maj+Flêche Haut] Champ précédent  [Maj+Flêche Bas] Champ Suivant';

    HintExpandNode = 'Ouvrir toutes les lignes du groupe de lignes sélectionné';
    HintCollapseNode = 'Fermer le groupe de lignes sélectionné';
    HintFullExpand = 'Ouvrir la liste à son niveau de détail maximum';
    HintFullCollapse = 'Fermer la liste (n''afficher que son 1er niveau de détail)';

    HintBtnConvert = 'Changer la monnaie d''affichage ...';
    HintBtnPreview = 'Afficher / Cacher la ligne de donnée supplémentaire';
    HintBtnPrintDbg = 'Imprimer la liste affichée';
    HintBtnSelMag = 'Liste de sélection des magasins... ';
    HintPeriodeEtude = 'Définir une période d''étude... ';
    HintBtnCmzDbg = 'Outil de configuration des lignes';
    HintBtnSoveCmz = 'Sauver / Charger un modèle de configuration des lignes';
    HintBtnClearFilterDbg = '[F11] Réinitialiser le filtre actif dans les lignes...';
    HintBtnShowGroupPanel = 'Afficher / Cacher la zone d''affichage des groupes';
    HintBtnShowFooter = 'Afficher / Cacher les cumuls de fin des lignes';
    HintBtnShowFooterRow = 'Afficher / Cacher les cumuls intermédiaires des lignes';
    HintBtnExcelDbg = 'Exporter les lignes dans Excel (Excel est automatiquement ouvert)';
    HintBtnPopup = 'Menu des fonctions annexes  [Clic droit]';
    HintBtnRefresh = 'Rafraîchir les données affichées (Relecture des données sur le serveur)';
    HintBtnCancel = '[Echap]  Abandonner les modifications effectuées';
    HintBtnPost = '[F12] Enregistrer les modifications effectuées';
    HintBtnEdit = '[F2] Modifier le document affiché';
    HintBtnDelete = '[Suppr] Supprimer le document affiché';
    HintBtnInsert = '[Ins] Ouvrir un nouveau document';
    HintBtnPrintDoc = 'Imprimer le document affiché à l''écran';
    HintBtnQuitDlg = 'Fermer la liste [Echap]';
    HintGenerikFrm = '[F12] Enregistrer   [Echap] Abandonner   [F2] Modifier   [SUPPR] Supprimer';
    HintGenerikFrmNoSuppr = '[F12] Enregistrer   [Echap] Abandonner   [F2] Modifier';

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

    CtrlJetons = 'Impossible d''ouvrir Ginkoia ...    ' + #13 + #10 +
        '   Nombre de postes autorisés dépassé ...   ';
    ErrPoste = 'Impossible d''ouvrir GINKOIA sans un nom de poste défini';
    ErrServeurPoste = 'Le serveur §0 ' + #13 + #10 + 'n' + #39 + 'a pas de poste défini !';
    NomTVT = 'Tarif général';
    NietConvert = 'On ne peut pas changer de devise lorsqu''une tâche est en édition ...   ';
    NietModifTTrav = 'On ne peut pas supprimer une taille travaillées ou une couleur     ' + #13 + #10 +
        '   lorsque une commande, une réception ou un transfert sont en édition ...    ';
    NietDeleteArt = 'On ne peut pas supprimer un article     ' + #13 + #10 +
        '   lorsque une commande, une réception ou un transfert sont en édition ...    ';
    TransNoStk = 'IMPOSSIBLE : cet article n''a jamais été référencé en stock ...   ';

// Messages du module de dimension

    GtfMajData = 'Problème de mise à jour des données...  ';
    MessGTFREF = 'Impossible de supprimer une grille de taille de référence...';
    MessGTFSup = 'Confirmez-vous la suppression de cette grille de taille?';
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
    UpRayon = '[Ctrl+fléche Haut] Déplacer le Rayon vers le haut';
    DownRayon = '[Ctrl+fléche Bas] Déplacer le Rayon vers le bas';
    UpFamille = '[Ctrl+fléche Haut] Déplacer la Famille vers le haut';
    DownFamille = '[Ctrl+fléche Bas] Déplacer la Famille vers le bas';
    UpSSFamille = '[Ctrl+fléche Haut] Déplacer la Sous-Famille vers le haut';
    DownSSFamille = '[Ctrl+fléche Bas] Déplacer la Sous-Famille vers le bas';

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
    ErrNomSSFamille = ' Ce nom de Sous-Famille n' + #39 + 'est pas valable!';

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
    ErrManqueTCT = ' Le type comptable d' + #39 + 'achat et de vente n' + #39 +
        'est pas défini!';
    ErrManqueSSF = 'La Sous-Famille n' + #39 + 'est pas définie!';
    ErrManqueGTS = ' La Grille de Taille Statistique n' + #39 + 'est pas définie!';

    ErrSupprRayon = ' Au moins un Article référence une sous-famille de ce Rayon !';
    ErrSupprFamille =
        ' Au moins un Article référence une sous-famille de cette Famille!';
    ErrSupprSSFamille = ' Au moins un Article référence cette sous-famille!';

    ErrCle = ' Cette sélection est vide!';
    ErrNiveauCle = ' Aucun niveau cette sélection!';

//    WARSuppr = ' Etes-vous sûr de vouloir supprimer §0 de votre Nomenclature ?';
    WARSupprSelection = ' Etes-vous sûr de vouloir supprimer la sélection "§0" ?';
    ErrDetruireSelection = ' Votre sélection référence des données qui ne sont plus valides,' + #10 + #13 +
        '  Elle est donc supprimée !';
    CNFModifSelection = ' Etes-vous sûr de vouloir modifier la sélection "§0" ?';
    INFRayonInvisible =
        ' Les Rayons ne sont pas visible, modifiez leur visibilité pour pouvoir travailler !';

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

    CNFSuperRayon0 = 'Retirer le Rayon "§0" de la liste des secteurs?...' + #13 + #10 +
        '(Ce Rayon n''aura plus de Secteur associé...)';
    CNFAffectSuperRayon = 'Placer le Rayon "§0"' + #13 + #10 +
        'dans le Secteur "§1" ?...';

// Selection_Dial

    NkItemRadioRay = 'Sélectionner tous les Rayons contenant :';
    NkItemRadioFam = 'Sélectionner toutes les Familles contenant :';
    NkItemRadioSf = 'Sélectionner toutes les Sous-Familles contenant :';
    NkCeRayon = 'ce Rayon';
    NkCetteFam = 'cette Famille';
    NkCetteSf = 'cette Sous-Famille';

    CNFAbandonSelection = '  Si vous abandonez maintenant votre sélection sera perdue.' +
        #13 + #10 +
        '  Etes-vous sûr de vouloir abandonner ?';
    CNFSupprFam = ' Attention des Familles de §0 sont déjà dans la sélection !' + #13 + #10
        +
        '  Pour rajouter §0, il faut les enlèver.';
    CNFSupprSSFam = ' Attention des Sous-Familles de §0 sont déjà dans la sélection !' +
        #13 + #10 +
        '  Pour rajouter §0, il faut les enlèver.';
    CNFSupprFam_SSFam = ' Attention des Familles et des Sous-Familles de §0 sont déjà dans la sélection !'
        + #13 + #10 +
        '  Pour rajouter §0, il faut les enlèver.';
    ErrRayon = ' Le Rayon de §0 est déjà sélectionné !';
    ErrFamille = ' La Famille de cette Sous-Famille est déjà sélectionnée !';
    WarSupprItem = ' Etes-vous sûr de vouloir enlèver "§0" de la sélection !';
    WarViderListe = ' Etes-vous sûr de vouloir supprimer tous les éléments de la sélection!';

// Bon de commande

    CdeSsGenre = 'Sans Genre';
    CdeListeVide = 'Liste de recherche vide...    ';
    CdeTitCritRech = 'Critère de recherche : ';
    CdeSaisLine = 'Saisie d''une ligne';
    CdeBcde = 'Bon de Commande';
    CdeOkModif = 'Modifiable';
    CdeNotModif = 'Non Modifiable';
    CdeCancelBcde = 'Abandonner toutes les modifications entreprises dans le document ?   ' + #13 + #10 + #13 + #10 +
        'ATTENTION : Toutes les modifications éventuellement faites dans les lignes   ' + #13 + #10 +
        'vont être abandonnées ...';
    CdeCancelLine = 'Abandonner les modifications réalisées dans cette ligne ?   ';
    CdePostBcde = 'Enregistrer les modifications du document en cours ?    ';
    CdeTabloVide = 'Impossible de valider une ligne sans quantités saisies ... ';
    cdeLineInModif = 'Pour pouvoir changer d''onglet,' + #13 + #10 +
        'if faut d''abord valider [F12] ou abandonner la ligne en cours de saisie    ';

    CdeRechVide = 'Aucun article trouvé ... ' + #13 + #10 +
        '(Cet article existe peut-être mais n''est pas accessible dans votre contexte de travail actuel )';
    CdePxBase = 'Prix de Base';
    CdeCadexist = 'Cette date de livraison existe déjà pour le code chrono : §0   ';
    CdeConfDelLine = 'Confirmer la suppression de la ligne sélectionnée...   ';
    CdeConfDelBcde = 'Confirmer la suppression complête du document affiché...   ';
    CdeConfConfDelBcde = 'La suppression de ce document est irréversible !' + #13 + #10 +
        'Etes-vous bien certain de vouloir le supprimer ?   ';
    CdeFournOblig = 'La saisie du fournisseur est obligatoire!...    ';
    CdeMagOblig = 'La saisie du magasin est obligatoire!...    ';
    CdeExercice = 'La saisie de l''exercice commercial est obligatoire!...   ';
    CdeRgltOblig = 'La saisie des conditions de paiement est obligatoire!...   ';
    CdeOnlyOneSuppr = 'Plusieurs lignes sélectionnées...    ' + #13 + #10 +
        ' On ne peut supprimer qu''une seule ligne à la fois !     ';
    CdeNewBcde = 'Nlle Commande';
    CdeNewRecep = 'Nlle Réception';
    CdeNewTrans = 'Nx Transfert';
    CdeExerciceOblig = 'La saisie de l''exercice commercial est obligatoire...   ';
    CdeDateRglt = 'La date de règlement ne peut pas être antérieure à la date de livraison!...   ';

    CdeArchive = 'Confirmer l''archivage de(s) §0 document(s) sélectionné(s)...    ';
    CdeNoArchive = 'Aucun document à archiver ...      ';
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

    RechNoCollec = 'IMPOSSIBLE, aucune collection n''est sélectionnée ...   ';

// FicheArticle

    MessExcel = ' Voulez-vous ouvrir Excel ?';
    InfExcel = ' Le fichier Excel §0 a été généré.';
    TipartPseudo = 'Pseudo';
    TipartRef = 'Référencé';
    TipartCat = 'Catalogue';
    FartDelartCnf = 'de la fiche article - code chrono :';
    FartListeDes = 'Liste des';
    FartGarantie = 'GARANTIE CONSTRUCTEUR';

// ClassementDial

    ClasseTitle = ' Eléments du classement : ';
    ClasseDbgHint = '[INSER] Créer    [F2] Modifier    [SUPPR] Supprimer';

    ErrClassement = 'Ce nom de classement n' + #39 + 'est pas valide !';
    ErrItemClassement = 'Le nom n' + #39 + 'est pas valide !';
    ErrIntegrityArticle = 'Ce classement est utilisé par un article !';
    ErrIntegrityClient = 'Ce classement est utilisé par un client ...';
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
    RechFiltre = 'Impossible d''acceder à la fiche trouvée...' + #13#10 +
        'Vérifiez que vous n''avez pas un filtre en cours';
    OnRef = 'Référencement';
    OnIns = 'Création';
    ArtSupGroup = 'Supprimer le groupe "§0" pour cet article?... ';
    ArtSupCollec = 'Supprimer la collection "§0" pour cet article ?...';

    ArtSupGarantie = 'Confirmez que la suppression de la garantie §0';
    ErrEditGarantie = 'Le nom de cette garantie ne peut pas être modifié ...';

    FartCBFNoValid = 'Code Barre fournisseur Non Valide ( ou déjà utilisé )...    ';

    Fart_dela = 'de la fiche article en cours...';
    FartCtrlCdmnt = 'Le champ conditionnement est décoché !          ' + #13 + #10 +
        #13 + #10 +
        'Un article ne peut être conditionné que si :   ' + #13 + #10 +
        '- L''unité est définie.' + #13 + #10 +
        '- La quantité de conditionnement est supérieure à 1';
    FartTdb = 'Prix de base';
    FartSupprTar = 'Confirmez la suppression du particulier de la taille affichée ...  ';
    FartNoGTaille = 'IMPOSSIBLE car aucune grile de taille de sélectionnée ...   ';
    FartTarifExist = 'La taille §0 a déjà un tarif spécifique défini ... ';
    FartErrMajTailles = 'Problème lors de la mise à jour du tarif ...     ' + #13 + #10 + 'Vos modifications sont abandonnées !';
    FartSupprTailBase = 'On ne peut pas supprimer le prix de base !...    ';
    FartSupprTail = 'Pour supprimer des tailles travaillées' + #13 + #10 +
        'il faut commencer par la plus petite et descendre une à une ...' + #13 + #10 +
        '( On ne peut supprimer ni la taille de base ni une taille intermédiaire )';
    FartAvortCrea = 'Création d''article impossible ...    ' + #13 + #10 +
        '  Problème de génération du prix de vente de base.   ';
    TabachatStd = 'Tarif';
    TabachatCrea = 'Nouvel Article';
    FartNomartOblig = 'Le nom de l''article est obligatoire ...     ';
    FartFournOblig = 'La désignation d''un fournisseur est obligatoire ...     ';
    FartMarkOblig = 'La désignation d''une marque est obligatoire ...      ';
    FartSsfOblig = 'La désignation d''un classement dans la nomenclature est obligatoire ...     ';
    FartGtOblig = 'La désignation d''une grille de taille est obligatoire ...     ';
    FartFourCrea = 'Problème lors de l''initialisation du fournisseur ... ';
    FartNeoFourn = 'Ajouter le fournisseur "§0" à la liste    ' + #13 + #10 +
        'des fournisseurs de l''article en cours ?   ';
    FartFournExist = 'Le fournisseur "§0" est déjà référencé par cet article...   ';
    FartFourn = 'Fournisseur';
    FartFPrin = 'Frn.Principal';
    CnfSupFourn = 'Confirmer la supression du fournisseur "§0"   ';
    FournSupPrin = 'Impossible de supprimer "§0" car c''est le fournisseur principal    ';
    FournDejaPrin = '"§0" est déjà le fournisseur principal...   ';
    ChangeFornPrin = 'Définir "§0" comme fournisseur principal ?   ';
    FartchangeSf = 'ATTENTION : Si vous venez de changer l''affectation nomenclature  ' + #13 + #10 +
        ' de cet article, vérifiez que son affectation comptable et sa TVA conviennent toujours !  ';
    ArtRefMarque = ' Référence Marque : ';

    ErrCoefTheorique = 'Le coefficient théorique doit être supérieur à 0 !';
    CanModifHint =
        '[INS] Nouvel article [F2] Modifier [F12] Enregistrer [SUPPR] Supprimer l''article [Clic Droit] Popup Menu';
    CannotModifHint = 'Fiche article';
    HintNotEditChpTaille = '[F4, Double Click ou Bouton] Liste des tailles travaillées de l''article';
    HintInsertChpTaille = '[F4, Double Click ou Bouton] Liste des grilles de tailles  [Suppr] Supprimer la grille de taille sélectionnée';
    HintEditChpTaille = '[F4, Double Click ou Bouton] Gestion des tailles travaillées de l''article';
    HintDesDbgs = '[INS] Ajouter un nouvel élément  [SUPPR] Supprimer l''élément sélectionné';
    HintEditFourn = 'Liste des fournisseurs référencés pour cet article    ';

    TitleStk = 'Etat de stock de l' + #39 + 'article - Chrono :';
    TitleRal = 'Reste à Livrer de l' + #39 + 'article - Chrono :';
    TitleStkMM = 'Etat de stock par magasin de l' + #39 + 'article - Chrono :';
    TitleRalMM = 'Reste à Livrer par magasin de l' + #39 + 'article - Chrono :';
    TitleHistoFourn = 'Historiques d''achat de l''article - Chrono : ';

    MsgLKNotEdit = 'Vous n''êtes pas en édition ! Impossible de mettre à jour la fiche article ...   ';
    ChronoMess = ' Le préfixe n''est pas modifiable';
    SupprImgCap = ' Suppression de l''image associée';
    CopyImgCap = ' Association d''une image à l''article en cours';
    SupprImg = 'Supprimer l''image associée à l''article en cours ?';
    Fart_UnikChrono = 'Ce code chrono est déjà pris par un autre article ...   ';
    FartNoFourn = 'Avant de saisir le tarif il faut définir le fournisseur principal !    ';
    FartCoulGes = 'Gestion des couleurs de l''article';
    FartCoulVisu = 'Liste des couleurs définies pour l''article';
    FartSupprGT = 'La suppression de la grille de taille va supprimer le tarif défini ...    ' + #13 + #10 +
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
    MessGtfLibVid = 'Le nom de la grille de taille est obligatoire...';
    MessNbtaille = 'Impossible de valider votre grille de taille, elle ne contient pas de taille...';
    MessModLibGTF = 'Impossible de changer le libellé d''une grille de taille de référence';
    MessModLibTail = 'Impossible de changer le libellé d''une taille de référence';
    MessModLibVid = 'Le nom du modèle est obligatoire...';
    MessMod28 = 'Impossible, le nombre de tailles travaillées est limité à 28...';
    GtfHintTailles = '[INS] Insérer une nouvelle taille   [CTRL+INS] Insérer une sous-taille';
    GtfNoDelete = 'IMPOSSIBLE de supprimer cette grille de taille car elle est utilisée !...   ';
    GTSCannotDelete = 'IMPOSSIBLE de supprimer la grille de taille statistique "§0"   ' + #13 + #10 +
        ' car elle est référencée par une Sous-Famille.';

    GtfModeleHint = '[F3] Sélectionne la taille pointée  [Double Clic] Ajoute la taille pointée à la liste des tailles travaillées';
    GtfModeleHint2 = '[F3] Sélectionne la taille pointée  [Double Clic] Retire la taille pointée de la liste des tailles travaillées';
    MessModEnf = 'Impossible de déplacer cette "taille", car la taille parent n''est pas un séletionnée...';
    MessGTSCancel = 'Abandonner les modifications éffectuées dans la grille de taille "§0"   ';
    GtsCreaChpOblig = 'Le nom et la catégorie doivent être obligatoirement renseignés!...   ';
    GtfManqueNom = 'Le nom de la taille doit être obligatoirement défini ...    ';
    GtfCancelWork = 'Abandonner tout le travail effectué sur cette grille de taille ?...   ';

    MessSupCoulTer = 'Impossible de supprimer cette couleur,' + #13 + #10 + '   car elle est présente dans les commandes ...';
    SelcoulDbg = '[F4] et [Double Clic] Exécuter la fonction associée au bouton';
    CoulFormHint = '[F12]  OK    [Echap]  Abandonner';
    CoulOkGesFormHint = '[Ins] Créer [F2] Editer [Suppr] Supprimer [F4] Ouvrir liste';
    CoulStatOkGesFormHint = '[Ins] Créer [Ctrl+Ins] Sous-couleur [F2] Editer [F12] Ok';
    RecepModerOblig = 'La saisie du mode de règlement est obligatoire!...   ';

// Marque_Frm

    messMARQUEGtf = 'Attention vous pouvez déplacer 100 tailles maximun à la fois...';

// SelGt_Frm

    MessSupTailleTTter = 'Impossible de supprimer cette taille,' + #13 + #10 + '   car elle est présente dans les commandes ...';
    SelTTailO = 'La sélection d''au moins une taille travaillée est obligatoire ...  ';
    SelGTTitle = ' Sélection d''une grille de tailles et des tailles à travailler';

// Fournisseurs
    FourNoVille = 'Attention pas de ville !!!';
    FourErrNoDelete = 'Impossible de supprimer ce fournisseur car il a des données associées     ';
    FourCnfDel = 'Etes-vous sûr de vouloir supprimer ce fournisseur?';
    ErrNoPaysListeFact = 'Vous devez obligatoirement renseigner le pays de cette ville §0';
    ErrNoPaysExprfourn = 'Vous devez obligatoirement renseigner le pays de cette ville §0';
    ErrNoVilleExprfourn = 'Vous devez obligatoirement renseigner la ville du fournisseur §0';
    ErrNomFournExprfourn = 'Un fournisseur doit obligatoirement avoir un nom !';
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
    RecepOkCloture = 'Confirmer la clôture du bon de réception affiché ...   ' + #13 + #10 +
        '  ATTENTION : ce document ne sera plus modifiable ! ';
    RecepArtExist = 'Cet article est déjà référencé dans le bon de réception !...   ';
    RecepCadExist = '[ Chrono : "§0" ] Cett cadence est déjà référencée dans le bon de réception.   ' + #13 + #10 +
        '   Faut-il complêter cette ligne avec les quantitées restant à livrer ?...   ';
    RecepDateRglt = 'La date de règlement ne peut pas être antérieure à la date de livraison!...   ';
    RecepNoRal = 'Aucun reste à livrer chez ce fournisseur...     ';
    RecepNotModif = 'Clôturé';
    TransArtExist = '[ Chrono : "§0" ] Cet article est déjà référencé dans le bon de transfert !...   ';
    TransIdemMag = 'Magasin d''origine et de destination doivent être différents !...     ';
    CdeNoDocVide = 'Impossible de valider un " document " vide !...    ';
    CdeNoChangeChp = 'Modification impossible lorsque le document a des lignes ...    ';
    TransOkCloture = 'Confirmer la clôture du bon de Transfert affiché ...   ' + #13 + #10 +
        '  ATTENTION : ce document ne sera plus modifiable ! ';
    CdeVR = 'Voir RAL';
    CdeNVR = 'Masquer RAL';
    CdeTitreListe = '  Liste des bons de commande';
    recepTitreListe = '   Liste des bons de réception';
    transTitreListe = '   Liste des bons de transfert';
    TransIsNega = 'ATTENTION : le stock de cette taille / couleur va devenir négatif !...     ';
    TransNoEdit = 'IMPOSSIBLE de modifer un bon de transfert au delà de 30 jours !...   ';
    TMMHintStkCour = 'Les transferts saisis ne seront pris en compte dans le stock affiché qu''aprés validation du bon... ';
    TMMHintStkDate = 'Le stock affiché est le stock à la date du bon "APRES LE TRANSFERT" ';
    TMMStkCour = 'Stock courant';
    TMMStkDate = 'Stock au';

    StkChkCoulS = 'Couleurs affichées';
    StkChkCoulM = 'Couleurs masquées';
    StkPPL = 'Etat de stock du magasin : ';
    PPStkHint = 'Paramétrage des colonnes à éditer';
    CmzEditDoc = 'Afficher / Masquer l''outil de configuration de l''édition';
    SbtnEditDoc = 'Imprimer le document';
    SelectLineBre = 'Vous devez séléctionnez les lignes que vous voulez ré-étiquetter !';
    RecepCapFrmRal = ' Restes à livrer : ';

    RecepErrInitTab1 = 'Problème lors de la création de cette ligne de réception ...';
    RecepErrInitTab2 = 'Cette ligne doit être abandonnée...';
    RecepErrInitTab3 = 'Ré-essayez une nouvelle fois et ...';
    RecepErrInitTab4 = '        Merci de prévenir "Hervé" à Algol qu''il subsiste des problèmes lors de la     ';
    RecepErrInitTab5 = '        création de nouvelles lignes de réception.';

// Etiquettes

    RecepEtikMess = 'Valider le bouton correspondant à votre choix ... ';
    RecepEtikP1 = 'Vous avez en stock des articles à un prix de vente différent.';
    RecepEtikP2 = 'Selon votre choix...';
    RecepEtikP3 = '         ...des étiquettes seront générées pour ces articles.';

// Edition de caisse

    JVTklDateLib = 'Journal des ventes du §0 au §1  -  ';
    HITParadeVte = 'Hit parade des ventes du §0 au §1  -  ';
    JVTkeDateLib = 'Liste des tickets du §0 au §1  -  ';
    JvTklSel = 'Sélection de magasins';
    JVLibSess = 'Magasin §0 - Poste §1 - Session No §2';
    FontCourierNew = 'Courier New';

    ConsoDivLib = 'Consommations diverses du §0 au §1  -  ';

    ChxDateJV = 'Période incorrecte !... Le date de fin ne peut être antérieure à celle de fin.   ';
    ChxSessJV = 'Choix de session non valide !?....     ';
    CHXDateJVMP = 'Le choix d''un magasin et d''un poste sont obligatoires...     ';
    CptCltTit = 'Comptes clients  ';

// Clients

    ErrNomClient = 'Vous devez obligatoirement spécifier un nom pour ce client';
    ErrNoAdrClient = ' La saisie d''une ville est obligatoire';
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
    CdvOblig = ' La saisie du champ "§0" est obligatoire !...    ';
    CdvNoPx = ' Le prix unitaire de cet article est à "0.00" ... ' + #13 + #10 +
        '   (Il n''est certainement pas référencé en stock à cette date )' + #13 + #10 + #13 + #10 +
        '   Faut-il continuer et accepter cette opération ?';
    CdvCtrlDate = ' La date de cette opération ne peut pas être postérieure     ' + #13 + #10 +
        '   à la date courante ... ';
    CdvDelai = ' Cette opération n''est plus modifiable ...    ';
    HintConsodiv = 'Pour une nouvelle ligne de consommation... rechercher l''article     [F12] Enregistrer [Echap] Abandonner [F2] Modifier';

// Ressourcesstring communes des applications
// ******************************************

// 29/01/2001 - Sandrine MEDEIROS - ajout Messages Classiques : WarAbandon, WarAbandonCreat, WarAbandonModif

//--------------------------------------------------------------------------------
// Messages d'erreurs BDD
//--------------------------------------------------------------------------------

    ErrLectINI = 'Erreur de lecture du fichier d''initialisation';
    ErrConnect = 'Erreur de connection à la base de donnée';
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
        'Prévenir Algol en précisant bien le contexte dans lequel cela se produit    ';
    ErrToMuchTransac = 'Problème de gestion du compteur de transaction' + #13 + #10 +
        'Le signaler à Algol en précisant bien le contexte dans lequel cela se produit.   ';

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

    WarAbandon = 'Est-vous sûr de vouloir abandonner le travail en cours ?';
    WarCancel = 'Est-vous sûr de vouloir abandonner les modifications effectuées ?';
    WarAbandonCreat = 'Est-vous sûr de vouloir abandonner votre création §0 ?';
    WarAbandonModif = 'Est-vous sûr de vouloir abandonner votre modification §0 ?';
    WarSuppr = 'Confirmez la suppression §0 ... ';
    WarPost = 'Enregistrer le travail en cours ?';

    ErrIdRefCentrale = 'Cette §0 a été fournie par §1, elle n' + #39 + 'est pas modifiable !';
    ErrIdRefCentrale1 = 'Ce §0 a été fourni par §1, il n' + #39 + 'est pas modifiable !';

//--------------------------------------------------------------------------------
// Hints Standards
//--------------------------------------------------------------------------------
    HintEditMemo1 = '[F4 ou Double Click ou Bouton] Ouvre la zone d''édition associée au bouton';
    HintNoEditMemo1 = 'La zone d''édition n''est pas accessible';
    HintEditLookup1 = '[F4 ou Double Click ou Bouton] Ouvre la liste associée au bouton  [Suppr] Effacer';
    HintNotEditLookup1 = 'La liste associée au bouton n''est pas accessible';
    HintEditCheck1 = 'Appuyer sur la barre d''espace ou cliquer pour inverser l''état de la coche';

// Ressourcesstring communes des applications
// ******************************************
// 06/02/2001 - Sandrine MEDEIROS - Permission Générale : SUPER
//                                  Permission Nomenclature : CMS_NK
    UILSuper = 'SUPER';

//--------------------------------------------------------------------------------
// Nom des vieilles Permissions
//--------------------------------------------------------------------------------

    UILFct_Negoce = 'FCT-NEGOCE';
    UILFct_GestCde = 'FCT-GESTION CDE';
    UILmodif_NK = 'NOMENCLATURE - MODIFIER';
    UILVisuMag = 'VISU MAG';
    UILVisuMag_Stock = 'VISU MAG - STOCK';
    UILmodif_Art = 'FICHE ARTICLE - MODIFIER';
    UILachatVis_Art = 'FICHE ARTICLE - ACHAT VISIBLE';
    UILmodif_Bcde = 'BON CDE - MODIFIER';
    UILmodif_Recep = 'BON RECEPTION - MODIFIER';
    UILmodif_TransMM = 'BON TRANSFERT - MODIFIER';
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
    UILModif_FicheArt = 'modifier - FICHE ARTCLE';
    UILModif_LaNK = 'modifier - NOMENCLATURE';
    UILModif_Fourn = 'modifier - FOURNISSEUR';
    UILModif_ConsoDiv = 'modifier - CONSO DIVERSES';
    UILModif_TarVente = 'modifier - TARIFS DE VENTE';
    UILModif_Clt = 'modifier - CLIENT';
    UILModif_Livr = 'modifier - BON DE LIVRAISON';
    UILModif_Devis = 'modifier - DEVIS';
    UILModif_Fact = 'modifier - FACTURE';

//--------------------------------------------------------------------------------
// Permissions de Visualisation de données
//--------------------------------------------------------------------------------
    UILVoir_Tarif = 'voir - fiche article - ONGLET TARIF';
    UILVoir_Mags = 'voir - TOUS LES MAGASINS';
    UILVoir_StockMags = 'voir - TOUS LES MAGASINS - STOCK';

//--------------------------------------------------------------------------------
// Permissions de gestion de la CAISSE
//--------------------------------------------------------------------------------
    UILCaisse_Cloturer = 'caisse - CLOTURER / PRELEVER';
    UILCaisse_SupprTik = 'caisse - SUPPRESSION D''UNE LIGNE DE TICKET';
    UILCaisse_EncTikNeg = 'caisse - ENCAISSEMENT D''UN TICKET NEGATIF';
    UILCaisse_AnnulTik = 'caisse - ANNULATION DU TICKET EN COURS';
    UILCaisse_SupprOldTik = 'caisse - SUPPRESSION D''UN ANCIEN TICKET';
    UILCaisse_VteSoldee = 'caisse - VENTE SOLDEE';
    UILCaisse_VtePromo = 'caisse - VENTE PROMO';
    UILCaisse_VteRemise = 'caisse - VENTE AVEC REMISE';
    UILCaisse_RetClient = 'caisse - RETOUR CLIENT';
    UILCaisse_FicheClient = 'caisse - CREATION MODIF FICHES CLIENTS';
    UILCaisse_ReajCF = 'caisse - REAJUSTEMENT D''UNE CARTE DE FIDELIETE';
    UILCaisse_Training = 'caisse - MODE TRAINING';
    UILCaisse_ParamModeEnc = 'caisse - PARAMETRAGE DES MODES D''ENCAISSEMENT';
    UILCaisse_ParamBtn = 'caisse - PARAMETRAGE DES BOUTONS';
    UILCaisse_OngletUtil = 'caisse - ONGLET UTILITAIRE';
    UILCaisse_OuvManu = 'caisse - OUVERTURE MANUELLE DU TIROIR';
    UILCaisse_SaisirDepense = 'caisse - SAISIR UNE DEPENSE';
    UILCaisse_RembClt = 'caisse - REMBOURSEMENT CLIENT';

//--------------------------------------------------------------------------------
// Permissions d'accès au menu de Ginkoia
//--------------------------------------------------------------------------------
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
    UILMenu_FicheArt = 'menu - gérer les produits - gestion du stock - FICHES ARTICLES';
    UILMenu_ConsoDiv = 'menu - gérer les produits - gestion du stock - CONSO DIVERSES';
    UILMenu_TarifVente = 'menu - gérer les produits - gestion du stock - TARIFS VENTES/MAG';
    UILMenu_EtikDiff = 'menu - gérer les produits - gestion du stock - ETIQUETTES DIFFER';
    UILMenu_EtatStock = 'menu - gérer les produits -analyse du stock- ETAT STOCK';
    UILMenu_EtatStockDate = 'menu - gérer les produits -analyse du stock- ETAT STOCK A DATE';
    UILMenu_EtatStockDetail = 'menu - gérer les produits -analyse du stock- ETAT STOCK DETAILLE';
    UILMenu_ListArtRef = 'menu - gérer les produits -analyse du stock- LISTE ARTICLES REF.';
    UILMenu_ListArtRefDetail = 'menu - gérer les produits -analyse du stock- LISTE DET. ART. REF';
    UILMenu_ListCtlg = 'menu - gérer les produits -analyse du stock- LISTE DU CATALOGUE';
    UILMenu_Recept = 'menu - gérer les produits - RECEPTION';
    UILMenu_TrsfMM = 'menu - gérer les produits - TRANSFERT INTER-MAGASINS';
    UILMenu_Inventaire = 'menu - gérer les produits - INVENTAIRE';
    UILMenu_Clt = 'menu - gérer la relation client - CLIENTS';
    UILMenu_Devis = 'menu - vendre - gestion du négoce - DEVIS';
    UILMenu_Livraison = 'menu - vendre - gestion du négoce - BONS DE LIVRAISON';
    UILMenu_Facture = 'menu - vendre - gestion du négoce - FACTURE';
    UILMenu_OrgEtps = 'menu - paramétrage - général - ORGANISATION DE L''ENTREPRISE';
    UILMenu_ParamTva = 'menu - paramétrage - général - TVA - TYPE COMPTABLE';
    UILMenu_ParamExeComm = 'menu - paramétrage - général - EXERCICE COMMERCIAUX';
    UILMenu_ParamEtik = 'menu - paramétrage - général - ETIQUETTE';
    UILMenu_ParamNK = 'menu - paramétrage - gérer les produits - NOMENCLATURE';
    UILMenu_GrilleTaille = 'menu - paramétrage - gérer les produits - GRILLES DE TAILLES';
    UILMenu_ParamGenre = 'menu - paramétrage - gérer les produits - GENRES, GROUPES';
    UILMenu_ParamCF = 'menu - paramétrage - gérer la rel. client - PARAM FIDELISATION';
    UILMenu_ParamEncaiss = 'menu - paramétrage - vendre - MODE D''ENCAISSEMENT, COFFRE';
    UILMenu_EditNegoce = 'menu - paramétrage - vendre - REGL. EDITIONS DANS LE NEGOCE';
    UILMenu_PersoBarreOutil = 'menu - paramétrage - gestion utilisateurs - PERSO BARRE D''OUTIL';
    UILMenu_DroitUtil = 'menu - paramétrage - gestion utilisateurs - MODIF. DES DROITS';

//****************************
// Ressources de la caisse
//****************************

    //28/02/2002 Bruno
    TrancheVide = 'Impossible, la correspondance entre la monnaie et les points est à zéro';

    // Pascal 27/02/2002
    CstProbSession = '      Vous avez un problème de clôture'#13#10 +
        'Veuillez noter le message d''erreur et appeler ALGOL'#13#10 +
        'Clicker sur OK pour visualiser le message d''erreur';
    // Pascal 18/02/2002
    CstPasVersement = 'Aucun type de versement n''a été selectionné';
    CstPasCoffre = 'Aucun coffre n''a été sélectionné';
    CstPasBanque = 'Aucune banque n''a été sélectionnée';

    // Bruno 18/02/2001
    RegulGlob01 = 'Dans un premier temps, vous allez devoir choisir dans la liste des tickets' + #13 + #10 +
        '   de la session en cours, le ticket à corriger.' + #13 + #10 +
        '  ' + #13 + #10 +
        '   Ensuite, Vous allez retrouver les encaissements réalisés sur ce ticket.' + #13 + #10 +
        '   Vous pourrez soit supprimer un encaissement [Suppr] pour ' + #13 + #10 +
        '   le remplacer par un autre, soit intervenir sur les valeurs.';

    RegulGlob03 = 'Confirmez vous l''annulation de votre correction d''encaissement?';

    // Bruno 15/02/2002
    ClientPasPossible = 'Impossible d''appeler ce cleint en caisse...';
    // Bruno 15/02/2002 Correction
    Type24 = 'Annulation d''un ancien ticket';

    // 15/02/2002 Correction
    CstPasDencaissement = 'Aucun encaissement de ce type n''existe dans la session';
    CstCaisOuv = 'Ouverture';
    CstCaisFer = 'Fermeture';
    //15/02/2002
    CstLibVerifComptage = 'Comptage  : Pièce %4d    Montant %10.2n';
    CstTickNum = 'Ticket num ';

    // Pascal 11/02/2002
    CstPanMoy = 'Panier moyen';
    CstValeur = 'Valeur';
    CstQuantite = 'Quantité';
    CstVtProduit = 'Vente produit %s';
    CstVersAutoCoffre = 'VERSEMENTS AUTOMATIQUES AU COFFRE';
    CstVersAutoBQe = 'VERSEMENTS AUTOMATIQUES EN BANQUE';
    // Pascal le 7/02/2002
    CstDuAu = 'Du %s au %s';

    // Trié
    Pas2Caisse = 'Vous ne pouvez pas, sur un même poste, activer plusieurs fois le module ''Caisse Ginkoia'' ...';
    DejaClientEnCours = 'Attention vous ne pouvez pas appeler ce client, il est déjà en cours sur une autre caisse...';

    Aucuntrouve = 'Aucun article trouvé correspondant à votre saisie...';
    LibSousTotal = 'SOUS TOTAL';
    Question = 'Souhaitez vous terminer le ticket en cours ?';
    LibTicketenCours = 'Impossible de quitter la caisse, vous avez un ticket en cours...';
    LibRapido = 'Impossible vous avez déjà éffectués des opérations dans l''onglet ''Encaissement''...';
    PasSessionEnCours = 'Attention, il n''y a pas de session en cours...';
    PasClientEnCours = ' Impossible, vous n''avez pas de client en cours ';
    Acompte = 'Acompte';
    Reglement = 'Reglement';
    Remboursement = 'Remboursement';
    TestAppelClient = 'Impossible, il y a des opérations en cours pour le client actuel...';
    RenduPasPossible = 'Attention le ''Rendu de monnaie'' est interdit pour ce mode de paiement...';
    CompteBloque = 'Opération impossible, le compte du client est bloqué...';
    SoldeNonCrediteur = 'Opération impossible, le solde du compte client n''est pas créditeur...';
    CreditEpuise = 'Attention vous avez épuisé le crédit du compte...';
    OpeAnnule = 'Opération annulée, le reste à payer est nul...';
    TotAcoReg = 'TOTAL OPERATIONS CLIENT';
    TotVente = 'TOTAL DES VENTES';
    PasVendeur = 'Attention, votre caisse est paramètrée avec une gestion vendeur,' + #13 + #10 + 'mais vous n''avez pas créé de vendeur...';
    PasCaissier = 'Attention, votre caisse est paramètrée avec une gestion caissier,' + #13 + #10 + 'mais vous n''avez pas créé de caissier...';
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
    PblImpressionFacturetteSuite = 'Problème lors de l''impression.' + #13 + #10 + 'Veuillez insérer à nouveau le document suivant ...';

    FactureNumero = 'Facture Numero : ';
    LibCaissier = 'Caissier : ';
    LibVendeurCaisse = 'Vendeur  : ';
    AnnuationTck = 'ANNULATION DU TICKET NUMERO ';
    LbCorrectionMP = 'CORRECTION ENCAISSEMENT';
    LibCorrectionMP = 'Opération impossible, vous êtes en correction d''encaissement...';

    QuestionDepense = 'Confirmez vous la saisie de dépense?';
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
    InfEtatSesClotNoCtrl = 'Cloturée mais non controlée';
    InfEtatSesOuverte = 'Ouverte';
    ErrRecNotFound = 'Enregistrement non trouvé. Mise à jour impossible';

    InfApportFromSession = 'Fond Initial';
    InfRetraitToSession = 'Retrait vers la session n°';
    InfVersementBanque = 'Versement à la banque ';

    InfApportPoste = 'Apport en caisse : ';
    InfRetraitPoste = 'Retrait de la caisse : ';
    InfComptageGlobModeEnc = 'Comptage global d''un mode d''encaissement';
    InfComptageDetModeEnc = 'Comptage détaillé d''un mode d''encaissement';
    InfPrelevement = 'Saisie manuelle d''un prelevement';

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
    ErrNoPosteNoSession = 'Pas de poste ou de session selectionné';
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
    ErrNoModeEnc = 'Aucun mode d''encaissement selectionné';
    ErrInvalidSource = 'Pas de source selectionnée';
    ErrInvalidDest = 'Pas de destination selectionnée';
    InfMontant = 'Montant en ';
    ErrInvalidQte = 'Nombre de pièce saisi incorrect';

//General

    //PasCaissier = 'Attention, votre caisse est paramètrée avec une gestion caissier,' + #13 + #10 + 'mais vous n''avez pas créé de caissier...';
    //PasSessionEnCours = 'Attention, il n''y a pas de session en cours...';
    InitModeEncImpossible = 'Impossible, des modes de paiement existent déjà pour ce magasin...';
    Pascoffre = 'Vous devez au préalable créer un coffre pour ce magasin...';
    Pasbanque = 'Vous devez au préalable créer une banque pour ce magasin...';
    BtnDejaCree = 'Attention des boutons existent déjà, voulez vous les supprimer?';
    CaisseEnCours = 'Impossible de clôturer la session, la caisse est encore ouverte';
    TMnonConnectee = ' L''imprimante ticket n''est pas allumée ou pas branchée...';
    TCnonConnecte = ' Le tiroir caisse n''est pas branché...';
    JourDifferentSessionL1 = ' Attention, il existe une session en cours ouverte le ';
    JourDifferentSessionL2 = 'Souhaitez vous clôturer la session?';
    ConfAnnul = 'Confirmez vous l''annulation de ce ticket?';
    DejaAnnule = 'Opération impossible, ce ticket est déjà annulé...';
    AnnulRegul = 'Annulation de la correction des encaissements en cours?';
    Pasledroit = 'Attention, vous n''avez pas les droits pour utiliser cette fonction...';
    TicketSimple = 'Ticket simple';
    TicketTVA = 'Ticket avec TVA';
    Facturet = 'Facturette';
    SupEncaissement = 'Confirmez vous l''annulation de cet encaissement?';
    CaptionAnnul = 'Annulation d''un ticket';
    CaptionCptcli = 'Liste des tickets';
    CaptionRegul = 'Correction des encaissements';

//Param Caisse
    Chrono = 'Code Chrono';
    RefFourn = 'Ref. fournisseur';

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
    BADispo = 'POINTS CUMULABLE JUSQU''AU';
    Utilisable = 'UTILISABLE JUSQU''AU';
    GenerationBAL1 = 'Votre client a droit à un Bon d''achat de';
    GenerationBAL2 = 'Souhaitez vous le générer aujourd''hui?';
    BenefBA = 'Votre client bénéficie d''un bon d''achat de';
    ValiditeBA = 'valide jusqu''au';
    QuestionBenefBA = 'Est ce qu''il souhaite l''utiliser maintenant?';
    PasModeEncFidelite = 'Opération impossible, vous n''avez pas de mode d''encaissement avec le type ''Fidélité''';
    FidManuel = 'Points fidélités saisis manuellement, pas de liaison avec un ticket de caisse...';
    BaPasUtilise = 'Ce bon d''achat n''a pas été utilisé...';
    BonAchat = 'Bon d''achat';
    NewParamCF = 'Attention cette fonction vous permet de paramétrer la grille des bon d''achat.' + #13 + #10 +
        'Souhaitez vous annuler le paramétrage précédent?';
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

    //Fonctions boutons
    Type01 = 'Appel Client';
    Type02 = 'Suppression de la ligne courante';
    Type03 = 'Suppression du ticket en cours';
    Type04 = 'Qte +1';
    Type05 = 'Retour Article';
    Type06 = 'Acces au champs remise,qte,prix...';
    Type07 = 'Remise Article (Normale, Solde,Promo)';
    Type08 = 'Liste des pseudos articles';
    Type09 = 'Mode d''encaissement';
    Type10 = 'Mode d''encaissement Rapide';
    Type11 = 'Sous Total';
    Type12 = 'Compte Client';
    Type13 = 'Reste Du';
    Type14 = 'Bon Achat Interne';
    Type15 = 'Bon Achat Externe';
    Type16 = 'Reglement';
    Type17 = 'Versement d''avance';
    Type18 = 'Remboursement client';
    Type19 = 'Validation des modifs. de la fiche client';
    Type20 = 'Annulation des modifs. de la fiche client';
    Type21 = 'Mise en attente du client';
    Type22 = 'Appel d''un article précis';
    Type23 = 'Réédition du ticket';
    Type25 = 'Correction des modes d''encaissement';
    Type26 = 'Ouverture du tiroir caisse';
    Type27 = 'Saisie d''une Depense';
    Type28 = 'Ticket Carte fidelite';
    Type29 = 'Acces à la liste complete des boutons';

    vente = 'Vente';
    Client = 'Client';
    Encaissement = 'Encaissement';
    Utilitaires = 'Utilitaires';

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
        '   Souhaitez vous poursuivre la réinitialisation?';
    QuitterBtn = 'Pour que les changements soient pris en compte, il faut fermer tous les tickets en cours.' + #13 + #10 +
        '   Lorsqu''il ne reste plus que l''onglet ''Ecran de contrôle'' vous pouvez réouvrir la caisse...';
    CopierBtn = 'Attention cette opération détruit les boutons existant et les remplace' + #13 + #10 +
        '   en prenant comme modèle une caisse que vous allez sélectionner ensuite.' + #13 + #10 +
        '   Souhaitez vous poursuivre le traitement?';

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
    CstEnQuantite = '                    en Quantite';
    CstEnQte = '             en Qte';
    CstCA = 'CHIFFRE D''AFFAIRE';
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
    CstFondCais1 = 'GESTION DU FOND DE CAISSE';
    CstFondCais2 = 'FOND DE CAISSE';
    CstEnc1 = '      Encaissements';
    CstEnc2 = ' Encaisse';
    CstSoldeEncaissement = '  Solde de l''encaissement : ';

    OKRegulGlob = 'Impossible, pour valider l''opération le solde doit être à zéro';

IMPLEMENTATION

END.


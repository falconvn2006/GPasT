unit Integration.Ressources;

interface

type
  TNiveau = (NivTrace, NivNotice, NivErreur, NivArret);

const
  SEPARATEUR        = '|';
  MOTPASSE          = '1082';
  FORMAT_DATE_HEURE = 'yyyy-mm-dd"T"hh-nn-ss';
  CLE_CRYPTAGE      = '{EB519B72-E247-41CC-AE4A-597E6F3C43CE}';

  REP_FORMAT = '%0:s\%1:s\%2:s\%3:s';

  REP_INTEGRES = 'Intégrations';
  REP_ENCOURS  = 'En cours';
  REP_SUCCES   = 'Succès';
  REP_ERREURS  = 'En erreur';

  REP_ARTICLES         = REP_INTEGRES + '\Articles\';
  REP_ARTICLES_ENCOURS = REP_ARTICLES + REP_ENCOURS;
  REP_ARTICLES_SUCCES  = REP_ARTICLES + REP_SUCCES;
  REP_ARTICLES_ERREURS = REP_ARTICLES + REP_ERREURS;

  REP_CLIENTS         = REP_INTEGRES + '\Clients\';
  REP_CLIENTS_ENCOURS = REP_CLIENTS + REP_ENCOURS;
  REP_CLIENTS_SUCCES  = REP_CLIENTS + REP_SUCCES;
  REP_CLIENTS_ERREURS = REP_CLIENTS + REP_ERREURS;

  ERREURENTETELOT1      = 'Erreur dans l’en-tête du lot n°1. Le fichier ne peut pas être intégré.';
  ATTENTIONENTETELOT1   = 'Avertissement sur l’en-tête du lot n°1.';
  ERREURLIGNELOT1       = 'Erreur lors du chargement du lot n°1 à la ligne n°%0:d. La ligne sera ignorée.';
  ERREURENTETELOT3      = 'Erreur dans l’en-tête du lot n°3. Le fichier ne peut pas être intégré.';
  ERREURLIGNELOT3       = 'Erreur lors du chargement du lot n°3 à la ligne n°%0:d. La ligne sera ignorée.';
  ERREURENTETENOMCHAMP  = sLineBreak + ' - Le champ “%1:s” ne correspond pas au champ “%2:s” présent dans le fichier.';
  ERREURENTETENBCHAMPS  = sLineBreak + ' - Le nombre de champs ne correspond pas.';
  ERREURLIGNENBCHAMPS   = sLineBreak + ' - La ligne ne contient pas le bon nombre de champs.';
  ERREURLIGNECHAMPREQUI = sLineBreak + ' - Le champ “%1:s” requis n’est pas renseigné.';
  ERREURLIGNEMVFORMAT   = sLineBreak + ' - Le champ “%1:s” n’est pas au bon format'#160': %2:s.';
  ERREURLIGNEMODEIMPORT = sLineBreak + ' - Mauvais mode d’import.';
  ERREURLIGNETAILLEEAN  = sLineBreak + ' - Le code-barres transmit n’est pas un code EAN'#160'13'#160': %1:s.';

  // Liste des codes de retours de la procédure stockée d'intégration
{$REGION 'Constantes lot n°1'}
  CR_LOT1_OK                    = 0;
  CR_LOT1_MAUVAIS_MODE          = 1;
  CR_LOT1_ARTICLE_EXISTANT      = 2;
  CR_LOT1_MODELE_INEXISTANT     = 3;
  CR_LOT1_ARTICLE_INEXISTANT    = 4;
  CR_LOT1_CHRONO_EXISTANT       = 5;
  CR_LOT1_MODELE_NON_ARCHIVABLE = 6;
  CR_LOT1_MODELE_DEJA_ARCHIVE   = 7;

  CR_LOT1_CHRONO_MAJ         = 1;
  CR_LOT1_REFMRK_MAJ         = 2 * CR_LOT1_CHRONO_MAJ;
  CR_LOT1_TAILLE_MAJ         = 2 * CR_LOT1_REFMRK_MAJ;
  CR_LOT1_COULEUR_MAJ        = 2 * CR_LOT1_TAILLE_MAJ;
  CR_LOT1_FOURN_MAJ          = 2 * CR_LOT1_COULEUR_MAJ;
  CR_LOT1_TARIF_FOURN_MAJ    = 2 * CR_LOT1_FOURN_MAJ;
  CR_LOT1_MARQUE_MAJ         = 2 * CR_LOT1_TARIF_FOURN_MAJ;
  CR_LOT1_LIST_PRICE_MAJ     = 2 * CR_LOT1_MARQUE_MAJ;
  CR_LOT1_LIST_PRICE_SKU_MAJ = 2 * CR_LOT1_LIST_PRICE_MAJ;
  CR_LOT1_PRIX_WEB_MAJ       = 2 * CR_LOT1_LIST_PRICE_SKU_MAJ;
  CR_LOT1_PRIX_WEB_SKU_MAJ   = 2 * CR_LOT1_PRIX_WEB_MAJ;
  CR_LOT1_TVA_MAJ            = 2 * CR_LOT1_PRIX_WEB_SKU_MAJ;
  CR_LOT1_LIBELLE_MAJ        = 2 * CR_LOT1_TVA_MAJ;
  CR_LOT1_CHANGE_MODE_IMPORT = 2 * CR_LOT1_LIBELLE_MAJ;
  CR_LOT1_ARCHIVAGE_MODELE   = 2 * CR_LOT1_CHANGE_MODE_IMPORT;

  CR_LOT1_MESSAGES: array [CR_LOT1_OK .. CR_LOT1_MODELE_DEJA_ARCHIVE] of string = (
    'Succès',
    'Mauvais mode d’import',
    'Article déjà existant',
    'Modèle inexistant',
    'Article inexistant',
    'Chrono déjà existant sur un autre modèle',
    'Le modèle ne peut pas être archivé',
    'Le modèle a déjà été archivé');

  CR_LOT1_NKL_ERREUR                = -1;
  CR_LOT1_NKL_RIEN                  = 00;
  CR_LOT1_NKL_CREATION              = 01;
  CR_LOT1_NKL_ASSOCIATION           = 10;
  CR_LOT1_NKL_CREATION_ASSOCIATION  = CR_LOT1_NKL_CREATION + CR_LOT1_NKL_ASSOCIATION;
  CR_LOT1_NKL_MODIFICATION          = 20;
  CR_LOT1_NKL_CREATION_MODIFICATION = CR_LOT1_NKL_CREATION + CR_LOT1_NKL_MODIFICATION;
{$ENDREGION 'Constantes lot n°1'}

{$REGION 'Constantes lot n°3'}
  CR_LOT3_ERREUR             = 0;
  CR_LOT3_CREATION           = 1;
  CR_LOT3_MISEAJOUR          = 2;
  CR_LOT3_AUCUNEMODIFICATION = 3;
{$ENDREGION 'Constantes lot n°3'}

resourcestring
{$REGION 'Ressources générales'}
  RS_DEMARRAGE = 'Démarrage du programme.';
  RS_ARRET = 'Arrêt du programme.';
  RS_AUTOMATIQUE = 'Traitement automatique'#133 + sLineBreak
    + 'Dossier'#160': %0:s' + sLineBreak
    + 'Base de données'#160': %1:s';
  RS_ERR_ARRET = 'Arrêt du programme impossible. Une intégration est en cours.' + sLineBreak
    + sLineBreak
    + 'Veuillez attendre que celle-ci soit terminée, ou l’interrompre.';
  RS_CONF_ARRET = 'Voulez-vous réellement interrompre l’intégration en cours'#160'?' + sLineBreak
    + sLineBreak
    + 'Aucune donnée ne sera intégrée dans la base de données.';
  RS_PROGRESSION = 'Progression de l’intégration.';
  RS_CONNEXION = 'Connexion à la base de données'#133;
  RS_DECONNEXION = 'Déconnexion de la base de données'#133;
  RS_CHARGEMENT_DOMAINES = 'Chargement des domaines d’activités'#133;
  RS_PARAMETRES_ENREGISTRES = 'Paramètres enregistrés.';
  RS_NETTOYAGE_JOURNAL = '%0:d fichier d’historique a été mis à la corbeille.';
  RS_NETTOYAGE_JOURNAUX = '%1:d fichiers d’historique ont été mis à la corbeille.';
  RS_VIDANGE = 'Sauvegarde des données chargées dans le fichier'#160':' + sLineBreak
    + '%0:s';
  RS_DEBUT = 'Début de l’intégration.';
  RS_TERMINEE = 'Intégration terminée.';
  RS_ABANDONNEE = 'Intégration interrompue.';
  RS_VALIDE_ERREURS = 'Le fichier sera intégré même s’il comporte des erreurs.';
  RS_CHARGEMENT_FICHIER = 'Chargement du fichier'#160': %0:s';
  RS_TRAITEMENT_FICHIER = 'Traitement du fichier %0:d sur %1:d'#133;

  RS_OUVRIR_ARTICLES = 'Ouvrir un fichier de référentiel article à intégrer'#133;
  RS_OUVRIR_CLIENTS = 'Ouvrir un fichier de clients à intégrer'#133;

  RS_ERREUR = 'Erreur';
  RS_ERREUR_EN_COURS = 'Une instance de cette application est déjà en cours.';
  RS_ERREUR_MOTPASSE = 'Mauvais mot de passe.';
  RS_ERREUR_INTEGRATIONENCOUR = 'Une intégration est déjà en cours.' + sLineBreak
    + 'Veuillez attendre qu’elle soit terminée, ou l’arrêter avant de lancer cette intégration.';
  RS_ERREUR_INTEGRATION = 'Une erreur s’est produite lors de l’intégration de la ligne %0:d. La ligne ne sera pas intégrée.' + sLineBreak
    + ' - (%1:s) [%2:s] %3:s' + sLineBreak
    + ' - %4:s - %5:s.';
  RS_ERREUR_MODIFICATION = 'Une erreur s’est produite lors de la mise à jour pour la ligne %0:d. La ligne ne sera pas intégrée.' + sLineBreak
    + ' - (%1:s) [%2:s] %3:s' + sLineBreak
    + ' - %4:s - %5:s.';
  RS_ERREUR_CONNEXION = 'Une erreur s’est produite lors de la connexion à la base de données.' + sLineBreak
    + ' - %0:s - %1:s.';
  RS_ERREUR_VIDANGE = 'Une erreur s’est produite lors de la sauvegarde des données.' + sLineBreak
    + ' - %0:s - %1:s.';
  RS_ERREUR_FICHIER = 'Le fichier comporte une erreur'#160'! Il ne sera pas intégré.';
  RS_ERREURS_FICHIER = 'Le fichier comporte %d erreurs'#160'! Il ne sera pas intégré.';
  RS_ERREUR_DOSSIER = 'Le dossier n’existe pas.';

  RS_RECHERCHE_TERMINEE = 'La recherche a atteint la fin du document.';
{$ENDREGION 'Ressources générales'}

{$REGION 'Ressources Lot n°1'}
  RS_CHARGEFICHIERLOT1 = 'Chargement du fichier “%0:s” pour le lot n°1'#133;
  RS_CHARGEMENTLOT1 = 'Chargement du lot n°1'#160': Référentiel Articles'#133;
  RS_VERIFICATION_COHERENCE = 'Vérification de la cohérence des EAN à la taille/couleur (étape %0:d/2)'#133;

  RS_ERREURENTETELOT1 = ERREURENTETELOT1;
  RS_ERREURENTETELOT1_NOMCHAMP = ERREURENTETELOT1 + ERREURENTETENOMCHAMP;
  RS_ERREURENTETELOT1_NBCHAMPS = ERREURENTETELOT1 + ERREURENTETENBCHAMPS;
  RS_ATTENTIONENTETELOT1_NBCHAMPS = ATTENTIONENTETELOT1 + ERREURENTETENBCHAMPS;

  RS_ERREURLIGNELOT1 = ERREURLIGNELOT1;
  RS_ERREURLIGNELOT1_NBCHAMPS = ERREURLIGNELOT1 + ERREURLIGNENBCHAMPS;
  RS_ERREURLIGNELOT1_CHAMPREQUI = ERREURLIGNELOT1 + ERREURLIGNECHAMPREQUI;
  RS_ERREURLIGNELOT1_MVFORMAT = ERREURLIGNELOT1 + ERREURLIGNEMVFORMAT;
  RS_ERREURLIGNELOT1_MODEIMPORT = ERREURLIGNELOT1 + ERREURLIGNEMODEIMPORT;
  RS_ERREURLIGNELOT1_TAILLEEAN = ERREURLIGNELOT1 + ERREURLIGNETAILLEEAN;

  RS_ERREURARTICLE_CREATION = 'Erreur lors de la création de l’article à la ligne n°%0:d. L’article ne sera pas intégré.' + sLineBreak
    + ' - %1:s [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)';
  RS_ERREURARTICLE_MODIFICATION = 'Erreur lors de la mise à jour de l’article à la ligne n°%0:d. L’article ne sera pas intégré.' + sLineBreak
    + ' - %1:s [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)';
  RS_ERREURARTICLE_ARCHIVAGE = 'Erreur lors de l’archivage de l’article à la ligne n°%0:d. L’article ne sera pas intégré.' + sLineBreak
    + ' - %1:s [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)';

  RS_AVERTISSEMENTARTICLE_CREATION = 'Avertissement lors de la création de l’article à la ligne n°%0:d.' + sLineBreak
    + ' - %1:s [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)';
  RS_AVERTISSEMENTARTICLE_MODIFICATION = 'Avertissement lors de la mise à jour de l’article à la ligne n°%0:d.' + sLineBreak
    + ' - %1:s [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)';
  RS_AVERTISSEMENTARTICLE_ARCHIVAGE = 'Avertissement lors de l’archivage de l’article à la ligne n°%0:d.' + sLineBreak
    + ' - %1:s [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)';

  RS_ERREURARTICLE_EAN_MANQUANT = 'Erreur lors du chargement d’un modèle. Il manque des EAN pour certaines tailles/couleurs.' + sLineBreak
    + ' - [%0:s] %1:s';
  RS_ERREURARTICLE_TROP_TAILLES = 'Erreur lors du chargement d’un modèle. Il y a trop de tailles existantes. Leur nombre est limité à 26.' + sLineBreak
    + ' - [%0:s] %1:s';
  RS_ERREURARTICLE_TAILLES_DOUBLES = 'Erreur lors du chargement d’un modèle. Ce modèle a des tailles en double.' + sLineBreak
    + ' - [%0:s] %1:s';
  RS_ERREURARTICLE_COULEURS_DOUBLES = 'Erreur lors du chargement d’un modèle. Ce modèle a des couleurs en double.' + sLineBreak
    + ' - [%0:s] %1:s';
  RS_AVERTISSEMENT_ARCHIVE = 'Avertissement lors du chargement d’un modèle. Le modèle est archivé dans Ginkoia. Il ne sera pas mis à jour.' + sLineBreak
    + ' - [%0:s] %1:s';
  RS_ERREUR_ACTIVITE = 'Le domaine d’activité doit être paramétré.';

  RS_LOT1_INTEGRATION = 'Intégration des articles (%0:d/%1:d) [%3:s] %4:s - (UUID'#160': %2:s - MASTER_UUID'#160': %5:s)'#133;

  RS_LOT1_MAJ1 = 'Chrono mis à jour.';
  RS_LOT1_MAJ2 = 'Référence mise à jour.';
  RS_LOT1_MAJ4 = 'Taille mise à jour.';
  RS_LOT1_MAJ8 = 'Couleur mise à jour.';
  RS_LOT1_MAJ16 = 'Fournisseur mis à jour.';
  RS_LOT1_MAJ32 = 'Tarifs fournisseur mis à jour.';
  RS_LOT1_MAJ64 = 'Marque mise à jour.';
  RS_LOT1_MAJ128 = 'Prix de vente conseillé mis à jour.';
  RS_LOT1_MAJ256 = 'Prix de vente conseillé à la taille/couleur mis à jour.';
  RS_LOT1_MAJ512 = 'Prix de vente Web mis à jour.';
  RS_LOT1_MAJ1024 = 'Prix de vente Web à la taille/couleur mis à jour.';
  RS_LOT1_MAJ2048 = 'Taux de TVA mis à jour.';
  RS_LOT1_MAJ4096 = 'Mise à jour du libellé du modèle.';
  RS_LOT1_MAJ8192_C_U = 'L’article a été mis à jour au lieu d’être créé.';
  RS_LOT1_MAJ8192_U_C = 'L’article a été créé au lieu d’être mis à jour.';
  RS_LOT1_MAJ16384 = 'Le modèle a été archivé.';

{$IFDEF DEBUG}
  RS_MSG_LOT1_PREFIX_NKL = '[%1:d] %0:s - %2:s';
  RS_MSG_LOT1_PREFIX_EAN = '[%1:s] %0:s - %2:s';
{$ELSE}
  RS_MSG_LOT1_PREFIX_NKL = '%0:s - %2:s';
  RS_MSG_LOT1_PREFIX_EAN = '%0:s - %2:s';
{$ENDIF}
  RS_MSG_LOT1_NKL = 'Nomenclature';
  RS_MSG_LOT1_NKL_RIEN = 'Rien.';
  RS_MSG_LOT1_NKL_CREATION = 'Nomenclature créée.';
  RS_MSG_LOT1_NKL_ASSOCIATION = 'Modèle associé à la nomenclature existante.';
  RS_MSG_LOT1_NKL_CREATION_ASSOCIATION = 'Nomenclature créée et modèle associé.';
  RS_MSG_LOT1_NKL_MODIFICATION = 'Association du modèle modifiée.';
  RS_MSG_LOT1_NKL_CREATION_MODIFICATION = 'Nomenclature créée et association du modèle modifiée.';
  RS_MSG_LOT1_NKL_ERREUR = 'Erreur.';
  RS_MSG_LOT1_NKL_INCONNU = 'Code de retour inconnu'#160': %d';

  RS_MSG_LOT1_EANP = 'EAN Principal';
  RS_MSG_LOT1_EANF = 'EAN Fournisseur n°%0:d';
  RS_MSG_LOT1_EANP_1 = 'Création de l’EAN principal.';
  RS_MSG_LOT1_EANP_2 = 'EAN principal déjà existant sur un autre article. L’EAN [%0:s] à la ligne n°%1:d ne sera pas intégré.';
  RS_MSG_LOT1_EANP_3 = 'EAN principal non renseigné à la ligne n°%0:d.';
  RS_MSG_LOT1_EANP_4 = 'EAN principal remplacé.';
  RS_MSG_LOT1_EANF_0 = 'Aucune modification EAN fournisseur.';
  RS_MSG_LOT1_EANF_1 = 'Création de l’EAN fournisseur.';
  RS_MSG_LOT1_EANF_2 = 'EAN fournisseur déjà existant sur un autre article. L’EAN [%0:s] à la ligne n°%1:d ne sera pas intégré.';
{$ENDREGION 'Ressources Lot n°1'}

{$REGION 'Ressources lot n°3'}
  RS_CHARGEFICHIERLOT3 = 'Chargement du fichier “%0:s” pour le lot n°3'#133;
  RS_CHARGEMENTLOT3 = 'Chargement du lot n°3'#160': Clients'#133;

  RS_MSG_LOT3_INTEGRATION = 'Intégration des clients (%0:d/%1:d)'#133;
  RS_MSG_LOT3_CREATION = '%0:d/%1:d - Création du client - [%2:s] %3:s %4:s'#133;
  RS_MSG_LOT3_MISEAJOUR = '%0:d/%1:d - Mise à jour du client - [%2:s] %3:s %4:s'#133;
  RS_MSG_LOT3_AUCUNEMODIFICATION = '%0:d/%1:d - Aucune modification du client - [%2:s] %3:s %4:s'#133;
  RS_MSG_LOT3_ERREUR = '%0:d/%1:d - Erreur lors de l’intégration du client - [%2:s] %3:s %4:s'#133;
  RS_MSG_LOT3_INCONNU = 'Code de retour inconnu.';

  RS_MSG_LOT3_PAY = 'Pays';
  RS_MSG_LOT3_PAY0 = 'Pays déjà existant.';
  RS_MSG_LOT3_PAY1 = 'Création du pays.';

  RS_MSG_LOT3_VIL = 'Ville';
  RS_MSG_LOT3_VIL0 = 'Ville déjà existante.';
  RS_MSG_LOT3_VIL1 = 'Création de la ville.';

  RS_MSG_LOT3_ADR = 'Adresse';
  RS_MSG_LOT3_ADR0 = 'Aucune modification de l’adresse.';
  RS_MSG_LOT3_ADR1 = 'Création de l’adresse.';
  RS_MSG_LOT3_ADR2 = 'Mise à jour de l’adresse.';

  RS_MSG_LOT3_CBI = 'Carte de fidélité';
  RS_MSG_LOT3_CBI0 = 'Carte de fidélité non renseignée.';
  RS_MSG_LOT3_CBI1 = 'Création de la carte de fidélité.';
  RS_MSG_LOT3_CBI2 = 'Mise à jour de la carte de fidélité.';
  RS_MSG_LOT3_CBI3 = 'Aucune modification de la carte de fidélité.';
  RS_MSG_LOT3_CBI4 = 'Erreur'#160': la carte de fidélité existe déjà.';

  RS_ERREURENTETELOT3 = ERREURENTETELOT3;
  RS_ERREURENTETELOT3_NOMCHAMP = ERREURENTETELOT3 + ERREURENTETENOMCHAMP;
  RS_ERREURENTETELOT3_NBCHAMPS = ERREURENTETELOT3 + ERREURENTETENBCHAMPS;

  RS_ERREURLIGNELOT3 = ERREURLIGNELOT3;
  RS_ERREURLIGNELOT3_NBCHAMPS = ERREURLIGNELOT3 + ERREURLIGNENBCHAMPS;
  RS_ERREURLIGNELOT3_CHAMPREQUI = ERREURLIGNELOT3 + ERREURLIGNECHAMPREQUI;
  RS_ERREURLIGNELOT3_MVFORMAT = ERREURLIGNELOT3 + ERREURLIGNEMVFORMAT;

{$ENDREGION 'Ressources lot n°3'}

{$REGION 'Ressources courriels'}
  RS_COURRIEL_OBJET_SUCCES = '[%0:s] Intégrations DataSolution automatique réussie';
  RS_COURRIEL_OBJET_AVERTISSEMENT = '[%0:s] Intégrations DataSolution automatique réussie avec des avertissements';
  RS_COURRIEL_OBJET_ERREUR = '[%0:s] Intégrations DataSolution automatique en erreur';
  RS_COURRIEL_ENTETE_SUCCES = 'Chère utilisatrice, cher utilisateur,' + sLineBreak
    + sLineBreak
    + 'L''intégration des fichiers s''est terminée sans erreur.' + sLineBreak
    + sLineBreak
    + '%0:s '
    + sLineBreak
    + sLineBreak
    + 'Vous trouverez le journal d''intégration en pièce-jointe.'
    + sLineBreak
    + sLineBreak;
  RS_COURRIEL_ENTETE_AVERTISSEMENT = 'Chère utilisatrice, cher utilisateur,' + sLineBreak
    + sLineBreak
    + 'L''intégration des fichiers s''est terminée avec des avertissements.' + sLineBreak
    + sLineBreak
    + 'Liste des fichiers ayant posé problème'#160':' + sLineBreak
    + sLineBreak
    + '%0:s' + sLineBreak
    + sLineBreak
    + 'Veuillez consulter le journal d''intégration en pièce-jointe, afin d''en savoir plus.' + sLineBreak
    + sLineBreak;
  RS_COURRIEL_ENTETE_ERREUR = 'Chère utilisatrice, cher utilisateur,' + sLineBreak
    + sLineBreak
    + 'L''intégration des fichiers a rencontré des erreurs.' + sLineBreak
    + sLineBreak
    + 'Liste des fichiers en erreur'#160':' + sLineBreak
    + sLineBreak
    + '%0:s' + sLineBreak
    + sLineBreak
    + 'Veuillez consulter le journal d''intégration en pièce-jointe, afin d''en savoir plus.'
    + sLineBreak
    + sLineBreak;
  RS_COURRIEL_PIED = 'Nous vous souhaitons une bonne journée,' + sLineBreak
    + sLineBreak
    + '%0:s';
  RS_COURRIEL_ERREUR = 'Un erreur s’est produite lors de l’envoi du courriel.' + sLineBreak
    + sLineBreak + '%0:s'#160': %1:s';
  RS_COURRIEL_FICHIER = '%0:d fichier a été intégré.';
  RS_COURRIEL_FICHIERS = '%0:d fichiers ont été intégrés.';
{$ENDREGION 'Ressources courriels'}

implementation

end.

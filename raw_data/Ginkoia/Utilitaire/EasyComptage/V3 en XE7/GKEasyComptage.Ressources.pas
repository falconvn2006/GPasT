unit GKEasyComptage.Ressources;

interface

const
  DELIMITER : Char        = ';';
  RS_ERR_QUITTER          = 'Le programme va se fermer.';
  NBESSAIS_DEFAUT         = 60;
  DELAIS_DEFAUT           = 60 * 1000;

resourcestring
  RS_INF_DEMARRAGE        = 'Démarrage du programme.';
  RS_INF_ARRET            = 'Arrêt du programme.';
  RS_INF_TEST             = 'Programme lancé en mode TEST.';
  RS_INF_PARAM            = 'Programme lancé en mode PARAM.';
  RS_INF_CONNECTE         = 'Connecté';
  RS_INF_DECONNECTE       = 'Déconnecté';
  RS_INF_TH_TRAIT_D       = 'Démarrage du thread de traitement.';
  RS_INF_TH_TRAIT_F       = 'Fin du thread de traitement.';
  RS_INF_TH_TRAIT_S       = 'Traitement effectué avec succès.';
  RS_INF_TH_TRAIT_E       = 'Traitement en erreur.';
  RS_INF_CONNEXION        = 'Connexion à la base de données réussie.';
  RS_ERR_CONNEXION        = 'Erreur de connexion à la base de données.';
  RS_ERR_TRAITEMENT       = 'Un autre traitement bloque la connexion à la base de données.';
  RS_ERR_PARAM_INI        = 'Erreur de lecture du fichier d’initialisation.'#13#10#13#10 + RS_ERR_QUITTER;
  RS_ERR_PARAM_BASE       = 'Erreur lors du chargement des paramètres.'#13#10#13#10 + RS_ERR_QUITTER;
  RS_ERR_PARAM_MAG        = 'Erreur dans l’identifiant magasin'#160': %d.';
  RS_ERR_PARAM_GENPARAM   = 'Les paramètres d’EasyComptage n’existent pas dans GENPARAM.';
  RS_ERR_PARAM_MODULE     = 'Vous n’avez pas le module nécessaire pour exécuter cette application.'#13#10#13#10 + RS_ERR_QUITTER;
  RS_ERR_PARAM_ENREG      = 'Erreur lors de l’enregistrement des paramètres dans la base.';
//  RS_ERR_PARAM_ENREG_EXC  = 'Erreur lors de l’enregistrement des données %d'#160': %s - %s.';
  RS_ERR_BARRE_STATUS     = 'Erreur (%d/%d)'#160': %s - %s';

  RS_ERR_REQUETE_CODEADH  = 'Attention :  le magasin en cours (%s) n’a pas de code adhérent !' + #13#10 + 'C''est une information obligatoire.';

  RS_INFO_TACHE_CREER_D   = 'Début de la création de la tâche planifiée.';
  RS_INFO_TACHE_CREER_F   = 'Fin de la création de la tâche planifiée.';
  RS_INFO_TACHE_SUPPR_D   = 'Début de la suppression de la tâche planifiée.';
  RS_INFO_TACHE_SUPPR_F   = 'Fin de la suppression de la tâche planifiée.';
  RS_INFO_DEMAR_CREER_D   = 'Début de la création du démarrage automatique.';
  RS_INFO_DEMAR_CREER_F   = 'Fin de la création du démarrage automatique.';

  RS_INFO_TRAITEMENT      = 'Traitement en cours...';
  RS_INFO_TRAIT_PROCHAIN  = 'Prochain traitement prévu à %s.';
  RS_INFO_EN_COURS        = 'L’application est toujours en cours d’exécution.'#13#10
                          + 'Double-cliquez sur cette icône pour la réafficher.';
  RS_QUES_QUITTER         = 'Voulez-vous vraiment quitter l’application'#160'?';

  RS_LIB_TITRE            = 'EasyComptage Export - %s';
  RS_LIB_ARRET            = 'Arrêt du traitement à %s';

implementation

end.

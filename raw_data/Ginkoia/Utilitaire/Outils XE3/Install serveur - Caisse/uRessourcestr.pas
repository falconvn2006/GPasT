{$REGION 'Documentation'}
/// <summary>
/// Resource strings
/// </summary>
{$ENDREGION}
unit uRessourcestr;

interface

CONST
  RST_BADCODE = 'Le code client n''est pas conforme';
  RST_GINKOIA_EXISTS = 'Un répertoire Ginkoia existe déjà' + #10 + 'Voulez-vous continuer ?';
  RST_STOP = 'Arrêter';
  RST_INSTALL = 'Installer';
  RST_FILE = 'Fichier à installer';
  RST_URL = 'Url de chargement';
  RST_DATABASE = 'Interrogation de la base de données';
  RST_NOTCONNECTED = 'La base n''est pas connectée';
  RST_CONFIRM = 'Confirmez-vous l''installation du serveur';
  RST_CLIENT = 'du client: ';
  RST_CODE = 'code :';
  RST_VILLE = 'ville :';
  RST_ERROR_UNZIP = 'Une erreur s''est produite lors de l''extraction du fichier';
  RST_ERROR_UNZIP2 = ' Voulez-vous';
  RST_RETRY = 'Réessayer';
  RST_IGNORE = 'Erreur ignorée';
  RST_CANCEL = 'Opération annulée';
  RST_LOG_FILE = 'GINKOIA-INSTALLATION.txt';
  RST_ERROR_CODE = 'Le code saisi ne correspond pas';
  RST_NOCODE = 'Aucune base ne correspond au code indiqué';
  RST_DOWNLOAD = 'Chargement';
  RST_ERROR_UNZIP3 = 'Une erreur s''est produite lors de l''installation' + #10 + 'Le processus est abandonné';
  RST_ERROR_PATH = 'Les chemins d''installation doivent être renseignés correctement';
  RST_ERROR_INSTALLFROMSERVER = 'Les paramètres d''installation depuis le serveur Easy ne sont pas corrects, veuillez vérifier les paramètres';
  RST_ERROR_INSTALLFROMLOCAL = 'Les paramètres de la base locale ne sont pas bons ou ne peuvent être trouvés dans la base du serveur';
  RTS_ERROR_COPYGINKOIAFROMSERVER = 'Erreur lors de la copie des fichiers depuis le serveur';
  RTS_ERROR_BACKUPBASE = 'Impossible de faire le backup de la base locale';
  RTS_ERROR_DEZIP = 'Erreur lors du DEZIP du fichier de version';
  RTS_ERROR_DEPERSOBASE = 'Erreur lors de la dépersonnalisation de la base : ';
  RTS_ERROR_RECUPBASE = 'Erreur lors du récupbase : ';
  RTS_INTERRUPTIONMANU = 'Installation interrompue par l''utilisateur';

  RST_ERROR_REFERENCEMENT = 'Une erreur s''est produite lors du référencement';

  RST_ERROR_BPL = 'Une erreur s''est produite lors de l''initialisation du chemin BPL';
  RST_ERROR_BDD = 'Une erreur s''est produite lors de la connexion à la base de données';
  RST_HINT_DOWNLOAD = 'Charger le fichier';
  RST_HINT_STOPDOWNLOAD = 'Cliquez ici pour arrêter le chargement';
  RST_HINT_OPENFILE = 'Sélectionner le fichier à installer';
  RST_NOFILE = 'Aucun fichier disponible sur la lame, vérifiez la connecxion';
  RST_RECUPBASE_ECHEC = 'Une erreur s''est produite dans la récupérationde la base';
  RST_RECUPBASE_NOINI = 'Voulez-vous récupérer le fichier InitParams ?';

  RST_NOXMLFILE = 'Le fichier Deploiement.xml n''a pas été initialisé ou déployé';
  RST_RESTEACHARGER = 'reste à charger : ';
  RST_URLHINT = 'Télécharger le fichier';

  RST_DOWNLOADRL = 'Chargement de l''url ';
  RST_ENDOFDOWNLOAD = 'Fin du chargement';
  RST_STOPPEDBYUSER = 'Chargement interrompu par l''uilisateur';
  RST_ZIPSTOPPEDBYUSER = 'L''installation a été interrompue par l''utilisateur';
  RST_UNZIP = 'Décompression du fichier';
  RST_CONFIRMED = 'Installation confirmée';
  RST_NOTCONFIRMED = 'Installation non confirmée';

  RST_NOGINKOIA = 'Le chemin d''installation de Ginkoia en local n''est pas valide';
  RST_SERVER = ' Serveur de la base de données : ';
  RST_GINKOIA = ' Chemin d''installation de Ginkoia : ';
  RST_AKOI = ' connexion à la base ';
  RST_CONNECTED = 'Base connectée';
  RST_MAG = ' Magasin : ';
  RST_POSTE = ' Poste : ';

  RST_NOBASE = 'Le fichier n''existe pas';
  RST_BADEXTENSION = 'Ce type de fichier n''est pas traité';
  RST_FILENOTFOUND = 'Le fichier Ginkoia.IB n''a pas été trouvé';

  RST_BASETEST = 'Création de la base test sur  ';
  RST_CANCELBASETEST = 'Abandon de la création de la base test';
  RST_NOCONNECTED = 'Erreur de connexion à la base de données';

  // easy
  RST_ERROR_EASYDEPLOY = 'Impossible de trouver l''exe de déploiement de Easy';
  RST_ERROR_INSTALLEASY = 'Une erreur s''est produite lors de l''installation d''EASY, veuillez contacter Ginkoia';
  RST_ERROR_INSTALLEASY2 = 'Une erreur s''est produite lors des GRANTS dans la base de données, veuillez contacter Ginkoia ';
  RST_ERROR_EASYSPLIT = 'Impossible de trouver le fichier Split pour l''installation de Easy';
  RST_EASYSUCCESS = 'Installation de Easy terminée avec succès';
  RST_EASY_CONFIRM_BASE_LOCALE = 'La base locale va être remplacée et ne sera plus utilisable,' + #10 + 'les données qui n''ont pas été répliquées seront définitivement perdues';
  RST_EASY_DELETE_BASE_LOCALE = 'Installation terminée avec succès. ' + #10 + 'Voulez vous supprimer la sauvegarde l''ancienne base de données ?';
  RST_ERROR_EASY_SOURCES = 'Impossible de trouver les fichiers sources d''Easy dans le répertoire sélectionné.' + #10 + ' Les fichiers "EasyDeploy.exe", "Java.7z" et "symmetric-pro-3.7.36-setup.jar" doivent être présent';
  RTS_ERROR_FINDINGUDF = 'Impossible de trouver le répertoire d''installation des UDF d''Interbase sur C: ou D:';
  RTS_ERRORPUTUDF = 'Impossible de transférer les UDF Easy dans le répertoire d''Interbase.' + #13#10 + 'Cliquez sur Ok une fois la copie effectuée, ou annuler pour annuler l''installation';
  RTS_ERRORFINDFILE = 'Installation d''Easy : Impossible de trouver le fichier : %s';

  RST_NOAMAJ = 'Impossible de créer le répertoire "GINKOIA\A_MAJ\", veuillez le créer manuellement';
  ERROROPENKEY = 'Erreur d''ouverture de la clef des registres';
  ERRORNOBASE = 'La base Ginkoia n''a pas été trouvée';

  GINKOIA = 'Ginkoia.exe';
  CAISSE = 'CaisseGinkoia.exe'; // 'Caisse~1.exe';
  LAUNCHER = 'LaunchV7.exe';
  LAUNCHEREASY = 'LauncherEASY.exe';
  GINKOIABatD = 'GinkoiaD.bat';
  GINKOIABat = 'Ginkoia.bat';
  CAISSESECOUR = 'CaisseSecoursGinkoia.exe';
  VERIFICATION = 'Verification.exe';

  IBAdminUser = 'SYSDBA';
  IBAdminPwd = 'masterkey';

  NameFileParam = 'Deploiement.ini';
  NameVersion = 'Deploy-Version.ini';

  UsrISF = 'Nosymag';
  UsrGin = 'Ginkoia';



implementation

end.

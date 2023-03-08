unit uResTPE;

interface

ResourceString
  TXT_ComOuvert  = 'Ouvert';     // 1
  TXT_ComInconnu = 'Inconnu';    // -1
  TXT_ComFerme   = 'Fermé';      // 0

  ParitePaire   = 'Paire';
  PariteImpaire = 'Impaire';
  PariteAucune  = 'Aucune';
  PariteMarque  = 'Marque';
  PariteEspace  = 'Espace';

  TXT_Erreur = 'Erreur';

  ERR_COM_ErreurNoCom  = 'Erreur de N° de port COM';
  ERR_COM_Vitesse      = 'Erreur de vitesse du Port COM';
  ERR_COM_BitDonnee    = 'Erreur du bit de données du port COM';
  ERR_COM_Parite       = 'Erreur de la parité du port COM';
  ERR_COM_BitArret     = 'Erreur du bit d''arrêt du port COM';
  ERR_COM_OuvertureCom = 'Erreur ouverture du port COM';

  ERR_NumeroPortInvalide = 'Numéro de port COM invalide !';

  ERR_ChaineVide         = 'Veuillez Saisir une chaine de recherche pour l''auto détection';

  TXT_Trans_TestPresence = 'Test présence TPE';
  TXT_Trans_Debit        = 'Débit :  %s';
  TXT_Trans_Credit       = 'Crédit :  %s';
  TXT_Trans_Annulation   = 'Annulation :  %s';
  TXT_Trans_Duplicata    = 'Duplicata :  %s';
  TXT_Trans_Cheq         = 'Chèque :  %s';

  ERR_Trans_Param_Invalide         = 'Paramètre invalide';        // 1
  ERR_Trans_Param_NoCaisseInvalide = 'N° de caisse invalide';     // 2
  ERR_Trans_Param_MntInvalide      = 'Montant invalide';          // 3

  ERR_Trans_PortCOM = 'Erreur ouverture port COM';

  ERR_Trans_TPE_TimeOut = 'Délai dépassé';                        // 1

implementation

end.

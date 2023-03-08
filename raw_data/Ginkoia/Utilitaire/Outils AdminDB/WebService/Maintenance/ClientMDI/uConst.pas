unit uConst;

interface

Const
  cActionModify    = 0;   //SR : Liste des actions possible.
  cActionInsert    = 1;
  cActionDelete    = 2;

  cRC = #13#10;
  cNameMain = 'Maintenance Ginkoia';
  cNameGestClient = 'Gestion des clients';
  cStart = 'StartConnexion';
  cWSStarted = 'Web service : Started';
  cConnexionOk = 'Url : Ok';
  cConnexionNotOk = 'Url : Erreur';
  cLibTimeValues = 'Les données datent du %s à %s';
  cPlage = '[%sM_%sM]';
  cSuffSrvSec = '_SYNC';
  cConfirmDelete = 'Voulez-vous supprimer ?';
  cCountRec = '%s/%s enregistrement(s)';
  cDefaultDelayRefreshValues = 300000; { 5 minutes }
  cNOYES: array[0..1] of String = ('NON', 'OUI');
  cListMAG_NATURE: array[0..3] of String = ('Aucune', 'Magasin', 'Plate-Forme', 'Bureau');


implementation

end.

unit uStatusMessage;

interface

type
  { Encapsulation des status avec leurs messages }
  RStatusMessage = Record
    Code:Integer;
    AMessage:String;
  end;

const
  cRC = #13#10;

  { Code = 0 : Ok }
  SM_OK: RStatusMessage = (Code: 0; AMessage: 'OK');

  { Code < 0 : Exception }
  SM_ERREUR_INTERNE: RStatusMessage = (Code: -1; AMessage: 'Erreur interne');


  { Code > 0 : Message standard }
  SM_PathDBMissing: RStatusMessage = (Code: 10; AMessage: 'Chaine de connexion vide');
  SM_PathNotFound: RStatusMessage = (Code: 20; AMessage: 'Dossier introuvable.');
  SM_ObjNotFound: RStatusMessage = (Code: 30; AMessage: 'l''Objet de type [%s] est introuvable.');
  SM_NotResult: RStatusMessage = (Code: 40; AMessage: 'Aucun résultat trouvé.');

implementation

end.

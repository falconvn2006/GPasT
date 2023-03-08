unit uConst;

interface

Const
  cRC = #13#10;

  cSqlInsertClient =  'INSERT INTO CLIENTS (' + cRC +
                      'CLI_IDETO' + cRC +
                      ',CLI_NUMCARTE' + cRC +
                      ',CLI_ENSID' + cRC +
                      ',CLI_DTVAL' + cRC +
                      ',CLI_CODECLUB' + cRC +
                      ',CLI_CIV' + cRC +
                      ',CLI_NOM' + cRC +
                      ',CLI_PRENOM' + cRC +
                      ',CLI_ADR1' + cRC +
                      ',CLI_ADR2' + cRC +
                      ',CLI_ADR3' + cRC +
                      ',CLI_ADR4' + cRC +
                      ',CLI_CP' + cRC +
                      ',CLI_VILLE' + cRC +
                      ',CLI_CODEPAYS' + cRC +
                      ',CLI_TEL1' + cRC +
                      ',CLI_TEL2' + cRC +
                      ',CLI_DTNAISS' + cRC +
                      ',CLI_CODEPROF' + cRC +
                      ',CLI_AUTRESP' + cRC +
                      ',CLI_BLACKLIST' + cRC +
                      ',CLI_EMAIL' + cRC +
                      ',CLI_DTCREATION' + cRC +
                      ',CLI_TOPSAL' + cRC +
                      ',CLI_CODERFM' + cRC +
                      ',CLI_OPTIN' + cRC +
                      ',CLI_OPTINPART' + cRC +
                      ',CLI_MAGORIG' + cRC +
                      ',CLI_TOPNPAI' + cRC +
                      ',CLI_TOPVIB' + cRC +
                      ',CLI_REMRENOUV' + cRC +
                      ',CLI_DTSUP' + cRC +
                      ',CLI_DTRENOUV' + cRC +
                      ',CLI_CREATION' + cRC +
                      ',CLI_MAGCREA' + cRC +
                      ',CLI_MODIF' + cRC +
                      ',CLI_MAGMODIF' + cRC +
                      ',CLI_DTMODIF' + cRC +
                      ',CLI_TOPVIBUTIL' + cRC +
                      ',CLI_QAADRESSE' + cRC +
                      ',CLI_QAMAIL' + cRC +
                      ',CLI_TYPEFID' + cRC +
                      ',CLI_CSTTEL' + cRC +
                      ',CLI_CSTMAIL' + cRC +
                      ',CLI_CSTCGV' + cRC +
                      ',CLI_DESACTIVE' + cRC +
                      ') VALUES (' + cRC +
                      ':PCLI_IDETO' + cRC +
                      ',:PCLI_NUMCARTE' + cRC +
                      ',:PCLI_ENSID' + cRC +
                      ',:PCLI_DTVAL' + cRC +
                      ',:PCLI_CODECLUB' + cRC +
                      ',:PCLI_CIV' + cRC +
                      ',:PCLI_NOM' + cRC +
                      ',:PCLI_PRENOM' + cRC +
                      ',:PCLI_ADR1' + cRC +
                      ',:PCLI_ADR2' + cRC +
                      ',:PCLI_ADR3' + cRC +
                      ',:PCLI_ADR4' + cRC +
                      ',:PCLI_CP' + cRC +
                      ',:PCLI_VILLE' + cRC +
                      ',:PCLI_CODEPAYS' + cRC +
                      ',:PCLI_TEL1' + cRC +
                      ',:PCLI_TEL2' + cRC +
                      ',:PCLI_DTNAISS' + cRC +
                      ',:PCLI_CODEPROF' + cRC +
                      ',:PCLI_AUTRESP' + cRC +
                      ',:PCLI_BLACKLIST' + cRC +
                      ',:PCLI_EMAIL' + cRC +
                      ',:PCLI_DTCREATION' + cRC +
                      ',:PCLI_TOPSAL' + cRC +
                      ',:PCLI_CODERFM' + cRC +
                      ',:PCLI_OPTIN' + cRC +
                      ',:PCLI_OPTINPART' + cRC +
                      ',:PCLI_MAGORIG' + cRC +
                      ',:PCLI_TOPNPAI' + cRC +
                      ',:PCLI_TOPVIB' + cRC +
                      ',:PCLI_REMRENOUV' + cRC +
                      ',:PCLI_DTSUP' + cRC +
                      ',:PCLI_DTRENOUV' + cRC +
                      ',:PCLI_CREATION' + cRC +
                      ',:PCLI_MAGCREA' + cRC +
                      ',:PCLI_MODIF' + cRC +
                      ',:PCLI_MAGMODIF' + cRC +
                      ',:PCLI_DTMODIF' + cRC +
                      ',:PCLI_TOPVIBUTIL' + cRC +
                      ',:PCLI_QAADRESSE' + cRC +
                      ',:PCLI_QAMAIL' + cRC +
                      ',:PCLI_TYPEFID' + cRC +
                      ',:PCLI_CSTTEL' + cRC +
                      ',:PCLI_CSTMAIL' + cRC +
                      ',:PCLI_CSTCGV' + cRC +
                      ',:PCLI_DESACTIVE' + cRC +
                      ')';

  cSqlInsertPoints =  'INSERT INTO POINTS (' + cRC +
                      'PTS_NBPOINTS' + cRC +
                      ',PTS_DATE' + cRC +
                      ',PTS_ENSID' + cRC +
                      ',PTS_NUMCARTE' + cRC +
                      ') VALUES (' + cRC +
                      ':PPTS_NBPOINTS' + cRC +
                      ',:PPTS_DATE' + cRC +
                      ',:PPTS_ENSID' + cRC +
                      ',:PPTS_NUMCARTE' + cRC +
                      ')';

  cSqlUpdatePoints =  'UPDATE POINTS SET' + cRC +
                      'PTS_NBPOINTS=:PPTS_NBPOINTS' + cRC +
                      ',PTS_DATE=:PPTS_DATE' + cRC +
                      ',PTS_ENSID=:PPTS_ENSID' + cRC +
                      'WHERE' + cRC +
                      'PTS_NUMCARTE=:PPTS_NUMCARTE';


resourcestring
  rs_ProcessTerminate = 'Traitement éffectué.';

  rs_PW_KeyMISMATCH = 'La clé n''est pas conforme.';
  rs_PW_DateTimeOudated = 'La date ou l''heure sont périmées.';

  rs_QryResult_OverTake = 'Trop de résultats, précisez les critères.';
  rs_QryResult_NotFound = 'Aucun résultat, précisez les critères.';
  rs_QryResult_NODATA = 'Aucune donnée.';

  rs_FieldMissing_EnteteMsg = 'La liste des champs manquants sont les suivants :';
  rs_FieldMissing_ENSID = 'Centrale';
  rs_FieldMissing_NUMCARTE = 'Numéro de carte';
  rs_FieldMissing_NOM = 'Nom du client';
  rs_FieldMissing_MAGORIG = 'Code magasin';
  rs_FieldMissing_ADR = 'Adresse du client';
  rs_FieldMissing_CP = 'Code postal du client';
  rs_FieldMissing_VILLE = 'Ville du client';
  rs_FieldMissing_CODEPAYS = 'Code pays du client';
  rs_FieldMissing_NUMTICKET = 'Numéro de ticket';
  rs_FieldMissing_DATE = 'Date';
  rs_FieldMissing_NUMBON = 'Numéro de bon';

  rs_MESS_CardNotfound = 'La carte %s est inconnue.';
  rs_MESS_ClientNotfound = 'Le client est introuvable.';
  rs_MESS_ClientDelete = 'Ce client est supprimé.';
  rs_MESS_ClientDisabled = 'La carte %s n''est plus valide, veuillez utiliser la nouvelle carte.';
  rs_MESS_BonValide = 'Le bon repris est valide';
  rs_MESS_BonDejaUtilise = 'Bon déjà utilisé';
  rs_MESS_BonPerime = 'Bon périmé';
  rs_MESS_BonNonTrouve = 'Bon introuvable';
  rs_MESS_UpdatePalierNonAutorise = 'La modification de palier n''est pas autorisé sur cette centrale.';
  rs_MESS_PalierExist = 'Un palier existe déjà.';

  rs_MESS_FileNotFound = 'Le fichier est introuvable dans %s.';
  rs_MESS_StructureFiledNotFound = 'La structure des champs est introuvable dans le fichier de configuration.';
  rs_MESS_FileImportClientExtensionFailed = 'L''extension %s du fichier d''import client est inconnue.';
  rs_MESS_ErrorSystem = 'Erreur dans %s';
  rs_MESS_ImportNbFieldFailed = 'Le nombre de champs n''est pas conforme.';
  rs_MESS_undeletable = 'Suppression impossible, le client est introuvable.';
  rs_MESS_LAnalyseDuFichierComporteDesErreurs = 'L''analyse du fichier %s comporte %d erreurs, %d avertissements';
  rs_MESS_DateTraitement = 'Date du traitement : %s';
  rs_MESS_TempsTraitement = 'Temps de traitement : %s';

implementation

end.

unit uConst;

interface

uses
  SysUtils;

Const
  cActionModify = 0;   //SR : Liste des actions possible.
  cActionInsert = 1;
  cActionDelete = 2;

  cPrUpdateK_Mvt  = 0;  //Mouvementer K
  cPrUpdateK_Sup  = 1;  //Supprimer K
  cPrUpdateK_Act  = 2;  //Réactiver K

  cRC = #13#10;
  cVersionRef = '11.3.0.9999';
  cIntervalPlage = 40;
  cPlage = '[%sM_%sM]';
  cFormatD = 'mm/dd/yyyy';
  cFormatDSeparator = '/';
  cFormatDT = 'mm/dd/yyyy hh:nn:ss';
  cFormatT = 'hh:nn:ss';
  cFormatTSeparator = ':';

  FormatSettings : TFormatSettings = (
    DateSeparator:    cFormatDSeparator;
    TimeSeparator:    cFormatTSeparator;
    ShortDateFormat:  cFormatD;
    LongTimeFormat:   cFormatT;
  );

  { Liste des fields pour les flux Xml }
  cFieldsEmetteurByDossier =  'EMET_ID' + cRC +
                              'EMET_GUID' + cRC +
                              'EMET_NOM' + cRC +
                              'EMET_DONNEES' + cRC +
                              'EMET_DOSSID' + cRC +
                              'EMET_INSTALL' + cRC +
                              'EMET_MAGID' + cRC +
                              'EMET_VERSID' + cRC +
                              'VERS_VERSION' + cRC +
                              'EMET_PATCH' + cRC +
                              'EMET_VERSION_MAX' + cRC +
                              'EMET_SPE_PATCH' + cRC +
                              'EMET_SPE_FAIT' + cRC +
                              'EMET_BCKOK' + cRC +
                              'EMET_DERNBCK' + cRC +
                              'EMET_RESBCK' + cRC +
                              'EMET_TIERSCEGID' + cRC +
                              'EMET_TYPEREPLICATION' + cRC +
                              'EMET_NONREPLICATION' + cRC +
                              'EMET_DEBUTNONREPLICATION' + cRC +
                              'EMET_FINNONREPLICATION' + cRC +
                              'EMET_SERVEURSECOURS' + cRC +
                              'EMET_IDENT' + cRC +
                              'EMET_JETON' + cRC +
                              'EMET_PLAGE' + cRC +
                              'EMET_H1' + cRC +
                              'EMET_HEURE1' + cRC +
                              'EMET_H2' + cRC +
                              'EMET_HEURE2' + cRC +
                              'BAS_NOM' + cRC +
                              'BAS_SENDER' + cRC +
                              'BAS_CENTRALE' + cRC +
                              'BAS_NOMPOURNOUS' + cRC +
                              'LAU_ID' + cRC +
                              'LAU_AUTORUN' + cRC +
                              'LAU_BACK' + cRC +
                              'LAU_BACKTIME' + cRC +
                              'PRM_POS' + cRC +
                              'RTR_PRMID_NBESSAI' + cRC +
                              'RTR_NBESSAI' + cRC +
                              'RTR_PRMID_DELAI' + cRC +
                              'RTR_DELAI' + cRC +
                              'RTR_PRMID_HEUREDEB' + cRC +
                              'RTR_HEUREDEB' + cRC +
                              'RTR_PRMID_HEUREFIN' + cRC +
                              'RTR_HEUREFIN' + cRC +
                              'RTR_PRMID_URL' + cRC +
                              'RTR_URL' + cRC +
                              'RTR_PRMID_SENDER' + cRC +
                              'RTR_SENDER' + cRC +
                              'RTR_PRMID_DATABASE' + cRC +
                              'RTR_DATABASE' + cRC +
                              'RW_PRMID_HEUREDEB' + cRC +
                              'RW_HEUREDEB' + cRC +
                              'RW_PRMID_HEUREFIN' + cRC +
                              'RW_HEUREFIN' + cRC +
                              'RW_PRMID_INTERORDRE' + cRC +
                              'RW_INTERVALLE' + cRC +
                              'RW_ORDRE' + cRC +
                              'EMET_BASID_GINKOIA' + cRC +
                              'BAS_GUID';

  cFieldsEmetteurByServeur =  'EMET_DOSSID' + cRC +
                              'DOSS_DATABASE' + cRC +
                              'EMET_ID' + cRC +
                              'EMET_NOM' + cRC +
                              'EMET_HEURE1' + cRC +
                              'EMET_H1' + cRC +
                              'EMET_HEURE2' + cRC +
                              'EMET_H2' + cRC +
                              'EMET_INFOSUP' + cRC +
                              'EMET_GUID' + cRC +
                              'BAS_GUID';

  cFieldsSociete =  'SOC_ID' + cRC +
                    'SOC_NOM' + cRC +
                    'SOC_CLOTURE' + cRC +
                    'SOC_SSID' + cRC +
                    'SOC_K';

  cFieldsMagasin =  'MAGA_ID' + cRC +
                    'MAGA_NOM' + cRC +
                    'MAG_SOCID' + cRC +
                    'MAG_IDENT' + cRC +
                    'MAG_K' + cRC +
                    'MAGA_ENSEIGNE' + cRC +
                    'MAG_IDENTCOURT' + cRC +
                    'MAGA_MAGID_GINKOIA' + cRC +
                    'MAG_NATURE' + cRC +
                    'MAG_SS' + cRC +
                    'MPU_GCPID' + cRC +
                    'MAGA_CODEADH' + cRC +
                    'MAGA_BASID';

  cFieldsPoste =  'POST_ID' + cRC +
                  'POST_POSID' + cRC +
                  'POST_MAGAID' + cRC +
                  'POST_NOM' + cRC +
                  'POST_INFO' + cRC +
                  'POST_COMPTA' + cRC +
                  'POST_PTYPID' + cRC +
                  'POST_DATEC' + cRC +
                  'POST_DATEM' + cRC +
                  'POST_ENABLE' + cRC+
                  'POST_MAGID' + cRC +
                  'POST_K';

  cFieldsSteMagPoste = 'DOSS_ID' + cRC +
                       cFieldsSociete + cRC +
                       cFieldsMagasin + cRC +
                       cFieldsPoste;

  cFieldsGrpPump = 'DOSS_ID' + cRC +
                   'GCP_ID' + cRC +
                   'GCP_NOM';

  cFieldsSuiviEmetteur = 'EMET_ID' + cRC +
                         'EMET_NOM' + cRC +
                         'EMET_DOSSID' + cRC +
                         'EMET_VERSID' + cRC +
                         'EMET_BCKOK' + cRC +
                         'EMET_DERNBCK' + cRC +
                         'EMET_RESBCK' + cRC +
                         'EMET_NONREPLICATION' + cRC +
                         'EMET_TYPEREPLICATION' + cRC +
                         'EMET_HEURE1' + cRC +
                         'EMET_HEURE2' + cRC +
                         'HDBM_CYCLE' + cRC +
                         'HDBM_OK' + cRC +
                         'HDBM_COMENTAIRE' + cRC +
                         'RAIS_NOM' + cRC +
                         'DOSS_DATABASE' + cRC +
                         'DOSS_VIP' + cRC +
                         'SERV_ID' + cRC +
                         'SERV_NOM';

  cSqlSuiviServeur = '';
  cSqlSuiviPortableEtPortableSynchro = '';
  cSqlSuiviVIP = '';

  cPathSuiviSvr = '\\%s\%s';
  cFileSearchSuiviSvr = 'DelosQPMAgent.dll';
  cSyncSVR = 'SYNCSVR';
  cSyncDOS = 'SYNCDOS';
  cSyncRECYCLEDATAWS = 'RECYCLEDATAWS';

  cFolderDATA = '\DATA';
  cDB_FileName_GINKOIA = 'GINKOIA.IB';

  cTypeSplit: array[0..1] of String = ('RECUP', 'SPLIT');

Type
  TStatutRecupBase = (srbStandby, srbStarted, srbTerminate, srbError);
  TPriorityOrdre = (poUp, poDown);
  TStatutPkg = (spDisponible, spTraite);

implementation

end.

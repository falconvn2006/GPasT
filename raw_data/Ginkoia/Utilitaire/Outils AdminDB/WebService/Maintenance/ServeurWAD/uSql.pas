unit uSql;

interface

Const
  cRC = #13#10;

  { Requetes Sql pour le modele Maintenance }
  cSql_S_LoadListSteMagPosteToDossier = 'SELECT kste.k_id as kste,' + cRC +
                                               'kmag.k_id as kmag,' + cRC +
                                               'kpst.k_id as kpst,' + cRC +
                                               'SOC_ID,' + cRC +
                                               'SOC_NOM,' + cRC +
                                               'SOC_CLOTURE,' + cRC +
                                               'SOC_SSID,' + cRC +
                                               'MAG_ID,' + cRC +
                                               'MAG_IDENT,' + cRC +
                                               'MAG_NATURE,' + cRC +
                                               'MAG_SS,' + cRC +
                                               'MAG_CODEADH,' + cRC +
                                               'POS_ID,' + cRC +
                                               'POS_NOM,' + cRC +
                                               'POS_INFO,' + cRC +
                                               'POS_MAGID,' + cRC +
                                               'POS_COMPTA' + cRC +
                                        'FROM GENSOCIETE' + cRC +
                                            'JOIN k kste on (kste.k_id=SOC_ID)' + cRC +
                                            'left outer join genmagasin' + cRC +
                                              'join k kmag on (kmag.k_id=mag_id and kmag.k_enabled = 1)' + cRC +
                                            'on (SOC_ID=MAG_SOCID)' + cRC +
                                            'left outer join genposte' + cRC +
                                              'join k kpst on (kpst.k_id=pos_id and kpst.k_enabled = 1)' + cRC +
                                            'on (MAG_ID=POS_MAGID)' + cRC +
                                        'where (soc_id <> 0) and (kste.k_enabled = 1)' + cRC +
                                        'order by SOC_NOM, MAG_NOM, POS_NOM';

  cSql_S_LoadListSteMagPosteToDossier_NewVersion =  'SELECT kste.k_id as kste,' + cRC +
                                                           'kmag.k_id as kmag,' + cRC +
                                                           'kpst.k_id as kpst,' + cRC +
                                                           'SOC_ID,' + cRC +
                                                           'SOC_NOM,' + cRC +
                                                           'SOC_CLOTURE,' + cRC +
                                                           'SOC_SSID,' + cRC +
                                                           'MAG_ID,' + cRC +
                                                           'MAG_IDENT,' + cRC +
                                                           'MAG_NATURE,' + cRC +
                                                           'MAG_SS,' + cRC +
                                                           'MAG_CODEADH,' + cRC +
                                                           'POS_ID,' + cRC +
                                                           'POS_NOM,' + cRC +
                                                           'POS_INFO,' + cRC +
                                                           'POS_MAGID,' + cRC +
                                                           'POS_COMPTA,' + cRC +
                                                           'MPU_GCPID' + cRC +
                                                    'FROM GENSOCIETE' + cRC +
                                                        'JOIN k kste on (kste.k_id=SOC_ID)' + cRC +
                                                        'left outer join genmagasin' + cRC +
                                                          'join k kmag on (kmag.k_id=mag_id and kmag.k_enabled = 1)' + cRC +
                                                        'on (SOC_ID=MAG_SOCID)' + cRC +
                                                        'left outer join genmaggestionpump on MPU_MAGID = MAG_ID' + cRC +
                                                        'left outer join genposte' + cRC +
                                                          'join k kpst on (kpst.k_id=pos_id and kpst.k_enabled = 1)' + cRC +
                                                        'on (MAG_ID=POS_MAGID)' + cRC +
                                                    'where (soc_id <> 0) and (kste.k_enabled = 1)' + cRC +
                                                    'order by SOC_NOM, MAG_NOM, POS_NOM';

  cSql_S_LoadListSteMagPosteToDossier_after_V16 =  'SELECT kste.k_id as kste,' + cRC +
                                                           'kmag.k_id as kmag,' + cRC +
                                                           'kpst.k_id as kpst,' + cRC +
                                                           'SOC_ID,' + cRC +
                                                           'SOC_NOM,' + cRC +
                                                           'SOC_CLOTURE,' + cRC +
                                                           'SOC_SSID,' + cRC +
                                                           'MAG_ID,' + cRC +
                                                           'MAG_IDENT,' + cRC +
                                                           'MAG_NATURE,' + cRC +
                                                           'MAG_SS,' + cRC +
                                                           'MAG_CODEADH,' + cRC +
                                                           'POS_ID,' + cRC +
                                                           'POS_NOM,' + cRC +
                                                           'POS_INFO,' + cRC +
                                                           'POS_MAGID,' + cRC +
                                                           'POS_COMPTA,' + cRC +
                                                           'MPU_GCPID,' + cRC +
                                                           'MAG_BASID' + cRC +
                                                    'FROM GENSOCIETE' + cRC +
                                                        'JOIN k kste on (kste.k_id=SOC_ID)' + cRC +
                                                        'left outer join genmagasin' + cRC +
                                                          'join k kmag on (kmag.k_id=mag_id and kmag.k_enabled = 1)' + cRC +
                                                        'on (SOC_ID=MAG_SOCID)' + cRC +
                                                        'left outer join genmaggestionpump on MPU_MAGID = MAG_ID' + cRC +
                                                        'left outer join genposte' + cRC +
                                                          'join k kpst on (kpst.k_id=pos_id and kpst.k_enabled = 1)' + cRC +
                                                        'on (MAG_ID=POS_MAGID)' + cRC +
                                                    'where (soc_id <> 0) and (kste.k_enabled = 1)' + cRC +
                                                    'order by SOC_NOM, MAG_NOM, POS_NOM';

  cSql_I_GENSUBSCRIBERS = 'INSERT INTO GENSUBSCRIBERS (' + cRC +
                          'SUB_ID,' + cRC +
                          'SUB_NOM,' + cRC +
                          'SUB_ORDRE,' + cRC +
                          'SUB_LOOP' + cRC +
                          ') Values (' + cRC +
                          ':PSUB_ID,' + cRC +
                          ':PSUB_NOM,' + cRC +
                          ':PSUB_ORDRE,' + cRC +
                          ':PSUB_LOOP' + cRC +
                          ')';

  cSql_U_GENSUBSCRIBERS = 'UPDATE GENSUBSCRIBERS SET' + cRC +
                          'SUB_NOM=:PSUB_NOM,' + cRC +
                          'SUB_ORDRE=:PSUB_ORDRE,' + cRC +
                          'SUB_LOOP=:PSUB_LOOP' + cRC +
                          'WHERE SUB_ID <> 0' + cRC +
                          'AND SUB_ID= :PSUB_ID';

  cSql_I_GENPROVIDERS = 'insert into GENPROVIDERS (' + cRC +
                        'PRO_ID,' + cRC +
                        'PRO_NOM,' + cRC +
                        'PRO_ORDRE,' + cRC +
                        'PRO_LOOP' + cRC +
                        ') Values (' + cRC +
                        ':PPRO_ID,' + cRC +
                        ':PPRO_NOM,' + cRC +
                        ':PPRO_ORDRE,' + cRC +
                        ':PPRO_LOOP' + cRC +
                        ')';

  cSql_U_GENPROVIDERS = 'update GENPROVIDERS Set' + cRC +
                        'PRO_NOM=:PPRO_NOM,' + cRC +
                        'PRO_ORDRE=:PPRO_ORDRE,' + cRC +
                        'PRO_LOOP=:PPRO_LOOP' + cRC +
                        'WHERE PRO_ID <> 0' + cRC +
                        'AND PRO_ID= :PPRO_ID';

  cSql_U_genmagasin = 'update genmagasin set' + cRC +
                      'MAG_NOM=:PMAG_NOM,' + cRC +
                      'MAG_ENSEIGNE=:PMAG_ENSEIGNE,' + cRC +
                      'MAG_IDENT=:PMAG_IDENT,' + cRC +
                      'MAG_NATURE=:PMAG_NATURE,' + cRC +
                      'MAG_SS=:PMAG_SS,' + cRC +
                      'MAG_CODEADH=:PMAG_CODEADH' + cRC +
                      'WHERE MAG_ID <> 0' + cRC +
                      'AND MAG_ID=:PMAG_ID';

  cSql_U_genmagasin_after_V16 = 'update genmagasin set' + cRC +
                      'MAG_NOM=:PMAG_NOM,' + cRC +
                      'MAG_ENSEIGNE=:PMAG_ENSEIGNE,' + cRC +
                      'MAG_IDENT=:PMAG_IDENT,' + cRC +
                      'MAG_NATURE=:PMAG_NATURE,' + cRC +
                      'MAG_SS=:PMAG_SS,' + cRC +
                      'MAG_CODEADH=:PMAG_CODEADH,' + cRC +
                      'MAG_BASID=:PMAG_BASID' + cRC +
                      'WHERE MAG_ID <> 0' + cRC +
                      'AND MAG_ID=:PMAG_ID';

  cSql_U_gengestionpump = 'update gengestionpump set' + cRC +
                          'GCP_NOM=:PGCPNOM' + cRC +
                          'WHERE GCP_ID <> 0' + cRC +
                          'AND GCP_ID=:PGCPID';

  cSql_U_genmaggestionpump = 'update genmaggestionpump set' + cRC +
                             'MPU_GCPID=:PGCPID' + cRC +
                             'WHERE MPU_ID <> 0' + cRC +
                             'AND MPU_ID=:PMPUID' + cRC +
                             'AND MPU_MAGID=:PMPUMAGID';

  cSql_U_genparambase = 'UPDATE GENPARAMBASE SET PAR_STRING = 0 WHERE PAR_NOM = :PPARNOM';

  cSql_S_genversion = 'SELECT VER_VERSION FROM GENVERSION WHERE VER_DATE = (SELECT MAX(VER_DATE) FROM GENVERSION)';

  cSql_I_genmagasin = 'insert into genmagasin (' + cRC +
                      'MAG_NOM,' + cRC +
                      'MAG_ID, ' + cRC +
                      'MAG_SOCID, ' + cRC +
                      'MAG_ENSEIGNE,' + cRC +
                      'MAG_IDENT,' + cRC +
                      'MAG_NATURE,' + cRC +
                      'MAG_SS,' + cRC +
                      'MAG_CODEADH' + cRC +
                      ') Values (' + cRC +
                      ':PMAG_NOM,' + cRC +
                      ':PMAG_ID_GINKOIA,' + cRC +
                      ':PMAG_SOCID,' + cRC +
                      ':PMAG_ENSEIGNE,' + cRC +
                      ':PMAG_IDENT,' + cRC +
                      ':PMAG_NATURE,' + cRC +
                      ':PMAG_SS,' + cRC +
                      ':PMAG_CODEADH' + cRC +
                      ')';

  cSql_I_genmagasin_after_V16 = 'insert into genmagasin (' + cRC +
                      'MAG_NOM,' + cRC +
                      'MAG_ID, ' + cRC +
                      'MAG_SOCID, ' + cRC +
                      'MAG_ENSEIGNE,' + cRC +
                      'MAG_IDENT,' + cRC +
                      'MAG_NATURE,' + cRC +
                      'MAG_SS,' + cRC +
                      'MAG_CODEADH,' + cRC +
                      'MAG_BASID' + cRC +
                      ') Values (' + cRC +
                      ':PMAG_NOM,' + cRC +
                      ':PMAG_ID_GINKOIA,' + cRC +
                      ':PMAG_SOCID,' + cRC +
                      ':PMAG_ENSEIGNE,' + cRC +
                      ':PMAG_IDENT,' + cRC +
                      ':PMAG_NATURE,' + cRC +
                      ':PMAG_SS,' + cRC +
                      ':PMAG_CODEADH,' + cRC +
                      ':PMAG_BASID' + cRC +
                      ')';

  cSql_I_genmaggestionpump = 'insert into genmaggestionpump (' + cRC +
                             'MPU_ID,' + cRC +
                             'MPU_MAGID,' + cRC +
                             'MPU_GCPID' + cRC +
                             ') Values (' + cRC +
                             ':PMPUID,' + cRC +
                             ':PMPUMAGID,' + cRC +
                             ':PMPUGCPID' + cRC +
                             ')';

  cSql_I_gengestionpump = 'insert into gengestionpump (' + cRC +
                          'GCP_ID,' + cRC +
                          'GCP_NOM' + cRC +
                          ') Values (' + cRC +
                          ':PGCPID,' + cRC +
                          ':PGCPNOM' + cRC +
                          ')';

  cSql_U_GENCONNEXION = 'update GENCONNEXION set' + cRC +
            'CON_LAUID=:PCON_LAUID,' + cRC +
            'CON_NOM=:PCON_NOM,' + cRC +
            'CON_TEL=:PCON_TEL,' + cRC +
            'CON_TYPE=:PCON_TYPE,' + cRC +
            'CON_ORDRE=:PCON_ORDRE' + cRC +
            'WHERE CON_ID <> 0' + cRC +
            'AND CON_ID=:PCON_ID';

  cSql_I_GENCONNEXION = 'insert into GENCONNEXION (' + cRC +
            'CON_LAUID,' + cRC +
            'CON_NOM,' + cRC +
            'CON_TEL,' + cRC +
            'CON_TYPE,' + cRC +
            'CON_ORDRE,' + cRC +
            'CON_ID' + cRC +
            ') Values (' + cRC +
            ':PCON_LAUID,' + cRC +
            ':PCON_NOM,' + cRC +
            ':PCON_TEL,' + cRC +
            ':PCON_TYPE,' + cRC +
            ':PCON_ORDRE,' + cRC +
            ':PCON_ID' + cRC +
            ')';


  cSql_U_genposte = 'update genposte set' + cRC +
            'POS_NOM=:PPOS_NOM,' + cRC +
            'POS_INFO=:PPOS_INFO,' + cRC +
            'POS_COMPTA=:PPOS_COMPTA' + cRC +
            'WHERE POS_ID <> 0' + cRC +
            'AND POS_ID=:PPOS_ID';

  cSql_I_genposte = 'insert into genposte (' + cRC +
            'POS_NOM,' + cRC +
            'POS_INFO,' + cRC +
            'POS_MAGID,' + cRC +
            'POS_COMPTA,' + cRC +
            'POS_ID' + cRC +
            ') Values (' + cRC +
            ':PPOS_NOM,' + cRC +
            ':PPOS_INFO,' + cRC +
            ':PPOS_MAGID,' + cRC +
            ':PPOS_COMPTA,' + cRC +
            ':PPOS_ID' + cRC +
            ')';

  cSql_S_genposte = 'SELECT ' + cRC +
                    'POS_ID,' + cRC +
                    'POS_NOM,' + cRC +
                    'POS_INFO,' + cRC +
                    'POS_MAGID,' + cRC +
                    'POS_COMPTA,' + cRC +
                    'K_INSERTED,' + cRC +
                    'K_UPDATED,' + cRC +
                    'K_ENABLED' + cRC +
                    'FROM GENPOSTE ' + cRC +
                    'JOIN K ON K_ID = POS_ID ' + cRC +
                    'WHERE POS_ID <> 0';

  cSql_S_GetListGenReplication =  'Select * ' + cRC +
                                  'From GENREPLICATION' + cRC +
                                    'Join K on (K_ID = REP_ID and K_ENABLED = 1)' + cRC +
                                  'Where REP_ORDRE > 0' + cRC +
                                    'And REP_LAUID = :PLAUID' + cRC +
                                  'Order By REP_ORDRE';

  cSql_S_GetListGenReplication_Web =  'Select * ' + cRC +
                                      'From GENREPLICATION' + cRC +
                                        'Join K on (K_ID = REP_ID and K_ENABLED = 1)' + cRC +
                                      'Where REP_ORDRE < 0' + cRC +
                                        'And REP_LAUID = :PLAUID' + cRC +
                                      'Order By REP_ORDRE DESC';

  cSql_S_SyncBase_GenBases =  'Select' + cRC +
                              '	BAS_ID,' + cRC +
                              '	BAS_NOM,' + cRC +
                              '	BAS_IDENT,' + cRC +
                              '	BAS_JETON,' + cRC +
                              '	BAS_PLAGE,' + cRC +
                              '	BAS_GUID,' + cRC +
                              '	BAS_MAGID,' + cRC +
                              '	BAS_CODETIERS,' + cRC +
                              '	LAU_HEURE1,' + cRC +
                              '	LAU_H1,' + cRC +
                              '	LAU_HEURE2,' + cRC +
                              '	LAU_H2' + cRC +
                              'From GENBASES' + cRC +
                              'Join K on (K_ID = BAS_ID and K_ENABLED = 1)' + cRC +
                              'Left Join GENLAUNCH on (BAS_ID = LAU_BASID)' + cRC +
                              'Where BAS_ID <> 0';

  cSql_U_CreateBase_GenBases = 'UPDATE GENBASES SET' + cRC +
                               'BAS_GUID =:PBAS_GUID,' + cRC +
                               'BAS_SENDER =:PBAS_SENDER,' + cRC +
                               'BAS_NOM =:PBAS_NOM,' + cRC +
                               'BAS_NOMPOURNOUS =:PBAS_NOMPOURNOUS' + cRC +
                               'WHERE BAS_ID <> 0' + cRC +
                               'AND BAS_ID =:PBAS_ID';

  cSql_S_CreateBase_GenMagasin = 'SELECT' + cRC +
                                 ' MAG_ID,' + cRC +
                                 ' MAG_NOM,' + cRC +
                                 ' MAG_ENSEIGNE,' + cRC +
                                 ' MAG_CODEADH,' + cRC +
                                 ' K_ENABLED' + cRC +
                                 'FROM GENMAGASIN' + cRC +
                                 ' JOIN K ON (K_ID = MAG_ID)' + cRC +
                                 'WHERE MAG_ID <> 0';

  cSQL_S_GenParam = 'SELECT' + cRC +
                    ' PRM_ID'  + cRC +
                    'FROM GENPARAM' + cRC +
                    ' JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)' + cRC +
                    'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                    ' AND PRM_CODE = :PPRMCODE' + cRC +
                    ' AND PRM_POS = :PPRMPOS';

  cSQL_U_Maj_Emetteur_GenParam_PrmInteger = 'UPDATE GENPARAM SET' + cRC +
                                            'PRM_INTEGER=:PPRM_INTEGER' + cRC +
                                            'WHERE PRM_ID=:PPRM_ID';

  cSQL_U_Maj_Emetteur_GenParam_PrmFloat = 'UPDATE GENPARAM SET' + cRC +
                                          'PRM_FLOAT=:PPRM_FLOAT' + cRC +
                                          'WHERE PRM_ID=:PPRM_ID';

  cSQL_U_Maj_Emetteur_GenParam_PrmString = 'UPDATE GENPARAM SET' + cRC +
                                           'PRM_STRING=:PPRM_STRING' + cRC +
                                           'Where PRM_ID=:PPRM_ID';

  cSQL_I_GenLaunch = 'INSERT INTO GENLAUNCH (' + cRC +
                      'LAU_ID,' + cRC +
                      'LAU_BASID,' + cRC +
                      'LAU_HEURE1,' + cRC +
                      'LAU_H1,' + cRC +
                      'LAU_HEURE2,' + cRC +
                      'LAU_H2,' + cRC +
                      'LAU_AUTORUN,' + cRC +
                      'LAU_BACKTIME,' + cRC +
                      'LAU_BACK' + cRC +
                      ') VALUES (' + cRC +
                      ':PLAUID,' + cRC +
                      ':PLAUBASID,' + cRC +
                      ':PLAUHEURE1,' + cRC +
                      ':PLAUH1,' + cRC +
                      ':PLAUHEURE2,' + cRC +
                      ':PLAUH2,' + cRC +
                      ':PLAUAUTORUN,' + cRC +
                      ':PLAUBACKTIME,' + cRC +
                      ':PLAUBACK' + cRC +
                      ')';

  cSQL_U_GenLaunch = 'UPDATE GENLAUNCH SET' + cRC +
                      'LAU_HEURE1 = :PLAU_HEURE1,' + cRC +
                      'LAU_H1 = :PLAU_H1,' + cRC +
                      'LAU_HEURE2 = :PLAU_HEURE2,' + cRC +
                      'LAU_H2 = :PLAU_H2,' + cRC +
                      'LAU_AUTORUN = :PLAU_AUTORUN,' + cRC +
                      'LAU_BACKTIME = :PLAU_BACKTIME,' + cRC +
                      'LAU_BACK = :PLAU_BACK,' + cRC +
                      'LAU_BASID = :PLAU_BASID' + cRC +
                      'WHERE LAU_ID = :PLAU_ID';


//******* SQL pour la BDD Maintenance *********//

  cSql_S_MAINTENANCE_VERSION = 'SELECT VMAI_VERSION FROM MAINTENANCE_VERSION WHERE VMAI_DATE = (SELECT MAX(VMAI_DATE) FROM MAINTENANCE_VERSION)';

  cSql_I_SPLITTAGE_LOG = 'INSERT INTO SPLITTAGE_LOG (' + cRC +
                          'SPLI_NOSPLIT,' + cRC +
                          'SPLI_EMETID,' + cRC +
                          'SPLI_EMETNOM,' + cRC +
                          'SPLI_TYPESPLIT,' + cRC +
                          'SPLI_USERNAME,' + cRC +
                          'SPLI_CLEARFILES,' + cRC +
                          'SPLI_ORDRE,' + cRC +
                          'SPLI_BASE,' + cRC +
                          'SPLI_MAIL' + cRC +
                          ') VALUES (' + cRC +
                          ':PNOSPLIT,' + cRC +
                          ':PEMET_ID,' + cRC +
                          ':PEMET_NOM,' + cRC +
                          ':PTYPESPLIT,' + cRC +
                          ':PUSERNAME,' + cRC +
                          ':PCLEARFILES,' + cRC +
                          ':PORDRE,' + cRC +
                          ':PBASE,' + cRC +
                          ':PMAIL' + cRC +
                          ')';

  cSql_I_SUIVISVR = 'INSERT INTO SUIVISVR (' + cRC +
                    'SSRV_SERVID,' + cRC +
                    'SSVR_PATH' + cRC +
                    ') VALUES (' + cRC +
                    ':PSSRVSERVID,' + cRC +
                    ':PSSVRPATH' + cRC +
                    ')';

  cSql_I_Groupe = 'INSERT INTO GROUPE (' + cRC +
                  'GROU_ID,' + cRC +
                  'GROU_NOM' + cRC +
                  ') VALUES (' + cRC +
                  ':PGROUID,' + cRC +
                  ':PGROUNOM' + cRC +
                  ')';

  cSql_U_Groupe = 'UPDATE GROUPE SET' + cRC +
                  'GROU_NOM = :PGROUNOM' + cRC +
                  'WHERE' + cRC +
                  'GROU_ID = :PGROUID';


  cSql_I_Version =  'INSERT INTO VERSION (' + cRC +
                    'VERS_ID,' + cRC +
                    'VERS_VERSION,' + cRC +
                    'VERS_NOMVERSION,' + cRC +
                    'VERS_PATCH,' + cRC +
                    'VERS_EAI' + cRC +
                    ') VALUES (' + cRC +
                    ':PVERSID,' + cRC +
                    ':PVERSVERSION,' + cRC +
                    ':PVERSNOMVERSION,' + cRC +
                    ':PVERSPATCH,' + cRC +
                    ':PVERSEAI' + cRC +
                    ')';

  cSql_U_Version =  'UPDATE VERSION SET' + cRC +
                    'VERS_VERSION = :PVERSVERSION,' + cRC +
                    'VERS_NOMVERSION = :PVERSNOMVERSION,' + cRC +
                    'VERS_PATCH = :PVERSPATCH,' + cRC +
                    'VERS_EAI = :PVERSEAI' + cRC +
                    'WHERE' + cRC +
                    'VERS_ID = :PVERSID';

  cSql_I_Dossier =  'INSERT INTO DOSSIER (' + cRC +
                    'DOSS_ID,' + cRC +
                    'DOSS_DATABASE,' + cRC +
                    'DOSS_SERVID,' + cRC +
                    'DOSS_CHEMIN,' + cRC +
                    'DOSS_GROUID,' + cRC +
                    'DOSS_INSTALL,' + cRC +
                    'DOSS_VIP,' + cRC +
                    'DOSS_PLATEFORME,' + cRC +
                    'DOSS_EMAIL,' + cRC +
                    'DOSS_ACTIF,' + cRC +
                    'DOSS_RECALTEMPS,' + cRC +
                    'DOSS_RECALLASTDATE,' + cRC +
                    'DOSS_EASY' + cRC +
                    ') VALUES (' + cRC +
                    ':PDOSSID,' + cRC +
                    ':PDOSSDATABASE,' + cRC +
                    ':PDOSSSERVID,' + cRC +
                    ':PDOSSCHEMIN,' + cRC +
                    ':PDOSSGROUID,' + cRC +
                    ':PDOSSINSTALL,' + cRC +
                    ':PDOSSVIP,' + cRC +
                    ':PDOSSPLATEFORME,' + cRC +
                    ':PDOSSEMAIL,' + cRC +
                    ':PDOSSACTIF,' + cRC +
                    ':PDOSSRECALTEMPS,' + cRC +
                    ':PDOSSRECALLASTDATE,' + cRC +
                    ':PDOSSEASY' + cRC +
                    ')';

  cSql_U_Dossier =  'UPDATE DOSSIER SET' + cRC +
                    'DOSS_DATABASE = :PDOSSDATABASE,' + cRC +
                    'DOSS_SERVID = :PDOSSSERVID,' + cRC +
                    'DOSS_CHEMIN = :PDOSSCHEMIN,' + cRC +
                    'DOSS_GROUID = :PDOSSGROUID,' + cRC +
                    'DOSS_INSTALL = :PDOSSINSTALL,' + cRC +
                    'DOSS_VIP = :PDOSSVIP,' + cRC +
                    'DOSS_PLATEFORME = :PDOSSPLATEFORME,' + cRC +
                    'DOSS_EMAIL = :PDOSSEMAIL,' + cRC +
                    'DOSS_ACTIF = :PDOSSACTIF,' + cRC +
                    'DOSS_RECALTEMPS = :PDOSSRECALTEMPS,' + cRC +
                    'DOSS_RECALLASTDATE = :PDOSSRECALLASTDATE,' + cRC +
                    'DOSS_EASY = :PDOSSEASY' + cRC +
                    'WHERE' + cRC +
                    'DOSS_ID = :PDOSSID';

  cSql_I_Serveur =  'INSERT INTO SERVEUR (' + cRC +
                    'SERV_ID,' + cRC +
                    'SERV_NOM,' + cRC +
                    'SERV_IP,' + cRC +
                    'SERV_DOSEAI,' + cRC +
                    'SERV_USER,' + cRC +
                    'SERV_PASSWORD,' + cRC +
                    'SERV_DOSBDD,' + cRC +
                    'SERV_SEVENZIP,' + cRC +
                    'SERV_LOCALIP' + cRC +
                    ') VALUES (' + cRC +
                    ':PSERVID,' + cRC +
                    ':PSERVNOM,' + cRC +
                    ':PSERVIP,' + cRC +
                    ':PSERVDOSEAI,' + cRC +
                    ':PSERVUSER,' + cRC +
                    ':PSERVPASSWORD,' + cRC +
                    ':PSERVDOSBDD,' + cRC +
                    ':PSERVSEVENZIP,' + cRC +
                    ':PSERVLOCALIP' + cRC +
                    ')';

  cSql_U_Serveur =  'UPDATE SERVEUR SET' + cRC +
                    'SERV_NOM = :PSERVNOM,' + cRC +
                    'SERV_IP = :PSERVIP,' + cRC +
                    'SERV_DOSEAI = :PSERVDOSEAI,' + cRC +
                    'SERV_USER = :PSERVUSER,' + cRC +
                    'SERV_PASSWORD = :PSERVPASSWORD,' + cRC +
                    'SERV_DOSBDD = :PSERVDOSBDD,' + cRC +
                    'SERV_SEVENZIP = :PSERVSEVENZIP,' + cRC +
                    'SERV_LOCALIP = :PSERVLOCALIP' + cRC +
                    'WHERE' + cRC +
                    'SERV_ID = :PSERVID';

  cSql_S_SyncBase_Magasins = 'SELECT MAGA_ID' + cRC +
                             'FROM MAGASINS' + cRC +
                             'WHERE MAGA_MAGID_GINKOIA = :PMAGAMAGIDGINKOIA' + cRC +
                             'AND MAGA_DOSSID = :PMAGADOSSID';

  cSql_I_Modules_Magasins = 'INSERT INTO MODULES_MAGASINS (' + cRC +
                    'MMAG_MODUID,' + cRC +
                    'MMAG_MAGAID,' + cRC +
                    'MMAG_EXPDATE,' + cRC +
                    'MMAG_KENABLED,' + cRC +
                    'MMAG_UGMID' + cRC +
                    ') VALUES (' + cRC +
                    ':PMMAGMODUID,' + cRC +
                    ':PMMAGMAGAID,' + cRC +
                    ':PMMAGEXPDATE,' + cRC +
                    ':PMMAGKENABLED,' + cRC +
                    ':PMMAGUGMID' + cRC +
                    ')';

  cSql_U_Modules_Magasins = 'UPDATE MODULES_MAGASINS SET' + cRC +
                            'MMAG_EXPDATE = :PMMAGEXPDATE,' + cRC +
                            'MMAG_KENABLED = :PMMAGKENABLED,' + cRC +
                            'MMAG_UGMID = :PMMAGUGMID' + cRC +
                            'WHERE' + cRC +
                            'MMAG_MODUID = :PMMAGMODUID' + cRC +
                            'AND' + cRC +
                            'MMAG_MAGAID = :PMMAGMAGAID';

  cSql_S_GetListModule =  'SELECT' + cRC +
                            'DOSS_ID,' + cRC +
                            'MAGA_ID,' + cRC +
                            'MAGA_MAGID_GINKOIA,' + cRC +
                            'DOSS_DATABASE,' + cRC +
                            'MMAG_EXPDATE,' + cRC +
                            'MAGA_NOM,' + cRC +
                            'MODU_ID,' + cRC +
                            'MODU_NOM,' + cRC +
                            'MODU_COMMENT,' + cRC +
                            'DOSS_SERVID,' + cRC +
                            'DOSS_GROUID' + cRC +
                          'FROM' + cRC +
                            'MAGASINS' + cRC +
                            'JOIN DOSSIER ON (MAGA_DOSSID = DOSS_ID)' + cRC +
                            'LEFT OUTER JOIN MODULES_MAGASINS ON (MMAG_MAGAID = MAGA_ID)' + cRC +
                            'LEFT OUTER JOIN MODULES ON (MODU_ID = MMAG_MODUID)' + cRC +
                          'WHERE DOSS_ID = :PDOSSID' + cRC +
                          'AND MMAG_MAGAID = :PMAGAID' + cRC +
                          'AND MMAG_EXPDATE > CURRENT_TIMESTAMP' + cRC +
                          'AND MMAG_KENABLED = 1' + cRC +
                          'ORDER BY DOSS_DATABASE, MAGA_NOM';

  cSql_S_LoadListModulePerMag = 'SELECT' + cRC +
                                  'DOSS_ID,' + cRC +
                                  'MAGA_ID,' + cRC +
                                  'MAGA_MAGID_GINKOIA,' + cRC +
                                  'DOSS_DATABASE,' + cRC +
                                  'MMAG_EXPDATE,' + cRC +
                                  'MAGA_NOM,' + cRC +
                                  'MODU_ID,' + cRC +
                                  'MODU_NOM,' + cRC +
                                  'MODU_COMMENT,' + cRC +
                                  'DOSS_SERVID,' + cRC +
                                  'DOSS_GROUID' + cRC +
                                'FROM' + cRC +
                                  'MAGASINS' + cRC +
                                  'JOIN DOSSIER ON (MAGA_DOSSID = DOSS_ID)' + cRC +
                                  'LEFT OUTER JOIN MODULES_MAGASINS ON (MMAG_MAGAID = MAGA_ID)' + cRC +
                                  'LEFT OUTER JOIN MODULES ON (MODU_ID = MMAG_MODUID)' + cRC +
                                'WHERE DOSS_ID <> 0' + cRC +
                                'AND MMAG_EXPDATE > CURRENT_TIMESTAMP' + cRC +
                                'AND MMAG_KENABLED = 1' + cRC +
                                'ORDER BY DOSS_DATABASE, MAGA_NOM';

  cSql_S_InitializeListDos =  'SELECT' + cRC +
                                'DOSSIER.*,' + cRC +
                                ' (SELECT' + cRC +
                                    'VERS_VERSION' + cRC +
                                  'FROM' + cRC +
                                    'EMETTEUR' + cRC +
                                    'JOIN VERSION ON EMET_VERSID = VERS_ID' + cRC +
                                  'WHERE (EMET_IDENT =''0'')' + cRC +
                                  'AND EMET_DOSSID = DOSSIER.DOSS_ID) AS VERS_VERSION' + cRC +
                              'FROM DOSSIER' + cRC +
                              'WHERE DOSS_ID <> 0';

  cSql_I_magasins = 'INSERT INTO MAGASINS (' + cRC +
                    'MAGA_ID,' + cRC +
                    'MAGA_DOSSID,' + cRC +
                    'MAGA_MAGID_GINKOIA,' + cRC +
                    'MAGA_NOM,' + cRC +
                    'MAGA_ENSEIGNE,' + cRC +
                    'MAGA_K_ENABLED,' + cRC +
                    'MAGA_CODEADH,' + cRC +
                    'MAGA_BASID' + cRC +
                    ') VALUES (' + cRC +
                    ':PMAGAID,' + cRC +
                    ':PMAGADOSSID,' + cRC +
                    ':PMAGAMAGIDGINKOIA,' + cRC +
                    ':PMAGANOM,' + cRC +
                    ':PMAGAENSEIGNE,' + cRC +
                    ':PMAGAKENABLED,' + cRC +
                    ':PMAGACODEADH,' + cRC +
                    ':PMAGABASID' + cRC +
                    ')';

  cSql_U_magasins = 'UPDATE MAGASINS SET' + cRC +
                    'MAGA_NOM=:PMAGANOM,' + cRC +
                    'MAGA_ENSEIGNE=:PMAGAENSEIGNE,' + cRC +
                    'MAGA_MAGID_GINKOIA=:PMAGAMAGIDGINKOIA,' + cRC +
                    'MAGA_K_ENABLED=:PMAGAKENABLED,' + cRC +
                    'MAGA_CODEADH=:PMAGACODEADH,' + cRC +
                    'MAGA_BASID=:PMAGABASID' + cRC +
                    'WHERE MAGA_DOSSID=:PMAGADOSSID' + cRC +
                    'and MAGA_ID=:PMAGAID';

  cSql_I_postes = 'INSERT INTO POSTES (' + cRC +
                  'POST_ID,' + cRC +
                  'POST_POSID,' + cRC +
                  'POST_MAGAID,' + cRC +
                  'POST_NOM,' + cRC +
                  'POST_INFO,' + cRC +
                  'POST_COMPTA,' + cRC +
                  'POST_PTYPID,' + cRC +
                  'POST_DATEC,' + cRC +
                  'POST_DATEM,' + cRC +
                  'POST_ENABLE' + cRC +
                  ') VALUES (' + cRC +
                  ':PPOSTID,' + cRC +
                  ':PPOSTPOSID,' + cRC +
                  ':PPOSTMAGAID,' + cRC +
                  ':PPOSTNOM,' + cRC +
                  ':PPOSTINFO,' + cRC +
                  ':PPOSTCOMPTA,' + cRC +
                  ':PPOSTPTYPID,' + cRC +
                  ':PPOSTDATEC,' + cRC +
                  ':PPOSTDATEM,' + cRC +
                  ':PPOSTENABLE' + cRC +
                  ')';

  cSql_U_postes = 'UPDATE POSTES SET' + cRC +
                  'POST_NOM=:PPOSTNOM,' + cRC +
                  'POST_INFO=:PPOSTINFO,' + cRC +
                  'POST_COMPTA=:PPOSTCOMPTA,' + cRC +
                  'POST_PTYPID=:PPOSTPTYPID,' + cRC +
                  'POST_DATEC=:PPOSTDATEC,' + cRC +
                  'POST_DATEM=:PPOSTDATEM,' + cRC +
                  'POST_ENABLE=:PPOSTENABLE' + cRC +
                  'WHERE POST_ID=:PPOSTID';

  cSql_S_SyncBase_Emetteur = 'Select EMET_ID' + cRC +
                             'From EMETTEUR' + cRC +
                             'Where EMET_GUID = :PEMETGUID' + cRC +
                             'And EMET_DOSSID = :PEMETDOSSID';

  cSql_U_SyncBase_Emetteur = 'Update emetteur set' + cRC +
                             'EMET_NOM = :PEMETNOM,' + cRC +
                             'EMET_MAGID = :PEMETMAGID,' + cRC +
                             'EMET_TIERSCEGID = :PEMETTIERSCEGID,' + cRC +
                             'EMET_IDENT = :PEMETIDENT,' + cRC +
                             'EMET_JETON = :PEMETJETON,' + cRC +
                             'EMET_PLAGE = :PEMETPLAGE,' + cRC +
                             'EMET_HEURE1 = :PEMETHEURE1,' + cRC +
                             'EMET_H1 = :PEMETH1,' + cRC +
                             'EMET_HEURE2 = :PEMETHEURE2,' + cRC +
                             'EMET_H2 = :PEMETH2,' + cRC +
                             'EMET_VERSID = :PEMETVERSID,' + cRC +
                             'EMET_BASID_GINKOIA = :PEMETBASID' + cRC +
                             'Where EMET_ID = :PEMETID';

  cSql_S_SyncBase_Modules = 'SELECT' + cRC +
                              'MODU_ID' + cRC +
                            'FROM MODULES' + cRC +
                            'WHERE MODU_NOM = :PMODUNOM';

  cSql_I_SyncBase_Modules = 'INSERT INTO MODULES (' + cRC +
                            'MODU_ID,' + cRC +
                            'MODU_NOM,' + cRC +
                            'MODU_COMMENT' + cRC +
                            ') VALUES (' + cRC +
                            ':PMODUID,' + cRC +
                            ':PMODUNOM,' + cRC +
                            ':PMODUCOMMENT' + cRC +
                            ')';

  cSql_S_SyncBase_Modules_Magasins =  'SELECT' + cRC +
                                        'MMAG_MODUID,' + cRC +
                                        'MMAG_MAGAID,' + cRC +
                                        'MMAG_EXPDATE,' + cRC +
                                        'MMAG_KENABLED' + cRC +
                                      'FROM MODULES_MAGASINS' + cRC +
                                      ' JOIN MODULES ON (MODU_ID = MMAG_MODUID)' + cRC +
                                      ' JOIN MAGASINS ON (MAGA_ID = MMAG_MAGAID)' + cRC +
                                      'WHERE MODU_NOM = :PMODUNOM' + cRC +
                                      'AND MAGA_MAGID_GINKOIA = :PMAGAMAGID_GINKOIA' + cRC +
                                      'AND MAGA_DOSSID = :PMMAG_DOSSID';

  cSql_I_Emetteur = 'insert into emetteur (' + cRC +
                    'EMET_NOM,' + cRC +
                    'EMET_JETON,' + cRC +
                    'EMET_IDENT,' + cRC +
                    'EMET_PLAGE,' + cRC +
                    'EMET_GUID,' + cRC +
                    'EMET_DONNEES,' + cRC +
                    'EMET_VERSID,' + cRC +
                    'EMET_INSTALL,' + cRC +
                    'EMET_MAGID,' + cRC +
                    'EMET_PATCH,' + cRC +
                    'EMET_VERSION_MAX,' + cRC +
                    'EMET_SPE_PATCH,' + cRC +
                    'EMET_SPE_FAIT,' + cRC +
                    'EMET_BCKOK,' + cRC +
                    'EMET_DERNBCK,' + cRC +
                    'EMET_RESBCK,' + cRC +
                    'EMET_TIERSCEGID,' + cRC +
                    'EMET_TYPEREPLICATION,' + cRC +
                    'EMET_NONREPLICATION,' + cRC +
                    'EMET_DEBUTNONREPLICATION,' + cRC +
                    'EMET_FINNONREPLICATION,' + cRC +
                    'EMET_SERVEURSECOURS,' + cRC +
                    'EMET_HEURE1,' + cRC +
                    'EMET_H1,' + cRC +
                    'EMET_HEURE2,' + cRC +
                    'EMET_H2,' + cRC +
                    'EMET_INFOSUP,' + cRC +
                    'EMET_EMAIL,' + cRC +
                    'EMET_DOSSID,' + cRC +
                    'EMET_ID,' + cRC +
                    'EMET_BASID_GINKOIA' + cRC +
                    ') Values (' + cRC +
                    ':PEMETNOM,' + cRC +
                    ':PEMETJETON,' + cRC +
                    ':PEMETIDENT,' + cRC +
                    ':PEMETPLAGE,' + cRC +
                    ':PEMETGUID,' + cRC +
                    ':PEMETDONNEES,' + cRC +
                    ':PEMETVERSID,' + cRC +
                    ':PEMETINSTALL,' + cRC +
                    ':PEMETMAGID,' + cRC +
                    ':PEMETPATCH,' + cRC +
                    ':PEMETVERSION_MAX,' + cRC +
                    ':PEMETSPEPATCH,' + cRC +
                    ':PEMETSPEFAIT,' + cRC +
                    ':PEMETBCKOK,' + cRC +
                    ':PEMETDERNBCK,' + cRC +
                    ':PEMETRESBCK,' + cRC +
                    ':PEMETTIERSCEGID,' + cRC +
                    ':PEMETTYPEREPLICATION,' + cRC +
                    ':PEMETNONREPLICATION,' + cRC +
                    ':PEMETDEBUTNONREPLICATION,' + cRC +
                    ':PEMETFINNONREPLICATION,' + cRC +
                    ':PEMETSERVEURSECOURS,' + cRC +
                    ':PEMETHEURE1,' + cRC +
                    ':PEMETH1,' + cRC +
                    ':PEMETHEURE2,' + cRC +
                    ':PEMETH2,' + cRC +
                    ':PEMETINFOSUP,' + cRC +
                    ':PEMETEMAIL,' + cRC +
                    ':PEMETDOSSID,' + cRC +
                    ':PEMETID,' + cRC +
                    ':PEMETBASID'+ cRC +
                    ')';

  { Requete Sql pour la synthese }
  cSqlSyntheseBase = 'SELECT' + cRC +
                     '  EMET_ID,' + cRC +
                     '  EMET_NOM,' + cRC +
                     '  DOSS_ID,' + cRC +
                     '  EMET_VERSID,' + cRC +
                     '  EMET_BCKOK,' + cRC +
                     '  EMET_DERNBCK,' + cRC +
                     '  EMET_RESBCK,' + cRC +
                     '  EMET_NONREPLICATION,' + cRC +
                     '  EMET_TYPEREPLICATION,' + cRC +
                     '  EMET_HEURE1,' + cRC +
                     '  EMET_HEURE2,' + cRC +
                     '  HDBM_DATE,' + cRC +
                     '  HDBM_CYCLE,' + cRC +
                     '  HDBM_OK,' + cRC +
                     '  HDBM_COMENTAIRE,' + cRC +
                     '  RAIS_NOM,' + cRC +
                     '  DOSS_DATABASE,' + cRC +
                     '  DOSS_VIP,' + cRC +
                     '  SERV_ID,' + cRC +
                     '  SERV_NOM' + cRC +
                     'FROM' + cRC +
                     '  HDB, EMETTEUR, DOSSIER, SERVEUR' + cRC +
                     '  LEFT OUTER JOIN RAISON ON HDBM_RAISID=RAIS_ID)' + cRC +
                     'WHERE (HDBM_EMETID=EMET_ID)' + cRC +
                     '  AND EMET_DOSSID=DOSS_ID)' + cRC +
                     '  AND (DOSS_SERVID=SERV_ID)' + cRC;


  cSqlSyntheseLastReplic = '  AND (HDBM_DATE = (SELECT MAX(HDBM_DATE) FROM HDB WHERE EMET_ID=HDBM_EMETID))' + cRC;

  cSqlSyntheseEMET_TYPEREPLICATION = '  AND (:PTYPEREPLIC LIKE ''%|'' || EMET_TYPEREPLICATION || ''|%'')' + cRC;

  cSqlSyntheseDELAINONREPLIC = '  AND ((HDBM_DATE - HDBM_CYCLE) >= :PDELAINONREPLIC)' + cRC;

  cSqlSyntheseHDBM_OK = '  AND (HDBM_OK = :PHDBM_OK)' + cRC;

  cSqlSyntheseDOSS_VIP = '  AND (DOSS_VIP = :PDOSS_VIP)' + cRC;

  cSql_S_Maintenance_Emet_DateInstallation = 'SELECT EMET_INSTALL ' + cRC +
                                             'FROM EMETTEUR WHERE EMET_GUID = :PEMETGUID';

  cSql_U_Maintenance_Emet_DateInstallation = 'UPDATE EMETTEUR SET EMET_INSTALL = :PEMETINSTALL WHERE EMET_GUID = :PEMETGUID';

  cSql_S_Maintenance_Param = 'SELECT * FROM MAINTENANCE_PARAM WHERE PMAI_CODE = :PPMAICODE AND PMAI_TYPE = :PPMAITYPE';
  cSql_I_Maintenance_Param = 'INSERT INTO MAINTENANCE_PARAM (PMAI_ID, PMAI_CODE, PMAI_TYPE, PMAI_INTEGER, PMAI_FLOAT, PMAI_STRING, PMAI_INFO)' + cRC +
	                            'VALUE (SELECT ID FROM NOUVEL_ID(''MAINTENANCE_PARAM'')), :PPMAICODE, :PPMAITYPE, :PPMAIINTEGER, :PPMAIFLOAT, :PPMAISTRING, :PPMAI_INFO);';
  cSql_U_Maintenance_Param_Integer  = 'UPDATE MAINTENANCE_PARAM SET PMAI_INTEGER = :PPMAIINTEGER WHERE PMAI_CODE = :PPMAICODE AND PMAI_TYPE = :PPMAITYPE';
  cSql_U_Maintenance_Param_Float    = 'UPDATE MAINTENANCE_PARAM SET PMAI_FLOAT = :PPMAIFLOAT WHERE PMAI_CODE = :PPMAICODE AND PMAI_TYPE = :PPMAITYPE';
  cSql_U_Maintenance_Param_String   = 'UPDATE MAINTENANCE_PARAM SET PMAI_STRING = :PPMAISTRING WHERE PMAI_CODE = :PPMAICODE AND PMAI_TYPE = :PPMAITYPE';

  cSql_S_InitPostes_Dossier = 'SELECT DOSS_ID, DOSS_DATABASE, DOSS_CHEMIN FROM DOSSIER WHERE DOSS_ID <> 0';

  cSql_S_InitPostes_Magasin = 'SELECT MAGA_ID FROM MAGASINS WHERE MAGA_DOSSID = :PDOSSID AND MAGA_MAGID_GINKOIA = :PMAGID';

  cSql_S_InitPostes_Poste = 'SELECT POST_ID ' + cRC +
                            'FROM POSTES ' + cRC +
                            'JOIN MAGASINS ON MAGA_ID = POST_MAGAID ' + cRC +
                            'WHERE MAGA_DOSSID = :PDOSSID ' + cRC +
                            'AND MAGA_MAGID_GINKOIA = :PMAGID ' + cRC +
                            'AND POST_POSID = :PPOSID ';

implementation

end.

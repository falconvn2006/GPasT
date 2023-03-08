unit GEB_Type;

interface

var
  InProgress : Boolean;
  TableSocieteList : Array [1..17] of record
                                        Table : String;
                                        Field : String;
                                        ParentField : String;
                                      End =
                     (
                       (Table:'GENSOCIETE'          ;Field:'SOC_ID' ;ParentField:''),
                       (Table:'GENGESTIONPUMP'      ;Field:'GCP_ID' ;ParentField:''),
                       (Table:'GENGESTIONCLT'       ;Field:'GCL_ID' ;ParentField:''),
                       (Table:'LOCMULTITARIFS'      ;Field:'MTA_ID' ;ParentField:''),
                       (Table:'GENGESTIONCLTCPT'    ;Field:'GCC_ID' ;ParentField:''),
                       (Table:'GENGESTIONCARTEFID'  ;Field:'GCF_ID' ;ParentField:''),
                       (Table:'ARTCLASSEMENT'       ;Field:'CLA_ID' ;ParentField:''),
                       (Table:'TARVENTE'            ;Field:'TVT_ID' ;ParentField:''),
                       (Table:'GENMAGASIN'          ;Field:'MAG_ID' ;ParentField:'MAG_SOCID'),
                       (Table:'GENMAGGESTIONPUMP'   ;Field:'MPU_ID' ;ParentField:'MPU_MAGID'),
                       (Table:'GENMAGGESTIONCLT'    ;Field:'MGC_ID' ;ParentField:'MGC_MAGID'),
                       (Table:'GENMAGGESTIONCLTCPT' ;Field:'MCC_ID' ;ParentField:'MCC_MAGID'),
                       (Table:'GENMAGGESTIONCF'     ;Field:'MCF_ID' ;ParentField:'MCF_MAGID'),
                       (Table:'GENPOSTE'            ;Field:'POS_ID' ;ParentField:'POS_MAGID'),
                       (Table:'GENADRESSE'          ;Field:'ADR_ID' ;ParentField:'ADR_ID'),
                       (Table:'GENVILLE'            ;Field:'VIL_ID' ;ParentField:'VIL_ID'),
                       (Table:'GENPAYS'             ;Field:'PAY_ID' ;ParentField:'PAY_ID')
                     );

  TableEtiquetteList : Array [1..5] of record
                                        Table : String;
                                        Field : String;
                                        ParentField : String;
                                       End =
                      (
                        (Table:'GENETQTYP'    ;Field:'GET_ID' ;ParentField:''),
                        (Table:'GENETQCHAMPS' ;Field:'GEC_ID' ;ParentField:''),
                        (Table:'GENETQMOD'    ;Field:'GEM_ID' ;ParentField:'GEM_GETID'),
                        (Table:'GENETQMODC'   ;Field:'GEO_ID' ;ParentField:'GEO_GEMID'),
                        (Table:'GENETQMODL'   ;Field:'GEL_ID' ;ParentField:'GEL_GEMID')
                      );

  TableUILList : Array [1..10] of record
                                    Table : String;
                                    Field : String;
                                    ParentField : String;
                                  End =
                      (
                        (Table:'UILGROUPS'          ;Field:'GRP_ID' ;ParentField:''),
                        (Table:'UILGRPGINKOIA'      ;Field:'UGG_ID' ;ParentField:''),
                        (Table:'UILPERMISSIONS'     ;Field:'PER_ID' ;ParentField:''),
                        (Table:'UILUSERS'           ;Field:'USR_ID' ;ParentField:''),
                        (Table:'UILUSRMAG'          ;Field:'UMA_ID' ;ParentField:'UMA_MAGID;UMA_USRID'),
                        (Table:'UILGRPGINKOIAMAG'   ;Field:'UGM_ID' ;ParentField:'UGM_MAGID;UGM_UGGID'),
                        (Table:'UILGROUPMEMBERSHIP' ;Field:'GRM_ID' ;ParentField:'GRM_USRID;GRM_GRPID'),
                        (Table:'UILUSERACCESS'      ;Field:'USA_ID' ;ParentField:'USA_PERID;USA_USRID'),
                        (Table:'UILGROUPACCESS'     ;Field:'GRA_ID' ;ParentField:'GRA_PERID;GRA_GRPID'),
                        (Table:'UILGRPGINKOIAL'     ;Field:'UGL_ID' ;ParentField:'UGL_PERID;UGL_UGGID')
                      );

  TableComptaList : Array [1..7] of record
                                    Table : String;
                                    Field : String;
                                    ParentField : String;
                                  End =
                      (
                       (Table:'ARTTYPECOMPTABLE' ;Field:'TCT_ID' ;ParentField:''),
                       (Table:'ARTTVA'           ;Field:'TVA_ID';ParentField:''),
                       (Table:'GENMAGCOMPTA'     ;Field:'MCP_ID' ;ParentField:'MCP_MAGID'),
                       (Table:'ARTTVACOMPTA'     ;Field:'TVC_ID' ;ParentField:'TVC_TVAID;TVC_MAGID'),
                       (Table:'ARTCPTACHATVENTE' ;Field:'CVA_ID' ;ParentField:'CVA_TVAID;CVA_TCTID;CVA_MAGID'),
                       (Table:'CSHCOFFRE'        ;Field:'CFF_ID' ;ParentField:'CFF_MAGID'),
                       (Table:'CSHBANQUE'        ;Field:'BQE_ID' ;ParentField:'BQE_SOCID')
                      );

  TableFidList : Array [1..2] of record
                                    Table : String;
                                    Field : String;
                                    ParentField : String;
                                  End =
                      (
                       (Table:'CSHPARAMCF' ;Field:'CTF_ID' ;ParentField:'CTF_GCFID'),
                       (Table:'CSHPARAMCFL';Field:'CTL_ID';ParentField:'CTL_CTFID')
                      );

  TableRepliList : Array [1..14] of record
                              Table : String;
                              Field : String;
                              ParentField : String;
                            End =
                      (
                       (Table:'GENPROVIDERS'     ;Field:'PRO_ID' ;ParentField:''),
                       (Table:'GENSUBSCRIBERS'   ;Field:'SUB_ID' ;ParentField:''),
                       (Table:'GENLIAIREPLI'     ;Field:'GLR_ID' ;ParentField:''),
                       (Table:'GENREPLICGRP'     ;Field:'RGP_ID' ;ParentField:''),
                       (Table:'GENMAGGRP'        ;Field:'MGP_ID' ;ParentField:''),
                       (Table:'GENREPREFER'      ;Field:'RRE_ID' ;ParentField:''),
                       (Table:'GENBASES'         ;Field:'BAS_ID' ;ParentField:''),
                       (Table:'GENLAUNCH'        ;Field:'LAU_ID' ;ParentField:'LAU_BASID'),
                       (Table:'GENREPLICGRPL'    ;Field:'RGL_ID' ;ParentField:'RGL_MAGID;RGL_RGPID'),
                       (Table:'GENMAGGRPL'       ;Field:'MGL_ID' ;ParentField:'MGL_MAGID;MGL_MGPID'),
                       (Table:'GENCHANGELAUNCH'  ;Field:'CHA_ID' ;ParentField:'CHA_LAUID'),
                       (Table:'GENCONNEXION'     ;Field:'CON_ID' ;ParentField:'CON_LAUID'),
                       (Table:'GENREPLICATION'   ;Field:'REP_ID' ;ParentField:'REP_LAUID'),
                       (Table:'GENREPREFERLIGNE' ;Field:'RRL_ID' ;ParentField:'RRL_RREID')
                      );
implementation

end.

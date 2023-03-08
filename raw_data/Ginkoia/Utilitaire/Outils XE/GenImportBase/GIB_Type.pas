unit GIB_Type;

interface

uses SysUtils;
const
  CGENSOCIETE          = 1;
  CGENGESTIONPUMP      = 2;
  CGENGESTIONCLT       = 3;
  CTARVENTE            = 4;
  CGENGESTIONCLTCPT    = 5;
  CGENGESTIONCARTEFID  = 6;
  CGENPAYS             = 7;
  CGENVILLE            = 8;
  CGENADRESSE          = 9;
  CGENMAGASIN          = 10;
  CGENMAGGESTIONCF     = 11;
  CGENMAGGESTIONCLT    = 12;
  CGENMAGGESTIONCLTCPT = 13;
  CGENMAGGESTIONPUMP   = 14;
  CGENPOSTE            = 15;
  CARTCLASSEMENT      = 16;
  CMAXSOCIETE   = CARTCLASSEMENT;

  CGENETQCHAMPS = CMAXSOCIETE + 1;
  CGENETQTYP    = CMAXSOCIETE + 2;
  CGENETQMOD    = CMAXSOCIETE + 3;
  CGENETQMODC   = CMAXSOCIETE + 4;
  CGENETQMODL   = CMAXSOCIETE + 5;
  CMAXETIQUETTE = CGENETQMODL;

  CUILGROUPS          = CMAXETIQUETTE + 1;
  CUILGRPGINKOIA      = CMAXETIQUETTE + 2;
  CUILPERMISSIONS     = CMAXETIQUETTE + 3;
  CUILUSERS           = CMAXETIQUETTE + 4;
  CUILGROUPACCESS     = CMAXETIQUETTE + 5;
  CUILGROUPMEMBERSHIP = CMAXETIQUETTE + 6;
  CUILGRPGINKOIAL     = CMAXETIQUETTE + 7;
  CUILUSERACCESS      = CMAXETIQUETTE + 8;
  CUILUSRMAG          = CMAXETIQUETTE + 9;
  CUILGRPGINKOIAMAG   = CMAXETIQUETTE + 10;
  CMAXUSR             = CUILGRPGINKOIAMAG;

  CARTTYPECOMPTABLE = CMAXUSR + 1;
  CARTTVA           = CMAXUSR + 2;
  CGENMAGCOMPTA     = CMAXUSR + 3;
  CARTTVACOMPTA     = CMAXUSR + 4;
  CARTCPTACHATVENTE = CMAXUSR + 5;
  CCSHCOFFRE        = CMAXUSR + 6;
  CSHBANQUE         = CMAXUSR + 7;
  CMAXCOMPTA        = CSHBANQUE;

  CCSHPARAMCF  = CMAXCOMPTA + 1;
  CCSHPARAMCFL = CMAXCOMPTA + 2;
  CMAXFID      = CCSHPARAMCFL;

  CGENBASES         = CMAXFID + 1;
  CGENLAUNCH        = CMAXFID + 2;
  CGENREPLICGRP     = CMAXFID + 3;
  CGENMAGGRP        = CMAXFID + 4;
  CGENREPREFER      = CMAXFID + 5;
  CGENPROVIDERS     = CMAXFID + 6;
  CGENSUBSCRIBERS   = CMAXFID + 7;
  CGENREPLICATION   = CMAXFID + 8;
  CGENCHANGELAUNCH  = CMAXFID + 9;
  CGENCONNEXION     = CMAXFID + 10;
  CGENREPLICGRPL    = CMAXFID + 11;
  CGENMAGGRPL       = CMAXFID + 12;
  CGENREPREFERLIGNE = CMAXFID + 13;
  CGENLIAIREPLISUB  = CMAXFID + 14;
  CGENLIAIREPLIPRO  = CMAXFID + 15;
  CMAXREPLI         = CGENLIAIREPLIPRO;

  CMAXTABLE    = CMAXREPLI;


type
  ETABLENOTDFOUND = Class(Exception);

var
  InProgress : Boolean;

  LstCsvFile : Array [1..CMAXTABLE] of  record
                          FileName : String;
                          AddField : String;
                          Obligatoire : Boolean;
                          CheckField : String;
                        end =
               (
                  // Société 1..16
                 (FileName:'GENSOCIETE'          ;AddField:'SOC_ID';Obligatoire:True ;CheckField:'SOC_NOM'),
                 (FileName:'GENGESTIONPUMP'      ;AddField:'GCP_ID';Obligatoire:False;CheckField:'GCP_NOM'),
                 (FileName:'GENGESTIONCLT'       ;AddField:'GCL_ID';Obligatoire:True ;CheckField:'GCL_NOM'),
                 (FileName:'TARVENTE'            ;AddField:'TVT_ID';Obligatoire:True ;CheckField:'TVT_NOM'),
                 (FileName:'GENGESTIONCLTCPT'    ;AddField:'GCC_ID';Obligatoire:True ;CheckField:'GCC_NOM'),
                 (FileName:'GENGESTIONCARTEFID'  ;AddField:'GCF_ID';Obligatoire:True ;CheckField:'GCF_NOM'),
                 (FileName:'GENPAYS'             ;AddField:'PAY_ID';Obligatoire:True ;CheckField:'PAY_NOM'),
                 (FileName:'GENVILLE'            ;AddField:'VIL_ID';Obligatoire:True ;CheckField:'VIL_NOM;VIL_CP;VIL_PAYID'),
                 (FileName:'GENADRESSE'          ;AddField:'ADR_ID';Obligatoire:True ;CheckField:'ADR_LIGNE;ADR_VILID'),
                 (FileName:'GENMAGASIN'          ;AddField:'MAG_ID';Obligatoire:True ;CheckField:'MAG_IDENT;MAG_NOM;MAG_SOCID;MAG_ADRID;MAG_TVTID;MAG_GCLID'),
                 (FileName:'GENMAGGESTIONCF'     ;AddField:'MCF_ID';Obligatoire:True ;CheckField:'MCF_MAGID;MCF_GCFID'),
                 (FileName:'GENMAGGESTIONCLT'    ;AddField:'MGC_ID';Obligatoire:True ;CheckField:'MGC_MAGID;MGC_GCLID'),
                 (FileName:'GENMAGGESTIONCLTCPT' ;AddField:'MCC_ID';Obligatoire:True ;CheckField:'MCC_MAGID;MCC_GCCID'),
                 (FileName:'GENMAGGESTIONPUMP'   ;AddField:'MPU_ID';Obligatoire:False;CheckField:'MPU_MAGID;MPU_GCPID'),
                 (FileName:'GENPOSTE'            ;AddField:'POS_ID';Obligatoire:True ;CheckField:'POS_NOM;POS_MAGID'),
                 (FileName:'ARTCLASSEMENT'       ;AddField:'CLA_ID';Obligatoire:True ;CheckField:'CLA_TYPE;CLA_NUM'),
                 // Etiquettes 17..21
                 (FileName:'GENETQCHAMPS'        ;AddField:'GEC_ID';Obligatoire:True ;CheckField:'GEC_CHAMP;GEC_GETCODE'),
                 (FileName:'GENETQTYP'           ;AddField:'GET_ID';Obligatoire:True ;CheckField:'GET_NOM;GET_CODE'),
                 (FileName:'GENETQMOD'           ;AddField:'GEM_ID';Obligatoire:True ;CheckField:'GEM_NOM;GEM_GETID'),
                 (FileName:'GENETQMODC'          ;AddField:'GEO_ID';Obligatoire:True ;CheckField:'GEO_ORDRE;GEO_POS;GEO_GEMID'),
                 (FileName:'GENETQMODL'          ;AddField:'GEL_ID';Obligatoire:True ;CheckField:'GEL_CAPTION;GEL_GEMID;GEL_GECID'),
                 // User & Accés 22..31
                 (FileName:'UILGROUPS'           ;AddField:'GRP_ID';Obligatoire:True ;CheckField:'GRP_GROUPNAME'),
                 (FileName:'UILGRPGINKOIA'       ;AddField:'UGG_ID';Obligatoire:True ;CheckField:'UGG_NOM'),
                 (FileName:'UILPERMISSIONS'      ;AddField:'PER_ID';Obligatoire:True ;CheckField:'PER_PERMISSION'),
                 (FileName:'UILUSERS'            ;AddField:'USR_ID';Obligatoire:True ;CheckField:'USR_USERNAME;USR_FULLNAME;USR_CREATEDDATE'),
                 (FileName:'UILGROUPACCESS'      ;AddField:'GRA_ID';Obligatoire:True ;CheckField:'GRA_GROUPNAME;GRA_PERID;GRA_GRPID'),
                 (FileName:'UILGROUPMEMBERSHIP'  ;AddField:'GRM_ID';Obligatoire:True ;CheckField:'GRM_USERNAME;GRM_GROUPNAME;GRM_USRID;GRM_GRPID'),
                 (FileName:'UILGRPGINKOIAL'      ;AddField:'UGL_ID';Obligatoire:True ;CheckField:'UGL_UGGID;UGL_PERID'),
                 (FileName:'UILUSERACCESS'       ;AddField:'USA_ID';Obligatoire:True ;CheckField:'USA_PERID;USA_USRID'), // USA_USERNAME;
                 (FileName:'UILUSRMAG'           ;AddField:'UMA_ID';Obligatoire:False;CheckField:'UMA_USRID;UMA_MAGID'),
                 (FileName:'UILGRPGINKOIAMAG'    ;AddField:'UGM_ID';Obligatoire:True ;CheckField:'UGM_DATE;UGM_MAGID;UGM_UGGID'),
                 // Export compta 32..38
                 (FileName:'ARTTYPECOMPTABLE'    ;AddField:'TCT_ID';Obligatoire:True ;CheckField:'TCT_NOM;TCT_CODE'),
                 (FileName:'ARTTVA'              ;AddField:'TVA_ID';Obligatoire:True ;CheckField:'TVA_CODE'),
                 (FileName:'GENMAGCOMPTA'        ;AddField:'MCP_ID';Obligatoire:True ;Checkfield:'MCP_TYPE;MCP_NOMSOC;MCP_CPTFOURN;MCP_MAGID'),
                 (FileName:'ARTTVACOMPTA'        ;Addfield:'TVC_ID';Obligatoire:True ;CheckField:'TVC_CPTVTE;TVC_CPTACHAT;TVC_TVAID;TVC_MAGID'),
                 (FileName:'ARTCPTACHATVENTE'    ;AddField:'CVA_ID';Obligatoire:True ;CheckField:'CVA_TVAID;CVA_TCTID;CVA_MAGID'),
                 (FileName:'CSHCOFFRE'           ;AddField:'CFF_ID';Obligatoire:True ;CheckField:'CFF_NOM;CFF_MAGID'),
                 (FileName:'CSHBANQUE'           ;AddField:'BQE_ID';Obligatoire:True ;CheckField:'BQE_NOM;BQE_SOCID'),
                 // fidélité 39..40
                 (FileName:'CSHPARAMCF'          ;AddField:'CTF_ID';Obligatoire:False;CheckField:'CTF_GCFID'),
                 (FileName:'CSHPARAMCFL'         ;AddField:'CTL_ID';Obligatoire:False;CheckField:'CTL_POINT;CTL_CTFID'),
                 // Réplication 41 .. 55
                 (FileName:'GENBASES'            ;AddField:'BAS_ID';Obligatoire:False;CheckField:'BAS_NOM;BAS_IDENT;BAS_MAGID'),
                 (FileName:'GENLAUNCH'           ;AddField:'LAU_ID';Obligatoire:False;CheckField:'LAU_BASID'),
                 (FileName:'GENREPLICGRP'        ;AddField:'RGP_ID';Obligatoire:False;CheckField:'RGP_NOM'),
                 (FileName:'GENMAGGRP'           ;AddField:'MGP_ID';Obligatoire:False;CheckField:'MGP_NOM'),
                 (FileName:'GENREPREFER'         ;AddField:'RRE_ID';Obligatoire:False;CheckField:'RRE_POSITION;RRE_PLACE;RRE_URL'),
                 (FileName:'GENPROVIDERS'        ;AddField:'PRO_ID';Obligatoire:False;CheckField:'PRO_NOM'),
                 (FileName:'GENSUBSCRIBERS'      ;AddField:'SUB_ID';Obligatoire:False;CheckField:'SUB_NOM'),
                 (FileName:'GENREPLICATION'      ;AddField:'REP_ID';Obligatoire:False;CheckField:'REP_LAUID'),
                 (FileName:'GENCHANGELAUNCH'     ;AddField:'CHA_ID';Obligatoire:False;CheckField:'CHA_LAUID'),
                 (FileName:'GENCONNEXION'        ;AddField:'CON_ID';Obligatoire:False;CheckField:'CON_NOM;CON_LAUID'),
                 (FileName:'GENREPLICGRPL'       ;AddField:'RGL_ID';Obligatoire:False;CheckField:'RGL_MAGID;RGL_RGPID'),
                 (FileName:'GENMAGGRPL'          ;AddField:'MGL_ID';Obligatoire:False;CheckField:'MGL_MAGID;MGL_MGPID'),
                 (FileName:'GENREPREFERLIGNE'    ;AddField:'RRL_ID';Obligatoire:False;CheckField:'RRL_RREID'),
                 (FileName:'GENLIAIREPLI'        ;AddField:'GLR_ID';Obligatoire:False;CheckField:'GLR_PROSUBID;GLR_REPID'),
                 (FileName:'GENLIAIREPLI'        ;AddField:'GLR_ID';Obligatoire:False;CheckField:'GLR_PROSUBID;GLR_REPID')
               );
implementation

end.

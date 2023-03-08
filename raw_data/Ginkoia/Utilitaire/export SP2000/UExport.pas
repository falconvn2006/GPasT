//$Log:
// 60   Utilitaires1.59        22/11/2017 10:43:02    Lionel Plais    Version
//      14.0.0.27 : Passage du champ TKE_NUMERO ? 26 caract?res. Correction.
// 59   Utilitaires1.58        20/11/2017 11:40:29    Lionel Plais    Version
//      14.0.0.26 : Passage du champ TKE_NUMERO ? 26 caract?res.
// 58   Utilitaires1.57        02/01/2017 16:36:02    Gilles Riand    Ajout de
//      Logs et optimisation  
// 57   Utilitaires1.56        13/12/2016 16:38:32    Ludovic MASSE   CDC ?
//      Sport 2000 Extraction fid?lit?
// 56   Utilitaires1.55        13/12/2016 16:36:51    Ludovic MASSE   CDC ?
//      Sport 2000 Extraction fid?lit?
// 55   Utilitaires1.54        13/12/2016 16:29:35    Ludovic MASSE   CDC ?
//      Sport 2000 Extraction fid?lit?
// 54   Utilitaires1.53        29/08/2014 17:23:12    Lionel Plais    Remise en
//      place du test de l'existance de ARTRELATIONAXE.
// 53   Utilitaires1.52        29/08/2014 17:14:18    Lionel Plais    Prend en
//      compte les version sup?rieures ou ?gales ? la version 13 pour utiliser
//      ARTRELATIONAXE.
// 52   Utilitaires1.51        29/08/2014 16:28:07    Lionel Plais    Ajout de
//      la jointure sur NKLACTIVITE et de la jointure sur K pour
//      ARTRELATIONAXE.
// 51   Utilitaires1.50        28/08/2014 16:26:20    Lionel Plais   
//      Utilisation de la table ARTRELATIONAXE pour les bases l'utilisant.
// 50   Utilitaires1.49        21/02/2013 18:20:25    Sylvain ROSSET 
//      Correction, ajout d'un caract?re.
// 49   Utilitaires1.48        12/02/2013 18:16:30    Sylvain ROSSET  Ajout
//      d'un Boolean pour rendre la loc Actif ou pas.
// 48   Utilitaires1.47        12/02/2013 18:01:22    Sylvain ROSSET 
//      Correction Be-Collector
// 47   Utilitaires1.46        17/12/2012 17:04:02    Sylvain ROSSET  Mise ?
//      jour du Be Collector
// 46   Utilitaires1.45        17/12/2012 15:52:20    Sylvain ROSSET  Mise ?
//      jour
// 45   Utilitaires1.44        17/12/2012 11:38:29    Sylvain ROSSET  Ajout de
//      la loc pour la becollector
// 44   Utilitaires1.43        29/10/2012 14:13:17    Thierry Fleisch
//      Suppression du traitement colombus car obsol?te
// 43   Utilitaires1.42        17/07/2012 16:44:36    Thierry Fleisch
//      Corrections probl?me avec millisecondes mal g?rer par les query
// 42   Utilitaires1.41        17/07/2012 12:06:17    Thierry Fleisch
//      Correction suppl?mentaire apr?s test avec stan
// 41   Utilitaires1.40        17/07/2012 11:26:07    Thierry Fleisch
//      Correction probl?me heure
// 40   Utilitaires1.39        16/07/2012 15:57:29    Sylvain ROSSET 
//      BeCollector
// 39   Utilitaires1.38        09/11/2009 13:24:54    Lionel ABRY     Valeur
//      absolue de la valeur discount et non du prix unitaire
// 38   Utilitaires1.37        14/10/2009 11:27:50    Lionel ABRY     Rollback
//      sur les modifs concernant mag_lastexp
// 37   Utilitaires1.36        13/10/2009 11:48:22    Lionel ABRY    
//      chemColombus en dur !
// 36   Utilitaires1.35        13/10/2009 11:41:33    Lionel ABRY    
//      Correction probl?me maj mag_lastexp si plantage
// 35   Utilitaires1.34        09/10/2009 10:40:40    Lionel ABRY    
//      correction prix untaire : renvoy? en valeur absolue dans les exports
//      depuis colombus et ginkoia
// 34   Utilitaires1.33        24/08/2009 09:53:38    Lionel ABRY     Ai
//      d?plac? le code permettant de d?placer la fichier csv dans le
//      r?pertoire ok.
//      Il y avait un risque que cela ne soit pas fait si exception lorsqu'on
//      met ? jour l'historique dans la base....
// 33   Utilitaires1.32        10/07/2009 11:19:31    Lionel ABRY    
//      Correction pb indice hors limite sur fichiers vides
// 32   Utilitaires1.31        03/07/2009 12:02:21    Lionel ABRY     D?calage
//      de la derni?re ent?te lorsqu'une carte becoll est rejet?e
// 31   Utilitaires1.30        17/06/2009 14:51:36    Lionel ABRY     Retour ?
//      la version migr?e
// 30   Utilitaires1.29        17/06/2009 14:29:12    Lionel ABRY    
//      S?paration D5-D11
// 29   Utilitaires1.28        15/06/2009 09:35:09    Lionel ABRY     Extension
//      des modifs d'espaces entre lignenum et num coupon au code de pascal
// 28   Utilitaires1.27        12/06/2009 16:15:39    Lionel ABRY     Ajout
//      correction bug colombus :
//      Comme convenu par t?l?phone :
//      
//      Lors du traitement des transactions becollector et avant envoi a
//      Accentiv il faut exclure les transactions qui ne correspondent pas au
//      sch?ma suivant :
//      
//      N? de carte : champs num?rique de 13 caract?res num?riques (pas plus,
//      pas moins) commen?ant par 256 ou 258.
//      N? de coupon : champs num?rique de 13 caract?res num?riques (pas plus,
//      pas moins) commen?ant par 257 ou 259.
// 27   Utilitaires1.26        10/06/2009 14:15:43    Lionel ABRY     ajout
//      icone
// 26   Utilitaires1.25        10/06/2009 11:01:43    Lionel ABRY    
//      migrationD2007 et correction de bug
// 25   Utilitaires1.24        15/04/2009 15:10:17    Florent CHEVILLON
//      correction bug 'coupon' suite
// 24   Utilitaires1.23        15/04/2009 13:53:52    Florent CHEVILLON
//      correction bug coupon
// 23   Utilitaires1.22        12/03/2009 17:34:42    Florent CHEVILLON MV MONDO
// 22   Utilitaires1.21        12/03/2009 15:01:09    Florent CHEVILLON modif
//      regle de gestion pour cas FEDAS
// 21   Utilitaires1.20        11/03/2009 11:36:57    Florent CHEVILLON version
//      prod
// 20   Utilitaires1.19        25/02/2009 12:41:05    Florent CHEVILLON
//      Traitement FEDAS
// 19   Utilitaires1.18        20/02/2009 09:57:57    Florent CHEVILLON
//      Historisation et corrections bug suite aux test
//      Version completes avec le traitement des bases actifs
// 18   Utilitaires1.17        19/02/2009 11:41:09    Florent CHEVILLON Version
//      avant test sur lame2
// 17   Utilitaires1.16        18/02/2009 17:33:58    Florent CHEVILLON sleep()
// 16   Utilitaires1.15        18/02/2009 13:17:34    Florent CHEVILLON Encours
//      de dev colombus
//      bug cr?ation fichiers
// 15   Utilitaires1.14        16/10/2007 16:51:45    Sandrine MEDEIROS mettre
//      l'email de stan au lieu de pascal + dev@ginkoia.fr
// 14   Utilitaires1.13        29/03/2007 12:50:27    pascal          rendu par
//      sandrine pendant que pascal ?tait malade
// 13   Utilitaires1.12        07/12/2006 15:40:20    pascal          recup des
//      b?tises diverses
// 12   Utilitaires1.11        05/12/2006 14:41:05    Sandrine MEDEIROS les
//      envois de fichiers ?taient en commentaire....
//      Changement de composant dans le thread
// 11   Utilitaires1.10        07/11/2006 17:02:06    pascal          modif
//      pour ne pas mettre fedas encore
// 10   Utilitaires1.9         07/11/2006 14:44:57    pascal         
//      Modification des codes barre suite ? l'erreur de Sp2000
// 9    Utilitaires1.8         24/10/2006 13:52:36    Sandrine MEDEIROS Mise en
//      place export FEDAS
// 8    Utilitaires1.7         18/10/2006 09:57:01    pascal          Ajout
//      fedas dans l'export
// 7    Utilitaires1.6         29/09/2006 09:32:58    Sandrine MEDEIROS mise en
//      place du Blade
// 6    Utilitaires1.5         25/01/2006 15:00:07    pascal          Modif
//      suite aux modification de SP2000
// 5    Utilitaires1.4         18/11/2005 09:30:49    pascal          Suite ?
//      demande, on ne prend plus les mouvements non tagg?s par un CB
// 4    Utilitaires1.3         07/11/2005 09:02:16    pascal         
//      Modification du message d'envois en fin d'export et ajout historique si
//      rien n'est ?mis
// 3    Utilitaires1.2         27/10/2005 15:35:13    pascal          Modif
//      demand?es par sandrine
// 2    Utilitaires1.1         11/08/2005 11:40:26    pascal         
//      Modification suite echange de mail
// 1    Utilitaires1.0         08/08/2005 09:06:55    pascal          
//$
//$NoKeywords$
//
UNIT UExport;

INTERFACE

USES
  Windows, StdCtrls, Controls, ComCtrls, Classes, Forms, SysUtils, StrUtils,
  //Début Uses Perso
  DateUtils,
  FtpThread,
  inifiles,
  //Fin Uses Perso
  DB, IBSQL, IBCustomDataSet, IBQuery, IBDatabase, dxmdaset, ExtCtrls;

  //IdFTP,
  //Messages,
  //StdCtrls,
  //Dialogs,
  //rxFileutil,
  //Graphics;
  //Psock,
  //NMFtp,  migration D2007;

TYPE
  TFrm_ExportSP2000 = CLASS (TForm)
    IBQue_Select: TIBQuery;
    IBQue_SelectMAG_CODEADH: TIBStringField;
    IBQue_SelectTKE_ID: TIntegerField;
    IBQue_SelectMAG_IDENT: TIBStringField;
    IBQue_SelectMAG_ENSEIGNE: TIBStringField;
    IBQue_SelectTKE_TOTNETA1: TFloatField;
    IBQue_SelectTKE_DATE: TDateTimeField;
    IBQue_CBClt: TIBQuery;
    IBQue_CBCltCCB_CB: TIBStringField;
    IBQue_Ligne: TIBQuery;
    IBQue_LigneARF_CHRONO: TIBStringField;
    IBQue_LigneART_REFMRK: TIBStringField;
    IBQue_LigneMRK_NOM: TIBStringField;
    IBQue_LigneRAY_IDREF: TIntegerField;
    IBQue_LigneRAY_NOM: TIBStringField;
    IBQue_LigneTKL_QTE: TFloatField;
    IBQue_LigneTKL_PXBRUT: TFloatField;
    IBQue_LigneTKL_TVA: TFloatField;
    IBQue_LigneMRK_ID: TIntegerField;
    IBQue_LigneREMISE: TFloatField;
    IBQue_CB2: TIBQuery;
    IBQue_CB2CCB_CB: TIBStringField;
    IBQue_CB1: TIBQuery;
    IBQue_CB1CCB_CB: TIBStringField;
    IBQue_FOU: TIBQuery;
    IBQue_FOUFOU_NOM: TIBStringField;
    data: TIBDatabase;
    tran: TIBTransaction;
    DataClt: TIBDatabase;
    TranClt: TIBTransaction;
    IBQue_Lesbases: TIBQuery;
    IBQue_LesbasesBDE_PATH: TIBStringField;
    IBQue_LesbasesMAG_GINKOID: TIntegerField;
    IBQue_LesbasesMAG_ID: TIntegerField;
    IBQue_LesbasesMAG_LASTEXP: TDateTimeField;
    Lab_Etat: TLabel;
    PB: TProgressBar;
    IBQue_Comptebase: TIBQuery;
    IBQue_ComptebaseNBR: TIntegerField;
    IBQue_LesbasesBDE_NOM: TIBStringField;
    IBQue_LesbasesMAG_NOM: TIBStringField;
    IBQue_SelectTKE_NUMERO: TIBStringField;
    sql: TIBSQL;
    IBQue_Date: TIBQuery;
    req: TIBQuery;
    IBQue_Fedas: TIBQuery;
    IBQue_FedasSSF_ID: TIntegerField;
    IBQue_LigneSSF_IDREF: TIntegerField;
    IBQue_LigneSEC_NOM: TStringField;
    IBQue_LesbasesBDE_INTEGRE: TIntegerField;
    qftp: TIBQuery;
    sqlFtp: TIBSQL;
    TransIntegre: TIBTransaction;
    IBQue_Mag: TIBQuery;
    sqlNewMag: TIBSQL;
    memData: TdxMemData;
    memDataMAGASIN: TStringField;
    memDataLIBELLEMAGASIN: TStringField;
    memDataETABLISSEMENT: TStringField;
    memDataLIBELLEETABLISSEMENT: TStringField;
    memDataNUMEROTICKET: TStringField;
    memDataDATEDOCUMENT: TStringField;
    memDataHEUREVALIDATION: TStringField;
    memDataCARTEBECOLLECTOR: TStringField;
    memDataNUMCOUPON: TStringField;
    memDataNUMLIGNETICKET: TStringField;
    memDataREFPRODUITFOURNISSEUR: TStringField;
    memDataPRODUIT: TStringField;
    memDataLIBELLEPRODUIT: TStringField;
    memDataFOURNISSEURPRODUIT: TStringField;
    memDataLIBELLEFOURNISSEURPRODUIT: TStringField;
    memDataMARQUE: TStringField;
    memDataACTIVITE: TStringField;
    memDataENSEIGNEETABLISSEMENT: TStringField;
    memDataQTEVTEMAG: TStringField;
    memDataPRIXUNITAIRE: TStringField;
    memDataREMISEVENTE: TStringField;
    memDataTXTVA: TStringField;
    memDataCATTCMAG: TStringField;
    IBQue_MagMAG_ID: TIntegerField;
    IBQue_DateMAX_DATE: TDateTimeField;
    IBQue_SelectTKE_TOTBRUTA2: TFloatField;
    IBQue_SelectREMISE: TFloatField;
    IBQue_TVALoc: TIBQuery;
    IBQue_TVALocLOA_TXTVA: TFloatField;
    IBQue_VerifARTRELATIONAXE: TIBQuery;
    IBQue_LigneSSF_CODENIV: TIBStringField;
    tmr1: TTimer;
    IBQue_LigneUNI_NOM: TIBStringField;
    PROCEDURE FormCreate (Sender: TObject) ;
    PROCEDURE FormDestroy (Sender: TObject) ;
    procedure FormShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  PRIVATE
    FCanClose     : boolean;
    ftp           : TFtpThread;
    first         : Boolean;
    Lemessage     : TstringList;
    LocActif,                     //Si vrai la loc est active.
    SendFTP,                      //Si vrai envoie sur FTP.
    SendMail      : Boolean;      //Si vrai envoie du mail.
    AdrMail_Dest  : string;       //Liste des adresses mail pour l'envoie du mail Destinataire.
    AdrMail_CC    : string;       //Liste des adresses mail pour l'envoie du mail Copie Carbonne.
    procedure traite(LaBase: STRING; MAGID: integer; De, A: tdateTime; Exp_magid: integer);
    procedure VasY;
    PROCEDURE Traitement_AUto;
//    chemColombus: STRING; //chemin vers le répertoire colombus local
//    PROCEDURE traiteColombus () ; //lab traitement des intégrés utilisant Colombus : opération sur fichier txt récupèré sur ftp Colombus
//    FUNCTION importerColombus () : Boolean;
//    FUNCTION doTranspoColombus (Afile: STRING; VAR exportFichier: STRING; codeAdh: STRING; VAR size: Integer) : Boolean;
//    FUNCTION verifierMag (magNom: STRING) : Integer;
//    FUNCTION StringToFloat (s: STRING) : double;
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
    procedure ftponfinifichier(fichier: STRING);
  END;

VAR
  Frm_ExportSP2000: TFrm_ExportSP2000;

IMPLEMENTATION

USES UPost,GestionLog; // migration D2007

{$R *.DFM}

procedure SetLengthStuff(var S: string; NewLength: Integer; CharFill: Char);
var
   OldLength: Integer;
begin
   if Length(S) < NewLength then
   begin
      OldLength := Length(S);
      SetLength(S, NewLength);
      FillMemory(@S[OldLength + 1], NewLength - (OldLength), Byte(CharFill));
   end;
end;

function CopyStuff(const S: string; NewLength: Integer; CharFill: Char): string;
begin
   if Length(S) >= NewLength then
   begin
      Result := S;
   end else
   begin
      SetLength(Result, Length(S));
      CopyMemory(@Result[1], @S[1], Length(S));
      SetLengthStuff(Result, NewLength, CharFill);
   end;
end;

procedure TFrm_ExportSP2000.tmr1Timer(Sender: TObject);
begin
    tmr1.Enabled:=false;
    FCanClose := false;
    Traitement_AUto;
end;

PROCEDURE TFrm_ExportSP2000.traite (LaBase: STRING; MAGID: integer; De, A: tdateTime; Exp_magid: integer) ;
VAR
  codeadh: STRING;
  fichier: TstringList;
  CB: STRING;
  ini: Tinifile;
  num: integer;
  Lig: Integer;
  S: STRING;
  aprendre: boolean;
  bUtiliseARTRELATIONAXE: Boolean;
  sVersion: String;
  iVersion: Integer;
  //   Fedas: boolean;
BEGIN
  //création du fichier SP2000 en fonction des infos contenu dans la base du magasin
  Log_Write('Traite ' + Format('%s|%d|%s|%s',[Labase,
                      MAGID,
                      FormatDateTime('dd/mm/yyyy hh:nn:ss',De),
                      FormatDateTime('dd/mm/yyyy hh:nn:ss',A)
                      ])
            ,el_Info);
  data.DatabaseName := LaBase;
  try
  data.Open;
  TRY
    // Vérifie si la base utilise la table ARTRELATIONAXE
    bUtiliseARTRELATIONAXE := False;
    IBQue_VerifARTRELATIONAXE.SQL.Clear();
    IBQue_VerifARTRELATIONAXE.SQL.Add('SELECT RDB$RELATION_NAME');
    IBQue_VerifARTRELATIONAXE.SQL.Add('FROM   RDB$RELATIONS');
    IBQue_VerifARTRELATIONAXE.SQL.Add('WHERE  RDB$RELATION_NAME = ''ARTRELATIONAXE''');
    IBQue_VerifARTRELATIONAXE.Open();

    if IBQue_VerifARTRELATIONAXE.RecordCount > 0 then
    begin
      IBQue_VerifARTRELATIONAXE.Close();
      IBQue_VerifARTRELATIONAXE.SQL.Clear();
      IBQue_VerifARTRELATIONAXE.SQL.Add('SELECT VER_VERSION');
      IBQue_VerifARTRELATIONAXE.SQL.Add('FROM   GENVERSION');
      IBQue_VerifARTRELATIONAXE.SQL.Add('ORDER  BY VER_DATE DESC ROWS 1;');
      IBQue_VerifARTRELATIONAXE.Open();

      if IBQue_VerifARTRELATIONAXE.RecordCount > 0 then
      begin
        sVersion := IBQue_VerifARTRELATIONAXE.FieldByName('VER_VERSION').AsString;
        if TryStrToInt(LeftStr(sVersion, Pos('.', sVersion) - 1), iVersion) then
          bUtiliseARTRELATIONAXE := iVersion >= 13;
      end;
    end;
    // Mon test
    // bUtiliseARTRELATIONAXE := false;
    // Modifie la requête d'extraction des lignes en fonction de l'usage de ARTRELATIONAXE
    if bUtiliseARTRELATIONAXE then
    begin
      Log_Write('Avec ARTRELATIONAXE',el_Info);
      IBQue_Ligne.SQL.Clear();
      IBQue_Ligne.SQL.Add('SELECT ARF_CHRONO, ART_REFMRK, MRK_ID, MRK_NOM, RAY_IDREF, RAY_NOM, TKL_QTE, TKL_PXBRUT,');
      IBQue_Ligne.SQL.Add('       TKL_QTE * TKL_PXBRUT - TKL_PXNET REMISE, TKL_TVA, SSF_IDREF, UPPER(SEC_NOM) SEC_NOM, UNI_NOM, SSF_CODENIV ');
      IBQue_Ligne.SQL.Add('FROM CSHTICKETL');
      IBQue_Ligne.SQL.Add('  JOIN ARTARTICLE ON (ART_ID = TKL_ARTID)');
      IBQue_Ligne.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = ART_ID)');
      IBQue_Ligne.SQL.Add('  JOIN ARTMARQUE ON (MRK_ID = ART_MRKID)');
      IBQue_Ligne.SQL.Add('  JOIN ARTRELATIONAXE ON (ARX_ARTID = ART_ID)');
      IBQue_Ligne.SQL.Add('  JOIN K ON (K_ID = ARX_ID AND K_ENABLED = 1)');
      IBQue_Ligne.SQL.Add('  JOIN NKLSSFAMILLE ON (SSF_ID = ARX_SSFID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLFAMILLE ON (FAM_ID = SSF_FAMID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLRAYON ON (RAY_ID = FAM_RAYID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLACTIVITE ON (ACT_ID = ART_ACTID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLUNIVERS ON (UNI_ID = SEC_UNIID)');
      IBQue_Ligne.SQL.Add('WHERE TKL_SSTOTAL = 0');
      IBQue_Ligne.SQL.Add('  AND TKL_TKEID = :ID');
      IBQue_Ligne.SQL.Add('  AND TKL_ARTID <> 0;');
    end
    else begin
      Log_Write('Sans ARTRELATIONAXE',el_Info);
      IBQue_Ligne.SQL.Clear();
      IBQue_Ligne.SQL.Add('SELECT ARF_CHRONO, ART_REFMRK, MRK_ID, MRK_NOM, RAY_IDREF, RAY_NOM, TKL_QTE, TKL_PXBRUT,');
      IBQue_Ligne.SQL.Add('       TKL_QTE * TKL_PXBRUT - TKL_PXNET REMISE, TKL_TVA, SSF_IDREF, UPPER(SEC_NOM) SEC_NOM, CAST('''' AS varchar(64)) UNI_NOM, SSF_CODENIV ');
      IBQue_Ligne.SQL.Add('FROM CSHTICKETL');
      IBQue_Ligne.SQL.Add('  JOIN ARTARTICLE ON (ART_ID = TKL_ARTID)');
      IBQue_Ligne.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = ART_ID)');
      IBQue_Ligne.SQL.Add('  JOIN ARTMARQUE ON (MRK_ID = ART_MRKID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLSSFAMILLE ON (SSF_ID = ART_SSFID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLFAMILLE ON (FAM_ID = SSF_FAMID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLRAYON ON (RAY_ID = FAM_RAYID)');
      IBQue_Ligne.SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID)');
      IBQue_Ligne.SQL.Add('WHERE TKL_SSTOTAL = 0');
      IBQue_Ligne.SQL.Add('  AND TKL_TKEID = :ID');
      IBQue_Ligne.SQL.Add('  AND TKL_ARTID <> 0;');
    end;

    //      IBQue_Fedas.Open;
    //      Fedas := not (IBQue_Fedas.IsEmpty);
    //      IBQue_Fedas.Close;
    codeadh := ' début avant fichier ';
    ini := Tinifile.Create (changefileext (application.exename, '.ini') ) ;
    Num := ini.readinteger ('param', 'numero', 1) ;

    IBQue_Select.ParamByName ('MAGID') .AsInteger := MAGID;
    IBQue_Select.ParamByName ('DATEDEB') .AsDateTime := de;
    IBQue_Select.ParamByName ('DATEFIN') .AsDateTime := A;
    IBQue_Select.open;
    IBQue_Select.first;
    fichier := NIL;
    Lemessage.add ('extraction de ' + LaBase) ;
    WHILE (NOT IBQue_Select.eof) AND (NOT(IBQue_SelectMAG_CODEADH.isnull or (IBQue_Select.FieldByName('MAG_CODEADH').AsString = ''))) DO
    BEGIN
      aprendre := false;
      IBQue_CBClt.parambyname ('ID') .AsInteger := IBQue_SelectTKE_ID.AsInteger;
      IBQue_CBClt.Open;
      IF NOT (IBQue_CBClt.isempty) THEN
        aprendre := true;

      CB := Copy (IBQue_CBCltCCB_CB.AsString + '                           ', 1, 13) ;
      IBQue_CBClt.Close;
      IBQue_CB1.Close;
      IBQue_CB1.parambyname ('ID') .AsInteger := IBQue_SelectTKE_ID.AsInteger;
      IBQue_CB1.Open;
      IF NOT (IBQue_CB1.isempty) THEN
        aprendre := true;

      IBQue_CB2.close;
      IBQue_CB2.parambyname ('ID') .AsInteger := IBQue_SelectTKE_ID.AsInteger;
      IBQue_CB2.Open;
      IF NOT (IBQue_CB2.isempty) THEN
        aprendre := true;

      IF aprendre THEN
      BEGIN
        IBQue_Ligne.Close;
        IBQue_Ligne.parambyname ('ID') .AsInteger := IBQue_SelectTKE_ID.AsInteger;
        IBQue_Ligne.Open;

        IF codeadh <> IBQue_SelectMAG_CODEADH.AsString THEN
        BEGIN
          fichier := tstringlist.create;
          CodeAdh := IBQue_SelectMAG_CODEADH.AsString;
          fichier.add (format ('%8d', [Num]) + FormatDateTime ('ddmmyyyy', Now) + FormatDateTime ('hhnnss', Now) + Copy (codeadh + '        ', 1, 6) ) ;
        END;
        IF ((NOT IBQue_CB1.eof) AND (NOT IBQue_CB1CCB_CB.isnull) ) OR
          ((NOT IBQue_CB2.eof) AND (NOT IBQue_CB2CCB_CB.isnull) ) OR
          ((NOT IBQue_Ligne.eof) AND (NOT IBQue_LigneARF_CHRONO.Isnull) ) OR
          ((IBQue_SelectTKE_TOTBRUTA2.AsFloat <> 0 ) And LocActif) THEN                           //Ajout de la loc
        BEGIN
          fichier.add ('ET' + Copy (IBQue_SelectTKE_NUMERO.AsString + DupeString(' ', 26), 1, 26) +
            copy (IBQue_SelectMAG_CODEADH.AsString + '      ', 1, 6) +
            copy (IBQue_SelectMAG_ENSEIGNE.AsString + '                                                                    ', 1, 64) +
            FormatDateTime ('ddmmyyyy', IBQue_SelectTKE_DATE.AsDateTime) +
            FormatDateTime ('hhnnss', IBQue_SelectTKE_DATE.AsDateTime) +
            Cb +
            format ('%17.2f', [IBQue_SelectTKE_TOTNETA1.AsFloat]) ) ;
          lig := 1;

          WHILE (NOT IBQue_CB1.eof) AND (NOT IBQue_CB1CCB_CB.isnull) DO
          BEGIN
            CB := Copy (IBQue_CB1CCB_CB.AsString + '                           ', 1, 14) ;        //SR - 21/02/2013 - Passage de 13 à 14
            fichier.add ('LT' + Copy (IBQue_SelectTKE_NUMERO.AsString + DupeString(' ', 26), 1, 26) +
              copy (IBQue_SelectMAG_CODEADH.AsString + '      ', 1, 6) +
              format ('%9d', [lig]) +
              //Copy('                                               ', 1, 13) +  //lab séparation entre le numéro de la ligne et le numéro du coupon
              CB +
              Copy ('                                               ', 1, 15) +
              Copy ('                                               ', 1, 15) +
              Copy ('                                                                                   ', 1, 64) +
              Copy ('                                                                                   ', 1, 64) +
              Copy ('                                               ', 1, 9) +
              Copy ('                                                                                   ', 1, 64) +
              Copy ('                                               ', 1, 11) +
              Copy ('                                               ', 1, 10) +
              Copy ('                                               ', 1, 10) +
              Copy ('                                               ', 1, 5) ) ;
            inc (lig) ;
            IBQue_CB1.next;
          END;
          IBQue_CB1.close;
          WHILE (NOT IBQue_CB2.eof) AND (NOT IBQue_CB2CCB_CB.isnull) DO
          BEGIN
            CB := Copy (IBQue_CB2CCB_CB.AsString + '                           ', 1, 14) ;          //SR - 21/02/2013 - Passage de 13 à 14
            fichier.add ('LT' + Copy (IBQue_SelectTKE_NUMERO.AsString + DupeString(' ', 26), 1, 26) +
              copy (IBQue_SelectMAG_CODEADH.AsString + '      ', 1, 6) +
              format ('%9d', [lig]) +
              //Copy('                                               ', 1, 13) +  //lab séparation entre le numéro de la ligne et le numéro du coupon
              CB +
              Copy ('                                               ', 1, 15) +
              Copy ('                                               ', 1, 15) +
              Copy ('                                                                                   ', 1, 64) +
              Copy ('                                                                                   ', 1, 64) +
              Copy ('                                               ', 1, 9) +
              Copy ('                                                                                   ', 1, 64) +
              Copy ('                                               ', 1, 11) +
              Copy ('                                               ', 1, 10) +
              Copy ('                                               ', 1, 10) +
              Copy ('                                               ', 1, 5) ) ;
            inc (lig) ;
            IBQue_CB2.next;
          END;
          IBQue_CB2.close;

          WHILE (NOT IBQue_Ligne.eof) AND (NOT IBQue_LigneARF_CHRONO.Isnull) DO
          BEGIN
            IBQue_FOU.ParamByName ('ID') .AsInteger := IBQue_LigneMRK_ID.AsInteger;
            IBQue_FOU.Open;

            S := 'LT' + Copy (IBQue_SelectTKE_NUMERO.AsString + DupeString(' ', 26), 1, 26) +
              copy (IBQue_SelectMAG_CODEADH.AsString + '      ', 1, 6) +
              format ('%9d', [lig]) +
              Copy ('                                               ', 1, 13) +
              Copy (IBQue_LigneARF_CHRONO.AsString + '                                               ', 1, 15) +
              Copy (IBQue_LigneART_REFMRK.AsString + '                                               ', 1, 15) +
              Copy (IBQue_FOUFOU_NOM.AsString + '                                                                                   ', 1, 64) +
              Copy (IBQue_LigneMRK_NOM.AsString + '                                                                                   ', 1, 64) ;
            // on reste dans le dégueulasse, pas le temps de réécrire
            if bUtiliseARTRELATIONAXE then
            begin
              if (IBQue_LigneUNI_NOM.AsString = 'FEDAS') then
              begin
                S := S + Copy(IBQue_LigneSSF_CODENIV.AsString + '                                               ', 1, 9) +
                   Copy (IBQue_LigneRAY_NOM.AsString + '                                                             ', 1, 64);
              end
              else
              begin
                S := S + Copy ('0' + '                                               ', 1, 9) +
                  Copy (IBQue_LigneRAY_NOM.AsString + '                                                                                   ', 1, 64) ;
              end;
            end
            else
            begin
              if (IBQue_LigneSEC_NOM.AsString = 'FEDAS') then
              begin
                S := S + Copy(IBQue_LigneSSF_IDREF.AsString + '                                               ', 1, 9) +
                  Copy('FEDAS' + '                                                                                   ', 1, 64);
              end
              else
              begin
                S := S + Copy ('0' + '                                               ', 1, 9) +
                  Copy (IBQue_LigneRAY_NOM.AsString + '                                                                                   ', 1, 64) ;
              end;
            end;
            ////////////
            S := S + format ('%11.3f', [IBQue_LigneTKL_QTE.AsFloat]) +
              format ('%10.2f', [IBQue_LigneTKL_PXBRUT.AsFloat]) +
              format ('%10.2f', [abs(IBQue_LigneREMISE.AsFloat)]) +
              format ('%6.3f', [IBQue_LigneTKL_TVA.AsFloat]) ;
            fichier.add (S) ;
            IBQue_FOU.Close;
            inc (lig) ;
            IBQue_Ligne.Next;
          END;
          IBQue_Ligne.close;

          //Ajout de la location SR - 10/12/2012
          if IBQue_SelectTKE_TOTBRUTA2.AsFloat <> 0 then
          begin
            IBQue_TVALoc.Close;
            IBQue_TVALoc.parambyname('TKEID').AsInteger := IBQue_SelectTKE_ID.AsInteger;
            IBQue_TVALoc.Open;

            S := 'LT';                                                          //LinId
            S := S + CopyStuff(IBQue_SelectTKE_NUMERO.AsString, 26, ' ');       //TicketNumber
            S := S + CopyStuff(IBQue_SelectMAG_CODEADH.AsString, 6, ' ');       //PointOfSale
            S := S + format ('%9d', [lig]);                                     //LineNumber
            S := S + CopyStuff(' ', 13, ' ');                                   //VoucherCode
            S := S + CopyStuff('LOCATION', 15, ' ');                            //ItemReference
            S := S + CopyStuff('LOCATION', 15, ' ');                            //SupplierReference
            S := S + CopyStuff('LOCATION', 64, ' ');                            //Supplier
            S := S + CopyStuff('LOCATION', 64, ' ');                            //Brand
            S := S + CopyStuff('LOC999', 9, ' ');                               //Category - Code FEDAS
            S := S + CopyStuff('LOCATION', 64, ' ');                            //CategoryLib
            S := S + '      1,000';                                             //Amount
            S := S + format ('%10.2f', [IBQue_SelectTKE_TOTBRUTA2.AsFloat]);    //Value
            S := S + format ('%10.2f', [abs(IBQue_SelectREMISE.AsFloat)]);      //Discount
            S := S + format ('%6.3f', [IBQue_TVALocLOA_TXTVA.AsFloat]) ;        //VATRate

            fichier.Add(S);
            Inc(lig);
          end;
          //Fin Ajout Location

        END;
      END;
      Application.ProcessMessages;
      IBQue_Select.next;
    END;

    //si fichier créé finaliser sa forme avant de l'enregistrer localement
    IF fichier <> NIL THEN
    BEGIN
      // hst_id (a faire)
      // hst_magid --> Exp_magid
      // hst_date = current_timestamp
      // hst_ok = 1
      // hst_fichier = Formatdatetime('yyyymmddhhnnss', now) + '_' + codeadh + '.txt'
      // hst_nbligne = fichier.count + 1 ;
      // hst_Fichenvoye = 0 ;
      S := IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\' + Formatdatetime ('yyyymmddhhnnss', now) + '_' + codeadh + '.txt';
      Lemessage[lemessage.count - 1] := Lemessage[lemessage.count - 1] + ' dans ' + S;

      Sql.sql.text := ' INSERT INTO HISTORIQUE ( hst_id,HST_MAGID, HST_DATE, HST_OK, HST_FICHIER, HST_NBLIGNE, HST_FICHENVOYE) VALUES (';
      Sql.sql.text := Sql.sql.text + 'GEN_ID(GENERAL_ID,1),' + inttostr (Exp_magid) + ',current_timestamp,1,''' +
        extractfilename (S) + ''',' + Inttostr (fichier.count + 1) + ',0)';
      Sql.ExecQuery;

      fichier.add (format ('%8d', [Num]) + format ('%12d', [fichier.count + 1]) ) ;
      ForceDirectories (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\') ;
      Log_Write('Sauve Fichier :'+S,el_Info);
      Fichier.SaveToFile (S) ;
      if SendFTP then   //SR - 17/12/2012 - Ajout d'une variable d'envoie FTP si nous sommes en test.
        ftp.Ajoute (S, extractfilename (S) ) ;
      fichier.free;
      inc (num) ;
    END
    ELSE
    BEGIN
      S := 'Rien à extraire';
      Lemessage[lemessage.count - 1] := Lemessage[lemessage.count - 1] + ' Rien à extraire';
      Sql.sql.text := ' INSERT INTO HISTORIQUE ( hst_id,HST_MAGID, HST_DATE, HST_OK, HST_FICHIER, HST_NBLIGNE, HST_FICHENVOYE) VALUES (';
      Sql.sql.text := Sql.sql.text + 'GEN_ID(GENERAL_ID,1),' + inttostr (Exp_magid) + ',current_timestamp,1,''' +
        extractfilename (S) + ''',-1,0)';
      Sql.ExecQuery;
    END;
    ini.writeinteger ('param', 'numero', num) ;
    ini.free;
  FINALLY
    data.Close;
  END;
  except
     On E:Exception
      do
        begin
           Log_Write(E.MEssage,el_Erreur);
           Raise;
        end;
  end;
END;

//traitement spécial à partir d'un fichier pour un magasin intégré utilisant Colombus

//PROCEDURE TFrm_ExportSP2000.traiteColombus () ;
//VAR
//  boucle: integer;
//  i: Integer;
//  magId, size: Integer;
//  exportFichier, codeAdh: STRING;
//  tsl: TstringList;
//  sr: tsearchrec;
//  ini: Tinifile;
//BEGIN
//  //récupèrer les nouveaux fichiers sur le ftp colombus
//  IF importerColombus THEN
//  BEGIN
//    TRY
//      //Chargement dans une TSL des fichiers présents dans le répertoire Colombus
//      tsl := TstringList.create;
//      boucle := FindFirst (chemColombus + '*.csv', faAnyFile, sr) ;           //DECO   'C:\ControleReplication\ExpSP2000\COLOMBUS\'
//      WHILE boucle = 0 DO
//      BEGIN
//        tsl.add (sr.name) ;
//        boucle := findnext (sr) ;
//      END;
//      findclose (sr) ;
//      //s'il y a des fichiers à traiter
//      IF tsl.count <> 0 THEN
//      BEGIN
//        FOR i := 0 TO tsl.count - 1 DO
//        BEGIN
//          //réinitialiser le futur nom du fichier export
//          exportFichier := '';
//          //récupèrer le code adhérent du magasin //: la valeur entière débarrassée des 0 inutiles d'un coté et de la date +extension de l'autre
//          codeAdh := Copy (tsl[i], 1, length (tsl[i]) - 12) ;
//          size := 0; //initialiser la taille en lignes du futur fichier
//          //vérifier paramètrage du Magasin
//          magId := verifierMag (codeAdh) ;
//          //Traitement spécifique colombus
//          IF doTranspoColombus (tsl[i], exportFichier, codeAdh, size) THEN
//          BEGIN
//            //envoyer dans la file de traitement Sp2000
//            ftp.Ajoute (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\' + exportFichier, exportFichier) ;
//            //lab : Moins risqué à ce moment là : déplacer dans le dossier traité = OK
//            MoveFile(Pchar (chemColombus + tsl[i]) , Pchar (chemColombus + 'OK\' + tsl[i]) ) ;
//            //mise à jour de l'historique
//            sqlFtp.Transaction.StartTransaction;
//            sqlFtp.sql.text := ' INSERT INTO HISTORIQUE ( hst_id,HST_MAGID, HST_DATE, HST_OK, HST_FICHIER, HST_NBLIGNE, HST_FICHENVOYE) VALUES (';
//            sqlFtp.sql.text := sqlFtp.sql.text + 'GEN_ID(GENERAL_ID,1),' + inttostr (magId) + ',current_timestamp,1,''' +
//              tsl[i] + ' / ' + exportFichier + ''',' + Inttostr (size) + ',0)';
//            sqlFtp.ExecQuery;
//            //mise à jour de la date du dernier export du magasin
//            sqlFtp.sql.text := 'Update MAGASIN SET MAG_LASTEXP = ' +
//              //SR - 13/07/2012 - quotedstr (formatdatetime ('MM/DD/YYYY', now) ) +
//              quotedstr (formatdatetime ('MM/DD/YYYY hh:mm:ss', now) ) +
//              ' where MAG_ID=' + IntToStr (magId) ;
//            sqlFtp.ExecQuery;
//            //valider les transactions
//            sqlFtp.Transaction.Commit;
//            ////enregistrement comme traité en base
//            //Tag le fichier comme reçu dans la base (Table INTEGRESFTP)
//            sqlFtp.Transaction.StartTransaction;
//            SqlFtp.sql.text := 'insert into INTEGRESFTP (FTP_NOM,FTP_DATE) values(''' + tsl[i] + ''',current_timestamp)';
//            SqlFtp.ExecQuery;
//            sqlFtp.Transaction.Commit;
//          END;
//        END;
//      END;
//    EXCEPT ON stan: exception DO
//        showmessage (stan.Message) ;
//    END;
//  END;
//END;

PROCEDURE TFrm_ExportSP2000.VasY;
VAR
  debut, Fin: Tdatetime;
  f: tsearchrec;
BEGIN
  Log_Write('VasY',el_Info);
  Update;
  //rendre la main au systeme
  Application.ProcessMessages;
  //création d'un thread ftp
  if SendFTP then  //SR - 17/12/2012 - Ajout d'une variable d'envoie FTP si nous sommes en test.
  begin
    ftp := TFtpThread.create (self, ChangeFileExt(Application.ExeName,'.ini')) ;
    //initialisation de la propriété onfinifichier....
    ftp.onfinifichier := ftponfinifichier;

    //création de la liste des fichiers restant à traiter
    //si un fichier *.txt est trouvé dans le répertoire de création
    IF FindFirst (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\*.txt', faAnyFile, F) = 0 THEN
    BEGIN
      //pour chaque fichier *.txt
      REPEAT
        //si le premier caractère du nom du fichier n'est pas '.'
        IF (copy (f.name, 1, 1) <> '.') THEN
        BEGIN
          ftp.ajoute (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\' + f.name, f.name);
        END;
      UNTIL findnext (f) <> 0;
    END;
    FindClose (f) ;
  end;

  //compter les bases pour initialiser la barre de progression pb
  IBQue_Comptebase.open;
  pb.Max := IBQue_ComptebaseNBR.AsInteger;
  IBQue_Comptebase.Close;
  IBQue_Lesbases.Open;
  IBQue_Lesbases.first;
  //récupèrer la liste des bases à traiter
  WHILE NOT IBQue_Lesbases.eof DO
  BEGIN
    lab_etat.caption := IBQue_LesbasesBDE_NOM.AsString + ' ' + IBQue_LesbasesMAG_NOM.AsString;
    Log_Write(lab_etat.caption,el_Info);
    lab_etat.Refresh;
    Application.ProcessMessages;
    pb.Position := pb.Position + 1;
    //si pas de date du dernier export initialiser la date de début
    IF IBQue_LesbasesMAG_LASTEXP.IsNull THEN
    BEGIN
      //rechercher la date du premier lundi d'il y a au moin 13 jours
      //début vaut aujourd'hui moins 13 jours
      debut := Now - 13;
      //tant que le jour de début ne vaut pas lundi reculer la date d'un jour
      WHILE DayOfWeek (debut) <> 2 DO
        debut := debut - 1;
    END
    ELSE //sinon début vaut la date du dernier export
      // On ajoute une seconde car il y a des soucis au niveau des timestamps récupéré
      // et traiter par les query car on perd les millisecondes.
      debut := IncSecond(IBQue_LesbasesMAG_LASTEXP.AsDateTime,1);
    //calcul écrasé
    Fin := Now - 13 + 7;
    WHILE DayOfWeek (fin) <> 2 DO
      fin := fin - 1;
    // changement de méthode, maintenant c'est la date du jour
    fin := Now;//SR - 13/07/2012 - date;
    //si la différence entre la date de début est de fin de l'export est supérieur à 30 jours
    //la date de fin est 30 jours après le début....
    IF fin - debut > 30 THEN
      fin := debut + 30;
    TRY
      //si début et fin sont différents

      IF trunc (fin) > trunc (debut) THEN
      BEGIN
        //ne traiter que les magasins utilisant ginkoia ici (non integrés)
        IF IBQue_LesbasesBDE_INTEGRE.asInteger <> 1 THEN
        BEGIN
          traite (IBQue_LesbasesBDE_PATH.AsString, IBQue_LesbasesMAG_GINKOID.asinteger, debut, fin, IBQue_LesbasesMAG_ID.asinteger) ;
          data.Close;
          //se connecter à la base pour mettre à jour la date du dernier export
          data.DatabaseName := IBQue_LesbasesBDE_PATH.AsString;
          data.Open;
          IBQue_Date.parambyname ('MAGID') .asinteger := IBQue_LesbasesMAG_GINKOID.asinteger;
          IBQue_Date.parambyname ('DateDeb') .AsDateTime := debut;
          IBQue_Date.parambyname ('DateFin') .AsDateTime := fin;
          IBQue_Date.open;
          IF NOT (IBQue_DateMAX_DATE.isnull) THEN
          BEGIN
            sql.sql.text := 'Update MAGASIN SET MAG_LASTEXP = ' +
              //SR - 13/07/2012 - quotedstr (formatdatetime ('MM/DD/YYYY ', IBQue_DateMAX_DATE.AsDateTime + 1) ) +
              quotedstr (formatdatetime ('MM/DD/YYYY hh:nn:ss', IBQue_DateMAX_DATE.AsDateTime) ) +
              ' where MAG_ID=' + IBQue_LesbasesMAG_ID.AsString;
            sql.ExecQuery;
          END
          ELSE IF Trunc(fin) <> date THEN
          BEGIN
            sql.sql.text := 'Update MAGASIN SET MAG_LASTEXP = ' +
              //SR - 13/07/2012 - quotedstr (formatdatetime ('MM/DD/YYYY', fin + 1) ) +
              quotedstr (formatdatetime ('MM/DD/YYYY hh:nn:ss', fin) ) +
              ' where MAG_ID=' + IBQue_LesbasesMAG_ID.AsString;
            sql.ExecQuery;
          END;
          data.close;
        END
          else
           begin
              Log_Write('Ne pas traité!',el_Warning);
           end;
      END
      else
        begin
          Log_Write(
            Format('Début et Fin même jour (%s,%s)',[
               FormatDateTime('dd/mm/yyyy hh:nn:ss',Debut),
               FormatDateTime('dd/mm/yyyy hh:nn:ss',Fin)
              ]),el_Warning);
        end;
    EXCEPT
    END;
    IBQue_Lesbases.next;
  END;
  IBQue_Lesbases.close;
  //commit des transactions s'il en reste
  IF sql.Transaction.InTransaction THEN
    sql.Transaction.Commit;

// Suppression du traitement car plus utilisé via mail du 29/10/2012 de Bruno castelli
//  Lab_etat.caption := 'Debut des traitements Colombus';
//  Lab_etat.update;
  //début du traitement spécial Integrés/colombus
//  traiteColombus () ;
//  Lab_etat.caption := 'Fin des traitements Colombus';
//  Lab_etat.update;
  //commit des transactions s'il en reste
  IF sqlftp.Transaction.InTransaction THEN
    sqlftp.Transaction.Commit;

  if SendFTP then
  begin
    Lab_etat.caption := 'Debut des envois Ftp';
    Lab_etat.update;
    //attendre que tout les fichiers soient transmis
    WHILE NOT ftp.vide DO
    BEGIN
      sleep (250) ;
      application.ProcessMessages;
    END;
    ftp.Terminate;
    Lab_etat.caption := 'Fin des envois Ftp';
    Lab_etat.update;
  end;
END;

procedure TFrm_ExportSP2000.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Log_Write('Fermeture du Programme',el_Info);
end;

procedure TFrm_ExportSP2000.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := FCanClose;
end;

procedure TFrm_ExportSP2000.FormCreate (Sender: TObject) ;
var
  ini : TIniFile;
begin
  Log_Init(el_Info,ExtractFilePath(ParamStr(0)));
  Log_Write('Lancement du Programme',el_Info);
  FCanClose := true;
  first := true;
  Lemessage := TstringList.create;

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    LocActif      := ini.ReadBool('param', 'LocActif', False);  //Par défaut la loc n'est pas active.
    SendFTP       := ini.ReadBool('param', 'SendFTP', True);    //Par défaut on envoie sur le FTP.
    SendMail      := ini.ReadBool('param', 'SendMail', True);   //Par défaut on envoie le mail.
    AdrMail_Dest  := ini.ReadString('param', 'AdrMail_Dest', 'dev@ginkoia.fr'); //Par défaut on envoie le mail à dev@ginkoia.fr.
    AdrMail_CC    := ini.ReadString('param', 'AdrMail_CC', '');   //Par défaut pas de Copie Carbonne.
  finally
    FreeAndNil(ini);
  end;
end;

PROCEDURE TFrm_ExportSP2000.Traitement_AUto;
VAR f: tsearchrec;
BEGIN
  IF first THEN
  BEGIN

    first := false;
    //traitement
    VasY;
    //vérifier s'il reste des fichiers non traités à la fin
    IF FindFirst (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\*.txt', faAnyFile, F) = 0 THEN
      Lemessage.add ('Export SP2000, des fichiers restent sur le serveur')
    ELSE
      Lemessage.add ('Export SP2000, c''est bien passé') ;
    findclose (f) ;
    if SendMail then    //SR - 17/12/2012 - Ajout d'une variable dans le fichier ini pour les tests.
    begin
      UPost.sendmail (AdrMail_Dest,                   //SR - 17/12/2012 - Passage par le .ini 'dev@ginkoia.fr',
                      AdrMail_CC,                     //SR - 17/12/2012 - Passage par le .ini 'bruno.nicolafrancesco@ginkoia.fr,sandrine.medeiros@ginkoia.fr',
                      'Export SP2000: Compte rendu',
                      Lemessage.text);
    end;
    //Test    Lemessage.add('Export SP2000, c''est bien passé');
    //Test    UPost.sendmail('lionel.abry@ginkoia.fr', 'lionel.abry@ginkoia.fr', 'Test Export Colombus/SP2000: Compte rendu', Lemessage.text);
    FCanClose:=true;
    Close;
  END;
END;

PROCEDURE TFrm_ExportSP2000.ftponfinifichier (fichier: STRING) ;
BEGIN
  //mise à jour de l'historique s'il existe
  fichier := extractfilename (fichier) ;
  req.close;
  req.sql.text := 'Select HST_ID from HISTORIQUE where HST_FICHIER like ' + quotedstr ('%' + fichier + '%') ;
  req.open;
  IF NOT req.eof THEN
  BEGIN
    sql.sql.text := 'Update HISTORIQUE set HST_FICHENVOYE=1 where HST_ID=' + req.fields[0].asString;
    sql.ExecQuery;
  END;
  req.close;
END;

procedure TFrm_ExportSP2000.FormDestroy (Sender: TObject) ;
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    ini.WriteBool('param', 'LocActif', LocActif);
    ini.WriteBool('param', 'SendFTP', SendFTP);
    ini.WriteBool('param', 'SendMail', SendMail);
    ini.WriteString('param', 'AdrMail_Dest', AdrMail_Dest);
    ini.WriteString('param', 'AdrMail_CC', AdrMail_CC);
  finally
    FreeAndNil(ini);
  end;

  Lemessage.free;
end;

procedure TFrm_ExportSP2000.FormShow(Sender: TObject);
begin
end;

//FUNCTION TFrm_ExportSP2000.importerColombus: Boolean;
//VAR
//  ini: Tinifile;
//  retour: boolean;
//  tsl: tstringlist;
//  i: integer;
//BEGIN
//  retour := false;
//  Lab_etat.caption := 'Connexion au FTP Colombus ...';
//  Lab_etat.update;
//  WITH idFtp DO
//  BEGIN
//    //initialiser le ftp
//    Host := '194.250.124.9';
//    Username := 'colombusginko';
//    Password := 'sui67f5d';
//    //Lecture du chemin du répertoire local
//    ini := Tinifile.Create (changefileext (application.exename, '.ini') ) ;
//    chemColombus := IncludeTrailingBackslash (ini.readString ('FTP', 'CHEMIN', '') ) ;
//    TRY
//      IF Connected THEN Disconnect;
//      tsl := tstringlist.create;
//      //Connexion sur le FTP
//      Connect;
//      IF Connected THEN
//      BEGIN
//        //Mode(MODE_BYTE);
//        Lab_etat.caption := 'Transfert en cours...';
//        Lab_etat.update;
//        //répertoire du FTP qui contient les fichiers à traiter
//        changedir ('FIDELITE') ;
//        //Chargement de la liste des fichiers dispo sur le FTP
//        list (tsl, '', false) ;
//        //Chargement de la liste des fichiers dispo sur le FTP et transfert des nouveau fichiers
//        //et liste non vide
//        IF tsl.count > 0 THEN
//        BEGIN
//          FOR i := 0 TO tsl.count - 1 DO
//          BEGIN
//            //si pas déjà traité
//            IF NOT FileExists (chemColombus + 'OK\' + tsl[i]) THEN
//            BEGIN
//              //On récupère en local seulemement les fichiers pas encore reçu
//              get (tsl[i], chemColombus + tsl[i], true, false) ;
//              Application.ProcessMessages;
//            END;
//          END;
//        END;
//        retour := true;
//      END
//      ELSE
//      BEGIN
//        Lemessage.add ('Echec de la connection au FTP Colombus' + #13#10) ;
//        Lab_etat.caption := 'Echec de la connection au FTP Colombus';
//      END
//    EXCEPT ON Stan: Exception DO
//      BEGIN
//        disconnect;
//        showmessage (Stan.message) ;
//      END;
//    END;
//    tsl.clear;
//  END;
//  Lemessage.add ('La récupération des fichiers du FTP Colombus c''est bien passée' + #13#10) ;
//  Lab_etat.caption := 'La récupération des fichiers du FTP Colombus c''est bien passée';
//  Lab_etat.update;
//  result := retour;
//END;

//FUNCTION TFrm_ExportSP2000.doTranspoColombus (Afile: STRING; VAR exportFichier: STRING; codeAdh: STRING; VAR size: Integer) : Boolean;
//VAR
//  coupon, categorie, categorieLib: STRING;
//  strTicket: STRING;
//  num: integer;
//  entetePos: integer; //position de l'entête
//  Lig: Integer;
//  sousTotal: double;
//  totalTicket: double;
//  retour: boolean;
//  ini: Tinifile;
//  fichierDest, fichierOri: Tstrings;
//  catNum: integer;
//  numcoupon: Int64;
//  strNumCarteBeColl: STRING;
//  dateDocument, heureValidation: STRING;
//  sautDeLigne, first: boolean;
//BEGIN
//  retour := false;
//  TRY
//    Lemessage.add ('extraction colombus de ' + Afile + #13#10) ;
//    //récupèrer dans l'ini l'identifiant unique du fichier de destination
//    ini := Tinifile.Create (changefileext (application.exename, '.ini') ) ;
//    Num := ini.readinteger ('param', 'numero', 1) ;
//    //charger le fichier Colombus
//    fichierOri := tstringlist.create;
//    fichierOri.LoadFromFile (IncludeTrailingBackslash (ExtractFilePath (Application.exeName) ) + 'COLOMBUS\' + Afile) ;
//    //Constituer le fichier destination transposant le fichier colombus en fichier sp2000
//    fichierDest := tstringlist.create;
//    //vérifier que le fichier contient des lignes
//    IF fichierOri.Count <> 0 THEN
//    BEGIN
//      //remplacer la première ligne par les noms des colonnes du memData pour maitriser leur identification
//      fichierOri.Delete (0) ;
//      fichierOri.insert (0, 'MAGASIN;LIBELLEMAGASIN;ETABLISSEMENT;LIBELLEETABLISSEMENT;NUMEROTICKET;DATEDOCUMENT;' + 'HEUREVALIDATION;CARTEBECOLLECTOR;NUMCOUPON;NUMLIGNETICKET;REFPRODUITFOURNISSEUR;PRODUIT;LIBELLEPRODUIT;' + 'FOURNISSEURPRODUIT;LIBELLEFOURNISSEURPRODUIT;MARQUE;ACTIVITE;ENSEIGNEETABLISSEMENT;QTEVTEMAG;PRIXUNITAIRE;REMISEVENTE;TXTVA;CATTCMAG') ;
//      //sauver dans un fichier temporaire pour concerver l'original
//      fichierOri.SavetoFile (IncludeTrailingBackslash (ExtractFilePath (Application.exeName) ) + 'COLOMBUS\TEMP\temp.csv') ;
//      //recharger dans le memdata
//      memData.close;
//      memDAta.DelimiterChar := ';';
//      memdata.LoadFromTextFile (IncludeTrailingBackslash (ExtractFilePath (Application.exeName) ) + 'COLOMBUS\TEMP\temp.csv') ;
//      //Entête de fichier
//      fichierDest.add (format ('%8d', [Num]) + FormatDateTime ('ddmmyyyy', Now) + FormatDateTime ('hhnnss', Now) + Copy (codeadh + '        ', 1, 6) ) ;
//      //tant qu'on n'a pas atteint la fin du fichier
//      memData.First;
//      totalTicket := 0;
//      lig := 1; //initialiser le compteur de ligne de tickets
//
//      //intialisation des variables de la ligne en cours
//      strTicket := memDataNUMEROTICKET.asString;
//      //récupèrer le numéro de la carte be collector de la première ligne
//      strNumCarteBeColl := memDataCARTEBECOLLECTOR.asString;
//      //récupèrer la date et l'heure du document
//      dateDocument := FormatDateTime ('ddmmyyyy', memDataDATEDOCUMENT.AsDateTime) ;
//      heureValidation := FormatDateTime ('hhnnss', memDataHEUREVALIDATION.AsDateTime) ;
//      //se souvenir de la position ou on va insèrer l'entête
//      entetePos := fichierDest.Count;
//      sautDeLigne := false;
//      first := true;
//      //traiter chaque ligne pour ensuite pourvoir créer l'entête du ticket avec la somme des lignes.
//      WHILE NOT memData.Eof DO
//      BEGIN
//        coupon := '';
//        categorie := '';
//        categorieLib := '';
//        //vérifier qu'il s'agit d'une carte Be Collector valide
//        IF ((Copy (memDataCARTEBECOLLECTOR.asString, 1, 3) = '256') OR (Copy (memDataCARTEBECOLLECTOR.asString, 1, 3) = '258') )
//          AND (length (trim (memDataCARTEBECOLLECTOR.asString) ) = 13) THEN
//        BEGIN
//          //vérifier s'il on a sauté une ligne dès la première ligne et mettre a jour les variables de la ligne en cours
//          IF sautDeligne AND first THEN
//          BEGIN
//            //mise a jour des variables de la ligne en cours
//            strTicket := memDataNUMEROTICKET.asString;
//            //récupèrer le numéro de la carte be collector de la première ligne
//            strNumCarteBeColl := memDataCARTEBECOLLECTOR.asString;
//            //récupèrer la date et l'heure du document
//            dateDocument := FormatDateTime ('ddmmyyyy', memDataDATEDOCUMENT.AsDateTime) ;
//            heureValidation := FormatDateTime ('hhnnss', memDataHEUREVALIDATION.AsDateTime) ;
//            //se souvenir de la position ou on va insèrer l'entête
//            entetePos := fichierDest.Count;
//            sautDeLigne := false;
//          END;
//          first := false;
//          //préparer les variables conditionnelles ( si j'ai çà je veux çà sino je vaux autrechose....)
//          //tester la valeur du coupon : si (sans valeur) alors vide
//          IF (memDataNUMCOUPON.asString <> '(Sans valeur)') THEN
//          BEGIN
//            coupon := memDataNUMCOUPON.asString;
//          END;
//          //si colonne ENSEIGNEETABLISSEMENT = 'SPORT 2000'
//          IF (Pos ('SPORT 2000', upperCase (memDataENSEIGNEETABLISSEMENT.asString) ) <> 0) THEN
//          BEGIN
//            categorieLib := 'FEDAS';
//            categorie := Copy (memDataACTIVITE.asString, length (memDataACTIVITE.asString) - 1, length (memDataACTIVITE.asString) ) ;
//            //convertir la catégorie en entier: si code non numérique  (seulement00-99) alors champ FEDAS='' et numero=''
//            TRY
//              catNum := -1;
//              catNum := StrToInt (categorie) ;
//              IF (catNum < 0) OR (catNum > 99) THEN
//              BEGIN
//                categorie := 'MV';
//                categorieLib := 'MONDO';
//              END;
//            EXCEPT
//              categorie := 'MV';
//              categorieLib := 'MONDO';
//            END;
//          END
//          ELSE
//          BEGIN
//            categorie := memDataACTIVITE.asString;
//            categorieLib := memDataENSEIGNEETABLISSEMENT.asString;
//          END;
//          //s'il s'agit du même ticket
//          IF (strTicket = memDataNUMEROTICKET.asString) THEN
//          BEGIN
//            //cumuler le total
//            sousTotal := StringToFloat (memDataCATTCMAG.asString) ;
//            totalTicket := totalTicket + sousTotal;
//            //tester et si coupon créer deux lignes
//            numcoupon := 0;
//            //si le coupon n'est pas vide et qu'il commence par 257 ou 259 et que nous traitons la première ligne LT, tenter de le convertir
//            IF (length (trim (coupon) ) = 13) AND ((Copy (coupon, 1, 3) = '257') OR (Copy (coupon, 1, 3) = '259') ) AND (lig = 1) THEN
//            BEGIN
//              TRY
//                numCoupon := StrToInt64 (coupon) ;
//              EXCEPT
//                numCoupon := 0;
//              END;
//            END;
//            //si coupon placer les infos sur deux lignes
//            IF (numcoupon <> 0) THEN
//            BEGIN
//              fichierDest.add ('LT' + Copy (memDataNUMEROTICKET.asString + '            ', 1, 12) +
//                copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//                format ('%9d', [lig]) +
//                //Copy('                                               ', 1, 13) +
//                Copy (coupon + '                                               ', 1, 13) +
//                Copy ('                                               ', 1, 15) +
//                Copy ('                                               ', 1, 15) +
//                Copy ('                                                                                   ', 1, 64) +
//                Copy ('                                                                                   ', 1, 64) +
//                Copy ('                                               ', 1, 9) +
//                Copy ('                                                                                   ', 1, 64) +
//                Copy ('                                               ', 1, 11) +
//                Copy ('                                               ', 1, 10) +
//                Copy ('                                               ', 1, 10) +
//                Copy ('                                               ', 1, 5) ) ;
//              inc (lig) ;
//              fichierDest.add ('LT' + Copy (memDataNUMEROTICKET.asString + '            ', 1, 12) +
//                copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//                format ('%9d', [lig]) +
//                Copy ('                                               ', 1, 13) +
//                Copy (memDataPRODUIT.AsString + '                                               ', 1, 15) +
//                Copy (memDataREFPRODUITFOURNISSEUR.AsString + '                                               ', 1, 15) +
//                Copy (memDataLIBELLEFOURNISSEURPRODUIT.AsString + '                                                                                   ', 1, 64) +
//                Copy (memDataMARQUE.asString + '                                                                                   ', 1, 64) +
//                Copy (categorie + '                                               ', 1, 9) +
//                Copy (categorieLib + '                                                                                   ', 1, 64) +
//                format ('%11.3f', [StringToFloat (memDataQTEVTEMAG.asString) ]) +
//                format ('%10.2f', [StringToFloat(memDataPRIXUNITAIRE.asString)]) +
//                format ('%10.2f', [abs(StringToFloat (memDataREMISEVENTE.asString) )]) +
//                format ('%6.3f', [StringToFloat (memDataTXTVA.AsString) ]) ) ;
//              inc (lig) ;
//            END
//            ELSE //sinon sur une seule ligne
//            BEGIN
//              fichierDest.add ('LT' + Copy (memDataNUMEROTICKET.asString + '            ', 1, 12) +
//                copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//                format ('%9d', [lig]) +
//                Copy ('                                               ', 1, 13) +
//                Copy (memDataPRODUIT.AsString + '                                               ', 1, 15) +
//                Copy (memDataREFPRODUITFOURNISSEUR.AsString + '                                               ', 1, 15) +
//                Copy (memDataLIBELLEFOURNISSEURPRODUIT.AsString + '                                                                                   ', 1, 64) +
//                Copy (memDataMARQUE.asString + '                                                                                   ', 1, 64) +
//                Copy (categorie + '                                               ', 1, 9) +
//                Copy (categorieLib + '                                                                                   ', 1, 64) +
//                format ('%11.3f', [StringToFloat (memDataQTEVTEMAG.asString) ]) +
//                format ('%10.2f', [StringToFloat(memDataPRIXUNITAIRE.asString)]) +
//                format ('%10.2f', [abs(StringToFloat (memDataREMISEVENTE.asString) )]) +
//                format ('%6.3f', [StringToFloat (memDataTXTVA.AsString) ]) ) ;
//              inc (lig) ;
//            END;
//          END //Fin de s'il s'agit du même ticket
//          ELSE //création de l'entête
//          BEGIN
//            //enregistrer l'entete du ticket
//            fichierDest.insert (entetePos, 'ET' +
//              Copy (strTicket + '            ', 1, 12) +
//              copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//              copy (memDataLIBELLEETABLISSEMENT.AsString + '                                                                    ', 1, 64) +
//              dateDocument +
//              heureValidation +
//              Copy (strNumCarteBeColl + '                                               ', 1, 13) +
//              format ('%17.2f', [totalTicket]) ) ;
//            //réinitialiser le compteur de lignes
//            lig := 1;
//            //se souvenir de la position ou on va insèrer la prochaine entête
//            entetePos := fichierDest.Count;
//            //nouvelle ligne
//            sousTotal := StringToFloat (memDataCATTCMAG.asString) ;
//            totalTicket := sousTotal;
//            //mémoriser le nouveau numéro de ticket
//            strTicket := memDataNUMEROTICKET.asString;
//            //mémoriser le nouveau numéro de la carte be collector
//            strNumCarteBeColl := memDataCARTEBECOLLECTOR.asString;
//            //récupèrer la date et l'heure du document
//            dateDocument := FormatDateTime ('ddmmyyyy', memDataDATEDOCUMENT.AsDateTime) ;
//            heureValidation := FormatDateTime ('hhnnss', memDataHEUREVALIDATION.AsDateTime) ;
//            //tester et si coupon créer deux lignes
//            numcoupon := 0;
//            //si le coupon n'est pas vide et qu'il commence par 257 ou 259 et que nous traitons la première ligne LT, tenter de le convertir
//            IF (length (trim (coupon) ) = 13) AND ((Copy (coupon, 1, 3) = '257') OR (Copy (coupon, 1, 3) = '259') ) AND (lig = 1) THEN
//            BEGIN
//              TRY
//                numCoupon := StrToInt64 (coupon) ;
//              EXCEPT
//                numCoupon := 0;
//              END;
//            END;
//            //si coupon placer les infos sur deux lignes
//            IF (numcoupon <> 0) THEN
//            BEGIN
//              fichierDest.add ('LT' + Copy (memDataNUMEROTICKET.asString + '            ', 1, 12) +
//                copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//                format ('%9d', [lig]) +
//                //Copy('                                               ', 1, 13) +
//                Copy (coupon + '                                               ', 1, 13) +
//                Copy ('                                               ', 1, 15) +
//                Copy ('                                               ', 1, 15) +
//                Copy ('                                                                                   ', 1, 64) +
//                Copy ('                                                                                   ', 1, 64) +
//                Copy ('                                               ', 1, 9) +
//                Copy ('                                                                                   ', 1, 64) +
//                Copy ('                                               ', 1, 11) +
//                Copy ('                                               ', 1, 10) +
//                Copy ('                                               ', 1, 10) +
//                Copy ('                                               ', 1, 5) ) ;
//              inc (lig) ;
//              fichierDest.add ('LT' + Copy (memDataNUMEROTICKET.asString + '            ', 1, 12) +
//                copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//                format ('%9d', [lig]) +
//                Copy ('                                               ', 1, 13) +
//                Copy (memDataPRODUIT.AsString + '                                               ', 1, 15) +
//                Copy (memDataREFPRODUITFOURNISSEUR.AsString + '                                               ', 1, 15) +
//                Copy (memDataLIBELLEFOURNISSEURPRODUIT.AsString + '                                                                                   ', 1, 64) +
//                Copy (memDataMARQUE.asString + '                                                                                   ', 1, 64) +
//                Copy (categorie + '                                               ', 1, 9) +
//                Copy (categorieLib + '                                                                                   ', 1, 64) +
//                format ('%11.3f', [StringToFloat (memDataQTEVTEMAG.asString) ]) +
//                format ('%10.2f', [stringToFloat(memDataPRIXUNITAIRE.asString)]) +
//                format ('%10.2f', [abs(StringToFloat (memDataREMISEVENTE.asString)) ]) +
//                format ('%6.3f', [StringToFloat (memDataTXTVA.AsString) ]) ) ;
//              inc (lig) ;
//            END
//            ELSE //sinon sur une seule ligne
//            BEGIN
//              fichierDest.add ('LT' + Copy (memDataNUMEROTICKET.asString + '            ', 1, 12) +
//                copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//                format ('%9d', [lig]) +
//                Copy ('                                               ', 1, 13) +
//                Copy (memDataPRODUIT.AsString + '                                               ', 1, 15) +
//                Copy (memDataREFPRODUITFOURNISSEUR.AsString + '                                               ', 1, 15) +
//                Copy (memDataLIBELLEFOURNISSEURPRODUIT.AsString + '                                                                                   ', 1, 64) +
//                Copy (memDataMARQUE.asString + '                                                                                   ', 1, 64) +
//                Copy (categorie + '                                               ', 1, 9) +
//                Copy (categorieLib + '                                                                                   ', 1, 64) +
//                format ('%11.3f', [StringToFloat (memDataQTEVTEMAG.asString) ]) +
//                format ('%10.2f', [stringToFloat(memDataPRIXUNITAIRE.asString)]) +
//                format ('%10.2f', [abs(StringToFloat (memDataREMISEVENTE.asString))]) +
//                format ('%6.3f', [StringToFloat (memDataTXTVA.AsString) ]) ) ;
//              inc (lig) ;
//            END;
//          END;
//        END
//        ELSE
//        BEGIN
//          sautDeLigne := true;
//        END;
//        memData.Next;
//      END;
//      //si au moins une ligne créée
//      IF (fichierDest.count > 1) THEN
//      BEGIN
//        //dernière entête (attention différent du insert ET ci dessus)
//        fichierDest.insert (entetePos, 'ET' +
//          Copy (strTicket + '            ', 1, 12) +
//          copy (memDataETABLISSEMENT.asString + '      ', 1, 6) +
//          copy (memDataLIBELLEETABLISSEMENT.AsString + '                                                                    ', 1, 64) +
//          dateDocument +
//          heureValidation +
//          Copy (strNumCarteBeColl + '                                               ', 1, 13) +
//          format ('%17.2f', [totalTicket]) ) ;
//      END;
//      //Enregistrement fin de fichierDest
//      fichierDest.add (format ('%8d', [Num]) + format ('%12d', [fichierDest.count + 1]) ) ;
//      exportFichier := Formatdatetime ('yyyymmddhhnnss', now) + '_' + codeadh + '.txt';
//      //si x fichiers du même adhérents il y a un risque d'écrasement :temporiser car sinon la création du fichier .TXT étant trop rapide, le nom est le même car la seconde n'a pas changée.
//      IF FileExists (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\' + exportFichier) THEN
//      BEGIN
//        sleep (1500) ;
//        //Attendre et créer un nouveau nom de fichier
//        exportFichier := Formatdatetime ('yyyymmddhhnnss', now) + '_' + codeadh + '.txt';
//      END;
//      fichierDest.SaveToFile (IncludeTrailingBackslash (ExtractFilePath (Application.ExeName) ) + 'CREATION\' + exportFichier) ; //.txt
//      Lemessage.add ('transposition du fichier Colombus ' + Afile + ' en ' + exportFichier + ' terminé' + #13#10) ;
//      Lab_etat.caption := 'Traitement du fichier Colombus ' + Afile + ' terminé';
//      Lab_etat.update;
//      //taille du fichier pour l'historique
//      size := FichierDest.Count;
//      retour := true;
//      //mettre à jour le fichier ini
//      inc (num) ;
//      ini.writeinteger ('param', 'numero', num) ;
//    END
//    ELSE
//    BEGIN
//      //fichier vide , ne rien faire mais ne pas bloquer la suite
//      retour := true;
//    END;
//  FINALLY
//    ini.free;
//    fichierDest.free;
//    fichierOri.free;
//  END;
//  result := retour;
//END;

//FUNCTION TFrm_ExportSP2000.verifierMag (magNom: STRING) : Integer;
//VAR
//  magId: Integer;
//BEGIN
//  magId := -1;
//  //vérifier l'existence d'un enregistrement concernant le magasin magnom
//  //si le mag n'existe pas le créer
//  IBQue_Mag.close;
//  TRY
//    IBQue_Mag.ParamByName ('magnom') .value := magNom;
//    IBQue_Mag.open;
//    IF IBQue_Mag.eof THEN
//    BEGIN
//      // Le magasin est inconnu : il doit être crée
//      sqlNewMag.Transaction.StartTransaction;
//      sqlNewMag.sql.text := 'insert into MAGASIN (MAG_ID,MAG_BDEID,MAG_GINKOID,MAG_ENABLED,MAG_LASTEXP,MAG_NOM)' +
//        'values(GEN_ID(GENERAL_ID,1),(SELECT BDE_ID from BASEDEDONNES where BDE_INTEGRE=1),' + magNom + ',1,NULL,''' + magNom + ''')';
//      sqlNewMag.ExecQuery;
//      sqlNewMag.Transaction.Commit;
//      //récupèrer l'id créé
//      IBQue_Mag.close;
//      IBQue_Mag.ParamByName ('magnom') .value := magNom;
//      IBQue_Mag.open;
//    END;
//    magId := IBQue_MagMAG_ID.Asinteger;
//  FINALLY
//    IBQue_Mag.close;
//  END;
//  result := magId;
//END;

//FUNCTION TFrm_ExportSP2000.StringToFloat (s: STRING) : double;
//VAR
//  SvgDecSep: Char;
//BEGIN
//  SvgDecSep := DecimalSeparator;
//  TRY
//    // On teste avec un .
//    DecimalSeparator := '.';
//    Result := StrToFloat (S) ;
//  EXCEPT
//    TRY
//      // On teste avec une ,
//      DecimalSeparator := ',';
//      Result := StrToFloat (S) ;
//    EXCEPT
//      Result := 0;
//    END;
//  END;
//  DecimalSeparator := SvgDecSep;
//END;

END.


unit ExtractDatabase_Dm;

interface

uses
  SysUtils, Forms, Classes, IBSQL, DB, IBCustomDataSet, IBQuery, IBDatabase, controls, Variants,
  ADODB, AdvProgr, RzLabel, IniCfg_Frm, uLog, UVersion, Dialogs, Diagnostics, StrUtils, DoByDate_Frm,
  AdvGlowButton;

type
  EMVTERROR = Exception;

  stRecordMvt = record
    // Général
    iDosid, iMagId: integer;
    // Infos article
    iArtId, iArtPseudo, iMrkIdRef, iGtfId: integer;
    iArtIdOri, iGtfIdOri: integer;
    sArtNom, sArtRefMrk, sMrkNom, sArtFedas, sGtfNom, sDateCree: string;
    // Infos mouvement
    iMvtId, iTyp, iQte, iKEnabled: integer;
    dtDateMvt, dtDateLivr, dtModif: TDateTime;
    fPxBrutTTC, fPxBrutHT: double;
    fPxNetTTC, fPxNetHT: double;
    fPump, fTva: double;
    fArtPump: double;
    iCodeTypeVente, iFouId: integer;
    sTypeVente, sCollection: string;
    iTkeId: integer;

    // Tailles / couleurs
    iTgfId, iCouId: integer;
    iTgfIdOri, iCouIdOri: integer;
    sTgfNom, sCouNom, sCouCode: string;
    iFusion : Integer;
  end;

  TModeArt = (maArt, maMrk);

  TModeFind = (mfMin, mfMax);


  TFouId_Assign = record
    Gink_FOUID : integer;
    MySQL_FOUID : Integer;
  end;

  TObjectAssignFouid = class(TObject)
  private
    FFouId_Array: array of TFouId_Assign;
  public
    constructor Create overload;
    procedure Clear;
    function Count : integer;
    function indexOf(aGink_FOUID : integer) : Integer;
    procedure Add(aGink_FOUID, aMySQL_FOUID : integer);
    function getValue(aGink_FOUID : integer) : Integer;
  end;

  TDm_ExtractDatabase = class(TDataModule)
    Ginkoia: TIBDatabase;
    IbSql_MajProc: TIBSQL;
    IbT_Ginkoia: TIBTransaction;
    QMvt: TIBQuery;
    IBQue_InitDtb: TIBQuery;
    ADODatabase: TADOConnection;
    AdQue_GetListMags: TADOQuery;
    Ps_Article: TADOStoredProc;
    Ps_CbArt: TADOStoredProc;
    IBQue_InitDtbARTID: TIntegerField;
    IBQue_InitDtbARFID: TIntegerField;
    IBQue_InitDtbARTREFMRK: TIBStringField;
    IBQue_InitDtbARTNOM: TIBStringField;
    IBQue_InitDtbARTFEDAS: TIBStringField;
    IBQue_InitDtbARFPSEUDO: TIntegerField;
    IBQue_InitDtbARFCREE: TDateField;
    IBQue_InitDtbCOUID: TIntegerField;
    IBQue_InitDtbCOUNOM: TIBStringField;
    IBQue_InitDtbCOUCODE: TIBStringField;
    IBQue_InitDtbTGFID: TIntegerField;
    IBQue_InitDtbTGFNOM: TIBStringField;
    IBQue_InitDtbGTFID: TIntegerField;
    IBQue_InitDtbGTFNOM: TIBStringField;
    IBQue_InitDtbCBICB: TIBStringField;
    IBQue_InitDtbTYPECB: TIntegerField;
    IBQue_InitDtbMRKIDREF: TIntegerField;
    IBQue_InitDtbMRKNOM: TIBStringField;
    Ps_Mouvement: TADOStoredProc;
    IBQue_InitDtbSTCQTE: TIntegerField;
    IBQue_GetMvt: TIBQuery;
    AdQue_KMax: TADOQuery;
    AdQue_KMaxmhi_typ: TWordField;
    AdQue_KMaxkmax: TIntegerField;
    IbQue_CurVersion: TIBQuery;
    IbQue_CurVersionNEWKEY: TIntegerField;
    AdQue_Histo: TADOQuery;
    AdQue_MajDateActiv: TADOQuery;
    IBQue_GetCB: TIBQuery;
    Ps_Fournisseur: TADOStoredProc;
    IBQue_GetFourn: TIBQuery;
    IBQue_GetFournFOU_IDREF: TIntegerField;
    IBQue_GetFournFOU_NOM: TIBStringField;
    IBQue_InitDtbRETOUR: TIntegerField;
    IBQue_InitDtbARTPUMP: TFMTBCDField;
    Ps_Ticket: TADOStoredProc;
    IBQue_GetEnc: TIBQuery;
    IBQue_GetEncENC_ID: TIntegerField;
    IBQue_GetEncMEN_NOM: TIBStringField;
    IBQue_GetEncENC_MONTANT: TFloatField;
    IBQue_GetEncK_ENABLED: TIntegerField;
    Ps_Enc: TADOStoredProc;
    IBQue_GetVersionAtDate: TIBQuery;
    IBQue_GetVersionAtDateKVERSION: TIntegerField;
    IBQue_InitDtbHSTID: TIntegerField;
    IBQue_GetFouById: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    IBQue_GetFouIdRef: TIBQuery;
    IBQue_GetFouIdRefFOU_IDREF: TIntegerField;
    IBQue_GetFournFOU_ID: TIntegerField;
    IBQue_GetEncENC_BA: TFloatField;
    Ps_BonsAchats: TADOStoredProc;
    PS_Coupons: TADOStoredProc;
    IBQue_Tmp: TIBQuery;
    IBQue_TmpCB: TIBQuery;
    AdQue_GetLstMarque: TADOQuery;
    IBQue_InitDtbK_ENABLED: TIntegerField;
    ADOQue_LstTmp: TADOQuery;
    AQue_INSERTTmp: TADOQuery;
    IBQue_InitDtbTmp: TIBQuery;
    aQue_QryTmp: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ADODatabaseAfterConnect(Sender: TObject);
    procedure ADODatabaseAfterDisconnect(Sender: TObject);
    procedure GinkoiaAfterConnect(Sender: TObject);
    procedure GinkoiaAfterDisconnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FMainProgress         : TAdvProgress;
    FLab_ConnexionStateDtb: TRzLabel;
    FLab_ConnexionStateGin: TRzLabel;
    FLab_State            : TRzLabel;
    FURLSrv               : string;
    FErreurSQL            : Integer;
    FErreurSQLTexte       : string;
    FArtProgress: TAdvProgress;
    FObjectAssignFouid : TObjectAssignFouid;
    FNbt_Stop: TAdvGlowButton;
    FExit : Boolean;
    { Déclarations privées }
//    procedure SupprProcedure(AProcName: string);
//    procedure CreerProcedure(AProcName: string);

    function InitBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit: TDateTime): boolean;
    function TraiteBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit: TDateTime; aInit : boolean; bAskPlage : Boolean): boolean;

    function InsertMvt(AMvt: stRecordMvt; var aSW: TStopwatch): boolean;
    function InitRecordMvt: stRecordMvt;

    Function GetCurVer(): integer;
    function GetVerDate(ADateInit: TDateTime): integer;


    procedure InitProgress(AMessage: string; AMax: integer; AReset : Boolean = True);
    procedure DoProgress();
    procedure CloseProgress();

    procedure UpdateArticle(ADosID, AMagID, AKDeb, AKFin : Integer; AMode : TModeArt; AMrkNom : String; AInit : Boolean = False; ADateInit : TDate = 43466);
    procedure DeltaArticle;
    procedure RecalStock;
    function GetGinkoiaMagid(aDatabaseMagId : integer) : integer;
    procedure OpenAndLog(aQry : TIBQuery; aName : string; var aSW: TStopwatch); overload;
    procedure OpenAndLog(aQry : TADOStoredProc; aName : string; var aSW: TStopwatch); overload;
    function getDatabase : string;
    procedure doDelta(aChemin : string; aDosId, aMagId : integer; AMagAdh : string; iLastK, iTypeMvt, iCurVersion : integer;
    ADateInit : TDateTime; aIsOldDatabase, bFinBoucle, aInit : Boolean; var aSW : TStopwatch);


    procedure GestionStock(AMagID : Integer; AMagADH : String);
    procedure GestionCorrectionFildelite(AMagID : Integer; AMagADH : String);
    procedure GestionCorrectionMouvement(AMagID : Integer; AMagADH : String);
    procedure UpdateUtilTkeID(AMagID: Integer);
    procedure GestionCorrectionCB(AMagID : Integer; AMagADH : String);

    procedure InsertAudit(AMAGID : Integer; ADATEDEBUT, ADATEFIN : TDateTime; ANUMETAPE, ANBLIGNE, ASTATUS : Integer; ASTATUSINFO : String;AWithTransaction : Boolean = False);

   procedure nbt_stopClick(Sender: TObject);

  public
    IBQue_GetVerDate       : TIBQuery;
    IBQue_GetVerDateVERSION: TIntegerField;
    { Déclarations publiques }
    //procedure SupprToutesProcedures;
    //procedure MajToutesProcedures;

    procedure DoTraitement(ADoInit, ADoTraitementAfterInit, ADoOneMag: boolean; ACodeADH: string; bAskPlage : Boolean = false);
    procedure DoTraitementMarque(AMrkNOM : String);
    procedure DoTraitementCB;
    procedure DoTraitementStock;
    procedure Test;
    procedure DataBaseConnection;

    procedure DoNewTraitement;

    function IsPathInList(ADirectory : String;ALst : TStrings) : Boolean;

    procedure InsertHisto(AResult, AMagId, AKDeb, AKFin, AType, ANb: integer; ADtDeb, ADtFin: TDateTime; AComment: string);


    function GetKByDate(ADate : TDate; AMode : TModeFind) : Integer;

    property MainProgress: TAdvProgress read FMainProgress write FMainProgress;
    property ArtProgress: TAdvProgress read FArtProgress write FArtProgress;
    property Lab_ConnexionStateDtb: TRzLabel read FLab_ConnexionStateDtb write FLab_ConnexionStateDtb;
    property Lab_ConnexionStateGin: TRzLabel read FLab_ConnexionStateGin write FLab_ConnexionStateGin;
    property Lab_State: TRzLabel read FLab_State write FLab_State;
    property Nbt_Stop : TAdvGlowButton read FNbt_Stop write FNbt_Stop;

  end;

var
  Dm_ExtractDatabase: TDm_ExtractDatabase;

implementation

uses ImportOC_Dm, UCommon, IniFiles, ImportClient_Dm, ChoixKVersion_Frm;

{$R *.dfm}

procedure TDm_ExtractDatabase.DataModuleCreate(Sender: TObject);
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

  iNivLog       : integer;  // Niveau de log à inscrire dans le fichier
begin

  // Cloture des connexions au cas ou
  ADODatabase.Close;
  Ginkoia.Close;

  iNivLog          := 0;

  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    iNivLog        := iniConfigAppli.ReadInteger('LOGS', 'NIVEAU', 0);
  finally
    iniConfigAppli.Free;
  end;
  FObjectAssignFouid := TObjectAssignFouid.Create;
  // On conserve 2 mois de log (arbitraire, voir pour rendre paramétrable ini ?)
  UCommon.PurgeOldLogs(True, 60);

  // Init les logs (voir pr rendre paramétrable le niveau de log au besoin, pr l'instant les 5 premiers niveaux sont logés)
  UCommon.InitLogFileName(Nil, Nil, iNivLog);

  FExit := False;
end;

procedure TDm_ExtractDatabase.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FObjectAssignFouid);
end;

procedure TDm_ExtractDatabase.DeltaArticle;
begin

end;

procedure TDm_ExtractDatabase.doDelta(aChemin : string; aDosId, aMagId : integer; AMagAdh: string;
  iLastK, iTypeMvt, iCurVersion: integer;
  ADateInit: TDateTime; aIsOldDatabase, bFinBoucle, aInit : Boolean;
  var aSW : TStopwatch);
var
  iNbMvt     : integer;     // Nombre de mouvments traités
  iNbEnr     : integer;     // Nombre d'enregistrement a traiter
  iPassage   : integer;     // Nombre de paquet de 9999 traité
  dtDebutTrt : TDateTime;   // Timestamp de début de traitement
  iCheckAllMvt : integer;
//  bFinBoucle : boolean;     // Flag de sortie de boucle en cas d'erreur
  iTkeId     : integer;     // Id (Ginkoia) du ticket en cours
  iTkeIdDtb  : integer;     // Id du Ticket dans la DATABASE
  stMvt      : stRecordMvt; // Structure pour stocker le mouvmeent en cours et l'insérer
  vCodeEAN   : variant;     // Tampon pour contacténer le dosid et le code barre.
  vTypeEAN   : variant;     // Tampon pour garder le type de code barre.
  vFouIdRef  : variant;     // tampon pour stocker l'id ref du fournisseur
  sLogSrv    : string;
  sLogDos    : string;
  sLogRef    : string;
  sLogMag    : string;
  sDate      : string;      // Tampon pour mettre date sur 4 car
  iKDeb      : integer;     // Dernier K traité au traitement précédent
begin
  iKDeb := iLastK;
  sloGSrv := getSrvFromPathIB(Trim(UpperCase(AChemin)));
  sLogDos := Trim(UpperCase(AChemin));
  sLogRef := AMagAdh;
  sLogMag := '';
  iNbEnr   := 0;
  iPassage := 0;
  iNbMvt   := 0;
  try
    repeat
      dtDebutTrt := Now;
      Inc(iPassage);
      // Trouvé, on envoie
      IBQue_GetMvt.Close;
      IBQue_GetMvt.ParamByName('MAGCODEADH').AsString      := AMagAdh;
      IBQue_GetMvt.ParamByName('LASTVERSION').AsInteger    := iLastK;
      IBQue_GetMvt.ParamByName('TYP').AsInteger            := iTypeMvt;
      IBQue_GetMvt.ParamByName('CURRENTVERSION').AsInteger := iCurVersion;
      IBQue_GetMvt.ParamByName('DTMAX').AsDateTime         := ADateInit;
  //              IBQue_GetMvt.Open;
      OpenAndLog(IBQue_GetMvt, 'IBQue_GetMvt', aSW);
      iCheckAllMvt := 0;
      IBQue_GetMvt.FetchAll;

      iNbEnr := IBQue_GetMvt.RecordCount;

      ADODatabase.BeginTrans;
      if iNbEnr > 0 then          // S'il y'a des enregistrement, sinon c'est qu'on a fini
      begin
        if IBQue_GetMvt.FieldByName('RETOUR').AsInteger = 1 then   // Retour = 0 indique un pb de code adhérant
        begin
          LogAction('Traitement des mouvements de type ' + IntToStr(iTypeMvt) + ' (' + IntToStr(iPassage) + ')', logInfo);
          InitProgress('Traitement des mouvements de type ' + IntToStr(iTypeMvt) + ' (' + IntToStr(iPassage) + ')', iNbEnr);

          iTkeId    := 0;
          iTkeIdDtb := 0;
          while (not bFinBoucle) and (not IBQue_GetMvt.Eof) do
          begin

            ////////////////////////////////  TEST  ////////////////////////////////
  //                    inc(iCheckAllMvt);
  //                    if iCheckAllMvt = 50 then
  //                    begin
  //                      iCheckAllMvt := 0;
  //                      IBQue_GetMvt.last;
  //                      iNbEnr := 0;
  //                    end;
            ////////////////////////////////  TEST  ////////////////////////////////
            ///
            ///
            sDate := FormatDateTime('yyyy', IBQue_GetMvt.FieldByName('ARFCREE').AsDateTime);

            // Ticket
            {$REGION 'Ticket'}
            if (iTypeMvt = 2) then
            begin
              if (iTkeId <> IBQue_GetMvt.FieldByName('MOVIDENTETE').AsInteger) then
              begin
                LogAction('Deb Tke - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
                iTkeId                        := IBQue_GetMvt.FieldByName('MOVIDENTETE').AsInteger;
                Ps_Ticket.Close;                                        //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                Ps_Ticket.Parameters[1].Value := 0;
                Ps_Ticket.Parameters[2].Value := AMagId;
                Ps_Ticket.Parameters[3].Value := iTkeId;
                Ps_Ticket.Parameters[4].Value := IBQue_GetMvt.FieldByName('TKEDATE').AsVariant;
                Ps_Ticket.Parameters[5].Value := IBQue_GetMvt.FieldByName('TKEBRUT').AsVariant;
                Ps_Ticket.Parameters[6].Value := IBQue_GetMvt.FieldByName('TKENET').AsVariant;
                Ps_Ticket.Parameters[7].Value := IBQue_GetMvt.FieldByName('TKEBECOL').AsVariant;
                if aIsOldDatabase then
                  Ps_Ticket.Parameters[8].Value := 0  // Nécessaire pour les bases inférieur à la version 15 de ginkoia
                else
                  Ps_Ticket.Parameters[8].Value := IBQue_GetMvt.FieldByName('TKEOSOIDREF').AsVariant;

  //                        Ps_Ticket.ExecProc;
                OpenAndLog(Ps_Ticket, 'Ps_Ticket', aSW);
                LogAction('OK Tke - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);

                iTkeIdDtb                                   := Ps_Ticket.Parameters[1].Value;
                Ps_Ticket.Close;                                        //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc

                IBQue_GetEnc.ParamByName('TKEID').AsInteger := iTkeId;
                IBQue_GetEnc.Open;
                while not IBQue_GetEnc.Eof do
                begin
                  LogAction('Deb Enc - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(IBQue_GetEnc.FieldByName('ENC_ID').AsInteger), logDebug);
                  Ps_Enc.Close;             //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                  Ps_Enc.Parameters[1].Value := iTkeIdDtb;
                  Ps_Enc.Parameters[2].Value := IBQue_GetEnc.FieldByName('ENC_ID').AsInteger;
                  Ps_Enc.Parameters[3].Value := IBQue_GetEnc.FieldByName('MEN_NOM').AsString;

                  if (IBQue_GetEnc.FieldByName('ENC_MONTANT').AsFloat = 0) and (IBQue_GetEnc.FieldByName('ENC_BA').AsFloat <> 0) then
                  begin
                    // Cas des pseudos remises
                    Ps_Enc.Parameters[4].Value := IBQue_GetEnc.FieldByName('ENC_BA').AsFloat;
                  end
                  else
                  begin
                    // Cas général
                    Ps_Enc.Parameters[4].Value := IBQue_GetEnc.FieldByName('ENC_MONTANT').AsFloat;
                  end;

                  Ps_Enc.Parameters[5].Value := IBQue_GetEnc.FieldByName('K_ENABLED').AsInteger;

  //                          Ps_Enc.ExecProc;
                  OpenAndLog(Ps_Enc, 'Ps_Enc', aSW);
                  Ps_Enc.Close;             //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                  LogAction('OK Enc - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(IBQue_GetEnc.FieldByName('ENC_ID').AsInteger), logDebug);

                  IBQue_GetEnc.Next;
                end;
                IBQue_GetEnc.Close;
              end
            end
            else
            begin
              iTkeIdDtb := 0;
            end;
            {$ENDREGION}
            // Coupon
            {$REGION 'Coupon'}
            if (iTypeMvt = 14) then
            begin
              LogAction('Deb COU - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
              PS_Coupons.Close;                                         //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
              PS_Coupons.Parameters[1].Value := 0;
              PS_Coupons.Parameters[2].Value := AMagId;
              PS_Coupons.Parameters[3].Value := IBQue_GetMvt.FieldByName('MOVIDENTETE').AsVariant;
              PS_Coupons.Parameters[4].Value := IBQue_GetMvt.FieldByName('MOVCB').AsVariant;
  //                      PS_Coupons.ExecProc;
              OpenAndLog(PS_Coupons, 'PS_Coupons', aSW);
              PS_Coupons.Close;                                         //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
              LogAction('OK COU - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
            end;
            {$ENDREGION}
            // Bons d'Achat
            {$REGION 'Bons Achats'}
            if (iTypeMvt = 13) then
            begin
              LogAction('Deb BAA - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
              Ps_BonsAchats.Close;                                      //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
              Ps_BonsAchats.Parameters[1].Value := 0;
              Ps_BonsAchats.Parameters[2].Value := AMagId;
              Ps_BonsAchats.Parameters[3].Value := IBQue_GetMvt.FieldByName('MOVIDORIGINE').AsInteger;
              Ps_BonsAchats.Parameters[4].Value := IBQue_GetMvt.FieldByName('MOVTKEID').AsVariant;
              Ps_BonsAchats.Parameters[5].Value := IBQue_GetMvt.FieldByName('MOVCHRONO').AsVariant;
              Ps_BonsAchats.Parameters[6].Value := IBQue_GetMvt.FieldByName('MOVVALEUR').AsVariant;
              Ps_BonsAchats.Parameters[7].Value := IBQue_GetMvt.FieldByName('MOVDTLIMDEB').AsVariant;
              Ps_BonsAchats.Parameters[8].Value := IBQue_GetMvt.FieldByName('MOVDTLIMFIN').AsVariant;
              Ps_BonsAchats.Parameters[9].Value := IBQue_GetMvt.FieldByName('MOVUTILTKEID').AsVariant;
              Ps_BonsAchats.Parameters[10].Value := IBQue_GetMvt.FieldByName('BAPNOM').AsVariant;
              Ps_BonsAchats.Parameters[11].Value := IBQue_GetMvt.FieldByName('MTYPE').AsVariant;
  //                      Ps_BonsAchats.ExecProc;
              OpenAndLog(Ps_BonsAchats, 'Ps_BonsAchats', aSW);
              Ps_BonsAchats.Close;                                      //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
              LogAction('OK BAA - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
            end;
            {$ENDREGION}
            if ((iTypeMvt <> 13) AND (iTypeMvt <> 14)) then
            begin
              LogAction('Deb Mvt - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
              // Maj des infos mouvement dans la structure pour insertion mouvement
              {$REGION 'Renseigne stMvt'}
              stMvt                := InitRecordMvt;

              stMvt.iDosid         := ADosid;                                             // @P_DOSID int,
              stMvt.iMagId         := AMagId;                                             // @P_MAGID int,
              // SR - 20/02/2013 - Correction transfert intermagasin
              if (iTypeMvt = 6) then     //Transfert Intermagasin - Sortie
              begin                      //On passe l'id en négatif
                stMvt.iMvtId         := -1 * IBQue_GetMvt.FieldByName('MOVIDORIGINE').AsInteger; // @P_MVTIDORIGINE int,
              end
              else
              begin
                stMvt.iMvtId         := IBQue_GetMvt.FieldByName('MOVIDORIGINE').AsInteger; // @P_MVTIDORIGINE int,
              end;
              stMvt.iTyp           := iTypeMvt;                                           // @P_MVTTYPE tinyint,
              stMvt.dtDateMvt      := IBQue_GetMvt.FieldByName('MOVDATE').AsDateTime;     // @P_MVTDATE datetime,
              stMvt.iArtId         := 0;                                                   // @P_ARTID int,
              stMvt.iArtIdOri         := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger; // @P_ARTIDORIGINE int,
              stMvt.sArtNom        := IBQue_GetMvt.FieldByName('ARTNOM').AsString;        // @P_ARTNOM VARCHAR (64),
              stMvt.sArtRefMrk     := IBQue_GetMvt.FieldByName('ARTREFMRK').AsString;     // @P_ARTREFMRK VARCHAR (64),
              stMvt.sMrkNom        := IBQue_GetMvt.FieldByName('MRKNOM').AsString;        // @P_MRKNOM VARCHAR (64),
              stMvt.iMrkIdRef      := IBQue_GetMvt.FieldByName('MRKIDREF').AsInteger;     // @P_MRKIDREF int,
              stMvt.sArtFedas      := IBQue_GetMvt.FieldByName('ARTFEDAS').AsString;      // @P_ARTFEDAS CHAR (6),
              stMvt.iArtPseudo     := IBQue_GetMvt.FieldByName('ARFPSEUDO').AsInteger;    // @P_ARTPSEUDO INT,
              stMvt.iGtfId         := 0;        // @P_GTFID INT,
              stMvt.iGtfIdOri         := IBQue_GetMvt.FieldByName('GTFID').AsInteger;        // @P_GTFIDORIGINE INT,
              stMvt.sGtfNom        := IBQue_GetMvt.FieldByName('GTFNOM').AsString;        // @P_GTFNOM VARCHAR (64),
              stMvt.sDateCree      := sDate;                                              // @P_DATECREE VARCHAR(4),
              stMvt.iTgfId         := 0;// @P_TGFID int,
              stMvt.iTgfIdOri         := IBQue_GetMvt.FieldByName('TGFIDORIGINE').AsInteger; // @P_TGFIDORIGINE int,
              stMvt.sTgfNom        := IBQue_GetMvt.FieldByName('TGFNOM').AsString;        // @P_TGFNOM VARCHAR(32),
              stMvt.iCouId         := 0; // @P_COUID int,
              stMvt.iCouIdOri         := IBQue_GetMvt.FieldByName('COUIDORIGINE').AsInteger; // @P_COUIDORIGINE int,
              stMvt.sCouNom        := IBQue_GetMvt.FieldByName('COUNOM').AsString;        // @P_COUNOM VARCHAR(64),
              stMvt.sCouCode       := IBQue_GetMvt.FieldByName('COUCODE').AsString;       // @P_COUCODE VARCHAR(64),
              stMvt.iQte           := IBQue_GetMvt.FieldByName('MOVQTE').AsInteger;       // @P_MVTQTE int,
              stMvt.iKEnabled      := IBQue_GetMvt.FieldByName('MOVKENABLED').AsInteger;  // @K_ENABLED int
              stMvt.dtDateLivr     := IBQue_GetMvt.FieldByName('MOVDTLIV').AsDateTime;
              stMvt.fPxBrutTTC     := IBQue_GetMvt.FieldByName('MOVPXBRUTTTC').AsFloat;
              stMvt.fPxBrutHT      := IBQue_GetMvt.FieldByName('MOVPXBRUTHT').AsFloat;
              stMvt.fPxNetTTC      := IBQue_GetMvt.FieldByName('MOVPXNETTTC').AsFloat;
              stMvt.fPxNetHT       := IBQue_GetMvt.FieldByName('MOVPXNETHT').AsFloat;
              stMvt.fPump          := IBQue_GetMvt.FieldByName('MOVPUMP').AsFloat;
              stMvt.fTva           := IBQue_GetMvt.FieldByName('MOVTVA').AsFloat;
              stMvt.iCodeTypeVente := IBQue_GetMvt.FieldByName('MOVTYPEVTE').AsInteger;
              stMvt.sTypeVente     := IBQue_GetMvt.FieldByName('MOVTYPEVTELIB').AsString;
              stMvt.iFouId         := IBQue_GetMvt.FieldByName('FOUIDORIGINE').AsInteger;
              stMvt.sCollection    := IBQue_GetMvt.FieldByName('MOVCOLLEC').AsString;
              stMvt.fArtPump       := IBQue_GetMvt.FieldByName('ARTPUMP').AsFloat;
              stMvt.iTkeId         := iTkeIdDtb;
              stMvt.dtModif        := IBQue_GetMvt.FieldByName('MOVKUPDATED').AsFloat;
              stMvt.iFusion        := IBQue_GetMvt.FieldByName('MOVFUSION').AsInteger;

              {$ENDREGION}
              if InsertMvt(stMvt, aSW) then
              begin
                LogAction('OK Mvt - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(stMvt.iMvtId), logDebug);
                // Fournisseurs : déja fait en Init
                if not aInit then
                begin
                  {$REGION 'Fournisseurs'}
                  IBQue_GetFourn.Close;
                  IBQue_GetFourn.ParamByName('ARTID').AsInteger := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger;
  //                      IBQue_GetFourn.Open;
                  OpenAndLog(IBQue_GetFourn, 'IBQue_GetFourn', aSW);
                  IBQue_GetFourn.First;
                  LogAction('Ok Que fou' + IntToStr(IBQue_GetFourn.RecordCount), logDebug);
                  while not IBQue_GetFourn.Eof do
                  begin
                    IF IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger = 1 THEN
                    BEGIN
                      IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := IBQue_GetFourn.FieldByName('FOU_ID').AsInteger;
  //                          IBQue_GetFouIdRef.Open;
                      OpenAndLog(IBQue_GetFouIdRef, 'IBQue_GetFouIdRef', aSW);
                      if NOT IBQue_GetFouIdRef.Eof then
                      begin
                        vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
                      end
                      else
                      begin
                        // Pas d'idref
                        vFouIdRef := 0;
                      end;

                      IBQue_GetFouIdRef.Close;
                    END
                    else
                    begin
                      // Pas d'idref
                      vFouIdRef := 0;
                    end;

                    LogAction('Deb Fou - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger), logDebug);
                    Ps_Fournisseur.Close;                                   //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                    Ps_Fournisseur.Parameters[1].Value := 0;                                                  // @R_FOUID (output)
                    Ps_Fournisseur.Parameters[2].Value := aDosId;                                             // @P_DOSID int,
                    Ps_Fournisseur.Parameters[3].Value := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger; // @P_ARTIDORIGINE int,
                    Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                          // @P_FOUIDREF int,
                    Ps_Fournisseur.Parameters[5].Value := IBQue_GetFourn.FieldByName('FOU_NOM').AsString;     // @P_FOUNOM int

  //                        Ps_Fournisseur.ExecProc;
                    OpenAndLog(Ps_Fournisseur, 'Ps_Fournisseur', aSW);
                    Ps_Fournisseur.Close;                                   //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                    LogAction('OK Fou - K=' + IntToStr(iLastK) + ' - mvtid=' + IntToStr(IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger), logDebug);

                    IBQue_GetFourn.Next;
                  end;
                  IBQue_GetFourn.Close;
                  {$ENDREGION}
                end;
                Inc(iNbMvt);

                iLastK := IBQue_GetMvt.FieldByName('MOVKVERSION').AsInteger;

                DoProgress;

                IBQue_GetMvt.Next;

              end
              else
              begin
                bFinBoucle := True;
              end;
            end
            else
            begin
              Inc(iNbMvt);
              iLastK := IBQue_GetMvt.FieldByName('MOVKVERSION').AsInteger;
              DoProgress;
              IBQue_GetMvt.Next;
            end;
          end; // End While IBQue_GetMvt

          if not bFinBoucle then
          begin
            Log.Log(sLogSrv,'Traitement',sLogDos,sLogRef,sLogMag,IntToStr(iTypeMvt),'OK',loginfo,true);
            InsertHisto(1, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'OK');
          end
          else
          begin
            Log.Log(sLogSrv,'Traitement',sLogDos,sLogRef,sLogMag,IntToStr(iTypeMvt),'KO : ' + FErreurSQLTexte,logError,true);
            InsertHisto(0, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'Erreur d''intrégration');
            iNbEnr := 0;
            Inc(FErreurSQL);
          end;
        end
        else begin // Retour = 0
          InsertHisto(0, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'Code adhérent non renseigné');
          iNbEnr := 0;
        end; // End IF Retour = 1
      end   // End if iNbEnr > 0
      else begin
        if iPassage = 1 then // Premier passage et rien dans le dataset = paquet vide, on note le lastk
        begin
          Log.Log(sLogSrv,'Traitement',sLogDos,sLogRef,sLogMag,IntToStr(iTypeMvt),'OK',logInfo,true);
          InsertHisto(1, AMagId, iKDeb, iCurVersion, iTypeMvt, 0, dtDebutTrt, Now(), 'OK');
        end;
      end;
      ADODatabase.CommitTrans;
      IBQue_GetMvt.Close;
    until iNbEnr < 1; // End while paquet de 9999            //SR : 16/07/2014 : Remplacement  until iNbEnr = 0
  except
    on e:exception do
    begin
      LogAction('Erreur d''intégration dans SQLServeur : ' + E.Message, logError);
      LogAction(E.Message, logError);
      LogAction(IntToStr(stMvt.iMvtId) + ' - ' + IntToStr(iLastK) + ' - ' + IntToStr(iTypeMvt), LogError);

      Log.Log(sLogSrv,'Traitement',sLogDos,sLogRef,sLogMag,'integration',E.Message,logError,true);
      InsertHisto(0, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'Erreur d''intégration dans SQLServeur');
    end;
  end;
end;

procedure TDm_ExtractDatabase.DoNewTraitement;
var
  ModeCheck : TModeCheck;
  DDebut, DFin : Variant;
  frmDoByDate : Tfrm_DoByDate;
  bContinue : Boolean;
  i : Integer;

  vDosID, vMagID, vKdeb, vKFin : Integer;
  vMagCode, vCheminBase : String;
  vDateActiv : TDateTime;
  bIsOldDatabase : Boolean;
  vTypeAction : TTypeAction;
  vOptionsActions : TOptionActions;
  vOptionsMvts : ToptionMvts;
  vOptionsMvt : TOptionMvt;
  vSW : TStopwatch;

begin
  FExit := False;
  FNbt_Stop.Visible := True;
  FNbt_Stop.OnClick := nbt_stopClick;
  FNbt_Stop.Caption := 'Arret du traitement';

  // Connexion à la base de données + récupération liste des magasins
  IniCfg.LoadIni;
  DataBaseConnection;

  AdQue_GetListMags.Close;
  AdQue_GetListMags.Close;
  AdQue_GetListMags.SQL.Clear;
  AdQue_GetListMags.SQL.Add('select mag_id, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom, max(mhi_datefin) replic, dos_nom,');
  AdQue_GetListMags.SQL.Add(' max(mag_extractCLT) mag_extractCLT, max(mag_extractCLTLastK) mag_extractCLTLastK, max(mag_database) mag_database, MAG_VILLE');
  AdQue_GetListMags.SQL.Add(' from ' + getDatabase + 'magasin mag with (nolock)');
  AdQue_GetListMags.SQL.Add(' join ' + getDatabase + 'dossiers dos on dos_id=mag_dosid	');
  AdQue_GetListMags.SQL.Add(' left outer join magasinhistodtb histo on (mag.mag_id=histo.mhi_magid and histo.mhi_ok=1)');
  AdQue_GetListMags.SQL.Add(' where mag_enabled=1');
  AdQue_GetListMags.SQL.Add('  and ((mag_database=1) or (mag_extractCLT=1))');
  AdQue_GetListMags.SQL.Add('  and mag_tymid<>3');
  AdQue_GetListMags.SQL.Add('  and mag_dtbdateactivation <= current_timestamp');
  AdQue_GetListMags.SQL.Add(' group by mag_id, mag_actif, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom,dos_nom, MAG_VILLE');
  AdQue_GetListMags.SQL.Add(' Order By mag_code');
  AdQue_GetListMags.Open;
  AdQue_GetListMags.First;

  Try
    // Ouverture d'interface
    frmDoByDate := Tfrm_DoByDate.create(nil);
    if frmDoByDate.DoByDateFormShow(AdQue_GetListMags, ModeCheck, vTypeAction, DDebut, DFin, vOptionsActions, vOptionsMvts) = mrCancel then
      exit;

    i := 0;
    bContinue := True;
    while bContinue and not AdQue_GetListMags.Eof do
    begin

     {$REGION 'gestion de la liste des magasins'}
     case ModeCheck of
       mcAll: begin
        // sur un traitement complet on limite aux bases autorisées
        vCheminBase := AdQue_GetListMags.FieldByName('mag_cheminbase').AsString;
        if not IsPathInList(vCheminBase,IniCfg.LstLames) then
        begin
          AdQue_GetListMags.Next;
          Continue;
        end;
        InitProgress('Traitement Magasin ' + AdQue_GetListMags.FieldByName('MAG_NOM').AsString,AdQue_GetListMags.RecordCount, AdQue_GetListMags.BOF);
       end;
       mcPartial: begin
         if frmDoByDate.dxDBGrid1.SelectedCount > i then
         begin
           AdQue_GetListMags.GotoBookmark(frmDoByDate.dxDBGrid1.SelectedRows[i]);
           InitProgress('Traitement Magasin ' + AdQue_GetListMags.FieldByName('MAG_NOM').AsString,frmDoByDate.dxDBGrid1.SelectedCount, i = 0);
           vCheminBase := AdQue_GetListMags.FieldByName('mag_cheminbase').AsString;
         end
         else begin
           bContinue := False;
           Continue;
         end;
       end;
     end;
    {$ENDREGION}

    Try

    {$REGION 'connexion à la base de données Ginkoia'}
    Ginkoia.Close;
    Ginkoia.DatabaseName := AdQue_GetListMags.FieldByName('mag_cheminbase').AsString;
    TRY
      Ginkoia.Open;
    EXCEPT
      // Chemin inccorect à voir si on log, ca peut être normal tant qu'on a pas renseigné le chemin
      Log.Log('','Main','','','','Status','Echec connexion : ' + AdQue_GetListMags.FieldByName('mag_cheminbase').AsString,logInfo,false);

      raise Exception.Create('Connection Ginkoia échouée - ' + AdQue_GetListMags.FieldByName('mag_cheminbase').AsString);
    END;
    {$ENDREGION}

    {$REGION 'Récupération des informations de plage'}
    vDosId := AdQue_GetListMags.FieldByName('DOS_ID').AsInteger;
    vMagID := AdQue_GetListMags.FieldByName('MAG_ID').AsInteger;
    vMagCode := AdQue_GetListMags.FieldByName('mag_code').AsString;
    vDateActiv := AdQue_GetListMags.FieldByName('mag_dtbdateactivation').AsDateTime;
    // Récupération des K Version seulement si on fait des actions qui nécessite de les utiliser
    if (oaArticle in vOptionsActions) or (oaMvt in vOptionsActions) then
    begin
      case vTypeAction of
        taDate: begin
          vKdeb := GetKByDate(VarToDateTime(DDEbut),mfMin);
          vKFin := GetKByDate(VarToDateTime(DFin),mfMax);
        end;
        taKVersion: begin
          vKdeb := DDEbut;
          vKFin := DFin;
        end;
      end;
    end;
    {$ENDREGION}

    {$REGION 'Traitement des articles'}
    if oaArticle in vOptionsActions then
    begin
      Log.Log('','Main','','','','Status','Récupération des articles',logInfo,true);
      UpdateArticle(vDosId, vMagId, vKDeb, vKFin ,maArt,'');
    end;
    {$ENDREGION}

    {$REGION 'Recalcul Stock'}
    Log.Log('','Main','','','','Status','Recalcul du stock',logInfo,true);
    RecalStock;
    {$ENDREGION}

    {$REGION 'Traitement des mouvements'}
    if oaMvt in vOptionsActions then
    begin
      {$REGION 'Vérification de la présence des tables OCSP2K'}
        IBQue_Tmp.Close;
        IBQue_Tmp.SQL.Clear;
        IBQue_Tmp.SQL.Add('select distinct count(*) as Resultat from rdb$RELATION_FIELDS');
        IBQue_Tmp.SQL.Add('where RDB$VIEW_CONTEXT is null');
        IBQue_Tmp.SQL.Add('and RDB$SYSTEM_FLAG = 0');
        IBQue_Tmp.SQL.Add('and RDB$RELATION_NAME = ''OCSP2K''');
        IBQue_Tmp.SQL.Add('GROUP BY  RDB$RELATION_NAME;');
        IBQue_Tmp.Open;

        bIsOldDatabase := (IBQue_Tmp.FieldByName('Resultat').AsInteger = 0);
      {$ENDREGION}

      for vOptionsMvt in vOptionsMvts do
      begin
        doDelta(vCheminBase,vDosId,vMagId,vMagCode,vKDeb,Ord(vOptionsMvt) + 1,vKFin,vDateActiv,bIsOldDatabase,False,False,vSW);
      end;

      UpdateUtilTkeID(vMagID);
    end;
    {$ENDREGION}

    {$REGION 'Correction Fildelité'}
    if oaFidelite in vOptionsActions then
      GestionCorrectionFildelite(vMagId,vMagCode);
    {$ENDREGION}

    {$REGION 'Correction Mouvement'}
    if oaCorrMvt in vOptionsActions then
      GestionCorrectionMouvement(vMagId,vMagCode);
    {$ENDREGION}

    {$REGION 'Gstion du Stock'}
    if oaStock in vOptionsActions then
      GestionStock(vMagId,vMagCode);
    {$ENDREGION}

    Except on E:Exception do
      begin
        LogAction(AdQue_GetListMags.FieldByName('MAG_CODE').AsString + E.Message, logError);

        if not ADODatabase.InTransaction then
          ADODatabase.BeginTrans;
        try
          InsertHisto(0, AdQue_GetListMags.FieldByName('MAG_ID').AsInteger, 0, 0, 0, 0, Now(), Now(), E.Message);
        finally
          ADODatabase.CommitTrans;
        end;
      end;
    End;

    if FExit then
    begin
      InitProgress('Traitement Annulé', 0);
      Exit;
    end;

    {$REGION 'Gestion magasin suivant'}
     case ModeCheck of
       mcAll: AdQue_GetListMags.Next;
       mcPartial: begin
         inc(i);
       end;
     end;
     DoProgress;
    {$ENDREGION}
    end; // while

    {$REGION 'Traitment des CB'}
    if oaCB in vOptionsActions then
    begin
      DoTraitementCB;
    end;
    {$ENDREGION}

    InitProgress('Fin du traitement', 0);

  // Libération
  finally
    frmDoByDate.Release;
    FNbt_Stop.Visible := False;
    FNbt_Stop.OnClick := nil;

  end;
end;

procedure TDm_ExtractDatabase.DoProgress();
begin
  if FMainProgress <> Nil then
  begin
    FMainProgress.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TDm_ExtractDatabase.DataBaseConnection;
begin
    ADODatabase.Close;
    // Connection à la database CATMAN
    ADODatabase.ConnectionString := IniCfg.MsSqlConnectionString;
    ADODatabase.Open;
end;

procedure TDm_ExtractDatabase.DoTraitement(ADoInit, ADoTraitementAfterInit,
  ADoOneMag: boolean; ACodeADH: string; bAskPlage : Boolean = false);
var
  sPathIni             : string;     // Chemin vers l'ini
  iniConfigAppli       : TIniFile;   // Manipulation du Fichier Ini

  sURLSrv              : string;     // URL Du serveur sur lequel se connecter.
  // wsPathConnectCatman  : Widestring; // Chaine de connexion CatMan
  wsPathConnectDatabase: Widestring; // Chaine de connexion Database

  iDosid               : integer;    // Contient l'id du dossier à traiter.
  iSqlErr              : Integer;   //Varriable d'erreur
  MAG_ID : integer;
  iVersion : string;
begin
  Log.Log('','Main','','','','Status','lancement',logInfo,true);
  iVersion := uversion.GetNumVersionSoft();
  Log.Log('','Main','','','','Version',iVersion,logInfo,true);
  IniCfg.LoadIni;
  FURLSrv        := IniCfg.ServeurUrl;
  DataBaseConnection;
  iSqlErr := 0;
  FErreurSQL := 0;      //SR : 16/07/2014 : Ajout pour relancer en cas d'erreur
  FErreurSQLTexte := '';
//  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
//  try
//    iniConfigAppli := TIniFile.Create(sPathIni);
//    sURLSrv        := iniConfigAppli.ReadString('DATABASE', 'URL', '');
//  finally
//    iniConfigAppli.Free;
//  end;

//  if sURLSrv <> '' then
  if IniCfg.ServeurUrl <> '' then

  begin
    // wsPathConnectCatman := 'Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Initial Catalog=DATABASE;Data Source=' +
    // 'lame5.no-ip.com' +
    // // 'sp2kcat.no-ip.org' +
    // ';Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=BRUNON_NB;Use Encryption for Data=False;Tag with column collation when possible=False';

//    wsPathConnectDatabase := 'Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Initial Catalog=DATABASE;Data Source=' +
//      sURLSrv + ';Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=BRUNON_NB;Use Encryption for Data=False;Tag with column collation when possible=False';
//
//    // Connection à la database CATMAN
//    ADODatabase.ConnectionString := wsPathConnectDatabase;
//    ADODatabase.Open;

//    InitProgress('Connexion à ' + sURLSrv, 1);
    InitProgress('Connexion à ' + IniCfg.ServeurUrl, 1);
    Log.Log('','Main','','','','Status','Connexion à ' + IniCfg.ServeurUrl,logInfo,false);

    try
      DoProgress();

      // Récup des dos_id à initialiser
      AdQue_GetListMags.Close;
      AdQue_GetListMags.Close;
      AdQue_GetListMags.SQL.Clear;
      AdQue_GetListMags.SQL.Add('select mag_id, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom, max(mhi_datefin) replic,');
      AdQue_GetListMags.SQL.Add(' max(mag_extractCLT) mag_extractCLT, max(mag_extractCLTLastK) mag_extractCLTLastK, max(mag_database) mag_database');
      AdQue_GetListMags.SQL.Add(' from ' + getDatabase + 'magasin mag with (nolock)');
      AdQue_GetListMags.SQL.Add(' join ' + getDatabase + 'dossiers dos on dos_id=mag_dosid	');
      AdQue_GetListMags.SQL.Add(' left outer join magasinhistodtb histo on (mag.mag_id=histo.mhi_magid and histo.mhi_ok=1)');
      AdQue_GetListMags.SQL.Add(' where mag_enabled=1');

      if ADoOneMag then
        AdQue_GetListMags.SQL.Add(' and mag_code=' + QuotedStr(ACodeADH) + ' ');

      AdQue_GetListMags.SQL.Add('  and ((mag_database=1) or (mag_extractCLT=1))');
      AdQue_GetListMags.SQL.Add('  and mag_tymid<>3');
      AdQue_GetListMags.SQL.Add('  and mag_dtbdateactivation <= current_timestamp');
      AdQue_GetListMags.SQL.Add(' group by mag_id, mag_actif, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom');
      AdQue_GetListMags.SQL.Add(' Order By replic');
      AdQue_GetListMags.Open;
      AdQue_GetListMags.First;

      while not AdQue_GetListMags.Eof do
      begin
        MAG_ID := AdQue_GetListMags.FieldByName('MAG_ID').AsInteger;
        // Test pour savoir si l'on va traiter les bases de la liste.
        if not IsPathInList(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString,IniCfg.LstLames) then
        begin
          AdQue_GetListMags.Next;
          Continue;
        end;

        if AdQue_GetListMags.FieldByName('replic').IsNull then
        begin
          if ADoInit then
          begin
            // Traitement d'init
            InitBase(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString, AdQue_GetListMags.FieldByName('mag_code').AsString, AdQue_GetListMags.FieldByName('dos_id').AsInteger,
              AdQue_GetListMags.FieldByName('mag_id').AsInteger, AdQue_GetListMags.FieldByName('mag_dtbdateactivation').AsDateTime);
            if ADoTraitementAfterInit then
            begin
              if AdQue_GetListMags.FieldByName('mag_database').AsInteger = 1 then
              begin
                Dm_ImportOC.doImportOC(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString, AdQue_GetListMags.FieldByName('mag_code').AsString,
                  AdQue_GetListMags.FieldByName('dos_id').AsInteger,AdQue_GetListMags.FieldByName('mag_id').AsInteger) ;

                TraiteBase(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString, AdQue_GetListMags.FieldByName('mag_code').AsString, AdQue_GetListMags.FieldByName('dos_id').AsInteger,
                  AdQue_GetListMags.FieldByName('mag_id').AsInteger, AdQue_GetListMags.FieldByName('mag_dtbdateactivation').AsDateTime, ADoInit, bAskPlage);
              end;

//              if AdQue_GetListMagsmag_extractCLT.AsInteger = 1 then
//              begin
//                Dm_ImportClient.doImportClient(AdQue_GetListMagsmag_cheminbase.AsString, AdQue_GetListMagsmag_code.AsString,
//                  AdQue_GetListMagsdos_id.AsInteger,AdQue_GetListMagsmag_id.AsInteger,AdQue_GetListMagsmag_extractCLTlastK.AsInteger) ;
//              end;
            end;
          end;
        end
        else
        begin
          if not ADoInit then // On ne traite plus les autres magasins en cas d'init.
          begin
            // Traitement normal
            if AdQue_GetListMags.FieldByName('mag_database').AsInteger = 1 then
            begin
              Dm_ImportOC.doImportOC(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString, AdQue_GetListMags.FieldByName('mag_code').AsString,
                AdQue_GetListMags.FieldByName('dos_id').AsInteger,AdQue_GetListMags.FieldByName('mag_id').AsInteger) ;

              TraiteBase(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString, AdQue_GetListMags.FieldByName('mag_code').AsString, AdQue_GetListMags.FieldByName('dos_id').AsInteger,
                AdQue_GetListMags.FieldByName('mag_id').AsInteger, AdQue_GetListMags.FieldByName('mag_dtbdateactivation').AsDateTime, ADoInit, bAskPlage);
            end;

          end;
        end;
        if not ADoInit then
        begin
            if AdQue_GetListMags.FieldByName('mag_extractCLT').AsInteger = 1 then
            begin
              Dm_ImportClient.doImportClient(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString, AdQue_GetListMags.FieldByName('mag_code').AsString,
                AdQue_GetListMags.FieldByName('dos_id').AsInteger,AdQue_GetListMags.FieldByName('mag_id').AsInteger,AdQue_GetListMags.FieldByName('mag_extractCLTlastK').AsInteger) ;
            end;
          end;


        if AdQue_GetListMags.Active then
          AdQue_GetListMags.Next
        else begin
          // La Query a été fermé ou l'ouvre a nouveau et on repositionne
          AdQue_GetListMags.Open;
          AdQue_GetListMags.Locate('MAG_ID',MAG_ID,[]);
          AdQue_GetListMags.Next;
        end;


        if (FErreurSQL > 0) then
        begin
          InitProgress('Erreur de connexion SQL.', 0);
          Log.Log('','Main','','','','Status','Erreur de connexion SQL : ' + FErreurSQLTexte,logError,false);
          FErreurSQL := 0;
          FErreurSQLTexte := '';
          DataBaseConnection;
          AdQue_GetListMags.Close;
          AdQue_GetListMags.Open;
          AdQue_GetListMags.First;
          if iSqlErr > 5 then
          begin
            AdQue_GetListMags.Last;
          end;
          Inc(iSqlErr);
        end;
      end;
      AdQue_GetListMags.Close;

      // traitement des CB
      DoTraitementCB;

    finally
      // Fermeture des connections
//      if ADoOneMag then
//      begin
//        AdQue_GetListMags.Close;
//        AdQue_GetListMags.SQL.Clear;
//        AdQue_GetListMags.SQL.Add('select mag_id, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom, max(mhi_datefin) replic,');
//        AdQue_GetListMags.SQL.Add(' max(mag_extractCLT) mag_extractCLT, max(mag_extractCLTLastK) mag_extractCLTLastK, max(mag_database) mag_database');
//        AdQue_GetListMags.SQL.Add(' from ' + getDatabase + 'magasin mag');
//        AdQue_GetListMags.SQL.Add(' join ' + getDatabase + 'dossiers dos on dos_id=mag_dosid	');
//        AdQue_GetListMags.SQL.Add(' left outer join magasinhistodtb histo on (mag.mag_id=histo.mhi_magid and histo.mhi_ok=1)');
//        AdQue_GetListMags.SQL.Add(' where mag_enabled=1');
//        AdQue_GetListMags.SQL.Add('  and ((mag_database=1) or (mag_extractCLT=1))');
//        AdQue_GetListMags.SQL.Add('  and mag_tymid<>3');
//        AdQue_GetListMags.SQL.Add('  and mag_dtbdateactivation <= current_timestamp');
//        AdQue_GetListMags.SQL.Add(' group by mag_id, mag_actif, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom');
//      end;

      ADODatabase.Close;

      CloseProgress;
      Log.Log('','Main','','','','Status','Fin traitement',logInfo,false);
    end;
  end
  else
  begin
    LogAction('URL Serveur non renseignée dans l''INI', logError);
  end;
end;

procedure TDm_ExtractDatabase.DoTraitementCB;
var
  iPass : Integer;
begin
    IniCfg.LoadIni;
    DataBaseConnection;

    InitProgress('Récupération de la liste des magasins',0);
    AdQue_GetListMags.Close;
    AdQue_GetListMags.SQL.Clear;
    AdQue_GetListMags.SQL.Add('select mag_id, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom, max(mhi_datefin) replic,');
    AdQue_GetListMags.SQL.Add(' max(mag_extractCLT) mag_extractCLT, max(mag_extractCLTLastK) mag_extractCLTLastK, max(mag_database) mag_database');
    AdQue_GetListMags.SQL.Add(' from ' + getDatabase + 'magasin mag with (nolock)');
    AdQue_GetListMags.SQL.Add(' join ' + getDatabase + 'dossiers dos on dos_id=mag_dosid	');
    AdQue_GetListMags.SQL.Add(' left outer join magasinhistodtb histo on (mag.mag_id=histo.mhi_magid and histo.mhi_ok=1)');
    AdQue_GetListMags.SQL.Add(' where mag_enabled=1');
    AdQue_GetListMags.SQL.Add('  and ((mag_database=1) or (mag_extractCLT=1))');
    AdQue_GetListMags.SQL.Add('  and mag_tymid<>3');
    AdQue_GetListMags.SQL.Add('  and mag_dtbdateactivation <= current_timestamp');
    AdQue_GetListMags.SQL.Add(' group by mag_id, mag_actif, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom');
    AdQue_GetListMags.Open;
    AdQue_GetListMags.First;
    InitProgress('',AdQue_GetListMags.RecordCount);

    Try
      while not AdQue_GetListMags.Eof do
      begin

        // Test pour savoir si l'on va traiter les bases de la liste.
        if not IsPathInList(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString,IniCfg.LstLames) then
        begin
          AdQue_GetListMags.Next;
          DoProgress;
          Continue;
        end;

        Ginkoia.Close;
        Ginkoia.DatabaseName := AdQue_GetListMags.FieldByName('mag_cheminbase').AsString;
        Ginkoia.Open;
        iPass := 0;
        while iPass < 2 do
        Try
          InitProgress('Init CB : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,0, False);

          // Récupération de la liste des modèles n'ayant pas de CB pour le magasin en cours
//          With ADOQue_LstTmp do
          begin
            case iPass of

              0: begin // Vérification via les mouvements
                ADOQue_LstTmp.Close;
                ADOQue_LstTmp.SQL.Clear;
                ADOQue_LstTmp.SQL.Add('select distinct art_id, art_idorigine, cou_id, cou_idorigine, tgf_id, tgf_idorigine from MOUVEMENTS B with (nolock)');
                ADOQue_LstTmp.SQL.Add(' join article on art_id=B.mov_artid');
                ADOQue_LstTmp.SQL.Add(' join couleur on cou_id = B.mov_couid');
                ADOQue_LstTmp.SQL.Add(' join tailleligne on tgf_id = B.mov_tgfid');
                ADOQue_LstTmp.SQL.Add(' where mov_magid = :PMAGID');
                ADOQue_LstTmp.SQL.Add('   and art_id not in(select cbi_artid from CODEBARRE A where B.MOV_ARTID=A.cbi_artid and B.MOV_COUID=A.CBI_COUID and B.MOV_TGFID=A.CBI_TGFID)');
                ADOQue_LstTmp.ParamCheck := True;
                ADOQue_LstTmp.Parameters.ParamValues['PMAGID'] := AdQue_GetListMags.FieldByName('MAG_ID').AsInteger;
                ADOQue_LstTmp.Open;
              end;
              1: begin  // vérification via le stock

                ADOQue_LstTmp.Close;
                ADOQue_LstTmp.SQL.Clear;
                ADOQue_LstTmp.SQL.Add('SELECT distinct art_id, art_idorigine, cou_id, cou_idorigine, tgf_id, tgf_idorigine');
                ADOQue_LstTmp.SQL.Add('FROM dbo.STOCK with (nolock)');
                ADOQue_LstTmp.SQL.Add('join article on art_id=Stk_artid');
                ADOQue_LstTmp.SQL.Add('join couleur on cou_id = stk_couid');
                ADOQue_LstTmp.SQL.Add('join tailleligne on tgf_id = stk_tgfid');
                ADOQue_LstTmp.SQL.Add('LEFT OUTER JOIN dbo.CODEBARRE ON STK_ARTID = CBI_ARTID AND STK_TGFID = CBI_TGFID AND STK_COUID = CBI_COUID');
                ADOQue_LstTmp.SQL.Add('WHERE CBI_ID IS NULL and stk_magid = :PMAGID');
                ADOQue_LstTmp.ParamCheck := True;
                ADOQue_LstTmp.Parameters.ParamValues['PMAGID'] := AdQue_GetListMags.FieldByName('MAG_ID').AsInteger;
                ADOQue_LstTmp.Open;
              end;
            end;

            while not ADOQue_LstTmp.EOF do
            begin
              // récupétration de l'ARFID
              IBQue_Tmp.Close;
              IBQue_Tmp.SQL.Clear;
              IBQue_Tmp.SQL.Add('SELECT ARF_ID FROM ARTREFERENCE');
              IBQue_Tmp.SQL.Add(' Where ARF_ARTID = :PARTID');
              IBQue_Tmp.ParamCheck := True;
              IBQue_Tmp.ParamByName('PARTID').AsInteger := ADOQue_LstTmp.FieldByName('ART_IDORIGINE').AsInteger;
              IBQue_Tmp.Open;

              // Récupération du CB
              IBQue_GetCB.Close;
              IBQue_GetCB.ParamByName('ARFID').AsInteger := IBQue_Tmp.FieldByName('ARF_ID').AsInteger;
              IBQue_GetCB.ParamByName('COUID').AsInteger := ADOQue_LstTmp.FieldByName('COU_IDORIGINE').AsInteger;
              IBQue_GetCB.ParamByName('TGFID').AsInteger  := ADOQue_LstTmp.FieldByName('TGF_IDORIGINE').AsInteger;
              IBQue_GetCB.Open;

//                        if IBQue_GetCB.Eof then // demande client, pseudo sans CB  -> Artid_dossier
//                        begin
//                          LogAction('Ok Que EOF' + IntToStr(IBQue_GetCB.RecordCount), 3);
//                          vCodeEAN := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsString + '_' + IntToStr(ADosid);
//                          vTypeEAN := 3;
//                        end
//                        else
//                        begin
//                          LogAction('Ok Que PAS EOF' + IntToStr(IBQue_GetCB.RecordCount), 3);
//                          vTypeEAN := IBQue_GetCB.FieldByName('TYPECB').AsVariant;
//                          if IBQue_GetCB.FieldByName('TYPECB').AsInteger = 3 then
//                          begin
//                            LogAction('Ok Que 1' + IntToStr(IBQue_GetCB.RecordCount), 3);
//                            vCodeEAN := IBQue_GetCB.FieldByName('CBICB').AsVariant + '_' + IntToStr(ADosid);
//                          end
//                          else
//                          begin
//                            LogAction('Ok Que 2' + IntToStr(IBQue_GetCB.RecordCount), 3);
//                            vCodeEAN := IBQue_GetCB.FieldByName('CBICB').AsVariant
//                          end;
//                        end;

              if IBQue_GetCB.EOF then
              begin
                AQue_INSERTTmp.Close;
                AQue_INSERTTmp.SQL.Clear;
                AQue_INSERTTmp.SQL.Add('INSERT INTO CODEBARRE(CBI_ARTID, CBI_COUID, CBI_TGFID, CBI_TYPE, CBI_EAN)');
                AQue_INSERTTmp.SQL.Add('VALUES(:PARTID, :PCOUID, :PTGFID, :PTYPE, :PEAN)');
                AQue_INSERTTmp.ParamCheck := True;
                AQue_INSERTTmp.Parameters.ParamByName('PARTID').Value := ADOQue_LstTmp.FieldByName('ART_ID').AsInteger;
                AQue_INSERTTmp.Parameters.ParamByName('PCOUID').Value := ADOQue_LstTmp.FieldByName('COU_ID').AsInteger;
                AQue_INSERTTmp.Parameters.ParamByName('PTGFID').Value := ADOQue_LstTmp.FieldByName('TGF_ID').AsInteger;
                AQue_INSERTTmp.Parameters.ParamByName('PTYPE').Value  := 3;
                AQue_INSERTTmp.Parameters.ParamByName('PEAN').Value := ADOQue_LstTmp.FieldByName('art_idorigine').AsString + '_' + IntToStr(AdQue_GetListMags.FieldByName('DOS_ID').AsInteger);

                ADODatabase.BeginTrans;
                AQue_INSERTTmp.ExecSQL;
                ADODatabase.CommitTrans;
              end;

              While not IBQue_GetCB.EOF do
              begin
                if IBQue_GetCB.FieldByName('K_Enabled').AsInteger = 1 then
                begin
                  // Insertion du CB
                  AQue_INSERTTmp.Close;
                  AQue_INSERTTmp.SQL.Clear;
                  AQue_INSERTTmp.SQL.Add('INSERT INTO CODEBARRE(CBI_ARTID, CBI_COUID, CBI_TGFID, CBI_TYPE, CBI_EAN)');
                  AQue_INSERTTmp.SQL.Add('VALUES(:PARTID, :PCOUID, :PTGFID, :PTYPE, :PEAN)');
                  AQue_INSERTTmp.ParamCheck := True;
                  AQue_INSERTTmp.Parameters.ParamByName('PARTID').Value := ADOQue_LstTmp.FieldByName('ART_ID').AsInteger;
                  AQue_INSERTTmp.Parameters.ParamByName('PCOUID').Value := ADOQue_LstTmp.FieldByName('COU_ID').AsInteger;
                  AQue_INSERTTmp.Parameters.ParamByName('PTGFID').Value := ADOQue_LstTmp.FieldByName('TGF_ID').AsInteger;
                  AQue_INSERTTmp.Parameters.ParamByName('PTYPE').Value  := IBQue_GetCB.FieldByName('TYPECB').AsInteger;
                  if IBQue_GetCB.FieldByName('TYPECB').AsInteger = 3 then
                    AQue_INSERTTmp.Parameters.ParamByName('PEAN').Value := IBQue_GetCB.FieldByName('CBICB').AsString + '_' + IntToStr(AdQue_GetListMags.FieldByName('DOS_ID').AsInteger)
                  else
                    AQue_INSERTTmp.Parameters.ParamByName('PEAN').Value := IBQue_GetCB.FieldByName('CBICB').AsString;

                  ADODatabase.BeginTrans;
                  AQue_INSERTTmp.ExecSQL;
                  ADODatabase.CommitTrans;
                end;

                IBQue_GetCB.Next;
              end;

              ADOQue_LstTmp.Next;
            end;
          end;

          Inc(iPass);
        Except on E:Exception do
          begin
            if ADODatabase.InTransaction then
              ADODatabase.RollbackTrans;
            raise;
          end;
        End;

        AdQue_GetListMags.Next;
        DoProgress;
      end;

      InitProgress('Init CB : Fin du traitement', 0,False);

    Except on E:Exception do
      begin
        Showmessage(Format('Une erreur est survenu lors du traitement de : %s - %s',[AdQue_GetListMags.FieldByName('MAG_NOM').AsString, E.Message]));
      end;
    End;

end;

procedure TDm_ExtractDatabase.DoTraitementMarque(AMrkNOM: String);
begin
    AdQue_GetListMags.Close;
    AdQue_GetListMags.SQL.Add('select mag_id, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom, max(mhi_datefin) replic,');
    AdQue_GetListMags.SQL.Add(' max(mag_extractCLT) mag_extractCLT, max(mag_extractCLTLastK) mag_extractCLTLastK, max(mag_database) mag_database');
    AdQue_GetListMags.SQL.Add(' from ' + getDatabase + 'magasin mag with (nolock)');
    AdQue_GetListMags.SQL.Add(' join ' + getDatabase + 'dossiers dos on dos_id=mag_dosid	');
    AdQue_GetListMags.SQL.Add(' left outer join magasinhistodtb histo on (mag.mag_id=histo.mhi_magid and histo.mhi_ok=1)');
    AdQue_GetListMags.SQL.Add(' where mag_enabled=1');
    AdQue_GetListMags.SQL.Add('  and ((mag_database=1) or (mag_extractCLT=1))');
    AdQue_GetListMags.SQL.Add('  and mag_tymid<>3');
    AdQue_GetListMags.SQL.Add('  and mag_dtbdateactivation <= current_timestamp');
    AdQue_GetListMags.SQL.Add(' group by mag_id, mag_actif, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom');
    AdQue_GetListMags.Open;
    AdQue_GetListMags.First;
    Try
      while not AdQue_GetListMags.Eof do
      begin

        // Test pour savoir si l'on va traiter les bases de la liste.
        if not IsPathInList(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString,IniCfg.LstLames) then
        begin
          AdQue_GetListMags.Next;
          DoProgress;
          Continue;
        end;

        Ginkoia.Close;
        Ginkoia.DatabaseName := AdQue_GetListMags.FieldByName('mag_cheminbase').AsString;
        Ginkoia.Open;

        ADODatabase.BeginTrans;
        Try
          InitProgress('Init Marque : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,0);

          UpdateArticle(AdQue_GetListMags.FieldByName('dos_id').AsInteger, AdQue_GetListMags.FieldByName('MAG_ID').AsInteger,0,0,maMrk, AMrkNOM);

          ADODatabase.CommitTrans;
          Except on E:Exception do
          begin
            ADODatabase.RollbackTrans;
            raise;
          end;
        End;

        AdQue_GetListMags.Next;
      end;

      InitProgress('Init Marque : Fin du traitement', 0);

    Except on E:Exception do
      begin
        Showmessage(Format('Une erreur est survenu lors du traitement de : %s - %s',[AdQue_GetListMags.FieldByName('MAG_NOM').AsString, E.Message]));
      end;
    End;
end;

procedure TDm_ExtractDatabase.GestionCorrectionCB(AMagID: Integer;
  AMagADH: String);
begin

end;

procedure TDm_ExtractDatabase.GestionCorrectionFildelite(AMagID: Integer;
  AMagADH: String);
var
  dDebut : TDateTime;
begin
  InitProgress('Correction Fildelité : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,2);

  Try

    {$REGION' Etape 1 : Récupération des informations Ginkoia et transfert'}
    try  With IBQue_Tmp do
      begin
        dDebut := Now;
        if not IBQue_Tmp.Transaction.InTransaction then
          IBQue_Tmp.Transaction.StartTransaction;

        Close;
        SQL.Clear;
        SQL.Add('SELECT TKE_ID AS WTO_TKE_IDORIGINE,');
        SQL.Add('       (SELECT SUM(CAST(TKL_QTE AS INTEGER) * TKL_PXBRUT)');
        SQL.Add('          FROM CSHTICKETL');
        SQL.Add('         WHERE CSHTICKET.TKE_ID = TKL_TKEID) AS WTO_TKE_BRUTORIGINE,');
        SQL.Add('       (SELECT SUM(CAST(TKL_QTE AS INTEGER) * TKL_PXNN)');
        SQL.Add('          FROM CSHTICKETL');
        SQL.Add('         WHERE CSHTICKET.TKE_ID = TKL_TKEID) AS WTO_TKE_NETORIGINE,');
        SQL.Add('       F_LINEWRAP(CCB_CB, 0, 20) AS WTO_TKE_BECOLORIGINE');
        SQL.Add('  FROM CSHTICKET JOIN K ON (K_ID = TKE_ID AND K_ENABLED = 1)');
        SQL.Add('  JOIN CSHSESSION ON TKE_SESID = SES_ID');
        SQL.Add('  JOIN GENPOSTE ON SES_POSID = POS_ID');
        SQL.Add('  JOIN GENMAGASIN ON POS_MAGID = MAG_ID');
        SQL.Add('  LEFT OUTER JOIN CSHCODEBARRREFID ON (    CCB_IDGINKOIA = TKE_ID');
        SQL.Add('                                       AND(   CCB_CB STARTING WITH ''254''');
        SQL.Add('                                           OR CCB_CB STARTING WITH ''256''');
        SQL.Add('                                           OR CCB_CB STARTING WITH ''258''))');
        SQL.Add('WHERE TKE_DATE >= ''2019-01-01'' AND TKE_ID <> 0 and MAG_CODEADH = :PMAGADH');
        SQL.Add('  AND CCB_CB IS NOT NULL and CCB_CB <> ''''');
        SQL.Add('ORDER BY TKE_ID, CCB_CB');
        ParamCheck := True;
        ParamByName('PMAGADH').AsString := AMagADH;
        Open;
        // Remplissage WRK_STOCK_Origine
        if not ADODatabase.InTransaction then
          ADODatabase.BeginTrans;
        // Suppression des anciennes données magasin
        AQue_INSERTTmp.Close;
        AQue_INSERTTmp.SQL.Clear;
        AQue_INSERTTmp.SQL.Add('Delete from WRK_TICKET_ORIGINE');
        AQue_INSERTTmp.SQL.Add('Where WTO_MAGID = :PMAGID');
        AQue_INSERTTmp.ParamCheck := True;
        AQue_INSERTTmp.Parameters.ParamByName('PMAGID').Value := AMagID;
        AQue_INSERTTmp.ExecSQL;


        AQue_INSERTTmp.Close;
        AQue_INSERTTmp.SQL.Clear;
        AQue_INSERTTmp.SQL.Add('INSERT INTO WRK_TICKET_ORIGINE(WTO_MAGID, WTO_DATECREATION, WTO_TKE_IDORIGINE,');
        AQue_INSERTTmp.SQL.Add(' WTO_TKE_BRUTORIGINE, WTO_TKE_NETORIGINE, WTO_KE_BECOLORIGINE)');
        AQue_INSERTTmp.SQL.Add('VALUES(:PMAGID, :PDATE, :PTKEO, :PTKEBRUTO, :PTKENETO, :PTKEBECOLO)');
        AQue_INSERTTmp.ParamCheck := True;
        AQue_INSERTTmp.Prepared := True;

        First;
        while not EOF do
        begin
          AQue_INSERTTmp.Close;
          AQue_INSERTTmp.Parameters.ParamByName('PMAGID').Value     := AMagID;
          AQue_INSERTTmp.Parameters.ParamByName('PDATE').Value      := Now;
          AQue_INSERTTmp.Parameters.ParamByName('PTKEO').Value      := FieldByName('WTO_TKE_IDORIGINE').AsInteger;
          AQue_INSERTTmp.Parameters.ParamByName('PTKEBRUTO').Value  := FieldByName('WTO_TKE_BRUTORIGINE').AsCurrency;
          AQue_INSERTTmp.Parameters.ParamByName('PTKENETO').Value   := FieldByName('WTO_TKE_NETORIGINE').AsCurrency;
          AQue_INSERTTmp.Parameters.ParamByName('PTKEBECOLO').Value := LeftStr(FieldByName('WTO_TKE_BECOLORIGINE').AsString, 20);
          AQue_INSERTTmp.ExecSQL;

          Next;
        end;
        InsertAudit(AMagID,dDebut, Now, 1, Recordcount, 1, 'GINKOIA -> WRK_TICKET_ORIGINE : Ok');
        IBQue_Tmp.Transaction.Commit;
        ADODatabase.CommitTrans;
      end;

      // Delete doublon
      ADODatabase.BeginTrans;
      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE WRK_TICKET_ORIGINE FROM WRK_TICKET_ORIGINE LEFT OUTER JOIN');
        SQL.Add('(SELECT MAX(WTO_id) as id,  WTO_TKE_IDORIGINE, WTO_MAGID FROM WRK_TICKET_ORIGINE');
        SQL.Add(' GROUP BY WTO_TKE_IDORIGINE, WTO_MAGID ) as t1 ON WRK_TICKET_ORIGINE.wto_id = t1.id WHERE t1.id IS NULL and WRK_TICKET_ORIGINE.WTO_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 1, AQue_INSERTTmp.RowsAffected, 1, 'WRK_TICKET_ORIGINE -> Delete : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 1, 0, 0, 'GINKOIA -> WRK_TICKET_ORIGINE : ' + E.Message);
        raise Exception.Create('GINKOIA -> WRK_TICKET_ORIGINE : ' + E.Message);
      end;
    End;
    {$ENDREGION}

    {$REGION 'Etape 2 : Mise à jour des lignes'}
    try
      // Merge Grille de taille
      ADODatabase.BeginTrans;
      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('MERGE TICKET as TARGET');
        SQL.Add('USING (Select WTO_MAGID, WTO_TKE_IDORIGINE, WTO_TKE_BRUTORIGINE, WTO_TKE_NETORIGINE, WTO_KE_BECOLORIGINE from WRK_TICKET_ORIGINE with (nolock) Where WTO_MAGID = :PMAGID) as SOURCE');
        SQL.Add('ON (TARGET.TKE_IDORIGINE = SOURCE.WTO_TKE_IDORIGINE and TARGET.TKE_MAGID = SOURCE.WTO_MAGID)');
        SQL.Add('WHEN MATCHED');
        SQL.Add('THEN UPDATE SET');
        SQL.Add('     TARGET.TKE_BECOL = SOURCE.WTO_KE_BECOLORIGINE;');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 2, AQue_INSERTTmp.RowsAffected, 1, 'WRK_TICKET_ORIGINE -> TICKET : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 2, 0, 0, 'WRK_TICKET_ORIGINE -> TICKET : ' + E.Message, True);
        raise;
      end;
    End;
    {$ENDREGION}

  except on E:EXception do
    begin
      LogAction('Erreur lors du traitement de la Correction Fildelité (voir audit) : ' + E.message, logInfo);
    end;
  End;

  InitProgress('Correction Fildelité : Fin du traitement', 0);
end;

procedure TDm_ExtractDatabase.GestionCorrectionMouvement(AMagID: Integer;
  AMagADH: String);
var

 dDebut : TDateTime;
begin
  Try
    InitProgress('Correction Mouvement : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,4);

    {$REGION 'Vérification de la présence des tables AGRMOUVEMENT'}
      IBQue_Tmp.Close;
      IBQue_Tmp.SQL.Clear;
      IBQue_Tmp.SQL.Add('select distinct count(*) as Resultat from rdb$RELATION_FIELDS');
      IBQue_Tmp.SQL.Add('where RDB$VIEW_CONTEXT is null');
      IBQue_Tmp.SQL.Add('and RDB$SYSTEM_FLAG = 0');
      IBQue_Tmp.SQL.Add('and RDB$RELATION_NAME = ''AGRMOUVEMENT''');
      IBQue_Tmp.SQL.Add('GROUP BY  RDB$RELATION_NAME;');
      IBQue_Tmp.Open;

      if IBQue_Tmp.FieldByName('Resultat').AsInteger = 0 then
      begin
        InsertAudit(AMagID,dDebut, Now, 2, 0, 0, 'Correction Mouvement -> Table AGRMOUVEMENT Non Présente', True);
        Exit;
      end;
    {$ENDREGION}

    {$REGION 'Etape 1 SQL SERVEUR : Récupération de la liste des mouvements faux'}
    if not ADODatabase.InTransaction then
      ADODatabase.BeginTrans;

    With ADOQue_LstTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT MOV_IDORIGINE, MOV_ID FROM MOUVEMENTS with (nolock)');
      SQL.Add('Where MOV_MAGID = :PMAGID');
      SQL.Add('  AND MOV_IDORIGINE BETWEEN 170000000 and 300000000');
      ParamCheck := True;
      Parameters.ParamByName('PMAGID').Value := AMagID;
      Open;
      InsertAudit(AMagID,dDebut, Now, 1, ADOQue_LstTmp.RecordCount, 1, 'WRK_MOUVEMENTS_ORIGINE -> Recuperation : Ok');
      InitProgress('Correction Mouvement : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,ADOQue_LstTmp.RecordCount);
    end;
    {$ENDREGION}

    if ADOQue_LstTmp.RecordCount > 0 then
    begin
      {$REGION 'Etape 2 SQL SERVEUR : Vidage Table Tmp WRK_MOUVEMENTS_ORIGINE'}
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM WRK_MOUVEMENTS_ORIGINE Where WMO_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
        ADODatabase.CommitTrans;
        InsertAudit(AMagID,dDebut, Now, 2, AQue_INSERTTmp.RowsAffected, 1, 'WRK_MOUVEMENTS_ORIGINE -> Recuperation : Ok', True);
      end;
      {$ENDREGION}

      {$REGION 'Etape 3 GINKOIA : Récupération des informations/Transfert Dans Databse'}
      Try
        ADODatabase.BeginTrans;
        dDebut := Now;
        With IBQue_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT Distinct MVT_IDLIGNE, MVT_KENABLED FROM AGRMOUVEMENT');
          SQL.Add('WHERE MVT_ID = :PMVTID');
          SQL.Add('GROUP BY MVT_IDLIGNE, MVT_KENABLED');
          ParamCheck := True;
          Prepared := True;
        end;

        With aQue_QryTmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO WRK_MOUVEMENTS_ORIGINE(WMO_DATECREATION, WMO_MAGID, WMO_MOV_IDDATABASE, WMO_MOV_IDORIGINE, WMO_MVT_KENABLED, WMO_MVT_IDORIGINE_UPDATE)');
          SQL.Add('       VALUES (:PDATE, :PMAGID, :PMOVID, :PMOVORIGINE, :PMVTKE, :PMVTIDLIGNE)');
          ParamCheck := True;
          Prepared := True;
        end;

        ADOQue_LstTmp.First;
        While not ADOQue_LstTmp.EOF do
        begin
          With IBQue_Tmp do
          begin
            Close;
            ParamByName('PMVTID').AsInteger := ADOQue_LstTmp.FieldByName('MOV_IDORIGINE').AsInteger;
            Open;
          end;

          if IBQue_Tmp.RecordCount > 0 then
          begin
            aQue_QryTmp.Parameters.ParamByName('PDATE').Value       := Now;
            aQue_QryTmp.Parameters.ParamByName('PMAGID').Value      := AMagID;
            aQue_QryTmp.Parameters.ParamByName('PMOVID').Value      := ADOQue_LstTmp.FieldByName('MOV_ID').AsInteger;
            aQue_QryTmp.Parameters.ParamByName('PMOVORIGINE').Value := ADOQue_LstTmp.FieldByName('MOV_IDORIGINE').AsInteger;
            aQue_QryTmp.Parameters.ParamByName('PMVTKE').Value      := IBQue_Tmp.FieldByName('MVT_KENABLED').AsInteger;
            aQue_QryTmp.Parameters.ParamByName('PMVTIDLIGNE').Value := IBQue_Tmp.FieldByName('MVT_IDLIGNE').AsInteger;
            aQue_QryTmp.ExecSQL;
          end;

          ADOQue_LstTmp.Next;
          DoProgress;
        end;
        ADODatabase.CommitTrans;
        InsertAudit(AMagID,dDebut, Now, 3, ADOQue_LstTmp.RecordCount , 1, 'GINKOIA -> WRK_MOUVEMENTS_ORIGINE : Ok', True);
      except on E:Exception do
        begin
          ADODatabase.RollbackTrans;
          InsertAudit(AMagID,dDebut, Now, 3,  0, 0, 'GINKOIA -> WRK_MOUVEMENTS_ORIGINE : ' + E.Message, True);
          raise;
        end;
      End;
      {$ENDREGION}

      {$REGION 'ETAPE 4 SQL SERVEUR : Merge des données'}
      Try
        ADODatabase.BeginTrans;
        dDebut := Now;
        With  AQue_INSERTTmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('MERGE MOUVEMENTS as TARGET');
          SQL.Add('USING (Select WMO_DATECREATION, WMO_MAGID, WMO_MOV_IDDATABASE, WMO_MOV_IDORIGINE, WMO_MVT_KENABLED, WMO_MVT_IDORIGINE_UPDATE');
          SQL.Add('       From WRK_MOUVEMENTS_ORIGINE with (nolock)');
          SQL.Add('       Where WMO_MAGID = :PMAGID) as SOURCE');
          SQL.Add('ON (TARGET.MOV_ID = SOURCE.WMO_MOV_IDDATABASE and TARGET.MOV_IDORIGINE = SOURCE.WMO_MOV_IDORIGINE)');
          SQL.Add('WHEN MATCHED THEN');
          SQL.Add('     UPDATE SET TARGET.MOV_IDORIGINE = SOURCE.WMO_MVT_IDORIGINE_UPDATE,');
          SQL.Add('                TARGET.MOV_KENABLED = SOURCE.WMO_MVT_KENABLED');
          SQL.Add(';');
          ParamCheck := True;
          Parameters.ParamByName('PMAGID').Value := AMagID;
          ExecSQL;
        end;
        ADODatabase.CommitTrans;
        InsertAudit(AMagID,dDebut, Now, 4, AQue_INSERTTmp.RowsAffected , 1, 'WRK_MOUVEMENTS_ORIGINE -> MOUVEMENTS : Merge Ok', True);
      except on E:Exception do
        begin
          ADODatabase.RollbackTrans;
          InsertAudit(AMagID,dDebut, Now, 4,  0, 0, 'WRK_MOUVEMENTS_ORIGINE -> MOUVEMENTS : ' + E.Message, True);
          raise;
        end;
      End;
      {$ENDREGION}
    end
  except on E:EXception do
    begin
      LogAction('Erreur lors du traitement de la Correction Mouvement (voir audit) : ' + E.message, logInfo);
    end;
  End;

  InitProgress('Correction Mouvement : Fin du traitement', 0);
end;

procedure TDm_ExtractDatabase.UpdateUtilTkeID(AMagID: Integer);
begin
  try
    InitProgress('Correction UtilTkeID : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,4);

    if not ADODatabase.InTransaction then
      ADODatabase.BeginTrans;

    With AQue_INSERTTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update BONSACHATS with(rowlock) set BAA_UTILTKEID=( ');
      SQL.Add('	select ISNULL(max(TKE_ID), 0) ');
      SQL.Add('	from TICKET WITH (NOLOCK) ');
      SQL.Add('	where TKE_MAGID in (select MAG_ID from MAGASIN  where MAG_DOSID=(select MAG_DOSID from MAGASIN where MAG_ID=BONSACHATS.BAA_MAGID)) ');
      SQL.Add('	and TKE_IDORIGINE=BONSACHATS.BAA_UTILTKEIDORIG ) ');
      SQL.Add('where BAA_MAGID = :PMAGID ');
      SQL.Add('and BAA_UTILTKEIDORIG > 0 ');
      SQL.Add('and (BAA_UTILTKEID is null or BAA_UTILTKEID = 0) ');
      ParamCheck := True;
      Parameters.ParamByName('PMAGID').Value := AMagID;
      ExecSQL;
      ADODatabase.CommitTrans;
    end;
  except on E:Exception do
    begin
      ADODatabase.RollbackTrans;
      LogAction('Erreur lors du traitement de la Correction UtilTkeID : ' + E.message, logWarning);
    end;
  End;

  InitProgress('Correction UtilTkeID : Fin du traitement', 0);
end;

procedure TDm_ExtractDatabase.GestionStock(AMagID: Integer; AMagADH : String);
var

 dDebut : TDateTime;
begin

  Try
    InitProgress('Stock : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,4);

    {$REGION 'Etape 1 : Remplissage WRK_EDC_INIT + Récupération avec jointure'}
    Try
      With IBQue_Tmp do
      begin
        dDebut := Now;
        if not IBQue_Tmp.Transaction.InTransaction then
          IBQue_Tmp.Transaction.StartTransaction;

        Close;
        SQL.Clear;
      //  SQL.Add('SELECT * FROM SP2K_EDC_INIT_STOCK(:PMAGADH)');
        SQL.Clear;
        SQL.Add('Select STC_ARTID, STC_COUID, STC_TGFID, STC_QTE, STC_PUMP, GTF_ID, GTF_NOM, TGF_NOM from AGRSTOCKCOUR');
        SQL.Add('join GENMAGASIN on MAG_ID = STC_MAGID');
        SQL.Add('join PLXTAILLESGF on TGF_ID = STC_TGFID');
        SQL.Add('join PLXGTF on GTF_ID = TGF_GTFID');
        SQL.Add('Where STC_QTE <> 0 and MAG_CODEADH = :PMAGADH');
        ParamCheck := True;
        ParamByName('PMAGADH').AsString := AMagADH;
        Open;

        // Remplissage WRK_STOCK_Origine
        if not ADODatabase.InTransaction then
          ADODatabase.BeginTrans;
        // Suppression des anciennes données magasin
        AQue_INSERTTmp.Close;
        AQue_INSERTTmp.SQL.Clear;
        AQue_INSERTTmp.SQL.Add('Delete from WRK_STOCK_ORIGINE');
        AQue_INSERTTmp.SQL.Add('Where WSO_MAGID = :PMAGID');
        AQue_INSERTTmp.ParamCheck := True;
        AQue_INSERTTmp.Parameters.ParamByName('PMAGID').Value := AMagID;
        AQue_INSERTTmp.ExecSQL;

        AQue_INSERTTmp.Close;
        AQue_INSERTTmp.SQL.Clear;
        AQue_INSERTTmp.SQL.Add('INSERT INTO WRK_STOCK_ORIGINE(WSO_MAGID, WSO_ARTIDORIGINE, WSO_TGFIDORIGINE, WSO_COUIDORIGINE,');
        AQue_INSERTTmp.SQL.Add(' WSO_QTE, WSO_PUMP, WSO_GTFIDORIGINE, WSO_GTFNOM, WSO_TGFNOM)');
        AQue_INSERTTmp.SQL.Add('VALUES(:PMAGID, :PARTID, :PTGFID, :PCOUID, :PQTE, :PPUMP, :PGTFID, :PGTFNOM, :PTGFNOM)');
        AQue_INSERTTmp.ParamCheck := True;
        AQue_INSERTTmp.Prepared := True;

        First;
        while not EOF do
        begin
          AQue_INSERTTmp.Close;
          AQue_INSERTTmp.Parameters.ParamByName('PMAGID').Value := AMagID;
//          AQue_INSERTTmp.Parameters.ParamByName('PARTID').Value := FieldByName('ARTID').AsInteger;
//          AQue_INSERTTmp.Parameters.ParamByName('PTGFID').Value := FieldByName('TGFID').AsInteger;
//          AQue_INSERTTmp.Parameters.ParamByName('PCOUID').Value := FieldByName('COUID').AsInteger;
//          AQue_INSERTTmp.Parameters.ParamByName('PQTE').Value   := FieldByName('QTE').AsInteger;
//          AQue_INSERTTmp.Parameters.ParamByName('PPUMP').Value  := FieldByName('PUMP').AsCurrency;
          AQue_INSERTTmp.Parameters.ParamByName('PARTID').Value := FieldByName('STC_ARTID').AsInteger;
          AQue_INSERTTmp.Parameters.ParamByName('PTGFID').Value := FieldByName('STC_TGFID').AsInteger;
          AQue_INSERTTmp.Parameters.ParamByName('PCOUID').Value := FieldByName('STC_COUID').AsInteger;
          AQue_INSERTTmp.Parameters.ParamByName('PQTE').Value   := FieldByName('STC_QTE').AsInteger;
          AQue_INSERTTmp.Parameters.ParamByName('PPUMP').Value  := FieldByName('STC_PUMP').AsCurrency;
          AQue_INSERTTmp.Parameters.ParamByName('PGTFID').Value  := FieldByName('GTF_ID').AsInteger;
          if FieldByName('GTF_NOM').IsNull then
            AQue_INSERTTmp.Parameters.ParamByName('PGTFNOM').Value := ''
          else
            AQue_INSERTTmp.Parameters.ParamByName('PGTFNOM').Value  :=  LeftStr(FieldByName('GTF_NOM').AsString, 32);

          if FieldByName('TGF_NOM').IsNull then
            AQue_INSERTTmp.Parameters.ParamByName('PTGFNOM').Value := ''
          else
            AQue_INSERTTmp.Parameters.ParamByName('PTGFNOM').Value  :=  LeftStr(FieldByName('TGF_NOM').AsString,32);
          AQue_INSERTTmp.ExecSQL;

          Next;
        end;
        InsertAudit(AMagID,dDebut, Now, 1, Recordcount, 1, 'WRK_EDC_INIT -> WRK_STOCK_ORIGINE : Ok');
        IBQue_Tmp.Transaction.Commit;
        ADODatabase.CommitTrans;
        DoProgress;
      end;
    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 1, 0, 0, Format('WRK_EDC_INIT -> WRK_STOCK_ORIGINE : A-%d T-%d C-%d %s',[
          IBQue_Tmp.FieldByName('STC_ARTID').AsInteger,
          IBQue_Tmp.FieldByName('STC_TGFID').AsInteger,
          IBQue_Tmp.FieldByName('STC_COUID').AsInteger, E.Message]), True);
        raise;
      end;
    End;
    {$ENDREGION}

    {$REGION 'Etape 1.1 : Gestion Grille/taille'}
    try
      // Merge Grille de taille
      ADODatabase.BeginTrans;
      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('MERGE TAILLEGRILLE as TARGET');
        SQL.Add('USING (Select MAG_DOSID, WSO_GTFIDORIGINE, WSO_GTFNOM from WRK_STOCK_ORIGINE with (nolock) JOIN SP2000CATMAN.DBO.MAGASIN on MAG_ID = WSO_MAGID and MAG_ID = :PMAGID) as SOURCE');
        SQL.Add('ON (TARGET.GTF_IDORIGINE = SOURCE.WSO_GTFIDORIGINE and TARGET.GTF_DOSID = SOURCE.MAG_DOSID)');
        SQL.Add('WHEN NOT MATCHED BY TARGET');
        SQL.Add('THEN INSERT(GTF_DOSID, GTF_IDORIGINE, GTF_NOM)');
        SQL.Add('     VALUES(SOURCE.MAG_DOSID, SOURCE.WSO_GTFIDORIGINE, left(SOURCE.WSO_GTFNOM,32));');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 1, 0, 1, 'WRK_EDC_ORIGINE -> GT Taille : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 1, 0, 0, 'WRK_EDC_ORIGINE -> GT Taille : ' + E.Message, True);
        raise;
      end;
    End;

    try
    // Merge Taile
      ADODatabase.BeginTrans;
      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('MERGE TAILLELIGNE as TARGET');
        SQL.Add('USING (Select ART_ID, GTF_ID, WSO_TGFIDORIGINE, WSO_TGFNOM from WRK_STOCK_ORIGINE with (nolock)');
        SQL.Add('        JOIN SP2000CATMAN.DBO.MAGASIN on MAG_ID = WSO_MAGID');
        SQL.Add('        JOIN ARTICLE on ART_IDORIGINE = WSO_ARTIDORIGINE and ART_DOSID = MAG_DOSID and MAG_ID = :PMAGID');
        SQL.Add('        JOIN TAILLEGRILLE on GTF_IDORIGINE = WSO_GTFIDORIGINE and GTF_DOSID = MAG_DOSID )as SOURCE');
        SQL.Add('ON (TARGET.TGF_IDORIGINE = SOURCE.WSO_TGFIDORIGINE and TARGET.TGF_ARTID = SOURCE.ART_ID and');
        SQL.Add('    TARGET.TGF_GTFID = SOURCE.GTF_ID)');
        SQL.Add('WHEN NOT MATCHED BY TARGET');
        SQL.Add('THEN INSERT(TGF_ARTID, TGF_IDORIGINE, TGF_GTFID, TGF_NOM)');
        SQL.Add('     VALUES(SOURCE.ART_ID, SOURCE.WSO_TGFIDORIGINE, SOURCE.GTF_ID, left(SOURCE.WSO_TGFNOM,32));');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 1, 0, 1, 'WRK_EDC_ORIGINE -> Taille : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 1, 0, 0, 'WRK_EDC_ORIGINE -> Taille : ' + E.Message, True);
        raise;
      end;
    End;


    {$ENDREGION}

    {$REGION 'Etape 2 : Remplissage WRK_STOCK_DATABASE'}
    try
      ADODatabase.BeginTrans;

      dDebut := Now;
      // Suppression des données avant insertsion
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Delete from WRK_STOCK_DATABASE');
        SQL.Add('Where WSD_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 2, 0, 1, 'WRK_EDC_ORIGINE -> WRK_STOCK_DATABASE : Delete Ok');

      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO WRK_STOCK_DATABASE(WSD_MAGID, WSD_ARTID, WSD_COUID, WSD_TGFID, WSD_QTE, WSD_PUMP, WSD_WRKIDORIGINE)');
        SQL.Add(' SELECT Distinct WSO_MAGID, ART_ID, COU_ID, TGF_ID, WSO_QTE, WSO_PUMP, WSO_ID  FROM WRK_STOCK_ORIGINE with (nolock)');
        SQL.Add('   JOIN SP2000CATMAN.DBO.MAGASIN on MAG_ID = WSO_MAGID');
        SQL.Add('   JOIN TAILLEGRILLE on GTF_DOSID = MAG_DOSID and GTF_IDORIGINE = WSO_GTFIDORIGINE');
        SQL.Add('   JOIN ARTICLE on ART_DOSID = MAG_DOSID and ART_IDORIGINE = WSO_ARTIDORIGINE');
        SQL.Add('   JOIN COULEUR on COU_ARTID = ART_ID and COU_IDORIGINE = WSO_COUIDORIGINE');
        SQL.Add('   JOIN TAILLELIGNE on TGF_ARTID = ART_ID and TGF_IDORIGINE = WSO_TGFIDORIGINE and TGF_GTFID = GTF_ID');
        SQL.Add(' WHERE WSO_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 2, AQue_INSERTTmp.RowsAffected, 1, 'WRK_EDC_ORIGINE -> WRK_STOCK_DATABASE : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 2, 0, 0, 'WRK_EDC_ORIGINE -> WRK_STOCK_DATABASE : ' + E.Message, True);
        raise;
      end;
    End;
    {$ENDREGION}

    {$REGION 'Etape 3 : Gestion des rejets'}
    try
      ADODatabase.BeginTrans;
      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO WRK_STOCK_REJET(WSR_DATECREATION, WSR_MAGID, WSR_ARTIDORIGINE, WSR_COUIDORIGINE, WSR_TGFIDORIGINE)');
        SQL.Add('    SELECT CURRENT_TIMESTAMP, WSO_MAGID, WSO_ARTIDORIGINE, WSO_COUIDORIGINE, WSO_TGFIDORIGINE FROM WRK_STOCK_ORIGINE with (nolock)');
        SQL.Add('      JOIN SP2000CATMAN.DBO.MAGASIN on MAG_ID = WSO_MAGID');
        SQL.Add('      LEFT JOIN ARTICLE on ART_DOSID = MAG_DOSID and ART_IDORIGINE = WSO_ARTIDORIGINE');
        SQL.Add('      LEFT JOIN COULEUR on COU_ARTID = ART_ID and COU_IDORIGINE = WSO_COUIDORIGINE');
        SQL.Add('      LEFT JOIN TAILLELIGNE on TGF_ARTID = ART_ID and TGF_IDORIGINE = WSO_TGFIDORIGINE');
        SQL.Add('    WHERE (ART_ID IS NULL or COU_ID IS NULL or TGF_ID IS NULL)');
        SQL.Add('      and WSO_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 3, AQue_INSERTTmp.RowsAffected, 1, 'WRK_EDC_ORIGINE -> WRK_STOCK_REJET : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 3, 0, 0, 'WRK_EDC_ORIGINE -> WRK_STOCK_REJET : ' + E.Message, True);
        raise;
      end;
    End;
    {$ENDREGION}

    {$REGION 'Etape 4 : Merge avec la table Stock'}
    try
      ADODatabase.BeginTrans;

//      // Update des Stock avant le merge
//      dDebut := Now;
//      With AQue_INSERTTmp do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('UPDATE STOCK SET');
//        SQL.Add('STK_QTE = 0, STK_TRAITE = 0');
//        SQL.Add('Where STK_MAGID = :PMAGID');
//        ParamCheck := True;
//        Parameters.ParamByName('PMAGID').Value := AMagID;
//        ExecSQL;
//      end;
//      InsertAudit(AMagID,dDebut, Now, 4, AQue_INSERTTmp.RowsAffected, 1, 'UPDATE STOCK à 0 : Ok');

      // Dédoublonage de la table WRK_STOCK_DATABASE
      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE WRK_STOCK_DATABASE FROM WRK_STOCK_DATABASE with (nolock)');
        SQL.Add('LEFT OUTER JOIN ( SELECT MIN(wsd_id) as id, wsd_wrkidorigine FROM WRK_STOCK_DATABASE GROUP BY wsd_wrkidorigine ) as t1');
        SQL.Add('ON WRK_STOCK_DATABASE.wsd_id = t1.id WHERE t1.id IS NULL and WSD_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 4, AQue_INSERTTmp.RowsAffected, 1, 'DELETE WRK_STOCK_DATABASE -> DEDOUBLONAGE : Ok');


      dDebut := Now;
      With AQue_INSERTTmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('MERGE STOCK as TARGET');
        SQL.Add('USING (SELECT WSD_MAGID, WSD_ARTID, WSD_COUID, WSD_TGFID, WSD_QTE, WSD_PUMP from WRK_STOCK_DATABASE with (nolock) where WSD_MAGID = :PMAGID) as SOURCE');
        SQL.Add('ON (TARGET.STK_MAGID = SOURCE.WSD_MAGID and TARGET.STK_ARTID = SOURCE.WSD_ARTID and');
        SQL.Add('    TARGET.STK_COUID = SOURCE.WSD_COUID and TARGET.STK_TGFID = SOURCE.WSD_TGFID)');
        SQL.Add('WHEN MATCHED and (TARGET.STK_QTE <> SOURCE.WSD_QTE or TARGET.STK_PUMP <> SOURCE.WSD_PUMP)');
        SQL.Add('THEN UPDATE SET TARGET.STK_QTE = SOURCE.WSD_QTE, TARGET.STK_PUMP = SOURCE.WSD_PUMP, STK_DATECALCUL = GETDATE(), STK_TRAITE = 0');
        SQL.Add('WHEN NOT MATCHED BY TARGET');
        SQL.Add('THEN INSERT(STK_MAGID, STK_ARTID, STK_COUID, STK_TGFID, STK_QTE, STK_PUMP, STK_DATECALCUL, STK_TRAITE)');
        SQL.Add('     VALUES(SOURCE.WSD_MAGID, SOURCE.WSD_ARTID, SOURCE.WSD_COUID, SOURCE.WSD_TGFID, SOURCE.WSD_QTE, SOURCE.WSD_PUMP, GETDate(), 0);');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := AMagID;
        ExecSQL;
      end;
      InsertAudit(AMagID,dDebut, Now, 4, AQue_INSERTTmp.RowsAffected, 1, 'MERGE WRK_EDC_DATABASE -> STOCK : Ok');
      ADODatabase.CommitTrans;
      DoProgress;

    except on E:Exception do
      begin
        ADODatabase.RollbackTrans;
        InsertAudit(AMagID,dDebut, Now, 4, 0, 0, 'MERGE WRK_EDC_DATABASE -> STOCK : ' + E.Message, True);
        raise;
      end;
    End;
    {$ENDREGION}

//    try
//    //Etape 5 : Suppression des données temporaires
//    ADODatabase.BeginTrans;
//    dDebut := Now;
//    With AQue_INSERTTmp do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('DELETE WRK_STOCK_ORIGINE FROM WRK_STOCK_ORIGINE join WRK_STOCK_DATABASE ON WSO_ID = WSD_WRKIDORIGINE');
//      SQL.Add('WHERE WSD_MAGID = :PMAGID;');
//      ParamCheck := True;
//      Parameters.ParamByName('PMAGID').Value := AMagID;
//      ExecSQL;
//    end;
//    InsertAudit(AMagID,dDebut, Now, 5, 0, 1, 'DELETE WRK_EDC_ORIGINE : Ok');
//    ADODatabase.CommitTrans;
//    except on E:Exception do
//      begin
//        ADODatabase.RollbackTrans;
//        InsertAudit(AMagID,dDebut, Now, 5, 0, 0, 'DELETE WRK_EDC_ORIGINE : ' + E.Message, True);
//        raise;
//      end;
//    End;

  except on E:EXception do
    begin
      LogAction('Erreur lors du traitement du stock (voir audit) : ' + E.message, logInfo);
    end;
  End;

  InitProgress('Stock : Fin du traitement', 0);
end;

function TDm_ExtractDatabase.GetCurVer: integer;
begin
  IbQue_CurVersion.Open;
  Result := IbQue_CurVersionNEWKEY.AsInteger;
  IbQue_CurVersion.Close;
end;

function TDm_ExtractDatabase.getDatabase: string;
begin
  result := '';
  if not IniCfg.isAzure then
    result := '[SP2000CATMAN].dbo.';
end;

function TDm_ExtractDatabase.GetGinkoiaMagid(aDatabaseMagId: integer): integer;
begin
  result := 0;

  AdQue_GetListMags.First;
  if AdQue_GetListMags.Locate('mag_id', aDatabaseMagId, []) then
  begin

    IBQue_Tmp.Close;
    IBQue_Tmp.SQL.Text := 'select mag_id from genmagasin where mag_codeadh=:code';
    IBQue_Tmp.ParamCheck := true;
    IBQue_Tmp.ParamByName('code').AsString := AdQue_GetListMags.FieldByName('mag_code').AsString;
    IBQue_Tmp.Open;
    if not IBQue_Tmp.IsEmpty then
      result := IBQue_Tmp.FieldByName('mag_id').AsInteger;
  end;
end;

function TDm_ExtractDatabase.GetKByDate(ADate: TDate;
  AMode: TModeFind): Integer;
var
  sPlage : String;
  MinPlage, MaxPlage : Integer;
  sTemp : String;
begin
  With IbQue_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select (cast(f_mid(bas_plage, 1, f_substr(''M_'', bas_plage) -1) as integer) * 1000000) as MinPlage,');
    SQL.Add('       (cast(f_mid(bas_plage, f_substr(''M_'', bas_plage) +2, (f_stringlength(bas_plage) -1) - (f_substr(''M_'', bas_plage) +2) -1) as integer) * 1000000 -1) as MaxPlage');
    SQL.Add('from genbases where bas_ident=''0''');
    Open;

    MinPlage := FieldByName('MinPlage').AsInteger;
    MaxPlage := FieldByName('MaxPlage').AsInteger;

    Close;
    SQL.Clear;
    case AMode of
      mfMin: SQL.Add('SELECT min(K_VERSION) as ID');
      mfMax: SQL.Add('SELECT Max(K_VERSION) as ID');
    end;
    SQL.Add('From K');
    case AMode of
      mfMin: SQL.Add('Where K_INSERTED >=:PDATE');
      mfMax: SQL.Add('Where K_INSERTED <=:PDATE');
    end;
    SQL.Add('  And (K_VERSION Between :PMIN and :PMAX)');
    ParamCheck := True;
    ParamByName('PDATE').AsDate := ADate;
    ParamByName('PMIN').AsInteger := MinPlage;
    ParamByName('PMAX').AsInteger := MaxPlage;
    Open;

    Result := FieldByName('ID').AsInteger;
  end;
end;

function TDm_ExtractDatabase.GetVerDate(ADateInit: TDateTime): integer;
begin
  IBQue_GetVersionAtDate.Close;
  IBQue_GetVersionAtDate.Params[0].AsDateTime := ADateInit;
  IBQue_GetVersionAtDate.Open;
  Result                                      := IBQue_GetVersionAtDate.Fields[0].AsInteger;
  IBQue_GetVersionAtDate.Close;

  // IBQue_GetVerDate.Close;
  // IBQue_GetVerDate.ParamByName('DATEINIT').AsDateTime := ADate;
  // IBQue_GetVerDate.Open;
  // Result := IBQue_GetVerDateVersion.AsInteger;
  // IBQue_GetVerDate.Close;
end;

procedure TDm_ExtractDatabase.GinkoiaAfterConnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateGin.Caption := 'GINKOIA - Connecté à : ' + Ginkoia.DatabaseName;
  Application.ProcessMessages;
end;

procedure TDm_ExtractDatabase.GinkoiaAfterDisconnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateGin.Caption := 'GINKOIA - Déconnecté';
  Application.ProcessMessages;
end;

function TDm_ExtractDatabase.InitBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit: TDateTime): boolean;
var
  stMvtInit : stRecordMvt; // Variable contenant le mouvemnet à insérer
  iArtId    : integer;     // Variable de test pour savoir si on a changé d'article.
  iCouId    : integer;     // Variable de test pour savoir si on a changé de couleur.
  iTgfId    : integer;     // Variable de test pour savoir si on a changé de taille.
  iNbArt    : integer;     // Nombre d'articles

  dtDebut   : TDateTime;   // Timestamp de début de traitement

  vDate     : variant;     // Variable tampon pour mettre la date sur 4 car.

  vArtIdDtb : variant;     // Valeur retournée par la procédure de création d'article.
  vGtfIdDtb : variant;     // Valeur retournée par la procédure de création d'article.

  vCodeEAN  : variant;     // Tampon pour contacténer le dosid et le code barre.
  vTypeEAN  : variant;     // Tampon pour type de CB
  vFouIdRef : variant;     // tampon pour stocker l'id ref du fournisseur

  i         : integer;

  iVersion  : integer; // Version actuelle de la base

  bErreurMvt: boolean; // Erreur de traitement du mouvemnet on sortira
begin
  LogAction('Initialisation ' + AChemin, logInfo);

  Result := False;
  if AChemin = '' then
  begin
    Exit;
  end;

  InitProgress('Connexion base Ginkoia ' + AChemin, 1);
  LogAction('Connexion base Ginkoia ' + AChemin, logInfo);

  Ginkoia.DatabaseName := AChemin;
  Ginkoia.Close;
  TRY
    Ginkoia.Open;
    DoProgress;
  EXCEPT
    // Chemin inccorect à voir si on log, ca peut être normal tant qu'on a pas renseigné le chemin
    // InsertHisto(1, AMagId, 0, iVersion, 12, iNbArt, dtDebut, Now(), 'Initialisation');
    LogAction(AMagAdh + ' : Connection Gin échouée - ' + AChemin, logError);
  END;

  if Ginkoia.Connected then
  begin
    LogAction('Connexion base Ginkoia réussie', logInfo);
//    InitProgress('Mise à jour des procédures', 1);

    //Dm_ExtractDatabase.MajToutesProcedures;
    DoProgress;

    IbT_Ginkoia.StartTransaction;
    ADODatabase.BeginTrans;
    TRY
      iVersion := GetVerDate(ADateInit);
      dtDebut := Now();
      UpdateArticle(ADosid, AMagId, 0, iVersion,maArt, '', True, ADateInit);
      ADODatabase.CommitTrans;


      // Init
//      iNbArt  := 0;
//      dtDebut := Now();
//
//      // Param de la requete
//      IBQue_InitDtb.ParamByName('MAGCODEADH').AsString := AMagAdh;
//      IBQue_InitDtb.ParamByName('DATEINIT').AsDateTime := ADateInit;
//
//      InitProgress('Préparation de la liste des articles', 1);
//      IBQue_InitDtb.Open;
//      IBQue_InitDtb.FetchAll;
//      DoProgress;
//
//      InitProgress('Initialisation des articles', IBQue_InitDtb.RecordCount);
//
//      while not IBQue_InitDtb.Eof do
//      begin
//        iArtId := IBQue_InitDtb.FieldByName('ARTID').AsInteger;
//        vDate  := FormatDateTime('yyyy', IBQue_InitDtb.FieldByName('ARFCREE').AsDateTime);
//
//        // Insertion Article
//        Ps_Article.Close;                                                       //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
//        Ps_Article.Parameters[1].Value  := 0;                                                // Output ARTID
//        Ps_Article.Parameters[2].Value  := 0;                                                // Output GTFID
//        Ps_Article.Parameters[3].Value  := ADosid;                                           // P_DOSID
//        Ps_Article.Parameters[4].Value  := IBQue_InitDtb.FieldByName('ARTID').AsVariant;     // P_ARTIDORIGINE int
//        Ps_Article.Parameters[5].Value  := IBQue_InitDtb.FieldByName('ARTNOM').AsVariant;    // P_ARTNOM VARHCAR(64)
//        Ps_Article.Parameters[6].Value  := IBQue_InitDtb.FieldByName('ARTREFMRK').AsVariant; // P_ARTREFMRK VARHCAR(64)
//        Ps_Article.Parameters[7].Value  := IBQue_InitDtb.FieldByName('MRKNOM').AsVariant;    // P_MRKNOM VARHCAR(64)
//        Ps_Article.Parameters[8].Value  := IBQue_InitDtb.FieldByName('MRKIDREF').AsVariant;  // P_MRKIDREF INT
//        Ps_Article.Parameters[9].Value  := IBQue_InitDtb.FieldByName('ARTFEDAS').AsVariant;  // P_ARTFEDAS  CHAR(6)
//        Ps_Article.Parameters[10].Value := IBQue_InitDtb.FieldByName('ARFPSEUDO').AsVariant; // P_ARTPSEUDO INT
//        Ps_Article.Parameters[11].Value := IBQue_InitDtb.FieldByName('GTFID').AsVariant;     // P_GTFIDORIGINE int
//        Ps_Article.Parameters[12].Value := IBQue_InitDtb.FieldByName('GTFNOM').AsVariant;    // P_GTFNOM VARCHAR (64)
//        Ps_Article.Parameters[13].Value := vDate;                                            // P_DATECREE VARCHAR(4)
//
//        Ps_Article.ExecProc;
//
//        IBQue_GetFourn.Close;
//        IBQue_GetFourn.ParamByName('ARTID').AsInteger := IBQue_InitDtb.FieldByName('ARTID').AsInteger;
//        IBQue_GetFourn.Open;
//        while not IBQue_GetFourn.Eof do
//        begin
//          IF IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger = 1 THEN
//          BEGIN
//            IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := IBQue_GetFourn.FieldByName('FOU_ID').AsInteger;
//            IBQue_GetFouIdRef.Open;
//            if NOT IBQue_GetFouIdRef.Eof then
//            begin
//              vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
//            end
//            else
//            begin
//              // Pas d'idref
//              vFouIdRef := 0;
//            end;
//            IBQue_GetFouIdRef.Close;
//          END
//          else
//          begin
//            // Pas d'idref
//            vFouIdRef := 0;
//          end;
//
//          Ps_Fournisseur.Close;                     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
//          Ps_Fournisseur.Parameters[1].Value := 0;                                               // @R_FOUID (output)
//          Ps_Fournisseur.Parameters[2].Value := ADosid;                                          // @P_DOSID int,
//          Ps_Fournisseur.Parameters[3].Value := IBQue_InitDtb.FieldByName('ARTID').AsVariant;    // @P_ARTIDORIGINE int,
//          Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                       // @P_FOUIDREF int,
//          Ps_Fournisseur.Parameters[5].Value := IBQue_GetFourn.FieldByName('FOU_NOM').AsVariant; // @P_FOUNOM int
//
//          Ps_Fournisseur.ExecProc;
//          Ps_Fournisseur.Close;                     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
//          IBQue_GetFourn.Next;
//        end;
//        IBQue_GetFourn.Close;
//
//        vArtIdDtb  := Ps_Article.Parameters[1].Value;
//        vGtfIdDtb  := Ps_Article.Parameters[2].Value;
//        Ps_Article.Close;                                                       //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
//
//        iCouId     := 0;
//        iTgfId     := 0;
//        bErreurMvt := False;
//
//        while (iArtId = IBQue_InitDtb.FieldByName('ARTID').AsInteger) and (not IBQue_InitDtb.Eof) and (not bErreurMvt) do
//        begin
//          if IBQue_InitDtb.FieldByName('CBICB').AsString = '' then // demande client, pseudo sans CB  -> Artid_dossier
//          begin
//            LogAction('Init, Pas de CB' + IntToStr(IBQue_GetCB.RecordCount), 3);
//            vCodeEAN := IBQue_InitDtb.FieldByName('ARTID').AsString + '_' + IntToStr(ADosid);
//            vTypeEAN := 3;
//          end
//          else
//          begin
//            vTypeEAN := IBQue_InitDtb.FieldByName('TYPECB').AsVariant;
//            if IBQue_InitDtb.FieldByName('TYPECB').AsInteger = 3 then
//            begin
//              vCodeEAN := IBQue_InitDtb.FieldByName('CBICB').AsVariant + '_' + IntToStr(ADosid);
//            end
//            else
//            begin
//              vCodeEAN := IBQue_InitDtb.FieldByName('CBICB').AsVariant
//            end;
//          end;
//
//          Ps_CbArt.Close; //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
//          Ps_CbArt.Parameters.ParamByName('@P_CBIEAN').Value       := vCodeEAN;                                       // P_CBIEAN VARCHAR(20),
//          Ps_CbArt.Parameters.ParamByName('@P_CBENABLED').Value    := IBQue_InitDtb.FieldByName('K_ENABLED').AsInteger;
//          Ps_CbArt.Parameters.ParamByName('@P_ARTID').Value        := vArtIdDtb;                                      // P_ARTID int,
//          Ps_CbArt.Parameters.ParamByName('@P_COUIDORIGINE').Value := IBQue_InitDtb.FieldByName('COUID').AsVariant;   // P_COUIDORIGINE int,
//          Ps_CbArt.Parameters.ParamByName('@P_COUNOM').Value       := IBQue_InitDtb.FieldByName('COUNOM').AsVariant;  // P_COUNOM VARCHAR(64),
//          Ps_CbArt.Parameters.ParamByName('@P_COUCODE').Value      := IBQue_InitDtb.FieldByName('COUCODE').AsVariant; // P_COUCODE VARCHAR(64),
//          Ps_CbArt.Parameters.ParamByName('@P_TGFIDORIGINE').Value := IBQue_InitDtb.FieldByName('TGFID').AsVariant;   // P_TGFIDORIGINE int,
//          Ps_CbArt.Parameters.ParamByName('@P_TGFNOM').Value       := IBQue_InitDtb.FieldByName('TGFNOM').AsVariant;  // P_TGFNOM VARCHAR(32),
//          Ps_CbArt.Parameters.ParamByName('@P_GTFID').Value        := vGtfIdDtb;                                      // P_GTFID int,
//          Ps_CbArt.Parameters.ParamByName('@P_TYPE').Value         := IBQue_InitDtb.FieldByName('TYPECB').AsVariant;  // P_TYPE int
//          Ps_CbArt.Parameters.ParamByName('@P_DOSID').Value        := 0;
//          Ps_CbArt.Parameters.ParamByName('@P_ARTIDORIGINE').Value := 0;
//          Ps_CbArt.Parameters.ParamByName('@P_GTFIDORIGINE').Value := 0;
//          Ps_CbArt.Parameters.ParamByName('@P_GTFNOM').Value       := '';
//
//          Ps_CbArt.ExecProc;
//          Ps_CbArt.Close;
//                                                                //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
//          if (iCouId <> IBQue_InitDtb.FieldByName('COUID').AsInteger) OR (iTgfId <> IBQue_InitDtb.FieldByName('TGFID').AsVariant) then
//          begin
//            // Svg taille / coul
//            iCouId := IBQue_InitDtb.FieldByName('COUID').AsInteger;
//            iTgfId := IBQue_InitDtb.FieldByName('TGFID').AsVariant;
//
//            // Insere le mouvment
//            stMvtInit            := InitRecordMvt;
//
//            stMvtInit.iDosid     := ADosid;                                           // @P_DOSID int,
//            stMvtInit.iMagId     := AMagId;                                           // @P_MAGID int,
//            stMvtInit.iMvtId     := IBQue_InitDtb.FieldByName('HSTID').AsInteger;     // @P_MVTIDORIGINE int,
//            stMvtInit.iTyp       := 12;                                               // @P_MVTTYPE tinyint,
//            stMvtInit.dtDateMvt  := ADateInit;                                        // @P_MVTDATE datetime,
//            stMvtInit.iArtId     := IBQue_InitDtb.FieldByName('ARTID').AsInteger;     // @P_ARTIDORIGINE int,
//            stMvtInit.sArtNom    := IBQue_InitDtb.FieldByName('ARTNOM').AsString;     // @P_ARTNOM VARCHAR (64),
//            stMvtInit.sArtRefMrk := IBQue_InitDtb.FieldByName('ARTREFMRK').AsVariant; // @P_ARTREFMRK VARCHAR (64),
//            stMvtInit.sMrkNom    := IBQue_InitDtb.FieldByName('MRKNOM').AsString;     // @P_MRKNOM VARCHAR (64),
//            stMvtInit.iMrkIdRef  := IBQue_InitDtb.FieldByName('MRKIDREF').AsInteger;  // @P_MRKIDREF int,
//            stMvtInit.sArtFedas  := IBQue_InitDtb.FieldByName('ARTFEDAS').AsString;   // @P_ARTFEDAS CHAR (6),
//            stMvtInit.iArtPseudo := IBQue_InitDtb.FieldByName('ARFPSEUDO').AsInteger; // @P_ARTPSEUDO INT,
//            stMvtInit.iGtfId     := IBQue_InitDtb.FieldByName('GTFID').AsInteger;     // @P_GTFIDORIGINE INT,
//            stMvtInit.sGtfNom    := IBQue_InitDtb.FieldByName('GTFNOM').AsString;     // @P_GTFNOM VARCHAR (64),
//            stMvtInit.sDateCree  := String(vDate);                                    // @P_DATECREE VARCHAR(4),
//            stMvtInit.iTgfId     := IBQue_InitDtb.FieldByName('TGFID').AsInteger;     // @P_TGFIDORIGINE int,
//            stMvtInit.sTgfNom    := IBQue_InitDtb.FieldByName('TGFNOM').AsString;     // @P_TGFNOM VARCHAR(32),
//            stMvtInit.iCouId     := IBQue_InitDtb.FieldByName('COUID').AsInteger;     // @P_COUIDORIGINE int,
//            stMvtInit.sCouNom    := IBQue_InitDtb.FieldByName('COUNOM').AsString;     // @P_COUNOM VARCHAR(64),
//            stMvtInit.sCouCode   := IBQue_InitDtb.FieldByName('COUCODE').AsString;    // @P_COUCODE VARCHAR(64),
//            stMvtInit.iQte       := IBQue_InitDtb.FieldByName('STCQTE').AsInteger;    // @P_MVTQTE int,
//            stMvtInit.iKEnabled  := 1;                                                // @K_ENABLED int
//            stMvtInit.fPump      := IBQue_InitDtb.FieldByName('ARTPUMP').AsFloat;
//            stMvtInit.fArtPump   := IBQue_InitDtb.FieldByName('ARTPUMP').AsFloat;
//            stMvtInit.dtModif    := ADateInit;
//
//            IF InsertMvt(stMvtInit) THEN
//            begin
//              Inc(iNbArt)
//            end
//            else
//            begin
//              // Traiter l'erreur
//              bErreurMvt := True;
//            end;
//          end;
//
//          IBQue_InitDtb.Next;
//
//          DoProgress;
//        end;
//      end;
//
//      if not bErreurMvt then
//      begin
//        LogAction('Mouvements OK, recup version' + IntToStr(iNbArt), 1);
//
//        // LogAction('Mouvements OK, recup version' + inttostr(iNbArt), 1);
//
//        iVersion := GetVerDate(ADateInit);
//        InsertHisto(1, AMagId, 0, iVersion, 12, iNbArt, dtDebut, Now(), 'Initialisation');
//        for i    := 1 to 11 do
//          InsertHisto(1, AMagId, 0, iVersion, i, 0, dtDebut, Now(), 'Initialisation');
//
//        InsertHisto(1, AMagId, 0, iVersion, 13, 0, dtDebut, Now(), 'Initialisation');  //SR - Ajout bon d'achat
//        InsertHisto(1, AMagId, 0, iVersion, 14, 0, dtDebut, Now(), 'Initialisation');  //SR - Ajout Coupon
//        LogAction('Histo OK', 1);
//
//        ADODatabase.CommitTrans;
//
//        Result := True;
//      end
//      else
//      begin
//        LogAction('Erreur sur mouvement ' + IntToStr(stMvtInit.iMvtId), 1);
//        ADODatabase.RollbackTrans;
//        ADODatabase.BeginTrans;
//        InsertHisto(0, AMagId, 0, iVersion, 12, iNbArt, dtDebut, Now(), 'Initialisation échouée');
//        ADODatabase.CommitTrans;
//
//        Result := False;
//      end;
    EXCEPT
      ON E: EMVTERROR do
      begin
        LogAction(E.Message, logError);
        ADODatabase.RollbackTrans;
        ADODatabase.BeginTrans;
        InsertHisto(0, AMagId, 0, iVersion, 12, 0, dtDebut, Now(), 'Initialisation échouée');
        ADODatabase.CommitTrans;
      end;
      ON E: Exception DO
      begin
        LogAction('Erreur d''intégration dans SQLServeur ' + IntToStr(stMvtInit.iMvtId), logError);
        LogAction(E.Message, logError);
        ADODatabase.RollbackTrans;

        ADODatabase.BeginTrans;
        try
          InsertHisto(0, AMagId, 0, 0, 12, 0, dtDebut, Now(), 'Erreur d''intégration dans SQLServeur');
        finally
          ADODatabase.CommitTrans;
        end;
      end;
    END;
    IbT_Ginkoia.Commit;

    IBQue_InitDtb.Close;
    //Dm_ExtractDatabase.SupprToutesProcedures;
    Ginkoia.Close;
  end;
end;

procedure TDm_ExtractDatabase.InitProgress(AMessage: string; AMax: integer; AReset : Boolean);
begin
  if FMainProgress <> Nil then
  begin
    if AReset then
    begin
      FMainProgress.Position := 0;
      FMainProgress.Step     := 1;
      FMainProgress.Min      := 0;
      FMainProgress.Max      := AMax;
      FMainProgress.Visible  := True;
      FArtProgress.Visible  := True;
    end;
  end;

  if Lab_State <> Nil then
  begin
    Lab_State.Visible := True;
    Lab_State.Caption := AMessage;
    LogAction('InitProgress : ' + AMessage, logInfo);
  end;

  Application.ProcessMessages;
end;

function TDm_ExtractDatabase.InitRecordMvt: stRecordMvt;
begin
  Result.iDosid         := 0;
  Result.iMagId         := 0;
  Result.iMvtId         := 0;
  Result.iTyp           := 0;
  Result.dtDateMvt      := 0;
  Result.iArtId         := 0;
  Result.sArtNom        := '';
  Result.sArtRefMrk     := '';
  Result.sMrkNom        := '';
  Result.iMrkIdRef      := 0;
  Result.sArtFedas      := '';
  Result.iArtPseudo     := 0;
  Result.iGtfId         := 0;
  Result.sGtfNom        := '';
  Result.sDateCree      := '';
  Result.iTgfId         := 0;
  Result.sTgfNom        := '';
  Result.iCouId         := 0;
  Result.sCouNom        := '';
  Result.sCouCode       := '';
  Result.iQte           := 0;
  Result.iKEnabled      := 1;
  Result.dtDateLivr     := 0;
  Result.fPxBrutTTC     := 0;
  Result.fPxBrutHT      := 0;
  Result.fPxNetTTC      := 0;
  Result.fPxNetHT       := 0;
  Result.fPump          := 0;
  Result.fTva           := 0;
  Result.iCodeTypeVente := 0;
  Result.sTypeVente     := '';
  Result.iFouId         := 0;
  Result.sCollection    := '';
  Result.fArtPump       := 0;
  Result.iTkeId         := 0;
  Result.dtModif        := 0;
end;

procedure TDm_ExtractDatabase.InsertAudit(AMAGID: Integer; ADATEDEBUT,
  ADATEFIN: TDateTime; ANUMETAPE, ANBLIGNE, ASTATUS: Integer;
  ASTATUSINFO: String;AWithTransaction : Boolean);
begin
  try
    if AWithTransaction then
      ADODatabase.BeginTrans;

    With aQue_QryTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO AUDIT_WRK_STOCK(AUD_MAGID, AUD_DATEDEBUT, AUD_DATEFIN, AUD_NUMETAPE, AUD_NBLIGNE, AUD_STATUS, AUD_STATUSINFO)');
      SQL.Add('VALUES(:PMAGID, :PDDEBUT, :PDFIN, :PETAPE, :PNB, :PSTATUS, :PINFO)');
      ParamCheck := True;
      Parameters.ParamByName('PMAGID').Value := AMAGID;
      Parameters.ParamByName('PDDEBUT').Value := ADATEDEBUT;
      Parameters.ParamByName('PDFIN').Value := ADATEFIN;
      Parameters.ParamByName('PETAPE').Value := ANUMETAPE;
      Parameters.ParamByName('PNB').Value := ANBLIGNE;
      Parameters.ParamByName('PSTATUS').Value := ASTATUS;
      Parameters.ParamByName('PINFO').Value := ASTATUSINFO;
      ExecSQL;
    end;

    if AWithTransaction then
      ADODatabase.CommitTrans;
  except on E:Exception do
    begin
      raise Exception.Create('Enregistrment audit en erreur : ' + E.Message);
    end;
  end;

end;

procedure TDm_ExtractDatabase.InsertHisto(AResult, AMagId, AKDeb, AKFin, AType, ANb: integer; ADtDeb, ADtFin: TDateTime; AComment: string);
begin
  AdQue_Histo.Close;
  AdQue_Histo.Parameters[0].Value := AMagId;  // Magasin
  AdQue_Histo.Parameters[1].Value := AKDeb;   // kdeb;
  AdQue_Histo.Parameters[2].Value := AKFin;   // kfin;
  AdQue_Histo.Parameters[3].Value := ADtFin;  // date fin
  AdQue_Histo.Parameters[4].Value := ADtDeb;  // Date deb
  AdQue_Histo.Parameters[5].Value := 'T' + IntToStr(AType) + ' ' + AComment;
  AdQue_Histo.Parameters[6].Value := AResult; // Ok = 1, pas ok = 0
  AdQue_Histo.Parameters[7].Value := AType;   // Type mvt
  AdQue_Histo.Parameters[8].Value := ANb;     // Nb mouvments traités (quand ok)
  AdQue_Histo.ExecSQL;

  LogAction('Insert Histo ' + IntToStr(AMagId) + '-' + IntToStr(AKDeb) + '-' + IntToStr(AKFin) + '-' + IntToStr(ANb) + '-' + IntToStr(AResult), logDebug);
end;

function TDm_ExtractDatabase.InsertMvt(AMvt: stRecordMvt; var aSW: TStopwatch): boolean;
var
  vFouIdRef: variant; // tampon pour stocker l'id ref du fournisseur
  vFouIDDtb: variant;
begin
  LogAction('Debut insertion mouvement ' + IntToStr(AMvt.iMvtId), logDebug);

  if (AMvt.iFouId <> 0) then
  begin
    vFouIDDtb := -1;
    vFouIDDtb := FObjectAssignFouid.getValue(AMvt.iFouId);
    if vFouIDDtb = -1 then
    begin
      LogAction('Debut get founisseur', logDebug);
      IBQue_GetFouById.Close;
      IBQue_GetFouById.ParamByName('FOUID').AsInteger := AMvt.iFouId;
  //    IBQue_GetFouById.Open;
      OpenAndLog(IBQue_GetFouById, '#         IBQue_GetFouById', aSW);
      IF not IBQue_GetFouById.Eof then
      begin
        LogAction('Debut insertion founisseur', logDebug);
        IF IBQue_GetFouById.FieldByName('FOU_IDREF').AsInteger = 1 THEN
        BEGIN
          IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := AMvt.iFouId;
  //        IBQue_GetFouIdRef.Open;
          OpenAndLog(IBQue_GetFouIdRef, '#         IBQue_GetFouIdRef', aSW);
          if NOT IBQue_GetFouIdRef.Eof then
          begin
            vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
          end
          else
          begin
            // Pas d'idref
            vFouIdRef := 0;
          end;
          IBQue_GetFouIdRef.Close;
        END
        else
        begin
          // Pas d'idref
          vFouIdRef := 0;
        end;
        Ps_Fournisseur.Close;     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
        Ps_Fournisseur.Parameters[1].Value := 0;                                                // @R_FOUID (output)
        Ps_Fournisseur.Parameters[2].Value := AMvt.iDosid;                                      // @P_DOSID int,
        Ps_Fournisseur.Parameters[3].Value := 0;                                                // @P_ARTIDORIGINE int,
        Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                        // @P_FOUIDREF int,
        Ps_Fournisseur.Parameters[5].Value := IBQue_GetFouById.FieldByName('FOU_NOM').AsString; // @P_FOUNOM VARCHAR

  //      Ps_Fournisseur.ExecProc;
        OpenAndLog(Ps_Fournisseur, '#         Ps_Fournisseur', aSW);
        LogAction('Fin insertion founisseur', logDebug);
        try
          vFouIDDtb := Ps_Fournisseur.Parameters[1].Value;
          FObjectAssignFouid.Add(AMvt.iFouId, vFouIDDtb);
        except
          vFouIDDtb := 0;
        end;
        Ps_Fournisseur.Close;     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
      end;
      IBQue_GetFouById.Close;
    end
    else LogAction('Founisseur déjà connu', logDebug);
  end
  else
  begin
    vFouIDDtb := AMvt.iFouId;
  end;

  try
    Ps_Mouvement.Close;     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
    Ps_Mouvement.Parameters[1].Value  := AMvt.iDosid;         // @P_DOSID int,
    Ps_Mouvement.Parameters[2].Value  := AMvt.iMagId;         // @P_MAGID int,
    Ps_Mouvement.Parameters[3].Value  := AMvt.iMvtId;         // @P_MVTIDORIGINE int,
    Ps_Mouvement.Parameters[4].Value  := AMvt.iTyp;           // @P_MVTTYPE tinyint,
    Ps_Mouvement.Parameters[5].Value  := AMvt.dtDateMvt;      // @P_MVTDATE datetime,
    Ps_Mouvement.Parameters[6].Value  := AMvt.iArtId;         // @P_ARTID int,
    Ps_Mouvement.Parameters[7].Value  := AMvt.iArtIdOri;         // @P_ARTIDORIGINE int,
    Ps_Mouvement.Parameters[8].Value  := AMvt.sArtNom;        // @P_ARTNOM VARCHAR (64),
    Ps_Mouvement.Parameters[9].Value  := AMvt.sArtRefMrk;     // @P_ARTREFMRK VARCHAR (64),
    Ps_Mouvement.Parameters[10].Value  := AMvt.sMrkNom;        // @P_MRKNOM VARCHAR (64),
    Ps_Mouvement.Parameters[11].Value := AMvt.iMrkIdRef;      // @P_MRKIDREF int,
    Ps_Mouvement.Parameters[12].Value := AMvt.sArtFedas;      // @P_ARTFEDAS CHAR (6),
    Ps_Mouvement.Parameters[13].Value := AMvt.iArtPseudo;     // @P_ARTPSEUDO INT,
    Ps_Mouvement.Parameters[14].Value := AMvt.iGtfId;         // @P_GTFID INT,
    Ps_Mouvement.Parameters[15].Value := AMvt.iGtfIdOri;         // @P_GTFIDORIGINE INT,
    Ps_Mouvement.Parameters[16].Value := AMvt.sGtfNom;        // @P_GTFNOM VARCHAR (64),
    Ps_Mouvement.Parameters[17].Value := AMvt.sDateCree;      // @P_DATECREE VARCHAR(4),
    Ps_Mouvement.Parameters[18].Value := AMvt.iTgfId;         // @P_TGFID int,
    Ps_Mouvement.Parameters[19].Value := AMvt.iTgfIdOri;         // @P_TGFIDORIGINE int,
    Ps_Mouvement.Parameters[20].Value := AMvt.sTgfNom;        // @P_TGFNOM VARCHAR(32),
    Ps_Mouvement.Parameters[21].Value := AMvt.iCouId;         // @P_COUID int,
    Ps_Mouvement.Parameters[22].Value := AMvt.iCouIdOri;         // @P_COUIDORIGINE int,
    Ps_Mouvement.Parameters[23].Value := AMvt.sCouNom;        // @P_COUNOM VARCHAR(64),
    Ps_Mouvement.Parameters[24].Value := AMvt.sCouCode;       // @P_COUCODE VARCHAR(64),
    Ps_Mouvement.Parameters[25].Value := AMvt.iQte;           // @P_MVTQTE int,
    Ps_Mouvement.Parameters[26].Value := AMvt.iKEnabled;      // @K_ENABLED int
    Ps_Mouvement.Parameters[27].Value := AMvt.fPxBrutTTC;     // @P_MVTPXBRUT_TTC float,
    Ps_Mouvement.Parameters[28].Value := AMvt.fPxBrutHT;      // @P_MVTPXBRUT_HT float,
    Ps_Mouvement.Parameters[29].Value := AMvt.fPxNetTTC;      // @P_MVTPXNET_TTC float,
    Ps_Mouvement.Parameters[30].Value := AMvt.fPxNetHT;       // @P_MVTPXNET_HT float,
    Ps_Mouvement.Parameters[31].Value := AMvt.fPump;          // @P_MVTPUMP float,
    Ps_Mouvement.Parameters[32].Value := AMvt.fTva;           // @P_MVTTVA float,
    Ps_Mouvement.Parameters[33].Value := AMvt.iCodeTypeVente; // @P_MVTTYPVTE int,
    Ps_Mouvement.Parameters[34].Value := AMvt.sTypeVente;     // @P_MVTTYPVTELIB VARCHAR(32),
    Ps_Mouvement.Parameters[35].Value := AMvt.dtDateLivr;     // @P_MVTDTLIV datetime,
    Ps_Mouvement.Parameters[36].Value := AMvt.sCollection;    // @P_MVTCOLLEC varchar(32),
    Ps_Mouvement.Parameters[37].Value := vFouIDDtb;           // @P_MVTFOUNOM int,
    Ps_Mouvement.Parameters[38].Value := AMvt.fArtPump;       // Pump
    Ps_Mouvement.Parameters[39].Value := AMvt.iTkeId;         // Id Ticket dans DTB
    Ps_Mouvement.Parameters[40].Value := AMvt.dtModif;        // Date de modif
    Ps_Mouvement.Parameters[41].Value := AMvt.iFusion;        // Flag Modèle fusionné.

//    Ps_Mouvement.ExecProc;
    OpenAndLog(Ps_Mouvement, '#         Ps_Mouvement', aSW);
    Ps_Mouvement.Close;     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
    LogAction('Fin insertion mouvement' + IntToStr(AMvt.iMvtId), logDebug);
    Result := True;
  except
    ON E: Exception DO
    begin
      LogAction('Erreur d''intégration dans SQLServeur', logError);
      LogAction(E.Message, logError);
      Result := False;
      FErreurSQLTexte := E.Message;
    end;
  end;
end;

function TDm_ExtractDatabase.IsPathInList(ADirectory: String;
  ALst: TStrings): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not Assigned(ALst) then
    Exit;

  for i := 0 to ALst.Count -1 do
    if Trim(Alst[i]) <> '' then
      if Pos(UpperCase(Alst[i]),Uppercase(ADirectory)) > 0 then
      begin
        Result := true;
        Exit;
      end;
end;

procedure TDm_ExtractDatabase.nbt_stopClick(Sender: TObject);
begin
  if not FExit then
  begin
    TAdvGlowButton(Sender).Caption := ' Arret en cours ... ';
    TAdvGlowButton(Sender).Enabled := False;
    FExit := True;
  end;
end;

procedure TDm_ExtractDatabase.OpenAndLog(aQry: TADOStoredProc; aName : string; var aSW: TStopwatch);
begin
  try
    aQry.ExecProc;
  except
    on e:exception do
    begin
      LogAction('##### ' + e.classname + ' - ' + e.Message, logError);
      raise;
    end;
  end;
  aSW.Stop;
  LogAction(aName + ':' + IntToStr(aSW.ElapsedMilliseconds) + 'ms', logDebug);
  aSW.Reset;
  aSW.Start;
end;

procedure TDm_ExtractDatabase.OpenAndLog(aQry: TIBQuery; aName : string; var aSW: TStopwatch);
begin
  try
    aQry.Open;
  except
    on e:exception do
      LogAction('#####' + e.classname + ' - ' + e.Message, logError);
  end;
  aSW.Stop;
  LogAction(aName + ':' + IntToStr(aSW.ElapsedMilliseconds) + 'ms', logDebug);
  aSW.Reset;
  aSW.Start;
end;

procedure TDm_ExtractDatabase.RecalStock;
begin
//  With IBQue_Tmp do
  try
    IBQue_Tmp.Close;
    IBQue_Tmp.SQL.Clear;
    IBQue_Tmp.SQL.Add('Select * from TF_TRIGGERDIFFERE_ARTICLE(0)');
    IBQue_Tmp.Open;
  Except on E:Exception do
    raise Exception.Create('Erreur Execution recalcul : ' + E.Message);
  end;
end;

procedure TDm_ExtractDatabase.DoTraitementStock;
begin
    IniCfg.LoadIni;
    DataBaseConnection;

    AdQue_GetListMags.Close;
    AdQue_GetListMags.SQL.Clear;
    AdQue_GetListMags.SQL.Add('select mag_id, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom, max(mhi_datefin) replic,');
    AdQue_GetListMags.SQL.Add(' max(mag_extractCLT) mag_extractCLT, max(mag_extractCLTLastK) mag_extractCLTLastK, max(mag_database) mag_database');
    AdQue_GetListMags.SQL.Add(' from ' + getDatabase + 'magasin mag with (nolock)');
    AdQue_GetListMags.SQL.Add(' join ' + getDatabase + 'dossiers dos on dos_id=mag_dosid	');
    AdQue_GetListMags.SQL.Add(' left outer join magasinhistodtb histo on (mag.mag_id=histo.mhi_magid and histo.mhi_ok=1)');
    AdQue_GetListMags.SQL.Add(' where mag_enabled=1');
    AdQue_GetListMags.SQL.Add('  and ((mag_database=1) or (mag_extractCLT=1))');
    AdQue_GetListMags.SQL.Add('  and mag_tymid<>3');
    AdQue_GetListMags.SQL.Add('  and mag_dtbdateactivation <= current_timestamp');
    AdQue_GetListMags.SQL.Add(' group by mag_id, mag_actif, mag_dtbdateactivation, mag_code, mag_cheminbase, dos_id, mag_nom');
    AdQue_GetListMags.SQL.Add(' Order By replic');
    AdQue_GetListMags.Open;
    AdQue_GetListMags.First;
    Try
      while not AdQue_GetListMags.Eof do
      begin

        // Test pour savoir si l'on va traiter les bases de la liste.
        if not IsPathInList(AdQue_GetListMags.FieldByName('mag_cheminbase').AsString,IniCfg.LstLames) then
        begin
          AdQue_GetListMags.Next;
          DoProgress;
          Continue;
        end;

        Ginkoia.Close;
        Ginkoia.DatabaseName := AdQue_GetListMags.FieldByName('mag_cheminbase').AsString;
        Ginkoia.Open;

//        InitProgress('Stock : ' +  AdQue_GetListMags.FieldByName('MAG_NOM').AsString,4);

        GestionStock(AdQue_GetListMags.FieldByName('MAG_ID').AsInteger, AdQue_GetListMags.FieldByName('MAG_CODE').AsString);

        AdQue_GetListMags.Next;
      end;

//      InitProgress('Stock : Fin du traitement', 0);

    Except on E:Exception do
      begin
        Showmessage(Format('Une erreur est survenu lors du traitement de : %s - %s',[AdQue_GetListMags.FieldByName('MAG_NOM').AsString, E.Message]));
      end;
    End;

end;

//procedure TDm_ExtractDatabase.SupprToutesProcedures;
//begin
//  {$IFNDEF DEBUG}
//    SupprProcedure('SP2K_DTB_MVT');
//    SupprProcedure('SP2K_DTB_GETMVT');
//    SupprProcedure('SP2K_DTB_INITARTICLE');
//    SupprProcedure('SP2K_DTB_ARTGETCB');
//    SupprProcedure('SP2K_DTB_ARTICLEINFO');
//  {$ELSE}
//    //Si on est en débug
//    //if diadiashw 'Voulez-vous supprimer toutes les Procédures ?'  then
//    begin
//      SupprProcedure('SP2K_DTB_MVT');
//      SupprProcedure('SP2K_DTB_GETMVT');
//      SupprProcedure('SP2K_DTB_INITARTICLE');
//      SupprProcedure('SP2K_DTB_ARTGETCB');
//      SupprProcedure('SP2K_DTB_ARTICLEINFO');
//    end;
//  {$ENDIF}
//end;
//
//procedure TDm_ExtractDatabase.MajToutesProcedures;
//begin
//  {$IFNDEF DEBUG}
//    // Suppression des procédures si existantes
//    SupprToutesProcedures;
//
//    // Recréation (dans l'ordre inverse)
//    CreerProcedure('SP2K_DTB_ARTICLEINFO');
//    CreerProcedure('SP2K_DTB_ARTGETCB');
//    CreerProcedure('SP2K_DTB_INITARTICLE');
//    CreerProcedure('SP2K_DTB_GETMVT');
//    CreerProcedure('SP2K_DTB_MVT');
//  {$ELSE}
//    // Suppression des procédures si existantes
//    SupprToutesProcedures;
//
//    //if shw 'Voulez-vous recréer toutes les Procédures ?'  then
//    begin
//      // Recréation (dans l'ordre inverse)
//      CreerProcedure('SP2K_DTB_ARTICLEINFO');
//      CreerProcedure('SP2K_DTB_ARTGETCB');
//      CreerProcedure('SP2K_DTB_INITARTICLE');
//      CreerProcedure('SP2K_DTB_GETMVT');
//      CreerProcedure('SP2K_DTB_MVT');
//    end;
//  {$ENDIF}
//end;

//procedure TDm_ExtractDatabase.SupprProcedure(AProcName: string);
//begin
//  // Suppression des procédures si existantes
//  try
//    IbT_Ginkoia.StartTransaction;
//    IbSql_MajProc.SQL.Text := 'DROP PROCEDURE ' + AProcName;
//    IbSql_MajProc.ExecQuery;
//    IbT_Ginkoia.Commit;
//  except
//    on E: Exception do
//    begin
//      if Pos('Procedure ' + AProcName + ' not found', E.Message) <= 0 then
//      begin
//        LogAction('Erreur suppression : ' + AProcName, 0);
//        LogAction(E.Message, 4);
//      end;
//      IbT_Ginkoia.RollBack;
//    end;
//  end;
//end;

procedure TDm_ExtractDatabase.Test;
//var
//  iTmp : integer;
begin
//  FObjectAssignFouid.Clear;
//  FObjectAssignFouid.Add(5,5);
//  FObjectAssignFouid.Add(7,6);
//  FObjectAssignFouid.Add(12,7);
//  FObjectAssignFouid.Add(25,50);
//  FObjectAssignFouid.Add(50,53);
//  iTmp := FObjectAssignFouid.getValue(12);
//  FObjectAssignFouid.Clear;
end;

function TDm_ExtractDatabase.TraiteBase(AChemin, AMagAdh: string; ADosid, AMagId: integer;
ADateInit: TDateTime; aInit : boolean; bAskPlage : Boolean): boolean;
var
  iTypeMvt   : integer;     // Type de mouvement (de 1 à 11)
  iLastK     : integer;     // Contient le dernier K Traité
  iCurVersion: integer;     // Current version de la base.
  iKDeb      : integer;     // Dernier K traité au traitement précédent
  dtDebutTrt : TDateTime;   // Timestamp de début de traitement
  bIsOldDatabase : Boolean;
  vSW : TStopwatch;
  sLogSrv    : string;
  sLogDos    : string;
  sLogRef    : string;
  sLogMag    : string;
  sDate      : string;      // Tampon pour mettre date sur 4 car
  bFinBoucle : boolean;     // Flag de sortie de boucle en cas d'erreur
  vPlageIn, vPlageOut : TPlage;
begin
  vSW.StartNew;
  Result := False;
//  aChemin := 'C:\Ginkoia\Data\Ginkoia.ib';  // test
  if AChemin = '' then
  begin
    ADODatabase.BeginTrans;
    try
      InsertHisto(0, AMagId, 0, 0, 0, 0, Now(), Now(), 'Chemin la base Ginkoia non paramétré');
    finally
      ADODatabase.CommitTrans;
    end;
    Exit;
  end;
  sloGSrv := getSrvFromPathIB(Trim(UpperCase(AChemin)));
  sLogDos := Trim(UpperCase(AChemin));
  sLogRef := AMagAdh;
  sLogMag := '';

  LogAction('Traitement base Ginkoia ' + AChemin, logInfo);

  InitProgress('Connexion base Ginkoia ' + AChemin, 1);

  LogAction('Connexion base Ginkoia ' + AChemin, logInfo);
  Ginkoia.DatabaseName := AChemin;
  Ginkoia.Close;
  TRY
    Ginkoia.Open;
    DoProgress;
  EXCEPT
    // Chemin inccorect à voir si on log, ca peut être normal tant qu'on a pas renseigné le chemin
    LogAction(AMagAdh + ' : Connection Ginkoia échouée - ' + AChemin, logError);
    Log.Log('','Main','','','','Status','Echec connexion : ' + AChemin,logInfo,false);

    ADODatabase.BeginTrans;
    try
      InsertHisto(0, AMagId, 0, 0, 0, 0, Now(), Now(), 'Connection Ginkoia échouée - ' + AChemin);
    finally
      ADODatabase.CommitTrans;
    end;
  END;
  FObjectAssignFouid.Clear;
  try
    if Ginkoia.Connected then
    begin
  //    IbT_Ginkoia.StartTransaction;
  //    with IBQue_Tmp do
      begin
        IBQue_Tmp.Close;
        IBQue_Tmp.SQL.Clear;
        IBQue_Tmp.SQL.Add('select bas_sender,mag_id,bas_guid,');
        IBQue_Tmp.SQL.Add('CASE WHEN bas_nompournous IS NULL THEN (select max(bas_nompournous) from genbases where bas_nompournous <> '''')');
        IBQue_Tmp.SQL.Add('ELSE bas_nompournous END as bas_nompournous');
        IBQue_Tmp.SQL.Add('from genmagasin');
        IBQue_Tmp.SQL.Add('left join genbases on bas_magid=mag_id');
        IBQue_Tmp.SQL.Add('where mag_codeadh = :codeadh');
        IBQue_Tmp.SQL.Add('order by bas_sender desc');
        IBQue_Tmp.ParamByName('codeadh').AsString := AMagAdh;
        IBQue_Tmp.Open;
        sLogRef := IBQue_Tmp.FieldByName('bas_guid').AsString;
        sLogMag := IBQue_Tmp.FieldByName('mag_id').AsString;
        sLogDos := IBQue_Tmp.FieldByName('bas_nompournous').AsString;
      end;
      LogAction('Connexion base Ginkoia réussie', logInfo);
      Log.Log('','Main','','','','Status','Traitement dossier ' + sLogDos + ' (' + AMagAdh + ')',logInfo,true);
      //SR - 17/10/2014 - Ajout d'un test si le traitement c'est déjà fait dans la nuit.

  //    InitProgress('Mise à jour des procédures', 1);
      //Dm_ExtractDatabase.MajToutesProcedures;

      if not IbT_Ginkoia.InTransaction then
        IbT_Ginkoia.StartTransaction;
      TRY

        {$REGION 'Vérification de la présence des tables OCSP2K'}
  //      With IBQue_Tmp do
        begin
          IBQue_Tmp.Close;
          IBQue_Tmp.SQL.Clear;
          IBQue_Tmp.SQL.Add('select distinct count(*) as Resultat from rdb$RELATION_FIELDS');
          IBQue_Tmp.SQL.Add('where RDB$VIEW_CONTEXT is null');
          IBQue_Tmp.SQL.Add('and RDB$SYSTEM_FLAG = 0');
          IBQue_Tmp.SQL.Add('and RDB$RELATION_NAME = ''OCSP2K''');
          IBQue_Tmp.SQL.Add('GROUP BY  RDB$RELATION_NAME;');
          IBQue_Tmp.Open;

          bIsOldDatabase := (IBQue_Tmp.FieldByName('Resultat').AsInteger = 0);
        end;
        {$ENDREGION}

        // Récup la Version en cours de la base
        iCurVersion := GetCurVer;

        AdQue_KMax.Close;
        AdQue_KMax.Parameters[0].Value := AMagId;
        AdQue_KMax.Open;

        AdQue_KMax.First;
        vPlageIn._Start := 0;
        if AdQue_KMax.Locate('mhi_typ', 12, []) then
        begin
          vPlageIn._Start := AdQue_KMaxkmax.AsInteger;
          vPlageIn._End := iCurVersion;
        end;

        if bAskPlage then
          vPlageOut := Show(vPlageIn)
        else
          vPlageOut := vPlageIn;

        {$REGION 'Gestion des articles'}
        Log.Log('','Main','','','','Status','Récupération des articles',logInfo,true);
//        AdQue_KMax.First;
//        if AdQue_KMax.Locate('mhi_typ', 12, []) then
        if vPlageIn._Start > 0 then
        begin
          LogAction(format('Debut UpdateArticle (%d > %d)', [vPlageOut._Start , vPlageOut._End]), logInfo);
          if not aInit then
            UpdateArticle(ADosid, AMagId, vPlageOut._Start , vPlageOut._End, maArt,'');
          LogAction(format('Fin UpdateArticle (%d > %d)', [vPlageOut._Start , vPlageOut._End]), logInfo);
        end;
        {$ENDREGION}

        {$REGION 'Recalcul Stock'}
        Log.Log('','Main','','','','Status','Recalcul du stock',logInfo,true);
        RecalStock;
        {$ENDREGION}

        bFinBoucle                     := False;
        iTypeMvt                       := 0;

        while (NOT bFinBoucle) AND (iTypeMvt <= 14) do
        begin
          Inc(iTypeMvt);
          case iTypeMvt of
            1, 3, 5, 11, 12 : // 13, 14 (Réactivation des BA et coupons 13/11/2019
              begin
                InitProgress('Mouvements de type ' + IntToStr(iTypeMvt) + ' ignorées', 0);
                LogAction('Mouvements de type ' + IntToStr(iTypeMvt) + ' ignorées', logInfo);
                Continue;
              end;
            15: begin
            bFinboucle := True;
            Continue;
            end;
          end;

          dtDebutTrt := Now;
          iLastK     := 0;

          InitProgress('Traitement des mouvements de type ' + IntToStr(iTypeMvt), 0);
          LogAction('Traitement des mouvements de type ' + IntToStr(iTypeMvt), logInfo);
          AdQue_KMax.First;
          if not AdQue_KMax.Locate('mhi_typ', iTypeMvt, []) then
          begin
            // Pas trouvé, on flag l'erreur + SORTIE DE BOUCLE, on ne traite pas les autres mouvements
            InsertHisto(0, AMagId, 0, iLastK, iTypeMvt, 0, dtDebutTrt, Now(), 'KVersion max non trouvé');
            bFinBoucle := True;
            FErreurSQLTexte := 'KVersion max non trouvé';
          end
          else
          begin

            if not bAskPlage then
              vPlageOut._Start := AdQue_KMaxkmax.AsInteger;

            iKDeb := vPlageOut._Start;

            if iKDeb <= 0 then
            begin
              // Pas trouvé, on flag l'erreur + SORTIE DE BOUCLE, on ne traite pas les autres mouvements
              InsertHisto(0, AMagId, 0, iLastK, iTypeMvt, 0, dtDebutTrt, Now(), 'KVersion max à 0');
              bFinBoucle := True;
              FErreurSQLTexte := 'KVersion max à 0';
            end
            else
            begin
              iLastK   := iKDeb;
              doDelta(AChemin, aDosId, aMagId, AMagAdh, iLastK, iTypeMvt, vPlageOut._End, ADateInit, bIsOldDatabase, bFinBoucle, aInit, vSW);
            end;                // End If
          end;                  // End If
        end; // End While typemvt

        UpdateUtilTkeID(AMagId);

        {$REGION ' 'Gestion du Stock'}
        if IniCfg.CheckCalcStock then
          GestionStock(aMagId, AMagAdh);

        {$ENDREGION}

        Log.Log(sLogSrv,'Traitement',sLogDos,sLogRef,sLogMag,'integration','OK',loginfo,true);
        IbT_Ginkoia.Commit;
        IBQue_InitDtb.Close;
      EXCEPT
        ON E: Exception DO
        begin
          if ADODatabase.InTransaction Then
            ADODatabase.RollbackTrans;

          if IbT_Ginkoia.InTransaction then
            IbT_Ginkoia.Rollback;
        end;
      END;
    end;
  finally
    Ginkoia.Close;
    FObjectAssignFouid.Clear;
  end;
  LogAction('Fin traitement' + AChemin, logInfo);
end;

procedure TDm_ExtractDatabase.UpdateArticle(ADosID, AMagID, AKDeb, AKFin: Integer; AMode : TModeArt; AMrkNom : String; AInit : Boolean = False; ADateInit : TDate = 43466);
var
  DtbARTID, DtbGtfID, DtbPrevARTID : Integer;
  typeCB : Integer; // type du code barre : 1,2,3...
  iDeb, iFin : Integer;
  bFin : Boolean;
  dTEstime, DtEcoule, dtTotal : TTime;
  iCount : Integer;

  vFouIdRef, iNbArt, i : Integer;
  stMvtInit : stRecordMvt; // Variable contenant le mouvemnet à insérer
  dtDebut : TDateTime;
  bErreurMvt : Boolean;
  iGnkMagId : integer;
  vSW : TStopwatch;
  vArt : TIBQuery;
  iOldKFin : integer;
  iOriArt, iOriCou, iOriTgf,
  iArt, iCou, iTgf : Integer;
begin
  vSW.StartNew;
  iNbArt := 0;
  dtDebut := Now;
  bErreurMvt := False;

  iGnkMagId := GetGinkoiaMagid(AMagID);
  iOldKFin := AKFin;

  if aInit then
  begin
    InitProgress('Initalisation de la base de données', 1);
    IBQue_Tmp.Close;
    IBQue_Tmp.SQL.Clear;
    IBQue_Tmp.SQL.Text := 'SELECT NBART FROM SP2K_DTB_ARTICLE_INIT(:DateInit)';
    IBQue_Tmp.ParamCheck := true;
    IBQue_Tmp.ParamByName('DateInit').AsDate := ADateInit;
    InitProgress('Chargement des articles', 1);
//      IBQue_Tmp.Open;
    OpenAndLog(IBQue_Tmp, '#SP2K_DTB_ARTICLE_INIT', vSW);
    if not IBQue_Tmp.isEmpty then
    begin
      AKFin := IBQue_Tmp.Fields[0].asInteger;
      AKDeb := 1;
    end;
  end
  else
    InitProgress('Récupération des données articles', 1);

  iDeb := AKDeb;

  if AKFin > 10000 then
    iFin := iDeb + 10000
  else
    iFin := AKFin;

  bFin := False;

  dTEstime := 0;
  DtEcoule := 0;
  dtTotal := 0;
  iCount := 1;
  InitProgress(Format('Plage Traitée %d - %d / Plage %d - %d',[iDeb,iFin,AKDeb, AKFin]), (AKFin div 10000) -(AKDeb Div 10000));

  ArtProgress.Min := 0;
  ArtProgress.Max := 10000;
  ArtProgress.Step := 1;

  while not bFin do
  begin
    InitProgress(Format('Plage Traitée %d - %d / Plage %d - %d',[iDeb,iFin,AKDeb, AKFin]), (AKFin div 10000) -(AKDeb Div 10000),False);
    DtEcoule := Now;

    // Récupération des données articles
//    With IBQue_Tmp do
    begin
      if aInit then
      begin
        IBQue_Tmp.Close;
        IBQue_Tmp.SQL.Clear;
        IBQue_Tmp.SQL.Text := 'SELECT * from SP2K_DTB_ARTICLE_SELECT(:PMAGID, :PKDEB, :PKFIN)';
        IBQue_Tmp.ParamCheck := True;
        IBQue_Tmp.ParamByName('PMAGID').AsInteger := iGnkMagId;//AMagID;
        IBQue_Tmp.ParamByName('PKDEB').AsInteger  := iDeb; // AKDeb;
        IBQue_Tmp.ParamByName('PKFIN').AsInteger  := iFin; //AKFin;
      end
      else
      begin
        IBQue_Tmp.Close;
        IBQue_Tmp.SQL.Clear;
        IBQue_Tmp.SQL.Text := 'SELECT * from SP2K_DTB_ARTICLE(:PMAGID, :PKDEB, :PKFIN, :PMOD, :PMRK)';
        IBQue_Tmp.ParamCheck := True;
        IBQue_Tmp.ParamByName('PMAGID').AsInteger := iGnkMagId;//AMagID;
        IBQue_Tmp.ParamByName('PKDEB').AsInteger  := iDeb; // AKDeb;
        IBQue_Tmp.ParamByName('PKFIN').AsInteger  := iFin; //AKFin;
        case AMode of
          maArt: begin
            IBQue_Tmp.ParamByName('PMOD').AsInteger  := 0;
            IBQue_Tmp.ParamByName('PMRK').AsString  := '';
          end;
          maMrk: begin
            IBQue_Tmp.ParamByName('PMOD').AsInteger  := 1;
            IBQue_Tmp.ParamByName('PMRK').AsString   := AMrkNom;
          end;
        end;
      end;

      DtbPrevARTID := 0;
//      IBQue_Tmp.Open;
      OpenAndLog(IBQue_Tmp, '#  SP2K_DTB_MODELE_SELECT', vSW);

      IBQue_Tmp.Last;
      IBQue_Tmp.First;
//      InitProgress('Récupération des données articles', RecordCount);
      ArtProgress.Position := 0;
      while not IBQue_Tmp.EOF do
      begin
        ArtProgress.StepIt;
        Application.ProcessMessages;
        try

          if(DtbPrevARTID <> IBQue_Tmp.FieldByName('ARTID').AsInteger) then
          begin
            // Gestion des modèles
            Ps_Article.Close;
            Ps_Article.Parameters.ParamByName('@P_DOSID').Value        := ADosID;
            Ps_Article.Parameters.ParamByName('@P_ARTIDORIGINE').Value := IBQue_Tmp.FieldByName('ARTID').AsInteger;
            Ps_Article.Parameters.ParamByName('@P_ARTNOM').Value       := IBQue_Tmp.FieldByName('ARTNOM').AsString;
            Ps_Article.Parameters.ParamByName('@P_ARTREFMRK').Value    := IBQue_Tmp.FieldByName('ARTREFMRK').AsString;
            Ps_Article.Parameters.ParamByName('@P_MRKNOM').Value       := IBQue_Tmp.FieldByName('MRKNOM').AsString;
            Ps_Article.Parameters.ParamByName('@P_MRKIDREF').Value     := IBQue_Tmp.FieldByName('MRKIDREF').AsInteger;
            Ps_Article.Parameters.ParamByName('@P_ARTFEDAS').Value     := IBQue_Tmp.FieldByName('ARTFEDAS').AsString;
            Ps_Article.Parameters.ParamByName('@P_ARTPSEUDO').Value    := IBQue_Tmp.FieldByName('ARFPSEUDO').AsInteger;
            Ps_Article.Parameters.ParamByName('@P_GTFIDORIGINE').Value := IBQue_Tmp.FieldByName('GTFID').AsInteger;
            Ps_Article.Parameters.ParamByName('@P_GTFNOM').Value       := IBQue_Tmp.FieldByName('GTFNOM').AsString;
            Ps_Article.Parameters.ParamByName('@P_DATECREE').Value     := FormatDateTime('YYYY', IBQue_Tmp.FieldByName('ARFCREE').AsDateTime);
//            Ps_Article.ExecProc;
            OpenAndLog(Ps_Article, '#     ARTICLE_GET_OR_INSERT', vSW);
            iOriArt := IBQue_Tmp.FieldByName('ARTID').AsInteger;
            iArt := Ps_Article.Parameters.ParamValues['@R_ARTID'];
            LogAction(format('AddArticle(Ori : %d > %d)', [iOriArt, iArt]), logDebug);
            DtbPrevARTID := IBQue_Tmp.FieldByName('ARTID').AsInteger;

            // En mode initialisation
            if AInit then
            begin
              {$REGION 'Gestion fournisseur'}
              IBQue_GetFourn.Close;
              IBQue_GetFourn.ParamByName('ARTID').AsInteger := IBQue_Tmp.FieldByName('ARTID').AsInteger;
  //            IBQue_GetFourn.Open;
              OpenAndLog(IBQue_GetFourn, '#     IBQue_GetFourn', vSW);
              while not IBQue_GetFourn.Eof do
              begin
                IF IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger = 1 THEN
                BEGIN
                  IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := IBQue_GetFourn.FieldByName('FOU_ID').AsInteger;
  //                IBQue_GetFouIdRef.Open;
                  OpenAndLog(IBQue_GetFouIdRef, '#     IBQue_GetFouIdRef', vSW);
                  if NOT IBQue_GetFouIdRef.Eof then
                  begin
                    vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
                  end
                  else
                  begin
                    // Pas d'idref
                    vFouIdRef := 0;
                  end;
                  IBQue_GetFouIdRef.Close;
                END
                else
                begin
                  // Pas d'idref
                  vFouIdRef := 0;
                end;

                Ps_Fournisseur.Close;                     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                Ps_Fournisseur.Parameters[1].Value := 0;                                               // @R_FOUID (output)
                Ps_Fournisseur.Parameters[2].Value := ADosid;                                          // @P_DOSID int,
                Ps_Fournisseur.Parameters[3].Value := IBQue_Tmp.FieldByName('ARTID').AsVariant;    // @P_ARTIDORIGINE int,
                Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                       // @P_FOUIDREF int,
                Ps_Fournisseur.Parameters[5].Value := IBQue_GetFourn.FieldByName('FOU_NOM').AsVariant; // @P_FOUNOM int

  //              Ps_Fournisseur.ExecProc;
                OpenAndLog(Ps_Fournisseur, '#     Ps_Fournisseur', vSW);
                Ps_Fournisseur.Close;                     //SR - 11/09/2014 - Pour éviter les DeadLock on ferme le TADOStoredProc
                IBQue_GetFourn.Next;
              end;
              IBQue_GetFourn.Close;
              {$ENDREGION}
            end;
          end;

          {$REGION 'Récupération des CB de l''article + Init mouvement'}
          IBQue_TmpCB.Close;
          IBQue_TmpCB.SQL.Clear;
          IBQue_TmpCB.SQL.Add('Select * from SP2K_DTB_ARTGETCB(:PARFID, :PCOUID, :PTGFID)');
          IBQue_TmpCB.ParamCheck := True;
          IBQue_TmpCB.ParamByName('PARFID').AsInteger := IBQue_Tmp.FieldByName('ARFID').AsInteger;
          IBQue_TmpCB.ParamByName('PCOUID').AsInteger := IBQue_Tmp.FieldByName('COUID').AsInteger;
          IBQue_TmpCB.ParamByName('PTGFID').AsInteger := IBQue_Tmp.FieldByName('TGFID').AsInteger;
//          IBQue_TmpCB.Open;
          OpenAndLog(IBQue_TmpCB, '#       SP2K_DTB_ARTGETCB', vSW);
          // Gestion des CB et couleurs
          while not IBQue_TmpCB.Eof do
          begin
            Ps_CbArt.Close;

            typeCB := IBQue_TmpCB.FieldByName('TYPECB').AsInteger;
            // dans le cas des CB de type 3, alors nous ajoutons le suffixe '_' + DOSID, sinon juste le CB
            if (typeCB = 3) then
            begin
              Ps_CbArt.Parameters.ParamByName('@P_CBIEAN').Value     := IBQue_TmpCB.FieldByName('CBICB').AsString + '_' + IntToStr(ADosID);
            end else
            begin
              Ps_CbArt.Parameters.ParamByName('@P_CBIEAN').Value     := IBQue_TmpCB.FieldByName('CBICB').AsString;
            end;

            Ps_CbArt.Parameters.ParamByName('@P_CBENABLED').Value    := IBQue_TmpCB.FieldByName('K_ENABLED').AsInteger;
            Ps_CbArt.Parameters.ParamByName('@P_ARTID').Value        := Ps_Article.Parameters.ParamValues['@R_ARTID'];
            Ps_CbArt.Parameters.ParamByName('@P_COUIDORIGINE').Value := IBQue_Tmp.FieldByName('COUID').AsInteger;
            Ps_CbArt.Parameters.ParamByName('@P_COUNOM').Value       := IBQue_Tmp.FieldByName('COUNOM').AsString;
            Ps_CbArt.Parameters.ParamByName('@P_COUCODE').Value      := IBQue_Tmp.FieldByName('COUCODE').AsString;
            Ps_CbArt.Parameters.ParamByName('@P_TGFIDORIGINE').Value := IBQue_Tmp.FieldByName('TGFID').AsInteger;
            Ps_CbArt.Parameters.ParamByName('@P_TGFNOM').Value       := IBQue_Tmp.FieldByName('TGFNOM').AsString;
            Ps_CbArt.Parameters.ParamByName('@P_GTFID').Value        := Ps_Article.Parameters.ParamValues['@R_GTFID'];
            Ps_CbArt.Parameters.ParamByName('@P_TYPE').Value         := IBQue_TmpCB.FieldByName('TYPECB').AsInteger;
            Ps_CbArt.Parameters.ParamByName('@P_DOSID').Value        := ADosID;
            Ps_CbArt.Parameters.ParamByName('@P_ARTIDORIGINE').Value := IBQue_Tmp.FieldByName('ARTID').AsInteger;
            Ps_CbArt.Parameters.ParamByName('@P_GTFIDORIGINE').Value := IBQue_Tmp.FieldByName('GTFID').AsInteger;
            Ps_CbArt.Parameters.ParamByName('@P_GTFNOM').Value       := IBQue_Tmp.FieldByName('GTFNOM').AsString;
//            Ps_CbArt.ExecProc;
            OpenAndLog(Ps_CbArt, '#         Ps_CbArt', vSW);
            iArt := Ps_Article.Parameters.ParamValues['@R_ARTID'];
            iCou := Ps_CbArt.Parameters.ParamValues['@R_COUID'];
            iTgf := Ps_CbArt.Parameters.ParamValues['@R_TGFID'];
            LogAction(format('AddCB(Ori Art, Cou, Tgf : %d, %d, %d > %d, %d, %d)',
                                [IBQue_Tmp.FieldByName('ARTID').AsInteger,
                                 IBQue_Tmp.FieldByName('COUID').AsInteger,
                                 IBQue_Tmp.FieldByName('TGFID').AsInteger,
                                 iArt,
                                 iCou,
                                 iTgf]), logDebug);




            IBQue_TmpCB.Next;

            if AInit then
            begin
              {$REGION 'Init des mouvements'}
              // récupétation des informations de stock
              IBQue_InitDtbTmp.Close;
              IBQue_InitDtbTmp.SQL.Clear;
              IBQue_InitDtbTmp.SQL.Add('SELECT HST_ID, HST_QTE FROM AGRHISTOSTOCK');
              IBQue_InitDtbTmp.SQL.Add('Where HST_ID = (');
              IBQue_InitDtbTmp.SQL.Add('SELECT MAX(HST_ID)');
              IBQue_InitDtbTmp.SQL.Add('  FROM AGRHISTOSTOCK');
              IBQue_InitDtbTmp.SQL.Add('WHERE HST_ARTID = :ARTID');
              IBQue_InitDtbTmp.SQL.Add('  AND HST_COUID = :COUID');
              IBQue_InitDtbTmp.SQL.Add('  AND HST_TGFID = :TGFID');
              IBQue_InitDtbTmp.SQL.Add('  AND HST_MAGID = :MAGID');
              IBQue_InitDtbTmp.SQL.Add('  AND HST_DATE <= :HSTDATE)');
              IBQue_InitDtbTmp.ParamCheck := True;
              IBQue_InitDtbTmp.ParamByName('ARTID').AsInteger := IBQue_Tmp.FieldByName('ARTID').AsInteger;
              IBQue_InitDtbTmp.ParamByName('COUID').AsInteger := IBQue_Tmp.FieldByName('COUID').AsInteger;
              IBQue_InitDtbTmp.ParamByName('TGFID').AsInteger := IBQue_Tmp.FieldByName('TGFID').AsInteger;
              IBQue_InitDtbTmp.ParamByName('MAGID').AsInteger := iGnkMagId;//aMagId;
              IBQue_InitDtbTmp.ParamByName('HSTDATE').AsDate := ADateInit;
//              IBQue_InitDtbTmp.Open;
              OpenAndLog(IBQue_InitDtbTmp, '#         IBQue_InitDtbTmp', vSW);
              stMvtInit            := InitRecordMvt;

              stMvtInit.iDosid     := ADosid;                                           // @P_DOSID int,
              stMvtInit.iMagId     := AMagId;                                           // @P_MAGID int,
              stMvtInit.iMvtId     := IBQue_InitDtbTmp.FieldByName('HST_ID').AsInteger;     // @P_MVTIDORIGINE int,
              stMvtInit.iTyp       := 12;                                               // @P_MVTTYPE tinyint,
              stMvtInit.dtDateMvt  := ADateInit;                                        // @P_MVTDATE datetime,
              stMvtInit.iArtId     := Ps_Article.Parameters.ParamValues['@R_ARTID'];     // @P_ARTID int,
              stMvtInit.iArtIdOri     := IBQue_Tmp.FieldByName('ARTID').AsInteger;     // @P_ARTIDORIGINE int,
              stMvtInit.sArtNom    := IBQue_Tmp.FieldByName('ARTNOM').AsString;     // @P_ARTNOM VARCHAR (64),
              stMvtInit.sArtRefMrk := IBQue_Tmp.FieldByName('ARTREFMRK').AsVariant; // @P_ARTREFMRK VARCHAR (64),
              stMvtInit.sMrkNom    := IBQue_Tmp.FieldByName('MRKNOM').AsString;     // @P_MRKNOM VARCHAR (64),
              stMvtInit.iMrkIdRef  := IBQue_Tmp.FieldByName('MRKIDREF').AsInteger;  // @P_MRKIDREF int,
              stMvtInit.sArtFedas  := IBQue_Tmp.FieldByName('ARTFEDAS').AsString;   // @P_ARTFEDAS CHAR (6),
              stMvtInit.iArtPseudo := IBQue_Tmp.FieldByName('ARFPSEUDO').AsInteger; // @P_ARTPSEUDO INT,
              stMvtInit.iGtfId     := Ps_Article.Parameters.ParamValues['@R_GTFID'];     // @P_GTFID INT,
              stMvtInit.iGtfIdOri     := IBQue_Tmp.FieldByName('GTFID').AsInteger;     // @P_GTFIDORIGINE INT,
              stMvtInit.sGtfNom    := IBQue_Tmp.FieldByName('GTFNOM').AsString;     // @P_GTFNOM VARCHAR (64),
              stMvtInit.sDateCree  := String(FormatDateTime('yyyy', IBQue_Tmp.FieldByName('ARFCREE').AsDateTime));// @P_DATECREE VARCHAR(4),
              stMvtInit.iTgfId     := Ps_CbArt.Parameters.ParamValues['@R_TGFID'];     // @P_TGFID int,
              stMvtInit.iTgfIdOri     := IBQue_Tmp.FieldByName('TGFID').AsInteger;     // @P_TGFIDORIGINE int,
              stMvtInit.sTgfNom    := IBQue_Tmp.FieldByName('TGFNOM').AsString;     // @P_TGFNOM VARCHAR(32),
              stMvtInit.iCouId     := Ps_CbArt.Parameters.ParamValues['@R_COUID'];     // @P_COUID int,
              stMvtInit.iCouIdOri     := IBQue_Tmp.FieldByName('COUID').AsInteger;     // @P_COUIDORIGINE int,
              stMvtInit.sCouNom    := IBQue_Tmp.FieldByName('COUNOM').AsString;     // @P_COUNOM VARCHAR(64),
              stMvtInit.sCouCode   := IBQue_Tmp.FieldByName('COUCODE').AsString;    // @P_COUCODE VARCHAR(64),
              stMvtInit.iQte       := IBQue_InitDtbTmp.FieldByName('HST_QTE').AsInteger;    // @P_MVTQTE int,
              stMvtInit.iKEnabled  := 1;                                                // @K_ENABLED int
              stMvtInit.fPump      := IBQue_Tmp.FieldByName('ARTPUMP').AsFloat;
              stMvtInit.fArtPump   := IBQue_Tmp.FieldByName('ARTPUMP').AsFloat;
              stMvtInit.dtModif    := ADateInit;

              if ((((aInit) and (stMvtInit.iKEnabled = 1))) or (not AInit)) then
                IF InsertMvt(stMvtInit, vSW) THEN
                begin
                  Inc(iNbArt)
                end
                else
                begin
                  // Traiter l'erreur
                  raise EMVTERROR.Create('Erreur sur mouvement ' + IntToStr(stMvtInit.iMvtId));
                end;
              {$ENDREGION}
            end;
          end;

          {$ENDREGION}

          IBQue_Tmp.Next;
        Except on E:Exception do
          raise Exception.Create('UpdateArticle - Erreur lors du traitement de la récupération des articles : ' + E.Message);
        end;
      end;
    end;
    DoProgress;

    iDeb := iFin + 1;
    if iDeb + 10000 < AKFin then
      iFin := iDeb + 10000
    else
      iFin := AKFin;
    if iDeb > AkFin then
      bFin := True;
  end;

  if AInit then
  begin
    LogAction('Mouvements OK, recup version' + IntToStr(iNbArt), logInfo);

    // LogAction('Mouvements OK, recup version' + inttostr(iNbArt), 1);

    InsertHisto(1, AMagId, 0, iOldKFin, 12, iNbArt, dtDebut, Now(), 'Initialisation');
    for i    := 1 to 11 do
      InsertHisto(1, AMagId, 0, iOldKFin, i, 0, dtDebut, Now(), 'Initialisation');

    InsertHisto(1, AMagId, 0, iOldKFin, 13, 0, dtDebut, Now(), 'Initialisation');  //SR - Ajout bon d'achat
    InsertHisto(1, AMagId, 0, iOldKFin, 14, 0, dtDebut, Now(), 'Initialisation');  //SR - Ajout Coupon
    LogAction('Histo OK', logInfo);
  end
  else begin
    // Sauvegarde du périmetre traité
    LogAction('Article OK, Recup Delta' + IntToStr(iNbArt), logInfo);
    InsertHisto(1, AMagId, AKDeb, AKFin, 12, iNbArt, dtDebut, Now(), 'Delta Article');
  end;
end;

procedure TDm_ExtractDatabase.ADODatabaseAfterConnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateDtb.Caption := 'DATABASE - Connecté à : ' + FURLSrv;
  Application.ProcessMessages;
end;

procedure TDm_ExtractDatabase.ADODatabaseAfterDisconnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateDtb.Caption := 'DATABASE - Déconnecté';
  Application.ProcessMessages;
end;

procedure TDm_ExtractDatabase.CloseProgress();
begin
  if FMainProgress <> Nil then
  begin
    FMainProgress.Position := 0;
    FMainProgress.Visible  := False;
    FArtProgress.Visible  := False;
  end;

  if Lab_State <> Nil then
  begin
    Lab_State.Caption := '';
    Lab_State.Visible := False;
  end;

  Application.ProcessMessages;
end;

//procedure TDm_ExtractDatabase.CreerProcedure(AProcName: string);
//var
//  sPathFile: string; // Chemin vers le fichier à charger
//begin
//  // Les procédures à mettre à jour doivent se trouver dans le dossier de l'exe
//  // nommées NomDeLaProc.sql
//  sPathFile := ExtractFilePath(Application.ExeName) + AProcName + '.sql';
//
//  try
//    IbT_Ginkoia.StartTransaction;
//    IbSql_MajProc.SQL.LoadFromFile(sPathFile);
//    IbSql_MajProc.ExecQuery();
//    IbT_Ginkoia.Commit;
//  except
//    on E: Exception do
//    begin
//      LogAction('Création procédure impossible : ' + sPathFile, 0);
//      LogAction(E.Message, 4);
//      // Exception notée en info de débug
//      IbT_Ginkoia.RollBack;
//    end;
//  end;
//end;

{ TObjectAssignFouid }

procedure TObjectAssignFouid.Add(aGink_FOUID, aMySQL_FOUID: integer);
var
  i : integer;
begin
  SetLength(FFouId_Array, Count+1);
  FFouId_Array[Count-1].Gink_FOUID := aGink_FOUID;
  FFouId_Array[Count-1].MySQL_FOUID := aMySQL_FOUID;
end;

procedure TObjectAssignFouid.Clear;
begin
  SetLength(FFouId_Array, 0);
end;

function TObjectAssignFouid.Count: integer;
begin
  result := length(FFouId_Array);
end;

constructor TObjectAssignFouid.Create;
begin
  inherited Create;
  Clear;
end;

function TObjectAssignFouid.getValue(aGink_FOUID: integer): Integer;
var
  i : integer;
begin
  result := -1;
  for I := 0 to Count-1 do
  begin
    if FFouId_Array[i].Gink_FOUID = aGink_FOUID then
    begin
      result := FFouId_Array[i].MySQL_FOUID;
      Break;
    end;
  end;
end;

function TObjectAssignFouid.indexOf(aGink_FOUID: integer): Integer;
var
  i : integer;
begin
  result := -1;
  for I := 0 to Count-1 do
  begin
    if FFouId_Array[i].Gink_FOUID = aGink_FOUID then
    begin
      result := i;
      Break;
    end;
  end;
end;

end.

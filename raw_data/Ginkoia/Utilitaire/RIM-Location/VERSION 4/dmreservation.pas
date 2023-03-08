unit dmreservation;

interface

uses
  SysUtils,
  Classes,
  Main_DM,
  DB,
  ReservationType_Defs,
  StrUtils,
  IBCustomDataSet,
  IBQuery,
  xml_unit,
  IcXmlParser,
  dxmdaset,
  IB_Components,
//  IB_Access,
  IBODataset,
  IB_StoredProc,
  StdUtils,
  ReservationResStr,
  GinkoiaResStr,
  uLogfile,
  Variants,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  Windows,
  Forms,
  IniFiles,
  dbugintf,
  ReservationTypeSkiset_Defs;

//****************************************************************************************************************************************************
//****************************************************************************************************************************************************
//
//               ATTENTION : Toutes modification faite ici, concernant Skiset, devra être reporté dans la caisse (Skiset_DM.pas) !!!
//
//****************************************************************************************************************************************************
//****************************************************************************************************************************************************

type
  Tdm_reservation = class(TDataModule)
    MemD_Mail: TdxMemData;
    MemD_MailMailID: TIntegerField;
    MemD_MailMailSubject: TStringField;
    MemD_MailMailAttachName: TStringField;
    MemD_MailMailIdMag: TStringField;
    MemD_MailMailIdResa: TStringField;
    MemD_MailMailDate: TDateField;
    MemD_MailbTraiter: TBooleanField;
    MemD_MailbArchive: TBooleanField;
    MemD_MailbAnnulation: TBooleanField;
    MemD_MailbVoucher: TBooleanField;
    MemD_Rap: TdxMemData;
    MemD_RapCentrale: TStringField;
    MemD_Rapclient: TStringField;
    MemD_RapNum: TStringField;
    MemD_RapWeb: TStringField;
    MemD_Rapdeb: TDateField;
    MemD_Rapfin: TDateField;
    Que_TmpNoEvent: TIBOQuery;
    IbC_GetListCentrale: TIB_Cursor;
    IbC_GetCFGMail: TIB_Cursor;
    Que_ResaExist: TIBOQuery;
    Que_Pays: TIBOQuery;
    Que_Villes: TIBOQuery;
    Que_GenAdresse: TIBOQuery;
    Que_Client: TIBOQuery;
    Que_Tmp: TIBOQuery;
    IbStProc_Client: TIB_StoredProc;
    Que_GENIMPORT: TIBOQuery;
    Que_CltTo: TIBOQuery;
    Que_CodeBarre: TIBOQuery;
    IbStProc_Codebarre: TIB_StoredProc;
    Que_LOCCENTRALEOC: TIBOQuery;
    Que_LOCOCRELATION: TIBOQuery;
    Que_LOCTYPERELATION: TIBOQuery;
    Que_LOCPARAMELT: TIBOQuery;
    IbStProc_Chrono: TIB_StoredProc;
    Que_Resa: TIBOQuery;
    Que_resal: TIBOQuery;
    Que_Resasl: TIBOQuery;
    IbC_Prd: TIB_Cursor;
    IbC_Com: TIB_Cursor;
    Que_UpdResa: TIBOQuery;
    IbStProc_DeleteReservation: TIB_StoredProc;
    Que_IdentMagExist: TIBOQuery;
    LK_Rap: TwwLookupDialogRV;
    IbC_ListeResa: TIB_Cursor;
    Que_Session: TIBOQuery;
    Que_CreeSess: TIBOQuery;
    IbC_ModRegl: TIB_Cursor;
    IbStProc_CompteClient: TIB_StoredProc;
    Que_MajResa: TIBOQuery;
    Que_Civilite: TIBOQuery;
    Que_ClientTO: TIBOQuery;
    Que_ResaExistMulti: TIBOQuery;
    Que_TmpLoc: TIBOQuery;
    MemD_Mailscodeah: TStringField;
    Que_OffreMag: TIBOQuery;
    Que_OffreMagPRD_ID: TIntegerField;
    Que_OffreMagPRD_NOM: TStringField;
    Que_OffreMagPRD_COMID: TIntegerField;
    Que_TypeAssocie: TIBOQuery;
    Que_TypeAssocieTYC_ID: TIntegerField;
    Que_TypeAssocieTYC_COMID: TIntegerField;
    Que_TypeAssocieTYC_RAT: TFloatField;
    Que_TypeAssocieTCA_NOM: TStringField;
    Que_CategorieAssocie: TIBOQuery;
    Que_CategorieAssociePRL_ID: TIntegerField;
    Que_CategorieAssociePRL_TYCID: TIntegerField;
    Que_TmpLoc2: TIBOQuery;
    Que_CodeBarreFidelite: TIBOQuery;
    Que_CodeBarreFideliteExiste: TIBOQuery;
    Que_CreateOCRelation: TIBOQuery;
    procedure Que_LOCCENTRALEOCAfterPost(DataSet: TDataSet);
    procedure Que_LOCCENTRALEOCBeforeDelete(DataSet: TDataSet);
    procedure Que_LOCCENTRALEOCBeforeEdit(DataSet: TDataSet);
    procedure Que_LOCCENTRALEOCNewRecord(DataSet: TDataSet);
    procedure Que_LOCCENTRALEOCUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);

    procedure GenerikNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);

  private
    FPOSID: Integer;
    sPaiement: string;
    FModeVerif: Boolean;
    { Déclarations privées }
    function Luhn(const aCB : string): boolean;
    function GetComentResa(aMonXml : TmonXML; aReservationXml: TIcXMLElement): String;
    function GetComentResaLine(aMonXml : TmonXML; aESkieurXml: TIcXMLElement): String;

    function GetGenTypeMail(aModule: String): Integer;
    function CorrespondanceWithNewId(aOldId, aOption: integer): Integer;
    function CheckOffreExiste(aIdCentrale, aMtyId: Integer): Integer;

  public
    { Déclarations publiques }
    
    oLogfile : Tlogfile ;          

    // Délais entre deux essais en secondes
    DelaisEssais: Integer;

    //CVI - PRD_ID pour contrôle de validité de nomenclature (Type, Catégorie, CA)
    iPrdId : integer;

    // Pour le log
    cpt_trc  : integer;

    
    function GetListCentrale: TListGENTYPEMAIL;
    function GetMailCFG(MaCentrale: TGENTYPEMAIL): TCFGMAIL;

     // Fonction de traitement des réservations
    function CreateResa(MaCentrale : TGENTYPEMAIL) : Boolean;
   //fonction d'annulation des réservations
    function AnnulResa : Boolean;

    
    // Retourne l'id état des reservation
    function GetEtat(iWeb,iType : Integer) : Integer;
    // Retourne la valeur max lcp_id pour un paramètre
    function GetLocParam(sParam : String) : Integer;
    // Retourne les paramètres de la location pour le magasin
    function GetLocParamMag(iMagId : Int64) : TParamLoc;
    // Retourne le tarif de l'article
    function GetTarifLoc(const vParamLoc : TParamLoc; const iMtaId : Integer; const vLigneReservation : TLigneReservation; const iPrdId, iLocType, iIdClient : Integer) : Double;
    // retourne vrai si la reservation existe
    function IsReservationExist(sIdResa : String) : Boolean;
    function IsReservationExistMulti(sIdResa: String; iCptCentrale,iIdCentrale:integer): Boolean; //TWGS
    // Récupère l'ID d'une réservation
    function IsReservationUpdatable(const AIdResaWeb: string): Boolean;
    // Annule une réservation en mémoire
    function ReservationInMemory(AMemD : TdxMemData;AIdResa : string) : Boolean;
    // Retourne le imp_ginkoia d'un client
    function GetClientImpGin(IdClient : String) : Integer;
   // Retourne l'idClient en recherchant par l'email
    function GetClientByMail(sMail : String) : Integer;
    // Retourne l'Id Pays (Si le pays n'existe pas la fonction va le créer)
    function GetPaysId(sNomPays : String; iIdMag: Integer) : Integer;
    // Retourn l'id de la ville, (si la ville/cp n'existe pas, la fonction va les créer)
    function GetVilleId(sNomVille, sCP : String; iPayID : Integer) : integer;
    // Retourne l'ID de l'adresse (si elle n'existe pas, la fonction va la créer)
    function GetAddresseId(iAdrIdRecherche, iIdVille : Integer) : Integer;
    // Retourn le client ID d'un imp_ginkoia
    function GetClientID(iImpGin : integer) : integer;
    // Retourne l'ID client qui a été créé
    function CreateClient(vClient : TClient) : Integer;
    function UpdateVoucherClient(aId: Integer; const iDureeVO : Integer; const tDebutSejourVO, tDureeVODate : TDateTime): Boolean;
    function GetClientById(aId: Integer): TClient;
    function UpdateContactClient(aAdrId: Integer; aEMail, aPhone: string): Boolean;
    // retourne l'id magasin
    function GetMagId(iMtyid : Integer; sIdPresta : String) : Integer;
   // Retourne l'id d'une civilité (la fonction la créer si elle n'existe pas)
    function GetCiviliteId(const sNomCivilite : String) : integer;
    // Retourne l'idPro d'un TO (s'il n'existe pas il est créé
    function GetIdTO(const sNomTO : String; const IdMag : Integer) : integer;
    // retourne le Chrono (Procédure Stockée) client
    function GetChronoClient : String;
    // Retourne l'ID de l'article correspondant à l'offre centrale (web)
    function GetPrdId(OCC_MTYID, OCC_IDCENTRALE, RLO_OPTION : integer; var iLocType : Integer) : Integer;
    // Insert dans la table GENIMPORT des données
    function InsertGENIMPORT(iIMPGINKOIA, iIMPKTBID, iIMPNUM  : integer; sIMPREFSTR : String; iIMPREF : Integer) : Boolean;
    // Delete dans la table GENIMPORT des données
    function DeleteGENIMPORT(iIMPGINKOIA, iIMPKTBID, iIMPNUM  : integer) : Boolean;
    // Insert des données dans la tavle CLTMEMBREPRO
    function InsertCLTMEMBREPRO(iPRMCLTIDPRO, iPRMCLTIDPART: Integer) : Boolean;
    function InsertCLTMEMBREPRO_ENMIEUX(iPRMCLTIDPRO, iPRMCLTIDPART: Integer) : Boolean;
    // Insert code barre
    function InsertCodeBarre(iIdClient : Integer) : Boolean;
    // Insert code barre fidélité
    function InsertCodeBarreFidelite(iIdClient : Integer; sCBFidelite : String) : Boolean;
    // Retourne un code à barre (Procedure stockée)
    function GetCodeBarre : String;    
    // Retourne l'id de locparamelt
    function GetLocParamElt(Id : integer;sNom : String) : Integer;
    // Met à jours les données de la table CLTMEMBREPRO (s'il n'existe pas, la fonction le créera
    function UpdateCLTMEMBREPRO(iPRMCLTIDPRO, iPRMCLTIDPART: Integer) : Boolean;
    // Retourne le Chrono (Procédure Stockée) réservation
    function GetProcChrono : String;
    // Insert une nouvelle réservation
    function InsertReservation(iIdClient,iIdPro,iEtat,iPaiement,iMagId : Integer;sAccompte,sComment,sNum,sNoWeb,sRemise,sMontantPrev : String;dResaDebut,dResaFin : TDateTime;IdCentrale : Integer; arrhesCom, ArrehseAco, IdWeb : string; bComentRemise: Boolean = True) : Integer;
    // Inseère une ligne de reservation
    function InsertResaLigne(MaCentrale : TGENTYPEMAIL;iIdResa, iIdWeb, iResaCasque,iResaMulti,iResaGarantie,iPrId : Integer;sResaIdent, sResaRemise, sResaPrix, sComent : String;dResaDebut,dResaFin : TDateTime; bInterSport : Boolean = false; sISComent : String = ''; iAppelWS : Integer = -1; aCAMAgasin: Currency = 0) : Integer;
    // Insère une sous ligne de reservation
    function InsertResaSousLigne(iIdResaL,iTCAID,iLCEID : Integer) : integer;

    // fonction qui retourne la date d'insertion dans la table k d'une reservation
    function GetDateFromK(sIdResa : String) : TDateTime;


    // Retourne vrai si l'identifiant magasin existe
    function IsIdentMagExist (iMtyMulti, iMtyId : integer;sIdMag : String) : Boolean;


   // Vérification des OC des fichiers
    function CheckOC(MaCentrale : TGENTYPEMAIL) : Boolean;
    
    function IsOCParamExist(OCC_MTYID, OCC_IDCENTRALE, RLO_OPTION : integer) : Boolean;

    //CVI - Pour contrôle de validité de nomenclature (Type, Catégorie, CA)
    function CheckNomenclature(aPrdId : Integer) : String;

    // pour check des autorisations
    function GetPostReferantId : integer;
    function IsMagAutorisation(iMTYID,iMagId, iPosID : Integer) : Boolean;

    //SK7
    function CreateResaSki7(MaCentrale: TGENTYPEMAIL; ddate_debut,ddate_end:tdatetime; modeVerif: Boolean = false): Boolean;
    procedure CommitSki7;
    procedure MappingOffresSkimium(aNewMtyId: integer);

    // Conversion champ string en float
    function ConvertStrToFloat(const aValeur : String) : Double;

    property PosID : Integer read FPOSID write FPOSID;

  end;

var
  dm_reservation: Tdm_reservation;

implementation

uses
  main,
  ReservationSport2k_Defs,
  IdHTTP,        //SK7
  IdGlobal,
  dateutils,
  IdSSLOpenSSL,
  uJSON,
  ReservationSkiset_Defs,
  ReservationSkimium_Defs;

{$R *.dfm}



function TDm_reservation.GetListCentrale: TListGENTYPEMAIL;
var
  MonGTMail : TGENTYPEMAIL;
begin
  Result := TListGENTYPEMAIL.Create;
  Result.OwnsObjects := True;
  Try
    try
      IbC_GetListCentrale.Close;
      IbC_GetListCentrale.Open;
      while not IbC_GetListCentrale.EOF do
      begin
        MonGTMail := TGENTYPEMAIL.Create;
        MonGTMail.MTY_ID       := IbC_GetListCentrale.FieldByName('MTY_ID').AsInteger;
        MonGTMail.MTY_NOM      := IbC_GetListCentrale.FieldByName('MTY_NOM').AsString;
        MonGTMail.MTY_CLTIDPRO := IbC_GetListCentrale.FieldByName('MTY_CLTIDPRO').AsInteger;
        MonGTMail.MTY_MULTI    := IbC_GetListCentrale.FieldByName('MTY_MULTI').AsInteger;

        // Temporaire, il faudrat rajouter un champ dans la table afin de récupérer le code directement
        case AnsiIndexStr(MonGTMail.MTY_NOM,['RESERVATION TWINNER','RESERVATION INTERSPORT','RESERVATION SKIMIUM',
                                             'RESERVATION SPORT 2000','RESERVATION GENERIQUE - 1',
                                             'RESERVATION GENERIQUE - 2','RESERVATION GENERIQUE - 3',
                                             'RESERVATION GOSPORT','RESERVATION SKISET', 'RESERVATION NETSKI',
                                             'RESERVATION SKIMIUM API']) of
          0: MonGTMail.MTY_CODE := 'RTW'; // Twinner
          1: MonGTMail.MTY_CODE := 'RIS'; // Intersport
          2: MonGTMail.MTY_CODE := 'RSK'; // Skimium
          3: MonGTMail.MTY_CODE := 'R2K'; // sport 2000
          4: MonGTMail.MTY_CODE := 'RG1'; // générique 1
          5: MonGTMail.MTY_CODE := 'RG2'; // générique 2
          6: MonGTMail.MTY_CODE := 'RG3'; // Générique 3
          7: MonGTMail.MTY_CODE := 'RGS'; // GoSport
          8: MonGTMail.MTY_CODE := 'RS7'; // SkiSet
          9: MonGTMail.MTY_CODE := 'RNS'; // Netski
          10: MonGTMail.MTY_CODE := 'RSKAPI'; // Skimium API
        else
          MonGTMail.MTY_CODE := '';
        end;

        Result.Add(MonGTMail);
        IbC_GetListCentrale.Next;
      end;

    Except
      on E:Exception do Fmain.trclog('XErreur dans GetListCentrale : '+e.message);
    end;
  Finally
    IBC_Getlistcentrale.Close ;
  End;
end;



function TDm_Reservation.GetMailCFG(MaCentrale: TGENTYPEMAIL): TCFGMAIL;
begin
  try
    IbC_GetCFGMail.Close;
    IbC_GetCFGMail.ParamCheck := True;
    IbC_GetCFGMail.ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
    IbC_GetCFGMail.Open;

    if not IbC_GetCFGMail.EOF then
    begin
      Result.PBT_ADRPRINC  := IbC_GetCFGMail.FieldByName('PBT_ADRPRINC').AsString;
      Result.PBT_ADRARCH   := IbC_GetCFGMail.FieldByName('PBT_ADRARCH').AsString;
      Result.PBT_PASSW     := IbC_GetCFGMail.FieldByName('PBT_PASSW').AsString;
      Result.PBT_SERVEUR   := IbC_GetCFGMail.FieldByName('PBT_SERVEUR').AsString;
      Result.PBT_PORT      := IbC_GetCFGMail.FieldByName('PBT_PORT').AsInteger;
      Result.PBT_MTYID     := IbC_GetCFGMail.FieldByName('PBT_MTYID').AsInteger;
      Result.PBT_ARCHIVAGE := IbC_GetCFGMail.FieldByName('PBT_ARCHIVAGE').AsInteger;
      Result.PBT_SMTP      := IbC_GetCFGMail.FieldByName('PBT_SMTP').AsString;
      Result.PBT_PORTSMTP  := IbC_GetCFGMail.FieldByName('PBT_PORTSMTP').AsInteger;
    end
    else
    begin
      Result.PBT_ADRPRINC  := '';
      Result.PBT_ADRARCH   := '';
      Result.PBT_PASSW     := '';
      Result.PBT_SERVEUR   := '';
      Result.PBT_PORT      := 0;
      Result.PBT_MTYID     := 0;
      Result.PBT_ARCHIVAGE := 10;
      Result.PBT_SMTP      := '';
      Result.PBT_PORTSMTP  := 0;
    end;

  Except
    on E:Exception do Fmain.trclog('XErreur dans GetMailCFG : '+e.message);
  end;
end;


// ----------- Début API via WEBSERVICE ------------

function TDm_Reservation.CreateResaSki7(MaCentrale: TGENTYPEMAIL; ddate_debut,ddate_end:tdatetime; modeVerif: Boolean = false): Boolean;
var
  sURL, sCle, sUser :string;
  vMagasin : TMagasin;
  vListeMagasins : TListeMagasins;
  vListeResaMag : TReservations;
  bGestionOffesOK : Boolean;
  vParametrage : TParametrage;
  iCentrale: Integer;

begin
  Result := True;
  bGestionOffesOK := False;
  SetLength(vListeResaMag, 0);
  FModeVerif := modeVerif;

  cpt_trc:=10;
  
  try
    try
      {$REGION 'Paramétrage et mise en place avant traitement'}
      if not Assigned(main.vDiagnostic) then
        main.vDiagnostic.Create;
      main.vDiagnostic.Centrale := MaCentrale.MTY_NOM;

      // récupère le format date heure local
      GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);

      // On le modifie pour qu'il soit compatible avec le format demandé dans les fichiers
      FSetting.ShortDateFormat := 'YYYY-MM-DD';
      FSetting.ShortTimeFormat:='HH:NN:SS';
      FSetting.DateSeparator := '-';
      FSetting.TimeSeparator:=':';

      vParametrage := TParametrage.Create;
      // Etat pré payée
      vParametrage.Paiement := GetEtat(1,1);

      // Récupération des Id correspondant au reponse de question
      cpt_trc:=30;
      vParametrage.Taille   := GetLocParam('Taille');
      vParametrage.Poids    := GetLocParam('Poids');
      vParametrage.Pointure := GetLocParam('Pointure');
      cpt_trc:=40;
      {$ENDREGION}

      {$REGION 'Traitement des réservations'}

      //Récupération des paramètres (URL, Clé et User) d'accès au web service dans GENPARAM
      iCentrale := -1;
      
      if (MaCentrale.MTY_CODE = 'RS7') then   // Skiset
        iCentrale := 0
      else if (MaCentrale.MTY_CODE = 'RNS') then  // Netski
        iCentrale := 1
      else if (MaCentrale.MTY_CODE = 'RGS') then   // GoSport
        iCentrale := 2
      else if (MaCentrale.MTY_CODE = 'RSKAPI') then   // Skimium  API
        iCentrale := 3;
        
      GetParamWebService(iCentrale, sURL, sCle, sUser);

      vParametrage.URL := sURL;
      vParametrage.Cle := sCle;
      vParametrage.User := sUser;

      cpt_trc:=50;

      // Le web service n'a pas été configuré
      if vParametrage.URL = '' then
      begin
        Fmain.ologfile.Addtext(ParamsStr(RS_ERREUR_CFGWEBSERVICE,MaCentrale.MTY_NOM));
        Fmain.Showmessagers(ParamsStr(RS_ERREUR_CFGWEBSERVICE,MaCentrale.MTY_NOM), RS_TXT_RESCMN_ERREUR);
        Fmain.trclog('T'+ParamsStr(RS_ERREUR_CFGWEBSERVICE_TRC,MaCentrale.MTY_NOM));
//        Fmain.trclog('Q-');   // Q : ne pas afficher la fenêtre de diagnostic

        Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

        Exit;
      end;

      // Récupération et gestion des offres
      bGestionOffesOK := GestionOffresSKISET(MaCentrale, vParametrage.URL, vParametrage.Cle, vParametrage.User);
      cpt_trc:=60;

      if bGestionOffesOK then
      begin
        // Récupération de la liste des magasins à traiter
        vListeMagasins := GetListeMagasins(MaCentrale);
        if vListeMagasins.Count = 0 then
        begin
          Fmain.trclog('T> Aucun magasin à traiter, traitement abandonné');
//          Fmain.trclog('Q-'); //pour forcer à ne pas afficher la fenêtre de diagnostic
          Exit;
        end;
        cpt_trc:=70;
        Fmain.ResetGauge ;
        Fmain.InitGauge(StringReplace(RS_TXT_RESADM_RESAINPROGRESS,'§0',MaCentrale.MTY_NOM,[rfReplaceAll]), vListeMagasins.Count + 1);


        // Gestion des réservations par magasin
        GestionReservationsParMag(MaCentrale, ddate_debut, ddate_end, vListeMagasins, vParametrage, FModeVerif);
      end
      else
      begin
        // Erreur dans la gestion des offres (récupération offres centrales, mise à jour ou création)
        if main.bcreation_oc and (not main.bcreation_init_oc) then
          FMain.trclog('ACréation d''OC complémentaires')
        else
          FMain.trclog('TLe traitement des offres centrales s''est mal déroulé, pas d''intégration possible.');
      end;

      cpt_trc:=90;
      Fmain.Refresh;
      Fmain.UpdateGauge;

      Fmain.trclog('T');
      Fmain.trclog('TFin traitement des réservations');
      Fmain.trclog('TTotal de réservations : ' + InttoStr(main.cpt_total));
      Fmain.trclog('T');
      {$ENDREGION}

    except
      on E: Exception do
      begin
        {$IFDEF DEBUG}
        OutputDebugString(pchar('Exception réservation : '+E.ClassName+':'+E.Message));
        {$ENDIF}
        Fmain.trclog('XException réservation SkiSet (trace_id='+inttostr(cpt_trc)+'): '+E.ClassName+':'+E.Message);
      end;
    end;


  finally
    Fmain.ResetGauge ;

    //Libération des structures
    if Assigned(vMagasin) then
      FreeAndNil(vMagasin);

    if Assigned(vListeMagasins) then
    begin
      FreeAndNil(vListeMagasins);
    end;

    if Assigned(vParametrage) then
      FreeAndNil(vParametrage);
  end;

end;

// ----------- Fin pour API via WEBSERVICE ------------

function TDm_Reservation.CreateResa(MaCentrale: TGENTYPEMAIL): Boolean;
var
  MonXml : TmonXML;
  nReservationXml : TIcXMLElement;
  eDureeXml       : TIcXMLElement;
  eClientXml      : TIcXMLElement;
  eFactureXml     : TIcXMLElement;
  nSkieurArtXml   : TIcXMLElement;
  eSkieurArtXml   : TIcXMLElement;
  eSkieurXML      : TIcXMLElement;
  eArticleXml     : TIcXMLElement;
  OldDateFormat   : String;
  dDateDebut, dDateFin,
  dDateResa,dDateResaDebut,
  dDateResaFin    : TDateTime;
  iNbJours        : integer;
  iImpGinKoia     : integer;

  iIdPays         : Integer;
  iIdVille        : Integer;
  iIdClient       : Integer;
  iIdPro          : Integer;
  iMagId          : Integer;
  iEtat           : Integer;
  iPaiment        : Integer;
  iIdResa         : integer;
  iIdResaligne    : Integer;
  FlagInsert      : Boolean;
  sCasque,sMulti,
  sGarantie,sIdArt,
  sImpRefStr, sTemp: String;
  iTaille,iPoids,iPointure : Integer;
  iLceId          : Integer;
  sNumChrono      : String;
  FSetting        : TFormatSettings;
  iRLOOption      : Integer;
  sAcompte        : String;
  sCommentaireAdr : string;
  sOldCommentaireAdr : String;
  bComentRemise : Boolean;

  cpt_resa:integer; //compteur resa
  cpt_trc:integer; //PDB compteur de tracing
  bxmlresa_ok : boolean;

  //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
  sCheckNomenclature : String;
  // Nouvelles balises Skimium (2020/2021)
  sCommentaireResa, sComentFicheClient, sComentNewBalises: String;
  sComentResaLine: String;
  sTotalAvecRemise: String;

  label gtResa_Next;

begin
  Fmain.trclog('TDébut de la procedure CreateResa');

  try
  try

    Result := True;
    MonXml := TmonXML.Create;

    // récupère le format date heure local
    GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);
    // On le modifie pour qu'il soit compatible avec le format demandé dans les fichiers
    FSetting.ShortDateFormat := 'YYYY-MM-DD';
    FSetting.DateSeparator := '-';


    iEtat := GetEtat(1,0);
    // Etat pré payée
    iPaiment := GetEtat(1,1);

    iTaille   := GetLocParam('Taille');
    iPoids    := GetLocParam('Poids');
    iPointure := GetLocParam('Pointure');

    with MemD_Mail do
    begin
      First;
      // ' : Traitement des réservations en cours ...'
      //InitGaugeMessHP(ParamsStr(RS_TXT_RESADM_RESAINPROGRESS,MaCentrale.MTY_NOM),RecordCount + 1,True,0,0,'',False);
      Fmain.InitGauge(StringReplace(RS_TXT_RESADM_RESAINPROGRESS,'§0',MaCentrale.MTY_NOM,[rfReplaceAll]), RecordCount + 1 );

      Fmain.trclog('TBoucle de parcours des réservations');

      if MemD_Mail.RecordCount=0 then begin
        if not berreur_codeadh then begin
          //Uniquement si pas d'erreur de code adhérent, sinon inutile.
          Fmain.trclog('AAucune réservation n''est disponible');
          inc(icptnoresa);
        end;
      end;

      cpt_resa:=0;
      while not EOF do
      begin
        {$IFDEF DEBUG}
        OutputDebugString(PChar(Format('Traitement de la réservation "%s". Fichier "%s".',
          [FieldByName('MailIdResa').AsString, FieldByName('MailAttachName').AsString])));
        {$ENDIF}
        inc(cpt_resa);
        Fmain.trclog('TRéservation n° '+inttostr(cpt_resa));
        cpt_trc:=0;

        // Initialisation
        bComentRemise := True;


        //Reset des infos client pour fenêtre de Diagnostic
        sClient_Id := '<Non disponible>';
        sClient_Nom := '<Non disponible>';
        sClient_Prenom := '';
        sClient_Email := '';


        try
          try
            Fmain.trclog('T  Chargement du fichier xml "'+FieldByName('MailAttachName').AsString+'"');

            // chargement du fichier xml
            bxmlresa_ok :=true;
            try
              MonXml.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
            Except
              on E:Exception do begin
                Fmain.trclog('XErreur XML résa : '+e.message);
                bxmlresa_ok := false;
                MemD_Mail.Edit;
                MemD_Mail.FieldByName('bArchive').AsBoolean := False;
                MemD_Mail.Post;
              end;
            end;
            cpt_trc:=10;

            //XML valide
            if bxmlresa_ok then begin

              // Si bTraiter n'est pas flaggé à vrai c'est que la pièce jointe n'était pas valide
              // On vérifie que la réservation n'a pas été déja traité juste avant
              Fmain.trclog('T  ID Resa '+FieldByName('MailIdResa').AsString);

              //if (FieldByName('bTraiter').AsBoolean) and not (IsReservationExist(FieldByName('MailIdResa').AsString)) then
              //TWGS
              if (FieldByName('bTraiter').AsBoolean) then
              begin

                if not (IsReservationExistMulti(FieldByName('MailIdResa').AsString,cpt_centrale,MaCentrale.MTY_ID) ) then
                begin
                  cpt_trc:=20;
                  Fmain.trclog('T  Réservation à traiter car n''existe pas déjà');
                  {$IFDEF DEBUG}
                  OutputDebugString(' - La réservation est à traiter et n''existe pas déjà.');
                  {$ENDIF}
                  MemD_Rap.Append;
                  MemD_Rap.FieldByName('Centrale').AsString := MaCentrale.MTY_NOM;

                  cpt_trc:=30;
                  Fmain.trclog('T  Récupération des dates');
                  // récupération des dates
                  nReservationXml := MonXml.find('/fiche/reservation');

                  if not assigned(nReservationXml) then begin
                    Fmain.trclog('EL''XML ne contient pas de section "reservation"');
                    goto gtResa_Next;
                  end;

                  eDureeXml := MonXml.FindTag(nReservationXml,'dates_duree');

                  if not assigned(eDureeXml) then begin
                    Fmain.trclog('EL''XML ne contient pas de section "dates_duree"');
                    goto gtResa_Next;
                  end;

                  cpt_trc:=40;

                  //PDB - Nouveau
                  bxmlresa_ok :=true;
                  if assigned(MonXml.FindTag(eDureeXml,'date_debut')) then begin
                    try
                      dDateDebut := StrToDate(MonXml.ValueTag (eDureeXml, 'date_debut'),FSetting);
                      dDateResa  := StrToDate(MonXml.ValueTag (eDureeXml, 'date_reservation'),FSetting);
                    except
                      on E:Exception do begin
                        Fmain.trclog('EErreur sur traitement "date_debut" et/ou "date_reservation"');
                        bxmlresa_ok :=false;
                      end;
                    end;

                  end
                  // Rustine pour les fichiers de Skimium qui ont des s en trop pour date(s)_xxxx
                  else if assigned(MonXml.FindTag(eDureeXml,'dates_debut')) then begin
                    try
                      dDateDebut := StrToDate(MonXml.ValueTag (eDureeXml, 'dates_debut'),FSetting);
                      dDateResa  := StrToDate(MonXml.ValueTag (eDureeXml, 'dates_reservation'),FSetting);
                    except
                      on E:Exception do begin
                        Fmain.trclog('EErreur sur traitement "dates_debut" et/ou "dates_reservation"');
                        bxmlresa_ok :=false;
                      end;
                    end;
                  end
                  //Pas de date spécifiée
                  else begin
                    Fmain.trclog('EPas de "dates_debut" et/ou "dates_reservation" spécifiées dans l''XML');
                    bxmlresa_ok :=false;
                  end;
                  if not bxmlresa_ok then goto gtResa_Next;

                  cpt_trc:=50;
                  bxmlresa_ok :=true;
                  if assigned(MonXml.FindTag(eDureeXml,'nb_jours')) then begin
                    iNbJours   := StrToIntDef(MonXml.ValueTag (eDureeXml, 'nb_jours'),0);
                    dDateFin   := dDateDebut + iNbJours -1;
                    //PDB - On refuse si la valeur est 0 (ou n'existe pas)
                    if iNbJours=0 then
                    begin
                      Fmain.trclog('EPas de "nb_jours" spécifiée dans l''XML');
                      bxmlresa_ok :=false;
                    end;
                    
                  end
                  else begin
                    Fmain.trclog('EPas de "nb_jours" spécifiée dans l''XML');
                    bxmlresa_ok :=false;
                  end;
                  if not bxmlresa_ok then goto gtResa_Next;

                  cpt_trc:=60;
                  Fmain.trclog('T  Récupération du client');

                  // Récupération des données clients

                  eClientXml := MonXml.FindTag(nReservationXml,'client');
                  if not assigned(eClientXml) then begin
                    Fmain.trclog('EL''XML ne contient pas de section "client"');
                    goto gtResa_Next;
                  end;

                  // On complète les variables déclarées dans Main
                  main.sClient_Id := trim(MonXml.ValueTag(eClientXml, 'id'));
                  main.sClient_Nom := trim(MonXml.ValueTag(eClientXml, 'nom'));
                  main.sClient_Prenom := trim(MonXml.ValueTag(eClientXml, 'prenom'));
                  main.sClient_Email := trim(MonXml.ValueTag(eClientXml, 'email'));

                  Fmain.trclog('TContrôle de la présence du Nom + id ou email du client');
                  bxmlresa_ok :=true;
                  if main.sClient_Nom='' then begin
                    Fmain.trclog('EPas de nom de client renseigné dans l''XML ("nom"). Abandon de l''intégration de la résa');
                    bxmlresa_ok :=false;
                  end;
                  //PDB - En plus du nom, il faut au moins soit l'ID soit l'EMAIL
                  if main.sClient_Id='' then begin
                    Fmain.trclog('TPas d''id client renseigné dans l''XML ("id")');
                  end;
                  if main.sClient_Email='' then begin
                    Fmain.trclog('TPas d''email client renseigné dans l''XML ("email")');
                  end;
                  //PDB - Si les deux sont absents on abandonne
                  if (main.sClient_Id='') and (main.sClient_Email='') then begin
                    Fmain.trclog('ELe client n''a pas d''ID et pas d''email. Abandon de l''intégration de la résa');
                    bxmlresa_ok :=false;
                  end;

                  if not bxmlresa_ok then goto gtResa_Next;


                  cpt_trc:=70;
                  // S'il ne s'agit pas, pour Sport 2000, d'un client Voucher
                  if not(SameText(MaCentrale.MTY_NOM, CSPORT2K)
                    and MemD_Mail.FieldByName('bVoucher').AsBoolean) then
                  begin
                    cpt_trc:=80;
                    {$IFDEF DEBUG}
                    OutputDebugString(' - Le client est Voucher pour Sport 2000.');
                    {$ENDIF}
                    cpt_trc:=90;
                    if (MonXml.ValueTag(eClientXml,'id') <> '0')
                      and (MonXml.ValueTag(eClientXml,'id') <> '') then
                      iImpGinKoia := GetClientImpGin(MonXml.ValueTag(eClientXml, 'id'))
                    else
                      iImpGinKoia := GetClientByMail(MonXml.ValueTag(eClientXml, 'email'));
                    cpt_trc:=100;

                  end
                  else begin
                    cpt_trc:=110;
                    {$IFDEF DEBUG}
                    OutputDebugString(' - Le client n''est pas Voucher pour Sport 2000.');
                    {$ENDIF}
                    iImpGinKoia := -1;
                  end;

                  cpt_trc:=120;

                  FlagInsert := (iImpGinKoia = -1);
                  Fmain.trclog('T  Récupération du pays+ville');
                  // Récupèration/création de l'id_pays
                  iMagId := GetMagId(MaCentrale.MTY_ID,MemD_Mail.FieldByName('MailIdMag').AsString);
                  iIdPays := GetPaysId(MonXml.ValueTag (eClientXml, 'pays'), iMagId);
                  // récupération/Création de l'id_ville
                  iIdVille := GetVilleId(MonXml.ValueTag (eClientXml, 'ville'),MonXml.ValueTag(eClientXml, 'code_postal'),iIdPays);
                  cpt_trc:=130;
                  With Que_GenAdresse do
                  begin
                    if not Active then
                    begin
                      Close;
                      // Juste pour qu'il y ai un paramètre pour l'ouverture de la requete
                      ParamByName('adrid').AsInteger := -1;
                      Open;
                    end;

                    cpt_trc:=140;
                    if FlagInsert then
                    begin
                      cpt_trc:=150;
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Création de l''adresse du client.');
                      {$ENDIF}
                      Append();
                    end
                    else begin
                      cpt_trc:=160;
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Mise à jour de l''adresse du client.');
                      {$ENDIF}
                      iIdClient := GetClientID(iImpGinKoia);
                      cpt_trc:=170;
                      if iIdClient = -1 then
                        FlagInsert := True // ne devrait pas se produire  //PDB - Bizarre, en fonction du trc 70,80,90
                      else begin
                        cpt_trc:=180;
                        Close;
                        ParamCheck := True;
                        ParamByName('adrid').AsInteger := Que_Client.FieldByName('CLT_ADRID').AsInteger;
                        Open;
                        if RecordCount = 0 then
                        begin
                          FlagInsert := True;
                          Append;
                        end else
                          Edit;
                      end;
                      cpt_trc:=190;
                    end; // else

                    cpt_trc:=200;
                    FieldByName('ADR_LIGNE').asstring := uppercase (MonXml.ValueTag (eClientXml, 'adresse') ) ;
                    FieldByName('ADR_VILID').asinteger := iIdVille;
                    FieldByName('ADR_TEL').asstring := MonXml.ValueTag (eClientXml, 'telephone') ;
                    FieldByName('ADR_FAX').asstring := '';
                    FieldByName('ADR_EMAIL').asstring := MonXml.ValueTag (eClientXml, 'email') ;
                    cpt_trc:=210;
                    Post;
                  end; // with
                  cpt_trc:=220;


                  With Que_Client do
                  begin
                    if not Active then
                    begin
                      cpt_trc:=230;
                      Close;
                      // Juste pour qu'il y ai un paramètre pour l'ouverture de la requete
                      ParamByName('cltid').asInteger := -1;
                      Open;
                    end;

                    cpt_trc:=240;
                    if FlagInsert then
                    begin
                      cpt_trc:=250;
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Création du client.');
                      {$ENDIF}
                      Append();
                    end
                    else begin
                      cpt_trc:=260;
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Mise à jour du client.');
                      {$ENDIF}
                      Edit();
                    end;
                    cpt_trc:=270;
                    iMagId := GetMagId(MaCentrale.MTY_ID,MemD_Mail.FieldByName('MailIdMag').AsString);
                    FieldByName('CLT_NOM').asstring := Trim(UpperCase (MonXml.ValueTag (eClientXml, 'nom')));
                    FieldByName('CLT_PRENOM').asstring := Trim(UpperCase (MonXml.ValueTag (eClientXml, 'prenom')));
                    FieldByName('CLT_ADRID').asinteger := Que_GenAdresse.FieldByName('ADR_ID').asinteger;
                    FieldByname ('clt_magid') .asinteger := iMagId;
                    cpt_trc:=280;

                    IF MonXml.ValueTag (eClientXml, 'civilite') <> '' THEN
                    BEGIN
                      cpt_trc:=290;
                      FieldByname ('CLT_CIVID').asinteger := GetCiviliteId(MonXml.ValueTag (eClientXml, 'civilite'));
                    END;

                    cpt_trc:=300;
                    IF MonXml.ValueTag (eClientXml, 'date_naissance') <> '' THEN
                    BEGIN
                      cpt_trc:=310;
                      FieldByname ('CLT_NAISSANCE').asdatetime := StrToDate(MonXml.ValueTag (eClientXml, 'date_naissance'),FSetting);
                    END;

                    // Si réservation SKIMIUM
                    if SameText(MaCentrale.MTY_NOM, CSKIMIUM) then
                    begin
                      // Evolutions Skimium saison 2021-2022
                      // Ajout d'un Voucher pour le client
                      cpt_trc:=3101;
                      FieldByname('CLT_DUREEVO').asinteger := iNbJours;            // Nb de jour de location
                      FieldByname('CLT_DEBUTSEJOURVO').asdatetime := dDateDebut;   // Date de début de la résa
                      FieldByname('CLT_DUREEVODATE').asdatetime := dDateFin;       // Date de fin de la résa
                    end;

                    cpt_trc:=320;
                    Post;
                    cpt_trc:=330;
                    iIdClient := FieldByName('CLT_ID').AsInteger;
                    Memd_Rap.FieldByName('Client').AsString := FieldByName('CLT_NOM').asstring + ' ' + FieldByName('CLT_PRENOM').asstring;
                    cpt_trc:=340;
                  End; // with

                  cpt_trc:=350;
                  // Gestion du TO
                  if MonXml.ValueTag(nReservationXml,'nom_TO') <> '' then
                  begin
                    iIdPro := GetIdTO(MonXml.ValueTag(nReservationXml,'nom_TO'),iMagId);
                    cpt_trc:=360;
                  end
                  else begin
                    cpt_trc:=370;
                    iIdPro := MaCentrale.MTY_CLTIDPRO;//  GetIdPro;
                  end;

                  cpt_trc:=380;
                  IF Flaginsert THEN
                  BEGIN
                    cpt_trc:=390;
                    // S'il ne s'agit pas, pour Sport 2000, d'un client Voucher
                    if not(SameText(MaCentrale.MTY_NOM, CSPORT2K)
                      and MemD_Mail.FieldByName('bVoucher').AsBoolean) then
                    begin
                      cpt_trc:=400;
                      Fmain.trclog('T  Liaison du client avec GenImport');
                      {$IFDEF DEBUG}
                      OutputDebugString(PChar(Format(' - Liaison du client avec GENIMPORT. IdClient = %d', [iIdClient])));
                      {$ENDIF}
                      //Lien avec genimport
                      //TWGS
                      //if cpt_centrale>1 then
                        InsertGENIMPORT(iIdClient,-11111401,5,MonXml.ValueTag(eClientXml,'id'),MaCentrale.MTY_ID);
                      //else
                      //  InsertGENIMPORT(iIdClient,-11111401,5,MonXml.ValueTag(eClientXml,'id'),0);
                      cpt_trc:=410;
                    end;
                    cpt_trc:=420;
                    iImpGinKoia := StrToIntDef(MonXml.ValueTag(eClientXml,'id'),-1);

                    cpt_trc:=430;
                    //Lien avec TO
                    {$IFDEF DEBUG}
                    OutputDebugString(PChar(Format(' - Liaison du client avec TO. IdClient = %d - IdPro = %d', [iIdClient, iIdPro])));
                    {$ENDIF}
                    InsertCLTMEMBREPRO(iIdPro,iIdClient);
                    cpt_trc:=440;

                    Fmain.trclog('T  Création du code-barre client');
                    //Codebarre client
                    {$IFDEF DEBUG}
                    OutputDebugString(PChar(Format(' - Création du code-barres client. IdClient = %d', [iIdClient])));
                    {$ENDIF}
                    InsertCodeBarre(iIdClient);
                    cpt_trc:=450;
                  End
                  else begin
                    cpt_trc:=460;
                    //Lien avec TO
                    {$IFDEF DEBUG}
                    OutputDebugString(PChar(Format(' - Mise à jour de la liaison du client avec TO. IdClient = %d - IdPro = %d', [iIdClient, iIdPro])));
                    {$ENDIF}
                    UpdateCLTMEMBREPRO(iIdPro,iIdClient);
                    cpt_trc:=470;
                  end;

                  cpt_trc:=480;
                  eFactureXml := MonXml.FindTag (nReservationXml, 'facture');
                  cpt_trc:=490;

                  // Gestion du Voucher
                  if FieldByName('bVoucher').AsBoolean then
                    sAcompte := MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise')
                  else
                    sAcompte := MonXml.ValueTag(eFactureXml,'arrhes');

                  // Si réservation SKIMIUM
                  if SameText(MaCentrale.MTY_NOM, CSKIMIUM) then
                  begin
                    // Evolutions SKIMIUM saison 2021-2022
                    if assigned(MonXml.FindTag(nReservationXml,'paiement')) then
                    begin
                      sPaiement := MonXml.ValueTag(nReservationXml,'paiement');
                      if (StrToFloatDef(sPaiement,0.00) = 100.00) then
                      begin
                        // Si paiement à 100%, on ne tient pas compte de l'acompte
                        sAcompte := '0';
                        bComentRemise := False; // On n'affiche pas la remise dans le commentaire de l'entête de résa
                      end;
                    end;
                  end;

                  cpt_trc:=500;

                  // Gestion nouvelles balises skimium
                  sCommentaireResa := GetComentResa(MonXml, nReservationXml);
                  if sCommentaireResa = '' then
                    sCommentaireResa := MonXml.ValueTag(nReservationXml,'numero')
                  else
                    sCommentaireResa := sCommentaireResa + sLineBreak + MonXml.ValueTag(nReservationXml,'numero');

                  cpt_trc:=501;
                  sNumChrono := GetProcChrono;
                  Fmain.trclog('T  Récupération du chrono '+snumchrono);
                  //Entete de la reservation
                  Fmain.trclog('T  Création de l''entête de réservation');
                  {$IFDEF DEBUG}
                  OutputDebugString(' - Création de l''en-tête de la réservation.');
                  {$ENDIF}
                  cpt_trc:=510;

                  sTotalAvecRemise := MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise');
                  if Assigned(MonXml.FindTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise_services')) then
                    sTotalAvecRemise := MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise_services');

                  iIdResa := InsertReservation(
                                    iIdClient,
                                    iIdPro,
                                    iEtat,
                                    iPaiment,
                                    iMagId,
                                    sAcompte,
                                    sCommentaireResa,
                                    sNumChrono,
                                    MonXml.ValueTag(nReservationXml,'numero'),
                                    MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'),'remise'),
                                    sTotalAvecRemise,
                                    dDateDebut,
                                    dDateFin,
                                    MaCentrale.MTY_ID,
                                    MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission'),
                                    MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission'),
                                    '',
                                    bComentRemise
                                    );
                  cpt_trc:=520;
                  MemD_Rap.FieldByName('Num').AsString := sNumChrono;
                  MemD_Rap.FieldByName('Web').AsString := MonXml.ValueTag(nReservationXml,'numero');

                  cpt_trc:=530;
                  Fmain.trclog('T  Création du lien avec GenImport');
                  {$IFDEF DEBUG}
                  OutputDebugString(PChar(Format(' - Lien avec GENIMPORT. IdResa = %d - NumChrono = %s.', [iIdResa, sNumChrono])));
                  {$ENDIF}
                  //Lien avec genimport
                  Fmain.trclog('T  MailIdResa='+MemD_Mail.FieldByName('MailIdResa').AsString);
                  //TWGS
                  //if cpt_centrale>1 then
                    InsertGENIMPORT(iIdResa  ,-11111512,5,MemD_Mail.FieldByName('MailIdResa').AsString,MaCentrale.MTY_ID);
                  //else
                  //  InsertGENIMPORT(iIdResa,-11111512,5,MemD_Mail.FieldByName('MailIdResa').AsString,0);
        //          InsertGENIMPORT(iIdResa,-11111512,5,MonXml.ValueTag(nReservationXml,'numero'),0);

                  cpt_trc:=540;
                  nSkieurArtXml := MonXml.FindTag(nReservationXml,'skieurs_articles');
                  eSkieurArtXml := MonXml.FindTag(nSkieurArtXml, 'skieur_article');

                  Fmain.trclog('T  Création des articles');
                  cpt_trc:=550;
                  while (eSkieurArtXml <> nil) do
                  begin
                    cpt_trc:=560;
                    eArticleXml := MonXml.FindTag(eSkieurArtXml,'article');
                    eSkieurXML  := MonXml.FindTag(eSkieurArtXml,'skieur');

                    cpt_trc:=570;
                    IF MonXml.ValueTag(eArticleXml{eSkieurArtXml},'date_debut') <> '' THEN
                    begin
                      dDateResaDebut := StrToDate(MonXml.ValueTag(eArticleXml{eSkieurArtXml},'date_debut'),FSetting);
                    end else
                      dDateResaDebut := dDateDebut;

                    cpt_trc:=580;
                    if MonXml.ValueTag(eArticleXml{eSkieurArtXml},'date_fin') <> '' then
                    begin
                      dDateResaFin := StrToDate(MonXml.ValueTag (eArticleXml{eSkieurArtXml},'date_fin'),FSetting);
                    end else
                      dDateResaFin := dDateFin;

                    cpt_trc:=590;
                    sCasque   := eArticleXml.getAttribute('avec_casque');
                    sMulti    := eArticleXml.getAttribute('multiglisse');
                    if sMulti = '' then  // ce n'est pas multiglisse Twinner
                      sMulti := eArticleXml.getAttribute('avec_GL');   // Glisse liberté Skimium
                    sGarantie := eArticleXml.getAttribute('garantie_vol_casse');
                    sIdArt    := MonXml.ValueTag(eArticleXml,('id_article'));
                    cpt_trc:=600;

                    if eArticleXml.getAttribute('avec_chaussure') = '0' then
                    begin
                      cpt_trc:=610;
                      if sCasque = '0' then
                        iRLOOption := 1  // Offre seule
                      else
                        iRLOOption := 3; // Offre seule + Casque
                    end
                    else begin
                      cpt_trc:=620;
                      if sCasque = '0' then
                        iRLOOption := 2  // Offre avec chaussures
                      else
                       iRLOOption := 4;  // Offre avec chaussures + Casque
                    end;

                    cpt_trc:=630;
                    IF not IsOCParamExist(MaCentrale.MTY_ID,StrToIntDef(sIdArt,-1),iRLOOption) THEN
                    BEGIN // La relation est manquante
                        cpt_trc:=640;
                        {
                        //              MaCentrale.MTY_NOM +  ' : Intégration interrompue, le paramétrage' + #13#10 + 'des offres commerciales est incomplet...' + #13#10 +
        //              'Réservation : ' + MemD_Mail.FieldByName('MailIdResa').AsString + #13#10 +
        //              'Offre : ' +  MonXml.ValueTag(eArticleXml,('nom'))
          (*            InfoMessHP (ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))]))
                                  ,True,0,0,RS_TXT_RESCMN_ERREUR);     * )

                         Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])),
                           RS_TXT_RESCMN_ERREUR) ;

                       // Non... Fmain.ologfile.Addtext(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));
                       //....On force via le tracing comme si c'était une exception pour augmenter le comptage et obliger l'affichage du log
                       Fmain.trclog('T'+ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));
                       Fmain.trclog('Q-');


                       Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

                      Result := false;
                      MemD_Rap.Cancel;
                      EXIT;
                      }

                      //Fmain.trclog('FLe paramétrage des offres commerciales est incomplet :'+MonXml.ValueTag(eArticleXml,('nom')));
                      Fmain.trclog('FLa relation avec l''OC est manquante :'+MonXml.ValueTag(eArticleXml,('nom')));

                      goto gtResa_Next;


                    END;


                    //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
                    Fmain.trclog('TCVI : contrôle nomenclature avec PrdId='+inttostr(iPrdId));
                    sCheckNomenclature := CheckNomenclature(iPrdId);
                    if sCheckNomenclature <> '' then
                    begin
                      Fmain.trclog('F'+sCheckNomenclature);
                      goto gtResa_Next;
                    end;

                    cpt_trc:=650;
                    Fmain.trclog('T  Création de la ligne de réservation');
                    {$IFDEF DEBUG}
                    OutputDebugString(PChar(Format(' - Création de la ligne de réservation. IdResa = %d - prenom = %s.', [iIdResa, MonXml.ValueTag(eSkieurXML, 'prenom')])));
                    {$ENDIF}

                    sComentResaLine := GetComentResaLine(MonXml, eSkieurXML);

                    iIdResaligne := InsertResaLigne(MaCentrale,
                                    iIdResa,
                                    0,
                                    StrToIntDef(sCasque,0),
                                    StrToIntDef(sMulti,0),
                                    StrToIntDef(sGarantie,0),
                                    Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger, // Ouvert lors de l'exécution de IsOCParamExist
                                    MonXml.ValueTag(eSkieurXML, 'prenom'),
                                    MonXml.ValueTag(eArticleXml, 'remise'),
                                    MonXml.ValueTag(eArticleXml, 'prix'),
                                    sComentResaLine,
                                    dDateResaDebut,
                                    dDateResaFin
                                    );
                    cpt_trc:=660;
                    sTemp := '';
                    IF sCasque = '1' THEN sTemp := 'Casque';
                    IF sGarantie = '1' THEN
                    BEGIN
                      IF sTemp <> '' THEN
                        sTemp := sTemp + ' + Garantie'
                      ELSE
                        sTemp := 'Garantie';
                    END;
                    IF sMulti = '1' THEN
                    BEGIN
                      IF sTemp <> '' THEN
                        sTemp := sTemp + ' + Multi.'
                      ELSE
                        sTemp := 'Multi.';
                    END;

                    cpt_trc:=670;
                    With Que_GenAdresse do
                    begin
                      if not (sTemp = '') then
                      begin
                        Edit;
                        FieldByName('ADR_COMMENT').AsString := copy ('   ' + uppercase (MonXml.ValueTag(eSkieurXML, 'prenom')) +
                                                                     ' : ' + sTemp + #13 + #10 +
                                                                     FieldByName('ADR_COMMENT').AsString, 1, 1024);
                        cpt_trc:=680;
                        Post;
                      end;
                    end;
                    cpt_trc:=690;

                    //Souslignes de resa
                 //   ibc_com.close;
                 //   ibc_com.parambyname ('prd_id') .asinteger := iImpGinKoia;
                //    ibc_com.open;

                    // On remet au debut la requete (Requete activé dans IsOcParamExist
                    Que_LOCOCRELATION.First;

                    WHILE NOT Que_LOCOCRELATION.eof DO
                    BEGIN
                      cpt_trc:=700;
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Création des lignes de réponses.');
                      {$ENDIF}

                      With Que_LOCTYPERELATION do
                      begin
                        Close;
                        ParamCheck := True;
                        ParamByName('PPrdID').AsInteger :=  Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger;
                        ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
                        Open;
                        cpt_trc:=710;

                        while not Que_LOCTYPERELATION.Eof do
        //                if RecordCount > 0 then
                        begin
                          cpt_trc:=720;
                          iLceId := 0;

                          if FieldByName('LTR_PTR').AsInteger = 1 then
                          begin
                            cpt_trc:=730;
                            iLceId := GetLocParamElt(iPointure,MonXml.ValueTag(eSkieurXML,'pointure'));

                            {$IFDEF DEBUG}
                            OutputDebugString(PChar(Format(' - Réponse "pointure". LceId = %d', [iLceId])));
                            {$ENDIF}

                            InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                            cpt_trc:=740;
                          end;

                          cpt_trc:=750;
                          if FieldByName('LTR_TAILLE').AsInteger = 1 then
                          begin
                            cpt_trc:=760;
                            iLceId := GetLocParamElt(iTaille,MonXml.ValueTag(eSkieurXML,'taille'));

                            {$IFDEF DEBUG}
                            OutputDebugString(PChar(Format(' - Réponse "taille". LceId = %d', [iLceId])));
                            {$ENDIF}

                            cpt_trc:=770;
                            InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                            cpt_trc:=780;
                          end;

                          if FieldByName('LTR_POIDS').asInteger = 1 then
                          begin
                            cpt_trc:=790;
                            ilceId := GetLocParamElt(iPoids,MonXml.ValueTag(eSkieurXML, 'poids'));

                            {$IFDEF DEBUG}
                            OutputDebugString(PChar(Format(' - Réponse "poids". LceId = %d', [iLceId])));
                            {$ENDIF}

                            cpt_trc:=800;
                            InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                            cpt_trc:=810;
                          end;

                          cpt_trc:=820;
                          // On insère une ligne sans valeur
                          if iLceId = 0 then
                          begin
                            cpt_trc:=830;
                            {$IFDEF DEBUG}
                            OutputDebugString(PChar(Format(' - Réponse sans valeur. LceId = %d', [iLceId])));
                            {$ENDIF}

                            InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,0);
                            cpt_trc:=840;
                          end;
                          cpt_trc:=850;
                          Que_LOCTYPERELATION.Next;
                        end;
                        cpt_trc:=860;
                        Que_LOCOCRELATION.Next;
                      end; //with
                    end; // while

                    cpt_trc:=870;
                    eSkieurArtXml := eSkieurArtXml.nextSibling;
                  end;

                  cpt_trc:=880;
                  Fmain.trclog('T  Mise à jour du commentaire client');
                  //mise à jour du commentaire client
                  With Que_GenAdresse do
                  begin
                    Edit;
                    cpt_trc:=890;

                    sComentNewBalises := GetComentResa(MonXml, nReservationXml);

                    sComentFicheClient := ('Réserv. du ' + FormatDateTime('DD/MM/YYYY',dDateDebut) +
                                                                 ' au ' + FormatDateTime('DD/MM/YYYY',dDateFin));

                    // Si pas réservation SKIMIUM
                    if not SameText(MaCentrale.MTY_NOM, CSKIMIUM) then
                    begin
                      sComentFicheClient := sComentFicheClient + sLineBreak +
                          ' Arrhes : ' + MonXml.ValueTag(eFactureXml,'arrhes') + '€' + #13 + #10 +
                          ' Commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission') +
                          ' arrhes moins la commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission');
                    end;

                    if sComentNewBalises <> '' then
                      sComentFicheClient := sComentFicheClient + sLineBreak + sComentNewBalises;

                    sComentFicheClient := sComentFicheClient + sLineBreak + FieldByName('ADR_COMMENT').AsString;

                    FieldByName('ADR_COMMENT').AsString := copy (sComentFicheClient, 1, 1024) ;
                    cpt_trc:=900;
                    Post;
                    cpt_trc:=910;
                  end;
                  cpt_trc:=920;

                  MemD_Rap.FieldByName('deb').AsDateTime := dDateDebut;
                  MemD_Rap.FieldByName('fin').AsDateTime := dDateFin;
                  cpt_trc:=930;
                  MemD_Rap.post;
                  cpt_trc:=940;

                  Fmain.trclog('T  Commit des caches');
                  TRY
                    Dm_Main.StartTransaction();
                    Dm_Main.IBOUpDateCache(Que_Pays);
                    Dm_Main.IBOUpDateCache(Que_Villes);
                    Dm_Main.IBOUpDateCache(Que_Civilite);
                    Dm_Main.IBOUpDateCache(Que_Client);
                    Dm_Main.IBOUpDateCache(Que_CltTo);
                    Dm_Main.IBOUpDateCache(Que_ClientTO);
                    Dm_Main.IBOUpDateCache(Que_GenAdresse);
                    Dm_Main.IBOUpDateCache(Que_CodeBarre);
                    Dm_Main.IBOUpDateCache(Que_Resa);
                    Dm_Main.IBOUpDateCache(Que_resal);
                    Dm_Main.IBOUpDateCache(Que_Resasl);
                    Dm_Main.IBOUpDateCache(Que_LOCPARAMELT);
                    Dm_Main.IBOUpDateCache(Que_GENIMPORT);
                    Dm_Main.IBOUpDateCache(Que_CreeSess);
                    Dm_Main.Commit();
                    cpt_trc:=950;
                    Fmain.trclog('RIntégration réussie');
                    inc(cpt_r);

                  EXCEPT
                    on e:exception do begin
                      Fmain.trclog('XException lors du commit des caches (id_trace='+inttostr(cpt_trc)+') : '+e.message);
                      Dm_Main.Rollback();
                      Dm_Main.IBOCancelCache(Que_Pays);
                      Dm_Main.IBOCancelCache(Que_Villes);
                      Dm_Main.IBOCancelCache(Que_Civilite);
                      Dm_Main.IBOCancelCache(Que_Client);
                      Dm_Main.IBOCancelCache(Que_CltTo);
                      Dm_Main.IBOCancelCache(Que_ClientTO);
                      Dm_Main.IBOCancelCache(Que_GenAdresse);
                      Dm_Main.IBOCancelCache(Que_CodeBarre);
                      Dm_Main.IBOCancelCache(Que_Resa);
                      Dm_Main.IBOCancelCache(Que_resal);
                      Dm_Main.IBOCancelCache(Que_Resasl);
                      Dm_Main.IBOCancelCache(Que_LOCPARAMELT);
                      Dm_Main.IBOCancelCache(Que_GENIMPORT);
                      Dm_Main.IBOCancelCache(Que_CreeSess);
                      raise;
                    end;
                  END;
                  cpt_trc:=970;
                  Dm_Main.IBOCommitCache(Que_Pays);
                  Dm_Main.IBOCommitCache(Que_Villes);
                  Dm_Main.IBOCommitCache(Que_Civilite);
                  Dm_Main.IBOCommitCache(Que_Client);
                  Dm_Main.IBOCommitCache(Que_CltTo);
                  Dm_Main.IBOCommitCache(Que_ClientTO);
                  Dm_Main.IBOCommitCache(Que_GenAdresse);
                  Dm_Main.IBOCommitCache(Que_CodeBarre);
                  Dm_Main.IBOCommitCache(Que_Resa);
                  Dm_Main.IBOCommitCache(Que_resal);
                  Dm_Main.IBOCommitCache(Que_Resasl);
                  Dm_Main.IBOCommitCache(Que_LOCPARAMELT);
                  Dm_Main.IBOCommitCache(Que_GENIMPORT);
                  Dm_Main.IBOCommitCache(Que_CreeSess);
                  cpt_trc:=980;

                end

                else if not(MemD_Mail.FieldByName('bTraiter').AsBoolean)
                  and SameText(MaCentrale.MTY_NOM, CSPORT2K)
                  and (MemD_Mail.FieldByName('bVoucher').AsBoolean
                    or (MonXml.ValueTag(MonXml.FindTag(MonXml.find('/fiche/reservation'), 'client'), 'id') = '')) then
                begin
                  Fmain.trclog('TLa réservation n''est pas à traiter. Mais est Sport 2000, et Voucher ou sans id client');
                  cpt_trc:=990;
                  {$IFDEF DEBUG}
                  OutputDebugString(' - La réservation n''est pas à traiter. Mais est Sport 2000, et Voucher ou sans id client.');
                  {$ENDIF}

                  // Récupération de la réservation
                  nReservationXml := MonXml.find('/fiche/reservation');
                  cpt_trc:=1000;
                  // Récupération des données clients
                  eClientXml := MonXml.FindTag(nReservationXml, 'client');

                  cpt_trc:=1010;
                  // Si la réservation existe déjà, mais qu'on est sur un client Voucher de la centrale Sport 2000
                  // ou un client d'une réservation express.
                  // Si la réservation est liée au client "générique" (présent dans GENIMPORT), alors on créer un nouveau client pour le lier à la réservation
                  if IsReservationUpdatable(FieldByName('MailIdResa').AsString) then
                  begin
                    cpt_trc:=1020;
                    {$IFDEF DEBUG}
                    OutputDebugString(' - La réservation peut être mise à jour.');
                    {$ENDIF}

                    if (MonXml.ValueTag(eClientXml, 'id') <> '') then
                      iImpGinKoia := GetClientImpGin(MonXml.ValueTag(eClientXml, 'id'))
                    else
                      iImpGinKoia := GetClientByMail(MonXml.ValueTag(eClientXml, 'email'));

                    cpt_trc:=1030;
                    if iImpGinKoia <> -1 then
                    begin
                      cpt_trc:=1040;
                      // Le client est générique, on récupère l'ID de la réservation
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Le client est générique, on récupère l''ID de la réservation.');
                      {$ENDIF}
                      try
                        if Que_ResaExist.Active then
                          Que_ResaExist.Close();

                        cpt_trc:=1050;
                        Que_ResaExist.ParamByName('IMPREF').AsString := MemD_Mail.FieldByName('MailIdResa').AsString;
                        Que_ResaExist.Open();

                        cpt_trc:=1060;
                        if not(Que_ResaExist.IsEmpty()) then
                          iIdResa := Que_ResaExist.FieldByName('IMP_GINKOIA').AsInteger
                        else
                          iIdResa := -1;
                        cpt_trc:=1070;
                      finally
                        Que_ResaExist.Close();
                      end;
                      cpt_trc:=1080;
                      // Si la réservation existe vraiment
                      if iIdResa <> -1 then
                      begin
                        cpt_trc:=1090;
                        {$IFDEF DEBUG}
                        OutputDebugString(PChar(Format(' - La réservation existe vraiment. IdResa = %d', [iIdResa])));
                        {$ENDIF}

                        if Que_MajResa.Active then
                          Que_MajResa.Close();

                        cpt_trc:=1100;
                        Que_MajResa.ParamByName('RVSID').AsInteger := iIdResa;
                        Que_MajResa.Open();

                        cpt_trc:=1110;
                        if not(Que_MajResa.IsEmpty()) then
                        begin
                          cpt_trc:=1120;
                          // Créer l'adresse du client, même si elle sera surement fausse
                          // Récupération / création de l'id_pays
                          iMagId := GetMagId(MaCentrale.MTY_ID, MemD_Mail.FieldByName('MailIdMag').AsString);
                          iIdPays := GetPaysId(MonXml.ValueTag(eClientXml, 'pays'), iMagId);

                          // Récupération / Création de l'id_ville
                          iIdVille := GetVilleId(MonXml.ValueTag(eClientXml, 'ville'), MonXml.ValueTag(eClientXml, 'code_postal'), iIdPays);

                          cpt_trc:=1130;
                          // Prépare le commentaire pour l'adresse
                          sCommentaireAdr := '';
                          nSkieurArtXml   := MonXml.FindTag(nReservationXml, 'skieurs_articles');
                          eSkieurArtXml   := MonXml.FindTag(nSkieurArtXml, 'skieur_article');
                          eArticleXml     := MonXml.FindTag(eSkieurArtXml, 'article');
                          eSkieurXML      := MonXml.FindTag(eSkieurArtXml, 'skieur');
                          cpt_trc:=1140;
                          while Assigned(eSkieurArtXml) do
                          begin
                            cpt_trc:=1150;
                            sCasque   := eArticleXml.getAttribute('avec_casque');
                            sMulti    := eArticleXml.getAttribute('multiglisse');
                            // Ce n'est pas multiglisse Twinner
                            if sMulti = '' then
                            begin
                              // Glisse liberté Skimium
                              sMulti := eArticleXml.getAttribute('avec_GL');
                            end;
                            sGarantie := eArticleXml.getAttribute('garantie_vol_casse');
                            cpt_trc:=1160;

                            sTemp := '';

                            if sCasque = '1' then
                              sTemp := 'Casque';

                            if sGarantie = '1' then
                            begin
                              if sTemp <> '' then
                                sTemp := sTemp + ' + Garantie'
                              else
                                sTemp := 'Garantie';
                            end;

                            if sMulti = '1' then
                            begin
                              if sTemp <> '' then
                                sTemp := sTemp + ' + Multi.'
                              else
                                sTemp := 'Multi.';
                            end;

                            cpt_trc:=1170;
                            sCommentaireAdr := Format('   %s'#160': %s', [UpperCase(MonXml.ValueTag(eSkieurXML, 'prenom')), sTemp]) + sLineBreak + sCommentaireAdr;
                            cpt_trc:=1180;
                            eSkieurArtXml := eSkieurArtXml.nextSibling();
                          end;

                          cpt_trc:=1190;
                          // Récupération des dates
                          nReservationXml := MonXml.find('/fiche/reservation');
                          eDureeXml       := MonXml.FindTag(nReservationXml,'dates_duree');
                          if (MonXml.ValueTag(eDureeXml, 'date_debut') <> '')
                            and (MonXml.ValueTag(eDureeXml, 'date_reservation') <> '') then
                          begin
                            cpt_trc:=1200;
                            if not(TryStrToDate(MonXml.ValueTag(eDureeXml, 'date_debut'), dDateDebut, FSetting)) then
                            begin
                              cpt_trc:=1210;
                              OutputDebugString(' - Erreur dans la date de début.');
                              dDateDebut := 0;
                            end;
                            if not(TryStrToDate(MonXml.ValueTag(eDureeXml, 'date_reservation'), dDateResa, FSetting)) then
                            begin
                              cpt_trc:=1220;
                              OutputDebugString(' - Erreur dans la date de réservation.');
                              dDateResa := 0;
                            end;
                          end
                          else begin
                            cpt_trc:=1230;
                            if not(TryStrToDate(MonXml.ValueTag(eDureeXml, 'dates_debut'), dDateDebut, FSetting)) then
                            begin
                              OutputDebugString(' - Erreur dans la date de début.');
                              dDateDebut := 0;
                            end;
                            if not(TryStrToDate(MonXml.ValueTag(eDureeXml, 'dates_reservation'), dDateResa, FSetting)) then
                            begin
                              OutputDebugString(' - Erreur dans la date de réservation.');
                              dDateResa := 0;
                            end;
                          end;
                          cpt_trc:=1240;
                          iNbJours   := StrToIntDef(MonXml.ValueTag (eDureeXml, 'nb_jours'), 0);
                          dDateFin   := dDateDebut + iNbJours - 1;
                          cpt_trc:=1250;

                          sOldCommentaireAdr := sCommentaireAdr;
                          sComentNewBalises := GetComentResa(MonXml, nReservationXml);

                          sCommentaireAdr := Format('Réserv. du %s au %s Arrhes'#160': %s€' + sLineBreak
                            + 'Commission'#160': %s arrhes moins la commission'#160': %s',
                            [FormatDateTime('dd/mm/yyyy', dDateDebut),
                              FormatDateTime('dd/mm/yyyy', dDateFin),
                              MonXml.ValueTag(eFactureXml, 'arrhes'),
                              MonXml.ValueTag(MonXml.FindTag(eFactureXml, 'detailarrhe'), 'commission'),
                              MonXml.ValueTag(MonXml.FindTag(eFactureXml, 'detailarrhe'), 'acompte_moins_commission')]);

                          if sComentNewBalises <> '' then
                            sCommentaireAdr := sCommentaireAdr + sLineBreak + sComentNewBalises;

                          sCommentaireAdr := sCommentaireAdr + sLineBreak + sOldCommentaireAdr;

                          cpt_trc:=1260;
                          if Que_GenAdresse.Active then
                            Que_GenAdresse.Close();

                          Que_GenAdresse.ParamByName('ADRID').AsInteger := -1;
                          Que_GenAdresse.Open();
                          cpt_trc:=1270;
                          Que_GenAdresse.Append();

                          Que_GenAdresse.FieldByName('ADR_LIGNE').AsString    := UpperCase(MonXml.ValueTag(eClientXml, 'adresse'));
                          Que_GenAdresse.FieldByName('ADR_VILID').AsInteger   := iIdVille;
                          Que_GenAdresse.FieldByName('ADR_TEL').AsString      := MonXml.ValueTag(eClientXml, 'telephone');
                          Que_GenAdresse.FieldByName('ADR_FAX').AsString      := '';
                          Que_GenAdresse.FieldByName('ADR_EMAIL').AsString    := MonXml.ValueTag(eClientXml, 'email');
                          Que_GenAdresse.FieldByName('ADR_COMMENT').AsString  := LeftStr(sCommentaireAdr, 1024);

                          cpt_trc:=1280;
                          Que_GenAdresse.Post();
                          cpt_trc:=1290;

                          // Créer le nouveau client
                          {$IFDEF DEBUG}
                          OutputDebugString(' - Création du nouveau client.');
                          {$ENDIF}
                          if Que_Client.Active then
                            Que_Client.Close();

                          cpt_trc:=1300;
                          Que_Client.ParamByName('CLTID').AsInteger := -1;
                          Que_Client.Open();
                          cpt_trc:=1310;
                          Que_Client.Append();

                          iMagId := GetMagId(MaCentrale.MTY_ID, MemD_Mail.FieldByName('MailIdMag').AsString);
                          Que_Client.FieldByName('CLT_NOM').AsString    := Trim(UpperCase(MonXml.ValueTag (eClientXml, 'nom')));
                          Que_Client.FieldByName('CLT_PRENOM').AsString := Trim(UpperCase(MonXml.ValueTag (eClientXml, 'prenom')));
                          Que_Client.FieldByName('CLT_ADRID').AsInteger := Que_GenAdresse.FieldByName('ADR_ID').AsInteger;
                          Que_Client.FieldByname('CLT_MAGID').AsInteger := iMagId;

                          cpt_trc:=1320;
                          Que_Client.Post();

                          cpt_trc:=1330;
                          iIdClient := Que_Client.FieldByName('CLT_ID').AsInteger;

                          {$IFDEF DEBUG}
                          OutputDebugString(PChar(Format(' - Client créé. IdClient = %d', [iIdClient])));
                          {$ENDIF}

                          // Gestion du TO
                          {$IFDEF DEBUG}
                          OutputDebugString(' - Gestion du TO.');
                          {$ENDIF}
                          if MonXml.ValueTag(nReservationXml, 'nom_TO') <> '' then
                            iIdPro := GetIdTO(MonXml.ValueTag(nReservationXml, 'nom_TO'), iMagId)
                          else
                            iIdPro := MaCentrale.MTY_CLTIDPRO;

                          cpt_trc:=1340;
                          // Lien avec le TO
                          {$IFDEF DEBUG}
                          OutputDebugString(PChar(Format(' - Liaison avec le TO. IdClient = %d - IdPro = %d', [iIdClient, iIdPro])));
                          {$ENDIF}
                          InsertCLTMEMBREPRO(iIdPro, iIdClient);

                          cpt_trc:=1350;
                          // Code-barres client
                          {$IFDEF DEBUG}
                          OutputDebugString(' - Création du code-barres client.');
                          {$ENDIF}
                          InsertCodeBarre(iIdClient);

                          cpt_trc:=1360;
                          // Met à jour le client de la réservation
                          {$IFDEF DEBUG}
                          OutputDebugString(' - Mise à jour du client de la réservation.');
                          {$ENDIF}
                          Que_MajResa.Edit();
                          Que_MajResa.FieldByName('RVS_CLTID').AsInteger := iIdClient;
                          cpt_trc:=1370;
                          Que_MajResa.Post();

                          cpt_trc:=1380;
                          Dm_Main.StartTransaction();
                          try
                            Dm_Main.IBOUpDateCache(Que_Pays);
                            Dm_Main.IBOUpDateCache(Que_Villes);
                            Dm_Main.IBOUpDateCache(Que_CltTo);
                            Dm_Main.IBOUpDateCache(Que_Client);
                            Dm_Main.IBOUpDateCache(Que_GenAdresse);
                            Dm_Main.IBOUpDateCache(Que_CodeBarre);
                            Dm_Main.IBOUpDateCache(Que_MajResa);
                            cpt_trc:=1390;
                            Dm_Main.Commit();
                          except
                            cpt_trc:=1400;
                            Dm_Main.Rollback();
                            Dm_Main.IBOCancelCache(Que_Pays);
                            Dm_Main.IBOCancelCache(Que_Villes);
                            Dm_Main.IBOCancelCache(Que_CltTo);
                            Dm_Main.IBOCancelCache(Que_Client);
                            Dm_Main.IBOCancelCache(Que_GenAdresse);
                            Dm_Main.IBOCancelCache(Que_CodeBarre);
                            Dm_Main.IBOCancelCache(Que_MajResa);
                            raise;
                          end;
                          cpt_trc:=1410;
                          Dm_Main.IBOCommitCache(Que_Pays);
                          Dm_Main.IBOCommitCache(Que_Villes);
                          Dm_Main.IBOCommitCache(Que_CltTo);
                          Dm_Main.IBOCommitCache(Que_Client);
                          Dm_Main.IBOCommitCache(Que_GenAdresse);
                          Dm_Main.IBOCommitCache(Que_CodeBarre);
                          Dm_Main.IBOCommitCache(Que_MajResa);
                          cpt_trc:=1420;
                        end;
                        cpt_trc:=1430;
                      end;
                      cpt_trc:=1440;
                    end;
                    cpt_trc:=1450;
                  end;
                  cpt_trc:=1460;

                end //IF resa !exist

                else begin
                  //PDB - Renvoyer le message de résa déjà existante uniquement si ce n'est pas une Annulation
                  //(l'annulation enverra le bon message)

                  senddebug('Cas 1');

                  if MemD_Mail.FieldByName('bAnnulation').AsBoolean then
                  begin
                    Fmain.trclog('TAnnulation réservation (traité après)');
                  end
                  else begin
                    Fmain.trclog('FLa réservation existe déjà');
                    //Fmain.trclog('TCas Impossible...(La réservation existe déjà ?)');
                  end;

                end;

              end //If btraiter

              else begin

                senddebug('Cas 2');

                if not MemD_Mail.FieldByName('bAnnulation').AsBoolean then
                begin
                  Fmain.trclog('FLa réservation existe déjà');
                end
                else begin
                  //main.trclog('FAnnulation d''une réservation inexistante.');
                end;
              end;

            end;

            cpt_trc:=1470;

gtResa_Next:

          //Si sortie en erreur, on annule tout pour la résa courante
          if cpt_trc < 1470 then begin
            Fmain.trclog('TSortie en erreur Resa_Next -> rollback');
            Dm_Main.IBOCancelCache(Que_Pays);
            Dm_Main.IBOCancelCache(Que_Villes);
            Dm_Main.IBOCancelCache(Que_Civilite);
            Dm_Main.IBOCancelCache(Que_Client);
            Dm_Main.IBOCancelCache(Que_CltTo);
            Dm_Main.IBOCancelCache(Que_ClientTO);
            Dm_Main.IBOCancelCache(Que_GenAdresse);
            Dm_Main.IBOCancelCache(Que_CodeBarre);
            Dm_Main.IBOCancelCache(Que_Resa);
            Dm_Main.IBOCancelCache(Que_resal);
            Dm_Main.IBOCancelCache(Que_Resasl);
            Dm_Main.IBOCancelCache(Que_LOCPARAMELT);
            Dm_Main.IBOCancelCache(Que_GENIMPORT);
            Dm_Main.IBOCancelCache(Que_CreeSess);
          end;


          except
            on E: Exception do
            begin
              Fmain.trclog('XErreur lors de la création de la réservation '+FieldByName('MailIdResa').AsString+' (id_trace='+inttostr(cpt_trc)+') : '+E.ClassName+'-'+E.Message);
              {$IFDEF DEBUG}
              OutputDebugString(PChar(Format(RS_ERR_RESADM_CREATERESA, [FieldByName('MailIdResa').AsString, E.ClassName, E.Message])));
              {$ENDIF}

              // Demande de ne pas archiver le mail pour le repasser la prochaine fois
              MemD_Mail.Edit();
              MemD_Mail.FieldByName('bArchive').AsBoolean := False;
              cpt_trc:=1490;
              MemD_Mail.Post();
              cpt_trc:=1500;

            end;
          end;

        finally
          cpt_trc:=1510;
          {$IFDEF DEBUG}
          OutputDebugString(' - Libération de MonXml.Doc.');
          {$ENDIF}
          FreeAndNil(MonXml.Doc);
        end;
        cpt_trc:=1520;

        Next;
        Fmain.UpdateGauge ;
        //IncGaugeMessHP(1);
      end; // while

      cpt_trc:=1530;
    end; // with

    cpt_trc:=1540;

  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans CreateResa (id_trace='+inttostr(cpt_trc)+') : '+e.message);
  end;

  finally
    Fmain.ResetGauge ;
    //CloseGaugeMessHP;
    MonXml.Free;
    Fmain.trclog('TFin de la procedure CreateResa');
  end; // with /try
End;

procedure Tdm_reservation.DataModuleCreate(Sender: TObject);
var
  sFicIni : TFileName;
  FicIni  : TIniFile;
  b_creeskiset : boolean;
begin
  // Récupère le temps entre deux essais
  try
  try
    sFicIni := ChangeFileExt(Application.ExeName, '.ini');
    FicIni  := TIniFile.Create(sFicIni);

    DelaisEssais  := FicIni.ReadInteger('Parametres', 'DelaisEssais', 5000);

    b_creeskiset:=false;
    if not(FileExists(sFicIni)) then begin
      FicIni.WriteInteger('Parametres', 'DelaisEssais', DelaisEssais);
      b_creeskiset:=true;
    end
    else begin
      if not FicIni.SectionExists('SKISET') then b_creeskiset:=true
      else begin
        if not FicIni.ValueExists('SKISET','date_begin') then b_creeskiset:=true;
        if not FicIni.ValueExists('SKISET','date_end') then b_creeskiset:=true
      end;
    end;

    if b_creeskiset then begin
      FicIni.WriteString('SKISET','date_begin','today');
      FicIni.WriteString('SKISET','date_end','today+15');
    end;

  Except
    on E:Exception do Fmain.trclog('XErreur dans DataModuleCreate : '+e.message);
  end;
  finally
    FicIni.Free();
  end;
end;

function TDm_Reservation.GetEtat(iWeb,iType : Integer): Integer;
begin
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select ers_id from locetatreservation');
      SQL.Add('where ers_web=:web');
      SQL.Add('and ers_type=:type');
      ParamCheck := True;
      ParamByName('web').asinteger := iWeb;
      ParamByName('type').asinteger := iType;
      Open;

      Result := FieldByName('ers_id').AsInteger;
    end;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetEtat : '+e.message);
  end;
end;

function Tdm_reservation.GetGenTypeMail(aModule: String): Integer;
begin
  // Attention, la requête ne tient pas compte si le module est activé sur le magasin
  // Cela est voulu pour pouvoir récupérer les infos d'un module désactivé

  Result := -1;

  try
    Que_TmpNoEvent.Close;
    Que_TmpNoEvent.SQL.Clear;
    Que_TmpNoEvent.SQL.Add('select MTY_ID');
    Que_TmpNoEvent.SQL.Add('from gentypemail join k on k_id = mty_id and k_enabled = 1');
    Que_TmpNoEvent.SQL.Add('where mty_id != 0 and upper(mty_nom) = :Module');
    Que_TmpNoEvent.ParamCheck := True;
    Que_TmpNoEvent.ParamByName('Module').asString := aModule;
    Que_TmpNoEvent.Open;

    if not Que_TmpNoEvent.Eof then
      Result := Que_TmpNoEvent.FieldByName('MTY_ID').AsInteger;
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetGenTypeMail : '+e.message);
  end;
end;

function Tdm_reservation.CheckOffreExiste(aIdCentrale, aMtyId: Integer): Integer;
begin
  Result := -1;

  try
    Que_TmpLoc.SQL.Clear;
    Que_TmpLoc.SQL.Add('select OCC_ID');
    Que_TmpLoc.SQL.Add('from LOCCENTRALEOC');
    Que_TmpLoc.SQL.Add('join K on K_ID = OCC_ID');
    Que_TmpLoc.SQL.Add('where OCC_IDCENTRALE = :IdCentrale and OCC_MTYID = :MtyId');
    Que_TmpLoc.ParamByName('IdCentrale').AsInteger := aIdCentrale;
    Que_TmpLoc.ParamByName('MtyId').AsInteger := aMtyId;

    try
      Que_TmpLoc.Open;

      if not Que_TmpLoc.Eof then
        Result := Que_TmpLoc.FieldByName('OCC_ID').AsInteger;

    except
      on E:Exception do Fmain.trclog('XErreur dans CheckOffreExiste : '+e.message);
    end;
  finally
    Que_TmpLoc.Close;
  end;
end;

function TDm_Reservation.GetLocParam(sParam: String): Integer;
begin
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(lcp_id) Resultat from locparam where lcp_nom= :PNom');
      ParamCheck := True;
      ParamByName('PNom').AsString := sParam;
      Open;

      Result := FieldByName('Resultat').AsInteger;
    end;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetLocParam : '+e.message);
  end;
end;

function Tdm_reservation.GetLocParamMag(iMagId: Int64): TParamLoc;
begin
  Result := nil;

  try
    Que_TmpNoEvent.Close;
    Que_TmpNoEvent.SQL.Clear;
    Que_TmpNoEvent.SQL.Add('SELECT LMP_SORTIEMATIN, LMP_SORTIEAM,');
    Que_TmpNoEvent.SQL.Add('LMP_RETOURMATIN, LMP_RETOURAM, LMP_DJSUP, LMP_DJSUPPC, LMP_saison');
    Que_TmpNoEvent.SQL.Add('FROM LOCMAGPARAM');
    Que_TmpNoEvent.SQL.Add('JOIN K ON K_ID = LMP_ID AND K_ENABLED=1');
    Que_TmpNoEvent.SQL.Add('WHERE LMP_MAGID = :MAGID');

    Que_TmpNoEvent.ParamCheck := True;
    Que_TmpNoEvent.ParamByName('MAGID').AsInteger := iMagId;
    Que_TmpNoEvent.Open;

    if Que_TmpNoEvent.RecordCount = 1 then
    begin
      Result := TParamLoc.Create;
      Result.SortieAM   := Que_TmpNoEvent.FieldByName('LMP_SORTIEMATIN').AsDateTime ;
      Result.SortiePM   := Que_TmpNoEvent.FieldByName('LMP_SORTIEAM').AsDateTime ;
      Result.RetourAM   := Que_TmpNoEvent.FieldByName('LMP_RETOURMATIN').AsDateTime ;
      Result.RetourPM   := Que_TmpNoEvent.FieldByName('LMP_RETOURAM').AsDateTime ;
      Result.DJSup      := (Que_TmpNoEvent.FieldByName('LMP_DJSUP').AsInteger = 1) ;
      Result.DJSuppC    := Que_TmpNoEvent.FieldByName('LMP_DJSUPPC').AsFloat ;
      Result.nbjsaison  := Que_TmpNoEvent.FieldByName('LMP_saison').AsInteger ;
    end;

  Except
    on E:Exception do Fmain.trclog('XErreur dans GetLocParamMag : '+e.message);
  end;
end;

function Tdm_reservation.GetTarifLoc(const vParamLoc : TParamLoc; const iMtaId : Integer; const vLigneReservation : TLigneReservation; const iPrdId, iLocType, iIdClient : Integer): Double;
var
  tDateFin : TDateTime;
begin
  Result := 0;

  try
    if vLigneReservation.NbJours = 1 then
    begin
      tDateFin := IncHour(vLigneReservation.DateDebut, 23);
    end
    else
    begin
      tDateFin := IncDay(vLigneReservation.DateDebut, vLigneReservation.NbJours) - 1;
    end;

    Que_TmpNoEvent.Close;
    Que_TmpNoEvent.SQL.Clear;
    Que_TmpNoEvent.SQL.Add('select * from bn_loc_tarif(:DEBUT,:FIN,:PRDID,:SORTIEM,:SORTIEAM,:RETOURAM,:DJSUP,:DJSUPPC,:RetourMAtin,');
    Que_TmpNoEvent.SQL.Add(':typeligne,:calid,:flagass,:nbjsaison,:cltid,:mtaid,:dureevoucher,');
    Que_TmpNoEvent.SQL.Add(':typegrille, :dureeloc)');

    Que_TmpNoEvent.ParamCheck := True;
    Que_TmpNoEvent.parambyname('DEBUT').AsDateTime      := vLigneReservation.DateDebut;
    Que_TmpNoEvent.parambyname('FIN').AsDateTime        := tDateFin;
    Que_TmpNoEvent.parambyname('PRDID').asinteger       := iPrdId;
    Que_TmpNoEvent.parambyname('SORTIEM').AsDateTime    := vParamLoc.SortieAM;
    Que_TmpNoEvent.parambyname('SORTIEAM').AsDateTime   := vParamLoc.SortiePM;
    Que_TmpNoEvent.parambyname('RETOURAM').AsDateTime   := vParamLoc.RetourPM;
    Que_TmpNoEvent.parambyname('DJSUP').AsInteger       := Ord(vParamLoc.DJSup);
    Que_TmpNoEvent.parambyname('DJSUPPC').ASfloat       := vParamLoc.DJSuppC;
    Que_TmpNoEvent.parambyname('RetourMAtin').ASDATETIME:= vParamLoc.RetourAM;
    Que_TmpNoEvent.parambyname('TypeLigne').ASinteger   := 1;
    Que_TmpNoEvent.parambyname('CALID').AsInteger       := 0;
    Que_TmpNoEvent.parambyname('FLAGASS').AsInteger     := Ord(vLigneReservation.Assurance);
    Que_TmpNoEvent.parambyname('nbjsaison').AsInteger   := vParamLoc.nbjsaison;
    Que_TmpNoEvent.parambyname('cltid').asinteger       := iIdClient;
    Que_TmpNoEvent.parambyname('mtaid').asinteger       := iMtaId;
    Que_TmpNoEvent.parambyname('dureevoucher').asinteger:= vLigneReservation.NbJours;
    Que_TmpNoEvent.parambyname('TYPEGRILLE').asinteger  := iLocType;
    Que_TmpNoEvent.parambyname('DUREELOC').asinteger    := MinutesBetween(vLigneReservation.DateDebut, tDateFin);

    Que_TmpNoEvent.Open;

    if not Que_TmpNoEvent.Eof then
      Result := Que_TmpNoEvent.fieldbyname('prix').asfloat;

  Except
    on E:Exception do Fmain.trclog('XErreur dans GetTarifLoc : '+e.message);
  end;

end;

function TDm_Reservation.IsReservationExist(sIdResa: String): Boolean;
begin
  try
    With Que_ResaExist do
    begin
      Close;
      ParamCheck := True;
      ParamByName('ImpRef').AsString := sIdResa;
      //senddebug('SQL resaexist='+SQL.TEXT);
      //senddebug('ImpRef='+ sIdResa);
      Open;

      // Retourne vrai si recordcount > 0 sinon false
      Result := (Recordcount > 0);
    end;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans IsReservationExist : '+e.message);
  end;
end;


//TWGS
function TDm_Reservation.IsReservationExistMulti(sIdResa: String; iCptCentrale,iIdCentrale:integer): Boolean;
var
  iId_Imp : integer;
begin
  try
    Result:=false;

    //Si une seule centrale
    (*
    if iCptCentrale=1 then begin
      Fmain.trclog('T  Avec une seule centrale -> on ne tient pas compte de l''id centrale');
      With Que_ResaExist do
      begin
        Close;

        ParamCheck := True;
        ParamByName('ImpRef').AsString := sIdResa;
        Open;

        // Retourne vrai si recordcount > 0 sinon false
        Result := (Recordcount > 0);
      end;

    end
    *)

    //Si plusieurs centrales, tenir compte de l'ID Centrale dans la recherche
    //else begin
      Fmain.trclog('T  Recherche résa -> on tient compte de l''id centrale '+inttostr(iIdCentrale));
      With Que_ResaExistMulti do
      begin
        Close;

        ParamCheck := True;
        ParamByName('ImpRef').AsString := sIdResa;
        ParamByName('RefCentrale').AsInteger := iIdCentrale;
        //senddebug('SQL avec centrale='+sql.Text);
        //senddebug('ImpRef='+ sIdResa);
        //senddebug('RefCentrale='+inttostr(iIdCentrale));;
        Open;

        // Retourne vrai si recordcount > 0
        if Recordcount > 0 then begin
          Fmain.trclog('T  Trouvé');
          Result := true;
        end
        // Sinon on cherche sans l'ID Centrale...
        else begin
          Fmain.trclog('T  Pas trouvé -> on cherche uniquement avec l''id de la resa '+sIdResa);
          With Que_ResaExist do
          begin
            Close;

            ParamCheck := True;
            ParamByName('ImpRef').AsString := sIdResa;
            //senddebug('SQL sans centrale='+sql.Text);
            //senddebug('ImpRef='+ sIdResa);

            Open;

            //...et si on trouve on en profite pour mettre à jour le record qvec l'Id Centrale
            if Recordcount > 0 then begin

              //Mais seulement si le champ imp_ref n'est pas renseigné, sinon on écraserait
              if fieldbyname('IMP_REF').asinteger>0 then begin
                Fmain.trclog('T  Trouvé mais déjà une valeur dans "imp_ref" -> pas trouvé');
                Result := false;
              end
              else begin
                Result := true;

                Fmain.trclog('T  Trouvé avec "imp_ref" non renseigné -> au passage, rajout de l''ID de la centrale dans "imp_ref" de GenImport');
                Que_TmpLoc.Close;
                iId_Imp:=fieldbyname('IMP_ID').asinteger;
                Fmain.trclog('T  ID mis à jour = '+Inttostr(iId_Imp));

                dm_main.StartTransaction;
                Que_TmpLoc.SQL.Clear;
                Que_TmpLoc.SQL.Add('UPDATE GENIMPORT');
                Que_TmpLoc.SQL.Add('SET imp_ref = ' + inttostr(iId_centrale) );
                Que_TmpLoc.SQL.Add('WHERE IMP_ID = ' + Inttostr(iId_Imp)  );
                //main.trclog('T  Que_TmpLoc.SQL='+Que_Tmp.SQL.text);
                Que_TmpLoc.ExecSQL;

                Que_TmpLoc.Close;
                Que_TmpLoc.SQL.Clear;
                Que_TmpLoc.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(iId_Imp) + ', 0)');
                Que_TmpLoc.ExecSQL;

                Dm_Main.Commit;
              end;

            end
            else Fmain.trclog('T  Réservation pas trouvée');

          end;
        end;
      end;

    //end;

  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans IsReservationExist : '+e.message);
  end;
end;

// Récupère l'ID d'une réservation
function TDm_Reservation.IsReservationUpdatable(const AIdResaWeb: string): Boolean;
begin
  try
  try
    if Que_Tmp.Active then
      Que_Tmp.Close();

    Que_Tmp.SQL.Clear();
    Que_Tmp.SQL.Add('SELECT RVS_ID, RVS_BL, IMP_REFSTR');
    Que_Tmp.SQL.Add('FROM LOCRESERVATION');
    Que_Tmp.SQL.Add('  JOIN K KRVS ON (KRVS.K_ID = RVS_ID AND KRVS.K_ENABLED = 1)');
    Que_Tmp.SQL.Add('  LEFT JOIN GENIMPORT ON (IMP_GINKOIA = RVS_CLTID)');
    Que_Tmp.SQL.Add('WHERE RVS_NUMEROWEBSTRING = :RVSNUMEROWEBSTRING;');
    Que_Tmp.ParamByName('RVSNUMEROWEBSTRING').AsString;

    Que_Tmp.Open();
    if not(Que_Tmp.IsEmpty()) then
      Result := not(Que_Tmp.FieldByName('IMP_REFSTR').IsNull)
    else
      Result := False;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans IsReservationUpdatable : '+e.message);
  end;
  finally
    Que_Tmp.Close();
  end;
end;

function Tdm_reservation.ReservationInMemory(AMemD: TdxMemData;
  AIdResa: string): Boolean;
var
 iPosition : Integer;
 BookM : TBookmark;
begin
  try
    Result := False;
    With  AMemD do
    begin
      // Est ce que la réservation est en mémoire ?
      iPosition := RecNo;
      BookM := GetBookmark;
      try
        if Locate('MailIdResa;bAnnulation',VarArrayOf([AIdResa,False]),[]) then
        begin
          if iPosition <> RecNo then
          begin
  //          Edit;
  //          FieldByName('bTraiter').AsBoolean := False;
  //          Post;
            Result := True;
          end;
        end;
      finally
        GotoBookmark(BookM);
      end;
    end;
  //PDB  
  Except
    on E:Exception do Fmain.trclog('XErreur dans ReservationInMemory : '+e.message);
  end;
end;

{$REGION 'Fonctions Generik des composants bases de données'}
procedure Tdm_reservation.Que_LOCCENTRALEOCAfterPost(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure Tdm_reservation.Que_LOCCENTRALEOCBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete ( ( DataSet As TIBODataSet).KeyRelation,
    DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True ) then Abort;
end;

procedure Tdm_reservation.Que_LOCCENTRALEOCBeforeEdit(DataSet: TDataSet);
begin
    if not Dm_Main.CheckAllowEdit ( ( DataSet As TIBODataSet).KeyRelation,
    DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True ) then Abort;
end;

procedure Tdm_reservation.Que_LOCCENTRALEOCNewRecord(DataSet: TDataSet);
begin
 if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;

end;

procedure Tdm_reservation.Que_LOCCENTRALEOCUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                            ( DataSet As TIBODataSet),UpdateKind, UpdateAction );

end;

procedure TDm_Reservation.GenerikNewRecord(DataSet: TDataSet);
var
  CltNum : String;
begin
  try
    IF NOT Dm_Main.IBOMajPkKey ((DataSet AS TIBODataSet) ,
      (DataSet AS TIBODataSet) .KeyLinks.IndexNames[0]) THEN Abort;
    IF dataset = que_client THEN
    BEGIN
      //---Num Chrono---
      CltNum := GetChronoClient;
      que_client.fieldbyname ('clt_numero') .asstring := CltNum;

      que_client.fieldbyname ('CLT_orgid') .asinteger := 0;
      que_client.fieldbyname ('clt_staadrid') .asinteger := 0;
      que_client.fieldbyname ('clt_gclid') .asinteger := 0;
      que_client.fieldbyname ('clt_type') .asinteger := 0;
      que_client.fieldbyname ('clt_cltid') .asinteger := 0;
      que_client.fieldbyname ('clt_bl') .asinteger := 0;
      que_client.fieldbyname ('CLT_PREMIERPASS') .asdatetime := now;
      que_client.fieldbyname ('CLT_DERNIERPASS') .asdatetime := now;
      que_client.fieldbyname ('CLT_ECAUTORISE') .asfloat := 0;
      que_client.fieldbyname ('CLT_cptbloque') .asinteger := 0;
      que_client.fieldbyname ('CLT_AFADRID') .asinteger := 0;
      que_client.fieldbyname ('CLT_MRGID') .asinteger := 0;
      que_client.fieldbyname ('CLT_CPAID') .asinteger := 0;
      que_client.fieldbyname ('CLT_RIBBANQUE') .asinteger := 0;
      que_client.fieldbyname ('CLT_RIBGUICHET') .asinteger := 0;
      que_client.fieldbyname ('CLT_RIBCLE') .asinteger := 0;
      que_client.fieldbyname ('CLT_ICLID1') .asinteger := 0;
      que_client.fieldbyname ('CLT_ICLID2') .asinteger := 0;
      que_client.fieldbyname ('CLT_ICLID3') .asinteger := 0;
      que_client.fieldbyname ('CLT_ICLID4') .asinteger := 0;
      que_client.fieldbyname ('CLT_ICLID5') .asinteger := 0;
      que_client.fieldbyname ('CLT_CIVID') .asinteger := 0;
      que_client.fieldbyname ('CLT_compta') .asstring := '';
      que_client.fieldbyname ('CLT_RETRAIT') .asstring := '';
      que_client.fieldbyname ('CLT_RIBCOMPTE') .asstring := '';
      que_client.fieldbyname ('CLT_RIBDOMICILIATION') .asstring := '';
      que_client.fieldbyname ('CLT_CODETVA') .asstring := '';
      que_client.fieldbyname ('CLT_NUMFACTOR') .asstring := '';
      que_client.fieldbyname ('CLT_FIDELITE') .asinteger := 0;
      que_client.fieldbyname ('CLT_DUREEVO') .asinteger := 0;
      que_client.fieldbyname ('CLT_DEBUTSEJOURVO').asdatetime := 0;
      que_client.fieldbyname ('CLT_resid') .asinteger := 0;

    END
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GenerikNewRecord : '+e.message);
  end;
end;


{$ENDREGION}

(*
function TDm_Reservation.GetClientImpGin(IdClient: String): Integer;
begin
  try
  With Que_TmpNoEvent do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from genimport');
    SQL.Add('where imp_num=5');
    SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
    SQL.Add('  and imp_ktbid=-11111401');
    Open;

    if Recordcount <> 0 then
      Result := FieldByName('imp_ginkoia').AsInteger
    else
      Result := -1;
  end;
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetClientImpGin : '+e.message);
  end;
end;
*)

function TDm_Reservation.GetClientImpGin(IdClient: String): Integer;
var
  iId_Imp:integer;
begin
  Fmain.trclog('T  Recherche du client');
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;


      //TWGS - cas normal (ou anciennement) 1 seule centrale
      if cpt_centrale=1 then begin

        Fmain.trclog('T  Une seule centrale');
        SQL.Add('select * from genimport');
        SQL.Add('where imp_num=5');
        SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
        SQL.Add('  and imp_ktbid=-11111401');
        Open;

        if Recordcount <> 0 then begin
          Fmain.trclog('T  Trouvé id='+inttostr(FieldByName('imp_ginkoia').AsInteger));
          Result := FieldByName('imp_ginkoia').AsInteger
        end
        else
          Result := -1;

      end

      //TWGS - nouveau si >1 centrale
      else if cpt_centrale>1 then begin
        Fmain.trclog('T  Plusieurs centrales, recherche avec l''ID de la centrale '+inttostr(iId_centrale));
        SQL.Add('select * from genimport');
        SQL.Add('where imp_num=5');
        SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
        SQL.Add('  and imp_ktbid=-11111401');
        SQL.Add('  and imp_ref='+inttostr(iId_centrale)); //prende en compte l'ID de la centrale
        Open;

        if Recordcount <> 0 then begin
          Fmain.trclog('T  Trouvé id='+inttostr(FieldByName('imp_ginkoia').AsInteger));
          Result := FieldByName('imp_ginkoia').AsInteger
        end
        //Si on ne trouve pas en tenant compte de l'ID de la centrale, on essaye sans
        else begin
          Fmain.trclog('T  Pas trouvé, essai sans l''ID de la centrale');
          Close;
          SQL.Clear;
          SQL.Add('select * from genimport');
          SQL.Add('where imp_num=5');
          SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
          SQL.Add('  and imp_ktbid=-11111401');
          //main.trclog('T  SQL.text='+SQL.text);
          Open;

          //Si on trouve on en profite pour rajouter l'ID de la centrale dans le record correspondant de GENIMPORT...
          if Recordcount <> 0 then begin
            //... mais seulement si il n'y a pas déjà qch. dans imp_ref, sinon on écraserait
            if fieldbyname('IMP_REF').asinteger>0 then begin
              Fmain.trclog('T  Trouvé mais déjà une valeur dans "imp_ref" -> pas trouvé');
              Result := -1;
            end
            else begin
              Fmain.trclog('T  Trouvé et pas de valeur dans "imp_ref" -> id='+inttostr(FieldByName('imp_ginkoia').AsInteger));
              Result := FieldByName('imp_ginkoia').AsInteger;

              Fmain.trclog('T  Au passage, rajout de l''ID de la centrale dans "imp_ref" de GenImport');
              Que_TmpLoc.Close;
              iId_Imp:=fieldbyname('IMP_ID').asinteger;
              Fmain.trclog('T  ID mis à jour = '+Inttostr(iId_Imp));
              dm_main.StartTransaction;
              Que_TmpLoc.SQL.Clear;
              Que_TmpLoc.SQL.Add('UPDATE GENIMPORT');
              Que_TmpLoc.SQL.Add('SET imp_ref = ' + inttostr(iId_centrale) );
              Que_TmpLoc.SQL.Add('WHERE IMP_ID = ' + Inttostr(iId_Imp)  );
              Fmain.trclog('T  Que_TmpLoc.sql='+Que_Tmp.SQL.text);
              Que_TmpLoc.ExecSQL;

              Que_TmpLoc.Close;
              Que_TmpLoc.SQL.Clear;
              Que_TmpLoc.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(iId_Imp) + ', 0)');
              Que_TmpLoc.ExecSQL;

              Dm_Main.Commit;
            end;
          end
          //Si pas trouvé dans aucun cas, on renvoi -1
          else begin
            Fmain.trclog('T  Pas trouvé définitivement');
            Result := -1;
          end;
        end;

      end;

    end;
  //PDB  
  Except
    on E:Exception do Fmain.trclog('TErreur dans GetClientImpGin : '+e.message);
  end;
end;

function Tdm_reservation.GetClientById(aId: Integer): TClient;
begin
  Result := nil;

  try
    Que_Client.Close;
    Que_Client.ParamCheck := true;
    Que_Client.ParamByName('cltid').AsInteger := aId;
    Que_Client.Open;

    if not Que_Client.Eof then
    begin
      Result := TClient.Create;
      Result.Id := aId;
      Result.Nom := Que_Client.FieldByName('CLT_NOM').asstring;
      Result.Prenom := Que_Client.FieldByName('CLT_PRENOM').asstring;
      Result.AdresseId := Que_Client.FieldByName('CLT_ADRID').asinteger;
      Result.MagId := Que_Client.FieldByname('CLT_MAGID').asinteger;
      Result.Civilite := Que_Client.FieldByname('CLT_CIVID').asinteger;
      Result.DureeVO := Que_Client.FieldByname('CLT_DUREEVO').asinteger;
      Result.DebutSejourVO := Que_Client.FieldByname('CLT_DEBUTSEJOURVO').AsDateTime;
      Result.DureeVODate := Que_Client.FieldByname('CLT_DUREEVODATE').AsDateTime;
    end;
  except
    on e:exception do Fmain.trclog('XErreur dans GetClientById : '+e.message);
  end;
end;

function TDm_Reservation.GetClientByMail(sMail: String): Integer;
begin
  try
    Result := -1;

    senddebug('IS> Paramètre email='+sMail);
    // Si le mail est vide on sort
    if Trim(sMail) = '' then
      Exit;

    With Que_TmpNoEvent do
    begin
      // recherche par l'email (adresse de livraison)
      Close;
      SQL.Clear;
      SQL.Add('Select CLT_ID from CLTCLIENT');
      SQL.Add('  join K on K_ID = CLT_ID and K_Enabled = 1');
      SQL.Add('  join GENADRESSE on CLT_ADRID = ADR_ID');
      SQL.Add('Where ADR_EMAIL = :PEMAIL');
      SQL.Add('  and CLT_ARCHIVE = 0');
      SQL.Add('order by CLT_PREMIERPASS desc');
      ParamCheck := True;
      ParamByName('PEMAIL').AsString := sMail;
      Open;

      if RecordCount > 0 then
      begin
        senddebug('IS> Trouvé='+inttostr(FieldByName('CLT_ID').AsInteger));
        Result := FieldByName('CLT_ID').AsInteger;
        exit;
      end;

      // recherche par l'email (adresse de facturation)
      Close;
      SQL.Clear;
      SQL.Add('Select CLT_ID from CLTCLIENT');
      SQL.Add('  join K on K_ID = CLT_ID and K_Enabled = 1');
      SQL.Add('  join GENADRESSE on CLT_AFADRID = ADR_ID');
      SQL.Add('Where ADR_EMAIL = :PEMAIL');
      SQL.Add('  and CLT_ARCHIVE = 0');
      SQL.Add('order by CLT_PREMIERPASS desc');
      ParamCheck := True;
      ParamByName('PEMAIL').AsString := sMail;
      Open;
      if RecordCount > 0 then
      begin
        senddebug('IS> Trouvé='+inttostr(FieldByName('CLT_ID').AsInteger));
        Result := FieldByName('CLT_ID').AsInteger;
      end;
    end;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetClientByMail : '+e.message);
  end;
end;

function TDm_Reservation.GetPaysId(sNomPays: String; iIdMag: Integer): Integer;
begin
  try
    if sNomPays = '' then
    begin
      // Si pas de pays renseigné, on prend celui du magasin
      try
        Que_TmpNoEvent.Close;
        Que_TmpNoEvent.SQL.Clear;
        Que_TmpNoEvent.SQL.Add('select VIL_PAYID');
        Que_TmpNoEvent.SQL.Add(' from GENMAGASIN');
        Que_TmpNoEvent.SQL.Add('  join K on K_ID = MAG_ID and K_ENABLED = 1');
        Que_TmpNoEvent.SQL.Add(' join genadresse on adr_id = mag_adrid');
        Que_TmpNoEvent.SQL.Add('  join k on k_id = adr_id and k_enabled = 1');
        Que_TmpNoEvent.SQL.Add(' join genville on vil_id = adr_vilid');
        Que_TmpNoEvent.SQL.Add(' where MAG_ID  = :MAGID');
        Que_TmpNoEvent.ParamCheck := True;
        Que_TmpNoEvent.ParamByName('MAGID').AsInteger := iIdMag;
        Que_TmpNoEvent.Open;

        Result := Que_TmpNoEvent.FieldByName('VIL_PAYID').AsInteger;
      except
        on e:exception do Fmain.trclog('XErreur dans GetPaysId : '+e.message);
      end;
    end
    else
    begin
      // Sinon on recherche le pays renseigné dans la réservation
      Que_Pays.Close;
      Que_Pays.ParamCheck := True;
      Que_Pays.ParamByName('PNom').AsString := sNomPays;
      Que_Pays.Open;

      if Que_Pays.Recordcount = 0 then
      begin
        Que_Pays.Append;
        Que_Pays.FieldByName('PAY_NOM').AsString := sNomPays;
        Que_Pays.Post;
      end;
      Result := Que_Pays.FieldByName('Pay_ID').AsInteger ;
    end;
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetPaysId : '+e.message);
  end;
end;

function TDm_Reservation.GetVilleId(sNomVille, sCP: String;
  iPayID: Integer): integer;
var
  i: Integer;
begin
  try
    Que_Villes.Close;
    Que_Villes.ParamCheck := True;
    Que_Villes.ParamByName('PNom').AsString := UpperCase(sNomVille);
    Que_Villes.ParamByName('PCp').AsString  := UpperCase(sCP);

    i := Que_Villes.SQL.IndexOF('/*BALISE1*/');
    if (sNomVille = '') and (sCP = '') then
    begin
      // Si pas de ville et de code postal renseigné, on recherche avec le pays passé en paramètre
      // (potentiellement, le pays du magasin)
      if i <> -1 then
      begin
        Que_Villes.SQL[i + 1] := 'and VIL_PAYID = :PAYID';
        Que_Villes.ParamByName('PAYID').AsInteger  := iPayID;
      end;
    end
    else
    begin
      if i <> -1 then
      begin
        Que_Villes.SQL[i + 1] := '';
      end;
    end;

    Que_Villes.Open;
    Que_Villes.First;

    if Que_Villes.RecordCount = 0 then
    begin
      Que_Villes.Append;
      Que_Villes.FieldByName('VIL_NOM').AsString    := UpperCase(sNomVille);
      Que_Villes.FieldByName('VIL_CP').AsString     := UpperCase(sCP);
      Que_Villes.FieldByName('VIL_PAYID').AsInteger := iPayID;
      Que_Villes.Post;
    end;

    Result := Que_Villes.FieldByName('VIL_ID').AsInteger;
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetVilleId : '+e.message);
  end;
end;

function Tdm_reservation.GetAddresseId(iAdrIdRecherche, iIdVille : Integer): Integer;
begin
  try
    Que_GenAdresse.Close;
    Que_GenAdresse.ParamCheck := True;
    Que_GenAdresse.ParamByName('adrid').AsInteger := iAdrIdRecherche;
    Que_GenAdresse.Open;

    if Que_GenAdresse.RecordCount = 0 then     // Création d'une adresse vide
    begin
      Que_GenAdresse.Append;
      Que_GenAdresse.FieldByName('ADR_LIGNE').asstring := '';
      Que_GenAdresse.FieldByName('ADR_VILID').asinteger := iIdVille;
      Que_GenAdresse.FieldByName('ADR_TEL').asstring := '';
      Que_GenAdresse.FieldByName('ADR_FAX').asstring := '';
      Que_GenAdresse.FieldByName('ADR_EMAIL').asstring := '' ;
      Que_GenAdresse.Post;
    end;

    Result := Que_GenAdresse.FieldByName('ADR_ID').AsInteger;

  Except
    on E:Exception do Fmain.trclog('XErreur dans GetAddresseId : '+e.message);
  end;
end;

function TDm_Reservation.GetCiviliteId(const sNomCivilite: String): integer;
begin
  try
  try
    if Que_Civilite.Active then
      Que_Civilite.Close();

    Que_Civilite.Open();

    if Que_Civilite.Locate('CIV_NOM', sNomCivilite, [loCaseInsensitive]) then
    begin
      Que_Civilite.Append();
      Que_Civilite.FieldByName('CIV_NOM').AsString  := sNomCivilite;
      Que_Civilite.Post();
    end;

    Result := Que_Civilite.FieldByName('CIV_ID').AsInteger;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetCiviliteId : '+e.message);
  end;
  finally
    // il faut laisser la requete ouverte sinon ca ne pose pas le cache
    // Que_Civilite.Close();
  end;
end;


function TDm_Reservation.GetIdTO(const sNomTO: String; const IdMag: Integer): integer;
begin
  try
  try
    if Que_ClientTO.Active then
      Que_ClientTO.Close();

    Que_ClientTO.ParamByName('CLTNOM').AsString := AnsiUpperCase(sNomTO);
    Que_ClientTO.Open();

    if Que_ClientTO.IsEmpty() then
    begin
      Que_ClientTO.Append();

      Que_ClientTO.FieldByName('CLT_NOM').AsString              := AnsiUpperCase(sNomTO);
      Que_ClientTO.FieldByName('CLT_TYPE').AsInteger            := 1;
      Que_ClientTO.FieldByName('CLT_CLIPROLOCATION').AsInteger  := 1;
      Que_ClientTO.FieldByName('CLT_BL').AsInteger              := 1;
      Que_ClientTO.FieldByName('CLT_NUMERO').AsString           := GetChronoClient();
      Que_ClientTO.FieldByName('CLT_MAGID').AsInteger           := IdMag;

      Que_ClientTO.Post();
    end;

    Result := Que_ClientTO.FieldByName('CLT_ID').AsInteger;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetIdTO : '+e.message);
  end;
  finally
    // il faut laisser la requete ouverte sinon ca ne pose pas le cache
    // Que_ClientTO.Close();
  end;
end;

function TDm_Reservation.GetChronoClient: String;
begin
  //---Num Chrono---
  try
    With IbStProc_Client do
    begin
      Close;
      IbStProc_Client.Prepared := True;
      IbStProc_Client.ExecProc;
      Result := IbStProc_client.Fields[0].AsString;
      IbStProc_Client.Close;
      IbStProc_Client.Unprepare;
    end;
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetChronoClient : '+e.message);
  end;
end;

function Tdm_reservation.GetPrdId(OCC_MTYID, OCC_IDCENTRALE, RLO_OPTION: integer; var iLocType : Integer): Integer;
begin
  Result := -1;
  iLocType := -1;

  try
    Que_LOCOCRELATION.Close;
    Que_LOCOCRELATION.SQL.Clear;
    Que_LOCOCRELATION.SQL.Add('Select LOCCENTRALEOC.*,LOCOCRELATION.*, LOCPARAMNONKE.LPE_TYPE');
    Que_LOCOCRELATION.SQL.Add('from  LOCCENTRALEOC');
    Que_LOCOCRELATION.SQL.Add(' join LOCOCRELATION on OCC_ID = RLO_OCCID');
    Que_LOCOCRELATION.SQL.Add(' join k on k_id = OCC_id and K_enabled = 1');
    Que_LOCOCRELATION.SQL.Add(' join k on k_id = RLO_ID and k_enabled = 1');
    Que_LOCOCRELATION.SQL.Add(' join LOCPRODUIT on PRD_ID = RLO_PRDID');
    Que_LOCOCRELATION.SQL.Add(' join LOCNKCOMPOSITION on COM_ID = PRD_COMID');
    Que_LOCOCRELATION.SQL.Add(' join LOCPARAMNONKE on LPE_ID = COM_LPEID');
    Que_LOCOCRELATION.SQL.Add('Where OCC_MTYID = :PMtyID');
    Que_LOCOCRELATION.SQL.Add('  and OCC_IDCENTRALE = :PIdCent');
    Que_LOCOCRELATION.SQL.Add('  and RLO_OPTION = :POpt');
    Que_LOCOCRELATION.ParamCheck := True;
    Que_LOCOCRELATION.ParamByName('PMtyID').AsInteger  := OCC_MTYID;
    Que_LOCOCRELATION.ParamByName('PIdCENT').AsInteger := OCC_IDCENTRALE;
    Que_LOCOCRELATION.ParamByName('Popt').AsInteger    := RLO_OPTION;

    Que_LOCOCRELATION.Open;

    if Que_LOCOCRELATION.RecordCount = 1 then
    begin
      Result := Que_LOCOCRELATION.FieldByName('RLO_PRDID').AsInteger;
      iLocType := Que_LOCOCRELATION.FieldByName('LPE_TYPE').AsInteger;
    end;

  except
    on e:exception do Fmain.trclog('XErreur dans GetPrdId : '+e.message);
  end;
end;

function TDm_Reservation.InsertGENIMPORT(iIMPGINKOIA, iIMPKTBID,
  iIMPNUM: integer; sIMPREFSTR: String; iIMPREF: Integer): Boolean;
begin
  Result := True;
  Try
    With Que_GENIMPORT do begin
      Close;
      Open;
      Append;
      FieldByName('IMP_GINKOIA').asinteger := iIMPGINKOIA;
      FieldByName('IMP_KTBID').asinteger := iIMPKTBID;
      FieldByName('IMP_NUM').asinteger := iIMPNUM;
      FieldByName('IMP_REFSTR').asstring := sIMPREFSTR;
      FieldByName('IMP_REF').asinteger := iIMPREF;
      Post;
    End;
  Except
    on E:Exception do begin
      Result := False;
      Fmain.trclog('XErreur dans InsertGENIMPORT : '+e.message);
    end;
  end;
end;

function Tdm_reservation.DeleteGENIMPORT(iIMPGINKOIA, iIMPKTBID, iIMPNUM: integer): Boolean;
var
  iIdGenImp : Integer;
begin
  Result := True;
  Try
    //Suppression de GENIMPORT
    Que_TmpNoEvent.Close;
    Que_TmpNoEvent.SQL.Clear;
    Que_TmpNoEvent.SQL.Add('select * from genimport');
    Que_TmpNoEvent.SQL.Add('where imp_num = :IMPNUM');
    Que_TmpNoEvent.SQL.Add('  and imp_ktbid = :IMPKTBID');
    Que_TmpNoEvent.SQL.Add('  and imp_ginkoia = :IMPGINKOIA');

    Que_TmpNoEvent.ParamByName('IMPNUM').AsInteger := iIMPNUM;
    Que_TmpNoEvent.ParamByName('IMPKTBID').AsInteger := iIMPKTBID;
    Que_TmpNoEvent.ParamByName('IMPGINKOIA').AsInteger := iIMPGINKOIA;

    Que_TmpNoEvent.Open;

    if Que_TmpNoEvent.Recordcount <> 0 then
    begin
      iIdGenImp := Que_TmpNoEvent.FieldByName('imp_id').AsInteger;

      // Mise à jour de K
      Que_TmpLoc2.Close;
      Que_TmpLoc2.SQL.Clear;
      Que_TmpLoc2.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(iIdGenImp) + ', 1)');
      Que_TmpLoc2.ExecSQL;


      // Suppression dans GENIMPORT
      Que_TmpLoc2.Close;
      Que_TmpLoc2.SQL.Clear;
      Que_TmpLoc2.SQL.Add('DELETE FROM GENIMPORT');
      Que_TmpLoc2.SQL.Add(' WHERE IMP_ID = ' + IntToStr(iIdGenImp));
      Que_TmpLoc2.ExecSQL;
    end;

  Except
    on E:Exception do begin
      Result := False;
      Fmain.trclog('XErreur dans DeleteGENIMPORT : '+e.message);
    end;
  end;
end;

function TDm_Reservation.InsertCLTMEMBREPRO(iPRMCLTIDPRO,
  iPRMCLTIDPART: Integer): Boolean;
begin
  Result := True;
  try
    With Que_CltTo do begin
      Close;
      ParamCheck := True;
      ParamByName('cltid').AsInteger := iPRMCLTIDPART;
      Open;
      Append;
      FieldByName('PRM_CLTIDPRO').AsInteger := iPRMCLTIDPRO;
      FieldByName('PRM_CLTIDPART').AsInteger := iPRMCLTIDPART;
      Post;
    end;
  Except
    On E:Exception do begin
      Result := False;
      Fmain.trclog('XErreur dans InsertCLTMEMBREPRO : '+e.message);
    end;
  end;
end;



function Tdm_reservation.InsertCLTMEMBREPRO_ENMIEUX(iPRMCLTIDPRO, iPRMCLTIDPART: Integer): Boolean;
var
  bAdd : boolean;
  bUpdate : Boolean;
begin
  Result := True;
  bAdd := False;
  bUpdate := False;
  try
    Que_CltTo.Close;
    Que_CltTo.ParamCheck := True;
    Que_CltTo.ParamByName('cltid').AsInteger := iPRMCLTIDPART;
    Que_CltTo.Open;
    bAdd := Que_CltTo.RecordCount=0;
    if not bAdd then
      bUpdate := not Que_CltTo.Locate('PRM_CLTIDPRO', iPRMCLTIDPRO, []);
    // si on ne trouve pas on l'ajoute
    if bAdd then
    begin
      Que_CltTo.Append;
      Que_CltTo.FieldByName('PRM_CLTIDPRO').AsInteger := iPRMCLTIDPRO;
      Que_CltTo.FieldByName('PRM_CLTIDPART').AsInteger := iPRMCLTIDPART;
      Que_CltTo.FieldByName('PRM_DEBUT').AsDateTime := Now;
      Que_CltTo.Post;
    end
    else if bUpdate then
    begin
      Que_CltTo.Edit;
      Que_CltTo.FieldByName('PRM_CLTIDPRO').AsInteger := iPRMCLTIDPRO;
      Que_CltTo.FieldByName('PRM_DEBUT').AsDateTime := Now;
      Que_CltTo.Post;      
    end;
  Except
    On E:Exception do begin
      Result := False;
      Fmain.trclog('XErreur dans InsertCLTMEMBREPRO_ENMIEUX : '+e.message);
    end;
  end;
end;

function TDm_Reservation.InsertCodeBarre(iIdClient: Integer): Boolean;
begin
  try
    With Que_CodeBarre do
    begin
      Close;
      ParamCheck := True;
      ParamByName('CLTID').AsInteger := iIdClient;
      Open;

      if recordcount > 0 then
        Edit
      else begin
        Append;
        FieldByName('CBI_CB').asstring := GetCodeBarre;
        FieldByName('CBI_TGFID').asInteger := 0;
        FieldByName('CBI_COUID').asInteger := 0;
        FieldByName('CBI_TYPE').asInteger := 2;
        FieldByName('CBI_ARFID').asInteger := 0;
        FieldByName('CBI_ARLID').asInteger := 0;
      end;

      FieldByName('CBI_CLTID').asInteger := iIdClient;
      Post;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans InsertCodeBarre : '+e.message);
  end;
end;

function Tdm_reservation.InsertCodeBarreFidelite(iIdClient: Integer; sCBFidelite: String): Boolean;
begin
  Result := False;
  try
    if sCBFidelite <> '' then
    begin
      // Est-ce que le client a déjà un code barre fidélité ?
      Que_CodeBarreFidelite.Close;
      Que_CodeBarreFidelite.ParamCheck := True;
      Que_CodeBarreFidelite.ParamByName('CLTID').AsInteger := iIdClient;
      Que_CodeBarreFidelite.Open;

      if Que_CodeBarreFidelite.RecordCount > 0 then
      begin
        // Le client a déjà un code barre fidélité, on ne fait rien
        Que_CodeBarreFidelite.Close;
        Fmain.trclog('TLe client ' + IntToStr(iIdClient) + ' a déjà un code barre fidélité.');
      end
      else
      begin
        // Le client n'a pas de code barre fidélité
        // Vérification du format du code barre
        if (Length(sCBFidelite) = 16) and (luhn(sCBFidelite)) then
        begin
          // Vérification si le CB fidélité n'appartient pas à un autre client
          Que_CodeBarreFideliteExiste.Close;
          Que_CodeBarreFideliteExiste.ParamByName('CB').AsString := sCBFidelite;
          Que_CodeBarreFideliteExiste.Open;

          if (not Que_CodeBarreFideliteExiste.IsEmpty)
            and (Que_CodeBarreFideliteExiste.FieldByName('CBI_CLTID').AsInteger <> iIdClient) then
          begin
            // Le code barre existe sur un autre client, on ne fait rien
            Que_CodeBarreFideliteExiste.Close;
            Fmain.trclog('TLe code barre fidélité ' + sCBFidelite + ' appartient déjà à un autre client.');
          end
          else
          begin
            // On ajoute le code barre au client
            Que_CodeBarreFidelite.Append;
            Que_CodeBarreFidelite.FieldByName('CBI_CB').asstring := sCBFidelite;
            Que_CodeBarreFidelite.FieldByName('CBI_TGFID').asInteger := 0;
            Que_CodeBarreFidelite.FieldByName('CBI_COUID').asInteger := 0;
            Que_CodeBarreFidelite.FieldByName('CBI_TYPE').asInteger := 5;
            Que_CodeBarreFidelite.FieldByName('CBI_ARFID').asInteger := 0;
            Que_CodeBarreFidelite.FieldByName('CBI_ARLID').asInteger := 0;
            Que_CodeBarreFidelite.FieldByName('CBI_CLTID').asInteger := iIdClient;
            Que_CodeBarreFidelite.Post;
            Fmain.trclog('TAjout du code barre fidélité ' + sCBFidelite);

            Result := True;
          end;
        end
        else
        begin
          Fmain.trclog('TLe code barre fidélité ' + sCBFidelite + ' n''a pas le bon format.');
        end;
      end;
    end;
  except
    on e:exception do Fmain.trclog('XErreur dans InsertCodeBarreFidelite : '+e.message);
  end;
end;

function Tdm_reservation.Luhn(const aCB: string): boolean;
var
  i, iSum: integer;
  Nombre : Integer;
begin
  iSum := 0;     // Formule de Luhn
  for i:= length(aCB) downto 1 do
  begin
    if ((length(aCB) - i) mod 2 = 0) then
      iSum := iSum + StrToInt(aCB[i])
    else
    begin
      Nombre := StrToInt(aCB[i]) * 2;
      if Nombre > 9 then
        iSum := iSum + ((Nombre - (Nombre mod 10)) div 10) + (Nombre mod 10)
      else
        iSum := iSum + Nombre;
    end;
  end;

  if iSum mod 10 = 0 then
    Result := True
  else
    Result := False;
end;

procedure Tdm_reservation.MappingOffresSkimium(aNewMtyId: integer);
var
  Old_MtyId: Integer;
  i, NewId, NewOccId: Integer;
begin
  // On récupère le MTY_ID du module de réservation SKIMIUM mode Mail
  Old_MtyId := GetGenTypeMail('RESERVATION SKIMIUM');
  if (Old_MtyId > -1) then
  begin
    // On récupère les offres centrales du module SKIMIUM mode Mail
    Que_TmpNoEvent.Close;
    Que_TmpNoEvent.SQL.Clear;
    Que_TmpNoEvent.SQL.Add('select OCC_IDCENTRALE, RLO_OPTION, RLO_PRDID');
    Que_TmpNoEvent.SQL.Add('from LOCCENTRALEOC join k on k_id = OCC_ID and k_enabled = 1');
    Que_TmpNoEvent.SQL.Add('join lococrelation on RLO_OCCID = OCC_ID');
    Que_TmpNoEvent.SQL.Add('join k on k_id = RLO_ID and k_enabled = 1');
    Que_TmpNoEvent.SQL.Add('where OCC_MTYID = :MtyId');
    Que_TmpNoEvent.SQL.Add('order by OCC_IDCENTRALE, RLO_OPTION');
    Que_TmpNoEvent.ParamCheck := True;
    Que_TmpNoEvent.ParamByName('MtyId').asInteger := Old_MtyId;
    Que_TmpNoEvent.Open;

    if not Que_TmpNoEvent.Eof then
    begin
      Que_TmpNoEvent.First;

      Que_CreateOCRelation.Close;
      Que_CreateOCRelation.ParamCheck := True;
      Que_CreateOCRelation.Open;

      try
        while not Que_TmpNoEvent.Eof do
        begin
          // Pour chaque offre centrale du module SKIMIUM mode Mail

          NewId := CorrespondanceWithNewId(Que_TmpNoEvent.FieldByName('OCC_IDCENTRALE').asInteger,
            Que_TmpNoEvent.FieldByName('RLO_OPTION').asInteger);
          if (NewId > -1) then
          begin
            // Contrôle que l'offre existe déjà en base
            NewOccId := CheckOffreExiste(NewId, aNewMtyId);
            if (NewOccId > -1) then
            begin
              // L'offre existe, on lui assigne le prdid de l'ancienne offre

              Que_CreateOCRelation.Append;
              Que_CreateOCRelation.FieldByName('RLO_OPTION').asinteger := 1;
              Que_CreateOCRelation.FieldByName('RLO_OCCID').asinteger := NewOccId;
              Que_CreateOCRelation.FieldByName('RLO_PRDID').asinteger := Que_TmpNoEvent.FieldByName('RLO_PRDID').asInteger;
              Que_CreateOCRelation.Post;
            end;
          end;

          Que_TmpNoEvent.Next;
        end;

      finally
//        Que_CreateOCRelation.Close;
      end;
    end;
  end;
end;

function TDm_Reservation.GetCodeBarre: String;
begin
  try
    With IbStProc_Codebarre do
    begin
      Close;
      Prepared := true;
      ExecProc;
      Result := IbStProc_Codebarre.Fields[0].asString;
      Close;
      Unprepare;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetCodeBarre : '+e.message);
  end;
end;

function Tdm_reservation.GetComentResa(aMonXml : TmonXML; aReservationXml: TIcXMLElement): String;
var
  sDrive, sPaiement, sGarantieVol, sSecours, sCommentaireClient : String;
  bOption: Boolean;
  sOptions, sNewBalises : String;
begin
  sDrive := '';
  sPaiement := '';
  sGarantieVol := '';
  sSecours := '';
  sCommentaireClient := '';
  bOption := False;
  sOptions := '';
  sNewBalises := '';

  Result := '';

  if assigned(aMonXml.FindTag(aReservationXml,'paiement')) then
  begin
    sPaiement := aMonXml.ValueTag(aReservationXml,'paiement');
    sNewBalises := ParamsStr(RS_TXT_COMENTRESA_PAIEMENT, sPaiement);
  end;

  if assigned(aMonXml.FindTag(aReservationXml,'drive')) then
  begin
    sDrive := aMonXml.ValueTag(aReservationXml,'drive');
    if sDrive = 'O' then
    begin
      sOptions := RS_TXT_COMENTRESA_DRIVE;
      bOption := True;
    end;
  end;

  if assigned(aMonXml.FindTag(aReservationXml,'garantie_vol_casse')) then
  begin
    sGarantieVol := aMonXml.ValueTag(aReservationXml,'garantie_vol_casse');
    if sGarantieVol = 'O' then
    begin
      if sOptions = '' then
        sOptions := RS_TXT_COMENTRESA_GARANTIEVOL
      else
        sOptions := sOptions + ', ' + RS_TXT_COMENTRESA_GARANTIEVOL;
      bOption := True;
    end;
  end;

  if assigned(aMonXml.FindTag(aReservationXml,'secours_rapatriement')) then
  begin
    sSecours := aMonXml.ValueTag(aReservationXml,'secours_rapatriement');
    if sSecours = 'O' then
    begin
      if sOptions = '' then
        sOptions := RS_TXT_COMENTRESA_SECOURS
      else
        sOptions := sOptions + ', ' + RS_TXT_COMENTRESA_SECOURS;
      bOption := True;
    end;
  end;

  if bOption then
  begin
    if sOptions = '' then
      sNewBalises := ParamsStr(RS_TXT_COMENTRESA_OPTIONS, sOptions)
    else
      sNewBalises := sNewBalises + sLineBreak + ParamsStr(RS_TXT_COMENTRESA_OPTIONS, sOptions);
  end;

  if assigned(aMonXml.FindTag(aReservationXml,'commentaire_client')) then
  begin
    sCommentaireClient := aMonXml.ValueTag(aReservationXml,'commentaire_client');
    if sNewBalises = '' then
      sNewBalises := sCommentaireClient
    else
      sNewBalises := sNewBalises + sLineBreak + sCommentaireClient;
  end;

  if sNewBalises <> ''then
    Result := sNewBalises;
end;

function Tdm_reservation.GetComentResaLine(aMonXml: TmonXML; aESkieurXml: TIcXMLElement): String;
begin
  Result := '';

  if assigned(aMonXml.FindTag(aESkieurXml,'age')) then
  begin
    Result := ParamsStr(RS_TXT_COMENTLINE_AGE, aMonXml.ValueTag(aESkieurXml,'age'));
  end;

  if assigned(aMonXml.FindTag(aESkieurXml,'niveau_du_skieur')) then
  begin
    if Result = '' then
      Result := ParamsStr(RS_TXT_COMENTLINE_LEVEL, aMonXml.ValueTag(aESkieurXml,'niveau_du_skieur'))
    else
      Result := Result + sLineBreak + ParamsStr(RS_TXT_COMENTLINE_LEVEL, aMonXml.ValueTag(aESkieurXml,'niveau_du_skieur'))
  end;
end;

function TDm_Reservation.GetLocParamElt(Id: integer; sNom: String): Integer;
begin
  try

    (*
    With Que_LOCPARAMELT do
    begin
      Close;
      ParamCheck := True;
      ParamByName('id').AsInteger := Id;
      ParamByName('Nom').AsString := sNom;
      Fmain.trclog('id='+inttostr(id));
      Fmain.trclog('snom='+snom);
      Open;

      Fmain.trclog('TRecordcount='+inttostr(recordcount));
      if RecordCount = 0 then
      begin
        Append;
        FieldByName('lce_lcpid').AsInteger := Id;
        FieldByName('lce_nom').AsString := sNom;
        Post;
        Fmain.trclog('T>>>>Ajout '+sNom+' id='+inttostr(Id)+' << '+inttostr(FieldByName('lce_id').AsInteger));
      end;
      Result := FieldByName('lce_id').AsInteger;
    end;
    *)

    Que_TmpNoEvent.Close;
    Que_TmpNoEvent.SQL.Clear;
    Que_TmpNoEvent.SQL.Add('select lce_id,lce_nom,lce_lcpid from locparamelt');
    Que_TmpNoEvent.SQL.Add(' where lce_lcpid='+inttostr(Id));
    Que_TmpNoEvent.SQL.Add('  and lce_nom='+QuotedStr(snom));
    Que_TmpNoEvent.Open;

    //main.trclog('Tid='+inttostr(id));
    //main.trclog('Tsnom='+snom);
    //main.trclog('TRecordcount='+inttostr(Que_TmpNoEvent.recordcount));
    if Que_TmpNoEvent.Recordcount = 0 then begin
      With Que_LOCPARAMELT do
      begin
        Close;
        ParamCheck := True;
        ParamByName('id').AsInteger := 0;
        ParamByName('Nom').AsString := '';
        Open;
        Append;
        FieldByName('lce_lcpid').AsInteger := Id;
        FieldByName('lce_nom').AsString := sNom;
        Post;
        //main.trclog('T>>>>Ajout '+sNom+' id='+inttostr(Id)+' << '+inttostr(FieldByName('lce_id').AsInteger));
        Result := FieldByName('lce_id').AsInteger;
      end;
    end
    else begin
      Result := Que_TmpNoEvent.FieldByName('lce_id').AsInteger;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetLocParamElt : '+e.message);
  end;
end;

function TDm_Reservation.UpdateCLTMEMBREPRO(iPRMCLTIDPRO,
  iPRMCLTIDPART: Integer): Boolean;
begin
  try
    With Que_CltTo do
    begin
      Close;
      ParamCheck := True;
      ParamByName('cltid').AsInteger := iPRMCLTIDPART;
      Open;

      if RecordCount > 0 then
      begin
        Edit;
        FieldByName('PRM_CLTIDPRO').AsInteger := iPRMCLTIDPRO;
        Post;
      end
      else
        InsertCLTMEMBREPRO(iPRMCLTIDPRO,iPRMCLTIDPART);
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans UpdateCLTMEMBREPRO : '+e.message);
  end;
end;

function Tdm_reservation.UpdateContactClient(aAdrId: Integer; aEMail, aPhone: string): Boolean;
var
  vClient: TClient;
begin
  Result := False;

  Fmain.trclog('T> Traitement des contacts client');

  if ((aEmail <> '') or (aPhone <> '')) then
  begin
    try
      Fmain.trclog('T> Contacts Ok');

      if (aAdrId > 0) then
      begin
        // L'adresse est déjà créée, on ouvre la query
        Que_GenAdresse.Close;
        Que_GenAdresse.ParamCheck := True;
        Que_GenAdresse.ParamByName('adrid').AsInteger := aAdrId;
        Que_GenAdresse.Open;

        if not Que_GenAdresse.Eof then
        begin
          Que_GenAdresse.Edit;
        end;

        if Que_GenAdresse.State in [dsEdit, dsInsert] then
        begin
          Fmain.trclog('T> Contacts Ok : Mise à jour du client');

          if (aEmail <> '') then
            Que_GenAdresse.FieldByName('ADR_EMAIL').asstring := aEMail;
          if (aPhone <> '') then
            Que_GenAdresse.FieldByName('ADR_GSM').asstring := aPhone;

          Que_GenAdresse.Post;
          Result := True;
        end;
      end;
    except
      on e:exception do Fmain.trclog('XErreur dans UpdateContactClient : '+e.message);
    end;
  end;
end;

function Tdm_reservation.UpdateVoucherClient(aId: Integer; const iDureeVO: Integer; const tDebutSejourVO, tDureeVODate: TDateTime): Boolean;
begin
  Result := False;

  try
//    Que_Client.Close;
//    Que_Client.ParamCheck := true;
//    Que_Client.ParamByName('cltid').AsInteger := aId;
//    Que_Client.Open;
//
//    if not Que_Client.Eof then

    if Que_Client.FieldByName('CLT_ID').asInteger = aId then
    begin
      Que_Client.Edit;
      Que_Client.FieldByname('CLT_DUREEVO').asinteger := iDureeVO;
      Que_Client.FieldByname('CLT_DEBUTSEJOURVO').AsDateTime := tDebutSejourVO;
      Que_Client.FieldByname('CLT_DUREEVODATE').AsDateTime := tDureeVODate;
      Que_Client.Post;

      Result := True;
    end;
  except
    on e:exception do Fmain.trclog('XErreur dans UpdateVoucherClient : '+e.message);
  end;
end;

function TDm_Reservation.GetProcChrono: String;
begin
  try
    With IbStProc_Chrono do begin
      Try
        Close;
        Prepared := true;
        ExecProc;
        Result := Fields[0].asString;
      finally
        Close;
        Unprepare;
      end;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetProcChrono : '+e.message);
  end;
end;

function TDm_Reservation.InsertReservation(iIdClient, iIdPro, iEtat, iPaiement, iMagId : Integer;
  sAccompte, sComment, sNum, sNoWeb, sRemise, sMontantPrev : String; dResaDebut, dResaFin : TDateTime; IdCentrale : Integer; ArrhesCom, ArrehseAco, IdWeb : String;
  bComentRemise: Boolean) : Integer;
var
  fRemise : currency;
  sRemiseText : String;
begin
  try
    Que_Resa.Close;
    Que_Resa.Open;

    Que_Resa.Append;
    Que_Resa.FieldByName('RVS_CLTID').asinteger := iIdClient;
    Que_Resa.FieldByName('RVS_ORGCLTID').asinteger := iIdPro;
    Que_Resa.FieldByName('RVS_DATE').AsDateTime := Now;
    Que_Resa.FieldByName('RVS_ETATRESRID').AsInteger := iEtat;
    Que_Resa.FieldByName('RVS_ETATPESRID').AsInteger := iPaiement;
    Que_Resa.FieldByName('RVS_ACCOMPTE').AsFloat := StrToFloatDef(sAccompte,0);//SK7
    Que_Resa.FieldByName('RVS_MAGID').asinteger := iMagId;
    Que_Resa.FieldByName('RVS_NUMERO').asString := sNum;
    Que_Resa.FieldByName('RVS_NUMEROWEB').asinteger := 0;
    Que_Resa.FieldByName('RVS_NUMEROWEBSTRING').AsString := sNoWeb;
    Que_Resa.FieldByName('RVS_ETATATOSESRID').asinteger := 0;
    Que_Resa.FieldByName('RVS_TRANSACTIONID').asinteger := 0;
    Que_Resa.FieldByName('RVS_ORIGINAMOUNT').asfloat := 0;
    Que_Resa.FieldByName('RVS_REPONSECODE').asinteger := 0;
    Que_Resa.FieldByName('RVS_DEBUT').AsDateTime := dResaDebut;
    Que_Resa.FieldByName('RVS_FIN').AsDateTime := dResaFin;
    Que_Resa.FieldByName('RVS_MTYID').asinteger := IdCentrale;
    Que_Resa.FieldByName('RVS_IDWEBSTRING').AsString := IdWeb;

    if Assigned(Que_Resa.FindField('RVS_COMMI')) then
    begin
      Que_Resa.FieldByName('RVS_COMMI').AsFloat := StrToFloatDef(ArrhesCom, 0);
      Que_Resa.FieldByName('RVS_ARRHE').AsFloat := StrToFloatDef(ArrehseAco, 0);
    end;

    if bComentRemise then
    begin
      sRemiseText := '';
      fRemise := StrToFloatDef(sRemise,0.00);
      IF fRemise <> 0 THEN
      BEGIN
        fRemise := 100 * (1 - fRemise) ;
        sRemiseText :=  #10 + ParamsStr(RS_TXT_RESADM_REMISETTPC,FloatToStr(fRemise)); // 'Remise total : §0%'
      END;
      Que_Resa.FieldByName('RVS_COMENT').asstring := LeftStr(sComment + sRemiseText, 1024);
    end
    else
    begin
      Que_Resa.FieldByName('RVS_COMENT').asstring := LeftStr(sComment, 1024);
    end;
      
    Que_Resa.FieldByName('RVS_MONTANTPREV').AsFloat := ConvertStrToFloat(sMontantPrev);

    Que_Resa.Post;
    Result := Que_Resa.FieldByName('RVS_ID').AsInteger;
  except
    on e:exception do Fmain.trclog('XErreur dans InsertReservation : '+e.message);
  end;
end;

function TDm_Reservation.IsOCParamExist(OCC_MTYID, OCC_IDCENTRALE,
  RLO_OPTION: integer): Boolean;
begin
  try
    Que_LOCOCRELATION.Close;
    Que_LOCOCRELATION.SQL.Clear;
    Que_LOCOCRELATION.SQL.Add('Select LOCCENTRALEOC.*,LOCOCRELATION.* from  LOCCENTRALEOC');
    Que_LOCOCRELATION.SQL.Add(' join LOCOCRELATION on OCC_ID = RLO_OCCID');
    Que_LOCOCRELATION.SQL.Add(' join k on k_id = OCC_id and K_enabled = 1');
    Que_LOCOCRELATION.SQL.Add(' join k on k_id = RLO_ID and k_enabled = 1');
    Que_LOCOCRELATION.SQL.Add('Where OCC_MTYID = :PMtyID');
    Que_LOCOCRELATION.SQL.Add('  and OCC_IDCENTRALE = :PIdCent');
    Que_LOCOCRELATION.SQL.Add('  and RLO_OPTION = :POpt');
    Que_LOCOCRELATION.ParamCheck := True;
    Que_LOCOCRELATION.ParamByName('PMtyID').AsInteger  := OCC_MTYID;
    Que_LOCOCRELATION.ParamByName('PIdCENT').AsInteger := OCC_IDCENTRALE;
    Que_LOCOCRELATION.ParamByName('Popt').AsInteger    := RLO_OPTION;

    Que_LOCOCRELATION.Open;

    if Que_LOCOCRELATION.Recordcount > 0 then
    begin
      //PDB pour contrôle CVI sur nomenclature
      if Que_LOCOCRELATION.FieldByName('RLO_PRDID').AsInteger > 0
        then iPrdId := Que_LOCOCRELATION.FieldByName('RLO_PRDID').AsInteger
        else iPrdId := -1;
      Result := (Que_LOCOCRELATION.FieldByName('RLO_PRDID').AsInteger <> 0)
    end
    else
    begin
      Result := False;
    end;
  except
    on e:exception do Fmain.trclog('XErreur dans IsOCParamExist : '+e.message);
  end;
end;


//CVI - Pour contrôle de validité de nomenclature (Type, Catégorie, CA)
function Tdm_reservation.CheckNomenclature(aPrdId: Integer): String;
begin
  //Initialisation
  Result := '';

  // on se place sur l'offre magasin sélectionnée
  Que_OffreMag.Close;
  Que_OffreMag.ParamByName('PRDID').AsInteger := aPrdId;
  Que_OffreMag.Open;

  if Que_OffreMag.RecordCount > 0 then
  begin
    // On regarde si il y a des types associés
    Que_TypeAssocie.Close;
    Que_TypeAssocie.ParamByName('PRDCOMID').AsInteger := Que_OffreMagPRD_COMID.AsInteger;
    Que_TypeAssocie.Open;

    if Que_TypeAssocie.RecordCount > 0 then
    begin
      // Pour chaque type associé
      Que_TypeAssocie.First;

      while not Que_TypeAssocie.Eof do
      begin
        // On regarde si il y a une catégorie associée
        Que_CategorieAssocie.Close;
        Que_CategorieAssocie.ParamByName('TYCID').AsInteger := Que_TypeAssocieTYC_ID.AsInteger;
        Que_CategorieAssocie.Open;

        // Si pas de catégorie
        if Que_CategorieAssocie.RecordCount = 0 then
        begin
          // Erreur pas de catégorie
          Result := Que_OffreMagPRD_NOM.asString + ' : Erreur de paramétrage de nomenclature';
          Exit;
        end

        // On regarde le % de CA
        else
        begin
          if Que_TypeAssocieTYC_RAT.AsFloat = 0 then
          begin
            // Erreur % du CA à 0
            Result := Que_OffreMagPRD_NOM.asString + ' : Erreur de paramétrage de nomenclature';
            Exit;
          end;
        end;
        Que_TypeAssocie.Next;
      end;
    end
    else
    begin
      // Erreur pas de type associé
      Result := Que_OffreMagPRD_NOM.asString + ' : Erreur de paramétrage de nomenclature';
      Exit;
    end;
  end
  else
  begin
    // Erreur pas d'offre magasin trouvée
    Result := 'Erreur offre magasion non trouvée';
    Exit;
  end;
end;


function TDm_Reservation.InsertResaLigne(MaCentrale : TGENTYPEMAIL;iIdResa, iIdWeb, iResaCasque, iResaMulti,
  iResaGarantie, iPrId: Integer; sResaIdent, sResaRemise, sResaPrix, sComent : String; dResaDebut,
  dResaFin: TDateTime; bInterSport : Boolean; sISComent : String; iAppelWS : Integer; aCAMAgasin: Currency): Integer;
var
  dPrix, dRemise : Double;
begin
  try
    // Initialisation
    dPrix := 0;
    dRemise := 0;
    Result := -1;

    With Que_resal do
    begin
      Close;
      Open;

      Append;
      FieldByName('RSL_RVSID').AsInteger  := iIdResa;
      FieldByName('RSL_DEBUT').AsDateTime := dResaDebut;
      FieldByName('RSL_FIN').AsDateTime   := dResaFin;
      FieldByName('RSL_CASQUE').AsInteger := iResaCasque;
      FieldByName('RSL_MULTI').AsInteger := iResaMulti;

      // Modif Mantis 7485 - Ne plus redescendre la garantie dans les résa Sport2000
      if MaCentrale.MTY_CODE = 'R2K' then
        FieldByName('RSL_GARANTIE').AsInteger := 0
      else
        FieldByName('RSL_GARANTIE').AsInteger := iResaGarantie;

      FieldByName('RSL_PRDID').AsInteger := iPrId;
      FieldByName('RSL_WEBID').AsInteger := iIdWeb;
      FieldByName('RSL_WSDONE').AsInteger := iAppelWS;
      FieldByName('RSL_CAMAGASIN').asFloat := aCAMAgasin;

      if not bInterSport then
      begin
        case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7','RNS','RSKAPI']) of
          // Twinner, Sport2k, Gen1,Gen2,Gen3, Skiset, Netski
          0,2,4,5,6,7,8,9,10: FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXNET,sResaPrix); //  'Prix net : '
          // Skimium / Intersport
          1,3:   FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXBRUT, sResaPrix); // 'Prix Brut : '
        end;
  //      FieldByName('RSL_COMENT').asstring := 'Prix Brut : ' + sResaPrix;
        if sResaRemise <> '' then
        begin
          case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7','RNS','RSKAPI']) of
            // Twinner , Intersport, Gosport
            0,3,7  :   FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_REMISEPC, sResaRemise); // 'Remise : §0%'
            //Skiset, Netski
            8,9,10 : FieldByName('RSL_COMENT').asstring := 'Payé en ligne';
            // Skimium
            1      :   FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_PRIXNET, floatToStr(RoundRv(strTofloat(sResaRemise),2))); // 'Remise : §0%'
            // Sport2k, Gen1,Gen2,Gen3
            2,4,5,6: FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_REMISEEUR,sResaRemise); // 'Remise : §0€'
          end;
        end;

        // Modif Mantis 7485 - Ne plus redescendre la garantie dans les résa Sport2000 - Saisie de l'info dans le commentaire
        if (MaCentrale.MTY_CODE = 'R2K') and (iResaGarantie = 1)  then
        begin
          FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + RS_TXT_RESADM_GARANTIE; // 'Garantie'
        end;

        if (sComent <> '') then
        begin
          case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7','RNS','RSKAPI']) of
            // Skimium
            1 : FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + sLineBreak + sComent;
          end;
        end;
      end
      else begin
        FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + sISComent;
      end;

      dPrix := ConvertStrToFloat(sResaPrix);

      // Skimium / Intersport
      if Trim(sResaRemise) <> '' then
      begin
        dRemise := (dPrix * ConvertStrToFloat(sResaRemise)) / 100;
      end;

      case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7','RNS','RSKAPI']) of
        // Twinner, Sport2k, Gen1,Gen2,Gen3, Skiset, Netski
        0,2,4,5,6,7,8,9,10 : FieldByName('RSL_PXNET').AsFloat := dPrix;
        // Skimium
        1        : FieldByName('RSL_PXNET').AsFloat := ConvertStrToFloat(sResaRemise);
        // Intersport
        3        : FieldByName('RSL_PXNET').AsFloat := dPrix - dRemise;
      end;
      FieldByName('RSL_IDENT').asstring := sResaIdent;
      Post;

      Result := FieldByName('RSL_ID').AsInteger;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans InsertResaLigne : '+e.message);
  end;
end;



function TDm_Reservation.InsertResaSousLigne(iIdResaL, iTCAID,
  iLCEID: Integer): integer;
begin
  try
    if not(Que_Resasl.Active) then
      Que_Resasl.Open;

    Que_Resasl.Append;
    Que_Resasl.FieldByName('RSE_RSLID').AsInteger := iIdResaL;
    Que_Resasl.FieldByName('RSE_CALID').AsInteger := 0;
    Que_Resasl.FieldByName('RSE_TCAID').AsInteger := iTCAID;
    Que_Resasl.FieldByName('RSE_LCEID').AsInteger := iLCEID;
    Que_Resasl.Post;
  except
    on e:exception do Fmain.trclog('XErreur dans InsertResaSousLigne : '+e.message);
  end;
end;



function TDm_Reservation.AnnulResa : Boolean;
var
  iEtat : Integer;
begin
  Result := True;

  try
  // 'Traitement des annulations de réservations en cours'
  //  InitGaugeMessHP (RS_TXT_RESADM_ANNULINPROGRESS, MemD_Mail.RecordCount + 1, true, 0, 0, '', false) ;

  try

    With MemD_Mail do
    begin
      First;
      Dm_Main.StartTransaction;

      while not EOF do
      begin
        if FieldByName('bAnnulation').AsBoolean then
        begin
          Fmain.trclog('TAnnulation pour résa '+MemD_Mail.FieldByName('MailIdResa').AsString);
          // récupération de l'id de l'état "Annulée"
          iEtat := GetEtat(7, 0);

          Que_UpdResa.Close;
          Que_UpdResa.ParamByName('PIdResa').AsString := MemD_Mail.FieldByName('MailIdResa').AsString;
          Que_UpdResa.Open;

          if Que_UpdResa.RecordCount > 0 then
          begin
            // Mise à jours de l'état de la réservation
            Que_UpdResa.Edit;
            Que_UpdResa.FieldByName('RVS_ETATRESRID').AsInteger := iEtat;
            Que_UpdResa.Post;

            OutputDebugString(PChar(Format('RVS_NUMEROWEBSTRING = %s - RVS_ETATRESRID = %d',
              [Que_UpdResa.FieldByName('RVS_NUMEROWEBSTRING').AsString, Que_UpdResa.FieldByName('RVS_ETATRESRID').AsInteger])));
            Fmain.trclog('RAnnulation réussie');
            inc(cpt_r);
          end

          else begin

            //PDB - contredire l'archivage par défault pour être libre de décider
            // dans la fenêtre de diagnostic.
            Edit;
            FieldByName('bArchive').AsBoolean := false;
            Post;

            Fmain.trclog('FRéservation inexistante pour annulation');

          end;

         { With IBStProc_DeleteReservation do
          begin
            Close;
            ParamByName('K_ID').AsInteger := MemD_Mail.FieldByName('MailIdResa').AsInteger;
            ParamByName('SUPRESSION').AsInteger := 1;
            Prepared := True;
            ExecProc;
          end; }
        end;
        Next;
  //      IncGaugeMessHP(1);
      end; // while
      
      Dm_Main.IBOUpDateCache(Que_UpdResa);
      Dm_Main.Commit;
    end;

  Except on E:Exception do
    begin
      Dm_Main.IBOCancelCache(Que_UpdResa);
      Dm_Main.Rollback;
      // 'Erreur lors du traitement des annulations : ', 'Erreur Annulation'
  //    InfoMessHP(RS_ERR_RESADM_ANNULPROGRESSERROR + #13#10 + E.Message,True,0,0, RS_TXT_RESADM_ANNULERROR);
      Fmain.ologfile.Addtext(RS_ERR_RESADM_ANNULPROGRESSERROR +' '+ E.Message);
      //PDB
      Fmain.trclog('X'+RS_ERR_RESADM_ANNULPROGRESSERROR + E.Message);
      Result := False;
      Exit;
    end;
  end;

  finally
   // CloseGaugeMessHP;
  end;
  
end;


function TDm_Reservation.GetClientID(iImpGin: integer): integer;
begin
  try
    With Que_Client do
    begin
      Close;
      ParamCheck := true;
      ParamByName('cltid').AsInteger := iImpGin;
      Open;

      if RecordCount = 0 then
        Result := -1
      else
        Result := FieldByName('CLT_ID').AsInteger;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetClientID : '+e.message);
  end;
end;

function Tdm_reservation.CreateClient(vClient: TClient): Integer;
begin
  try
    Que_Client.Close;
    Que_Client.ParamCheck := true;
    Que_Client.ParamByName('cltid').AsInteger := 0;
    Que_Client.Open;

    Que_Client.Append();
    Que_Client.FieldByName('CLT_NOM').asstring := vClient.Nom;
    Que_Client.FieldByName('CLT_PRENOM').asstring := vClient.Prenom;
    Que_Client.FieldByName('CLT_ADRID').asinteger := vClient.AdresseId;
    Que_Client.FieldByname('CLT_MAGID').asinteger := vClient.MagId;
    Que_Client.FieldByname('CLT_CIVID').asinteger := vClient.Civilite;
    Que_Client.FieldByname('CLT_DUREEVO').asinteger := vClient.DureeVO;
    Que_Client.FieldByname('CLT_DEBUTSEJOURVO').AsDateTime := vClient.DebutSejourVO;
    Que_Client.FieldByname('CLT_DUREEVODATE').AsDateTime := vClient.DureeVODate;
    Que_Client.Post;

    Result := Que_Client.FieldByName('CLT_ID').AsInteger;

  except
    on e:exception do Fmain.trclog('XErreur dans CreateClient : '+e.message);
  end;
end;



function TDm_Reservation.GetMagId(iMtyid: Integer; sIdPresta: String): integer;
begin
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select LOCMAILIDENTMAG.* From LOCMAILIDENTMAG');
      SQL.Add('  join k on k_id = IDM_ID and K_enabled = 1');
      SQL.Add('Where IDM_MTYID  = :PMtyID');
      SQL.Add('  and IDM_PRESTA Like :PPresta');
      ParamCheck := True;
      ParamByName('PMtyId').AsInteger := iMtyid;
      ParamByName('PPresta').AsString := '%' + sIdPresta + '%';
      //trclog('T  >Identification magasin :');
      //trclog('  '+SQL.TEXT);
      //trclog('T   PMtId='+inttostr(iMtyid));
      //trclog('T   PPresta='+'%' + sIdPresta + '%');
      Open;

      Result := FieldByName('IDM_MAGID').AsInteger;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetMagId : '+e.message);
  end;
end;

function TDm_Reservation.IsIdentMagExist(iMtyMulti, iMtyId: integer;
  sIdMag: String): Boolean;
var
  lst :TStringList;
  i : integer;
  bFound : Boolean;
begin
  try
    with Que_IdentMagExist do
    begin
      Close;
      ParamCheck := True;
      ParamByName('PMtyId').AsInteger := iMtyId;
    //  ParamByName('PIdPres').AsString := sIdMag;
      Open;

        bFound := False;
        lst := TStringList.Create;
        try
          while not EOF do
          begin
            lst.Text := FieldByName('IDM_PRESTA').AsString;
            lst.Text := StringReplace(lst.Text,';',#13#10,[rfReplaceAll]);
            // Nettoyage des espaces et caractère spéciaux
            for i := 0 to lst.Count - 1 do
              lst[i] := Trim(lst[i]);
            if lst.IndexOf(Trim(sIdMag)) <> -1 then
            begin
              bFound := True;
              break;
            end;
            Next;
          end;
        finally
          lst.free;
        end;

      // Si on est en mode poste référant
      if iMtyMulti = 0 then
      begin
        // Retourne vrai si Recorcount > 0 sinon false
        Result := bFound;
      end
      else begin
        // sinon on est en mode magasin unique
      //  if RecordCount > 0 then
      //  begin
          // On vérifie que le poste a bien les droits pour traiter les réservations
          Result := (FPOSID = FieldByName('IDM_POSID').AsInteger) and bFound;
     //   end else
     //   Result := False;
      end;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans IsIdentMagExist : '+e.message);
  end;
end;



function TDm_Reservation.CheckOC(MaCentrale: TGENTYPEMAIL): Boolean;
var
  MonXml : TmonXML;
  nArticlesXml: TIcXMLElement;
  eArticleXml : TIcXMLElement;
  sCentraleNom : String;
  icptoc,icptart:integer;
  berreurxml : boolean;
begin
  Fmain.trclog('TDébut traitement des OC');

  try
  try

  Result := True;
  main.bcreation_oc := false;
  main.bparcours_oc := true;
  berreurxml := false;
  MonXml := TmonXML.Create;

  // Si on est pas avec le poste référant on n'intègre pas les offres commerciales
  //if StdGinKoia.PosteID <> GetPostReferantId then
  //  exit;

  With Dm_Reservation do
  //try
    // Ouverture de la table LOCCENTRALEOC pour récpèrer la liste des OC de cette centrale
    Fmain.trclog('TRécupération des OC de la centrale '+MaCentrale.MTY_NOM);
    With Que_LOCCENTRALEOC do
    begin
      Close;
      ParamCheck := True;
      ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
      Open;
    end; // with
    // 'Analyse des pièces jointes en cours'
     Fmain.InitGauge(RS_TXT_RESADM_PJINPROGRESS, MemD_Mail.RecordCount + 1 );
   // InitGaugeMessHP (RS_TXT_RESADM_PJINPROGRESS, MemD_Mail.RecordCount + 1, true, 0, 0, '', false) ;

    Fmain.trclog('TBoucle de parcours des OC');
    icptoc:=0;

    if Que_LOCCENTRALEOC.RecordCount=0 then begin
      Fmain.trclog('AAucune OC -> création initiale');
      bcreation_init_oc := true;
      //exit;
    end;

    with MemD_Mail do
    begin
      First;

      while not EOF do
      begin
        inc(icptoc);
        Fmain.trclog('T>Traitement de l''OC n° '+inttostr(icptoc));

        berreurxml := false;

        try

        // Si bTraiter n'est pas flaggé à vrai c'est que la pièce jointe n'était pas valide
        if FieldByName('bTraiter').AsBoolean then
        begin
          Fmain.trclog('T  Pièce jointe valide, traitement de l''xml');

          // chargement du fichier xml
          //PDB
          try
            MonXml.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
          Except
            on E:Exception do begin
             Fmain.trclog('XErreur XML OC : '+e.message);
             berreurxml := true;
            end;
          end;

          senddebug('TEtat XML?');

          if not berreurxml then
          begin
            senddebug('TXML correct, on traite');
            // Sélection du noeud articles
            nArticlesXml := MonXml.find('/fiche/articles');
            // récupération du 1er article
            eArticleXml  := MonXml.FindTag(nArticlesXml,'article');

            icptart:=0;
            Fmain.trclog('T  Boucle de parcours des articles');

            while eArticleXml <> Nil do
            begin
              inc(icptart);
              Fmain.trclog('T  Traitement de l''article n° '+inttostr(icptart));

              (*
              - Vérification structurelle du XML, que les articles soient des "éléments" et pas des "attributs"
              du noeud Article.
              - Vérification qu'il y a au moins 2 éléments : nom et id_article
              *)

              if (eArticleXml.hasChild) and
                (MonXml.ValueTag(eArticleXml,'nom')<>'') and
                (MonXml.ValueTag(eArticleXml,'id_article')<>'') then
              begin
                Fmain.trclog('T  L''xml de l''article est valide');
                sCentraleNom := MonXml.ValueTag(eArticleXml,'nom');
                if  MonXml.ValueTag(eArticleXml,'categorie') <> '' then
                  sCentraleNom := sCentraleNom  + '(' + MonXml.ValueTag(eArticleXml,'categorie') + ')';

                Fmain.trclog('T  Vérification si l''OC existe pour l''article "'+MonXml.ValueTag(eArticleXml,'nom')+'" (id='+MonXml.ValueTag(eArticleXml,'id_article')+')');
                // Vérification que l'OC existe
                if Que_LOCCENTRALEOC.Locate('OCC_IDCENTRALE',MonXml.ValueTag(eArticleXml,'id_article'),[]) then
                begin
                  // OC Existante
                  // Vérification si nom différent
                  if Uppercase(Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString) <> Uppercase(sCentraleNom) then
                  begin
                    Fmain.trclog('T  Existe déjà, mais le nom est différent -> mise à jour');
                    //  si différent on met à jour
                    Que_LOCCENTRALEOC.Edit;
                    Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString := sCentraleNom;
                    Que_LOCCENTRALEOC.Post;
                  end
                  else Fmain.trclog('T  Existe déjà, avec nom identique');
                end
                else begin
                  // OC inéxistante donc création dans la table
                  // puis passage du resultat à false pour indiquer qu'il y a eu nouvelle création d'OC
                  Fmain.trclog('T  N''existe pas encore -> création');
                  Que_LOCCENTRALEOC.Append;
                  Que_LOCCENTRALEOC.FieldByName('OCC_MTYID').AsInteger     := MaCentrale.MTY_ID;
                  Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString        := sCentraleNom;
                  Que_LOCCENTRALEOC.FieldByName('OCC_IDCENTRALE').AsString := MonXml.ValueTag(eArticleXml,'id_article');
                  Que_LOCCENTRALEOC.Post;

                  Fmain.trclog('TNouvelle OC "'+sCentraleNom+'"');

                  Result := False;
                  main.bcreation_oc := true;

                end;

              end
              else begin
                Fmain.ologfile.Addtext(RS_ERR_RESMAN_OCx+' '+inttostr(icptart));
                //A ce niveau, uniquement dans le tracing et pas dans la fenêtre de diagnotic
                Fmain.trclog('TOC n°'+inttostr(icptart)+' : l''XML pour cet article ne contient pas les éléments requis : nom et/ou id_article -> OC ignorée');
              end;

              // on passe à l'article suivant
              eArticleXml := eArticleXml.nextSibling;
            end;

          end
          else begin
            senddebug('TXML mauvais, on passe cette OC');
          end;

        end;
        (* pas forcément correct : si OC déjà renseignée on sort pour une mauvaise raison
        else begin
          Fmain.trclog('EOC n°'+inttostr(icptoc)+' : OC ignorée car pièce jointe non valide.');
        end;
        *)

        //PDB
        except
          on e:exception do begin
            Fmain.trclog('XErreur dans CheckOC-2 : '+e.message);
            Result := False;
          end;
        end;

        Next;
         Fmain.UpdateGauge ;
     //   IncGaugeMessHP(1);
      end; // while
    end;  // With

  //PDB
  except
    on e:exception do begin
      Fmain.trclog('XErreur dans CheckOC-1 : '+e.message);
      Result := False;
    end;
  end;
  finally
    //CloseGaugeMessHP;
    Fmain.ResetGauge ;
    MonXml.Free;
    main.bparcours_oc := false;
    Fmain.trclog('TFin traitement des OC');
  end; // with /try

end;

function TDm_Reservation.GetDateFromK(sIdResa: String): TDateTime;
begin
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select k_inserted from GENIMPORT');
      SQL.Add('join k on k_id = imp_id');
      SQL.Add('where IMP_REFSTR = ' + QuotedStr(sIdResa));
      SQL.Add('and imp_ktbid = -11111512');
      SQL.Add('and imp_num = 5');
      Open;
      if Recordcount > 0 then
        Result := FieldByName('K_inserted').AsDateTime
      else
        Result := Now;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetDateFromK : '+e.message);
  end;
end;



function TDm_Reservation.GetPostReferantId : integer;
begin
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select max(prm_id) prm_id,prm_string,prm_pos,prm_code from genparam');
      SQL.Add('where prm_code=10009');
      SQL.Add('and prm_type=0');
      SQL.Add('group by prm_id,prm_string,prm_pos,prm_code');
      Open;

      Result := FieldByName('PRM_POS').AsInteger;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetPostReferantId : '+e.message);
  end;
end;



function TDm_Reservation.IsMagAutorisation(iMTYID,iMagId, iPosID: Integer): Boolean;
begin
  try
    With Que_TmpNoEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from LOCMAILIDENTMAG');
      SQL.Add('join k on k_id = IDM_ID and k_enabled = 1');
      SQL.Add('Where IDM_MTYID = :PMTYID');
      SQL.Add('  and IDM_MAGID = :PMAGID');
      ParamCheck := True;
      ParamByName('PMTYID').AsInteger := iMTYID;
      ParamByName('PMAGID').AsInteger := iMagId;
      Open;
      if RecordCount > 0 then
      begin
        Result := (FieldByName('IDM_POSID').AsInteger = iPosID);
      end
      else begin
        Result := False;
      end;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GetPostReferantId : '+e.message);
  end;
end;


procedure Tdm_reservation.CommitSki7;
begin
  {$REGION 'Commit des caches'}
//  Fmain.trclog('T');
//  Fmain.trclog('T6--Commit des caches');

  TRY
    Dm_Main.StartTransaction();
    Dm_Main.IBOUpDateCache(Que_Pays);
    Dm_Main.IBOUpDateCache(Que_Villes);
    Dm_Main.IBOUpDateCache(Que_Civilite);
    Dm_Main.IBOUpDateCache(Que_Client);
    Dm_Main.IBOUpDateCache(Que_CltTo);
    Dm_Main.IBOUpDateCache(Que_ClientTO);
    Dm_Main.IBOUpDateCache(Que_GenAdresse);
    Dm_Main.IBOUpDateCache(Que_CodeBarre);
    Dm_Main.IBOUpDateCache(Que_Resa);
    Dm_Main.IBOUpDateCache(Que_resal);
    Dm_Main.IBOUpDateCache(Que_Resasl);
    Dm_Main.IBOUpDateCache(Que_LOCPARAMELT);
    Dm_Main.IBOUpDateCache(Que_GENIMPORT);
    Dm_Main.IBOUpDateCache(Que_CreeSess);
    Dm_Main.IBOUpDateCache(Que_CreateOCRelation);
    Dm_Main.Commit();
//    cpt_trc:=100;
  EXCEPT
    on e:exception do begin
//      cpt_trc:=110;
//      Fmain.trclog('XException lors du commit des caches (id_trace='+inttostr(cpt_trc)+') : '+e.message);
      Fmain.trclog('XException lors du commit des caches : '+e.message);
      Dm_Main.Rollback();
      Dm_Main.IBOCancelCache(Que_Pays);
      Dm_Main.IBOCancelCache(Que_Villes);
      Dm_Main.IBOCancelCache(Que_Civilite);
      Dm_Main.IBOCancelCache(Que_Client);
      Dm_Main.IBOCancelCache(Que_CltTo);
      Dm_Main.IBOCancelCache(Que_ClientTO);
      Dm_Main.IBOCancelCache(Que_GenAdresse);
      Dm_Main.IBOCancelCache(Que_CodeBarre);
      Dm_Main.IBOCancelCache(Que_Resa);
      Dm_Main.IBOCancelCache(Que_resal);
      Dm_Main.IBOCancelCache(Que_Resasl);
      Dm_Main.IBOCancelCache(Que_LOCPARAMELT);
      Dm_Main.IBOCancelCache(Que_GENIMPORT);
      Dm_Main.IBOCancelCache(Que_CreeSess);
      Dm_Main.IBOCancelCache(Que_CreateOCRelation);
      raise;
    end;
  END;
//  cpt_trc:=120;
  Dm_Main.IBOCommitCache(Que_Pays);
  Dm_Main.IBOCommitCache(Que_Villes);
  Dm_Main.IBOCommitCache(Que_Civilite);
  Dm_Main.IBOCommitCache(Que_Client);
  Dm_Main.IBOCommitCache(Que_CltTo);
  Dm_Main.IBOCommitCache(Que_ClientTO);
  Dm_Main.IBOCommitCache(Que_GenAdresse);
  Dm_Main.IBOCommitCache(Que_CodeBarre);
  Dm_Main.IBOCommitCache(Que_Resa);
  Dm_Main.IBOCommitCache(Que_resal);
  Dm_Main.IBOCommitCache(Que_Resasl);
  Dm_Main.IBOCommitCache(Que_LOCPARAMELT);
  Dm_Main.IBOCommitCache(Que_GENIMPORT);
  Dm_Main.IBOCommitCache(Que_CreeSess);
  Dm_Main.IBOCommitCache(Que_CreateOCRelation);

  {$ENDREGION}
end;

function Tdm_reservation.ConvertStrToFloat(const aValeur: String): Double;
var
  vFormatSettings : TFormatSettings;
  sNouveauMontant : String;
  iLength, iBoucle : Integer;
  cChar : Char;
  bSepDecimalFound : Boolean;
begin
  // Initialisation
  Result := 0;
  iLength := Length(aValeur);
  sNouveauMontant := '';
  bSepDecimalFound := False;

  // Boucle sur les caractères de la chaine en partant de la droite vers la gauche
  for iBoucle := iLength downto 1 do
  begin
    cChar := aValeur[iBoucle];
    case cChar of
      Char('0')..Char('9'), '+', '-' :
      begin
        sNouveauMontant := cChar + sNouveauMontant;
      end
      else
      begin
        if (not bSepDecimalFound) and ((cChar = '.') or (cChar = ',')) then
        begin
          // 1er caractère différent = le séparateur décimal
          bSepDecimalFound := True;
          sNouveauMontant := '.' + sNouveauMontant;   // On impose le point
        end
        else
        begin
          // On supprime tous les autres caractères différents d'un chiffre
          sNouveauMontant := '' + sNouveauMontant;
        end;
      end;
    end;
  end;

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, vFormatSettings);
  vFormatSettings.DecimalSeparator := '.' ;

  // Renvoie le résultat arrondi à 2 chiffres après la virgule
  Result := RoundRv(SysUtils.StrToFloatDef(sNouveauMontant, 0, vFormatSettings), 2);
end;


function Tdm_reservation.CorrespondanceWithNewId(aOldId, aOption: integer): Integer;
var
  NewId: Integer;
  sNewId: string;
begin
  Result := -1;
  sNewId := '';

  // Correspondance avec l'ID de la nouvelle offre centrale
  if (aOldId = 8) or (aOldId = 105) then
  begin
    // Nouvelle ID = Ancien ID
    NewId := aOldId;
  end
  else if (aOldId < 500) then
  begin
    // Nouvelle ID = Ancien ID - 37
    NewId :=  aOldId - 37;
  end
  else
  begin
    // Nouvelle ID = Ancien ID - 500
    NewId :=  aOldId - 500;
  end;

  // Format du nouvel ID : 1 + [newID sur 3 caractères] + option (00, 01, 10 ou 11)
  sNewId := '1' + format('%.*d', [3,NewId]);

  // Pour chaque option
  case aOption of
    1: sNewId := sNewId + '00';
    2: sNewId := sNewId + '10';
    3: sNewId := sNewId + '01';
    4: sNewId := sNewId + '11';
  end;

  Result := StrToIntDef(sNewId, -1);
end;

end.

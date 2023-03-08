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
  IniFiles;

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
    { Déclarations privées }
  public
    { Déclarations publiques }
    
    oLogfile : Tlogfile ;          

    // Délais entre deux essais en secondes
    DelaisEssais: Integer;
    
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
    function GetPaysId(sNomPays : String) : Integer;    
    // Retourn l'id de la ville, (si la ville/cp n'existe pas, la fonction va les créer)
    function GetVilleId(sNomVille, sCP : String; iPayID : Integer) : integer;    
    // Retourn le client ID d'un imp_ginkoia
    function GetClientID(iImpGin : integer) : integer;
    // retourne l'id magasin
    function GetMagId(iMtyid : Integer; sIdPresta : String) : Integer;
   // Retourne l'id d'une civilité (la fonction la créer si elle n'existe pas)
    function GetCiviliteId(const sNomCivilite : String) : integer;
    // Retourne l'idPro d'un TO (s'il n'existe pas il est créé
    function GetIdTO(const sNomTO : String; const IdMag : Integer) : integer;
    // retourne le Chrono (Procédure Stockée) client
    function GetChronoClient : String;    
    // Insert dans la table GENIMPORT des données
    function InsertGENIMPORT(iIMPGINKOIA, iIMPKTBID, iIMPNUM  : integer; sIMPREFSTR : String; iIMPREF : Integer) : Boolean;
    // Insert des données dans la tavle CLTMEMBREPRO
    function InsertCLTMEMBREPRO(iPRMCLTIDPRO, iPRMCLTIDPART: Integer) : Boolean;
    // Insert code barre
    function InsertCodeBarre(iIdClient : Integer) : Boolean;
    // Retourne un code à barre (Procedure stockée)
    function GetCodeBarre : String;    
    // Retourne l'id de locparamelt
    function GetLocParamElt(Id : integer;sNom : String) : Integer;
    // Met à jours les données de la table CLTMEMBREPRO (s'il n'existe pas, la fonction le créera
    function UpdateCLTMEMBREPRO(iPRMCLTIDPRO, iPRMCLTIDPART: Integer) : Boolean;
    // Retourne le Chrono (Procédure Stockée) réservation
    function GetProcChrono : String;
    // Insert une nouvelle réservation
    function InsertReservation(iIdClient,iIdPro,iEtat,iPaiement,iMagId : Integer;sAccompte,sComment,sNum,sNoWeb,sRemise,sMontantPrev : String;dResaDebut,dResaFin : TDateTime;IdCentrale : Integer; arrhesCom, ArrehseAco : string) : Integer;
    // Inseère une ligne de reservation
    function InsertResaLigne(MaCentrale : TGENTYPEMAIL;iIdResa,iResaCasque,iResaMulti,iResaGarantie,iPrId : Integer;sResaIdent, sResaRemise, sResaPrix : String;dResaDebut,dResaFin : TDateTime; bInterSport : Boolean = false; sISComent : String = '') : Integer;
    // Insère une sous ligne de reservation
    function InsertResaSousLigne(iIdResaL,iTCAID,iLCEID : Integer) : integer;

    // fonction qui retourne la date d'insertion dans la table k d'une reservation
    function GetDateFromK(sIdResa : String) : TDateTime;


    // Retourne vrai si l'identifiant magasin existe
    function IsIdentMagExist (iMtyMulti, iMtyId : integer;sIdMag : String) : Boolean;


   // Vérification des OC des fichiers
    function CheckOC(MaCentrale : TGENTYPEMAIL) : Boolean;
    
    function IsOCParamExist(OCC_MTYID, OCC_IDCENTRALE, RLO_OPTION : integer) : Boolean;


    // pour check des autorisations
    function GetPostReferantId : integer;
    function IsMagAutorisation(iMTYID,iMagId, iPosID : Integer) : Boolean;



    property PosID : Integer read FPOSID write FPOSID;
    
  end;

var
  dm_reservation: Tdm_reservation;

implementation

uses
  main,
  ReservationSport2k_Defs;

{$R *.dfm}



function TDm_reservation.GetListCentrale: TListGENTYPEMAIL;
var
  MonGTMail : TGENTYPEMAIL;
begin
  Result := TListGENTYPEMAIL.Create;
  Result.OwnsObjects := True;
  Try
  try
  With IbC_GetListCentrale do
  begin
    Close;
    Open;
    while not EOF do
    begin
      MonGTMail := TGENTYPEMAIL.Create;
      MonGTMail.MTY_ID       := FieldByName('MTY_ID').AsInteger;
      MonGTMail.MTY_NOM      := FieldByName('MTY_NOM').AsString;
      MonGTMail.MTY_CLTIDPRO := FieldByName('MTY_CLTIDPRO').AsInteger;
      MonGTMail.MTY_MULTI    := FieldByName('MTY_MULTI').AsInteger;

      // Temporaire, il faudrat rajouter un champ dans la table afin de récupérer le code directement
      case AnsiIndexStr(MonGTMail.MTY_NOM,['RESERVATION TWINNER','RESERVATION INTERSPORT','RESERVATION SKIMIUM',
                                           'RESERVATION SPORT 2000','RESERVATION GENERIQUE - 1',
                                           'RESERVATION GENERIQUE - 2','RESERVATION GENERIQUE - 3',
                                           'RESERVATION GOSPORT']) of
        0: MonGTMail.MTY_CODE := 'RTW'; // Twinner
        1: MonGTMail.MTY_CODE := 'RIS'; // Intersport
        2: MonGTMail.MTY_CODE := 'RSK'; // Skimium
        3: MonGTMail.MTY_CODE := 'R2K'; // sport 2000
        4: MonGTMail.MTY_CODE := 'RG1'; // générique 1
        5: MonGTMail.MTY_CODE := 'RG2'; // générique 2
        6: MonGTMail.MTY_CODE := 'RG3'; // Générique 3
        7: MonGTMail.MTY_CODE := 'RGS'; // GoSport
        else
          MonGTMail.MTY_CODE := '';
      end;

      Result.Add(MonGTMail);
      Next;
    end;
  end;
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetListCentrale : '+e.message);
  end;
  Finally
    IBC_Getlistcentrale.Close ;
  End;
end;



function TDm_Reservation.GetMailCFG(MaCentrale: TGENTYPEMAIL): TCFGMAIL;
begin
  try
  with IbC_GetCFGMail do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
    Open;

    if not EOF then
    begin
      Result.PBT_ADRPRINC  := FieldByName('PBT_ADRPRINC').AsString;
      Result.PBT_ADRARCH   := FieldByName('PBT_ADRARCH').AsString;
      Result.PBT_PASSW     := FieldByName('PBT_PASSW').AsString;
      Result.PBT_SERVEUR   := FieldByName('PBT_SERVEUR').AsString;
      Result.PBT_PORT      := FieldByName('PBT_PORT').AsInteger;
      Result.PBT_MTYID     := FieldByName('PBT_MTYID').AsInteger;
      Result.PBT_ARCHIVAGE := FieldByName('PBT_ARCHIVAGE').AsInteger;
      Result.PBT_SMTP      := FieldByName('PBT_SMTP').AsString;
      Result.PBT_PORTSMTP  := FieldByName('PBT_PORTSMTP').AsInteger;
    end
    else begin
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

  end;
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetMailCFG : '+e.message);
  end;
end;



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

  cpt_resa:integer; //compteur resa
  cpt_trc:integer; //PDB compteur de tracing

begin
  main.trclog('1Début de la procedure CreateResa');

  Result := True;
  MonXml := TmonXML.Create;

  // récupère le format date heure local
  GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);
  // On le modifie pour qu'il soit compatible avec le format demandé dans les fichiers
  FSetting.ShortDateFormat := 'YYYY-MM-DD';
  FSetting.DateSeparator := '-';

  try
  try
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

      main.trclog('1Boucle de parcours des réservations');

      if MemD_Mail.RecordCount=0 then trclog('1Aucune réservation n''est disponible');

      cpt_resa:=0;
      while not EOF do
      begin
        {$IFDEF DEBUG}
        OutputDebugString(PChar(Format('Traitement de la réservation "%s". Fichier "%s".',
          [FieldByName('MailIdResa').AsString, FieldByName('MailAttachName').AsString])));
        {$ENDIF}
        inc(cpt_resa);
        main.trclog('1Réservation n° '+inttostr(cpt_resa));
        cpt_trc:=0;
        try
          try
            main.trclog('1  Chargement du fichier xml "'+FieldByName('MailAttachName').AsString+'"');
            // chargement du fichier xml
            MonXml.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
            cpt_trc:=10;

            // Si bTraiter n'est pas flaggé à vrai c'est que la pièce jointe n'était pas valide
            // On vérifie que la réservation n'a pas été déja traité juste avant
            main.trclog('1  ID Resa '+FieldByName('MailIdResa').AsString);

            //if (FieldByName('bTraiter').AsBoolean) and not (IsReservationExist(FieldByName('MailIdResa').AsString)) then
            //TWGS
            if (FieldByName('bTraiter').AsBoolean) and not (IsReservationExistMulti(FieldByName('MailIdResa').AsString,cpt_centrale,MaCentrale.MTY_ID) ) then
            begin
              cpt_trc:=20;
              main.trclog('1  Réservation à traiter car n''existe pas déjà');
              {$IFDEF DEBUG}
              OutputDebugString(' - La réservation est à traiter et n''existe pas déjà.');
              {$ENDIF}
              MemD_Rap.Append;
              MemD_Rap.FieldByName('Centrale').AsString := MaCentrale.MTY_NOM;

              cpt_trc:=30;
              main.trclog('1  Récupération des dates');
              // récupération des dates
              nReservationXml := MonXml.find('/fiche/reservation');
              eDureeXml := MonXml.FindTag(nReservationXml,'dates_duree');
              cpt_trc:=40;
              try
                dDateDebut := StrToDate(MonXml.ValueTag (eDureeXml, 'date_debut'),FSetting);
                dDateResa  := StrToDate(MonXml.ValueTag (eDureeXml, 'date_reservation'),FSetting);
              Except on E:Exception do
                begin
                  // Rustine pour les fichiers de Skimium qui ont des s en trop pour date(s)_xxxx
                  dDateDebut := StrToDate(MonXml.ValueTag (eDureeXml, 'dates_debut'),FSetting);
                  dDateResa  := StrToDate(MonXml.ValueTag (eDureeXml, 'dates_reservation'),FSetting);
                end;
              end;
              cpt_trc:=50;
              iNbJours   := StrToIntDef(MonXml.ValueTag (eDureeXml, 'nb_jours'),0);
              dDateFin   := dDateDebut + iNbJours -1;

              cpt_trc:=60;
              main.trclog('1  Récupération du client');
              // Récupération des données clients
              eClientXml := MonXml.FindTag(nReservationXml,'client');

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
              main.trclog('1  Récupération du pays+ville');
              // Récupèration/création de l'id_pays
              iIdPays := GetPaysId(MonXml.ValueTag (eClientXml, 'pays'));
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
                    FlagInsert := True // ne devrait pas se produire
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
                  main.trclog('1  Liaison du client avec GenImport');
                  {$IFDEF DEBUG}
                  OutputDebugString(PChar(Format(' - Liaison du client avec GENIMPORT. IdClient = %d', [iIdClient])));
                  {$ENDIF}
                  //Lien avec genimport
                  //TWGS
                  if cpt_centrale>1 then
                    InsertGENIMPORT(iIdClient,-11111401,5,MonXml.ValueTag(eClientXml,'id'),MaCentrale.MTY_ID)
                  else
                    InsertGENIMPORT(iIdClient,-11111401,5,MonXml.ValueTag(eClientXml,'id'),0);
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

                main.trclog('1  Création du code-barre client');
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

              cpt_trc:=500;
              sNumChrono := GetProcChrono;
              main.trclog('1  Récupération du chrono '+snumchrono);
              //Entete de la reservation
              main.trclog('1  Création de l''entête de réservation');
              {$IFDEF DEBUG}
              OutputDebugString(' - Création de l''en-tête de la réservation.');
              {$ENDIF}
              cpt_trc:=510;
              iIdResa := InsertReservation(
                                iIdClient,
                                iIdPro,
                                iEtat,
                                iPaiment,
                                iMagId,
                                sAcompte,
                                MonXml.ValueTag(nReservationXml,'numero'),
                                sNumChrono,
                                MonXml.ValueTag(nReservationXml,'numero'),
                                MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'),'remise'),
                                MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise'),
                                dDateDebut,
                                dDateFin,
                                MaCentrale.MTY_ID,
                                MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission'),
                                MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission')
                                );
              cpt_trc:=520;
              MemD_Rap.FieldByName('Num').AsString := sNumChrono;
              MemD_Rap.FieldByName('Web').AsString := MonXml.ValueTag(nReservationXml,'numero');

              cpt_trc:=530;
              main.trclog('1  Création du lien avec GenImport');
              {$IFDEF DEBUG}
              OutputDebugString(PChar(Format(' - Lien avec GENIMPORT. IdResa = %d - NumChrono = %s.', [iIdResa, sNumChrono])));
              {$ENDIF}
              //Lien avec genimport
              main.trclog('1  MailIdResa='+MemD_Mail.FieldByName('MailIdResa').AsString);
              //TWGS
              if cpt_centrale>1 then
                InsertGENIMPORT(iIdResa,-11111512,5,MemD_Mail.FieldByName('MailIdResa').AsString,MaCentrale.MTY_ID)
              else
                InsertGENIMPORT(iIdResa,-11111512,5,MemD_Mail.FieldByName('MailIdResa').AsString,0);
    //          InsertGENIMPORT(iIdResa,-11111512,5,MonXml.ValueTag(nReservationXml,'numero'),0);

              cpt_trc:=540;
              nSkieurArtXml := MonXml.FindTag(nReservationXml,'skieurs_articles');
              eSkieurArtXml := MonXml.FindTag(nSkieurArtXml, 'skieur_article');

              main.trclog('1  Création des articles');
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
    //              MaCentrale.MTY_NOM +  ' : Intégration interrompue, le paramétrage' + #13#10 + 'des offres commerciales est incomplet...' + #13#10 +
    //              'Réservation : ' + MemD_Mail.FieldByName('MailIdResa').AsString + #13#10 +
    //              'Offre : ' +  MonXml.ValueTag(eArticleXml,('nom'))
      {*            InfoMessHP (ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))]))
                              ,True,0,0,RS_TXT_RESCMN_ERREUR);     * }

                     Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])),
                       RS_TXT_RESCMN_ERREUR) ;

                   // Non... Fmain.ologfile.Addtext(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));
                   //....On force via le tracing comme si c'était une exception pour augmenter le comptage et obliger l'affichage du log
                   main.trclog('X'+ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));

                  Result := false;
                  MemD_Rap.Cancel;
                  EXIT;
                END;

                cpt_trc:=650;
                main.trclog('1  Création de la ligne de réservation');
                {$IFDEF DEBUG}
                OutputDebugString(PChar(Format(' - Création de la ligne de réservation. IdResa = %d - prenom = %s.', [iIdResa, MonXml.ValueTag(eSkieurXML, 'prenom')])));
                {$ENDIF}

                iIdResaligne := InsertResaLigne(MaCentrale,
                                iIdResa,
                                StrToIntDef(sCasque,0),
                                StrToIntDef(sMulti,0),
                                StrToIntDef(sGarantie,0),
                                Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger, // Ouvert lors de l'exécution de IsOCParamExist
                                MonXml.ValueTag(eSkieurXML, 'prenom'),
                                MonXml.ValueTag(eArticleXml, 'remise'),
                                MonXml.ValueTag(eArticleXml, 'prix'),
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
              main.trclog('1  Mise à jour du commentaire client');
              //mise à jour du commentaire client
              With Que_GenAdresse do
              begin
                Edit;
                cpt_trc:=890;
                FieldByName('ADR_COMMENT').AsString := copy ('Réserv. du ' + FormatDateTime('DD/MM/YYYY',dDateDebut) +
                                                             ' au ' + FormatDateTime('DD/MM/YYYY',dDateFin) +
                                                             ' Arrhes : ' + MonXml.ValueTag(eFactureXml,'arrhes') + '€' + #13 + #10 +
                                                             ' Commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission') +
                                                             ' arrhes moins la commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission') + #13 + #10 +
                                                             FieldByName('ADR_COMMENT').AsString, 1, 1024) ;
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

              main.trclog('1  Commit des caches');
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
              EXCEPT
                on e:exception do begin
                  main.trclog('XException lors du commit des caches (id_trace='+inttostr(cpt_trc)+') : '+e.message);
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
              main.trclog('1La réservation n''est pas à traiter. Mais est Sport 2000, et Voucher ou sans id client');
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
                      iIdPays := GetPaysId(MonXml.ValueTag(eClientXml, 'pays'));

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
                      sCommentaireAdr := Format('Réserv. du %s au %s Arrhes'#160': %s€' + sLineBreak
                        + 'Commission'#160': %s arrhes moins la commission'#160': %s',
                        [FormatDateTime('dd/mm/yyyy', dDateDebut),
                          FormatDateTime('dd/mm/yyyy', dDateFin),
                          MonXml.ValueTag(eFactureXml, 'arrhes'),
                          MonXml.ValueTag(MonXml.FindTag(eFactureXml, 'detailarrhe'), 'commission'),
                          MonXml.ValueTag(MonXml.FindTag(eFactureXml, 'detailarrhe'), 'acompte_moins_commission')])
                        + sLineBreak + sCommentaireAdr;

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
            end
            else main.trclog('1La réservation existe déjà');
            cpt_trc:=1470;
          except
            on E: Exception do
            begin
              main.trclog('XErreur lors de la création de la réservation '+FieldByName('MailIdResa').AsString+' (id_trace='+inttostr(cpt_trc)+') : '+E.ClassName+'-'+E.Message);
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
    on e:exception do main.trclog('XErreur dans la procedure CreateResa (id_trace='+inttostr(cpt_trc)+') : '+e.message);
  end;
  finally
    Fmain.ResetGauge ;
    //CloseGaugeMessHP;
    MonXml.Free;
    main.trclog('1Fin de la procedure CreateResa');
  end; // with /try
End;

procedure Tdm_reservation.DataModuleCreate(Sender: TObject);
var
  sFicIni : TFileName;
  FicIni  : TIniFile;
begin
  // Récupère le temps entre deux essais
  try
  try
    sFicIni := ChangeFileExt(Application.ExeName, '.ini');
    FicIni  := TIniFile.Create(sFicIni);

    DelaisEssais  := FicIni.ReadInteger('Parametres', 'DelaisEssais', 5000);

    if not(FileExists(sFicIni)) then
      FicIni.WriteInteger('Parametres', 'DelaisEssais', DelaisEssais);
  Except
    on E:Exception do main.trclog('XErreur dans la procedure DataModuleCreate : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetEtat : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetLocParam : '+e.message);
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
    Open;

    // Retourne vrai si recordcount > 0 sinon false
    Result := (Recordcount > 0);
  end;
  Except
    on E:Exception do main.trclog('XErreur dans la procedure IsReservationExist : '+e.message);
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
    if iCptCentrale=1 then begin
      main.trclog('1  Avec une seule centrale -> on ne tient pas compte de l''id centrale');
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

    //Si plusieurs centrales, tenir compte de l'ID Centrale dans la recherche
    else begin
      main.trclog('1  Avec plusieurs centrales -> on tient compte de l''id centrale '+inttostr(iIdCentrale));
      With Que_ResaExistMulti do
      begin
        Close;

        ParamCheck := True;
        ParamByName('ImpRef').AsString := sIdResa;
        ParamByName('RefCentrale').AsInteger := iIdCentrale;
        Open;

        // Retourne vrai si recordcount > 0
        if Recordcount > 0 then begin
          main.trclog('1  Trouvé');
          Result := true;
        end
        // Sinon on cherche sans l'ID Centrale...
        else begin
          main.trclog('1  Pas trouvé -> on cherche uniquement avec l''id de la resa '+sIdResa);
          With Que_ResaExist do
          begin
            Close;

            ParamCheck := True;
            ParamByName('ImpRef').AsString := sIdResa;
            Open;

            //...et si on trouve on en profite pour mettre à jour le record qvec l'Id Centrale
            if Recordcount > 0 then begin

              //Mais seulement si le champ imp_ref n'est pas renseigné, sinon on écraserait
              if fieldbyname('IMP_REF').asinteger>0 then begin
                main.trclog('1  Trouvé mais déjà une valeur dans "imp_ref" -> pas trouvé');
                Result := false;
              end
              else begin
                Result := true;

                main.trclog('1  Trouvé avec "imp_ref" non renseigné -> au passage, rajout de l''ID de la centrale dans "imp_ref" de GenImport');
                Que_TmpLoc.Close;
                iId_Imp:=fieldbyname('IMP_ID').asinteger;
                main.trclog('1  ID mis à jour = '+Inttostr(iId_Imp));

                dm_main.StartTransaction;
                Que_TmpLoc.SQL.Clear;
                Que_TmpLoc.SQL.Add('UPDATE GENIMPORT');
                Que_TmpLoc.SQL.Add('SET imp_ref = ' + inttostr(iId_centrale) );
                Que_TmpLoc.SQL.Add('WHERE IMP_ID = ' + Inttostr(iId_Imp)  );
                //main.trclog('1  Que_TmpLoc.SQL='+Que_Tmp.SQL.text);
                Que_TmpLoc.ExecSQL;

                Que_TmpLoc.Close;
                Que_TmpLoc.SQL.Clear;
                Que_TmpLoc.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(iId_Imp) + ', 0)');
                Que_TmpLoc.ExecSQL;

                Dm_Main.Commit;
              end;

            end
            else main.trclog('1  Réservation pas trouvée');

          end;
        end;
      end;

    end;

  Except
    on E:Exception do main.trclog('XErreur dans la procedure IsReservationExist : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure IsReservationUpdatable : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure ReservationInMemory : '+e.message);
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
    que_client.fieldbyname ('CLT_DEBUTSEJOURVO').asdatetime := 0;
    que_client.fieldbyname ('CLT_resid') .asinteger := 0;

  END
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GenerikNewRecord : '+e.message);
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
    on E:Exception do main.trclog('XErreur dans la procedure GetClientImpGin : '+e.message);
  end;
end;
*)

function TDm_Reservation.GetClientImpGin(IdClient: String): Integer;
var
  iId_Imp:integer;
begin
  main.trclog('1  Recherche du client');
  try
  With Que_TmpNoEvent do
  begin
    Close;
    SQL.Clear;


    //TWGS - cas normal (ou anciennement) 1 seule centrale
    if cpt_centrale=1 then begin

      main.trclog('1  Une seule centrale');
      SQL.Add('select * from genimport');
      SQL.Add('where imp_num=5');
      SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
      SQL.Add('  and imp_ktbid=-11111401');
      Open;

      if Recordcount <> 0 then begin
        main.trclog('1  Trouvé id='+inttostr(FieldByName('imp_ginkoia').AsInteger));
        Result := FieldByName('imp_ginkoia').AsInteger
      end
      else
        Result := -1;

    end

    //TWGS - nouveau si >1 centrale
    else if cpt_centrale>1 then begin
      main.trclog('1  Plusieurs centrales, recherche avec l''ID de la centrale '+inttostr(iId_centrale));
      SQL.Add('select * from genimport');
      SQL.Add('where imp_num=5');
      SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
      SQL.Add('  and imp_ktbid=-11111401');
      SQL.Add('  and imp_ref='+inttostr(iId_centrale)); //prende en compte l'ID de la centrale
      Open;

      if Recordcount <> 0 then begin
        main.trclog('1  Trouvé id='+inttostr(FieldByName('imp_ginkoia').AsInteger));
        Result := FieldByName('imp_ginkoia').AsInteger
      end
      //Si on ne trouve pas en tenant compte de l'ID de la centrale, on essaye sans
      else begin
        main.trclog('1  Pas trouvé, essai sans l''ID de la centrale');
        Close;
        SQL.Clear;
        SQL.Add('select * from genimport');
        SQL.Add('where imp_num=5');
        SQL.Add('  and imp_refstr=' + QuotedStr(IdClient));
        SQL.Add('  and imp_ktbid=-11111401');
        //main.trclog('1  SQL.text='+SQL.text);
        Open;

        //Si on trouve on en profite pour rajouter l'ID de la centrale dans le record correspondant de GENIMPORT...
        if Recordcount <> 0 then begin
          //... mais seulement si il n'y a pas déjà qch. dans imp_ref, sinon on écraserait
          if fieldbyname('IMP_REF').asinteger>0 then begin
            main.trclog('1  Trouvé mais déjà une valeur dans "imp_ref" -> pas trouvé');
            Result := -1;
          end
          else begin
            main.trclog('1  Trouvé et pas de valeur dans "imp_ref" -> id='+inttostr(FieldByName('imp_ginkoia').AsInteger));
            Result := FieldByName('imp_ginkoia').AsInteger;

            main.trclog('1  Au passage, rajout de l''ID de la centrale dans "imp_ref" de GenImport');
            Que_TmpLoc.Close;
            iId_Imp:=fieldbyname('IMP_ID').asinteger;
            main.trclog('1  ID mis à jour = '+Inttostr(iId_Imp));
            dm_main.StartTransaction;
            Que_TmpLoc.SQL.Clear;
            Que_TmpLoc.SQL.Add('UPDATE GENIMPORT');
            Que_TmpLoc.SQL.Add('SET imp_ref = ' + inttostr(iId_centrale) );
            Que_TmpLoc.SQL.Add('WHERE IMP_ID = ' + Inttostr(iId_Imp)  );
            main.trclog('1  Que_TmpLoc.sql='+Que_Tmp.SQL.text);
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
          main.trclog('1  Pas trouvé définitivement');
          Result := -1;
        end;
      end;

    end;

  end;
  Except
    on E:Exception do main.trclog('1Erreur dans la procedure GetClientImpGin : '+e.message);
  end;
end;



function TDm_Reservation.GetClientByMail(sMail: String): Integer;
begin
  try
  Result := -1;

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
      Result := FieldByName('CLT_ID').AsInteger;
  end;
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetClientByMail : '+e.message);
  end;
end;


function TDm_Reservation.GetPaysId(sNomPays: String): Integer;
begin
  try
  With Que_Pays do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PNom').AsString := sNomPays;
    Open;

    if Recordcount = 0 then
    begin
      Append;
      FieldByName('PAY_NOM').AsString := sNomPays;
      Post;
    end;
    Result := FieldByName('Pay_ID').AsInteger ;
  end;
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetPaysId : '+e.message);
  end;
end;

function TDm_Reservation.GetVilleId(sNomVille, sCP: String;
  iPayID: Integer): integer;
begin
  try
  With Que_Villes do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PNom').AsString := UpperCase(sNomVille);
    ParamByName('PCp').AsString  := UpperCase(sCP);
    ParamByName('PidPays').AsInteger := iPayID;
    Open;

    if RecordCount = 0 then
    begin
      Append;
      FieldByName('VIL_NOM').AsString    := UpperCase(sNomVille);
      FieldByName('VIL_CP').AsString     := UpperCase(sCP);
      FieldByName('VIL_PAYID').AsInteger := iPayID;
      Post;
    end;

    Result := FieldByName('VIL_ID').AsInteger;
  end; // With
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetVilleId : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetCiviliteId : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetIdTO : '+e.message);
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
  Except
    on E:Exception do main.trclog('XErreur dans la procedure GetChronoClient : '+e.message);
  end;
end;



function TDm_Reservation.InsertGENIMPORT(iIMPGINKOIA, iIMPKTBID,
  iIMPNUM: integer; sIMPREFSTR: String; iIMPREF: Integer): Boolean;
begin
  Result := True;
  With Que_GENIMPORT do
  Try
    Close;
    Open;
    Append;
    FieldByName('IMP_GINKOIA').asinteger := iIMPGINKOIA;
    FieldByName('IMP_KTBID').asinteger := iIMPKTBID;
    FieldByName('IMP_NUM').asinteger := iIMPNUM;
    FieldByName('IMP_REFSTR').asstring := sIMPREFSTR;
    FieldByName('IMP_REF').asinteger := iIMPREF;
    Post;
  Except on E:Exception do begin
    Result := False;
    main.trclog('XErreur dans la procedure InsertGENIMPORT : '+e.message);
  end;
  end;
end;


function TDm_Reservation.InsertCLTMEMBREPRO(iPRMCLTIDPRO,
  iPRMCLTIDPART: Integer): Boolean;
begin
  Result := True;
  With Que_CltTo do
  try
    Close;
    ParamCheck := True;
    ParamByName('cltid').AsInteger := iPRMCLTIDPART;
    Open;
    Append;
    FieldByName('PRM_CLTIDPRO').AsInteger := iPRMCLTIDPRO;
    FieldByName('PRM_CLTIDPART').AsInteger := iPRMCLTIDPART;
    Post;
  Except On E:Exception do begin
    Result := False;
    main.trclog('XErreur dans la procedure InsertCLTMEMBREPRO : '+e.message);
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
    on e:exception do main.trclog('XErreur dans la procedure InsertCodeBarre : '+e.message);
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
    on e:exception do main.trclog('XErreur dans la procedure GetCodeBarre : '+e.message);
  end;
end;



function TDm_Reservation.GetLocParamElt(Id: integer; sNom: String): Integer;
begin
  try
  With Que_LOCPARAMELT do
  begin
    Close;
    ParamCheck := True;
    ParamByName('id').AsInteger := Id;
    ParamByName('Nom').AsString := sNom;
    Open;

    if RecordCount = 0 then
    begin
      Append;
      FieldByName('lce_lcpid').AsInteger := Id;
      FieldByName('lce_nom').AsString := sNom;
      Post;
    end;
    Result := FieldByName('lce_id').AsInteger;
  end;
  //PDB
  except
    on e:exception do main.trclog('XErreur dans la procedure GetLocParamElt : '+e.message);
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
    on e:exception do main.trclog('XErreur dans la procedure UpdateCLTMEMBREPRO : '+e.message);
  end;
end;


function TDm_Reservation.GetProcChrono: String;
begin
  try
  With IbStProc_Chrono do
  Try
  Close;
  Prepared := true;
  ExecProc;
  Result := Fields[0].asString;
  finally
    Close;
    Unprepare;
  end;
  //PDB
  except
    on e:exception do main.trclog('XErreur dans la procedure GetProcChrono : '+e.message);
  end;
end;


function TDm_Reservation.InsertReservation(iIdClient, iIdPro, iEtat, iPaiement, iMagId : Integer;
  sAccompte, sComment, sNum, sNoWeb, sRemise, sMontantPrev : String; dResaDebut, dResaFin : TDateTime; IdCentrale : Integer; ArrhesCom, ArrehseAco : String) : Integer;
var
  fRemise : currency;
  sRemiseText : String;
begin
  try
  With Que_Resa do
  begin
    Close;
    Open;

    Append;
    FieldByName('RVS_CLTID').asinteger := iIdClient;
    FieldByName('RVS_ORGCLTID').asinteger := iIdPro;
    FieldByName('RVS_DATE').AsDateTime := Now;
    FieldByName('RVS_ETATRESRID').AsInteger := iEtat;
    FieldByName('RVS_ETATPESRID').AsInteger := iPaiement;
    FieldByName('RVS_ACCOMPTE').AsFloat := StrToFloat(sAccompte);
    FieldByName('RVS_MAGID').asinteger := iMagId;
    FieldByName('RVS_NUMERO').asString := sNum;
    FieldByName('RVS_NUMEROWEB').asinteger := 0;
    FieldByName('RVS_NUMEROWEBSTRING').AsString := sNoWeb;
    FieldByName('RVS_ETATATOSESRID').asinteger := 0;
    FieldByName('RVS_TRANSACTIONID').asinteger := 0;
    FieldByName('RVS_ORIGINAMOUNT').asfloat := 0;
    FieldByName('RVS_REPONSECODE').asinteger := 0;
    FieldByName('RVS_DEBUT').AsDateTime := dResaDebut;
    FieldByName('RVS_FIN').AsDateTime := dResaFin;
    FieldByName('RVS_MTYID').asinteger := IdCentrale;

    if Assigned(Que_Resa.FindField('RVS_COMMI')) then
    begin
      FieldByName('RVS_COMMI').AsFloat := StrToFloatDef(ArrhesCom, 0);
      FieldByName('RVS_ARRHE').AsFloat := StrToFloatDef(ArrehseAco, 0);
    end;

    sRemiseText := '';
    fRemise := StrToFloatDef(sRemise,0.00);
    IF fRemise <> 0 THEN
    BEGIN
      fRemise := 100 * (1 - fRemise) ;
      sRemiseText :=  #10 + ParamsStr(RS_TXT_RESADM_REMISETTPC,FloatToStr(fRemise)); // 'Remise total : §0%'
    END;
    FieldByName('RVS_COMENT').asstring := sComment + sRemiseText;
    FieldByName('RVS_MONTANTPREV').asstring := StringReplace(sMontantPrev,',','',[rfReplaceAll]);
    Post;
    Result := FieldByName('RVS_ID').AsInteger;
  end;
  //PDB
  except
    on e:exception do main.trclog('XErreur dans la procedure InsertReservation : '+e.message);
  end;
end;


function TDm_Reservation.IsOCParamExist(OCC_MTYID, OCC_IDCENTRALE,
  RLO_OPTION: integer): Boolean;
begin
  try
  With Que_LOCOCRELATION do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select LOCCENTRALEOC.*,LOCOCRELATION.* from  LOCCENTRALEOC');
    SQL.Add(' join LOCOCRELATION on OCC_ID = RLO_OCCID');
    SQL.Add(' join k on k_id = OCC_id and K_enabled = 1');
    SQL.Add(' join k on k_id = RLO_ID and k_enabled = 1');
    SQL.Add('Where OCC_MTYID = :PMtyID');
    SQL.Add('  and OCC_IDCENTRALE = :PIdCent');
    SQL.Add('  and RLO_OPTION = :POpt');
    ParamCheck := True;
    ParamByName('PMtyID').AsInteger  := OCC_MTYID;
    ParamByName('PIdCENT').AsInteger := OCC_IDCENTRALE;
    ParamByName('Popt').AsInteger    := RLO_OPTION;
    Open;

    if Recordcount > 0 then
      Result := (FieldByName('RLO_PRDID').AsInteger <> 0)
    else
      Result := False;
  end;
  //PDB
  except
    on e:exception do main.trclog('XErreur dans la procedure IsOCParamExist : '+e.message);
  end;
end;




function TDm_Reservation.InsertResaLigne(MaCentrale : TGENTYPEMAIL;iIdResa, iResaCasque, iResaMulti,
  iResaGarantie, iPrId: Integer; sResaIdent, sResaRemise, sResaPrix : String; dResaDebut,
  dResaFin: TDateTime; bInterSport : Boolean; sISComent : String): Integer;
var
  sRemise, sPrix : String;
  cPrix, cRemise : Currency;
begin
  try
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
    FieldByName('RSL_GARANTIE').AsInteger := iResaGarantie;
    FieldByName('RSL_PRDID').AsInteger := iPrId;
    if not bInterSport then
    begin
      case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS']) of
        // Twinner, Sport2k, Gen1,Gen2,Gen3
        0,2,4,5,6,7: FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXNET,sResaPrix); //  'Prix net : '
        // Skimium / Intersport
        1,3:   FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXBRUT, sResaPrix); // 'Prix Brut : '
      end;
//      FieldByName('RSL_COMENT').asstring := 'Prix Brut : ' + sResaPrix;
      if sResaRemise <> '' then
      begin
        case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS']) of
          // Twinner, Skimium , Intersport
          0,3,7  :   FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_REMISEPC, sResaRemise); // 'Remise : §0%'
          // Skimium
          1      :   FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_PRIXNET, floatToStr(RoundRv(strTofloat(sResaRemise),2))); // 'Remise : §0%'
          // Sport2k, Gen1,Gen2,Gen3
          2,4,5,6: FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_REMISEEUR,sResaRemise); // 'Remise : §0€'
        end;
      end;

    end
    else begin
      FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + sISComent;
    end;

    cPrix := StrToCurr(StringReplace(sResaPrix,'.',DecimalSeparator,[rfReplaceAll]));

    // Skimium / Intersport
    if Trim(sResaRemise) <> '' then
      cRemise := cPrix * StrToCurr(StringReplace(sResaRemise,'.',DecimalSeparator,[rfReplaceAll])) / 100;

    case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS']) of
      // Twinner, Sport2k, Gen1,Gen2,Gen3
      0,2,4,5,6,7: FieldByName('RSL_PXNET').AsCurrency := cPrix;
      // Skimium
      1        : FieldByName('RSL_PXNET').AsString := floatToStr(RoundRv(strTofloat(sResaRemise),2));
      // Skimium / Intersport
      3        : FieldByName('RSL_PXNET').AsCurrency := cPrix - cRemise;
    end;
    FieldByName('RSL_IDENT').asstring := sResaIdent;
    Post;

    Result := FieldByName('RSL_ID').AsInteger;
  end;
  //PDB
  except
    on e:exception do main.trclog('XErreur dans la procedure InsertResaLigne : '+e.message);
  end;
end;



function TDm_Reservation.InsertResaSousLigne(iIdResaL, iTCAID,
  iLCEID: Integer): integer;
begin
  With Que_Resasl do
  begin
    if not(Active) then
      Open;

    Append;
    FieldByName('RSE_RSLID').AsInteger := iIdResaL;
    FieldByName('RSE_CALID').AsInteger := 0;
    FieldByName('RSE_TCAID').AsInteger := iTCAID;
    FieldByName('RSE_LCEID').AsInteger := iLCEID;
    Post;
  end;
end;





function TDm_Reservation.AnnulResa : Boolean;
var
  iEtat : Integer;
begin
  Result := True;

  // 'Traitement des annulations de réservations en cours'
//  InitGaugeMessHP (RS_TXT_RESADM_ANNULINPROGRESS, MemD_Mail.RecordCount + 1, true, 0, 0, '', false) ;

  With MemD_Mail do
  try
    First;
    Dm_Main.StartTransaction;
    try
      while not EOF do
      begin
        if FieldByName('bAnnulation').AsBoolean then
        begin
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
    Except on E:Exception do
      begin
        Dm_Main.IBOCancelCache(Que_UpdResa);
        Dm_Main.Rollback;
        // 'Erreur lors du traitement des annulations : ', 'Erreur Annulation'
    //    InfoMessHP(RS_ERR_RESADM_ANNULPROGRESSERROR + #13#10 + E.Message,True,0,0, RS_TXT_RESADM_ANNULERROR);
        Fmain.ologfile.Addtext(RS_ERR_RESADM_ANNULPROGRESSERROR +' '+ E.Message);
        trclog('X'+RS_ERR_RESADM_ANNULPROGRESSERROR +' '+ E.Message);
        Result := False;
        Exit;
      end;
    end; // try
  finally
   // CloseGaugeMessHP;
  end;
end;


function TDm_Reservation.GetClientID(iImpGin: integer): integer;
begin
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
end;



function TDm_Reservation.GetMagId(iMtyid: Integer; sIdPresta: String): integer;
begin
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
    Open;

    Result := FieldByName('IDM_MAGID').AsInteger;
  end;
end;


function TDm_Reservation.IsIdentMagExist(iMtyMulti, iMtyId: integer;
  sIdMag: String): Boolean;
var
  lst :TStringList;
  i : integer;
  bFound : Boolean;
begin
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
end;



function TDm_Reservation.CheckOC(MaCentrale: TGENTYPEMAIL): Boolean;
var
  MonXml : TmonXML;
  nArticlesXml: TIcXMLElement;
  eArticleXml : TIcXMLElement;
  sCentraleNom : String;
  icptoc,icptart:integer;
begin
  trclog('1Début traitement des OC');

  Result := True;
  MonXml := TmonXML.Create;

  // Si on est pas avec le poste référant on n'intègre pas les offres commerciales
  //if StdGinKoia.PosteID <> GetPostReferantId then
  //  exit;

  try
  try

  With Dm_Reservation do
  //try
    // Ouverture de la table LOCCENTRALEOC pour récpèrer la liste des OC de cette centrale
    trclog('1Récupération des OC de la centrale '+MaCentrale.MTY_NOM);
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

    trclog('1Boucle de parcours des OC');
    icptoc:=0;

    if MemD_Mail.RecordCount=0 then trclog('1Aucune OC n''est disponible');

    with MemD_Mail do
    begin
      First;

      while not EOF do
      begin
        inc(icptoc);
        trclog('1>Traitement de l''OC n° '+inttostr(icptoc));

        try

        // Si bTraiter n'est pas flaggé à vrai c'est que la pièce jointe n'était pas valide
        if FieldByName('bTraiter').AsBoolean then
        begin
          trclog('1  Pièce jointe valide, traitement de l''xml');
          // chargement du fichier xml
          MonXml.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
          // Sélection du noeud articles
          nArticlesXml := MonXml.find('/fiche/articles');
          // récupération du 1er article
          eArticleXml  := MonXml.FindTag(nArticlesXml,'article');

          icptart:=0;
          trclog('1  Boucle de parcours des articles');

          while eArticleXml <> Nil do
          begin
            inc(icptart);
            trclog('1  Traitement de l''article n° '+inttostr(icptart));

            (*
            - Vérification structurelle du XML, que les articles soient des "éléments" et pas des "attributs"
            du noeud Article.
            - Vérification qu'il y a au moins 2 éléments : nom et id_article
            *)

            if (eArticleXml.hasChild) and
              (MonXml.ValueTag(eArticleXml,'nom')<>'') and
              (MonXml.ValueTag(eArticleXml,'id_article')<>'') then
            begin
              trclog('1  L''xml de l''article est valide');
              sCentraleNom := MonXml.ValueTag(eArticleXml,'nom');
              if  MonXml.ValueTag(eArticleXml,'categorie') <> '' then
                sCentraleNom := sCentraleNom  + '(' + MonXml.ValueTag(eArticleXml,'categorie') + ')';

              trclog('1  Vérification si l''OC existe pour l''article "'+MonXml.ValueTag(eArticleXml,'nom')+'" (id='+MonXml.ValueTag(eArticleXml,'id_article')+')');
              // Vérification que l'OC existe
              if Que_LOCCENTRALEOC.Locate('OCC_IDCENTRALE',MonXml.ValueTag(eArticleXml,'id_article'),[]) then
              begin
                // OC Existante
                // Vérification si nom différent
                if Uppercase(Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString) <> Uppercase(sCentraleNom) then
                begin
                  trclog('1  Existe déjà, mais le nom est différent -> mise à jour');
                  //  si différent on met à jour
                  Que_LOCCENTRALEOC.Edit;
                  Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString := sCentraleNom;
                  Que_LOCCENTRALEOC.Post;
                end
                else trclog('1  Existe déjà, avec nom identique');
              end
              else begin
                // OC inéxistante donc création dans la table
                // puis passage du resultat à false pour indiquer qu'il y a eu nouvelle création d'OC
                trclog('1  N''existe pas encore -> création');
                Que_LOCCENTRALEOC.Append;
                Que_LOCCENTRALEOC.FieldByName('OCC_MTYID').AsInteger     := MaCentrale.MTY_ID;
                Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString        := sCentraleNom;
                Que_LOCCENTRALEOC.FieldByName('OCC_IDCENTRALE').AsString := MonXml.ValueTag(eArticleXml,'id_article');
                Que_LOCCENTRALEOC.Post;

                Result := False;
              end;

            end
            else begin
              Fmain.ologfile.Addtext(RS_ERR_RESMAN_OCx+' '+inttostr(icptart));
              trclog(RS_ERR_RESMAN_OCx+' '+inttostr(icptart));
            end;

            // on passe à l'article suivant
            eArticleXml := eArticleXml.nextSibling;
          end;
        end
        else trclog('1  OC ignorée car pièce jointe non valide');

        //PDB
        except
          on e:exception do main.trclog('XErreur dans la procedure CheckOC : '+e.message);
        end;

        Next;
         Fmain.UpdateGauge ;
     //   IncGaugeMessHP(1);
      end; // while
    end;  // With
  //PDB
  except
    on e:exception do main.trclog('XErreur dans la procedure CheckOC : '+e.message);
  end;
  finally
    //CloseGaugeMessHP;
    Fmain.ResetGauge ;
    MonXml.Free;
    trclog('1Fin traitement des OC');
  end; // with /try

end;


function TDm_Reservation.GetDateFromK(sIdResa: String): TDateTime;
begin
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
end;



function TDm_Reservation.GetPostReferantId : integer;
begin
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
end;



function TDm_Reservation.IsMagAutorisation(iMTYID,iMagId, iPosID: Integer): Boolean;
begin
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
end;




end.

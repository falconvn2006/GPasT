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
                                           'RESERVATION GENERIQUE - 2','RESERVATION GENERIQUE - 3']) of
        0: MonGTMail.MTY_CODE := 'RTW'; // Twinner
        1: MonGTMail.MTY_CODE := 'RIS'; // Intersport
        2: MonGTMail.MTY_CODE := 'RSK'; // Skimium
        3: MonGTMail.MTY_CODE := 'R2K'; // sport 2000
        4: MonGTMail.MTY_CODE := 'RG1'; // générique 1
        5: MonGTMail.MTY_CODE := 'RG2'; // générique 2
        6: MonGTMail.MTY_CODE := 'RG3'; // Générique 3
        else
          MonGTMail.MTY_CODE := '';
      end;

      Result.Add(MonGTMail);
      Next;
    end;
  end;
  Finally
    IBC_Getlistcentrale.Close ;
  End;
end;



function TDm_Reservation.GetMailCFG(MaCentrale: TGENTYPEMAIL): TCFGMAIL;
begin
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
begin
  Result := True;
  MonXml := TmonXML.Create;

  // récupère le format date heure local
  GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);
  // On le modifie pour qu'il soit compatible avec le format demandé dans les fichiers
  FSetting.ShortDateFormat := 'YYYY-MM-DD';
  FSetting.DateSeparator := '-';

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

      while not EOF do
      begin
        {$IFDEF DEBUG}
        OutputDebugString(PChar(Format('Traitement de la réservation "%s". Fichier "%s".',
          [FieldByName('MailIdResa').AsString, FieldByName('MailAttachName').AsString])));
        {$ENDIF}

        try
          try
            // chargement du fichier xml
            MonXml.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);

            // Si bTraiter n'est pas flaggé à vrai c'est que la pièce jointe n'était pas valide
            // On vérifie que la réservation n'a pas été déja traité juste avant
            if (FieldByName('bTraiter').AsBoolean) and not (IsReservationExist(FieldByName('MailIdResa').AsString)) then
            begin
              {$IFDEF DEBUG}
              OutputDebugString(' - La réservation est à traiter et n''existe pas déjà.');
              {$ENDIF}
              MemD_Rap.Append;
              MemD_Rap.FieldByName('Centrale').AsString := MaCentrale.MTY_NOM;

              // récupération des dates
              nReservationXml := MonXml.find('/fiche/reservation');
              eDureeXml := MonXml.FindTag(nReservationXml,'dates_duree');
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
              iNbJours   := StrToIntDef(MonXml.ValueTag (eDureeXml, 'nb_jours'),0);
              dDateFin   := dDateDebut + iNbJours -1;

              // Récupération des données clients
              eClientXml := MonXml.FindTag(nReservationXml,'client');

              // S'il ne s'agit pas, pour Sport 2000, d'un client Voucher
              if not(SameText(MaCentrale.MTY_NOM, CSPORT2K)
                and MemD_Mail.FieldByName('bVoucher').AsBoolean) then
              begin
                {$IFDEF DEBUG}
                OutputDebugString(' - Le client est Voucher pour Sport 2000.');
                {$ENDIF}
                if (MonXml.ValueTag(eClientXml,'id') <> '0')
                  and (MonXml.ValueTag(eClientXml,'id') <> '') then
                  iImpGinKoia := GetClientImpGin(MonXml.ValueTag(eClientXml, 'id'))
                else
                  iImpGinKoia := GetClientByMail(MonXml.ValueTag(eClientXml, 'email'));
              end
              else begin
                {$IFDEF DEBUG}
                OutputDebugString(' - Le client n''est pas Voucher pour Sport 2000.');
                {$ENDIF}
                iImpGinKoia := -1;
              end;


              FlagInsert := (iImpGinKoia = -1);
              // Récupèration/création de l'id_pays
              iIdPays := GetPaysId(MonXml.ValueTag (eClientXml, 'pays'));
              // récupération/Création de l'id_ville
              iIdVille := GetVilleId(MonXml.ValueTag (eClientXml, 'ville'),MonXml.ValueTag(eClientXml, 'code_postal'),iIdPays);
              With Que_GenAdresse do
              begin
                if not Active then
                begin
                  Close;
                  // Juste pour qu'il y ai un paramètre pour l'ouverture de la requete
                  ParamByName('adrid').AsInteger := -1;
                  Open;
                end;

                if FlagInsert then
                begin
                  {$IFDEF DEBUG}
                  OutputDebugString(' - Création de l''adresse du client.');
                  {$ENDIF}
                  Append();
                end
                else begin
                  {$IFDEF DEBUG}
                  OutputDebugString(' - Mise à jour de l''adresse du client.');
                  {$ENDIF}
                  iIdClient := GetClientID(iImpGinKoia);
                  if iIdClient = -1 then
                    FlagInsert := True // ne devrait pas se produire
                  else begin
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
                end; // else

                FieldByName('ADR_LIGNE').asstring := uppercase (MonXml.ValueTag (eClientXml, 'adresse') ) ;
                FieldByName('ADR_VILID').asinteger := iIdVille;
                FieldByName('ADR_TEL').asstring := MonXml.ValueTag (eClientXml, 'telephone') ;
                FieldByName('ADR_FAX').asstring := '';
                FieldByName('ADR_EMAIL').asstring := MonXml.ValueTag (eClientXml, 'email') ;
                Post;
              end; // with

              With Que_Client do
              begin
                if not Active then
                begin
                  Close;
                  // Juste pour qu'il y ai un paramètre pour l'ouverture de la requete
                  ParamByName('cltid').asInteger := -1;
                  Open;
                end;

                if FlagInsert then
                begin
                  {$IFDEF DEBUG}
                  OutputDebugString(' - Création du client.');
                  {$ENDIF}
                  Append();
                end
                else begin
                  {$IFDEF DEBUG}
                  OutputDebugString(' - Mise à jour du client.');
                  {$ENDIF}
                  Edit();
                end;
                iMagId := GetMagId(MaCentrale.MTY_ID,MemD_Mail.FieldByName('MailIdMag').AsString);
                FieldByName('CLT_NOM').asstring := Trim(UpperCase (MonXml.ValueTag (eClientXml, 'nom')));
                FieldByName('CLT_PRENOM').asstring := Trim(UpperCase (MonXml.ValueTag (eClientXml, 'prenom')));
                FieldByName('CLT_ADRID').asinteger := Que_GenAdresse.FieldByName('ADR_ID').asinteger;
                FieldByname ('clt_magid') .asinteger := iMagId;

                IF MonXml.ValueTag (eClientXml, 'civilite') <> '' THEN
                BEGIN
                  FieldByname ('CLT_CIVID').asinteger := GetCiviliteId(MonXml.ValueTag (eClientXml, 'civilite'));
                END;

                IF MonXml.ValueTag (eClientXml, 'date_naissance') <> '' THEN
                BEGIN
                  FieldByname ('CLT_NAISSANCE').asdatetime := StrToDate(MonXml.ValueTag (eClientXml, 'date_naissance'),FSetting);
                END;

                Post;
                iIdClient := FieldByName('CLT_ID').AsInteger;
                Memd_Rap.FieldByName('Client').AsString := FieldByName('CLT_NOM').asstring + ' ' + FieldByName('CLT_PRENOM').asstring;
              End; // with

              // Gestion du TO
              if MonXml.ValueTag(nReservationXml,'nom_TO') <> '' then
              begin
                iIdPro := GetIdTO(MonXml.ValueTag(nReservationXml,'nom_TO'),iMagId);
              end
              else
                iIdPro := MaCentrale.MTY_CLTIDPRO;//  GetIdPro;

              IF Flaginsert THEN
              BEGIN

                // S'il ne s'agit pas, pour Sport 2000, d'un client Voucher
                if not(SameText(MaCentrale.MTY_NOM, CSPORT2K)
                  and MemD_Mail.FieldByName('bVoucher').AsBoolean) then
                begin
                  {$IFDEF DEBUG}
                  OutputDebugString(PChar(Format(' - Liaison du client avec GENIMPORT. IdClient = %d', [iIdClient])));
                  {$ENDIF}
                  //Lien avec genimport
                  InsertGENIMPORT(iIdClient,-11111401,5,MonXml.ValueTag(eClientXml,'id'),0);
                end;
                iImpGinKoia := StrToIntDef(MonXml.ValueTag(eClientXml,'id'),-1);

                //Lien avec TO
                {$IFDEF DEBUG}
                OutputDebugString(PChar(Format(' - Liaison du client avec TO. IdClient = %d - IdPro = %d', [iIdClient, iIdPro])));
                {$ENDIF}
                InsertCLTMEMBREPRO(iIdPro,iIdClient);

                //Codebarre client
                {$IFDEF DEBUG}
                OutputDebugString(PChar(Format(' - Création du code-barres client. IdClient = %d', [iIdClient])));
                {$ENDIF}
                InsertCodeBarre(iIdClient);
              End
              else begin
                //Lien avec TO
                {$IFDEF DEBUG}
                OutputDebugString(PChar(Format(' - Mise à jour de la liaison du client avec TO. IdClient = %d - IdPro = %d', [iIdClient, iIdPro])));
                {$ENDIF}
                UpdateCLTMEMBREPRO(iIdPro,iIdClient);
              end;

              eFactureXml := MonXml.FindTag (nReservationXml, 'facture');
              // Gestion du Voucher
              if FieldByName('bVoucher').AsBoolean then
                sAcompte := MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise')
              else
                sAcompte := MonXml.ValueTag(eFactureXml,'arrhes');

              sNumChrono := GetProcChrono;
              //Entete de la reservation
              {$IFDEF DEBUG}
              OutputDebugString(' - Création de l''en-tête de la réservation.');
              {$ENDIF}
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
              MemD_Rap.FieldByName('Num').AsString := sNumChrono;
              MemD_Rap.FieldByName('Web').AsString := MonXml.ValueTag(nReservationXml,'numero');

              {$IFDEF DEBUG}
              OutputDebugString(PChar(Format(' - Lien avec GENIMPORT. IdResa = %d - NumChrono = %s.', [iIdResa, sNumChrono])));
              {$ENDIF}
              //Lien avec genimport
              InsertGENIMPORT(iIdResa,-11111512,5,MemD_Mail.FieldByName('MailIdResa').AsString,0);
    //          InsertGENIMPORT(iIdResa,-11111512,5,MonXml.ValueTag(nReservationXml,'numero'),0);

              nSkieurArtXml := MonXml.FindTag(nReservationXml,'skieurs_articles');
              eSkieurArtXml := MonXml.FindTag(nSkieurArtXml, 'skieur_article');

              while (eSkieurArtXml <> nil) do
              begin
                eArticleXml := MonXml.FindTag(eSkieurArtXml,'article');
                eSkieurXML  := MonXml.FindTag(eSkieurArtXml,'skieur');

                IF MonXml.ValueTag(eArticleXml{eSkieurArtXml},'date_debut') <> '' THEN
                begin
                  dDateResaDebut := StrToDate(MonXml.ValueTag(eArticleXml{eSkieurArtXml},'date_debut'),FSetting);
                end else
                  dDateResaDebut := dDateDebut;

                if MonXml.ValueTag(eArticleXml{eSkieurArtXml},'date_fin') <> '' then
                begin
                  dDateResaFin := StrToDate(MonXml.ValueTag (eArticleXml{eSkieurArtXml},'date_fin'),FSetting);
                end else
                  dDateResaFin := dDateFin;

                sCasque   := eArticleXml.getAttribute('avec_casque');
                sMulti    := eArticleXml.getAttribute('multiglisse');
                if sMulti = '' then  // ce n'est pas multiglisse Twinner
                  sMulti := eArticleXml.getAttribute('avec_GL');   // Glisse liberté Skimium
                sGarantie := eArticleXml.getAttribute('garantie_vol_casse');
                sIdArt    := MonXml.ValueTag(eArticleXml,('id_article'));

                if eArticleXml.getAttribute('avec_chaussure') = '0' then
                begin
                  if sCasque = '0' then
                    iRLOOption := 1  // Offre seule
                  else
                    iRLOOption := 3; // Offre seule + Casque
                end
                else begin
                  if sCasque = '0' then
                    iRLOOption := 2  // Offre avec chaussures
                  else
                   iRLOOption := 4;  // Offre avec chaussures + Casque
                end;

                IF not IsOCParamExist(MaCentrale.MTY_ID,StrToIntDef(sIdArt,-1),iRLOOption) THEN
                BEGIN // La relation est manquante
    //              MaCentrale.MTY_NOM +  ' : Intégration interrompue, le paramétrage' + #13#10 + 'des offres commerciales est incomplet...' + #13#10 +
    //              'Réservation : ' + MemD_Mail.FieldByName('MailIdResa').AsString + #13#10 +
    //              'Offre : ' +  MonXml.ValueTag(eArticleXml,('nom'))
      {*            InfoMessHP (ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))]))
                              ,True,0,0,RS_TXT_RESCMN_ERREUR);     * }

                     Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])),
                       RS_TXT_RESCMN_ERREUR) ;
                         

                   Fmain.ologfile.Addtext(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));


                  Result := false;
                  MemD_Rap.Cancel;
                  EXIT;
                END;

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

                With Que_GenAdresse do
                begin
                  if not (sTemp = '') then
                  begin
                    Edit;
                    FieldByName('ADR_COMMENT').AsString := copy ('   ' + uppercase (MonXml.ValueTag(eSkieurXML, 'prenom')) +
                                                                 ' : ' + sTemp + #13 + #10 +
                                                                 FieldByName('ADR_COMMENT').AsString, 1, 1024);
                    Post;
                  end;
                end;

                //Souslignes de resa
             //   ibc_com.close;
             //   ibc_com.parambyname ('prd_id') .asinteger := iImpGinKoia;
            //    ibc_com.open;

                // On remet au debut la requete (Requete activé dans IsOcParamExist
                Que_LOCOCRELATION.First;

                WHILE NOT Que_LOCOCRELATION.eof DO
                BEGIN
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

                    while not Que_LOCTYPERELATION.Eof do
    //                if RecordCount > 0 then
                    begin
                      iLceId := 0;

                      if FieldByName('LTR_PTR').AsInteger = 1 then
                      begin
                        iLceId := GetLocParamElt(iPointure,MonXml.ValueTag(eSkieurXML,'pointure'));

                        {$IFDEF DEBUG}
                        OutputDebugString(PChar(Format(' - Réponse "pointure". LceId = %d', [iLceId])));
                        {$ENDIF}

                        InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                      end;

                      if FieldByName('LTR_TAILLE').AsInteger = 1 then
                      begin
                        iLceId := GetLocParamElt(iTaille,MonXml.ValueTag(eSkieurXML,'taille'));

                        {$IFDEF DEBUG}
                        OutputDebugString(PChar(Format(' - Réponse "taille". LceId = %d', [iLceId])));
                        {$ENDIF}

                        InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                      end;

                      if FieldByName('LTR_POIDS').asInteger = 1 then
                      begin
                        ilceId := GetLocParamElt(iPoids,MonXml.ValueTag(eSkieurXML, 'poids'));

                        {$IFDEF DEBUG}
                        OutputDebugString(PChar(Format(' - Réponse "poids". LceId = %d', [iLceId])));
                        {$ENDIF}

                        InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                      end;

                      // On insère une ligne sans valeur
                      if iLceId = 0 then
                      begin
                        {$IFDEF DEBUG}
                        OutputDebugString(PChar(Format(' - Réponse sans valeur. LceId = %d', [iLceId])));
                        {$ENDIF}

                        InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,0);
                      end;
                      Que_LOCTYPERELATION.Next;
                    end;
                    Que_LOCOCRELATION.Next;
                  end; //with
                end; // while

                eSkieurArtXml := eSkieurArtXml.nextSibling;
              end;

              //mise à jour du commentaire client
              With Que_GenAdresse do
              begin
                Edit;
                FieldByName('ADR_COMMENT').AsString := copy ('Réserv. du ' + FormatDateTime('DD/MM/YYYY',dDateDebut) +
                                                             ' au ' + FormatDateTime('DD/MM/YYYY',dDateFin) +
                                                             ' Arrhes : ' + MonXml.ValueTag(eFactureXml,'arrhes') + '€' + #13 + #10 +
                                                             ' Commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission') +
                                                             ' arrhes moins la commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission') + #13 + #10 +
                                                             FieldByName('ADR_COMMENT').AsString, 1, 1024) ;
                Post;
              end;

              MemD_Rap.FieldByName('deb').AsDateTime := dDateDebut;
              MemD_Rap.FieldByName('fin').AsDateTime := dDateFin;
              MemD_Rap.post;


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
              EXCEPT
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
              END;
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
            end
            else if not(MemD_Mail.FieldByName('bTraiter').AsBoolean)
              and SameText(MaCentrale.MTY_NOM, CSPORT2K)
              and (MemD_Mail.FieldByName('bVoucher').AsBoolean
                or (MonXml.ValueTag(MonXml.FindTag(MonXml.find('/fiche/reservation'), 'client'), 'id') = '')) then
            begin    
              {$IFDEF DEBUG}
              OutputDebugString(' - La réservation n''est pas à traiter. Mais est Sport 2000, et Voucher ou sans id client.');
              {$ENDIF}

              // Récupération de la réservation
              nReservationXml := MonXml.find('/fiche/reservation');

              // Récupération des données clients
              eClientXml := MonXml.FindTag(nReservationXml, 'client');

              // Si la réservation existe déjà, mais qu'on est sur un client Voucher de la centrale Sport 2000
              // ou un client d'une réservation express.
              // Si la réservation est liée au client "générique" (présent dans GENIMPORT), alors on créer un nouveau client pour le lier à la réservation
              if IsReservationUpdatable(FieldByName('MailIdResa').AsString) then
              begin
                {$IFDEF DEBUG}
                OutputDebugString(' - La réservation peut être mise à jour.');
                {$ENDIF}

                if (MonXml.ValueTag(eClientXml, 'id') <> '') then
                  iImpGinKoia := GetClientImpGin(MonXml.ValueTag(eClientXml, 'id'))
                else
                  iImpGinKoia := GetClientByMail(MonXml.ValueTag(eClientXml, 'email'));

                if iImpGinKoia <> -1 then
                begin
                  // Le client est générique, on récupère l'ID de la réservation
                  {$IFDEF DEBUG}
                  OutputDebugString(' - Le client est générique, on récupère l''ID de la réservation.');
                  {$ENDIF}
                  try
                    if Que_ResaExist.Active then
                      Que_ResaExist.Close();

                    Que_ResaExist.ParamByName('IMPREF').AsString := MemD_Mail.FieldByName('MailIdResa').AsString;
                    Que_ResaExist.Open();

                    if not(Que_ResaExist.IsEmpty()) then
                      iIdResa := Que_ResaExist.FieldByName('IMP_GINKOIA').AsInteger
                    else
                      iIdResa := -1;
                  finally
                    Que_ResaExist.Close();
                  end;

                  // Si la réservation existe vraiment
                  if iIdResa <> -1 then
                  begin
                    {$IFDEF DEBUG}
                    OutputDebugString(PChar(Format(' - La réservation existe vraiment. IdResa = %d', [iIdResa])));
                    {$ENDIF}

                    if Que_MajResa.Active then
                      Que_MajResa.Close();

                    Que_MajResa.ParamByName('RVSID').AsInteger := iIdResa;
                    Que_MajResa.Open();

                    if not(Que_MajResa.IsEmpty()) then
                    begin
                      // Créer l'adresse du client, même si elle sera surement fausse
                      // Récupération / création de l'id_pays
                      iIdPays := GetPaysId(MonXml.ValueTag(eClientXml, 'pays'));

                      // Récupération / Création de l'id_ville
                      iIdVille := GetVilleId(MonXml.ValueTag(eClientXml, 'ville'), MonXml.ValueTag(eClientXml, 'code_postal'), iIdPays);

                      // Prépare le commentaire pour l'adresse
                      sCommentaireAdr := '';
                      nSkieurArtXml   := MonXml.FindTag(nReservationXml, 'skieurs_articles');
                      eSkieurArtXml   := MonXml.FindTag(nSkieurArtXml, 'skieur_article');
                      eArticleXml     := MonXml.FindTag(eSkieurArtXml, 'article');
                      eSkieurXML      := MonXml.FindTag(eSkieurArtXml, 'skieur');
                      while Assigned(eSkieurArtXml) do
                      begin
                        sCasque   := eArticleXml.getAttribute('avec_casque');
                        sMulti    := eArticleXml.getAttribute('multiglisse');
                        // Ce n'est pas multiglisse Twinner
                        if sMulti = '' then
                        begin
                          // Glisse liberté Skimium
                          sMulti := eArticleXml.getAttribute('avec_GL');
                        end;
                        sGarantie := eArticleXml.getAttribute('garantie_vol_casse');
                  
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

                        sCommentaireAdr := Format('   %s'#160': %s', [UpperCase(MonXml.ValueTag(eSkieurXML, 'prenom')), sTemp]) + sLineBreak + sCommentaireAdr;
                        eSkieurArtXml := eSkieurArtXml.nextSibling();
                      end;

                      // Récupération des dates
                      nReservationXml := MonXml.find('/fiche/reservation');
                      eDureeXml       := MonXml.FindTag(nReservationXml,'dates_duree');
                      if (MonXml.ValueTag(eDureeXml, 'date_debut') <> '')
                        and (MonXml.ValueTag(eDureeXml, 'date_reservation') <> '') then
                      begin
                        if not(TryStrToDate(MonXml.ValueTag(eDureeXml, 'date_debut'), dDateDebut, FSetting)) then
                        begin
                          OutputDebugString(' - Erreur dans la date de début.');
                          dDateDebut := 0;
                        end;
                        if not(TryStrToDate(MonXml.ValueTag(eDureeXml, 'date_reservation'), dDateResa, FSetting)) then
                        begin
                          OutputDebugString(' - Erreur dans la date de réservation.');
                          dDateResa := 0;
                        end;
                      end
                      else begin
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
                      iNbJours   := StrToIntDef(MonXml.ValueTag (eDureeXml, 'nb_jours'), 0);
                      dDateFin   := dDateDebut + iNbJours - 1;

                      sCommentaireAdr := Format('Réserv. du %s au %s Arrhes'#160': %s€' + sLineBreak
                        + 'Commission'#160': %s arrhes moins la commission'#160': %s',
                        [FormatDateTime('dd/mm/yyyy', dDateDebut),
                          FormatDateTime('dd/mm/yyyy', dDateFin),
                          MonXml.ValueTag(eFactureXml, 'arrhes'),
                          MonXml.ValueTag(MonXml.FindTag(eFactureXml, 'detailarrhe'), 'commission'),
                          MonXml.ValueTag(MonXml.FindTag(eFactureXml, 'detailarrhe'), 'acompte_moins_commission')])
                        + sLineBreak + sCommentaireAdr;

                      if Que_GenAdresse.Active then
                        Que_GenAdresse.Close();

                      Que_GenAdresse.ParamByName('ADRID').AsInteger := -1;
                      Que_GenAdresse.Open();
                      Que_GenAdresse.Append();

                      Que_GenAdresse.FieldByName('ADR_LIGNE').AsString    := UpperCase(MonXml.ValueTag(eClientXml, 'adresse'));
                      Que_GenAdresse.FieldByName('ADR_VILID').AsInteger   := iIdVille;
                      Que_GenAdresse.FieldByName('ADR_TEL').AsString      := MonXml.ValueTag(eClientXml, 'telephone');
                      Que_GenAdresse.FieldByName('ADR_FAX').AsString      := '';
                      Que_GenAdresse.FieldByName('ADR_EMAIL').AsString    := MonXml.ValueTag(eClientXml, 'email');
                      Que_GenAdresse.FieldByName('ADR_COMMENT').AsString  := LeftStr(sCommentaireAdr, 1024);

                      Que_GenAdresse.Post();

                      // Créer le nouveau client
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Création du nouveau client.');
                      {$ENDIF}
                      if Que_Client.Active then
                        Que_Client.Close();

                      Que_Client.ParamByName('CLTID').AsInteger := -1;
                      Que_Client.Open();
                      Que_Client.Append();

                      iMagId := GetMagId(MaCentrale.MTY_ID, MemD_Mail.FieldByName('MailIdMag').AsString);
                      Que_Client.FieldByName('CLT_NOM').AsString    := Trim(UpperCase(MonXml.ValueTag (eClientXml, 'nom')));
                      Que_Client.FieldByName('CLT_PRENOM').AsString := Trim(UpperCase(MonXml.ValueTag (eClientXml, 'prenom')));
                      Que_Client.FieldByName('CLT_ADRID').AsInteger := Que_GenAdresse.FieldByName('ADR_ID').AsInteger;
                      Que_Client.FieldByname('CLT_MAGID').AsInteger := iMagId;

                      Que_Client.Post();

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

                      // Lien avec le TO
                      {$IFDEF DEBUG}
                      OutputDebugString(PChar(Format(' - Liaison avec le TO. IdClient = %d - IdPro = %d', [iIdClient, iIdPro])));
                      {$ENDIF}
                      InsertCLTMEMBREPRO(iIdPro, iIdClient);

                      // Code-barres client
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Création du code-barres client.');
                      {$ENDIF}
                      InsertCodeBarre(iIdClient);

                      // Met à jour le client de la réservation
                      {$IFDEF DEBUG}
                      OutputDebugString(' - Mise à jour du client de la réservation.');
                      {$ENDIF}
                      Que_MajResa.Edit();
                      Que_MajResa.FieldByName('RVS_CLTID').AsInteger := iIdClient;
                      Que_MajResa.Post();

                      Dm_Main.StartTransaction();
                      try
                        Dm_Main.IBOUpDateCache(Que_Pays);
                        Dm_Main.IBOUpDateCache(Que_Villes);
                        Dm_Main.IBOUpDateCache(Que_CltTo);
                        Dm_Main.IBOUpDateCache(Que_Client);
                        Dm_Main.IBOUpDateCache(Que_GenAdresse);
                        Dm_Main.IBOUpDateCache(Que_CodeBarre);
                        Dm_Main.IBOUpDateCache(Que_MajResa);
                        Dm_Main.Commit();
                      except
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
                      Dm_Main.IBOCommitCache(Que_Pays);
                      Dm_Main.IBOCommitCache(Que_Villes);
                      Dm_Main.IBOCommitCache(Que_CltTo);
                      Dm_Main.IBOCommitCache(Que_Client);
                      Dm_Main.IBOCommitCache(Que_GenAdresse);
                      Dm_Main.IBOCommitCache(Que_CodeBarre);
                      Dm_Main.IBOCommitCache(Que_MajResa);
                    end;
                  end;
                end;
              end;
            end;
          except
            on E: Exception do
            begin
              {$IFDEF DEBUG}
              OutputDebugString(PChar(Format(RS_ERR_RESADM_CREATERESA, [FieldByName('MailIdResa').AsString, E.ClassName, E.Message])));
              {$ENDIF}

              // Demande de ne pas archiver le mail pour le repasser la prochaine fois
              MemD_Mail.Edit();
              MemD_Mail.FieldByName('bArchive').AsBoolean := False;
              MemD_Mail.Post();

              Fmain.oLogfile.Addtext(Format(RS_ERR_RESADM_CREATERESA, [FieldByName('MailIdResa').AsString, E.ClassName, E.Message]));
            end;
          end;
        finally
          {$IFDEF DEBUG}
          OutputDebugString(' - Libération de MonXml.Doc.');
          {$ENDIF}
          FreeAndNil(MonXml.Doc);
        end;

        Next;
        Fmain.UpdateGauge ;
        //IncGaugeMessHP(1);
      end; // while
    end; // with
  finally
    Fmain.ResetGauge ;
    //CloseGaugeMessHP;
    MonXml.Free;
  end; // with /try
End;

procedure Tdm_reservation.DataModuleCreate(Sender: TObject);
var
  sFicIni : TFileName;
  FicIni  : TIniFile;
begin
  // Récupère le temps entre deux essais
  try
    sFicIni := ChangeFileExt(Application.ExeName, '.ini');
    FicIni  := TIniFile.Create(sFicIni);

    DelaisEssais  := FicIni.ReadInteger('Parametres', 'DelaisEssais', 5000);

    if not(FileExists(sFicIni)) then
      FicIni.WriteInteger('Parametres', 'DelaisEssais', DelaisEssais);
  finally
    FicIni.Free();
  end;
end;

function TDm_Reservation.GetEtat(iWeb,iType : Integer): Integer;
begin
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
end;


function TDm_Reservation.GetLocParam(sParam: String): Integer;
begin
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
end;


function TDm_Reservation.IsReservationExist(sIdResa: String): Boolean;
begin
  With Que_ResaExist do
  begin
    Close;
    ParamCheck := True;
    ParamByName('ImpRef').AsString := sIdResa;
    Open;

    // Retourne vrai si recordcount > 0 sinon false
    Result := (Recordcount > 0);
  end;
end;

// Récupère l'ID d'une réservation
function TDm_Reservation.IsReservationUpdatable(const AIdResaWeb: string): Boolean;
begin
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

end;


{$ENDREGION}

function TDm_Reservation.GetClientImpGin(IdClient: String): Integer;
begin
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
end;


function TDm_Reservation.GetClientByMail(sMail: String): Integer;
begin
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
end;


function TDm_Reservation.GetPaysId(sNomPays: String): Integer;
begin
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
end;

function TDm_Reservation.GetVilleId(sNomVille, sCP: String;
  iPayID: Integer): integer;
begin
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
end;

function TDm_Reservation.GetCiviliteId(const sNomCivilite: String): integer;
begin
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
  finally
    // il faut laisser la requete ouverte sinon ca ne pose pas le cache
    // Que_Civilite.Close();
  end;
end;


function TDm_Reservation.GetIdTO(const sNomTO: String; const IdMag: Integer): integer;
begin
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
  finally
    // il faut laisser la requete ouverte sinon ca ne pose pas le cache
    // Que_ClientTO.Close();
  end;
end;


function TDm_Reservation.GetChronoClient: String;
begin
  //---Num Chrono---
  With IbStProc_Client do
  begin
    Close;
    IbStProc_Client.Prepared := True;
    IbStProc_Client.ExecProc;
    Result := IbStProc_client.Fields[0].AsString;
    IbStProc_Client.Close;
    IbStProc_Client.Unprepare;
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
  Except on E:Exception do
    Result := False;
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
  Except On E:Exception do
    Result := False;
  end;
end;



function TDm_Reservation.InsertCodeBarre(iIdClient: Integer): Boolean;
begin
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
end;


function TDm_Reservation.GetCodeBarre: String;
begin
  With IbStProc_Codebarre do
  begin
    Close;
    Prepared := true;
    ExecProc;
    Result := IbStProc_Codebarre.Fields[0].asString;
    Close;
    Unprepare;
  end;
end;



function TDm_Reservation.GetLocParamElt(Id: integer; sNom: String): Integer;
begin
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
end;

function TDm_Reservation.UpdateCLTMEMBREPRO(iPRMCLTIDPRO,
  iPRMCLTIDPART: Integer): Boolean;
begin
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
end;


function TDm_Reservation.GetProcChrono: String;
begin
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
end;


function TDm_Reservation.InsertReservation(iIdClient, iIdPro, iEtat, iPaiement, iMagId : Integer;
  sAccompte, sComment, sNum, sNoWeb, sRemise, sMontantPrev : String; dResaDebut, dResaFin : TDateTime; IdCentrale : Integer; ArrhesCom, ArrehseAco : String) : Integer;
var
  fRemise : currency;
  sRemiseText : String;
begin
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
end;


function TDm_Reservation.IsOCParamExist(OCC_MTYID, OCC_IDCENTRALE,
  RLO_OPTION: integer): Boolean;
begin
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
end;




function TDm_Reservation.InsertResaLigne(MaCentrale : TGENTYPEMAIL;iIdResa, iResaCasque, iResaMulti,
  iResaGarantie, iPrId: Integer; sResaIdent, sResaRemise, sResaPrix : String; dResaDebut,
  dResaFin: TDateTime; bInterSport : Boolean; sISComent : String): Integer;
var
  sRemise, sPrix : String;
  cPrix, cRemise : Currency;
begin
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
      case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3']) of
        // Twinner, Sport2k, Gen1,Gen2,Gen3
        0,2,4,5,6: FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXNET,sResaPrix); //  'Prix net : '
        // Skimium / Intersport
        1,3:   FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXBRUT, sResaPrix); // 'Prix Brut : '
      end;
//      FieldByName('RSL_COMENT').asstring := 'Prix Brut : ' + sResaPrix;
      if sResaRemise <> '' then
      begin
        case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3']) of
          // Twinner, Skimium , Intersport
          0,3  :   FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_REMISEPC, sResaRemise); // 'Remise : §0%'
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

    case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3']) of
      // Twinner, Sport2k, Gen1,Gen2,Gen3
      0,2,4,5,6: FieldByName('RSL_PXNET').AsCurrency := cPrix;
      // Skimium
      1        : FieldByName('RSL_PXNET').AsString := floatToStr(RoundRv(strTofloat(sResaRemise),2));
      // Skimium / Intersport
      3        : FieldByName('RSL_PXNET').AsCurrency := cPrix - cRemise;
    end;
    FieldByName('RSL_IDENT').asstring := sResaIdent;
    Post;

    Result := FieldByName('RSL_ID').AsInteger;
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
  icptoc:integer;
begin
  Result := True;
  MonXml := TmonXML.Create;

  // Si on est pas avec le poste référant on n'intègre pas les offres commerciales
  //if StdGinKoia.PosteID <> GetPostReferantId then
  //  exit;

  With Dm_Reservation do
  try
    // Ouverture de la table LOCCENTRALEOC pour récpèrer la liste des OC de cette centrale
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

    with MemD_Mail do
    begin
      First;
      while not EOF do
      begin
        // Si bTraiter n'est pas flaggé à vrai c'est que la pièce jointe n'était pas valide
        if FieldByName('bTraiter').AsBoolean then
        begin
          // chargement du fichier xml
          MonXml.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
          // Sélection du noeud articles
          nArticlesXml := MonXml.find('/fiche/articles');
          // récupération du 1er article
          eArticleXml  := MonXml.FindTag(nArticlesXml,'article');

          icptoc:=0;
          Fmain.ologfile.Addtext(RS_TXT_RESMAN_OC);
          while eArticleXml <> Nil do
          begin

            inc(icptoc);
            Fmain.ologfile.Addtext(RS_TXT_RESMAN_OCx+' '+inttostr(icptoc));

            (*
            - Vérification structurelle du XML, que les articles soient des "éléments" et pas des "attributs"
            du noeud Article.
            - Vérification qu'il y a au moins 2 éléments : nom et id_article
            *)

            if (eArticleXml.hasChild) and
              (MonXml.ValueTag(eArticleXml,'nom')<>'') and
              (MonXml.ValueTag(eArticleXml,'id_article')<>'') then
            begin

              sCentraleNom := MonXml.ValueTag(eArticleXml,'nom');
              if  MonXml.ValueTag(eArticleXml,'categorie') <> '' then
                sCentraleNom := sCentraleNom  + '(' + MonXml.ValueTag(eArticleXml,'categorie') + ')';

              // Vérification que l'OC existe
              if Que_LOCCENTRALEOC.Locate('OCC_IDCENTRALE',MonXml.ValueTag(eArticleXml,'id_article'),[]) then
              begin
                // OC Existante
                // Vérification si nom différent
                if Uppercase(Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString) <> Uppercase(sCentraleNom) then
                begin
                  //  si différent on met à jour
                  Que_LOCCENTRALEOC.Edit;
                  Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString := sCentraleNom;
                  Que_LOCCENTRALEOC.Post;
                end;
              end
              else begin
                // OC inéxistante donc création dans la table
                // puis passage du resultat à false pour indiquer qu'il y a eu nouvelle création d'OC
                Que_LOCCENTRALEOC.Append;
                Que_LOCCENTRALEOC.FieldByName('OCC_MTYID').AsInteger     := MaCentrale.MTY_ID;
                Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString        := sCentraleNom;
                Que_LOCCENTRALEOC.FieldByName('OCC_IDCENTRALE').AsString := MonXml.ValueTag(eArticleXml,'id_article');
                Que_LOCCENTRALEOC.Post;

                Result := False;
              end;

            end
            else begin
              Fmain.ologfile.Addtext(RS_ERR_RESMAN_OCx+' '+inttostr(icptoc));
            end;

            // on passe à l'article suivant
            eArticleXml := eArticleXml.nextSibling;
          end;
        end;
        Next;
         Fmain.UpdateGauge ;
     //   IncGaugeMessHP(1);
      end; // while
    end;  // With

  finally
    //CloseGaugeMessHP;
    Fmain.ResetGauge ;
    MonXml.Free;
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

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
  IdHTTP, IdGlobal, dateutils; //SK7


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

    //CVI - PRD_ID pour contrôle de validité de nomenclature (Type, Catégorie, CA)
    iPrdId : integer;

    
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
    function InsertCLTMEMBREPRO_ENMIEUX(iPRMCLTIDPRO, iPRMCLTIDPART: Integer) : Boolean;
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

    //CVI - Pour contrôle de validité de nomenclature (Type, Catégorie, CA)
    function CheckNomenclature(aPrdId : Integer) : String;

    // pour check des autorisations
    function GetPostReferantId : integer;
    function IsMagAutorisation(iMTYID,iMagId, iPosID : Integer) : Boolean;

    //SK7
    function CreateResaSki7(MaCentrale: TGENTYPEMAIL; ddate_debut,ddate_end:tdatetime): Boolean;

    // Conversion champ string en float
    function ConvertStrToFloat(const aValeur : String) : Double;

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
                                           'RESERVATION GOSPORT','RESERVATION SKISET']) of
        0: MonGTMail.MTY_CODE := 'RTW'; // Twinner
        1: MonGTMail.MTY_CODE := 'RIS'; // Intersport
        2: MonGTMail.MTY_CODE := 'RSK'; // Skimium
        3: MonGTMail.MTY_CODE := 'R2K'; // sport 2000
        4: MonGTMail.MTY_CODE := 'RG1'; // générique 1
        5: MonGTMail.MTY_CODE := 'RG2'; // générique 2
        6: MonGTMail.MTY_CODE := 'RG3'; // Générique 3
        7: MonGTMail.MTY_CODE := 'RGS'; // GoSport
        8: MonGTMail.MTY_CODE := 'RS7'; // SkiSet
        else
          MonGTMail.MTY_CODE := '';
      end;

      Result.Add(MonGTMail);
      Next;
    end;
  end;
  //PDB
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
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetMailCFG : '+e.message);
  end;
end;


// ----------- Début pour SKISET via WEBSERVICE ------------

//SK7
function TDm_Reservation.CreateResaSki7(MaCentrale: TGENTYPEMAIL; ddate_debut,ddate_end:tdatetime): Boolean;
var
  offre_xml,status_xml,booking_xml,mag_xml  : TmonXML;
  nroot: TIcXMLElement;
  node,node2,node3,node4,node5 : TIcXMLElement;

  httpcli: TIdHTTP;
  resget: TStringStream;
  surl,scle,suri_listmag,suri_listoffre,suri_listresa,suri_liststatus:string;
  tlistmag : array of string;

  i,cpt_art,cpt_trc  : integer;
  cpt_offer,cpt_resa,cpt_mag:integer;
  ss : string;

  soc_id,soc_nom:string;
  smag_id, smag_nom, smag_active:string;
  smag_resortid, smag_resort:string;
  sdate : string;

  //Pour l'XML
  //----------
  //Réservation
  sorigin      : string;
  smemberid    : string;
  sresortid    : string;
  sshopid      : string;
  sbookingid   : string;
  screationdate : string;
  supdatedate   : string;
  sstatus      : string;
  bmajresa      : boolean;
  bmajok        : boolean;
  bresaexist    : boolean;
  bresaannul    : boolean;
  sfirstday    : string;
  sduration    : string;
  sfirstname   : string;
  slastname    : string;
  sadress      : string;
  szipcode     : string;
  scity        : string;
  scountry     : string;
  sphonenumber : string;
  sdateofbirth : string;

  //customer
  sart_firstname        : string;
  sart_lastname         : string;
  sart_weight_value     : string;
  sart_weight_unit      : string;
  sart_height_value     : string;
  sart_height_unit      : string;
  sart_shoesize_value   : string;
  sart_shoesize_unit    : string;
  sart_helmetsize_value : string;
  sart_helmetsize_unit  : string;

  //offer
  soffertype_id    : string;
  soffertype_name  : string;
  soffer_id        : string;
  soffer_name      : string;
  sequipment_id    : string;
  sequipment_name  : string;
  sage_groupid     : string;
  sage_groupname   : string;

  //pack
  spack_withshoes        :string;
  spack_withelmet        :string;
  spack_skiertype        :string;
  spack_skiersexe        :string;
  spack_snowposition     :string;
  spack_insurancedamage  :string;
  spack_skifit           :string;

  //product
  sproduct_id      : string;
  sproduct_brand   : string;
  sproduct_model   : string;
  //------------

  //Idem CreateResa
  dDateDebut, dDateFin,
  dDateResa,dDateResaDebut,
  dDateResaFin    : TDateTime;
  dDateMaj    : TDateTime;
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

  //Idem CreateResa mais remplace des champs de MemD_RAP inutile
  sCentrale : string;

  lstRep : TStringList;

  //Spécifique
  sFullname : string;
  iIdAdr : integer;
  dDateNaiss : tdatetime;
  dcurdate : tdatetime;
  bcheckoc : boolean;
  iIdGenImp : integer;

  //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
  sCheckNomenclature : String;

  label gtResa_Next;

begin
  Result := True;

  cpt_trc:=10;

  try

    //Allocations dynamiques
    httpcli := TIdHTTP.Create(nil);
    cpt_trc:=11;
    httpcli.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    cpt_trc:=12;
    resget := TStringStream.Create('');
    cpt_trc:=13;
    offre_xml := TmonXML.Create;
    cpt_trc:=14;
    status_xml := TmonXML.Create;
    cpt_trc:=15;
    mag_xml := TmonXML.Create;
    cpt_trc:=16;
    booking_xml := TmonXML.Create;

    lstRep := TStringList.Create;

    cpt_trc:=20;

    try

      //Traitement
      //----------
      // récupère le format date heure local
      GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);
      // On le modifie pour qu'il soit compatible avec le format demandé dans les fichiers
      FSetting.ShortDateFormat := 'YYYY-MM-DD';
      FSetting.ShortTimeFormat:='HH:NN:SS';
      FSetting.DateSeparator := '-';
      FSetting.TimeSeparator:=':';

      iEtat := GetEtat(1,0);
      // Etat pré payée
      iPaiment := GetEtat(1,1);

      cpt_trc:=30;
      iTaille   := GetLocParam('Taille');
      iPoids    := GetLocParam('Poids');
      iPointure := GetLocParam('Pointure');
      cpt_trc:=40;

      //---------------

      Fmain.ResetGauge ;
      Fmain.InitGauge(StringReplace(RS_TXT_RESADM_RESAINPROGRESS,'§0',MaCentrale.MTY_NOM,[rfReplaceAll]), 5 );

      //Récupération des URL+URI d'accès dans GENPARAM
      //----------------------------------------------
      Fmain.trclog('TWeb service SKISET');
      Fmain.trclog('T');
      Fmain.trclog('T1-- Lecture des paramètres d''accès au webservice');
      with Que_TmpNoEvent do begin
        Close;
        sql.Clear;
        sql.add('select * from genparam where prm_type = 27 order by prm_code');
        Open;
        cpt_trc:=50;
        while not Eof do begin
          if fieldbyname('prm_code').asinteger=1 then surl:=fieldbyname('prm_string').asstring
          else if fieldbyname('prm_code').asinteger=2 then scle:=fieldbyname('prm_string').asstring
          else if fieldbyname('prm_code').asinteger=3 then suri_listmag:=fieldbyname('prm_string').asstring
          else if fieldbyname('prm_code').asinteger=4 then suri_listoffre:=fieldbyname('prm_string').asstring
          else if fieldbyname('prm_code').asinteger=5 then suri_listresa:=fieldbyname('prm_string').asstring
          else if fieldbyname('prm_code').asinteger=6 then suri_liststatus:=fieldbyname('prm_string').asstring;
          Next;
        end;
      end;
      cpt_trc:=60;
      Fmain.trclog('T - URL : '+surl);
      Fmain.trclog('T - Clé : '+scle);
      Fmain.trclog('T - URI liste des magasins : '+suri_listmag);
      Fmain.trclog('T - URI liste des offres : '+suri_listoffre);
      Fmain.trclog('T - URI liste des réservations : '+suri_listresa);
      Fmain.trclog('T - URI liste des status : '+suri_liststatus);
      Fmain.trclog('T');

      Fmain.UpdateGauge;

      //Récupération de la liste des status
      //-----------------------------------
      Fmain.trclog('T');
      Fmain.trclog('T2--Récupération de la liste des status');
      ss:=surl+suri_liststatus;
      ss:=StringReplace(ss, '[cle]', scle, [rfReplaceAll, rfIgnoreCase]);
      Fmain.trclog('TURL = '+ss);
      cpt_trc:=70;
      httpcli.Get(ss, resget);
      cpt_trc:=80;
      status_xml.loadfromstring(resget.DataString);
      cpt_trc:=90;
      //Fmain.oLogfile.Addtext(status_xml.SaveTostring);
      nroot := status_xml.find('/statuses');
      if nroot<>nil then begin
        cpt_trc:=100;
        Fmain.trclog('T'+inttostr(nroot.GetNodeList.length)+' status disponibles');
        node:=nroot.getFirstChild;
        while node<>nil do begin
          soc_id:=status_xml.ValueTag(node,'id');
          soc_nom:=status_xml.ValueTag(node,'name');
          Fmain.trclog('T  '+soc_id+'-'+soc_nom);
          node:=node.nextSibling;
        end;
      end
      else Fmain.trclog('TNoeud xml racine inexistant ("statuses"). Traitement abandonné.');
      Fmain.trclog('TFin traitement des status');
      Fmain.trclog('T');

      cpt_trc:=110;
      Fmain.UpdateGauge;
      resget.size:=0;

      //Gestion des offres
      //------------------
      Fmain.trclog('T');
      Fmain.trclog('T3--Traitement des offres');
      //httpcli.Get('http://pts.skiset.com/webservicesv4/getoffertypes/key/Z2lua29pYWlhbWFyZW50YWxzb2Z0d2FyZQ==e80d9e1d85ae3177614f14e59fee2c26', resget);
      ss:=surl+suri_listoffre;
      ss:=StringReplace(ss, '[cle]', scle, [rfReplaceAll, rfIgnoreCase]);
      Fmain.trclog('TURL = '+ss);
      cpt_trc:=120;
      httpcli.Get(ss, resget);
      cpt_trc:=130;
      offre_xml.loadfromstring(resget.DataString);
      cpt_trc:=140;
      //Fmain.oLogfile.Addtext(offre_xml.SaveTostring);

      nroot := offre_xml.find('/offertypes');
      if nroot<>nil then begin
        Fmain.trclog('T'+inttostr(nroot.GetNodeList.length)+' offres disponibles');

        With Que_LOCCENTRALEOC do
        begin
          Close;
          ParamCheck := True;
          ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
          Fmain.trclog('TOuverture des offres avec PMtyId:='+inttostr(MaCentrale.MTY_ID));
          Open;
          //trclog('T'+SQL.text);
          Fmain.trclog('TNbre. d''offres dans la base='+inttostr(recordcount));
        end;
        cpt_trc:=150;

        Fmain.trclog('TBoucle sur les offres');
        cpt_offer:=0;
        node:=nroot.getFirstChild;
        while node<>nil do begin
          inc(cpt_offer);
          soc_id:=offre_xml.ValueTag(node,'id');
          soc_nom:=offre_xml.ValueTag(node,'name');

          cpt_trc:=160;
          // Vérification que l'OC existe
          if Que_LOCCENTRALEOC.Locate('OCC_IDCENTRALE',soc_id,[]) then
          begin
            // OC Existante
            // Vérification si nom différent
            if Uppercase(Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString) <> Uppercase(soc_nom) then
            begin
              //  si différent on met à jour
              Que_LOCCENTRALEOC.Edit;
              Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString := soc_nom;
              Que_LOCCENTRALEOC.Post;
              //Dm_Main.Commit;
              ss:='offre modifiée';
            end
            else ss:='pas de changement';
          end
          else begin
            cpt_trc:=170;
            // OC inéxistante donc création dans la table
            // puis passage du resultat à false pour indiquer qu'il y a eu nouvelle création d'OC
            Que_LOCCENTRALEOC.Append;
            Que_LOCCENTRALEOC.FieldByName('OCC_MTYID').AsInteger     := MaCentrale.MTY_ID;
            Que_LOCCENTRALEOC.FieldByName('OCC_NOM').AsString        := soc_nom;
            Que_LOCCENTRALEOC.FieldByName('OCC_IDCENTRALE').AsString := soc_id;
            Que_LOCCENTRALEOC.Post;
            //Dm_Main.Commit;
            ss:='offre ajoutée';
          end;
          Fmain.trclog('T  n° '+inttostr(cpt_offer)+' '+soc_id+'-'+soc_nom+'   ->'+ss);

          node:=node.nextSibling;
        end;
      end
      else Fmain.trclog('TNoeud xml racine inexistant ("offertypes"). Traitement abandonné.');
      Fmain.trclog('TFin traitement des offres');
      Fmain.trclog('T');

      cpt_trc:=180;
      Fmain.UpdateGauge;
      resget.size:=0;

      //Récupération des magasins
      //-----------------------------
      Fmain.trclog('T');
      Fmain.trclog('T4--Récupération des magasins disponibles');
      ss:=surl+suri_listmag;
      ss:=StringReplace(ss, '[cle]', scle, [rfReplaceAll, rfIgnoreCase]);
      Fmain.trclog('TURL = '+ss);
      cpt_trc:=190;
      httpcli.Get(ss, resget);
      cpt_trc:=200;
      mag_xml.loadfromstring(resget.DataString);
      cpt_trc:=210;
      //Fmain.oLogfile.Addtext(mag_xml.SaveTostring);

      nroot := mag_xml.find('/shops');
      if nroot<>nil then begin
        Fmain.trclog('T'+inttostr(nroot.GetNodeList.length)+' magasin(s) disponibles');
        node:=nroot.getFirstChild;
        i:=0;
        while node<>nil do begin
          smag_id:=status_xml.ValueTag(node,'id');
          smag_nom:=status_xml.ValueTag(node,'name');
          smag_active:=status_xml.ValueTag(node,'active');
          smag_resortid:=status_xml.ValueTag(node,'resort_id');
          smag_resort:=status_xml.ValueTag(node,'resort_name');
          Fmain.trclog('T> '+smag_id+'-'+smag_nom+'-'+smag_active+'-'+smag_resortid+'-'+smag_resort);

          (*
          //Vérification que le magasin existe dans la base
          Que_TmpNoEvent.Close;
          Que_TmpNoEvent.SQL.Clear;
          Que_TmpNoEvent.SQL.Add('select * from genmagasin');
          //Que_TmpNoEvent.SQL.Add('where upper(mag_nom)='+uppercase(QuotedStr(smag_nom)));
          Que_TmpNoEvent.SQL.Add('where upper(mag_codeadh)='+uppercase(QuotedStr(smag_id)));
          Fmain.trclog('T  Recherche du magasin "'+smag_nom+'" (adh='+smag_id+')');
          Que_TmpNoEvent.Open;

          if Que_TmpNoEvent.Recordcount > 0 then begin
            Fmain.trclog('T Ce magasin existe et sera pris en compte');
            inc(i);
            setlength(tlistmag,i);
            tlistmag[i-1]:=smag_id;
          end
          else Fmain.trclog('T Ce magasin n''existe pas dans la base et sera ignoré');
          *)

          node:=node.nextSibling;
        end;
      end
      else Fmain.trclog('TNoeud xml racine inexistant ("shops"). Traitement abandonné.');

      Fmain.trclog('TFin traitement des magasins disponibles');
      Fmain.trclog('T');

      cpt_trc:=215;

      // Récupération de la liste des magasins à traiter
      Fmain.trclog('TRécupération des magasins à traiter dans le module');
      dm_reservation.Que_IdentMagExist.Close;
      dm_reservation.Que_IdentMagExist.ParamCheck := True;
      dm_reservation.Que_IdentMagExist.ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
      dm_reservation.Que_IdentMagExist.Open;

      cpt_mag:=0;
      if dm_reservation.Que_IdentMagExist.recordcount > 0 then begin
        while not dm_reservation.Que_IdentMagExist.EOF do begin
          if ((MaCentrale.MTY_MULTI <> 0) and (dm_reservation.POSID = dm_reservation.Que_IdentMagExist.FieldByName('IDM_POSID').AsInteger)) Or
             (MaCentrale.MTY_MULTI = 0) then begin
            lstRep.Text := StringReplace(Trim(dm_reservation.Que_IdentMagExist.FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);
            for i := 0 to lstRep.Count - 1 do begin
              inc(cpt_mag);
              setlength(tlistmag,cpt_mag);
              tlistmag[cpt_mag-1]:=Trim(lstRep[i]);
              Fmain.trclog('TIdentifiant "'+tlistmag[cpt_mag-1]+'"');
            end;
          end;
          dm_reservation.Que_IdentMagExist.next;
        end;
      end;
      dm_reservation.Que_IdentMagExist.Close;
      Fmain.trclog('T'+inttostr(cpt_mag)+' magasin(s) identifié(s)');
      Fmain.trclog('TFin traitement des magasins à traiter');
      Fmain.trclog('T');

      if length(tlistmag)=0 then begin
        Fmain.trclog('T> Aucun magasin à traiter, traitement abandonné');
        exit
      end;

      cpt_trc:=220;
      Fmain.UpdateGauge;
      resget.size:=0;

      Fmain.trclog('T');
      Fmain.trclog('T5--Récupération des réservations du '+datetostr(ddate_begin)+' au '+datetostr(ddate_end));

      //Vérification de la correspondance avec les OC. Sinon aucun traitement n'a lieu.
      //---------------------------------------------
      //Le code ci-dessous st un sous-ensemble du traitement d'intégration des réservations plus bas.
      Fmain.trclog('TVérification de la correspondance avec les OC');

      bcheckoc:=true;
      dcurdate:=ddate_begin;

      //Boucle de parcours de la période concernée
      while dcurdate<=ddate_end do begin

        sdate:=datetostr(dcurdate);

        for i := 1 to length(tlistmag) do begin

          ss:=surl+suri_listresa;
          ss:=StringReplace(ss, '[cle]', scle, [rfReplaceAll, rfIgnoreCase]);
          ss:=StringReplace(ss, '[idmag]', tlistmag[i-1], [rfReplaceAll, rfIgnoreCase]);
          ss:=StringReplace(ss, '[date_yyyy-mm-dd]', formatdatetime('yyyy-mm-dd',dcurdate), [rfReplaceAll, rfIgnoreCase]);

          //main.trclog('TURL = '+ss);
          resget.size:=0;
          httpcli.Get(ss, resget);
          booking_xml.loadfromstring(resget.DataString);

          nroot := booking_xml.find('/bookings');
          if nroot<>nil then begin

            cpt_resa:=0;
            node:=nroot.getFirstChild;
            while node<>nil do begin
              inc(cpt_resa);

              node2:=booking_xml.FindTag(node,'head');
              if node2<>nil then begin

                sbookingid:=booking_xml.ValueTag(node2,'bookingid');

                node2:=booking_xml.FindTag(node,'content');
                if node2<>nil then begin

                  node3:=node2.getFirstChild;
                  cpt_art:=0;

                  //Boucle sur les articles
                  while node3<>nil do begin

                    inc(cpt_art);
                    node4:=booking_xml.FindTag(node3,'pack');
                    if node4<>nil then begin

                      spack_withshoes:=booking_xml.ValueTag(node4,'withshoes');
                      spack_withelmet:=booking_xml.ValueTag(node4,'withelmet');
                      sCasque := spack_withelmet;

                      node5:=booking_xml.FindTag(node4,'offer');
                      if node5<>nil then begin

                        soffertype_id:=booking_xml.ValueTag(node5,'offertypeid');
                        soffertype_name:=booking_xml.ValueTag(node5,'offertypename');

                        if spack_withshoes = '0' then
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

                        //sIdArt := MonXml.ValueTag(eArticleXml,('id_article')); //Cette notion n'existe pas sur l'article
                        //N'est utilisé que dans le cadre de la recherche/validation par rapport aux OC.
                        //Donc on peut y mettre l'id de l'OC référencé sur l'artice :
                        sIdArt := soffertype_id;


                        if not IsOCParamExist(MaCentrale.MTY_ID,StrToIntDef(sIdArt,-1),iRLOOption) then begin
                          bcheckoc:=false;

                          //Ne pas faire car on aurait autant de message que d'erreur vu que le traitement de vérif des OC parcourt toutes les Resa.
                          //Ne garder que le log
                          //Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,iIdResa,sIdArt+'-'+soffertype_name])),
                          //  RS_TXT_RESCMN_ERREUR) ;

                           // Non... Fmain.ologfile.Addtext(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));
                           //....On force via le tracing comme si c'était une exception pour augmenter le comptage et obliger l'affichage du log
                           //main.trclog('X'+ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,iIdResa,sIdArt+'-'+soffertype_name])));
                           //trop verbeux est pas assez précis...

                           //Plus de détail
                           //main.trclog('E  '+MaCentrale.MTY_NOM+'  id='+sbookingid+' du magasin "'+tlistmag[i-1]+'" en date du '+sdate+' n° article '+inttostr(cpt_art)+' -> '+soffertype_id+'-'+soffertype_name+' -> PAS OK!');

                        end
                        else Fmain.trclog('T  id='+sbookingid+' du magasin "'+tlistmag[i-1]+'" en date du '+sdate+' n° article '+inttostr(cpt_art)+' -> '+soffertype_id+'-'+soffertype_name+' -> OK');

                      end;
                    end;

                    node3:=node3.nextSibling; //article suvant
                  end;

                end;

              end;

              //Réservation suivante
              node:=node.nextSibling;

            end;

          end; //booking

        end; //for...listmag

        dcurdate:=incday(dcurdate,1);
      end; //while... sur la période

      //On abandonne le traitement si il y a eu une non-correspondance
      if not bcheckoc then begin
        Fmain.trclog('T> Erreur de correspondance avec les OC, traitement abandonné');
        exit;
      end;

      Fmain.trclog('TCorrespondance OK avec les OC');
      Fmain.trclog('T> Intégration des réservations');

      Fmain.UpdateGauge;
      resget.size:=0;

      Fmain.trclog('T');
      //Récupération des réservations
      //-----------------------------
      //sdate:='2017-02-12';
      dcurdate:=ddate_begin;

      //Boucle de parcours de la période concernée
      while dcurdate<=ddate_end do begin

        sdate:=datetostr(dcurdate);
        Fmain.trclog('T');
        Fmain.trclog('T> En date du : '+sdate);

        if length(tlistmag)>0 then begin

        for i := 1 to length(tlistmag) do begin

          cpt_trc:=230;
          Fmain.trclog('T');
          Fmain.trclog('T> Pour le magasin '+tlistmag[i-1]);

          ss:=surl+suri_listresa;
          ss:=StringReplace(ss, '[cle]', scle, [rfReplaceAll, rfIgnoreCase]);
          ss:=StringReplace(ss, '[idmag]', tlistmag[i-1], [rfReplaceAll, rfIgnoreCase]);
          ss:=StringReplace(ss, '[date_yyyy-mm-dd]', formatdatetime('yyyy-mm-dd',dcurdate), [rfReplaceAll, rfIgnoreCase]);

          Fmain.trclog('TURL = '+ss);
          cpt_trc:=240;
          httpcli.Get(ss, resget);
          cpt_trc:=250;
          booking_xml.loadfromstring(resget.DataString);
          //Fmain.oLogfile.Addtext(booking_xml.SaveTostring);

          cpt_trc:=260;
          nroot := booking_xml.find('/bookings');
          if nroot<>nil then begin
            cpt_trc:=270;
            Fmain.trclog('T'+inttostr(nroot.GetNodeList.length)+' réservations disponibles');

            //Intégration des réservations
            cpt_resa:=0;
            node:=nroot.getFirstChild;
            while node<>nil do begin
              inc(cpt_resa);
              Fmain.trclog('TLecture de l''xml :');
              cpt_trc:=280;
              node2:=booking_xml.FindTag(node,'head');
              if node2<>nil then begin

                sorigin:=booking_xml.ValueTag(node2,'origin');             //main.trclog('T  origin='+sorigin);
                smemberid:=booking_xml.ValueTag(node2,'memberid');         //main.trclog('T  memberid='+smemberid);
                sresortid:=booking_xml.ValueTag(node2,'resortid');         //main.trclog('T  resortid='+sresortid);
                sshopid:=booking_xml.ValueTag(node2,'shopid');             //main.trclog('T  shopid='+sshopid);

                sbookingid:=booking_xml.ValueTag(node2,'bookingid');             Fmain.trclog('T>>RESERVATION n°'+inttostr(cpt_resa)+' bookingid='+sbookingid);
                screationdate:=booking_xml.ValueTag(node2,'creationdate');       Fmain.trclog('T  creationdate='+screationdate);
                supdatedate:=booking_xml.ValueTag(node2,'updatedate');           Fmain.trclog('T  updatedate='+supdatedate);
                sstatus:=booking_xml.ValueTag(node2,'status');                   Fmain.trclog('T    status='+sstatus);
                sfirstday:=booking_xml.ValueTag(node2,'firstday');               Fmain.trclog('T    firstday='+sfirstday);
                sduration:=booking_xml.ValueTag(node2,'duration');               Fmain.trclog('T    duration='+sduration);
                node3:=booking_xml.FindTag(node2,'customer');
                //Passage en uppercase car pas de cohérence dans l'XML
                sfirstname:=uppercase(booking_xml.ValueTag(node3,'firstname'));   Fmain.trclog('T    firstname='+sfirstname);
                slastname:=uppercase(booking_xml.ValueTag(node3,'lastname'));     Fmain.trclog('T    lastname='+slastname);
                sadress:=booking_xml.ValueTag(node3,'adress');                    Fmain.trclog('T    adress='+sadress);
                szipcode:=booking_xml.ValueTag(node3,'zipcode');                  Fmain.trclog('T    zipcode='+szipcode);
                scity:=booking_xml.ValueTag(node3,'city');                        Fmain.trclog('T    city='+scity);
                scountry:=booking_xml.ValueTag(node3,'country');                  Fmain.trclog('T    country='+scountry);
                sphonenumber:=booking_xml.ValueTag(node3,'phonenumber');          Fmain.trclog('T    phonenumber='+sphonenumber);
                sdateofbirth:=booking_xml.ValueTag(node3,'dateofbirth');          Fmain.trclog('T    dateofbirth='+sdateofbirth);

                //Traitement global de la réservation
                //-----------------------------------

                Fmain.trclog('T');
                Fmain.trclog('>>1INFORMATIONS DE SYNTHESE');
                sCentrale := MaCentrale.MTY_NOM;
                Fmain.trclog('T> Centrale : '+sCentrale);

                cpt_trc:=290;
                // Récupération des dates
                //-----------------------
                //Date de création
                if not TryStrToDateTime(screationdate, dDateResa, FSetting) then begin
                  dDateResa:=0;
                  Fmain.trclog('T> Date de création : ERREUR DE CONVERSION de '+screationdate);
                end
                else Fmain.trclog('T> Date de création : '+datetimetostr(dDateResa));
                //Date de début
                if not TryStrToDate(sfirstday, dDateDebut, FSetting) then begin
                  dDateDebut:=0;
                  Fmain.trclog('T> Date de début : ERREUR DE CONVERSION de '+sfirstday);
                end
                else Fmain.trclog('T> Date de début : '+datetostr(dDateDebut));
                //Durée
                iNbJours := StrToIntDef(sduration,0);
                Fmain.trclog('T> Durée : '+inttostr(iNbJours));
                //Calcul de la date de fin
                if (dDateDebut>0) and (iNbJours>0) then begin
                  dDateFin   := dDateDebut + iNbJours -1;
                  Fmain.trclog('T> Date de fin : '+datetostr(dDateFin));
                end
                else Fmain.trclog('T> Date de fin : ERREUR DE CALCUL');

                //Cas particulier de la date de mise à jour + status associé 22 (=PAIDAFTERUPDATE)
                //Indique une mise à jour de la resa.
                bmajresa:=false;
                bmajok:=false;
                if supdatedate<>'' then begin
                  bmajresa:=true;
                  if not TryStrToDate(supdatedate, dDateMaj, FSetting) then begin
                    dDateMaj:=0;
                    Fmain.trclog('T> Date de mise à jour : ERREUR DE CONVERSION de '+supdatedate);
                    Fmain.trclog('T> -> La demande de mise à jour n''est pas valable -> ignorer la resa');
                  end
                  else begin
                    Fmain.trclog('T> Date de mise à jour : '+datetostr(dDateMaj));
                    Fmain.trclog('T> Vérification du status');
                    if sstatus='22' then begin
                      Fmain.trclog('T> Status de mise à jour : '+sstatus);
                      bmajok:=true;
                      Fmain.trclog('T> -> La demande de mise à jour est valable -> poursuivre avec la resa');
                    end
                    else begin
                      Fmain.trclog('T> Status de mise à jour : '+sstatus);
                      Fmain.trclog('T> -> La demande de mise à jour n''est pas valable');
                    end;
                  end;
                end;

                //Vérifier si la resa existe au niveau de son bookingid dans genimport
                bresaexist:=IsReservationExist(sbookingid);

                cpt_trc:=290;
                bresaannul:=false;
                //Gérer l'annulation d'une resa en premier lieu (status=30 ou 31 et la resa existe déjà)
                //----
                if (sstatus='30') or (sstatus='31') then begin
                  bresaannul:=true;
                  Fmain.trclog('T> Demande d''annulation');
                  if bresaexist then begin
                    Fmain.trclog('T> Status d''annulation : '+sstatus);
                    Fmain.trclog('   Récupération du status "Annulé" dans la base');
                    with Que_TmpNoEvent do begin
                      Close;
                      sql.Clear;
                      sql.add('select ers_id from LOCETATRESERVATION where ers_ordre = 8');
                      Open;
                      iIdAdr:=fieldbyname('ers_id').asinteger;
                      Close;
                    end;
                    ss:=inttostr(iIdAdr);
                    Fmain.trclog('   Status "Annulé" = '+ss);

                    if iIdAdr>0 then begin

                      Fmain.trclog('   Mise à jour de l''état de réservation à  = '+ss);
                      dm_main.StartTransaction;
                      Que_TmpLoc.SQL.Clear;
                      Que_TmpLoc.SQL.Add('UPDATE LOCRESERVATION');
                      Que_TmpLoc.SQL.Add('SET RVS_ETATRESRID = '+ ss );
                      Que_TmpLoc.SQL.Add('WHERE RVS_ID = ' + inttostr(Que_ResaExist.fieldbyname('IMP_GINKOIA').asinteger));
                      //main.trclog('T  Que_TmpLoc.SQL='+Que_Tmp.SQL.text);
                      Que_TmpLoc.ExecSQL;

                      Que_TmpLoc.Close;
                      Que_TmpLoc.SQL.Clear;
                      Que_TmpLoc.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + inttostr(Que_ResaExist.fieldbyname('IMP_GINKOIA').asinteger) + ', 0)');
                      Que_TmpLoc.ExecSQL;

                      Dm_Main.Commit;

                    end
                    else begin
                      Fmain.trclog('   Status d''annulation non renseigné dans la base -> annulation de la resa ignorée');
                    end;
                    iIdAdr:=0;
                  end
                  else begin
                    Fmain.trclog('   La réservation renseignée n''existe pas -> annulation de la resa ignorée');
                  end;
                end;

                cpt_trc:=300;
                //Gérer la mise à jour, pour autant que les conditions sont remplies (date de màj + status=22 + resa existe + pas BL)
                //==========================
                //Voir si la réservation existe déjà (recherche dans GENIMPORT critère sur "imp_refstr")
                //Et la supprimer d'abord.
                //D'après ls infos reçues, "tout" peut êre modifié dans une réservation.
                //Donc il est plus facile de la supprimer et de la recréer en l'état le plus récent.
                if (not bresaannul) and (bresaexist) and (bmajresa) and (bmajok) then begin

                  //Récupérer l'ID de la réservation (=RVS_ID de LOCRESERVATION)
                  ss:=inttostr(Que_ResaExist.fieldbyname('IMP_GINKOIA').asinteger);

                  cpt_trc:=310;
                  Fmain.trclog('T> La réservation "'+sbookingid+ '" existe déjà -> validation des autres éléments indiquant sa mise à jour effective');
                  Que_TmpLoc.Close;
                  Que_TmpLoc.SQL.Clear;
                  Que_TmpLoc.SQL.Add('Select RVS_PAYMENTTIME,RVS_BL');
                  Que_TmpLoc.SQL.Add(' FROM LOCRESERVATION');
                  Que_TmpLoc.SQL.Add(' WHERE RVS_ID='+ss);
                  cpt_trc:=320;
                  Que_TmpLoc.ExecSQL;
                  Fmain.trclog('   Déjà transféré en BL : '+inttostr(Que_TmpLoc.fieldbyname('RVS_BL').asinteger));
                  Fmain.trclog('   Date de dernière màj : '+datetimetostr(Que_TmpLoc.fieldbyname('RVS_PAYMENTTIME').asdatetime));

                  //Refuser si RESA déjà transférée en BL
                  if Que_TmpLoc.fieldbyname('RVS_BL').asinteger>0 then bmajok:=false;
                  //Refuser si date maj fournie < ou = date de dernière mise à jour stocké dans la base
                  if dDateMaj<=Que_TmpLoc.fieldbyname('RVS_PAYMENTTIME').asdatetime then bmajok:=false;

                  //Mise à jour effective ou rejet
                  if bmajok then begin

                    Fmain.trclog('   > Toutes les conditions sont réunies pour traiter la resa en màj');

                    try

                    dm_main.StartTransaction;

                    Fmain.trclog('T>   suppression des sous-lignes');
                    //Suppression des sous-lignes de la réservation
                    //--------------
                    Que_TmpLoc.Close;
                    Que_TmpLoc.SQL.Clear;
                    Que_TmpLoc.SQL.Add('Select LOCRESERVATIONSOUSLIGNE.RSE_ID');
                    Que_TmpLoc.SQL.Add(' FROM LOCRESERVATIONLIGNE');
                    Que_TmpLoc.SQL.Add(' JOIN K ON (K_ID=RSL_ID AND K_ENABLED=1)');
                    Que_TmpLoc.SQL.Add(' JOIN LOCRESERVATIONSOUSLIGNE');
                    Que_TmpLoc.SQL.Add(' JOIN K ON (K_ID=RSE_ID AND K_ENABLED=1)');
                    Que_TmpLoc.SQL.Add(' ON (RSE_RSLID=RSL_ID)');
                    Que_TmpLoc.SQL.Add(' WHERE RSE_ID<>0 AND RSL_RVSID='+ss);
                    //main.trclog('T  Sélection sous-lignes SQL='+Que_Tmp.SQL.text);
                    cpt_trc:=320;
                    Que_TmpLoc.ExecSQL;

                    //Marquer les records correspondant dans K pour suppression
                    while not Que_TmpLoc.eof do begin
                      Que_TmpNoEvent.Close;
                      Que_TmpNoEvent.SQL.Clear;
                      Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(Que_TmpLoc.fieldbyname('RSE_ID').asinteger) + ', 1)');
                      Que_TmpNoEvent.ExecSQL;

                      Que_TmpLoc.next;
                    end;
                    cpt_trc:=330;

                    Que_TmpLoc.Close;
                    Que_TmpLoc.SQL.Clear;
                    Que_TmpLoc.SQL.Add('DELETE FROM LOCRESERVATIONSOUSLIGNE');
                    Que_TmpLoc.SQL.Add(' WHERE RSE_ID IN (');
                    Que_TmpLoc.SQL.Add('Select LOCRESERVATIONSOUSLIGNE.RSE_ID');
                    Que_TmpLoc.SQL.Add(' FROM LOCRESERVATIONLIGNE');
                    Que_TmpLoc.SQL.Add(' JOIN K ON (K_ID=RSL_ID AND K_ENABLED=1)');
                    Que_TmpLoc.SQL.Add(' JOIN LOCRESERVATIONSOUSLIGNE');
                    Que_TmpLoc.SQL.Add(' JOIN K ON (K_ID=RSE_ID AND K_ENABLED=1)');
                    Que_TmpLoc.SQL.Add(' ON (RSE_RSLID=RSL_ID)');
                    Que_TmpLoc.SQL.Add(' WHERE RSE_ID<>0 AND RSL_RVSID='+ss);
                    Que_TmpLoc.SQL.Add(')');
                    //main.trclog('Suppression sous-lignes SQL='+Que_Tmp.SQL.text);
                    cpt_trc:=340;
                    Que_TmpLoc.ExecSQL;


                    Fmain.trclog('T>   suppression des lignes');
                    //Suppression des lignes de la réservation
                    //--------------
                    Que_TmpLoc.Close;
                    Que_TmpLoc.SQL.Clear;
                    Que_TmpLoc.SQL.Add('Select LOCRESERVATIONLIGNE.RSL_ID');
                    Que_TmpLoc.SQL.Add(' FROM LOCRESERVATIONLIGNE');
                    Que_TmpLoc.SQL.Add(' JOIN K ON (K_ID=RSL_ID AND K_ENABLED=1)');
                    Que_TmpLoc.SQL.Add(' WHERE RSL_ID<>0 AND RSL_RVSID='+ss);
                    //main.trclog('T  Sélection sous-lignes SQL='+Que_Tmp.SQL.text);
                    cpt_trc:=350;
                    Que_TmpLoc.ExecSQL;

                    //Marquer les records correspondant dans K pour suppression
                    while not Que_TmpLoc.eof do begin
                      Que_TmpNoEvent.Close;
                      Que_TmpNoEvent.SQL.Clear;
                      Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(Que_TmpLoc.fieldbyname('RSL_ID').asinteger) + ', 1)');
                      Que_TmpNoEvent.ExecSQL;

                      Que_TmpLoc.next;
                    end;
                    cpt_trc:=360;

                    Que_TmpLoc.Close;
                    Que_TmpLoc.SQL.Clear;
                    Que_TmpLoc.SQL.Add('DELETE FROM LOCRESERVATIONLIGNE');
                    Que_TmpLoc.SQL.Add(' WHERE RSL_ID IN (');
                    Que_TmpLoc.SQL.Add('Select LOCRESERVATIONLIGNE.RSL_ID');
                    Que_TmpLoc.SQL.Add(' FROM LOCRESERVATIONLIGNE');
                    Que_TmpLoc.SQL.Add(' JOIN K ON (K_ID=RSL_ID AND K_ENABLED=1)');
                    Que_TmpLoc.SQL.Add(' WHERE RSL_ID<>0 AND RSL_RVSID='+ss);
                    Que_TmpLoc.SQL.Add(')');
                    //main.trclog('Suppression sous-lignes SQL='+Que_Tmp.SQL.text);
                    cpt_trc:=370;
                    Que_TmpLoc.ExecSQL;


                    Fmain.trclog('T>   suppression de la réservation');
                    //Suppression de la réservation
                    //--------------
                    Que_TmpNoEvent.Close;
                    Que_TmpNoEvent.SQL.Clear;
                    Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + ss + ', 1)');
                    Que_TmpNoEvent.ExecSQL;
                    cpt_trc:=380;

                    Que_TmpLoc.Close;
                    Que_TmpLoc.SQL.Clear;
                    Que_TmpLoc.SQL.Add('DELETE FROM LOCRESERVATION');
                    Que_TmpLoc.SQL.Add(' WHERE RVS_ID='+ss);
                    //main.trclog('Suppression resa SQL='+Que_Tmp.SQL.text);
                    Que_TmpLoc.ExecSQL;
                    cpt_trc:=382;

                    //Suppression de GENIMPORT
                    Que_TmpNoEvent.Close;
                    Que_TmpNoEvent.SQL.Clear;
                    Que_TmpNoEvent.SQL.Add('select * from genimport');
                    Que_TmpNoEvent.SQL.Add('where imp_num=5');
                    Que_TmpNoEvent.SQL.Add('  and imp_refstr=' + QuotedStr(ss));
                    Que_TmpNoEvent.SQL.Add('  and imp_ktbid=-11111512');
                    Que_TmpNoEvent.SQL.Add('  and imp_ref='+inttostr(MaCentrale.MTY_ID)); //prende en compte l'ID de la centrale
                    Fmain.trclog('T> Recherche de la resa dans genimport '+ss);
                    Que_TmpNoEvent.Open;

                    if Que_TmpNoEvent.Recordcount <> 0 then begin
                      cpt_trc:=384;
                      iIdGenImp := Que_TmpNoEvent.FieldByName('imp_id').AsInteger;
                      Fmain.trclog('T> Trouvé idgenimport='+inttostr(iIdGenImp)+', on supprime');

                      Que_TmpLoc.Close;
                      Que_TmpLoc.SQL.Clear;
                      Que_TmpLoc.SQL.Add('DELETE FROM GENIMPORT');
                      Que_TmpLoc.SQL.Add(' WHERE IMP_ID='+inttostr(iIdGenImp));
                      //main.trclog('Suppression resa SQL='+Que_Tmp.SQL.text);
                      Que_TmpLoc.ExecSQL;
                      cpt_trc:=386;

                      Que_TmpNoEvent.Close;
                      Que_TmpNoEvent.SQL.Clear;
                      Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + inttostr(iIdGenImp) + ', 1)');
                      Que_TmpNoEvent.ExecSQL;
                      cpt_trc:=388;

                    end
                    else Fmain.trclog('T> Pas trouvé, on ignore...');

                    //Suppression du client
                    //--------------------
                    cpt_trc:=390;

                    //Suppression de GENIMPORT
                    Que_TmpNoEvent.Close;
                    Que_TmpNoEvent.SQL.Clear;
                    Que_TmpNoEvent.SQL.Add('select * from genimport');
                    Que_TmpNoEvent.SQL.Add('where imp_num=5');
                    sFullname:=QuotedStr(slastname+' '+sfirstname);
                    Que_TmpNoEvent.SQL.Add('  and imp_refstr=' + sFullname);
                    Que_TmpNoEvent.SQL.Add('  and imp_ktbid=-11111401');
                    Que_TmpNoEvent.SQL.Add('  and imp_ref='+inttostr(MaCentrale.MTY_ID)); //prende en compte l'ID de la centrale
                    Fmain.trclog('T> Recherche du client dans genimport '+sFullname);
                    Que_TmpNoEvent.Open;

                    if Que_TmpNoEvent.Recordcount > 0 then begin
                      cpt_trc:=391;
                      iIdGenImp := Que_TmpNoEvent.FieldByName('imp_id').AsInteger;
                      iIdClient := Que_TmpNoEvent.FieldByName('imp_ginkoia').AsInteger;
                      Fmain.trclog('T> Trouvé idgenimport='+inttostr(iIdGenImp)+', on supprime');

                      cpt_trc:=392;
                      Que_TmpLoc.Close;
                      Que_TmpLoc.SQL.Clear;
                      Que_TmpLoc.SQL.Add('DELETE FROM GENIMPORT');
                      Que_TmpLoc.SQL.Add(' WHERE IMP_ID='+inttostr(iIdGenImp));
                      Que_TmpLoc.ExecSQL;

                      cpt_trc:=393;
                      Que_TmpNoEvent.Close;
                      Que_TmpNoEvent.SQL.Clear;
                      Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + inttostr(iIdGenImp) + ', 1)');
                      Que_TmpNoEvent.ExecSQL;

                      //Suppression de l'adresse
                      cpt_trc:=394;
                      Que_Client.Close;
                      Que_Client.ParamByName('cltid').asInteger := iIdClient;
                      Que_Client.Open;
                      if Que_Client.Recordcount > 0 then begin
                        cpt_trc:=395;

                        iIdAdr:=Que_Client.fieldbyname('ADR_ID').AsInteger;
                        Fmain.trclog('T> Trouvé adr_id='+inttostr(iIdAdr)+', on supprime');

                        Que_TmpLoc.Close;
                        Que_TmpLoc.SQL.Clear;
                        Que_TmpLoc.SQL.Add('DELETE FROM genadresse');
                        Que_TmpLoc.SQL.Add(' WHERE ADR_ID='+inttostr(iIdAdr));
                        Que_TmpLoc.ExecSQL;

                        Que_TmpNoEvent.Close;
                        Que_TmpNoEvent.SQL.Clear;
                        Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + inttostr(iIdAdr) + ', 1)');
                        Que_TmpNoEvent.ExecSQL;

                      end
                      else Fmain.trclog('T> Pas trouvé, on ignore...');

                      cpt_trc:=396;
                      //Suppression du client
                      Que_TmpLoc.Close;
                      Que_TmpLoc.SQL.Clear;
                      Que_TmpLoc.SQL.Add('DELETE FROM cltclient ');
                      Que_TmpLoc.SQL.Add(' WHERE CLT_ID='+inttostr(iIdClient));
                      Que_TmpLoc.ExecSQL;

                      Que_TmpNoEvent.Close;
                      Que_TmpNoEvent.SQL.Clear;
                      Que_TmpNoEvent.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + inttostr(iIdClient) + ', 1)');
                      Que_TmpNoEvent.ExecSQL;

                    end
                    else Fmain.trclog('T> Pas trouvé, on ignore...');

                    Dm_Main.Commit;

                    cpt_trc:=400;
                    except
                      on e:exception do begin
                        Fmain.trclog('X> Exception lors de la suppression de la réservation : '+e.Message);
                        Dm_Main.Rollback;
                      end;
                    end;

                  end
                  else Fmain.trclog('   > Toutes les conditions ne sont pas réunies pour traiter la resa en màj!');

                end;

                //Poursuite du traitement normal si :
                // - la réservation n'existait pas encore
                // - la réservation existait et la demande de mise à jour était valable

                if (not bresaannul) and (not bresaexist) or ( (bresaexist) and (bmajresa) and (bmajok) ) then begin

                  //!!! ON AJOUTE TOUJOURS UN NOUVEAU CLIENT CAR IL N'Y A QUE LE NOM+PRENOM POUR L'IDENTIFIER -> risque d'écrasement
                  (*
                  //Traitement du client + adresse
                  //===================
                  // Récherche du client - pass d'ID dans l'XML, il faut se baser sur NOM+PRENOM
                  Fmain.trclog('T> Traitement du client + Addresse');
                  cpt_trc:=410;
                  With Que_TmpNoEvent do
                  begin
                    Close;
                    SQL.Clear;
                    SQL.Add('select * from genimport');
                    SQL.Add('where imp_num=5');
                    sFullname:=QuotedStr(slastname+' '+sfirstname);
                    SQL.Add('  and imp_refstr=' + sfullname);
                    SQL.Add('  and imp_ktbid=-11111401');
                    SQL.Add('  and imp_ref='+inttostr(MaCentrale.MTY_ID)); //prende en compte l'ID de la centrale
                    Fmain.trclog('T> Recherche du client '+sfullname);
                    Open;
                    if Recordcount <> 0 then begin
                      iImpGinKoia := FieldByName('imp_ginkoia').AsInteger;
                      iIdClient := iImpGinKoia;
                    end
                    else
                      iImpGinKoia := -1;
                  end;
                  FlagInsert := (iImpGinKoia = -1);
                  *)

                  //ON FORCE L'AJOUT
                  FlagInsert := true;
                  Fmain.trclog('T> On force l''ajout d''un nouveau client dans tous les cas');

                  cpt_trc:=420;
                  //Le client n'existe pas -> Ajout
                  //-------------
                  if FlagInsert then  begin

                    cpt_trc:=430;
                    Fmain.trclog('T> Le client '+sfullname+ ' n''existe pas encore -> création');

                    //D'abord ajout de son adresse (si elle existe dans l'xml, au moins le pays)
                    Fmain.trclog('T> Traitement de l''adresse');

                    //On créé toujours l'adresse même vide
                    //iIdAdr:=0;
                    //if (scountry<>'') then begin

                      //main.trclog('TIl y a au moins le pays de renseigné-> création de l''adresse');
                      //Relativement inutile, car info pays,zip et pays pas renseigné dans l'xml

                      // Récupèration/création de l'id_pays
                      iIdPays := GetPaysId(scountry);
                      // récupération/Création de l'id_ville
                      iIdVille := GetVilleId(scity,szipcode,iIdPays);

                      iIdAdr:=0;
                      With Que_GenAdresse do begin
                        if not Active then begin
                          Close;
                          ParamByName('adrid').AsInteger := -1; //pour qu'il y ait un paramètre à la requête
                          Open;
                        end;
                        Append();
                        FieldByName('ADR_LIGNE').asstring := uppercase(sadress);
                        FieldByName('ADR_VILID').asinteger := iIdVille;
                        FieldByName('ADR_TEL').asstring := sphonenumber;
                        FieldByName('ADR_FAX').asstring := '';
                        FieldByName('ADR_EMAIL').asstring := '' ;  //Pas présent dans l'ml
                        Post;
                        iIdAdr:=fieldbyname('ADR_ID').AsInteger;
                      end;

                    //end
                    //else Fmain.trclog('TIl n''y a pas au minimum le pays de renseigné-> pas de création de l''adresse');

                    cpt_trc:=440;
                    Fmain.trclog('T> Traitement du client');
                    //Ensuite ajout du client avec le lien sur l'adresse
                    With Que_Client do begin
                      if not Active then begin
                        Close;
                        ParamByName('cltid').asInteger := -1; //pour qu'il y ait un paramètre à la requête
                        Open;
                      end;
                      Append();
                      //iMagId := GetMagId(MaCentrale.MTY_ID,MemD_Mail.FieldByName('MailIdMag').AsString);
                      iMagId := GetMagId(MaCentrale.MTY_ID,tlistmag[i-1]);
                      Fmain.trclog('T>iMagId='+inttostr(iMagId));
                      FieldByName('CLT_NOM').asstring := Trim(UpperCase(slastname));
                      FieldByName('CLT_PRENOM').asstring := Trim(UpperCase(sfirstname));
                      FieldByName('CLT_ADRID').asinteger := iIdAdr;
                      FieldByname ('clt_magid') .asinteger := iMagId;

                      //Pas de civilité dans l'xml SkiSet, et mettre 0 pas -1 sinon ne s'affiche pas dans Ginkoia
                      FieldByname ('CLT_CIVID').asinteger :=0;
                      (*
                      IF MonXml.ValueTag (eClientXml, 'civilite') <> '' THEN
                      BEGIN
                        FieldByname ('CLT_CIVID').asinteger := GetCiviliteId(MonXml.ValueTag (eClientXml, 'civilite'));
                      END;
                      *)
                      if sdateofbirth <> '' then begin
                        if TryStrToDate(sdateofbirth, dDateNaiss, FSetting) then FieldByname ('CLT_NAISSANCE').asdatetime:=dDateNaiss;
                      end;

                      Post;
                      iIdClient := FieldByName('CLT_ID').AsInteger;
                      Fmain.trclog('>1CLT_ID créé='+inttostr(iIdClient));
                    end;

                    cpt_trc:=450;
                    //Liaison aven GENIMPORT - pas d'id client dans l'xml -> NOM PRENOM
                    //Dorénavant, toujours rajouter l'ID de la centrale en plus dans imp_ref
                    Fmain.trclog('TRépercution dans GENIMPORT');
                    InsertGENIMPORT(iIdClient,-11111401,5,uppercase(slastname)+' '+uppercase(sfirstname),MaCentrale.MTY_ID);

                    cpt_trc:=460;
                  end

                  else begin
                    Fmain.trclog('T> Le client '+sfullname+ ' existe déjà ->màj de l''adresse');

                    //MAJ  client
                    With Que_Client do begin
                      Close;
                      ParamByName('cltid').asInteger := iIdClient;
                      Open;
                      //Il faut juste récupérer l'id de l'adresse
                      iIdAdr:=fieldbyname('CLT_ADRID').AsInteger;
                    end;

                    //Maj adresse
                    iIdPays := GetPaysId(scountry);
                    // récupération/Création de l'id_ville
                    iIdVille := GetVilleId(scity,szipcode,iIdPays);
                    With Que_GenAdresse do begin
                      Close;
                      ParamByName('adrid').AsInteger := iIdAdr;
                      Open;
                      Edit;
                      FieldByName('ADR_LIGNE').asstring := uppercase(sadress);
                      FieldByName('ADR_VILID').asinteger := iIdVille;
                      FieldByName('ADR_TEL').asstring := sphonenumber;
                      FieldByName('ADR_FAX').asstring := '';
                      FieldByName('ADR_EMAIL').asstring := '' ;  //Pas présent dans l'ml
                      Post;
                    end;

                    //iMagId := GetMagId(MaCentrale.MTY_ID,MemD_Mail.FieldByName('MailIdMag').AsString);
                    iMagId := GetMagId(MaCentrale.MTY_ID,tlistmag[i-1]);

                    Fmain.trclog('T>iMagId='+inttostr(iMagId));

                    Fmain.trclog('>1CLT_ID existant='+inttostr(iIdClient));

                  end;

                  //Traitement de la réservation - (re)création
                  //=========================

                  Fmain.trclog('T> Création de la réservation "'+sbookingid+ '"');

                  cpt_trc:=470;
                  //Poursuite du traitement de la réservation

                  // Gestion du TO
                  (* n'existe pas dans l'xml
                  if MonXml.ValueTag(nReservationXml,'nom_TO') <> '' then
                    iIdPro := GetIdTO(MonXml.ValueTag(nReservationXml,'nom_TO'),iMagId);
                  else
                  *)
                    iIdPro := MaCentrale.MTY_CLTIDPRO;//  GetIdPro;

                  if FlagInsert then
                    InsertCLTMEMBREPRO(iIdPro,iIdClient)
                  else
                    UpdateCLTMEMBREPRO(iIdPro,iIdClient);

                  //Codebarre client
                  Fmain.trclog('T> Récupération du codebarre client');
                  InsertCodeBarre(iIdClient);

                  cpt_trc:=480;
                  //Traitement de l'entête de la reservation
                  Fmain.trclog('T> Récupération du chrono pour la réservation');
                  sNumChrono := GetProcChrono;
                  Fmain.trclog('TAjout de la réservation, chrono='+sNumChrono);
                  iIdResa := InsertReservation(
                                    iIdClient,
                                    iIdPro,
                                    iEtat,
                                    iPaiment,
                                    iMagId,
                                    sAcompte,
                                    sbookingid, //MonXml.ValueTag(nReservationXml,'numero'),
                                    sNumChrono,
                                    sbookingid, //MonXml.ValueTag(nReservationXml,'numero'),
                                    '', //MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'),'remise'),
                                    '', //MonXml.ValueTag(MonXml.FindTag(eFactureXml,'remise_client_supplementaire'), 'total_avec_remise'),
                                    dDateDebut,
                                    dDateFin,
                                    MaCentrale.MTY_ID,
                                    '', //MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission'),
                                    ''  //MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission')
                                    );
                  Fmain.trclog('TRVS_ID créé='+inttostr(iIdResa));

                  cpt_trc:=485;
                  Fmain.trclog('T  Mise à jour de la date de traitement');
                  Que_Resa.Edit;
                  Que_Resa.fieldbyname('RVS_PAYMENTTIME').asdatetime:=now;
                  Que_Resa.Post;
                  Fmain.trclog('T  Fixée au '+datetimetostr(Que_Resa.fieldbyname('RVS_PAYMENTTIME').asdatetime));


                  dDateResaDebut:=dDateDebut;
                  dDateResaFin:=dDateFin;

                  cpt_trc:=490;
                  Fmain.trclog('TRépercution dans GENIMPORT');
                  //Lien avec genimport : IdResa = %d - NumChrono = %s.', [iIdResa, sNumChrono]
                  //Dorénavant, toujours rajouter l'ID de la centrale en plus dans imp_ref
                  InsertGENIMPORT(iIdResa,-11111512,5,sbookingid,MaCentrale.MTY_ID);

                  cpt_trc:=500;

                  //Traitement des lignes de détail - articles
                  //-------------
                  Fmain.trclog('TTraitement des articles de la réservation');

                  //Content, qui contient tous les articles
                  node2:=booking_xml.FindTag(node,'content');
                  if node2<>nil then begin

                    //Nbre. d'article dans la réservation
                    Fmain.trclog('T  '+inttostr(node2.GetNodeList.length)+' articles');
                    node3:=node2.getFirstChild;
                    cpt_art:=0;

                    Fmain.trclog('T  Parcours des articles');
                    //Boucle sur tous les articles de la réservation
                    while node3<>nil do begin

                      //Affiche le n° d'ordre de l'article avant de commencer
                      inc(cpt_art);
                      Fmain.trclog('T');
                      Fmain.trclog('T  Article n°'+inttostr(cpt_art)+')');

                      //Infos sur la personne
                      Fmain.trclog('T    Infos sur la personne :');
                      node4:=booking_xml.FindTag(node3,'person');
                      if node4<>nil then begin

                        sart_firstname:=booking_xml.ValueTag(node4,'first_name');    Fmain.trclog('T      first_name='+sart_firstname);
                        sart_lastname:=booking_xml.ValueTag(node4,'last_name');      Fmain.trclog('T      last_name='+sart_lastname);

                        node5:=booking_xml.FindTag(node4,'weight');
                        if node5<>nil then begin
                          sart_weight_value:=booking_xml.ValueTag(node5,'value');    Fmain.trclog('T      weight_value='+sart_weight_value);
                          sart_weight_unit:=booking_xml.ValueTag(node5,'unit');      Fmain.trclog('T      weight_unit='+sart_weight_unit);
                        end
                        else Fmain.trclog('T      Noeud "weight" absent -> poids ignoré! -> poursuite de l''article.');

                        node5:=booking_xml.FindTag(node4,'height');
                        if node5<>nil then begin
                          sart_height_value:=booking_xml.ValueTag(node5,'value');    Fmain.trclog('T      height_value='+sart_height_value);
                          sart_height_unit:=booking_xml.ValueTag(node5,'unit');      Fmain.trclog('T      height_unit='+sart_height_unit);
                        end
                        else Fmain.trclog('T      Noeud "height" absent -> taille ignorée! -> poursuite de l''article.');

                        node5:=booking_xml.FindTag(node4,'shoesize');
                        if node5<>nil then begin
                          sart_shoesize_value:=booking_xml.ValueTag(node5,'value');    Fmain.trclog('T      shoesize_value='+sart_shoesize_value);
                          sart_shoesize_unit:=booking_xml.ValueTag(node5,'unit');      Fmain.trclog('T      shoesize_unit='+sart_shoesize_unit);
                        end
                        else Fmain.trclog('T      Noeud "shoesize" absent -> taille chaussure ignorée! -> poursuite de l''article.');

                        node5:=booking_xml.FindTag(node4,'helmetsize');
                        if node5<>nil then begin
                          sart_helmetsize_value:=booking_xml.ValueTag(node5,'value');    Fmain.trclog('T      helmetsize_value='+sart_helmetsize_value);
                          sart_helmetsize_unit:=booking_xml.ValueTag(node5,'unit');      Fmain.trclog('T      helmetsize_unit='+sart_helmetsize_unit);
                        end
                        else Fmain.trclog('T      Noeud "helmetsize" absent -> taille casque ignorée! -> poursuite de l''article.');

                      end
                      else Fmain.trclog('T      Noeud "person" absent -> réservation ignorée!');

                      //Infos sur Pack
                      Fmain.trclog('T    Infos sur le pack :');
                      node4:=booking_xml.FindTag(node3,'pack');
                      if node4<>nil then begin
                        spack_withshoes:=booking_xml.ValueTag(node4,'withshoes');                Fmain.trclog('T      withshoes='+spack_withshoes);
                        spack_withelmet:=booking_xml.ValueTag(node4,'withelmet');                Fmain.trclog('T      withelmet='+spack_withelmet);
                        spack_skiertype:=booking_xml.ValueTag(node4,'skiertype');                Fmain.trclog('T      skiertype='+spack_skiertype);
                        spack_skiersexe:=booking_xml.ValueTag(node4,'skiersexe');                Fmain.trclog('T      skiersexe='+spack_skiersexe);
                        spack_snowposition:=booking_xml.ValueTag(node4,'snowposition');          Fmain.trclog('T      snowposition='+spack_snowposition);
                        spack_insurancedamage:=booking_xml.ValueTag(node4,'insurancedamage');    Fmain.trclog('T      insurancedamage='+spack_insurancedamage);
                        spack_skifit:=booking_xml.ValueTag(node4,'skifit');                      Fmain.trclog('T      skifit='+spack_skifit);
                      end
                      else Fmain.trclog('T    Noeud "pack" absent -> pack ignoré! -> poursuite de l''article.');

                      //Offer - Répétition du détail de l'offre (cf. liste des offres traitées en amont)
                      Fmain.trclog('T    Infos répétées de l''offre :');
                      node5:=booking_xml.FindTag(node4,'offer');
                      if node5<>nil then begin
                        soffertype_id:=booking_xml.ValueTag(node5,'offertypeid');                Fmain.trclog('T      offertypeid='+soffertype_id);
                        soffertype_name:=booking_xml.ValueTag(node5,'offertypename');            Fmain.trclog('T      offertypename='+soffertype_name);
                        soffer_id:=booking_xml.ValueTag(node5,'offerid');                        Fmain.trclog('T      offerid='+soffer_id);
                        soffer_name:=booking_xml.ValueTag(node5,'offername');                    Fmain.trclog('T      offername='+soffer_name);
                        sequipment_id:=booking_xml.ValueTag(node5,'equipmentid');                Fmain.trclog('T      equipmentid='+sequipment_id);
                        sequipment_name:=booking_xml.ValueTag(node5,'equipmentname');            Fmain.trclog('T      equipmentname='+sequipment_name);
                        sage_groupid:=booking_xml.ValueTag(node5,'agegroupid');                  Fmain.trclog('T      agegroupid='+sage_groupid);
                        sage_groupname:=booking_xml.ValueTag(node5,'agegroupname');              Fmain.trclog('T      agegroupname='+sage_groupname);

                      end
                      else Fmain.trclog('T    Noeud "offer" absent -> offre ignoré! -> poursuite de l''article.');

                      //Product - Détail du produit spécifique réservé
                      Fmain.trclog('T    Infos sur le produit spécifique réservé :');
                      node5:=booking_xml.FindTag(node4,'product');
                      if node5<>nil then begin
                        sproduct_id:=booking_xml.ValueTag(node5,'id');               Fmain.trclog('T      id='+sproduct_id);
                        sproduct_brand:=booking_xml.ValueTag(node5,'brand');         Fmain.trclog('T      brand='+sproduct_brand);
                        sproduct_model:=booking_xml.ValueTag(node5,'model');         Fmain.trclog('T      model='+sproduct_model);
                      end
                      else Fmain.trclog('T    Noeud "product" absent -> produit ignoré! -> poursuite de l''article.');


                      sCasque := spack_withelmet;
                      sMulti  :='0'; //Cette notion n'existe pas (Twinner, Skium)
                      sGarantie := spack_insurancedamage;
                      //sIdArt := MonXml.ValueTag(eArticleXml,('id_article')); //Cette notion n'existe pas sur l'article
                      //N'est utilisé que dans le cadre de la recherche/validation par rapport aux OC.
                      //Donc on peut y mettre l'id de l'OC référencé sur l'artice :
                      sIdArt := soffertype_id;

                      if spack_withshoes = '0' then
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


                      Fmain.trclog('T    Vérification du lien avec l''OC');
                      IF not IsOCParamExist(MaCentrale.MTY_ID,StrToIntDef(sIdArt,-1),iRLOOption) THEN
                      BEGIN // La relation est manquante
                          cpt_trc:=600;
                          {
          //              MaCentrale.MTY_NOM +  ' : Intégration interrompue, le paramétrage' + #13#10 + 'des offres commerciales est incomplet...' + #13#10 +
          //              'Réservation : ' + MemD_Mail.FieldByName('MailIdResa').AsString + #13#10 +
          //              'Offre : ' +  MonXml.ValueTag(eArticleXml,('nom'))
            (*            InfoMessHP (ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))]))
                                    ,True,0,0,RS_TXT_RESCMN_ERREUR);     *)

                           Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,iIdResa,sIdArt+'-'+soffertype_name])),
                             RS_TXT_RESCMN_ERREUR) ;

                         // Non... Fmain.ologfile.Addtext(ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,MemD_Mail.FieldByName('MailIdResa').AsString,MonXml.ValueTag(eArticleXml,('nom'))])));
                         //....On force via le tracing comme si c'était une exception pour augmenter le comptage et obliger l'affichage du log
                         Fmain.trclog('T'+ParamsStr(RS_ERR_RESADM_CANCELINTEG,VarArrayOf([MaCentrale.MTY_NOM,iIdResa,sIdArt+'-'+soffertype_name])));
                         Fmain.trclog('Q-');

                         Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

                        Result := false;
                        EXIT;
                        }

                        Fmain.trclog('FLa relation avec l''OC est manquante :'+soffertype_name);
                        goto gtResa_Next;

                      END;
                      Fmain.trclog('T    La relation avec l''OC existe');

                      //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
                      Fmain.trclog('TCVI : contrôle nomenclature avec PrdId='+inttostr(iPrdId));
                      sCheckNomenclature := CheckNomenclature(iPrdId);
                      if sCheckNomenclature <> '' then
                      begin
                        Fmain.trclog('F'+sCheckNomenclature);
                        goto gtResa_Next;
                      end;

                      //Intégration de l'article
                      Fmain.trclog('T    Ajout de l''article');
                      cpt_trc:=610;
                      iIdResaligne := InsertResaLigne(
                        MaCentrale,
                        iIdResa,
                        StrToIntDef(sCasque,0),
                        StrToIntDef(sMulti,0),
                        StrToIntDef(sGarantie,0),
                        Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger, // Ouvert lors de l'exécution de IsOCParamExist
                        sart_firstname,  ///MonXml.ValueTag(eSkieurXML, 'prenom'),
                        '0',  /// notion n'existe pas : MonXml.ValueTag(eArticleXml, 'remise'),
                        '0',  /// notion n'existe pas : MonXml.ValueTag(eArticleXml, 'prix'),
                        dDateResaDebut,
                        dDateResaFin
                        );

                        cpt_trc:=620;
                        //Traitement du commentaire dans l'adresse
                        //seulement si il y a eu création de celle-ci précédement
                        Fmain.trclog('T    Traitement du commentaire');
                        if iIdAdr<>0 then begin
                          sTemp := '';
                          IF sCasque = '1' THEN begin
                            sTemp := 'Casque';
                            if sart_helmetsize_value<>'' then sTemp:=sTemp+' ('+sart_helmetsize_value+')';
                          end;
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
                            //Ignorer ce test car dans le cas SkiSet la garantie n'est pas mentionnée (bien que j'y mets l'assurance faute de mieux)
                            if not (sTemp = '') then
                            begin
                              Edit;
                              FieldByName('ADR_COMMENT').AsString := copy ('   ' + uppercase (sart_firstname) +
                                                                           ' : ' + sTemp + #13 + #10 +
                                                                           FieldByName('ADR_COMMENT').AsString, 1, 1024);
                              Post;
                            end;
                          end;

                        end
                        else Fmain.trclog('T    Pas d''adresse -> pas de commentaire');


                        cpt_trc:=630;
                        //Traitement des sous-lignes pour les réponses
                        Fmain.trclog('T    Traitement des sous-lignes (réponses)');

                        // On remet au debut la requete (Requete activé dans IsOcParamExist
                        Que_LOCOCRELATION.First;

                        WHILE NOT Que_LOCOCRELATION.eof DO
                        BEGIN
                          {$IFDEF DEBUG}
                          OutputDebugString(' - Création des lignes de réponses.');
                          {$ENDIF}

                          //main.trclog('TLoop...'+Que_LOCTYPERELATION.sql.text);
                          //main.trclog('TPPrdID='+inttostr(Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger));
                          //main.trclog('TPMtyId='+inttostr(MaCentrale.MTY_ID));

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

                              //main.trclog('LTR_PTR='+inttostr(FieldByName('LTR_PTR').AsInteger));
                              if FieldByName('LTR_PTR').AsInteger = 1 then
                              begin
                                //main.trclog('T>>Appel pointure...');
                                iLceId := GetLocParamElt(iPointure,sart_shoesize_value);

                                {$IFDEF DEBUG}
                                OutputDebugString(PChar(Format(' - Réponse "pointure". LceId = %d', [iLceId])));
                                {$ENDIF}

                                //main.trclog('T      '+PChar(Format(' - Réponse "pointure". LceId = %d', [iLceId])));
                                InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                              end;

                              //main.trclog('LTR_TAILLE='+inttostr(FieldByName('LTR_TAILLE').AsInteger));
                              if FieldByName('LTR_TAILLE').AsInteger = 1 then
                              begin
                                //main.trclog('T>>Appel taille...');
                                iLceId := GetLocParamElt(iTaille,sart_height_value);

                                {$IFDEF DEBUG}
                                OutputDebugString(PChar(Format(' - Réponse "taille". LceId = %d', [iLceId])));
                                {$ENDIF}

                                //main.trclog('T      '+PChar(Format(' - Réponse "taille". LceId = %d', [iLceId])));
                                InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                              end;

                              //main.trclog('LTR_POIDS='+inttostr(FieldByName('LTR_POIDS').AsInteger));
                              if FieldByName('LTR_POIDS').asInteger = 1 then
                              begin
                                //main.trclog('T>>Appel poids...');
                                ilceId := GetLocParamElt(iPoids,sart_weight_value);

                                {$IFDEF DEBUG}
                                OutputDebugString(PChar(Format(' - Réponse "poids". LceId = %d', [iLceId])));
                                {$ENDIF}

                                //main.trclog('T      '+PChar(Format(' - Réponse "poids". LceId = %d', [iLceId])));
                                InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                              end;

                              // On insère une ligne sans valeur
                              if iLceId = 0 then
                              begin
                                {$IFDEF DEBUG}
                                OutputDebugString(PChar(Format(' - Réponse sans valeur. LceId = %d', [iLceId])));
                                {$ENDIF}

                                //main.trclog('T      '+PChar(Format(' - Réponse sans valeur. LceId = %d', [iLceId])));
                                InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,0);
                              end;
                              Que_LOCTYPERELATION.Next;
                            end;
                            Que_LOCOCRELATION.Next;
                          end; //with
                        end; // while
                        Fmain.trclog('T    Fin de traitement de l''article -> au suivant');

                        cpt_trc:=640;
                      //Article suivant dans la réservation
                      node3:=node3.nextSibling;
                    end;
                    Fmain.trclog('T Tous les articles ont été traités');


                    Fmain.trclog('T Mise à jour du commentaire client');
                    cpt_trc:=650;
                    //mise à jour du commentaire client
                    With Que_GenAdresse do
                    begin
                      Edit;
                      FieldByName('ADR_COMMENT').AsString := copy ('Réserv. du ' + FormatDateTime('DD/MM/YYYY',dDateDebut) +
                                                                   ' au ' + FormatDateTime('DD/MM/YYYY',dDateFin) +
                                                                   (*
                                                                   ' Arrhes : ' + MonXml.ValueTag(eFactureXml,'arrhes') + '€' + #13 + #10 +
                                                                   ' Commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'),'commission') +
                                                                   ' arrhes moins la commission : ' + MonXml.ValueTag(MonXml.FindTag(eFactureXml,'detailarrhe'), 'acompte_moins_commission') + #13 + #10 +
                                                                   *)
                                                                   FieldByName('ADR_COMMENT').AsString, 1, 1024) ;
                      Post;
                    end;


                    Fmain.trclog('T  >> ETAT FINAL DES PAIEMENTS');
                    Fmain.trclog('T  >> - RVS_ACCOMPTE = '+inttostr(Que_Resa.fieldbyname('RVS_ACCOMPTE').asinteger));
                    Fmain.trclog('T  >> - RVS_MONTANTPREV = '+inttostr(Que_Resa.fieldbyname('RVS_MONTANTPREV').asinteger));
                    Fmain.trclog('T  >> - RVS_COMMI = '+inttostr(Que_Resa.fieldbyname('RVS_COMMI').asinteger));


                  end
                  else Fmain.trclog('TNoeud "article" absent -> réservation ignorée!');

                  //----------------------------------------

                end
                else Fmain.trclog('   > Resa ignorée!');

              end
              else Fmain.trclog('TNoeud d''entête "head" absent -> réservation ignorée!');
              cpt_trc:=660;
gtResa_Next:
              //Réservation suivante
              node:=node.nextSibling;
            end;
          end

          //Absence de réservation pour le couple magasin+date
          else begin
            nroot := booking_xml.find('/errors');
            if nroot<>nil
              then Fmain.trclog('TAucune réservation ce jour. Traitement terminé.')
              else Fmain.trclog('TNoeud xml racine inexistant ("bookings"). Traitement abandonné.');
          end;
          resget.size:=0;

        //For... magasin suivant
        end;

        end
        else begin
          Fmain.trclog('T> Aucun magasin à traiter');
        end;

        dcurdate:=incday(dcurdate,1);
      end; //while... sur la période

      Fmain.UpdateGauge;
      Fmain.Refresh;

      cpt_trc:=700;
      Fmain.trclog('T');
      Fmain.trclog('T6--Commit des caches');
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
        cpt_trc:=710;
      EXCEPT
        on e:exception do begin
          cpt_trc:=720;
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
      cpt_trc:=730;
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
      cpt_trc:=740;

      Fmain.UpdateGauge;

      Fmain.trclog('T');
      Fmain.trclog('TFin traitement des réservations');
      Fmain.trclog('T');

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
    httpcli.free;
    resget.free;
    mag_xml.free;
    booking_xml.free;
    status_xml.free;
    offre_xml.Free;
    lstRep.free;
  end;

end;

// ----------- Fin pour SKISET via WEBSERVICE ------------



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
  bxmlresa_ok : boolean;

  //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
  sCheckNomenclature : String;

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

                  //PDB - Obsolète, revu : plus complet pour gestion des erreurs
                  (*
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
                  *)
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

                  cpt_trc:=500;
                  sNumChrono := GetProcChrono;
                  Fmain.trclog('T  Récupération du chrono '+snumchrono);
                  //Entete de la reservation
                  Fmain.trclog('T  Création de l''entête de réservation');
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
                  Fmain.trclog('T  Mise à jour du commentaire client');
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
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetPaysId : '+e.message);
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
  //PDB
  Except
    on E:Exception do Fmain.trclog('XErreur dans GetVilleId : '+e.message);
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
      FieldByName('RVS_ACCOMPTE').AsFloat := StrToFloatDef(sAccompte,0);//SK7
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
      FieldByName('RVS_MONTANTPREV').AsFloat := ConvertStrToFloat(sMontantPrev);
      Post;
      Result := FieldByName('RVS_ID').AsInteger;
    end;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans InsertReservation : '+e.message);
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

      (*
      Fmain.trclog('T CVI : SQL '+sql.text);
      Fmain.trclog('T  OCC_MTYID='+inttostr(OCC_MTYID));
      Fmain.trclog('T  OCC_IDCENTRALE='+inttostr(OCC_IDCENTRALE));
      Fmain.trclog('T  RLO_OPTION='+inttostr(RLO_OPTION));
      *)

      Open;

      if Recordcount > 0 then
      begin
        //PDB pour contrôle CVI sur nomenclature
        if FieldByName('RLO_PRDID').AsInteger > 0
          then iPrdId := FieldByName('RLO_PRDID').AsInteger
          else iPrdId := -1;
        Result := (FieldByName('RLO_PRDID').AsInteger <> 0)
      end
      else
        Result := False;
    end;
  //PDB
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


function TDm_Reservation.InsertResaLigne(MaCentrale : TGENTYPEMAIL;iIdResa, iResaCasque, iResaMulti,
  iResaGarantie, iPrId: Integer; sResaIdent, sResaRemise, sResaPrix : String; dResaDebut,
  dResaFin: TDateTime; bInterSport : Boolean; sISComent : String): Integer;
var
  dPrix, dRemise : Double;
begin
  // Initialisation
  dPrix := 0;
  dRemise := 0;

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
        case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7']) of
          // Twinner, Sport2k, Gen1,Gen2,Gen3
          0,2,4,5,6,7,8: FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXNET,sResaPrix); //  'Prix net : '
          // Skimium / Intersport
          1,3:   FieldByName('RSL_COMENT').asstring := ParamsStr(RS_TXT_RESADM_PRIXBRUT, sResaPrix); // 'Prix Brut : '
        end;
  //      FieldByName('RSL_COMENT').asstring := 'Prix Brut : ' + sResaPrix;
        if sResaRemise <> '' then
        begin
          case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7']) of
            // Twinner, Skimium , Intersport
            0,3,7  :   FieldByName('RSL_COMENT').asstring := FieldByName('RSL_COMENT').asstring + ' / ' + ParamsStr(RS_TXT_RESADM_REMISEPC, sResaRemise); // 'Remise : §0%'
            //Skiset
            8 : FieldByName('RSL_COMENT').asstring := 'Payé en ligne';
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

      dPrix := ConvertStrToFloat(sResaPrix);

      // Skimium / Intersport
      if Trim(sResaRemise) <> '' then
        dRemise := (dPrix * ConvertStrToFloat(sResaRemise)) / 100;

      case AnsiIndexStr(MaCentrale.MTY_CODE,['RTW','RSK','R2K','RIS','RG1','RG2','RG3','RGS','RS7']) of
        // Twinner, Sport2k, Gen1,Gen2,Gen3
        0,2,4,5,6,7,8 : FieldByName('RSL_PXNET').AsFloat := dPrix;
        // Skimium
        1        : FieldByName('RSL_PXNET').AsFloat := ConvertStrToFloat(sResaRemise);
        // Skimium / Intersport
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
  //PDB
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


end.

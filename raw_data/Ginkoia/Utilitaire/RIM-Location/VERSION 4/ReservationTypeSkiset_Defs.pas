unit ReservationTypeSkiset_Defs;

interface

uses
  Contnrs,
  SysUtils,
  Classes,
  uGestionBDD;

const
  // Constantes pour nom client sur réservation
  CCLIENTNOM = 'Réservation Skiset n°';
  // Constantes pour connexion au web service SKISET
  CAPIUSER = 'X-Skiset-Api-User';
  CAPIKEY = 'X-Skiset-Api-Key';
  CSTATUS_CANCELLED = 'CANCELLED';
  // message envoyer par les methode patch
  CAFFECTBOOKINGSHOP = '{ "shop_id": %s }';
  CSERVEBOOKINGPACK = '{ "served": %s }';

type
   // Liste des actions possibles lors de l'appel au web service
  TActionWebService = (awsListeOffres, awsDetailOffre, awsDetailMagasin, awsListeResaMagasin, awsListeResaStation, awsListePacksResa, awsPatchSetMagasin, awsPatchSetServi);

  // Objet pour JSON
  THref = class(TPersistent)
  private
    Fhref : String;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property href : String read Fhref write Fhref;
  end;

  // Objet JSON pour les offres
  TLinkOffre = class(TPersistent)
  private
    Fself : THref;
  public
    constructor Create;
    destructor Destroy;  override;
  published
    property self : THref read Fself write Fself;
  end;

  TJsonOffre = class(TPersistent)
  private
    Fid : Integer;
    Ftrademark : String;
    Foffer_id : Integer;
    Fgroup_id : Integer;
    Fcomposition_id : Integer;
    Foffer : String;
    fgroup : String;
    Fcomposition : String;
    Fpack: String;
    F_links : TLinkOffre;
  public
    constructor Create;
    destructor Destroy; override;

  published
    property id : Integer               read Fid                write Fid;
    property trademark : String         read Ftrademark         write Ftrademark;
    property offer_id : Integer         read Foffer_id          write Foffer_id;
    property group_id : Integer         read Fgroup_id          write Fgroup_id;
    property composition_id : Integer   read Fcomposition_id    write Fcomposition_id;
    property offer : String             read Foffer             write Foffer;
    property group : String             read Fgroup             write Fgroup;
    property composition : String       read Fcomposition       write Fcomposition;
    property pack : String              read Fpack              write Fpack;
    property _links : TLinkOffre        read F_links            write F_links;
  end;

  TJsonOffres = array of TJsonOffre;

  // Objet métier pour les offres
  TOffre = class(TPersistent)
  private
    FId : Integer;
    FCentrale : String;
    FOffreNom : String;
  published
    property Id : Integer        read FId         write FId;
    property Centrale : String   read FCentrale   write FCentrale;
    property OffreNom : String   read FOffreNom   write FOffreNom;
  end;

  TOffres = array of TOffre;

  // Objet pour les magasins
  TLinkMagasin = class(TPersistent)
  private
    Fself : THref;
    Fresort : THref;
    Fcountry : THref;
  published
    property self : THref read Fself write Fself;
    property resort : THref read Fresort write Fresort;
    property country : THref read Fcountry write Fcountry;
  end;

  TJsonMagasin = class(TPersistent)
  private
    Fid : Integer;
    Fresort_id : integer;
    Fcountry_id : integer;
    Fname : string;
    Fmember : string;
    Fcity : string;
    Fcountry : string;
    F_links : TLinkMagasin;
  published
    property id : Integer               read Fid                write Fid;
    property resort_id : integer        read Fresort_id         write Fresort_id;
    property country_id : integer       read Fcountry_id        write Fcountry_id;
    property name : string              read Fname              write Fname;
    property member : string            read Fmember            write Fmember;
    property city : string              read Fcity              write Fcity;
    property country : string           read Fcountry           write Fcountry;
    property _links : TLinkMagasin      read F_links            write F_links;
  end;

  TJsonMagasins = array of TJsonMagasin;

  TMagasin = class(TPersistent)
  private
    FMagId : Integer;
    FPresta : String;
    FCentraleId : Integer;
    FPosId : Integer;
    FMtaId : Integer;
  published
    property MagId : Integer      read FMagId       write FMagId;
    property Presta : String      read FPresta      write FPresta;
    property CentraleId : Integer read FCentraleId  write FCentraleId;
    property PosId : Integer      read FPosId       write FPosId;
    property MtaId : Integer      Read FMtaId       write FMtaId;
  end;

  TListeMagasins = class(TObjectList)
  private
    function GetItem(iIndex : Integer) : TMagasin;
    procedure SetItem(iIndex : Integer; const Value : TMagasin);
  public
    function Add(aObject : TMagasin) : Integer;
    procedure Insert(iIndex : Integer; aObject : TObject);
    property Items[iIndex : Integer] : TMagasin read GetItem write SetItem; default;
  end;

  // Objet JSON pour les lignes de réservation
  TLinkLigneResa = class(TPersistent)
  private
    Fself : THref;
    Fbooking : THref;
    Fpack : THref;
  public
    constructor Create;
    destructor Destroy;  override;
  published
    property self : THref     read Fself      write Fself;
    property booking : THref  read Fbooking   write Fbooking;
    property pack : THref     read Fpack      write Fpack;
  end;

  TJsonAmountBilling = class(TPersistent)
  private
    Famount_ttc: Currency;
    Ftva_rate: Currency;
    Fcurrency: string;
    Fcompany: string;
  published
    property amount_ttc: Currency read Famount_ttc write Famount_ttc;
    property tva_rate: Currency read Ftva_rate write Ftva_rate;
    property devise: string read Fcurrency write Fcurrency;
    property company: string read Fcompany write Fcompany;
  end;

  TJsonLigneReservation = class(TPersistent)
  private
    Fid : Integer;
    Freference : String;
    Fpack_id : Integer;
    Foffer_id : String;
    Foffer : String;
    Fequipment : String;
    Fwith_shoes : Boolean;
    Fwith_helmet : Boolean;
    Finsurance : Boolean;
    Fagegroup : String;
    Fduration : Integer;
    Ffirst_day : TDateTime;
    Ffirstname : String;
    Flastname : String;
    Fgroupname : String;
    Fage : Integer;
    Fheight : String;
    Fweight : String;
    Fshoesize : String;
    Fheadsize : String;
    Fsnowposition : String;
    Fskier_level : String;
    Fskier_sexe : String;
    Fserved : Boolean;
    Famount_billing: TJsonAmountBilling;
    Fcreated_on : TDateTime;
    Fupdated_on : TDateTime;
    F_links : TLinkLigneResa;
  public
    constructor Create;
    destructor Destroy;  override;
  published
    property id : Integer             read Fid            write Fid;
    property reference : String       read Freference     write Freference;
    property pack_id : Integer        read Fpack_id       write Fpack_id;
    property offer_id : String        read Foffer_id      write Foffer_id;
    property offer : String           read Foffer         write Foffer;
    property equipment : String       read Fequipment     write Fequipment;
    property with_shoes : Boolean     read Fwith_shoes    write Fwith_shoes;
    property with_helmet : Boolean    read Fwith_helmet   write Fwith_helmet;
    property insurance : Boolean      read Finsurance     write Finsurance;
    property agegroup : String        read Fagegroup      write Fagegroup;
    property duration : Integer       read Fduration      write Fduration;
    property first_day : TDateTime    read Ffirst_day     write Ffirst_day;
    property firstname : String       read Ffirstname     write Ffirstname;
    property lastname : String        read Flastname      write Flastname;
    property groupname : String       read Fgroupname     write Fgroupname;
    property age : Integer            read Fage           write Fage;
    property height : String          read Fheight        write Fheight;
    property weight : String          read Fweight        write Fweight;
    property shoesize : String        read Fshoesize      write Fshoesize;
    property headsize : String        read Fheadsize      write Fheadsize;
    property snowposition : String    read Fsnowposition  write Fsnowposition;
    property skier_level : String     read Fskier_level   write Fskier_level;
    property skier_sexe : String      read Fskier_sexe    write Fskier_sexe;
    property served : Boolean         read Fserved        write Fserved;
    property amount_billing: TJsonAmountBilling read Famount_billing write Famount_billing;
    property created_on : TDateTime   read Fcreated_on    write Fcreated_on;
    property updated_on : TDateTime   read Fupdated_on    write Fupdated_on;
    property _links : TLinkLigneResa  read F_links        write F_links;
  end;

  TJsonLignesReservation = array of TJsonLigneReservation;

  // Objet métier pour les lignes de réservation
  TLigneReservation = class(TPersistent)
  private
    FId : Integer;
    FReference : String;
    FPackId : Integer;
    FAvecCasque : Boolean;
    FAssurance : Boolean;                      
    FDateDebut : TDateTime;
    FNbJours : Integer;
    FClient : String;
    FTaille : String;
    FPoids : String;
    FPointure : String;
    FTourTete : String;
    FPositionSnow : String;
    FNiveauSki : String;
    FMaterielServi : Boolean;
    FAmountTTC: Currency;
    FDateMAJ : TDateTime;
  published
    property Id : Integer             read FId              write FId;
    property Reference : String       read FReference       write FReference;
    property PackId : Integer         read FPackId          write FPackId;
    property AvecCasque : Boolean     read FAvecCasque      write FAvecCasque;
    property Assurance : Boolean      read FAssurance       write FAssurance;
    property DateDebut : TDateTime    read FDateDebut       write FDateDebut;
    property NbJours : Integer        read FNbJours         write FNbJours;
    property Client : String          read FClient          write FClient;
    property Taille : String          read FTaille          write FTaille;
    property Poids : String           read FPoids           write FPoids;
    property Pointure : String        read FPointure        write FPointure;
    property TourTete : String        read FTourTete        write FTourTete;
    property PositionSnow : String    read FPositionSnow    write FPositionSnow;
    property NiveauSki : String       read FNiveauSki       write FNiveauSki;
    property MaterielServi : Boolean  read FMaterielServi   write FMaterielServi;
    property AmountTTC: Currency      read FAmountTTC       write FAmountTTC;
    property DateMAJ : TDateTime      read FDateMAJ         write FDateMAJ;
  end;

  TLignesReservation = array of TLigneReservation;

  // Objet JSON pour les réservations
  TLinkResa = class(TPersistent)
  private
    Fself : THref;
    Fpacks : THref;
    Ftourops : THref;
  public
    constructor Create;
    destructor Destroy;  override;
  published
    property self : THref     read Fself    write Fself;
    property packs : THref    read Fpacks   write Fpacks;
    property tourops : THref  read Ftourops write Ftourops;
  end;

  TJsonReservation = class(TPersistent)
  private
    Fid : String;
    Freference : String;
    Ftourop_id : Integer;
    Ftourop_name : String;
    Fcustomer_id : string;
    Fcustomer_email : string;
    Fcustomer_phone : string;
    Ffirstname : String;
    Flastname : String;
    Fbookingstatus : String;
    Fcancellation_date : TDateTime;
    Fcountry_id : Integer;
    Fresort_id : Integer;
    Fshop_id : Integer;
    Fwith_shop : Boolean;
    Ftrademark : string;
    Ffirst_day : TDateTime;
    Flast_day : TDateTime;
    Fduration : Integer;
    Fnbpacks : Integer;
    Fcreated_on : TDateTime;
    Fupdated_on : TDateTime;
    F_links : TLinkResa;
  public
    constructor Create;
    destructor Destroy;  override;

  published
    property id : String                    read Fid                  write Fid;
    property reference : String             read Freference           write Freference;
    property tourop_id : Integer            read Ftourop_id           write Ftourop_id;
    property tourop_name : String           read Ftourop_name         write Ftourop_name;
    property customer_id : string           read Fcustomer_id         write Fcustomer_id;
    property customer_email : string        read Fcustomer_email      write Fcustomer_email;
    property customer_phone : string        read Fcustomer_phone      write Fcustomer_phone;
    property firstname : String             read Ffirstname           write Ffirstname;
    property lastname : String              read Flastname            write Flastname;
    property bookingstatus : String         read Fbookingstatus       write Fbookingstatus;
    property cancellation_date : TDateTime  read Fcancellation_date   write Fcancellation_date;
    property country_id : Integer           read Fcountry_id          write Fcountry_id;
    property resort_id : Integer            read Fresort_id           write Fresort_id;
    property shop_id : Integer              read Fshop_id             write Fshop_id;
    property with_shop : Boolean            read Fwith_shop           write Fwith_shop;
    property trademark : string             read Ftrademark           write Ftrademark;
    property first_day : TDateTime          read Ffirst_day           write Ffirst_day;
    property last_day : TDateTime           read Flast_day            write Flast_day;
    property duration : Integer             read Fduration            write Fduration;
    property nbpacks : Integer              read Fnbpacks             write Fnbpacks;
    property created_on : TDateTime         read Fcreated_on          write Fcreated_on;
    property updated_on : TDateTime         read Fupdated_on          write Fupdated_on;
    property _links : TLinkResa             read F_links              write F_links;
  end;

  TJsonReservations = array of TJsonReservation;

  // Objet métier pour les réservations
  TReservation = class(TPersistent)
  private
    FId : String;
    FReference : String;
    FCentrale : String;
    FClientNom : String;
    FClientPrenom : String;
    FClientId : String;
    FClientEmail : String;
    FClientPhone : String;
    FStatus : String;
    FDateAnnulation : TDateTime;
    FMagId : Integer;
    FDateDebut : TDateTime;
    FDateFin : TDateTime;
    FNbJours : Integer;
    FDateCreation : TDateTime;
    FDateMAJ : TDateTime;
    FOrganisme : String;
    FNbPacks : Integer;
    FReservationLignes : TLignesReservation;
  public
    constructor Create;
    destructor Destroy;  override;
  published
    property Id : String                  read FId              write FId;
    property Reference : String           read FReference       write FReference;
    property Centrale : String            read FCentrale        write FCentrale;
    property ClientNom : String           read FClientNom       write FClientNom;
    property ClientPrenom : String        read FClientPrenom    write FClientPrenom;
    property ClientID : String            read FClientId        write FClientId;
    property ClientEmail : String         read FClientEmail     write FClientEmail;
    property ClientPhone : String         read FClientPhone     write FClientPhone;
    property Status : String              read FStatus          write FStatus;
    property DateAnnulation : TDateTime   read FDateAnnulation  write FDateAnnulation;
    property MagId : Integer              read FMagId           write FMagId;
    property DateDebut : TDateTime        read FDateDebut       write FDateDebut;
    property DateFin : TDateTime          read FDateFin         write FDateFin;
    property NbJours : Integer            read FNbJours         write FNbJours;
    property DateCreation : TDateTime     read FDateCreation    write FDateCreation;
    property DateMAJ : TDateTime          read FDateMAJ         write FDateMAJ;
    property Organisme : String           read FOrganisme       write FOrganisme;
    property NbPacks : Integer            read FNbPacks         write FNbPacks;
    property ReservationLignes : TLignesReservation   read FReservationLignes   write FReservationLignes;
  end;

  TReservations = array of TReservation;

  TTranspoJson = class(TPersistent)
  public
    class function CopyJSONToOffre(aJsonOffre : TJsonOffre): TOffre;
    class function CopyJSONToOffres(aJsonOffres : TJsonOffres) : TOffres;
    class function CopyJSONToReservation(aJsonReservation : TJsonReservation) : TReservation;
    class function CopyJSONToReservations(aJsonReservations : TJsonReservations) : TReservations;
    class function CopyJSONToLignesReservation(aJsonLignesReservation : TJsonLignesReservation) : TLignesReservation;
  end;

  TInfosReservation = class(TPersistent)
  private
    FIdResa : Integer;
    FIdClient : Integer;
    FDateResa : TDateTime;
    FTransfertBL : Integer;
    FCltAdrId : Integer;
  published
    property IdResa : Integer      read FIdResa      write FIdResa;
    property IdClient : Integer    read FIdClient    write FIdClient;
    property DateResa : TDateTime  read FDateResa    write FDateResa;
    property TransfertBL : Integer read FTransfertBL write FTransfertBL;
    property CltAdrId : Integer       read FCltAdrId       write FCltAdrId;
  end;

  TClient = class(TPersistent)
  private
    FID : Integer;
    FNom : String;
    FPrenom : String;
    FAdresseId : Integer;
    FMagId : Integer;
    FCivilite : Integer;
    FDebutSejourVO : TDateTime;
    FDureeVO : Integer;
    FDureeVODate : TDateTime;
  public
    procedure Assign(aSource : TPersistent);  override;
  published
    property Id : Integer         read FID          write FID;
    property Nom : String         read FNom         write FNom;
    property Prenom : String      read FPrenom      write FPrenom;
    property AdresseId : Integer  read FAdresseId   write FAdresseId;
    property MagId : Integer      read FMagId       write FMagId;
    property Civilite : Integer   read FCivilite    write FCivilite;
    property DebutSejourVO : TDateTime   read FDebutSejourVO   write FDebutSejourVO;
    property DureeVO : Integer    read FDureeVO     write FDureeVO;
    property DureeVODate : TDateTime  read FDureeVODate   write FDureeVODate;
  end;

  // Classe utilisée pour récupérer les paramètres de la locations
  TParamLoc = class(TPersistent)
  private
    FRetourAM : TDateTime;
    FSortieAM : TDateTime;
    FRetourPM : TDateTime;
    FDJSup    : boolean;
    FSortiePM : TDateTime;
    Fnbjsaison : integer;
    FDJSuppC: Double;
  published
    property SortieAM : TDateTime   read FSortieAM      write FSortieAM ;
    property SortiePM : TDateTime   read FSortiePM      write FSortiePM ;
    property RetourAM : TDateTime   read FRetourAM      write FRetourAM ;
    property RetourPM : TDateTime   read FRetourPM      write FRetourPM ;
    property DJSup    : boolean     read FDJSup         write FDJSup ;
    property DJSuppC  : Double      read FDJSuppC       write FDjSuppC ;
    property nbjsaison : integer    read Fnbjsaison     write Fnbjsaison;
  end;

  // Classe utilisée pour la fenêtre de diagnostic
  TResaSkisetDiagnostic = class(TPersistent)
  private
    FCentrale : String;
    FCodeAdherent : String;
    FDateResa : TDateTime;
    FNumResa : String;
    FClient : String;
  published
    property Centrale : String     read FCentrale     write FCentrale;
    property CodeAdherent : String read FCodeAdherent write FCodeAdherent;
    property DateResa : TDateTime  read FDateResa     write FDateResa;
    property NumResa : String      read FNumResa      write FNumResa;
    property Client : String       read FClient       write FClient;
  end;

  TParametrage = class(TPersistent)
  private
    FPaiement : Integer;
    FPointure : Integer;
    FTaille : Integer;
    FPoids : Integer;
    FURL : String;
    FUser : String;
    FCle : String;
  public
    procedure Assign(aSource : TPersistent);  override;

    property Paiement : integer read FPaiement  write FPaiement;
    property Pointure : integer read FPointure  write FPointure;
    property Taille : integer   read FTaille    write FTaille;
    property Poids : integer    read FPoids     write FPoids;
    property URL : String       read FURL       write FURL;
    property User : String      read FUser      write FUser;
    property Cle : String       read FCle       write FCle;
  end;

// Gesytion de creation de l'URL
function GetURLSkiset(const sBaseURL : String; const Action : TActionWebService; Param1 : string = ''; Param2 : string = ''; DateFrom : TDateTime = 0; DateTo : TDateTime = 0) : String;
// Gestion appel au web service
function AppelWebServiceSkiset(const URL, User, Cle : String) : string;
function PatchWebServiceSkiset(const URL, User, Cle, Msg, LogBaseDir : string) : string;
// Fonction Utils !
function WebServiceGetResaFromReferenceStation(const BaseURL, User, Cle, Reference : string; const WebMagId : integer) : TReservations;
function WebServiceGetDetailOffre(const BaseURL, User, Cle : string; OffreId : integer) : TOffre;
function WebServiceAffectMagasinReservation(const BaseURL, User, Cle, IdReservation : string; const WebMagId : integer; const LogBaseDir : string) : boolean;
function WebServiceMarqueReservationLignePrise(const BaseURL, User, Cle, IdReservation : string; const IDLigne : integer; const Served : boolean; const LogBaseDir : string) : boolean;
// gestion de l'existance en base
function IsReservationDejaIntegree(const Connexion : TMyConnection; const iIdCentrale : Integer; const sNomCentrale, sIdReservation, sRefReservation: String; var InfosResa : TInfosReservation) : Boolean;
// Gestion du paramétrage GINKOIA
function MagHasWebServiceSkiset(const Connexion : TMyConnection; const Module : string; const MagIs : integer; out MtyId, CltId : integer) : boolean;
function GetParamWebService(const Connexion : TMyConnection; const Centrale: Integer; out URL, User, Cle : String) : Boolean;
function GetParamMagasin(const Connexion : TMyConnection; const MtyId, MagId : integer; out WebMagId : integer) : boolean;

implementation

uses
  DateUtils,
  StrUtils,
  IdURI,
  IdSSLOpenSSL,
  IdHTTP,
  uJSON;

type
  TIdHTTPAccess = class(TIdHTTP);

{ Fonctions de base d'acces au web service }

function GetURLSkiset(const sBaseURL : String; const Action : TActionWebService; Param1 : string; Param2 : string; DateFrom : TDateTime; DateTo : TDateTime) : string;

  function GetParamDate(DateFrom : TDateTime; DateTo : TDateTime) : string;
  begin
    // Gestion de paramètres
    Result := '';
    if (DateFrom <> 0) then
    begin
      if Result = '' then
        Result := '?date_from=' + FormatDateTime('yyyy-mm-dd', DateFrom)
      else
        Result := Result + '&date_from=' + FormatDateTime('yyyy-mm-dd', DateFrom);
    end;
    if (DateTo <> 0) then
    begin
      if Result = '' then
        Result := '?date_to=' + FormatDateTime('yyyy-mm-dd', DateTo)
      else
        Result := Result + '&date_to=' + FormatDateTime('yyyy-mm-dd', DateTo);
    end;
  end;

begin
  // Initialisation
  Result := '';

  // Construction de l'URL en fonction de l'action demandée
  case Action of
    awsListeOffres :
      Result := sBaseURL + 'offerpacks';

    awsDetailOffre :
      Result := sBaseURL + 'offerpacks/' + Param1;

    awsDetailMagasin :
      Result := sBaseURL + 'shops/' + Param1;

    awsListeResaMagasin :
        Result := sBaseURL + 'shops/' + Param1 + '/bookings' + GetParamDate(DateFrom, DateTo);

    awsListeResaStation :
        Result := sBaseURL + 'resorts/' + Param1 + '/bookings' + GetParamDate(DateFrom, DateTo);

    awsListePacksResa :
      Result := sBaseURL + 'bookings/' + Param1 + '/packs';

    awsPatchSetMagasin :
      Result := sBaseURL + 'bookings/' + Param1;

    awsPatchSetServi :
      Result := sBaseURL + 'bookings/' + Param1 + '/packs/' + Param2;
  end;
end;

function AppelWebServiceSkiset(const URL, User, Cle : string) : string;
var
  IdHTTP: TIdHTTPAccess;
  IdIoHandler : TIdSSLIOHandlerSocketOpenSSL;
  vResponse : TStringStream;
  sJsonResult : String;
begin
  // Initialisation
  Result := '';
  idHTTP := nil;
  IdIoHandler := nil;
  vResponse := TStringStream.Create('');

  try
    // Paramétrage de l'en-tête
    IdHTTP := TIdHTTPAccess.Create(nil);
    IdHTTP.Request.ContentType := 'application/json';

    if not ((Trim(User) = '') and (Trim(Cle) = '')) then
    begin
      IdHTTP.Request.CustomHeaders.FoldLines := False;
      IdHTTP.Request.CustomHeaders.AddValue(CAPIUSER, User);
      IdHTTP.Request.CustomHeaders.AddValue(CAPIKEY, Cle);
    end;

    if UpperCase(Copy(URL, 1, 5)) = 'HTTPS' then
    begin
      IdIoHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
      IdIoHandler.Destination := URL;
      IdIoHandler.SSLOptions.Method := sslvTLSv1_2;
      IdHTTP.IOHandler := IdIoHandler;
    end;

    // Appel au web service
    IdHTTP.Get(TIdURI.URLEncode(URL), vResponse);
    if ((IdHTTP.ResponseCode >= 200) and (IdHTTP.ResponseCode < 300)) then
    begin
      vResponse.Seek(0, soFromBeginning);
      // On supprime le début et la fin de la réponse json pour ne récupérer que l'objet utile
      sJsonResult := Copy(vResponse.DataString, 14, Length(vResponse.DataString) -14); // Length('{"_embedded":') = 14
      Result := TIdURI.URLDecode(sJsonResult);
    end;
  finally
    FreeAndNil(vResponse);
    FreeAndNil(IdIoHandler);
    FreeAndNil(IdHTTP);
  end;
end;

function PatchWebServiceSkiset(const URL, User, Cle, Msg, LogBaseDir : string) : string;

  procedure SaveToFile(const FileName : string; Content : array of string);
  var
    Fichier : TextFile;
    i : integer;
  begin
    AssignFile(Fichier, FileName);
    rewrite(Fichier);
    try
      for i := 0 to Length(Content) -1 do
        if not (Trim(Content[i]) = '') then
          Writeln(Fichier, Content[i], '');
    finally
      CloseFile(Fichier);
    end;
  end;

var
  IdHTTP: TIdHTTP;
  IdIoHandler : TIdSSLIOHandlerSocketOpenSSL;
  vAsk, vRep : TStringStream;
  sJsonResult : String;
  LogDir, LogAsk, LogRep : string;
  DateLog : TDateTime;
begin
  // Initialisation
  Result := '';
  idHTTP := nil;
  IdIoHandler := nil;
  vAsk := TStringStream.Create(Msg);
  vAsk.Seek(0, soFromBeginning);
  vRep := TStringStream.Create('');

  // init du log
  DateLog := Now();
  LogDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(LogBaseDir) + FormatDateTime('yyyy' + PathDelim + 'mm' + PathDelim + 'dd', DateLog));
  LogAsk := LogDir + FormatDateTime('hh-nn-ss-zzz', DateLog) + '_Ask.json.log';
  LogRep := LogDir + FormatDateTime('hh-nn-ss-zzz', DateLog) + '_Rep.json.log';
  ForceDirectories(LogDir);

  try
    // Paramétrage de l'en-tête
    IdHTTP := TIdHTTP.Create(nil);
    IdHTTP.Request.ContentType := 'application/json';

    if not ((Trim(User) = '') and (Trim(Cle) = '')) then
    begin
      IdHTTP.Request.CustomHeaders.FoldLines := False;
      IdHTTP.Request.CustomHeaders.AddValue(CAPIUSER, User);
      IdHTTP.Request.CustomHeaders.AddValue(CAPIKEY, Cle);
    end;

    if UpperCase(Copy(URL, 1, 5)) = 'HTTPS' then
    begin
      IdIoHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
      IdIoHandler.Destination := URL;
      IdIoHandler.SSLOptions.Method := sslvTLSv1_2;
      IdHTTP.IOHandler := IdIoHandler;
    end;

    // log de l'envoi
    SaveToFile(LogAsk, [URL, IdHTTP.Request.RawHeaders.Text, vAsk.DataString]);

    // Appel au web service
    TIdHTTPAccess(IdHTTP).DoRequest('PATCH', TIdURI.URLEncode(URL), vAsk, vRep, []);
    if ((IdHTTP.ResponseCode >= 200) and (IdHTTP.ResponseCode < 300)) then
    begin
      vRep.Seek(0, soFromBeginning);
      SaveToFile(LogRep, [URL, IdHTTP.ResponseText, vRep.DataString]);
      // On supprime le début et la fin de la réponse json pour ne récupérer que l'objet utile
      sJsonResult := Copy(vRep.DataString, 14, Length(vRep.DataString) -14); // Length('{"_embedded":') = 14
      Result := TIdURI.URLDecode(sJsonResult);
    end;
  finally
    FreeAndNil(vAsk);
    FreeAndNil(vRep);
    FreeAndNil(IdIoHandler);
    FreeAndNil(IdHTTP);
  end;
end;

{ Fonctionnel d'appel du webservice }

function WebServiceGetResaFromReferenceStation(const BaseURL, User, Cle, Reference : string; const WebMagId : integer) : TReservations;
var
  iJsonPos, i : integer;
  URLDetailMagasin : string;
  URLReservationStation : string;
  URLDetailReservation : string;
  JsonStrDetailMagasin : string;
  JsonStrReservationStation : string;
  JsonStrDetailReservation : string;
  JsonMagasin : TJsonMagasin;
  ListeJsonReservation : TJsonReservations;
  ListeJsonLignes : TJsonLignesReservation;
  JsonReservation : TJsonReservation;
  vResa : TReservation;
  iCptResa : Integer;
begin
  SetLength(Result, 0);
  iCptResa := 0;

  // Recupération des details du magasin
  URLDetailMagasin := GetURLSkiset(BaseURL, awsDetailMagasin, IntToStr(WebMagId));
  JsonStrDetailMagasin := AppelWebServiceSkiset(URLDetailMagasin, User, Cle);
  if Length(JsonStrDetailMagasin) > 0 then
  begin
    try
      // transfert dans la liste d'objet
      JsonMagasin := TJsonMagasin.Create();
      if TJSON.JSONToObject(JsonStrDetailMagasin, JsonMagasin) then
      begin
        // Recupérationde la liste des reservation de la station de ce magasin pour la periode de 3 jours autour d'aujourd'hui !
        URLReservationStation := GetURLSkiset(BaseURL, awsListeResaStation, IntToStr(JsonMagasin.resort_id), '', IncDay(Date(), -1), IncDay(Date(), +1));

//        {$ifdef debug}
//          // flemme de changer la date de mon poste et de toute façons il y a un autre param a ajouter pour teste
//          URLReservationStation := GetURLSkiset(BaseURL, awsListeResaStation, IntToStr(JsonMagasin.resort_id), '', EncodeDate(2022, 02, 28), EncodeDate(2022, 03, 5)) + '&season_id=18';
//        {$endif}

        JsonStrReservationStation := AppelWebServiceSkiset(URLReservationStation, User, Cle);
        if length(JsonStrReservationStation) > 0 then
        begin
          try
            // transfert dans la liste d'objet
            iJsonPos := 1;
            TJSON.JSONToDynArray(JsonStrReservationStation, iJsonPos, Pointer(ListeJsonReservation), System.TypeInfo(TJsonReservations));
            for JsonReservation in ListeJsonReservation do
            begin
              // si une reservation correspond a la reference demander
              if JsonReservation.reference = Reference then
              begin
                // creation de l'objet utilisable
                vResa := TTranspoJson.CopyJSONToReservation(JsonReservation);
                if Assigned(vResa) then
                begin
                  if (vResa.Status = CSTATUS_CANCELLED) or (vResa.DateAnnulation <> 0) then
                  begin
                    // Si résa annulée, on ne la compte pas et on passe à la suivante
                    Continue;
                  end
                  else if ((vResa.MagId <> 0) and (vResa.MagId <> WebMagId)) then
                  begin
                    //Si résa affectée à un autre magasin, on ne la compte pas et on passe à la suivante
                    Continue;
                  end
                  else
                  begin
                    Inc(iCptResa);
                    SetLength(Result, iCptResa);

                    // Sauvegarde de l'entête de réservation
                    Result[iCptResa - 1] := vResa;

                    // Recupération des lignes de la resa
                    URLDetailReservation := GetURLSkiset(BaseURL, awsListePacksResa, JsonReservation.id);
                    JsonStrDetailReservation := AppelWebServiceSkiset(URLDetailReservation, User, Cle);
                    if Length(JsonStrDetailReservation) > 0 then
                    begin
                      try
                        iJsonPos := 1;
                        TJSON.JSONToDynArray(JsonStrDetailReservation, iJsonPos, Pointer(ListeJsonLignes), System.TypeInfo(TJsonLignesReservation));
                        Result[iCptResa - 1].ReservationLignes := TTranspoJson.CopyJSONToLignesReservation(ListeJsonLignes);
                      finally
                        for i := 0 to Length(ListeJsonLignes) -1 do
                        begin
                          FreeAndNil(ListeJsonLignes[i]);
                        end;
                        SetLength(ListeJsonLignes, 0);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          finally
            for i := 0 to Length(ListeJsonReservation) -1 do
            begin
              FreeAndNil(ListeJsonReservation[i]);
            end;
            SetLength(ListeJsonReservation, 0);
          end;
        end;
      end;
    finally
      FreeAndNil(JsonMagasin);
    end;
  end;
end;

function WebServiceGetDetailOffre(const BaseURL, User, Cle : string; OffreId : integer) : TOffre;
var
  URLDetailOffre : string;
  JsonStrOffre : string;
  JsonOffre : TJsonOffre;
begin
  Result := nil;
  URLDetailOffre := GetURLSkiset(BaseURL, awsDetailOffre, IntToStr(OffreId));
  JsonStrOffre := AppelWebServiceSkiset(URLDetailOffre, User, Cle);
  if Length(JsonStrOffre) > 0 then
  begin
    try
      JsonOffre := TJsonOffre.Create();
      if TJSON.JSONToObject(JsonStrOffre, JsonOffre) then
        Result := TTranspoJson.CopyJSONToOffre(JsonOffre);
    finally
      FreeAndNil(JsonOffre);
    end;
  end;
end;

function WebServiceAffectMagasinReservation(const BaseURL, User, Cle, IdReservation : string; const WebMagId : integer; const LogBaseDir : string) : boolean;
var
  URLAffectBookingShop : string;
  JsonStrReservation : string;
  JsonReservation : TJsonReservation;
begin
  Result := false;
  URLAffectBookingShop := GetURLSkiset(BaseURL, awsPatchSetMagasin, IdReservation);
  JsonStrReservation := PatchWebServiceSkiset(URLAffectBookingShop, User, Cle, Format(CAFFECTBOOKINGSHOP, [IfThen(WebMagId = 0, 'null', IntToStr(WebMagId))]), LogBaseDir);
  if Length(JsonStrReservation) > 0 then
  begin
    try
      JsonReservation := TJsonReservation.Create();
      if TJSON.JSONToObject(JsonStrReservation, JsonReservation) then
        Result := JsonReservation.shop_id = WebMagId
      else
        raise Exception.Create('Pas de reservation trouvée');
    finally
      FreeAndNil(JsonReservation);
    end;
  end;
end;

function WebServiceMarqueReservationLignePrise(const BaseURL, User, Cle, IdReservation : string; const IDLigne : integer; const Served : boolean; const LogBaseDir : string) : boolean;
var
  URLServeBookingPack : string;
  JsonStrLigne : string;
  JsonLigne : TJsonLigneReservation;
begin
  Result := false;
  URLServeBookingPack := GetURLSkiset(BaseURL, awsPatchSetServi, IdReservation, IntToStr(IDLigne));
  JsonStrLigne := PatchWebServiceSkiset(URLServeBookingPack, User, Cle, Format(CSERVEBOOKINGPACK, [LowerCase(BoolToStr(Served, true))]), LogBaseDir);
  if Length(JsonStrLigne) > 0 then
  begin
    try
      JsonLigne := TJsonLigneReservation.Create();
      if TJSON.JSONToObject(JsonStrLigne, JsonLigne) then
        Result := JsonLigne.served = Served
      else
        raise Exception.Create('Pas de ligne trouvée');
    finally
      FreeAndNil(JsonLigne);
    end;
  end;
end;

{ Gestion d'existance }

function IsReservationDejaIntegree(const Connexion : TMyConnection; const iIdCentrale : Integer; const sNomCentrale, sIdReservation, sRefReservation: String; var InfosResa : TInfosReservation) : Boolean;
var
  Query : TMyQuery;
begin
  Result := false;
  InfosResa := nil;

  try
    Query := GetNewQuery(Connexion);
    Query.SQL.Add('select rvs_id, rvs_cltid, rvs_paymenttime, rvs_bl, rvs_date, clt_adrid ');
    Query.SQL.Add('from locreservation join k on k_id = rvs_id and k_enabled = 1 ');
    Query.SQL.Add('left join genimport on imp_ginkoia = rvs_id ');
    Query.SQL.Add('join cltclient on clt_id = rvs_cltid ');
    Query.SQL.Add('where rvs_mtyid = :IDCENTRALE ');
    Query.SQL.Add(' and ((rvs_idwebstring = :IDWEB) ');
    Query.SQL.Add(' or (imp_ktbid = -11111512 and imp_num = 5 and imp_refstr = :IDWEB)) ');
    Query.SQL.Add('order by rvs_date desc ');

    Query.ParamByName('IDCENTRALE').AsInteger := iIdCentrale;
    Query.ParamByName('IDWEB').AsString := sIdReservation;
    try
      Query.Open();

      // Attention : Ne pas utiliser Query.RecordCount
      // Le RecordCount relance une requête et ne renvoi pas le nombre réel du résultat de la requête
      // Utiliser Query.IsEmpty
      if not Query.IsEmpty then
      begin
        Result := True;
      end
      else
      begin
        // Si on est sur le nouveau module SKIMIUM API,
        // on vérifie que la résa n'a pas déjà été intégrée avec l'ancien module RESERVATION SKIMIUM
        if (Uppercase(sNomCentrale) = 'RESERVATION SKIMIUM API') then
        begin
          Query.SQL.Clear;
          Query.SQL.Add('select rvs_id, rvs_cltid, rvs_paymenttime, rvs_bl, clt_adrid');
          Query.SQL.Add('from LOCRESERVATION');
          Query.SQL.Add('join K on k_id = rvs_id and k_enabled = 1');
          Query.SQL.Add('join cltclient on clt_id = rvs_cltid ');
          Query.SQL.Add('join gentypemail on mty_id = rvs_mtyid');
          Query.SQL.Add('where rvs_numerowebstring = :REF and mty_nom = :CENTRALE');

          Query.ParamByName('REF').AsString := sRefReservation;
          Query.ParamByName('CENTRALE').AsString := 'RESERVATION SKIMIUM';

          Query.Open;

          if not Query.Eof then
          begin
            Result := True;
          end;
        end;
      end;

      if Result = True then
      begin
        InfosResa := TInfosReservation.Create();
        InfosResa.IdResa := Query.FieldByName('rvs_id').AsInteger;
        InfosResa.IdClient := Query.FieldByName('rvs_cltid').AsInteger;
        InfosResa.DateResa := Query.FieldByName('rvs_paymenttime').AsDateTime;
        InfosResa.TransfertBL := Query.FieldByName('rvs_bl').AsInteger;
        InfosResa.CltAdrId := Query.FieldByName('clt_adrid').AsInteger;
      end;
    finally
      Query.Close();
    end;
  finally
    FreeAndNil(Query);
  end;
end;

{ Recuperation dans le base ginkoia }

function MagHasWebServiceSkiset(const Connexion : TMyConnection; const Module : string; const MagIs : integer; out MtyId, CltId : integer) : boolean;
var
  Query : TMyQuery;
begin
  Result := false;
  Query := nil;
  MtyId := 0;
  CltId := 0;
  try
    Query := GetNewQuery(Connexion);
    Query.SQL.Add('select mty_id, mty_cltidpro');
    Query.SQL.Add('from gentypemail join k on k_id = mty_id and k_enabled = 1');
    Query.SQL.Add('join uilgrpginkoia join k on k_id = ugg_id and k_enabled = 1 on upper(mty_nom) = upper(ugg_nom)');
    Query.SQL.Add('join uilgrpginkoiamag join k on k_id = ugm_id and k_enabled = 1 on ugm_uggid = ugg_id');
    Query.SQL.Add('where mty_id != 0 and upper(ugg_nom) = :Module and ugm_magid = :MagId ');
    Query.ParambyName('Module').AsString := Module;
    Query.ParambyName('MagId').AsInteger := MagIs;
    try
      Query.Open();
      if not Query.Eof then
      begin
        Result := true;
        MtyId := Query.FieldByName('mty_id').AsInteger;
        CltId := Query.FieldByName('mty_cltidpro').AsInteger;
      end;
    finally
      Query.Close();
    end;
  finally
    FreeAndNil(Query);
  end;
end;

function GetParamWebService(const Connexion : TMyConnection; const Centrale: Integer; out URL, User, Cle : String) : Boolean;
var
  Query : TMyQuery;
  bCentraleOk: Boolean;
begin
  Result := false;
  Query := nil;
  bCentraleOk := True;
  URL := '';
  User := '';
  Cle := '';
  try
    Query := GetNewQuery(Connexion);
    Query.SQL.Add('select prm_code, prm_string');
    Query.SQL.Add('from genparam join k on k_id = prm_id and k_enabled = 1');
    Query.SQL.Add('where prm_type = 27 and ');

    case Centrale of
      0: // Skiset
        Query.SQL.Add('prm_code in (1, 2, 7);');
      1: // Netski
        Query.SQL.Add('prm_code in (11, 12, 17);');
      2: // GoSport
        Query.SQL.Add('prm_code in (21, 22, 27);');
      3: // Skimium  API
        Query.SQL.Add('prm_code in (31, 32, 37);');
    else
      bCentraleOk := False;
    end;

    if bCentraleOk then
    begin
      try
        Query.Open();
        if not Query.Eof then
        begin
          Result := true;
          while not Query.Eof do
          begin
            case Query.FieldByName('prm_code').AsInteger of
              1, 11, 21, 31 : URL := Query.FieldByName('prm_string').AsString;
              2, 12, 22, 32 : Cle := Query.FieldByName('prm_string').AsString;
              7, 17, 27, 37 : User := Query.FieldByName('prm_string').AsString;
            end;
            Query.Next();
          end;
        end;
      finally
        Query.Close();
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

function GetParamMagasin(const Connexion : TMyConnection; const MtyId, MagId : integer; out WebMagId : integer) : boolean;
var
  Query : TMyQuery;
begin
  Result := false;
  Query := nil;
  WebMagId := 0;
  try
    Query := GetNewQuery(Connexion);
    Query.SQL.Add('select locmailidentmag.*');
    Query.SQL.Add('from locmailidentmag join k on k_id = idm_id and k_enabled = 1');
    Query.SQL.Add('where idm_mtyid = :MtyId and idm_magid = :MagId');
    Query.ParambyName('MtyId').AsInteger := MtyId;
    Query.ParambyName('MagId').AsInteger := MagId;
    try
      Query.Open();
      if not Query.Eof then     
      begin
        if (Trim(Query.FieldByName('idm_presta').AsString) <> '') and (StrToIntDef(Query.FieldByName('idm_presta').AsString, -1) <> -1) then
        begin
          Result := true;
          WebMagId := Query.FieldByName('idm_presta').AsInteger;
        end;
      end;
    finally
      Query.Close();
    end;
  finally
    FreeAndNil(Query);
  end;
end;

{ TListeMagasins }

function TListeMagasins.Add(aObject: TMagasin): Integer;
begin
  Result := inherited Add(aObject);
end;

function TListeMagasins.GetItem(iIndex: Integer): TMagasin;
begin
  Result := TMagasin(inherited GetItem(iIndex));
end;

procedure TListeMagasins.Insert(iIndex: Integer; aObject: TObject);
begin
  inherited Insert(iIndex, AObject);
end;

procedure TListeMagasins.SetItem(iIndex: Integer; const Value: TMagasin);
begin
  inherited setItem(iIndex, Value);
end;

{ TReservation }

constructor TReservation.Create;
begin
  SetLength(FReservationLignes, 0);
end;

destructor TReservation.Destroy;
var
  i : Integer;
begin
  for i := 0 to Pred(Length(ReservationLignes)) do
  begin
    ReservationLignes[i].Free;
  end;
  inherited;
end;

{ TTranspoJson }

class function TTranspoJson.CopyJSONToOffre(aJsonOffre : TJsonOffre): TOffre;
begin
  Result := TOffre.Create;

  Result.Id := aJsonOffre.id;
  Result.Centrale := aJsonOffre.trademark;
  // Le nom de l'offre = offre + groupe + composition
  Result.OffreNom := aJsonOffre.offer + '|' + aJsonOffre.group + '|' + aJsonOffre.composition + '|' + aJsonOffre.pack;
end;

class function TTranspoJson.CopyJSONToOffres(aJsonOffres : TJsonOffres): TOffres;
var
  i : Integer;
begin
  SetLength(Result, Length(aJsonOffres));

  for i := 0 to Pred(Length(aJsonOffres)) do
  begin
    Result[i] := CopyJSONToOffre(aJsonOffres[i]);
    FreeAndNil(aJsonOffres[i]);
  end;
end;

class function TTranspoJson.CopyJSONToReservation(aJsonReservation : TJsonReservation) : TReservation;
begin
  Result := TReservation.Create;

  Result.Id := aJsonReservation.id;

  if aJsonReservation.reference = '' then
    Result.Reference := aJsonReservation.id
  else
    Result.Reference := aJsonReservation.reference;

  Result.Centrale := aJsonReservation.trademark;

  if (aJsonReservation.customer_id <> '') then
    Result.ClientID := aJsonReservation.customer_id;
  if (aJsonReservation.customer_email <> '') then
    Result.ClientEmail := aJsonReservation.customer_email;
  if (aJsonReservation.customer_phone <> '') then
    Result.ClientPhone := aJsonReservation.customer_phone;

  if (aJsonReservation.firstname = '') and (aJsonReservation.lastname = '') then
    Result.ClientNom := CCLIENTNOM + Result.Reference
  else
    Result.ClientNom := aJsonReservation.lastname;
  Result.ClientPrenom := aJsonReservation.firstname;

  Result.Status := aJsonReservation.bookingstatus;
  Result.DateAnnulation := aJsonReservation.cancellation_date;
  Result.MagId := aJsonReservation.shop_id;
  Result.DateDebut := aJsonReservation.first_day;
  Result.DateFin := aJsonReservation.last_day;
  Result.NbJours := aJsonReservation.duration;
  Result.DateCreation := aJsonReservation.created_on;
  Result.DateMAJ := aJsonReservation.updated_on;

  Result.Organisme := aJsonReservation.tourop_name;
  Result.NbPacks := aJsonReservation.nbpacks;
end;

class function TTranspoJson.CopyJSONToReservations(aJsonReservations : TJsonReservations): TReservations;
var
  i : Integer;
begin
  SetLength(Result, Length(aJsonReservations));

  for i := 0 to Pred(Length(aJsonReservations)) do
  begin
    Result[i] := CopyJSONToReservation(aJsonReservations[i]);
    aJsonReservations[i].Free;
  end;
end;

class function TTranspoJson.CopyJSONToLignesReservation(aJsonLignesReservation: TJsonLignesReservation): TLignesReservation;
var
  i : Integer;
begin
  SetLength(Result, Length(aJsonLignesReservation));

  for i := 0 to Pred(Length(aJsonLignesReservation)) do
  begin
    Result[i] := TLigneReservation.Create;

    Result[i].Id := aJsonLignesReservation[i].id;
    Result[i].Reference := aJsonLignesReservation[i].reference;
    Result[i].PackId := aJsonLignesReservation[i].pack_id;
    Result[i].AvecCasque := aJsonLignesReservation[i].with_helmet;
    Result[i].Assurance := aJsonLignesReservation[i].insurance;
    Result[i].DateDebut := aJsonLignesReservation[i].first_day;
    Result[i].NbJours := aJsonLignesReservation[i].duration;
    Result[i].Client := aJsonLignesReservation[i].firstname;
    Result[i].DateMAJ := aJsonLignesReservation[i].updated_on;
    Result[i].Pointure := aJsonLignesReservation[i].shoesize;
    Result[i].Taille := aJsonLignesReservation[i].height;
    Result[i].Poids := aJsonLignesReservation[i].weight;
    Result[i].TourTete := aJsonLignesReservation[i].headsize;
    Result[i].PositionSnow := aJsonLignesReservation[i].snowposition;
    Result[i].NiveauSki := aJsonLignesReservation[i].skier_level;
    Result[i].MaterielServi := aJsonLignesReservation[i].served;
    if Assigned(aJsonLignesReservation[i].amount_billing) then
      Result[i].AmountTTC := aJsonLignesReservation[i].amount_billing.amount_ttc
    else
      Result[i].AmountTTC := 0;

    FreeAndNil(aJsonLignesReservation[i]);
  end;
end;

{ TClient }

procedure TClient.Assign(aSource: TPersistent);
begin
  if Assigned(aSource) and aSource.InheritsFrom(TClient) then
  begin
    FID := tClient(aSource).FID;
    FNom := tClient(aSource).FNom;
    FPrenom := tClient(aSource).FPrenom;
    FAdresseId := tClient(aSource).FAdresseId;
    FMagId := tClient(aSource).FMagId;
    FCivilite := tClient(aSource).FCivilite;
    FDebutSejourVO := tClient(aSource).FDebutSejourVO;
    FDureeVO := tClient(aSource).FDureeVO;
    FDureeVODate := tClient(aSource).FDureeVODate;
  end
  else
    inherited;
end;

{ TParametrage }

procedure TParametrage.Assign(aSource: TPersistent);
begin
  if Assigned(aSource) and aSource.InheritsFrom(TParametrage) then
  begin
    FPaiement := TParametrage(aSource).FPaiement;
    FPointure := TParametrage(aSource).FPointure;
    FTaille := TParametrage(aSource).FTaille;
    FPoids := TParametrage(aSource).FPoids;
    FURL := TParametrage(aSource).FURL;
    FUser := TParametrage(aSource).FUser;
    FCle := TParametrage(aSource).FCle;
  end
  else
    inherited;
end;

{ TJsonOffre }

constructor TJsonOffre.Create;
begin
  F_links := TLinkOffre.Create;
end;

destructor TJsonOffre.Destroy;
begin
  F_links.Destroy;
  inherited;
end;

{ TLinkOffre }

constructor TLinkOffre.Create;
begin
  Fself := THref.Create;
end;

destructor TLinkOffre.Destroy;
begin
  FreeAndNil(Fself);
  inherited;
end;

{ TLinkLigneResa }

constructor TLinkLigneResa.Create;
begin
  Fself := THref.Create;
  Fbooking := THref.Create;
  Fpack := THref.Create;
end;

destructor TLinkLigneResa.Destroy;
begin
  Fself.Destroy;
  if Assigned(Fbooking) then
  Fbooking.Destroy;
  if Assigned(Fpack) then
  Fpack.Destroy;
  inherited;
end;

{ TJsonLigneReservation }

constructor TJsonLigneReservation.Create;
begin
  F_links := TLinkLigneResa.Create;
  Famount_billing := TJsonAmountBilling.Create;
end;

destructor TJsonLigneReservation.Destroy;
begin
  F_links.Destroy;
  Famount_billing.Destroy;
  inherited;
end;

{ TJsonReservation }

constructor TJsonReservation.Create;
begin
  Fcustomer_id := '';
  Fcustomer_email := '';
  Fcustomer_phone := '';

  F_links := TLinkResa.Create;
end;

destructor TJsonReservation.Destroy;
begin
  F_links.Destroy;
  inherited;
end;

{ TLinkResa }

constructor TLinkResa.Create;
begin
  Fself := THref.Create;
  Fpacks := THref.Create;
  Ftourops := THref.Create;
end;

destructor TLinkResa.Destroy;
begin
  Fself.Destroy;
  if Assigned(Fpacks) then
    Fpacks.Destroy;
  if Assigned(Ftourops) then
    Ftourops.Destroy;
  inherited;
end;

{ THref }

constructor THref.Create;
begin
  Fhref := '';
end;

destructor THref.Destroy;
begin
  Fhref := '';
  inherited;
end;

end.

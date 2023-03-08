unit CardDAV;

interface

{.$DEFINE DEMO}

uses
  Classes,
  Contnrs,
  IdHTTP,
  IdSSLOpenSSL,
  IdSSL,
  IdSocks,
  XMLDoc,
  IdWebDAV,
  SyncObjs,
  IdComponent,
  IdLogFile;

// Definition for compiling demo version of component

{$IFDEF VER210}
  {$DEFINE 2010ANDLATER}
{$ENDIF}

{$IFDEF VER220}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
{$ENDIF}

{$IFDEF VER230}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
{$ENDIF}

{$IFDEF VER240}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
{$ENDIF}

{$IFDEF VER250}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
{$ENDIF}

{$IFDEF VER260}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
  {$DEFINE XE5ANDLATER}
{$ENDIF}

{$IFDEF VER270}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
  {$DEFINE XE5ANDLATER}
  {$DEFINE XE6ANDLATER}
{$ENDIF}

{$IFDEF VER280}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
  {$DEFINE XE5ANDLATER}
  {$DEFINE XE6ANDLATER}
  {$DEFINE XE7ANDLATER}
{$ENDIF}

type
  // Some fixing workaround on Indy WebDAV class
  TIdWebDAV = class(IdWebDAV.TIdWebDAV)
  protected
    procedure DoRequest(const AMethod: TIdHTTPMethod; AURL: string; ASource, AResponseContent: TStream;
      AIgnoreReplies: array of SmallInt); override;
  end;

  TCardDavProxyType = (ptNone, ptHTTP, ptSocks4, ptSocks5);

  TCDAddressbook = class;
  TCDContact = class;

  TCardDAVStoreProgressEvent = procedure(Sender: TCDAddressbook; Current, Total: Cardinal; var Cancel: Boolean) of object;
  TCardDAVStoreErrorEvent = procedure(Sender: TCDContact; ErrorMessage: String) of object;

  TVCStringList = class(TStringList)
  protected
    function Get(Index: Integer): string; override;
  end;

  // vCard field wrapping class
  TVCardField = class
  private
    FAttributes: TStringList;
    FValues: TStringList;
    FFieldName: String;
    FQuotedPrintable: Boolean;
    FFieldPrefix: String;
    function GetvText: String;
    procedure SetvText(const avText: String);
  public
    // Constructor (avText - field string from vCard code, should be unfolded before)
    constructor Create(const avText: String);
    // Destructor
    destructor Destroy; override;
    // Field name
    property FieldName: String read FFieldName write FFieldName;
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // Field attributes (name-value pairs)
    property Attributes: TStringList read FAttributes;
    // Field value(s)
    property Values: TStringList read FValues;
    // unfolded (long) vCard string of field
    property vText: String read GetvText write SetvText;
    // Indicate that the value was QP encoded, set if it should be encoded
    property QuotedPrintable: Boolean read FQuotedPrintable write FQuotedPrintable;
  end;

  // vCard embedded object wrapper class (photo, logo, sound, key)
  TVCardEmbeddedObject = class
  private
    function GetDataStream: TMemoryStream;
  protected
    FObjectType: String;
    FObjectURL: String;
    FEncoding: String;
    FDataStream: TMemoryStream;
  public
    // Constructor
    constructor Create;
    // Destructor
    destructor Destroy; override;
    // The type of object (usually MIME)
    property ObjectType: String read FObjectType write FObjectType;
    // URL where the object is located if it is NOT in this card itself
    property ObjectURL: String read FObjectURL write FObjectURL;
    // Encoding of object field (usually b or base64 for binary objects)
    property Encoding: String read FEncoding write FEncoding;
    // The data of the object if it is in the VCard (decoded)
    property DataStream: TMemoryStream read GetDataStream;
  end;

  // vCard postal address types
  TVCardAddressAttribute = (tatHome, tatDomestic, tatInternational, tatPostal, tatParcel, tatWork, tatPreferred);
  TVCardAddressAttributes = set of TVCardAddressAttribute;

  // vCard postal address
  TVCardAddress = class
  private
    FAddressAttributes: TVCardAddressAttributes;
    FPOBox: String;
    FExtendedAddress: String;
    FStreetAddress: String;
    FCity: String;
    FRegion: String;
    FPostalCode: String;
    FCountry: String;
    FFieldPrefix: String;
  public
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // Types of address such as Home or Work, postal, parcel, etc.
    property AddressAttributes: TVCardAddressAttributes read FAddressAttributes write FAddressAttributes;
    // The P.O. Box
    property POBox: String read FPOBox write FPOBox;
    // This could be something such as an Office identifier for a building or an appartment number
    property ExtendedAddress: String read FExtendedAddress write FExtendedAddress;
    // The street address
    property StreetAddress: String read FStreetAddress write FStreetAddress;
    // The city name
    property City: String read FCity write FCity;
    // The region name
    property Region: String read FRegion write FRegion;
    // The postal code
    property PostalCode: String read FPostalCode write FPostalCode;
    // The country
    property Country: String read FCountry write FCountry;
  end;

  // vCard mailing label (full formatted postal address text)
  TVCardAddressLabel = class
  private
    FAddressAttributes: TVCardAddressAttributes;
    FMailingLabel: String;
    FFieldPrefix: String;
  public
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // Types of mailing label such as Home or Work, postal, parcel, etc.
    property AddressAttributes: TVCardAddressAttributes read FAddressAttributes write FAddressAttributes;
    // The mailing label text itself
    property MailingLabel: String read FMailingLabel write FMailingLabel;
  end;

  // Types of vCard phone number
  TVCardPhoneAttribute = (tpaHome, tpaVoiceMessaging, tpaWork, tpaPreferred,
    tpaVoice, tpaFax, tpaCellular, tpaVideo, tpaBBS, tpaModem, tpaCar,
    tpaISDN, tpaPCS, tpaText, tpaPager, tpaiPhone);
  TVCardPhoneAttributes = set of TVCardPhoneAttribute;

  // vCard phone number
  TVCardPhoneNumber = class
  private
    FPhoneAttributes: TVCardPhoneAttributes;
    FNumber: String;
    FFieldPrefix: String;
  public
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // Types of the phone number
    property PhoneAttributes: TVCardPhoneAttributes read FPhoneAttributes write FPhoneAttributes;
    // The phone number itself
    property Number: String read FNumber write FNumber;
  end;

  // vCard EMail address types
  TVCardEMailType = (
    ematAOL, // America On-Line
    ematAppleLink, // AppleLink
    ematATT,   // AT&T Mail
    ematCIS,   // CompuServe Information Service
    emateWorld, // eWorld
    ematInternet, // Internet SMTP
    ematIBMMail, // IBM Mail
    ematMCIMail, // Indicates MCI Mail
    ematPowerShare, // PowerShare
    ematProdigy, // Prodigy information service
    ematTelex, // Telex number
    ematX400, // X.400 service
    ematHome, // Home
    ematWork, // Work
    ematOther // Other
  );
  TVCardEMailTypes = set of TVCardEMailType;

  // vCard E-Mail address
  TVCardEMailAddress = class
  private
    FEMailTypes: TVCardEMailTypes;
    FPreferred: Boolean;
    FAddress: String;
    FFieldPrefix: String;
  public
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // E-Mail address type (default - internet)
    property EMailTypes: TVCardEMailTypes read FEMailTypes write FEMailTypes;
    // Indicate the person's prefered E-Mail address
    property Preferred: Boolean read FPreferred write FPreferred;
    // The E-Mail address itself
    property Address: String read FAddress write FAddress;
  end;

  // vCard URL address types
  TVCardURLType = (
    utWork,
    utHome,
    utInternet,
    utOther
  );

  // vCard URL address
  TVCardURL = class
  private
    FURLType: TVCardURLType;
    FPreferred: Boolean;
    FURL: String;
    FFieldPrefix: String;
  public
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // URL type (default - other)
    property URLType: TVCardURLType read FURLType write FURLType;
    // Indicate the person's prefered URL
    property Preferred: Boolean read FPreferred write FPreferred;
    // The URL itself
    property URL: String read FURL write FURL;
  end;

  // vCard IM types
  TVCardIMType = (
    imtNone,
    imtPersonal,
    imtBusiness,
    imtHome,
    imtWork,
    imtMobile
  );

  // vCard OwnCloud IM Service type
  TVCardOCIMServiseType = (
    imstNone,
    imstJabber,
    imstSIP,
    imstAIM,
    imstMSN,
    imstTwitter,
    imstGoogleTalk,
    imstFacebook,
    imstXMPP,
    imstICQ,
    imstYahoo,
    imstSkype,
    imstQQ,
    imstGaduGadu,
    imstOwnCloud
  );

  // vCard IM
  TVCardIM = class
  private
    FIMType: TVCardIMType;
    FPreferred: Boolean;
    FValue: String;
    FFieldPrefix: String;
    FProtocol: String;
    FOCIMServiceType: TVCardOCIMServiseType;
  public
    // Field name prefix (such as "Item1." without dot sign)
    property FieldPrefix: String read FFieldPrefix write FFieldPrefix;
    // IM type (default - imNone)
    property IMType: TVCardIMType read FIMType write FIMType;
    // OwnCloud IM service type (default - imstNone)
    property OCIMServiceType: TVCardOCIMServiseType read FOCIMServiceType write FOCIMServiceType;
    // Indicate the person's prefered IM
    property Preferred: Boolean read FPreferred write FPreferred;
    // The IM value itself
    property Protocol: String read FProtocol write FProtocol;
    // The IM value itself
    property Value: String read FValue write FValue;
  end;

  TCardDAVStoreThread = class;

  // vCard contact wrapping class
  TCDContact = class
  private
    FAddressbook: TCDAddressbook;
    FUID: String;
    FHRef: String;
    FLastModified: TDateTime;
    FETag: String;
    FGetOnNextMultiget: Boolean;
    FETagOnly: Boolean;
    FVCardFields: TObjectList;
    FFirstName: String;
    FLastName: String;
    FOtherNames: String;
    FPrefix: String;
    FSuffix: String;
    FFormattedName: String;
    FLastRevised: TDateTime;
    FSortString: String;
    FNickNames: String;
    FBirthDay: TDateTime;
    FNotes: String;
    FCategories: String;
    FEMailProgram: String;
    FClassification: String;
    FProductID: String;
    FVCardVersion: String;
    FDivisions: String;
    FRole: String;
    FTitle: String;
    FOrganization: String;
    FTimeZoneStr: String;
    FLatitude: String;
    FLongitude: String;
    FPhoto: TVCardEmbeddedObject;
    FKey: TVCardEmbeddedObject;
    FSound: TVCardEmbeddedObject;
    FLogo: TVCardEmbeddedObject;
    FAddresses: TObjectList;
    FAddressLabels: TObjectList;
    FPhoneNumbers: TObjectList;
    FEMailAddresses: TObjectList;
    FOtherFields: TObjectList;
    FURLs: TObjectList;
    FIMs: TObjectList;
    FToDelete: Boolean;
    FToStore: Boolean;
    FStoreThread: TCardDAVStoreThread;
    FStoreError: String;
    FLoaded: Boolean;
    FStored: Boolean;
    function GetvCard: String;
    procedure SetvCard(const Value: String);
    procedure DeleteFieldsWithName(const FieldName: String);
    procedure SetSimpleFieldValue(const FieldName, Value: String; ToDelimited: Boolean = False);
    procedure SetPhoto(const Value: TVCardEmbeddedObject);
    procedure SetKey(const Value: TVCardEmbeddedObject);
    procedure SetLogo(const Value: TVCardEmbeddedObject);
    procedure SetSound(const Value: TVCardEmbeddedObject);
    function ParseEmbeddedObject(const VCardField: TVCardField): TVCardEmbeddedObject;
    procedure SetEmbeddedObjectField(const FieldName: String; const Obj: TVCardEmbeddedObject);
    function GetAddress(Index: Integer): TVCardAddress;
    function ParseAddress(const VCardField: TVCardField): TVCardAddress;
    function GenerateAddress(const Address: TVCardAddress): TVCardField;
    function GetAddressLabel(Index: Integer): TVCardAddressLabel;
    function ParseAddressLabel(const VCardField: TVCardField): TVCardAddressLabel;
    function GenerateAddressLabel(const AddressLabel: TVCardAddressLabel): TVCardField;
    function GetPhoneNumber(Index: Integer): TVCardPhoneNumber;
    function ParsePhoneNumber(const VCardField: TVCardField): TVCardPhoneNumber;
    function GeneratePhoneNumber(const PhoneNumber: TVCardPhoneNumber): TVCardField;
    function GetEMailAddress(Index: Integer): TVCardEMailAddress;
    function ParseEMailAddress(const VCardField: TVCardField): TVCardEMailAddress;
    function GenerateEMailAddress(const EMailAddress: TVCardEMailAddress): TVCardField;
    function GetOtherField(Index: Integer): TVCardField;
    procedure SetOtherValue(Index: String; const Value: String);
    function GetOtherValue(Index: String): String;
    function FieldWithPrefix(const Prefix: String): TVCardField;
    function GetURL(Index: Integer): TVCardURL;
    function ParseURL(const VCardField: TVCardField): TVCardURL;
    function GenerateURL(const URL: TVCardURL): TVCardField;
    function GetIM(Index: Integer): TVCardIM;
    function ParseIM(const VCardField: TVCardField): TVCardIM;
    function GenerateIM(const IM: TVCardIM): TVCardField;
    function GetLastModified: TDateTime;
    function GetLastModifiedLocal: TDateTime;
  protected
    constructor Create(Addressbook: TCDAddressbook);
    function GetOtherFieldByName(const ID: String): TVCardField; virtual;
  public
    // Destructor
    destructor Destroy; override;
    // Returns first field object with given name
    function FieldWithName(const FieldName: String): TVCardField;
    // Count of postal addresses
    function AddressesCount: Integer;
    // Adding postal address to contact
    function NewAddress: TVCardAddress;
    // Delete postal address with index
    procedure DeleteAddress(Index: Integer); overload;
    // Delete postal address
    procedure DeleteAddress(Address: TVCardAddress); overload;
    // Clear all postal addresses
    procedure ClearAddresses;
    // Count of address labels
    function AddressLabelsCount: Integer;
    // Adding address label to contact
    function NewAddressLabel: TVCardAddressLabel;
    // Delete address label with index
    procedure DeleteAddressLabel(Index: Integer); overload;
    // Delete address label
    procedure DeleteAddressLabel(AddressLabel: TVCardAddressLabel); overload;
    // Clear all address labels
    procedure ClearAddressLabels;
    // Count of phone numbers
    function PhoneNumbersCount: Integer;
    // Adding phone number to contact
    function NewPhoneNumber: TVCardPhoneNumber;
    // Delete phone number with index
    procedure DeletePhoneNumber(Index: Integer); overload;
    // Delete phone number
    procedure DeletePhoneNumber(PhoneNumber: TVCardPhoneNumber); overload;
    // Clear all phone numbers
    procedure ClearPhoneNumbers;
    // Count of E-Mail Addresses
    function EMailAddressesCount: Integer;
    // Adding E-Mail Address to contact
    function NewEMailAddress: TVCardEMailAddress;
    // Delete E-Mail Address with index
    procedure DeleteEMailAddress(Index: Integer); overload;
    // Delete E-Mail Address
    procedure DeleteEMailAddress(EMailAddress: TVCardEMailAddress); overload;
    // Clear all E-Mail Addresses
    procedure ClearEMailAddresses;
    // Count of URLs
    function URLsCount: Integer;
    // Adding URL to contact
    function NewURL: TVCardURL;
    // Delete URL with index
    procedure DeleteURL(Index: Integer); overload;
    // Delete URL
    procedure DeleteURL(URL: TVCardURL); overload;
    // Clear all URLs
    procedure ClearURLs;
    // Count of IMs
    function IMsCount: Integer;
    // Adding IM to contact
    function NewIM: TVCardIM;
    // Delete IM with index
    procedure DeleteIM(Index: Integer); overload;
    // Delete IM
    procedure DeleteIM(IM: TVCardIM); overload;
    // Clear all IMs
    procedure ClearIMs;
    // Count of other fields
    function OtherFieldsCount: Integer;
    // Adding custom field to contact (vText - unfolded vCard string of field)
    function NewOtherField(const vText: String): TVCardField;
    // Delete other field with index
    procedure DeleteOtherField(Index: Integer); overload;
    // Delete other field
    procedure DeleteOtherField(OtherField: TVCardField); overload;
    // Clear all other fields
    procedure ClearOtherFields;
    // Stores contact on server
    procedure Store(Batch: Boolean = False);
    // Deletes contact on server
    procedure Delete(Batch: Boolean = False);
    // Generate unique field prefix for prefixed fields
    function NewFieldPrefix: String;
    // Resets batch storing status
    procedure ResetBatchStoring;
    // Postal address with index
    property Addresses[Index: Integer]: TVCardAddress read GetAddress;
    // Address label with index
    property AddressLabels[Index: Integer]: TVCardAddressLabel read GetAddressLabel;
    // Phone number with index
    property PhoneNumbers[Index: Integer]: TVCardPhoneNumber read GetPhoneNumber;
    // E-Mail address with index
    property EMailAddresses[Index: Integer]: TVCardEMailAddress read GetEMailAddress;
    // Other field with index
    property OtherFields[Index: Integer]: TVCardField read GetOtherField;
    // Values of other fields by name
    property OtherValues[Index: String]: String read GetOtherValue write SetOtherValue;
    // vCard code of contact
    property vCard: String read GetvCard write SetvCard;
    // Last modified time from server
    property LastModified: TDateTime read GetLastModified;
    // Last modified time in local timezone
    property LastModifiedInLocalTZ: TDateTime read GetLastModifiedLocal;
    // Reference to the contact on server
    property HRef: String read FHRef;
    // ETag of contact
    property ETag: String read FETag;
    // Indicate that contact content is not loaded
    property ETagOnly: Boolean read FETagOnly;
    // Set true to get contact itself on next MultiGet query
    property GetOnNextMultiget: Boolean read FGetOnNextMultiget write FGetOnNextMultiget;
    // The vCard specification version
    property VCardVersion: String read FVCardVersion write FVCardVersion;
    // Last version revised time
    property LastRevised: TDateTime read FLastRevised;
    // A unique indentifier for the vCard
    property UID: String read FUID write FUID;
    // The product ID of the software created this vCard
    property ProductID: String read FProductID write FProductID;
    // The access classification of contact (public, private, confidential)
    property Classification: String read FClassification write FClassification;
    // The person's birthday
    property BirthDay: TDateTime read FBirthDay write FBirthDay;
    // The E-Mail program used by the card's owner
    property EMailProgram: String read FEMailProgram write FEMailProgram;
    // A list of Categories (Groups) used for classification, comma separated
    property Categories: String read FCategories write FCategories;
    // The person's notes
    property Notes: String read FNotes write FNotes;
    // The person's first name
    property FirstName: String read FFirstName write FFirstName;
    // The person's last name
    property LastName: String read FLastName write FLastName;
    // The person's middle name and some other names such as a woman's maiden name, comma separated
    property OtherNames: String read FOtherNames write FOtherNames;
    // A prefix added to a name
    property Prefix: String read FPrefix write FPrefix;
    // A suffix added to a name
    property Suffix: String read FSuffix write FSuffix;
    // Properly formatted name
    property FormattedName: String read FFormattedName write FFormattedName;
    // The string used for sorting
    property SortString: String read FSortString write FSortString;
    // Nick names which a person may have (comma separated)
    property NickNames: String read FNickNames write FNickNames;
    // The organization name
    property Organization: String read FOrganization write FOrganization;
    // The divisions in the orginization, comma separated
    property Divisions: String read FDivisions write FDivisions;
    // The person's formal title in the business
    property Title: String read FTitle write FTitle;
    // The person's role in an organization
    property Role: String read FRole write FRole;
    // Geographical latitude the person is in
    property Latitude: String read FLatitude write  FLatitude;
    // Geographical longitude the person is in
    property Longitude: String read FLongitude write FLongitude;
    // The time zone abbreviation the person is in
    property TimeZoneStr: String read FTimeZoneStr write FTimeZoneStr;
    // The person's photo
    property Photo: TVCardEmbeddedObject read FPhoto write SetPhoto;
    // Organization's logo
    property Logo: TVCardEmbeddedObject read FLogo write SetLogo;
    // A sound associated with the contact
    property Sound: TVCardEmbeddedObject read FSound write SetSound;
    // An encryption key such as S/MIME, VeriSign, or PGP
    property Key: TVCardEmbeddedObject read FKey write SetKey;
    // URLs associated with contact
    property URLs[Index: Integer]: TVCardURL read GetURL;
    // IMs associated with contact
    property IMs[Index: Integer]: TVCardIM read GetIM;
    // True if contact marked to delete on batch store
    property ToDelete: Boolean read FToDelete;
    // True if contact marked to store on batch store
    property ToStore: Boolean read FToStore;
  end;

  // CardDAV addressbook connecting class
  TCDAddressbook = class
  private
    FHTTP: TIdWebDAV;
    FSSLIO: TIdSSLIOHandlerSocketOpenSSL;
    FBaseURL: String;
    FLogFile: TIdLogFile;
    FLogFileName: String;
    FContacts: TObjectList;
    FUsedMIMEType: String;
    FAddressbooks: TStringList;
    FCTags: TStringList;
    FOnBatchStoreProgress: TCardDAVStoreProgressEvent;
    FOnStoreError: TCardDAVStoreErrorEvent;
    FMultigetThreads: TObjectList;
    FStoreThreads: TObjectList;
    FCancelMultiget: Boolean;
    FCancelStore: Boolean;
    FProxyType: TCardDavProxyType;
    FProxyServer: String;
    FProxyPort: Word;
    FProxyUsername: String;
    FProxyPassword: String;
    FCriticalSection: TCriticalSection;
    procedure ApplyProxySettings(AHTTP: TIdHTTP; ASSLIO: TIdSSLIOHandlerSocketOpenSSL);
    procedure SetUserName(const Value: String);
    function GetUserName: String;
    procedure SetPassword(const Value: String);
    function GetPassword: String;
    procedure SetProxyServer(const Value: String);
    procedure SetProxyPort(const Value: Word);
    procedure SetLogFileName(const Value: String);
    function GetContact(Index: Integer): TCDContact;
    function GetUserPrincipal: AnsiString;
    function GetAddressbookHomeSet: AnsiString;
    function GetAddressbookDisplayName: String;
    procedure ChangeDisplayName(URL, NewDisplayName: string);
    procedure ParseMultigetResponse(const Request: string; ResponseText: string; LastModified: TDateTime; var Multiget: String);
    procedure SetProxyPassword(const Value: String);
    procedure SetProxyType(const Value: TCardDavProxyType);
    procedure SetProxyUsername(const Value: String);
  protected
    property HTTP: TIdWebDAV read FHTTP;
    property ContactsList: TObjectList read FContacts;
  public
    // Constructor
    constructor Create;
    // Destructor
    destructor Destroy; override;
    // Get iCloud addressbook URL
    procedure GetiCloudAddressbookURL;
    // Get Addressbook URLs
    function GetAddressbooks: TStringList;
    // Creates new addressbook
    procedure CreateAddressbook(const NewAddressbookName: string);
    // Renames current addressbook
    procedure RenameAddressbook(const NewAddressbookName: string);
    // Deletes current addressbook
    procedure DeleteAddressbook;
    // Load only ETags and LastModified info of contacts
    procedure LoadContactsETags;
    // Load contacts themselves marked with GetOnNextMultiGet
    procedure MultiGet; overload;
    // Load contacts themselves marked with GetOnNextMultiGet multithreaded
    procedure MultiGet(MaxThreads: Word; ItemsInThread: Word; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    // Load all contacts
    procedure LoadAllContacts;
    // Add new contact locally
    function NewContact: TCDContact;
    // Get contact with given Reference
    function ContactWithHRef(HRef: String): TCDContact;
    // Count of contacts
    function ContactCount: Integer;
    // True if base URL is an addressbook URI
    function BaseURLIsAddressbook: Boolean;
    // Multithreaded batch storing/deleting
    procedure BatchStore(MaxThreads: Integer);
    // Reset batch storing status for all contacts
    procedure ResetBatchStoring;
    // Get CTag of BaseURL addressbook (if BaseURL is an addressbook URL)
    function GetAddressbookCTag: string;
    // Stops all threads immediately
    procedure StopAllThreads;
    // Contact with index
    property Contacts[Index: Integer]: TCDContact read GetContact;
    // Addressbook URL
    property BaseURL: String read FBaseURL write FBaseURL;
    // Username
    property UserName: String read GetUserName write SetUserName;
    // Password
    property Password: String read GetPassword write SetPassword;
    // Proxy server IP or name
    property ProxyServer: String read FProxyServer write SetProxyServer;
    // Proxy port
    property ProxyPort: Word read FProxyPort write SetProxyPort;
    // Proxy type (ptNone, ptHTTP, ptSocks4, ptSocks5)
    property ProxyType: TCardDavProxyType read FProxyType write SetProxyType;
    // Proxy server username
    property ProxyUsername: String read FProxyUsername write SetProxyUsername;
    // Proxy server password
    property ProxyPassword: String read FProxyPassword write SetProxyPassword;
    // Filename for log
    property LogFileName: String read FLogFileName write SetLogFileName;
    // Gets user principal URL
    property UserPrincipalURL: AnsiString read GetUserPrincipal;
    // Gets addressbook home set URL
    property AddressbookHomeSetURL: AnsiString read GetAddressbookHomeSet;
    // List of addressbook name-value pairs Name=URL after GetAddressbooks method calling
    property Addressbooks: TStringList read FAddressbooks;
    // List of addressbooks CTags after GetAddressbooks method calling (one-to-one with Addressbooks list)
    property AddressbooksCTags: TStringList read FCTags;
    // Displayname of current addressbook
    property AddressbookDisplayName: String read GetAddressbookDisplayName;
    // Batch store progress event
    property OnBatchStoreProgress: TCardDAVStoreProgressEvent read FOnBatchStoreProgress write FOnBatchStoreProgress;
    // Batch store error event
    property OnBatchStoreError: TCardDAVStoreErrorEvent read FOnStoreError write FOnStoreError;
  end;

  TCardDAVStoreThread = class(TThread)
  private
    FItem: TCDContact;
    FHTTP: TIdWebDAV;
    FSSLIO: TIdSSLIOHandlerSocketOpenSSL;
    FWaitEvent: THandle;
    FBaseURL: String;
  protected
    procedure Execute; override;
    constructor Create(AItem: TCDContact; WaitEvent: THandle);
  public
    destructor Destroy; override;
  end;

  TMultigetThread = class(TThread)
  private
    FResponse: string;
    FMultiget: string;
    FAddressBook: TCDAddressbook;
    FHTTP: TIdWebDAV;
    FSSLIO: TIdSSLIOHandlerSocketOpenSSL;
    FWaitEvent: THandle;
    FBaseURL: String;
    procedure DoProcessResponse;
  protected
    procedure Execute; override;
    constructor Create(AddressBook: TCDAddressbook; Multiget: string; WaitEvent: THandle);
  public
    destructor Destroy; override;
  end;

function vCardDateToDateTime(const S: String): TDateTime;
function DateTimeTovCardDate(DateTime: TDateTime; NoDelimiters: Boolean = False): String;

implementation

uses
  Windows,
  IdException,
  IdExceptionCore,
  IdResourceStringsProtocols,
  IdGlobal,
  IdGlobalProtocols,
  IdURI,
  SysUtils,
  Variants,
  StrUtils,
  XmlIntf,
  ActiveX,
  DateUtils;

function ExtractServerName(const URL: AnsiString): AnsiString;
begin
  Result := Copy(URL, Pos('://', URL) + 3, MaxInt);
  if Pos('/', Result) <> 0 then
    Result := Copy(Result, 1, Pos('/', Result) - 1);
end;

function ExtractServerWProtocolName(const URL: AnsiString): AnsiString;
begin
  Result := '';
  if Pos('://', URL) = 0 then
    Exit;
  Result := Copy(URL, 1, Pos('://', URL) + 2) + ExtractServerName(URL);
end;

{$IFNDEF SUPPORTS_TTIMEZONE}
function GetDateTimeForBiasSystemTime(GivenDateTime: TSystemTime; GivenYear: Integer): TDateTime;
var
  Year, Month, Day: Word;
  Hour, Minute, Second, MilliSecond: Word;
begin
  GivenDateTime.wYear := GivenYear;
  while not TryEncodeDayOfWeekInMonth(GivenDateTime.wYear, GivenDateTime.wMonth, GivenDateTime.wDay,
    GivenDateTime.wDayOfWeek, Result) do
    Dec(GivenDateTime.wDay);
  DecodeDateTime(Result, Year, Month, Day, Hour, Minute, Second, MilliSecond);
  Result := EncodeDateTime(Year, Month, Day, GivenDateTime.wHour, GivenDateTime.wMinute,
    GivenDateTime.wSecond, GivenDateTime.wMilliseconds);
end;

function GetBiasForDate(GivenDateTime: TDateTime): Integer;
var
  tzi: TIME_ZONE_INFORMATION;
begin
  GetTimeZoneInformation(tzi);
  if tzi.StandardDate.wMonth = 0 then
    Result := -tzi.Bias
  else if tzi.StandardDate.wMonth > tzi.DaylightDate.wMonth then
    if (GivenDateTime < GetDateTimeForBiasSystemTime(tzi.StandardDate, YearOf(GivenDateTime))) and
      (GivenDateTime >= GetDateTimeForBiasSystemTime(tzi.DaylightDate, YearOf(GivenDateTime))) then
      Result := -tzi.Bias - tzi.DaylightBias
    else
      Result := -tzi.Bias - tzi.StandardBias
  else if (GivenDateTime >= GetDateTimeForBiasSystemTime(tzi.StandardDate, YearOf(GivenDateTime))) and
    (GivenDateTime < GetDateTimeForBiasSystemTime(tzi.DaylightDate, YearOf(GivenDateTime))) then
    Result := -tzi.Bias - tzi.StandardBias
  else
    Result := -tzi.Bias - tzi.DaylightBias;
end;
{$ENDIF}

// Converts local date-time to UTC
function LocalDateTimeToUTC(Local: TDateTime): TDateTime;
begin
{$IFNDEF SUPPORTS_TTIMEZONE}
  Result := IncMinute(Local, -GetBiasForDate(Local));
{$ELSE}
  Result := DateUtils.TTimeZone.Local.ToUniversalTime(Local);
{$ENDIF}
end;

// Converts UTC date-time to local
function UTCDateTimeToLocal(UTC: TDateTime): TDateTime;
begin
{$IFNDEF SUPPORTS_TTIMEZONE}
  Result := IncMinute(UTC, GetBiasForDate(UTC));
{$ELSE}
  Result := DateUtils.TTimeZone.Local.ToLocalTime(UTC);
{$ENDIF}
end;

function XMLFilter(const XML: String): String;
begin
  Result := StringReplace(XML, 'c:dt=', 'cdt=', [rfReplaceAll, rfIgnoreCase]);
end;

function vCardDateToDateTime(const S: String): TDateTime;

  function StrToDate(const Str: String): TDateTime;
  begin
    Result := 0;
    if Length(Str) >= 8 then
      if Pos('-', Str) = 5 then
        Result := EncodeDate(StrToInt(Copy(Str, 1, 4)), StrToInt(Copy(Str, 6, 2)), StrToInt(Copy(Str, 9, 2)))
      else
        Result := EncodeDate(StrToInt(Copy(Str, 1, 4)), StrToInt(Copy(Str, 5, 2)), StrToInt(Copy(Str, 7, 2)));
  end;

  function StrToTime(const Str: String): TDateTime;
  begin
    Result := 0;
    if Length(Str) >= 6 then
      if Pos(':', Str) = 3 then
        Result := EncodeTime(StrToInt(Copy(Str, 1, 2)), StrToInt(Copy(Str, 4, 2)), StrToInt(Copy(Str, 7, 2)), 0)
      else
        Result := EncodeTime(StrToInt(Copy(Str, 1, 2)), StrToInt(Copy(Str, 3, 2)), StrToInt(Copy(Str, 5, 2)), 0);
  end;

var
  T: Integer;
begin
  Result := 0;
  if S = '' then
    Exit;
  T := Pos('T', S);
  if T = 0 then
    if (Length(S) = 8) or (Length(S) = 10) then
      Result := StrToDate(S)
    else
      Result := StrToTime(S)
  else
    Result := StrToDate(S) + StrToTime(Copy(S, T + 1, MaxInt));
end;

function RawStrInternetToDateTime(var Value: string; var VDateTime: TDateTime): Boolean;
var
  i: Integer;
  Dt, Mo, Yr, Ho, Min, Sec: Word;
  sYear, sTime, sDelim: string;
  //flags for if AM/PM marker found
  LAM, LPM : Boolean;

  procedure ParseDayOfMonth;
  begin
    Dt :=  IndyStrToInt( Fetch(Value, sDelim), 1);
    Value := TrimLeft(Value);
  end;

  procedure ParseMonth;
  begin
    Mo := StrToMonth( Fetch (Value, sDelim)  );
    Value := TrimLeft(Value);
  end;

begin
  Result := False;
  VDateTime := 0.0;

  LAM := False;
  LPM := False;

  Value := Trim(Value);
  if Length(Value) = 0 then begin
    Exit;
  end;

  {Day of Week}
  if StrToDay(Copy(Value, 1, 3)) > 0 then begin
    //workaround in case a space is missing after the initial column
    if CharEquals(Value, 4, ',') and (not CharEquals(Value, 5, ' ')) then begin
      Insert(' ', Value, 5);
    end;
    Fetch(Value);
    Value := TrimLeft(Value);
  end;

  // Workaround for some buggy web servers which use '-' to separate the date parts.    {Do not Localize}
  if (IndyPos('-', Value) > 1) and (IndyPos('-', Value) < IndyPos(' ', Value)) then begin    {Do not Localize}
    sDelim := '-';    {Do not Localize}
  end else begin
    sDelim := ' ';    {Do not Localize}
  end;

  //workaround for improper dates such as 'Fri, Sep 7 2001'    {Do not Localize}
  //RFC 2822 states that they should be like 'Fri, 7 Sep 2001'    {Do not Localize}
  if StrToMonth(Fetch(Value, sDelim, False)) > 0 then begin
    {Month}
    ParseMonth;
    {Day of Month}
    ParseDayOfMonth;
  end else begin
    {Day of Month}
    ParseDayOfMonth;
    {Month}
    ParseMonth;
  end;

  {Year}
  // There is some strange date/time formats like
  // DayOfWeek Month DayOfMonth Time Year
  sYear := Fetch(Value);
  Yr := IndyStrToInt(sYear, High(Word));
  if Yr = High(Word) then begin // Is sTime valid Integer?
    sTime := sYear;
    sYear := Fetch(Value);
    Value := TrimRight(sTime + ' ' + Value);
    Yr := IndyStrToInt(sYear);
  end;

  // RLebeau: According to RFC 2822, Section 4.3:
  //
  // "Where a two or three digit year occurs in a date, the year is to be
  // interpreted as follows: If a two digit year is encountered whose
  // value is between 00 and 49, the year is interpreted by adding 2000,
  // ending up with a value between 2000 and 2049.  If a two digit year is
  // encountered with a value between 50 and 99, or any three digit year
  // is encountered, the year is interpreted by adding 1900."
  if Length(sYear) = 2 then begin
    if {(Yr >= 0) and} (Yr <= 49) then begin
      Inc(Yr, 2000);
    end
    else if (Yr >= 50) and (Yr <= 99) then begin
      Inc(Yr, 1900);
    end;
  end
  else if Length(sYear) = 3 then begin
    Inc(Yr, 1900);
  end;

  VDateTime := EncodeDate(Yr, Mo, Dt);
  // SG 26/9/00: Changed so that ANY time format is accepted
  if IndyPos('AM', Value) > 0 then begin{do not localize}
    LAM := True;
    Value := Fetch(Value, 'AM');  {do not localize}
  end
  else if IndyPos('PM', Value) > 0 then begin {do not localize}
    LPM := True;
    Value := Fetch(Value, 'PM');  {do not localize}
  end;

  // RLebeau 03/04/2009: some countries use dot instead of colon
  // for the time separator
  i := IndyPos('.', Value);       {do not localize}
  if i > 0 then begin
    sDelim := '.';                {do not localize}
  end else begin
    sDelim := ':';                {do not localize}
  end;
  i := IndyPos(sDelim, Value);
  if i > 0 then begin
    // Copy time string up until next space (before GMT offset)
    sTime := Fetch(Value, ' ');  {do not localize}
    {Hour}
    Ho  := IndyStrToInt( Fetch(sTime, sDelim), 0);
    {Minute}
    Min := IndyStrToInt( Fetch(sTime, sDelim), 0);
    {Second}
    Sec := IndyStrToInt( Fetch(sTime), 0);
    {AM/PM part if present}
    Value := TrimLeft(Value);
    if LAM then begin
      if Ho = 12 then begin
        Ho := 0;
      end;
    end
    else if LPM then begin
      //in the 12 hour format, afternoon is 12:00PM followed by 1:00PM
      //while midnight is written as 12:00 AM
      //Not exactly technically correct but pretty accurate
      if Ho < 12 then begin
        Inc(Ho, 12);
      end;
    end;
    {The date and time stamp returned}
    VDateTime := VDateTime + EncodeTime(Ho, Min, Sec, 0);
  end;
  Value := TrimLeft(Value);
  Result := True;
end;

{This should never be localized}

function StrInternetToDateTime(Value: string): TDateTime;
begin
  try
    RawStrInternetToDateTime(Value, Result);
  except
    Result := vCardDateToDateTime(Value);
  end;
end;

function EncodeBase64(const inpStr: TStream): AnsiString;

  function Encode_Byte(b: Byte): AnsiChar;
  const
    Base64Code: string[64] =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  begin
    Result := Base64Code[(b and $3F)+1];
  end;

var
  b1, b2, b3: Byte;
  b2read, b3read: Boolean;
  TempStr: AnsiString;
begin
  Result := '';
  while inpStr.Read(b1, 1) > 0 do
  begin
    b2read := false;
    b3read := false;
    TempStr := TempStr + Encode_Byte(b1 shr 2);
    if inpStr.Read(b2, 1) = 0 then
      b2 := 0
    else
      b2read := true;
    TempStr := TempStr + Encode_Byte((b1 shl 4) or (b2 shr 4));
    if inpStr.Read(b3, 1) = 0 then
      b3 := 0
    else
      b3read := true;
    if b2read then
      TempStr := TempStr + Encode_Byte((b2 shl 2) or (b3 shr 6))
    else
      TempStr := TempStr + '=';
    if b3read then
      TempStr := TempStr + Encode_Byte(b3)
    else
      TempStr := TempStr + '=';
  end;
  Result := TempStr;
end;

procedure DecodeBase64(const CinLine: AnsiString; ToStream: TStream);
const
  RESULT_ERROR = -2;
var
  inLineIndex: Integer;
  c: AnsiChar;
  x: SmallInt;
  b: Byte;
  c4: Word;
  StoredC4: array[0..3] of SmallInt;
  InLineLength: Integer;
begin
  inLineIndex := 1;
  c4 := 0;
  InLineLength := Length(CinLine);

  while inLineIndex <= InLineLength do
  begin
    while (inLineIndex <= InLineLength) and (c4 < 4) do
    begin
      c := CinLine[inLineIndex];
      case c of
        '+'     : x := 62;
        '/'     : x := 63;
        '0'..'9': x := Ord(c) - (Ord('0')-52);
        '='     : x := -1;
        'A'..'Z': x := Ord(c) - Ord('A');
        'a'..'z': x := Ord(c) - (Ord('a')-26);
      else
        x := RESULT_ERROR;
      end;
      if x <> RESULT_ERROR then
      begin
        StoredC4[c4] := x;
        Inc(c4);
      end;
      Inc(inLineIndex);
    end;

    if c4 = 4 then
    begin
      c4 := 0;
      b := (StoredC4[0] shl 2) or (StoredC4[1] shr 4);
      ToStream.Write(b, 1);
      if StoredC4[2] = -1 then Exit;
      b := (StoredC4[1] shl 4) or (StoredC4[2] shr 2);
      ToStream.Write(b, 1);
      if StoredC4[3] = -1 then Exit;
      b := (StoredC4[2] shl 6) or (StoredC4[3]);
      ToStream.Write(b, 1);
    end;
  end;
  ToStream.Position := 0;
end;

function FileNameOnly(const URL: AnsiString): AnsiString;
begin
  Result := URL;
  while (Pos('/', Result) > 0) do
    if Pos('/', Result) < Length(Result) then
      Result := Copy(Result, Pos('/', Result) + 1, MaxInt)
    else
      Result := '';
end;

function BSEscape(const Str: String): String;
begin
  Result := AdjustLineBreaks(Str, tlbsCRLF);
  Result := StringReplace(Result, '\', '<$backslash$>', [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, '\n', [rfReplaceAll]);
//  Result := StringReplace(Result, ':', '\:', [rfReplaceAll]);
//  Result := StringReplace(Result, ';', '\;', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '\,', [rfReplaceAll]);
  Result := StringReplace(Result, '<$backslash$>', '\\', [rfReplaceAll]);
end;

function BSUnescape(const Str: String): String;
begin
  Result := StringReplace(Str, '\\', '<$backslash$>', [rfReplaceAll]);
  Result := StringReplace(Result, '\n', #13#10, [rfReplaceAll, rfIgnoreCase]);
//  Result := StringReplace(Result, '\:', ':', [rfReplaceAll]);
//  Result := StringReplace(Result, '\;', ';', [rfReplaceAll]);
  Result := StringReplace(Result, '\,', ',', [rfReplaceAll]);
  Result := StringReplace(Result, '<$backslash$>', '\', [rfReplaceAll]);
end;

function QPEncode(const InString: AnsiString): AnsiString;
const
  SafeChars = [#33..#60, #62..#126];
  HalfSafeChars = [#32, #9];
var
  CurrentLine: ShortString;
  SourceLine: AnsiString;
  CurrentPos: Integer;

  procedure WriteToString(const s: AnsiString);
  begin
    CurrentLine := Copy(CurrentLine, 1, CurrentPos - 1);
    CurrentLine := CurrentLine + s;
    Inc(CurrentPos, Length(s));
  end;

  function ByteToHex(const AByte: Byte): AnsiString;
  const
    HexDigits: array[0..15] of AnsiChar = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
      'F');
  begin
    SetLength(Result, 2);
    Result[1] := HexDigits[(AByte and $F0) shr 4];
    Result[2] := HexDigits[AByte and $F];
  end;

  procedure FinishLine;
  begin
    Result := Result + Copy(CurrentLine, 1, CurrentPos - 1) + #13#10;
    CurrentPos := 1;
  end;

  function CharToHex(const AChar: AnsiChar): AnsiString;
  begin
    Result := '=' + ByteToHex(Ord(AChar));
  end;

var
  I: Integer;
  LSourceSize: Integer;
  InPosition: integer;
begin
  Result := '';
  SetLength(CurrentLine, 255);
  LSourceSize := Length(InString);
  InPosition := 1;
  while InPosition <= LSourceSize do
  begin
    I := PosEx(#13#10, InString, InPosition);
    if I > 0 then
    begin
      SourceLine := Copy(InString, InPosition, I - InPosition);
      InPosition := I + 2;
    end
    else
    begin
      SourceLine := Copy(InString, InPosition, MaxInt);
      InPosition := LSourceSize + 1;
    end;
    CurrentPos := 1;
    for i := 1 to Length(SourceLine) do
    begin
      if not (SourceLine[i] in SafeChars) then
      begin
        if (SourceLine[i] in HalfSafeChars) then
        begin
          if i = Length(SourceLine) then
          begin
            WriteToString(CharToHex(SourceLine[i]));
          end
          else
          begin
            WriteToString(SourceLine[i]);
          end;
        end
        else
        begin
          WriteToString(CharToHex(SourceLine[i]));
        end;
      end
      else if ((CurrentPos = 1) or (CurrentPos = 71)) and (SourceLine[i] = '.') then
      begin
        WriteToString(CharToHex(SourceLine[i]));
      end
      else
      begin
        WriteToString(SourceLine[i]);
      end;
      if CurrentPos > 70 then
      begin
        WriteToString('=');
        FinishLine;
      end;
    end;
    FinishLine;
  end;
end;

function QPDecode(const QPString: AnsiString): AnsiString;
var
  LBuffer: AnsiString;
  i: Integer;
  B, DecodedByte: Byte;
  LBufferLen: Integer;
  LBufferIndex: Integer;
  LPos: integer;

  procedure StripEOLChars;
  var
    j: Integer;
  begin
    for j := 1 to 2 do
    begin
      if (LBufferIndex > LBufferLen) or (not Ord(LBuffer[LBufferIndex]) in [10, 13]) then
      begin
        Break;
      end;
      Inc(LBufferIndex);
    end;
  end;

begin
  Result := '';
  LBuffer := Trim(QPString);
  LBufferLen := Length(LBuffer);
  if LBufferLen <= 0 then
  begin
    Exit;
  end;
  LBufferIndex := 1;
  while LBufferIndex <= LBufferLen do
  begin
    LPos := PosEx('=', LBuffer, LBufferIndex);
    if LPos < 1 then
    begin
      Result := Result + Copy(LBuffer, LBufferIndex, MaxInt);
      Break;
    end;
    Result := Result + Copy(LBuffer, LBufferIndex, LPos - LBufferIndex);
    LBufferIndex := LPos + 1;
    // process any following hexidecimal representation
    if LBufferIndex <= LBufferLen then
    begin
      i := 0;
      DecodedByte := 0;
      while LBufferIndex <= LBufferLen do
      begin
        B := Ord(LBuffer[LBufferIndex]);
        case B of
          48..57: //0-9
            DecodedByte := (DecodedByte shl 4) or (B - 48);
          65..70: //A-F
            DecodedByte := (DecodedByte shl 4) or (B - 65 + 10);
          97..102: //a-f
            DecodedByte := (DecodedByte shl 4) or (B - 97 + 10);
        else
          Break;
        end;
        Inc(i);
        Inc(LBufferIndex);
        if i > 1 then
        begin
          Break;
        end;
      end;
      if i > 0 then
      begin
        if (DecodedByte = 32) and (LBufferIndex <= LBufferLen) and (Ord(LBuffer[LBufferIndex]) in [10, 13]) then
        begin
          Result := Result + AnsiChar(DecodedByte) + #13#10;
          StripEOLChars;
        end
        else
        begin
          Result := Result + AnsiChar(DecodedByte);
        end;
      end
      else
      begin
        StripEOLChars;
      end;
    end;
  end;
end;

function DateTimeTovCardDate(DateTime: TDateTime; NoDelimiters: Boolean = False): String;
begin
  if NoDelimiters then
  begin
    Result := FormatDateTime('yyyymmdd', DateTime);
    if Frac(DateTime) <> 0 then
      Result := Result + FormatDateTime('"T"hhnnss"Z"', DateTime);
  end
  else
  begin
    Result := FormatDateTime('yyyy-mm-dd', DateTime);
    if Frac(DateTime) <> 0 then
      Result := Result + FormatDateTime('"T"hh:nn:ss"Z"', DateTime);
  end;
end;

function OleVariantToString(Value: OleVariant): AnsiString;
begin
  if VarIsNull(Value) then
    Result := ''
  else
    Result := Value;
end;

function OleVariantToWideString(Value: OleVariant): WideString;
begin
  if VarIsNull(Value) then
    Result := ''
  else
    Result := Value;
end;

procedure TCDAddressbook.LoadAllContacts;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  lHRef: String;
  I: Integer;
begin
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8"?>' + #13#10 +
    '<C:addressbook-query xmlns:C="urn:ietf:params:xml:ns:carddav" xmlns:D="DAV:">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getcontenttype/>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '    <C:address-data/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter/>' + #13#10 +
    '</C:addressbook-query>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    Req.Position := 0;
    try
      FHTTP.DAVReport(FBaseURL, Req, Resp);
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
    XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
    XMLDoc.Active := True;
    FContacts.Clear;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
            with ChildNodes['propstat'].ChildNodes['prop'].ChildNodes do
            begin
              lHRef := OleVariantToWideString(ChildValues['href']);
              if (FindNode('getcontenttype', 'DAV:') = nil)
              or (FindNode('getcontenttype', 'DAV:').NodeValue <> 'text/x-vcard') then
                if (Pos('.vcf', lHRef) = 0) and (Pos('.eml', lHRef) = 0) then
                Continue;
              if (FindNode('getcontenttype', 'DAV:') <> nil) then
                if (FindNode('getcontenttype', 'DAV:').NodeValue <> FUsedMIMEType) then
                  FUsedMIMEType := OleVariantToWideString(FindNode('getcontenttype', 'DAV:').NodeValue);
              with NewContact do
              begin
                FHRef := lHRef;
                FETagOnly := False;
                FGetOnNextMultiget := False;
                if FindNode('getlastmodified', 'DAV:') <> nil then
                  with FindNode('getlastmodified', 'DAV:') do
                    FLastModified := StrInternetToDateTime(NodeValue)
                else
                  FlastModified := 0;
                if FindNode('getetag', 'DAV:') <> nil then
                  with FindNode('getetag', 'DAV:') do
                    FETag := OleVariantToWideString(NodeValue)
                else
                  FETag := '';
                with FindNode('address-data',
                  'urn:ietf:params:xml:ns:carddav') do
                  SetvCard(OleVariantToWideString(NodeValue));
              end;
            end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TCDAddressbook.LoadContactsETags;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  lHRef: String;
  I: Integer;
begin
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8"?>' + #13#10 +
    '<D:propfind xmlns:D="DAV:">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getcontenttype/>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FBaseURL, Req, Resp, '1');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
    XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
    XMLDoc.Active := True;
    FContacts.Clear;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
            with ChildNodes['propstat'].ChildNodes['prop'].ChildNodes do
            begin
              lHRef := OleVariantToWideString(ChildValues['href']);
              if (FindNode('getcontenttype', 'DAV:') = nil)
              or (FindNode('getcontenttype', 'DAV:').NodeValue <> 'text/x-vcard') then
                if (Pos('.vcf', lHRef) = 0) and (Pos('.eml', lHRef) = 0) then
                Continue;
              if (FindNode('getcontenttype', 'DAV:') <> nil) then
                if (FindNode('getcontenttype', 'DAV:').NodeValue <> FUsedMIMEType) then
                  FUsedMIMEType := OleVariantToWideString(FindNode('getcontenttype', 'DAV:').NodeValue);
              with NewContact do
              begin
                FHRef := lHRef;
                FETagOnly := True;
                if FindNode('getlastmodified', 'DAV:') <> nil then
                  with FindNode('getlastmodified', 'DAV:') do
                    FLastModified := StrInternetToDateTime(NodeValue)
                else
                  FlastModified := 0;
                if FindNode('getetag', 'DAV:') <> nil then
                  with FindNode('getetag', 'DAV:') do
                    FETag := OleVariantToWideString(NodeValue)
                else
                  FETag := '';
              end;
            end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TCDAddressbook.MultiGet(MaxThreads, ItemsInThread: Word; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
var
  MultiGet: String;
  I, Added: Integer;
  WaitEvent: THandle;
  Total, Current: Cardinal;
begin
  FCancelMultiget := False;
  Total := 0;
  for I := 0 to FContacts.Count - 1 do
  begin
    if TCDContact(FContacts[I]).FGetOnNextMultiget then
      Inc(Total);
    TCDContact(FContacts[I]).FLoaded := False;
  end;
  if Total = 0 then
    Exit;
  if Assigned(OnWorkBeginEvent) then
    OnWorkBeginEvent(Self, wmRead, Total);
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    repeat
      repeat
        Multiget := '';
        Added := 0;
        for I := 0 to FContacts.Count - 1 do
          if TCDContact(FContacts[I]).FGetOnNextMultiget then
          begin
            MultiGet := MultiGet + '    <D:href xmlns:D="DAV:">' + TCDContact(FContacts[I]).FHRef + '</D:href>' + #13#10;
            TCDContact(FContacts[I]).FGetOnNextMultiget := False;
            Inc(Added);
            if Added >= ItemsInThread then
              break;
          end;
        if MultiGet <> '' then
          FMultigetThreads.Add(TMultigetThread.Create(Self, MultiGet, WaitEvent));
      until (MultiGet = '') or (FMultigetThreads.Count >= MaxThreads);
      if FMultigetThreads.Count > 0 then
        WaitForSingleObject(WaitEvent, INFINITE)
      else
        Break;
      ResetEvent(WaitEvent);
      Current := 0;
      for I := 0 to FContacts.Count - 1 do
        if TCDContact(FContacts[I]).FLoaded then
          Inc(Current);
      if Assigned(OnWorkEvent) then
        OnWorkEvent(Self, wmRead, Current);
    until FCancelMultiget;
  finally
    CloseHandle(WaitEvent);
  end;
end;

procedure TCDAddressbook.MultiGet;
var
  Req, Resp: TStringStream;
  MultiGetStr, lHRef: String;
  XMLDoc: TXMLDocument;
  I: Integer;
begin
  MultigetStr := '';
  for I := 0 to FContacts.Count - 1 do
    if TCDContact(FContacts[I]).FGetOnNextMultiget then
      MultiGetStr := MultiGetStr + '  <D:href xmlns:D="DAV:">' + TCDContact(FContacts[I]).FHRef + '</D:href>' + #13#10;
  if MultigetStr = '' then
    Exit;
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8"?>' + #13#10 +
    '<C:addressbook-multiget xmlns:C="urn:ietf:params:xml:ns:carddav">' + #13#10 +
    '  <D:prop xmlns:D="DAV:">' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '    <D:getcontenttype/>' + #13#10 +
    '    <C:address-data/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    MultiGetStr +
    '</C:addressbook-multiget>'
  );
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    Req.Position := 0;
    try
      FHTTP.DAVReport(FBaseURL, Req, Resp);
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
    XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
    XMLDoc.Active := True;
    FContacts.Clear;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
            with ChildNodes['propstat'].ChildNodes['prop'].ChildNodes do
            begin
              lHRef := OleVariantToWideString(ChildValues['href']);
              if (FindNode('getcontenttype', 'DAV:') = nil)
              or (FindNode('getcontenttype', 'DAV:').NodeValue <> 'text/x-vcard') then
                if (Pos('.vcf', lHRef) = 0) and (Pos('.eml', lHRef) = 0) then
                Continue;
              if (FindNode('getcontenttype', 'DAV:') <> nil) then
                if (FindNode('getcontenttype', 'DAV:').NodeValue <> FUsedMIMEType) then
                  FUsedMIMEType := OleVariantToWideString(FindNode('getcontenttype', 'DAV:').NodeValue);
              with NewContact do
              begin
                FHRef := lHRef;
                if FindNode('getlastmodified', 'DAV:') <> nil then
                  with FindNode('getlastmodified', 'DAV:') do
                    FLastModified := StrInternetToDateTime(NodeValue)
                else
                  FlastModified := 0;
                if FindNode('getetag', 'DAV:') <> nil then
                  with FindNode('getetag', 'DAV:') do
                    FETag := OleVariantToWideString(NodeValue)
                else
                  FETag := '';
                with FindNode('address-data',
                  'urn:ietf:params:xml:ns:carddav') do
                  SetvCard(OleVariantToWideString(NodeValue));
                GetOnNextMultiget := False;
              end;
            end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDAddressbook.ContactWithHRef(HRef: String): TCDContact;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FContacts.Count - 1 do
    if TCDContact(FContacts[I]).FHRef = HRef then
    begin
      Result := TCDContact(FContacts[I]);
      Exit;
    end;
end;

constructor TCDAddressbook.Create;
begin
  inherited Create;
  FCriticalSection := TCriticalSection.Create;
  FContacts := TObjectList.Create(True);
  FAddressbooks := TStringList.Create;
  FCTags := TStringList.Create;
  FHTTP := TIdWebDAV.Create(nil);
  FSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHTTP.IOHandler := FSSLIO;
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 4;
  FHTTP.ConnectTimeout := 30000;
  FHTTP.ReadTimeout := 30000;
  FHTTP.HTTPOptions := [hoForceEncodeParams, hoInProcessAuth];
  FHTTP.Request.UserAgent := 'Mozilla/5.0';
  FHTTP.IOHandler.RecvBufferSize := 50 * 1024;
  FHTTP.IOHandler.SendBufferSize := 50 * 1024;
  FUsedMIMEType := 'text/x-vcard';
  FMultigetThreads := TObjectList.Create(False);
  FStoreThreads := TObjectList.Create(False);
end;

procedure TCDAddressbook.CreateAddressbook(const NewAddressbookName: string);
  function GUIDToString(const Guid: TGUID): string;
  begin
    SetLength(Result, 36);
    StrLFmt(PChar(Result), 36,'%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x',
      [Guid.D1, Guid.D2, Guid.D3, Guid.D4[0], Guid.D4[1], Guid.D4[2], Guid.D4[3],
      Guid.D4[4], Guid.D4[5], Guid.D4[6], Guid.D4[7]]);
  end;
  function GUIDString: String;
  var
    Guid: TGUID;
  begin
    CreateGUID(Guid);
    Result := GUIDToString(Guid);
  end;
var
  Req: TStringStream;
  XMLDoc: TXMLDocument;
  URL: string;
begin
  Req := TStringStream.Create(
      '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
      '<D:mkcol xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">' + #13#10 +
      '  <D:set>' + #13#10 +
      '    <D:prop>' + #13#10 +
      '      <D:resourcetype>' + #13#10 +
      '        <D:collection/>' + #13#10 +
      '        <C:addressbook/>' + #13#10 +
      '      </D:resourcetype>' + #13#10 +
      '      <D:displayname><![CDATA[]]></D:displayname>' + #13#10 +
      '    </D:prop>' + #13#10 +
      '  </D:set>' + #13#10 +
      '</D:mkcol>'
      );
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    Req.Position := 0;
    URL := TIdURI.URLEncode(TIdURI.URLDecode(AddressbookHomeSetURL) + GUIDString) + '/';
    FHTTP.DoRequest('MKCOL', URL, Req, nil, []);
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
    FAddressbooks.Add(NewAddressbookName + '=' + URL);
    FCTags.Add('');
  finally
    Req.Free;
  end;
  ChangeDisplayName(URL, NewAddressbookName);
end;

procedure TCDAddressbook.DeleteAddressbook;
var
  I: Integer;
begin
  FHTTP.Disconnect;
  try
    FHTTP.DoRequest('DELETE', FBaseURL, nil, nil, []);
  finally
    for I := FAddressbooks.Count - 1 downto 0 do
      if FAddressbooks.ValueFromIndex[I] = FBaseURL then
      begin
        FAddressbooks.Delete(I);
        FCTags.Delete(I);
      end;
  end;
end;

destructor TCDAddressbook.Destroy;
var
  I: Integer;
begin
  StopAllThreads;
  FSSLIO.Free;
  FHTTP.Free;
  FStoreThreads.Free;
  FMultigetThreads.Free;
  FLogFile.Free;
  FCTags.Free;
  FAddressbooks.Free;
  FContacts.Free;
  FCriticalSection.Free;
  inherited;
end;

function TCDAddressbook.GetUserName: String;
begin
  Result := FHTTP.Request.Username;
end;

function TCDAddressbook.GetUserPrincipal: AnsiString;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  Attempt: Integer;
begin
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  Attempt := 0;
  repeat
    Inc(Attempt);
    Req := TStringStream.Create(
      '<?xml version="1.0" encoding="utf-8" ?>' +
      '<D:propfind xmlns:D="DAV:">' +
      '<D:prop>' +
      '   <D:current-user-principal/>' +
      '</D:prop>' +
      '</D:propfind>');
    Resp := TStringStream.Create('');
    XMLDoc := TXMLDocument.Create(FHTTP);
    try
      try
        FHTTP.Disconnect;
        FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
        Req.Position := 0;
        try
          FHTTP.DAVPropFind(FBaseURL, Req, Resp);
        except
          on E: EIdConnClosedGracefully do
            Exit;
          else
            raise;
        end;
        if FHTTP.ResponseCode div 100 <> 2 then
          raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
        XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
        XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
        XMLDoc.Active := True;
        with XMLDoc.DocumentElement do
          if ChildNodes['response'] <> nil then
            with ChildNodes['response'] do
              if ChildNodes['propstat'] <> nil then
                with ChildNodes['propstat'] do
                  if ChildNodes['prop'] <> nil then
                    with ChildNodes['prop'] do
                      if ChildNodes['current-user-principal'] <> nil then
                        with ChildNodes['current-user-principal'] do
                          if ChildNodes.FindNode('unauthenticated') <> nil then
                            raise Exception.Create('Unauthenticated')
                          else
                          if ChildNodes['href'] <> nil then
                            Result := ExtractServerWProtocolName(FBaseURL) + ChildValues['href'];
        Result := StringReplace(Result, ' ', '%20', [rfReplaceAll]);
        break;
      except on E: EIdSocksError do
        raise;
      else
        if Attempt = 1 then
            FBaseURL := ExtractServerWProtocolName(FBaseURL) + '/.well-known/carddav/'
        else
        begin
          Result := '';
          raise;
        end;
      end;
    finally
      XMLDoc.Free;
      Resp.Free;
      Req.Free;
    end;
  until false;
end;

procedure TCDAddressbook.SetUserName(const Value: String);
begin
  FHTTP.Request.Username := Value;
end;

procedure TCDAddressbook.StopAllThreads;
var
  I: Integer;
begin
  FHTTP.IOHandler.InputBuffer.Clear;
  FHTTP.Disconnect;
  FCancelMultiget := True;
  FCancelStore := True;
  FCriticalSection.Enter;
  try
    for I := FMultigetThreads.Count - 1 downto 0 do
    with TMultigetThread(FMultigetThreads[I]) do
    try
      FHTTP.Disconnect;
      Terminate;
    except
    end;
    for I := FStoreThreads.Count - 1 downto 0 do
    with TCardDAVStoreThread(FStoreThreads[I]) do
    try
      FHTTP.Disconnect;
      Terminate;
    except
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCDAddressbook.SetPassword(const Value: String);
begin
  FHTTP.Request.Password := Value;
end;

function TCDAddressbook.GetPassword: String;
begin
  Result := FHTTP.Request.Password;
end;

procedure TCDAddressbook.SetProxyServer(const Value: String);
begin
  FProxyServer := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDAddressbook.SetProxyPassword(const Value: String);
begin
  FProxyPassword := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDAddressbook.SetProxyType(const Value: TCardDavProxyType);
begin
  FProxyType := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDAddressbook.SetProxyUsername(const Value: String);
begin
  FProxyUsername := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDAddressbook.SetProxyPort(const Value: Word);
begin
  FProxyPort := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDAddressbook.SetLogFileName(const Value: String);
begin
  if FLogFileName = Value then
    Exit;
  FLogFileName := Value;
  if Trim(FLogFileName) <> '' then
  begin
    if FLogFile = nil then
    begin
      FLogFile := TIdLogFile.Create;
      FLogFile.ReplaceCRLF := False;
      FHTTP.Intercept := FLogFile;
    end;
    FLogFile.Filename := FLogFileName;
    FLogFile.Active := True;
  end
  else
  begin
    FHTTP.Intercept := nil;
    FreeAndNil(FLogFile);
  end;
end;

function TCDAddressbook.NewContact: TCDContact;
begin
  Result := TCDContact.Create(Self);
  FContacts.Add(Result);
end;

procedure TCDAddressbook.ParseMultigetResponse(const Request: string;
  ResponseText: string; LastModified: TDateTime; var Multiget: String);
var
  XMLDoc: TXMLDocument;
  Node: IXMLNode;
  I: Integer;
  lHRef, lETag: String;
  NewItem, ToMarkLoaded: TCDContact;
  lLastModified: TDateTime;
begin
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := ResponseText;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(ResponseText);
{$ENDIF}
    XMLDoc.Active := True;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
        begin
          if FCancelMultiget then
            Exit;
          with ChildNodes[I] do
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
            begin
              lHRef := ChildNodes['href'].Text;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getlastmodified', 'DAV:');
              if Node <> nil then
                lLastModified := StrInternetToDateTime(Node.Text)
              else
                lLastModified := 0;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getetag', 'DAV:');
              if Node <> nil then
                lETag := Node.Text
              else
                lETag := '';
              if (LastModified <> 0) and (lLastModified <> 0) and (lLastModified < LastModified) then
                Continue;
              with ChildNodes['propstat'].ChildNodes['prop'].ChildNodes do
              begin
                if (FindNode('getcontenttype', 'DAV:') = nil)
                or (FindNode('getcontenttype', 'DAV:').NodeValue <> 'text/x-vcard') then
                  if (Pos('.vcf', lHRef) = 0) and (Pos('.eml', lHRef) = 0) then
                  Continue;
                if (FindNode('getcontenttype', 'DAV:') <> nil) then
                  if (FindNode('getcontenttype', 'DAV:').NodeValue <> FUsedMIMEType) then
                    FUsedMIMEType := OleVariantToWideString(FindNode('getcontenttype', 'DAV:').NodeValue);
              end;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('address-data',
                'urn:ietf:params:xml:ns:carddav');
              if (Node <> nil) or (Multiget = 'none') then
              begin
                NewItem := nil;
                FCriticalSection.Enter;
                try
                  if Request = '' then
                  begin
                    NewItem := ContactWithHRef(lHRef);
                  end;
                  if NewItem = nil then
                  begin
                    NewItem := NewContact;
                  end;
                finally
                  FCriticalSection.Leave;
                end;
                if NewItem = nil then
                  Continue;
                with NewItem do
                begin
                  FHRef := lHRef;
                  FLastModified := lLastModified;
                  FETag := lETag;
                  if Node <> nil then
                    SetvCard(Node.Text);
                  ToMarkLoaded := ContactWithHRef(lHRef);
                  if ToMarkLoaded <> nil then
                    ToMarkLoaded.FLoaded := True;
                  Continue;
                end;
              end;
              if (Multiget <> 'none') and (Request <> '') then
                MultiGet := MultiGet + '    <D:href>' + lHRef + '</D:href>' + #13#10;
            end;
        end;
  finally
    XMLDoc.Free;
  end;
end;

procedure TCDAddressbook.RenameAddressbook(const NewAddressbookName: string);
begin
  ChangeDisplayName(FBaseURL, NewAddressbookName);
end;

procedure TCDAddressbook.ResetBatchStoring;
var
  I: Integer;
begin
  for I := ContactCount - 1 downto 0 do
    Contacts[I].ResetBatchStoring;
end;

procedure TCDAddressbook.ApplyProxySettings(AHTTP: TIdHTTP; ASSLIO: TIdSSLIOHandlerSocketOpenSSL);
begin
  AHTTP.ProxyParams.ProxyServer := '';
  AHTTP.ProxyParams.ProxyPort := 0;
  AHTTP.ProxyParams.ProxyUsername := '';
  AHTTP.ProxyParams.ProxyPassword := '';
  AHTTP.ProxyParams.BasicAuthentication := False;
  ASSLIO.TransparentProxy := nil;
  if FProxyType = ptNone then
    Exit;
  if Trim(FProxyServer) = '' then
    Exit;
  if FProxyPort = 0 then
    Exit;
  if FProxyType = ptHTTP then
  begin
    AHTTP.ProxyParams.ProxyServer := FProxyServer;
    AHTTP.ProxyParams.ProxyPort := FProxyPort;
    if Trim(FProxyUsername) <> '' then
    begin
      AHTTP.ProxyParams.ProxyUsername := FProxyUsername;
      AHTTP.ProxyParams.ProxyPassword := FProxyPassword;
      AHTTP.ProxyParams.BasicAuthentication := True;
    end;
  end
  else
  begin
    ASSLIO.TransparentProxy := TIdSocksInfo.Create(nil);
    with TIdSocksInfo(ASSLIO.TransparentProxy) do
    begin
      if FProxyType = ptSocks4 then
        Version := svSocks4
      else
        Version := svSocks5;
      Host := FProxyServer;
      Port := FProxyPort;
      if Trim(FProxyUsername) <> '' then
      begin
        Username := FProxyUsername;
        Password := FProxyPassword;
        Authentication := saUsernamePassword;
      end;
    end;
  end;
end;

function TCDAddressbook.BaseURLIsAddressbook: Boolean;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
begin
  Result := False;
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8" ?>' +
    '<D:propfind xmlns:D="DAV:">' +
    ' <D:prop>' +
    '  <D:resourcetype/>' +
    ' </D:prop>' +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
      Req.Position := 0;
      try
        FHTTP.DAVPropFind(FBaseURL, Req, Resp, '0');
      except
        on E: EIdConnClosedGracefully do
          Exit;
        else
          raise;
      end;
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
      XMLDoc.XML.Text := Resp.DataString;
      XMLDoc.Active := True;
      if XMLDoc.DocumentElement <> nil then
        with XMLDoc.DocumentElement do
            with ChildNodes[0] do
            begin
              if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
                if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                  'DAV:') <> nil then
                    Result := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                  'DAV:').ChildNodes.FindNode('addressbook', 'urn:ietf:params:xml:ns:carddav') <> nil;
            end;
    except
      on E: EIdSocksError do
        raise;
      on E: EIdReadTimeout do
        raise;
      else
        exit;
    end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TCDAddressbook.BatchStore(MaxThreads: Integer);
var
  Queue, LastQueue, I: Integer;
  Total, Current: Cardinal;
  WaitEvent: THandle;
begin
  FCancelStore := False;
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    LastQueue := 0;
    repeat
      ResetEvent(WaitEvent);
      Queue := 0;
      Total := 0;
      Current := 0;
      for I := 0 to FContacts.Count - 1 do
        if Contacts[I].FStoreThread = nil then
        begin
          if Contacts[I].FToStore or Contacts[I].FToDelete then
          begin
            Inc(Total);
            if Contacts[I].FStoreError = '' then
            begin
              if LastQueue < MaxThreads then
              begin
                Inc(Queue);
                Inc(LastQueue);
                Contacts[I].FStoreThread := TCardDAVStoreThread.Create(Contacts[I], WaitEvent);
                FCriticalSection.Enter;
                try
                  FStoreThreads.Add(Contacts[I].FStoreThread);
                finally
                  FCriticalSection.Leave;
                end;
              end;
            end
            else
              Inc(Current);
          end;
        end
        else
        begin
          Inc(Queue);
          if Contacts[I].FToStore or Contacts[I].FToDelete then
          begin
            Inc(Total);
            if Contacts[I].FStoreError <> '' then
              Inc(Current);
          end;
        end;
      LastQueue := Queue;
      if Assigned(FOnBatchStoreProgress) then
        FOnBatchStoreProgress(Self, Current, Total, FCancelStore);
      if Queue > 0 then
        WaitForSingleObject(WaitEvent, INFINITE);
      for I := FContacts.Count - 1 downto 0 do
        if (Contacts[I].FStoreError <> '') and (Contacts[I].FStoreError <> 'OK') then
        begin
          if Assigned(FOnStoreError) then
            FOnStoreError(Contacts[I], Contacts[I].FStoreError)
          else
            raise Exception.Create(Contacts[I].FStoreError);
        end;
      Dec(LastQueue);
    until (Queue = 0) or FCancelStore;
  finally
    while Queue > 0 do
    begin
      WaitForSingleObject(WaitEvent, INFINITE);
      ResetEvent(WaitEvent);
      Queue := 0;
      for I := FContacts.Count - 1 downto 0 do
        if Contacts[I].FStoreThread <> nil then
          Inc(Queue);
    end;
    CloseHandle(WaitEvent);
    for I := FContacts.Count - 1 downto 0 do
      if Contacts[I].FStoreError = 'OK' then
      begin
        Contacts[I].FStoreError := '';
        Contacts[I].FToStore := False;
        if Contacts[I].FToDelete then
          FContacts.Delete(I);
      end;
  end;
end;

procedure TCDAddressbook.ChangeDisplayName(URL, NewDisplayName: string);
var
  Req: TStringStream;
  XMLDoc: TXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    XMLDoc.XML.Text :=
      '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
      '<D:propertyupdate xmlns:D="DAV:">' + #13#10 +
      '  <D:set>' + #13#10 +
      '    <D:prop>' + #13#10 +
      '      <D:displayname/>' + #13#10 +
      '    </D:prop>' + #13#10 +
      '  </D:set>' + #13#10 +
      '</D:propertyupdate>';
    XMLDoc.Active := True;
    XMLDoc.DocumentElement.ChildNodes['set'].ChildNodes['prop'].ChildValues['displayname'] := NewDisplayName;
{$IFDEF 2010ANDLATER}
    Req := TStringStream.Create(Utf8Encode(XMLDoc.XML.Text));
{$ELSE}
    Req := TStringStream.Create(XMLDoc.XML.Text);
{$ENDIF}
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
      Req.Position := 0;
      FHTTP.DoRequest('PROPPATCH', URL, Req, nil, []);
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
    finally
      Req.Free;
    end;
  finally
    XMLDoc.Free;
  end;
end;

function TCDAddressbook.ContactCount: Integer;
begin
  Result := FContacts.Count;
end;

function TCDAddressbook.GetAddressbookCTag: string;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
begin
  if not BaseURLIsAddressbook then
    raise Exception.Create('URL is not addressbook');
  Result := '';
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<D:propfind xmlns:D="DAV:" xmlns:cs="http://calendarserver.org/ns/">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <cs:getctag/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FBaseURL, Req, Resp, '0');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
    XMLDoc.Active := True;
    with XMLDoc.DocumentElement do
      if ChildNodes.Count > 0 then
        with ChildNodes[0] do
          if ChildNodes.FindNode('propstat') <> nil then
            with ChildNodes['propstat'] do
              if (Pos('200 OK', ChildNodes['status'].Text) > 0)
              and (ChildNodes.FindNode('prop') <> nil) then
                with ChildNodes['prop'] do
                  if ChildNodes.FindNode('getctag', 'http://calendarserver.org/ns/') <> nil then
                    Result := ChildNodes.FindNode('getctag', 'http://calendarserver.org/ns/').Text;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDAddressbook.GetAddressbookDisplayName: String;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
begin
  Result := '';
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<D:propfind xmlns:D="DAV:">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:displayname/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FBaseURL, Req, Resp, '0');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
    XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
    XMLDoc.Active := True;
    with XMLDoc.DocumentElement do
      if ChildNodes.Count > 0 then
        with ChildNodes[0] do
          if ChildNodes.FindNode('propstat') <> nil then
            with ChildNodes['propstat'] do
              if (Pos('200 OK', OleVariantToString(ChildValues['status'])) > 0)
              and (ChildNodes.FindNode('prop') <> nil) then
                with ChildNodes['prop'] do
                  if ChildNodes.FindNode('displayname') <> nil then
                    Result := OleVariantToWideString(ChildValues['displayname']);
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDAddressbook.GetAddressbookHomeSet: AnsiString;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  FURL: AnsiString;
begin
  FURL := GetUserPrincipal;
  if FURL = '' then
    Exit;
  Result := '';
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8" ?>' +
    '<D:propfind xmlns:D="DAV:">' +
    '<D:prop>' +
    '   <C:addressbook-home-set xmlns:C="urn:ietf:params:xml:ns:carddav"/>' +
    '</D:prop>' +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
      Req.Position := 0;
      try
        FHTTP.DAVPropFind(FURL, Req, Resp);
      except
        on E: EIdConnClosedGracefully do
          Exit;
        else
          raise;
      end;
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
      XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
      XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
      XMLDoc.Active := True;
      with XMLDoc.DocumentElement do
        if ChildNodes.FindNode('response') <> nil then
          with ChildNodes['response'] do
            if ChildNodes.FindNode('propstat') <> nil then
              with ChildNodes['propstat'] do
                if ChildNodes.FindNode('prop') <> nil then
                  with ChildNodes['prop'] do
                    if ChildNodes.FindNode('addressbook-home-set', 'urn:ietf:params:xml:ns:carddav') <> nil then
                      with ChildNodes.FindNode('addressbook-home-set', 'urn:ietf:params:xml:ns:carddav') do
                        if ChildNodes.FindNode('href', 'DAV:') <> nil then
                          with ChildNodes.FindNode('href', 'DAV:') do
                            Result := ExtractServerWProtocolName(FBaseURL) + NodeValue;
      Result := StringReplace(Result, ' ', '%20', [rfReplaceAll]);
    except
      Result := '';
      raise;
    end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDAddressbook.GetAddressbooks: TStringList;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  I: Integer;
  FURL, ABURL, CTag: AnsiString;
  DName: WideString;
begin
  Result := FAddressbooks;
  FURL := GetAddressbookHomeSet;
  if FURL = '' then
    Exit;
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8" ?>' +
    '<D:propfind xmlns:D="DAV:" xmlns:cs="http://calendarserver.org/ns/">' +
    ' <D:prop>' +
    '  <D:displayname/>' +
    '  <cs:getctag/>' + #13#10 +
    '  <D:resourcetype/>' +
    ' </D:prop>' +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FURL, Req, Resp, '1');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := XMLFilter(Resp.DataString);
{$ELSE}
    XMLDoc.XML.Text := XMLFilter(UTF8ToWideString(Resp.DataString));
{$ENDIF}
    XMLDoc.Active := True;
    FAddressbooks.Clear;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
          begin
            CTag := '';
            if ChildNodes.FindNode('href', 'DAV:') <> nil then
              ABURL := ExtractServerWProtocolName(FBaseURL) + ChildNodes.FindNode('href', 'DAV:').NodeValue;
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getctag',
                    'http://calendarserver.org/ns/') <> nil then
                      CTag := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getctag',
                        'http://calendarserver.org/ns/').Text;
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
              if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                'DAV:') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                'DAV:').ChildNodes.FindNode('addressbook', 'urn:ietf:params:xml:ns:carddav') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('displayname',
                    'DAV:') <> nil then
                    begin
                      DName := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('displayname',
                        'DAV:').NodeValue;
                      FAddressbooks.Add(DName + '=' + ABURL);
                      FCTags.Add(CTag);
                    end;
          end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDAddressbook.GetContact(Index: Integer): TCDContact;
begin
  Result := TCDContact(FContacts[Index]);
end;

procedure TCDAddressbook.GetiCloudAddressbookURL;
var
  Principal: AnsiString;
begin
  if (Trim(UserName) = '') or (Trim(Password) = '') then
    raise Exception.Create('Credentials not set');
  FHTTP.HTTPOptions := [hoForceEncodeParams];
  FHTTP.Request.BasicAuthentication := True;
  FBaseURL := 'https://contacts.icloud.com/';
  Principal := GetUserPrincipal;
  Principal := Copy(Principal, Pos('.com/', Principal) + 5, MaxInt);
  Principal := Copy(Principal, 1, Pos('/', Principal) - 1);
  FBaseURL := 'https://p02-contacts.icloud.com/' + Principal + '/carddavhome/card/';
end;

{ TIdWebDAV }

procedure TIdWebDAV.DoRequest(const AMethod: TIdHTTPMethod; AURL: string;
  ASource, AResponseContent: TStream; AIgnoreReplies: array of SmallInt);
var
  LResponseLocation: Integer;
  SavePos: Int64;
begin
  //reset any counters
  FRedirectCount := 0;
  FAuthRetries := 0;
  FAuthProxyRetries := 0;
  IOHandler.InputBuffer.Clear;

  if Assigned(AResponseContent) then
  begin
    LResponseLocation := AResponseContent.Position;
  end
  else
  begin
    LResponseLocation := 0; // Just to avoid the warning message
  end;

  Request.URL := AURL;
  Request.Method := AMethod;
  Request.Source := ASource;
  Response.ContentStream := AResponseContent;

  try
    repeat

      PrepareRequest(Request);

      if IOHandler is TIdSSLIOHandlerSocketBase then
      begin
        TIdSSLIOHandlerSocketBase(IOHandler).URIToCheck := FURI.URI;
      end;

      if Request.Source <> nil then
        SavePos := Request.Source.Position
      else
        SavePos := 0;

      ConnectToHost(Request, Response);

      // for WebDAV (some old Indy 10) by Dmitrij Osipov
      if (Request.Source <> nil) and (PosInStrArray(Request.Method, [Id_HTTPMethodPropFind, Id_HTTPMethodReport], False) > -1) then
        if Request.Source.Position = SavePos then
        begin
          IOHandler.Write(Request.Source, 0, False);
        end;

      // Workaround for servers wich respond with 100 Continue on GET and HEAD
      // This workaround is just for temporary use until we have final HTTP 1.1
      // realisation. HTTP 1.1 is ongoing because of all the buggy and conflicting servers.
      repeat
        Response.ResponseText := IOHandler.ReadLn;
        FHTTPProto.RetrieveHeaders(MaxHeaderLines);
        ProcessCookies(Request, Response);
      until Response.ResponseCode <> 100;

      case FHTTPProto.ProcessResponse(AIgnoreReplies) of
        wnAuthRequest:
          begin
            Request.URL := AURL;
          end;
        wnReadAndGo:
          begin
{$IFNDEF XE2ANDLATER}
            ReadResult(Response);
{$ELSE}
            ReadResult(Request, Response);
{$ENDIF}
            if Assigned(AResponseContent) then
            begin
              AResponseContent.Position := LResponseLocation;
              AResponseContent.Size := LResponseLocation;
            end;
            FAuthRetries := 0;
            FAuthProxyRetries := 0;
          end;
        wnGoToURL:
          begin
            if Assigned(AResponseContent) then
            begin
              AResponseContent.Position := LResponseLocation;
              AResponseContent.Size := LResponseLocation;
            end;
            FAuthRetries := 0;
            FAuthProxyRetries := 0;
          end;
        wnJustExit:
          begin
            Break;
          end;
        wnDontKnow:
          begin
            raise EIdException.Create(RSHTTPNotAcceptable);
          end;
      end;
      if Request.Source <> nil then
        Request.Source.Position := SavePos;
    until False;
  finally
    if not Response.KeepAlive then
    begin
      Disconnect;
    end;
  end;
end;

{ TCDContact }

function TCDContact.AddressesCount: Integer;
begin
  Result := FAddresses.Count;
end;

function TCDContact.AddressLabelsCount: Integer;
begin
  Result := FAddressLabels.Count;
end;

procedure TCDContact.ClearAddresses;
begin
  FAddresses.Clear;
end;

procedure TCDContact.ClearAddressLabels;
begin
  FAddressLabels.Clear;
end;

procedure TCDContact.ClearEMailAddresses;
begin
  FEMailAddresses.Clear;
end;

procedure TCDContact.ClearIMs;
begin
  FIMs.Clear;
end;

procedure TCDContact.ClearOtherFields;
begin
  FOtherFields.Clear;
end;

procedure TCDContact.ClearPhoneNumbers;
begin
  FPhoneNumbers.Clear;
end;

procedure TCDContact.ClearURLs;
begin
  FURLs.Clear;
end;

constructor TCDContact.Create(Addressbook: TCDAddressbook);
begin
  inherited Create;
  FAddressbook := Addressbook;
  FVCardFields := TObjectList.Create(True);
  FOtherFields := TObjectList.Create(True);
  FAddresses := TObjectList.Create(True);
  FAddressLabels := TObjectList.Create(True);
  FPhoneNumbers := TObjectList.Create(True);
  FEMailAddresses := TObjectList.Create(True);
  FURLs := TObjectList.Create(True);
  FIMs := TObjectList.Create(True);
  Randomize;
  FUID := DateTimeTovCardDate(Now, True) + IntToStr(Random(1000000));
  SetvCard('BEGIN:VCARD'#13#10 +
    'VERSION:3.0'#13#10 +
    'UID:' + FUID + #13#10 +
    'FN:'#13#10 +
    'N:;;;;'#13#10 +
    'END:VCARD'#13#10);
  FStored := False;
end;

procedure TCDContact.SetEmbeddedObjectField(const FieldName: String;
  const Obj: TVCardEmbeddedObject);
var
  Field: TVCardField;
  TStr: String;
begin
  if Obj = nil then
    DeleteFieldsWithName(FieldName)
  else
  begin
    Field := FieldWithName(FieldName);
    if Trim(Obj.FObjectURL) <> '' then
    begin
      Field.Attributes.Values['VALUE'] := 'uri';
      Field.Values.Text := Obj.FObjectURL;
    end
    else
    if (LowerCase(Obj.FEncoding) = 'b') or (LowerCase(Obj.FEncoding) = 'base64') then
    begin
      Field.Attributes.Values['ENCODING'] := 'b';
      if Trim(Obj.FObjectType) <> '' then
        Field.Attributes.Values['TYPE'] := Obj.FObjectType;
        Obj.FDataStream.Position := 0;
      Field.Values.DelimitedText := EncodeBase64(Obj.FDataStream);
    end
    else
    begin
      if Trim(Obj.FObjectType) <> '' then
        Field.Attributes.Values['TYPE'] := Obj.FObjectType;
      Obj.FDataStream.Position := 0;
      SetLength(TStr, Obj.FDataStream.Size);
      Obj.DataStream.Read(PChar(TStr)^, Obj.DataStream.Size);
      Field.Values.DelimitedText := BSEscape(TStr);
    end;
  end;
end;

procedure TCDContact.SetKey(const Value: TVCardEmbeddedObject);
begin
  FKey.Free;
  FKey := Value;
end;

procedure TCDContact.SetLogo(const Value: TVCardEmbeddedObject);
begin
  FLogo.Free;
  FLogo := Value;
end;

procedure TCDContact.SetOtherValue(Index: String; const Value: String);
var
  tmpField: TVCardField;
begin
  tmpField := GetOtherFieldByName(Index);
  if tmpField = nil then
    tmpField := NewOtherField(Index + ':');
  tmpField.Values.DelimitedText := Value;
end;

procedure TCDContact.SetPhoto(const Value: TVCardEmbeddedObject);
begin
  FPhoto.Free;
  FPhoto := Value;
end;

procedure TCDContact.SetSimpleFieldValue(const FieldName, Value: String; ToDelimited: Boolean = False);
begin
  if Trim(Value) <> '' then
  begin
    if ToDelimited then
      FieldWithName(FieldName).Values.DelimitedText := Value
    else
      FieldWithName(FieldName).Values.Text := Value;
  end
  else
    DeleteFieldsWithName(FieldName);
end;

procedure TCDContact.SetSound(const Value: TVCardEmbeddedObject);
begin
  FSound.Free;
  FSound := Value;
end;

procedure TCDContact.SetvCard(const Value: String);
var
  I, J: Integer;
  S: String;
  StrS: TVCStringList;
  Field: TVCardField;
begin
  FVCardFields.Clear;
  FUID := '';
  FFirstName := '';
  FLastName := '';
  FOtherNames := '';
  FPrefix := '';
  FSuffix := '';
  FFormattedName := '';
  FSortString := '';
  FNickNames := '';
  FBirthDay := 0;
  FNotes := '';
  FCategories := '';
  FEMailProgram := '';
  FClassification := '';
  FProductID := '';
  FVCardVersion := '';
  FDivisions := '';
  FRole := '';
  FTitle := '';
  FOrganization := '';
  FTimeZoneStr := '';
  FLatitude := '';
  FLongitude := '';
  FLastRevised := 0;
  SetPhoto(nil);
  SetLogo(nil);
  SetSound(nil);
  SetKey(nil);
  FAddresses.Clear;
  FAddressLabels.Clear;
  FPhoneNumbers.Clear;
  FEMailAddresses.Clear;
  FURLs.Clear;
  FIMs.Clear;
  FOtherFields.Clear;
  StrS := TVCStringList.Create;
  with StrS do
  try
    Text := Value;
    // remove empty lines
    for I := Count - 1 downto 1 do
    begin
      S := Strings[I];
      if Trim(S) = '' then
        Delete(I);
    end;
    // unfolding fields
    for I := Count - 1 downto 1 do
    begin
      S := Strings[I];
      if S[1] = ' ' then
      begin
        Strings[I - 1] := Strings[I - 1] + Copy(S, 2, MaxInt);
        Delete(I);
      end;
    end;
    // parsing, adding fields to list
    // and reading values from fields
    for I := 0 to Count - 1 do
    begin
      Field := TVCardField.Create(Strings[I]);
      with Field do
        if FieldName = 'VERSION' then
          FVCardVersion := Values[0]
        else
        if FieldName = 'REV' then
          FLastRevised := vCardDateToDateTime(Values[0])
        else
        if FieldName = 'UID' then
          FUID := Values.DelimitedText
        else
        if FieldName = 'PRODID' then
          FProductID := Values.DelimitedText
        else
        if FieldName = 'CLASS' then
          FClassification := Values.DelimitedText
        else
        if FieldName = 'BDAY' then
          FBirthDay := vCardDateToDateTime(Values[0])
        else
        if FieldName = 'MAILER' then
          FEMailProgram := Values.DelimitedText
        else
        if FieldName = 'CATEGORIES' then
          FCategories := BSUnescape(Values[0])
        else
        if FieldName = 'NOTE' then
          FNotes := BSUnescape(Values.DelimitedText)
        else
        if FieldName = 'FN' then
          FFormattedName := BSUnescape(Values.DelimitedText)
        else
        if FieldName = 'NICKNAME' then
          FNickNames := BSUnescape(Values.DelimitedText)
        else
        if FieldName = 'TITLE' then
          FTitle := BSUnescape(Values.DelimitedText)
        else
        if FieldName = 'ROLE' then
          FRole := BSUnescape(Values.DelimitedText)
        else
        if FieldName = 'N' then
        begin
          FLastName := BSUnescape(Values[0]);
          if Values.Count > 1 then
            FFirstName := BSUnescape(Values[1]);
          if Values.Count > 2 then
            FOtherNames := BSUnescape(StringReplace(Values[2], ' ', ',', [rfReplaceAll]));
          if Values.Count > 3 then
            FPrefix := BSUnescape(Values[3]);
          if Values.Count > 4 then
            FSuffix := BSUnescape(Values[4]);
        end
        else
        if FieldName = 'ORG' then
        begin
          FOrganization := BSUnescape(Values[0]);
          if Values.Count > 1 then
            FDivisions := BSUnescape(Values[1]);
          for J := 2 to Values.Count - 1 do
            FDivisions := BSUnescape(FDivisions + ',' + Values[J]);
        end
        else
        if FieldName = 'GEO' then
        begin
          FLatitude := Values[0];
          FLongitude := Values[1];
        end
        else
        if FieldName = 'TZ' then
          FTimeZoneStr := Values[0]
        else
        if FieldName = 'PHOTO' then
          SetPhoto(ParseEmbeddedObject(Field))
        else
        if FieldName = 'LOGO' then
          SetLogo(ParseEmbeddedObject(Field))
        else
        if FieldName = 'SOUND' then
          SetSound(ParseEmbeddedObject(Field))
        else
        if FieldName = 'KEY' then
          SetKey(ParseEmbeddedObject(Field))
        else
        if FieldName = 'ADR' then
          ParseAddress(Field)
        else
        if FieldName = 'LABEL' then
          ParseAddressLabel(Field)
        else
        if FieldName = 'TEL' then
          ParsePhoneNumber(Field)
        else
        if FieldName = 'EMAIL' then
          ParseEMailAddress(Field)
        else
        if FieldName = 'URL' then
          ParseURL(Field)
        else
        if FieldName = 'IMPP' then
          ParseIM(Field)
        else
        if FieldName = 'SORT-STRING' then
          FSortString := BSUnescape(Values.DelimitedText)
        else
        if (FieldName <> 'BEGIN') and (FieldName <> 'END') then
        begin
          FOtherFields.Add(Field);
          Continue;
        end;
        FVCardFields.Add(Field);
    end;
  finally
    FStored := True;
    Free;
  end;
end;

procedure TCDContact.Store(Batch: Boolean);
var
  S: TStringStream;
  URL: AnsiString;
begin
  if Batch then
  begin
    FToStore := True;
    FToDelete := False;
  end
  else
  with FAddressbook do
  begin
    FHTTP.Disconnect;
    if FHRef <> '' then
      URL := FBaseURL + FileNameOnly(FHRef)
    else
    if Trim(FUID) <> '' then
      URL := FBaseURL + FUID + '.vcf'
    else
      URL := FBaseURL + DateTimeTovCardDate(Now, True) + IntToStr(Random(1000000)) + '.vcf';
    S := TStringStream.Create(UTF8Encode(vCard));
    try
      if not FStored then
        FHTTP.Request.CustomHeaders.Add('If-None-Match:*');
      FHTTP.Request.ContentType := FUsedMIMEType +'; charset=UTF-8';
      FHTTP.Put(URL, S);
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
      S.Size := 0;
      FHRef := URL;
      if FHTTP.Response.RawHeaders.Values['ETag'] <> '' then
        FETag := FHTTP.Response.RawHeaders.Values['ETag']
      else
      begin
        FHTTP.Request.ContentType := '';
        if FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match') <> -1 then
          FHTTP.Request.CustomHeaders.Delete(FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match'));
        FHTTP.Get(URL, S);
        FETag := FHTTP.Response.RawHeaders.Values['ETag'];
        FHTTP.Request.ContentType := FUsedMIMEType + '; charset=UTF-8';
        SetvCard(S.DataString);
      end;
    finally
      if FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match') <> -1 then
        FHTTP.Request.CustomHeaders.Delete(FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match'));
      S.Free;
    end;
  end;
end;

function TCDContact.URLsCount: Integer;
begin
  Result := FURLs.Count;
end;

procedure TCDContact.DeleteAddress(Index: Integer);
begin
  FAddresses.Delete(Index);
end;

procedure TCDContact.Delete(Batch: Boolean);
begin
  if Batch then
  begin
    FToStore := False;
    FToDelete := True;
  end
  else
  begin
    if FHRef <> '' then
    begin
      FAddressbook.FHTTP.Disconnect;
      FAddressbook.FHTTP.DAVDelete(FAddressbook.FBaseURL + FileNameOnly(FHRef), '');
    end;
    FAddressbook.FContacts.Remove(Self);
  end;
end;

procedure TCDContact.DeleteAddress(Address: TVCardAddress);
begin
  FAddresses.Remove(Address);
end;

procedure TCDContact.DeleteAddressLabel(AddressLabel: TVCardAddressLabel);
begin
  FAddressLabels.Remove(AddressLabel);
end;

procedure TCDContact.DeleteEMailAddress(EMailAddress: TVCardEMailAddress);
begin
  FEMailAddresses.Remove(EMailAddress);
end;

procedure TCDContact.DeleteEMailAddress(Index: Integer);
begin
  FEMailAddresses.Delete(Index);
end;

procedure TCDContact.DeleteAddressLabel(Index: Integer);
begin
  FAddressLabels.Delete(Index);
end;

procedure TCDContact.DeleteFieldsWithName(const FieldName: String);
var
  I: Integer;
begin
  for I := FVCardFields.Count - 1 downto 0 do
    if TVCardField(FVCardFields[I]).FieldName = FieldName then
      FVCardFields.Delete(I);
end;

procedure TCDContact.DeleteIM(IM: TVCardIM);
begin
  FIMs.Remove(IM);
end;

procedure TCDContact.DeleteIM(Index: Integer);
begin
  FIMs.Delete(Index);
end;

procedure TCDContact.DeleteOtherField(OtherField: TVCardField);
begin
  FOtherFields.Remove(OtherField);
end;

procedure TCDContact.DeleteOtherField(Index: Integer);
begin
  FOtherFields.Delete(Index);
end;

procedure TCDContact.DeletePhoneNumber(PhoneNumber: TVCardPhoneNumber);
begin
  FPhoneNumbers.Remove(PhoneNumber);
end;

procedure TCDContact.DeleteURL(Index: Integer);
begin
  FURLs.Delete(Index);
end;

procedure TCDContact.DeleteURL(URL: TVCardURL);
begin
  FURLs.Remove(URL);
end;

procedure TCDContact.DeletePhoneNumber(Index: Integer);
begin
  FPhoneNumbers.Delete(Index);
end;

destructor TCDContact.Destroy;
begin
  FPhoto.Free;
  FSound.Free;
  FLogo.Free;
  FKey.Free;
  FIMs.Free;
  FURLs.Free;
  FEMailAddresses.Free;
  FPhoneNumbers.Free;
  FAddressLabels.Free;
  FAddresses.Free;
  FOtherFields.Free;
  FVCardFields.Free;
  inherited;
end;

function TCDContact.EMailAddressesCount: Integer;
begin
  Result := FEMailAddresses.Count;
end;

function TCDContact.FieldWithName(const FieldName: String): TVCardField;
var
  I: Integer;
begin
  for I := 0 to FVCardFields.Count - 1 do
    if TVCardField(FVCardFields[I]).FieldName = FieldName then
    begin
      Result := TVCardField(FVCardFields[I]);
      Exit;
    end;
  Result := TVCardField.Create(FieldName + ':');
  FVCardFields.Insert(FVCardFields.Count - 1, Result);
end;

function TCDContact.FieldWithPrefix(const Prefix: String): TVCardField;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FVCardFields.Count - 1 do
    if TVCardField(FVCardFields[I]).FieldPrefix = Prefix then
    begin
      Result := TVCardField(FVCardFields[I]);
      Exit;
    end;
  for I := 0 to FOtherFields.Count - 1 do
    if TVCardField(FOtherFields[I]).FieldPrefix = Prefix then
    begin
      Result := TVCardField(FOtherFields[I]);
      Exit;
    end;
end;

function TCDContact.GenerateAddressLabel(
  const AddressLabel: TVCardAddressLabel): TVCardField;
const
  AttribsArray: array[tatHome..tatPreferred] of String = ('HOME', 'DOM', 'INTL', 'POSTAL', 'PARCEL', 'WORK', 'PREF');
var
  AI: TVCardAddressAttribute;
  Attribs: TVCStringList;
begin
  Result := TVCardField.Create('LABEL');
  Result.FFieldPrefix := AddressLabel.FFieldPrefix;
  Attribs := TVCStringList.Create;
  try
    for AI := tatHome to tatPreferred do
      if AI in AddressLabel.FAddressAttributes then
        Attribs.Add(AttribsArray[AI]);
    if Attribs.Count > 0 then
      Result.Attributes.Values['TYPE'] := Attribs.CommaText;
  finally
    Attribs.Free;
  end;
  Result.Values.DelimitedText := BSEscape(AddressLabel.FMailingLabel);
end;

function TCDContact.GenerateEMailAddress(
  const EMailAddress: TVCardEMailAddress): TVCardField;

const AttribsArray: array [ematAOL..ematOther] of string = (
  'AOL', // America On-Line
  'APPLELINK',   // AppleLink
  'ATTMAIL', // AT&T Mail
  'CIS', // CompuServe Information Service
  'EWORLD', // eWorld
  'INTERNET', // Internet SMTP
  'IBMMAIL', // IBM Mail
  'MCIMAIL', // MCI Mail
  'POWERSHARE', // PowerShare
  'PRODIGY', // Prodigy information service
  'TLX', // Telex number
  'X400', // X.400 service
  'HOME', // Home
  'WORK', // Work
  'OTHER' // Other
);

var
  I: TVCardEMailType;
begin
  Result := TVCardField.Create('EMAIL');
  Result.FFieldPrefix := EMailAddress.FFieldPrefix;
  for I := ematAOL to ematOther do
    if I in EMailAddress.EMailTypes then
    begin
      if Result.Attributes.Values['TYPE'] <> '' then
        Result.Attributes.Values['TYPE'] := Result.Attributes.Values['TYPE'] + ',';
      Result.Attributes.Values['TYPE'] := Result.Attributes.Values['TYPE'] + Lowercase(AttribsArray[I]);
    end;
  if EMailAddress.FPreferred then
    Result.Attributes.Values['TYPE'] := Result.Attributes.Values['TYPE'] + ',pref';
  Result.Values.DelimitedText := EMailAddress.FAddress;
end;

function TCDContact.GenerateIM(const IM: TVCardIM): TVCardField;

const
  AttribsArray1: array [imtPersonal..imtMobile] of string = (
    'PERSONAL',
    'BUSINESS',
    'HOME',
    'WORK',
    'MOBILE'
  );

  AttribsArray2: array [imstJabber..imstOwnCloud] of string = (
    'jabber',
    'sip',
    'aim',
    'msn',
    'twitter',
    'googletalk',
    'facebook',
    'xmpp',
    'icq',
    'yahoo',
    'skype',
    'qq',
    'gadugadu',
    'owncloud-handle'
  );

  AttribsArray3: array [imstJabber..imstOwnCloud] of string = (
    'xmpp',
    'sip',
    'aim',
    'msn',
    'twitter',
    'xmpp',
    'xmpp',
    'xmpp',
    'icq',
    'ymsgr',
    'skype',
    'x-apple',
    'x-apple',
    'x-owncloud-handle'
  );

begin
  Result := TVCardField.Create('IMPP');
  Result.FFieldPrefix := IM.FFieldPrefix;
  if IM.IMType <> imtNone then
  begin
    Result.Attributes.Values['TYPE'] := Lowercase(AttribsArray1[IM.FIMType]);
    if IM.FPreferred then
      Result.Attributes.Values['TYPE'] := Result.Attributes.Values['TYPE'] + ',PREF';
  end
  else
  if IM.FPreferred then
    Result.Attributes.Values['TYPE'] := 'PREF';
  if IM.FOCIMServiceType <> imstNone then
  begin
    Result.Attributes.Values['X-SERVICE-TYPE'] := AttribsArray2[IM.FOCIMServiceType];
    Result.Values.DelimitedText := AttribsArray3[IM.FOCIMServiceType] + ':' + IM.FValue;
  end
  else
    Result.Values.DelimitedText := IM.FProtocol + ':' + IM.FValue;
end;

function TCDContact.GeneratePhoneNumber(
  const PhoneNumber: TVCardPhoneNumber): TVCardField;
const
   AttribsArray: array [tpaHome..tpaiPhone] of string = ('HOME', 'MSG', 'WORK', 'PREF', 'VOICE', 'FAX',
     'CELL', 'VIDEO', 'BBS', 'MODEM', 'CAR', 'ISDN', 'PCS', 'TEXT', 'PAGER', 'IPHONE');
var
  AI: TVCardPhoneAttribute;
  Attribs: TVCStringList;
begin
  Result := TVCardField.Create('TEL');
  Result.FFieldPrefix := PhoneNumber.FFieldPrefix;
  Attribs := TVCStringList.Create;
  try
    for AI := tpaHome to tpaiPhone do
      if AI in PhoneNumber.FPhoneAttributes then
        Attribs.Add(Lowercase(AttribsArray[AI]));
    if Attribs.Count > 0 then
      Result.Attributes.Values['TYPE'] := Attribs.CommaText;
  finally
    Attribs.Free;
  end;
  Result.Values.DelimitedText := PhoneNumber.FNumber;
end;

function TCDContact.GenerateURL(const URL: TVCardURL): TVCardField;

const AttribsArray: array [utWork..utOther] of string = (
  'WORK',
  'HOME',
  'INTERNET',
  'OTHER'
);

begin
  Result := TVCardField.Create('URL');
  Result.FFieldPrefix := URL.FFieldPrefix;
  Result.Attributes.Values['TYPE'] := Lowercase(AttribsArray[URL.FURLType]);
  if URL.FPreferred then
    Result.Attributes.Values['TYPE'] := Result.Attributes.Values['TYPE'] + ',PREF';
  Result.Values.DelimitedText := URL.FURL;
end;

function TCDContact.GenerateAddress(const Address: TVCardAddress): TVCardField;
const
  AttribsArray: array[tatHome..tatPreferred] of String = ('HOME', 'DOM', 'INTL', 'POSTAL', 'PARCEL', 'WORK', 'PREF');
var
  AI: TVCardAddressAttribute;
  Attribs: TVCStringList;
begin
  Result := TVCardField.Create('ADR');
  Result.FFieldPrefix := Address.FFieldPrefix;
  Attribs := TVCStringList.Create;
  try
    for AI := tatHome to tatPreferred do
      if AI in Address.FAddressAttributes then
        Attribs.Add(Lowercase(AttribsArray[AI]));
    if Attribs.Count > 0 then
      Result.Attributes.Values['TYPE'] := Attribs.CommaText;
  finally
    Attribs.Free;
  end;
  Result.Values.Clear;
  Result.Values.Add(Address.FPOBox);
  Result.Values.Add(Address.FExtendedAddress);
  Result.Values.Add(Address.FStreetAddress);
  Result.Values.Add(Address.FCity);
  Result.Values.Add(Address.FRegion);
  Result.Values.Add(Address.FPostalCode);
  Result.Values.Add(Address.FCountry);
end;

function TCDContact.GetAddress(Index: Integer): TVCardAddress;
begin
  Result := TVCardAddress(FAddresses[Index]);
end;

function TCDContact.GetAddressLabel(Index: Integer): TVCardAddressLabel;
begin
  Result := TVCardAddressLabel(FAddressLabels[Index]);
end;

function TCDContact.GetEMailAddress(Index: Integer): TVCardEMailAddress;
begin
  Result := TVCardEMailAddress(FEMailAddresses[Index]);
end;

function TCDContact.GetIM(Index: Integer): TVCardIM;
begin
  Result := TVCardIM(FIMs[Index]);
end;

function TCDContact.GetLastModified: TDateTime;
begin
  Result := FLastModified;
  if Result = 0 then
    Result := FLastRevised;
end;

function TCDContact.GetLastModifiedLocal: TDateTime;
begin
  Result := UTCDateTimeToLocal(GetLastModified);
end;

function TCDContact.GetOtherFieldByName(const ID: String): TVCardField;
var
  Counter: Integer;
begin
  Result := nil;
  for Counter := 0 to OtherFieldsCount - 1 do
  begin
    if CompareText(OtherFields[Counter].FieldName, ID) = 0 then
    begin
      Result := OtherFields[Counter];
      Break;
    end;
  end;
end;

function TCDContact.GetOtherField(Index: Integer): TVCardField;
begin
  Result := TVCardField(FOtherFields[Index]);
end;

function TCDContact.GetPhoneNumber(Index: Integer): TVCardPhoneNumber;
begin
  Result := TVCardPhoneNumber(FPhoneNumbers[Index]);
end;

function TCDContact.GetURL(Index: Integer): TVCardURL;
begin
  Result := TVCardURL(FURLs[Index]);
end;

function TCDContact.GetvCard: String;
var
  I: Integer;
  Field: TVCardField;
  TStr: String;
begin
  SetSimpleFieldValue('UID', FUID, True);
  Field := FieldWithName('FN');
  Field.Values.DelimitedText := FFormattedName;
  Field := FieldWithName('N');
  if OtherValues['X-ADDRESSBOOKSERVER-KIND'] = 'group' then
    Field.Values.DelimitedText := FFormattedName
  else
  begin
    Field.Values.Clear;
    Field.Values.Add(BSEscape(FLastName));
    Field.Values.Add(BSEscape(FFirstName));
    Field.Values.Add(BSEscape(StringReplace(FOtherNames, ',', ' ', [rfReplaceAll])));
    Field.Values.Add(BSEscape(FPrefix));
    Field.Values.Add(BSEscape(FSuffix));
  end;
  SetSimpleFieldValue('SORT-STRING', BSEscape(FSortString), True);
  SetSimpleFieldValue('NICKNAME', BSEscape(FNickNames), True);
  SetSimpleFieldValue('VERSION', FVCardVersion);
  SetSimpleFieldValue('PRODID', FProductID, True);
  SetSimpleFieldValue('CLASS', FClassification, True);
  if FBirthDay = 0 then
    DeleteFieldsWithName('BDAY')
  else
  begin
    Field := FieldWithName('BDAY');
    Field.Attributes.Values['VALUE'] := 'DATE';
    Field.Values.Text := DateTimeTovCardDate(Trunc(FBirthDay));
  end;
  SetSimpleFieldValue('MAILER', FEMailProgram, True);
  SetSimpleFieldValue('CATEGORIES', FCategories);
  if Trim(FNotes) = '' then
    DeleteFieldsWithName('NOTE')
  else
  begin
    Field := FieldWithName('NOTE');
    Field.Values.DelimitedText := BSEscape(FNotes);
  end;
  if Trim(FOrganization) = '' then
    DeleteFieldsWithName('ORG')
  else
  begin
    Field := FieldWithName('ORG');
    try
      Field.Values.Delimiter := ',';
      Field.Values.DelimitedText := FDivisions;
    finally
      Field.Values.Delimiter := ';';
      Field.Values.Insert(0, FOrganization);
    end;
  end;
  SetSimpleFieldValue('TITLE', BSEscape(FTitle), True);
  SetSimpleFieldValue('ROLE', BSEscape(FRole), True);
  SetSimpleFieldValue('TZ', FTimeZoneStr);
  if (Trim(FLatitude) = '') or (Trim(FLongitude) = '') then
    DeleteFieldsWithName('GEO')
  else
  begin
    Field := FieldWithName('GEO');
    Field.Values.Clear;
    Field.Values.Add(FLatitude);
    Field.Values.Add(FLongitude);
  end;
  SetEmbeddedObjectField('PHOTO', FPhoto);
  SetEmbeddedObjectField('LOGO', FLogo);
  SetEmbeddedObjectField('SOUND', FSound);
  SetEmbeddedObjectField('KEY', FKey);
  DeleteFieldsWithName('ADR');
  for I := 0 to FAddresses.Count - 1 do
    FVCardFields.Insert(FVCardFields.Count - 1, GenerateAddress(TVCardAddress(FAddresses[I])));
  DeleteFieldsWithName('LABEL');
  for I := 0 to FAddressLabels.Count - 1 do
    FVCardFields.Insert(FVCardFields.Count - 1, GenerateAddressLabel(TVCardAddressLabel(FAddressLabels[I])));
  DeleteFieldsWithName('TEL');
  for I := 0 to FPhoneNumbers.Count - 1 do
    FVCardFields.Insert(FVCardFields.Count - 1, GeneratePhoneNumber(TVCardPhoneNumber(FPhoneNumbers[I])));
  DeleteFieldsWithName('EMAIL');
  for I := 0 to FEMailAddresses.Count - 1 do
    FVCardFields.Insert(FVCardFields.Count - 1, GenerateEMailAddress(TVCardEMailAddress(FEMailAddresses[I])));
  DeleteFieldsWithName('URL');
  for I := 0 to FURLs.Count - 1 do
    FVCardFields.Insert(FVCardFields.Count - 1, GenerateURL(TVCardURL(FURLs[I])));
  DeleteFieldsWithName('IMPP');
  for I := 0 to FIMs.Count - 1 do
    FVCardFields.Insert(FVCardFields.Count - 1, GenerateIM(TVCardIM(FIMs[I])));
  Result := '';
  for I := 0 to FVCardFields.Count - 2 do
  begin
    TStr := TVCardField(FVCardFields[I]).GetvText;
    while Length(TStr) > 75 do
    begin
      Result := Result + Copy(TStr, 1, 75) + #13#10;
      TStr := ' ' + Copy(TStr, 76, MaxInt);
    end;
    if Length(TStr) <> 0 then
      Result := Result + TStr + #13#10;
  end;
  for I := 0 to FOtherFields.Count - 1 do
  begin
    TStr := TVCardField(FOtherFields[I]).GetvText;
    while Length(TStr) > 75 do
    begin
      Result := Result + Copy(TStr, 1, 75) + #13#10;
      TStr := ' ' + Copy(TStr, 76, MaxInt);
    end;
    if Length(TStr) <> 0 then
      Result := Result + TStr + #13#10;
  end;
  Result := Result + TVCardField(FVCardFields[FVCardFields.Count - 1]).GetvText + #13#10;
end;

function TCDContact.IMsCount: Integer;
begin
  Result := FIMs.Count;
end;

function TCDContact.NewAddress: TVCardAddress;
begin
  Result := TVCardAddress.Create;
  FAddresses.Add(Result);
end;

function TCDContact.NewAddressLabel: TVCardAddressLabel;
begin
  Result := TVCardAddressLabel.Create;
  FAddressLabels.Add(Result);
end;

function TCDContact.NewEMailAddress: TVCardEMailAddress;
begin
  Result := TVCardEMailAddress.Create;
  Result.FEMailTypes := [ematInternet];
  FEMailAddresses.Add(Result);
end;

function TCDContact.NewFieldPrefix: String;
var
  I: Integer;
begin
  I := 1;
  repeat
    Result := 'item' + IntToStr(I);
    if FieldWithPrefix(Result) = nil then
      Exit;
    Inc(I);
  until false;
end;

function TCDContact.NewIM: TVCardIM;
begin
  Result := TVCardIM.Create;
  Result.FIMType := imtNone;
  Result.FOCIMServiceType := imstNone;
  Result.Protocol := '';
  FIMs.Add(Result);
end;

function TCDContact.NewOtherField(const vText: String): TVCardField;
begin
  Result := TVCardField.Create(vText);
  FOtherFields.Add(Result);
end;

function TCDContact.NewPhoneNumber: TVCardPhoneNumber;
begin
  Result := TVCardPhoneNumber.Create;
  FPhoneNumbers.Add(Result);
end;

function TCDContact.NewURL: TVCardURL;
begin
  Result := TVCardURL.Create;
  Result.FURLType := utOther;
  FURLs.Add(Result);
end;

function TCDContact.OtherFieldsCount: Integer;
begin
  Result := FOtherFields.Count;
end;

function TCDContact.ParseAddress(const VCardField: TVCardField): TVCardAddress;
const
  AttribsArray: array[0..6] of String = ('HOME', 'DOM', 'INTL', 'POSTAL', 'PARCEL', 'WORK', 'PREF');
var
  Attribs: TVCStringList;
  I: Integer;
begin
  Result := NewAddress;
  Result.FFieldPrefix := VCardField.FFieldPrefix;
  if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
  begin
    Attribs := TVCStringList.Create;
    Attribs.CommaText := VCardField.Attributes.Values['TYPE'];
    try
      for I := 0 to Attribs.Count - 1 do begin
        case PosInStrArray(Attribs[I], AttribsArray, False) of
          0: Include(Result.FAddressAttributes, tatHome);
          1: Include(Result.FAddressAttributes, tatDomestic);
          2: Include(Result.FAddressAttributes, tatInternational);
          3: Include(Result.FAddressAttributes, tatPostal);
          4: Include(Result.FAddressAttributes, tatParcel);
          5: Include(Result.FAddressAttributes, tatWork);
          6: Include(Result.FAddressAttributes, tatPreferred);
        end;
      end;
    finally
      Attribs.Free;
    end;
  end
  else
    Result.FAddressAttributes := [tatHome];
  Result.POBox := VCardField.Values[0];
  Result.ExtendedAddress := VCardField.Values[1];
  Result.StreetAddress := VCardField.Values[2];
  Result.City := VCardField.Values[3];
  Result.Region := VCardField.Values[4];
  Result.PostalCode := VCardField.Values[5];
  Result.Country := VCardField.Values[6];
end;

function TCDContact.ParseAddressLabel(
  const VCardField: TVCardField): TVCardAddressLabel;
const
  AttribsArray: array[0..6] of String = ('HOME', 'DOM', 'INTL', 'POSTAL', 'PARCEL', 'WORK', 'PREF');
var
  Attribs: TVCStringList;
  I: Integer;
begin
  Result := NewAddressLabel;
  Result.FFieldPrefix := VCardField.FFieldPrefix;
  if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
  begin
    Attribs := TVCStringList.Create;
    Attribs.CommaText := VCardField.Attributes.Values['TYPE'];
    try
      for I := 0 to Attribs.Count - 1 do begin
        case PosInStrArray(Attribs[I], AttribsArray, False) of
          0: Include(Result.FAddressAttributes, tatHome);
          1: Include(Result.FAddressAttributes, tatDomestic);
          2: Include(Result.FAddressAttributes, tatInternational);
          3: Include(Result.FAddressAttributes, tatPostal);
          4: Include(Result.FAddressAttributes, tatParcel);
          5: Include(Result.FAddressAttributes, tatWork);
          6: Include(Result.FAddressAttributes, tatPreferred);
        end;
      end;
    finally
      Attribs.Free;
    end;
  end
  else
    Result.FAddressAttributes := [tatHome];
  Result.FMailingLabel := BSUnescape(VCardField.Values.DelimitedText);
end;

function TCDContact.ParseEMailAddress(
  const VCardField: TVCardField): TVCardEMailAddress;

const AttribsArray: array [0..14] of string = (
  'AOL', // America On-Line
  'APPLELINK',   // AppleLink
  'ATTMAIL', // AT&T Mail
  'CIS', // CompuServe Information Service
  'EWORLD', // eWorld
  'INTERNET', // Internet SMTP
  'IBMMAIL', // IBM Mail
  'MCIMAIL', // MCI Mail
  'POWERSHARE', // PowerShare
  'PRODIGY', // Prodigy information service
  'TLX', // Telex number
  'X400', // X.400 service
  'HOME',
  'WORK',
  'OTHER'
);

var
  Attribs: TVCStringList;
  I, ps: Integer;
begin
  Result := NewEMailAddress;
  Result.FFieldPrefix := VCardField.FFieldPrefix;
  Result.FEMailTypes := [];
  if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
  begin
    Result.FPreferred := Pos('PREF', UpperCase(VCardField.Attributes.Values['TYPE'])) > 0;
    Attribs := TVCStringList.Create;
    Attribs.CommaText := VCardField.Attributes.Values['TYPE'];
    try
      for I := 0 to Attribs.Count - 1 do begin
        ps := PosInStrArray(Attribs[I], AttribsArray, False);
        if ps <> -1 then
        begin
          case ps of
            0 : Result.FEMailTypes := Result.FEMailTypes + [ematAOL]; // America On-Line
            1 : Result.FEMailTypes := Result.FEMailTypes + [ematAppleLink]; // AppleLink
            2 : Result.FEMailTypes := Result.FEMailTypes + [ematATT];   // AT&T Mail
            3 : Result.FEMailTypes := Result.FEMailTypes + [ematCIS];   // CompuServe Information Service
            4 : Result.FEMailTypes := Result.FEMailTypes + [emateWorld]; // eWorld
            5 : Result.FEMailTypes := Result.FEMailTypes + [ematInternet]; // Internet SMTP
            6 : Result.FEMailTypes := Result.FEMailTypes + [ematIBMMail]; // IBM Mail
            7 : Result.FEMailTypes := Result.FEMailTypes + [ematMCIMail]; // Indicates MCI Mail
            8 : Result.FEMailTypes := Result.FEMailTypes + [ematPowerShare]; // PowerShare
            9 : Result.FEMailTypes := Result.FEMailTypes + [ematProdigy]; // Prodigy information service
           10 : Result.FEMailTypes := Result.FEMailTypes + [ematTelex]; // Telex number
           11 : Result.FEMailTypes := Result.FEMailTypes + [ematX400]; // X.400 service
           12 : Result.FEMailTypes := Result.FEMailTypes + [ematHome]; // X.400 service
           13 : Result.FEMailTypes := Result.FEMailTypes + [ematWork]; // X.400 service
           14 : Result.FEMailTypes := Result.FEMailTypes + [ematOther]; // X.400 service
          end;
        end;
      end;
    finally
      Attribs.Free;
    end;
  end;
  if Result.FEMailTypes = [] then
    Result.FEMailTypes := [ematInternet];
  Result.FAddress := VCardField.Values.DelimitedText;
end;

function TCDContact.ParseEmbeddedObject(
  const VCardField: TVCardField): TVCardEmbeddedObject;
var
  TStr: String;
begin
  Result := TVCardEmbeddedObject.Create;
  try
    if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
      Result.FObjectType := VCardField.Attributes.Values['TYPE'];
    if VCardField.Attributes.IndexOfName('ENCODING') <> -1 then
      Result.FEncoding := VCardField.Attributes.Values['ENCODING'];
    if LowerCase(Result.FEncoding) = 'base64' then
      Result.FEncoding := 'b';
    if VCardField.Attributes.IndexOfName('VALUE') <> -1 then
      if LowerCase(VCardField.Attributes.Values['VALUE']) = 'uri' then
      begin
        Result.FEncoding := '';
        Result.FObjectURL := VCardField.Values[0];
        Exit;
      end;
    TStr := VCardField.Values.DelimitedText;
    if Result.FEncoding = 'b' then
      DecodeBase64(TStr, Result.FDataStream)
    else
    begin
      TStr := BSUnescape(TStr);
      Result.FDataStream.Write(PChar(TStr)^, Length(TStr));
    end;
  except
    Result.Free;
    Result := nil;
  end;
end;

function TCDContact.ParseIM(const VCardField: TVCardField): TVCardIM;

const
  AttribsArray1: array [1..5] of string = (
    'PERSONAL',
    'BUSINESS',
    'HOME',
    'WORK',
    'MOBILE'
  );

  AttribsArray2: array [1..14] of string = (
    'jabber',
    'sip',
    'aim',
    'msn',
    'twitter',
    'googletalk',
    'facebook',
    'xmpp',
    'icq',
    'yahoo',
    'skype',
    'qq',
    'gadugadu',
    'owncloud-handle'
  );

var
  Attribs: TVCStringList;
  I, ps: Integer;
begin
  Result := NewIM;
  Result.FFieldPrefix := VCardField.FFieldPrefix;
  Result.FIMType := imtNone;
  Result.FOCIMServiceType := imstNone;
  Result.FProtocol := '';
  if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
  begin
    Result.FPreferred := Pos('PREF', UpperCase(VCardField.Attributes.Values['TYPE'])) > 0;
    Attribs := TVCStringList.Create;
    Attribs.CommaText := VCardField.Attributes.Values['TYPE'];
    try
      for I := 0 to Attribs.Count - 1 do begin
        ps := PosInStrArray(Attribs[I], AttribsArray1, False);
        if ps <> -1 then
        begin
          Result.FIMType := TVCardIMType(ps + 1);
          Break;
        end;
      end;
    finally
      Attribs.Free;
    end;
  end;
  Result.FValue := VCardField.Values.DelimitedText;
  ps := Pos(':', Result.FValue);
  if (ps > 1) and (ps < Length(Result.FValue)) then
  begin
    Result.FProtocol := Copy(Result.FValue, 1, ps - 1);
    Result.FValue := Copy(Result.FValue, ps + 1, MaxInt);
  end;
  if VCardField.Attributes.IndexOfName('X-SERVICE-TYPE') <> -1 then
  begin
    ps := PosInStrArray(VCardField.Attributes.Values['X-SERVICE-TYPE'], AttribsArray2, False);
    if ps <> -1 then
      Result.FOCIMServiceType := TVCardOCIMServiseType(ps + 1);
  end;
end;

function TCDContact.ParsePhoneNumber(
  const VCardField: TVCardField): TVCardPhoneNumber;
const
   AttribsArray: array [0..15] of string = ('HOME', 'MSG', 'WORK', 'PREF', 'VOICE', 'FAX',
     'CELL', 'VIDEO', 'BBS', 'MODEM', 'CAR', 'ISDN', 'PCS', 'TEXT', 'PAGER', 'IPHONE');
var
  Attribs: TVCStringList;
  I: Integer;
begin
  Result := NewPhoneNumber;
  Result.FFieldPrefix := VCardField.FFieldPrefix;
  if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
  begin
    Attribs := TVCStringList.Create;
    Attribs.CommaText := VCardField.Attributes.Values['TYPE'];
    try
      for I := 0 to Attribs.Count - 1 do begin
        case PosInStrArray(Attribs[I], AttribsArray, False) of
          0: Include(Result.FPhoneAttributes, tpaHome);
          1: Include(Result.FPhoneAttributes, tpaVoiceMessaging);
          2: Include(Result.FPhoneAttributes, tpaWork);
          3: Include(Result.FPhoneAttributes, tpaPreferred);
          4: Include(Result.FPhoneAttributes, tpaVoice);
          5: Include(Result.FPhoneAttributes, tpaFax);
          6: Include(Result.FPhoneAttributes, tpaCellular);
          7: Include(Result.FPhoneAttributes, tpaVideo);
          8: Include(Result.FPhoneAttributes, tpaBBS);
          9: Include(Result.FPhoneAttributes, tpaModem);
          10: Include(Result.FPhoneAttributes, tpaCar);
          11: Include(Result.FPhoneAttributes, tpaISDN);
          12: Include(Result.FPhoneAttributes, tpaPCS);
          13: Include(Result.FPhoneAttributes, tpaText);
          14: Include(Result.FPhoneAttributes, tpaPager);
          15: Include(Result.FPhoneAttributes, tpaiPhone);
        end;
      end;
    finally
      Attribs.Free;
    end;
  end
  else
    Result.FPhoneAttributes := [tpaHome];
  Result.FNumber := VCardField.Values.DelimitedText;
end;

function TCDContact.ParseURL(const VCardField: TVCardField): TVCardURL;

const AttribsArray: array [0..3] of string = (
  'WORK',
  'HOME',
  'INTERNET',
  'OTHER'
);

var
  Attribs: TVCStringList;
  I, ps: Integer;
begin
  Result := NewURL;
  Result.FFieldPrefix := VCardField.FFieldPrefix;
  Result.FURLType := utOther;
  if VCardField.Attributes.IndexOfName('TYPE') <> -1 then
  begin
    Result.FPreferred := Pos('PREF', UpperCase(VCardField.Attributes.Values['TYPE'])) > 0;
    Attribs := TVCStringList.Create;
    Attribs.CommaText := VCardField.Attributes.Values['TYPE'];
    try
      for I := 0 to Attribs.Count - 1 do begin
        ps := PosInStrArray(Attribs[I], AttribsArray, False);
        if ps <> -1 then
        begin
          case ps of
            0 : Result.FURLType := utWork;
            1 : Result.FURLType := utHome;
            2 : Result.FURLType := utInternet;
            3 : Result.FURLType := utOther;
          end;
          Break;
        end;
      end;
    finally
      Attribs.Free;
    end;
  end;
  Result.FURL := VCardField.Values.DelimitedText;
end;

function TCDContact.PhoneNumbersCount: Integer;
begin
  Result := FPhoneNumbers.Count;
end;

procedure TCDContact.ResetBatchStoring;
begin
  FToDelete := False;
  FToStore := False;
end;

function TCDContact.GetOtherValue(Index: String): String;
var
  tmpField: TVCardField;
begin
  tmpField := GetOtherFieldByName(Index);
  if tmpField <> nil then
    Result := Trim(GetOtherFieldByName(Index).Values.DelimitedText)
  else
    Result := '';
end;

{ TVCardField }

constructor TVCardField.Create(const avText: String);
begin
  FAttributes := TVCStringList.Create;
  FAttributes.Delimiter := ';';
  FAttributes.NameValueSeparator := '=';
  FAttributes.QuoteChar := #0;
  FValues := TVCStringList.Create;
  FValues.Delimiter := ';';
  FValues.NameValueSeparator := '=';
  FValues.QuoteChar := #0;
{$IFDEF 2010ANDLATER}
  FAttributes.StrictDelimiter := True;
  FValues.StrictDelimiter := True;
{$ENDIF}
  if Trim(avText) <> '' then
    SetvText(avText);
end;

destructor TVCardField.Destroy;
begin
  FValues.Free;
  FAttributes.Free;
  inherited;
end;

function TVCardField.GetvText: String;
var
  I, J: Integer;
begin
  Result := FFieldName;
  if Trim(FFieldPrefix) <> '' then
    Result := FFieldPrefix + '.' + Result;
  if FAttributes.Count > 0 then
  for I := 0 to FAttributes.Count - 1 do
  begin
    with TVCStringList.Create do
    try
      CommaText := FAttributes.ValueFromIndex[I];
      for J := 0 to Count - 1 do
        Result := Result + ';' + FAttributes.Names[I] + '=' + Strings[J];
    finally
      Free;
    end;
  end;
  if not FQuotedPrintable then
  begin
    Result := Result + ':';
    if FValues.Count > 0 then
      Result := Result + FValues.DelimitedText;
  end
  else
  begin
    Result := Result + ';ENCODING=QUOTED-PRINTABLE:';
    if FValues.Count > 0 then
      Result := Result + QPEncode(FValues.DelimitedText);
  end;
end;

procedure TVCardField.SetvText(const avText: String);

{  function SaveEscaped(const Str:String): String;
  begin
    Result := StringReplace(Str, '\\', '<$backslash$>', [rfReplaceAll]);
    Result := StringReplace(Result, '\:', '<$colon$>', [rfReplaceAll]);
    Result := StringReplace(Result, '\;', '<$semicolon$>', [rfReplaceAll]);
    Result := StringReplace(Result, '\,', '<$comma$>', [rfReplaceAll]);
  end;

  function UnSaveEscaped(const Str:String): String;
  begin
    Result := StringReplace(Str, '<$colon$>', '\:', [rfReplaceAll]);
    Result := StringReplace(Result, '<$semicolon$>', '\;', [rfReplaceAll]);
    Result := StringReplace(Result, '<$comma$>', '\,', [rfReplaceAll]);
    Result := StringReplace(Result, '<$backslash$>', '\\', [rfReplaceAll]);
  end;}

var
  I, FI: Integer;
  AttrName: String;
  DP, CP: Integer;
  lvText: String;
begin
  lvText := avText;
  FQuotedPrintable := False;
  FFieldName := '';
  FFieldPrefix := '';
  FAttributes.Clear;
  FValues.Clear;
  CP := Pos(':', lvText);
  DP := Pos('.', lvText);
  if CP = 1 then
    Exit;
  if CP = 0 then
  begin
    if DP <> 0 then
    begin
      if DP > 1 then
        FFieldPrefix := Copy(lvText, 1, DP - 1);
      lvText := Copy(lvText, DP + 1, MaxInt);
    end;
    FFieldName := UpperCase(lvText)
  end
  else
  begin
    if (DP <> 0) and (DP < CP) then
    begin
      if DP > 1 then
        FFieldPrefix := Copy(lvText, 1, DP - 1);
      lvText := Copy(lvText, DP + 1, MaxInt);
    end;
    CP := Pos(':', lvText);
    FAttributes.DelimitedText := Copy(lvText, 1, CP - 1);
    FFieldName := UpperCase(FAttributes[0]);
    FAttributes.Delete(0);
    for I := 0 to FAttributes.Count - 1 do
      FAttributes[I] := UpperCase(FAttributes.Names[I]) + '=' + FAttributes.ValueFromIndex[I];
    if FAttributes.Count > 1 then
    begin
      I := 1;
      while I < FAttributes.Count do
      begin
        AttrName := FAttributes.Names[I];
        FI := FAttributes.IndexOfName(AttrName);
        if FI < I then
        begin
          if FAttributes.ValueFromIndex[FI] <> FAttributes.ValueFromIndex[I] then
            FAttributes.ValueFromIndex[FI] := FAttributes.ValueFromIndex[FI] + ',' + FAttributes.ValueFromIndex[I];
          FAttributes.Delete(I);
        end
        else
          Inc(I);
      end;
    end;
    if CP < Length(lvText) then
      FValues.DelimitedText := Copy(lvText, CP + 1, MaxInt);
    if FValues.Count = 0 then
      FValues.Add('');
    I := FAttributes.IndexOfName('ENCODING');
    if (I <> -1) and (FAttributes.ValueFromIndex[I] = 'QUOTED-PRINTABLE') then
    begin
      FQuotedPrintable := True;
      FAttributes.Delete(I);
      for I := 0 to FValues.Count - 1 do
        FValues[I] := QPDecode(FValues[I]);
    end;
  end;
end;

{ TVCardEmbeddedObject }

constructor TVCardEmbeddedObject.Create;
begin
  inherited Create;
  FEncoding := 'b';
  FDataStream := TMemoryStream.Create;
end;

destructor TVCardEmbeddedObject.Destroy;
begin
  FDataStream.Free;
  inherited;
end;

function TVCardEmbeddedObject.GetDataStream: TMemoryStream;
begin
  if (FDataStream.Size = 0) and (FObjectURL <> '') then
  begin
    with TIdHTTP.Create(nil) do
    try
      Get(FObjectURL, FDataStream);
      ObjectType := Response.ContentType;
    finally
      Free;
    end;
  end;
  Result := FDataStream;
end;

{ TVCStringList }

function TVCStringList.Get(Index: Integer): string;
begin
  if Index >= Count then Result := ''
  else
    Result := inherited Get(Index);
end;

{ TCardDAVStoreThread }

constructor TCardDAVStoreThread.Create(AItem: TCDContact; WaitEvent: THandle);
begin
  inherited Create(True);
  FItem := AItem;
  FWaitEvent := WaitEvent;
  FHTTP := TIdWebDAV.Create(nil);
  FSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHTTP.IOHandler := FSSLIO;
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 4;
  FHTTP.ConnectTimeout := 30000;
  FHTTP.ReadTimeout := 30000;
  FHTTP.Request.UserAgent := 'Mozilla/5.0';
  FHTTP.HTTPOptions := AItem.FAddressbook.FHTTP.HTTPOptions;
  FHTTP.Request.BasicAuthentication := AItem.FAddressbook.FHTTP.Request.BasicAuthentication;
  FHTTP.IOHandler.RecvBufferSize := 50 * 1024;
  FHTTP.IOHandler.SendBufferSize := 50 * 1024;
  FHTTP.ProxyParams.Assign(AItem.FAddressbook.FHTTP.ProxyParams);
  FHTTP.Request.Username := AItem.FAddressbook.FHTTP.Request.Username;
  FHTTP.Request.Password := AItem.FAddressbook.FHTTP.Request.Password;
  FHTTP.Intercept := AItem.FAddressbook.FHTTP.Intercept;
  AItem.FAddressbook.ApplyProxySettings(FHTTP, FSSLIO);
  FreeOnTerminate := True;
  FBaseURL := FItem.FAddressbook.FBaseURL;
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  Resume;
end;

destructor TCardDAVStoreThread.Destroy;
begin
  FSSLIO.Free;
  FHTTP.Free;
  SetEvent(FWaitEvent);
  inherited;
end;

procedure TCardDAVStoreThread.Execute;
var
  URL: String;
  S: TStringStream;
begin
  with FItem do
  try
    try
      if FToDelete then
      begin
        if FHRef <> '' then
        begin
          FHTTP.Disconnect;
          FHTTP.DAVDelete(FBaseURL + FileNameOnly(FHRef), '');
        end;
      end
      else
      if FToStore then
      begin
        FHTTP.Disconnect;
        if FHRef <> '' then
          URL := FBaseURL + FileNameOnly(FHRef)
        else
        if Trim(FUID) <> '' then
          URL := FBaseURL + FUID + '.vcf'
        else
          URL := FBaseURL + DateTimeTovCardDate(Now, True) + IntToStr(Random(1000000)) + '.vcf';
        S := TStringStream.Create(UTF8Encode(vCard));
        try
          if not FStored then
            FHTTP.Request.CustomHeaders.Add('If-None-Match:*');
          FHTTP.Request.ContentType := FItem.FAddressbook.FUsedMIMEType +'; charset=UTF-8';
          FHTTP.Put(URL, S);
          if FHTTP.ResponseCode div 100 <> 2 then
            raise Exception.Create(FHTTP.ResponseText);
          S.Size := 0;
          FHRef := URL;
          if FHTTP.Response.RawHeaders.Values['ETag'] <> '' then
            FETag := FHTTP.Response.RawHeaders.Values['ETag']
          else
          begin
            FHTTP.Disconnect;
            FHTTP.Request.ContentType := '';
            if FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match') <> -1 then
              FHTTP.Request.CustomHeaders.Delete(FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match'));
            FHTTP.Get(URL, S);
            if FHTTP.ResponseCode div 100 <> 2 then
              raise Exception.Create(FHTTP.ResponseText);
            FETag := FHTTP.Response.RawHeaders.Values['ETag'];
            FHTTP.Request.ContentType := FItem.FAddressbook.FUsedMIMEType + '; charset=UTF-8';
            SetvCard(S.DataString);
          end;
        finally
          if FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match') <> -1 then
            FHTTP.Request.CustomHeaders.Delete(FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match'));
          S.Free;
        end;
      end;
      FStoreError := 'OK';
    except
      on E: Exception do
      begin
        FStoreError := E.Message;
        Exit;
      end
      else
        Exit;
    end;
  finally
    FAddressbook.FCriticalSection.Enter;
    try
      FAddressbook.FStoreThreads.Remove(Self);
      FStoreThread := nil;
    finally
      FAddressbook.FCriticalSection.Leave;
    end;
  end;
end;

{ TMultigetThread }

constructor TMultigetThread.Create(AddressBook: TCDAddressbook;
  Multiget: string; WaitEvent: THandle);
begin
  inherited Create(True);
  FAddressBook := AddressBook;
  FMultiget := Multiget;
  FWaitEvent := WaitEvent;
  FHTTP := TIdWebDAV.Create(nil);
  FSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHTTP.IOHandler := FSSLIO;
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 4;
  FHTTP.ConnectTimeout := 30000;
  FHTTP.ReadTimeout := 60000;
  FHTTP.Request.UserAgent := 'Mozilla/5.0';
  FHTTP.HTTPOptions := Addressbook.FHTTP.HTTPOptions;
  FHTTP.Request.BasicAuthentication := Addressbook.FHTTP.Request.BasicAuthentication;
  FHTTP.IOHandler.RecvBufferSize := 50 * 1024;
  FHTTP.IOHandler.SendBufferSize := 50 * 1024;
  FHTTP.ProxyParams.Assign(AddressBook.FHTTP.ProxyParams);
  FHTTP.Request.Username := AddressBook.FHTTP.Request.Username;
  FHTTP.Request.Password := AddressBook.FHTTP.Request.Password;
  FHTTP.Intercept := AddressBook.FHTTP.Intercept;
  Addressbook.ApplyProxySettings(FHTTP, FSSLIO);
  FreeOnTerminate := True;
  FBaseURL := FAddressBook.FBaseURL;
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  Resume;
end;

destructor TMultigetThread.Destroy;
begin
  FSSLIO.Free;
  FHTTP.Free;
  inherited;
end;

procedure TMultigetThread.DoProcessResponse;
var
  Multiget: string;
begin
  Multiget := 'none';
  FAddressBook.ParseMultigetResponse('', FResponse, 0, Multiget);
end;

procedure TMultigetThread.Execute;
var
  Req, Resp: TStringStream;
begin
  Resp := TStringStream.Create('');
  CoInitialize(nil);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset="utf-8"';
    if (FMultiGet <> '') and (FMultiget <> 'none') then
    begin
      Req := TStringStream.Create(
        '<?xml version="1.0" encoding="utf-8" ?>' + #13#10 +
        '<C:addressbook-multiget xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">' + #13#10 +
        '  <D:prop>' + #13#10 +
        '    <D:getetag/>' + #13#10 +
        '    <D:getlastmodified/>' + #13#10 +
        '    <D:getcontenttype/>' + #13#10 +
        '    <C:address-data/>' + #13#10 +
        '  </D:prop>' + #13#10 +
        FMultiGet +
        '</C:addressbook-multiget>'
      );
      Resp.Size := 0;
    end;
    try
      FHTTP.DAVReport(FBaseURL, Req, Resp);
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
    except
      Exit;
    end;
    FResponse := Resp.DataString;
    if not FAddressBook.FCancelMultiget then
      DoProcessResponse;
  finally
    FAddressBook.FCriticalSection.Enter;
    try
      FAddressBook.FMultigetThreads.Remove(Self);
    finally
      FAddressBook.FCriticalSection.Leave;
    end;
    SetEvent(FWaitEvent);
    CoUninitialize;
    Resp.Free;
    Req.Free;
  end;
end;

initialization
{$IFDEF DEMO}
  if DebugHook = 0 then
  begin
    MessageBox(0, 'CardDAV trial version requires Delphi IDE!', 'Error', 0);
    Halt(1);
  end;
{$ENDIF}
end.


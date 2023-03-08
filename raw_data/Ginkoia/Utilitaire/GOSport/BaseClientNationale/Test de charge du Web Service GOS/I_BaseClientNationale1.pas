// ************************************************************************ //
// Les types déclarés dans ce fichier ont été générés à partir de données lues
// depuis le fichier WSDL décrit ci-dessous :
// WSDL     : C:\Users\DEVXE\Desktop\I_BaseClientNationale.xml
//  >Importer : C:\Users\DEVXE\Desktop\I_BaseClientNationale.xml>0
// Version  : 1.0
// (17/08/2016 11:47:18 - - $Rev: 34800 $)
// ************************************************************************ //

unit I_BaseClientNationale1;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // Les types suivants mentionnés dans le document WSDL ne sont pas représentés
  // dans ce fichier. Ce sont des alias[@] d'autres types représentés ou alors ils étaient référencés
  // mais jamais[!] déclarés dans le document. Les types de la dernière catégorie
  // sont en principe mappés sur des types Embarcadero ou XML prédéfinis/connus. Toutefois, ils peuvent aussi 
  // signaler des documents WSDL incorrects n'ayant pas réussi à déclarer ou importer un type de schéma.
  // ************************************************************************ //
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TRemotableGnk        = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TInfoClients         = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TClientInfos         = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TLogExportInfo       = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TLogExports          = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TNbPointsClient      = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }

  TLogExportInfoArray = array of TLogExportInfo;   { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TClientsInfosArray = array of TClientInfos;   { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }


  // ************************************************************************ //
  // XML       : TRemotableGnk, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TRemotableGnk = class(TRemotable)
  private
    FiErreur: Integer;
    FsMessage: string;
    FsFilename: string;
  published
    property iErreur:   Integer  read FiErreur write FiErreur;
    property sMessage:  string   read FsMessage write FsMessage;
    property sFilename: string   read FsFilename write FsFilename;
  end;



  // ************************************************************************ //
  // XML       : TInfoClients, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TInfoClients = class(TRemotableGnk)
  private
    FstClientInfos: TClientsInfosArray;
    FiNbClients: Integer;
  public
    destructor Destroy; override;
  published
    property stClientInfos: TClientsInfosArray  read FstClientInfos write FstClientInfos;
    property iNbClients:    Integer             read FiNbClients write FiNbClients;
  end;



  // ************************************************************************ //
  // XML       : TClientInfos, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TClientInfos = class(TRemotable)
  private
    FiCentrale: Integer;
    FsNumCarte: string;
    FsCiv: string;
    FsNom: string;
    FsPrenom: string;
    FsAdr: string;
    FsCP: string;
    FsVille: string;
    FsPays: string;
    FsTel1: string;
    FsTel2: string;
    FsDateNaiss: string;
    FsEmail: string;
    FiSalarie: Integer;
    FsDateCreation: string;
    FiBlackList: Integer;
    FiNPAI: Integer;
    FiVIB: Integer;
    FsIDREF: string;
    FsDateSuppression: string;
    FsSoldePts: string;
    FsDateSoldePts: string;
    FiTypeFid: Integer;
  published
    property iCentrale:        Integer  read FiCentrale write FiCentrale;
    property sNumCarte:        string   read FsNumCarte write FsNumCarte;
    property sCiv:             string   read FsCiv write FsCiv;
    property sNom:             string   read FsNom write FsNom;
    property sPrenom:          string   read FsPrenom write FsPrenom;
    property sAdr:             string   read FsAdr write FsAdr;
    property sCP:              string   read FsCP write FsCP;
    property sVille:           string   read FsVille write FsVille;
    property sPays:            string   read FsPays write FsPays;
    property sTel1:            string   read FsTel1 write FsTel1;
    property sTel2:            string   read FsTel2 write FsTel2;
    property sDateNaiss:       string   read FsDateNaiss write FsDateNaiss;
    property sEmail:           string   read FsEmail write FsEmail;
    property iSalarie:         Integer  read FiSalarie write FiSalarie;
    property sDateCreation:    string   read FsDateCreation write FsDateCreation;
    property iBlackList:       Integer  read FiBlackList write FiBlackList;
    property iNPAI:            Integer  read FiNPAI write FiNPAI;
    property iVIB:             Integer  read FiVIB write FiVIB;
    property sIDREF:           string   read FsIDREF write FsIDREF;
    property sDateSuppression: string   read FsDateSuppression write FsDateSuppression;
    property sSoldePts:        string   read FsSoldePts write FsSoldePts;
    property sDateSoldePts:    string   read FsDateSoldePts write FsDateSoldePts;
    property iTypeFid:         Integer  read FiTypeFid write FiTypeFid;
  end;



  // ************************************************************************ //
  // XML       : TLogExportInfo, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TLogExportInfo = class(TRemotable)
  private
    FsHeure: string;
    FsFichier: string;
    FsDateLastExport: string;
  published
    property sHeure:          string  read FsHeure write FsHeure;
    property sFichier:        string  read FsFichier write FsFichier;
    property sDateLastExport: string  read FsDateLastExport write FsDateLastExport;
  end;



  // ************************************************************************ //
  // XML       : TLogExports, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TLogExports = class(TRemotableGnk)
  private
    FAListLogExport: TLogExportInfoArray;
    FiNbLogExport: Integer;
  public
    destructor Destroy; override;
  published
    property AListLogExport: TLogExportInfoArray  read FAListLogExport write FAListLogExport;
    property iNbLogExport:   Integer              read FiNbLogExport write FiNbLogExport;
  end;



  // ************************************************************************ //
  // XML       : TNbPointsClient, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TNbPointsClient = class(TRemotableGnk)
  private
    FsSoldePts: string;
    FsDateSoldePts: string;
  published
    property sSoldePts:     string  read FsSoldePts write FsSoldePts;
    property sDateSoldePts: string  read FsDateSoldePts write FsDateSoldePts;
  end;


  // ************************************************************************ //
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale
  // soapAction : urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // utiliser   : encoded
  // Liaison : I_BaseClientNationalebinding
  // service   : I_BaseClientNationaleservice
  // port      : I_BaseClientNationalePort
  // URL       : http://127.0.0.1/BaseClientNationaleGnkTest/SrvBaseClientNationale.dll/soap/I_BaseClientNationale
  // ************************************************************************ //
  I_BaseClientNationale = interface(IInvokable)
  ['{D844D8E7-C044-CBA6-609F-DB940D2D0A21}']
    function  GetTime: string; stdcall;
    function  InfoClientGet(const sDateHeure: string; const sPassword: string; const iCentrale: Integer; const sNumCarte: string; const sNomClient: string; const sPrenomClient: string; 
                            const sVilleClient: string; const sCPClient: string; const sDateNaiss: string): TInfoClients; stdcall;
    function  InfoClientMaj(const iCentrale: Integer; const sDateHeure: string; const sPassword: string; const sNumCarte: string; const sCodeMag: string; const sCiv: string; 
                            const sNom: string; const sPrenom: string; const sAdr: string; const sCP: string; const sVille: string; 
                            const sPays: string; const sTel1: string; const sTel2: string; const sDateNaiss: string; const sEmail: string; 
                            const sDateMAJ: string; const iTypeFid: Integer): TRemotableGnk; stdcall;
    function  InfoClientMajCAP(const iCentrale: Integer; const sDateHeure: string; const sPassword: string; const sNumCarte: string; const sCodeMag: string; const sCiv: string;
                               const sNom: string; const sPrenom: string; const sAdr: string; const sCP: string; const sVille: string; 
                               const sPays: string; const sTel1: string; const sTel2: string; const sDateNaiss: string; const sEmail: string; 
                               const sDateMAJ: string; const CapRetMail: string; const CapQualite: string; const iTypeFid: Integer): TRemotableGnk; stdcall;
    function  NbPointsClientGet(const sDateHeure: string; const sPassword: string; const sNumcarte: string; const iCentrale: Integer): TNbPointsClient; stdcall;
    function  BonReducUtilise(const iCentrale: Integer; const sDateHeure: string; const sPassword: string; const sNumCarte: string; const sNumTicket: string; const sCodeMag: string; 
                              const sDate: string; const sNumeroBon: string): TRemotableGnk; stdcall;
    function  CheckBonReducUtilise(const iCentrale: Integer; const sDateHeure: string; const sPassword: string; const sNumCarte: string; const sNumTicket: string; const sCodeMag: string; 
                                   const sDate: string; const sNumeroBon: string): TRemotableGnk; stdcall;
    function  PalierUtilise(const iCentrale: Integer; const iPalierUtilise: Integer; const sDateHeure: string; const sPassword: string; const sNumCarte: string; const sCodeMag: string
                            ): TRemotableGnk; stdcall;
    function  ImportClients(const sDateHeure: string; const sPassword: string; const AFileName: string): TRemotableGnk; stdcall;
    function  ImportPoints(const sDateHeure: string; const sPassword: string; const AFileName: string): TRemotableGnk; stdcall;
    function  ExportClients(const sDateHeure: string; const sPassword: string; const AExtension: string; const APathDest: string): TRemotableGnk; stdcall;
    function  ExportBonRepris(const sDateHeure: string; const sPassword: string; const AExtension: string; const APathDest: string): TRemotableGnk; stdcall;
    function  LogExportGet(const sDateHeure: string; const sPassword: string): TLogExports; stdcall;
  end;

function GetI_BaseClientNationale(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): I_BaseClientNationale;


implementation
  uses SysUtils;

function GetI_BaseClientNationale(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): I_BaseClientNationale;
const
  defWSDL = 'C:\Users\DEVXE\Desktop\I_BaseClientNationale.xml';
  defURL  = 'http://oce4.ginkoia.eu/BaseClientNationaleGnkTest/SrvBaseClientNationale.dll/soap/I_BaseClientNationale';
  defSvc  = 'I_BaseClientNationaleservice';
  defPrt  = 'I_BaseClientNationalePort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as I_BaseClientNationale);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor TInfoClients.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FstClientInfos)-1 do
    SysUtils.FreeAndNil(FstClientInfos[I]);
  System.SetLength(FstClientInfos, 0);
  inherited Destroy;
end;

destructor TLogExports.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FAListLogExport)-1 do
    SysUtils.FreeAndNil(FAListLogExport[I]);
  System.SetLength(FAListLogExport, 0);
  inherited Destroy;
end;

initialization
  { I_BaseClientNationale }
  InvRegistry.RegisterInterface(TypeInfo(I_BaseClientNationale), 'urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(I_BaseClientNationale), 'urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TLogExportInfoArray), 'urn:u_i_BaseClientNationaleIntf', 'TLogExportInfoArray');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TClientsInfosArray), 'urn:u_i_BaseClientNationaleIntf', 'TClientsInfosArray');
  RemClassRegistry.RegisterXSClass(TRemotableGnk, 'urn:u_i_BaseClientNationaleIntf', 'TRemotableGnk');
  RemClassRegistry.RegisterXSClass(TInfoClients, 'urn:u_i_BaseClientNationaleIntf', 'TInfoClients');
  RemClassRegistry.RegisterXSClass(TClientInfos, 'urn:u_i_BaseClientNationaleIntf', 'TClientInfos');
  RemClassRegistry.RegisterXSClass(TLogExportInfo, 'urn:u_i_BaseClientNationaleIntf', 'TLogExportInfo');
  RemClassRegistry.RegisterXSClass(TLogExports, 'urn:u_i_BaseClientNationaleIntf', 'TLogExports');
  RemClassRegistry.RegisterXSClass(TNbPointsClient, 'urn:u_i_BaseClientNationaleIntf', 'TNbPointsClient');

end.
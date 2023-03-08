// ************************************************************************ //

// Les types déclarés dans ce fichier ont été générés à partir de données lues dans le

// fichier WSDL décrit ci-dessous :

// WSDL     : C:\Users\DEVXE\Desktop\I_BaseClientNationale.xml

//  >Import : C:\Users\DEVXE\Desktop\I_BaseClientNationale.xml:0
// Version  : 1.0
// (16/07/2020 11:14:22 - - $Rev: 10138 $)
// ************************************************************************ //

unit u_I_BaseClientNationale;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // Les types suivants mentionnés dans le document WSDL ne sont pas représentés

  // dans ce fichier. Ce sont soit des alias[@] de types représentés ou alors ils sont

  // référencés mais jamais[!] déclarés dans le document. Les types de la dernière catégorie

  // sont en principe mappés à des types Borland ou XML prédéfinis/connus. Toutefois, ils peuvent aussi 

  // signaler des documents WSDL incorrects n'ayant pas réussi à déclarer ou importer un type de schéma.  // ************************************************************************ //
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TRemotableGnk        = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TNbPointsClient      = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TLogExports          = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TLogExportInfo       = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TInfoClients         = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }
  TClientInfos         = class;                 { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }



  // ************************************************************************ //
  // XML       : TRemotableGnk, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TRemotableGnk = class(TRemotable)
  private
    FiErreur: Integer;
    FsMessage: WideString;
    FsFilename: WideString;
  published
    property iErreur:   Integer     read FiErreur write FiErreur;
    property sMessage:  WideString  read FsMessage write FsMessage;
    property sFilename: WideString  read FsFilename write FsFilename;
  end;



  // ************************************************************************ //
  // XML       : TNbPointsClient, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TNbPointsClient = class(TRemotableGnk)
  private
    FsSoldePts: WideString;
    FsDateSoldePts: WideString;
  published
    property sSoldePts:     WideString  read FsSoldePts write FsSoldePts;
    property sDateSoldePts: WideString  read FsDateSoldePts write FsDateSoldePts;
  end;

  TLogExportInfoArray = array of TLogExportInfo;   { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }


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
  // XML       : TLogExportInfo, global, <complexType>
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf
  // ************************************************************************ //
  TLogExportInfo = class(TRemotable)
  private
    FsHeure: WideString;
    FsFichier: WideString;
    FsDateLastExport: WideString;
  published
    property sHeure:          WideString  read FsHeure write FsHeure;
    property sFichier:        WideString  read FsFichier write FsFichier;
    property sDateLastExport: WideString  read FsDateLastExport write FsDateLastExport;
  end;

  TClientsInfosArray = array of TClientInfos;   { "urn:u_i_BaseClientNationaleIntf"[GblCplx] }


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
    FsNumCarte: WideString;
    FsCiv: WideString;
    FsNom: WideString;
    FsPrenom: WideString;
    FsAdr: WideString;
    FsCP: WideString;
    FsVille: WideString;
    FsPays: WideString;
    FsTel1: WideString;
    FsTel2: WideString;
    FsDateNaiss: WideString;
    FsEmail: WideString;
    FiSalarie: Integer;
    FsDateCreation: WideString;
    FiBlackList: Integer;
    FiNPAI: Integer;
    FiVIB: Integer;
    FsIDREF: WideString;
    FsDateSuppression: WideString;
    FsSoldePts: WideString;
    FsDateSoldePts: WideString;
    FiTypeFid: Integer;
    FiCstTel: WideString;
    FiCstMail: WideString;
    FiCstCgv: WideString;
    FiCltDesactive: Integer;
  published
    property iCentrale:        Integer     read FiCentrale write FiCentrale;
    property sNumCarte:        WideString  read FsNumCarte write FsNumCarte;
    property sCiv:             WideString  read FsCiv write FsCiv;
    property sNom:             WideString  read FsNom write FsNom;
    property sPrenom:          WideString  read FsPrenom write FsPrenom;
    property sAdr:             WideString  read FsAdr write FsAdr;
    property sCP:              WideString  read FsCP write FsCP;
    property sVille:           WideString  read FsVille write FsVille;
    property sPays:            WideString  read FsPays write FsPays;
    property sTel1:            WideString  read FsTel1 write FsTel1;
    property sTel2:            WideString  read FsTel2 write FsTel2;
    property sDateNaiss:       WideString  read FsDateNaiss write FsDateNaiss;
    property sEmail:           WideString  read FsEmail write FsEmail;
    property iSalarie:         Integer     read FiSalarie write FiSalarie;
    property sDateCreation:    WideString  read FsDateCreation write FsDateCreation;
    property iBlackList:       Integer     read FiBlackList write FiBlackList;
    property iNPAI:            Integer     read FiNPAI write FiNPAI;
    property iVIB:             Integer     read FiVIB write FiVIB;
    property sIDREF:           WideString  read FsIDREF write FsIDREF;
    property sDateSuppression: WideString  read FsDateSuppression write FsDateSuppression;
    property sSoldePts:        WideString  read FsSoldePts write FsSoldePts;
    property sDateSoldePts:    WideString  read FsDateSoldePts write FsDateSoldePts;
    property iTypeFid:         Integer     read FiTypeFid write FiTypeFid;
    property iCstTel:          WideString  read FiCstTel write FiCstTel;
    property iCstMail:         WideString  read FiCstMail write FiCstMail;
    property iCstCgv:          WideString  read FiCstCgv write FiCstCgv;
    property iCltDesactive:    Integer     read FiCltDesactive write FiCltDesactive;
  end;


  // ************************************************************************ //
  // Espace de nommage : urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale
  // soapAction : urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // Liaison   : I_BaseClientNationalebinding
  // service   : I_BaseClientNationaleservice
  // port      : I_BaseClientNationalePort
  // URL       : http://10.1.71.15/BaseClientNationaleGnkCourir/SrvBaseClientNationale.dll/soap/I_BaseClientNationale
  // ************************************************************************ //
  I_BaseClientNationale = interface(IInvokable)
  ['{D844D8E7-C044-CBA6-609F-DB940D2D0A21}']
    function  GetTime: WideString; stdcall;
    function  InfoClientGet(const sDateHeure: WideString; const sPassword: WideString; const iCentrale: Integer; const sNumCarte: WideString; const sNomClient: WideString; const sPrenomClient: WideString;
                            const sVilleClient: WideString; const sCPClient: WideString; const sDateNaiss: WideString): TInfoClients; stdcall;
    function  InfoClientMaj(const iCentrale: Integer; const sDateHeure: WideString; const sPassword: WideString; const sNumCarte: WideString; const sCodeMag: WideString; const sCiv: WideString;
                            const sNom: WideString; const sPrenom: WideString; const sAdr: WideString; const sCP: WideString; const sVille: WideString; 
                            const sPays: WideString; const sTel1: WideString; const sTel2: WideString; const sDateNaiss: WideString; const sEmail: WideString; 
                            const sDateMAJ: WideString; const iTypeFid: Integer; const iCstTel: WideString; const iCstMail: WideString; const iCstCgv: WideString;
                            const iCltDesactive : Integer): TRemotableGnk; stdcall;
    function  InfoClientMajCAP(const iCentrale: Integer; const sDateHeure: WideString; const sPassword: WideString; const sNumCarte: WideString; const sCodeMag: WideString; const sCiv: WideString;
                               const sNom: WideString; const sPrenom: WideString; const sAdr: WideString; const sCP: WideString; const sVille: WideString;
                               const sPays: WideString; const sTel1: WideString; const sTel2: WideString; const sDateNaiss: WideString; const sEmail: WideString;
                               const sDateMAJ: WideString; const CapRetMail: WideString; const CapQualite: WideString; const iTypeFid: Integer; const iCstTel: WideString;
                               const iCstMail: WideString; const iCstCgv: WideString; const iCltDesactive : Integer): TRemotableGnk; stdcall;
    function  NbPointsClientGet(const sDateHeure: WideString; const sPassword: WideString; const sNumcarte: WideString; const iCentrale: Integer): TNbPointsClient; stdcall;
    function  BonReducUtilise(const iCentrale: Integer; const sDateHeure: WideString; const sPassword: WideString; const sNumCarte: WideString; const sNumTicket: WideString; const sCodeMag: WideString;
                              const sDate: WideString; const sNumeroBon: WideString): TRemotableGnk; stdcall;
    function  CheckBonReducUtilise(const iCentrale: Integer; const sDateHeure: WideString; const sPassword: WideString; const sNumCarte: WideString; const sNumTicket: WideString; const sCodeMag: WideString; 
                                   const sDate: WideString; const sNumeroBon: WideString): TRemotableGnk; stdcall;
    function  PalierUtilise(const iCentrale: Integer; const iPalierUtilise: Integer; const sDateHeure: WideString; const sPassword: WideString; const sNumCarte: WideString; const sCodeMag: WideString
                            ): TRemotableGnk; stdcall;
    function  ImportClients(const sDateHeure: WideString; const sPassword: WideString; const AFileName: WideString): TRemotableGnk; stdcall;
    function  ImportPoints(const sDateHeure: WideString; const sPassword: WideString; const AFileName: WideString): TRemotableGnk; stdcall;
    function  ExportClients(const sDateHeure: WideString; const sPassword: WideString; const AExtension: WideString; const APathDest: WideString): TRemotableGnk; stdcall;
    function  ExportBonRepris(const sDateHeure: WideString; const sPassword: WideString; const AExtension: WideString; const APathDest: WideString): TRemotableGnk; stdcall;
    function  LogExportGet(const sDateHeure: WideString; const sPassword: WideString): TLogExports; stdcall;
  end;

function GetI_BaseClientNationale(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): I_BaseClientNationale;


implementation
  uses SysUtils;

function GetI_BaseClientNationale(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): I_BaseClientNationale;
const
  defWSDL = 'C:\Users\DEVXE\Desktop\I_BaseClientNationale.xml';
  defURL  = 'http://10.1.71.15/BaseClientNationaleGnkCourir/SrvBaseClientNationale.dll/soap/I_BaseClientNationale';
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


destructor TLogExports.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FAListLogExport)-1 do
    FreeAndNil(FAListLogExport[I]);
  SetLength(FAListLogExport, 0);
  inherited Destroy;
end;

destructor TInfoClients.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FstClientInfos)-1 do
    FreeAndNil(FstClientInfos[I]);
  SetLength(FstClientInfos, 0);
  inherited Destroy;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(I_BaseClientNationale), 'urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(I_BaseClientNationale), 'urn:u_i_BaseClientNationaleIntf-I_BaseClientNationale#%operationName%');
  RemClassRegistry.RegisterXSClass(TRemotableGnk, 'urn:u_i_BaseClientNationaleIntf', 'TRemotableGnk');
  RemClassRegistry.RegisterXSClass(TNbPointsClient, 'urn:u_i_BaseClientNationaleIntf', 'TNbPointsClient');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TLogExportInfoArray), 'urn:u_i_BaseClientNationaleIntf', 'TLogExportInfoArray');
  RemClassRegistry.RegisterXSClass(TLogExports, 'urn:u_i_BaseClientNationaleIntf', 'TLogExports');
  RemClassRegistry.RegisterXSClass(TLogExportInfo, 'urn:u_i_BaseClientNationaleIntf', 'TLogExportInfo');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TClientsInfosArray), 'urn:u_i_BaseClientNationaleIntf', 'TClientsInfosArray');
  RemClassRegistry.RegisterXSClass(TInfoClients, 'urn:u_i_BaseClientNationaleIntf', 'TInfoClients');
  RemClassRegistry.RegisterXSClass(TClientInfos, 'urn:u_i_BaseClientNationaleIntf', 'TClientInfos');

end.


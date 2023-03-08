unit u_i_BaseClientNationaleIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type
  TRemotableGnk = class(TRemotable)
  private
    FMessage: String;
    FErreur: integer;
    FFilename: String;
  published
    property iErreur: integer read FErreur write FErreur;
    property sMessage: String read FMessage write FMessage;
    property sFilename: String read FFilename write FFilename;
  end;

  TClientInfos = class(TRemotable)
  private
    FSoldePts: String;
    FTel1: String;
    FPrenom: String;
    FDateSoldePts: String;
    FPays: String;
    FNom: String;
    FVIB: integer;
    FAdr: String;
    FNPAI: integer;
    FVille: String;
    FIDREF: String;
    FDateCreation: String;
    FDateNaiss: String;
    FCP: String;
    FSalarie: integer;
    FBlackList: integer;
    FEmail: String;
    FCiv: String;
    FTel2: String;
    FDateSuppression: String;
    FCentrale: integer;
    FNumCarte: String;
    FTypeFid : integer;
    FCstTel : String;
    FCstMail : String;
    FCstCgv : String;
    FCltDesactive: Integer;
  published
    property iCentrale: integer read FCentrale write FCentrale;
    property sNumCarte: String read FNumCarte write FNumCarte;
    property sCiv: String read FCiv write FCiv;
    property sNom: String read FNom write FNom;
    property sPrenom: String read FPrenom write FPrenom;
    property sAdr: String read FAdr write FAdr;
    property sCP: String read FCP write FCP;
    property sVille: String read FVille write FVille;
    property sPays: String read FPays write FPays;
    property sTel1: String read FTel1 write FTel1;
    property sTel2: String read FTel2 write FTel2;
    property sDateNaiss: String read FDateNaiss write FDateNaiss;
    property sEmail: String read FEmail write FEmail;
    property iSalarie: integer read FSalarie write FSalarie;
    property sDateCreation: String read FDateCreation write FDateCreation;
    property iBlackList: integer read FBlackList write FBlackList;
    property iNPAI: integer read FNPAI write FNPAI;
    property iVIB: integer read FVIB write FVIB;
    property sIDREF: String read FIDREF write FIDREF;
    property sDateSuppression: String read FDateSuppression write FDateSuppression;
    property sSoldePts: String read FSoldePts write FSoldePts;
    property sDateSoldePts: String read FDateSoldePts write FDateSoldePts;
    property iTypeFid: integer read FTypeFid write FTypeFid;
    property iCstTel : String read FCstTel write FCstTel;
    property iCstMail : String read FCstMail write FCstMail;
    property iCstCgv : String read FCstCgv write FCstCgv;
    property iCltDesactive : Integer read FCltDesactive write FCltDesactive;
  end;

  TClientsInfosArray = array of TClientInfos;

  TInfoClients = Class(TRemotableGnk)
  private
    FNbClients: integer;
    FClientInfos: TClientsInfosArray;
  published
    property stClientInfos: TClientsInfosArray read FClientInfos write FClientInfos;
    property iNbClients: integer read FNbClients write FNbClients;
  End;

  TNbPointsClient = Class(TRemotableGnk)
  private
    FSoldePts: String;
    FDateSoldePts: String;
  published
    property sSoldePts: String read FSoldePts write FSoldePts;
    property sDateSoldePts: String read FDateSoldePts write FDateSoldePts;
  End;

  TLogExportInfo = class(TRemotable)
  private
    FHeure: String;
    FDateLastExport: String;
    FFichier: String;
  published
    property sHeure: String read FHeure write FHeure;
    property sFichier: String read FFichier write FFichier;
    property sDateLastExport: String read FDateLastExport write FDateLastExport;
  end;

  TLogExportInfoArray = array of TLogExportInfo;

  TLogExports = Class(TRemotableGnk)
  private
    FListLogExport: TLogExportInfoArray;
    FNbLogExport: integer;
  published
    property AListLogExport: TLogExportInfoArray read FListLogExport write FListLogExport;
    property iNbLogExport: integer read FNbLogExport write FNbLogExport;
  End;


  I_BaseClientNationale = interface(IInvokable)
  ['{8366F4A7-487E-428E-913A-F80625CCF172}']

    function GetTime: String; stdcall;

    function InfoClientGet(Const sDateHeure, sPassword: String; Const iCentrale: integer;
                           Const sNumCarte, sNomClient, sPrenomClient, sVilleClient,
                           sCPClient, sDateNaiss: String): TInfoClients; stdcall;

    function InfoClientMaj(Const iCentrale: integer; Const sDateHeure, sPassword,
                           sNumCarte, sCodeMag, sCiv, sNom, sPrenom, sAdr, sCP,
                           sVille, sPays, sTel1, sTel2, sDateNaiss, sEmail, sDateMAJ: String;
                           iTypeFid : integer;
                           iCstTel : string = ''; iCstMail : string = ''; iCstCgv : string = ''; iCltDesactive : Integer = 0): TRemotableGnk; stdcall;

    function InfoClientMajCAP(Const iCentrale: integer; Const sDateHeure, sPassword,
                              sNumCarte, sCodeMag, sCiv, sNom, sPrenom, sAdr, sCP,
                              sVille, sPays, sTel1, sTel2, sDateNaiss, sEmail, sDateMAJ: String;
                              CapRetMail, CapQualite : string; iTypeFid : integer;
                              iCstTel : string = ''; iCstMail : string = ''; iCstCgv : string = ''; iCltDesactive : Integer = 0): TRemotableGnk; stdcall;

    function NbPointsClientGet(Const sDateHeure, sPassword, sNumcarte: String;
                               Const iCentrale: integer): TNbPointsClient; stdcall;
    function BonReducUtilise(Const iCentrale: integer; Const sDateHeure, sPassword,
                             sNumCarte, sNumTicket, sCodeMag, sDate, sNumeroBon: String): TRemotableGnk; stdcall;
    function CheckBonReducUtilise(Const iCentrale: integer; Const sDateHeure, sPassword,
                                  sNumCarte, sNumTicket, sCodeMag, sDate, sNumeroBon: String): TRemotableGnk; stdcall; //--> Demande de BN

    function PalierUtilise(Const iCentrale, iPalierUtilise: integer; Const sDateHeure, sPassword,
                           sNumCarte, sCodeMag: String): TRemotableGnk; stdcall;

    function ImportClients(Const sDateHeure, sPassword, AFileName: String): TRemotableGnk; stdcall;
    function ImportPoints(Const sDateHeure, sPassword, AFileName: String): TRemotableGnk; stdcall;
    function ExportClients(Const sDateHeure, sPassword, AExtension, APathDest: String): TRemotableGnk; stdcall;
    function ExportBonRepris(Const sDateHeure, sPassword, AExtension, APathDest: String): TRemotableGnk; stdcall;

    function LogExportGet(Const sDateHeure, sPassword: String): TLogExports; stdcall;
  end;

implementation

initialization
  InvRegistry.RegisterInterface(TypeInfo(I_BaseClientNationale));

end.

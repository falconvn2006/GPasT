unit wm_Maintenance;

interface

uses
  SysUtils, Classes, HTTPApp, InvokeRegistry, WSDLIntf, TypInfo, WebServExp,
  WSDLBind, XMLSchema, WSDLPub, SOAPPasInv, SOAPHTTPPasInv, SOAPHTTPDisp,
  WebBrokerSOAP, u_Parser, uCommon, DateUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client;

type
  TwmMaintenance = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    procedure WebModule2DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure wmMaintenanceActGetModuleAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGetJetonAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGetSrvAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGetGrpAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGetDossierAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActEmetteurAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGetMagasinAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActVersionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSteMagPosteAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActStartConnexionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSocieteAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActPosteAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActHoraireAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActModuleGinkoiaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActNewPlageAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActNewIdentAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActConnexionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSuiviSrvReplicationAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleException(Sender: TObject; E: Exception;
      var Handled: Boolean);
    procedure wmMaintenanceActModeleMailAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSendMailEmetteurAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActRaisonAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActRecupBaseAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActPriorityOrdreSplittageAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSplittageLogAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActStatutSplittageProcessAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGenReplicationAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGenSubscribersAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGenGenLiaiRepliAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGenProvidersAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActlistFolderAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActListFileAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSynchronizeStartedAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSynchronizeAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGrpPumpAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActExecuteProcessAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSyncBaseAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActJetonLameAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActMaintenanceVersionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActTestMailAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActGetSiteInstallAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActSetSiteInstallAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActClearSiteInstallAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMaintenanceActInitPosteAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    procedure Module(Request: TWebRequest; Response: TWebResponse);
    procedure ModuleGinkoia(Request: TWebRequest; Response: TWebResponse);
    procedure Jeton(Request: TWebRequest; Response: TWebResponse);
    procedure Srv(Request: TWebRequest; Response: TWebResponse);
    procedure Grp(Request: TWebRequest; Response: TWebResponse);
    procedure Horaire(Request: TWebRequest; Response: TWebResponse);
    procedure Dossier(Request: TWebRequest; Response: TWebResponse);
    procedure Emetteur(Request: TWebRequest; Response: TWebResponse);
    procedure Connexion(Request: TWebRequest; Response: TWebResponse);
    procedure Societe(Request: TWebRequest; Response: TWebResponse);
    procedure Magasin(Request: TWebRequest; Response: TWebResponse);
    procedure Poste(Request: TWebRequest; Response: TWebResponse);
    procedure Version(Request: TWebRequest; Response: TWebResponse);
    procedure SteMagPoste(Request: TWebRequest; Response: TWebResponse);
    procedure Raison(Request: TWebRequest; Response: TWebResponse);
    procedure NewPlage(Request: TWebRequest; Response: TWebResponse);
    procedure NewIdent(Request: TWebRequest; Response: TWebResponse);
    procedure SuiviSrvReplication(Request: TWebRequest; Response: TWebResponse);
    procedure ModeleMail(Request: TWebRequest; Response: TWebResponse);
    procedure MaintenanceVersion(Request: TWebRequest; Response: TWebResponse);
    procedure SendMailEmetteur(Request: TWebRequest; Response: TWebResponse);
    procedure SendMailTest(Request: TWebRequest; Response: TWebResponse);
    procedure StatutSplittageProcess(Request: TWebRequest; Response: TWebResponse);
    procedure SplittageLog(Request: TWebRequest; Response: TWebResponse);
    procedure GenReplication(Request: TWebRequest; Response: TWebResponse);
    procedure GenProviders(Request: TWebRequest; Response: TWebResponse);
    procedure GenSubscribers(Request: TWebRequest; Response: TWebResponse);
    procedure GenGenLiaiRepli(Request: TWebRequest; Response: TWebResponse);
    procedure ListFolder(Request: TWebRequest; Response: TWebResponse);
    procedure ListFile(Request: TWebRequest; Response: TWebResponse);
    procedure GroupPump(Request: TWebRequest; Response: TWebResponse);
    procedure ExecuteProcess(Request: TWebRequest; Response: TWebResponse);
    procedure JetonLame(Request: TWebRequest; Response: TWebResponse);
    procedure GetSiteInstallAction(Request: TWebRequest; Response: TWebResponse);
    procedure SetSiteInstallAction(Request: TWebRequest; Response: TWebResponse);
    procedure ClearSiteConnexion(Request: TWebRequest; Response: TWebResponse);
    procedure InitialisePostes(Request:TWebRequest; Response: TWebResponse);
    procedure PriorityOrdreSplittageLog(Request: TWebRequest; Response: TWebResponse);

    procedure RecupBase(Request: TWebRequest; Response: TWebResponse);
  public
    procedure Initialize;
  end;

var
  //Log: TFileStream;
  //WLog: TStreamWriter;
  wmMaintenance: TwmMaintenance;

implementation

uses WebReq, dmdMaintenance, uCtrlMaintenance, uMapper, uVar, uConst;

{$R *.dfm}

procedure TwmMaintenance.ClearSiteConnexion(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vEMET_GUID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vEMET_GUID:= Request.QueryFields.Values['aGUID'];

    case Request.MethodType of
      mtGet : Response.Content:= vMapperObj.SetDateInstallation(vEMET_GUID, StrToDateTime('01/01/1900'));
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Connexion(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vEMET_ID, vCON_ID, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    vEMET_ID:= Request.QueryFields.Values['EMET_ID'];
    vCON_ID:= Request.QueryFields.Values['CON_ID'];
    if vDOSS_ID = '' then
      vDOSS_ID:= '-1';
    if vEMET_ID = '' then
      vEMET_ID:= '-1';
    if vCON_ID = '' then
      vCON_ID:= '-1';
    if vDELETE = '' then
      vDELETE:= '0';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListConnexionToXml(Request, StrToInt(vDOSS_ID), StrToInt(vEMET_ID), StrToInt(vCON_ID))
          else
            Response.Content:= vMapperObj.DeleteConnexion(StrToInt(vEMET_ID), StrToInt(vCON_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetConnexion(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Dossier(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vCHANGEDOS, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    if vDOSS_ID = '' then
      vDOSS_ID:= '-1';
    if vDELETE = '' then
      vDELETE:= '0';

    vCHANGEDOS:= Request.QueryFields.Values['CHANGEDOS'];

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListDossierToXml(Request, StrToInt(vDOSS_ID))
          else
            Response.Content:= vMapperObj.DeleteDossier(StrToInt(vDOSS_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetDossier(Request.ContentFields.text, vCHANGEDOS);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Emetteur(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vSERV_ID, vSynthese: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
          vSERV_ID:= Request.QueryFields.Values['SERV_ID'];
          vSynthese:= Request.QueryFields.Values['Synthese'];
          if vDOSS_ID = '' then
            vDOSS_ID:= '-1';
          if vSERV_ID = '' then
            vSERV_ID:= '-1';
          Response.Content:= vMapperObj.GetListEmetteurToXml(Request, StrToInt(vDOSS_ID), StrToInt(vSERV_ID), vSynthese);
        end;
      mtPost: Response.Content:= vMapperObj.SetEmetteur(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.ExecuteProcess(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          //Au besoin
        end;
      mtPost: Response.Content:= vMapperObj.SetExecuteProcess(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.GenGenLiaiRepli(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vGLR_ID, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    vGLR_ID:= Request.QueryFields.Values['GLR_ID'];
    if vDELETE = '' then
      vDELETE:= '0';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE <> '0' then
            Response.Content:= vMapperObj.DeleteGenLiaiRepli(StrToInt(vDOSS_ID), StrToInt(vGLR_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetGenLiaiRepli(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.GenProviders(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vREP_ID, vSTATUTPKG, vPRO_ID, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    if vDELETE = '' then
      vDELETE:= '0';

    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];

    vREP_ID:= Request.QueryFields.Values['REP_ID'];
    if vREP_ID = '' then
      vREP_ID:= '0';

    vSTATUTPKG:= Request.QueryFields.Values['STATUTPKG'];

    vPRO_ID:= Request.QueryFields.Values['PRO_ID'];
    if vPRO_ID = '' then
      vPRO_ID:= '0';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListGenProvidersToXml(Request, StrToInt(vDOSS_ID), StrToInt(vREP_ID), StrToInt(vSTATUTPKG))
          else
            Response.Content:= vMapperObj.DeleteGenProviders(StrToInt(vDOSS_ID), StrToInt(vPRO_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetGenProviders(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.GenReplication(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vLAUID, vREPLICWEB, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    if vDELETE = '' then
      vDELETE:= '0';

    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    if vDOSS_ID = '' then
      vDOSS_ID:= '0';
    vLAUID:= Request.QueryFields.Values['LAUID'];
    if vLAUID = '' then
      vLAUID:= '0';
    vREPLICWEB:= Request.QueryFields.Values['REPLICWEB'];

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListGenReplicationToXml(Request, StrToInt(vDOSS_ID), StrToInt(vLAUID), StrToInt(vREPLICWEB))
          else
            Response.Content:= vMapperObj.DeleteGenReplication(StrToInt(vDOSS_ID), StrToInt(vLAUID));
        end;
      mtPost: Response.Content:= vMapperObj.SetGenReplication(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.GenSubscribers(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vREP_ID, vSTATUTPKG, vSUB_ID, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    if vDELETE = '' then
      vDELETE:= '0';

    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];

    vREP_ID:= Request.QueryFields.Values['REP_ID'];
    if vREP_ID = '' then
      vREP_ID:= '0';

    vSTATUTPKG:= Request.QueryFields.Values['STATUTPKG'];

    vSUB_ID:= Request.QueryFields.Values['SUB_ID'];
    if vSUB_ID = '' then
      vSUB_ID:= '0';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListGenSubscribersToXml(Request, StrToInt(vDOSS_ID), StrToInt(vREP_ID), StrToInt(vSTATUTPKG))
          else
            Response.Content:= vMapperObj.DeleteGenSubscribers(StrToInt(vDOSS_ID), StrToInt(vSUB_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetGenSubscribers(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.GetSiteInstallAction(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vEMET_GUID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vEMET_GUID:= Request.QueryFields.Values['aGUID'];

    case Request.MethodType of
      mtGet : Response.Content:= vMapperObj.GetDateInstallation(vEMET_GUID);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.GroupPump(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID: String;
  vGCP_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];

          vGCP_ID:= Request.QueryFields.Values['GCP_ID'];
          if vGCP_ID = '' then
            vGCP_ID:= '-1';

          Response.Content:= vMapperObj.GetListGroupPumpToXml(Request, StrToInt(vDOSS_ID), StrToInt(vGCP_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetGroupPump(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Grp(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    Response.Content:= vMapperObj.GetListGrpToXml(Request);
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Horaire(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vSERV_ID, vPRHO_ID, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    vSERV_ID:= Request.QueryFields.Values['SERV_ID'];
    vPRHO_ID:= Request.QueryFields.Values['PRHO_ID'];
    if vSERV_ID = '' then
      vSERV_ID:= '-1';
    if vPRHO_ID = '' then
      vPRHO_ID:= '-1';
    if vDELETE = '' then
      vDELETE:= '0';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListHoraireToXml(Request)
          else
            vMapperObj.DeleteHoraire(StrToInt(vSERV_ID), StrToInt(vPRHO_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetHoraire(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Jeton(Request: TWebRequest; Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          { Tous les jetons }
          Response.Content:= vMapperObj.GetListJetonToXml(Request);

          { Un jeton }
          //--> à faire...
        end;
//      mtPost: ;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.JetonLame(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSSID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDOSSID := Request.QueryFields.Values['DOSS_ID'];
    case Request.MethodType of
      mtGet: Response.Content:= vMapperObj.GetJetonLame(StrToInt(vDOSSID));
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.ListFile(Request: TWebRequest; Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vLAME, vFOLDER: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vFOLDER:= Request.QueryFields.Values['FOLDER'];
          vLAME:= Request.QueryFields.Values['LAME'];
          Response.Content:= vMapperObj.GetListFile(Request, vLAME, vFOLDER);
        end;
//      mtPost: Response.Content:= ;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.ListFolder(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vLAME, vFOLDER, vITEMPATHBROWSER: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vITEMPATHBROWSER:= Request.QueryFields.Values['ITEMPATHBROWSER'];
          vFOLDER:= Request.QueryFields.Values['FOLDER'];
          vLAME:= Request.QueryFields.Values['LAME'];
          Response.Content:= vMapperObj.GetListFolder(Request, vLAME, vFOLDER, vITEMPATHBROWSER);
        end;
//      mtPost: Response.Content:= ;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Magasin(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vMAGA_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
          vMAGA_ID:= Request.QueryFields.Values['MAGA_ID'];
          if vDOSS_ID = '' then
            vDOSS_ID:= '-1';
          if vMAGA_ID = '' then
            vMAGA_ID:= '-1';

          Response.Content:= vMapperObj.GetListMagasinToXml(Request, StrToInt(vMAGA_ID), StrToInt(vDOSS_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetMagasin(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.MaintenanceVersion(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vVERSIONCLIENT: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vVERSIONCLIENT:= Request.QueryFields.Values['VERSION_CLIENT'];
    case Request.MethodType of
      mtGet: Response.Content:= vMapperObj.VerifMaintenanceVersion(vVERSIONCLIENT);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Poste(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          //-->
        end;
      mtPost: Response.Content:= vMapperObj.SetPoste(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.PriorityOrdreSplittageLog(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vNOSPLIT, vPriorityOrdre: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vNOSPLIT:= Request.QueryFields.Values['NOSPLIT'];
          vPriorityOrdre:= Request.QueryFields.Values['PRIORITYORDRE'];
          Response.Content:= vMapperObj.PriorityOrdreSplittageLog(Request, StrToInt(vNOSPLIT) , StrToInt(vPriorityOrdre));
        end;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Raison(Request: TWebRequest; Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vRAIS_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vRAIS_ID:= Request.QueryFields.Values['RAIS_ID'];
          if vRAIS_ID = '' then
            vRAIS_ID:= '-1';

          Response.Content:= vMapperObj.GetListRaisonToXml(Request, StrToInt(vRAIS_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetMagasin(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.RecupBase(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDELETE,
  vBASE,
  vMAIL: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    if vDELETE = '' then
      vDELETE:= '0';

    vBASE:= Request.QueryFields.Values['BASE'];
    if vBASE = '' then
      vBASE:= '1';

    vMAIL:= Request.QueryFields.Values['MAIL'];
    if vMAIL = '' then
      vMAIL:= '1';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.RecupBase(Request, Request.QueryFields.Values['USERNAME'],
                                                    Request.QueryFields.Values['TYPESPLIT'],
                                                    StrToInt(Request.QueryFields.Values['EMET_ID']),
                                                    StrToInt(Request.QueryFields.Values['CLEARFILES']),
                                                    StrToInt(vBASE),
                                                    StrToInt(vMAIL))
          else
            Response.Content:= vMapperObj.DeleteRecupBase(StrToInt(Request.QueryFields.Values['NOSPLIT']));
        end;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.ModeleMail(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet: Response.Content:= vMapperObj.GetlistModeleMailToXml(Request);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Module(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vMAGA_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
          vMAGA_ID:= Request.QueryFields.Values['MAGA_ID'];
          if vDOSS_ID = '' then
            vDOSS_ID:= '-1';
          if vMAGA_ID = '' then
            vMAGA_ID:= '-1';
          Response.Content:= vMapperObj.GetListModuleToXml(Request, StrToInt(vMAGA_ID), StrToInt(vDOSS_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetModule(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.ModuleGinkoia(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID, vMAGA_MAGID_GINKOIA, vUGM_MAGID, vUGG_ID, vALL, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    vMAGA_MAGID_GINKOIA:= Request.QueryFields.Values['MAGA_MAGID_GINKOIA'];
    vUGM_MAGID:= Request.QueryFields.Values['UGM_MAGID'];
    vUGG_ID:= Request.QueryFields.Values['UGG_ID'];
    vALL:= Request.QueryFields.Values['ALL'];
    if vDOSS_ID = '' then
      vDOSS_ID:= '-1';
    if vMAGA_MAGID_GINKOIA = '' then
      vMAGA_MAGID_GINKOIA:= '-1';
    if vUGM_MAGID = '' then
      vUGM_MAGID:= '-1';
    if vUGG_ID = '' then
      vUGG_ID:= '-1';
    if vALL = '' then
      vALL:= '0';
    if vDELETE = '' then
      vDELETE:= '0';

    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListModuleGinkoiaToXml(Request, StrToInt(vDOSS_ID), StrToInt(vMAGA_MAGID_GINKOIA), vALL <> '0')
          else
            Response.Content:= vMapperObj.DeleteModuleGinkoia(StrToInt(vDOSS_ID), StrToInt(vUGM_MAGID), StrToInt(vUGG_ID));
        end;
      mtPost: Response.Content:= vMapperObj.SetModuleGinkoia(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.NewIdent(Request: TWebRequest; Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    if vDOSS_ID = '' then
      vDOSS_ID:= '-1';
    Response.Content:= vMapperObj.GetNewIdentToXml(Request, StrToInt(vDOSS_ID));
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.NewPlage(Request: TWebRequest; Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
    if vDOSS_ID = '' then
      vDOSS_ID:= '-1';
    Response.Content:= vMapperObj.GetNewPlageToXml(Request, StrToInt(vDOSS_ID));
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.SendMailEmetteur(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtPost: Response.Content:= vMapperObj.SendMailEmetteur(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.SendMailTest(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtPost: Response.Content:= vMapperObj.SendMailTest(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.SetSiteInstallAction(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vEMET_GUID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vEMET_GUID:= Request.QueryFields.Values['aGUID'];

    case Request.MethodType of
      mtGet : Response.Content:= vMapperObj.SetDateInstallation(vEMET_GUID, Now);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Societe(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          //-->
        end;
      mtPost: Response.Content:= vMapperObj.SetSociete(Request.ContentFields.text);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.SplittageLog(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDELETE, vNOSPLIT: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    if vDELETE = '' then
      vDELETE:= '0';

    vNOSPLIT:= Request.QueryFields.Values['NOSPLIT'];
    if vNOSPLIT = '' then
      vNOSPLIT:= '-1';

    if vDELETE = '0' then
      Response.Content:= vMapperObj.GetListSplittageLogToXml(Request)
    else
      Response.Content:= vMapperObj.DeleteListSpittageLog(StrToInt(vNOSPLIT));

  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Srv(Request: TWebRequest; Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    Response.Content:= vMapperObj.GetListSrvToXml(Request);
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.StatutSplittageProcess(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vSTATUT: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vSTATUT:= Request.QueryFields.Values['STATUT'];
          if vSTATUT = '' then
            Response.Content:= vMapperObj.GetStatutSplittageProcessToXml(Request)
          else
            begin
              vMapperObj.SetEtatSplittage(StrToInt(vSTATUT));
              Response.Content:= vMapperObj.GetStatutSplittageProcessToXml(Request)
            end;
        end;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.SteMagPoste(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSS_ID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    case Request.MethodType of
      mtGet:
        begin
          vDOSS_ID:= Request.QueryFields.Values['DOSS_ID'];
          if vDOSS_ID <> '' then
            Response.Content:= vMapperObj.GetListSteMagPosteToXml(Request, StrToInt(vDOSS_ID))
          else
            Response.Content:= BuildXml([cBlsExcept], [cBadRequest]);
        end;
//      mtPost: ;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.SuiviSrvReplication(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vSERV_ID, vSSVR_PATH, vDELETE: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDELETE:= Request.QueryFields.Values['DELETE'];
    if vDELETE = '' then
      vDELETE:= '0';

    vSERV_ID:= Request.QueryFields.Values['SERV_ID'];
    vSSVR_PATH:= Request.QueryFields.Values['SSVR_PATH'];
    if vSERV_ID = '' then
      vSERV_ID:= '-1';
    case Request.MethodType of
      mtGet:
        begin
          if vDELETE = '0' then
            Response.Content:= vMapperObj.GetListSuiviSrvReplicationToXml(Request, StrToInt(vSERV_ID))
          else
            Response.Content:= vMapperObj.DeleteSrvReplicationLog(StrToInt(vSERV_ID), vSSVR_PATH);
        end;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Version(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    Response.Content:= vMapperObj.GetListVersionToXml(Request);
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.InitialisePostes(Request: TWebRequest;
  Response: TWebResponse);
var
  vMapperObj: TGINKOIAMapperObj;
  vCMD: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vCMD:= Request.QueryFields.Values['aCMD'];

    case Request.MethodType of
      mtGet : Response.Content:= vMapperObj.InitialisationPostes(vCMD);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.Initialize;
var
  vSL: TStringList;
begin
  vSL:= TStringList.Create;
  try
    try
      {$IFDEF WAD}
      GWSConfig.ServiceName:= 'SrvMaintenance_WAD';
      //WLog.WriteLine('SrvMaintenance_WAD');
      {$ELSE}
      GWSConfig.ServiceName:= 'SrvMaintenance';
      //WLog.WriteLine('SrvMaintenance');
      {$ENDIF}

      GWSConfig.Load;

      if GWSConfig.FileNameIni = '' then
        Raise Exception.Create('Le chemin du fichier de config est introuvable.');
      vSL.Append('FileNameIni : ' + GWSConfig.FileNameIni);

      //WLog.WriteLine('FileNameIni : ' + GWSConfig.FileNameIni);

      if GWSConfig.FileNameDB = '' then
        Raise Exception.Create('Le chemin de la base de données est introuvable.');
      vSL.Append('FileNameDB : ' + GWSConfig.FileNameDB);

      //WLog.WriteLine('FileNameDB : ' + GWSConfig.FileNameDB);

      vSL.Append('LogOnStart : ' + IntToStr(Integer(GWSConfig.LogOnStart)));
      vSL.Append('LogException : ' + IntToStr(Integer(GWSConfig.LogException)));
      vSL.Append('Traceur : ' + IntToStr(Integer(GWSConfig.Traceur)));

      vSL.Append('Before Create : TdmMaintenance');
      dmMaintenance:= TdmMaintenance.Create(Self);
      vSL.Append('TdmMaintenance Create : Ok');

      //WLog.WriteLine('TdmMaintenance Create : Ok');

      vSL.Append('Before Connected : CNX_MAINTENANCE');
      dmMaintenance.CNX_MAINTENANCE.Close;
      dmMaintenance.CNX_MAINTENANCE.Params.Clear;
      dmMaintenance.CNX_MAINTENANCE.Params.Add('Database=' + string(GWSConfig.FileNameDB));
      dmMaintenance.CNX_MAINTENANCE.Params.Add('User_Name=SYSDBA');
      dmMaintenance.CNX_MAINTENANCE.Params.Add('Password=masterkey');
      dmMaintenance.CNX_MAINTENANCE.Params.Add('Protocol=TCPIP');
      dmMaintenance.CNX_MAINTENANCE.Params.Add('Server=localhost');
      dmMaintenance.CNX_MAINTENANCE.Params.Add('Port=3050');
      dmMaintenance.CNX_MAINTENANCE.Params.Add('DriverID=IB');
      dmMaintenance.CNX_MAINTENANCE.Transaction := dmMaintenance.Transaction;
      dmMaintenance.CNX_MAINTENANCE.Open;
      vSL.Append('CNX_MAINTENANCE Connected : Ok');

      //WLog.WriteLine('CNX_MAINTENANCE Connected : Ok');

      vSL.Append('Before Create : TMaintenanceCtrl');
      GMaintenanceCtrl:= TMaintenanceCtrl.Create(Self);
      vSL.Append('TMaintenanceCtrl Create : Ok');

      //WLog.WriteLine('TMaintenanceCtrl Create : Ok');

      vSL.Append(cWSStarted);
    except
      on E: Exception do
      begin
        vSL.Append(E.Message);
        //WLog.WriteLine(E.Message);
      end;
    end;
  finally
    if GWSConfig.ServiceFileName <> '' then
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TwmMaintenance_Initialize.log', vSL, GWSConfig.LogOnStart)
    else
      GWSConfig.SaveFile('C:\' + GWSConfig.ServiceName + GWSConfig.GetTime + '_TwmMaintenance_Initialize.Except', vSL, True);
    FreeAndNil(vSL);
  end;
end;

procedure TwmMaintenance.WebModule2DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled);
end;

procedure TwmMaintenance.WebModuleCreate(Sender: TObject);
begin
  //WLog.WriteLine('Début');
  GWSConfig:= TWSConfig.Create(Self);
  //WLog.WriteLine('GWSConfig:= TWSConfig.Create(Self);');
  Initialize;
  //WLog.WriteLine('Initialize');
end;

procedure TwmMaintenance.WebModuleException(Sender: TObject; E: Exception;
  var Handled: Boolean);
var
  vSL: TStringList;
begin
  vSL:= TStringList.Create;
  try
    vSL.Append(E.Message);
    GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TwmMaintenance_WebModuleException.Except', vSL, GWSConfig.LogException);
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TwmMaintenance.wmMaintenanceActClearSiteInstallAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  ClearSiteConnexion(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ClearSiteInstallAction' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActConnexionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Connexion(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Connexion' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActEmetteurAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Emetteur(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Emetteur' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActExecuteProcessAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  ExecuteProcess(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ExecuteProcess' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGenGenLiaiRepliAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  GenGenLiaiRepli(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GenGenLiaiRepli' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGenProvidersAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  GenProviders(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GenProviders' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGenReplicationAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  GenReplication(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GenReplication' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGenSubscribersAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  GenSubscribers(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GenSubscribers' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetDossierAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Dossier(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Dossier' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetGrpAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Grp(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Grp' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetJetonAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Jeton(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Jeton' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetMagasinAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Magasin(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'MAGASIN' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetModuleAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Module(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Module' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetSiteInstallAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  GetSiteInstallAction(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GetSiteInstallAction' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGetSrvAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Srv(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Srv' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActGrpPumpAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  GroupPump(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GroupPump' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActHoraireAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Horaire(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Horaire' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActInitPosteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  InitialisePostes(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'InitPosteAction' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActJetonLameAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  JetonLame(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'JetonLame' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActListFileAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  ListFile(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ListFile' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActlistFolderAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  ListFolder(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ListFolder' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActMaintenanceVersionAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  MaintenanceVersion(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'MaintenanceVersion' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActModeleMailAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  ModeleMail(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ModeleMail' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActModuleGinkoiaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  ModuleGinkoia(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ModuleGinkoia' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActNewIdentAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  NewIdent(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'NewIdent' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActNewPlageAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  NewPlage(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'NewPlage' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActPosteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Poste(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Poste' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActPriorityOrdreSplittageAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  PriorityOrdreSplittageLog(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'PriorityOrdreSplittageLog' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActRaisonAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Raison(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Raison' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActRecupBaseAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  RecupBase(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'RecupBase' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSendMailEmetteurAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  SendMailEmetteur(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'SendMailEmetteur' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSetSiteInstallAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  SetSiteInstallAction(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'SetSiteInstallAction' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSocieteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Societe(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Societe' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSplittageLogAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  SplittageLog(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'SplittageLog' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActStartConnexionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if GWSConfig.FileNameDB <> '' then
    Response.Content:= cWSStarted
  else
    Response.Content:= cWSFailed;
end;

procedure TwmMaintenance.wmMaintenanceActStatutSplittageProcessAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  StatutSplittageProcess(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'StatutSplittageProcess' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSteMagPosteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  SteMagPoste(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'SteMagPoste' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSuiviSrvReplicationAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  SuiviSrvReplication(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'SuiviSrvReplication' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSyncBaseAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vMapperObj: TGINKOIAMapperObj;
  vDOSSID: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vDOSSID:= Request.QueryFields.Values['DOSS_ID'];
    if vDOSSID = '' then
      vDOSSID:= '0';
    case Request.MethodType of
      mtGet: Response.Content:= vMapperObj.SyncBaseDossier(StrToInt(vDOSSID));
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSynchronizeAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vMapperObj: TGINKOIAMapperObj;
  vSyncType: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vSyncType:= Request.QueryFields.Values['TYPESYNC'];
    case Request.MethodType of
      mtGet:
        begin
          if vSyncType = cSyncSVR then
            Response.Content:= vMapperObj.SynchronizeSVR
          else
            if vSyncType = cSyncDOS then
              Response.Content:= vMapperObj.SynchronizeDossier
            else
              if vSyncType = cSyncRECYCLEDATAWS then
                Response.Content:= vMapperObj.RecycleDataWS;
        end;
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.wmMaintenanceActSynchronizeStartedAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  vMapperObj: TGINKOIAMapperObj;
  vSyncType: String;
begin
  vMapperObj:= TGINKOIAMapperObj.Create(nil);
  try
    vSyncType:= Request.QueryFields.Values['TYPESYNC'];
    case Request.MethodType of
      mtGet: Response.Content:= vMapperObj.SynchronizeStarted(vSyncType);
    end;
  finally
    FreeAndNil(vMapperObj);
  end;
end;

procedure TwmMaintenance.wmMaintenanceActTestMailAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  SendMailTest(Request, Response);
end;

procedure TwmMaintenance.wmMaintenanceActVersionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
begin
  dDebut := Now;
  Version(Request, Response);
  dFin := Now;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    try
      vSLTraceur.Append(GetNowToStr + 'Temps de traitement (s) : ' + FloatToStr(SecondsBetween(dFin, dDebut)));
    finally
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'Version' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

initialization
  //if FileExists('C:\Users\Public\maint.log') then
  //begin
    //Log := TFileStream.Create('C:\Users\Public\maint.log', fmOpenWrite or fmShareDenyWrite);
    //Log.Seek(0, soFromEnd);
  //end
  //else
  //begin
    //Log := TFileStream.Create('C:\Users\Public\maint.log', fmCreate or fmShareDenyWrite);
  //end;
  //WLog := TStreamWriter.Create(Log, TEncoding.ANSI);
  //WLog.AutoFlush := True;
  //WLog.WriteLine('initialization');

  WebRequestHandler.WebModuleClass := TwmMaintenance;          //a garder

  //WLog.WriteLine('WebRequestHandler.WebModuleClass := TwmMaintenance');

finalization
  //WLog.WriteLine('finalization');
  //WLog.Free;
  //Log.Free;

end.

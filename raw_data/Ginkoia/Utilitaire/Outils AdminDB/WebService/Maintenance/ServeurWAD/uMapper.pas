unit uMapper;

interface

uses
  Windows, Classes, SysUtils, TypInfo, uCtrlMaintenance, u_Parser, XMLDoc,
  HTTPApp, DB, Variants, Contnrs, dmdMaintenance;

Const
  cClassNameErr = 'ClassName incorrecte';
  cBadRequest = 'Bad request';

Type
  TGINKOIAMapperObj = Class(TMapperObj)
  private
    procedure pOnPropertyToXml(AName: String; var Value: String);
  public
    constructor Create(AOwner: TComponent); override;

    { ---------------------------- Ressources Xml ----------------------------- }
    { Maintenance }
    function GetListSrvToXml(Const ARequest: TWebRequest): String;
    function GetListGrpToXml(Const ARequest: TWebRequest): String;
    function GetListModuleToXml(Const ARequest: TWebRequest; Const AMAGA_ID: integer = -1; Const ADOSS_ID: integer = -1): String;
    function GetListModuleGinkoiaToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer;
                                       Const AMAGA_MAGID_GINKOIA: integer; Const All: Boolean): String;
    function GetListJetonToXml(Const ARequest: TWebRequest): String;
    function GetListHoraireToXml(Const ARequest: TWebRequest): String;
    function GetListDossierToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer = -1): String;
    function GetListEmetteurToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer = -1;
                                  Const ASERV_ID: integer = -1; Const ASynthese: String = ''): String;
    function GetListConnexionToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer = -1;
                                   Const AEMET_ID: integer = -1; Const ACON_ID: integer = -1): String;
    function GetListMagasinToXml(Const ARequest: TWebRequest; Const AMAGA_ID: integer = -1; Const ADOSS_ID: integer = -1): String;
    function GetListGroupPumpToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer = -1; Const AGCP_ID: integer = -1): String;
    function GetListVersionToXml(Const ARequest: TWebRequest): String;
    function GetListSteMagPosteToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer): String;
    function GetNewPlageToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer = -1): String;
    function GetNewIdentToXml(Const ARequest: TWebRequest; Const ADOSS_ID: integer = -1): String;
    function GetlistModeleMailToXml(Const ARequest: TWebRequest): String;
    function GetListRaisonToXml(Const ARequest: TWebRequest; Const ARAIS_ID: integer = -1): String;
    function SynchronizeStarted(Const ASyncName: String): String;

    { Gestion de RecupBase/Splittage }
    function GetStatutSplittageProcessToXml(Const ARequest: TWebRequest): String;
    function GetListSplittageLogToXml(Const ARequest: TWebRequest): String;
    procedure SetEtatSplittage(Const AActivate: integer);
    function PriorityOrdreSplittageLog(Const ARequest: TWebRequest; Const ANOSPLIT: integer; const APriorityOrdre: integer): String;
    function RecupBase(Const ARequest: TWebRequest; Const AUSERNAME, ATYPESPLIT: String; Const AEMET_ID, ACLEARFILES, ABASE, AMAIL: integer): String;

    { Gestion des Bases Clients Ginkoia }
    function GetGenReplicationToXml(Const ARequest: TWebRequest; Const ADOSS_ID, AREP_ID: integer): String;  //--> en attente...

    function GetListGenReplicationToXml(Const ARequest: TWebRequest; Const ADOSS_ID, ALAUID, AREPLICWEB: integer): String;
    function GetListGenProvidersToXml(Const ARequest: TWebRequest; Const ADOSS_ID, AREP_ID: integer; Const AStatutPkg: integer): String;
    function GetListGenSubscribersToXml(Const ARequest: TWebRequest; Const ADOSS_ID, AREP_ID: integer; Const AStatutPkg: integer): String;

    function GetDateInstallation(Const AEmet_GUID: string):string;
    { Gestion de suivi de replication }
    function GetListSuiviSrvReplicationToXml(Const ARequest: TWebRequest; Const ASERV_ID: integer): String;

    { Explorateur }
    function GetListFolder(Const ARequest: TWebRequest; Const ALAME, AFOLDER, AITEMPATHBROWSER: String): String;
    function GetListFile(Const ARequest: TWebRequest; Const ALAME, AFOLDER: String): String;

    { ---------------------- MAJ de la base de données ------------------------ }
    function SetModule(Const ARequest: String): String;
    function SetModuleGinkoia(Const ARequest: String): String;
    function SetDossier(Const ARequest, ACHANGEDOS: String): String;
    function SetEmetteur(Const ARequest: String): String;
    function SetConnexion(Const ARequest: String): String;
    function SetSociete(Const ARequest: String): String;
    function SetMagasin(Const ARequest: String): String;
    function SetGroupPump(Const ARequest: String): String;
    function SetPoste(Const ARequest: String): String;
    function SetHoraire(Const ARequest: String): String;
    function SendMailEmetteur(Const ARequest: String): String;
    function SendMailTest(Const ARequest: String): String;
    function SetGenReplication(Const ARequest: String): String;
    function SetGenProviders(Const ARequest: String): String;
    function SetGenSubscribers(Const ARequest: String): String;
    function SetGenLiaiRepli(Const ARequest: String): String;

    function SetDateInstallation(Const AEmet_GUID: String; Const AEmet_Install: TDateTime):string;

    function InitialisationPostes(Const ACMD: String):string;

    function SetExecuteProcess(Const ARequest: String): String;

    function GetJetonLame(Const ADOSS_ID: integer): String;
    function VerifMaintenanceVersion(Const AVERSIONCLIENT: string): string;
    function SyncBaseDossier(Const ADOSS_ID: integer): String;
    function SynchronizeSVR: String;
    function SynchronizeDossier: String;
    function RecycleDataWS: String;

    function DeleteDossier(Const ADOSS_ID: integer): String;
    function DeleteModuleGinkoia(Const ADOSS_ID, UGM_MAGID, AUGG_ID: integer): String;
    function DeleteHoraire(Const ASERV_ID, APRHO_ID: integer): String;
    function DeleteConnexion(Const AEMET_ID, ACON_ID: integer): String;
    function DeleteSrvReplicationLog(Const ASERV_ID: integer; Const ASSVR_PATH: String): String;
    function DeleteRecupBase(Const ANOSPLIT: integer): String;
    function DeleteGenReplication(Const ADOSS_ID, AREP_ID: integer): String;
    function DeleteGenProviders(Const ADOSS_ID, APRO_ID: integer): String;
    function DeleteGenSubscribers(Const ADOSS_ID, ASUB_ID: integer): String;
    function DeleteGenLiaiRepli(Const ADOSS_ID, AGLR_ID: integer): String;
    function DeleteListSpittageLog(const ANOSPLIT: integer): String;
  end;


implementation

uses uMdlMaintenance, uConst, uSearchTG, uVar, uTool_XE7, uMdlGinkoia, uCommon,
  uStatusMessage;

{ TGINKOIAMapperObj }

constructor TGINKOIAMapperObj.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //-->
end;

function TGINKOIAMapperObj.DeleteConnexion(const AEMET_ID,
  ACON_ID: integer): String;
var
  vEmet: TEmetteur;
  vCon: TConnexion;
begin
  try
    if (AEMET_ID < 1) or (ACON_ID < 1) then
      Raise Exception.Create(cBadRequest);

    vEmet:= GMaintenanceCtrl.EmetteurByID[AEMET_ID];
    if vEmet <> nil then
      vCon:= vEmet.ConnexionByID[ACON_ID]
    else
      Raise Exception.Create('Emetteur introuvable.');

    if vCon <> nil then
      begin
        vCon.MAJ(ukDelete);
        vEmet.DeleteConnexion(vCon);
      end;

    Result:= BuildXml([cBlsResult], [cSucces]);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteConnexion', E.Message], TConnexion.ClassName);
  end;
end;

function TGINKOIAMapperObj.DeleteDossier(const ADOSS_ID: integer): String;
var
  vDos: TDossier;
begin
  try
    if ADOSS_ID < 1 then
      Raise Exception.Create(cBadRequest);

    vDos:= GMaintenanceCtrl.DossierByID[ADOSS_ID];
    if vDos = nil then
      Raise Exception.Create(SM_PathNotFound.AMessage);

    GMaintenanceCtrl.DeleteDossier(vDos);
    Result:= BuildXml([cBlsResult], [cSucces]);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteDossier', E.Message], TConnexion.ClassName);
  end;
end;

function TGINKOIAMapperObj.DeleteGenLiaiRepli(const ADOSS_ID,
  AGLR_ID: integer): String;
var
  vGnkGenLiaiRepli: TGnkGenLiaiRepli;
begin
  vGnkGenLiaiRepli:= nil;
  try
    try
      if (ADOSS_ID < 1) or (AGLR_ID < 1) then
        Raise Exception.Create(cBadRequest);

      vGnkGenLiaiRepli:= GMaintenanceCtrl.GetGenLiaiRepli(ADOSS_ID, AGLR_ID);
      if vGnkGenLiaiRepli = nil then
        Raise Exception.Create('GenLiaiRepli introuvable.');

      vGnkGenLiaiRepli.MAJ(ukDelete);
      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteGenLiaiRepli', E.Message], TGnkGenLiaiRepli.ClassName);
    end;
  finally
    if vGnkGenLiaiRepli <> nil then
      FreeAndNil(vGnkGenLiaiRepli);
  end;
end;

function TGINKOIAMapperObj.DeleteGenProviders(const ADOSS_ID,
  APRO_ID: integer): String;
var
  vGnkGenProviders: TGnkGenProviders;
begin
  vGnkGenProviders:= nil;
  try
    try
      if (ADOSS_ID < 1) or (APRO_ID < 1) then
        Raise Exception.Create(cBadRequest);

      vGnkGenProviders:= GMaintenanceCtrl.GetGenProviders(ADOSS_ID, APRO_ID);
      if vGnkGenProviders = nil then
        Raise Exception.Create('Providers introuvable.');

      vGnkGenProviders.MAJ(ukDelete);
      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteGenProviders', E.Message], TGnkGenProviders.ClassName);
    end;
  finally
    if vGnkGenProviders <> nil then
      FreeAndNil(vGnkGenProviders);
  end;
end;

function TGINKOIAMapperObj.DeleteGenReplication(const ADOSS_ID, AREP_ID: integer): String;
var
  vGenReplication: TGnkGenReplication;
begin
  vGenReplication:= nil;
  try
    try
      if (ADOSS_ID < 1) or (AREP_ID < 1) then
        Raise Exception.Create(cBadRequest);

      vGenReplication:= GMaintenanceCtrl.GetGenReplication(ADOSS_ID, AREP_ID);
      if vGenReplication = nil then
        Raise Exception.Create('Replication introuvable.');

      vGenReplication.MAJ(ukDelete);
      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteGenReplication', E.Message], TGnkGenReplication.ClassName);
    end;
  finally
    if vGenReplication <> nil then
      FreeAndNil(vGenReplication);
  end;
end;

function TGINKOIAMapperObj.DeleteGenSubscribers(const ADOSS_ID,
  ASUB_ID: integer): String;
var
  vGnkGenSubscribers: TGnkGenSubscribers;
begin
  vGnkGenSubscribers:= nil;
  try
    try
      if (ADOSS_ID < 1) or (ASUB_ID < 1) then
        Raise Exception.Create(cBadRequest);

      vGnkGenSubscribers:= GMaintenanceCtrl.GetGenSubscribers(ADOSS_ID, ASUB_ID);
      if vGnkGenSubscribers = nil then
        Raise Exception.Create('Subscribers introuvable.');

      vGnkGenSubscribers.MAJ(ukDelete);
      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteGenSubscribers', E.Message], TGnkGenSubscribers.ClassName);
    end;
  finally
    if vGnkGenSubscribers <> nil then
      FreeAndNil(vGnkGenSubscribers);
  end;
end;

function TGINKOIAMapperObj.DeleteHoraire(const ASERV_ID, APRHO_ID: integer): String;
var
  vSrv: TServeur;
  vHoraire: THoraire;
begin
  try
    if (ASERV_ID < 1) or (APRHO_ID < 1) then
      Raise Exception.Create(cBadRequest);

    vSrv:= GMaintenanceCtrl.ServeurByID[ASERV_ID];
    if vSrv <> nil then
      vHoraire:= vSrv.HoraireByID[APRHO_ID]
    else
      Raise Exception.Create('Serveur introuvable.');

    if vHoraire <> nil then
      begin
        vHoraire.MAJ(ukDelete);
        vSrv.DeleteHoraire(vHoraire);
      end;

    Result:= BuildXml([cBlsResult], [cSucces]);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteHoraire', E.Message], THoraire.ClassName);
  end;
end;

function TGINKOIAMapperObj.DeleteModuleGinkoia(const ADOSS_ID, UGM_MAGID,
  AUGG_ID: integer): String;
var
  vMdlG: TModuleGinkoia;
  vMod: TModule;
  vMag: TMagasin;
begin
  vMdlG:= nil;
  try
    try
      if (ADOSS_ID < 1) or (UGM_MAGID < 1) or (AUGG_ID < 1) then
        Raise Exception.Create(cBadRequest);

      vMdlG:= GMaintenanceCtrl.GetModuleGinkoia(ADOSS_ID, UGM_MAGID, AUGG_ID);
      if vMdlG <> nil then
        begin
          vMag:= GMaintenanceCtrl.MagasinByMAGA_MAGID_GINKOIA[vMdlG.UGM_MAGID, ADOSS_ID];
          vMod:= GMaintenanceCtrl.ModuleByNOM[vMdlG.MODU_NOM];
          if vMag <> nil then
            vMdlG.MAGA_ID:= vMag.MAGA_ID;
          if vMod <> nil then
            vMdlG.MODU_ID:= vMod.MODU_ID;

          vMdlG.MAJ(ukDelete);

          if (vMag <> nil) and (vMod <> nil) then
            vMag.DeleteMdl(vMod);
        end;
      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteModuleGinkoia', E.Message], TModuleGinkoia.ClassName);
    end;
  finally
    if vMdlG <> nil then
      FreeAndNil(vMdlG);
  end;
end;

function TGINKOIAMapperObj.DeleteRecupBase(const ANOSPLIT: integer): String;
begin
  try
    GMaintenanceCtrl.DelSplittage(ANOSPLIT);
    Result:= BuildXml([cBlsResult], [cSucces]);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DelSplittage', E.Message], TGnkSplittageLog.ClassName);
  end;
end;

function TGINKOIAMapperObj.DeleteSrvReplicationLog(Const ASERV_ID: integer;
  const ASSVR_PATH: String): String;
var
  vSvr: TSrvReplication;
begin
  vSvr:= nil;
  try
    try
      if GMaintenanceCtrl.ServeurByID[ASERV_ID] = nil then
        Raise Exception.Create('Serveur introuvable.');

      vSvr:= TSrvReplication.Create(nil);
      vSvr.SRV_ID:= ASERV_ID;
      vSvr.SVR_PATH:= ASSVR_PATH;
      vSvr.MAJ(ukDelete);

      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteSrvReplicationLog', E.Message], TSrvReplication.ClassName);
    end;
  finally
    if vSvr <> nil then
      FreeAndNil(vSvr);
  end;
end;

function TGINKOIAMapperObj.DeleteListSpittageLog(Const ANOSPLIT: integer): String;
var
  vSPLIT: TGnkSplittageLog;
begin
  vSPLIT:= nil;
  try
    try
      vSPLIT:= TGnkSplittageLog.Create(nil);
      vSPLIT.SPLI_NOSPLIT:= ANOSPLIT;
      vSPLIT.MAJ(ukDelete);

      Result:= BuildXml([cBlsResult], [cSucces]);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans DeleteListSpittageLog', E.Message], TSrvReplication.ClassName);
    end;
  finally
    if vSPLIT <> nil then
      FreeAndNil(vSPLIT);
  end;
end;

function TGINKOIAMapperObj.GetListConnexionToXml(const ARequest: TWebRequest;
  const ADOSS_ID, AEMET_ID: integer; Const ACON_ID: integer): String;
var
  i: integer;
  vDos: TDossier;
  vEmet: TEmetteur;
  vCon: TConnexion;
  Buffer, vItXml: String;
  vResultMsg: RStatusMessage;
begin
  Result:= '';
  if (ADOSS_ID > 0) and (AEMET_ID > 0) then
    begin
      vDos:= GMaintenanceCtrl.DossierByID[ADOSS_ID];

      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      vEmet:= vDos.EmetteurByID[AEMET_ID];

      if vEmet = nil then
        begin
          GMaintenanceCtrl.LoadListEmetteur(ADOSS_ID, -1, '', False, vResultMsg);
          if vResultMsg.Code <> 0 then
            begin
              if vResultMsg.Code < 0 then
                Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans GetListConnexionToXml', vResultMsg.AMessage], TConnexion.ClassName)
              else
                if vResultMsg.Code > 0 then
                  Result:= BuildXml([cBlsResult], [vResultMsg.AMessage], TConnexion.ClassName);
              Exit;
            end;
          vEmet:= vDos.EmetteurByID[AEMET_ID];
        end;

      if vEmet = nil then
        Raise Exception.Create('Emetteur introuvable.');

    if ACON_ID > 0 then
      begin
        { Une connexion pour un emetteur }
        vCon:= vEmet.ConnexionByID[ACON_ID];
        if vCon <> nil then
          begin
            PropertyToXml(vCon, Buffer);
            vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vCon.ClassName, Buffer]);
            Result:= BuilXmlItems(ARequest, vItXml);
          end;
      end
    else
      begin
        { Toutes les connexions pour un emetteur }
        for i:= 0 to vEmet.CountConnexion - 1 do
          begin
            Buffer:= '';
            PropertyToXml(vEmet.Connexion[i], Buffer);
            vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vEmet.Connexion[i].ClassName, Buffer]);
          end;
        Result:= BuilXmlItems(ARequest, vItXml);
      end;
    end;
end;

function TGINKOIAMapperObj.GetListDossierToXml(Const ARequest: TWebRequest;
  const ADOSS_ID: integer): String;
var
  i: integer;
  vDos: TDossier;
  Buffer, vItXml: String;
  vResultMsg: RStatusMessage;

begin
  Result:= '';
  if ADOSS_ID > 0 then
    begin
      { Un dossiers }
      vDos:= GMaintenanceCtrl.DossierByID[ADOSS_ID];
      if vDos <> nil then
        begin
          Buffer:= '';
          PropertyToXml(vDos, Buffer);
          vItXml:= Format(cBaliseItemURI, [vDos.ClassName, Buffer]);
        end;
    end
  else
    begin
      { Tous les dossiers }
      for i:= 0 to GMaintenanceCtrl.CountDossier - 1 do
      begin
        if GMaintenanceCtrl.Dossier[i] <> nil then
        begin
          Buffer:= '';
          PropertyToXml(GMaintenanceCtrl.Dossier[i], Buffer);
          vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Dossier[i].ClassName, Buffer]);
        end;
      end;
    end;

  Result:= BuilXmlItems(ARequest, vItXml);
end;

function TGINKOIAMapperObj.GetListEmetteurToXml(Const ARequest: TWebRequest;
  Const ADOSS_ID: integer; Const ASERV_ID: integer; Const ASynthese: String): String;
var
  i: integer;
  Buffer, vItXml, vURI: String;
  vSrv: TServeur;
  vEmet: TEmetteur;
  vSL: TStringList;
  vPropSynth: PPropSynthese;
  vResultMsg: RStatusMessage;
  vListEmet: TObjectList;
  vSLTraceur: TStringList;
begin
  Result:= '';
  vListEmet:= nil;
  vSL:= TStringList.Create;
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur:= TStringList.Create;
    vSLTraceur.Append(GetNowToStr + 'GetListEmetteurToXml');
    vSLTraceur.Append(GetNowToStr + 'DOSS_ID : ' + IntToStr(ADOSS_ID));
    vSLTraceur.Append(GetNowToStr + 'SERV_ID : ' + IntToStr(ASERV_ID));
    vSLTraceur.Append(GetNowToStr + 'Synthese : ' + ASynthese);
  end;
  try
    vURI:= string(GetURI(ARequest));
    if ADOSS_ID > 0 then { Tous les emetteurs pour un dossier }
      begin
        try
          vSL.Text:= cFieldsEmetteurByDossier;
          vListEmet:= GMaintenanceCtrl.LoadListEmetteur(ADOSS_ID, -1, '', True, vResultMsg);

          if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
            vSLTraceur.Append(GetNowToStr + 'LoadListEmetteur');

          if vResultMsg.Code <> 0 then
            begin
              if vResultMsg.Code < 0 then
              begin
                if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
                  vSLTraceur.Append(GetNowToStr + 'vResultMsg.Code : ' + IntToStr(vResultMsg.Code));
                Result:= BuildXml([cBlsExcept], [vResultMsg.AMessage], vURI);
              end
              else
                if vResultMsg.Code > 0 then
                  Result:= BuildXml([cBlsResult], [vResultMsg.AMessage], vURI);
              Exit;
            end;

          if vListEmet = nil then
            begin
              Result:= BuildXml([cBlsResultEmpty], [cNoValue], 'TListEmetteur');
              Exit;
            end;

          for i:= 0 to vListEmet.Count - 1 do
            begin
              vEmet:= TEmetteur(vListEmet.Items[i]);
              Buffer:= '';
              PropertyToXml(vEmet, Buffer, vSL);
              vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vEmet.ClassName, Buffer]);
            end;

          if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
            vSLTraceur.Append(GetNowToStr + 'BuilXmlItems');

          Result:= BuilXmlItems(ARequest, vItXml);
        except
          on E: Exception do
            Result:= BuildXml([cBlsExcept], [E.Message], vURI);
        end;
      end
    else
      if ASERV_ID > 0 then { Tous les emetteurs pour un serveur }
        begin
          try
            vSL.Text:= cFieldsEmetteurByServeur;
            vSrv:= GMaintenanceCtrl.ServeurByID[ASERV_ID];
            if vSrv = nil then
              begin
                Result:= BuildXml([cBlsExcept], ['Serveur introuvable'], vURI);
                Exit;
              end;

            vListEmet:= GMaintenanceCtrl.LoadListEmetteur(-1, ASERV_ID, '', True, vResultMsg);

            if vResultMsg.Code <> 0 then
              begin
                if vResultMsg.Code < 0 then
                  Result:= BuildXml([cBlsExcept], [vResultMsg.AMessage], vURI)
                else
                  if vResultMsg.Code > 0 then
                    Result:= BuildXml([cBlsResult], [vResultMsg.AMessage], vURI);
                Exit;
              end;

            if vListEmet = nil then
              begin
                Result:= BuildXml([cBlsResultEmpty], [cNoValue], 'TListEmetteur');
                Exit;
              end;

            for i:= 0 to vListEmet.Count - 1 do
              begin
                vEmet:= TEmetteur(vListEmet.Items[i]);
                Buffer:= '';
                PropertyToXml(vEmet.ADossier, Buffer, vSL);
                PropertyToXml(vEmet, Buffer, vSL);
                vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vEmet.ClassName, Buffer]);
              end;

            Result:= BuilXmlItems(ARequest, vItXml);
          except
            on E: Exception do
              Result:= BuildXml([cBlsExcept], [E.Message], vURI);
          end;
        end
      else
        begin
          { Tous les emetteurs }
          try
            vPropSynth:= GMaintenanceCtrl.GetPropSynthese(ASynthese);
            if vPropSynth <> nil then
              vSL.Text:= vPropSynth.ListFields;
            GMaintenanceCtrl.LoadListEmetteur(-1, -1, ASynthese, False, vResultMsg);

            if vResultMsg.Code <> 0 then
              begin
                if vResultMsg.Code < 0 then
                  Result:= BuildXml([cBlsExcept], [vResultMsg.AMessage], vURI)
                else
                  if vResultMsg.Code > 0 then
                    Result:= BuildXml([cBlsResult], [vResultMsg.AMessage], vURI);
                Exit;
              end;

            for i:= 0 to GMaintenanceCtrl.CountEmet - 1 do
              begin
                Buffer:= '';
                vEmet:= GMaintenanceCtrl.Emetteur[i];
                if vEmet <> nil then
                  begin
                    PropertyToXml(vEmet, Buffer, vSL);
                    if vEmet.ADossier <> nil then
                      PropertyToXml(vEmet.ADossier, Buffer, vSL);
                    vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vEmet.ClassName, Buffer]);
                  end;
              end;
            Result:= BuilXmlItems(ARequest, vItXml);
          except
            on E: Exception do
              Result:= BuildXml([cBlsExcept], [E.Message], vURI);
          end;
        end;
  finally
    FreeAndNil(vSL);
    if vListEmet <> nil then
      FreeAndNil(vListEmet);

    if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
    begin
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'GetListEmetteurToXml' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

function TGINKOIAMapperObj.GetListFile(const ARequest: TWebRequest; const ALAME,
  AFOLDER: String): String;
var
  i: integer;
  vSL: TStringList;
  vSearch: TSearching;
  vLame, vPathSearch: String;
begin
  vLame:= '';
  vSL:= TStringList.Create;
  vSearch:= TSearching.Create(GWSConfig.ServiceFileName);
  try
    if ALAME <> 'LOCALHOST' then
      vLame:= ALAME;

    if vLame = '' then
      vPathSearch:= AFOLDER
    else
      vPathSearch:= DOSS_CHEMINToUNC(vLame, AFOLDER);

    vSearch.Searching(vPathSearch, '*.*', True, True);
    if vSearch.NbFilesFound <> 0 then
      begin
         for i:= Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
          begin
            if (Trim(vSearch.TabInfoSearch[i].Name) <> '') and
               (UpperCase(ExtractFileExt(vSearch.TabInfoSearch[i].Name)) = '.IB') then
              vSL.Append(vSearch.TabInfoSearch[i].Name);
          end;

        Result:= BuildXml([cBlsResult], [vSL.Text], 'TListFile');
      end
    else
      Result:= BuildXml([cBlsResultEmpty], [cNoValue], 'TListFile');
  finally
    FreeAndNil(vSearch);
    FreeAndNil(vSL);
  end;
end;

function TGINKOIAMapperObj.GetListFolder(const ARequest: TWebRequest;
  const ALAME, AFOLDER, AITEMPATHBROWSER: String): String;
var
  i: integer;
  vSL: TStringList;
  vSearch: TSearching;
  Buffer, vLame, vPath, vPATHBROWSER, vPathSearch: String;
begin
  vLame:= '';
  vSL:= TStringList.Create;
  vSearch:= TSearching.Create(GWSConfig.ServiceFileName);
  try
    vPATHBROWSER:= GWSConfig.Options.Values[AITEMPATHBROWSER];

    if vPATHBROWSER = '' then
      begin
        Result:= BuildXml([cBlsResultEmpty], ['"ITEMPATHBROWSER" incorrecte'], 'TListFolder');
        Exit;
      end;

    if ALAME <> 'LOCALHOST' then
      vLame:= ALAME;

    if AFOLDER = '' then
      begin
        vPath:= IncludeTrailingBackslash(vPATHBROWSER);

        if vLame = '' then
          begin
            if (Trim(ALAME) <> '') and (ALAME <> 'LOCALHOST') then
              begin
                Buffer:= ExtractFileDrive(vPath);
                if Buffer <> '' then
                  Delete(vPath, 1, Length(Buffer));
              end;
          end;
      end
    else
      begin
        vPath:= AFOLDER;

        if (vPath[Length(vPath)] = '.') and (vPath[Length(vPath) -1] = '.') then
          begin
            Delete(vPath, Length(vPath), 1);
            Delete(vPath, Length(vPath), 1);
            vPath:= ExcludeTrailingBackslash(vPath);
            if Uppercase(vPath) <> Uppercase(vPATHBROWSER) then
              vPath:= ExtractFilePath(vPath);
          end;
      end;

    if vLame = '' then
      vPathSearch:= vPath
    else
      vPathSearch:= DOSS_CHEMINToUNC(vLame, vPath);

    vSearch.Searching(vPathSearch, '*.*', True, True);
    if vSearch.NbFoldersFound <> 0 then
      begin
        vSL.Text:= vSearch.ListPathForSL;
        for i:= vSL.Count -1 Downto 0 do
          begin
            if ExcludeTrailingBackslash(vPathSearch) <> ExcludeTrailingBackslash(vSL.Strings[i]) then
              begin
                Buffer:= ExtractFileName(vSL.Strings[i]);
                vSL.Strings[i]:= Buffer;
              end
            else
              vSL.Delete(i);
          end;

        Result:= BuildXml([cBlsResult], [vPath + cRC + vSL.Text], 'TListFolder');
      end
    else
      Result:= BuildXml([cBlsResultEmpty], [cNoValue], 'TListFolder');
  finally
    FreeAndNil(vSearch);
    FreeAndNil(vSL);
  end;
end;

function TGINKOIAMapperObj.GetListGenProvidersToXml(const ARequest: TWebRequest;
  const ADOSS_ID, AREP_ID, AStatutPkg: integer): String;
var
  i: integer;
  Buffer, vItXml: String;
  vGnkGenProviders: TGnkGenProviders;
  vList: TObjectList;
begin
  Result:= '';
  try
    try
      vList:= GMaintenanceCtrl.GetListGenProviders(ADOSS_ID, AREP_ID, TStatutPkg(AStatutPkg));

      if (vList <> nil) and (vList.Count <> 0) then
        begin
          for i:= 0 to vList.Count -1 do
            begin
              vGnkGenProviders:= TGnkGenProviders(vList.Items[i]);

              Buffer:= '';
              PropertyToXml(vGnkGenProviders, Buffer);
              vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vGnkGenProviders.ClassName, Buffer]);
            end;
        end;

      if vItXml <> '' then
        Result:= BuilXmlItems(ARequest, vItXml)
      else
        Result:= BuildXml([cBlsResultEmpty], [cNoValue], TGnkGenProviders.ClassName);

    except
      Raise;
    end;
  finally
    FreeAndNil(vList);
  end;
end;

function TGINKOIAMapperObj.GetListGenReplicationToXml(
  const ARequest: TWebRequest; const ADOSS_ID, ALAUID, AREPLICWEB: integer): String;
var
  i: integer;
  Buffer, vItXml: String;
  vGnkGenReplication: TGnkGenReplication;
  vList: TObjectList;
begin
  Result:= '';
  try
    try
      if (ADOSS_ID < 1) or (ALAUID < 1) then
        Raise Exception.Create(cBadRequest);

      vList:= GMaintenanceCtrl.GetListGenReplication(ADOSS_ID, ALAUID, AREPLICWEB);

      if (vList <> nil) and (vList.Count <> 0) then
        begin
          for i:= 0 to vList.Count -1 do
            begin
              vGnkGenReplication:= TGnkGenReplication(vList.Items[i]);

              Buffer:= '';
              PropertyToXml(vGnkGenReplication, Buffer);
              vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vGnkGenReplication.ClassName, Buffer]);
            end;
        end;

      if vItXml <> '' then
        Result:= BuilXmlItems(ARequest, vItXml)
      else
        Result:= BuildXml([cBlsResultEmpty], [cNoValue], TGnkGenReplication.ClassName);
    except
      Raise;
    end;
  finally
    FreeAndNil(vList);
  end;
end;

function TGINKOIAMapperObj.GetListGenSubscribersToXml(
  const ARequest: TWebRequest; const ADOSS_ID, AREP_ID,
  AStatutPkg: integer): String;
var
  i: integer;
  Buffer, vItXml: String;
  vGnkGenSubscribers: TGnkGenSubscribers;
  vList: TObjectList;
begin
  Result:= '';
  try
    try
      vList:= GMaintenanceCtrl.GetListGenSubscribers(ADOSS_ID, AREP_ID, TStatutPkg(AStatutPkg));

      if (vList <> nil) and (vList.Count <> 0) then
        begin
          for i:= 0 to vList.Count -1 do
            begin
              vGnkGenSubscribers:= TGnkGenSubscribers(vList.Items[i]);

              Buffer:= '';
              PropertyToXml(vGnkGenSubscribers, Buffer);
              vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vGnkGenSubscribers.ClassName, Buffer]);
            end;
        end;

      if vItXml <> '' then
        Result:= BuilXmlItems(ARequest, vItXml)
      else
        Result:= BuildXml([cBlsResultEmpty], [cNoValue], TGnkGenSubscribers.ClassName);

    except
      Raise;
    end;
  finally
    FreeAndNil(vList);
  end;
end;

function TGINKOIAMapperObj.GetListGroupPumpToXml(const ARequest: TWebRequest;
  const ADOSS_ID: integer; Const AGCP_ID: integer): String;
var
  i: integer;
  vDos: TDossier;
  Buffer, vItXml: String;
  vSL: TStringList;
begin
  Result:= '';
  vSL:= TStringList.Create;
  try
    if ADOSS_ID > 0 then
      begin
        vSL.Text:= cFieldsGrpPump;
        vDos:= GMaintenanceCtrl.DossierByID[ADOSS_ID];
        if vDos <> nil then
          begin
            try
              GMaintenanceCtrl.LoadListGrpToDossier(vDos);

              { Groupe de Pump }
              for i:= 0 to vDos.CountGroupPump - 1 do
                begin
                  Buffer:= '';
                  PropertyToXml(vDos, Buffer, vSL);
                  PropertyToXml(vDos.GroupPump[i], Buffer, vSL);
                  vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vDos.GroupPump[i].ClassName, Buffer]);
                end;
              Result:= BuilXmlItems(ARequest, vItXml);
            except
              on E: Exception do
                Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
            end;
          end;
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

function TGINKOIAMapperObj.GetListGrpToXml(Const ARequest: TWebRequest): String;
var
  i: integer;
  Buffer, vItXml: String;
begin
  Result:= '';
  for i:= 0 to GMaintenanceCtrl.CountGrp - 1 do
    begin
      Buffer:= '';
      PropertyToXml(GMaintenanceCtrl.Groupe[i], Buffer);
      vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Groupe[i].ClassName, Buffer]);
    end;
  Result:= BuilXmlItems(ARequest, vItXml);
end;

function TGINKOIAMapperObj.GetListHoraireToXml(Const ARequest: TWebRequest): String;
var
  i, j: integer;
  Buffer, vItXml: String;
begin
  Result:= '';
  try
    for i:= 0 to GMaintenanceCtrl.CountSrv - 1 do
      begin
        for j:= 0 to GMaintenanceCtrl.Serveur[i].CountHoraire - 1 do
          begin
            Buffer:= '';
            PropertyToXml(GMaintenanceCtrl.Serveur[i].Horaire[j], Buffer);
            vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Serveur[i].Horaire[j].ClassName, Buffer]);
          end;
      end;
    Result:= BuilXmlItems(ARequest, vItXml);
  except
    on E: Exception do
      Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
  end;
end;

{===============================================================================
 function     : GetListJetonToXml
 Description  : permet la construction de la liste des jetons par magasin en
                flux XML à partir du controleur.
===============================================================================}
function TGINKOIAMapperObj.GetListJetonToXml(Const ARequest: TWebRequest): String;
var
  i: integer;
  Buffer, vItXml: String;
  vSL: TStringList;
begin
  Result:= '';
  vSL:= TStringList.Create;
  try
    vSL.Append('DOSS_ID');
    vSL.Append('DOSS_DATABASE');
    vSL.Append('EMET_ID');
    vSL.Append('EMET_NOM');
    vSL.Append('EMET_JETON');
    vSL.Append('EMET_TYPEREPLICATION');

    GMaintenanceCtrl.LoadListJetonPerEmet;
    for i:= 0 to GMaintenanceCtrl.CountEmet - 1 do
      begin
        if GMaintenanceCtrl.Emetteur[i].ADossier <> nil then
          begin
            Buffer:= '';
            PropertyToXml(GMaintenanceCtrl.Emetteur[i].ADossier, Buffer, vSL);
            PropertyToXml(GMaintenanceCtrl.Emetteur[i], Buffer, vSL);
            vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Emetteur[i].ClassName, Buffer]);
          end;
      end;
    Result:= BuilXmlItems(ARequest, vItXml);
  finally
    FreeAndNil(vSL);
  end;
end;

function TGINKOIAMapperObj.GetListMagasinToXml(Const ARequest: TWebRequest;
  Const AMAGA_ID: integer; const ADOSS_ID: integer): String;
var
  i: integer;
  vDos: TDossier;
  vMag: TMagasin;
  Buffer, vItXml: String;
begin
  Result:= '';
  if AMAGA_ID > 0 then
    begin
      { Un magasin }
      vMag:= GMaintenanceCtrl.MagasinByID[AMAGA_ID];
      if vMag <> nil then
        begin
          Buffer:= '';
          PropertyToXml(vMag, Buffer);
          vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vMag.ClassName, Buffer]);
        end;
    end
  else
    if ADOSS_ID > 0 then
      begin
        { Tous les magasins pour un dossier }
        vDos:= GMaintenanceCtrl.DossierByID[ADOSS_ID];
        if vDos <> nil then
          begin
            for i:= 0 to GMaintenanceCtrl.CountMag - 1 do
              begin
                if GMaintenanceCtrl.Magasin[i].MAGA_DOSSID = vDos.DOSS_ID then
                  begin
                    Buffer:= '';
                    PropertyToXml(GMaintenanceCtrl.Magasin[i], Buffer);
                    vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Magasin[i].ClassName, Buffer]);
                  end;
              end;
          end;
      end
    else
      begin
        { Tous les magasins }
        for i:= 0 to GMaintenanceCtrl.CountMag - 1 do
          begin
            Buffer:= '';
            PropertyToXml(GMaintenanceCtrl.Magasin[i], Buffer);
            vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Magasin[i].ClassName, Buffer]);
          end;
      end;
  if vItXml <> '' then
    Result:= BuilXmlItems(ARequest, vItXml)
  else
    Result:= BuildXml([cBlsResultEmpty], [cNoValue], TMagasin.ClassName);
end;

function TGINKOIAMapperObj.GetlistModeleMailToXml(
  const ARequest: TWebRequest): String;
var
  i: integer;
  vModeleMail: TModeleMail;
  vSearch: TSearching;
  vSL: TStringList;
  Buffer, vItXml: String;
begin
  Result:= '';
  vSearch:= TSearching.Create(GWSConfig.ServiceFileName);
  vSL:= TStringList.Create;
  vModeleMail:= TModeleMail.Create(nil);
  try
    vSearch.Searching(GWSConfig.ServicePath, '*.mail', False);
    if vSearch.NbFilesFound = 0 then
      Exit;
    for i:= Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
      begin
        if vSearch.TabInfoSearch[i].PathAndName <> '' then
          begin
            vSL.LoadFromFile(string(vSearch.TabInfoSearch[i].PathAndName));
            vModeleMail.MAIL_FILENAME:= string(vSearch.TabInfoSearch[i].PathAndName);
            vModeleMail.MAIL_OBJET:= vSL.Values['OBJET'];
            if vModeleMail.MAIL_OBJET <> '' then
              vSL.Delete(0);
            vModeleMail.MAIL_MESSAGE:= vSL.Text;
            Buffer:= '';
            PropertyToXml(vModeleMail, Buffer);
            vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [TModeleMail.ClassName, Buffer]);
          end;
      end;
    if vItXml <> '' then
      Result:= BuilXmlItems(ARequest, vItXml);
  finally
    FreeAndNil(vSearch);
    FreeAndNil(vSL);
    FreeAndNil(vModeleMail);
  end;
end;

function TGINKOIAMapperObj.GetListModuleGinkoiaToXml(Const ARequest: TWebRequest;
  const ADOSS_ID, AMAGA_MAGID_GINKOIA: integer; Const All: Boolean): String;
var
  i: integer;
  Buffer, vItXml: String;
  vSL: TStringList;
  vListModule: TObjectList;
  vMdl: TModuleGinkoia;
begin
  Result:= '';
  vSL:= TStringList.Create;
  try
    try
      if ADOSS_ID < 1 then
        Raise Exception.Create(cBadRequest);

      vSL.Append('DOSS_ID');
      vSL.Append('MAGA_MAGID_GINKOIA');
      vSL.Append('MODU_ID');
      vSL.Append('MODU_NOM');
      vSL.Append('UGG_ID');
      vSL.Append('UGM_MAGID');

      vListModule:= GMaintenanceCtrl.GetListModuleGinkoia(ADOSS_ID, AMAGA_MAGID_GINKOIA, All);
      for i:= 0 to vListModule.Count - 1 do
        begin
          Buffer:= '';
          vMdl:= TModuleGinkoia(vListModule.Items[i]);
          PropertyToXml(vMdl, Buffer);
          vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vMdl.ClassName, Buffer]);
        end;
      Result:= BuilXmlItems(ARequest, vItXml);
    except
      on E: Exception do
        Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
    end;
  finally
    FreeAndNil(vListModule);
    FreeAndNil(vSL);
  end;
end;

{===============================================================================
 function     : GetListModuleToXml
 Description  : permet la construction de la liste des modules en flux XML à
                partir du controleur.
===============================================================================}
function TGINKOIAMapperObj.GetListModuleToXml(Const ARequest: TWebRequest;
  Const AMAGA_ID: integer; Const ADOSS_ID: integer): String;
var
  i, j: integer;
  Buffer, vItXml: String;
  vDos: TDossier;
  vMdl: TModule;
  vSL: TStringList;
  vListModule: TObjectList;
begin
  Result:= '';
  vListModule:= nil;
  vSL:= TStringList.Create;
  try
    if AMAGA_ID > 0 then
      begin
        { Tous les modules pour un magasin }
        vListModule:= GMaintenanceCtrl.GetListModule(ADOSS_ID, AMAGA_ID);

        if vListModule <> nil then
          begin
            for i:= 0 to vListModule.Count - 1 do
              begin
                Buffer:= '';
                vMdl:= TModule(vListModule.Items[i]);
                PropertyToXml(vMdl, Buffer);
                vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vMdl.ClassName, Buffer]);
              end;
          end;
      end
    else
      begin
        { Tous les modules par magasin }

        vSL.Append('DOSS_ID');
        vSL.Append('DOSS_DATABASE');
        vSL.Append('MAGA_ID');
        vSL.Append('MAGA_NOM');
        vSL.Append('MODU_NOM');

        GMaintenanceCtrl.LoadListModulePerMag;

        for i:= 0 to GMaintenanceCtrl.CountMag - 1 do
          begin
            vDos:= GMaintenanceCtrl.DossierByID[GMaintenanceCtrl.Magasin[i].MAGA_DOSSID];
            for j:= 0 to GMaintenanceCtrl.Magasin[i].CountMdl - 1 do
              begin
                Buffer:= '';
                PropertyToXml(vDos, Buffer, vSL);
                PropertyToXml(GMaintenanceCtrl.Magasin[i], Buffer, vSL);
                PropertyToXml(GMaintenanceCtrl.Magasin[i].Module[j], Buffer, vSL);
                vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Magasin[i].ClassName, Buffer]);
              end;
          end;
      end;
    Result:= BuilXmlItems(ARequest, vItXml);
  finally
    FreeAndNil(vSL);
    if vListModule <> nil then
      FreeAndNil(vListModule);
  end;
end;

function TGINKOIAMapperObj.GetListSplittageLogToXml(
  const ARequest: TWebRequest): String;
var
  i: integer;
  vList: TObjectList;
  vGnkSplittageLog: TGnkSplittageLog;
  Buffer, vItXml: String;
begin
  Result:= '';
  vList:= GMaintenanceCtrl.GetListSplittageLog;
  try
    for i:= 0 to vList.Count - 1 do
      begin
        Buffer:= '';
        vGnkSplittageLog:= TGnkSplittageLog(vList.Items[i]);
        PropertyToXml(vGnkSplittageLog, Buffer);
        vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vGnkSplittageLog.ClassName, Buffer]);
      end;

    if vItXml <> '' then
      Result:= BuilXmlItems(ARequest, vItXml)
    else
      Result:= BuildXml([cBlsResultEmpty], [cNoValue], TGnkSplittageLog.ClassName);
  finally
    FreeAndNil(vList);
  end;
end;

function TGINKOIAMapperObj.GetListSrvToXml(Const ARequest: TWebRequest): String;
var
  i: integer;
  Buffer, vItXml: String;
begin
  Result:= '';

  for i:= 0 to GMaintenanceCtrl.CountSrv - 1 do
    begin
      Buffer:= '';
      PropertyToXml(GMaintenanceCtrl.Serveur[i], Buffer);
      vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Serveur[i].ClassName, Buffer]);
    end;
  Result:= BuilXmlItems(ARequest, vItXml);
end;

function TGINKOIAMapperObj.GetListSteMagPosteToXml(Const ARequest: TWebRequest;
  const ADOSS_ID: integer): String;
var
  i, j, k: integer;
  vDos: TDossier;
  Buffer, vItXml: String;
  vSL: TStringList;
begin
  Result:= '';
  vSL:= TStringList.Create;
  try
    if ADOSS_ID > 0 then
      begin
        vSL.Text:= cFieldsSteMagPoste;
        vDos:= GMaintenanceCtrl.DossierByID[ADOSS_ID];
        if vDos <> nil then
          begin
            try
              GMaintenanceCtrl.LoadListSteMagPosteToDossier(vDos);

              { Societes }
              for i:= 0 to vDos.CountSociete - 1 do
                begin
                  if vDos.Societe[i].CountMag = 0 then
                    begin
                      Buffer:= '';
                      PropertyToXml(vDos, Buffer, vSL);
                      PropertyToXml(vDos.Societe[i], Buffer, vSL);
                      vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vDos.Societe[i].ClassName, Buffer]);
                    end
                  else
                    begin
                      { Magasins }
                      for j:= 0 to vDos.Societe[i].CountMag - 1 do
                        begin
                          if vDos.Societe[i].Magasin[j].CountPoste = 0 then
                            begin
                              Buffer:= '';
                              PropertyToXml(vDos, Buffer, vSL);
                              PropertyToXml(vDos.Societe[i], Buffer, vSL);
                              PropertyToXml(vDos.Societe[i].Magasin[j], Buffer, vSL);
                              vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vDos.Societe[i].ClassName, Buffer]);
                            end
                          else
                            begin
                              { Postes }
                              for k:= 0 to vDos.Societe[i].Magasin[j].CountPoste - 1 do
                                begin
                                  Buffer:= '';
                                  PropertyToXml(vDos, Buffer, vSL);
                                  PropertyToXml(vDos.Societe[i], Buffer, vSL);
                                  PropertyToXml(vDos.Societe[i].Magasin[j], Buffer, vSL);
                                  PropertyToXml(vDos.Societe[i].Magasin[j].Poste[k], Buffer, vSL);
                                  vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vDos.Societe[i].ClassName, Buffer]);
                                end;
                            end;
                        end;
                    end;
                end;
              Result:= BuilXmlItems(ARequest, vItXml);
            except
              on E: Exception do
                Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
            end;
          end;
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

function TGINKOIAMapperObj.GetListSuiviSrvReplicationToXml(
  const ARequest: TWebRequest; const ASERV_ID: integer): String;
var
  i: integer;
  vSrv: TServeur;
  vParser: TParser;
  vSrvRep: TSrvReplication;
  vSL, vSLTraceur: TStringList;
  Buffer, vItXml: String;
  vList: TObjectList;
begin
  Result:= BuildXml([cBlsResult], [''], string(GetURI(ARequest)));
  vParser:= TParser.Create(nil);
  vSL:= TStringList.Create;
  vSLTraceur:= TStringList.Create;
  try
    vParser.ContentEncoding:= '';
    vParser.XmlREST:= False;
    vParser.SizeField:= 2000;
    try
      vSrv:= GMaintenanceCtrl.ServeurByID[ASERV_ID];
      if vSrv = nil then
        Raise Exception.Create('Serveur introuvable.');

      vList:= GMaintenanceCtrl.GetListSrvReplication(ASERV_ID);
      for i:= 0 to vList.Count - 1 do
        begin
          vSrvRep:= TSrvReplication(vList.Items[i]);

          if FileExists(vSrvRep.SVR_PATH) then
            begin
              vSLTraceur.Append('');
              vSLTraceur.Append('PathAndName = ' + vSrvRep.SVR_PATH);

              vSL.LoadFromFile(vSrvRep.SVR_PATH);
              vParser.ARequest:= vSL.Text;
              vParser.Execute(True);

              { Version }
              vSL.Text:= StringReplace(vSrvRep.SVR_PATH, '\', cRc, [rfReplaceAll]);
              vSrvRep.SVR_VERSION:= vSL.Strings[vSL.Count-3];

              if vParser.Erreur = '' then
                begin
                  vSLTraceur.Append('vParser.Execute = Ok');

                  { Date }
                  if vParser.ADataSet.FindField('XMLC_ShortDateTime') <> nil then
                    vSrvRep.SVR_DATE:= vParser.ADataSet.FieldByName('XMLC_ShortDateTime').AsString
                  else
                    if vParser.ADataSet.FindField('Date') <> nil then
                      vSrvRep.SVR_DATE:= vParser.ADataSet.FieldByName('Date').AsString;

                  { Erreur }
                  if vParser.ADataSet.FindField('LogItem') <> nil then
                    vSrvRep.SVR_ERR:= vParser.ADataSet.FieldByName('LogItem').AsString;

                  { DataBase et Sender }
                  if vParser.ADataSet.FindField('ContextItem') <> nil then
                    begin
                      if vParser.ADataSet.Locate('ID', 'DataBase', [loCaseInsensitive]) then
                        vSrvRep.SVR_DATABASE:= vParser.ADataSet.FieldByName('ContextItem').AsString;

                      if vParser.ADataSet.Locate('ID', 'Sender', [loCaseInsensitive]) then
                        vSrvRep.SVR_SENDER:= vParser.ADataSet.FieldByName('ContextItem').AsString;
                    end;
                end
              else
                begin
                  vSrvRep.SVR_ERR:= 'Fichier xml non conforme.';
                  vSLTraceur.Append(vSrvRep.SVR_ERR);
                end;
              Buffer:= '';
              PropertyToXml(vSrvRep, Buffer);
              vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vSrvRep.ClassName, Buffer]);
            end;
        end;

      if vItXml <> '' then
        Result:= BuilXmlItems(ARequest, vItXml)
      else
        Result:= BuildXml([cBlsResultEmpty], [cNoValue], TSrvReplication.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
    end;
  finally
    GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '.Traceur',
                       vSLTraceur, GWSConfig.Traceur);
    FreeAndNil(vParser);
    FreeAndNil(vSL);
    FreeAndNil(vList);
    FreeAndNil(vSLTraceur);
  end;
end;

function TGINKOIAMapperObj.GetListVersionToXml(Const ARequest: TWebRequest): String;
var
  i: integer;
  Buffer, vItXml: String;
begin
  Result:= '';
  for i:= 0 to GMaintenanceCtrl.CountVer - 1 do
    begin
      Buffer:= '';
      PropertyToXml(GMaintenanceCtrl.Version[i], Buffer);
      vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Version[i].ClassName, Buffer]);
    end;
  Result:= BuilXmlItems(ARequest, vItXml);
end;

function TGINKOIAMapperObj.GetNewIdentToXml(const ARequest: TWebRequest;
  const ADOSS_ID: integer): String;
begin
  try
    if ADOSS_ID < 1 then
      Raise Exception.Create(cBadRequest);

    Result:= GMaintenanceCtrl.GetNewIdentGinkoia(ADOSS_ID);
    Result:= BuildXml(['EMET_IDENT'], [Result], string(GetURI(ARequest)));
  except
    on E: Exception do
      Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
  end;
end;

function TGINKOIAMapperObj.GetNewPlageToXml(const ARequest: TWebRequest;
  const ADOSS_ID: integer): String;
begin
  try
    if ADOSS_ID < 1 then
      Raise Exception.Create(cBadRequest);

    Result:= GMaintenanceCtrl.GetNewPlageGinkoia(ADOSS_ID);
    Result:= BuildXml(['EMET_PLAGE'], [Result], string(GetURI(ARequest)));
  except
    on E: Exception do
      Result:= BuildXml([cBlsExcept], [E.Message], string(GetURI(ARequest)));
  end;
end;

function TGINKOIAMapperObj.GetDateInstallation(const AEmet_GUID: string): string;
begin
  Result:= GMaintenanceCtrl.GetMaintenanceEmetDateInstallation(AEmet_GUID);
end;

function TGINKOIAMapperObj.GetGenReplicationToXml(const ARequest: TWebRequest;
  const ADOSS_ID, AREP_ID: integer): String;
var
  Buffer, vItXml: String;
  vGnkGenReplication: TGnkGenReplication;
begin
  Result:= '';
  vGnkGenReplication:= nil;
  try
    OnPropertyToXml:= pOnPropertyToXml;
    vGnkGenReplication:= GMaintenanceCtrl.GetGenReplication(ADOSS_ID, AREP_ID);
    if vGnkGenReplication <> nil then
      begin
        Buffer:= '';
        PropertyToXml(vGnkGenReplication, Buffer);
        vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vGnkGenReplication.ClassName, Buffer]);
      end;

    if vItXml <> '' then
      Result:= BuilXmlItems(ARequest, vItXml)
    else
      Result:= BuildXml([cBlsResultEmpty], [cNoValue], TGnkGenReplication.ClassName);

  finally
    if vGnkGenReplication <> nil then
      FreeAndNil(vGnkGenReplication);
    OnPropertyToXml:= nil;
  end;
end;

function TGINKOIAMapperObj.GetJetonLame(const ADOSS_ID: integer): String;
var
  Buffer: String;
begin
  Result:= '';
  try
    Buffer := GMaintenanceCtrl.JetonLame(ADOSS_ID);
    Result := BuildXml([cBlsResult], [Buffer], 'GetJetonLame');
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans GetJetonLame', E.Message]);
  end;
end;

function TGINKOIAMapperObj.GetStatutSplittageProcessToXml(
  const ARequest: TWebRequest): String;
var
  Buffer: String;
begin
  if GMaintenanceCtrl.IsSplittageProcessActivate then
    Buffer:= '1'
  else
    Buffer:= '0';
  Result:= BuildXml([cBlsResult], [Buffer], 'TGnkSplittageProcess');
end;

function TGINKOIAMapperObj.InitialisationPostes(const ACMD: String): string;
begin
  Result := GMaintenanceCtrl.SetMaintenanceInitialisationPostes(ACMD);
end;

procedure TGINKOIAMapperObj.pOnPropertyToXml(AName: String;
  var Value: String);
begin
  if Value = '0' then
    Value:= '';
end;

function TGINKOIAMapperObj.PriorityOrdreSplittageLog(
  const ARequest: TWebRequest; const ANOSPLIT, APriorityOrdre: integer): String;
begin
  GMaintenanceCtrl.PriorityOrdreSplittageLog(ANOSPLIT, TPriorityOrdre(APriorityOrdre));
  Result:= BuildXml([cBlsResult], [cSucces]);
end;

function TGINKOIAMapperObj.RecupBase(const ARequest: TWebRequest;
  Const AUSERNAME, ATYPESPLIT: String; const AEMET_ID, ACLEARFILES, ABASE,
  AMAIL: integer): String;
var
  vEMET: TEmetteur;
  Buffer: String;
begin
  Result:= '';
  vEMET:= GMaintenanceCtrl.EmetteurByID[AEMET_ID];
  if vEMET <> nil then
    begin
      try
        { Ajout d'une demande de recuperation de base ou de splittage }
        GMaintenanceCtrl.AddSplittage(vEMET, AUSERNAME, ATYPESPLIT, ACLEARFILES, Buffer, ABASE, AMAIL);
        Result:= BuildXml([cBlsResult], [Buffer], 'TGnkSplittageLog');
      except
        on E: Exception do
          Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans RecupBase', E.Message], TGnkSplittageLog.ClassName);
      end;
    end;
end;

function TGINKOIAMapperObj.RecycleDataWS: String;
begin
  GMaintenanceCtrl.IntializeCtrl;
end;

function TGINKOIAMapperObj.GetListRaisonToXml(const ARequest: TWebRequest;
  const ARAIS_ID: integer): String;
var
  i: integer;
  vRaison: TRaison;
  Buffer, vItXml: String;
begin
  Result:= '';
  if ARAIS_ID > 0 then
    begin
      { Une Raison }
      vRaison:= GMaintenanceCtrl.RaisonByID[ARAIS_ID];
      if vRaison <> nil then
        begin
          Buffer:= '';
          PropertyToXml(vRaison, Buffer);
          vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [vRaison.ClassName, Buffer]);
        end;
    end
  else
    begin
      { Toutes les raisons }
      for i:= 0 to GMaintenanceCtrl.CountRaison - 1 do
        begin
          Buffer:= '';
          PropertyToXml(GMaintenanceCtrl.Raison[i], Buffer);
          vItXml:= vItXml + #13#10 + Format(cBaliseItemURI, [GMaintenanceCtrl.Raison[i].ClassName, Buffer]);
        end;
    end;
  if vItXml <> '' then
    Result:= BuilXmlItems(ARequest, vItXml);
end;

function TGINKOIAMapperObj.SendMailEmetteur(const ARequest: String): String;
var
  vPort: integer;
  vEmet: TEmetteur;
  vSLMess, vSLDest: TStringList;
  Buffer, vSendReport: String;
begin
  vSendReport:= cSucces;
  vPort:= 25;
  if dmMaintenance.GetMaintenanceParamInteger(4,1) <> 0 then
    vPort:= dmMaintenance.GetMaintenanceParamInteger(4,1);
  vSLMess:= TStringList.Create;
  vSLDest:= TStringList.Create;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.FindField('EMET_ID') = nil) or
         (AParser.ADataSet.FindField('MAIL_FILENAME') = nil) then
        Raise Exception.Create(cBadRequest);

      if (AParser.ADataSet.RecordCount <> 0) and
         (not FileExists(AParser.ADataSet.FieldByName('MAIL_FILENAME').AsString)) then
        Raise Exception.Create('Le modèle de mail est introuvable.');

      try
        while not AParser.ADataSet.Eof do
          begin
            vEmet:= GMaintenanceCtrl.EmetteurByID[AParser.ADataSet.FieldByName('EMET_ID').AsInteger];
            if vEmet <> nil then
              begin
                { Destinataire }
                vSLDest.Text:= vEmet.EMET_EMAIL;

                { Objet et Message }
                vSLMess.LoadFromFile(AParser.ADataSet.FieldByName('MAIL_FILENAME').AsString);
                Buffer:= vSLMess.Values['OBJET'];
                vSLMess.Delete(0);
                try
                  SendMail(dmMaintenance.GetMaintenanceParamString(1,1),
                           dmMaintenance.GetMaintenanceParamString(3,1),
                           dmMaintenance.GetMaintenanceParamString(2,1),
                           GWSConfig.Options.Values['FROM'],
                           GWSConfig.Options.Values['REPLYTO'],
                           Buffer, vSLDest, vSLMess, nil, False, nil, nil,
                           vPort);
                except
                  on E: Exception do
                    vSendReport:= vSendReport + cRC + vEmet.EMET_NOM + ' : Echec de l''envoi du mail. Email : ' + vEmet.EMET_EMAIL;
                end;
              end;
            AParser.ADataSet.Next;
          end;
      finally
        Result:= BuildXml([cBlsResult], [vSendReport]);
      end;
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SendMailEmetteur', E.Message], TEmetteur.ClassName);
    end;
  finally
    FreeAndNil(vSLMess);
    FreeAndNil(vSLDest);
  end;
end;

function TGINKOIAMapperObj.SendMailTest(const ARequest: String): String;
var
  vPort: integer;
  vSLMess, vSLDest: TStringList;
  Buffer, vSendReport: String;
begin
  vSendReport:= cSucces;
  vPort:= 25;
  if dmMaintenance.GetMaintenanceParamInteger(4,1) <> 0 then
    vPort:= dmMaintenance.GetMaintenanceParamInteger(4,1);
  vSLMess:= TStringList.Create;
  vSLDest:= TStringList.Create;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.RecordCount <> 0) and
         (not FileExists(AParser.ADataSet.FieldByName('MAIL_FILENAME').AsString)) then
        Raise Exception.Create('Le modèle de mail est introuvable.');

      try
        while not AParser.ADataSet.Eof do
        begin
          { Destinataire }
          vSLDest.Text:= dmMaintenance.GetMaintenanceParamString(1,4);

          { Objet et Message }
          vSLMess.LoadFromFile(AParser.ADataSet.FieldByName('MAIL_FILENAME').AsString);
          Buffer:= vSLMess.Values['OBJET'];
          vSLMess.Delete(0);
          try
            SendMail(dmMaintenance.GetMaintenanceParamString(1,1),
                     dmMaintenance.GetMaintenanceParamString(3,1),
                     dmMaintenance.GetMaintenanceParamString(2,1),
                     GWSConfig.Options.Values['FROM'],
                     GWSConfig.Options.Values['REPLYTO'],
                     Buffer, vSLDest, vSLMess, nil, False, nil, nil,
                     vPort);
          except on E: Exception do
              vSendReport:= vSendReport + cRC + ' : Echec de l''envoi du mail test. Email : ' + dmMaintenance.GetMaintenanceParamString(4,1);
          end;
        end;
        AParser.ADataSet.Next;
      finally
        Result:= BuildXml([cBlsResult], [vSendReport]);
      end;
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SendMailTest', E.Message], TEmetteur.ClassName);
    end;
  finally
    FreeAndNil(vSLMess);
    FreeAndNil(vSLDest);
  end;
end;

procedure TGINKOIAMapperObj.SetEtatSplittage(
  const AActivate: integer);
begin
  GMaintenanceCtrl.SetActiveThrdCtrlSplittage(AActivate);
end;

function TGINKOIAMapperObj.SetConnexion(const ARequest: String): String;
var
  vEmet: TEmetteur;
  vCon: TConnexion;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vCon:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('EMET_ID') = nil then
      Raise Exception.Create(cBadRequest);

    if AParser.ADataSet.FieldByName('EMET_ID').AsInteger < 1 then
      Raise Exception.Create('Emetteur introuvable.');

    vEmet:= GMaintenanceCtrl.EmetteurByID[AParser.ADataSet.FieldByName('EMET_ID').AsInteger];

    if (vEmet <> nil) and (AParser.ADataSet.FieldByName('CON_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vCon:= vEmet.ConnexionByID[AParser.ADataSet.FieldByName('CON_ID').AsInteger];
      end;

    if vCon = nil then
      begin
        vUk:= ukInsert;
        vCon:= TConnexion.Create(nil);
        vCon.AEmetteur:= vEmet;
      end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TConnexion.ClassName) then
      begin
        MappingProperty(TComponent(vCon));
        vCon.MAJ(vUk);

        if vUk = ukInsert then
          vEmet.AppendConnexion(vCon);
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TConnexion.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetEmetteur', E.Message], TConnexion.ClassName);
  end;
end;

function TGINKOIAMapperObj.SetDateInstallation(
  const AEmet_GUID: String; Const AEmet_Install: TDateTime): string;
begin
  Result := GMaintenanceCtrl.SetMaintenanceEmetDateInstallation(AEmet_GUID, AEmet_Install);
end;

function TGINKOIAMapperObj.SetDossier(Const ARequest, ACHANGEDOS: String): String;
var
  vDos, vOldDos: TDossier;
  vGrp: TGroupe;
  vSrv: TServeur;
  vUk: TUpdateKind;
  i:integer;
  a:string;
begin
  vUk:= ukInsert;
  vOldDos:= nil;
  vDos:= nil;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.FindField('DOSS_ID') <> nil) and
         (AParser.ADataSet.FieldByName('DOSS_ID').AsInteger > 0) then
        begin
          vUk:= ukModify;
          vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];
        end;

      if vDos = nil then
        begin
          vUk:= ukInsert;
          vDos:= TDossier.Create(nil);
        end;

      if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TDossier.ClassName) then
        begin
          if (ACHANGEDOS <> '') and (ACHANGEDOS = '1') then
            begin
              vOldDos:= TDossier.Create(nil);
              CloneProperty(vDos, vOldDos);
              vOldDos.AServeur:= vDos.AServeur;
              vOldDos.AGroupe:= vDos.AGroupe;
            end;

          vDos.AServeur:= GMaintenanceCtrl.ServeurByID[AParser.ADataSet.FieldByName('DOSS_SERVID').Asinteger];
          vDos.AGroupe:= GMaintenanceCtrl.GroupeByID[AParser.ADataSet.FieldByName('DOSS_GROUID').Asinteger];

          if vUk = ukInsert then
            begin
              if vDos.AServeur = nil then
                begin
                  vSrv:= TServeur.Create(nil);
                  MappingProperty(TComponent(vSrv));
                  vSrv.MAJ(ukInsert);
                  GMaintenanceCtrl.AddSrv(vSrv);
                  vDos.AServeur:= vSrv;
                end;

              if vDos.AGroupe = nil then
                begin
                  vGrp:= TGroupe.Create(nil);
                  MappingProperty(TComponent(vGrp));
                  vGrp.MAJ(ukInsert);

                  GMaintenanceCtrl.AddGrp(vGrp);
                  vDos.AGroupe:= vGrp;
                end;
            end;

          MappingProperty(TComponent(vDos));
          vDos.MAJ(vUk);
          GMaintenanceCtrl.AppendDossier(vDos);

          {for i := 0 to  AParser.ADataSet.FieldCount-1 do
            begin
               a := AParser.ADataSet.Fields[i].FieldName;
            end;
          }
          if (vUk = ukInsert) and (AParser.ADataSet.FindField('DOSS_EASY').AsInteger=1)
            then
              // rien de spécial...
            else
              begin



          if (vUk = ukInsert) and (AParser.ADataSet.FindField('CHEMIN_BV') <> nil) and
             (not AParser.ADataSet.FieldByName('CHEMIN_BV').IsNull) then
            GMaintenanceCtrl.CreateBase(AParser.ADataSet.FieldByName('CHEMIN_BV').AsString, vDos)
          else
            if (vOldDos <> nil) and (vDos.DOSS_CHEMIN <> '') and
               (vOldDos.DOSS_CHEMIN <> vDos.DOSS_CHEMIN) then
              GMaintenanceCtrl.ChangeDossier(vOldDos, vDos);

          //GMaintenanceCtrl.AppendDossier(vDos);


              end;


        end
      else
        Raise Exception.Create(cClassNameErr);

      Result:= BuildXml([cBlsResult], [cSucces], TDossier.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetDossier', E.Message], TDossier.ClassName);
    end;
  finally
    if vOldDos <> nil then
      FreeAndNil(vOldDos);
  end;
end;

function TGINKOIAMapperObj.SetEmetteur(Const ARequest: String): String;
var
  vDos: TDossier;
  vEmet, vEmetZero: TEmetteur;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vDos:= nil;
  vEmet:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('EMET_DOSSID') <> nil then
      vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('EMET_DOSSID').AsInteger];

    if (vDos <> nil) and (AParser.ADataSet.FieldByName('EMET_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vEmet:= GMaintenanceCtrl.EmetteurByID[AParser.ADataSet.FieldByName('EMET_ID').AsInteger];
      end;

    if vEmet = nil then
      begin
        vUk:= ukInsert;
        vEmet:= TEmetteur.Create(nil);
        if vDos <> nil then
          vEmet.ADossier:= vDos;

        vEmetZero:= GMaintenanceCtrl.EmetteurByALGOL[vEmet.EMET_DOSSID];
        if vEmetZero <> nil then
          vEmet.AVersion:= vEmetZero.AVersion;
      end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TEmetteur.ClassName) then
      begin
        MappingProperty(TComponent(vEmet));
        vEmet.MAJ(vUk);

        if vUk = ukInsert then
          begin
            GMaintenanceCtrl.AppendEmetteur(vEmet);
            if vDos <> nil then
              vDos.AppendEmetteur(vEmet);
          end;
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TEmetteur.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetEmetteur', E.Message], TEmetteur.ClassName);
  end;
end;

function TGINKOIAMapperObj.SetExecuteProcess(const ARequest: String): String;
begin
//  try
//    AParser.ARequest:= ARequest;
//    AParser.Execute;
//    AParser.ADataSet.First;
//
//    if AParser.ADataSet.FindField('DOSS_ID') <> nil then
//      vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];
//
//    if (vDos <> nil) and (AParser.ADataSet.FieldByName('EMET_ID').AsInteger > 0) then
//      begin
//        vUk:= ukModify;
//        vEmet:= GMaintenanceCtrl.EmetteurByID[AParser.ADataSet.FieldByName('EMET_ID').AsInteger];
//      end;
//
//    if vEmet = nil then
//      begin
//        vUk:= ukInsert;
//        vEmet:= TEmetteur.Create(nil);
//        if vDos <> nil then
//          vEmet.ADossier:= vDos;
//
//        vEmetZero:= GMaintenanceCtrl.EmetteurByALGOL[vEmet.DOSS_ID];
//        if vEmetZero <> nil then
//          vEmet.AVersion:= vEmetZero.AVersion;
//      end;
//
//    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TEmetteur.ClassName) then
//      begin
//        MappingProperty(TComponent(vEmet));
//        vEmet.MAJ(vUk);
//
//        if vUk = ukInsert then
//          begin
//            GMaintenanceCtrl.AppendEmetteur(vEmet);
//            if vDos <> nil then
//              vDos.AppendEmetteur(vEmet);
//          end;
//      end
//    else
//      Raise Exception.Create(cClassNameErr);
//
//    Result:= BuildXml([cBlsResult], [cSucces], TEmetteur.ClassName);
//  except
//    on E: Exception do
//      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetEmetteur', E.Message], TEmetteur.ClassName);
//  end;

end;

function TGINKOIAMapperObj.SetGenLiaiRepli(const ARequest: String): String;
var
  vGnkGenLiaiRepli: TGnkGenLiaiRepli;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vGnkGenLiaiRepli:= nil;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.Fields.FindField('DOSS_ID') = nil) or
         (AParser.ADataSet.FieldByName('DOSS_ID').AsInteger < 1) then
        Raise Exception.Create(cBadRequest);

      if (AParser.ADataSet.Fields.FindField('GLR_ID') <> nil) and
         (AParser.ADataSet.FieldByName('GLR_ID').AsInteger > 0) then
        vUk:= ukModify;

      if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TGnkGenLiaiRepli.ClassName) then
        begin
          vGnkGenLiaiRepli:= TGnkGenLiaiRepli.Create(nil);
          vGnkGenLiaiRepli.ADmGINKOIA:= GMaintenanceCtrl.GetNewdmGINKOIAByDOSS_ID(AParser.ADataSet.FieldByName('DOSS_ID').AsInteger);

          MappingProperty(TComponent(vGnkGenLiaiRepli));
          vGnkGenLiaiRepli.MAJ(vUk);
        end
      else
        Raise Exception.Create(cClassNameErr);

      Result:= BuildXml([cBlsResult], [cSucces], TGnkGenLiaiRepli.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetGenLiaiRepli', E.Message], TGnkGenLiaiRepli.ClassName);
    end;
  finally
    if vGnkGenLiaiRepli <> nil then
      FreeAndNil(vGnkGenLiaiRepli);
  end;
end;

function TGINKOIAMapperObj.SetGenProviders(const ARequest: String): String;
var
  vGnkGenProviders: TGnkGenProviders;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vGnkGenProviders:= nil;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.Fields.FindField('DOSS_ID') = nil) or
         (AParser.ADataSet.FieldByName('DOSS_ID').AsInteger < 1) then
        Raise Exception.Create(cBadRequest);

      if (AParser.ADataSet.Fields.FindField('PRO_ID') <> nil) and
         (AParser.ADataSet.FieldByName('PRO_ID').AsInteger > 0) then
        vUk:= ukModify;

      if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TGnkGenProviders.ClassName) then
        begin
          vGnkGenProviders:= TGnkGenProviders.Create(nil);
          vGnkGenProviders.ADmGINKOIA:= GMaintenanceCtrl.GetNewdmGINKOIAByDOSS_ID(AParser.ADataSet.FieldByName('DOSS_ID').AsInteger);

          MappingProperty(TComponent(vGnkGenProviders));
          vGnkGenProviders.MAJ(vUk);
        end
      else
        Raise Exception.Create(cClassNameErr);

      Result:= BuildXml([cBlsResult], [cSucces], TGnkGenProviders.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetGenProviders', E.Message], TGnkGenProviders.ClassName);
    end;
  finally
    if vGnkGenProviders <> nil then
      FreeAndNil(vGnkGenProviders);
  end;
end;

function TGINKOIAMapperObj.SetGenReplication(const ARequest: String): String;
var
  vGenReplication: TGnkGenReplication;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vGenReplication:= nil;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.Fields.FindField('DOSS_ID') = nil) or
         (AParser.ADataSet.FieldByName('DOSS_ID').AsInteger < 1) then
        Raise Exception.Create(cBadRequest);

      if (AParser.ADataSet.Fields.FindField('REP_ID') <> nil) and
         (AParser.ADataSet.FieldByName('REP_ID').AsInteger > 0) then
        vUk:= ukModify;

      if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TGnkGenReplication.ClassName) then
        begin
          vGenReplication:= TGnkGenReplication.Create(nil);
          vGenReplication.ADmGINKOIA:= GMaintenanceCtrl.GetNewdmGINKOIAByDOSS_ID(AParser.ADataSet.FieldByName('DOSS_ID').AsInteger);

          MappingProperty(TComponent(vGenReplication));
          vGenReplication.MAJ(vUk);
        end
      else
        Raise Exception.Create(cClassNameErr);

      Result:= BuildXml([cBlsResult], [cSucces], TGnkGenReplication.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetGenReplication', E.Message], TGnkGenReplication.ClassName);
    end;
  finally
    if vGenReplication <> nil then
      FreeAndNil(vGenReplication);
  end;
end;

function TGINKOIAMapperObj.SetGenSubscribers(const ARequest: String): String;
var
  vGnkGenSubscribers: TGnkGenSubscribers;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vGnkGenSubscribers:= nil;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      if (AParser.ADataSet.Fields.FindField('DOSS_ID') = nil) or
         (AParser.ADataSet.FieldByName('DOSS_ID').AsInteger < 1) then
        Raise Exception.Create(cBadRequest);

      if (AParser.ADataSet.Fields.FindField('SUB_ID') <> nil) and
         (AParser.ADataSet.FieldByName('SUB_ID').AsInteger > 0) then
        vUk:= ukModify;

      if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TGnkGenSubscribers.ClassName) then
        begin
          vGnkGenSubscribers:= TGnkGenSubscribers.Create(nil);
          vGnkGenSubscribers.ADmGINKOIA:= GMaintenanceCtrl.GetNewdmGINKOIAByDOSS_ID(AParser.ADataSet.FieldByName('DOSS_ID').AsInteger);

          MappingProperty(TComponent(vGnkGenSubscribers));
          vGnkGenSubscribers.MAJ(vUk);
        end
      else
        Raise Exception.Create(cClassNameErr);

      Result:= BuildXml([cBlsResult], [cSucces], TGnkGenSubscribers.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetGenProviders', E.Message], TGnkGenSubscribers.ClassName);
    end;
  finally
    if vGnkGenSubscribers <> nil then
      FreeAndNil(vGnkGenSubscribers);
  end;
end;

function TGINKOIAMapperObj.SetGroupPump(const ARequest: String): String;
var
  vDos: TDossier;
  vGrp: TGroupPump;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vDos:= nil;
  vGrp:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('DOSS_ID') <> nil then
      vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];

    if (vDos <> nil) and (AParser.ADataSet.Fields.FindField('GCP_ID') <> nil) and
       (AParser.ADataSet.FieldByName('GCP_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vGrp:= vDos.GroupPumpByID[AParser.ADataSet.FieldByName('GCP_ID').AsInteger];
      end;

    if vGrp = nil then
      begin
        vUk:= ukInsert;
        vGrp:= TGroupPump.Create(nil);
        if vDos <> nil then
          vGrp.ADossier:= vDos;
      end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TGroupPump.ClassName) then
      begin
        MappingProperty(TComponent(vGrp));
        vGrp.MAJ(vUk);

        if (vUk = ukInsert) and (vDos <> nil) then
          vDos.AppendGroupPump(vGrp);
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TGroupPump.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetGroupPump', E.Message], TGroupPump.ClassName);
  end;
end;

function TGINKOIAMapperObj.SetHoraire(const ARequest: String): String;
var
  vSrv: TServeur;
  vHor: THoraire;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vHor:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('PRHO_SERVID') <> nil then
      vSrv:= GMaintenanceCtrl.ServeurByID[AParser.ADataSet.FieldByName('PRHO_SERVID').AsInteger]
    else
      Raise Exception.Create(cBadRequest);

    if (AParser.ADataSet.FindField('PRHO_ID') <> nil) and
       (AParser.ADataSet.FieldByName('PRHO_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vHor:= vSrv.HoraireByID[AParser.ADataSet.FieldByName('PRHO_ID').AsInteger];
      end;

    if vHor = nil then
      begin
        vUk:= ukInsert;
        vHor:= THoraire.Create(nil);
      end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(THoraire.ClassName) then
      begin
        MappingProperty(TComponent(vHor));
        vHor.MAJ(vUk);

        if vSrv <> nil then
          vSrv.AppendHoraire(vHor);
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], THoraire.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetHoraire', E.Message], THoraire.ClassName);
  end;
end;

function TGINKOIAMapperObj.SetMagasin(Const ARequest: String): String;
var
  vDos: TDossier;
  vMag: TMagasin;
  vUk: TUpdateKind;
  vSoc: TSociete;
begin
  vUk:= ukInsert;
  vDos:= nil;
  vMag:= nil;
  vSoc:=nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('DOSS_ID') <> nil then
      vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];

    if AParser.ADataSet.FindField('MAG_SOCID') <> nil then
      vSoc:= vDos.SocieteByID[AParser.ADataSet.FieldByName('MAG_SOCID').AsInteger];

    if AParser.ADataSet.FindField('ACTION').AsInteger = cActionModify then  //SR 24/03/2014 : Correction pour ne plus avoir de doublon
    begin
      if (vDos <> nil) and (AParser.ADataSet.Fields.FindField('MAGA_ID') <> nil) and
        (AParser.ADataSet.FieldByName('MAGA_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vMag:= vDos.MagasinByID[AParser.ADataSet.FieldByName('MAGA_ID').AsInteger];
      end;

      if (vMag = nil) and (vDos <> nil) then  //SR : Dans ce cas il va falloir recharger.
      begin
        GMaintenanceCtrl.LoadListSteMagPosteToDossier(vDos);
        vUk:= ukModify;
        vMag:= vDos.MagasinByID[AParser.ADataSet.FieldByName('MAGA_ID').AsInteger];
      end;

      if vMag = nil then  //SR : Dans ce cas on met une erreur.
      begin
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetMagasin', 'perte de mémoire'], TMagasin.ClassName);
        Exit;
      end;
    end
    else
    begin
      if AParser.ADataSet.FindField('ACTION').AsInteger = cActionInsert then  //SR 24/03/2014 : Correction pour ne plus avoir de doublon
      begin
        vUk:= ukInsert;
        vMag:= TMagasin.Create(nil);
        if vDos <> nil then
          vMag.ADossier:= vDos;
      end;
    end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TMagasin.ClassName) then
      begin
        MappingProperty(TComponent(vMag));
        vMag.MAJ(vUk);

        if vUk = ukInsert then
          begin
            if vSoc <> nil then
              vSoc.AppendMag(vMag);
            if vDos <> nil then
              vDos.AppendMag(vMag);
            GMaintenanceCtrl.AppendMagasin(vMag);
            GMaintenanceCtrl.CreateMdlGinkoiaToMaintenance(vMag.MAGA_ID);
          end;
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TMagasin.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetMagasin', E.Message], TMagasin.ClassName);
  end;
end;

function TGINKOIAMapperObj.SetModule(const ARequest: String): String;
var
  vDos: TDossier;
  vMag: TMagasin;
  vMod: TModule;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vMag:= nil;
  vMod:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('DOSS_ID') <> nil then
      begin
        vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];
        if (vDos <> nil) and  (AParser.ADataSet.FindField('MAG_ID') <> nil) then
          vMag:= vDos.MagasinByID[AParser.ADataSet.FieldByName('MAG_ID').AsInteger];
      end;

    if (vMag <> nil) and (AParser.ADataSet.FieldByName('MOD_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vMod:= vMag.ModuleByID[AParser.ADataSet.FieldByName('MOD_ID').AsInteger];
      end;

    if vMod = nil then
      begin
        vUk:= ukInsert;
        vMod:= TModule.Create(nil);
      end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TModule.ClassName) then
      begin
        MappingProperty(TComponent(vMod));
        vMod.MAJ(vUk);
        if (vUk = ukInsert) and (vMag <> nil) then
          begin
            vMag.AppendMdl(vMod);
            GMaintenanceCtrl.AppendModule(vMod);
          end;
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TModule.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetModule', E.Message], TModule.ClassName);
  end;
end;

function TGINKOIAMapperObj.SetModuleGinkoia(const ARequest: String): String;
var
  vDos: TDossier;
  vMldG: TModuleGinkoia;
begin
  vDos:= nil;
  vMldG:= nil;
  try
    try
      AParser.ARequest:= ARequest;
      AParser.Execute;
      AParser.ADataSet.First;

      vMldG:= TModuleGinkoia.Create(nil);
      if AParser.ADataSet.FindField('DOSS_ID') <> nil then
        vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];

      vMldG.ADossier:= vDos;

      if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TModuleGinkoia.ClassName) then
        begin
          MappingProperty(TComponent(vMldG));
          vMldG.MAJ(ukModify);
        end
      else
        Raise Exception.Create(cClassNameErr);

      Result:= BuildXml([cBlsResult], [cSucces], TModuleGinkoia.ClassName);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetModuleGinkoia', E.Message], TModuleGinkoia.ClassName);
    end;
  finally
    FreeAndNil(vMldG);
  end;
end;

function TGINKOIAMapperObj.SetPoste(Const ARequest: String): String;
var
  vDos: TDossier;
  vMag: TMagasin;
  vPoste: TPoste;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vDos:= nil;
  vMag:= nil;
  vPoste:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('DOSS_ID') <> nil then
    begin
      vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];
      if (vDos <> nil) and (AParser.ADataSet.FindField('MAGA_ID') <> nil) then
        vMag:= vDos.MagasinByID[AParser.ADataSet.FieldByName('MAGA_ID').AsInteger];
    end;

    if AParser.ADataSet.FindField('ACTION').AsInteger = cActionModify then  //SR 24/03/2014 : Correction pour ne plus avoir de doublon
    begin
      if (vMag <> nil) and (AParser.ADataSet.Fields.FindField('POST_POSID') <> nil) and     //SR - 01/09/2016 - Correction suite mise en prod
         (AParser.ADataSet.FieldByName('POST_POSID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vPoste:= vMag.PosteByID[AParser.ADataSet.FieldByName('POST_POSID').AsInteger];
      end;

      if (vPoste = nil) and (vDos <> nil) then  //SR : Dans ce cas il va falloir recharger.
      begin
        GMaintenanceCtrl.LoadListSteMagPosteToDossier(vDos);
        vUk:= ukModify;
        if (vDos <> nil) and (AParser.ADataSet.FindField('MAGA_ID') <> nil) then      //SR - 01/09/2016 - Correction suite recylage
          vMag:= vDos.MagasinByID[AParser.ADataSet.FieldByName('MAGA_ID').AsInteger];

        if (vMag <> nil) then
          vPoste:= vMag.PosteByID[AParser.ADataSet.FieldByName('POST_POSID').AsInteger]
        else
        begin
          Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetPoste', 'Perte de mémoire pour le magasin.'], TPoste.ClassName);
          Exit;
        end;
      end;

      if vPoste = nil then  //SR : Dans ce cas on met une erreur.
      begin
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetPoste', 'perte de mémoire'], TPoste.ClassName);
        Exit;
      end;
    end
    else
    begin
      if AParser.ADataSet.FindField('ACTION').AsInteger = cActionInsert then  //SR 24/03/2014 : Correction pour ne plus avoir de doublon
      begin
        vUk:= ukInsert;
        vPoste:= TPoste.Create(nil);
        if vMag <> nil then
          vPoste.AMagasin := vMag;
      end;
    end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TPoste.ClassName) then
      begin
        MappingProperty(TComponent(vPoste));
        vPoste.MAJ(vUk);

        if vMag <> nil then
          vMag.AppendPoste(vPoste);
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TPoste.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetPoste', E.Message], TPoste.ClassName);
  end;
end;


function TGINKOIAMapperObj.SetSociete(Const ARequest: String): String;
var
  vDos: TDossier;
  vSte: TSociete;
  vUk: TUpdateKind;
begin
  vUk:= ukInsert;
  vDos:= nil;
  vSte:= nil;
  try
    AParser.ARequest:= ARequest;
    AParser.Execute;
    AParser.ADataSet.First;

    if AParser.ADataSet.FindField('DOSS_ID') <> nil then
      vDos:= GMaintenanceCtrl.DossierByID[AParser.ADataSet.FieldByName('DOSS_ID').AsInteger];

    if AParser.ADataSet.FindField('ACTION').AsInteger = cActionModify then  //SR 24/03/2014 : Correction pour ne plus avoir de doublon
    begin
      if (vDos <> nil) and (AParser.ADataSet.Fields.FindField('SOC_ID') <> nil) and
       (AParser.ADataSet.FieldByName('SOC_ID').AsInteger > 0) then
      begin
        vUk:= ukModify;
        vSte:= vDos.SocieteByID[AParser.ADataSet.FieldByName('SOC_ID').AsInteger];
      end;

      if (vSte = nil) and (vDos <> nil) then //SR : Dans ce cas il va falloir recharger.
      begin
        GMaintenanceCtrl.LoadListSteMagPosteToDossier(vDos);
        vUk:= ukModify;
        vSte:= vDos.SocieteByID[AParser.ADataSet.FieldByName('SOC_ID').AsInteger];
      end;

      if vSte = nil then  //SR : Dans ce cas on met une erreur.
      begin
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetSociete', 'perte de mémoire'], TSociete.ClassName);
        Exit;
      end;
    end
    else
    begin
      if AParser.ADataSet.FindField('ACTION').AsInteger = cActionInsert then  //SR 24/03/2014 : Correction pour ne plus avoir de doublon
      begin
        vUk:= ukInsert;
        vSte:= TSociete.Create(nil);
        if vDos <> nil then
          vSte.ADossier:= vDos;
      end;
    end;

    if UpperCase(AParser.ADataSet.FieldByName(cFieldID).AsString) = UpperCase(TSociete.ClassName) then
      begin
        MappingProperty(TComponent(vSte));
        vSte.MAJ(vUk);

        if (vUk = ukInsert) and (vDos <> nil) then
          vDos.AppendSociete(vSte);
      end
    else
      Raise Exception.Create(cClassNameErr);

    Result:= BuildXml([cBlsResult], [cSucces], TSociete.ClassName);
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SetSociete', E.Message], TSociete.ClassName);
  end;
end;

function TGINKOIAMapperObj.SyncBaseDossier(Const ADOSS_ID: integer): String;
var
  Buffer: String;
begin
  Result:= '';
  try
    Buffer := GMaintenanceCtrl.SyncBase(ADOSS_ID);
    Result:= BuildXml([cBlsResult], [Buffer], 'SyncBaseDossier');
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans SyncBaseDossier', E.Message]);
  end;
end;

function TGINKOIAMapperObj.SynchronizeDossier: String;
var
  vSLTraceur: TStringList;
  vResultMsg: RStatusMessage;
  Buffer, vPathSyncDos: String;
begin
  vSLTraceur:= TStringList.Create;
  try
    { Permet de gérer les demandes concurrentielles de synchronisation }
    vPathSyncDos:= GWSConfig.ServicePath + cSyncDOS + '.$$$';
    Buffer:= SynchronizeStarted(cSyncDOS);
    if Buffer <> '' then
      begin
        Result:= BuildXml([cBlsResult], [Buffer], cSyncDOS);
        Exit;
      end
    else
      begin
        vSLTraceur.Append(FormatDateTime('hh:nn:ss', Now) + ' - Synchronisation en cours...');
        vSLTraceur.SaveToFile(vPathSyncDos);

        GMaintenanceCtrl.SynchronizeDossier(vResultMsg);
      end;
  finally
    GWSConfig.SaveFile(GWSConfig.ServiceFileName + cSyncDOS + GWSConfig.GetTime + '.Traceur',
                       vSLTraceur, GWSConfig.Traceur);
    FreeAndNil(vSLTraceur);
    if FileExists(vPathSyncDos) then
      DeleteFile(vPathSyncDos);
  end;
end;

function TGINKOIAMapperObj.SynchronizeSVR: String;
var
  i, j, k, vCpt: integer;
  vSrv: TServeur;
  vSrvRep: TSrvReplication;
  vSearchRepVer, vSearch: TSearching;
  Buffer, vPath, vPathSyncSvr: String;
  vSLTraceur: TStringList;
begin
  vSearchRepVer:= TSearching.Create(GWSConfig.ServiceFileName);
  vSearch:= TSearching.Create(GWSConfig.ServiceFileName);
  vSrvRep:= TSrvReplication.Create(nil);
  vSLTraceur:= TStringList.Create;
  try
    { Permet de gérer les demandes concurrentielles de synchronisation }
    vPathSyncSvr:= GWSConfig.ServicePath + cSyncSVR + '.$$$';
    Buffer:= SynchronizeStarted(cSyncSVR);
    if Buffer <> '' then
      begin
        Result:= BuildXml([cBlsResult], [Buffer], cSyncSVR);
        Exit;
      end
    else
      begin
        vSLTraceur.Append(FormatDateTime('hh:nn:ss', Now) + ' - Synchronisation en cours...');
        vSLTraceur.SaveToFile(vPathSyncSvr);
      end;

    vSLTraceur.Clear;
    try
      for k:= 0 to GMaintenanceCtrl.CountSrv -1 do
        begin
          vCpt:= 0;
          vSrv:= GMaintenanceCtrl.Serveur[k];
          if vSrv <> nil then
            begin
              { Recherche tous les path de "DelosQPMAgent.dll" dans la cible
                Ex : \\GSA-LAME3\EAI }
              vPath:= Format(cPathSuiviSvr, [vSrv.SERV_NOM, GWSConfig.Options.Values['FOLDERDELOSAGENT']]);
              vSearchRepVer.Searching(vPath, cFileSearchSuiviSvr, True);
              if vSearchRepVer.NbFilesFound = 0 then
                Exit;
              for i:= Low(vSearchRepVer.TabInfoSearch) to High(vSearchRepVer.TabInfoSearch) do
                begin
                  if vSearchRepVer.TabInfoSearch[i].PathAndName <> '' then
                    begin
                     { Recherche tous les path trouvés par "vSearchRepVer"
                       les fichiers log dans tous les rep. "Log" }
                      Buffer:= vSearchRepVer.TabInfoSearch[i].PathFolder + '\Log';
                      vSearch.Searching(Buffer, '*.log', True);
                      for j:= Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
                        begin
                          { Ce "if" sert à exclure les fichiers qui se trouvent dans
                            le repertoire de version }
                          if (vSearch.TabInfoSearch[j].PathFolder <> Buffer) and
                             (vSearch.TabInfoSearch[j].PathAndName <> '') then
                            begin
                              if FileExists(string(vSearch.TabInfoSearch[j].PathAndName)) then
                                begin
                                  { Injection dans la base de tous les path des fichiers log trouvés  }
                                  vSrvRep.SRV_ID:= vSrv.SERV_ID;
                                  vSrvRep.SVR_PATH:= string(vSearch.TabInfoSearch[j].PathAndName);
                                  vSrvRep.MAJ(ukInsert);
                                  Inc(vCpt);
                                end;
                            end;
                        end;
                    end;
                end;
              vSLTraceur.Append(vSrv.SERV_NOM + ' : ' + IntToStr(vCpt) + ' insert(s)');
            end;
        end;
      Result:= BuildXml([cBlsResult], [cSucces], cSyncSVR);
    except
      on E: Exception do
        Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans ' + cSyncSVR, E.Message], cSyncSVR);
    end;
  finally
    GWSConfig.SaveFile(GWSConfig.ServiceFileName + cSyncSVR + GWSConfig.GetTime + '.Traceur',
                       vSLTraceur, GWSConfig.Traceur);
    FreeAndNil(vSLTraceur);
    FreeAndNil(vSearchRepVer);
    FreeAndNil(vSearch);
    FreeAndNil(vSrvRep);
    if FileExists(vPathSyncSvr) then
      DeleteFile(vPathSyncSvr);
  end;
end;

function TGINKOIAMapperObj.VerifMaintenanceVersion(
  const AVERSIONCLIENT: string): string;
var
  Buffer: String;
begin
  Result:= '';
  try
    Buffer := GMaintenanceCtrl.VerifMaintenanceVersion(AVERSIONCLIENT);
    Result:= BuildXml([cBlsResult], [Buffer], 'VerifMaintenanceVersion');
  except
    on E: Exception do
      Result:= BuildXml([cBlsResult, cBlsExcept], ['Erreur dans VerifMaintenanceVersion', E.Message]);
  end;
end;

function TGINKOIAMapperObj.SynchronizeStarted(Const ASyncName: String): String;
var
  Buffer: String;
  vSL: TStringList;
begin
  Result:= '';
  if ASyncName = '' then
    Exit;
  Buffer:= GWSConfig.ServicePath + ASyncName + '.$$$';
  if FileExists(Buffer) then
    begin
      vSL:= TStringList.Create;
      try
        vSL.LoadFromFile(Buffer);
        Result:= vSL.Text;
      finally
        FreeAndNil(vSL);
      end;
    end
end;

end.

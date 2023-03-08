{===============================================================================
 Projet    : <Ginkoia> - <Delos>
===============================================================================}

unit uXmlDelos;

{===============================================================================
 Module    : Aucun
 Création  : 09/09/2013
 Auteur(s) : Gregory Ben Hamza

--- Description ----------------------------------------------------------------
  Unit regroupant les Fonctions et Procedures relatives à la manipulation des
  fichiers XML Delos.

  "uXmlDelos" s'appuie sur des Units de liaison de données Xml (voir uses de
  l'implementation) dans lesquelles se trouvent l'implémentation des interfaces
  typées.

--- ATTENTION ------------------------------------------------------------------
  Si l'un des fichiers Xml venait à changer de structure, il faudra juste
  regenerer l'unit de liaison de données et le cas échéant, modifier le code
  de l'unit "uXmlDelos" puis recompiler le projet.
===============================================================================}

interface

uses
  SysUtils, uMdlMaintenance;

Const
  { Fichiers Xml }
  cFileNameDatabases     = 'DelosQPMAgent.Databases.xml';
  cFileNameDataSources   = 'DelosQPMAgent.DataSources.xml';
  cFileNameInitParams    = 'DelosQPMAgent.InitParams.xml';
  cFileNameProviders     = 'DelosQPMAgent.Providers.xml';
  cFileNameSubscriptions = 'DelosQPMAgent.Subscriptions.xml';
  cFileNameXMLModules    = 'DelosQPMAgent.XMLModules.xml';

  { Chaine de formatage normalisé des Urls }
  { http://[IP_Serveur]/[Nom_SiteBin]/DelosQPMAgent.dll/ }
  cUrlDelosQPMAgent = 'http://%s/%s/DelosQPMAgent.dll/';

  { http://[IP_Serveur]/V_DOSSIERS/[DOSS_DATABASE]/DelosQPMAgent.dll/ }
  cUrlDelosQPMAgentV_DOSSIERS = 'http://%s/V_DOSSIERS/%s/DelosQPMAgent.dll/';

  { Type de l'url }
  cUrlTypeInsertLOG         = 'InsertLOG';
  cUrlTypeBatch             = 'Batch';
  cUrlTypeExtract           = 'Extract';
  cUrlTypeGetCurrentVersion = 'GetCurrentVersion';



function MAJXmlDatabases(Const APath: String; Const ADossier: TDossier;
                         Const AOldDossier: TDossier = nil;
                         Const ADelete: Boolean = False): Boolean;

function MAJXmlDataSources(Const APath: String; Const APathMonitor: String; Const ADossier: TDossier; Const APlaceBase: string): Boolean;

function MAJXmlInitParamXMLCInstanceName(Const APath: String; Const ADossier: TDossier): Boolean;

function MAJXmlInitParamQPMUrl(Const APath, AUrl: String): Boolean;

function MAJXmlProviders(Const APath: String; Const AUrl, ADOSS_DATABASE, ASender: String): Boolean;

function MAJXmlSubscriptions(Const APath: String; Const AUrl, ADOSS_DATABASE, ASender: String): Boolean;

function MAJXmlModules(Const APath: String; Const AVersion: String): Boolean;


implementation

uses
  uXmlDelosQPMAgentDatabases, uXmlDelosQPMAgentInitParams,
  uXmlDelosQPMAgentProviders, uXmlDelosQPMAgentSubscriptions,
  uXmlDelosQPMAgentXmlModules;


{===============================================================================
 function     : IndexOfDataSourceXmlByName
 Description  : permet la recherche du noeud "DataSource" par sa balise "NAME"
                et retourne son index.

 Signature    : - AName        : la valeur de recherche de la balise "NAME".
                - ADataSources : l'objet "DataSources" qui regroupe tous les "DataSource".
===============================================================================}
function IndexOfDataSourceXmlByName(Const AName: String;
  Const ADataSources: IXMLDataSourcesType): integer;
var
  i: integer;
begin
  Result:= -1;
  for i:= 0 to ADataSources.Count -1 do
    begin
      if UpperCase(ADataSources.DataSource[i].Name) = UpperCase(AName) then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

{===============================================================================
 function     : FindDataSourceXmlByName
 Description  : permet la recherche du noeud "DataSource" par sa balise "NAME".

 Signature    : - AName        : la valeur de recherche de la balise "NAME".
                - ADataSources : l'objet "DataSources" qui regroupe tous les "DataSource".
===============================================================================}
function FindDataSourceXmlByName(Const AName: String;
  Const ADataSources: IXMLDataSourcesType): IXMLDataSourceType;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to ADataSources.Count -1 do
    begin
      if UpperCase(ADataSources.DataSource[i].Name) = UpperCase(AName) then
        begin
          Result:= ADataSources.DataSource[i];
          Break;
        end;
    end;
end;

{===============================================================================
 function     : FindDataSourceXmlByName
 Description  : permet la recherche du noeud "DataSource" par sa balise "NAME".

 Signature    : - AName        : la valeur de recherche de la balise "NAME".
                - ADataSources : l'objet "DataSources" qui regroupe tous les "DataSource".
===============================================================================}
function FindXmlModuleXmlByName(Const AName: String;
  Const AXmlModules: IXMLXMLModulesType): IXMLXMLModuleType;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to AXmlModules.Count -1 do
    begin
      if UpperCase(AXmlModules.XMLModule[i].Name) = UpperCase(AName) then
        begin
          Result:= AXmlModules.XMLModule[i];
          Break;
        end;
    end;
end;

{===============================================================================
 function     : FindDataSourceParamXmlByName
 Description  : permet la recherche du noeud "Param" par sa balise "NAME".

 Signature    : - AName        : la valeur de recherche de la balise "NAME".
                - ADataSources : l'objet "DataSource" qui regroupe tous les "Param".
===============================================================================}
function FindDataSourceParamXmlByName(Const AName: String;
  Const ADataSource: IXMLDataSourceType): IXMLParamType;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to ADataSource.Params.Count -1 do
    begin
      if UpperCase(ADataSource.Params.Param[i].Name) = UpperCase(AName) then
        begin
          Result:= ADataSource.Params.Param[i];
          Break;
        end;
    end;
end;

{===============================================================================
 function     : MAJXmlDatabases
 Description  : permet de mettre à jour (ou de créer si il n'existe pas) le
                noeud d'un Database dans le fichier "DelosQPMAgent.Databases.xml".

 Signature    : - APath       : le chemin du fichier Xml.
                - ADossier    : l'objet dossier courant.
                - AOldDossier : l'objet dossier qui doit être remplacé.
                - ADelete     : Supprime le noeud du dossier "ADossier".

 INFO         : Le paramètre "AOldDossier" permet dans certains cas (changement
                de nom de dossier, de chemin de base, etc) d'effectuer la mise
                à jour des valeurs Xml.
                Si le parametre "AOldDossier" <> nil, dans ce cas la function
                va effectuer soit une mise à jour du "DOSS_CHEMIN" si le
                "DOSS_DATABASE" exite, soit un ajout d'un nouveau noeud.
===============================================================================}
function MAJXmlDatabases(Const APath: String;
  Const ADossier, AOldDossier: TDossier; Const ADelete: Boolean): Boolean;
var
  vIdx: integer;
  vDataSources: IXMLDataSourcesType;
  vDataSource: IXMLDataSourceType;
  vDatasourceParam: IXMLParamType;
  vFileName, vDOSS_DATABASE: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameDatabases;
  if FileExists(vFileName) then
    begin
      vDataSources:= LoadDataSources(vFileName);

      vDOSS_DATABASE:= ADossier.DOSS_DATABASE;
      if AOldDossier <> nil then
        vDOSS_DATABASE:= AOldDossier.DOSS_DATABASE;

      vDataSource:= FindDataSourceXmlByName(vDOSS_DATABASE, vDataSources);

      if ADelete then
        begin
          if vDataSource <> nil then
            begin
              vIdx:= IndexOfDataSourceXmlByName(ADossier.DOSS_DATABASE, vDataSources);
              if vIdx <> -1 then
                vDataSources.Delete(vIdx);
            end;
        end
      else
        begin
          if vDataSource <> nil then
            begin
              vDataSource.Name:= ADossier.DOSS_DATABASE;
              vDatasourceParam:= FindDataSourceParamXmlByName('SERVER NAME', vDataSource);
              if vDatasourceParam <> nil then
                vDatasourceParam.Value:= ADossier.DOSS_CHEMIN;
            end
          else
            begin
              vDataSource:= vDataSources.Add;
              vDataSource.Name:= ADossier.DOSS_DATABASE;
              vDataSource.Connected:= 'False';
              vDataSource.KeepConnection:= 'False';
              vDataSource.Middleware:= 'FIB';

              vDatasourceParam:= vDataSource.Params.Add;
              vDatasourceParam.Name:= 'SERVER NAME';
              vDatasourceParam.Value:= ADossier.DOSS_CHEMIN;
              vDatasourceParam.LastBCK:= '';
              vDatasourceParam.LastTIME:= '';
              vDatasourceParam.LastRESULT:= '';
              vDatasourceParam.REFERENCER:= '';
              vDatasourceParam.NO_IP:= '';

              vDatasourceParam:= vDataSource.Params.Add;
              vDatasourceParam.Name:= 'USER NAME';
              vDatasourceParam.Value:= 'GINKOIA';

              vDatasourceParam:= vDataSource.Params.Add;
              vDatasourceParam.Name:= 'PASSWORD';
              vDatasourceParam.Value:= 'ginkoia';
            end;
        end;

      vDataSources.OwnerDocument.SaveToFile(vFileName);
      Result:= True;
    end;
end;

{===============================================================================
 function     : MAJXmlDataSources
 Description  : permet de mettre à jour les noeuds "Database" et "DBMonitor" du
                fichier "DelosQPMAgent.DataSources.xml".

 Signature    : - APath    : le chemin du fichier Xml.
                - ADossier : le dossier.
===============================================================================}
function MAJXmlDataSources(Const APath: String; Const APathMonitor: String;
Const ADossier: TDossier; Const APlaceBase: string): Boolean;
var
  vDataSources: IXMLDataSourcesType;
  vDataSource: IXMLDataSourceType;
  vDatasourceParam: IXMLParamType;
  vFileName: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameDataSources;
  if FileExists(vFileName) then
    begin
      vDataSources:= LoadDataSources(vFileName);
      vDataSource:= FindDataSourceXmlByName('Database', vDataSources);

      if vDataSource <> nil then
        begin
          vDatasourceParam:= FindDataSourceParamXmlByName('SERVER NAME', vDataSource);
          if vDatasourceParam <> nil then
          begin
            if APlaceBase = '' then
              vDatasourceParam.Value:= ADossier.DOSS_CHEMIN
            else
              vDatasourceParam.Value:= APlaceBase;
          end;
        end;

      vDataSource:= FindDataSourceXmlByName('DBMonitor', vDataSources);

      if vDataSource <> nil then
        begin
          vDatasourceParam:= FindDataSourceParamXmlByName('SERVER NAME', vDataSource);
          if vDatasourceParam <> nil then
            vDatasourceParam.Value:= IncludeTrailingBackslash(APathMonitor) + 'MONITOR.IB';
        end;

      vDataSources.OwnerDocument.SaveToFile(vFileName);
      Result:= True;
    end;
end;

{===============================================================================
 function     : MAJXmlInitParamXMLCInstanceName
 Description  : permet de mettre à jour la balise "XMLC_InstanceName" du
                fichier "DelosQPMAgent.InitParams.xml".

 Signature    : - APath    : le chemin du fichier Xml.
                - ADossier : le dossier.
===============================================================================}
function MAJXmlInitParamXMLCInstanceName(Const APath: String;
  Const ADossier: TDossier): Boolean;
var
  vInitParams: IXMLInitParamsType;
  vFileName: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameInitParams;
  if FileExists(vFileName) then
    begin
      vInitParams:= LoadInitParams(vFileName);

      vInitParams.XMLC.XMLC_InstanceName:= ADossier.DOSS_DATABASE;

      vInitParams.OwnerDocument.SaveToFile(vFileName);
      Result:= True;
    end;
end;

{===============================================================================
 function     : MAJXmlModules
 Description  : permet de mettre à jour la balise "XMLPath" du
                fichier "DelosQPMAgent.XmlModules.xml".

 Signature    : - APath    : le chemin du fichier Xml.
                - ADossier : le dossier.
===============================================================================}
function MAJXmlModules(Const APath: String; Const AVersion: String): Boolean;
var
  vXmlModules: IXMLXMLModulesType;
  vXmlModule: IXMLXMLModuleType;
  vFileName: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameXMLModules;
  if FileExists(vFileName) then
  begin
    vXmlModules:= LoadXMLModules(vFileName);
    vXmlModule:= FindXmlModuleXmlByName('bmDelosQPMAgent', vXmlModules);

    if vXmlModule <> nil then
    begin
      vXmlModule.XMLPath := '..\..\' + copy(AVersion, 1, pos('BIN', UpperCase(AVersion))-1) + '\XML_Ginkoia\'; //Exemple pour AVersion : V13_3_0
    end;

    vXmlModules.OwnerDocument.SaveToFile(vFileName);

    Result:= True;
  end;
end;

{===============================================================================
 function     : MAJXmlInitParamQPMUrl
 Description  : permet de mettre à jour les balises (url de type "InsertLOG")
                du fichier "DelosQPMAgent.InitParams.xml".

 Signature    : - APath : le chemin du fichier Xml.
                - AUrl  : Url issu du formatage normalisé (cUrlDelosQPMAgent ou
                          cUrlDelosQPMAgentV_DOSSIERS) donc SANS le type "InsertLOG".
===============================================================================}
function MAJXmlInitParamQPMUrl(Const APath, AUrl: String): Boolean;
var
  vInitParams: IXMLInitParamsType;
  Buffer, vFileName: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameInitParams;
  if FileExists(vFileName) then
    begin
      vInitParams:= LoadInitParams(vFileName);

      Buffer:= AUrl + cUrlTypeInsertLOG;

      vInitParams.QPM.QPM_BatchException:= Buffer;
      vInitParams.QPM.QPM_ExtractException:= Buffer;
      vInitParams.QPM.QPM_PullDone:= Buffer;
      vInitParams.QPM.QPM_PullException:= Buffer;
      vInitParams.QPM.QPM_PushDone:= Buffer;
      vInitParams.QPM.QPM_PushException:= Buffer;

      vInitParams.OwnerDocument.SaveToFile(vFileName);
      Result:= True;
    end;
end;

{===============================================================================
 function     : MAJXmlProviders
 Description  : permet de mettre à jour les balises (url de type "Batch", Database)
                du fichier "DelosQPMAgent.Providers.xml".

 Signature    : - APath         : le chemin du fichier Xml.
                - AUrl          : Url issu du formatage normalisé (cUrlDelosQPMAgent
                                  ou cUrlDelosQPMAgentV_DOSSIERS) donc SANS sans
                                  le type "Batch".
                - ADOSS_DATABASE : Le nom du dossier.
===============================================================================}
function MAJXmlProviders(Const APath: String; Const AUrl, ADOSS_DATABASE, ASender: String): Boolean;
var
  i: integer;
  vProviders: IXMLProvidersType;
  vProvider: IXMLProviderType;
  vFileName: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameProviders;
  if FileExists(vFileName) then
    begin
      vProviders:= LoadProviders(vFileName);

      for i:= 0 to vProviders.Count -1 do
        begin
          vProvider:= vProviders.Provider[i];

          vProvider.URL:= AUrl + cUrlTypeBatch;
          vProvider.Database:= ADOSS_DATABASE;
          vProvider.Sender:= ASender;
        end;

      vProviders.OwnerDocument.SaveToFile(vFileName);
      Result:= True;
    end;
end;

{===============================================================================
 function     : MAJXmlSubscriptions
 Description  : permet de mettre à jour les balises (url de type "Extract et
                GetCurrentVersion", Database) du fichier "DelosQPMAgent.Subscriptions.xml".

 Signature    : - APath : le chemin du fichier Xml.
                - AUrl  : Url issu du formatage normalisé (cUrlDelosQPMAgent ou
                          cUrlDelosQPMAgentV_DOSSIERS) donc SANS le
                          type "Extract ou GetCurrentVersion".
===============================================================================}
function MAJXmlSubscriptions(Const APath: String; Const AUrl, ADOSS_DATABASE, ASender: String): Boolean;
var
  i: integer;
  vSubscriptions: IXMLSubscriptionsType;
  vSubscription: IXMLSubscriptionType;
  vFileName: String;
begin
  Result:= False;
  vFileName:= IncludeTrailingBackslash(APath) + cFileNameSubscriptions;
  if FileExists(vFileName) then
    begin
      vSubscriptions:= LoadSubscriptions(vFileName);

      for i:= 0 to vSubscriptions.Count -1 do
        begin
          vSubscription:= vSubscriptions.Subscription[i];

          vSubscription.URL:= AUrl + cUrlTypeExtract;
          vSubscription.GetCurrentVersion:= AUrl + cUrlTypeGetCurrentVersion;
          vSubscription.Database:= ADOSS_DATABASE;
          vSubscription.Sender:=ASender;
        end;

      vSubscriptions.OwnerDocument.SaveToFile(vFileName);
      Result:= True;
    end;
end;

end.

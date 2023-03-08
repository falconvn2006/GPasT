unit uCtrlMaintenance;

interface

uses
  Windows, SysUtils, Classes, System.Types, Contnrs, SqlExpr, uMdlMaintenance, DB, uConst,
  ThrdCtrlSplittage, Variants, dmdGINKOIA_XE7, uStatusMessage, uSql, ShellApi,
  IOUtils, GestionJetonLaunch, SOAPHTTPClient, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.IBDef, FireDAC.Phys.IBBase, FireDAC.Phys.IB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

Type
  PPropSynthese = ^TPropSynthese;

  TPropSynthese = Record
    Name: String;
    ListFields: String;
    Ressource: String;
    IsStoredProc: Boolean;
    ListParamValue: String;
  End;

Const
  { Liste de propriete des syntheses }

  cListTypeSynthese: array [0 .. 3] of TPropSynthese = ((Name: 'SuiviRepEtBaseHS'; ListFields: cFieldsSuiviEmetteur; Ressource: cSqlSyntheseBase;
    IsStoredProc: False; ListParamValue: ''),

    (Name: 'SuiviServeur'; ListFields: cFieldsSuiviEmetteur; Ressource: cSqlSyntheseBase + cSqlSyntheseLastReplic + cSqlSyntheseEMET_TYPEREPLICATION +
    cSqlSyntheseDELAINONREPLIC; IsStoredProc: False; ListParamValue: '|Serveur|' + cRC + '1'),

    (Name: 'SuiviPortableEtPortableSynchro'; ListFields: cFieldsSuiviEmetteur;
    Ressource: cSqlSyntheseBase + cSqlSyntheseLastReplic + cSqlSyntheseEMET_TYPEREPLICATION + cSqlSyntheseDELAINONREPLIC; IsStoredProc: False;
    ListParamValue: '|Notebook||Notebook synchro|' + cRC + '5'),

    (Name: 'SuiviVIP'; ListFields: cFieldsSuiviEmetteur; Ressource: cSqlSyntheseBase + cSqlSyntheseLastReplic + cSqlSyntheseEMET_TYPEREPLICATION +
    cSqlSyntheseDELAINONREPLIC + cSqlSyntheseDOSS_VIP; IsStoredProc: False; ListParamValue: '|Serveur|' + cRC + '1' + cRC + '1'));

Type
  TMaintenanceCtrl = Class(TComponent)
  private
    FListDos: TObjectList;
    FListMag: TObjectList;
    FListPoste: TObjectList;
    FListMod: TObjectList;
    FListEmet: TObjectList;
    FListSrv: TObjectList;
    FListGrp: TObjectList;
    FListVer: TObjectList;
    FListRaison: TObjectList;
    FTThrdCtrlSplittage: TThrdCtrlSplittage;

    function GetCountMag: integer;
    function GetCountModule: integer;
    function GetCountDossier: integer;
    function GetMagasin(index: integer): TMagasin;
    function GetMagasinByID(AMAGA_ID: integer): TMagasin;
    function GetMagasinByMAGA_MAGID_GINKOIA(AMAGA_MAGID_GINKOIA, ADOSS_ID: integer): TMagasin;
    function GetDossier(index: integer): TDossier;
    function GetDossierByID(ADOSS_ID: integer): TDossier;
    function GetModule(index: integer): TModule;
    function GetModuleByID(AMODU_ID: integer): TModule;
    function GetCountEmet: integer;
    function GetEmetteur(index: integer): TEmetteur;
    function GetEmetteurByID(AEMET_ID: integer): TEmetteur;
    function GetCountGrp: integer;
    function GetCountSrv: integer;
    function GetGroupe(index: integer): TGroupe;
    function GetGroupeByID(AGROU_ID: integer): TGroupe;
    function GetServeur(index: integer): TServeur;
    function GetServeurByID(ASERV_ID: integer): TServeur;
    function GetEmetteurByALGOL(ADOSS_ID: integer): TEmetteur;
    function GetEmetteurByGUID(AEMET_GUID: string): TEmetteur;
    function GetCountVer: integer;
    function GetVersion(index: integer): TVersion;
    function GetVersionByID(AVERS_ID: integer): TVersion;
    function GetModuleByNOM(AMODU_NOM: String): TModule;
    function GetHoraireByServeurID(ASERV_ID, APRH_ID: integer): THoraire;
    function GetCountRaison: integer;
    function GetRaison(index: integer): TRaison;
    function GetRaisonByID(ARAIS_ID: integer): TRaison;
    function GetVersionByVERS_VERSION(AVERS_VERSION: String): TVersion;
    function GetCountPoste: integer;
    function GetPoste(index: integer): TPoste;
    function GetPosteByID(APOST_ID: integer): TPoste;
    function GetPosteByPOST_MAGAID(APOST_MAGAID, APOST_POSID: integer): TPoste;
    procedure SetGenParamBaseTypeBase(aDataModule: TdmGINKOIA);
  protected
    procedure InitializeLists;
    procedure FreeLists;

    procedure InitializeListDos;
    procedure InitializeListSrv;
    procedure InitializeListGrp;
    procedure InitializeListMag;
    procedure InitializeListPoste;
    procedure InitializeListMod;
    procedure InitializeListVer;
    procedure InitializeListRaison;
    procedure StartThrdCtrlSplittage;
  published

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Initialisation des listes statiques }
    procedure IntializeCtrl;

    { Chargement des listes }
    procedure LoadListModulePerMag;
    procedure LoadListJetonPerEmet;

    { DmdGinkoia }
    procedure CheckConnexionByDossier(Const ADossier: TDossier; var AResultMsg: RStatusMessage);
    function GetNewdmGINKOIAByChemin(Const AChemin: string): TdmGINKOIA;
    function GetNewdmGINKOIAByDOSS_ID(Const ADOSS_ID: integer): TdmGINKOIA;
    function GetNewdmGINKOIAByDossier(Const ADossier: TDossier): TdmGINKOIA;

    { Serveur }
    property CountSrv: integer read GetCountSrv;
    property Serveur[index: integer]: TServeur read GetServeur;
    property ServeurByID[ASERV_ID: integer]: TServeur read GetServeurByID;
    property HoraireByServeurID[ASERV_ID, APRHO_ID: integer]: THoraire read GetHoraireByServeurID;
    procedure AddSrv(Const ASRV: TServeur);

    { Groupe }
    property CountGrp: integer read GetCountGrp;
    property Groupe[index: integer]: TGroupe read GetGroupe;
    property GroupeByID[AGRP_ID: integer]: TGroupe read GetGroupeByID;
    procedure AddGrp(Const AGRP: TGroupe);

    { Version }
    property CountVer: integer read GetCountVer;
    property Version[index: integer]: TVersion read GetVersion;
    property VersionByID[AVERS_ID: integer]: TVersion read GetVersionByID;
    property VersionByVERS_VERSION[AVERS_VERSION: String]: TVersion read GetVersionByVERS_VERSION;
    procedure AddVersion(Const AVersion: TVersion);

    { Dossier }
    property CountDossier: integer read GetCountDossier;
    property Dossier[index: integer]: TDossier read GetDossier;
    property DossierByID[ADOSS_ID: integer]: TDossier read GetDossierByID;
    procedure AppendDossier(Const ADossier: TDossier);
    procedure DeleteDossier(Const ADossier: TDossier);
    procedure LoadListSteMagPosteToDossier(Const ADossier: TDossier);
    procedure LoadListGrpToDossier(Const ADossier: TDossier);
    function GetNewPlageGinkoia(Const ADOSS_ID: integer): String;
    function GetNewIdentGinkoia(Const ADOSS_ID: integer): String;
    procedure SynchronizeDossier(var AResultMsg: RStatusMessage);
    procedure ChangeDossier(Const ADossier, ANewDossier: TDossier);

    { Magasin }
    property CountMag: integer read GetCountMag;
    property Magasin[index: integer]: TMagasin read GetMagasin;
    property MagasinByID[AMAG_ID: integer]: TMagasin read GetMagasinByID;
    property MagasinByMAGA_MAGID_GINKOIA[AMAGA_MAGID_GINKOIA, ADOSS_ID: integer]: TMagasin read GetMagasinByMAGA_MAGID_GINKOIA;
    procedure AppendMagasin(Const AMagasin: TMagasin);

    { Poste }
    property CountPoste: integer read GetCountPoste;
    property Poste[index: integer]: TPoste read GetPoste;
    property PosteByID[APOST_ID: integer]: TPoste read GetPosteByID;
    property PosteByPOST_MAGAID[APOST_MAGAID, APOST_POSID: integer]: TPoste read GetPosteByPOST_MAGAID;
    procedure AppendPoste(Const APoste: TPoste);

    { Module }
    property CountModule: integer read GetCountModule;
    property Module[index: integer]: TModule read GetModule;

    property ModuleByID[AMOD_ID: integer]: TModule read GetModuleByID;
    property ModuleByNOM[AMOD_NOM: String]: TModule read GetModuleByNOM;
    procedure AppendModule(Const AModule: TModule);
    procedure CreateMdlGinkoiaToMaintenance(Const AMAG_ID: integer);
    function GetModuleGinkoia(const ADOSS_ID, AUGM_MAGID, AUGG_ID: integer): TModuleGinkoia;
    function GetListModuleGinkoia(Const ADOSS_ID, AMAG_ID_GINKOIA: integer; Const All: Boolean): TObjectList;
    function GetListModule(Const ADOSS_ID, AMAG_ID: integer): TObjectList;

    { Emetteur }
    property CountEmet: integer read GetCountEmet;
    property Emetteur[index: integer]: TEmetteur read GetEmetteur;
    property EmetteurByID[AEMET_ID: integer]: TEmetteur read GetEmetteurByID;
    property EmetteurByALGOL[ADOSS_ID: integer]: TEmetteur read GetEmetteurByALGOL;
    property EmetteurByGUID[AEMET_GUID: string]: TEmetteur read GetEmetteurByGUID;
    procedure AppendEmetteur(Const AEmetteur: TEmetteur);
    function LoadListEmetteur(Const ADOSS_ID, ASERV_ID: integer; Const ASynthese: String; Const AAllowListResult: Boolean;
      var AResultMsg: RStatusMessage): TObjectList;
    procedure SetValuesEmetteurByGinkoia(Const ADmGINKOIA: TdmGINKOIA; Const AEmet: TEmetteur);
    procedure SynchronizeBAS_IDENTToEMET_IDENT(Const ADOSS_ID, ASERV_ID: integer; Const AListDossier: TDataSet; Const ADmGINKOIA: TdmGINKOIA;
      var AResultMsg: RStatusMessage);

    { Raison }
    property CountRaison: integer read GetCountRaison;
    property Raison[index: integer]: TRaison read GetRaison;
    property RaisonByID[ARAIS_ID: integer]: TRaison read GetRaisonByID;

    { Synthese }
    function GetPropSynthese(Const ATypeSynthese: String): PPropSynthese;
    function GetListSrvReplication(Const ASERV_ID: integer): TObjectList;

    { Splittage log }
    function GetSplittageLog(Const ANOSPLIT: integer = -1): TGnkSplittageLog;
    function GetListSplittageLog: TObjectList;
    function AddSplittage(Const AEmetteur: TEmetteur; Const AUSERNAME, ATYPESPLIT: String; Const ACLEARFILES: integer; var AInfoStatut: String;
      Const ABASE: integer; Const AMAIL: integer): Boolean;
    procedure DelSplittage(Const ANOSPLIT: integer);
    procedure PriorityOrdreSplittageLog(Const ANOSPLIT: integer; const APriorityOrdre: TPriorityOrdre);

    function IsSplittageProcessActivate: Boolean;
    procedure SetActiveThrdCtrlSplittage(Const AActivate: integer);

    //
    function GetMaintenanceEmetDateInstallation(Const AGUID: string): string;
    function SetMaintenanceEmetDateInstallation(Const AGUID: string; Const AEmet_Install: TDateTime): string;

    // Init
    function SetMaintenanceInitialisationPostes(Const ACMD: string): string;

    { Ginkoia Base Client }
    function GetGenReplication(Const ADOSS_ID, AREP_ID: integer): TGnkGenReplication;
    function GetGenReplicationByLauID(Const ADOSS_ID, ALAU_ID: integer): TGnkGenReplication;
    function GetListGenReplication(Const ADOSS_ID, ALAUID, AREPLICWEB: integer): TObjectList;

    function GetGenLiaiRepli(Const ADOSS_ID, AGLR_ID: integer): TGnkGenLiaiRepli;

    function GetGenProviders(Const ADOSS_ID, APRO_ID: integer): TGnkGenProviders;
    function GetListGenProviders(Const ADOSS_ID, AREP_ID: integer; Const AStatutPkg: TStatutPkg): TObjectList;

    function GetGenSubscribers(Const ADOSS_ID, ASUB_ID: integer): TGnkGenSubscribers;
    function GetListGenSubscribers(Const ADOSS_ID, AREP_ID: integer; Const AStatutPkg: TStatutPkg): TObjectList;

    procedure CreateBase(Const ADirSource: String; Const ADossier: TDossier);

    procedure SplitEASY(const AEmetteur: TEmetteur; const ANOSPLIT: integer);
    procedure RunRecupBase(Const AEmetteur: TEmetteur; Const ANOSPLIT: integer);

    function SyncBase(Const ADOSS_ID: integer): string;
    function VerifMaintenanceVersion(Const AVERSIONCLIENT: string): string;
    function JetonLame(Const ADOSS_ID: integer): string;

  End;

var
  GMaintenanceCtrl: TMaintenanceCtrl;

implementation

uses dmdMaintenance, uSearchTG, uCommon, uVar, uTool_XE7, uXmlDelos,
  uMapper;

{ TMaintenanceCtrl }

procedure TMaintenanceCtrl.AddGrp(const AGRP: TGroupe);
begin
  if GroupeByID[AGRP.GROU_ID] = nil then
    FListGrp.Add(AGRP);
end;

function TMaintenanceCtrl.AddSplittage(const AEmetteur: TEmetteur; const AUSERNAME, ATYPESPLIT: String; Const ACLEARFILES: integer;
  var AInfoStatut: String; Const ABASE: integer; Const AMAIL: integer): Boolean;
var
  vGnkSplittageLog: TGnkSplittageLog;
begin
  AInfoStatut := '';
  Result := False;
  try
    try
      vGnkSplittageLog := GetSplittageLog;
      vGnkSplittageLog.SPLI_EMETID := AEmetteur.EMET_ID;
      vGnkSplittageLog.SPLI_EMETNOM := AEmetteur.EMET_NOM;
      vGnkSplittageLog.SPLI_USERNAME := AUSERNAME;
      vGnkSplittageLog.SPLI_TYPESPLIT := ATYPESPLIT;
      vGnkSplittageLog.SPLI_CLEARFILES := ACLEARFILES;
      vGnkSplittageLog.SPLI_BASE := ABASE;
      vGnkSplittageLog.SPLI_MAIL := AMAIL;
      vGnkSplittageLog.MAJ(ukInsert);
      Result := True;
      AInfoStatut := 'Ajout de "RecupBase" de type "' + ATYPESPLIT + '".';

      SetActiveThrdCtrlSplittage(0);
      StartThrdCtrlSplittage;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.AddSplittage : ' + E.Message);
    end;
  finally
    FreeAndNil(vGnkSplittageLog);
  end;
end;

procedure TMaintenanceCtrl.AddSrv(const ASRV: TServeur);
begin
  if ServeurByID[ASRV.SERV_ID] = nil then
    FListSrv.Add(ASRV);
end;

procedure TMaintenanceCtrl.AddVersion(const AVersion: TVersion);
begin
  if VersionByID[AVersion.VERS_ID] = nil then
    FListVer.Add(AVersion);
end;

procedure TMaintenanceCtrl.AppendDossier(Const ADossier: TDossier);
begin
  if DossierByID[ADossier.DOSS_ID] = nil then
    FListDos.Add(ADossier);
end;

procedure TMaintenanceCtrl.AppendEmetteur(const AEmetteur: TEmetteur);
begin
  if EmetteurByID[AEmetteur.EMET_ID] = nil then
    FListEmet.Add(AEmetteur);
end;

procedure TMaintenanceCtrl.AppendMagasin(const AMagasin: TMagasin);
begin
  if MagasinByID[AMagasin.MAGA_ID] = nil then
    FListMag.Add(AMagasin);
end;

procedure TMaintenanceCtrl.AppendModule(const AModule: TModule);
begin
  if ModuleByID[AModule.MODU_ID] = nil then
    FListMod.Add(AModule);
end;

procedure TMaintenanceCtrl.AppendPoste(const APoste: TPoste);
begin
  if PosteByID[APoste.POST_ID] = nil then
    FListPoste.Add(APoste);
end;

function TMaintenanceCtrl.SyncBase(const ADOSS_ID: integer): string;
var
  vdmGINKOIA: TdmGINKOIA;
  vQryGinkoia, vQryMaintenanceS, vQryMaintenanceU: TFDQuery;
  iMAGAID: integer;
  iMODUID: integer;
  // vDossier: TDossier;
  sVerVersion: string;
  VersionInt: integer;
  iMAG_BASID: integer;
begin
  Result := '';
  try
    try
      vQryMaintenanceS := dmMaintenance.GetNewQry;
      vQryMaintenanceU := dmMaintenance.GetNewQry;

      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      // vDossier := GetDossierByID(ADOSS_ID);
      vQryGinkoia := vdmGINKOIA.GetNewQry;

      sVerVersion := '';
      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := cSql_S_genversion;
      vQryGinkoia.Open;
      if not vQryGinkoia.Eof then
        sVerVersion := vQryGinkoia.FieldByName('VER_VERSION').AsString;
      vQryGinkoia.Close;

      // on vérifie si on est en version > à 16 pour savoir si on récupère le champ mag_basid ou pas
      VersionInt := dmMaintenance.VersionStringToInt(sVerVersion);

      // SR 13/03/2014 : Partie Synchro Magasin Ginkoia -> Maintenance

      if VersionInt >= 16 then
        vQryGinkoia.SQL.Text :=
          'Select	MAG_ID, MAG_NOM, MAG_ENSEIGNE, K_ENABLED, MAG_BASID From GENMAGASIN Join K on (K_ID = MAG_ID) Where MAG_ID <> 0'
      else
        vQryGinkoia.SQL.Text := 'Select	MAG_ID, MAG_NOM, MAG_ENSEIGNE, K_ENABLED From GENMAGASIN Join K on (K_ID = MAG_ID) Where MAG_ID <> 0';
      vQryGinkoia.Open;
      vQryGinkoia.First;

      vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Magasins;

      while not vQryGinkoia.Eof do
      begin
        if VersionInt >= 16 then
          iMAG_BASID := vQryGinkoia.FieldByName('MAG_BASID').AsInteger
        else
          iMAG_BASID := 0;

        vQryMaintenanceS.Close;
        vQryMaintenanceS.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := vQryGinkoia.FieldByName('MAG_ID').AsInteger;
        vQryMaintenanceS.ParamByName('PMAGADOSSID').AsInteger := ADOSS_ID;
        vQryMaintenanceS.Open;

        if not vQryMaintenanceU.Connection.Transaction.Active then
          vQryMaintenanceU.Connection.Transaction.StartTransaction;

        vQryMaintenanceU.Close;

        if not vQryMaintenanceS.Eof then
        begin
          // Update
          vQryMaintenanceU.SQL.Text := cSql_U_magasins;
          vQryMaintenanceU.ParamByName('PMAGAID').AsInteger := vQryMaintenanceS.FieldByName('MAGA_ID').AsInteger;
        end
        else
        begin
          // Insert
          vQryMaintenanceU.SQL.Text := cSql_I_magasins;
          vQryMaintenanceU.ParamByName('PMAGAID').AsInteger := dmMaintenance.GetNewID('MAGASINS');
        end;

        vQryMaintenanceU.ParamByName('PMAGABASID').AsInteger := iMAG_BASID;
        vQryMaintenanceU.ParamByName('PMAGANOM').AsString := vQryGinkoia.FieldByName('MAG_NOM').AsString;
        vQryMaintenanceU.ParamByName('PMAGAENSEIGNE').AsString := vQryGinkoia.FieldByName('MAG_ENSEIGNE').AsString;
        vQryMaintenanceU.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := vQryGinkoia.FieldByName('MAG_ID').AsInteger;
        vQryMaintenanceU.ParamByName('PMAGADOSSID').AsInteger := ADOSS_ID;
        vQryMaintenanceU.ParamByName('PMAGAKENABLED').AsInteger := vQryGinkoia.FieldByName('K_ENABLED').AsInteger;
        vQryMaintenanceU.ExecSQL;

        if vQryMaintenanceU.Connection.Transaction.Active then
          vQryMaintenanceU.Connection.Transaction.Commit;

        vQryGinkoia.Next;
      end;
      vQryGinkoia.Close;
      vQryMaintenanceU.Close;
      vQryMaintenanceS.Close;

      // SR 13/03/2014 : Partie Synchro Magasin Maintenance -> Ginkoia (On supprime les magasins présent dans Maintenance et inéxistant dans Ginkoia)
      vQryMaintenanceS.SQL.Text := 'SELECT MAGA_ID, MAGA_MAGID_GINKOIA FROM MAGASINS WHERE MAGA_DOSSID = :PDOSSID';
      vQryMaintenanceS.ParamByName('PDOSSID').AsInteger := ADOSS_ID;
      vQryMaintenanceS.Open;
      vQryMaintenanceS.First;

      vQryGinkoia.SQL.Text := 'Select MAG_ID From GENMAGASIN Join K on (K_ID = MAG_ID and K_ENABLED = 1) Where MAG_ID = :PMAGID';
      vQryMaintenanceU.SQL.Text := 'Delete From Magasins Where MAGA_ID = :PMAGAID';

      while not vQryMaintenanceS.Eof do
      begin
        vQryGinkoia.Close;
        vQryGinkoia.ParamByName('PMAGID').AsInteger := vQryMaintenanceS.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
        vQryGinkoia.Open;
        vQryGinkoia.First;

        if vQryGinkoia.Eof then // Si non présent dans Ginkoia, on supprime la ligne
        begin
          if not vQryMaintenanceU.Connection.Transaction.Active then
            vQryMaintenanceU.Connection.Transaction.StartTransaction;

          vQryMaintenanceU.Close;
          vQryMaintenanceU.ParamByName('PMAGAID').AsInteger := vQryMaintenanceS.FieldByName('MAGA_ID').AsInteger;
          vQryMaintenanceU.ExecSQL;
          if vQryMaintenanceU.Connection.Transaction.Active then
            vQryMaintenanceU.Connection.Transaction.Commit;
        end;
        vQryMaintenanceS.Next;
      end;
      vQryMaintenanceS.Close;
      vQryMaintenanceU.Close;
      vQryGinkoia.Close;

      // SR 13/03/2014 : Partie Synchro Emetteur Ginkoia -> Maintenance
      vQryGinkoia.SQL.Text := cSql_S_SyncBase_GenBases;
      vQryGinkoia.Open;
      vQryGinkoia.First;

      while not vQryGinkoia.Eof do
      begin
        vQryMaintenanceS.Close;
        vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Magasins;
        vQryMaintenanceS.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := vQryGinkoia.FieldByName('BAS_MAGID').AsInteger;
        vQryMaintenanceS.ParamByName('PMAGADOSSID').AsInteger := ADOSS_ID;
        vQryMaintenanceS.Open;

        if not vQryMaintenanceS.Eof then
          iMAGAID := vQryMaintenanceS.FieldByName('MAGA_ID').AsInteger
        else
          iMAGAID := 0;

        vQryMaintenanceS.Close;
        vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Emetteur;
        vQryMaintenanceS.ParamByName('PEMETGUID').AsString := vQryGinkoia.FieldByName('BAS_GUID').AsString;
        vQryMaintenanceS.ParamByName('PEMETDOSSID').AsInteger := ADOSS_ID;
        vQryMaintenanceS.Open;

        if not vQryMaintenanceU.Connection.Transaction.Active then
          vQryMaintenanceU.Connection.Transaction.StartTransaction;

        vQryMaintenanceU.Close;

        if not vQryMaintenanceS.Eof then
        begin
          // Update
          vQryMaintenanceU.SQL.Text := cSql_U_SyncBase_Emetteur;
          vQryMaintenanceU.ParamByName('PEMETID').AsInteger := vQryMaintenanceS.FieldByName('EMET_ID').AsInteger;
        end
        else
        begin
          // Insert
          vQryMaintenanceU.SQL.Text := cSql_I_Emetteur;
          vQryMaintenanceU.ParamByName('PEMETID').AsInteger := dmMaintenance.GetNewID('EMETTEUR');

          vQryMaintenanceU.ParamByName('PEMETGUID').AsString := vQryGinkoia.FieldByName('BAS_GUID').AsString;
          vQryMaintenanceU.ParamByName('PEMETDONNEES').AsString := '';
          vQryMaintenanceU.ParamByName('PEMETINSTALL').AsDateTime := StrToDateTime('01/01/1900');
          vQryMaintenanceU.ParamByName('PEMETPATCH').AsInteger := 0;
          vQryMaintenanceU.ParamByName('PEMETVERSION_MAX').AsInteger := 0;
          vQryMaintenanceU.ParamByName('PEMETSPEPATCH').AsInteger := 0;
          vQryMaintenanceU.ParamByName('PEMETSPEFAIT').AsInteger := 0;
          vQryMaintenanceU.ParamByName('PEMETBCKOK').AsDateTime := StrToDateTime('01/01/1900');
          vQryMaintenanceU.ParamByName('PEMETDERNBCK').AsDateTime := StrToDateTime('01/01/1900');
          vQryMaintenanceU.ParamByName('PEMETRESBCK').AsString := '';
          vQryMaintenanceU.ParamByName('PEMETTYPEREPLICATION').Clear;
          vQryMaintenanceU.ParamByName('PEMETNONREPLICATION').AsInteger := 0;
          vQryMaintenanceU.ParamByName('PEMETDEBUTNONREPLICATION').Clear;
          vQryMaintenanceU.ParamByName('PEMETFINNONREPLICATION').Clear;
          vQryMaintenanceU.ParamByName('PEMETSERVEURSECOURS').Clear;
          vQryMaintenanceU.ParamByName('PEMETINFOSUP').Clear;
          vQryMaintenanceU.ParamByName('PEMETEMAIL').Clear;
          vQryMaintenanceU.ParamByName('PEMETDOSSID').AsInteger := ADOSS_ID;

        end;

        vQryMaintenanceS.Close;
        vQryMaintenanceS.SQL.Text := 'SELECT VERS_ID FROM VERSION WHERE VERS_VERSION = :PVERSVERSION';
        vQryMaintenanceS.ParamByName('PVERSVERSION').AsString := sVerVersion;
        vQryMaintenanceS.Open;
        if not(vQryMaintenanceS.Eof) then
          vQryMaintenanceU.ParamByName('PEMETVERSID').AsInteger := vQryMaintenanceS.FieldByName('VERS_ID').AsInteger
        else
          vQryMaintenanceU.ParamByName('PEMETVERSID').AsInteger := 0;
        vQryMaintenanceU.ParamByName('PEMETNOM').AsString := vQryGinkoia.FieldByName('BAS_NOM').AsString;
        vQryMaintenanceU.ParamByName('PEMETBASID').AsString := vQryGinkoia.FieldByName('BAS_ID').AsString;
        vQryMaintenanceU.ParamByName('PEMETMAGID').AsInteger := iMAGAID;
        vQryMaintenanceU.ParamByName('PEMETTIERSCEGID').AsString := vQryGinkoia.FieldByName('BAS_CODETIERS').AsString;
        vQryMaintenanceU.ParamByName('PEMETIDENT').AsString := vQryGinkoia.FieldByName('BAS_IDENT').AsString;
        vQryMaintenanceU.ParamByName('PEMETJETON').AsInteger := vQryGinkoia.FieldByName('BAS_JETON').AsInteger;
        vQryMaintenanceU.ParamByName('PEMETPLAGE').AsString := vQryGinkoia.FieldByName('BAS_PLAGE').AsString;
        vQryMaintenanceU.ParamByName('PEMETHEURE1').AsDateTime := vQryGinkoia.FieldByName('LAU_HEURE1').AsDateTime;
        vQryMaintenanceU.ParamByName('PEMETH1').AsInteger := vQryGinkoia.FieldByName('LAU_H1').AsInteger;
        vQryMaintenanceU.ParamByName('PEMETHEURE2').AsDateTime := vQryGinkoia.FieldByName('LAU_HEURE2').AsDateTime;
        vQryMaintenanceU.ParamByName('PEMETH2').AsInteger := vQryGinkoia.FieldByName('LAU_H2').AsInteger;

        vQryMaintenanceU.ExecSQL;
        if vQryMaintenanceU.Connection.Transaction.Active then
          vQryMaintenanceU.Connection.Transaction.Commit;

        vQryGinkoia.Next;
      end;
      vQryMaintenanceS.Close;
      vQryMaintenanceU.Close;
      vQryGinkoia.Close;

      // SR 13/03/2014 : Partie Synchro Emetteur Maintenance -> Ginkoia (On supprime les emetteurs présent dans Maintenance et inéxistant dans Ginkoia)
      try
        vQryMaintenanceS.SQL.Text := 'SELECT EMET_ID, EMET_GUID FROM EMETTEUR WHERE EMET_DOSSID = :PEMETDOSSID';
        vQryMaintenanceS.ParamByName('PEMETDOSSID').AsInteger := ADOSS_ID;
        vQryMaintenanceS.Open;
        vQryMaintenanceS.First;

        vQryGinkoia.SQL.Text := 'Select BAS_ID From GENBASES Join K on (K_ID = BAS_ID and K_ENABLED = 1) Where BAS_GUID = :PBASGUID';
        vQryMaintenanceU.SQL.Text := 'Delete From EMETTEUR Where EMET_ID = :PEMETID';

        while not vQryMaintenanceS.Eof do
        begin
          vQryGinkoia.Close;
          vQryGinkoia.ParamByName('PBASGUID').AsString := vQryMaintenanceS.FieldByName('EMET_GUID').AsString;
          vQryGinkoia.Open;
          vQryGinkoia.First;

          if vQryGinkoia.Eof then // Si non présent dans Ginkoia, on supprime la ligne
          begin
            if not vQryMaintenanceU.Connection.Transaction.Active then
              vQryMaintenanceU.Connection.Transaction.StartTransaction;

            vQryMaintenanceU.Close;
            vQryMaintenanceU.ParamByName('PEMETID').AsInteger := vQryMaintenanceS.FieldByName('EMET_ID').AsInteger;
            vQryMaintenanceU.ExecSQL;
            if vQryMaintenanceU.Connection.Transaction.Active then
              vQryMaintenanceU.Connection.Transaction.Commit;
          end;
          vQryMaintenanceS.Next;
        end;
        vQryMaintenanceS.Close;
        vQryMaintenanceU.Close;
        vQryGinkoia.Close;
      except
        on E: Exception do
        begin
          Raise Exception.Create(ClassName + '.SyncBase : ' + E.Message);
          // LogDebug(FichierLog, 'Except : Partie Synchro Emetteur Maintenance -> Ginkoia');
          // LogDebug(FichierLog, '         ' + E.Message);
          // LogDebug(FichierLog, '         ' + vQryMaintenanceU.SQL.Text);
          // LogDebug(FichierLog, '         PEMETID = ' + IntToStr(vQryMaintenanceU.ParamByName('PEMETID').AsInteger));
          vQryMaintenanceU.Connection.Transaction.Rollback;
        end;
      end;

      // SR 11/04/2014 : Partie Synchro UILGRPGINKOIA Ginkoia -> Maintenance MODULES
      try
        vQryGinkoia.SQL.Clear;
        vQryGinkoia.SQL.Append('Select');
        vQryGinkoia.SQL.Append('	UGG_NOM,');
        vQryGinkoia.SQL.Append('	UGG_COMMENT');
        vQryGinkoia.SQL.Append('From UILGRPGINKOIA');
        // vQryGinkoia.SQL.Append('Join K on (K_ID = UGG_ID and K_ENABLED = 1)');
        vQryGinkoia.SQL.Append('Where UGG_ID <> 0');
        vQryGinkoia.Open;
        vQryGinkoia.First;

        vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Modules;

        while not vQryGinkoia.Eof do
        begin
          vQryMaintenanceS.Close;
          vQryMaintenanceS.ParamByName('PMODUNOM').AsString := vQryGinkoia.FieldByName('UGG_NOM').AsString;
          vQryMaintenanceS.Open;

          if vQryMaintenanceS.Eof then
          begin
            // Insert car non présent
            if not vQryMaintenanceU.Connection.Transaction.Active then
              vQryMaintenanceU.Connection.Transaction.StartTransaction;

            vQryMaintenanceU.Close;
            vQryMaintenanceU.SQL.Text := cSql_I_SyncBase_Modules;
            vQryMaintenanceU.ParamByName('PMODUID').AsInteger := dmMaintenance.GetNewID('MODULES');
            vQryMaintenanceU.ParamByName('PMODUNOM').AsString := vQryGinkoia.FieldByName('UGG_NOM').AsString;
            vQryMaintenanceU.ParamByName('PMODUCOMMENT').AsString := vQryGinkoia.FieldByName('UGG_COMMENT').AsString;
            vQryMaintenanceU.ExecSQL;
            if vQryMaintenanceU.Connection.Transaction.Active then
              vQryMaintenanceU.Connection.Transaction.Commit;
          end;
          vQryGinkoia.Next;
        end;
        vQryMaintenanceS.Close;
        vQryMaintenanceU.Close;
        vQryGinkoia.Close;
      except
        on E: Exception do
        begin
          Raise Exception.Create(ClassName + '.SyncBase : ' + E.Message);
          // LogDebug(FichierLog, 'Except : Partie Synchro UILGRPGINKOIA Ginkoia -> Maintenance MODULES');
          // LogDebug(FichierLog, '         ' + E.Message);
          // LogDebug(FichierLog, '         ' + vQryMaintenanceU.SQL.Text);
          // LogDebug(FichierLog, '         PMODUID = ' + IntToStr(vQryMaintenanceU.ParamByName('PMODUID').AsInteger));
          // LogDebug(FichierLog, '         PMODUNOM = ' + vQryMaintenanceU.ParamByName('PMODUNOM').AsString);
          // LogDebug(FichierLog, '         PMODUCOMMENT = ' + vQryMaintenanceU.ParamByName('PMODUCOMMENT').AsString);
          vQryMaintenanceU.Connection.Transaction.Rollback;
        end;
      end;

      // SR 17/04/2014 : Partie Synchro UILGRPGINKOIAMAG Ginkoia -> Maintenance MODULES_MAGASINS
      try
        vQryGinkoia.SQL.Clear;
        vQryGinkoia.SQL.Append('Select');
        vQryGinkoia.SQL.Append('	UGM_ID,');
        vQryGinkoia.SQL.Append('	UGM_MAGID,');
        vQryGinkoia.SQL.Append('	UGM_UGGID,');
        vQryGinkoia.SQL.Append('	UGM_DATE,');
        vQryGinkoia.SQL.Append('	K_ENABLED,');
        vQryGinkoia.SQL.Append('	UGG_NOM');
        vQryGinkoia.SQL.Append('From UILGRPGINKOIAMAG');
        vQryGinkoia.SQL.Append('Join K on (K_ID = UGM_ID)');
        vQryGinkoia.SQL.Append('Join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
        vQryGinkoia.SQL.Append('Where UGM_ID <> 0');
        vQryGinkoia.Open;
        vQryGinkoia.First;

        while not vQryGinkoia.Eof do
        begin
          vQryMaintenanceS.Close;
          vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Modules_Magasins;
          vQryMaintenanceS.ParamByName('PMODUNOM').AsString := vQryGinkoia.FieldByName('UGG_NOM').AsString;
          vQryMaintenanceS.ParamByName('PMAGAMAGID_GINKOIA').AsInteger := vQryGinkoia.FieldByName('UGM_MAGID').AsInteger;
          vQryMaintenanceS.ParamByName('PMMAG_DOSSID').AsInteger := ADOSS_ID;
          vQryMaintenanceS.Open;

          if not vQryMaintenanceU.Connection.Transaction.Active then
            vQryMaintenanceU.Connection.Transaction.StartTransaction;

          vQryMaintenanceU.Close;

          if vQryMaintenanceS.Eof then
          begin
            // Insert car non présent
            vQryMaintenanceU.SQL.Text := cSql_I_Modules_Magasins;
          end
          else
          begin
            // Update
            vQryMaintenanceU.SQL.Text := cSql_U_Modules_Magasins;
          end;

          vQryMaintenanceS.Close;
          vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Modules;
          vQryMaintenanceS.ParamByName('PMODUNOM').AsString := vQryGinkoia.FieldByName('UGG_NOM').AsString;
          vQryMaintenanceS.Open;
          iMODUID := vQryMaintenanceS.FieldByName('MODU_ID').AsInteger;

          vQryMaintenanceS.Close;
          vQryMaintenanceS.SQL.Text := cSql_S_SyncBase_Magasins;
          vQryMaintenanceS.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := vQryGinkoia.FieldByName('UGM_MAGID').AsInteger;
          vQryMaintenanceS.ParamByName('PMAGADOSSID').AsInteger := ADOSS_ID;
          vQryMaintenanceS.Open;
          iMAGAID := vQryMaintenanceS.FieldByName('MAGA_ID').AsInteger;

          vQryMaintenanceU.ParamByName('PMMAGMODUID').AsInteger := iMODUID;
          vQryMaintenanceU.ParamByName('PMMAGMAGAID').AsInteger := iMAGAID;
          vQryMaintenanceU.ParamByName('PMMAGEXPDATE').AsDateTime := vQryGinkoia.FieldByName('UGM_DATE').AsDateTime;
          vQryMaintenanceU.ParamByName('PMMAGKENABLED').AsInteger := vQryGinkoia.FieldByName('K_ENABLED').AsInteger;
          vQryMaintenanceU.ParamByName('PMMAGUGMID').AsInteger := vQryGinkoia.FieldByName('UGM_ID').AsInteger;
          vQryMaintenanceU.ExecSQL;
          if vQryMaintenanceU.Connection.Transaction.Active then
            vQryMaintenanceU.Connection.Transaction.Commit;

          vQryGinkoia.Next;
        end;
        vQryMaintenanceS.Close;
        vQryMaintenanceU.Close;
        vQryGinkoia.Close;
      except
        on E: Exception do
        begin
          Raise Exception.Create(ClassName + '.SyncBase : ' + E.Message);
          // LogDebug(FichierLog, 'Except : Partie Synchro UILGRPGINKOIAMAG Ginkoia -> Maintenance MODULES_MAGASINS');
          // LogDebug(FichierLog, '         ' + E.Message);
          // LogDebug(FichierLog, '         ' + vQryMaintenanceU.SQL.Text);
          // LogDebug(FichierLog, '         PMMAGMODUID = ' + IntToStr(vQryMaintenanceU.ParamByName('PMMAGMODUID').AsInteger));
          // LogDebug(FichierLog, '         PMMAGMAGAID = ' + IntToStr(vQryMaintenanceU.ParamByName('PMMAGMAGAID').AsInteger));
          // LogDebug(FichierLog, '         PMMAGEXPDATE = ' + DateTimeToStr(vQryMaintenanceU.ParamByName('PMMAGEXPDATE').AsDateTime));
          // LogDebug(FichierLog, '         PMMAGKENABLED = ' + IntToStr(vQryMaintenanceU.ParamByName('PMMAGKENABLED').AsInteger));
          // LogDebug(FichierLog, '         PMMAGUGMID = ' + IntToStr(vQryMaintenanceU.ParamByName('PMMAGUGMID').AsInteger));
          vQryMaintenanceU.Connection.Transaction.Rollback;
        end;
      end;
      if vQryMaintenanceU.Connection.Transaction.Active then
        vQryMaintenanceU.Connection.Transaction.Commit;

    except
      on E: Exception do
      begin
        Raise Exception.Create(ClassName + '.SyncBase : ' + E.Message);
        Result := 'Erreur dans SyncBase : ' + E.Message;
      end;
    end;
  finally
    FreeAndNil(vQryGinkoia);
    FreeAndNil(vQryMaintenanceS);
    FreeAndNil(vQryMaintenanceU);
  end;
  Result := 'Synchronisation de la base effectué.';
end;

procedure TMaintenanceCtrl.SynchronizeBAS_IDENTToEMET_IDENT(Const ADOSS_ID, ASERV_ID: integer; Const AListDossier: TDataSet;
  Const ADmGINKOIA: TdmGINKOIA; var AResultMsg: RStatusMessage);
var
  vDOSS_ID: integer;
  vQryDos, vQryEmet, vQryEmetU, vQryGinkoia: TFDQuery;
  vdmGINKOIA: TdmGINKOIA;
  vDosChemin, vSrvNom: String;
  vDS: TDataSet;
  vSLTraceur: TStringList;
begin
  vDOSS_ID := ADOSS_ID;
  vDS := nil;
  vdmGINKOIA := nil;
  vQryGinkoia := nil;
  vQryDos := nil;

  vQryEmet := dmMaintenance.GetNewQry;
  vQryEmetU := dmMaintenance.GetNewQry;
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur := TStringList.Create;
    vSLTraceur.Append(GetNowToStr + 'SynchronizeBAS_IDENTToEMET_IDENT');
    vSLTraceur.Append(GetNowToStr + 'DOSS_ID : ' + IntToStr(ADOSS_ID));
    vSLTraceur.Append(GetNowToStr + 'SERV_ID : ' + IntToStr(ASERV_ID));
    vSLTraceur.Append(GetNowToStr + 'ResultMsg.Code : ' + IntToStr(AResultMsg.Code));
    vSLTraceur.Append(GetNowToStr + 'ResultMsg.AMessage : ' + AResultMsg.AMessage);
  end;
  try
    if AListDossier <> nil then
    begin
      vDS := AListDossier;
      vDOSS_ID := vDS.FieldByName('DOSS_ID').AsInteger;
    end;

    if vDOSS_ID <> -1 then
    begin
      if vDS = nil then
      begin
        vQryDos := dmMaintenance.GetNewQry;
        vQryDos.SQL.Append('SELECT DOSS_CHEMIN, SERV_NOM FROM DOSSIER, SERVEUR');
        vQryDos.SQL.Append('WHERE (DOSS_SERVID=SERV_ID) AND (DOSS_ID=:PDOSS_ID)');
        vQryDos.Params[0].AsInteger := vDOSS_ID;
        vQryDos.Open;
        vDS := vQryDos;
      end;

      if not vDS.Eof then
      begin
        vDosChemin := vDS.FieldByName('DOSS_CHEMIN').AsString;
        if vDosChemin = '' then
        begin
          AResultMsg := SM_PathDBMissing;
          Exit;
        end;

        vSrvNom := vDS.FieldByName('SERV_NOM').AsString;
        if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
          vSLTraceur.Append(GetNowToStr + 'vSrvNom : ' + vSrvNom);

        // {$IFDEF WAD}
        // if vSrvNom <> 'LOCALHOST' then
        // Exit;
        // {$ELSE}
        // if not FileExists(IncludeTrailingBackslash(DOSS_CHEMINToUNC(vSrvNom, vDosChemin)) + cDB_FileName_GINKOIA) then
        // begin
        // AResultMsg:= SM_PathNotFound;
        // Exit;
        // end;
        // {$ENDIF}
      end;
    end;

    if ADmGINKOIA <> nil then
      vdmGINKOIA := ADmGINKOIA
    else if vDosChemin <> '' then
      vdmGINKOIA := ConnectToGINKOIA(vDosChemin)
    else
      Exit;

    vQryGinkoia := vdmGINKOIA.GetNewQry;

    vQryEmetU.SQL.Text := 'UPDATE EMETTEUR SET EMET_IDENT=:PEMET_IDENT, EMET_BASID_GINKOIA=:PEMET_BASID_GINKOIA WHERE EMET_GUID=:PEMET_GUID';
    vQryGinkoia.SQL.Text := 'SELECT BAS_IDENT, BAS_ID FROM GENBASES WHERE BAS_GUID=:PBAS_GUID';

    if vDOSS_ID <> -1 then
    begin
      vQryEmet.SQL.Text := 'SELECT EMET_GUID, EMET_IDENT, EMET_BASID_GINKOIA FROM EMETTEUR WHERE EMET_DOSSID=:PEMETDOSSID';
      vQryEmet.ParamByName('PEMETDOSSID').AsInteger := vDOSS_ID;
    end
    else if ASERV_ID <> -1 then
    begin
      vQryEmet.SQL.Append('SELECT EMET_GUID, EMET_IDENT, EMET_BASID_GINKOIA FROM EMETTEUR, DOSSIER ');
      vQryEmet.SQL.Append('WHERE (EMET_DOSSID=DOSS_ID) AND (DOSS_SERVID=:PDOSSSERVID)');
      vQryEmet.ParamByName('PDOSSSERVID').AsInteger := ASERV_ID;
    end
    else
      Exit;

    vQryEmet.Open;

    try
      if not vQryEmetU.Connection.Transaction.Active then
        vQryEmetU.Connection.Transaction.StartTransaction;

      while not vQryEmet.Eof do
      begin
        if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
          vSLTraceur.Append(GetNowToStr + 'EMET_GUID : ' + vQryEmet.FieldByName('EMET_GUID').AsString);

        vQryGinkoia.Close;
        vQryGinkoia.Params[0].AsString := vQryEmet.FieldByName('EMET_GUID').AsString;
        vQryGinkoia.Open;

        if (not vQryGinkoia.Eof) and ((vQryEmet.FieldByName('EMET_IDENT').IsNull) or
          (vQryEmet.FieldByName('EMET_IDENT').AsInteger <> vQryGinkoia.FieldByName('BAS_IDENT').AsInteger) or
          (vQryEmet.FieldByName('EMET_BASID_GINKOIA').IsNull) or (vQryEmet.FieldByName('EMET_BASID_GINKOIA').AsInteger <>
          vQryGinkoia.FieldByName('BAS_ID').AsInteger)) then
        begin
          if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
          begin
            vSLTraceur.Append(GetNowToStr + '-----------');
            vSLTraceur.Append(GetNowToStr + 'BAS_IDENT : ' + IntToStr(vQryGinkoia.FieldByName('BAS_IDENT').AsInteger));
            vSLTraceur.Append(GetNowToStr + 'EMET_GUID : ' + vQryEmet.FieldByName('EMET_GUID').AsString);
            vSLTraceur.Append(GetNowToStr + '-----------');
          end;
          vQryEmetU.Close;
          vQryEmetU.ParamByName('PEMET_IDENT').AsInteger := vQryGinkoia.FieldByName('BAS_IDENT').AsInteger;
          vQryEmetU.ParamByName('PEMET_BASID_GINKOIA').AsInteger := vQryGinkoia.FieldByName('BAS_ID').AsInteger;
          vQryEmetU.ParamByName('PEMET_GUID').AsString := vQryEmet.FieldByName('EMET_GUID').AsString;
          vQryEmetU.ExecSQL;
        end;

        vQryEmet.Next;
      end;
      if vQryEmetU.Connection.Transaction.Active then
        vQryEmetU.Connection.Transaction.Commit;
    except
      on E: Exception do
      begin
        if vQryEmetU.Connection.Transaction.Active then
          vQryEmetU.Connection.Transaction.Rollback;
        AResultMsg := SM_ERREUR_INTERNE;
        AResultMsg.AMessage := E.Message;
      end;
    end;
  finally
    FreeAndNil(vQryEmet);
    FreeAndNil(vQryEmetU);
    if vQryDos <> nil then
      FreeAndNil(vQryDos);
    if (ADmGINKOIA = nil) and (vdmGINKOIA <> nil) then
      FreeAndNil(vdmGINKOIA);
    if vQryGinkoia <> nil then
      FreeAndNil(vQryGinkoia);

    if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
    begin
      vSLTraceur.Append(GetNowToStr + 'ResultMsg.Code : ' + IntToStr(AResultMsg.Code));
      vSLTraceur.Append(GetNowToStr + 'ResultMsg.AMessage : ' + AResultMsg.AMessage);
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'SynchronizeBAS_IDENTToEMET_IDENT' + GWSConfig.GetTime + '.Traceur', vSLTraceur,
        GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TMaintenanceCtrl.SynchronizeDossier(var AResultMsg: RStatusMessage);
var
  vSLExcept: TStringList;
  vResultMsg: RStatusMessage;
  vQryDos: TFDQuery;
begin
  AResultMsg := SM_OK;
  vSLExcept := TStringList.Create;
  vQryDos := dmMaintenance.GetNewQry;
  try
    try
      vQryDos.SQL.Append('SELECT DOSS_ID, DOSS_CHEMIN, SERV_NOM FROM DOSSIER, SERVEUR');
      vQryDos.SQL.Append('WHERE (DOSS_SERVID=SERV_ID) AND (DOSS_CHEMIN <> '''')');
      vQryDos.Open;

      while not vQryDos.Eof do
      begin
        SynchronizeBAS_IDENTToEMET_IDENT(-1, -1, vQryDos, nil, vResultMsg);
        vQryDos.Next;
      end;

    except
      on E: Exception do
      begin
        AResultMsg := SM_ERREUR_INTERNE;
        AResultMsg.AMessage := E.Message;
        vSLExcept.Append('TMaintenanceCtrl.SynchronizeDossier');
        vSLExcept.Append(E.Message);
        GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TMaintenanceCtrl_SynchronizeDossier.Except', vSLExcept,
          GWSConfig.LogException);
      end;
    end;
  finally
    FreeAndNil(vSLExcept);
  end;
end;

function TMaintenanceCtrl.VerifMaintenanceVersion(const AVERSIONCLIENT: string): string;
var
  vQryMaintenanceS: TFDQuery;
begin
  Result := '';
  try
    try
      vQryMaintenanceS := dmMaintenance.GetNewQry;

      vQryMaintenanceS.SQL.Text := cSql_S_MAINTENANCE_VERSION;
      vQryMaintenanceS.Open;

      { // Pour EASY il faut obligatoirement être en V1.2.3 }
      if AVERSIONCLIENT = vQryMaintenanceS.FieldByName('VMAI_VERSION').AsString then
      begin
        Result := 'Version de la DLL et du client identique (' + AVERSIONCLIENT + ').';
      end
      else
      begin
        Result := 'Version de la DLL (' + vQryMaintenanceS.FieldByName('VMAI_VERSION').AsString + ') et du client (' + AVERSIONCLIENT +
          ') sont différentes.';
      end;

      if (vQryMaintenanceS.FieldByName('VMAI_VERSION').AsString = 'v1.2.3') then
      begin
        Result := Result + #13 + #10 + 'Attention : Version EASY sur la DLL !';
      end;

    except
      on E: Exception do
      begin
        Raise Exception.Create(ClassName + '.VerifMaintenanceVersion : ' + E.Message);
        Result := 'Erreur dans VerifMaintenanceVersion : ' + E.Message;
      end;
    end;
  finally
    FreeAndNil(vQryMaintenanceS);
  end;
end;

procedure TMaintenanceCtrl.ChangeDossier(const ADossier, ANewDossier: TDossier);
var
  i: integer;
  vSLDirData, vSLNewDir, vSLLog: TStringList;
  Buffer, vDirData,
  // vDirTmp,
  vNewDir: String;
  vPathAndName, vFileNameCible: String;
  vPathDossierVierge, vPathDistantVDossierClient: String;
  vPathEAI, vNewPathEAI: String;
  vNewPathDistantVDossierClient: String;
  vSearch: TSearching;
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
  vVer: TVersion;
  vSLTraceur: TStringList;
begin
  vdmGINKOIA := nil;
  vQry := nil;
  if UpperCase(ADossier.DOSS_CHEMIN) <> UpperCase(ANewDossier.DOSS_CHEMIN) then
  begin
    vSLDirData := TStringList.Create;
    vSLNewDir := TStringList.Create;
    vSLLog := TStringList.Create;
    vSearch := TSearching.Create(GWSConfig.ServiceFileName);
    vSLTraceur := TStringList.Create;
    try
      try
{$IFDEF WAD}
        vDirData := ExcludeTrailingBackslash(ExtractFilePath(ADossier.DOSS_CHEMIN));
        vNewDir := ExcludeTrailingBackslash(ExtractFilePath(ANewDossier.DOSS_CHEMIN));

        { Construction du path dossier vierge ( D:\EAI\VDossier\DossierVierge ) }
        vPathDossierVierge := GWSConfig.Options.Values['PATHBASEVIERGE'];

        if DirectoryExists(vPathDossierVierge) then
        begin
          { Construction du path DOSS_DATABASE ( D:\EAI\VDossier\MERCIER ) }
          vPathDistantVDossierClient := IncludeTrailingBackslash(UpDirectory(vPathDossierVierge, 1)) + ADossier.DOSS_DATABASE;

          { Construction du path du nouveau DOSS_DATABASE ( D:\EAI\VDossier\TOTO ) }
          vNewPathDistantVDossierClient := IncludeTrailingBackslash(UpDirectory(vPathDossierVierge, 1)) + ANewDossier.DOSS_DATABASE;
        end;

        { Construction du path EAI ( D:\EAI ) }
        vPathEAI := ADossier.AServeur.SERV_DOSEAI;
{$ELSE}
        vDirData := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, ADossier.DOSS_CHEMIN); // --> \\GSA-LAME3\EAI\Sport2000\MERCIER\DATA
        vNewDir := DOSS_CHEMINToUNC(ANewDossier.AServeur.SERV_NOM, ANewDossier.DOSS_CHEMIN); // --> \\GSA-LAME3\EAI\Sport2000\TOTO\DATA

        { Construction du path distant dossier vierge ( \\GSA-LAME3\EAI\VDossier\DossierVierge ) }
        vPathDossierVierge := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, GWSConfig.Options.Values['PATHBASEVIERGE']);

        if DirectoryExists(vPathDossierVierge) then
        begin
          { Construction du path distant DOSS_DATABASE ( \\GSA-LAME3\EAI\VDossier\MERCIER ) }
          vPathDistantVDossierClient := IncludeTrailingBackslash(UpDirectory(vPathDossierVierge, 1)) + ADossier.DOSS_DATABASE;

          { Construction du path distant du nouveau DOSS_DATABASE ( \\GSA-LAME3\EAI\VDossier\MERCIER ) }
          vNewPathDistantVDossierClient := IncludeTrailingBackslash(UpDirectory(vPathDossierVierge, 1)) + ANewDossier.DOSS_DATABASE;
        end;

        { Construction du path distant EAI ( \\GSA-LAME3\EAI ) }
        vPathEAI := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, ADossier.AServeur.SERV_DOSEAI);
        vNewPathEAI := DOSS_CHEMINToUNC(ANewDossier.AServeur.SERV_NOM, ANewDossier.AServeur.SERV_DOSEAI);
{$ENDIF}
        vSLTraceur.Append(GetNowToStr + 'DirData : ' + vDirData);
        vSLTraceur.Append(GetNowToStr + 'NewDir : ' + vNewDir);
        vSLTraceur.Append(GetNowToStr + 'PathDossierVierge : ' + vPathDossierVierge);
        vSLTraceur.Append(GetNowToStr + 'PathDistantVDossierClient : ' + vPathDistantVDossierClient);
        vSLTraceur.Append(GetNowToStr + 'NewPathDistantVDossierClient : ' + vNewPathDistantVDossierClient);
        vSLTraceur.Append(GetNowToStr + 'PathEAI : ' + vPathEAI);

        { ---------------------------- DATABASE ---------------------------- }
        if not DirectoryExists(vNewDir) then
        begin
          ForceDirectories(vNewDir);
          vSLTraceur.Append(GetNowToStr + 'Création de NewDir : ' + vNewDir);
        end
        else
          Raise Exception.Create('Le chemin de ce dossier existe déjà.');

        { Recherche les fichiers dans l'ancien repertoire }
        vSearch.Searching(vDirData, '*.*', False);
        if vSearch.NbFilesFound = 0 then
          Exit;

        { Deplacement/Copie des fichiers dans le nouveau repertoire }
        for i := 0 to vSearch.NbFilesFound - 1 do
        begin
          if vSearch.TabInfoSearch[i].PathAndName <> '' then
          begin
            vPathAndName := string(vSearch.TabInfoSearch[i].PathAndName);
            vFileNameCible := StringReplace(vPathAndName, vDirData, vNewDir, []);

            Buffer := ExtractFilePath(vFileNameCible);
            if not DirectoryExists(Buffer) then
              ForceDirectories(Buffer);

            { Afin d'optimiser les transferts des fichiers, on verifie si
              le traitement doit s'effectuer sur la même lame ou non.
              Si c'est sur la même lame, on effectue un déplacement si
              non, ce sera une copie }
            if ADossier.AServeur.SERV_NOM = ANewDossier.AServeur.SERV_NOM then
            begin
              if not MoveFile(PChar(vPathAndName), PChar(vFileNameCible)) then
                vSLLog.Append(string(vSearch.TabInfoSearch[i].PathAndName));
            end
            else
            begin
              if not CopyFile(PChar(vPathAndName), PChar(vFileNameCible), False) then
                vSLLog.Append(string(vSearch.TabInfoSearch[i].PathAndName));
            end;
          end;
        end;

        if vSLLog.Count <> 0 then
          Raise Exception.Create('Impossible de deplacer le(s) fichier(s) :' + cRC + vSLLog.Text);

        vSLTraceur.Append(GetNowToStr + 'Déplacement des fichiers de : ' + vDirData + ' vers ' + vNewDir);

        { Suppression de l'ancien repertoire }
        DeleteFile(IncludeTrailingBackslash(vDirData) + cDB_FileName_GINKOIA);
        vSLDirData.Text := StringReplace(vDirData, '\', #13#10, [rfReplaceAll]);
        vSLNewDir.Text := StringReplace(vNewDir, '\', #13#10, [rfReplaceAll]);
        Buffer := vDirData;
        for i := vSLDirData.Count - 1 Downto 0 do
        begin
          vSearch.Searching(Buffer, '*.*', False);
          if (vSearch.NbFilesFound = 0) and (vSearch.NbFoldersFound = 0) then

            RemoveDir(Buffer);

          Buffer := UpDirectory(Buffer, 1);

          if UpperCase(vSLNewDir.Strings[i]) <> UpperCase(vSLDirData.Strings[i]) then
            Break;
        end;

        vSLTraceur.Append(GetNowToStr + 'Suppression de : ' + vDirData);

        { ---------------------------- V_DOSSIERS -------------------------- }
        vdmGINKOIA := GetNewdmGINKOIAByDossier(ANewDossier);
        vQry := vdmGINKOIA.GetNewQry;

        vQry.SQL.Text := cSql_S_genversion;
        vQry.Open;
        if vQry.Eof then
          Raise Exception.Create('Version introuvable dans la nouvelle base.');

        vVer := VersionByVERS_VERSION[vQry.FieldByName('VER_VERSION').AsString];

        if vVer = nil then
          Raise Exception.Create('Version introuvable dans la base Maintenance.');

        vQry.Close;

        { Pour les versions > 11.3.0.1 on copie tout le repertoire du dossier
          vierge dans le nouveau repertoire du client }
        if (vNewPathDistantVDossierClient <> '') and (CompareVersion(vVer.VERS_VERSION, cVersionRef) = 1) then
        begin
          if not DirectoryExists(vNewPathDistantVDossierClient) then
          begin
            ForceDirectories(vNewPathDistantVDossierClient);
            vSLTraceur.Append(GetNowToStr + 'Création de NewPathDistantVDossierClient : ' + vNewPathDistantVDossierClient);
          end
          else
            Raise Exception.Create('Le chemin de ce dossier existe déjà.');

          { Recherche les fichiers dans l'ancien repertoire }
          vSearch.Searching(vPathDistantVDossierClient, '*.*', True);
          if vSearch.NbFilesFound = 0 then
            Exit;

          { Deplacement/Copie des fichiers dans le nouveau repertoire }
          for i := 0 to vSearch.NbFilesFound - 1 do
          begin
            if vSearch.TabInfoSearch[i].PathAndName <> '' then
            begin
              vPathAndName := string(vSearch.TabInfoSearch[i].PathAndName);
              vFileNameCible := StringReplace(vPathAndName, vPathDistantVDossierClient, vNewPathDistantVDossierClient, []);

              Buffer := ExtractFilePath(vFileNameCible);
              if not DirectoryExists(Buffer) then
                ForceDirectories(Buffer);

              { Afin d'optimiser les transferts des fichiers, on verifie si
                le traitement doit s'effectuer sur la même lame ou non.
                Si c'est sur la même lame, on effectue un déplacement si
                non, ce sera une copie }
              if ADossier.AServeur.SERV_NOM = ANewDossier.AServeur.SERV_NOM then
              begin
                if not MoveFile(PChar(vPathAndName), PChar(vFileNameCible)) then
                  vSLLog.Append(string(vSearch.TabInfoSearch[i].PathAndName));
              end
              else
              begin
                if not CopyFile(PChar(vPathAndName), PChar(vFileNameCible), False) then
                  vSLLog.Append(string(vSearch.TabInfoSearch[i].PathAndName));
              end;
            end;
          end;

          if vSLLog.Count <> 0 then
            Raise Exception.Create('Impossible de deplacer le(s) fichier(s) :' + cRC + vSLLog.Text);

          vSLTraceur.Append(GetNowToStr + 'Déplacement des fichiers de : ' + vPathDistantVDossierClient + ' vers ' + vNewPathDistantVDossierClient);

          { Suppression de l'ancien repertoire }
          DeleteDirectory(vPathDistantVDossierClient);

          { vSLDirData.Text:= StringReplace(vPathDistantVDossierClient, '\', #13#10, [rfReplaceAll]);
            vSLNewDir.Text:= StringReplace(vNewPathDistantVDossierClient, '\', #13#10, [rfReplaceAll]);
            Buffer:= vPathDistantVDossierClient;
            for i:= vSLDirData.Count -1 Downto 0 do
            begin
            vSearch.Searching(Buffer, '*.*', False);
            if (vSearch.NbFilesFound = 0) and (vSearch.NbFoldersFound = 0) then
            RemoveDir(Buffer);

            Buffer:= UpDirectory(Buffer, 1);

            if UpperCase(vSLNewDir.Strings[i]) <> UpperCase(vSLDirData.Strings[i]) then
            Break;
            end; }
          vSLTraceur.Append(GetNowToStr + 'Suppression de : ' + vPathDistantVDossierClient);
        end;

        { ----------------------------- MAJ XML ---------------------------- }
        if (vNewPathDistantVDossierClient <> '') and (CompareVersion(vVer.VERS_VERSION, cVersionRef) = 1) then
        begin
          { Mise à jour du fichier DelosQPMAgent.Databases.xml du repertoire V_DOSSIERS\DOSS_DATABASE }
          if MAJXmlDatabases(vNewPathDistantVDossierClient, ANewDossier, ADossier) then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : ' + vNewPathDistantVDossierClient)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : Erreur');

          { Mise à jour du fichier DelosQPMAgent.DataSources.xml du repertoire V_DOSSIERS\DOSS_DATABASE }
          if MAJXmlDataSources(vNewPathDistantVDossierClient, '', ANewDossier, '') then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDataSources : ' + vNewPathDistantVDossierClient)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDataSources : Erreur');

          { Mise à jour du fichier DelosQPMAgent.InitParam.xml du repertoire V_DOSSIERS\DOSS_DATABASE }
          if MAJXmlInitParamXMLCInstanceName(vNewPathDistantVDossierClient, ANewDossier) then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlInitParamXMLCInstanceName : ' + vNewPathDistantVDossierClient)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlInitParamXMLCInstanceName : Erreur');
        end;

        { Mise à jour du fichier DelosQPMAgent.Databases.xml du repertoire Vx_x_x }
        Buffer := IncludeTrailingBackslash(vNewPathEAI) + StringReplace(vVer.VERS_EAI, 'Bin', '', [rfIgnoreCase]);
        if MAJXmlDatabases(Buffer, ANewDossier, ADossier) then
          vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : ' + Buffer)
        else
          vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : Erreur');

        if ADossier.AServeur.SERV_NOM <> ANewDossier.AServeur.SERV_NOM then
        begin
          { Suppression du dossier dans le fichier DelosQPMAgent.Databases.xml du repertoire Vx_x_x }
          Buffer := IncludeTrailingBackslash(vPathEAI) + StringReplace(vVer.VERS_EAI, 'Bin', '', [rfIgnoreCase]);
          if MAJXmlDatabases(Buffer, ADossier, nil, True) then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases.Delete : ' + Buffer)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases.Delete : Erreur');
        end;

      except
        on E: Exception do
          Raise Exception.Create(ClassName + '.ChangeDossier : ' + E.Message);
      end;

    finally
      FreeAndNil(vSLDirData);
      FreeAndNil(vSLNewDir);
      FreeAndNil(vSearch);
      FreeAndNil(vSLLog);
      if vdmGINKOIA <> nil then
        FreeAndNil(vdmGINKOIA);
      if vQry <> nil then
        FreeAndNil(vQry);

      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'ChangeDossier' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TMaintenanceCtrl.CheckConnexionByDossier(const ADossier: TDossier; var AResultMsg: RStatusMessage);
var
  vdmGINKOIA: TdmGINKOIA;
begin
  AResultMsg := SM_OK;
  vdmGINKOIA := nil;
  try
    try
      vdmGINKOIA := GMaintenanceCtrl.GetNewdmGINKOIAByDossier(ADossier);
    except
      on E: Exception do
      begin
        AResultMsg := SM_ERREUR_INTERNE;
        AResultMsg.AMessage := E.Message;
      end;
    end;
  finally
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
  end;
end;

constructor TMaintenanceCtrl.Create(AOwner: TComponent);
begin
  try
    inherited Create(AOwner);

    FListDos := TObjectList.Create(True);
    FListMag := TObjectList.Create(True);
    FListPoste := TObjectList.Create(True);
    FListMod := TObjectList.Create(True);
    FListEmet := TObjectList.Create(False);
    FListSrv := TObjectList.Create(True);
    FListGrp := TObjectList.Create(True);
    FListVer := TObjectList.Create(True);
    FListRaison := TObjectList.Create(True);
    IntializeCtrl;
  except
    on E: Exception do
    begin
      // vSL.Append(E.Message);
      // WLog.WriteLine(E.Message);
    end;
  end;
end;

// Ajout par AJ le 15/09/2017, création du genparambase d'identification de base de PROD
procedure TMaintenanceCtrl.SetGenParamBaseTypeBase(aDataModule: TdmGINKOIA);
var
  vQryGenParamBase: TFDQuery;
begin
  vQryGenParamBase := aDataModule.GetNewQry;

  // On regarde si le GENPARAMBASE existe déjà, si oui on l'update, sinon on l'ajoute, TOUJOURS avec la valeur BASE DE PROD
  // 1=Base de prod   2=Base de test    3=Archive
  vQryGenParamBase.SQL.Text := 'SELECT * FROM GENPARAMBASE WHERE PAR_NOM = ''BASETYPE'';';
  vQryGenParamBase.Open();

  if (vQryGenParamBase.Eof) then
  begin
    vQryGenParamBase.SQL.Text := 'INSERT INTO GENPARAMBASE (PAR_NOM, PAR_STRING, PAR_FLOAT) VALUES (''BASETYPE'','''',1);';
    vQryGenParamBase.ExecSQL;
  end
  else
  begin
    vQryGenParamBase.SQL.Text := 'UPDATE GENPARAMBASE SET PAR_FLOAT = 1 WHERE PAR_NOM = ''BASETYPE'';';
    vQryGenParamBase.ExecSQL;
  end;

  vQryGenParamBase.Close;
end;

procedure TMaintenanceCtrl.CreateBase(Const ADirSource: String; Const ADossier: TDossier);
  procedure CheckORDREGenProviders(Const ADmGINKOIA: TdmGINKOIA);
  var
    i, vCptOrdre, vDistinctOrdre: integer;
    vQry: TFDQuery;
    vObjList: TObjectList;
    vGnkGenProviders: TGnkGenProviders;
  begin
    vObjList := nil;
    vCptOrdre := 0;
    vDistinctOrdre := 0;

    try
      vQry := ADmGINKOIA.GetNewQry;

      vQry.SQL.Text := 'SELECT COUNT(PRO_ORDRE) FROM GENPROVIDERS';
      vQry.Open;
      if not vQry.Eof then
        vCptOrdre := vQry.Fields[0].AsInteger;

      vQry.SQL.Text := 'SELECT COUNT(DISTINCT(PRO_ORDRE)) FROM GENPROVIDERS';
      vQry.Open;
      if not vQry.Eof then
        vDistinctOrdre := vQry.Fields[0].AsInteger;

      if vCptOrdre <> vDistinctOrdre then
      begin
        vObjList := GetListGenProviders(ADossier.DOSS_ID, 0, spDisponible);
        if vObjList <> nil then
        begin
          for i := 0 to vObjList.Count - 1 do
          begin
            vGnkGenProviders := TGnkGenProviders(vObjList.Items[i]);
            vGnkGenProviders.ADmGINKOIA := ADmGINKOIA;
            vGnkGenProviders.PRO_ORDRE := i + 1;
            vGnkGenProviders.MAJ;
          end;
        end;
      end;
    finally
      FreeAndNil(vQry);
      if vObjList <> nil then
        FreeAndNil(vObjList);
    end;
  end;

  procedure CheckORDREGenSubscribers(Const ADmGINKOIA: TdmGINKOIA);
  var
    i, vCptOrdre, vDistinctOrdre: integer;
    vQry: TFDQuery;
    vObjList: TObjectList;
    vGnkGenSubscribers: TGnkGenSubscribers;
  begin
    vObjList := nil;
    vCptOrdre := 0;
    vDistinctOrdre := 0;
    try
      vQry := ADmGINKOIA.GetNewQry;

      vQry.SQL.Text := 'SELECT COUNT(SUB_ORDRE) FROM GENSUBSCRIBERS';
      vQry.Open;
      if not vQry.Eof then
        vCptOrdre := vQry.Fields[0].AsInteger;

      vQry.SQL.Text := 'SELECT COUNT(DISTINCT(SUB_ORDRE)) FROM GENSUBSCRIBERS';
      vQry.Open;
      if not vQry.Eof then
        vDistinctOrdre := vQry.Fields[0].AsInteger;

      if (vCptOrdre <> 0) and (vDistinctOrdre <> 0) and (vCptOrdre <> vDistinctOrdre) then
      begin
        vObjList := GetListGenSubscribers(ADossier.DOSS_ID, 0, spDisponible);
        if vObjList <> nil then
        begin
          for i := 0 to vObjList.Count - 1 do
          begin
            vGnkGenSubscribers := TGnkGenSubscribers(vObjList.Items[i]);
            vGnkGenSubscribers.ADmGINKOIA := ADmGINKOIA;
            vGnkGenSubscribers.SUB_ORDRE := i + 1;
            vGnkGenSubscribers.MAJ;
          end;
        end;
      end;
    finally
      FreeAndNil(vQry);
      if vObjList <> nil then
        FreeAndNil(vObjList);
    end;
  end;

var
  i, j, vResultProcess: integer;

  vEmet: TEmetteur;

  vMag: TMagasin;
  vPoste: TPoste;
  vVer: TVersion;

  vdmGINKOIA: TdmGINKOIA;

  vQry, vQryS, vQryK, vQryGenParam, vQryGenParamS, vQryGenBases, vQryGenMagasin, vQryGenPoste, vQryPr_INITBASE: TFDQuery;

  Buffer: string;
  vFileNameData: string;
  vPathDistant: string;
  vPathDossierVierge: string;
  vPathDistantVDossierClient: string;
  vPathMonitorVierge: string;
  vPathMonitorClient: string;
  vPathMonitorXML: string;
  vFileNameCible: string;
  vFileNameSource: string;
  vPathEAI: string;
  vPathIIS: string;
  vNomPool: string;
  vPathDllPool: string;
  vExecAndWaitProcessMsg: string;
  vCmd: string;
  vTmp: string;
  sNom, vREPPING, vREPPUSH, vREPPULL, vREPURLLOCAL, vREPURLDISTANT, vREPPLACEEAI, vREPPLACEBASE: string;

  vREPID, vLAUID, vREPORDRE: integer;

  vSearch: TSearching;

  vSLTraceur: TStringList;
  vSLScriptIIS: TStringList;
  vSLLogErr: TStringList;
begin
  vQry := nil;
  vQryS := nil;
  vQryGenBases := nil;
  vQryGenMagasin := nil;
  vQryGenPoste := nil;
  vQryPr_INITBASE := nil;
  vdmGINKOIA := nil;
  vSearch := nil;

  vSLTraceur := TStringList.Create;
  try
    if (ADossier.AServeur <> nil) and (ADossier.AServeur.SERV_NOM <> 'LOCALHOST') then
    begin
      { Construction du path distant ( \\GSA-LAME3\EAI\Sport2000\MERCIER\DATA ) }
      vPathDistant := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, ADossier.DOSS_CHEMIN);
      { Construction du path distant dossier vierge ( \\GSA-LAME3\EAI\VDossier\DossierVierge ) }
      vPathDossierVierge := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, GWSConfig.Options.Values['PATHBASEVIERGE']);

      if DirectoryExists(vPathDossierVierge) then
      begin
        { Construction du path distant DOSS_DATABASE ( \\GSA-LAME3\EAI\VDossier\MERCIER ) }
        vPathDistantVDossierClient := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, UpDirectory(GWSConfig.Options.Values['PATHBASEVIERGE'], 1) +
          '\V_DOSSIERS\' + ADossier.DOSS_DATABASE);
        { Construction du path pour la DllPool }
        vPathDllPool := UpDirectory(GWSConfig.Options.Values['PATHBASEVIERGE'], 1) + '\V_DOSSIERS\' + ADossier.DOSS_DATABASE;
      end;

      { Construction du path distant EAI ( \\GSA-LAME3\EAI ) }
      vPathEAI := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, ADossier.AServeur.SERV_DOSEAI);

      { Construction du path de la base de données }
      vFileNameData := vPathDistant;
      if Pos(cDB_FileName_GINKOIA, vFileNameData) = 0 then
        vFileNameData := IncludeTrailingBackslash(vPathDistant) + cDB_FileName_GINKOIA;

      Buffer := ExtractFilePath(vFileNameData);
      if not DirectoryExists(Buffer) then
        ForceDirectories(Buffer);

      { Construction du path }
      vPathMonitorVierge := DOSS_CHEMINToUNC(ADossier.AServeur.SERV_NOM, GWSConfig.Options.Values['PATHMONITORVIERGE']);

      if DirectoryExists(vPathMonitorVierge) then
      begin
        { Construction du path }
        vPathMonitorClient := UpDirectory(ExtractFilePath(vFileNameData), 1) + '\Monitor';
        { Construction du path }
        vPathMonitorXML := vPathMonitorClient; // UpDirectory(ADossier.DOSS_CHEMIN, 1) + '\Monitor\';
        Delete(vPathMonitorXML, 1, Pos('\', vPathMonitorXML)); // SR : Suppression de : \
        Delete(vPathMonitorXML, 1, Pos('\', vPathMonitorXML)); // SR : Suppression de : \
        Delete(vPathMonitorXML, 1, Pos('\', vPathMonitorXML)); // SR : Suppression de : \
        vPathMonitorXML := ADossier.AServeur.SERV_NOM + ':' + ADossier.AServeur.SERV_DOSBDD + '\' + vPathMonitorXML;
      end;
    end
    else
    begin
      vPathDistant := ADossier.DOSS_CHEMIN; // 'D:\EAI\DUPONT\NEWTEST20\DATA\GINKOIA.IB'

      { Construction du path distant dossier vierge ( D:\EAI\VDossier\DossierVierge ) }
      vPathDossierVierge := GWSConfig.Options.Values['PATHBASEVIERGE'];

      if DirectoryExists(vPathDossierVierge) then
      begin
        { Construction du path distant DOSS_DATABASE ( D:\EAI\VDossier\MERCIER ) }
        vPathDistantVDossierClient := IncludeTrailingBackslash(UpDirectory(vPathDossierVierge, 1)) + ADossier.DOSS_DATABASE;
        // vPathMonitor := vPathDistantVDossierClient;
        vPathDllPool := vPathDistantVDossierClient;
      end;

      { Construction du path de la base de données }
      vFileNameData := vPathDistant;
      if Pos(cDB_FileName_GINKOIA, vFileNameData) = 0 then
        vFileNameData := IncludeTrailingBackslash(vPathDistant) + cDB_FileName_GINKOIA;

      Buffer := ExtractFilePath(vFileNameData);
      if not DirectoryExists(Buffer) then
        ForceDirectories(Buffer);

      { Construction du path distant EAI ( D:\EAI ) }
      vPathEAI := ADossier.AServeur.SERV_DOSEAI;
    end;

    vNomPool := ADossier.DOSS_DATABASE;

    vSLTraceur.Append(GetNowToStr + 'PathDistant                : ' + vPathDistant);
    vSLTraceur.Append(GetNowToStr + 'PathDossierVierge          : ' + vPathDossierVierge);
    vSLTraceur.Append(GetNowToStr + 'PathDistantVDossierClient  : ' + vPathDistantVDossierClient);
    vSLTraceur.Append(GetNowToStr + 'PathMonitorVierge          : ' + vPathMonitorVierge);
    vSLTraceur.Append(GetNowToStr + 'PathMonitorClient          : ' + vPathMonitorClient);
    vSLTraceur.Append(GetNowToStr + 'PathMonitorXML             : ' + vPathMonitorXML);
    vSLTraceur.Append(GetNowToStr + 'PathEAI                    : ' + vPathEAI);
    vSLTraceur.Append(GetNowToStr + 'PathDllPool                : ' + vPathDllPool);
    vSLTraceur.Append(GetNowToStr + 'FileNameData               : ' + vFileNameData);
    vSLTraceur.Append(GetNowToStr + 'DOSS_CHEMIN                : ' + ADossier.DOSS_CHEMIN);

    try
      { Copie de la base vierge dans la cible }

      CopyFile(PChar(ADirSource), PChar(vFileNameData), False);
      vSLTraceur.Append(GetNowToStr + 'Copie de : ' + ADirSource + ' vers ' + vFileNameData);

      if not FileExists(vFileNameData) then
        Raise Exception.Create('La nouvelle base est introuvable dans ' + ExtractFilePath(vFileNameData));

      { Mise à jour de la nouvelle base de données }
      vSLTraceur.Append(GetNowToStr + 'Mise à jour de la nouvelle base de données');

      if vdmGINKOIA <> nil then
        vdmGINKOIA := nil;

      vdmGINKOIA := GetNewdmGINKOIAByChemin(ADossier.DOSS_CHEMIN);

      vQry := vdmGINKOIA.GetNewQry;
      vQryS := vdmGINKOIA.GetNewQry;
      vQryK := vdmGINKOIA.GetNewQry;
      vQryGenParam := vdmGINKOIA.GetNewQry;
      vQryGenParamS := vdmGINKOIA.GetNewQry;
      vQryGenBases := vdmGINKOIA.GetNewQry;
      vQryGenMagasin := vdmGINKOIA.GetNewQry;
      vQryGenPoste := vdmGINKOIA.GetNewQry;
      vQryPr_INITBASE := vdmGINKOIA.GetNewQry;

      // Ajout par AJ le 15/09/2017, création du genparambase d'identification de base de PROD
      SetGenParamBaseTypeBase(vdmGINKOIA);

      vQry.SQL.Text := cSql_S_genversion;

      vQryGenBases.SQL.Text := cSql_U_CreateBase_GenBases;

      vQryGenMagasin.SQL.Text := cSql_S_CreateBase_GenMagasin;
      vQryGenMagasin.Open;

      vQryGenPoste.SQL.Text := cSql_S_genposte;
      vQryGenPoste.Open;

      vQryPr_INITBASE.SQL.Text := 'EXECUTE PROCEDURE PR_INITBASE(:PBASID, :PPANTIN, :PLAVERSION)';

      vQryS.SQL.Append('SELECT * FROM GENBASES GB');
      vQryS.SQL.Append('JOIN K ON (K_ID=GB.BAS_ID and K_ENABLED=1)');
      vQryS.SQL.Append('LEFT OUTER JOIN GENLAUNCH GL ON (GB.BAS_ID=GL.LAU_BASID)');
      vQryS.SQL.Append('WHERE GB.BAS_ID <> 0');
      vQryS.SQL.Append('ORDER BY GB.BAS_IDENT');
      vQryS.Open;

      if not vQryS.Eof then
      begin
        if not vdmGINKOIA.Transaction.Active then
          vdmGINKOIA.Transaction.StartTransaction;

        vQry.Open;
        if vQry.Eof then
          Raise Exception.Create('Version introuvable dans la nouvelle base.');

        vVer := VersionByVERS_VERSION[vQry.FieldByName('VER_VERSION').AsString];

        if vVer = nil then
        begin
          vVer := TVersion.Create(nil);
          // vVer.VERS_VERSION := vQry.FieldByName('VER_VERSION').AsString;
          // vVer.VERS_NOMVERSION :=
          // vVer.VERS_PATCH := 0;
          // vVer.VERS_EAI := ;
          vVer.MAJ(ukInsert);
          AddVersion(vVer);
          vSLTraceur.Append(GetNowToStr + 'Création de la version : Ok');
        end;

        vQry.Close;

        vSLTraceur.Append(GetNowToStr + 'Version : ' + vVer.VERS_VERSION);
        vSLTraceur.Append(GetNowToStr + 'Version EAI : ' + vVer.VERS_EAI);

        { Pour les versions > 11.3.0.1 on copie tout le repertoire du dossier
          vierge dans le nouveau repertoire du client }
        if (vPathDistantVDossierClient <> '') and (CompareVersion(vVer.VERS_VERSION, cVersionRef) = 1) then
        begin
          vSearch := TSearching.Create(GWSConfig.ServiceFileName);
          try
            try
              vSearch.Searching(vPathDossierVierge, '*.*', True);
              if vSearch.NbFilesFound = 0 then
              begin
                vSLTraceur.Append(GetNowToStr + 'Dossier vierge : "' + vPathDossierVierge + '" vide, pas de copie');
                Exit;
              end;
              for i := Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
              begin
                if vSearch.TabInfoSearch[i].PathAndName <> '' then
                begin
                  vFileNameSource := string(vSearch.TabInfoSearch[i].PathAndName);
                  vFileNameCible := StringReplace(vFileNameSource, vPathDossierVierge, vPathDistantVDossierClient, []);

                  Buffer := ExtractFilePath(vFileNameCible);
                  if not DirectoryExists(Buffer) then
                    ForceDirectories(Buffer);

                  vSLTraceur.Append(GetNowToStr + 'Copie de : ' + vFileNameSource + ' vers ' + vFileNameCible);
                  CopyFile(PChar(vFileNameSource), PChar(vFileNameCible), False);
                end;
              end;
            except
              on E: Exception do
              begin
                vSLTraceur.Append(GetNowToStr + 'Erreur à la copie de : ' + vFileNameSource + ' vers ' + vFileNameCible + ' avec le message : ' +
                  E.Message);
              end;
            end;
          finally
            FreeAndNil(vSearch);
          end;

          vSLTraceur.Append(GetNowToStr + 'Copie du repertoire "Dossier vierge" de ' + vPathDossierVierge + ' vers ' + vPathDistantVDossierClient);

          vSearch := TSearching.Create(GWSConfig.ServiceFileName);
          try
            try
              vSearch.Searching(string(vPathMonitorVierge), '*.*', True);
              if vSearch.NbFilesFound = 0 then
              begin
                vSLTraceur.Append(GetNowToStr + 'Dossier monitor : "' + vPathMonitorVierge + '" vide, pas de copie');
                Exit;
              end;
              for i := Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
              begin
                if vSearch.TabInfoSearch[i].PathAndName <> '' then
                begin
                  vFileNameSource := string(vSearch.TabInfoSearch[i].PathAndName);
                  vFileNameCible := StringReplace(vFileNameSource, vPathMonitorVierge, vPathMonitorClient, []);

                  Buffer := ExtractFilePath(vFileNameCible);
                  if not DirectoryExists(Buffer) then
                    ForceDirectories(Buffer);

                  vSLTraceur.Append(GetNowToStr + 'Copie de : ' + vFileNameSource + ' vers ' + vFileNameCible);
                  CopyFile(PChar(vFileNameSource), PChar(vFileNameCible), False);
                end;
              end;
            except
              on E: Exception do
              begin
                vSLTraceur.Append(GetNowToStr + 'Erreur à la copie de : ' + vFileNameSource + ' vers ' + vFileNameCible + ' avec le message : ' +
                  E.Message);
              end;
            end;
          finally
            FreeAndNil(vSearch);
          end;
          vSLTraceur.Append(GetNowToStr + 'Copie du repertoire "Monitor vierge" de ' + vPathMonitorVierge + ' vers ' + vPathMonitorClient);

          { Mise à jour du fichier DelosQPMAgent.Databases.xml du repertoire VDossier\DOSS_DATABASE }
          if MAJXmlDatabases(vPathDistantVDossierClient, ADossier) then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : ' + vPathDistantVDossierClient)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : Erreur');

          { Mise à jour du fichier DelosQPMAgent.DataSources.xml du repertoire VDossier\DOSS_DATABASE }
          if MAJXmlDataSources(vPathDistantVDossierClient, vPathMonitorXML, ADossier, '') then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDataSources : "' + vPathDistantVDossierClient + '". Et : "' + vPathMonitorXML + '"')
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlDataSources : Erreur');

          { Mise à jour du fichier DelosQPMAgent.InitParam.xml du repertoire VDossier\DOSS_DATABASE }
          if MAJXmlInitParamXMLCInstanceName(vPathDistantVDossierClient, ADossier) then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlInitParamXMLCInstanceName : ' + vPathDistantVDossierClient)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlInitParamXMLCInstanceName : Erreur');

          { Mise à jour du fichier DelosQPMAgent.XMLModules.xml du repertoire VDossier\DOSS_DATABASE }
          if MAJXmlModules(vPathDistantVDossierClient, vVer.VERS_EAI) then
            vSLTraceur.Append(GetNowToStr + 'MAJXmlModules : ' + vPathDistantVDossierClient)
          else
            vSLTraceur.Append(GetNowToStr + 'MAJXmlModules : Erreur');

          // Création du Site et Pool IIS
          if dmMaintenance.GetMaintenanceParamInteger(2, 4) = 1 then
          begin
            vSLTraceur.Append(GetNowToStr + 'Création du Site et Pool IIS.');
            vSLScriptIIS := TStringList.Create;
            try
              vPathIIS := '%windir%\system32\inetsrv\';

              j := 1;
              while dmMaintenance.GetMaintenanceParamString(j, 5) <> '' do
              begin
                vCmd := dmMaintenance.GetMaintenanceParamString(j, 5);
                vCmd := StringReplace(vCmd, '%vNomPool%', vNomPool, [rfReplaceAll, rfIgnoreCase]);
                vCmd := StringReplace(vCmd, '%vPathDllPool%', vPathDllPool, [rfReplaceAll, rfIgnoreCase]);
                vCmd := StringReplace(vCmd, '%vIp%', ADossier.SERV_LOCALIP, [rfReplaceAll, rfIgnoreCase]);
                vSLScriptIIS.Add(vPathIIS + vCmd);
                inc(j);
              end;

              // Ajout fichier hosts distant
              j := 1;
              while dmMaintenance.GetMaintenanceParamString(j, 6) <> '' do
              begin
                vCmd := dmMaintenance.GetMaintenanceParamString(j, 6);
                vCmd := StringReplace(vCmd, '%vNomPool%', vNomPool, [rfReplaceAll, rfIgnoreCase]);
                vCmd := StringReplace(vCmd, '%vIp%', ADossier.SERV_LOCALIP, [rfReplaceAll, rfIgnoreCase]);
                vCmd := StringReplace(vCmd, '%vTab%', #9, [rfReplaceAll, rfIgnoreCase]);
                vSLScriptIIS.Add(vCmd);
                inc(j);
              end;

              vSLScriptIIS.SaveToFile(vPathDistantVDossierClient + '\ScriptIIS.bat');

              vSLTraceur.Append(GetNowToStr + 'Création du Site et Pool IIS : ' + '"' + GWSConfig.ServicePath + 'PsExec.exe"');
              vSLTraceur.Append(GetNowToStr + 'Création du Site et Pool IIS : ' + ' -i ' + ADossier.SERV_NOM + ' -u ' + ADossier.SERV_USER + ' -p ' +
                ADossier.SERV_PASSWORD + ' "' + vPathDllPool + '\ScriptIIS.bat"');

              ExecAndWaitProcess('"' + GWSConfig.ServicePath + 'PsExec.exe"', ' -i \\' + ADossier.SERV_NOM + ' -u ' + ADossier.SERV_USER + ' -p ' +
                ADossier.SERV_PASSWORD + ' "' + vPathDllPool + '\ScriptIIS.bat"', '', vExecAndWaitProcessMsg);

              // Ajout fichier hosts local
              j := 1;
              while dmMaintenance.GetMaintenanceParamString(j, 6) <> '' do
              begin
                vCmd := dmMaintenance.GetMaintenanceParamString(j, 6);
                vCmd := StringReplace(vCmd, '%vNomPool%', LowerCase(vNomPool), [rfReplaceAll, rfIgnoreCase]);
                vCmd := StringReplace(vCmd, '%vIp%', ADossier.SERV_LOCALIP, [rfReplaceAll, rfIgnoreCase]);
                vCmd := StringReplace(vCmd, '%vTab%', #9, [rfReplaceAll, rfIgnoreCase]);
                ShellExecute(0, nil, 'cmd.exe', PWideChar('/C ' + vCmd), nil, SW_HIDE);
                inc(j);
              end;

              if dmMaintenance.GetMaintenanceParamInteger(1, 4) = 1 then
                DeleteFile(PWideChar(vPathDistantVDossierClient + '\ScriptIIS.bat'));
            finally
              vSLScriptIIS.Free;
            end;
          end;
        end;

        { Mise à jour du fichier DelosQPMAgent.Databases.xml du repertoire Vx_x_x }
        // Buffer:= IncludeTrailingBackslash(vPathEAI) + StringReplace(vVer.VERS_EAI, 'Bin', '', [rfIgnoreCase]);
        // if MAJXmlDatabases(Buffer, ADossier) then
        // vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : ' + Buffer)
        // else
        // vSLTraceur.Append(GetNowToStr + 'MAJXmlDatabases : Erreur dans : ' + Buffer);

        // SR - 02-09-2014 - Nettoyage des genparam
        vQryGenParamS.SQL.Text :=
          'SELECT PRM_ID FROM GENPARAM WHERE PRM_TYPE = 11 AND NOT PRM_POS IN (SELECT BAS_ID FROM GENBASES WHERE BAS_ID <> 0)';
        vQryGenParamS.Open;
        vQryGenParamS.FetchAll;
        vQryGenParamS.First;

        vQryGenParam.SQL.Text := 'DELETE FROM GENPARAM WHERE PRM_ID = :PPRMID';
        vQryK.SQL.Text := 'DELETE FROM K WHERE K_ID = :PKID';

        while not vQryGenParamS.Eof do
        begin
          vQryGenParam.ParamByName('PPRMID').AsInteger := vQryGenParamS.FieldByName('PRM_ID').AsInteger;
          vQryGenParam.ExecSQL;
          vQryK.ParamByName('PKID').AsInteger := vQryGenParamS.FieldByName('PRM_ID').AsInteger;
          vQryK.ExecSQL;
          vQryGenParamS.Next;
        end;
        // Fin SR - 02-09-2014

        // SR - 19-08-2015 - Mise à jour de l'url d'accès au webservice
        if vdmGINKOIA.GetParamString(3, 121, 0) <> '' then
        begin
          // On met à jour
          i := vdmGINKOIA.GetParamID(3, 121, 0);
          vdmGINKOIA.SetParamString(i, dmMaintenance.GetMaintenanceParamString(1, 7));
        end
        else
        begin
          // On ajout le genparam
          vdmGINKOIA.CreateParam(3, 121, 0, 0, 0, 0, dmMaintenance.GetMaintenanceParamString(1, 7), 'Url accès WebService GinkoiaTools');
        end;
        // SR - 19-08-2015

        while not vQryS.Eof do
        begin
          vEmet := TEmetteur.Create(nil);
          try
            vEmet.SetValuesByDataSet(vQryS);
            vEmet.MatchGenBasesToEmetteur;

            vEmet.AVersion := vVer;
            vEmet.ADossier := ADossier;
            vEmet.IsExcludeGnkMAJ := True;
            vEmet.MAJ(ukInsert);
            vSLTraceur.Append(GetNowToStr + 'Création emetteur : ' + vEmet.EMET_NOM);

            vdmGINKOIA.UpdateK(vEmet.BAS_ID, 0);
            vQryGenBases.ParamByName('PBAS_ID').AsInteger := vEmet.BAS_ID;
            vQryGenBases.ParamByName('PBAS_GUID').AsString := vEmet.EMET_GUID;
            vQryGenBases.ParamByName('PBAS_SENDER').AsString := vEmet.EMET_NOM;
            vQryGenBases.ParamByName('PBAS_NOM').AsString := vEmet.EMET_NOM;
            vQryGenBases.ParamByName('PBAS_NOMPOURNOUS').AsString := vEmet.ADossier.DOSS_DATABASE;
            vQryGenBases.ExecSQL;
            vSLTraceur.Append(GetNowToStr + 'Synchronisation du GUID emetteur dans GENBASE.BAS_ID : ' + IntToStr(vEmet.BAS_ID));

            vQryPr_INITBASE.ParamByName('PBASID').AsInteger := vEmet.BAS_ID;
            vQryPr_INITBASE.ParamByName('PPANTIN').AsString := vEmet.ADossier.DOSS_DATABASE;
            vQryPr_INITBASE.ParamByName('PLAVERSION').AsString := vEmet.ADossier.DOSS_DATABASE + 'Bin';
            vQryPr_INITBASE.ExecSQL;
            vSLTraceur.Append(GetNowToStr + 'Exécution de la procédure PR_INITBASE.');

            // SR - 29-09-2015 - Vérification Genreplication
            vQry.SQL.Text := 'SELECT REP_ID, REP_PING, REP_PUSH, REP_PULL, REP_ORDRE, REP_URLLOCAL, REP_URLDISTANT, REP_PLACEEAI, REP_PLACEBASE	' +
              'FROM GENREPLICATION ' + 'JOIN K ON K_ID = REP_ID AND K_ENABLED = 1 ' + 'JOIN GENLAUNCH ON LAU_ID = REP_LAUID ' +
              'JOIN GENBASES ON BAS_ID = LAU_BASID ' + 'WHERE BAS_ID = :PBASID ' + 'AND REP_ORDRE = 1' + 'ORDER BY REP_ID';
            vQry.ParamByName('PBASID').AsInteger := vEmet.BAS_ID;
            vQry.Open;
            vQry.FetchAll;
            vQry.First;

            if not vQry.Eof then
            begin
              vREPID := vQry.FieldByName('REP_ID').AsInteger;
              vREPPING := vQry.FieldByName('REP_PING').AsString;
              vREPPUSH := vQry.FieldByName('REP_PUSH').AsString;
              vREPPULL := vQry.FieldByName('REP_PULL').AsString;
              vREPORDRE := vQry.FieldByName('REP_ORDRE').AsInteger;
              vREPURLLOCAL := vQry.FieldByName('REP_URLLOCAL').AsString;
              vREPURLDISTANT := vQry.FieldByName('REP_URLDISTANT').AsString;
              vREPPLACEEAI := vQry.FieldByName('REP_PLACEEAI').AsString;
              vREPPLACEBASE := vQry.FieldByName('REP_PLACEBASE').AsString;

              vQry.Close;
              vQry.SQL.Text := 'SELECT dos_string FROM GENDOSSIER join k ON k_id=dos_id and k_enabled=1 WHERE dos_nom=''LECTEUR GINKOIA''';
              vQry.Open;
              vQry.FetchAll;
              vQry.First;

              if (vREPPLACEEAI = '') then
                vREPPLACEEAI := vQry.FieldByName('dos_string').AsString + 'Ginkoia\EAI\';
              if (vREPPLACEBASE = '') then
                vREPPLACEBASE := vQry.FieldByName('dos_string').AsString + 'Ginkoia\data\ginkoia.IB';

              vQry.Close;

              if (vREPPING = '') then
                vREPPING := 'Ping';
              if (vREPPUSH = '') then
                vREPPUSH := 'Push';
              if (vREPPULL = '') then
                vREPPULL := 'PullSubscription';
              if (vREPORDRE = 0) then
                vREPORDRE := 1;
              if (vREPURLLOCAL = '') then
                vREPURLLOCAL := 'http://localhost:668/DelosEAIBin/DelosQPMAgent.dll/';
              // SR - 10-08-2016 - Suite accord admin on met à jour
              // if (vREPURLDISTANT = '') or (AnsiPos(UpperCase('pantin'), UpperCase(vREPURLDISTANT)) <> 0) then
              // begin
              if (vREPORDRE > 0) then // En cas de réplication Web
              begin
                if dmMaintenance.GetMaintenanceParamInteger(1, 8) = 1 then
                  vREPURLDISTANT := 'http://' + vEmet.ADossier.DOSS_DATABASE + '.' + dmMaintenance.GetMaintenanceParamString(1, 8) + '/' +
                    vEmet.ADossier.DOSS_DATABASE + 'Bin/DelosQPMAgent.dll/'
                else
                  vREPURLDISTANT := 'http://' + vEmet.ADossier.SERV_IP + '/' + vEmet.ADossier.DOSS_DATABASE + 'Bin/DelosQPMAgent.dll/';
              end;
              // end;

              vdmGINKOIA.UpdateK(vREPID, 0);
              vQry.SQL.Text := 'UPDATE GENREPLICATION SET ' + 'REP_PING = :PREPPING, ' + 'REP_PUSH = :PREPPUSH, ' + 'REP_PULL = :PREPPULL, ' +
                'REP_ORDRE = :PREPORDRE, ' + 'REP_URLLOCAL = :PREPURLLOCAL, ' + 'REP_URLDISTANT = :PREPURLDISTANT, ' +
                'REP_PLACEEAI = :PREPPLACEEAI, ' + 'REP_PLACEBASE = :PREPPLACEBASE ' + 'WHERE REP_ID = :PREPID';
              vQry.ParamByName('PREPPING').AsString := vREPPING;
              vQry.ParamByName('PREPPUSH').AsString := vREPPUSH;
              vQry.ParamByName('PREPPULL').AsString := vREPPULL;
              vQry.ParamByName('PREPORDRE').AsInteger := vREPORDRE;
              vQry.ParamByName('PREPURLLOCAL').AsString := vREPURLLOCAL;
              vQry.ParamByName('PREPURLDISTANT').AsString := vREPURLDISTANT;
              vQry.ParamByName('PREPPLACEEAI').AsString := vREPPLACEEAI;
              vQry.ParamByName('PREPPLACEBASE').AsString := vREPPLACEBASE;
              vQry.ParamByName('PREPID').AsInteger := vREPID;
              vQry.ExecSQL;
            end
            else
            begin
              vQry.SQL.Text := 'SELECT LAU_ID	' + 'FROM GENLAUNCH ' + 'JOIN K ON K_ID = LAU_ID AND K_ENABLED = 1 ' +
                'JOIN GENBASES ON BAS_ID = LAU_BASID ' + 'WHERE BAS_ID = :PBASID';
              vQry.ParamByName('PBASID').AsInteger := vEmet.BAS_ID;
              vQry.Open;
              vQry.FetchAll;
              vQry.First;

              if not vQry.Eof then
              begin
                vLAUID := vQry.FieldByName('LAU_ID').AsInteger;

                vQry.Close;
                vQry.SQL.Text := 'SELECT dos_string FROM GENDOSSIER join k ON k_id=dos_id and k_enabled=1 WHERE dos_nom=''LECTEUR GINKOIA''';
                vQry.Open;
                vQry.FetchAll;
                vQry.First;

                vREPPLACEEAI := vQry.FieldByName('dos_string').AsString + 'Ginkoia\EAI\';
                vREPPLACEBASE := vQry.FieldByName('dos_string').AsString + 'Ginkoia\data\ginkoia.IB';

                vQry.Close;

                vREPID := vdmGINKOIA.GetNewID('GENREPLICATION');
                vREPPING := 'Ping';
                vREPPUSH := 'Push';
                vREPPULL := 'PullSubscription';
                vREPORDRE := 1;
                vREPURLLOCAL := 'http://localhost:668/DelosEAIBin/DelosQPMAgent.dll/';

                if (vREPORDRE > 0) then // En cas de réplication Web
                begin
                  if dmMaintenance.GetMaintenanceParamInteger(1, 8) = 1 then
                    vREPURLDISTANT := 'http://' + vEmet.ADossier.DOSS_DATABASE + '.' + dmMaintenance.GetMaintenanceParamString(1, 8) + '/' +
                      vEmet.ADossier.DOSS_DATABASE + 'Bin/DelosQPMAgent.dll/'
                  else
                    vREPURLDISTANT := 'http://' + vEmet.ADossier.SERV_IP + '/' + vEmet.ADossier.DOSS_DATABASE + 'Bin/DelosQPMAgent.dll/';
                end;

                vQry.SQL.Text :=
                  'INSERT INTO GENREPLICATION (REP_ID, REP_LAUID, REP_PING, REP_PUSH, REP_PULL, REP_ORDRE, REP_URLLOCAL, REP_URLDISTANT, REP_PLACEEAI, REP_PLACEBASE) '
                  + 'VALUES (:PREPID, :PLAUID, :PREPPING, :PREPPUSH, :PREPPULL, :PREPORDRE, :PREPURLLOCAL, :PREPURLDISTANT, :PREPPLACEEAI, :PREPPLACEBASE)';
                vQry.ParamByName('PREPID').AsInteger := vREPID;
                vQry.ParamByName('PLAUID').AsInteger := vLAUID;
                vQry.ParamByName('PREPPING').AsString := vREPPING;
                vQry.ParamByName('PREPPUSH').AsString := vREPPUSH;
                vQry.ParamByName('PREPPULL').AsString := vREPPULL;
                vQry.ParamByName('PREPORDRE').AsInteger := vREPORDRE;
                vQry.ParamByName('PREPURLLOCAL').AsString := vREPURLLOCAL;
                vQry.ParamByName('PREPURLDISTANT').AsString := vREPURLDISTANT;
                vQry.ParamByName('PREPPLACEEAI').AsString := vREPPLACEEAI;
                vQry.ParamByName('PREPPLACEBASE').AsString := vREPPLACEBASE;
                vQry.ExecSQL;
              end;
            end;
            // ---------------------------------------------

            // SR - 02-09-2014 - Nettoyage des genparam
            vQryGenParamS.SQL.Text := 'SELECT PRM_ID FROM GENPARAM WHERE PRM_TYPE = 11 AND PRM_CODE = :PPRMCODE AND PRM_POS = :PPRMPOS';
            vQryGenParam.SQL.Text := 'UPDATE GENPARAM SET PRM_STRING = :PPRMSTRING WHERE PRM_ID = :PPRMID';

            vQryGenParamS.ParamByName('PPRMPOS').AsInteger := vEmet.BAS_ID;
            vQryGenParamS.ParamByName('PPRMCODE').AsInteger := 34;
            vQryGenParamS.Open;
            if not vQryGenParamS.Eof then
            begin
              vdmGINKOIA.UpdateK(vQryGenParamS.FieldByName('PRM_ID').AsInteger, 0);
              vQryGenParam.ParamByName('PPRMID').AsInteger := vQryGenParamS.FieldByName('PRM_ID').AsInteger;
              vQryGenParam.ParamByName('PPRMSTRING').AsString := '/JetonLaunch.dll/soap/IJetonLaunch';
              vQryGenParam.ExecSQL;
            end;
            vQryGenParamS.Close;

            vQryGenParamS.ParamByName('PPRMPOS').AsInteger := vEmet.BAS_ID;
            vQryGenParamS.ParamByName('PPRMCODE').AsInteger := 35;
            vQryGenParamS.Open;
            if not vQryGenParamS.Eof then
            begin
              vdmGINKOIA.UpdateK(vQryGenParamS.FieldByName('PRM_ID').AsInteger, 0);
              vQryGenParam.ParamByName('PPRMID').AsInteger := vQryGenParamS.FieldByName('PRM_ID').AsInteger;
              vQryGenParam.ParamByName('PPRMSTRING').AsString := vEmet.EMET_NOM;
              vQryGenParam.ExecSQL;
            end;
            vQryGenParamS.Close;

            vQryGenParamS.ParamByName('PPRMPOS').AsInteger := vEmet.BAS_ID;
            vQryGenParamS.ParamByName('PPRMCODE').AsInteger := 36;
            vQryGenParamS.Open;
            if not vQryGenParamS.Eof then
            begin
              vdmGINKOIA.UpdateK(vQryGenParamS.FieldByName('PRM_ID').AsInteger, 0);
              vQryGenParam.ParamByName('PPRMID').AsInteger := vQryGenParamS.FieldByName('PRM_ID').AsInteger;
              vQryGenParam.ParamByName('PPRMSTRING').AsString := vEmet.ADossier.DOSS_DATABASE;
              vQryGenParam.ExecSQL;
            end;
            vQryGenParamS.Close;
            // Fin SR - 02-09-2014

            vQryS.Next;
          finally
            FreeAndNil(vEmet);
          end;
        end;

        while not vQryGenMagasin.Eof do
        begin
          vMag := TMagasin.Create(nil);
          vMag.ADossier := ADossier;
          vMag.MAGA_DOSSID := ADossier.DOSS_ID;
          vMag.MAGA_MAGID_GINKOIA := vQryGenMagasin.FieldByName('MAG_ID').AsInteger;
          vMag.MAGA_ENSEIGNE := vQryGenMagasin.FieldByName('MAG_ENSEIGNE').AsString;
          vMag.MAGA_NOM := vQryGenMagasin.FieldByName('MAG_NOM').AsString;
          vMag.MAGA_CODEADH := vQryGenMagasin.FieldByName('MAG_CODEADH').AsString;
          vMag.MAGA_K_ENABLED := vQryGenMagasin.FieldByName('K_ENABLED').AsInteger;
          vMag.IsExcludeGnkMAJ := True;
          vMag.MAJ(ukInsert);
          vSLTraceur.Append(GetNowToStr + 'Ajout du Magasin : ' + IntToStr(vMag.MAGA_MAGID_GINKOIA));

          FListMag.Add(vMag);

          vQryGenMagasin.Next;
        end;

        while not vQryGenPoste.Eof do
        begin
          vPoste := TPoste.Create(nil);
          vPoste.AMagasin := GMaintenanceCtrl.GetMagasinByMAGA_MAGID_GINKOIA(vQryGenPoste.FieldByName('POS_MAGID').AsInteger, ADossier.DOSS_ID);

          sNom := vQryGenPoste.FieldByName('POS_NOM').AsString;

          vPoste.POST_POSID := vQryGenPoste.FieldByName('POS_ID').AsInteger;
          vPoste.POST_MAGAID := vPoste.AMagasin.MAGA_ID;
          vPoste.POST_NOM := sNom;
          vPoste.POST_INFO := vQryGenPoste.FieldByName('POS_INFO').AsString;
          vPoste.POST_COMPTA := vQryGenPoste.FieldByName('POS_COMPTA').AsString;

          if (UpperCase(sNom[1]) = 'B') OR (UpperCase(sNom[1]) = 'G') then
            vPoste.POST_PTYPID := 1 // Gestion
          else if (UpperCase(sNom[1]) = 'S') then
          begin
            if UpperCase(sNom[sNom.Length]) = 'C' then
              vPoste.POST_PTYPID := 3 // Serveur Secours
            else
              vPoste.POST_PTYPID := 2; // Serveur
          end
          else if (UpperCase(sNom[1]) = 'C') then
          begin
            if UpperCase(sNom[sNom.Length]) = 'C' then
              vPoste.POST_PTYPID := 5 // Caisse Secours
            else
              vPoste.POST_PTYPID := 4; // Caisse
          end
          else if (UpperCase(sNom[1]) = 'P') then
          begin
            if UpperCase(sNom[2]) = 'L' then
              vPoste.POST_PTYPID := 9 // Sans Abo
            else if UpperCase(sNom[sNom.Length]) = 'C' then
              vPoste.POST_PTYPID := 7 // Portable Synchro
            else
              vPoste.POST_PTYPID := 6; // Portable
          end
          else if (UpperCase(sNom[1]) = 'R') then
            vPoste.POST_PTYPID := 8 // RDP
          else
            vPoste.POST_PTYPID := 9; // Par défaut Sans Abo

          vPoste.POST_DATEC := vQryGenPoste.FieldByName('K_INSERTED').AsDateTime;
          vPoste.POST_DATEM := vQryGenPoste.FieldByName('K_UPDATED').AsDateTime;
          vPoste.POST_ENABLE := vQryGenPoste.FieldByName('K_ENABLED').AsInteger;
          vPoste.IsExcludeGnkMAJ := True;
          vPoste.MAJ(ukInsert);
          vSLTraceur.Append(GetNowToStr + 'Ajout des Postes : ' + IntToStr(vPoste.POST_POSID));

          vQryGenPoste.Next;
        end;

        if not vdmGINKOIA.Transaction.Active then
          vdmGINKOIA.Transaction.StartTransaction;

        vdmGINKOIA.Transaction.Commit;

        CheckORDREGenProviders(vdmGINKOIA);
        vSLTraceur.Append(GetNowToStr + 'CheckORDREGenProviders');
        CheckORDREGenSubscribers(vdmGINKOIA);
        vSLTraceur.Append(GetNowToStr + 'CheckORDREGenSubscribers');

        if not vdmGINKOIA.Transaction.Active then
          vdmGINKOIA.Transaction.StartTransaction;

        vdmGINKOIA.Transaction.Commit;

        InitializeLists;
      end;

    except
      on E: Exception do
      begin
        if vdmGINKOIA.Transaction.Active then
          vdmGINKOIA.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.CreateBase : ' + E.Message);
      end;
    end;
  finally
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
    if vQryS <> nil then
      FreeAndNil(vQryS);
    if vQryK <> nil then
      FreeAndNil(vQryK);
    if vQryGenParam <> nil then
      FreeAndNil(vQryGenParam);
    if vQryGenParamS <> nil then
      FreeAndNil(vQryGenParamS);
    if vQryGenBases <> nil then
      FreeAndNil(vQryGenBases);
    if vQryGenMagasin <> nil then
      FreeAndNil(vQryGenMagasin);
    if vQryGenPoste <> nil then
      FreeAndNil(vQryGenPoste);
    if vQryPr_INITBASE <> nil then
      FreeAndNil(vQryPr_INITBASE);
    if vQry <> nil then
      FreeAndNil(vQry);
    if vSearch <> nil then
      FreeAndNil(vSearch);

    GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'CreateBase' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
    FreeAndNil(vSLTraceur);
  end;
end;

procedure TMaintenanceCtrl.CreateMdlGinkoiaToMaintenance(const AMAG_ID: integer);
var
  vDos: TDossier;
  vMag: TMagasin;
  vMdl: TModule;
  vdmGINKOIA: TdmGINKOIA;
  vQry, vQryMOD_MAG, vQryGinkoia: TFDQuery;
begin
  try
    try
      vMag := MagasinByID[AMAG_ID];
      if vMag = nil then
        Raise Exception.Create('Erreur de création du magasin');

      vDos := DossierByID[vMag.ADossier.DOSS_ID];
      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      if vDos.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);
      vQryGinkoia := vdmGINKOIA.GetNewQry;
      vQry := dmMaintenance.GetNewQry;
      vQryMOD_MAG := dmMaintenance.GetNewQry;

      vQryMOD_MAG.SQL.Append('SELECT * FROM MODULES_MAGASINS WHERE');
      vQryMOD_MAG.SQL.Append('MMAG_MODUID =:PMMAGMODUID AND MMAG_MAGAID =:PMMAGMAGAID');

      vQryGinkoia.SQL.Append('select * from');
      vQryGinkoia.SQL.Append('UILGRPGINKOIAMAG UGM join K on (K.K_ID = UGM.UGM_ID)');
      vQryGinkoia.SQL.Append('left outer join UILGRPGINKOIA UGG on (UGG.UGG_ID = UGM.UGM_UGGID)');
      vQryGinkoia.SQL.Append('where UGM.UGM_MAGID =' + IntToStr(vMag.MAGA_MAGID_GINKOIA));
      vQryGinkoia.SQL.Append('and K.K_Enabled = 1');
      vQryGinkoia.Open;

      while not vQryGinkoia.Eof do
      begin
        vMdl := ModuleByNOM[vQryGinkoia.FieldByName('UGG_NOM').AsString];
        if vMdl <> nil then
        begin
          vQryMOD_MAG.Close;
          vQryMOD_MAG.ParamByName('PMMAGMODUID').AsInteger := vMdl.MODU_ID;
          vQryMOD_MAG.ParamByName('PMMAGMAGAID').AsInteger := vMag.MAGA_ID;
          vQryMOD_MAG.Open;

          vQry.SQL.Clear;
          if vQryMOD_MAG.Eof then
          begin
            vQry.SQL.Text := cSql_I_Modules_Magasins;
          end
          else
          begin
            vQry.SQL.Text := cSql_U_Modules_Magasins;
          end;

          vQry.ParamByName('PMMAGMODUID').AsInteger := vMdl.MODU_ID;
          vQry.ParamByName('PMMAGMAGAID').AsInteger := vMag.MAGA_ID;
          vQry.ParamByName('PMMAGEXPDATE').AsDateTime := vQryGinkoia.FieldByName('UGM_DATE').AsDateTime;
          vQry.ParamByName('PMMAGKENABLED').AsInteger := 1;
          vQry.ParamByName('PMMAGUGMID').AsInteger := vQryGinkoia.FieldByName('UGM_ID').AsInteger;

          vQry.ExecSQL;
        end;
        vQryGinkoia.Next;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.CreateMdlGinkoiaToMaintenance : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vQryMOD_MAG);
    FreeAndNil(vQryGinkoia);
    FreeAndNil(vdmGINKOIA);
  end;
end;

{ ===============================================================================
  Procedure    : DeleteDossier
  Description  : permet la suppression d'un dossier et touts sa ramification
  uniquement dans la base "Maintenance", en aucun cas la base
  "Ginkoia" sera touchée.
  =============================================================================== }
procedure TMaintenanceCtrl.DeleteDossier(const ADossier: TDossier);
begin
  if DossierByID[ADossier.DOSS_ID] <> nil then
  begin
    ADossier.MAJ(ukDelete);
    FListDos.Remove(ADossier);
    InitializeLists;
  end;
end;

procedure TMaintenanceCtrl.DelSplittage(const ANOSPLIT: integer);
var
  vGnkSplittageLog: TGnkSplittageLog;
  vAllow: Boolean;
begin
  try
    try
      vGnkSplittageLog := GetSplittageLog(ANOSPLIT);
      if vGnkSplittageLog <> nil then
      begin
        vAllow := not((vGnkSplittageLog.SPLI_STARTED = 1) and (vGnkSplittageLog.SPLI_TERMINATE = 0) and (vGnkSplittageLog.SPLI_ERROR = 0));

        if (vAllow) or (not IsSplittageProcessActivate) then
          vGnkSplittageLog.MAJ(ukDelete);
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.DelSplittage : ' + E.Message);
    end;
  finally
    FreeAndNil(vGnkSplittageLog);
  end;
end;

destructor TMaintenanceCtrl.Destroy;
begin
  FreeLists;
  inherited Destroy;
end;

procedure TMaintenanceCtrl.FreeLists;
begin
  if FTThrdCtrlSplittage.Finished then
    FreeAndNil(FTThrdCtrlSplittage)
  else
  begin
    FTThrdCtrlSplittage.Terminate;
    FreeAndNil(FTThrdCtrlSplittage);
  end;

  FreeAndNil(FListDos);
  FreeAndNil(FListMag);
  FreeAndNil(FListPoste);
  FreeAndNil(FListMod);
  FreeAndNil(FListEmet);
  FreeAndNil(FListSrv);
  FreeAndNil(FListGrp);
  FreeAndNil(FListVer);
end;

function TMaintenanceCtrl.GetCountDossier: integer;
begin
  Result := FListDos.Count;
end;

function TMaintenanceCtrl.GetCountEmet: integer;
begin
  Result := FListEmet.Count;
end;

function TMaintenanceCtrl.GetCountGrp: integer;
begin
  Result := FListGrp.Count;
end;

function TMaintenanceCtrl.GetCountMag: integer;
begin
  Result := FListMag.Count;
end;

function TMaintenanceCtrl.GetCountModule: integer;
begin
  Result := FListMod.Count;
end;

function TMaintenanceCtrl.GetCountPoste: integer;
begin
  Result := FListPoste.Count;
end;

function TMaintenanceCtrl.GetCountRaison: integer;
begin
  Result := FListRaison.Count;
end;

function TMaintenanceCtrl.GetCountSrv: integer;
begin
  Result := FListSrv.Count;
end;

function TMaintenanceCtrl.GetCountVer: integer;
begin
  Result := FListVer.Count;
end;

function TMaintenanceCtrl.GetDossier(index: integer): TDossier;
begin
  Result := TDossier(FListDos.Items[index]);
end;

function TMaintenanceCtrl.GetDossierByID(ADOSS_ID: integer): TDossier;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListDos.Count - 1 do
  begin
    if Dossier[i].DOSS_ID = ADOSS_ID then
    begin
      Result := Dossier[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetEmetteur(index: integer): TEmetteur;
begin
  Result := TEmetteur(FListEmet.Items[index]);
end;

function TMaintenanceCtrl.GetEmetteurByALGOL(ADOSS_ID: integer): TEmetteur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListEmet.Count - 1 do
  begin
    if (Emetteur[i].EMET_DOSSID = ADOSS_ID) and (Emetteur[i].EMET_IDENT = '0') then
    begin
      Result := Emetteur[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetEmetteurByGUID(AEMET_GUID: string): TEmetteur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListEmet.Count - 1 do
  begin
    if Emetteur[i].EMET_GUID = AEMET_GUID then
    begin
      Result := Emetteur[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetEmetteurByID(AEMET_ID: integer): TEmetteur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListEmet.Count - 1 do
  begin
    if Emetteur[i].EMET_ID = AEMET_ID then
    begin
      Result := Emetteur[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetGenLiaiRepli(const ADOSS_ID, AGLR_ID: integer): TGnkGenLiaiRepli;
var
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      vQry.SQL.Append('Select * From GENLIAIREPLI');
      vQry.SQL.Append('Join K on (K_ID = GLR_ID and K_ENABLED = 1)');
      vQry.SQL.Append('Where GLR_ID = :PGLR_ID');

      vQry.ParamByName('PGLR_ID').AsInteger := AGLR_ID;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TGnkGenLiaiRepli.Create(nil);
        Result.DOSS_ID := ADOSS_ID;
        Result.ADmGINKOIA := vdmGINKOIA;
        Result.SetValuesByDataSet(vQry);
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetGenLiaiRepli : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetGenProviders(const ADOSS_ID, APRO_ID: integer): TGnkGenProviders;
var
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      vQry.SQL.Append('Select');
      vQry.SQL.Append('	PRO_ID,');
      vQry.SQL.Append('	PRO_NOM,');
      vQry.SQL.Append('	PRO_ORDRE,');
      vQry.SQL.Append('	PRO_LOOP');
      vQry.SQL.Append('From GENPROVIDERS');
      vQry.SQL.Append('Join K on (K_ID = PRO_ID and K_ENABLED = 1)');
      vQry.SQL.Append('Where PRO_ID = :PPRO_ID');

      vQry.ParamByName('PPRO_ID').AsInteger := APRO_ID;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TGnkGenProviders.Create(nil);
        Result.DOSS_ID := ADOSS_ID;
        Result.ADmGINKOIA := vdmGINKOIA;
        Result.SetValuesByDataSet(vQry);
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetGenProviders : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetGenReplication(const ADOSS_ID, AREP_ID: integer): TGnkGenReplication;
var
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      vQry.SQL.Append('Select *');
      vQry.SQL.Append('From GENREPLICATION');
      vQry.SQL.Append('Join K on (K_ID = REP_ID and K_ENABLED = 1)');
      vQry.SQL.Append('Where  REP_ORDRE > 0');
      vQry.SQL.Append('And REP_ID = :PREP_ID');

      vQry.ParamByName('PREP_ID').AsInteger := AREP_ID;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TGnkGenReplication.Create(nil);
        Result.ADmGINKOIA := vdmGINKOIA;
        Result.DOSS_ID := ADOSS_ID;
        Result.SetValuesByDataSet(vQry);
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetGenReplication : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetGenReplicationByLauID(const ADOSS_ID, ALAU_ID: integer): TGnkGenReplication;
var
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      vQry.SQL.Append('Select *');
      vQry.SQL.Append('From GENREPLICATION');
      vQry.SQL.Append('Join K on (K_ID = REP_ID and K_ENABLED = 1)');
      vQry.SQL.Append('Where  REP_ORDRE > 0');
      vQry.SQL.Append('And REP_LAUID = :PREP_LAUID');

      vQry.ParamByName('PREP_LAUID').AsInteger := ALAU_ID;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TGnkGenReplication.Create(nil);
        Result.ADmGINKOIA := vdmGINKOIA;
        Result.DOSS_ID := ADOSS_ID;
        Result.SetValuesByDataSet(vQry);
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetGenReplicationByLauID : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetGenSubscribers(const ADOSS_ID, ASUB_ID: integer): TGnkGenSubscribers;
var
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      vQry.SQL.Append('Select');
      vQry.SQL.Append('	SUB_ID,');
      vQry.SQL.Append('	SUB_NOM,');
      vQry.SQL.Append('	SUB_ORDRE,');
      vQry.SQL.Append('	SUB_LOOP');
      vQry.SQL.Append('From GENSUBSCRIBERS');
      vQry.SQL.Append('Join K on (K_ID = SUB_ID and K_ENABLED = 1)');
      vQry.SQL.Append('Where SUB_ID = :PSUB_ID');
      vQry.SQL.Append('Order By SUB_ORDRE');

      vQry.ParamByName('PSUB_ID').AsInteger := ASUB_ID;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TGnkGenSubscribers.Create(nil);
        Result.DOSS_ID := ADOSS_ID;
        Result.ADmGINKOIA := vdmGINKOIA;
        Result.SetValuesByDataSet(vQry);
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetGenSubscribers : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetGroupe(index: integer): TGroupe;
begin
  Result := TGroupe(FListGrp.Items[index]);
end;

function TMaintenanceCtrl.GetGroupeByID(AGROU_ID: integer): TGroupe;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListGrp.Count - 1 do
  begin
    if Groupe[i].GROU_ID = AGROU_ID then
    begin
      Result := Groupe[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetHoraireByServeurID(ASERV_ID, APRH_ID: integer): THoraire;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListSrv.Count - 1 do
  begin
    if Serveur[i].SERV_ID = ASERV_ID then
    begin
      Result := Serveur[i].HoraireByID[APRH_ID];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetListGenProviders(const ADOSS_ID, AREP_ID: integer; const AStatutPkg: TStatutPkg): TObjectList;
var
  vGnkGenProviders: TGnkGenProviders;
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      case AStatutPkg of
        spDisponible:
          begin
            vQry.SQL.Append('Select');
            vQry.SQL.Append('  PRO_ID,');
            vQry.SQL.Append('  PRO_NOM,');
            vQry.SQL.Append('  PRO_ORDRE,');
            vQry.SQL.Append('  PRO_LOOP');
            vQry.SQL.Append('From GENPROVIDERS');
            vQry.SQL.Append('Join K on (K_ID = PRO_ID and K_ENABLED = 1)');
            vQry.SQL.Append('Where PRO_ID <> 0');
            vQry.SQL.Append('Order By PRO_ORDRE');
          end;
        spTraite:
          begin
            vQry.SQL.Append('Select');
            vQry.SQL.Append('  PRO_ID,');
            vQry.SQL.Append('  PRO_NOM,');
            vQry.SQL.Append('  PRO_ORDRE,');
            vQry.SQL.Append('  PRO_LOOP,');
            vQry.SQL.Append('  GLR_ID');
            vQry.SQL.Append('From GENLIAIREPLI');
            vQry.SQL.Append('Join K on (K_ID = GLR_ID and K_ENABLED = 1)');
            vQry.SQL.Append('Join GENPROVIDERS on (PRO_ID = GLR_PROSUBID)');
            vQry.SQL.Append('Where GLR_REPID = :PREPID');
            vQry.SQL.Append('Order By PRO_ORDRE');

            vQry.ParamByName('PREPID').AsInteger := AREP_ID;
          end;
      end;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TObjectList.Create(True);

        while not vQry.Eof do
        begin
          vGnkGenProviders := TGnkGenProviders.Create(nil);
          vGnkGenProviders.DOSS_ID := ADOSS_ID;
          vGnkGenProviders.FreeDmGINKOIA := False;
          vGnkGenProviders.ADmGINKOIA := vdmGINKOIA;
          vGnkGenProviders.SetValuesByDataSet(vQry);

          Result.Add(vGnkGenProviders);

          vQry.Next;
        end;
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetListGenProviders : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetListGenReplication(const ADOSS_ID, ALAUID, AREPLICWEB: integer): TObjectList;
var
  vGnkGenReplication: TGnkGenReplication;
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      if AREPLICWEB = 1 then
        vQry.SQL.Text := cSql_S_GetListGenReplication_Web
      else
        vQry.SQL.Text := cSql_S_GetListGenReplication;

      vQry.ParamByName('PLAUID').AsInteger := ALAUID;
      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TObjectList.Create(True);

        while not vQry.Eof do
        begin
          vGnkGenReplication := TGnkGenReplication.Create(nil);
          vGnkGenReplication.DOSS_ID := ADOSS_ID;
          vGnkGenReplication.FreeDmGINKOIA := False;
          vGnkGenReplication.ADmGINKOIA := vdmGINKOIA;
          vGnkGenReplication.SetValuesByDataSet(vQry);

          Result.Add(vGnkGenReplication);
          vQry.Next;
        end;
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetListGenReplication : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetListGenSubscribers(const ADOSS_ID, AREP_ID: integer; const AStatutPkg: TStatutPkg): TObjectList;
var
  vGnkGenSubscribers: TGnkGenSubscribers;
  vdmGINKOIA: TdmGINKOIA;
  vQry: TFDQuery;
begin
  inherited;
  Result := nil;
  try
    try
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(ADOSS_ID);
      vQry := vdmGINKOIA.GetNewQry;

      case AStatutPkg of
        spDisponible:
          begin
            vQry.SQL.Append('Select');
            vQry.SQL.Append('	SUB_ID,');
            vQry.SQL.Append('	SUB_NOM,');
            vQry.SQL.Append('	SUB_ORDRE,');
            vQry.SQL.Append('	SUB_LOOP');
            vQry.SQL.Append('From GENSUBSCRIBERS');
            vQry.SQL.Append('Join K on (K_ID = SUB_ID and K_ENABLED = 1)');
            vQry.SQL.Append('Where SUB_ID <> 0');
            vQry.SQL.Append('Order By SUB_ORDRE');
          end;
        spTraite:
          begin
            vQry.SQL.Append('Select');
            vQry.SQL.Append('	SUB_ID,');
            vQry.SQL.Append('	SUB_NOM,');
            vQry.SQL.Append('	SUB_ORDRE,');
            vQry.SQL.Append('	SUB_LOOP,');
            vQry.SQL.Append('	GLR_ID');
            vQry.SQL.Append('From GENLIAIREPLI');
            vQry.SQL.Append('Join K on (K_ID = GLR_ID and K_ENABLED = 1)');
            vQry.SQL.Append('Join GENSUBSCRIBERS on (SUB_ID = GLR_PROSUBID)');
            vQry.SQL.Append('Where GLR_REPID = :PREPID');
            vQry.SQL.Append('Order By SUB_ORDRE');

            vQry.ParamByName('PREPID').AsInteger := AREP_ID;
          end;
      end;

      vQry.Open;

      if not vQry.Eof then
      begin
        Result := TObjectList.Create(True);

        while not vQry.Eof do
        begin
          vGnkGenSubscribers := TGnkGenSubscribers.Create(nil);
          vGnkGenSubscribers.DOSS_ID := ADOSS_ID;
          vGnkGenSubscribers.FreeDmGINKOIA := False;
          vGnkGenSubscribers.ADmGINKOIA := vdmGINKOIA;
          vGnkGenSubscribers.SetValuesByDataSet(vQry);

          Result.Add(vGnkGenSubscribers);

          vQry.Next;
        end;
      end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetListGenSubscribers : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetListModule(const ADOSS_ID, AMAG_ID: integer): TObjectList;
var
  vMdl: TModule;
  vDos: TDossier;
  vQry: TFDQuery;
begin
  Result := TObjectList.Create(True);
  try
    try
      vDos := DossierByID[ADOSS_ID];
      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      if vDos.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vQry := dmMaintenance.GetNewQry;

      vQry.SQL.Text := cSql_S_GetListModule;
      vQry.ParamByName('PDOSSID').AsInteger := vDos.DOSS_ID;
      vQry.ParamByName('PMAGAID').AsInteger := AMAG_ID;
      vQry.Open;

      while not vQry.Eof do
      begin
        vMdl := TModule.Create(nil);
        vMdl.MODU_ID := vQry.FieldByName('MODU_ID').AsInteger;
        vMdl.MODU_NOM := vQry.FieldByName('MODU_NOM').AsString;
        vMdl.MODU_COMMENT := vQry.FieldByName('MODU_COMMENT').AsString;
        vMdl.MMAG_EXPDATE := vQry.FieldByName('MMAG_EXPDATE').AsDateTime;
        Result.Add(vMdl);

        vQry.Next;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetListModule : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetListModuleGinkoia(const ADOSS_ID, AMAG_ID_GINKOIA: integer; Const All: Boolean): TObjectList;
var
  vMdl: TModule;
  vMdlG: TModuleGinkoia;
  vDos: TDossier;
  vMag: TMagasin;
  vdmGINKOIA: TdmGINKOIA;
  vQryGinkoia: TFDQuery;
begin
  Result := TObjectList.Create(True);
  try
    try
      vDos := DossierByID[ADOSS_ID];
      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      if vDos.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);
      vQryGinkoia := vdmGINKOIA.GetNewQry;

      vQryGinkoia.SQL.Append('select UGG.UGG_ID, UGG.UGG_NOM');
      vQryGinkoia.SQL.Append('from UILGRPGINKOIA UGG join K K1 on (K1.K_ID = UGG.UGG_ID and K_Enabled = 1)');

      if not All then
      begin
        vQryGinkoia.SQL.Append('and UGG.UGG_ID not in (select UGM.UGM_UGGID');
        vQryGinkoia.SQL.Append('from  UILGRPGINKOIAMAG UGM join K K2 on (K2.K_ID = UGM.UGM_ID and K_Enabled = 1)');
        vQryGinkoia.SQL.Append('where UGM.UGM_MAGID = ' + IntToStr(AMAG_ID_GINKOIA) + ')');
      end;

      vQryGinkoia.SQL.Append('where UGG.UGG_ID <> 0');

      vMag := vDos.MagasinByIDGINKOIA[AMAG_ID_GINKOIA];

      vQryGinkoia.Open;
      while not vQryGinkoia.Eof do
      begin
        vMdlG := TModuleGinkoia.Create(nil);
        vMdlG.ADossier := vDos;
        Result.Add(vMdlG);

        vMdlG.UGG_ID := vQryGinkoia.FieldByName('UGG_ID').AsInteger;
        vMdlG.MODU_NOM := vQryGinkoia.FieldByName('UGG_NOM').AsString;

        if vMag <> nil then
        begin
          vMdlG.MAGA_ID := vMag.MAGA_ID;
          vMdlG.UGM_MAGID := vMag.MAGA_MAGID_GINKOIA;
        end;

        vMdl := ModuleByNOM[vMdlG.MODU_NOM];
        if vMdl <> nil then
          vMdlG.MODU_ID := vMdl.MODU_ID;

        vQryGinkoia.Next;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetListModuleGinkoia : ' + E.Message);
    end;
  finally
    FreeAndNil(vQryGinkoia);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetListSplittageLog: TObjectList;
var
  vGnkSplittageLog: TGnkSplittageLog;
  vQry: TFDQuery;
begin
  Result := TObjectList.Create(True);
  try
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'SELECT * FROM SPLITTAGE_LOG ORDER BY SPLI_ORDRE';
    vQry.Open;
    dmMaintenance.GetMaintenanceParamInteger(2, 2);
    while not vQry.Eof do
    begin
      vGnkSplittageLog := TGnkSplittageLog.Create(nil);
      vGnkSplittageLog.SetValuesByDataSet(vQry);

      Result.Add(vGnkSplittageLog);

      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetListSrvReplication(const ASERV_ID: integer): TObjectList;
var
  vSrvRep: TSrvReplication;
  vQry: TFDQuery;
begin
  Result := TObjectList.Create(True);
  try
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'SELECT * FROM SUIVISVR WHERE SSVR_SERVID = ' + IntToStr(ASERV_ID);
    vQry.Open;
    while not vQry.Eof do
    begin
      vSrvRep := TSrvReplication.Create(nil);
      vSrvRep.SRV_ID := ASERV_ID;
      vSrvRep.SVR_PATH := vQry.FieldByName('SSVR_PATH').AsString;
      Result.Add(vSrvRep);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetMagasin(index: integer): TMagasin;
begin
  Result := TMagasin(FListMag.Items[index]);
end;

function TMaintenanceCtrl.GetMagasinByID(AMAGA_ID: integer): TMagasin;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMag.Count - 1 do
  begin
    if Magasin[i].MAGA_ID = AMAGA_ID then
    begin
      Result := Magasin[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetMagasinByMAGA_MAGID_GINKOIA(AMAGA_MAGID_GINKOIA, ADOSS_ID: integer): TMagasin;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMag.Count - 1 do
  begin
    if (Magasin[i].MAGA_DOSSID = ADOSS_ID) and (Magasin[i].MAGA_MAGID_GINKOIA = AMAGA_MAGID_GINKOIA) then
    begin
      Result := Magasin[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetMaintenanceEmetDateInstallation(Const AGUID: string): string;
var
  vQry: TFDQuery;
begin
  Result := '';
  try
    if AGUID <> '' then
    begin
      vQry := dmMaintenance.GetNewQry;
      vQry.SQL.Text := cSql_S_Maintenance_Emet_DateInstallation;
      vQry.ParamByName('PEMETGUID').AsString := AGUID;
      vQry.Open;

      if not vQry.Eof then
      begin
        if (vQry.FieldByName('EMET_INSTALL').AsDateTime = 0) or (vQry.FieldByName('EMET_INSTALL').AsDateTime = StrToDateTime('01/01/1900')) then
          Result := '0'
        else
          Result := DateTimeToIso8601(vQry.FieldByName('EMET_INSTALL').AsDateTime);
      end
      else
        Result := 'Erreur : Le Guid : ' + AGUID + ' ne correspond à aucun Emetteur.'
    end
    else
      Result := 'Erreur : GUID vide.';
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.SetMaintenanceEmetDateInstallation(Const AGUID: string; Const AEmet_Install: TDateTime): string;
var
  vQry: TFDQuery;
begin
  Result := '';
  try
    if AGUID <> '' then
    begin
      vQry := dmMaintenance.GetNewQry;
      vQry.SQL.Text := cSql_S_Maintenance_Emet_DateInstallation;
      vQry.ParamByName('PEMETGUID').AsString := AGUID;
      vQry.Open;

      if not vQry.Eof then
      begin
        vQry.Close;
        vQry.SQL.Text := cSql_U_Maintenance_Emet_DateInstallation;
        vQry.ParamByName('PEMETINSTALL').AsDateTime := AEmet_Install;
        vQry.ParamByName('PEMETGUID').AsString := AGUID;
        vQry.ExecSQL;
        Result := 'Ok';
      end
      else
        Result := 'Erreur : Le Guid : ' + AGUID + ' ne correspond à aucun Emetteur.'
    end
    else
      Result := 'Erreur : GUID vide.';
  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.SetMaintenanceInitialisationPostes(const ACMD: string): string;
var
  vdmGINKOIA: TdmGINKOIA;
  vQry_S_Dossier, vQry_S_Magasins, vQry_S_Poste, vQry_I_Poste, vQryGinkoia: TFDQuery;
  sNom: string;
begin
  Result := '';
  try
    if ACMD = 'POSTES-INIT' then
    begin
      // Init Query
      vQry_S_Magasins := dmMaintenance.GetNewQry;
      vQry_S_Magasins.SQL.Text := cSql_S_InitPostes_Magasin;

      vQry_S_Poste := dmMaintenance.GetNewQry;
      vQry_S_Poste.SQL.Text := cSql_S_InitPostes_Poste;

      vQry_I_Poste := dmMaintenance.GetNewQry;
      vQry_I_Poste.SQL.Text := cSql_I_postes;

      // Récupération liste des dossiers
      vQry_S_Dossier := dmMaintenance.GetNewQry;
      vQry_S_Dossier.SQL.Text := cSql_S_InitPostes_Dossier;
      vQry_S_Dossier.Open;

      if not vQry_S_Dossier.Eof then
      begin
        vQry_S_Poste := dmMaintenance.GetNewQry;
        vQry_S_Poste.SQL.Text := cSql_S_InitPostes_Poste;

        // On boucle sur les dossiers
        while not vQry_S_Dossier.Eof do
        begin
          if FileExists('\\' + vQry_S_Dossier.FieldByName('DOSS_CHEMIN').AsString.Replace(':', '\')) then
          begin
            try
              if vdmGINKOIA = nil then
                vdmGINKOIA := ConnectToGINKOIA(vQry_S_Dossier.FieldByName('DOSS_CHEMIN').AsString);

              vQryGinkoia := vdmGINKOIA.GetNewQry;

              if not vdmGINKOIA.Transaction.Active then
                vdmGINKOIA.Transaction.StartTransaction;

              // Récupération des postes du dossier
              vQryGinkoia.SQL.Text := cSql_S_genposte;
              vQryGinkoia.Open;

              // On boucle sur les postes
              while not vQryGinkoia.Eof do
              begin
                vQry_S_Poste.Close;
                vQry_S_Poste.ParamByName('PDOSSID').AsInteger := vQry_S_Dossier.FieldByName('DOSS_ID').AsInteger;
                vQry_S_Poste.ParamByName('PMAGID').AsInteger := vQryGinkoia.FieldByName('POS_MAGID').AsInteger;
                vQry_S_Poste.ParamByName('PPOSID').AsInteger := vQryGinkoia.FieldByName('POS_ID').AsInteger;
                vQry_S_Poste.Open;

                // Si le poste n'est pas trouvé on le créé.
                if vQry_S_Poste.Eof then
                begin
                  vQry_S_Magasins.Close;
                  vQry_S_Magasins.ParamByName('PDOSSID').AsInteger := vQry_S_Dossier.FieldByName('DOSS_ID').AsInteger;
                  vQry_S_Magasins.ParamByName('PMAGID').AsInteger := vQryGinkoia.FieldByName('POS_MAGID').AsInteger;
                  vQry_S_Magasins.Open;

                  sNom := vQryGinkoia.FieldByName('POS_NOM').AsString;

                  vQry_I_Poste.ParamByName('PPOSTID').AsInteger := dmMaintenance.GetNewID('postes');
                  vQry_I_Poste.ParamByName('PPOSTPOSID').AsInteger := vQryGinkoia.FieldByName('POS_ID').AsInteger;
                  vQry_I_Poste.ParamByName('PPOSTMAGAID').AsInteger := vQry_S_Magasins.FieldByName('MAGA_ID').AsInteger;
                  vQry_I_Poste.ParamByName('PPOSTNOM').AsString := sNom;
                  vQry_I_Poste.ParamByName('PPOSTINFO').AsString := vQryGinkoia.FieldByName('POS_INFO').AsString;
                  vQry_I_Poste.ParamByName('PPOSTCOMPTA').AsString := vQryGinkoia.FieldByName('POS_COMPTA').AsString;

                  if (UpperCase(sNom[1]) = 'B') OR (UpperCase(sNom[1]) = 'G') then
                    vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 1 // Gestion
                  else if (UpperCase(sNom[1]) = 'S') then
                  begin
                    if UpperCase(sNom[sNom.Length]) = 'C' then
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 3 // Serveur Secours
                    else
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 2; // Serveur
                  end
                  else if (UpperCase(sNom[1]) = 'C') then
                  begin
                    if UpperCase(sNom[sNom.Length]) = 'C' then
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 5 // Caisse Secours
                    else
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 4; // Caisse
                  end
                  else if (UpperCase(sNom[1]) = 'P') then
                  begin
                    if UpperCase(sNom[2]) = 'L' then
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 9 // Sans Abo
                    else if UpperCase(sNom[sNom.Length]) = 'C' then
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 7 // Portable Synchro
                    else
                      vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 6; // Portable
                  end
                  else if (UpperCase(sNom[1]) = 'R') then
                    vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 8 // RDP
                  else
                    vQry_I_Poste.ParamByName('PPOSTPTYPID').AsInteger := 9; // Par défaut Sans Abo

                  vQry_I_Poste.ParamByName('PPOSTDATEC').AsDateTime := vQryGinkoia.FieldByName('K_INSERTED').AsDateTime;
                  vQry_I_Poste.ParamByName('PPOSTDATEM').AsDateTime := vQryGinkoia.FieldByName('K_UPDATED').AsDateTime;
                  vQry_I_Poste.ParamByName('PPOSTENABLE').AsInteger := 1;
                  vQry_I_Poste.ExecSQL;
                end;
                vQryGinkoia.Next;
              end;

              Result := Result + 'Dossier : ' + vQry_S_Dossier.FieldByName('DOSS_DATABASE').AsString + ' -> Base traité.' + '<br>';

            finally
              FreeAndNil(vdmGINKOIA);
              FreeAndNil(vQryGinkoia);
            end;
          end
          else
            Result := Result + 'Dossier : ' + vQry_S_Dossier.FieldByName('DOSS_DATABASE').AsString + ' -> Chemin de base incorrect.' + '<br>';

          vQry_S_Dossier.Next;
        end;
      end
      else
        Result := 'Erreur : Pas de dossier sur cette base Maintenance.'
    end
    else
      Result := 'Erreur : Code init non valide.';
  finally
    FreeAndNil(vQry_S_Dossier);
    FreeAndNil(vQry_S_Magasins);
    FreeAndNil(vQry_S_Poste);
    FreeAndNil(vQry_I_Poste);
  end;
end;

function TMaintenanceCtrl.GetModule(index: integer): TModule;
begin
  Result := TModule(FListMod.Items[index]);
end;

function TMaintenanceCtrl.GetModuleByID(AMODU_ID: integer): TModule;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMod.Count - 1 do
  begin
    if Module[i].MODU_ID = AMODU_ID then
    begin
      Result := Module[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetModuleByNOM(AMODU_NOM: String): TModule;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMod.Count - 1 do
  begin
    if Module[i].MODU_NOM = AMODU_NOM then
    begin
      Result := Module[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetModuleGinkoia(const ADOSS_ID, AUGM_MAGID, AUGG_ID: integer): TModuleGinkoia;
var
  vDos: TDossier;
  vdmGINKOIA: TdmGINKOIA;
  vQryGinkoia: TFDQuery;
begin
  Result := nil;
  try
    try
      vDos := DossierByID[ADOSS_ID];
      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      if vDos.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);
      vQryGinkoia := vdmGINKOIA.GetNewQry;

      vQryGinkoia.SQL.Append('select * from');
      vQryGinkoia.SQL.Append('UILGRPGINKOIAMAG UGM join K on (K.K_ID = UGM.UGM_ID)');
      vQryGinkoia.SQL.Append('left outer join UILGRPGINKOIA UGG on (UGG.UGG_ID = UGM.UGM_UGGID)');
      vQryGinkoia.SQL.Append('where UGM.UGM_MAGID =' + IntToStr(AUGM_MAGID));
      vQryGinkoia.SQL.Append('and UGG.UGG_ID =' + IntToStr(AUGG_ID));
      vQryGinkoia.SQL.Append('and K.K_Enabled = 1');
      vQryGinkoia.Open;

      if not vQryGinkoia.Eof then
      begin
        Result := TModuleGinkoia.Create(nil);
        Result.ADossier := vDos;
        Result.UGM_ID := vQryGinkoia.FieldByName('UGM_ID').AsInteger;
        Result.UGM_MAGID := vQryGinkoia.FieldByName('UGM_MAGID').AsInteger;
        Result.UGG_ID := vQryGinkoia.FieldByName('UGG_ID').AsInteger;
        Result.MODU_ID := vQryGinkoia.FieldByName('UGG_ID').AsInteger;
        Result.MODU_NOM := vQryGinkoia.FieldByName('UGG_NOM').AsString;
        Result.MMAG_EXPDATE := vQryGinkoia.FieldByName('UGM_DATE').AsDateTime;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetModuleGinkoia : ' + E.Message);
    end;
  finally
    FreeAndNil(vQryGinkoia);
    FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetNewdmGINKOIAByChemin(const AChemin: string): TdmGINKOIA;
begin
  try
    if AChemin = '' then
      Raise Exception.Create(SM_PathDBMissing.AMessage);

    Result := ConnectToGINKOIA(AChemin);
  except
    on E: Exception do
      Raise Exception.Create(ClassName + '.GetNewdmGINKOIAByChemin : ' + E.Message);
  end;
end;

function TMaintenanceCtrl.GetNewdmGINKOIAByDossier(const ADossier: TDossier): TdmGINKOIA;
begin
  Result := GetNewdmGINKOIAByDOSS_ID(ADossier.DOSS_ID);
end;

function TMaintenanceCtrl.GetNewdmGINKOIAByDOSS_ID(const ADOSS_ID: integer): TdmGINKOIA;
var
  vDos: TDossier;
begin
  try
    vDos := DossierByID[ADOSS_ID];
    if vDos = nil then
      Raise Exception.Create(SM_PathNotFound.AMessage);

    if vDos.DOSS_CHEMIN = '' then
      Raise Exception.Create(SM_PathDBMissing.AMessage);

    Result := ConnectToGINKOIA(vDos.DOSS_CHEMIN);
  except
    on E: Exception do
      Raise Exception.Create(ClassName + '.GetNewdmGINKOIAByDOSS_ID : ' + E.Message);
  end;
end;

function TMaintenanceCtrl.GetNewIdentGinkoia(const ADOSS_ID: integer): String;
var
  vDos: TDossier;
  vdmGINKOIA: TdmGINKOIA;
begin
  vdmGINKOIA := nil;
  Result := '';
  try
    try
      vDos := DossierByID[ADOSS_ID];
      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      if vDos.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);

      Result := vDos.GetNewIdent(vdmGINKOIA);
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetNewIdentGinkoia : ' + E.Message);
    end;
  finally
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetNewPlageGinkoia(const ADOSS_ID: integer): String;
var
  vDos: TDossier;
  vdmGINKOIA: TdmGINKOIA;
  vSL: TStringList;
begin
  Result := '';
  vdmGINKOIA := nil;
  vSL := TStringList.Create;
  try
    try
      vDos := DossierByID[ADOSS_ID];
      if vDos = nil then
        Raise Exception.Create(SM_PathNotFound.AMessage);

      if vDos.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);

      Result := vDos.GetNewPlage(vdmGINKOIA, vSL);
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetNewPlageGinkoia : ' + E.Message);
    end;
  finally
    FreeAndNil(vSL);
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
  end;
end;

function TMaintenanceCtrl.GetServeur(index: integer): TServeur;
begin
  Result := TServeur(FListSrv.Items[index]);
end;

function TMaintenanceCtrl.GetServeurByID(ASERV_ID: integer): TServeur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListSrv.Count - 1 do
  begin
    if Serveur[i].SERV_ID = ASERV_ID then
    begin
      Result := Serveur[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetSplittageLog(const ANOSPLIT: integer): TGnkSplittageLog;
var
  vQry: TFDQuery;
begin
  Result := TGnkSplittageLog.Create(nil);
  if ANOSPLIT = -1 then
    Exit;
  try
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'SELECT * FROM SPLITTAGE_LOG WHERE SPLI_NOSPLIT = :PNOSPLIT';
    vQry.ParamByName('PNOSPLIT').AsInteger := ANOSPLIT;
    vQry.Open;

    if not vQry.Eof then
      Result.SetValuesByDataSet(vQry);

  finally
    FreeAndNil(vQry);
  end;
end;

function TMaintenanceCtrl.GetPoste(index: integer): TPoste;
begin
  Result := TPoste(FListPoste.Items[index]);
end;

function TMaintenanceCtrl.GetPosteByID(APOST_ID: integer): TPoste;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListPoste.Count - 1 do
  begin
    if Poste[i].POST_ID = APOST_ID then
    begin
      Result := Poste[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetPosteByPOST_MAGAID(APOST_MAGAID, APOST_POSID: integer): TPoste;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListPoste.Count - 1 do
  begin
    if (Poste[i].POST_POSID = APOST_POSID) and (Poste[i].POST_MAGAID = APOST_MAGAID) then
    begin
      Result := Poste[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetPropSynthese(const ATypeSynthese: String): PPropSynthese;
var
  i: integer;
begin
  Result := nil;
  if ATypeSynthese = '' then
    Exit;
  for i := Low(cListTypeSynthese) to High(cListTypeSynthese) do
  begin
    if UpperCase(cListTypeSynthese[i].Name) = UpperCase(ATypeSynthese) then
    begin
      Result := @cListTypeSynthese[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetRaison(index: integer): TRaison;
begin
  Result := TRaison(FListRaison.Items[index]);
end;

function TMaintenanceCtrl.GetRaisonByID(ARAIS_ID: integer): TRaison;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListRaison.Count - 1 do
  begin
    if Raison[i].RAIS_ID = ARAIS_ID then
    begin
      Result := Raison[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetVersion(index: integer): TVersion;
begin
  Result := TVersion(FListVer.Items[index]);
end;

function TMaintenanceCtrl.GetVersionByID(AVERS_ID: integer): TVersion;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListVer.Count - 1 do
  begin
    if Version[i].VERS_ID = AVERS_ID then
    begin
      Result := Version[i];
      Break;
    end;
  end;
end;

function TMaintenanceCtrl.GetVersionByVERS_VERSION(AVERS_VERSION: String): TVersion;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to CountVer - 1 do
  begin
    if Version[i].VERS_VERSION = AVERS_VERSION then
    begin
      Result := Version[i];
      Break;
    end;
  end;
end;

procedure TMaintenanceCtrl.InitializeListDos;
var
  vDos: TDossier;
  vSrv: TServeur;
  vGrp: TGroupe;
  vQry: TFDQuery;
begin
  try
    FListDos.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := cSql_S_InitializeListDos;
    vQry.Open;
    while not vQry.Eof do
    begin
      vDos := TDossier.Create(nil);
      vDos.SetValuesByDataSet(vQry);

      vDos.VERS_VERSION := vQry.FieldByName('VERS_VERSION').AsString;

      vSrv := ServeurByID[vQry.FieldByName('DOSS_SERVID').AsInteger];
      if vSrv <> nil then
        vDos.AServeur := vSrv;

      vGrp := GroupeByID[vQry.FieldByName('DOSS_GROUID').AsInteger];
      if vGrp <> nil then
        vDos.AGroupe := vGrp;

      FListDos.Add(vDos);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeListGrp;
var
  vGrp: TGroupe;
  vQry: TFDQuery;
begin
  try
    FListGrp.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'SELECT * FROM GROUPE WHERE GROU_ID <> 0 ORDER BY GROU_NOM';
    vQry.Open;
    while not vQry.Eof do
    begin
      vGrp := TGroupe.Create(nil);
      vGrp.GROU_ID := vQry.FieldByName('GROU_ID').AsInteger;
      vGrp.GROU_NOM := vQry.FieldByName('GROU_NOM').AsString;

      FListGrp.Add(vGrp);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeListMag;
var
  vDos: TDossier;
  vMag: TMagasin;
  vQry: TFDQuery;
begin
  try
    FListMag.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'Select * from MAGASINS WHERE MAGA_ID <> 0';
    vQry.Open;
    while not(vQry.Eof) do
    begin
      vMag := TMagasin.Create(nil);
      vMag.MAGA_ID := vQry.FieldByName('MAGA_ID').AsInteger;
      vMag.MAGA_DOSSID := vQry.FieldByName('MAGA_DOSSID').AsInteger;
      vMag.MAGA_MAGID_GINKOIA := vQry.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
      vMag.MAGA_NOM := vQry.FieldByName('MAGA_NOM').AsString;
      vMag.MAGA_ENSEIGNE := vQry.FieldByName('MAGA_ENSEIGNE').AsString;
      vMag.MAGA_CODEADH := vQry.FieldByName('MAGA_CODEADH').AsString;
      vMag.MAGA_K_ENABLED := vQry.FieldByName('MAGA_K_ENABLED').AsInteger;
      vMag.MAGA_BASID := vQry.FieldByName('MAGA_BASID').AsInteger;
      vMag.MAGA_MAGCODE := vQry.FieldByName('MAGA_MAGCODE').AsString;

      vDos := DossierByID[vMag.MAGA_DOSSID];
      if vDos <> nil then
        vMag.ADossier := vDos;

      FListMag.Add(vMag);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeListMod;
var
  vMdl: TModule;
  vQry: TFDQuery;
begin
  try
    FListMod.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'Select * from modules where MODU_ID <> 0';
    vQry.Open;
    while not vQry.Eof do
    begin
      vMdl := TModule.Create(nil);
      vMdl.MODU_ID := vQry.FieldByName('MODU_ID').AsInteger;
      vMdl.MODU_NOM := vQry.FieldByName('MODU_NOM').AsString;
      vMdl.MODU_COMMENT := vQry.FieldByName('MODU_COMMENT').AsString;

      FListMod.Add(vMdl);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeListPoste;
var
  vMag: TMagasin;
  vPoste: TPoste;
  vQry: TFDQuery;
  i: integer;
begin
  vQry := dmMaintenance.GetNewQry;
  try

    FListPoste.Clear;

    vQry.SQL.Text := 'Select * from POSTES WHERE POST_ID <> 0';
    vQry.Open;
    while not vQry.Eof do
    begin
      vPoste := TPoste.Create(nil);
      vPoste.POST_ID := vQry.FieldByName('POST_ID').AsInteger;
      vPoste.POST_POSID := vQry.FieldByName('POST_POSID').AsInteger;
      vPoste.POST_MAGAID := vQry.FieldByName('POST_MAGAID').AsInteger;
      vPoste.POST_NOM := vQry.FieldByName('POST_NOM').AsString;
      vPoste.POST_INFO := vQry.FieldByName('POST_INFO').AsString;
      vPoste.POST_COMPTA := vQry.FieldByName('POST_COMPTA').AsString;
      vPoste.POST_PTYPID := vQry.FieldByName('POST_PTYPID').AsInteger;
      vPoste.POST_DATEC := vQry.FieldByName('POST_DATEC').AsDateTime;
      vPoste.POST_DATEM := vQry.FieldByName('POST_DATEM').AsDateTime;
      vPoste.POST_ENABLE := vQry.FieldByName('POST_ENABLE').AsInteger;

      vMag := MagasinByID[vPoste.POST_MAGAID];
      if vMag <> nil then
        vPoste.AMagasin := vMag;

      FListPoste.Add(vPoste);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeListRaison;
var
  vRaison: TRaison;
  vQry: TFDQuery;
begin
  try
    FListRaison.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'Select * from raison where RAIS_ID <> 0';
    vQry.Open;
    while not vQry.Eof do
    begin
      vRaison := TRaison.Create(nil);
      vRaison.RAIS_ID := vQry.FieldByName('RAIS_ID').AsInteger;
      vRaison.RAIS_NOM := vQry.FieldByName('RAIS_NOM').AsString;

      FListRaison.Add(vRaison);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeLists;
begin
  { ATTENTION - l'ordre est tres important }
  InitializeListRaison;
  InitializeListSrv;
  InitializeListGrp;
  InitializeListVer;
  InitializeListDos;
  InitializeListMod;
  InitializeListMag;
  InitializeListPoste;
end;

procedure TMaintenanceCtrl.InitializeListSrv;
var
  vSrv: TServeur;
  vHor: THoraire;
  vQry: TFDQuery;
begin
  try
    FListSrv.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Append('SELECT * FROM SERVEUR LEFT OUTER JOIN PARAM_HORAIRES on (SERV_ID = PRHO_SERVID)');
    vQry.SQL.Append('WHERE SERV_ID <> 0 ORDER BY SERV_NOM');
    vQry.Open;
    while not vQry.Eof do
    begin
      vSrv := TServeur.Create(nil);
      vSrv.SetValuesByDataSet(vQry);
      FListSrv.Add(vSrv);

      while (not vQry.Eof) and (vQry.FieldByName('SERV_ID').AsInteger = vSrv.SERV_ID) do
      begin
        if Not vQry.FieldByName('PRHO_ID').IsNull then
        begin
          vHor := vSrv.HoraireByID[vQry.FieldByName('PRHO_ID').AsInteger];
          if vHor = nil then
            vHor := THoraire.Create(nil);

          vHor.SetValuesByDataSet(vQry);
          vSrv.AppendHoraire(vHor);
        end;

        vQry.Next;
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.InitializeListVer;
var
  vVer: TVersion;
  vQry: TFDQuery;
begin
  try
    FListVer.Clear;
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'Select * from version where VERS_ID <> 0';
    vQry.Open;
    while not vQry.Eof do
    begin
      vVer := TVersion.Create(nil);
      vVer.VERS_ID := vQry.FieldByName('VERS_ID').AsInteger;
      vVer.VERS_VERSION := vQry.FieldByName('VERS_VERSION').AsString;
      vVer.VERS_NOMVERSION := vQry.FieldByName('VERS_NOMVERSION').AsString;
      vVer.VERS_PATCH := vQry.FieldByName('VERS_PATCH').AsInteger;
      vVer.VERS_EAI := vQry.FieldByName('VERS_EAI').AsString;

      FListVer.Add(vVer);
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.StartThrdCtrlSplittage;
begin
  FTThrdCtrlSplittage.Resume;
end;

function TMaintenanceCtrl.LoadListEmetteur(Const ADOSS_ID, ASERV_ID: integer; Const ASynthese: String; Const AAllowListResult: Boolean;
  var AResultMsg: RStatusMessage): TObjectList;
var
  vCptResult, vEmetID: integer;
  vEmet: TEmetteur;
  vVer: TVersion;
  vDos: TDossier;
  vdmGINKOIA: TdmGINKOIA;
  vQry, vQryGinkoia: TFDQuery;
  vDS: TDataSet;
  vStoredProc: TFDStoredProc;
  vPropSynth: PPropSynthese;
  vSLExcept: TStringList;
  vSLTraceur: TStringList;
begin
  Result := nil;
  vCptResult := 0;
  vEmetID := -1;
  AResultMsg := SM_OK;

  vdmGINKOIA := nil;
  vQryGinkoia := nil;
  vQry := dmMaintenance.GetNewQry;
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur := TStringList.Create;
    vSLTraceur.Append(GetNowToStr + 'LoadListEmetteur');
    vSLTraceur.Append(GetNowToStr + 'DOSS_ID : ' + IntToStr(ADOSS_ID));
    vSLTraceur.Append(GetNowToStr + 'SERV_ID : ' + IntToStr(ASERV_ID));
    vSLTraceur.Append(GetNowToStr + 'Synthese : ' + ASynthese);
    vSLTraceur.Append(GetNowToStr + 'AllowListResult : ' + BoolToStr(AAllowListResult));
    vSLTraceur.Append(GetNowToStr + 'ResultMsg.Code : ' + IntToStr(AResultMsg.Code));
    vSLTraceur.Append(GetNowToStr + 'ResultMsg.AMessage : ' + AResultMsg.AMessage);
  end;
  vSLExcept := TStringList.Create;
  try
    vDS := vQry;
    try
      vQry.SQL.Append('SELECT * FROM EMETTEUR ');

      vDos := DossierByID[ADOSS_ID];

      if vDos <> nil then
      begin
        if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
          vSLTraceur.Append(GetNowToStr + 'vDos.DOSS_DATABASE : ' + vDos.DOSS_DATABASE);

        if vDos.DOSS_CHEMIN = '' then
        begin
          AResultMsg := SM_PathDBMissing;
          Exit;
        end;

        // {$IFDEF WAD}
        // if not FileExists(vDos.DOSS_CHEMIN) then
        // begin
        // AResultMsg:= SM_PathNotFound;
        // Exit;
        // end;
        // {$ELSE}
        // if not FileExists(IncludeTrailingBackslash(DOSS_CHEMINToUNC(vDos.SERV_NOM, vDos.DOSS_CHEMIN)) + cDB_FileName_GINKOIA) then
        // begin
        // AResultMsg:= SM_PathNotFound;
        // Exit;
        // end;
        // {$ENDIF}

        vdmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);
        vQryGinkoia := vdmGINKOIA.GetNewQry;

        vQry.SQL.Append('where EMET_DOSSID = ' + IntToStr(vDos.DOSS_ID));

        if AAllowListResult then
          Result := TObjectList.Create(False); // --> Liste restreinte de sortie

        SynchronizeBAS_IDENTToEMET_IDENT(ADOSS_ID, ASERV_ID, nil, vdmGINKOIA, AResultMsg);

        if AResultMsg.Code < 0 then
        begin
          if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
          begin
            vSLTraceur.Append(GetNowToStr + 'ResultMsg.Code : ' + IntToStr(AResultMsg.Code));
            vSLTraceur.Append(GetNowToStr + 'ResultMsg.AMessage : ' + AResultMsg.AMessage);
          end;
          Exit;
        end;
      end
      else
      begin
        if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
          vSLTraceur.Append(GetNowToStr + 'vDos.DOSS_DATABASE : Vide');

        vQry.SQL.Append('where EMET_ID <> 0');
      end;

      { ---------------------------- Synthese -------------------------------- }
      if ASynthese <> '' then
      begin
        vPropSynth := GetPropSynthese(ASynthese);
        if (vPropSynth <> nil) and (vPropSynth.Ressource <> '') then
        begin
          if vPropSynth.IsStoredProc then
          begin
            FreeAndNil(vDS);
            vStoredProc := dmMaintenance.GetNewStoredProc(vPropSynth.Ressource, vPropSynth.ListParamValue);
            vDS := vStoredProc;
          end
          else
            dmMaintenance.LoadParamsToQuery(vQry, vPropSynth.Ressource, vPropSynth.ListParamValue);
        end;
      end;
      { ---------------------------------------------------------------------- }

      vDS.Open;
      while (not vDS.Eof) do
      begin
        vEmetID := vDS.FieldByName('EMET_ID').AsInteger;

        if vEmetID = 0 then
        begin
          vDS.Next;
          Continue;
        end;

        vEmet := EmetteurByID[vEmetID];
        if vEmet = nil then
        begin
          vEmet := TEmetteur.Create(nil);
          FListEmet.Add(vEmet);
        end;

        vEmet.SetValuesByDataSet(vDS);

        if (vDos <> nil) and (ADOSS_ID > 0) then
          vEmet.ADossier := vDos
        else
        begin
          vDos := DossierByID[vDS.FieldByName('EMET_DOSSID').AsInteger];
          if vDos <> nil then
            vEmet.ADossier := vDos;
        end;

        if vEmet.ADossier <> nil then
          vEmet.ADossier.AppendEmetteur(vEmet);

        vVer := VersionByID[vEmet.EMET_VERSID];
        if vVer <> nil then
          vEmet.AVersion := vVer;

        if (vDos <> nil) and (ADOSS_ID > 0) then
          SetValuesEmetteurByGinkoia(vdmGINKOIA, vEmet);

        if Result <> nil then
        begin
          if ADOSS_ID > 0 then
            Result.Add(vEmet)
          else if (vEmet.ADossier <> nil) and (vEmet.ADossier.DOSS_SERVID = ASERV_ID) then
            Result.Add(vEmet);
        end;

        inc(vCptResult);
        vDS.Next;
      end;

      if vCptResult = 0 then
        AResultMsg := SM_NotResult;
    except
      on E: Exception do
      begin
        AResultMsg := SM_ERREUR_INTERNE;
        AResultMsg.AMessage := E.Message;
        vSLExcept.Append('TMaintenanceCtrl.LoadListEmetteur');
        vSLExcept.Append('vEmet.EMET_ID : ' + IntToStr(vEmetID));
        vSLExcept.Append(E.Message);
        GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TMaintenanceCtrl_LoadListEmetteur.Except', vSLExcept,
          GWSConfig.LogException);
      end;
    end;
  finally
    FreeAndNil(vDS);

    if vQryGinkoia <> nil then
      FreeAndNil(vQryGinkoia);

    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);

    FreeAndNil(vSLExcept);

    if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
    begin
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'LoadListEmetteur' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
      FreeAndNil(vSLTraceur);
    end;
  end;
end;

procedure TMaintenanceCtrl.LoadListGrpToDossier(const ADossier: TDossier);
var
  vGroupPump: TGroupPump;
  vdmGINKOIA: TdmGINKOIA;
  vQryGinkoia: TFDQuery;
begin
  vdmGINKOIA := nil;
  vQryGinkoia := nil;
  try
    try
      if ADossier.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);
      vQryGinkoia := vdmGINKOIA.GetNewQry;

      vQryGinkoia.SQL.Append('SELECT GCP_ID, GCP_NOM FROM GENGESTIONPUMP JOIN K ON (K_ID = GCP_ID) WHERE GCP_ID <> 0');

      vQryGinkoia.Open;
      while not vQryGinkoia.Eof do
      begin
        { Creation/Maj des Societes }
        vGroupPump := ADossier.GroupPumpByID[vQryGinkoia.FieldByName('GCP_ID').AsInteger];
        if vGroupPump = nil then
        begin
          vGroupPump := TGroupPump.Create(nil);
          vGroupPump.ADossier := ADossier;
        end;

        vGroupPump.GCP_ID := vQryGinkoia.FieldByName('GCP_ID').AsInteger;
        vGroupPump.GCP_NOM := vQryGinkoia.FieldByName('GCP_NOM').AsString;
        ADossier.AppendGroupPump(vGroupPump);

        vQryGinkoia.Next;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.LoadListGrpToDossier : ' + E.Message);
    end;
  finally
    if vQryGinkoia <> nil then
      FreeAndNil(vQryGinkoia);
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
  end;
end;

procedure TMaintenanceCtrl.LoadListJetonPerEmet;
var
  vEmet: TEmetteur;
  vDos: TDossier;
  vQry: TFDQuery;
begin
  vDos := nil;
  try
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Append('SELECT DOSS_ID, EMET_ID, DOSS_DATABASE, EMET_NOM, EMET_JETON, EMET_TYPEREPLICATION');
    vQry.SQL.Append('FROM DOSSIER JOIN EMETTEUR ON DOSS_ID = EMET_DOSSID');
    vQry.SQL.Append('WHERE DOSS_ID <> 0');
    vQry.SQL.Append('ORDER BY DOSS_DATABASE');
    vQry.Open;

    while not vQry.Eof do
    begin
      if (vDos = nil) or (vQry.FieldByName('DOSS_ID').AsInteger <> vDos.DOSS_ID) then
        vDos := DossierByID[vQry.FieldByName('DOSS_ID').AsInteger];

      { Dossier }
      if vDos = nil then
      begin
        vDos := TDossier.Create(nil);
        vDos.DOSS_ID := vQry.FieldByName('DOSS_ID').AsInteger;
        vDos.DOSS_DATABASE := vQry.FieldByName('DOSS_DATABASE').AsString;
        FListDos.Add(vDos);
      end;

      { Emetteur }
      vEmet := EmetteurByID[vQry.FieldByName('EMET_ID').AsInteger];
      if vEmet = nil then
      begin
        vEmet := TEmetteur.Create(nil);
        vEmet.EMET_ID := vQry.FieldByName('EMET_ID').AsInteger;
        vEmet.EMET_NOM := vQry.FieldByName('EMET_NOM').AsString;
        vEmet.EMET_JETON := vQry.FieldByName('EMET_JETON').AsInteger;
        vEmet.EMET_TYPEREPLICATION := vQry.FieldByName('EMET_TYPEREPLICATION').AsString;
        if vDos <> nil then
        begin
          vEmet.ADossier := vDos;
          vDos.AppendEmetteur(vEmet);
        end;

        FListEmet.Add(vEmet);
      end;

      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.LoadListModulePerMag;
var
  vDos: TDossier;
  vMdl: TModule;
  vMag: TMagasin;
  vQry: TFDQuery;
begin
  try
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := cSql_S_LoadListModulePerMag;
    vQry.Open;

    while not vQry.Eof do
    begin
      { Dossier }
      vDos := DossierByID[vQry.FieldByName('DOSS_ID').AsInteger];
      if vDos = nil then
      begin
        vDos := TDossier.Create(nil);
        vDos.DOSS_ID := vQry.FieldByName('DOSS_ID').AsInteger;
        vDos.DOSS_DATABASE := vQry.FieldByName('DOSS_DATABASE').AsString;
        vDos.AServeur := ServeurByID[vQry.FieldByName('DOSS_SERVID').AsInteger];
        vDos.AGroupe := GroupeByID[vQry.FieldByName('DOSS_GROUID').AsInteger];
        FListDos.Add(vDos);
      end;

      while (not vQry.Eof) and (vQry.FieldByName('DOSS_ID').AsInteger = vDos.DOSS_ID) do
      begin

        { Module }
        vMdl := ModuleByID[vQry.FieldByName('MODU_ID').AsInteger];
        if vMdl = nil then
        begin
          vMdl := TModule.Create(nil);
          vMdl.MODU_ID := vQry.FieldByName('MODU_ID').AsInteger;
          vMdl.MODU_NOM := vQry.FieldByName('MODU_NOM').AsString;
          vMdl.MODU_COMMENT := vQry.FieldByName('MODU_COMMENT').AsString;
          FListMod.Add(vMdl);
        end;

        { Magasin }
        vMag := MagasinByID[vQry.FieldByName('MAGA_ID').AsInteger];
        if vMag = nil then
        begin
          vMag := TMagasin.Create(nil);
          vMag.MAGA_DOSSID := vQry.FieldByName('DOSS_ID').AsInteger;
          vMag.MAGA_ID := vQry.FieldByName('MAGA_ID').AsInteger;
          vMag.MAGA_MAGID_GINKOIA := vQry.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
          vMag.MAGA_NOM := vQry.FieldByName('MAGA_NOM').AsString;
          vMag.ADossier := vDos;
          FListMag.Add(vMag);
        end;

        { Ajout du module au magasin }
        if vMdl <> nil then
          vMag.AppendMdl(vMdl);

        vQry.Next;
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.LoadListSteMagPosteToDossier(const ADossier: TDossier);
var
  vSoc: TSociete;
  vMag: TMagasin;
  vPoste: TPoste;
  iPosId, VersionInt: integer;
  vdmGINKOIA: TdmGINKOIA;
  vQryGinkoia: TFDQuery;
begin
  vdmGINKOIA := nil;
  vQryGinkoia := nil;
  try
    try
      if ADossier.DOSS_CHEMIN = '' then
        Raise Exception.Create(SM_PathDBMissing.AMessage);

      vdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);
      vQryGinkoia := vdmGINKOIA.GetNewQry;

      // on vérifie si on est en version > à 16 pour savoir si on récupère le champ mag_basid ou pas
      VersionInt := dmMaintenance.VersionStringToInt(ADossier.VERS_VERSION);

      if ADossier.VERS_VERSION > cVersionRef then
      begin
        if VersionInt >= 16 then
          vQryGinkoia.SQL.Text := cSql_S_LoadListSteMagPosteToDossier_after_V16
        else
          vQryGinkoia.SQL.Text := cSql_S_LoadListSteMagPosteToDossier_NewVersion
      end
      else
        vQryGinkoia.SQL.Text := cSql_S_LoadListSteMagPosteToDossier;

      vQryGinkoia.Open;
      while not(vQryGinkoia.Eof) do
      begin
        { Creation/Maj des Societes }
        vSoc := ADossier.SocieteByID[vQryGinkoia.FieldByName('SOC_ID').AsInteger];
        if vSoc = nil then
        begin
          vSoc := TSociete.Create(nil);
          vSoc.ADossier := ADossier;
        end;

        vSoc.SOC_ID := vQryGinkoia.FieldByName('SOC_ID').AsInteger;
        vSoc.SOC_NOM := vQryGinkoia.FieldByName('SOC_NOM').AsString;
        vSoc.SOC_CLOTURE := vQryGinkoia.FieldByName('SOC_CLOTURE').AsDateTime;
        vSoc.SOC_SSID := vQryGinkoia.FieldByName('SOC_SSID').AsInteger;
        ADossier.AppendSociete(vSoc);

        while (not vQryGinkoia.Eof) and (vQryGinkoia.FieldByName('SOC_ID').AsInteger = vSoc.SOC_ID) do
        begin
          vMag := MagasinByMAGA_MAGID_GINKOIA[vQryGinkoia.FieldByName('MAG_ID').AsInteger, ADossier.DOSS_ID];
          if vMag <> nil then
          begin
            vMag.MAG_IDENT := vQryGinkoia.FieldByName('MAG_IDENT').AsString;
            vMag.MAG_NATURE := vQryGinkoia.FieldByName('MAG_NATURE').AsInteger;
            vMag.MAG_SS := vQryGinkoia.FieldByName('MAG_SS').AsInteger;
            vMag.MAGA_CODEADH := vQryGinkoia.FieldByName('MAG_CODEADH').AsString;
            vMag.MAGA_BASID := 0;

            if ADossier.VERS_VERSION > cVersionRef then
            begin
              vMag.MPU_GCPID := vQryGinkoia.FieldByName('MPU_GCPID').AsInteger;

              if VersionInt >= 16 then
                vMag.MAGA_BASID := vQryGinkoia.FieldByName('MAG_BASID').AsInteger;
            end
            else
              vMag.MPU_GCPID := 0;

            vMag.ASociete := vSoc;

            { Association des Magasins aux Dossiers et Societes }
            ADossier.AppendMag(vMag);
            vSoc.AppendMag(vMag);

            while (not vQryGinkoia.Eof) and (vQryGinkoia.FieldByName('MAG_ID').AsInteger = vMag.MAGA_MAGID_GINKOIA) do
            begin
              iPosId := vQryGinkoia.FieldByName('POS_ID').AsInteger;
              if iPosId > 0 then
              begin
                { Creation/Maj des Postes }
                vPoste := PosteByPOST_MAGAID[vMag.MAGA_ID, iPosId];
                if vPoste = nil then
                begin
                  vPoste := TPoste.Create(nil);
                  vPoste.AMagasin := vMag;
                end;

                vPoste.POST_POSID := iPosId;
                vPoste.POST_NOM := vQryGinkoia.FieldByName('POS_NOM').AsString;
                vPoste.POST_INFO := vQryGinkoia.FieldByName('POS_INFO').AsString;
                vPoste.POST_MAGID := vQryGinkoia.FieldByName('POS_MAGID').AsInteger;
                vPoste.POST_COMPTA := vQryGinkoia.FieldByName('POS_COMPTA').AsString;

                vMag.AppendPoste(vPoste);
              end;

              vQryGinkoia.Next;
            end;
          end
          else
            vQryGinkoia.Next;
        end;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.LoadListSteMagPosteToDossier : ' + E.Message);
    end;
  finally
    if vQryGinkoia <> nil then
      FreeAndNil(vQryGinkoia);
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
  end;
end;

procedure TMaintenanceCtrl.PriorityOrdreSplittageLog(const ANOSPLIT: integer; const APriorityOrdre: TPriorityOrdre);
var
  vQry: TFDQuery;
  vGnkSplittageLogCurr, vGnkSplittageLog: TGnkSplittageLog;
begin
  vGnkSplittageLog := nil;
  try
    try
      vQry := dmMaintenance.GetNewQry;

      vGnkSplittageLogCurr := GetSplittageLog(ANOSPLIT);
      if vGnkSplittageLogCurr.SPLI_NOSPLIT = 0 then
        Exit;

      vQry.SQL.Text := 'SELECT SPLI_ORDRE, SPLI_NOSPLIT FROM SPLITTAGE_LOG WHERE SPLI_ORDRE=:PORDRE AND SPLI_STARTED = 0';

      case APriorityOrdre of
        poUp:
          begin
            vQry.ParamByName('PORDRE').AsInteger := vGnkSplittageLogCurr.SPLI_ORDRE - 1;
            vQry.Open;

            if not vQry.Eof then
            begin
              vGnkSplittageLog := GetSplittageLog(vQry.FieldByName('SPLI_NOSPLIT').AsInteger);
              vGnkSplittageLog.SPLI_ORDRE := vGnkSplittageLog.SPLI_ORDRE + 1;
              vGnkSplittageLog.MAJ;
              vGnkSplittageLogCurr.SPLI_ORDRE := vGnkSplittageLogCurr.SPLI_ORDRE - 1;
              vGnkSplittageLogCurr.MAJ;
            end;
          end;
        poDown:
          begin
            vQry.ParamByName('PORDRE').AsInteger := vGnkSplittageLogCurr.SPLI_ORDRE + 1;
            vQry.Open;

            if not vQry.Eof then
            begin
              vGnkSplittageLog := GetSplittageLog(vQry.FieldByName('SPLI_NOSPLIT').AsInteger);
              vGnkSplittageLog.SPLI_ORDRE := vGnkSplittageLog.SPLI_ORDRE - 1;
              vGnkSplittageLog.MAJ;
              vGnkSplittageLogCurr.SPLI_ORDRE := vGnkSplittageLogCurr.SPLI_ORDRE + 1;
              vGnkSplittageLogCurr.MAJ;
            end;
          end;
      end;
    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.PriorityOrdreSplittageLog : ' + E.Message);
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vGnkSplittageLogCurr);
    if vGnkSplittageLog <> nil then
      FreeAndNil(vGnkSplittageLog);
  end;
end;

{ ------------------------------ Faire un Split de EASY ------------------------- }
procedure TMaintenanceCtrl.SplitEASY(const AEmetteur: TEmetteur; const ANOSPLIT: integer);
var
  v: integer;
begin
  // vResultProcess:= ExecAndWaitProcess();
  // Faire le splitEASY....
  // Lancer juste la commande ....
  v := 1;

  // ---------------------------------------------------------------------------
end;

{ ===============================================================================
  procedure    : RunRecupBase
  Description  : permet d'effectuer les traitements de recuperation ou de splittage
  suivant le type "TYPESPLIT".
  =============================================================================== }
procedure TMaintenanceCtrl.RunRecupBase(const AEmetteur: TEmetteur; const ANOSPLIT: integer);
Const
  cProcessAvorted = ' - Erreur : Processus avorté. ';
  cProcessAvorteFileNotFound = cProcessAvorted + 'Le fichier %s est introuvable.' + cRC + 'Dans %s';
  cProcessStartCopyXml = ' - Ok : Processus de copie en cours du fichier %s.' + cRC + 'Dans %s';
  cProcessEndCopyXml = ' - Ok : Processus de copie teminé du fichier %s.' + cRC + 'Dans %s';
  cProcessStartMAJXml = ' - Ok : Processus de mise à jour en cours du fichier %s.' + cRC + 'Dans %s';
  cProcessEndMAJXml = ' - Ok : Processus de mise à jour terminé du fichier %s.' + cRC + 'Dans %s';
  cProcessMAJIDGenerator = ' - Ok : Processus de mise à jour du IDGENERATOR.';
  cProcessEndIDGenerator = ' - Ok : Processus de mise à jour du IDGENERATOR terminé.';
  cProcessTerminate = ' - Ok : Processus terminé';
  cProcess_VERS_EAI_NotFound = cProcessAvorted + 'La version EAI est introuvable.';

var
  i, vResultProcess: integer;
  Buffer, vPathSPLIT, vPathTRANS, vPathTech, vPathMAJ, vExecAndWaitProcessMsg: String;
  vPathEmetteurLocal, vPathEmetteurDistant, vPathLocalMaj, vSrc, vDest, vEMET_NOM: String;
  vPathTechVersion: string;
  vDOSS_DATABASE: String;
  vFolderEAI, vUrlDelosQPMAgent, vCmd7z, vParam7z, vPathZip: String;
  vCmdMail: String;
  vSLListFile, vSLLogErr, vSLTraceur, vSLScriptMail: TStringList;
  vGnkSplittageLog: TGnkSplittageLog;
  vSearch: TSearching;
  vdmGINKOIA: TdmGINKOIA;
  vGenReplication: TGnkGenReplication;
  vQry: TFDQuery;

  procedure SetMAJSplittageLog(Const AMsg: String; Const AIsTerminate: integer = 0; Const AIsERROR: integer = 0);
  begin
    vGnkSplittageLog.SPLI_EVENTLOG := GetNowToStr + AMsg;
    vGnkSplittageLog.SPLI_TERMINATE := AIsTerminate;
    if vGnkSplittageLog.SPLI_TERMINATE = 1 then
      vGnkSplittageLog.SPLI_DATEHEUREEND := 0;
    vGnkSplittageLog.SPLI_ERROR := AIsERROR;
    vGnkSplittageLog.MAJ(ukModify);
  end;

begin
  vdmGINKOIA := nil;
  vQry := nil;
  vExecAndWaitProcessMsg := '';
  vGnkSplittageLog := nil;
  vSLListFile := TStringList.Create;
  vSLTraceur := TStringList.Create;
  try
    try
      vSLTraceur.Append(GetNowToStr + 'RunRecupBase Started');

      vPathTech := GWSConfig.Options.Values['PATHLOCALTECH'];
      vPathSPLIT := GWSConfig.Options.Values['PATHLOCALSPLIT'];
      vPathTRANS := GWSConfig.Options.Values['PATHLOCALTRANS'];
      vPathMAJ := GWSConfig.Options.Values['PATHLOCALMAJ'];
      vFolderEAI := '\' + GWSConfig.Options.Values['FOLDERDELOSAGENT'];

      vSLTraceur.Append(GetNowToStr + 'AWSConfig.ServiceFileName = ' + GWSConfig.ServiceFileName + cRC + cRC + 'vPathTech = ' + vPathTech + cRC +
        'vPathSPLIT = ' + vPathSPLIT + cRC + 'vPathTRANS = ' + vPathTRANS + cRC + 'vPathMAJ = ' + vPathMAJ);

      { Recuperation de l'objet responsable de la journalisation du processus }
      vGnkSplittageLog := GMaintenanceCtrl.GetSplittageLog(ANOSPLIT);
      vGnkSplittageLog.SPLI_DATEHEURESTART := Now;
      vGnkSplittageLog.SPLI_STARTED := 1;
      vGnkSplittageLog.SPLI_EVENTLOG := GetNowToStr + '*** Récupération de base en cours ***';
      vGnkSplittageLog.SetStart;

      vSLTraceur.Append(GetNowToStr + 'GnkSplittageLog.SetStart');

      { Construction du path local ( D:\TECH\SPLIT\Sport2000\MERCIER\SERVEUR_LA-NORMA_000400_PORTAZ }
      vPathEmetteurLocal := GetPathEmetteur(AEmetteur, vPathSPLIT);
      vSLTraceur.Append(GetNowToStr + 'vPathEmetteurLocal = ' + vPathEmetteurLocal);

      if DirectoryExists(vPathEmetteurLocal) then
        DeleteDirectory(vPathEmetteurLocal);

      { Folder DATA }
      ForceDirectories(vPathEmetteurLocal + cFolderDATA);
      vSLTraceur.Append(GetNowToStr + 'ForceDirectories = ' + vPathEmetteurLocal + cFolderDATA);

      { Folder EAI }
      ForceDirectories(vPathEmetteurLocal + vFolderEAI);
      vSLTraceur.Append(GetNowToStr + 'ForceDirectories = ' + vPathEmetteurLocal + vFolderEAI);

      { Construction du path distant ( \\GSA-LAME3\EAI\Sport2000\MERCIER\DATA }
{$IFDEF WAD}
      vPathEmetteurDistant := ExcludeTrailingBackslash(ExtractFilePath(AEmetteur.ADossier.DOSS_CHEMIN));
{$ELSE}
      vPathEmetteurDistant := DOSS_CHEMINToUNC(AEmetteur.ADossier.AServeur.SERV_NOM, AEmetteur.ADossier.DOSS_CHEMIN);
{$ENDIF}
      { Construction de l'url DelosQPMAgent }
      // if CompareVersion(AEMETTEUR.AVersion.VER_VERSION, cVersionRef) = 1 then
      // vUrlDelosQPMAgent:= Format(cUrlDelosQPMAgentV_DOSSIERS, [AEMETTEUR.ADossier.AServeur.SRV_IP,
      // AEMETTEUR.AVersion.VERS_EAI])
      // else
      // vUrlDelosQPMAgent:= Format(cUrlDelosQPMAgent, [AEMETTEUR.ADossier.AServeur.SRV_IP,
      // AEMETTEUR.AVersion.VERS_EAI]);

      vSLTraceur.Append(GetNowToStr + 'vPathEmetteurDistant = ' + vPathEmetteurDistant);

      // vPathEmetteurDistant:= 'C:\DEV\bases_clients\boileau\data'; //--> Debug

      { ***************************** Splittage ****************************** }

      if vGnkSplittageLog.SPLI_TYPESPLIT = cTypeSplit[1] then
      begin
        vPathLocalMaj := vPathMAJ + '\' + AEmetteur.AVersion.VERS_NOMVERSION;
        vSLTraceur.Append(GetNowToStr + 'vPathLocalMaj = ' + vPathLocalMaj);

        vSearch := TSearching.Create(GWSConfig.ServiceFileName);
        try
          vSearch.Searching(shortstring(vPathLocalMaj), '*.*', True);
          if vSearch.NbFilesFound = 0 then
            SetMAJSplittageLog('- Erreur : Les fichiers de splittage sont introuvable dans ' + vPathLocalMaj, 0, 1);

          SetMAJSplittageLog('- Ok : Copie des fichiers du splittage en cours, depuis : ' + vPathLocalMaj);
          for i := Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
          begin
            if vSearch.TabInfoSearch[i].PathAndName <> '' then
            begin
              Buffer := vSearch.TabInfoSearch[i].PathFolder;
              Delete(Buffer, 1, Length(vPathLocalMaj));
              Buffer := vPathEmetteurLocal + Buffer;
              if not DirectoryExists(Buffer) then
                ForceDirectories(Buffer);

              vSrc := string(vSearch.TabInfoSearch[i].PathAndName);
              vDest := Buffer + '\' + vSearch.TabInfoSearch[i].Name;

              CopyFile(PChar(vSrc), PChar(vDest), False);

              vSLListFile.Append(vDest);
            end;
          end;
          SetMAJSplittageLog('- Ok : Copie des fichiers du splittage terminée, dans : ' + vPathEmetteurLocal);
        finally
          FreeAndNil(vSearch);
        end;
      end;

      { ***************************** Copie des fichiers Tech Version ****************************** }

      if vGnkSplittageLog.SPLI_TYPESPLIT = cTypeSplit[1] then
      begin
        vPathTechVersion := IncludeTrailingBackslash(vPathTech + '\' + AEmetteur.AVersion.VERS_EAI);
        vSLTraceur.Append(GetNowToStr + 'vPathTechVersion = ' + vPathTechVersion);

        vSearch := TSearching.Create(GWSConfig.ServiceFileName);
        try
          vSearch.Searching(shortstring(vPathTechVersion), '*.*', True);
          if vSearch.NbFilesFound = 0 then
            SetMAJSplittageLog('- Erreur : Les fichiers Tech Version sont introuvable dans ' + vPathTechVersion, 0, 1);

          SetMAJSplittageLog('- Ok : Copie des fichiers Tech Version en cours, depuis : ' + vPathTechVersion);
          for i := Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
          begin
            if vSearch.TabInfoSearch[i].PathAndName <> '' then
            begin
              Buffer := vSearch.TabInfoSearch[i].PathFolder;
              Delete(Buffer, 1, Length(vPathLocalMaj));
              Buffer := IncludeTrailingBackslash(vPathEmetteurLocal + vFolderEAI) + Buffer;
              if not DirectoryExists(Buffer) then
                ForceDirectories(Buffer);

              vSrc := String(vSearch.TabInfoSearch[i].PathAndName);
              vDest := Buffer + '\' + vSearch.TabInfoSearch[i].Name;

              CopyFile(PChar(vSrc), PChar(vDest), False);

              vSLListFile.Append(vDest);
            end;
          end;
          SetMAJSplittageLog('- Ok : Copie des fichiers Tech Version terminée, dans : ' + vPathEmetteurLocal);
        finally
          FreeAndNil(vSearch);
        end;
      end;

      { ***************************** RecupBase ****************************** }

      { Copie du \\vEMET.ADossier.DOSS_CHEMIN\GINKOIA.IB vers \\TECH\SPLIT\DOSS_DATABASE\EMET_NOM\DATA }
      vSrc := IncludeTrailingBackslash(vPathEmetteurDistant) + cDB_FileName_GINKOIA;
      if not FileExists(vSrc) then
      begin
        SetMAJSplittageLog(Format(cProcessAvorteFileNotFound, [cDB_FileName_GINKOIA, vPathEmetteurDistant]), 0, 1);
        Exit;
      end;

      vDest := vPathEmetteurLocal + IncludeTrailingBackslash(cFolderDATA) + cDB_FileName_GINKOIA;
      SetMAJSplittageLog(Format(cProcessStartCopyXml, [vSrc, vDest]));
      CopyFile(PChar(vSrc), PChar(vDest), False); // copie de la base
      SetMAJSplittageLog(Format(cProcessEndCopyXml, [vSrc, vDest]));
      vSLListFile.Append(vDest);

      if (AEmetteur.AVersion = nil) or (AEmetteur.AVersion.VERS_EAI = '') then
      begin
        SetMAJSplittageLog(cProcess_VERS_EAI_NotFound, 0, 1);
        Exit;
      end;

      { ----------------------------- Identification de la base GENPARAMBASE --------------------------- }
      // Ajout par AJ le 19/09/2017, création/maj du genparambase d'identification de base de PROD lors d'un split
      vdmGINKOIA := ConnectToGINKOIA(IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA);
      SetGenParamBaseTypeBase(vdmGINKOIA);
      if not vdmGINKOIA.Transaction.Active then
        vdmGINKOIA.Transaction.StartTransaction;
      vdmGINKOIA.Transaction.Commit;
      vdmGINKOIA.CNX_GINKOIA.Close;
      FreeAndNil(vdmGINKOIA);

      { ----------------------------- IDGENERATEUR --------------------------- }
      SetMAJSplittageLog(cProcessMAJIDGenerator);
      vdmGINKOIA := ConnectToGINKOIA(IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA);
      vQry := vdmGINKOIA.GetNewQry;
      vQry.SQL.Text := 'UPDATE GENPARAMBASE SET PAR_STRING =:PPAR_STRING WHERE PAR_NOM = ''IDGENERATEUR''';
      if not vdmGINKOIA.Transaction.Active then
        vdmGINKOIA.Transaction.StartTransaction;
      vQry.ParamByName('PPAR_STRING').AsString := AEmetteur.EMET_IDENT;
      vQry.ExecSQL;
      vdmGINKOIA.Transaction.Commit;
      vdmGINKOIA.CNX_GINKOIA.Close;
      SetMAJSplittageLog(cProcessEndIDGenerator);
      vSLTraceur.Append(GetNowToStr + 'IDGENERATEUR - EMET_IDENT = ' + AEmetteur.EMET_IDENT);

      { ---------------------------------------------------------------------- }
      { Copie des fichiers D:\TECH\[VERS_EAI]\*.xml vers D:\TECH\SPLIT\DOSS_DATABASE\EMET_NOM }
      { ---------------------------------------------------------------------- }

      vSLTraceur.Append(GetNowToStr + 'AEMETTEUR.ADossier.DOSS_ID : ' + IntToStr(AEmetteur.ADossier.DOSS_ID) + ' - AEMETTEUR.LAU_ID = ' +
        IntToStr(AEmetteur.LAU_ID));

      if (AEmetteur.ADossier.DOSS_ID < 1) or (AEmetteur.LAU_ID < 1) then
        Raise Exception.Create(cBadRequest);
      vGenReplication := GetGenReplicationByLauID(AEmetteur.ADossier.DOSS_ID, AEmetteur.LAU_ID);
      if vGenReplication = nil then
        Raise Exception.Create('Replication introuvable.');
      vUrlDelosQPMAgent := vGenReplication.REP_URLDISTANT;
      SetMAJSplittageLog(vUrlDelosQPMAgent);

      { ----------------------------- InitParams.xml -------------------------- }
      vSrc := IncludeTrailingBackslash(vPathTech + '\' + AEmetteur.AVersion.VERS_EAI) + cFileNameInitParams;
      if not FileExists(vSrc) then
      begin
        SetMAJSplittageLog(Format(cProcessAvorteFileNotFound, [cFileNameInitParams, vSrc]), 0, 1);
        Exit;
      end;

      SetMAJSplittageLog(Format(cProcessStartCopyXml, [vSrc, vDest]));
      vDest := IncludeTrailingBackslash(vPathEmetteurLocal + vFolderEAI) + cFileNameInitParams;
      CopyFile(PChar(vSrc), PChar(vDest), False);
      SetMAJSplittageLog(Format(cProcessEndCopyXml, [cFileNameInitParams, vDest]));
      vSLListFile.Append(vDest);

      { Mise à jour du fichier DelosQPMAgent.InitParams.xml }
      SetMAJSplittageLog(Format(cProcessStartMAJXml, [cFileNameInitParams, vDest]));
      if MAJXmlInitParamQPMUrl(ExtractFilePath(vDest), vUrlDelosQPMAgent) then
        SetMAJSplittageLog(Format(cProcessEndMAJXml, [cFileNameInitParams, vDest]))
      else
      begin
        SetMAJSplittageLog(cProcessAvorted, 0, 1);
        Exit;
      end;

      { ----------------------------- DataSources.xml -------------------------- }
      vSrc := IncludeTrailingBackslash(vPathTech + '\' + AEmetteur.AVersion.VERS_EAI) + cFileNameDataSources;
      if not FileExists(vSrc) then
      begin
        SetMAJSplittageLog(Format(cProcessAvorteFileNotFound, [cFileNameDataSources, vSrc]), 0, 1);
        Exit;
      end;

      SetMAJSplittageLog(Format(cProcessStartCopyXml, [vSrc, vDest]));
      vDest := IncludeTrailingBackslash(vPathEmetteurLocal + vFolderEAI) + cFileNameDataSources;
      CopyFile(PChar(vSrc), PChar(vDest), False);
      SetMAJSplittageLog(Format(cProcessEndCopyXml, [cFileNameDataSources, vDest]));
      vSLListFile.Append(vDest);

      if vdmGINKOIA <> nil then
        FreeAndNil(vdmGINKOIA);

      vdmGINKOIA := ConnectToGINKOIA(IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA);
      vQry := vdmGINKOIA.GetNewQry;
      vQry.SQL.Text := 'SELECT REP_PLACEBASE ' + cRC + 'FROM GENREPLICATION ' + cRC + 'JOIN K ON (K_ID = REP_ID AND K_ENABLED = 1) ' + cRC +
        'JOIN GENLAUNCH ON REP_LAUID = LAU_ID ' + cRC + 'JOIN GENBASES ON LAU_BASID = BAS_ID ' + cRC + 'WHERE BAS_GUID = :PBASGUID';
      if not vdmGINKOIA.Transaction.Active then
        vdmGINKOIA.Transaction.StartTransaction;
      vQry.ParamByName('PBASGUID').AsString := AEmetteur.EMET_GUID;
      vQry.Open;

      { Mise à jour du fichier DelosQPMAgent.DataSources.xml }
      SetMAJSplittageLog(Format(cProcessStartMAJXml, [cFileNameDataSources, vDest]));
      if MAJXmlDataSources(ExtractFilePath(vDest), '', nil, vQry.FieldByName('REP_PLACEBASE').AsString) then
        SetMAJSplittageLog(Format(cProcessEndMAJXml, [cFileNameDataSources, vDest]))
      else
      begin
        SetMAJSplittageLog(cProcessAvorted, 0, 1);
        Exit;
      end;
      vdmGINKOIA.Transaction.Commit;
      vdmGINKOIA.CNX_GINKOIA.Close;
      { ----------------------------- Providers.xml --------------------------- }
      vSrc := IncludeTrailingBackslash(vPathTech + '\' + AEmetteur.AVersion.VERS_EAI) + cFileNameProviders;
      if not FileExists(vSrc) then
      begin
        SetMAJSplittageLog(Format(cProcessAvorteFileNotFound, [cFileNameProviders, vSrc]), 0, 1);
        Exit;
      end;

      vDest := IncludeTrailingBackslash(vPathEmetteurLocal + vFolderEAI) + cFileNameProviders;
      SetMAJSplittageLog(Format(cProcessStartCopyXml, [vSrc, vDest]));
      CopyFile(PChar(vSrc), PChar(vDest), False);
      SetMAJSplittageLog(Format(cProcessEndCopyXml, [cFileNameProviders, vDest]));
      vSLListFile.Append(vDest);

      { Mise à jour du fichier DelosQPMAgent.Providers.xml }
      SetMAJSplittageLog(Format(cProcessStartMAJXml, [cFileNameProviders, vDest]));
      vDOSS_DATABASE := AEmetteur.ADossier.DOSS_DATABASE;
      vEMET_NOM := AEmetteur.EMET_NOM;
      SetMAJSplittageLog('Providers.xml - DOSS_DATABASE = ' + vDOSS_DATABASE);
      SetMAJSplittageLog('Providers.xml - EMET_NOM = ' + vEMET_NOM);
      SetMAJSplittageLog('Providers.xml - vDest = ' + vDest);
      if MAJXmlProviders(ExtractFilePath(vDest), vUrlDelosQPMAgent, vDOSS_DATABASE, vEMET_NOM) then
        SetMAJSplittageLog(Format(cProcessEndMAJXml, [cFileNameProviders, vDest]))
      else
      begin
        SetMAJSplittageLog(cProcessAvorted, 0, 1);
        Exit;
      end;

      { --------------------------- Subscriptions.xml ------------------------- }
      vSrc := IncludeTrailingBackslash(vPathTech + '\' + AEmetteur.AVersion.VERS_EAI) + cFileNameSubscriptions;
      if not FileExists(vSrc) then
      begin
        SetMAJSplittageLog(Format(cProcessAvorteFileNotFound, [cFileNameSubscriptions, vSrc]), 0, 1);
        Exit;
      end;

      vDest := IncludeTrailingBackslash(vPathEmetteurLocal + vFolderEAI) + cFileNameSubscriptions;
      SetMAJSplittageLog(Format(cProcessStartCopyXml, [vSrc, vDest]));
      CopyFile(PChar(vSrc), PChar(vDest), False);
      SetMAJSplittageLog(Format(cProcessEndCopyXml, [cFileNameSubscriptions, vDest]));
      vSLListFile.Append(vDest);

      { Mise à jour du fichier DelosQPMAgent.Subscriptions.xml }
      SetMAJSplittageLog(Format(cProcessStartMAJXml, [cFileNameSubscriptions, vDest]));
      vDOSS_DATABASE := AEmetteur.ADossier.DOSS_DATABASE;
      vEMET_NOM := AEmetteur.EMET_NOM;
      SetMAJSplittageLog('Subscriptions.xml - DOSS_DATABASE = ' + vDOSS_DATABASE);
      SetMAJSplittageLog('Subscriptions.xml - EMET_NOM = ' + vEMET_NOM);
      SetMAJSplittageLog('Subscriptions.xml - vDest = ' + vDest);
      if MAJXmlSubscriptions(ExtractFilePath(vDest), vUrlDelosQPMAgent, vDOSS_DATABASE, vEMET_NOM) then
        SetMAJSplittageLog(Format(cProcessEndMAJXml, [cFileNameSubscriptions, vDest]))
      else
      begin
        SetMAJSplittageLog(cProcessAvorted, 0, 1);
        Exit;
      end;

      { ----------------- Lancement l'application RecupBase.exe -------------- }
      SetMAJSplittageLog('- Ok : Processus de mise à jour de la base et des fichiers XML en cours. (RecupBase.exe)');
      SetMAJSplittageLog(GWSConfig.ServicePath + 'RecupBase.exe');
      SetMAJSplittageLog(' AUTO="' + IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA + '"');

      vResultProcess := ExecAndWaitProcess(GWSConfig.ServicePath + 'RecupBase.exe',
        ' AUTO="' + IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA + '"', '', vExecAndWaitProcessMsg);

      if vResultProcess = 0 then
        SetMAJSplittageLog('- Ok : Processus de mise à jour de la base et des fichiers XML terminé. (RecupBase.exe)')
      else
      begin
        vSLLogErr := TStringList.Create;
        try
          Buffer := GWSConfig.ServicePath + '\' + IntToStr(vResultProcess) + '.log';
          if FileExists(Buffer) then
            vSLLogErr.LoadFromFile(Buffer);

          SetMAJSplittageLog('- Erreur : Processus de mise à jour de la base et des fichiers XML.' + cRC + 'Info : ' + vExecAndWaitProcessMsg + cRC +
            vSLLogErr.Text, 0, 1);

          Exit;

        finally
          FreeAndNil(vSLLogErr);
        end;
      end;

      { --------------- Suppression de la base si besoin ---------------------- }
      if vGnkSplittageLog.SPLI_BASE = 0 then // Pas besoin de base pour ce split.
      begin
        SetMAJSplittageLog('- Ok : Processus de suppression de la base de données en cours.');
        if FileExists(IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA) then
        begin
          if DeleteFile(IncludeTrailingBackslash(vPathEmetteurLocal + cFolderDATA) + cDB_FileName_GINKOIA) then
            SetMAJSplittageLog('- Ok : Base de données supprimée.')
          else
            SetMAJSplittageLog('- Ko : Problème à la suppression.');
        end
        else
        begin
          SetMAJSplittageLog('- Ko : Le fichier de la base de données est inexistant.');
        end;
      end;

      { --------------- Creation du zip des fichiers du dossier -------------- }
      // \\TECH\SPLIT\DOSS_DATABASE\EMET_NOM et le copier dans \\Tranferts\Bases
      SetMAJSplittageLog('- Ok : Processus de compression des données en cours.');
      SetCurrentDir(GWSConfig.ServicePath);

      // Suppression du fichier si déjà existant
      vPathZip := vPathTRANS + '\' + AEmetteur.EMET_NOM + '.Zip';
      if FileExists(vPathZip) then
      begin
        SetMAJSplittageLog('- Ok : Suppression du fichier : ' + vPathZip + ' déjà présent sur le serveur');
        DeleteFileW(PWideChar(vPathZip));
      end;

      vCmd7z := '"' + AEmetteur.ADossier.AServeur.SERV_SEVENZIP + '\7z"';
      vParam7z := ' a "' + vPathZip + '"';

      if vGnkSplittageLog.SPLI_TYPESPLIT = cTypeSplit[0] then
      begin
        for i := 0 to vSLListFile.Count - 1 do
          vParam7z := vParam7z + ' "' + vSLListFile.Strings[i] + '"'; // RecupBase
      end
      else
        vParam7z := vParam7z + ' "' + vPathEmetteurLocal + '\*.*" -r'; // Splittage

      vParam7z := vParam7z + ' -p1082'; // Ajout du mot de passe

      SetMAJSplittageLog('- Ok : Chemin de la commande 7z : ' + vCmd7z);
      SetMAJSplittageLog('- Ok : Paramètres pour la commande 7z : ' + vParam7z);

      uTool_XE7.ExecAndWaitProcess(vCmd7z, vParam7z, '', vExecAndWaitProcessMsg);

      ForceDirectories(vPathTRANS + '\' + AEmetteur.ADossier.DOSS_DATABASE);

      if FileExists(vPathTRANS + '\' + AEmetteur.ADossier.DOSS_DATABASE + '\' + AEmetteur.EMET_NOM + '.Zip') then
        DeleteFile(vPathTRANS + '\' + AEmetteur.ADossier.DOSS_DATABASE + '\' + AEmetteur.EMET_NOM + '.Zip');

      MoveFileW(PWideChar(vPathZip), PWideChar(vPathTRANS + '\' + AEmetteur.ADossier.DOSS_DATABASE + '\' + AEmetteur.EMET_NOM + '.Zip'));

      SetMAJSplittageLog('- Ok : Processus de compression des données terminé.' + cRC + 'Copié dans ' + vPathTRANS);

      { ----------------------- Processus de néttoyage ----------------------- }
      if vGnkSplittageLog.SPLI_CLEARFILES = 1 then
      begin
        SetMAJSplittageLog('- Ok : Néttoyage en cours du répertoire ' + vPathEmetteurLocal);
        if DirectoryExists(vPathEmetteurLocal) then
          DeleteDirectory(vPathEmetteurLocal);
        SetMAJSplittageLog('- Ok : Néttoyage terminé.');
      end;

      SetMAJSplittageLog('*** Récupération de la base terminé. ***', 1);

      { ----------------------- Envoi du mail de fin ----------------------- }
      try
        if vGnkSplittageLog.SPLI_MAIL = 1 then // Pour ce split ?
        begin
          if dmMaintenance.GetMaintenanceParamInteger(7, 1) = 1 then
          begin
            vCmdMail := '"C:\Migration\SendMail\SendMail.exe" ' + '"' + dmMaintenance.GetMaintenanceParamString(1, 1) + '" ' + // Host
              '"' + dmMaintenance.GetMaintenanceParamString(2, 1) + '" ' + // User
              '"' + dmMaintenance.GetMaintenanceParamString(3, 1) + '" ' + // Password
              '"' + IntToStr(dmMaintenance.GetMaintenanceParamInteger(4, 1)) + '" ' + // Port
              '"' + dmMaintenance.GetMaintenanceParamString(1, 2) + '" ' + // Dest
              '"' + '[Maintenance] - Splittage termin&eacute; pour l''&eacute;metteur : ' + AEmetteur.EMET_NOM + '" ' + // Subject
              '"' + 'Bonjour, ' + '<BR><BR>' + 'Le split est disponible dans : ' + '<BR>' + dmMaintenance.GetMaintenanceParamString(1, 3) + '\' +
              dmMaintenance.GetMaintenanceParamString(2, 3) + '\' + AEmetteur.ADossier.DOSS_DATABASE + '\' + AEmetteur.EMET_NOM + '.Zip ' + '<BR><BR>'
              + 'Cordialement, ' + '<BR>' + 'Les Ginkoia-Tools"';
            vSLTraceur.Append(GetNowToStr + 'Commande pour l''envoi du Mail : ' + vCmdMail);

            vSLScriptMail := TStringList.Create;
            try
              vSLScriptMail.Add(vCmdMail);
              if FileExists(dmMaintenance.GetMaintenanceParamString(7, 1) + '\SendMail\Mail.bat') then
                DeleteFile(dmMaintenance.GetMaintenanceParamString(7, 1) + '\SendMail\Mail.bat');

              vSLScriptMail.SaveToFile(dmMaintenance.GetMaintenanceParamString(7, 1) + '\SendMail\Mail.bat');

              ExecAndWaitProcess('"' + GWSConfig.ServicePath + 'PsExec.exe"', ' -i ' + dmMaintenance.GetMaintenanceParamString(7, 1) + ' -u ' +
                AEmetteur.ADossier.SERV_USER + ' -p ' + AEmetteur.ADossier.SERV_PASSWORD + ' "C:\Migration\SendMail\Mail.bat"', '',
                vExecAndWaitProcessMsg);

            finally
              vSLScriptMail.Free;
            end;
          end
          else
          begin
            SendMailLite(dmMaintenance.GetMaintenanceParamString(1, 2), '[Maintenance] - Splittage terminé pour l''émetteur : ' + AEmetteur.EMET_NOM,
              // Subject
              'Bonjour,' + cRC + cRC + 'Le split est disponible dans : ' + 'http://' + dmMaintenance.GetMaintenanceParamString(1, 3) + '/' +
              dmMaintenance.GetMaintenanceParamString(2, 3) + '/' + AEmetteur.ADossier.DOSS_DATABASE + '/' + AEmetteur.EMET_NOM + '.Zip' + cRC + cRC +
              'Cordialement,' + cRC + 'Les Ginkoia-Tools', dmMaintenance.GetMaintenanceParamString(1, 1), // Host
              dmMaintenance.GetMaintenanceParamString(2, 1), // User
              dmMaintenance.GetMaintenanceParamString(3, 1), // Password
              dmMaintenance.GetMaintenanceParamInteger(4, 1)); // Port
          end;
        end;
      except
        on E: Exception do
        begin
          vSLTraceur.Append(GetNowToStr + 'Erreur à l''envoi du Mail : ' + E.Message);
        end;
      end;
    except
      on E: Exception do
      begin
        SetMAJSplittageLog('- Erreur : ' + E.Message, 0, 1);
      end;
    end;

  finally
    GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
    FreeAndNil(vSLListFile);
    FreeAndNil(vSLTraceur);
    if vGnkSplittageLog <> nil then
      FreeAndNil(vGnkSplittageLog);
    if vdmGINKOIA <> nil then
      FreeAndNil(vdmGINKOIA);
    if vQry <> nil then
      FreeAndNil(vQry);
  end;
end;

procedure TMaintenanceCtrl.SetActiveThrdCtrlSplittage(const AActivate: integer);
begin
  dmMaintenance.SetMaintenanceParamInteger(2, 2, AActivate);
  StartThrdCtrlSplittage;
end;

procedure TMaintenanceCtrl.SetValuesEmetteurByGinkoia(const ADmGINKOIA: TdmGINKOIA; const AEmet: TEmetteur);
var
  vCon: TConnexion;
  vdmGINKOIA: TdmGINKOIA;
  vQryGinkoia: TFDQuery;
  vIsFreeDmGINKOIA: Boolean;
begin
  vIsFreeDmGINKOIA := False;
  try
    if ADmGINKOIA = nil then
    begin
      vIsFreeDmGINKOIA := True;
      vdmGINKOIA := GetNewdmGINKOIAByDOSS_ID(AEmet.EMET_DOSSID);
    end
    else
      vdmGINKOIA := ADmGINKOIA;

    vQryGinkoia := vdmGINKOIA.GetNewQry;
    vQryGinkoia.SQL.Clear;
    vQryGinkoia.SQL.Append('select * from GENBASES');
    vQryGinkoia.SQL.Append('join k on (k_id=bas_id and k_enabled=1)');
    vQryGinkoia.SQL.Append('where (BAS_ID <> 0) and (BAS_GUID = ' + QuotedStr(AEmet.EMET_GUID) + ')');
    vQryGinkoia.Open;
    if not vQryGinkoia.Eof then
    begin
      AEmet.SetValuesByDataSet(vQryGinkoia);

      vQryGinkoia.SQL.Clear;
      vQryGinkoia.SQL.Append('select * from GENLAUNCH');
      vQryGinkoia.SQL.Append('where LAU_BASID = ' + IntToStr(AEmet.BAS_ID));
      vQryGinkoia.Open;
      if not vQryGinkoia.Eof then
      begin
        AEmet.LAU_ID := vQryGinkoia.FieldByName('LAU_ID').AsInteger;
        AEmet.LAU_AUTORUN := vQryGinkoia.FieldByName('LAU_AUTORUN').AsInteger;
        AEmet.LAU_BACK := vQryGinkoia.FieldByName('LAU_BACK').AsInteger;
        AEmet.LAU_BACKTIME := vQryGinkoia.FieldByName('LAU_BACKTIME').AsDateTime;
      end;

      vQryGinkoia.SQL.Clear;
      vQryGinkoia.SQL.Append('select * from GENPARAM');
      vQryGinkoia.SQL.Append('where PRM_INTEGER = ' + IntToStr(AEmet.BAS_ID));
      vQryGinkoia.SQL.Append('and PRM_CODE = 666');
      vQryGinkoia.SQL.Append('and PRM_TYPE = 1999');

      vQryGinkoia.Open;
      if not vQryGinkoia.Eof then
      begin
        AEmet.PRM_ID := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
        AEmet.PRM_POS := vQryGinkoia.FieldByName('PRM_POS').AsInteger;
      end;

      vQryGinkoia.SQL.Clear;
      vQryGinkoia.SQL.Append('Select * From GENPARAM');
      vQryGinkoia.SQL.Append('Join K on (K_ID = PRM_ID and K_ENABLED = 1)');
      vQryGinkoia.SQL.Append('Where PRM_TYPE = 11');
      vQryGinkoia.SQL.Append('And PRM_POS = ' + IntToStr(AEmet.BAS_ID));
      vQryGinkoia.Open;

      while not vQryGinkoia.Eof do
      begin
        case vQryGinkoia.FieldByName('PRM_CODE').AsInteger of
          1:
            begin
              AEmet.RW_PRMID_HEUREDEB := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RW_HEUREDEB := FloatToDateTime(vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat);
            end;
          2:
            begin
              AEmet.RW_PRMID_HEUREFIN := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RW_HEUREFIN := FloatToDateTime(vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat);
            end;
          3:
            begin
              AEmet.RW_PRMID_INTERORDRE := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RW_INTERVALLE := vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat;
              AEmet.RW_ORDRE := vQryGinkoia.FieldByName('PRM_POS').AsInteger;
            end;
          30:
            begin
              AEmet.RTR_PRMID_NBESSAI := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_NBESSAI := vQryGinkoia.FieldByName('PRM_INTEGER').AsInteger;
            end;
          31:
            begin
              AEmet.RTR_PRMID_DELAI := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_DELAI := vQryGinkoia.FieldByName('PRM_INTEGER').AsInteger;
            end;
          32:
            begin
              AEmet.RTR_PRMID_HEUREDEB := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_HEUREDEB := FloatToDateTime(vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat);
            end;
          33:
            begin
              AEmet.RTR_PRMID_HEUREFIN := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_HEUREFIN := FloatToDateTime(vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat);
            end;
          34:
            begin
              AEmet.RTR_PRMID_URL := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_URL := vQryGinkoia.FieldByName('PRM_STRING').AsString;
            end;
          35:
            begin
              AEmet.RTR_PRMID_SENDER := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_SENDER := vQryGinkoia.FieldByName('PRM_STRING').AsString;
            end;
          36:
            begin
              AEmet.RTR_PRMID_DATABASE := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
              AEmet.RTR_DATABASE := vQryGinkoia.FieldByName('PRM_STRING').AsString;
            end;
        end;
        vQryGinkoia.Next;
      end;

      if AEmet.LAU_ID > 0 then
      begin
        vQryGinkoia.SQL.Clear;
        vQryGinkoia.SQL.Append('select * from GENCONNEXION');
        vQryGinkoia.SQL.Append('join k on (k_id=con_id and k_enabled=1)');
        vQryGinkoia.SQL.Append('where CON_LAUID = ' + IntToStr(AEmet.LAU_ID));
        vQryGinkoia.SQL.Append('order by CON_ORDRE');
        vQryGinkoia.Open;
        while not vQryGinkoia.Eof do
        begin
          vCon := AEmet.ConnexionByID[vQryGinkoia.FieldByName('CON_ID').AsInteger];
          if vCon = nil then
            vCon := TConnexion.Create(nil);

          vCon.SetValuesByDataSet(vQryGinkoia, AEmet.EMET_DOSSID, AEmet.EMET_ID);
          vCon.AEmetteur := AEmet;

          AEmet.AppendConnexion(vCon);

          vQryGinkoia.Next;
        end;
      end;
    end;
  finally
    FreeAndNil(vQryGinkoia);
    if vIsFreeDmGINKOIA then
      FreeAndNil(vdmGINKOIA);
  end;
end;

procedure TMaintenanceCtrl.IntializeCtrl;
var
  vSLExcept: TStringList;
  vResultMsg: RStatusMessage;
begin
  InitializeLists;

  FTThrdCtrlSplittage := TThrdCtrlSplittage.Create(True);

  vSLExcept := TStringList.Create;
  try
    try
      SetActiveThrdCtrlSplittage(0);
      LoadListEmetteur(-1, -1, '', False, vResultMsg);

      if vResultMsg.Code < 0 then
      begin
        vSLExcept.Append(vResultMsg.AMessage);
        Exit;
      end;

      StartThrdCtrlSplittage;
    except
      on E: Exception do
      begin
        vSLExcept.Append('TMaintenanceCtrl.IntializeCtrl');
        vSLExcept.Append(E.Message);
        GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TMaintenanceCtrl_IntializeCtrl.Except', vSLExcept,
          GWSConfig.LogException);
      end;
    end;
  finally
    FreeAndNil(vSLExcept);
  end;
end;

function TMaintenanceCtrl.IsSplittageProcessActivate: Boolean;
begin
  Result := (dmMaintenance.GetMaintenanceParamInteger(2, 2) = 0);
end;

function TMaintenanceCtrl.JetonLame(Const ADOSS_ID: integer): string;
var
  sPathDatabase, sAdresseWS, sSenderWS, sDatabaseWS, sAdresse: string;
  vDos: TDossier;
  vEmet: TEmetteur;
  vGenR: TGnkGenReplication;
begin
  Result := 'Début traitement des jetons.';

  vDos := nil;

  if ADOSS_ID > 0 then
  begin
    vDos := GMaintenanceCtrl.DossierByID[ADOSS_ID];
  end;

  if vDos.TokenManager = nil then
  begin
    sPathDatabase := DOSS_CHEMINToUNC(vDos.AServeur.SERV_NOM, vDos.DOSS_CHEMIN);
    if Pos(cDB_FileName_GINKOIA, sPathDatabase) = 0 then
      sPathDatabase := IncludeTrailingBackslash(DOSS_CHEMINToUNC(vDos.AServeur.SERV_NOM, vDos.DOSS_CHEMIN)) + cDB_FileName_GINKOIA;

    if not TFile.Exists(sPathDatabase) then
    begin
      Result := 'La base n''existe pas. Merci de vérifier le chemin.';
    end
    else
    begin
      try
        Delete(sPathDatabase, 1, Pos('\', sPathDatabase)); // SR : Suppression de : \
        Delete(sPathDatabase, 1, Pos('\', sPathDatabase)); // SR : Suppression de : \
        Delete(sPathDatabase, 1, Pos('\', sPathDatabase)); // SR : Suppression de : \
        sPathDatabase := vDos.AServeur.SERV_NOM + ':' + vDos.AServeur.SERV_DOSBDD + '\' + sPathDatabase;

        vDos.TokenManager := TTokenManager.Create;
        vEmet := vDos.EmetteurByIDENT['0'];

        if (vDos.ADmGINKOIA = nil) then
          if (vDos.DOSS_CHEMIN <> '') then
            vDos.ADmGINKOIA := ConnectToGINKOIA(vDos.DOSS_CHEMIN);

        sAdresseWS := vDos.ADmGINKOIA.GetParamString(11, 34, vEmet.BAS_ID); // Adresse du webservice   code = 34
        sSenderWS := vDos.ADmGINKOIA.GetParamString(11, 35, vEmet.BAS_ID); // Sender pour le WebService   code = 35
        sDatabaseWS := vDos.ADmGINKOIA.GetParamString(11, 36, vEmet.BAS_ID);

        if vEmet.LAU_ID = 0 then
          vEmet := vDos.EmetteurByIDENT['1'];

        vGenR := GetGenReplicationByLauID(vDos.DOSS_ID, vEmet.LAU_ID);

        sAdresse := StringReplace(vGenR.REP_URLDISTANT, '/DelosQPMAgent.dll', sAdresseWS, [rfReplaceAll, rfIgnoreCase]);

        vDos.BJeton := vDos.TokenManager.tryGetToken(sAdresse, sDatabaseWS, sSenderWS, 2, 10000);

        vDos.BJeton := vDos.TokenManager.Acquired;

        Result := vDos.TokenManager.GetReasonString;

        if not vDos.BJeton then
        begin
          vDos.TokenManager.Free;
          vDos.TokenManager := nil;
        end;

      except
        on E: Exception do
        begin
          Raise Exception.Create(ClassName + '.SyncBase : ' + E.Message);
          Result := 'Erreur dans SyncBase : ' + E.Message;
        end;
      end;
    end;
  end
  else
  begin
    // Relache le jeton
    try
      vDos.TokenManager.Free;
    finally
      vDos.TokenManager := nil;
      vDos.BJeton := False;
      Result := 'Jeton rendu.';
    end;
  end;
end;

end.

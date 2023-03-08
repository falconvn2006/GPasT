unit dmdClient;

interface

uses
  SysUtils, Classes, DB, DBClient, midaslib;

type
  TdmClient = class(TDataModule)
    CDS_EMETTEUR: TClientDataSet;
    CDS_EMETTEUREMET_ID: TIntegerField;
    CDS_EMETTEUREMET_GUID: TStringField;
    CDS_EMETTEUREMET_NOM: TStringField;
    CDS_EMETTEUREMET_DONNEES: TStringField;
    CDS_EMETTEUREMET_DOSSID: TIntegerField;
    CDS_EMETTEUREMET_INSTALL: TDateTimeField;
    CDS_EMETTEUREMET_MAGID: TIntegerField;
    CDS_EMETTEUREMET_VERSID: TIntegerField;
    CDS_EMETTEUREMET_PATCH: TIntegerField;
    CDS_EMETTEUREMET_VERSION_MAX: TIntegerField;
    CDS_EMETTEUREMET_SPE_PATCH: TIntegerField;
    CDS_EMETTEUREMET_SPE_FAIT: TIntegerField;
    CDS_EMETTEUREMET_BCKOK: TDateTimeField;
    CDS_EMETTEUREMET_DERNBCK: TDateTimeField;
    CDS_EMETTEUREMET_RESBCK: TStringField;
    CDS_EMETTEUREMET_TIERSCEGID: TStringField;
    CDS_EMETTEUREMET_TYPEREPLICATION: TStringField;
    CDS_EMETTEUREMET_NONREPLICATION: TIntegerField;
    CDS_EMETTEUREMET_DEBUTNONREPLICATION: TDateField;
    CDS_EMETTEUREMET_FINNONREPLICATION: TDateField;
    CDS_EMETTEUREMET_SERVEURSECOURS: TIntegerField;
    CDS_EMETTEUREMET_IDENT: TStringField;
    CDS_EMETTEUREMET_JETON: TIntegerField;
    CDS_EMETTEUREMET_PLAGE: TStringField;
    CDS_EMETTEUREMET_H1: TIntegerField;
    CDS_EMETTEUREMET_HEURE1: TDateTimeField;
    CDS_EMETTEUREMET_H2: TIntegerField;
    CDS_EMETTEUREMET_HEURE2: TDateTimeField;
    CDS_EMETTEURStringField: TStringField;
    CDS_EMETTEURStringField2: TStringField;
    CDS_EMETTEURStringField3: TStringField;
    CDS_SRVSECOURS: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    CDS_GENCONNEXION: TClientDataSet;
    CDS_GENCONNEXIONCON_ID: TIntegerField;
    CDS_GENCONNEXIONCON_LAUID: TIntegerField;
    CDS_GENCONNEXIONCON_NOM: TStringField;
    CDS_GENCONNEXIONCON_TEL: TStringField;
    CDS_GENCONNEXIONCON_ORDRE: TIntegerField;
    CDS_SOCMAGPOS: TClientDataSet;
    CDS_SOCMAGPOSSOC_ID: TIntegerField;
    CDS_SOCMAGPOSSOC_NOM: TStringField;
    CDS_SOCMAGPOSMAGA_ID: TIntegerField;
    CDS_SOCMAGPOSMAGA_NOM: TStringField;
    CDS_SOCMAGPOSMAG_SOCID: TIntegerField;
    CDS_SOCMAGPOSSOC_SSID: TIntegerField;
    CDS_SOCMAGPOSMAG_IDENTCOURT: TStringField;
    CDS_SOCMAGPOSMAGA_ENSEIGNE: TStringField;
    CDS_SOCMAGPOSMAG_IDENT: TStringField;
    CDSModuleActif: TClientDataSet;
    CDSModuleActifMODU_NOM: TStringField;
    CDSModuleActifMODU_ID: TIntegerField;
    CDS_SOCMAGPOSSOC_CLOTURE: TDateTimeField;
    CDSModuleActifMAGA_ID: TIntegerField;
    CDSModuleActifMAGA_NOM: TStringField;
    CDS_SOCMAGPOSDOSS_ID: TIntegerField;
    CDSModuleActifDOSS_ID: TIntegerField;
    CDSModuleActifMMAG_EXPDATE: TDateTimeField;
    CDS_SOCMAGPOSMAGA_MAGID_GINKOIA: TIntegerField;
    CDSModuleActifUGG_ID: TIntegerField;
    CDSModuleActifUGM_MAGID: TIntegerField;
    CDSModuleDisponible: TClientDataSet;
    CDSModuleDisponibleDOSS_ID: TIntegerField;
    CDSModuleDisponibleMAGA_ID: TIntegerField;
    CDSModuleDisponibleMAGA_NOM: TStringField;
    CDSModuleDisponibleMODU_ID: TIntegerField;
    CDSModuleDisponibleMODU_NOM: TStringField;
    CDSModuleDisponibleMMAG_EXPDATE: TDateTimeField;
    CDSModuleDisponibleUGG_ID: TIntegerField;
    CDSModuleDisponibleUGM_MAGID: TIntegerField;
    CDS_EMETTEURLAU_AUTORUN: TIntegerField;
    CDS_EMETTEURLAU_BACK: TIntegerField;
    CDS_EMETTEURLAU_BACKTIME: TDateTimeField;
    CDS_EMETTEURPRM_POS: TIntegerField;
    CDS_SOCMAGPOSMAG_NATURE: TIntegerField;
    CDS_SOCMAGPOSMAG_SS: TIntegerField;
    CDS_GENCONNEXIONDOSS_ID: TIntegerField;
    CDS_GENCONNEXIONEMET_ID: TIntegerField;
    CDS_GENCONNEXIONCON_TYPE: TBooleanField;
    CDS_GENREPLICATION: TClientDataSet;
    CDS_GENREPLICATIONREP_ID: TIntegerField;
    CDS_GENREPLICATIONREP_LAUID: TIntegerField;
    CDS_GENREPLICATIONREP_PING: TStringField;
    CDS_GENREPLICATIONREP_PUSH: TStringField;
    CDS_GENREPLICATIONREP_PULL: TStringField;
    CDS_GENREPLICATIONREP_USER: TStringField;
    CDS_GENREPLICATIONREP_PWD: TStringField;
    CDS_GENREPLICATIONREP_ORDRE: TIntegerField;
    CDS_GENREPLICATIONREP_URLLOCAL: TStringField;
    CDS_GENREPLICATIONREP_URLDISTANT: TStringField;
    CDS_GENREPLICATIONREP_PLACEEAI: TStringField;
    CDS_GENREPLICATIONREP_PLACEBASE: TStringField;
    CDS_GENLAUNCH: TClientDataSet;
    CDS_GENLAUNCHLAU_ID: TIntegerField;
    CDS_GENLAUNCHLAU_BASID: TIntegerField;
    CDS_GENLAUNCHLAU_HEURE1: TDateTimeField;
    CDS_GENLAUNCHLAU_H1: TIntegerField;
    CDS_GENLAUNCHLAU_HEURE2: TDateTimeField;
    CDS_GENLAUNCHLAU_H2: TIntegerField;
    CDS_GENLAUNCHLAU_AUTORUN: TIntegerField;
    CDS_GENLAUNCHLAU_BACK: TIntegerField;
    CDS_GENLAUNCHLAU_BACKTIME: TDateTimeField;
    CDS_GENPROVIDERS_D: TClientDataSet;
    CDS_GENPROVIDERS_DPRO_ID: TIntegerField;
    CDS_GENPROVIDERS_DPRO_NOM: TStringField;
    CDS_GENPROVIDERS_DPRO_ORDRE: TIntegerField;
    CDS_GENPROVIDERS_DPRO_LOOP: TIntegerField;
    CDS_GENSUBSCRIBERS_D: TClientDataSet;
    CDS_GENSUBSCRIBERS_DSUB_ID: TIntegerField;
    CDS_GENSUBSCRIBERS_DSUB_NOM: TStringField;
    CDS_GENSUBSCRIBERS_DSUB_ORDRE: TIntegerField;
    CDS_GENSUBSCRIBERS_DSUB_LOOP: TIntegerField;
    CDS_GENREPLICATIONREP_JOUR: TIntegerField;
    CDS_GENPROVIDERS_DGLR_ID: TIntegerField;
    CDS_GENSUBSCRIBERS_DGLR_ID: TIntegerField;
    CDS_EMETTEURRTR_NBESSAI: TIntegerField;
    CDS_EMETTEURRTR_PRMID_NBESSAI: TIntegerField;
    CDS_EMETTEURRTR_PRMID_DELAI: TIntegerField;
    CDS_EMETTEURRTR_DELAI: TIntegerField;
    CDS_EMETTEURRTR_PRMID_HEUREDEB: TIntegerField;
    CDS_EMETTEURRTR_HEUREDEB: TDateTimeField;
    CDS_EMETTEURRTR_PRMID_HEUREFIN: TIntegerField;
    CDS_EMETTEURRTR_HEUREFIN: TDateTimeField;
    CDS_EMETTEURRTR_PRMID_URL: TIntegerField;
    CDS_EMETTEURRTR_URL: TStringField;
    CDS_EMETTEURRTR_PRMID_SENDER: TIntegerField;
    CDS_EMETTEURRTR_SENDER: TStringField;
    CDS_EMETTEURRTR_PRMID_DATABASE: TIntegerField;
    CDS_EMETTEURRTR_DATABASE: TStringField;
    CDS_EMETTEURRW_PRMID_HEUREDEB: TIntegerField;
    CDS_EMETTEURRW_HEUREDEB: TDateTimeField;
    CDS_EMETTEURRW_PRMID_HEUREFIN: TIntegerField;
    CDS_EMETTEURRW_HEUREFIN: TDateTimeField;
    CDS_EMETTEURRW_PRMID_INTERORDRE: TIntegerField;
    CDS_EMETTEURRW_INTERVALLE: TFloatField;
    CDS_EMETTEURRW_ORDRE: TIntegerField;
    CDS_GENREPLICATIONREP_EXEFINREPLIC: TStringField;
    CDS_EMETTEURVERS_VERSION: TStringField;
    CDS_GENREPLICATIONWEB: TClientDataSet;
    IntegerField7: TIntegerField;
    IntegerField8: TIntegerField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    IntegerField9: TIntegerField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    IntegerField10: TIntegerField;
    StringField14: TStringField;
    CDS_EMETTEURLAU_ID: TIntegerField;
    CDS_GENPROVIDERS_T: TClientDataSet;
    IntegerField11: TIntegerField;
    StringField15: TStringField;
    IntegerField12: TIntegerField;
    IntegerField13: TIntegerField;
    IntegerField14: TIntegerField;
    CDS_GENSUBSCRIBERS_T: TClientDataSet;
    IntegerField17: TIntegerField;
    StringField17: TStringField;
    IntegerField18: TIntegerField;
    IntegerField19: TIntegerField;
    IntegerField20: TIntegerField;
    CDS_GENLIAIREPLI: TClientDataSet;
    IntegerField26: TIntegerField;
    IntegerField27: TIntegerField;
    IntegerField28: TIntegerField;
    StringField20: TStringField;
    CDS_GENLIAIREPLIDOSS_ID: TIntegerField;
    CDS_GENREPLICATIONDOSS_ID: TIntegerField;
    CDS_GENREPLICATIONWEBDOSS_ID: TIntegerField;
    CDS_GENLAUNCHDOSS_ID: TIntegerField;
    CDS_GENPROVIDERS_DDOSS_ID: TIntegerField;
    CDS_GENSUBSCRIBERS_DDOSS_ID: TIntegerField;
    CDS_GENPROVIDERS_TDOSS_ID: TIntegerField;
    CDS_GENSUBSCRIBERS_TDOSS_ID: TIntegerField;
    CDSDossier: TClientDataSet;
    CDSDossierDOSS_ID: TIntegerField;
    CDSDossierDOSS_DATABASE: TStringField;
    CDSDossierDOSS_CHEMIN: TStringField;
    CDSDossierDOSS_SERVID: TIntegerField;
    CDSDossierDOSS_GROUID: TIntegerField;
    CDSDossierDOSS_INSTALL: TDateTimeField;
    CDSDossierDOSS_VIP: TIntegerField;
    CDSDossierDOSS_PLATEFORME: TStringField;
    CDSDossierSERV_NOM: TStringField;
    CDSDossierGROU_NOM: TStringField;
    CDSDossierVERS_VERSION: TStringField;
    CDSDossierCHEMIN_BV: TStringField;
    CDS_EMETTEURBAS_GUID: TStringField;
    CDSDossierDOSS_ACTIF: TIntegerField;
    CDS_SOC: TClientDataSet;
    CDS_SOCDOSS_ID: TIntegerField;
    IntegerField21: TIntegerField;
    StringField16: TStringField;
    DateTimeField2: TDateTimeField;
    IntegerField30: TIntegerField;
    CDS_MAG: TClientDataSet;
    CDS_MAGDOSS_ID: TIntegerField;
    CDS_MAGMAGA_ID: TIntegerField;
    CDS_MAGMAG_SOCID: TIntegerField;
    CDS_MAGMAG_IDENT: TStringField;
    CDS_MAGMAGA_ENSEIGNE: TStringField;
    CDS_MAGMAG_IDENTCOURT: TStringField;
    CDS_MAGMAGA_MAGID_GINKOIA: TIntegerField;
    CDS_MAGMAG_SS: TIntegerField;
    CDS_POS: TClientDataSet;
    CDS_POSDOSS_ID: TIntegerField;
    Ds_SOCMAG: TDataSource;
    Ds_MAGPOS: TDataSource;
    CDS_POSMAG_ID: TIntegerField;
    CDS_GrpPump: TClientDataSet;
    CDS_GrpPumpGCP_NOM: TStringField;
    CDS_GrpPumpGCP_ID: TIntegerField;
    CDS_MAGMPU_GCPID: TIntegerField;
    CDS_SOCMAGPOSMPU_GCPID: TIntegerField;
    CDS_MAGACTION: TIntegerField;
    CDS_EMETTEURBAS_NOM: TStringField;
    CDS_SRVSECOURSEMET_DONNEES: TStringField;
    CDS_SRVSECOURSEMET_DOSSID: TIntegerField;
    CDS_SRVSECOURSEMET_INSTALL: TSQLTimeStampField;
    CDS_SRVSECOURSEMET_MAGID: TIntegerField;
    CDS_SRVSECOURSEMET_VERSID: TIntegerField;
    CDS_SRVSECOURSEMET_PATCH: TIntegerField;
    CDS_SRVSECOURSEMET_VERSION_MAX: TIntegerField;
    CDS_SRVSECOURSEMET_SPE_PATCH: TIntegerField;
    CDS_SRVSECOURSEMET_SPE_FAIT: TIntegerField;
    CDS_SRVSECOURSEMET_BCKOK: TSQLTimeStampField;
    CDS_SRVSECOURSEMET_DERNBCK: TSQLTimeStampField;
    CDS_SRVSECOURSEMET_RESBCK: TStringField;
    CDS_SRVSECOURSEMET_TIERSCEGID: TStringField;
    CDS_SRVSECOURSEMET_TYPEREPLICATION: TStringField;
    CDS_SRVSECOURSEMET_NONREPLICATION: TIntegerField;
    CDS_SRVSECOURSEMET_DEBUTNONREPLICATION: TDateField;
    CDS_SRVSECOURSEMET_FINNONREPLICATION: TDateField;
    CDS_SRVSECOURSEMET_SERVEURSECOURS: TIntegerField;
    CDS_SRVSECOURSEMET_IDENT: TStringField;
    CDS_SRVSECOURSEMET_JETON: TIntegerField;
    CDS_SRVSECOURSEMET_PLAGE: TStringField;
    CDS_SRVSECOURSEMET_H1: TIntegerField;
    CDS_SRVSECOURSEMET_HEURE1: TSQLTimeStampField;
    CDS_SRVSECOURSEMET_H2: TIntegerField;
    CDS_SRVSECOURSEMET_HEURE2: TSQLTimeStampField;
    CDS_SRVSECOURSBAS_SENDER: TStringField;
    CDS_SRVSECOURSBAS_CENTRALE: TStringField;
    CDS_SRVSECOURSBAS_NOMPOURNOUS: TStringField;
    CDS_SOCACTION: TIntegerField;
    CDS_POSACTION: TIntegerField;
    CDSDossierBJETON: TBooleanField;
    CDS_MAGMAGA_CODEADH: TStringField;
    CDS_SOCMAGPOSMAGA_CODEADH: TStringField;
    CDS_POSPOST_POSID: TIntegerField;
    CDS_POSPOST_NOM: TStringField;
    CDS_POSPOST_MAGID: TIntegerField;
    CDS_SOCMAGPOSPOST_NOM: TStringField;
    CDS_SOCMAGPOSPOST_MAGID: TIntegerField;
    CDS_SOCMAGPOSPOST_POSID: TIntegerField;
    CDS_SOCMAGPOSPOST_ID: TIntegerField;
    CDSDossierDOSS_EASY: TIntegerField;
    CDS_MAGMAGA_NOM: TStringField;
    CDS_MAGMAG_NATURE: TIntegerField;
    CDS_MAGMAGA_BASID: TIntegerField;
    CDS_SOCMAGPOSMAGA_BASID: TIntegerField;
    CDS_EMETTEUREMET_BASID_GINKOIA: TIntegerField;
    procedure CDS_EMETTEURBeforePost(DataSet: TDataSet);
    procedure CDS_EMETTEURNewRecord(DataSet: TDataSet);
    procedure CDS_SOCMAGPOSNewRecord(DataSet: TDataSet);
    procedure CDS_SOCMAGPOSBeforePost(DataSet: TDataSet);
    procedure CDS_GENCONNEXIONBeforePost(DataSet: TDataSet);
    procedure CDS_GENCONNEXIONNewRecord(DataSet: TDataSet);
    procedure CDS_GENPROVIDERS_DNewRecord(DataSet: TDataSet);
    procedure CDS_GENLIAIREPLINewRecord(DataSet: TDataSet);
    procedure CDS_GENREPLICATIONWEBNewRecord(DataSet: TDataSet);
    procedure CDS_SOCBeforePost(DataSet: TDataSet);
    procedure CDS_MAGBeforePost(DataSet: TDataSet);
    procedure CDS_POSBeforePost(DataSet: TDataSet);
    procedure CDS_SOCNewRecord(DataSet: TDataSet);
    procedure CDS_MAGNewRecord(DataSet: TDataSet);
    procedure CDS_POSNewRecord(DataSet: TDataSet);
    procedure CDS_MAG_MAG_NATUREGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CDS_MAG_MAG_NATURESetText(Sender: TField; const Text: string);
    procedure CDS_MAGMAG_SSGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CDS_GENREPLICATIONNewRecord(DataSet: TDataSet);
  private
    FDOSS_ID: integer;
  public
    property DOSS_ID: integer read FDOSS_ID write FDOSS_ID;

    function GetVersionMajeure(Const AVER_VERSION: String): integer;

    function IndexOfListMAG_NATURE(Const S: String): integer;
    function GetListMAG_NATURE: String;
    function GetIndexByLibelleMAG_NATURE(Const S: String): integer;
    function GetListGrpPump: String;
  end;

var
  dmClient: TdmClient;

implementation

uses uTool, uConst;

{$R *.dfm}

procedure TdmClient.CDS_EMETTEURBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('EMET_H1').IsNull then
    DataSet.FieldByName('EMET_H1').AsInteger:= 0;
  if DataSet.FieldByName('EMET_H2').IsNull then
    DataSet.FieldByName('EMET_H2').AsInteger:= 0;
  if DataSet.FieldByName('EMET_NONREPLICATION').IsNull then
    DataSet.FieldByName('EMET_NONREPLICATION').AsInteger:= 0;
end;

procedure TdmClient.CDS_EMETTEURNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('EMET_ID').AsInteger:= -1;
  DataSet.FieldByName('EMET_H1').AsInteger:= 0;
  DataSet.FieldByName('EMET_H2').AsInteger:= 0;
  DataSet.FieldByName('EMET_NONREPLICATION').AsInteger:= 0;
end;

procedure TdmClient.CDS_GENCONNEXIONBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('CON_TYPE').IsNull then
    DataSet.FieldByName('CON_TYPE').AsBoolean:= False;
end;

procedure TdmClient.CDS_GENCONNEXIONNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('CON_ID').AsInteger:= -1;
  DataSet.FieldByName('CON_TYPE').AsBoolean:= False;
end;

procedure TdmClient.CDS_GENLIAIREPLINewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('GLR_ID').AsInteger:= 0;
end;

procedure TdmClient.CDS_GENPROVIDERS_DNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('GLR_ID').AsInteger:= 0;
end;

procedure TdmClient.CDS_GENREPLICATIONNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('REP_ORDRE').AsInteger:= 1;
end;

procedure TdmClient.CDS_GENREPLICATIONWEBNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('REP_ORDRE').AsInteger:= -1;
end;

procedure TdmClient.CDS_MAGBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('MAGA_ID').IsNull then
    DataSet.FieldByName('MAGA_ID').AsInteger:= -1;
  if DataSet.FieldByName('MAG_NATURE').IsNull then
    DataSet.FieldByName('MAG_NATURE').AsInteger:= 0;
  if DataSet.FieldByName('MAG_SS').IsNull then
    DataSet.FieldByName('MAG_SS').AsInteger:= 0;
end;

procedure TdmClient.CDS_MAGNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('MAGA_ID').AsInteger:= -1;
  DataSet.FieldByName('MAG_NATURE').AsInteger:= 0;
  DataSet.FieldByName('MAG_SS').AsInteger:= 0;
end;

procedure TdmClient.CDS_POSBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('POST_POSID').IsNull then
    DataSet.FieldByName('POST_POSID').AsInteger:= -1;
end;

procedure TdmClient.CDS_POSNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('POST_POSID').AsInteger:= -1;
end;

procedure TdmClient.CDS_SOCBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('SOC_ID').IsNull then
    DataSet.FieldByName('SOC_ID').AsInteger:= -1;
end;

procedure TdmClient.CDS_SOCMAGPOSBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('SOC_ID').IsNull then
    DataSet.FieldByName('SOC_ID').AsInteger:= -1;
  if DataSet.FieldByName('MAGA_ID').IsNull then
    DataSet.FieldByName('MAGA_ID').AsInteger:= -1;
  if DataSet.FieldByName('POST_POSID').IsNull then
    DataSet.FieldByName('POST_POSID').AsInteger:= -1;
  if DataSet.FieldByName('MAG_NATURE').IsNull then
    DataSet.FieldByName('MAG_NATURE').AsInteger:= 0;
  if DataSet.FieldByName('MAG_SS').IsNull then
    DataSet.FieldByName('MAG_SS').AsInteger:= 0;
end;

procedure TdmClient.CDS_SOCMAGPOSNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('SOC_ID').AsInteger:= -1;
  DataSet.FieldByName('MAGA_ID').AsInteger:= -1;
  DataSet.FieldByName('POST_POSID').AsInteger:= -1;
  DataSet.FieldByName('MAG_NATURE').AsInteger:= 0;
  DataSet.FieldByName('MAG_SS').AsInteger:= 0;
end;

procedure TdmClient.CDS_SOCNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('SOC_ID').AsInteger:= -1;
end;



function TdmClient.GetIndexByLibelleMAG_NATURE(const S: String): integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= Low(cListMAG_NATURE) to High(cListMAG_NATURE) do
    begin
      if cListMAG_NATURE[i] = S then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

function TdmClient.GetListGrpPump: String;
begin

end;

function TdmClient.GetListMAG_NATURE: String;
var
  i: integer;
begin
  Result:= '';
  for i:= Low(cListMAG_NATURE) to High(cListMAG_NATURE) do
    Result:= Result + cListMAG_NATURE[i] + #13#10;
end;

function TdmClient.GetVersionMajeure(const AVER_VERSION: String): integer;
var
  vSL: TStringList;
begin
  Result:= 0;
  if Trim(AVER_VERSION) = '' then
    Exit;

  vSL:= TStringList.Create;
  try
    vSL.Text:= StringReplace(AVER_VERSION, '.', #13#10, [rfReplaceAll]);
    if (vSL.Count <> 0) and (IsInteger(vSL.Strings[0])) then
      Result:= StrToInt(vSL.Strings[0]);
  finally
    FreeAndNil(vSL);
  end;
end;

function TdmClient.IndexOfListMAG_NATURE(const S: String): integer;
var
  i: integer;
begin
  Result:= -1;
  for i:= Low(cListMAG_NATURE) to High(cListMAG_NATURE) do
    begin
      if UpperCase(cListMAG_NATURE[i]) = UpperCase(S) then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

procedure TdmClient.CDS_MAGMAG_SSGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text:= cNOYES[Sender.AsInteger];
end;

procedure TdmClient.CDS_MAG_MAG_NATUREGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsInteger = -1 then
    Text:= cListMAG_NATURE[0]
  else
    Text:= cListMAG_NATURE[Sender.AsInteger]
end;

procedure TdmClient.CDS_MAG_MAG_NATURESetText(Sender: TField; const Text: string);
var
  vIdx: integer;
begin
  vIdx:= IndexOfListMAG_NATURE(Text);
  if vIdx <> -1 then
    Sender.AsInteger:= GetIndexByLibelleMAG_NATURE(Text)
  else
    Sender.AsInteger:= vIdx;
end;

end.

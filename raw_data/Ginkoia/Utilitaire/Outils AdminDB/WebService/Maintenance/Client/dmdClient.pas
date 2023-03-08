unit dmdClient;

interface

uses
  SysUtils, Classes, DB, DBClient, midaslib;

type
  TdmClient = class(TDataModule)
    CDSDossier: TClientDataSet;
    CDSDossierDOS_ID: TIntegerField;
    CDSDossierDOS_DATABASE: TStringField;
    CDSDossierDOS_CHEMIN: TStringField;
    CDSDossierSRV_ID: TIntegerField;
    CDSDossierGRP_ID: TIntegerField;
    CDSDossierDOS_INSTALL: TDateTimeField;
    CDSDossierDOS_VIP: TIntegerField;
    CDSDossierDOS_PLATEFORME: TStringField;
    CDS_EMETTEUR: TClientDataSet;
    CDS_EMETTEUREMET_ID: TIntegerField;
    CDS_EMETTEUREMET_GUID: TStringField;
    CDS_EMETTEUREMET_NOM: TStringField;
    CDS_EMETTEUREMET_DONNEES: TStringField;
    CDS_EMETTEURDOS_ID: TIntegerField;
    CDS_EMETTEUREMET_INSTALL: TDateTimeField;
    CDS_EMETTEUREMET_MAGID: TIntegerField;
    CDS_EMETTEURVER_ID: TIntegerField;
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
    CDS_SOCMAGPOSMAG_ID: TIntegerField;
    CDS_SOCMAGPOSMAG_NOM: TStringField;
    CDS_SOCMAGPOSMAG_SOCID: TIntegerField;
    CDS_SOCMAGPOSPOS_ID: TIntegerField;
    CDS_SOCMAGPOSPOS_NOM: TStringField;
    CDS_SOCMAGPOSPOS_MAGID: TIntegerField;
    CDS_SOCMAGPOSSOC_SSID: TIntegerField;
    CDS_SOCMAGPOSMAG_IDENTCOURT: TStringField;
    CDS_SOCMAGPOSMAG_ENSEIGNE: TStringField;
    CDS_SOCMAGPOSMAG_IDENT: TStringField;
    CDSModuleActif: TClientDataSet;
    CDSModuleActifMOD_NOM: TStringField;
    CDSModuleActifMOD_ID: TIntegerField;
    CDS_SOCMAGPOSSOC_CLOTURE: TDateTimeField;
    CDSModuleActifMAG_ID: TIntegerField;
    CDSModuleActifMAG_NOM: TStringField;
    CDS_SOCMAGPOSDOS_ID: TIntegerField;
    CDSModuleActifDOS_ID: TIntegerField;
    CDSModuleActifMODMAG_DATE: TDateTimeField;
    CDS_SOCMAGPOSMAG_ID_GINKOIA: TIntegerField;
    CDSModuleActifUGG_ID: TIntegerField;
    CDSModuleActifUGM_MAGID: TIntegerField;
    CDSModuleDisponible: TClientDataSet;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    StringField3: TStringField;
    IntegerField4: TIntegerField;
    StringField4: TStringField;
    DateTimeField1: TDateTimeField;
    IntegerField5: TIntegerField;
    IntegerField6: TIntegerField;
    CDS_EMETTEURLAU_AUTORUN: TIntegerField;
    CDS_EMETTEURLAU_BACK: TIntegerField;
    CDS_EMETTEURLAU_BACKTIME: TDateTimeField;
    CDS_EMETTEURPRM_POS: TIntegerField;
    CDS_SOCMAGPOSMAG_NATURE: TIntegerField;
    CDS_SOCMAGPOSMAG_SS: TIntegerField;
    CDS_GENCONNEXIONDOS_ID: TIntegerField;
    CDS_GENCONNEXIONEMET_ID: TIntegerField;
    CDS_GENCONNEXIONCON_TYPE: TBooleanField;
    procedure CDS_EMETTEURBeforePost(DataSet: TDataSet);
    procedure CDS_EMETTEURNewRecord(DataSet: TDataSet);
    procedure CDS_SOCMAGPOSNewRecord(DataSet: TDataSet);
    procedure CDS_SOCMAGPOSBeforePost(DataSet: TDataSet);
    procedure CDS_GENCONNEXIONBeforePost(DataSet: TDataSet);
    procedure CDS_GENCONNEXIONNewRecord(DataSet: TDataSet);
  private
    FDOS_ID: integer;
  public
    property DOS_ID: integer read FDOS_ID write FDOS_ID;
  end;

var
  dmClient: TdmClient;

implementation

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

procedure TdmClient.CDS_SOCMAGPOSBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('SOC_ID').IsNull then
    DataSet.FieldByName('SOC_ID').AsInteger:= -1;
  if DataSet.FieldByName('MAG_ID').IsNull then
    DataSet.FieldByName('MAG_ID').AsInteger:= -1;
  if DataSet.FieldByName('POS_ID').IsNull then
    DataSet.FieldByName('POS_ID').AsInteger:= -1;
  if DataSet.FieldByName('MAG_NATURE').IsNull then
    DataSet.FieldByName('MAG_NATURE').AsInteger:= 0;
  if DataSet.FieldByName('MAG_SS').IsNull then
    DataSet.FieldByName('MAG_SS').AsInteger:= 0;
end;

procedure TdmClient.CDS_SOCMAGPOSNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('SOC_ID').AsInteger:= -1;
  DataSet.FieldByName('MAG_ID').AsInteger:= -1;
  DataSet.FieldByName('POS_ID').AsInteger:= -1;
  DataSet.FieldByName('MAG_NATURE').AsInteger:= 0;
  DataSet.FieldByName('MAG_SS').AsInteger:= 0;
end;

end.

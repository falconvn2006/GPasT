unit dmdClients;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, ImgList, Controls, DB, DBClient, Forms, Dialogs, cxGrid, cxPC, midaslib,
  ActnList, ComCtrls, u_Parser, ExtCtrls, Graphics;


type
  TParams = Class(TComponent)
  private
    FListParam: TStringList;
    FDelayRefreshValues: integer;
    FUrl: String;
    FIsFileExist: Boolean;
  published
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    property ListParam: TStringList read FListParam;
    property Url: String read FUrl;
    property DelayRefreshValues: integer read FDelayRefreshValues;
    property IsFileExist: Boolean read FIsFileExist;
  End;

  TGenerique = Class(TComponent)
  private
    FID: Variant;
    FLibelle: Variant;
  public
    property ID: Variant read FID write FID;
    property Libelle: Variant read FLibelle write FLibelle;
  End;

  TdmClients = class(TDataModule)
    ImgLst: TImageList;
    CDS_SRV: TClientDataSet;
    CDS_SRVSRV_ID: TIntegerField;
    CDS_SRVSRV_NOM: TStringField;
    CDS_SRVSRV_IP: TStringField;
    CDS_GRP: TClientDataSet;
    CDS_GRPGRP_ID: TIntegerField;
    CDS_GRPGRP_NOM: TStringField;
    CDS_DOS: TClientDataSet;
    CDS_DOSDOS_ID: TIntegerField;
    CDS_DOSDOS_DATABASE: TStringField;
    CDS_DOSDOS_CHEMIN: TStringField;
    CDS_DOSSRV_ID: TIntegerField;
    CDS_DOSGRP_ID: TIntegerField;
    CDS_DOSDOS_VIP: TIntegerField;
    CDS_DOSDOS_PLATEFORME: TStringField;
    CDSModule: TClientDataSet;
    CDSModuleDOS_ID: TIntegerField;
    CDSModuleMAG_ID: TIntegerField;
    CDSModuleMAG_ID_GINKOIA: TIntegerField;
    CDSModuleDOS_DATABASE: TStringField;
    CDSModuleMAG_NOM: TStringField;
    CDSModuleMOD_NOM: TStringField;
    CDSJeton: TClientDataSet;
    CDSJetonDOS_ID: TIntegerField;
    CDSJetonEMET_ID: TIntegerField;
    CDSJetonDOS_DATABASE: TStringField;
    CDSJetonEMET_NOM: TStringField;
    CDSJetonEMET_JETON: TIntegerField;
    CDS_DOSSRV_NOM: TStringField;
    CDS_DOSGRP_NOM: TStringField;
    CDS_DOSVER_VERSION: TStringField;
    CDSHoraire: TClientDataSet;
    CDS_PARAMHORAIRES: TClientDataSet;
    CDS_PARAMHORAIRESPRH_ID: TIntegerField;
    CDS_PARAMHORAIRESPRH_NOMPLAGE: TStringField;
    CDS_PARAMHORAIRESPRH_NBREPLIC: TIntegerField;
    CDS_PARAMHORAIRESPRH_DEFAUT: TIntegerField;
    CDS_PARAMHORAIRESPRH_SRVID: TIntegerField;
    CDS_PARAMHORAIRESPRH_HDEB: TDateTimeField;
    CDS_PARAMHORAIRESPRH_HFIN: TDateTimeField;
    CDS_DOSDOS_INSTALL: TDateTimeField;
    CDSJetonEMET_TYPEREPLICATION: TStringField;
    CDSSuiviRepEtBaseHS: TClientDataSet;
    CDSSuiviRepEtBaseHSEMET_ID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_GUID: TStringField;
    CDSSuiviRepEtBaseHSEMET_NOM: TStringField;
    CDSSuiviRepEtBaseHSEMET_DONNEES: TStringField;
    CDSSuiviRepEtBaseHSDOS_ID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_INSTALL: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_MAGID: TIntegerField;
    CDSSuiviRepEtBaseHSVER_ID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_PATCH: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_VERSION_MAX: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_SPE_PATCH: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_SPE_FAIT: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_BCKOK: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_DERNBCK: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_RESBCK: TStringField;
    CDSSuiviRepEtBaseHSEMET_TIERSCEGID: TStringField;
    CDSSuiviRepEtBaseHSEMET_TYPEREPLICATION: TStringField;
    CDSSuiviRepEtBaseHSEMET_NONREPLICATION: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_DEBUTNONREPLICATION: TDateField;
    CDSSuiviRepEtBaseHSEMET_FINNONREPLICATION: TDateField;
    CDSSuiviRepEtBaseHSEMET_SERVEURSECOURS: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_IDENT: TStringField;
    CDSSuiviRepEtBaseHSEMET_JETON: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_PLAGE: TStringField;
    CDSSuiviRepEtBaseHSEMET_H1: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_HEURE1: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_H2: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_HEURE2: TDateTimeField;
    CDSSuiviRepEtBaseHSBAS_SENDER: TStringField;
    CDSSuiviRepEtBaseHSBAS_CENTRALE: TStringField;
    CDSSuiviRepEtBaseHSBAS_NOMPOURNOUS: TStringField;
    CDSSuiviRepEtBaseHSLAU_AUTORUN: TIntegerField;
    CDSSuiviRepEtBaseHSLAU_BACK: TIntegerField;
    CDSSuiviRepEtBaseHSLAU_BACKTIME: TDateTimeField;
    CDSSuiviRepEtBaseHSPRM_POS: TIntegerField;
    CDSSuiviRepEtBaseHSSRV_ID: TIntegerField;
    CDSSuiviRepEtBaseHSSRV_NOM: TStringField;
    CDSSuiviRepEtBaseHSDOS_DATABASE: TStringField;
    CDSSuiviRepEtBaseHSHDB_ID: TIntegerField;
    CDSSuiviRepEtBaseHSHDB_CYCLE: TDateTimeField;
    CDSSuiviRepEtBaseHSHDB_OK: TIntegerField;
    CDSSuiviRepEtBaseHSHDB_COMMENTAIRE: TStringField;
    CDSSuiviRepEtBaseHSHDB_ARCHIVER: TIntegerField;
    CDSSuiviRepEtBaseHSHDB_DATE: TDateTimeField;
    CDSSuiviRepEtBaseHSRAISON_ID: TIntegerField;
    CDSSuiviRepEtBaseHSRAISON_NOM: TStringField;
    CDSSuiviRepEtBaseHSDOS_VIP: TBooleanField;
    CDSHoraireDispo: TClientDataSet;
    CDSHoraireDispoHoraireDispo: TDateTimeField;
    CDSHoraireDispoIndexCol: TIntegerField;
    CDSHoraireDispoPlageDispo: TStringField;
    CDSSuiviSrvReplication: TClientDataSet;
    CDSSuiviSrvReplicationSRV_ID: TIntegerField;
    CDSSuiviSrvReplicationSVR_DATE: TStringField;
    CDSSuiviSrvReplicationSVR_VERSION: TStringField;
    CDSSuiviSrvReplicationSVR_ERR: TStringField;
    CDSSuiviSrvReplicationSVR_PATH: TStringField;
    CDSSuiviSrvReplicationSVR_DATABASE: TStringField;
    CDSSuiviSrvReplicationSVR_SENDER: TStringField;
    CDSModeleMail: TClientDataSet;
    CDSModeleMailNOM: TStringField;
    CDSModeleMailOBJET: TStringField;
    CDSModeleMailMESSAGE: TStringField;
    CDSModeleMailFILENAME: TStringField;
    CDSSendMail: TClientDataSet;
    CDSSendMailEMET_ID: TIntegerField;
    CDSSendMailMAIL_FILENAME: TStringField;
    CDSRAISONS: TClientDataSet;
    CDSRAISONSRAISON_ID: TIntegerField;
    CDSRAISONSRAISON_NOM: TStringField;
    CDSRAISONSHDB_ID: TIntegerField;
    CDSRAISONSDOS_ID: TIntegerField;
    CDSRAISONSEMET_ID: TIntegerField;
    CDSSuiviServeur: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    IntegerField2: TIntegerField;
    DateTimeField1: TDateTimeField;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    IntegerField6: TIntegerField;
    IntegerField7: TIntegerField;
    IntegerField8: TIntegerField;
    DateTimeField2: TDateTimeField;
    DateTimeField3: TDateTimeField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    IntegerField9: TIntegerField;
    DateField1: TDateField;
    DateField2: TDateField;
    IntegerField10: TIntegerField;
    StringField9: TStringField;
    IntegerField11: TIntegerField;
    StringField10: TStringField;
    IntegerField12: TIntegerField;
    DateTimeField4: TDateTimeField;
    IntegerField13: TIntegerField;
    DateTimeField5: TDateTimeField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    IntegerField14: TIntegerField;
    IntegerField15: TIntegerField;
    DateTimeField6: TDateTimeField;
    IntegerField16: TIntegerField;
    IntegerField17: TIntegerField;
    IntegerField18: TIntegerField;
    DateTimeField7: TDateTimeField;
    IntegerField19: TIntegerField;
    StringField14: TStringField;
    IntegerField20: TIntegerField;
    DateTimeField8: TDateTimeField;
    IntegerField21: TIntegerField;
    StringField15: TStringField;
    BooleanField1: TBooleanField;
    CDSSuiviPortable: TClientDataSet;
    IntegerField22: TIntegerField;
    StringField16: TStringField;
    StringField17: TStringField;
    StringField18: TStringField;
    StringField19: TStringField;
    StringField20: TStringField;
    IntegerField23: TIntegerField;
    DateTimeField9: TDateTimeField;
    IntegerField24: TIntegerField;
    IntegerField25: TIntegerField;
    IntegerField26: TIntegerField;
    IntegerField27: TIntegerField;
    IntegerField28: TIntegerField;
    IntegerField29: TIntegerField;
    DateTimeField10: TDateTimeField;
    DateTimeField11: TDateTimeField;
    StringField21: TStringField;
    StringField22: TStringField;
    StringField23: TStringField;
    IntegerField30: TIntegerField;
    DateField3: TDateField;
    DateField4: TDateField;
    IntegerField31: TIntegerField;
    StringField24: TStringField;
    IntegerField32: TIntegerField;
    StringField25: TStringField;
    IntegerField33: TIntegerField;
    DateTimeField12: TDateTimeField;
    IntegerField34: TIntegerField;
    DateTimeField13: TDateTimeField;
    StringField26: TStringField;
    StringField27: TStringField;
    StringField28: TStringField;
    IntegerField35: TIntegerField;
    IntegerField36: TIntegerField;
    DateTimeField14: TDateTimeField;
    IntegerField37: TIntegerField;
    IntegerField38: TIntegerField;
    IntegerField39: TIntegerField;
    DateTimeField15: TDateTimeField;
    IntegerField40: TIntegerField;
    StringField29: TStringField;
    IntegerField41: TIntegerField;
    DateTimeField16: TDateTimeField;
    IntegerField42: TIntegerField;
    StringField30: TStringField;
    BooleanField2: TBooleanField;
    CDSSuiviServeurVIP: TClientDataSet;
    IntegerField43: TIntegerField;
    StringField31: TStringField;
    StringField32: TStringField;
    StringField33: TStringField;
    StringField34: TStringField;
    StringField35: TStringField;
    IntegerField44: TIntegerField;
    DateTimeField17: TDateTimeField;
    IntegerField45: TIntegerField;
    IntegerField46: TIntegerField;
    IntegerField47: TIntegerField;
    IntegerField48: TIntegerField;
    IntegerField49: TIntegerField;
    IntegerField50: TIntegerField;
    DateTimeField18: TDateTimeField;
    DateTimeField19: TDateTimeField;
    StringField36: TStringField;
    StringField37: TStringField;
    StringField38: TStringField;
    IntegerField51: TIntegerField;
    DateField5: TDateField;
    DateField6: TDateField;
    IntegerField52: TIntegerField;
    StringField39: TStringField;
    IntegerField53: TIntegerField;
    StringField40: TStringField;
    IntegerField54: TIntegerField;
    DateTimeField20: TDateTimeField;
    IntegerField55: TIntegerField;
    DateTimeField21: TDateTimeField;
    StringField41: TStringField;
    StringField42: TStringField;
    StringField43: TStringField;
    IntegerField56: TIntegerField;
    IntegerField57: TIntegerField;
    DateTimeField22: TDateTimeField;
    IntegerField58: TIntegerField;
    IntegerField59: TIntegerField;
    IntegerField60: TIntegerField;
    DateTimeField23: TDateTimeField;
    IntegerField61: TIntegerField;
    StringField44: TStringField;
    IntegerField62: TIntegerField;
    DateTimeField24: TDateTimeField;
    IntegerField63: TIntegerField;
    StringField45: TStringField;
    BooleanField3: TBooleanField;
    CDSSPLITTAGE_LOG: TClientDataSet;
    CDSSPLITTAGE_LOGNOSPLIT: TIntegerField;
    CDSSPLITTAGE_LOGEMET_ID: TIntegerField;
    CDSSPLITTAGE_LOGEMET_NOM: TStringField;
    CDSSPLITTAGE_LOGDATEHEURESTART: TDateTimeField;
    CDSSPLITTAGE_LOGDATEHEUREEND: TDateTimeField;
    CDSSPLITTAGE_LOGORDRE: TIntegerField;
    CDSSPLITTAGE_LOGEVENTLOG: TBlobField;
    CDSSPLITTAGE_LOGSTARTED: TIntegerField;
    CDSSPLITTAGE_LOGTERMINATE: TIntegerField;
    CDSSPLITTAGE_LOGERROR: TIntegerField;
    CDSSPLITTAGE_LOGUSERNAME: TStringField;
    CDSSPLITTAGE_LOGTYPESPLIT: TStringField;
    CDSSPLITTAGE_LOGCLEARFILES: TIntegerField;
    procedure CDSHoraireNewRecord(DataSet: TDataSet);
    procedure CDS_PARAMHORAIRESNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure CDS_DOSNewRecord(DataSet: TDataSet);
    procedure CDSSuiviRepEtBaseHSBeforePost(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CDS_PARAMHORAIRESPRH_HDEBGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CDSSPLITTAGE_LOGDATEHEURESTARTGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure CDSSPLITTAGE_LOGSTARTEDGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FInitialized: Boolean;
    procedure ClearListGenerique(AList: TStrings);
    procedure InitialiseBooleanToDataSet(DataSet: TDataSet);
    procedure pOnRecordToXml(AName: String; ADateType: TFieldType; var Value: String);
  public
    function ResetConnexion: Boolean;
    function GetNewIdHTTP(Const AOwner: TComponent = nil): TIdHTTP;
    function GetTimeValues: String;
    function IndexOfByID(Const AID: integer; Const AList: TStrings): integer;
    function CountRecCxGrid(Const AGrid: TcxGrid): String;
    procedure ResetTimePanel(const APanel: TPanel);
    procedure InitializeIHM(Const AFrom: TWinControl);
    procedure LoadLists;
    procedure XmlToDataSet(Const ARessource: String; Const ACible: TClientDataSet;
                           Const FirstRecAutoDelete: Boolean = True; Const AutoPost: Boolean = True;
                           Const AEmpty: Boolean = True; Const AContentEncoding: String = cDefaultEncoding;
                           Const ASizeField: integer = cSizeField);
    procedure XmlToList(Const ARessource: String; Const AFieldName, AFieldNameID: String;
                        AListCible: TStrings; Const AOwner: TComponent;
                        Const FirstRecAutoDelete: Boolean = True);

    procedure PostRecordToXml(Const ARessource, AClassName: String; Const ASource: TClientDataSet;
                              Const AListField: TStringList = nil; Const AllDataSet: Boolean = False);
    procedure DeleteRecordByRessource(Const ARessource: String);

    procedure DataSetToList(Const ASource: TClientDataSet; Const AFieldNameID, AFieldName: String;
                        AListCible: TStrings; Const AOwner: TComponent);
    property Initialized: Boolean read FInitialized;
  end;

var
  dmClients: TdmClients;
  GIsBrowse: Boolean;
  GParams: TParams;

implementation

uses uTool, uConst;

{$R *.dfm}

{ TdmClients }

procedure TdmClients.XmlToDataSet(const ARessource: String;
  const ACible: TClientDataSet; Const FirstRecAutoDelete: Boolean;
  Const AutoPost: Boolean; Const AEmpty: Boolean;
  Const AContentEncoding: String; Const ASizeField: integer);
var
  vParser: TParser;
  vIdHTTP: TIdHTTP;
begin
  Screen.Cursor:= crHourGlass;
  vParser:= TParser.Create(nil);
  try
    vParser.ContentEncoding:= AContentEncoding;
    vParser.SizeField:= ASizeField;
    try
      { Recuperation de la ressource }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Get(GParams.Url + ARessource);
      vParser.Execute;

      if vParser.Erreur <> '' then
        Raise Exception.Create(vParser.Erreur);

      if vParser.ADataSet.FindField('Exception') <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName('Exception').AsString);

      if FirstRecAutoDelete then
        begin
          vParser.ADataSet.First;
          vParser.ADataSet.Delete;
        end;

      { Chargement des données dans le ClientDataSet }
      if AEmpty then
        ACible.EmptyDataSet;
      BatchMove(vParser.ADataSet, ACible, AutoPost);
    except
      Raise;
    end;
  finally
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TdmClients.XmlToList(Const ARessource: String; Const AFieldName, AFieldNameID: String;
  AListCible: TStrings; Const AOwner: TComponent; Const FirstRecAutoDelete: Boolean = True);
var
  vParser: TParser;
  vGen: TGenerique;
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= nil;
  Screen.Cursor:= crHourGlass;
  vParser:= TParser.Create(nil);
  try
    try
      { Recuperation de la ressource }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Get(GParams.Url + ARessource);
      vParser.Execute;

      if vParser.Erreur <> '' then
        Raise Exception.Create(vParser.Erreur);

      if vParser.ADataSet.FindField('Exception') <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName('Exception').AsString);

      if FirstRecAutoDelete then
        begin
          vParser.ADataSet.First;
          if vParser.ADataSet.RecordCount <> 0 then
            vParser.ADataSet.Delete;
        end;

      { Chargement des données  }
      if vParser.ADataSet.FindField(AFieldName) = nil then
        Exit;

      ClearListGenerique(AListCible);
      vParser.ADataSet.First;
      while not vParser.ADataSet.Eof do
        begin
          vGen:= TGenerique.Create(AOwner);
          vGen.Libelle:= vParser.ADataSet.FieldByName(AFieldName).AsString;
          if (AFieldNameID <> '') and (vParser.ADataSet.FindField(AFieldNameID) <> nil) then
            vGen.ID:= vParser.ADataSet.FieldByName(AFieldNameID).AsString;
          AListCible.AddObject(vGen.Libelle, Pointer(vGen));
          vParser.ADataSet.Next;
        end;
    except
      Raise;
    end;
  finally
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TdmClients.CDSHoraireNewRecord(DataSet: TDataSet);
begin
  InitialiseBooleanToDataSet(DataSet);
end;

procedure TdmClients.CDSSPLITTAGE_LOGDATEHEURESTARTGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= FormatDateTime('dd/mm/yyyy hh:nn:ss', Sender.AsDateTime);
  if (Sender.IsNull) or (Sender.AsDateTime = 0) then
    Text:= '';
end;

procedure TdmClients.CDSSPLITTAGE_LOGSTARTEDGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull then
    Text:= cNOYES[Sender.AsInteger];
end;

procedure TdmClients.CDSSuiviRepEtBaseHSBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('DOS_VIP').IsNull then
    DataSet.FieldByName('DOS_VIP').AsBoolean:= False;
end;

procedure TdmClients.CDS_DOSNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('DOS_ID').AsInteger:= -1;
  DataSet.FieldByName('DOS_VIP').AsInteger:= 0;
end;

procedure TdmClients.CDS_PARAMHORAIRESNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('PRH_ID').AsInteger:= -1;
  if DataSet.FieldByName('PRH_DEFAUT').IsNull then
    DataSet.FieldByName('PRH_DEFAUT').AsInteger:= 0;
end;

procedure TdmClients.CDS_PARAMHORAIRESPRH_HDEBGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= FormatDateTime('hh:nn', Sender.AsDateTime);
  if (CDS_PARAMHORAIRES.FieldByName('PRH_DEFAUT').AsInteger = 1) then
    Text:= '';
end;

procedure TdmClients.ClearListGenerique(AList: TStrings);
var
  i: integer;
  vGen: TGenerique;
begin
  for i:= 0 to AList.Count - 1 do
    begin
      if (AList.Objects[i] <> nil) and (AList.Objects[i].ClassType = TGenerique) then
        begin
          vGen:= TGenerique(AList.Objects[i]);
          FreeAndNil(vGen);
        end;
    end;
  AList.Clear;
end;

function TdmClients.CountRecCxGrid(const AGrid: TcxGrid): String;
begin
  Result:= Format(cCountRec, ['0', '0']);
  if (AGrid <> nil) and (AGrid.Enabled) then
    Result:= Format(cCountRec, [IntToStr(AGrid.Controller.Control.FocusedView.DataController.FilteredRecordCount),
                                IntToStr(AGrid.Controller.Control.FocusedView.DataController.RecordCount)]);
end;

procedure TdmClients.DataModuleCreate(Sender: TObject);
begin
  GIsBrowse:= True;
  SetLength(TrueBoolStrs, 2);
  SetLength(FalseBoolStrs, 2);
  TrueBoolStrs[0]:= DefaultTrueBoolStr;
  FalseBoolStrs[0]:= DefaultFalseBoolStr;
  TrueBoolStrs[1]:= 'Vrai';
  FalseBoolStrs[1]:= 'Faux';
  GParams:= TParams.Create(Self);
  GParams.Load;
end;

procedure TdmClients.DataModuleDestroy(Sender: TObject);
begin
  Finalize(TrueBoolStrs);
  Finalize(FalseBoolStrs);
end;

procedure TdmClients.DataSetToList(const ASource: TClientDataSet;
  const AFieldNameID, AFieldName: String; AListCible: TStrings;
  const AOwner: TComponent);
var
  vGen: TGenerique;
begin
  ClearListGenerique(AListCible);
  ASource.DisableControls;
  try
    ASource.First;
    while not ASource.Eof do
      begin
        vGen:= TGenerique.Create(AOwner);
        vGen.Libelle:= ASource.FieldByName(AFieldName).AsString;
        if (AFieldNameID <> '') and (ASource.FindField(AFieldNameID) <> nil) then
          vGen.ID:= ASource.FieldByName(AFieldNameID).Value;
        AListCible.AddObject(vGen.Libelle, Pointer(vGen));
        ASource.Next;
      end;
  finally
    ASource.First;
    ASource.EnableControls;
  end;
end;

procedure TdmClients.DeleteRecordByRessource(const ARessource: String);
var
  vIdHTTP: TIdHTTP;
begin
  Screen.Cursor:= crHourGlass;
  try
    try
      { Delete du record au serveur }
      vIdHTTP:= GetNewIdHTTP(nil);
      vIdHTTP.Head(GParams.Url + ARessource);
    except
      Raise;
    end;
  finally
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

function TdmClients.GetNewIdHTTP(const AOwner: TComponent): TIdHTTP;
begin
  Result:= TIdHTTP.Create(AOwner);
  Result.Request.Accept:= 'text/xml, */*';
  Result.Request.ContentEncoding:= 'UTF-8';
  Result.Request.ContentType:= 'text/xml, */*';
  Result.Request.UserAgent:= 'Client Ginkoia 1.0';
  Result.Response.KeepAlive:= False;
end;

function TdmClients.GetTimeValues: String;
begin
  Result:= Format(cLibTimeValues, [FormatDateTime('dd/mm/yyy', Now), FormatDateTime('hh:nn', Now)]);
end;

procedure TdmClients.PostRecordToXml(const ARessource, AClassName: String;
  const ASource: TClientDataSet; Const AListField: TStringList;
  Const AllDataSet: Boolean);
var
  vParser: TParser;
  vSL: TStrings;
  vIdHTTP: TIdHTTP;
begin
  Screen.Cursor:= crHourGlass;
  vSL:= TStringList.Create;
  vParser:= TParser.Create(nil);
  try
    vParser.OnRecordToXml:= pOnRecordToXml;
    try
      if not AllDataSet then
        vSL.Text:= vParser.RecordToXml(ASource, AClassName, AListField)
      else
        begin
          ASource.First;
          while not ASource.Eof do
            begin
              vSL.Text:= vSL.Text + vParser.RecordToXml(ASource, AClassName, AListField);
              ASource.Next;
            end;
        end;

      { Post du record au serveur }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Post(GParams.Url + ARessource, vSL);
      vParser.Execute;

      if vParser.ADataSet.FindField('Exception') <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName('Exception').AsString);
    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

function TdmClients.ResetConnexion: Boolean;
var
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= GetNewIdHTTP(nil);
  try
    Result:= vIdHTTP.Get(GParams.Url + cStart) = cWSStarted;
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TdmClients.ResetTimePanel(const APanel: TPanel);
begin
  APanel.Caption:= GetTimeValues;
  APanel.Font.Color:= clWindowText;
  if APanel.Tag <> 0 then
    begin
      TTimer(APanel.Tag).Interval:= GParams.DelayRefreshValues;
      TTimer(APanel.Tag).Enabled:= True;
    end;
end;

function TdmClients.IndexOfByID(const AID: integer;
  const AList: TStrings): integer;
var
  i: integer;
  vGen: TGenerique;
begin
  Result:= -1;
  for i:= 0 to AList.Count - 1 do
    begin
      vGen:= TGenerique(AList.Objects[i]);
      if (vGen <> nil) and (vGen.ID = AID) then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

procedure TdmClients.InitialiseBooleanToDataSet(DataSet: TDataSet);
var
  i: integer;
begin
  for i:= 0 to DataSet.FieldCount - 1 do
    begin
      if DataSet.Fields.Fields[i].DataType = ftBoolean then
        DataSet.Fields.Fields[i].AsBoolean:= False;
    end;
end;

procedure TdmClients.InitializeIHM(const AFrom: TWinControl);
var
  i: integer;
begin
  for i:= 0 to AFrom.ComponentCount - 1 do
    begin
      if (AFrom.Components[i] is TcxGrid) and (TcxGrid(AFrom.Components[i]).Parent is TcxTabSheet) then
        TcxTabSheet(TcxGrid(AFrom.Components[i]).Parent).Tag:= Integer(AFrom.Components[i]);
    end;
end;

procedure TdmClients.LoadLists;
begin
  FInitialized:= False;
  Screen.Cursor:= crHourGlass;
  try
    try
      { Recuperation des Srv }
      XmlToDataSet('Srv', CDS_SRV);

      { Recuperation des Grp }
      XmlToDataSet('Grp', CDS_GRP);

      { Recuperation des dossiers }
      XmlToDataSet('Dossier', CDS_DOS);

      { Recuperation des modeles de mail }
      XmlToDataSet('ModeleMail', CDSModeleMail, True, True, True, cDefaultEncoding, 2000);

      FInitialized:= True;
    except
      Raise;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TdmClients.pOnRecordToXml(AName: String; ADateType: TFieldType;
  var Value: String);
begin
  if Value <> '' then
    begin
      case ADateType of
        ftDate, ftTime, ftDateTime, ftTimeStamp: Value:= FloatToStr(StrToDateTime(Value));
        ftBoolean: Value:= IntToStr(Integer(StrToBool(Value)));
      end;
    end;
end;

{ TParams }

constructor TParams.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListParam:= TStringList.Create;
end;

destructor TParams.Destroy;
begin
  FreeAndNil(FListParam);
  inherited Destroy;
end;

procedure TParams.Load;
var
  Buffer: String;
begin
  Buffer:= ChangeFileExt(Application.ExeName, '.ini');
  FIsFileExist:= FileExists(Buffer);
  if FIsFileExist then
    begin
      FListParam.LoadFromFile(Buffer);

      FUrl:= FListParam.Values['URL'];
      if FUrl[Length(FUrl)] <> '/' then
        FUrl:= FUrl + '/';

      Buffer:= FListParam.Values['DelayRefreshValues'];
      if Buffer <> '' then
        FDelayRefreshValues:= StrToInt(Buffer)
      else
        FDelayRefreshValues:= cDefaultDelayRefreshValues;
    end;
end;

procedure TParams.Save;
begin
  FListParam.SaveToFile(ChangeFileExt(Application.ExeName, '.ini'));
  Load;
end;

end.

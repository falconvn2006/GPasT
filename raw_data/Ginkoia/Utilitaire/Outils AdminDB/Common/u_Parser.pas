unit u_Parser;

interface

uses Classes, SysUtils, Windows, contnrs, Variants, DB, DBClient, midaslib,
  xmldom, XMLIntf, HTTPApp, msxmldom, XMLDoc, ActiveX, TypInfo, Dialogs,
  IniFiles, Registry, WideStrUtils;

Const
  cRC              = #13#10;
  cKeyPathIni      = 'PATHINI';
  cWS              = 'Web service : ';
  cWSStarted       = cWS + 'Started';
  cWSFailed        = cWS + 'Failed';
  cFieldID         = 'ID';
  cSizeField       = 400;
  cDefaultEncoding = 'UTF-8';
  cBaliseValXml    = cRC + '<%s>%s</%s>';
  cBaliseCDataXml  = cRC + '<%s>' + cRC + '<![CDATA[%s]]>' + cRC + '</%s>';

  cHeaderBalise    = '<?xml version="1.0" encoding="' + cDefaultEncoding + '"?>';
  cBaliseURI       = '<order uri="%s">%s' + cRC + '</order>';
  cBaliseItemURI   = '<order_item uri="%s">%s' + cRC + '</order_item>';
  cBlsResult       = 'result';
  cBaliseResult    = '<' + cBlsResult + '>' + cRC + '<![CDATA[%s]]>' + cRC + '</' + cBlsResult + '>';
  cBaliseCDataResult = '<' + cBlsResult + '>%s' + cRC + '</' + cBlsResult + '>';
  cOrderItems      = 'order_items';
  cBlsValXml       = cBaliseValXml;
  cBlsExcept       = 'Exception';
  cBlsResultEmpty  = 'ResultEmpty';
  cSucces          = 'Succes';
  cNoValue          = 'No Value';

  // -- Parametres INI
  Sec_Gen              = 'Général';
  Sec_Log              = 'Log';

  Itm_LogOnStart       = 'LogOnStart';   // --> Log au demarrage du Web Service
  Itm_LogException     = 'LogException'; // --> Log sur les exceptions du Web Service
  Itm_Traceur          = 'Traceur';      // --> Log de traçage (utile dans les procedures ou functions)
  Itm_Verbose          = 'Verbose';      // --> Log veurbeux (ou pas) (gestion des evenement de webservice)
  Itm_Profiling        = 'Profiling';    // --> Profiling des temps de traitements
  Itm_FileNameDB       = 'FileNameDB';   // --> Chemin de la base de données + le fichier .IB
  Itm_LoginDB          = 'LoginDB';      // --> Login de connexion base de données
  Itm_PasswordDB       = 'PasswordDB';   // --> Password de connexion base de données
  Itm_ServicePath      = 'ServicePath';  // --> Chemin du Web Service
  Itm_PathXMLClgLocal  = 'PathXMLClg';   // --> Chemin de sauvegarde du fichier xml en local
  Itm_PathXMLClgReseau = 'PathXMLRes';   // --> Chemin d'acces au fichier xml en réseau

Type
  TNodeTypes          = Set of TNodeType;

  TOnLoadValue        = procedure(AName: String; var Value: String) of object;
  TOnLoadValueMapping = procedure(AName: String; var Value: Variant) of object;
  TOnRecordToXml      = procedure(AName: String; ADateType: TFieldType; var Value: String) of object;

  TCustomWSConfig = class(TComponent)
  private
    FServiceName     : String;
    FServicePath     : String;
    FServicePathLog  : String;
    FTraceur         : Boolean;
    FLogOnStart      : Boolean;
    FVerbose         : Boolean;
    FProfiling       : Boolean;
    FFileNameIni     : String;
    FFileNameDB      : String;
    FLoginDB         : string;
    FPasswordDB      : string;
    FLogException    : Boolean;
    FOptions         : TStringList;
    FPathXMLClgLocal : String;
    FPathXMLClgReseau: String;
  protected
    function GetServiceFileName: String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTime: String; virtual;
    procedure Load; virtual;

    { Permet de créer un log conditionné par un permission }
    procedure SaveFile(Const FileName: String; Const ASL: TStringList; Const Allow: Boolean); virtual;

    { Chemin + le nom du fichier ini de config }
    property FileNameIni: String read FFileNameIni;

    { Config generique du Web Service }
    property ServiceName: String read FServiceName write FServiceName;
    property ServicePath: String read FServicePath;
    property ServicePathLog: String read FServicePathLog;
    property ServiceFileName: String read GetServiceFileName;
    property LogOnStart: Boolean read FLogOnStart write FLogOnStart;
    property LogException: Boolean read FLogException write FLogException;
    property Traceur: Boolean read FTraceur write FTraceur;
    property Verbose: Boolean read FVerbose write FVerbose;
    property Profiling: Boolean read FProfiling write FProfiling;
    property FileNameDB: String read FFileNameDB write FFileNameDB;
    property LoginDB : string read FLoginDB write FLoginDB;
    property PasswordDB : string read FPasswordDB write FPasswordDB;

    property PathXMLClgLocal: String read FPathXMLClgLocal write FPathXMLClgLocal;
    property PathXMLClgReseau: String read FPathXMLClgReseau write FPathXMLClgReseau;

    { Regroupe tous les parametres de config du fichier ini <> de la config generique }
    property Options: TStringList read FOptions;
  end;

  TWSConfig = class(TCustomWSConfig);

  TCustomParser = class(TComponent)
  private
    FXMLDoc           : TXMLDocument;
    FListFields       : TStringList;
    FDataSet          : TClientDataSet;
    FTOnLoadXMLInTable: TOnLoadValue;
    FARequest         : String;
    FErreur           : String;
    FContentEncoding  : String;
    FOnRecordToXml    : TOnRecordToXml;
    FSizeField        : integer;
    FXmlREST          : Boolean;
    procedure FinalizeParsing;
    procedure SetARequest(const Value: String);
  protected
    procedure LoadListFields(XMLNode: IXMLNode; AListFields: TStringList); virtual;
    procedure LoadListFieldsToTable; virtual;
    procedure LoadXMLInTable(ADataSet: TDataSet; XMLNode: IXMLNode; ANodeAttrib: String = ''); virtual;
    procedure DoOnLoadXMLInTable(AName: String; var Value: String); virtual;
    procedure DoOnRecordToXml(AName: String; ADateType: TFieldType; var Value: String); virtual;
    property XMLDoc: TXMLDocument read FXMLDoc;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute(Const ASilentRaise: Boolean = False); virtual;
    procedure ClearMemData; virtual;
    function RecordToXml(Const ADataSet: TDataSet; Const AClassName: String; Const AListField: TStringList = nil): String; virtual;
    property ARequest: String read FARequest write SetARequest;
    property ADataSet: TClientDataSet read FDataSet;
    property ListFields: TStringList read FListFields;
    property OnLoadXMLInTable: TOnLoadValue read FTOnLoadXMLInTable write FTOnLoadXMLInTable;
    property OnRecordToXml: TOnRecordToXml read FOnRecordToXml write FOnRecordToXml;
    property Erreur: String read FErreur;
    property ContentEncoding: String read FContentEncoding write FContentEncoding;
    property SizeField: integer read FSizeField write FSizeField;
    property XmlREST: Boolean read FXmlREST write FXmlREST;
  end;

  TParser = class(TCustomParser);

  TCustomMapperObj = Class(TComponent)
  private
    FAParser          : TParser;
    FOnPropertyToXml  : TOnLoadValue;
    FOnMappingProperty: TOnLoadValueMapping;
  protected
    function BuilXmlItems(Const ARequest: TWebRequest; Const Items: String): String; virtual;
    procedure MappingProperty(Const UdpObj: TComponent); virtual;
    procedure PropertyToXml(Const UdpObj: TComponent; var AXml: String; Const ListField: TStringList = nil); virtual;
    procedure DoOnPropertyToXml(Const AName: String; var Value: String); virtual;
    procedure DoOnMappingProperty(Const AName: String; var Value: Variant); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AParser: TParser read FAParser;
    property OnPropertyToXml: TOnLoadValue read FOnPropertyToXml write FOnPropertyToXml;
    property OnMappingProperty: TOnLoadValueMapping read FOnMappingProperty write FOnMappingProperty;
  end;

  TMapperObj = Class(TCustomMapperObj);

function GetURI(Const ARequest: TWebRequest): AnsiString;
function BuildXml(Const ABaliseName, AValues: array of String; Const AUri: String = ''; Const ASimpleText: Boolean = False): String;

implementation

function FiltreXML(const s : string):string;
// Fonction pour ajouter les caractère mal gérer en XML
var
  i : integer;
begin
  result := '';
  for i := 1 to length(s) do
  begin
    case s[i] of
      '&' : result := result +  '&amp;';
      else result := result + s[i];
    end;
  end;
end;

{ ===============================================================================
  procedure    : GetURI
  Description  : Normalisation d'un uri standard.
  =============================================================================== }
function GetURI(Const ARequest: TWebRequest): AnsiString;
begin
  Result := 'http://' + ARequest.RemoteHost + ARequest.PathInfo;
end;

{ ===============================================================================
  procedure    : BuildXml
  Description  : permet la construction générique d'une chaine "Balises et Valeurs"
                 au format XML.
                 Le parametre "AUri" permet d'inclure un "Uri" dans le flux. Si
                 ce parametre est vide la nom de balise du flux sera "result".
  INFO         : Si une valeur dans "AValues" est vide la balise n'apparaitra pas.
  =============================================================================== }
function BuildXml(Const ABaliseName, AValues: array of String; Const AUri: String = '';
  Const ASimpleText: Boolean = False): String;
var
  i     : integer;
  Buffer, vVal: String;
begin
  Result := '';
  Buffer := '';

  for i  := Low(AValues) to High(AValues) do
    begin
      if Trim(AValues[i]) <> '' then
        begin
          vVal:= AValues[i];
          vVal:= StringReplace(vVal, '<', '', [rfReplaceAll]);
          vVal:= StringReplace(vVal, '>', '', [rfReplaceAll]);
          Buffer := Buffer + Format(cBaliseValXml, [ABaliseName[i], vVal, ABaliseName[i]]);
        end;
    end;

  if AUri <> '' then
    Result := cHeaderBalise + cRC + UTF8Encode(Format(cBaliseURI, [AUri, Buffer]))
  else
    if not ASimpleText then
      Result := cHeaderBalise + cRC + UTF8Encode(Format(cBaliseResult, [Buffer]))
    else
      Result := cHeaderBalise + UTF8Encode(Buffer);
end;

{ TCustomParser }

procedure TCustomParser.ClearMemData;
begin
  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);
  FDataSet := TClientDataSet.Create(Self);
end;

constructor TCustomParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CoInitialize(nil);
  FXMLDoc           := TXMLDocument.Create(Self);
  FXMLDoc.DOMVendor := DOMVendors.Find('MSXML');
  FListFields       := TStringList.Create;
  FContentEncoding  := cDefaultEncoding;
  FSizeField        := cSizeField;
  FXmlREST          := True;
end;

destructor TCustomParser.Destroy;
begin
  FreeAndNil(FListFields);
  CoUnInitialize;
  inherited;
end;

procedure TCustomParser.DoOnLoadXMLInTable(AName: String; var Value: String);
begin
  if Assigned(FTOnLoadXMLInTable) then
    FTOnLoadXMLInTable(AName, Value);
end;

procedure TCustomParser.DoOnRecordToXml(AName: String; ADateType: TFieldType; var Value: String);
begin
  if Assigned(FOnRecordToXml) then
    FOnRecordToXml(AName, ADateType, Value);
end;

{ ===============================================================================
  procedure    : LoadListFields
  Description  : permet le chargement d'une liste de "Field" à partir des
  données XML.
  =============================================================================== }
procedure TCustomParser.LoadListFields(XMLNode: IXMLNode; AListFields: TStringList);
var
  i: integer;
begin
  if XMLNode.NodeType <> ntElement then
    Exit;
  if AListFields.IndexOf(XMLNode.NodeName) = -1 then
    AListFields.Add(XMLNode.NodeName);
  if XMLNode.HasChildNodes then
    begin
      for i := 0 to XMLNode.ChildNodes.Count - 1 do
        LoadListFields(XMLNode.ChildNodes.Nodes[i], AListFields);
    end;
end;

{ ===============================================================================
  procedure    : LoadListFieldsToTable
  Description  : Création des "Fields" dans le "DataSet" à partir de "AListFields"
  =============================================================================== }
procedure TCustomParser.LoadListFieldsToTable;
var
  i: integer;
begin
  ClearMemData;
  for i := 0 to FListFields.Count - 1 do
    FDataSet.FieldDefs.Add(FListFields.Strings[i], ftString, FSizeField);
  FDataSet.CreateDataSet;
end;

{ ===============================================================================
  procedure    : LoadXMLInTable
  Description  : Chargement des données dans le "DataSet" à partir du flux XML.
  =============================================================================== }
procedure TCustomParser.LoadXMLInTable(ADataSet: TDataSet; XMLNode: IXMLNode; ANodeAttrib: String);
var
  i                              : integer;
  vFieldName, vValue, vNodeAttrib: string;
  AttributNoeud                  : IXMLNode;
  vField                         : TField;
  vNodeTypes                     : TNodeTypes;
begin
  vNodeTypes   := [ntElement, ntCData];
  if not FXmlREST then
    vNodeTypes := [ntElement, ntCData];

  if not(XMLNode.NodeType in vNodeTypes) then
    Exit;

  if (XMLNode.IsTextElement) or (XMLNode.NodeType = ntCData) then
    begin
      vFieldName := XMLNode.NodeName;
      vField     := ADataSet.FindField(vFieldName);

      if (vField = nil) and (not FXmlREST) then
        begin
          vField     := ADataSet.FindField(XMLNode.ParentNode.NodeName);
          vFieldName := XMLNode.ParentNode.NodeName;
        end;

      if (vField <> nil) and (not VarIsNull(XMLNode.NodeValue)) then
        begin
          vValue := XMLNode.NodeValue;
          //if Pos(vValue, '#'+'38') <> 0 then
          //  vValue := StringReplace(vValue, '#38', '&', [rfReplaceAll]);

          DoOnLoadXMLInTable(vFieldName, vValue);
          ADataSet.Append;
          ADataSet.FieldByName(vFieldName).AsString := vValue;

          if (ADataSet.RecordCount < 1) and (not FXmlREST) then
            begin
              if XMLNode.IsTextElement then
                ADataSet.FieldByName(cFieldID).AsString := XMLNode.ParentNode.NodeName;
            end;

          ADataSet.Post;
        end;
    end;

  for i:= 0 to XMLNode.AttributeNodes.Count - 1 do
    begin
      AttributNoeud := XMLNode.AttributeNodes.Nodes[i];
      vNodeAttrib   := AttributNoeud.Text;
      vField        := ADataSet.FindField(cFieldID);
      if (vField <> nil) and (not VarIsNull(AttributNoeud.Text)) then
        begin
          DoOnLoadXMLInTable(vField.FieldName, vNodeAttrib);
          ADataSet.Append;
          ADataSet.FieldByName(cFieldID).AsString := vNodeAttrib;
          ADataSet.Post;
        end;
    end;

  if XMLNode.HasChildNodes then
    begin
      for i:= 0 to XMLNode.ChildNodes.Count - 1 do
        LoadXMLInTable(FDataSet, XMLNode.ChildNodes.Nodes[i], vNodeAttrib);
    end;
end;

function TCustomParser.RecordToXml(const ADataSet: TDataSet; Const AClassName: String; Const AListField: TStringList): String;
var
  i                       : integer;
  vFieldName, vValue, vXml: String;
  vAllow                  : Boolean;
begin
  Result := '';
  vAllow := True;
  for i:= 0 to ADataSet.FieldCount - 1 do
    begin
      if AListField <> nil then
        vAllow := AListField.IndexOf(ADataSet.Fields.Fields[i].FieldName) <> -1;

      if vAllow then
        begin
          vFieldName := ADataSet.Fields.Fields[i].FieldName;
          vValue     := ADataSet.Fields.Fields[i].AsString;
          DoOnRecordToXml(vFieldName, ADataSet.Fields.Fields[i].DataType, vValue);
          vXml       := vXml + Format(cBaliseValXml, [vFieldName, vValue, vFieldName]);
        end;
    end;
  Result := Format(cBaliseURI, [AClassName, vXml]);
end;

procedure TCustomParser.SetARequest(const Value: String);
var
  i     : integer;
  vSL   : TStringList;
  Buffer: String;
  vTypeEncoding: TEncodeType;
begin
  vSL:= TStringList.Create;
  try
    FARequest:= Value;
    FXMLDoc.XML.Clear;
    vTypeEncoding:= DetectUTF8Encoding(FARequest);
    if vTypeEncoding = etUTF8 then
      FARequest := UTF8Decode(FARequest);
    vSL.Text:= FARequest;
    for i:= 0 to vSL.Count - 1 do
      begin
        Buffer:= vSL.Strings[i];
        if Trim(Buffer) <> '' then
          begin
            if (Buffer[1] = '<') and (AnsiPos('>', Buffer) = 0) then
              Buffer := Buffer + '>';
          end;
        FXMLDoc.XML.Append(Buffer);
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

{ ===============================================================================
  procedure    : Execute
  Description  : Execute le parsing.
  =============================================================================== }
procedure TCustomParser.Execute(Const ASilentRaise: Boolean);
begin
  try
    FErreur := '';
    try
      if Trim(FARequest) = '' then
        Raise Exception.Create('Request empty');

      FListFields.Clear;
      FXMLDoc.Active := True;

      { Chargement des Fields dans FListFields }
      LoadListFields(FXMLDoc.DocumentElement, FListFields);
      if FListFields.IndexOf(cFieldID) = -1 then
        FListFields.Insert(0, cFieldID);

      { Création des Fields dans FDataSet }
      LoadListFieldsToTable;

      { Chargement des données XML dans le DataSet }
      LoadXMLInTable(FDataSet, FXMLDoc.DocumentElement);

      { Restructuration des données dans le DataSet }
      FinalizeParsing;

      FDataSet.First;
    except
      on E: Exception do
        begin
          FErreur := E.Message;
          if not ASilentRaise then
            Raise;
        end;
    end;
  finally
    FXMLDoc.Active := False;
  end;
end;

{ ===============================================================================
  procedure    : FinalizeParsing
  Description  : permet la restructuration des données pour les transferer dans
  un "DataSet".
  =============================================================================== }
procedure TCustomParser.FinalizeParsing;
var
  i                 : integer;
  vFieldName, vValue: String;
  vSL               : TStringList;

  { =============================================================================
    procedure    : AppendList
    Description  : permet le remplissage d'une liste (FieldName + Value) avec
    avec un record.
    ============================================================================= }
  procedure AppendList(AList: TStringList; const AFieldName, AValue: String; Const Allow: Boolean);
  var
    i         : integer;
    vExist    : Boolean;
    vNextValue: String;
  begin
    vExist:= False;
    for i:= 0 to AList.Count - 1 do
      begin
        vExist := Copy(AList.Strings[i], 1, Pos('=', AList.Strings[i]) - 1) = AFieldName;
        if vExist then
          begin
            if Allow then
              begin
                vNextValue       := Copy(AList.Strings[i], Pos('=', AList.Strings[i]) + 1, Length(AList.Strings[i]));
                AList.Strings[i] := AFieldName + '=' + AValue + #13#10 + vNextValue;
              end;
            Break;
          end;
      end;
    if not vExist then
      AList.Append(AFieldName + '=' + AValue);
  end;

{ =============================================================================
  procedure    : DeleteEmptyRecord
  Description  : permet la suppression des records vide.
  ============================================================================= }
  procedure DeleteEmptyRecord(const ADataSet: TDataSet);
  var
    i   : integer;
    vDel: Boolean;
  begin
    ADataSet.First;
    while not ADataSet.Eof do
      begin
        vDel:= False;
        for i:= 0 to ADataSet.FieldCount - 1 do
          begin
            vDel:= ADataSet.Fields.Fields[i].AsString = '';
            if not vDel then
              Break;
          end;
        if vDel then
          ADataSet.Delete
        else
          ADataSet.Next;
      end;
  end;

begin
  vSL := TStringList.Create;
  try
    ADataSet.Last;
    while not ADataSet.Bof do
      begin
        ADataSet.Edit;
        if ADataSet.FieldByName(cFieldID).AsString = '' then
          begin
            for i:= 1 to ADataSet.FieldCount - 1 do
              begin
                if ADataSet.Fields.Fields[i].AsString <> '' then
                  begin
                    AppendList(vSL, ADataSet.Fields.Fields[i].FieldName, ADataSet.Fields.Fields[i].AsString, not FXmlREST);
                    ADataSet.Fields.Fields[i].AsString := '';
                  end;
              end;
          end
        else
          begin
            for i:= 0 to vSL.Count - 1 do
              begin
                vFieldName:= Copy(vSL.Strings[i], 1, Pos('=', vSL.Strings[i]) - 1);
                vValue:= Copy(vSL.Strings[i], Pos('=', vSL.Strings[i]) + 1, Length(vSL.Strings[i]));
                if ADataSet.FieldByName(vFieldName) <> nil then
                  ADataSet.FieldByName(vFieldName).AsString := vValue;
              end;
            vSL.Clear;
          end;
        ADataSet.Post;
        ADataSet.Prior;
      end;
    DeleteEmptyRecord(FDataSet);
    FDataSet.FindField(cFieldID).Visible := not FXmlREST;
  finally
    FreeAndNil(vSL);
  end;
end;

{ TCustomMapperObj }

function TCustomMapperObj.BuilXmlItems(Const ARequest: TWebRequest; const Items: String): String;
var
  Buffer, vHeader: String;
begin
  vHeader := '';
  Buffer  := Items;
  Buffer  := Format(cBlsValXml, [cOrderItems, Buffer, cOrderItems]);
  if AParser.ContentEncoding <> '' then
    begin
      if AParser.ContentEncoding = cDefaultEncoding then
      begin
        Buffer  := UTF8Encode(Buffer);
        vHeader := cHeaderBalise + cRC;
      end;
    end;
  Result := vHeader + Format(cBaliseURI, [GetURI(ARequest), Buffer]);
end;

constructor TCustomMapperObj.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAParser := TParser.Create(Self);
end;

destructor TCustomMapperObj.Destroy;
begin
  // -->
  inherited;
end;

procedure TCustomMapperObj.DoOnMappingProperty(const AName: String; var Value: Variant);
begin
  if Assigned(FOnMappingProperty) then
    FOnMappingProperty(AName, Value);
end;

procedure TCustomMapperObj.DoOnPropertyToXml(const AName: String; var Value: String);
begin
  if Assigned(FOnPropertyToXml) then
    FOnPropertyToXml(AName, Value);
end;

{ ===============================================================================
  procedure    : MappingProperty
  Description  : permet le transfere des données du "DataSet" vers un Objet.
  =============================================================================== }
procedure TCustomMapperObj.MappingProperty(Const UdpObj: TComponent);
var
  i, vCpt   : integer;
  vPListInfo: PPropList;
  Buffer    : String;
  vField    : TField;
  vValue    : Variant;
begin
  vCpt:= GetPropList(UdpObj, vPListInfo);
  for i:= 0 to vCpt - 1 do
    begin
      if (UpperCase(vPListInfo[i].Name) <> 'NAME') and (UpperCase(vPListInfo[i].Name) <> 'TAG') then
        begin
          Buffer := vPListInfo[i].Name;
          vField := FAParser.ADataSet.FindField(Buffer);
          if vField <> nil then
            begin
              vValue := vField.Value;
              if VarIsNull(vValue) then
                begin
                  case vPListInfo[i]^.PropType^^.Kind of
                    tkInteger, tkFloat: vValue:= -1;
                    tkString, tkLString, tkWString: vValue:= '';
                    tkEnumeration : vValue := 0;
                  end;
                end;
              DoOnMappingProperty(Buffer, vValue);

              if Buffer = 'BJETON' then
                vValue := Boolean(vValue);

              //if GetPropValue(UdpObj, Buffer) then
                SetPropValue(UdpObj, Buffer, vValue);
            end;
        end;
    end;
end;

{ ===============================================================================
  procedure    : PropertyToXml
  Description  : permet la conversion des données d'un Objet en XML.
  =============================================================================== }
procedure TCustomMapperObj.PropertyToXml(Const UdpObj: TComponent; var AXml: String;
  Const ListField: TStringList);
var
  i, vIdx, vCpt : integer;
  vPListInfo    : PPropList;
  Buffer, vValue: String;
  vAllow        : Boolean;
  vSL           : TStringList;
begin
  vSL := nil;
  if (ListField <> nil) and (ListField.Count <> 0) then
    begin
      vSL      := TStringList.Create;
      vSL.Text := UpperCase(ListField.Text);
    end;
  try
    vAllow:= True;
    vCpt:= GetPropList(UdpObj, vPListInfo);
    for i:= 0 to vCpt - 1 do
      begin
        if (UpperCase(vPListInfo[i].Name) <> 'NAME') and (UpperCase(vPListInfo[i].Name) <> 'TAG') then
          begin
            if vSL <> nil then
              begin
                vIdx   := vSL.IndexOf(UpperCase(vPListInfo[i].Name));
                vAllow := vIdx <> -1;
                if vAllow then
                  vSL.Delete(vIdx);
              end;

            if vAllow then
              begin
                Buffer := UpperCase(vPListInfo[i].Name);
                if PropType(UdpObj, Buffer) = tkClass then
                  PropertyToXml(TComponent(GetObjectProp(UdpObj, Buffer)), AXml, ListField)
                else
                  begin
                    vValue := GetPropValue(UdpObj, Buffer);
                    DoOnPropertyToXml(Buffer, vValue);
                    if vValue <> '' then
                    begin
                      vValue := FiltreXML(vValue);
                      AXml := AXml + (Format(cBaliseValXml, [Buffer, vValue, Buffer]));
                    end;
                  end;
              end;
          end;
      end;
  finally
    if vSL <> nil then
      FreeAndNil(vSL);
  end;
end;

function GetModuleName: string;
var
  szFileName: array[0..MAX_PATH] of Char;
begin
  FillChar(szFileName, SizeOf(szFileName), #0);
  GetModuleFileName(hInstance, szFileName, MAX_PATH);
  Result := szFileName;
  if Copy(Result, 1, 4) = '\\?\' then
    Result := Copy(Result, 5, Length(Result));
end;

{ TCustomWSConfig }

constructor TCustomWSConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions      := TStringList.Create;
  FServiceName  := ChangeFileExt(ExtractFileName(GetModuleName), '');
  FServicePath  := ExtractFilePath(GetModuleName);
  FTraceur      := True;
  FVerbose      := false;
  FProfiling    := false;
  FLogOnStart   := False;
  FFileNameIni  := '';
  FFileNameDB   := '';
  FLogException := True;
end;

destructor TCustomWSConfig.Destroy;
begin
  FreeAndNil(FOptions);
  inherited Destroy;
end;

function TCustomWSConfig.GetServiceFileName: String;
begin
  Result   := '';
  if (FServiceName <> '') and (FServicePath <> '') then
    Result := FServicePathLog + FServiceName;
end;

function TCustomWSConfig.GetTime: String;
begin
  Result := '_' + FormatDateTime('hh_nn_ss_zzz', Now);
end;

procedure TCustomWSConfig.Load;
var
  i, j       : integer;
  vIniFile   : TIniFile;
  vSLSec, vSL: TStrings;
  vReg       : TRegistry;
  Buffer: String;
begin
  vReg := TRegistry.Create;
  try

    { ******* Probleme de lecture et ecriture de la Registry lié aux droits ******* }

    { Chargement du chemin du fichier de config du WebService depuis la registry }
    // vReg.RootKey:= HKEY_CURRENT_USER;
    // vReg.OpenKey('\ginkoia\WebService\' + FServiceName, True);
    // if vReg.ValueExists(cKeyPathIni) then
    // begin
    // FServicePath:= vReg.ReadString(cKeyPathIni);
    // if (Trim(FServicePath) <> '') and (FServicePath[Length(FServicePath)] <> '\') then
    // FServicePath:= FServicePath + '\';
    // end
    // else
    // vReg.WriteString(cKeyPathIni, '');

    { ***************************************************************************** }

    { En attendant de trouver la solution des droits de la Registry, les fichiers
      de config des Web Service devront etre dans le repertoire de IIS (c:\windows\system32\inetsrv\) }
    FFileNameIni := ExtractFilePath(ParamStr(0)) + FServiceName + '.ini';

    if not FileExists(FFileNameIni) then
      FFileNameIni := ChangeFileExt(GetModuleName, '.ini');

    if (FileNameIni <> '') and (FileExists(FFileNameIni)) then
      begin
        { Chargement du fichier de config }
        vIniFile := TIniFile.Create(FileNameIni);
        vSLSec   := TStringList.Create;
        vSL      := TStringList.Create;
        FOptions.Clear;
        try
          FServicePath      := vIniFile.ReadString(Sec_Gen, Itm_ServicePath, FServicePath);
          FServicePath      := IncludeTrailingPathDelimiter(FServicePath);
          FServicePathLog   := FServicePath + 'Log\';
          ForceDirectories(FServicePathLog);
          FileNameDB        := vIniFile.ReadString(Sec_Gen, Itm_FileNameDB, '');
          LoginDB           := vIniFile.ReadString(Sec_Gen, Itm_LoginDB, 'ginkoia');
          PasswordDB        := vIniFile.ReadString(Sec_Gen, Itm_PasswordDB, 'ginkoia');

          LogOnStart        := vIniFile.ReadBool(Sec_Log, Itm_LogOnStart, LogOnStart);
          LogException      := vIniFile.ReadBool(Sec_Log, Itm_LogException, LogException);
          Traceur           := vIniFile.ReadBool(Sec_Log, Itm_Traceur, Traceur);
          FVerbose          := vIniFile.ReadBool(Sec_Log, Itm_Verbose, FVerbose);
          FProfiling        := vIniFile.ReadBool(Sec_Log, Itm_Profiling, FProfiling);
          FPathXMLClgLocal  := vIniFile.ReadString(Sec_Gen, Itm_PathXMLClgLocal, '');
          FPathXMLClgReseau := vIniFile.ReadString(Sec_Gen, Itm_PathXMLClgReseau, '');

          if FPathXMLClgReseau = '' then
            FPathXMLClgReseau := FPathXMLClgLocal;


          { La property "Options" doit rester generique, c'est la raison pour
            laquelle on charge toutes les keys <> "Sec_Gen" et "Sec_Log" }
          vIniFile.ReadSections(vSLSec);
          for i := 0 to vSLSec.Count - 1 do
            begin
              if (vSLSec.Strings[i] <> Sec_Gen) and (vSLSec.Strings[i] <> Sec_Log) then
                begin
                  vIniFile.ReadSection(vSLSec.Strings[i], vSL);
                  for j:= 0 to vSL.Count -1 do
                    begin
                      Buffer:= vIniFile.ReadString(vSLSec.Strings[i], vSL.Strings[j], '');
                      if Buffer <> '' then
                        FOptions.Append(vSL.Strings[j] + '=' + Buffer);
                    end;
                end;
            end;
        finally
          FreeAndNil(vIniFile);
          FreeAndNil(vSLSec);
          FreeAndNil(vSL);
        end;
      end;
  finally
    FreeAndNil(vReg);
  end;
end;

procedure TCustomWSConfig.SaveFile(Const FileName: String; const ASL: TStringList; Const Allow: Boolean);
begin
  if not Allow then
    Exit;
  if DirectoryExists(ExtractFilePath(FileName)) then
    ASL.SaveToFile(FileName)
  else
    { Permet la creation d'un fichier quand le chemin n'existe pas }
    ASL.SaveToFile('C:\' + ExtractFileName(FileName));
end;

end.

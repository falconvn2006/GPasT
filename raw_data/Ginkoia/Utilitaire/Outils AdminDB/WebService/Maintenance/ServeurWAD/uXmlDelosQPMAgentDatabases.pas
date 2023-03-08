
{********************************************************************}
{                                                                    }
{                       Liaison de données XML                       }
{                                                                    }
{         Généré le : 10/09/2013 10:45:22                            }
{       Généré depuis : D:\EAI\V11_1_0\DelosQPMAgent.Databases.xml   }
{                                                                    }
{********************************************************************}

unit uXmlDelosQPMAgentDatabases;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLDataSourcesType = interface;
  IXMLDataSourceType = interface;
  IXMLParamsType = interface;
  IXMLParamType = interface;

{ IXMLDataSourcesType }

  IXMLDataSourcesType = interface(IXMLNodeCollection)
    ['{37C308D3-76BE-46D6-9D7B-377E7B4A0BB9}']
    { Accesseurs de propriétés }
    function Get_DataSource(Index: Integer): IXMLDataSourceType;
    { Méthodes & propriétés }
    function Add: IXMLDataSourceType;
    function Insert(const Index: Integer): IXMLDataSourceType;
    property DataSource[Index: Integer]: IXMLDataSourceType read Get_DataSource; default;
  end;

{ IXMLDataSourceType }

  IXMLDataSourceType = interface(IXMLNode)
    ['{0DEC4BEA-95CF-4149-ADAE-DCC075DB9FC6}']
    { Accesseurs de propriétés }
    function Get_Name: UnicodeString;
    function Get_Connected: UnicodeString;
    function Get_KeepConnection: UnicodeString;
    function Get_Middleware: UnicodeString;
    function Get_Params: IXMLParamsType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Connected(Value: UnicodeString);
    procedure Set_KeepConnection(Value: UnicodeString);
    procedure Set_Middleware(Value: UnicodeString);
    { Méthodes & propriétés }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Connected: UnicodeString read Get_Connected write Set_Connected;
    property KeepConnection: UnicodeString read Get_KeepConnection write Set_KeepConnection;
    property Middleware: UnicodeString read Get_Middleware write Set_Middleware;
    property Params: IXMLParamsType read Get_Params;
  end;

{ IXMLParamsType }

  IXMLParamsType = interface(IXMLNodeCollection)
    ['{A40ACEB1-1752-4920-B5FC-796946C4C5A0}']
    { Accesseurs de propriétés }
    function Get_Param(Index: Integer): IXMLParamType;
    { Méthodes & propriétés }
    function Add: IXMLParamType;
    function Insert(const Index: Integer): IXMLParamType;
    property Param[Index: Integer]: IXMLParamType read Get_Param; default;
  end;

{ IXMLParamType }

  IXMLParamType = interface(IXMLNode)
    ['{D197C382-2F2A-4A3E-A16A-1261AE51136A}']
    { Accesseurs de propriétés }
    function Get_Name: UnicodeString;
    function Get_Value: UnicodeString;
    function Get_LastBCK: UnicodeString;
    function Get_LastTIME: UnicodeString;
    function Get_LastRESULT: UnicodeString;
    function Get_REFERENCER: UnicodeString;
    function Get_NO_IP: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Value(Value: UnicodeString);
    procedure Set_LastBCK(Value: UnicodeString);
    procedure Set_LastTIME(Value: UnicodeString);
    procedure Set_LastRESULT(Value: UnicodeString);
    procedure Set_REFERENCER(Value: UnicodeString);
    procedure Set_NO_IP(Value: UnicodeString);
    { Méthodes & propriétés }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Value: UnicodeString read Get_Value write Set_Value;
    property LastBCK: UnicodeString read Get_LastBCK write Set_LastBCK;
    property LastTIME: UnicodeString read Get_LastTIME write Set_LastTIME;
    property LastRESULT: UnicodeString read Get_LastRESULT write Set_LastRESULT;
    property REFERENCER: UnicodeString read Get_REFERENCER write Set_REFERENCER;
    property NO_IP: UnicodeString read Get_NO_IP write Set_NO_IP;
  end;

{ Décl. Forward }

  TXMLDataSourcesType = class;
  TXMLDataSourceType = class;
  TXMLParamsType = class;
  TXMLParamType = class;

{ TXMLDataSourcesType }

  TXMLDataSourcesType = class(TXMLNodeCollection, IXMLDataSourcesType)
  protected
    { IXMLDataSourcesType }
    function Get_DataSource(Index: Integer): IXMLDataSourceType;
    function Add: IXMLDataSourceType;
    function Insert(const Index: Integer): IXMLDataSourceType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDataSourceType }

  TXMLDataSourceType = class(TXMLNode, IXMLDataSourceType)
  protected
    { IXMLDataSourceType }
    function Get_Name: UnicodeString;
    function Get_Connected: UnicodeString;
    function Get_KeepConnection: UnicodeString;
    function Get_Middleware: UnicodeString;
    function Get_Params: IXMLParamsType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Connected(Value: UnicodeString);
    procedure Set_KeepConnection(Value: UnicodeString);
    procedure Set_Middleware(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLParamsType }

  TXMLParamsType = class(TXMLNodeCollection, IXMLParamsType)
  protected
    { IXMLParamsType }
    function Get_Param(Index: Integer): IXMLParamType;
    function Add: IXMLParamType;
    function Insert(const Index: Integer): IXMLParamType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLParamType }

  TXMLParamType = class(TXMLNode, IXMLParamType)
  protected
    { IXMLParamType }
    function Get_Name: UnicodeString;
    function Get_Value: UnicodeString;
    function Get_LastBCK: UnicodeString;
    function Get_LastTIME: UnicodeString;
    function Get_LastRESULT: UnicodeString;
    function Get_REFERENCER: UnicodeString;
    function Get_NO_IP: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Value(Value: UnicodeString);
    procedure Set_LastBCK(Value: UnicodeString);
    procedure Set_LastTIME(Value: UnicodeString);
    procedure Set_LastRESULT(Value: UnicodeString);
    procedure Set_REFERENCER(Value: UnicodeString);
    procedure Set_NO_IP(Value: UnicodeString);
  end;

{ Fonctions globales }

function GetDataSources(Doc: IXMLDocument): IXMLDataSourcesType;
function LoadDataSources(const FileName: string): IXMLDataSourcesType;
function NewDataSources: IXMLDataSourcesType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetDataSources(Doc: IXMLDocument): IXMLDataSourcesType;
begin
  Result := Doc.GetDocBinding('DataSources', TXMLDataSourcesType, TargetNamespace) as IXMLDataSourcesType;
end;

function LoadDataSources(const FileName: string): IXMLDataSourcesType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DataSources', TXMLDataSourcesType, TargetNamespace) as IXMLDataSourcesType;
end;

function NewDataSources: IXMLDataSourcesType;
begin
  Result := NewXMLDocument.GetDocBinding('DataSources', TXMLDataSourcesType, TargetNamespace) as IXMLDataSourcesType;
end;

{ TXMLDataSourcesType }

procedure TXMLDataSourcesType.AfterConstruction;
begin
  RegisterChildNode('DataSource', TXMLDataSourceType);
  ItemTag := 'DataSource';
  ItemInterface := IXMLDataSourceType;
  inherited;
end;

function TXMLDataSourcesType.Get_DataSource(Index: Integer): IXMLDataSourceType;
begin
  Result := List[Index] as IXMLDataSourceType;
end;

function TXMLDataSourcesType.Add: IXMLDataSourceType;
begin
  Result := AddItem(-1) as IXMLDataSourceType;
end;

function TXMLDataSourcesType.Insert(const Index: Integer): IXMLDataSourceType;
begin
  Result := AddItem(Index) as IXMLDataSourceType;
end;

{ TXMLDataSourceType }

procedure TXMLDataSourceType.AfterConstruction;
begin
  RegisterChildNode('Params', TXMLParamsType);
  inherited;
end;

function TXMLDataSourceType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLDataSourceType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLDataSourceType.Get_Connected: UnicodeString;
begin
  Result := ChildNodes['Connected'].Text;
end;

procedure TXMLDataSourceType.Set_Connected(Value: UnicodeString);
begin
  ChildNodes['Connected'].NodeValue := Value;
end;

function TXMLDataSourceType.Get_KeepConnection: UnicodeString;
begin
  Result := ChildNodes['KeepConnection'].Text;
end;

procedure TXMLDataSourceType.Set_KeepConnection(Value: UnicodeString);
begin
  ChildNodes['KeepConnection'].NodeValue := Value;
end;

function TXMLDataSourceType.Get_Middleware: UnicodeString;
begin
  Result := ChildNodes['Middleware'].Text;
end;

procedure TXMLDataSourceType.Set_Middleware(Value: UnicodeString);
begin
  ChildNodes['Middleware'].NodeValue := Value;
end;

function TXMLDataSourceType.Get_Params: IXMLParamsType;
begin
  Result := ChildNodes['Params'] as IXMLParamsType;
end;

{ TXMLParamsType }

procedure TXMLParamsType.AfterConstruction;
begin
  RegisterChildNode('Param', TXMLParamType);
  ItemTag := 'Param';
  ItemInterface := IXMLParamType;
  inherited;
end;

function TXMLParamsType.Get_Param(Index: Integer): IXMLParamType;
begin
  Result := List[Index] as IXMLParamType;
end;

function TXMLParamsType.Add: IXMLParamType;
begin
  Result := AddItem(-1) as IXMLParamType;
end;

function TXMLParamsType.Insert(const Index: Integer): IXMLParamType;
begin
  Result := AddItem(Index) as IXMLParamType;
end;

{ TXMLParamType }

function TXMLParamType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLParamType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLParamType.Get_Value: UnicodeString;
begin
  Result := ChildNodes['Value'].Text;
end;

procedure TXMLParamType.Set_Value(Value: UnicodeString);
begin
  ChildNodes['Value'].NodeValue := Value;
end;

function TXMLParamType.Get_LastBCK: UnicodeString;
begin
  Result := ChildNodes['lastBCK'].Text;
end;

procedure TXMLParamType.Set_LastBCK(Value: UnicodeString);
begin
  ChildNodes['lastBCK'].NodeValue := Value;
end;

function TXMLParamType.Get_LastTIME: UnicodeString;
begin
  Result := ChildNodes['lastTIME'].Text;
end;

procedure TXMLParamType.Set_LastTIME(Value: UnicodeString);
begin
  ChildNodes['lastTIME'].NodeValue := Value;
end;

function TXMLParamType.Get_LastRESULT: UnicodeString;
begin
  Result := ChildNodes['lastRESULT'].Text;
end;

procedure TXMLParamType.Set_LastRESULT(Value: UnicodeString);
begin
  ChildNodes['lastRESULT'].NodeValue := Value;
end;

function TXMLParamType.Get_REFERENCER: UnicodeString;
begin
  Result := ChildNodes['REFERENCER'].Text;
end;

procedure TXMLParamType.Set_REFERENCER(Value: UnicodeString);
begin
  ChildNodes['REFERENCER'].NodeValue := Value;
end;

function TXMLParamType.Get_NO_IP: UnicodeString;
begin
  Result := ChildNodes['NO_IP'].Text;
end;

procedure TXMLParamType.Set_NO_IP(Value: UnicodeString);
begin
  ChildNodes['NO_IP'].NodeValue := Value;
end;

end.
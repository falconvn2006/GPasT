
{************************************************************************}
{                                                                        }
{                         Liaison de données XML                         }
{                                                                        }
{         Généré le : 19/09/2013 09:33:31                                }
{       Généré depuis : D:\Tech\V12_1_0Bin\DelosQPMAgent.Providers.xml   }
{                                                                        }
{************************************************************************}

unit uXmlDelosQPMAgentProviders;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLProvidersType = interface;
  IXMLProviderType = interface;

{ IXMLProvidersType }

  IXMLProvidersType = interface(IXMLNodeCollection)
    ['{53633ABE-AE7A-45CA-8FB2-4ACE15C85749}']
    { Accesseurs de propriétés }
    function Get_Provider(Index: Integer): IXMLProviderType;
    { Méthodes & propriétés }
    function Add: IXMLProviderType;
    function Insert(const Index: Integer): IXMLProviderType;
    property Provider[Index: Integer]: IXMLProviderType read Get_Provider; default;
  end;

{ IXMLProviderType }

  IXMLProviderType = interface(IXMLNode)
    ['{57362437-5106-4662-92C8-859B99EEB8A4}']
    { Accesseurs de propriétés }
    function Get_Name: UnicodeString;
    function Get_Group: UnicodeString;
    function Get_Generator: UnicodeString;
    function Get_MIN_ID: Integer;
    function Get_MAX_ID: Integer;
    function Get_LAST_VERSION: UnicodeString;
    function Get_XMLServiceExtract: UnicodeString;
    function Get_XMLServiceBatch: UnicodeString;
    function Get_URL: UnicodeString;
    function Get_UserName: UnicodeString;
    function Get_Password: UnicodeString;
    function Get_Sender: UnicodeString;
    function Get_Zip: Integer;
    function Get_Database: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Group(Value: UnicodeString);
    procedure Set_Generator(Value: UnicodeString);
    procedure Set_MIN_ID(Value: Integer);
    procedure Set_MAX_ID(Value: Integer);
    procedure Set_LAST_VERSION(Value: UnicodeString);
    procedure Set_XMLServiceExtract(Value: UnicodeString);
    procedure Set_XMLServiceBatch(Value: UnicodeString);
    procedure Set_URL(Value: UnicodeString);
    procedure Set_UserName(Value: UnicodeString);
    procedure Set_Password(Value: UnicodeString);
    procedure Set_Sender(Value: UnicodeString);
    procedure Set_Zip(Value: Integer);
    procedure Set_Database(Value: UnicodeString);
    { Méthodes & propriétés }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Group: UnicodeString read Get_Group write Set_Group;
    property Generator: UnicodeString read Get_Generator write Set_Generator;
    property MIN_ID: Integer read Get_MIN_ID write Set_MIN_ID;
    property MAX_ID: Integer read Get_MAX_ID write Set_MAX_ID;
    property LAST_VERSION: UnicodeString read Get_LAST_VERSION write Set_LAST_VERSION;
    property XMLServiceExtract: UnicodeString read Get_XMLServiceExtract write Set_XMLServiceExtract;
    property XMLServiceBatch: UnicodeString read Get_XMLServiceBatch write Set_XMLServiceBatch;
    property URL: UnicodeString read Get_URL write Set_URL;
    property UserName: UnicodeString read Get_UserName write Set_UserName;
    property Password: UnicodeString read Get_Password write Set_Password;
    property Sender: UnicodeString read Get_Sender write Set_Sender;
    property Zip: Integer read Get_Zip write Set_Zip;
    property Database: UnicodeString read Get_Database write Set_Database;
  end;

{ Décl. Forward }

  TXMLProvidersType = class;
  TXMLProviderType = class;

{ TXMLProvidersType }

  TXMLProvidersType = class(TXMLNodeCollection, IXMLProvidersType)
  protected
    { IXMLProvidersType }
    function Get_Provider(Index: Integer): IXMLProviderType;
    function Add: IXMLProviderType;
    function Insert(const Index: Integer): IXMLProviderType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLProviderType }

  TXMLProviderType = class(TXMLNode, IXMLProviderType)
  protected
    { IXMLProviderType }
    function Get_Name: UnicodeString;
    function Get_Group: UnicodeString;
    function Get_Generator: UnicodeString;
    function Get_MIN_ID: Integer;
    function Get_MAX_ID: Integer;
    function Get_LAST_VERSION: UnicodeString;
    function Get_XMLServiceExtract: UnicodeString;
    function Get_XMLServiceBatch: UnicodeString;
    function Get_URL: UnicodeString;
    function Get_UserName: UnicodeString;
    function Get_Password: UnicodeString;
    function Get_Sender: UnicodeString;
    function Get_Zip: Integer;
    function Get_Database: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Group(Value: UnicodeString);
    procedure Set_Generator(Value: UnicodeString);
    procedure Set_MIN_ID(Value: Integer);
    procedure Set_MAX_ID(Value: Integer);
    procedure Set_LAST_VERSION(Value: UnicodeString);
    procedure Set_XMLServiceExtract(Value: UnicodeString);
    procedure Set_XMLServiceBatch(Value: UnicodeString);
    procedure Set_URL(Value: UnicodeString);
    procedure Set_UserName(Value: UnicodeString);
    procedure Set_Password(Value: UnicodeString);
    procedure Set_Sender(Value: UnicodeString);
    procedure Set_Zip(Value: Integer);
    procedure Set_Database(Value: UnicodeString);
  end;

{ Fonctions globales }

function GetProviders(Doc: IXMLDocument): IXMLProvidersType;
function LoadProviders(const FileName: string): IXMLProvidersType;
function NewProviders: IXMLProvidersType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetProviders(Doc: IXMLDocument): IXMLProvidersType;
begin
  Result := Doc.GetDocBinding('Providers', TXMLProvidersType, TargetNamespace) as IXMLProvidersType;
end;

function LoadProviders(const FileName: string): IXMLProvidersType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Providers', TXMLProvidersType, TargetNamespace) as IXMLProvidersType;
end;

function NewProviders: IXMLProvidersType;
begin
  Result := NewXMLDocument.GetDocBinding('Providers', TXMLProvidersType, TargetNamespace) as IXMLProvidersType;
end;

{ TXMLProvidersType }

procedure TXMLProvidersType.AfterConstruction;
begin
  RegisterChildNode('Provider', TXMLProviderType);
  ItemTag := 'Provider';
  ItemInterface := IXMLProviderType;
  inherited;
end;

function TXMLProvidersType.Get_Provider(Index: Integer): IXMLProviderType;
begin
  Result := List[Index] as IXMLProviderType;
end;

function TXMLProvidersType.Add: IXMLProviderType;
begin
  Result := AddItem(-1) as IXMLProviderType;
end;

function TXMLProvidersType.Insert(const Index: Integer): IXMLProviderType;
begin
  Result := AddItem(Index) as IXMLProviderType;
end;

{ TXMLProviderType }

function TXMLProviderType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLProviderType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLProviderType.Get_Group: UnicodeString;
begin
  Result := ChildNodes['Group'].Text;
end;

procedure TXMLProviderType.Set_Group(Value: UnicodeString);
begin
  ChildNodes['Group'].NodeValue := Value;
end;

function TXMLProviderType.Get_Generator: UnicodeString;
begin
  Result := ChildNodes['Generator'].Text;
end;

procedure TXMLProviderType.Set_Generator(Value: UnicodeString);
begin
  ChildNodes['Generator'].NodeValue := Value;
end;

function TXMLProviderType.Get_MIN_ID: Integer;
begin
  Result := ChildNodes['MIN_ID'].NodeValue;
end;

procedure TXMLProviderType.Set_MIN_ID(Value: Integer);
begin
  ChildNodes['MIN_ID'].NodeValue := Value;
end;

function TXMLProviderType.Get_MAX_ID: Integer;
begin
  Result := ChildNodes['MAX_ID'].NodeValue;
end;

procedure TXMLProviderType.Set_MAX_ID(Value: Integer);
begin
  ChildNodes['MAX_ID'].NodeValue := Value;
end;

function TXMLProviderType.Get_LAST_VERSION: UnicodeString;
begin
  Result := ChildNodes['LAST_VERSION'].Text;
end;

procedure TXMLProviderType.Set_LAST_VERSION(Value: UnicodeString);
begin
  ChildNodes['LAST_VERSION'].NodeValue := Value;
end;

function TXMLProviderType.Get_XMLServiceExtract: UnicodeString;
begin
  Result := ChildNodes['XMLServiceExtract'].Text;
end;

procedure TXMLProviderType.Set_XMLServiceExtract(Value: UnicodeString);
begin
  ChildNodes['XMLServiceExtract'].NodeValue := Value;
end;

function TXMLProviderType.Get_XMLServiceBatch: UnicodeString;
begin
  Result := ChildNodes['XMLServiceBatch'].Text;
end;

procedure TXMLProviderType.Set_XMLServiceBatch(Value: UnicodeString);
begin
  ChildNodes['XMLServiceBatch'].NodeValue := Value;
end;

function TXMLProviderType.Get_URL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLProviderType.Set_URL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

function TXMLProviderType.Get_UserName: UnicodeString;
begin
  Result := ChildNodes['UserName'].Text;
end;

procedure TXMLProviderType.Set_UserName(Value: UnicodeString);
begin
  ChildNodes['UserName'].NodeValue := Value;
end;

function TXMLProviderType.Get_Password: UnicodeString;
begin
  Result := ChildNodes['Password'].Text;
end;

procedure TXMLProviderType.Set_Password(Value: UnicodeString);
begin
  ChildNodes['Password'].NodeValue := Value;
end;

function TXMLProviderType.Get_Sender: UnicodeString;
begin
  Result := ChildNodes['Sender'].Text;
end;

procedure TXMLProviderType.Set_Sender(Value: UnicodeString);
begin
  ChildNodes['Sender'].NodeValue := Value;
end;

function TXMLProviderType.Get_Zip: Integer;
begin
  Result := ChildNodes['Zip'].NodeValue;
end;

procedure TXMLProviderType.Set_Zip(Value: Integer);
begin
  ChildNodes['Zip'].NodeValue := Value;
end;

function TXMLProviderType.Get_Database: UnicodeString;
begin
  Result := ChildNodes['Database'].Text;
end;

procedure TXMLProviderType.Set_Database(Value: UnicodeString);
begin
  ChildNodes['Database'].NodeValue := Value;
end;

end.
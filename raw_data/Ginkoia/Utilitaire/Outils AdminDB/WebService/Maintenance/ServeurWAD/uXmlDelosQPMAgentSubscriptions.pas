
{****************************************************************************}
{                                                                            }
{                           Liaison de données XML                           }
{                                                                            }
{         Généré le : 19/09/2013 09:34:12                                    }
{       Généré depuis : D:\Tech\V12_1_0Bin\DelosQPMAgent.Subscriptions.xml   }
{                                                                            }
{****************************************************************************}

unit uXmlDelosQPMAgentSubscriptions;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLSubscriptionsType = interface;
  IXMLSubscriptionType = interface;

{ IXMLSubscriptionsType }

  IXMLSubscriptionsType = interface(IXMLNodeCollection)
    ['{8F81C61D-1E37-4AF7-9F34-BF08B59D85E1}']
    { Accesseurs de propriétés }
    function Get_Subscription(Index: Integer): IXMLSubscriptionType;
    { Méthodes & propriétés }
    function Add: IXMLSubscriptionType;
    function Insert(const Index: Integer): IXMLSubscriptionType;
    property Subscription[Index: Integer]: IXMLSubscriptionType read Get_Subscription; default;
  end;

{ IXMLSubscriptionType }

  IXMLSubscriptionType = interface(IXMLNode)
    ['{95B69EB2-A907-4916-A349-4E95B24998A2}']
    { Accesseurs de propriétés }
    function Get_Subscription: UnicodeString;
    function Get_Provider: UnicodeString;
    function Get_Subscriber: UnicodeString;
    function Get_Sender: UnicodeString;
    function Get_LAST_VERSION: UnicodeString;
    function Get_URL: UnicodeString;
    function Get_UserName: UnicodeString;
    function Get_Password: UnicodeString;
    function Get_XMLServiceBatch: UnicodeString;
    function Get_Zip: Integer;
    function Get_Database: UnicodeString;
    function Get_GetCurrentVersion: UnicodeString;
    function Get_Generator: UnicodeString;
    function Get_Group: UnicodeString;
    procedure Set_Subscription(Value: UnicodeString);
    procedure Set_Provider(Value: UnicodeString);
    procedure Set_Subscriber(Value: UnicodeString);
    procedure Set_Sender(Value: UnicodeString);
    procedure Set_LAST_VERSION(Value: UnicodeString);
    procedure Set_URL(Value: UnicodeString);
    procedure Set_UserName(Value: UnicodeString);
    procedure Set_Password(Value: UnicodeString);
    procedure Set_XMLServiceBatch(Value: UnicodeString);
    procedure Set_Zip(Value: Integer);
    procedure Set_Database(Value: UnicodeString);
    procedure Set_GetCurrentVersion(Value: UnicodeString);
    procedure Set_Generator(Value: UnicodeString);
    procedure Set_Group(Value: UnicodeString);
    { Méthodes & propriétés }
    property Subscription: UnicodeString read Get_Subscription write Set_Subscription;
    property Provider: UnicodeString read Get_Provider write Set_Provider;
    property Subscriber: UnicodeString read Get_Subscriber write Set_Subscriber;
    property Sender: UnicodeString read Get_Sender write Set_Sender;
    property LAST_VERSION: UnicodeString read Get_LAST_VERSION write Set_LAST_VERSION;
    property URL: UnicodeString read Get_URL write Set_URL;
    property UserName: UnicodeString read Get_UserName write Set_UserName;
    property Password: UnicodeString read Get_Password write Set_Password;
    property XMLServiceBatch: UnicodeString read Get_XMLServiceBatch write Set_XMLServiceBatch;
    property Zip: Integer read Get_Zip write Set_Zip;
    property Database: UnicodeString read Get_Database write Set_Database;
    property GetCurrentVersion: UnicodeString read Get_GetCurrentVersion write Set_GetCurrentVersion;
    property Generator: UnicodeString read Get_Generator write Set_Generator;
    property Group: UnicodeString read Get_Group write Set_Group;
  end;

{ Décl. Forward }

  TXMLSubscriptionsType = class;
  TXMLSubscriptionType = class;

{ TXMLSubscriptionsType }

  TXMLSubscriptionsType = class(TXMLNodeCollection, IXMLSubscriptionsType)
  protected
    { IXMLSubscriptionsType }
    function Get_Subscription(Index: Integer): IXMLSubscriptionType;
    function Add: IXMLSubscriptionType;
    function Insert(const Index: Integer): IXMLSubscriptionType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSubscriptionType }

  TXMLSubscriptionType = class(TXMLNode, IXMLSubscriptionType)
  protected
    { IXMLSubscriptionType }
    function Get_Subscription: UnicodeString;
    function Get_Provider: UnicodeString;
    function Get_Subscriber: UnicodeString;
    function Get_Sender: UnicodeString;
    function Get_LAST_VERSION: UnicodeString;
    function Get_URL: UnicodeString;
    function Get_UserName: UnicodeString;
    function Get_Password: UnicodeString;
    function Get_XMLServiceBatch: UnicodeString;
    function Get_Zip: Integer;
    function Get_Database: UnicodeString;
    function Get_GetCurrentVersion: UnicodeString;
    function Get_Generator: UnicodeString;
    function Get_Group: UnicodeString;
    procedure Set_Subscription(Value: UnicodeString);
    procedure Set_Provider(Value: UnicodeString);
    procedure Set_Subscriber(Value: UnicodeString);
    procedure Set_Sender(Value: UnicodeString);
    procedure Set_LAST_VERSION(Value: UnicodeString);
    procedure Set_URL(Value: UnicodeString);
    procedure Set_UserName(Value: UnicodeString);
    procedure Set_Password(Value: UnicodeString);
    procedure Set_XMLServiceBatch(Value: UnicodeString);
    procedure Set_Zip(Value: Integer);
    procedure Set_Database(Value: UnicodeString);
    procedure Set_GetCurrentVersion(Value: UnicodeString);
    procedure Set_Generator(Value: UnicodeString);
    procedure Set_Group(Value: UnicodeString);
  end;

{ Fonctions globales }

function GetSubscriptions(Doc: IXMLDocument): IXMLSubscriptionsType;
function LoadSubscriptions(const FileName: string): IXMLSubscriptionsType;
function NewSubscriptions: IXMLSubscriptionsType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetSubscriptions(Doc: IXMLDocument): IXMLSubscriptionsType;
begin
  Result := Doc.GetDocBinding('Subscriptions', TXMLSubscriptionsType, TargetNamespace) as IXMLSubscriptionsType;
end;

function LoadSubscriptions(const FileName: string): IXMLSubscriptionsType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Subscriptions', TXMLSubscriptionsType, TargetNamespace) as IXMLSubscriptionsType;
end;

function NewSubscriptions: IXMLSubscriptionsType;
begin
  Result := NewXMLDocument.GetDocBinding('Subscriptions', TXMLSubscriptionsType, TargetNamespace) as IXMLSubscriptionsType;
end;

{ TXMLSubscriptionsType }

procedure TXMLSubscriptionsType.AfterConstruction;
begin
  RegisterChildNode('Subscription', TXMLSubscriptionType);
  ItemTag := 'Subscription';
  ItemInterface := IXMLSubscriptionType;
  inherited;
end;

function TXMLSubscriptionsType.Get_Subscription(Index: Integer): IXMLSubscriptionType;
begin
  Result := List[Index] as IXMLSubscriptionType;
end;

function TXMLSubscriptionsType.Add: IXMLSubscriptionType;
begin
  Result := AddItem(-1) as IXMLSubscriptionType;
end;

function TXMLSubscriptionsType.Insert(const Index: Integer): IXMLSubscriptionType;
begin
  Result := AddItem(Index) as IXMLSubscriptionType;
end;

{ TXMLSubscriptionType }

function TXMLSubscriptionType.Get_Subscription: UnicodeString;
begin
  Result := ChildNodes['Subscription'].Text;
end;

procedure TXMLSubscriptionType.Set_Subscription(Value: UnicodeString);
begin
  ChildNodes['Subscription'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Provider: UnicodeString;
begin
  Result := ChildNodes['Provider'].Text;
end;

procedure TXMLSubscriptionType.Set_Provider(Value: UnicodeString);
begin
  ChildNodes['Provider'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Subscriber: UnicodeString;
begin
  Result := ChildNodes['Subscriber'].Text;
end;

procedure TXMLSubscriptionType.Set_Subscriber(Value: UnicodeString);
begin
  ChildNodes['Subscriber'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Sender: UnicodeString;
begin
  Result := ChildNodes['Sender'].Text;
end;

procedure TXMLSubscriptionType.Set_Sender(Value: UnicodeString);
begin
  ChildNodes['Sender'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_LAST_VERSION: UnicodeString;
begin
  Result := ChildNodes['LAST_VERSION'].Text;
end;

procedure TXMLSubscriptionType.Set_LAST_VERSION(Value: UnicodeString);
begin
  ChildNodes['LAST_VERSION'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_URL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLSubscriptionType.Set_URL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_UserName: UnicodeString;
begin
  Result := ChildNodes['UserName'].Text;
end;

procedure TXMLSubscriptionType.Set_UserName(Value: UnicodeString);
begin
  ChildNodes['UserName'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Password: UnicodeString;
begin
  Result := ChildNodes['Password'].Text;
end;

procedure TXMLSubscriptionType.Set_Password(Value: UnicodeString);
begin
  ChildNodes['Password'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_XMLServiceBatch: UnicodeString;
begin
  Result := ChildNodes['XMLServiceBatch'].Text;
end;

procedure TXMLSubscriptionType.Set_XMLServiceBatch(Value: UnicodeString);
begin
  ChildNodes['XMLServiceBatch'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Zip: Integer;
begin
  Result := ChildNodes['Zip'].NodeValue;
end;

procedure TXMLSubscriptionType.Set_Zip(Value: Integer);
begin
  ChildNodes['Zip'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Database: UnicodeString;
begin
  Result := ChildNodes['Database'].Text;
end;

procedure TXMLSubscriptionType.Set_Database(Value: UnicodeString);
begin
  ChildNodes['Database'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_GetCurrentVersion: UnicodeString;
begin
  Result := ChildNodes['GetCurrentVersion'].Text;
end;

procedure TXMLSubscriptionType.Set_GetCurrentVersion(Value: UnicodeString);
begin
  ChildNodes['GetCurrentVersion'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Generator: UnicodeString;
begin
  Result := ChildNodes['Generator'].Text;
end;

procedure TXMLSubscriptionType.Set_Generator(Value: UnicodeString);
begin
  ChildNodes['Generator'].NodeValue := Value;
end;

function TXMLSubscriptionType.Get_Group: UnicodeString;
begin
  Result := ChildNodes['Group'].Text;
end;

procedure TXMLSubscriptionType.Set_Group(Value: UnicodeString);
begin
  ChildNodes['Group'].NodeValue := Value;
end;

end.
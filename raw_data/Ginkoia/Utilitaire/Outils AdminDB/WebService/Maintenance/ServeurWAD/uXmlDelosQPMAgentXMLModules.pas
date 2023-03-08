
{*********************************************************************************************************}
{                                                                                                         }
{                                         Liaison de données XML                                          }
{                                                                                                         }
{         Généré le : 23/12/2013 18:14:50                                                                 }
{       Généré depuis : D:\EAI\V_DOSSIERS\[V_DOSSIER] Dossier vierge\DelosQPMAgent.XMLModules.xml         }
{   Paramètres stockés dans : D:\EAI\V_DOSSIERS\[V_DOSSIER] Dossier vierge\DelosQPMAgent.XMLModules.xdb   }
{                                                                                                         }
{*********************************************************************************************************}

unit uXmlDelosQPMAgentXMLModules;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLXMLModulesType = interface;
  IXMLXMLModuleType = interface;
  IXMLImportType = interface;

{ IXMLXMLModulesType }

  IXMLXMLModulesType = interface(IXMLNodeCollection)
    ['{14FB09F0-2EFF-4F45-BFE9-5A613C9F06A8}']
    { Accesseurs de propriétés }
    function Get_XMLModule(Index: Integer): IXMLXMLModuleType;
    { Méthodes & propriétés }
    function Add: IXMLXMLModuleType;
    function Insert(const Index: Integer): IXMLXMLModuleType;
    property XMLModule[Index: Integer]: IXMLXMLModuleType read Get_XMLModule; default;
  end;

{ IXMLXMLModuleType }

  IXMLXMLModuleType = interface(IXMLNode)
    ['{97C8995E-E57A-4456-9E7A-DFB2562DAB4C}']
    { Accesseurs de propriétés }
    function Get_Name: UnicodeString;
    function Get_XMLPath: UnicodeString;
    function Get_Import: IXMLImportType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_XMLPath(Value: UnicodeString);
    { Méthodes & propriétés }
    property Name: UnicodeString read Get_Name write Set_Name;
    property XMLPath: UnicodeString read Get_XMLPath write Set_XMLPath;
    property Import: IXMLImportType read Get_Import;
  end;

{ IXMLImportType }

  IXMLImportType = interface(IXMLNode)
    ['{4AD12C99-241E-487A-9D54-94E097363FBE}']
    { Accesseurs de propriétés }
    function Get_HRef: UnicodeString;
    function Get_NodePath: UnicodeString;
    procedure Set_HRef(Value: UnicodeString);
    procedure Set_NodePath(Value: UnicodeString);
    { Méthodes & propriétés }
    property HRef: UnicodeString read Get_HRef write Set_HRef;
    property NodePath: UnicodeString read Get_NodePath write Set_NodePath;
  end;

{ Décl. Forward }

  TXMLXMLModulesType = class;
  TXMLXMLModuleType = class;
  TXMLImportType = class;

{ TXMLXMLModulesType }

  TXMLXMLModulesType = class(TXMLNodeCollection, IXMLXMLModulesType)
  protected
    { IXMLXMLModulesType }
    function Get_XMLModule(Index: Integer): IXMLXMLModuleType;
    function Add: IXMLXMLModuleType;
    function Insert(const Index: Integer): IXMLXMLModuleType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLXMLModuleType }

  TXMLXMLModuleType = class(TXMLNode, IXMLXMLModuleType)
  protected
    { IXMLXMLModuleType }
    function Get_Name: UnicodeString;
    function Get_XMLPath: UnicodeString;
    function Get_Import: IXMLImportType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_XMLPath(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLImportType }

  TXMLImportType = class(TXMLNode, IXMLImportType)
  protected
    { IXMLImportType }
    function Get_HRef: UnicodeString;
    function Get_NodePath: UnicodeString;
    procedure Set_HRef(Value: UnicodeString);
    procedure Set_NodePath(Value: UnicodeString);
  end;

{ Fonctions globales }

function GetXMLModules(Doc: IXMLDocument): IXMLXMLModulesType;
function LoadXMLModules(const FileName: string): IXMLXMLModulesType;
function NewXMLModules: IXMLXMLModulesType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetXMLModules(Doc: IXMLDocument): IXMLXMLModulesType;
begin
  Result := Doc.GetDocBinding('XMLModules', TXMLXMLModulesType, TargetNamespace) as IXMLXMLModulesType;
end;

function LoadXMLModules(const FileName: string): IXMLXMLModulesType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('XMLModules', TXMLXMLModulesType, TargetNamespace) as IXMLXMLModulesType;
end;

function NewXMLModules: IXMLXMLModulesType;
begin
  Result := NewXMLDocument.GetDocBinding('XMLModules', TXMLXMLModulesType, TargetNamespace) as IXMLXMLModulesType;
end;

{ TXMLXMLModulesType }

procedure TXMLXMLModulesType.AfterConstruction;
begin
  RegisterChildNode('XMLModule', TXMLXMLModuleType);
  ItemTag := 'XMLModule';
  ItemInterface := IXMLXMLModuleType;
  inherited;
end;

function TXMLXMLModulesType.Get_XMLModule(Index: Integer): IXMLXMLModuleType;
begin
  Result := List[Index] as IXMLXMLModuleType;
end;

function TXMLXMLModulesType.Add: IXMLXMLModuleType;
begin
  Result := AddItem(-1) as IXMLXMLModuleType;
end;

function TXMLXMLModulesType.Insert(const Index: Integer): IXMLXMLModuleType;
begin
  Result := AddItem(Index) as IXMLXMLModuleType;
end;

{ TXMLXMLModuleType }

procedure TXMLXMLModuleType.AfterConstruction;
begin
  RegisterChildNode('Import', TXMLImportType);
  inherited;
end;

function TXMLXMLModuleType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLXMLModuleType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLXMLModuleType.Get_XMLPath: UnicodeString;
begin
  Result := ChildNodes['XMLPath'].Text;
end;

procedure TXMLXMLModuleType.Set_XMLPath(Value: UnicodeString);
begin
  ChildNodes['XMLPath'].NodeValue := Value;
end;

function TXMLXMLModuleType.Get_Import: IXMLImportType;
begin
  Result := ChildNodes['Import'] as IXMLImportType;
end;

{ TXMLImportType }

function TXMLImportType.Get_HRef: UnicodeString;
begin
  Result := ChildNodes['HRef'].Text;
end;

procedure TXMLImportType.Set_HRef(Value: UnicodeString);
begin
  ChildNodes['HRef'].NodeValue := Value;
end;

function TXMLImportType.Get_NodePath: UnicodeString;
begin
  Result := ChildNodes['NodePath'].Text;
end;

procedure TXMLImportType.Set_NodePath(Value: UnicodeString);
begin
  ChildNodes['NodePath'].NodeValue := Value;
end;

end.
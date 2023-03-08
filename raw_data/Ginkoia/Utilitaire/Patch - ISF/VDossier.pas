
{********************************************************************************************}
{                                                                                            }
{                                   Liaison de données XML                                   }
{                                                                                            }
{         Généré le : 19/09/2017 17:06:54                                                    }
{       Généré depuis : C:\Developpement\Ginkoia\UTILITAIRE\Patch - ISF\VDossier.xml         }
{   Paramètres stockés dans : C:\Developpement\Ginkoia\UTILITAIRE\Patch - ISF\VDossier.xdb   }
{                                                                                            }
{********************************************************************************************}

unit VDossier;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLCENTRALESType = interface;
  IXMLCENTRALEType = interface;
  IXMLORDRESType = interface;
  IXMLORDREType = interface;

{ IXMLCENTRALESType }

  IXMLCENTRALESType = interface(IXMLNodeCollection)
    ['{DE96230B-3629-497F-A877-681F56533EA6}']
    { Accesseurs de propriétés }
    function Get_CENTRALE(Index: Integer): IXMLCENTRALEType;
    { Méthodes & propriétés }
    function Add: IXMLCENTRALEType;
    function Insert(const Index: Integer): IXMLCENTRALEType;
    property CENTRALE[Index: Integer]: IXMLCENTRALEType read Get_CENTRALE; default;
  end;

{ IXMLCENTRALEType }

  IXMLCENTRALEType = interface(IXMLNode)
    ['{7C937C36-DCB8-449E-9DAA-F68814DD7B0E}']
    { Accesseurs de propriétés }
    function Get_NOM: UnicodeString;
    function Get_ORDRES: IXMLORDRESType;
    procedure Set_NOM(Value: UnicodeString);
    { Méthodes & propriétés }
    property NOM: UnicodeString read Get_NOM write Set_NOM;
    property ORDRES: IXMLORDRESType read Get_ORDRES;
  end;

{ IXMLORDRESType }

  IXMLORDRESType = interface(IXMLNodeCollection)
    ['{2E9C774A-C0A0-47AD-A101-232DDCE176EC}']
    { Accesseurs de propriétés }
    function Get_ORDRE(Index: Integer): IXMLORDREType;
    { Méthodes & propriétés }
    function Add: IXMLORDREType;
    function Insert(const Index: Integer): IXMLORDREType;
    property ORDRE[Index: Integer]: IXMLORDREType read Get_ORDRE; default;
  end;

{ IXMLORDREType }

  IXMLORDREType = interface(IXMLNode)
    ['{254E833B-0E3B-4EBA-853B-F67FFDDD1F8E}']
    { Accesseurs de propriétés }
    function Get_NOM: UnicodeString;
    function Get_TYPE_: UnicodeString;
    function Get_DATA: UnicodeString;
    procedure Set_NOM(Value: UnicodeString);
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_DATA(Value: UnicodeString);
    { Méthodes & propriétés }
    property NOM: UnicodeString read Get_NOM write Set_NOM;
    property TYPE_: UnicodeString read Get_TYPE_ write Set_TYPE_;
    property DATA: UnicodeString read Get_DATA write Set_DATA;
  end;

{ Décl. Forward }

  TXMLCENTRALESType = class;
  TXMLCENTRALEType = class;
  TXMLORDRESType = class;
  TXMLORDREType = class;

{ TXMLCENTRALESType }

  TXMLCENTRALESType = class(TXMLNodeCollection, IXMLCENTRALESType)
  protected
    { IXMLCENTRALESType }
    function Get_CENTRALE(Index: Integer): IXMLCENTRALEType;
    function Add: IXMLCENTRALEType;
    function Insert(const Index: Integer): IXMLCENTRALEType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCENTRALEType }

  TXMLCENTRALEType = class(TXMLNode, IXMLCENTRALEType)
  protected
    { IXMLCENTRALEType }
    function Get_NOM: UnicodeString;
    function Get_ORDRES: IXMLORDRESType;
    procedure Set_NOM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLORDRESType }

  TXMLORDRESType = class(TXMLNodeCollection, IXMLORDRESType)
  protected
    { IXMLORDRESType }
    function Get_ORDRE(Index: Integer): IXMLORDREType;
    function Add: IXMLORDREType;
    function Insert(const Index: Integer): IXMLORDREType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLORDREType }

  TXMLORDREType = class(TXMLNode, IXMLORDREType)
  protected
    { IXMLORDREType }
    function Get_NOM: UnicodeString;
    function Get_TYPE_: UnicodeString;
    function Get_DATA: UnicodeString;
    procedure Set_NOM(Value: UnicodeString);
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_DATA(Value: UnicodeString);
  end;

{ Fonctions globales }

function GetCENTRALES(Doc: IXMLDocument): IXMLCENTRALESType;
function LoadCENTRALES(const FileName: string): IXMLCENTRALESType;
function NewCENTRALES: IXMLCENTRALESType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetCENTRALES(Doc: IXMLDocument): IXMLCENTRALESType;
begin
  Result := Doc.GetDocBinding('CENTRALES', TXMLCENTRALESType, TargetNamespace) as IXMLCENTRALESType;
end;

function LoadCENTRALES(const FileName: string): IXMLCENTRALESType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('CENTRALES', TXMLCENTRALESType, TargetNamespace) as IXMLCENTRALESType;
end;

function NewCENTRALES: IXMLCENTRALESType;
begin
  Result := NewXMLDocument.GetDocBinding('CENTRALES', TXMLCENTRALESType, TargetNamespace) as IXMLCENTRALESType;
end;

{ TXMLCENTRALESType }

procedure TXMLCENTRALESType.AfterConstruction;
begin
  RegisterChildNode('CENTRALE', TXMLCENTRALEType);
  ItemTag := 'CENTRALE';
  ItemInterface := IXMLCENTRALEType;
  inherited;
end;

function TXMLCENTRALESType.Get_CENTRALE(Index: Integer): IXMLCENTRALEType;
begin
  Result := List[Index] as IXMLCENTRALEType;
end;

function TXMLCENTRALESType.Add: IXMLCENTRALEType;
begin
  Result := AddItem(-1) as IXMLCENTRALEType;
end;

function TXMLCENTRALESType.Insert(const Index: Integer): IXMLCENTRALEType;
begin
  Result := AddItem(Index) as IXMLCENTRALEType;
end;

{ TXMLCENTRALEType }

procedure TXMLCENTRALEType.AfterConstruction;
begin
  RegisterChildNode('ORDRES', TXMLORDRESType);
  inherited;
end;

function TXMLCENTRALEType.Get_NOM: UnicodeString;
begin
  Result := ChildNodes['NOM'].Text;
end;

procedure TXMLCENTRALEType.Set_NOM(Value: UnicodeString);
begin
  ChildNodes['NOM'].NodeValue := Value;
end;

function TXMLCENTRALEType.Get_ORDRES: IXMLORDRESType;
begin
  Result := ChildNodes['ORDRES'] as IXMLORDRESType;
end;

{ TXMLORDRESType }

procedure TXMLORDRESType.AfterConstruction;
begin
  RegisterChildNode('ORDRE', TXMLORDREType);
  ItemTag := 'ORDRE';
  ItemInterface := IXMLORDREType;
  inherited;
end;

function TXMLORDRESType.Get_ORDRE(Index: Integer): IXMLORDREType;
begin
  Result := List[Index] as IXMLORDREType;
end;

function TXMLORDRESType.Add: IXMLORDREType;
begin
  Result := AddItem(-1) as IXMLORDREType;
end;

function TXMLORDRESType.Insert(const Index: Integer): IXMLORDREType;
begin
  Result := AddItem(Index) as IXMLORDREType;
end;

{ TXMLORDREType }

function TXMLORDREType.Get_NOM: UnicodeString;
begin
  Result := ChildNodes['NOM'].Text;
end;

procedure TXMLORDREType.Set_NOM(Value: UnicodeString);
begin
  ChildNodes['NOM'].NodeValue := Value;
end;

function TXMLORDREType.Get_TYPE_: UnicodeString;
begin
  Result := ChildNodes['TYPE'].Text;
end;

procedure TXMLORDREType.Set_TYPE_(Value: UnicodeString);
begin
  ChildNodes['TYPE'].NodeValue := Value;
end;

function TXMLORDREType.Get_DATA: UnicodeString;
begin
  Result := ChildNodes['DATA'].Text;
end;

procedure TXMLORDREType.Set_DATA(Value: UnicodeString);
begin
  ChildNodes['DATA'].NodeValue := Value;
end;

end.
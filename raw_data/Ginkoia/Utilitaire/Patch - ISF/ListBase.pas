
{********************************************************************************************}
{                                                                                            }
{                                   Liaison de données XML                                   }
{                                                                                            }
{         Généré le : 30/11/2016 10:12:21                                                    }
{       Généré depuis : C:\Developpement\Ginkoia\UTILITAIRE\Patch - ISF\ListBase.xml         }
{   Paramètres stockés dans : C:\Developpement\Ginkoia\UTILITAIRE\Patch - ISF\ListBase.xdb   }
{                                                                                            }
{********************************************************************************************}

unit ListBase;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLDossiersType = interface;
  IXMLDossierType = interface;

{ IXMLDossiersType }

  IXMLDossiersType = interface(IXMLNodeCollection)
    ['{7F8009EB-6FA3-4386-A0EF-7DC4D69FE3FA}']
    { Accesseurs de propriétés }
    function Get_Dossier(Index: Integer): IXMLDossierType;
    { Méthodes & propriétés }
    function Add: IXMLDossierType;
    function Insert(const Index: Integer): IXMLDossierType;
    property Dossier[Index: Integer]: IXMLDossierType read Get_Dossier; default;
  end;

{ IXMLDossierType }

  IXMLDossierType = interface(IXMLNode)
    ['{32F3D12D-23C2-40E5-98BC-A405FF44CD65}']
    { Accesseurs de propriétés }
    function Get_Name: UnicodeString;
    function Get_Centrale: UnicodeString;
    function Get_Version: UnicodeString;
    function Get_Serveur: UnicodeString;
    function Get_Base: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Centrale(Value: UnicodeString);
    procedure Set_Version(Value: UnicodeString);
    procedure Set_Serveur(Value: UnicodeString);
    procedure Set_Base(Value: UnicodeString);
    { Méthodes & propriétés }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Centrale: UnicodeString read Get_Centrale write Set_Centrale;
    property Version: UnicodeString read Get_Version write Set_Version;
    property Serveur: UnicodeString read Get_Serveur write Set_Serveur;
    property Base: UnicodeString read Get_Base write Set_Base;
  end;

{ Décl. Forward }

  TXMLDossiersType = class;
  TXMLDossierType = class;

{ TXMLDossiersType }

  TXMLDossiersType = class(TXMLNodeCollection, IXMLDossiersType)
  protected
    { IXMLDossiersType }
    function Get_Dossier(Index: Integer): IXMLDossierType;
    function Add: IXMLDossierType;
    function Insert(const Index: Integer): IXMLDossierType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDossierType }

  TXMLDossierType = class(TXMLNode, IXMLDossierType)
  protected
    { IXMLDossierType }
    function Get_Name: UnicodeString;
    function Get_Centrale: UnicodeString;
    function Get_Version: UnicodeString;
    function Get_Serveur: UnicodeString;
    function Get_Base: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Centrale(Value: UnicodeString);
    procedure Set_Version(Value: UnicodeString);
    procedure Set_Serveur(Value: UnicodeString);
    procedure Set_Base(Value: UnicodeString);
  end;

{ Fonctions globales }

function GetDossiers(Doc: IXMLDocument): IXMLDossiersType;
function LoadDossiers(const FileName: string): IXMLDossiersType;
function NewDossiers: IXMLDossiersType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetDossiers(Doc: IXMLDocument): IXMLDossiersType;
begin
  Result := Doc.GetDocBinding('Dossiers', TXMLDossiersType, TargetNamespace) as IXMLDossiersType;
end;

function LoadDossiers(const FileName: string): IXMLDossiersType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Dossiers', TXMLDossiersType, TargetNamespace) as IXMLDossiersType;
end;

function NewDossiers: IXMLDossiersType;
begin
  Result := NewXMLDocument.GetDocBinding('Dossiers', TXMLDossiersType, TargetNamespace) as IXMLDossiersType;
end;

{ TXMLDossiersType }

procedure TXMLDossiersType.AfterConstruction;
begin
  RegisterChildNode('Dossier', TXMLDossierType);
  ItemTag := 'Dossier';
  ItemInterface := IXMLDossierType;
  inherited;
end;

function TXMLDossiersType.Get_Dossier(Index: Integer): IXMLDossierType;
begin
  Result := List[Index] as IXMLDossierType;
end;

function TXMLDossiersType.Add: IXMLDossierType;
begin
  Result := AddItem(-1) as IXMLDossierType;
end;

function TXMLDossiersType.Insert(const Index: Integer): IXMLDossierType;
begin
  Result := AddItem(Index) as IXMLDossierType;
end;

{ TXMLDossierType }

function TXMLDossierType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLDossierType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLDossierType.Get_Centrale: UnicodeString;
begin
  Result := ChildNodes['Centrale'].Text;
end;

procedure TXMLDossierType.Set_Centrale(Value: UnicodeString);
begin
  ChildNodes['Centrale'].NodeValue := Value;
end;

function TXMLDossierType.Get_Version: UnicodeString;
begin
  Result := ChildNodes['Version'].Text;
end;

procedure TXMLDossierType.Set_Version(Value: UnicodeString);
begin
  ChildNodes['Version'].NodeValue := Value;
end;

function TXMLDossierType.Get_Serveur: UnicodeString;
begin
  Result := ChildNodes['Serveur'].Text;
end;

procedure TXMLDossierType.Set_Serveur(Value: UnicodeString);
begin
  ChildNodes['Serveur'].NodeValue := Value;
end;

function TXMLDossierType.Get_Base: UnicodeString;
begin
  Result := ChildNodes['Base'].Text;
end;

procedure TXMLDossierType.Set_Base(Value: UnicodeString);
begin
  ChildNodes['Base'].NodeValue := Value;
end;

end.
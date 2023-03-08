
{*********************************************}
{                                             }
{           Liaison de données XML            }
{                                             }
{         Généré le : 23/05/2018 11:51:54     }
{       Généré depuis : F:\refDyn.xml         }
{   Paramètres stockés dans : F:\refDyn.xdb   }
{                                             }
{*********************************************}

unit refDynSP2K_XmlToObj;
interface

uses xmldom, XMLDoc, XMLIntf;
type

{ Décl. Forward }

  IXMLLISTE_ITEMType = interface;
  IXMLITEMType = interface;
  IXMLTAILLESType = interface;
  IXMLTAILLEType = interface;
  IXMLTARIFSType = interface;
  IXMLTARIFType = interface;
  IXMLTARIFTypeList = interface;
  IXMLCOULEURSType = interface;
  IXMLCOULEURType = interface;
  IXMLCODEBARRESType = interface;
  IXMLCODEBARREType = interface;

{ IXMLLISTE_ITEMType }

  IXMLLISTE_ITEMType = interface(IXMLNode)
    ['{637C6465-1E26-4D8B-8D6C-B9AC10266243}']
    { Accesseurs de propriétés }
    function Get_ITEM: IXMLITEMType;
    { Méthodes & propriétés }
    property ITEM: IXMLITEMType read Get_ITEM;
  end;

{ IXMLITEMType }

  IXMLITEMType = interface(IXMLNode)
    ['{65A92156-BEB4-47D7-9CAD-FDFBFD3FB63A}']
    { Accesseurs de propriétés }
    function Get_RefREFART: Integer;
    function Get_AnneeReference: Integer;
    function Get_COLLECTION: WideString;
    function Get_Saison: WideString;
    function Get_Designation: WideString;
    function Get_Descriptif: WideString;
    function Get_IDMARQUE: Integer;
    function Get_NomMarque: WideString;
    function Get_Pack: Integer;
    function Get_GENRESP2K: WideString;
    function Get_Sexe: Integer;
    function Get_Type_: WideString;
    function Get_RefGrilleTaille: Integer;
    function Get_DesignationTaille: WideString;
    function Get_TAILLES: IXMLTAILLESType;
    function Get_TARIFS: IXMLTARIFSType;
    function Get_RefOperation: Integer;
    function Get_CodeCategorieFedas: Integer;
    function Get_CodeActiviteFedas: Integer;
    function Get_CodeGroupeFedas: Integer;
    function Get_CodeGenreFedas: Integer;
    function Get_CodeFedas: Integer;
    function Get_CodeGescom: WideString;
    function Get_COULEURS: IXMLCOULEURSType;
    function Get_CODEBARRES: IXMLCODEBARRESType;
    function Get_CATMAN: Integer;
    function Get_REFERENCECENTRALE: Integer;
    function Get_MONDOVELO: WideString;
    procedure Set_RefREFART(Value: Integer);
    procedure Set_AnneeReference(Value: Integer);
    procedure Set_COLLECTION(Value: WideString);
    procedure Set_Saison(Value: WideString);
    procedure Set_Designation(Value: WideString);
    procedure Set_Descriptif(Value: WideString);
    procedure Set_IDMARQUE(Value: Integer);
    procedure Set_NomMarque(Value: WideString);
    procedure Set_Pack(Value: Integer);
    procedure Set_GENRESP2K(Value: WideString);
    procedure Set_Sexe(Value: Integer);
    procedure Set_Type_(Value: WideString);
    procedure Set_RefGrilleTaille(Value: Integer);
    procedure Set_DesignationTaille(Value: WideString);
    procedure Set_RefOperation(Value: Integer);
    procedure Set_CodeCategorieFedas(Value: Integer);
    procedure Set_CodeActiviteFedas(Value: Integer);
    procedure Set_CodeGroupeFedas(Value: Integer);
    procedure Set_CodeGenreFedas(Value: Integer);
    procedure Set_CodeFedas(Value: Integer);
    procedure Set_CodeGescom(Value: WideString);
    procedure Set_CATMAN(Value: Integer);
    procedure Set_REFERENCECENTRALE(Value: Integer);
    procedure Set_MONDOVELO(Value: WideString);
    { Méthodes & propriétés }
    property RefREFART: Integer read Get_RefREFART write Set_RefREFART;
    property AnneeReference: Integer read Get_AnneeReference write Set_AnneeReference;
    property COLLECTION: WideString read Get_COLLECTION write Set_COLLECTION;
    property Saison: WideString read Get_Saison write Set_Saison;
    property Designation: WideString read Get_Designation write Set_Designation;
    property Descriptif: WideString read Get_Descriptif write Set_Descriptif;
    property IDMARQUE: Integer read Get_IDMARQUE write Set_IDMARQUE;
    property NomMarque: WideString read Get_NomMarque write Set_NomMarque;
    property Pack: Integer read Get_Pack write Set_Pack;
    property GENRESP2K: WideString read Get_GENRESP2K write Set_GENRESP2K;
    property Sexe: Integer read Get_Sexe write Set_Sexe;
    property Type_: WideString read Get_Type_ write Set_Type_;
    property RefGrilleTaille: Integer read Get_RefGrilleTaille write Set_RefGrilleTaille;
    property DesignationTaille: WideString read Get_DesignationTaille write Set_DesignationTaille;
    property TAILLES: IXMLTAILLESType read Get_TAILLES;
    property TARIFS: IXMLTARIFSType read Get_TARIFS;
    property RefOperation: Integer read Get_RefOperation write Set_RefOperation;
    property CodeCategorieFedas: Integer read Get_CodeCategorieFedas write Set_CodeCategorieFedas;
    property CodeActiviteFedas: Integer read Get_CodeActiviteFedas write Set_CodeActiviteFedas;
    property CodeGroupeFedas: Integer read Get_CodeGroupeFedas write Set_CodeGroupeFedas;
    property CodeGenreFedas: Integer read Get_CodeGenreFedas write Set_CodeGenreFedas;
    property CodeFedas: Integer read Get_CodeFedas write Set_CodeFedas;
    property CodeGescom: WideString read Get_CodeGescom write Set_CodeGescom;
    property COULEURS: IXMLCOULEURSType read Get_COULEURS;
    property CODEBARRES: IXMLCODEBARRESType read Get_CODEBARRES;
    property CATMAN: Integer read Get_CATMAN write Set_CATMAN;
    property REFERENCECENTRALE: Integer read Get_REFERENCECENTRALE write Set_REFERENCECENTRALE;
    property MONDOVELO: WideString read Get_MONDOVELO write Set_MONDOVELO;
  end;

{ IXMLTAILLESType }

  IXMLTAILLESType = interface(IXMLNodeCollection)
    ['{5616AEE7-A48F-4470-96E7-7F2A1F180D12}']
    { Accesseurs de propriétés }
    function Get_TAILLE(Index: Integer): IXMLTAILLEType;
    { Méthodes & propriétés }
    function Add: IXMLTAILLEType;
    function Insert(const Index: Integer): IXMLTAILLEType;
    property TAILLE[Index: Integer]: IXMLTAILLEType read Get_TAILLE; default;
  end;

{ IXMLTAILLEType }

  IXMLTAILLEType = interface(IXMLNode)
    ['{24FF1D42-0356-4534-9360-9918F6928EDC}']
    { Accesseurs de propriétés }
    function Get_CODE: Integer;
    function Get_CODETAILLE: Integer;
    function Get_NOM: WideString;
    function Get_RANGTAILLE: Integer;
    function Get_EQUIVALENCETAILLEF: WideString;
    procedure Set_CODE(Value: Integer);
    procedure Set_CODETAILLE(Value: Integer);
    procedure Set_NOM(Value: WideString);
    procedure Set_RANGTAILLE(Value: Integer);
    procedure Set_EQUIVALENCETAILLEF(Value: WideString);
    { Méthodes & propriétés }
    property CODE: Integer read Get_CODE write Set_CODE;
    property CODETAILLE: Integer read Get_CODETAILLE write Set_CODETAILLE;
    property NOM: WideString read Get_NOM write Set_NOM;
    property RANGTAILLE: Integer read Get_RANGTAILLE write Set_RANGTAILLE;
    property EQUIVALENCETAILLEF: WideString read Get_EQUIVALENCETAILLEF write Set_EQUIVALENCETAILLEF;
  end;

{ IXMLTARIFSType }

  IXMLTARIFSType = interface(IXMLNodeCollection)
    ['{93611B40-F712-44ED-8848-9C83248F1889}']
    { Accesseurs de propriétés }
    function Get_TARIF(Index: Integer): IXMLTARIFType;
    { Méthodes & propriétés }
    function Add: IXMLTARIFType;
    function Insert(const Index: Integer): IXMLTARIFType;
    property TARIF[Index: Integer]: IXMLTARIFType read Get_TARIF; default;
  end;

{ IXMLTARIFType }

  IXMLTARIFType = interface(IXMLNode)
    ['{3BB5C274-2BAE-467C-A0B9-0708AEF5C6FA}']
    { Accesseurs de propriétés }
    function Get_IDFOURNISSEUR: Integer;
    function Get_Fournisseur: WideString;
    function Get_ADR1_Fournisseur: WideString;
    function Get_ADR2_Fournisseur: WideString;
    function Get_CODEPOSTAL_Fournisseur: WideString;
    function Get_VILLE_Fournisseur: WideString;
    function Get_PATARIF: WideString;
    function Get_PVI: WideString;
    function Get_PANET: WideString;
    function Get_PCESSION: WideString;
    function Get_PBARRE: WideString;
    function Get_PxNormalFournisseur: WideString;
    function Get_REMISE: WideString;
    procedure Set_IDFOURNISSEUR(Value: Integer);
    procedure Set_Fournisseur(Value: WideString);
    procedure Set_ADR1_Fournisseur(Value: WideString);
    procedure Set_ADR2_Fournisseur(Value: WideString);
    procedure Set_CODEPOSTAL_Fournisseur(Value: WideString);
    procedure Set_VILLE_Fournisseur(Value: WideString);
    procedure Set_PATARIF(Value: WideString);
    procedure Set_PVI(Value: WideString);
    procedure Set_PANET(Value: WideString);
    procedure Set_PCESSION(Value: WideString);
    procedure Set_PBARRE(Value: WideString);
    procedure Set_PxNormalFournisseur(Value: WideString);
    procedure Set_REMISE(Value: WideString);
    { Méthodes & propriétés }
    property IDFOURNISSEUR: Integer read Get_IDFOURNISSEUR write Set_IDFOURNISSEUR;
    property Fournisseur: WideString read Get_Fournisseur write Set_Fournisseur;
    property ADR1_Fournisseur: WideString read Get_ADR1_Fournisseur write Set_ADR1_Fournisseur;
    property ADR2_Fournisseur: WideString read Get_ADR2_Fournisseur write Set_ADR2_Fournisseur;
    property CODEPOSTAL_Fournisseur: WideString read Get_CODEPOSTAL_Fournisseur write Set_CODEPOSTAL_Fournisseur;
    property VILLE_Fournisseur: WideString read Get_VILLE_Fournisseur write Set_VILLE_Fournisseur;
    property PATARIF: WideString read Get_PATARIF write Set_PATARIF;
    property PVI: WideString read Get_PVI write Set_PVI;
    property PANET: WideString read Get_PANET write Set_PANET;
    property PCESSION: WideString read Get_PCESSION write Set_PCESSION;
    property PBARRE: WideString read Get_PBARRE write Set_PBARRE;
    property PxNormalFournisseur: WideString read Get_PxNormalFournisseur write Set_PxNormalFournisseur;
    property REMISE: WideString read Get_REMISE write Set_REMISE;
  end;

{ IXMLTARIFTypeList }

  IXMLTARIFTypeList = interface(IXMLNodeCollection)
    ['{E1C94E8F-DDBB-46E6-ACB4-AA8B83ABDE94}']
    { Méthodes & propriétés }
    function Add: IXMLTARIFType;
    function Insert(const Index: Integer): IXMLTARIFType;
    function Get_Item(Index: Integer): IXMLTARIFType;
    property Items[Index: Integer]: IXMLTARIFType read Get_Item; default;
  end;

{ IXMLCOULEURSType }

  IXMLCOULEURSType = interface(IXMLNodeCollection)
    ['{D9E98610-74B3-4E91-AA9C-D41E1C3E396B}']
    { Accesseurs de propriétés }
    function Get_COULEUR(Index: Integer): IXMLCOULEURType;
    { Méthodes & propriétés }
    function Add: IXMLCOULEURType;
    function Insert(const Index: Integer): IXMLCOULEURType;
    property COULEUR[Index: Integer]: IXMLCOULEURType read Get_COULEUR; default;
  end;

{ IXMLCOULEURType }

  IXMLCOULEURType = interface(IXMLNode)
    ['{59F6FCC3-4B45-4271-951D-708361562799}']
    { Accesseurs de propriétés }
    function Get_IDCOLORIS: Integer;
    function Get_CODECOLORIS: Integer;
    function Get_DESCRIPTIF: WideString;
    procedure Set_IDCOLORIS(Value: Integer);
    procedure Set_CODECOLORIS(Value: Integer);
    procedure Set_DESCRIPTIF(Value: WideString);
    { Méthodes & propriétés }
    property IDCOLORIS: Integer read Get_IDCOLORIS write Set_IDCOLORIS;
    property CODECOLORIS: Integer read Get_CODECOLORIS write Set_CODECOLORIS;
    property DESCRIPTIF: WideString read Get_DESCRIPTIF write Set_DESCRIPTIF;
  end;

{ IXMLCODEBARRESType }

  IXMLCODEBARRESType = interface(IXMLNodeCollection)
    ['{A7997A75-18AF-4C02-A444-4615B0A7FE03}']
    { Accesseurs de propriétés }
    function Get_CODEBARRE(Index: Integer): IXMLCODEBARREType;
    { Méthodes & propriétés }
    function Add: IXMLCODEBARREType;
    function Insert(const Index: Integer): IXMLCODEBARREType;
    property CODEBARRE[Index: Integer]: IXMLCODEBARREType read Get_CODEBARRE; default;
  end;

{ IXMLCODEBARREType }

  IXMLCODEBARREType = interface(IXMLNode)
    ['{408E96C5-ABE2-466C-A5A2-6CF0211B5508}']
    { Accesseurs de propriétés }
    function Get_IDCOLORIS: Integer;
    function Get_CODECOLORIS: Integer;
    function Get_CODE: Integer;
    function Get_NOM: WideString;
    function Get_CODEEAN: Integer;
    function Get_CODEEANCENTRALE: WideString;
    procedure Set_IDCOLORIS(Value: Integer);
    procedure Set_CODECOLORIS(Value: Integer);
    procedure Set_CODE(Value: Integer);
    procedure Set_NOM(Value: WideString);
    procedure Set_CODEEAN(Value: Integer);
    procedure Set_CODEEANCENTRALE(Value: WideString);
    { Méthodes & propriétés }
    property IDCOLORIS: Integer read Get_IDCOLORIS write Set_IDCOLORIS;
    property CODECOLORIS: Integer read Get_CODECOLORIS write Set_CODECOLORIS;
    property CODE: Integer read Get_CODE write Set_CODE;
    property NOM: WideString read Get_NOM write Set_NOM;
    property CODEEAN: Integer read Get_CODEEAN write Set_CODEEAN;
    property CODEEANCENTRALE: WideString read Get_CODEEANCENTRALE write Set_CODEEANCENTRALE;
  end;

{ Décl. Forward }

  TXMLLISTE_ITEMType = class;
  TXMLITEMType = class;
  TXMLTAILLESType = class;
  TXMLTAILLEType = class;
  TXMLTARIFSType = class;
  TXMLTARIFType = class;
  TXMLTARIFTypeList = class;
  TXMLCOULEURSType = class;
  TXMLCOULEURType = class;
  TXMLCODEBARRESType = class;
  TXMLCODEBARREType = class;

{ TXMLLISTE_ITEMType }

  TXMLLISTE_ITEMType = class(TXMLNode, IXMLLISTE_ITEMType)
  protected
    { IXMLLISTE_ITEMType }
    function Get_ITEM: IXMLITEMType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLITEMType }

  TXMLITEMType = class(TXMLNode, IXMLITEMType)
  protected
    { IXMLITEMType }
    function Get_RefREFART: Integer;
    function Get_AnneeReference: Integer;
    function Get_COLLECTION: WideString;
    function Get_Saison: WideString;
    function Get_Designation: WideString;
    function Get_Descriptif: WideString;
    function Get_IDMARQUE: Integer;
    function Get_NomMarque: WideString;
    function Get_Pack: Integer;
    function Get_GENRESP2K: WideString;
    function Get_Sexe: Integer;
    function Get_Type_: WideString;
    function Get_RefGrilleTaille: Integer;
    function Get_DesignationTaille: WideString;
    function Get_TAILLES: IXMLTAILLESType;
    function Get_TARIFS: IXMLTARIFSType;
    function Get_RefOperation: Integer;
    function Get_CodeCategorieFedas: Integer;
    function Get_CodeActiviteFedas: Integer;
    function Get_CodeGroupeFedas: Integer;
    function Get_CodeGenreFedas: Integer;
    function Get_CodeFedas: Integer;
    function Get_CodeGescom: WideString;
    function Get_COULEURS: IXMLCOULEURSType;
    function Get_CODEBARRES: IXMLCODEBARRESType;
    function Get_CATMAN: Integer;
    function Get_REFERENCECENTRALE: Integer;
    function Get_MONDOVELO: WideString;
    procedure Set_RefREFART(Value: Integer);
    procedure Set_AnneeReference(Value: Integer);
    procedure Set_COLLECTION(Value: WideString);
    procedure Set_Saison(Value: WideString);
    procedure Set_Designation(Value: WideString);
    procedure Set_Descriptif(Value: WideString);
    procedure Set_IDMARQUE(Value: Integer);
    procedure Set_NomMarque(Value: WideString);
    procedure Set_Pack(Value: Integer);
    procedure Set_GENRESP2K(Value: WideString);
    procedure Set_Sexe(Value: Integer);
    procedure Set_Type_(Value: WideString);
    procedure Set_RefGrilleTaille(Value: Integer);
    procedure Set_DesignationTaille(Value: WideString);
    procedure Set_RefOperation(Value: Integer);
    procedure Set_CodeCategorieFedas(Value: Integer);
    procedure Set_CodeActiviteFedas(Value: Integer);
    procedure Set_CodeGroupeFedas(Value: Integer);
    procedure Set_CodeGenreFedas(Value: Integer);
    procedure Set_CodeFedas(Value: Integer);
    procedure Set_CodeGescom(Value: WideString);
    procedure Set_CATMAN(Value: Integer);
    procedure Set_REFERENCECENTRALE(Value: Integer);
    procedure Set_MONDOVELO(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTAILLESType }

  TXMLTAILLESType = class(TXMLNodeCollection, IXMLTAILLESType)
  protected
    { IXMLTAILLESType }
    function Get_TAILLE(Index: Integer): IXMLTAILLEType;
    function Add: IXMLTAILLEType;
    function Insert(const Index: Integer): IXMLTAILLEType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTAILLEType }

  TXMLTAILLEType = class(TXMLNode, IXMLTAILLEType)
  protected
    { IXMLTAILLEType }
    function Get_CODE: Integer;
    function Get_CODETAILLE: Integer;
    function Get_NOM: WideString;
    function Get_RANGTAILLE: Integer;
    function Get_EQUIVALENCETAILLEF: WideString;
    procedure Set_CODE(Value: Integer);
    procedure Set_CODETAILLE(Value: Integer);
    procedure Set_NOM(Value: WideString);
    procedure Set_RANGTAILLE(Value: Integer);
    procedure Set_EQUIVALENCETAILLEF(Value: WideString);
  end;

{ TXMLTARIFSType }

  TXMLTARIFSType = class(TXMLNodeCollection, IXMLTARIFSType)
  protected
    { IXMLTARIFSType }
    function Get_TARIF(Index: Integer): IXMLTARIFType;
    function Add: IXMLTARIFType;
    function Insert(const Index: Integer): IXMLTARIFType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTARIFType }

  TXMLTARIFType = class(TXMLNode, IXMLTARIFType)
  protected
    { IXMLTARIFType }
    function Get_IDFOURNISSEUR: Integer;
    function Get_Fournisseur: WideString;
    function Get_ADR1_Fournisseur: WideString;
    function Get_ADR2_Fournisseur: WideString;
    function Get_CODEPOSTAL_Fournisseur: WideString;
    function Get_VILLE_Fournisseur: WideString;
    function Get_PATARIF: WideString;
    function Get_PVI: WideString;
    function Get_PANET: WideString;
    function Get_PCESSION: WideString;
    function Get_PBARRE: WideString;
    function Get_PxNormalFournisseur: WideString;
    function Get_REMISE: WideString;
    procedure Set_IDFOURNISSEUR(Value: Integer);
    procedure Set_Fournisseur(Value: WideString);
    procedure Set_ADR1_Fournisseur(Value: WideString);
    procedure Set_ADR2_Fournisseur(Value: WideString);
    procedure Set_CODEPOSTAL_Fournisseur(Value: WideString);
    procedure Set_VILLE_Fournisseur(Value: WideString);
    procedure Set_PATARIF(Value: WideString);
    procedure Set_PVI(Value: WideString);
    procedure Set_PANET(Value: WideString);
    procedure Set_PCESSION(Value: WideString);
    procedure Set_PBARRE(Value: WideString);
    procedure Set_PxNormalFournisseur(Value: WideString);
    procedure Set_REMISE(Value: WideString);
  end;

{ TXMLTARIFTypeList }

  TXMLTARIFTypeList = class(TXMLNodeCollection, IXMLTARIFTypeList)
  protected
    { IXMLTARIFTypeList }
    function Add: IXMLTARIFType;
    function Insert(const Index: Integer): IXMLTARIFType;
    function Get_Item(Index: Integer): IXMLTARIFType;
  end;

{ TXMLCOULEURSType }

  TXMLCOULEURSType = class(TXMLNodeCollection, IXMLCOULEURSType)
  protected
    { IXMLCOULEURSType }
    function Get_COULEUR(Index: Integer): IXMLCOULEURType;
    function Add: IXMLCOULEURType;
    function Insert(const Index: Integer): IXMLCOULEURType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCOULEURType }

  TXMLCOULEURType = class(TXMLNode, IXMLCOULEURType)
  protected
    { IXMLCOULEURType }
    function Get_IDCOLORIS: Integer;
    function Get_CODECOLORIS: Integer;
    function Get_DESCRIPTIF: WideString;
    procedure Set_IDCOLORIS(Value: Integer);
    procedure Set_CODECOLORIS(Value: Integer);
    procedure Set_DESCRIPTIF(Value: WideString);
  end;

{ TXMLCODEBARRESType }

  TXMLCODEBARRESType = class(TXMLNodeCollection, IXMLCODEBARRESType)
  protected
    { IXMLCODEBARRESType }
    function Get_CODEBARRE(Index: Integer): IXMLCODEBARREType;
    function Add: IXMLCODEBARREType;
    function Insert(const Index: Integer): IXMLCODEBARREType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCODEBARREType }

  TXMLCODEBARREType = class(TXMLNode, IXMLCODEBARREType)
  protected
    { IXMLCODEBARREType }
    function Get_IDCOLORIS: Integer;
    function Get_CODECOLORIS: Integer;
    function Get_CODE: Integer;
    function Get_NOM: WideString;
    function Get_CODEEAN: Integer;
    function Get_CODEEANCENTRALE: WideString;
    procedure Set_IDCOLORIS(Value: Integer);
    procedure Set_CODECOLORIS(Value: Integer);
    procedure Set_CODE(Value: Integer);
    procedure Set_NOM(Value: WideString);
    procedure Set_CODEEAN(Value: Integer);
    procedure Set_CODEEANCENTRALE(Value: WideString);
  end;

{ Fonctions globales }

function GetLISTE_ITEM(Doc: IXMLDocument): IXMLLISTE_ITEMType;
function LoadLISTE_ITEM(const FileName: WideString): IXMLLISTE_ITEMType;
function NewLISTE_ITEM: IXMLLISTE_ITEMType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetLISTE_ITEM(Doc: IXMLDocument): IXMLLISTE_ITEMType;
begin
  Result := Doc.GetDocBinding('LISTE_ITEM', TXMLLISTE_ITEMType, TargetNamespace) as IXMLLISTE_ITEMType;
end;

function LoadLISTE_ITEM(const FileName: WideString): IXMLLISTE_ITEMType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('LISTE_ITEM', TXMLLISTE_ITEMType, TargetNamespace) as IXMLLISTE_ITEMType;
end;

function NewLISTE_ITEM: IXMLLISTE_ITEMType;
begin
  Result := NewXMLDocument.GetDocBinding('LISTE_ITEM', TXMLLISTE_ITEMType, TargetNamespace) as IXMLLISTE_ITEMType;
end;

{ TXMLLISTE_ITEMType }

procedure TXMLLISTE_ITEMType.AfterConstruction;
begin
  RegisterChildNode('ITEM', TXMLITEMType);
  inherited;
end;

function TXMLLISTE_ITEMType.Get_ITEM: IXMLITEMType;
begin
  Result := ChildNodes['ITEM'] as IXMLITEMType;
end;

{ TXMLITEMType }

procedure TXMLITEMType.AfterConstruction;
begin
  RegisterChildNode('TAILLES', TXMLTAILLESType);
  RegisterChildNode('TARIFS', TXMLTARIFSType);
  RegisterChildNode('COULEURS', TXMLCOULEURSType);
  RegisterChildNode('CODEBARRES', TXMLCODEBARRESType);
  inherited;
end;

function TXMLITEMType.Get_RefREFART: Integer;
begin
  Result := ChildNodes['RefREFART'].NodeValue;
end;

procedure TXMLITEMType.Set_RefREFART(Value: Integer);
begin
  ChildNodes['RefREFART'].NodeValue := Value;
end;

function TXMLITEMType.Get_AnneeReference: Integer;
begin
  Result := ChildNodes['AnneeReference'].NodeValue;
end;

procedure TXMLITEMType.Set_AnneeReference(Value: Integer);
begin
  ChildNodes['AnneeReference'].NodeValue := Value;
end;

function TXMLITEMType.Get_COLLECTION: WideString;
begin
  Result := ChildNodes['COLLECTION'].Text;
end;

procedure TXMLITEMType.Set_COLLECTION(Value: WideString);
begin
  ChildNodes['COLLECTION'].NodeValue := Value;
end;

function TXMLITEMType.Get_Saison: WideString;
begin
  Result := ChildNodes['Saison'].Text;
end;

procedure TXMLITEMType.Set_Saison(Value: WideString);
begin
  ChildNodes['Saison'].NodeValue := Value;
end;

function TXMLITEMType.Get_Designation: WideString;
begin
  Result := ChildNodes['Designation'].Text;
end;

procedure TXMLITEMType.Set_Designation(Value: WideString);
begin
  ChildNodes['Designation'].NodeValue := Value;
end;

function TXMLITEMType.Get_Descriptif: WideString;
begin
  Result := ChildNodes['Descriptif'].Text;
end;

procedure TXMLITEMType.Set_Descriptif(Value: WideString);
begin
  ChildNodes['Descriptif'].NodeValue := Value;
end;

function TXMLITEMType.Get_IDMARQUE: Integer;
begin
  Result := ChildNodes['IDMARQUE'].NodeValue;
end;

procedure TXMLITEMType.Set_IDMARQUE(Value: Integer);
begin
  ChildNodes['IDMARQUE'].NodeValue := Value;
end;

function TXMLITEMType.Get_NomMarque: WideString;
begin
  Result := ChildNodes['NomMarque'].Text;
end;

procedure TXMLITEMType.Set_NomMarque(Value: WideString);
begin
  ChildNodes['NomMarque'].NodeValue := Value;
end;

function TXMLITEMType.Get_Pack: Integer;
begin
  Result := ChildNodes['Pack'].NodeValue;
end;

procedure TXMLITEMType.Set_Pack(Value: Integer);
begin
  ChildNodes['Pack'].NodeValue := Value;
end;

function TXMLITEMType.Get_GENRESP2K: WideString;
begin
  Result := ChildNodes['GENRESP2K'].Text;
end;

procedure TXMLITEMType.Set_GENRESP2K(Value: WideString);
begin
  ChildNodes['GENRESP2K'].NodeValue := Value;
end;

function TXMLITEMType.Get_Sexe: Integer;
begin
  Result := ChildNodes['Sexe'].NodeValue;
end;

procedure TXMLITEMType.Set_Sexe(Value: Integer);
begin
  ChildNodes['Sexe'].NodeValue := Value;
end;

function TXMLITEMType.Get_Type_: WideString;
begin
  Result := ChildNodes['Type'].Text;
end;

procedure TXMLITEMType.Set_Type_(Value: WideString);
begin
  ChildNodes['Type'].NodeValue := Value;
end;

function TXMLITEMType.Get_RefGrilleTaille: Integer;
begin
  Result := ChildNodes['RefGrilleTaille'].NodeValue;
end;

procedure TXMLITEMType.Set_RefGrilleTaille(Value: Integer);
begin
  ChildNodes['RefGrilleTaille'].NodeValue := Value;
end;

function TXMLITEMType.Get_DesignationTaille: WideString;
begin
  Result := ChildNodes['DesignationTaille'].Text;
end;

procedure TXMLITEMType.Set_DesignationTaille(Value: WideString);
begin
  ChildNodes['DesignationTaille'].NodeValue := Value;
end;

function TXMLITEMType.Get_TAILLES: IXMLTAILLESType;
begin
  Result := ChildNodes['TAILLES'] as IXMLTAILLESType;
end;

function TXMLITEMType.Get_TARIFS: IXMLTARIFSType;
begin
  Result := ChildNodes['TARIFS'] as IXMLTARIFSType;
end;

function TXMLITEMType.Get_RefOperation: Integer;
begin
  Result := ChildNodes['RefOperation'].NodeValue;
end;

procedure TXMLITEMType.Set_RefOperation(Value: Integer);
begin
  ChildNodes['RefOperation'].NodeValue := Value;
end;

function TXMLITEMType.Get_CodeCategorieFedas: Integer;
begin
  Result := ChildNodes['CodeCategorieFedas'].NodeValue;
end;

procedure TXMLITEMType.Set_CodeCategorieFedas(Value: Integer);
begin
  ChildNodes['CodeCategorieFedas'].NodeValue := Value;
end;

function TXMLITEMType.Get_CodeActiviteFedas: Integer;
begin
  Result := ChildNodes['CodeActiviteFedas'].NodeValue;
end;

procedure TXMLITEMType.Set_CodeActiviteFedas(Value: Integer);
begin
  ChildNodes['CodeActiviteFedas'].NodeValue := Value;
end;

function TXMLITEMType.Get_CodeGroupeFedas: Integer;
begin
  Result := ChildNodes['CodeGroupeFedas'].NodeValue;
end;

procedure TXMLITEMType.Set_CodeGroupeFedas(Value: Integer);
begin
  ChildNodes['CodeGroupeFedas'].NodeValue := Value;
end;

function TXMLITEMType.Get_CodeGenreFedas: Integer;
begin
  Result := ChildNodes['CodeGenreFedas'].NodeValue;
end;

procedure TXMLITEMType.Set_CodeGenreFedas(Value: Integer);
begin
  ChildNodes['CodeGenreFedas'].NodeValue := Value;
end;

function TXMLITEMType.Get_CodeFedas: Integer;
begin
  Result := ChildNodes['CodeFedas'].NodeValue;
end;

procedure TXMLITEMType.Set_CodeFedas(Value: Integer);
begin
  ChildNodes['CodeFedas'].NodeValue := Value;
end;

function TXMLITEMType.Get_CodeGescom: WideString;
begin
  Result := ChildNodes['CodeGescom'].Text;
end;

procedure TXMLITEMType.Set_CodeGescom(Value: WideString);
begin
  ChildNodes['CodeGescom'].NodeValue := Value;
end;

function TXMLITEMType.Get_COULEURS: IXMLCOULEURSType;
begin
  Result := ChildNodes['COULEURS'] as IXMLCOULEURSType;
end;

function TXMLITEMType.Get_CODEBARRES: IXMLCODEBARRESType;
begin
  Result := ChildNodes['CODEBARRES'] as IXMLCODEBARRESType;
end;

function TXMLITEMType.Get_CATMAN: Integer;
begin
  Result := ChildNodes['CATMAN'].NodeValue;
end;

procedure TXMLITEMType.Set_CATMAN(Value: Integer);
begin
  ChildNodes['CATMAN'].NodeValue := Value;
end;

function TXMLITEMType.Get_REFERENCECENTRALE: Integer;
begin
  Result := ChildNodes['REFERENCECENTRALE'].NodeValue;
end;

procedure TXMLITEMType.Set_REFERENCECENTRALE(Value: Integer);
begin
  ChildNodes['REFERENCECENTRALE'].NodeValue := Value;
end;

function TXMLITEMType.Get_MONDOVELO: WideString;
begin
  Result := ChildNodes['MONDOVELO'].Text;
end;

procedure TXMLITEMType.Set_MONDOVELO(Value: WideString);
begin
  ChildNodes['MONDOVELO'].NodeValue := Value;
end;

{ TXMLTAILLESType }

procedure TXMLTAILLESType.AfterConstruction;
begin
  RegisterChildNode('TAILLE', TXMLTAILLEType);
  ItemTag := 'TAILLE';
  ItemInterface := IXMLTAILLEType;
  inherited;
end;

function TXMLTAILLESType.Get_TAILLE(Index: Integer): IXMLTAILLEType;
begin
  Result := List[Index] as IXMLTAILLEType;
end;

function TXMLTAILLESType.Add: IXMLTAILLEType;
begin
  Result := AddItem(-1) as IXMLTAILLEType;
end;

function TXMLTAILLESType.Insert(const Index: Integer): IXMLTAILLEType;
begin
  Result := AddItem(Index) as IXMLTAILLEType;
end;

{ TXMLTAILLEType }

function TXMLTAILLEType.Get_CODE: Integer;
begin
  Result := ChildNodes['CODE'].NodeValue;
end;

procedure TXMLTAILLEType.Set_CODE(Value: Integer);
begin
  ChildNodes['CODE'].NodeValue := Value;
end;

function TXMLTAILLEType.Get_CODETAILLE: Integer;
begin
  Result := ChildNodes['CODETAILLE'].NodeValue;
end;

procedure TXMLTAILLEType.Set_CODETAILLE(Value: Integer);
begin
  ChildNodes['CODETAILLE'].NodeValue := Value;
end;

function TXMLTAILLEType.Get_NOM: WideString;
begin
  Result := ChildNodes['NOM'].Text;
end;

procedure TXMLTAILLEType.Set_NOM(Value: WideString);
begin
  ChildNodes['NOM'].NodeValue := Value;
end;

function TXMLTAILLEType.Get_RANGTAILLE: Integer;
begin
  Result := ChildNodes['RANGTAILLE'].NodeValue;
end;

procedure TXMLTAILLEType.Set_RANGTAILLE(Value: Integer);
begin
  ChildNodes['RANGTAILLE'].NodeValue := Value;
end;

function TXMLTAILLEType.Get_EQUIVALENCETAILLEF: WideString;
begin
  Result := ChildNodes['EQUIVALENCETAILLEF'].Text;
end;

procedure TXMLTAILLEType.Set_EQUIVALENCETAILLEF(Value: WideString);
begin
  ChildNodes['EQUIVALENCETAILLEF'].NodeValue := Value;
end;

{ TXMLTARIFSType }

procedure TXMLTARIFSType.AfterConstruction;
begin
  RegisterChildNode('TARIF', TXMLTARIFType);
  ItemTag := 'TARIF';
  ItemInterface := IXMLTARIFType;
  inherited;
end;

function TXMLTARIFSType.Get_TARIF(Index: Integer): IXMLTARIFType;
begin
  Result := List[Index] as IXMLTARIFType;
end;

function TXMLTARIFSType.Add: IXMLTARIFType;
begin
  Result := AddItem(-1) as IXMLTARIFType;
end;

function TXMLTARIFSType.Insert(const Index: Integer): IXMLTARIFType;
begin
  Result := AddItem(Index) as IXMLTARIFType;
end;

{ TXMLTARIFType }

function TXMLTARIFType.Get_IDFOURNISSEUR: Integer;
begin
  Result := ChildNodes['IDFOURNISSEUR'].NodeValue;
end;

procedure TXMLTARIFType.Set_IDFOURNISSEUR(Value: Integer);
begin
  ChildNodes['IDFOURNISSEUR'].NodeValue := Value;
end;

function TXMLTARIFType.Get_Fournisseur: WideString;
begin
  Result := ChildNodes['Fournisseur'].Text;
end;

procedure TXMLTARIFType.Set_Fournisseur(Value: WideString);
begin
  ChildNodes['Fournisseur'].NodeValue := Value;
end;

function TXMLTARIFType.Get_ADR1_Fournisseur: WideString;
begin
  Result := ChildNodes['ADR1_Fournisseur'].Text;
end;

procedure TXMLTARIFType.Set_ADR1_Fournisseur(Value: WideString);
begin
  ChildNodes['ADR1_Fournisseur'].NodeValue := Value;
end;

function TXMLTARIFType.Get_ADR2_Fournisseur: WideString;
begin
  Result := ChildNodes['ADR2_Fournisseur'].Text;
end;

procedure TXMLTARIFType.Set_ADR2_Fournisseur(Value: WideString);
begin
  ChildNodes['ADR2_Fournisseur'].NodeValue := Value;
end;

function TXMLTARIFType.Get_CODEPOSTAL_Fournisseur: WideString;
begin
  Result := ChildNodes['CODEPOSTAL_Fournisseur'].Text;
end;

procedure TXMLTARIFType.Set_CODEPOSTAL_Fournisseur(Value: WideString);
begin
  ChildNodes['CODEPOSTAL_Fournisseur'].NodeValue := Value;
end;

function TXMLTARIFType.Get_VILLE_Fournisseur: WideString;
begin
  Result := ChildNodes['VILLE_Fournisseur'].Text;
end;

procedure TXMLTARIFType.Set_VILLE_Fournisseur(Value: WideString);
begin
  ChildNodes['VILLE_Fournisseur'].NodeValue := Value;
end;

function TXMLTARIFType.Get_PATARIF: WideString;
begin
  Result := ChildNodes['PATARIF'].Text;
end;

procedure TXMLTARIFType.Set_PATARIF(Value: WideString);
begin
  ChildNodes['PATARIF'].NodeValue := Value;
end;

function TXMLTARIFType.Get_PVI: WideString;
begin
  Result := ChildNodes['PVI'].Text;
end;

procedure TXMLTARIFType.Set_PVI(Value: WideString);
begin
  ChildNodes['PVI'].NodeValue := Value;
end;

function TXMLTARIFType.Get_PANET: WideString;
begin
  Result := ChildNodes['PANET'].Text;
end;

procedure TXMLTARIFType.Set_PANET(Value: WideString);
begin
  ChildNodes['PANET'].NodeValue := Value;
end;

function TXMLTARIFType.Get_PCESSION: WideString;
begin
  Result := ChildNodes['PCESSION'].Text;
end;

procedure TXMLTARIFType.Set_PCESSION(Value: WideString);
begin
  ChildNodes['PCESSION'].NodeValue := Value;
end;

function TXMLTARIFType.Get_PBARRE: WideString;
begin
  Result := ChildNodes['PBARRE'].Text;
end;

procedure TXMLTARIFType.Set_PBARRE(Value: WideString);
begin
  ChildNodes['PBARRE'].NodeValue := Value;
end;

function TXMLTARIFType.Get_PxNormalFournisseur: WideString;
begin
  Result := ChildNodes['PxNormalFournisseur'].Text;
end;

procedure TXMLTARIFType.Set_PxNormalFournisseur(Value: WideString);
begin
  ChildNodes['PxNormalFournisseur'].NodeValue := Value;
end;

function TXMLTARIFType.Get_REMISE: WideString;
begin
  Result := ChildNodes['REMISE'].Text;
end;

procedure TXMLTARIFType.Set_REMISE(Value: WideString);
begin
  ChildNodes['REMISE'].NodeValue := Value;
end;

{ TXMLTARIFTypeList }

function TXMLTARIFTypeList.Add: IXMLTARIFType;
begin
  Result := AddItem(-1) as IXMLTARIFType;
end;

function TXMLTARIFTypeList.Insert(const Index: Integer): IXMLTARIFType;
begin
  Result := AddItem(Index) as IXMLTARIFType;
end;
function TXMLTARIFTypeList.Get_Item(Index: Integer): IXMLTARIFType;
begin
  Result := List[Index] as IXMLTARIFType;
end;

{ TXMLCOULEURSType }

procedure TXMLCOULEURSType.AfterConstruction;
begin
  RegisterChildNode('COULEUR', TXMLCOULEURType);
  ItemTag := 'COULEUR';
  ItemInterface := IXMLCOULEURType;
  inherited;
end;

function TXMLCOULEURSType.Get_COULEUR(Index: Integer): IXMLCOULEURType;
begin
  Result := List[Index] as IXMLCOULEURType;
end;

function TXMLCOULEURSType.Add: IXMLCOULEURType;
begin
  Result := AddItem(-1) as IXMLCOULEURType;
end;

function TXMLCOULEURSType.Insert(const Index: Integer): IXMLCOULEURType;
begin
  Result := AddItem(Index) as IXMLCOULEURType;
end;

{ TXMLCOULEURType }

function TXMLCOULEURType.Get_IDCOLORIS: Integer;
begin
  Result := ChildNodes['IDCOLORIS'].NodeValue;
end;

procedure TXMLCOULEURType.Set_IDCOLORIS(Value: Integer);
begin
  ChildNodes['IDCOLORIS'].NodeValue := Value;
end;

function TXMLCOULEURType.Get_CODECOLORIS: Integer;
begin
  Result := ChildNodes['CODECOLORIS'].NodeValue;
end;

procedure TXMLCOULEURType.Set_CODECOLORIS(Value: Integer);
begin
  ChildNodes['CODECOLORIS'].NodeValue := Value;
end;

function TXMLCOULEURType.Get_DESCRIPTIF: WideString;
begin
  Result := ChildNodes['DESCRIPTIF'].Text;
end;

procedure TXMLCOULEURType.Set_DESCRIPTIF(Value: WideString);
begin
  ChildNodes['DESCRIPTIF'].NodeValue := Value;
end;

{ TXMLCODEBARRESType }

procedure TXMLCODEBARRESType.AfterConstruction;
begin
  RegisterChildNode('CODEBARRE', TXMLCODEBARREType);
  ItemTag := 'CODEBARRE';
  ItemInterface := IXMLCODEBARREType;
  inherited;
end;

function TXMLCODEBARRESType.Get_CODEBARRE(Index: Integer): IXMLCODEBARREType;
begin
  Result := List[Index] as IXMLCODEBARREType;
end;

function TXMLCODEBARRESType.Add: IXMLCODEBARREType;
begin
  Result := AddItem(-1) as IXMLCODEBARREType;
end;

function TXMLCODEBARRESType.Insert(const Index: Integer): IXMLCODEBARREType;
begin
  Result := AddItem(Index) as IXMLCODEBARREType;
end;

{ TXMLCODEBARREType }

function TXMLCODEBARREType.Get_IDCOLORIS: Integer;
begin
  Result := ChildNodes['IDCOLORIS'].NodeValue;
end;

procedure TXMLCODEBARREType.Set_IDCOLORIS(Value: Integer);
begin
  ChildNodes['IDCOLORIS'].NodeValue := Value;
end;

function TXMLCODEBARREType.Get_CODECOLORIS: Integer;
begin
  Result := ChildNodes['CODECOLORIS'].NodeValue;
end;

procedure TXMLCODEBARREType.Set_CODECOLORIS(Value: Integer);
begin
  ChildNodes['CODECOLORIS'].NodeValue := Value;
end;

function TXMLCODEBARREType.Get_CODE: Integer;
begin
  Result := ChildNodes['CODE'].NodeValue;
end;

procedure TXMLCODEBARREType.Set_CODE(Value: Integer);
begin
  ChildNodes['CODE'].NodeValue := Value;
end;

function TXMLCODEBARREType.Get_NOM: WideString;
begin
  Result := ChildNodes['NOM'].Text;
end;

procedure TXMLCODEBARREType.Set_NOM(Value: WideString);
begin
  ChildNodes['NOM'].NodeValue := Value;
end;

function TXMLCODEBARREType.Get_CODEEAN: Integer;
begin
  Result := ChildNodes['CODEEAN'].NodeValue;
end;

procedure TXMLCODEBARREType.Set_CODEEAN(Value: Integer);
begin
  ChildNodes['CODEEAN'].NodeValue := Value;
end;

function TXMLCODEBARREType.Get_CODEEANCENTRALE: WideString;
begin
  Result := ChildNodes['CODEEANCENTRALE'].Text;
end;

procedure TXMLCODEBARREType.Set_CODEEANCENTRALE(Value: WideString);
begin
  ChildNodes['CODEEANCENTRALE'].NodeValue := Value;
end;

end.

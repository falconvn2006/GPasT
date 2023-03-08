
{**************************************************************************************************************}
{                                                                                                              }
{                                            Liaison de données XML                                            }
{                                                                                                              }
{         Généré le : 16/10/2014 12:13:34                                                                      }
{       Généré depuis : C:\Developpement\Ginkoia\UTILITAIRE\SymmetricDS\Commun\InstallationServeur.xml         }
{   Paramètres stockés dans : C:\Developpement\Ginkoia\UTILITAIRE\SymmetricDS\Commun\InstallationServeur.xdb   }
{                                                                                                              }
{**************************************************************************************************************}

unit SymmetricDS.Commun.XML.InstallationServeur;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLAutomatedInstallationType = interface;
  IXMLPanelsSymmetricHelloPanelType = interface;
  IXMLComizforgeizpackpanelsuserinputUserInputPanelType = interface;
  IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList = interface;
  IXMLUserInputType = interface;
  IXMLEntryType = interface;
  IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType = interface;
  IXMLComizforgeizpackpanelstargetTargetPanelType = interface;
  IXMLComizforgeizpackpanelspacksPacksPanelType = interface;
  IXMLPackType = interface;
  IXMLComizforgeizpackpanelssummarySummaryPanelType = interface;
  IXMLComizforgeizpackpanelsinstallInstallPanelType = interface;
  IXMLComizforgeizpackpanelsshortcutShortcutPanelType = interface;
  IXMLComizforgeizpackpanelsprocessProcessPanelType = interface;
  IXMLPanelsSymmetricFinishPanelType = interface;
  IXMLComizforgeizpackpanelsuserinputUserInputPanelType2 = interface;

{ IXMLAutomatedInstallationType }

  IXMLAutomatedInstallationType = interface(IXMLNode)
    ['{48F95AC8-AAC1-41B1-B386-2585F2CD47A9}']
    { Accesseurs de propriétés }
    function Get_Langpack: WideString;
    function Get_PanelsSymmetricHelloPanel: IXMLPanelsSymmetricHelloPanelType;
    function Get_ComizforgeizpackpanelsuserinputUserInputPanel: IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList;
    function Get_ComizforgeizpackpanelshtmllicenceHTMLLicencePanel: IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType;
    function Get_ComizforgeizpackpanelstargetTargetPanel: IXMLComizforgeizpackpanelstargetTargetPanelType;
    function Get_ComizforgeizpackpanelspacksPacksPanel: IXMLComizforgeizpackpanelspacksPacksPanelType;
    function Get_ComizforgeizpackpanelssummarySummaryPanel: IXMLComizforgeizpackpanelssummarySummaryPanelType;
    function Get_ComizforgeizpackpanelsinstallInstallPanel: IXMLComizforgeizpackpanelsinstallInstallPanelType;
    function Get_ComizforgeizpackpanelsshortcutShortcutPanel: IXMLComizforgeizpackpanelsshortcutShortcutPanelType;
    function Get_ComizforgeizpackpanelsprocessProcessPanel: IXMLComizforgeizpackpanelsprocessProcessPanelType;
    function Get_PanelsSymmetricFinishPanel: IXMLPanelsSymmetricFinishPanelType;
    procedure Set_Langpack(Value: WideString);
    { Méthodes & propriétés }
    property Langpack: WideString read Get_Langpack write Set_Langpack;
    property PanelsSymmetricHelloPanel: IXMLPanelsSymmetricHelloPanelType read Get_PanelsSymmetricHelloPanel;
    property ComizforgeizpackpanelsuserinputUserInputPanel: IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList read Get_ComizforgeizpackpanelsuserinputUserInputPanel;
    property ComizforgeizpackpanelshtmllicenceHTMLLicencePanel: IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType read Get_ComizforgeizpackpanelshtmllicenceHTMLLicencePanel;
    property ComizforgeizpackpanelstargetTargetPanel: IXMLComizforgeizpackpanelstargetTargetPanelType read Get_ComizforgeizpackpanelstargetTargetPanel;
    property ComizforgeizpackpanelspacksPacksPanel: IXMLComizforgeizpackpanelspacksPacksPanelType read Get_ComizforgeizpackpanelspacksPacksPanel;
    property ComizforgeizpackpanelssummarySummaryPanel: IXMLComizforgeizpackpanelssummarySummaryPanelType read Get_ComizforgeizpackpanelssummarySummaryPanel;
    property ComizforgeizpackpanelsinstallInstallPanel: IXMLComizforgeizpackpanelsinstallInstallPanelType read Get_ComizforgeizpackpanelsinstallInstallPanel;
    property ComizforgeizpackpanelsshortcutShortcutPanel: IXMLComizforgeizpackpanelsshortcutShortcutPanelType read Get_ComizforgeizpackpanelsshortcutShortcutPanel;
    property ComizforgeizpackpanelsprocessProcessPanel: IXMLComizforgeizpackpanelsprocessProcessPanelType read Get_ComizforgeizpackpanelsprocessProcessPanel;
    property PanelsSymmetricFinishPanel: IXMLPanelsSymmetricFinishPanelType read Get_PanelsSymmetricFinishPanel;
  end;

{ IXMLPanelsSymmetricHelloPanelType }

  IXMLPanelsSymmetricHelloPanelType = interface(IXMLNode)
    ['{D9387724-A7D8-473F-9BE9-642BE60DAD6F}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    procedure Set_Id(Value: WideString);
    { Méthodes & propriétés }
    property Id: WideString read Get_Id write Set_Id;
  end;

{ IXMLComizforgeizpackpanelsuserinputUserInputPanelType }

  IXMLComizforgeizpackpanelsuserinputUserInputPanelType = interface(IXMLNode)
    ['{1D0608F5-0FCE-4947-9F8C-1F43335B2B3B}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    function Get_UserInput: IXMLUserInputType;
    procedure Set_Id(Value: WideString);
    { Méthodes & propriétés }
    property Id: WideString read Get_Id write Set_Id;
    property UserInput: IXMLUserInputType read Get_UserInput;
  end;

{ IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList }

  IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList = interface(IXMLNodeCollection)
    ['{5560E875-876F-4CFC-95A5-D4573F6B3AAB}']
    { Méthodes & propriétés }
    function Add: IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
    function Insert(const Index: Integer): IXMLComizforgeizpackpanelsuserinputUserInputPanelType;

    function Get_Item(Index: Integer): IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
    property Items[Index: Integer]: IXMLComizforgeizpackpanelsuserinputUserInputPanelType read Get_Item; default;
  end;

{ IXMLUserInputType }

  IXMLUserInputType = interface(IXMLNodeCollection)
    ['{04793C35-89E9-4542-AD1E-4C482CA1BA21}']
    { Accesseurs de propriétés }
    function Get_Entry(Index: Integer): IXMLEntryType;
    { Méthodes & propriétés }
    function Add: IXMLEntryType;
    function Insert(const Index: Integer): IXMLEntryType;
    property Entry[Index: Integer]: IXMLEntryType read Get_Entry; default;
  end;

{ IXMLEntryType }

  IXMLEntryType = interface(IXMLNode)
    ['{386E6E90-FECB-48FE-BA5F-08E2BB1A3322}']
    { Accesseurs de propriétés }
    function Get_Key: WideString;
    function Get_Value: Boolean;
    procedure Set_Key(Value: WideString);
    procedure Set_Value(Value: Boolean);
    { Méthodes & propriétés }
    property Key: WideString read Get_Key write Set_Key;
    property Value: Boolean read Get_Value write Set_Value;
  end;

{ IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType }

  IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType = interface(IXMLNode)
    ['{52623C26-EDE8-4CE6-B641-14488399FEBE}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
  end;

{ IXMLComizforgeizpackpanelstargetTargetPanelType }

  IXMLComizforgeizpackpanelstargetTargetPanelType = interface(IXMLNode)
    ['{C065CAD4-98B4-416E-B2B9-10657B71EA9B}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    function Get_Installpath: WideString;
    procedure Set_Installpath(Value: WideString);
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
    property Installpath: WideString read Get_Installpath write Set_Installpath;
  end;

{ IXMLComizforgeizpackpanelspacksPacksPanelType }

  IXMLComizforgeizpackpanelspacksPacksPanelType = interface(IXMLNodeCollection)
    ['{F8B1F335-D18C-4BB5-94ED-A37E874E57CB}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    function Get_Pack(Index: Integer): IXMLPackType;
    { Méthodes & propriétés }
    function Add: IXMLPackType;
    function Insert(const Index: Integer): IXMLPackType;
    property Id: WideString read Get_Id;
    property Pack[Index: Integer]: IXMLPackType read Get_Pack; default;
  end;

{ IXMLPackType }

  IXMLPackType = interface(IXMLNode)
    ['{23D4AB66-54E3-4184-878B-94002713AB88}']
    { Accesseurs de propriétés }
    function Get_Index: Integer;
    function Get_Name: WideString;
    function Get_Selected: Boolean;
    procedure Set_Index(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Selected(Value: Boolean);
    { Méthodes & propriétés }
    property Index: Integer read Get_Index write Set_Index;
    property Name: WideString read Get_Name write Set_Name;
    property Selected: Boolean read Get_Selected write Set_Selected;
  end;

{ IXMLComizforgeizpackpanelssummarySummaryPanelType }

  IXMLComizforgeizpackpanelssummarySummaryPanelType = interface(IXMLNode)
    ['{91E137E9-4C43-461B-8BDF-7445AD147234}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
  end;

{ IXMLComizforgeizpackpanelsinstallInstallPanelType }

  IXMLComizforgeizpackpanelsinstallInstallPanelType = interface(IXMLNode)
    ['{33F6552F-AD8C-483B-9F89-552D78B1B667}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
  end;

{ IXMLComizforgeizpackpanelsshortcutShortcutPanelType }

  IXMLComizforgeizpackpanelsshortcutShortcutPanelType = interface(IXMLNode)
    ['{E4B0661C-0DA1-4867-BFA7-9C7956FE05D2}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    function Get_CreateShortcuts: Boolean;
    function Get_ProgramGroup: WideString;
    function Get_CreateDesktopShortcuts: Shortint;
    function Get_ShortcutType: WideString;
    procedure Set_CreateShortcuts(Value: Boolean);
    procedure Set_ProgramGroup(Value: WideString);
    procedure Set_CreateDesktopShortcuts(Value: Shortint);
    procedure Set_ShortcutType(Value: WideString);
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
    property CreateShortcuts: Boolean read Get_CreateShortcuts write Set_CreateShortcuts;
    property ProgramGroup: WideString read Get_ProgramGroup write Set_ProgramGroup;
    property CreateDesktopShortcuts: Shortint read Get_CreateDesktopShortcuts write Set_CreateDesktopShortcuts;
    property ShortcutType: WideString read Get_ShortcutType write Set_ShortcutType;
  end;

{ IXMLComizforgeizpackpanelsprocessProcessPanelType }

  IXMLComizforgeizpackpanelsprocessProcessPanelType = interface(IXMLNode)
    ['{35213BFA-B9E0-437F-95A4-B2FE67A06DB9}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
  end;

{ IXMLPanelsSymmetricFinishPanelType }

  IXMLPanelsSymmetricFinishPanelType = interface(IXMLNode)
    ['{52333932-6533-4CB0-BC58-C6AF6087B336}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    { Méthodes & propriétés }
    property Id: WideString read Get_Id;
  end;

{ IXMLComizforgeizpackpanelsuserinputUserInputPanelType2 }

  IXMLComizforgeizpackpanelsuserinputUserInputPanelType2 = interface(IXMLNode)
    ['{9A2A1ECB-39A4-4780-B501-3E4A9849EE5F}']
    { Accesseurs de propriétés }
    function Get_Id: Integer;
    procedure Set_Id(Value: Integer);
    { Méthodes & propriétés }
    property Id: Integer read Get_Id write Set_Id;
  end;

{ Décl. Forward }

  TXMLAutomatedInstallationType = class;
  TXMLPanelsSymmetricHelloPanelType = class;
  TXMLComizforgeizpackpanelsuserinputUserInputPanelType = class;
  TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList = class;
  TXMLUserInputType = class;
  TXMLEntryType = class;
  TXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType = class;
  TXMLComizforgeizpackpanelstargetTargetPanelType = class;
  TXMLComizforgeizpackpanelspacksPacksPanelType = class;
  TXMLPackType = class;
  TXMLComizforgeizpackpanelssummarySummaryPanelType = class;
  TXMLComizforgeizpackpanelsinstallInstallPanelType = class;
  TXMLComizforgeizpackpanelsshortcutShortcutPanelType = class;
  TXMLComizforgeizpackpanelsprocessProcessPanelType = class;
  TXMLPanelsSymmetricFinishPanelType = class;
  TXMLComizforgeizpackpanelsuserinputUserInputPanelType2 = class;

{ TXMLAutomatedInstallationType }

  TXMLAutomatedInstallationType = class(TXMLNode, IXMLAutomatedInstallationType)
  private
    FComizforgeizpackpanelsuserinputUserInputPanel: IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList;
  protected
    { IXMLAutomatedInstallationType }
    function Get_Langpack: WideString;
    function Get_PanelsSymmetricHelloPanel: IXMLPanelsSymmetricHelloPanelType;
    function Get_ComizforgeizpackpanelsuserinputUserInputPanel: IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList;
    function Get_ComizforgeizpackpanelshtmllicenceHTMLLicencePanel: IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType;
    function Get_ComizforgeizpackpanelstargetTargetPanel: IXMLComizforgeizpackpanelstargetTargetPanelType;
    function Get_ComizforgeizpackpanelspacksPacksPanel: IXMLComizforgeizpackpanelspacksPacksPanelType;
    function Get_ComizforgeizpackpanelssummarySummaryPanel: IXMLComizforgeizpackpanelssummarySummaryPanelType;
    function Get_ComizforgeizpackpanelsinstallInstallPanel: IXMLComizforgeizpackpanelsinstallInstallPanelType;
    function Get_ComizforgeizpackpanelsshortcutShortcutPanel: IXMLComizforgeizpackpanelsshortcutShortcutPanelType;
    function Get_ComizforgeizpackpanelsprocessProcessPanel: IXMLComizforgeizpackpanelsprocessProcessPanelType;
    function Get_PanelsSymmetricFinishPanel: IXMLPanelsSymmetricFinishPanelType;
    procedure Set_Langpack(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPanelsSymmetricHelloPanelType }

  TXMLPanelsSymmetricHelloPanelType = class(TXMLNode, IXMLPanelsSymmetricHelloPanelType)
  protected
    { IXMLPanelsSymmetricHelloPanelType }
    function Get_Id: WideString;
    procedure Set_Id(Value: WideString);
  end;

{ TXMLComizforgeizpackpanelsuserinputUserInputPanelType }

  TXMLComizforgeizpackpanelsuserinputUserInputPanelType = class(TXMLNode, IXMLComizforgeizpackpanelsuserinputUserInputPanelType)
  protected
    { IXMLComizforgeizpackpanelsuserinputUserInputPanelType }
    function Get_Id: WideString;
    function Get_UserInput: IXMLUserInputType;
    procedure Set_Id(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList }

  TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList = class(TXMLNodeCollection, IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList)
  protected
    { IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList }
    function Add: IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
    function Insert(const Index: Integer): IXMLComizforgeizpackpanelsuserinputUserInputPanelType;

    function Get_Item(Index: Integer): IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
  end;

{ TXMLUserInputType }

  TXMLUserInputType = class(TXMLNodeCollection, IXMLUserInputType)
  protected
    { IXMLUserInputType }
    function Get_Entry(Index: Integer): IXMLEntryType;
    function Add: IXMLEntryType;
    function Insert(const Index: Integer): IXMLEntryType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEntryType }

  TXMLEntryType = class(TXMLNode, IXMLEntryType)
  protected
    { IXMLEntryType }
    function Get_Key: WideString;
    function Get_Value: Boolean;
    procedure Set_Key(Value: WideString);
    procedure Set_Value(Value: Boolean);
  end;

{ TXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType }

  TXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType = class(TXMLNode, IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType)
  protected
    { IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType }
    function Get_Id: WideString;
  end;

{ TXMLComizforgeizpackpanelstargetTargetPanelType }

  TXMLComizforgeizpackpanelstargetTargetPanelType = class(TXMLNode, IXMLComizforgeizpackpanelstargetTargetPanelType)
  protected
    { IXMLComizforgeizpackpanelstargetTargetPanelType }
    function Get_Id: WideString;
    function Get_Installpath: WideString;
    procedure Set_Installpath(Value: WideString);
  end;

{ TXMLComizforgeizpackpanelspacksPacksPanelType }

  TXMLComizforgeizpackpanelspacksPacksPanelType = class(TXMLNodeCollection, IXMLComizforgeizpackpanelspacksPacksPanelType)
  protected
    { IXMLComizforgeizpackpanelspacksPacksPanelType }
    function Get_Id: WideString;
    function Get_Pack(Index: Integer): IXMLPackType;
    function Add: IXMLPackType;
    function Insert(const Index: Integer): IXMLPackType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPackType }

  TXMLPackType = class(TXMLNode, IXMLPackType)
  protected
    { IXMLPackType }
    function Get_Index: Integer;
    function Get_Name: WideString;
    function Get_Selected: Boolean;
    procedure Set_Index(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Selected(Value: Boolean);
  end;

{ TXMLComizforgeizpackpanelssummarySummaryPanelType }

  TXMLComizforgeizpackpanelssummarySummaryPanelType = class(TXMLNode, IXMLComizforgeizpackpanelssummarySummaryPanelType)
  protected
    { IXMLComizforgeizpackpanelssummarySummaryPanelType }
    function Get_Id: WideString;
  end;

{ TXMLComizforgeizpackpanelsinstallInstallPanelType }

  TXMLComizforgeizpackpanelsinstallInstallPanelType = class(TXMLNode, IXMLComizforgeizpackpanelsinstallInstallPanelType)
  protected
    { IXMLComizforgeizpackpanelsinstallInstallPanelType }
    function Get_Id: WideString;
  end;

{ TXMLComizforgeizpackpanelsshortcutShortcutPanelType }

  TXMLComizforgeizpackpanelsshortcutShortcutPanelType = class(TXMLNode, IXMLComizforgeizpackpanelsshortcutShortcutPanelType)
  protected
    { IXMLComizforgeizpackpanelsshortcutShortcutPanelType }
    function Get_Id: WideString;
    function Get_CreateShortcuts: Boolean;
    function Get_ProgramGroup: WideString;
    function Get_CreateDesktopShortcuts: Shortint;
    function Get_ShortcutType: WideString;
    procedure Set_CreateShortcuts(Value: Boolean);
    procedure Set_ProgramGroup(Value: WideString);
    procedure Set_CreateDesktopShortcuts(Value: Shortint);
    procedure Set_ShortcutType(Value: WideString);
  end;

{ TXMLComizforgeizpackpanelsprocessProcessPanelType }

  TXMLComizforgeizpackpanelsprocessProcessPanelType = class(TXMLNode, IXMLComizforgeizpackpanelsprocessProcessPanelType)
  protected
    { IXMLComizforgeizpackpanelsprocessProcessPanelType }
    function Get_Id: WideString;
  end;

{ TXMLPanelsSymmetricFinishPanelType }

  TXMLPanelsSymmetricFinishPanelType = class(TXMLNode, IXMLPanelsSymmetricFinishPanelType)
  protected
    { IXMLPanelsSymmetricFinishPanelType }
    function Get_Id: WideString;
  end;

{ TXMLComizforgeizpackpanelsuserinputUserInputPanelType2 }

  TXMLComizforgeizpackpanelsuserinputUserInputPanelType2 = class(TXMLNode, IXMLComizforgeizpackpanelsuserinputUserInputPanelType2)
  protected
    { IXMLComizforgeizpackpanelsuserinputUserInputPanelType2 }
    function Get_Id: Integer;
    procedure Set_Id(Value: Integer);
  end;

{ Fonctions globales }

function GetAutomatedInstallation(Doc: IXMLDocument): IXMLAutomatedInstallationType;
function LoadAutomatedInstallation(const FileName: WideString): IXMLAutomatedInstallationType;
function NewAutomatedInstallation(): IXMLAutomatedInstallationType;

implementation

{ Fonctions globales }

function GetAutomatedInstallation(Doc: IXMLDocument): IXMLAutomatedInstallationType;
begin
  Result := Doc.GetDocBinding('AutomatedInstallation', TXMLAutomatedInstallationType) as IXMLAutomatedInstallationType;
end;

function LoadAutomatedInstallation(const FileName: WideString): IXMLAutomatedInstallationType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('AutomatedInstallation', TXMLAutomatedInstallationType) as IXMLAutomatedInstallationType;
end;

function NewAutomatedInstallation(): IXMLAutomatedInstallationType;
begin
  Result := NewXMLDocument.GetDocBinding('AutomatedInstallation', TXMLAutomatedInstallationType) as IXMLAutomatedInstallationType;
end;

{ TXMLAutomatedInstallationType }

procedure TXMLAutomatedInstallationType.AfterConstruction;
begin
  RegisterChildNode('panels.SymmetricHelloPanel', TXMLPanelsSymmetricHelloPanelType);
  RegisterChildNode('com.izforge.izpack.panels.userinput.UserInputPanel', TXMLComizforgeizpackpanelsuserinputUserInputPanelType);
  RegisterChildNode('com.izforge.izpack.panels.htmllicence.HTMLLicencePanel', TXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType);
  RegisterChildNode('com.izforge.izpack.panels.target.TargetPanel', TXMLComizforgeizpackpanelstargetTargetPanelType);
  RegisterChildNode('com.izforge.izpack.panels.packs.PacksPanel', TXMLComizforgeizpackpanelspacksPacksPanelType);
  RegisterChildNode('com.izforge.izpack.panels.summary.SummaryPanel', TXMLComizforgeizpackpanelssummarySummaryPanelType);
  RegisterChildNode('com.izforge.izpack.panels.install.InstallPanel', TXMLComizforgeizpackpanelsinstallInstallPanelType);
  RegisterChildNode('com.izforge.izpack.panels.shortcut.ShortcutPanel', TXMLComizforgeizpackpanelsshortcutShortcutPanelType);
  RegisterChildNode('com.izforge.izpack.panels.process.ProcessPanel', TXMLComizforgeizpackpanelsprocessProcessPanelType);
  RegisterChildNode('panels.SymmetricFinishPanel', TXMLPanelsSymmetricFinishPanelType);
  FComizforgeizpackpanelsuserinputUserInputPanel := CreateCollection(TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList, IXMLComizforgeizpackpanelsuserinputUserInputPanelType, 'com.izforge.izpack.panels.userinput.UserInputPanel') as IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList;
  inherited;
end;

function TXMLAutomatedInstallationType.Get_Langpack: WideString;
begin
  Result := AttributeNodes['langpack'].NodeValue;
end;

procedure TXMLAutomatedInstallationType.Set_Langpack(Value: WideString);
begin
  SetAttribute('langpack', Value);
end;

function TXMLAutomatedInstallationType.Get_PanelsSymmetricHelloPanel: IXMLPanelsSymmetricHelloPanelType;
begin
  Result := ChildNodes['panels.SymmetricHelloPanel'] as IXMLPanelsSymmetricHelloPanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelsuserinputUserInputPanel: IXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList;
begin
  Result := FComizforgeizpackpanelsuserinputUserInputPanel;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelshtmllicenceHTMLLicencePanel: IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.htmllicence.HTMLLicencePanel'] as IXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelstargetTargetPanel: IXMLComizforgeizpackpanelstargetTargetPanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.target.TargetPanel'] as IXMLComizforgeizpackpanelstargetTargetPanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelspacksPacksPanel: IXMLComizforgeizpackpanelspacksPacksPanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.packs.PacksPanel'] as IXMLComizforgeizpackpanelspacksPacksPanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelssummarySummaryPanel: IXMLComizforgeizpackpanelssummarySummaryPanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.summary.SummaryPanel'] as IXMLComizforgeizpackpanelssummarySummaryPanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelsinstallInstallPanel: IXMLComizforgeizpackpanelsinstallInstallPanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.install.InstallPanel'] as IXMLComizforgeizpackpanelsinstallInstallPanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelsshortcutShortcutPanel: IXMLComizforgeizpackpanelsshortcutShortcutPanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.shortcut.ShortcutPanel'] as IXMLComizforgeizpackpanelsshortcutShortcutPanelType;
end;

function TXMLAutomatedInstallationType.Get_ComizforgeizpackpanelsprocessProcessPanel: IXMLComizforgeizpackpanelsprocessProcessPanelType;
begin
  Result := ChildNodes['com.izforge.izpack.panels.process.ProcessPanel'] as IXMLComizforgeizpackpanelsprocessProcessPanelType;
end;

function TXMLAutomatedInstallationType.Get_PanelsSymmetricFinishPanel: IXMLPanelsSymmetricFinishPanelType;
begin
  Result := ChildNodes['panels.SymmetricFinishPanel'] as IXMLPanelsSymmetricFinishPanelType;
end;

{ TXMLPanelsSymmetricHelloPanelType }

function TXMLPanelsSymmetricHelloPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

procedure TXMLPanelsSymmetricHelloPanelType.Set_Id(Value: WideString);
begin
  SetAttribute('id', Value);
end;

{ TXMLComizforgeizpackpanelsuserinputUserInputPanelType }

procedure TXMLComizforgeizpackpanelsuserinputUserInputPanelType.AfterConstruction;
begin
  RegisterChildNode('userInput', TXMLUserInputType);
  inherited;
end;

function TXMLComizforgeizpackpanelsuserinputUserInputPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelsuserinputUserInputPanelType.Set_Id(Value: WideString);
begin
  SetAttribute('id', Value);
end;

function TXMLComizforgeizpackpanelsuserinputUserInputPanelType.Get_UserInput: IXMLUserInputType;
begin
  Result := ChildNodes['userInput'] as IXMLUserInputType;
end;

{ TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList }

function TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList.Add: IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
begin
  Result := AddItem(-1) as IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
end;

function TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList.Insert(const Index: Integer): IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
begin
  Result := AddItem(Index) as IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
end;

function TXMLComizforgeizpackpanelsuserinputUserInputPanelTypeList.Get_Item(Index: Integer): IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
begin
  Result := List[Index] as IXMLComizforgeizpackpanelsuserinputUserInputPanelType;
end;

{ TXMLUserInputType }

procedure TXMLUserInputType.AfterConstruction;
begin
  RegisterChildNode('entry', TXMLEntryType);
  ItemTag := 'entry';
  ItemInterface := IXMLEntryType;
  inherited;
end;

function TXMLUserInputType.Get_Entry(Index: Integer): IXMLEntryType;
begin
  Result := List[Index] as IXMLEntryType;
end;

function TXMLUserInputType.Add: IXMLEntryType;
begin
  Result := AddItem(-1) as IXMLEntryType;
end;

function TXMLUserInputType.Insert(const Index: Integer): IXMLEntryType;
begin
  Result := AddItem(Index) as IXMLEntryType;
end;

{ TXMLEntryType }

function TXMLEntryType.Get_Key: WideString;
begin
  Result := AttributeNodes['key'].NodeValue;
end;

procedure TXMLEntryType.Set_Key(Value: WideString);
begin
  SetAttribute('key', Value);
end;

function TXMLEntryType.Get_Value: Boolean;
begin
  Result := AttributeNodes['value'].NodeValue;
end;

procedure TXMLEntryType.Set_Value(Value: Boolean);
begin
  SetAttribute('value', Value);
end;

{ TXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType }

function TXMLComizforgeizpackpanelshtmllicenceHTMLLicencePanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

{ TXMLComizforgeizpackpanelstargetTargetPanelType }

function TXMLComizforgeizpackpanelstargetTargetPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

function TXMLComizforgeizpackpanelstargetTargetPanelType.Get_Installpath: WideString;
begin
  Result := ChildNodes['installpath'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelstargetTargetPanelType.Set_Installpath(Value: WideString);
begin
  ChildNodes['installpath'].NodeValue := Value;
end;

{ TXMLComizforgeizpackpanelspacksPacksPanelType }

procedure TXMLComizforgeizpackpanelspacksPacksPanelType.AfterConstruction;
begin
  RegisterChildNode('pack', TXMLPackType);
  ItemTag := 'pack';
  ItemInterface := IXMLPackType;
  inherited;
end;

function TXMLComizforgeizpackpanelspacksPacksPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

function TXMLComizforgeizpackpanelspacksPacksPanelType.Get_Pack(Index: Integer): IXMLPackType;
begin
  Result := List[Index] as IXMLPackType;
end;

function TXMLComizforgeizpackpanelspacksPacksPanelType.Add: IXMLPackType;
begin
  Result := AddItem(-1) as IXMLPackType;
end;

function TXMLComizforgeizpackpanelspacksPacksPanelType.Insert(const Index: Integer): IXMLPackType;
begin
  Result := AddItem(Index) as IXMLPackType;
end;

{ TXMLPackType }

function TXMLPackType.Get_Index: Integer;
begin
  Result := AttributeNodes['index'].NodeValue;
end;

procedure TXMLPackType.Set_Index(Value: Integer);
begin
  SetAttribute('index', Value);
end;

function TXMLPackType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].NodeValue;
end;

procedure TXMLPackType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLPackType.Get_Selected: Boolean;
begin
  Result := AttributeNodes['selected'].NodeValue;
end;

procedure TXMLPackType.Set_Selected(Value: Boolean);
begin
  SetAttribute('selected', Value);
end;

{ TXMLComizforgeizpackpanelssummarySummaryPanelType }

function TXMLComizforgeizpackpanelssummarySummaryPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

{ TXMLComizforgeizpackpanelsinstallInstallPanelType }

function TXMLComizforgeizpackpanelsinstallInstallPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

{ TXMLComizforgeizpackpanelsshortcutShortcutPanelType }

function TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

function TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Get_CreateShortcuts: Boolean;
begin
  Result := ChildNodes['createShortcuts'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Set_CreateShortcuts(Value: Boolean);
begin
  ChildNodes['createShortcuts'].NodeValue := Value;
end;

function TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Get_ProgramGroup: WideString;
begin
  Result := ChildNodes['programGroup'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Set_ProgramGroup(Value: WideString);
begin
  ChildNodes['programGroup'].NodeValue := Value;
end;

function TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Get_CreateDesktopShortcuts: Shortint;
begin
  Result := ChildNodes['createDesktopShortcuts'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Set_CreateDesktopShortcuts(Value: Shortint);
begin
  ChildNodes['createDesktopShortcuts'].NodeValue := Value;
end;

function TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Get_ShortcutType: WideString;
begin
  Result := ChildNodes['shortcutType'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelsshortcutShortcutPanelType.Set_ShortcutType(Value: WideString);
begin
  ChildNodes['shortcutType'].NodeValue := Value;
end;

{ TXMLComizforgeizpackpanelsprocessProcessPanelType }

function TXMLComizforgeizpackpanelsprocessProcessPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

{ TXMLPanelsSymmetricFinishPanelType }

function TXMLPanelsSymmetricFinishPanelType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

{ TXMLComizforgeizpackpanelsuserinputUserInputPanelType2 }

function TXMLComizforgeizpackpanelsuserinputUserInputPanelType2.Get_Id: Integer;
begin
  Result := AttributeNodes['id'].NodeValue;
end;

procedure TXMLComizforgeizpackpanelsuserinputUserInputPanelType2.Set_Id(Value: Integer);
begin
  SetAttribute('id', Value);
end;

end.

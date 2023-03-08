unit IDEVirtualTreesReg;

// This unit is an addendum to VirtualTrees.pas and contains code of design time editors as well as
// for theirs and the tree's registration.

interface

{$include Compilers.inc}

uses
  Windows, Classes,
  {$ifdef COMPILER_6_UP}
    DesignIntf, DesignEditors, VCLEditors, PropertyCategories,
  {$else}
    DsgnIntf,
  {$endif}
  ColnEdit,
  IDEVirtualTrees, IDEVTHeaderPopup;

type
  TVirtualTreeEditor = class (TDefaultEditor)
  public
    procedure Edit; override;
  end;

procedure Register;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  {$ifdef COMPILER_5_UP}
    StrEdit,
  {$else}
    StrEditD4,
  {$endif COMPILER_5_UP}
  Dialogs, TypInfo, SysUtils, Graphics;

resourcestring
  StrCustomPainting = 'Custom Painting';
  StrHeader = 'Header';
  StrIncrementalSearch = 'Incremental Search';
  StrOLEDragAndClipboard = '(OLE drag and clipboard)';
  StrVirtualControls = 'Virtual Controls';
  StrChangeDelay = 'ChangeDelay';
  StrEditDelay = 'EditDelay';

type
  // The usual trick to make a protected property accessible in the ShowCollectionEditor call below.
  TVirtualTreeCast = class(TBaseVirtualTree);

  TClipboardElement = class(TNestedProperty {$ifdef COMPILER_6_UP}, ICustomPropertyDrawing {$endif COMPILER_6_UP})
  private
    FElement: string;
  protected
    constructor Create(Parent: TPropertyEditor; AElement: string); reintroduce;
  public
    function AllEqual: Boolean; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetName: string; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;

    {$ifdef COMPILER_5_UP}
      {$ifdef COMPILER_6_UP}
        procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
      {$endif COMPILER_6_UP}
      procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
        {$ifndef COMPILER_6_UP} override; {$endif COMPILER_6_UP}
    {$endif COMPILER_5_UP}
  end;

  // This is a special property editor to make the strings in the clipboard format string list
  // being shown as subproperties in the object inspector. This way it is shown what formats are actually available
  // and the user can pick them with a simple yes/no choice.

  {$ifdef COMPILER_6_UP}
    TGetPropEditProc = TGetPropProc;
  {$endif}

  TClipboardFormatsProperty = class(TStringListProperty {$ifdef COMPILER_6_UP}, ICustomPropertyDrawing {$endif COMPILER_6_UP})
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetProperties(Proc: TGetPropEditProc); override;
    {$ifdef COMPILER_5_UP}
      procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
        {$ifndef COMPILER_6_UP} override; {$endif}
      procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
        {$ifndef COMPILER_6_UP} override; {$endif}
    {$endif}
  end;

  // Property categories. They are defined this way only for Delphi 5 & BCB 5.
  {$ifdef COMPILER_5}
    TVTHeaderCategory = class(TPropertyCategory)
    public
      class function Name: string; override;
      class function Description: string; override;
    end;

    TVTPaintingCategory = class(TPropertyCategory)
    public
      class function Name: string; override;
      class function Description: string; override;
    end;

    TVTIncrementalSearchCategory = class(TPropertyCategory)
    public
      class function Name: string; override;
      class function Description: string; override;
    end;
  {$endif COMPILER_5}

  {$ifdef COMPILER_6_UP}
    resourcestring
      sVTHeaderCategoryName = 'Header';
      sVTPaintingCategoryName = 'Custom painting';
      sVTIncremenalCategoryName = 'Incremental search';
  {$endif}

//----------------------------------------------------------------------------------------------------------------------

procedure TVirtualTreeEditor.Edit;

begin
  ShowCollectionEditor(Designer, Component, TVirtualTreeCast(Component).Header.Columns, 'Columns');
end;

//----------------------------------------------------------------------------------------------------------------------

constructor TClipboardElement.Create(Parent: TPropertyEditor; AElement: string);

begin
  inherited Create(Parent);
  FElement := AElement;
end;

//----------------------------------------------------------------------------------------------------------------------

function TClipboardElement.AllEqual: Boolean;

// Determines if this element is included or excluded in all selected components it belongs to.

var
  I, Index: Integer;
  List: TClipboardFormats;
  V: Boolean;

begin
  Result := False;
  if PropCount > 1 then
  begin
    List := TClipboardFormats(GetOrdValue);
    V := List.Find(FElement, Index);
    for I := 1 to PropCount - 1 do
    begin
      List := TClipboardFormats(GetOrdValue);
      if List.Find(FElement, Index) <> V then
        Exit;
    end;
  end;
  Result := True;
end;

//----------------------------------------------------------------------------------------------------------------------

function TClipboardElement.GetAttributes: TPropertyAttributes;

begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

//----------------------------------------------------------------------------------------------------------------------

function TClipboardElement.GetName: string;

begin
  Result := FElement;
end;

//----------------------------------------------------------------------------------------------------------------------

function TClipboardElement.GetValue: string;

var
  List: TClipboardFormats;

begin
  List := TClipboardFormats(GetOrdValue);
  Result := BooleanIdents[List.IndexOf(FElement) > -1];
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TClipboardElement.GetValues(Proc: TGetStrProc);

begin
  Proc(BooleanIdents[False]);
  Proc(BooleanIdents[True]);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TClipboardElement.SetValue(const Value: string);

var
  List: TClipboardFormats;
  I, Index: Integer;

begin
  if CompareText(Value, 'True') = 0 then
  begin
    for I := 0 to PropCount - 1 do
    begin
      List := TClipboardFormats(GetOrdValueAt(I));
      List.Add(FElement);
    end;
  end
  else
  begin
    for I := 0 to PropCount - 1 do
    begin
      List := TClipboardFormats(GetOrdValueAt(I));
      if List.Find(FElement, Index) then
        List.Delete(Index);
    end;
  end;
  Modified;
end;

//----------------------------------------------------------------------------------------------------------------------

{$ifdef COMPILER_5_UP}

  procedure DrawBoolean(Checked: Boolean; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);

  var
    BoxSize,
    EntryWidth: Integer;
    R: TRect;
    State: Cardinal;

  begin
    with ACanvas do
    begin
      FillRect(ARect);

      BoxSize := ARect.Bottom - ARect.Top;
      EntryWidth := ARect.Right - ARect.Left;

      R := Rect(ARect.Left + (EntryWidth - BoxSize) div 2, ARect.Top, ARect.Left + (EntryWidth + BoxSize) div 2,
        ARect.Bottom);
      InflateRect(R, -1, -1);
      State := DFCS_BUTTONCHECK;
      if Checked then
        State := State or DFCS_CHECKED;
      DrawFrameControl(Handle, R, DFC_BUTTON, State);
    end;
  end;

//----------------------------------------------------------------------------------------------------------------------

  {$ifdef COMPILER_6_UP}

    procedure TClipboardElement.PropDrawName(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);

    begin
      DefaultPropertyDrawName(Self, ACanvas, ARect);
    end;

  {$endif COMPILER_6_UP}

//----------------------------------------------------------------------------------------------------------------------

  procedure TClipboardElement.PropDrawValue(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);

  begin
    DrawBoolean(CompareText(GetVisualValue, 'True') = 0, ACanvas, ARect, ASelected);
  end;

{$endif COMPILER_5_UP}

//----------------- TClipboardFormatsProperty --------------------------------------------------------------------------

function TClipboardFormatsProperty.GetAttributes: TPropertyAttributes;

begin
  Result := inherited GetAttributes + [paSubProperties {$ifdef COMPILER_5_UP}, paFullWidthName {$endif COMPILER_5_UP}];
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TClipboardFormatsProperty.GetProperties(Proc: TGetPropEditProc);

var
  List: TStringList;
  I: Integer;
  Tree: TBaseVirtualTree;

begin
  List := TStringList.Create;
  Tree := TClipboardFormats(GetOrdValue).Owner;
  EnumerateVTClipboardFormats(TVirtualTreeClass(Tree.ClassType), List);
  for I := 0 to List.Count - 1 do
    Proc(TClipboardElement.Create(Self, List[I]));
  List.Free;
end;

//----------------------------------------------------------------------------------------------------------------------

{$ifdef COMPILER_5_UP}

  procedure TClipboardFormatsProperty.PropDrawName(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);

  var
    S: string;
    Width: Integer;
    R: TRect;

  begin
    with ACanvas do
    begin
      Font.Name := 'Arial'; // Do not localize
      R := ARect;
      Font.Color := clBlack;
      S := GetName;
      Width := TextWidth(S);
      TextRect(R, R.Left + 1, R.Top + 1, S);

      Inc(R.Left, Width + 8);
      Font.Height := 14;
      Font.Color := clBtnHighlight;
      S := StrOLEDragAndClipboard;
      SetBkMode(Handle, TRANSPARENT);
      ExtTextOut(Handle, R.Left + 1, R.Top + 1, ETO_CLIPPED, @R, PChar(S), Length(S), nil);
      Font.Color := clBtnShadow;
      ExtTextOut(Handle, R.Left, R.Top, ETO_CLIPPED, @R, PChar(S), Length(S), nil);
    end;
  end;

//----------------------------------------------------------------------------------------------------------------------

  procedure TClipboardFormatsProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);

  begin
    // Nothing to do here.
  end;

{$endif COMPILER_5_UP}

{$ifdef COMPILER_5}

//----------------- TVTPaintingCategory --------------------------------------------------------------------------------

  class function TVTPaintingCategory.Name: string;

  begin
    Result := StrCustomPainting;
  end;

//----------------------------------------------------------------------------------------------------------------------

  class function TVTPaintingCategory.Description: string;

  begin
    Result := StrCustomPainting;
  end;

//----------------- TVTHeaderCategory ----------------------------------------------------------------------------------

  class function TVTHeaderCategory.Name: string;

  begin
    Result := StrHeader;
  end;

//----------------------------------------------------------------------------------------------------------------------

  class function TVTHeaderCategory.Description: string;

  begin
    Result := StrHeader;
  end;

//----------------- TVTIncrementalSearchCategory -----------------------------------------------------------------------

  class function TVTIncrementalSearchCategory.Name: string;

  begin
    Result := StrIncrementalSearch;
  end;

//----------------------------------------------------------------------------------------------------------------------

  class function TVTIncrementalSearchCategory.Description: string;

  begin
    Result := StrIncrementalSearch;
  end;

//----------------------------------------------------------------------------------------------------------------------

{$endif COMPILER_5}

procedure Register;

begin
  RegisterComponents(StrVirtualControls, [TVirtualStringTree, TVirtualDrawTree, TVTHeaderPopupMenu]);
  RegisterComponentEditor(TVirtualStringTree, TVirtualTreeEditor);
  RegisterComponentEditor(TVirtualDrawTree, TVirtualTreeEditor);
  RegisterPropertyEditor(TypeInfo(TClipboardFormats), nil, '', TClipboardFormatsProperty);

  // Categories:
  {$ifdef COMPILER_5_UP}
    RegisterPropertiesInCategory({$ifdef COMPILER_5} TActionCategory, {$endif} {$ifdef COMPILER_6_UP} sActionCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      [StrChangeDelay,
       StrEditDelay]);

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TDataCategory, {$endif} {$ifdef COMPILER_6_UP} sDataCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['NodeDataSize', // Do not localize
       'RootNodeCount', // Do not localize
       'OnCompareNodes', // Do not localize
       'OnGetNodeDataSize', // Do not localize
       'OnInitNode', // Do not localize
       'OnInitChildren', // Do not localize
       'OnFreeNode', // Do not localize
       'OnGetNodeWidth', // Do not localize
       'OnGetPopupMenu', // Do not localize
       'OnLoadNode', // Do not localize
       'OnSaveNode', // Do not localize
       'OnResetNode', // Do not localize
       'OnNodeMov*', // Do not localize
       'OnStructureChange', // Do not localize
       'OnUpdating', // Do not localize
       'OnGetText', // Do not localize
       'OnNewText', // Do not localize
       'OnShortenString']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TLayoutCategory, {$endif} {$ifdef COMPILER_6_UP} slayoutCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['AnimationDuration', // Do not localize
       'AutoExpandDelay', // Do not localize
       'AutoScroll*', // Do not localize
       'ButtonStyle', // Do not localize
       'DefaultNodeHeight', // Do not localize
       '*Images*', 'OnGetImageIndex', // Do not localize
       'Header', // Do not localize
       'Indent', // Do not localize
       'LineStyle', 'OnGetLineStyle', // Do not localize
       'CheckImageKind', // Do not localize
       'Options', // Do not localize
       'Margin', // Do not localize
       'NodeAlignment', // Do not localize
       'ScrollBarOptions', // Do not localize
       'SelectionCurveRadius', // Do not localize
       'TextMargin']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TVisualCategory, {$endif} {$ifdef COMPILER_6_UP} sVisualCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['Background*', // Do not localize
       'ButtonFillMode', // Do not localize
       'CustomCheckimages', // Do not localize
       'Colors', // Do not localize
       'LineMode']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} THelpCategory, {$endif} {$ifdef COMPILER_6_UP} sHelpCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['Hint*', 'On*Hint*', 'On*Help*']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TDragNDropCategory, {$endif} {$ifdef COMPILER_6_UP} sDragNDropCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['ClipboardFormats', // Do not localize
       'DefaultPasteMode', // Do not localize
       'OnCreateDataObject', // Do not localize
       'OnCreateDragManager', // Do not localize
       'OnGetUserClipboardFormats', // Do not localize
       'OnNodeCop*', // Do not localize
       'OnDragAllowed', // Do not localize
       'OnRenderOLEData']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TInputCategory, {$endif} {$ifdef COMPILER_6_UP} sInputCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['DefaultText', // Do not localize
       'DrawSelectionMode', // Do not localize
       'WantTabs', // Do not localize
       'OnChang*', // Do not localize
       'OnCollaps*', // Do not localize
       'OnExpand*', // Do not localize
       'OnCheck*', // Do not localize
       'OnEdit*', // Do not localize
       'On*Click', // Do not localize
       'OnFocus*', // Do not localize
       'OnCreateEditor', // Do not localize
       'OnScroll', // Do not localize
       'OnHotChange']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TVTHeaderCategory, {$endif} {$ifdef COMPILER_6_UP} sVTHeaderCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['OnHeader*', 'OnGetHeader*']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TVTPaintingCategory, {$endif} {$ifdef COMPILER_6_UP} sVTPaintingCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['On*Paint*', // Do not localize
       'OnDraw*', // Do not localize
       'On*Erase*']); // Do not localize

    RegisterPropertiesInCategory({$ifdef COMPILER_5} TVTIncrementalSearchCategory, {$endif} {$ifdef COMPILER_6_UP} sVTIncremenalCategoryName, {$endif COMPILER_6_UP}
      TBaseVirtualTree,
      ['*Incremental*']); // Do not localize
  {$endif COMPILER_5_UP}
end;

//----------------------------------------------------------------------------------------------------------------------

end.

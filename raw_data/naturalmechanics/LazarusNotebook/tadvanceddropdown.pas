unit TAdvancedDropDown;

{$mode ObjFPC}{$H+}{$modeswitch advancedrecords}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls,BCLabel, bgraControls,BCTypes, math, BCPanel;

type

  TProc          = procedure(AParm: TObject) of object;
  TStringArray = Array of String;

  { TAdvancedDropDownList }

  TAdvancedDropDownList = Class

    public
      currPos   : Integer;
      items     : TStringArray;

      renderContainer : TBCPanel;
      dropDown        : TBCPanel;
      itemView        : TListBox ;

      containerHeight : Integer;
      containerWidth  : Integer;
      containerColor  : TColor;
      containerBorderColor : TColor;
      containerFontColors : Array of TColor;
      containerBorderWidth : Integer;
      containerFontNames   : Array of String;
      containerFontSizes   : Array of Integer;
      containerFontStyles   : Array of Integer;
      containerFontBackGrounds : Array of TColor;

      cpanels       : Array of TBCPanel;
      sBarH         : TScrollbar;
      sBarV         : TScrollBar;

      selectedItem : Integer;

      dropDownOn   : Boolean;
      dropDownWidth: Integer;
      dropDownHeight:Integer;
      setFullWidth : Boolean;

      totalWidth   : Integer;

      bottom_ofAll  : Integer;
      top_ofAll     : Integer;
      bottomPadding : Integer;

      debugLabel    : TBCLabel;
      allowOverFlow : Boolean;
      overFlowCounter: Integer;

      constructor Create();

      procedure Initialize(entryItems: TStringArray);
      procedure Render(pPanel : TBCPanel);
      procedure toggleDropDown(Sender : TObject) ;
      procedure selectItem(Sender: TObject; User: boolean);



  end;

implementation

{ TAdvancedDropDownList }

constructor TAdvancedDropDownList.Create;

begin




  // containerHeight := Floor(0.5 * Length(items)) * 1;


end;

procedure TAdvancedDropDownList.Initialize(entryItems: TStringArray);
var

  i             : Integer;
  totalHeight   : Integer;
  maxWidth      : Integer;
  fnt           : TFont;
  currWidth     : Integer;

  c             : TBitmap;
begin

  renderContainer := TBCPanel.Create(Nil);
  renderContainer.Parent := Nil;

  itemView := TListBox.Create(Nil);
  itemView.Parent := Nil;

  setLength(items, 0);
  items         := entryitems;

  selectedItem := 0;

  containerColor  := clForm;
  containerBorderColor := clGrayText;

  SetLength( containerFontColors, 0);
  for i := 0 to Length(items) - 1 do
  begin
    SetLength( containerFontColors, Length(containerFontColors) + 1);
    containerFontColors[Length(containerFontColors) - 1] := clWindowText;
  end;


  containerBorderColor := clGrayText;
  containerBorderWidth := 1;


  SetLength( containerFontNames, 0);
  for i := 0 to Length(items) - 1 do
  begin
    SetLength( containerFontNames, Length(containerFontNames) + 1);
    containerFontNames[Length(containerFontNames) - 1] := Screen.SystemFont.Name;
  end;



  SetLength( containerFontSizes, 0);
  for i := 0 to Length(items) - 1 do
  begin
    SetLength( containerFontSizes, Length(containerFontSizes) + 1);
    containerFontSizes[Length(containerFontSizes) - 1] := 0;
  end;


  SetLength( containerFontStyles, 0);
  for i := 0 to Length(items) - 1 do
  begin
    SetLength( containerFontStyles, Length(containerFontStyles) + 1);
    containerFontStyles[Length(containerFontStyles) - 1] := 0;
  end;


  SetLength( containerFontBackGrounds, 0);
  for i := 0 to Length(items) - 1 do
  begin
    SetLength( containerFontBackGrounds, Length(containerFontBackGrounds) + 1);
    containerFontBackGrounds[Length(containerFontBackGrounds) - 1] := clForm;
  end;

  dropDownOn    := False;

  dropDownWidth := -1;
  dropDownHeight:= -1;

  setFullWidth  := False;

  maxWidth    := 0;





  totalHeight := 0;

  for i := 0 to Length(items) - 1 do
  begin

   fnt       := TFont.Create;
   fnt.Name  := containerFontNames[i];

   c := TBitmap.Create;
   c.Canvas.Font.Assign(fnt);
   currWidth  := c.Canvas.TextWidth(items[i]) + 4; //-----------------------// Label width

   c.Free;

   itemView.Items.Add(items[i]);

   if maxWidth < currWidth then
   begin
    maxWidth := currWidth;
   end;

   totalHeight:= totalHeight + fnt.GetTextHeight('AyTg') + 4 + 2;

  end;

  itemView.Height:=totalHeight+2;
  itemView.Width:= maxWidth+4;

  itemView.ScrollWidth := 10;

  totalWidth    := maxWidth + 5;


  if (dropDownWidth <> -1) then
  begin
  itemView.Width:=dropDownWidth;
  end;

  if (dropDownHeight <> -1) then
  begin
  itemView.Height:=dropDownHeight;
  end;

  if not setFullWidth then
  begin
    itemView.Height := Floor(itemView.Height div 2)  ;
  end;



  itemView.OnSelectionChange:=@selectItem;

  allowOverFlow := False;
  overFlowCounter:= 1;
  {TODO : Implement bevel controls}
end;



procedure TAdvancedDropDownList.Render(pPanel: TBCPanel);
var
  mPanel          : TBCPanel;
begin


  //---------------   Attach the top Panel to the container    -------------------//

  // mPanel        := TBCPanel.Create(Nil);
  renderContainer.Parent := pPanel;



  renderContainer.Caption:= items[selectedItem];

  renderContainer.FontEx.Color:= containerFontColors[selectedItem] ;

  renderContainer.Height := pPanel.Height;
  renderContainer.Width  := pPanel.Width ;

  renderContainer.BevelOuter:=bvNone;

  renderContainer.Color:= containerColor;

  renderContainer.Border.Color:= containerBorderColor;
  renderContainer.Border.Width:= containerBorderWidth;

  renderContainer.Border.Style:=bboSolid;
  renderContainer.BorderBCStyle:= bpsBorder;

  renderContainer.Rounding.RoundX:=5;
  renderContainer.Rounding.RoundY:=5;

  mPanel := TBCPanel.Create(renderContainer);
  mPanel.Parent := renderContainer;

  mPanel.Height := renderContainer.Height - 4;
  mPanel.Top    := 2;

  mPanel.Width  := mPanel.Height;
  renderContainer.FontEx.PaddingRight:= mPanel.Width + 4;
  renderContainer.FontEx.PaddingLeft :=                4;
  renderContainer.FontEx.TextAlignment:=bcaLeftCenter;
  mPanel.Caption:='ᐯ';
  mPanel.Left   := renderContainer.Width - mPanel.Width - 2;

  mPanel.BevelOuter:=bvNone;

  mPanel.FontEx.Color:=clWindowText;
  mPanel.OnClick:= @toggleDropDown;

  bottom_ofAll  := -1;
  top_ofAll     := -1;

  bottomPadding := 2;



end;

procedure TAdvancedDropDownList.toggleDropDown(Sender: TObject);
var
  i             : Integer;
  cPanel        : TBCPanel;

  scWidth       : Integer;



begin

  if not dropDownOn then
  begin

    itemView.Top:=((Sender as TBCPanel).Parent.Parent as TBCPanel).Top + ((Sender as TBCPanel).Parent.Parent as TBCPanel).Height;
    itemView.Left:=((Sender as TBCPanel).Parent.Parent as TBCPanel).Left;

    if allowOverflow then
    begin
      itemView.Parent := (Sender as TBCPanel).Parent.Parent.Parent;
      for i := 1 to overFlowCounter do
      begin

       itemView.Top:= itemView.Top + itemView.Parent.Top;
       itemView.Left:=itemView.Left+ itemView.Parent.Left;
       itemView.Parent := itemView.Parent.Parent;

      end;


      // showMessage(   itemView.Parent.Name);
    end
    else
    begin
     itemView.Parent := (Sender as TBCPanel).Parent.Parent.Parent;

    end;

    if setFullWidth then
    begin

      itemView.Width:=totalWidth;
      scWidth         := itemView.Width - itemView.ClientWidth;
      itemView.Width  := itemView.Width + scWidth;

    end;




    itemView.Visible:=True;
    dropDownOn      := True;
  end
  else
  begin
    itemView.Visible:=False;
    dropDownOn      :=False;
  end;
end;

procedure TAdvancedDropDownList.selectItem(Sender: TObject; User: boolean);
var
  lView         : TListBox;
begin
  lView         := Sender as TListBox;

  renderContainer.Caption:=lView.GetSelectedText;
  selectedItem  := lView.ItemIndex;
  itemView.Visible:=False;
  dropDownOn      :=False;

end;

end.



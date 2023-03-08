unit MICMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, ComCtrls, ToolWin, Db, DBTables, DBCtrls,
  Buttons, StdCtrls, ImgList, Mask ;

const ItemDescFileName      = '.\ITEMDESC.TXT';
const MagicDescFileName     = '.\MAGICDESC.TXT';
const MonsterDescFileName   = '.\MONSTERDESC.TXT';
const MobItemDescFileName   = '.\MOBITEMDESC.TXT';

type
  TTabInfo = ( tiITEM , tiMAGIC , tiMONSTER , tiMOBITEM );

  TMIEForm = class(TForm)
    ToolBar1: TToolBar;
    InfoBar: TStatusBar;
    ToolButton1: TToolButton;
    ConnBtn: TToolButton;
    DisConnBtn: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    DataPage: TPageControl;
    ItemTab: TTabSheet;
    MagicTab: TTabSheet;
    MobTab: TTabSheet;
    Panel1: TPanel;
    LeftLockBtn: TSpeedButton;
    RightLockBtn: TSpeedButton;
    LeftNavigator: TDBNavigator;
    DBEdit1: TDBEdit;
    RightNavigator: TDBNavigator;
    LeftGrid: TDBGrid;
    Splitter1: TSplitter;
    RightGrid: TDBGrid;
    Bevel1: TBevel;
    Panel2: TPanel;
    Panel3: TPanel;
    ItemDBGrid: TDBGrid;
    MagicDBGrid: TDBGrid;
    ItemDBNavigator: TDBNavigator;
    MagicDBNavigator: TDBNavigator;
    ItemEditBtn: TSpeedButton;
    MgicEditBtn: TSpeedButton;
    DBEdit3: TDBEdit;
    ItemFindEdit: TEdit;
    ItemFindBtn: TButton;
    MagicFindBtn: TButton;
    MagicFindEdit: TEdit;
    DBEdit2: TDBEdit;
    MobFindBtn: TButton;
    MobFindEdit: TEdit;
    MobItemTab: TTabSheet;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    ItemBox: TComboBox;
    ITemQuertBtn: TBitBtn;
    procedure ConnBtnClick(Sender: TObject);
    procedure DisConnBtnClick(Sender: TObject);
    procedure LeftLockBtnClick(Sender: TObject);
    procedure RightLockBtnClick(Sender: TObject);
    procedure MgicEditBtnClick(Sender: TObject);
    procedure ItemEditBtnClick(Sender: TObject);
    procedure ItemDBGridColEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MagicDBGridColEnter(Sender: TObject);
    procedure LeftGridColEnter(Sender: TObject);
    procedure RightGridColEnter(Sender: TObject);
    procedure ItemDBNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    procedure MagicDBNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    procedure LeftNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    procedure RightNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    procedure ItemFindBtnClick(Sender: TObject);
    procedure ItemFindEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MagicFindEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MagicFindBtnClick(Sender: TObject);
    procedure MobFindBtnClick(Sender: TObject);
    procedure MobFindEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ITemQuertBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    FITemFieldDesc      : TStringList;
    FMagicFieldDesc     : TStringList;
    FMonsterFieldDesc   : TStringList;
    FMObItemFieldDesc   : TStringList;
    procedure ShowConnectInfo( Params : TStrings);
    function  GetFiledDesc( TabInfo : TTabInfo ; FieldName : String ) :string;
    procedure PostKeyEx( hWindow: HWnd; key: Word; Const shift: TShiftState; specialkey: Boolean );
    procedure LastInsert( Button : TNavigateBtn ; DBGrid : TDBGrid );
    procedure SetEditable( SpeedBtn : TSpeedButton ; Grid : TDBGrid ; Navigator :TDBNavigator);
  public
    { Public declarations }
  end;

var
  MIEForm: TMIEForm;

implementation
  uses
    MCIDATA ;

{$R *.DFM}
procedure TMIEForm.PostKeyEx( hWindow: HWnd; key: Word; Const shift: TShiftState; specialkey: Boolean );
type
    TBuffers = Array [0..1] of TKeyboardState;
var
    pKeyBuffers : ^TBuffers;
    lparam      : LongInt;
begin
    {check if the target window exists}
    if IsWindow(hWindow) then
    begin
        {set local variables to default values}
        pKeyBuffers := Nil;
        lparam := MakeLong(0, MapVirtualKey(key, 0));

        {modify lparam if special key requested}
        if specialkey then
            lparam := lparam or $1000000;

        {allocate space for the key state buffers}
        New(pKeyBuffers);


        try
        {Fill buffer 1 with current state so we can later restore it. Null out buffer 0 to get a
        "no key pressed" state.}
        GetKeyboardState( pKeyBuffers^[1] );
        FillChar(pKeyBuffers^[0], Sizeof(TKeyboardState), 0);

        {set the requested modifier keys to "down" state in the buffer}
        if ssShift in Shift then
            pKeyBuffers^[0][VK_SHIFT] := $80;

        if ssAlt in Shift then
        begin
            {Alt needs special treatment since a bit in lparam needs also be set}
            pKeyBuffers^[0][VK_MENU] := $80;
            lparam := lparam or $20000000;
        end;

        if ssCtrl in Shift then
            pKeyBuffers^[0][VK_CONTROL] := $80;
        if ssLeft in Shift then
            pKeyBuffers^[0][VK_LBUTTON] := $80;
        if ssRight in Shift then
            pKeyBuffers^[0][VK_RBUTTON] := $80;
        if ssMiddle in Shift then
            pKeyBuffers^[0][VK_MBUTTON] := $80;

        {make out new key state array the active key state map}
        SetKeyboardState( pKeyBuffers^[0] );

        {post the key messages}
        if ssAlt in Shift then
        begin
            PostMessage( hWindow, WM_SYSKEYDOWN, key, lparam);
            PostMessage( hWindow, WM_SYSKEYUP, key, lparam or $C0000000);
        end
        else
        begin
            PostMessage( hWindow, WM_KEYDOWN, key, lparam);
            PostMessage( hWindow, WM_KEYUP, key, lparam or $C0000000);
        end;

        {process the messages}
        Application.ProcessMessages;

        {restore the old key state map}
        SetKeyboardState( pKeyBuffers^[1] );

        finally
        {free the memory for the key state buffers}
        if pKeyBuffers <> Nil then
            Dispose( pKeyBuffers );
        end;

    end;
end;

procedure TMIEForm.ShowConnectInfo( Params : TStrings);
begin

    Infobar.SimpleText := RES_DATAS.GetInfo;

end;

function TMIEForm.GetFiledDesc( TabInfo : TTabInfo ; FieldName : String ) :string;
var
    InfoList : TStringList;
begin
    case TabInfo of
    tiITEM      : InfoList := FITemFieldDesc    ;
    tiMAGIC     : InfoList := FMagicFieldDesc   ;
    tiMONSTER   : InfoList := FMonsterFieldDesc ;
    tiMOBITEM   : InfoList := FMObItemFieldDesc ;
    end;

    Result :=  ( InfoList.Values[FieldName] );

end;

procedure TMIEForm.ConnBtnClick(Sender: TObject);
begin
    if not RES_DATAS.Connected then
    begin
        RES_DATAS.Connect;

        RES_DATAS.LoadItemNameList( LeftGrid.Columns[0].PickList );
        ItemBox.Items.Assign ( LeftGrid.Columns[0].PickList );
    end;

    if FileExists( ItemDescFileName )then
       FITemFieldDesc.LoadFromFile( ItemDescFileName );
    if FileExists( MagicDescFileName )then
       FMagicFieldDesc.LoadFromFile( MagicDescFileName );
    if FileExists( MonsterDescFileName )then
       FMonsterFieldDesc.LoadFromFile( MonsterDescFileName );
    if FileExists( MobItemDescFileName )then
       FMObItemFieldDesc.LoadFromFile( MobItemDescFileName );

end;

procedure TMIEForm.DisConnBtnClick(Sender: TObject);
begin
    RES_DATAS.DisConnect;
end;

procedure TMIEForm.SetEditable( SpeedBtn : TSpeedButton ; Grid : TDBGrid ; Navigator :TDBNavigator);
begin
    Grid.ReadOnly := not SpeedBtn.down;

    if SpeedBtn.down then
    begin
       SpeedBtn.Caption := 'EDITABLE';
       Navigator.VisibleButtons := Navigator.VisibleButtons + [nbInsert,nbDelete];
    end
    else
    begin
       SpeedBtn.Caption := 'DONTEDIT';
       Navigator.VisibleButtons := Navigator.VisibleButtons - [nbInsert,nbDelete];
    end;

end;

procedure TMIEForm.LeftLockBtnClick(Sender: TObject);
begin
    SetEditable( (Sender As TSpeedButton ), LeftGrid , LeftNavigator );

end;

procedure TMIEForm.RightLockBtnClick(Sender: TObject);
begin
    SetEditable( (Sender As TSpeedButton ), RightGrid , RightNavigator );

end;

procedure TMIEForm.MgicEditBtnClick(Sender: TObject);
begin
    SetEditable( (Sender As TSpeedButton ), MagicDBGrid , MagicDBNavigator );
end;

procedure TMIEForm.ItemEditBtnClick(Sender: TObject);
begin
    SetEditable( (Sender As TSpeedButton ), ItemDBGrid , ItemDBNavigator );
end;


procedure TMIEForm.FormCreate(Sender: TObject);
var
    temp: string;
begin
    FITemFieldDesc      := TStringList.Create;
    FMagicFieldDesc     := TStringList.Create;
    FMonsterFieldDesc   := TStringList.Create;
    FMObItemFieldDesc   := TStringList.Create;

{$IFDEF _VIEWER}
    ItemEditBtn.Enabled := FALSE;
    MgicEditBtn.Enabled := FALSE;
    LeftLockBtn.Enabled := FALSE;
    RightLockBtn.Enabled := FALSE;

    Caption := 'MIR2 DATA Viewer v 1.6';
{$ENDIF}
end;

procedure TMIEForm.FormDestroy(Sender: TObject);
begin
    FITemFieldDesc.Free;
    FMagicFieldDesc.Free;
    FMonsterFieldDesc.Free;
    FMObItemFieldDesc.Free;

end;

procedure TMIEForm.ItemDBGridColEnter(Sender: TObject);
begin
    InfoBar.SimpleText :=
        GetFiledDesc(tiITEM , (Sender As TDBGrid ).SelectedField.FieldName );
end;

procedure TMIEForm.MagicDBGridColEnter(Sender: TObject);
begin
    InfoBar.SimpleText :=
        GetFiledDesc(tiMAGIC , (Sender As TDBGrid ).SelectedField.FieldName );

end;

procedure TMIEForm.LeftGridColEnter(Sender: TObject);
begin
    InfoBar.SimpleText :=
        GetFiledDesc(tiMOBITEM , (Sender As TDBGrid ).SelectedField.FieldName );

end;

procedure TMIEForm.RightGridColEnter(Sender: TObject);
begin
    InfoBar.SimpleText :=
        GetFiledDesc(tiMONSTER , (Sender As TDBGrid ).SelectedField.FieldName );

end;

procedure TMIEForm.LastInsert( Button : TNavigateBtn ; DBGrid : TDBGrid );
begin
    if ( Button = nbInsert ) and not DBGrid.ReadOnly then
    begin
        DBGrid.DataSource.DataSet.Last;
        PostKeyEx( DBGrid.Handle , VK_DOWN ,[],false);
    end;

end;

procedure TMIEForm.ItemDBNavigatorClick(Sender: TObject;
  Button: TNavigateBtn);
begin
    LastInsert( Button  , ItemDBGrid  );

end;

procedure TMIEForm.MagicDBNavigatorClick(Sender: TObject;
  Button: TNavigateBtn);
begin
    LastInsert( Button  , MagicDBGrid  );

end;

procedure TMIEForm.LeftNavigatorClick(Sender: TObject;
  Button: TNavigateBtn);
begin
    LastInsert( Button  , LeftGrid  );

end;

procedure TMIEForm.RightNavigatorClick(Sender: TObject;
  Button: TNavigateBtn);
begin
    LastInsert( Button  , RightGrid  );


end;

procedure TMIEForm.ItemFindBtnClick(Sender: TObject);
begin
    RES_DATAS.ItemTable.Locate( 'NAME' , ItemFindEdit.Text , [loPartialKey]	 );
end;

procedure TMIEForm.ItemFindEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ((Sender AS TEdit).Text <> '') and ( Key = VK_RETURN ) then
        ItemFindBtn.Click;
end;

procedure TMIEForm.MagicFindBtnClick(Sender: TObject);
begin
    RES_DATAS.MagicTable.Locate( 'NAME' , MagicFindEdit.Text , [loPartialKey]	 );
end;

procedure TMIEForm.MagicFindEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ((Sender AS TEdit).Text <> '') and ( Key = VK_RETURN ) then
        MagicFindBtn.Click;

end;


procedure TMIEForm.MobFindBtnClick(Sender: TObject);
begin
    RES_DATAS.RightTable.Locate( 'NAME' , MobFindEdit.Text , [loPartialKey]	 );
end;

procedure TMIEForm.MobFindEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ((Sender AS TEdit).Text <> '') and ( Key = VK_RETURN ) then
        MobFindBtn.Click;

end;

procedure TMIEForm.ITemQuertBtnClick(Sender: TObject);
begin
    if ItemBox.Text <> '' then
    begin
      RES_DATAS.MobItemQuery.Active := false;
      RES_DATAS.MobItemQuery.SQL.Clear;
      RES_DATAS.MobItemQuery.SQL.Add( 'select MOBNAME , ITEMNAME from RES_MOBITEM where ITEMNAME='''+ItemBox.Text+'''');
      RES_DATAS.MobItemQuery.Active := true;
    end;
end;

procedure TMIEForm.DBGrid1DblClick(Sender: TObject);
var
    str : string;
begin
    str := RES_DATAS.MobItemQuery.FieldByName('MOBNAME').AsString;

    if str <> '' then
    begin
        MobFindEdit.Text := str;
        MobFindBtn.Click;
        DataPage.ActivePageIndex := 2;
    end;


end;

end.

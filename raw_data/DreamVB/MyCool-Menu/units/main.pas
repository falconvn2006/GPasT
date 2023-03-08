unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Tools,
  IniFiles, LCLType, ExtCtrls, ComCtrls, LCLIntf, Menus, Buttons, about;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    cmdbrowse: TBitBtn;
    cmdInfo: TBitBtn;
    cmdExit: TBitBtn;
    ImgLogo: TImage;
    lstApps: TListBox;
    LstIcons: TImageList;
    Separator2: TMenuItem;
    mnuWeb: TMenuItem;
    Separator1: TMenuItem;
    mnubrowse: TMenuItem;
    mnuMain: TMainMenu;
    mnuAbout: TMenuItem;
    mnuHelp: TMenuItem;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    pImgHolder: TPanel;
    StatusBar1: TStatusBar;
    TabPage1: TTabControl;
    procedure cmdbrowseClick(Sender: TObject);
    procedure cmdExitClick(Sender: TObject);
    procedure cmdInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstAppsDblClick(Sender: TObject);
    procedure lstAppsDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure lstAppsMeasureItem(Control: TWinControl; Index: integer;
      var AHeight: integer);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnubrowseClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuWebClick(Sender: TObject);
    procedure TabPage1Change(Sender: TObject);
  private
    procedure LoadMenu;
    procedure LoadApps(Selection: string);
    procedure ExecApp(Selection: string; Index: integer);
    function ReadAboutInfo(Value: string): string;
    function ReadButtonsInfo(Value,iDefault : String) : String;
    function ReadMenuInfo(Value,iDefault : String) : String;
    procedure ReadButtonImageInfo;
  public

  end;

var
  frmmain: Tfrmmain;
  TabPageCaption: string;
  mnuCfg: TIniFile;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.ReadButtonImageInfo;
Var
  lzFile1,lzFile2,lzFile3 : String;
  mImage : TPicture;
  bmp : TBitmap;
begin

   lzFile1 := AppPath + mnucfg.ReadString('button-images','about','');
   lzFile2 := AppPath + mnucfg.ReadString('button-images','browse','');
   lzFile3 := AppPath + mnucfg.ReadString('button-images','exit','');

   mImage := TPicture.Create;
   bmp := TBitmap.Create;

   if FileExists(lzFile1) then
   begin
     mImage.LoadFromFile(lzFile1);
     bmp.Assign(mImage.Graphic);
     cmdInfo.Glyph := bmp;
   end;
   if FileExists(lzFile2) then
   begin
     mImage.LoadFromFile(lzFile2);
     bmp.Assign(mImage.Graphic);
     cmdbrowse.Glyph := bmp;
   end;
   if FileExists(lzFile3) then
   begin
     mImage.LoadFromFile(lzFile3);
     bmp.Assign(mImage.Graphic);
     cmdExit.Glyph := bmp;
   end;

   FreeAndNil(mImage);
   FreeAndNil(bmp);
end;

function Tfrmmain.ReadAboutInfo(Value: string): string;
begin
  Result := mnucfg.ReadString('about', Value, '');
end;

function Tfrmmain.ReadButtonsInfo(Value,iDefault : String) : String;
begin
  Result := mnucfg.ReadString('buttons',Value,'');
end;

function Tfrmmain.ReadMenuInfo(Value,iDefault : String) : String;
begin
  Result := mnucfg.ReadString('menus',Value,iDefault);
end;

procedure Tfrmmain.ExecApp(Selection: string; Index: integer);
var
  lzFile: string;
begin
  lzFile := AppPath + mnuCfg.ReadString(Selection, 'exec' + IntToStr(Index), '');

  if not OpenDocument(lzFile) then
  begin
    MessageDlg(Text, 'An error occurred opening the filename:' +
      sLineBreak + sLineBreak + lzFile, mtError, [mbOK], 0);
  end;
end;

procedure Tfrmmain.LoadMenu;
var
  TabCount, X: integer;
  TabCaption: string;
  lzLogoFile: string;
begin
  //Set form caption.
  Caption := mnuCfg.ReadString('general', 'caption', 'menu');
  //Get menu logo
  lzLogoFile := AppPath + mnuCfg.ReadString('general', 'logo', '');
  //Get number of tabs to create.
  TabCount := mnuCfg.ReadInteger('general', 'tabs', 0);

  //Set logo image
  if FileExists(lzLogoFile) then
  begin
    ImgLogo.Picture.LoadFromFile(lzLogoFile);
  end;

  //Create the tabs
  for X := 0 to TabCount do
  begin
    TabCaption := mnuCfg.ReadString('tab' + IntToStr(X), 'caption', '');
    //App tab
    TabPage1.Tabs.Add(TabCaption);
  end;
end;

procedure Tfrmmain.LoadApps(Selection: string);
var
  AppCount, X: integer;
  bmp: TBitmap;
  StrIdx: string;
  mImage: TPicture;
  AppIcon: string;
begin
  //Create bitmap object
  bmp := TBitmap.Create;
  //Get app count
  AppCount := mnuCfg.ReadInteger(Selection, 'count', 0);

  //Get app count
  AppCount := mnuCfg.ReadInteger(Selection, 'count', 0);

  //Clear imagelist.
  lstIcons.Clear;
  //Clear menu items.
  lstApps.Clear;

  for X := 0 to AppCount do
  begin
    //Get X as string
    StrIdx := IntToStr(X);
    //Get icon
    AppIcon := AppPath + mnuCfg.ReadString(Selection, 'icon' + StrIdx, '');

    if FileExists(AppIcon) then
    begin
      mImage := TPicture.Create;
      mImage.LoadFromFile(AppIcon);
      bmp.Assign(mImage.Graphic);
      lstIcons.Add(bmp, nil);
    end;
    //Add menu app titles
    lstApps.Items.Add(mnucfg.ReadString(Selection, 'caption' + StrIdx, ''));
  end;

  //Clear up image stuff
  FreeAndNil(mImage);
  FreeAndNil(bmp);

end;

procedure Tfrmmain.FormCreate(Sender: TObject);
var
  S: string;
begin
  //Remove the programs file ext and return just the exe name and append .ini
  S := RemoveFileExt(ExtractFileName(Application.ExeName)) + '.ini';

  //Current app path the menu is running from
  AppPath := FixPath(ExtractFileDir(Application.ExeName));
  Tools.cfgFile := AppPath + S;

  //Check if the menu config file is found.
  if not FileExists(Tools.cfgFile) then
  begin
    MessageDlg('Error', 'Cannot find menu file.' + sLineBreak +
      sLineBreak + Tools.cfgFile,
      mtError, [mbOK], 0);
    //Exit app
    Application.Terminate;
  end;

  //Menu data location.
  mnuCfg := TIniFile.Create(Tools.cfgFile);

  //Load menu info
  LoadMenu;
  //Load button info
  cmdbrowse.Caption := ReadButtonsInfo('browse','Browse');
  cmdInfo.Caption := ReadButtonsInfo('about','About');
  cmdExit.Caption := ReadButtonsInfo('exit','Close');
  //Load menu info
  mnufile.Caption := ReadMenuInfo('file','file');
  mnubrowse.Caption := ReadMenuInfo('browse','Browse Menu');
  mnuExit.Caption := ReadMenuInfo('exit','E&xit');
  mnuHelp.Caption := ReadMenuInfo('help','&Help');
  mnuabout.Caption := ReadMenuInfo('about','About');
  mnuweb.Caption := ReadMenuInfo('web','Visit Website');
  //
  ReadButtonImageInfo;

  //First tab
  TabPageCaption := 'tab0';
  //Load the first tab
  if TabPage1.Tabs.Count > 0 then
  begin
    //Load apps into the listbox.
    LoadApps(TabPageCaption);
  end;
end;

procedure Tfrmmain.cmdExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrmmain.cmdbrowseClick(Sender: TObject);
begin
  OpenDocument(AppPath);
end;

procedure Tfrmmain.cmdInfoClick(Sender: TObject);
begin
  mnuAboutClick(Sender);
end;

procedure Tfrmmain.lstAppsDblClick(Sender: TObject);
var
  idx: integer;
begin
  idx := lstApps.ItemIndex;
  if idx <> -1 then
  begin
    //Open appliaction
    ExecApp(TabPageCaption, idx);
  end;
end;

procedure Tfrmmain.lstAppsDrawItem(Control: TWinControl; Index: integer;
  ARect: TRect; State: TOwnerDrawState);
var
  th: integer;
  lzAppDest: string;
begin
  if odSelected in State then
  begin
    lstApps.Canvas.Brush.Color := $00FF8080;
  end;

  //Draw the icons in the listbox
  lstApps.Canvas.FillRect(ARect);
  lstApps.Canvas.Font.Color := clBlack;
  //Draw the icon on the listbox from the image list.
  lstIcons.Draw(lstApps.Canvas, ARect.Left + 4, ARect.Top + 4, index);
  //Get height if title text
  th := lstApps.Canvas.TextHeight(Text);
  //Set the apps title to bold
  lstApps.Canvas.Font.Bold := True;
  //Write the list item text
  lstApps.Canvas.TextOut(ARect.left + lstIcons.Width + 8, ARect.Top + 4,
    lstApps.Items.Strings[index]);
  //Setup the font props for the description.
  lstApps.Canvas.Font.Bold := False;
  lstApps.Canvas.Font.Italic := True;
  lstApps.Canvas.Font.Color := clGray;
  //Make the description text white if item is selected
  if odSelected in State then
  begin
    lstApps.Canvas.Font.Color := clWhite;
  end;
  //Read app description
  lzAppDest := mnucfg.ReadString(TabPageCaption, 'desc' + IntToStr(Index), '');
  //Write app description text
  lstApps.Canvas.TextOut(ARect.left + lstIcons.Width + 8, ARect.Top + th + 4, lzAppDest);
end;

procedure Tfrmmain.lstAppsMeasureItem(Control: TWinControl; Index: integer;
  var AHeight: integer);
begin
  AHeight := 56;
end;

procedure Tfrmmain.mnuAboutClick(Sender: TObject);
var
  frm: TfrmAbout;
  lzLogoIcon: string;
begin
  frm := TfrmAbout.Create(self);
  //Set aboutbox info
  frm.Caption := ReadAboutInfo('caption');
  frm.lblTitle.Caption := ReadAboutInfo('title');
  frm.lblVer.Caption := ReadAboutInfo('version');
  frm.lblInfo.Caption := ReadAboutInfo('info');
  //Set aboutbox logo
  lzLogoIcon := AppPath + ReadAboutInfo('icon');

  //Check if aboutbox image is here
  if FileExists(lzLogoIcon) then
  begin
    //Load the image into the image control
    frm.imgAbout.Picture.LoadFromFile(lzLogoIcon);
  end;

  frm.ShowModal;
  //Clear up
  FreeAndNil(frm);
end;

procedure Tfrmmain.mnubrowseClick(Sender: TObject);
begin
  OpenDocument(AppPath);
end;

procedure Tfrmmain.mnuExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrmmain.mnuWebClick(Sender: TObject);
begin
  OpenURL(mnuCfg.ReadString('general','web',''));
end;

procedure Tfrmmain.TabPage1Change(Sender: TObject);
begin
  TabPageCaption := 'tab' + IntToStr(TabPage1.TabIndex);
  LoadApps(TabPageCaption);
end;

end.

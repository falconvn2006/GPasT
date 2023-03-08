unit plugin;

interface

uses
  Winapi.Windows,  Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.ComCtrls, SciSupport, Vcl.Forms,
  Vcl.Controls, NppPlugin, Vcl.Dialogs, Vcl.Graphics, StrUtils;

type
  TModalResultArray = array[False..True] of TModalResult;
  TMenuItemCheck = (miHidden,miShown);

  PDarkModeColors = ^TDarkModeColors;
  TDarkModeColors = record
  //public
      background: Longint;
      softerBackground: Longint;
      hotBackground: Longint;
      pureBackground: Longint;
      errorBackground: Longint;
      text: Longint;
      darkerText: Longint;
      disabledText: Longint;
      linkText: Longint;
      edge: Longint;
      hotEdge: Longint;
      disabledEdge: Longint;
  end;

  TDarkModeColorsDelphi = record
  //public
      background: TColor;
      softerBackground: TColor;
      hotBackground: TColor;
      pureBackground: TColor;
      errorBackground: TColor;
      text: TColor;
      darkerText: TColor;
      disabledText: TColor;
      linkText: TColor;
      edge: TColor;
      hotEdge: TColor;
      disabledEdge: TColor;
  end;





  TdsPlugin = class(TNppPlugin)
  private
    FForm: TForm;


    function GetTColorFromWindowsColor(wcolor: Integer): TColor;
  public
    constructor Create;
    procedure DoNppnDarkModeChanged;
    procedure DoNppnToolbarModification; override;
    procedure DoShowHide;
    procedure FuncAbout;
    procedure BeNotified(sn: PSCNotification); override;
    function isUnicode: boolean;
    function IsDarkMode: boolean;
    function GetDarkModeColorsDelphi(nppDarkModeColors: TDarkModeColors): TDarkModeColorsDelphi;
  end;

const
   WM_USER_MESSAGE_FROM_THREAD =  WM_USER + 1;
   cnstMainDlgId = 0;

var
  NPlugin: TdsPlugin;



implementation

uses frmMainUnit;

procedure _FuncDoShowHide; cdecl;
begin
  NPlugin.DoShowHide;
end;


procedure _FuncAbout; cdecl;
begin
  NPlugin.FuncAbout;
end;

{ TdsPlugin }

constructor TdsPlugin.Create;
begin
  inherited;

   PluginName := 'BFRegex';
   AddFuncItem('Show BFRegex', _FuncDoShowHide);
   AddFuncItem('About BFRegex', _FuncAbout);
   Sci_Send(SCI_SETMODEVENTMASK,SC_MOD_INSERTTEXT or SC_MOD_DELETETEXT,0);
end;

procedure TdsPlugin.DoNppnToolbarModification;
var
  tb: TToolbarIcons;
  ico1: TtoolbarIconsWithDarkMode;
  //ico2: TtoolbarIconsWithDarkMode;
begin
  tb.ToolbarIcon := 0;

  tb.ToolbarBmp := LoadImage(Hinstance, 'BFREGEX', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  tb.ToolbarIcon:= LoadImage(Hinstance, 'BFREGEXDARK', IMAGE_ICON, 0, 0, (LR_DEFAULTSIZE));

  ico1.hToolbarBmp:=tb.ToolbarBmp;
  ico1.hToolbarIcon:=tb.ToolbarIcon;
  ico1.hToolbarIconDarkMode:=tb.ToolbarIcon;



{  tb.ToolbarBmp := LoadImage(Hinstance, 'BFABOUT', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  tb.ToolbarIcon:= LoadImage(Hinstance, 'BFABOUTDARK', IMAGE_ICON, 0, 0, (LR_DEFAULTSIZE));

  ico2.hToolbarBmp:=tb.ToolbarBmp;
  ico2.hToolbarIcon:=tb.ToolbarIcon;
  ico2.hToolbarIconDarkMode:=tb.ToolbarIcon; }


  tb.ToolbarBmp := LoadImage(Hinstance, 'BFREGEX', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  Npp_Send(NPPM_ADDTOOLBARICON_FORDARKMODE, WPARAM(self.CmdIdFromDlgId(cnstMainDlgId)), LPARAM(@ico1));

{  tb.ToolbarBmp := LoadImage(Hinstance, 'BFABOUT', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  Npp_Send(NPPM_ADDTOOLBARICON_FORDARKMODE, WPARAM(self.CmdIdFromDlgId(cnstMainDlgId+1)), LPARAM(@ico2));    }
end;

function TdsPlugin.isUnicode: boolean;
begin
  result:=true;
end;

procedure TdsPlugin.FuncAbout;
begin
  if not Assigned(FForm) then FForm := TfrmMain.Create(self, cnstMainDlgId);
  (FForm as TfrmMain).btnAboutClick(nil);
end;

procedure TdsPlugin.DoShowHide;
begin
  if not Assigned(FForm) then FForm := TfrmMain.Create(self, cnstMainDlgId);
  (FForm as TfrmMain).Carousel;
end;

function TdsPlugin.GetDarkModeColorsDelphi(nppDarkModeColors: TDarkModeColors): TDarkModeColorsDelphi;
var
   delphiColors: TDarkModeColorsDelphi;
begin

      delphiColors.background:=        GetTColorFromWindowsColor(nppDarkModeColors.background);
      delphiColors.softerBackground:=  GetTColorFromWindowsColor(nppDarkModeColors.softerBackground);
      delphiColors.hotBackground:=     GetTColorFromWindowsColor(nppDarkModeColors.hotBackground);
      delphiColors.pureBackground:=    GetTColorFromWindowsColor(nppDarkModeColors.pureBackground);
      delphiColors.errorBackground:=   GetTColorFromWindowsColor(nppDarkModeColors.errorBackground);
      delphiColors.text:=              GetTColorFromWindowsColor(nppDarkModeColors.text);
      delphiColors.darkerText:=        GetTColorFromWindowsColor(nppDarkModeColors.darkerText);
      delphiColors.disabledText:=      GetTColorFromWindowsColor(nppDarkModeColors.disabledText);
      delphiColors.linkText:=          GetTColorFromWindowsColor(nppDarkModeColors.linkText);
      delphiColors.edge:=              GetTColorFromWindowsColor(nppDarkModeColors.edge);
      delphiColors.hotEdge:=           GetTColorFromWindowsColor(nppDarkModeColors.hotEdge);
      delphiColors.disabledEdge:=      GetTColorFromWindowsColor(nppDarkModeColors.disabledEdge);

      result:=delphiColors;

end;

function TdsPlugin.GetTColorFromWindowsColor(wcolor: Integer): TColor;
var
   s: string;
begin
   s:=system.sysutils.inttohex(wcolor, 6);

   if(Length(s)>6) then begin
      s := System.StrUtils.RightStr(s, 6);
   end;


   if(Length(s)=6) then begin
      result:= RGB(StrToIntDef('$' + s.Substring(4, 2), 0),
                   StrToIntDef('$' + s.Substring(2, 2), 0),
                   StrToIntDef('$' + s.Substring(0, 2), 0));
   end
   else begin
      result:=clBlack;
   end;


end;

function  TdsPlugin.IsDarkMode: boolean;
var
   ui: NativeInt;
begin
   ui:=Npp_Send(NPPM_ISDARKMODEENABLED,0,0);
   result:= ui = 1;
end;


procedure TdsPlugin.DoNppnDarkModeChanged;
var
   dmc: TDarkModeColors;
   delphiColors: TDarkModeColorsDelphi;
   msg_param: PDarkModeColors;
  // dt: TDateTime;
   res: NativeInt;
begin

  if(IsDarkMode) then begin
     //ShowMessage('darkmode enabled');
     msg_param:=@dmc;
     res:=Npp_Send(NPPM_GETDARKMODECOLORS, SizeOf(TDarkModeColors), LPARAM(msg_param));
     if(res = 1) then begin
         delphiColors:=self.GetDarkModeColorsDelphi(dmc);
     end;

     if not Assigned(FForm) then
      FForm := TfrmMain.Create(self, cnstMainDlgId);

     (FForm as TfrmMain).ApplyDarkColorScheme(true, delphiColors);
  end
  else begin
      (FForm as TfrmMain).ApplyDarkColorScheme(false, delphiColors);
  end;

end;







procedure TdsPlugin.BeNotified(sn: PSCNotification);
begin
   inherited;
  if (HWND(sn^.nmhdr.hwndFrom) = self.NppData.NppHandle) and (sn^.nmhdr.code = NPPN_DARKMODECHANGED) then begin
    DoNppnDarkModeChanged;
  end;

end;







end.

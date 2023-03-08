unit Form_Configuration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, VCLTee.TeCanvas, uTypes,
  Entropy.TPanel.Paint, Vcl.ColorGrd, Vcl.Menus;

type
  TConfigurationForm = class(TForm)
    Pan_Header: TPanel;
    Img_AppIcon: TImage;
    Lab_AppCaption: TLabel;
    Btn_Close: TImage;
    Tabs_Configuration: TPageControl;
    Tab_Colors: TTabSheet;
    GPnl_Parametres: TGridPanel;
    Lab_Trace: TLabel;
    Lab_Info: TLabel;
    Lab_Notice: TLabel;
    Lab_Error: TLabel;
    Lab_DLL: TLabel;
    Lab_Emergency: TLabel;
    Lab_Actions: TLabel;
    Lab_Debug: TLabel;
    Pan_Buttons: TPanel;
    Btn_Update: TButton;
    Lab_Warning: TLabel;
    Lab_Critical: TLabel;
    Lab_DoubleDLL: TLabel;
    Pan_Debug: TPanel;
    Pan_Trace: TPanel;
    Pan_Info: TPanel;
    Pan_Notice: TPanel;
    Pan_Warning: TPanel;
    Pan_Error: TPanel;
    Pan_Critical: TPanel;
    Pan_Emergency: TPanel;
    Pan_DLL: TPanel;
    Pan_DoubleDLL: TPanel;
    PopupMenu1: TPopupMenu;
    Copier1: TMenuItem;
    Coller1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_UpdateClick(Sender: TObject);
    { events }
    procedure PanelOnClick(Sender: TObject);
    procedure OnColorChange(Sender: TObject);
  private
    { Déclarations privées }
    function PromptColor(const DefaultColor: TColor;
      out PickedColor: TColor): Boolean;
  public
    class function Prompt: Boolean; overload;
    class function Prompt(const Debug, Trace, Info, Notice, Warning, Error,
      Critical, Emergency, DLL, DoubleDLL: TColor): Boolean; overload;
  end;

var
  ConfigurationForm: TConfigurationForm;

function EditColors(const Debug, Trace, Info, Notice, Warning, Error,
  Critical, Emergency, DLL, DoubleDLL: TColor): Boolean;

implementation

{$R *.dfm}

uses
  uConfiguration, System.UITypes, rest.json;

function EditColors(const Debug, Trace, Info, Notice, Warning, Error,
  Critical, Emergency, DLL, DoubleDLL: TColor): Boolean;
var
  TileColor: TTileColor;
begin
  try
    if Assigned( TConfiguration.Colors ) then
      TConfiguration.Colors.Free;
    TConfiguration.Colors := TTileColors.Create( Debug, Trace, Info, Notice, Warning, Error,
      Critical, Emergency, DLL, DoubleDLL );
    Exit( True );
  except
    Exit( False );
  end;
end;

{ TConfigurationForm }

class function TConfigurationForm.Prompt: Boolean;
begin
  if TConfiguration.Load then
    Exit(
      Prompt(
        TileColorToColor( TTileColor.Debug ),
        TileColorToColor( TTileColor.Trace ),
        TileColorToColor( TTileColor.Info ),
        TileColorToColor( TTileColor.Notice ),
        TileColorToColor( TTileColor.Warning ),
        TileColorToColor( TTileColor.Error ),
        TileColorToColor( TTileColor.Critical ),
        TileColorToColor( TTileColor.Emergency ),
        TileColorToColor( TTileColor.DLL ),
        TileColorToColor( TTileColor.DoubleDLL )
      )
    );
end;

procedure TConfigurationForm.Btn_UpdateClick(Sender: TObject);
begin
  if EditColors( Pan_Debug.Color, Pan_Trace.Color, Pan_Info.Color,
    Pan_Notice.Color, Pan_Warning.Color, Pan_Error.Color, Pan_Critical.Color,
    Pan_Emergency.Color, Pan_DLL.Color, Pan_DoubleDLL.Color ) then
    ModalResult := mrOk
  else
    ShowMessage( 'error' );
end;

procedure TConfigurationForm.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TConfigurationForm.FormCreate(Sender: TObject);
var
  i: Integer;
  TileColor: TTileColor;
begin
  if Assigned( Vcl.Forms.Application.MainForm ) then
    case Vcl.Forms.Application.MainForm.WindowState of
      TWindowState.wsNormal: BoundsRect := Vcl.Forms.Application.MainForm.BoundsRect;
      TWindowState.wsMinimized, Twindowstate.wsMaximized: WindowState := Vcl.Forms.Application.MainForm.WindowState;
    end;           
end;

procedure TConfigurationForm.OnColorChange(Sender: TObject);
begin
  Btn_Update.Enabled := ( 
    ( not Assigned( TConfiguration.Colors ) ) or
    ( Pan_Debug.Color <> TConfiguration.Colors.FDebug ) or
    ( Pan_Trace.Color <> TConfiguration.Colors.FTrace ) or
    ( Pan_Info.Color <> TConfiguration.Colors.FInfo ) or
    ( Pan_Notice.Color <> TConfiguration.Colors.FNotice ) or
    ( Pan_Warning.Color <> TConfiguration.Colors.FWarning ) or
    ( Pan_Error.Color <> TConfiguration.Colors.FError ) or
    ( Pan_Critical.Color <> TConfiguration.Colors.FCritical ) or
    ( Pan_Emergency.Color <> TConfiguration.Colors.FEmergency ) or
    ( Pan_DLL.Color <> TConfiguration.Colors.FDLL ) or
    ( Pan_DoubleDLL.Color <> TConfiguration.Colors.FDoubleDLL )    
  );
end;

procedure TConfigurationForm.PanelOnClick(Sender: TObject);
var
  Color: TColor;
begin
  if PromptColor( TPanel( Sender ).Color, Color ) then begin
    TPanel( Sender ).Color := Color;
    OnColorChange( nil );      
  end;
end;

class function TConfigurationForm.Prompt(const Debug, Trace, Info, Notice,
  Warning, Error, Critical, Emergency, DLL, DoubleDLL: TColor): Boolean;
begin
  ConfigurationForm := TConfigurationForm.Create( nil );
  try
    {$REGION 'GUI update'}    
    if Assigned( TConfiguration.Colors ) then
      ConfigurationForm.Btn_Update.Caption := 'Mettre à jour'
    else
      ConfigurationForm.Btn_Update.Caption := 'Enregistrer';
    
    ConfigurationForm.Pan_Debug.Color := Debug;
    ConfigurationForm.Pan_Trace.Color := Trace;
    ConfigurationForm.Pan_Info.Color := Info;
    ConfigurationForm.Pan_Notice.Color := Notice;
    ConfigurationForm.Pan_Warning.Color := Warning;
    ConfigurationForm.Pan_Error.Color := Error;
    ConfigurationForm.Pan_Critical.Color := Critical;
    ConfigurationForm.Pan_Emergency.Color := Emergency;
    ConfigurationForm.Pan_DLL.Color := DLL;
    ConfigurationForm.Pan_DoubleDLL.Color := DoubleDLL;          
    ConfigurationForm.OnColorChange( nil );
    {$ENDREGION 'GUI update'}
    ConfigurationForm.ShowModal;
    if ConfigurationForm.ModalResult <> mrOk then
      Exit( False );
    { success }
    Exit( True );
  finally
    ConfigurationForm.Free;
  end;
end;

function TConfigurationForm.PromptColor(const DefaultColor: TColor;
  out PickedColor: TColor): Boolean;
var
  ColorDialog: TColorDialog;
begin
  ColorDialog := TColorDialog.Create( nil );
  try
    ColorDialog.Color := DefaultColor;
    ColorDialog.Options := [
      TColorDialogOption.cdFullOpen,
      TColorDialogOption.cdAnyColor,
      TColorDialogOption.cdSolidColor
    ];
    Result := ColorDialog.Execute;
    if Result then
      PickedColor := ColorDialog.Color;
  finally
    ColorDialog.Free;
  end;
end;

end.

unit GinCaracteristique;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  RzPanel, RzLabel, rzCommon;

type
  TRzGinCaracteristique = class( TRzCustomPanel )
  private
    FAboutInfo: TRzAboutInfo;
    FPan_Titre: TRzPanel;
    FLab_Titre: TRzLabel;
    FPan_Client: TRzPanel;
    procedure SetPan_Titre(const Value: TRzPanel);
    procedure SetLab_Titre(const Value: TRzLabel);
    procedure SetPan_Client(const Value: TRzPanel);
  public
    constructor Create( AOwner: TComponent ); override;
    property Canvas;
    property DockManager;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Pan_Titre: TRzPanel read FPan_Titre write SetPan_Titre;
    property Lab_Titre: TRzLabel read FLab_Titre write SetLab_Titre;
    property Pan_Client: TRzPanel read FPan_Client write SetPan_Client;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property AlignmentVertical;
    property Anchors;
    property AutoSize;
    property BevelWidth;
    property BiDiMode;
    property BorderInner;
    property BorderOuter;
    property BorderSides;
    property BorderColor;
    property BorderHighlight;
    property BorderShadow;
    property BorderWidth;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    {$IFDEF VCL120_OR_HIGHER}
    property DoubleBuffered;
    {$ENDIF}
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment;
    property Font;
    property FrameControllerNotifications;
    property FrameController;
    property FullRepaint;
    property GradientColorStyle;
    property GradientColorStart;
    property GradientColorStop;
    property GradientDirection;
    property GridColor;
    property GridStyle;
    property GridXSize;
    property GridYSize;
    property Locked;
    property PaintClientArea;
    property TextMargin;
    property TextMarginVertical;
    {$IFDEF VCL100_OR_HIGHER}
    property Padding;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    {$IFDEF VCL120_OR_HIGHER}
    property ParentDoubleBuffered;
    {$ENDIF}
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowDockClientCaptions;
    property ShowGrid;
    property ShowHint;
    property TabOrder;
    property TabStop;
    {$IFDEF VCL140_OR_HIGHER}
    property Touch;
    {$ENDIF}
    property Transparent;
    property UseDockManager default True;
    property Visible;
    property VisualStyle;
    property WordWrap;

    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF VCL140_OR_HIGHER}
    property OnGesture;
    {$ENDIF}
    property OnGetSiteInfo;
    {$IFDEF VCL90_OR_HIGHER}
    property OnMouseActivate;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;


implementation

{ TRzGinCaracteristique }

constructor TRzGinCaracteristique.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderOuter := fsFlatRounded;
  Font.Color := rgb(51,51,51);
  Font.Name := 'Arial';
  Font.Size := 10;
  Font.Style := [];
  GradientColorStart := $00F8F6F5;
  GradientColorStop := $00DED6D2;
  GradientColorStyle := gcsCustom;
  VisualStyle := vsGradient;
  Height := 200;

  FPan_Titre := TRzPanel.Create(Self);
  FPan_Titre.Parent := Self;
  FPan_Titre.SetBounds(1,1,Width-2,37);
  FPan_Titre.Align := alTop;
  FPan_Titre.BorderColor := $001A09BE;
  FPan_Titre.BorderOuter := fsNone;
  FPan_Titre.BorderSides := [sdBottom];
  FPan_Titre.BorderWidth := 3;
  FPan_Titre.Transparent := true;

  FLab_Titre := TRzLabel.Create(Self);
  FLab_Titre.Parent := FPan_Titre;
  FLab_Titre.Left := 9;
  FLab_Titre.Top := 8;
  FLab_Titre.Font.Color := $001A09BE;
  FLab_Titre.Font.Name := 'Arial';
  FLab_Titre.Font.Size := 12;
  FLab_Titre.Font.Style := [fsBold];

  FPan_Client := TRzPanel.Create(Self);
  FPan_Client.Parent := Self;
  FPan_Client.SetBounds(1,FPan_Titre.Top+FPan_Titre.Height,Width-2,Height-FPan_Titre.Top+FPan_Titre.Height-1);
  FPan_Client.Align := alClient;
  FPan_Client.BorderOuter := fsNone;
  FPan_Client.Transparent := true;
  FPan_Client.Padding.Left := 19;
  FPan_Client.Padding.Right := 19;
  FPan_Client.Padding.Top := 10;
  FPan_Client.Padding.Bottom := 20;

end;

procedure TRzGinCaracteristique.SetLab_Titre(const Value: TRzLabel);
begin
  FLab_Titre := Value;
end;

procedure TRzGinCaracteristique.SetPan_Client(const Value: TRzPanel);
begin
  FPan_Client := Value;
end;

procedure TRzGinCaracteristique.SetPan_Titre(const Value: TRzPanel);
begin
  FPan_Titre := Value;
end;

end.

unit uEventPanel;

interface

uses  Windows, Classes, SysUtils, Controls, StdCtrls, ExtCtrls, Graphics,
      uLog, menus ;


type
  TEventPanel = class(TCustomPanel)
  private
    lbTitle  : TLabel ;
    lbDetail : TLabel ;
    imgIcon  : TImage ;

    FTitle: string;
    FLevel: TLogLevel;
    FDetail: string;
    FPopMenu : TPopupMenu;

    procedure SetTitle(const Value: string);
    procedure SetLevel(const Value: TLogLevel);
    procedure SetIcon(const Value: TBitMap);
    function getIcon: TIcon;
    procedure setDetail(const Value: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy ; override ;
    procedure SetPopMenu(const Value: TPopupMenu);
  published
    property Title : string  read FTitle write SetTitle ;
    property Detail : string read FDetail write setDetail ;
    property Icon  : TIcon   read getIcon ;
    property Level : TLogLevel  read FLevel write SetLevel;
    property PopMenu : TPopupMenu read FPopMenu write SetPopMenu;
    property Align ;
  end;

implementation
//==============================================================================
{ TEventPanel }
//==============================================================================
constructor TEventPanel.Create(AOwner: TComponent);
begin
  inherited;

  Width  := 100 ;
  Height := 100 ;
  Padding.Left    := 5 ;
  Padding.Right   := 5 ;
  Padding.Top     := 5 ;
  Padding.Bottom  := 5 ;

  PopupMenu := nil;

  Margins.Right     := 5 ;
  AlignWithMargins  := true ;

  BevelOuter := bvNone ;
  ParentColor := false ;
  ParentBackground := false ;

  lbTitle := TLabel.Create(Self) ;
  lbTitle.Align := alBottom ;
  lbTitle.Color := clWhite ;
  lbTitle.Font.Name := 'Arial' ;
  lbTitle.Font.Size := 8 ;
  lbTitle.Font.Style := [fsBold] ;
  lbTitle.Alignment  := taCenter ;
  lbTitle.Font.Color := clWhite ;
  lbTitle.ParentColor := true ;
  lbTitle.Transparent := true ;
  lbTitle.Parent := Self ;

  lbDetail := TLabel.Create(Self);
  lbDetail.Align := alBottom ;
  lbDetail.Color := clWhite ;
  lbDetail.Font.Name := 'Arial' ;
  lbDetail.Font.Size := 7 ;
  lbDetail.Font.Style := [] ;
  lbDetail.Alignment  := taCenter ;
  lbDetail.Font.Color := clWhite ;
  lbDetail.ParentColor := true ;
  lbDetail.Transparent := true ;
  lbDetail.Parent := Self ;

  imgIcon := TImage.Create(Self);
  imgIcon.Top := 15 ;
  imgIcon.Left := 34 ;
  imgIcon.Width := 32 ;
  imgIcon.Height := 32 ;
  imgIcon.Parent := self ;
  imgIcon.Transparent := true ;

  setTitle('') ;
  setDetail('') ;
  setLevel(logNone) ;
end;
//------------------------------------------------------------------------------
destructor TEventPanel.Destroy;
begin
  lbTitle.Free ;

  inherited;
end;
function TEventPanel.getIcon: TIcon;
begin
  Result := imgIcon.Picture.Icon ;
end;

procedure TEventPanel.setDetail(const Value: string);
begin
  FDetail := Value;

  lbDetail.Visible := (FDetail <> '') ;
  lbDetail.Caption := FDetail ;
  lbDetail.Top := Height - lbDetail.Height ;
end;

procedure TEventPanel.SetIcon(const Value: TBitMap);
begin
end;

procedure TEventPanel.SetLevel(const Value: TLogLevel);
begin
  FLevel := Value ;
  Color := LogLevelColor[Ord(FLevel)] ;
end;

procedure TEventPanel.SetPopMenu(const Value: TPopupMenu);
begin
  Self.PopupMenu := Value;
end;

procedure TEventPanel.SetTitle(const Value: string);
begin
  FTitle := Value;
  lbTitle.Caption := FTitle ;
end;

//==============================================================================
end.

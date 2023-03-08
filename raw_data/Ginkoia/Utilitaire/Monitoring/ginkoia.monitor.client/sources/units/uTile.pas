unit uTile;

interface

uses
  Vcl.ExtCtrls, { TPanel }
  Vcl.Controls, { TWinControl }
  Vcl.StdCtrls, { TLabel }
  Vcl.ComCtrls, { TProgressBar, TListView }
  System.Classes, { TAlign }
  System.UITypes, { TColor }
  uTypes,
  uTileCustom,
  Entropy.TPanel.Paint, System.SysUtils;

type
  TTile = class( TTileCustom )
  private const
//    cDefaultIntervalMax = 10;
    cDefaultTileWidth = 200;
    cDefaultTileHeight = 200;
  private
    { members }
    FPanel: TPanel;
    FTag: TLabel;
    FValues: TLabel;
    FProgressBar: TProgressBar;
    { events }
    FOnClick: TTileNotify;
    FOnDetailChange: TTileEvent;
    procedure SetColor(const Value: TTileColor);
  protected
    procedure DoChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoColorChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoMaxChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoMinChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoTagChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoTypeChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoValueChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoValuesChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoDetailChange(const Tile: TTileCustom; const Response: TResponse); override;
    procedure DoClick(Sender: TObject);
  public
    { constructor / destructor }
    constructor Create(const AOwner: TWinControl; const Tag: TTag;
      const &Type: TTileType; const Uid: TUid;
      const Interval: TInterval); reintroduce;
    destructor Destroy; override;
    { methods }
    procedure Synchronize; override;
    procedure Repaint;
    { events }
    property OnClick: TTileNotify read FOnClick write FOnClick;
    property OnDetailChange: TTileEvent read FOnDetailChange write FOnDetailChange;
  end;

implementation

{ TTile }

constructor TTile.Create(const AOwner: TWinControl; const Tag: TTag;
  const &Type: TTileType; const Uid: TUid; const Interval: TInterval);
begin
  inherited Create( Tag, &Type, Uid, Interval );
  FPanel := TPanel.Create( AOwner );
  FPanel.Parent := AOwner;
  FPanel.TabStop := True;
  FPanel.Font.Name := 'Segoe UI Light';
  FPanel.Width := cDefaultTileWidth;
  FPanel.Height := cDefaultTileHeight;
  FPanel.ParentBackground := False;
  FPanel.Color := TileColorToColor( TTileColor.None );

  FTag:= TLabel.Create( FPanel );
  FTag.Parent := FPanel;
  FTag.Align := TAlign.alTop;
  FTag.Font.Size := 15;
  FTag.AutoSize := True;

  FValues := TLabel.Create( FPanel );
  FValues.Parent := FPanel;
  FValues.Align := TAlign.alClient;
  FValues.Alignment := TAlignment.taCenter;
  FValues.Layout := TTextLayout.tlCenter;
  FValues.Font.Size := 105;

  FProgressBar := TProgressBar.Create( FPanel );
  FProgressBar.Parent := FPanel;
  FProgressBar.Align := TAlign.alBottom;

  FPanel.OnClick := DoClick;
  FTag.OnClick := DoClick;
  FValues.OnClick := DoClick;
end;

destructor TTile.Destroy;
begin
  FProgressBar.Free;
  FValues.Free;
  FTag.Free;
  FPanel.Free;
  inherited;
end;

procedure TTile.DoChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  // Silence is golden
end;

procedure TTile.DoClick(Sender: TObject);
begin
  if Assigned( FOnClick ) then
    FOnClick( Self );
end;

procedure TTile.DoColorChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FPanel ) then
    FPanel.Color := TileColorToColor( TResponseColored( Response ).Color );
end;

procedure TTile.DoDetailChange(const Tile: TTileCustom;
  const Response: TResponse);
begin
  inherited;
  //
end;

procedure TTile.DoMaxChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FProgressBar ) then
    FProgressBar.Max := TResponseProgressive( Response ).FMax;
end;

procedure TTile.DoMinChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FProgressBar ) then
    FProgressBar.Min := TResponseProgressive( Response ).FMin;
end;

procedure TTile.DoTagChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FTag ) then
    FTag.Caption := TResponseColored( Response ).FTag;
end;

procedure TTile.DoTypeChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FProgressBar ) then
    FProgressBar.Visible := Response.InheritsFrom( TResponseProgressive ) and not (
      ( TResponseProgressive( Response ).FMin = TResponseProgressive( Response ).FMax ) and
      ( TResponseProgressive( Response ).FMin = 0 )
    );
                            ;
  if Assigned( FValues ) then
    FValues.Visible := Response.InheritsFrom( TResponseProgressive )
                    or Response.InheritsFrom( TResponseValued );
  // TODO : FValues (timer)
end;

procedure TTile.DoValueChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FProgressBar ) then
    FProgressBar.Position := TResponseProgressive( Response ).FValue;
  if Assigned( FValues ) then
    FValues.Caption := IntToStr( TResponseProgressive( Response ).FValue );
end;

procedure TTile.DoValuesChange(const Tile: TTileCustom; const Response: TResponse);
begin
  inherited;
  if Assigned( FValues ) and Response.InheritsFrom( TResponseValued ) then
    FValues.Caption := TResponseValued( Response ).FValues[ 0 ];
  if Response.InheritsFrom( TResponseDetail ) then begin
    if Assigned( FOnDetailChange ) then
      FOnDetailChange( Tile, Response );
  end;
end;

procedure TTile.Repaint;
begin
//  DoChange();
  DoColorChange( Self, Response );
  DoMaxChange( Self, Response );
  DoMinChange( Self, Response );
  DoTagChange( Self, Response );
  DoTypeChange( Self, Response );
  DoValueChange( Self, Response );
  DoValuesChange( Self, Response );
//  DoDetailChange( Self, Response );
end;

procedure TTile.SetColor(const Value: TTileColor);
begin
  if Assigned( FPanel ) then
    FPanel.Color := TileColorToColor( Value );
end;

procedure TTile.Synchronize;
begin
  TThread.Synchronize(
    nil,
    procedure
    begin
      FTag.Caption := Format( '%s (%ds)', [ Self.Tag, Self.Interval{, Self.IntervalMax} ] )
    end
  );
  inherited;
end;

end.

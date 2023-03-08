unit uTiles;

interface

uses
  Vcl.ExtCtrls, { TFlowPanel }
  Vcl.Controls, { TWinControl }
  Vcl.ComCtrls, { TListView }
  uTilesCustom, uTile, uTileCustom;

type
  TTiles = class( TFlowPanel )
  private
    FTiles: TTilesCustom;
    FOnClick: TTileNotify;
    FOnDetailChange: TTileEvent;
  protected
    procedure DoClick(const Tile: TTileCustom);
  public
    { constructor / destructor }
    constructor Create(const AOwner: TWinControl); reintroduce;
    destructor Destroy; override;
    { methods }
    procedure Add(Value: TTile);
    procedure Remove(Value: TTile);
    { events }
    property OnClick: TTileNotify read FOnClick write FOnClick;
    property OnDetailChange: TTileEvent read FOnDetailChange write FOnDetailChange;
    { properties }
    property Tiles: TTilesCustom read FTiles write FTiles;
  end;

implementation

{ TTiles }

procedure TTiles.Add(Value: TTile);
begin
  if Assigned( Value ) then begin
    Value.OnDetailChange := FOnDetailChange;
    Value.OnClick := DoClick;
    FTiles.Add( Value );
  end;
end;

constructor TTiles.Create(const AOwner: TWinControl);
begin
  FTiles := TTilesCustom.Create;
  inherited Create( AOwner );
  Parent := AOwner;
  Align := TAlign.alTop;
  AutoWrap := True;
  AutoSize := True;
  BevelOuter := TBevelCut.bvNone;
end;

destructor TTiles.Destroy;
begin
  FTiles.Free;
  inherited;
end;

procedure TTiles.DoClick(const Tile: TTileCustom);
begin
  if Assigned( FOnClick ) then
    FOnClick( Tile );
end;

procedure TTiles.Remove(Value: TTile);
begin
  if Assigned( Value ) then
    FTiles.Remove( Value );
end;

end.

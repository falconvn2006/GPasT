unit uEntropy.TForm.Constrained;

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Forms,
  FMX.StdCtrls,
  FMX.Types;

type
  TFormConstrained = class(FMX.Forms.TForm)
  private type
    TSizeGridConstrained = class(FMX.StdCtrls.TSizeGrip)
    private const
      cSize: Single             = 22;
      cSizeGridVisible: Boolean = True;
    public
      constructor Create(AOwner: TComponent); override;
    end;
  private
    FSizeGrid                                   : TSizeGrip;
    FMinWidth, FMaxWidth, FMinHeight, FMaxHeight: Single;
  protected
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property MinWidth: Single
      read   FMinWidth
      write  FMinWidth;
    property MaxWidth: Single
      read   FMaxWidth
      write  FMaxWidth;
    property MinHeight: Single
      read   FMinHeight
      write  FMinHeight;
    property MaxHeight: Single
      read   FMaxHeight
      write  FMaxHeight;
    property SizeGrid: TSizeGrip
      read   FSizeGrid
      write  FSizeGrid;
  end;

  TForm = TFormConstrained;

implementation

uses
  System.Math;

{ TFormConstrained }

constructor TFormConstrained.Create(AOwner: TComponent);
begin
  inherited;
  FMinWidth   := 0;
  FMinHeight  := 0;
  FMaxWidth   := Screen.Size.cx;
  FMaxHeight  := Screen.Size.cy;
  BorderStyle := TFmxFormBorderStyle.None;
  FSizeGrid   := TSizeGridConstrained.Create(Self);
end;

procedure TFormConstrained.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  StartWindowDrag;
end;

procedure TFormConstrained.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  Width, Height: Single;
begin
  Width  := AWidth;
  Height := AHeight;

  if FMinWidth > 0 then
    Width := Max(FMinWidth, Width);
  if FMaxWidth > 0 then
    Width := Min(FMaxWidth, Width);
  if FMinHeight > 0 then
    Height := Max(FMinHeight, Height);
  if FMaxHeight > 0 then
    Height := Min(FMaxHeight, Height);

  inherited SetBounds(ALeft, ATop, Round(Width), Round(Height));
end;

{ TFormConstrained.TSizeGridConstrained }

constructor TFormConstrained.TSizeGridConstrained.Create(AOwner: TComponent);
begin
  inherited;
  if not AOwner.InheritsFrom(TForm) then
    exit;
  Parent     := TForm(AOwner);
  Width      := cSize;
  Height     := cSize;
  Position.X := TForm(AOwner).ClientWidth - cSize;
  Position.Y := TForm(AOwner).ClientHeight - cSize;
  Anchors    := [TAnchorKind.akRight, TAnchorKind.akBottom];
  Visible    := cSizeGridVisible;
end;

end.

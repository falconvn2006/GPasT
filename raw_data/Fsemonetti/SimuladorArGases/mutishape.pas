unit Mutishape;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs;


type
  TPix = Array of TPoint;
  TShapeEx = class(TGraphicControl)
  private
    { Private declarations }
  FAmount: Integer; // amount of contour points of an shape
  FPix: TPix; // points of contour of an shape
  FBodyColor: TColor; // colour of filling or shading
  FContourColor: TColor;  // colour of contour
  FBodyStyle: TBrushStyle; // style of filling of shape body
  FContourWidth: Integer; // thickness of a contour line
  FContourStyle: TPenStyle; // contour line style
  procedure SetAmount(AValue: Integer);
  procedure SetPix(AValue: TPix);
  procedure SetBodyColor(AValue: TColor);
  procedure SetContourColor(AValue: TColor);
  procedure SetBodyStyle(AValue: TBrushStyle);
  procedure SetContourWidth(AValue: Integer);
  procedure SetContourStyle(AValue: TPenStyle);
  protected
    { Protected declarations }
  public
    { Public declarations }
  constructor Create(AOwner:TComponent); override;
  procedure Paint; override; // let's draw
  published
    { Published declarations }
  property OnMouseDown; //We publish in the inspector
  property OnClick;     //necessary events
  property PopUpMenu;   // from an ancestor
  property Left;
  property Top;
  property Height;
  property Width;

  // we add ours :
  property Amount: Integer
  read FAmount
  write SetAmount;

  property Pix: TPix
  read FPix
  write SetPix;

  property BodyColor: TColor
  read FBodyColor
  write SetBodyColor;

  property ContourColor: TColor
  read FContourColor
  write SetContourColor;

  property BodyStyle: TBrushStyle
  read FBodyStyle
  write SetBodyStyle;

  property ContourWidth: Integer
  read FContourWidth
  write SetContourWidth;

  property ContourStyle: TPenStyle
  read FContourStyle
  write SetContourStyle;

end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio',[TShapeEx]);
end;

Constructor TShapeEx.Create(AOwner:TComponent);
begin
Inherited Create(AOwner);
///////////////////////////
Width:=50;
Height:=50;
FAmount:=4;
setLength(FPix,FAmount);
FPix[0].X:=0;
FPix[0].Y:=0;
FPix[1].X:=Width;
FPix[1].Y:=0;
FPix[2].X:=Width;
FPix[2].Y:=Height;
FPix[3].X:=0;
FPix[3].Y:=Height;
FBodyColor:=clBlue; Canvas.Brush.Color:=FBodyColor;
FContourColor:=clBlack; Canvas.Pen.Color:=FContourColor;
FBodyStyle:=bsSolid; Canvas.Brush.Style:=FBodyStyle;
FContourWidth:=1; Canvas.Pen.Width:=FContourWidth;
FContourStyle:=psSolid; Canvas.Pen.Style:=FContourStyle;
////////////////////////////
repaint;
end;

procedure TShapeEx.SetAmount(AValue: Integer);
begin
SetLength(FPix,Avalue);
end;

procedure TShapeEx.SetPix(AValue: TPix);
begin
FPix:=AValue;
repaint;
end;

procedure TShapeEx.SetBodyColor(AValue: TColor);
begin
FBodyColor:=AValue;
canvas.Brush.Color:=FBodyColor;
repaint;
end;

procedure TShapeEx.SetContourColor(AValue: TColor);
begin
FContourColor:=AValue;
Canvas.Pen.Color:=FContourColor;
repaint;
end;

procedure TShapeEx.SetBodyStyle(AValue: TBrushStyle);
begin
FBodyStyle:=AValue;
Canvas.Brush.Style:=FBodyStyle;
repaint;
end;

procedure TShapeEx.SetContourWidth(AValue: Integer);
begin
FContourWidth:=AValue;
Canvas.Pen.Width:=FContourWidth;
repaint;
end;

procedure TShapeEx.SetContourStyle(AValue: TPenStyle);
begin
FContourStyle:=AValue;
Canvas.Pen.Style:=FContourStyle;
repaint;
end;

procedure TShapeEx.Paint;
begin
Canvas.Polygon(FPix);
end;

end.


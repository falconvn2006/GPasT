unit ShapeF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

    Modelo = (Valvula,ValvulaV,TurbinaE,TurbinaD);

   TPix = Array of TPoint;
  { TShapeF }
  TShapeF = class(TShape)
  private
    FTipo: Modelo;
    procedure SetTipo(AValue: Modelo);

  protected
    FColorOfShape: TColor;
     procedure SetColorOfShape(Value: TColor);
  public
  constructor Create(AOwner: TComponent); override;
  procedure paint;override;


   destructor Destroy; override;

  published
   Property ChangeColor: TColor read FColorOfShape write SetColorOfShape;
   Property Tipo : Modelo read FTipo write SetTipo default valvula;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio',[TShapeF]);
end;

{ TShapeF }

constructor TShapeF.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOfShape := clWhite;
end;

procedure TShapeF.paint;
var
  pontos : array[1..4] of tpoint;
  a,b    : integer;
  pt : array[1..5] of tpoint;
begin

  if ftipo=valvula then
  begin
  a:=round(width/2);
  b:=round(height/2);

  pontos[1].x:=1;
  pontos[1].y:=1;
  pontos[2].x:=1;
  pontos[2].y:=height-1;
  pontos[3].x:=a;
  pontos[3].y:=b;
  pontos[4].x:=1;
  pontos[4].y:=1;

  canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pontos);

  pontos[1].x:=width-1;
  pontos[1].y:=1;
  pontos[2].x:=a;
  pontos[2].y:=b;
  pontos[3].x:=width-1;
  pontos[3].y:=height-1;
  pontos[4].x:=width-1;
  pontos[4].y:=1;

 canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pontos);





  canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pontos);
end;



    if ftipo=valvulaV then
  begin
  a:=round(width/2);
  b:=round(height/2);
  pontos[1].x:=1;
  pontos[1].y:=1;
  pontos[2].x:=width-1;
  pontos[2].y:=1;
  pontos[3].x:=a;
  pontos[3].y:=b;
  pontos[4].x:=1;
  pontos[4].y:=1;
  canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pontos);
  pontos[1].x:=1;
  pontos[1].y:=height-1;
  pontos[2].x:=width-1;
  pontos[2].y:=height-1;
  pontos[3].x:=a;
  pontos[3].y:=b;
  pontos[4].x:=1;
  pontos[4].y:=height-1;
  canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pontos);
   canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pontos);
end;


    if ftipo=TurbinaE then
  begin
  a:=round(width*0.4);
  pt[1].x:=1;
  pt[1].y:=1;
  pt[2].x:=width-1;
  pt[2].y:=a;
  pt[3].x:=width-1;;
  pt[3].y:=height-1-a;
  pt[4].x:=1;
  pt[4].y:=height-1;
  pt[5].x:=1;
  pt[5].y:=1;
  canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pt);
end;


   
    if ftipo=TurbinaD then
  begin
  a:=round(width*0.4);
  pt[1].x:=1;
  pt[1].y:=1+a;
  pt[2].x:=width-1;
  pt[2].y:=1;
  pt[3].x:=width-1;;
  pt[3].y:=height-1;
  pt[4].x:=1;
  pt[4].y:=height-a;
  pt[5].x:=1;
  pt[5].y:=1+a;
  canvas.Brush.Color:=ChangeColor;
  canvas.Polygon(pt);
end;








end;

procedure TShapeF.SetTipo(AValue: Modelo);
begin
  if FTipo=AValue then Exit;
  FTipo:=AValue;
end;

procedure TShapeF.SetColorOfShape(Value: TColor);
begin
  if FColorOfShape <> Value then
     begin
      FColorOfShape := Value;
      Self.Brush.Color := FColorOfShape;
     end;
end;




destructor TShapeF.Destroy;
begin
  inherited Destroy;
end;

end.


unit ShapeF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

    Modelo = (Valvula,Tubulacao,Turbina);

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
  pontos : array[1..8] of tpoint;
  a,b    : integer;
begin

  if ftipo=valvula then
  begin
  a:=round(width/3);
  b:=round(height/3);
 // inherited paint;
pontos[1].x:=0;
pontos[1].y:=0;
pontos[2].x:=a;
pontos[2].y:=b;
pontos[3].x:=a+a;
pontos[3].y:=b;
pontos[4].x:=width;
pontos[4].y:=0;
pontos[5].x:=width;
pontos[5].y:=height;
pontos[6].x:=a+a;
pontos[6].y:=2*b;
pontos[7].x:=a;
pontos[7].y:=2*b;
pontos[8].x:=0;
pontos[8].y:=height;
canvas.Brush.Color:=ChangeColor;
canvas.Polygon(pontos);
end;

  if ftipo=Tubulacao then
  begin
  canvas.Rectangle(0,0,round(width/2),round(height/2));
  pen.Color:=brush.Color;
  brush.Style:=bsClear;
  canvas.moveto(0,0);
  canvas.lineto(round(width/2),round(height/2));
  canvas.lineto(round(width/2),height);
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


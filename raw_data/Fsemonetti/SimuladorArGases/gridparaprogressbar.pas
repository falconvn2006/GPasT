unit gridparaprogressbar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
   Tipo = (PercentualE,PercentualD,CorrenteE,CorrenteD,TemperaturaE);


   TPix = Array of TPoint;
  { TShapeG }
  TShapeG = class(TShape)
  private
    FDivisoes: integer;
    FescalaD: Boolean;
     FModelo: tipo;
  FEspaco: integer;
  FMescala: Boolean;
  FNome: string;
  FNomeB: string;
  FPosicao: integer;
  procedure SetModelo(AValue: tipo);
  procedure SetDivisoes(AValue: integer);
  procedure SetescalaD(AValue: Boolean);
  procedure SetEspaco(AValue: integer);
  procedure SetMescala(AValue: Boolean);
  procedure SetNome(AValue: string);
  procedure SetNomeB(AValue: string);
   procedure SetPosicao(AValue: integer);
  protected
    FColorOfShape: TColor;
     procedure SetColorOfShape(Value: TColor);
  public
  constructor Create(AOwner: TComponent); override;
  procedure paint;override;


   destructor Destroy; override;

  published
   Property ChangeColor: TColor read FColorOfShape write SetColorOfShape;
   Property Espaco : integer read FEspaco write SetEspaco default 0;
   Property Mescala : Boolean read FMescala write SetMescala default true;
   property Posicao : integer read FPosicao write SetPosicao default 30;
   property Divisoes : integer read FDivisoes write SetDivisoes default 10;
   property Nome : string read FNome write SetNome;
   property NomeB: string read FNomeB write SetNomeB;
   property escalaD : Boolean read FescalaD write SetescalaD;
   property Modelo : tipo read FModelo write SetModelo;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio',[TShapeG]);
end;

{ TShapeF }

constructor TShapeG.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOfShape := clWhite;
   FDivisoes:=5;
   FMescala:=true;

end;

procedure TShapeG.paint;
Var f,g ,d,v,i: integer;
begin
  Width:=120;
  Height:=225;
  canvas.pen.Color:=clblack;
  canvas.brush.Style:=bsClear;

  // divisões a esquerda

  canvas.moveto(22,203);canvas.lineto(33,203);
  canvas.moveto(22,169);canvas.lineto(33,169);
  canvas.moveto(22,135);canvas.lineto(33,135);
  canvas.moveto(22,100);canvas.lineto(33,100);
  canvas.moveto(22,67);canvas.lineto(33,67);
  canvas.moveto(22,33);canvas.lineto(33,33);



if FMescala=true then
  Begin
    canvas.textout(10,203-7,'0');
    canvas.textout(5,169-7,'20');
    canvas.textout(5,135-7,'40');
    canvas.textout(5,100-7,'60');
    canvas.textout(5,67-7,'80');
    canvas.textout(0,33-10,'100');
  end;

if FescalaD=true then
  Begin
    canvas.textout(85,203-7,'0');
    canvas.textout(85,169-7,'20');
    canvas.textout(85,135-7,'40');
    canvas.textout(85,100-7,'60');
    canvas.textout(85,67-7,'80');
    canvas.textout(85,33-10,'100');
  end;



  canvas.moveto(28,169+17);canvas.lineto(33,169+17);
  canvas.moveto(28,135+17);canvas.lineto(33,135+17);
  canvas.moveto(28,100+17);canvas.lineto(33,100+17);
  canvas.moveto(28,67+17);canvas.lineto(33,67+17);
  canvas.moveto(28,33+17);canvas.lineto(33,33+17);




 //duas linhas que cortam as divisões
  canvas.moveto(33,33);canvas.lineto(33,203);
  canvas.moveto(72,33);canvas.lineto(72,203);


 //divisões a direita



   canvas.moveto(28,203);canvas.lineto(84,203);
  canvas.moveto(73,169);canvas.lineto(84,169);
  canvas.moveto(73,135);canvas.lineto(84,135);
  canvas.moveto(73,100);canvas.lineto(84,100);
  canvas.moveto(73,67);canvas.lineto(84,67);
  canvas.moveto(73,33);canvas.lineto(84,33);








  canvas.moveto(73,169+17);canvas.lineto(78,169+17);
  canvas.moveto(73,135+17);canvas.lineto(78,135+17);
  canvas.moveto(73,100+17);canvas.lineto(78,100+17);
  canvas.moveto(73,67+17);canvas.lineto(78,67+17);
  canvas.moveto(73,33+17);canvas.lineto(78,33+17);

  //barra
  canvas.rectangle(40,33,61,203);




  // texto posiçao
  canvas.rectangle(30,210,70,225);
 canvas.TextOut(42,209,inttostr(FPosicao));

 // primeira e segunda linha de texzto
 canvas.TextOut(38,0,Fnome);

  canvas.TextOut(38,15,FnomeB);

     canvas.brush.Style:=bssolid;
     canvas.brush.Color:=clgray;


    canvas.rectangle(40,203-round((170*Fposicao)/100),61,203);






end;

procedure TShapeG.SetEspaco(AValue: integer);
begin
  if FEspaco=AValue then Exit;
  FEspaco:=AValue;
end;

procedure TShapeG.SetDivisoes(AValue: integer);
begin
  if FDivisoes=AValue then Exit;
  FDivisoes:=AValue;
end;

procedure TShapeG.SetescalaD(AValue: Boolean);
begin
  if FescalaD=AValue then Exit;
  FescalaD:=AValue;
end;

procedure TShapeG.SetMescala(AValue: Boolean);
begin
  if FMescala=AValue then Exit;
  FMescala:=AValue;
end;

procedure TShapeG.SetNome(AValue: string);
begin
  if FNome=AValue then Exit;
  FNome:=AValue;
end;

procedure TShapeG.SetNomeB(AValue: string);
begin
  if FNomeB=AValue then Exit;
  FNomeB:=AValue;
end;







procedure TShapeG.SetPosicao(AValue: integer);
begin
  if FPosicao=AValue then Exit;
  FPosicao:=AValue;
end;

procedure TShapeG.SetColorOfShape(Value: TColor);
begin
  if FColorOfShape <> Value then
     begin
      FColorOfShape := Value;
      Self.Brush.Color := FColorOfShape;
     end;
end;

procedure TShapeG.SetModelo(AValue: tipo);
begin
  if FModelo=AValue then Exit;
  FModelo:=AValue;
end;


destructor TShapeG.Destroy;
begin
  inherited Destroy;
end;

end.


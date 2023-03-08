unit EscalaQualquer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

   TPix = Array of TPoint;
  { TShapeG }

  { TShapeQualquer }

  TShapeQualquer = class(TShape)
  private
    FCorrTemp: boolean;
    FDivisoes: integer;
    FE1: string;
    FE2: string;
    FE3: string;
    FE4: string;
    FE5: string;
    FE6: string;
    FE7: string;
    FescalaD: Boolean;
  FEspaco: integer;
  FMescala: Boolean;
  FNome: string;
  FNomeB: string;
  Fper: boolean;
  FPosicao: integer;
  procedure SetCorrTemp(AValue: boolean);
  procedure SetDivisoes(AValue: integer);
  procedure SetE1(AValue: string);
  procedure SetE2(AValue: string);
  procedure SetE3(AValue: string);
  procedure SetE4(AValue: string);
  procedure SetE5(AValue: string);
  procedure SetE6(AValue: string);
  procedure SetE7(AValue: string);
  procedure SetescalaD(AValue: Boolean);
  procedure SetEspaco(AValue: integer);
  procedure SetMescala(AValue: Boolean);
  procedure SetNome(AValue: string);
  procedure SetNomeB(AValue: string);
  procedure Setper(AValue: boolean);
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
   property CorrTemp : boolean read FCorrTemp write SetCorrTemp;
   property per : boolean read Fper write Setper;
   property E1 : string read FE1 write SetE1;
   property E2  :string read FE2 write SetE2;
   property E3  : string read FE3 write SetE3;
   property E4  : string read FE4 write SetE4;
   property E5  : string read FE5 write SetE5;
   property E6  : string read FE6 write SetE6;
   property E7 : string read FE7 write SetE7;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio',[TShapeQualquer]);
end;

{ TShapeF }

constructor TShapeQualquer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOfShape := clWhite;
   FDivisoes:=5;
   FMescala:=true;

end;

procedure TShapeQualquer .paint;
Var f,g ,d,v,i: integer;
begin
  Width:=120;
  Height:=225;
  canvas.pen.Color:=clblack;
  canvas.brush.Style:=bsClear;

  // divisões a esquerda

  canvas.moveto(20,203);canvas.lineto(33,203);
  canvas.moveto(20,175);canvas.lineto(33,175);
  canvas.moveto(20,147);canvas.lineto(33,147);
  canvas.moveto(20,119);canvas.lineto(33,119);
  canvas.moveto(20,91);canvas.lineto(33,91);
  canvas.moveto(20,63);canvas.lineto(33,63);
  canvas.moveto(20,35);canvas.lineto(33,35);


  canvas.moveto(28,175+14);canvas.lineto(33,175+14);
  canvas.moveto(28,147+14);canvas.lineto(33,147+14);
  canvas.moveto(28,119+14);canvas.lineto(33,119+14);
  canvas.moveto(28,91+14);canvas.lineto(33,91+14);
  canvas.moveto(28,63+14);canvas.lineto(33,63+14);
  canvas.moveto(28,35+14);canvas.lineto(33,35+14);



if FMescala=true then
  Begin
     canvas.textout(6,203-7,FE1);
    canvas.textout(6,175-7,FE2);
    canvas.textout(12,147-7,FE3);
    canvas.textout(12,119-7,FE4);
    canvas.textout(9,91-7,FE5);
    canvas.textout(2,63-7,FE6);
    canvas.textout(2,33-10,FE7);
    end;
 if  Fper=true then
begin

    canvas.textout(90,203-7,FE1);
    canvas.textout(90,175-7,FE2);
    canvas.textout(90,148-7,FE3);
    canvas.textout(90,119-7,FE4);
    canvas.textout(90,92-7,FE5);
    canvas.textout(90,63-7,FE6);
    canvas.textout(90,33-10,FE7);


end;













 //duas linhas que cortam as divisões
  canvas.moveto(33,33);canvas.lineto(33,203);
  canvas.moveto(72,33);canvas.lineto(72,203);


 //divisões a direita



 canvas.moveto(72,203);canvas.lineto(84,203);
 canvas.moveto(72,175);canvas.lineto(84,175);
 canvas.moveto(72,147);canvas.lineto(84,147);
 canvas.moveto(72,119);canvas.lineto(84,119);
 canvas.moveto(72,91);canvas.lineto(84,91);
 canvas.moveto(72,63);canvas.lineto(84,63);
 canvas.moveto(72,35);canvas.lineto(84,35);

  canvas.moveto(72,175+14);canvas.lineto(78,175+14);
  canvas.moveto(72,147+14);canvas.lineto(78,147+14);
  canvas.moveto(72,119+14);canvas.lineto(78,119+14);
  canvas.moveto(72,91+14);canvas.lineto(78,91+14);
  canvas.moveto(72,63+14);canvas.lineto(78,63+14);
  canvas.moveto(72,35+14);canvas.lineto(78,35+14);







  //barra
  canvas.rectangle(40,33,61,203);




  // texto posiçao
  canvas.rectangle(30,210,70,224);
 canvas.TextOut(42,207,inttostr(FPosicao));

 // primeira e segunda linha de texzto
 canvas.TextOut(38,0,Fnome);

  canvas.TextOut(38,15,FnomeB);

     canvas.brush.Style:=bssolid;
     canvas.brush.Color:=clgray;


    canvas.rectangle(40,203-round((170*Fposicao)/100),61,203);






end;

procedure TShapeQualquer .SetEspaco(AValue: integer);
begin
  if FEspaco=AValue then Exit;
  FEspaco:=AValue;
end;

procedure TShapeQualquer .SetDivisoes(AValue: integer);
begin
  if FDivisoes=AValue then Exit;
  FDivisoes:=AValue;
end;

procedure TShapeQualquer.SetE1(AValue: string);
begin
  if FE1=AValue then Exit;
  FE1:=AValue;
end;

procedure TShapeQualquer.SetE2(AValue: string);
begin
  if FE2=AValue then Exit;
  FE2:=AValue;
end;

procedure TShapeQualquer.SetE3(AValue: string);
begin
  if FE3=AValue then Exit;
  FE3:=AValue;
end;

procedure TShapeQualquer.SetE4(AValue: string);
begin
  if FE4=AValue then Exit;
  FE4:=AValue;
end;

procedure TShapeQualquer.SetE5(AValue: string);
begin
  if FE5=AValue then Exit;
  FE5:=AValue;
end;

procedure TShapeQualquer.SetE6(AValue: string);
begin
  if FE6=AValue then Exit;
  FE6:=AValue;
end;

procedure TShapeQualquer.SetE7(AValue: string);
begin
  if FE7=AValue then Exit;
  FE7:=AValue;
end;

procedure TShapeQualquer.SetCorrTemp(AValue: boolean);
begin
  if FCorrTemp=AValue then Exit;
  FCorrTemp:=AValue;
end;

procedure TShapeQualquer.SetescalaD(AValue: Boolean);
begin
  if FescalaD=AValue then Exit;
  FescalaD:=AValue;
end;

procedure TShapeQualquer.SetMescala(AValue: Boolean);
begin
  if FMescala=AValue then Exit;
  FMescala:=AValue;
end;

procedure TShapeQualquer.SetNome(AValue: string);
begin
  if FNome=AValue then Exit;
  FNome:=AValue;
end;

procedure TShapeQualquer.SetNomeB(AValue: string);
begin
  if FNomeB=AValue then Exit;
  FNomeB:=AValue;
end;

procedure TShapeQualquer.Setper(AValue: boolean);
begin
  if Fper=AValue then Exit;
  Fper:=AValue;
end;







procedure TShapeQualquer.SetPosicao(AValue: integer);
begin
  if FPosicao=AValue then Exit;
  FPosicao:=AValue;
end;

procedure TShapeQualquer.SetColorOfShape(Value: TColor);
begin
  if FColorOfShape <> Value then
     begin
      FColorOfShape := Value;
      Self.Brush.Color := FColorOfShape;
     end;
end;




destructor TShapeQualquer.Destroy;
begin
  inherited Destroy;
end;

end.


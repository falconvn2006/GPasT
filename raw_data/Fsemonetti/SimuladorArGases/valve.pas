unit Valve;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
   Tipo = (um,dois,tres,quatro,cinco,seis,sete);


   TPix = Array of TPoint;
  { TShapeG }

  { TValve }

  TValve = class(TShape)
  private
    FAtuada: Boolean;
    FModelo: tipo;
  procedure SetAtuada(AValue: Boolean);
  procedure SetModelo(AValue: tipo);
  protected
     FColorOfShape: TColor;
     procedure SetColorOfShape(Value: TColor);

   public
  constructor Create(AOwner: TComponent); override;
  procedure paint;override;


   destructor Destroy; override;

  published

   property Modelo : tipo read FModelo write SetModelo;
   property Atuada : Boolean read FAtuada write SetAtuada;

     Property ChangeColor: TColor read FColorOfShape write SetColorOfShape;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio',[TValve]);
end;

{ TShapeF }

constructor TValve.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

procedure TValve.paint;
Var a,b,c,l: integer;
begin
  //Width:=100;
 // Height:=50;
 //canvas.pen.Color:=clwhite;
 // canvas.brush.Style:=bssolid;
 // canvas.rectangle(0,0,width,height);

  canvas.pen.Color:=clblack;
  canvas.brush.Style:=bsClear;
  canvas.pen.Width:=1;
if  FModelo=um then
       begin
        a:=round(width*0.08);
        L:=Width-2*a;
        b:=round(L/8);
        c:=round(l/2);
        // parte comun
        // Retangulo principal
        canvas.rectangle(a,0,a+L,height);
        // Linha do Meio
        canvas.moveto(a+round(l/2),0);
        canvas.lineto(a+round(l/2),height);
        // a mola do  lado direito parte de baixo
        canvas.moveto(width-1,height);

        canvas.lineto(width-1,height-round(height/3));
        canvas.lineto(width-round(a/2),height);
        canvas.lineto(width-a-1,height-round(height/3));
        canvas.lineto(width-a-1,0);
        // parte conforme estado
            if  FAtuada=true  then
                       begin
                        canvas.pen.Color:=clred;
                        // Desenhar seta no lado esquerdo ponta para baixo
                        canvas.moveto(a+round(l/4),height);
                        canvas.Lineto(a+round(l/4),0);
                        canvas.lineto(a+round(l/4)+round(b/2),round(height/8));
                        canvas.lineto(a+round(l/4)-round(b/2),round(height/8));
                        canvas.Lineto(a+round(l/4),0);
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),height);
                        canvas.lineto(a+3*round(l/4),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),0);
                        canvas.lineto(a+3*round(l/4),round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),round(height/4));

                       end
                    else
                     begin
                       canvas.pen.Color:=clred;
                        // Desenhar seta no lado direito ponta para baixo
                        canvas.moveto(a+3*round(l/4),height);
                        canvas.Lineto(a+3*round(l/4),0);
                        canvas.lineto(a+3*round(l/4)+round(b/2),round(height/8));
                        canvas.lineto(a+3*round(l/4)-round(b/2),round(height/8));
                        canvas.Lineto(a+3*round(l/4),0);
                        // desenhar o t no quadrado da esquerdo no meio na parte de baixo
                        canvas.moveto(a+round(l/4),height);
                        canvas.lineto(a+round(l/4),height-round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+round(l/4),0);
                        canvas.lineto(a+round(l/4),round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),round(height/4));
                   end


  end; // fim do um
if  FModelo=dois then
       begin
        a:=round(width*0.08);
        L:=Width-2*a;
        b:=round(L/8);
        c:=round(l/2);
        // parte comun
        // Retangulo principal
        canvas.rectangle(a,0,a+L,height);
        // Linha do Meio
        canvas.moveto(a+round(l/2),0);
        canvas.lineto(a+round(l/2),height);
        // a mola do  lado esquerdo parte de cima
        canvas.moveto(0,0);
        canvas.lineto(0,round(height/3));
        canvas.lineto(round(a/2),0);
        canvas.lineto(a,round(height/3));
        canvas.lineto(a,0);
        // parte conforme estado
            if  FAtuada=true  then
                       begin
                        canvas.pen.Color:=clred;
                        // Desenhar seta no lado esquerdo ponta para baixo
                        canvas.moveto(a+round(l/4),0);
                        canvas.Lineto(a+round(l/4),height);
                        canvas.lineto(a+round(l/4)+round(b/2),height-round(height/8));
                        canvas.lineto(a+round(l/4)-round(b/2),height-round(height/8));
                        canvas.Lineto(a+round(l/4),height);
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),height);
                        canvas.lineto(a+3*round(l/4),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),0);
                        canvas.lineto(a+3*round(l/4),round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),round(height/4));

                       end
                    else
                     begin
                       canvas.pen.Color:=clred;
                        // Desenhar seta no lado direito ponta para baixo
                        canvas.moveto(a+3*round(l/4),0);
                        canvas.Lineto(a+3*round(l/4),height);
                        canvas.lineto(a+3*round(l/4)+round(b/2),height-round(height/8));
                        canvas.lineto(a+3*round(l/4)-round(b/2),height-round(height/8));
                        canvas.Lineto(a+3*round(l/4),height);
                        // desenhar o t no quadrado da esquerdo no meio na parte de baixo
                        canvas.moveto(a+round(l/4),height);
                        canvas.lineto(a+round(l/4),height-round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+round(l/4),0);
                        canvas.lineto(a+round(l/4),round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),round(height/4));
                   end


  end; // fim do dois
if  FModelo=tres then
       begin
        a:=round(width*0.08);
        L:=Width-2*a;
        b:=round(L/8);
        c:=round(l/2);
        // parte comun
        // Retangulo principal
        canvas.rectangle(a,0,a+L,height);
        // Linha do Meio
        canvas.moveto(a+round(l/2),0);
        canvas.lineto(a+round(l/2),height);
        if  FAtuada=true  then
                       begin
                        canvas.pen.Color:=clred;
                        // Desenhar seta no lado esquerdo ponta para baixo
                        canvas.moveto(a+round(l/4),height);
                        canvas.Lineto(a+round(l/4),0);
                        canvas.lineto(a+round(l/4)+round(b/2),round(height/8));
                        canvas.lineto(a+round(l/4)-round(b/2),round(height/8));
                        canvas.Lineto(a+round(l/4),0);
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),height);
                        canvas.lineto(a+3*round(l/4),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),0);
                        canvas.lineto(a+3*round(l/4),round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),round(height/4));

                       end
                    else
                     begin
                       canvas.pen.Color:=clred;
                        // Desenhar seta no lado direito ponta para baixo
                        canvas.moveto(a+3*round(l/4),height);
                        canvas.Lineto(a+3*round(l/4),0);
                        canvas.lineto(a+3*round(l/4)+round(b/2),round(height/8));
                        canvas.lineto(a+3*round(l/4)-round(b/2),round(height/8));
                        canvas.Lineto(a+3*round(l/4),0);
                        // desenhar o t no quadrado da esquerdo no meio na parte de baixo
                        canvas.moveto(a+round(l/4),height);
                        canvas.lineto(a+round(l/4),height-round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+round(l/4),0);
                        canvas.lineto(a+round(l/4),round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),round(height/4));
                   end


  end; // fim do tres
if  FModelo=quatro then
       begin
        a:=round(width*0.08);
        L:=Width-2*a;
        b:=round(L/8);
        c:=round(l/2);
        // parte comun
        // Retangulo principal
        canvas.rectangle(a,0,a+L,height);
        // Linha do Meio
        canvas.moveto(a+round(l/2),0);
        canvas.lineto(a+round(l/2),height);
        // parte conforme estado
            if  FAtuada=true  then
                       begin
                        canvas.pen.Color:=clred;
                        // Desenhar seta no lado esquerdo ponta para baixo
                        canvas.moveto(a+round(l/4),0);
                        canvas.Lineto(a+round(l/4),height);
                        canvas.lineto(a+round(l/4)+round(b/2),height-round(height/8));
                        canvas.lineto(a+round(l/4)-round(b/2),height-round(height/8));
                        canvas.Lineto(a+round(l/4),height);
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),height);
                        canvas.lineto(a+3*round(l/4),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+3*round(l/4),0);
                        canvas.lineto(a+3*round(l/4),round(height/4));
                        canvas.lineto(a+3*round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+3*round(l/4)-round(b/2),round(height/4));
                       end
                    else
                     begin
                       canvas.pen.Color:=clred;
                        // Desenhar seta no lado direito ponta para baixo
                        canvas.moveto(a+3*round(l/4),0);
                        canvas.Lineto(a+3*round(l/4),height);
                        canvas.lineto(a+3*round(l/4)+round(b/2),height-round(height/8));
                        canvas.lineto(a+3*round(l/4)-round(b/2),height-round(height/8));
                        canvas.Lineto(a+3*round(l/4),height);
                        // desenhar o t no quadrado da esquerdo no meio na parte de baixo
                        canvas.moveto(a+round(l/4),height);
                        canvas.lineto(a+round(l/4),height-round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita no meio na parte de baixo
                        canvas.moveto(a+round(l/4),0);
                        canvas.lineto(a+round(l/4),round(height/4));
                        canvas.lineto(a+round(l/4)+round(b/2),round(height/4));
                        canvas.lineto(a+round(l/4)-round(b/2),round(height/4));
                   end
  end; // fim do quatro

     if  FModelo=cinco then
  begin
  if  FAtuada=true  then
 begin
  canvas.rectangle(0,0,width,height); // retangulo principal
  canvas.moveto(0,round(height/2));    // linha do meio
  canvas.lineto(width,round(height/2)); // linha do meio
  //seta
   canvas.moveto(0,round(height/4));
  canvas.lineto(width,round(height/4));
  canvas.lineto(width-10,round(height/4)-round(height/8));
  canvas.lineto(width-10,round(height/4)+round(height/8));
  canvas.lineto(width,round(height/4));
  // t de cima
  canvas.moveto(0,height-round(height/4));
  canvas.lineto(round(width/4),height-round(height/4));
  canvas.lineto(round(width/4),height-round(height/4)-round(height/8));
  canvas.lineto(round(width/4),height-round(height/4)+round(height/8));
  canvas.moveto(width,height-round(height/4));
  canvas.lineto(width-round(width/4),height-round(height/4));
  canvas.lineto(width-round(width/4),height-round(height/4)-round(height/8));
  canvas.lineto(width-round(width/4),height-round(height/4)+round(height/8));
  end
  else
  begin
    canvas.rectangle(0,0,width,height); // retangulo principal
    canvas.moveto(0,round(height/2));    // linha do meio
    canvas.lineto(width,round(height/2)); // linha do meio
    //seta
    canvas.moveto(0,height-round(height/4));
    canvas.lineto(width,height-round(height/4));
    canvas.lineto(width-10,height-round(height/4)-round(height/8));
    canvas.lineto(width-10,height-round(height/4)+round(height/8));
    canvas.lineto(width,height-round(height/4));
    // t de cima
    canvas.moveto(0,round(height/4));
    canvas.lineto(round(width/4),round(height/4));
    canvas.lineto(round(width/4),round(height/4)-round(height/8));
    canvas.lineto(round(width/4),round(height/4)+round(height/8));
    canvas.moveto(width,round(height/4));
    canvas.lineto(width-round(width/4),round(height/4));
    canvas.lineto(width-round(width/4),round(height/4)-round(height/8));
    canvas.lineto(width-round(width/4),round(height/4)+round(height/8));
  end;
end;
if  FModelo=seis then
       begin
        a:=round(width*0.08);
        L:=Width-2*a;
        b:=round(L/8);
        c:=round(l/2);
        // parte comun
        // Retangulo principal
        canvas.rectangle(a,0,a+L,height);
        // Linha do Meio
        canvas.moveto(a+round(l/2),0);
        canvas.lineto(a+round(l/2),height);
        // quadrado do canto esquerdo
        canvas.rectangle(0,height-round(height/3),a,height);
        // linha inclinada do quadrado esquerdo
        canvas.moveto(0,height-round(height/3));
        canvas.lineto(a,height);
        // a mola do outro lado
        canvas.moveto(a+L,height-round(height/3));
        canvas.lineto(a+L+round(a/2),height);
        canvas.lineto(2*a+L-1,height-round(height/3));
        canvas.lineto(2*a+L-1,height);
       // parte conforme estado
            if  FAtuada=true  then
                       begin
                        // Desenhar seta no lado esquerdo ponta para cima
                        canvas.moveto(a+b,height);
                        canvas.Lineto(a+b,0);
                        canvas.lineto(a+b+round(b/2),round(height/8));
                        canvas.lineto(a+b-round(b/2),round(height/8));
                        canvas.Lineto(a+b,0);
                        // desenhar o t no quadrado da esquerda lado direito
                        canvas.moveto(a+round(l/2)-B,height);
                        canvas.lineto(a+round(l/2)-B,height-round(height/4));
                        canvas.lineto(a+round(l/2)-B+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/2)-B-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da direita  lado esquerdo
                        canvas.moveto(a+round(l/2)+B,height);
                        canvas.lineto(a+round(l/2)+B,height-round(height/4));
                        canvas.lineto(a+round(l/2)+B+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/2)+B-round(b/2),height-round(height/4));
                        // desenhar a ponta inclinada quadrado direito lado direito
                        canvas.moveto(a+round(l/2)+B,0);
                        canvas.lineto(width-a-b,height);
                        canvas.lineto(width-a-b-2*round(b/3),height-round(height/8));
                        canvas.lineto(width-a-b+round(b/6),height-round(height/8));
                        canvas.lineto(width-a-b,height);
                   end
                    else
                     begin
                        // Desenhar seta no lado esquerdo ponta para cima
                        canvas.moveto(c+a+b,height);
                        canvas.Lineto(c+a+b,0);
                        canvas.lineto(c+a+b+round(b/2),round(height/8));
                        canvas.lineto(c+a+b-round(b/2),round(height/8));
                        canvas.Lineto(c+a+b,0);
                        // desenhar o t no quadrado da esquerda lado direito
                        canvas.moveto(c+a+round(l/2)-B,height);
                        canvas.lineto(c+a+round(l/2)-B,height-round(height/4));
                        canvas.lineto(c+a+round(l/2)-B+round(b/2),height-round(height/4));
                        canvas.lineto(c+a+round(l/2)-B-round(b/2),height-round(height/4));
                        // desenhar o t no quadrado da esquerda  lado direito
                        canvas.moveto(a+B,height);
                        canvas.lineto(a+B,height-round(height/4));
                        canvas.lineto(a+B+round(b/2),height-round(height/4));
                        canvas.lineto(a+B-round(b/2),height-round(height/4));
                        // desenhar a ponta inclinada quadrado esquerdo lado direito
                        canvas.moveto(a+B,0);
                        canvas.lineto(a+3*b,height);
                        canvas.lineto(a+3*b-2*round(b/3),height-round(height/8));
                        canvas.lineto(a+3*b+round(b/6),height-round(height/8));
                        canvas.lineto(a+3*b,height);
                   end
  end; // fim do seis

if  FModelo=sete then
       begin
        a:=round(width*0.08);
        L:=Width-2*a;
        b:=round(L/8);
        c:=round(l/2);
        // parte comun
        // Retangulo principal
        canvas.rectangle(a,0,a+L,height);
        // Linha do Meio
        canvas.moveto(a+round(l/2),0);
        canvas.lineto(a+round(l/2),height);
        // a mola do  lado esquerdo parte de cima
        canvas.moveto(0,0);
        canvas.lineto(0,round(height/3));
        canvas.lineto(round(a/2),0);
        canvas.lineto(a,round(height/3));
        canvas.lineto(a,0);
        // parte conforme estado
            if  FAtuada=true  then
                       begin
                        canvas.pen.Color:=clred;
                        // Desenhar seta no lado esquerdo ponta para cima
                        canvas.moveto(a+b,height);
                        canvas.Lineto(a+b,0);
                        canvas.lineto(a+b+round(b/2),round(height/8));
                        canvas.lineto(a+b-round(b/2),round(height/8));
                        canvas.Lineto(a+b,0);
                        // desenhar o t no quadrado da esquerda lado direito
                        canvas.moveto(a+round(l/2)-B,height);
                        canvas.lineto(a+round(l/2)-B,height-round(height/4));
                        canvas.lineto(a+round(l/2)-B+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/2)-B-round(b/2),height-round(height/4));
                        canvas.pen.Color:=clblack;
                        // desenhar o t no quadrado da direita  lado esquerdo
                        canvas.moveto(a+round(l/2)+B,height);
                        canvas.lineto(a+round(l/2)+B,height-round(height/4));
                        canvas.lineto(a+round(l/2)+B+round(b/2),height-round(height/4));
                        canvas.lineto(a+round(l/2)+B-round(b/2),height-round(height/4));
                        // desenhar a ponta inclinada quadrado direito lado direito
                        canvas.moveto(a+round(l/2)+B,0);
                        canvas.lineto(width-a-b,height);
                        canvas.lineto(width-a-b-2*round(b/3),height-round(height/8));
                        canvas.lineto(width-a-b+round(b/6),height-round(height/8));
                        canvas.lineto(width-a-b,height);
                   end
                    else
                     begin
                        canvas.pen.Color:=clblack;
                        // Desenhar seta no lado esquerdo ponta para cima
                        canvas.moveto(c+a+b,height);
                        canvas.Lineto(c+a+b,0);
                        canvas.lineto(c+a+b+round(b/2),round(height/8));
                        canvas.lineto(c+a+b-round(b/2),round(height/8));
                        canvas.Lineto(c+a+b,0);
                        // desenhar o t no quadrado da esquerda lado direito
                        canvas.moveto(c+a+round(l/2)-B,height);
                        canvas.lineto(c+a+round(l/2)-B,height-round(height/4));
                        canvas.lineto(c+a+round(l/2)-B+round(b/2),height-round(height/4));
                        canvas.lineto(c+a+round(l/2)-B-round(b/2),height-round(height/4));
                         canvas.pen.Color:=clred;
                        // desenhar o t no quadrado da esquerda  lado direito
                        canvas.moveto(a+B,height);
                        canvas.lineto(a+B,height-round(height/4));
                        canvas.lineto(a+B+round(b/2),height-round(height/4));
                        canvas.lineto(a+B-round(b/2),height-round(height/4));
                        // desenhar a ponta inclinada quadrado esquerdo lado direito
                        canvas.moveto(a+B,0);
                        canvas.lineto(a+3*b,height);
                        canvas.lineto(a+3*b-2*round(b/3),height-round(height/8));
                        canvas.lineto(a+3*b+round(b/6),height-round(height/8));
                        canvas.lineto(a+3*b,height);
                   end
  end; // fim do sete
end;


procedure TValve.SetModelo(AValue: tipo);
begin
  if FModelo=AValue then Exit;
  FModelo:=AValue;
   invalidate;
end;

procedure TValve.SetColorOfShape(Value: TColor);
begin
 if FColorOfShape <> Value then
     begin
      FColorOfShape := Value;
      Self.Brush.Color := FColorOfShape;
     end;
end;

procedure TValve.SetAtuada(AValue: Boolean);
begin
  if FAtuada=AValue then Exit;
   FAtuada:=AValue;
  invalidate;
end;

destructor TValve.Destroy;
begin
  inherited Destroy;
end;

end.


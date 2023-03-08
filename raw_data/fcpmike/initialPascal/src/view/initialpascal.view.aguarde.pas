{ ******************************************************************************
  Title: View Aguarde
  Description: Tela de Aguarde

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add
  **************************************************************************** }
unit initialPascal.View.Aguarde;

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, Classes;

type

  { TFViewAguarde }

  TFViewAguarde = class(TForm)
    panBottom: TPanel;
    panTop: TPanel;
    ShapeAnimacao: TShape;
    timAnimation: TTimer;
    procedure timAnimationTimer(Sender: TObject);
  private
    vShapeAnimado: Boolean;
  public

  end;

var
  FViewAguarde: TFViewAguarde;

implementation

{$R *.lfm}

{ TFViewAguarde }

procedure TFViewAguarde.timAnimationTimer(Sender: TObject);
begin
  if vShapeAnimado then
  begin
    ShapeAnimacao.Left:=ShapeAnimacao.Left - ShapeAnimacao.Width;
    vShapeAnimado:=not (ShapeAnimacao.Left <= 0);
  end else
  begin
    ShapeAnimacao.Left:=ShapeAnimacao.Left + ShapeAnimacao.Width;
    vShapeAnimado:=(ShapeAnimacao.Left > (Self.Width-ShapeAnimacao.Width));
  end;
  Self.Refresh;
end;

end.


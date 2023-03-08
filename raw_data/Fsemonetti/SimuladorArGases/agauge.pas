unit AGauge;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TAGauge }

  TAGauge = class(TPaintBox)
  private
   Local : Tpaintbox;
  protected

  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Paint; override;

  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio',[TAGauge]);
end;

{ TAGauge }

constructor TAGauge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.Height:=80;
  self.Width:=120;
  self.Color:=clgreen;
end;

destructor TAGauge.Destroy;
begin
  inherited Destroy;
end;

procedure TAGauge.Paint;
begin
  inherited Paint;
  canvas.moveto(0,0);
  canvas.lineto(80,120);
end;

end.

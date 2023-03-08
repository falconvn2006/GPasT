unit Mgauge;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls ;


type

  { TMgauge }

  TMgauge = Class(Tpanel)
    private
    Errro: TLabel;
    Ferro: integer;
    Fposicao: integer;
    Pposicao : TLabel;
    Label12 : TLabel;
    Label13 : TLabel;

    Sposicao: TShape;
    Serro   : TShape;
    Shape3  : TShape;
    Shape4  : TShape;
    procedure Seterro(AValue: integer);
    procedure Setposicao(AValue: integer);
    protected
    public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint;override;
   published
   property erro : integer read Ferro write Seterro;
   property posicao:integer read Fposicao write Setposicao;


  end;




procedure Register;
implementation

{ TPanelEstacaoMotor }
procedure Register;
begin
RegisterComponents('Fabricio', [TMgauge]);
end;


{ TMgauge }

procedure TMgauge.Seterro(AValue: integer);
begin
  if Ferro=AValue then Exit;
  Ferro:=AValue;
  errro.caption:='Erro '+inttostr(avalue)+'%';
  Serro.left:=8+avalue;
  Serro.Width:=2;

end;

procedure TMgauge.Setposicao(AValue: integer);
begin
  if Fposicao=AValue then Exit;
  Fposicao:=AValue;
   Pposicao.caption:='Posição '+inttostr(AValue)+'%';
   Sposicao.Width:=avalue;;
end;

constructor TMgauge.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption:='';
  Color:=clActiveCaption;
  Width:=120;
  Height:=120;
  Top:=150;;
  Left:=150;

  Label13:= Tlabel.create(nil);
  Label13.Parent:=self;
  Label13.caption:='0           50          100';
  Label13.Top:=40;
  Label13.Left:=10;
  Label13.Height:=15;
  Label13.Width:=96;
  Label13.Alignment:=taCenter;

  errro:= Tlabel.create(nil);
  errro.Parent:=self;
  errro.caption:='Erro 0%';
  errro.Top:=53;
  errro.Left:=41;
  errro.Height:=15;
  errro.Width:=34;
  errro.Alignment:=taCenter;


  Label12:= Tlabel.create(nil);
  Label12.Parent:=self;
  Label12.caption:='-20          0           20';
  Label12.Top:=96;
  Label12.Left:=8;
  Label12.Height:=15;
  Label12.Width:=101;
  Label12.Alignment:=taCenter;

  Pposicao:= Tlabel.create(nil);
  Pposicao.Parent:=self;
  Pposicao.caption:='Posição 0%';
  Pposicao.Top:=0;
  Pposicao.Left:=33;
  Pposicao.Height:=18;
  Pposicao.Width:=54;
  Pposicao.Alignment:=taCenter;





  
  Shape3:=Tshape.create(nil);
  Shape3.parent:=self;
  Shape3.Color:=8;
  Shape3.Width:=100;
  Shape3.Height:=25;
  Shape3.Top:=16;
  Shape3.Left:=8;
  Shape3.Brush.Color:=clwhite;


  Sposicao:=Tshape.create(nil);
  Sposicao.parent:=self;
  Sposicao.Color:=8;
  Sposicao.Width:=50;
  Sposicao.Height:=25;
  Sposicao.Top:=16;
  Sposicao.Left:=8;
  Sposicao.Brush.Color:=clblue;
  Sposicao.BringToFront;


  Shape4:=Tshape.create(nil);
  Shape4.parent:=self;
  Shape4.Color:=8;
  Shape4.Width:=100;
  Shape4.Height:=25;
  Shape4.Top:=69;
  Shape4.Left:=8;
  Shape4.Brush.Color:=clMenuBar;


  Serro:=Tshape.create(nil);
  Serro.parent:=self;
  Serro.Color:=8;
  Serro.Width:=2;
  Serro.Height:=25;
  Serro.Top:=69;
  Serro.Left:=8;
  Serro.Brush.Color:=clred;



end;

destructor TMgauge.Destroy;
begin
  inherited Destroy;
end;

procedure TMgauge.paint;
begin

end;

end.


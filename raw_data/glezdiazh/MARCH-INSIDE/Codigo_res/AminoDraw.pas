unit AminoDraw;

interface
  uses ExtCtrls, classes, StdCtrls, Controls, Graphics, Menus, ConstandUtils;

Type

  TA_Draw =
    class(TShape)
      private
       procedure SetParent(aParent: TWinControl);
       procedure PosIdentifier;
      public
        Identifier: TLabel;
        constructor Create(aOwner: TComponent);
        destructor Destroy; override;
        Procedure LoadFromElement(x,y,Z: Real;PropertyX: Integer);
      public
        property TheParent: TWinControl write SetParent;
    end;

implementation

  uses Main, results,save;

constructor TA_Draw.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Identifier := TLabel.Create(aOwner);
  Identifier.Transparent := true;
  Shape := stCircle;
  Brush.Color := clgray;
  Width := 20;
  Height := 20;

 end;

destructor TA_Draw.Destroy;
begin
  Identifier.Free;
  inherited Destroy;
end;

procedure TA_Draw.SetParent(aParent: TWinControl);
begin
  Parent := aParent;
  Identifier.Parent := aParent;
  PosIdentifier;
end;

procedure TA_Draw.PosIdentifier;
begin
  Identifier.Left := Left +7 ;
  Identifier.Top := Top +4;
end;

Procedure TA_Draw.LoadFromElement(x,y,Z: Real;PropertyX: Integer);
 const
  factor = 12;
begin
  if StatusX then
  begin
   Left := 512+Trunc((Sin(Pi/2)*x + Sin(165*Pi/180)*y + Sin(105*Pi/180)*z)*factor);
   Top := 320-Trunc((Cos(Pi/2)*x + Cos(165*Pi/180)*y + Cos(105*Pi/180)*z)*factor);
   Identifier.Caption := AASEQ2[PropertyX];
   Brush.Color := ColorPalette [PropertyX];
  end
 else
  begin
   Left := trunc(x);
   Top :=  Trunc(y);
   Identifier.Caption := '.';
   Brush.Color := Clgray;
   Width := 10;
   Height := 10;
  end;


end;



end.

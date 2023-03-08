unit SeqRes;

interface
  uses  Controls, Classes, AminoDraw, ConstandUtils;

Type

  TTSeqRes =
    class(TGraphicControl)
      private
      public
        constructor Create(aOwner: TComponent);
        destructor Destroy; override;
        procedure Paint; override;
       // procedure SaveToFile(Stream: TFileStream);
        Procedure LoadFromLuft(Idx:integer);
      public
        Origin,
        Destination: TA_Draw;
    end;

implementation
  uses Main, Graphics;

constructor TTSeqRes.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
   Canvas.Pen.Width := 10;
 end;

destructor TTSeqRes.Destroy;
begin
  inherited Destroy;
end;

procedure TTSeqRes.Paint;

 begin
   canvas.pen.Width :=3;
   Canvas.pen.Color := clgray;

    if Origin.Left <= Destination.Left
    then
      begin
        if Origin.Top <= Destination.Top
          then
            begin
              Left := Origin.Left + 10;
              Top := Origin.Top + 10;
              Canvas.MoveTo(0, 0);
              Canvas.LineTo(Width, Height);
            end
          else
            begin
              Left := Origin.Left + 10;
              Top := Destination.Top + 10;
              Canvas.MoveTo(0, Height);
              Canvas.LineTo(Width, 0);
            end;
      end
    else
      begin
      canvas.Pen.Color := clgray;
        if Origin.Top <= destination.Top
          then
            begin
              Left := Destination.Left + 10;
              Top := Origin.Top + 10;
              Canvas.MoveTo(Width, 0);
              Canvas.LineTo(0, Height);
            end
          else
            begin
              Left := Destination.Left + 10;
              Top := Destination.Top + 10;
              Canvas.MoveTo(Width, Height);
              Canvas.LineTo(0, 0);
            end;
    end;
end;
{
procedure TTSeqRes.SaveToFile(Stream: TFileStream);
var
  Index: Integer;
begin
  Stream.Write(Left, SizeOf(Left));
  Stream.Write(Top, SizeOf(Top));
  Stream.Write(Width, SizeOf(Width));
  Stream.Write(Height, SizeOf(Height));
  Index := MainForm.ChemElement2.AminoAPos(Origin);
  Stream.Write(Index, SizeOf(Index));
  Index := MainForm.ChemElement2.AminoAPos(Destination);
  Stream.Write(Index, SizeOf(Index));
end;
 }


Procedure TTSeqRes.LoadFromLuft(Idx:integer);

const
  factor = 10;

begin
if Idx = 0 then
  begin
   Origin := MainForm.ChemToDraw.AminoAs[Idx];
   Destination := MainForm.ChemToDraw.AminoAs[Idx];
   Height := Abs( Destination.Top - Origin.Top);
   Width  := Abs(Destination.Left - Origin.Left);
 end
   else
    begin
      Origin := MainForm.ChemToDraw.AminoAs[Idx-1];
      Destination := MainForm.ChemToDraw.AminoAs[Idx];
      Height := Abs( Destination.Top - Origin.Top);
      Width  := Abs(Destination.Left - Origin.Left);

    end;

  end;

end.

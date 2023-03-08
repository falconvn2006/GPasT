unit ProtDraw;

interface
  uses AminoAcids, SeqRes, Classes, Drawing, AminoDraw;

Type

  TAminoAs = TList;
  TSeqRes = TList;


  TProtDraw =
    class
      private
        FAminoAs: TAminoAs;
        FSeqRes: TSeqRes;

      public
        Visible:Boolean;
        constructor Create;
        destructor Destroy; override;
        Procedure LoadFromElement (x,y,z:real;propertyX:Integer);
        procedure AddAminoA(aAminoA: TA_Draw);
        procedure AddSeqRes(SeqRes:TTSeqRes);
        Procedure SetSeq;
        function GetAminoA(I: Integer): TA_Draw;
        function GetAminoAsCount: Integer;

      public

        property AminoAs[I: Integer]: TA_Draw read GetAminoA;
        property AminoAsCount: Integer read GetAminoAsCount;


    end;

implementation
  uses Main, SysUtils, ConstAndUtils;

constructor TProtDraw.Create;
begin
  inherited Create;
  FAminoAs := TAminoAs.Create;
  FSeqRes  := TSeqRes.create;
end;

destructor TProtDraw.Destroy;
var
  I: Integer;
begin
  for I := 0 to Pred(FAminoAs.Count) do
  TAminoA(FAminoAs[I]).Destroy;
  FAminoAs.Free;
  for I:=0 to Pred(FSeqRes.Count) do
  TSeqRes(FSeqRes[I]).Destroy;
  inherited Destroy;
end;


Procedure TProtDraw.LoadFromElement (x,y,z:real;propertyX:Integer);
var
 AminoA: TA_Draw;
begin
  AminoA := TA_Draw.Create(Draw_frm);
  AminoA.LoadFromElement (x,y,z,propertyX);
  AddAminoA(AminoA);
end;


  // to Draw AminoAcids

Procedure TProtDraw.SetSeq;
var
  AminoA  : TA_Draw;
   SeqRes  : TTSeqRes;
   FileAA : Textfile;
         S: ShortString;
   I, model:integer;

begin
   for I := 0 to Pred(FAminoAs.Count) do
    begin
      SeqRes :=TTSeqRes.Create(Draw_frm);
      if  (I <> Pred(FAminoAs.Count))  then SeqRes.LoadFromLuft(I+1)
                                       else SeqRes.LoadFromLuft(I);
      SeqRes.Parent := Draw_frm;
      SeqRes.Paint;
      AddSeqRes(SeqRes);
    end;

     for I := 0 to Pred(FAminoAs.Count) do
      AminoAs[I].TheParent := Draw_frm;

end;


procedure TProtDraw.AddAminoA(aAminoA: TA_Draw);
begin
  FAminoAs.Add(aAminoA);
end;

procedure TProtDraw.AddSeqRes(SeqRes:TTSeqRes);
begin
 FSeqRes.Add(SeqRes);
end;

function TProtDraw.GetAminoA(I: Integer): TA_Draw;
begin
 If FaminoAS = nil then result:=nil
  else
     result :=  FAminoAs[I];
end;


function TProtDraw.GetAminoAsCount: Integer;
begin
  Result := FAminoAs.Count;
end;




end.

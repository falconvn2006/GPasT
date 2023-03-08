unit Prot_Draw;

interface
  uses AminoAcids, SeqRes, Classes, Drawing;

Type

  TAminoAs = TList;
  TSeqRes = TList;

  Centroid = record
   x,y,z:real;
   end;

  TProteins =
    class
      private
        FAminoAs: TAminoAs;
        FSeqRes: TSeqRes;
        function GetAminoA(I: Integer): TAminoA;
        function GetAminoAsCount: Integer;
      public
        Midle_point:Centroid;
        MaxDist :Real;
        Visible :boolean;
        constructor Create;
        destructor Destroy; override;
        procedure SaveToFile(Stream: TFileStream);
        Procedure LoadFromFile(F: ShortString);
        procedure AddAminoA(aAminoA: TAminoA);
        procedure AddSeqRes(SeqRes:TTSeqRes);
        function AminoAPos(AminoA: TAminoA): Integer;
        Procedure GetCentroid (var centroidx:Centroid);
        function MaxDistt:Real;

     public
        property AminoAs[I: Integer]: TAminoA read GetAminoA;
        property AminoAsCount: Integer read GetAminoAsCount;


    end;

implementation
  uses Main, SysUtils, ConstAndUtils;

constructor TProteins.Create;
begin
  inherited Create;
  FAminoAs := TAminoAs.Create;
  FSeqRes  := TSeqRes.create;
end;

destructor TProteins.Destroy;
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

procedure TProteins.SaveToFile(Stream: TFileStream);
var
  I: Integer;
begin
  Stream.Write(FAminoAs.Count, SizeOf(FAminoAs.Count));
  for I := 0 to Pred(FAminoAs.Count) do
    AminoAs[I].SaveToFile(Stream);

end;

Procedure TProteins.LoadFromFile(F: ShortString);
var
  AminoA  : TAminoA;
  SeqRes  : TTSeqRes;
   FileAA : Textfile;
         S: ShortString;
   I, model:integer;
begin
  //To Read  AminoAcids
  Assign (FileAA,F);
  reset (FileAA);
  Term :=TStringlist.Create;
  model := 0;
  While (not Eof(FileAA) ) and (model <> 2) do // and (term <> 1) do
    begin
     readln(FileAA, S);
     if (pos('TER',S)=1) then term.Add(FloatToStr(FAminoAs.Count));
     if (pos('MODEL',S)=1) then inc (model);
     if (Pos('ATOM',S)=1) and (Pos('CA',S)<>0)
      then
       begin
        AminoA := TAminoA.Create(Draw_frm);
        AminoA.LoadFromString(S);
        AddAminoA(AminoA);
       end;
     end;
     close(fileAA);

  // to Draw AminoAcids


   for I := 1 to Pred(FAminoAs.Count) do
    begin
      SeqRes :=TTSeqRes.Create(Draw_frm);
      if (term.IndexOf(FloatToStr(I+1))<> -1) and (I <> Pred(FAminoAs.Count))  then SeqRes.LoadFromLuft(I+1)
                                                                              else SeqRes.LoadFromLuft(I);
      if Visible then SeqRes.Parent := Draw_frm;
      if Visible then SeqRes.Paint;
      AddSeqRes(SeqRes);
    end;
  if Visible then
     for I := 0 to Pred(FAminoAs.Count) do
    AminoAs[I].TheParent := Draw_frm;
    GetCentroid (Midle_point);


end;

procedure TProteins.AddAminoA(aAminoA: TAminoA);
begin
  FAminoAs.Add(aAminoA);
end;

procedure TProteins.AddSeqRes(SeqRes:TTSeqRes);
begin
 FSeqRes.Add(SeqRes);
end;

function TProteins.GetAminoA(I: Integer): TAminoA;
begin
 If FaminoAS = nil then result:=nil
  else
     result :=  FAminoAs[I];
end;

function TProteins.AminoAPos(AminoA: TAminoA): Integer;
begin
  Result := FAminoAs.IndexOf(AminoA);
end;

function TProteins.MaxDistt:Real;
var
 I:integer;
 S, M:Real;

begin
 S:=0.0;
 for I := 0 to Pred(FAminoAs.Count) do
 begin
  M := TAminoA(FAminoAs[I]).DistOrigin;
  If  M > S then S:=M;
 end;
 Result := M;
end;

function TProteins.GetAminoAsCount: Integer;
begin
  Result := FAminoAs.Count;
end;


Procedure TProteins.GetCentroid (var centroidx:Centroid);
var
 I:integer;
begin
 with Centroidx do
  begin
   x :=0.0;
   y:=0.0;
   z:=0.0;
  end;

 for I := 0 to Pred(FAminoAs.Count) do
 begin
  with Centroidx do
   begin
    x:=x + TAminoA(FAminoAs[I]).x;
    y:=y + TAminoA(FAminoAs[I]).y;
    z:=z + TAminoA(FAminoAs[I]).z;
   end;
 end;
  with Centroidx do
   begin
    x:=x /FAminoAs.Count;
    y:=y /FAminoAs.Count;
    z:=z /FAminoAs.Count;
   end;

 for I := 0 to Pred(FAminoAs.Count) do
 begin
  with Centroidx do
   begin
    TAminoA(FAminoAs[I]).DistOrigin:= Sqrt((Sqr(x-TAminoA(FAminoAs[I]).x)+ Sqr(y-TAminoA(FAminoAs[I]).y)+Sqr(z-TAminoA(FAminoAs[I]).z)));
   end;
  end;

  MaxDist := MaxDistt;
end;

end.
 
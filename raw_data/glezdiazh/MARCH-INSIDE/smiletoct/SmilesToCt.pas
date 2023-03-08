unit SmilesToCt;

interface
 Uses SysUtils, Classes,Dialogs, StrUtils, CheckStrings, ConTabobj;
 Procedure SmiToCt (S:string; var TablaConect : TConTabobj; var ValFree :Integer);
 Procedure AddHid (var TablaConect : TConTabobj);
 function HowHB(var S: String):Integer;

 function Gformule(TablaConect : TConTabobj):String;

implementation

Procedure SmiToCt (S:string; var TablaConect : TConTabobj; var ValFree :Integer);
var
 aux, aux1, Aux2 :string;
 I,J,K,L, Vf, AtomCounter, lastAtom : Integer;
 Setbontolast, Dellast, atomset, Disc_Marker : boolean;
 Ring, Branch, Multibond, ExcludeB, Minus_set, Plus_set: TStringList;
begin
try
TablaConect.Destroy;
TablaConect := TConTabobj.Create;
 Ring := TStringList.Create;;
 Branch := TStringList.Create;
 Multibond := TStringList.Create;

 AtomCounter := 0;
 LastAtom := 0;
 Disc_Marker := False;
 Aux:= S;
 { To remove symmetry symbols }
 Aux := AnsiReplaceStr( Aux, '@', '');
 Aux := AnsiReplaceStr( Aux, '/', '');
 Aux:= AnsiReplaceStr( Aux, '\', '');
 Aux:= AnsiReplaceStr( Aux, '[CH]', 'C');
 //ShowMessage(Aux);
  if length (Aux) = 0 then
  begin
   ShowMessage('SMILES string contains no atoms');
   exit;
  end;

  if pos('.', aux) <> 0 then
   begin
    //ShowMessage('There is disconection...');
    ExcludeB  := TstringList.Create;
    Minus_set := TstringList.Create;
    Plus_set  := TstringList.Create;
    Disc_Marker := True;
   end;


  if pos(' ', Aux) <> 0 then
   begin
    ShowMessage('sorry, an error occurred while processing SMILES string: unexpected character.');
    exit;
   end;
   I := occurrenceX ('(', aux);
   J := occurrenceX (')', aux);
   if I<>J then
            begin
             ShowMessage('error () do not match');
             exit;
            end;

   I := occurrenceX ('[', aux);
   J := occurrenceX (']', aux);
   if I<>J then
            begin
             ShowMessage('error [] do not match');
             exit;
            end;
   I := occurrenceX ('%', aux);
   if I mod 2 <> 0 then
            begin
             ShowMessage('error % do not match');
             exit;
            end;

   I := 1;
 If Aux[length(Aux)] in ['~','-','#','=',':'] then
 begin
  ShowMessage('error: A bond was at end included');
  exit;
 end;
 lastatom := 0;

  While I <= Length (Aux) do
   begin
      atomset := True;
      Setbontolast := False;
      Dellast := False;
      if Aux[I] in ['~','-','=','#',':']  then
       begin
        atomset := False;
        Multibond.Add(IntToStr(AtomCounter -1)+Aux[I]+IntToStr(AtomCounter));
       end;

      if Aux[I] in [ '%', '0'..'9'] then
      begin
       atomset := false;
       if Aux[I] = '%' then
             begin
              aux1 := IntToStr(AtomCounter -1 );
              Aux2:= Aux[I+1] + Aux[i+2]+'*';
              I := I + 2;
             end
             else
              begin
               Aux1 := IntToStr(AtomCounter -1 );
               Aux2:= Aux[I]+'*';
              end;


       J := Ring.IndexOf(Aux2);
        if J = -1 then
         begin
          Ring.Add(Aux1);
          Ring.Add(aux2);
         end
         else
          begin
           TablaConect.AddBond(Ring.Strings[J-1]+'**'+IntToStr(AtomCounter-1));
           Ring.Delete(J-1);
           Ring.Delete(J-1);
         end;
       end;


      if Aux[I] in ['-','+'] then atomset := False;
      Case Aux[I] of
      '.':begin
           Atomset := False;
           ExcludeB.Add(IntToStr(LastAtom)+'**'+IntToStr(LastAtom+1));
          end;
       '(':
         begin
          Branch.Add(IntToStr(LastAtom));
          Atomset := False;
         end;

       '[': begin
              Aux1:='';
              Atomset := False;
              Inc(I);
              while Aux[I]<> ']' do
               begin
                if Aux[I] in ['A'..'Z', 'a'..'z', '0'..'9','-','+'] then Aux1:= Aux1+Aux[I];
                if (Aux[I] ='+') and Disc_Marker then Plus_set.Add(IntToStr(AtomCounter));
                if (Aux[I] ='-') and Disc_Marker then Minus_set.Add(IntToStr(AtomCounter));
                Inc(I);
               end;
              // Multiple Charge
              if (Pos(Aux1, 'Ca2+, Ca+2,Be2+, Be+2,Ba2+,Ba+2, Sn+2, Cd2+, Cd+2, Sn2+,Zn2+,Zn+2, Mg2+,Mg+2, Ti2+, Ti+2,Pb2+, Pb+2, Hg2+, Hg+2') <> 0) and  Disc_Marker then Plus_set.Add(IntToStr(AtomCounter));
              if (Pos(Aux1, 'Al3+,Al+3 ') <> 0 ) and Disc_Marker then Plus_set.Add(IntToStr(AtomCounter));
              if (Pos(Aux1, 'Al3+, Al+3') <> 0 ) and Disc_Marker then Plus_set.Add(IntToStr(AtomCounter));


              begin

              end;

              Vf := HowHB (Aux1);
              TablaConect.AddAtom(Aux1);
              TablaConect.AddBind(IntToStr(Vf));
              Inc(AtomCounter);
              TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
              LastAtom :=  AtomCounter-1;
            end;


       'B','b': if Aux[I+1] = 'r' then
                               begin
                                 //ShowMessage ('I found an  Br at '+ IntToStr(I));
                                 TablaConect.AddAtom('Br');
                                 TablaConect.AddBind('1');
                                 Inc(AtomCounter);
                                 Inc(I);
                                 Atomset := False;
                                 TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
                                 LastAtom :=  AtomCounter-1;
                               end
                              else
                               begin
                                 TablaConect.AddAtom('B');
                                 TablaConect.AddBind('3');
                                 Inc(AtomCounter);
                                 TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
                                 LastAtom :=  AtomCounter-1;
                               end;

       'C': begin
             if Aux[I+1] = 'l'   then

                               begin
                                 //ShowMessage ('I found an  Cl at '+ IntToStr(I));
                                 Inc(I);
                                 TablaConect.AddAtom('Cl');
                                 TablaConect.AddBind('1');
                                 Inc(AtomCounter);
                                 TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
                                 LastAtom :=  AtomCounter-1;
                                 Atomset := False;
                               end
                               else
                                begin
                                 TablaConect.AddAtom('C');
                                 TablaConect.AddBind('4');
                                 Atomset := False;
                                 Inc(AtomCounter);
                                 TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
                                 LastAtom :=  AtomCounter-1;
                                end;

             end;
       'c': begin
             TablaConect.AddAtom('C');
             TablaConect.AddBind('3');
             Atomset := False;
             Inc(AtomCounter);
             TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
             LastAtom :=  AtomCounter-1;
            end;
  'O', 'o': begin
             TablaConect.AddAtom('O');
             TablaConect.AddBind('2');
             Atomset := False;
             Inc(AtomCounter);
             TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
             LastAtom :=  AtomCounter-1;
            end;
   'S', 's': begin
             TablaConect.AddAtom('S');
             TablaConect.AddBind('2');
             Atomset := False;
             Inc(AtomCounter);
             TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
             LastAtom :=  AtomCounter-1;
            end;
   'N', 'n': begin
             TablaConect.AddAtom('N');
             if Aux[I]= 'N' then TablaConect.AddBind('3')
                             else TablaConect.AddBind('2');
             Atomset := False;
             Inc(AtomCounter);
             TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
             LastAtom :=  AtomCounter-1;
            end;

       ']': begin
              Atomset := False;
            end;
       ')': begin
              Atomset := False;
              if Aux[I+1] in ['=','#',':'] then
               begin
                MultiBond.Add(Branch.Strings[Branch.Count-1]+Aux[I+1]+IntToStr(AtomCounter));
                Inc(I);
               end;
              lastAtom := StrToInt (Branch.Strings[Branch.Count-1]);
              Branch.Delete(Branch.Count-1);
            end;

      end;

      if AtomSet then
                  begin
                   TablaConect.AddAtom(Aux[I]);
                   TablaConect.AddBind('0');
                   Inc(AtomCounter);
                   TablaConect.AddBond(IntToStr(LastAtom)+'**'+IntToStr(AtomCounter-1));
                   LastAtom :=  AtomCounter-1;
                  end;
      Inc (I);

   end;
 //branch.SaveToFile('d:/locura');
//  Solucion crear la lista de los numeros n-1 n
//eliminar los elementos close-1 close.
//Ring.clear;

 For I:= 0 to Pred(Ring.Count) do
       TablaConect.AddBond(Ring.Strings[I]);
//ELIMINAR EL ENLACE 0**0
   TablaConect.Enlaces.Delete(0);
   Aux2:= IntToStr(AtomCounter-1)+'**'+IntToStr(AtomCounter);
   I:= TablaConect.Enlaces.IndexOf(Aux2);
   if I <> -1 then TablaConect.Enlaces.Delete(I);
   TablaConect.SetSymbol;
//Corregir desconexiones
 if Disc_Marker then
 begin
  For  I:=0 to Pred(ExcludeB.Count) do
  begin
     J:= TablaConect.Enlaces.IndexOf(ExcludeB.Strings[I]);
     if J <> -1 then TablaConect.Enlaces.Delete(J);
     //restablecer vaelncia
  end;
 //Eliminar enlace no deseados
  If Minus_set.count=Plus_set.Count then
   for I:=0 to Pred(Minus_Set.count) do
       begin
          if StrToInt(Minus_Set.Strings[I]) < StrToInt(Plus_set.Strings[I]) then Aux2 := Minus_Set.Strings[I]+'**'+Plus_set.Strings[I]
                                                                            else Aux2 := Plus_set.Strings[I]+'**'+Minus_Set.Strings[I];
          J := TablaConect.Enlaces.IndexOf(Aux2);
          if J =-1 then TablaConect.AddBond(Aux2);
       end;


  ExcludeB.Free;
  Minus_set.Free;
  Plus_set.Free;

 end;

 // Check MultiBond and Bonding Free Valence...
   For I:= 0 to Pred(MultiBond.Count) do
   begin
    Aux:=MultiBond.Strings[I];
    Aux2:=' ';
    J:=1;
    while Aux[J] in ['0'..'9'] do
    begin
     Aux2 := Aux2+ Aux[J];
     inc(J);
    end;
    Case Aux[J] of
        '#': K :=2;
    '=',':': K := 1;
    '-','~': K:=0;
    end;
    TablaConect.ChangeV(StrToInt(Aux2),K,true);
    Delete(Aux,1,J);
    TablaConect.ChangeV(StrToInt(Aux),K,true);
   end;

   For I:=0 to Pred(TablaConect.Enlaces.Count) do
   begin
     Aux := TablaConect.Enlaces.Strings[I];
     Aux2:=' ';
     J :=1;
     while Aux[J] in ['0'..'9'] do
      begin
       Aux2 := Aux2+ Aux[J];
       inc(J);
      end;
    TablaConect.ChangeV(StrToInt(Aux2),1,true);
    Delete(Aux,1,J+1);
    TablaConect.ChangeV(StrToInt(Aux),1,true);
   end;
   J:=0;
   For I:=0 to Pred(TablaConect.valencias.count) do
     if   StrToInt(TablaConect.Valencias.Strings[I]) > 0 then J:= J+ StrToInt(TablaConect.Valencias.Strings[I]);
    ValFree := J;


  // TablaConect.WritetoFile('d:\listado.txt');
  // Multibond.SaveToFile('d:\enlaces multiple.txt');
finally
 Ring.Free;
 Branch.Free;
 MultiBond.Free;
end;


end;
Procedure AddHid (var TablaConect : TConTabobj);
Var
Aux, Aux1: TStringList;
I, counter: Integer;
begin
 Aux:= TStringList.Create;
 Aux1:= TStringList.Create;

 For I:=0 to Pred(TablaConect.valencias.count) do
     if   StrToInt(TablaConect.Valencias.Strings[I]) > 0 then
      begin
       Aux.Add(InttoStr(I)) ;
       Aux1.Add(TablaConect.Valencias.Strings[I]);
      end;
 For I:=0 to Pred(Aux.Count) do
 begin
  Counter := StrToInt(' '+Aux1.Strings[I]);
  while Counter > 0 do
  begin
   TablaConect.AddAtom('H');
   TablaConect.AddBind('0');
   TablaConect.ChangeV(StrToInt(Aux.Strings[I]),1,true);
   TablaConect.AddBond(Aux.Strings[I]+'**'+IntToStr(TablaConect.AtomsCount-1));
   Counter := Counter -1;
  end;
 end;
 Aux.Free;
 Aux1.Free;
end;

function HowHB(var S: String):Integer;
var
 I, vf : Integer;
 S1, S2: string;
 caseSp : Boolean;
              {if (Aux1 = 'O') or (Aux1 = 'S') then TablaConect.AddBind('2');
              if (Aux1 <> 'O') and (Aux1 <> 'N') then TablaConect.AddBind('0');}
begin
 Vf :=0;
 S2 :='';
 S1 :='';
 caseSp := false;
 if (S='H') or (S='h') then Result := 1;
 if (S='C')or (S='c') then Result := 4;
 if (S='H') or (S='h') then CaseSp:=true;
 //ShowMessage(S);
  s1 := copy(S,1,2) ;
 if not caseSp then
 begin
 if Pos('H', S) <> 0 then
  if (S1 ='Hg') or (S1= 'Rh') or (S1='He') or (S1= 'Hf') or (S1='Th') then
   begin
    Delete (S,1,2);
    s2:=S ;
    S:=S1;
   end
 else
    begin
      S1:='';
      while (S[1] <> 'H') and (length(S)<>0) do
      begin
       S1 := S1 +S[1];
       Delete(S,1,1);
      end;
      S2:=S;
      S:=S1;
     if S2[2] in ['0'..'9'] then Vf := StrToInt(S2[2])+2
                            else Vf := 1;
    end;
    if Pos('+',S)<> 0 then
                        begin
                         Delete(S, Pos('+', S),1);
                         vf :=0;
                        end;
    if Pos('-',S)<> 0 then
                        begin
                         Delete(S, Pos('-', S),1);
                         vf :=0;
                        end;

     if (S='C')or (S='c') then Result := 4;
     if (S='H') or (S='h') then Result := 1;
    end;



  result:=Vf;



end;
function Gformule(TablaConect : TConTabobj):String;
var
 S: string;
 SOrtList : TStringlist;
 I,J: Integer;
begin
  SortList := TstringList.Create;
  SortList.Sorted := true;
  For I:=0 to Pred(TablaConect.AtomsCount) do
  begin
   SortList.Add(TablaConect.Atoms[I]);
  end;
  S:='';
  For I:=0 to Pred(Sortlist.Count) do
  begin
     J := TablaConect.Occurrence[SortList.Strings[I]];
     if J <> 1 then S := S + SortList.Strings[I]+ IntToStr(J)
               else S := S + SortList.Strings[I];
  end;
  result := S;
  SortList.Free;
end;

end.

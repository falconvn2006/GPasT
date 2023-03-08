unit mytypes;
interface
const
  am=255;
  an=255;
  mx=1.0e+37;
  max=255;
  min=-1e30;
type

     Easy=array [1..256] of integer;
     {Added for B&B and unit9}

     my_int = integer;
     my_real = real;
     arr_1 = array [1..max] of my_int;
     arr_2 = array [1..max] of my_real;
     p_arr_1 = ^arr_1;
     p_arr_2 = ^arr_2;
     yarc = ^arc;
     arc = record
         vit:my_real;
         pos:1..am;
         pap:yarc;
         pat:yarc;
         tr:0..an;
     end;
     tran = record
          l:my_real;
          m:my_real
     end;
     place = record
           h:my_real
     end;
     ytran=^tran ;
     yplace=^place ;
     trns=array(.1..an.) of ytran;
     pls=array(.1..am.) of yplace;
     tar=array(.1..an.) of yarc;
     plar=array(.1..am.) of yarc;
     machine = record lambda, mu, u:real; end;
     machine_array = array[1..5] of machine;
     order=array[1..am] of integer;
     Procedure simple_numbers(n:my_int;x:p_arr_2);
implementation
     Procedure simple_numbers(n:my_int;x:p_arr_2);
     var
        j,t:my_int;
        k:my_real;
        b:boolean;
     begin
       if assigned(x) = true then
       begin
         x^[1] := 2.0;
         x^[2] := 3.0;
         x^[3] := 5.0;
         x^[4] := 7.0;
         j := 4;
         k := 8.0;
         b := true;
         while j < n do
         begin
           for t := 1 to j do
             if frac(k / x^[t]) = 0.0 then b := false;
           if b <> false then
           begin
             j := j + 1;
             x^[j] := k;
           end;
           k := k + 1;
           b := true;
         end;
         for t := 1 to n do
           x^[t] := sqrt(x^[t]);
       end;
     end;
end.

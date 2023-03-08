unit FPlin;
interface
 uses
 Classes,
 VarType;
 const piece_lin = 1;
 type
  my_arr = array[1..100] of TReal;

  a_function = object
   f_type,n_pieces:TInt;alphas,betas,borders:my_arr;
   constructor fread(ind:TIndex;var f:TStringList;var ok:TBool);
   function get(x:TReal; var ok:boolean):TReal;
   procedure Assign(var x:a_function);
   destructor done;
  end;
implementation
{******************************************************************************}
 destructor a_function.done;
 begin
 end;
{******************************************************************************}
 procedure a_function.Assign(var x:a_function);
 var
  i:TIndex;
 begin
  n_pieces:=x.n_pieces;
  for i:=1 to n_pieces do
  begin
   alphas[i]:=x.alphas[i];
   betas[i]:=x.betas[i];
   borders[i]:=x.borders[i];
  end;
 end;
{******************************************************************************}
 constructor a_function.fread(ind:TIndex;var f:TStringList;var ok:TBool);
 var c:char; cod,i:TInt; s,k:TString;
 begin
  s:=f.Strings[ind];
  while pos(' ',s)=1 do delete(s,1,1);

  if s[1]='p' then
  begin
   delete(s,1,1);
   if s[1]='l' then
   begin
    delete(s,1,1);
    f_type:=piece_lin;
   end;
  end;

  while pos(' ',s)<>0 do delete(s,pos(' ',s),1);

  if f_type=piece_lin then
  begin
   val(s,n_pieces,cod);
   for i:=1 to n_pieces do
   begin
    s:=f.Strings[ind+i];

    while pos(' ',s)=1 do delete(s,1,1);
    k:=copy(s,1,pos(' ',s)-1);delete(s,1,pos(' ',s));
    val(k,borders[i],cod);
    while pos(' ',s)=1 do delete(s,1,1);
    k:=copy(s,1,pos(' ',s)-1);delete(s,1,pos(' ',s));
    val(k,alphas[i],cod);
    while pos(' ',s)=1 do delete(s,1,1);
    val(s,betas[i],cod);

   end;
  end;

 end;
{******************************************************************************}
 function a_function.get(x:TReal; var ok:boolean):TReal;
 var i:integer;
 begin
  if borders[1]>x then
  begin
   get:=0;
   ok:=false;
   exit;
  end;

  ok:=true;
  i:=1;
  while (i<=n_pieces) and (borders[i]<=x) do inc(i);
  get:=alphas[i-1]+betas[i-1]*(x-borders[i-1]);
 end;
{******************************************************************************}
end.

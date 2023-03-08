unit ConTabobj;
interface
 uses Classes, SysUtils;
Type
 TAtomsList = TStringList;
 TBondList  = TStringList;
 TBindList  = TStringList;

 {Atom_type  C, N, O, P, S, Cl, Br}

 TConTabobj = class
    private
     Atomos   : TAtomsList;

     function GetAtomsCount: Integer;
     function GetAtom (I: Integer): String;
     function GetBondsCount: Integer;
     function GetBond (I : Integer): String;
     function GetBind (I : Integer): Integer;
     function How_Much_times (S: String):Integer;

    public
       Enlaces  : TbondList;
       Valencias: TBindList;
       constructor Create;
       destructor Destroy; override;
       procedure AddAtom(aAtom: String);
       procedure AddBond(aBond: String);
       Procedure AddBind (aBind : String);
       Procedure WritetoFile (FileName: String);
       Procedure SetSymbol;
       Procedure AddVal (BindN:Integer);
       Procedure ChangeV (I,Valencia: Integer; CMode: Boolean);
      public
        property Atoms[I: Integer]: String read GetAtom;
        property AtomsCount: Integer read GetAtomsCount;
        property Bonds[I: Integer]: String read GetBond;
        property BondsCount : Integer read GetBondsCount;
        Property Occurrence [S :string]: Integer read How_Much_times;
        property Binds[I: Integer]: Integer read GetBind;
    end;


implementation

  constructor TConTabobj.Create;
  begin
     inherited create;
      Atomos   := TAtomsList.Create;
      Enlaces  := TBondList.Create;
      Valencias:= TBindList.Create;
  end;

Destructor TConTabobj.Destroy;
 begin
  Atomos.Free;
  Enlaces.Free;
  Valencias.Free;
  inherited Destroy;
 end;

function TConTabObj.GetAtomsCount: Integer;
 begin
  Result := Atomos.Count;
 end;

function TConTabObj.GetBondsCount:Integer;
 begin
  Result := Enlaces.Count;
 end;

procedure TConTabObj.AddAtom(aAtom: String);
 begin
  Atomos.Add(aAtom);
 end;

procedure TConTabObj.AddBond(aBond: String);
 begin
  Enlaces.Add(aBond);
end;
Procedure TConTabObj.AddBind (aBind : String);
begin
 Valencias.Add(aBind);
end;

function TConTabObj.GetAtom (I: Integer): String;
 begin
  If Atomos = nil then result:=' '
   else
     result := Atomos.Strings[I];
 end;

function TConTabObj.GetBond (I : Integer): String;
 begin
  if Enlaces <> nil then result := ' '
   else
    result:= Enlaces.Strings[I];
 end;

function TConTabObj.How_Much_times (S: String):Integer;
var
 I,J : Integer;
begin
 J:=0;
 For I:= 0 to pred(Atomos.Count) do
  if Atomos[I]=S then Inc(J);
 result := J;
end;

Procedure TConTabObj.WritetoFile (FileName: String);
 var
  F: textfile;
  I: integer;
 begin
  Assignfile(F,FileName);
  rewrite(F);
  Writeln(F,'Atomnumber, Simbolo, valencias');
  for I:=0 to pred(Atomos.Count) do
   writeln(F,I,'-->',Atomos.Strings[I],'--',Valencias.Strings[I]);
  for I:=0 to pred(Enlaces.Count) do
   writeln(F,Enlaces.Strings[I]);
  closefile(f);
 end;

Procedure TConTabObj.SetSymbol;
 var
  I:integer;
  Aux:String;
 begin
 //Atomos.SaveToFile('D:\Locura');
  for I:=0 to Pred(Atomos.Count) do
  begin
   Aux := Atomos.Strings[I];
   if length(Aux) >= 3 then Delete(Aux,3,length(Aux));
   if length(Aux) <> 0 then
    begin
     Aux:=LowerCase (Aux);
     Aux [1]:= UpCase(Aux[1]);
     Atomos.Strings[I]:=Aux;
    end;
  end;
 end;
function TConTabObj.GetBind (I : Integer): Integer;
 begin
   If Valencias = nil then result:=0
   else
     result := StrToInt(valencias.Strings[I]);
 end;

Procedure TConTabObj.AddVal (BindN:Integer);
begin
 Valencias.Add(IntToStr(BindN));
end;
Procedure TConTabObj.ChangeV (I,Valencia: Integer; CMode: Boolean);
Var
 temp:Integer;
begin
 Case CMode of
  True:begin
        Temp := StrToInt(Valencias.Strings[I])-Valencia;
        Valencias.Strings[I] := IntToStr(Temp);
       end;
  False:Valencias.Strings[I] := IntToStr(Valencia);
 end;

end;

end.







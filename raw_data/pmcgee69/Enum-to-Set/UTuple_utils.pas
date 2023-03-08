unit UTuple_utils;

interface
uses System.SysUtils, System.StrUtils, System.Generics.Collections;

type

  Str = class
      class function map<T>  ( sa : TArray<string>; f : TFunc<string,T> ) : TList<T>;
  end;

  Tuple<T> = record
      a : T;
      b : T;
      constructor create(_a,_b : T);
  end;

  Tupcc    = Tuple<char>;

  function char_sort(const t:Tupcc) : Tupcc;

  function Str_range_to_tuple ( s : string ) : Tupcc;

  function Included ( c : char; range : TList<Tupcc> ) : boolean;



implementation

  constructor Tuple<T>.create(_a,_b : T);
      begin
            a := _a;
            b := _b;
      end;

  function char_sort(const t:Tupcc) : Tupcc;
      begin
            if t.a > t.b then  result := Tuple<char>.create( t.b, t.a)
                         else  result := t;
      end;


  class function Str.map<T> ( sa : TArray<string>; f : TFunc<string,T> ) : TList<T>;
      begin
            result := TList<T>.create();
            for var s in sa do result.add( f(s) );
      end;


  function Str_range_to_tuple ( s : string ) : Tupcc;
      begin
         s :=trim(s);

         if  length(s) = 1                    then exit ( result.create( s[1], #0  ) );

         if (length(s) = 2) and ( s[2]='-' )  then exit ( result.create( s[1], 'z' ) );
         if (length(s) = 2) and ( s[1]='-' )  then exit ( result.create( 'a' , s[1]) );

         if (length(s) <> 3) or (s[2] <> '-') then exit; {error}

         result := char_sort( Tuple<char>.create(s[1], s[3]) );
      end;


  function Included ( c : char; range : TList<Tupcc> ) : boolean;
      begin
            result := false;
            for var r in range do begin
                 if (r.a = c) and (r.b = #0) then exit ( true );

                 if (r.a<= c) and (r.b >= c) then exit ( true );
            end;
      end;

end.


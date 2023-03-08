unit CSN;

{$MODE Delphi}

interface

uses SysUtils, Classes, Math;

type TCSN = class
        private
                ocsn : TCSN;

                procedure calcPositionalProbability();

        public
                elementCount, combineCount: integer;
                combineTotal: int64;
                icombineTotal: integer;
                combineData: array of integer;
                elementData: array of boolean;
                positionalProbability: array of array of double;

                constructor Create(elemCount, combCount: integer);
                destructor Destroy();

                function Fatorial(n : integer): double;
                function Combine(n, r: double): double; overload;
                function Combine(n, r: integer): int64; overload;
                function mdc(a, b:double) : double;
                function GetFractionForm(a, b : double):string;

                function GetCSN(): double;
                function GetIntCSN(): integer;
                procedure SetCSN(csn: double); overload;
                procedure SetCSN(csn: integer); overload;
                procedure Sort();

                function GetCombination() : string;
                procedure SetCombination(s : string);

                function GetTheoreticalProbability(element, position : integer):double;
                function GetTheoreticalProbabilityFractionForm(element, position : integer):string;
                function GetTheoreticalProbabilityDelay(probability : double; delay : integer) : double;
                function GetTheoreticalProbabilityAdvance(probability : double; advance : integer) : double;

                function GetScore(ncsn:double) : integer; overload;
                function GetScore(ncsn:integer) : integer; overload;
                function chooseRandom() : integer;
                function choosePositionalRandom() : integer;
                function chooseParetto() : integer;

end;

implementation

        constructor TCSN.Create(elemCount, combCount: integer);
        var i : integer;
        begin

                elementCount := elemCount;
                combineCount := combCount;
                combineTotal := Combine(elementCount, combineCount);
                icombineTotal := combineTotal;

                SetLength(combineData, combCount+1);
                SetLength(elementData, elemCount+1);

                ocsn := nil;

    	        for i:=1 to elementCount do
    		        elementData[i] := false;

    	        for i:=1 to combineCount do
                begin
                    combineData[i] := i;
    		            elementData[i] := true;
                end;
                
                calcPositionalProbability();

        end;

        destructor TCSN.Destroy();
        begin
            if ocsn <> nil then
                ocsn.Free;
            inherited;
        end;

        function TCSN.Fatorial(n : integer): double;
        var f : double;
            i : integer;
        begin

            f := 1;
            if n > 0 then
                for i := 1 to n do
                    f := f * i;

            result := f;

        end;

        function TCSN.Combine(n, r: double): double;
        var f1, f2 : double;
            i, k, iir, iin : integer;
            s : double;
        begin
            s := 0;
            iir := trunc(r);
            iin := trunc(n);
            if n >= r then
            begin
                f2 := 1;
                if r > 0 then
                    for i := 1 to iir do
                        f2 := f2 * i;
                f1 := 1;
                k := (iin-iir+1);
                for i := k to iin do
                    f1 := f1 * i;
                s := f1 / f2;
            end;
            result := s;
        end;

        function TCSN.Combine(n, r: integer): int64;
        var f1, f2 : int64;
            i, k : integer;
            s : int64;
        begin
            s := 0;
            if n >= r then
            begin
                f2 := 1;
                if r > 0 then
                    for i := 1 to r do
                        f2 := f2 * i;
                f1 := 1;
                k := (n-r+1);
                for i := k to n do
                    f1 := f1 * i;
                s := f1 div f2;
            end;
            result := s;
        end;

        function TCSN.mdc(a, b:double) : double;
        var c : double;
        begin

             if (a > 1) and (b > 1) then
             begin
                  while a <> b do
                  begin
		       if a > b then
                       begin
                            if b > 0 then
                               c := int(a / b)
                            else
                                c := 1;
                            c := b * c;
                            if c >= a then
                               a := b
                            else
                                a := a - c;
                       end
                       else
                       begin
                            if a > 0 then
                               c := int(b / a)
                            else
                                c := 1;
                            c := a * c;
                            if c >= b then
                               b := a
                            else
			        b := b - c;
                       end;
                  end;
             end
             else
                 a := 1;

             result := a
        end;

        function TCSN.GetIntCSN(): integer;
        begin
                result := trunc(GetCSN());
        end;

        function TCSN.GetCSN(): double;
        var     x : double;
                k, i : integer;
        begin
            Sort;
            x := 0;
            for i := 1 to combineCount do
            begin
                 k := elementCount - combineData[combineCount-i+1];
                 if k >= i then
                    x := x + combine(k, i);
            end;
            result := combineTotal - x;
        end;

        procedure TCSN.SetCSN(csn: double);
        var     ncsn, x : double;
                k, i : integer;
        begin
    	      for i:=1 to combineCount do
    		        elementData[combineData[i]] := false;

            if csn > combineTotal then
               csn := combineTotal;
            ncsn := combineTotal - csn;
            k := elementCount + 1;
            for i := combineCount downto 1 do
            begin
                repeat
                    k := k - 1;
                    if k >= 1 then
                        x := combine(k, i)
                    else
                        x := 0;
                until x <= ncsn;
                ncsn := ncsn - x;
                combineData[combineCount-i+1] := elementCount - k;
            end;
            if ncsn >= 0 then
               combineData[combineCount] := combineData[combineCount] - trunc(ncsn);

    	      for i:=1 to combineCount do
    		        elementData[combineData[i]] := true;
        end;

        procedure TCSN.SetCSN(csn: integer);
        var     ncsn, x : integer;
                k, i : integer;
        begin
    	      for i:=1 to combineCount do
    		        elementData[combineData[i]] := false;

            if csn > icombineTotal then
               csn := icombineTotal;
            ncsn := icombineTotal - csn;
            k := elementCount + 1;
            for i := combineCount downto 1 do
            begin
                repeat
                    k := k - 1;
                    if k >= 1 then
                        x := combine(k, i)
                    else
                        x := 0;
                until x <= ncsn;
                ncsn := ncsn - x;
                combineData[combineCount-i+1] := elementCount - k;
            end;
            if ncsn >= 0 then
               combineData[combineCount] := combineData[combineCount] - ncsn;

    	      for i:=1 to combineCount do
    		        elementData[combineData[i]] := true;
        end;

        procedure TCSN.Sort;
        var     i, k, s : integer;
        begin
            for i := 1 to combineCount-1 do
                for k := i+1 to combineCount do
                begin
                    if combineData[i] > combineData[k] then
                    begin
                        s := combineData[i];
                        combineData[i] := combineData[k];
                        combineData[k] := s;
                    end;
                end;
        end;

        function TCSN.GetTheoreticalProbability(element, position : integer):double;
        begin
             result := Combine(element-1, position-1)*Combine(elementCount-element, combineCount-position)/combineTotal;
        end;

        function TCSN.GetFractionForm(a, b : double):string;
        var c : double;
            s : string;
        const million = 10000;
        begin
             c := mdc(a, b);
             if c > 0 then
             begin
                  a := a / c;
                  b := b / c;
                  if (a > million) or (b > million) then
                       s := '~' + GetFractionForm(int((a/b)*million), million)
                  else
                      s := FloatToStr(a) + '/' + FloatToStr(b)
             end
             else
                 s := '0';
             result := s;
        end;

        function TCSN.GetTheoreticalProbabilityFractionForm(element, position : integer):string;
        var a, b : double;
        begin
             a := Combine(element-1, position-1)*Combine(elementCount-element, combineCount-position);
             b := combineTotal;
             result := GetFractionForm(a, b);
        end;

        function TCSN.GetTheoreticalProbabilityDelay(probability : double; delay : integer) : double;
        begin
             result := power(1-probability, delay)*probability;
        end;

        function TCSN.GetTheoreticalProbabilityAdvance(probability : double; advance : integer) : double;
        begin
             result := power(probability, advance) * (1 - probability);
        end;

        function TCSN.GetCombination() : string;
        var s : string;
            i : integer;
        begin
             s := '';
             for i := 1 to combineCount do
             begin
                  s := s + IntToStr(combineData[i]);
                  if i <> combineCount then
                     s := s + ', ';
             end;
             result := s;
        end;

        procedure TCSN.SetCombination(s : string);
        var i, j, t, b : integer;
        begin
             i := 0;
             b := 0;
             t := length(s);
             for j := 1 to t do
             begin
                  case s[j] of
                  '0' : b := b * 10;
                  '1' : b := b * 10 + 1;
                  '2' : b := b * 10 + 2;
                  '3' : b := b * 10 + 3;
                  '4' : b := b * 10 + 4;
                  '5' : b := b * 10 + 5;
                  '6' : b := b * 10 + 6;
                  '7' : b := b * 10 + 7;
                  '8' : b := b * 10 + 8;
                  '9' : b := b * 10 + 9;
                  ';', ',' :
                      begin
                           if i < combineCount then
                           begin
                                if b <= elementCount then
                                begin
                                     i := i + 1;
                                     combineData[i] := b;
                                end;
                                b := 0;
                           end;
                      end;
                  end;
             end;
             if (b > 0) and (i < combineCount) then
             begin
                  i := i + 1;
                  combineData[i] := b;
             end;

    	      for i:=1 to elementCount do
    		        elementData[i] := false;
    	      for i:=1 to combineCount do
    		        elementData[combineData[i]] := true;
        end;

        function TCSN.GetScore(ncsn:double):integer;
        var
          score, i : integer;
        begin
            if ocsn = nil then
    	          ocsn := TCSN.Create(elementCount, combineCount);
    	      ocsn.SetCSN(ncsn);

    	      score := 0;
    	      for i:=1 to combineCount do
    		        if(elementData[ocsn.combineData[i]]) then
    				        score := score + 1;

    	      result := score;
        end;

        function TCSN.GetScore(ncsn:integer):integer;
        var
          score, i : integer;
        begin
            if ocsn = nil then
    	          ocsn := TCSN.Create(elementCount, combineCount);
    	      ocsn.SetCSN(ncsn);

    	      score := 0;
    	      for i:=1 to combineCount do
    		        if(elementData[ocsn.combineData[i]]) then
    				        score := score + 1;

    	      result := score;
        end;

        function TCSN.chooseRandom() : integer;
        var ncsn : integer;
        begin
            ncsn := random(icombineTotal)+1;
            SetCSN(ncsn);
            result := ncsn;
        end;

        function TCSN.choosePositionalRandom() : integer;
        var i, position, dezena, conta : integer;
            percr, perct : double;
        begin
            for i:=1 to combineCount do
    		        elementData[combineData[i]] := false;
            position := 1;
            while position <= combineCount do
            begin
                    dezena := 0;
                    conta := 0;
                    repeat
                            percr := (random(icombineTotal)*1.0)/icombineTotal;
                            perct := 0;
                            for i := 1 to elementCount do
                            begin
                                    perct := perct + positionalProbability[position, i];
                                    if(perct >= percr) then
                                    begin
                                            dezena := i;
                                            break;
                                    end;
                            end;
                            if(position > 1) then
                                    if(combineData[position-1] >= dezena) then
                                            dezena := 0;

                            if(conta > 500) then
                            begin
                                position := 0;
                                dezena := 1;
                            end;
                            conta := conta + 1;
                    until dezena <> 0;
                    combineData[position] := dezena;
                    position := position + 1;
            end;
            for i:=1 to combineCount do
    		        elementData[combineData[i]] := true;
            result := trunc(getCSN());
        end;

        function TCSN.chooseParetto() : integer;
        var i, dezena, anterior : integer;
        begin
            for i:=1 to combineCount do
    		        elementData[combineData[i]] := false;
            anterior := 0;
            dezena := 0;
            for i := 1 to combineCount do
            begin
                repeat
                    case i of
                    1: dezena := 1 + random(2);    // 01 a 02
                    2: dezena := 2 + random(3);    // 02 a 04
                    3: dezena := 3 + random(4);    // 03 a 06
                    4: dezena := 4 + random(5);    // 04 a 08
                    5: dezena := 6 + random(5);    // 06 a 10
                    6: dezena := 8 + random(5);    // 08 a 12
                    7: dezena := 9 + random(5);    // 09 a 13
                    8: dezena := 11 + random(5);   // 11 a 15
                    9: dezena := 13 + random(5);   // 13 a 17
                    10: dezena := 14 + random(5);  // 14 a 18
                    11: dezena := 16 + random(5);  // 16 a 20
                    12: dezena := 18 + random(5);  // 18 a 22
                    13: dezena := 20 + random(4);  // 20 a 23
                    14: dezena := 22 + random(3);  // 22 a 24
                    15: dezena := 24 + random(2);  // 24 a 25
                    end;
                until dezena > anterior;
                combineData[i] := dezena;
                anterior := dezena;
            end;
            for i:=1 to combineCount do
    		        elementData[combineData[i]] := true;
            result := trunc(getCSN());
        end;

        procedure TCSN.calcPositionalProbability();
        var position, i : integer;
        begin
            setlength(positionalProbability, combineCount+1, elementCount+1);
            for position := 1 to combineCount do
            begin
                for i := 1 to elementCount do
                        positionalProbability[position, i] := GetTheoreticalProbability(i, position); // chance de ser sorteada na posição
            end;
        end;

end.



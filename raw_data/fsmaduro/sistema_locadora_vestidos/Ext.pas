Unit Ext;

interface

uses SysUtils, Funcao;

function Extenso(Valor : Extended) : String;
function Extenso2(Valor : Extended) : String;
function Extenso3(Valor : Extended) : String;
function ExtensoEng(Valor : Extended; Moeda : Integer) : String;

implementation

function Extenso(Valor : Extended): String;
var Centavos, Centena, Milhar, Milhao, Bilhao, Texto : string;
const
  Unidades: array [1..9] of string = ('Um', 'Dois', 'Três', 'Quatro','Cinco','Seis', 'Sete', 'Oito','Nove');
  Dez : array [1..9] of string = ('Onze', 'Doze', 'Treze','Quatorze','Quinze', 'Dezesseis','Dezessete','Dezoito', 'Dezenove');
  Dezenas: array [1..9] of string = ('Dez', 'Vinte', 'Trinta','Quarenta','Cinquenta', 'Sessenta', 'Setenta', 'Oitenta','Noventa');
  Centenas: array [1..9] of string = ('Cento', 'Duzentos','Trezentos','Quatrocentos','Quinhentos', 'Seiscentos','Setecentos','Oitocentos', 'Novecentos');

  {function ifs( Expressao: Boolean; CasoVerdadeiro, CasoFalso: String): String;
  begin
    if Expressao
       then Result := CasoVerdadeiro
       else Result := CasoFalso;
  end; {}

  function MiniExtenso( Valor: ShortString ): string;
  var Unidade, Dezena, Centena : String;
  begin
    if (Valor[2] = '1') and (Valor[3] <> '0')
       then
         begin
           Unidade := Dez[StrToInt(Valor[3])];
           Dezena := '';
         end
       else
         begin
           if Valor[2] <> '0'
              then Dezena := Dezenas[StrToInt(Valor[2])];
           if Valor[3] <> '0'
              then unidade:= Unidades[StrToInt(Valor[3])];
         end;
    if (Valor[1] = '1') and (Unidade = '') and (Dezena = '')
       then Centena := 'cem'
       else
         if Valor[1] <> '0'
            then Centena := Centenas[StrToInt(Valor[1])]
            else Centena := '';
    Result := Centena + iif( (Centena <> '') and
             ((Dezena <> '') or (Unidade <> '')),  ' e ', '') + Dezena +
             iif( (Dezena <> '') and (Unidade <> ''), ' e ', '') + Unidade;
  end;

begin
if Valor = 0
   then
     begin
       Result := '';
       Exit;
     end;
  Texto := FormatFloat('000000000000.00', Valor);
  Centavos := MiniExtenso('0' + Copy(Texto,14,2));

Centena := MiniExtenso( Copy( Texto, 10, 3 ) );
Milhar := MiniExtenso( Copy( Texto, 7, 3 ) );
if Milhar <> ''
   then Milhar := Milhar + ' Mil';
Milhao := MiniExtenso( Copy( Texto, 4, 3 ) );
if Milhao <> ''
   then Milhao := Milhao +
                  iif( Copy( Texto, 4, 3 ) = '001', ' Milhão',' Milhões');
Bilhao := MiniExtenso( Copy( Texto, 1, 3 ) );
if Bilhao <> ''
   then Bilhao := Bilhao +
                  iif( Copy( Texto, 1, 3 ) = '001', ' Bilhão',' Bilhões');
if (Bilhao <> '') and (Milhao + Milhar + Centena = '')
   then Result := Bilhao + ' de Reais'
   else
     if (Milhao <> '') and (Milhar + Centena = '')
        then Result := Milhao + ' de Reais'
        else Result := Bilhao +
                       iif( (Bilhao <> '') and
                       (Milhao + Milhar + Centena <>''),
                        iif((Pos(' e ', Bilhao) > 0) or
                       (Pos( ' e ', Milhao + Milhar + Centena ) > 0)
                        , ', ', ' e '), '') + Milhao +
                        iif( (Milhao <> '') and
                        (Milhar + Centena <> ''), iif((Pos(' e ', Milhao) > 0)
                        or (Pos( ' e ', Milhar + Centena ) > 0 ),
                        ', ',' e '), '') + Milhar + iif( (Milhar <> '') and
                        (Centena <> ''),
                        iif(Pos( ' e ', Centena ) > 0, ', ', ' e '), '')+
                        Centena + iif( Int(Valor) = 1, ' Real', ' Reais' );


  if Centavos <> '' then
    Result := Result + ' e ' + Centavos + iif( Copy( Texto, 14, 2 )= '01', ' Centavo', ' Centavos' );

end;

function ExtensoEng(Valor : Extended; Moeda : Integer) : String;
var
Centavos,Centena,Milhar,Milhao,Bilhao,Texto : String;
Nome1,Nome2,Nome3 : String;
Const
Unidades: Array [1..9] of String = ('One','Two','Tree','Four','Five','Six','Seven','Eight','Nine');
Dez : Array [1..9] of String = ('Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Nineteen');
Dezenas : Array [1..9] of String = ('Ten','Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety');
Centenas : Array [1..9] of String = ('One Hundred','Two Hundred','Three Hundred','Four Hundred','Five Hundred','Six Hundred','Seven Hundred','Eight Hundred','Nine Hundred');

{function ifs( Expressao : Boolean; CasoVerdadeiro, CasoFalso : String): String;
begin
  if Expressao
     then Result := CasoVerdadeiro
     else Result := CasoFalso;
end; {}

function MiniExtenso( Valor: ShortString ): String;
var Unidade,Dezena,Centena : String;
begin
  if (Valor[2] = '1') and (Valor[3] <> '0') then
  begin
    Unidade := Dez[StrToInt(Valor[3])];
    Dezena := '';
  end
  else
  begin
    if Valor[2] <> '0' then
      Dezena := Dezenas[StrToInt(Valor[2])];
    if Valor[3] <> '0' then
      Unidade := Unidades[StrToInt(Valor[3])];
  end;
  if (Valor[1] = '1') and (Unidade = '') and (Dezena = '') then
    Centena := 'One Hundred'
  else if Valor[1] <> '0' then
    Centena := Centenas[StrToInt(Valor[1])]
  else Centena := '';
  Result := Centena + iif( (Centena <> '') and
            ((Dezena <> '') or (Unidade <> '')),Nome3,'') + Dezena +
            iif((Dezena <> '') and (Unidade <> ''),Nome3,'') + Unidade;
end;

begin
  if Valor = 0 then
  begin
    Result := '';
    Exit;
  end;

  if Moeda = 0 then
  begin
    Nome1 := ' de Reais';
    Nome2 := ' Real';
    Nome3 := ' e ';
  end
  else
  begin
    Nome1 := ' Dollars';
    Nome2 := ' Dollar';
    Nome3 := ' and ';
  end;

  Texto := FormatFloat('000000000000.00',Valor);
  Centavos := MiniExtenso('0' + Copy(Texto,14,2));
  Centena := MiniExtenso(Copy(Texto,10,3));
  Milhar := MiniExtenso(Copy(Texto,7,3));

  if Milhar <> '' then
    Milhar := Milhar + ' Thousand';

  Milhao := MiniExtenso(Copy(Texto,4,3));

  if Milhao <> '' then
    Milhao := Milhao +
              iif(Copy(Texto,4,3) = '001',' Million',' Millions');

  Bilhao := MiniExtenso(Copy(Texto,1,3));

  if Bilhao <> '' then
    Bilhao := Bilhao +
              iif( Copy( Texto, 1, 3 ) = '001',' Billion',' Billions');

  if (Bilhao <> '') and (Milhao + Milhar + Centena = '') then
    Result := Bilhao + Nome1
  else
    if (Milhao <> '') and (Milhar + Centena = '') then
      Result := Milhao + Nome1
    else Result := Bilhao +
                   iif ((Bilhao <> '') and (Milhao + Milhar + Centena <>''),
                   iif((Pos(Nome3, Bilhao) > 0) or
                   (Pos(Nome3,Milhao + Milhar + Centena) > 0),', ',Nome3),'') + Milhao +
                   iif((Milhao <> '') and (Milhar + Centena <> ''), iif((Pos(Nome3, Milhao) > 0)
                   or (Pos(Nome3,Milhar + Centena ) > 0 ),', ',Nome3),'') + Milhar +
                   iif((Milhar <> '') and (Centena <> ''),
                   iif(Pos(Nome3, Centena ) > 0,', ',Nome3),'') +
                   Centena + iif( Int(Valor) = 1, Nome2, Nome1 );

if Centavos <> '' then Result := Result + Nome3 + Centavos +
                  iif(Copy(Texto,14,2)= '01',' Cent',' Cents');

end; {}

function Extenso2(Valor : Extended): String;
var Centavos, Centena, Milhar, Milhao, Bilhao, Texto : string;
const Unidades: array [1..9] of string = ('Um','Dois','Três','Quatro','Cinco','Seis','Sete','Oito','Nove');
      Dez :     array [1..9] of string = ('Onze','Doze','Treze','Quatorze','Quinze','Dezesseis','Dezessete','Dezoito','Dezenove');
      Dezenas:  array [1..9] of string = ('Dez','Vinte','Trinta','Quarenta','Cinquenta','Sessenta','Setenta', 'Oitenta','Noventa');
      Centenas: array [1..9] of string = ('Cento','Duzentos','Trezentos','Quatrocentos','Quinhentos','Seiscentos','Setecentos','Oitocentos','Novecentos');

function MiniExtenso(Valor : ShortString): string;
var Unidade, Dezena, Centena : String;
begin
  if (Valor[2] = '1') and (Valor[3] <> '0') then
  begin
    Unidade := Dez[StrToInt(Valor[3])];
    Dezena := '';
  end
  else
  begin
    if Valor[2] <> '0' then
      Dezena := Dezenas[StrToInt(Valor[2])];
    if Valor[3] <> '0' then
      Unidade := Unidades[StrToInt(Valor[3])];
  end;
  if (Valor[1] = '1') and (Unidade = '') and (Dezena = '') then
    Centena := 'cem'
  else if Valor[1] <> '0' then
    Centena := Centenas[StrToInt(Valor[1])]
  else
    Centena := '';
  Result := Centena + iif((Centena <> '') and ((Dezena <> '') or (Unidade <> '')),' e ', '') +
            Dezena + iif((Dezena <> '') and (Unidade <> ''),' e ','') + Unidade;
end;

begin
  if Valor = 0 then
  begin
    Result := '';
    Exit;
  end;

  Texto := FormatFloat('000000000000.00', Valor);
  Centavos := MiniExtenso('0' + Copy(Texto,14,2));
  Centena := MiniExtenso(Copy(Texto,10,3));
  Milhar := MiniExtenso(Copy(Texto,7,3));
  if Milhar <> '' then
    Milhar := Milhar + ' Mil';
  Milhao := MiniExtenso(Copy(Texto,4,3));
  if Milhao <> '' then
    Milhao := Milhao + iif(Copy(Texto,4,3) = '001','Milhão','Milhões');
  Bilhao := MiniExtenso(Copy(Texto,1,3));
  if Bilhao <> '' then
    Bilhao := Bilhao + iif(Copy(Texto,1,3) = '001','Bilhão','Bilhões');
  if (Bilhao <> '') and (Milhao + Milhar + Centena = '') then
    Result := Bilhao + ' de Reais'
  else if (Milhao <> '') and (Milhar + Centena = '') then
    Result := Milhao + ' de Reais'
  else
    Result := Bilhao + iif((Bilhao <> '') and (Milhao + Milhar + Centena <>''),
                       iif((Pos(' e ',Bilhao) > 0) or (Pos(' e ',Milhao + Milhar + Centena ) > 0),', ',' e '),'') +
              Milhao + iif((Milhao <> '') and (Milhar + Centena <> ''),
                       iif((Pos(' e ', Milhao) > 0) or (Pos(' e ',Milhar + Centena ) > 0 ),', ',' e '),'') +
              Milhar + iif((Milhar <> '') and (Centena <> ''),
                       iif(Pos(' e ', Centena ) > 0,', ', ' e '), '') +
              Centena;

  if Centavos <> '' then
    Result := Result + ' e ' + Centavos +
              iif( Copy( Texto, 14, 2 )= '01',' Centavo',' Centavos');
end;

function Extenso3(Valor : Extended): String;
var Numero : Integer; Texto, Aux : String;
const
  Unidades: array [1..9] of string = ('Um', 'Dois', 'Três', 'Quatro', 'Cinco','Seis', 'Sete', 'Oito', 'Nove');
  Dez : array [0..9] of string = ('Dez', 'Onze', 'Doze', 'Treze', 'Quatorze', 'Quinze', 'Dezesseis', 'Dezessete', 'Dezoito', 'Dezenove');
  Dezenas: array [2..9] of string = ('Vinte', 'Trinta', 'Quarenta', 'Cinquenta', 'Sessenta', 'Setenta', 'Oitenta', 'Noventa');
  Centenas: array [1..9] of string = ('Cento', 'Duzentos', 'Trezentos', 'Quatrocentos', 'Quinhentos', 'Seiscentos', 'Setecentos', 'Oitocentos', 'Novecentos');

  function MiniExtenso(Valor: String) : String;
  begin
    Result := '';

    if Valor[1] <> '0' then
    begin
      if (Valor[1] = '1') and (Valor[2] = '0') and (Valor[3] = '0') then
        Result := ' Cem'
      else
        Result := ' ' + Centenas[StrToInt(Valor[1])];
    end;

    if Valor[2] = '1' then
      Result := iif(Result <> '', Result + ' e ', '') + Dez[StrToInt(Valor[3])]
    else if Valor[2] <> '0' then
      Result := iif(Result <> '', Result + ' e ', '') + Dezenas[StrToInt(Valor[2])];

    if (Valor[2] <> '1') and (Valor[3] <> '0') then
      Result := iif(Result <> '', Result + ' e ', '') + Unidades[StrToInt(Valor[3])];
  end;

begin
  if Valor = 0 then
  begin
    Result := '';
    Exit;
  end
  else
  begin
    Result := '';
                       // 1  4  7  10
    Texto := FormatFloat('000000000000.00', Valor);

    // Bilhão
    Aux := Copy(Texto, 1, 3);
    if StrToInt(Aux) > 0 then
    begin
      Result := MiniExtenso(Aux);

      if Aux = '001' then
        Result := Result + 'Bilhão'
      else
        Result := Result + 'Bilhões';
    end;

    // Milhão
    Aux := Copy(Texto, 4, 3);
    if StrToInt(Aux) > 0 then
    begin
      Result := Result + MiniExtenso(Aux);

      if Aux = '001' then
        Result := Result + iif(Result <> '', ' ', '') + 'Milhão'
      else
        Result := Result + iif(Result <> '', ' ', '') + 'Milhões';
    end;

    // Milhar
    Aux := Copy(Texto, 7, 3);
    if StrToInt(Aux) > 0 then
    begin
      Result := Result + MiniExtenso(Aux);

      Result := Result + iif(Result <> '', ' ', '') + 'Mil'
    end;

    // Unidade
    Aux := Copy(Texto, 10, 3);
    if StrToInt(Aux) > 0 then
    begin
      Result := Result + MiniExtenso(Aux);
    end;

    Aux := Copy(Texto, 1, 12);

    if StrToInt(Aux) > 0 then
    begin
      if StrToInt(Aux) > 1 then
        Result := Result + ' Reais'
      else
        Result := Result + ' Real';
    end;

    // Centavos
    Aux := MiniExtenso('0' + Copy(Texto, 14, 2));

    if Aux <> '' then
    begin
      if Copy(Texto, 14, 2) = '01' then
        Result := Result + iif(Result <> '', ' e ', '') + Aux + ' Centavo'
      else
        Result := Result + iif(Result <> '', ' e ', '') + Aux + ' Centavos';
    end;
  end;
end;

end.


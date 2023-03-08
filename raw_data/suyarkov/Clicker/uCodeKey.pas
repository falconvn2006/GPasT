unit uCodeKey;

interface

function InVK(pKey: char) : word;
implementation

function InVK(pKey: char) : word;
var vCode : word;
begin
  begin
    case pKey of
    'À', 'à':  vCode := 70;
    'Á', 'á':  vCode := 188;
    'Â', 'â':  vCode := 68;
    'Ã', 'ã':  vCode := 85;
    'Ä', 'ä':  vCode := 76;
    'Å', 'å':  vCode := 84;
    'Æ', 'æ':  vCode := 186;
    'Ç', 'ç':  vCode := 80;
    'È', 'è':  vCode := 66;
    'É', 'é':  vCode := 81;
    'Ê', 'ê':  vCode := 82;
    'Ë', 'ë':  vCode := 75;
    'Ì', 'ì':  vCode := 86;
    'Í', 'í':  vCode := 89;
    'Î', 'î':  vCode := 74;
    'Ï', 'ï':  vCode := 71;
    'Ð', 'ð':  vCode := 72;
    'Ñ', 'ñ':  vCode := 67;
    'Ò', 'ò':  vCode := 78;
    'Ó', 'ó':  vCode := 69;
    'Ô', 'ô':  vCode := 65;
    'Õ', 'õ':  vCode := 219;
    'Ö', 'ö':  vCode := 87;
    '×', '÷':  vCode := 80;
    'Ø', 'ø':  vCode := 73;
    'Ù', 'ù':  vCode := 79;
    'Ú', 'ú':  vCode := 221;
    'Û', 'û':  vCode := 83;
    'Ü', 'ü':  vCode := 77;
    'Ý', 'ý':  vCode := 222;
    'Þ', 'þ':  vCode := 190;
    'ß', 'ÿ':  vCode := 90;
    end;

  end;
   Result := vCode;
end;

end.

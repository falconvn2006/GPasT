unit Fnc_Utils;

interface

uses
{(*}
  uMessage,
  Vcl.Controls,
  System.Classes, System.SysUtils, System.TypInfo;
{*)}

type
  TGenerico = 0..255;

  TConvert<T: record> = class
  private
  public
    class procedure PopulateListEnum(AList: TStrings);
    class function StrToEnum(const AStr: string): T;
    class function EnumToStr(const eEnum: T): string;
  end;

procedure CCShowMessage(Titulo, Menssagem: string; Tipo: tpMessage);

function CCShowQuestion(Titulo, Menssagem: string): Boolean;

implementation

function CCShowQuestion(Titulo, Menssagem: string): Boolean;
var
  pFormMessage: TFrmShowMessage;
begin
  pFormMessage := TFrmShowMessage.Create(nil);
  try
    pFormMessage.FTituloMessage := Titulo;
    pFormMessage.FMessage := Menssagem;
    pFormMessage.FTipoMessage := tpMessage.tQuestion;

    if pFormMessage.ShowModal = mrYes then
      Result := True
    else
      Result := False;
  finally
    pFormMessage.Free;
  end;
end;

procedure CCShowMessage(Titulo, Menssagem: string; Tipo: tpMessage);
var
  pFormMessage: TFrmShowMessage;
begin
  pFormMessage := TFrmShowMessage.Create(nil);
  try
    pFormMessage.FTituloMessage := Titulo;
    pFormMessage.FMessage := Menssagem;
    pFormMessage.FTipoMessage := Tipo;

    pFormMessage.ShowModal;
  finally
    pFormMessage.Free;
  end;
end;

{ TConvert<T> }

class function TConvert<T>.EnumToStr(const eEnum: T): string;
var
  P: PInteger;
  Num: integer;
begin
  try
    P := @eEnum;
    Num := integer(TGenerico((P^)));
    Result := GetEnumName(TypeInfo(T), Num);
  except
    raise EConvertError.Create('O Parâmetro passado não corresponde a ' + sLineBreak + 'um inteiro Ou a um Tipo Enumerado');
  end;
end;

class procedure TConvert<T>.PopulateListEnum(AList: TStrings);
var
  i: integer;
  StrTexto: string;
  Enum: Integer;
begin
  i := 0;
  try
    repeat
      StrTexto := trim(GetEnumName(TypeInfo(T), i));
      Enum := GetEnumValue(TypeInfo(T), StrTexto);
      AList.Add(StrTexto);
      inc(i);
    until Enum < 0;
    AList.Delete(pred(AList.Count));
  except
    raise EConvertError.Create('O Parâmetro passado não corresponde a um Tipo ENUM');
  end;
end;

class function TConvert<T>.StrToEnum(const AStr: string): T;
var
  P: ^T;
  num: Integer;
begin
  try
    num := GetEnumValue(TypeInfo(T), AStr);
    if num = -1 then
      abort;
    P := @num;
    result := P^;
  except
    raise EConvertError.Create('O Parâmetro "' + AStr + '" passado não ' + sLineBreak + ' corresponde a um Tipo Enumerado');
  end;
end;

end.


unit RegexUtils;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
      Generics.Collections, Math, System.RegularExpressions, System.RegularExpressionsCore;

function IsValidRegex(str: string): boolean;
function GetMatches(sPattern: string;
                     sInput: String;
                     out Success: boolean;
                     var ErrorMessage: string;
                     opts: TRegexOptions = [];
                     inputStart: Integer = 0;
                     inputLength: Integer = 0): TMatchCollection;

type
  TMyTextRange = class
  public
      Start: Integer;
      Length: Integer;
  end;

implementation

function IsValidRegex(str: string): boolean;
var
  RegEx: TRegEx;
begin
  try
     Regex := TRegex.Create(str);
     result:=true;
  except
     result:=false;
  end;
end;

function GetMatches(sPattern: string;
                     sInput: String;
                     out Success: boolean;
                     var ErrorMessage: string;
                     opts: TRegexOptions = [];
                     inputStart: Integer = 0;
                     inputLength: Integer = 0): TMatchCollection;
var
  rx: TRegEx;
  Matches: TMatchCollection;
  //m: TMatch;
begin

  try
    if(not IsValidRegex(sPattern)) then begin
      Success := false;
      ErrorMessage := 'Regex is invalid';
      result := Matches;
      exit;
    end;

    Include(opts, roCompiled);
    rx := TRegEx.Create(sPattern, opts);

    if (inputStart < 1) then
      inputStart := 0;  //start of text
    if(inputLength < 1) then
      inputLength := 0;// all text after inputStart


    if (inputStart > 0) or (inputLength > 0) then begin

      if(inputStart+1 >= Length(sInput)) then begin
         //Start is after end of string
         Success:=false;
         ErrorMessage := 'Start is after end of string';
         result := Matches; //soft fail
         exit;
      end;

      if(inputStart + inputLength > Length(sInput)) then begin
         Success := false;
         ErrorMessage := 'Specified length is beyond end of string';
         result := Matches; //soft fail
         exit;
      end;

      sInput := sInput.Substring(inputStart, inputLength);
    end;

    Matches := rx.Matches(sInput);
    Success := true;
    result := Matches;
  except
    on E : Exception do begin
      ErrorMessage := E.Message;
      Success := false;
     result := Matches;
    end;
  end;

end;

end.

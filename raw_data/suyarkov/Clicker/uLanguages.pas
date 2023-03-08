unit uLanguages;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  System.JSON, System.Net.HTTPClient,
  System.NetEncoding, Vcl.Dialogs,
  Character;

type
  TLanguage = record
    Id: integer; // íîìåð ïî ïîðÿäêó
    LnCode: string;
    NameForEnter: string;
    NameForRead: string;
    Activ: integer;
  end;

type
  TListLanguages = Array [1 .. 1000] of TLanguage;

function InitListLanguages(): TListLanguages; // èíèöèàëèçàöèÿ èç ôàéëà
function InitListLanguagesStatic(): TListLanguages;

function GetLnCode(pNameRead: String): String;
function GetLnCodeFromList(pNameRead: String;
  pListLanguages: TListLanguages): String;
function GetNextLnCodeForEnter(pLastLnCode: String;
  pListLanguages: TListLanguages): String;
function GetNameEnterOnLnCodeFromList(pLnCode: String;
  pListLanguages: TListLanguages): String;

implementation

function InitListLanguages(): TListLanguages;
const
  cNameFile: string = 'Languages.lng';
var
  vList: TListLanguages;
  i: integer;
  vPath: string;
  vFullNameFile: string;
  FileText: TStringList; // Tstrings;
  vStr: string;
  vPos: integer;
begin
  vPath := GetCurrentDir();
  vFullNameFile := vPath + '/' + cNameFile;
  // Òåïåðü ïðîâåðÿåì ñóùåñòâóåò ëè ôàéë
  if FileExists(vFullNameFile) then
  begin
    FileText := TStringList.Create;
    FileText.LoadFromFile(vFullNameFile);
    if FileText.Count > 0 then
    begin
      for i := 0 to FileText.Count - 1 do
      begin
        vStr := FileText.Strings[i];
        vPos := Pos(' ', vStr);
        vList[i + 1].LnCode := Copy(vStr, 1, vPos - 1);
        vStr := Copy(vStr, vPos + 1);
        vPos := Pos('.', vStr);
        vList[i + 1].NameForEnter := ToUpper(Copy(vStr, 1, vPos - 1));
        vList[i + 1].NameForRead := vList[i + 1].NameForEnter;
        vList[i + 1].Activ := StrToInt(Copy(vStr, vPos + 1, vPos + 1));
      end;
      result := vList;
    end;
  end
  else
    showmessage(vFullNameFile + ' íå ñóùåñòâóåò ôàéëà ñ ÿçûêàìè');

end;

function InitListLanguagesStatic(): TListLanguages;
var
  vList: TListLanguages;
  i: integer;
begin
  i := 1;
  vList[i].Id := i;
  vList[i].LnCode := 'az';
  vList[i].NameForEnter := 'ÀÇÅÐÁÀÉÄÆÀÍÑÊÈÉ';
  vList[i].NameForRead := 'Àçåðáàéäæàíñêèé';

  i := 2;
  vList[i].Id := i;
  vList[i].LnCode := 'ar';
  vList[i].NameForEnter := 'ÀÐÀÁÑÊÈÉ';
  vList[i].NameForRead := 'Àðàáñêèé';

  i := 3;
  vList[i].Id := i;
  vList[i].LnCode := 'hy';
  vList[i].NameForEnter := 'ÀÐÌßÍÑÊÈÉ';
  vList[i].NameForRead := 'Àðìÿíñêèé';

  i := 4;
  vList[i].Id := i;
  vList[i].LnCode := 'be';
  vList[i].NameForEnter := 'ÁÅËÎÐÓÑÑÊÈÉ';
  vList[i].NameForRead := 'Áåëîðóññêèé';

  i := 5;
  vList[i].Id := i;
  vList[i].LnCode := 'bn';
  vList[i].NameForEnter := 'ÁÅÍÃÀËÜÑÊÈÉ';
  vList[i].NameForRead := 'Áåíãàëüñêèé';

  i := 6;
  vList[i].Id := i;
  vList[i].LnCode := 'bg';
  vList[i].NameForEnter := 'ÁÎËÃÀÐÑÊÈÉ';
  vList[i].NameForRead := 'Áîëãàðñêèé';

  i := 7;
  vList[i].Id := i;
  vList[i].LnCode := 'bs';
  vList[i].NameForEnter := 'ÁÎÑÍÈÉÑÊÈÉ';
  vList[i].NameForRead := 'Áîñíèéñêèé';

  i := 8;
  vList[i].Id := i;
  vList[i].LnCode := 'hu';
  vList[i].NameForEnter := 'ÂÅÍÃÅÐÑÊÈÉ';
  vList[i].NameForRead := 'Âåíãåðñêèé';

  i := 9;
  vList[i].Id := i;
  vList[i].LnCode := 'el';
  vList[i].NameForEnter := 'ÃÐÅ×ÅÑÊÈÉ';
  vList[i].NameForRead := 'Ãðå÷åñêèé';

  i := 10;
  vList[i].Id := i;
  vList[i].LnCode := 'ka';
  vList[i].NameForEnter := 'ÃÐÓÇÈÍÑÊÈÉ';
  vList[i].NameForRead := 'Ãðóçèíñêèé';

  i := 11;
  vList[i].Id := i;
  vList[i].LnCode := 'da';
  vList[i].NameForEnter := 'ÄÀÒÑÊÈÉ';
  vList[i].NameForRead := 'Äàòñêèé';

  i := 12;
  vList[i].Id := i;
  vList[i].LnCode := 'iw';
  vList[i].NameForEnter := 'ÈÂÐÈÒ';
  vList[i].NameForRead := 'Èâðèò';

  i := 13;
  vList[i].Id := i;
  vList[i].LnCode := 'ga';
  vList[i].NameForEnter := 'ÈÐËÀÍÄÑÊÈÉ';
  vList[i].NameForRead := 'Èðëàíäñêèé';

  i := 14;
  vList[i].Id := i;
  vList[i].LnCode := 'is';
  vList[i].NameForEnter := 'ÈÑËÀÍÄÑÊÈÉ';
  vList[i].NameForRead := 'Èñëàíäñêèé';

  i := 15;
  vList[i].Id := i;
  vList[i].LnCode := 'es';
  vList[i].NameForEnter := 'ÈÑÏÀÍÑÊÈÉ';
  vList[i].NameForRead := 'Èñïàíñêèé';

  i := 16;
  vList[i].Id := i;
  vList[i].LnCode := 'it';
  vList[i].NameForEnter := 'ÈÒÀËÜßÍÑÊÈÉ';
  vList[i].NameForRead := 'Èòàëüÿíñêèé';

  i := 17;
  vList[i].Id := i;
  vList[i].LnCode := 'kk';
  vList[i].NameForEnter := 'ÊÀÇÀÕÑÊÈÉ';
  vList[i].NameForRead := 'Êàçàõñêèé';

  i := 18;
  vList[i].Id := i;
  vList[i].LnCode := 'ky';
  vList[i].NameForEnter := 'ÊÈÐÃÈÇÑÊÈÉ';
  vList[i].NameForRead := 'Êèðãèçñêèé';

  i := 19;
  vList[i].Id := i;
  vList[i].LnCode := 'zh-CN';
  vList[i].NameForEnter := 'ÊÈÒÀÉÑÊÈÉ';
  vList[i].NameForRead := 'Êèòàéñêèé';

  i := 20;
  vList[i].Id := i;
  vList[i].LnCode := 'ko';
  vList[i].NameForEnter := 'ÊÎÐÅÉÑÊÈÉ';
  vList[i].NameForRead := 'Êîðåéñêèé';

  i := 21;
  vList[i].Id := i;
  vList[i].LnCode := 'la';
  vList[i].NameForEnter := 'ËÀÒÈÍÑÊÈÉ';
  vList[i].NameForRead := 'Ëàòèíñêèé';

  i := 22;
  vList[i].Id := i;
  vList[i].LnCode := 'lv';
  vList[i].NameForEnter := 'ËÀÒÛØÑÊÈÉ';
  vList[i].NameForRead := 'Ëàòûøñêèé';

  i := 23;
  vList[i].Id := i;
  vList[i].LnCode := 'lt';
  vList[i].NameForEnter := 'ËÈÒÎÂÑÊÈÉ';
  vList[i].NameForRead := 'Ëèòîâñêèé';

  i := 24;
  vList[i].Id := i;
  vList[i].LnCode := 'lb';
  vList[i].NameForEnter := 'ËÞÊÑÅÌÁÓÐÑÊÈÉ';
  vList[i].NameForRead := 'Ëþêñåìáóðñêèé';

  i := 25;
  vList[i].Id := i;
  vList[i].LnCode := 'ms';
  vList[i].NameForEnter := 'ÌÀËÀÉÑÊÈÉ';
  vList[i].NameForRead := 'Ìàëàéñêèé';

  i := 26;
  vList[i].Id := i;
  vList[i].LnCode := 'mn';
  vList[i].NameForEnter := 'ÌÎÍÃÎËÜÑÊÈÉ';
  vList[i].NameForRead := 'Ìîíãîëüñêèé';

  i := 27;
  vList[i].Id := i;
  vList[i].LnCode := 'de';
  vList[i].NameForEnter := 'ÍÅÌÅÖÊÈÉ';
  vList[i].NameForRead := 'Íåìåöêèé';

  i := 28;
  vList[i].Id := i;
  vList[i].LnCode := 'nl';
  vList[i].NameForEnter := 'ÍÈÄÅÐËÀÍÄÑÊÈÉ';
  vList[i].NameForRead := 'Íèäåðëàíäñêèé';

  i := 29;
  vList[i].Id := i;
  vList[i].LnCode := 'no';
  vList[i].NameForEnter := 'ÍÎÐÂÅÆÑÊÈÉ';
  vList[i].NameForRead := 'Íîðâåæñêèé';

  i := 30;
  vList[i].Id := i;
  vList[i].LnCode := 'pl';
  vList[i].NameForEnter := 'ÏÎËÜÑÊÈÉ';
  vList[i].NameForRead := 'Ïîëüñêèé';

  i := 31;
  vList[i].Id := i;
  vList[i].LnCode := 'pt';
  vList[i].NameForEnter := 'ÏÎÐÒÓÃÀËÜÑÊÈÉ';
  vList[i].NameForRead := 'Ïîðòóãàëüñêèé';

  i := 32;
  vList[i].Id := i;
  vList[i].LnCode := 'ro';
  vList[i].NameForEnter := 'ÐÓÌÛÍÑÊÈÉ';
  vList[i].NameForRead := 'Ðóìûíñêèé';

  i := 33;
  vList[i].Id := i;
  vList[i].LnCode := 'ru';
  vList[i].NameForEnter := 'ÐÓÑÑÊÈÉ';
  vList[i].NameForRead := 'Ðóññêèé';

  i := 34;
  vList[i].Id := i;
  vList[i].LnCode := 'sr';
  vList[i].NameForEnter := 'ÑÅÐÁÑÊÈÉ';
  vList[i].NameForRead := 'Ñåðáñêèé';

  i := 35;
  vList[i].Id := i;
  vList[i].LnCode := 'si';
  vList[i].NameForEnter := 'ÑÈÃÍÀËÜÑÊÈÉ';
  vList[i].NameForRead := 'Ñèãíàëüñêèé';

  i := 36;
  vList[i].Id := i;
  vList[i].LnCode := 'sk';
  vList[i].NameForEnter := 'ÑËÎÂÀÖÊÈÉ';
  vList[i].NameForRead := 'Ñëîâàöêèé';

  i := 37;
  vList[i].Id := i;
  vList[i].LnCode := 'so';
  vList[i].NameForEnter := 'ÑËÎÂÅÍÑÊÈÉ';
  vList[i].NameForRead := 'Ñëîâåíñêèé';

  i := 38;
  vList[i].Id := i;
  vList[i].LnCode := 'tr';
  vList[i].NameForEnter := 'ÒÓÐÅÖÊÈÉ';
  vList[i].NameForRead := 'Òóðåöêèé';

  i := 39;
  vList[i].Id := i;
  vList[i].LnCode := 'uz';
  vList[i].NameForEnter := 'ÓÇÁÅÊÑÊÈÉ';
  vList[i].NameForRead := 'Óçáåêñêèé';

  i := 40;
  vList[i].Id := i;
  vList[i].LnCode := 'uk';
  vList[i].NameForEnter := 'ÓÊÐÀÈÍÑÊÈÉ';
  vList[i].NameForRead := 'Óêðàèíñêèé';

  i := 41;
  vList[i].Id := i;
  vList[i].LnCode := 'ur';
  vList[i].NameForEnter := 'ÓÐÄÓ';
  vList[i].NameForRead := 'Óðäó';

  i := 42;
  vList[i].Id := i;
  vList[i].LnCode := 'fi';
  vList[i].NameForEnter := 'ÔÈÍÑÊÈÉ';
  vList[i].NameForRead := 'Ôèíñêèé';

  i := 43;
  vList[i].Id := i;
  vList[i].LnCode := 'fr';
  vList[i].NameForEnter := 'ÔÐÀÍÖÓÇÑÊÈÉ';
  vList[i].NameForRead := 'Ôðàíöóçñêèé';

  i := 44;
  vList[i].Id := i;
  vList[i].LnCode := 'hi';
  vList[i].NameForEnter := 'ÕÈÍÄÈ';
  vList[i].NameForRead := 'Õèíäè';

  i := 45;
  vList[i].Id := i;
  vList[i].LnCode := 'hr';
  vList[i].NameForEnter := 'ÕÎÐÂÀÒÑÊÈÉ';
  vList[i].NameForRead := 'Õîðâàòñêèé';

  i := 46;
  vList[i].Id := i;
  vList[i].LnCode := 'cs';
  vList[i].NameForEnter := '×ÅØÑÊÈÉ';
  vList[i].NameForRead := '×åøñêèé';

  i := 47;
  vList[i].Id := i;
  vList[i].LnCode := 'sv';
  vList[i].NameForEnter := 'ØÂÅÄÑÊÈÉ';
  vList[i].NameForRead := 'Øâåäñêèé';

  i := 48;
  vList[i].Id := i;
  vList[i].LnCode := 'et';
  vList[i].NameForEnter := 'ÝÑÒÎÍÑÊÈÉ';
  vList[i].NameForRead := 'Ýñòîíñêèé';

  i := 49;
  vList[i].Id := i;
  vList[i].LnCode := 'ja';
  vList[i].NameForEnter := 'ßÏÎÍÑÊÈÉ';
  vList[i].NameForRead := 'ßïîíñêèé';

  result := vList;
end;

// ïî èíèöèàëèçàöèè íîâîãî ñïèñêà ÿçûêîâ
function GetLnCode(pNameRead: String): String;
var
  vList: TListLanguages;
  i: integer;
begin
  vList := InitListLanguages();
  result := GetLnCodeFromList(pNameRead, vList);
end;



// ïî ñòðîêå ñ íàèìåíîâàíèå ÿçûêå îïðåäåëÿåì ñàì ÿçûê
function GetLnCodeFromList(pNameRead: String;
  pListLanguages: TListLanguages): String;
var
  i: integer;
  vUpperName: string;
begin
  // ïðèâåäåì ê âåðõíåìó ðåãèñòðó è ANSI è UTF
  vUpperName := ToUpper(pNameRead);
  // óáåðåì ëèøíèå ïðîáåëëû
  vUpperName := StringReplace(vUpperName, ' ', '',
    [rfReplaceAll, rfIgnoreCase]);
  result := 'unknown';
  i := 1;
  repeat
    if vUpperName = pListLanguages[i].NameForRead then
    begin
      result := pListLanguages[i].LnCode;
      i := 1000;
      break;
    end;
    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;



function GetNextLnCodeForEnter(pLastLnCode: String;
  pListLanguages: TListLanguages): String;
var
  i: integer;
  vFlNext: integer;
begin
  vFlNext := 0; // ñëåäóþùèé ïîêà íå ùåì
  result := '';
  if pLastLnCode = '' then
  begin
    vFlNext := 1; // åñëè ïóñòîé òî áåðåì ïåðâûé ïîäõîäÿùèé
  end;

  i := 1;
  repeat
    // íàøëè ñëåäóþùèé ÿçûê äëÿ ââîäà
    if (vFlNext = 1) and (pListLanguages[i].Activ = 1) then
    begin
      result := pListLanguages[i].LnCode;
      i := 1000;
      break;
    end;

    if pLastLnCode = pListLanguages[i].LnCode then
    begin
      vFlNext := 1; // íàøëè òåêóùèé, èñêàòü ñëåäóþùèé ÿçûê äëÿ ââîäà
    end;

    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;



// ïî ñòðîêå ñ êîäîì ÿçûêà îïðåäåëÿåì ñàì ÿçûê äëÿ ââîäà
function GetNameEnterOnLnCodeFromList(pLnCode: String;
  pListLanguages: TListLanguages): String;
var
  i: integer;
begin
  // óáåðåì ëèøíèå ïðîáåëëû
  result := '';
  i := 1;
  repeat
    if pLnCode = pListLanguages[i].LnCode then
    begin
      result := ToUpper(pListLanguages[i].NameForEnter); // â âåðõíåì ðåãèñòðå
      i := 1000;
      break;
    end;
    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;

end.

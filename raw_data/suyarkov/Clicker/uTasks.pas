unit uTasks;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Winapi.Windows, Vcl.Forms, ClipBrd, Vcl.Controls,Vcl.Dialogs,
  uCodeKey, uLanguages, uTranslate;
// var
// LnCodeForTranslation : string; // как ведут себя глобальные переменные
function Task_1(const pX, pY: integer): integer;
// перемещение курсора в координаты
function Task_2(): integer; // правый одиночный клик мышкой
function Task_3(pMilliseconds: LongInt): integer;
// пауза в работе в миллисекундах
function Task_4(pPixels: integer): integer; // скрол
function Task_5(pString: string): integer;
// набор переданного текста и в конце ВВод
function Task_6(LnCodeForTranslation: string; ListLanguages: TListLanguages;
  pIntControl: integer): integer;
function Task_7(pIntControl: integer; pClipName, pStrTranslate, pLnFrom,
  pLnCodeForTranslation: string): integer;
function Task_8(): integer;
function Task_9(): integer;
function Task_101(pX, pY, pRepeat: integer; pListLanguages: TListLanguages;
  var pLastLng: string): integer;

procedure Delay(dwMilliseconds: LongInt);

implementation

procedure GetPosXY(var pX, pY: integer);
var
  MyMouse: TMouse;
begin
  pX := MyMouse.CursorPos.x;
  pY := MyMouse.CursorPos.y;
end;

// перемещение курсора
function Task_1(const pX, pY: integer): integer;
begin
  try
    SetCursorPos(pX, pY);
    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// перемещение курсора
function Task_2(): integer;
begin
  try
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0); // левый клик
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);

    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// пауза
function Task_3(pMilliseconds: LongInt): integer;
begin
  try
    Delay(pMilliseconds);
    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// прокрутка колеса мыши, скрол
function Task_4(pPixels: integer): integer;
begin
  try
    Mouse_Event(MOUSEEVENTF_WHEEL, 0, 0, Cardinal(-pPixels), 0);

    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// набор текста и в конце клавиша ВВод
function Task_5(pString: string): integer;
var
  i: integer;
  vKey: char;
  CodeKey: integer;
begin
  try
    Delay(500);
    // Sleep(500); // с тормозами других программ
    Mouse_Event(MOUSEEVENTF_WHEEL, 0, 0, Cardinal(-12000), 0);
    Delay(500); // без тормозов других программ
    // Sleep(500); // с тормозами других программ
    for i := 1 to Length(pString) do
    begin
      vKey := pString[i];
      // перекодируем для ввода нажимом кнопки
      CodeKey := InVK(vKey);
      // нажимаем и отпускаем кнопку
      keybd_event(CodeKey, 0, 0, 0);
      keybd_event(CodeKey, 0, KEYEVENTF_KEYUP, 0);
    end;
    keybd_event(VK_RETURN, 0, 0, 0); // Нажатие 'Enter'.
    keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0); // Отпускание 'Enter'.
    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// двойной клик, и копирование в буфер обмена выделенного и в мемо
// и далее из буфера обмена в мемо
function Task_6(LnCodeForTranslation: string; ListLanguages: TListLanguages;
  pIntControl: integer): integer;
var
  vIntControl: integer;
  vStrOld, vStrNew: string;

begin
  try
    vIntControl := 0;
    Clipboard.AsText := ' ';
    vStrOld := Clipboard.AsText;
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0); // левый клик
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0); // левый клик
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    // Delay(150);
    keybd_event(VK_LCONTROL, 0, 0, 0); // Нажатие левого Ctrl.
    keybd_event(Ord('C'), 0, 0, 0); // Нажатие 'C'.
    keybd_event(Ord('C'), 0, KEYEVENTF_KEYUP, 0); // Отпускание 'C'.
    keybd_event(VK_LCONTROL, 0, KEYEVENTF_KEYUP, 0);
    // Отпускание левого Ctrl.
    Delay(100);
    vStrNew := Clipboard.AsText;
    if vStrNew <> vStrOld then
    begin
      vIntControl := 1;
      LnCodeForTranslation := GetLnCodeFromList(vStrNew, ListLanguages);
    end;

    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// перемещение курсора
function Task_7(pIntControl: integer; pClipName, pStrTranslate, pLnFrom,
  pLnCodeForTranslation: string): integer;
var
  vStr: string;
begin
  try
    if pIntControl > 0 then
    begin
      vStr := GoogleTranslate(pClipName, pLnFrom, pLnCodeForTranslation);
      vStr := StringReplace(vStr, #13, '', [rfReplaceAll, rfIgnoreCase]);
      if Length(vStr) > 100 then // в длинну упрячем
        vStr := Copy(vStr, 1, 100);

      pStrTranslate := vStr;
      // скопируем из мемо в буфер обена
      Clipboard.AsText := vStr; // TranslateText.Text[0];
      // активируем окно вставки текста
      Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0); // левый клик
      Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
      // вставить из буфера в окно
      keybd_event(VK_LCONTROL, 0, 0, 0); // Нажатие левого Ctrl.
      keybd_event(Ord('V'), 0, 0, 0); // Нажатие 'C'.
      keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0); // Отпускание 'C'.
      keybd_event(VK_LCONTROL, 0, KEYEVENTF_KEYUP, 0);
      // Отпускание левого Ctrl.
    end;

    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// перемещение курсора
function Task_8(): integer;
begin
  try
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0); // левый клик
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);

    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// перемещение курсора
function Task_9(): integer;
begin
  try
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0); // левый клик
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);

    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

// добавление всех языков
function Task_101(pX, pY, pRepeat: integer; pListLanguages: TListLanguages;
  var pLastLng: string): integer;
const
  cMaxCicle: integer = 300;
var
  vCicle: integer; // против зацикливания
  vRet: integer;
  vPausePosClick: integer;
  vPause1: integer;
  vPause2: integer;
  vNameLenguage: string;
  vNextLng: string;
  vX, vY: integer; // считанные координаты

begin
  if pLastLng = 'unknown' then
  begin
    Exit;
  end;

  try
    vPausePosClick := 150;
    vPause1 := 700;
    vPause2 := 850;
    vCicle := 0;
    // набор текста - текст взять из списка! и крутить по кругу
    repeat
      // подбор языка для ввода
      vNextLng := GetNextLnCodeForEnter(pLastLng, pListLanguages);
      // только если нашли следующий язык
      if vNextLng <> '' then
      begin
        // координаты кнопки открыть окно с выбором языков
        vRet := Task_1(pX, pY);
        // пауза
        vRet := Task_3(vPausePosClick);
        // клик
        vRet := Task_2();
        // пауза
        vRet := Task_3(vPause1);

        // подбор языка для ввода
        vNextLng := GetNextLnCodeForEnter(pLastLng, pListLanguages);

        // чтоб двигая мышку можно было остановить цикл
        GetPosXY(vX, vY);
        if (pX <> vX) or (pY <> vY) then
        begin
          showmessage(intToStr(pX) + ':' + intToStr(pY) + ' != '
                      + intToStr(vX) + ':' + intToStr(vY));
          Exit;
        end;

        vNameLenguage := GetNameEnterOnLnCodeFromList(vNextLng, pListLanguages);
        vRet := Task_5(vNameLenguage);
        pLastLng := vNextLng;
        // пауза 2
        vRet := Task_3(vPause2);
        // скрол
        vRet := Task_4(20000);
        // пауза позиционирования
        vRet := Task_3(vPausePosClick);
      end;
      inc(vCicle);
    until ((vNextLng = '') or (pRepeat = 0) or (vCicle >= cMaxCicle));
    result := 1;
  except
    result := -1;
    Exit;
  end;
end;

procedure Delay(dwMilliseconds: LongInt);
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Sleep(1); // Значительно уменьшает загрузку процессора
    // разрешает процесса ожидания делать другие ветки
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
end;

end.

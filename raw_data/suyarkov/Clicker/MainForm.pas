unit MainForm;

interface

uses
  uCodeKey, uLanguages, uTranslate, fmClipInfoForm, uTasks,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  ClipBrd;

// Настройка, наименование, языки, разрешение экрана, основной язык канала.
type
  TProfile = record
    Id: integer;
    Name: string;
    MainLanguage: string;
    LanguagesTranslation: string;
    ScreenResolution: string;
  end;

type
  TRecord = record
    TypeComand: integer;
    IntPar1: integer;
    IntPar2: integer;
    IntPar3: integer;
    StrPar1: string;
  end;

type
  TMain = class(TForm)
    ButtonStep1: TButton;
    ButtonStep2: TButton;
    ButtonStep3: TButton;
    LabelCountLanguages: TLabel;
    LabelMainLanguage: TLabel;
    LoadTask: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Start: TButton;
    Label2: TLabel;
    CountRepeatCicleEdit: TEdit;
    GetXYMouse: TButton;
    XYMouse: TEdit;
    ButtonStep3_1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure LoadTaskClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure ButtonStep1Click(Sender: TObject);
    procedure GetXYMouseClick(Sender: TObject);
    procedure ButtonStep2Click(Sender: TObject);
    procedure ButtonStep3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonStep3_1Click(Sender: TObject);
  private
    { Private declarations }
    var verProgram : string;
    Profile: TProfile;
    // настройка профиля для разных расширений, разных каналов.
    ListLanguages: TListLanguages; // список всех возможных языков в системе
    Rec: Array [1 .. 1000] of TRecord;
    // записи для действий, создаются по файлу
    CountRec: integer; // количество действий
    CountRepeatCicle: integer; // количество циклов действий
    LnCodeForTranslation: string; // код языка на который будут перевод
    ClipInfo: TStringList;
    ClipName: string;
    TranslateText: TStringList; // Tstrings;
    procedure RecordFree(var pRecord: TRecord);
    procedure RecFree(var pRec: Array of TRecord; var pCountRec: integer);

    procedure GridFree(var pGrid: TStringGrid);

    procedure MemoToRec(pMemo: TMemo; var pRec: Array of TRecord;
      var pCountRec: integer);

    procedure RecToMemo(pRec: Array of TRecord; pCountRec: integer;
      var pMemo: TMemo);
    procedure Delay(dwMilliseconds: Longint);
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

procedure TMain.RecordFree(var pRecord: TRecord);
begin
  pRecord.TypeComand := 0;
  pRecord.IntPar1 := 0;
  pRecord.IntPar2 := 0;
  pRecord.StrPar1 := '';
end;

function ProfileGet(pId: integer): TProfile;
var
  vProfile: TProfile;
begin
  vProfile.Id := 1;
  vProfile.Name := 'Основной';
  vProfile.MainLanguage := 'pl';
  vProfile.LanguagesTranslation := '/ru/en';
  vProfile.ScreenResolution := '1366 х 768';
  ProfileGet := vProfile;
end;

procedure TMain.RecFree(var pRec: Array of TRecord; var pCountRec: integer);
var
  i: integer;
begin
  for i := 0 to pCountRec do
  begin
    pRec[i].TypeComand := 0;
    pRec[i].IntPar1 := 0;
    pRec[i].IntPar2 := 0;
    pRec[i].StrPar1 := '';
  end;
  pCountRec := 0;
end;

procedure TMain.GridFree(var pGrid: TStringGrid);
begin
  pGrid.Cols[0].Clear;
  pGrid.ColCount := 1;
  pGrid.RowCount := 0;
end;

procedure TMain.LoadTaskClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
  CountRec := 0;
  MemoToRec(Memo1, Rec, CountRec);
end;

procedure TMain.MemoToRec(pMemo: TMemo; var pRec: Array of TRecord;
  var pCountRec: integer);
var
  vPos, i: integer;
  vStr, vStrPart: string;

  vRecord: TRecord;
begin
  RecFree(pRec, pCountRec);
  if pMemo.Lines.Count > 0 then
  begin
    for i := 0 to pMemo.Lines.Count - 1 do
    begin
      vStr := pMemo.Lines.Strings[i];
      vPos := Pos('-', vStr);
      RecordFree(vRecord);
      vRecord.TypeComand := StrToInt(Copy(vStr, 1, vPos - 1));
      pCountRec := pCountRec + 1;
      case vRecord.TypeComand of
        1:
          begin // перемещение
            vStrPart := Copy(vStr, vPos + 1, Length(vStr) - (vPos));
            vPos := Pos('-', vStrPart); // координаты Х
            vRecord.IntPar1 := StrToInt(Copy(vStrPart, 1, vPos - 1));
            vStrPart := Copy(vStrPart, vPos + 1, Length(vStrPart) - (vPos));
            vRecord.IntPar2 := StrToInt(vStrPart);
          end;

        2:
          begin // клик
          end;

        3:
          begin // пауза
            vStrPart := Copy(vStr, vPos + 1, Length(vStr) - (vPos));
            vRecord.IntPar1 := StrToInt(vStrPart);
          end;

        4:
          begin // скрол
            vStrPart := Copy(vStr, vPos + 1, Length(vStr) - (vPos));
            vRecord.IntPar1 := StrToInt(vStrPart); // сдвиг с - и без него
          end;

        5:
          begin // текст, нажатие по нему клавиш
            vStrPart := Copy(vStr, vPos + 1, Length(vStr) - (vPos));
            vRecord.StrPar1 := vStrPart; // сдвиг с - и без него
          end;

        6:
          begin // двойной клик, и копирование в буфер обмена выделенного
            // и далее из буфера обмена в мемо
          end;

        7:
          begin // перевод мемо названия
          end;

        8:
          begin // перевод мемо описание
          end;

        9:
          begin // вставка из мемо в буфер, и далее в позицию
          end;

        10:
          begin // Признак один раз или несколько выполнять
            vStrPart := Copy(vStr, vPos + 1, Length(vStr) - (vPos));
            vRecord.StrPar1 := vStrPart; // число
            CountRepeatCicleEdit.Text := vStrPart;
            CountRepeatCicle := StrToInt(vStrPart);
          end;

        101:
          begin // перемещение
            vStrPart := Copy(vStr, vPos + 1, Length(vStr) - (vPos));
            vPos := Pos('-', vStrPart); // координаты Х
            vRecord.IntPar1 := StrToInt(Copy(vStrPart, 1, vPos - 1));
            vStrPart := Copy(vStrPart, vPos + 1, Length(vStrPart) - (vPos));
            vPos := Pos('-', vStrPart); // координаты Y
            vRecord.IntPar2 := StrToInt(Copy(vStrPart, 1, vPos - 1));
            vStrPart := Copy(vStrPart, vPos + 1, Length(vStrPart) - (vPos));
            // повторять в цикле для оставшихся языков
            vRecord.IntPar3 := StrToInt(vStrPart);
          end;
      end;
      pRec[i] := vRecord;
    end;
  end;
end;

procedure TMain.RecToMemo(pRec: Array of TRecord; pCountRec: integer;
  var pMemo: TMemo);
var
  i: integer;
  vStr: string;
begin
  pMemo.Clear;
  if pCountRec = null then
    pCountRec := 0;
  vStr := '10-2';
  pMemo.Lines.add(vStr);
  vStr := '11-';
  pMemo.Lines.add(vStr);
  if pCountRec > 2 then
  begin
    for i := 2 to pCountRec - 1 do
    begin
      case pRec[i].TypeComand of
        1:
          begin // перемещение
            vStr := '1-' + IntToStr(pRec[i].IntPar1) + '-' +
              IntToStr(pRec[i].IntPar2);
            pMemo.Lines.add(vStr)
          end;

        2:
          begin // клик
            pMemo.Lines.add('2-');
          end;

        3:
          begin // пауза
            vStr := '3-' + IntToStr(pRec[i].IntPar1);
            pMemo.Lines.add(vStr)
          end;

        4:
          begin // скрол
            vStr := '4-' + IntToStr(pRec[i].IntPar1);
            pMemo.Lines.add(vStr);
          end;

        5:
          begin // текст, нажатие по нему клавиш
            vStr := '5-' + pRec[i].StrPar1;
            pMemo.Lines.add(vStr);
          end;

        6:
          begin // двойной клик, и копирование в буфер обмена выделенного
            pMemo.Lines.add('6-'); // и далее из буфера обмена в мемо
          end;

        7:
          begin // перевод мемо
            pMemo.Lines.add('7-');
          end;

        8:
          begin // перевод мемо2
            pMemo.Lines.add('8-');
          end;

        9:
          begin // вставка из мемо в буфер, и далее в позицию
            pMemo.Lines.add('9-');
          end;

      end;
    end;
  end;
end;

procedure TMain.Delay(dwMilliseconds: Longint);
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Sleep(1); // Значительно уменьшает загрузку процессора
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
end;

procedure TMain.GetXYMouseClick(Sender: TObject);
var
  MyMouse: TMouse;
begin
  Delay(2000);
  XYMouse.Text := IntToStr(MyMouse.CursorPos.x) + ':' +
    IntToStr(MyMouse.CursorPos.y);
end;

procedure KeyEm(pKey: char);
var
  CodeKey: integer;
begin
  CodeKey := InVK(pKey);
  keybd_event(CodeKey, 0, 0, 0);
  keybd_event(CodeKey, 0, KEYEVENTF_KEYUP, 0);
End;

procedure TMain.StartClick(Sender: TObject);

var
  i, j, vX, vY, vX2, vY2, i7: integer;
  MyMouse: TMouse;
  Layout: array [0 .. KL_NAMELENGTH] of char;
  vKey: char;
  vCountCicle: integer;
  vStrFor6: string;
  vStrFor7: string;
  vIntControl: integer;
  vLnFrom, LnFor: string;
  vRetTask: integer; // возращаемый результат выполнения задачи, удачно =1
  vLastLng: string;
begin
  vLnFrom := Profile.MainLanguage;
  vLnFrom := 'ru'; // пока на время!!!
  LoadKeyboardLayout(StrCopy(Layout, '00000419'), KLF_ACTIVATE);
  Delay(1000);
  vCountCicle := 0;
  vIntControl := 0;
  vLastLng := '';
  repeat
    vCountCicle := vCountCicle + 1;
    vX := 0;
    vY := 0;
    vX2 := 0;
    vY2 := 0;
    for i := 3 to CountRec do
    begin
      vY2 := Rec[i].TypeComand;
      case Rec[i].TypeComand of
        1:
          begin // перемещение
            vRetTask := Task_1(Rec[i].IntPar1, Rec[i].IntPar2);
          end;

        2:
          begin // клик
            vRetTask := Task_2();
          end;

        3:
          begin // пауза
            vRetTask := Task_3(Rec[i].IntPar1);
          end;

        4:
          begin // скрол
            vRetTask := Task_4(Rec[i].IntPar1);
          end;

        5:
          begin // набор текста , нажатие по нему клавиш
            vRetTask := Task_5(Rec[i].StrPar1);
          end;

        6:
          begin // двойной клик, и копирование в буфер обмена выделенного и в мемо
            // и далее из буфера обмена в мемо
            //vRetTask := Task_6(LnCodeForTranslation, ListLanguages,
            //  vIntControl);

              vIntControl := 0;
              Clipboard.AsText := ' ';
              vStrFor7 := Clipboard.AsText;
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
              vStrFor6 := Clipboard.AsText;
              if vStrFor6 <> vStrFor7 then
              begin
              vIntControl := 1;
              Label2.Caption := vStrFor6;
              LnCodeForTranslation := GetLnCodeFromList(vStrFor6,
              ListLanguages);
              end;

            // showmessage('Из буфера обмена' + vStrFor6 + ' ' + LnCodeForTranslation);
          end;

        7:
          begin // перевод ClipName и вставка в поле
            if vIntControl > 0 then
            begin
              vStrFor7 := GoogleTranslate(ClipName, vLnFrom,
                LnCodeForTranslation);
              vStrFor7 := StringReplace(vStrFor7, #13, '',
                [rfReplaceAll, rfIgnoreCase]);
              if Length(vStrFor7) > 100 then // в длинну упрячем
                vStrFor7 := Copy(vStrFor7, 1, 100);

              TranslateText.Text := vStrFor7;
              // скопируем из мемо в буфер обена
              Clipboard.AsText := vStrFor7; // TranslateText.Text[0];
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
          end;

        8:
          begin // перевод мемоInfo 2
            if vIntControl > 0 then
            begin
              TranslateText.Text := GoogleTranslate(ClipInfo.Text, vLnFrom,
                LnCodeForTranslation);
              if Length(TranslateText.Text) > 5000 then // в длинну упрячем
                TranslateText.Text := Copy(TranslateText.Text, 1, 5000);
              // скопируем из мемо в буфер обена
              Clipboard.AsText := TranslateText.Text;
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
          end;

        9:
          begin // вставка из мемо в буфер, и далее в позицию
          end;

        101:
          begin // вставка из мемо в буфер, и далее в позицию
            vRetTask := Task_101(Rec[i].IntPar1, Rec[i].IntPar2, Rec[i].IntPar3,
              ListLanguages, vLastLng);
            vLastLng := vLastLng;
          end;
      end;
    end;

    // если это не последний цикл то можем выйти по движению мышки
    if vCountCicle < CountRepeatCicle then
    begin
      vX := MyMouse.CursorPos.x;
      vY := MyMouse.CursorPos.y;
      Delay(2000);
      vX2 := MyMouse.CursorPos.x;
      vY2 := MyMouse.CursorPos.y;
      // Label2.Caption := IntToStr(vX) + '=' + IntToStr(vX2) + ':' + IntToStr(vY)
      // + '=' + IntToStr(vY2);
    end;
    Label2.Caption := IntToStr(vCountCicle);
  until (vX2 <> vX) or (vY2 <> vY) or (vCountCicle >= CountRepeatCicle);

  showmessage('Завершено ' + IntToStr(vCountCicle) + ' = ' +
    IntToStr(CountRepeatCicle));
end;

procedure TMain.ButtonStep2Click(Sender: TObject);
const
  cNameFile: string = 'Step2.cls';
var
  vPath: string;
  vFullNameFile: string;
begin
  vPath := GetCurrentDir();
  vFullNameFile := vPath + '/' + cNameFile;
  // Теперь проверяем существует ли файл
  if FileExists(vFullNameFile) then
  begin
    Memo1.Lines.LoadFromFile(vFullNameFile);
    CountRec := 0;
    MemoToRec(Memo1, Rec, CountRec);
    // ShowMessage(vFullNameFile + ' загружен!');
    Start.Click();
  end
  else
    showmessage(vFullNameFile + ' не существует');

end;

procedure TMain.ButtonStep3Click(Sender: TObject);
const
  cNameFile: string = 'Step3.cls';
  cFileWithNameClip: string = 'NameClip.cls';
  cFileWithInfoClip: string = 'InfoClip.cls';
var
  resultForm: word;
  vPath: string;
  vFullNameFile: string;
  i: integer;
  vNumberLanguage: integer;

begin
  vNumberLanguage := 0;
  // наполняем box значениями
  for i := 1 to 1000 do
  begin
    // пустые уже не добавляем
    if ListLanguages[i].LnCode = '' then
      break;

    ClipInfoForm.LanguageComboBox.Items.add(ListLanguages[i].LnCode + ' | ' +
      ListLanguages[i].NameForRead);
    // Запомним тот который активен
    if ListLanguages[i].LnCode = Profile.MainLanguage then
      vNumberLanguage := ClipInfoForm.LanguageComboBox.Items.Count - 1;
    // потому как индекс с -1

  end;

  if vNumberLanguage > 0 then
    ClipInfoForm.LanguageComboBox.ItemIndex := vNumberLanguage;
  {
    если номер записи не знаешь, но известно, что в Items есть строка Txt, то так:
    ComboBox.ItemIndex:=ComboBox.Items.IndexOf(Txt);
  }
  // зачитываем значение форм из файла
  vPath := GetCurrentDir();
  vFullNameFile := vPath + '/' + cFileWithNameClip;
  if FileExists(vFullNameFile) then
  begin
    ClipInfo.LoadFromFile(vFullNameFile);
    ClipName := ClipInfo.Strings[0];
    ClipInfo.Text := '';
    // ShowMessage(vFullNameFile + ' загружен!');
  end
  else
    ClipName := '';

  vFullNameFile := vPath + '/' + cFileWithInfoClip;
  if FileExists(vFullNameFile) then
  begin
    ClipInfo.LoadFromFile(vFullNameFile);
    // ShowMessage(vFullNameFile + ' загружен!');
  end
  else
    ClipInfo.Text := '';

  ClipInfoForm.EditClipName.Text := ClipName;
  ClipInfoForm.MemoClipInfo.Text := ClipInfo.Text;

  resultForm := ClipInfoForm.ShowModal;

  if resultForm = mrOK then
  begin
    ClipName := ClipInfoForm.EditClipName.Text;
    // сохраняем имя в файл
    ClipInfo.Text := ClipName;
    vFullNameFile := vPath + '/' + cFileWithNameClip;
    ClipInfo.SaveToFile(vFullNameFile);

    ClipInfo.Text := ClipInfoForm.MemoClipInfo.Text;
    // сохранение описания в файл
    vFullNameFile := vPath + '/' + cFileWithInfoClip;
    ClipInfo.SaveToFile(vFullNameFile);

    // загрузка выполнения
    vFullNameFile := vPath + '/' + cNameFile;
    // Теперь проверяем существует ли файл
    if FileExists(vFullNameFile) then
    begin
      Memo1.Lines.LoadFromFile(vFullNameFile);
      CountRec := 0;
      MemoToRec(Memo1, Rec, CountRec);
      Start.Click(); // **************************************запуск выполнения
    end
    else
      showmessage(vFullNameFile + ' не существует');
  end
  else
    MessageDlg('Действие отменено.', mtInformation, [mbYes], 0);
end;

procedure TMain.ButtonStep3_1Click(Sender: TObject);
const
  cNameFile: string = 'Step3_1.cls';
  cFileWithNameClip: string = 'NameClip.cls';
  cFileWithInfoClip: string = 'InfoClip.cls';
var
  resultForm: word;
  vPath: string;
  vFullNameFile: string;
  i: integer;
  vNumberLanguage: integer;

begin
  vNumberLanguage := 0;
  // наполняем box значениями
  for i := 1 to 1000 do
  begin
    // пустые уже не добавляем
    if ListLanguages[i].LnCode = '' then
      break;

    ClipInfoForm.LanguageComboBox.Items.add(ListLanguages[i].LnCode + ' | ' +
      ListLanguages[i].NameForRead);
    // Запомним тот который активен
    if ListLanguages[i].LnCode = Profile.MainLanguage then
      vNumberLanguage := ClipInfoForm.LanguageComboBox.Items.Count - 1;
    // потому как индекс с -1

  end;

  if vNumberLanguage > 0 then
    ClipInfoForm.LanguageComboBox.ItemIndex := vNumberLanguage;
  {
    если номер записи не знаешь, но известно, что в Items есть строка Txt, то так:
    ComboBox.ItemIndex:=ComboBox.Items.IndexOf(Txt);
  }
  // зачитываем значение форм из файла
  vPath := GetCurrentDir();
  vFullNameFile := vPath + '/' + cFileWithNameClip;
  if FileExists(vFullNameFile) then
  begin
    ClipInfo.LoadFromFile(vFullNameFile);
    ClipName := ClipInfo.Strings[0];
    ClipInfo.Text := '';
    // ShowMessage(vFullNameFile + ' загружен!');
  end
  else
    ClipName := '';

  vFullNameFile := vPath + '/' + cFileWithInfoClip;
  if FileExists(vFullNameFile) then
  begin
    ClipInfo.LoadFromFile(vFullNameFile);
    // ShowMessage(vFullNameFile + ' загружен!');
  end
  else
    ClipInfo.Text := '';

  ClipInfoForm.EditClipName.Text := ClipName;
  ClipInfoForm.MemoClipInfo.Text := ClipInfo.Text;

  resultForm := ClipInfoForm.ShowModal;

  if resultForm = mrOK then
  begin
    ClipName := ClipInfoForm.EditClipName.Text;
    // сохраняем имя в файл
    ClipInfo.Text := ClipName;
    vFullNameFile := vPath + '/' + cFileWithNameClip;
    ClipInfo.SaveToFile(vFullNameFile);

    ClipInfo.Text := ClipInfoForm.MemoClipInfo.Text;
    // сохранение описания в файл
    vFullNameFile := vPath + '/' + cFileWithInfoClip;
    ClipInfo.SaveToFile(vFullNameFile);

    // загрузка выполнения
    vFullNameFile := vPath + '/' + cNameFile;
    // Теперь проверяем существует ли файл
    if FileExists(vFullNameFile) then
    begin
      Memo1.Lines.LoadFromFile(vFullNameFile);
      CountRec := 0;
      MemoToRec(Memo1, Rec, CountRec);
      // showmessage(vFullNameFile + ' загружен!');
      Start.Click(); // **************************************запуск выполнения
    end
    else
      showmessage(vFullNameFile + ' не существует');
  end
  else
    MessageDlg('Действие отменено.', mtInformation, [mbYes], 0);
end;

procedure TMain.ButtonStep1Click(Sender: TObject);
const
  cNameFile: string = 'Step1.cls';
var
  vPath: string;
  vFullNameFile: string;
begin
  vPath := GetCurrentDir();
  vFullNameFile := vPath + '/' + cNameFile;
  // Теперь проверяем существует ли файл
  if FileExists(vFullNameFile) then
  begin
    Memo1.Lines.LoadFromFile(vFullNameFile);
    CountRec := 0;
    MemoToRec(Memo1, Rec, CountRec);
    // ShowMessage(vFullNameFile + ' загружен!');
    Start.Click();
  end
  else
    showmessage(vFullNameFile + ' не существует');
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  verProgram := '0.1';
  Profile := ProfileGet(1);
  ListLanguages := InitListLanguages();
  // Инициализация надписей согласной профилю
  Main.Caption := Profile.Name + ' ' + Profile.ScreenResolution + ' ' +
    '( актуальное ' + IntToStr(screen.Width) + ' х ' +
    IntToStr(screen.Height) + ')';
  LabelMainLanguage.Caption := 'Язык канала ' + Profile.MainLanguage;
  LabelCountLanguages.Caption := 'Перевод на ' +
    IntToStr(Trunc(Length(Profile.LanguagesTranslation) / 3)) + ' языка';
  LnCodeForTranslation := 'unknow';
  ClipInfo := TStringList.Create;
  TranslateText := TStringList.Create;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  //
end;

end.

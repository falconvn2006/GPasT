unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, ActnList, ExtCtrls, XPMan, ActnMan,
  ActnColorMaps;

type
  TTelephones = class(TForm)
    Setup: TButton;
    questions: TButton;
    exit: TButton;
    Panel1: TPanel;
    Razdel: TLabel;
    TelInfo: TLabel;
    TelNum: TLabel;
    NameInfo: TLabel;
    Tema: TComboBox;
    Teleph: TListBox;
    Names: TListBox;
    TemaPopup: TPopupMenu;
    N2: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    NamesPopup: TPopupMenu;
    N3: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    TelephPopup: TPopupMenu;
    N6: TMenuItem;
    N11: TMenuItem;
    N8: TMenuItem;
    N7: TMenuItem;
    XPManifest1: TXPManifest;
    Bevel1: TBevel;
    XPColorMap1: TXPColorMap;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure exitClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TemaChange(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure NamesClick(Sender: TObject);
    procedure TelephPopupPopup(Sender: TObject);
    procedure NamesPopupPopup(Sender: TObject);
    procedure TemaPopupPopup(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure TelephClick(Sender: TObject);
    procedure N7Click(Sender: TObject);

    function  InputSt(st1, st2, st3:string; long :Word):string;
    procedure CreateItem(st1, st2, st3:string);
    procedure DeleteItem(st1, st2, st3:string; b1, b2, b3:boolean);
    procedure AddToFile;
    procedure RewriteFile;
    procedure FindNameItems;
    function  FindCommentItems(st1, st2:string; b:boolean):string;
    procedure FindTelephItems(st:string);
    function  can(st:string; List:TStrings):boolean;
  end;

  PTelList=^TelList;
  TelList=Record
    Part:String[50];
    Name:string[100];
    NameComments:string[200];
    Tel:String[50];
    TelComments:string[50];
    Next, Prev:PTelList;
  end;

var
  Telephones: TTelephones;
  TelF:File of TelList;
  TelP:PTelList;
  Ver:string='1.0.0b';

implementation

{$R *.dfm}

procedure TTelephones.FormCreate(Sender: TObject);
var
  FileT:TelList;
  PtrTel :PTelList;
begin
  TelInfo.Caption:='';
  NameInfo.Caption:='';

  // Создание файла данных
  AssignFile(TelF, 'Book.dat');
  if not(FileExists('Book.dat')) then
  Begin
   Application.MessageBox
   ('Будет создан новый файл базы данных !',
    'База данных справочника (Book.dat) отсутствует !',
     MB_ICONEXCLAMATION+MB_OK);
   Rewrite(TelF);
   //описатель
//   FileT.Part:='AyyyK'; //идентификатор
  // FileT.Name:='Телефонный справочник.'; //название
//   FileT.NameComments:='Андрей Ковыляев'; //автор
  // FileT.Tel:='1.0.0b'; //номер версии
//   Write(TelF, FileT);
   CloseFile(TelF);
  end else
  begin
    Reset(TelF);
    CloseFile(TelF);
  end;

  //Считывание описателя
  Reset(TelF);
  //read(TelF, FileT);

  //Считывание данных в список
  TelP:=nil;
  While not eof(TelF) do
  begin
    Read(TelF, FileT);
    PtrTel:=New(PTelList);
    PtrTel^:=FileT;
    PtrTel^.Next:=TelP;
    if TelP<>nil then TelP^.Prev:=PtrTel;
    TelP:=PtrTel;
  end;
  CloseFile(TelF);
  if TelP<>nil then TelP^.Prev:=nil;

  //Первичное заполнение окна "Tema"
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    if (PtrTel^.Part<>'') and (PtrTel^.Name='') and (PtrTel^.Tel='') then
      Tema.Items.Add(PtrTel^.Part);
    PtrTel:=PtrTel^.Next;
  end;
  Tema.ItemIndex:=0;

  //Первичное заполнение окна "Names"
  FindNameItems;
  Names.ItemIndex:=0;

  //Комментарий
  if Names.Items.Count<>0 then
    NameInfo.Caption:=FindCommentItems(Names.Items[0], '', true);

  //Первичное заполнение окна "Teleph"
  if Names.Items.Count<>0 then
  begin
    FindTelephItems(Names.Items[0]);
    Teleph.ItemIndex:=0;
  end;

  //коммнетарий к телефону
  if Teleph.Items.Count<>0 then
    TelInfo.Caption:=FindCommentItems(Names.Items[0], Teleph.Items[0], false);
end;

procedure TTelephones.FormDestroy(Sender: TObject);
var
  PtrTel:PTelList;
begin
  While not (TelP=nil) do
  begin
    PtrTel:=TelP;
    TelP:=TelP^.Next;
    Dispose(PtrTel);
  end;
end;

procedure TTelephones.exitClick(Sender: TObject);
begin
  Telephones.Close;
end;

{************************** работа с разделами ********************************}
procedure TTelephones.N2Click(Sender: TObject); //новый раздел
var
  st:string[50];
begin
  //Ввод идентификатора
  st:=InputSt('Новый раздел', 'Введите название раздела (до 50 символов)', '', 50);

  if st<>'' then
    if can(st, Tema.Items) then
      Application.MessageBox('Такая группа уже создана', 'Действие отменено !',
      MB_ICONWARNING)
    else begin
      // Добавить в список
      CreateItem(st, '', '');

      // Добавить в файл
      AddToFile;

      // Добавить в выпадающий список
      Tema.ItemIndex:=Tema.Items.Add(TelP^.Part);

      //Очистить формы
      Names.Items.Clear;
      NameInfo.Caption:='';
      Teleph.Items.Clear;
      TelInfo.Caption:='';
    end;
end;

procedure TTelephones.N9Click(Sender: TObject);//Удаление  раздела
begin
  //Подтверждение удаления
  if Application.MessageBox('Вы уверены, что надо удалить данный раздел ?',
    'Удаление раздела', MB_ICONQUESTION+MB_YESNO)=IDYES then
     begin
       //Убрать из списка
       DeleteItem(Tema.Text, '', '', false, true, true);

       //Убрать из файла
       RewriteFile;

       //Убрать из выпадающего списка
       Tema.DeleteSelected;
       Tema.ItemIndex:=0;

       //перезаполнение окна Names
       Names.Items.Clear;
       FindNameItems;
       Names.ItemIndex:=0;

       //Комментарии
       if Names.Items.Count<>0 then
         NameInfo.Caption:=FindCommentItems(Names.Items[0], '', true);

       //презаполнение окна Teleph
       if Names.Items.Count<>0 then
         FindTelephItems(Names.Items[Names.ItemIndex]);
       Teleph.ItemIndex:=0;

       //комментарий к номеру
       TelInfo.Caption:='';
       if Names.Items.Count<>0 then
         TelInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex],
       Teleph.Items[Teleph.ItemIndex], false);
     end;
end;

procedure TTelephones.N10Click(Sender: TObject); //Переименование раздела
var
  st:string[50];
  PtrTel:PTelList;
begin
  st:=InputSt('Переименовать раздел', 'Введите название раздела', Tema.Text, 50);

  if st<>'' then
    if can(st, Tema.Items) then
      Application.MessageBox('Такая группа уже создана', 'Действие отменено !',
      MB_ICONWARNING)
    else begin
      //Изменить список
      PtrTel:=TelP;
      While not (PtrTel=nil) do
      begin
        if PtrTel^.Part=Tema.Text then
          PtrTel^.Part:=st;
        PtrTel:=PtrTel^.Next;
      end;

      //Изменить файл
      RewriteFile;

      //Изменить выпадающий список
      Tema.Items[Tema.ItemIndex]:=st;
      Tema.ItemIndex:=0;
    end;
end;


{**************************** работа с именами ********************************}
procedure TTelephones.N3Click(Sender: TObject); //Добавление идентиф.
VAR
  st:string;
begin
  //ввод имени
  st:=InputSt('Новое имя','Введите новое имя (до 100 символов)','', 100);

  if st<>'' then
    if can(st, Tema.Items) then
      Application.MessageBox('Такое имя уже создано', 'Действие отменено !',
      MB_ICONWARNING)
    else begin
      //Добавить в список
      CreateItem(Tema.Text, st, '');

      //Добавить в файл
      AddToFile;

      //Добавить в окно
      Names.ItemIndex:=Names.Items.Add(st);

      //Очистка форм
      NameInfo.Caption:='';
      Teleph.Items.Clear;
      TelInfo.Caption:='';
    end;
end;

procedure TTelephones.N4Click(Sender: TObject);  //удаление идентификатора
begin
  if Application.MessageBox('Вы уверены, что надо удалить данное имя ?',
    'Удаление имени ', MB_ICONQUESTION+MB_YESNO)=IDYES then
  begin
    //удалить из списка
    DeleteItem(Tema.Text, Names.Items[Names.ItemIndex], '', false, false, true);

    //удалить из файла
    RewriteFile;

    //удалить из окна
    Names.DeleteSelected;
    Names.ItemIndex:=0;

    //переопределение комментариев
    if Names.Items.Count<>0 then
      NameInfo.Caption:=FindCommentItems(Names.Items[0], '', true);

    //переопределение телефонов
    Teleph.Items.Clear;
    if Names.Items.Count<>0 then
      FindTelephItems(Names.Items[Names.ItemIndex]);
    Teleph.ItemIndex:=0;

    //комментарии к номеру
    TelInfo.Caption:='';
    if Names.Items.Count<>0 then
      TelInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex],
    Teleph.Items[Teleph.ItemIndex], false);
  end;
end;

procedure TTelephones.N5Click(Sender: TObject);   //переименование идентификатора
var
  st:string;
  PtrTel:PTelList;
begin
  st:=InputSt('Переименовать идентификатор ?','Введите новое имя (до 100 символов)',
  Names.Items[Names.ItemIndex], 100);

  if st<>'' then
    if can(st, Tema.Items) then
      Application.MessageBox('Такое имя уже есть', 'Действие отменено !',
      MB_ICONWARNING)
    else begin
      // в списке
      PtrTel:=TelP;
      While not (PtrTel=nil) do
      begin
        if (PtrTel^.Part=Tema.Text) and
          (PtrTel^.Name=Names.Items[Names.ItemIndex])
          then PtrTel^.Name:=st;
        PtrTel:=PtrTel^.Next;
      end;

      // в файле
      RewriteFile;

      // в окне
      Names.Items[Names.ItemIndex]:=st;
    end;
end;

procedure TTelephones.N1Click(Sender: TObject); //Комментарий к идентиф.
var
  st:string;
  PtrTel:PTelList;
begin
  st:=InputSt('Комментарий к имени', 'Введите комментарий (до 200 символов)',
  NameInfo.Caption, 200);

  //список
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    if (PtrTel^.Part=Tema.Text) and
      (PtrTel^.Name=Names.Items[Names.ItemIndex])
      then PtrTel^.NameComments:=st;
    PtrTel:=PtrTel^.Next;
  end;

  //файл
  RewriteFile;

  //сноска
  NameInfo.Caption:=st;

end;

{************************* перемещение курсора ********************************}
procedure TTelephones.TemaChange(Sender: TObject);   //новое заполнение окна
begin
  Names.Items.Clear;
  FindNameItems;
  Names.ItemIndex:=0;

  //комментарии
  if Names.Items.Count<>0 then
    NameInfo.Caption:=FindCommentItems(Names.Items[0], '', true)
  else NameInfo.Caption:='';

  //телефоны
  Teleph.Items.Clear;
  if Names.Items.Count<>0 then
    FindTelephItems(Names.Items[Names.ItemIndex]);
  Teleph.ItemIndex:=0;

  //комментарий к телефонам
  TelInfo.Caption:='';
  if Teleph.Items.Count<>0 then
    TelInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex],
    Teleph.Items[Teleph.ItemIndex], false);
end;

procedure TTelephones.NamesClick(Sender: TObject);
begin
  //коммнетарий
  NameInfo.Caption:='';
  if Names.Items.Count<>0 then
    NameInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex], '', true);

  //номера телефонов
  Teleph.Items.Clear;
  if Names.Items.Count<>0 then
    FindTelephItems(Names.Items[Names.ItemIndex]);
  Teleph.ItemIndex:=0;

  //комментарий к телефону
  TelInfo.Caption:='';
  if Teleph.Items.Count<>0 then
    TelInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex],
    Teleph.Items[Teleph.ItemIndex], false);
end;

procedure TTelephones.TelephClick(Sender: TObject);
begin
  TelInfo.Caption:='';
  if Teleph.Items.Count<>0 then
    TelInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex],
  Teleph.Items[Teleph.ItemIndex], false);
end;

{*************************** контекстное меню *********************************}
procedure TTelephones.TelephPopupPopup(Sender: TObject);
begin
  if Teleph.Items.Count=0 then
  begin
    N11.Enabled:=false;
    N8.Enabled:=false;
    N7.Enabled:=false;
  end
  else begin
    N11.Enabled:=True;
    N8.Enabled:=True;
    N7.Enabled:=True;
  end;
  if Names.Items.Count=0 then N6.Enabled:=false
  else N6.Enabled:=True;
end;

procedure TTelephones.NamesPopupPopup(Sender: TObject);
begin
  if Names.Items.Count=0 then
  begin
    N1.Enabled:=false;
    N4.Enabled:=false;
    N5.Enabled:=false;
  end
  else begin
    N1.Enabled:=True;
    N4.Enabled:=True;
    N5.Enabled:=True;
  end;
  if Tema.Items.Count=0 then N3.Enabled:=false
  else N3.Enabled:=True;
end;

procedure TTelephones.TemaPopupPopup(Sender: TObject);
begin
  if Tema.Items.Count=0 then
  begin
    N9.Enabled:=false;
    N10.Enabled:=false;
  end
  else begin
    N9.Enabled:=True;
    N10.Enabled:=True;
  end;
end;



{*********************** работа с телефонными номерами ************************}
procedure TTelephones.N6Click(Sender: TObject); //Добавление телефонного номера
var
  st:string;
begin
  st:=InputSt('Новый телефон', 'Введите номер', '', 50);

  if st<>'' then
    if can(st, Tema.Items) then
      Application.MessageBox('Такой номер уже создан', 'Действие отменено !',
      MB_ICONWARNING)
    else begin
      //добавить в список
      CreateItem(Tema.Text, Names.Items[Names.ItemIndex], st);

      //добавить в файл
      AddToFile;

      //добавить в окно
      Teleph.ItemIndex:=Teleph.Items.Add(st);

      //очистка форм
      TelInfo.Caption:='';
    end;
end;

procedure TTelephones.N8Click(Sender: TObject);   //удаление телефона
begin
  if Application.MessageBox('Вы уверены, что надо удалить данный номер ?',
    'Удаление номера ', MB_ICONQUESTION+MB_YESNO)=IDYES then
  begin
    //удалить из списка
    DeleteItem(Tema.Text, Names.Items[Names.ItemIndex],
    Teleph.Items[Teleph.ItemIndex], false, false, false);

    //удалить из файла
    RewriteFile;

    //удалить из окна
    Teleph.DeleteSelected;
    Teleph.ItemIndex:=0;

    //комментарий
    TelInfo.Caption:='';
    if Teleph.Items.Count<>0 then
      TelInfo.Caption:=FindCommentItems(Names.Items[Names.ItemIndex],
    Teleph.Items[Teleph.ItemIndex], false);

  end;
end;

procedure TTelephones.N11Click(Sender: TObject);  //Комментарий к телефону
var
  st:string;
  PtrTel:PTelList;
begin
  st:=InputSt('Комментарий к номеру', 'Введите комментарий (до 50 символов)',
  TelInfo.Caption, 50);

  //список
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    if (PtrTel^.Part=Tema.Text) and (PtrTel^.Name=Names.Items[Names.ItemIndex])
    and (PtrTel^.Tel=Teleph.Items[Teleph.ItemIndex]) then PtrTel^.TelComments:=st;
    PtrTel:=PtrTel^.Next;
  end;

  //файл
  RewriteFile;

  //сноска
  TelInfo.Caption:=st;
end;

procedure TTelephones.N7Click(Sender: TObject);//переопределить телефонный номер
var
  st:string;
  PtrTel:PTelList;
begin
  st:=InputSt('Изменить номер ?','Введите новый номер (до 50 символов)',
  Teleph.Items[Teleph.ItemIndex], 50);

  if st<>'' then
    if can(st, Tema.Items) then
      Application.MessageBox('Такой номер уже есть', 'Действие отменено !',
      MB_ICONWARNING)
    else begin
      // в списке
      PtrTel:=TelP;
      While not (PtrTel=nil) do
      begin
        if (PtrTel^.Part=Tema.Text) and (PtrTel^.Name=Names.Items[Names.ItemIndex])
        and (PtrTel^.Tel=Teleph.Items[Teleph.ItemIndex]) then PtrTel^.Tel:=st;
        PtrTel:=PtrTel^.Next;
      end;

      // в файле
      RewriteFile;

      // в окне
      Teleph.Items[Teleph.ItemIndex]:=st;
    end;
end;

{********************************* прочее *************************************}
function TTelephones.InputSt(st1, st2, st3 :string; long :Word):string; //ввод строки
var
  st:string;
begin
  st:='';
  st:=InputBox(st1, st2, st3);
  While not (Length(st)<=long) do
    st:=InputBox('Слишком много символов !'+'(до '+FloatToStr(long)+'символов)', st2, st3);
  InputSt:=st;
end;

procedure TTelephones.DeleteItem(st1, st2, st3:string; b1, b2,b3:boolean);
var                                                   //удаление элемента списка
  PtrTel:PTelList;
begin
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    if ((PtrTel^.Part=st1)or b1) and ((PtrTel^.Name=st2) or b2)
    and ((PtrTel^.Tel=st3) or b3) then
    begin
      if PtrTel^.Next<>nil then PtrTel^.Next^.Prev:=PtrTel^.Prev;
      if PtrTel^.Prev<>nil then PtrTel^.Prev^.Next:=PtrTel^.Next
      else if TelP<>nil then TelP:=TelP^.Next;
      Dispose(PtrTel);
    end;
    PtrTel:=PtrTel^.Next;
  end;
end;

procedure TTelephones.CreateItem(st1, st2, st3:string); //добавление элемента списка
var
  PtrTel:PTelList;
begin
  PtrTel:=New(PTelList);
  PtrTel^.Next:=TelP;
  PtrTel^.Prev:=nil;
  if TelP<>nil then TelP^.Prev:=PtrTel;
  TelP:=PtrTel;
  TelP^.Part:=st1;
  TelP^.Name:=st2;
  TelP^.Tel:=st3;
end;

procedure TTelephones.AddToFile;  //добавление в файл
var
  FileT:TelList;
begin
  FileT:=TelP^;
  Reset(TelF);
  seek(TelF, FileSize(TelF));
  Write(TelF, TelP^);
  CloseFile(TelF);
end;

procedure TTelephones.RewriteFile;  //перезапись файла
var
  PtrTel:PTelList;
begin
  Rewrite(TelF);
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    Write(TelF, PtrTel^);
    PtrTel:=PtrTel^.Next;
  end;
  CloseFile(TelF);
end;

procedure TTelephones.FindNameItems;  //нахождение похожих элементов  Names
var
  PtrTel:PTelList;
Begin
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    if (PtrTel^.Part=Tema.Text) and (PtrTel^.Name<>'') and (PtrTel^.Tel='') then
      Names.Items.Add(PtrTel^.Name);
    PtrTel:=PtrTel^.Next;
  end;
end;

function TTelephones.FindCommentItems(st1, st2:string; b:boolean):string;
var                                                     //нахождение комментария
  PtrTel:PTelList;
  st:string;
begin
  st:='';
  PtrTel:=TelP;
  While (PtrTel<>nil) and ((PtrTel^.Part<>Tema.Text) or (PtrTel^.Name<>st1)
  or (PtrTel^.Tel<>st2)) do PtrTel:=PtrTel^.Next;
  if (PtrTel^.Part=Tema.Text) and (PtrTel^.Name=st1) and (PtrTel^.Tel=st2) then
    if b then st:=PtrTel^.NameComments
    else st:=PtrTel^.TelComments;
  FindCommentItems:=st;
end;

procedure TTelephones.FindTelephItems(st:string);  //нахождение похожих элементов  Teleph
var
  PtrTel:PTelList;
begin
  PtrTel:=TelP;
  While not (PtrTel=nil) do
  begin
    if (PtrTel^.Part=Tema.Text) and (PtrTel^.Name=st) and (PtrTel^.Tel<>'') then
      Teleph.Items.Add(PtrTel^.Tel);
    PtrTel:=PtrTel^.Next;
  end;
end;

function TTelephones.can(st:string; List:TStrings):boolean; //проверка наличмя
var
  i:word;
  b:boolean;
begin
  b:=false;
  if st<>'' then
  begin
    i:=0;
    while (i<=List.Count) and (List[i]<>st) do i:=i+1;
    if List[i]=st then b:=True
  end;
  can:=b;
end;


end.


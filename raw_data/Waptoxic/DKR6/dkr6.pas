Program List1;
Uses crt;
Type Pint=^intr;
     intr=record
       a:integer;
       next:Pint;
     end;
Procedure NtCreat(Var Hed:Pint);  //процедура создания элемента списка
Var C,B:Pint;
    a:integer;
begin
  New(C);
  Write('Введите а ');
  readLn(C^.a);
  if hed=nil then
    begin
      hed:=c;
      hed^.next:=Hed;  //так как список кольцевой,то сюда вставляем адрес "головы"
    end      else
    begin
      b:=hed;
      while b^.next<>hed do
        b:=b^.next;
      c^.next:=Hed;
      b^.next:=c;
    end;
end;
 
Procedure View(Var Hed:Pint);  // процедура просмотра всего списка
Var C,S:Pint;
    i:integer;
begin
  c:=Hed;     //Встали на первый элемент списка
  S:=nil;
  if c=nil then
  begin
   WriteLn('Список пуст! ');
   readLn;
   exit;
  end;
 repeat
    WriteLn(C^.a);  // читаем элементы списка до тех пор,пока не перейдём на начало
    Write('1-Далее 0-Назад 2-Закончить просмотр ');
    readLn(i);     //Жмём Enter
    case i of
    1:c:=C^.next;  //Движение по списку вперёд
    0:begin
        s:=C;
        c:=hed;
         While C^.next<>s do
           c:=c^.next;
      end;
    2:begin
        break;
        exit;
      end;
    end;
 until false;//C=hed;
end;
 
Function Show(Var Sp:pint):boolean;
Var i:char;
begin
  Show:=true;
  WriteLn('1- Создать элемент списка ');
  Writeln('2- Просмотреть весь список ');
  WriteLn('3- Выход ');
  //i:=readkey;
  readLn(i);
  case i of
    '1':NtCreat(Sp);
    '2':View(sp);
    '3':Show:=false;
  end;
end;
Var Spisok:Pint;
    F:boolean;
Begin
  ClrScr;
  Spisok:=nil;
  repeat
    f:=show(Spisok);
    clrscr;
  until not F;
end.


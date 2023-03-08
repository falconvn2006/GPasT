unit Reestr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry;

type
  TForm15 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form15: TForm15;

implementation
  //Uses Key, Entry;
{$R *.dfm}
 function SHRegGetPath(hkey:HKEY; pszSubKey:PChar; pszValue:PChar;
         pszPath:PChar; dwFlags:DWORD):LongInt;
         stdcall; external 'shlwapi.dll' name 'SHRegGetPathA';
procedure TForm15.Button1Click(Sender: TObject);
var c:array [0..MAX_PATH] of char;
    res:longint;
begin
//Получение значения
res:= SHRegGetPath( HKEY_LOCAL_MACHINE,
                    'SYSTEM\CurrentControlSet\Services\Eventlog',
                    'ImagePath',c,0);
//Если res<>0, то выводится сообщение об ошибке (в зависимости от кода ошибки)
if res<>0 then begin
   FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,nil,res,0,c,High(c)-1,nil);
   MessageBox(0,c,nil,MB_ICONEXCLAMATION);
   ExitProcess(0);
   end;
//Если GetFileAttributes=-1, то, скорее всего, такого файла нет
//или нет прав на чтнеие атрибутов - всё равно ничего хорошего
if GetFileAttributes(c)=Cardinal(-1) then begin
   FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,nil,GetLastError(),0,c,High(c)-1,nil);
   MessageBox(0,c,nil,MB_ICONEXCLAMATION);
   ExitProcess(0);
   end;
//false - заменить существующий, true - не заменять
CopyFile(c,'c:\SomeFile.zzz',false);
end;

end.

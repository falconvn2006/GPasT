unit Proverka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, registry;

type
  TForm14 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
     procedure FormClose(Sender: TObject;
      var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation
   Uses Key, Entry;
{$R *.dfm}
var
RegFile: TRegIniFile;
const
  //ѕодсекци€
  SubKey: string = 'Software\RegDemo';
  // Ёлемент дл€ хранени€ логических данных
  BoolKey: string = 'BoolKey';
  // Ёлемент дл€ хранени€ целочисленных данных
  IntKey: string = 'IntKey';
  // Ёлемент дл€ хранени€ строчных данных
  StrKey: string = 'StrKey';


procedure TForm14.Button1Click(Sender: TObject);

begin
     RegFile.WriteInteger(IntKey, 'Value', 1998);
end;

procedure TForm14.Button2Click(Sender: TObject);

begin
     RegFile.WriteBool(BoolKey, 'Value', True);
end;


procedure TForm14.FormCreate(Sender: TObject);
begin
    RegFile := TRegIniFile.Create(SubKey);
end;

procedure TForm14.Button3Click(Sender: TObject);
begin
     RegFile.WriteString(StrKey, 'Value', 'Demo');
end;

procedure TForm14.Button4Click(Sender: TObject);
begin
     Memo1.Lines.Add('Int Value = ' +
    IntToStr(RegFile.ReadInteger(IntKey,
    'Value', 0)));
end;

procedure TForm14.Button5Click(Sender: TObject);
begin
    if RegFile.ReadBool(BoolKey, 'Value', False) then
    Memo1.Lines.Add('Bool Value = True')
  else
    Memo1.Lines.Add('Bool Value = False');
end;

procedure TForm14.Button6Click(Sender: TObject);
begin
      Memo1.Lines.Add(RegFile.ReadString(StrKey, 'Value', ''));
end;
  procedure TForm14.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // ”далить секцию
  RegFile.EraseSection(SubKey);
  // ќсвободить пам€ть
  RegFile.Free;
end;
end.

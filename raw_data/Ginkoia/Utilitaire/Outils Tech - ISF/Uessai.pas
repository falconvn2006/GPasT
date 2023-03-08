unit Uessai;

interface

uses
   ZipMstr,
   UInstallThr,
   ChxBase,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ExtCtrls;

type
   TForm2 = class(TForm)
      Button1: TButton;
      od: TOpenDialog;
      Memo1: TMemo;
      Button2: TButton;
      Button3: TButton;
      Timer1: TTimer;
      Timer2: TTimer;
      Button4: TButton;
      ZipM: TZipMaster;
      procedure Button1Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure Timer1Timer(Sender: TObject);
      procedure Timer2Timer(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button4Click(Sender: TObject);
   private
      procedure TotalProgress(Sender: TObject; TotalSize: Int64;
         PerCent: Integer);
    { Déclarations privées }
   public
    { Déclarations publiques }
      Last: Integer;
      LesThread: array of TInstall_Thr;
   end;

var
   Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
var
   f: tsearchrec;
begin
  // IF od.execute THEN    caption := od.FileName ;
   if FindFirst('\\liveup\liveupdate\*.*', faAnyFile, f) = 0 then
   begin
      repeat
         if f.Attr and faDirectory = faDirectory then
         begin
            if (f.name <> '.') and (f.name <> '..') then
               memo1.lines.add(f.Name + '\;DIR;' + f.Name + #13#10);
         end
         else if uppercase(extractfileext(f.name)) = '.IB' then
            memo1.lines.add(f.Name + '\;FIC;' + f.Name + #13#10)
         else if uppercase(extractfileext(f.name)) = '.GDB' then
            memo1.lines.add(f.Name + '\;FIC;' + f.Name + #13#10);
      until findnext(f) <> 0;
   end;
   findclose(f);
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
   memo1.lines.add('création');
   SetLength(LesThread, high(LesThread) + 2);
   LesThread[high(LesThread)] := TInstall_Thr.create(false, 1);
   LesThread[high(LesThread)].AddOrdre('COPY;C:\Developpement\Ginkoia\Data\CASTEL\ginkoia.ib;C:\Developpement\Ginkoia\Data\CASTEL\essai.ib');
   Timer2.enabled := true;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
   i: integer;
   j: integer;
begin
   i := 0;
   while i <= high(LesThread) do
   begin
      if (lesthread[i].doing = 'NONE') and (LesThread[i].LastCall < now - (1 / 24 / 60 / 6)) then
      begin
         memo1.lines.add('nettoyage');
         LesThread[i].stop;
         for j := i to high(LesThread) - 1 do
            LesThread[j] := LesThread[j + 1];
         SetLength(LesThread, high(LesThread));
      end
      else
         inc(i);
   end;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
var
   i: integer;
begin
   for i := 0 to high(LesThread) do
      if lesthread[i].id = 1 then
         memo1.Lines.add(lesthread[i].doing);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
   ChoixBase: TChoixBase;
begin
   application.createform(TChoixBase, ChoixBase);
   ChoixBase.ShowModal;
   ChoixBase.release;
end;

procedure TForm2.TotalProgress(Sender: TObject; TotalSize: Int64;
   PerCent: Integer);
begin
   if last <> Percent then
      Memo1.lines.add('Pcent ' + Inttostr(PerCent));
   last := Percent;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
   Zip: TZipMaster;

   procedure addfile(path,chem: string);
   var
      f: tSearchrec;
   begin
      if FindFirst(Path + '*.*', faAnyFile, f) = 0 then
      begin
         repeat
            if f.attr and faDirectory = faDirectory then
            begin
               if f.name[1] <> '.' then
                  Addfile(Path + f.name + '\', chem+f.name + '\');
            end
            else
            begin
               Zip.FSpecArgs.Add(chem + f.name);
            end;
         until FindNext(f) <> 0;
      end;
      FindClose(f);
   end;

begin
   zip := TZipMaster.Create(Nil);
   Zip.Dll_Load := false;
   Zip.AddCompLevel := 5 ;
   Zip.AddOptions := [AddDirNames,AddEncrypt] ;
   Zip.Password := '1082' ;
   Zip.OnTotalProgress := TotalProgress;
   Zip.RootDir := 'D:\TECH\SPLIT\PIERRICH\SERVEUR_CAHORS\';
   DeleteFile('D:\Transferts\Bases\SERVEUR_CAHORS.ZIP');
   Zip.ZipFileName := 'D:\Transferts\Bases\SERVEUR_CAHORS.ZIP';
   Zip.FSpecArgs.Clear;
   addfile('D:\TECH\SPLIT\PIERRICH\SERVEUR_CAHORS\','');
   Zip.add;
   Zip.Free ;
end;

end.


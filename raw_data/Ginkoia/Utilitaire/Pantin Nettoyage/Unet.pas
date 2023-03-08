unit Unet;

interface

uses
   Ftpthread,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, VCLUnZip, VCLZip, ComCtrls;

type
   TForm1 = class(TForm)
      Button1: TButton;
      ZIP: TVCLZip;
      Button2: TButton;
      Lab1: TLabel;
      PB: TProgressBar;
      procedure Button1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure ZIPTotalPercentDone(Sender: TObject; Percent: Integer);
      procedure ZIPZipComplete(Sender: TObject; FileCount: Integer);
   private
      procedure Traite(Path: string);
      procedure TraiteMonth(Path: string; month: word);
      procedure Compresse(path: string);
      procedure traiteDay(Path: string);
    { Déclarations privées }
   public
    { Déclarations publiques }
      ftp: TFtpThread;
      NomServeur: string;
      arret: boolean;
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Compresse(path: string);
var
   f: tsearchrec;
   s: string;
   pp: string;
   i: integer;
begin
   Lab1.caption := 'en cours ' + Path; Lab1.Update;
   s := path;
   delete(s, 1, 3);
   delete(s, length(s), 1);
   while pos('\', S) > 0 do
      s[pos('\', S)] := '-';
   pp := Path;
   delete(pp, length(pp), 1);
   while pp[length(pp)] <> '\' do
      delete(pp, length(pp), 1);
   Zip.ZipName := pp + s + '.zip';
   Zip.FilesList.Clear;
   if FindFirst(Path + '\*.*', faAnyFile, f) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') and (f.Attr and faDirectory <> faDirectory) then
         begin
            Zip.FilesList.add(Path + f.name);
            application.processmessages;
            if arret then exit;
         end;
      until Findnext(f) <> 0;
   end;
   findclose(f);
   zip.Zip;
   ftp.Ajoute(pp + s + '.zip', NomServeur + '-' + s + '.zip');
   for i := 0 to Zip.FilesList.count - 1 do
   begin
      deletefile(Zip.FilesList[i]);
   end;
   RemoveDir(path);
   Lab1.caption := ''; Lab1.Update;
end;

procedure TForm1.traiteDay(Path: string);
var
   f: tsearchrec;
begin
   if FindFirst(Path + '*.*', faDirectory, f) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            Compresse(Path + f.name + '\');
            if arret then exit;
         end;
      until Findnext(f) <> 0;
   end;
   findclose(f);
end;

procedure TForm1.TraiteMonth(Path: string; month: word);
var
   f: tsearchrec;
begin
   if FindFirst(Path + '*.*', faDirectory, f) = 0 then
   begin
      repeat
         try
            if (f.name <> '.') and (f.name <> '..') then
               if strtoint(f.name) <= month then
               begin
                  traiteDay(Path + f.name + '\');
                  if arret then exit;
                  lab1.caption := 'Attente pour sup le rep '; lab1.Update;
                  while not ftp.vide do
                  begin
                     sleep(250);
                     application.ProcessMessages;
                  end;
                  RemoveDir(Path + f.name + '\');
               end;
            if arret then exit;
         except end;
      until Findnext(f) <> 0;
   end;
   findclose(f);
end;

procedure TForm1.Traite(Path: string);
var
   Year, Month, Day: Word;
   f: tsearchrec;
begin
   // V***\data\Batch\annee\moi\jour
   // V***\data\Extract\annee\moi\jour
   DecodeDate(IncMonth(Date, -2), Year, Month, Day);
   Path := Path + 'data\';
   // selection des Batch
   if FindFirst(Path + 'batch\*.*', faDirectory, f) = 0 then
   begin
      repeat
         try
            if (f.name <> '.') and (f.name <> '..') then
            begin
               if strtoint(f.name) < year then
                  traiteMonth(Path + 'batch\' + f.name + '\', 99)
               else if strtoint(f.name) = year then
                  traiteMonth(Path + 'batch\' + f.name + '\', month);
               if arret then Break;
            end;
         except end;
      until Findnext(f) <> 0;
   end;
   findclose(f);
   if not arret then
   begin
      if FindFirst(Path + 'Extract\*.*', faDirectory, f) = 0 then
      begin
         repeat
            try
               if (f.name <> '.') and (f.name <> '..') then
               begin
                  if strtoint(f.name) < year then
                     traiteMonth(Path + 'Extract\' + f.name + '\', 99)
                  else if strtoint(f.name) = year then
                     traiteMonth(Path + 'Extract\' + f.name + '\', month);
                  if arret then Break;
               end;
            except end;
         until Findnext(f) <> 0;
      end;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   f: tsearchrec;
   Path: string;
begin
   arret := false;
   Path := 'D:\Eai\';
   if FindFirst(Path + '*.*', faanyfile, f) = 0 then
   begin
      repeat
         if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
         begin
            if FileExists(Path + f.name + '\DelosQPMAgent.Databases.xml') then
            begin
               Traite(Path + f.name + '\');
               if arret then BREAK;
            end;
         end;
      until Findnext(f) <> 0;
   end;
   findclose(f);
   lab1.caption := 'Arret en cours finalisation des envois '; lab1.Update;
   while not ftp.vide do
   begin
      sleep(250);
      application.ProcessMessages;
   end;
   ftp.Terminate;
   Application.messageBox('C''est fini', 'fin', mb_ok);
   close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   Compt: array[0..256] of Char;
   Lasize: DWord;
begin
   Lab1.caption := '';
   Lasize := 255;
   getcomputername(@compt, Lasize);
   NomServeur := string(compt);
   ftp := TFtpThread.create(self);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   arret := true;
end;

procedure TForm1.ZIPTotalPercentDone(Sender: TObject; Percent: Integer);
begin
   pb.Position := Percent;
end;

procedure TForm1.ZIPZipComplete(Sender: TObject; FileCount: Integer);
begin
   pb.Position := 0;
end;

end.


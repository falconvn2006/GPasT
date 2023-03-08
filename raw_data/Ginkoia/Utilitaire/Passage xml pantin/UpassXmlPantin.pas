unit UpassXmlPantin;

interface

uses
   SimpHTTP,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls, Buttons;

type
   TForm1 = class(TForm)
      Label1: TLabel;
      Edit1: TEdit;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      Edit3: TEdit;
      Edit4: TEdit;
      pb: TProgressBar;
      Button1: TButton;
      Button2: TButton;
      Lab_etat: TLabel;
      lb: TListBox;
      SpeedButton1: TSpeedButton;
      Od: TOpenDialog;
      Edit2: TEdit;
      Label5: TLabel;
      Memo: TMemo;
      Button3: TButton;
      Label6: TLabel;
      Edit5: TEdit;
      Button4: TButton;
      Button5: TButton;
    OdRep: TOpenDialog;
    SpeedButton2: TSpeedButton;
      procedure Button1Click(Sender: TObject);
      procedure SpeedButton1Click(Sender: TObject);
      procedure Edit1Exit(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure Button4Click(Sender: TObject);
      procedure Button5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
   private
      function Compter: TstringList;
      function Compterrep: TstringList;
      procedure traiteentete;
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

function TForm1.Compter: TstringList;
var
   tsl: tstringlist;
   rech: string;
   dd, df: TdateTime;

   procedure go(chemin: string);
   var
      f: tsearchrec;
   begin
      if findfirst(chemin + '*.*', faanyfile, F) = 0 then
      begin
         repeat
            lab_etat.caption := chemin + f.name + '   ' + Inttostr(result.count);
            lab_etat.Update;
            if (f.name <> '.') and (f.name <> '..') then
            begin
               if f.attr and fadirectory = fadirectory then
                  go(chemin + f.name + '\')
               else if uppercase(extractfileext(f.name)) = '.XML' then
               begin
                  if (FileDateToDateTime(f.Time) >= dd) and
                     (FileDateToDateTime(f.Time) <= df) then
                  begin
                     tsl.loadfromfile(chemin + f.name);
                     if pos('<Operation>BatchRequest</Operation>', tsl.text) > 0 then
                     begin
                        if pos(rech, tsl.text) > 0 then
                        begin
                              // peut etre a considérer
                           result.add(inttostr(f.time) + ';' + chemin + f.name);
                        end;
                     end;
                  end
               end;
            end;
         until findnext(f) <> 0;
         findclose(f);
      end;
   end;

begin
   dd := strtodate(Edit3.text);
   df := strtodate(Edit4.text);
   if (lb.itemindex <> -1) then
      rech := lb.items[lb.itemindex];
   rech := '<Database>' + rech + '</Database>';
   tsl := tstringlist.create;
   result := tstringlist.create;
   if Edit5.text <> '' then
      Go(IncludeTrailingBackslash(Edit5.text))
   else
      Go(IncludeTrailingBackslash(extractfilepath(edit1.text)) + 'data\batch\');
   tsl.free;
end;

function trilist(List: TStringList; Index1, Index2: Integer): Integer;
var
   s1, s2: string;
begin
   s1 := list[index1];
   s2 := list[index2];
   s1 := copy(s1, 1, pos(';', s1) - 1);
   s2 := copy(s2, 1, pos(';', s2) - 1);
   if strtoint(s1) < strtoint(s2) then
      result := -1
   else if strtoint(s1) > strtoint(s2) then
      result := 1
   else
      result := 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   tsl: tstringlist;
begin
   tsl := Compter;
   caption := inttostr(tsl.count) + ' fichiers trouvés';
   tsl.free;
end;

procedure TForm1.traiteentete;
var
   tsl: tstringlist;
   S1: string;
   S: string;
begin
   lb.items.clear;
   if fileexists(edit1.text) then
   begin
      tsl := tstringlist.create;
      tsl.loadfromfile(edit1.text);
      S := tsl.text;
      tsl.free;
      while pos('<DataSource>', S) > 0 do
      begin
         Delete(S, 1, Pos('<DataSource>', S) + 11);
         Delete(S, 1, Pos('<Name>', S) + 5);
         S1 := Copy(S, 1, Pos('<', S) - 1);
         Delete(S, 1, Pos('</DataSource>', S) + 12);
         lb.items.add(S1);
      end;
   end;
   S := edit1.text;
   S := ExcludeTrailingBackslash(extractfilepath(S));
   while pos('\', S) > 0 do
      delete(s, 1, pos('\', s));
   edit2.text := s + 'Bin';
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   if od.execute then
      edit1.text := od.FileName;
   traiteentete;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
   traiteentete;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   traiteentete;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   FHTTP: TSimpleHTTP;
   ResultBody: TStringStream;
   tsl: tstringlist;
   i: integer;
   S1,
      S: string;
   entete: string;
   ModifFic: TStringList;
begin
   if (lb.itemindex <> -1) then
   begin
      tsl := Compter;
      caption := inttostr(tsl.count) + ' fichiers trouvés';
      tsl.CustomSort(trilist);

      FHTTP := TSimpleHTTP.Create(nil);
      ResultBody := TStringStream.Create('');
      try
         pb.min := 0; pb.max := tsl.count;
         for i := 0 to tsl.count - 1 do
         begin
            pb.Position := I+1;
            FHTTP.UserName := '';
            FHTTP.Password := '';
            FHTTP.PostData.Clear;
            FHTTP.PostData.Values['XMLC_StandardParams'] := '1';
            FHTTP.PostData.Values['XMLC_OutputFormat'] := 'HTML';
            FHTTP.PostData.Values['Database'] := lb.items[lb.itemindex];
            S1 := tsl[i];
            delete(s1, 1, pos(';', s1));
            lab_etat.caption := 'Envoie ' + S1; lab_etat.Update;
            FHTTP.PostData.Values['XMLFile'] := S1;

            // vérifier que l'entête XML est présente
            //<?xml version="1.0" encoding="ISO-8859-1"?>
            ModifFic := TStringList.create;
            ModifFic.LoadFromFile(s1);
            entete := ModifFic[0];
            if pos('<?XML', Uppercase(entete)) = 0 then
            begin
               ModifFic.Insert(0, '<?xml version="1.0" encoding="UTF-8"?>');
               ModifFic.SavetoFile(s1);
            end else if pos('ENCODING=', Uppercase(entete)) = 0 then
            begin
               delete(entete, 1, pos('>', entete));
               entete := '<?xml version="1.0" encoding="ISO-8859-1"?>' + entete;
               ModifFic[0] := entete;
               ModifFic.SavetoFile(s1);
            end;
            ModifFic.free;
            // fin de vérification de l'entête

            FHTTP.Post('http://localhost/' + edit2.text + '/DelosQPMAgent.dll/BatchFile', ResultBody);
            S := ResultBody.DataString;

            if (pos('ERROR', UpperCase(s)) > 0) then
            begin
               application.messageBox(pchar('fichier ' + S1), 'PROBLEME', Mb_Ok);
               memo.lines.text := ResultBody.DataString;
               memo.visible := true;
               BREAK;
            end;
            ResultBody.free;
            ResultBody := TStringStream.Create('');
         end;
      finally
         ResultBody.free;
         FHTTP.free;
      end;
      tsl.free;
   end;
   if sender <> nil then
      application.messagebox('fin', 'fin', mb_ok);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   tsl: TStringList;
begin
   tsl := CompterRep;
   caption := inttostr(tsl.count) + ' fichiers trouvés';
   tsl.free;
end;

function TForm1.Compterrep: TstringList;
   procedure go(chemin: string);
   var
      f: tsearchrec;
   begin
      if findfirst(chemin + '*.*', faanyfile, F) = 0 then
      begin
         repeat
            lab_etat.caption := chemin + f.name + '   ' + Inttostr(result.count);
            lab_etat.Update;
            if (f.name <> '.') and (f.name <> '..') then
            begin
               if f.attr and fadirectory = fadirectory then
                  go(chemin + f.name + '\')
               else if uppercase(extractfileext(f.name)) = '.XML' then
               begin
                  result.add(inttostr(f.time) + ';' + chemin + f.name);
               end;
            end;
         until findnext(f) <> 0;
         findclose(f);
      end;
   end;

begin
   result := tstringlist.create;
   Go(IncludeTrailingBackslash(extractfilepath(edit5.text)));
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   FHTTP: TSimpleHTTP;
   ResultBody: TStringStream;
   tsl: tstringlist;
   i: integer;
   S1,
      S: string;
begin
   if (lb.itemindex <> -1) then
   begin
      tsl := CompterRep;
      caption := inttostr(tsl.count) + ' fichiers trouvés';
      tsl.CustomSort(trilist);

      FHTTP := TSimpleHTTP.Create(nil);
      ResultBody := TStringStream.Create('');
      try
         pb.min := 0; pb.max := tsl.count;
         for i := 0 to tsl.count - 1 do
         begin
            pb.Position := I+1;
            FHTTP.UserName := '';
            FHTTP.Password := '';
            FHTTP.PostData.Clear;
            FHTTP.PostData.Values['XMLC_StandardParams'] := '1';
            FHTTP.PostData.Values['XMLC_OutputFormat'] := 'HTML';
            FHTTP.PostData.Values['Database'] := lb.items[lb.itemindex];
            S1 := tsl[i];
            delete(s1, 1, pos(';', s1));
            lab_etat.caption := 'Envoie ' + S1; lab_etat.Update;
            FHTTP.PostData.Values['XMLFile'] := S1;
            FHTTP.Post('http://localhost/' + edit2.text + '/DelosQPMAgent.dll/BatchFile', ResultBody);
            S := ResultBody.DataString;
            if (pos('ERROR', UpperCase(s)) > 0) then
            begin
               application.messageBox(pchar('fichier ' + S1), 'PROBLEME', Mb_Ok);
               memo.lines.text := ResultBody.DataString;
               memo.visible := true;
               BREAK;
            end;
            ResultBody.free;
            ResultBody := TStringStream.Create('');
         end;
      finally
         ResultBody.free;
         FHTTP.free;
      end;
      tsl.free;
   end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
   i: integer;
begin
   for i := 0 to lb.items.count - 1 do
   begin
      lb.itemIndex := i;
      Button2Click(nil);
   end;
   application.messagebox('fin', 'fin', mb_ok);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
   if odrep.execute then
      edit5.text := IncludeTrailingBackslash(ExtractFilePath(odrep.FileName));
end;

end.


//$Log:
// 7    Utilitaires1.6         05/11/2018 11:43:53    Ludovic MASSE   on enl?ve
//      tous les composant li? au code en commentaire (yellis)
// 6    Utilitaires1.5         02/11/2018 14:50:38    Ludovic MASSE   v3.0.0.2
//      : ajout de la 7z.dll a l'auto extractible
// 5    Utilitaires1.4         27/06/2018 12:25:01    Python Benoit  
//      Utilisation du nouveau nom en constante
// 4    Utilitaires1.3         25/07/2017 09:57:29    Ludovic MASSE   Algol
//      Patch Maker - Ajout signature exe
// 3    Utilitaires1.2         10/07/2017 15:53:43    Ludovic MASSE   Algol
//      Patch Maker - Ajout signature exe
// 2    Utilitaires1.1         03/11/2016 15:40:31    Ludovic MASSE   CDC -
//      demenagement yellis
// 1    Utilitaires1.0         19/09/2016 10:08:39    Ludovic MASSE   
//$
//$NoKeywords$
//


unit UPatch;

interface

uses
   inifiles,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, ComCtrls, ExtCtrls, VCLUnZip, VCLZip, Db, dxmdaset,
   Psock, NMFtp, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia,
   RzEdit, shellAPI;

type
   TForm1 = class(TForm)
      Label1: TLabel;
      Ed_AncVersion: TEdit;
      Ed_NvlVersion: TEdit;
      Label2: TLabel;
      SpeedButton1: TSpeedButton;
      SpeedButton2: TSpeedButton;
      OD: TOpenDialog;
      Vit: TRadioGroup;
      Pb_Tot: TProgressBar;
      Pb_Fichier: TProgressBar;
      Label3: TLabel;
      Lab_Fic: TLabel;
      Button1: TButton;
      Lab_Pcent: TLabel;
      ZIP: TVCLZip;
      ed_Rep: TEdit;
      Label4: TLabel;
    Log: TRzMemo;
    Label5: TLabel;
    eMdp: TEdit;
    Button3: TButton;
      procedure SpeedButton1Click(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure ZIPTotalPercentDone(Sender: TObject; Percent: Integer);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure AbZipArchiveProgress(Sender: TObject; Progress: Byte;
         var Abort: Boolean);
      procedure ftpPacketSent(Sender: TObject);
    procedure Button3Click(Sender: TObject);
   private
      TailleFichier: Integer;
      function Lesfichier(Path: string; var Lataille: Integer): TStringList;
      procedure Patching(T_Actu, T_Tot: Integer);
      procedure ChangeTaille;

    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

uses
   UmakePatch,
   uConstante;

function traiteversion(S: string): string;
var
   S1: string;
begin
   result := '';
   while pos('.', S) > 0 do
   begin
      S1 := Copy(S, 1, pos('.', S));
      delete(S, 1, pos('.', S));
      while (Length(S1) > 2) and (S1[1] = '0') do delete(S1, 1, 1);
      result := result + S1;
   end;
   S1 := S;
   while (Length(S1) > 1) and (S1[1] = '0') do delete(S1, 1, 1);
   result := result + S1;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
   S: string;
begin
   if od.execute then
   begin
      S := ExcludeTrailingBackSlash(extractfilepath(od.filename));
      while S[1] <> 'V' do
         delete(S, 1, 1);
      Ed_AncVersion.Text := S;
   end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
   S: string;
begin
   if od.execute then
   begin
      S := ExcludeTrailingBackSlash(extractfilepath(od.filename));
      while S[1] <> 'V' do
         delete(S, 1, 1);
      Ed_NvlVersion.Text := S;
   end;
end;

function TForm1.Lesfichier(Path: string; var Lataille: Integer): TStringList;

   procedure liste(PO, path: string);
   var
      f: TSearchRec;
   begin
      if findfirst(path + '*.*', FaAnyfile, F) = 0 then
      begin
         repeat
            if (f.name <> '.') and (f.name <> '..') then
            begin
               if f.attr and faDirectory = faDirectory then
               begin
                  Liste(Po + f.name + '\', path + f.name + '\');
               end
               else
               begin
                  result.add(Uppercase(Po + f.name));
                  LaTaille := LaTaille + f.size;
               end;
            end;
         until findnext(f) <> 0;
      end;
      findclose(f);
   end;

begin
   Lataille := 0;
   result := tstringlist.create;
   liste('', IncludeTrailingBackslash(path));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   tslSrc: TstringList;
   tslDest: TstringList;
   Taille: Integer;
   i: Integer;
   Fsrc, Fdest: string;

   TMS_Pass: TMemoryStream;
   TMS_LesFichiers: TMemoryStream;

   TaillePass: Integer;
   Fl: Double;

   Tsl: TstringList;
   S1,
      S: string;
   Fe, fs: file;
   BLock: array[0..2048] of char;
   Ts: Integer;
   NvlVersion: string;
   sMotDePasse : string;

   SEInfo: TShellExecuteInfo;
   ExitCode: DWORD;
begin
   sMotDePasse := eMdp.text;
   IF Ed_AncVersion.Text = '' then
   BEGIN
      Showmessage('Il faut renseigner l''ancienne Version');
      Ed_AncVersion.SetFocus;
      EXIT;
   END;
   IF Ed_NvlVersion.Text = '' then
   BEGIN
      Showmessage('Il faut renseigner la nouvelle Version');
      Ed_NvlVersion.setfocus;
      EXIT;
   END;
   IF not FileExists(ExtractFilePath(Application.ExeName) + 'signtool.exe') then
   BEGIN
      Showmessage('Outils de signature introuvable !');
      EXIT;
   END;
   IF not FileExists(ExtractFilePath(Application.ExeName) + 'Ginkoia.pfx') then
   BEGIN
      Showmessage('Certificat introuvable !');
      EXIT;
   END;
   IF sMotDePasse = '' then
   BEGIN
      Showmessage('Il faut renseigner un mdp !');
      EXIT;
   END;

   tslSrc := Lesfichier(IncludeTrailingBackslash(ed_rep.text + Ed_AncVersion.text), Taille);
   tslDest := Lesfichier(IncludeTrailingBackslash(ed_rep.text + Ed_NvlVersion.text), Taille);
   Pb_Tot.Max := Taille;
   TMS_LesFichiers := TMemoryStream.Create;
   try
      WriteString(Ed_AncVersion.text, TMS_LesFichiers);
      Tsl := TstringList.Create;
      try
         Tsl.LoadFromFile(ed_rep.text + Ed_AncVersion.text + '\SCRIPT.SCR');
         i := tsl.count - 1;
         while Copy(tsl[i], 1, 9) <> '<RELEASE>' do
            dec(i);
         S := Tsl[i];
         delete(S, 1, 9);
         S := traiteversion(S);
         WriteString(S, TMS_LesFichiers);

         WriteString(Ed_NvlVersion.text, TMS_LesFichiers);
         Tsl.LoadFromFile(ed_rep.text + Ed_NvlVersion.text + '\SCRIPT.SCR');
         i := tsl.count - 1;
         while Copy(tsl[i], 1, 9) <> '<RELEASE>' do
            dec(i);
         S := Tsl[i];
         delete(S, 1, 9);
         S := traiteversion(S);
         NvlVersion := S;
         WriteString(S, TMS_LesFichiers);
      finally
         tsl.free;
      end;
      for i := 0 to tslDest.Count - 1 do
      begin
         Pb_Fichier.Position := 0;
         Fdest := tslDest[i];
         if tslSrc.indexOf(Fdest) > -1 then
            Fsrc := Fdest
         else
            Fsrc := '';
            // exclure les fichiers non interressant
         if (Uppercase(ExtractFileExt(Fdest)) = '.ALG') then
         begin
            FSRC := '';
         end;
         Lab_Fic.Caption := Fdest; Lab_Fic.Update;
         TMS_Pass := PatchFile(IncludeTrailingBackslash(ed_rep.text + Ed_AncVersion.text),
            IncludeTrailingBackslash(ed_rep.text + Ed_NvlVersion.text),
            FSrc, Fdest, Vit.ItemIndex, Patching);
         TaillePass := TMS_Pass.Size;
         TMS_Pass.Seek(soFromBeginning, 0);
         TMS_LesFichiers.Write(TaillePass, Sizeof(TaillePass));
         TMS_LesFichiers.CopyFrom(TMS_Pass, 0);
         TMS_Pass.free;

         Pb_Tot.Position := Pb_Tot.Position + TailleFichier;
         fl := ((Pb_Tot.Position - TMS_LesFichiers.Size) / Pb_Tot.Position) * 100;
         Lab_Pcent.Caption := Format('%.2f %%', [Fl]); //Inttostr(Pb_Tot.Position)+'  '+Inttostr(TMS_LesFichiers.Size)+'  '+Format ('%.2f %%',[Fl]) ;
         Lab_Pcent.Update;
      end;
        // Suppression des fichiers non utilisés
      Fdest := '';
      for i := 0 to tslSrc.Count - 1 do
      begin
         Fsrc := tslSrc[i];
         if tslDest.indexOf(Fsrc) < 0 then
         begin
            TMS_Pass := PatchFile(IncludeTrailingBackslash(ed_rep.text + Ed_AncVersion.text),
               IncludeTrailingBackslash(ed_rep.text + Ed_NvlVersion.text),
               FSrc, Fdest, Vit.ItemIndex, Patching);
            TaillePass := TMS_Pass.Size;
            TMS_Pass.Seek(soFromBeginning, 0);
            TMS_LesFichiers.Write(TaillePass, Sizeof(TaillePass));
            TMS_LesFichiers.CopyFrom(TMS_Pass, 0);
            TMS_Pass.free;
            Pb_Tot.Position := Pb_Tot.Position + TailleFichier;
            fl := ((Pb_Tot.Position - TMS_LesFichiers.Size) / Pb_Tot.Position) * 100;
            Lab_Pcent.Caption := Format('%.2f %%', [Fl]); //Inttostr(Pb_Tot.Position)+'  '+Inttostr(TMS_LesFichiers.Size)+'  '+Format ('%.2f %%',[Fl]) ;
            Lab_Pcent.Update;
         end;
      end;
   finally
     // BPY le 2018-05-04 : Renommage
     IF FileExists(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'Patch.Exe') then
     begin
       IF FileExists(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + Nom_Outil_Maj + '.exe') then
         DeleteFile(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + Nom_Outil_Maj + '.exe');
       MoveFile(PChar(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'Patch.Exe'), PChar(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + Nom_Outil_Maj + '.exe'));
     END;

      TMS_LesFichiers.Savetofile(ed_rep.text + Nom_Outil_Maj + '.GIN');
      Zip.ZipName := ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.ZIP';
      Zip.FilesList.Clear;
      Zip.FilesList.ADD(ed_rep.text + Nom_Outil_Maj + '.GIN');
      Zip.FilesList.ADD(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + Nom_Outil_Maj + '.exe');
      Zip.FilesList.ADD(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'DelZip179.dll');
      Zip.FilesList.ADD(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + '7z.dll');

      Lab_Fic.Caption := 'Zipping'; Lab_Fic.Update;
      Pb_Fichier.Position := 0;
      Pb_Fichier.Max := 100;
      zip.Zip;

      ChangeTaille;

      Assignfile(Fs, ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE');
      Rewrite(fs, 1);
      AssignFile(Fe, IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'MAJ_Ginkoia.exe');
      reset(fe, 1);
      repeat
         BlockRead(fe, Block, 2048, TS);
         BlockWrite(fs, Block, TS);
      until Ts <> 2048;
      Closefile(fe);

      AssignFile(Fe, ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.ZIP');
      reset(fe, 1);
      repeat
         BlockRead(fe, Block, 2048, TS);
         BlockWrite(fs, Block, TS);
      until Ts <> 2048;
      Closefile(fe);
      Closefile(fS);

      //Lab_Fic.caption := 'envois à yellis'; Lab_Fic.update;
      AssignFile(Fe, ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE');
      reset(fe, 1);
      i := filesize(fe); //trunc(filesize(fe) / 512); //
      Pb_Fichier.position := 0;
      Pb_Fichier.max := i;
      closefile(fe);


      try
        FillChar(SEInfo, SizeOf(SEInfo), 0) ;
        SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
        with SEInfo do begin
          fMask := SEE_MASK_NOCLOSEPROCESS;
          Wnd := Application.Handle;
          lpFile := pchar(ExtractFilePath(Application.ExeName) + 'signtool.exe') ;
          lpParameters := pchar('sign /v /f "' + ExtractFilePath(Application.ExeName) + 'Ginkoia.pfx" /p '+sMotDePasse+' /t "http://timestamp.verisign.com/scripts/timestamp.dll" "' + ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE'+'"');
          nShow := SW_SHOWNORMAL;
       END;
         IF ShellExecuteEx(@SEInfo)then
         begin
              repeat
                    Application.ProcessMessages;
                    GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
              until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
         END;

      finally

      END;

      S := Inttostr(FileCRC32(ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE'));
      tsl := TstringList.create;
      tsl.add(NvlVersion);
      tsl.add(S);
      tsl.savetofile(ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.TXT');
      tsl.Free;
      Application.MessageBox('C''est fini', 'C''est fini', Mb_Ok);
      Lab_Fic.Caption := 'C''est fini'; Lab_Fic.Update;
      TMS_LesFichiers.free;

      Pb_Fichier.Position := 0;
      Pb_Tot.Position := 0;

   end;
end;

procedure TForm1.Patching(T_Actu, T_Tot: Integer);
begin
   TailleFichier := T_Tot;
   Pb_Fichier.Position := t_actu;
   Pb_Fichier.Max := T_Tot;
end;

procedure TForm1.ZIPTotalPercentDone(Sender: TObject; Percent: Integer);
begin
   Pb_Fichier.Position := Percent;
end;

procedure TForm1.ChangeTaille;
var
   f: file;
   tc: char;
   S: string;
   Taille: string;
   i: Integer;
begin
 //
   AssignFile(F, IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'MAJ_Ginkoia.exe');
   reset(f, 1);
   Taille := Inttostr(FileSize(F));
   while length(Taille) < 10 do taille := '0' + Taille;
   Seek(f, 0);
   S := 'TAILLE EXE';
   repeat
      repeat
         BlockRead(F, tc, 1);
      until tc = 'T';
      I := 1;
      while (i < 10) and (tc = S[i]) do
      begin
         Inc(i);
         BlockRead(F, tc, 1);
      end;
   until (tc = 'E') and (i = 10);
   for i := 1 to 10 do
      BlockRead(F, tc, 1);
   for i := 1 to 10 do
      BlockWrite(f, Taille[i], 1);
   Closefile(f);
 //
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   ini: tinifile;
begin
   ini := tinifile.create(changefileext(application.exename, '.ini'));
   ed_rep.text := ini.readstring('GENERAL', 'REPDEP', 'C:\');
   ini.free
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
   ini: tinifile;
begin
   ini := tinifile.create(changefileext(application.exename, '.ini'));
   ini.Writestring('GENERAL', 'REPDEP', ed_rep.text);
   ini.free
end;

procedure TForm1.AbZipArchiveProgress(Sender: TObject; Progress: Byte;
   var Abort: Boolean);
begin
   Pb_Fichier.Position := Progress;
end;

procedure TForm1.ftpPacketSent(Sender: TObject);
begin
   Pb_Fichier.position := Pb_Fichier.position + 1;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   Crc_Exe, Crc_Txt, Exe, Txt : String;
   sl : TstringList;
begin
     Exe := ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE';
     Txt := ed_rep.text + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.TXT';
     Crc_Exe := Inttostr(FileCRC32(Exe));
     try
     sl := TStringList.create;
     sl.loadfromfile(Txt);
     Crc_Txt := sl[1];
     IF Crc_Exe = Crc_Txt then
        showmessage('CRC OK')
     else
        showmessage('CRC NOK');
     finally
        sl.free;
     end
end;

end.


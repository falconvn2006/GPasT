//$Log:
// 3    Utilitaires1.2         21/07/2006 10:37:51    pascal          divers
//      correction
// 2    Utilitaires1.1         12/05/2005 16:50:47    pascal         
//      Modification divers pour le patching
// 1    Utilitaires1.0         27/04/2005 10:41:35    pascal          
//$
//$NoKeywords$
//


unit UPatch;

interface

uses
   inifiles,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, ComCtrls, ExtCtrls, VCLUnZip, VCLZip, Db, dxmdaset,
   MemDataX, Psock, NMFtp, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia,
   IpFtp;

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
      Button2: TButton;
      ed_Rep: TEdit;
      Label4: TLabel;
      Bdx: TDataBaseX;
      Version: TMemDataX;
      Versionid: TIntegerField;
      Versionversion: TStringField;
      fichiers: TMemDataX;
      fichiersid_ver: TIntegerField;
      fichiersfichier: TStringField;
      fichierscrc: TStringField;
      fichiersid_fic: TIntegerField;
      Versionnomversion: TStringField;
      Http1: TIpHttpClientGinkoia;
      IpFtp: TIpFtpClient;
      procedure SpeedButton1Click(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure ZIPTotalPercentDone(Sender: TObject; Percent: Integer);
      procedure Button2Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure AbZipArchiveProgress(Sender: TObject; Progress: Byte;
         var Abort: Boolean);
      procedure ftpPacketSent(Sender: TObject);
      procedure Http1Progress(Sender: TObject; Actuel, Maximum: Integer);
      procedure IpFtpFtpLoginError(Sender: TObject; ErrorCode: Integer;
         const Error: string);
   private
      TailleFichier: Integer;
      function Lesfichier(Path: string; var Lataille: Integer): TStringList;
      procedure Patching(T_Actu, T_Tot: Integer);
      procedure ChangeTaille;
      procedure FaireLeLog(Ver: string);
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Form1: TForm1;

implementation
{$R *.DFM}
uses
   UmakePatch;

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

begin
   FaireLeLog(Ed_NvlVersion.text);
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
      TMS_LesFichiers.Savetofile(ed_rep.text + 'Patch.GIN');
      Zip.ZipName := ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.ZIP';
      Zip.FilesList.Clear;
      Zip.FilesList.ADD(ed_rep.text + 'Patch.GIN');
      Zip.FilesList.ADD(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'Patch.Exe');
      Zip.FilesList.ADD(IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'DelZip179.dll');
      Lab_Fic.Caption := 'Zipping'; Lab_Fic.Update;
      Pb_Fichier.Position := 0;
      Pb_Fichier.Max := 100;
      zip.Zip;

      ChangeTaille;

      Assignfile(Fs, ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE');
      Rewrite(fs, 1);
      AssignFile(Fe, IncludeTrailingBackslash(ExtractFilePath(Application.exename)) + 'MAJ_Ginkoia.exe');
      reset(fe, 1);
      repeat
         BlockRead(fe, Block, 2048, TS);
         BlockWrite(fs, Block, TS);
      until Ts <> 2048;
      Closefile(fe);

      AssignFile(Fe, ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.ZIP');
      reset(fe, 1);
      repeat
         BlockRead(fe, Block, 2048, TS);
         BlockWrite(fs, Block, TS);
      until Ts <> 2048;
      Closefile(fe);
      Closefile(fS);
      S := Inttostr(FileCRC32(ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE'));
      tsl := TstringList.create;
      tsl.add(NvlVersion);
      tsl.add(S);
      tsl.savetofile(ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.TXT');
      tsl.Free;
      Lab_Fic.caption := 'envois à yellis'; Lab_Fic.update;
      AssignFile(Fe, ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE');
      reset(fe, 1);
      i := filesize(fe); //trunc(filesize(fe) / 512); //
      Pb_Fichier.position := 0;
      Pb_Fichier.max := i;
      closefile(fe);

      if IpFtp.Login('ginkoia.yellis.net', 'ginkoia', '1082', '') then
      begin
         while IpFtp.InProgress do
            application.processmessages;
         IpFtp.Store('MAJ/PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE',
            ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE',
            smReplace,
            0);
         while IpFtp.InProgress do
         begin
            Pb_Fichier.Position := IpFtp.BytesTransferred;
            application.processmessages;
         end;
         IpFtp.Store('MAJ/PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.TXT',
            ed_rep.text + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.TXT',
            smReplace,
            0);
         while IpFtp.InProgress do
         begin
            application.processmessages;
         end;
         IpFtp.Logout;
      end;

      if Http1.GetWaitTimeOut('http://ginkoia.yellis.net/MAJ/' + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE', 30000) then
      begin
         Http1.SaveToFile('http://ginkoia.yellis.net/MAJ/' + 'PatchGin' + Ed_AncVersion.Text + '-' + Ed_NvlVersion.Text + '.EXE', ed_rep.text + 'essai.exe');
         S1 := Inttostr(FileCRC32(ed_rep.text + 'essai.exe'));
         if s1 <> s then
            application.messagebox('Problème d''envois à Yellis', 'PROBLEME', Mb_OK);
         DeleteFile(ed_rep.text + 'essai.exe');
      end
      else
         application.messagebox('Problème d''envois à Yellis', 'PROBLEME', Mb_OK);

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

procedure TForm1.FaireLeLog(Ver: string);
var
   tsl: TstringList;
   tslSrc: TstringList;

   i: integer;
   S: string;
   CRC: string;
   Taille: Integer;
   id: integer;
begin
 //
   Screen.Cursor := CrHourGlass;
   try
      Tsl := TStringList.Create;
      try
         Tsl.LoadFromFile(ed_rep.text + Ver + '\SCRIPT.SCR');
         i := tsl.count - 1;
         while Copy(tsl[i], 1, 9) <> '<RELEASE>' do
            dec(i);
         S := Tsl[i];
         delete(S, 1, 9);
         S := traiteversion(S);
      finally
         tsl.free;
      end;
      Version.parambyname('numero').asstring := S;
      Version.Open;
      if Version.IsEmpty then
      begin
         Version.Insert;
         Versionversion.AsString := S;
         Versionnomversion.AsString := Ver;
         Version.Post;
         Version.Validation;
         Version.Close;
         Version.parambyname('numero').asstring := S;
         Version.Open;
      end;
      id := Versionid.AsInteger;
      Version.close;
      fichiers.parambyname('ver').asinteger := id;
      fichiers.Open;
      tslSrc := Lesfichier(IncludeTrailingBackslash(ed_rep.text + Ver), Taille);
      for i := 0 to tslSrc.count - 1 do
      begin
         S := Uppercase(tslSrc[i]);
         if (extractfileext(s) <> '.SCR') and
            (extractfileext(s) <> '.ALG') then
         begin
            CRC := Inttostr(FileCRC32(IncludeTrailingBackslash(ed_rep.text + Ver) + S));
            if fichiers.Locate('fichier', Vararrayof([S]), []) then
            begin
               fichiers.edit;
               fichierscrc.AsString := CRC;
               fichiers.Post;
            end
            else
            begin
               fichiers.Insert;
               fichierscrc.AsString := CRC;
               fichiersid_ver.AsInteger := id;
               fichiersfichier.asstring := S;
               fichiers.Post;
            end;
            tslSrc[i] := S + ';' + CRC
         end;
      end;
      fichiers.Validation;
      fichiers.close;
    // tslSrc.SaveToFile(ed_rep.text + S + '.LOG');
      tslSrc.Free;
   finally
      Screen.Cursor := CrDefault;
   end;
 //
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   FaireLeLog(Ed_AncVersion.text);
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

procedure TForm1.Http1Progress(Sender: TObject; Actuel, Maximum: Integer);
begin
   pb_fichier.Max := Maximum;
   pb_fichier.Position := Actuel;
end;

procedure TForm1.IpFtpFtpLoginError(Sender: TObject; ErrorCode: Integer;
   const Error: string);
begin
   application.messagebox(Pchar(error), 'erreur', MB_Ok);
end;

end.


//$Log:
// 1    Utilitaires1.0         01/10/2012 16:06:33    Loic G          
//$
//$NoKeywords$
//
unit UCreBaseTest;

interface

uses
   registry,
   FileCtrl,
   inifiles,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, RzLabel, ArtLabel,
   DFClasses, Backgnd, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
   TFrm_Crertest = class(TForm)
      Background12: TBackground;
      Art_Crer: TArtLabel;
      Art_Modif: TArtLabel;
      Lib1: TRzLabel;
      Lib2: TRzLabel;
      BitBtn3: TBitBtn;
      Lib3: TRzLabel;
      Lab_Etat: TLabel;
      data: TIBDatabase;
      SQL: TIBQuery;
      tran: TIBTransaction;
      procedure FormCreate(Sender: TObject);
      procedure BitBtn3Click(Sender: TObject);
   private
    { Déclarations privées }
      Labase: string;
      creer: Boolean;
   public
    { Déclarations publiques }
   end;

var
   Frm_Crertest: TFrm_Crertest;

implementation

{$R *.DFM}

procedure TFrm_Crertest.FormCreate(Sender: TObject);
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.access := Key_Read;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
      Labase := reg.ReadString('Base0');
   finally
      reg.free;
   end;
   if (trim(Labase) = '') or (not FileExists(Labase)) then
   begin
      creer := False;
      lib3.visible := true;
      lib1.visible := false;
      lib2.visible := false;
      Art_Crer.visible := false;
      Art_Modif.visible := True;
   end
   else
   begin
      creer := True;
      Art_Crer.visible := true;
      Art_Modif.visible := false;
      lib3.visible := false;
      lib1.visible := true;
      lib2.visible := true;
   end;
end;

procedure TFrm_Crertest.BitBtn3Click(Sender: TObject);
var
   path: string;
   chem: string;
   ini: TiniFile;
   ss: string;
   S: string;
   mag: string;
   poste: string;
   i: Integer;
   ouelleest: string;

   procedure changeChemin;
   begin
      if FileExists(Path + 'ginkoia.ini') then
      begin
         ini := tinifile.create(Path + 'ginkoia.ini');
         SS := Uppercase(Labase);
         while pos(':', SS) > 0 do
            delete(SS, 1, pos(':', SS));
         ini := tinifile.create(Path + 'ginkoia.ini');
         i := 0;
         while i < 10 do
         begin
            S := Uppercase(ini.ReadString('DATABASE', 'PATH' + Inttostr(i), ''));
            if pos(SS, S) > 0 then
               BREAK;
            inc(i);
         end;
         if i < 10 then
         begin
            Poste := ini.ReadString('NOMPOSTE', 'POSTE' + Inttostr(i), '');
            ouelleest := ini.ReadString('DATABASE', 'PATH' + Inttostr(i), '');
            i := 0;
            while i < 10 do
            begin
               S := Uppercase(ini.ReadString('NOMMAGS', 'MAG' + Inttostr(i), ''));
               if pos('TEST', S) > 0 then
                  BREAK;
               inc(i);
            end;
            if i = 10 then
            begin
               i := 0;
               while i < 10 do
               begin
                  S := Uppercase(ini.ReadString('NOMMAGS', 'MAG' + Inttostr(i), ''));
                  if trim(S) = '' then
                     BREAK;
                  inc(i);
               end;
               if i < 10 then
               begin
                  chem := ExcludeTrailingBackslash(ExtractFilePath(ouelleest));
                  while Chem[Length(chem)] <> '\' do
                     delete(chem, length(chem), 1);
                  Chem := Chem + 'test\test.IB';
                  ini.WriteString('DATABASE', 'PATH' + Inttostr(i), Chem);
                  ini.WriteString('NOMMAGS', 'MAG' + Inttostr(i), 'TEST');
                  ini.WriteString('NOMPOSTE', 'POSTE' + Inttostr(i), poste);
                  ini.WriteString('NOMBASES', 'ITEM' + Inttostr(i), 'TEST');
               end;
            end;
         end;
         ini.free;
      end;
      if FileExists(Path + 'CaisseGinkoia.ini') then
      begin
         ini := tinifile.create(Path + 'CaisseGinkoia.ini');
         SS := Uppercase(Labase);
         while pos(':', SS) > 0 do
            delete(SS, 1, pos(':', SS));
         ini := tinifile.create(Path + 'CaisseGinkoia.ini');
         i := 0;
         while i < 10 do
         begin
            S := Uppercase(ini.ReadString('DATABASE', 'PATH' + Inttostr(i), ''));
            if pos(SS, S) > 0 then
               BREAK;
            inc(i);
         end;
         if i < 10 then
         begin
            Poste := ini.ReadString('NOMPOSTE', 'POSTE' + Inttostr(i), '');
            ouelleest := ini.ReadString('DATABASE', 'PATH' + Inttostr(i), '');
            i := 0;
            while i < 10 do
            begin
               S := Uppercase(ini.ReadString('NOMMAGS', 'MAG' + Inttostr(i), ''));
               if pos('TEST', S) > 0 then
                  BREAK;
               inc(i);
            end;
            if i = 10 then
            begin
               i := 0;
               while i < 10 do
               begin
                  S := Uppercase(ini.ReadString('NOMMAGS', 'MAG' + Inttostr(i), ''));
                  if trim(S) = '' then
                     BREAK;
                  inc(i);
               end;
               if i < 10 then
               begin
                  chem := ExcludeTrailingBackslash(ExtractFilePath(ouelleest));
                  while Chem[Length(chem)] <> '\' do
                     delete(chem, length(chem), 1);
                  Chem := Chem + 'test\test.IB';
                  ini.WriteString('DATABASE', 'PATH' + Inttostr(i), Chem);
                  ini.WriteString('NOMMAGS', 'MAG' + Inttostr(i), 'TEST');
                  ini.WriteString('NOMPOSTE', 'POSTE' + Inttostr(i), poste);
                  ini.WriteString('NOMBASES', 'ITEM' + Inttostr(i), 'TEST');
               end;
            end;
         end;
         ini.free;
      end;
   end;

begin
   Screen.Cursor := crhourglass;
   try
      Path := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
      if creer then
      begin
         chem := ExcludeTrailingBackslash(ExtractFilePath(Labase));
         while Chem[Length(chem)] <> '\' do
            delete(chem, length(chem), 1);
         Chem := Chem + 'test\';
         ForceDirectories(chem);
         Lab_Etat.Caption := 'Création de la base de données de TEST, patientez .....';
         Lab_Etat.visible := true;
         Update;
         CopyFile(Pchar(Labase), pchar(Chem + 'TEST.IB'), False);
         Lab_Etat.Caption := 'Modification de la base test';
         Update;
         if FileExists(Path + 'ginkoia.ini') then
         begin
            SS := Uppercase(Labase);
            while pos(':', SS) > 0 do
               delete(SS, 1, pos(':', SS));
            ini := tinifile.create(Path + 'ginkoia.ini');
            i := 0;
            while i < 10 do
            begin
               S := Uppercase(ini.ReadString('DATABASE', 'PATH' + Inttostr(i), ''));
               if pos(SS, S) > 0 then
                  BREAK;
               inc(i);
            end;
            if i < 10 then
            begin
               Mag := ini.ReadString('NOMMAGS', 'MAG' + Inttostr(i), '');
               data.databasename := Chem + 'TEST.IB';
               data.Open;
               Sql.sql.clear;
               Sql.sql.add('UPDATE GENMAGASIN SET MAG_NOM=''TEST'', MAG_IDENT=''TEST'', MAG_IDENTCOURT=''TEST'', MAG_ENSEIGNE=''TEST''  WHERE MAG_NOM=''' + MAG + '''');
               Sql.execsql;
               if tran.InTransaction then
                  tran.Commit;
               Data.close;
            end;
            ini.free;
         end;
         Lab_Etat.Caption := 'Modification de vos chemins';
         Update;
         changeChemin;
         Application.messageBox('Traitement terminé', ' Fin', Mb_OK);
      end
      else
      begin
         Lab_Etat.Caption := 'Modification de vos chemins';
         Lab_Etat.visible := true;
         Update;
         changeChemin;
         Application.messageBox('Traitement terminé', ' Fin', Mb_OK);
      end;
   finally
      Screen.Cursor := crDefault;
   end;
   Close;
end;

end.


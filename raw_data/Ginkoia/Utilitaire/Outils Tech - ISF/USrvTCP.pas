unit USrvTCP;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   LMDCustomComponent, LMDWndProcComponent, LMDTrayIcon, StdCtrls, ExtCtrls,
   IniFiles;

type
   TFrm_SrvTCP = class(TForm)
      LMDTrayIcon1: TLMDTrayIcon;
      memo: TMemo;
      Timer1: TTimer;
      procedure LMDTrayIcon1DblClick(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      procedure Timer1Timer(Sender: TObject);
      //Fonction de lecture d'une valeur dans le fichier Ini
      FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String;
    procedure FormCreate(Sender: TObject);

   private
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Frm_SrvTCP: TFrm_SrvTCP;
   LecteurLame: string;

implementation

uses UVersion;

{$R *.DFM}

procedure TFrm_SrvTCP.FormCreate(Sender: TObject);
var
  sPathIni : string;
begin
  sPathIni := ChangeFileExt(Application.ExeName, '.ini');
  LecteurLame := LecteurValeurIni(sPathIni, 'GENERAL', 'LecteurLame', 'F');
  Frm_SrvTCP.Caption  := Frm_SrvTCP.Caption + '  -  V' + GetNumVersionSoft; 
end;

function TFrm_SrvTCP.LecteurValeurIni(AFileIni, ASection, AIdent,
  ADefault: String): String;
//Fonction de lecture d'une valeur dans le fichier Ini
Var
  FichierIni  : TIniFile;
begin
  Try
    //Ouverture ou création du fichier ini
    FichierIni  := TIniFile.Create(AFileIni);

    //Lecteur de la valeur
    Result := FichierIni.ReadString(ASection, AIdent, ADefault);
  Finally
    FichierIni.Free;
    FichierIni  := nil;
  End;
end;

procedure TFrm_SrvTCP.LMDTrayIcon1DblClick(Sender: TObject);
begin
   Show;
end;

procedure TFrm_SrvTCP.FormCloseQuery(Sender: TObject;
   var CanClose: Boolean);
begin
   CanClose := application.MessageBox('Si vous fermez cette application, le service technique ne vat plus pouvoir travailler', '   ATTENTION', mb_yesno or MB_DEFBUTTON2) = mryes;
   if not canclose then
      hide;
end;

procedure TFrm_SrvTCP.Timer1Timer(Sender: TObject);
var
   F: TSearchRec;
   tsl_pass: tstringlist;
   tsl: tstringlist;
   i, j: integer;
   fich: string;
   LastOrdre: string;
   prob: boolean;
begin
   Timer1.Enabled := false;
   if Timer1.Interval = 1000 then
      Memo.lines.add(DateTimeToStr(Now) + ' Démarrage ');
   try
      if FindFirst(LecteurLame+':\TECH\WEB\*.AAA', faAnyFile, F) = 0 then
      begin
         repeat
            Application.processMessages;
            if f.Attr and faDirectory <> faDirectory then
            begin
               if Uppercase(ExtractFileExt(f.name)) = '.AAA' then
               begin
                  sleep(1000);
                  Memo.lines.add(DateTimeToStr(Now) + ' Lancement de ' + ChangeFileExt(F.Name, '.cmd'));
                  DeleteFile(LecteurLame+':\TECH\WEB\' + ChangeFileExt(F.Name, '.cmd'));
                  RenameFile(LecteurLame+':\TECH\WEB\' + f.name, LecteurLame+':\TECH\WEB\' + ChangeFileExt(F.Name, '.cmd'));
                  Memo.lines.add(Inttostr(WinExec(PChar(LecteurLame+':\TECH\WEB\' + ChangeFileExt(F.Name, '.cmd')), 0)));
               end;
            end;
         until FindNext(f) <> 0;
      end;
      findclose(F);

      if FindFirst(LecteurLame+':\TECH\WEB\*.OOO', faAnyFile, F) = 0 then
      begin
         repeat
            Application.processMessages;
            if f.Attr and faDirectory <> faDirectory then
            begin
               if Uppercase(ExtractFileExt(f.name)) = '.OOO' then
               begin
                  sleep(1000);
                  prob := false;
                     // traitement spécifique
                  Memo.lines.add(DateTimeToStr(Now) + ' traitement de ' + ChangeFileExt(F.Name, ''));
                  tsl := tstringlist.create;
                  try
                     tsl.loadfromfile(F.Name);
                     DeleteFile(LecteurLame+':\TECH\WEB\' + F.Name);
                     i := 0;
                     while i < tsl.count do
                     begin
                        if tsl[i] = '[ADD XML]' then
                        begin
                           inc(i); // 1° ligne le fichier
                           fich := tsl[i]; inc(i);
                           Memo.lines.add('Ajout XML ' + fich);
                           tsl_pass := Tstringlist.create;
                           LastOrdre := 'ERREUR : Ouverture du fichier ' + fich;
                           try
                              tsl_pass.LoadFromFile(fich);
                              j := tsl_pass.count - 1;
                              while copy(trim(tsl_pass[j]), 1, 1) <> '<' do
                                 dec(j);
                              LastOrdre := 'ERREUR : Ajout des lignes au fichier ' + fich;
                              while tsl[i] <> '[FIN]' do
                              begin
                                 tsl_pass.Insert(j, tsl[i]);
                                 inc(j);
                                 inc(i);
                              end;
                              LastOrdre := 'ERREUR : Sauvegarde du fichier ' + fich;
                              tsl_pass.SaveToFile(fich);
                           except
                              prob := true;
                              Memo.lines.add(DateTimeToStr(Now) + LastOrdre);
                           end;
                           tsl_pass.free;
                           inc(i);
                        end
                        else inc(i);
                     end;
                  except
                     Memo.lines.add(DateTimeToStr(Now) + ' Erreur lecture ' + ChangeFileExt(F.Name, ''));
                     prob := true;
                  end;
                  if prob then
                  begin
                     tsl.clear;
                     tsl.add(LastOrdre);
                  end
                  else
                  begin
                     tsl.clear;
                     tsl.add('OK');
                  end;
                  tsl.SaveToFile(ChangeFileExt(F.Name, '.FINI'));
                  tsl.free;
               end;
            end;
         until FindNext(f) <> 0;
      end;
      findclose(F);
   except
      on E: Exception do
      begin
         Memo.lines.add(DateTimeToStr(Now) + ' Erreur ' + E.Message);
         Timer1.Enabled := true;
      end;
   end;
   Timer1.Interval := 100;
   Timer1.Enabled := true;
end;

end.


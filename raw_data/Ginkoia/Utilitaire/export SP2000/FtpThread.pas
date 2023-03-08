//$Log:
// 16   Utilitaires1.15        12/02/2013 17:17:47    Sylvain ROSSET  Ajout
//      fichier INI
// 15   Utilitaires1.14        14/10/2009 11:27:50    Lionel ABRY     Rollback
//      sur les modifs concernant mag_lastexp
// 14   Utilitaires1.13        13/10/2009 11:41:33    Lionel ABRY    
//      Correction probl?me maj mag_lastexp si plantage
// 13   Utilitaires1.12        17/06/2009 14:51:36    Lionel ABRY     Retour ?
//      la version migr?e
// 12   Utilitaires1.11        17/06/2009 14:29:11    Lionel ABRY    
//      S?paration D5-D11
// 11   Utilitaires1.10        12/06/2009 16:15:39    Lionel ABRY     Ajout
//      correction bug colombus :
//      Comme convenu par t?l?phone :
//      
//      Lors du traitement des transactions becollector et avant envoi a
//      Accentiv il faut exclure les transactions qui ne correspondent pas au
//      sch?ma suivant :
//      
//      N? de carte : champs num?rique de 13 caract?res num?riques (pas plus,
//      pas moins) commen?ant par 256 ou 258.
//      N? de coupon : champs num?rique de 13 caract?res num?riques (pas plus,
//      pas moins) commen?ant par 257 ou 259.
// 10   Utilitaires1.9         10/06/2009 11:01:44    Lionel ABRY    
//      migrationD2007 et correction de bug
// 9    Utilitaires1.8         11/03/2009 11:36:57    Florent CHEVILLON version
//      prod
// 8    Utilitaires1.7         19/02/2009 11:41:08    Florent CHEVILLON Version
//      avant test sur lame2
// 7    Utilitaires1.6         18/02/2009 13:17:34    Florent CHEVILLON Encours
//      de dev colombus
//      bug cr?ation fichiers
// 6    Utilitaires1.5         07/12/2006 15:40:19    pascal          recup des
//      b?tises diverses
// 5    Utilitaires1.4         05/12/2006 14:41:04    Sandrine MEDEIROS les
//      envois de fichiers ?taient en commentaire....
//      Changement de composant dans le thread
// 4    Utilitaires1.3         29/09/2006 09:32:58    Sandrine MEDEIROS mise en
//      place du Blade
// 3    Utilitaires1.2         27/10/2005 15:35:13    pascal          Modif
//      demand?es par sandrine
// 2    Utilitaires1.1         11/08/2005 11:40:26    pascal         
//      Modification suite echange de mail
// 1    Utilitaires1.0         08/08/2005 09:06:54    pascal          
//$
//$NoKeywords$
//
unit FtpThread;

interface

uses
   rxfileutil,
   sysutils,
   //NMFtp,
   windows,
   inifiles,
   Classes,
   idFtp;

type
   Tonfinifichier = procedure(fichier: string) of object;
   TFtpThread = class(TThread)
   private
    { Déclarations privées }
      NbrEssai: Integer;
      ListeFichier: TstringList;
      FTP: TIDFTP;
      //FTP: TNMFTP;   migration D2007
      LeFichier: string;
      Fonfinifichier: Tonfinifichier;
      procedure RecupFichier;
      procedure Setonfinifichier(const Value: Tonfinifichier);
   protected
      procedure Execute; override;
   public
      procedure Ajoute(S, S1: string);
      procedure remet;
      procedure ChangeFichier;
      function vide: boolean;
      constructor Create(AOwner: TComponent;IniFile : string);
      property onfinifichier: Tonfinifichier read Fonfinifichier write Setonfinifichier;
   end;

implementation

{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure TFtpThread.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end; }

{ TFtpThread }

procedure TFtpThread.Ajoute(S, S1: string);
begin
   ListeFichier.add(S + ';' + S1);
end;
//déplace le fichier dans le répertoire ok puis l'efface
procedure TFtpThread.ChangeFichier;
var
   dest: string;
begin
   LeFichier := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
   IF assigned(fonfinifichier) THEN onfinifichier(lefichier) ;
   dest := IncludeTrailingBackslash(extractfilepath(LeFichier)) + 'OK\';
   ForceDirectories(dest);
   dest := dest + extractfilename(Lefichier);
   if CopyFile(Pchar(lefichier), pchar(dest), true) then
      DeleteFile(Pchar(lefichier));
end;

constructor TFtpThread.Create(AOwner: TComponent;IniFile : string);
var
  ini : TIniFile;
begin
  inherited create(false);
  FreeOnTerminate := true;
  ListeFichier := TstringList.create;
  FTP := TIDFTP.create(AOwner);
  //FTP := TNMFTP.create(AOwner);      migration D2007
  //ftp.FirewallType := FTUser;          migration D2007
  //ftp.FWAuthenticate := false;        migration D2007
  ini := TIniFile.Create(IniFile);
  try
    ftp.Host := ini.ReadString('ftp', 'Host', '194.250.124.9');
    ftp.Username := ini.ReadString('ftp', 'Username', 'be-ginkoia');
    ftp.Password := ini.ReadString('ftp', 'Password', 'gk58mlpo');

    //On sauvegarde si jamais les valeurs ne sont pas présente dans l'ini
    ini.ReadString('ftp', 'Host', ftp.Host);
    ini.ReadString('ftp', 'Username', ftp.Username);
    ini.ReadString('ftp', 'Password', ftp.Password);
  finally
    FreeAndNil(ini);
  end;
//   ftp.Host := '192.168.10.3';       //T
//   ftp.Username := 'liveupdate';  //T
//   ftp.Password := 'live';   //T
   //ftp.UserID := 'be-ginkoia';         migration D2007
   //ftp.ParseList := false;
   ftp.Passive := True;
   ftp.Port := 21;
   ftp.ProxySettings.proxytype:=fpcmNone;
   ftp.ProxySettings.Port := 0;
   //ftp.ReportLevel := 0;          migration D2007
   //ftp.Vendor := 2411;         migration D2007
   ftp.autoLogin := true;  //migration D2007
   NbrEssai := 0;
   LeFichier := '';
end;

procedure TFtpThread.Execute;
var
   S: string;
   s1: string;
begin
  { Placez le code du thread ici}
  //thread FreeOnTerminate := true;

  //tant que des fichiers à traiter il continue
   while not Terminated do
   begin
      Synchronize(RecupFichier);
      if LeFichier <> '' then
      begin
         S1 := LeFichier;
         try
            FTP.Connect;
            //FTP.ChangeDir('SP2000');  //T
            S := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
            delete(LeFichier, 1, pos(';', LeFichier));
            FTP.put(S, LeFichier);
            FTP.disConnect;
            LeFichier := S1;
            Synchronize(ChangeFichier);
         except
            NbrEssai := NbrEssai + 1;
            if (NbrEssai < 15) then
            begin
               LeFichier := S1;
               Synchronize(remet);
            end;
         end;
         LeFichier := '';
      end;
   end;
end;

procedure TFtpThread.RecupFichier;
begin
   if ListeFichier.count > 0 then
   begin
      LeFichier := ListeFichier[0];
      ListeFichier.delete(0);
   end
   else
      LeFichier := '';
end;

procedure TFtpThread.remet;
begin
   ListeFichier.add(LeFichier);
end;

procedure TFtpThread.Setonfinifichier(const Value: Tonfinifichier);
begin
   Fonfinifichier := Value;
end;

function TFtpThread.vide: boolean;
begin
   result := (LeFichier = '') and (ListeFichier.count = 0);
end;

end.


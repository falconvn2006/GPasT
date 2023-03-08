//$Log:
// 2    Utilitaires1.1         02/10/2006 16:19:09    Sandrine MEDEIROS Modif
//      du ftp + envoie d'email
// 1    Utilitaires1.0         02/02/2006 09:21:55    pascal          
//$
//$NoKeywords$
//
unit FtpThread;

interface

uses
   fileutil,
   sysutils,
   NMFtp,
   windows,
   Classes;

type
   Tonfinifichier = procedure(fichier: string) of object;
   TFtpThread = class(TThread)
   private
    { Déclarations privées }
      NbrEssai: Integer;
      ListeFichier: TstringList;
      FTP: TNMFTP;
      LeFichier: string;
      Fonfinifichier: Tonfinifichier;
      ok: boolean;
      procedure RecupFichier;
      procedure Setonfinifichier(const Value: Tonfinifichier);
   protected
      procedure Execute; override;
      procedure Success(Trans_Type: TCmdType);
   public
      procedure Ajoute(S, S1: string);
      procedure remet;
      procedure ChangeFichier;
      function vide: boolean;
      constructor Create(AOwner: TComponent);
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

procedure TFtpThread.ChangeFichier;
begin
   LeFichier := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
   if assigned(fonfinifichier) then onfinifichier(lefichier);
   if ok then
   begin
      DeleteFile(Pchar(lefichier));
   end
end;

constructor TFtpThread.Create(AOwner: TComponent);
begin
   inherited create(false);
   FreeOnTerminate := true;
   ListeFichier := TstringList.create;
   FTP := TNMFTP.create(AOwner);
   ftp.FirewallType := FTUser;
   ftp.FWAuthenticate := false;
   ftp.Host := 'liveupdate.algol.fr';
   ftp.UserID := 'liveupdate';
   ftp.Password := 'live';
   ftp.ParseList := false;
   ftp.Passive := true;
   ftp.Port := 21;
   ftp.ProxyPort := 0;
   ftp.ReportLevel := 0;
   ftp.Vendor := 2411;
   ftp.OnSuccess := Success;
   NbrEssai := 0;
   LeFichier := '';
end;

procedure TFtpThread.Execute;
var
   S: string;
   s1: string;
   S2: string;
begin
  { Placez le code du thread ici}
   while not Terminated do
   begin
      Synchronize(RecupFichier);
      if LeFichier <> '' then
      begin
         S1 := LeFichier;
         try
            ok := false ;
            FTP.Connect;
            FTP.ChangeDir('PANTIN');
            S := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
            delete(LeFichier, 1, pos(';', LeFichier));
            S2 := LeFichier;
            LeFichier := S1;
            FTP.Upload(S, S2);
            FTP.disConnect;
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

procedure TFtpThread.Success(Trans_Type: TCmdType);
begin
   ok := true;
end;

function TFtpThread.vide: boolean;
begin
   result := (LeFichier = '') and (ListeFichier.count = 0);
end;

end.


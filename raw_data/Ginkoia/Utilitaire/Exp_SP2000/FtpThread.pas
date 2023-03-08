//$Log:
// 4    Utilitaires1.3         05/09/2011 10:33:37    Christophe HENRAT
//      Modification pour St?phane--> blocage envoi ftp
// 3    Utilitaires1.2         28/03/2011 10:37:28    Christophe HENRAT
//      Extraction des analyse synth?tique pour Sp2000 - Achat 2008
// 2    Utilitaires1.1         27/03/2011 22:38:55    Christophe HENRAT Passage
//      ? D2007+mis en erreur Fichiers<1Ko
// 1    Utilitaires1.0         22/10/2007 16:38:33    pascal          
//$
//$NoKeywords$
//
unit FtpThread;

interface

uses
   sysutils,
   windows,
   Classes,
   IdBaseComponent, IdComponent,
   IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
   IdFTP;

type
   Tonfinifichier = procedure(fichier: string) of object;

   TFtpThread = class(TThread)
   private
    { Déclarations privées }
      NbrEssai: Integer;
      ListeFichier: TstringList;
      FTP: TIdFTP;
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
      constructor Create(AOwner: TComponent; AHost, AUser, APass: string);
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
var
   dest: string;
begin
   LeFichier := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
   IF assigned(fonfinifichier) THEN onfinifichier(lefichier) ;
   dest := IncludeTrailingBackslash(extractfilepath(LeFichier)) + 'OK\';
   ForceDirectories(dest);
   dest := dest + extractfilename(Lefichier);
   if CopyFile(Pchar(lefichier), pchar(dest), False) then
      DeleteFile(Pchar(lefichier));
end;

constructor TFtpThread.Create(AOwner: TComponent; AHost, AUser, APass: string);
begin
   inherited create(false);
   FreeOnTerminate := true;
   ListeFichier := TstringList.create;
   FTP := TIdFTP.create(AOwner);


   ftp.Host := AHost;
   ftp.Username := AUser;
   ftp.Password := APass;
   Ftp.Passive := true;

  (* ftp.Host := '194.250.124.9';
   ftp.Username := 'be-ginkoia';
   ftp.Password := 'gk58mlpo';
   Ftp.Passive := true;  *)

  (* Ftp.Host := '192.168.30.96';
   Ftp.Username := 'Chris';
   Ftp.Password := '1082';
   Ftp.Passive := true;    *)

   NbrEssai := 0;
   LeFichier := '';
end;

procedure TFtpThread.Execute;
var
   S: string;
   s1: string;
begin
  { Placez le code du thread ici}
   while not Terminated do
   begin
      Synchronize(RecupFichier);
      if LeFichier <> '' then
      begin
         S1 := LeFichier;
         try
            FTP.Connect;
            Sleep(250) ;
            FTP.ChangeDir('GinkoiaExtract');
            Sleep(250) ;
            S := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
            delete(LeFichier, 1, pos(';', LeFichier));
            Ftp.Put(s, LeFichier);
            //FTP.Upload(S, LeFichier);
            Sleep(250) ;
            FTP.disConnect;
            LeFichier := S1;
            Synchronize(ChangeFichier);
            NbrEssai := 1 ;
            Sleep(1000) ;
         except           
            FTP.disConnect;
            NbrEssai := NbrEssai + 1;
            if (NbrEssai < 15) then
            begin
               LeFichier := S1;
               Synchronize(remet);
               Sleep(1000) ;
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


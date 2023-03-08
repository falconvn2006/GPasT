UNIT FtpThread;

INTERFACE

USES
    NMFtp,
    Classes;

TYPE
    TFtpThread = CLASS(TThread)
    PRIVATE
    { Déclarations privées }
        ListeFichier: TstringList;
        FTP: TNMFTP;
        LeFichier: STRING;
        dest:string;
        PROCEDURE RecupFichier;
    PROTECTED
        PROCEDURE Execute; OVERRIDE;
    PUBLIC
        PROCEDURE Ajoute(S, S1: STRING);
        FUNCTION vide: boolean;
        PROCEDURE init(user,mp,host,desti :string);
        CONSTRUCTOR Create(AOwner: TComponent);
    END;

IMPLEMENTATION

{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure TFtpThread.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end; }

{ TFtpThread }

PROCEDURE TFtpThread.Ajoute(S, S1: STRING);
BEGIN
    ListeFichier.add(S + ';' + S1);
END;

CONSTRUCTOR TFtpThread.Create(AOwner: TComponent);
BEGIN
    INHERITED create(false);
    FreeOnTerminate := true;
    ListeFichier := TstringList.create;
    FTP := TNMFTP.create(AOwner);
    ftp.FirewallType := FTUser;
    ftp.FWAuthenticate := false;
    //ftp.Host := 'ftp.npd.com';
    ftp.ParseList := false;
    ftp.Passive := true; //false;
    //ftp.Password := 'panyivca';
    ftp.Port := 21;
    ftp.ProxyPort := 0;
    ftp.ReportLevel := 0;
    //ftp.UserID := 'algol';
    ftp.Vendor := 2411;

    LeFichier := '';
END;

PROCEDURE TFtpThread.init(user,mp,host,desti :string);
begin
    ftp.Host := host;
    ftp.Password := mp;
    ftp.UserID := user;
    dest:=desti;
END;



PROCEDURE TFtpThread.Execute;
VAR
    S: STRING;
BEGIN
  { Placez le code du thread ici}
    WHILE NOT Terminated DO
    BEGIN
        Synchronize(RecupFichier);
        IF LeFichier <> '' THEN
        BEGIN
            FTP.Connect;
            //FTP.ChangeDir('/data.in/');
            FTP.ChangeDir(dest);
            S := Copy(LeFichier, 1, pos(';', LeFichier) - 1);
            delete(LeFichier, 1, pos(';', LeFichier));
            FTP.Upload(S, LeFichier);
            FTP.disConnect;
            LeFichier := '';
        END;
    END;
END;

PROCEDURE TFtpThread.RecupFichier;
BEGIN
    IF ListeFichier.count > 0 THEN
    BEGIN
        LeFichier := ListeFichier[0];
        ListeFichier.delete(0);
    END
    ELSE
        LeFichier := '';
END;

FUNCTION TFtpThread.vide: boolean;
BEGIN
    result := (LeFichier = '') AND (ListeFichier.count = 0);
END;

END.



unit UTransfert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    //Perso
  IdSMTP,
  IdMessage,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  idFtpCommon,
  IdFTP,
  SBSimpleFTPS,
  SBTypes,
  SBUtils,
  DateUtils,
  IBServices,
  //
  Dialogs, ZipMstr19, SBSSLCommon, SBSocket, DB, IBCustomDataSet, IBQuery,
  IBDatabase, StdCtrls;

type
  TForm1 = class(TForm)
    ZipMaster191: TZipMaster19;
    Base: TIBDatabase;
    Transaction: TIBTransaction;
    Query: TIBQuery;
    Gbx_FTP: TGroupBox;
    edt_FTPPassword: TEdit;
    Lab_FTPPassword: TLabel;
    edt_FTPLogin: TEdit;
    Lab_FTPLogin: TLabel;
    edt_FTPServeur: TEdit;
    Lab_FTPServeur: TLabel;
    Lab_FTPPath: TLabel;
    edt_FTPPath: TEdit;
    Lab_ZipFileName: TLabel;
    edt_ZipFileName: TEdit;
    Gbx_Local: TGroupBox;
    Lab_LocalPath: TLabel;
    edt_LocalPath: TEdit;
    Lab_LocalBaseName: TLabel;
    edt_LocalBaseName: TEdit;
    FTP: TElSimpleFTPSClient;
    procedure FormShow(Sender: TObject);
  private
    procedure SendEmail(const Recipients: string; const Subject: string; const Body: string);
    procedure FTPGetAFile;
    procedure FTPUploadFile(const sFileName:string);
    procedure DeZip;
    function GetStart(const iBasIdent:Integer):Boolean;
    function RestoreBase(AFileBase, AFileBack, AFileLog: string): boolean;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

const
//  FTP_HOST = '195.46.212.62';
//  FTP_USER = 'data_INTERSYS';
//  FTP_PWD = 'Ppjxj3A1';
//  PATH_FILE_LOCAL = 'D:\Ginkoia\Data\LECLER-Migration.zip';
//  PATH_FILE_FTP = 'Bases/LECLER-Apr_migration.zip';
//  PATH_FOLDER_LOCAL = 'D:\Ginkoia\Data\';
//  MAIL_ACCOUNT  = 'dev@ginkoia.fr'; // Votre compte Mail
//  MAIL_PASSWORD = 'Toru682674';     // Votre mot de passe Mail
//  MAIL_HOST     = 'pod51015.outlook.com';
//  MAIL_PORT     = 587;

  FTP_HOST = '195.46.212.62';
  FTP_USER = 'data_INTERSYS';
  FTP_PWD = 'Ppjxj3A1';
  PATH_FILE_LOCAL = 'D:\Ginkoia\Data\ANDALI-Migration.zip';
  PATH_FILE_FTP = 'Bases/ANDALI-Apr_migration.zip';
  PATH_FOLDER_LOCAL = 'D:\Ginkoia\Data\';
  PATH_FICHIER_SVG = 'ANDALI-Apr_migration.ibk';
  PATH_FICHIER_BASE = 'ANDALI_migration.ib';
  MAIL_DESTINATAIRES = 'benoit.python@ginkoia.fr;admin@ginkoia.fr';
  MAIL_ACCOUNT  = 'dev@ginkoia.fr'; // Votre compte Mail
  MAIL_PASSWORD = 'Toru682674';     // Votre mot de passe Mail
  MAIL_HOST     = 'pod51015.outlook.com';
  MAIL_PORT     = 587;

implementation

{$R *.dfm}


procedure TForm1.SendEmail(const Recipients: string; const Subject: string; const Body: string);
var
  SMTP        : TIdSMTP;
  IdMessage   : TIdMessage;
  IdSSL       : TIdSSLIOHandlerSocketOpenSSL;
begin
  SMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Try
    Try
      IdSSL.SSLOptions.Method    := sslvTLSv1;
      IdSSL.SSLOptions.Mode      := sslmUnassigned;

      IdMessage.Clear;
      IdMessage.ContentType := 'multipart/mixed';
      IdMessage.Subject := Format('%s - %s ',[Subject, FormatDateTime('DD/MM/YYYY à hh:mm:ss',Now)]);
      IdMessage.Body.Text := Body;

      IdMessage.From.Text := MAIL_ACCOUNT;
      IdMessage.Recipients.EMailAddresses := Recipients;

      SMTP.IOHandler  := IdSSL;
      SMTP.UseTLS     := utUseExplicitTLS;
      SMTP.Host       := MAIL_HOST;
      SMTP.Username   := MAIL_ACCOUNT;
      SMTP.Password   := MAIL_PASSWORD;

      Try
        SMTP.Port := MAIL_PORT;
        SMTP.Connect;
      Except on E:Exception do
        begin
          try
            SMTP.Port := 25;
            SMTP.Connect;
          Except
          end;
        end;
      End;

      SMTP.Send(IdMessage);

    Except
    End;
  finally
    SMTP.Free;
    IdMessage.Free;
    IdSSL.Free;
    if SMTP.Connected then
      SMTP.Disconnect(True);
  End;
end;

procedure TForm1.FTPGetAFile;
BEGIN
    // Au cas ou...
    IF FTP.Active THEN
    BEGIN
      // Dans le doute
      FTP.Abort;
      FTP.Close;
    END;

    FTP.Address := FTP_HOST;
    FTP.Username := FTP_USER;
    FTP.Password := FTP_PWD;
    FTP.Port := 21;

    TRY
      FTP.Open;
      IF FTP.Active THEN
      BEGIN
        FTP.Login;
      END;
    EXCEPT
      ON E: Exception DO
      BEGIN
        // Erreur à la connection, on log
      END;
    END;

    IF FileExists(PATH_FILE_LOCAL) THEN
    BEGIN
      // on l'a déjà, on la retélécharge, le fichier du FTP est le plus fiable
      DeleteFile(PATH_FILE_LOCAL);
    END;

    FTP.DownloadFile(PATH_FILE_FTP, PATH_FILE_LOCAL, ftmOverwrite);

    FTP.Close;
END;

procedure TForm1.FTPUploadFile(const sFileName:string);
BEGIN
  // Au cas ou...
  IF FTP.Active THEN
  BEGIN
    // Dans le doute
    FTP.Abort;
    FTP.Close;
  END;

  FTP.Address := FTP_HOST;
  FTP.Username := FTP_USER;
  FTP.Password := FTP_PWD;
  FTP.Port := 21;

  TRY
    FTP.Open;
    IF FTP.Active THEN
    BEGIN
      FTP.Login;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // Erreur à la connection, on log
    END;
  END;

  FTP.UploadFile(ExtractFilePath(Application.ExeName) + sFileName, 'Bases/' + sFileName, ftmOverwrite);

  FTP.Close;
end;

function TForm1.GetStart(const iBasIdent:Integer):Boolean;
// SERVEUR_COLMAR_2769_LECLERC				                1
// SERVEUR_MONTBELIARD_2621_LECLERC		                2
// SERVEUR_ILLZACH_2811_LECLERC			                  3
// SERVEUR_SAINT-LOUIS_2903_LECLERC		                4
// SERVEUR_ANDELMANS_2914_LECLERC			                5
// SERVEUR_GILLY-SUR-ISERE_2647_LECLERC	              6
// SERVEUR_CHALON-SUR-SAONE_2662_LECLERC	            7
// SERVEUR_PREMILHAT_2656_LECLERC			                8
// SERVEUR_AUXERRE_2664_LECLERC			                  16
// SERVEUR_CHAMBERY_2663_LECLERC			                18
// SERVEUR_COSNE_2643_LECLERC				                  20
// SERVEUR_ARBENT_2687_LECLERC				                21
// SERVEUR_ST-CLEMENT_2642_LECLERC			              22
// SERVEUR_ST-JEAN-MAURIENNE_2652_LECLERC	            23
// SERVEUR_THIERS_2646_LECLERC				                24
// SERVEUR_ALBERTVILLE_3463_LECLERC		                25
// SERVEUR_ALBERTVILLE_2651_LECLERC		                26
// SERVEUR-ADMIN_PREMILHAT_2656_LECLERC	              27
// SERVEUR_SENS_3787_LECLERC				                  37
// SERVEUR_COLLECTIVITE_CHALON-SUR-SAONE_2662_LECLERC	41

// SERVEUR_AUTUN_2828_ANDALI                1
// SERVEUR_MOULINS_2912_ANDALI              2
// SERVEUR_MONTCEAU-LES-MINES_2592_ANDALI   3
// SERVEUR_PARAY-LE-MONIAL_2911_ANDALI      4
// SERVEUR_LE-CREUSOT_2939_ANDALI           5
// SERVEUR_SAINT-DIZIER_3552_ANDALI         6
// SERVEUR-ADMIN_AUTUN_2828_ANDALI          7
// SERVEUR_TERVILLE_3748_ANDALI            13
// SERVEUR_DORLISHEIM_2729_ANDALI          19
// SERVEUR_SCHWEIGHOUSE_2767_ANDALI        21
// SERVEUR_ADMIN-SCHWEIGHOUSE_2778_ANDALI	24
// SERVEUR_SARREBOURG_4147_ANDALI	        36
// SERVEUR_DOMMARTIN_7048_ANDALI	          41
// SERVEUR_ESSEY_7047_ANDALI	              42
// SERVEUR_NANCY_7046_ANDALI	              43

var
  datetraitement : TDateTime;
begin
  Result := False;
  datetraitement := date;
  case iBasIdent of
    1 : Result := True;
    2, 3, 4 :
      begin
        datetraitement := datetraitement + StrToTime('20:00:00');
        while (now - datetraitement) < 0 do
        begin
          Sleep(1800000);
        end;
        Result := True;
      end;
    5, 6, 7, 13 :
      begin
        datetraitement := datetraitement + StrToTime('21:15:00');
        while (now - datetraitement) < 0 do
        begin
          Sleep(1800000);
        end;
        Result := True;
      end;
    19, 21, 24, 36 :
      begin
        datetraitement := datetraitement + StrToTime('22:30:00');
        while (now - datetraitement) < 0 do
        begin
          Sleep(1800000);
        end;
        Result := True;
      end;
    41, 42, 43 :
      begin
        datetraitement := datetraitement + StrToTime('23:45:00');
        while (now - datetraitement) < 0 do
        begin
          Sleep(1800000);
        end;
        Result := True;
      end;
  end;
end;

procedure TForm1.DeZip;
var
  Idx: Integer;
  ZM: TZipMaster19;
begin
  ZM := TZipMaster19.Create(nil);
  try
    ZM.ZipFileName := PATH_FILE_LOCAL;
    if ZM.ErrCode <> 0 then
      raise Exception.Create('Invalid zip file: ' + ZM.ErrMessage);
    Idx := -1; // search from beginning
    if ZM.Find(PATH_FICHIER_SVG, Idx) <> nil then
    begin
      ZM.ExtrBaseDir := PATH_FOLDER_LOCAL; // a safe destination for file
      // extract <SafePath>\testb.txt
      if ZM.Extract <> 0 then
        raise Exception.Create('Unzip error: ' + ZM.ErrMessage);
    end;
  finally
    ZM.Free;
  end;
end;

function TForm1.RestoreBase(AFileBase, AFileBack, AFileLog: string): boolean;
var
  IbRestore: TIBRestoreService;
  OkLog: boolean;
  sLigne: string;
  LstLog: TStringList;
begin
  Result := True;
  // OkLog := (ALogProc<>nil);
  OkLog := true;
  LstLog := TStringList.Create;
  IbRestore := TIBRestoreService.Create(Self);
  try
    try
      IbRestore.Params.Clear;
      IbRestore.Params.Add('user_name=sysdba');
      IbRestore.Params.Add('password=masterkey');

      IbRestore.BackupFile.Clear;
      IbRestore.BackupFile.Add(AFileBack);

      ibRestore.DatabaseName.Clear;
      ibRestore.DatabaseName.Add(AFileBase);

      ibRestore.LoginPrompt := False;
      ibRestore.Verbose     := OkLog;

      ibRestore.Active := True;
      ibRestore.ServiceStart;

      if OkLog then
      begin
        while not ibRestore.Eof do
        begin
          sLigne := ibRestore.GetNextLine;
          if Pos('GBAK: ERROR', sLigne)>0 then
            Result := false;
          LstLog.Add(sLigne);
        end;
      end;

    except
      on E: exception do
      begin
        sLigne := DateTimeToStr(Now) + '  Exception : ' + e.message;
        LstLog.Add(DateTimeToStr(Now) + '  Exception : ' + e.message);
        LstLog.Add('');
        Result := False;
      end;
    end;
  finally
    ibRestore.Active := False;
    if not(Result) and (AFileLog<>'') then
    begin
      try
        LstLog.SaveToFile(AFileLog);
      except
      end;
    end;
    FreeAndNil(LstLog);
    FreeAndNil(ibRestore);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  vSLTraceur: TStringList;
  dDebut, dFin : TDateTime;
  sNom_Base : string;
  iBasIdent : Integer;
begin
  Base.Connected := True;
  Transaction.Active := True;
  Query.Open;
  sNom_Base := Query.FieldByName('BAS_NOM').AsString;
  iBasIdent := Query.FieldByName('BAS_IDENT').AsInteger;
  Query.Close;
  Transaction.Active := False;
  Base.Connected := False;

  if GetStart(iBasIdent) then
  begin
    vSLTraceur:= TStringList.Create;
    try
      //Get File
      dDebut := Now;
      FTPGetAFile;
      dFin := Now;
      vSLTraceur.Add('Début téléchargement : ' + DateTimeToStr(dDebut));
      vSLTraceur.Add(' - Temps du téléchargement en s : ' + FloatToStr(SecondsBetween(dFin, dDebut)));

      //Unzip
      dDebut := Now;
      DeZip;
      dFin := Now;
      vSLTraceur.Add(' - Début dé zip : ' + DateTimeToStr(dDebut));
      vSLTraceur.Add(' - Temps du Dé zip en s : ' + FloatToStr(SecondsBetween(dFin, dDebut)));

      //Restore
      dDebut := Now;
      RestoreBase(
        PATH_FOLDER_LOCAL + PATH_FICHIER_BASE,
        PATH_FOLDER_LOCAL + PATH_FICHIER_SVG,
        PATH_FOLDER_LOCAL + 'Log_Restore_Test.Log');
      dFin := Now;
      vSLTraceur.Add(' - Début restore base : ' + DateTimeToStr(dDebut));
      vSLTraceur.Add(' - Temps du restore en s : ' + FloatToStr(SecondsBetween(dFin, dDebut)));

      //Mail
      SendEmail(MAIL_DESTINATAIRES, 'Download Migration - ' + sNom_Base , vSLTraceur.Text);

    finally
      vSLTraceur.SaveToFile(ExtractFilePath(Application.ExeName) + 'Log_Traitement-' + sNom_Base + '.log');
      FTPUploadFile('Log_Traitement-' + sNom_Base + '.log');
      FreeAndNil(vSLTraceur);
    end;
  end;
  Form1.Close;
end;

initialization
  SetLicenseKey('4FDA4556348ED2F45F1A6BE199EFA3FC3E0762DC70E138047C3B51E1E80AF73E'
              + '93572E6216C39B769CEC821C38E3F660EF222820EB6DC3EC912C5A390AED971F'
              + 'A50EEC92E376F7E22023CC1D530D5D371DCDDE03227F87D3F3D4826E2D6AA06D'
              + 'B50E61E257CDFE8E765407EAE1E0F1FDBB1B4FF9990A0F04F9FA64A8FAC82136'
              + '403D6B107DD4D7F48D72AB0F923FB45983BAA94A86FDE7E694D1BA649DD3564F'
              + '77AB88F07594D1B395FF0AC6A83699F048F23D6473D086BB5BE09F753CDE3694'
              + 'CCED24109146D7750699FDDEB53BE57951D0326B185A592E9BB3BAE89260237D'
              + '7C3198B98FDC6C7997AF9E673F307FAADE5D04FF8646E4E7B9059B6285390C8C');

end.


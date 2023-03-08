unit EldosFTPS_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  SBSimpleFTPS, SBX509, SBCustomCertStorage, SBSSLCommon, SBSSLConstants,
  SBWinCertStorage, SBLicenseManager, SBTypes, SBUtils, StrUtils, ExtCtrls;

const
   SSL_CA_ZLIB = 1;

type
  TFrm_EldosFTPS = class(TForm)
    ElMemoryCertStorage: TElMemoryCertStorage;
    ElWinCertStorage: TElWinCertStorage;
    ElSBLicenseManager1: TElSBLicenseManager;
    Timer1: TTimer;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
    FClient : TElSimpleFTPSClient;
    FCert : TElX509Certificate;
    AClientSSLError : String;
    procedure ClientSSLError(Sender : TObject; ErrorCode: integer; Fatal: boolean; Remote : boolean);
  public
    { Déclarations publiques }
    procedure EnregistrerLog(ALogFile, AInfo : string);
    function SendFileByFTPS(Adresse, UserName, Password, SourceFileName, DestinationFileName : String; Var ErrorTxt : String) : Boolean;
  end;

var
  Frm_EldosFTPS: TFrm_EldosFTPS;

implementation

{$R *.dfm}

procedure TFrm_EldosFTPS.EnregistrerLog(ALogFile, AInfo: string);
var
  MyFile : TextFile;
  AString : String;
begin
  TRY
    AssignFile(MyFile,ALogFile);
    Append(MyFile);
    AString := '['+FormatDateTime('dd/mm/yyyy hh:nn:ss',now)+']: ' + AInfo + #13#10;
    WriteLN(MyFile, AString);
  FINALLY
    CloseFile(MyFile);
  END;
end;

procedure TFrm_EldosFTPS.FormCreate(Sender: TObject);
var
//  AString : String;
  AString, FilePath, ExistingFileName, NewFileName, ALogFile : String;
  MyFile1, MyFile2 : TextFile;
  AErrorTexte, Adresse, User, Pwd : String;
  IsOK : Boolean;
  I, J, K, L : Integer;
begin
  Timer1.Enabled := False;
//ParamStr0=C:\Developpement\Ginkoia\EldosFTPS.exe
//ParamStr1=ftp://abaques:4b4qu3s@abaques.ginkoia.net
//ParamStr2=C:\Developpement\Ginkoia\LOG_Ginkoia\2016-09-19_12-29-02_{823C60CD-D234-4C41-8E38-5A48510B0A14}_BUREAU1.txt
//ParamStr3=C:\Developpement\Ginkoia\LOG_Ginkoia\LOG_Ginkoia-2016-09-19.txt

  Memo1.Lines.add('ParamStr0='+ParamStr(0));
  Memo1.Lines.add('ParamStr1='+ParamStr(1));
  Memo1.Lines.add('ParamStr2='+ParamStr(2));
  Memo1.Lines.add('ParamStr3='+ParamStr(3));
  AString := ParamStr(1);
  ExistingFileName := ParamStr(2);
  NewFileName := ExtractFileName(ExistingFileName);
  ALogFile := ParamStr(3);

// Pour Test  
//AString:='ftp://abaques:4b4qu3s@abaques.ginkoia.net';
//ExistingFileName:='C:\Developpement\Ginkoia\LOG_Ginkoia\2016-09-26_15-57-41_{823C60CD-D234-4C41-8E38-5A48510B0A14}_BUREAU1.txt';
//NewFileName := ExtractFileName(ExistingFileName);
//ALogFile:= 'C:\Developpement\Ginkoia\LOG_Ginkoia\LOG_Ginkoia-2016-09-26.txt';


  if AString <> '' then
  begin
    // ftp://abaques:4b4qu3s@abaques.ginkoia.net //
    IsOK := True;
    I := Pos('ftp://',AString);
    J := Pos(':',copy(AString,7,length(AString)-6)) + 6;
    K := Pos('@',AString);
    L := Pos('.',AString);

    if (I = 1) and (J > 0) and (J > I + 6) and (K > 0) and (K > J + 1) and (L > 0) and (L > K + 1)  then
    begin
      Adresse := Copy(AString,K+1,length(AString)-K);
      User := copy(AString,7,J-7);
      Pwd := copy(AString,J+1,K-J-1);

      AErrorTexte := ' Envoi FTP fichier Log Abaques : ';
      TRY
        AString := '';
        if Frm_EldosFTPS.SendFileByFTPS(Adresse, User, Pwd, ExistingFileName, NewFileName , AString) = True then
        begin
          AErrorTexte := ' Supprime fichier Log Abaque envoyé: ';
          DeleteFile(ExistingFileName);
        end
        else EnregistrerLog(ALogFile, NewFileName + AErrorTexte + AString);
      EXCEPT
        on E: Exception do
          EnregistrerLog(ALogFile, NewFileName + AErrorTexte + E.Message);
      END;
    end
    else EnregistrerLog(ALogFile, ' Adresse FTP erronnée : doit être de la forme "ftp://UserName:password@networkAddress"');
  end;
  Timer1.Enabled := True;
end;

function TFrm_EldosFTPS.SendFileByFTPS(Adresse, UserName, Password, SourceFileName, DestinationFileName : String; Var ErrorTxt : String) : Boolean;
var
  FDataStream : TStream;
  AErrorTitle : String;
begin
  FClient := TElSimpleFTPSClient.Create(nil);
  try
    FCert := TElX509Certificate.Create(nil);
    FClient.OnSSLError := ClientSSLError;
    FClient.CertStorage := ElWinCertStorage;

    FClient.Address := Adresse;
    FClient.Port := 21;
    FClient.Username := UserName;
    FClient.Password := Password;
    FClient.CompressionAlgorithms[SSL_CA_ZLIB] := False;
    FClient.Versions := FClient.Versions + [sbTLS1] + [sbTLS11] + [sbTLS12];

    FClient.UseSSL := False;
    FClient.EncryptDataChannel := True;
    FClient.AuthCmd := acAuto;
    FClient.PassiveMode := False;
    FClient.SSLMode := smExplicit;
    ElMemoryCertStorage.Clear;

    AClientSSLError := '';
    AErrorTitle := 'Open/Login : ';
    try
      FClient.Open;
      FClient.Login;

    except
      on E: Exception do
        ErrorTxt := AErrorTitle + AClientSSLError + E.Message;
    end;

    AErrorTitle := 'Ouverture flux de données : ';
    try
      FDataStream := TFileStream.Create(SourceFileName, fmOpenRead or fmShareDenyWrite);
      try
        AErrorTitle := 'Envoi FTP : ';
        try
          FClient.Send(FDataStream, Trim(DestinationFileName), 0, FDataStream.Size - 1, false, 0);
          result := True;
        except
          on E : EElOperationCancelledError do
            ErrorTxt := AErrorTitle + AClientSSLError + E.Message;
        end;
      finally
        FreeAndNil(FDataStream);
      end;
    except
      on E : Exception do
        ErrorTxt := AErrorTitle + AClientSSLError + E.Message ;
    end;

    AErrorTitle := 'Close FTP : ';
    try
      FClient.Close(true);
    except
      on E: Exception do
        ErrorTxt := AErrorTitle + AClientSSLError + E.Message ;
    end;

  finally
     FreeAndNil(FClient);
  end;
end;

procedure TFrm_EldosFTPS.Timer1Timer(Sender: TObject);
begin
  Frm_EldosFTPS.Close;
end;

procedure TFrm_EldosFTPS.ClientSSLError(Sender: TObject; ErrorCode: integer; Fatal, Remote: boolean);
var
  S : string;
begin
  if Fatal then
    S := 'Fatal '
  else
    S := '';
  if Remote then
    S := S + 'Remote '
  else
    S := s + 'Local ';

  S := S + 'Error ' + IntToStr(ErrorCode);
  AClientSSLError := S;
//  Log('If you are getting error 75778, this can mean that the remote server doesn''t support specified SSL/TLS version', true);
end;

end.

unit R2D2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, 
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3,
  IdSMTPBase, IdSMTP,  IdSASL,
  IdSASLAnonymous, IdSASLUserPass, IdSASLLogin, IdSASLOTP, IdSASL_CRAMBase,
  IdSASL_CRAM_MD5, IdSASL_CRAM_SHA1, IdSASLPlain, IdSASLSKey, IdUserPassProvider,
  IdMessage, IdText, IdAttachmentfile    ;



const 
 SASLAnonymous = 0 ;
 SASLCRAMMD5 = 1 ;
 SASLCRAMSHA1 = 2 ;
 SASLOTP =3;
 SASLLogin =4 ;
 SASLPlain = 5 ;
 SASLSKey = 6 ;



Type
 TAccount = Class(Tobject) 
   private
   FUsername : string ;
   FPassword : string ;
   FHost : string ;
   FPort : integer ;
   FLoginAs : string ;

   public
    Constructor Create(User, Pwd, Logas : string) ; 
    Destructor Free ; 

   property Username : string read Fusername write Fusername ;
   property Password : string read Fpassword write Fpassword ;
   property Host : string read FHost write Fhost ;
   property Port : integer read FPort write Fport ;
   property LoginAs : string read FloginAs write FloginAs ;
  end ;  
  

Tpop3Client = Class(Tobject)
   Private 
     idPop3 : TIdPOP3 ;
     Faccount : TAccount ;
     bSSl : boolean ;
   public

   Constructor Create(Account : TAccount; bsl : boolean) ;
   Destructor Free ;

   function PrepareSASL(sMOde : Integer) : boolean ;  // mode est une des constantes ci dessus
   function PrepareUserPass : boolean ;

   // procedure pour faciliter l'écriture
   // if faut trapper les erreurs dans le programme
   procedure Connect ;
   function Connected : boolean ;
   procedure Disconnect ;
   function Checkmessages : integer ;

   property Pop3 : TidPOP3 read idPop3 ;
   property SSL  : boolean  read bSSl write bssl ;
   
End;


TSmtpClient = Class(TObject)
  Private
    idSmtp : TidSmtp ;
    FAccount : TAccount ;
  Public
    Constructor Create(Account : TAccount) ;
    Destructor  Free ; 


    procedure Connect ;
    function Connected : boolean ;
    procedure Disconnect ;
    procedure Send(idMsg : TidMessage) ;
    


    property Smtp : TidSmtp  read idSmtp ;
    
End;



// Decode les messages avec attachements  et retourne le nom du fichier sauvegardé dans sPath
Function DecodeMessage(idMess : Tidmessage ; sPath : string; Resa : integer; var sFileName : String) : boolean;
  
   
implementation

{**************************************************Classe SMTP*****************************************************}
Constructor TSmtpClient.Create(Account: TAccount);
var SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  FAccount := Account ;
  idSmtp := TidSmtp.Create(nil);
  SSLHandler   := TIdSSLIOHandlerSocketOpenSSL.Create(); //  SSL Handler
  With idSmtp do
   begin
     IOHandler := SSLHandler ;
     AuthType := satDefault ;
     MailAgent := 'Ginkoia' ;
     UseTLS := utUseExplicitTLS ;
     ValidateAuthLoginCapability := True ;
     Host := Faccount.Host ;
     Username :=  Faccount.Username ;
     Password :=  Faccount.Password ;
     Port :=  Faccount.Port ;
   end;
end;

Destructor TSmtpClient.Free ;
begin
Try
  idSmtp.Disconnect;
  idSmtp.Free ;
Except
End;
end;
//*************************************************helpers********************************************************//
Procedure TSmtpClient.Connect;
begin
  idSmtp.Connect ;
end;


function TSmtpClient.Connected;
begin
  result := idSmtp.Connected ;
end;

procedure TSmtpClient.Disconnect;
begin
   idSmtp.Disconnect;
end;

procedure TSmtpClient.Send(idMsg: TIdMessage);
begin
  idSmtp.Send(idMsg);
end;



{***************************************************Classe POP 3****************************************************}
Constructor TPop3Client.Create(Account : Taccount; bSl : boolean) ;
begin
  idPop3 := TIdPOP3.Create(nil);
  Faccount := Account ;
  bSSL := bSl ;
end;


Destructor Tpop3Client.Free;
begin
Try
  idPop3.Disconnect ;
  idPop3.Free ;
Except
End;
end;




function TPop3Client.PrepareSASL(sMode : integer) : boolean;
var
 SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
 sasl_anonymous : TIdSASLAnonymous;
 sasl_md5       : TIdSASLCRAMMD5 ;
 sasl_sh1       : TIdSASLCRAMSHA1;
 sasl_otp       : TIdSASLOTP ;
 sasl_login     : TIdSASLLogin ;
 sasl_plain     : TIdSASLPlain ;
 sasl_key       : TIdSASLSKey ;
 user_pass      :  TIdUserPassProvider;
begin
  result := True ;
  TRY
    if bSSL then
     begin
        // utilisation du SSL
        SSLHandler   := TIdSSLIOHandlerSocketOpenSSL.Create(); //  SSL Handler
        idPOP3.IOHandler := SSLHandler; // affectation du SSLHandler
        idPOP3.UseTLS    := TIdUseTLS(utUseImplicitTLS); // en mode implicite 
     end else
     begin
        idPOP3.UseTLS := utNoTLSSupport ; // pas de SSL
     end;

    with idPOP3 do
    begin
      AutoLogin      := True ;
      ConnectTimeout := 2500; 
      Username       := FAccount.Username; // Username 
      Password       := FAccount.Password; // Password 
      Host           := FAccount.Host; // Host
      Port           := FAccount.Port; // Port
      if bSSL then
       begin
        AuthType := patSASL ; // authentification pour SSL
       end else
        AuthType :=    patUserPass ;
      { TIdPOP3AuthenticationType = (patUserPass, patAPOP, patSASL); }
    end;

    if idPOP3.AuthType = patSASL then
    begin
 
      user_pass := TIdUserPassProvider.Create(nil); // Username and Paswword Login
 
      with user_pass do
      begin
        Username := FAccount.Username;
        Password := FAccount.Password;
      end;
 
      case sMode of
        SASLAnonymous:
          begin // Anonymous
            sasl_anonymous := TIdSASLAnonymous.Create(nil);
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_anonymous);
          end;
 
        SASLCRAMMD5:
          begin // Cramm MD5
            sasl_md5 := TIdSASLCRAMMD5.Create(nil);
            sasl_md5.UserPassProvider  := user_pass;
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_md5);
          end;
        SASLCRAMSHA1:
          begin // Cramm SH1
            sasl_sh1  := TIdSASLCRAMSHA1.Create(nil);
            sasl_sh1.UserPassProvider := user_pass;
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_sh1);
          end;
 
        SASLOTP:
          begin // SASL Otp
            sasl_otp    := TIdSASLOTP.Create(nil);
            sasl_otp.UserPassProvider := user_pass;
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_otp);
          end;
 
        SASLLogin:
          begin // SASL Login
            sasl_login := TIdSASLLogin.Create(nil);
            sasl_login.UserPassProvider    := user_pass;
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_login);
          end;
 
        SASLPlain:
          begin // SASL Plain
            sasl_plain                     := TIdSASLPlain.Create(nil);
            sasl_plain.UserPassProvider    := user_pass;
            sasl_plain.LoginAs             := FAccount.LoginAs;
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_plain);
          end;
 
        SASLSKey:
          begin // SASL Key
            sasl_key := TIdSASLSKey.Create(nil);
            sasl_key.UserPassProvider := user_pass;
            idPOP3.SASLMechanisms.Add.SASL := tidsasl(sasl_key);
          end;
      end;
 
    end;    
     
    
  EXCEPT
    Result := false ;
  END;
end;


function TPop3Client.PrepareUserPass : boolean;
var
 SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  result := True ;
  TRY
    if bSSL then
     begin
        // utilisation du SSL
        SSLHandler   := TIdSSLIOHandlerSocketOpenSSL.Create(); //  SSL Handler
        idPOP3.IOHandler := SSLHandler; // affectation du SSLHandler
        idPOP3.UseTLS    := TIdUseTLS(utUseImplicitTLS); // en mode implicite 
     end else
     begin
        idPOP3.UseTLS := utNoTLSSupport ; // pas de SSL
     end;

    with idPOP3 do
    begin
      AutoLogin      := True ;   // <- important
      ConnectTimeout := 2500; 
      Username       := FAccount.Username; // Username 
      Password       := FAccount.Password; // Password 
      Host           := FAccount.Host; // Host
      Port           := FAccount.Port; // Port
       AuthType := patUserPass ; // authentification pour userpass
      { TIdPOP3AuthenticationType = (patUserPass, patAPOP, patSASL); }
    end;

    
  EXCEPT
    Result := false ;
  END;
end;




//******************************************helper*************************************************************//

procedure Tpop3Client.Connect;
begin
   Pop3.Connect ;
end;

function Tpop3Client.Connected : boolean;
begin
   result := Pop3.Connected ;
end;


procedure Tpop3Client.Disconnect;
begin
  Pop3.Disconnect ;
end;


function Tpop3Client.Checkmessages : integer;
begin
  result := Pop3.CheckMessages ;
end;


{******************************************* Classe Account ******************************************************}

Constructor TAccount.Create(User, Pwd, logas : string) ;
begin
  Fusername := User ;
  Fpassword := Pwd ;
  FHost := 'pod51015.outlook.com' ;
  Fport := 995 ;              // pour pop3 SSL    587 pour SMTP SSL 
  FLoginas := logas ;
end;

Destructor TAccount.Free;
begin
   Fusername := '' ;
  Fpassword := '' ;
  FHost := '' ;
  Fport := -1 ;
  FLoginas := '' ;
end;




// fonction Decode
Function DecodeMessage(idMess : Tidmessage ; sPath: string ; Resa : integer; var sFileName : String)  : boolean ;
var sTemp, sF : string ;
    i : integer ;
begin 
   // 0 = sport2000
   // 1 = skimium
   // 2 = twinner
   // 3 = generique
//   sPath :=  IncludeTrailingPathDelimiter(sPath) ;
//   sTemp := sPath+'Temp.txt' ;
//   Deletefile(sTemp) ;
//   idMess.SaveToFile(sTemp, false);
//   idMess.LoadFromFile(sTemp);
   sf := '' ;
   for i := 0 to IdMess.MessageParts.Count-1 do
      begin
      if Trim(IdMess.MessageParts.Items[i].FileName) <> '' then
       begin
        sf := sPath ;
        case resa of
          0 : sf := sf+'S2K-' + FormatDateTime('YYYYMMDDhhmmsszzz_',Now) + IdMess.MessageParts.Items[i].FileName;
          1 : sF := sf+'SKM-' + FormatDateTime('YYYYMMDDhhmmsszzz_',Now) + IdMess.MessageParts.Items[i].FileName;
          2 : sF := sf+'TW-' + FormatDateTime('YYYYMMDDhhmmsszzz_',Now) + IdMess.MessageParts.Items[i].FileName;
          3 : sf := sf+FormatDateTime('YYYYMMDDhhmmsszzz_',Now) + IdMess.MessageParts.Items[i].FileName;

        end;
        if  lowercase(idMess.MessageParts.Items[i].ClassName) <> 'tidattachmentfile'  then
          TIdText(IdMess.MessageParts.Items[i]).Body.SaveToFile(sf)
        else begin
          TIdAttachmentfile(IdMess.MessageParts.Items[i]).SaveToFile(sf);
        end;
        sFileName := ExtractFileName(sf);

        Sleep(100) ; // pour permettre la mise à jour système
        break ;
       end;
      end;
    result := (sf <> '') ;

//    Deletefile(sTemp) ;
 end ;
end.

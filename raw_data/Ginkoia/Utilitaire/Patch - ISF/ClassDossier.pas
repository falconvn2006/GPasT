unit ClassDossier;

interface

uses Classes, uJSON, IdHTTP, SysUtils, Controls, Contnrs, IniFiles;

type
  // Base maintenance > select * from GROUPE
  TCentrale = (
      tcNone,               // 0
      tcCourir,             // 1
      tcAlgol,              // 2
      tcIntersport,         // 3
      tcSP2k,               // 4
      tcSkimium,            // 5
      tcTwinner,            // 6
      tcGoSport,            // 7
      tcEspaceMontagne,     // 8
      tcVeloland,           // 9
      tcMondoVelo,          // 10
      tcSkiset,             // 11
      tcUCPA);              // 12

  TDossier = class(TObject)
    private
      FVersion: string;
      FCentrale: TCentrale;
      FNomCentrale : String;
      FNom: String;
      FBase: string;
      FServeur: string;
      FDOSS_ID: Integer;
    public

    published
      property Nom : String read FNom write FNom;
      property Centrale : TCentrale read FCentrale write FCentrale;
      property NomCentrale : String read FNomCentrale write FNomCentrale;
      property Version : string read FVersion write FVersion;
      property Serveur : string read FServeur write FServeur;
      property Base : string read FBase write FBase;
      property DOSS_ID: Integer read FDOSS_ID write FDOSS_ID;
  end;

  TDossiers = class (TObjectList);

  TListCentrales = class(TObject)
    private
    FNom: String;
    FId: integer;
    public
    published
      property Nom : String read FNom write FNom;
      property Id : integer read FId write FId;
  end;

  TListVersions = class(TObject)
    private
    FNom: String;
    FId: integer;
    public
    published
      property Nom : String read FNom write FNom;
      property Id : integer read FId write FId;
  end;

  TListModules = class(TObject)
    private
    FNom: String;
    FId: integer;
    public
    published
      property Nom : String read FNom write FNom;
      property Id : integer read FId write FId;
  end;

  TOptions = class(TObject)
    private
      FNom: String;
      FId: integer;
      FIni_Opt_Error: integer;
      FIni_Opt_Mail: string;
      FIni_Opt_Mail_Security: integer;
      FIni_Opt_AutoClose: integer;
      FIni_Opt_Mail_Exp: string;
      FIni_Opt_Mode: integer;
      FIni_Opt: string;
      FIni_Opt_Mail_Pwd: string;
      FIni_Opt_Mail_Port: integer;
      FIni_Opt_Token: integer;
      FIni_Opt_Mail_SMTP: string;
      FIni_Opt_Mail_Log: integer;
    public
      procedure LoadOptions(IniFile : string);
      procedure SaveOptions(IniFile : string);
    published
      property Ini_Opt : string read FIni_Opt write FIni_Opt;
      property Ini_Opt_Mode : integer read FIni_Opt_Mode write FIni_Opt_Mode;
      property Ini_Opt_Mail : string read FIni_Opt_Mail write FIni_Opt_Mail;
      property Ini_Opt_AutoClose : integer read FIni_Opt_AutoClose write FIni_Opt_AutoClose;
      property Ini_Opt_Error : integer read FIni_Opt_Error write FIni_Opt_Error;
      property Ini_Opt_Token : integer read FIni_Opt_Token write FIni_Opt_Token;
      property Ini_Opt_Mail_SMTP : string read FIni_Opt_Mail_SMTP write FIni_Opt_Mail_SMTP;
      property Ini_Opt_Mail_Port : integer read FIni_Opt_Mail_Port write FIni_Opt_Mail_Port;
      property Ini_Opt_Mail_Exp : string read FIni_Opt_Mail_Exp write FIni_Opt_Mail_Exp;
      property Ini_Opt_Mail_Pwd : string read FIni_Opt_Mail_Pwd write FIni_Opt_Mail_Pwd;
      property Ini_Opt_Mail_Security : integer read FIni_Opt_Mail_Security write FIni_Opt_Mail_Security;
      property Ini_Opt_Mail_Log : integer read FIni_Opt_Mail_Log write FIni_Opt_Mail_Log;
  end;

implementation

const
  cIni_Opt : string = 'OPTIONS_COMM';
  cIni_Opt_Mode : string = 'MODE';
  cIni_Opt_Mail : string = 'MAIL';
  cIni_Opt_AutoClose : string = 'AUTOCLOSE';
  cIni_Opt_Error : string = 'ERREURS';
  cIni_Opt_Token : string = 'JETON';
  cIni_Opt_Mail_SMTP : string = 'SMTP';
  cIni_Opt_Mail_Port : string = 'PORT';
  cIni_Opt_Mail_Exp : string = 'EXPEDITEUR';
  cIni_Opt_Mail_Pwd : string = 'MDP';
  cIni_Opt_Mail_Security : String = 'TYPESEC';
  cIni_Opt_Mail_Log : string = 'LOGMAIL';

function CentraleToString (Centrale : TCentrale) : string;
var
  sTmp : String;
begin
  result := '';
  sTmp := '';
  try
    case Centrale of
      tcNone:sTmp := '';
      tcCourir:sTmp := 'COURIR';
      tcAlgol:sTmp := 'Algol';
      tcIntersport:sTmp := 'Intersport';
      tcSP2k:sTmp := 'Sport2000';
      tcSkimium:sTmp := 'Skimium';
      tcTwinner:sTmp := 'Twinner';
      tcGoSport:sTmp := 'GOSPORT';
      tcEspaceMontagne:sTmp := 'Espace_Montagne';
      tcVeloland:sTmp := 'Véloland';
      tcMondoVelo:sTmp := 'MondoVélo';
      tcSkiset:sTmp := 'Skiset';
      tcUCPA:sTmp := 'UCPA';
    else sTmp := '';
    end;
  finally
    if sTmp <> '' then
      result := sTmp;
  end;
end;
{ TOptions }

procedure TOptions.LoadOptions(IniFile : string);
var
  ini : TIniFile;
begin
  ini:= TIniFile.Create(IniFile);
  if ini.SectionExists(cIni_Opt) then
  begin
    FIni_Opt_Mode := ini.Readinteger(cIni_Opt, cIni_Opt_Mode ,0);
    FIni_Opt_Mail := ini.ReadString(cIni_Opt, cIni_Opt_Mail, '');
    FIni_Opt_AutoClose := ini.Readinteger(cIni_Opt, cIni_Opt_AutoClose, 0);
    FIni_Opt_Error := ini.Readinteger(cIni_Opt, cIni_Opt_Error, 0);
    FIni_Opt_Token := ini.Readinteger(cIni_Opt, cIni_Opt_Token, 0);
    FIni_Opt_Mail_SMTP := ini.ReadString(cIni_Opt, cIni_Opt_Mail_SMTP, '');
    FIni_Opt_Mail_Port := ini.Readinteger(cIni_Opt, cIni_Opt_Mail_Port, 0);
    FIni_Opt_Mail_Exp := ini.ReadString(cIni_Opt, cIni_Opt_Mail_Exp, '');
    FIni_Opt_Mail_Pwd := ini.ReadString(cIni_Opt, cIni_Opt_Mail_Pwd, '');
    FIni_Opt_Mail_Security := ini.Readinteger(cIni_Opt, cIni_Opt_Mail_Security, 0);
    FIni_Opt_Mail_Log := ini.Readinteger(cIni_Opt, cIni_Opt_Mail_Log, 0);
  end;
end;

procedure TOptions.SaveOptions(IniFile : string);
var
  ini : TIniFile;
begin
  ini:= TIniFile.Create(IniFile);
  ini.WriteInteger(cIni_Opt, cIni_Opt_Mode, FIni_Opt_Mode);
  ini.WriteString(cIni_Opt, cIni_Opt_Mail, FIni_Opt_Mail);
  ini.WriteInteger(cIni_Opt, cIni_Opt_AutoClose, FIni_Opt_AutoClose);
  ini.WriteInteger(cIni_Opt, cIni_Opt_Error, FIni_Opt_Error);
  ini.WriteInteger(cIni_Opt, cIni_Opt_Token, FIni_Opt_Token);
  ini.WriteString(cIni_Opt, cIni_Opt_Mail_SMTP, FIni_Opt_Mail_SMTP);
  ini.WriteInteger(cIni_Opt, cIni_Opt_Mail_Port, FIni_Opt_Mail_Port);
  ini.WriteString(cIni_Opt, cIni_Opt_Mail_Exp, FIni_Opt_Mail_Exp);
  ini.WriteString(cIni_Opt, cIni_Opt_Mail_Pwd, FIni_Opt_Mail_Pwd);
  ini.WriteInteger(cIni_Opt, cIni_Opt_Mail_Security, FIni_Opt_Mail_Security);
  ini.WriteInteger(cIni_Opt, cIni_Opt_Mail_Log, FIni_Opt_Mail_Log);
end;

end.

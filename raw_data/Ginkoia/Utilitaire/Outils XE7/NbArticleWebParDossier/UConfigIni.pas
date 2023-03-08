unit UConfigIni;

interface

uses
  System.Inifiles,System.SysUtils, UConstantes, System.Classes,
  IdExplicitTLSClientServerBase, IdSSLOpenSSL;

type TConfigIni = class(TObject)
  private
    FIni: TIniFile;
    FPathBdd: string;
    FPathLog: string;
    FPathCsv: string;
    FEmailActif: boolean;
    FParamMail: TParamMail;
    FListEmail: TStringList;
    FTpsMonitoring: integer;
    procedure SetPathCsv(pPath: string);
    procedure SetPathLog(pPath: string);
    function CheckPath(pPath: string): string;
  public
    constructor Create;
    procedure Load;
    procedure Save;
    property PathBDD: string read FPathBdd Write FPathBdd;
    property PathLOG: string read FPathLog Write SetPathLog;
    property PathCSV: string read FPathCsv Write SetPathCsv;
    property EmailActif: boolean read FEmailActif write FEmailActif;
    property ParamMail: TParamMail read FParamMail write FParamMail;
    property ListeEmail: TStringList read FListEmail write FListEmail;
    property TempsMonitoring: integer read FTpsMonitoring write FTpsMonitoring;
end;

implementation

{ TConfigIni }

function TConfigIni.CheckPath(pPath: string): string;
var
  lPath: string;
begin
  lPath := IncludeTrailingPathDelimiter(trim(pPath));
  if (lPath = '') or (lPath = '\') then
    Result := ExtractFilePath(ParamStr(0))
  else
    Result := lPath;
end;

constructor TConfigIni.Create;
begin
  inherited Create;
  FIni := TIniFile.Create(ExtractFilePath(ParamStr(0))+ChangeFileExt(ExtractFileName(ParamStr(0)),'.ini'));
  FListEmail := TStringList.Create;
  FListEmail.Delimiter := #13;
  FListEmail.StrictDelimiter := true;
  Load;
end;

procedure TConfigIni.Load;
var
  lListeIni: TStringList;
  lEmail: string;
  iEmail: integer;
begin
  lListeIni := TStringList.Create;
  //lecture param path
  EmailActif := FIni.ReadBool('CONFIG','email',false);
  PathBDD :=  FIni.ReadString('CONFIG','PathBDD','');
  PathCSV :=  FIni.ReadString('CONFIG','PathCsv','');
  PathLOG :=  FIni.ReadString('CONFIG','PathLog','');
  FTpsMonitoring := FIni.ReadInteger('CONFIG','Monitoring',0);

  //lecture adresses mail
  FListEmail.Clear;
  FIni.ReadSection('EMAIL',lListeIni);
  for iEmail := 0 to lListeIni.Count -1 do
  begin
    lEmail := FIni.ReadString('EMAIL',IntToStr(iEmail),'');
    if lEmail <> '' then
      FListEmail.Add(lEmail);
  end;

  //lecture param smtp
  FParamMail.FromAddress := FIni.ReadString('CONFIG','FromAddress','dev@ginkoia.fr');
  FParamMail.SmtpPort := FIni.ReadInteger('CONFIG','SmtpPort',587);
  FParamMail.SmtpHost := FIni.ReadString('CONFIG','SmtpHost','pod51015.outlook.com');
  FParamMail.SmtpUsername := FIni.ReadString('CONFIG','SmtpUsername','dev@ginkoia.fr');
  FParamMail.SmtpPassword := FIni.ReadString('CONFIG','SmtpPassword','Toru682674');
  FParamMail.SmtpUseTLS := TIdUseTLS(FIni.ReadInteger('CONFIG','SmtpUseTLS',ord(utUseExplicitTLS)));
  FParamMail.SSLVersion := TIdSSLVersion(FIni.ReadInteger('CONFIG','SSLVersion',ord(sslvTLSv1_2)));
end;

procedure TConfigIni.Save;
var
  iEmail: integer;
  lListeIni: TStringList;
begin
  lListeIni := TStringList.Create;
  //écriture param path
  FIni.WriteBool('CONFIG','email',EmailActif);
  FIni.WriteString('CONFIG','PathBDD',PathBDD);
  FIni.WriteString('CONFIG','PathCsv',PathCSV);
  FIni.WriteString('CONFIG','PathLog',PathLOG);
  FIni.WriteInteger('CONFIG','Monitoring',FTpsMonitoring);

  //écriture des emails
  for iEmail := 0 to FListEmail.Count -1 do
  begin
    FIni.WriteString('EMAIL',IntToStr(iEmail),Trim(FListEmail[iEmail]));
  end;

  //nettoyage des lignes vides après
  FIni.ReadSection('EMAIL',lListeIni);
  if lListeIni.Count > FListEmail.Count then
    begin
    for iEmail := FListEmail.Count to lListeIni.Count -1 do
    begin
      FIni.DeleteKey('EMAIL',IntToStr(iEmail));
    end;
  end;

  //écriture param smtp
  FIni.WriteString('CONFIG','FromAddress',ParamMail.FromAddress);
  FIni.WriteInteger('CONFIG','SmtpPort',ParamMail.SmtpPort);
  FIni.WriteString('CONFIG','SmtpHost',ParamMail.SmtpHost);
  FIni.WriteString('CONFIG','SmtpUsername',ParamMail.SmtpUsername);
  FIni.WriteString('CONFIG','SmtpPassword',ParamMail.SmtpPassword);
  FIni.WriteInteger('CONFIG','SmtpUseTLS',ord(ParamMail.SmtpUseTLS));
  FIni.WriteInteger('CONFIG','SSLVersion',ord(ParamMail.SSLVersion)); 
end;

procedure TConfigIni.SetPathCsv(pPath: string);
begin
  FPathCsv := CheckPath(pPath);  
end;

procedure TConfigIni.SetPathLog(pPath: string);
begin
  FPathLog := CheckPath(pPath);  
end;

end.

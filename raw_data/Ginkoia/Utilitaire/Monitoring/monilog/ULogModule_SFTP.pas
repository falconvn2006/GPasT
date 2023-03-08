unit ULogModule_SFTP;

interface

USes Classes, SysUtils, Forms, Math, UlogModule, SBUtils, SBSimpleSftp, SBSSHKeyStorage,
      SBSSHConstants, SBSftpCommon, SBTypes,ULog;

type
   TSFTPEtat = class
   private
      FConnected  : boolean;
      FErrorMsg   : string;
      FFileSize     : int64;
      FUploaded   : boolean;
      FDownloaded : boolean;
      FCompared   : boolean;
      FConnectTime  : integer;
      FUploadTime   : integer;
      FDownloadTime : integer;
   published
    constructor Create();
  public
    property Connected  : boolean read FConnected  write FConnected;
    property ErrorMsg   : String  read FErrorMsg   write FErrorMsg;
    property FileSize   : int64   read FFileSize   write FFileSize;
    property Uploaded   : boolean read FUploaded   write FUploaded;
    property Downloaded : boolean read FDownloaded write FDownloaded;
    property Compared   : boolean read FCompared   write FCompared;
    property ConnectTime  : integer read FConnectTime  write FConnectTime;
    property DownloadTime : integer read FDownloadTime write FDownloadTime;
    property UploadTime   : integer read FUploadTime   write FUploadTime;
  end;

   TLogModule_SFTP = class(TLogModule)
   private
     FSFTPClient: TElSimpleSFTPClient;
     FRunning: boolean;
     FOnAfterTest: TNotifyEvent;
     FHost: string;
     Fdir : string;
     FUploadFile   : string;
     FDownloadFile : string;
     FEtat : TSFTPEtat;
     FRemotePath : string;
     procedure KeyValidate(Sender: TObject;
       ServerKey: TElSSHKey; var Validate: Boolean);
   protected
    procedure DoTest; override;
    procedure CreateRandomFile;
    procedure CompareFiles;
    procedure ConnectionIsValid;
    procedure UploadFileMyFile;
    procedure DownloadMyFile;
    procedure SetAdresse(AValue:string);
    procedure SetPort(AValue:integer);
    procedure SetUsername(AValue:string);
    procedure SetPassword(AValue:string);
   public
     constructor Create(Host: string;  AFreq:integer; ANotifyEvent: TNotifyEvent);
     destructor Destroy; override;
   published
     property Running  : boolean   read FRunning write FRunning;
     property Etat     : TSFTPEtat read FEtat;
     property Adresse  : string    write SetAdresse;
     property Port     : integer   write SetPort;
     property Username : string    write SetUsername;
     property Password : string    write SetPassword;
     property RemotePath : string  read FRemotePath write FRemotePath;
   end;

implementation


Uses UCommun,GestionLog;

constructor TSFTPEtat.Create();
begin
    FConnected    := false;
    FErrorMsg     := '';
    FFileSize     := -1;
    FUploaded     := false;
    FDownloaded   := false;
    FCompared     := false;
    FConnectTime  := 0;
    FUploadTime   := 0;
    FDownloadTime := 0;
end;

constructor TLogModule_SFTP.Create(Host: string;  AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   FHost := Host;
   Module := 'SFTP';
   FEtat  := TSFTPEtat.Create;
   FSFTPClient:= TElSimpleSFTPClient.Create(nil);
   FSFTPClient.OnKeyValidate:=KeyValidate;
   // Répertoire de travail sftp
   FDir:=ExtractFileDir(Application.ExeName)+'\sftp\';
   if NOT DirectoryExists(FDir) then
     begin
        ForceDirectories(FDir);
     end;
   // delete de tous les fichiers .up .down...
   // ElSimpleSFTPClient.CompressionAlgorithms[ SSH_CA_ZLIB ] := True;
end;

procedure TLogModule_SFTP.SetAdresse(AValue:string);
begin
   FSFTPClient.Address:=AValue;
end;
procedure TLogModule_SFTP.SetPort(AValue:integer);
begin
   FSFTPClient.Port:=AValue;
end;
procedure TLogModule_SFTP.SetUsername(AValue:string);
begin
   FSFTPClient.username:=AValue;
end;
procedure TLogModule_SFTP.SetPassword(AValue:string);
begin
   FSFTPClient.password:=AValue;
end;

destructor TLogModule_SFTP.Destroy;
begin
   FSFTPClient.Close(true);
   FSFTPClient.Free;
   FEtat.Free;
   inherited;
end;

procedure TLogModule_SFTP.KeyValidate(Sender:TObject;ServerKey: TElSSHKey; var Validate: Boolean);
begin
    // J'accepte toutes les clés du serveur....
    Validate:=true;
end;


procedure TLogModule_SFTP.DownloadMyFile;
var afile:string;
    dwn:string;
    Top_Depart:TTimeStamp;
    Top_Arrivee:TTimeStamp;
begin
    try
       if (Etat.Uploaded) and (Etat.Connected) then
          begin
            // on va récuperer le fichier sur le serveur
            try
               afile:=ExtractFileName(FUploadFile);
               dwn:=ChangeFileExt(afile,'.dwn');
               FDownloadFile:=FDir + dwn;
               Top_Depart:=DateTimeToTimeStamp(Now());
               FSFTPClient.DownloadFile(RemotePath+afile,FDownloadFile);
               Top_arrivee:=DateTimeToTimeStamp(Now());
               Etat.Downloaded:=true;
               Etat.DownloadTime:=Top_Arrivee.Time-Top_Depart.Time;
               FSFTPClient.RemoveFile(RemotePath+afile);
            except On E:Exception do
               Etat.Downloaded:=false;
            end;
          end;
    finally
      //
    end;
end;



procedure TLogModule_SFTP.UploadFileMyFile;
var afile:string;
    Top_Depart:TTimeStamp;
    Top_Arrivee:TTimeStamp;
begin
    try
       Etat.Uploaded:=false;
       CreateRandomFile;
       if (FUploadFile<>'') and (Etat.Connected) then
          begin
            // on va le poser sur le serveur
            try
               afile:=ExtractFileName(FUploadFile);
               Top_Depart:=DateTimeToTimeStamp(Now());
               // FSFTPClient.OpenDirectory(RemotePath);
               FSFTPClient.UploadFile(FUploadFile,RemotePath+afile);
               Top_arrivee:=DateTimeToTimeStamp(Now());
               Etat.Uploaded:=true;
               Etat.UploadTime:=Top_Arrivee.Time-Top_Depart.Time;
            except On E:Exception do
              begin
                 Log_Write(E.Message, el_Erreur);
                 Log.Log(Host, Module,'',FSFTPClient.Address,'upload', E.Message , logError, true);
                 FEtat.Uploaded:=false;
              end;
            end;
          end;
    finally
      //
    end;
end;

procedure TLogModule_SFTP.CompareFiles;
var UpLoaded, Downloaded: TStringList;
i: integer;
begin
    UpLoaded   := TStringList.Create;
    Downloaded := TStringList.Create;
    try
      try
        UpLoaded.LoadFromFile(FUploadFile);
        Downloaded.LoadFromFile(FDownloadFile);
        if UpLoaded.Count <> Downloaded.Count then
         begin
             Etat.Compared:=false;
             exit;
         end;
        for i := 0 to UpLoaded.Count - 1 do
            begin
                if AnsiCompareText(UpLoaded.Strings[i], Downloaded.Strings[i]) <> 0 then
                    begin
                        Etat.Compared:=false;
                        exit;
                   end;
          end;
        Etat.Compared:=true;
        Log.Log(Host, Module,'',FSFTPClient.Address,'up/down','OK',logInfo,true);
     except
        Etat.Compared:=false;
        Log.Log(Host, Module,'',FSFTPClient.Address,'up/down','KO',logInfo,true);
     end;
   Finally
     UpLoaded.Free;
     Downloaded.free;
   end;
end;

procedure TLogModule_SFTP.ConnectionIsValid;
var Top_Depart:TTimeStamp;
    Top_Arrivee:TTimeStamp;
    MyList:TList;
begin
    try
      MyList:=TList.Create;
      try
        Top_Depart:=DateTimeToTimeStamp(Now());
        FSFTPClient.Open;
        FSFTPClient.ListDirectory('./',MyList);
        Top_Arrivee:=DateTimeToTimeStamp(Now());
        Etat.UploadTime:=Top_Arrivee.Time-Top_Depart.Time;
        Etat.Connected := true;
      Except
        On E:Exception do
          begin
             Log_Write(E.Message, el_Erreur);
             Log.Log(Host, Module,'',FSFTPClient.Address,'ConnectionIsValid', E.Message , logError, true);
             FEtat.Connected := false;
             FEtat.ErrorMsg := E.Message;
          end;
      end;
    Finally
       MyList.Free;
    end;
end;

procedure TLogModule_SFTP.CreateRandomFile;
var ligne: string;
    w,h:integer;
    content:TStringList;
    str:string;
    i:integer;
begin
  Randomize;
  content := TStringList.Create;
  FUploadFile := '';
  try
    // longueur ligne fichier
    w:=RandomRange(256,512);
    // nombre de ligne du fichier
    h:=RandomRange(2048,4096);
    str := '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for i:=0 to h do
      begin
          ligne:='';
          repeat
            ligne := ligne + str[Random(Length(str)) + 1];
          until (Length(ligne) = w);
          content.Add(ligne);
      end;
      FUploadFile:=CreateNewFileName(FDir + 'test_','.upl');
      content.SaveToFile(FUploadFile);
      Etat.FileSize:=GetFileSize(FUploadFile);
  finally
     content.Free;
  end;
end;

procedure TLogModule_SFTP.DoTest;
begin
   try
     FStatus := 'Running';
     ConnectionIsValid;
     UploadFileMyFile;
     DownloadMyFile;
     CompareFiles;
     FSFTPClient.Close(true);
   finally
     FStatus := 'Not Running';
     FRunning := false;
   end;
end;

initialization
  SetLicenseKey('4003D46B2B8444C662FA106C95792805D3E87D27FC53D6E57C3050AEA3E7375A' +
              'E9D03CD909F3120E8E740B4510CEA0E5D3303E83DD28EFEB5862603B18E7EF46' +
              '2FA3CE11BDECA8DC271B63F7F53D6EEEA8709B45130709DC97A73B9EFD3A8D92' +
              'DF286D7B55C02D26322D76D4E0312936C177419931345AED6B3A298774A71B05' +
              'F4DE9D00FCF9DC55F907219D5AB67032F7D184F4CD069CE39F28E60AE4DA6034' +
              'B434939F74F61535C602116CFAEBF228F6477B7D20D7FC43D8502ADA45359169' +
              '3D708AFDAB7A08DD8A2D3092082466DA583EF082625E8C3820BE5EF5B48D45B2' +
              'F76D49B11FE99F2295F677A8F3BD84A4560E73C231803D74EAFE53105B38017F');

end.

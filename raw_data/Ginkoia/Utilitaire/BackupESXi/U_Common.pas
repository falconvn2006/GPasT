unit U_Common;

interface

uses
  Windows, SysUtils, Messages, Variants, Graphics, Controls, Dialogs, ExtCtrls,
  //Début Uses Perso
  IniFiles,
  StrUtils,
  IdMessage,
  IdSMTP,
  IdSSLOpenSSL,
  IdGlobal,
  IdExplicitTLSClientServerBase,
  IdLogFile,
  IdText,
  GestionEMail,
  //Fin Uses Perso
  Classes, Forms, DateUtils;

type
  TLog = class
  private
    Lst : TStringList;
    FileName : string;
  public
    constructor Create(aPathExe:string);
    destructor Free;
    procedure AddLog(aText:string);
    function GetLog:string;
    function GetFileName:string;
  end;

  TBackup = class
  private
    { Déclarations privées }
    ESXi_Name       : string;
    ESXi_IP         : string;
    ESXi_User       : string;
    ESXi_Password   : string;
    ESXi_PathBck    : string;
    Local_PathBck   : string;
    Local_NbBackup  : Integer;
    PathExe         : string;
    List_VM         : TStringList;
    Mail,
    Log             : TLog;

    MAIL_ACCOUNT    : string;
    MAIL_PASSWORD   : string;
    MAIL_HOST       : string;
    MAIL_PORT       : Integer;
    MAIL_RECIPIENTS : string;
  public
    constructor Create(aPathExe:string);
    destructor Free;

    { Déclarations publiques }
    function SaveIni(aFichierIni :string):Boolean;
    function LoadIni(aFichierIni :string):Boolean;

    function SaveListVM:Boolean;
    function LoadListVM:Boolean;

    function DoBackup:Boolean;
    function BackupVM(aNomVM:string;aDate:TDateTime):Boolean;

    function SendEmail(const Subject: string; const Body: string):Boolean;

    //Set
    procedure SetLocal_PathBck(aValue:string);
    procedure SetLocal_NbBackup(aValue:Integer);
    procedure SetESXi_Name(aValue:string);
    procedure SetESXi_IP(aValue:string);
    procedure SetESXi_User(aValue:string);
    procedure SetESXi_Password(aValue:string);
    procedure SetESXi_PathBck(aValue:string);

    //Get
    function GetLocal_PathBck:string;
    function GetLocal_NbBackup:Integer;
    function GetESXi_Name:string;
    function GetESXi_IP:string;
    function GetESXi_User:string;
    function GetESXi_Password:string;
    function GetESXi_PathBck:string;
  end;

implementation

function GetFileSize(const APath: string): int64;
var
  Sr : TSearchRec;
begin
  if FindFirst(APath,faAnyFile,Sr)=0 then
  try
    Result := Int64(Sr.FindData.nFileSizeHigh) shl 32 + Sr.FindData.nFileSizeLow;
  finally
    FindClose(Sr);
  end
  else
    Result := -1;
end;

function LancerExe(Le_exe:string;La_cmd:string;OkAtten:boolean):boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  sRep,sExe:string;
  SavDir:string;
begin
  Result:=true;
  if Le_exe='' then
    exit;
  sRep:=extractfilepath(Le_exe);
  sExe:=ExtractFileName(Le_exe);
  if sRep[length(sRep)]<>'\' then
    sRep:=sRep+'\';
  SavDir := GetCurrentDir;
  SetCurrentDir(sRep);
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW  ;
    wShowWindow := SW_SHOWNORMAL;
  end;

  CreateProcess(nil, PChar(sExe + La_cmd), nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);

  WaitForSingleObject(ProcessInfo.hProcess,INFINITE);

  SetCurrentDir(SavDir);
end;

function TBackup.BackupVM(aNomVM: string;aDate: TDateTime): Boolean;
var
  tmp           : TStringList;
  tmpLst        : TextFile;
  sPathTmp,
  sTmp,
  sYear,
  sMonth,
  sDay,
  sPrefixeDate  : string;
  sDateTmp      : TDateTime;
  Info          : TSearchRec;
  i             : Integer;

  function Deltree(sDir: string): Boolean;
  var
    iIndex: Integer;
    SearchRec: TSearchRec;
    sFileName: string;
  begin
    sDir := sDir + '\*.*';
    iIndex := FindFirst(sDir, faAnyFile, SearchRec);
    while iIndex = 0 do
    begin
      sFileName := ExtractFileDir(sDir) + '\' + SearchRec.Name;
      if SearchRec.Attr = faDirectory then
      begin
      if (SearchRec.Name <> '' ) and
         (SearchRec.Name <> '.') and
         (SearchRec.Name <> '..') then
        Deltree(sFileName);
      end else
      begin
        if SearchRec.Attr <> faArchive then
          FileSetAttr(sFileName, faArchive);
        DeleteFile(PWideChar(sFileName));
      end;
      iIndex := FindNext(SearchRec);
    end;
    FindClose(SearchRec);
    RemoveDir(ExtractFileDir(sDir));
    Result := True;
  end;
begin
  Result := True;
  sPrefixeDate := IntToStr(YearOf(adate)) + '-' + IntToStr(MonthOf(adate)) + '-' + IntToStr(DayOf(adate)) + '-';
  try
    sPathTmp := ExtractFilePath(PathExe);

    try
      Log.AddLog('Début backup ' + aNomVM);
      tmp := TStringList.Create;
      try
        tmp.Add('option batch on');
        tmp.Add('option confirm off');
        tmp.Add('open ' + GetESXI_User + ':' + GetESXi_Password + '@' + GetESXi_IP);  //Connexion
        tmp.Add('option transfer binary');                                            //Force binary mode transfer
        tmp.Add('rmdir ' + GetESXi_PathBck + aNomVM);                                 //Supprimer le dossier
        tmp.Add('close');                                                             //De-connexion
        tmp.Add('pause');
        tmp.Add('exit');                                                              //Exit WinSCP
        tmp.SaveToFile(sPathTmp + 'Script\tmp.txt');

        LancerExe(sPathTmp + 'Exe\WinSCP.exe', ' /console /script=' + sPathTmp + 'Script\tmp.txt',True);

        DeleteFile(PWideChar(sPathTmp + 'Script\tmp.txt'));
      finally
        tmp.Free;
      end;

      Log.AddLog('Création de la liste de VM');
      AssignFile(tmpLst, sPathTmp + 'GhettoVCB\Liste-VM.lst');
      Rewrite(tmpLst);
      Write(tmpLst,aNomVM);
      CloseFile(tmpLst);

      Log.AddLog('Envoi des fichiers GhettoVCB');
      tmp := TStringList.Create;
      try
        tmp.Add('option batch on');
        tmp.Add('option confirm off');
        tmp.Add('open ' + GetESXI_User + ':' + GetESXi_Password + '@' + GetESXi_IP);  //Connexion
        tmp.Add('option transfer binary');                                            //Force binary mode transfer
        tmp.Add('mkdir GhettoVCB');                                                   //Création du Dossier
        tmp.Add('cd /GhettoVCB');
        tmp.Add('put ' + sPathTmp + 'GhettoVCB\ghettoVCB.conf');     //Envoi des fichiers
        tmp.Add('put ' + sPathTmp + 'GhettoVCB\ghettoVCB.sh');
        tmp.Add('put ' + sPathTmp + 'GhettoVCB\Commande.sh');
        tmp.Add('put ' + sPathTmp + 'GhettoVCB\Liste-VM.lst');
        tmp.Add('rmdir ' + GetESXi_PathBck + aNomVM);                                 //Supprimer le dossier
        tmp.Add('pause');
        tmp.Add('close');                                                             //De-connexion

        tmp.Add('exit');                                                              //Exit WinSCP
        tmp.SaveToFile(sPathTmp+ 'Script\tmp.txt');

        LancerExe(sPathTmp + 'Exe\WinSCP.exe', ' /console /script=' + sPathTmp + 'Script\tmp.txt', True);

        DeleteFile(PWideChar(sPathTmp + 'Script\tmp.txt'));
        DeleteFile(PWideChar(sPathTmp + 'GhettoVCB\Liste-VM.lst'));
      finally
        tmp.Free;
      end;

      Log.AddLog('Lancement de plink.exe pour supprimer le dossier Zip du Backup');
      LancerExe(sPathTmp + 'Exe\plink.exe', ' -v -pw ' + GetESXi_Password + ' ' + GetESXi_User + '@' + GetESXi_IP +
                ' rm -rf ' + GetESXi_PathBck + aNomVM + '_' + GetESXi_Name + 'Zip', True);

      Log.AddLog('Lancement de plink.exe pour le Backup');
      LancerExe(sPathTmp + 'Exe\plink.exe', ' -v -pw ' + GetESXi_Password + ' ' + GetESXi_User + '@' + GetESXi_IP +
                ' sh ./GhettoVCB/Commande.sh', True);

      Log.AddLog('Lancement de plink.exe pour créer le dossier du Zip');
      LancerExe(sPathTmp + 'Exe\plink.exe', ' -v -pw ' + GetESXi_Password + ' ' + GetESXi_User + '@' + GetESXi_IP +
                ' mkdir ' + GetESXi_PathBck + aNomVM + '_' + GetESXi_Name + 'Zip/', True);

      Log.AddLog('Lancement de plink.exe pour le zipper le Backup');
      LancerExe(sPathTmp + 'Exe\plink.exe', ' -v -pw ' + GetESXi_Password + ' ' + GetESXi_User + '@' + GetESXi_IP +
                ' tar cvzf ' + GetESXi_PathBck + aNomVM + '_' + GetESXi_Name + 'Zip/' + GetESXi_Name + sPrefixeDate + aNomVM + '.tar.gz ' + GetESXi_PathBck + aNomVM, True);

      Log.AddLog('Lancement de plink.exe pour supprimer le dossier du Backup');
      LancerExe(sPathTmp + 'Exe\plink.exe', ' -v -pw ' + GetESXi_Password + ' ' + GetESXi_User + '@' + GetESXi_IP +
                ' rm -rf ' + GetESXi_PathBck + aNomVM, True);

      Log.AddLog('Supression de GhettoVCB');
      tmp := TStringList.Create;
      try
        tmp.Add('option batch on');
        tmp.Add('option confirm off');
        tmp.Add('open ' + GetESXI_User + ':' + GetESXi_Password + '@' + GetESXi_IP);  //Connexion
        tmp.Add('option transfer binary');                                            //Force binary mode transfer
        tmp.Add('rmdir /GhettoVCB');                                                  //Supprimer le dossier
        tmp.Add('close');                                                             //De-connexion
        tmp.Add('pause');
        tmp.Add('exit');                                                              //Exit WinSCP
        tmp.SaveToFile(sPathTmp + 'Script\tmp.txt');

        LancerExe(sPathTmp + 'Exe\WinSCP.exe', ' /console /script=' + sPathTmp + 'Script\tmp.txt', True);

        DeleteFile(PWideChar(sPathTmp + 'Script\tmp.txt'));
      finally
        tmp.Free;
      end;

      Log.AddLog('Téléchargement du Backup');
      tmp := TStringList.Create;
      try
        tmp.Add('option batch on');
        tmp.Add('option confirm off');
        tmp.Add('open ' + GetESXI_User + ':' + GetESXi_Password + '@' + GetESXi_IP);  //Connexion
        tmp.Add('option transfer binary');                                            //Force binary mode transfer
        tmp.Add('get ' + GetESXi_PathBck + aNomVM + '_' + GetESXi_Name + 'Zip ' + GetLocal_PathBck);   //Récupération du Backup
        tmp.Add('close');                                                             //De-connexion
        tmp.Add('pause');
        tmp.Add('exit');                                                              //Exit WinSCP
        tmp.SaveToFile(sPathTmp + 'Script\tmp.txt');

        LancerExe(sPathTmp + 'Exe\WinSCP.exe', ' /console /script=' + sPathTmp + 'Script\tmp.txt', True);

        DeleteFile(PWideChar(sPathTmp + 'Script\tmp.txt'));
      finally
        tmp.Free;
      end;

      Log.AddLog('Suppression de l''ancien Backup');
      tmp := TStringList.Create;
      try
        { Recherche de la première entrée du répertoire }
        if FindFirst(IncludeTrailingPathDelimiter(GetLocal_PathBck)+'*.*',faAnyFile,Info)=0 Then
        begin
          repeat
            { Les fichiers sont affichés dans ListBox1 }
            { Les répertoires sont affichés dans ListBox3 }
            // le fichier n'est pas un repertoire donc =0
            if (info.Name<>'.')And(info.Name<>'..') then
            begin
              if not((Info.Attr And faDirectory)=0) then
                tmp.Add(Info.FindData.cFileName);
            end;

            { Il faut ensuite rechercher l'entrée suivante }
          Until FindNext(Info)<>0;

          { Dans le cas ou une entrée au moins est trouvée il faut }
          { appeler FindClose pour libérer les ressources de la recherche }
          FindClose(Info);
        end;

        i := 0;
        while i < (tmp.Count - 1) do
        begin
          sTmp := tmp.Strings[i];

          if Pos(aNomVM,sTmp) > 0 then    //Si la machine est dans le nom du dossier
          begin
            sYear   := Copy(sTmp, Pos(aNomVM,sTmp) + Length(aNomVM) + 1, 4);
            sMonth  := Copy(sTmp, Pos(aNomVM,sTmp) + Length(aNomVM) + 6, 2);
            sDay    := Copy(sTmp, Pos(aNomVM,sTmp) + Length(aNomVM) + 9, 2);

            sDateTmp := EncodeDate(StrToInt(sYear),StrToInt(sMonth),StrToInt(sDay));

            if DaysBetween(aDate,sDateTmp) > GetLocal_NbBackup then     //On garde le jour en cours + le nombre de Backup
            begin
              Deltree(GetLocal_PathBck + '\' + sTmp);
            end;
          end;

          Inc(i);
        end;
      finally
        tmp.Free;
      end;
    finally
      Log.AddLog('Fin backup ' + aNomVM);
      Mail.AddLog('Backup de la VM : ' + aNomVM);
      Mail.AddLog('Taille du fichier : ' + IntToStr(GetFileSize(GetLocal_PathBck + '\' + GetESXi_Name + sPrefixeDate + aNomVM + '.tar.gz')));
      if GetFileSize(GetLocal_PathBck + '\' + GetESXi_Name + sPrefixeDate + aNomVM + '.tar.gz') < 1000 then
      begin
        Log.AddLog('Suppression du fichier');
        DeleteFile(GetLocal_PathBck + '\' + GetESXi_Name + sPrefixeDate + aNomVM + '.tar.gz');
        Mail.AddLog('Suppression du fichier : Car vide');
      end;
      Mail.AddLog('-------------------------------------');
    end;
  Except on E:Exception do
    begin
      Log.AddLog('Erreur dans BackupVM() : ' + E.Message);
      SendEmail('[Erreur Backup ESXi]', Log.GetLog);
      Result := False;
    end;
  end;
end;

constructor TBackup.Create(aPathExe:string);
begin
  List_VM := TStringList.Create;
  Mail    := TLog.Create(aPathExe);
  Log     := TLog.Create(aPathExe);

  PathExe := aPathExe;
end;

destructor TBackup.Free;
begin
  Log.Free;
  Mail.Free;
  List_VM.Free;
end;

function TBackup.DoBackup: Boolean;
var
  dDate : TDateTime;
  I     : Integer;
begin
  Result := True;
  try
    try
      LoadListVM;
      dDate := Date;

      for I := 0 to List_VM.Count - 1 do
        BackupVM(List_VM.Strings[I],dDate);

    finally
      SendEmail('[Backup ESXi]', Mail.GetLog);
    end;
  Except on E:Exception do
    begin
      Log.AddLog('Erreur dans DoBackup() : ' + E.Message);
      SendEmail('[Erreur Backup ESXi]', Log.GetLog);
      Result := False;
    end;
  end;
end;

function TBackup.GetESXi_IP: string;
begin
  Result := ESXi_IP;
end;

function TBackup.GetESXi_Name: string;
begin
  Result := ESXi_Name;
end;

function TBackup.GetESXi_Password: string;
begin
  Result := ESXi_Password;
end;

function TBackup.GetESXi_PathBck: string;
begin
  Result := ESXi_PathBck;
end;

function TBackup.GetESXI_User: string;
begin
  Result := ESXi_User;
end;

function TBackup.GetLocal_NbBackup: Integer;
begin
  Result := Local_NbBackup;
end;

function TBackup.GetLocal_PathBck: string;
begin
  Result := Local_PathBck;
end;

function TBackup.LoadIni(aFichierIni: string):Boolean;
var
  Ini : TIniFile;
begin
  Result := True;
  try
    Ini := TIniFile.Create(aFichierIni);
    try
      SetLocal_PathBck(Ini.ReadString('Local', 'PathBck', ''));
      SetLocal_NbBackup(Ini.ReadInteger('Local', 'NbBackup', 0));

      SetESXi_Name(Ini.ReadString('ESXi', 'Name', ''));
      SetESXi_IP(Ini.ReadString('ESXi', 'IP', ''));
      SetESXI_User(Ini.ReadString('ESXi', 'User', ''));
      SetESXi_Password(Ini.ReadString('ESXi', 'Password', ''));
      SetESXi_PathBck(Ini.ReadString('ESXi', 'PathBck', ''));

      MAIL_ACCOUNT    := Ini.ReadString('Mail', 'Account', 'dev@ginkoia.fr');
      MAIL_PASSWORD   := Ini.ReadString('Mail', 'Password', 'Toru682674');
      MAIL_HOST       := Ini.ReadString('Mail', 'Host', 'pod51015.outlook.com');
      MAIL_PORT       := Ini.ReadInteger('Mail', 'Port', 587);
      MAIL_RECIPIENTS := Ini.ReadString('Mail', 'Recipients', 'sylvain.rosset@ginkoia.fr');
    finally
      Ini.Free;
    end;
  Except on E:Exception do
    begin
      Log.AddLog('Erreur dans LoadIni() : ' + E.Message);
      Result := False;
    end;
  end;
end;

function TBackup.LoadListVM:Boolean;
begin
  Result := True;
  try
    List_VM.LoadFromFile(ChangeFileExt(PathExe, '.lst'));
  Except on E:Exception do
    begin
      Log.AddLog('Erreur dans LoadListVM() : ' + E.Message);
      Result:= False;
    end;
  end;
end;

function TBackup.SaveIni(aFichierIni :string):Boolean;
var
  Ini : TIniFile;
begin
  Result := True;
  try
    Ini := TIniFile.Create(aFichierIni);
    try
      Ini.WriteString('Local', 'PathBck', GetLocal_PathBck);
      Ini.WriteInteger('Local', 'NbBackup', GetLocal_NbBackup);

      Ini.WriteString('ESXi', 'Name', GetESXi_Name);
      Ini.WriteString('ESXi', 'IP', GetESXi_IP);
      Ini.WriteString('ESXi', 'User', GetESXi_User);
      Ini.WriteString('ESXi', 'Password', GetESXi_Password);
      Ini.WriteString('ESXi', 'PathBck', GetESXi_PathBck);

      Ini.WriteString('Mail', 'Account', MAIL_ACCOUNT);
      Ini.WriteString('Mail', 'Password', MAIL_PASSWORD);
      Ini.WriteString('Mail', 'Host', MAIL_HOST);
      Ini.WriteInteger('Mail', 'Port', MAIL_PORT);
      Ini.WriteString('Mail', 'Recipients', MAIL_RECIPIENTS);
    finally
      Ini.Free;
    end;
  Except on E:Exception do
    begin
      Log.AddLog('Erreur dans SaveIni() : ' + E.Message);
      Result := False;
    end;
  end;
end;

function TBackup.SaveListVM:Boolean;
begin
  Result := True;
  try
    List_VM.SaveToFile(ChangeFileExt(PathExe, '.lst'));
  Except on E:Exception do
    begin
      Log.AddLog('Erreur dans SaveListVM() : ' + E.Message);
      Result:= False;
    end;
  end;
end;

procedure TBackup.SetESXi_IP(aValue: string);
begin
  ESXi_IP := aValue;
end;

procedure TBackup.SetESXi_Name(aValue: string);
begin
  ESXi_Name := aValue;
end;

procedure TBackup.SetESXi_Password(aValue: string);
begin
  ESXi_Password := aValue;
end;

procedure TBackup.SetESXi_PathBck(aValue: string);
begin
  ESXi_PathBck := aValue;
end;

procedure TBackup.SetESXI_User(aValue: string);
begin
  ESXi_User := aValue;
end;

procedure TBackup.SetLocal_NbBackup(aValue: Integer);
begin
  Local_NbBackup := aValue;
end;

procedure TBackup.SetLocal_PathBck(aValue: string);
begin
  Local_PathBck := aValue;
end;

{ TLog }

procedure TLog.AddLog(aText: string);
begin
  try
    try
      Lst.LoadFromFile(FileName);
      Lst.Add(FormatDateTime('yyyy/mm/dd hh:nn:ss', now) + ' : ' + aText);
    finally
      Lst.SaveToFile(FileName);
    end;
  except
  end;
end;

constructor TLog.Create(aPathExe: string);
begin
  Lst := TStringList.Create;
  FileName := ExtractFilePath(aPathExe) + 'Log\Log Backup' + FormatDateTime('yyyy-mm-dd_hh-nn-ss', now) + '.log';
  ForceDirectories(ExtractFilePath(aPathExe) + 'Log');
  Lst.SaveToFile(FileName);
end;

destructor TLog.Free;
begin
  Lst.Free;
end;

function TLog.GetFileName: string;
begin
  Result := FileName;
end;

function TLog.GetLog: string;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to Lst.Count-1 do
    Result := Result + Lst.Strings[I] + #13#10;
end;

function TBackup.SendEmail(const Subject: string; const Body: string):Boolean;
var
  tsTmp     : TStringList;
begin
  tsTmp := TStringList.Create;
  try
    tsTmp.Add(Log.FileName);
    Result := SendMail( MAIL_HOST,
                        MAIL_PORT,
                        MAIL_ACCOUNT,
                        MAIL_PASSWORD,
                        tsm_TLS,
                        MAIL_ACCOUNT,
                        MAIL_RECIPIENTS,
                        Format('%s - Backup ESXi du %s ',[Subject, FormatDateTime('DD/MM/YYYY à hh:mm:ss',Now)]),
                        Body,
                        tsTmp);
  finally
    FreeAndNil(tsTmp);
  end;
end;

end.

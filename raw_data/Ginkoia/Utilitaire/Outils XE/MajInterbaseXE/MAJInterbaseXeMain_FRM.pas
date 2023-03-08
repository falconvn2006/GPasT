unit MAJInterbaseXeMain_FRM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, CategoryButtons, ActnList, StdCtrls, ComCtrls, RzStatus,
  uLogs, uToolsXE, StrUtils, Registry, Unite_Def, IBServices, ShlObj, LMDPNGImage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdMessage, IdAttachmentFile, IniFiles,ShellAPI,
  Informations,RegExpr;

type
  TFrm_MAJInterbaseXEMain = class(TForm)
    Pan_Corp: TPanel;
    Pan_Footer: TPanel;
    Pan_Option: TPanel;
    CategoryButtons1: TCategoryButtons;
    ProgressBar1: TProgressBar;
    Lab_text: TLabel;
    ActLst_Etape: TActionList;
    Ax_VerifcationReg: TAction;
    Ax_CoupIB: TAction;
    Ax_InstalPatch: TAction;
    Ax_RedemarIB: TAction;
    IBServerProperties: TIBServerProperties;
    Gbx_EtatVerif: TGroupBox;
    Gbx_LogVerif: TGroupBox;
    Memo_verif: TMemo;
    Lab_BaseConnec: TLabel;
    Img_EtatIB: TImage;
    Lab_Patch: TLabel;
    Img_patch: TImage;
    Img_Cancel: TImage;
    Img_Valid: TImage;
    Tim_AutoStart: TTimer;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure Ax_VerifcationRegExecute(Sender: TObject);
    procedure Ax_CoupIBExecute(Sender: TObject);
    procedure Ax_RedemarIBExecute(Sender: TObject);
    procedure Ax_InstalPatchExecute(Sender: TObject);
    procedure Tim_AutoStartTimer(Sender: TObject);
  private
    { Déclarations privées }
    Procedure GestDossier(sPatchDir : String);
    Procedure StopAppAndService;
    Procedure TraitementAuto;
    Procedure LockAffichage(Etat : Boolean);
    Procedure EnvoiMail(MessageMail : TIdMessage);
    Function  VerifDll : Boolean;
  public
    { Déclarations publiques }
  end;
  resourcestring
    { Déclaration des ressources String }
    RS_VERSION_DLL_IB     = 'Version d''InterBase :'#13#10'%s';
    RS_CHEMIN_IB          = 'Chemin du service InterBase :'#13#10'%s';
    RS_SERVICE_EXISTE_PAS = 'Le service n''existe pas.';
  const
    SERVICE_IBXE          = 'IBS_gds_db';
    RECUP_CHEMIN          = '^"(.+)"|^(\S+)';

var
  Frm_MAJInterbaseXEMain: TFrm_MAJInterbaseXEMain;
  VersionDLL_IB         : String;

  vVersionInterBase:  TInfoSurExe;
  vInfoService:       TInfoSurService;
  sCheminInterBase:   String;
  sCheminBDD:         String;
  ExprRegServ:        TRegExpr;

implementation

{$R *.dfm}

procedure TFrm_MAJInterbaseXEMain.Ax_CoupIBExecute(Sender: TObject);
begin
  {$REGION 'Arrêt de l''instance d''interbase XE'}
   try
      Logs.AddToLogs('  -> Arrêt du service interbase');
      ServiceStop('','IBG_gds_db');

      Logs.AddToLogs('      - Arrêt Ibguard');
      KillProcessus('ibguard.exe');

      Logs.AddToLogs('      - Arrêt Ibserver');
      KillProcessus('ibserver.exe');
      Logs.AddToLogs('');

      Img_EtatIB.Picture := Img_Cancel.Picture;
   Except on E:Exception do
      begin
        raise Exception.Create('Arrêt Interbase Erreur -> ' + E.Message);
      end;
    end;
  {$ENDREGION}
end;

procedure TFrm_MAJInterbaseXEMain.Ax_InstalPatchExecute(Sender: TObject);
var
  Res, ResClt, ResSrv : TResourceStream;
  Reg                 : TRegistry;
  iResult             : Integer;
  Iinstal             : Integer;
begin
  {$REGION 'Installation du patch XE 5'}
  Logs.AddToLogs('  -> Extraction du patch');
  Logs.AddToLogs('');
  Res         := TResourceStream.Create(HInstance,'PATCH',RT_RCDATA);
  ResClt      := TResourceStream.Create(HInstance,'CLT',RT_RCDATA);
  ResSrv      := TResourceStream.Create(HInstance,'SRV',RT_RCDATA);
  try
    GestDossier(sPatchPathXE);
    Res.SaveToFile(sPatchPathXE+'PATH.exe');
    ResClt.SaveToFile(sPatchPathXE+'installclt.txt');
    ResSrv.SaveToFile(sPatchPathXE+'installSrv.txt');
  finally
    Res.Free;
  end;

  Logs.AddToLogs('  -> Extraction réussi avec succès');
  Logs.AddToLogs('');
  Logs.AddToLogs('  -> Installation du patch XE 5');

  //Logs.AddToLogs('/c "' +  sPatchPathXE + Format('PATH.exe" /s /m="%sinstallSrv.txt"',[sPatchPathXE]));

  GestDossier(sPathTemp);

  if InstallMode = mrServer then
  begin
    Iinstal := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' +  sPatchPathXE + Format('PATH.exe /s /m=%sinstallSrv.txt"',[sPatchPathXE]));
  end;

  if InstallMode = mrClient then
  begin
    Iinstal := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' +  sPatchPathXE + Format('PATH.exe /s /m=%sinstallClt.txt"',[sPatchPathXE]));
  end;

  if Iinstal <> -1 then
  begin
    Logs.AddToLogs('  -> Installation Abandonnée ');
  end else
  begin
    Logs.AddToLogs('  -> Mise à jour de la base de registre ');
    Reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
    Try
      try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db',False);
        if TRIM(reg.ReadString('Version')) = 'Wl-10.0.5.595' then
        begin
          Logs.AddToLogs('  -> Version de la base de registre correcte');
          Img_patch.Picture := Img_Valid.Picture;
        end else
        begin
          reg.WriteString('Version', 'Wl-10.0.5.595');
          Logs.AddToLogs('  -> Mise à jour terminé');
          Img_patch.Picture := Img_Valid.Picture;
        end;
      Except on E:Exception do
        begin
          raise Exception.Create('Mise à jour de la base de registre Erreur -> ' + E.Message);
          Img_patch.Picture := Img_Cancel.Picture;
        end;
      end;
     Finally
        Reg.Free;
     End;
     Logs.AddToLogs('  -> Installation terminé ');
     Logs.AddToLogs('');
  end;

     Logs.AddToLogs('');

  {$ENDREGION}
end;

procedure TFrm_MAJInterbaseXEMain.Ax_RedemarIBExecute(Sender: TObject);
begin
  {$REGION 'Redémarrage de l''instance d''interbase'}
  Logs.AddToLogs('  -> Redémarrage du service interbase');
  ServiceStart('','IBG_gds_db');
  Logs.AddToLogs('');

  Img_EtatIB.Picture := Img_Valid.Picture;
  {$ENDREGION}
end;

procedure TFrm_MAJInterbaseXEMain.Ax_VerifcationRegExecute(Sender: TObject);
var
  Reg       : TRegistry;
  j         : Integer;
  DirSystem : String;
  ServExist : Boolean;
begin
  {$REGION 'Verifie si le service est actif'}
  try
    IBServerProperties.Active := False;
    IBServerProperties.Active := True;
    Img_EtatIB.Picture        := Img_Valid.Picture;
  Except on E:Exception do
    begin
      Img_EtatIB.Picture := Img_Cancel.Picture;
    end;
  end;
  IBServerProperties.Active := False;
  {$ENDREGION}

  {$REGION 'Partie de vérification de la base de registre'}
  GestDossier(sPatchLog);
  Logs.Create;
  Logs.Path     := sPatchLog;
  Logs.FileName := Format('E0-Initialisation%s.log',[FormatDateTime('YYYYMMDDhhmmss',Now)]);
  Logs.Memo     := Memo_verif;

  Logs.AddToLogs('-------------------------------------------------------');
  Logs.AddToLogs('Etape - Vérification de la version de la DLL gds32.dll');
  Logs.AddToLogs('-------------------------------------------------------');
  Logs.AddToLogs('');

  {$REGION 'Vérifie si le service existe'}
    if ServiceExiste(SERVICE_IBXE) then
    begin
      //Afficher(Format(RS_SERVICE_EXISTE, [SERVICE_IB7]));
      vInfoService := InfoSurService(SERVICE_IBXE);
    end
    else if ServiceExiste(SERVICE_IBXE) then
    begin
      //Afficher(Format(RS_SERVICE_EXISTE, [SERVICE_IBXE]));
      vInfoService := InfoSurService(SERVICE_IBXE);
      ServExist    := True;
    end
    else begin
      ServExist    := False;
      //raise Exception.Create(RS_SERVICE_EXISTE_PAS);
    end;
    {$ENDREGION 'Vérifie si le service existe'}

  {$REGION 'Récupération du chemin d''interbase '}
  if ServExist then
  begin
    ExprRegServ := TRegExpr.Create();
      try
        ExprRegServ.Expression  := RECUP_CHEMIN;

        if ExprRegServ.Exec(vInfoService.BinaryPathName) then
          sCheminInterBase := ExprRegServ.Match[1] + ExprRegServ.Match[2]
        else
          sCheminInterBase := vInfoService.BinaryPathName;
      finally
        ExprRegServ.Free();
      end;

      if sCheminInterBase <> '' then
      begin
        sCheminInterBase := StringReplace(sCheminInterBase, 'ibserver.exe', 'gds32.dll', [rfReplaceAll,rfIgnoreCase]);
      end else
      begin
        Logs.AddToLogs('Service Interbase non trouvé');
        Exit;
      end;
  end else
  begin
    // Le service n'existe pas je vais lire l'information dans la base de registre
    Reg := TRegistry.Create(KEY_READ or KEY_WOW64_32KEY);
    Try
      try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
        begin
          reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db',False);
          sCheminInterBase := reg.ReadString('ServerDirectory');
          sCheminInterBase := sCheminInterBase + '\gds32.dll';
        end;
      Except on E:Exception do
      begin
        raise Exception.Create('Lecture de la base de registre Erreur -> ' + E.Message);
      end;
    end;
    Finally
      Reg.Free;
    End;

  end;

  {$ENDREGION}

  {$REGION 'Vérification version DLL '}
  if FileExists(sCheminInterBase) then
  begin
    vVersionInterBase := InfoSurExe(sCheminInterBase);

    if (vVersionInterBase.FileVersion <> 'WI-V10.0.5.595') then
    begin
      Logs.AddToLogs('  -> Mise à jour Interbase XE nécéssaire la version actuel est '+ vVersionInterBase.FileVersion);
      Img_patch.Picture := Img_Cancel.Picture;

      //Je déplie toute les catégorie
      for j := 0 to CategoryButtons1.Categories.Count -1 do
      begin
       CategoryButtons1.Categories.Items[j].Collapsed := False;
      end;

    end else
    begin
      Logs.AddToLogs('  -> Vous disposez du dernier patch XE5 v10.0.5.595 ');
      Img_patch.Picture := Img_Valid.Picture;
    end;

  end else
  begin
    DirSystem := SpecialFolder(CSIDL_SYSTEM);
    DirSystem := DirSystem + '\gds32.dll';

    if FileExists(DirSystem) then
    begin
      vVersionInterBase := InfoSurExe(DirSystem);

      if (vVersionInterBase.FileVersion <> 'WI-V10.0.5.595') then
      begin
        Logs.AddToLogs('  -> Mise à jour Interbase XE nécéssaire la version actuel est '+ vVersionInterBase.FileVersion);
        Img_patch.Picture := Img_Cancel.Picture;

      end else
      begin
        Logs.AddToLogs('  -> Vous disposez du dernier patch XE5 v10.0.5.595 ');
        Img_patch.Picture := Img_Valid.Picture;

      end;
    end;
  end;
  {$ENDREGION}

//  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_32KEY);
//  Try
//    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
//      if Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
//      begin
//        reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db',False);
//        if TRIM(reg.ReadString('Version')) = 'Wl-10.0.5.595' then
//        begin
//          Logs.AddToLogs('  -> Version de la base de registre correcte');
//          Img_patch.Picture := Img_Valid.Picture;
//        end else
//        begin
//          Logs.AddToLogs('  -> Mise à jour Interbase XE nécéssaire');
//          Img_patch.Picture := Img_Cancel.Picture;
//
//          //Je déplie toute les catégorie
//          for j := 0 to CategoryButtons1.Categories.Count -1 do
//          begin
//           CategoryButtons1.Categories.Items[j].Collapsed := False;
//          end;
//
//        end;
//      end else
//      begin
//        Logs.AddToLogs('  -> Interbase XE non trouvé sur le poste');
//        if Reg.KeyExists('\Software\Borland\Interbase\CurrentVersion') then
//        begin
//          Logs.AddToLogs('  -> Interbase 7 présent sur le poste');
//        end
//      end;
//    Except on E:Exception do
//      begin
//        raise Exception.Create('Lecture de la base de registre Erreur -> ' + E.Message);
//      end;
//    end;
//  Finally
//    Reg.Free;
//  End;
  Logs.AddToLogs('');

  {$ENDREGION}
end;

procedure TFrm_MAJInterbaseXEMain.EnvoiMail(MessageMail: TIdMessage);
begin
  {$REGION 'Paramétrage pour l''envoi de mail'}
  with IdSMTP1 do
  try
    Disconnect();
    Host     := 'pod51015.outlook.com';
    Username := 'Admin@ginkoia.fr';
    Password := 'Duda7196741';
    Try
      Port := 587;
      Logs.AddToLogs('  -> Test Port 587');
      Connect;
    Except on E:Exception do
      begin
        try
        Port := 25;
        Logs.AddToLogs('  -> Test du Port 25');
        Connect;
        Except on E:Exception do
          raise Exception.Create('SendMailList Connexion -> ' + E.Message);
        end;
      end;
    End;
    Logs.AddToLogs('  -> Envoi du mail en cours');
    Send(MessageMail);
    Logs.AddToLogs('  -> Mail envoyé');
  Except on E:Exception do
    begin
      Logs.Memo := nil;
      Logs.Path := sPatchLog;
      Logs.FileName := 'MailSend.txt';
      Logs.AddToLogs(E.Message);
    end;
  end;
  {$ENDREGION}
end;

procedure TFrm_MAJInterbaseXEMain.FormCreate(Sender: TObject);
var
  sPassword : String;
  bOk       : Boolean;
  AutoMode  : Boolean;
  i,j       : Integer;
begin
  bOk          := False;
  AutoMode     := False;
  sPathProg    := ExtractFilePath(Application.ExeName);
  sPatchLog    := sPathProg+'Logs\';
  sPatchPathXE := sPathProg+'Path\';
  sPathTemp    := sPathProg+'Temp\';

  {$REGION 'Lecture Param'}
  for j := 0 to CategoryButtons1.Categories.Count -1 do
  begin
    CategoryButtons1.Categories.Items[j].Collapsed := True;
    if j < 1 then
    begin
      CategoryButtons1.Categories.Items[j].Collapsed := False;
    end;
  end;

  for i := 1 to ParamCount do
  begin
    case AnsiIndexStr(UpperCase(ParamStr(i)),['AUTO','SERVEUR','CLIENT']) of
      0: begin // Mode Auto Activé
        for j := 0 to CategoryButtons1.Categories.Count -1 do
        begin
          CategoryButtons1.Categories.Items[j].Collapsed := True;
        end;

        AutoMode    := True;
        bOk         := True;
        InstallMode := mrServer;
        end;
      1: begin //Mode Serveur
          InstallMode := mrServer;
         end;

      2: begin //Mode Client
          InstallMode := mrClient;
         end;
    end;
  end;
  {$ENDREGION}

  {$REGION 'Mot de passe au lancement du programme'}
  if bOk = False then
  begin
    if InputPassword('Veuillez saisir le mot de passe','',sPassword) then
    begin
      if UpperCase(sPassword) = 'GINKOIA1082' then
      begin
        bOk := True;
      end else
      begin
        Application.Terminate;
      end;
    end else
    begin
      Application.Terminate;
    end;
  end;
  {$ENDREGION}

  {$REGION 'Mode AUTO'}
  if AutoMode then
  begin
    //Le programme est lancé en mode AUTO
    LockAffichage(True);
    Tim_AutoStart.Enabled := True;
  end;
  {$ENDREGION}
end;

procedure TFrm_MAJInterbaseXEMain.GestDossier(sPatchDir : String);
begin
  //Procedure qui permet la gestion de dossier créer un dossier si inexistant
  if not DirectoryExists(sPatchDir) then
  begin
    if CreateDir(sPatchDir) then
  end;
end;

procedure TFrm_MAJInterbaseXEMain.LockAffichage(Etat: Boolean);
begin
  //procedure qui permet de bloquer l'affichaque que l'utilisateur ne puisse rien faire
  CategoryButtons1.Enabled := not Etat;
end;

procedure TFrm_MAJInterbaseXEMain.StopAppAndService;
const
  ginkoia     = 'ginkoia.exe';
  Caisse      = 'CaisseGinkoia.exe';
  Script      = 'Script.exe';
  PICCO       = 'Piccolink.exe';
  LauncherV7  = 'LaunchV7.exe';
  SyncWeb     = 'SyncWeb.exe';
begin
  Logs.AddToLogs('--- Arrêt des applications et services ---');
  Logs.AddToLogs('  -> Maj Windows');
  ServiceStop('','wuauserv');
  Logs.AddToLogs('  -> Launcher');
  KillProcessus(LauncherV7);
  Logs.AddToLogs('  -> Ginkoia');
  KillProcessus(ginkoia);
  Logs.AddToLogs('  -> Caisse');
  KillProcessus(Caisse);
  Logs.AddToLogs('  -> Script');
  KillProcessus(Script);
  Logs.AddToLogs('  -> Piccolink');
  KillProcessus(PICCO);
  Logs.AddToLogs('  -> SyncWeb');
  KillProcessus(SyncWeb);
end;

procedure TFrm_MAJInterbaseXEMain.Tim_AutoStartTimer(Sender: TObject);
begin
  Tim_AutoStart.Enabled := false;
  Lab_text.Visible := True;
  Lab_text.Caption := 'Installation du patch XE 5 en cours ...';
  TraitementAuto;
end;

procedure TFrm_MAJInterbaseXEMain.TraitementAuto;
var
  TraitementOk : Boolean;
  MailSujet    : String;
  GinkoiaDir   : String;
  StringList   : TStringList;
  Search       : TSearchRec;
  i            : Integer;
  Reg          : TRegistry;
  GINKOIAIBDIR : String;
  GINKOIAIB    : String;
begin
  {$REGION 'Installation du patch automatiquement'}
  progressBar1.Visible := True;
  Application.ProcessMessages;
  ProgressBar1.StepBy(1);
  GestDossier(sPatchLog);
  Logs.Create;
  Logs.Path     := sPatchLog;
  Logs.FileName := Format('AutoInstalPath%s.log',[FormatDateTime('YYYYMMDDhhmmss',Now)]);
  Logs.Memo     := Memo_verif;

  Logs.AddToLogs('-------------------------------------------------------');
  Logs.AddToLogs('- Installation du patch XE 5 -');
  Logs.AddToLogs('-------------------------------------------------------');
  Logs.AddToLogs('');
  try


    if VerifDll = True then
    begin
      Logs.AddToLogs(' -> Patch XE 5 déjà présent ');
    end else
    begin
      Ax_CoupIB.Execute;
      ProgressBar1.StepBy(33);
      Ax_InstalPatch.Execute;
      ProgressBar1.StepBy(70);
      Ax_RedemarIB.Execute;
    end;


    Logs.AddToLogs('-------------------------------------------------------');
    Logs.AddToLogs('- Fin installation du patch -');
    Logs.AddToLogs('-------------------------------------------------------');
    ProgressBar1.StepBy(100);
    TraitementOk := True;
  except on E:Exception do
    begin
      TraitementOk := False;
    end;
  end;

  {$ENDREGION}

  {$REGION 'Envoi de mail'}

  if TraitementOk = False then
  begin
    MailSujet := 'Echec'
  end else
  begin
    MailSujet := 'Réussie';
  end;


  // Création du corps du mail
  IdMessage1.Body.Clear;
  IdMessage1.Body.Add('--- Mise à jour du Patch XE 5 --- ' + MailSujet);
  IdMessage1.From.Text                 := 'Admin@ginkoia.fr';
  IdMessage1.Recipients.EMailAddresses := 'stanley.jasmin@ginkoia.fr';

  // Récupération du répertoire de ginkoia
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Algol\Ginkoia', False);
    GINKOIAIBDIR := ExtractFilePath(reg.ReadString('Base0'));
    GINKOIAIB := reg.ReadString('Base0');
  finally
    reg.free;
  end;

   GinkoiaDir := ExtractFilePath(ExcludeTrailingPathDelimiter(GINKOIAIBDIR));
   With TIniFile.Create(GinkoiaDir + 'Ginkoia.ini') do
   try
    IdMessage1.Subject := Format('Mise à jour du patch XE5 -%s -%s',[MailSujet,ReadString('NOMMAGS','MAG0',''),ReadString('NOMPOSTE','POSTE0','')]);
    StringList := TStringList.Create;
    try
      IdMessage1.Body.Add('');
      ReadSection('NOMMAGS',StringList);
      IdMessage1.Body.Add('[NOMMAGS]');
      for i := 0 to StringList.Count -1 do
        IdMessage1.Body.Add(StringList[i]);
      IdMessage1.Body.Add('');
      IdMessage1.Body.Add('[NOMPOSTE]');
      ReadSection('NOMPOSTE',StringList);
      for i := 0 to StringList.Count -1 do
        IdMessage1.Body.Add(StringList[i]);
      IdMessage1.Body.Add('');
      IdMessage1.Body.Add('[NOMBASE]');
      ReadSection('NOMBASE',StringList);
      for i := 0 to StringList.Count -1 do
        IdMessage1.Body.Add(StringList[i]);
    finally
      StringList.Free;
    end;
    finally
      Free;
    end;

  // Gestion des pièces jointes
  if TraitementOk = False then
  begin
    // Récupération de la liste des fichiers de logs si on est en erreur (E*.*)
    Logs.AddToLogs(sPatchLog + '*.*');
    i := FindFirst(sPatchLog + '*.*',faAnyFile,Search);
    try
      while i = 0 do
      begin
       if (Search.Name <> '.') and (Search.Name <> '..') then
         if Pos('-G',Search.Name) = 0  then
         begin
           Logs.AddToLogs('  -> Envoi du fichier :' + Search.Name);
           TIdAttachmentFile.Create(IdMessage1.MessageParts,sPatchLog + Search.Name);
         end;
        i := FindNext(Search);
      end;
    finally
      FindClose(Search);
    end;
  end;
  EnvoiMail(IdMessage1);
  // Envoi du mail

  {$ENDREGION}

  Lab_text.Visible := False;

  Sleep(1000);
  Application.Terminate;
end;

function TFrm_MAJInterbaseXEMain.VerifDll: Boolean;
var
 DirSystem : String;
 ServExist : Boolean;
 Reg       : TRegistry;
begin
  //Vérification de la version de la DLL gds32.dll
  Result := False;

  if InstallMode = mrServer then
  begin
    {$REGION 'Vérifie si le service existe'}
    if ServiceExiste(SERVICE_IBXE) then
    begin
      vInfoService := InfoSurService(SERVICE_IBXE);
    end
    else if ServiceExiste(SERVICE_IBXE) then
    begin
      vInfoService := InfoSurService(SERVICE_IBXE);
      ServExist    := True;
    end
    else begin
      ServExist    := False;
    end;
    {$ENDREGION 'Vérifie si le service existe'}

    {$REGION 'Récupération du chemin d''interbase '}
    if ServExist then
    begin
      ExprRegServ := TRegExpr.Create();
        try
          ExprRegServ.Expression  := RECUP_CHEMIN;

          if ExprRegServ.Exec(vInfoService.BinaryPathName) then
            sCheminInterBase := ExprRegServ.Match[1] + ExprRegServ.Match[2]
          else
            sCheminInterBase := vInfoService.BinaryPathName;
        finally
          ExprRegServ.Free();
        end;

        if sCheminInterBase <> '' then
        begin
          sCheminInterBase := StringReplace(sCheminInterBase, 'ibserver.exe', 'gds32.dll', [rfReplaceAll,rfIgnoreCase]);
        end else
        begin
          Logs.AddToLogs('Service Interbase non trouvé');
          Exit;
        end;
    end else
    begin
      // Le service n'existe pas je vais lire l'information dans la base de registre
      Reg := TRegistry.Create(KEY_READ or KEY_WOW64_32KEY);
      Try
        try
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          if Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
          begin
            reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db',False);
            sCheminInterBase := reg.ReadString('ServerDirectory');
            sCheminInterBase := sCheminInterBase + '\gds32.dll';
          end;
        Except on E:Exception do
        begin
          raise Exception.Create('Lecture de la base de registre Erreur -> ' + E.Message);
        end;
      end;
      Finally
        Reg.Free;
      End;

    end;

    {$ENDREGION}

    {$REGION 'Vérification version DLL '}
    if FileExists(sCheminInterBase) then
    begin
      vVersionInterBase := InfoSurExe(sCheminInterBase);

      if (vVersionInterBase.FileVersion <> 'WI-V10.0.5.595') then
      begin
        Logs.AddToLogs('  -> Mise à jour Interbase XE nécéssaire');
        Img_patch.Picture := Img_Cancel.Picture;

        result := False;
      end else
      begin
        Logs.AddToLogs('  -> Vous disposez du dernier patch XE5 v10.0.5.595 ');
        Img_patch.Picture := Img_Valid.Picture;

        result := True;
      end;

    end;
    {$ENDREGION}
  end;

  if InstallMode = mrClient then
  begin
    DirSystem := SpecialFolder(CSIDL_SYSTEM);
    DirSystem := DirSystem + '\gds32.dll';

    if FileExists(DirSystem) then
    begin
      vVersionInterBase := InfoSurExe(DirSystem);

      if (vVersionInterBase.FileVersion <> 'WI-V10.0.5.595') then
      begin
        Logs.AddToLogs('  -> Mise à jour Interbase XE nécéssaire');
        Img_patch.Picture := Img_Cancel.Picture;

        result := False;
      end else
      begin
        Logs.AddToLogs('  -> Vous disposez du dernier patch XE5 v10.0.5.595 ');
        Img_patch.Picture := Img_Valid.Picture;

        result := True;
      end;
    end;

  end;
end;

end.

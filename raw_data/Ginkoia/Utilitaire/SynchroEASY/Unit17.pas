unit Unit17;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, uThreadDB, UWMI, uThreadWMI, uThreadLinkLame,
  uWsQtePull, Vcl.ComCtrls,uThreadSynchro, {dxGDIPlusClasses,}ServiceControler,
  System.Notification, Vcl.Buttons,Math, System.IOUtils,uWinVersion,
  dxGDIPlusClasses;

Const Cst_60s  =  60000;
      Cst_30s  =  50000;
      Cst_20s  =  20000;
      Cst_10s  =  10000;
      Cst_3min = 180000;
type
  EnumWindowsProc = function (Hwnd : THandle;Param:Pointer):Boolean;stdcall;

  TForm17 = class(TForm)
    tmDB: TTimer;
    tmWMI: TTimer;
    StatusBar1: TStatusBar;
    tmLinkLame: TTimer;
    mLog: TMemo;
    Panel3: TPanel;
    Image2: TImage;
    Label9: TLabel;
    Panel4: TPanel;
    img_HeartBeart: TImage;
    lbl_lame: TLabel;
    lbl_heartbeat: TLabel;
    tmDecision: TTimer;
    img_lines: TImage;
    img_infos: TImage;
    pbGeneral: TProgressBar;
    PnAction: TPanel;
    img_cloud: TImage;
    img_Syncrho: TImage;
    lbl_BIG_Center: TLabel;
    NotificationCenter1: TNotificationCenter;
    tmAutoCloseInX: TTimer;
    BDETAILS: TBitBtn;
    Panel1: TPanel;
    lbl_Push: TLabel;
    BSYNCHRO: TBitBtn;
    img_OK: TImage;
    pbDetails: TProgressBar;
    tmElapse: TTimer;
    img_Error: TImage;
    BQUITTER: TBitBtn;
    edt_BAS_IDENT: TEdit;
    edt_SENDER: TEdit;

    Procedure StatusCallBack(Const s:String);
    procedure pbGeneralCallBack(Const position:integer);
    procedure pbDetailsCallBack(Const position:integer);
    procedure CallBackDB(Sender: TObject);
    procedure CallBackWMI(Sender: TObject);
    procedure CallBackLinkLame(Sender: TObject);
    procedure tmDBTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmWMITimer(Sender: TObject);
    procedure tmLinkLameTimer(Sender: TObject);
    procedure BSYNCHROClick(Sender: TObject);
    procedure CallBackSYnchro(Sender: TObject);
    procedure tmDecisionTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmAutoCloseInXTimer(Sender: TObject);
    procedure BDETAILSClick(Sender: TObject);
    procedure tmElapseTimer(Sender: TObject);
    procedure BQUITTERClick(Sender: TObject);
  private
    FSynchroPaths : TSynchroPaths;
    FMultiSynchroPossible : boolean;

    FWinVersion : TWinVersion;
    FOSINFOS    : TOSINFOS;
    FCanShowNotif : Boolean;
    FBLockage   : Integer;
    FDEBUG      : boolean;
    FFrmMultiSites : integer;
    FLock       : boolean;
    FCHOIX      : integer;  // 0 pas de choix
                            // 1 "Sauvegarder"
                            // 2 "Forcer"
                            // 3 "Ne rien faire" c'est pas tout à fait comme 0
    FStart      : Cardinal;
    FAUTOStart  : boolean;
    FTimeClose  : integer;
    FFistPass   : boolean;
    FAccesLame  : Boolean;
    FIBFILE     : string;
    FNOTPUSH    : integer;
    FURL        : string;
    FNode       : string;
    FNode_Group : string;
    FMgsFreeSpace : string;
    FThreadSyncho   : TThreadSynchro;
    FThreadDB       : TThreadDB;
    FThreadWMI      : TThreadWMI;
    //------------------------------
    FEASY_EXTERNAL_ID : string;
    FEASY_GROUP_ID    : string;
    // FDB_NODE_ID       : string;
    // FDB_NODE_GROUP_ID : string;
    //------------------------------
    FThreadQtePull  : TThreadWsQtePull;
    FThreadLinkLame : TThreadLinkLame;
    FFileExist_Server_NB   : boolean;
    FSYNCHRO_NB : string;    // BASE GINKCOPY.IB
    FGENERAL_ID : Int64;
    FDRIVES : TDrives;
    FFREESPACE : int64;
    FFileSize_Local_IB      : Int64;
    FFileSize_Local_OLD     : Int64;
    FFileSize_Server_NB     : Int64;
    FFileDateTime_Server_NB : TDateTime;
    FError_Message          : string;
    FRollBackOK             : integer;
    FHandleLauncher         : HWND;
//    FHandleSystrayLauncher  : HWND;
    function SecondToTime(const Seconds: double): String;
    Procedure processParameters();
    procedure RelancerLauncherEasy();
    procedure KillProgrammes();
    procedure SauveLog();
    Procedure AddLog(Const s:String);
    procedure CloseInXseconds(const aSec:integer=30);
    procedure ShowNotification(aTitle:string;aBody:string);
    procedure ParamScreen();
    procedure ReCenter();
    function Get_FileSize(aFileName:TFileName):int64;
    procedure ResultatError(aMsg:string);
    { Déclarations privées }
    function GetInfo(Const Ressource:String): String;
  public
    { Déclarations publiques }
    property FileSize_Local_IB    : Int64     read FFileSize_Local_IB;
    property FileSize_Local_OLD   : Int64     read FFileSize_Local_OLD;
    property FileSize_Server_NB   : Int64     read FFileSize_Server_NB;
    property FileExist_Server_NB  : boolean   read FFileExist_Server_NB;
    property Error_Message        : string    read FError_Message;
    property RollBackOK           : integer   read FRollBackOK;
  end;

var
  Form17: TForm17;

implementation

{$R *.dfm}

uses Force_Frm, uProcess, ChoixServer_Frm;


function GetTitle(Hwnd : THandle;Param:Pointer):Boolean;stdcall;
var Text : string;
begin
  SetLength(Text,100);
  GetWindowText(Hwnd,Pchar(Text),100);
  // Attention le Systray a également sont Handle.... lui envoyer le message sert à rien
  // de plus le Systray du Launcher EASY a pour Caption "Launcher EASY"
  // c'est pour cette raison qu'il y a un espace à la fin
  // mais avec le • ca devrait etre bon....
  if (AnsiPos('Launcher EASY ',Text)>0) and (AnsiPos('•',Text)>0) then
     begin
         // Form17.ListBox1.Items.Add (Inttostr(Hwnd) + ' : ' + Text);
         If Form17.FHandleLauncher=0
           then
            begin
                Form17.FHandleLauncher:= Hwnd;
                if Form17.FDEBUG then
                  Form17.AddLog(Format('Launcher EASY Handle : %d / %s',[Hwnd,Text]));
            end;

         // else Form17.FHandleSystrayLauncher:= Hwnd;
     end;
  GetTitle := True;
end;

function TForm17.GetInfo(Const Ressource:String): String;
var VerInfoSize: DWord;
    VerInfo: Pointer;
    VerValueSize: DWord;
    VerValue: PVSFixedFileInfo;
    Dummy: DWord;
begin
     result:='';
     VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
     if VerInfoSize <> 0
        then
            begin
                 GetMem(VerInfo, VerInfoSize);
                 GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
                 if Ressource='Version'
                    then
                        begin
                             VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
                             with VerValue^ do
                                  begin
                                       result := IntTostr(dwFileVersionMS shr 16);
                                       result := result+'.'+ IntTostr(dwFileVersionMS and $FFFF);
                                       result := result+'.'+ IntTostr(dwFileVersionLS shr 16);
                                       result := result+'.'+ IntTostr(dwFileVersionLS and $FFFF);
                                  end;
                        end;
                 if Ressource='LegalCopyright'
                    then
                        begin
                             {$IFDEF VER150}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(Pointer(VerValue));
                             {$ENDIF}
                             {$IFDEF VER210}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$ENDIF}
                        end;
                 if Ressource='InternalName'
                    then
                        begin
                             {$IFDEF VER150}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(Pointer(VerValue));
                             {$ENDIF}
                             {$IF CompilerVersion>=22}
                             VerQueryValue(VerInfo, PChar('\StringFileInfo\040C04E4\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$IFEND}
                        end;
                 FreeMem(VerInfo, VerInfoSize);
            end
        else result:='';
end;

procedure TForm17.pbDetailsCallBack(Const position:integer);
begin
  PbDetails.Position := position;
end;


procedure TForm17.pbGeneralCallBack(Const position:integer);
begin
  PbGeneral.Position := position;
end;

Procedure TForm17.AddLog(Const s:String);
begin
  mLog.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss : ',Now()) + s);
end;


Procedure TForm17.StatusCallBack(Const s:String);
begin
  StatusBar1.Panels[1].Text  := s;
  AddLog(s);
end;


procedure TForm17.tmAutoCloseInXTimer(Sender: TObject);
begin
   tmAutoCloseInX.Enabled := false;
   If (FAutoStart) and not(FLOCK)
     then
      begin
         Dec(FTimeClose);
         StatusBar1.Panels[1].Text := Format('Fermerture de l''application dans %d secondes',[FTimeClose]);
         if (FTimeClose<=0)
            then Close;
      end;
   tmAutoCloseInX.Enabled := true;
end;

procedure TForm17.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := not(FLock);

   // c'est un abandon suite au message "Ne rien faire"
   // Abandonner la synchro et revenir au Launcher
   If FAutoStart and (FCHOIX=3)
     then
       begin
          RelancerLauncherEasy;
       end;

   // Erreur au Renommage ce n'est pas bloquant...
   If FAutoStart and (Error_Message='Erreur au renommage')
     then
       begin
          RelancerLauncherEasy;
       end;

   // Le RollBack à réussi (RollBack=1)
   If FAutoStart and (RollBackOK=1)
     then
       begin
          RelancerLauncherEasy;
       end;


   iF CanClose
      then
        begin
            SauveLog();
        end;

end;

procedure TForm17.SauveLog();
var vMyLog,vGinkoiaPath :string;
begin
     try
        vGinkoiaPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
        vMyLog       := vGinkoiaPath + 'Logs\SynchroEASY_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+ '.log';
        mLog.Lines.SaveToFile(vMyLog);
     except
       // pas grave  c'est que le LOG
     end;
end;

procedure TForm17.KillProgrammes;
var MessageSys : UINT; // Message recherché
    targetHandle: HWND;
    WindowProc : EnumWindowsProc;

begin
  MessageSys := RegisterWindowMessageW('Msg_Sys_Kill_LauncherEasy');
  WindowProc := GetTitle;
  EnumWindows(@WindowProc,0);

  if FHandleLauncher<>0
    then
      begin
        if FDebug then
           AddLog(Format('PostMsg Handle %s',[FHandleLauncher]));
        PostMessage(FHandleLauncher, MessageSys, 0, 0);
        Sleep(400);   // 400ms c'est le seuil de Doherty
      end;
  // On Kill Quand même
  KillProcessus('LauncherEASY.exe');
end;


procedure TForm17.RelancerLauncherEasy;
var vGinkoiaPath : string;
begin
  vGinkoiaPath     := IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(FIBFILE)))));
  ExecuterProcess('"' + vGinkoiaPath + 'LauncherEasy.exe"', 0);
end;



procedure TForm17.processParameters;
var i: integer;
    s: string;
begin
  for i := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(i)) = 'AUTO'   then FAutoStart := true;
    if UpperCase(ParamStr(i)) = 'DEBUG'  then FDEBUG := true;
    (* if pos(':\', s) > 0 then
    begin
      FAutoStart := true;
    end;
    *)
  end;
end;


function TForm17.Get_FileSize(aFileName:TFileName):int64;
var info: TWin32FileAttributeData;
begin
   result := -1;

   if NOT GetFileAttributesEx(PWideChar(aFileName), GetFileExInfoStandard, @info) then
      EXIT;

  result := Int64(info.nFileSizeLow) or Int64(info.nFileSizeHigh shl 32);
end;



procedure TForm17.FormCreate(Sender: TObject);
var vDATADir : string;

begin
    FOSINFOS := WMI_GetOsInfos;
    FWinVersion := GetWinVersion();
    FHandleLauncher := 0;
   // FHandleSystrayLauncher :=0;
    FCanShowNotif := (FWinVersion>=wv_Win81);

    Caption := Caption + ' - ' + GetInfo('Version');

    FError_Message := '';
    FRollBackOK := -1;
    FBLockage  := 0;

    FFrmMultiSites := 0;

    FDEBUG        := false;
    FAUTOStart    := false;
    FCHOIX        := 0;

    FLock := false;
    FFistPass := true;
    FAccesLame := false;

    VGSE.Init;
    GetBase0();
    FIBFILE := VGSE.Base0;

    FFileSize_Local_IB    := Get_FileSize(FIBFILE);
    vDATADir              := ExtractFilePath(FIBFILE);
    FFileSize_Local_OLD   := Get_FileSize(IncludeTrailingPathDelimiter(vDATADir)+ 'Backup\SYNCHRO.OLD');
    // '+ ChangeFileExt(ExtractFileName(FIBFILE), '

    FURL     := '';
    FNode    := '';
    FNOTPUSH := -1; // on sait pas encore....

    FEASY_EXTERNAL_ID := '';
    FEASY_GROUP_ID    := '';

    FFREESPACE   :=0;

    FFileSize_Server_NB  :=0;
    FFileExist_Server_NB := False;

    FMgsFreeSpace := '';
    Panel1.Visible:=false;

    ParamScreen();
    ProcessParameters;

    //
    // lbl_Recup_Infos
    // 'Synchronisation en cours'+#13+#10+'Veuillez patienter...'
    lbl_BIG_Center.Caption := 'Récupération et contrôle des informations'+#13+#10+'Veuillez patienter...';
    lbl_BIG_Center.Visible := true;
    Img_Infos.Visible := true;

    If FAutoStart
      then
        begin
           KillProgrammes;
        end;
end;

procedure TForm17.tmDecisionTimer(Sender: TObject);
var vFreeSpaceAfter:int64;
begin
    tmDecision.Enabled  := false;
    tmDecision.Interval := RandomRange(Cst_10s, Cst_20s);
    // Si un thread tourne ou que l'ecran Multisite arrive ... on se casse
    if Assigned(FThreadWMI) or Assigned(FThreadLinkLame) or Assigned(FThreadDB)
       or (FFREESPACE=0) or (FileSize_Server_NB=0) or (FFrmMultiSites>0)
      then
         begin
             IF FDEBUG
               then AddLog('Exit'); // au prochain passage
             tmDecision.Enabled := true;
             exit;
         end;
   // Si l'espace restant est inférieur à
   // le nouvelle espace = FileSize_Server_NB - FileSize_Local_IB
   // De toute facon "FileSize_Local_IB" ne rentre pas dans l'equation car il est juste déplacé
   //
   If ( FFREESPACE < 2000000000 + FileSize_Server_NB - FileSize_Local_OLD)
     then
      begin
         tmDecision.Enabled := true;
         if not(FMgsFreeSpace = 'Pas assez de place sur votre disque')
           then
            begin
               AddLog('Pas assez de place sur votre disque');
               FMgsFreeSpace := 'Pas assez de place sur votre disque';
            end;
         AtomicIncrement(FBLockage);
         ResultatError('Pas assez de place sur votre disque dur.');
         Exit;
      end;

   if (FNode_Group<>'') and (FNode<>'') and (FEASY_EXTERNAL_ID<>'') AND (FEASY_GROUP_ID<>'')
      and ((FNode_Group<>FEASY_GROUP_ID) or (FNode<>FEASY_EXTERNAL_ID))
      then
        begin
           AtomicIncrement(FBLockage);
           ResultatError('ERREUR GRAVE !!');
           Exit;
        end;

   BSYNCHRO.Enabled := (FNode_Group='portables')
                        and (FSYNCHRO_NB<>'')
                        and (FileExist_Server_NB)
                        and ((FNOTPUSH=0) or (FCHOIX=2));   // Si on a fait le choix de "FORCER"
//                        and ((FNOTPUSH>0) and not(FAccesLame))
   if BSYNCHRO.Enabled then
       begin
           if (FCHOIX=2)
              then BSYNCHRO.Caption:='Forcer la Synchro';

           BSYNCHRO.Visible := true;
           lbl_BIG_Center.Visible := False;
           // img_infos.Visible:=true;

           lbl_lame.Visible := true;
           img_cloud.Visible := true;

           lbl_heartbeat.Visible := true;
           img_HeartBeart.Visible := true;

           lbl_Push.Visible  := true;
           img_lines.Visible := true;

           // On arrete de "timer"
           TmWMI.Enabled       := false;
           TmLinkLame.Enabled  := false;
           tmDB.Enabled        := false;
           // On arrete les Timer
           AddLog('Date de la base du Magasin : '+DateTimeToStr(FFileDateTime_Server_NB));
           AddLog(Format('Espace disponible actuellement : %0.0f Mo',[FFREESPACE/1024/1024]));

           // AddLog('Taille de la base : '+IntToStr(FFileSize_NB));
           vFreeSpaceAfter := FFREESPACE - FileSize_Server_NB + FileSize_Local_OLD;
           AddLog(Format('Espace libre estimé restant après la synchro : %0.0f Mo',[vFreeSpaceAfter/1024/1024]));

           AddLog('Vous pouvez Lancer la Synchro');

           if FAUTOStart then
              begin
                 // lancement en mode Auto
                 BSYNCHROClick(self);
              end;
       end
     else
      begin
         if (FNode_Group<>'portables')
           then
              begin
                  AddLog('Vous n''êtes pas un noeud du groupe "portables"');
                  exit;
              end;
         If (FSYNCHRO_NB='')
            then
              begin
                  AddLog('Pas de chemin de Synchro');
                  exit;
              end;
         if not(FileExist_Server_NB)
            then
                begin
                  AddLog(Format('Le fichier %s n''existe pas',[FSYNCHRO_NB]));
                  exit;
                end;

         // Non bloquant
         if not(FAccesLame)
            then
              begin
                 AddLog('Aucun accès à la Lame');
              end;
         If (FNOTPUSH>0)
            then
               begin
                  AddLog(Format('Il reste des données non poussées %d',[FNOTPUSH]));
               end;
         if FBLockage=0
           then tmDecision.Enabled := true;
      end;
end;

procedure TForm17.tmDBTimer(Sender: TObject);
begin
   TmDB.Enabled := false;
   TmDB.Interval  := RandomRange(Cst_30s, Cst_60s);
   if FBLockage<>0 then exit;
   if not(Assigned(FThreadDB)) then
      begin
        AddLog('Récupération des informations dans la Base de Données...');
        FThreadDB := TThreadDB.Create(true, FFistPass, CallBackDB);
        FThreadDB.IBFILE := VGSE.Base0;
        FThreadDB.Start;
      end
   else
    begin
       TmDB.Enabled := true;
    end;
end;

procedure TForm17.tmElapseTimer(Sender: TObject);
begin
    tmElapse.Enabled:=false;
    try
      StatusBar1.Panels[0].Text := SecondToTime((GetTickCount() - FStart) / 1000);
    finally
      tmElapse.Enabled:=true;
    end;
end;


function TForm17.SecondToTime(const Seconds: double): String;
var ms, ss, mm, hh, dd: integer;
    sec :Integer;
begin
  sec := Trunc(Seconds);
  dd :=  sec div SecsPerDay;
  hh := (sec mod SecsPerDay) div 3600;
  mm := ((sec mod SecsPerDay) mod 3600) div 60;
  ss := ((sec mod SecsPerDay) mod 3600) mod 60;
  //  ms := Round(Frac(Seconds)*1000);
  if hh>0
    then result := Format('%.2d:%.2d:%.2d',[hh,mm,ss])
    else result := Format('%.2d:%.2d',[mm,ss]);
end;

procedure TForm17.tmLinkLameTimer(Sender: TObject);
begin
  tmLinkLame.Enabled  := false;
  tmLinkLame.Interval := RandomRange(Cst_30s, Cst_60s);;
  if FBLockage<>0 then exit;

  if not(Assigned(FThreadLinkLame)) and (FURL<>'') then
      begin
        AddLog('Récupération des informations d''accès à la Lame...');
        FThreadLinkLame := TThreadLinkLame.Create(true, FURL, CallBackLinkLame);
        FThreadLinkLame.Start;
      end
  else
    begin
      tmLinkLame.Enabled := true;
    end;
end;

procedure TForm17.tmWMITimer(Sender: TObject);
begin
   TmWMI.Enabled  := false;
   TmWMI.Interval := RandomRange(Cst_30s, Cst_60s);;
   if FBLockage<>0 then exit;
   if not(Assigned(FThreadWMI)) then
      begin
        AddLog('Récupération des informations WMI...');
        FThreadWMI := TThreadWMI.Create(true, CallBackWMI);
        FThreadWMI.Start;
      end
   else
    begin
       TmWMI.Enabled := false;
    end;
end;

procedure TForm17.ShowNotification(aTitle:string;aBody:string);
var MyNotification: TNotification; //Defines a TNotification variable
begin
  // Seulement si on peut mettre les Notifs....
  if FCanShowNotif then
    begin
        MyNotification := NotificationCenter1.CreateNotification; //Creates the notification
        try
          MyNotification.Name := 'SynchroEasy';
          MyNotification.Title := aTitle;
          MyNotification.AlertBody := aBody;
          NotificationCenter1.PresentNotification(MyNotification);
        finally
          MyNotification.DisposeOf;
        end;
    end;
end;


procedure TForm17.ParamScreen();
begin
    if not(Panel1.Visible)
      then
          begin
             Self.Height := 435;
             BDETAILS.Caption:='Voir les détails';
          end
      else
        begin
            Self.Top := 100;
            Self.Height := 700;
            BDETAILS.Caption:='Cacher les détails';
        end;
  ReCenter();
end;


procedure TForm17.ReCenter();
var
  LRect: TRect;
  X, Y: Integer;
begin
  LRect := Screen.WorkAreaRect;
  X := LRect.Left + (LRect.Right - LRect.Left - Width) div 2;
  Y := LRect.Top + (LRect.Bottom - LRect.Top - Height) div 2;
  SetBounds(X, Y, Width, Height);
end;


procedure TForm17.BDETAILSClick(Sender: TObject);
begin
  Panel1.Visible:=not(Panel1.Visible);
  ParamScreen;
end;

procedure TForm17.BQUITTERClick(Sender: TObject);
begin
  Close;
end;

procedure TForm17.BSYNCHROClick(Sender: TObject);
begin
    BSYNCHRO.Enabled := false;
    BSYNCHRO.Visible := false;
    TmDB.Enabled     := false;
    TmWMI.Enabled    := false;
    TmLinkLame.Enabled  := false;

    if FBLockage<>0 then exit;

    //--------------------------
    if not(Assigned(FThreadWMI)) and
       not(Assigned(FThreadLinkLame)) and
       not(Assigned(FThreadDB))
     then
        begin
           lbl_lame.Visible := false;
           lbl_heartbeat.Visible := false;
           lbl_Push.Visible := false;
           img_Cloud.Visible := false;
           img_HeartBeart.Visible := false;
           img_Infos.Visible := false;
           img_lines.Visible := false;

           img_Syncrho.Visible := true;
           //
           lbl_BIG_Center.Caption := 'Synchronisation en cours'+#13+#10+'Veuillez patienter...';
           lbl_BIG_Center.Visible := true;

           pbGeneral.Visible := true;
           pbGeneral.Refresh;
           pbDetails.Visible := true;
           pbDetails.Refresh;

           FStart := GetTickCount;
           tmElapse.Enabled := true;
           FLock := True;
           FThreadSyncho := TThreadSynchro.Create(FSYNCHRO_NB,
                FIBFILE,
                FGENERAL_ID,
                FAUTOStart,
                FDEBUG,
                StatusCallBack,
                pbGeneralCallBack,
                pbDetailsCallBack,
                CallBackSYnchro);
           FThreadSyncho.Start;
        end
    else
      begin
        TmDB.Enabled        := true;
        TmWMI.Enabled       := true;
        TmLinkLame.Enabled  := true;
      end;
end;


procedure TForm17.CloseInXseconds(const aSec:integer=30);
begin
   FTimeClose := aSec;
   tmAutoCloseInX.Enabled := true;
end;


procedure TForm17.CallBackSYnchro(Sender: TObject);
begin
   // au retour il faudra tester si c'est tout OK...
   FLock := false;
   tmElapse.Enabled:=false;
   FRollBackOK := TThreadSynchro(Sender).RollBackOK;
   // Si tout OK
   if TThreadSynchro(Sender).NBError=0 then
    begin
       AddLog('Synchronisation Terminée avec succès');
       img_Syncrho.Visible := false;
      // 'Récupération et contrôle des informations'+#13+#10+'Veuillez patienter...'
       // lbl_Recup_Infos
       // 'Synchronisation en cours'+#13+#10+'Veuillez patienter...'
       lbl_BIG_Center.Caption := 'Synchronisation terminée'+#13+#10+'Votre base est à jour.';

       img_OK.Visible := true;
       ShowNotification('Synchronisation terminée','Votre base est à jour.');
       // Close dans x secondes.....
       if FAUTOStart then
          CloseInXseconds(5);
    end;

   if (TThreadSynchro(Sender).NBError>0) and (RollBackOK=1) then
    begin
       AddLog('Echec de la Synchronisation');
       ResultatError(TThreadSynchro(Sender).ErrorMessage);
       if FAUTOStart then
          CloseInXseconds(5);
    end;

   if (TThreadSynchro(Sender).NBError>0) and (RollBackOK<>1) then
    begin
       AddLog('Echec de la Synchronisation');
       //
       ResultatError(TThreadSynchro(Sender).ErrorMessage)
    end;
    // Le Quitter est visible dans tous les Cas
    BQUITTER.Visible := true;
end;

procedure TForm17.ResultatError(aMsg:string);
begin
    FError_Message := aMsg;
    img_Syncrho.Visible:=false;
    img_OK.Visible:=false;
    img_Error.Visible:=false;
    img_infos.Visible:=false;

    img_Error.Visible:=true;
    lbl_BIG_Center.Caption  := aMsg;
    lbl_BIG_Center.AutoSize := true;
    BQUITTER.Visible := true;
    // MessageDlg(aMsg,  mtError, [mbOK], 0);
    // Self.Hide();
    // Close;
end;

procedure TForm17.CallBackDB(Sender: TObject);
var vVersion_Zip:boolean;
    i:integer;
begin
   if FFistPass=true then
      begin
         FMultiSynchroPossible:=false;

         FGENERAL_ID  := TThreadDB(Sender).GENERAL_ID;
         FNode        := TThreadDB(Sender).Node;
         // lbl_portable.Caption := FNode;
         FNode_Group  := TThreadDB(Sender).Node_Group;
         FSYNCHRO_NB  := TThreadDB(Sender).SYNCHRO_NB;

         edt_BAS_IDENT.Text := IntToStr(TThreadDB(Sender).BAS_IDENT);
         edt_SENDER.Text    := TThreadDB(Sender).SENDER;
         AddLog('Base Ident : '+edt_BAS_IDENT.Text);
         AddLog('Sender     : '+edt_SENDER.Text);

         // portables pour test mags
         // lbl_Serveur.Caption := 'Serveur Magasin'+#13+#10+FSYNCHRO_NB;
         if FNode_Group<>'portables'
            then
                begin
                  AtomicIncrement(FBLockage);
                  // on est pas sur le bon noeud !
                  AddLog('Ce portable n''est portable un portable de synchro');
                  ResultatError('Cet ordinateur n’est pas configuré pour effectuer une synchronisation, veuillez contacter votre support.');
                  exit;
                end;

         if FSYNCHRO_NB=''
           then
             begin
                AtomicIncrement(FBLockage);
                // on est pas sur le bon noeud !
                AddLog('Chemin de synchro vide : '+FSYNCHRO_NB);
                ResultatError('La configuration du mode synchronisation est incomplète, veuillez contacter votre support client.');
                exit;
             end
           else AddLog('Chemin de Synchro : '+ FSYNCHRO_NB);

         FFileExist_Server_NB   := TThreadDB(Sender).FileExistSYNCHRO_NB;

         FSynchroPaths          := TThreadDB(Sender).SynchroPaths;
         if Not(FileExist_Server_NB)
           then
              begin
                  AddLog(Format('Le fichier %s est absent',[FSYNCHRO_NB]));
                  For i:= Low(FSynchroPaths) to High(FSynchroPaths) do
                     begin
                        if UpperCase(FSYNCHRO_NB)<>Uppercase(FSynchroPaths[i].Path)
                          then
                            begin
                               // Si on trouve un chemin différent
                               AddLog('Mais le Multi Sites est possible...');
                               FMultiSynchroPossible:=true;
                               break;
                            end;
                     end;
                  //------------------------------------------------------------
                  if not(FMultiSynchroPossible) then
                      begin
                          AtomicIncrement(FBLockage);
                          ResultatError('La base de donnée du serveur n’est pas accessible, assurez-vous d’être dans le magasin et vérifiez votre accès réseau.');
                          exit;
                      end;
              end
           else
              begin
                  AddLog(Format('Le fichier %s est présent',[FSYNCHRO_NB]));
              end;

         if not(FMultiSynchroPossible) then
            begin
                vVersion_Zip   := TThreadDB(Sender).FileExistVersion_ZIP;
               if Not(vVersion_Zip)
                 then
                    begin
                        AtomicIncrement(FBLockage);
                        AddLog('Le fichier version.zip est absent');
                        ResultatError('Le fichier de version du serveur n’est pas accessible, assurez-vous d’être dans le magasin et vérifiez votre accès réseau.');
                        exit;
                    end
                 else
                    begin
                        AddLog('Le fichier version.zip est présent');
                    end;
            end;

         FFileSize_Server_NB       := TThreadDB(Sender).FileSize_NB;
         FFileDateTime_Server_NB   := TThreadDB(Sender).FileDateTime_NB;
      end;

   FNOTPUSH := TThreadDB(Sender).Datacount;
   lbl_Push.Caption := 'Push'+#13+#10+
              Format('%d lignes données',[TThreadDB(Sender).Datacount]) +#13+#10+
              Trim(Format('%s',[TThreadDB(Sender).Oldestbatch]))        +#13+#10+
              Trim(Format('%d lignes HeartBeat',[TThreadDB(Sender).HeartBeatCount]));
   lbl_HeartBeat.Caption := 'HeartBeat'+#13+#10+TThreadDB(Sender).HEARTBEAT.Detail;

   AddLog(Format('%d lignes données',[TThreadDB(Sender).Datacount]));
   AddLog(Format('%d lignes HeartBeat',[TThreadDB(Sender).HeartBeatCount]));

   if (FFistPass) and (FMultiSynchroPossible) then
      begin
        // il faut Arreter tmDecision car la fenetre pourrait s'ouvrir....
        tmDecision.Enabled  := false;
        AtomicIncrement(FFrmMultiSites);
        Application.CreateForm(TForm_ChoixServer,Form_ChoixServer);
        try
           Form_ChoixServer.SynchroPaths       := FSynchroPaths;
           Form_ChoixServer.SYNCHRO_NB_Default := FSYNCHRO_NB;

           Form_ChoixServer.Remplissage;
           Form_ChoixServer.Showmodal;

           // On affecte tout
           FSYNCHRO_NB             := Form_ChoixServer.SYNCHRO_NB;
           FFileExist_Server_NB    := Form_ChoixServer.FileExist_Server_NB;
           FFileSize_Server_NB     := Form_ChoixServer.FileSize_Server_NB;
           FFileDateTime_Server_NB := Form_ChoixServer.FileDateTime_Server_NB;

           if not(FFileExist_Server_NB) then
              begin
                AtomicIncrement(FBLockage);
                ResultatError('La base de donnée du serveur n’est pas accessible, assurez-vous d’être dans le magasin et vérifiez votre accès réseau.');
                exit;
              end;
              begin
                AddLog(Format('Le fichier %s est présent',[FSYNCHRO_NB]));
              end;
           //-------------------------------------------------------------------
           {
           Form_ChoixServer.FileExist_Server_NB;
           Form_ChoixServer.FileDateTime_Server_NB;
           }

        finally
          tmDecision.Enabled  := true;
          AtomicDecrement(FFrmMultiSites);
        end;


      end;

   FFistPass := false;
   FThreadDB := nil;

   if (FBLockage=0)
      then tmDB.Enabled := true;
end;

procedure TForm17.CallBackWMI(Sender: TObject);
begin
    FEASY_EXTERNAL_ID := TThreadWMI(Sender).ServiceEASY.external_id;
    FEASY_GROUP_ID    := TThreadWMI(Sender).ServiceEASY.group_id;

    if (TThreadWMI(Sender).ServiceEASY.Status<>'Running') and (TThreadWMI(Sender).Java_RUN)
    then
       begin
          AtomicIncrement(FBLockage);
          // il reste des Java Associées à EASY qui tournent.... il faut bloquer
          AddLog('Il reste des java.exe alors que le service EASY ne tourne pas');
          ResultatError('Problème détecté sur cet ordinateur, veuillez contacter votre support.');
          exit;
       end;

   if (FNOTPUSH>0) then
    begin
       //-----------------------------------------------------------------------
       {
       if (TThreadWMI(Sender).ServiceEASY.Status<>'Running')
         then
            begin
                if Application.MessageBox(PChar(Format('Vous avez %d lignes non envoyés sur la lame.' + #13#10 +
                 'Pour pouvoir envoyer ces données, il faut démarrer le service EASY.'+ #13#10 +
                 'Voulez-vous démarrer le Service EASY ?', [FNOTPUSH])),
                 'Confirmation', MB_YESNO + MB_ICONINFORMATION
                 + MB_DEFBUTTON2) = IDYES then
                      begin
                          // à Threader ===> ca serait mieux...
                          AddLog('Démarrage Service EASY');
                          ServiceStart('','EASY');
                          AddLog('Soyez patient...');
                          Sleep(1000);
                      end;
            end
       else
          begin
              AddLog('Le service EASY tourne : il va envoyer les données');
          end;
       }
       //-----------------------------------------------------------------------
       if (FBLockage=0) and (FCHOIX=0)  // si on a fait encore aucun choix !!
          and (FFrmMultiSites=0)
         then
            begin
               Application.CreateForm(TFormFORCE,FormFORCE);
               try
                 FormFORCE.NbLignes := FNOTPUSH;
                 FormFORCE.Showmodal;
                 AddLog(Format('Choix N°%d',[FormFORCE.Choix]));
                 FCHOIX := FormFORCE.Choix;
                 if FCHOIX=1 then
                    begin
                       AddLog('Sauvegarder');
                       if (TThreadWMI(Sender).ServiceEASY.Status<>'Running')
                          then
                            begin
                              // il faut donc lancer EASY
                              // à Threader ===> ca serait mieux...
                              AddLog('Démarrage Service EASY');
                              ServiceStart('','EASY');
                              AddLog('Soyez patient...');
                              AddLog('Temporisation de 3 minutes...');
                              tmDecision.Interval := Cst_3Min;
                            end
                          else
                            begin
                              AddLog('Temporisation de 1 min');
                              tmDecision.Interval := Cst_60s;
                            end;
                       // On passe Le Timer ???? à 5 minutes...
                       // Sleep(1000);
                    end;
                 if FCHOIX=2 then
                    begin
                       AddLog('Forcer la synchro sans sauvegarder');
                    end;
                 if FCHOIX=3 then
                    begin
                       AddLog('Ne rien Faire');
                       // BQUITTER.Visible := true;
                       Close(); // Directement
                    end;
               finally

               end;
            end;
    end;
   FDRIVES    := TThreadWMI(Sender).DRIVES;
   FFREESPACE := TThreadWMI(Sender).FREESPACE;
   FURL := TThreadWMI(Sender).URL;


   AddLog('URL : '+FURL);
   AddLog(Format('Espace disponible : %0.0f Mo',[FFREESPACE/1024/1024]));

   FThreadWMI := nil;

   if (FBLockage=0)
      then
        begin
            tmWMI.Enabled := true;
            // On démarre le Timer
            if not(tmLinkLame.Enabled) and (FURL<>'')
               then tmLinkLame.Enabled:=true;
        end;
end;


procedure TForm17.CallBackLinkLame(Sender: TObject);
begin
    if TThreadLinkLame(Sender).TCPOpen
      then
        begin
            AddLog('Lame OK');
            lbl_Lame.Caption := 'Lame'+#13+#10+'OK';
            FAccesLame := True;
        end
      else
        begin
            AddLog('Lame ERREUR');
            lbl_Lame.Caption := 'Lame'+#13+#10+'ERREUR';
            // Si La Lame n'est pas la.... on va avoir du mal a envoyer....
            // BSYNCHRO.Enabled := false;
            FAccesLame := false;
        end;

    FThreadLinkLame := nil;
    if (FBLockage=0)
      then tmLinkLame.Enabled := true;
end;





end.

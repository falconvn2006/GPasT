unit MainSplit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,UWMI,
  uSplit, uDataMod, UCommun, Vcl.ComCtrls, Vcl.StdCtrls, ulog, uCheckUpdate,
  Vcl.ExtCtrls;

type
  TFrmSplitMain = class(TForm)
    ProgressBar: TProgressBar;
    Lbl_Status: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    rbMini: TRadioButton;
    rbComplet: TRadioButton;
    teBASE: TEdit;
    teSENDER: TEdit;
    Panel1: TPanel;
    lbl_Update: TLabel;
    cbDEPOTFTP: TCheckBox;
    Label3: TLabel;
    cbType: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure SplitCallBack(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCheckUpdateThread : TCheckUpdateThread;
    FExeUpdateTHread   : TExeUpdateThread;
    FLockUpdate    : Boolean;

    FCanCLose : boolean;
    FType       : string;
    FMode       : Integer;
    // FDepotFTP   : integer;
    FErrorLevel : Cardinal;
    FListBases  : TStringList;
    FSplitThread:TSplitThread;
    procedure DoSplittage(aIBFile:string;aSENDER:string);
    procedure SetLockUpdate(value:Boolean);
    procedure CallBackCheckVersion(Sender:Tobject);
    procedure CallBackNewExeInstall(Sender:Tobject);
    { Déclarations privées }
  public
    Procedure StatusCallBack(Const s:String);
    Procedure ProgressCallBack(Const value:integer);
    property  ErrorLevel : Cardinal read FErrorLevel;

  property LockUpdate : Boolean read FLockUpdate write SetLockUpdate;
  end;

var
  FrmSplitMain: TFrmSplitMain;

implementation


{$R *.dfm}

procedure TFrmSplitMain.SetLockUpdate(value:Boolean);
begin
    FLockUpdate  := Value;
    Self.Enabled := not(Value);
end;


procedure TFrmSplitMain.DoSplittage(aIBFile:string;aSENDER:string);
var i,j:integer;
    ResInstallateur : TResourceStream;
    vSYMDSInfos : TSYMDSInfos;
    vTmpFile    : TFileName;
    VBases : TBases;
    vOKSENDER : boolean;
    vDB : string;
    vInfos : TInfosDelosEASY;

begin
    try
    //Listage des Instances
    WMI_GetServicesSYMDS;
    GetDatabases;
    vSYMDSInfos.ServiceName := '';
    for i:=0 to length(VGIB)-1 do
       begin
         if (Uppercase(VGIB[i].DatabaseFile) = Uppercase(aIBFile)) then
           begin
             for j:=0 to length(VGSYMDS)-1 do
                begin
                     if VGSYMDS[j].ServiceName = VGIB[i].ServiceName
                       then vSYMDSInfos := VGSYMDS[j];
                 end;
            end;
       end;

    // Aun Service EASY Associé a cette bases  ==> ERREUR 4
    if vSYMDSInfos.ServiceName='' then
      begin
         FErrorLevel := 4;
         exit;
      end;

    vBases := DataMod.ListeBases(teBASE.Text);
    if aSender<>'ALL' then
      begin
          vOKSENDER := false;
          for i:=Low(vBases) to High(VBases)
            do
              begin
                if UpperCase(VBases[i].BAS_SENDER)=UpperCase(aSender)
                  then
                    begin
                        vOKSENDER :=true;
                        FListBases.Add(aSender);
                    end;
              end;
          // Ce n'est pas un SENDER valide
          if Not vOKSender then
            begin
               FErrorLevel := 5;
               exit;
            end;
      end;
    if aSender='ALL' then
      begin
          for i:=Low(vBases) to High(VBases)
            do
              begin
                if (vBases[i].BAS_IDENT<>0) and (Pos(' ',vBases[i].BAS_SENDER)=0)
                  then FListBases.Add(vBases[i].BAS_SENDER);
              end;
      end;

    FCanCLose := False;
    EnableMenuItem( GetSystemMenu( handle, False ),SC_CLOSE, MF_BYCOMMAND or MF_GRAYED );

    vTmpFile := CreateUniqueGUIDFileName(GetTmpDir,'','.tmp');
    //--------------------------------------------------------------------------
    FSplitThread:=TSplitThread.Create(true,StatusCallBack,ProgressCallBack,SplitCallBack);
    FSplitThread.sORIGINE_IB    := aIBFile;   // aLame+'/'+ aIBFile
//  FSplitThread.sCOPY_IB       := Format('%s\%s.ib.sav.tmp',[ExcludeTrailingPathDelimiter(ExtractFilePath(aIBFile)), aSender]);
    FSplitThread.sCOPY_IB       := LowerCase(Format('%s\splits\%s_prepa_split_%s.ib',[ExcludeTrailingPathDelimiter(ExtractFilePath(aIBFile)),aSender,FormatDateTime('yyyymmdd_hhnnss',FSplitThread.CreateTime)]));
    FSplitThread.sScriptFile    := vTmpFile;
    FSplitThread.sBases         := FListBases.Text;
    FSplitThread.SYMDSInfos     := vSYMDSInfos;
    FSplitThread.Engine         := DataMod.GetNomPourNous(aIBFile);
    FSplitThread.bForceReCreate := true;
    FSplitThread.bTriggerDiff   := false;  // False signifie qu'on ne calcul pas en différé (donc on calcul tout de suite)
    FSplitThread.NOMPOURNOUS    := LowerCase(DataMod.GetNomPourNous(aIBFile));
    FSplitThread.Engine         := 'easy_' + FSplitThread.NOMPOURNOUS;
    FSplitThread.Mode           := FMode;      // 0 ou 1
    FSplitThread.DepotFTP       := cbDEPOTFTP.Checked;
    FSplitThread.NODE_GROUP_ID  := cbType.Text; // 'mags' ou 'portables'; // ici mettre un parametre mags

    try
       ResInstallateur := TResourceStream.Create(HInstance, 'cleanmaster2mags', RT_RCDATA);
       try
          ResInstallateur.SaveToFile(vTmpFile);
          finally
          ResInstallateur.Free();
        end;
       // le Log uniquement en minisplit (Delos2Easy)
       if FSplitThread.Mode=1 then
         begin
              vDB := FSplitThread.sORIGINE_IB;
              vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vDB);
              Log.App   := 'Delos2Easy';
              Log.Doss  := vInfos.Dossier;
              Log.Ref   := vInfos.GUID;
              // On passe en actif
              Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT, logNotice, True, 0, ltServer);
         end;
       FSplitThread.Start;
       // FRunning:=true;
    finally

    end;
  finally

  end;
end;

procedure TFrmSplitMain.SplitCallBack(Sender: TObject);
var vDB : string;
    vInfos : TInfosDelosEASY;

begin
  ProgressBar.Visible:=false;
  //
  vDB := FSplitThread.sORIGINE_IB;
  vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vDB);
  Log.App   := 'Delos2Easy';
  Log.Doss  := vInfos.Dossier;
  Log.Ref   := vInfos.GUID;
  // On passe en actif

  if FSplitTHread.NbError=0
    then
       begin
          lbl_Status.Caption:='Traitement Terminé avec Succès';
          // Ecriture de 2500 dans le parametre
          If DataMod.MAJ_GENPARAM_Monitor(FSplitThread.sORIGINE_IB,2500)
             then Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logInfo, True, 0, ltServer)
             else Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logError, True, 0, ltServer);
          ExitCode := 0;
          FCanCLose := true;
          Close();
       end
    else
      begin
          ExitCode  := 8;    // Ca arrive quand on a un mauvais host par exemple ou quand il manque le .ini
          If DataMod.MAJ_GENPARAM_Monitor(FSplitThread.sORIGINE_IB,2499)
             then Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logError, True, 0, ltServer)
             else Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logError, True, 0, ltServer);
          FCanCLose := true;
          Close();
      end;
  FCanCLose := true;
  EnableMenuItem( GetSystemMenu( handle, False ), SC_CLOSE, MF_BYCOMMAND or MF_ENABLED );
end;


Procedure TFrmSplitMain.StatusCallBack(Const s:String);
begin
  Lbl_Status.Caption  := s;
end;

Procedure TFrmSplitMain.ProgressCallBack(Const value:integer);
begin
    ProgressBar.Visible  := true;
    ProgressBar.Position := value;
end;


procedure TFrmSplitMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Log.App := 'EasySplit';
    Log.Log('EasySplit', '', '', 'Action', 'Arrêt', logInfo, True, 0, ltServer);
    Log.Close;
end;

procedure TFrmSplitMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    FListBases.DisposeOf;
    CanClose := FCanCLose;
end;

procedure TFrmSplitMain.CallBackNewExeInstall(Sender:Tobject);
begin
    try
      If (TExeUpdateThread(Sender).ShellUpdate) then
        begin
            // Inc(FNbBoucleUpdates);
            // Save_Ini_BoucleUpdates;
            //------------------ On ne relance pas -----------------------------
            // ShellExecute(0,'OPEN', PWideChar(Application.ExeName), nil, nil, SW_SHOW);
            Application.Terminate;
        end

    finally
      LockUpdate:=false;
    end;
end;


procedure TFrmSplitMain.CallBackCheckVersion(Sender: TObject);
var vUrl:string;
begin
    try
       If (CompareVersion(TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion)<0)
        then
           begin
            If MessageDlg(PChar(Format('Nouvelle version disponible :  Voulez-vous faire la mise à jour ? '+#13+#10+#13+#10+
                                    'Votre version : %s '  +#13+#10+
                                    'Version disponible : %s '  +#13+#10
                              , [TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion ])),
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                begin
                   vUrl := TCheckUpdateThread(Sender).RemoteFile;
                   FExeUpdateThread := TExeUpdateThread.Create(Application.ExeName,vUrl,Lbl_Update,CallBackNewExeInstall);
                   FExeUpdateThread.Resume;
                   LockUpdate:=true;
                end
                else LockUpdate:=false;
           end
        else
          begin
            MessageDlg(PChar(Format('Le programme %s est à jour.'+#13+#10+#13+#10+
                                    'Votre version : %s '  +#13+#10+
                                    'Version disponible : %s '  +#13+#10
                              , [ExtractFileName(Application.ExeName),TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion ])),
             mtInformation, [mbOK], 0);
            LockUpdate:=false;
          end;
    finally
      // LockUpdate:=false; non pas là l'autre thread peut-etre lancer...
    end;
end;


procedure TFrmSplitMain.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
begin
   try
    Log.App   := 'EasySplit';
    Log.Inst  := '' ;
    Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
    Log.SendOnClose := true ;
    Log.Open ;
    Log.SendLogLevel := logTrace;

    FErrorLevel := 0;
    FCanCLose := true;
    FListBases := TStringList.Create;

    if (ParamCount=0) then
      begin
        // mise à jour sans relancement
       FCheckUpdateThread := TCheckUpdateThread.Create(Application.ExeName,Lbl_Update,CallBackCheckVersion);
       FCheckUpdateThread.Resume;
       LockUpdate:=true;
       Exit;
      end;

    // MANQUE OU TROP DE PARAMETRES     ==> ERREUR 1
    if ((ParamCount<3) or (ParamCount>4)) then
      begin
        FErrorLevel := 1;
        Exit;
      end;

    Fmode := -1;
    FType := 'mags';
    for i :=1 to ParamCount do
      begin
          param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
          value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
          If lowercase(param)='ib'
            then teBASE.Text   := value;
          If lowercase(param)='sender'
            then teSENDER.Text := value;
          If (lowercase(param)='mode') and (LowerCase(value)='mini')
            then FMode:=1;
          If (lowercase(param)='mode') and ((LowerCase(value)='complet') or (LowerCase(value)='recupbase'))
            then FMode:=0;

          If (lowercase(param)='type') and (LowerCase(value)='portables')
            then FType:='portables';

          If LowerCase(ParamStr(i))='depotftp'
            then cbDEPOTFTP.Checked := true;
      end;

    cbType.Text := FType;

    rbMini.Checked     := FMode=1;
    rbComplet.Checked  := FMode=0;

    // Pour les Mini on dépose toujours sur le FTP (ca coute rien)
    cbDEPOTFTP.Checked := ((FMode=1) or (cbDEPOTFTP.Checked));

    // Le fichier IB n'existe pas ==>   ERREUR 2
    if Not(FileExists(teBASE.Text))
      then FErrorLevel := 2;

    // Erreur Mauvais Mode        ==>   ERREUR 3
    if not(FMode in [0,1]) then
      begin
         FErrorLevel := 3;
         exit;
      end;

    Log.Log('EasySplit', '', '', 'Action', 'Lancement', logInfo, True, 0, ltServer);

    // on fait le splittage
    if (FErrorLevel=0)
      then
        begin
            DoSplittage(teBASE.Text,teSender.text);
        end;

    {
    if (FErrorLevel=0) then
        begin
          // si on est en ALL faut pas fermer...
          ExitCode := 0;
          FCanCLose := true;
          Close();
        end;
    }
   except
    On E:Exception do
      begin
        FErrorLevel := 9;
        // MessageDlg(E.Message,  mtError, [mbOK], 0);
        // ExitCode := StrToInt(E.Message);
        // FCanCLose := true;
        // Close();
      end;
    end;
end;

procedure TFrmSplitMain.FormShow(Sender: TObject);
begin
    if ErrorLevel<>0
      then
        begin
            ExitCode := ErrorLevel;
            Close;
        end;
end;

end.

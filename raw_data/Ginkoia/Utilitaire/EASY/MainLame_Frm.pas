/// <summary>
/// Unité de la Forme Principale de EasyControlCenter
/// </summary>
unit MainLame_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UWMI, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Math,Winapi.ShellAPI,
  Vcl.Buttons, System.StrUtils, Vcl.Menus, uInstallDossierLame,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON,
  Vcl.XPMan, uSplit, uLog,uCheckUpdate;

const clBgL0 = $00EFEFEF;
      clBgL1 = $00FFFFFF;

type
  TFrm_MainLame = class(TForm)
    Instances: TFDMemTable;
    InstancesServiceName: TStringField;
    InstancesPathName: TStringField;
    dsInstances: TDataSource;
    InstancesConfigFile: TStringField;
    InstancesDirectory: TStringField;
    InstancesPorts: TStringField;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Splitter1: TSplitter;
    dsDOSSIERS: TDataSource;
    InstancesID: TIntegerField;
    InstancesEtat: TStringField;
    gridInstance: TDBGrid;
    DBGrid3: TDBGrid;
    Dossiers: TFDMemTable;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    DossiersID: TIntegerField;
    InstancesNBBASES: TIntegerField;
    InstanceSIZE: TLargeintField;
    InstancessSize: TStringField;
    DossiersSIZE: TLargeintField;
    BActualiser: TBitBtn;
    DossierssSize: TStringField;
    DossiersEngineName: TStringField;
    pmService: TPopupMenu;
    pmsStart: TMenuItem;
    pmsStop: TMenuItem;
    pmsRestart: TMenuItem;
    N1: TMenuItem;
    Ouvrirlesservices1: TMenuItem;
    DossiersTRG: TIntegerField;
    DossiersRTB: TIntegerField;
    DossiersVersion: TStringField;
    BNOUVEAU: TButton;
    ProgressBar: TProgressBar;
    lbl_Status: TLabel;
    XPManifest1: TXPManifest;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    N2: TMenuItem;
    Mettrejour: TMenuItem;
    Lbl_Update: TLabel;
    procedure FormCreate(Sender: TObject);
//    procedure Button2Click(Sender: TObject);
    procedure gridInstanceDblClick(Sender: TObject);
    procedure gridInstanceDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
//    procedure Button1Click(Sender: TObject);
    procedure InstancesAfterScroll(DataSet: TDataSet);
    procedure InstancesCalcFields(DataSet: TDataSet);
    procedure BActualiserClick(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure pmServicePopup(Sender: TObject);
    procedure pmsStartClick(Sender: TObject);
    procedure pmsStopClick(Sender: TObject);
    procedure pmsRestartClick(Sender: TObject);
    procedure Ouvrirlesservices1Click(Sender: TObject);
    procedure GetPublicIP();
    procedure DBGrid3DrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BNOUVEAUClick(Sender: TObject);
    procedure InstallCallBack(Sender: TObject);
    procedure SplitCallBack(Sender: TObject);
    procedure BJAVAClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MettrejourClick(Sender: TObject);
    procedure CallBackCheckVersion(Sender:Tobject);
    procedure CallBackNewExeInstall(Sender:Tobject);
  private
    { Déclarations privées }
    FCheckUpdateThread : TCheckUpdateThread;
    FExeUpdateTHread   : TExeUpdateThread;
    FLockUpdate    : Boolean;

    FErrorLevel    : integer;
    FInstallTHread : TInstallDossierLameThread;
    FSplitThread   : TSplitThread;
    FLock          : boolean;
    FNewDB         : string;
    FNewName       : string;  // Pour avoir de nouveau GUID pour les tests
    procedure DoSplittage(aIBFile:string;aServiceName:string);
    procedure Refresh();
    procedure LoadIni;
    procedure LoadHostName;
    procedure SetLockUpdate(value:Boolean);
    procedure EnabledActions(aEnabled:boolean);
    Procedure StatusCallBack(Const s:String);
    Procedure ProgressCallBack(Const value:integer);
    procedure NewDossier; // en Mode Auto
  public
    procedure DoRefresh;
    property LockUpdate : Boolean read FLockUpdate write SetLockUpdate;
    { Déclarations publiques }
  end;

var
  Frm_MainLame: TFrm_MainLame;

implementation

{$R *.dfm}

Uses UCommun,ServiceControler,uDataMod, SplittageDossierLame_Frm ,inifiles, NewDossierLame_Frm,
  DossierLame_Frm;


procedure TFrm_MainLame.SetLockUpdate(value:Boolean);
begin
    FLockUpdate  := Value;
    Self.Enabled := not(Value);
end;

Procedure TFrm_MainLame.StatusCallBack(Const s:String);
begin
  Lbl_Status.Caption  := s;
end;

Procedure TFrm_MainLame.ProgressCallBack(Const value:integer);
begin
    ProgressBar.Visible  := true;
    ProgressBar.Position := value;
end;


procedure TFrm_MainLame.EnabledActions(aEnabled:boolean);
begin
  FLock := Not(aEnabled);
  BNouveau.Enabled    := aEnabled;
  BActualiser.Enabled := aEnabled;
end;


procedure TFrm_MainLame.DoRefresh();
begin
   Refresh();
end;

procedure TFrm_MainLame.InstallCallBack(Sender: TObject);
var vInfos : TInfosDelosEASY;
    vDB : string;
   vLevel : TLogLevel;
begin
  ProgressBar.Visible := false;
  Lbl_Status.Caption  := 'Traitement Terminé';
  // un petit refresh ca serait bien....
  DoRefresh();
  EnabledActions(true);
  //----------------------------------------------------------------------------
  vDB := FInstallTHread.DB.DatabaseFile;
  vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vDB);
  Log.App   := 'Delos2Easy';
  Log.Doss  := vInfos.Dossier;
  Log.Ref   := vInfos.GUID;
  if (FInstallTHread.NumError<>0)
    then
      begin
        vLevel := LogError;
        Datamod.MAJ_GENPARAM_Monitor(vDB,1999);
        Log.Log('InstallEasyLame',  Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_ERROR, vLevel, True, 0, ltServer);
      end
    else
      begin
         // Enregsitrement dans la base au niveau 2000
         If Datamod.MAJ_GENPARAM_Monitor(vDB,2000)
           then
             begin
                Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_OK, logInfo, True, 0, ltServer);
                vLevel := LogInfo;
             end
         else
           begin
               Log.Log('InstallEasyLame',  Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_ERROR, logError, True, 0, ltServer);
               vLevel := LogError;
           end;
      end;
  //----------------------------------------------------------------------------
  // Si on est en mode Auto on ferme
  if FNewDB<>''
    then
      begin
         Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_END, vLevel, True, 0, ltServer);
         // un petit refresh de la grille pour avoir ne nombre de triggers ??
         // faut plus de 100
         Dossiers.DisableControls;
         try
          while not(Dossiers.Eof) do
            begin
                if UpperCase(Dossiers.FieldByName('IBFile').asstring)=UpperCase(FNewDB) then
                  begin
                     If (Dossiers.FieldByName('TRG').Asinteger<>Dossiers.FieldByName('RTB').Asinteger)
                       or (Dossiers.FieldByName('TRG').Asinteger<100)
                       then FErrorLevel:=8;
                  end;
                Dossiers.Next;
            end;
         finally
           Dossiers.EnableControls;
         end;
         Close;
      end;
end;

procedure TFrm_MainLame.LoadHostName;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
      // VGSE.PublicIP  := appINI.ReadString('EASY','IP',VGSE.HostName) ;
      VGSE.HostName  := appINI.ReadString('EASY','HOSTNAME',VGSE.HostName) ;
    finally
      appINI.Free;
    end;
end;

procedure TFrm_MainLame.GetPublicIP();
var json : string;
    IdHTTP: TIdHTTP;
    jsonObject: TJSONObject;
begin
  IdHTTP        := TIdHTTP.Create;
  json          := '';
  VGSE.PublicIP := '127.0.0.1';
  VGSE.HostName := GetComputerNetName;
  try
    json := IdHTTP.Get('http://easy-ftp.ginkoia.net/nslookup.php');  // http://ipinfo.io/json
  finally
    IdHTTP.Free;
  end;
  // Récupération de l'IP public
  jsonObject := TJSONObject.ParseJSONValue(json) as TJSONObject;
  try
    // sur les replic locales ou pour les tests on a des pb...
    try
      if jsonObject.Get('hostname').JsonValue.Value<>'No Hostname'
        then VGSE.HostName := jsonObject.Get('hostname').JsonValue.Value
        else VGSE.HostName := GetComputerNetName;
      VGSE.PublicIP := jsonObject.Get('ip').JsonValue.Value;
    Except
      //
    end;
  finally
    jsonObject.DisposeOf;
  end;
end;


procedure TFrm_MainLame.BActualiserClick(Sender: TObject);
begin
    Refresh;
end;

{
procedure TFrm_MainLame.Button1Click(Sender: TObject);
var Frm_NewDatabase:TFrm_NewDatabase;
begin
    // Il faut au moins une instance pour installer un dossier
    if Instances.IsEmpty then exit;
    Application.CreateForm(TFrm_NewDatabase,Frm_NewDatabase);
    Frm_NewDatabase.cbInstance.ItemIndex:=Instances.FieldByName('ID').asinteger;
    Frm_NewDatabase.Showmodal;
end;
}

procedure TFrm_MainLame.LoadIni;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
      VGSE.EASY_PATHDIR   := appINI.ReadString('EASY','EASY_PATHDIR',VGSE.EASY_PATHDIR) ;
      VGSE.EASY_PATHBASES := appINI.ReadString('EASY','EASY_PATHBASES',VGSE.EASY_PATHBASES) ;
      // à Partir de
      VGSE.EASY_PORTS           := appINI.ReadInteger('EASY','EASY_PORTS',40000) ;
      VGSE.EASY_BackupLame_Ini  := appINI.ReadString('EASY','EASY_BackupLame_Ini','EasyBackupLame.ini') ;
    finally
      appINI.Free;
    end;
end;

procedure TFrm_MainLame.CallBackCheckVersion(Sender:Tobject);
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

procedure TFrm_MainLame.CallBackNewExeInstall(Sender:Tobject);
begin
    try
      If (TExeUpdateThread(Sender).ShellUpdate) then
        begin
            // Inc(FNbBoucleUpdates);
            // Save_Ini_BoucleUpdates;
            //------------------ On relance-------------------------------------
            ShellExecute(0,'OPEN', PWideChar(Application.ExeName), nil, nil, SW_SHOW);
            Application.Terminate;
        end

    finally
      LockUpdate:=false;
    end;
end;



{
            begin
                FStatus := 'version = Check Version : OK';
                Synchronize(UpdateVCL);
            end;
      If (TCheckUpdateThread(Sender).ShellUpdate) then
        begin
            // Inc(FNbBoucleUpdates);
            // Save_Ini_BoucleUpdates;
            //------------------ On relance-------------------------------------
            ShellExecute(0,'OPEN', PWideChar(Application.ExeName), nil, nil, SW_SHOW);
            Application.Terminate;
        end
      else
}

procedure TFrm_MainLame.MettrejourClick(Sender: TObject);
begin
//   FExeUpdateThread := TExeUpdateThread.Create(Application.ExeName,Lbl2,CallBackNewExeVersion);
   FCheckUpdateThread := TCheckUpdateThread.Create(Application.ExeName,Lbl_Update,CallBackCheckVersion);
   FCheckUpdateThread.Resume;
   LockUpdate:=true;
end;

{
procedure TFrm_MainLame.Button2Click(Sender: TObject);
var Frm_NewInstance:TFrm_NewInstance;
    i:integer;
    myhttp, myhttps,  myjmx, myagent:integer;
    NumeroInstance : integer;
    MyDrive:string;
    iNumero :integer;

begin
    LoadIni;
    myhttp  := VGSE.EASY_PORTS + 5;
    myjmx   := VGSE.EASY_PORTS + 6;
    myhttps := VGSE.EASY_PORTS + 7;
    myagent := VGSE.EASY_PORTS + 8;
    MyDrive := VGSE.EASY_PATHDIR;
    NumeroInstance:=0;
    i:=0;
    While i<length(VGSYMDS) do
      begin
         myhttp  := Math.max(myhttp,VGSYMDS[i].http);
         myhttps := Math.max(myhttps,VGSYMDS[i].https);
         myagent := Math.max(myagent,VGSYMDS[i].jmxagent);
         myjmx   := Math.max(myjmx,VGSYMDS[i].jmxhttp);
         MyDrive := ExtractFileDrive(VGSYMDS[i].ConfigFile);
         iNumero := StrToIntDef(RightStr(VGSYMDS[i].ServiceName,2),0);
         NumeroInstance := max(NumeroInstance,iNumero);
         inc(i);
      end;
    Inc(NumeroInstance);




    Application.CreateForm(TFrm_NewInstance,Frm_NewInstance);
   // Frm_NewInstance.ServicesSYMDS    := VGSYMDS;
    Frm_NewInstance.teNom.Text       := Format('EASY%.2d',[NumeroInstance]);
    Frm_NewInstance.teDirectory.Text := Format('%s\EASY%.2d\',[MyDrive,NumeroInstance]);
    Frm_NewInstance.tehttp.text      := IntToStr(myhttp  + 10);
    Frm_NewInstance.tehttps.text     := IntToStr(myhttps + 10);
    Frm_NewInstance.teAgent.text     := IntToStr(myagent + 10);
    Frm_NewInstance.tejmx.text       := IntToStr(myjmx   + 10);
    Frm_NewInstance.Showmodal;
    Refresh;
end;
}

// Mode Auto
procedure TFrm_MainLame.NewDossier;
var vmyhttp,vmyhttps:integer;
    vmyjmx:integer;
    vmyagent:Integer;
    i:Integer;
    sMessage:string;
    vDB   : TDossierINfos;
    vEASY : TSymmetricDS;
    vLastDir : string;
    vInfos   : TInfosDelosEASY;

begin
    FErrorLevel := 0;
    LoadIni;
    try
      EnabledActions(false);
      vmyhttp  := VGSE.EASY_PORTS + 5;
      vmyjmx   := VGSE.EASY_PORTS + 6;
      vmyhttps := VGSE.EASY_PORTS + 7;
      vmyagent := VGSE.EASY_PORTS + 8;
      i:=0;
      While i<length(VGSYMDS) do
        begin
           vmyhttp  := Math.max(vmyhttp,VGSYMDS[i].http);
           vmyhttps := Math.max(vmyhttps,VGSYMDS[i].https);
           vmyagent := Math.max(vmyagent,VGSYMDS[i].jmxagent);
           vmyjmx   := Math.max(vmyjmx,VGSYMDS[i].jmxhttp);
           Inc(i);
        end;

      // Lancement d l'installation...
      // a passer en paramètre

      if not(FileExists(FNewDB))
        then
          begin
            // sMessage := Format('Absence de la base "%s".',[FNewDB]);
            // MessageDlg(sMessage, mtError, [mbOk], 0);
            FErrorLevel := 1;          // Fichier Absent
            EnabledActions(true);
            exit;
            // Nettoyage des variables "Auto"
            {
            FNewDB   :='';
            FNewName :='';
            EnabledActions(true);
            exit;
            }
          end;
      // Le chemin de la doit etre dans le chemins "Normal" du ".ini"
      if Pos(UpperCase(VGSE.EASY_PATHBASES),UpperCase(FNewDB))<>1 then
         begin
            // sMessage := Format('La base "%s" n''est pas dans le bon chemin "%s".',[FNewDB,VGSE.EASY_PATHBASES]);
            // MessageDlg(sMessage, mtError, [mbOk], 0);
            FErrorLevel := 2;          // Mauvais Chemin
            EnabledActions(true);
            exit;
            // Nettoyage des variables "Auto"
            {
            FNewDB   :='';
            FNewName :='';
            EnabledActions(true);
            exit;
            }
         end;

      if UpperCase(ExtractFileName(FNewDB))<>'GINKOIA.IB'
        then
          begin
            FErrorLevel := 3;          // la base doit etre ginkoia.ib
            EnabledActions(true);
            exit;
            {
            sMessage := Format('La Base doit obligatoirement être nommée GINKOIA.IB et pas "%s"',[ExtractFileName(FNewDB)]);
            MessageDlg(sMessage, mtError, [mbOk], 0);
            // Nettoyage des variables "Auto"
            FNewDB   :='';
            FNewName :='';
            EnabledActions(true);
            exit;
            }
          end;

      // calcul de la prochaine dizaine
      vEASY.http   := vmyhttp  + 10;
      vEASY.https  := vmyhttps + 10;
      vEASY.jmx    := vmyagent + 10;
      vEASY.agent  := vmyjmx   + 10;
      vEASY.server_java := true;
      vEASY.memory := 512;   // 2048;
      vEASY.IsLame := true;

      if (vEASY.http-VGSE.EASY_PORTS>=CST_MAX_PORTS) then
          begin
            FErrorLevel := 4;          //
            EnabledActions(true);
            exit;
            // pas plus de 2000 ports par lame
            {
            sMessage := Format('Le Port %d n''est pas dans la plage réservée de la machine',[vEASY.http]);
            MessageDlg(sMessage, mtError, [mbOk], 0);
            // Nettoyage des variables "Auto"
            FNewDB   :='';
            FNewName :='';
            EnabledActions(true);
            exit;
            }
          end;

      vDB.init;
      vDB.DatabaseFile := FNeWDB; // 'G:\Public\bases\X14\GINKOIA.IB'
      if FNewName<>''
        then
          begin
            DataMod.DROP_SYMDS(FNeWDB);
//            DataMod.DROP_TABLES_SYMDS(FNeWDB);
            DataMod.CLEAN_MAGCODE(FNeWDB);
            DataMod.SetNomPourNous(FNeWDB,FNewName);
          end;

      DataMod.Ouverture_IBFile(vDB);
      // Le NomPourNous doit etre le répertoire de la base
      // NOMPOURNOUS = vDB.Nom
      vLastDir := UpperCase(ExtractFileName(ExtractFileDir(vDB.DatabaseFile)));

      if vLastDir<>Uppercase(vDB.Nom)
        then
          begin
            FErrorLevel := 5;          // Différence des le nom et Chemin
            EnabledActions(true);
            exit;
            {
            sMessage := Format('Différence entre Nom et Chemin :' + #13 + #10 +
                               'NomPourNous : "%s"' + #13 + #10 +
                               'Chemin : "%s"',[UpperCase(vDB.Nom), vDB.DatabaseFile]);
            MessageDlg(sMessage, mtError, [mbOk], 0);
            // Nettoyage des variables "Auto"
            FNewDB   :='';
            FNewName :='';
            EnabledActions(true);
            exit;
            }
          end;


      vEASY.Nom        := UpperCase(Format('EASY_%s',[vDB.Nom]));
      vEASY.Repertoire := Uppercase(Format('%s\EASY_%s\',[VGSE.EASY_PATHDIR,vDB.Nom]));

      vDB.Nom         := LowerCase(vEASY.Nom);
      vDB.ServiceName := vEASY.Nom;
      vDB.SymDir      := vEASY.Repertoire;
      vDB.HTTPPort    := vEASY.http;

      //  FInstallTHread.DB.Nom      := '';
      for i := 0 to length(VGIB) - 1 do
      begin
        if vDB.DatabaseFile = VGIB[i].DatabaseFile then
        begin
           FErrorLevel := 6;    // base déjà associée à une instance
           EnabledActions(true);
           exit;
          {
          sMessage := Format('La Base "%s" est déjà associée à l''instance "%s".' + #13 + #10 + 'Impossible de l''ajouter à nouveau.',[vDB.DatabaseFile,VGIB[i].ServiceName]);
          MessageDlg(sMessage, mtError, [mbOk], 0);
          // Nettoyage des variables "Auto"
          FNewDB   :='';
          FNewName :='';
          EnabledActions(true);
          exit;
          }
        end;
        if vDB.Nom = VGIB[i].Nom then
        begin
           FErrorLevel := 7;    // nom déjà associée à une instance
           EnabledActions(true);
           exit;
          {
          sMessage := Format('Ce nom "%s" est déjà associée à l''instance %s.' + #13 + #10 + 'Impossible d''utiliser ce même nom.',[vDB.Nom,VGIB[i].ServiceName]);
          MessageDlg(sMessage, mtError, [mbOk], 0);
          FNewDB   :='';
          FNewName :='';
          EnabledActions(true);
          exit;
          }
        end;
      end;

      vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vDB.DatabaseFile);
      Log.App   := 'Delos2Easy';
      Log.Doss  := vInfos.Dossier;
      Log.Ref   := vInfos.GUID;
      Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL, logNotice, True, 0, ltServer);

      // Tous les controles sont passés
      // Lancement du thread
      FInstallTHread := nil;
      FInstallTHread := TInstallDossierLameThread.Create(true,StatusCallBack,ProgressCallBack,InstallCallBack);
      FInstallTHread.DB   := vDB;
      FInstallTHread.EASY := vEASY;
      FInstallTHread.Start;
    finally
      if Not(Assigned(FInstallTHread))
        then close;
    end;
end;

procedure TFrm_MainLame.BNOUVEAUClick(Sender: TObject);
var vF : TFrm_NewDossierLame;
    vInfos : TInfosDelosEASY;
begin
  // NewDossier;
  LoadIni;
  vF := TFrm_NewDossierLame.Create(nil);
  try
    if vF.Showmodal = mrOk then
      begin
       EnabledActions(false);

       vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vF.DB.DatabaseFile);
       Log.App   := 'Delos2Easy';
       Log.Doss  := vInfos.Dossier;
       Log.Ref   := vInfos.GUID;
       Log.Log('InstallEasyLame', Log.Ref, vInfos.Dossier, 'InstallOk', MSG_CC_INSTALL, logNotice, True, 0, ltServer);

       // Lancement d l'installation...
       FInstallTHread := nil;
       FInstallTHread := TInstallDossierLameThread.Create(true,StatusCallBack,ProgressCallBack,InstallCallBack);
       FInstallTHread.DB   := vF.DB;
       FInstallTHread.EASY := vF.EASY;
       FInstallTHread.Start;
      end
    else
      begin
        EnabledActions(true);
      end;
  finally
     vF.Release;
  end;
end;

procedure TFrm_MainLame.BJAVAClick(Sender: TObject);
begin
    // 0 c'est la lame
    if not(JavaInstalled(0)) then InstallJAVA(0);
end;

procedure TFrm_MainLame.DBGrid3DblClick(Sender: TObject);
var i:integer;
    mouseInGrid : TPoint;
    Coord: TGridCoord;
begin
     If FLock then
       begin
          MessageDlg('Traitement en cours : Action Impossible pour le moment',  mtError, [mbOK], 0);
          exit;
       end;

     If TDBGrid(Sender).DataSource.Dataset.IsEmpty then exit;
     mouseInGrid := DBGrid3.ScreenToClient(Mouse.CursorPos) ;
     Coord := DBGrid3.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
     if (Coord.X=-1) or (Coord.Y=-1) then exit;
     // si pas de triggers c'est pas normal
     if TDBGrid(Sender).DataSource.Dataset.FieldByName('RTB').asinteger = 0
        then exit;
     if TDBGrid(Sender).DataSource.Dataset.FieldByName('TRG').asinteger = 0
        then exit;

     if TDBGrid(Sender).DataSource.Dataset.FieldByName('VERSION').AsString='?'
        then
          begin
            MessageDlg('Fichier de base de données absent !' + #13#10 +
              'Il y a peut-etre le backup/restore de la lame ' + #13#10 +
              'qui tourne sur cette base ?',  mtError, [mbOK], 0);
            exit;
          end;

     // si pas le nombre de triggers n'est pas en phase c'est pas normal
     // si c'est peut-etre normal si on a CASH
     {
     if TDBGrid(Sender).DataSource.Dataset.FieldByName('RTB').asinteger <> TDBGrid(Sender).DataSource.Dataset.FieldByName('TRG').asinteger
        then exit;
     }

     if TDBGrid(Sender).DataSource.Dataset.FieldByName('RTB').asinteger <> TDBGrid(Sender).DataSource.Dataset.FieldByName('TRG').asinteger
       then
          begin
              MessageDlg('Le nombre de triggers est différent du nombre dans SYM_TRIGGERS' +#13+#10 +
                         'Veuillez controler si toutes les tables repliquent correctement'
                          ,  mtWarning, [mbOK], 0);
          end;


     If (Coord.X=9) then
          begin
             DoSplittage(TDBGrid(Sender).DataSource.Dataset.FieldByName('IBFile').AsString,TDBGrid(Sender).DataSource.Dataset.FieldByName('ServiceName').AsString);
          end
      else
         begin
             Application.CreateForm(TFrm_DossierLame,Frm_DossierLame);
             Frm_DossierLame.IBFile:=TDBGrid(Sender).DataSource.Dataset.FieldByName('IBFile').AsString;
             Frm_DossierLame.Showmodal;
         end;
end;

procedure TFrm_MainLame.SplitCallBack(Sender: TObject);
var vDB    : string;
    vInfos : TInfosDelosEASY;

begin
  ProgressBar.Visible:=false;
  vDB := FSplitThread.sORIGINE_IB;
  vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vDB);
  Log.App   := 'Delos2Easy';
  Log.Doss  := vInfos.Dossier;
  Log.Ref   := vInfos.GUID;
  if FSplitTHread.NbError=0
    then
      begin
          //----------------------------------------------------------------------------
          lbl_Status.Caption:='Traitement Terminé avec Succès';
          // si MiniSplit ?
          if FSplitThread.Mode=1 then
            begin
                If Datamod.MAJ_GENPARAM_Monitor(vDB,2500)
                  then
                    begin
                        Log.Log('InstallEasyLame',  Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logInfo, True, 0, ltServer);
                    end
                  else
                    begin
                        Log.Log('InstallEasyLame',  Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logError, True, 0, ltServer);
                    end;
            end;
          //----------------------------------------------------------------------------
      end
    else
      begin
        if FSplitThread.Mode=1 then
            begin
               Log.Log('InstallEasyLame',  Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_END, logError, True, 0, ltServer);
            end;
      end;
  EnabledActions(true);
end;

procedure TFrm_MainLame.DoSplittage(aIBFile:string;aServiceName:string);
var i:integer;
    ResInstallateur : TResourceStream;
    bNeedForce:boolean;
    Frm_SplittageDossierLame : TFrm_SplittageDossierLame;
    vDB    : string;
    vInfos : TInfosDelosEASY;

begin
  EnabledActions(false);
  Frm_SplittageDossierLame := TFrm_SplittageDossierLame.Create(nil);
  try
   Frm_SplittageDossierLame.IBFile:=aIBFile;
   for i:=0 to length(VGSYMDS)-1 do
      begin
        if aServiceName=VGSYMDS[i].ServiceName
          then Frm_SplittageDossierLame.SYMDSInfos:=VGSYMDS[i];
      end;
    if Frm_SplittageDossierLame.Showmodal = mrOk then
      begin

        FSplitThread:=TSplitThread.Create(true,StatusCallBack,ProgressCallBack,SplitCallBack);
        FSplitThread.sORIGINE_IB    := Frm_SplittageDossierLame.teIBFile.text;
//        FSplitThread.sDLC           := FormatDateTime('yyyymmdd_hhnnss',Now);
        FSplitThread.NOMPOURNOUS    := LowerCase(Frm_SplittageDossierLame.teNOM.text);
        FSplitThread.sCOPY_IB       := LowerCase(Format('%s\splits\%s_prepa_split_%s.ib',[ExcludeTrailingPathDelimiter(ExtractFilePath(Frm_SplittageDossierLame.teIBFile.text)), Frm_SplittageDossierLame.teNOM.text,FormatDateTime('yyyymmdd_hhnnss',FSplitThread.CreateTime)]));
        FSplitThread.sScriptFile    := Frm_SplittageDossierLame.TmpFile;
        FSplitThread.sBases         := Frm_SplittageDossierLame.ListBases.Text;
        FSplitThread.SYMDSInfos     := Frm_SplittageDossierLame.SYMDSInfos;
        FSplitThread.Engine         := 'easy_' + Frm_SplittageDossierLame.teNOM.text;
        FSplitThread.NODE_GROUP_ID  := Frm_SplittageDossierLame.cbType.Text;

//        FSplitThread.bStopService   := true; /// forcement
        FSplitThread.bForceReCreate := Frm_SplittageDossierLame.cbForceRecreate.Checked;
        if Frm_SplittageDossierLame.rbsplitcomplet.Checked then
          FSplitThread.Mode := 0;

        if Frm_SplittageDossierLame.rbMiniSplit.Checked then
          FSplitThread.Mode := 1;

        FSplitThread.DepotFTP := Frm_SplittageDossierLame.cbDEPOTFTP.Checked;

//        FSplitThread.bSplit         := Frm_SplittageDossierLame.cbSplittage.Checked;
        FSplitThread.bTriggerDiff   := false;  // False signifie qu'on ne calcul pas en différé (donc on calcul tout de suite)
//      FSplitThread.bDeleteSplitIBFile := True ; // Frm_SplittageDossierLame.cbDeleteIBAfterSplit.Checked;
//      FSplitThread.TypeArchive    := CLSID_CFormat7z;  // GetTypeArchive(Frm_SplittageDossierLame.cbTypeArchive.ItemIndex);
//        FSplitThread.ilevel         := GetLevelCompression(Frm_SplittageDossierLame.cbLevel.ItemIndex);
        try
           ResInstallateur := TResourceStream.Create(HInstance, 'cleanmaster2mags', RT_RCDATA);
           try
             ResInstallateur.SaveToFile(Frm_SplittageDossierLame.TmpFile);
             finally
             ResInstallateur.Free();
           end;

           // Pour le Log MiniSplit Uniquement (Delos2EASY)
           if FSplitThread.Mode=1 then
            begin
               vDB := FSplitThread.sORIGINE_IB;
               vInfos := DataMod.Get_Infos_Passage_DELOS2EASY(vDB);
               Log.App   := 'Delos2Easy';
               Log.Doss  := vInfos.Dossier;
               Log.Ref   := vInfos.GUID;
               // On passe en actif
               Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk',MSG_SPLIT , logNotice, True, 0, ltServer);
            end;

           FSplitThread.Start;
//           FRunning:=true;
        finally

        end;
      end
    else EnabledActions(true);
  finally

  end;
end;

procedure TFrm_MainLame.DBGrid3DrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var  BRect:TRect;
begin
  if (Column.Index=8) then
    begin
         if (gdFocused in State) or (gdSelected In State) then
          begin
             TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
             TDBGrid(Sender).Canvas.Font.Color  := clHighlightText;
             TDBGrid(Sender).Canvas.FillRect(Rect);
          end;

         BRect:=Rect;
         BRect.left:=BRect.left+1;
         BRect.Right:=BRect.Right-1;
         BRect.top:=BRect.top+1;
         BRect.bottom:=BRect.bottom-1;

         TDBGrid(Sender).Canvas.Pen.Color:= $00000000;
         TDBGrid(Sender).Canvas.Brush.Color := clBtnFace;
         TDBGrid(Sender).Canvas.Rectangle(BRect);

         TDBGrid(Sender).Canvas.Pen.Color := $00000000;
         TDBGrid(Sender).Canvas.Font.Color := $00000000;
         TDBGrid(Sender).Canvas.Font.Size := 8;
         TDBGrid(Sender).Canvas.TextOut(Rect.Left+10,Rect.Top+2,'Splittage...');

    end;
  if (Column.Index<>8) then
     begin
          if gdSelected in State then
            begin
              TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
              TDBGrid(Sender).Canvas.Font.Color := clHighlightText;
              TDBGrid(Sender).Canvas.FillRect(Rect);
            end
          else
            begin
                if (TDBGrid(Sender).DataSource.DataSet.RecNo mod 2) = 0
                  then TDBGrid(Sender).Canvas.Brush.Color := clBgL0
                  else TDBGrid(Sender).Canvas.Brush.Color := clBgL1;
            end;
          TDBGrid(Sender).DefaultDrawColumnCell(rect,datacol,column,state);
    end;
end;

procedure TFrm_MainLame.gridInstanceDblClick(Sender: TObject);
var Coord: TGridCoord;
    mouseInGrid : TPoint;
begin
    If TDBGrid(Sender).DataSource.Dataset.IsEmpty then Exit;
    mouseInGrid := gridInstance.ScreenToClient(Mouse.CursorPos) ;
    Coord := gridInstance.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
    if not (dgTitles in gridInstance.Options) then Exit;
    If (Coord.X=7) then
    begin
         ShellExecute(0, 'OPEN', PChar(Format('http://localhost:%d/app',[VGSYMDS[TDBGrid(Sender).DataSource.Dataset.FieldByName('ID').asinteger].http])), '', '', SW_SHOWNORMAL);
    end;
end;

procedure TFrm_MainLame.gridInstanceDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var  BRect:TRect;
begin
  if (Column.Index=6) then
    begin
         if (gdFocused in State) or (gdSelected In State) then
          begin
             TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
             TDBGrid(Sender).Canvas.Font.Color  := clHighlightText;
             TDBGrid(Sender).Canvas.FillRect(Rect);
          end;
         BRect:=Rect;
         BRect.left:=BRect.left+1;
         BRect.Right:=BRect.Right-1;
         BRect.top:=BRect.top+1;
         BRect.bottom:=BRect.bottom-1;

         TDBGrid(Sender).Canvas.Pen.Color:= $00000000;
         TDBGrid(Sender).Canvas.Brush.Color := clBtnFace;
         TDBGrid(Sender).Canvas.Rectangle(BRect);

         TDBGrid(Sender).Canvas.Pen.Color := $00000000;
         TDBGrid(Sender).Canvas.Font.Color := $00000000;
         TDBGrid(Sender).Canvas.Font.Size := 8;
         TDBGrid(Sender).Canvas.TextOut(Rect.Left+10,Rect.Top+2,'Détails..');

        // gridGeneral.Canvas.Pen.Color:=clRed;
        // gridGeneral.Canvas.TextRect(Rect,5,2,'Voir...');
    end;
  if (Column.Index<>6) then
     begin
          if gdSelected in State then
            begin
              TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
              TDBGrid(Sender).Canvas.Font.Color  := clHighlightText;
              TDBGrid(Sender).Canvas.FillRect(Rect);
            end
          else
            begin
                if (TDBGrid(Sender).DataSource.DataSet.RecNo mod 2) = 0
                  then TDBGrid(Sender).Canvas.Brush.Color := clBgL0
                  else TDBGrid(Sender).Canvas.Brush.Color := clBgL1;
            end;
          TDBGrid(Sender).DefaultDrawColumnCell(rect,datacol,column,state);
    end;
end;

procedure TFrm_MainLame.Ouvrirlesservices1Click(Sender: TObject);
begin
    ShellExecute(0, 'OPEN', pChar('services.msc'),PChar(VGSYMDS[pmService.Tag].ServiceName), '', SW_SHOWNORMAL);
end;

procedure TFrm_MainLame.pmServicePopup(Sender: TObject);
var Coord: TGridCoord;
    mouseInGrid : TPoint;
begin
    // il faut saoir sur quel instance on est ?
    If Instances.IsEmpty then Exit;
    mouseInGrid := gridInstance.ScreenToClient(Mouse.CursorPos) ;
    Coord := gridInstance.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
    pmService.Tag:=-1;
    if not (dgTitles in gridInstance.Options) then Exit;
    If (Coord.X=6) then
    begin
        // On pose l'ID dans le TAG du popup;
        pmService.Tag:=Instances.FieldByName('ID').asinteger;
        if VGSYMDS[Instances.FieldByName('ID').asinteger].Status='Stopped'
          then
            begin
                pmsStart.Enabled:=true;
                pmsStop.Enabled:=false;
                pmsRestart.Enabled:=false;
            end;
        if VGSYMDS[Instances.FieldByName('ID').asinteger].Status='Running'
          then
            begin
                pmsStart.Enabled:=false;
                pmsStop.Enabled:=true;
                pmsRestart.Enabled:=true;
            end;
    end;
end;

procedure TFrm_MainLame.pmsRestartClick(Sender: TObject);
begin
    // Stop du service
    ServiceStop('',VGSYMDS[pmService.Tag].ServiceName);
    Sleep(1000);
    ServiceStart('',VGSYMDS[pmService.Tag].ServiceName);
    Sleep(1000);
    Refresh();
end;

procedure TFrm_MainLame.pmsStartClick(Sender: TObject);
begin
    // Start du service
    ServiceStart('',VGSYMDS[pmService.Tag].ServiceName);
    Sleep(1000);
    Refresh();
end;

procedure TFrm_MainLame.pmsStopClick(Sender: TObject);
begin
    // Stop du service
    ServiceStop('',VGSYMDS[pmService.Tag].ServiceName);
    Sleep(1000);
    Refresh();
end;

procedure TFrm_MainLame.InstancesAfterScroll(DataSet: TDataSet);
begin
//     FDMemTable2.Filter:=Format('ServiceName=''%s''',[DataSet.FieldByName('ServiceName').asstring]);
//     FDMemTable2.Filtered:=true;
end;

procedure TFrm_MainLame.InstancesCalcFields(DataSet: TDataSet);
begin
     if DataSet.FieldByName('Size').Asfloat>0 then
       begin
          DataSet.FieldByName('sSize').AsString := FormatFloat(',0.0 Go',DataSet.FieldByName('Size').Asfloat / 1073741824);
       end;
end;

procedure TFrm_MainLame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Log.App := 'EasyCC';
    Log.Log('EasyCC', '', '', 'Action', 'Arrêt', logInfo, True, 0, ltServer);
    Log.Close;
    If FNewDB<>''
      then
        begin
          ExitCode := FErrorLevel;
        end;

end;

procedure TFrm_MainLame.FormCreate(Sender: TObject);
var astr:string;
    i:Integer;
    param,value:string;
begin
     FLockUpdate:=false;
     FNeWDB    := '';
     FNewName  := '';
     VGSE.ExePath:=ExtractFilePath(ParamStr(0));
     FormatSettings.DecimalSeparator  := '.';
     SetCurrentDir(ExtractFileDir(ParamStr(0)));
     CreationRessources;
     // GetPublicIP();
     // -----------------
     LoadHostName;
     // -----------------
     Caption := 'Easy Control Center / Lame : ' + VGSE.HostName + ' - ' + FileVersion(ParamStr(0));
     Refresh;
     //  BJAVA.Enabled := not(JavaInstalled);

      for i :=1 to ParamCount do
      begin
          param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
          value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
          If lowercase(param)='newdb'
            then FNewDB := value;
          // NewName pour avoir des GUID tout neufs
          If lowercase(param)='newname'
            then FNewName := value;
      end;
    FInstallTHread := nil;

    Log.App   := 'EasyCC';
    Log.Inst  := '' ;
    Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
    Log.SendOnClose := true ;
    Log.Open ;
    Log.SendLogLevel := logTrace;
    Log.Log('EasyCC', '', '', 'Action', 'Lancement', logInfo, True, 0, ltServer);

end;

procedure TFrm_MainLame.FormShow(Sender: TObject);
begin
    If FNewDB<>'' then NewDossier;
end;

procedure TFrm_MainLame.Refresh();
var i:integer;
    vID:integer;
begin
     vID := -1;
     if not(Instances.Isempty) then
       vID := Instances.FieldByName('ID').AsInteger;
     Instances.DisableControls;
     Dossiers.DisableControls;
     Instances.Close;
     Dossiers.Close;
     WMI_GetServicesSYMDS;
     GetDatabases;
     Instances.Open;
     for i:=0 to length(VGSYMDS)-1 do
        begin
          Instances.append;
          Instances.FieldByName('ID').asinteger         := i;
          Instances.FieldByName('ServiceName').asstring := VGSYMDS[i].ServiceName;
          Instances.FieldByName('PathName').asstring    := VGSYMDS[i].PathName;
          Instances.FieldByName('ConfigFile').asstring  := VGSYMDS[i].ConfigFile;
          Instances.FieldByName('Directory').asstring   := VGSYMDS[i].Directory;
          case CaseOfString(VGSYMDS[i].Status, ['Stopped','Running']) of
            0:Instances.FieldByName('Etat').asstring        := 'Arrêté';
            1:Instances.FieldByName('Etat').asstring        := 'En cours d''exécution';
            else Instances.FieldByName('Etat').asstring        := '?';
          end;
          Instances.FieldByName('NBBASES').AsInteger    := 0;
          Instances.FieldByName('SIZE').AsLargeInt      := 0;
          Instances.FieldByName('Ports').asstring       := Format('%d,%d,%d,%d',[
              VGSYMDS[i].http,VGSYMDS[i].https,VGSYMDS[i].jmxhttp,VGSYMDS[i].jmxagent]);
          Instances.post;
        end;
     Dossiers.Open;
     for i:=0 to length(VGIB)-1 do
        begin

          Dossiers.append;
          Dossiers.FieldByName('ID').asinteger := i;
          Dossiers.FieldByName('EngineName').asstring  := VGIB[i].Nom;
          Dossiers.FieldByName('IBFile').asstring := VGIB[i].DatabaseFile;;
          Dossiers.FieldByName('ServiceName').asstring := VGIB[i].ServiceName;
          Dossiers.FieldByName('PropertiesFile').asstring := VGIB[i].PropertiesFile;
          Dossiers.FieldByName('SIZE').asLargeInt  := -1;
          Dossiers.FieldByName('TRG').Asinteger    := -1;
          Dossiers.FieldByName('RTB').Asinteger    := -1;
          Dossiers.FieldByName('Version').AsString := '?';
          if FileExists(VGIB[i].DatabaseFile) then
            begin
                Dossiers.FieldByName('SIZE').asLargeInt  := FileSize(VGIB[i].DatabaseFile);
                Dossiers.FieldByName('TRG').Asinteger    := DataMod.NbTriggersSymDS(VGIB[i].DatabaseFile);
                Dossiers.FieldByName('RTB').Asinteger    := DataMod.NbTableTriggersSymDS(VGIB[i].DatabaseFile);
                Dossiers.FieldByName('Version').AsString := DataMod.GetGinkoiaVersion(VGIB[i].DatabaseFile);
                // On compte le nombre de base et la taille des bases...
                if Instances.Locate('ServiceName',VGIB[i].ServiceName)
                    then
                        begin
                            Instances.Edit;
                            Instances.FieldByName('NBBASES').AsInteger := Instances.FieldByName('NBBASES').AsInteger+1;
                            Instances.FieldByName('SIZE').AsLargeInt   := Instances.FieldByName('SIZE').AsLargeInt   + FileSize(VGIB[i].DatabaseFile);
                            Instances.Post;
                        end;
            end;
          Dossiers.post;
          //  IntToStr(NbTriggersSymDS(VGIB[i].DatabaseFile));



        end;
     if vID>-1
      then Instances.Locate('ID',vID,[]);
     Instances.EnableControls;
     Dossiers.EnableControls;
end;

initialization

end.


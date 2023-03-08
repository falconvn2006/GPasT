unit MainFrmEasyClean_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ShellAPI,  System.IOUtils,
  Vcl.ComCtrls, uDownloadHTTP, Vcl.ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.IniFiles, IdURI, System.JSON,uThreadCleanEASY,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Winapi.ShlObj,Winapi.ActiveX;

Const
  CST_MD5_JAVA  = 'CB814E318F840EAE77CCBFD7FF88C402';
  CST_MD5_EASY  = 'FDCE87E308B7EBDC909F95832BC7822C';

type
  TForm19 = class(TForm)
    BCleanDir: TButton;
    BCleanSYMTABLES: TButton;
    BInstall: TButton;
    edtDATABASEFILE: TEdit;
    Label1: TLabel;
    BDownload: TButton;
    mLog: TMemo;
    pbEtape: TProgressBar;
    Button6: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    TabSheet3: TTabSheet;
    StatusBar1: TStatusBar;
    Label17: TLabel;
    Label16: TLabel;
    cbDossiers: TComboBox;
    cbSENDER: TComboBox;
    cbType: TComboBox;
    Label2: TLabel;
    teURLSynchro: TEdit;
    Label3: TLabel;
    BRecup: TButton;
    BCreateProperties: TButton;
    mTABLE_SENDERS: TFDMemTable;
    mTABLE_SENDERSSENDER: TStringField;
    mTABLE_SENDERSIDENT: TStringField;
    mTABLE_SENDERSPLAGE: TStringField;
    TabSheet4: TTabSheet;
    Button2: TButton;
    ComboBox1: TComboBox;
    Button1: TButton;
    BUnInstall: TButton;
    TabSheet5: TTabSheet;
    BGRANT: TButton;
    BRegLauncherEASY: TButton;
    BregBase0: TButton;
    BUDF: TButton;
    procedure BCleanDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BDownloadClick(Sender: TObject);

    procedure DoLog(aValue:string);
    procedure StatusCallBack(Const aValue:string);

    procedure BInstallClick(Sender: TObject);
    procedure BCleanSYMTABLESClick(Sender: TObject);
    procedure cbDossiersChange(Sender: TObject);
    procedure BCreatePropertiesClick(Sender: TObject);
    procedure BRecupClick(Sender: TObject);
    procedure CallBackClean(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure CallBackRecupBase(Sender: TObject);
    procedure BUnInstallClick(Sender: TObject);
    procedure BGRANTClick(Sender: TObject);
    procedure BRegLauncherEASYClick(Sender: TObject);
    procedure BregBase0Click(Sender: TObject);
    procedure BUDFClick(Sender: TObject);

  private
    FEasy7z  : string;
    FJava7z  : string;
    FFileEasy7zOk : Boolean;
    FFileJava7zOk : Boolean;
    FDATADir      : string;
    FGinkoiaPath  : string;

    FThread  : TDownloadThread;
    FThreadCleanEASY :TThreadCleanEASY;
    FThreadRecupBase :TThreadRecupBase;
    FLnkFiles            : TStringList;
    procedure DoDownload7zFiles();
    function Confirmation(Const aMsg:string=''):boolean;
    procedure DoDownloadEasy7Z();
    procedure DoDownloadJava7Z();
    function InstallEASYDir():boolean;
    procedure LockBtn();
    procedure UnLockBtn();
    function GetDossiersDistants:Boolean;
    function GetSplitsDistants(aDossier:string):Boolean;

    function DeleteShortCutLauncherEASY():Boolean;
    procedure AjouteLnkDir(const Dir: string);
    function GetTargetFromLnk (const LinkFileName:String):String;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form19: TForm19;

implementation

{$R *.dfm}

Uses uCommun,UWMI,SymmetricDS.Commun,uSevenZip, LaunchProcess, uDataMod,ServiceControler, uPasswordManager;

procedure TForm19.StatusCallBack(Const aValue:string);
begin
    DoLog(aValue);
end;


procedure TForm19.DoLog(aValue:string);
begin
    mLog.Lines.Add(FormatDateTime('[yyyy-mm-dd hh:nn:ss.zzz] : ',Now())+aValue);
end;


function TForm19.GetSplitsDistants(aDossier:string):Boolean;
var vjson : string;
    IdHTTP: TIdHTTP;
    vUrl : Widestring;
    LJsonArr   : TJSONArray;
    LJsonValue : TJSONValue;
    LItem     : TJSONValue;
    vItem     : string;
    IsMiniSplit : Boolean;
    vSender : string;
    vOpen    : Boolean;
    vComplet : Boolean;
begin
  result:=false;
  cbSender.Items.Clear;
  IdHTTP        := TIdHTTP.Create;
  try
    vjson          := '';
    try
      vUrl := TIdURI.UrlENcode('http://easy-ftp.ginkoia.net/list_splits.php');
      vjson := IdHTTP.Get(vUrl);
    finally
      IdHTTP.Free;
    end;

    if vJson='null' then exit;


    // On parse maintenant
     try
      LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(vjson),0) as TJSONArray;
        try
           for LJsonValue in LJsonArr do
           begin
              // Ouvert =
              vOpen    := False;
              vComplet := False;
              for LItem in TJSONArray(LJsonValue) do
                begin
                    if ((TJSONPair(LItem).JsonString.Value='dossier') and ((TJSONPair(LItem).JsonValue.Value)=aDossier))
                      then
                         begin
                            // On ouvre
                            vOpen:=true;
                         end;
                    if (TJSONPair(LItem).JsonString.Value='filename') and vOpen
                      then
                         begin
                             vSender := TJSONPair(LItem).JsonValue.Value;
                             vSender := Copy(vSender,1,Length(vSender)-22); // -22 car la fin ressemble à _YYYYMMJJ_HHMMSS.split
                         end;
                    if ((TJSONPair(LItem).JsonString.Value='splittype') and ((TJSONPair(LItem).JsonValue.Value)<>''))
                       and vOpen and (vSender<>'')
                      then
                         begin
                            vComplet:=true;
                            if cbSender.Items.IndexOf(TJSONPair(LItem).JsonValue.Value)=-1
                              then cbSender.Items.Add(vSender);
                         end;

                end;
           end;
         finally
          LJsonArr.DisposeOf;
         end;
     Except
        //

     end;





    result:=true;
  except
    result := False;
  end;
end;


function TForm19.GetDossiersDistants:Boolean;
var vjson : string;
    IdHTTP: TIdHTTP;
    vUrl : Widestring;
    LJsonArr   : TJSONArray;
    LJsonValue : TJSONValue;
    LItem     : TJSONValue;
    vItem     : string;
    IsMiniSplit : Boolean;
    vSender : string;

begin
  result:=false;
  cbDossiers.Items.Clear;
  cbSender.Items.Clear;
  IdHTTP        := TIdHTTP.Create;
  try
    vjson          := '';
    try
      vUrl := TIdURI.UrlENcode('http://easy-ftp.ginkoia.net/list_splits.php');
      vjson := IdHTTP.Get(vUrl);
    finally
      IdHTTP.Free;
    end;

    if vJson='null' then exit;
    // On parse maintenant
     try
      LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(vjson),0) as TJSONArray;
        try
           for LJsonValue in LJsonArr do
           begin
              for LItem in TJSONArray(LJsonValue) do
                begin
                    if (TJSONPair(LItem).JsonString.Value='dossier')
                      then
                         begin
                             if cbDossiers.Items.IndexOf(TJSONPair(LItem).JsonValue.Value)=-1
                               then cbDossiers.Items.Add(TJSONPair(LItem).JsonValue.Value);
                         end;
                end;
           end;
         finally
          LJsonArr.DisposeOf;
         end;
     Except

     end;
    result:=true;
  except
    result := False;
  end;
end;


function TForm19.InstallEASYDir():boolean;
var vPathGinkoiaDir:string;
begin
    try
      vPathGinkoiaDir := IncludeTrailingPathDelimiter(ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(edtDATABASEFILE.Text))));
      Unzip7zFile(FEasy7Z, IncludeTrailingPathDelimiter(vPathGinkoiaDir+'\EASY'));
      Sleep(150);
      // Création des répertoires /tmp /logs / engines
      MkDir(IncludeTrailingPathDelimiter(vPathGinkoiaDir)+'\EASY\logs');
      MkDir(IncludeTrailingPathDelimiter(vPathGinkoiaDir)+'\EASY\engines');
      MkDir(IncludeTrailingPathDelimiter(vPathGinkoiaDir)+'\EASY\tmp');
      // depot de sym_udf.dll
      result:=true;
    except
      on e: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
end;

procedure TForm19.CallBackRecupBase(Sender: TObject);
begin
    UnLockBtn();
end;

procedure TForm19.CallBackClean(Sender: TObject);
begin
  UnLockBtn();
end;

procedure TForm19.BCleanSYMTABLESClick(Sender: TObject);
begin
  if Not(Confirmation('Suppression des tables SYMDS ? ')) then
    exit;

  LockBtn;
  FThreadCleanEASY := TThreadCleanEASY.Create(edtDATABASEFILE.Text,nil,nil,CallBackClean);
  FThreadCleanEASY.Start;
end;

procedure TForm19.LockBtn();
begin
    BUDF.Enabled := false;
    BGRANT.Enabled := False;
    BRegLauncherEASY.Enabled := false;
    BRegbase0.Enabled := false;

    BDownload.Enabled := False;
    BInstall.Enabled  := False;
    ComboBox1.Enabled   := false;
    Button1.Enabled   := false;
    Button2.Enabled   := false;
    BUnInstall.Enabled  := False;

    BCleanDir.Enabled := False;
    BCleanSYMTABLES.Enabled := False;
    BRecup.Enabled := False;
    BCreateProperties.Enabled := False;
end;


procedure TForm19.UnLockBtn();
begin
    BUDF.Enabled := true;
    BGRANT.Enabled := true;
    BRegLauncherEASY.Enabled := true;
    BRegbase0.Enabled := true;


    BDownload.Enabled := true;
    BInstall.Enabled  := true;
    BCleanDir.Enabled := true;
    ComboBox1.Enabled   := true;
    Button1.Enabled   := true;
    Button2.Enabled   := true;
    BUnInstall.Enabled  := true;

    BCleanSYMTABLES.Enabled := true;
    BRecup.Enabled := true;
    BCreateProperties.Enabled := true;
end;

procedure TForm19.BInstallClick(Sender: TObject);
begin
    LockBtn();
    if not(JavaInstalled(1)) then InstallJAVA(1);
    InstallEASYDir();
    unLockBtn();
end;

procedure TForm19.BDownloadClick(Sender: TObject);
begin
   LockBtn;
   DoDownload7zFiles();
   UnLockBtn;
end;

procedure TForm19.BGRANTClick(Sender: TObject);
begin
  if (DataMod.Grant_SYMTABLE_TO_GINKOIA(edtDATABASEFILE.Text))
     then DoLog('GRANT OK')
     else DoLog('GRANT Erreur');
end;

procedure TForm19.BCreatePropertiesClick(Sender: TObject);
var slConfFile:TStringList;
    vNode :string;
    vPropertiesFile:string;
    vDATADir:string;
    vGinkoiaPath : string;
begin
  slConfFile        := TStringList.Create();
  try
    vNode := Sender_To_Node(cbSender.text);

    vDATADir      := ExtractFilePath(edtDATABASEFILE.Text);
    vGinkoiaPath  := IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(vDATADir))));

    vPropertiesFile := vGinkoiaPath + 'EASY\engines\' + cbType.Text + '-' + vNode + '.properties';
    DeleteFile(vPropertiesFile);


    slConfFile.NameValueSeparator             := '=';
    slConfFile.Values['external.id']          := vNode;
    slConfFile.Values['engine.name']          := cbType.Text +'-'+ vNode;
    slConfFile.Values['group.id']             := cbType.Text;


    slConfFile.Values['sync.url']             := Format('http\://%s\:%d/sync/%s',[GetComputerNetName,32415,cbType.Text +'-'+ vNode]);

    slConfFile.Values['db.driver']            := 'interbase.interclient.Driver';
    slConfFile.Values['db.url']               := StringReplace('jdbc:interbase://localhost:3050/' + StringReplace(edtDATABASEFILE.Text, '\', '/',[rfReplaceAll]),':','\:',[rfReplaceAll]);
    slConfFile.Values['db.user']              := 'SYSDBA';
    slConfFile.Values['db.password']          := 'masterkey';
    slConfFile.Values['db.validation.query']  := 'SELECT CAST(1 AS INTEGER) FROM RDB$DATABASE';

    slConfFile.Values['registration.url']     := StringReplace(teURLSynchro.Text,':','\:',[rfReplaceAll]);
    slConfFile.SaveToFile(vPropertiesFile);
  finally
    slConfFile.Free();
  end;
end;

procedure TForm19.BRecupClick(Sender: TObject);
begin
    teURLSynchro.Text := DataMod.GetGenParam_80_1(edtDATABASEFILE.Text);
end;

procedure TForm19.BregBase0Click(Sender: TObject);
begin
  WriteBase0(edtDATABASEFILE.Text);
  try
     FDATADir     := ExtractFilePath(edtDATABASEFILE.Text);
     FGinkoiaPath := IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FDATADir))));
  except
      //
  end;
end;

procedure TForm19.BRegLauncherEASYClick(Sender: TObject);
begin
  //  WriteBase0(edtDATABASEFILE.Text);
end;

procedure TForm19.BUnInstallClick(Sender: TObject);
var ShOp: TSHFileOpStruct;
    vDATADir : string;
    vGinkoiaPath : string;
    vParams:string;
    vCall:string;
    merror  : string;
    a:Cardinal;
var passCorrect: Boolean;
    password: string;
    test: AnsiString;
    retourPassword: TPasswordValidation;
begin
  if edtDATABASEFILE.Text=''
    then
      begin
          DoLog('Aucun Chemin de Base...');
          exit;
      end;

  passCorrect := true;
  password := InputBox('Service Easy', #31'Mot de passe : ', '');

  PasswordManager.PasswordName := 'GestionServices';
  retourPassword := PasswordManager.ComparePassword(password);
  // si le fichier de mot de passe, ou la clé du mot de passe n'existe pas, on prend chamonix par défaut
  if (retourPassword = fileNotExist) or (retourPassword = PasswordNotExist) then
  begin
    if password <> 'ch@mon1x' then
      passCorrect := false;
  end
  else
    if retourPassword <> PassOk then
      passCorrect := false;

  if not(passCorrect) then
  begin
     exit;
  end;

  LockBtn;
  KillProcess('LauncherEASY.exe');
  DoLog('Kill du LauncherEASY');



  vDATADir      := ExtractFilePath(edtDATABASEFILE.Text);
  vGinkoiaPath  := IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(vDATADir))));

  // vParams := 'stop';
  // vCall   := vGinkoiaPath + 'EASY\bin\sym_service.bat';
  // a:=ExecAndWaitProcess(merror,vCall,vParams);

  // vParams := 'uninstall';
  // vCall   := vGinkoiaPath + 'EASY\bin\sym_service.bat';
  // a:=ExecAndWaitProcess(merror,vCall,vParams);


  If ServiceExist('','EASY')
    then
      begin
          DoLog('Arrêt Service EASY');
          ServiceStop('','EASY');
      end;
  Sleep(5000);

  // -------------
  // Kill JAVA ???


  DoLog('Suppression Service EASY');
  vParams := 'delete EASY';
  vCall   := 'sc';
  a:=ExecAndWaitProcess(merror,vCall,vParams);


  DoLog('Suppression de \EASY\tmp\');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'EASY\tmp\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  DoLog('Suppression de \EASY\engines\');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'EASY\engines\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  DoLog('Vidage du répertoire \EASY');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'EASY\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  DoLog('Suppression de \JAVA');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'JAVA\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  If RemoveDir(vGinkoiaPath + 'EASY')
    then DoLog('Suppression du répertoire EASY');

  DoLog('Suppression de '+vGinkoiaPath+'DATA\GINKOIA.IB');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'DATA\GINKOIA.IB'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  DoLog('Vidage de '+vGinkoiaPath+'EASYInstall');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'EASYInstall\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  DoLog('Vidage  '+vGinkoiaPath+ 'EAI');
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(vGinkoiaPath + 'EAI\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  // -------------------
  DoLog('Suppression des Entrées dans le registre');
  DeleteBase0();
  CleanLauncherAuto();
  //--------------------
  DoLog('Suppression des raccourcis LauncherEASY');
  DeleteShortCutLauncherEASY();

  unLockBtn;
end;



procedure TForm19.Button1Click(Sender: TObject);
begin
   try
      DataMod.GetSenders(edtDATABASEFILE.text,TDataSet(mTABLE_SENDERS));
   except
      On E:Exception do
        DoLog(E.Message);
   end;
   ComboBox1.Items.Clear;
   mTABLE_SENDERS.First;
   while not(mTABLE_SENDERS.eof) do
    begin
       ComboBox1.Items.Add(mTABLE_SENDERS.Fields[0].asstring);
       mTABLE_SENDERS.Next;
    end;
end;

procedure TForm19.Button2Click(Sender: TObject);
var vIDENT:string;
begin
    vIDENT :='';
    if ComboBox1.text<>''
      then
        begin
           mTABLE_SENDERS.First;
           while not(mTABLE_SENDERS.eof) do
            begin
               If ComboBox1.Text = mTABLE_SENDERS.Fields[0].AsString
                  then
                    begin
                        vIDENT:= mTABLE_SENDERS.Fields[1].AsString;
                        break;
                    end;
               mTABLE_SENDERS.Next;
            end;
          LockBtn;
          // il faut trouver le IDENT..
          FThreadRecupBase := TThreadRecupBase.Create(edtDATABASEFILE.Text,vIDENT,StatusCallBack,nil,CallBackRecupBase);
          FThreadRecupBase.Start;
        end;
end;




procedure TForm19.BUDFClick(Sender: TObject);
var vIBService, vIBStarted:boolean;
    vTempStr :string;
    i:Integer;
    vIBVersion:string;
    vIBPath:string;
begin
    LockBtn;
    try
      vIBService   := ServiceExist('','IBS_gds_db') and ServiceExist('','IBG_gds_db');
      vIBStarted   := (ServiceGetStatus('','IBS_gds_db')=4) and (ServiceGetStatus('','IBG_gds_db')=4);
      vTempStr:=InfoService('IBS_gds_db');
      i:=Pos('\bin\ibserver.exe',vTempStr,1);
      if i>0 then
        begin
          vTempStr:=Copy(vTempStr,0,i+16);
        end;
      vIBVersion := GetFileVersion(vTempStr);
      vIBPath    := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(vTempStr)));
      if PoseUDF(vIBPath)
         then DoLog('sym_udf.dll : OK')
         else DoLog('sym_udf.dll : ERREUR');
    except
      DoLog('sym_udf.dll : ERREUR');
    end;
    UnLockBtn;
end;

procedure TForm19.Button6Click(Sender: TObject);
begin
    //
    MessageDlg('Ne fait rien pour le moment',  mtError, mbOKCancel, 0);


    //
end;

procedure TForm19.cbDossiersChange(Sender: TObject);
begin
    GetSplitsDistants(TComboBox(Sender).Text);
end;

procedure TForm19.DoDownloadEasy7Z();
var vUrl :string;
  vLettreLecteur:string;
begin
  try
   DoLog('Téléchargement de EASY.7z...');
   pbEtape.Visible := true;
   pbEtape.Position:=0;
   // Suivant la lettre de lecture C ou D
   vLettreLecteur := UpperCase(ExtractFileDrive(edtDATABASEFILE.Text));
   if vLettreLecteur='D:'
     then vUrl :='http://lame2.no-ip.com/algol/Installation_EASY/MAGASIN/Easy-D.7z';
   if vUrl= '' then
      begin
         MessageDlg('Pas de fichier 7Z pour ce Drive pour le moment',
           mtError, mbOKCancel, 0);
         Exit;
      end;
   // ou C vUrl :='http://lame2.no-ip.com/algol/Installation_EASY/MAGASIN/Easy-C.7z';

   if FileExists(FEasy7z)
     then DeleteFile(FEasy7z);
   FThread := TDownloadThread.Create(vURL, FEasy7z, '', '', '', pbEtape);

   while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();

   pbEtape.Position:=pbEtape.Max;
   Application.ProcessMessages();
   DoLog('Téléchargement EASY.7z terminé');
   DoLog(Format('Contrôle du fichier %s ...',[ExtractFileName(FEasy7z)]));
   if MD5File(FEasy7z)=CST_MD5_EASY
      then
          begin
             FFileEasy7zOk  := true;
             DoLog(Format('Fichier %s OK',[ExtractFileName(FEasy7z)]))
          end
      else
        begin
           DoLog(MD5File(FEasy7z));
           DoLog(Format('Fichier %s corrompu : ERREUR',[ExtractFileName(FEasy7z)]));
        end;
  finally
    FreeAndNil(FThread);
  end;
end;

procedure TForm19.DoDownloadJava7Z();
var vUrl :string;
begin
  try
   DoLog('Téléchargement de JAVA.7z....');
   pbEtape.Visible := true;
   pbEtape.Position:=0;
   vUrl :='http://lame2.no-ip.com/algol/Installation_EASY/MAGASIN/Java.7z';
   if FileExists(FJAVA7z)
     then DeleteFile(FJAVA7z);

   FThread := TDownloadThread.Create(vURL, FJAVA7z, '', '', '', pbEtape);

   while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();

    pbEtape.Position:=pbEtape.Max;
    Application.ProcessMessages();
    DoLog('Téléchargement terminé');
    DoLog(Format('Contrôle du fichier %s ...',[ExtractFileName(FJava7z)]));
    if MD5File(FJava7z)=CST_MD5_JAVA
      then
          begin
             FFileJava7zOk := true;
             DoLog(Format('Fichier %s OK',[ExtractFileName(FJava7z)]))
          end
      else
         begin
            DoLog(Format('Fichier %s corrompu : ERREUR',[ExtractFileName(FJava7z)]));
         end;
  finally
    FreeAndNil(FThread);
  end;
end;


procedure TForm19.DoDownload7zFiles();
var  vDoDLJava : boolean;
     vDoDLEASY : boolean;
begin
     // JAVA
     FFileJava7zOk  := false;
     vDoDLJava := true;
     if FileExists(FJava7z) then
        begin
          DoLog(Format('Contrôle du fichier %s ...',[ExtractFileName(FJava7z)]));
          if MD5File(FJava7z)=CST_MD5_JAVA
            then
                begin
                   FFileJava7zOk := true;
                   DoLog(Format('Fichier %s OK',[ExtractFileName(FJava7z)]));
                   vDoDLJAVa :=false;
                end
            else DoLog(Format('Fichier %s corrompu',[ExtractFileName(FJava7z)]));
        end
     else DoLog(Format('Fichier %s absent...',[ExtractFileName(FJava7z)]));

     if vDODLJAVA
       then DoDownloadJava7z();

     // Easy
     FFileJava7zOk := False;
     vDoDLEASY := true;
     if FileExists(FEasy7z) then
        begin
           DoLog(Format('Contrôle du fichier %s...',[ExtractFileName(FEasy7z)]));
           if MD5File(FEasy7z)=CST_MD5_EASY
             then
                begin
                   FFileJava7zOk := true;
                   DoLog(Format('Fichier %s OK',[ExtractFileName(FEasy7z)]));
                   vDoDLEASY :=false
                end
              else
                begin
                    DoLog(MD5File(FEasy7z));
                    DoLog(Format('Fichier %s corrompu',[ExtractFileName(FEasy7z)]));
                end;
        end
     else DoLog(Format('Fichier %s absent...',[ExtractFileName(FEasy7z)]));

    if vDoDLEASY
      then DoDownloadEasy7Z();

    if (FFileJava7zOk and FFileEasy7zOk) then
      begin
         // ==> envoyer un log pour dire que ce noeud est pret a recevoir EASY

      end;
    // On peut fermer dans tous les cas
    //  FCanClose := true;
end;


function TForm19.Confirmation(Const aMsg:string=''):boolean;
begin
    result := false;
    if Application.MessageBox(PWideChar(aMsg),'Confirmation' , MB_OKCANCEL +
      MB_ICONQUESTION + MB_DEFBUTTON2) = mrOk
       then result :=true;
end;

procedure TForm19.FormCreate(Sender: TObject);
begin
    edtDATABASEFILE.Text := ReadBase0;

    FDATADir     := '';
    FGinkoiaPath := '';

    try
      FDATADir     := ExtractFilePath(edtDATABASEFILE.Text);
      FGinkoiaPath := IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FDATADir))));
    except
      //
    end;

    FJava7z := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'JAVA.7Z';
    FEasy7z := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'EASY.7Z';

    GetDossiersDistants();
end;

procedure TForm19.BCleanDirClick(Sender: TObject);
var ShOp: TSHFileOpStruct;
    vParams:string;
    vCall:string;
    merror  : string;
    a       : cardinal;
begin
  if Not(Confirmation('Suppression du Service, vidage du /tmp et /engines ? ')) then
    exit;
  LockBtn;

  vParams := 'stop';
  vCall   := FGinkoiaPath + 'EASY\bin\sym_service.bat';
  a:=ExecAndWaitProcess(merror,vCall,vParams);

  vParams := 'uninstall';
  vCall   := FGinkoiaPath + 'EASY\bin\sym_service.bat';
  a:=ExecAndWaitProcess(merror,vCall,vParams);

  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(FGinkoiaPath + 'EASY\tmp\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(FGinkoiaPath + 'EASY\engines\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);

  unLockBtn;
end;



function TForm19.GetTargetFromLnk (const LinkFileName:String):String;
var
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  Info: array[0..MAX_PATH] of Char;
  FindData: TWin32FindData;
begin
  Result := '';
  CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, ShellLink);
  if ShellLink.QueryInterface(IPersistFile, PersistFile) = 0 then
  begin
    PersistFile.Load(PChar(LinkFileName), STGM_READ);
    ShellLink.GetPath(@Info, MAX_PATH, FindData, SLGP_UNCPRIORITY);
    Result := UpperCase(Info);
  end;
end;

procedure TForm19.AjouteLnkDir(const Dir: string);
var SR: TSearchRec;
    vLauncherEASY : TFileName;
    vTargetFile : TFileName;
begin

  vLauncherEASY := upperCase(FGinkoiaPath+'LauncherEASY.exe');
  if FindFirst(IncludeTrailingBackslash(Dir) + '*.*', faAnyFile or faDirectory, SR) = 0 then
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          begin
            // Seulement si c'est un .lnk
            if ExtractFileExt(SR.Name)='.lnk' then
              begin
                  vTargetFile := GetTargetFromLnk(Dir+SR.Name);
                  if (vTargetFile=vLauncherEASY) then
                     FLnkFiles.Add(Dir+SR.Name)
              end;
          end
        else if (SR.Name <> '.') and (SR.Name <> '..') then
          AjouteLnkDir(IncludeTrailingBackslash(IncludeTrailingBackslash(Dir)+SR.Name));  // recursive call!
      until FindNext(Sr) <> 0;
    finally
      FindClose(SR);
    end;
end;

function TForm19.DeleteShortCutLauncherEASY():Boolean;
var vDir:string;
    i:integer;
begin
    // Liste les Raccourcis du Bureau et du lancement Rapide
    // Si ca pointe vers le LaunchV7 ... on supprime le raccourci
    FLnkFiles:=TStringList.Create;
    try

      // Répertoire "Ginkoia"
      vDir := IncludeTrailingPathDelimiter(FGinkoiaPath);
      AjouteLnkDir(vDir);
      //------------------------

      // Répertoire du "Bureau"
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_DESKTOP));
      AjouteLnkDir(vDir);

      // Menu Demarrer
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_STARTMENU));
      AjouteLnkDir(vDir);

      // Menu Demarrer Commun
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_COMMON_STARTMENU));
      AjouteLnkDir(vDir);

      // Barre de Lancement Rapide
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA)) + 'Microsoft\Internet Explorer\Quick Launch\';
      AjouteLnkDir(vDir);

      // Maintenant on a la liste.....
      result:=true;
      for i := 0 to FLnkFiles.Count-1 do
        begin
           Result := Result and DeleteFile(FLnkFiles.Strings[i]);
        end;
    finally
      FLnkFiles.DisposeOf;
    end;
end;



end.

unit Download_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IOUtils, System.Types, System.StrUtils,
  // Début Uses Perso
  uFunctions,
  uParams,
  uRessourcestr,
  uSevenZip,
  uToolsXE,
  // uLogfile, anciens
  uLog,
  uLameFileparser,
  uDownloadfromlame,
  uPatchScript,
  uInstallbase,
  uBasetest,
  registry,
  ShlObj,
  Informations,
  IniFiles,
  Pwd_Frm,
  SelectFile_frm,
  UPatchDll,
  // Fin Uses Perso
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.CheckLst;

Const
  LOCALFILE = 0;
  URL = 1; // id de l'image dans imagelist
  STOP = 2;
  FROMLAME = 3;
  WM_LOADLISTFROMLAME = WM_USER + 101;
  Log_Mdl = 'Download';

type
  TFrm_Download = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    pbBar: TProgressBar;
    pnlLame: TPanel;
    lblLblconfirmation: TLabel;
    btnDownload: TButton;
    edtConfirm: TEdit;
    pnlClient: TPanel;
    lbl5: TLabel;
    lbl6: TLabel;
    edtCode: TEdit;
    rgRgChoice: TRadioGroup;
    pnlInstall: TPanel;
    lbl1: TLabel;
    btnBtn_Install: TButton;
    cbbDrive: TComboBox;
    chkBasetest: TCheckBox;
    pnlUrl: TPanel;
    Label4: TLabel;
    edtLocalfile: TButtonedEdit;
    lblInfo: TLabel;
    lblEstimated: TLabel;
    IdHTTP1: TIdHTTP;
    Openfile: TFileOpenDialog;
    OpenFileXP: TOpenDialog;
    chkEasy: TCheckBox;
    lblEasy: TLabel;
    edtPathEasy: TButtonedEdit;
    BtnFromServer: TButton;
    procedure edtCodeChange(Sender: TObject);
    procedure rgRgChoiceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtConfirmChange(Sender: TObject);
    procedure LoadListFromLame(var aMsg: Tmessage); message WM_LOADLISTFROMLAME;
    procedure btnBtn_InstallClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtLocalfileDblClick(Sender: TObject);
    procedure edtLocalfileExit(Sender: TObject);
    procedure edtLocalfileKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtLocalfileRightButtonClick(Sender: TObject);
    procedure cbbDriveChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure edtCodeEnter(Sender: TObject);
    procedure edtPathEasyDblClick(Sender: TObject);
    procedure edtPathEasyExit(Sender: TObject);
    procedure edtPathEasyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure BtnFromServerClick(Sender: TObject);
  private
    { Déclarations privées }
    sCodeClient, sLocation, sFiletoInstall, sPathEasy: string;
    aListdesfichierssurlame: Tstringlist;
    Fstop: boolean;
    ptAfterDownload: TAfterDownload;
    ptBeforeDownload: TBeforeDownload;
    ptProgress: TDisplayprogress;
    ptBeforeReset: TBeforeReset;
    Install: Tinstall;
    bRecupBase: boolean;
    bIsEasy: boolean;
    FTransaction: boolean;
    AlreadyInstall: boolean;
    Res: TResourceStream;

    // partie zip
    Vzipmax, Vzipvalue: Int64;
    StopExtract: boolean; // variable globale pour stopper le processus d'extraction

    function Unzip(aFile, aDestPath, aPassword: string): boolean; Overload;
    function InstallServeur: boolean;
    procedure TestIfEasy(aFileToTest: string);
    procedure ChoixChargementEnable(State: boolean);
    function UnzipWithExe(aFile, aDestPath, aPassword: string): boolean;
  public
    { Déclarations publiques }
  end;

function ProgressCallback(Sender: Pointer; total: boolean; value: Int64): HRESULT; stdcall;
procedure UpdateProgress(aPercent: Integer);

var
  Frm_Download: TFrm_Download;

implementation

uses Main_Dm, Server_Frm, Main_Frm;

{$R *.dfm}

procedure TFrm_Download.btnBtn_InstallClick(Sender: TObject);
Const
	Log_Key = 'btnBtn_InstallClick';
var
  sMag: string;
  HasError: Boolean;
var
  oMsg: TForm;
  procedure ErrorMsg(sMsg: string); inline;
  var
    oMsg: TForm;
  begin
    oMsg := CreateMessageDialog(sMsg, mtError, [mbOk]);
    oMsg.Position := poOwnerFormCenter;
    oMsg.FormStyle := fsStayOnTop;
    oMsg.ShowModal;
    oMsg.Release;
  end;

  procedure LockUnlockPanel(bAction: boolean);
  begin
    edtCode.Enabled := bAction;
    // rgRgChoice.Enabled := bAction;
    ChoixChargementEnable(bAction);
    application.ProcessMessages;
  end;

  procedure ExitForError(aMsg: string = '');
  begin
    btnBtn_Install.Caption := RST_INSTALL;
    btnBtn_Install.Tag := 0;
    lblInfo.Caption := '';

    Log.Log(Log_Mdl, Log_Key, aMsg, logError, True, 0, ltBoth);

    HasError := True;

    if aMsg <> '' then
      ErrorMsg(aMsg);
  end;

begin

  HasError := False;
  // installation du fichier
  if btnBtn_Install.Tag = 1 then
  begin
    // on arrête le processus d'installation
    // le tag est remis à 0
    btnBtn_Install.Caption := RST_INSTALL;
    btnBtn_Install.Tag := 0;
    //Log.Log(RST_ZIPSTOPPEDBYUSER, logWarning);
    Log.Log(Log_Mdl,Log_Key, RST_ZIPSTOPPEDBYUSER, logInfo, True, 0, ltBoth);

    lblInfo.Caption := '';
    Exit;
  end;

  // Saving the path file
  UPatchDll.FileInstallBase := edtLocalfile.Text;

  Try
    // on place le tag en 1
    btnBtn_Install.Tag := 1;
    Self.Cursor := crHourGlass;

    LockUnlockPanel(False);

    lblInfo.Caption := '';
    pbBar.Visible := True;
    lblInfo.Visible := True;
    btnBtn_Install.Caption := RST_STOP;

    // si install sous Easy, on vérifie que les sources sont présentes
    if (SearchSourcesEasy(sPathEasy, True) = '') and (bIsEasy) then
    begin
      ExitForError(RST_ERROR_EASY_SOURCES);
      Exit;
    end;

    // on dézip le fichier et on poursuit si ok
    Log.Log(Log_Mdl, Log_Key, 'Installation depuis un ZIP', logInfo, True, 0, ltBoth);
    if InstallServeur = True then
    begin
      Try
        try
          application.ProcessMessages;

          // Après extraction des fichiers on lance l'installation de Easy avant de passer à la suite
          // (dans le cas d'un choix d'une installation easy uniquement
          if bIsEasy then
          begin
            lblInfo.Caption := ' Installation de Easy';
            lblInfo.Visible := True;

            Log.Log(Log_Mdl, Log_Key, 'Installation de Easy', logInfo, True, 0, ltBoth);
            if not InstallEasy(sPathEasy, sLocation) then
            begin
              ExitForError(RST_ERROR_INSTALLEASY);
              // le tag est remis à 0
              btnBtn_Install.Caption := RST_INSTALL;
              btnBtn_Install.Tag := 0;
              Exit;
            end
            else
            begin
              // on nettoie le registre du launcherDelos
              CleanRegistryDelos();

              ShowMessage(RST_EASYSUCCESS);
            end;

            lblInfo.Caption := '';
          end;

          // création de l'objet Tinstall (uInstallbase)
          Install := Tinstall.Create(sLocation);
          // référencement de la base
          if bRecupBase = False then
          begin
            if Install.Referencement then
            begin
              // mise à jour du chemin de la base
              if Install.SetPathBPL then
              begin
                //
              end
              else
                ExitForError(RST_ERROR_BPL);
            end
            else
            begin
              ExitForError(RST_ERROR_REFERENCEMENT + #10 + Install.ErrorMsg);
              Exit;
            end;
          end
          else
          begin
            // c'est un récup base
            try
              oMsg := CreateMessageDialog(RST_RECUPBASE_NOINI, mtError, [mbYES, mbNo]);
              oMsg.Position := poOwnerFormCenter;
              oMsg.FormStyle := fsStayOnTop;
              if oMsg.ShowModal = IDYES then
              begin
                Install.NoInit := True;
              end;
            finally
              FreeAndNil(oMsg);
            end;
            Install.SetRecupBase(sLocation, Tpath.GetTempPath);
            if Install.Recupbase.MoveDatabase then
            begin

            end
            else
            begin
              ExitForError(RST_RECUPBASE_ECHEC + #10 + Install.ErrorMsg);
            end;

          end;
        except
          on E: Exception do
          begin
            raise Exception.Create(E.Message);
            Log.Log(Log_Mdl, Log_Key, 'Erreur lors de l''installation : ' + E.Message, logError, True, 0, ltBoth);
          end;
        end;
      Finally
        //

        if HasError then
        begin
          ShowMessage('Erreur lors de l''installation');
          Self.ModalResult := ID_CANCEL;
        end
        else
        begin
          if uFunctions.UsrLogged = UsrISF then
            if AlreadyInstall = False then
              ShowMessage('Installation de Nosymag terminée')
            else
              ShowMessage('Installation de Ginkoia terminée');
          Self.ModalResult := ID_YES;
        end;

        LockUnlockPanel(False);
        //Self.CloseModal;
      End;
    end
    else
    begin
      if AlreadyInstall <> True then
        ExitForError(RST_ERROR_UNZIP3);
      btnBtn_Install.Caption := RST_INSTALL;
    end;
  Finally
    LockUnlockPanel(True);

    if Assigned(Install) then
      Install.Database.DisposeOf;
  End;
end;

procedure TFrm_Download.TestIfEasy(aFileToTest: string);
Const
	Log_Key = 'TestIfEasy';
begin
  // on vérifie que le fichier de l'archive existe avant tout traitement

  if FileExists(aFileToTest) then
  begin
    bIsEasy := ArchiveIsEasy(aFileToTest);

    // si on est sur Easy, on fait la recherche des sources et on coche la case easy
    if bIsEasy then
    begin
      lblEasy.Visible := True;
      chkEasy.Visible := True;
      edtPathEasy.Visible := True;
      chkEasy.Checked := True;

      edtPathEasy.Text := SearchSourcesEasy();
      sPathEasy := edtPathEasy.Text;

      if (uFunctions.UsrLogged = UsrGin) or (Trim(edtPathEasy.Text) = '') then
        edtPathEasy.Enabled := True;

    end
    else
    begin
      chkEasy.Checked := False;
      lblEasy.Visible := False;
      chkEasy.Visible := False;
      edtPathEasy.Visible := False;
      edtPathEasy.Text := '';
      edtPathEasy.Enabled := False;
      sPathEasy := '';
    end;
  end
  else
  begin
    chkEasy.Checked := False;
    lblEasy.Visible := False;
    chkEasy.Visible := False;
    edtPathEasy.Visible := False;
    edtPathEasy.Text := '';
    edtPathEasy.Enabled := False;
    pnlInstall.Visible := False;
    sPathEasy := '';
  end;
end;

procedure TFrm_Download.btnCancelClick(Sender: TObject);
Const
	Log_Key = 'btnCancelClick';
begin
  TLameFileDownloader.Reset;
  ModalResult := mrCancel;
end;

procedure TFrm_Download.btnDownloadClick(Sender: TObject);
Const
	Log_Key = 'btnDownloadClick';
var
  fs: string;
begin

  if btnDownload.Tag = 0 then
  begin
    TLameFileParser.GetClientFiles(sCodeClient);

    if TLameFileParser.TClientFiles.Count > 1 then
    begin
      Try
        application.CreateForm(TFrm_SelectFile, Frm_SelectFile);
        Frm_SelectFile.Caption := Frm_SelectFile.Caption + ' ' + sCodeClient;
        if Frm_SelectFile.ShowModal = mrOk then
        begin
          fs := TLameFileParser.GetFullFileToDownloadPath;

        end
        else
        begin
          Exit;
        end;
      Finally
        Frm_SelectFile.Release;
        Frm_SelectFile := nil;
      End;
    end
    else
    begin
      TLameFileParser.GetFile(sCodeClient);
      fs := TLameFileParser.GetFullFileToDownloadPath;

    end;
    Try
      // Tlogfile.Addline(DateTimeToStr(now)+' '+RST_DOWNLOADRL );
      //Log.Log(RST_DOWNLOADRL, logInfo);
      Log.Log(Log_Mdl,Log_Key, RST_DOWNLOADRL, logInfo, True, 0, ltBoth);
      TLameFileDownloader.SetUrl(fs);
      TLameFileDownloader.BeforeDownload := ptBeforeDownload;
      TLameFileDownloader.Progress := ptProgress;
      TLameFileDownloader.AfterDownload := ptAfterDownload;
      TLameFileDownloader.BeforeReset := ptBeforeReset;
      Try
        TLameFileDownloader.Downloadfile(FROMLAME);
        // Tlogfile.Addline(DateTimetostr(Now)+' '+RST_ENDOFDOWNLOAD);
        //Log.Log(RST_ENDOFDOWNLOAD);
        Log.Log(Log_Mdl,Log_Key, RST_ENDOFDOWNLOAD, logInfo, True, 0, ltBoth);
        btnOk.Visible := False;
        btnCancel.Visible := False;
      Finally
        TLameFileDownloader.Reset;
      End;
    Except
      On E: Exception do
      begin
        // Tlogfile.Addline('****'+DateTimeToStr(Now)+' '+E.Message);
//        Log.Log(E.Message);
//        Log.Log(E.Message, logError);
        Log.Log(Log_Mdl,Log_Key, 'Erreur : ' + E.Message, logError, True, 0, ltBoth);
        ShowMessage(E.Message);
      end;
    End;

  end
  else
  begin
    // arrêter
    Fstop := True;
    application.ProcessMessages;
    btnDownload.Tag := 0;
    btnDownload.Caption := RST_DOWNLOAD;
    // Tlogfile.Addline('****'+DateTimeToStr(now)+' '+ RST_STOPPEDBYUSER );
    //Log.Log(RST_STOPPEDBYUSER, logWarning);
    Log.Log(Log_Mdl,Log_Key, RST_STOPPEDBYUSER, logInfo, True, 0, ltBoth);
    btnOk.Visible := True;
    btnCancel.Visible := True;
  end;
end;

procedure TFrm_Download.btnOkClick(Sender: TObject);
Const
	Log_Key = 'btnOkClick';
begin
  TLameFileDownloader.Reset;
  ModalResult := mrOk;
end;

procedure TFrm_Download.BtnFromServerClick(Sender: TObject);
Const
	Log_Key = 'BtnFromServerClick';
begin
  Self.Visible := False;
  Screen.Cursor := crHourGlass;
  application.CreateForm(TFrm_Serveur, Frm_Serveur);
  Frm_Serveur.Align := alClient;
  Frm_Serveur.ManualDock(Frm_Main.PDocksite, nil, alClient);
  Frm_Serveur.Show;
  Frm_Serveur.Parent := Frm_Main;
  Frm_Serveur.InitCaisseSec();
  // FreeAndNil(Frm_Download);
  Postmessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TFrm_Download.cbbDriveChange(Sender: TObject);
Const
	Log_Key = 'cbbDriveChange';
var
  oMsg: TForm;
begin
  if cbbDrive.Text = '' then
    Exit;

  btnBtn_Install.Visible := False;
  sLocation := cbbDrive.Text;
  sLocation := IncludeTrailingBackslash(sLocation) + 'GINKOIA';
  if Tdirectory.Exists(sLocation) then
  begin
    Try
      oMsg := CreateMessageDialog(RST_GINKOIA_EXISTS, mtWarning, [mbYES, mbNo]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      if oMsg.ShowModal = IDYES Then
      begin
        Log.Log(Log_Mdl, Log_Key, 'Installation sur répertoire Ginkoia existant sur ' + cbbDrive.Text, logWarning, True, 0, ltBoth);
        FTransaction := True;
        btnBtn_Install.Visible := True;
      end
      else
        cbbDrive.Text := '';
    Finally
      FreeAndNil(oMsg);
    End;
  end
  else
    btnBtn_Install.Visible := True;
end;

procedure TFrm_Download.edtCodeChange(Sender: TObject);
Const
	Log_Key = 'edtCodeChange';
begin
  if edtCode.Focused then
  begin
    // rgRgChoice.Enabled := (edtCode.Text <> '');
    ChoixChargementEnable(edtCode.Text <> '')
  end;
end;

procedure TFrm_Download.edtCodeEnter(Sender: TObject);
Const
	Log_Key = 'edtCodeEnter';
begin
  rgRgChoice.Itemindex := -1;
  pnlUrl.Visible := False;
  pnlInstall.Visible := False;
  edtCode.Text := '';
end;

procedure TFrm_Download.edtConfirmChange(Sender: TObject);
Const
	Log_Key = 'edtConfirmChange';
var
  sc: string;
  oMsg: TForm;
begin
  sc := edtConfirm.Text;
  if sc.Length = sCodeClient.Length then
  begin
    btnDownload.Enabled := (sc = sCodeClient);
    if btnDownload.Enabled then
    begin
      edtCode.Text := sCodeClient;
    end
    else
    begin
      oMsg := CreateMessageDialog(RST_ERROR_CODE, mtWarning, [mbOk]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      oMsg.ShowModal;
      oMsg.Release;
    end;
  end;
end;

procedure TFrm_Download.edtLocalfileDblClick(Sender: TObject);
Const
	Log_Key = 'edtLocalfileDblClick';
var
  af: TStringDynArray;
  fs: string;
begin
  case edtLocalfile.RightButton.ImageIndex of
    LOCALFILE:
      begin
        af := Tdirectory.GetFiles(Tpath.GetTempPath, '*.zip');
        for fs in af do
        begin
          if fs.Contains(sCodeClient) = True then
          begin
            edtLocalfile.Text := fs;
            pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            sFiletoInstall := fs;
            break;
          end;
        end;
      end;
  end;
end;

procedure TFrm_Download.edtLocalfileExit(Sender: TObject);
Const
	Log_Key = 'edtLocalfileExit';
var
  sFilename: string;
  oMsg: TForm;
begin
  sFilename := edtLocalfile.Text;
  bIsEasy := False;

  if sFilename.IsEmpty = False then
  begin
    case edtLocalfile.RightButton.ImageIndex of
      LOCALFILE:
        begin
          if Tfile.Exists(sFilename) = True then
          begin
            if sFilename.Contains(sCodeClient) = False then
            begin
              oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOk]);
              oMsg.Position := poOwnerFormCenter;
              oMsg.FormStyle := fsStayOnTop;
              oMsg.ShowModal;
              oMsg.Release;
              pnlInstall.Visible := False;
              Exit;
            end;
            sFiletoInstall := sFilename;
            pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            edtLocalfile.Text := sFilename;
            sFiletoInstall := sFilename;
            edtCode.Text := sCodeClient;

            TestIfEasy(sFilename);
          end;
        end;
      URL:
        begin
          if not Tfile.Exists(sFilename) = True then
          begin
            pnlInstall.Visible := False;
          end;
        end;
    end;
  end;
end;

procedure TFrm_Download.edtLocalfileKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Const
	Log_Key = 'edtLocalfileKeyUp';
begin
  if Key = VK_RETURN then
  begin
    edtLocalfileExit(Sender);
  end;
end;

procedure TFrm_Download.edtLocalfileRightButtonClick(Sender: TObject);
Const
	Log_Key = 'edtLocalfileRightButtonClick';
var
  sFilename: string;
  fs: string;
  oMsg: TForm;
begin

  case edtLocalfile.RightButton.ImageIndex of
    LOCALFILE:
      begin
        if IsVistaOrHigher then
        begin
          Openfile.DefaultFolder := Tpath.GetTempPath;
          if Openfile.Execute then
          begin
            sFilename := Openfile.FileName;
            sFiletoInstall := sFilename;
          end;
        end
        else
        begin
          // xp
          OpenFileXP.InitialDir := Tpath.GetTempPath;
          if OpenFileXP.Execute then
            sFilename := OpenFileXP.FileName;
        end;
        if sFilename.IsEmpty = False then
        begin
          if sFilename.Contains(sCodeClient) = False then
          begin
            oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOk]);
            oMsg.Position := poOwnerFormCenter;
            oMsg.FormStyle := fsStayOnTop;
            oMsg.ShowModal;
            oMsg.Release;
          end
          else
          begin
            pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            edtLocalfile.Text := sFilename;
            sFiletoInstall := sFilename;
            edtCode.Text := sCodeClient;

            // on appelle la fonction pour tester si on est sur une base easy
            TestIfEasy(sFilename);
          end;
        end;
      end;
    URL:
      begin
        // download
        if (edtLocalfile.Text <> '') and (edtLocalfile.Text <> 'http://') then
        begin
          sFilename := edtLocalfile.Text;

          if Tfile.Exists(sFilename) = True then
          begin
            if sFilename.Contains(sCodeClient) = False then
            begin
              oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOk]);
              oMsg.Position := poOwnerFormCenter;
              oMsg.FormStyle := fsStayOnTop;
              oMsg.ShowModal;
              oMsg.Release;
              pnlInstall.Visible := False;
              Exit;
            end;
            sFiletoInstall := sFilename;
            pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            edtLocalfile.Text := sFilename;
            sFiletoInstall := sFilename;
            edtCode.Text := sCodeClient;

            // on appelle la fonction  pour tester si on est sur une base easy
            TestIfEasy(sFilename);
          end
          else
          begin

            TLameFileDownloader.SetUrl(sFilename);
            TLameFileDownloader.Progress := ptProgress;
            TLameFileDownloader.AfterDownload := ptAfterDownload;
            TLameFileDownloader.BeforeDownload := ptBeforeDownload;
            TLameFileDownloader.BeforeReset := ptBeforeReset;
            Try
              TLameFileDownloader.Downloadfile(URL);;
            Finally
              btnDownload.Tag := 0;
              lblInfo.Caption := '';
              edtConfirm.ReadOnly := False;
              edtCode.ReadOnly := False;
              pbBar.Position := 0;
              pbBar.Visible := False;
              pbBar.Update;
              Fstop := False;
              // rgRgChoice.Enabled := True;
              ChoixChargementEnable(True);
              btnDownload.Caption := RST_DOWNLOAD;
              pnlLame.Visible := False;
              pnlLame.Update;

              // test si la base téléchargée est sous easy
              TestIfEasy(TLameFileDownloader.LOCALFILE);
            End;
          end;
        end
        else
        begin
          beep;
          beep;
        end;
      END;
    STOP:
      begin
        // arrêt chargement à partir URL
        Fstop := True;
        application.ProcessMessages;
        edtLocalfile.RightButton.ImageIndex := URL;
        edtLocalfile.RightButton.Hint := RST_URLHINT;
        edtLocalfile.ReadOnly := False;
        // Sleep(1000) ;
      end;
  end;
end;

procedure TFrm_Download.edtPathEasyDblClick(Sender: TObject);
Const
	Log_Key = 'edtPathEasyDblClick';
begin
  // on permet la selection des dossiers
  Openfile.Options := [fdoPickFolders];

  // si le chemin du disque est renseigné, on met celui la par défaut pour le choix du dossier
  if (cbbDrive.Text <> '') then
    Openfile.DefaultFolder := IncludeTrailingBackslash(cbbDrive.Text);

  if (Openfile.Execute()) then
  begin
    edtPathEasy.Text := IncludeTrailingBackslash(Openfile.FileName);
    sPathEasy := IncludeTrailingBackslash(edtPathEasy.Text);
  end;

  // on annule la sélection des dossiers
  Openfile.Options := [];
end;

procedure TFrm_Download.edtPathEasyExit(Sender: TObject);
Const
	Log_Key = 'edtPathEasyExit';
begin
  if DirectoryExists(edtPathEasy.Text) then
    sPathEasy := IncludeTrailingBackslash(edtPathEasy.Text)
  else
    sPathEasy := '';
end;

procedure TFrm_Download.edtPathEasyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Const
	Log_Key = 'edtPathEasyKeyUp';
begin
  if Key = VK_RETURN then
  begin
    edtPathEasyExit(Sender);
  end;
end;

procedure TFrm_Download.FormClick(Sender: TObject);
Const
	Log_Key = 'FormClick';
begin
  ModalResult := mrCancel;
end;

procedure TFrm_Download.FormCreate(Sender: TObject);
Const
	Log_Key = 'FormCreate';
var
  af: TStringDynArray;
  fs: string;
  ls: Integer;
begin
  // recherche des partitions installables
  af := Tdirectory.GetLogicalDrives;
  for fs in af do
  begin
    if IsAvalidtype(fs) then
      cbbDrive.Items.Add(fs);
  end;

  aListdesfichierssurlame := Tstringlist.Create;

  // initialisation du fichier log en mode Add
  // Tlogfile.InitLog(False);

  // initialisation de la procedure utilisée par TLameFileDownloader  après chargement
  ptAfterDownload := procedure(Aborted, Error: boolean)
    var
      oMsg: TForm;
    begin
      if Error = True then
      Begin
        Try
          oMsg := CreateMessageDialog(TLameFileDownloader.ErrorMsg, mtError, [mbOk]);
          oMsg.Position := poOwnerFormCenter;
          oMsg.FormStyle := fsStayOnTop;
          oMsg.ShowModal;
        Finally
          FreeAndNil(oMsg);
        End;
      End
      else if (Aborted = False) then
      begin
        sFiletoInstall := TLameFileDownloader.LOCALFILE;
        if edtLocalfile.RightButton.ImageIndex = STOP then
        begin
          // si on a choisi le mode URL
          edtLocalfile.ReadOnly := False;
          edtLocalfile.RightButton.ImageIndex := URL;
          edtLocalfile.RightButton.Hint := RST_URLHINT;
        end;
        pnlInstall.Align := alClient;
        pnlInstall.Visible := True;
      end;

      pbBar.Visible := False;
      pbBar.Position := 0;
      btnOk.Visible := True;
      btnCancel.Visible := True;

    end; // fin de ptAfterdownload

  // initialisation de la procédure de progression utilisée par TlameFileDownloader pendant le chargement
  ptProgress := procedure(Progress, ProgressMax: cardinal; StatusText: string; var cancel: boolean; Pct2Download: Integer)
    var
      iValA, iValC: Integer;
    begin
      pbBar.Max := ProgressMax;
      pbBar.Position := Progress;
      pbBar.Update;
      if Progress > 0 then
      begin
        lblInfo.Caption := StatusText;
        lblInfo.Update;
      end;
      cancel := Fstop;
      // lblEstimated.Caption := RST_RESTEACHARGER + IntToStr(Pct2Download) + ' %';
      if pbBar.Position > 0 then
      begin
        iValA := StrToInt(FormatFloat('#.##', pbBar.Position div 1024));
        iValC := StrToInt(FormatFloat('#.##', pbBar.Max div 1024));
        lblEstimated.Caption := FloatToStr((iValA * 100) div iValC) + '%';
        lblEstimated.Update;
      end;
      application.ProcessMessages;
    end; // fin de ptProgress

  // initialisation de la procedure utilisée par TlameFileDownloader avant le chargement
  ptBeforeDownload := procedure(Mode: Integer)
    begin
      case Mode of
        FROMLAME, URL:
          begin
            btnDownload.Tag := 1;
            btnDownload.Caption := RST_STOP;
            pbBar.Position := 0;
            pbBar.Visible := True;
            pbBar.Update;
            lblInfo.Caption := '';
            lblInfo.Visible := True;
            lblInfo.Update;
            edtConfirm.ReadOnly := True;
            edtConfirm.Update;
            edtCode.ReadOnly := True;
            edtCode.Update;
            // rgRgChoice.Enabled := False;
            ChoixChargementEnable(False);
            // Label2.Caption := '';
            lblEstimated.Visible := True;
            btnOk.Visible := False;
            btnCancel.Visible := False;
            if Mode = URL then
            begin
              edtLocalfile.ReadOnly := True;
              edtLocalfile.RightButton.ImageIndex := STOP;
              edtLocalfile.RightButton.Hint := RST_HINT_STOPDOWNLOAD;
            end;
          end;

      end; // fin de mode

    end; // fin de ptBeforeDownload

  ptBeforeReset := procedure(Mode: Integer; Aborted, Error: boolean)
    begin
      case Mode of
        URL:
          begin
            pbBar.Position := 0;
            pbBar.Visible := True;
            pbBar.Update;
            lblInfo.Caption := '';
            lblInfo.Visible := True;
            lblInfo.Update;
            lblEstimated.Visible := False;
            lblEstimated.Caption := '';
            lblEstimated.Update;
            edtConfirm.ReadOnly := True;
            edtConfirm.Update;
            edtCode.ReadOnly := True;
            edtCode.Update;
            edtLocalfile.ReadOnly := True;
            // rgRgChoice.Enabled := False;
            ChoixChargementEnable(False);
            Fstop := False;
          end;
        FROMLAME:
          begin
            btnDownload.Tag := 0;
            lblInfo.Caption := '';
            edtConfirm.ReadOnly := False;
            edtCode.ReadOnly := False;
            pbBar.Position := 0;
            pbBar.Visible := False;
            pbBar.Update;
            lblEstimated.Visible := False;
            lblEstimated.Caption := '';
            lblEstimated.Update;
            Fstop := False;
            // rgRgChoice.Enabled := True;
            ChoixChargementEnable(True);

            btnDownload.Caption := RST_DOWNLOAD;
            if (Aborted = False) and (Error = False) then
            begin
              Fstop := False;
              pnlLame.Visible := False;
              pnlLame.Update;
            end;
          end;
      end; // fin de case
      btnOk.Visible := True;
      btnCancel.Visible := True;
    end; // fin de ptCleanScreen
end;

procedure TFrm_Download.FormShow(Sender: TObject);
Const
	Log_Key = 'FormShow';
begin
  ChoixChargementEnable(False); // pour activer le choix d'installation Easy par le réseau
end;

procedure TFrm_Download.LoadListFromLame(var aMsg: Tmessage);
Const
	Log_Key = 'LoadListFromLame';
var
  fs, sLame: string;
  ptFilter: TFilter_Perso;
  bOk: boolean;
  oMsg: TForm;
  NbTentative: Integer;
  IniParam: TIniFile;
  Section, IdS, value, sDirIniParam: String;
  ValueSection: Tstringlist;
  I: Integer;
begin
  ptFilter := function(sFile: string): boolean
    begin
      if (sFile.Contains('PORTABLE') = True) or (sFile.Contains('SERVEUR') = True) then
        Exit(True)
      else
        Exit(False);
    end;

  application.ProcessMessages;
  bOk := False;

  try
    sDirIniParam := PChar(ExtractFilePath(ParamStr(0)) + NameFileParam);
    IniParam := TIniFile.Create(sDirIniParam);
    ValueSection := Tstringlist.Create;

    if uFunctions.UsrLogged = UsrISF then
    begin
      Section := 'LAME_ISF';
      IdS := 'SYMR';
    end
    else
    begin
      Section := 'LAME_GINKOIA';
      IdS := 'LAME';
    end;

    if uFunctions.UsrLogged <> '' then
    begin
      IniParam.ReadSection(Section, ValueSection);

      for I := 0 to ValueSection.Count do
      begin
        sLame := IniParam.ReadString(Section, IdS + IntToStr(I + 1), '');
        sLame := EnCryptDeCrypt(sLame);

        lblInfo.Caption := 'Recherche sur ' + sLame + ' en cours ...';
        lblInfo.Update;
        pbBar.Max := ValueSection.Count;
        pbBar.Position := I;
        pbBar.State := pbsPaused;
        pbBar.Update;

        if sLame <> '' then
        begin
          TLameFileParser.SetUrl(sLame);
          TLameFileParser.Filter := ptFilter;
          TLameFileParser.GetFiles('.zip');

          for fs in TLameFileParser.TlistFiles do
          begin
            if fs.Contains(sCodeClient) = True then
            begin
              bOk := True;
              break;
              pbBar.State := pbsNormal;
            end;
          end;

        end;
      end;

      lblInfo.Caption := 'Recherche terminée.';
      lblInfo.Update;
      pbBar.Max := ValueSection.Count;
      pbBar.Position := ValueSection.Count;
      pbBar.Update;
    end
    else
    begin
      // seek everywhere
      NbTentative := 0;

      if (bOk = False) and (NbTentative = 0) then
      begin
        repeat
          if NbTentative = 0 then
          begin
            Section := 'LAME_ISF';
            IdS := 'SYMR';
          end;

          if NbTentative = 1 then
          begin
            Section := 'LAME_GINKOIA';
            IdS := 'LAME';
          end;

          IniParam.ReadSection(Section, ValueSection);

          for I := 0 to ValueSection.Count do
          begin
            sLame := IniParam.ReadString(Section, IdS + IntToStr(I + 1), '');
            sLame := EnCryptDeCrypt(sLame);

            if sLame <> '' then
            begin
              TLameFileParser.SetUrl(sLame);
              TLameFileParser.Filter := ptFilter;
              TLameFileParser.GetFiles('.zip');
              for fs in TLameFileParser.TlistFiles do
              begin
                if fs.Contains(sCodeClient) = True then
                begin
                  bOk := True;
                  Exit;
                end;
              end;
            end;
          end;

          ValueSection.Clear;
          Inc(NbTentative, 1);
        until (NbTentative = 2) or (bOk = True);
      end;

    end;

    if bOk = False then
    begin
      Try
        if TLameFileParser.noFile = False then
        begin
          lblInfo.Caption := '';
          lblInfo.Update;
          pbBar.Max := ValueSection.Count;
          pbBar.Position := 0;
          pbBar.State := pbsNormal;
          pbBar.Update;

          oMsg := CreateMessageDialog(RST_NOCODE + ' (' + sCodeClient + ')', mtError, [mbOk])
        end
        else
        begin
          // pas de fichiers sur la lame problème de connection ?
          lblInfo.Caption := '';
          lblInfo.Update;
          pbBar.Max := ValueSection.Count;
          pbBar.Position := 0;
          pbBar.State := pbsNormal;
          pbBar.Update;

          oMsg := CreateMessageDialog(RST_NOFILE, mtError, [mbOk]);
        end;

        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        oMsg.ShowModal;
      Finally
        FreeAndNil(oMsg);
        pnlLame.Visible := False;
        rgRgChoice.Itemindex := -1;
        edtCode.SetFocus;
      End;
    end;

  finally
    IniParam.Free;
    ValueSection.Free;
  end;
end;

procedure TFrm_Download.ChoixChargementEnable(State: boolean);
Const
	Log_Key = 'ChoixChargementEnable';
begin
  rgRgChoice.Buttons[0].Enabled := State;
  rgRgChoice.Buttons[1].Enabled := State;
  rgRgChoice.Buttons[2].Enabled := State;

end;

procedure TFrm_Download.rgRgChoiceClick(Sender: TObject);
Const
	Log_Key = 'rgRgChoiceClick';
var
  sTemp, sTempPath: string;
  af: TStringDynArray; // pour rechercher le fichier zip
  fs: string; // pour évaluer chacune des valeurs de af
begin
  try
    if (edtCode.Text = '') and (sCodeClient = '') and (rgRgChoice.Itemindex <> 3) then
      Exit;

    Screen.Cursor := crHourGlass;
    sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
    // on sélectionne  la source du fichier
    if edtCode.Text <> '' then
      sCodeClient := edtCode.Text;
    // edtCode.Text := '';
    pnlLame.Visible := False;
    pnlInstall.Visible := False;

    case rgRgChoice.Itemindex of
      0:
        begin
          // lame
          pnlUrl.Visible := False;
          pnlUrl.Update;

          pnlLame.Visible := True;
          pnlLame.Update;

          Postmessage(Handle, WM_LOADLISTFROMLAME, 0, 0);
          edtConfirm.SetFocus;
          application.ProcessMessages;
        end;
      1, 2:
        begin
          // url ou fichier local
          if rgRgChoice.Itemindex = 1 then
          begin
            edtLocalfile.Text := 'http://';
            edtLocalfile.RightButton.ImageIndex := URL;
            edtLocalfile.RightButton.Hint := RST_HINT_DOWNLOAD;
            Label4.Caption := RST_URL;
          end
          else
          begin
            // local file
            edtLocalfile.Text := '';
            sTempPath := Tpath.GetTempPath;
            af := Tdirectory.GetFiles(sTempPath, '*.zip');
            for fs in af do
            begin
              if fs.Contains(sCodeClient) = True then
              begin
                edtLocalfile.Text := fs;
                break;
              end;

            end;
            edtLocalfile.RightButton.ImageIndex := LOCALFILE;
            Label4.Caption := RST_FILE;
            edtLocalfile.RightButton.Hint := RST_HINT_OPENFILE;
          end;
          pnlUrl.Visible := True;
          pnlUrl.Update;
          edtLocalfile.SetFocus;
        end;
      3: // Depuis un serveur sur le réseau
        // Dans ce cas c'est la même installation que pour un portable (sous EASY), seuls les raccourcis changent
        // on utilise donc la Form Server_FRM avec paramètre Caisse secours pour faire l'installation
        begin
          Self.Visible := False;
          Screen.Cursor := crHourGlass;
          application.CreateForm(TFrm_Serveur, Frm_Serveur);
          Frm_Serveur.Align := alClient;
          Frm_Serveur.ManualDock(Frm_Main.PDocksite, nil, alClient);
          Frm_Serveur.Show;
          Frm_Serveur.Parent := Frm_Main;
          Frm_Serveur.InitCaisseSec();
          // FreeAndNil(Frm_Download);
          Postmessage(Handle, WM_CLOSE, 0, 0);
        end;
    end;
  Finally
    Screen.Cursor := crDefault;
  End;
end;

function TFrm_Download.Unzip(aFile: string; aDestPath: string; aPassword: string): boolean;
Const
	Log_Key = 'Unzip';
begin
  Result := False;
  try
    if FileExists(aFile) then
    begin
      pbBar.Max := 100;
      // on remet la progressBar à 0
      UpdateProgress(0);

      lblInfo.Caption := ' Extraction de l''archive en cours';
      lblInfo.Visible := True;

      // la dll est maintenant récupéré dans le form create de la main form
      // sRep := ExtractFilePath(application.ExeName);
      // sDll := '7z.dll';
      //
      // // if Is64bits then
      // // Res := TResourceStream.Create(0,'SevenZip64', RT_RCDATA)
      // // else
      // Res := TResourceStream.Create(0, 'SevenZip32', RT_RCDATA);
      // try
      // Res.SaveToFile(sRep + sDll);
      // finally
      // Res.Free;
      // end;

      StopExtract := False;
      with CreateInArchive(CLSID_CFormatZip) do
      begin
        try
          // Btn_Install.Enabled := False;
          Openfile(aFile);

          if aPassword <> '' then
            SetPassword(aPassword);

          SetProgressCallback(Self, ProgressCallback);

          ExtractTo(aDestPath);
        finally
          Close();
          // on remet la progressbar à 0 après traitement
          UpdateProgress(0);
          // Btn_Install.Enabled := True;
        end;
      end;

      // DeleteFile(sRep + sDll);

      Result := True;
      btnBtn_Install.Caption := RST_INSTALL;
      lblInfo.Caption := '';
      Self.Cursor := crDefault;
      ShowMessage('Dézipage du fichier terminé');
    end;
  Except
    on E: Exception do
    begin
      // impossible de trouver le fichier à dézziper
      raise Exception.Create('Impossible de trouver le fichier à déziper');
    end;
  end;
end;

function TFrm_Download.UnzipWithExe(aFile: string; aDestPath: string; aPassword: string): boolean;
const
  Log_Key = 'Unzip';
var
  Res: TResourceStream;
  sRep, sExe, paramExtract: string;
  execExtract: Integer;
begin
  Result := False;
  try
    if FileExists(aFile) then
    begin
      pbBar.Position := 0;
      pbBar.Max := 100;
      pbBar.Visible := true;
      // on remet la progressBar à 0
      UpdateProgress(0);

      lblInfo.Caption := ' Extraction de l''archive en cours';
      lblInfo.Visible := True;


      // on charge l'exe depuis les resources
      sRep := ExtractFilePath(Application.ExeName);
      sExe := '7za.exe';

      Res := TResourceStream.Create(0, 'SevenZipCmd', RT_RCDATA);
      try
        Res.SaveToFile(sRep + sExe);
      finally
        Res.Free;
      end;


      paramExtract := '7z x "' + aFile + '" -aos -ad -y -o"' + aDestPath + '"';

      if aPassword <> '' then
        paramExtract := paramExtract + ' -p' + aPassword;

      execExtract := ExecuteAndWait(ExtractFilePath(Application.ExeName) + '7za.exe', paramExtract);

      DeleteFile(sRep + sExe);

      lblInfo.Caption := '';

      if (execExtract = 0) or (execExtract = 1) then
        Result := true
      else
      begin
        Result := False;
        raise Exception.Create('Erreur lors de l''extraction du fichier');
      end;

    end
    else
    begin
      // impossible de trouver le fichier à dézziper
      raise Exception.Create('Impossible de trouver le fichier à déziper');
    end;
  except
    on E: Exception do
    begin
      btnBtn_Install.Caption := RST_INSTALL;
      btnBtn_Install.Tag := 0;
       // Log.Log(RST_ZIPSTOPPEDBYUSER, logInfo);
      Log.Log(Log_Mdl, Log_Key, RST_ZIPSTOPPEDBYUSER, logInfo, True, 0, ltBoth);

      if StopExtract = True then
        raise Exception.Create(RST_ZIPSTOPPEDBYUSER)
      else
        raise Exception.Create('UnZipFile -> ' + E.Message);
    end;
  end;
  pbBar.Visible := False;
end;

function ProgressCallback(Sender: Pointer; total: boolean; value: Int64): HRESULT; stdcall;
var
  vPrc: Int64;
begin
  if total then
    Frm_Download.Vzipmax := value
  else
  begin
    if Frm_Download.Vzipmax > 0 then
    begin
      vPrc := Trunc(value * 100 / Frm_Download.Vzipmax);

      // on met à jour tous les 2% d'avancement
      if ((vPrc mod 2 = 0) and (vPrc <> Frm_Download.Vzipvalue)) then
      begin
        UpdateProgress(vPrc);

        Frm_Download.Vzipvalue := vPrc;
      end;
    end;
  end;

  application.ProcessMessages;

  if Frm_Download.StopExtract then
    Result := S_FALSE
  else
    Result := S_OK;
end;

procedure UpdateProgress(aPercent: Integer);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Frm_Download.pbBar.Position := aPercent;
    end);
end;

function TFrm_Download.InstallServeur: boolean;
const
  Log_Key = 'InstallServeur';
var
  sTemp, sPassword: string;
  bSkipfile: boolean;

  bOk: boolean;
  I: Integer;
  ResponseWebService, DateInstall, tmp: string;
  Year, Month, Day: String;

  function ShowMessagesed(sPath: string): boolean;
  var
    oMsg: TForm;
    s, sCode, sVille, sClient: string;
    sf: TArray<System.string>; // utilisation d'un generic de Delphi ;
  begin
    // confirmation de l'installation
    s := Tpath.GetFileNameWithoutExtension(sFiletoInstall);
    sf := s.Split(['_']);
    // on casse le nom du fichier en utilisant le '_' comme séparateur
    if Length(sf) > 1 then
    begin
      sVille := sf[1];
      sCode := sf[2];
      sClient := sf[3];
      s := RST_CONFIRM + #10 + RST_CLIENT + ' ' + sClient + #10 + RST_CODE + ' ' + sCode + #10 + RST_VILLE + ' ' + sVille;
    end
    else
      s := RST_CONFIRM;
    Try
      oMsg := CreateMessageDialog(s, mtConfirmation, [mbYES, mbNo]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      if oMsg.ShowModal = IDYES Then
      begin
        Result := True;
        // Tlogfile.Addline(DateTimeTostr(Now)+' '+RST_CONFIRMED );
        //Log.Log(RST_CONFIRMED, logInfo, 'Install serveur');
        Log.Log(Log_Mdl,Log_Key, RST_CONFIRMED, logInfo, True, 0, ltBoth);
      end
      else
      begin
        Result := False;
        // Tlogfile.Addline('****'+DateTimeToStr(Now)+' '+RST_NOTCONFIRMED );
        //Log.Log(RST_NOTCONFIRMED, logWarning, 'Install serveur');
        Log.Log(Log_Mdl,Log_Key, RST_NOTCONFIRMED, logInfo, True, 0, ltBoth);
      end;
    Finally
      FreeAndNil(oMsg);
    End;

    pbBar.Visible := False;
    pbBar.Update;
    btnBtn_Install.Caption := RST_INSTALL;
    btnBtn_Install.Update;
    lblInfo.Caption := '';
    lblInfo.Visible := False;
    application.ProcessMessages;
    Exit(True);
  end;

begin
  Try
    ForceDirectories(sLocation);
    lblEstimated.Visible := True;
    pbBar.Visible := True;
    pbBar.Position := 0;
    pbBar.Update;
    bRecupBase := False;

    sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
    if Tfile.Exists(sTemp) then
    begin
      Tfile.Delete(sTemp);
    end;

    // Try
    // application.CreateForm(TFrm_Pwd, Frm_Pwd);
    // if Frm_Pwd.ShowModal = mrOk then
    // Begin
    // sPassword := Frm_Pwd.edtpwd.Text;
    // bSkipfile := False;
    // End
    // else
    // bSkipfile := True;
    // Finally
    // Frm_Pwd.Release;
    // Frm_Pwd := nil;
    // End;

    // on passe le mot de passe de l'archive par défaut à présent
    sPassword := '1082';

    // Tlogfile.Addline(DateTimeToStr(Now)+' '+RST_UNZIP );
    //Log.Log(RST_UNZIP, logInfo);
    Log.Log(Log_Mdl,Log_Key, RST_UNZIP, logInfo, True, 0, ltBoth);

    pbBar.Visible := True;
    pbBar.State := pbsNormal;
    pbBar.Max := 4;
    pbBar.Position := 0;
    lblInfo.Caption := '';
    application.ProcessMessages;

    // Appel WebService, uniquement si pas sous easy car sinon on ne peut pas se connecter à la base qui est encore en .split
    // todo : Remettre le bon test quand l'url sera corrigée
    if (UsrLogged = UsrISF) and not(bIsEasy) and (1=0) then
    begin
      bOk := False;
      AlreadyInstall := False;

      pbBar.Position := 0;
      lblInfo.Caption := 'Préparation de l''installation ...';
      application.ProcessMessages;

      // On dézip le fichier dans le dossier temp
      // on ne passe plus par le dossier TMP
      //ForceDirectories(sLocation + '\TMP');
      ForceDirectories(sLocation);
      //Unzip(sFiletoInstall, sLocation + '\TMP', sPassword);


      if not Unzip(sFiletoInstall, sLocation, sPassword) then
        UnzipWithExe(sFiletoInstall, sLocation, sPassword);

      try
        Install := Tinstall.Create(sLocation);

        pbBar.Position := 1;
        lblInfo.Caption := 'Vérification de l''installation ...';
        application.ProcessMessages;

        //if Install.GetUrlWebService(sLocation + '\TMP\DATA\GINKOIA.IB') then
        if Install.GetUrlWebService(sLocation + '\DATA\GINKOIA.IB') then
        begin
          if Install.GetFromWebService(Install.PathWebService, Install.GUIID, UsrLogged, 'GET', ResponseWebService) then
          begin
            // erreur dans l'appel du webservice
            if (ContainsText(ResponseWebService, 'Erreur : ') and (UsrLogged = UsrISF)) then
            begin
              ShowMessage(ResponseWebService + #13#10 + 'Veuillez contacter Ginkoia ..');
              //Log.Log('Erreur webservice : ' + ResponseWebService, logError);
              Log.Log(Log_Mdl,Log_Key, 'Erreur webservice : ' + ResponseWebService, logError, True, 0, ltBoth);
              btnBtn_Install.Enabled := False;
              if UsrLogged = UsrISF then
                bOk := False;
            end;

            if ResponseWebService = '' then
            begin
              ShowMessage('Erreur dans l''appel du webservice');
              //Log.Log('Erreur dans l''appel du webservice' + #13#10 + 'Veuillez contacter Ginkoia ..', logError);
              Log.Log(Log_Mdl,Log_Key, 'Erreur dans l''appel du webservice' + #13#10 + 'Veuillez contacter Ginkoia ..', logError, True, 0, ltBoth);
              btnBtn_Install.Enabled := False;
              if UsrLogged = UsrISF then
                bOk := False;
            end;

            // Déja installé
            if ContainsText(ResponseWebService, '-') then
            begin
              if ((ResponseWebService[5] = '-') and (ResponseWebService[8] = '-')) then
              begin

                Year := Copy(ResponseWebService, 0, 4);
                Month := Copy(ResponseWebService, 6, 2);
                Day := Copy(ResponseWebService, 9, 2);

                DateInstall := Day + '/' + Month + '/' + Year;

                if UsrLogged = UsrISF then
                begin
                  application.ProcessMessages;
                  //Install.DelFilesDir(sLocation + '\TMP');
                  Install.DelFilesDir(sLocation);
                  ShowMessage('Une installation a déjà été effectué le : ' + DateInstall + #13#10 + 'Installation impossible');
                  //Log.Log('Une installation a déjà été effectué le : ' + DateInstall + #13#10 + 'Installation impossible', logInfo);
                  Log.Log(Log_Mdl,Log_Key, 'Une installation a déjà été effectué le : ' + DateInstall + #13#10 + 'Installation impossible', logInfo, True, 0, ltBoth);
                  btnBtn_Install.Enabled := False;
                  AlreadyInstall := True;
                  bOk := False;
                end;
              end;
            end;

            // pas bon
            if Trim(ResponseWebService) <> '0' then
            begin
              //Log.Log('Code de renvoie du webservice <> 0', logError);
              Log.Log(Log_Mdl,Log_Key, 'Code de renvoie du webservice <> 0', logError, True, 0, ltBoth);
              if UsrLogged = UsrISF then
                bOk := False;
            end;

            if Trim(ResponseWebService) = '0' then
            begin
              //Log.Log('Webservice = 0 - Tout est ok ', logInfo);
              Log.Log(Log_Mdl,Log_Key, 'Webservice = 0 - Tout est ok ', logInfo, True, 0, ltBoth);
              // plus necessaire car l'archive est directement décompressée dans le bon répertoire
//              Install.DelFilesDir(sLocation + '\TMP');
//
//              pbBar.Position := 2;
//              lblInfo.Caption := 'Extraction de l''archive ...';
//              application.ProcessMessages;
//
//              Unzip(sFiletoInstall, sLocation, sPassword);
              bOk := True;
            end;

            // if bOk = False then
            // begin
            // Install.Free;
            // Exit;
            // end;

          end;
        end
        else
        begin
          //Log.Log('Webservice = Pas de verification.', logWarning);
          Log.Log(Log_Mdl,Log_Key, 'Webservice = Pas de verification.', logInfo, True, 0, ltBoth);

          pbBar.Position := 2;
          lblInfo.Caption := 'Extraction de l''archive ...';
          application.ProcessMessages;

          Unzip(sFiletoInstall, sLocation, sPassword);
          bOk := True;
        end;

      Except
        on E: Exception do
        begin
          ShowMessage(E.Message);
        end;
      end;
    end
    else
    begin

      pbBar.State := pbsNormal;
      pbBar.Position := 3;
      lblInfo.Caption := 'Extraction de l''archive ...';
      application.ProcessMessages;

      // todo : decommenter
      if not Unzip(sFiletoInstall, sLocation, sPassword) then
        UnzipWithExe(sFiletoInstall, sLocation, sPassword);
      bOk := True;
    end;

    // don't touch il y a une bonne raison a cela
    if UsrLogged = UsrISF then
    begin
      if bOk then
      begin
        Result := True;
        pbBar.Position := 4;
        lblInfo.Caption := 'Terminé';
        lblInfo.Update;
      end
      else
      begin
        Result := False;
      end;
    end
    else
    begin
      Result := True;
      pbBar.Position := 4;
      lblInfo.Caption := 'Terminé';
      lblInfo.Update;
    end;

  Finally
    // Log.
    // if Tlogfile.Count > 0 then
    // begin
    // sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
    // Tlogfile.SaveToFile(sTemp);
    // end;
    //
    if Assigned(Install) then
      FreeAndNil(Install);

    pbBar.Position := 0;
    lblInfo.Caption := '';
    lblInfo.Update;
    lblEstimated.Visible := False;
  End;
end;

end.

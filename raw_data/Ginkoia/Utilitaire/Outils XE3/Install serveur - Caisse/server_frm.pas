unit Server_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.IOUtils, System.Types, System.StrUtils, System.DateUtils, System.Zip,
  // Début Uses Perso
  uFunctions, uParams, uRessourcestr, uSevenZip,
  //uLogfile, ancienne unité de uLog
  uLog, uLameFileparser, uDownloadfromlame, uPatchScript, uInstallbase,
  uBasetest, registry, ShlObj, Informations, IniFiles, SelectRescueC_Frm,
  UPatchDll, uToolsXE,
  // Fin Uses Perso
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, Vcl.CheckLst, System.Generics.Collections,
  FireDAC.UI.Intf, FireDAC.Stan.Async, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Stan.Intf, FireDAC.Comp.Script;

const
  LOCALFILE = 0;
  URL = 1; // id de l'image dans imagelist
  STOP = 2;
  FROMLAME = 3;
  WM_LOADLISTFROMLAME = WM_USER + 101;
  Log_Mdl = 'InstallServerCaissePort';

type
  TFrm_Serveur = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    ItemSubtitle: TLabel;
    pnlLame: TPanel;
    btnDownload: TButton;
    edtConfirm: TEdit;
    Lblconfirmation: TLabel;
    pnlUrl: TPanel;
    edtLocalfile: TButtonedEdit;
    OpenFileXP: TOpenDialog;
    Openfile: TFileOpenDialog;
    Label2: TLabel;
    lblInfo: TLabel;
    pnlInstall: TPanel;
    Btn_Install: TButton;
    cbDrive: TComboBox;
    Label3: TLabel;
    pnlClient: TPanel;
    Label1: TLabel;
    edtCode: TEdit;
    RgChoice: TRadioGroup;
    Label4: TLabel;
    Label5: TLabel;
    lblEstimated: TLabel;
    Panel2: TPanel;
    pnlmag: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    cbMagasin: TComboBox;
    cbPoste: TComboBox;
    Btn_Finalize: TButton;
    chkBasetest: TCheckBox;
    IdHTTP1: TIdHTTP;
    pgBar: TProgressBar;
    Chp_PostePortable: TComboBox;
    Chk_ManuMagSup: TCheckBox;
    Label8: TLabel;
    lbl_ServerPrin: TLabel;
    edt_ServerPrin: TEdit;
    cbbLetterDir: TComboBox;
    lbl_LetterDir: TLabel;
    chk_AddServ: TCheckBox;
    lblEasy: TLabel;
    chkEasy: TCheckBox;
    edtPathEasy: TButtonedEdit;
    pnlEasy: TPanel;
    lblSourcesEasy: TLabel;
    lblDescEasy: TLabel;
    pnlServeurEasy: TPanel;
    lblNomServeur: TLabel;
    cbListeServeur: TComboBox;
    cbLettre: TComboBox;
    lblLettre: TLabel;
    lblD: TLabel;
    PathBaseServerEasy: TEdit;
    BtnConnServEasy: TButton;
    pnlTypeInstallEasy: TPanel;
    rbBaseLocale: TRadioButton;
    rbPosteList: TRadioButton;
    edtPathBaseLocale: TButtonedEdit;
    cbChoixSite: TComboBox;
    cbPosteSecours: TComboBox;
    lblCaisseSec: TLabel;
    lblLang: TLabel;
    imgLang: TImage;
    lblLangName: TLabel;
    pnlProgress: TPanel;
    lblCash: TLabel;
    chkCash: TCheckBox;
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RgChoiceClick(Sender: TObject);
    procedure edtCodeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtLocalfileRightButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtLocalfileDblClick(Sender: TObject);
    procedure cbDriveChange(Sender: TObject);
    function InstallServeur: boolean;
    procedure Btn_InstallClick(Sender: TObject);
    procedure btnFileErrorClick(Sender: TObject);
    procedure mnDeleteErrorFileClick(Sender: TObject);
    procedure LoadListFromLame(var aMsg: Tmessage); message WM_LOADLISTFROMLAME;
    procedure edtConfirmChange(Sender: TObject);

{$REGION 'Documentation'}
    /// <summary>
    /// Chargement du fichier zip à partir de la lame.
    /// </summary>
    /// <remarks>
    /// <para>
    /// Si plusieurs fichiers pour un même client sont disponibles une
    /// liste de sélection est affichée pour sélectionner le fichier à
    /// installer.
    /// </para>
    /// </remarks>
    /// <seealso cref="uLameFileParser|TLameFileParser">
    /// Classe d'analyse des fichiers sur la lame TLameFileParser
    /// </seealso>
{$ENDREGION}
    procedure btnDownloadClick(Sender: TObject);
    procedure Btn_FinalizeClick(Sender: TObject);
    procedure edtCodeExit(Sender: TObject);
    procedure edtCodeEnter(Sender: TObject);
    procedure edtLocalfileExit(Sender: TObject);
    procedure edtLocalfileKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbMagasinChange(Sender: TObject);
    procedure cbPosteChange(Sender: TObject);
    procedure InitPortable(bIsLaptop: boolean = False);
    procedure Chp_PostePortableDrawItem(Control: TWinControl; Index: integer; Rect: TRect; State: TOwnerDrawState);
    procedure Chp_PostePortableSelect(Sender: TObject);
    procedure Chk_ManuMagSupClick(Sender: TObject);
    procedure InitGestion(bIsGestion: boolean = False);
    procedure edt_ServerPrinChange(Sender: TObject);
    procedure cbbLetterDirChange(Sender: TObject);
    procedure edtPathEasyClick(Sender: TObject);
    procedure edtPathEasyExit(Sender: TObject);
    procedure edtPathEasyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnConnServEasyClick(Sender: TObject);
    procedure cbListeServeurChange(Sender: TObject);
    procedure cbLettreChange(Sender: TObject);
    procedure PathBaseServerEasyChange(Sender: TObject);
    procedure edtPathBaseLocaleRightButtonClick(Sender: TObject);
    procedure cbChoixSiteChange(Sender: TObject);
    procedure rbBaseLocaleClick(Sender: TObject);
    procedure rbPosteListClick(Sender: TObject);
    procedure InitCaisseSec;
  private
    { Déclarations privées }
    Install: Tinstall;
    ListBases: TObjectList<TObject>;
    ptAddShop: TAddShop;
    ptAddPoste: TAddPoste;
    ptAddPosteSEC: TAddPoste;

    // partie zip
    Vzipmax, Vzipvalue: Int64;
    VDateBaseSynchro: TdateTime; //
    StopExtract: boolean; // variable globale pour stopper le processus d'extraction

    sCodeClient, sLocation, sFiletoInstall, sPathEasy: string;
    bIsEasy: boolean; // pour les différentes étapes pour savoir si on est sur une installation sous easy
    bIsFromServer: boolean;
    FTransaction: boolean; // pour éviter une catastrophe
    aListdesfichierssurlame: Tstringlist;
    Fstop: boolean;
    ptAfterDownload: TAfterDownload;
    ptBeforeDownload: TBeforeDownload;
    ptProgress: TDisplayprogress;
    ptBeforeReset: TBeforeReset;
    bRecupBase: boolean;
    bIsPortable: boolean;
    bSelection: array of boolean;
    bRescueC: boolean;
    LstServSup: Tstringlist;
    AlreadyInstall: boolean;
    Res: TResourceStream;

    // variables pour l'inslattion d'easy portable ou caisse-sec via un serveur réseau
    sServeurPathGinkoia: string;
    sServeurConnexionPath: string;
    bServeurToto: boolean;
    function Unzip(aFile: string; aDestPath: string; aPassword: string; forceMessage: boolean = true): boolean;
    procedure ValidInstall;
    function AddLauncherToRegistry: boolean;
    // procedure CleanRegistryDelos;
    procedure TestIfEasy(aFileToTest: string);
    procedure EnabledDisableConnexion;
    procedure ChoixChargementEnable(State: boolean);
    function checkParamsFromServer: boolean;
    function checkParamsFromLocal: boolean;
    function CreateBat(aApplication: string): boolean;
    function UnzipWithExe(aFile, aDestPath, aPassword: string): boolean;
  public
    { Déclarations publiques }
    procedure EnumNetworkProc(const aNetResource: TNetResource; const aLevel: Word; var aContinue: boolean);
  end;

function ProgressCallback(Sender: Pointer; total: boolean; value: Int64): HRESULT; stdcall;

procedure UpdateProgress(aPercent: integer);

var
  Frm_Serveur: TFrm_Serveur;

implementation

uses
  Main_Dm, Main_Frm, Pwd_Frm, Basetestfromserver_Frm, SelectFile_Frm,
  Codeuser_Frm, Paramlame_Frm, AddServeur_Frm, SelectCaisseSecours_Frm,
  ProgressBar_Frm, ServicesInstall_Frm;

{$R *.dfm}

procedure TFrm_Serveur.btnFileErrorClick(Sender: TObject);
var
  sTemp: string;
begin
  sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
end;

function TFrm_Serveur.CreateBat(aApplication: string): boolean;
const
  Log_Key = 'CreateBat';
var
  tmp: Tstringlist;
  sFile, VserverEasy: string;
  i, sNb: integer;
  Res, Res_Icon: TResourceStream;
  sRep, sBat, sIcon, sNameServ: string;
begin
  Result := True;
  tmp := Tstringlist.Create;
  try
    try
      VserverEasy := StringReplace(StringReplace(cbListeServeur.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase]);

      if cbListeServeur.Text <> '' then
        sFile := '\\' + VserverEasy + '\ginkoia\Batch\' + sBat
      else
        sFile := cbDrive.Text[1] + ':\ginkoia\Batch\' + sBat;

      if Tfile.Exists(sFile) = False then
      begin
        sRep := ExtractFilePath(Application.ExeName);
        sBat := 'MODEL.BAT';

        if sRep[length(sRep)] <> '\' then
          sRep := sRep + '\';

        Res := TResourceStream.Create(0, 'MODEL', RT_RCDATA);
        try
          Res.SaveToFile(sRep + sBat);
        finally
          Res.Free;
        end;
        tmp.LoadFromFile(sRep + sBat);
      end
      else
      begin
        tmp.LoadFromFile(sFile);
      end;

      for i := 0 to tmp.Count - 1 do
      begin
        tmp.Strings[i] := StringReplace(tmp.Strings[i], '%SERVEUR%', VserverEasy, [rfReplaceAll, rfIgnoreCase]);
        tmp.Strings[i] := StringReplace(tmp.Strings[i], '%LOCAL%', cbDrive.Text[1] + ':\GINKOIA', [rfReplaceAll, rfIgnoreCase]);
        tmp.Strings[i] := StringReplace(tmp.Strings[i], '%PROG%', cbDrive.Text[1] + ':\GINKOIA\' + aApplication, [rfReplaceAll, rfIgnoreCase]);
      end;
    finally

      sNameServ := '\\' + Trim(VserverEasy);

      if aApplication = GINKOIA then
      begin
        tmp.SaveToFile('\\' + VserverEasy + '\ginkoia\Batch\Ginkoia' + cbDrive.Text[1] + '.BAT');

        if uFunctions.UsrLogged = 'Nosymag' then
        begin
           // Log.Log('sNameServ = ' + sNameServ, logInfo);
          Log.Log(Log_Mdl, Log_Key, 'sNameServ = ' + sNameServ, logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Nosymag', sNameServ + '\' + cbLettre.Text + '\ginkoia\Batch\Ginkoia' + cbDrive.Text[1] + '.BAT', 'Nosymag', cbDrive.Text[1] + ':\GINKOIA\', cbDrive.Text[1] + ':\GINKOIA\' + GINKOIA);

        end
        else
        begin
           // Log.Log('sNameServ = ' + sNameServ, logInfo);
          Log.Log(Log_Mdl, Log_Key, 'sNameServ = ' + sNameServ, logInfo, True, 0, ltBoth);
           // Log.Log('Creation du raccourci Ginkoia', logInfo);
          Log.Log(Log_Mdl, Log_Key, 'Creation du raccourci Ginkoia', logInfo, True, 0, ltBoth);
           // Log.Log(' edGinkoia = ' + cbDrive.Text[1], logInfo);
          Log.Log(Log_Mdl, Log_Key, ' edGinkoia = ' + cbDrive.Text[1], logInfo, True, 0, ltBoth);
           // Log.Log(' cbLettre = ' + cbLettre.Text, logInfo);
          Log.Log(Log_Mdl, Log_Key, ' cbLettre = ' + cbLettre.Text, logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Ginkoia', sNameServ + '\' + cbLettre.Text + '\ginkoia\Batch\Ginkoia' + cbDrive.Text[1] + '.BAT', 'Ginkoia', cbDrive.Text[1] + ':\GINKOIA\', cbDrive.Text[1] + ':\GINKOIA\' + GINKOIA);

        end;

      end;

      if aApplication = CAISSESECOUR then
      begin
        if Tfile.Exists(sFile) = False then
        begin
          sRep := ExtractFilePath(Application.ExeName);
          sBat := 'MODEL.BAT';
          sIcon := 'Icon_CaisseSecours.ICO';

          if sRep[length(sRep)] <> '\' then
            sRep := sRep + '\';

          Res := TResourceStream.Create(0, 'MODEL', RT_RCDATA);
          Res_Icon := TResourceStream.Create(HInstance, 'Icon_CaisseSecours', RT_RCDATA);

          try
            Res.SaveToFile(sRep + sBat);
            // Res_Icon.SaveToFile(sRep + sIcon);
            Res_Icon.SaveToFile(cbDrive.Text[1] + ':\GINKOIA\' + sIcon);
          finally
            Res_Icon.Free;
            Res.Free;
          end;
          tmp.LoadFromFile(sRep + sBat);
        end
        else
        begin
          tmp.LoadFromFile(sFile);
        end;

        // Install.Machine.CreateShortcut( 'Caisse de secours',
        // cbDrive.Text[1] + ':\ginkoia\CAISSEGINKOIA.exe',
        // 'Caisse',
        // cbDrive.Text[1]+':\GINKOIA\', sRep + sIcon);

        Install.Machine.CreateShortcut('Caisse de secours', cbDrive.Text[1] + ':\ginkoia\CAISSEGINKOIA.exe', 'Caisse', cbDrive.Text[1] + ':\GINKOIA\', cbDrive.Text[1] + ':\GINKOIA\' + sIcon);
         // Log.Log('Creation du raccourci caisse de secours', logInfo);
        Log.Log(Log_Mdl, Log_Key, 'Creation du raccourci caisse de secours', logInfo, True, 0, ltBoth);
      end;

      if aApplication = CAISSE then
      begin
        tmp.SaveToFile('\\' + VserverEasy + '\ginkoia\Batch\Caisse' + cbDrive.Text[1] + '.BAT');

         // Log.Log('Creation du raccourci caisse Ginkoia', logInfo);
        Log.Log(Log_Mdl, Log_Key, 'Creation du raccourci caisse Ginkoia', logInfo, True, 0, ltBoth);
         // Log.Log('edtGinkoia = ' + cbDrive.Text[1] + ':\GINKOIA\', logInfo);
        Log.Log(Log_Mdl, Log_Key, 'edtGinkoia = ' + cbDrive.Text[1] + ':\GINKOIA\', logInfo, True, 0, ltBoth);
         // Log.Log('cbLettre = ' + cbLettre.Text, logInfo);
        Log.Log(Log_Mdl, Log_Key, 'cbLettre = ' + cbLettre.Text, logInfo, True, 0, ltBoth);
        Install.Machine.CreateShortcut('Caisse', sNameServ + '\' + cbLettre.Text + '\ginkoia\Batch\Caisse' + cbDrive.Text[1] + '.BAT', 'Caisse', cbDrive.Text[1] + ':\GINKOIA\', cbDrive.Text[1] + ':\GINKOIA\' + CAISSE);

      end;

      if aApplication = LAUNCHER then
      begin
        if bIsEasy then
        begin
           // Log.Log('Creation du raccourci Launcher Easy', logInfo);
          Log.Log(Log_Mdl, Log_Key, 'Creation du raccourci Launcher Easy', logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Synchronisation', cbDrive.Text[1] + ':\ginkoia\' + LAUNCHEREASY, 'Synchronisation', cbDrive.Text[1] + ':\GINKOIA\', cbDrive.Text[1] + ':\GINKOIA\' + LAUNCHEREASY);
        end
        else
        begin
           // Log.Log('Creation du raccourci Launcher', logInfo);
          Log.Log(Log_Mdl, Log_Key, 'Creation du raccourci Launcher', logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Launcher', cbDrive.Text[1] + ':\ginkoia\LAUNCHV7.exe', 'Launcher', cbDrive.Text[1] + ':\GINKOIA\', cbDrive.Text[1] + ':\GINKOIA\' + LAUNCHER);
        end;
      end;

      tmp.Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Erreur lors de la création du fichier batch : ' + E.Message);
       // Log.Log('Erreur lors de la création du fichier batch : ' + E.Message);
      Log.Log(Log_Mdl, Log_Key, 'Erreur lors de la création du fichier batch : ' + E.Message, logInfo, True, 0, ltBoth);
      exit;
    end;
  end;
end;

procedure TFrm_Serveur.Btn_FinalizeClick(Sender: TObject);
const
  Log_Key = 'Btn_FinalizeClick';
var
  oInstall: Tinstall;
  sMagasin, sPoste, sMagPostPb, sNomServeur, sDirDesktop, sDirServeur, backupName, PathBaseServer: string;
  i: integer;
  SelectionMag: array of string;
  Registre: TRegistry;
  oMsg, oRescueC: TForm;
  tmp: string;
  LineServ: Tstringlist;
  ResponseWebService: string;
  bOk, bCash: boolean;
  TypeInstall: TTypeInstall;
  aGenParam: TGenParam;
  vMagid, vPosID: Integer;
  vGuid: String;
begin
  aGenParam.prm_string := '';
  aGenParam.prm_integer := 0;

  // si c'est une installation de CASH
  bCash := chkCash.Checked;

  // For check if we should add servers
  if chk_AddServ.Checked then
  begin
    try
      Application.CreateForm(TFrm_AddServer, Frm_AddServer);
      Frm_AddServer.Position := TPosition.poMainFormCenter;
      Frm_AddServer.initList;
      Frm_AddServer.FormStyle := fsStayOnTop;

      if Frm_AddServer.ShowModal = IDYES then
      begin
        //
        if Assigned(Frm_AddServer.ListServ) then
          LstServSup := Frm_AddServer.ListServ;
      end;
    finally
      //
    end;

    if Assigned(Frm_AddServer.ListServ) then
      LstServSup := Frm_AddServer.ListServ;

    Frm_AddServer.Release;
    Frm_AddServer := nil;
  end;

  oInstall := Tinstall.Create(sLocation);
  try
    sMagasin := cbMagasin.Text;
    sPoste := cbPoste.Text;
  
    // si on a choisi cash, on met à jour les GENPARAM du poste par défaut et du type de caisse par défaut
    if bCash then
    begin
      vMagid := Integer(cbMagasin.Items.Objects[cbMagasin.Itemindex]);
      vPosID := Integer(cbPoste.Items.Objects[cbPoste.Itemindex]);

      // caisse par défaut
      aGenParam.prm_string := 'cash';
      oInstall.SetGENPARAM(666, 205, vMagid, vPosID, aGenParam);

      // Renseigner le poste utilisé (pour ne pas le demander lors du premier lancement de CASH)
      vGuid := Install.GetGENPARAM(666, 120, PRM_STRING);
      aGenParam.prm_string := getMachineGuid;
      aGenParam.prm_integer := Install.GetBasIdFromMagID(vMagid);
      if aGenParam.prm_integer = 0 then  // on a pas trouvé le bas_id
      begin
        Showmessage('Impossible de trouver l''identifiant de base du poste.');
      end;
      if bOk then

      if (vGuid <> '') and (aGenParam.prm_integer > 0) then
      begin
         try
          oMsg := CreateMessageDialog('Attention, l''association entre le poste ' + cbPoste.Text + ' et une machine physique existe déjà.' + #13#10 + ' Voulez vous la remplacer ?', mtWarning, [mbYES, mbNo]);
          oMsg.Position := poOwnerFormCenter;
          oMsg.FormStyle := fsStayOnTop;
          oMsg.ShowModal;
          if (oMsg.ModalResult = ID_YES) then
          begin
            Log.Log(Log_Mdl, Log_Key, 'Remplacement de l''association poste / machine physique pour le poste ' + cbPoste.Text, logInfo, True, 0, ltBoth);
            oInstall.SetGENPARAM(666, 120, vMagid, vPosID, aGenParam);
          end;
        finally
          oMsg.Release
        end;
      end
      else
        oInstall.SetGENPARAM(666, 120, vMagid, vPosID, aGenParam);
    end;


    if chkBasetest.Checked then
    begin
      // création de la base test
      try
        Application.CreateForm(TFrm_Basetestfromserver, Frm_Basetestfromserver);
        Frm_Basetestfromserver.SetBase(cbDrive.Text + 'ginkoia\Data\Ginkoia.ib');
        // Tlogfile.Addline(RST_BASETEST);
         // Log.Log(RST_BASETEST, logInfo);
        Log.Log(Log_Mdl, Log_Key, RST_BASETEST, logInfo, True, 0, ltBoth);
        Frm_Basetestfromserver.btnInstallClick(Sender);
        // Tlogfile.Addline(RST_BASETEST);
         // Log.Log(RST_BASETEST, logInfo);
        Log.Log(Log_Mdl, Log_Key, RST_BASETEST, logInfo, True, 0, ltBoth);
        // le chemin de la base test
        oInstall.PathBasetest := Tpath.GetDirectoryName(TbaseTest.Destination);
      finally
        Frm_Basetestfromserver.Release;
        Frm_Basetestfromserver := nil;
      end;
    end;

    // test si les ports sont ouvers pour cash


    // ***************************************************
    // Partie pour l'installation automatique des services
    // ***************************************************
    if bIsPortable then
      TypeInstall := InstallTypePortable
    else if bRescueC then
      TypeInstall := InstallTypeCaisseSec
    else
      TypeInstall := InstallTypeServeur;

    Application.CreateForm(TFrmServicesInstall, Frm_ServicesInstall);
    Frm_ServicesInstall.Position := TPosition.poMainFormCenter;
    Frm_ServicesInstall.FormStyle := fsStayOnTop;
    Frm_ServicesInstall.TypeInstall := TypeInstall;
    Frm_ServicesInstall.PathGinkoia := cbDrive.Text + 'ginkoia\';
    Frm_ServicesInstall.ListModules := oInstall.GetModules();

    Frm_ServicesInstall.ShowModal;

    Frm_ServicesInstall.Release;
    Frm_ServicesInstall := Nil;
    // *************************************************************
    // ** Fin Partie pour l'installation automatique des services **
    // *************************************************************

    // ******************* gestion de la langue ********************
    oInstall.SetLanguage;

    // Update the install patch
     // Log.Log('Préparation mise à jour Path', logInfo);
    Log.Log(Log_Mdl, Log_Key, 'Préparation mise à jour Path', logInfo, True, 0, ltBoth);
    tmp := cbDrive.Text;

    if Install.UpdatePatchInstall(tmp[1], cbDrive.Text + 'ginkoia\Data\Ginkoia.ib', cbMagasin.Text) then
       // Log.Log('Mise à jour du chemin d''install de la base de données', logInfo)
      Log.Log(Log_Mdl, Log_Key, 'Mise à jour du chemin d''install de la base de données', logInfo, True, 0, ltBoth)
    else
       // Log.Log('Erreur dans la mise a jour du path de ginkoia', logInfo);
      Log.Log(Log_Mdl, Log_Key, 'Erreur dans la mise a jour du path de ginkoia', logInfo, True, 0, ltBoth);

    // precision install portable ou non
    if (bIsPortable) then
    begin

      SetLength(SelectionMag, 0);
      for i := Low(bSelection) to High(bSelection) do
      begin
        if bSelection[i] then
        begin
          SetLength(SelectionMag, length(SelectionMag) + 1);
          SelectionMag[length(SelectionMag) - 1] := Chp_PostePortable.Items[i];
        end;
      end;
      sMagPostPb := oInstall.PosteExist(sPoste, SelectionMag);

      if sMagPostPb <> '' then
        ShowMessage('Le(s) magasin(s) suivant(s) : ' + sMagPostPb + ' ,ne contienne(nt) pas le poste : ' + sPoste + ' . Des erreurs de connection peuvent apparaitre, veuillez contacter le service admin base.');

      if bIsPortable then
      begin
        if Assigned(LstServSup) then
          oInstall.CreateIniPortable(sMagasin, sPoste, edt_ServerPrin.Text, cbbLetterDir.Text, SelectionMag, LstServSup)
        else
          oInstall.CreateIniPortable(sMagasin, sPoste, edt_ServerPrin.Text, cbbLetterDir.Text, SelectionMag);
      end;
    end
    else if not bRescueC then
    begin
      oInstall.CreateIniServeur(sMagasin, sPoste);
    end;

    TPatchScript.DirGinkoia := IncludeTrailingBackslash(cbDrive.Text) + 'Ginkoia';
    TPatchScript.Dirbase := IncludeTrailingBackslash(TPatchScript.DirGinkoia) + 'Data';
    // TpatchScript.OpenBase;
  finally

    // si c'est une caisse de secours, on créé les bats et raccourcis différemment
    if bRescueC then
    begin
      Log.Log(Log_Mdl, Log_Key, 'Création des bats et ini de la caisse de secours', logInfo, True, 0, ltBoth);

      // création de l'ini
      PathBaseServer := StringReplace(StringReplace(cbListeServeur.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase]) + ':' + cbLettre.Text + ':' + '\Ginkoia\data\GINKOIA.IB';

      oInstall.CreateIniCaisseSecours(cbDrive.Text[1], cbDrive.Text + 'ginkoia\Data\Ginkoia.ib', PathBaseServer, cbMagasin.Text, cbPoste.Text, cbPosteSecours.Text, cbDrive.Text + 'GINKOIA\DATA\GINKOIA.IB', bRescueC);

      if CreateBat(GINKOIA) then
        bOk := True;

      if bOk then
        bOk := CreateBat(GINKOIA);

      if bOk then
        bOk := CreateBat(CAISSE);

      if bOk then
        bOk := CreateBat(CAISSESECOUR);

      if bOk then
        CreateBat(LAUNCHER);
    end
    else
    begin
      // si on est sur easy, on fait un raccourci pour le launcher Easy à la place
      if bIsEasy then
      begin
        Install.Machine.CreateShortcut('Synchronisation', cbDrive.Text + 'ginkoia\' + LAUNCHEREASY, 'Synchronisation', cbDrive.Text + 'ginkoia\', cbDrive.Text + 'ginkoia\' + LAUNCHEREASY);
        // on ajoute le démarrage automatique dans le registre
        AddLauncherToRegistry();
      end
      else
        Install.Machine.CreateShortcut('Launcher', cbDrive.Text + 'ginkoia\' + LAUNCHER, 'Launcher', cbDrive.Text + 'ginkoia\', cbDrive.Text + 'ginkoia\' + LAUNCHER);

      // création des icones pour chaque ligne coché, si mode portable
      if bIsPortable then
      begin
        // on ouvre le registre, récupération du chemin du bureau
        Registre := TRegistry.Create;
        with Registre do
        begin
          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('Software\Microsoft\Windows\CurrentVersion\', False);
          sDirDesktop := ReadString('DeskTop') + '\';
        end;

        if not (Chk_ManuMagSup.Checked) then
        begin
          // Si on n'est pas en saisie manuel
          for i := Low(SelectionMag) to High(SelectionMag) do
          begin
            sNomServeur := Install.GetNameServ(SelectionMag[i]);
            sDirServeur := Install.GetDirServ(SelectionMag[i]);

            sDirServeur := sDirServeur[1];
            if UpperCase(sDirServeur) = 'D' then
            begin
              Install.Machine.CreateShortcut('GinkoiaD ' + SelectionMag[i], sNomServeur + 'Batch\' + GINKOIABatD, 'GinkoiaD ', sDirDesktop, cbDrive.Text + 'ginkoia\' + GINKOIA);
            end;

            if UpperCase(sDirServeur) = 'C' then
            begin
              Install.Machine.CreateShortcut('Ginkoia ' + SelectionMag[i], sNomServeur + 'Batch\' + GINKOIABat, 'Ginkoia ', sDirDesktop, cbDrive.Text + 'ginkoia\' + GINKOIA);
            end;
          end;
        end
        else
        begin
          // On est on saisie manuel
          // sDirServeur := sDirServeur[1];
          // if UpperCase(sDirServeur) = 'D' then
          // begin
          // Install.Machine.CreateShortcut( 'GinkoiaD '+ Edt_MagSupManuel.Text,
          // sNomServeur + 'Batch\' + GINKOIABatD,
          // 'GinkoiaD ',
          // sDirDesktop,
          // cbDrive.Text + 'ginkoia\' + GINKOIA);
          // end;
          //
          // if UpperCase(sDirServeur) = 'C' then
          // begin
          // Install.Machine.CreateShortcut( 'Ginkoia '+ Edt_MagSupManuel.Text,
          // sNomServeur + 'Batch\' + GINKOIABat,
          // 'Ginkoia ',
          // sDirDesktop,
          // cbDrive.Text + 'ginkoia\' + GINKOIA);
          // end;
        end;
        // TpatchScript.CloseBase;
      end;

      // on créé les raccourcis pour La caisse et Ginkoia, chemin en fonction de si on déploi une caisse sec ou pas

      if uFunctions.UsrLogged = 'Nosymag' then
      begin
        Install.Machine.CreateShortcut('Nosymag', cbDrive.Text + 'ginkoia\' + GINKOIA, 'Nosymag', cbDrive.Text + 'ginkoia\', cbDrive.Text + 'ginkoia\' + GINKOIA);
      end
      else
      begin
        Install.Machine.CreateShortcut('Ginkoia', cbDrive.Text + 'ginkoia\' + GINKOIA, 'Ginkoia', cbDrive.Text + 'ginkoia\', cbDrive.Text + 'ginkoia\' + GINKOIA);
      end;

      // raccourcis pour Cash
      if bCash then
      begin
        Install.Machine.CreateRaccourciAndIniCASH(cbDrive.Text + 'ginkoia\', TypeServeur, 'localhost', '');
      end
      else
        Install.Machine.CreateShortcut('Caisse', cbDrive.Text + 'ginkoia\' + CAISSE, 'Caisse', cbDrive.Text + 'ginkoia\', cbDrive.Text + 'ginkoia\' + CAISSE);

      // end;
    end;

    // install path directory update (EAI, pas dans le cas de Easy)
    if not bIsEasy then
      Param.XmlSetLetterDir(cbDrive.Text);

    // Inscription de la date d'installation
     // Log.Log('Fin Création des fichiers bats et raccourcis', logInfo);
    Log.Log(Log_Mdl, Log_Key, 'Fin Création des fichiers bats et raccourcis', logInfo, True, 0, ltBoth);
    Install.GetUrlWebService(cbDrive.Text + 'GINKOIA\DATA\GINKOIA.IB');
    Install.GetFromWebService(Install.PathWebService, Install.GUIID, UsrLogged, 'GET', ResponseWebService);
     // Log.Log(' WEBSERVICE : ' + ResponseWebService, logError);
    Log.Log(Log_Mdl, Log_Key, ' WEBSERVICE : ' + ResponseWebService, logError, True, 0, ltBoth);

    // installation ok -
    if Trim(ResponseWebService) = '0' then
    begin
      if Install.SetFromWebService(Install.PathWebService, Install.GUIID, UsrLogged, 'SET', ResponseWebService) then
      begin
        if ResponseWebService = 'Ok' then
        begin
          ShowMessage('WEBSERVICE OK');
           // Log.Log('Date d''installation enregistrer sur maintenance', logInfo);
          Log.Log(Log_Mdl, Log_Key, 'Date d''installation enregistrer sur maintenance', logInfo, True, 0, ltBoth);
        end
        else
        begin
           // Log.Log('Erreur dans l''enregistrement de la date install - WEBSERVICE', logError);
          Log.Log(Log_Mdl, Log_Key, 'Erreur dans l''enregistrement de la date install - WEBSERVICE', logError, True, 0, ltBoth);
        end;
      end;
    end;

    // Verification de la version d'interbase
    VerifDll(True);

    // Lancement de vérification.exe

    lblInfo.Caption := 'Attente pour lancement de vérification';
    lblInfo.Visible := True;
    Application.ProcessMessages;

    for i := 0 to 5 do
    begin
      lblInfo.Caption := 'Lancement de verification dans ' + IntToStr(60 - (i * 10)) + ' secondes';
      Application.ProcessMessages;

      Sleep(10000);
    end;

    lblInfo.Caption := 'Lancement de verification';
    Application.ProcessMessages;

    Log.Log(Log_Mdl, Log_Key, 'Lancement de verification.exe', logInfo, True, 0, ltBoth);
    LunchVerif(True);

    FreeAndNil(oInstall);

    // Delete zip file
    // si l'utilisateur connecté est nosymag, on demande s'il veut supprimer le fichier d'installation
    if (UsrLogged = UsrISF) and (not bIsFromServer) then
    begin
      if UPatchDll.FileInstallBase <> '' then
      begin
        oMsg := CreateMessageDialog('Voulez-vous supprimer le fichier d''installation ?', mtConfirmation, [mbYES, mbNo]);
        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        if oMsg.ShowModal = IDYES then
        begin
          Log.Log(Log_Mdl, Log_Key, 'Suppression du fichier d''installation', logInfo, True, 0, ltBoth);
          UPatchDll.DelAppli(UPatchDll.FileInstallBase);
        end;
        oMsg.Release;
      end;
    end;

    // Si l'installation s'est bien passée, on propose de supprimer l'ancienne base locale si c'est un remplacement
    if rbBaseLocale.Checked then
    begin
      try
        oMsg := CreateMessageDialog(RST_EASY_DELETE_BASE_LOCALE, mtWarning, [mbYES, mbNo]);
        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        oMsg.ShowModal;
        if (oMsg.ModalResult = ID_YES) then
        begin
          // suppression de la base de backup
          Log.Log(Log_Mdl, Log_Key, 'Suppression de la base de backup', logInfo, True, 0, ltBoth);
          backupName := ChangeFileExt(edtPathBaseLocale.Text, '') + '_backup' + ExtractFileExt(edtPathBaseLocale.Text);
          if FileExists(backupName) then
            if not DeleteFile(backupName) then
              ErrorMsg('Impossible de supprimer le backup de l''ancienne base')
        end;
      finally
        oMsg.Release
      end;
    end
    else
    begin
      Log.Log(Log_Mdl, Log_Key, 'Installation terminée avec succès', logInfo, True, 0, ltBoth);
      ShowMessage('Installation terminée avec succès.');
    end;

    if Assigned(Install) then
      FreeAndNil(Install);

    // On revient à l'écran princpal
    Btn_Install.Caption := RST_INSTALL;
    Btn_Install.Tag := 0;
    Image1Click(Sender);

    Frm_Main.Tag := 0;
  end;
end;

function TFrm_Serveur.checkParamsFromLocal(): boolean;
var
  InstallLocal: Tinstall;
  test: string;
begin
  Result := False;

  // on commence par faire un restart de la base au cas ou elle soit shutdown, on ne se connecte pas en sysdba car on veut que être sur qu'il n'y ait plus de connexion active pour la remplacer
  if FileExists(edtPathBaseLocale.Text) then
    RestartDatabase(edtPathBaseLocale.Text);

  InstallLocal := Tinstall.Create(edtPathBaseLocale.Text);
  try
    InstallLocal.Connexion := ExcludeTrailingPathDelimiter(edtPathBaseLocale.Text);
    InstallLocal.OpenServeur();

    if InstallLocal.Database.Error <> '' then
    begin
      ErrorMsg('Impossible de se connecter à la base de données locale, vérifiez le chemin de connexion');
      exit;
    end;

    // test si la base est sous Easy
    if InstallLocal.IsEasy() then
    begin
      ErrorMsg('Erreur : La base locale est déjà sous Easy');
      exit;
    end;

    // récupération du base sender dans le Tinstall pour vérification s'il est bien présent dans la base distante
    if not InstallLocal.SetBaseSenderFromDatabase then
    begin
      ErrorMsg('Impossible de récupérer l''identifiant de la base de données locale');
      exit;
    end;

    // on affecte le basesenderselected au Tinstall en cours
    Install.BaseSenderSelected := InstallLocal.BaseSenderSelected;

  finally
    FreeAndNil(InstallLocal);
  end;

  Result := True;
end;

function TFrm_Serveur.checkParamsFromServer(): boolean;
const
  Log_Key = 'checkParamsFromServer';
var
  VserverEasy, VConnexionPath, PathBase: string;
  InstallCheck: Tinstall;
begin
  // on vérifie que les champs sont bons, que la base toto est trouvable sur le réseau
  // et que les choix sont disponibles dans celle-ci
  Result := False;

  // On prends toujours la GinkCopy à présent, plus de vérification de la toto
  //bServeurToto := False;
  PathBase := PathBaseServerEasy.Text;

  // on se connecte sur la base du serveur à partir duquel on va faire l'installation
  VserverEasy := StringReplace(StringReplace(cbListeServeur.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase]);
  VConnexionPath := sServeurConnexionPath;

  sServeurPathGinkoia := IncludeTrailingBackslash('\\' + StringReplace(VserverEasy, '\\', '', [rfReplaceAll, rfIgnoreCase]) + '\' + cbLettre.Text + '\ginkoia');

  // plus utile maintenant qu'on prends la ginkcopy, la vérification est faite à la connexion
  // on essai de voir si la toto existe, si oui on se base sur celle là
//  if FileExists(sServeurPathGinkoia + 'data\backup\ginkoia.toto') then
//  begin
//    VConnexionPath := sServeurPathGinkoia + 'data\backup\ginkoia.toto';
//    PathBase := StringReplace(PathBase, 'ginkoia.ib', 'backup\ginkoia.toto', [rfReplaceAll, rfIgnoreCase]);
//    bServeurToto := True;
//  end
//  else
//    Log.Log(Log_Mdl, Log_Key, 'Base toto du serveur non trouvée', logWarning, True, 0, ltBoth);

  InstallCheck := Tinstall.Create(VConnexionPath);
  try
    InstallCheck.Server := VserverEasy;
    InstallCheck.Drive := cbLettre.Text;
    InstallCheck.PathBdd := PathBase;
    InstallCheck.Connexion := VConnexionPath;

    InstallCheck.OpenServeur(True);
    if InstallCheck.Database.Error <> '' then
    begin
      ErrorMsg('Impossible de se connecter à la base de données du serveur distant : ' + InstallCheck.Database.Error);
      exit;
    end;

    // on vérifie si la base est bien sur Easy
    if not InstallCheck.IsEasy then
    begin
      ShowMessage('La base sélectionnée n''est pas sous Easy, le serveur doit être en synchronisation continue');
      exit;
    end;

    // on vérifie qu'on trouve bien les répertoire JAVA et EASY
    if not (DirectoryExists(sServeurPathGinkoia + 'JAVA')) or not (DirectoryExists(sServeurPathGinkoia + 'EASY')) then
    begin
      ShowMessage('Impossible de trouver les répertoire nécessaires à l''installation sur le serveur d''origine : ' + #13#10 + sServeurPathGinkoia + 'JAVA\' + #13#10 + sServeurPathGinkoia + 'EASY\');
      exit;
    end;

    // on vérifie qu'on trouve toujours bien le poste sélectionné dans la base
    InstallCheck.ErrorMsg := '';
    if (rbPosteList.Checked) then
    begin
      // on vérifie qu'un poste à été choisi
      if rbPosteList.Checked then
      begin
        if Trim(cbChoixSite.Text) = '' then
        begin
          ErrorMsg('Vous devez choisir le poste à installer');
          exit;
        end;
      end;

      // on réattribue la valeur choisie pour le baseSenderSelected
      cbChoixSiteChange(Nil);

      if not Assigned(Install.BaseSenderSelected) then
      begin
        ErrorMsg('Vous devez choisir le poste à installer');
        exit;
      end;

      if not InstallCheck.PosteInBase(Install.BaseSenderSelected) then
      begin
        if InstallCheck.ErrorMsg <> '' then
          ErrorMsg(InstallCheck.ErrorMsg);
        exit;
      end;
    end;

    // si on remplace la base locale, on vérifie ses paramètres puis qu'on trouve son basesender dans la base distante
    if rbBaseLocale.Checked then
    begin
      // on vérifie que la base locale n'est pas déjà sous EASY et on récupère son bas_sender pour comparer à la base à télecharger
      if not checkParamsFromLocal() then
      begin
        ErrorMsg(RST_ERROR_INSTALLFROMLOCAL);
        exit;
      end;

      // on vérifie qu'on trouve le sender dans la base distante
      if not InstallCheck.PosteInBase(Install.BaseSenderSelected) then
      begin
        if InstallCheck.ErrorMsg <> '' then
          ErrorMsg(InstallCheck.ErrorMsg);
        exit;
      end;
    end;

    // on met à jours les infos de log
    Log.Ref := Install.BaseSenderSelected.bas_guid;
    Log.Doss := Install.BaseSenderSelected.bas_dossier;

  finally
    InstallCheck.Free;
  end;

  Result := True;
end;

procedure TFrm_Serveur.Btn_InstallClick(Sender: TObject);
const
  Log_Key = 'Btn_InstallClick';
var
  ResponseWebService: string;
  sMag: string;
  oMsg, oRescueC: TForm;
  InstallLocal: Tinstall;
  EasyURL: String;
  cpt: Integer;

  procedure LockUnlockPanel(bAction: boolean);
  begin
    edtCode.Enabled := bAction;
    ChoixChargementEnable(bAction);
    Application.ProcessMessages;
  end;

  procedure ExitForError(aMsg: string = '');
  var
    backupName: string;
  begin
    Btn_Install.Caption := RST_INSTALL;
    Btn_Install.Tag := 0;
    lblInfo.Caption := '';

    if rbBaseLocale.Checked then
    begin
      backupName := ChangeFileExt(edtPathBaseLocale.Text, '') + '_backup' + ExtractFileExt(edtPathBaseLocale.Text);
      if FileExists(backupName) then
        aMsg := aMsg + ' - récupération de la sauvegarde de la base locale';
    end;

    if aMsg <> '' then
      ErrorMsg(aMsg);

    // s'il y a eu une erreur et qu'on a le backup de la base locale, on remet la base en place
    if rbBaseLocale.Checked then
    begin
      // deconnexion de la base locale
      Install.Database.Disconnect;
      FreeAndNil(Install);

      if FileExists(backupName) then
      begin
        lblInfo.Caption := 'Récupération de la base locale';
        Application.ProcessMessages;
        ShutdownDatabase(edtPathBaseLocale.Text);

        if not CopyFileWithProgressBar(PWideChar(backupName), PWideChar(edtPathBaseLocale.Text), pgBar) then
          ErrorMsg('Impossible de remettre en place la sauvegarde de la base locale')
        else
          ShowMessage('Base locale récupérée avec succès');

        lblInfo.Caption := '';
        Application.ProcessMessages;
      end;
    end;
  end;

  procedure InfoCaption(aInfo: string);
  begin
    lblInfo.Caption := aInfo;
    Application.ProcessMessages;
  end;

begin
  // Arrêt de l'installation
  if Btn_Install.Tag = 1 then
  begin
    // on arrête le processus d'installation
    // le tag est remis à 0

    StopExtract := True;
    ExitForError;
    // Tlogfile.Addline('****'+DateTimeToStr(now)+' '+RST_ZIPSTOPPEDBYUSER );
     // Log.Log(RST_ZIPSTOPPEDBYUSER, logInfo);
    Log.Log(Log_Mdl, Log_Key, RST_ZIPSTOPPEDBYUSER, logInfo, True, 0, ltBoth);
    exit;
  end;

  Btn_Install.Tag := 1;
  Btn_Install.Caption := RST_STOP;

  // si on a choisit de remplacer la base locale, on demande confirmation
  if rbBaseLocale.Checked then
  begin
    try
      oMsg := CreateMessageDialog(RST_EASY_CONFIRM_BASE_LOCALE, mtWarning, [mbOK, mbCancel]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      oMsg.ShowModal;
      if (oMsg.ModalResult = ID_CANCEL) then
      begin
        Btn_Install.Caption := RST_INSTALL;
        Btn_Install.Tag := 0;
        lblInfo.Caption := '';
        Exit;
      end;
    finally
      FreeAndNil(oMsg);
    end;
  end;

  // Saving the path file
  UPatchDll.FileInstallBase := edtLocalfile.Text;

  // on vérifie avant de démarrer que les chemins sont bien renseignées
  if (((bIsEasy) and (sPathEasy = '')) or (sFiletoInstall = '')) and not (bIsFromServer) then
  begin
    ExitForError(RST_ERROR_PATH);
    exit;
  end;

  // si install sous Easy et pas depuis serveur, on vérifie que les sources sont présentes
  if (bIsEasy) and (SearchSourcesEasy(sPathEasy, True) = '') and not (bIsFromServer) then
  begin
    ExitForError(RST_ERROR_EASY_SOURCES);
    exit;
  end;

  // création de l'objet Tinstall (uInstallbase)
  Install := Tinstall.Create(sLocation);
  try

    // on place le tag en 1
    LockUnlockPanel(False);

    InfoCaption('');
    lblInfo.Visible := True;

    // si on fait l'installation depuis un serveurEasy, on vérifie que tous les paramétrages sont bons
    if (bIsFromServer) then
    begin
      Log.Log(Log_Mdl, Log_Key, 'Installation depuis Serveur', logInfo, True, 0, ltBoth);
      InfoCaption('Vérification des paramètres d''installation');
      if not (checkParamsFromServer()) then
      begin
        ExitForError(RST_ERROR_INSTALLFROMSERVER);
        exit;
      end;

      // Si tout est bon, on remonte la date du fichier au monitoring
      // si la date n'est pas trop ancienne on la remonte au monitoring
      Log.Log(Log_Mdl, 'DateBaseSyncro', DateTimeToStr(VDateBaseSynchro), logInfo, True, 0, ltBoth);

      // cas de l'installation en remplaçant une base locale
      if rbBaseLocale.Checked then
      begin
        Log.Log(Log_Mdl, Log_Key, 'Installation en remplaçant la base locale', logInfo, True, 0, ltBoth);

        // on shutdown la base locale pour fermer les connexions actives pour être sur qu'elle puisse être remplacée par la copie
        InfoCaption('Shutdown de la base locale');
        ShutdownDatabase(edtPathBaseLocale.Text);

        InfoCaption('Sauvegarde de la base locale');
        // on fait un backup de la base avant traitement, seule différence avec le traitement au choix du site
        Log.Log(Log_Mdl, Log_Key, 'Backup de la base locale', logInfo, True, 0, ltBoth);
        if not BackupFile(ExcludeTrailingPathDelimiter(edtPathBaseLocale.Text), pgBar) then
        begin
          ExitForError(RTS_ERROR_BACKUPBASE);
          InfoCaption('');
          exit;
        end;
      end
      else
        Log.Log(Log_Mdl, Log_Key, 'Installation à partir de la liste des postes : ' + cbChoixSite.Text, logInfo, True, 0, ltBoth);

      // on copie les fichiers de la base serveur
      InfoCaption('Copie de Ginkoia depuis le serveur');
      Log.Log(Log_Mdl, Log_Key, 'Copie de Ginkoia depuis le serveur', logInfo, True, 0, ltBoth);
      // on copie maintenant les sources Easy, et la version + ginkcopy
      if not CopyFromServeur(sServeurPathGinkoia, cbDrive.Text + 'Ginkoia', sPathEasy, pgBar, lblInfo) then
      begin
        ExitForError(RTS_ERROR_COPYGINKOIAFROMSERVER);
        InfoCaption('');
        exit;
      end;

      // après la copie des fichiers, on dezip le version.zip à la racine
      InfoCaption('Dezip du fichier de version');
      Log.Log(Log_Mdl, Log_Key, 'Dezip du fichier de version', logInfo, True, 0, ltBoth);
      if not Unzip(cbDrive.Text + 'Ginkoia\Data\Synchro\Version.zip', cbDrive.Text + 'Ginkoia\', '', False) then
      begin
        ShowMessage('Echec de l''extraction, Tentative d''extraction avec l''executable de 7z');
        // si erreur on retest avec l'exe portable de 7z
        if not UnzipWithExe(cbDrive.Text + 'Ginkoia\Data\Synchro\Version.zip', cbDrive.Text + 'Ginkoia\', '') then
        begin
          ExitForError(RTS_ERROR_DEZIP);
          InfoCaption('');
          exit;
        end;
      end;

      // on vérifie que les sources d'installation pour Easy on bien été récupérées et si oui on remet à jour le chemin des sources
      // uniquement dans le cas ou les sources pointent sur le chemin réseau, si elles sont été prises en local on ne touche pas le chemin
      if ExtractFileDrive(sServeurPathGinkoia) = ExtractFileDrive(sPathEasy) then
      begin
        edtPathEasy.Text := SearchSourcesEasy();
        sPathEasy := edtPathEasy.Text;
      end;

      // on dépersonnalise la base pour enlever les triggers Easy
      InfoCaption('Dépersonnalisation de la base de données');
      Log.Log(Log_Mdl, Log_Key, 'Dépersonnalisation de la base données - suppression de SymDS', logInfo, True, 0, ltBoth);
      if not Install.DROP_SYMDS(pgBar) then
      begin
        ExitForError(RTS_ERROR_DEPERSOBASE + Install.ErrorMsg);
        InfoCaption('');
        exit;
      end;

      InfoCaption('Mise à jour des identifiants de base');
      // on fait le récup base
      Log.Log(Log_Mdl, Log_Key, 'RécupBase', logInfo, True, 0, ltBoth);
      if not Install.DoRecupBase(cbDrive.Text + 'Ginkoia\Data\', bIsEasy) then
      begin
        ExitForError(RTS_ERROR_RECUPBASE + Install.ErrorMsg);
        InfoCaption('');
        exit;
      end;

      // On lance l'installation de Easy
      InfoCaption('Installation de Easy, veuillez patienter');
      Log.Log(Log_Mdl, Log_Key, 'Installation de Easy', logInfo, True, 0, ltBoth);

      if not bIsFromServer then
      begin
        if not InstallEasy(sPathEasy, sLocation, Install.BaseSenderSelected.bas_nom) then
        begin
          ExitForError(RST_ERROR_INSTALLEASY);
          exit;
        end
      end
      else
      begin
         // nouvelle méthode en modifiant les fichiers dans le cas d'une install depuis le serveur
        EasyURL := Install.GetGENPARAM(80, 1, PRM_STRING);

        if not InstallEasyNew(cbLettre.text, sLocation, Install.BaseSenderSelected.bas_nom, bIsPortable, bRescueC, EasyURL) then
        begin
          ExitForError(RST_ERROR_INSTALLEASY);
          exit;
        end;

         //le service est installé, pause de 2minutes et on donne les droits
         //pause de 2minutes avant d'éxecuter le fichier des grants.sql
        for cpt := 0 to 11 do
        begin
          InfoCaption('Mise en place des grants pour Easy, veuillez attendre ' + IntToStr(120 - (cpt * 10)) + ' Secondes');

          Sleep(10000);
        end;

        if not Install.GRANT_FOR_EASY() then
        begin
          ExitForError(RST_ERROR_INSTALLEASY2);
          exit;
        end;
      end;

      // on nettoie le registre du launcherDelos
      CleanRegistryDelos();
      ShowMessage(RST_EASYSUCCESS);

      if not DirectoryExists(IncludeTrailingPathDelimiter(sLocation) + 'A_MAJ\') then
      if not CreateDir(IncludeTrailingPathDelimiter(sLocation) + 'A_MAJ\') then
        ShowMessage(RST_NOAMAJ);

      // *********************************************************
      // *** fin de l'installation partie hors install serveur ***
      // *********************************************************
      InfoCaption('');
      if Install.Referencement then
      begin
        // mise à jour du chemin de la base
        if Install.SetPathBPL then
        begin
          // ShowMessage('Mise à jour du Path terminée.');
          // connection à la base
          if Install.Connect(True) then
          begin
            ShowMessage('Connexion à la base terminée.');

            // ******************* gestion de la langue ********************
            Install.SetLanguage;

            // on met à jour les paramètres régionaux si pas en français
            if Install.Language.UpdateRegionals then
              SetRegionToFr();
            lblLangName.Caption := Install.Language.Name;
            Dm_Main.ImgListLng.GetIcon(Install.Language.ImgIndex, imgLang.Picture.Icon);
            // ****************** fin de la langue *************************

            cbMagasin.Items.Clear;
            cbPoste.Items.Clear;
            Install.AddShop := ptAddShop;
            Install.AddPoste := ptAddPoste;
            Install.GetShop;
            // recherche du magasin principal
            sMag := Install.getMainShop;
            if sMag <> '' then
            begin
              cbMagasin.Itemindex := cbMagasin.Items.indexof(sMag);
              cbMagasin.Text := sMag;
              Install.GetPoste(sMag);
              if cbPoste.Items.Count > 0 then
              begin
                cbPoste.Itemindex := cbPoste.Items.indexof('SERVEUR');
                if cbPoste.Itemindex > -1 then
                begin
                  cbPoste.Text := 'SERVEUR';
                end;
              end;
            end;

            // on met les infos serveur locales par défaut
            edt_ServerPrin.Text := cbListeServeur.Text;
            cbbLetterDir.Itemindex := cbbLetterDir.Items.indexof(cbLettre.Text);

            pnlmag.Visible := True;
            pnlmag.BringToFront;

          end
          else
            ExitForError(RST_ERROR_BDD);

        end
        else
          ExitForError(RST_ERROR_BPL);
      end
      else
      begin
        ExitForError(RST_ERROR_REFERENCEMENT + #10 + Install.ErrorMsg);
      end;

      lblInfo.Caption := '';

    end
    // *********************************************************************************
    // *********** dans le cas d'une installation à partir d'un ZIP  *******************
    // *********************************************************************************
    else
    begin
      // on dézip le fichier et on poursuit si ok
      Log.Log(Log_Mdl, Log_Key, 'Installation depuis un ZIP', logInfo, True, 0, ltBoth);
      if InstallServeur = True then
      begin
        try
          Application.ProcessMessages;

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
              exit;
            end
            else
            begin
              // on nettoie le registre du launcherDelos
              CleanRegistryDelos();

              ShowMessage(RST_EASYSUCCESS);
            end;

            lblInfo.Caption := '';
          end;

          lblInfo.Caption := ' Connexion à la base de données';
          lblInfo.Visible := True;
          Application.ProcessMessages;

          // référencement de la base
          if bRecupBase = False then
          begin
            if Install.Referencement then
            begin
              // mise à jour du chemin de la base
              if Install.SetPathBPL then
              begin
                // ShowMessage('Mise à jour du Path terminée.');
                // connection à la base
                if Install.Connect(True) then
                begin
                  ShowMessage('Connexion à la base terminée.');

                  // ******************* gestion de la langue ********************
                  Install.SetLanguage;

                  // on met à jour les paramètres régionaux si pas en français
                  if Install.Language.UpdateRegionals then
                    SetRegionToFr();
                  lblLangName.Caption := Install.Language.Name;
                  Dm_Main.ImgListLng.GetIcon(Install.Language.ImgIndex, imgLang.Picture.Icon);
                  // ****************** fin de la langue *************************

                  cbMagasin.Items.Clear;
                  cbPoste.Items.Clear;
                  Install.AddShop := ptAddShop;
                  Install.AddPoste := ptAddPoste;
                  Install.GetShop;
                  // recherche du magasin principal
                  sMag := Install.getMainShop;
                  if sMag <> '' then
                  begin
                    cbMagasin.Itemindex := cbMagasin.Items.indexof(sMag);
                    cbMagasin.Text := sMag;
                    Install.GetPoste(sMag);
                    if cbPoste.Items.Count > 0 then
                    begin
                      cbPoste.Itemindex := cbPoste.Items.indexof('SERVEUR');
                      if cbPoste.Itemindex > -1 then
                      begin
                        cbPoste.Text := 'SERVEUR';
                      end;
                    end;

                  end;
                  pnlmag.Align := alClient;
                  pnlmag.Visible := True;
                  pnlmag.BringToFront;

                end
                else
                  ExitForError(RST_ERROR_BDD);

              end
              else
                ExitForError(RST_ERROR_BPL);
            end
            else
            begin
              ExitForError(RST_ERROR_REFERENCEMENT + #10 + Install.ErrorMsg);
            end;

            lblInfo.Caption := '';
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
        finally

        end;
      end
      else
      begin
        if AlreadyInstall <> True then
        begin
          ExitForError(RST_ERROR_UNZIP3);
        end;
      end;
    end;

    // si on est en version >= 21 et que le module cash est activé.
    if Install.CanInstallCash then
    begin
      lblCash.Visible := True;
      chkCash.Visible := True;
      chkCash.Enabled := True;
      chkCash.Checked := False;
    end;

  finally
    LockUnlockPanel(True);

    // if Assigned(Install) then
    // Install.Database.Disconnect;
  end;
end;

procedure TFrm_Serveur.cbbLetterDirChange(Sender: TObject);
begin
  ValidInstall;
end;

procedure TFrm_Serveur.cbChoixSiteChange(Sender: TObject);
begin
  if (Assigned(Install)) and (cbChoixSite.Itemindex <> -1) then
    Install.SetBaseSenderSelected(cbChoixSite.Items.Objects[cbChoixSite.Itemindex]);
end;

procedure TFrm_Serveur.cbDriveChange(Sender: TObject);
const
  Log_Key = 'cbDriveChange';
var
  oMsg: TForm;
begin
  if cbDrive.Text = '' then
    exit;

  Btn_Install.Visible := False;
  sLocation := cbDrive.Text;
  sLocation := IncludeTrailingBackslash(sLocation) + 'GINKOIA';
  if Tdirectory.Exists(sLocation) then
  begin
    try
      oMsg := CreateMessageDialog(RST_GINKOIA_EXISTS, mtWarning, [mbYES, mbNo]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      if oMsg.ShowModal = IDYES then
      begin
        Log.Log(Log_Mdl, Log_Key, 'Installation sur répertoire Ginkoia existant sur ' + cbDrive.Text, logWarning, True, 0, ltBoth);
        FTransaction := True;
        Btn_Install.Visible := True;
      end
      else
      begin
        cbDrive.Text := '';
        Btn_Install.Visible := False;
      end;
    finally
      FreeAndNil(oMsg);
    end;
  end
  else
    Btn_Install.Visible := True;
end;

procedure TFrm_Serveur.cbLettreChange(Sender: TObject);
begin
  EnabledDisableConnexion();
end;

procedure TFrm_Serveur.cbListeServeurChange(Sender: TObject);
begin
  EnabledDisableConnexion();
end;

procedure TFrm_Serveur.EnabledDisableConnexion();
begin
  if (cbListeServeur.Text <> '') and (cbLettre.Text <> '') and (PathBaseServerEasy.Text <> '') then
    BtnConnServEasy.Enabled := True
  else
    BtnConnServEasy.Enabled := False;
end;

procedure TFrm_Serveur.cbMagasinChange(Sender: TObject);
begin
  ValidInstall;

  // SR - On vide la combo et on charge les postes
  cbPoste.Clear;
  if cbMagasin.Itemindex > -1 then
  begin
    Install.GetPoste(cbMagasin.Text);
    // Chp_PostePortable.Items := Install.GetMagPortable(cbMagasin.Text);
  end;
end;

procedure TFrm_Serveur.cbPosteChange(Sender: TObject);
var
  i: integer;
  bOk: boolean;
begin
  // charge automatiquement caisse_sec (dans le cas de l'installation d'une caisse-sec seulement)

  if bRescueC then
  begin
    i := cbPosteSecours.Items.Count;
    bOk := False;
    for i := 0 to i do
    begin
      if cbPoste.Text + '_SEC' = cbPosteSecours.Items[i] then
      begin
        cbPosteSecours.Itemindex := i;
        bOk := True
      end;
    end;

    if bOk = False then
      cbPosteSecours.ClearSelection;
  end;

  // if bIsPortable = False then
  ValidInstall;
end;

procedure TFrm_Serveur.Chk_ManuMagSupClick(Sender: TObject);
begin
  // // On choisi la saisie manuelle
  // if Chk_ManuMagSup.Checked then
  // begin
  // Chp_PostePortable.Visible := False;
  // Edt_MagSupManuel.Visible  := True;
  // end else
  // begin
  // Chp_PostePortable.Visible := True;
  // Edt_MagSupManuel.Visible  := False;
  // end;
end;

procedure TFrm_Serveur.Chp_PostePortableDrawItem(Control: TWinControl; Index: integer; Rect: TRect; State: TOwnerDrawState);
begin
  SetLength(bSelection, TComboBox(Control).Items.Count);
  with TComboBox(Control).Canvas do
  begin
    FillRect(Rect);

    Rect.Left := Rect.Left + 1;
    Rect.Right := Rect.Left + 13;
    Rect.Bottom := Rect.Bottom;
    Rect.Top := Rect.Top;

    if not (odSelected in State) and (bSelection[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if (odFocused in State) and (bSelection[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if (bSelection[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if not (bSelection[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT);

    TextOut(Rect.Left + 15, Rect.Top, TComboBox(Control).Items[Index]);
  end
end;

procedure TFrm_Serveur.Chp_PostePortableSelect(Sender: TObject);
var
  i: integer;
  Nom: string;
  nbSelect: integer;
begin
  // Btn_Finalize.Visible := False;
  nbSelect := 0;

  bSelection[TComboBox(Sender).Itemindex] := not bSelection[TComboBox(Sender).Itemindex];

  for i := Low(bSelection) to High(bSelection) do
  begin
    if bSelection[i] then
    begin
      Inc(nbSelect);
      if nbSelect > 7 then
      begin
        ShowMessage('Vous ne pouvez pas sélection plus de 7 magasins');
        bSelection[TComboBox(Sender).Itemindex] := False;
        exit;
      end;
    end;
  end;

end;

procedure TFrm_Serveur.edtCodeChange(Sender: TObject);
begin
  if edtCode.Focused then
  begin
    // RgChoice.Enabled := (edtCode.Text <> '');
    ChoixChargementEnable(edtCode.Text <> '');

    RgChoice.Buttons[3].Enabled := (bIsPortable or bRescueC);
  end;
end;

procedure TFrm_Serveur.edtCodeEnter(Sender: TObject);
begin
  RgChoice.Itemindex := -1;
  pnlUrl.Visible := False;
  pnlInstall.Visible := False;
  pnlEasy.Visible := False;
  pnlServeurEasy.Visible := False;
  pnlTypeInstallEasy.Visible := False;
  edtCode.Text := '';
  cbbLetterDir.Itemindex := -1;
  cbDrive.Itemindex := -1;
  rbBaseLocale.Checked := False;
  rbPosteList.Checked := False;
end;

procedure TFrm_Serveur.edtCodeExit(Sender: TObject);
begin
  Application.ProcessMessages;
  if sCodeClient <> '' then
  begin
    // on a resaissi le code client
    sCodeClient := edtCode.Text;
  end;
end;

procedure TFrm_Serveur.edtConfirmChange(Sender: TObject);
var
  sc: string;
  oMsg: TForm;
begin
  sc := edtConfirm.Text;
  if sc.length = sCodeClient.length then
  begin
    btnDownload.Enabled := (sc = sCodeClient);
    if btnDownload.Enabled then
    begin
      edtCode.Text := sCodeClient;
    end
    else
    begin
      oMsg := CreateMessageDialog(RST_ERROR_CODE, mtWarning, [mbOK]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      oMsg.ShowModal;
      oMsg.Release;
    end;
  end;

end;

procedure TFrm_Serveur.edtLocalfileDblClick(Sender: TObject);
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
          if fs.contains(sCodeClient) = True then
          begin
            edtLocalfile.Text := fs;
            // pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            sFiletoInstall := fs;
            break;
          end;
        end;
      end;
  end;
end;

procedure TFrm_Serveur.edtLocalfileExit(Sender: TObject);
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
            if sFilename.contains(sCodeClient) = False then
            begin
              oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOK]);
              oMsg.Position := poOwnerFormCenter;
              oMsg.FormStyle := fsStayOnTop;
              oMsg.ShowModal;
              oMsg.Release;
              pnlInstall.Visible := False;
              exit;
            end;
            sFiletoInstall := sFilename;
            // pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            edtLocalfile.Text := sFilename;
            sFiletoInstall := sFilename;
            edtCode.Text := sCodeClient;

            TestIfEasy(sFilename);
          end
          else
          begin
            pnlInstall.Visible := False;
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

procedure TFrm_Serveur.TestIfEasy(aFileToTest: string);
const
  Log_Key = 'TestIfEasy';
begin
  // on vérifie que le fichier de l'archive existe avant tout traitement

  if FileExists(aFileToTest) then
  begin
    bIsEasy := ArchiveIsEasy(aFileToTest);

    // si on est sur Easy, on fait la recherche des sources et on coche la case easy
    if bIsEasy then
    begin
      pnlEasy.Visible := True;
      chkEasy.Checked := True;

      edtPathEasy.Text := SearchSourcesEasy();
      sPathEasy := edtPathEasy.Text;

      if (uFunctions.UsrLogged = UsrGin) or (Trim(edtPathEasy.Text) = '') then
        edtPathEasy.Enabled := True;

    end
    else
    begin
      pnlEasy.Visible := False;
      chkEasy.Checked := False;
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

procedure TFrm_Serveur.edtLocalfileKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    edtLocalfileExit(Sender);
  end;
end;

procedure TFrm_Serveur.edtLocalfileRightButtonClick(Sender: TObject);
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
          if sFilename.contains(sCodeClient) = False then
          begin
            oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOK]);
            oMsg.Position := poOwnerFormCenter;
            oMsg.FormStyle := fsStayOnTop;
            oMsg.ShowModal;
            oMsg.Release;
          end
          else
          begin
            // pnlInstall.Align := alClient;
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
          // on test d'abord si c'est un fichier sur le réseau local
          sFilename := edtLocalfile.Text;
          if Tfile.Exists(sFilename) = True then
          begin
            if sFilename.contains(sCodeClient) = False then
            begin
              oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOK]);
              oMsg.Position := poOwnerFormCenter;
              oMsg.FormStyle := fsStayOnTop;
              oMsg.ShowModal;
              oMsg.Release;
              pnlInstall.Visible := False;
              exit;
            end;
            sFiletoInstall := sFilename;
            // pnlInstall.Align := alClient;
            pnlInstall.Visible := True;
            edtLocalfile.Text := sFilename;
            sFiletoInstall := sFilename;
            edtCode.Text := sCodeClient;

            // on appelle la fonction  pour tester si on est sur une base easy
            TestIfEasy(sFilename);
          end
          else
          begin

            fs := edtLocalfile.Text;
            TLameFileDownloader.SetUrl(fs);
            TLameFileDownloader.Progress := ptProgress;
            TLameFileDownloader.AfterDownload := ptAfterDownload;
            TLameFileDownloader.BeforeDownload := ptBeforeDownload;
            TLameFileDownloader.BeforeReset := ptBeforeReset;
            try
              TLameFileDownloader.Downloadfile(URL);
              ;
            finally
              btnDownload.Tag := 0;
              lblInfo.Caption := '';
              edtConfirm.ReadOnly := False;
              edtCode.ReadOnly := False;
              pgBar.Position := 0;
              pgBar.Visible := False;
              pgBar.Update;
              Fstop := False;
              // RgChoice.Enabled := True;
              ChoixChargementEnable(True);
              btnDownload.Caption := RST_DOWNLOAD;
              pnlLame.Visible := False;
              pnlLame.Update;

              // test si la base téléchargée est sous easy
              TestIfEasy(TLameFileDownloader.LOCALFILE);
            end;
          end;
        end
        else
        begin
          beep;
          beep;
        end;
      end;
    STOP:
      begin
        // arrêt chargement à partir URL
        Fstop := True;
        Application.ProcessMessages;
        edtLocalfile.RightButton.ImageIndex := URL;
        edtLocalfile.RightButton.Hint := RST_URLHINT;
        edtLocalfile.ReadOnly := False;
        // Sleep(1000) ;
      end;
  end;
end;

procedure TFrm_Serveur.edtPathBaseLocaleRightButtonClick(Sender: TObject);
var
  TypeItemsOri: TFileTypeItems;
begin

  // on met en type par défaut les .IB
  Openfile.FileTypeIndex := 3;

  // si le chemin du disque est renseigné, on met celui la par défaut pour le choix du dossier
  if (edtPathBaseLocale.Text <> '') then
    Openfile.DefaultFolder := IncludeTrailingBackslash(ExtractFileDir(edtPathBaseLocale.Text));

  if (Openfile.Execute()) then
  begin
    edtPathBaseLocale.Text := IncludeTrailingBackslash(Openfile.FileName);
  end;

  // on remet en type zip par défaut
  Openfile.FileTypeIndex := 1;

end;

procedure TFrm_Serveur.edtPathEasyClick(Sender: TObject);
begin
  // on permet la selection des dossiers
  Openfile.Options := [fdoPickFolders];

  // si le chemin du disque est renseigné, on met celui la par défaut pour le choix du dossier
  if (cbDrive.Text <> '') then
    Openfile.DefaultFolder := IncludeTrailingBackslash(cbDrive.Text);

  if (Openfile.Execute()) then
  begin
    edtPathEasy.Text := IncludeTrailingBackslash(Openfile.FileName);
    sPathEasy := IncludeTrailingBackslash(edtPathEasy.Text);
  end;

  // on annule la sélection des dossiers
  Openfile.Options := [];
end;

procedure TFrm_Serveur.edtPathEasyExit(Sender: TObject);
begin
  if DirectoryExists(edtPathEasy.Text) then
    sPathEasy := IncludeTrailingBackslash(edtPathEasy.Text)
  else
    sPathEasy := '';
end;

procedure TFrm_Serveur.edtPathEasyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    edtPathEasyExit(Sender);
  end;
end;

procedure TFrm_Serveur.edt_ServerPrinChange(Sender: TObject);
begin
  ValidInstall;
end;

procedure TFrm_Serveur.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Main.Tag := 0;
  // pour permettre la fermeture de la fenêtre principale.

  if Assigned(Install) then
    FreeAndNil(Install); // SR - Libération de l'insatallation.

  if Assigned(ListBases) then
    FreeAndNil(ListBases);

  Action := caHide;
end;

procedure TFrm_Serveur.FormCreate(Sender: TObject);
var
  af: TStringDynArray;
  fs: string;
  ls: integer;
  a: Char;
begin
  bIsEasy := False;
  bIsFromServer := False;
  ListBases := TObjectList<TObject>.Create();

  // 7z
  Vzipmax := 0;
  Vzipvalue := 0;
  StopExtract := False;

  // Rempli les lettres pour le disque
  cbbLetterDir.Clear;
  for a := 'A' to 'Z' do
    cbbLetterDir.Items.Add(a);

  // recherche des partitions installables
  af := Tdirectory.GetLogicalDrives;
  for fs in af do
  begin
    if IsAvalidtype(fs) then
      cbDrive.Items.Add(fs);
  end;

  aListdesfichierssurlame := Tstringlist.Create;

  // initialisation du fichier log en mode Add
  // Tlogfile.InitLog(False);

  // initialisation de la procedure utilisée par TLameFileDownloader  après chargement
  ptAfterDownload :=
    procedure(Aborted, Error: boolean)
    var
      oMsg: TForm;
    begin
      if Error = True then
      begin
        try
          oMsg := CreateMessageDialog(TLameFileDownloader.ErrorMsg, mtError, [mbOK]);
          oMsg.Position := poOwnerFormCenter;
          oMsg.FormStyle := fsStayOnTop;
          oMsg.ShowModal;

          pnlInstall.Visible := False;
        finally
          FreeAndNil(oMsg);
        end;
      end
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
        // pnlInstall.Align := alClient;

        // edtLocalfileExit(Self);

        if sFiletoInstall.contains(sCodeClient) = False then
        begin
          oMsg := CreateMessageDialog(RST_BADCODE, mtWarning, [mbOK]);
          oMsg.Position := poOwnerFormCenter;
          oMsg.FormStyle := fsStayOnTop;
          oMsg.ShowModal;
          oMsg.Release;
          pnlInstall.Visible := False;
          exit;
        end;

        // on test si on est sur easy
        TestIfEasy(sFiletoInstall);

        pnlInstall.Visible := False;

        pnlInstall.Visible := True;
      end;

      pgBar.Visible := False;
      pgBar.Position := 0;

    end; // fin de ptAfterdownload

  // initialisation de la procédure de progression utilisée par TlameFileDownloader pendant le chargement
  ptProgress :=
    procedure(Progress, ProgressMax: cardinal; StatusText: string; var cancel: boolean; Pct2Download: integer)
    var
      iValA, iValC: integer;
    begin
      pgBar.Visible := True;
      pgBar.Max := ProgressMax;
      pgBar.Position := Progress;
      pgBar.Update;
      if Progress > 0 then
      begin
        lblInfo.Caption := StatusText;
        lblInfo.Update;
      end;
      cancel := Fstop;
      // lblEstimated.Caption := RST_RESTEACHARGER + IntToStr(Pct2Download) + ' %';
      if pgBar.Position > 0 then
      begin
        iValA := StrToInt(FormatFloat('#.##', pgBar.Position div 1024));
        iValC := StrToInt(FormatFloat('#.##', pgBar.Max div 1024));
        lblEstimated.Caption := FloatToStr((iValA * 100) div iValC) + '%';
        lblEstimated.Update;
      end;
      Application.ProcessMessages;
    end; // fin de ptProgress

  // initialisation de la procedure utilisée par TlameFileDownloader avant le chargement
  ptBeforeDownload :=
    procedure(Mode: integer)
    begin
      case Mode of
        FROMLAME, URL:
          begin
            btnDownload.Tag := 1;
            btnDownload.Caption := RST_STOP;
            pgBar.Position := 0;
            pgBar.Visible := True;
            pgBar.Update;
            lblInfo.Caption := '';
            lblInfo.Visible := True;
            lblInfo.Update;
            edtConfirm.ReadOnly := True;
            edtConfirm.Update;
            edtCode.ReadOnly := True;
            edtCode.Update;
            // RgChoice.Enabled := False;
            ChoixChargementEnable(False);
            Label2.Caption := '';
            lblEstimated.Visible := True;
            if Mode = URL then
            begin
              edtLocalfile.ReadOnly := True;
              edtLocalfile.RightButton.ImageIndex := STOP;
              edtLocalfile.RightButton.Hint := RST_HINT_STOPDOWNLOAD;
            end;
          end;

      end; // fin de mode

    end; // fin de ptBeforeDownload

  ptBeforeReset :=
    procedure(Mode: integer; Aborted, Error: boolean)
    begin
      case Mode of
        URL:
          begin
            pgBar.Position := 0;
            pgBar.Visible := True;
            pgBar.Update;
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
            // RgChoice.Enabled := False;
            ChoixChargementEnable(False);
            Fstop := False;
          end;
        FROMLAME:
          begin
            btnDownload.Tag := 0;
            lblInfo.Caption := '';
            edtConfirm.ReadOnly := False;
            edtCode.ReadOnly := False;
            pgBar.Position := 0;
            pgBar.Visible := False;
            pgBar.Update;
            lblEstimated.Visible := False;
            lblEstimated.Caption := '';
            lblEstimated.Update;
            Fstop := False;
            // RgChoice.Enabled := True;
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

    end; // fin de ptCleanScreen

  // **** Création des procédures propre à la form ****//
  ptAddShop :=
    procedure(sMag: string; aMagID: Integer)
    begin
      // ajout magasin à la liste  cbMagasin
      //cbMagasin.Items.Add(sMag);
      cbMagasin.Items.AddObject(sMag, TObject(aMagID));
    end;

  ptAddPoste :=
    procedure(sPoste: string; aPosID: Integer)
    begin
      // ajout d'un poste à la liste cbPose
      cbPoste.Items.AddObject(sPoste, TObject(aPosID));
      cbPosteSecours.Items.AddObject(sPoste, TObject(aPosID));
      //cbPoste.Items.Add(sPoste);
      //cbPosteSecours.Items.Add(sPoste);
    end
  // **************************************************//
end;

procedure TFrm_Serveur.FormShow(Sender: TObject);
begin
  // forcer le focus Activecontrol semble pas fonctionner
  edtCode.SetFocus;
end;

procedure TFrm_Serveur.ChoixChargementEnable(State: boolean);
begin
  RgChoice.Buttons[0].Enabled := State;
  RgChoice.Buttons[1].Enabled := State;
  RgChoice.Buttons[2].Enabled := State;

  // le choix de déployer depuis un serveur easy est toujours disponible si on est sur un portable ou caisse de secours
  RgChoice.Buttons[3].Enabled := (bIsPortable or bRescueC);
end;

procedure TFrm_Serveur.Image1Click(Sender: TObject);
begin
  // on ferme la fenêtre
  if (Btn_Install.Tag = 1) or (btnDownload.Tag = 1) then
    exit;

  Postmessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TFrm_Serveur.EnumNetworkProc(const aNetResource: TNetResource; const aLevel: Word; var aContinue: boolean);
var
  networkName: string;
begin
  if aNetResource.dwDisplayType in [RESOURCEDISPLAYTYPE_DOMAIN, RESOURCEDISPLAYTYPE_SERVER] then
  begin
    networkName := StringOfChar(' ', aLevel * 4) + aNetResource.lpRemoteName;

    cbListeServeur.Items.Add(networkName);

    if (Pos('ns', LowerCase(networkName)) > 0) or (Pos('serveur', LowerCase(networkName)) > 0) then
      cbListeServeur.ItemIndex := cbListeServeur.Items.Count - 1;
  end;
end;

procedure TFrm_Serveur.RgChoiceClick(Sender: TObject);
var
  sTemp, sTempPath: string;
  af: TStringDynArray; // pour rechercher le fichier zip
  fs: string; // pour évaluer chacune des valeurs de af
  DriveLetter: Char;
begin
  try

    bIsFromServer := False;
    bIsEasy := False;

    if (edtCode.Text = '') and (sCodeClient = '') and (RgChoice.Itemindex <> 3) then
      exit;

    screen.Cursor := crHourGlass;
    sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
    // on sélectionne  la source du fichier
    if edtCode.Text <> '' then
      sCodeClient := edtCode.Text;
    // edtCode.Text := '';

    // on masque les panels
    pnlLame.Visible := False;
    pnlUrl.Visible := False;
    pnlInstall.Visible := False;
    pnlEasy.Visible := False;
    pnlServeurEasy.Visible := False;
    pnlTypeInstallEasy.Visible := False;

    case RgChoice.Itemindex of
      0: // lame
        begin

          pnlLame.Visible := True;
          pnlLame.Update;
          Postmessage(Handle, WM_LOADLISTFROMLAME, 0, 0);
          Frm_Main.Tag := 1;
          edtConfirm.SetFocus;
          Application.ProcessMessages;
        end;
      1, 2: // url ou fichier local
        begin
          pnlUrl.Top := pnlLame.Top;
          pnlUrl.Left := pnlLame.Left;
          if RgChoice.Itemindex = 1 then
          begin
            // edtLocalfile.Text := 'http://'; on peut mettre un chemin réseau donc plus http:// par défaut
            edtLocalfile.Text := '';
            edtLocalfile.RightButton.ImageIndex := URL;
            edtLocalfile.RightButton.Hint := RST_HINT_DOWNLOAD;
            Label4.Caption := RST_URL;
            Frm_Main.Tag := 1;
          end
          else
          begin
            // local file
            edtLocalfile.Text := '';
            sTempPath := Tpath.GetTempPath;
            af := Tdirectory.GetFiles(sTempPath, '*.zip');
            for fs in af do
            begin
              if fs.contains(sCodeClient) = True then
              begin
                edtLocalfile.Text := fs;
                break;
              end;

            end;
            edtLocalfile.RightButton.ImageIndex := LOCALFILE;
            Label4.Caption := RST_FILE;
            edtLocalfile.RightButton.Hint := RST_HINT_OPENFILE;
            Frm_Main.Tag := 1;
          end;
          pnlUrl.Visible := True;
          pnlUrl.Update;
          edtLocalfile.SetFocus;
        end;
      3: // Depuis un serveur sur le réseau
        begin
          bIsFromServer := True;
          // on demande si on veut chercher les postes sur le réseau
          if MessageDlg('Souhaitez-vous faire une recherche des postes sur le réseau ?', mtInformation, mbYesNo, 0) = mrYes then
          begin
            // **** Recherche des machines sur le réseau ****//
            screen.Cursor := crHourGlass;
            Application.CreateForm(TFrm_ProgressBar, Frm_ProgressBar);
            Frm_ProgressBar.ShowModal;
            if ((Frm_ProgressBar.ModalResult = mrCancel) or (Frm_ProgressBar.ModalResult = mrOk)) then
              Frm_ProgressBar.Free;
            screen.Cursor := crDefault;
          end;

          // **** Les lettres des disques ****//
          if cbLettre.Items.Count = 0 then
          begin
            cbLettre.Clear;
            for DriveLetter := 'C' to 'Z' do
            begin
              cbLettre.Items.Add(DriveLetter);
            end;
          end;

          pnlServeurEasy.Visible := True;
          // dans le cas d'une install depuis un serveur, on a plus besoin des sources Easy
          lblSourcesEasy.Visible := False;
          edtPathEasy.Visible := False;
        end;
    end;
  finally
    screen.Cursor := crDefault;
  end;
end;

function ProgressCallback(Sender: Pointer; total: boolean; value: Int64): HRESULT; stdcall;
var
  vPrc: Int64;
begin
  if total then
    Frm_Serveur.Vzipmax := value
  else
  begin
    if Frm_Serveur.Vzipmax > 0 then
    begin
      vPrc := Trunc(value * 100 / Frm_Serveur.Vzipmax);

      // on met à jour tous les 2% d'avancement
      if ((vPrc mod 2 = 0) and (vPrc <> Frm_Serveur.Vzipvalue)) then
      begin
        UpdateProgress(vPrc);

        Frm_Serveur.Vzipvalue := vPrc;
      end;
    end;
  end;

  Application.ProcessMessages;

  if Frm_Serveur.StopExtract then
    Result := S_FALSE
  else
    Result := S_OK;
end;

procedure UpdateProgress(aPercent: integer);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Frm_Serveur.pgBar.Position := aPercent;
    end);
end;

function TFrm_Serveur.Unzip(aFile: string; aDestPath: string; aPassword: string; forceMessage: boolean = true): boolean;
const
  Log_Key = 'Unzip';
begin
  Result := False;
  try
    if FileExists(aFile) then
    begin
      pgBar.Position := 0;
      pgBar.Max := 100;
      pgBar.Visible := true;
      // on remet la progressBar à 0
      UpdateProgress(0);

      if forceMessage then
      begin
        lblInfo.Caption := ' Extraction de l''archive en cours';
        lblInfo.Visible := True;
      end;


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

      lblInfo.Caption := '';

      Result := True;
      if forceMessage then
        ShowMessage('Dézipage du fichier terminé');
    end
    else
    begin
      // impossible de trouver le fichier à dézziper
      raise Exception.Create('Impossible de trouver le fichier à déziper');
    end;
  except
    on E: Exception do
    begin
      //Btn_Install.Caption := RST_INSTALL;
      //Btn_Install.Tag := 0;

       // Log.Log(RST_ZIPSTOPPEDBYUSER, logInfo);
      Log.Log(Log_Mdl, Log_Key, E.Message, logInfo, True, 0, ltBoth);

      if StopExtract = True then
        raise Exception.Create(RST_ZIPSTOPPEDBYUSER);
      //else
        //raise Exception.Create('UnZipFile -> ' + E.Message);
    end;
  end;
  pgBar.Visible := False;
end;

function TFrm_Serveur.UnzipWithExe(aFile: string; aDestPath: string; aPassword: string): boolean;
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
      pgBar.Position := 0;
      pgBar.Max := 100;
      pgBar.Visible := true;
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
      Btn_Install.Caption := RST_INSTALL;
      Btn_Install.Tag := 0;
       // Log.Log(RST_ZIPSTOPPEDBYUSER, logInfo);
      Log.Log(Log_Mdl, Log_Key, RST_ZIPSTOPPEDBYUSER, logInfo, True, 0, ltBoth);

      if StopExtract = True then
        raise Exception.Create(RST_ZIPSTOPPEDBYUSER)
      else
        raise Exception.Create('UnZipFile -> ' + E.Message);
    end;
  end;
  pgBar.Visible := False;
end;

procedure TFrm_Serveur.ValidInstall;
begin
  if bIsPortable then
    Btn_Finalize.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '') and (cbbLetterDir.Text <> '') and (edt_ServerPrin.Text <> '')
  else if bRescueC then
    Btn_Finalize.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '') and (cbPosteSecours.Text <> '') and (cbbLetterDir.Text <> '') and (edt_ServerPrin.Text <> '')
  else
    Btn_Finalize.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '');

  Btn_Finalize.Enabled := Btn_Install.Visible;

  if bIsPortable then
    chk_AddServ.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '') and (cbbLetterDir.Text <> '') and (edt_ServerPrin.Text <> '')
end;

{ *******************************************************Lame*********************************************************** }

procedure TFrm_Serveur.LoadListFromLame(var aMsg: Tmessage);
var
  fs, sLame: string;
  ptFilter: TFilter_Perso;
  bOk: boolean;
  oMsg: TForm;
  NbTentative: integer;
  IniParam: TIniFile;
  Section, IdS, value, sDirIniParam: string;
  ValueSection: Tstringlist;
  i: integer;
begin
  ptFilter :=
    function(sFile: string): boolean
    begin
      if (sFile.contains('PORTABLE') = True) or (sFile.contains('SERVEUR') = True) then
        exit(True)
      else
        exit(False);
    end;

  Application.ProcessMessages;
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

      for i := 0 to ValueSection.Count do
      begin
        sLame := IniParam.ReadString(Section, IdS + IntToStr(i + 1), '');
        sLame := EnCryptDeCrypt(sLame);

        if sLame <> '' then
        begin
          TLameFileParser.SetUrl(sLame);
          TLameFileParser.Filter := ptFilter;
          TLameFileParser.GetFiles('.zip');
          for fs in TLameFileParser.TlistFiles do
          begin
            if fs.contains(sCodeClient) = True then
            begin
              bOk := True;
              break;
            end;
          end;
        end;
      end;
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

          for i := 0 to ValueSection.Count do
          begin
            sLame := IniParam.ReadString(Section, IdS + IntToStr(i + 1), '');
            sLame := EnCryptDeCrypt(sLame);

            if sLame <> '' then
            begin
              TLameFileParser.SetUrl(sLame);
              TLameFileParser.Filter := ptFilter;
              TLameFileParser.GetFiles('.zip');
              for fs in TLameFileParser.TlistFiles do
              begin
                if fs.contains(sCodeClient) = True then
                begin
                  bOk := True;
                  // IniParam.Free;
                  // ValueSection.Free;
                  exit;
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
      try
        if TLameFileParser.noFile = False then
          oMsg := CreateMessageDialog(RST_NOCODE + ' (' + sCodeClient + ')', mtError, [mbOK])
        else
        begin
          // pas de fichiers sur la lame problème de connection ?
          oMsg := CreateMessageDialog(RST_NOFILE, mtError, [mbOK])
        end;

        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        oMsg.ShowModal;
      finally
        FreeAndNil(oMsg);
        pnlLame.Visible := False;
        RgChoice.Itemindex := -1;
        edtCode.SetFocus;
      end;
    end;

  finally
    IniParam.Free;
    ValueSection.Free;
  end;

end;

procedure TFrm_Serveur.BtnConnServEasyClick(Sender: TObject);
const
  Log_Key = 'BtnConnServEasyClick';
var
  VserverEasy, VfolderSrcEasy, VfolderSync, VfolderEasyOrigin: string;
  i, VFileDate: integer;
  InstallConnEasy: Tinstall;
  PathEmbarcaderoUDF: string;
  oMsg: TForm;
begin

  // on se connecte sur la base du serveur à partir duquel on va faire l'installation
  VserverEasy := StringReplace(StringReplace(cbListeServeur.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase]);
  sServeurConnexionPath := VserverEasy + ':' + cbLettre.Text + ':' + PathBaseServerEasy.Text;
  VfolderSync := ExtractFilePath('\\' + VserverEasy + '\' + cbLettre.Text + PathBaseServerEasy.Text);
  VfolderEasyOrigin := '\\' + VserverEasy + '\' + cbLettre.Text + '\Ginkoia\Easy\';

  // avant de se connecter, on vérifie que la Ginkcopy n'est pas trop ancienne et que le fichier de version.zip est présent
  if not FileExists(VfolderSync + 'ginkcopy.ib') then
  begin
    ShowMessage('La base de données n''a pas été trouvée sur le serveur distant');
    exit;
  end;


  // on vérifie que l'UDF de Easy est présent en local, sinon on le copie, si echec, on demande à faire manuellement.
  if (not FileExists('C:\Embarcadero\InterBase\UDF\sym_udf.dll')) and not (FileExists('D:\Embarcadero\InterBase\UDF\sym_udf.dll')) then
  begin
    PathEmbarcaderoUDF := '';

    if DirectoryExists('C:\Embarcadero\InterBase\UDF\') then
      PathEmbarcaderoUDF := 'C:\Embarcadero\InterBase\UDF\'
    else
    begin
      if DirectoryExists('D:\Embarcadero\InterBase\UDF\') then
        PathEmbarcaderoUDF := 'D:\Embarcadero\InterBase\UDF\';
    end;

    if PathEmbarcaderoUDF = '' then
    begin
      ShowMessage(RTS_ERROR_FINDINGUDF);
      exit;
    end;

    if not CopyFile(PWideChar(VfolderEasyOrigin + 'databases\interbase\sym_udf.dll'), PWideChar(PathEmbarcaderoUDF + 'sym_udf.dll'), False) then
    begin
      try
        oMsg := CreateMessageDialog(RTS_ERRORPUTUDF, mtWarning, [mbOK, mbCancel]);
        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        oMsg.ShowModal;
        if (oMsg.ModalResult = ID_CANCEL) then
        begin
          Exit;
        end;
      finally
        FreeAndNil(oMsg);
      end;
    end;
  end;

  // on vérifie que la base de synchro n'a pas plus de 48h
  VFileDate := FileAge(VfolderSync + 'ginkcopy.ib');
  VDateBaseSynchro := FileDateToDateTime(VFileDate);
  if HoursBetween(Now, VDateBaseSynchro) > 48 then
  begin
    ShowMessage('La base de données du serveur distant est trop ancienne pour l''installation');
    exit;
  end;

  //FileDateToDateTime()
  if not FileExists(VfolderSync + 'Version.zip') then
  begin
    ShowMessage('Le fichier Version.zip n''a pas été trouvé sur le serveur distant');
    pnlEasy.Visible := False;
    pnlTypeInstallEasy.Visible := False;
    pnlInstall.Visible := False;
    pnlmag.Visible := False;
    exit;
  end;

  InstallConnEasy := Tinstall.Create(sServeurConnexionPath); // create pour caisse
  try
    InstallConnEasy.Server := VserverEasy;
    InstallConnEasy.Drive := cbLettre.Text;
    InstallConnEasy.PathBdd := PathBaseServerEasy.Text;
    InstallConnEasy.Connexion := sServeurConnexionPath;

    InstallConnEasy.OpenServeur;
    if InstallConnEasy.Database.Error <> '' then
    begin
      ShowMessage('Impossible de se connecter à la base de données, vérifiez le chemin de connexion');
      pnlEasy.Visible := False;
      pnlTypeInstallEasy.Visible := False;
      pnlInstall.Visible := False;
      pnlmag.Visible := False;
      exit;
    end;

    // on vérifie si la base est bien sur Easy
    if not InstallConnEasy.IsEasy then
    begin
      ShowMessage('La base sélectionnée n''est pas sous Easy, le serveur doit être en synchronisation continue');
      pnlEasy.Visible := False;
      pnlTypeInstallEasy.Visible := False;
      pnlInstall.Visible := False;
      pnlmag.Visible := False;
      exit;
    end;

    VfolderSrcEasy := '\\' + InstallConnEasy.Server + '\' + InstallConnEasy.Drive + '\' + 'Ginkoia\EasyInstall\';
    // on cherche les sources d'installation Easy, d'abord dans le répertoire distant
    edtPathEasy.Text := SearchSourcesEasy(VfolderSrcEasy);

    // si pas trouvé en distant et en local on laisse le choix à l'utilisateur de choisir un dossier
    if (uFunctions.UsrLogged = UsrGin) or (Trim(edtPathEasy.Text) = '') then
      edtPathEasy.Enabled := True;

    // set des variables globales pour une installation Easy
    bIsEasy := True;
    sPathEasy := edtPathEasy.Text;

    // affichage du panneau easy
    pnlEasy.Visible := True;
    chkEasy.Checked := True;

    // affiche du panneau de choix du type d'installation
    // on remplit les options du panneau
    // on pré-rempli si on trouve un répertoire Ginkoia sur le disque
    edtPathBaseLocale.Text := SearchLocalGinkoiaPathBase();
    // si pas trouvé en local on laisse le choix à l'utilisateur de choisir un dossier
    if (uFunctions.UsrLogged = UsrGin) or (Trim(edtPathBaseLocale.Text) = '') then
      edtPathBaseLocale.Enabled := True;

    // on rempli la liste des postes disponibles pour le site connecté
    // on vide le tobjectlist
    if Assigned(ListBases) then
      ListBases.Clear;

    if bIsPortable then
      InstallConnEasy.GetListeBases(TypePortable, ListBases)
    else
      InstallConnEasy.GetListeBases(TypeCaisseSec, ListBases);

    cbChoixSite.Items.Clear;
    for i := 0 to ListBases.Count - 1 do
    begin
      cbChoixSite.Items.AddObject(InstallConnEasy.GetSenderName(ListBases[i]), ListBases[i]);
    end;

    // ShowMessage(ComboBox1.Items[ComboBox1.ItemIndex]);
    // cbLettre.Items.Add(DriveLetter);

    pnlTypeInstallEasy.Visible := True;
    pnlTypeInstallEasy.Align := alBottom; // repositionnement pour qu'il vienne se placer en dernière position
    pnlTypeInstallEasy.Align := alTop;
    pnlTypeInstallEasy.Visible := True;

  finally
    InstallConnEasy.Free;
  end;
end;

procedure TFrm_Serveur.btnDownloadClick(Sender: TObject);
const
  Log_Key = 'btnDownloadClick';
var
  fs: string;
begin

  if btnDownload.Tag = 0 then
  begin
    TLameFileParser.GetClientFiles(sCodeClient);

    if TLameFileParser.TClientFiles.Count > 1 then
    begin
      try
        Application.CreateForm(TFrm_SelectFile, Frm_SelectFile);
        Frm_SelectFile.Caption := Frm_SelectFile.Caption + ' ' + sCodeClient;
        if Frm_SelectFile.ShowModal = mrOk then
        begin
          fs := TLameFileParser.GetFullFileToDownloadPath;

        end
        else
        begin
          exit;
        end;
      finally
        Frm_SelectFile.Release;
        Frm_SelectFile := nil;
      end;
    end
    else
    begin
      TLameFileParser.GetFile(sCodeClient);
      fs := TLameFileParser.GetFullFileToDownloadPath;

    end;
    try
       // Log.Log(RST_DOWNLOADRL, logInfo);
      Log.Log(Log_Mdl, Log_Key, RST_DOWNLOADRL, logInfo, True, 0, ltBoth);
      TLameFileDownloader.SetUrl(fs);
      TLameFileDownloader.BeforeDownload := ptBeforeDownload;
      TLameFileDownloader.Progress := ptProgress;
      TLameFileDownloader.AfterDownload := ptAfterDownload;
      TLameFileDownloader.BeforeReset := ptBeforeReset;
      try
        TLameFileDownloader.Downloadfile(FROMLAME);
         // Log.Log(RST_ENDOFDOWNLOAD, logInfo);
        Log.Log(Log_Mdl, Log_Key, RST_ENDOFDOWNLOAD, logInfo, True, 0, ltBoth);
      finally
        TLameFileDownloader.Reset;
      end;
    except
      on E: Exception do
      begin
         // Log.Log(E.Message, logError);
        Log.Log(Log_Mdl, Log_Key, E.Message, logError, True, 0, ltBoth);
        ShowMessage(E.Message);
      end;
    end;

  end
  else
  begin
    // arrêter
    Fstop := True;
    Application.ProcessMessages;
    btnDownload.Tag := 0;
    Frm_Main.Tag := 0;
    btnDownload.Caption := RST_DOWNLOAD;
    // Tlogfile.Addline('****'+DateTimeToStr(now)+' '+ RST_STOPPEDBYUSER );
     // Log.Log(RST_STOPPEDBYUSER, logWarning);
    Log.Log(Log_Mdl, Log_Key, RST_STOPPEDBYUSER, logWarning, True, 0, ltBoth);
  end;
end;

{ ********************************************************Unzip********************************************************* }

procedure TFrm_Serveur.InitGestion(bIsGestion: boolean);
begin
  if bIsGestion then
    ItemSubtitle.Caption := 'Déploiement poste de gestion';
end;

procedure TFrm_Serveur.InitPortable(bIsLaptop: boolean);
begin
  // Procédure pour initialiser le déploiement d'un portable
  bIsPortable := False;

  if bIsLaptop then
  begin
    bIsPortable := True;

{$REGION 'Changement du visuel : Mode Portable'}
    ItemSubtitle.Caption := 'Déploiement portable';
{$ENDREGION}
    chkBasetest.Checked := False;
    Label7.Caption := 'Poste Portable :';
  end
  else
  begin
    lbl_ServerPrin.Visible := False;
    edt_ServerPrin.Visible := False;
    lbl_LetterDir.Visible := False;
    cbbLetterDir.Visible := False;
    chk_AddServ.Visible := False;
  end;

  ChoixChargementEnable(False);
end;

procedure TFrm_Serveur.InitCaisseSec();
begin
  // Procédure pour initialiser le déploiement d'un portable
  bRescueC := True;

{$REGION 'Changement du visuel : Mode caisse sec'}
  ItemSubtitle.Caption := 'Déploiement Caisse de secours';
  rbPosteList.Caption := 'Je choisis la caisse dans la liste :';
  lbl_ServerPrin.Caption := 'Nom Serveur :';
  Label7.Caption := 'Poste Serveur :';
{$ENDREGION}
  chkBasetest.Checked := False;

  edtCode.Enabled := False;
  ChoixChargementEnable(False);

  RgChoice.Itemindex := 3;

  // on positionne les élements du bloc du pnlmag pour le choix du poste en fin d'installation
  lblCaisseSec.Visible := True;
  cbPosteSecours.Visible := True;

  lbl_ServerPrin.Top := lbl_ServerPrin.Top + 30;
  edt_ServerPrin.Top := edt_ServerPrin.Top + 30;
  lbl_LetterDir.Top := lbl_LetterDir.Top + 30;
  cbbLetterDir.Top := cbbLetterDir.Top + 30;
  Btn_Finalize.Top := Btn_Finalize.Top + 30;
  pnlmag.Height := pnlmag.Height + 30;
  imgLang.Top := imgLang.Top + 30;
  lblLang.Top := lblLang.Top + 30;
  lblLangName.Top := lblLangName.Top + 30;
end;

function TFrm_Serveur.InstallServeur: boolean;
const
  Log_Key = 'InstallServeur';
var
  sTemp, sPassword: string;
  bSkipfile: boolean;
  InstallZip: Tinstall;
  bOk: boolean;
  i: integer;
  ResponseWebService, DateInstall, tmp: string;
  Year, Month, Day: string;

  function ShowMessagesed(sPath: string): boolean;
  var
    oMsg: TForm;
    s, sCode, sVille, sClient: string;
    sf: TArray<System.string>;
    // utilisation d'un generic de Delphi ;
  begin
    // confirmation de l'installation
    s := Tpath.GetFileNameWithoutExtension(sFiletoInstall);
    sf := s.Split(['_']);

    // on casse le nom du fichier en utilisant le '_' comme séparateur
    if length(sf) > 1 then
    begin
      sVille := sf[1];
      sCode := sf[2];
      sClient := sf[3];

      s := RST_CONFIRM + #10 + RST_CLIENT + ' ' + sClient + #10 + RST_CODE + ' ' + sCode + #10 + RST_VILLE + ' ' + sVille;
    end
    else
      s := RST_CONFIRM;

    try
      oMsg := CreateMessageDialog(s, mtConfirmation, [mbYES, mbNo]);
      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      if oMsg.ShowModal = IDYES then
      begin
        Result := True;
         // Log.Log(RST_CONFIRMED, logInfo);
        Log.Log(Log_Mdl, Log_Key, RST_CONFIRMED, logInfo, True, 0, ltBoth);
      end
      else
      begin
        Result := False;
         // Log.Log(RST_NOTCONFIRMED, logInfo);
        Log.Log(Log_Mdl, Log_Key, RST_NOTCONFIRMED, logInfo, True, 0, ltBoth);
      end;
    finally
      FreeAndNil(oMsg);
    end;

    pgBar.Visible := False;
    pgBar.Update;
    Btn_Install.Caption := RST_INSTALL;
    Btn_Install.Update;
    lblInfo.Caption := '';
    lblInfo.Visible := False;
    Application.ProcessMessages;
    exit(True);
  end;

begin
  try
    ForceDirectories(sLocation);
    lblEstimated.Visible := True;
    pgBar.Visible := True;
    pgBar.Position := 0;
    pgBar.Update;
    bRecupBase := False;
    InstallZip := Nil;

    sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
    if Tfile.Exists(sTemp) then
    begin
      Tfile.Delete(sTemp);
    end;

    // on passe le mot de passe de l'archive par défaut à présent
    sPassword := '1082';

     // Log.Log(RST_UNZIP, logInfo);
    Log.Log(Log_Mdl, Log_Key, RST_UNZIP, logInfo, True, 0, ltBoth);

    // Appel WebService
    // todo : Remettre le bon test quand l'url sera corrigée
    if (UsrLogged = UsrISF) and (not bIsEasy) and (1=0) then
    begin
      bOk := False;

      // On dézip le fichier dans le dossier temp
//      ForceDirectories(sLocation + '\TMP');
//      if not Unzip(sFiletoInstall, sLocation + '\TMP', sPassword) then
//        UnzipWithExe(sFiletoInstall, sLocation + '\TMP', sPassword);

      ForceDirectories(sLocation);

      if not Unzip(sFiletoInstall, sLocation, sPassword) then
        UnzipWithExe(sFiletoInstall, sLocation, sPassword);

      // Après avoir extrait les fichiers on lance le easyDeploy dans le cas d'un dossier Easy

      try
        InstallZip := Tinstall.Create(sLocation);
        if InstallZip.GetUrlWebService(sLocation + '\DATA\GINKOIA.IB') then
        begin
          if InstallZip.GetFromWebService(InstallZip.PathWebService, InstallZip.GUIID, UsrLogged, 'GET', ResponseWebService) then
          begin
            // erreur dans l'appel du webservice
            if (ContainsText(ResponseWebService, 'Erreur : ') and (UsrLogged = 'Nosymag')) then
            begin
              ShowMessage(ResponseWebService + #13#10 + 'Veuillez contacter Ginkoia ..');
               // Log.Log('Erreur webservice : ' + ResponseWebService, logError);
              Log.Log(Log_Mdl, Log_Key, 'Erreur webservice : ' + ResponseWebService, logError, True, 0, ltBoth);

              if UsrLogged = UsrISF then
                bOk := False;
            end;

            if ResponseWebService = '' then
            begin
              ShowMessage('Erreur dans l''appel du webservice');
               // Log.Log('Erreur dans l''appel du webservice', logError);
              Log.Log(Log_Mdl, Log_Key, 'Erreur dans l''appel du webservice', logError, True, 0, ltBoth);

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
                  Application.ProcessMessages;
                  //InstallZip.DelFilesDir(sLocation);
                  ShowMessage('Une installation a déjà été effectué le : ' + DateInstall + #13#10 + 'Installation impossible');
                   // Log.Log('Une installation a déjà été effectué le : ' + DateInstall + #13#10 + 'Installation impossible', logInfo);
                  Log.Log(Log_Mdl, Log_Key, 'Une installation a déjà été effectué le : ' + DateInstall + #13#10 + 'Installation impossible', logInfo, True, 0, ltBoth);
                  Btn_Install.Enabled := False;
                  AlreadyInstall := True;
                  bOk := False;
                end;
              end;
            end;

            // pas bon
            if Trim(ResponseWebService) <> '0' then
            begin
              if UsrLogged = UsrISF then
                bOk := False;
            end;

            if Trim(ResponseWebService) = '0' then
            begin
//              InstallZip.DelFilesDir(sLocation + '\TMP');
//              if not Unzip(sFiletoInstall, sLocation, sPassword) then
//                UnzipWithExe(sFiletoInstall, sLocation, sPassword);
              bOk := True;
            end;

            // if bOk = False then
            // begin
            // Install.Free;
            // Exit;
            // end;

          end;
        end;
      except
        on E: Exception do
        begin
          ShowMessage(E.Message);
        end;
      end;
    end
    else
    begin
      // todo : décommenter
      if not Unzip(sFiletoInstall, sLocation, sPassword) then
        UnzipWithExe(sFiletoInstall, sLocation, sPassword);
      //bOk := True;
    end;

    // don't touch il y a une bonne raison a cela
    if UsrLogged = UsrISF then
    begin
      if bOk then
        Result := True
      else
        Result := False;
    end
    else
    begin
      Result := True;
    end;

  finally
    if Assigned(InstallZip) then
      FreeAndNil(InstallZip);

    Btn_Install.Tag := 0;
    pgBar.Position := 0;
    lblInfo.Update;
    lblEstimated.Visible := False;
  end;
end;

procedure TFrm_Serveur.mnDeleteErrorFileClick(Sender: TObject);
var
  sTemp: string;
begin
  sTemp := IncludeTrailingPathDelimiter(Tpath.GetTempPath) + RST_LOG_FILE;
end;

procedure TFrm_Serveur.PathBaseServerEasyChange(Sender: TObject);
begin
  EnabledDisableConnexion();
end;

procedure TFrm_Serveur.rbBaseLocaleClick(Sender: TObject);
begin
  if rbBaseLocale.Checked then
  begin
    // on met le bon lecteur pour le chemin d'installation et on empêche de modifier le path (c'est celui de la base locale)
    cbDrive.Itemindex := cbDrive.Items.indexof(IncludeTrailingBackslash(ExtractFileDrive(edtPathBaseLocale.Text)));
    cbDrive.Enabled := False;

    sLocation := cbDrive.Text;
    sLocation := IncludeTrailingBackslash(sLocation) + 'GINKOIA';

    // affichage du panneau de choix du type d'installation et de celui d'installation finale
    pnlInstall.Visible := True;
    Btn_Install.Visible := True;
  end;
end;

procedure TFrm_Serveur.rbPosteListClick(Sender: TObject);
begin
  cbDrive.Enabled := True;
  // affichage du panneau de choix du type d'installation et de celui d'installation finale
  pnlInstall.Visible := True;
  Btn_Install.Visible := False;
  cbDrive.Itemindex := -1;
  sLocation := '';

  // si on est connecté en Nosymag et que le disque D existe, on ne laisse pas le choix du disque
//  if uFunctions.UsrLogged = 'Nosymag' then
//  begin
//    if DirectoryExists('D:') then
//    begin
//      // on met le bon lecteur pour le chemin d'installation et on empêche de modifier le path (c'est celui de la base locale)
//      cbDrive.Itemindex := cbDrive.Items.indexof(IncludeTrailingBackslash('D:'));
//      cbDrive.Enabled := False;
//
//      sLocation := cbDrive.Text;
//      sLocation := IncludeTrailingBackslash(sLocation) + 'GINKOIA';
//
//      cbDriveChange(Sender);
//
//      // affichage du panneau de choix du type d'installation et de celui d'installation finale
//      pnlInstall.Visible := True;
//      Btn_Install.Visible := True;
//    end;
//  end;

  // on autorise toujours à présent le choix du lecteur
end;

function TFrm_Serveur.AddLauncherToRegistry(): boolean;
var
  reg: TRegistry;
  vLauncher: string;
begin
  // On essaye d'ecrire la valeur
  try
    reg := TRegistry.Create(KEY_WRITE);
    try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
      reg.WriteString('Launch_Replication', cbDrive.Text + 'ginkoia\' + LAUNCHEREASY)
    finally
      reg.CloseKey;
      reg.Free;
    end;
  except
    on E: Exception do
    begin
      // result:=false;
      Log.Log(Log_Mdl, 'AddLauncherToRegistry', 'Erreur lors de l''ajout du launcher EASY au registre', logError, True, 0, ltBoth);
    end;
  end;

  // On regarde si c'est bon
  Result := False;
  try
    reg := TRegistry.Create(KEY_READ);
    try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
      vLauncher := reg.ReadString('Launch_Replication');
      if UpperCase(cbDrive.Text + 'ginkoia\' + LAUNCHEREASY) <> UpperCase(vLauncher) then
        Result := False
      else
        Result := True;
    finally
      reg.CloseKey;
      reg.Free;
    end;
  except
    on E: Exception do
    begin
      Log.Log(Log_Mdl, 'AddLauncherToRegistry', 'Erreur lors de l''ajout du launcher EASY au registre', logError, True, 0, ltBoth);
      Result := False;
    end;
  end;
end;

end.


unit CaisseSecours_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  stdActns,
  System.IOUtils,
  // Uses perso
  uNetwork,
  //uLogfile, anciens logs
  uLog,
  uInstallbase,
  uFunctions,
  uRessourcestr,
  UPatchDll,
  // Fin Uses perso
  Vcl.Graphics,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

const
  Log_Mdl = 'CaisseSecours';

type
  TFrm_CaisseSecours = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    ItemSubtitle: TLabel;
    lblNomServeur: TLabel;
    cbListeServeur: TComboBox;
    cbLettre: TComboBox;
    edBddPath: TEdit;
    lblD: TLabel;
    lblLettre: TLabel;
    edGinkoia: TButtonedEdit;
    lblInstallPath: TLabel;
    lblConnexionPath: TLabel;
    edConnexionPath: TEdit;
    OpenFileXP: TOpenDialog;
    Openfile: TFileOpenDialog;
    btnConnect: TButton;
    btnDisConnect: TButton;
    btnInstall: TButton;
    lblMagasin: TLabel;
    cbMagasin: TComboBox;
    lblPoste: TLabel;
    cbPoste: TComboBox;
    cbPosteSecours: TComboBox;
    lblPosteSecours: TLabel;
    lbl_nameServSecours: TLabel;
    cbbServDistantSec: TComboBox;
    lbl_LetterDirDistant: TLabel;
    cbb_LetterDirDistant: TComboBox;
    edt_eddPathSecDistant: TEdit;
    lbl_PatchDistant: TLabel;
    lblInfo: TLabel;
    imgLang: TImage;
    lblLang: TLabel;
    lblLangName: TLabel;
    chkCash: TCheckBox;
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edGinkoiaRightButtonClick(Sender: TObject);
    procedure edBddPathChange(Sender: TObject);
    procedure cbLettreChange(Sender: TObject);
    procedure edGinkoiaChange(Sender: TObject);
    procedure cbListeServeurChange(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure cbMagasinChange(Sender: TObject);
    procedure btnDisConnectClick(Sender: TObject);
    procedure cbPosteSecoursChange(Sender: TObject);
    procedure cbPosteChange(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure cbbServDistantSecChange(Sender: TObject);
    procedure cbb_LetterDirDistantChange(Sender: TObject);
  private
    { Déclarations privées }
    Install: Tinstall;
    NomDuPoste, NomDuPosteDeSecours: string;

    ptrAddshop: TAddshop;
    ptrAddPoste: TAddposte;
    ptrAddPosteSecorus: TAddposte;

    function GetVolumeLabel(DriveChar: Char): String;
    function GetcbListeServeur: string;
    procedure ConnexionConcat;
    procedure CheckConnection;
    procedure Initialisation;
    procedure EtatCompoConnexion(Etat: Boolean);
    procedure ValidInstall;

    function CreateBat(aApplication: string): Boolean;
    procedure ConnexionConcatDist;
    function GetcbListeServeurDist: string;
    function UpdatePatchInstall(LetterDir: string): Boolean;
  public
    { Déclarations publiques }
    isServerSec: Boolean;
    bIsEasy: Boolean;

    procedure EnumNetworkProc(const aNetResource: TNetResource; const aLevel: word; var aContinue: Boolean);

    procedure ChangeMode(ModeSec: Boolean);
  end;

var
  Frm_CaisseSecours: TFrm_CaisseSecours;

implementation

Uses
  Main_Frm,
  Main_Dm,
  ProgressBar_Frm,
  ServicesInstall_Frm;

{$R *.dfm}

procedure TFrm_CaisseSecours.btnConnectClick(Sender: TObject);
begin
  Frm_Main.Tag := 1;
  Initialisation;
end;

procedure TFrm_CaisseSecours.btnDisConnectClick(Sender: TObject);
begin
  FreeAndNil(Install);

  cbMagasin.Clear;
  cbPoste.Clear;
  cbPosteSecours.Clear;

  EtatCompoConnexion(True); // Réactive les composants de connexion

  btnConnect.Enabled := True;
  btnDisConnect.Enabled := False;
  btnInstall.Enabled := False;
  Frm_Main.Tag := 0;
end;

procedure TFrm_CaisseSecours.btnInstallClick(Sender: TObject);
Const
	Log_Key = 'btnInstallClick';
var
  bOk: Boolean;
  AlreadyInstal: Boolean;
  a: Char;
  i: integer;
  ResponseWebService, DateInstall, tmp: string;
  Pos1, Pos2, CountNb: integer;
  Year, Month, Day: String;
  PathMajLetterDir: String;
  vLocalDrive: string;
  TypeInstall: TTypeInstall;
  bCash: Boolean;
  oMsg: TForm;
  aGenParam: TGenParam;
  vMagid, vPosID: Integer;
  vGuid: String;
  vCaisseSecHost: String;
  vGinkoiaPath: String;
  vCashDistantFolder: String;
begin
  bOk := False;
  // si c'est une installation de CASH
  bCash := chkCash.Checked;
  vGinkoiaPath := IncludeTrailingPathDelimiter(edGinkoia.Text);

  vLocalDrive := '';
  try
    try
      Log.Log(Log_Mdl,Log_Key, RST_MAG + cbMagasin.Text + ' ' + RST_POSTE + cbPoste.Text + ' - Instalation des patchs BPL', logInfo, True, 0, ltBoth);
      Install.SetPathBPL;

      // si on a choisi cash, on met à jour les GENPARAM du poste par défaut et du type de caisse par défaut
      if bCash then
      begin
        vCashDistantFolder := '\\' + GetcbListeServeur + '\ginkoia\CASH\';

        // on vérifie que le répertoire cash existe en local, ainsi que les exe, sinon on les copies depuis le serveur
        bOk := CheckIfCashFolderExists(vCashDistantFolder, vGinkoiaPath + 'CASH');


        vMagid := Integer(cbMagasin.Items.Objects[cbMagasin.Itemindex]);
        vPosID := Integer(cbPoste.Items.Objects[cbPoste.Itemindex]);

        // caisse par défaut
        aGenParam.prm_string := 'cash';
        Install.SetGENPARAM(666, 205, vMagid, vPosID, aGenParam);

        // Renseigner le poste utilisé (pour ne pas le demander lors du premier lancement de CASH)
        vGuid := Install.GetGENPARAM(666, 120, PRM_STRING);
        aGenParam.prm_string := getMachineGuid;
        aGenParam.prm_integer := Install.GetBasIdFromMagID(vMagid);
        if aGenParam.prm_integer = 0 then  // on a pas trouvé le bas_id
        begin
          Showmessage('Impossible de trouver l''identifiant de base du poste.');
        end;
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
              Install.SetGENPARAM(666, 120, vMagid, vPosID, aGenParam);
            end;
          finally
            oMsg.Release
          end;
        end
        else
          Install.SetGENPARAM(666, 120, vMagid, vPosID, aGenParam);
      end;

      // Installation d'une caisse de secours cliente
        if edGinkoia.Text <> '' then
          vLocalDrive := edGinkoia.Text[1];

//      if not isServerSec then
//      begin
//        i := 0;
//        // cbLettre.Clear;
//        for a := 'C' to 'Z' do
//        begin
//          if DirectoryExists(a + ':\GINKOIA') then
//          begin
//            edGinkoia.Text := a + ':\GINKOIA';
//          end;
//        end;
//      end;


//        //Log.Log('Création des fichiers .ini', logInfo);
//        Log.Log(Log_Mdl,Log_Key, 'Création des fichiers .ini', logInfo, True, 0, ltBoth);
//        Install.CreateIniCaisseSecours(vLocalDrive, edGinkoia.Text + '\data\Ginkoia.IB', edConnexionPath.Text, cbMagasin.Text, cbPoste.Text, cbPosteSecours.Text,
//          edt_eddPathSecDistant.Text, isServerSec);
//      end
//      else
//      begin
        Log.Log(Log_Mdl,Log_Key, 'Préparation mise à jour Path', logInfo, True, 0, ltBoth);
        if Install.UpdatePatchInstall(edGinkoia.Text[1], edGinkoia.Text + '\data\Ginkoia.IB', cbMagasin.Text) then
          Log.Log(Log_Mdl,Log_Key, 'Mise à jour du chemin d''install de la base de données', logInfo, True, 0, ltBoth)
        else
          Log.Log(Log_Mdl,Log_Key, 'Erreur dans la mise a jour du path de ginkoia', logInfo, True, 0, ltBoth);

        Install.CreateIniCaisseSecours(edGinkoia.Text[1], edGinkoia.Text + '\data\Ginkoia.IB', edConnexionPath.Text, cbMagasin.Text, cbPoste.Text,
          cbPosteSecours.Text, edt_eddPathSecDistant.Text, isServerSec);
//      end;

      // ***************************************************
    // Partie pour l'installation automatique des services
    // ***************************************************
    if isServerSec then
    begin
      TypeInstall := InstallTypeCaisseSec;

      Application.CreateForm(TFrmServicesInstall, Frm_ServicesInstall);
      Frm_ServicesInstall.Position := TPosition.poMainFormCenter;
      Frm_ServicesInstall.FormStyle := fsStayOnTop;
      Frm_ServicesInstall.TypeInstall := TypeInstall;
      Frm_ServicesInstall.PathGinkoia := vLocalDrive + ':\ginkoia\';
      Frm_ServicesInstall.ListModules := Install.GetModules();

      Frm_ServicesInstall.ShowModal;

      Frm_ServicesInstall.Release;
      Frm_ServicesInstall := Nil;
      // *************************************************************
      // ** Fin Partie pour l'installation automatique des services **
      // *************************************************************
    end;

      //Log.Log('Création des fichiers bats et raccourcis', logInfo);
      Log.Log(Log_Mdl,Log_Key, 'Création des fichiers bats et raccourcis', logInfo, True, 0, ltBoth);

      // plus de bat
//      if CreateBat(GINKOIA) then
//        bOk := True;

      // raccourci de Ginkoia
      if uFunctions.UsrLogged = 'Nosymag' then
        bOk := Install.Machine.CreateShortcut('Nosymag', vGinkoiaPath + GINKOIA, 'Nosymag', vGinkoiaPath, vGinkoiaPath + GINKOIA)
      else
        bOk := Install.Machine.CreateShortcut('Ginkoia', vGinkoiaPath + GINKOIA, 'Ginkoia', vGinkoiaPath, vGinkoiaPath + GINKOIA);


      if bOk then
      begin
        if bCash then
        begin
          if isServerSec then
            vCaisseSecHost := 'localhost'
          else
            vCaisseSecHost := GetcbListeServeurDist;

          Install.Machine.CreateRaccourciAndIniCASH(vGinkoiaPath, TypeCaisseSec, GetcbListeServeur, vCaisseSecHost);
        end
        else
        begin
          bOk := Install.Machine.CreateShortcut('Caisse', vGinkoiaPath + CAISSE, 'Caisse', vGinkoiaPath, vGinkoiaPath + CAISSE);

          //bOk := CreateBat(CAISSE);

          if bOk then
            bOk := CreateBat(CAISSESECOUR);
        end;
      end;

      if isServerSec then
        if bOk then
          CreateBat(LAUNCHER);

      if bOk then
      begin
        //Log.Log('Fin Création des fichiers bats et raccourcis', logInfo);
        Log.Log(Log_Mdl,Log_Key, 'Fin Création des fichiers bats et raccourcis', logInfo, True, 0, ltBoth);

        if Install.GetUrlWebService(edGinkoia.Text + '\data\Ginkoia.IB') then
          if Install.SetFromWebService(Install.PathWebService, Install.GUIID, UsrLogged, 'SET', ResponseWebService) then
          begin
            if ResponseWebService = 'Ok' then
            begin
              //Log.Log('Date d''installation enregistrer sur maintenance', logInfo);
              Log.Log(Log_Mdl,Log_Key, 'Date d''installation enregistrée sur maintenance', logInfo, True, 0, ltBoth);
            end
            else
            begin
              //Log.Log('Erreur dans l''enregistrement de la date install - WEBSERVICE', logError);
              Log.Log(Log_Mdl,Log_Key, 'Erreur dans l''enregistrement de la date install - WEBSERVICE', logInfo, True, 0, ltBoth);
            end;
          end;
      end
      else
      begin
        //Log.Log('Erreur lors de la création des fichiers bats et raccourcis ', logInfo);
        Log.Log(Log_Mdl,Log_Key, 'Erreur lors de la création des fichiers bats et raccourcis', logError, True, 0, ltBoth);
      end;

    finally
      Frm_Main.Tag := 0;
      if bOk then
      begin

        // Lancement de vérification.exe   (Seulement mode serveur)
        if isServerSec then
        begin
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

          LunchVerif(True);

        end;

        // Delete zip file
        if UPatchDll.FileInstallBase <> '' then
          UPatchDll.DelAppli(UPatchDll.FileInstallBase);

        ShowMessage('Installation de la caisse de secours terminée');
        //Log.Log('Installation de la caisse de secours terminée', logInfo);
        Log.Log(Log_Mdl,Log_Key, 'Installation de la caisse de secours terminée', logInfo, True, 0, ltBoth);

        // On revient à l'écran principal
        Image1Click(Sender);
      end
      else
      begin
        ShowMessage('Problème lors de l''installation consultez les logs.');
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Problème lors de l''installation, consultez les logs. Message : ' + E.Message);
      //Log.Log('Problème lors de l''installation, consultez les logs. Message : ' + E.Message, logError);
      Log.Log(Log_Mdl,Log_Key, 'Problème lors de l''installation : ' + E.Message, logInfo, True, 0, ltBoth);
      exit;
    end;
  end;
end;

procedure TFrm_CaisseSecours.cbbServDistantSecChange(Sender: TObject);
begin
  ConnexionConcatDist;
  CheckConnection;
end;

procedure TFrm_CaisseSecours.cbb_LetterDirDistantChange(Sender: TObject);
begin
  ConnexionConcatDist;
  CheckConnection;
end;

procedure TFrm_CaisseSecours.cbLettreChange(Sender: TObject);
begin
  ConnexionConcat;
  CheckConnection;
end;

procedure TFrm_CaisseSecours.edBddPathChange(Sender: TObject);
begin
  ConnexionConcat;
  CheckConnection;
end;

procedure TFrm_CaisseSecours.edGinkoiaChange(Sender: TObject);
begin
  CheckConnection;
end;

procedure TFrm_CaisseSecours.edGinkoiaRightButtonClick(Sender: TObject);
begin
  if IsVistaOrHigher then
  begin
    Openfile.DefaultFolder := Tpath.GetTempPath;
    if Openfile.Execute then
    begin
      edGinkoia.Text := Openfile.FileName;
    end;
  end
  else
  begin
    // xp
    with TBrowseForFolder.Create(nil) do
    begin
      try
        // RootDir  := 'C:\';

        if Execute then
          edGinkoia.Text := Folder;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TFrm_CaisseSecours.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Main.Tag := 0; // pour permettre la fermeture de la fenêtre principale.

  if assigned(Install) then
    if Install.Server <> '' then
      FreeAndNil(Install); // SR - Libération de l'insatallation.

  Action := caFree;

end;

procedure TFrm_CaisseSecours.FormCreate(Sender: TObject);
Var
  a: Char;
  DriveLetter: String;
  i: integer;
  TmpGin: string;
begin
  // initialisation du fichier log en mode Add
  // Tlogfile.InitLog(False);

  // **** Création des procédures propre à la form ****//
  ptrAddshop := procedure(Magasin: string; aMagID: Integer)
    begin
      //cbMagasin.Items.Add(Magasin);
      cbMagasin.Items.AddObject(Magasin, TObject(aMagID));
      if Magasin = Install.MagasinSurServeur then
      begin
        cbMagasin.ItemIndex := cbMagasin.Items.Count - 1;
      end;
    end;

  ptrAddPoste := procedure(Poste: string; aPosID: Integer)
    begin
      cbPoste.Items.AddObject(Poste, TObject(aPosID));
      cbPosteSecours.Items.AddObject(Poste, TObject(aPosID));

//      cbPoste.Items.Add(Poste);
//      cbPosteSecours.Items.Add(Poste);
      if NomDuPoste = Poste then
      begin
        cbPoste.ItemIndex := cbPoste.Items.Count - 1;
        cbPosteSecours.ItemIndex := cbPosteSecours.Items.Count - 1;
      end;
    end;

  ptrAddPosteSecorus := procedure(Poste: string; aPosID: integer)
    begin
      //cbPosteSecours.Items.Add(Poste);
      cbPosteSecours.Items.AddObject(Poste, TObject(aPosID));
      if NomDuPoste = Poste then
      begin
        cbPosteSecours.ItemIndex := cbPosteSecours.Items.Count - 1;
      end;
    end;
  // ****************************************************//

  // **** Recherche des machines sur le réseau ****//
  cbListeServeur.Clear;
  if MessageDlg('Souhaitez-vous faire une recherche des postes sur le réseau ?', mtInformation, mbYesNo, 0) = mrYes then
  begin
    // try
    // Screen.Cursor := crHourGlass;
    // Application.CreateForm(TFrm_ProgressBar, Frm_ProgressBar);
    // Frm_ProgressBar.Show;
    // // Frm_ProgressBar.ShowModal;
    // finally
    // Frm_ProgressBar.Free;
    // Screen.Cursor := crDefault;
    // end;

    Screen.Cursor := crHourGlass;
    Application.CreateForm(TFrm_ProgressBar, Frm_ProgressBar);
    Frm_ProgressBar.ShowModal;
    if ((Frm_ProgressBar.ModalResult = mrCancel) or (Frm_ProgressBar.ModalResult = mrOk)) then
      Frm_ProgressBar.Free;
    Screen.Cursor := crDefault;
  end;
  // **********************************************//

  i := 0;
  // **** Les lettres des disques ****//
  cbLettre.Clear;
  for a := 'C' to 'Z' do
  begin
    DriveLetter := a;
    cbLettre.Items.Add(DriveLetter);
  end;

  i := 0;
  cbb_LetterDirDistant.Clear;
  for a := 'C' to 'Z' do
  begin
    DriveLetter := a;
    cbb_LetterDirDistant.Items.Add(DriveLetter);
  end;

  edBddPath.Text := '\Ginkoia\data\Ginkoia.ib'; // Par défaut le dossier de la BDD

  edt_eddPathSecDistant.Text := '\Ginkoia\data\Ginkoia.ib';

  if assigned(Install) then
    if Install.PathBdd <> '' then
      edGinkoia.Text := Install.PathBdd;

  // Recherche de la base de donnée Ginkoia
  i := cbLettre.Items.Count;

  for i := 0 to i do
  begin
    TmpGin := cbLettre.Items[i];

    if ((FileExists(TmpGin + '\Ginkoia\data\ginkoia.ib')) and (TmpGin <> '')) then
      edGinkoia.Text := TmpGin + '\GINKOIA\';
  end;

  // On cherche un répertoire par défaut pour l'installation locale de Ginkoia
  edGinkoia.Text := StringReplace(SearchLocalGinkoiaPathBase(), 'data\ginkoia.ib', '', [rfReplaceAll, rfIgnoreCase]);
end;

function TFrm_CaisseSecours.GetVolumeLabel(DriveChar: Char): String;
var
  NotUsed: DWORD;
  VolumeFlags: DWORD;
  VolumeInfo: array [0 .. MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
  Buf: array [0 .. MAX_PATH] of Char;
begin
  // Fonction permettant de récupérer les lettres des disques
  GetVolumeInformation(PChar(DriveChar + ':\'), Buf, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed, VolumeFlags, nil, 0);

  SetString(Result, Buf, StrLen(Buf)); { Set return result }
  Result := AnsiUpperCase(Result);
end;

procedure TFrm_CaisseSecours.Image1Click(Sender: TObject);
begin
  // on ferme la fenêtre

  if assigned(Install) then
    FreeAndNil(Install);

  Postmessage(handle, WM_CLOSE, 0, 0);
  Self.FreeOnRelease;
end;

procedure TFrm_CaisseSecours.Initialisation;
const
  Log_Key = 'Initialisation';
var
  vConnexionPath: String;
begin
  // Initialisation procedure
  try
    btnConnect.Enabled := False;

//    Log.Log(RST_SERVER + edConnexionPath.Text);
//    Log.Log(RST_GINKOIA + IncludeTrailingPathDelimiter(edGinkoia.Text));
    Log.Log(Log_Mdl,Log_Key, RST_SERVER + edConnexionPath.Text + ' ' + RST_GINKOIA + IncludeTrailingPathDelimiter(edGinkoia.Text), logInfo, True, 0, ltBoth);

    vConnexionPath := ExtractFilePath(edConnexionPath.Text);

    Install := Tinstall.Create(edGinkoia.Text, vConnexionPath); // create pour caisse
    Install.Server := GetcbListeServeur;
    Install.Drive := cbLettre.Text;
    Install.PathBdd := edBddPath.Text;
    Install.Connexion := edConnexionPath.Text;

    // ***********************************************************************
    Install.GetMagasinSurServeurSecours;
    NomDuPoste := Install.Machine.NomDuPoste;


    //Log.Log(RST_AKOI + Install.Connexion, logInfo);
    Log.Log(Log_Mdl,Log_Key, RST_AKOI + Install.Connexion, logInfo, True, 0, ltBoth);

    // ShowMessage(Install.Connexion);
    Install.OpenServeur;
    if Install.Database.Error <> '' then // Si connexion en erreur
    begin
      //Log.Log(Install.Database.Error, logInfo);
      Log.Log(Log_Mdl,Log_Key, Install.Database.Error, logError, True, 0, ltBoth);

      btnConnect.Enabled := True;
      btnDisConnect.Enabled := False;

      ShowMessage(Install.Database.Error);
      // ShowMessage('Pour information le serveur Interbase est en version : ' +
      // Dm_Main.GetVersionIBServeur(Install.Server));

      ShowMessage('Pour information le serveur Interbase est en version : ' + Frm_Main.GetVersInterbase);
    end
    else
    begin
      // ******************* gestion de la langue ********************
      Install.SetLanguage;

      // si la base est élibigle à cash
      if Install.CanInstallCash then
      begin
        chkCash.Visible := True;
        chkCash.Enabled := True;
        chkCash.Checked := False;
      end;

      // on met à jour les paramètres régionaux si pas en français
      if Install.Language.UpdateRegionals then
        SetRegionToFr();
      lblLangName.Caption := Install.Language.Name;
      Dm_Main.ImgListLng.GetIcon(Install.Language.ImgIndex, imgLang.Picture.Icon);
      lblLangName.Visible := True;
      lblLang.Visible := True;
      // ****************** fin de la langue *************************


      bIsEasy := Install.IsEasy();

      cbMagasin.Items.Clear;
      cbMagasin.Text := '';
      cbMagasin.Enabled := True;

      cbPoste.Items.Clear;
      cbPoste.Text := '';
      cbPoste.Enabled := True;

      cbPosteSecours.Items.Clear;
      cbPosteSecours.Text := '';
      cbPosteSecours.Enabled := False;

      Install.AddShop := ptrAddshop;
      Install.AddPoste := ptrAddPoste;
      Install.GetShop;

      cbMagasin.OnChange(Self);

      // Tlogfile.Addline(Datetimetostr(Now)+' '+RST_CONNECTED);
      //Log.Log(RST_CONNECTED, logInfo);
      Log.Log(Log_Mdl,Log_Key, RST_CONNECTED, logInfo, True, 0, ltBoth);

      EtatCompoConnexion(False);

      btnConnect.Enabled := False;
      btnDisConnect.Enabled := True;

      if cbListeServeur.Text <> '' then
        // Showmessage(RST_CONNECTED +
        // ' - Pour information le serveur Interbase est en version : ' +
        // Dm_Main.GetVersionIBServeur(Install.Server));

        ShowMessage(RST_CONNECTED + ' - Pour information le serveur Interbase est en version : ' + Frm_Main.GetVersInterbase);
    end;

  finally

  end;
end;

function TFrm_CaisseSecours.UpdatePatchInstall(LetterDir: string): Boolean;
begin
  // Update
end;

function TFrm_CaisseSecours.GetcbListeServeur: string;
begin
  Result := StringReplace(StringReplace(cbListeServeur.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase])
end;

function TFrm_CaisseSecours.GetcbListeServeurDist: string;
begin
  Result := StringReplace(StringReplace(cbbServDistantSec.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase])
end;

procedure TFrm_CaisseSecours.ConnexionConcat;
begin
  if cbListeServeur.Text = '' then
    edConnexionPath.Text := cbLettre.Text + ':' + edBddPath.Text
  else
    edConnexionPath.Text := GetcbListeServeur + ':' + cbLettre.Text + ':' + edBddPath.Text;
end;

procedure TFrm_CaisseSecours.ConnexionConcatDist;
begin
  if cbbServDistantSec.Text = '' then
  begin
    edt_eddPathSecDistant.Text := cbb_LetterDirDistant.Text + ':' + edt_eddPathSecDistant.Text;
  end
  else
  begin
    edt_eddPathSecDistant.Text := ':\Ginkoia\data\Ginkoia.ib';
    edt_eddPathSecDistant.Text := GetcbListeServeurDist + ':' + cbb_LetterDirDistant.Text + edt_eddPathSecDistant.Text;
  end;
end;

function TFrm_CaisseSecours.CreateBat(aApplication: string): Boolean;
Const
	Log_Key = 'CreateBat';
var
  tmp: TStringList;
  sFile: string;
  i, sNb: integer;
  Res, Res_Icon: TResourceStream;
  sRep, sBat, sIcon, sNameServ: string;
begin
  Result := True;
  tmp := TStringList.Create;
  try
    try
      if GetcbListeServeur <> '' then
        sFile := '\\' + GetcbListeServeur + '\ginkoia\Batch\' + sBat
      else
        sFile := edGinkoia.Text[1] + ':\ginkoia\Batch\' + sBat;

      if Tfile.Exists(sFile) = False then
      begin
        sRep := ExtractFilePath(Application.ExeName);
        sBat := 'MODEL.BAT';

        if sRep[length(sRep)] <> '\' then
          sRep := sRep + '\';

        Res := TResourceStream.Create(0, 'MODEL', RT_RCDATA);
        try
          ForceDirectories(sRep);
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
        tmp.Strings[i] := StringReplace(tmp.Strings[i], '%SERVEUR%', GetcbListeServeur, [rfReplaceAll, rfIgnoreCase]);
        tmp.Strings[i] := StringReplace(tmp.Strings[i], '%LOCAL%', edGinkoia.Text[1] + ':\GINKOIA', [rfReplaceAll, rfIgnoreCase]);
        tmp.Strings[i] := StringReplace(tmp.Strings[i], '%PROG%', edGinkoia.Text[1] + ':\GINKOIA\' + aApplication, [rfReplaceAll, rfIgnoreCase]);
      end;
    finally

      sNameServ := '\\' + Trim(GetcbListeServeur);

      if aApplication = GINKOIA then
      begin
        ForceDirectories('\\' + GetcbListeServeur + '\ginkoia\Batch\');
        tmp.SaveToFile('\\' + GetcbListeServeur + '\ginkoia\Batch\Ginkoia' + edGinkoia.Text[1] + '.BAT');

        if uFunctions.UsrLogged = 'Nosymag' then
        begin
          //Log.Log('sNameServ = ' + sNameServ, logInfo);
          Log.Log(Log_Mdl,Log_Key, 'sNameServ = ' + sNameServ, logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Nosymag', sNameServ + '\' + cbLettre.Text + '\ginkoia\Batch\Ginkoia' + edGinkoia.Text[1] + '.BAT', 'Nosymag',
            edGinkoia.Text[1] + ':\GINKOIA\', edGinkoia.Text[1] + ':\GINKOIA\' + GINKOIA);

        end
        else
        begin
//          Log.Log('sNameServ = ' + sNameServ, logInfo);
//          Log.Log('Creation du raccourci Ginkoia', logInfo);
//          Log.Log(' edGinkoia = ' + edGinkoia.Text, logInfo);
//          Log.Log(' cbLettre = ' + cbLettre.Text, logInfo);
          Log.Log(Log_Mdl,Log_Key, 'sNameServ = ' + sNameServ + ' - Creation du raccourci Ginkoia. edGinkoia = ' + edGinkoia.Text + ', cbLettre = ' + cbLettre.Text, logTrace, True, 0, ltBoth);


          Install.Machine.CreateShortcut('Ginkoia', sNameServ + '\' + cbLettre.Text + '\ginkoia\Batch\Ginkoia' + edGinkoia.Text[1] + '.BAT', 'Ginkoia',
            edGinkoia.Text[1] + ':\GINKOIA\', edGinkoia.Text[1] + ':\GINKOIA\' + GINKOIA);

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
            ForceDirectories(sRep);
            Res.SaveToFile(sRep + sBat);
            // Res_Icon.SaveToFile(sRep + sIcon);
            Res_Icon.SaveToFile(edGinkoia.Text[1] + ':\GINKOIA\' + sIcon);
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
        // edGinkoia.Text[1] + ':\ginkoia\CAISSEGINKOIA.exe',
        // 'Caisse',
        // edGinkoia.Text[1]+':\GINKOIA\', sRep + sIcon);

        Install.Machine.CreateShortcut('Caisse de secours', edGinkoia.Text[1] + ':\ginkoia\CAISSEGINKOIA.exe', 'Caisse', edGinkoia.Text[1] + ':\GINKOIA\',
          edGinkoia.Text[1] + ':\GINKOIA\' + sIcon);
        //Log.Log('Creation du raccourci caisse de secours', logInfo);
        Log.Log(Log_Mdl,Log_Key, 'Creation du raccourci caisse de secours', logInfo, True, 0, ltBoth);
      end;

      if aApplication = CAISSE then
      begin
        ForceDirectories('\\' + GetcbListeServeur + '\ginkoia\Batch\');
        tmp.SaveToFile('\\' + GetcbListeServeur + '\ginkoia\Batch\Caisse' + edGinkoia.Text[1] + '.BAT');

//        Log.Log('Creation du raccourci caisse Ginkoia', logInfo);
//        Log.Log('edtGinkoia = ' + edGinkoia.Text + ':\GINKOIA\', logInfo);
//        Log.Log('cbLettre = ' + cbLettre.Text, logInfo);
        Log.Log(Log_Mdl,Log_Key, 'Creation du raccourci caisse Ginkoia - edtGinkoia = ' + edGinkoia.Text + ':\GINKOIA\ - cbLettre = ' + cbLettre.Text, logInfo, True, 0, ltBoth);

        Install.Machine.CreateShortcut('Caisse', sNameServ + '\' + cbLettre.Text + '\ginkoia\Batch\Caisse' + edGinkoia.Text[1] + '.BAT', 'Caisse',
          edGinkoia.Text[1] + ':\GINKOIA\', edGinkoia.Text[1] + ':\GINKOIA\' + CAISSE);

      end;

      if aApplication = LAUNCHER then
      begin
        if bIsEasy then
        begin
         // Log.Log('Creation du raccourci Launcher Easy', logInfo);
          Log.Log(Log_Mdl,Log_Key, 'Creation du raccourci Launcher Easy', logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Synchronisation', edGinkoia.Text[1] + ':\ginkoia\' + LAUNCHEREASY, 'Synchronisation',
            edGinkoia.Text[1] + ':\GINKOIA\', edGinkoia.Text[1] + ':\GINKOIA\' + LAUNCHEREASY);
        end
        else
        begin
          //Log.Log('Creation du raccourci Launcher', logInfo);
          Log.Log(Log_Mdl,Log_Key, 'Creation du raccourci Launcher Delos', logInfo, True, 0, ltBoth);
          Install.Machine.CreateShortcut('Launcher', edGinkoia.Text[1] + ':\ginkoia\LAUNCHV7.exe', 'Launcher', edGinkoia.Text[1] + ':\GINKOIA\',
            edGinkoia.Text[1] + ':\GINKOIA\' + LAUNCHER);
        end;
      end;

      tmp.Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Erreur lors de la création du fichier batch : ' + E.Message);
      //Log.Log('Erreur lors de la création du fichier batch : ' + E.Message);
      Log.Log(Log_Mdl,Log_Key, 'Erreur lors de la création du fichier batch : ' + E.Message, logInfo, True, 0, ltBoth);
      exit;
    end;
  end;
end;

procedure TFrm_CaisseSecours.cbListeServeurChange(Sender: TObject);
begin
  ConnexionConcat;
  CheckConnection;
end;

procedure TFrm_CaisseSecours.cbMagasinChange(Sender: TObject);
begin
  ValidInstall;

  // SR - On vide la combo et on charge les postes
  cbPoste.Clear;
  cbPosteSecours.Clear;
  if cbMagasin.ItemIndex > -1 then
  begin
    Install.GetPoste(cbMagasin.Text);
  end;
end;

procedure TFrm_CaisseSecours.cbPosteChange(Sender: TObject);
var
  i: integer;
  bOk: Boolean;
begin
  // charge automatiquement caisse_sec
  i := cbPosteSecours.Items.Count;
  bOk := False;
  for i := 0 to i do
  begin
    if cbPoste.Text + '_SEC' = cbPosteSecours.Items[i] then
    begin
      cbPosteSecours.ItemIndex := i;
      bOk := True
    end;
  end;

  if bOk = False then
    cbPosteSecours.ClearSelection;

  ValidInstall;
end;

procedure TFrm_CaisseSecours.cbPosteSecoursChange(Sender: TObject);
begin
  ValidInstall;
end;

procedure TFrm_CaisseSecours.ChangeMode(ModeSec: Boolean);
begin
  // Change the screen if i'm in mode serv sec or not
  if ModeSec then
  begin
    // I'm a serv sec
    lbl_nameServSecours.Visible := False;
    lbl_LetterDirDistant.Visible := False;
    lbl_PatchDistant.Visible := False;
    cbbServDistantSec.Visible := False;
    cbb_LetterDirDistant.Visible := False;
    edt_eddPathSecDistant.Visible := False;
  end
  else
  begin
    //edGinkoia.Visible := False;
    //lblInstallPath.Visible := False;
  end;
end;

procedure TFrm_CaisseSecours.CheckConnection;
begin
  if isServerSec then
    btnConnect.Enabled := (((GetcbListeServeur <> '') and (cbLettre.Text <> '') and (edBddPath.Text <> '')) or (edConnexionPath.Text <> '')) and
      (edGinkoia.Text <> '')
  else
    btnConnect.Enabled := (((GetcbListeServeurDist <> '') and (cbLettre.Text <> '') and (edBddPath.Text <> '')) or (edConnexionPath.Text <> '')) and
      (cbbServDistantSec.Text <> '') and (cbb_LetterDirDistant.Text <> '') and (edt_eddPathSecDistant.Text <> '');
end;

procedure TFrm_CaisseSecours.EnumNetworkProc(const aNetResource: TNetResource; const aLevel: word; var aContinue: Boolean);
begin
  if aNetResource.dwDisplayType in [RESOURCEDISPLAYTYPE_DOMAIN, RESOURCEDISPLAYTYPE_SERVER] then
  begin
    cbListeServeur.Items.Add(StringOfChar(' ', aLevel * 4) + aNetResource.lpRemoteName);
    cbbServDistantSec.Items.Add(StringOfChar(' ', aLevel * 4) + aNetResource.lpRemoteName);
  end;
end;

procedure TFrm_CaisseSecours.EtatCompoConnexion(Etat: Boolean);
begin
  cbListeServeur.Enabled := Etat;
  cbLettre.Enabled := Etat;
  edBddPath.Enabled := Etat;
  edConnexionPath.Enabled := Etat;
  edGinkoia.Enabled := Etat;
end;

procedure TFrm_CaisseSecours.ValidInstall;
begin
  btnInstall.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '') and (cbPosteSecours.Text <> '');
  btnInstall.Enabled := btnInstall.Visible;

  // btnInstall.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '') ;
  // btnInstall.Enabled := btnInstall.Visible;
end;

end.


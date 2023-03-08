{$REGION 'Documentation'}
/// <summary>
/// Module d'installation de la caisse
/// </summary>
{$ENDREGION}
unit Caisse_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.IOUtils,
  stdActns,
  // Uses perso
  uNetwork,
  // uLogfile, anciens logs
  uLog, uFunctions, uRessourcestr, uInstallbase, UPatchDll,
  // Fin Uses perso
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.Imaging.pngimage,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ComCtrls;

const
  Log_Mdl = 'CaisseParam';

type
  TFrm_Caisse = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    ItemSubtitle: TLabel;
    Panel2: TPanel;
    lblNomServeur: TLabel;
    lblInstallPath: TLabel;
    btnConnect: TButton;
    PnlPoste: TPanel;
    cbMagasin: TComboBox;
    cbPoste: TComboBox;
    btnInstall: TButton;
    lblMagasin: TLabel;
    lblPoste: TLabel;
    lblLettre: TLabel;
    lblD: TLabel;
    lblConnexionPath: TLabel;
    cbListeServeur: TComboBox;
    edBddPath: TEdit;
    edConnexionPath: TEdit;
    cbLettre: TComboBox;
    btnDisConnect: TButton;
    edGinkoia: TButtonedEdit;
    Openfile: TFileOpenDialog;
    OpenFileXP: TOpenDialog;
    imgLang: TImage;
    lblLang: TLabel;
    lblLangName: TLabel;
    chkCash: TCheckBox;
    pgBar: TProgressBar;
    lblEstimated: TLabel;
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

{$REGION 'Documentation'}
    /// <summary>
    /// Si  la connexion peut être établie le panel affichant la liste des
    /// magasins et celle des postes devient visible. Les combobox sont
    /// nettoyés
    /// </summary>
{$ENDREGION}
    procedure CheckConnection;

{$REGION 'Documentation'}
    /// <summary>
    /// L'initialisation du poste est lancée
    /// </summary>
    /// <remarks>
    /// Si le fichier Finkoia.IB n'est pas disponible dans le repertoire data
    /// du dossier d'installation le processus est interrompu
    /// </remarks>
    /// <seealso cref="Initialisation">
    /// Porcédure d'initialisation
    /// </seealso>
{$ENDREGION}
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Initialisation;
    procedure ValidInstall;
    procedure cbMagasinChange(Sender: TObject);
    procedure cbPosteChange(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure cbListeServeurChange(Sender: TObject);
    procedure cbLettreChange(Sender: TObject);
    procedure edBddPathChange(Sender: TObject);
    procedure edGinkoiaChange(Sender: TObject);
    procedure btnDisConnectClick(Sender: TObject);
    procedure edGinkoiaRightButtonClick(Sender: TObject);
  private
    { Private declarations }
    Install: Tinstall;
    NomDuPoste: string;
    ptrAddshop: TAddshop;
    ptrAddPoste: TAddposte;
    bCash: Boolean;
    procedure ConnexionConcat;
    procedure EtatCompoConnexion(Etat: Boolean);
    function CreateBat(aApplication: string): Boolean;
    function GetcbListeServeur: string;
  public
    { Public declarations }
    procedure EnumNetworkProc(const aNetResource: TNetResource; const aLevel: word; var aContinue: Boolean);
    procedure InitGestion(bIsGestion: Boolean);
  end;

var
  Frm_Caisse: TFrm_Caisse;

implementation

uses
  Main_Frm, Main_Dm, ProgressBar_Frm;

{$R *.dfm}

procedure TFrm_Caisse.btnConnectClick(Sender: TObject);
var
  sFile: string;
begin
  sFile := edGinkoia.Text;
  if TDirectory.Exists(sFile) = false then
  begin
    Showmessage(RST_NOGINKOIA);
  end
  else
  begin
    Initialisation;
  end;
end;

procedure TFrm_Caisse.btnDisConnectClick(Sender: TObject);
begin
  FreeAndNil(Install);

  PnlPoste.Visible := false; // Cache les information magasin + poste

  EtatCompoConnexion(True); // Réactive les composants de connexion

  btnConnect.Enabled := True;
  btnDisConnect.Enabled := false;
end;

procedure TFrm_Caisse.btnInstallClick(Sender: TObject);
const
  Log_Key = 'btnInstallClick';
var
  bOk: Boolean;
  aGenParam: TGenParam;
  vMagid, vPosID: Integer;
  vGuid, vCashDistantFolder, vGinkoiaDistantFolder: String;
  oMsg: TForm;
  vGinkoiaPath: String;
begin
  bOk := false;
  aGenParam.prm_string := '';
  aGenParam.prm_integer := 0;
  try
    try

      // si c'est une installation de CASH
      bCash := chkCash.Checked;
      vGinkoiaPath := IncludeTrailingPathDelimiter(edGinkoia.Text);
      vGinkoiaDistantFolder := '\\' + GetcbListeServeur + '\ginkoia\';

      pgBar.Visible := True;
      lblEstimated.Visible := True;
      lblEstimated.Caption := 'Copie des BPL et EXE Ginkoia et Caisse...';
      application.ProcessMessages;

      // on copie le répertoire BPL et l'exe Ginkoia et caisse car ceux dans l'install de base ne sont pas à jour
      CopyFolder(vGinkoiaDistantFolder + 'Bpl\', vGinkoiaPath + 'Bpl\');
      CopyFileWithProgressBar(PWideChar(vGinkoiaDistantFolder + 'ginkoia.exe'), PWideChar(vGinkoiaPath + 'ginkoia.exe'), pgBar);

      if not bCash then
        CopyFileWithProgressBar(PWideChar(vGinkoiaDistantFolder + 'CaisseGinkoia.exe'), PWideChar(vGinkoiaPath + 'CaisseGinkoia.exe'), pgBar);

      lblEstimated.Caption := '';


      // si on a choisi cash, on met à jour les GENPARAM du poste par défaut et du type de caisse par défaut
      if bCash then
      begin
//        vCashDistantFolder := ExcludeTrailingPathDelimiter(ExtractFilePath(edConnexionPath.Text));
//        nbCharToRemove := Length(vCashDistantFolder) - LastDelimiter(PathDelim, vCashDistantFolder);
//        vCashDistantFolder := Copy(vCashDistantFolder, 0, Length(vCashDistantFolder) - nbCharToRemove);
//        vCashDistantFolder := vCashDistantFolder + 'CASH';
        vCashDistantFolder := vGinkoiaDistantFolder + 'CASH\';

        // on vérifie que le répertoire cash existe en local, ainsi que les exe, sinon on les copies depuis le serveur
        bOk := CheckIfCashFolderExists(vCashDistantFolder, vGinkoiaPath + 'CASH');

        vMagid := Integer(cbMagasin.Items.Objects[cbMagasin.Itemindex]);
        vPosID := Integer(cbPoste.Items.Objects[cbPoste.Itemindex]);

        // caisse par défaut
        aGenParam.prm_string := 'cash';
        Install.SetGENPARAM(666, 205, vMagid, vPosID, aGenParam);

        // Renseigner le poste utilisé (pour ne pas le demander lors du premier lancement de CASH) et l'id de la base dans le prm_integer pour les caisses
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

       // Log.Log(RST_MAG + cbMagasin.Text);
      Log.Log(Log_Mdl, Log_Key, RST_MAG + cbMagasin.Text, logInfo, True, 0, ltBoth);
       // Log.Log(RST_POSTE + cbPoste.Text);
      Log.Log(Log_Mdl, Log_Key, RST_POSTE + cbPoste.Text, logInfo, True, 0, ltBoth);

      Install.SetPathBPL;
      Install.CreateIniPoste(cbMagasin.Text, cbPoste.Text);


      // on ne créé plus les bats, raccourci vers les exes à présent
//      bOk := CreateBat(GINKOIA);
//
//      if bOk then
//      begin
//        if bCash then
//          bOk := Install.Machine.CreateRaccourciAndIniCASH(edGinkoia.Text, TypeCaisseSimple)
//        else
//          bOk := CreateBat(CAISSE);
//      end;

      // raccourci de Ginkoia
      if uFunctions.UsrLogged = 'Nosymag' then
        bOk := Install.Machine.CreateShortcut('Nosymag', vGinkoiaPath + GINKOIA, 'Nosymag', vGinkoiaPath, vGinkoiaPath + GINKOIA)
      else
        bOk := Install.Machine.CreateShortcut('Ginkoia', vGinkoiaPath + GINKOIA, 'Ginkoia', vGinkoiaPath, vGinkoiaPath + GINKOIA);

      // raccourci de la caisse
      if bCash then
        bOk := Install.Machine.CreateRaccourciAndIniCASH(edGinkoia.Text, TypeCaisseSimple, GetcbListeServeur, '')
      else
      begin
        bOk := Install.Machine.CreateShortcut('Caisse', vGinkoiaPath + CAISSE, 'Caisse', vGinkoiaPath, vGinkoiaPath + CAISSE);
      end;

    finally
      if bOk then
      begin
        Showmessage('Installation caisse terminée');
        Log.Log(Log_Mdl, Log_Key, 'Installation caisse terminée', logInfo, True, 0, ltBoth);
      end
      else
        Showmessage('Problème lors de l''installation consultez les logs.');

      // On revient à l'écran princpal
      Image1Click(Sender);

      // Lancement de vérification.exe
      // LunchVerif(True);

      // Delete zip file
      if UPatchDll.FileInstallBase <> '' then
        UPatchDll.DelAppli(UPatchDll.FileInstallBase);
    end;
  except
    on E: Exception do
    begin
      Showmessage('Problème lors de l''installation consulté les logs. Message : ' + E.Message);
      // TlogFile.Addline('Problème lors de l''installation consulté les logs. Message : ' + E.Message);
       // Log.Log('Problème lors de l''installation consulté les logs. Message : ' + E.Message, logError);
      Log.Log(Log_Mdl, Log_Key, 'Problème lors de l''installation : ' + E.Message, logError, True, 0, ltBoth);
    end;
  end;
end;

procedure TFrm_Caisse.cbLettreChange(Sender: TObject);
begin
  ConnexionConcat;
  CheckConnection;
end;

procedure TFrm_Caisse.cbListeServeurChange(Sender: TObject);
begin
  ConnexionConcat;
  CheckConnection;
end;

procedure TFrm_Caisse.cbMagasinChange(Sender: TObject);
begin
  ValidInstall;

  // SR - On vide la combo et on charge les postes
  cbPoste.Clear;
  if cbMagasin.ItemIndex > -1 then
  begin
    Install.GetPoste(cbMagasin.Text);
  end;
end;

procedure TFrm_Caisse.cbPosteChange(Sender: TObject);
begin
  ValidInstall;
end;

procedure TFrm_Caisse.CheckConnection;
begin
  btnConnect.Enabled := (((GetcbListeServeur <> '') and (cbLettre.Text <> '') and (edBddPath.Text <> '')) or (edConnexionPath.Text <> '')) and (edGinkoia.Text <> '');
end;

procedure TFrm_Caisse.ConnexionConcat;
begin
  edConnexionPath.Text := GetcbListeServeur + ':' + cbLettre.Text + ':' + edBddPath.Text;
end;

function TFrm_Caisse.CreateBat(aApplication: string): Boolean;
const
  Log_Key = 'CreateBat';
var
  tmp: TStringList;
  sFile: string;
  I: Integer;
  Res: TResourceStream;
  sRep, sBat: string;
begin
  Result := True;
  tmp := TStringList.Create;
  try
    try
      sFile := '\\' + GetcbListeServeur + '\ginkoia\Batch\' + sBat;
      if Tfile.Exists(sFile) = false then
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

      for I := 0 to tmp.Count - 1 do
      begin
        tmp.Strings[I] := StringReplace(tmp.Strings[I], '%SERVEUR%', GetcbListeServeur, [rfReplaceAll, rfIgnoreCase]);
        tmp.Strings[I] := StringReplace(tmp.Strings[I], '%LOCAL%', edGinkoia.Text, [rfReplaceAll, rfIgnoreCase]);

        tmp.Strings[I] := StringReplace(tmp.Strings[I], '%PROG%', edGinkoia.Text[1] + ':\GINKOIA\' + aApplication, [rfReplaceAll, rfIgnoreCase]);
        // tmp.Strings[I] := StringReplace(tmp.Strings[I], '%PROG%', '\\' + GetcbListeServeur + '\ginkoia\' + aApplication, [rfReplaceAll, rfIgnoreCase]);
      end;

    finally
      if aApplication = GINKOIA then
      begin
        tmp.SaveToFile('\\' + GetcbListeServeur + '\ginkoia\Batch\Ginkoia' + edGinkoia.Text[1] + '.BAT');

        if uFunctions.UsrLogged = 'Nosymag' then
        begin
          Install.Machine.CreateShortcut('Nosymag', '\\' + GetcbListeServeur + '\ginkoia\Batch\Ginkoia' + edGinkoia.Text[1] + '.BAT', 'Nosymag', edGinkoia.Text, edGinkoia.Text + '\' + GINKOIA);
        end
        else
        begin
          Install.Machine.CreateShortcut('Ginkoia', '\\' + GetcbListeServeur + '\ginkoia\Batch\Ginkoia' + edGinkoia.Text[1] + '.BAT', 'Ginkoia', edGinkoia.Text, edGinkoia.Text + '\' + GINKOIA);
        end;
      end
      else
      begin
        tmp.SaveToFile('\\' + GetcbListeServeur + '\ginkoia\Batch\Caisse' + edGinkoia.Text[1] + '.BAT');
        Install.Machine.CreateShortcut('Caisse', '\\' + GetcbListeServeur + '\ginkoia\Batch\Caisse' + edGinkoia.Text[1] + '.BAT', 'Caisse', edGinkoia.Text, edGinkoia.Text + '\' + CAISSE);
      end;
      tmp.Free;
    end;
  except
    on E: Exception do
    begin
      Result := false;
      Showmessage('Erreur lors de la création du fichier batch : ' + E.Message);
      // TlogFile.Addline('Erreur lors de la création du fichier batch : ' + E.Message);
       // Log.Log('Erreur lors de la création du fichier batch : ' + E.Message, logError);
      Log.Log(Log_Mdl, Log_Key, 'Erreur lors de la création du fichier batch : ' + E.Message, logError, True, 0, ltBoth);
    end;
  end;
end;

procedure TFrm_Caisse.edBddPathChange(Sender: TObject);
begin
  ConnexionConcat;
  CheckConnection;
end;

procedure TFrm_Caisse.edGinkoiaChange(Sender: TObject);
begin
  CheckConnection;
end;

procedure TFrm_Caisse.edGinkoiaRightButtonClick(Sender: TObject);
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

procedure TFrm_Caisse.EtatCompoConnexion(Etat: Boolean);
begin
  cbListeServeur.Enabled := Etat;
  cbLettre.Enabled := Etat;
  edBddPath.Enabled := Etat;
  edConnexionPath.Enabled := Etat;
  edGinkoia.Enabled := Etat;
end;

procedure TFrm_Caisse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Main.Tag := 0; // pour permettre la fermeture de la fenêtre principale.

  if Install <> nil then
    FreeAndNil(Install); // SR - Libération de l'insatallation.

  Action := caHide; // FL : Pas caFree sinon le Destroy de la MainForm va as aimer !

  // //Enregistrement et Libération du fichier log.
  // Tlogfile.SaveToFile(ChangeFileExt(Application.ExeName, '.log'));
  // Tlogfile.Reset;
end;

procedure TFrm_Caisse.EnumNetworkProc(const aNetResource: TNetResource; const aLevel: word; var aContinue: Boolean);
begin
  if aNetResource.dwDisplayType in [RESOURCEDISPLAYTYPE_DOMAIN, RESOURCEDISPLAYTYPE_SERVER] then
    cbListeServeur.Items.Add(StringOfChar(' ', aLevel * 4) + aNetResource.lpRemoteName);
end;

procedure TFrm_Caisse.FormCreate(Sender: TObject);
var
  a: Char;
  FoldSkip: TStringList;
  ExtSkip: TStringList;
begin
  // **** Création des procédures propre à la form ****//
  ptrAddshop :=
    procedure(Magasin: string; aMagID: Integer)
    begin
      //cbMagasin.Items.Add(Magasin);
      Log.Log('Caisse_FRM', 'ptrAddshop', 'Magasin : ' + Magasin + ', magid : ' + IntToStr(aMagID) , logInfo, True, 0, ltLocal);

      cbMagasin.Items.AddObject(Magasin, TObject(aMagID));
      if Magasin = Install.MagasinSurServeur then
      begin
        cbMagasin.ItemIndex := cbMagasin.Items.Count - 1;
      end;
    end;

  ptrAddPoste :=
    procedure(Poste: string; aPosID: integer)
    begin
      //cbPoste.Items.Add(Poste);
      Log.Log('Caisse_FRM', 'ptrAddPoste', 'Poste : ' + Poste + ', PosID : ' + IntToStr(aPosID) , logInfo, True, 0, ltLocal);

      cbPoste.Items.AddObject(Poste, TObject(aPosID));
      if NomDuPoste = Poste then
      begin
        cbPoste.ItemIndex := cbPoste.Items.Count - 1;
      end;
    end;
  // **************************************************//

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

  // **** Les lettres des disques ****//
  cbLettre.Clear;
  for a := 'A' to 'Z' do
    cbLettre.Items.Add(a);
  // *********************************//

  edBddPath.Text := '\Ginkoia\data\Ginkoia.ib'; // Par défaut le dossier de la BDD

  // On cherche un répertoire par défaut pour l'installation locale de Ginkoia
  edGinkoia.Text := StringReplace(SearchLocalGinkoiaPathBase(), 'data\ginkoia.ib', '', [rfReplaceAll, rfIgnoreCase]);
end;

function TFrm_Caisse.GetcbListeServeur: string;
begin
  Result := StringReplace(StringReplace(cbListeServeur.Text, ' ', '', [rfReplaceAll, rfIgnoreCase]), '\', '', [rfReplaceAll, rfIgnoreCase])
end;

procedure TFrm_Caisse.Image1Click(Sender: TObject);
begin
  Postmessage(handle, WM_CLOSE, 0, 0);
  Self.FreeOnRelease;
end;

procedure TFrm_Caisse.InitGestion(bIsGestion: Boolean);
begin
  if bIsGestion then
    ItemSubtitle.Caption := 'Déploiement poste de gestion';
end;

procedure TFrm_Caisse.Initialisation;
const
  Log_Key = 'Initialisation';
begin
  try
    btnConnect.Enabled := false;

     // Log.Log(RST_SERVER + edConnexionPath.Text);
    Log.Log(Log_Mdl, Log_Key, RST_SERVER + edConnexionPath.Text, logInfo, True, 0, ltBoth);
     // Log.Log(RST_GINKOIA + IncludeTrailingPathDelimiter(edGinkoia.Text));
    Log.Log(Log_Mdl, Log_Key, RST_GINKOIA + IncludeTrailingPathDelimiter(edGinkoia.Text), logInfo, True, 0, ltBoth);

    Install := Tinstall.Create(edGinkoia.Text, ExtractFilePath(edConnexionPath.Text)); // create pour caisse
    Install.Server := GetcbListeServeur;
    Install.Drive := cbLettre.Text;
    Install.PathBdd := edBddPath.Text;
    Install.Connexion := edConnexionPath.Text;

    // ***********************************************************************
    Install.GetMagasinSurServeur;
    NomDuPoste := Install.Machine.NomDuPoste;

     // Log.Log(RST_AKOI + Install.Connexion, logInfo);
    Log.Log(Log_Mdl, Log_Key, RST_AKOI + Install.Connexion, logInfo, True, 0, ltBoth);

    Install.OpenServeur;
    if Install.Database.Error <> '' then // Si connexion en erreur
    begin
       // Log.Log(Install.Database.Error, logError);
      Log.Log(Log_Mdl, Log_Key, Install.Database.Error, logError, True, 0, ltBoth);

      btnConnect.Enabled := True;
      btnDisConnect.Enabled := false;

      Showmessage(Install.Database.Error);
      // ShowMessage('Pour information le serveur Interbase est en version : ' +
      // Dm_Main.GetVersionIBServeur(Install.Server));
      Showmessage('Pour information le serveur Interbase est en version : ' + Frm_Main.GetVersInterbase);
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
      // ****************** fin de la langue *************************

      PnlPoste.Visible := True;

      cbMagasin.Items.Clear;
      cbMagasin.Text := '';
      cbMagasin.Enabled := True;

      cbPoste.Items.Clear;
      cbPoste.Text := '';
      cbPoste.Enabled := True;

      Install.AddShop := ptrAddshop;
      Install.AddPoste := ptrAddPoste;
      Install.GetShop;

      // Tlogfile.Addline(Datetimetostr(Now)+' '+RST_CONNECTED);
       // Log.Log(RST_CONNECTED, logInfo);
      Log.Log(Log_Mdl, Log_Key, RST_CONNECTED, logInfo, True, 0, ltBoth);

      EtatCompoConnexion(false);

      btnConnect.Enabled := false;
      btnDisConnect.Enabled := True;

      // Showmessage(RST_CONNECTED +
      // ' - Pour information le serveur Interbase est en version : ' +
      // Dm_Main.GetVersionIBServeur(Install.Server));
      Showmessage(RST_CONNECTED + ' - Pour information le serveur Interbase est en version : ' + Frm_Main.GetVersInterbase);
    end;
  except
    on E: Exception do
    begin
      // Tlogfile.Addline(Datetimetostr(Now) + ' Erreur lors de Initialisation avec le message : ' + E.Message);
       // Log.Log(' Erreur lors de Initialisation avec le message : ' + E.Message, logError);
      Log.Log(Log_Mdl, Log_Key, ' Erreur lors de Initialisation avec le message : ' + E.Message, logError, True, 0, ltBoth);
      Showmessage('Erreur lors de Initialisation avec le message : ' + E.Message);
    end;
  end;
end;

procedure TFrm_Caisse.ValidInstall;
begin
  btnInstall.Visible := (cbMagasin.Text <> '') and (cbPoste.Text <> '');
  btnInstall.Enabled := btnInstall.Visible;
end;

end.


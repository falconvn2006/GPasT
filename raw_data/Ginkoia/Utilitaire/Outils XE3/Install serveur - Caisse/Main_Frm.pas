unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.IOUtils,
  // Début Uses Perso
  uToolsXE, uFunctions,
  // uLogfile, ancienne unité de log
  uLog, uRessourcestr, uParams, uDownloadfromlame,
  // Form
  CaisseSecours_Frm, Codeuser_Frm, Paramlame_Frm, Caisse_Frm, Server_Frm,
  Download_Frm, Basetest_Frm, Main_Dm, ShellAPI, RegExpr, Registry, Informations,
  uLaunchAsAdmin,
  // Fin Uses Perso
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.StrUtils, Vcl.ExtCtrls, Vcl.themes, Data.DB, Datasnap.DBClient,
  Generics.Collections, IdBaseComponent, IdZLibCompressorBase, IdCompressorZLib,
  Vcl.Imaging.pngimage, idHTTP, UpdateurFrm;

type
  TFrm_Main = class(TForm)
    lbl_VersionSystem: TLabel;
    lbl_VersionLogiciel: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    PDocksite: TPanel;
    img_caisse: TImage;
    img_serveur: TImage;
    img_BddTest: TImage;
    Label6: TLabel;
    Label7: TLabel;
    DSParam: TClientDataSet;
    Label2: TLabel;
    Label3: TLabel;
    ItemTitle: TLabel;
    ItemSubtitle: TLabel;
    btnparam: TButton;
    Img_portable: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Img_CaisseSecours: TImage;
    Label8: TLabel;
    Label9: TLabel;
    Img_PosteGertion: TImage;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure img_serveurClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure img_caisseClick(Sender: TObject);
    procedure img_BddTestClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnparamClick(Sender: TObject);
    procedure Img_portableClick(Sender: TObject);
    procedure Img_CaisseSecoursClick(Sender: TObject);
    procedure Img_PosteGertionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    iCurrentStyle: integer; // pour modifiier le style
    IsDirNetwork: Boolean; // True --> this application has been lunched by a network dir

    function getVersionDeployLame: string;
    // function getDeploiementIni(aFileName : string): boolean;
  public
    { Déclarations publiques }
    function GetVersInterbase: string;
  end;

var
  Frm_Main: TFrm_Main;
  VersionDLL_IB: string;
  vVersionInterBase: TInfoSurExe;
  UsrNosymag: Boolean;
  Param: TransportParam;

implementation

{$R *.dfm}

procedure TFrm_Main.btnparamClick(Sender: TObject);
var
  k: integer;
begin
  // Try
  // k := 0;

  // application.CreateForm(TFcodeuser, Fcodeuser);
  // Repeat
  // inc(k);
  // if Fcodeuser.ShowModal = mrOk then
  // begin
  // if IsAuthorized(Fcodeuser.edtUser.Text, Fcodeuser.edtpwd.Text) then
  // begin
  // // saisie des params
  // k := 10000;
  // Try
  // application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
  // Frm_Paramlame.ShowModal;
  // Finally
  // Frm_Paramlame.Release;
  // Frm_Paramlame := nil;
  // End;
  // end;
  // end
  // else
  // begin
  // k := 10000;
  // break;
  // end;
  // Until k = 10000;
  // Finally
  // Fcodeuser.Release;
  // Fcodeuser := nil;
  // End;

  // on connait déjà le user loggué donc la partie au dessus est inutile
  try
    application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
    Frm_Paramlame.ShowModal;
  finally
    Frm_Paramlame.Release;
    Frm_Paramlame := nil;
  end;

end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if tag = 1 then
  begin
    CanClose := False;
    ShowMessage('Merci de fermer l''onglet en cours.');
    Exit;
  end
  else
  begin
    // if windows is still open
    if Assigned(Frm_CaisseSecours) then
      Frm_CaisseSecours.FreeOnRelease;

    if Assigned(Frm_Serveur) then
      Frm_Serveur.FreeOnRelease;

    if Assigned(Frm_Download) then
      Frm_Download.FreeOnRelease;

    if Assigned(Frm_Caisse) then
      Frm_Caisse.FreeOnRelease;
  end;

end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  Res: TResourceStream;
  sDll, sRep: string;
  isRestart: boolean;
  i: Integer;
begin
  // lancement en mode administrateur
  // pour savoir si c'est un restart, on cherche le paramètre
  isRestart := False;
  if ParamCount() > 0 then
  begin
    for i := 1 to ParamCount() do
    begin
      if UpperCase(ParamStr(i)) = 'RESTART' then
      begin
        isRestart := True;
        Break;
      end
    end;
  end;

  // plus de vérification de lancement administrateur car ouvre deux fenêtres pour la maj
//  if not LaunchAsAdministrator and isRestart then
//  begin
//    ShowMessage('Le programme n''est pas lancé avec les droits administrateurs');
//    application.Terminate;
//  end;

   // mise à jour de l'exe si pas dans la dernière version
  VerificationMAJ(true);

  iCurrentStyle := 1; // style bleu
  lbl_VersionSystem.Caption := uFunctions.GetInfoSystem + ' - Version local d''Interbase : ' + GetVersInterbase;
  lbl_VersionLogiciel.Caption := uFunctions.GetVersion(application.ExeName, application.Handle);

  IsDirNetwork := False;

  if ContainsStr(application.ExeName, '\\') then
  begin
    IsDirNetwork := true;
  end;

  // I choose to delete the ini's file , when the software is launched
  if FileExists(GetCurrentDir + '\Deploiement.ini') then
    DeleteFile(GetCurrentDir + '\Deploiement.ini');

  Param := TransportParam.Create;

  // on récupère la dll de 7z dans les ressources et on la met à coté de l'exe
  sRep := ExtractFilePath(application.ExeName);
  sDll := '7z.dll';
  Res := TResourceStream.Create(0, 'SevenZip32', RT_RCDATA);
  try
    Res.SaveToFile(sRep + sDll);
  finally
    Res.Free;
  end;

  // initialisation des logs
  Log.App := 'Deploy';
  Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue];
  Log.SendOnClose := True;
  Log.SendLogLevel := logInfo;
  Log.Open;
  Log.saveIni;

  Log.Log('Main', 'Status', 'Démarrage du Deploy', logInfo, True, 0, ltBoth);
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
var
  sRep, sDll: string;
begin
  Log.Log('Main', 'Status', 'Arrêt du deploy', logInfo, True, 0, ltBoth);

  // on nettoie la dll de 7z en sortie
  sRep := ExtractFilePath(application.ExeName);
  sDll := '7z.dll';

  if FileExists(sRep + sDll) then
    DeleteFile(sRep + sDll);

  Param.Free;
end;

procedure TFrm_Main.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  sTyle: string;
begin
  if Shift = [ssCtrl] then
  begin
    if Key = vk_right then
    begin
      try
        case iCurrentStyle of
          0:
            sTyle := 'Metropolis UI Blue';
          1:
            sTyle := 'Metropolis UI Green';
          2:
            sTyle := 'Metropolis UI Dark';
        end;
        TstyleManager.SetStyle(sTyle);
        inc(iCurrentStyle);
        if iCurrentStyle = 3 then
          iCurrentStyle := 0;
      except
      end;
    end;
  end;
end;

procedure TFrm_Main.FormShow(Sender: TObject);
var
  k, i: integer;
  sFile: string;
  bOk: Boolean;
  RightVersion: Boolean;
  oMsg: TForm;
  ChooseDir: TFileOpenDialog;
  DirChosen: string;
  LetterDirExe: string;
  TypLetterDir: integer;
  vDeployVersionLocal: string;
  vDeployVersionLame: string;
  userParam, passParam, paramNom, paramValue: string;
begin
  k := 0;

  sFile := IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(Paramstr(0))) + 'Deploiement.ini';

  // connexion automatique avec paramètres
  for i := 0 to ParamCount do
  begin
    if Pos('=', Paramstr(i)) > 0 then
    begin
      paramNom := Copy(Paramstr(i), 1, Pos('=', Paramstr(i)) - 1);
      paramValue := Copy(Paramstr(i), Pos('=', Paramstr(i)) + 1, Length(Paramstr(i)));
    end
    else
    begin
      paramNom := Paramstr(i);
      paramValue := '';
    end;

    if LowerCase(paramNom) = 'user' then
      userParam := paramValue;
    if LowerCase(paramNom) = 'password' then
      passParam := paramValue;
  end;

  if Tfile.Exists(sFile) = False then
  begin
    // saisie des paramétres

    // autologin
    if (userParam <> '') and (passParam <> '') then
    begin
      if IsAuthorized(userParam, passParam) then
      begin
        if uFunctions.UsrLogged = UsrISF then
        begin
          UsrNosymag := true;

          // Block the software if it launched by a network directory
          if IsDirNetwork then
          begin
            ShowMessage('Impossible de lancer cette application par un chemin réseau' + #10 + 'Veuillez le lancer en local avant');
            application.Terminate;
          end;

          LetterDirExe := LeftStr(ExtractFilePath(Paramstr(0)), 3);

          TypLetterDir := GetDriveType(PChar(LetterDirExe));

          if TypLetterDir <> 0 then
            case TypLetterDir of
              DRIVE_REMOTE:
                begin
                  ShowMessage('Impossible de lancer cette application par un chemin réseau' + #10 + 'Veuillez le lancer en local avant');
                  application.Terminate;
                end;
            end;
        end
        else
        begin
          UsrNosymag := False;
        end;

        // on masque cet écran à présent
        try
          application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
        finally
          Frm_Paramlame.Release;
          Frm_Paramlame := nil;
        end;
      end
      else
        application.Terminate;
    end
    else
    begin
      try
        application.CreateForm(TFcodeuser, Fcodeuser);
        bOk := False;
        repeat
          inc(k);

          if Fcodeuser.ShowModal = mrOk then
          begin
            if IsAuthorized(Fcodeuser.edtUser.Text, Fcodeuser.edtpwd.Text) then
            begin
              vDeployVersionLocal := uFunctions.GetVersion(application.ExeName, application.Handle);
              if Copy(vDeployVersionLocal, 1, 10) = 'Version : ' then
                vDeployVersionLocal := Copy(vDeployVersionLocal, 11, Length(vDeployVersionLocal) - 10);
              //vDeployVersionLame := getVersionDeployLame;
              // RightVersion := (vDeployVersionLocal = vDeployVersionLame);

              if uFunctions.UsrLogged = UsrISF then
              begin
                UsrNosymag := true;

                // if vDeployVersionLame = '' then
                // begin
                // ShowMessage('Impossible de controler la version de Deploy. Vous devez avoir accès à Internet.');
                // application.Terminate;
                // end;

                // Block the software if it launched by a network directory
                if IsDirNetwork then
                begin
                  ShowMessage('Impossible de lancer cette application par un chemin réseau' + #10 + 'Veuillez le lancer en local avant');
                  application.Terminate;
                end;

                LetterDirExe := LeftStr(ExtractFilePath(Paramstr(0)), 3);

                TypLetterDir := GetDriveType(PChar(LetterDirExe));

                if TypLetterDir <> 0 then
                  case TypLetterDir of
                    DRIVE_REMOTE:
                      begin
                        ShowMessage('Impossible de lancer cette application par un chemin réseau' + #10 + 'Veuillez le lancer en local avant');
                        application.Terminate;
                      end;
                  end;

                // plus utile car auto-updateur
                // if (RightVersion = False) then
                // begin
                // // it isn't in the latest version
                // oMsg := CreateMessageDialog('Vous ne disposez pas de la dernière version du deploy' + #10 + 'Voulez-vous télécharger la version ' +
                // vDeployVersionLame + ' ?', mtError, [mbOk, mbCancel]);
                //
                // oMsg.Position := poScreenCenter;
                // oMsg.FormStyle := fsStayOnTop;
                //
                // if oMsg.ShowModal = ID_OK then
                // begin
                // // Let's Download the file
                // Param.DownloadSofware(vDeployVersionLame);
                //
                // // Select a directory to put the file
                // try
                // ChooseDir := TFileOpenDialog.Create(Nil);
                // try
                // ChooseDir.Title := 'Dossier d''enregistrement du fichier';
                // ChooseDir.Options := [fdoPickFolders];
                // if ChooseDir.Execute then
                // DirChosen := ChooseDir.FileName;
                //
                // if ChooseDir.FileName = '' then
                // begin
                // ShowMessage('Erreur dans la sélection du dossier d''enregistrement de la dernière version du Deploy');
                // application.Terminate;
                // end;
                //
                // // To Move the .ini file
                // if FileExists(uDownloadfromlame.TLameFileDownloader.Localfile) then
                // MoveFile(PChar(uDownloadfromlame.TLameFileDownloader.Localfile), PChar(ChooseDir.FileName + '\Deploy-V' + vDeployVersionLame + '.zip'));
                //
                // uDownloadfromlame.TLameFileDownloader.Reset;
                //
                // ShowMessage('Fichier Enregistré' + #10 + '/!\ Veuillez utiliser la nouvelle version /!\');
                // finally
                // application.Terminate;
                // end;
                // except
                // on e: Exception do
                // begin
                // Log.Log(e.Message, logError);
                // ShowMessage(e.Message);
                // end;
                // end;
                // end
                // else
                // begin
                // application.Terminate;
                // end;
                // end;

              end
              else
              begin
                UsrNosymag := False;

                // l'exe se met à présent à jour tout seul
                // if RightVersion = False then
                // ShowMessage('/!\ Vous ne disposez pas de la dernière version du logiciel Deploy : ' + vDeployVersionLame + ' /!\');
              end;

              // saisie des params
              k := 10000;
              bOk := true;
              // on masque cet écran à présent
              try
                application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
              finally
                Frm_Paramlame.Release;
                Frm_Paramlame := nil;
              end;

              // bOk := False;
              // Try
              // application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
              // if Frm_Paramlame.ShowModal = mrOk then
              // begin
              // bOk := true;
              // end
              // else
              // begin
              // bOk := False;
              // end;
              // Finally
              // Frm_Paramlame.Release;
              // Frm_Paramlame := nil;
              // End;
            end;
          end
          else
          begin
            k := 10000;
            application.Terminate;
          end;
        until k = 10000;
      finally
        Fcodeuser.Release;
        Fcodeuser := nil;
      end;
    end;
  end;

  // Download inifile if it wasn't here
  if UsrNosymag then
  begin
    Label1.Caption := Label1.Caption + ' - Intersport';
    Label1.AutoSize := true;
  end;

end;

function TFrm_Main.GetVersInterbase: string;
var
  Reg: TRegistry;
  sDirInterbase, sVersion: string;
begin
  // To get the good version of interbase's dll
  Result := '';
  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_32KEY);
  try
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
      begin
        Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', False);
        sDirInterbase := Reg.ReadString('ServerDirectory');
        sDirInterbase := sDirInterbase + '\gds32.dll';
      end;
    except
      on e: Exception do
      begin
        raise Exception.Create('Lecture de la base de registre Erreur -> ' + e.Message);
      end;
    end;
  finally
    Reg.Free;
  end;

  if FileExists(sDirInterbase) then
  begin
    vVersionInterBase := InfoSurExe(sDirInterbase);
    Result := vVersionInterBase.FileVersion;
  end;

end;

function TFrm_Main.getVersionDeployLame: string;
var
  vClient: TidHTTP;
  vUrl: string;
  vStream: TStringStream;
begin
  try
//    vUrl := 'http://lame2.ginkoia.eu/algol/Deploy/version.txt';
//
//    vClient := TidHTTP.Create(Self);
//    try
//      vStream := TStringStream.Create;
//      try
//        try
//          vClient.Get(vUrl, vStream);
//        except
//
//        end;
//
//        if vClient.ResponseCode = 200 then
//        begin
//          Result := Trim(vStream.DataString);
//        end
//        else
//        begin
//          Result := '';
//        end;
//      finally
//        vStream.Free;
//      end;
//    finally
//      vClient.Free;
//    end;
  except
    on e: Exception do
      Log.Log('Main', 'getVersionDeployLame', 'Erreur lors de la récupèration de la version lame : ' + e.Message, logError, True, 0, ltBoth);
      //Log.Log('Erreur lors de la récupèration de la version lame : ' + e.Message, logError, 'getVersionDeployLame');
  end;
end;

// function TFrm_Main.getDeploiementIni(aFileName : string): boolean ;
// var
// vClient : TidHTTP ;
// vUrl    : string ;
// vStream : TStringStream ;
// begin
// try
// vUrl := 'http://lame2.ginkoia.eu/algol/Deploy/Deploiement.ini' ;
//
// vClient := TidHTTP.Create(Self);
// try
// vStream := TStringStream.Create ;
// try
// try
// vClient.Get(vUrl, vStream);
// except
// end;
//
// Result := (vClient.ResponseCode = 200) ;
//
// if Result then
// begin
// vStream.SaveToFile(aFileName);
// end;
//
// finally
// vStream.Free ;
// end;
// finally
// vClient.Free ;
// end;
// except
// on E:Exception do
// Log.Log('Erreur lors de la récupèration de la version lame : ' + E.Message, logError, 'getVersionDeployLame');
// end;
// end;

procedure TFrm_Main.img_caisseClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    application.CreateForm(TFrm_Caisse, Frm_Caisse);
    Frm_Caisse.Align := alClient;
    Frm_Caisse.ManualDock(PDocksite, nil, alClient);
    Frm_Caisse.Show;
    tag := 1; // pour empêcher la fermeture de la fenêtre principale
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Img_CaisseSecoursClick(Sender: TObject);
var
  bOk, isServSec: Boolean;
  sFile: string;
  k: integer;
  oMsg: TForm;
begin

  Log.Log('Main', 'Status', 'Installation d''une caisse de secours', logInfo, True, 0, ltBoth);

  isServSec := False;
  // Download -  checkout's file or not
  oMsg := CreateMessageDialog('Voulez-vous installer le serveur de la caisse de secours, ou configurer une caisse en mode secours ?', mtInformation, [mbYes, mbNo]);
  oMsg.Position := poScreenCenter;
  oMsg.FormStyle := fsStayOnTop;
  oMsg.Caption := 'Installation caisse de secours';
  TButton(oMsg.FindComponent('Yes')).Caption := 'Installer le serveur';
  TButton(oMsg.FindComponent('Yes')).Width := 150;
  TButton(oMsg.FindComponent('Yes')).left := 125;
  TButton(oMsg.FindComponent('No')).Caption := 'Configurer une caisse';
  TButton(oMsg.FindComponent('No')).Width := 150;

  if oMsg.ShowModal = ID_YES then
  begin
    isServSec := true;
    application.CreateForm(TFrm_Download, Frm_Download);
    Frm_Download.Position := TPosition.poMainFormCenter;
    Frm_Download.ShowModal;
  end;

  if oMsg.ModalResult = ID_NO then
  begin
    try
      Screen.Cursor := crHourGlass;
      application.CreateForm(TFrm_CaisseSecours, Frm_CaisseSecours);
      Frm_CaisseSecours.Align := alClient;
      Frm_CaisseSecours.ManualDock(PDocksite, nil, alClient);
      Frm_CaisseSecours.isServerSec := isServSec;
      Frm_CaisseSecours.ChangeMode(isServSec);
      Frm_CaisseSecours.Show;
      // tag := 1; // pour empêcher la fermeture de la fenêtre principale
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  begin
    // Caisse de secours - Mise en place
    if Assigned(Frm_Download) then
      if Frm_Download.ModalResult <> ID_CANCEL then
      begin
        try
          Screen.Cursor := crHourGlass;
          application.CreateForm(TFrm_CaisseSecours, Frm_CaisseSecours);
          Frm_CaisseSecours.Align := alClient;
          Frm_CaisseSecours.ManualDock(PDocksite, nil, alClient);
          Frm_CaisseSecours.isServerSec := isServSec;
          Frm_CaisseSecours.ChangeMode(isServSec);
          Frm_CaisseSecours.Show;
          // tag := 1; // pour empêcher la fermeture de la fenêtre principale
        finally
          Screen.Cursor := crDefault;
        end;
      end;
  end;

end;

procedure TFrm_Main.Img_portableClick(Sender: TObject);
var
  bOk: Boolean;
  sFile: string;
  k: integer;
begin
  // Mode portable
  Log.Log('Main', 'Status', 'Installation d''un portable', logInfo, True, 0, ltBoth);

  k := 0;
  try
    sFile := IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(Paramstr(0))) + 'Deploiement.ini';
    bOk := true;
    if Tfile.Exists(sFile) = False then
    begin
      // saisie des paramétres
      try
        application.CreateForm(TFcodeuser, Fcodeuser);
        bOk := False;
        repeat
          inc(k);
          if Fcodeuser.ShowModal = mrOk then
          begin
            if IsAuthorized(Fcodeuser.edtUser.Text, Fcodeuser.edtpwd.Text) then
            begin
              // saisie des params
              k := 10000;
              bOk := False;
              try
                application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
                if Frm_Paramlame.ShowModal = mrOk then
                begin
                  bOk := true;
                end
                else
                begin
                  bOk := False;
                end;
              finally
                Frm_Paramlame.Release;
                Frm_Paramlame := nil;
              end;
            end;
          end
          else
          begin
            k := 10000;
            application.Terminate;
          end;
        until k = 10000;
      finally
        Fcodeuser.Release;
        Fcodeuser := nil;
      end;
    end;

    if bOk = False then
    begin
      ShowMessage(RST_NOXMLFILE);
    end
    else
    begin
      Screen.Cursor := crHourGlass;
      application.CreateForm(TFrm_Serveur, Frm_Serveur);
      Frm_Serveur.Align := alClient;
      Frm_Serveur.ManualDock(PDocksite, nil, alClient);
      Frm_Serveur.Show;
      Frm_Serveur.InitPortable(true);
      // tag := 1; // pour empêcher la fermeture de la fenêtre principale
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Img_PosteGertionClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    application.CreateForm(TFrm_Caisse, Frm_Caisse);
    Frm_Caisse.Align := alClient;
    Frm_Caisse.ManualDock(PDocksite, nil, alClient);
    Frm_Caisse.Show;
    Frm_Caisse.InitGestion(true);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.img_serveurClick(Sender: TObject);
var
  bOk: Boolean;
  sFile: string;
  k: integer;
begin
  Log.Log('Main', 'Status', 'Installation d''un serveur', logInfo, True, 0, ltBoth);

  k := 0;
  try
    sFile := IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(Paramstr(0))) + 'Deploiement.ini';
    bOk := true;
    if Tfile.Exists(sFile) = False then
    begin
      // saisie des paramétres
      try
        application.CreateForm(TFcodeuser, Fcodeuser);
        bOk := False;
        repeat
          inc(k);
          if Fcodeuser.ShowModal = mrOk then
          begin
            if IsAuthorized(Fcodeuser.edtUser.Text, Fcodeuser.edtpwd.Text) then
            begin
              // saisie des params
              k := 10000;
              bOk := False;
              try
                application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
                if Frm_Paramlame.ShowModal = mrOk then
                begin
                  bOk := true;
                end
                else
                begin
                  bOk := False;
                end;
              finally
                Frm_Paramlame.Release;
                Frm_Paramlame := nil;
              end;
            end;
          end
          else
          begin
            k := 10000;
            application.Terminate;
          end;
        until k = 10000;
      finally
        Fcodeuser.Release;
        Fcodeuser := nil;
      end;
    end;

    if bOk = False then
    begin
      ShowMessage(RST_NOXMLFILE);
    end
    else
    begin
      Screen.Cursor := crHourGlass;
      application.CreateForm(TFrm_Serveur, Frm_Serveur);
      Frm_Serveur.Align := alClient;
      Frm_Serveur.ManualDock(PDocksite, nil, alClient);
      Frm_Serveur.Show;
      Frm_Serveur.InitPortable(False);
      // tag := 1; // pour empêcher la fermeture de la fenêtre principale
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.img_BddTestClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    application.CreateForm(TFrm_Basetest, Frm_Basetest);
    Frm_Basetest.Align := alClient;
    Frm_Basetest.ManualDock(PDocksite, nil, alClient);
    Frm_Basetest.Show;
    tag := 1; // pour empêcher la fermeture de la fenêtre principale
  finally
    Screen.Cursor := crDefault;
  end;
  application.ExeName
end;

end.


unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  uDataMod, uWMI, SymmetricDS.Commun,IOUtils , UCommun, ShellAPI,ServiceControler,
  Vcl.Imaging.pngimage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, Vcl.ComCtrls,uInstallDossierMag, uSevenZip, System.IniFiles,
  uDownloadHTTP, IdURI, System.JSON;

Const sEASY='EASY';
      CST_7Z_PASSWORD = 'ch@mon1x';
      CST_OK           = 'Ok';
      CST_DEJAINSTALL  = 'Déjà installé';
      CST_ERREUR       = 'Erreur';
      CST_LAUNCHEREASY = 'LauncherEASY.exe';

type
  TForm_Main = class(TForm)
    gb_Prerequis: TGroupBox;
    sb_status: TStatusBar;
    pnl_Infos: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    mLog: TMemo;
    lbl_Infos: TLabel;
    gb_Split: TGroupBox;
    lbl_Result1: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    lbl_Result2: TLabel;
    Label18: TLabel;
    lbl_Result3: TLabel;
    lbl_Result4: TLabel;
    lbl_Result5: TLabel;
    pbGeneral: TProgressBar;
    BEtape1: TButton;
    BEtape2: TButton;
    BEtape3: TButton;
    BEtape4: TButton;
    BEtape5: TButton;
    BEtape6: TButton;
    lbl_Result6: TLabel;
    cb_Drive: TComboBox;
    BEtape1_5: TButton;
    cbDossiers: TComboBox;
    cbSENDER: TComboBox;
    gb_Etape2: TGroupBox;
    rbSplitLocal: TRadioButton;
    rbDistant: TRadioButton;
    Bevel1: TBevel;
    teSplitLocal: TEdit;
    bSplitLocal: TButton;
    timAUTO: TTimer;
    lbl_Result1_5: TLabel;
    procedure BtnSymmetricDSClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BFermerClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BCONSOLEWEBClick(Sender: TObject);
    procedure BEasyInstallClick(Sender: TObject);
    procedure BcontrolerClick(Sender: TObject);
    procedure BActionClick(Sender: TObject);
    procedure teURLMasterEnter(Sender: TObject);
    procedure teURLMasterExit(Sender: TObject);
    procedure BCLEANClick(Sender: TObject);
    procedure BINSTALLClick(Sender: TObject);
    procedure InstallCallBack(Sender: TObject);
    procedure BLocalSplitClick(Sender: TObject);
    procedure BBASEINSTALLClick(Sender: TObject);
//    procedure BRemoteSplitClick(Sender: TObject);
//    procedure BRemoteVersionClick(Sender: TObject);
    procedure BEtape1Click(Sender: TObject);
    procedure BEtape2Click(Sender: TObject);
    procedure BEtape3Click(Sender: TObject);
    procedure BEtape4Click(Sender: TObject);
    procedure BEtape5Click(Sender: TObject);
    procedure BEtape6Click(Sender: TObject);
    procedure BEtape1_5Click(Sender: TObject);
    procedure cbDossiersChange(Sender: TObject);
    procedure rbSplitClick(Sender: TObject);
    procedure bSplitLocalClick(Sender: TObject);
    procedure timAUTOTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    // Nouveauté plus dans l'esprit Delos2EASY (moins de boutons)

    FAuto         : Boolean; // Si en mode auto
    FAUTO_FROM_IB : Boolean;
    FStopError    : Boolean; // Si on trouve une Erreur ca permet de bloquer le timer
    FStopFinish   : Boolean; // Quand on arrive à la fin : Arrete du Timer

//    FGVersion    : string; // Repertoire local des GVERSION (version GINKOIA)
    FJava7z      : TFileName;
    FSymDSjar    : TFileName;
    F7zdll       : TFileName;
    FBase0       : string;
    FSplitFile   : string;
    FFullPathSplitFile : string;
    FSplitLocalDir : string;

    FThread  : TDownloadThread;
    FPostControlesThread   : TPostControlesThread;

    FErrorLevel  : integer;
    FHidden      : Boolean;
    FIBService   : Boolean;
    FIBStarted   : Boolean;
    FIBPath      : string;
    FIBVersion   : string;
    FNODE_GROUP_ID : string;
    FSENDER_PARAM : string;

    FGinkoiaPath    : string;
    FEasyPath       : string;
    FConsoleWebUrl  : string;
    FTraitementEncours : Boolean;
    FSplitDIR       : string;
    FDB      : TDossierInfos;
    FEASY    : TSymmetricDS;
    FInstallTHread : TInstallDossierMagThread ;
    FCanClose  : Boolean;
    FSizeItem : Int64;
    procedure ChangeRadios();

    procedure MessageHint(AMessage:string;AControl:TControl);
    procedure SetGinkoiaPath(Avalue:string);
    procedure SetEasyPath(Avalue:string);
    procedure CompleteInfos;
    procedure Actualiser_Etat_Service_EASY;
    procedure Etat_Fichier_Properties(APath:string);
    procedure Installation_Easy;
//    procedure DesInstallion_Easy;
    function FindGinkoiaPath:Boolean;
    function ControlURL(aUrl:string):boolean;
    // CallBack
    Procedure StatusCallBack(Const s:String);
    Procedure ProgressInstallCallBack(Const value:integer);
    procedure PostControlesCallBack(Sender: TObject);

    procedure LectureFichierInf();
    procedure Un7zSplitFile(zipFullFname:string);
    procedure Un7zVersion(z7Version:string);
    procedure Actualise_Ecran();
    procedure Joue_MiniSplit();
    procedure InstallationBase();
    procedure SetTraitementEnCours(aValue:boolean);
    function ControleDB:boolean;

//    procedure Parse_Json_Datas(astr:string);

    function DoEtape1():boolean;
    procedure DoEtape2();
    procedure DoEtape3();
    procedure DoEtape4();
    procedure DoEtape6();
    function  ResultEtape4():boolean;
    function AnalyseSplit():boolean;

    procedure DoLog(aValue:string);
    procedure Creation7zdll;
    procedure DoDownloadSplitFile();
    function GetSplittagesDistants:boolean;
    function GetSplitsDistants(aDossier:string):Boolean;
//    function ProgressCallBack(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
    { Déclarations privées }
    function GetDossiersDistants:Boolean;
  public
    property Hidden            : Boolean      read FHidden            write FHidden;
    property TraitementEnCours : boolean      read FTraitementEncours write SetTraitementEnCours;
    property IBPath            : string       read FIBPath            write FIBPath;
    property GinkoiaPath       : string       read FGinkoiaPath       write SetGinkoiaPath;
    Property EasyPath          : string       read FEasyPath          write SetEasyPath;
    Property SizeItem          : Int64        read FSizeItem          write FSizeItem;
    Property NODE_GROUP_ID     : string       read FNODE_GROUP_ID     write FNODE_GROUP_ID;
    Property SENDER_PARAM     : string       read FSENDER_PARAM     write FSENDER_PARAM;

    { Déclarations publiques }
  end;

var
  Form_Main: TForm_Main;

implementation

{$R *.dfm}

{uses uListSplittagesDistants, uListGVersionsDistants;}

function CopyCallBack(
  TotalFileSize: LARGE_INTEGER;          // Taille totale du fichier en octets
  TotalBytesTransferred: LARGE_INTEGER;  // Nombre d'octets déjàs transférés
  StreamSize: LARGE_INTEGER;             // Taille totale du flux en cours
  StreamBytesTransferred: LARGE_INTEGER; // Nombre d'octets déjà tranférés dans ce flus
  dwStreamNumber: DWord;                 // Numéro de flux actuel
  dwCallbackReason: DWord;               // Raison de l'appel de cette fonction
  hSourceFile: THandle;                  // handle du fichier source
  hDestinationFile: THandle;             // handle du fichier destination
  progressBar : TProgressBar
  ): DWord; far; stdcall;

begin
  // Calcul de la position en % :
  ProgressBar.position := TotalBytesTransferred.QuadPart * 100 Div TotalFileSize.QuadPart;
  // La fonction doit définir si la copie peut être continuée.
  Result := PROGRESS_CONTINUE;
  Application.ProcessMessages;
end;


procedure TForm_Main.SetTraitementEnCours(aValue:boolean);
begin
   FTraitementEncours:=AValue;
   // faudrait activer/désactiver
//   BRemoteSplit.Enabled:=not(aValue);
//   bLocalSplit.Enabled:=not(aValue);
//   BRemoteVersion.Enabled:=not(aValue);
   // Mais BBASEInstall dépend d'autres trucs, répertoire temporaire du split etc..
   if AValue
      then
        begin
//            BBASEINSTALL.Enabled := false;
//            cbVersion.Enabled    := false;
        end;
end;

Procedure TForm_Main.StatusCallBack(Const s:String);
begin
  sb_Status.Panels[0].Text  := s;
  DoLog(s);
end;

Procedure TForm_Main.ProgressInstallCallBack(Const value:integer);
begin
    pbGeneral.Visible  := true;
    pbGeneral.Position := value;
end;


procedure TForm_Main.rbSplitClick(Sender: TObject);
begin
    ChangeRadios();
end;


procedure TForm_Main.ChangeRadios();
begin
    if rbSplitLocal.Checked then
      begin
        Label16.Visible:=false;
        cbDossiers.Visible:=false;
        Label17.Visible:=false;
        cbSENDER.Visible:=false;
        BEtape2.Caption:='Dézip Split Complet';
        teSplitLocal.Visible:=true;
        bSplitLocal.Visible:=true;
      end
    else
      begin
        Label16.Visible:=true;
        cbDossiers.Visible:=true;
        Label17.Visible:=true;
        cbSENDER.Visible:=true;
        BEtape2.Caption:='Download et Dézip Split Complet';
        teSplitLocal.Visible:=false;
        bSplitLocal.Visible:=false;
      end;
end;

procedure TForm_Main.SetEasyPath(Avalue:string);
begin
    FEasyPath:=Avalue;
end;

procedure TForm_Main.SetGinkoiaPath(Avalue:string);
begin
    FGinkoiaPath:=Avalue;
end;

procedure TForm_Main.teURLMasterEnter(Sender: TObject);
begin
// BInstaller.Enabled:=false;
end;

procedure TForm_Main.teURLMasterExit(Sender: TObject);
begin
// BInstaller.Enabled:=false;
end;

procedure TForm_Main.timAUTOTimer(Sender: TObject);
begin
   timAUTO.Enabled:=False;
   // Comme ca on arrêtre le Timer
   if FStopError
    then
      begin
          DoLog('Arrêt de l''installation automatique suite à une erreur');
          FErrorLevel := 9;
          Close;
          exit;
      end;

   if FStopFinish
    then
      begin
          DoLog('Passage en Etat Arrêt : StopFinish');
          exit;
      end;

   try
     // Ce Timer va Appuyer sur les boutons les un après les autres
     If BEtape6.Enabled
       then
          begin
              FStopFinish := true; // On arrete le timer au prochain passage
              DoLog(BEtape6.Caption);
              BEtape6.Click;
              exit;
          end;

     If BEtape5.Enabled
       then
          begin
              DoLog(BEtape5.Caption);
              BEtape5.Click;
              exit;
          end;

     If BEtape4.Enabled
       then
          begin
              DoLog(BEtape4.Caption);
              BEtape4.Click;
              exit;
          end;

     If BEtape3.Enabled
       then
          begin
              DoLog(BEtape3.Caption);
              BEtape3.Click;
              exit;
          end;

     If BEtape2.Enabled
       then
          begin
              DoLog(BEtape2.Caption);
              BEtape2.Click;
              exit;
          end;

     If BEtape1_5.Enabled
        then
          begin
              DoLog(BEtape1_5.Caption);
              BEtape1_5.Click;
              exit;
          end;

     If BEtape1.Enabled
        then
          begin
              DoLog(BEtape1.Caption);
              BEtape1.Click;
              exit;
          end;
   finally
       timAUTO.Enabled := true;
   end;
end;

procedure TForm_Main.BtnSymmetricDSClick(Sender: TObject);
var dlgopenFile:TOpenDialog;

begin
{  // Ouvre un fichier de base de données
  dlgopenFile:=TOpenDialog.Create(self);
  try
    dlgOpenFile.InitialDir  := ExtractFileDir(teIBFile.Text);
    if dlgopenFile.Execute()
      then
          begin
            teIBFile.Text := dlgopenFile.FileName;
            // on enregistre la base0   ... dangereux... NON ??!
            // WriteBase0(teIBFile.Text);
            FindGinkoiaPath;
            FEASY.Repertoire  := FGinkoiaPath+'EASY';
            CompleteInfos;
          end;
  finally
    dlgopenFile.Free;
  end;
}
end;

procedure TForm_Main.BEtape1_5Click(Sender: TObject);
begin
    BEtape1_5.Enabled:=false;
    cb_Drive.Enabled:=false;
    // Ecriture du BASE0
    if FBase0=''
      then
         begin
           // Ecriture de la base 0
           FBase0 := cb_Drive.Text + '\Ginkoia\data\Ginkoia.ib';
           WriteBase0(FBase0);
           BEtape2.Enabled := true;
           lbl_Result1_5.Visible := true;
           lbl_Result1_5.Caption := CST_OK;
           lbl_Result1_5.Font.Color   := clGreen;
         end
     else
       begin
           if LowerCase(FBase0)<>LowerCase(cb_Drive.Text + '\Ginkoia\data\Ginkoia.ib')
             then
                begin
                    // Si en Mode Auto on ne pose pas de question....
                    // C'est CB_Drive qui a raison
                    if Fauto or (MessageDlg(PChar(Format('La base0 va être écrasée.' + #13#10 +
                      'L''ancienne valeur :  %s' + #13#10 + 'La nouvelle valeur sera : %s' +
                      #13#10 + 'Voukez-vous continuer ?', [FBase0,cb_Drive.Text + '\Ginkoia\data\Ginkoia.ib' ])),  mtWarning, mbOKCancel, 0) =
                      mrOk) then
                        begin
                             FBase0 := cb_Drive.Text + '\Ginkoia\data\Ginkoia.ib';
                             WriteBase0(FBase0);
                             BEtape2.Enabled := true;
                             lbl_Result1_5.Visible := true;
                             lbl_Result1_5.Caption := CST_OK;
                             lbl_Result1_5.Font.Color   := clGreen;
                        end
                      else
                        begin
                          BEtape1_5.Enabled := true;
                          cb_Drive.Enabled  := true;
                          lbl_Result1_5.Visible := true;
                          lbl_Result1_5.Caption := CST_ERREUR;
                          lbl_Result1_5.Font.Color := clRed;
                          Exit;
                        end;
                end
             else
              begin
                 // C'était pareil... donc c'est tout bon.... on passe à la suite
                 BEtape2.Enabled := true;
                 lbl_Result1_5.Visible := true;
                 lbl_Result1_5.Caption := CST_OK;
                 lbl_Result1_5.Font.Color   := clGreen;
              end;
       end;
    GetDossiersDistants;
    // BRefresh.Enabled:=true;
end;

procedure TForm_Main.cbDossiersChange(Sender: TObject);
begin
    GetSplitsDistants(cbDossiers.Text);
end;

{
procedure TForm_Main.GetSplittagesDistants;
var json : string;
    IdHTTP: TIdHTTP;
    vUrl : Widestring;
begin
  IdHTTP        := TIdHTTP.Create;
  json          := '';
  try
    vUrl := 'http://easy-ftp.ginkoia.net/list_splits.php';
    if NomPourNous<>''
      then vUrl := vUrl + '?dossier='+ LowerCase(NomPourNous);
    json := IdHTTP.Get(vUrl);
  finally
    IdHTTP.Free;
  end;
  // On parse maintenant
  Parse_Json_Datas(json);
end;
}

{
procedure TForm_Main.BRemoteSplitClick(Sender: TObject);
begin
    Application.CreateForm(TFrm_SplittagesDistants,Frm_SplittagesDistants);
    Frm_SplittagesDistants.Showmodal;

end;

procedure TForm_Main.BRemoteVersionClick(Sender: TObject);
begin
    Application.CreateForm(TFrm_GversionsDistants,Frm_GversionsDistants);
    Frm_GversionsDistants.Showmodal;
end;
}

procedure TForm_Main.bSplitLocalClick(Sender: TObject);
var vOpenDialog:TOpenDialog;
begin
  vOpenDialog := TOpenDialog.Create(self);
  vOpenDialog.InitialDir := cb_Drive.Text + '\Ginkoia\Data';
  vopenDialog.Filter := 'Split files|*.split';
  if vopenDialog.Execute
    then
      begin
        teSplitLocal.Text := vOpenDialog.FileName;
      end;
end;

procedure TForm_Main.InstallCallBack(Sender: TObject);
var vTmpThread:TInstallDossierMagThread;
begin
  // Retour du Thread
  pbGeneral.Visible := false;
  sb_Status.Panels[0].Text := 'Installation Terminée';
  BEtape6.Enabled := true;
  if Assigned(FInstallTHread) then
    begin
      vTmpThread := FInstallThread;
      FInstallThread := nil;
      if vTmpThread.ReturnValue<>0 then
        begin
          lbl_Result5.Font.Color:=clRed;
          lbl_Result5.Caption:=CST_ERREUR;
          DoLog(vTmpThread.GetErrorLibelle(vTmpThread.ReturnValue));
        end
      else
        begin
          lbl_Result5.Font.Color:=clGreen;
          lbl_Result5.Caption:=CST_OK
        end;
      lbl_Result5.Visible:=true;
    end;

  Application.ProcessMessages;
  FCanClose :=true;

//  if FLancementAuto
//    then DoEtape6();

{
  pbGeneral.Visible := false;
  sb_Status.Panels[0].Text := 'Traitement Terminé.';
  CompleteInfos;

}
end;

procedure TForm_Main.BINSTALLClick(Sender: TObject);
begin
{
    // Lancement d l'installation...
    if FDB.RegistrationUrl=''
      then
        begin
          MessageDlg('Pas d''Url du Noeud Maitre',  mtError, [mbOK], 0);
          exit;
        end;
    if FDB.BAS_IDENT=0
      then
        begin
          MessageDlg('Impossible d''Installer c''est une base 0',  mtError, [mbOK], 0);
          exit;
        end;


    FCanClose := false;
    ProgressBar.Visible    := true;
    BINSTALL.Enabled       := false;
    BtnSymmetricDS.Enabled := false;
    lbl_EASY.Caption := 'EASY : Installation en cours...';
    FInstallTHread   := nil;
    FInstallTHread   := TInstallDossierMagThread.Create(true,StatusCallBack,ProgressInstallCallBack,InstallCallBack);
    FInstallTHread.DB   := FDB;
    FInstallTHread.EASY := FEASY;
    FInstallTHread.Start;
}
end;

procedure TForm_Main.CompleteInfos;
var sGrp : string;
    sEngine : string;
    i:integer;
begin
    try
      try
        // IMGEASYOK.Visible := false;
        // IMGEASYKO.Visible := false;

        FDB.init;
        FDB.DatabaseFile := FBase0;
        if FDB.DatabaseFile='' then
          exit;


        DataMod.Ouverture_IBFile(FDB);

        // Si FDB.RegistrationUrl=0 il nous faut au moins le minisplittage
        // teURLMaster.Text := FDB.RegistrationUrl;

        // -------------------------------------------------------------------------
        // le fichier .properties est-il déjà présent ?
        FDB.ServiceName    := 'EASY';
        FDB.HTTPPort       :=  32415; // Forcement en Magasin

        FDB.DatabaseFile   := FBase0;
        FDB.SymDir         := FGinkoiaPath + 'EASY';
        FDB.ExternalID     := Sender_To_Node(FDB.BAS_SENDER);
        sGrp               := 'mags';
        sEngine            := Format('%s-%s',[sGrp,FDB.ExternalID]);
        FDB.PropertiesFile := Format('%s\engines\%s.properties',[FDB.SymDir,sEngine]);

        {
        teNode.Text        := FDB.Nom;
        Edit1.Text         := IntToStr(FDB.BAS_IDENT);
        Edit3.Text         := FDB.BAS_SENDER;
        Edit2.Text         := Sender_To_Node(FDB.BAS_SENDER);
        Edit4.Text         := FDB.BAS_GUID;
        Edit5.Text         := FDB.BAS_PLAGE;
        Edit6.Text         := FDB.GENERAL_ID;
        }

        // Si le Fichier Existe cela veut dire que c'est déja installé !
        {
        if FileExists(FDB.PropertiesFile)
          then
            begin
               lbl_EASY.Caption := 'EASY : Installé';
               // IMGEASYOK.Visible := true;
               BtnSymmetricDS.Enabled  := false;
               BINSTALL.Enabled  := false;
            end
          else
            begin
               lbl_EASY.Caption := 'EASY : Pas encore installé';
               // IMGEASYKO.Visible := true;
               BINSTALL.Enabled  := true;
            end;
        }
      Except


      end;
    finally

    end;
end;


procedure TForm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ExitCode := FErrorLevel;
end;

procedure TForm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose:=FCanClose;
end;

function TForm_Main.FindGinkoiaPath:Boolean;
begin
{
    FGinkoiaPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(Readbase0)));
    result       := FileExists(Readbase0);
    Image1.Visible   := not(result);
    imgBase0.Visible := result;
    if not(Result) then
       begin
        imgBase0.Hint := 'Le fichier ' + Readbase0 + ' existe, il vous faut un minisplit';
        imgBase0.ShowHint := true;
        Image1.Hint     := 'Le fichier ' + Readbase0 + ' n''existe pas, il vous faut un split complet';
        Image1.ShowHint := true;
       end;
}
end;

{
procedure TForm_Main.Etat_Interbase;
var str:string;
    i:integer;
    vServices : Boolean;
    vStarted  : Boolean;
    vVersion  : string;
begin
    vServices := ServiceExist('','IBS_gds_db') and ServiceExist('','IBG_gds_db');
    vStarted  := (ServiceGetStatus('','IBS_gds_db')=4) and (ServiceGetStatus('','IBG_gds_db')=4);
    str:=InfoService('IBS_gds_db');
    i:=Pos('\bin\ibserver.exe',str,1);
    if i>0 then
      begin
        str:=Copy(str,0,i+16);
      end;
    // -------------------------------------------------------------------------
    vVersion := GetFileVersion(str);
//    lblInterbase.Caption := 'Interbase : ' + vVersion;
    FIBPath    := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(str)));
    FIBVersion := vVersion;

    if not(vServices and vStarted  and (vVersion='WI-V10.0.5.595'))
      then mLog.Lines.Add('Problème Interbase : ' + vVersion );

//    imgIBOK.Visible :=
//    imgIBKO.Visible:=not(imgIBOK.Visible);
end;
}

procedure TForm_Main.Etat_Fichier_Properties(APath:string);
var searchResult : TSearchRec;
    i:integer;
    nom:string;
begin
{    i:=0;
    SetCurrentDir(Format('%s\engines\',[APath]));
    If FindFirst('*.properties',faAnyFile,SearchResult)=0 then
    begin
      repeat
         inc(i);
         if i=1 then teFileProperties.Text:=Format('%s\engines\%s',[APath,searchResult.Name]);
      until FindNext(searchResult)<>0;
     FindClose(searchResult);
    end;
    // Etat Normal seulement s'il y a qu'un seul fichier !
    if i=1
      then
        begin
           //
            teURLMaster.Enabled:=false;
            With TStringList.Create do
              begin
                  try
                    LoadFromFile(teFileProperties.Text);
                    NameValueSeparator    := '=';
                    teURLMaster.Text:=StringReplace(Values['registration.url'],'\','',[rfReplaceAll]);
                    ImgDBOK.Visible:=true;
                  finally
                     free;
                  end;
              end;
        end;
    ImgDBKO.Visible:=not(ImgDBOK.Visible);
    setCurrentDir(VGSE.ExePath);
    }
end;


procedure TForm_Main.Creation7zdll;
var ResScripts:TResourceStream;
begin
    F7zdll := IncludeTrailingPathDelimiter(VGSE.ExePath)+'7z.dll';
    if not(FileExists(F7zdll))
      then
       begin
          ResScripts := TResourceStream.Create(HInstance, '7zipdll', RT_RCDATA);
          try
            if not(FileExists(F7zdll)) then
              ResScripts.SaveToFile(F7zdll);
            finally
            ResScripts.Free();
          end;
       end;
end;

procedure TForm_Main.Actualiser_Etat_Service_EASY;
var i:integer;
begin
    WMI_GetServicesSYMDS_ONLY_EASY;

    {
    lblEasyInstall.Caption:='Non';
    BAction.Enabled:=false;
    LblEasyEtat.Caption:='';
    Label8.Caption:='';
    Label12.Caption:='';
    Label10.Caption:='';
    Label18.Caption:='';

    Label12.Caption:='';
    FConsoleWebUrl:='';
    ImgEASYOK.Visible:=false;
    ImgEASYKO.Visible:=false;
    for i:=0 to Length(VGSYMDS)-1 do
       begin
        if VGSYMDS[i].ServiceName=sEASY
          then
              begin
                 EasyPath:=VGSYMDS[i].Directory;
                 // lblEasyInstall.Caption:='Oui';
                 If VGSYMDS[i].Status='Running' then
                    begin
                        LblEasyEtat.Caption:='En cours d''exécution';
                        // BAction.Caption:='Arrêter';
                        ImgEASYOK.Visible:=true;
                        // BAction.Visible:=true;
                        //BAction.Enabled:=true;
                        BCONSOLEWEB.Enabled:=true;
                    end;
                 If VGSYMDS[i].Status='Stopped' then
                    begin
                        LblEasyEtat.Caption:='Arrêté';
                        // BAction.Caption:='Démarrer';
                        //BAction.Visible:=true;
                        //BAction.Enabled:=true;
                        BCONSOLEWEB.Enabled:=false;
                    end;
                 If VGSYMDS[i].StartMode='Auto' then
                    begin
                        Label12.Caption:='Automatique';
                    end;
                 If VGSYMDS[i].StartMode='Manual' then
                    begin
                        Label12.Caption:='Manuel';
                    end;
                 If VGSYMDS[i].StartMode='Disabled' then
                    begin
                        Label12.Caption:='Désactivé';
                    end;

                 FConsoleWebUrl:=Format('http://localhost:%d/app',[VGSYMDS[i].http]);
                 // Label8.Caption:=Format('%d, %d, %d, %d',[VGSYMDS[i].http,VGSYMDS[i].https,VGSYMDS[i].jmxhttp,VGSYMDS[i].jmxagent]);
                 // Label10.Caption:=Format('%s',[VGSYMDS[i].Directory]);

                 Label18.Caption := 'Erreur';
                 if FileExists(EasyPath+'\lib\interclient.jar')
                   then Label18.Caption:='OK';
              end;
       end;
  if lblEasyInstall.Caption='Non'
    then
      begin
          BAction.Enabled:=false;
          BEasyInstall.Caption:='Installer';
          BEasyInstall.Enabled:=true;
          BAction.Enabled:=false;
          BAction.Visible:=false;
          BCONSOLEWEB.Enabled:=false;
      end
    else
      begin
          BAction.Enabled:=true;
          BEasyInstall.Caption:='Désinstaller';
          BEasyInstall.Enabled:=BAction.Caption='Démarrer';
      end;
  // EasyPath:=FGinkoiaPath+'EASY';
  // ImgEASYKO.Visible:=not(ImgEASYOK.Visible);

  Label17.Caption := 'Erreur';
  if FileExists(FInterbasePath+'\UDF\sym_udf.dll')
    then Label17.Caption:='OK';
  }

end;

procedure TForm_Main.Actualise_Ecran();
begin
{
   If FindGinkoiaPath
     then
       begin
          Actualiser_Etat_Service_EASY;
          // teIBFile.Text := Readbase0;
          CompleteInfos;
          if (teURLMaster.Text='')
            then // Minisplittage
              begin
                 gb_Split.Visible := true;
                 gb_Split.Enabled := true;

                 gb_EASY.Visible := true;
                 gb_EASY.Enabled := false;

                 edt_BASE0.Text := Readbase0;
                 BBASEINSTALL.Enabled := FileExists(edt_BASE0.Text);
                 cbVersion.Enabled    := BBASEINSTALL.Enabled;
                 cbVersion.Visible    := BBASEINSTALL.Enabled;

                 BLocalSplit.Visible := true;
                 BLocalSplit.Enabled := true;

                 BINSTALL.Enabled  := false;
                 teIBFile.Enabled  := false;
                 BtnSymmetricDS.Enabled := False;
              end
            else
              begin
                FEASY.Nom         := sEASY;
                FEASY.Repertoire  := FGinkoiaPath+'EASY';
                FEASY.http        := 32415;
                FEASY.https       := 32417;
                FEASY.jmx         := 32416;
                FEASY.agent       := 32418;
                FEASY.server_java := False; //
                FEASY.memory      := 1024;
                FEASY.IsLame      := false;

                gb_Split.Visible := false;
                gb_Split.Enabled := false;

                gb_EASY.Visible  := true;
                gb_EASY.Enabled  := true;

               end;
       end
     else
      begin
         // Mode Split Complet
         gb_Split.Visible := true;
         gb_Split.Enabled := true;

         gb_EASY.Visible := false;
         gb_EASY.Enabled := false;


         edt_BASE0.Text := Readbase0;
         BBASEINSTALL.Enabled := not(FileExists(edt_BASE0.Text)) and (FileExists(edtSplitIBFile.Text));
         cbVersion.Enabled    := BBASEINSTALL.Enabled;
         cbVersion.Visible    := BBASEINSTALL.Enabled;

         BLocalSplit.Visible := true;
         BLocalSplit.Enabled := true;

         BRemoteSplit.Visible := true;
         BRemoteSplit.Enabled := true;
         BRemoteVersion.Enabled := true;

         BINSTALL.Enabled  := false;
         teIBFile.Enabled  := false;
         BtnSymmetricDS.Enabled := False;
      end;
  sb_status.Panels[0].Text:='';
  }
end;

procedure TForm_Main.FormCreate(Sender: TObject);
var vdir : string;
    i:integer;
    vTempStr : string;
    vDrives :TDrives;
    param : string;
    value : string;
begin
    FNODE_GROUP_ID := 'mags';
    SENDER_PARAM := '';
    FErrorLevel := 1;
    // ExitCode := 1;
    Caption := Caption + ' - ' + FileVersion(ParamStr(0));

    vDrives := WMI_GetDrivesInfos;
    cb_Drive.Clear;
    for I := Low(vDrives) to High(vDrives) do
        begin
          cb_Drive.Items.Add(vDrives[i].DeviceID);
        end;
    if High(vDrives)>0 then cb_Drive.ItemIndex:=0;

    FAUTO_FROM_IB := false;

    // Creation 7z.dll
    Creation7zdll;
    // CreationRessources;
    FCanClose :=True;

    FBase0       := Readbase0;

    WMI_GetServicesSYMDS_ONLY_EASY;

    FJava7z := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'JAVA.7Z';
    FSymDSjar := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'symmetric-pro-3.7.36-setup.jar';

    FIBService   := ServiceExist('','IBS_gds_db') and ServiceExist('','IBG_gds_db');
    FIBStarted   := (ServiceGetStatus('','IBS_gds_db')=4) and (ServiceGetStatus('','IBG_gds_db')=4);
    vTempStr:=InfoService('IBS_gds_db');
    i:=Pos('\bin\ibserver.exe',vTempStr,1);
    if i>0 then
      begin
        vTempStr:=Copy(vTempStr,0,i+16);
      end;
    FIBVersion := GetFileVersion(vTempStr);
    FIBPath    := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(vTempStr)));
    // Savoir s'il y a déja du EASY ou SymmetricDS

    TraitementEncours := False;
    vdir := Uppercase(IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))));
    {
    if (AnsiPos('C:\GINKOIA\',vDir)=1) or
       (AnsiPos('D:\GINKOIA\',vDir)=1)
      then
      begin
          MessageDlg('Veuillez deplacer le programme !'+#10+
                     'Ne pas lancer ce programme depuis le répertoire Ginkoia',  mtError, [mbOK], 0);
          Application.Terminate;
      end;
    }

    // FGVersion := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName))+'GVERSIONS\';

    // Etat_Java;
    // On est obligé de poser l'UDF avant si on ne veut pas avoir des erreurs sur la base
    // En effet la base redescend d'un splittage et cette base possède la liaison avec un UDF qu'on a pas encore !
    // dès qu'on va faire une requete dans la base on peut la casser !
    if (FIBVersion>='WI-V10.0.5.595')
      then
        begin
            // On Pose d'UDF avant car sinon on peut avoir des problèmes à la lecture de la base
            // même si on utilise pas les fonctions de l'UDF encore à ce moment là
            PoseUDF(FIBPath);
            Actualise_Ecran();
{            If FindGinkoiaPath
              then
                begin
                  Actualiser_Etat_Service_EASY;
                  teIBFile.Text := Readbase0;
                  CompleteInfos;

                  FEASY.Nom         := sEASY;
                  FEASY.Repertoire  := FGinkoiaPath+'EASY';
                  FEASY.http        := 32415;
                  FEASY.https       := 32417;
                  FEASY.jmx         := 32416;
                  FEASY.agent       := 32418;
                  FEASY.server_java := False; //
                  FEASY.memory      := 1024;
                  FEASY.IsLame      := false;
                end
            // le split n'est pas encore posé
            else
                begin
                   edt_BASE0.Text := Readbase0;
                   BBASEINSTALL.Enabled:=not(FileExists(edt_BASE0.Text));

                   BSplittage.Visible := true;
                   BSplittage.Enabled := true;

                   GroupBox1.Enabled := false;
                   BINSTALL.Enabled  := false;
                   teIBFile.Enabled  := false;
                   BtnSymmetricDS.Enabled := False;
                end;
}
        end
      else
        begin
        end;

    FSplitLocalDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'split\';
    ForceDirectories(FSplitLocalDir);

    GetDossiersDistants();


    //--------------------------------------------------------------------------
    FAuto      := false;
    FStopError := false;
    FStopFinish := False;
    for i :=1 to ParamCount do
      begin
          if (UpperCase(ParamStr(i))='AUTO')
            then
              begin
                  //FHidden := true;
                  FAuto   :=true;
                  rbSplitLocal.Checked:=true;
                  timAUTO.Enabled:=true;
                  DoLog('MODE AUTO Lancement dans 3 secondes');
              end;

          param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
          value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));

          If UPPERCASE(param)='DRIVE'
            then
              begin
                  // Seulement les 2 premier caractères 'C:\' ==> "C:"
                  cb_Drive.Text := Copy(UpperCase(value),1,2);
                  DoLog('Lecteur :' + cb_Drive.Text);
              end;

          If UPPERCASE(param)='SPLIT'
            then
              begin
                 teSplitLocal.Text := value;
                 DoLog('Split :' + teSplitLocal.Text);
              end;

          //--------------------------------------------------------------------
          If UPPERCASE(param)='SENDER'
            then
              begin
                 FAUTO_FROM_IB := True;
                 DoLog('Sender :' + value);
                 SENDER_PARAM := value;
                 // On passe directement à l'etape XXX ?
                 // La base GINKOIA est en place
              end;

          If UPPERCASE(param)='GROUPE'
            then
              begin
                 FNODE_GROUP_ID := LowerCase(value);
                 DoLog('Groupe :' + value);
              end;



      end;
end;

procedure TForm_Main.BEasyInstallClick(Sender: TObject);
begin
{
    BEasyInstall.Enabled:=false;
    Self.Enabled:=false;
    if BEasyInstall.Caption='Installer' then
      begin
         Installation_Easy;
      end;
    if BEasyInstall.Caption='Désinstaller' then
      begin
          if MessageBox(0, 'Voulez-vous réellement désintaller le service EASY ?', '',
            MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = IDYES then
            begin
              DesInstallion_Easy;
            end;
      end;
    Actualiser_Etat_Service_EASY;
    Etat_Fichier_Properties(FDB.SymDir);
    Self.Enabled:=True;
    }
end;

procedure TForm_Main.BEtape1Click(Sender: TObject);
var vResult : Boolean;
    vGenreplicPLACEBASE: string;
begin
    BEtape1.Enabled:=False;
    if FAUTO_FROM_IB and FAuto then
      begin
        // Mettre quelques autre controles....
        // le Service EASY existe, Interbase est ok
        // BASE0 lettre de lecteur etc....
        if Length(VGSYMDS)>0 then
          begin
            DoLog('Le service EASY Existe déjà : veuillez désinstaller le service et supprimer le répertoire EASY');
            exit;
          end;

        FBase0 := cb_Drive.Text + '\Ginkoia\data\Ginkoia.ib';
        WriteBase0(FBase0);
        FBase0 := Readbase0;

        // il faut que ca corresponde... mais bon ca sera pas repliquer.... car les triggers ne sont pas encore la
        vGenreplicPLACEBASE := Uppercase(DataMod.GetCheminBaseGENREPLICATION(FBase0));
        if (UpperCase(vGenreplicPLACEBASE)<>UpperCase(FBase0))
        then
          begin
            DoLog(Fbase0);
            DoLog(vGenreplicPLACEBASE);
            DoLog('Votre Base0 (dans le registre ou/et dans Ginkoia.ib) n''est pas correctement paramétrée');
            // 1er param c'est le chemnin de la base
            // 2ème c'est aussi le chemin de la base mais c'est la valeur qu'on va stocker dans la base elle meme (genparam)
            If (DataMod.UpdateREP_PLACEBASE(UpperCase(FBase0),UpperCase(FBase0)))
              then
                begin
                  DoLog('Nouvelle valeur de REP_PLACEBASE =' + UpperCase(FBase0) + ' OK ');
                end
              else
                begin
                  DoLog('Erreur à la mise à jour de REP_PLACEBASE');
                  exit;
                end;
          end;

        // Il y a egalement d'autre controles à faire.....est-ce que les générateurs sont OK ?
        // est-ce que SYMDS est bien désinstaller correctement de GINKOIA.IB                 ?
        // > on me balance un SENDER est-ce bien le bon ?
        // > SYM_DS doit etre totalement absent de la base !

        if DataMod.IsEasyInstalled(Fbase0) then
          begin
            DoLog('Il reste des traces de EASY dans la base');
            exit;
          end;


        if FileExists(F7zdll) and FileExists(FJava7z) and FileExists(FSymDSjar)
           and FIBService and FIBStarted  and (FIBVersion>='WI-V10.0.5.595')
           and (Length(VGSYMDS)=0) and PoseUDF(FIBPATH)
        then
            begin
              ControleDB;
              Lbl_Infos.Caption := 'Base0 : '      + FBase0  + #13+#10+
                               'Dossier : '    + FDB.Nom + #13+#10+
                               'Générateur : ' + IntToStr(FDB.BAS_IDENT)  + #13+#10+
                               'Sender : '     + FDB.BAS_SENDER + #13+#10+
                               'GUID   : '     + FDB.BAS_GUID   + #13+#10+
                               'Plage  : '     + FDB.BAS_PLAGE  + #13+#10+
                               'GeneralID  : ' + FDB.GENERAL_ID + #13+#10+
                               'ExternalID : ' + FDB.ExternalID + #13+#10+
                               'PropertiesFile : ' + ExtractFileName(FDB.PropertiesFile) + #13+#10+
                               'Url : '        + FDB.RegistrationUrl;
               DoEtape4();
            end;
         exit;
      end;


    vResult := DoEtape1();
    Application.ProcessMessages;
    lbl_Result1.Caption:='';
    {
    vPreControls := Precontrols;
    vControleDB  := ControleDB;
    }
    CompleteInfos;
                  // -----------------------------------------------------------
                  Lbl_Infos.Caption := 'Base0 : '      + FBase0  + #13+#10+
                         'Dossier : '    + FDB.Nom + #13+#10+
                         'Générateur : ' + IntToStr(FDB.BAS_IDENT)  + #13+#10+
                         'Sender : '     + FDB.BAS_SENDER + #13+#10+
                         'GUID   : '     + FDB.BAS_GUID   + #13+#10+
                         'Plage  : '     + FDB.BAS_PLAGE  + #13+#10+
                         'GeneralID  : ' + FDB.GENERAL_ID + #13+#10+
                         'ExternalID : ' + FDB.ExternalID + #13+#10+
                         'PropertiesFile : ' + ExtractFileName(FDB.PropertiesFile) + #13+#10+
                         'Url : '        + FDB.RegistrationUrl;
//    Lbl_Infos.Caption := 'Base0 : '      + FBase0; //   + #13+#10+
{
                         'Dossier : '    + FDB.Nom + #13+#10+
                         'Générateur : ' + IntToStr(FDB.BAS_IDENT)  + #13+#10+
                         'Sender : '     + FDB.BAS_SENDER + #13+#10+
                         'GUID   : '     + FDB.BAS_GUID   + #13+#10+
                         'Plage  : '     + FDB.BAS_PLAGE  + #13+#10+
                         'GeneralID  : ' + FDB.GENERAL_ID + #13+#10+
                         'ExternalID : ' + FDB.ExternalID + #13+#10+
                         'PropertiesFile : ' + ExtractFileName(FDB.PropertiesFile) + #13+#10+
                         'Url : '        + FDB.RegistrationUrl;
      }
    If vResult
      then
        begin
          lbl_Result1.Font.Color:=clGreen;
          lbl_Result1.Caption:=CST_OK;
          lbl_Result1.Visible:=true;

          BEtape1_5.Enabled    := true;
          cb_Drive.Enabled    := true;
          Label18.Enabled     := true;
          cbDossiers.Enabled  := true;
          Label16.Enabled     := true;
          cbSENDER.Enabled    := true;
          Label17.Enabled     := true;
//            else BEtape4.Enabled := true
        end
      else
        begin
          FStopError := FAuto;

          if (Length(VGSYMDS)=0)
            then
              begin
                  lbl_Result1.Font.Color:=clRed;
                  lbl_Result1.Caption:=CST_ERREUR;
                  lbl_Result1.Visible:=true;
                  Application.ProcessMessages;
                  BEtape1.Enabled := true;
              end
            else
              begin
                  lbl_Result1.Font.Color:=clBlue;
                  lbl_Result1.Caption:=CST_DEJAINSTALL;
                  lbl_Result1.Visible:=true;
                  Application.ProcessMessages;
                  BEtape1.Enabled := true;

                  cb_Drive.Text := ExtractFileDrive(FBase0);
                  cbDossiers.Text := FDB.Nom;
                  cbSENDER.Text := FDB.BAS_SENDER;

              end;
        end;
//   BEtape1.Enabled := false;
end;

{
procedure TForm_Main.Parse_Json_Datas(astr:string);
var  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;
  vItem     : string;
  IsMiniSplit : Boolean;
begin
   try
    LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0) as TJSONArray;
    try
       FSplitFile:='';
       for LJsonValue in LJsonArr do
       begin
          for LItem in TJSONArray(LJsonValue) do
            begin
                if (TJSONPair(LItem).JsonString.Value='filename')
                  then
                     begin
                        FSplitFile := TJSONPair(LItem).JsonValue.Value;
                        // break;
                     end;
                if (TJSONPair(LItem).JsonString.Value='splittype') and (FSplitFile<>'')
                    and (TJSONPair(LItem).JsonValue.Value='mini')
                  then
                    begin
                       break;
                    end;

            end;
       end;
     finally
      LJsonArr.DisposeOf;
     end;
   Except

   end;
end;
}


function TForm_Main.GetSplitsDistants(aDossier:string):Boolean;
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
           FSplitFile:='';
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
                    if ((TJSONPair(LItem).JsonString.Value='splittype') and ((TJSONPair(LItem).JsonValue.Value)='complet'))
                       and vOpen and (vSender<>'')
                      then
                         begin
                            vComplet:=true;
                            if cbSender.Items.IndexOf(TJSONPair(LItem).JsonValue.Value)=-1 then
                              cbSender.Items.Add(vSender);
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




function TForm_Main.GetDossiersDistants:Boolean;
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
           FSplitFile:='';
           for LJsonValue in LJsonArr do
           begin
              for LItem in TJSONArray(LJsonValue) do
                begin
                    if (TJSONPair(LItem).JsonString.Value='dossier')
                      then
                         begin
                             if cbDossiers.Items.IndexOf(TJSONPair(LItem).JsonValue.Value)=-1  then
                               cbDossiers.Items.Add(TJSONPair(LItem).JsonValue.Value);
                         end;
                    { On va le faire ailleurs....
                    if (TJSONPair(LItem).JsonString.Value='filename')
                      then
                         begin
                             vSender := TJSONPair(LItem).JsonValue.Value;
                             vSender := Copy(vSender,1,Length(vSender)-22);
                             if cbSender.Items.IndexOf(TJSONPair(LItem).JsonValue.Value)=-1
                               then cbSender.Items.Add(vSender);
                         end;
                    }
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


{ // On doit plus passer ici }
function TForm_Main.GetSplittagesDistants:boolean;
var json : string;
    IdHTTP: TIdHTTP;
    vUrl : Widestring;
    LJsonArr   : TJSONArray;
    LJsonValue : TJSONValue;
    LItem     : TJSONValue;
    vItem     : string;
    vIsOpen    : Boolean;
    vSplitFile : string;
    VSender, VDossier, VTypeSplit: string;
begin
  result:=false;
  DoLog('Récupération du split...');

  if FAUTO_FROM_IB then
  begin
    VDossier := LowerCase(FDB.Nom);
    VSender := UpperCase(SENDER_PARAM);
    VTypeSplit := 'mini';
  end
  else
  begin
    VDossier := LowerCase(cbDossiers.Text);
    VSender := UpperCase(cbSENDER.Text);
    VTypeSplit := 'complet';
  end;

  // Pour ISF il faudra peut-etre faire autrement... par un partage ?
  IdHTTP        := TIdHTTP.Create;
  try
    json          := '';
    try
      // vUrl := TIdURI.UrlENcode('http://easy-ftp.ginkoia.net/list_splits.php?dossier='+LowerCase(Edit7.Text)+'&sender='+UpperCase(Edit8.Text));
      vUrl := TIdURI.UrlENcode('http://easy-ftp.ginkoia.net/list_splits.php?dossier='+VDossier+'&sender='+VSender);
      json := IdHTTP.Get(vUrl);
    finally
      IdHTTP.Free;
    end;


    // On parse json maintenant
    LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONArray;
    try
       FSplitFile:='';
       for LJsonValue in LJsonArr do
       begin
          vIsOpen := false;
          if FSplitFile<>'' then break;
          vSplitFile := '';
          for LItem in TJSONArray(LJsonValue) do
            begin
                if (TJSONPair(LItem).JsonString.Value='filename')
                  then
                     begin
                        vSplitFile := TJSONPair(LItem).JsonValue.Value;
                     end;

                if (TJSONPair(LItem).JsonString.Value='splittype') and (TJSONPair(LItem).JsonValue.Value=VTypeSplit)
                    and (vSplitFile<>'')
                  then
                    begin
                      FSplitFile := vSplitFile;
                    end;
            end;
       end;
     finally
      LJsonArr.DisposeOf;
     end;
    // Avant c'était la dedans >>  Parse_Json_Datas(json);

    DoDownloadSplitFile();
    Un7zSplitFile(FFullPathSplitFile);
    result:=true;
  except
    result := False;
  end;
end;

procedure TForm_Main.DoEtape3;
begin
  BEtape3.Enabled:=false;
  if AnalyseSplit then
    begin
      lbl_Result3.Font.Color:=clGreen;
      lbl_Result3.Caption:=CST_OK;
      lbl_Result3.Visible:=true;
      BEtape4.Enabled:=true;
    end
    else
    begin
      // Si on est en mode Auto on passe FStopError à vrai car on a trouver une erreur Bloquante
      FStopError := FAuto;
      lbl_Result3.Font.Color:=clRed;
      lbl_Result3.Caption:=CST_ERREUR;
      lbl_Result3.Visible:=true;
      BEtape3.Enabled:=true;
    end;
end;

procedure TForm_Main.DoEtape2();
begin
    BEtape2.Enabled:=false;
    gb_Etape2.Enabled:=false;
    cbDossiers.Enabled:=false;
    cbSENDER.Enabled:=false;
    // Test si déjà un fichier .split en local ?
    // Nettoyage du répertoire /des fichiers .inf et .ib
    DeleteFiles(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'split','*.inf');
    DeleteFiles(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'split','*.ib');
//    DeleteFiles(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'split','*.split');
    if (rbSplitLocal.Checked) then
      begin
          If FileExists(teSplitLocal.Text)
            then
              begin
                  FFullPathSplitFile := teSplitLocal.Text;
                  Un7zSplitFile(FFullPathSplitFile);
                  lbl_Result2.Font.Color:=clGreen;
                  lbl_Result2.Caption:=CST_OK;
                  lbl_Result2.Visible:=true;
                  BEtape3.Enabled := true;
              end
            else
              begin
                // Si on est en mode Auto on passe FStopError à vrai car on a trouver une erreur Bloquante
                FStopError := FAuto;
                DoLog('Pas de fichier de split : ERREUR');
                MessageDlg('Pas de splittage local',  mtError, [mbOK],0);
                // BEtape2.Enabled:=true;
              end;
      end
    else
      begin
        If GetSplittagesDistants
          then
            begin
              lbl_Result2.Font.Color:=clGreen;
              lbl_Result2.Caption:=CST_OK;
              lbl_Result2.Visible:=true;
              BEtape3.Enabled := true;
            end
          else
            begin
              // Si on est en mode Auto on passe FStopError à vrai car on a trouver une erreur Bloquante
              FStopError := FAuto;
              DoLog('Pas de splittage distant disponible : ERREUR');
              MessageDlg('Pas de splittage distant disponible',  mtError, [mbOK],0);
              BEtape2.Enabled:=true;
            end;
      end;
end;

procedure TForm_Main.BEtape2Click(Sender: TObject);
begin
  if rbSplitLocal.Checked then
    begin
      If (teSplitLocal.Text<>'')
        then
          begin
            DOEtape2();
          end
        else
          begin
            MessageDlg('Veuillez choisir un fichier .split',  mtError, [mbOK], 0);
            teSplitLocal.SetFocus;
          end;
    end;
  if rbDistant.Checked then
    begin
      if (cbSENDER.Text<>'') and (cbDossiers.Text<>'')
        then DOEtape2()
        else
          begin
              MessageDlg('Veuillez choisir un dossier et un sender',  mtError, [mbOK], 0);
              if (cbSENDER.Text='')
                then cbSENDER.SetFocus
                else cbDossiers.SetFocus;
              exit;
          end;
    end;


end;

procedure TForm_Main.BEtape3Click(Sender: TObject);
begin
  DoEtape3;
end;

procedure TForm_Main.DoEtape4();
begin
   BEtape4.Enabled := False;
   If ResultEtape4()
     then
       begin
         lbl_Result4.Font.Color:=clGreen;
         lbl_Result4.Caption:=CST_OK;
         lbl_Result4.Visible:=true;
         BEtape5.Enabled    :=true;
       end
    else
      begin
         lbl_Result4.Font.Color:=clRed;
         lbl_Result4.Caption:=CST_ERREUR;
         lbl_Result4.Visible:=true;
         BEtape4.Enabled    :=true;
      end;
end;

procedure TForm_Main.BEtape4Click(Sender: TObject);
begin
  BEtape4.Enabled:=false;
  DoEtape4();
end;

procedure TForm_Main.BEtape5Click(Sender: TObject);
begin
    // Lancement d l'installation...
    if FDB.RegistrationUrl=''
      then
        begin
          DoLog('Pas d''Url du Noeud Maitre');
          exit;
        end;
    if FDB.BAS_IDENT=0
      then
        begin
          DoLog('Impossible d''Installer c''est une base 0');
          exit;
        end;

    FCanClose := false;
    pbGeneral.Visible    := true;
    BEtape5.Enabled       := false;

    FInstallTHread   := nil;
    FInstallTHread   := TInstallDossierMagThread.Create(true,StatusCallBack,ProgressInstallCallBack,InstallCallBack);
    FInstallTHread.DB   := FDB;
    FInstallTHread.EASY := FEASY;

    FInstallTHread.Start;
end;


function TForm_Main.ResultEtape4():Boolean;
var sGrp     : string;
    sEngine  : string;

begin
    DataMod.Ouverture_IBFile(FDB);
    result:=true;

    // dans le cas ou on est en installation automatique depuis un serveur via le deploy,
    // on ouvre le split pour mettre à jour le node_group_id à partir du fichier inf du split
    // on le fait après le ouverture_IBFILE car on à besoin du nom du dossier qui est récupéré dans la base
    if FAUTO_FROM_IB then
    begin
      // on télécharge le split
      if not GetSplittagesDistants then
      begin
         DoLog('Impossible de récuperer le minisplit : ERREUR');
         Result := false;
      end;
      // on récupère les infos du fichier inf
      if not AnalyseSplit then
      begin
         DoLog('Impossible de récuperer la valeur du NODE_GROUP_ID dans le minisplit  : ERREUR');
         Result := false;
      end;
    end;

    if FDB.RegistrationUrl=''
      then
        begin
          DoLog('Pas d''URL de LAME : ERREUR');
          result:=false;
        end;

    if FDB.BAS_IDENT=0
      then
        begin
          DoLog('Impossible d''Installer c''est une base ident 0 : ERREUR');
          result:=false;
        end;

    if (FDB.SymDir='')
      then
        begin
          DoLog('Impossible d''Installer SymDir : ERREUR');
          result:=false;
        end;


    FEASY.Nom         := 'EASY';
    FEASY.Repertoire  := cb_Drive.Text + '\Ginkoia\EASY';
    FEASY.http        := 32415;
    FEASY.https       := 32417;
    FEASY.jmx         := 32416;
    FEASY.agent       := 32418;
    FEASY.server_java := False; //
    FEASY.memory      := 1024;
    FEASY.IsLame      := false;


    FDB.ServiceName    := 'EASY';
    FDB.HTTPPort       :=  32415; // Forcement en Magasin

    // ShowMessage(FDB.BAS_SENDER);

    FDB.DatabaseFile   := cb_Drive.Text + '\Ginkoia\DATA\Ginkoia.ib';
    FDB.SymDir         := cb_Drive.Text + '\Ginkoia\EASY';
    FDB.ExternalID     := Sender_To_Node(FDB.BAS_SENDER);
    sGrp               := NODE_GROUP_ID;  // mags ou portables
    sEngine            := Format('%s-%s',[sGrp,FDB.ExternalID]);
    FDB.PropertiesFile := Format('%s\engines\%s.properties',[FDB.SymDir,sEngine]);
    FDB.NODE_GROUP_ID  := NODE_GROUP_ID;  // mags ou portables

    FDB.ServiceName  := FEASY.Nom;
    FDB.DatabaseFile := FBase0;
    FDB.httpport     := FEASY.http;

end;




procedure TForm_Main.DoDownloadSplitFile();
var
  vUrl :string;
  vDossier: string;
begin
  try
   if FAUTO_FROM_IB then
    vDossier := LowerCase(FDB.Nom)
   else
    vDossier := Lowercase(cbDossiers.Text);

   pbGeneral.Visible:=true;
   pbGeneral.Position:=0;
   pbGeneral.Refresh;
   FFullPathSplitFile :=  FSplitLocalDir + FSplitFile;
    vUrl :=
      Format('http://easy-ftp.ginkoia.net/%s/%s',[
      vDossier,
      FSplitFile
      ]);

{
    vUrl :=
      Format('http://easy-ftp.ginkoia.net/download_split.php?dossier=%s&filename=%s',[
      Lowercase(Edit7.Text),
      FSplitFile
      ]);
    }
     if FileExists(FFullPathSplitFile)
       then DeleteFile(FFullPathSplitFile);
    FThread := TDownloadThread.Create(vURL, FFullPathSplitFile, '', '', '', pbGeneral);
    while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      begin
         pbGeneral.Refresh;
         Application.ProcessMessages();
      end;
//    Bdownload.Enabled := (TDownloadThread(FThread).ReturnValue=mrOK);
    pbGeneral.Position:=pbGeneral.Max;
  finally
    FreeAndNil(FThread);
  end;
end;

function TForm_Main.ControleDB:boolean;
var vEngine, vGrp:string;
begin
    result:=false;
    FDB.init;
    FDB.DatabaseFile:=FBase0;
    DataMod.Ouverture_IBFile(FDB);

    // Si FDB.RegistrationUrl=0 il nous faut au moins le minisplittage
    // teURLMaster.Text := FDB.RegistrationUrl;
    // -------------------------------------------------------------------------
    // le fichier .properties est-il déjà présent : théoriquement non !
    //   mais c'est possible, si on a mal nettoyer l'ancienne installation ?
    FDB.ServiceName    := 'EASY';
    FDB.HTTPPort       :=  32415; // Forcement en Magasin
    FDB.SymDir         := FGinkoiaPath + 'EASY';
    FDB.ExternalID     := Sender_To_Node(FDB.BAS_SENDER);
    vGrp               := NODE_GROUP_ID; // 'mags' ou  'portables' (only push)
    vEngine            := Format('%s-%s',[vGrp,FDB.ExternalID]);
    FDB.PropertiesFile := Format('%s\engines\%s.properties',[FDB.SymDir,vEngine]);
    // Si le Fichier Existe cela veut dire que c'est déja installé ou que ca va merder à l'installation
    // plusieurs fichier properties !!! PAS BON !!!
    if (FileExists(FDB.PropertiesFile)) then
      begin
        DoLog('EASY a déjà été installé, il y a déja un fichier .properties : Attention');
        // Mais on peut controler le PostControle
        // BEtape6.Enabled := true;
        result:=False;
      end;
    if (FDB.BAS_IDENT=0) then
      begin
        DoLog('Le BAS_IDENT est sur "0" (BASE LAME) : ERREUR');
        result:=False;
      end;

    if not((FileExists(FDB.PropertiesFile))) and (FDB.BAS_IDENT<>0)
     then
      begin
         result:=True;
      end;
end;



function TForm_Main.AnalyseSplit():boolean;
var searchResult : TSearchRec;
    i:Integer;
    vInfFile : TFileName;
    vIBFile : TFileName;
    vIniFile : TIniFile;
    vDLC : TDateTime;
    vGenreplicPLACEBASE : string;
begin
  try
    // Controle de la validité du MiniSplit
    // DLC, BON Noeud, BON SENDER, NOMPOURNOUS....
    i:=0;
    if findfirst(IncludeTrailingPathDelimiter(FSplitLocalDir)+'*.inf', faAnyFile, searchResult) = 0 then
      begin
        repeat
           vInfFile := IncludeTrailingPathDelimiter(FSplitLocalDir) + searchResult.Name;
           Inc(i);
        until FindNext(searchResult) <> 0;
      end;
    if (i=0) then
      begin
        DoLog('Pas de fichier .inf dans le minisplit : ERREUR');
        result:=false;
        exit;
      end;
    if (i<>1) then
      begin
        DoLog('plusieurs fichiers .inf dans le minisplit : ERREUR');
        result:=false;
        exit;
      end;
    If FileExists(vInfFile)
      then
        begin
          vIniFile:=TIniFile.Create(vInfFile);
          vDLC    := vIniFile.ReadDateTime('SPLIT','DLC',0);
          //
          if (vDLC<Now()) then
            begin
                DoLog('Ce split a dépassé sa DLC : ERREUR');
                result:=false;
                exit;
            end;
          FNODE_GROUP_ID := vIniFile.Readstring('SPLIT','NODE_GROUP_ID','mags');
        end;

    // si on est en mode auto avec installation d'une base depuis le réseau, on s'arrête là, on veut juste le node_group_id
    if FAUTO_FROM_IB then
    begin
      Result := True;
      Exit;
    end;

    //--------------------------------------------------------------------------
    i:=0;
    if findfirst(IncludeTrailingPathDelimiter(FSplitLocalDir)+'*.ib', faAnyFile, searchResult) = 0 then
      begin
        repeat
           vIBFile := IncludeTrailingPathDelimiter(FSplitLocalDir) + searchResult.Name;
           Inc(i);
        until FindNext(searchResult) <> 0;
      end;
    if (i=0) then
      begin
        DoLog('Pas de fichier .ib dans le split : ERREUR');
        result:=false;
        exit;
      end;
    if (i>1) then
      begin
        DoLog('plusieurs fichiers .ib dans le split : ERREUR');
        result:=false;
        exit;
      end;

    // -----------
    FBase0 := cb_Drive.Text + '\Ginkoia\data\Ginkoia.ib';
    WriteBase0(FBase0);
    FBase0 := Readbase0;

    if FileExists(FBase0)
      then
        begin
           DoLog(Format('Vous avez déjà un fichier %s : ERREUR',[FBase0]));
           result:=false;
           exit;
        end;

   vGenreplicPLACEBASE := Uppercase(DataMod.GetCheminBaseGENREPLICATION(vIBFile));
   if (UpperCase(vGenreplicPLACEBASE)<>UpperCase(FBase0))
    then
      begin
        DoLog(Fbase0);
        DoLog(vGenreplicPLACEBASE);
        DoLog('Votre Base0 (dans le registre ou/et dans Ginkoia.ib) n''est pas correctement paramétrée');
        // vIBFile : c'est le chemin temporaire la ou on a poser le split
        // FBase0  : c'est le final
        If (DataMod.UpdateREP_PLACEBASE(UpperCase(vIBFile),UpperCase(FBase0)))
          then
            begin
              DoLog('Nouvelle valeur de REP_PLACEBASE =' + UpperCase(FBase0) + ' OK ');
            end
          else
            begin
              DoLog('Erreur à la mise à jour de REP_PLACEBASE');
              result:=false;
              exit;
            end;
      end;

    // Deplacement du fichier IB
    // TFile.Move(vIBFile,FBase0);
    DeplaceFichier(vIBFile,FBase0);
    // TFile.Copy(vIBFile,FBase0);

    Result := ControleDB;
    Lbl_Infos.Caption := 'Base0 : '      + FBase0  + #13+#10+
                         'Dossier : '    + FDB.Nom + #13+#10+
                         'Générateur : ' + IntToStr(FDB.BAS_IDENT)  + #13+#10+
                         'Sender : '     + FDB.BAS_SENDER + #13+#10+
                         'GUID   : '     + FDB.BAS_GUID   + #13+#10+
                         'Plage  : '     + FDB.BAS_PLAGE  + #13+#10+
                         'GeneralID  : ' + FDB.GENERAL_ID + #13+#10+
                         'ExternalID : ' + FDB.ExternalID + #13+#10+
                         'PropertiesFile : ' + ExtractFileName(FDB.PropertiesFile) + #13+#10+
                         'Url : '        + FDB.RegistrationUrl;

  except
    result:=false;
  end;
end;

procedure TForm_Main.DoLog(aValue:string);
begin
     mLog.Lines.Add(FormatDateTime('[yyyy-mm-dd hh:nn:ss.zzz] : ',Now())+aValue);
end;

function TForm_Main.DoEtape1:Boolean;
begin
    // pour les Tests sur un poste comme celui de Gilles il y a plein de SymmetricDS qui sont la


    if (FBase0<>'') and (FileExists(FBase0)) then
      begin
        if (FileExists(FBase0))
          then DoLog('Le fichier '+FBase0+' est présent : ERREUR');
        result:=false;
        exit;
      end;
    if FileExists(F7zdll) and FileExists(FJava7z) and FileExists(FSymDSjar)
       and FIBService and FIBStarted  and (FIBVersion>='WI-V10.0.5.595')
       and (Length(VGSYMDS)=0) and PoseUDF(FIBPATH) and KillProcess('LaunchV7.exe')
//       and DelosRename() and CleanLancherV7()
     then
        begin
          result := true;
        end
    else
        begin
           if Not(FileExists(F7zdll))
             then DoLog('Le fichier '+F7zdll+' est absent : ERREUR');
           {// Mini splt
           if Not(FileExists(FBase0))
             then DoLog('Le fichier '+FBase0+' est absent : ERREUR');
           }

           if Not(FileExists(FJava7z))
             then DoLog('Le fichier '+FJava7z+' est absent : ERREUR');
           if Not(FileExists(FSymDSjar))
             then DoLog('Le fichier '+FSymDSjar+' est absent : ERREUR');
           if Not(FIBService)
             then DoLog('Le Service FIBService est absent : ERREUR');
           if Not(FIBStarted)
             then DoLog('Le Service FIBService est arrêté : ERREUR');
           if Not(FIBVersion>='WI-V10.0.5.595')
             then DoLog('Interbase n''est pas en dernière version : ERREUR');
           if Not((Length(VGSYMDS)=0))
             then DoLog('EASY est déjà installé : Attention');
           if Not(PoseUDF(FIBPATH))
             then DoLog('L''UDF de SymmetricDS est absent : ERREUR');
           if Not(KillProcess('LaunchV7.exe'))
             then DoLog('Le LaunchV7 tourne : ERREUR');

           // Renommage du fichier .xml pour que le DELOS ne puisse plus du tout fonctionner
{           If Not(DelosRename())
            then DoLog('Impossible de renommer le fichier .xml (DELOS) : ERREUR');
           if not(CleanLancherV7())
             then DoLog('Le LauncherEasy n''a pas pu être ajouter en lancement automatique : ERREUR');
}
           Result := false;
        end;
end;

procedure TForm_Main.BActionClick(Sender: TObject);
begin
{    BAction.Enabled:=false;
    BAction.Visible:=false;

    if BAction.Caption='Démarrer' then
        ServiceStart('','EASY');

    if BAction.Caption='Arrêter' then
        ServiceStop('','EASY');

    Actualiser_Etat_Service_EASY;
    BAction.Enabled:=true;

    }
end;

procedure TForm_Main.Joue_MiniSplit();
begin
{ If FileExists(IncludeTrailingPathDelimiter(edtSplitIBFile.Text)+'K.csv')
    then
      begin
        // le faire dans DataMod
        DataMod.Joue_MiniSplit(IncludeTrailingPathDelimiter(edtSplitIBFile.Text)+'K.csv',edt_BASE0.Text);
      end;
  If FileExists(IncludeTrailingPathDelimiter(edtSplitIBFile.Text)+'GENPARAM.csv')
    then
      begin
        // le faire dans DataMod
        DataMod.Joue_MiniSplit(IncludeTrailingPathDelimiter(edtSplitIBFile.Text)+'GENPARAM.csv',edt_BASE0.Text);
      end;
    }
end;

procedure TForm_Main.InstallationBase();
var vVersion:string;
    vGenreplicPLACEBASE:string;
    Retour: LongBool;
begin
   //----------------------------------------------------------------------
   // Mini Split il faut passer les 2 fichiers CSV(.sql)
{
   if (FileExists(edt_BASE0.Text)) then
      begin
        // Si le Noeud, le sender ne correspond pas.... Erreur
        if  (Edit2.Text<>edt_Noeud.Text) or (Edit3.Text<>edt_Sender.Text)
          or (teNode.Text<>edt_NOMPOURNOUS.Text) or (Edit1.Text='0')
          then
             begin
                MessageDlg('Erreur Noeud/Sender Mauvaise Base !',  mtError, [mbOK], 0);
                exit;
             end;
        Joue_MiniSplit();
        Actualise_Ecran();
        exit;

        //----------------------------------------------------------------------
      end;

    vVersion := FGVersion + 'V' + StringReplace(edt_VERSION.Text,'.9999','.1.7z',[]);
   if cbVersion.Checked then
      begin
           if not(FileExists(vVersion)) then
            begin
                MessageDlg('Il vous manque le fichier de Version '+ vVersion,  mtError, [mbOK], 0);
                TraitementEncours := False;
                Actualise_Ecran();
                exit;
            end;
      end;

   vGenreplicPLACEBASE := Uppercase(DataMod.GetCheminBaseGENREPLICATION(edtSplitIBFile.Text));
   if (vGenreplicPLACEBASE<>UpperCase(edt_BASE0.Text))
    then
      begin
        MessageDlg('Votre Base0 (dans le registre ou dans Ginkoia.ib) n''est pas correctement paramétrée :  '+ #10
          + edt_BASE0.Text + #10
          + vGenreplicPLACEBASE ,  mtError, [mbOK], 0);
        TraitementEncours := False;
        Actualise_Ecran();
        exit;
      end;
   if not(FileExists(edt_BASE0.Text)) then
      begin
        ForceDirectories(ExtractFilePath(edt_BASE0.Text));
        pbSplit.Visible:=true;
        pbSplit.Position:=0;
        pbSplit.Max:=100;
        sb_status.Panels[0].Text := 'Copie du fichier base de données...';
        CopyfileEx(PChar(edtSplitIBFile.Text),PChar(edt_BASE0.Text), @CopyCallBack,  pbSplit, nil,0);
        // Installation de la version Ginkoia
        if (cbVersion.Visible) and (cbVersion.Checked)
          then
            begin
                sb_status.Panels[0].Text := 'Installation de la version Ginkoia v' + edt_VERSION.TExt;
                Application.ProcessMessages;
                Un7zVersion(vVersion);
            end;
        //----Nettoyage du répertoire temporaire
        TDirectory.Delete(ExtractFileDir(edtSplitIBFile.Text), True);
        //---------------------------------------
        Actualise_Ecran();
        TraitementEncours := False;
      end
}
end;

procedure TForm_Main.BBASEINSTALLClick(Sender: TObject);
begin
   TraitementEncours     := true;

//   BBASEINSTALL.Enabled   := False;
//   cbVersion.Enabled      := False;
//   BLocalSplit.Enabled    := false;
//   BRemoteSplit.Enabled   := false;
//   BRemoteVersion.Enabled := false;

   InstallationBase();
end;

procedure TForm_Main.BCLEANClick(Sender: TObject);
begin
//    DataMod.Grant_SYMTABLE_TO_GINKOIA(teIBFile.Text);
end;

procedure TForm_Main.BcontrolerClick(Sender: TObject);
begin
{
    BControler.Enabled:=false;
    BInstaller.Enabled:=false;
    try
      FDB.init;
      FDB.ServiceName  := sEASY;
      FDB.DatabaseFile := teIBFile.Text;
      FDB.Nom          := teNOM.Text;
      FDB.SetSymDir;
      FDB.ExternalID      := teNODE.text;
      FDB.RegistrationUrl := teURLMaster.text;

      if Pos(teNom.Text,teURLMaster.Text)=0
        then
            begin
              MessageHint('L''Url du Noeud Maitre doit être composé du nom du client',teURLMaster);
              exit;
            end;

      // etrange ca passe pas ....
      If not ControlURL(FDB.RegistrationUrl)
          then
              begin
                MessageHint('L''Url du Noeud Maitre ne répond pas correctement',teURLMaster);
                // exit;
              end;
      // teURLMaster.Enabled:=false;
      BInstaller.Enabled:=true;
    finally

      BControler.Enabled:=true;
    end;
}
end;

procedure TForm_Main.MessageHint(AMessage:string;AControl:TControl);
var Pt: TPoint;
begin
{     BHint.Title:='Attention';
     BHint.Style:=bhsBalloon;
     BHint.Description := AMessage;
     Pt.X := AControl.Width Div 2;
     Pt.Y := AControl.Height-10;
     BHint.ShowHint(AControl.ClientToScreen(Pt));
     }
end;

function TForm_Main.ControlURL(aUrl:string):boolean;
var idhttp:TIdHttp;
    MS : TMemoryStream;
    resultat:string;
    code:integer;
begin
    result:=false;
    // est-ce qu'il y a des nettoyages à faire ?
    idhttp:=TidHttp.Create(Self);
    MS := TMemoryStream.Create;
    try
      try
       idhttp.Get(aUrl,ms);
       except on E: EIdHTTPProtocolException do begin
            code := idhttp.ResponseCode;
            // Is 403 c'est bon...
            if code=403 then result:=true;
          end;
         on E: Exception do begin
            result:=false;
          end;
      end;
    finally
      MS.free;
      idHttp.Free;
    end;
end;

procedure TForm_Main.Installation_Easy;
begin
end;

procedure TForm_Main.BFermerClick(Sender: TObject);
begin
    Close;
end;

function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
 begin
   if total
    then
        begin
            Form_Main.pbGeneral.Max := 1000;
            Form_Main.SizeItem    := value;
        end
    else
        begin
          if (Form_Main.SizeItem)<>0
            then Form_Main.pbGeneral.Position := Round(value*1000/Form_Main.SizeItem)
            else Form_Main.pbGeneral.Position := 0;
        end;
   Application.ProcessMessages;
   Result := S_OK;
 end;


procedure TForm_Main.Un7zVersion(z7Version:string);
var outDir:string;
begin
    with CreateInArchive(CLSID_CFormat7z) do
    begin
      pbGeneral.Visible:=true;
      OpenFile(z7Version);
      SetProgressCallback(pbGeneral, ProgressCallback);
      outDir := IncludeTrailingPathDelimiter(FGinkoiaPath);
      ExtractTo(outDir);
      pbGeneral.Visible:=false;
    end;
end;

procedure TForm_Main.Un7zSplitFile(zipFullFname:string);
var outDir:string;
begin
    with CreateInArchive(CLSID_CFormat7z) do
    begin
      SetPassword(CST_7Z_PASSWORD);
      OpenFile(zipFullFname);
      pbGeneral.Visible:=true;
      SetProgressCallback(pbGeneral, ProgressCallback);
      // on decompresse
      //------------------------------------------------------------------------
      outDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'split';
      //------------------------------------------------------------------------
      // outDir := IncludeTrailingPathDelimiter(GetTempDirectory) + 'InstallationEASY_'+FormatDateTime('yyyymmdd_hhnnss',Now());
      ExtractTo(outDir);
      FSplitDIR := outDir;
      pbGeneral.Visible:=false;
    end;
end;

procedure TForm_Main.LectureFichierInf();
var searchResult : TSearchRec;
    vIniFile : TIniFile;
begin
{
  if FindFirst(IncludeTrailingPathDelimiter(FSplitDir) + '*.inf', faAnyFile, searchResult) = 0 then
    begin
      repeat
        // lecture du fichier
        vIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(FSplitDir)+searchResult.Name);
        try
          edt_NOMPOURNOUS.Text := vIniFile.ReadString('SPLIT','NOMPOURNOUS','');
          edt_Sender.Text := vIniFile.ReadString('SPLIT','SENDER','');
          edt_Noeud.Text := vIniFile.ReadString('SPLIT','NOEUD','');
          edt_Version.Text := vIniFile.ReadString('SPLIT','VERSION','');
          // mettre le type de split ? Complet on Mini ?
          // edt_xxxxx.Text := vIniFile.ReadString('SPLIT','TYPE','');
        finally
          vIniFile.DisposeOf;
        end;

      until FindNext(searchResult) <> 0;
      FindClose(searchResult);
    end;

  // S'il n'y a pas de fichier .ib c'est un "minisplit"
  if FindFirst(IncludeTrailingPathDelimiter(FSplitDir) + '*.ib', faAnyFile, searchResult) = 0 then
    begin
      repeat
         edtSplitIBFile.Text := IncludeTrailingPathDelimiter(FSplitDir)+searchResult.Name;
      until FindNext(searchResult) <> 0;
      FindClose(searchResult);
    end
  else
    begin
      // c'est MiniSplit
      edtSplitIBFile.Text := IncludeTrailingPathDelimiter(FSplitDir);

      // il faut que la base existe déjà donc...
      if not(FileExists(edt_BASE0.Text))
        then
          begin
            MessageDlg('La base n''existe pas or le fichier que vous avez choisi est un Minisplit'+#10
                      + 'Un fichier Minisplit ne contient pas de base ! ' +#10
                      + 'Il vous faut un fichier de split complet !' ,  mtError, [mbOK], 0);
            //------------------------------------------------------------------
            edtSplitIBFile.Text  := '';
            edt_NOMPOURNOUS.Text := '';
            edt_Sender.Text      := '';
            edt_Noeud.Text       := '';
            edt_Version.Text     := '';

            BBASEINSTALL.Enabled := False;
            cbVersion.Visible    := False;
            BLocalSplit.Enabled   := true;
            BRemoteSplit.Enabled := true;
          end;
    end;
  Actualise_Ecran();
  Refresh;
  }
end;

procedure TForm_Main.BLocalSplitClick(Sender: TObject);
var vFile  : TOpenDialog;
    outDir : string;
    vDir   : string;
begin
{
   TraitementEncours := true;
   vDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'split\';
   vFile := TOpenDialog.Create(nil);
   vFile.Filter := 'Fichiers Split (*.split)|*.SPLIT|Tous (*.*)|*.*';
   vFile.InitialDir := vDir;
   try
    If vFile.Execute()
    then
      begin
        if FileExists(vFile.FileName)
          then
            begin
              // si change de fichier de split il faut virer l'ancienne décompression
              // Suppression du répertoire
              if (edtSplitIBFile.Text<>'')
                 then
                   begin
                     If (DirectoryExists(ExtractFileDir(edtSplitIBFile.Text),false))
                       then TDirectory.Delete(ExtractFileDir(edtSplitIBFile.Text), True);
                   end;

              BBASEINSTALL.Enabled := false;
              cbVersion.Visible    := False;
              BLocalSplit.Enabled   := false;
              BRemoteSplit.Enabled := false;

              edtSplitIBFile.Text  := '';
              edt_NOMPOURNOUS.Text := '';
              edt_Sender.Text      := '';
              edt_Noeud.Text       := '';
              edt_VERSION.Text     := '';

              sb_status.Panels[0].Text := 'Décompression du split';
              Un7zSplitFile(vFile.FileName);
              // Lecture du fichier .inf
              LectureFichierInf();
              // Copier le fichier .ib en Base0
            end;
      end;
   finally
     vFile.DisposeOf;
     TraitementEncours := False;
   end;
}
end;


procedure TForm_Main.BCONSOLEWEBClick(Sender: TObject);
begin
    ShellExecute(0, 'OPEN', PChar(FConsoleWebUrl), '', '', SW_SHOWNORMAL);
end;

procedure TForm_Main.BEtape6Click(Sender: TObject);
begin
  DoEtape6();
end;

procedure TForm_Main.PostControlesCallBack(Sender: TObject);
var vTmpThread:TPostControlesThread;
begin
  pbGeneral.Visible := false;
  sb_status.Panels[0].Text := 'Post-Contrôles Terminés';
  if Assigned(FPostControlesThread) then
  begin
    vTmpThread := FPostControlesThread;
    FPostControlesThread := nil;
    if vTmpThread.ReturnValue<>0 then
      begin
        lbl_Result6.Font.Color:=clRed;
        lbl_Result6.Caption:=CST_ERREUR;
        DoLog(vTmpThread.GetErrorLibelle(vTmpThread.ReturnValue));
      end
    else
      begin
        lbl_Result6.Font.Color:=clGreen;
        lbl_Result6.Caption:=CST_OK
      end;

    lbl_Result6.Visible := true;
    BEtape6.Enabled     := true;

    // DeleteShortCutLauncherV7(); // Non Bloquant
    FGinkoiaPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(FBase0)));

    // Lancement du LauncherEASY
    if FileExists(FGinkoiaPath + CST_LAUNCHEREASY)
      then
        begin
            DoLog('Lancement du Launcher EASY...');
            ShellExecute(0, 'open', PWideChar(FGinkoiaPath + CST_LAUNCHEREASY), nil, nil, SW_SHOW);

            // Si tout est OK...
            if FAuto and FStopFinish and (lbl_Result6.Caption=CST_OK) then
              begin
                FErrorLevel := 0;
                Close;
              end;
        end
      else
        begin
            DoLog('Lancement du Launcher EASY : ERREUR');
        end;
    // vTmpThread.GetErrorLib(vTmpThread.ReturnValue);
  end;
end;


procedure TForm_Main.DoEtape6();
begin

    BEtape6.Enabled := False;
    pbGeneral.Visible := true;
    pbGeneral.Max := 100;
    pbGeneral.Position := 0;
    pbGeneral.Refresh;
    sb_status.Panels[0].Text := 'Post-Contrôles...';
    Application.ProcessMessages;
    FPostControlesThread   := nil;
    FPostControlesThread   :=  TPostControlesThread.Create(true,
        StatusCallBack,ProgressInstallCallBack,
//        LogCallBack,
        PostControlesCallBack);
    FPostControlesThread.DB     := FDB;
    FPostControlesThread.EASY   := FEASY;
    FPostControlesThread.Start;
end;

end.

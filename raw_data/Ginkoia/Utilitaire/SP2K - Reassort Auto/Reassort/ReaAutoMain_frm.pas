unit ReaAutoMain_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ReaAutoMain_DM, StrUtils, uDefs, StdCtrls, ComCtrls, ExtCtrls,
  Buttons, IniFiles, uReaAutoStock, uReaAutoVente, DB, ADODB, DBCtrls, Grids,
  DBGrids, IniCfg_Frm, AlgolDialogForms,uLog;

type
  Tfrm_ReaAutoMain = class(TAlgolDialogForm)
    Pan_Top: TPanel;
    Pan_TopLeft: TPanel;
    Rgr_Choix: TRadioGroup;
    Pan_TopClient: TPanel;
    Gbx_Progress: TGroupBox;
    pb_Mag: TProgressBar;
    pb_Marque: TProgressBar;
    pb_Ftp: TProgressBar;
    Lab_Magasin: TLabel;
    Lab_Marque: TLabel;
    Lab_FTP: TLabel;
    Pan_Bottom: TPanel;
    Gbx_Bottom: TGroupBox;
    Nbt_Executer: TBitBtn;
    Tim_AutoExec: TTimer;
    Nbt_EnvFTP: TBitBtn;
    Pan_CFG: TPanel;
    DBLookupComboBox1: TDBLookupComboBox;
    Lab_SelectMag: TLabel;
    Chk_SaveInDb: TCheckBox;
    Chk_SendToFTP: TCheckBox;
    Nbt_ExecuteForMag: TBitBtn;
    Ds_MagList: TDataSource;
    DBGrid1: TDBGrid;
    Pan_Client: TPanel;
    mmLogs: TMemo;
    Gbx_LstPath: TGroupBox;
    mmPathList: TMemo;
    Nbt_Parametrage: TBitBtn;
    Lab_MagNom: TLabel;
    Lab_MrkNom: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Tim_AutoExecTimer(Sender: TObject);
    procedure Nbt_ExecuterClick(Sender: TObject);
    procedure Nbt_EnvFTPClick(Sender: TObject);
    procedure Nbt_ExecuteForMagClick(Sender: TObject);
    procedure Nbt_ParametrageClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
//    procedure LoadIni;
  end;

var
  frm_ReaAutoMain: Tfrm_ReaAutoMain;

implementation

{$R *.dfm}

procedure Tfrm_ReaAutoMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //  Sauvegarde de la liste des chmemin à traiter
  mmPathList.Lines.SaveToFile(GDIRFILES + CDIRPATH);

  Log.Log('Main', 'Status', 'Fin du programme', logInfo, True);
  Log.Close;
  if Assigned(DM_ReaAuto) then
    DM_ReaAuto.Free;
end;

procedure Tfrm_ReaAutoMain.FormCreate(Sender: TObject);
var
  bAutoExec : Boolean;
begin
  Log.App  := 'ReaAuto';
  Log.Inst := '1';
  Log.SendOnClose := True;
  Log.Open;
  Log.saveIni();

  Caption := 'Réassort Auto v' + AppVersion; // CVERSION;

//  if FindCmdLineSwitch( 'debug',true ) then
//    TLogEngine.Strings := mmLogs.Lines;

  //TLogEngine.Info( 'Version', AppVersion );
  Log.Log('Main', 'Status', 'Démarrage du programme', logNotice, True) ;
  Log.Log('Main', 'Version', AppVersion, logInfo, True, -1, ltServer) ;

  // Initialisations
  IniCfg.LoadIni;

  DM_ReaAuto := TDM_ReaAuto.Create(Self);
  DM_ReaAuto.Memo := mmLogs;
  DM_ReaAuto.ProgressMag := pb_Mag;
  DM_ReaAuto.ProgressMrk := pb_Marque;
  DM_ReaAuto.ProgressFTP := pb_Ftp;
  DM_ReaAuto.LabMagNom := Lab_MagNom;
  DM_ReaAuto.LabMrkNom := Lab_MrkNom;

  GAPPPATH   := ExtractFilePath(Application.ExeName);
  GDIRFILES  := GAPPPATH + 'Fichiers\';
  GDIRTOSEND := GAPPPATH + 'ToSend\';
  GDIRARCHIV := GAPPPATH + 'Archiv\';
  GDIRLOGS   := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\',Now);
  GFILELOG   := GDIRLOGS + FormatDateTime('YYYYMMDD-hhmmss',Now) + '.txt';

  // Chargement de la liste des fichiers à traiter
  if FileExists(GDIRFILES + CDIRPATH) then
    mmPathList.Lines.LoadFromFile(GDIRFILES + CDIRPATH);

  // Création des répertoires
  DoDir(GDIRTOSEND);
  DoDir(GDIRARCHIV);
  DoDir(GDIRLOGS);

  // Gestion des paramètres
  bAutoExec := False;
  if ParamCount > 0 then
    if Length(ParamStr(1)) = 1 then
    begin
      bAutoExec := True;
      case AnsiIndexStr(ParamStr(1),['S','V']) of
        0: Rgr_Choix.ItemIndex := 0;// S
        1: Rgr_Choix.ItemIndex := 1;// V
        else
          bAutoExec := False;
      end;
    end;

  try
    // Chargement de la configuration
//    LoadIni;

//    if IniStruct.Client = 0 then
    if IniCfg.ClientType = 0 then
    begin
       DM_ReaAuto.AddToMemo('Problème de paramétrage du client. Merci de vérifier le fichier ini.');
    end
    else
    begin
      if DM_ReaAuto.Open2kDatabase then
        DM_ReaAuto.AddToMemo('Connexion à la base de données SQL serveur Ok');

      Tim_AutoExec.Enabled := bAutoExec;
    end;
  Except on E:Exception do
    DM_ReaAuto.AddToMemo(E.Message);
  end;
end;

//procedure Tfrm_ReaAutoMain.LoadIni;
//begin
//  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
//  try
//    //Mode
//    IniStruct.IsDevMode := (ReadInteger('DEBUG','MODE',0) = 1);
//
//    if IniStruct.IsDevMode then
//    begin
//      //Dev
//      IniStruct.LoginDev    := ReadString('DEBUG','LOGIN','');
//      IniStruct.PasswordDev := CPASSWORD;
//      IniStruct.ServerDev   := ReadString('DEBUG','SERVER','');
//      IniStruct.CatalogDev  := ReadString('DEBUG','CATALOG','');
//    end
//    else
//    begin
//      //Prd
//      IniStruct.LoginPrd    := ReadString('DATABASE','LOGIN','');
//      IniStruct.PasswordPrd := CPASSWORD;
//      IniStruct.ServerPrd   := ReadString('DATABASE','SERVER','');
//      IniStruct.CatalogPrd  := ReadString('DATABASE','CATALOG','');
//    end;
//
//    //Client
//    IniStruct.Client := ReadInteger('CLIENT','NUM',0);
//
//    //FTP
//    IniStruct.FTP.Host      := ReadString('FTP','HOST','');
//    IniStruct.FTP.Port      := ReadInteger('FTP','PORT',21);
//    IniStruct.FTP.UserName  := ReadString('FTP','USER','');
//    IniStruct.FTP.PassWord  := ReadString('FTP','PWD','');
//  finally
//    Free;
//  end;
//end;

procedure Tfrm_ReaAutoMain.Nbt_EnvFTPClick(Sender: TObject);
begin
  try
    // Init
    DM_ReaAuto.MemD_FTPToSend.Close;
    DM_ReaAuto.MemD_FTPToSend.Open;
    // Transfert les fichiers vers le FTP
//    TLogEngine.Notice( 'FTP' );
    Log.Log('FTP', 'Status', 'Envoi Manuel en cours', logNotice, True) ;

    try
      DM_ReaAuto.SendFileToFTP;
      Log.Log('FTP', 'Status', 'Envoi Manuel terminé', logInfo, False) ;

//      TLogEngine.Info( 'FTP' );
    except
      on E: Exception do
        Log.Log('FTP', 'Status', E.Message, logError, False) ;

//        TLogEngine.Info( 'FTP', E.Message );
    end;
  Except on E:Exception do
    DM_ReaAuto.AddToMemo(E.Message);
  end;
end;

procedure Tfrm_ReaAutoMain.Nbt_ExecuteForMagClick(Sender: TObject);
begin
  case Rgr_Choix.ItemIndex of
    0: begin
      if MessageDlg('Etes vous sûr de vouloir faire le traitement de Stock sur ce magasin : ' + Ds_MagList.DataSet.FieldByName('MAG_NOM').AsString, mtConfirmation, [mbYes,mbNo],0) = mrYes then
//        case IniStruct.Client of
        case IniCfg.ClientType of
          1 : DoTraitementSTK_S2K(True,Ds_MagList.DataSet.FieldByName('REM_MAGID').AsInteger,Chk_SaveInDb.Checked,Chk_SendToFTP.Checked,mmPathList.Lines);
          2 : DoTraitementSTK_ISF(True,Ds_MagList.DataSet.FieldByName('REM_MAGID').AsInteger,Chk_SaveInDb.Checked,Chk_SendToFTP.Checked,mmPathList.Lines);
        end;
    end; // 0
    1: begin
      if MessageDlg('Etes vous sûr de vouloir faire le traitement de vente sur ce magasin : ' + Ds_MagList.DataSet.FieldByName('MAG_NOM').AsString, mtConfirmation, [mbYes,mbNo],0) = mrYes then
//        case IniStruct.Client of
        case IniCfg.ClientType of
          1: DoTraitementVTE_S2K(True,Ds_MagList.DataSet.FieldByName('REM_MAGID').AsInteger,Chk_SaveInDb.Checked,Chk_SendToFTP.Checked,mmPathList.Lines);
          2: DoTraitementVTE_ISF(True,Ds_MagList.DataSet.FieldByName('REM_MAGID').AsInteger,Chk_SaveInDb.Checked,Chk_SendToFTP.Checked,mmPathList.Lines);
        end;
    end; // 1
  end;
end;

procedure Tfrm_ReaAutoMain.Nbt_ExecuterClick(Sender: TObject);
var
  sModule : String;
  sDossiers : String;
begin
  if Rgr_Choix.ItemIndex < 0 then begin
    ShowMessage( 'Veuillez sélectionner un type d''export' );
    Exit;
  end;
  try
    sModule :=  IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' );
    sDossiers := IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' );

//    TLogEngine.Notice(
//      IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' ),
//      IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' ),
//      SysUtils.EmptyStr, 'Traitement'
//    );

    Log.Log('Main', 'Status', Format('Traitement : %s, %s', [sModule,sDossiers]) , logNotice, True) ;
    case Rgr_Choix.ItemIndex of
      0: begin
  //        case IniStruct.Client of
        case IniCfg.ClientType of
          1 : DoTraitementSTK_S2K(False,0,True,True,mmPathList.Lines);
          2 : DoTraitementSTK_ISF(False,0,True,True,mmPathList.Lines);
        end;
      end;
      1: begin
  //        case IniStruct.Client of
        case IniCfg.ClientType of
          1 : DoTraitementVTE_S2K(False,0,True,True,mmPathList.Lines);
          2 : DoTraitementVTE_ISF(False,0,True,True,mmPathList.Lines);
        end;
      end;
    end;
    // Transfert les fichiers vers le FTP


    Log.Log('', sModule, sDossiers, '' {ref}, '' {mag}, 'FTP', 'Envoi en cours', logNotice, True, -1, ltServer);


//    TLogEngine.Notice(
//      IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' ),
//      IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' ),
//      SysUtils.EmptyStr, 'FTP'
//    );
    try
      DM_ReaAuto.SendFileToFTP;

      Log.Log('', sModule, sDossiers, '' {ref}, '' {mag}, 'FTP', 'Envoi terminé', logInfo, False, -1, ltServer);

//      TLogEngine.Info(
//        IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' ),
//        IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' ),
//        SysUtils.EmptyStr, 'FTP'
//      );
    except
      on E: Exception do begin
        Log.Log('', sModule, sDossiers, '' {ref}, '' {mag}, 'FTP', E.Message, logError, False, -1, ltServer);

//        TLogEngine.Info(
//          IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' ),
//          IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' ),
//          SysUtils.EmptyStr, 'FTP', E.Message
//        );
        raise Exception.Create('Transfert des fichiers vers FTP échoué');
      end;
    end;

    Log.Log('Main', 'Status', 'Traitement terminé' , logInfo, False) ;

//    TLogEngine.Info(
//      IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' ),
//      IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' ),
//      SysUtils.EmptyStr, 'Traitement'
//    );

  except
    on E: Exception do
      Log.Log('Main', 'Status', E.Message , logError, False) ;
//      TLogEngine.Error(
//        IfThen( Rgr_Choix.ItemIndex = 0, 'STOCK', 'VENTE' ),
//        IfThen( IniCfg.ClientType = 1, 'SPORT2000', 'INTERSPORT' ),
//        SysUtils.EmptyStr, 'Traitement', E.Message
//      );
  end;
end;

procedure Tfrm_ReaAutoMain.Nbt_ParametrageClick(Sender: TObject);
var
  bReloadDatabase : Boolean;
begin
  IniCfg.AdoConnection := DM_ReaAuto.ADOConnection;
  bReloadDatabase := False;

  bReloadDatabase := IniCfg.ShowCfgInterface = mrOk;
  bReloadDatabase := bReloadDatabase or (DM_ReaAuto.ADOConnection.ConnectionString <> IniCfg.MsSqlConnectionString);

  if bReloadDatabase then
    DM_ReaAuto.Open2kDatabase;

end;

procedure Tfrm_ReaAutoMain.Tim_AutoExecTimer(Sender: TObject);
begin
  Tim_AutoExec.Enabled := False;
  Nbt_Executer.Click;
  Application.Terminate;
end;

end.

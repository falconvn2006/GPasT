unit UMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, StdCtrls, LMDCustomButton,
  LMDButton, Mask, wwdbedit, wwDBEditRv, LMDBaseControl, LMDBaseGraphicControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, RzLabel, ExtCtrls,
  RzPanel, RzPanelRv, IB_Components, ComCtrls, RzEdit, RzDBEdit, Wwdbspin,
  wwDBSpinEditRv, wwclearbuttongroup, wwradiogroup, wwcheckbox,
  Inifiles, DB, IBODataset, wwDialog, wwidlg, Character, StrUtils,
  UMotDePasse_Frm, IdMessageClient, IdSMTPBase, IdSMTP,
  IdMessage, IdAttachmentFile, FolderDialog, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, ShlObj,
  cxShellCommon, cxShellBrowserDialog, cxDropDownEdit, cxShellComboBox,
  cxMRUEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, DBClient, Grids, DBGrids,
  DateUtils, uToolsXE, UMapping, Types,
  RegExpr, IdSSL, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack;

type
  // Type pour les adresses dans les exports
  TAdrLignes = array[1..3] of String;

  TFrm_Main = class(TForm)
    IdFTP_Main: TIdFTP;
    IBC_Ginkoia: TIB_Connection;
    OpDlg_DBNom: TOpenDialog;
    Pgc_Main: TPageControl;
    Tab_Traitement: TTabSheet;
    Tab_Parametres: TTabSheet;
    Pan_DB: TRzPanelRv;
    Lab_DBNom: TRzLabel;
    Lab_BDNom: TRzLabel;
    Nbt_DBNom: TLMDSpeedButton;
    Chp_DBNom: TRzEdit;
    Pan_Transfert: TRzPanelRv;
    Lab_Transfert: TRzLabel;
    Lab_FTPListenTimeout: TRzLabel;
    Lab_FTPTransferTimeout: TRzLabel;
    Lab_FTPReadTimeout: TRzLabel;
    Chp_FTPListenTimeout: TRzEdit;
    Chp_FTPTransferTimeout: TRzEdit;
    Chp_FTPReadTimeout: TRzEdit;
    Pan_Journal: TRzPanelRv;
    Lab_Logs: TRzLabel;
    Nbt_Traitement: TLMDButton;
    Pan_Log: TRzPanelRv;
    Lab_Log: TRzLabel;
    Lab_FTPUserName: TRzLabel;
    Chp_FTPUsername: TRzEdit;
    Chp_FTPPassword: TRzEdit;
    Lab_FTPHost: TRzLabel;
    Chp_FTPHost: TRzEdit;
    Pan_Serveur: TRzPanelRv;
    Lab_Serveur: TRzLabel;
    Lab_DistantEnvoyer: TRzLabel;
    Lab_ServeurRecevoir: TRzLabel;
    Edt_ServeurEnvoyer: TEdit;
    Edt_ServeurRecevoir: TEdit;
    Pan_Local: TRzPanelRv;
    Lab_Local: TRzLabel;
    Lab_LocalEnvoyer: TRzLabel;
    Lab_LocalRecevoir: TRzLabel;
    Edt_LocalRecevoir: TEdit;
    Lab_LocalArchiver: TRzLabel;
    Edt_LocalArchiver: TEdit;
    Lab_ServeurArchiver: TRzLabel;
    Edt_ServeurArchiver: TEdit;
    Que_Maitre: TIBOQuery;
    Que_Details: TIBOQuery;
    Msg_Mail: TIdMessage;
    Lab_MelSMTP: TRzLabel;
    Lab_MailUsername: TRzLabel;
    Edt_MailUsername: TEdit;
    Edt_MailSMTP: TEdit;
    SMTP_Mail: TIdSMTP;
    Lab_MailFrom: TRzLabel;
    Edt_MailPassword: TEdit;
    Lab_MailTo: TRzLabel;
    Edt_MailTo: TEdit;
    Edt_MailPort: TEdit;
    Edt_MailFrom: TEdit;
    Rgr_TraitementType: TRadioGroup;
    Chk_Export: TCheckBox;
    Chk_Send: TCheckBox;
    Chk_Receive: TCheckBox;
    Chk_Import: TCheckBox;
    Nbt_SMTPTest: TLMDButton;
    Nbt_FTPTest: TLMDButton;
    Nbt_BDTest: TLMDButton;
    Chp_FTPPort: TEdit;
    Nbt_LocalTest: TLMDButton;
    Nbt_DistantsTest: TLMDButton;
    Nbt_MailSend: TLMDButton;
    Cds_Main: TClientDataSet;
    IBT_Ginkoia: TIB_Transaction;
    Ds_GenParam: TDataSource;
    Nbt_Quitter: TLMDButton;
    Que_GenParam: TIBOQuery;
    SP_Ginkoia: TIBOStoredProc;
    Pgc_Log: TPageControl;
    Tab_Journal: TTabSheet;
    Requêtes: TTabSheet;
    Tab_Parametre: TTabSheet;
    Mem_Requetes: TMemo;
    Dbg_Genparam: TDBGrid;
    Mem_Log: TMemo;
    Lab_LocalConserver: TRzLabel;
    Upd_LocalConserver: TUpDown;
    Edt_LocalConserver: TEdit;
    Edt_LocalEnvoyer: TEdit;
    Chk_MailSSL: TCheckBox;
    SSL_Mail: TIdSSLIOHandlerSocketOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_DBNomClick(Sender: TObject);
    procedure Nbt_TraitementClick(Sender: TObject);
    procedure Nbt_BDTestClick(Sender: TObject);
    procedure Nbt_FTPTestClick(Sender: TObject);
    procedure Nbt_SMTPTestClick(Sender: TObject);
    procedure Chp_DBNomChange(Sender: TObject);
    procedure Nbt_LocalTestClick(Sender: TObject);
    procedure Nbt_DistantsTestClick(Sender: TObject);
    procedure Nbt_MailSendClick(Sender: TObject);
    procedure Rgr_TraitementTypeClick(Sender: TObject);
    procedure Que_BeforeOpen(DataSet: TDataSet);
    procedure Nbt_QuitterClick(Sender: TObject);
    procedure Que_BeforePrepare(Sender: TObject);
    procedure IBT_GinkoiaBeforeStart(Sender: TIB_Transaction);
    procedure Que_MaitreAfterOpen(DataSet: TDataSet);
  private
    FModeAuto: Boolean; // indicateur mode automatique (True si paramètre "AUTO" à l'exécution)
    FModeTestAuto: Boolean;
    FLogCurrent: string;
    FLogMessage: string;
    FLogInternal: TSTrings;
    FLogChemin: String;
    FMinVersion, FMaxVersion: Integer;
    FEnvoyerCourriel: Boolean;
    function LocalSendPathName: TFileName;
    function LocalReceivePathName: TFileName;
    function DistantSendPathName: TFileName;
    function DistantReceivePathName: TFileName;
    function GetArchivesPathName( ALocal: Boolean; const APathName: string ): TFileName;
    function GetCleanString( const AText: string ): string;
    function GetFileName( const APathName, AFileTitle: string ): TFileName;
    procedure GetPathFileNames( AList: TStrings; const APathName: string; AMaxDate: TDateTime = 0 );
    procedure ClearLog;
    procedure WriteLog( const AText: string ); overload;
    procedure WriteLog( const AText: string; const AResult: string ); overload;
    procedure ConnectDB;
    procedure DisconnectDB;
    function GetDBParamValue( AParamCode: Integer; const AFieldName: string; AMagId: Integer = 0 ): string;
    procedure SetDBParamValue( AParamCode: Integer; const AFieldName: string; AValue: variant; AMagId: Integer = 0 );
    procedure GetDBParamValues( AValueList: TList; AParamCode: Integer; const AFieldName: string );
    function GetDBVersion( AFinPlage: Boolean ): Integer;
    function GetDBLastVersion: Integer;
    function GetDBEstEntrepot( AMagId: Integer ): Boolean;
    procedure ConnectFTP;
    procedure DisconnectFTP;
    procedure GetFTPFileNames( AList: TStrings; const APathName: string );
    procedure SendFTPFile( const AOriginFileName, ADestinationPathName: TFileName );
    procedure ReceiveFTPFile( const AOriginFileName, ADestinationPathName: TFileName );
    procedure MoveFTPFile( const AOriginFileName, ADestinationPathName: TFileName );
    procedure DeleteFTPFile( const AFileName: TFileName );
    procedure ConnectSMTP;
    procedure DisconnectSMTP;
    procedure SendSMTPMail;
    // Retourne les différentes parties d'une adresse dans un tableau
    function LignesAdresse(aAdrLignes: String): TAdrLignes;
  public
    procedure ExporterMagasins;
    procedure ExporterArticles( ALastVersion, ACurrentVersion: Integer );
    procedure ExporterStockIO( AListMagId: TList; ADateInit: TDateTime; ALastVersion, ACurrentVersion: Integer; AStockIn: Boolean );
    procedure ExporterTransferts( ALastVersion, ACurrentVersion: Integer );
    procedure ExporterMouvements( AViderBI: Integer );
    procedure ExporterStock( AListMagId: TList );
    procedure EnvoyerFichiers;
    procedure RecevoirFichiers;
    procedure ImporterTransferts;
    procedure ArchiverFichiers( const APathName: TFileName );
    procedure SupprimerFichiers;
  end;

const
  txtParamAuto                        = 'AUTO';
  txtParamTestAuto                    = 'TESTAUTO';

  txtIniFileName                      = 'SyncStockIt.ini';

  txtIniSectionDB                     = 'DB';
  txtIniSectionFichiers               = 'FICHIERS';
  txtIniSectionTransfert              = 'TRANSFERT';
  txtIniSectionMel                    = 'MEL';
  txtIniSectionTraitement             = 'TRAITEMENT';

  txtIniKeyNom                        = 'Nom';
  txtIniKeyDelFiles                   = 'DELFILES';
  txtIniKeyHost                       = 'Host';
  txtIniKeyPort                       = 'Port';
  txtIniKeyUsername                   = 'Username';
  txtIniKeyPassword                   = 'Password';
  txtIniKeyListen                     = 'Listen';
  txtIniKeyTransfert                  = 'Transfert';
  txtIniKeyLecture                    = 'Lecture';
  txtIniKeyLocalEnvoyer               = 'LocalEnvoyer';
  txtIniKeyLocalRecevoir              = 'LocalRecevoir';
  txtIniKeyLocalArchiver              = 'LocalArchiver';
  txtIniKeyLocalConserver             = 'LocalConserver';
  txtIniKeyServeurEnvoyer             = 'ServeurEnvoyer';
  txtIniKeyServeurRecevoir            = 'ServeurRecevoir';
  txtIniKeyServeurArchiver            = 'ServeurArchiver';
  txtIniKeyFrom                       = 'From';
  txtIniKeyTo                         = 'To';
  txtIniKeySSL                        = 'SSL';
  txtIniKeyTimeStamp                  = 'Dernière exécution';

  txtDBUsername                       = 'SYSDBA';
  txtDBPassword                       = 'masterkey';

  intTraitementInit                   = 0;
  intTraitementMAJ                    = 1;

  intParamInitialisation              = 5;
  intParamLastVersion                 = 1;
  intParamEnteteFR                    = 2;
  intParamEnteteCL                    = 3;
  intParamEnteteST                    = 4;
  intParamMagasins                    = 6;

  txtLogFichier                       = '%s\LOG_SyncStockIt-%s.txt';
  txtLogTestConnexionBD               = 'Test connexion base de données %s... ';
  txtLogTestConnexionFTP              = 'Test connexion serveur FTP %s... ';
  txtLogTestConnexionSMTP             = 'Test connexion serveur SMTP %s... ';
  txtLogTestEnvoiJournal              = 'Test envoi journal par mél à %s... ';
  txtLogTestLocaux                    = 'Test écriture fichiers dans dossiers locaux... ';
  txtLogTestDistants                  = 'Test écriture fichiers dans dossiers serveur FTP... ';
  txtLogTacheExport                   = 'Exportation fichier %s... ';
  txtLogTacheEnvois                   = 'Envoi tous fichiers depuis %s... ';
  txtLogTacheReceptions               = 'Réception tous fichiers depuis %s... ';
  txtLogTacheImport                   = 'Importation fichier %s... ';
  txtLogTacheArchive                  = 'Déplacement vers archive fichier %s...';
  txtLogTacheSupprimerFichiers        = 'Suppression des fichiers locaux datant de plus de %d jour(s)... ';
  txtLogTacheOK                       = 'OK';
  txtLogTacheFichierVide              = 'Le fichier %s était vide, il ne sera pas envoyé...';
  txtLogTacheFichierExporte           = '%d enregistrement a été exporté dans le fichier %s...';
  txtLogTacheFichierExportes          = '%d enregistrements ont été exportés dans le fichier %s...';
  txtLogTraitementDebut               = 'TRAITEMENT DE SYNCHRONISATION DES ECHANGES AVEC STOCKIT - ';
  txtLogTraitementDebutInit           = 'INITIALISATION';
  txtLogTraitementDebutMAJ            = 'MISE A JOUR REGULIERE';
  txtLogTraitementDebutTest           = 'TEST';
  txtLogTraitementReadLastVersion     = 'Initialisation - lecture du paramètre "LastVersion" : %d';
  txtLogTraitementReadCurrentVersion  = 'Initialisation - lecture du paramètre "CurrentVersion" : %d';
  txtLogTraitementReadDateInit        = 'Initialisation - lecture du paramètre "DateInit" : %s';
  txtLogTraitementWriteDateInit       = 'Finalisation - Ecriture paramètre "DateInit" : %s';
  txtLogTraitementWriteLastVersion    = 'Finalisation - Ecriture paramètre "LastVersion" : %d';
  txtLogTraitementTermine             = 'TRAITEMENT TERMINE ';
  txtLogTraitementTermineOK           = txtLogTraitementTermine + 'OK.';
  txtLogTraitementTermineErreur       = txtLogTraitementTermine + 'EN ERREUR; TOUTES MISE A JOUR BASE ANNULEES.';
  txtLogTraitementErreurBackup        = 'IMPOSSIBLE D''EXECUTER LE TRAITEMENT : BACKUP EN COURS';
  txtLogTraimementErreurTIM           = 'Avertissement : LE TRANSFERT INTER-MAGASINS ENTRE %d ET %d N''A PAS PU ÊTRE INTÉGRÉ. - Ligne %d.';

  txtLogErreur                        = 'Erreur : %s';

  txtCSVSeparator                     = '|';
  txtCSVProhibited                    = '"'';' + txtCSVSeparator;

  txtFichierMagasins                  = 'MAG';
  txtFichierArticles                  = 'INV';
  txtFichierStockIn                   = 'STOCKIN';
  txtFichierStockOut                  = 'STOCKOUT';
  txtFichierTIM                       = 'TIM'; // NB : même nom de fichier pour l'export et pour l'import
  txtFichierMouvements                = 'STOCKMAG';
  txtFichierStock                     = 'STOCK';
  txtFichierTest                      = 'TEST';

  txtRegExpr                          = '(.[^\n]+\n)?(.[^\n]+\n)?(.+)?';

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

// renvoyer une chaine nettoyée des caractères interdits
function TFrm_Main.GetCleanString( const AText: string ): string;
var
  i,j: Integer;
begin
  SetLength( Result, Length( AText ));
  j := 0;
  for i := 1 to Length( AText ) do begin
    if not TCharacter.IsControl( AText[i] )
      and not TCharacter.IsSeparator( AText[i] )
      and not ( Pos( AText[i], txtCSVProhibited ) > 0 ) then
    begin
      Inc( j );
      Result[j] := AText[i];
    end;
  end;
  SetLength( Result, j );
end;

// nom du dossier local d'envoi
function TFrm_Main.LocalSendPathName: TFileName;
begin
  // constituer chemin et terminer par slash
  Result := ExtractFileDir( Application.ExeName ) + Edt_LocalEnvoyer.Text;
  Result := IncludeTrailingPathDelimiter( Result );
end;

// Retourne les différentes parties d'une adresse dans un tableau
function TFrm_Main.LignesAdresse(aAdrLignes: String): TAdrLignes;
var
  regAdresse : TRegExpr;
  i, j: Integer;
begin
  // Met les champs à vide par défaut
  for i := 1 to 3 do
    Result[i] := '';

  // Créer l'expression régulière
  regAdresse := TRegExpr.Create();
  try
    // Spécifie l'expression régulière à utiliser
    regAdresse.Expression := txtRegExpr;

    // Exécute l'expression sur la chaîne passée en paramètre
    if regAdresse.Exec(aAdrLignes) then
    begin
      j := 1;

      // Parcours la liste des sous-chaînes trouvées
      for i := 1 to 3 do
      begin
        // Si il y a une sous-chaîne de trouvée pour chaque bloc
        if regAdresse.Match[i] <> '' then
        begin
          Result[j] := TrimRight(RegAdresse.Match[i]);
          Inc(j);
        end;
      end;
    end;
  finally
    regAdresse.Free();
  end;
end;

// nom du dossier local de réception
function TFrm_Main.LocalReceivePathName: TFileName;
begin
  // constituer chemin et terminer par slash
  Result := ExtractFileDir( Application.ExeName ) + Edt_LocalRecevoir.Text;
  Result := IncludeTrailingPathDelimiter( Result );
end;

// nom du dossier local d'archives, selon fichier local (envoi ou réception)
function TFrm_Main.GetArchivesPathName( ALocal: Boolean; const APathName: string ): TFileName;
var
  s: string;
begin
  // constituer chemin à partir du chemin du dossier local et terminer par slash
  if ALocal then
  begin
    s := Edt_LocalArchiver.Text;
  end else
  begin
    s := Edt_ServeurArchiver.Text;
  end;
  if IsPathDelimiter( s, 1 ) then s := Copy( s, 2, Length( s ));
  Result := IncludeTrailingPathDelimiter( APathName + s );
end;

// nom du dossier distant de réception
function TFrm_Main.DistantReceivePathName: TFileName;
begin
  // constituer chemin et terminer par backslash
  Result := Edt_ServeurRecevoir.Text;
  Result := IncludeTrailingPathDelimiter( Result );
end;

// nom du dossier distant d'envoi
function TFrm_Main.DistantSendPathName: TFileName;
begin
  // constituer chemin et terminer par backslash
  Result := Edt_ServeurEnvoyer.Text;
  Result := IncludeTrailingPathDelimiter( Result );
end;

// charger une liste avec les noms des fichiers d'un dossier
procedure TFrm_Main.GetPathFileNames( AList: TStrings; const APathName: string; AMaxDate: TDateTime = 0 );
var
  s: string;
  r: TSearchRec;
begin
  // constituer filtre et dossier de recherche
  s := '*.*';
  if APathName <> '' then
  begin
    s := IncludeTrailingPathDelimiter( APathName ) + s;
  end;
  // parcourir le dossier, ajouter chaque nom complet de fichier à la liste (option : passé une certaine date si indiquée)
  AList.Clear;
  if FindFirst( s, 0, r ) = 0 then
  begin
    repeat
      if (( AMaxDate = 0 ) or ( r.TimeStamp <= AMaxDate )) then
      begin
        AList.Append( r.Name );
      end;
    until FindNext( r ) <> 0;
    FindClose( r );
  end;
end;

// génération d'un nom de fichier csv complet d'après son titre (format "X:\Chemin\Titre_AAAAMMJJ_HHMMSS.csv")
function TFrm_Main.GetFileName( const APathName, AFileTitle: string ): TFileName;
var
  p,f,e: string;
begin
  // constituer chemin, fichier ( titre + date/heure), extension
  p := IncludeTrailingPathDelimiter( APathName );
  f := AFileTitle + FormatDateTime( '_yyyymmdd_hhnnss', Now );
  e := '.csv';
  // constituer nom fichier...
  Result := p + f + e;
end;

// écriture message dans le journal
procedure TFrm_Main.WriteLog( const AText: string );
var
  fLogs: TextFile;
begin
  // conserver dernier texte et ajouter dans le journal interne
  FLogCurrent := AText;
  FLogInternal.Append( FLogCurrent );
  // écrire message complet de date+heure dans le journal visible et conserver message complet
  FLogMessage := FormatDateTime( 'dd/mm/yyyy hh:nn:ss.zzz - ', Now ) + FLogCurrent;
  Mem_Log.Lines.Append( FLogMessage );

  // Enregistre le message dans le fichier de logs
  AssignFile(fLogs, FLogChemin);
  if not FileExists(FLogChemin) then
  begin
    Rewrite(fLogs);
  end
  else begin
    Append(fLogs);
  end;
  Writeln(fLogs, FLogMessage);
  System.Close(fLogs);
end;

// écriture résultat dans le journal (à la suite d'une ligne de texte si elle existe)
procedure TFrm_Main.WriteLog( const AText: string; const AResult: string );
var
  fLogs: TextFile;
var
  i: Integer;
begin
  // chercher le précédent message, si trouvé, ajouter le résultat au précédent message
  i := FLogInternal.IndexOf( AText );
  if i >= 0 then
  begin
    FLogMessage := Mem_Log.Lines[i] + AResult;
    Mem_Log.Lines[i] := FLogMessage;

    // Enregistre le message dans le fichier de logs
    AssignFile(fLogs, FLogChemin);
    if not FileExists(FLogChemin) then
    begin
      Rewrite(fLogs);
    end
    else begin
      Append(fLogs);
    end;
    Writeln(fLogs, AResult);
    System.Close(fLogs);
  end
  // si précédent message pas trouvé, écrire message + résultat
  else
  begin
    WriteLog( AText + AResult );
  end;
end;

// effacer le journal
procedure TFrm_Main.ClearLog;
var
  sCheminExe: String;
begin
  FLogCurrent := '';
  FLogInternal.Clear;
  Mem_Log.Lines.Clear;

  sCheminExe := ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  ForceDirectories(sCheminExe + '\Logs');
  FLogChemin := Format(txtLogFichier,
    [sCheminExe + '\Logs', FormatDateTime('yyyy-mm-dd', Now())]);
end;

// Méthode ConnectDB: connection à la BD
procedure TFrm_Main.ConnectDB;
begin
  // si déjà connecté, sortir immédiatement
  if IBC_Ginkoia.Connected then
  begin
    Exit;
  end;
  // indiquer paramètres BD
  with IBC_Ginkoia do
  begin
    UserName := txtDBUsername;
    Password := txtDBPassword;
    DatabaseName := Chp_DBNom.Text;
  end;
  IBC_Ginkoia.Connect;
end;

// Méthode DisconnectDB: déconnection de la BD
procedure TFrm_Main.DisconnectDB;
begin
  if IBC_Ginkoia.Connected then
  begin
    IBC_Ginkoia.Disconnect;
  end;
end;

// fonction GetDBParamValue : retourne la valeur d'un paramètre (type 18) d'après son code (option : pour un magasin)
function TFrm_Main.GetDBParamValue( AParamCode: Integer; const AFieldName: string; AMagId: Integer = 0 ): string;
begin
  with Que_GenParam do
  begin
    if not Active then
    begin
      Open;
    end;
    if AMagId <> 0 then
    begin
      Locate( 'PRM_CODE;PRM_MAGID', VarArrayOf( [AParamCode,AMagId] ), [] );
    end else
    begin
      Locate( 'PRM_CODE', AParamCode, [] );
    end;
    Result := FieldByName( AFieldName ).AsString;
  end;
end;

// méthode SetDBParamValue : écrit dans la base la valeur d'un paramètre (type 18)
procedure TFrm_Main.SetDBParamValue( AParamCode: Integer; const AFieldName: string; AValue: Variant; AMagId: Integer = 0 );
begin
  // se positionner sur le paramètre voulu et le mettre à jour
  GetDBParamValue( AParamCode, 'PRM_ID', AMagId );
  with Que_GenParam do
  begin
    Edit;
    FieldByName( AFieldName ).Value := AValue;
    Post;
  end;
  // ne pas oublier le K
  with SP_Ginkoia do
  begin
    StoredProcName := 'PR_UPDATEK';
    ParamByName( 'K_ID' ).AsInteger := Que_GenParam.FieldByName( 'PRM_ID' ).AsInteger;
    ParamByName( 'SUPRESSION' ).AsInteger := 0;
    ExecProc;
  end;
end;

// méthode GetDBParamValues : remplit une liste avec toutes les valeurs d'un paramètre (type 18) d'après son code
procedure TFrm_Main.GetDBParamValues( AValueList: TList; AParamCode: Integer; const AFieldName: string );
begin
  with Que_GenParam do
  begin
    Filter := Format( 'PRM_CODE=%d', [AParamCode] );
    Filtered := True;
    First;
    while not EOF do begin
      AValueList.Add( Pointer( FieldByName( AFieldName ).AsInteger ));
      Next;
    end;
    Filtered := False;
  end;
end;

// méthode GetDBVersion : renvoie le numéro de dernière version des maj
function TFrm_Main.GetDBVersion( AFinPlage: Boolean ): Integer;
const
  txtSQLSelectCurrentVersion = 'SELECT BAS_PLAGE FROM GENBASES WHERE BAS_IDENT=''0''';
var
  s: string;
begin
  with Que_Maitre do
  begin
    SQL.Text := txtSQLSelectCurrentVersion;
    Open;
    s := FieldByName( 'BAS_PLAGE' ).AsString;             // [100M_200M]
    s := Copy( s, Pos( '_', s ) + 1, Length( s ));      // 200M]
    s := Copy( s, 1, Pos( 'M', s ) - 1 );               // 200
    FMaxVersion := StrToInt( s ) * 1000000;
    s := FieldByName( 'BAS_PLAGE' ).AsString;             // [100M_200M]
    s := Copy( s, Pos( '[', s ) + 1, Length( s ));      // 100M_200M]
    s := Copy( s, 1, Pos( 'M', s ) - 1 );               // 100
    FMinVersion := StrToInt( s ) * 1000000;
    if AFinPlage then
    begin
      Result := FMaxVersion;
    end else
    begin
      Result := FMinVersion;
    end;
  end;
end;

// méthode GetDBLastVersion : renvoie le numéro de dernière version des maj
function TFrm_Main.GetDBLastVersion: Integer;
const
  txtSQLSelectNewVersion = 'SELECT MAX(K_VERSION) AS LAST_VERSION FROM K WHERE K_VERSION BETWEEN :MINVERSION AND :MAXVERSION';
begin
  with Que_Maitre do
  begin
    SQL.Text := txtSQLSelectNewVersion;
    ParamByName( 'MINVERSION' ).AsInteger := FMinVersion;
    ParamByName( 'MAXVERSION' ).AsInteger := FMaxVersion;
    Open;
    Result := FieldByName( 'LAST_VERSION' ).AsInteger;
  end;
end;

// méthode GetDBEstEntrepot : indique si un magasin est entrepot
function TFrm_Main.GetDBEstEntrepot( AMagId: Integer ): Boolean;
const
  txtSQLSelectGenMagasin = 'SELECT MAG_ENTREPOT FROM GENMAGASIN WHERE MAG_ID=:MAGID';
begin
  with Que_Maitre do
  begin
    SQL.Text := txtSQLSelectGenMagasin;
    ParamByName( 'MAGID' ).AsInteger := AMagId;
    Open;
    Result := FieldByName( 'MAG_ENTREPOT' ).AsInteger = 1;
  end;
end;

// méthode ConnectFTP : connexion FTP
procedure TFrm_Main.ConnectFTP;
begin
  // si déjà connecté, sortir immédiatement
  if IdFTP_Main.Connected then
  begin
    Exit;
  end;
  // indiquer paramètres FTP
  with IdFTP_Main do
  begin
    Host := Chp_FTPHost.Text;
    Port := StrToInt( Chp_FTPPort.Text );
    Username := Chp_FTPUsername.Text;
    Password := Chp_FTPPassword.Text;
    ListenTimeout := StrToInt( Chp_FTPListenTimeout.Text );
    TransferTimeout := StrToInt( Chp_FTPTransferTimeout.Text );
    ReadTimeout := StrToInt( Chp_FTPReadTimeout.Text );
  end;
  // connexion FTP
  IdFTP_Main.Connect;
end;

// méthode DisconnectFTP : déconnexion FTP
procedure TFrm_Main.DisconnectFTP;
begin
  if IdFTP_Main.Connected then
  begin
    IdFTP_Main.Disconnect;
  end;
end;

// méthode GetFTPFileNames : remplit la liste avec les fichiers d'un dossier sur le serveur FTP
procedure TFrm_Main.GetFTPFileNames( AList: TStrings; const APathName: string );
begin
  // se connecter au serveur FTP
  ConnectFTP;
  // se positionner dans le dossier du serveur
  with IdFTP_Main do
  begin
    if RetrieveCurrentDir <> APathName then
    begin
      ChangeDir( APathName );
    end;
    List( AList, '*.csv', False );
  end;
end;

// méthode SendFTPFile : envoi d'un fichier vers le serveur distant
procedure TFrm_Main.SendFTPFile( const AOriginFileName, ADestinationPathName: TFileName );
begin
  // se connecter à FTP
  ConnectFTP;
  // envoi fichier via FTP
  with IdFTP_Main do
  begin
    if RetrieveCurrentDir <> ADestinationPathName then
    begin
      ChangeDir( ADestinationPathName );
    end;
    Put( AOriginFileName, ExtractFileName( AOriginFileName ));
  end;
end;

// méthode ReceiveFTPFile : réception d'un fichier depuis le serveur distant
procedure TFrm_Main.ReceiveFTPFile( const AOriginFileName, ADestinationPathName: TFileName );
begin
  // se connecter à FTP
  ConnectFTP;
  // réception fichier via FTP
  with IdFTP_Main do
  begin
    if not FileExists( ADestinationPathName + ExtractFileName( AOriginFileName )) then
    begin
      Get( AOriginFileName, ADestinationPathName + AOriginFileName );
    end;
  end;
end;

// méthode MoveFTPFile : déplace un fichier du serveur distant dans un autre dossier
procedure TFrm_Main.MoveFTPFile( const AOriginFileName, ADestinationPathName: TFileName );
begin
  // se connecter à FTP
  ConnectFTP;
  // renommer fichier FTP
  with IdFTP_Main do
  begin
    IdFTP_Main.Rename( AOriginFileName, ADestinationPathName + ExtractFileName( AOriginFileName ));
  end;
end;

// méthode DeleteFTPFile : suppirme un fichier du serveur distant
procedure TFrm_Main.DeleteFTPFile( const AFileName: TFileName );
begin
  // se connecter à FTP
  ConnectFTP;
  // renommer fichier FTP
  with IdFTP_Main do
  begin
    IdFTP_Main.Delete( AFileName );
  end;
end;

// méthode DisconnectSMTP : déconnexion SMTP
procedure TFrm_Main.DisconnectSMTP;
begin
  // si on es connecté, se déconnecter
  if SMTP_Mail.Connected then
  begin
    SMTP_Mail.Disconnect;
  end;
end;

// méthode ConnectSMTP : connexion SMTP
procedure TFrm_Main.ConnectSMTP;
begin
  // si déjà connecté, sortir immédiatement
  if SMTP_Mail.Connected then
  begin
    Exit;
  end;
  // écrire paramétres serveur
  with SMTP_Mail do
  begin
    Host := Edt_MailSMTP.Text;
    Port := StrToInt( Edt_MailPort.Text );
    if Chk_MailSSL.Checked then
    begin
      UseTLS := utUseRequireTLS;
      SSL_Mail.Port := Port;
    end;
    if Edt_MailUsername.Text <> '' then
    begin
      AuthType := satDefault;
      Username := Edt_MailUsername.Text;
      Password := Edt_MailPassword.Text;
    end else
    begin
      AuthType := satNone;
    end;
  end;
  // se connecter
  SMTP_Mail.Connect;
end;

// envoi du journal par mél via SMTP
procedure TFrm_Main.SendSMTPMail;
begin
  // écrire paramètres mél
  with Msg_Mail do
  begin
    Clear;
    From.Address := Edt_MailFrom.Text;
    Recipients.EMailAddresses := Edt_MailTo.Text;
    Msg_Mail.
    Subject := 'Compte-rendu d''exécution de : ' + Application.ExeName;
    Body.Clear();
    Body.Add('= JOURNAL =========================');
    Body.Add(Mem_Log.Lines.Text);
    if Mem_Requetes.Lines.Count > 0 then
    begin
      Body.Add('= REQUÊTES ========================');
      Body.Add(Mem_Requetes.Lines.Text);
    end;
  end;
  // envoyer message
  try
    ConnectSMTP;
    SMTP_Mail.Send( Msg_Mail );
  // en cas de problème, écrire journal erreur, et NE PAS TRANSMETTRE l'exception
  except
    on E: Exception do
    begin
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
    end;
  end;
end;

// Exporter liste des magasins
procedure TFrm_Main.ExporterMagasins;
const
  txtSQLSelectMagasinsListe = 'SELECT MAGID, MAGNOM, MAGENTREPOT FROM STOCKIT_MAGASINS_LISTE';
var
  b: TBytes;
  n: TFileName;
  f: TFileStream;
  s: TStringBuilder;
begin
  // initialiser nom fichier et journal
  n := GetFileName( LocalSendPathName, txtFichierMagasins );
  WriteLog( Format( txtLogTacheExport, [n] ));
  // écrire enregistrements dataset dans fichier, écrire journal OK
  try
    // créer chaine temporaire et fichier
    s := TStringBuilder.Create;
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    // parcourir ensemble de données magasins, lire magasin et écrire magasin
    with Que_Maitre do
    begin
      SQL.Text := txtSQLSelectMagasinsListe;
      Open;
      while not EOF do
      begin
        s.Clear;
        s.Append( FieldByName( 'MAGID' ).AsString ).Append( txtCSVSeparator ); // 1
        s.Append( LeftStr( FieldByName( 'MAGNOM' ).AsString, 64 )).Append( txtCSVSeparator ); // 2
        s.Append( FieldByName( 'MAGENTREPOT' ).AsString ); // 3
        s.AppendLine;
        b := TEncoding.Default.GetBytes( s.ToString );
        f.Write( b[0], Length( b ));
        Next;
      end;
    end;
    // libérer ressources
    FreeAndNil( f );
    FreeAndNil( s );

    // Supprime le fichier s'il est vide
    if Que_Maitre.RecordCount = 0 then
    begin
      DeleteFile(n);
      WriteLog(Format(txtLogTacheFichierVide, [n]));
    end
    else begin
      if Que_Maitre.RecordCount > 1 then
        WriteLog(Format(txtLogTacheFichierExportes, [Que_Maitre.RecordCount, n]))
      else
        WriteLog(Format(txtLogTacheFichierExporte, [Que_Maitre.RecordCount, n]));
    end;

    // écrire journal OK
    WriteLog( FLogCurrent, txtLogTacheOK );
  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( f );
    FreeAndNil( s );
    raise;
  end;
end;

// Exporter fiches Articles
procedure TFrm_Main.ExporterArticles( ALastVersion, ACurrentVersion: Integer );
const
  txtSQLSelectArticlesFiches = 'SELECT * FROM STOCKIT_ARTICLES_FICHES( :LASTVERSION, :CURRENTVERSION, :STOCK, :ARCHIVE )';
var
  b: TBytes;
  i: Integer;
  n: TFileName;
  f: TFileStream;
  s: TStringBuilder;
begin
  // initialiser nom fichier et log
  n := GetFileName( LocalSendPathName, txtFichierArticles );
  WriteLog( Format( txtLogTacheExport, [n] ));
  // écrire enregistrements dataset dans fichier texte, écrire journal OK
  try
    // créer chaine temporaire et fichier
    s := TStringBuilder.Create;
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    // parcourir ensemble de données articles, lire article et écrire article
    with Que_Maitre do
    begin
      SQL.Text := txtSQLSelectArticlesFiches;
      ParamByName( 'LASTVERSION' ).AsInteger := ALastVersion;
      ParamByName( 'CURRENTVERSION' ).AsInteger := ACurrentVersion;
      ParamByName( 'STOCK' ).AsInteger := 0; // articles y compris sans stock
      ParamByName( 'ARCHIVE' ).AsInteger := 0; // articles non archivés
      Open;

      while not EOF do
      begin
        if FieldByName( 'CBICB' ).AsString <> '' then
        begin
          s.Clear;
          s.Append( LeftStr( FieldByName( 'CBICB' ).AsString, 30 )).Append( txtCSVSeparator ); // 1
          s.Append( LeftStr( FieldByName( 'ARTREFMRK' ).AsString, 35 )).Append( txtCSVSeparator ); // 2
          s.Append( LeftStr( FieldByName( 'ARTNOM' ).AsString, 150 )).Append( txtCSVSeparator ); // 3
          s.Append( txtCSVSeparator ); // 4
          s.Append( LeftStr( FieldByName( 'MRKNOM' ).AsString, 250 )).Append( txtCSVSeparator );  // 5
          s.Append( FieldByName( 'ARFCHRONO' ).AsString ).Append( txtCSVSeparator );  // 6
          s.Append( FieldByName( 'COULEUR' ).AsString ).Append( txtCSVSeparator );  // 7
          s.Append( FieldByName( 'ARFARCHIVER' ).AsString ).Append( txtCSVSeparator );  // 8
          s.Append( txtCSVSeparator ); // 9
          s.Append( FieldByName( 'TGFNOM' ).AsString ).Append( txtCSVSeparator ); // 10
          for i := 11 to 12 do s.Append( txtCSVSeparator ); // 11 à 12
          s.Append( LeftStr( FieldByName( 'FAMSSFNOM' ).AsString, 200 )).Append( txtCSVSeparator ); // 13
          s.Append( LeftStr( FieldByName( 'RAYNOM' ).AsString, 200 )).Append( txtCSVSeparator ); // 14
          for i := 15 to 16 do s.Append( txtCSVSeparator ); // 15 à 16
          s.Append( FieldByName( 'VIRTUEL' ).AsString ).Append( txtCSVSeparator ); // 17
          for i := 18 to 19 do s.Append( txtCSVSeparator ); // 18 à 19

          s.AppendLine;
          b := TEncoding.Default.GetBytes( s.ToString );
          f.Write( b[0], Length( b ));
        end;
        Next;
      end;
    end;
    FreeAndNil( f );
    FreeAndNil( s );

    // Supprime le fichier s'il est vide
    if Que_Maitre.RecordCount = 0 then
    begin
      DeleteFile(n);
      WriteLog(Format(txtLogTacheFichierVide, [n]));
    end
    else begin
      if Que_Maitre.RecordCount > 1 then
        WriteLog(Format(txtLogTacheFichierExportes, [Que_Maitre.RecordCount, n]))
      else
        WriteLog(Format(txtLogTacheFichierExporte, [Que_Maitre.RecordCount, n]));
    end;

    WriteLog( FLogCurrent, txtLogTacheOK );
  // en cas de problème, libérer ressources et lever l'exception
  except
    FreeAndNil( f );
    FreeAndNil( s );
    raise;
  end;
end;

// Exporter stock entrant ou sortant (fichier StockIn ou StockOut) selon sens indiqué par paramètre booléen AStockIn
procedure TFrm_Main.ExporterStockIO( AListMagId: TList; ADateInit: TDateTime; ALastVersion, ACurrentVersion: Integer; AStockIn: Boolean );
const
  txtSQLSelectStockIn   = 'SELECT ID, NUMERO, DATEMOUV, NOMPRENOM, ADRLIGNE, VILCP, VILNOM, PAYNOM, IDMAG,'#13#10
                        + '       CLTTEL, CLTEMAIL, NBLIGNE, NUMEROLIGNE, CBICB, IDLIGNE, QTE, TYPEENREG,'#13#10
                        + '       KENABLED'#13#10
                        + 'FROM STOCKIT_EXPORT_STOCK(:DATEINIT, :LASTVERSION, :CURRENTVERSION, :MAGID)'#13#10
                        + 'WHERE (QTE >= 0)';
  txtSQLSelectStockOut  = 'SELECT ID, NUMERO, DATEMOUV, NOMPRENOM, ADRLIGNE, VILCP, VILNOM, PAYNOM, IDMAG,'#13#10
                        + '       CLTTEL, CLTEMAIL, NBLIGNE, NUMEROLIGNE, CBICB, IDLIGNE, QTE, TYPEENREG,'#13#10
                        + '       KENABLED'#13#10
                        + 'FROM STOCKIT_EXPORT_STOCK(:DATEINIT, :LASTVERSION, :CURRENTVERSION, :MAGID)'#13#10
                        + 'WHERE (QTE < 0)';
var
  b: TBytes;
  n: TFileName;
  f: TFileStream;
  s: TStringBuilder;
  i,j,Sens: Integer;
  bFichierVide: Boolean;
  q,e,sEntete,sEnteteFR,sEnteteCL,sEnteteST,sBLType,sBL20,sSite,sLangue,sDT20,sDT22,sDT32,sAdrLignes: string;
  asAdrLignes: TAdrLignes;
begin
  // initialiser nom fichier, requête et journal
  if AStockIn then
  begin
    n := GetFileName( LocalSendPathName, txtFichierStockIn );
    q := txtSQLSelectStockIn;
  end else
  begin
    n := GetFileName( LocalSendPathName, txtFichierStockOut );
    q := txtSQLSelectStockOut;
  end;
  WriteLog( Format( txtLogTacheExport, [n] ));
  // initialiser valeurs de champs, selon sens StockIn ou StockOut
  sEnteteFR := GetDBParamValue( intParamEnteteFR, 'PRM_STRING' );
  sEnteteCL := GetDBParamValue( intParamEnteteCL, 'PRM_STRING' );
  sEnteteST := GetDBParamValue( intParamEnteteST, 'PRM_STRING' );
  sSite := '1';
  sLangue := '0';
  if AStockIn then
  begin
    Sens := +1;
    sBLType := '03';
    sBL20 := '';
    sDT20 := '1';
    sDT22 := '1';
    sDT32 := '0';
  end else
  begin
    Sens := -1;
    sBLType := '99';
    sBL20 := 'OK';
    sDT20 := '';
    sDT22 := '';
    sDT32 := '1';
  end;
  // écrire fichier
  try
    // initialiser écriture fichier
    bFichierVide := True;
    s := TStringBuilder.Create;
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    // écrire entête fichier StockOut (lignes d'entete FR, CL, ST)
    s.Clear;
    if not AStockIn then
    begin
      s.Append( sEnteteFR ).AppendLine;
      s.Append( sEnteteCL ).AppendLine;
      s.Append( sEnteteST ).AppendLine;
    end;
    b := TEncoding.Default.GetBytes( s.ToString );
    f.Write( b[0], Length( b ));
    // écrire stock de tous les magasins de type Entrepôt
    for i := 0 to AListMagId.Count - 1 do
    begin
      if GetDBEstEntrepot( Integer( AListMagId[i] )) then
      begin
        with Que_Maitre do
        begin
          SQL.Text := q;
          ParamByName( 'DATEINIT' ).AsDateTime := ADateInit;
          ParamByName( 'LASTVERSION' ).AsInteger := ALastVersion;
          ParamByName( 'CURRENTVERSION' ).AsInteger := ACurrentVersion;
          ParamByName( 'MAGID' ).AsInteger := Integer(  AListMagId[i] );
          Open;
          if RecordCount > 0 then bFichierVide := False;
          sEntete := '';
          while not EOF do
          begin
            // lire l'ID dans le dataset
            s.Clear;
            e := FieldByName( 'ID' ).AsString;
            // si nouvelle entête, écrire entête dans le fichier
            if e <> sEntete then
            begin
              if AStockIn then // pré-entête BL pour StockIn (lignes d'entête FR, ST)
              begin
                s.Append( sEnteteFR ).AppendLine;
                s.Append( sEnteteST ).AppendLine;
              end;
              s.Append( 'BL' ).Append( txtCSVSeparator ); // 1
              s.Append( FieldByName( 'TYPEENREG' ).AsString + FieldByName( 'NUMERO' ).AsString ).Append( txtCSVSeparator ); // 2
              s.Append( sBLType ).Append( txtCSVSeparator ); // 3
              s.Append( FormatDateTime( 'yyyymmdd', FieldByName( 'DATEMOUV' ).AsDateTime )).Append( txtCSVSeparator ); // 4
              for j := 5 to 11 do s.Append( txtCSVSeparator ); // 5 à 11
              s.Append(FieldByName('NOMPRENOM').AsString).Append(txtCSVSeparator); // 12

              sAdrLignes := FieldByName('ADRLIGNE').AsString;
              asAdrLignes := LignesAdresse(sAdrLignes);
              s.Append(asAdrLignes[1]).Append(txtCSVSeparator); // 13
              s.Append(asAdrLignes[2]).Append(txtCSVSeparator); // 14
              s.Append(asAdrLignes[3]).Append(txtCSVSeparator); // 15

              s.Append(FieldByName('VILCP').AsString).Append(txtCSVSeparator); // 16
              s.Append(FieldByName('VILNOM').AsString).Append(txtCSVSeparator); // 17
              s.Append(FieldByName('PAYNOM').AsString).Append(txtCSVSeparator); // 18

              s.Append(txtCSVSeparator); // 19

              s.Append( sBL20 ).Append( txtCSVSeparator ); // 20
              s.Append( txtCSVSeparator ); // 21
              s.Append( FieldByName( 'IDMAG' ).AsString ).Append( txtCSVSeparator ); // 22

              s.Append(FieldByName('CLTTEL').AsString).Append(txtCSVSeparator); // 23
              s.Append(FieldByName('CLTEMAIL').AsString).Append(txtCSVSeparator); // 24

              for j := 25 to 27 do s.Append( txtCSVSeparator ); // 25 à 27
              s.Append( sSite ).Append( txtCSVSeparator ); // 28
              s.Append( sLangue ).Append( txtCSVSeparator ); // 29
              s.AppendLine;
              sEntete := e;
            end;

            // écrire ligne dans le fichier
            if (FieldByName('KENABLED').AsInteger = 1) then
            begin
              s.Append( 'DT' ).Append( txtCSVSeparator ); // 1
              s.Append( FieldByName( 'NBLIGNE' ).AsString ).Append( txtCSVSeparator ); // 2
              s.Append( FieldByName( 'TYPEENREG' ).AsString + FieldByName( 'NUMEROLIGNE' ).AsString ).Append( txtCSVSeparator ); // 3
              s.Append( FieldByName( 'CBICB' ).AsString ).Append( txtCSVSeparator ); // 4
              for j := 5 to 6 do s.Append( txtCSVSeparator ); // 5 à 6
              s.Append( FieldByName( 'IDLIGNE' ).AsString ).Append( txtCSVSeparator ); // 7
              for j := 8 to 19 do s.Append( txtCSVSeparator ); // 8 à 19
              s.Append( sDT20 ).Append( txtCSVSeparator ); // 20
              s.Append( txtCSVSeparator ); // 21
              s.Append( sDT22 ).Append( txtCSVSeparator ); // 22
              s.Append( txtCSVSeparator ); // 23
              s.Append( IntToStr( FieldByName( 'QTE' ).AsInteger * Sens )).Append( txtCSVSeparator ); // 24
              s.Append( 'PIECES' ).Append( txtCSVSeparator ); // 25
              for j := 26 to 31 do s.Append( txtCSVSeparator ); // 26 à 31
              s.Append( sDT32 ).Append( txtCSVSeparator ); // 32
              for j := 33 to 39 do s.Append( txtCSVSeparator ); // 33 à 39
              s.AppendLine;
            end;

            b := TEncoding.Default.GetBytes( s.ToString );
            f.Write( b[0], Length( b ));
            Next;
          end;
          Next;
        end;
      end;
    end;
    // libérer ressources
    FreeAndNil( f );
    FreeAndNil( s );

    if bFichierVide then
    begin
      DeleteFile( n );
      WriteLog(Format(txtLogTacheFichierVide, [n]));
    end
    else begin
      if Que_Maitre.RecordCount > 1 then
        WriteLog(Format(txtLogTacheFichierExportes, [Que_Maitre.RecordCount, n]))
      else
        WriteLog(Format(txtLogTacheFichierExporte, [Que_Maitre.RecordCount, n]));
    end;

    // écrire journal OK
    WriteLog( FLogCurrent, txtLogTacheOK );
  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( f );
    FreeAndNil( s );
    raise;
  end;
end;

// Exporter Transferts inter-magasins
procedure TFrm_Main.ExporterTransferts( ALastVersion, ACurrentVersion: Integer );
const
  txtSQLSelectTransferts = 'SELECT MAGOID, MAGDID, CBICB, IMLQTE, IMADATE, IMLID, IMANUMERO FROM STOCKIT_TRANSFERTSIM_LISTE( :LASTVERSION, :CURRENTVERSION )';
var
  b: TBytes;
  n: TFileName;
  f: TFileStream;
  s: TStringBuilder;
  bFichierVide: Boolean;
begin
  // initialiser nom fichier et log
  n := GetFileName( LocalSendPathName, txtFichierTIM );
  bFichierVide := True;
  WriteLog( Format( txtLogTacheExport, [n] ));
  // pour chaque magasin de type entrepot, lire les transferts et les écrire dans le fichier, écrire journal OK
  try
    s := TStringBuilder.Create;
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    with Que_Maitre do
    begin
      SQL.Text := txtSQLSelectTransferts;
      ParamByName( 'LASTVERSION' ).AsInteger := ALastVersion;
      ParamByName( 'CURRENTVERSION' ).AsInteger := ACurrentVersion;
      Open;
      if RecordCount > 0 then bFichierVide := False;
      while not EOF do
      begin
        s.Clear;
        s.Append( FieldByName( 'MAGOID' ).AsString ).Append( txtCSVSeparator ); // 1
        s.Append( FieldByName( 'MAGDID' ).AsString ).Append( txtCSVSeparator ); // 2
        s.Append( FieldByName( 'CBICB' ).AsString ).Append( txtCSVSeparator ); // 3
        s.Append( FieldByName( 'IMLQTE' ).AsString ).Append( txtCSVSeparator ); // 4
        s.Append( FormatDateTime( 'yyyymmdd', FieldByName( 'IMADATE' ).AsDateTime )).Append( txtCSVSeparator ); // 5
        s.Append( FieldByName( 'IMLID' ).AsString ).Append( txtCSVSeparator ); // 4
        s.Append( FieldByName( 'IMANUMERO' ).AsString ).Append( txtCSVSeparator ); // 4
        s.AppendLine;
        b := TEncoding.Default.GetBytes( s.ToString );
        f.Write( b[0], Length( b ));
        Next;
      end;
    end;
    FreeAndNil( f );
    FreeAndNil( s );

    if bFichierVide then
    begin
      DeleteFile( n );
      WriteLog(Format(txtLogTacheFichierVide, [n]));
    end
    else begin
      if Que_Maitre.RecordCount > 1 then
        WriteLog(Format(txtLogTacheFichierExportes, [Que_Maitre.RecordCount, n]))
      else
        WriteLog(Format(txtLogTacheFichierExporte, [Que_Maitre.RecordCount, n]));
    end;

    WriteLog( FLogCurrent, txtLogTacheOK );

  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( f );
    FreeAndNil( s );
    raise;
  end;
end;

// Exporter Mouvements magasins
procedure TFrm_Main.ExporterMouvements( AViderBI: Integer );
const
  txtSQLSelectMouvements = 'SELECT MAGID, SKU, QTE FROM STOCKIT_STOCK_MOUVEMENT( :VIDERBI )';
var
  b: TBytes;
  n: TFileName;
  f: TFileStream;
  s: TStringBuilder;
  bFichierVide: Boolean;
begin
  // initialiser nom fichier et log
  n := GetFileName( LocalSendPathName, txtFichierMouvements );
  bFichierVide := True;
  WriteLog( Format( txtLogTacheExport, [n] ));
  // lire les mouvements et les écrire dans le fichier, écrire journal OK
  try
    s := TStringBuilder.Create;
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    with Que_Maitre do
    begin
      SQL.Text := txtSQLSelectMouvements;
      ParamByName( 'VIDERBI' ).AsInteger := AViderBI;
      Open;
      if RecordCount > 0 then bFichierVide := False;
      while not EOF do
      begin
        s.Clear;
        s.Append( FieldByName( 'MAGID' ).AsString ).Append( txtCSVSeparator ); // 1
        s.Append( LeftStr( FieldByName( 'SKU' ).AsString, 15 )).Append( txtCSVSeparator ); // 2
        s.Append( FieldByName( 'QTE' ).AsString ).Append( txtCSVSeparator ); // 3
        s.AppendLine;
        b := TEncoding.Default.GetBytes( s.ToString );
        f.Write( b[0], Length( b ));
        Next;
      end;
    end;
    FreeAndNil( f );
    FreeAndNil( s );

    if bFichierVide then
    begin
      DeleteFile( n );
      WriteLog(Format(txtLogTacheFichierVide, [n]));
    end
    else begin
      if Que_Maitre.RecordCount > 1 then
        WriteLog(Format(txtLogTacheFichierExportes, [Que_Maitre.RecordCount, n]))
      else
        WriteLog(Format(txtLogTacheFichierExporte, [Que_Maitre.RecordCount, n]));
    end;

    WriteLog( FLogCurrent, txtLogTacheOK );

  // en cas de problème, écrire journal erreur, libérer ressources et transmettre l'exception
  except
    FreeAndNil( f );
    FreeAndNil( s );
    raise;
  end;
end;

// Exporter image du stock magasins
procedure TFrm_Main.ExporterStock( AListMagId: TList );
const
  txtSQLSelectStock = 'SELECT MAGID, SKU, QTE FROM STOCKIT_STOCK_MAGASIN( :MAGID )';
var
  l: TList;
  b: TBytes;
  i: Integer;
  n: TFileName;
  f: TFileStream;
  s: TStringBuilder;
  bFichierVide: Boolean;
begin
  // copier les MagId des magasins à traiter dans une nouvelle liste
  l := TList.Create;
  for i := 0 to AListMagId.Count - 1 do
  begin
    if GetDBParamValue( intParamMagasins, 'PRM_INTEGER', Integer( AListMagId[i] )) = '1' then
    begin
      l.Add( AListMagId[i] );
    end;
  end;
  // s'il y a au moins un magasin à traiter, créer fichier d'export stock
  if l.Count > 0 then
  begin
    // initialiser nom fichier et log
    n := GetFileName( LocalSendPathName, txtFichierStock );
    bFichierVide := True;
    WriteLog( Format( txtLogTacheExport, [n] ));
    // pour chaque magasin, lire les stocks et les écrire dans le fichier, écrire journal OK
    try
      s := TStringBuilder.Create;
      f := TFileStream.Create( n, fmCreate, fmShareExclusive );
      for i := 0 to l.Count - 1 do
      begin
        with Que_Maitre do
        begin
          SQL.Text := txtSQLSelectStock;
          ParamByName( 'MAGID' ).AsInteger := Integer( l[i] );
          Open;
          if RecordCount > 0 then bFichierVide := False;
          while not EOF do
          begin
            s.Clear;
            s.Append( FieldByName( 'MAGID' ).AsString ).Append( txtCSVSeparator ); // 1
            s.Append( LeftStr( FieldByName( 'SKU' ).AsString, 15 )).Append( txtCSVSeparator ); // 2
            s.Append( FieldByName( 'QTE' ).AsString ).Append( txtCSVSeparator ); // 3
            s.AppendLine;
            b := TEncoding.Default.GetBytes( s.ToString );
            f.Write( b[0], Length( b ));
            Next;
          end;
        end;
      end;
      FreeAndNil( f );
      FreeAndNil( s );
      WriteLog( FLogCurrent, txtLogTacheOK );

      if bFichierVide then
      begin
        DeleteFile( n );
        WriteLog(Format(txtLogTacheFichierVide, [n]));
      end
      else begin
        if Que_Maitre.RecordCount > 1 then
          WriteLog(Format(txtLogTacheFichierExportes, [Que_Maitre.RecordCount, n]))
        else
          WriteLog(Format(txtLogTacheFichierExporte, [Que_Maitre.RecordCount, n]));
      end;

    // en cas de problème, libérer ressources et transmettre l'exception
    except
      FreeAndNil( f );
      FreeAndNil( s );
      raise;
    end;
  end;
  // libérer liste temporaire
  l.Free;
end;

// Envoyer tous fichiers du dossier "à envoyer" vers le dossier "à recevoir" du serveur distant
procedure TFrm_Main.EnvoyerFichiers;
var
  e,a: TFileName;
  i: Integer;
  l: TStrings;
begin
  // écrire journal
  WriteLog( Format( txtLogTacheEnvois, [LocalSendPathName] ));
  // envoyer fichiers
  try
    // déterminer liste de fichiers à envoyer, progression (selon nombre de fichiers dans le dossier d'envoi)
    l := TStringList.Create;
    GetPathFileNames( l, LocalSendPathName );
    // envoyer fichiers dossier d'envoi client vers dossier réception serveur, archiver fichiers envoyés
    for i := 0 to l.Count - 1 do
    begin
      e := LocalSendPathName + l[i];                                // fichier avec chemin complet
      SendFTPFile( e, DistantReceivePathName );
      a := GetArchivesPathName( True, LocalSendPathName ) + l[i];   // fichier d'archive avec chemin complet
      RenameFile( e, a );
    end;
    // écrire journal OK
    WriteLog( FLogCurrent, txtLogTacheOK );
  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( l );
    raise;
  end;
  // liberer ressources
  l.Free;
end;

// Recevoir tous fichiers depuis le dossier serveur FTP "à envoyer" dans le dossier "à recevoir"
procedure TFrm_Main.RecevoirFichiers;
var
  r,a: TFileName;
  i: Integer;
  l: TStrings;
begin
  // écrire journal
  WriteLog( Format( txtLogTacheReceptions, [Chp_FTPHost.Text + Edt_ServeurEnvoyer.Text] ));
  // recevoir fichiers
  try
    // déterminer liste de fichiers à envoyer, progression (selon nombre de fichiers dans le dossier d'envoi)
    l := TStringList.Create;
    GetFTPFileNames( l, DistantSendPathName );
    // envoyer fichiers dossier d'envoi serveur vers dossier réception client, déplacer fichiers envoyés
    for i := 0 to l.Count - 1 do
    begin
      r := l[i];
      ReceiveFTPFile( r, LocalReceivePathName );
      a := GetArchivesPathName( False, DistantSendPathName ) + r;
      IdFTP_Main.Rename( r, a );
    end;
    // écrire journal OK
    WriteLog( FLogCurrent, txtLogTacheOK );
  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( l );
    raise;
  end;
  // liberer ressources
  l.Free;
end;

// Importer fichiers Transferts inter-magasins
procedure TFrm_Main.ImporterTransferts;
const
  txtSQLSelectTIMEntete = 'SELECT IMAID, CREE FROM STOCKIT_TRANSFERTSIM_IMPORT_ENTETE( :MAGO, :MAGD, :DATETRANS, 0 )';
  txtSQLExecuteTIMLigne = 'STOCKIT_TRANSFERTSIM_IMPORT_LIGNE';
var
  r: TFileName;
  i: Integer;
  l: TStrings;

  procedure EcrireTIM( const AFileName: string );
  var
    s, sEntete: string;
    i,p: Integer;
    l: TStrings;
    t: TStringDynArray;
    sMAGO, sMAGD, sQTE, sSKU, sAnnee, sMois, sJour: string;
  begin
    l := TStringList.Create;
    try
      // préparer dataset en mémoire pour tri avant d'importer dans la base
      with Cds_Main do
      begin
        Close;
        Cds_Main.FieldDefs.Clear;
        FieldDefs.Add( 'MAGO', ftInteger );
        FieldDefs.Add( 'MAGD', ftInteger );
        FieldDefs.Add( 'SKU', ftString, 15 );
        FieldDefs.Add( 'QTE', ftInteger );
        FieldDefs.Add( 'DATE', ftDateTime );
        FieldDefs.Add( 'LIGNE', ftInteger );
        CreateDataset;
        Open;
      end;
      // charger fichier dans dataset en mémoire
      l.LoadFromFile( AFileName );
      for i := 0 to l.Count - 1 do
      begin
        s := l[i];
        if Trim( s ) = '' then Continue; // ligne vide ? on passe
        t := SplitString( s, txtCSVSeparator );
        with Cds_Main do
        begin
          Append;
          FieldByName('MAGO').AsInteger := StrToInt( t[0] );
          FieldByName('MAGD').AsInteger := StrToInt( t[1] );
          FieldByName('SKU').AsString := t[2];
          FieldByName('QTE').AsInteger := StrToInt( t[3] );
          FieldByName('DATE').AsDateTime := EncodeDate( StrToInt( Copy( t[4], 1, 4 )), StrToInt( Copy( t[4], 5, 2 )), StrToInt( Copy( t[4], 7, 2 )));
          FieldByName('LIGNE').AsInteger := Succ(i);
          Post;
        end;
      end;
      // parcourir dataset mémoire pour écrire entêtes et détails
      with Cds_Main do
      begin
        // trier le dataset mémoire par magasin d'origine, magasin de destination et date
        IndexFieldNames := 'MAGO;MAGD;DATE';
        First;
        // parcourir dataset mémoire
        sEntete := '';
        while not EOF do
        begin
          // si nouvel entête, l'écrire dans la base
          s := FieldByName( 'MAGO' ).AsString + FieldByName( 'MAGD' ).AsString + FieldByName( 'DATE' ).AsString;
          if s <> sEntete then
          begin
            Que_Maitre.Close;
            Que_Maitre.ParamByName( 'MAGO' ).AsInteger := Cds_Main.FieldByName( 'MAGO' ).AsInteger;
            Que_Maitre.ParamByName( 'MAGD' ).AsInteger := Cds_Main.FieldByName( 'MAGD' ).AsInteger;
            Que_Maitre.ParamByName( 'DATETRANS' ).AsDateTime := Cds_Main.FieldByName( 'DATE' ).AsDateTime;
            Que_Maitre.Open;

            // Si l'ajout de l'en-tête a provoqué une erreur : on la journalise
            if Que_Maitre.FieldByName('CREE').AsInteger = 0 then
            begin
              WriteLog(Format(txtLogTraimementErreurTIM,
                [Cds_Main.FieldByName('MAGO').AsInteger,
                  Cds_Main.FieldByName('MAGD').AsInteger,
                  Cds_Main.FieldByName('LIGNE').AsInteger]));
              Next();
              FEnvoyerCourriel := True;
              Continue;
            end;

            sEntete := s;
          end;
          // pour chaque ligne, écrire détail dans la base (utiliser IMAID de l'entete)
          SP_Ginkoia.ParamByName( 'IMAID' ).AsInteger := Que_Maitre.FieldByName( 'IMAID' ).AsInteger;
          SP_Ginkoia.ParamByName( 'SKU' ).AsString := FieldByName( 'SKU' ).AsString;
          SP_Ginkoia.ParamByName( 'QTE' ).AsInteger := FieldByName( 'QTE' ).AsInteger;
          SP_Ginkoia.ParamByName( 'DATETRANS' ).AsDateTime := FieldByName( 'DATE' ).AsDateTime;
          SP_Ginkoia.ExecProc;
          // ligne suivante
          Next;
        end;
      end;
    // libérer ressources
    finally
      l.Free;
      Finalize( t );
      Cds_Main.Close;
    end;
  end;

begin
  // importer fichiers
  try
    // constituer liste des fichiers à importer et progression
    l := TStringList.Create;
    GetPathFileNames( l, LocalReceivePathName );
    // requêtes
    Que_Maitre.SQL.Text := txtSQLSelectTIMEntete;
    SP_Ginkoia.StoredProcName := txtSQLExecuteTIMLigne;
    // pour chaque fichier, importer dans la base
    for i := 0 to l.Count - 1 do
    begin
      r := LocalReceivePathName + l[i];
      WriteLog( Format( txtLogTacheImport, [r] ));
      EcrireTIM( r );
      WriteLog( FLogCurrent, txtLogTacheOK );
    end;
  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( l );
    raise;
  end;
  // liberer ressources
  l.Free;
end;

// méthode ArchiverFichiers : déplace les fichiers importés
procedure TFrm_Main.ArchiverFichiers( const APathName: TFileName );
var
  r,a: TFileName;
  i: Integer;
  l: TStrings;
begin
    // pour chaque fichier du dossier indiqué, déplacer dans dossier archivé
    l := TStringList.Create;
    GetPathFileNames( l, APathName );
    for i := 0 to l.Count - 1 do
    begin
      r := APathName + l[i];
      WriteLog( Format( txtLogTacheArchive, [r] ));
      a := GetArchivesPathName( True, APathName ) + l[i];
      DeleteFile( a ); // si un fichier du même nom existe dans le dossier de destination (normalement non !)
      MoveFile( PChar( r ), PChar( a ));
      WriteLog( FLogCurrent, txtLogTacheOK );
    end;
end;

// méthode SupprimerFichiers : supprime les fichiers archivés qui ont passé l'age limite
procedure TFrm_Main.SupprimerFichiers;
var
  i: Integer;
  l: TStrings;
  d: TDateTime;
begin
  // écrire journal
  WriteLog( Format( txtLogTacheSupprimerFichiers, [Upd_LocalConserver.Position] ));
  // déterminer date correspondant à l'age limite en jours
  d := IncDay( Date(), - Upd_LocalConserver.Position );
  // supprimer les fichiers qui dépassent la date d'age limite
  l := TStringList.Create;
  try
    GetPathFileNames( l, GetArchivesPathName( True, LocalSendPathName ), d );
    for i := 0 to l.Count - 1 do DeleteFile( GetArchivesPathName( True, LocalSendPathName ) + l[i] );
    GetPathFileNames( l, GetArchivesPathName( True, LocalReceivePathName ), d );
    for i := 0 to l.Count - 1 do DeleteFile( GetArchivesPathName( True, LocalReceivePathName ) + l[i] );
    WriteLog( FLogCurrent, txtLogTacheOK );
  // en cas de problème, libérer ressources et transmettre l'exception
  except
    FreeAndNil( l );
    raise;
  end;
  // liberer ressources
  l.Free;
end;

// évènement FormCreate
procedure TFrm_Main.FormCreate(Sender: TObject);
var
  f: TMemIniFile;
begin
  // journal interne
  FLogInternal := TStringList.Create;
  // lire fichier d'initialisation, le créer si n'existe pas
  f := TMemIniFile.Create( txtIniFileName );
  with f do
  begin
    Chp_DBNom.Text                    := ReadString( txtIniSectionDB, txtIniKeyNom, Chp_DBNom.Text );
    Chp_FTPHost.Text                  := ReadString( txtIniSectionTransfert, txtIniKeyHost, Chp_FTPHost.Text );
    Chp_FTPPort.Text                  := ReadString( txtIniSectionTransfert, txtIniKeyPort, Chp_FTPPort.Text );
    Chp_FTPUsername.Text              := ReadString( txtIniSectionTransfert, txtIniKeyUsername, Chp_FTPUsername.Text );
    Chp_FTPPassword.Text              := DoUncryptPass( ReadString( txtIniSectionTransfert, txtIniKeyPassword, '' ));
    Chp_FTPListenTimeout.Text         := ReadString( txtIniSectionTransfert, txtIniKeyListen, Chp_FTPListenTimeout.Text );
    Chp_FTPTransferTimeout.Text       := ReadString( txtIniSectionTransfert, txtIniKeyTransfert, Chp_FTPTransferTimeout.Text );
    Chp_FTPReadTimeout.Text           := ReadString( txtIniSectionTransfert, txtIniKeyLecture, Chp_FTPReadTimeout.Text );
    Edt_LocalEnvoyer.Text             := ReadString( txtIniSectionFichiers, txtIniKeyLocalEnvoyer, Edt_LocalEnvoyer.Text );
    Edt_LocalRecevoir.Text            := ReadString( txtIniSectionFichiers, txtIniKeyLocalRecevoir, Edt_LocalRecevoir.Text );
    Edt_LocalArchiver.Text            := ReadString( txtIniSectionFichiers, txtIniKeyLocalArchiver, Edt_LocalArchiver.Text );
    Upd_LocalConserver.Position       := ReadInteger( txtIniSectionFichiers, txtIniKeyLocalConserver, Upd_LocalConserver.Position );
    Edt_ServeurEnvoyer.Text           := ReadString( txtIniSectionFichiers, txtIniKeyServeurEnvoyer, Edt_ServeurEnvoyer.Text );
    Edt_ServeurRecevoir.Text          := ReadString( txtIniSectionFichiers, txtIniKeyServeurRecevoir, Edt_ServeurRecevoir.Text );
    Edt_ServeurArchiver.Text          := ReadString( txtIniSectionFichiers, txtIniKeyServeurArchiver, Edt_ServeurArchiver.Text );
    Edt_MailSMTP.Text                 := ReadString( txtIniSectionMel, txtIniKeyHost, Edt_MailSMTP.Text );
    Edt_MailPort.Text                 := ReadString( txtIniSectionMel, txtIniKeyPort, Edt_MailPort.Text );
    Edt_MailUsername.Text             := ReadString( txtIniSectionMel, txtIniKeyUsername, Edt_MailUsername.Text );
    Edt_MailPassword.Text             := DoUncryptPass( ReadString( txtIniSectionMel, txtIniKeyPassword, '' ));
    Edt_MailFrom.Text                 := ReadString( txtIniSectionMel, txtIniKeyFrom, Edt_MailFrom.Text );
    Edt_MailTo.Text                   := ReadString( txtIniSectionMel, txtIniKeyTo, Edt_MailTo.Text );
    Chk_MailSSL.Checked               := ReadBool(txtIniSectionMel, txtIniKeySSL, False);
    Free;
  end;
  // indiquer mode d'après premier paramètre (Auto ou Manuel)
//  FModeAuto := ( UpperCase( ParamStr( 1 )) = txtParamAuto );
  FModeAuto := AnsiMatchText(ParamStr(1), [txtParamAuto, txtParamTestAuto]);
  FModeTestAuto := AnsiSameText(ParamStr(1), txtParamTestAuto);
  // en mode auto, cacher la fenêtre principale et lancer tous les traitements puis terminer application
  if FModeAuto then
  begin

    if FModeTestAuto then
    begin
      Chk_Send.Checked      := False;
      Chk_Receive.Checked   := False;
      Chk_Import.Checked  := False;
    end;

    Self.Visible := False;
    Nbt_TraitementClick( Nbt_Traitement );
    Application.Terminate;
  end
  // en mode manuel, demander mot de passe avant d'acceder à la fenêtre principale (si pas en mode debug)
  else
  begin
    Frm_MotDePasse := TFrm_MotDePasse.Create( Self );
    if ( DebugHook = 0 ) and ( Frm_MotDePasse.ShowModal <> mrOK ) then
    begin
      Application.Terminate;
    end;
  end;
end;

// évènement FormClose
procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
var
  f: TMemIniFile;
begin
  // journal interne
  FLogInternal.Free;
  // écrire fichier d'initialisation (toujours l'écrire pour stocker date-heure dernière exécution
  f := TMemIniFile.Create( txtIniFileName );
  with f do
  begin
    WriteString( txtIniSectionDB, txtIniKeyNom, Chp_DBNom.Text );
    WriteString( txtIniSectionTransfert, txtIniKeyHost, Chp_FTPHost.Text );
    WriteString( txtIniSectionTransfert, txtIniKeyPort, Chp_FTPPort.Text );
    WriteString( txtIniSectionTransfert, txtIniKeyUsername, Chp_FTPUsername.Text );
    WriteString( txtIniSectionTransfert, txtIniKeyPassword, DoCryptPass( Chp_FTPPassword.Text ));
    WriteString( txtIniSectionTransfert, txtIniKeyListen, Chp_FTPListenTimeout.Text );
    WriteString( txtIniSectionTransfert, txtIniKeyTransfert, Chp_FTPTransferTimeout.Text );
    WriteString( txtIniSectionTransfert, txtIniKeyLecture, Chp_FTPReadTimeout.Text );
    WriteString( txtIniSectionFichiers, txtIniKeyLocalEnvoyer, Edt_LocalEnvoyer.Text );
    WriteString( txtIniSectionFichiers, txtIniKeyLocalRecevoir, Edt_LocalRecevoir.Text );
    WriteString( txtIniSectionFichiers, txtIniKeyLocalArchiver, Edt_LocalArchiver.Text );
    WriteInteger( txtIniSectionFichiers, txtIniKeyLocalConserver, Upd_LocalConserver.Position );
    WriteString( txtIniSectionFichiers, txtIniKeyServeurEnvoyer, Edt_ServeurEnvoyer.Text );
    WriteString( txtIniSectionFichiers, txtIniKeyServeurRecevoir, Edt_ServeurRecevoir.Text );
    WriteString( txtIniSectionFichiers, txtIniKeyServeurArchiver, Edt_ServeurArchiver.Text );
    WriteString( txtIniSectionMel, txtIniKeyHost, Edt_MailSMTP.Text );
    WriteString( txtIniSectionMel, txtIniKeyPort, Edt_MailPort.Text );
    WriteString( txtIniSectionMel, txtIniKeyUsername, Edt_MailUsername.Text );
    WriteString( txtIniSectionMel, txtIniKeyPassword, DoCryptPass( Edt_MailPassword.Text ));
    WriteString( txtIniSectionMel, txtIniKeyFrom, Edt_MailFrom.Text );
    WriteString( txtIniSectionMel, txtIniKeyTo, Edt_MailTo.Text );
    WriteBool( txtIniSectionMel, txtIniKeySSL, Chk_MailSSL.Checked );
    WriteDateTime( txtIniSectionTraitement, txtIniKeyTimeStamp, Now );
    try
      UpdateFile;
    finally
      Free;
    end;
  end;
end;

// évènement IBT_Ginkoia.BeforeStart
procedure TFrm_Main.IBT_GinkoiaBeforeStart(Sender: TIB_Transaction);
begin
  // se connecter à la base
  ConnectDB;
end;

// évènement Que_xxx.BeforeOpen (évènement sur toutes requêtes pour ouverture BD et trace SQL)
procedure TFrm_Main.Que_BeforeOpen(DataSet: TDataSet);
var
  i: Integer;
begin
  // se connecter à la base
  ConnectDB;

  // ajouter texte requête dans le log des requêtes
  Mem_Requetes.Lines.Append(' - Début - ' + FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now()));

  Mem_Requetes.Lines.Append( TIBOQuery( Dataset ).SQL.Text ); // afficher requêtes SQL

  for i := 0 to TIBOQuery(DataSet).Params.Count - 1 do
    Mem_Requetes.Lines.Append(TIBOQuery(DataSet).Params[i].Name + '=' + TIBOQuery(DataSet).Params[i].AsString);
end;

procedure TFrm_Main.Que_BeforePrepare(Sender: TObject);
begin
  // se connecter à la base
  ConnectDB;
end;

procedure TFrm_Main.Que_MaitreAfterOpen(DataSet: TDataSet);
begin
  // ajouter texte requête dans le log des requêtes
  Mem_Requetes.Lines.Append(' - Fin - ' + FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now()));
end;

// évènement Chp_DBNom.OnChange
procedure TFrm_Main.Chp_DBNomChange(Sender: TObject);
begin
  // forcer déconnexion de la base
  IBC_Ginkoia.Disconnect;
end;

// bouton DBNom : dialogue de recherche de la BD
procedure TFrm_Main.Nbt_DBNomClick(Sender: TObject);
begin
  // demander nom fichier BD à l'utilisateur, l'afficher
  if OpDlg_DBNom.Execute then
  begin
    Chp_DBNom.Text := OpDlg_DBNom.Filename;
  end;
end;

// Bouton BDTest : test connexion BD
procedure TFrm_Main.Nbt_BDTestClick(Sender: TObject);
begin
  ClearLog;
  WriteLog( Format( txtLogTestConnexionBD, [ExtractFileName( Chp_DBNom.Text )] ));
  DisconnectDB;
  try
    ConnectDB;
    Que_GenParam.Open;
    WriteLog( FLogCurrent, txtLogTacheOK );
    MessageDlg( FLogMessage, mtInformation, [mbOK], 0 );
  except
    on E: Exception do
    begin
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      MessageDlg( FLogMessage, mtError, [mbOK], 0 );
    end;
  end;
end;

// Bouton FTPTest : test connexion FTP
procedure TFrm_Main.Nbt_FTPTestClick(Sender: TObject);
begin
  ClearLog;
  WriteLog( Format( txtLogTestConnexionFTP, [Chp_FTPHost.Text] ));
  DisconnectFTP;
  try
    ConnectFTP;
    DisconnectFTP;
    WriteLog( FLogCurrent, txtLogTacheOK );
    MessageDlg( FLogMessage, mtInformation, [mbOK], 0 );
  except
    on E: Exception do
    begin
      DisconnectFTP;
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      MessageDlg( FLogMessage, mtError, [mbOK], 0 );
    end;
  end;
end;

// Bouton SMTPTest : test connexion SMTP
procedure TFrm_Main.Nbt_SMTPTestClick(Sender: TObject);
begin
  ClearLog;
  WriteLog( Format( txtLogTestConnexionSMTP, [Edt_MailSMTP.Text] ));
  DisconnectSMTP;
  try
    ConnectSMTP;
    DisconnectSMTP;
    WriteLog( FLogCurrent, txtLogTacheOK );
    MessageDlg( FLogMessage, mtInformation, [mbOK], 0 );
  except
    on E: Exception do
    begin
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      MessageDlg( FLogMessage, mtError, [mbOK], 0 );
    end;
  end;
end;

// Bouton MailTest : envoi journal par mel
procedure TFrm_Main.Nbt_MailSendClick(Sender: TObject);
begin
  ClearLog;
  WriteLog( Format( txtLogTestEnvoiJournal, [Edt_MailTo.Text] ));
  try
    SendSMTPMail;
    DisconnectSMTP;
    WriteLog( FLogCurrent, txtLogTacheOK );
    MessageDlg( FLogMessage, mtInformation, [mbOK], 0 );
  except
    on E: Exception do
    begin
      DisconnectSMTP;
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      MessageDlg( FLogMessage, mtError, [mbOK], 0 );
    end;
  end;
end;

// Bouton LocalTest : test écriture dossiers locaux (FromGinkoia, FromStockIt, Archive)
procedure TFrm_Main.Nbt_LocalTestClick(Sender: TObject);
var
  n: TFileName;
  f: TFileStream;
begin
  ClearLog;
  WriteLog( txtLogTestLocaux );
  try
    n := GetFileName( LocalSendPathName, txtFichierTest );
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    f.Write( '', Length( '' ));
    FreeAndNil( f );
    DeleteFile( n );
    n := GetFileName( LocalReceivePathName, txtFichierTest );
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    f.Write( '', Length( '' ));
    FreeAndNil( f );
    DeleteFile( n );
    n := GetFileName( GetArchivesPathName( True, LocalReceivePathName ), txtFichierTest );
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    f.Write( '', Length( '' ));
    FreeAndNil( f );
    DeleteFile( n );
    WriteLog( FLogCurrent, txtLogTacheOK );
    MessageDlg( FlogMessage, mtInformation, [mbOK], 0 );
  except
    on E: Exception do
    begin
      FreeAndNil( f );
      DeleteFile( n );
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      MessageDlg( FLogMessage, mtError, [mbOK], 0 );
    end;
  end;
end;

// Bouton DistantTest : test envoi d'un fichier sur dossiers distants (FromGinkoia, FromStockIt, Archive)
procedure TFrm_Main.Nbt_DistantsTestClick(Sender: TObject);
var
  n: TFileName;
  f: TFileStream;
begin
  ClearLog;
  WriteLog( txtLogTestDistants );
  try
    // créer fichier test local
    n := GetFileName( LocalSendPathName, txtFichierTest );
    f := TFileStream.Create( n, fmCreate, fmShareExclusive );
    f.Write( '', Length( '' ));
    FreeAndNil( f );
    // s'assurer qu'on sera sur une nouvelle connexion FTP
    DisconnectFTP;
    // envoyer fichier sur dossier de réception FTP, déplacer dans archives, le supprimer
    SendFTPFile( n, DistantReceivePathName );
    MoveFTPFile( DistantReceivePathName + ExtractFileName( n ), GetArchivesPathName( False, DistantReceivePathName ));
    DeleteFTPFile( GetArchivesPathName( False, DistantReceivePathName ) + ExtractFileName( n ));
    // envoyer fichier sur dossier envoi FTP, déplacer dans archives, le supprimer
    SendFTPFile( n, DistantSendPathName );
    MoveFTPFile( DistantSendPathName + ExtractFileName( n ), GetArchivesPathName( False, DistantSendPathName ));
    DeleteFTPFile( GetArchivesPathName( False, DistantSendPathName ) + ExtractFileName( n ));
    // supprmier fichier local, écrire journal OK
    DeleteFile( n );
    WriteLog( FLogCurrent, txtLogTacheOK );
    MessageDlg( FlogMessage, mtInformation, [mbOK], 0 );
  except
    on E: Exception do
    begin
      FreeAndNil( f );
      DeleteFile( n );
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      MessageDlg( FLogMessage, mtError, [mbOK], 0 );
    end;
  end;
end;

// Bouton Type fichier
procedure TFrm_Main.Rgr_TraitementTypeClick(Sender: TObject);
begin
  // proposer options de traitement par défaut
  Chk_Export.Checked := True;
  Chk_Send.Checked := True;
  Chk_Receive.Checked := Rgr_TraitementType.ItemIndex = intTraitementMAJ;
  Chk_Import.Checked := Rgr_TraitementType.ItemIndex = intTraitementMAJ;
end;

// Bouton Traitement : Traitement principal
procedure TFrm_Main.Nbt_TraitementClick(Sender: TObject);
const
  iExport = 7;
  iSend = 7;
  iReceive = 1;
  iImport = 1;
var
  bExport, bSend, bReceive, bImport: Boolean;
  i: Integer;
  lMagId: TList;
  dInitialisation: TDateTime;
  iLastVersion, iCurrentVersion: Integer;
begin
  // initialiser journal et progression selon tâches à exécuter
  ClearLog;
  FEnvoyerCourriel := False;

  WriteLog( txtLogTraitementDebut );
  // interdire exécution si backup en cours
  if MapGinkoia.Backup then
  begin
    WriteLog( txtLogTraitementErreurBackup );
    Exit;
  end;
  // curseur en attente
  Screen.Cursor := crSQLWait;
  // déterminer taches pour durée estimée selon options cochées
  bExport := Chk_Export.Checked;
  bSend := Chk_Send.Checked;
  bReceive := Chk_Receive.Checked;
  bImport := Chk_Import.Checked;
//  Frm_Progression.InitialiserTraitement( Ord( bExport ) * iExport + Ord( bSend ) * iSend + Ord( bReceive ) * iReceive + Ord( bImport ) * iImport );
  // signaler réplication en cours
  MapGinkoia.Launcher := True;
  // liste des ID magasins en paramètres
  lMagId := TList.Create;
  // lancer traitement (toute tache en erreur génère une exception -> fin traitement)
  try
    // si export ou import, initialisation
    if bExport or bImport then
    begin
      // lire paramètres (DateInitialisation, LastVersion, CurrentVersion et liste des MAGID)
      dInitialisation := StrToInt( GetDBParamValue( intParamInitialisation, 'PRM_INTEGER' ));
      iLastVersion := StrToInt( GetDBParamValue( intParamLastVersion, 'PRM_INTEGER' ));
      iCurrentVersion := GetDBVersion( True );
      GetDBParamValues( lMagId, intParamMagasins, 'PRM_MAGID' );
      // transaction en BD (après lecture des paramètres pour ne pas inclure GetDBCurrentVersion)
      IBT_Ginkoia.StartTransaction;
      // si date initialisation est 0 ou si initialisation explicitement demandée, forcer traitement initialisation
      if ( dInitialisation = 0 ) or ( Rgr_TraitementType.ItemIndex = intTraitementInit ) then
      begin
        WriteLog( txtLogTraitementDebut, txtLogTraitementDebutInit );
        dInitialisation := DateOf( Date );     // initialisation ce jour
        iLastVersion := GetDBVersion( False ); // forcer export pour toutes versions (commencer en début de plage)
        for i := 0 to lMagId.Count - 1 do      // forcer export image stock pour tous les magasins en paramètres 18
        begin
          SetDBParamValue( intParamMagasins, 'PRM_INTEGER', 1, Integer( lMagId[i] ));
        end;
      end else
      // si date initialisation indiquée, traitement est MAJ courante
      begin
        WriteLog( txtLogTraitementDebut, txtLogTraitementDebutMAJ );
      end;
      WriteLog( Format( txtLogTraitementReadLastVersion, [iLastVersion] ));
      WriteLog( Format( txtLogTraitementReadCurrentVersion, [iCurrentVersion] ));
      WriteLog( Format( txtLogTraitementReadDateInit, [FormatDateTime( 'dd/mm/yyyy', dInitialisation )] ));
    end else
    // ni export ni import, considérer qu'il s'agit d'un test
    begin
      WriteLog( txtLogTraitementDebut, txtLogTraitementDebutTest );
    end;
    // exporter toutes données selon paramètres et type traitement (Initialisation ou Mise à jour)
    if bExport then
    begin
      ExporterMagasins;
      Application.ProcessMessages();
      ExporterArticles( iLastVersion, iCurrentVersion );
      Application.ProcessMessages();
      ExporterStock( lMagId );
      Application.ProcessMessages();
      if iLastVersion > 0 then
      begin
        ExporterStockIO( lMagId, dInitialisation, iLastVersion, iCurrentVersion, True );
        Application.ProcessMessages();
        ExporterStockIO( lMagId, dInitialisation, iLastVersion, iCurrentVersion, False );
        Application.ProcessMessages();
        ExporterTransferts( iLastVersion, iCurrentVersion );
        Application.ProcessMessages();
        ExporterMouvements( 1 );
        Application.ProcessMessages();
      end;
    end;
    // envoyer fichiers sur serveur distant et déplacer dans dossier archivés
    if bSend then
    begin
      EnvoyerFichiers;
      Application.ProcessMessages();
      ArchiverFichiers( LocalSendPathName );
      Application.ProcessMessages();
    end;
    // réceptionner fichiers depuis serveur FTP (si MAJ)
    if bReceive then
    begin
      if ( dInitialisation <> 0 ) or ( Rgr_TraitementType.ItemIndex = intTraitementMAJ ) then
      begin
        RecevoirFichiers;
        Application.ProcessMessages();
      end;
    end;
    // importer fichiers depuis dossier de réception et déplacer dans dossier archivés (si MAJ)
    if bImport then
    begin
      if ( dInitialisation <> 0 ) or ( Rgr_TraitementType.ItemIndex = intTraitementMAJ ) then
      begin
        ImporterTransferts;
        Application.ProcessMessages();
        ArchiverFichiers( LocalReceivePathName );
        Application.ProcessMessages();
      end;
    end;
    // tout est OK, enregistrer les paramètres et valider transaction
    if bExport or bImport then
    begin
      if ( Rgr_TraitementType.ItemIndex = intTraitementInit ) then
      begin
        WriteLog( Format( txtLogTraitementWriteDateInit, [DateToStr( dInitialisation )] ));
        SetDBParamValue( intParamInitialisation, 'PRM_INTEGER', Trunc( dInitialisation ));
      end;
      iLastVersion := GetDBLastVersion;
      WriteLog( Format( txtLogTraitementWriteLastVersion, [iLastVersion] ));
      SetDBParamValue( intParamLastVersion, 'PRM_INTEGER', iLastVersion );
      for i := 0 to lMagId.Count - 1 do
      begin
        SetDBParamValue( intParamMagasins, 'PRM_INTEGER', 0, Integer( lMagId[i] ));
      end;
      IBT_Ginkoia.Commit;
    end;
    // supprimer anciens fichiers
    SupprimerFichiers;
    Application.ProcessMessages();
    // écrire journal fin traitement OK
    WriteLog( txtLogTraitementTermineOK );
  // en cas de problème...
  except
    on E: Exception do
    begin
      // annuler la transaction
      if bExport or bImport then
      begin
        IBT_Ginkoia.RollBack;
      end;
      // indiquer erreur dans la ligne du journal en cours et journal fin traitement en erreur
      WriteLog( FLogCurrent, Format( txtLogErreur, [E.Message] ));
      WriteLog( txtLogTraitementTermineErreur );
      // envoyer journal par mél (NB : SendSMTPMail ne déclenche jamais d'exception -> permettre au traitement de continuer ensuite)
      FEnvoyerCourriel := True;
    end;
  end;

  // Si il y a eu un problème : envoyer un courriel
  if FEnvoyerCourriel then
      SendSMTPMail();

  // signaler fin réplication en cours
  MapGinkoia.Launcher := False;
  // libérer ressources, fermer connexions, terminer progression
  lMagId.Free;
  DisconnectFTP;
  DisconnectSMTP;
  // curseur par défaut
  Screen.Cursor := crDefault;
//  Frm_Progression.Hide;
end;

// Bouton quitter : ferme l'application
procedure TFrm_Main.Nbt_QuitterClick(Sender: TObject);
begin
  DisconnectDB;
  Close;
end;

end.

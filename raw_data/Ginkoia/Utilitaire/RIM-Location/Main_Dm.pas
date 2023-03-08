//$Log:
// 6    Utilitaires1.5         22/01/2016 16:57:35    Lionel Plais    Source
//      pour la version 1.0.2.35.
// 5    Utilitaires1.4         14/01/2016 09:57:48    Lionel Plais    Version
//      1.0.2.30?: Correction de l'int?gration des dates de r?servation.
// 4    Utilitaires1.3         07/01/2016 16:36:57    Lionel Plais    Version
//      1.0.2.28?: Mantis 1324?:
//       - Retirer les espaces devant les noms et pr?noms des clients,
//       - Param?trer les d?lais entre les r?essais des connexions aux bo?tes
//      de messageries dans le fichier INI,
//       - Journaliser les erreurs de connexions aux serveurs de messageries.
// 3    Utilitaires1.2         22/12/2015 11:34:48    Lionel Plais    Version
//      1.0.2.26?: Mantis 1291?:
//       - Modification du message d'erreur de connexion au serveur de
//      messagerie.
//       - Le programme tente par trois fois, avec un intervalle de deux
//      secondes, pour se connecter au serveur avant d'afficher le message
//      d'erreur.
// 2    Utilitaires1.1         23/10/2013 12:39:14    Lionel Plais    Ajoute
//      l'annulation de l'accompte client lors de l'annulation d'une
//      r?servation.
// 1    Utilitaires1.0         07/12/2012 12:56:53    soustraitant    
//$
//$NoKeywords$
//
//------------------------------------------------------------------------------
// Nom de l'unité : Main_Dm
// Rôle           : Gestion des accés à une base de donnée Interbase
// Auteur         : Sylvain GHEROLD
// Historique     :
// 15/05/2001 - Hervé Pulluard  - v 5.0.2 : Gestion des Sur-transactions
// 13/03/2001 - Sylvain GHEROLD - v 5.0.1 : Modif condition AllowEdit/AllowDelete
// 07/03/2001 - Hervé Pulluard  - v 5.0.0 : Chemin de la base dans INI Prgm
// 24/01/2001 - Sylvain GHEROLD - v 4.0.2 : Param. de la base en f° ligne cmde
// 18/01/2001 - Sylvain GHEROLD - v 4.0.1 : Modif CheckIntegrity pour Arbre
// 26/12/2000 - Sylvain GHEROLD - v 4.0.0 : Séparation en 3 Dm (Main,Rap,Uil)
// 15/12/2000 - Sylvain GHEROLD - v 3.1.6 : modif gestion script avec RPM
// 14/12/2000 - Sylvain GHEROLD - v 3.1.5 : modif UIL avec RPM
// 11/12/2000 - Sylvain GHEROLD - v 3.1.4 : ajout gestion paramètre RAP+CrossTab
// 21/11/2000 - Sandrine MEDEIROS - v 3.1.3 : ajout RollBackUser
// 16/11/2000 - Sylvain GHEROLD - v 3.1.2 : modif K pour utilisation triggers
// 12/10/2000 - Sylvain GHEROLD - v 3.1.1 : ajout UdpPending + chg nom fonction
// 22/09/2000 - Sylvain GHEROLD - v 3.1.0 : ajt gestion script + gestion erreur
// 10/08/2000 - Sylvain GHEROLD - v 3.0.0 : version CU + IBO
// 19/06/2000 - Sylvain GHEROLD - v 2.0.0 : version IBO
// 05/07/2000 - Sylvain GHEROLD - v 2.1.0 : intégration RAP + UIL
//------------------------------------------------------------------------------
//

unit Main_Dm;

interface

uses
  Windows,
  messages,
  ShellApi,
  Controls,
  inifiles,
  Dialogs,
  Classes,
  SysUtils,
  Forms,
  Db,
  FileCtrl,
  IB_Components,
  IB_Session,
  IB_SessionProps,
  IB_Dialogs,
  IB_StoredProc,
  IBODataset,
  IB_Process,
  IB_Script,
//  IB_Access,
  Variants ;
type
  TObjetValidation = class
    Nom: string;
    Proc: TIB_StoredProc;
    constructor Create(LeNom: string);
    destructor Destroy; override;
    procedure execute;
  end;

  TObjetTableFields = class
    PkKFLD_NAME: string;
    PkKTB_ID: string;
    LaListe: TstringList;
    function GetKFLD_NAME(Index: Integer): string;
    function GetKKW_NAME(Index: Integer): string;
    constructor Create;
    destructor Destroy; override;
    property KFLD_NAME[Index: integer]: string read GetKFLD_NAME;
    property KKW_NAME[Index: integer]: string read GetKKW_NAME;
  end;

  TDm_Main = class(TDataModule)
    Database: TIB_Connection;
    IbT_Maj: TIB_Transaction;
    IbT_Select: TIB_Transaction;
    Monitor: TIB_MonitorDialog;
    IbStProc_NewKey: TIB_StoredProc;
    IbStProc_NewVerKey: TIB_StoredProc;
    IbQ_TableField: TIB_Query;
    IbQ_TablePkKey: TIB_Query;
    IbQ_FieldFkField: TIB_Query;
    IbC_InsertK: TIB_Cursor;
    IbC_UpDateK: TIB_Cursor;
    IbC_DeleteK: TIB_Cursor;
    IbC_Integritychk: TIB_Cursor;
    IbC_MajCu: TIB_Cursor;
    IbC_Script: TIB_Cursor;
    IbT_Lk: TIB_Transaction;
    IbT_MajLk: TIB_Transaction;
    IbC_InsertKLK: TIB_Cursor;
    IbC_UpdateKLK: TIB_Cursor;
    IbC_DeleteKLK: TIB_Cursor;
    IbC_MajCuLK: TIB_Cursor;
    IbC_ScriptLk: TIB_Cursor;
    IbT_HorsK: TIB_Transaction;
    IbC_CorPxVente: TIB_Cursor;
    IbQ_VerifEuro: TIB_Query;
    IbC_PassageEuro: TIB_Cursor;
    IBS_Creation: TIB_Script;
    SessionProps: TIB_SessionProps;
    procedure DataModuleDestroy(Sender: TObject);
    procedure IbC_MajCuError(Sender: TObject; const ERRCODE: Integer;
      ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
      SQLMessage, SQL: TStringList; var RaiseException: Boolean);

  private
    FVideCache: Boolean;
    FVersionSys: integer;
    FKActive: Boolean;
    FTransactionCount: Integer;
    FTransactionCountLk: Integer;

    LesObjets: TStringlist;
    LesTableFields: TStringList;
    tsl_Help: Tstringlist;
    HelpDesign: boolean;
    HelpInit: Boolean;
    function TrouveTablesFields(TableName: string): TObjetTableFields;
    function TrouveObjetValidation(TableName: string; DataSet: TIBODataSet): TObjetValidation;

    procedure Initialize;
    procedure GetTableFields(TableName: string);

    procedure IBOCacheUpdateI(TableName: string; DataSet: TIBODataSet);
    procedure IBOCacheUpdateU(TableName: string; DataSet: TIBODataSet);
    procedure IBOCacheUpdateD(TableName: string; DataSet: TIBODataSet);

    procedure IB_CacheUpdateI(TableName: string; DataSet: TIB_BDataSet);
    procedure IB_CacheUpdateU(TableName: string; DataSet: TIB_BDataSet);
    procedure IB_CacheUpdateD(TableName: string; DataSet: TIB_BDataSet);

    procedure InsertK(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: string);
    procedure UpdateK(K_ID, KSE_Update: string);
    procedure DeleteK(K_ID, KSE_Delete: string);

    procedure InsertKLk(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: string);
    procedure UpdateKLk(K_ID, KSE_Update: string);
    procedure DeleteKLk(K_ID, KSE_Delete: string);

    procedure ErrorGestionnaire(Sender: TObject; E: Exception);

  public

    Ferror : string ;
  
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure StartTransaction;
    procedure StartTransactionLk;
    procedure StartSurTransaction;
    procedure Commit;
    procedure CommitLk;
    procedure CommitUSER;
    procedure Rollback;
    procedure RollbackLk;
    procedure RollbackUser;
    procedure ControlCache(DataSet: TIBODataSet);

    function GenID: string;
    function GenVersion: string;

    function IBOMajPkKey(DataSet: TIBODataSet; LeChamp: string): Boolean;
    function IBOUpdPending(DataSet: TIBODataSet): boolean;
    procedure IBOCancelCache(DataSet: TIBOQuery);
    procedure IBOCommitCache(DataSet: TIBOQuery);
    procedure IBOUpDateCache(DataSet: TIBOQuery);

    function IB_MajPkKey(DataSet: TIB_BDataSet; LeChamp: string): Boolean;
    function IB_UpdPending(DataSet: TIB_BDataSet): Boolean;
    procedure IB_CancelCache(DataSet: TIB_BDataSet);
    procedure IB_CommitCache(DataSet: TIB_BDataSet);
    procedure IB_UpDateCache(DataSet: TIB_BDataSet);

    procedure IBOUpdateRecord(TableName: string; DataSet: TIBODataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);

    procedure IB_UpdateRecord(TableName: string; DataSet: TIB_BDataSet;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);

    procedure SetVersionSys(Version: Integer);
    procedure DesableKManagement;
    function IsKManagementActive: Boolean;

    procedure SetNewGeneratorKey(ProcName: string);
    procedure SetNewGeneratorVerKey(ProcName: string);

    procedure ShowMonitor;

    procedure PrepareScript(SQL: string);
    procedure PrepareScriptLk(SQL: string);
    procedure PrepareScriptMultiKUpDate(SQL: string);
    procedure PrepareScriptMultiKUpDateLk(SQL: string);
    procedure PrepareScriptMultiKDelete(SQL: string);
    procedure PrepareScriptMultiKDeleteLk(SQL: string);

    procedure SetScriptParameterValue(ParamName, ParamValue: string);
    procedure SetScriptParameterValueLk(ParamName, ParamValue: string);
    procedure ExecuteScript;
    procedure ExecuteScriptLk;
    procedure ExecuteInsertK(TableName, KeyValue: string);
    procedure ExecuteInsertKLk(TableName, KeyValue: string);

    function CheckAllowDelete(TableName, KeyValue: string;
      ShowErrorMessage: Boolean): Boolean;
    function CheckAllowEdit(TableName, KeyValue: string;
      ShowErrorMessage: Boolean): boolean;

    function TransactionUpdPending: boolean;
    function TransactionUpdPendingLk: boolean;

    function CheckOneIntegrity(LkUpTableName, LkPkFieldName, LkUpFieldName,
      KeyValue: string; ShowErrorMessage: Boolean): Boolean;

    function CheckKeyExist(LkUpTableName, LkPkFieldName,
      LkUpFieldName, KeyValue: string; ShowErrorMessage: Boolean): Boolean;


    // pour ouvrir la base à partir du module location
    function InitDatabase(sDatabase, sUser, sPassword : string) : boolean ;
      
  end;

var
  Dm_Main: TDm_Main;
  Error_Piccolink: string;

procedure EnregistrerLog(AInfo: string);

implementation
uses
  GinkoiaResStr,
  StdUtils ;

{$R *.DFM}

var
  NomExecutable    : string;
  VersionProg      : string;
  RepertoireDesLog : string;

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------     

function ApplicationVersion: String;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  Version: string;
  d: TDateTime;
  AgeExe: string;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize <> 0 then   // Les info de version sont inclues
  begin
    // On alloue de la mémoire pour un pointeur sur les info de version
    GetMem(VerInfo, VerInfoSize);
    // On récupère ces informations :
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    // On traite les informations ainsi récupérées
    with VerValue^ do
    begin
      Version := IntTostr(dwFileVersionMS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Version := Version + '.' + IntTostr(dwFileVersionLS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;
    // On libère la place précédemment allouée
    FreeMem(VerInfo, VerInfoSize);
  end
  else
    Version:='0.0.0.0 ';

  d:=  FileDateToDateTime(FileAge(ParamStr(0)));
  AgeExe := ' du '+FormatDateTime('dd/mm/yyyy',d);
  result := Version+AgeExe;
end;

procedure EnregistrerLog(AInfo: string);
var
  AFilename: string;
  sLigne: string;
  Stream: TFileStream;
begin
  AFilename := RepertoireDesLog+'LOG_'+NomExecutable+'-'+FormatDateTime('yyyy-mm-dd',Date)+'.txt';
  sLigne := '['+VersionProg+'] ['+FormatDateTime('dd/mm/yyyy hh:nn:ss',now)+']: '+AInfo+#13#10;
  Stream := nil;
  try
    if FileExists(AFileName) then
    begin
      Stream := TFileStream.Create(AFileName, fmOpenWrite);
      Stream.Seek(0, soFromEnd);
    end
    else    
      Stream := TFileStream.Create(AFileName, fmCreate);
    Stream.Write(Pointer(sLigne)^, Length(sLigne));
  except
  end;
  if assigned(Stream) then
  begin
    Stream.Free;
    Stream := nil;
  end;
end;

procedure InitialisationDesLog;
var
  sl: TStringList;
  i, resu: integer;
  Search: TSearchRec;
  s: string;
begin
  Error_Piccolink := '';
  NomExecutable    := ExtractFileName(ParamStr(0));
  NomExecutable    := Copy(NomExecutable,1,Length(NomExecutable)-Length(ExtractFileExt(NomExecutable)));
  VersionProg      := ApplicationVersion;
  RepertoireDesLog := ExtractFilePath(ParamStr(0));
  if RepertoireDesLog[Length(RepertoireDesLog)]<>'\' then
    RepertoireDesLog := RepertoireDesLog+'\';
  RepertoireDesLog := RepertoireDesLog+'LOG_'+NomExecutable+'\';
  ForceDirectories(RepertoireDesLog);

  // supprime les log de plus de 60 jours
  sl := TStringList.Create;
  try  
    resu := FindFirst(RepertoireDesLog+'LOG_*.*', faAnyFile, Search);
    while (resu=0) do
    begin
      s := ExtractFileName(Search.Name);
      if (s<>'.') and (s<>'..') and ((Search.Attr and faDirectory)<>faDirectory) then
      begin
        try
          if Trunc(FileDateToDateTime(FileAge(RepertoireDesLog+s)))<Trunc(Date)-60 then
            sl.Add(RepertoireDesLog+s);
        except
        end;
      end;
      resu := FindNext(Search);
    end;
    FindClose(Search);
    for i:=1 to sl.Count do
      DeleteFile(sl[i-1]);
  finally
    sl.Free;
    sl := nil;
  end;
  
  EnregistrerLog('Démarrage du programme');
end;

constructor TDm_Main.Create(AOwner: TComponent);
begin
  inherited;
  Application.OnException := ErrorGestionnaire;
  Initialize;
  LesObjets := TStringlist.Create;
  LesTableFields := TStringlist.Create;
end;

destructor TDm_Main.Destroy;
var
  i: integer;
begin
  for i := 0 to LesObjets.Count - 1 do
    TObjetValidation(LesObjets.Objects[i]).free;
  LesObjets.Free;

  for i := 0 to LesTableFields.Count - 1 do
    TObjetTableFields(LesTableFields.Objects[i]).Free;
  LesTableFields.Free;

  inherited;
end;

procedure TDm_Main.Initialize;
begin
  FTransactionCount := 0;
  FTransactionCountLk := 0;
  // Désactivation du mode Système
  SetVersionSys(0);
 // Active le fonctionnement de K
  FKActive := True;  
end;




function Tdm_Main.InitDatabase(sDatabase, sUser, sPassword : string) : boolean ;
begin
 database.DatabaseName := sDatabase ;
 Database.Params.Values['user_name'] := sUser;
 Database.Params.Values['password'] := sPassword;
 Try
  Database.Open ;
 Except
  On E: Exception do
   begin
     Ferror := E.Message ;
   end;
 End;
 result := database.Connected ;
end;



// GESTIONNAIRE D'EXCEPTIONS

procedure TDm_Main.ErrorGestionnaire(Sender: TObject; E: Exception);
var
  NErreur: DWord;
  sTmp: string;
begin
  // log des erreurs
  NErreur := 0;
  try
    NErreur := GetLastError;
  except
  end;
  sTmp :='GetLasterror = '+inttostr(NErreur);
  if Error_Piccolink<>'' then
    sTmp := sTmp+' ; Picco Erreur = '+Error_Piccolink;
  sTmp := sTmp+': '+E.Message;
  EnregistrerLog(sTmp);

  // Evitons les messages d'erreurs qui provoquent des erreurs !
  if not (CsDestroying in Application.ComponentState) then
    Showmessage(E.message);
end;

// GESTION DES TRANSACTIONS

procedure TDm_Main.StartTransaction;
begin
  if FTransactionCount = 0 then
  begin
    IbT_Maj.StartTransaction;
  end;
  Inc(FTransactionCount);
end;

procedure TDm_Main.StartTransactionLK;
begin
  if FTransactionCountLk = 0 then
  begin
    IbT_MajLk.StartTransaction;
  end;
  Inc(FTransactionCountLk);
end;

procedure TDm_Main.StartSurTransaction;
begin
  if FTransactionCount <> 0 then Exit;
  // --------- > y'a que ça de plus à une transac classique
  if FTransactionCount = 0 then
  begin
    IbT_Maj.StartTransaction;
  end;
  Inc(FTransactionCount);

  { Hervé's Comment :
    Dans notre modus oprendi de modules comme gestion des tailles et des couleurs
    l'utilisateur peut appeler plusieurs fois ces modules dans la même session
    de travail sur une fiche ( c'est à dire avabt d'avoir validé ou abandonné )
    Le principe c'est de n'ouvrir qu'une seule "sur-transaction".
    Deux solutions :
    1. On agit dans le module maître au moment de la mise en édition ou de l'insertion
       mais dans ce cas on a toujours une surtransaction ouverte
    2. On agit dans les modules enfants auquel cas la surtransaction ne doit être
       ouverte qu'une seule fois.
       Je préfère cette méthode car elle permet de garder la gestion des transactions
       toujours au même endroit à savoir la gestion du cache.
    C'est l'objet de cette procédure qu'y n'ouvre une transaction que si le compteur
    est à 0 ce qui correspond bien à la sur-transaction de départ !
    Cette façon de faire permet en plus de ne rien changer d'autre au code habituel
    de la gestion de nos procédures de mise à jour de cache...
  }
end;

procedure TDm_Main.ControlCache(DataSet: TIBODataSet);
begin
  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    if FTransactionCount = 0 then
      if Dataset.UpdatesPending then Dataset.CancelUpdates;
  end;
  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    if FTransactionCountLk = 0 then
      if Dataset.UpdatesPending then Dataset.CancelUpdates;
  end;

  { Hervé's Comment :
    L'avantage avec les IBO c'est que le cache n'est pas détruit même après un close
    de la query. Cela facilte énormément le travail car sinon il faudrait toujours
    avoir les requêtes ouvertes jusqu'au commit de la transaction globale.
    Avec cette manière de faire les requêtes peuvent être fermées et si on revient
    dans le module avant la validation finale l'affichage des données reflête bien
    l'état actuel désiré puisqu'il s'appuie sur justement le cache.
    Cela induit cependant un effet de bord : Puisque nos Dm par la force des choses
    ne doivent pas être détruits car sinon le cache l'est avec et on perd tout le
    bénéfice... lorsqu'on revient après mise à jour de la transaction globale
    le cache reste toujours dans l'état si l'utilisateur n'a pas changé d'article.
    Dans les cas de validation cela ne pose aucun problème c'est bien les données
    logiques mais parcontre après un cancel global du maiître si les données sur
    le serveur sont bien propres ce n'est hélas plus le cas de l'affichage.
    La solution pour concilier les deux est simple.
    Dan les modules enfant, avant l'ouverture des tables concernées par des mises à
    jour de données il suffit d'appeler cette procédure.
    Si le compteur de transaction est à 0, on est dans un contexte de nouvelle
    transaction à venir, il faut donc vider le cache. Dans tous les autres cas
    rien ne se passe et le cache est préservé
  }
end;

procedure TDm_Main.Commit;
begin
  Dec(FTransactionCount);
  if FTransactionCount = 0 then
  begin
    try
      IbT_Maj.Commit;
    except
      Inc(FTransactionCount);
      raise Exception.Create(ErrBD); // Erreur grave !
    end;
  end
  else if FTransactionCount < 0 then
  begin
    IbT_Maj.RollBack;
    FTransactionCount := 0;
    Showmessage(ErrNegativeTransac);
    // le compteur ne doit jamais passer à 0 car sinon cela fout le
    // bordel dans toute l'application. Cela ne devrait jamais se
    // produire sauf si erreur de codage ... d'où la nécessité de ce
    // message d'erreur pour nous prévenir ...
  end;

end;

procedure TDm_Main.CommitLk;
begin
  Dec(FTransactionCountLk);
  if FTransactionCountLk = 0 then
  begin
    try
      IbT_MajLk.Commit;
    except
      Inc(FTransactionCountLk);
      raise Exception.Create(ErrBD); // Erreur grave !
    end;
  end
  else if FTransactionCountLk < 0 then
  begin
    IbT_MajLk.RollBack;
    FTransactionCountLk := 0;
    Showmessage(ErrNegativeTransac);
    // le compteur ne doit jamais passer à 0 car sinon cela fout le
    // bordel dans toute l'application. Cela ne devrait jamais se
    // produire sauf si erreur de codage ... d'où la nécessité de ce
    // message d'erreur pour nous prévenir ...
  end;

end;

procedure TDm_Main.Rollback;
begin
  Dec(FTransactionCount);
  if FTransactionCount = 0 then
  begin
    try
      IbT_Maj.Rollback;
      Showmessage(ErrMajDB);
    except
      Inc(FTransactionCount);
      raise Exception.Create(ErrBD); // Erreur grave !
    end;
  end
  else if FTransactionCount < 0 then
  begin
    IbT_Maj.Rollback;
    FtransactionCount := 0;
    Showmessage(ErrNegativeTransac);
    // le compteur ne doit jamais passer à 0 car sinon cela fout le
    // bordel dans toute l'application. Cela ne devrait jamais se
    // produire sauf si erreur de codage ... d'où la nécessité de ce
    // message d'erreur pour nous prévenir ...
  end;

end;

procedure TDm_Main.RollbackLk;
begin
  Dec(FTransactionCountLk);
  if FTransactionCountLk = 0 then
  begin
    try
      IbT_MajLk.Rollback;
      Showmessage(ErrMajDB);
    except
      Inc(FTransactionCountLk);
      raise Exception.Create(ErrBD); // Erreur grave !
    end;
  end
  else if FTransactionCountLk < 0 then
  begin
    IbT_MajLk.Rollback;
    FtransactionCountLk := 0;
    Showmessage(ErrNegativeTransac);
    // le compteur ne doit jamais passer à 0 car sinon cela fout le
    // bordel dans toute l'application. Cela ne devrait jamais se
    // produire sauf si erreur de codage ... d'où la nécessité de ce
    // message d'erreur pour nous prévenir ...
  end;

end;

// idem PROCEDURE TDm_Main.Rollback mais sans le message d'erreur

procedure TDm_Main.RollbackUser;
begin
  if FTransactionCount = 1 then
  begin
    Dec(FTransactionCount);
    if FTransactionCount = 0 then
    try
      IbT_Maj.Rollback;
    except
      Inc(FTransactionCount);
      raise Exception.Create(ErrBD); // Erreur grave !
    end;
  end
  else if FTransactionCount > 1 then
  begin
    IbT_Maj.Rollback;
    FtransactionCount := 0;
    showmessage(ErrToMuchTransac);
  end;

  { Hervé's Comment : dans le maître, lorsque sa propre mise à jour du cache
    est terminé, si sur_transaction il y a eu il faut la terminer pour que le
    serveur soit validé. Dans ce contexte il faut donc à  la fin appeler
    RollbackUser qui si une sur-transaction est active (compteur à 1)
    fait le boulot. Si aucune sur-transaction le compteur est à "0" il ne se passe
    rien.
    Si ici transaction est > 1 c'est qu'il y a un problème de code il faut le
    signaler ...
  }
end;

procedure TDm_Main.CommitUSER;
begin

  if FTransactionCount = 1 then
  begin
    Dec(FTransactionCount);
    if FTransactionCount = 0 then
    try
      IbT_Maj.Commit;
    except
      inc(FTransactionCount);
      raise Exception.Create(ErrBD); // Erreur grave !
    end;
  end
  else if FTransactionCount > 1 then
  begin
    IbT_Maj.Rollback;
    FtransactionCount := 0;
    Inc(FTransactionCount);
    showmessage(ErrToMuchTransac);
  end;

  { Hervé's Comment : dans le maître, lorsque sa propre mise à jour du cache
    est terminé, si sur_transaction il y a eu il faut la terminer pour que le
    serveur soit validé. Dans ce contexte il faut donc à  la fin appeler
    CommitUser qui si une sur-transaction est active (compteur à 1)
    fait le boulot. Si aucune sur-transaction le compteur est à "0" il ne se passe
    rien.
    Si ici transaction est > 1 c'est qu'il y a un problème de code il faut le
    signaler ...
  }

end;

// GESTION DES GENERATORS

function TDm_Main.GenID: string;
begin
  IbStProc_NewKey.Close;
  IbStProc_NewKey.Prepared := True;
  IbStProc_NewKey.ExecProc;
  result := IbStProc_NewKey.Fields[0].AsString;
  IbStProc_NewKey.Close;
  IbStProc_NewKey.Unprepare;
end;

function TDm_Main.GenVersion: string;
begin
  IbStProc_NewVerKey.Close;
  IbStProc_NewVerKey.Prepared := true;
  IbStProc_NewVerKey.ExecProc;
  result := IbStProc_NewVerKey.Fields[0].AsString;
  IbStProc_NewVerKey.Close;
  IbStProc_NewVerKey.Unprepare;
end;

function TDm_Main.IBOMajPkKey(DataSet: TIBODataSet; LeChamp: string):
  Boolean;
// Alimentation de la cle primaire d'un DataSet
begin
  Result := True;
  try
    DataSet.FieldByName(LeChamp).AsString := GenID;
  except
    Showmessage(ErrGenId);
    DataSet.Cancel;
    Result := False;
  end;
end;

function TDm_Main.IB_MajPkKey(DataSet: TIB_BDataSet; LeChamp: string):
  Boolean;
// Alimentation de la cle primaire d'un DataSet
begin
  Result := True;
  try
    DataSet.FieldByName(LeChamp).AsString := GenID;
  except
    Showmessage(ErrGenId);
    DataSet.Cancel;
    Result := False;
  end;
end;

// GESTION DES MISES A JOUR DU CACHE

procedure TDm_Main.IBOCancelCache(DataSet: TIBOQuery);
begin
  if DataSet.Active then
    DataSet.CancelUpdates;
end;

procedure TDm_Main.IBOCommitCache(DataSet: TIBOQuery);
begin
  if not DataSet.Active then Exit;

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    if DataSet.Active and (FTransactionCount = 0) then
    begin
      FVideCache := True;
      DataSet.ApplyUpdates;
      DataSet.CommitUpdates;
    end;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    if DataSet.Active and (FTransactionCountLk = 0) then
    begin
      FVideCache := True;
      DataSet.ApplyUpdates;
      DataSet.CommitUpdates;
    end;
  end;

end;

procedure TDm_Main.IBOUpDateCache(DataSet: TIBOQuery);
begin
  if not DataSet.Active then Exit;

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    if DataSet.Active then
    begin
      try
        Dm_Main.StartTransaction;
        FVideCache := False;
        DataSet.ApplyUpdates;
        Dm_Main.Commit;
      except
        Dm_Main.Rollback;
        Dm_Main.IBOCancelCache(DataSet);
        if (FTransactionCount <> 0) then raise;
      end;
      Dm_Main.IBOCommitCache(DataSet);
    end;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    if DataSet.Active then
    begin
      try
        Dm_Main.StartTransactionLk;
        FVideCache := False;
        DataSet.ApplyUpdates;
        Dm_Main.CommitLk;
      except
        Dm_Main.RollbackLk;
        Dm_Main.IBOCancelCache(DataSet);
        if (FTransactionCountLk <> 0) then raise;
      end;
      Dm_Main.IBOCommitCache(DataSet);
    end;
  end;

end;

procedure TDm_Main.IB_CancelCache(DataSet: TIB_BDataSet);
begin
  if DataSet.Active then
    DataSet.CancelUpdates;
end;

procedure TDm_Main.IB_CommitCache(DataSet: TIB_BDataSet);
begin
  if not DataSet.Active then Exit;

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    if DataSet.Active and (FTransactionCount = 0) then
    begin
      FVideCache := True;
      DataSet.ApplyUpdates;
      DataSet.CommitUpdates;
    end;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    if DataSet.Active and (FTransactionCountLk = 0) then
    begin
      FVideCache := True;
      DataSet.ApplyUpdates;
      DataSet.CommitUpdates;
    end;
  end;

end;

procedure TDm_Main.IB_UpDateCache(DataSet: TIB_BDataSet);
begin
  if not DataSet.Active then Exit;

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    if DataSet.Active then
    begin
      try
        Dm_Main.StartTransaction;
        FVideCache := False;
        DataSet.ApplyUpdates;
        Dm_Main.Commit;
      except
        Dm_Main.Rollback;
        Dm_Main.IB_CancelCache(DataSet);
        if (FTransactionCount <> 0) then raise;
      end;
      Dm_Main.IB_CommitCache(DataSet);
    end;
  end;

  if Dataset.IB_Transaction = Ibt_lk then
  begin
    if DataSet.Active then
    begin
      try
        Dm_Main.StartTransactionLk;
        FVideCache := False;
        DataSet.ApplyUpdates;
        Dm_Main.Commit;
      except
        Dm_Main.RollbackLk;
        Dm_Main.IB_CancelCache(DataSet);
        if (FTransactionCountLk <> 0) then raise;
      end;
      Dm_Main.IB_CommitCache(DataSet);
    end;
  end;

end;

procedure TDm_Main.IBOUpdateRecord(TableName: string; DataSet: TIBODataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  if FVideCache then
    UpdateAction := uaApplied
  else
  begin
    if UpdateKind = ukInsert then
    begin
      IBOCacheUpdateI(TableName, DataSet);
    end;
    if UpdateKind = ukModify then
    begin
      IBOCacheUpdateU(TableName, DataSet);
    end;
    if UpdateKind = ukDelete then
    begin
      IBOCacheUpdateD(TableName, DataSet);
    end;

  end;
end;

procedure TDm_Main.IB_UpdateRecord(TableName: string; DataSet: TIB_BDataSet;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  if FVideCache then
    UpdateAction := uacApplied
  else
  begin
    if UpdateKind = ukiInsert then
    begin
      IB_CacheUpdateI(TableName, DataSet);
    end;
    if UpdateKind = ukiModify then
    begin
      IB_CacheUpdateU(TableName, DataSet);
    end;
    if UpdateKind = ukiDelete then
    begin
      IB_CacheUpdateD(TableName, DataSet);
    end;
  end;
end;

procedure TDm_Main.GetTableFields(TableName: string);
begin
  if IbQ_TableField.ParamByName('TABLENAME').AsString <> Uppercase(TableName) then
    IbQ_TableField.ParamByName('TABLENAME').AsString := Uppercase(TableName);
  if not IbQ_TableField.Active then IbQ_TableField.Open;

  IbQ_TableField.First;
  if IbQ_TableField.Eof then
    raise Exception.Create(ParamsStr(ErrNoFieldDef, TableName));

  if IbQ_TablePkKey.ParamByName('TABLENAME').AsString <> uppercase(TableName) then
    IbQ_TablePkKey.ParamByName('TABLENAME').AsString := uppercase(TableName);
  if not IbQ_TablePkKey.Active then IbQ_TablePkKey.Open;

  IbQ_TablePkKey.First;
  if IbQ_TablePkKey.Eof then
    raise Exception.Create(ParamsStr(ErrNoPkFieldDef, TableName));
end;

function TDm_Main.TrouveTablesFields(TableName: string): TObjetTableFields;
var
  j: integer;
  TOTF: TObjetTableFields;
begin
  J := LesTableFields.IndexOf(Uppercase(TableName));
  if j = -1 then
  begin
    GetTableFields(TableName);
    TOTF := TObjetTableFields.Create;
    LesTableFields.AddObject(Uppercase(TableName), TOTF);
    TOTF.PkKFLD_NAME := IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString;
    TOTF.PkKTB_ID := IbQ_TablePkKey.FieldByName('KTB_ID').AsString;
    IbQ_TableField.First;
    while not IbQ_TableField.Eof do
    begin
      if TOTF.LaListe.IndexOf(IbQ_TableField.FieldByName('KFLD_NAME').AsString + ';' + IbQ_TableField.FieldByName('KKW_NAME').AsString) < 0 then
        TOTF.LaListe.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString + ';' + IbQ_TableField.FieldByName('KKW_NAME').AsString);

      IbQ_TableField.Next;
    end;
    result := TOTF;
  end
  else
    result := TObjetTableFields(LesTableFields.Objects[j]);
end;

function TDm_Main.TrouveObjetValidation(TableName: string; DataSet: TIBODataSet): TObjetValidation;
var
  I: Integer;
  j: Integer;
  Pass: string;
  MonField: TField;
  LaQuery: string;
  PassLst: TStringList;
  TOTF: TObjetTableFields;
begin
  if LesObjets.Count = 0 then
  begin
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add('Select distinct rdb$procedure_parameters.rdb$procedure_name');
    ibc_majcu.SQL.Add('From rdb$procedure_parameters');
    ibc_majcu.SQL.Add(' Where rdb$procedure_parameters.rdb$procedure_name LIKE ''INS/_%'' escape ''/''');
    ibc_majcu.Open;
    while not ibc_majcu.Eof do
    begin
      Pass := ibc_majcu.Fields[0].AsString;
      delete(pass, 1, 4);
      Pass := Uppercase(Pass);
      result := TObjetValidation.Create(Pass);
      LesObjets.addObject(Pass, result);
      ibc_majcu.Next;
    end;
  end;
  Pass := Uppercase(TableName);
  J := LesObjets.IndexOf(Pass);
  if j = -1 then
  begin
    TOTF := TrouveTablesFields(TableName);
    MonField := DataSet.FindField(TOTF.PkKFLD_NAME);
    if MonField = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));
    IbQ_TableField.First;
    IBS_Creation.SQL.Clear;
    IBS_Creation.SQL.Add('CREATE PROCEDURE INS_' + TableName);
    IBS_Creation.SQL.Add('');
    IBS_Creation.SQL.Add('AS');
    IBS_Creation.SQL.Add('DECLARE VARIABLE KVER INTEGER ;');
    IBS_Creation.SQL.Add('BEGIN');
    IBS_Creation.SQL.Add('');
    IBS_Creation.SQL.Add('IF (:KI=1) THEN');
    IBS_Creation.SQL.Add('BEGIN');
    IBS_Creation.SQL.Add('SELECT NEWKEY FROM PROC_NEWVERKEY INTO :KVER ;');
    IBS_Creation.SQL.Add('INSERT INTO K (K_ID,  KRH_ID,  KTB_ID,  K_VERSION,  K_ENABLED,');
    IBS_Creation.SQL.Add('               KSE_OWNER_ID,  KSE_INSERT_ID,  KSE_UPDATE_ID,');
    IBS_Creation.SQL.Add('               KSE_DELETE_ID,  K_INSERTED,  K_UPDATED,  K_DELETED,  KSE_LOCK_ID,  KMA_LOCK_ID)');
    Pass := TOTF.PkKTB_ID;
    IBS_Creation.SQL.Add('      VALUES  (:V' + TOTF.PkKFLD_NAME + ', :KVER , ''' + Pass + ''', :KVER, 1,');
    IBS_Creation.SQL.Add('               -1, -1, 0, 0, current_timestamp, current_timestamp,');
    IBS_Creation.SQL.Add('               NULL, :KVER, :KVER) ;');
    IBS_Creation.SQL.Add('END');
    IBS_Creation.SQL.Add('');
    IBS_Creation.SQL.Add('INSERT INTO ' + TableName + '(');
    LaQuery := 'KI INTEGER, V' + TOTF.PkKFLD_NAME + ' INTEGER';
    PassLst := tStringList.Create;
    try
      for i := 0 to TOTF.LaListe.Count - 1 do
      begin
        IBS_Creation.SQL.Add(TOTF.KFLD_NAME[i]);
        if TOTF.KKW_NAME[i] = 'INTEGER' then
        begin
          LaQuery := LaQuery + ', ' + TOTF.KFLD_NAME[i] + ' INTEGER';
          PassLst.Add('IF (' + TOTF.KFLD_NAME[i] + ' IS NULL) THEN ' + TOTF.KFLD_NAME[i] + ' = 0 ;');
        end
        else if TOTF.KKW_NAME[i] = 'VARCHAR' then
        begin
          LaQuery := LaQuery + ', ' + TOTF.KFLD_NAME[i] + ' VARCHAR(1024)';
          PassLst.Add('IF (' + TOTF.KFLD_NAME[i] + ' IS NULL) THEN ' + TOTF.KFLD_NAME[i] + ' = '''' ;');
        end
        else if TOTF.KKW_NAME[i] = 'DATE' then
        begin
          LaQuery := LaQuery + ', ' + TOTF.KFLD_NAME[i] + ' TIMESTAMP';
        end
        else if TOTF.KKW_NAME[i] = 'FLOAT' then
        begin
          LaQuery := LaQuery + ', ' + TOTF.KFLD_NAME[i] + ' NUMERIC(18,5)';
          PassLst.Add('IF (' + TOTF.KFLD_NAME[i] + ' IS NULL) THEN ' + TOTF.KFLD_NAME[i] + ' = 0 ;');
        end;
        IBS_Creation.SQL.Add(', ');
      end;
      IBS_Creation.SQL[1] := '(' + LaQuery + ')';
      IBS_Creation.SQL[IBS_Creation.SQL.Count - 1] := ') VALUES (';
      for i := 0 to TOTF.LaListe.Count - 1 do
      begin
        IBS_Creation.SQL.Add(':' + TOTF.KFLD_NAME[i]);
        IBS_Creation.SQL.Add(',');
      end;
      IBS_Creation.SQL[IBS_Creation.SQL.Count - 1] := ') ;';
      IBS_Creation.SQL.Add('END');
      for i := 0 to PassLst.Count - 1 do
        IBS_Creation.SQL.Insert(5 + i, PassLst[i]);
    finally
      PassLst.free;
    end;
    IBS_Creation.SQL.Insert(0, 'SET TERM ^ ;');
    IBS_Creation.SQL.ADD('^');
    IBS_Creation.SQL.ADD('SET TERM ; ^');
    IBS_Creation.SQL.ADD('COMMIT ; ');
    IBS_Creation.SQL.Add('GRANT EXECUTE ON PROCEDURE INS_' + TableName + ' TO GINKOIA; ');
    IBS_Creation.SQL.ADD('COMMIT ; ');
    if Dataset.IB_Transaction = Ibt_Lk then
      IBS_Creation.IB_Transaction := IbT_MajLk
    else
      IBS_Creation.IB_Transaction := IbT_Maj;
    try
      IBS_Creation.Execute;
    except
      // cas de deux postes créant la procédure en même temps
    end;
    result := TObjetValidation.Create(Uppercase(TableName));
    LesObjets.addObject(Uppercase(TableName), result);
  end
  else
    result := TObjetValidation(LesObjets.Objects[j]);
end;

procedure TDm_Main.IBOCacheUpdateI(TableName: string; DataSet: TIBODataSet);
var
  I: Integer;
  MonField: TField;
  TOV: TObjetValidation;
  S: string;
begin
  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) or
    (Dataset.IB_Transaction = Ibt_Lk) then
  begin
    TOV := TrouveObjetValidation(TableName, DataSet);
    if Dataset.IB_Transaction = Ibt_Lk then
      Tov.Proc.IB_Transaction := IbT_MajLk
    else
      Tov.Proc.IB_Transaction := IbT_Maj;
    for i := 2 to Tov.Proc.ParamNames.Count - 1 do
    begin
      if (Tov.Proc.ParamCount = 0) then
        Tov.Proc.prepare;
      MonField := DataSet.FindField(Tov.Proc.ParamNames[i]);
      if (MonField = nil) or VarIsNull(MonField.Value) then
        Tov.Proc.Params[i].clear
      else
      begin
        if MonField.DataType in [ftBoolean] then
        begin
          if MonField.AsBoolean then
            Tov.Proc.Params[i].AsInteger := 1
          else
            Tov.Proc.Params[i].AsInteger := 0;
        end
        else if MonField.DataType in [ftSmallint, ftInteger, ftWord] then
          Tov.Proc.Params[i].AsInteger := MonField.AsInteger
        else if MonField.DataType in [ftFloat, ftCurrency, ftBCD] then
          Tov.Proc.Params[i].AsFloat := MonField.AsFloat
        else if MonField.DataType in [ftDate, ftTime, ftDateTime] then
          Tov.Proc.Params[i].AsDateTime := MonField.AsDateTime
        else
          Tov.Proc.Params[i].AsString := MonField.AsString;
      end;
    end;
    if (Dataset.IB_Transaction <> Ibt_HorsK) and IsKManagementActive then
    begin
      Tov.Proc.Params[0].AsInteger := 1;
      S := Tov.Proc.ParamNames[1];
      delete(s, 1, 1);
      Tov.Proc.Params[1].AsInteger := DataSet.FieldByName(S).AsInteger;
    end
    else
      Tov.Proc.Params[0].AsInteger := 0;
    Tov.Execute;
  end;
end;

procedure TDm_Main.IBOCacheUpdateU(TableName: string; DataSet: TIBODataSet);
var
  FoundModified: Boolean;
  KFLD_NAME: string;
  LeChamps: TField;

  i: Integer;

  TOTF: TObjetTableFields;
begin
  FoundModified := False;
  TOTF := TrouveTablesFields(TableName);

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET ');

    if DataSet.FindField(TOTF.PkKFLD_NAME) = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));

    for i := 0 to TOTF.LaListe.Count - 1 do
    begin
      LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
      if (LeChamps <> nil) and
        not VarIsNull(LeChamps.NewValue) and
        (KFLD_NAME <> TOTF.PkKFLD_NAME) and
        (LeChamps.OldValue <> LeChamps.NewValue) then
      begin
        ibc_majcu.SQL.Add(TOTF.KFLD_NAME[i] + ' = :' + TOTF.KFLD_NAME[i]);
        ibc_majcu.SQL.Add(',');
        FoundModified := True;
      end;
    end;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ' WHERE ' + TOTF.PkKFLD_NAME + '= :' + TOTF.PkKFLD_NAME;
    if FoundModified then
    begin
      ibc_majcu.Prepare;
      for i := 0 to TOTF.LaListe.Count - 1 do
      begin
        LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
        if (LeChamps <> nil) and
          not VarIsNull(LeChamps.NewValue) and
          (KFLD_NAME <> TOTF.PkKFLD_NAME) and
          (LeChamps.OldValue <> LeChamps.NewValue) then
        begin
          if TOTF.KKW_NAME[i] = 'INTEGER' then
          begin
            case LeChamps.DataType of
              ftBoolean:
                if LeChamps.AsBoolean then
                  ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := 1
                else
                  ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := 0;
              ftInteger:
                ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := LeChamps.NewValue;
            end
          end;
          if TOTF.KKW_NAME[i] = 'VARCHAR' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsString := LeChamps.NewValue;
          end;
          if TOTF.KKW_NAME[i] = 'DATE' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsDateTime := LeChamps.NewValue;
          end;
          if TOTF.KKW_NAME[i] = 'FLOAT' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsFloat := LeChamps.NewValue;
          end;
        end;
      end;

      ibc_majcu.ParamByName(TOTF.PkKFLD_NAME).AsString :=
        DataSet.FieldByName(TOTF.PkKFLD_NAME).NewValue;

      if (Dataset.IB_Transaction <> Ibt_HorsK) then
        if IsKManagementActive then
          UpdateK(DataSet.FieldByName(TOTF.PkKFLD_NAME).NewValue, '-1');
      Ibc_majcu.Execute;
    end;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    ibc_majcuLk.SQL.Clear;
    ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET ');

    if DataSet.FindField(TOTF.pkKFLD_NAME) = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));
    for i := 0 to TOTF.LaListe.Count - 1 do
    begin
      LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
      if (LeChamps <> nil) and
        not VarIsNull(LeChamps.NewValue) and
        (KFLD_NAME <> TOTF.PkKFLD_NAME) and
        (LeChamps.OldValue <> LeChamps.NewValue) then
      begin
        ibc_majcuLk.SQL.Add(TOTF.KFLD_NAME[i] + ' = :' + TOTF.KFLD_NAME[i]);
        ibc_majcuLk.SQL.Add(',');
        FoundModified := True;
      end;
    end;
    ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ' WHERE ' + TOTF.PkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME;

    if FoundModified then
    begin
      ibc_majcuLk.Prepare;
      for i := 0 to TOTF.LaListe.count - 1 do
      begin
        LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
        if (LeChamps <> nil) and
          not VarIsNull(LeChamps.NewValue) and
          (KFLD_NAME <> TOTF.PkKFLD_NAME) and
          (LeChamps.OldValue <> LeChamps.NewValue) then
        begin
          if TOTF.KKW_NAME[i] = 'INTEGER' then
          begin
            case LeChamps.DataType of
              ftBoolean:
                if LeChamps.AsBoolean then
                  ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := 1
                else
                  ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := 0;
              ftInteger:
                ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := LeChamps.NewValue
            end
          end;
          if TOTF.KKW_NAME[i] = 'VARCHAR' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsString := LeChamps.NewValue;
          end;
          if TOTF.KKW_NAME[i] = 'DATE' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsDateTime := LeChamps.NewValue;
          end;
          if TOTF.KKW_NAME[i] = 'FLOAT' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsFloat := LeChamps.NewValue;
          end;
        end;
      end;

      ibc_majcuLk.ParamByName(TOTF.PkKFLD_NAME).AsString := DataSet.FieldByName(TOTF.PkKFLD_NAME).NewValue;

      if IsKManagementActive then
        UpdateKLk(DataSet.FieldByName(TOTF.PkKFLD_NAME).NewValue, '-1');

      Ibc_majcuLk.Execute;
    end;
  end;
end;

procedure TDm_Main.IBOCacheUpdateD(TableName: string; DataSet: TIBODataSet);
var
  TOFT: TObjetTableFields;
begin
  TOFT := TrouveTablesFields(TableName);
  if DataSet.FindField(TOFT.PkKFLD_NAME) = nil then
    raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOFT.PkKFLD_NAME));

  if (Dataset.IB_Transaction = Ibt_Select) then
  begin
    if not IsKManagementActive then
    begin
      ibc_majcu.SQL.Clear;
      ibc_majcu.SQL.Add('DELETE FROM ' + TableName + ' WHERE ' + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME);
      ibc_majcu.Prepare;
      ibc_majcu.ParamByName(TOFT.PkKFLD_NAME).AsString := DataSet.FieldByName(TOFT.PkKFLD_NAME).OldValue;
      ibc_majcu.Execute;
    end;

    if IsKManagementActive then
    begin

      DeleteK(DataSet.FieldByName(TOFT.PkKFLD_NAME).Oldvalue, '-1');
      // Simulation de modification pour activation des triggers
      ibc_majcu.SQL.Clear;
      ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET '
        + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME
        + ' WHERE '
        + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME);

      ibc_majcu.Prepare;
      ibc_majcu.ParamByName(TOFT.PkKFLD_NAME).AsString := DataSet.FieldByName(TOFT.PkKFLD_NAME).OldValue;
      ibc_majcu.Execute;
    end;
  end;

  if (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add('DELETE FROM ' + TableName + ' WHERE ' + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME);
    ibc_majcu.Prepare;
    ibc_majcu.ParamByName(TOFT.PkKFLD_NAME).AsString := DataSet.FieldByName(TOFT.PkKFLD_NAME).OldValue;
    ibc_majcu.Execute;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin

    if not IsKManagementActive then
    begin
      ibc_majcuLk.SQL.Clear;
      ibc_majcuLk.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
        + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME);
      ibc_majcuLk.Prepare;
      ibc_majcuLk.ParamByName(TOFT.PkKFLD_NAME).AsString := DataSet.FieldByName(TOFT.PkKFLD_NAME).OldValue;
      ibc_majcuLk.Execute;
    end;

    if IsKManagementActive then
    begin
      DeleteKLk(DataSet.FieldByName(TOFT.PkKFLD_NAME).Oldvalue, '-1');
      // Simulation de modification pour activation des triggers
      ibc_majcuLk.SQL.Clear;
      ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET '
        + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME
        + ' WHERE '
        + TOFT.PkKFLD_NAME + ' = :' + TOFT.PkKFLD_NAME);

      ibc_majcuLk.Prepare;
      ibc_majcuLk.ParamByName(TOFT.PkKFLD_NAME).AsString := DataSet.FieldByName(TOFT.PkKFLD_NAME).OldValue;
      ibc_majcuLk.Execute;
    end;
  end;

end;

procedure TDm_Main.IB_CacheUpdateI(TableName: string; DataSet: TIB_BDataSet);
var
  TotF: TObjetTableFields;
  LeChamps: TIB_Column;
  i: Integer;
begin
  TOTF := TrouveTablesFields(TableName);
  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add('INSERT INTO ' + TableName + '(');
    if DataSet.FindField(TOTF.PkKFLD_NAME) = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));

    for i := 0 to TOTF.LaListe.Count - 1 do
    begin
      ibc_majcu.SQL.Add(TOTF.KFLD_NAME[i]);
      ibc_majcu.SQL.Add(',');
    end;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ') VALUES (';

    for i := 0 to TOTF.LaListe.Count - 1 do
    begin
      ibc_majcu.SQL.Add(':' + TOTF.KFLD_NAME[i]);
      ibc_majcu.SQL.Add(',');
    end;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ')';
    ibc_majcu.Prepare;

    for i := 0 to TOTF.LaListe.Count - 1 do
    begin
      LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
      if TOTF.KKW_NAME[i] = 'INTEGER' then
      begin
        if LeChamps <> nil then
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsInteger :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsInteger
        else
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := 0;
      end;

      if TOTF.KKW_NAME[i] = 'VARCHAR' then
      begin
        if LeChamps <> nil then
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsString :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsString
        else
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsString := '';
      end;

      if TOTF.KKW_NAME[i] = 'DATE' then
      begin
        if LeChamps <> nil then
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsDateTime :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsDateTime;
      end;

      if TOTF.KKW_NAME[i] = 'FLOAT' then
      begin
        if LeChamps <> nil then
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsFloat :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsFloat
        else
          ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsFloat := 0;
      end;

    end;

    if (Dataset.IB_Transaction <> Ibt_HorsK) then
      if IsKManagementActive then
        InsertK(DataSet.FieldByName(TOTF.pkKFLD_NAME).AsString, TOTF.PkKTB_ID,
          '-101', '-1', '-1');
    Ibc_majcu.Execute;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    ibc_majcuLk.SQL.Clear;
    ibc_majcuLk.SQL.Add('INSERT INTO ' + TableName + '(');

    if DataSet.FindField(TOTF.PkKFLD_NAME) = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));

    for i := 0 to TOTF.LaListe.count - 1 do
    begin
      ibc_majcuLk.SQL.Add(TOTF.KFLD_NAME[i]);
      ibc_majcuLk.SQL.Add(',');
    end;
    ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ') VALUES (';
    for i := 0 to TOTF.LaListe.Count - 1 do
    begin
      ibc_majcuLk.SQL.Add(':' + TOTF.KFLD_NAME[i]);
      ibc_majcuLk.SQL.Add(',');
    end;
    ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ')';
    ibc_majcuLk.Prepare;

    for i := 0 to TOTF.LaListe.count - 1 do
    begin
      LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
      if TOTF.KKW_NAME[i] = 'INTEGER' then
      begin
        if LeChamps <> nil then
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsInteger :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsInteger
        else
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := 0;
      end;

      if TOTF.KKW_NAME[i] = 'VARCHAR' then
      begin
        if LeChamps <> nil then
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsString :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsString
        else
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsString := '';
      end;

      if TOTF.KKW_NAME[i] = 'DATE' then
      begin
        if LeChamps <> nil then
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsDateTime :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsDateTime
      end;

      if TOTF.KKW_NAME[i] = 'FLOAT' then
      begin
        if LeChamps <> nil then
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsFloat :=
            DataSet.FieldByName(TOTF.KFLD_NAME[i]).AsFloat
        else
          ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsFloat := 0;
      end;
    end;

    if IsKManagementActive then
      InsertKLk(DataSet.FieldByName(TOTF.PkKFLD_NAME).AsString,
        TOTF.pKKTB_ID, '-101', '-1', '-1');

    Ibc_majcuLk.Execute;
  end;
end;

procedure TDm_Main.IB_CacheUpdateU(TableName: string; DataSet: TIB_BDataSet);
var
  FoundModified: Boolean;
  TOTF: TObjetTableFields;
  LeChamps: TIB_Column;
  i: Integer;

begin
  FoundModified := False;
  TOTF := TrouveTablesFields(TableName);

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin

    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET ');

    if DataSet.FindField(TOTF.PkKFLD_NAME) = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));

    for i := 0 to TOTF.Laliste.count - 1 do
    begin
      LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
      if (LeChamps <> nil) and
        (TOTF.KFLD_NAME[i] <> TOTF.PkKFLD_NAME) and
        (LeChamps.AsString <> LeChamps.OldAsString) then
      begin
        ibc_majcu.SQL.Add(TOTF.KFLD_NAME[i] + ' = :' + TOTF.KFLD_NAME[i]);
        ibc_majcu.SQL.Add(',');
        FoundModified := True;
      end;
    end;

    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ' WHERE ' + TOTF.PkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME;
    if FoundModified then
    begin
      ibc_majcu.Prepare;
      for i := 0 to TOTF.LaListe.Count - 1 do
      begin
        LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
        if (LeChamps <> nil) and
          (TOTF.KFLD_NAME[i] <> TOTF.PkKFLD_NAME) and
          (LeChamps.AsString <> LeChamps.OldAsString) then
        begin
          if TOTF.KKW_NAME[i] = 'INTEGER' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := LeChamps.AsInteger;
          end;

          if TOTF.KKW_NAME[i] = 'VARCHAR' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsString := LeChamps.AsString;
          end;

          if TOTF.KKW_NAME[i] = 'DATE' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsDateTime := LeChamps.AsDateTime;
          end;

          if TOTF.KKW_NAME[i] = 'FLOAT' then
          begin
            ibc_majcu.ParamByName(TOTF.KFLD_NAME[i]).AsFloat := LeChamps.AsFloat;
          end;
        end;
      end;

      ibc_majcu.ParamByName(TOTF.PkKFLD_NAME).AsString := DataSet.FieldByName(TOTF.pkKFLD_NAME).AsString;

      if (Dataset.IB_Transaction <> Ibt_HorsK) then
        if IsKManagementActive then
          UpdateK(DataSet.FieldByName(TOTF.PkKFLD_NAME).AsString, '-1');

      Ibc_majcu.Execute;

    end;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    ibc_majcuLk.SQL.Clear;
    ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET ');

    if DataSet.FindField(TOTF.PkKFLD_NAME) = nil then
      raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.PkKFLD_NAME));

    for i := 0 to TOTF.LaListe.count - 1 do
    begin
      LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
      if (LeChamps <> nil) and
        (TOTF.KFLD_NAME[i] <> TOTF.PkKFLD_NAME) and
        (LeChamps.AsString <> LeChamps.OldAsString) then
      begin
        ibc_majcuLk.SQL.Add(TOTF.KFLD_NAME[i] + ' = :' + TOTF.KFLD_NAME[i]);
        ibc_majcuLk.SQL.Add(',');
        FoundModified := True;
      end;
    end;
    ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ' WHERE ' + TOTF.PkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME;

    if FoundModified then
    begin
      ibc_majcuLk.Prepare;
      for i := 0 to TOTF.LaListe.Count - 1 do
      begin
        LeChamps := DataSet.FindField(TOTF.KFLD_NAME[i]);
        if (LeChamps <> nil) and
          (TOTF.KFLD_NAME[i] <> TOTF.pkKFLD_NAME) and
          (LeChamps.AsString <> LeChamps.OldAsString) then
        begin
          if TOTF.KKW_NAME[i] = 'INTEGER' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsInteger := LeChamps.AsInteger;
          end;

          if TOTF.KKW_NAME[i] = 'VARCHAR' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsString := LeChamps.AsString;
          end;

          if TOTF.KKW_NAME[i] = 'DATE' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsDateTime := LeChamps.AsDateTime;
          end;

          if TOTF.KKW_NAME[i] = 'FLOAT' then
          begin
            ibc_majcuLk.ParamByName(TOTF.KFLD_NAME[i]).AsFloat := LeChamps.AsFloat;
          end;
        end;
      end;

      ibc_majcuLk.ParamByName(TOTF.PkKFLD_NAME).AsString := DataSet.FieldByName(TOTF.PkKFLD_NAME).AsString;

      if IsKManagementActive then
        UpdateKLk(DataSet.FieldByName(TOTF.PkKFLD_NAME).AsString, '-1');

      Ibc_majcuLk.Execute;

    end;
  end;

end;

procedure TDm_Main.IB_CacheUpdateD(TableName: string; DataSet: TIB_BDataSet);
var
  TOTF: TObjetTableFields;
begin
  TOTF := TrouveTablesFields(TableName);

  if DataSet.FindField(TOTF.PkKFLD_NAME) = nil then
    raise Exception.Create(ParamsStr(ErrNoPkFieldFound, TOTF.pkKFLD_NAME));

  if (Dataset.IB_Transaction = Ibt_Select) or
    (Dataset.IB_Transaction = Ibt_HorsK) then
  begin
    if not IsKManagementActive then
    begin
      ibc_majcu.SQL.Clear;
      ibc_majcu.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
        + TOTF.pkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME);
      ibc_majcu.Prepare;
      ibc_majcu.ParamByName(TOTF.pkKFLD_NAME).AsString :=
        DataSet.FieldByName(TOTF.PkKFLD_NAME).OldAsString;
      ibc_majcu.Execute;
    end
    else
    begin
      if (Dataset.IB_Transaction <> Ibt_HorsK) then
        DeleteK(DataSet.FieldByName(TOTF.pkKFLD_NAME).OldAsString, '-1');

      // Simulation de modification pour activation des triggers
      ibc_majcu.SQL.Clear;
      ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET '
        + TOTF.pkKFLD_NAME + ' = :' + TOTF.pkKFLD_NAME
        + ' WHERE '
        + TOTF.pkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME);

      ibc_majcu.Prepare;
      ibc_majcu.ParamByName(TOTF.PkKFLD_NAME).AsString :=
        DataSet.FieldByName(TOTF.PkKFLD_NAME).OldAsString;
      ibc_majcu.Execute;

    end;
  end;

  if Dataset.IB_Transaction = Ibt_Lk then
  begin
    if not IsKManagementActive then
    begin
      ibc_majcuLk.SQL.Clear;
      ibc_majcuLk.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
        + TOTF.pkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME);
      ibc_majcuLk.Prepare;
      ibc_majcuLk.ParamByName(TOTF.pkKFLD_NAME).AsString :=
        DataSet.FieldByName(TOTF.pkKFLD_NAME).OldAsString;
      ibc_majcuLk.Execute;
    end
    else
    begin
      DeleteKLk(DataSet.FieldByName(TOTF.PkKFLD_NAME).OldAsString, '-1');

      // Simulation de modification pour activation des triggers
      ibc_majcuLk.SQL.Clear;
      ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET '
        + TOTF.pkKFLD_NAME + ' = :' + TOTF.pkKFLD_NAME
        + ' WHERE '
        + TOTF.PkKFLD_NAME + ' = :' + TOTF.PkKFLD_NAME);

      ibc_majcuLk.Prepare;
      ibc_majcuLk.ParamByName(TOTF.pkKFLD_NAME).AsString :=
        DataSet.FieldByName(TOTF.PkKFLD_NAME).OldAsString;
      ibc_majcuLk.Execute;
    end;
  end;

end;

// GESTION DE LA TABLE K

procedure TDm_Main.InsertK(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: string);
begin
  if not IbC_InsertK.Prepared then
    IbC_InsertK.Prepare;
  IbC_InsertK.ParamByName('K_ID').AsString := K_ID;
  if FVersionSys = 0 then
    IbC_InsertK.ParamByName('K_VERSION').AsString := GenVersion
  else
    IbC_InsertK.ParamByName('K_VERSION').AsInteger := FVersionSys;

  IbC_InsertK.ParamByName('KRH_ID').AsString := KRH_ID;
  IbC_InsertK.ParamByName('KTB_ID').AsString := KTB_ID;
  IbC_InsertK.ParamByName('KSE_OWNER_ID').AsString := KSE_Owner;
  IbC_InsertK.ParamByName('KSE_INSERT_ID').AsString := KSE_Insert;
  IbC_InsertK.ParamByName('KSE_UPDATE_ID').AsString := '0';
  IbC_InsertK.ParamByName('KSE_DELETE_ID').AsString := '0';
  {
  IbC_InsertK.ParamByName ( 'K_INSERTED' ) .AsString := S1;
  IbC_InsertK.ParamByName ( 'K_UPDATED' ) .AsString := S1;
  IbC_InsertK.ParamByName ( 'K_DELETED' ) .AsString := S2;
  }
  IbC_InsertK.ParamByName('K_INSERTED').AsDateTime := Now;
  IbC_InsertK.ParamByName('K_UPDATED').AsDateTime := Now;
  IbC_InsertK.ParamByName('K_DELETED').Clear;

  IbC_InsertK.ParamByName('KSE_LOCK_ID').AsString := '0';
  IbC_InsertK.ParamByName('KMA_LOCK_ID').AsString := '0';
  IbC_InsertK.Execute;
end;

procedure TDm_Main.InsertKLk(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: string);
begin
  if not IbC_InsertKLk.Prepared then
    IbC_InsertKLk.Prepare;
  IbC_InsertKLk.ParamByName('K_ID').AsString := K_ID;
  if FVersionSys = 0 then
    IbC_InsertKLk.ParamByName('K_VERSION').AsString := GenVersion
  else
    IbC_InsertKLk.ParamByName('K_VERSION').AsInteger := FVersionSys;

  IbC_InsertKLk.ParamByName('KRH_ID').AsString := KRH_ID;
  IbC_InsertKLk.ParamByName('KTB_ID').AsString := KTB_ID;
  IbC_InsertKLk.ParamByName('KSE_OWNER_ID').AsString := KSE_Owner;
  IbC_InsertKLk.ParamByName('KSE_INSERT_ID').AsString := KSE_Insert;
  IbC_InsertKLk.ParamByName('KSE_UPDATE_ID').AsString := '0';
  IbC_InsertKLk.ParamByName('KSE_DELETE_ID').AsString := '0';
  {
  IbC_InsertKLk.ParamByName ( 'K_INSERTED' ) .AsString := S1;
  IbC_InsertKLk.ParamByName ( 'K_UPDATED' ) .AsString := S1;
  IbC_InsertKLk.ParamByName ( 'K_DELETED' ) .AsString := S2;
  }
  IbC_InsertKLk.ParamByName('K_INSERTED').AsDateTime := Now;
  IbC_InsertKLk.ParamByName('K_UPDATED').AsDateTime := Now;
  IbC_InsertKLk.ParamByName('K_DELETED').Clear;

  IbC_InsertKLk.ParamByName('KSE_LOCK_ID').AsString := '0';
  IbC_InsertKLk.ParamByName('KMA_LOCK_ID').AsString := '0';
  IbC_InsertKLk.Execute;
end;

procedure TDm_Main.UpdateK(K_ID, KSE_Update: string);
begin
  if not IbC_UpDateK.Prepared then
    IbC_UpDateK.Prepare;
  IbC_UpDateK.ParamByName('K_ID').AsString := K_ID;
  if FVersionSys = 0 then
    IbC_UpDateK.ParamByName('K_VERSION').AsString := GenVersion
  else
    IbC_UpDateK.ParamByName('K_VERSION').AsString := IntToStr(FVersionSys);

  IbC_UpDateK.ParamByName('KSE_UPDATE_ID').AsString := KSE_Update;
  IbC_UpDateK.ParamByName('K_UPDATED').AsDateTime := Now;
  IbC_UpDateK.Execute;
end;

procedure TDm_Main.UpdateKLk(K_ID, KSE_Update: string);
begin
  if not IbC_UpDateKLk.Prepared then
    IbC_UpDateKLk.Prepare;
  IbC_UpDateKLk.ParamByName('K_ID').AsString := K_ID;
  if FVersionSys = 0 then
    IbC_UpDateKLk.ParamByName('K_VERSION').AsString := GenVersion
  else
    IbC_UpDateKLk.ParamByName('K_VERSION').AsString := IntToStr(FVersionSys);

  IbC_UpDateKLk.ParamByName('KSE_UPDATE_ID').AsString := KSE_Update;
  IbC_UpDateKLk.ParamByName('K_UPDATED').AsDateTime := Now;
  IbC_UpDateKLk.Execute;
end;

procedure TDm_Main.DeleteK(K_ID, KSE_Delete: string);
begin
  if not IbC_DeleteK.Prepared then
    IbC_DeleteK.Prepare;
  IbC_DeleteK.ParamByName('K_ID').AsString := K_ID;
  if FVersionSys = 0 then
    IbC_DeleteK.ParamByName('K_VERSION').AsString := GenVersion
  else
    IbC_DeleteK.ParamByName('K_VERSION').AsInteger := FVersionSys;

  IbC_DeleteK.ParamByName('KSE_DELETE_ID').AsString := KSE_Delete;
  IbC_DeleteK.ParamByName('K_DELETED').AsDateTime := Now;
  IbC_DeleteK.Execute;
end;

procedure TDm_Main.DeleteKLk(K_ID, KSE_Delete: string);
begin
  if not IbC_DeleteKLk.Prepared then
    IbC_DeleteKLk.Prepare;
  IbC_DeleteKLk.ParamByName('K_ID').AsString := K_ID;
  if FVersionSys = 0 then
    IbC_DeleteKLk.ParamByName('K_VERSION').AsString := GenVersion
  else
    IbC_DeleteKLk.ParamByName('K_VERSION').AsInteger := FVersionSys;

  IbC_DeleteKLk.ParamByName('KSE_DELETE_ID').AsString := KSE_Delete;
  IbC_DeleteKLk.ParamByName('K_DELETED').AsDateTime := Now;
  IbC_DeleteKLk.Execute;
end;

procedure TDm_Main.SetVersionSys(Version: Integer);
begin
  FVersionSys := Version;
end;

procedure TDm_Main.DesableKManagement;
begin
  FKActive := False;
end;

function TDm_Main.IsKManagementActive: Boolean;
begin
  Result := FKActive;
end;

procedure TDm_Main.SetNewGeneratorKey(ProcName: string);
begin
  IbStProc_NewKey.StoredProcName := ProcName;
end;

procedure TDm_Main.SetNewGeneratorVerKey(ProcName: string);
begin
  IbStProc_NewVerKey.StoredProcName := ProcName;
end;

// GESTION DU MONITEUR SQL

procedure TDm_Main.ShowMonitor;
begin
  Monitor.Show;
end;

// GESTION DE SCRIPT SQL

procedure TDm_Main.PrepareScript(SQL: string);
begin
  IbC_Script.Close;
  IbC_Script.SQL.Clear;
  IbC_Script.SQL.Add(SQL);
  IbC_Script.Prepare;
end;

procedure TDm_Main.PrepareScriptLk(SQL: string);
begin
  IbC_ScriptLk.Close;
  IbC_ScriptLk.SQL.Clear;
  IbC_ScriptLk.SQL.Add(SQL);
  IbC_ScriptLk.Prepare;
end;

procedure TDm_Main.PrepareScriptMultiKUpDate(SQL: string);
begin
  IbC_Script.Close;
  IbC_Script.SQL.Clear;
  IbC_Script.SQL.Add(
    'UPDATE K SET ' +
    'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
    'KSE_UPDATE_ID = -1,' +
    'K_UPDATED = :K_UPDATED WHERE K.K_ID IN (' +
    SQL + ' )');
  IbC_Script.Prepare;
  IbC_Script.ParamByName('K_UPDATED').AsDateTime := Now;
end;

procedure TDm_Main.PrepareScriptMultiKUpDateLk(SQL: string);
begin
  IbC_ScriptLk.Close;
  IbC_ScriptLk.SQL.Clear;
  IbC_ScriptLk.SQL.Add(
    'UPDATE K SET ' +
    'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
    'KSE_UPDATE_ID = -1,' +
    'K_UPDATED = :K_UPDATED WHERE K.K_ID IN (' +
    SQL + ' )');
  IbC_ScriptLk.Prepare;
  IbC_ScriptLk.ParamByName('K_UPDATED').AsDateTime := Now;
end;

procedure TDm_Main.PrepareScriptMultiKDelete(SQL: string);
begin
  IbC_Script.Close;
  IbC_Script.SQL.Clear;
  IbC_Script.SQL.Add(
    'UPDATE K SET ' +
    'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
    'K_ENABLED = 0,' +
    'KSE_UPDATE_ID = -1,' +
    'K_DELETED = :K_DELETED WHERE K.K_ID IN (' +
    SQL + ' )');
  IbC_Script.Prepare;
  IbC_Script.ParamByName('K_DELETED').AsDateTime := Now;

end;

procedure TDm_Main.PrepareScriptMultiKDeleteLk(SQL: string);
begin
  IbC_ScriptLk.Close;
  IbC_ScriptLk.SQL.Clear;
  IbC_ScriptLk.SQL.Add(
    'UPDATE K SET ' +
    'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
    'K_ENABLED = 0,' +
    'KSE_UPDATE_ID = -1,' +
    'K_DELETED = :K_DELETED WHERE K.K_ID IN (' +
    SQL + ' )');
  IbC_ScriptLk.Prepare;
  IbC_ScriptLk.ParamByName('K_DELETED').AsDateTime := Now;

end;

procedure TDm_Main.SetScriptParameterValue(ParamName, ParamValue: string);
begin
  IbC_Script.ParamByName(ParamName).AsString := ParamValue;
end;

procedure TDm_Main.SetScriptParameterValueLk(ParamName, ParamValue: string);
begin
  IbC_ScriptLk.ParamByName(ParamName).AsString := ParamValue;
end;

procedure TDm_Main.ExecuteScript;
begin
  try
    Dm_Main.StartTransaction;
    IbC_Script.Execute;
    Dm_Main.Commit;
  except
    Dm_Main.Rollback;
    if (FTransactionCount <> 0) then raise;
  end;
end;

procedure TDm_Main.ExecuteScriptLk;
begin
  try
    Dm_Main.StartTransactionLk;
    IbC_ScriptLk.Execute;
    Dm_Main.CommitLk;
  except
    Dm_Main.RollbackLk;
    if (FTransactionCountLk <> 0) then raise;
  end;
end;

procedure TDm_Main.ExecuteInsertK(TableName, KeyValue: string);
var
  SQLTYPE: string;
  TOTF: TObjetTableFields;
begin
  try
    Dm_Main.StartTransaction;

    // Mise à jour de la Table K
    TOTF := TrouveTablesFields(TableName);

    SQLTYPE := FirstMot(IbC_Script.SQL[0]);
    if (SQLTYPE <> 'INSERT') or (StrToInt(KeyValue) <= 0) then
      raise Exception.Create(ErrUsingScript);

    InsertK(KeyValue, TOTF.PkKTB_ID, '-101', '-1', '-1');

    // Lancement de la commande SQL
    IbC_Script.Execute;

    Dm_Main.Commit;
  except
    Dm_Main.Rollback;
    if (FTransactionCount <> 0) then raise;
  end;
end;

procedure TDm_Main.ExecuteInsertKLk(TableName, KeyValue: string);
var
  SQLTYPE: string;
  TOTF: TObjetTableFields;
begin
  try
    Dm_Main.StartTransactionLk;

    // Mise à jour de la Table K
    TOTF := TrouveTablesFields(TableName);

    SQLTYPE := FirstMot(IbC_Script.SQL[0]);
    if (SQLTYPE <> 'INSERT') or (StrToInt(KeyValue) <= 0) then
      raise Exception.Create(ErrUsingScript);

    InsertKLk(KeyValue, TOTF.PkKTB_ID, '-101', '-1', '-1');

    // Lancement de la commande SQL
    IbC_ScriptLk.Execute;

    Dm_Main.CommitLk;
  except
    Dm_Main.RollbackLk;
    if (FTransactionCountLk <> 0) then raise;
  end;
end;

//********************************************
// VERIFICATION DE L'INTEGRITE DE LA BASE
// Retourne True si pas d'enreg trouvé
//********************************************

function TDm_Main.CheckOneIntegrity(LkUpTableName, LkPkFieldName,
  LkUpFieldName, KeyValue: string; ShowErrorMessage: Boolean): Boolean;
begin
  Result := False;
  try
    Ibc_IntegrityChk.Close;
    Ibc_IntegrityChk.SQL.Clear;

    if IsKManagementActive then
      Ibc_IntegrityChk.SQL.Add('SELECT * FROM '
        + LkUpTableName
        + ',K WHERE '
        + LkUpFieldName
        + '=' + KeyValue
        + ' AND ' + LkPkFieldName // Ajout pour traiter le cas des arbres stockés
        + '<>' + KeyValue // dans une même table
        + ' AND K_ID = '
        + LkPkFieldName
        + ' AND K_ENABLED=1')
    else
      Ibc_IntegrityChk.SQL.Add('SELECT * FROM '
        + LkUpTableName
        + ' WHERE '
        + LkUpFieldName
        + '=' + KeyValue
        + ' AND ' + LkPkFieldName // Ajout pour traiter le cas des arbres stockés
        + '<>' + KeyValue // dans une même table
        );
    Ibc_IntegrityChk.Open;
    Result := Ibc_IntegrityChk.Eof;

  finally
    Ibc_IntegrityChk.Close;
    if not Result and ShowErrorMessage then Showmessage(ErrNoDeleteIntChk);
  end;
end;

function TDm_Main.CheckAllowEdit(TableName, KeyValue: string;
  ShowErrorMessage:
  Boolean): boolean;
begin
  Result := True;
  // Si...
  if (KeyValue <> '') and // ID défini
  (StrToInt(KeyValue) <= 0) and // ID négatif
  (FVersionSys = 0) then
  begin // alors on ne peut pas modifier un enregistrement système  // Pas en mode système
    if ShowErrorMessage then Showmessage(ErrNoEditNullRec);
    Result := False;
  end
end;

function TDm_Main.TransactionUpdPending: boolean;
begin
  Result := IbT_Select.TransactionIsActive;
end;

function TDm_Main.TransactionUpdPendingLk: boolean;
begin
  Result := IbT_Lk.TransactionIsActive;
end;

function TDm_Main.IBOUpdPending(DataSet: TIBODataSet): boolean;
begin
  Result := DataSet.Modified or DataSet.UpdatesPending;
end;

function TDm_Main.IB_UpdPending(DataSet: TIB_BDataSet): boolean;
begin
  Result := DataSet.Modified or DataSet.UpdatesPending;
end;

function TDm_Main.CheckAllowDelete(TableName, KeyValue: string;
  ShowErrorMessage: Boolean): boolean;
begin
  Result := True;

  // Si...
  if (KeyValue <> '') and // ID défini
  (StrToInt(KeyValue) <= 0) and // ID négatif
  (FVersionSys = 0) then
  begin // alors on ne peut pas effacer un enregistrement système  // Pas en mode système
    if ShowErrorMessage then Showmessage(ErrNoDeleteNullRec);
    Result := False;
  end
  else
  begin

    GetTableFields(TableName);
    if IbQ_TablePkKey.Eof then
      raise Exception.Create(ParamsStr(ErrNoPkFieldDef, TableName));

    if IbQ_FieldFkField.ParamByName('KFLD_FK').AsString <>
      IbQ_TablePkKey.FieldByName('KFLD_ID').AsString then
      IbQ_FieldFkField.ParamByName('KFLD_FK').AsString :=
        IbQ_TablePkKey.FieldByName('KFLD_ID').AsString;

    if not IbQ_FieldFkField.Active then IbQ_FieldFkField.Open;
    IbQ_FieldFkField.First;

    while not IbQ_FieldFkField.Eof do
    begin
      Result := Result and
        CheckOneIntegrity(IbQ_FieldFkField.FieldByName('KTB_NAME').AsString,
        IbQ_FieldFkField.FieldByName('PKFIELD').AsString,
        IbQ_FieldFkField.FieldByName('KFLD_NAME').AsString,
        KeyValue, False);
      IbQ_FieldFkField.Next;
    end;

    if not Result and ShowErrorMessage then
    begin
      Showmessage(ErrNoDeleteIntChk);
    end;
  end;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  tsl_help.free;
  if (not (csDesigning in ComponentState)) then
    Database.Connected := False;
end;

procedure TDm_Main.ibc_majcuError(Sender: TObject; const ERRCODE: Integer;
  ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
  SQLMessage, SQL: TStringList; var RaiseException: Boolean);
begin
  RaiseException := False;
  case SQLCODE of
    -625: raise Exception.Create(errSQL625);
    -803: raise Exception.Create(errSQL803);
  else
    raise Exception.Create(ParamsStr(errSQL, SQLCODE));
  end;
end;

function TDm_Main.CheckKeyExist(LkUpTableName, LkPkFieldName,
  LkUpFieldName, KeyValue: string; ShowErrorMessage: Boolean): Boolean;
begin
  Result := False;
  try

    Ibc_IntegrityChk.Close;
    Ibc_IntegrityChk.SQL.Clear;
    if IsKManagementActive then
      Ibc_IntegrityChk.SQL.Add('SELECT * FROM '
        + LkUpTableName
        + ',K WHERE '
        + LkUpFieldName
        + '=' + KeyValue
        + ' AND K_ID = '
        + LkPkFieldName
        + ' AND K_ENABLED=1')
    else
      Ibc_IntegrityChk.SQL.Add('SELECT * FROM '
        + LkUpTableName
        + ' WHERE '
        + LkUpFieldName
        + '=' + KeyValue
        );
    Ibc_IntegrityChk.Open;
    Result := Ibc_IntegrityChk.Eof;

  finally
    Ibc_IntegrityChk.Close;
    if not Result and ShowErrorMessage then Showmessage(ErrNoDeleteIntChk);
  end;

end;

{ TObjetValidation }

constructor TObjetValidation.Create(LeNom: string);
begin
  inherited create;
  Nom := LeNom;
  Proc := TIB_StoredProc.Create(nil);
  Proc.Ib_Connection := Dm_Main.Database;
  Proc.Ib_Transaction := Dm_Main.IbT_Maj;
  Proc.SQL.Text := 'EXECUTE PROCEDURE INS_' + LENOM;
  Proc.AutoDefineParams := True;
  Proc.Prepared := true;
end;

destructor TObjetValidation.Destroy;
begin
  proc.free;
  inherited;
end;

procedure TObjetValidation.execute;
begin
  proc.prepare;
  proc.execute;
  proc.unprepare;
end;

{ TObjetTableFields }

constructor TObjetTableFields.Create;
begin
  inherited;
  LaListe := TStringList.Create;
end;

destructor TObjetTableFields.Destroy;
begin
  LaListe.free;
  inherited;
end;

function TObjetTableFields.GetKFLD_NAME(Index: Integer): string;
begin
  Result := Laliste[Index];
  result := Copy(Result, 1, pos(';', result) - 1);
end;

function TObjetTableFields.GetKKW_NAME(Index: Integer): string;
begin
  Result := Laliste[Index];
  result := Copy(Result, pos(';', result) + 1, 255);
end;






initialization
  InitialisationDesLog;

finalization
  EnregistrerLog('Fin du programme');

end.


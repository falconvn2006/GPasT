/// <summary>
/// Unité uDataMod pour tous les Logiciels relatifs à EASY
/// </summary>
unit uDataMod;

interface

uses
  Winapi.Windows,
  Winapi.ShellAPI,
//  Dialogs,
  System.SysUtils,
  System.Classes,
  System.RegularExpressionsCore,
  System.Win.Registry,
  System.StrUtils,
  System.IOUtils,
  System.Variants,
  Data.DB,
  VCL.Forms,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.Phys.IBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.IBBase,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util,
  FireDAC.Comp.Script,
  FireDAC.Phys.IBWrapper,
  SymmetricDS.Commun,
  cHash,
  UWMI,
  ServiceControler,
  UCommun,
  System.IniFiles,
  uLog,
  uEasy.Types;

Const MinVersion=14;

type
(*  TQueryThread = class(TThread)
  private
    FEvent         : TNotifyEvent;
    FCnx           : TFDConnection;
    FQuery         : TFDQuery;
    FResultat      : integer;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aQuery:TFDQuery; aEvent:TNotifyEvent=nil);
    property Resultat:integer read FResultat write FResultat;
  end;

  TQueryDeltaThread = class(TThread)
  private
    FEvent         : TNotifyEvent;
    FCnx           : TFDConnection;
    FTrans         : TFDTransaction;
    FQuery         : TFDQuery;
    FGENID         : Integer;    // Niveau du GENERALID
    FMINKVERSION   : integer;    // Niveau du plus vieux du K_VERSION
    FMAXKVERSION   : integer;    // Niveau du plus récent du K_VERSION
    FCOUNT         : integer;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aQuery:TFDQuery; aGENID:Integer; aEvent:TNotifyEvent=nil);
    property MinKVERSION:integer read FMINKVERSION;
    property MaxKVERSION:integer read FMaxKVERSION;
    property COUNT:Integer       read FCOUNT;
  end;

  TQueryMVTThread = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FProgressProc  : TProgressMessageCall;

    FEvent         : TNotifyEvent;

    FProgress     : integer;

    FCnx           : TFDConnection;
    FTrans         : TFDTransaction;
    FNODEID        : string;      // Node
    FGENID         : Integer;      // Niveau du GENERALID
    FMINKVERSION   : integer;      // Niveau du plus vieux du K_VERSION
    FMAXKVERSION   : integer;      // Niveau du plus récent du K_VERSION

    Procedure ProgressCallBack;
//    Procedure StatusCallBack;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aNodeID:string; aGENID:Integer;
    aMinKVERSION,aMaxKVERSION:integer;aEvent:TNotifyEvent=nil);
  end;
  *)


  /// <summary>
  /// DataMod Général
  /// </summary>
  TDataMod = class(TDataModule)
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    TransSymmDS: TFDTransaction;
    FDManager: TFDManager;
    FDConnection1: TFDConnection;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    /// <summary>
    /// Installation de SymmetricDS
    /// <param name="ASym">DOTO</param>
    /// </summary>
    function InstallationSymmetricDS(ASym:TSymmetricDS;aStart:Boolean): Boolean;
    function DesInstallationSymmetricDS(ASym:TSymmetricDS): Boolean;
    // Installation de dossiers

    // Nettoyage du dossier (pour les tests)
    procedure DROP_SYMDS(const ABaseDonnees: TFileName);
//    procedure DROP_TRIGGERS_SYMDS(const ABaseDonnees: TFileName);
    procedure CLEAN_MAGCODE(const ABaseDonnees: TFileName);


    /// <summary>
    /// Ouverture du Dossier
    /// <param name="ADossierInfos">DOTO</param>
    /// </summary>
    procedure Ouverture_IBFile(var ADossierInfos:TDossierInfos);


    function Liste_Tables_Exclues(aCnx:TFDConnection):string;



    /// <summary>
    /// Installation d'un Dossier LAME
    /// <param name="ADossierInfos">DOTO</param>
    /// </summary>
    function Installation_Master(ADossierInfos:TDossierInfos): Boolean;

    /// <summary>
    /// Installation d'EASY sur un Noeud MAGASIN
    /// <param name="ADossierInfos">DOTO</param>
    /// </summary>
    function Installation_BASE(ADossierInfos:TDossierInfos): Boolean;

    function InfosReplication(const ABaseDonnees: TFileName): TInfosReplication;
    // Liste des bases de la base de données
    function ListeBases(const ABaseDonnees: TFileName): TBases;
    function Grant_SYMTABLE_TO_GINKOIA(const ABaseDonnees: TFileName):boolean;
    function GetNomPourNous(const ABaseDonnees: TFileName):string;
    procedure SetNomPourNous(const ABaseDonnees: TFileName;aNomPourNous:string);
    function GetCheminBaseGENREPLICATION(const ABaseDonnees: TFileName):string;
    function UpdateREP_PLACEBASE(const ABaseDonnees: TFileName;ABase0:string):boolean;


    function EtatNoeud(const ABaseDonnees: TFileName;aNode:string):TEtatNoeud;
    function GetLastHeartBeat(const ABaseDonnees: TFileName;Const NODEID:string):string;
    procedure CreateInFDManager({aServer:string;}aUser:string;aFile:string);

    function getNewConnexion(aRef:string): TFDConnection;

    function getNewTransaction(aConnection : TFDConnection): TFDTransaction;


    function getNewQuery(aConnection : TFDConnection ;  aTrans: TFDTransaction): TFDQuery;
    function getNewStoredProc(AConnexion: TFDConnection; ATransaction: TFDTransaction;const ANomProcedure: string): TFDStoredProc;


    function ScriptTriggersManquants(const ABaseDonnees: TFileName):TStringList;
    function ScriptTriggersManquantsLCL(const aLCLFile:TFileName):TStringList;

    function Controle_Longueur_Champs_Table(aCnx:TFDConnection;aTABLE:string):boolean;

    function GetGinkoiaVersion(const ABaseDonnees: TFileName):string;
    function NbTriggersSymDS(const ABaseDonnees: TFileName):integer;
    function NbTableTriggersSymDS(const ABaseDonnees: TFileName):integer;
    procedure FreeInfFDManager(aRef:string);

    function AjouteDossierBackupLame(aDB:TDossierInfos):Boolean;

    procedure GetTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
    procedure GetTablesExclues(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
    procedure GetAllTablesExclues(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
    procedure UpdateServiceACL(aName:string);
    procedure OpenFireWall(ASym:TSymmetricDS);
    function SetGenParamURL(aIBFile:string;aURL:string): Boolean;
    function ExecuteScript(const ABaseDonnees: TFileName;Asql:TStringList):boolean;
    function IsGAPDefined(const ABaseDonnees: TFileName):boolean;
    procedure DetectGAP(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
    procedure DoGAP(const ABaseDonnees: TFileName);
    function Joue_MiniSplit(aFileCSV:TFileName;aIBFile:TFileName):boolean;
//    procedure EASY_PUSH_MISSING_DELOS(const ABaseDonnees: TFileName);
    function IsPushMissingDELOSDefined(const ABaseDonnees: TFileName):boolean;
    procedure DoPushMissingDELOS(const ABaseDonnees: TFileName);
    function GetLocalNode(const ABaseDonnees: TFileName):string;
    function MAJ_Ajoute_TABLE_REPLIC(AIBFile:string;aTABLENAME,aKEYFIELD:string):boolean;
    function Get_Infos_Passage_DELOS2EASY(const ABaseDonnees: TFileName):TInfosDelosEASY;
    function RestartDataBase(const ABaseDonnees: TFileName) : boolean;

    function MAJ_GENPARAM_Monitor(aIBFile:string;avalue:integer): boolean;



    function EasyMvtListeBases(const ABaseDonnees: TFileName):TEasyBases;
//    function EasyMvtEval(const ABaseDonnees: TFileName;aDEB,aFIN:TDateTIme):integer;
    function EasyMvtLocalNode(const ABaseDonnees: TFileName):TNode;
    function EasyMvtListeRemoteNodes(const ABaseDonnees: TFileName):TNodes;

    function DeleteGenParamURL(aIBFile:string):Boolean;
    procedure GetAllTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
    procedure GetCASHTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
    procedure GetEASYTablesSuppReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);


    function GetGENERAL_ID(const ABaseDonnees: TFileName):integer;
    function GetPLAGE(const ABaseDonnees: TFileName):string;

    function EasyMvtKenabled(const ABaseDonnees: TFileName;Const aMAXROWS:Integer=50):string;
    function EasyMvtKenabled_INSERT(const ABaseDonnees: TFileName):string;
    function DetectNodeIBCorrupt(const ABaseDonnees: TFileName):string;
    function DetectNodeIBDeadLock(const ABaseDonnees: TFileName):string;

    function Get_GENPARAMS(const ABaseDonnees: TFileName;aWHERE:string):TGENPARAMS;

    function EasyUnsentBatchs(const ABaseDonnees: TFileName):TUnsentBatchs;
    function EasyLastReplicDELOS(const ABaseDonnees: TFileName):TLastRepicDelos;

    // -------------------------------------------------------------------------
    // Cette fonction permet de savoir s'il y a des triggers, tables ou genérateur de SYMDS
    // ne controle pas le paramètre 80,1
    function IsEasyInstalled(const ABaseDonnees: TFileName):Boolean;
    //--------------------------------------------------------------------------

    function GetGenParam_80_1(aIBFile:string):string;
    // Recupération de tous les SENDER
    procedure GetSenders(const ABaseDonnees: TFileName;var aDataSet:TDataSet);

    // mise à jour du genparam de delos vers easy dans le cas d'un mouvement automatique lancé par easyInstallLame
    function UpdateGenParamDelos2EasyByGUID(const ABaseDonnees: TFileName; const aGUID: string; const AValue: integer): boolean;

  end;

var
  DataMod: TDataMod;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

(*
constructor TQueryMVTThread.Create(ACnx:TFDConnection; aNodeID:string; aGENID:Integer;
    aMinKVERSION,aMaxKVERSION:integer;aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    OnTerminate := AEvent;
    FreeOnTerminate := True;

    FCnx           := ACnx;
    FTrans         := DataMod.getNewTransaction(Fcnx);
    FNODEID        := aNodeID;
    FGENID         := aGENID;
    FMinKVERSION   := aMinKVERSION;
    FMaxKVERSION   := aMaxKVERSION;
end;

procedure TQueryMVTThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;


procedure TQueryMVTThread.Execute;
var vQuery  : TFDQuery;
    i       : integer;
    vQMVT   : TFDQuery;
begin
    vQuery := DataMod.GetNewQuery(FCnx,nil);
    try
      vQMVT := DataMod.GetNewQuery(FCnx,FTrans);
      vQMVT.Close;
      vQMVT.SQL.Clear;
      vQMVT.SQL.Add('EXECUTE PROCEDURE EASY_MVT_LAME2MAG(:KID,:TONODE);');

      vQuery.Close;
      vQuery.SQL.Add('SELECT K_ID FROM K WHERE K_VERSION BETWEEN :ADEB AND :AFIN');
      vQuery.SQL.Add(' ORDER BY K_VERSION');
      vQuery.ParamByName('ADEB').Asinteger := FMINKVERSION;
      vQuery.ParamByName('AFIN').Asinteger := FMAXKVERSION;
      vQuery.OptionsIntf.FetchOptions.Unidirectional:=true;

      vQuery.Open();
      i:=0;
      while not(vQuery.Eof) do
        begin
            if (i mod 450=0) then
              begin
                 If (FTrans.Active)
                  then
                    begin
                      FTrans.Commit;
                      Sleep(100);
                      //
                      Synchronize(ProgressCallBack);
                      // un petit synchronize ???
                      FTrans.StartTransaction;
                    end
                 else FTrans.StartTransaction;
              end;
            if (FTrans.Active)
             then
                begin
                  vQMVT.Close;
                  vQMVT.ParamByName('KID').AsInteger:=vQuery.FieldByName('K_ID').AsInteger;
                  vQMVT.ParamByName('TONODE').Asstring:=FNODEID;
                  vQMVT.ExecSQL;
                end;
             Inc(i);
             vQuery.Next;
        end;
       //
       If (FTrans.Active)
         then FTrans.Commit;
      vQMVT.Close;
      vQuery.Close;
    finally
      vQuery.DisposeOf;
      vQMVT.DisposeOf;
    end;
end;



constructor TQueryDeltaThread.Create(ACnx:TFDConnection; aQuery:TFDQuery; aGENID:Integer; aEvent:TNotifyEvent=nil);
begin
  inherited Create(True);
  FCnx   := aCnx;
  FQuery := aQuery;
  FGENID     := aGENID;
  FMinKVERSION  := 0;
  FMaxKVERSION  := Int32.MaxValue;
  OnTerminate := AEvent;
  FreeOnTerminate := True;
end;

procedure TQueryDeltaThread.Execute;
begin
  try
    if Pos('SELECT',FQuery.SQL.Text)=1
      then FQuery.Open;

    if not(FQuery.IsEmpty) then
      begin
        FMinKVERSION := FQuery.Fields[0].AsInteger;
        FMaxKVERSION := FQuery.Fields[1].AsInteger;
        FCOUNT       := FQuery.Fields[2].AsInteger;
      end;
  except
    FMinKVERSION := 0;
    FMaxKVERSION := 0;
  end;
end;




constructor TQueryThread.Create(ACnx:TFDConnection; aQuery:TFDQuery; aEvent:TNotifyEvent=nil);
begin
  inherited Create(True);
  FCnx   := aCnx;
  FQuery := aQuery;
  OnTerminate := AEvent;
  FreeOnTerminate := True;
end;

procedure TQueryThread.Execute;
begin
  try
    Resultat := 0;
    // Suivant le FQuery.

    if Pos('EXECUTE',FQuery.SQL.Text)=1
      then FQuery.ExecSQL;

    if Pos('SELECT',FQuery.SQL.Text)=1
      then FQuery.Open;

    if not(FQuery.IsEmpty) then
      begin
        Resultat := FQuery.Fields[0].AsInteger;
      end;
  except
    Resultat := -1;
  end;
end;

*)

function TDataMod.GetGenParam_80_1(aIBFile:string):string;
var vCnx   : TFDConnection;
    vQuery : TFDQuery;

begin
    Result := '';
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+aIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 ');
      vQuery.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=1                            ');
      vQuery.Open();
      if not(vQuery.IsEmpty) then
         begin
            result := vQuery.FieldByName('PRM_STRING').Asstring;
         end;
      vQuery.Close;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;



function TDataMod.MAJ_GENPARAM_Monitor(aIBFile:string;avalue:integer): boolean;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vID : integer;
    vInfos : TInfosDelosEASY;
begin
    vInfos := Get_Infos_Passage_DELOS2EASY(aIBFile);
    vCnx := getNewConnexion('SYSDBA@'+aIBFile);
    vQuery := getNewQuery(vCnx,nil);
    Result := false;
    try

      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 ');
      vQuery.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=2 AND PRM_POS=:BASID       ');
      vQuery.ParamByName('BASID').asinteger := vInfos.BAS_ID;
      vQuery.Open();
      vID := 0;
      if vQuery.recordCount=1 then
        begin
          vID := vQUery.FieldByName('PRM_ID').asinteger;
        end;
      vQuery.Close();

      if vID<>0 then
        begin
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT * FROM GENPARAM WHERE PRM_ID=:ID');
          vQuery.ParamByName('ID').asinteger := vID;
          vQuery.Open();

          vQuery.Edit;
          vQuery.FieldByName('PRM_INTEGER').asinteger := aValue;
          vQuery.Post;
          Result :=true;
        end;
      //
    finally
      vquery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

function TDataMod.GetNewTransaction(aConnection : TFDConnection) : TFDTransaction;
begin
  Result := TFDTransaction.Create(nil);
  Result.Connection := aConnection;
end;

function TDataMod.DesInstallationSymmetricDS(ASym:TSymmetricDS): Boolean;
var sdirectory:string;
    sProgUninstall:string;
begin
  setCurrentDir(ParamStr(0));
  sdirectory:=ParamStr(0);
  sProgUninstall:=ASym.Repertoire+'\Uninstaller\Uninstaller.jar';
  if ExecuterAdministrateur(VGSE.JavaPath+'\bin\javaw', Format('-jar %s', [sProgUninstall]), sdirectory) then
  else begin
    Result := False;
    Exit;
  end;

  if ExecuterAdministrateur('sc.exe','delete EASY','') then
  else begin
    Result := False;
    Exit;
  end;
  result:=true;
end;

procedure TDataMod.OpenFireWall(ASym:TSymmetricDS);
begin
  ShellExecute(0, 'Open' ,'netsh.exe',
      PWideChar(Format('advfirewall firewall add rule name="%s" dir=in action=allow protocol=TCP localport=%d-%d',[
        ASym.Nom,ASym.http,ASym.agent])), nil, SW_HIDE);

//  ShellExecute(0, 'Open' ,'netsh.exe',
//      PWideChar(Format('advfirewall firewall add rule name="%s" dir=out action=allow protocol=TCP localport=%d-%d',[
//      ASym.Nom,ASym.http,ASym.agent])), nil, SW_HIDE);
end;

procedure TDataMod.updateServiceACL(aName:string);
var
  vSDDL : string ;
  vResult : Cardinal ;
begin
  vSDDL := 'D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;RPWPDT;;;AU)' ;

  vResult := ShellExecute(0, 'Open' ,'sc.exe', PWideChar('sdset ' + Name + ' ' + vSDDL), nil, SW_HIDE) ;
{
  if vResult <= 32
    then Log.Log('Application', 'updateServiceACL', 'Log', 'Erreur lors de la mise à jour des droits : ' + IntToStr(vResult), logWarning, true, 0, ltLocal)
    else Log.Log('Application', 'updateServiceACL', 'Log', 'Droits mis à jour', logInfo, true, 0, ltLocal);
}
end;

// Installation de SymmetricDS
function TDataMod.InstallationSymmetricDS(ASym:TSymmetricDS;aStart:Boolean): Boolean;
Const
  REGEXP_VERSION      = '(\d+)\.(\d+)';
  REGEXP_RECUP_CHEMIN = '^"(.+)"|^(\S+)';
var
  Registre          : TRegistry;
  reExpression      : TPerlRegEx;
  ResInstallateur   : TResourceStream;
  sVersionJava      : string;
  sProgInstall      : TFileName;
  sAutoInstall      : TFileName;
//   sFichParams       : TFileName;  ne sert plus
  sCheminInterBase  : TFileName;
  sFichierConf      : TFileName;
  XMLFile           : TextFile;
  slConfFile        : TStringList;
  iIndex            : Integer;
  pos               : integer;
  vPos              : integer;
  vstring           : string;
  vSymDSjar         : TFileName;
begin
  sProgInstall  := IncludeTrailingPathDelimiter(ASym.Repertoire) + 'symmetric-pro-3.7.36-setup.jar';
  sAutoInstall  := IncludeTrailingPathDelimiter(ASym.Repertoire) + 'master-autoinstall.xml';

  {$REGION 'Vérification du répertoire d’installation'}
  // Journaliser('Vérification du répertoire d’installation.');
  if not(DirectoryExists(ASym.Repertoire)) then
  begin
    // Création du répertoire d'installation
    // Journaliser('Création du répertoire d’installation.');
    if not(ForceDirectories(ASym.Repertoire)) then
    begin
      // Le répertoire d'installation ne peux pas être créé
      // Journaliser('Le répertoire d’installation ne peux pas être créé.', NivErreur);
      Result := False;
      Exit;
    end;
  end;
  {$ENDREGION 'Vérification du répertoire d’installation'}

  {$REGION 'Extraction du programme d’installation'}
  // Il faut copier le fichier local vers
  // on sort l'install qui prend trop de place !
  // Journaliser('Extraction du programme d’installation.');
  try
    // CopyFile(PWideChar(VGSE.ExePath+'res\symmetric-pro-3.7.36-setup.jar'),PWideChar(sProgInstall),true);
    vSymDSjar := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'symmetric-pro-3.7.36-setup.jar';
    TFile.Copy(vSymDSjar,sProgInstall);
    {
    ResInstallateur := TResourceStream.Create(HInstance, 'SymmetricDS', RT_RCDATA);
    try
      ResInstallateur.SaveToFile(sProgInstall);
      // Journaliser('Programme d’installation extrait.');
    finally
      ResInstallateur.Free();
    end;
    }
    ResInstallateur := TResourceStream.Create(HInstance, 'masterautoinstall', RT_RCDATA);
    try
      ResInstallateur.SaveToFile(sAutoInstall);
      // Journaliser('Paramétrage d’installation extrait.');
    finally
      ResInstallateur.Free();
    end;
  except
    on e: Exception do
    begin
      // Impossible d'extraire les ressources
      // Journaliser('Impossible d’extraire les ressources.', NivErreur);
      Result := False;
      Exit;
    end;
  end;

  {$ENDREGION 'Extraction du programme d’installation'}

  {$REGION 'Modification des paramètres d’installation automatique'}

  // Chargement du fichier XML

  // Enregistrement du fichier XML modifié
  With TStringList.create do
    try
        LoadFromfile(sAutoInstall);
        Text:=Replacetext(Text,'%installpath%',ASym.Repertoire);
        Text:=Replacetext(Text,'%servicename%',ASym.Nom);
        Text:=Replacetext(Text,'%agent%',IntToStr(ASym.agent));
        Text:=Replacetext(Text,'%http%',IntToStr(ASym.http));
        Text:=Replacetext(Text,'%https%',IntToStr(ASym.https));
        Text:=Replacetext(Text,'%jmx%',IntToStr(ASym.jmx));
        Text:=Replacetext(Text,'%programmegroup%',ASym.Nom);
        SaveTofile(sAutoInstall);
    finally
        free;
    end;
  {$ENDREGION 'Modification des paramètres d’installation automatique'}

  {$REGION 'Lancement du programme d’installation en mode automatique'}
  // Mode caché
  if ExecuterAdministrateur(VGSE.JavaPath + '\bin\javaw', Format('-jar %s %s', [sProgInstall, sAutoInstall]), ASym.Repertoire) then
  // if ExecuterAdministrateur(VGSE.JavaPath + '\bin\java', Format('-jar %s %s', [sProgInstall, sAutoInstall]), ASym.Repertoire) then
  else begin
    Result := False;
    Exit;
  end;
  {$ENDREGION 'Lancement du programme d’installation en mode automatique'}

  {$REGION 'Chemin JAVA dans environnement SymmetricDS'}
  with TStringList.Create do
      try
        LineBreak := #10;
        LoadFromFile(Format('%s\bin\setenv.bat',[ASym.Repertoire]));

        vPos := IndexOf('set SYM_JAVA=java');
        if vPos>-1 then
            begin
                 Strings[vPos]:='@REM '+Strings[vPos];
            end;
        vPos := IndexOf('if /i NOT "%JAVA_HOME%" == "" set SYM_JAVA=%JAVA_HOME%\bin\java');
        if vPos>-1 then
            begin
               Strings[vPos]:='@REM '+Strings[vPos];
            end;
        Insert(vPos+1,'set SYM_JAVA='+VGSE.JavaPath+'\bin\java');
        SaveToFile(Format('%s\bin\setenv.bat',[ASym.Repertoire]));
      finally
        Free;
      end;
  {$ENDREGION 'Chemin JAVA dans environnement SymmetricDS'}

  //DOTO il semblerait que l'installation du service ne respect pas les "\" "/" de la variable d'environnement
  // en effet le fichier  setenv qu'on vient pourtant de modifier
  // dans le fichier \bin\sym_service.conf on a quelquechose comme ça.
  // wrapper.java.command=C:\Ginkoia\JAVA\jre1.8.0_131/bin/java
  // alors que ca devrait être
  // wrapper.java.command=C:\Ginkoia\JAVA\jre1.8.0_131\bin\java
  // FAUT-il le changer ? avant l'installation du service ? ==> ca fonctionne aussi avec les '/' mais c'est quand même étrange

   // problème du "\" java
   // wrapper.java.command="C:\Ginkoia\JAVA\jre1.8.0_131" /bin/java
  {$REGION 'Problème du \ pour le service CCleaner voit ca comme une erreur'}
  slConfFile        := TStringList.Create();
  try
    sFichierConf                  := Format('%s\conf\sym_service.conf', [ExcludeTrailingPathDelimiter(ASym.Repertoire)]);
    slConfFile.NameValueSeparator := '=';
    slConfFile.LoadFromFile(sFichierConf);
    vstring := slConfFile.Values['wrapper.java.command'];
    slConfFile.Values['wrapper.java.command']  := StringReplace(vstring,'/','\',[rfReplaceAll]);
    slConfFile.SaveToFile(sFichierConf);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Problème du \ pour le service CCleaner voit ca comme une erreur'}

  {$REGION 'Installation du service'}
  if ExecuterAdministrateur(ASym.Repertoire +'\bin\sym_service.bat','install', ASym.Repertoire+'\bin\') then
    //
  else begin
    Result := False;
    Exit;
  end;

  // Si Lame mettre le service en "Manuel"
  if ASym.IsLame then
    begin
      // Si echec pas grave...
      ExecuterAdministrateur('C:\windows\system32\sc.exe',Format('config %s start=demand',[ASym.Nom]),'C:\windows\system32\');
      // il faut aussi modifier le fichier sym_service.conf à la ligne
      // car si on déinstall et réinstall le service on repasse en "wrapper.ntservice.starttype"
      // ==> Cel est fait un peu plus bas...
    end;
  {$ENDREGION 'Installation du service'}

  // Vérification du service SymmetricDS
  {
  if ServiceExiste(ASym.Nom) then
  begin
     if ExecuterAdministrateur(ASym.Repertoire +'\bin\sym_service.bat','start', ASym.Repertoire+'\bin\')
      then Sleep(5000);
  end
  else begin
    // Journaliser('Erreur lors de la vérification du service SymmetricDS.', NivErreur);
    Result := False;
    Exit;
  end;
  ServiceStop('',ASym.Nom);
  }
  { On ne supprime plus les fichiers d'install c'etait quoi "sFichParams" ?
  if not(MettreCorbeille(sProgInstall) and MettreCorbeille(sFichParams)) then
  begin
    // Journaliser('Erreur lors de la suppression des fichiers d’installation.', NivErreur);
  end;
  }

  {$REGION 'Récupération du chemin d’InterBase'}
  reExpression      := TPerlRegEx.Create();
  try
    try
      sCheminInterBase          := InfoSurService('IBS_gds_db').BinaryPathName;
      reExpression.RegEx        := REGEXP_RECUP_CHEMIN;
      reExpression.Subject      := sCheminInterBase;

      if reExpression.Match() then
        begin
          //
          sCheminInterBase := reExpression.Groups[0];
          // sCheminInterBase := reExpression.Groups[1] + reExpression.Groups[2];
        end;

      sCheminInterBase   := ExtractFilePath(sCheminInterBase);
    except
      on E: Exception do
      begin
//        Journaliser(Format('Erreur lors de la récupération du chemin d’InterBase.' + sLineBreak + '%s - %s',
//          [E.ClassName, E.Message]), NivErreur);
        Result := False;
        Exit;
      end;
    end;
  finally
    reExpression.Free();
  end;
  {$ENDREGION 'Récupération du chemin d’InterBase'}

  {$REGION 'Installation des UDF de SymmetricDS'}
//  Journaliser('Installation des UDF de SymmetricDS.');
  if not(FileExists(Format('%s\..\UDF\sym_udf.dll', [ExcludeTrailingPathDelimiter(sCheminInterBase)])))
      then
          begin
              if not(CopierFichier(Format('%s\databases\interbase\sym_udf.dll', [ExcludeTrailingPathDelimiter(ASym.Repertoire)]),
                  Format('%s\..\UDF\sym_udf.dll', [ExcludeTrailingPathDelimiter(sCheminInterBase)])))
                  then
                    begin
                      Result := False;
                      Exit;
                    end;
          end;
  {$ENDREGION 'Installation des UDF de SymmetricDS'}

  {$REGION 'Installation de InterClient'}
  if not(CopierFichier(Format('%s\..\SDK\lib\interclient.jar', [ExcludeTrailingPathDelimiter(sCheminInterBase)]),
                Format('%s\lib\interclient.jar', [ExcludeTrailingPathDelimiter(ASym.Repertoire)])))
    then
      begin
        try
          ResInstallateur := TResourceStream.Create(HInstance, 'interclientjar', RT_RCDATA);
          try
            ResInstallateur.SaveToFile(Format('%s\lib\interclient.jar', [ExcludeTrailingPathDelimiter(ASym.Repertoire)]));
            // Journaliser('Paramétrage d’installation extrait.');
          finally
            ResInstallateur.Free();
          end;
        except
          // rien
        end;
      end;
   // Test si le fichier est bien présent maintenant
   if Not(FileExists(Format('%s\lib\interclient.jar', [ExcludeTrailingPathDelimiter(ASym.Repertoire)])))
    then
      begin
          Result := False;
          Exit;
      end;

  {$ENDREGION 'Installation de InterClient'}

  {$REGION 'Configuration de Java pour SymmetricDS'}
  slConfFile        := TStringList.Create();
  try
    sFichierConf                  := Format('%s\conf\sym_service.conf', [ExcludeTrailingPathDelimiter(ASym.Repertoire)]);
    slConfFile.NameValueSeparator := '=';
    slConfFile.LoadFromFile(sFichierConf);

    // Passe en mode serveur
    iIndex:=1;
    while slConfFile.IndexOfName(Format('wrapper.java.additional.%d',[iIndex]))>-1 do
      begin
        pos:=slConfFile.IndexOfName(Format('wrapper.java.additional.%d',[iIndex]));
        inc(iIndex);
      end;
    // sur certains poste il ne faut pas mettre la ligne suivante...
    {
    if ASym.server_java
      then
          begin
              slConfFile.Insert(Pos+1,Format('wrapper.java.additional.%d=-server',[iIndex]));
              inc(iIndex);
          end;
    }
    slConfFile.Insert(Pos+2,Format('wrapper.java.additional.%d=-Dfile.encoding=ISO8859_15',[iIndex]));
    inc(iIndex);
    slConfFile.Insert(Pos+3,Format('wrapper.java.additional.%d=-XX:-UseGCOverheadLimit',[iIndex]));
    inc(iIndex);

    // Change les tailles pour la RAM allouée 1024 sur les magasins ca serait mieux...
    slConfFile.Values['wrapper.java.initmemory']      := IntToStr(ASym.memory);
    slConfFile.Values['wrapper.java.maxmemory']       := IntToStr(ASym.memory);

    // Si LAME et si on désinstall et réinstall le service il faut bien etre en Manuel
    if ASym.IsLame then
      begin
        slConfFile.Values['wrapper.ntservice.starttype']  := 'manual';
      end;

    slConfFile.SaveToFile(sFichierConf);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Configuration de Java pour SymmetricDS'}

  {$REGION 'Configuration de SymmetricDS 3.7.36 pour InterBase'}
  slConfFile        := TStringList.Create();
  try
    sFichierConf                  := Format('%s\conf\symmetric.properties', [ExcludeTrailingPathDelimiter(ASym.Repertoire)]);
    slConfFile.NameValueSeparator := '=';

    // Change l'"initial load"
    slConfFile.Values['initial.load.concat.csv.in.sql.enabled'] := 'true';

    slConfFile.SaveToFile(sFichierConf);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Configuration de SymmetricDS 3.7.10 pour InterBase'}

  {$REGION 'ACL'}
   UpdateServiceACL(ASym.Nom);
  {$ENDREGION 'ACL'}

  {$REGION 'Firewall'}
  if ASym.IsLame  // Seulement si on est une Lame
    then OpenFireWall(ASym);
  {$ENDREGION 'Firewall'}

  {$REGION 'Grants - Uniquement en MAG'}
  // ne fonctionne pas !
  if not(ASym.IsLame)  // Seulement si on est un MAG
    then
      begin
        ResInstallateur := TResourceStream.Create(HInstance, 'grants', RT_RCDATA);
        try
          ResInstallateur.SaveToFile(IncludeTrailingPathDelimiter(ASym.Repertoire) + 'grants.sql');
        finally
          ResInstallateur.Free();
        end;
      end;
  {$ENDREGION 'Grants - Uniquement en MAG'}

  {$REGION 'Démarrage du service SymmetricDS'}
  if aStart then
    try
      ServiceStart('',ASym.Nom);
    except
      on E: Exception do
      begin
        Result := False;
        Exit;
      end;
    end;
  {$ENDREGION 'Démarrage du service SymmetricDS'}


  Result := True;
end;

//------------------------------------------------------------------------------
procedure TDataMod.Ouverture_IBFile(var ADossierInfos:TDossierInfos);
const
  USERID    = 'ginkoia';
  FIRSTNAME = 'Ginkoia';
  LASTNAME  = FIRSTNAME;
  EMAIL     = 'ginkoia@ginkoia.fr';
  PASSWORD  = 'ch@mon1x';
var
  sNomDossier           : string;
  sAdresseURL           : string;
  sFichierConf          : TFileName;
  slConfFile            : TStringList;
  slListeTables         : TStringList;
  ResScripts            : TResourceStream;
  FicSymGrants          : TFileName;
  FicSymProcedures      : TFileName;
  i, j                  : Integer;
  bNoeudCorrecte        : Boolean;
  QueScript             : TFDQuery;
  version               : string;
  majorversion          : string ;
  vCnx                  : TFDConnection;
begin
    {$REGION 'Connexion à la base de données'}
    vCnx := getNewConnexion('SYSDBA@'+ADossierInfos.DatabaseFile);
    {$ENDREGION 'Connexion à la base de données'}

    // controle de la version...
    QueScript:= getNewQuery(vCnx,nil);
    try
      try
        QueScript.SQL.Clear();
        QueScript.SQL.Add('SELECT * FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
        QueScript.Open();
        if not(QueScript.IsEmpty) then
          begin
            ADossierInfos.Version:=QueScript.FieldByName('VER_VERSION').Asstring;
          end;
        QueScript.Close;

        QueScript.SQL.Clear();
        QueScript.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 ');
        QueScript.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=1                            ');
        QueScript.Open();
        if not(QueScript.IsEmpty) then
         begin
            ADossierInfos.RegistrationUrl := QueScript.FieldByName('PRM_STRING').Asstring;
         end;
        QueScript.Close;

        QueScript.SQL.Clear();
        QueScript.SQL.Add('SELECT * FROM GENPARAMBASE WHERE PAR_NOM=:NOM');
        QueScript.ParamByName('NOM').asstring := 'IDGENERATEUR';
        QueScript.Open();
        if not(QueScript.IsEmpty) then
          begin
            ADossierInfos.BAS_IDENT:=QueScript.FieldByName('PAR_STRING').asinteger;
          end;
        QueScript.Close;

        QueScript.Close;
        QueScript.SQL.Clear();
        QueScript.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
        QueScript.Open();
        If (QueScript.RecordCount=1) then
           begin
              ADossierInfos.GENERAL_ID := FormatFloat(',0',QueScript.Fields[0].AsFloat);
           end;
        //----------------------------------------------------------------------
        QueScript.Close;
        QueScript.SQL.Clear();
        QueScript.SQL.Add('SELECT BAS_GUID, BAS_SENDER, BAS_PLAGE ');
        QueScript.SQL.Add(' FROM   GENBASES       ');
        QueScript.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1)');
        QueScript.SQL.Add('  WHERE BAS_IDENT=:BASIDENT ');
        QueScript.ParamByName('BASIDENT').AsString:=IntToStr(ADossierInfos.BAS_IDENT);
        QueScript.Open();
        if not(QueScript.IsEmpty) then
          begin
            ADossierInfos.BAS_GUID   := QueScript.Fields[0].AsString;
            ADossierInfos.BAS_SENDER := QueScript.Fields[1].AsString;
            ADossierInfos.BAS_PLAGE  := QueScript.Fields[2].AsString;
          end;
        QueScript.Close;


        QueScript.SQL.Clear();
        QueScript.SQL.Add('SELECT BAS_SENDER , BAS_IDENT, BAS_NOMPOURNOUS, BAS_CENTRALE, BAS_GUID ');
        QueScript.SQL.Add(' FROM   GENBASES       ');
        QueScript.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1)');
        QueScript.SQL.Add('  WHERE BAS_IDENT<>'''' ');
        QueScript.Open();
        while not(QueScript.eof) do
          begin
              if QueScript.FieldByName('BAS_IDENT').AsString='0' then
                begin
                    ADossierInfos.Nom:=Lowercase(QueScript.FieldByName('BAS_NOMPOURNOUS').Asstring);
                    ADossierInfos.IsOk:=true;
                end
              else
                begin
                    i:=Length(ADossierInfos.ListBases);
                    SetLength(ADossierInfos.ListBases,i+1);
                    ADossierInfos.ListBases[i].BAS_SENDER := QueScript.FieldByName('BAS_SENDER').Asstring;
                    ADossierInfos.ListBases[i].SYM_NODE   := Sender_To_Node(QueScript.FieldByName('BAS_SENDER').Asstring);
                    ADossierInfos.ListBases[i].BAS_IDENT  := StrToIntDef(QueScript.FieldByName('BAS_IDENT').AsString,-1);
                    ADossierInfos.ListBases[i].BAS_GUID   := QueScript.FieldByName('BAS_GUID').Asstring;
                    ADossierInfos.ListBases[i].BAS_CENTRALE := QueScript.FieldByName('BAS_CENTRALE').Asstring;
                end;
              QueScript.Next;
          end;

         //Liste des Tables a exclure
         // ADossierInfos.TablesExclues := Liste_Tables_Exclues(vCnx);

        except
          on E: Exception do
          begin
            ADossierInfos.IsOk:=false;
          end;
      end;
      QueScript.Close();
    finally
      QueScript.DisposeOf;
      vCnx.DisposeOf;
      //      FdcConnection.Close();
    end;
end;

{
function TDataMod.EASY_PUSH_MISSING_DELOS():string;
var vQuery : TFDQuery;
    vBas_Ident : string;
    vPlage : string;
    vDebut,vFin : integer;

begin
   // controle de la version...
   vQuery:= getNewQuery(aCnx,nil);
    try
      try

      except
        result :='!!!ERREUR!!!'
      end;
    finally
      vQuery.DisposeOf;
    end;
end;
}

function TDataMod.Liste_Tables_Exclues(aCnx:TFDConnection):string;
var vTABLE      : string;
    vseparateur : string;
    vQuery      : TFDQuery;
begin
   result:='';
   vseparateur := '';
   // controle de la version...
   vQuery:= getNewQuery(aCnx,nil);
    try
      try
        vQuery.Close();
        vQuery.SQL.Clear;
        vQuery.SQL.Add('SELECT RDB$RELATION_NAME,                                     ');
        vQuery.SQL.Add('    CASE                                                      ');
        vQuery.SQL.Add('        WHEN F_LEFT(KTB_DATA, F_SUBSTR('','',KTB_DATA))=''''  ');
        vQuery.SQL.Add('            THEN KTB_DATA                                     ');
        vQuery.SQL.Add('            ELSE F_LEFT(KTB_DATA, F_SUBSTR('','',KTB_DATA))   ');
        vQuery.SQL.Add('    END                                                       ');
        vQuery.SQL.Add(' FROM RDB$RELATIONS                                           ');
    //  vQuery.SQL.Add('            LEFT JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME ');
        vQuery.SQL.Add('            JOIN KTB ON KTB_NAME=RDB$RELATION_NAME         ');
        vQuery.SQL.Add('            WHERE ((RDB$SYSTEM_FLAG = 0) OR                ');
        vQuery.SQL.Add('            (RDB$SYSTEM_FLAG IS NULL)) AND                 ');
        vQuery.SQL.Add('            (RDB$VIEW_SOURCE IS NULL)  AND                 ');
        vQuery.SQL.Add('            (RDB$RELATION_NAME!=''INVIMGSTK'') AND         ');
        // Exclusion des TABLES K2, KFLD, KTB car on doit pouvoir les créer partout lame et mag indépendament
        vQuery.SQL.Add('            (RDB$RELATION_NAME NOT IN (''K2'',''KFLD'',''KTB'')) ');
    //    vQuery.SQL.Add('            AND TRIGGER_ID IS NULL                         ');
        vQuery.SQL.Add('            ORDER BY RDB$RELATION_NAME                     ');
        vQuery.open;
        while not(vQuery.eof) do
          begin
             vTable:=vQuery.FieldByName('RDB$RELATION_NAME').asstring;
             // Controle longueur total des champs de cette table
             if not(Controle_Longueur_Champs_Table(aCnx,vTABLE))
              then
                  begin
                     result:=Result + vseparateur + vTable;
                     vseparateur := ' ';
                  end;
             vQuery.Next;
          end;
      except
        result :='!!!ERREUR!!!'
      end;
    finally
      vQuery.DisposeOf;
    end;
end;

function TDataMod.Controle_Longueur_Champs_Table(aCnx:TFDConnection;aTABLE:string):boolean;
var vQuery  : TFDQuery;

begin
    result:=false;
    {$ENDREGION 'Connexion à la base de données'}
    // controle de la version...
    vQuery:= getNewQuery(aCnx,nil);
    try
      try
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT r.RDB$RELATION_NAME,   ');
        vQuery.SQL.Add('    SUM(                      ');
        vQuery.SQL.Add('        CASE f.RDB$FIELD_TYPE ');
        vQuery.SQL.Add('          WHEN 27 THEN 27     ');
        vQuery.SQL.Add('          WHEN 10 THEN 27     ');
        vQuery.SQL.Add('          WHEN 8 THEN 14      ');
        vQuery.SQL.Add('          WHEN 12 THEN 15     ');
        vQuery.SQL.Add('          WHEN 16 THEN 22     ');
        vQuery.SQL.Add('          WHEN 13 THEN 15     ');
        vQuery.SQL.Add('          WHEN 35 THEN 25     ');
        vQuery.SQL.Add('          WHEN 37 THEN f.RDB$FIELD_LENGTH+3 ');
        vQuery.SQL.Add('          ELSE 5000           ');
        vQuery.SQL.Add('        END) AS NBCHAR        ');
        vQuery.SQL.Add('   FROM RDB$RELATION_FIELDS r ');
        vQuery.SQL.Add('   LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME');
        vQuery.SQL.Add('WHERE r.RDB$RELATION_NAME=:ATABLE');
        vQuery.SQL.Add('GROUP BY r.RDB$RELATION_NAME ');
        vQuery.ParamByName('ATABLE').AsString:=aTABLE;
        vQuery.open();
        if not(vQuery.IsEmpty) then
          begin
             result := vQuery.FieldByName('NBCHAR').AsInteger<=4070;   // 4096  avec tous les ","
          end;
        vQuery.Close();
      except
        result:=false;
      end;
    finally
      vQuery.DisposeOf;
    end;
end;

// Delete physique du GENPARAM et du K
function TDataMod.DeleteGenParamURL(aIBFile:string):boolean;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vID : integer;
begin
    result := false;
    vID := 0;
    vCnx := getNewConnexion('SYSDBA@'+aIBFile);
    vQuery := getNewQuery(vCnx,nil);
    vQuery.OptionsIntf.UpdateOptions.AutoCommitUpdates:=true;
    try
      try
         vQuery.Close;
         vQuery.SQL.Clear;
         vQuery.SQL.Add('SELECT PRM_ID FROM GENPARAM           ');
         vQuery.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=1     ');
         vQuery.Open();
         if not(vQuery.ISEmpty) then
         begin
           vID := vQuery.FieldByName('PRM_ID').AsInteger;
         end;
         vQuery.Close;
         if vID<>0 then
            begin
               vQuery.Close;
               vQuery.SQL.Clear;
               vQuery.SQL.Add('DELETE FROM K WHERE K_ID=:KID;');
               vQuery.ParamByName('KID').AsInteger:=vID;
               vQuery.ExecSQL;

               vQuery.Close;
               vQuery.SQL.Clear;
               vQuery.SQL.Add('DELETE FROM GENPARAM WHERE PRM_ID=:PRMID;');
               vQuery.ParamByName('PRMID').AsInteger:=vID;
               vQuery.ExecSQL;

               result:=true;
            end;
      except
         On E:Exception do
          begin
             result:=False;
             Raise;
          end;
      end;
    finally
      vquery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


function TDataMod.SetGenParamURL(aIBFile:string;aURL:string):Boolean;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vID : integer;
begin
    vCnx := getNewConnexion('SYSDBA@'+aIBFile);
    vQuery := getNewQuery(vCnx,nil);
    try
      vQuery.SQL.Clear;
      vQuery.SQL.Add('EXECUTE PROCEDURE SM_CREER_PARAM(80,1,''URL de synchronisation EASY'',''http://'',0,0,0,0);');
      vQuery.ExecSQL;

      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 ');
      vQuery.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=1                            ');
      vQuery.Open();
      vID := 0;
      if vQuery.recordCount=1 then
        begin
          vID := vQUery.FieldByName('PRM_ID').asinteger;
        end;
      vQuery.Close();

      if vID<>0 then
        begin
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT * FROM GENPARAM WHERE PRM_ID=:ID');
          vQuery.ParamByName('ID').asinteger := vID;
          vQuery.Open();

          vQuery.Edit;
          vQuery.FieldByName('PRM_STRING').asstring := aURL;
          vQuery.Post;

        end;
    finally
      vquery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


// Lors d'une Migration de la lame il faut ajouter certaines tables... à la main
function TDataMod.MAJ_Ajoute_TABLE_REPLIC(AIBFile:string;aTABLENAME,aKEYFIELD:string):boolean;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vID : integer;
begin
    vCnx := getNewConnexion('SYSDBA@'+aIBFile);
    vQuery := getNewQuery(vCnx,nil);
    result:=false;

    try
      try
      vQuery.SQL.Clear;
      vQuery.SQL.Add('INSERT INTO SYM_TRIGGER(TRIGGER_ID, SOURCE_TABLE_NAME, CHANNEL_ID, SYNC_KEY_NAMES, LAST_UPDATE_TIME, CREATE_TIME, SYNC_ON_DELETE, SYNC_ON_INCOMING_BATCH) VALUES(:TABLENAME1, :TABLENAME2,''default'',:KEYFIELD, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, 1);');
      vQuery.ParamByName('TABLENAME1').AsString:=aTABLENAME;
      vQuery.ParamByName('TABLENAME2').AsString:=aTABLENAME;
      vQuery.ParamByName('KEYFIELD').AsString:=aKeyField;
      vQuery.ExecSQL;

      vQuery.SQL.Clear;
      vQuery.SQL.Add('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (:TABLENAME,''lame_vers_mags'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);');
      vQuery.ParamByName('TABLENAME').AsString:=aTABLENAME;
      vQuery.ExecSQL;

      vQuery.SQL.Clear;
      vQuery.SQL.Add('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (:TABLENAME,''mags_vers_lame'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);');
      vQuery.ParamByName('TABLENAME').AsString:=aTABLENAME;
      vQuery.ExecSQL;

      result:=true;

      except
        Result :=false;
      end;
    finally
      vquery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


// Installation des dossiers
function TDataMod.Installation_Master(ADossierInfos:TDossierInfos): Boolean;
const
  USERID    = 'ginkoia';
  FIRSTNAME = 'Ginkoia';
  LASTNAME  = FIRSTNAME;
  EMAIL     = 'ginkoia@ginkoia.fr';
  PASSWORD  = 'ch@mon1x';
var
  sNomDossier           : TFileName;
  sFile                 : TStringList;
  FicMaster             : TFileName;
  v182                  : TFileName;
  SrvFileSql            : TStringList;
  slConfFile            : TStringList;
  ResScripts            : TResourceStream;
  i, j                  : Integer;
  bNoeudCorrecte        : Boolean;
  sEngine               : string;
  vPropertiesFile       : string;
  vPlage                : integer;
  vMin                  : integer;
  vHr                   : Integer;
  vCron5                : string;    // Purge.outgoing
  vCron6                : string;    // Purge.incoming
  vCron7                : string;    // Synctriggers

begin
  Result := False;

  // Vérifie que le nom de dossier ne comporte pas d'espaces
  for i := 1 to Length(ADossierInfos.Nom) do
  begin
    if not(ADossierInfos.Nom[i] in ['0'..'9', 'A'..'Z', 'a'..'z', '-', '_']) then
    begin
      Result := False;
      Exit;
    end;
  end;

  sNomDossier := LowerCase(ADossierInfos.Nom);

  FicMaster  := IncludeTrailingPathDelimiter(ADossierInfos.SymDir) + 'master-v15.sql';
  // DeleteFile(FicMaster);

  vPropertiesFile   := Format('%s\engines\%s.properties',
    [ExcludeTrailingPathDelimiter(ADossierInfos.SymDir), sNomDossier]);
  // DeleteFile(ADossierInfos.PropertiesFile);

  //  sAdresseURL := ADossierInfos.Nom;
  // if sAdresseURL[High(sAdresseURL)] = '/' then
  //  SetLength(sAdresseURL, Length(sAdresseURL) - 1);
  //  Construction du fichier sql qui sera executer au permier lancement
    try
      ResScripts := TResourceStream.Create(HInstance, 'masterv15', RT_RCDATA);
      try
        ResScripts.SaveToFile(FicMaster);
      finally
        ResScripts.Free();
      end;
    finally
//
    end;

  //
  SrvFileSql := TStringList.Create();
  try
    SrvFileSql.LoadFromFile(FicMaster,TEncoding.ANSI);

//  SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%master-grp%',sNomDossier+'-master-grp');

    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%master-id%',sNomDossier+'-id');
//  SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%mags-grp%',sNomDossier+'-mags-grp');

    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%ip%',VGSE.HostName);
    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%port%',IntToStr(ADossierInfos.httpport));
    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%master%',sNomDossier);

    // Calcul Savant suivant le Port.....
    vPlage := ADossierInfos.httpport - VGSE.EASY_PORTS;
    // environ 50 dossiers par lame ==> 50 plages donc de 40000 à 40500
    // exemple 40000 ==> vPlage = 40405 - 40000 = 405
    // Comme on a environ 4h chez ISF pour le faire avant que MDC se lance on a 240 minutes
    // règle de 3
    //   500 ==> 240  ==> 4:00 du matin
    // 40005 ==> 0    ==> 0:00 du matin (mais il y a des trucs qui tourne à minuit)
    //   405 ==> 405*240/500  soit environ 405*0.5 = 202 ==> 202 ème minuit de la nuit ==> nous donne un horaire
    // Calcul du Cron des Triggers vCron7

    vMin   := (vPlage div 2) mod 60;
    vHr    := (vPlage div 120);
    vCron7 := Format('0 %d %d * * *',[vMin,vHr]);

    // Pour la purge.... il faut etaler sur une heure uniquement car c'est de 7h du mat à 20h toutes les 2 hrs
    // il faudra voir si ca ne fait pas des pics les heures paires ou impaires...
    // une simple division par dix donne un bon truc...
    // faire un Mod 60 pour plus de sécurité pour pas que ca dépasse 60 !
    vMin := (vPlage div 10) mod 60;
    vCron5 := Format('0 %d 7-20/2 * * *',[vMin]);

    // le Cron6 ne doit plus prendre de temps (tps=0) car on ne stock plus les incoming
    vCron6 := Format('0 %d 7-20/2 * * *',[(vMin+1) mod 60]);

    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%job.purge.outgoing.cron%',vCron5);
    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%job.purge.incoming.cron%',vCron6);
    SrvFileSql.Text:=ReplaceText(SrvFileSql.Text,'%job.synctriggers.cron%',vCron7);

    // il faudrait ecrire les TRIGGER parce qu'avec une procédure stokée ca ne passe pas
    // faudrait se connecter à la base et

    // les TABLES lcl ne sont plus installé comme cela
    SrvFileSql.Text :=  SrvFileSql.Text + #13 + #10
            + ScriptTriggersManquants(ADossierInfos.DatabaseFile).Text;

    {
     v182  := IncludeTrailingPathDelimiter(ADossierInfos.SymDir) + 'v18.2.lcl';
     try
       ResScripts := TResourceStream.Create(HInstance, 'v18_2_lcl', RT_RCDATA);
       try
         ResScripts.SaveToFile(v182);
        finally
         ResScripts.Free();
       end;
     finally

     end;

    // Si V18.2
    if (ADossierInfos.Version>'18.1.0.9999') and (ADossierInfos.Version<='18.2.0.9999')
      then
        begin
          SrvFileSql.Text :=  SrvFileSql.Text + #13 + #10
            + ScriptTriggersManquantsLCL(v182).Text;
        end;
    }


    // le nom faut l'adapter au dossier !!  evidement
    FicMaster := ReplaceStr(Format('%s\master-%s.sql',[ExcludeTrailingPathDelimiter(ADossierInfos.SymDir),sNomDossier]), '\', '/');
    SrvFileSql.SaveToFile(FicMaster,TEncoding.ANSI);
  finally
    SrvFileSql.Free;
  end;

//  Format('%s\master-v%s.sql',[ExcludeTrailingPathDelimiter(ADossierInfos.SymDir),ADossierInfos.Version]);

  {$REGION 'Création du fichier de propriétés'}
  slConfFile        := TStringList.Create();
  try
    slConfFile.NameValueSeparator             := '=';
    slConfFile.Values['external.id']          := sNomDossier+'-id';
    sEngine                                   := sNomDossier;
    slConfFile.Values['engine.name']          := sNomDossier;
    slConfFile.Values['group.id']             := 'lame';        // sNomDossier+'-master-grp';
    // slConfFile.Values['sync.url']             := Format('http\://%s\:%d/sync/%s',[VGSE.PublicIP,ADossierInfos.httpport,sNomDossier]);
    if (VGSE.HostName<>'')
      then slConfFile.Values['sync.url']             := Format('http\://%s\:%d/sync/%s',[VGSE.HostName,ADossierInfos.httpport,sNomDossier])
      else slConfFile.Values['sync.url']             := Format('http\://%s\:%d/sync/%s',[VGSE.PublicIP,ADossierInfos.httpport,sNomDossier]);

    // Il faut aller ecrire cette url de synchro dans la base avant l'installation des triggers
    if (VGSE.HostName<>'')
      then DataMod.SetGenParamURL(ADossierInfos.DatabaseFile,Format('http://%s:%d/sync/%s',[VGSE.HostName,ADossierInfos.httpport,sNomDossier]))
      else DataMod.SetGenParamURL(ADossierInfos.DatabaseFile,Format('http://%s:%d/sync/%s',[VGSE.PublicIP,ADossierInfos.httpport,sNomDossier]));

    slConfFile.Values['db.driver']            := 'interbase.interclient.Driver';
    slConfFile.Values['db.url']               := ReplaceStr('jdbc:interbase://localhost:3050/' + ReplaceStr(ADossierInfos.DatabaseFile, '\', '/'),':','\:');
    slConfFile.Values['db.user']              := 'SYSDBA';
    slConfFile.Values['db.password']          := 'masterkey';
    slConfFile.Values['db.validation.query']  := 'SELECT CAST(1 AS INTEGER) FROM RDB$DATABASE';
    slConfFile.Values['auto.config.registration.svr.sql.script']
         := ReplaceStr(Format('%s\master-%s.sql',[ExcludeTrailingPathDelimiter(ADossierInfos.SymDir),sNomDossier]), '\', '/');

    slConfFile.Add('registration.url=');
    slConfFile.SaveToFile(vPropertiesFile);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Création du fichier de propriétés'}
  Result := True;
end;


function TDataMod.Installation_Base(ADossierInfos:TDossierInfos): Boolean;
const
  USERID    = 'ginkoia';
  FIRSTNAME = 'Ginkoia';
  LASTNAME  = FIRSTNAME;
  EMAIL     = 'ginkoia@ginkoia.fr';
  PASSWORD  = 'ch@mon1x';
var
  sNomDossier           : TFileName;
  sFile                 : TStringList;
  FicMaster             : TFileName;
  SrvFileSql            : TStringList;
  slConfFile            : TStringList;
  ResScripts            : TResourceStream;
  i, j                  : Integer;
  bNoeudCorrecte        : Boolean;
  sEngine               : string;
  sGrp                  : string;
  vCmd                  : string;
begin
  Result := False;

  // Vérifie que le nom de dossier ne comporte pas d'espaces
  for i := 1 to Length(ADossierInfos.Nom) do
  begin
    if not(ADossierInfos.Nom[i] in ['0'..'9', 'A'..'Z', 'a'..'z', '-', '_']) then
    begin
      Result := False;
      Exit;
    end;
  end;

  sNomDossier := LowerCase(ADossierInfos.Nom);

  // on en fait rien du grant ???? et il est ou ?
  // FicMaster  := IncludeTrailingPathDelimiter(ADossierInfos.SymDir) + 'grant.sql';

  {$REGION 'Création du fichier de propriétés'}
  slConfFile        := TStringList.Create();
  try
    //    sGrp                                := sNomDossier+'-mags-grp';
    sGrp                                      := ADossierInfos.NODE_GROUP_ID;
    sEngine                                   := Format('%s-%s',[sGrp,ADossierInfos.ExternalID]);
    ADossierInfos.PropertiesFile              := Format('%s/engines/%s.properties',[ADossierInfos.SymDir,sEngine]);
    slConfFile.NameValueSeparator             := '=';
    slConfFile.Values['external.id']          := ADossierInfos.ExternalID;
    slConfFile.Values['engine.name']          := sEngine;
    slConfFile.Values['group.id']             := sGrp;
    slConfFile.Values['sync.url']             := Format('http\://%s\:%d/sync/%s',[GetComputerNetName,ADossierInfos.httpport,sEngine]);
    slConfFile.Values['db.driver']            := 'interbase.interclient.Driver';
    slConfFile.Values['db.url']               := ReplaceStr('jdbc:interbase://localhost:3050/' + ReplaceStr(ADossierInfos.DatabaseFile, '\', '/'),':','\:');
    slConfFile.Values['db.user']              := 'SYSDBA';
    slConfFile.Values['db.password']          := 'masterkey';
    slConfFile.Values['db.validation.query']  := 'SELECT CAST(1 AS INTEGER) FROM RDB$DATABASE';
    slConfFile.Values['registration.url']     := ReplaceStr(ADossierInfos.RegistrationUrl,':','\:');
    // pourquoi 2 fois la même ligne ? etrange Gilles 13/09/2007
    // slConfFile.Values['registration.url']     := ReplaceStr(ADossierInfos.RegistrationUrl,':','\:');
    // Grant GINKOIA sur les tables symmetricDS
    slConfFile.Values['auto.config.registration.svr.sql.script'] := IncludeTrailingPathDelimiter(ADossierInfos.SymDir) + 'grants.sql';
    // -------------------------------------------------
    slConfFile.SaveToFile(ADossierInfos.PropertiesFile);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Création du fichier de propriétés'}
  Result := True;

  ServiceStop('',ADossierInfos.ServiceName);

  // On passe en Service DelayedAutostart (REG_DWORD = 1)
  // Note you must have the space between the "start=" and the "delayed-auto" or it will not work.
  vCmd := Format('config %s start= delayed-auto',[ADossierInfos.ServiceName]);
  if ExecuterAdministrateur('sc.exe',vCmd,'') then
    //
    else begin
      Result := False;
    end;

  // Passage du Grant avant de redemarrer si a pas encore les tables symmetricDS ca ne fonctionnera pas)
  // c'est pour cela qu'on ajoute "auto.config.registration.svr.sql.script...
  Grant_SYMTABLE_TO_GINKOIA(ADossierInfos.DatabaseFile);
  // On le refait après la génération des triggers sur la base MAG... c'est mieux de le faire plus tard
  ServiceStart('',ADossierInfos.ServiceName);
end;

function TDataMod.Grant_SYMTABLE_TO_GINKOIA(const ABaseDonnees: TFileName):boolean;
var vCnx   : TFDConnection;
    vquery : TFDQuery;
    Tables : TStringList;
    i:integer;
begin
  result:=false;

  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  Tables := TStringList.Create;
  try
    try
    // Paramètre la connexion à la base de données
    {
    FdcConnection.Params.Clear();
    FdcConnection.Params.Add('DriverID=IB');
    FdcConnection.Params.Add('User_Name=SYSDBA');
    FdcConnection.Params.Add('Password=masterkey');
    FdcConnection.Params.Add(Format('Database=%s', [ABaseDonnees]));
    FdcConnection.Params.Add('Protocol=TCPIP');
    FdcConnection.Params.Add('Server=localhost');
    FdcConnection.Params.Add('Port=3050');
    }

    // vquery.Connection:=FdcConnection;

    vquery.SQL.Clear;
    vquery.SQL.Add('SELECT DISTINCT RDB$RELATION_NAME AS TABLENAME');
    vquery.SQL.Add(' FROM RDB$RELATION_FIELDS');
    vquery.SQL.Add('WHERE RDB$SYSTEM_FLAG=0 AND RDB$RELATION_NAME LIKE ''SYM_%'' ');

    vquery.Connection.open();
    vQuery.Open();
    while not(vQuery.Eof) do
      begin
          Tables.Add(vQuery.FieldByName('TABLENAME').AsString);
          vquery.Next;
      end;
    if Tables.Count<1
      then
          begin
              Result := false;
              exit;
          end;
    vquery.Close();
    for i:=0 to Tables.Count-1 do
      begin
          vquery.Close();
          vquery.SQl.Clear;
          vquery.SQL.Add(Format('GRANT ALL ON %s TO GINKOIA;',[Tables[i]]));
          // showmessage(Fquery.SQL.Text);
          vquery.ExecSQL;
      end;
     result:=true;
     Except On E:Exception
      do
        begin
            // showmessage(E.Message);
            result:=false;
        end;
    end;
    vquery.Close;
  finally
    Tables.Free;
    vquery.DisposeOf;
    vCnx.DisposeOf;
  end;
end;


// Nom de la base de données et serveur de réplication
function TDataMod.InfosReplication(const ABaseDonnees: TFileName): TInfosReplication;
const REGEXP_URL = 'http://([^:|/]+)*';
var reExpression      : TPerlRegEx;
    vQuery  : TFDQuery;
    vCnx    : TFDConnection;
begin
    vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
    vQuery := getNewQuery(vCnx,nil);
    try
      {
      QueURLReplic.Open();

      if not(QueURLReplic.IsEmpty) then
      begin
        Result.NomBase              := QueURLReplic.FieldByName('BAS_NOM').AsString;
        Result.ServeurReplication   := QueURLReplic.FieldByName('REP_URLDISTANT').AsString;

        // Récupére le nom du serveur dans l'URL
        reExpression  := TPerlRegEx.Create();
        try
          reExpression.RegEx        := REGEXP_URL;
          reExpression.Subject      := Result.ServeurReplication;

          if reExpression.Match() then
            Result.ServeurReplication   := reExpression.Groups[1];
        finally
          reExpression.Free();
        end;
      end
      else begin
        Result.NomBase              := '';
        Result.ServeurReplication   := '';
      end;
      }
      vQuery.SQL.Clear;
      vQuery.SQL.Add(' SELECT DISTINCT BAS_NOM, REP_URLDISTANT      ');
      vQuery.SQL.Add(' FROM   GENBASES                              ');
      vQuery.SQL.Add(' JOIN GENPARAMBASE     ON (PAR_STRING = BAS_IDENT AND PAR_NOM = ''IDGENERATEUR'') ');
      vQuery.SQL.Add(' JOIN GENLAUNCH        ON (LAU_BASID = BAS_ID)                        ');
      vQuery.SQL.Add(' JOIN K KLAU           ON (KLAU.K_ID = LAU_ID AND KLAU.K_ENABLED = 1) ');
      vQuery.SQL.Add(' JOIN GENREPLICATION   ON (REP_LAUID = LAU_ID AND REP_ORDRE > 0)      ');
      vQuery.SQL.Add(' JOIN K KREP           ON (KREP.K_ID = LAU_ID AND KREP.K_ENABLED = 1);');

      vQuery.Open();
      if not(vQuery.IsEmpty) then
      begin
        Result.NomBase              := vQuery.FieldByName('BAS_NOM').AsString;
        Result.ServeurReplication   := vQuery.FieldByName('REP_URLDISTANT').AsString;

        // Récupére le nom du serveur dans l'URL
        reExpression  := TPerlRegEx.Create();
        try
          reExpression.RegEx        := REGEXP_URL;
          reExpression.Subject      := Result.ServeurReplication;

          if reExpression.Match() then
            Result.ServeurReplication   := reExpression.Groups[1];
        finally
          reExpression.Free();
        end;
      end
      else begin
        Result.NomBase              := '';
        Result.ServeurReplication   := '';
      end;
     vQuery.Close;
  finally
      //     FdcConnection.Close();
     vQuery.DisposeOf;
     vCnx.DisposeOf();
  end;
end;


procedure TDataMod.FreeInfFDManager(aRef:string);
var bfound: boolean;
    i:Integer;
begin
    for i:=FDManager.ConnectionDefs.Count-1 downto 0  do
        begin
          If FDManager.ConnectionDefs[i].Name=aRef
            then
              begin
                FDManager.ConnectionDefs[i].Delete;
                Break;
              end;
        end;
end;

procedure TDataMod.CreateInFDManager({aServer:string;}aUser:string;aFile:string);
var  vParams : TStringList ;
     vtext:string;
     vServer : string;
     vFile   : string;
     Splitted : TArray<string>;
begin
  // FLock   := TCriticalSection.Create ;
  // il faut essayer de voir s'il y a déja l'entrée dans le FDMANAGER

  // Faut parser aFile

  vServer  := 'localhost';
  vFile    := aFile;

  Splitted := aFile.Split(['/']);
  if Length(Splitted)=2
    then
      begin
        vServer := Splitted[0];
        vFile   := Splitted[1];
      end;


  vParams := TStringList.Create ;
  try
    vParams.Add('DriverID=IB') ;
    vParams.Add('Server='+vServer) ;
    vParams.Add('Protocol=TCPIP') ;
    vParams.Add('Port=3050') ;
    vParams.Add('Database='  + vFile) ;
    if aUser='SYSDBA'
      then
        begin
          vParams.Add('User_Name=SYSDBA');
          vParams.Add('Password=masterkey');
        end;
    if aUser='GINKOIA'
      then
        begin
          vParams.Add('User_Name=GINKOIA');
          vParams.Add('Password=ginkoia');
        end;
    // vParams.Add('Pooled=true') ;
    vtext := Format('%s@%s',[aUser,aFile]);


    FDManager.AddConnectionDef(vText, 'IB', vParams);    // true

  finally
    vParams.Free;
  end;
end;

function TDataMod.GetNewStoredProc(AConnexion: TFDConnection; ATransaction: TFDTransaction;const ANomProcedure: string): TFDStoredProc;
begin
  Result                := TFDStoredProc.Create(Self);
  Result.Connection     := AConnexion;
  Result.Transaction    := ATransaction;
  Result.StoredProcName := ANomProcedure;
  Result.Prepare();
end;



function TDataMod.getNewQuery(aConnection : TFDConnection ;  aTrans: TFDTransaction): TFDQuery;
begin
  try
    Result := TFDQuery.Create(Self) ;
    Result.Connection := aConnection ;
    if Assigned(aTrans)
      then Result.Transaction := aTrans ;
    // Inc(ServerStats.FQueryCount) ;
  except
    // Inc(ServerStats.FErrorCount) ;
    // Log.Log('DM_Main','GetNewQuery','TFDQuery','Creation de Query impossible', logError);
    // Dm_Main.ServerStats.raiseStatusDatabase(logError) ;
    raise ;
  end;
end;

function TDataMod.Joue_MiniSplit(aFileCSV:TFileName;aIBFile:TFileName):Boolean;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    I: Integer;
    vStringList : TStringList;
begin
    vCnx   := getNewConnexion('SYSDBA@'+aIBFile);
    try
      vQuery := getNewQuery(vCnx,nil);
      vStringList := TStringList.Create;
      Result := false;
      try
        try
          if ExtractFileName(aFileCSV)='K.csv'
            then
              begin
                vStringList.LoadFromFile(aFileCSV);
                for I := 0 to vStringList.Count-1 do
                  begin
                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add(Format('INSERT INTO K VALUES (%s);',[vStringList.Strings[i]]));
                    vQuery.ExecSQL;
                    Result := true;
                    Exit;
                  end;
              end;
          if ExtractFileName(aFileCSV)='GENPARAM.csv'
            then
              begin
                vStringList.LoadFromFile(aFileCSV);
                for I := 0 to vStringList.Count-1 do
                  begin
                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add(Format('INSERT INTO GENPARAM VALUES (%s);',[vStringList.Strings[i]]));
                    vQuery.ExecSQL;
                    Result := True;
                    Exit;
                  end;
              end;
        except
          Result :=False;
        end;
      finally
        vQuery.DisposeOf;
        FreeAndNil(vStringList);
      end;
    finally
     vCnx.DisposeOf();
    end;
end;

function TDataMod.getNewConnexion(aRef:string): TFDConnection;
var tc : Cardinal ;
    i  : integer;
    bFound : boolean;
    Splitted: TArray<String>;
begin
  result:=nil;
  try
    // FLock.Enter;
    try
      // ServerStats.raiseStatusDatabase(logNotice) ;
      tc := GetTickCount ;
      bFound :=false;
      for i:=0 to FDManager.ConnectionDefs.Count-1 do
        begin
          If FDManager.ConnectionDefs[i].Name=aRef
            then
              begin
                bFound:=true;
                Break;
              end;
        end;
      if Not(bFound) then
        begin
            Splitted := aRef.Split(['@']);
            CreateInFDManager(Splitted[0],Splitted[1]);
        end;

      Result := TFDConnection.Create(nil);
      Result.ConnectionDefName := aRef;
      tc := getTickCount - tc ;
      {
      if tc < 1000
        then ServerStats.FStatusDatabase := logInfo
        else ServerStats.FStatusDatabase := logWarning ;
      }
     finally
      // FLock.Leave;
    end;
  except
    on E:Exception do
    begin
      // Inc(ServerStats.FErrorCount) ;
      // Log.Log('DM_Main','GetNewConnection','TFDConnection','Creation de connexion impossible : ' + E.Message, logError);
      // ServerStats.raiseStatusDatabase(logCritical) ;
      if Assigned(result) then
      begin
        result.DisposeOf ;
        result := nil ;
      end;

      raise ;
    end;
  end;
end;


// Liste des bases de la base de données
function TDataMod.ListeBases(const ABaseDonnees: TFileName):TBases;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
begin
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  try
    vQuery := getNewQuery(vCnx,nil);
    vQuery.SQL.Add('SELECT BAS_SENDER, CAST(BAS_IDENT AS INTEGER) AS BAS_IDENT, BAS_GUID ');
    vQuery.SQL.Add('  FROM   GENBASES ');
    vQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1) ');
    vQuery.SQL.Add(' WHERE  BAS_GUID != '''' ORDER BY 2 ASC ; ');

    vQuery.Open();

    SetLength(result,0);
    while not(vQuery.Eof) do
    begin
      i:=Length(result);
      SetLength(result,i+1);
      result[i].BAS_SENDER  := vQuery.FieldByName('BAS_SENDER').Asstring;
      result[i].SYM_NODE    := Sender_To_Node(vQuery.FieldByName('BAS_SENDER').Asstring);
      result[i].BAS_IDENT   := vQuery.FieldByName('BAS_IDENT').Asinteger;
      result[i].BAS_GUID    := vQuery.FieldByName('BAS_GUID').Asstring;
      vQuery.Next();
    end;
    vQuery.Close;
    vQuery.DisposeOf();
  finally
    vCnx.DisposeOf();
  end;
end;


function TDataMod.EtatNoeud(const ABaseDonnees: TFileName;aNode:string):TEtatNoeud;
Var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    i:Integer;
begin
    Result.NODE_ID        := aNode;
    Result.SYNC_ENABLED   := -1;
    Result.SYNC_URL       := '';
    Result.HEARTBEAT_TIME := '';
    Result.NODE_GROUP_ID  := '';
    vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
    vQuery := getNewQuery(vCnx,nil);
    try
      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add(' SELECT A.NODE_ID,                ');
      vQuery.SQL.Add('      C.sync_enabled,             ');
      vQuery.SQL.Add('      C.sync_url,                 ');
      vQuery.SQL.Add('      C.NODE_GROUP_ID,            ');
      vQuery.SQL.Add('      B.HEARTBEAT_TIME            ');
      vQuery.SQL.Add('    FROM SYM_NODE_SECURITY A      ');
      vQuery.SQL.Add('   JOIN SYM_NODE C ON (C.NODE_ID=A.NODE_ID)  ');
      vQuery.SQL.Add(' LEFT JOIN SYM_NODE_HOST B ON ( B.NODE_ID=A.NODE_ID) ');
      vQuery.SQL.Add('   WHERE A.NODE_ID=:NODE          ');
      vQuery.ParamByName('NODE').AsString := aNode;
      vQuery.open();
      if not(vQuery.eof) then
        begin
          Result.NODE_ID        := aNode;
          Result.SYNC_ENABLED   := vQuery.FieldByName('SYNC_ENABLED').asinteger;
          Result.SYNC_URL       := vQuery.FieldByName('SYNC_URL').asstring;
          Result.NODE_GROUP_ID  := vQuery.FieldByName('NODE_GROUP_ID').asstring;
          Result.HEARTBEAT_TIME := vQuery.FieldByName('HEARTBEAT_TIME').asstring;
        end;
      vQuery.Close();

      {
      Result.SYNC_MOD := 1;

      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add(' SELECT *                    ');
      vQuery.SQL.Add('    FROM SYM_PARAMETER P     ');
      vQuery.SQL.Add('   WHERE EXTERNAL_ID=:NODE   ');
      vQuery.SQL.Add('   AND NODE_GROUP_ID=:GROUP ');
      vQuery.SQL.Add('   AND PARAM_KEY=:KEY        ');
      vQuery.ParamByName('NODE').AsString := aNode;
      vQuery.ParamByName('GROUP').AsString := 'mags';
      vQuery.ParamByName('KEY').AsString  := 'node.offline';
      vQuery.open();

      if not(vQuery.eof) then
        begin
          If vQuery.FieldByName('PARAM_VALUE').asstring='true'
            then Result.SYNC_MOD := 2;

          If vQuery.FieldByName('PARAM_VALUE').asstring='false'
            then Result.SYNC_MOD := 1;

        end;
      vQuery.Close();
      }

      {
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM SYM_NODE WHERE NODE_ID=:NODEID');
      vQuery.ParamByName('NODEID').AsString:=
      vQuery.open;
      result:=result or not(vQuery.IsEmpty);
      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM SYM_NODE_SECURITY WHERE NODE_ID=:NODEID');
      vQuery.ParamByName('NODEID').AsString:=LowerCase(aBaseSender);
      vQuery.open;
      result:=result or not(vQuery.IsEmpty);
      vQuery.Close();
      }







    finally
      vQuery.DisposeOf();
      vCnx.DisposeOf();
    end;
end;

// sert dans le cadre d'un nettoyage de base pour faire des dossiers de test
procedure TDataMod.CLEAN_MAGCODE(const ABaseDonnees: TFileName);
var vCnx    : TFDConnection;
    vQuery  : TFDQuery;
    vPR_UPDATEK : TFDStoredProc;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vPR_UPDATEK := getNewStoredProc(vCnx,nil,'PR_UPDATEK');
    try
       vCnx.open;
       If vCnx.Connected then
          begin
             vQuery.Close;
             vQuery.SQL.Clear;
             vQuery.SQL.Add('SELECT * FROM GENMAGASIN');
             vQuery.open;
             while not(vQuery.Eof) do
                begin
                   vPR_UPDATEK.ParamByName('K_ID').AsInteger        := vQuery.FieldByName('MAG_ID').asinteger;
                   vPR_UPDATEK.ParamByName('SUPRESSION').AsInteger := 0;
                   vPr_UpdateK.ExecProc();
                   vQuery.Edit;
                   vQuery.FieldByName('MAG_CODE').Asstring:='';
                   vQuery.Post;
                   vQuery.Next;
                end;
           end;
    finally
       vQuery.Close;
       vQuery.DisposeOf;
       vCnx.DisposeOf;
    end;
end;




procedure TDataMod.DROP_SYMDS(const ABaseDonnees: TFileName);
var sdirectory:string;
    sProgUninstall:string;
    vScript:TFDScript;
    vScriptFile : string;
    BufferSQL:string;
    i:integer;
    chaine:string;
    vCnx    : TFDConnection;
    vQuery  : TFDQuery;
    ResInstallateur : TResourceStream;


begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript:=TFDScript.Create(nil);
    vScript.Connection:=vCnx;

    vScriptFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'drop_symds.sql';
    if FileExists(vScriptFile)
      then DeleteFile(vScriptFile);

    ResInstallateur := TResourceStream.Create(HInstance, 'drop_symds', RT_RCDATA);
    try
       ResInstallateur.SaveToFile(vScriptFile);
      finally
       ResInstallateur.Free();
    end;
//  vScript.Transaction:=FTransaction;
//  PScript.Transaction.Options.AutoStart:=true;
//  PScript.Transaction.Options.AutoCommit:=true;
//  PScript.Transaction:=TransSymmDS;
//  vScript.Transaction.Options.AutoStart:=true;
//  PScript.Transaction.Options.AutoCommit:=true;

    try
       try
       vCnx.open;
       If vCnx.Connected then
          begin
               With TStringList.Create do
                   try
                      LoadFromFile(vScriptFile);
                      BufferSQL:='';
                      for i:= 0 to Count-1 do
                        begin
                             IF Pos('^', Strings[i]) = 0
                                then BufferSQL := BufferSQL + #13 + #10 + Strings[i];
                             IF Pos('^',  Strings[i]) = 1
                                then
                                    begin
                                        if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                                            then
                                                begin
                                                     // vQuery.Transaction.StartTransaction;
                                                     vQuery.Close;
                                                     vQuery.SQL.Clear;
                                                     vQuery.SQL.Add(BufferSQL);
                                                     vQuery.Prepare;
                                                     vQuery.Open;
                                                     vQuery.FetchAll();
                                                     // vQuery.Transaction.Commit;
                                                     vQuery.Close;
                                                end
                                            else
                                              try
                                               // vScript.Transaction.StartTransaction;
                                               vScript.SQLScripts.Clear;
                                               vScript.SQLScripts.Add;
                                               vScript.SQLScripts[0].SQL.Add(Trim(BufferSQL));
                                               vScript.ValidateAll;
                                               vScript.ExecuteAll;
                                               // vScript.Transaction.Commit;
                                               // FStatus:=Format('Ligne N°%d : [OK]' ,[i]);
                                               // Synchronize(UpdateVCL);
                                               Except On Ez:Exception do
                                                 begin
                                                    // FStatus:=Format('Ligne N°%d : [ERREUR]',[i]);
                                                    // if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                                                    exit;
                                                     // MessageDlg(Ez.Message,  mtCustom, [mbOK], 0);
                                                 end;
                                            end;
                                       BufferSQL:='';
                                    end;
                        end;
                     finally
                        Free;
                   end;
          end;
       Except On Ez : Exception do
                 begin
                    //
                 end;
        end;
     finally
        vScript.Free;
        vQuery.Close;
        vQuery.DisposeOf;
        vCnx.DisposeOf;
        // Libération du POOL
        DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
    end;

   // -----------
   Sleep(10*1000); // 10 secondes
   // -----------
   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
      try
       vScript:=TFDScript.Create(nil);
       vScript.Connection:=vCnx;

       vScript.SQLScripts.Clear;
       vScript.SQLScripts.Add;
       vScript.SQLScripts[0].SQL.Add('DROP TABLE SYM_DATA;');
       vScript.ValidateAll;
       vScript.ExecuteAll;
     Except On Ez:Exception do
       begin
         //
       end;
     end;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;

   // -----------
   Sleep(10*1000); // 10 secondes
   // -----------

   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
     try
     vScript:=TFDScript.Create(nil);
     vScript.Connection:=vCnx;

     vScript.SQLScripts.Clear;
     vScript.SQLScripts.Add;
     vScript.SQLScripts[0].SQL.Add('DROP TABLE SYM_CONTEXT;');
     vScript.ValidateAll;
     vScript.ExecuteAll;
     Except On Ez:Exception do
       begin
         //
       end;
     end;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;
end;

{
procedure TDataMod.DROP_TABLES_SYMDS(const ABaseDonnees: TFileName);
var sdirectory:string;
    sProgUninstall:string;
    vScript:TFDScript;
    vScriptFile : string;
    BufferSQL:string;
    i:integer;
    chaine:string;
    vCnx    : TFDConnection;
    vQuery  : TFDQuery;
    ResInstallateur : TResourceStream;


begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript:=TFDScript.Create(nil);
    vScript.Connection:=vCnx;

    vScriptFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ ' drop_tables_symds.sql';
    if FileExists(vScriptFile)
      then DeleteFile(vScriptFile);

    ResInstallateur := TResourceStream.Create(HInstance, 'drop_tables_symds', RT_RCDATA);
    try
       ResInstallateur.SaveToFile(vScriptFile);
      finally
       ResInstallateur.Free();
    end;
//  vScript.Transaction:=FTransaction;
//  PScript.Transaction.Options.AutoStart:=true;
//  PScript.Transaction.Options.AutoCommit:=true;
//  PScript.Transaction:=TransSymmDS;
//  vScript.Transaction.Options.AutoStart:=true;
//  PScript.Transaction.Options.AutoCommit:=true;

    try
       try
       vCnx.open;
       If vCnx.Connected then
          begin
               With TStringList.Create do
                   try
                      LoadFromFile(vScriptFile);
                      BufferSQL:='';
                      for i:= 0 to Count-1 do
                        begin
                             IF Pos('^', Strings[i]) = 0
                                then BufferSQL := BufferSQL + #13 + #10 + Strings[i];
                             IF Pos('^',  Strings[i]) = 1
                                then
                                    begin
                                        if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                                            then
                                                begin
                                                     // vQuery.Transaction.StartTransaction;
                                                     vQuery.Close;
                                                     vQuery.SQL.Clear;
                                                     vQuery.SQL.Add(BufferSQL);
                                                     vQuery.Prepare;
                                                     vQuery.Open;
                                                     vQuery.FetchAll();
                                                     // vQuery.Transaction.Commit;
                                                     vQuery.Close;
                                                end
                                            else
                                              try
                                               // vScript.Transaction.StartTransaction;
                                               vScript.SQLScripts.Clear;
                                               vScript.SQLScripts.Add;
                                               vScript.SQLScripts[0].SQL.Add(Trim(BufferSQL));
                                               vScript.ValidateAll;
                                               vScript.ExecuteAll;
                                               // vScript.Transaction.Commit;
                                               // FStatus:=Format('Ligne N°%d : [OK]' ,[i]);
                                               // Synchronize(UpdateVCL);
                                               Except On Ez:Exception do
                                                 begin
                                                    // FStatus:=Format('Ligne N°%d : [ERREUR]',[i]);
                                                    // if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                                                    // exit;
                                                    // MessageDlg(Ez.Message,  mtCustom, [mbOK], 0);
                                                 end;
                                            end;
                                       BufferSQL:='';
                                    end;
                        end;
                     finally
                        Free;
                   end;
          end;
       Except On Ez : Exception do
                 begin
                    //
                 end;
        end;
     finally
        vScript.Free;
        vQuery.Close;
        vQuery.DisposeOf;
        vCnx.DisposeOf;
        // Libération du POOL
        DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
     end;

   // -----------
   Sleep(400);
   // -----------
   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
     vScript:=TFDScript.Create(nil);
     vScript.Connection:=vCnx;

     vScript.SQLScripts.Clear;
     vScript.SQLScripts.Add;
     vScript.SQLScripts[0].SQL.Add('DROP TABLE SYM_CONTEXT;');
     vScript.ValidateAll;
     vScript.ExecuteAll;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;
end;
}


procedure TDataMod.SetNomPourNous(const ABaseDonnees: TFileName;aNomPourNous:string);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT * ');
    vQuery.SQL.Add(' FROM GENBASES ');
    vQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1) WHERE BAS_ID<>0');
    vQuery.Open();
    // OUI je mouvement même pas les K ! pas la peine c'est la création du NOEUD MAITRE
    while not(vQuery.eof) do
      begin
        vQuery.Edit;
        vQuery.FieldByName('BAS_NOMPOURNOUS').Asstring  := UpperCase(aNomPourNous);
        vQuery.FieldByName('BAS_GUID').Asstring := NewGUID;
        vQuery.Post;
        vQuery.Next;
      end;
    vQuery.Close();
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;


// Est-ce que les procedure et functions du GAP sont bien présentes ?
function TDataMod.IsGAPDefined(const ABaseDonnees: TFileName):boolean;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := false;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT * FROM RDB$FUNCTIONS WHERE RDB$FUNCTION_NAME=''F_SUBSTR4'' ');
    vQuery.Open();
    If vQuery.eof then
      begin
        result:=false;
        exit;
      end;

    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT * FROM RDB$FUNCTIONS WHERE RDB$FUNCTION_NAME=''F_LEFT4'' ');
    vQuery.Open();
    If vQuery.eof then
      begin
        result:=false;
        exit;
      end;

    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('select rdb$procedure_name from rdb$procedures where rdb$procedure_name =''EASY_DO_GAP'' ');
    vQuery.Open();
    If vQuery.eof then
      begin
        result:=false;
        exit;
      end;

    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('select rdb$procedure_name from rdb$procedures where rdb$procedure_name =''EASY_MVT_LAME2MAGS'' ');
    vQuery.Open();
    If vQuery.eof then
      begin
        result:=false;
        exit;
      end;

    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('select rdb$procedure_name from rdb$procedures where rdb$procedure_name =''EASY_DETECT_GAP'' ');
    vQuery.Open();
    If vQuery.eof then
      begin
        result:=false;
        exit;
      end;
    result:=true;
    vQuery.Close();
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;





// Liste des bases de la base de données
function TDataMod.GetNomPourNous(const ABaseDonnees: TFileName):string;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := '';
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);  // GINKOIA (test easy_split)
  vQuery := getNewQuery(vCnx,nil);
  try
    // Paramètre la connexion à la base de données
    {
    FdcConnection.Params.Clear();
    FdcConnection.Params.Add('DriverID=IB');
    FdcConnection.Params.Add('User_Name=ginkoia');
    FdcConnection.Params.Add('Password=ginkoia');
    FdcConnection.Params.Add(Format('Database=%s', [ABaseDonnees]));
    FdcConnection.Params.Add('Protocol=TCPIP');
    FdcConnection.Params.Add('Server=localhost');
    FdcConnection.Params.Add('Port=3050');
    // FdcConnection.Params.Add('Pooled=true');
    QueTmp.Connection:=FdcConnection;
    QueTmp.Close();
    }

    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT BAS_NOM , BAS_IDENT, BAS_NOMPOURNOUS ');
    vQuery.SQL.Add(' FROM   GENBASES       ');
    vQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1)');
    vQuery.SQL.Add('  WHERE BAS_IDENT=''0'' ');
    vQuery.Open();
    If not(vQuery.eof) then
      begin
          result:=Lowercase(vQuery.FieldByName('BAS_NOMPOURNOUS').Asstring);
      end;
    vQuery.Close();
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;


// Liste des bases de la base de données
function TDataMod.GetLastHeartBeat(const ABaseDonnees: TFileName;Const NODEID:string):string;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := '';
  if (ABaseDonnees='') or (NODEID='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    // Paramètre la connexion à la base de données
    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT * FROM SYM_NODE_HOST WHERE NODE_ID=:NODEID');
    vQuery.ParamByName('NODEID').asstring:=NODEID;
    vQuery.Open();
    If not(vQuery.eof) then
      begin
          result:=vQuery.FieldByName('HEARTBEAT_TIME').asstring;
      end;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf;
  end;
end;

function TDataMod.ScriptTriggersManquantsLCL(const aLCLFile:TFileName):TStringList;
var aTABLENAME:string;
    i:integer;
    vListTables_LCL:TStringList;
begin
  Result := TStringList.Create;
  vListTables_LCL := TStringList.Create;
  try
    // Paramètre la connexion à la base de données
    vListTables_LCL.LoadFromFile(aLCLFile);
    for i := 0 to vListTables_LCL.Count-1 do
      begin
          // Controle longueur total des champs de cette table
          aTABLENAME := LowerCase(trim(vListTables_LCL[i]));
          Result.Add(Format('INSERT INTO SYM_TRIGGER(TRIGGER_ID, SOURCE_TABLE_NAME, CHANNEL_ID, LAST_UPDATE_TIME, CREATE_TIME, SYNC_ON_DELETE, SYNC_ON_INCOMING_BATCH) VALUES(''%s'', ''%s'',''default'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, 1);',
                [aTABLENAME,aTABLENAME]));

          Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''caisses_pg_vers_mags_pg'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

          Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''mags_pg_vers_caisses_pg'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                  [aTABLENAME]));
      end;
  finally
     vListTables_LCL.DisposeOf;
  end;
end;

//
function TDataMod.ScriptTriggersManquants(const ABaseDonnees: TFileName):TStringList;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    aTABLENAME,aKeyField:string;
begin
  Result := TStringList.Create;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    // Paramètre la connexion à la base de données
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME,                                     ');
    vQuery.SQL.Add('    CASE                                                      ');
    vQuery.SQL.Add('        WHEN F_LEFT(KTB_DATA, F_SUBSTR('','',KTB_DATA))=''''  ');
    vQuery.SQL.Add('            THEN KTB_DATA                                     ');
    vQuery.SQL.Add('            ELSE F_LEFT(KTB_DATA, F_SUBSTR('','',KTB_DATA))   ');
    vQuery.SQL.Add('    END                                                       ');
    vQuery.SQL.Add(' FROM RDB$RELATIONS                                           ');
//  vQuery.SQL.Add('            LEFT JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME ');
    vQuery.SQL.Add('            JOIN KTB ON KTB_NAME=RDB$RELATION_NAME         ');
    vQuery.SQL.Add('            WHERE ((RDB$SYSTEM_FLAG = 0) OR                ');
    vQuery.SQL.Add('            (RDB$SYSTEM_FLAG IS NULL)) AND                 ');
    vQuery.SQL.Add('            (RDB$VIEW_SOURCE IS NULL)                   ');
     //  vQuery.SQL.Add('            (RDB$RELATION_NAME!=''INVIMGSTK'') AND         ');  elle est plus bas... dans la partie inventaire
    // Exclusion des TABLES K2, KFLD, KTB car on doit pouvoir les créer partout lame et mag indépendament
    vQuery.SQL.Add('      AND  (RDB$RELATION_NAME NOT IN (''K2'',''KFLD'',''KTB'') ) ');
   // Exclusion des TABLE par STAN
    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''ARTRELINV'',''ARTSEUILWEB'',''CFGMODULESNONK'',''CFGUSERLEVELNONK'') ) ');
   // Exclusion des TABLE par STAN Table de Training et ECR
    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''CLTCOMPTETRG'',''CSHENCAISSEMENTTRG'',''CSHTICKETTRG'',''CSHTICKETLTRG'') ) ');

    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''DDOC'',''ECRCHAMPS'',''ECRECRAN'',''ECRLOOKUP'',''ECRSAISIE'',''ECRTABLE'') ) ');
    // ne sert plus à mon avis
    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''GENCUSTOMISE'',''NKLSELECTION'') ) ');
    // Exclusion des tables Inventaire
    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''INVENTETE'',''INVENTETEL'',''INVIMGSTK'',''INVSESSION'',''INVSESSIONL'',''INVPALETTE'',''INVZONESAISIE'') ) ');
    // TABLE DE PICCO
    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''PICCOECHANGE'',''PICCORETOTO'',''PICCORETOUR'',''PICCOSORTIE'') ) ');
    //
    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''PRECDE'',''RAPFIELD'',''RAPFOLDER'',''RAPITEMDETAIL'',''RAPITEMENTETE'',''RAPJOIN'',''RAPTABLE'') )');

    vQuery.SQL.Add('      AND   (RDB$RELATION_NAME NOT IN (''TARCLGFOURN_TMP'',''TARPRIXVENTE_TMP'') )');

    //  vQuery.SQL.Add('            AND TRIGGER_ID IS NULL                         ');
    vQuery.SQL.Add('            ORDER BY RDB$RELATION_NAME                     ');
    vQuery.open;


    while not(vQuery.eof) do
      begin
          // Controle longueur total des champs de cette table
          aTABLENAME := trim(vQuery.Fields[0].AsString);
          aKeyField  := trim(vQuery.Fields[1].AsString);
          If (Controle_Longueur_Champs_Table(vCnx,aTABLEName))
            then
               begin
                  Result.Add(Format('INSERT INTO SYM_TRIGGER(TRIGGER_ID, SOURCE_TABLE_NAME, CHANNEL_ID, SYNC_KEY_NAMES, LAST_UPDATE_TIME, CREATE_TIME, SYNC_ON_DELETE, SYNC_ON_INCOMING_BATCH) VALUES(''%s'', ''%s'',''default'',''%s'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, 1);',
                      [ aTABLENAME,aTABLENAME,aKeyField]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''lame_vers_mags'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''mags_vers_lame'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''portables_vers_lame'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

               end;
         vQuery.Next;
      END;
    vQuery.Close();

    // -------------------------------------------------------------------------
    // AJOUT DES TABLES CASHXXX et des repliques "PG"
    // à tous les niveaux (6 routes)
    // SAUF CASHGROUPEROLE ==> Loick / Gilles V18.2 --> V19.1
    // il faut sortir de la replication EASY cette table car sinon les triggers symds seront crées
    // et on pourra pas renommer le fameux champs LGRD_LGRUID en LGRR_LGRUID

    // NON plus maintenant ca pose trop de soucis
    {
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME                ');
    vQuery.SQL.Add('  FROM RDB$RELATIONS                    ');
    vQuery.SQL.Add('WHERE  RDB$RELATION_NAME LIKE ''CASH%'' ');
    /// BEGIN Loick / Gilles
    vQuery.SQL.Add(' AND   RDB$RELATION_NAME <> ''CASHGROUPEROLE'' ');
    // END Loick / Gilles
    vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME             ');
    vQuery.open;
    while not(vQuery.eof) do
      begin
          // Controle longueur total des champs de cette table
          aTABLENAME := trim(vQuery.Fields[0].AsString);
          If (Controle_Longueur_Champs_Table(vCnx,aTABLEName))
            then
               begin
                  Result.Add(Format('INSERT INTO SYM_TRIGGER(TRIGGER_ID, SOURCE_TABLE_NAME, CHANNEL_ID, LAST_UPDATE_TIME, CREATE_TIME, SYNC_ON_DELETE, SYNC_ON_INCOMING_BATCH) VALUES(''%s'', ''%s'',''default'', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, 1);',
                      [ aTABLENAME,aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''lame_vers_mags'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''mags_vers_lame'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''lame_vers_mags_pg'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''mags_pg_vers_lame'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''mags_pg_vers_caisses_pg'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));

                  Result.Add(Format('INSERT INTO SYM_TRIGGER_ROUTER(TRIGGER_ID, ROUTER_ID, ENABLED, INITIAL_LOAD_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) VALUES (''%s'',''caisses_pg_vers_mags_pg'', 1, 100, CURRENT_TIMESTAMP, ''GINKOIA'', CURRENT_TIMESTAMP);',
                                    [aTABLENAME]));
               end;
         vQuery.Next;
      END;
    vQuery.Close();
    }

    // il manque encore les routes caisses_pg et mags_pg mais la ca depend de la version



    // Pour les Tables "Mouvement" il faut envelever le CAPTURE_OLDDATA
    Result.Add('UPDATE SYM_TRIGGER SET USE_CAPTURE_OLD_DATA=0 WHERE TRIGGER_ID IN (''K'',''COMBCDEL'',''COMANNULL'',''RECBRL'',''NEGBLL'',''CSHTICKETL'',''CONSODIV'',''COMRETOURL'',''NEGFACTUREL'',''TRANSFERTIML'');');
    // et COMANNULL ???

    // Ajout de K le 03/06/2019 suite a un Pb chez GARRIGOU et PLOTNIKOVA...
    // Les K_ENABLED etaient différents et cela malgré un PR_UPDATEK....
    // le seul moyen est de ne plus capturer le OLD


    // AND $(curTriggerValue).KTB_ID NOT IN()
    // KTB_ID NOT IN (-11113017,-11113015,-11113011,-11113009,-11113007,-11112018,-11112005,-11112003,-11111682,-11111651,-11111650,-11111535,-11111524,-11111518,-11111507,-11111504,-11111503,-11111502,-11111501,-11111500,-11111499,-11111491,-11111490,-11111471,-11111464,-11111463,-11111462,-11111461,-11111460,-11111444,-11111331,-11111329,-11111015)
(*
SELECT KTB_ID FROM KTB WHERE KTB_NAME IN (
'ARTRELINV', 'ARTSEUILWEB',
'CFGMODULESNONK','CFGUSERLEVELNONK',
'CLTCOMPTETRG', 'CSHENCAISSEMENTTRG', 'CSHTICKETLTRG', 'CSHTICKETTRG',
'ECRCHAMPS' , 'ECRECRAN',  'ECRLOOKUP' , 'ECRSAISIE' , 'ECRTABLE',
'GENSAUVEGRILLE',
'INVENTETE','INVENTETEL','INVIMGSTK','INVPALETTE','INVSESSION','INVSESSIONL','INVZONESAISIE',
'K2','KFLD','KKW','KKWLG', 'KTB',
'PICCOECHANGE','PICCORETOTO','PICCORETOUR','PICCOSORTIE',
'PRECDE',
'RAPJOIN','RAPTABLE'
)
ORDER BY KTB_ID

*)


    // Uniquement les K>0 pour K (pour passer le script de MAJ)
    // Ajout des tables Exclus dans le trigger... ca risque de consommé plus !!!
    Result.Add('UPDATE SYM_TRIGGER SET SYNC_ON_INSERT_CONDITION=''$(curTriggerValue).K_ID>0 AND $(curTriggerValue).KTB_ID NOT IN ');
    Result.Add('  (-11113017,-11113015,-11113011,-11113009,-11113007,-11112018,-11112005,-11112003,-11111682,  ');
    Result.Add('   -11111651,-11111650,-11111535,-11111524,-11111518,-11111507,-11111504,-11111503,-11111502,  ');
    Result.Add('   -11111501,-11111500,-11111499,-11111491,-11111490,-11111471,-11111464,-11111463,-11111462,  ');
    Result.Add('   -11111461,-11111460,-11111444,-11111331,-11111329,-11111015)'' WHERE TRIGGER_ID=''K'';      ');

    Result.Add('UPDATE SYM_TRIGGER SET SYNC_ON_UPDATE_CONDITION=''$(curTriggerValue).K_ID>0 AND $(curTriggerValue).KTB_ID NOT IN ');
    Result.Add('  (-11113017,-11113015,-11113011,-11113009,-11113007,-11112018,-11112005,-11112003,-11111682,  ');
    Result.Add('   -11111651,-11111650,-11111535,-11111524,-11111518,-11111507,-11111504,-11111503,-11111502,  ');
    Result.Add('   -11111501,-11111500,-11111499,-11111491,-11111490,-11111471,-11111464,-11111463,-11111462,  ');
    Result.Add('   -11111461,-11111460,-11111444,-11111331,-11111329,-11111015)'' WHERE TRIGGER_ID=''K'';      ');


    // Pour les K_VERSION LAME pour faire les mêmes modifs que DELOS
    Result.Add('INSERT INTO SYM_TRANSFORM_TABLE (TRANSFORM_ID, SOURCE_NODE_GROUP_ID, TARGET_NODE_GROUP_ID, TRANSFORM_POINT, SOURCE_CATALOG_NAME, SOURCE_SCHEMA_NAME, SOURCE_TABLE_NAME,');
    Result.Add('  TARGET_CATALOG_NAME, TARGET_SCHEMA_NAME, TARGET_TABLE_NAME, UPDATE_FIRST, UPDATE_ACTION, DELETE_ACTION, TRANSFORM_ORDER, COLUMN_POLICY, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME)');
    Result.Add('  VALUES (''K_PUSH'', ''mags'', ''lame'', ''LOAD'', NULL, NULL, ''K'', NULL, NULL, ''K'', 0, ''UPDATE_COL'', ''DEL_ROW'', 1, ''IMPLIED'', current_timestamp, null, current_timestamp);');
    Result.Add('INSERT INTO SYM_TRANSFORM_COLUMN (TRANSFORM_ID, INCLUDE_ON, TARGET_COLUMN_NAME, SOURCE_COLUMN_NAME, PK, TRANSFORM_TYPE, TRANSFORM_EXPRESSION, TRANSFORM_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) ');
    Result.Add('  VALUES (''K_PUSH'', ''*'', ''K_VERSION'', ''K_VERSION'', 0, ''lookup'', ''SELECT GEN_ID(GENERAL_ID,1) FROM RDB$DATABASE'', 1, current_timestamp, NULL, current_timestamp);');

    //
    Result.Add('UPDATE SYM_TRIGGER_ROUTER SET PING_BACK_ENABLED=1, LAST_UPDATE_TIME=current_timestamp WHERE TRIGGER_ID=''K'' AND ROUTER_ID=''lame_vers_mags'';');

    // Ajout du K_PUSHP Pour les "portables"
    Result.Add('INSERT INTO SYM_TRANSFORM_TABLE (TRANSFORM_ID, SOURCE_NODE_GROUP_ID, TARGET_NODE_GROUP_ID, TRANSFORM_POINT, SOURCE_CATALOG_NAME, SOURCE_SCHEMA_NAME, SOURCE_TABLE_NAME,');
    Result.Add('  TARGET_CATALOG_NAME, TARGET_SCHEMA_NAME, TARGET_TABLE_NAME, UPDATE_FIRST, UPDATE_ACTION, DELETE_ACTION, TRANSFORM_ORDER, COLUMN_POLICY, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME)');
    Result.Add('  VALUES (''K_PUSHP'', ''portables'', ''lame'', ''LOAD'', NULL, NULL, ''K'', NULL, NULL, ''K'', 0, ''UPDATE_COL'', ''DEL_ROW'', 1, ''IMPLIED'', current_timestamp, null, current_timestamp);');
    Result.Add('INSERT INTO SYM_TRANSFORM_COLUMN (TRANSFORM_ID, INCLUDE_ON, TARGET_COLUMN_NAME, SOURCE_COLUMN_NAME, PK, TRANSFORM_TYPE, TRANSFORM_EXPRESSION, TRANSFORM_ORDER, CREATE_TIME, LAST_UPDATE_BY, LAST_UPDATE_TIME) ');
    Result.Add('  VALUES (''K_PUSHP'', ''*'', ''K_VERSION'', ''K_VERSION'', 0, ''lookup'', ''SELECT GEN_ID(GENERAL_ID,1) FROM RDB$DATABASE'', 1, current_timestamp, NULL, current_timestamp);');


  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

procedure TDataMod.GetAllTablesExclues(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME  AS TABLE_NAME, RDB$RELATION_TYPE AS TYPE_TABLE');
    vQuery.SQL.Add('FROM RDB$RELATIONS                                          ');
    vQuery.SQL.Add('LEFT JOIN KTB ON KTB_NAME=RDB$RELATION_NAME                 ');
    vQuery.SQL.Add(' WHERE ((RDB$SYSTEM_FLAG = 0) OR                            ');
    vQuery.SQL.Add('  (RDB$SYSTEM_FLAG IS NULL)) AND                            ');
    vQuery.SQL.Add('  (RDB$VIEW_SOURCE IS NULL)                                 ');
    vQuery.SQL.Add(' AND KTB_NAME IS NULL                                       ');
    vQuery.SQL.Add('ORDER BY RDB$RELATION_NAME                                  ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

procedure TDataMod.DoGAP(const ABaseDonnees: TFileName);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    i  : integer;
begin
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vCnx.StartTransaction;
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM EASY_DO_GAP(1);');
    vQuery.Open();
    while not(vQuery.Eof) do
      begin
        vQuery.Next;
      end;
    vCnx.Commit;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;


function TDataMod.IsPushMissingDELOSDefined(const ABaseDonnees: TFileName):boolean;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := false;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('select rdb$procedure_name from rdb$procedures where rdb$procedure_name =''EASY_PUSH_MISSING_DELOS'' ');
    vQuery.Open();
    If vQuery.eof then
      begin
        result:=false;
        exit;
      end;

    result:=true;
    vQuery.Close();
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;

procedure TDataMod.DoPushMissingDELOS(const ABaseDonnees: TFileName);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    i  : integer;
begin
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vCnx.StartTransaction;
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM EASY_PUSH_MISSING_DELOS(1);');
    vQuery.Open();
    while not(vQuery.Eof) do
      begin
        vQuery.Next;
      end;
    vCnx.Commit;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;




procedure TDataMod.DetectGAP(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
{
    NODEID varchar(50),
    DECLARED_DATAID numeric(18,0),
    RECORDED_DATAID numeric(18,0),
    NBRECORDS integer,
    NBREPASSE integer,
    ETAT varchar(30))
}
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    i  : integer;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM EASY_DETECT_GAP');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          for i:=0 to vQuery.Fields.Count-1 do
            begin
              aDataSet.Fields[i].Value := vQuery.Fields[i].Value;
            end;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

procedure TDataMod.GetTablesExclues(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME AS TABLE_NAME, F_LEFT(KTB_DATA, F_SUBSTR(''_ID'',KTB_DATA)+3) AS PRIMARY_KEY');
    vQuery.SQL.Add(' FROM RDB$RELATIONS                                          ');
    vQuery.SQL.Add('LEFT JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME ');
    vQuery.SQL.Add('JOIN KTB ON KTB_NAME=RDB$RELATION_NAME                       ');
    vQuery.SQL.Add(' WHERE ((RDB$SYSTEM_FLAG = 0) OR                             ');
    vQuery.SQL.Add('  (RDB$SYSTEM_FLAG IS NULL)) AND                             ');
    vQuery.SQL.Add('  (RDB$VIEW_SOURCE IS NULL)                                  ');
    vQuery.SQL.Add('AND TRIGGER_ID IS NULL                                       ');
    vQuery.SQL.Add('ORDER BY RDB$RELATION_NAME                                   ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

procedure TDataMod.GetSenders(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    virgule : string;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT BAS_SENDER, BAS_IDENT, BAS_PLAGE FROM GENBASES JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 WHERE BAS_SENDER<>'''' ');
    vQuery.open;
    aDataSet.Close();
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Fields[2].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

procedure TDataMod.GetEASYTablesSuppReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery,vQuery1 : TFDQuery;
    vCnx   : TFDConnection;
    virgule : string;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  vQuery1 := getNewQuery(vCnx,nil);
  try
    vQuery1.Close();
    vQuery1.SQL.Clear;
    vQuery1.SQL.Add('SELECT i.RDB$RELATION_NAME,                               ');
    vQuery1.SQL.Add('       rc.RDB$CONSTRAINT_NAME,                            ');
    vQuery1.SQL.Add('       s.RDB$FIELD_NAME AS field_name,                    ');
    vQuery1.SQL.Add('       (s.RDB$FIELD_POSITION + 1) AS field_position       ');
    vQuery1.SQL.Add('     FROM RDB$INDEX_SEGMENTS s                            ');
    vQuery1.SQL.Add('LEFT JOIN RDB$INDICES i ON i.RDB$INDEX_NAME = s.RDB$INDEX_NAME ');
    vQuery1.SQL.Add('LEFT JOIN RDB$RELATION_CONSTRAINTS rc ON rc.RDB$INDEX_NAME = s.RDB$INDEX_NAME ');
    vQuery1.SQL.Add('    WHERE i.RDB$RELATION_NAME=:TABLE_NAME                 ');
    vQuery1.SQL.Add('      AND rc.RDB$CONSTRAINT_TYPE=''PRIMARY KEY''          ');
    vQuery1.SQL.Add('      AND rc.RDB$CONSTRAINT_TYPE IS NOT NULL              ');
    vQuery1.SQL.Add(' ORDER BY s.RDB$FIELD_POSITION                            ');

    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT SOURCE_TABLE_NAME, SYNC_KEY_NAMES                    ');
    vQuery.SQL.Add('  FROM sym_trigger                                          ');
    vQuery.SQL.Add('LEFT JOIN RDB$RELATIONS ON RDB$RELATION_NAME=SOURCE_TABLE_NAME ');
    vQuery.SQL.Add('LEFT JOIN KTB ON KTB_NAME=RDB$RELATION_NAME                    ');
    vQuery.SQL.Add('WHERE KTB_NAME IS NULL                                         ');
    vQuery.SQL.Add('AND NOT(SOURCE_TABLE_NAME LIKE ''CASH%'')                      ');
    vQuery.SQL.Add('ORDER BY SOURCE_TABLE_NAME                                     ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Fields[2].AsString:='';
          if (VarIsNull(vQuery.Fields[1].Value))
            then
              begin
                 vQuery1.Close;
                 vQuery1.ParamByName('TABLE_NAME').AsString := vQuery.Fields[0].AsString;
                 vQuery1.Open();
                 virgule := '';
                 while not(vQuery1.Eof) do
                  begin
                     aDataSet.Fields[2].AsString:= aDataSet.Fields[2].AsString + virgule + vQuery1.Fields[2].AsString;
                     virgule := ',';
                     vQuery1.Next;
                  end;
              end;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;





procedure TDataMod.GetCASHTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery,vQuery1 : TFDQuery;
    vCnx   : TFDConnection;
    virgule : string;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  vQuery1 := getNewQuery(vCnx,nil);
  try
    vQuery1.Close();
    vQuery1.SQL.Clear;
    vQuery1.SQL.Add('SELECT i.RDB$RELATION_NAME,                               ');
    vQuery1.SQL.Add('       rc.RDB$CONSTRAINT_NAME,                            ');
    vQuery1.SQL.Add('       s.RDB$FIELD_NAME AS field_name,                    ');
    vQuery1.SQL.Add('       (s.RDB$FIELD_POSITION + 1) AS field_position       ');
    vQuery1.SQL.Add('     FROM RDB$INDEX_SEGMENTS s                            ');
    vQuery1.SQL.Add('LEFT JOIN RDB$INDICES i ON i.RDB$INDEX_NAME = s.RDB$INDEX_NAME ');
    vQuery1.SQL.Add('LEFT JOIN RDB$RELATION_CONSTRAINTS rc ON rc.RDB$INDEX_NAME = s.RDB$INDEX_NAME ');
    vQuery1.SQL.Add('    WHERE i.RDB$RELATION_NAME=:TABLE_NAME                 ');
    vQuery1.SQL.Add('      AND rc.RDB$CONSTRAINT_TYPE=''PRIMARY KEY''          ');
    vQuery1.SQL.Add('      AND rc.RDB$CONSTRAINT_TYPE IS NOT NULL              ');
    vQuery1.SQL.Add(' ORDER BY s.RDB$FIELD_POSITION                            ');

    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME AS TABLE_NAME , SYNC_KEY_NAMES     ');
    vQuery.SQL.Add('FROM RDB$RELATIONS                                          ');
    vQuery.SQL.Add('JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME     ');
    vQuery.SQL.Add('WHERE ((RDB$SYSTEM_FLAG = 0) OR(RDB$SYSTEM_FLAG IS NULL))   ');
    vQuery.SQL.Add(' AND (RDB$RELATION_NAME LIKE ''CASH%'')                     ');
    // Exception LOICK/GILLES renommage de champs en v18.2 => v19.x
    // c'est ailleurs...
    // vQuery.SQL.Add(' AND (RDB$RELATION_NAME <> ''CASHGROUPEROLE'')              ');
    //
    vQuery.SQL.Add(' AND (RDB$VIEW_SOURCE IS NULL)                              ');
    vQuery.SQL.Add('ORDER BY RDB$RELATION_NAME                                  ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Fields[2].AsString:='';
          if (VarIsNull(vQuery.Fields[1].Value))
            then
              begin
                 vQuery1.Close;
                 vQuery1.ParamByName('TABLE_NAME').AsString := vQuery.Fields[0].AsString;
                 vQuery1.Open();
                 virgule := '';
                 while not(vQuery1.Eof) do
                  begin
                     aDataSet.Fields[2].AsString:= aDataSet.Fields[2].AsString + virgule + vQuery1.Fields[2].AsString;
                     virgule := ',';
                     vQuery1.Next;
                  end;
              end;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;





procedure TDataMod.GetAllTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery,vQuery1 : TFDQuery;
    vCnx   : TFDConnection;
    virgule : string;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  vQuery1 := getNewQuery(vCnx,nil);
  try
    vQuery1.Close();
    vQuery1.SQL.Clear;
    vQuery1.SQL.Add('SELECT i.RDB$RELATION_NAME,                               ');
    vQuery1.SQL.Add('       rc.RDB$CONSTRAINT_NAME,                            ');
    vQuery1.SQL.Add('       s.RDB$FIELD_NAME AS field_name,                    ');
    vQuery1.SQL.Add('       (s.RDB$FIELD_POSITION + 1) AS field_position       ');
    vQuery1.SQL.Add('     FROM RDB$INDEX_SEGMENTS s                            ');
    vQuery1.SQL.Add('LEFT JOIN RDB$INDICES i ON i.RDB$INDEX_NAME = s.RDB$INDEX_NAME ');
    vQuery1.SQL.Add('LEFT JOIN RDB$RELATION_CONSTRAINTS rc ON rc.RDB$INDEX_NAME = s.RDB$INDEX_NAME ');
    vQuery1.SQL.Add('    WHERE i.RDB$RELATION_NAME=:TABLE_NAME                 ');
    vQuery1.SQL.Add('      AND rc.RDB$CONSTRAINT_TYPE=''PRIMARY KEY''          ');
    vQuery1.SQL.Add('      AND rc.RDB$CONSTRAINT_TYPE IS NOT NULL              ');
    vQuery1.SQL.Add(' ORDER BY s.RDB$FIELD_POSITION                            ');

    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME AS TABLE_NAME , SYNC_KEY_NAMES     ');
    vQuery.SQL.Add('FROM RDB$RELATIONS                                          ');
    vQuery.SQL.Add('JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME     ');
    vQuery.SQL.Add('WHERE ((RDB$SYSTEM_FLAG = 0) OR                             ');
    vQuery.SQL.Add('      (RDB$SYSTEM_FLAG IS NULL)) AND (RDB$VIEW_SOURCE IS NULL) ');
    vQuery.SQL.Add('ORDER BY RDB$RELATION_NAME                                  ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Fields[2].AsString:='';
          if (VarIsNull(vQuery.Fields[1].Value))
            then
              begin
                 vQuery1.Close;
                 vQuery1.ParamByName('TABLE_NAME').AsString := vQuery.Fields[0].AsString;
                 vQuery1.Open();
                 virgule := '';
                 while not(vQuery1.Eof) do
                  begin
                     aDataSet.Fields[2].AsString:= aDataSet.Fields[2].AsString + virgule + vQuery1.Fields[2].AsString;
                     virgule := ',';
                     vQuery1.Next;
                  end;
              end;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;





procedure TDataMod.GetTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME AS TABLE_NAME, F_LEFT(KTB_DATA, F_SUBSTR(''_ID'',KTB_DATA)+3) AS PRIMARY_KEY');
    vQuery.SQL.Add(' FROM RDB$RELATIONS                                       ');
    vQuery.SQL.Add(' JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME  ');
    vQuery.SQL.Add(' JOIN KTB ON KTB_NAME=RDB$RELATION_NAME                   ');
    vQuery.SQL.Add(' WHERE ((RDB$SYSTEM_FLAG = 0) OR                          ');
    vQuery.SQL.Add('  (RDB$SYSTEM_FLAG IS NULL)) AND                          ');
    vQuery.SQL.Add('(RDB$VIEW_SOURCE IS NULL)                                 ');
    vQuery.SQL.Add(' /* AND TRIGGER_ID IS NULL */                             ');
    vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME                               ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Post;
          vQuery.Next;
      END;
    if not(aDataSet.IsEmpty) then aDataSet.First;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

{
procedure TDataModuleTraitements.GetTablesReplicantes(const ABaseDonnees: TFileName;var aDataSet:TDataSet);
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  if (ABaseDonnees='') then exit;
  aDataSet.Close;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT RDB$RELATION_NAME AS TABLE_NAME, F_LEFT(KTB_DATA, F_SUBSTR(''_ID'',KTB_DATA)+3) AS PRIMARY_KEY');
    vQuery.SQL.Add(' FROM RDB$RELATIONS                                       ');
    vQuery.SQL.Add(' JOIN sym_trigger ON SOURCE_TABLE_NAME=RDB$RELATION_NAME  ');
    vQuery.SQL.Add(' JOIN KTB ON KTB_NAME=RDB$RELATION_NAME                   ');
    vQuery.SQL.Add(' WHERE ((RDB$SYSTEM_FLAG = 0) OR                          ');
    vQuery.SQL.Add('  (RDB$SYSTEM_FLAG IS NULL)) AND                          ');
    vQuery.SQL.Add('(RDB$VIEW_SOURCE IS NULL)                                 ');
    vQuery.SQL.Add(' /* AND TRIGGER_ID IS NULL */                             ');
    vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME                               ');
    vQuery.open;
    aDataSet.Open();
    while not(vQuery.eof) do
      begin
          aDataSet.Append;
          aDataSet.Fields[0].AsString:=vQuery.Fields[0].AsString;
          aDataSet.Fields[1].AsString:=vQuery.Fields[1].AsString;
          aDataSet.Post;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;
}

function TDataMod.ExecuteScript(const ABaseDonnees: TFileName;Asql:TStringList):boolean;
var vCnx   : TFDConnection;
    vScript: TFDScript;
    i:Integer;
    BufferSQL:string;
    vQuery : TFDQuery;

begin
  Result := true;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery:=TFDQuery.Create(DataMod);
  vScript:=TFDScript.Create(DataMod);
  try
     vScript.Connection:= vCnx;
     vScript.ScriptOptions.IgnoreError := false;
     vScript.ScriptOptions.BreakOnError := true;

     vQuery.Connection := vCnx;
     for i:= 0 to Asql.Count - 1 do
        begin
             IF Pos('^', ASql.Strings[i]) = 0
                then BufferSQL := BufferSQL + #13 + #10 + ASql.Strings[i];
             IF Pos('^', ASql.Strings[i]) = 1
                then
                    begin
                         Try
                            // ShowMessage(BufferSQL);
                            if (Pos('EXECUTE PROCEDURE ', UPPERCASE(Trim(BufferSQL))) = 1 ) then
                              begin
                                 vQuery.Close;
                                 vQuery.SQL.Clear;
                                 vQuery.SQL.Add(BufferSQL);
                                 vQuery.Prepare;
                                 vQuery.ExecSQL;
                              end
                            else
                              begin
                                 vScript.SQLScripts.Clear;
                                 vScript.SQLScripts.Add;
                                 vScript.SQLScripts[0].SQL.Add(BufferSQL);
                                 vScript.ValidateAll;
                                 vScript.ExecuteAll;
                              end;
                          BufferSQL:='';
                          Except On E:Exception do
                            begin
                               // ShowMessage(BufferSQL);
                               BufferSQL:='';
                               result:=false;
                            end;
                         end;
                    End;

        end;
  finally
    vCnx.DisposeOf();
    vScript.Free;
  end;

end;


function TDataMod.RestartDataBase(const ABaseDonnees: TFileName) : boolean;
var Config : TFDIBConfig;
begin
  Result := false;

  try
    try
      Config := TFDIBConfig.Create(nil);
      Config.DriverLink := FDPhysIBDriverLink;
      Config.Protocol := ipTCPIP;
      Config.Host := 'localhost';
      Config.Port := 3050;
      Config.Database := AbaseDonnees;
      Config.UserName := 'SYSDBA';
      Config.Password := 'masterkey';
      // Config.OnProgress := LogDriverMessage;
      Config.OnlineDB();
      Result := true;
    finally
      FreeAndNil(Config);
    end;
  except
    on e : Exception do
      // DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TDataMod.Get_GENPARAMS(const ABaseDonnees: TFileName;aWHERE:string):TGENPARAMS;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    i:integer;
begin
  SetLength(result,0);
  if (ABaseDonnees='') then exit;
  if (AWHERE='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM GENPARAM                ');
    vQuery.SQL.Add('JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 ');
    vQuery.SQL.Add(Format(' WHERE %s ',[aWHERE]));
    vQuery.open;
    while not(vQuery.Eof) do
      begin
         i:=length(result);
         SetLength(result,i+1);
         result[i].PRM_ID     := vQuery.FieldByName('PRM_ID').Asinteger;
         result[i].PRM_STRING := vQuery.FieldByName('PRM_STRING').Asstring;
         vQuery.Next;
       END;
    vQuery.Close;
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;


//---------------- Pour savoir tout les infos de passage de Delos à EASY     ///

function TDataMod.Get_Infos_Passage_DELOS2EASY(const ABaseDonnees: TFileName):TInfosDelosEASY;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result.Init;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM GENBASES ');
    vQuery.SQL.Add(' JOIN GENPARAMBASE  ON (PAR_STRING = BAS_IDENT AND PAR_NOM = ''IDGENERATEUR'') ');
    vQuery.open;
    if vQuery.RecordCount=1
      then
        begin
            result.BAS_ID     := vQuery.FieldByName('BAS_ID').Asinteger;
            result.GUID       := vQuery.FieldByName('BAS_GUID').Asstring;
            result.SENDER     := vQuery.FieldByName('BAS_SENDER').Asstring;
            Result.BAS_IDENT  := vQuery.FieldByName('BAS_IDENT').Asstring;
            Result.BAS_MAGID  := vQuery.FieldByName('BAS_MAGID').Asinteger;
            result.Dossier    := vQuery.FieldByName('BAS_NOMPOURNOUS').asstring;
        END
    else exit;

    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM GENPARAM                 ');
    vQuery.SQL.Add(' JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 ');
    vQuery.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=2 AND PRM_POS=:BASID  ');
    vQuery.ParamByName('BASID').AsInteger := Result.BAS_ID;
    vQuery.open;
    if vQuery.RecordCount=1
      then
        begin
            result.DatePassage := vQuery.FieldByName('PRM_FLOAT').AsFloat;
            result.Etat        := vQuery.FieldByName('PRM_INTEGER').Asinteger;
            // result.Dossier     := vQuery.FieldByName('PRM_STRING').asstring;
        end;
    vQuery.Close;
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;



function TDataMod.GetGinkoiaVersion(const ABaseDonnees: TFileName):string;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := '';
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT VER_VERSION FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
    vQuery.open;
    while not(vQuery.eof) do
      begin
          result := vQuery.Fields[0].AsString;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;


function TDataMod.GetCheminBaseGENREPLICATION(const ABaseDonnees: TFileName):string;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := '';
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT REP_PLACEBASE    ');
    vQuery.SQL.Add('FROM GENBASES           ');
    vQuery.SQL.Add('JOIN GENPARAMBASE     ON (PAR_STRING = BAS_IDENT AND PAR_NOM = ''IDGENERATEUR'' ) ');
    vQuery.SQL.Add('JOIN GENLAUNCH        ON (LAU_BASID = BAS_ID)                                     ');
    vQuery.SQL.Add('JOIN K KLAU           ON (KLAU.K_ID = LAU_ID AND KLAU.K_ENABLED = 1)              ');
    vQuery.SQL.Add('JOIN GENREPLICATION   ON (REP_LAUID = LAU_ID AND REP_ORDRE > 0)                   ');
    vQuery.SQL.Add('JOIN K KREP           ON (KREP.K_ID = LAU_ID AND KREP.K_ENABLED = 1)              ');
    vQuery.open();
    while not(vQuery.eof) do
      begin
          result := vQuery.Fields[0].AsString;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

function TDataMod.UpdateREP_PLACEBASE(const ABaseDonnees: TFileName;ABase0:string):boolean;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    vREPID : integer;
    vPR_UPDATEK : TFDStoredProc;
begin
  Result := false;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  vPR_UPDATEK := getNewStoredProc(vCnx,nil,'PR_UPDATEK');
  try
    vREPID:=0;
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT REP_ID, REP_PLACEBASE ');
    vQuery.SQL.Add('FROM GENBASES           ');
    vQuery.SQL.Add('JOIN GENPARAMBASE     ON (PAR_STRING = BAS_IDENT AND PAR_NOM = ''IDGENERATEUR'' ) ');
    vQuery.SQL.Add('JOIN GENLAUNCH        ON (LAU_BASID = BAS_ID)                                     ');
    vQuery.SQL.Add('JOIN K KLAU           ON (KLAU.K_ID = LAU_ID AND KLAU.K_ENABLED = 1)              ');
    vQuery.SQL.Add('JOIN GENREPLICATION   ON (REP_LAUID = LAU_ID AND REP_ORDRE > 0)                   ');
    vQuery.SQL.Add('JOIN K KREP           ON (KREP.K_ID = LAU_ID AND KREP.K_ENABLED = 1)              ');
    vQuery.open();
    if not(vQuery.IsEmpty)
      then
        begin
          vREPID := vQuery.FieldByName('REP_ID').Asinteger;
        end;

    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('UPDATE GENREPLICATION SET REP_PLACEBASE=:PLACEBASE WHERE REP_ID=:REPID');
    vQuery.ParamByName('PLACEBASE').AsString  := UpperCase(ABase0);
    vQuery.ParamByName('REPID').Asinteger := vREPID;
    vQuery.ExecSQL;

    vPr_UPDATEK.Close;
    vPR_UPDATEK.ParamByName('K_ID').AsInteger        := vREPID;
    vPR_UPDATEK.ParamByName('SUPRESSION').AsInteger := 0;
    vPr_UpdateK.ExecProc();

    result:=true;
    vQuery.Close();
  finally
    vPR_UPDATEK.DisposeOf;
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

function TDataMod.UpdateGenParamDelos2EasyByGUID(const ABaseDonnees: TFileName; const aGUID: string; const AValue:integer):boolean;
var
  vQuery : TFDQuery;
  vCnx   : TFDConnection;
  vTrans : TFDTransaction;
  Vprmid : Integer;
begin
  Result := false;

  if (ABaseDonnees = '') or (aGUID = '') then
    exit;

  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vTrans := getNewTransaction(vCnx);
  vQuery := getNewQuery(vCnx,nil);

  try
    vTrans.StartTransaction;

    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT prm_id FROM genparam');
    vQuery.SQL.Add('JOIN genbases ON bas_id = prm_pos');
    vQuery.SQL.Add('JOIN k ON k_id = bas_id');
    vQuery.SQL.Add('WHERE k_enabled = 1 AND prm_type = 80 AND prm_code = 2');
    vQuery.SQL.Add('AND bas_guid = :guid');
    vQuery.ParamByName('guid').AsString := aGUID;
    vQuery.Open;

    if (vQuery.IsEmpty) then
    begin
      Log.Log('Main', 'MajGenParam', 'Le genparam n''a pas été trouvé', logError);
      Exit;
    end
    else
    begin
      Vprmid := vQuery.FieldByName('prm_id').AsInteger;
      vQuery.Close;

      vQuery.SQL.Clear;
      vQuery.SQL.Add('UPDATE GENPARAM SET prm_integer = :prm_value WHERE prm_id = :prm_id');
      vQuery.ParamByName('prm_value').AsInteger := aValue;
      vQuery.ParamByName('prm_id').AsInteger := Vprmid;
      vQuery.ExecSQL;

      vTrans.Commit;

      Result := True;
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
    vTrans.DisposeOf();
  end;
end;


function TDataMod.GetGENERAL_ID(const ABaseDonnees: TFileName):integer;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := 0;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
    vQuery.Open();
    If (vQuery.RecordCount=1) then
       begin
          result := vQuery.Fields[0].AsInteger;
       end;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;


function TDataMod.GetPLAGE(const ABaseDonnees: TFileName):string;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    vBAS_IDENT : integer;
begin
  Result := '';
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT * FROM GENPARAMBASE WHERE PAR_NOM=:NOM');
    vQuery.ParamByName('NOM').asstring := 'IDGENERATEUR';
    vQuery.Open();
    if not(vQuery.IsEmpty) then
      begin
        vBAS_IDENT:=vQuery.FieldByName('PAR_STRING').asinteger;
      end;
    vQuery.Close;

    vQuery.Close;
    vQuery.SQL.Clear();
    vQuery.SQL.Add('SELECT BAS_GUID, BAS_SENDER, BAS_PLAGE ');
    vQuery.SQL.Add(' FROM   GENBASES       ');
    vQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1)');
    vQuery.SQL.Add('  WHERE BAS_IDENT=:BASIDENT ');
    vQuery.ParamByName('BASIDENT').AsString:=IntToStr(vBAS_IDENT);
    vQuery.Open();
    if not(vQuery.IsEmpty) then
      begin
        result  := vQuery.Fields[2].AsString;
      end;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

//----------------------------------------------------------------------

function TDataMod.GetLocalNode(const ABaseDonnees: TFileName):string;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := '';
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT * FROM SYM_NODE_SECURITY ');
    vQuery.open;
    while not(vQuery.eof) do
      begin
          result := vQuery.Fields[0].Asstring;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

function TDataMod.AjouteDossierBackupLame(aDB:TDossierInfos):Boolean;
var vIniFile : TIniFile;
    vSection : string;
begin
    Result := false;
    If FileExists(VGSE.EASY_BackupLame_Ini) then
     begin
          vIniFile := TIniFile.Create(VGSE.EASY_BackupLame_Ini) ;
          try
            vSection := StringReplace(aDB.ServiceName,'EASY_','',[rfIgnoreCase]);
            vIniFile.WriteString(vSection,'EASYSERVICE',aDB.ServiceName);
            vIniFile.WriteString(vSection,'IBFILE',aDB.DatabaseFile);
            vIniFile.WriteString(vSection,'INSTALL',FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()));
            vIniFile.WriteString(vSection,'LAST',FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()));
            vIniFile.WriteString(vSection,'LASTOK',FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()));
            vIniFile.WriteInteger(vSection,'TIME',1800);
            vIniFile.WriteInteger(vSection,'LASTRESULT',0);
            result := true;
          finally
            vIniFile.Free;
          end;
     end;
end;


function TDataMod.NbTriggersSymDS(const ABaseDonnees: TFileName):integer;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := 0;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT COUNT(*) FROM RDB$TRIGGERS            ');
    vQuery.SQL.Add('WHERE RDB$SYSTEM_FLAG=0                      ');
    vQuery.SQL.Add('    AND RDB$RELATION_NAME NOT LIKE ''SYM_%'' ');
    vQuery.SQL.Add('    AND RDB$TRIGGER_NAME LIKE ''SYM_%''      ');
    vQuery.open;
    while not(vQuery.eof) do
      begin
          result := vQuery.Fields[0].Asinteger;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;


function TDataMod.NbTableTriggersSymDS(const ABaseDonnees: TFileName):integer;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    vSens  : string;
begin
  Result := 0;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    try
      // Avant c'etait ca.... mais maintenant ca se complexifie
      // vQuery.Close();
      // vQuery.SQL.Clear;
      // vQuery.SQL.Add('SELECT SUM(SYNC_ON_UPDATE+SYNC_ON_INSERT+SYNC_ON_DELETE) FROM SYM_TRIGGER A ');
      // vQuery.SQL.Add('   JOIN SYM_TRIGGER_ROUTER B ON B.TRIGGER_ID=A.TRIGGER_ID AND ROUTER_ID=''lame_vers_mags'' ');

      // j'ai essayé ca.... mais je ne suis pas content .... il y a toujours le meme nombre que le nombre de trigger donc pas satisiferant
      // vQuery.SQL.Clear;
      // vQuery.SQL.Add('SELECT COUNT(NAME_FOR_INSERT_TRIGGER)+COUNT(NAME_FOR_UPDATE_TRIGGER)+COUNT(NAME_FOR_DELETE_TRIGGER) FROM SYM_TRIGGER_HIST ');
      // vQuery.SQL.Add(' WHERE UPPER(SOURCE_TABLE_NAME) NOT LIKE ''SYM_%'' AND INACTIVE_TIME IS NULL ');



      // Je suis quel type de noeud ?
      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT router_id FROM SYM_NODE N ');
      vQuery.SQL.Add(' JOIN SYM_NODE_IDENTITY I ON I.NODE_ID=N.NODE_ID ');
      vQuery.SQL.Add(' JOIN SYM_ROUTER R ON R.source_node_group_id=N.node_group_id ');
      vQuery.open;
      vSens := 'lame_vers_mags'; // il peut y avoir plusieurs enregsitrements (surtout sur la lame)
      If (vQuery.RecordCount=1)
        then
          begin
            vSens := vQuery.FieldByName('router_id').AsString;
          end;

      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT SUM(SYNC_ON_UPDATE+SYNC_ON_INSERT+SYNC_ON_DELETE) FROM SYM_TRIGGER A ');
      vQuery.SQL.Add('   JOIN SYM_TRIGGER_ROUTER B ON B.TRIGGER_ID=A.TRIGGER_ID AND ROUTER_ID=:ROUTERID');
      vQuery.ParamByName('ROUTERID').AsString := vSens;
      vQuery.open;
      while not(vQuery.eof) do
        begin
            result := vQuery.Fields[0].Asinteger;
            vQuery.Next;
        END;
    vQuery.Close();
    Except
      // si la table n'existe pas encore... ca plante... faudrait
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;


function TDataMod.EasyMvtLocalNode(const ABaseDonnees: TFileName):TNode;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
begin
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT N.NODE_ID, N.NODE_GROUP_ID, H.HEARTBEAT_TIME FROM SYM_NODE N');
    vQuery.SQL.Add(' JOIN SYM_NODE_HOST H ON H.NODE_ID=N.NODE_ID      ');
    vQuery.SQL.Add(' JOIN SYM_NODE_IDENTITY I ON (I.NODE_ID=N.NODE_ID)');
    vQuery.Open();
    If not(vQuery.IsEmpty) then
    begin
      result.NODE_ID        := vQuery.FieldByName('NODE_ID').Asstring;
      result.NODE_GROUP_ID  := vQuery.FieldByName('NODE_GROUP_ID').Asstring;
      result.HEARTBEAT_TIME := vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime;
    end;
    vQuery.Close();
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;

function TDataMod.EasyMvtListeRemoteNodes(const ABaseDonnees: TFileName):TNodes;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
begin
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT N.NODE_ID, N.NODE_GROUP_ID, H.HEARTBEAT_TIME, S.REGISTRATION_TIME ');
    vQuery.SQL.Add(' FROM SYM_NODE N                                    ');
    vQuery.SQL.Add(' JOIN SYM_NODE_SECURITY  S ON S.NODE_ID=N.NODE_ID   ');
    vQuery.SQL.Add(' LEFT JOIN SYM_NODE_HOST H ON H.NODE_ID=N.NODE_ID   ');
    vQuery.SQL.Add(' JOIN SYM_NODE_IDENTITY I ON (I.NODE_ID<>N.NODE_ID) ');
    vQuery.SQL.Add(' ORDER BY N.NODE_ID ');
    SetLength(result,0);
    vQuery.Open();
    while not(vQuery.Eof) do
    begin
      i:=Length(result);
      SetLength(result,i+1);
      result[i].NODE_ID        := vQuery.FieldByName('NODE_ID').Asstring;
      result[i].NODE_GROUP_ID  := vQuery.FieldByName('NODE_GROUP_ID').Asstring;
      result[i].HEARTBEAT_TIME := vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime;
      result[i].REGISTRATION_TIME := vQuery.FieldByName('REGISTRATION_TIME').AsDateTime;
      vQuery.Next();
    end;
    vQuery.Close();
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;



function TDataMod.EasyLastReplicDELOS(const ABaseDonnees: TFileName):TLastRepicDelos;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
begin
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT HEV_DATE, BAS_SENDER,  ');
    vQuery.SQL.Add('    K.K_VERSION, K.K_UPDATED ');
    vQuery.SQL.Add('       from genhistoevt       ');
    vQuery.SQL.Add('       join k on (k_id=hev_id and k_enabled=1) ');
    vQuery.SQL.Add('       join genbases on (bas_id=hev_basid)     ');
    vQuery.SQL.Add('WHERE HEV_TYPE = 2998  and  HEV_RESULT = 1     ');
    vQuery.SQL.Add('ORDER By K_VERSION                             ');
    vQuery.Close();
    SetLength(result,0);
    vQuery.Open();
    while not(vQuery.Eof) do
    begin
      i:=Length(result);
      SetLength(result,i+1);
      result[i].HEV_DATE    := vQuery.FieldByName('HEV_DATE').AsDateTime;
      result[i].BAS_SENDER  := vQuery.FieldByName('BAS_SENDER').Asstring;
      result[i].K_VERSION   := vQuery.FieldByName('K_VERSION').Asinteger;
      result[i].K_UPDATED   := vQuery.FieldByName('K_UPDATED').AsDateTime;
      vQuery.Next();
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;



function TDataMod.DetectNodeIBDeadLock(const ABaseDonnees: TFileName):string;
var vQuery,vQBacth  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
    vNode:string;
    vEventType : string;
    vCondition : string;
    vVirgule   : string;
begin
  result := '';
  if FileExists(ABaseDonnees) then
    begin
      try
        vCnx   := getNewConnexion('GINKOIA@'+ABaseDonnees);
        vQuery  := getNewQuery(vCnx,nil);
        try
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT NODE_ID, MIN(BATCH_ID), MIN(CREATE_TIME)  ');
          vQuery.SQL.Add('  FROM SYM_OUTGOING_BATCH ');
          vQuery.SQL.Add(' WHERE STATUS=''ER'' AND SQL_MESSAGE LIKE ''%deadlock%'' ' );
          vQuery.SQL.Add(' GROUP BY NODE_ID ');
          vQuery.Open();

          vVirgule := '';
          while not(vQuery.eof) do
            begin
               vNode  := vQuery.FieldByName('NODE_ID').asstring;
               Result := Result + vVirgule + Format('%s deadlock',[vNode]);
               vVirgule := ',';
               vQuery.Next;
            end;
          vQuery.Close();
        except
          On E:Exception do
            // Des fois la base est présente mais Shutdown
            begin
              result := 'ER:'+E.Message;
            end;
        end;
      finally
        vCnx.DisposeOf;
        vQuery.DisposeOf;
      end;
    end;
end;



// On analyse les bases cassées à distance....==> on remonte au monitoring...
function TDataMod.DetectNodeIBCorrupt(const ABaseDonnees: TFileName):string;
var vQuery,vQBacth  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
    vNode:string;
    vEventType : string;
    vCondition : string;
    vVirgule   : string;
begin
  result := '';
  if FileExists(ABaseDonnees) then
    begin
      try
        vCnx   := getNewConnexion('GINKOIA@'+ABaseDonnees);
        vQuery  := getNewQuery(vCnx,nil);
        try
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT NODE_ID, MIN(BATCH_ID), MIN(CREATE_TIME)  ');
          vQuery.SQL.Add('  FROM SYM_OUTGOING_BATCH ');
          vQuery.SQL.Add(' WHERE STATUS=''ER'' AND SQL_MESSAGE LIKE ''%database file appears corrupt ()%'' ' );
          vQuery.SQL.Add(' GROUP BY NODE_ID ');
          vQuery.Open();

          vVirgule := '';
          while not(vQuery.eof) do
            begin
               vNode  := vQuery.FieldByName('NODE_ID').asstring;
               Result := Result + vVirgule + Format('%s base corrompue',[vNode]);
               vVirgule := ',';
               vQuery.Next;
            end;
          vQuery.Close();
        except
          On E:Exception do
            // Des fois la base est présente mais Shutdown
            begin
              result := 'ER:'+E.Message;
            end;
        end;
      finally
        vCnx.DisposeOf;
        vQuery.DisposeOf;
      end;
    end;
end;


function TDataMod.EasyMvtKenabled_INSERT(const ABaseDonnees: TFileName):string;
var vQuery  : TFDQuery;
    vInsert : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
    vNodeID    : string;
    vEventType : string;
    vCondition : string;
    vTRIGID    : integer;
    vBatchID   : Int64;
    vDATAID    : int64;
    vVirgule   : string;

    vNbEr      : integer;
    vZap       : integer;
    vReload    : Integer;
begin
  result := 'RAS';
  if FileExists(ABaseDonnees) then
    begin
      try
        vCnx   := getNewConnexion('GINKOIA@'+ABaseDonnees);
        // vTrans := getNewTransaction(vCnx);
        vQuery  := getNewQuery(vCnx,nil);
        vInsert := getNewQuery(vCnx,nil);
        try
          vTRIGID := 0;
          vQuery.Close();
          vQuery.SQL.Clear;
          vQuery.SQL.Add('select max(trigger_hist_id) from sym_trigger_hist where trigger_id=:TRGNAME ');
          vQuery.ParamByname('TRGNAME').asstring := 'K';
          vQuery.Open();

          if not(vQuery.IsEmpty) then
            begin
              vTRIGID := vQUery.Fields[0].asinteger;
            end;

          if vTRIGID=0 then
            exit;

          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT BATCH_ID, DATA_ID, NODE_ID, ROW_DATA ');
          vQuery.SQL.Add('  FROM SYM_OUTGOING_BATCH ');
          vQuery.SQL.Add(' JOIN SYM_DATA ON DATA_ID = FAILED_DATA_ID ');
          vQuery.SQL.Add(' WHERE STATUS=''ER'' AND SQL_MESSAGE LIKE ''%MVT_KENABLED%'' AND EVENT_TYPE=''I''  ' );
          vQuery.Open();

          vNbEr := 0;
          vZap  := 0;
          vReload := 0;
          while not(vQuery.eof) do
            begin
               Inc(vNbEr);
               vBatchID   := vQuery.FieldByName('BATCH_ID').asLargeInt;
               vDATAID    := vQuery.FieldByName('DATA_ID').asLargeInt;
               vNodeID    := vQuery.FieldByName('NODE_ID').asstring;
               // Si le site distant à déja un reload en cours c'est à dire 'NE' sur reload on fait rien
               vInsert.Close();
               vInsert.SQl.Clear;
               vInsert.SQl.Add('SELECT LOAD_ID              ');
               vInsert.SQl.Add('FROM SYM_OUTGOING_BATCH     ');
               vInsert.SQl.Add('WHERE NODE_ID=:NODE AND STATUS=''NE'' ');
               vInsert.SQl.Add('AND CHANNEL_ID=''reload''             ');
               vInsert.SQl.Add('AND LOAD_ID>0               ');
               vInsert.SQl.Add('ROWS 1                      ');
               vInsert.ParamByName('NODE').asstring      := vNodeID;
               vInsert.Open();
               if not(vInsert.eof)
                 then
                   begin
                     Inc(vZap);
                     vQuery.Next;
                     Continue;
                   end;

               // Uniquement les tables "STOCK"
               // il faut analyse 'ROW_DATA' pour passer le K_ID
               vCONDITION := vQuery.FieldByName('ROW_DATA').asstring;
               vCONDITION := Copy(vCONDITION,  1, Pos(',', vCONDITION)-1);
               vCONDITION := StringReplace(vCONDITION,'"','',[rfReplaceAll]);
               vCONDITION := 'K_ID='+vCONDITION;

               vInsert.Close();
               vInsert.SQl.Clear;
               vInsert.SQl.Add('INSERT INTO SYM_DATA (TABLE_NAME, EVENT_TYPE, ROW_DATA,TRIGGER_HIST_ID, CHANNEL_ID, NODE_LIST, CREATE_TIME)');
               vInsert.SQl.Add(' VALUES (''K'', ''R'', :CONDITION, :TRIGID, ''reload'', :NODE ,current_timestamp);');
               vInsert.ParamByName('CONDITION').asstring := vCONDITION;
               vInsert.ParamByName('TRIGID').asinteger   := vTRIGID;
               vInsert.ParamByName('NODE').asstring      := vNodeID;
               vInsert.ExecSQL;
               Inc(vReload);

               vQuery.Next;
            end;

          If (vNbEr<>0)
            then Result := Format('ER:%d | ZAP:%d | RELOAD:%d ',[vNbEr,vZap,vReload]);

          vQuery.Close();
          vInsert.Close();
        finally
          vQuery.DisposeOf();
          vInsert.DisposeOf();
          vCnx.DisposeOf();
          DataMod.FreeInfFDManager('GINKOIA@'+ABaseDonnees);
        end;
      except
          On E:Exception do
            // Des fois la base est présente mais Shutdown
            begin
              result := 'ER:'+E.Message;
            end;
    end;
  end;
end;





function TDataMod.EasyMvtKenabled(const ABaseDonnees: TFileName;Const aMAXROWS:Integer=50):string;
var vQuery,vQBatch  : TFDQuery;
    vInsert : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
    vNodeID    : string;
    vEventType : string;
    vCondition : string;
    vTRIGID    : integer;
    vBatchID   : Int64;
    vDATAID    : int64;
    vVirgule   : string;
    vIncRows   : integer;
    vInc       : integer;
    vNbEr      : integer;
    vZap       : integer;
    vReload    : Integer;
begin
  result := 'RAS';
  if FileExists(ABaseDonnees) then
    begin
      try
        vCnx   := getNewConnexion('GINKOIA@'+ABaseDonnees);
        // vTrans := getNewTransaction(vCnx);
        vQuery  := getNewQuery(vCnx,nil);
        vQBatch := getNewQuery(vCnx,nil);
        vInsert := getNewQuery(vCnx,nil);   // vTrans
        try
          vTRIGID := 0;
          vQuery.Close();
          vQuery.SQL.Clear;
          vQuery.SQL.Add('select max(trigger_hist_id) from sym_trigger_hist where trigger_id=:TRGNAME ');
          vQuery.ParamByname('TRGNAME').asstring := 'K';
          vQuery.Open();

          if not(vQuery.IsEmpty) then
            begin
              vTRIGID := vQUery.Fields[0].asinteger;
            end;

          if vTRIGID=0 then
            exit;

          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT BATCH_ID, DATA_ID, NODE_ID ');
          vQuery.SQL.Add('  FROM SYM_OUTGOING_BATCH ');
          vQuery.SQL.Add(' JOIN SYM_DATA ON DATA_ID = FAILED_DATA_ID ');
          vQuery.SQL.Add(' WHERE STATUS=''ER'' AND SQL_MESSAGE LIKE ''%MVT_KENABLED%'' AND EVENT_TYPE=''U''  ' );
          vQuery.Open();

          vNbEr := 0;
          vInc  := 0;
          vZap  := 0;
          vReload := 0;
          while not(vQuery.eof) do
            begin
               Inc(vNbEr);
               vBatchID   := vQuery.FieldByName('BATCH_ID').asLargeInt;
               vDATAID    := vQuery.FieldByName('DATA_ID').asLargeInt;
               vNodeID    := vQuery.FieldByName('NODE_ID').asstring;
               // Si le site distant à déja un reload en cours c'est à dire 'NE' sur reload on fait rien
               vInsert.Close();
               vInsert.SQl.Clear;
               vInsert.SQl.Add('SELECT LOAD_ID              ');
               vInsert.SQl.Add('FROM SYM_OUTGOING_BATCH     ');
               vInsert.SQl.Add('WHERE NODE_ID=:NODE AND STATUS=''NE'' ');
               vInsert.SQl.Add('AND CHANNEL_ID=''reload''             ');
               vInsert.SQl.Add('AND LOAD_ID>0               ');
               vInsert.SQl.Add('ROWS 1                      ');
               vInsert.ParamByName('NODE').asstring      := vNodeID;
               vInsert.Open();
               if not(vInsert.eof)
                 then
                   begin
                     Inc(vZap);
                     vQuery.Next;
                     Continue;
                   end;

               // Uniquement les tables "STOCK"
               vQBatch.Close();
               vQBatch.SQL.Clear;
               vQBatch.SQL.Add('SELECT BATCH_ID, DATA_ID, TABLE_NAME, PK_DATA         ');
               vQBatch.SQL.Add(' FROM SYM_DATA_EVENT E                                ');
               vQBatch.SQL.Add(' JOIN SYM_OUTGOING_BATCH B ON B.BATCH_ID = E.BATCH_ID ');
               vQBatch.SQL.Add(' JOIN SYM_DATA D ON (D.DATA_ID=E.DATA_ID              ');
               vQBatch.SQL.Add('  AND D.TABLE_NAME IN (''COMBCDEL'',''COMRETOURL'',   ');
               vQBatch.SQL.Add('  ''CONSODIV'',''CSHTICKETL'',''NEGFACTUREL'',''NEGBLL'', ');
               vQBatch.SQL.Add('  ''RECBRL'',''TRANSFERTIML'')                        ');
               vQBatch.SQL.Add('  AND D.EVENT_TYPE=''U''  )                          ');
               vQBatch.SQL.Add(' WHERE E.BATCH_ID=:BATCHID                           ');
//             La condition suivante passe par un mauvais plan
//               vQBatch.SQL.Add('  AND D.DATA_ID>=:DATAID                      ');
               vQBatch.SQL.Add(' ORDER BY D.DATA_ID                             ');
               vQBatch.SQL.Add('  ROWS 1000 ');     // pas plus de 1000
//             vQBatch.SQL.Add(Format('  ROWS %d ',[aMAXROWS]));
               vQBatch.ParamByName('BATCHID').aslargeInt := vBATCHID;
//               vQBatch.ParamByName('DATAID').aslargeInt  := vDATAID;
               vQBatch.OptionsIntf.FetchOptions.Unidirectional;
               vCONDITION := 'K_ID IN (';
               vVirgule   := '';

               vQBatch.Open();
               vIncRows := 0;
               while not(vQBatch.eof) do
                begin
                   // C'est plus rapide par programme que par une requete SQL
                   // il faudra peut autre aussi exclure les TABLE dans le SQL si c'est aussi lent....
                   // et le faire par Delphi
                   if vQBatch.FieldByName('DATA_ID').aslargeInt < vDATAID then
                    begin
                      vQBatch.Next;
                      Continue;
                    end;


                   //,[StringReplace(vQuery.FieldByName('PK_DATA').asstring,'"','',[rfreplaceAll])]);
                   // ca compte le nombre de "IN CONDITION"
                   Inc(vInc);
                   Inc(vIncRows);

                   vCONDITION := vCONDITION + vVirgule + StringReplace(vQBatch.FieldByName('PK_DATA').asstring,'"','',[rfreplaceAll]);
                   vVirgule := ',';

                   if (Length(vCondition)>4000) or (vIncRows>aMAXROWS)
                     then break;
                   vQBatch.Next;
                end;

               vCONDITION := vCONDITION + ')';

               if vVirgule<>'' then
                begin
                   vInsert.Close();
                   vInsert.SQl.Clear;
                   vInsert.SQl.Add('INSERT INTO SYM_DATA (TABLE_NAME, EVENT_TYPE, ROW_DATA,TRIGGER_HIST_ID, CHANNEL_ID, NODE_LIST, CREATE_TIME)');
                   vInsert.SQl.Add(' VALUES (''K'', ''R'', :CONDITION, :TRIGID, ''reload'', :NODE ,current_timestamp);');
                   vInsert.ParamByName('CONDITION').asstring := vCONDITION;
                   vInsert.ParamByName('TRIGID').asinteger   := vTRIGID;
                   vInsert.ParamByName('NODE').asstring      := vNodeID;
                   vInsert.ExecSQL;
                   // Nombre de Reload
                   Inc(vReload);
                end;

               vQuery.Next;
            end;

          If (vNbEr<>0)
            then Result := Format('ER:%d | ZAP:%d | INC:%d | RELOAD:%d ',[vNbEr,vZap, vInc,vReload]);

          vQBatch.Close();
          vQuery.Close();
          vInsert.Close();
        finally
          vQuery.DisposeOf();
          vQBatch.DisposeOf();
          vInsert.DisposeOf();
          vCnx.DisposeOf();
          DataMod.FreeInfFDManager('GINKOIA@'+ABaseDonnees);
        end;
      except
          On E:Exception do
            // Des fois la base est présente mais Shutdown
            begin
              result := 'ER:'+E.Message;
            end;
    end;
  end;
end;


function TDataMod.IsEasyInstalled(const ABaseDonnees: TFileName):Boolean;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
begin
  result := true;
  vCnx   := getNewConnexion('GINKOIA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    try
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT RDB$RELATION_NAME ');
      vQuery.SQL.Add('  FROM RDB$RELATIONS     ');
      vQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0 AND RDB$RELATION_NAME LIKE ''SYM_%'' ');
      vQuery.Open();
      if not(vQuery.Eof) then
        begin
          exit;
        end;

      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT RDB$TRIGGER_NAME FROM RDB$TRIGGERS ');
      vQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0 AND RDB$TRIGGER_NAME LIKE ''SYM_%'' ');
      vQuery.Open();
      if not(vQuery.Eof) then
        begin
           exit
        end;

      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT RDB$GENERATOR_NAME ');
      vQuery.SQL.Add('  FROM RDB$GENERATORS     ');
      vQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0 AND RDB$GENERATOR_NAME=''GEN_SYM_DATA_DATA_ID'' ');
      vQuery.Open();
      if not(vQuery.Eof) then
        begin
           exit
        end;
      // Donc on repond faux seulement si tout est vide..
      result := false;
    Except
      result := true;
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;

function TDataMod.EasyUnsentBatchs(const ABaseDonnees: TFileName):TUnsentBatchs;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    i,j:integer;
    vfound :boolean;
    vSenderNodes : TSenderNodes;
begin
  SetLength(Result,0);
  vCnx   := getNewConnexion('GINKOIA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    try
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT BAS_SENDER, CAST(BAS_IDENT AS INTEGER) AS BAS_IDENT, BAS_GUID, BAS_NOMPOURNOUS ');
      vQuery.SQL.Add('  FROM   GENBASES ');
      vQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1) ');
      vQuery.SQL.Add(' WHERE  BAS_GUID != '''' ORDER BY 2 ASC ; ');
      vQuery.Open();
      SetLength(vSenderNodes,0);
      while not(vQuery.Eof) do
      begin
        i:=Length(vSenderNodes);
        SetLength(vSenderNodes,i+1);
        vSenderNodes[i].SENDER  := vQuery.FieldByName('BAS_SENDER').Asstring;
        vSenderNodes[i].NODEID  := Sender_To_Node(vQuery.FieldByName('BAS_SENDER').Asstring);
        vSenderNodes[i].GUID    := vQuery.FieldByName('BAS_GUID').Asstring;
        vSenderNodes[i].NOMPOURNOUS  := vQuery.FieldByName('BAS_NOMPOURNOUS').Asstring;
        vQuery.Next();
      end;


      // Pour SET à zéro...
      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT NODE_ID FROM SYM_NODE ');
      vQuery.SQL.Add(' WHERE NODE_GROUP_ID IN (''mags'',''portables'') ');

      SetLength(result,0);
      vQuery.Open();
      while not(vQuery.Eof) do
        begin
          i:=Length(result);
          SetLength(result,i+1);
          result[i].Init;
          result[i].NODEID      := vQuery.FieldByName('NODE_ID').Asstring;
          // faut encore trouver le GUID..... et le SENDER ....
          vfound := false;
          for j := Low(vSenderNodes) to High(vSenderNodes) do
            begin
              if (result[i].NODEID=vSenderNodes[j].NODEID) then
                begin
                   result[i].SenderNode := vSenderNodes[j];
                   vfound := true;
                end;
            end;
          // ca arrive quand il renomme un SENDER et que le noeud est déja créer....
          // La C'est la merde dans ce cas..... Exemple "SAINTE POUR VINET"
          If Not(vfound)
            then
              begin
                // Ca correspond à rien.....
                result[i].SenderNode.NODEID      := result[i].NODEID;
                result[i].SenderNode.SENDER      := result[i].NODEID;
                result[i].SenderNode.NOMPOURNOUS := vSenderNodes[Low(vSenderNodes)].NOMPOURNOUS;
                result[i].SenderNode.GUID        := result[i].NODEID;
                // Rustine de merde a cause des gens qui renomme les sender une fois le noeud crée !!!
                if result[i].NODEID = 's_saintes_7843_vinet' then
                  begin
                    result[i].SenderNode.NODEID      := 's_saintes_7843_vinet';
                    result[i].SenderNode.SENDER      := 'SERVEUR_SAINTES_7483_VINET';
                    result[i].SenderNode.NOMPOURNOUS := 'VINET-NOSYMAG';
                    result[i].SenderNode.GUID        := '{D4459137-7077-4AC3-960C-E29C681FBD23}';
                  end;
                //--------------------------------------------------------------
              end;
          vQuery.Next();
        end;

      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT COUNT(*) AS BATCH_COUNT, SUM(DATA_EVENT_COUNT) AS DATA_COUNT, ');
      vQuery.SQL.Add(' NODE_ID, MIN(CREATE_TIME) AS OLDEST_BATCH ');
      vQuery.SQL.Add(' FROM SYM_OUTGOING_BATCH  ');
      vQuery.SQL.Add(' WHERE STATUS=''NE'' ');
      vQuery.SQL.Add(' GROUP BY NODE_ID    ');
      vQuery.SQL.Add(' ORDER BY 1 DESC     ');
      vQuery.Open();
      while not(vQuery.Eof) do
      begin
        for i := Low(result) to High(result) do
          begin
            if (result[i].NODEID=vQuery.FieldByName('NODE_ID').asstring) then
              begin
                  result[i].BATCHCOUNT  := vQuery.FieldByName('BATCH_COUNT').Asinteger;
                  result[i].DATACOUNT   := vQuery.FieldByName('DATA_COUNT').Asinteger;
                  result[i].OLDESTBATCH := vQuery.FieldByName('OLDEST_BATCH').Asstring;
              end;
          end;
        vQuery.Next();
      end;
      //
      vQuery.close();
    Except
      //
      //
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;


function TDataMod.EasyMvtListeBases(const ABaseDonnees: TFileName):TEasyBases;
var vQuery  : TFDQuery;
    vCnx    : TFDConnection;
    i:integer;
begin
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.SQL.Add('SELECT BAS_SENDER, CAST(BAS_IDENT AS INTEGER) AS BAS_IDENT, BAS_GUID ');
    vQuery.SQL.Add('  FROM   GENBASES ');
    vQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1) ');
    vQuery.SQL.Add(' WHERE  BAS_GUID != '''' ORDER BY 2 ASC ; ');
    vQuery.Open();

    SetLength(result,0);
    while not(vQuery.Eof) do
    begin
      i:=Length(result);
      SetLength(result,i+1);
      result[i].BAS_SENDER  := vQuery.FieldByName('BAS_SENDER').Asstring;
      result[i].CAL_SYMNODE := Sender_To_Node(vQuery.FieldByName('BAS_SENDER').Asstring);
      result[i].BAS_IDENT   := vQuery.FieldByName('BAS_IDENT').Asinteger;
      result[i].BAS_GUID    := vQuery.FieldByName('BAS_GUID').Asstring;
      vQuery.Next();
    end;
    //
    vQuery.close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('select MAX(HEV_DATE) AS LAST_REPLIC           ');
    vQuery.SQL.Add(' from genhistoevt                             ');
    vQuery.SQL.Add(' join k on (k_id=hev_id and k_enabled=1)      ');
    vQuery.SQL.Add(' join genbases on (bas_id=hev_basid)          ');
    vQuery.SQL.Add(' WHERE HEV_TYPE = 2998  and  HEV_RESULT = 1   ');
    vQuery.SQL.Add(' AND BAS_SENDER=:BASSENDER                    ');
    For i:=Low(result) to High(result) do
      begin
        result[i].LAST_REPLIC  := 0;
        vQuery.close();
        vQuery.ParamByName('BASSENDER').asString := result[i].BAS_SENDER;
        vQuery.Open();
        if not(vQuery.IsEmpty) then
          begin
            result[i].LAST_REPLIC  := vQuery.FieldByName('LAST_REPLIC').AsDateTime;
          end;
      end;

    try
      vQuery.close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('select * FROM SYM_NODE_HOST       ');
      vQuery.SQL.Add(' WHERE NODE_ID=:CALNODE           ');
      For i:=Low(result) to High(result) do
        begin
          result[i].NODE_ID := '';
          vQuery.close();
          vQuery.ParamByName('CALNODE').asString := result[i].CAL_SYMNODE;
          vQuery.Open();
          if not(vQuery.IsEmpty) then
            begin
              result[i].NODE_ID := vQuery.FieldByName('NODE_ID').Asstring
            end;
          vQuery.close();
        end;
    except
      On E:Exception
        Do
         begin
            raise Exception.Create('Easy n''est pas installé sur cette base');
         end;
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;






end.




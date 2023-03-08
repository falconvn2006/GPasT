unit uGenerique;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Controls,
  DateUtils,
  uCommon_DM,
  IniFiles,
  SysUtils,
  Forms,
  Types,
  uCreateCsv,
  Db,
  uCommon,
  MD5Api,
  Classes,
  XMLDoc,
  XMLIntf,
  StrUtils,
  uGeneriqueType,
  Math,
  Windows,
  Variants,
  uCommon_Type,
  IBODataset,
  SBSimpleSftp,
  SBTypes,
  SBSftpCommon,
  SBSSHConstants,
  SBSimpleFTPS,
  RegularExpressionsCore,
  SyncWebResStr,
  uWebVenteFid,
  IB_Components, uFidelite;

function DoGenGet(dHeureDebut, dHeureFin: TTime): Boolean;
function DoGenSend(dHeureDebut, dHeureFin: TTime; bEnd: Boolean; bZipper: Boolean; dLastDateArt: TDateTime; dLastDateStk: TDateTime; bInitialisation: Boolean = False; bInitStockUniquement: Boolean = False;  bDateFicInit: Boolean = False; bDateFic: Boolean = False): Boolean;

// Retourne le mode de traitement à faire MODE_XXXX
function IsTimerDone(dHeureDebut, dHeureFin: TTime; bEnd, bInitialisation, bInitStockUniquement: Boolean; dLastDateArt: TDateTime; dLastDateStk: TDateTime): TMode;
// MAJ des dates dans la table ARTEXPORTWEB après extraction
procedure MajDate(const ANomFichier: string; const ACurrentVersion: Int64); overload;
procedure MajDate(const ACurrentVersion, ACurrentVersionLame: Int64;
  const ANomFichier: string); overload;
procedure MajDate(const ACurrentVersion, ACurrentVersionLame, ACurrentVersionStock: Int64;
  const ANomFichier: string; AMagId: integer); overload;
// récup des LastVersion pour les Delta
procedure GetLastVersions(var AListeNom: TStringList; AListeIndex: Array of Integer; var ALastVersion: Int64; var ALastVersionLame: Int64);   overload;
procedure GetLastVersions(var AListeNom: TStringList; AListeIndex: Array of Integer; var ALastVersion: Int64; var ALastVersionLame: Int64; var LastDateExport: TDateTime);   overload;
// function de génération des fichiers articles
function GenerateCsvArtFiles(var AListeFichiers: TStringList; const ACurrentVersion, ACurrentVersionLame: Int64; const bInitialisation: Boolean = False; const bDateFicInit: Boolean = False; const bDateFic: Boolean = False): Boolean;
procedure GenerateCsvArtFiles_2(var AListeFichiers: TStringList; const bInitialisation: Boolean; const ACurrentVersion, ACurrentVersionLame, iLastVersion: int64; const sCheminCsv, sDatePourFic: String);
procedure GenerateCsvArtFiles_3(var AListeFichiers: TStringList; const bInitialisation: Boolean; const ACurrentVersion, ACurrentVersionLame, iLastVersion: int64; const sCheminCsv, sDatePourFic: String);
// function de génération des fichiers de stocks
function GenerateCsvStkFiles(var AListeFichiers: TStringList; const ACurrentVersionStk, ACurrentVersionArt, ACurrentVersionLame: Int64; const bInitialisation: Boolean = False; const bDateFicInit: Boolean = False; const bDateFic: Boolean = False): Boolean;
// function de traitement des commandes
function DoGenCde: Boolean;

// function pour récupérer le Taux TVA des frais de port
function GetFPTauxTVA(CODE_SITE_WEB: Integer): Currency;
function CalculatePriceVATexc(ANetPriceVATinc, AVAT : Currency): Currency;
function GetAddressLigne(AAdresse : stUneAdresse): string;
function GetVilleID(ACLT_ID : integer): integer;

// Converti un fichier Xml en un tableau d'articles.
function XMLArticlesToRecord(const sFichierXML: String): TTabArticles;
// Converti un fichier Xml en une Structure commande
function DoXmlGenToRecord(sXmlfile: string): TCde;

// Fonction de convertion des données xml diverses
function XmlAdrToAdr(AFichier: string; ACde: TCde; XmlNode: IXmlNode; var
  bValid: boolean): stUneAdresse;
function XmlStrToFloat(Value: OleVariant; var bValid: boolean; const DefValue: Extended = 0.0): Extended;
function XmlStrToDate(Value: OleVariant; var bValid: boolean): TDateTime;
function XmlStrToInt(Value: OleVariant; const DefValue: integer = 0): Integer;
function XmlStrToStr(Value: OleVariant): string;

//emet un ou plusieur log d'erreur avec les paramètres
procedure DoErreurGeneric(AFichier: string; ANoeud: string; ACommNum: string;
  ACommId: integer; ANomCli: string; ATypeLigne: integer;
  ACodeArt: string; ALibProd: string; ALibErr: string;
  var bValid: boolean);
//emet un ou plusieur log d'erreur spécial balise
procedure DoErreurBalise(AFichier: string; ANoeud: string; ALibErr: string;
  var bValid: boolean);
//test si la balise existe dans le noeud spécifié
function IsBaliseExists(ANode:IXmlNode;AName:OleVariant):boolean;
//Contrôle la validité de la valeur
function CtrlValidStr(Value: string; bOblig: boolean; Longueur: integer):
  integer; //0 = ok ; 1 = vide ; 2 = Err. long.
//contrôle la validité d'un mail
function CtrlValidMail(Value: string): boolean;

// Création dans la base de données des articles qui n'existent pas.
function ArticlesToDB(TabArticles: TTabArticles): Boolean;
// Transforme la structure en commande dans la base de données
function DoGenCdeToDb(Cde: TCde): Boolean;

// permet de créer les fichiers csv depuis un dataset
function DoCsv(DataSet: TDataSet; sFileName: string; AFilter: String=''; AChampUnique: String = ''; AFichierDelta: Boolean = False): Boolean;  overload;
function DoCsv(DataSet: TDataSet; sFileName: string; AFilter: TStringList; AChampUnique: String = ''; AFichierDelta: Boolean = False): Boolean;  overload;

{$REGION 'Méthodes pour le FTP'}
function GenFTPConnection(FTPCfg: TFTPData): Boolean;
function GenFTPDownloadFile(FTPCfg: TFTPData): Boolean;
function GenFTPUploadFile(FTPCfg: TFTPData): Boolean;
procedure GenFTPClose;
{$ENDREGION 'Méthodes pour le FTP'}

{$REGION 'Méthodes pour le SFTP'}
function GenSFTPConnection(SFTPCfg: TFTPData): Boolean;
function GenSFTPDownloadFile(SFTPCfg: TFTPData): Boolean;
function GenSFTPUploadFile(SFTPCfg: TFTPData): Boolean;
procedure GenSFTPClose();
{$ENDREGION 'Méthodes pour le SFTP'}

function SearchClientID(Client: TClientCde): integer;
function GenCreateClient(var Client: TClientCde): Boolean;
function GenCreateLigneCompteClient(Cde: TCDE; AMAG_ID : integer): boolean;
function GenCreateEnteteBL(Cde: TCDE; AReglements: TReglementsCDE): Boolean;
function GenCreateLineBL(ID_COMMANDE: Integer; ArtInfos: stArticleInfos; LigneCDE: TLigneCDE; var ATkeId: Integer; ATransaction: TIB_Transaction): boolean;
function GenCreateReglements(AIdCommande: Integer; AReglements: TReglementsCDE; var ATkeId: Integer): Boolean;
function GenCreateEnteteFacture(var Cde: TCDE; AReglements: TReglementsCDE): Boolean;
function GenCreateLigneFacture(Cde : TCde; ANumLigne: Integer; ArtInfos: stArticleInfos; LigneCDE: TLigneCDE; APromo : boolean): boolean;
function GestionFidelite(Facture: TCde; Client: TClientCde): Boolean;
function IsExistFacture(ANumCde: string; aCdeId: Integer): boolean;
procedure GetInfoParamWeb(ACodeSite: integer; out AMAG_ID, AUSR_ID, AASS_ID, APORTWEB_ID : integer);
procedure GetInfoReglementWeb(ACodeSite: integer; AModeReglement : string; out AMRG_ID, ACPA_ID : integer);
function ReglementExiste(const sMode: String): Boolean;

//Identifie le magasin correspondant à la base de donnée sur laquel on est connecté
function IdentLocalMagid: Integer;

//Contrôle si on est bien connecté sur la base web
function CtrlIdentBaseWeb: Boolean;

// fonction qui met dans une liste les fichiers d'un répertoire
function GetFileListFromDir(lst : TStringList;sDir, sFileExt : String; bRecursive : Boolean = false) : Boolean;

// Mouvemente un K
procedure UpdateK(AKId: Integer; ASuppression: Integer = 0);

// Créé un nouveau K et renvoie l'id
function NewK(ATblName: string): Integer;

// Récupére l'ID le plus bas de la base
function IdBase(): Int64;

function DoublonADW:boolean;

implementation

uses
  uMonitoring, uLog, uTableNegColisUtils, UMain;

var
  HandleSFTP: TSBSftpFileHandle;

function GetFileListFromDir(lst : TStringList;sDir, sFileExt : String; bRecursive : Boolean) : Boolean;
var
  Search : TSearchRec;
  i : Integer;
begin
  Result := False;
  i := FindFirst(IncludeTrailingPathDelimiter(sDir) + sFileExt,faAnyFile,Search);
  Try
    while i = 0 do
    begin
      if (Search.Name <> '.') and (Search.Name <> '..') then
      begin
        if bRecursive and (faDirectory in [Search.Attr]) then
          GetFileListFromDir(lst,IncludeTrailingPathDelimiter(sDir) + Search.Name,sFileExt,bRecursive)
        else
        begin
          if lst.IndexOf(Search.Name) = -1 then
            lst.Add(Search.Name);
        end;
      end;
      i := FindNext(Search);
    end;
    Result := True;
  Finally
    SysUtils.FindClose(Search);
  End;
end;



//arrondi à 2 decimal après la virgule
//OBU 09/10/2018 : on remplace par la fonction RoundRv à cause d'un bug sur l'arrondi
//OBU 23/08/2019 : on restaure la version initiale car RoundRv est finalement plus boguée !
function ArrondiA2(v: Double): Double;
var
  TpV: Currency;
  v1: integer;
  s: STRING;
  Ecart: integer;
begin
  TpV := v;
  s := inttostr(Trunc(TpV * 1000));
  Ecart := 0;
  try
    v1 := StrToInt(s[Length(s)]);
    if v1 >= 5 then begin
      if v < 0 then
        Ecart := -1
      else
        Ecart := 1;
    end;
  EXCEPT
  end;
  Result := (Trunc(TpV * 100) + Ecart) / 100;
end;



function CtrlIdentBaseWeb: Boolean;
//Contrôle si on est bien connecté sur la base web
var
  iBaseWeb: Integer; //Id base web
  iBaseLocal: Integer; //Id base local
  QryTmp: TIBOQuery; //Query temporaire
begin
  //Recherche de la base web
  iBaseWeb := Dm_Common.GetParamInteger(203);

  //Recherche de la base local
  iBaseLocal := 0;
  QryTmp := TIBOQuery.Create(nil);
  try
    with QryTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select par_string from genparambase where par_nom = ''IDGENERATEUR''');
      Open;
      first;
      if not eof then
        iBaseLocal := FieldByName('PAR_STRING').AsInteger;
    end;
  finally
    QryTmp.Free;
  end;

  //Contrôle de discordance
  Result := (iBaseWeb = iBaseLocal);
end;

function IdentLocalMagid: Integer;
//Identifie le magasin correspondant à la base de donnée sur laquel on est connecté
var
  QryTmp: TIBOQuery; //Query temporaire
begin
  //Recherche du magasin correspond à la BdD
  Result := 0;
  QryTmp := TIBOQuery.Create(nil);
  try
    with QryTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select bas_magid ' +
        'from GENBASES ' +
        'join genparambase on (par_nom=''IDGENERATEUR'') and (par_string=bas_ident)';
      Open;
      First;
      if not Eof then
        Result := FieldByName('bas_magid').AsInteger;
      Close;
    end;
  finally
    QryTmp.Free;
  end;
end;

 function DoGenGet(dHeureDebut, dHeureFin: TTime): Boolean;
var
  dHTDebut, dHTFin, dNow: TDateTime;
begin
  Result := True;
  try
    Dm_Common.WebVenteIntFid.Enabled  := (Dm_Common.GetParamInteger(410) = 1);
    Dm_Common.WebVenteIntFid.Url      := Dm_Common.GetParamString(410);
    Dm_Common.WebVenteIntFid.Code     := Dm_Common.GetParamString(411);
    Dm_Common.WebVenteIntFid.Key      := Dm_Common.GetParamString(412);
    if Dm_Common.WebVenteIntFid.Enabled then
    begin
      Dm_Common.WebVenteFid             := TWebVenteFid.Create();
      Dm_Common.WebVenteFid.Url         := Dm_Common.WebVenteIntFid.Url;
      Dm_Common.WebVenteFid.Code        := Dm_Common.WebVenteIntFid.Code;
      Dm_Common.WebVenteFid.Key         := Dm_Common.WebVenteIntFid.Key;
      Dm_Common.WebVenteFid.Open();
    end;
    try
      dNow := Now;

      // Calcul pour la date de traitement
      dHTDebut := DateOf(dNow) + dHeureDebut;
      dHTFin := DateOf(dNow) + dHeureFin;
      // Si l'heure de debut est plus grande que l'heure de fin
      // c'est que l'heure de fin est le lendemain
      if CompareDateTime(dHTDebut, dHTFin) in [EqualsValue, GreaterThanValue] then
        dHTFin := dHTFin + 1;

      // Dans le cas de la commande
      if (dNow >= dHTDebut) and (dNow < dHTFin) and (CtrlIdentBaseWeb) then
      begin
        // Traitement des commandes
        Result := DoGenCde;
      end;
    except on E: Exception do
      begin
        raise Exception.Create('DoGenGet -> ' + E.Message);
      end;
    end;
  finally
    if Assigned(Dm_Common.WebVenteFid) then
      Dm_Common.WebVenteFid.Free();
  end;
end;

function DoGenSend(dHeureDebut, dHeureFin: TTime; bEnd: Boolean; bZipper: Boolean; dLastDateArt: TDateTime; dLastDateStk: TDateTime; bInitialisation, bInitStockUniquement, bDateFicInit, bDateFic: Boolean): Boolean;
var
  Mode: TMode;
  bDoArt, bDoStk: Boolean;
  FTPCsv, FTPCDE: TFTPData;
  lstFichiers: TStringList;
  iCurrentVersionArt: Int64;
  iCurrentVersionStk: Int64;
  iCurrentVersionLame: Int64;
  CodeAdherent: String;
  ZipName, Md5Name: TFileName;
  Fichier: TextFile;
  iLocalMagId: integer;
  vIniFile: TIniFile;
  dLastDateInit : TDateTime;
begin
  Result := False;
  lstFichiers := TStringList.Create();
  vIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    try

      // Vérification timer
      Mode := IsTimerDone(dHeureDebut, dHeureFin, bEnd, bInitialisation, bInitStockUniquement, dLastDateArt, dLastDateStk);

      // Récupération de la liste des fichiers à exporter
      if Dm_Common.Que_GetArtExportWeb.Active then
        Dm_Common.Que_GetArtExportWeb.Close();
      if Dm_Common.Que_GetArtExportWebLame.Active then
        Dm_Common.Que_GetArtExportWebLame.Close();

      lstFichiers.Clear();

      Dm_Common.Que_GetArtExportWeb.ParamByName('ASSID').AsInteger := Dm_Common.MySiteParams.iAssID;
      Dm_Common.Que_GetArtExportWebLame.ParamByName('ASSID').AsInteger := Dm_Common.MySiteParams.iAssID;
      // MD - 2015-10-22 - ajout param MAGID pour le multi-mag
      iLocalMagId := IdentLocalMagid;
      if iLocalMagId = 0 then
        iLocalMagId := Dm_Common.MySiteParams.iMagID;
      Dm_Common.Que_GetArtExportWeb.ParamByName('MAGID').AsInteger := iLocalMagId;
      Dm_Common.Que_GetArtExportWeb.Open();
      Dm_Common.Que_GetArtExportWeb.First();
      Dm_Common.Que_GetArtExportWebLame.Open();
      Dm_Common.Que_GetArtExportWebLame.First();
      while not(Dm_Common.Que_GetArtExportWeb.Eof) do
      begin
        lstFichiers.Values[Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_FICHIER').AsString] :=
          Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_ID').AsString;
        Dm_Common.Que_GetArtExportWeb.Next();
      end;

      // Récupère le CURRENT_VERSION article
      if Dm_Common.Gestion_K_VERSION = tKV64 then
      begin
        if Dm_Common.Que_VersionID.Active then
          Dm_Common.Que_VersionID.Close();
        Dm_Common.Que_VersionID.Open();

        iCurrentVersionArt := Dm_Common.Que_VersionID.FieldByName('CURRENT_VERSION').AsLargeInt;

        Dm_Common.Que_VersionID.Close();
      end
      else
      begin
        if Dm_Common.Que_GeneralId.Active then
          Dm_Common.Que_GeneralId.Close();
        Dm_Common.Que_GeneralId.Open();

        iCurrentVersionArt := Dm_Common.Que_GeneralId.FieldByName('CURRENT_VERSION').AsLargeInt;

        Dm_Common.Que_GeneralId.Close();
      end;


      if iCurrentVersionArt = 0 then
        // Récupère le CURRENT_VERSION le plus base de la plage si besoin
        iCurrentVersionArt := IdBase();

      // Récupère le CURRENT_VERSION Stock
      if Dm_Common.Que_NumVersion.Active then
        Dm_Common.Que_NumVersion.Close();
      Dm_Common.Que_NumVersion.Open();
      iCurrentVersionStk := Dm_Common.Que_NumVersion.FieldByName('CURRENT_VERSION').AsLargeInt;
      Dm_Common.Que_NumVersion.Close();

      // Récupère le CURRENT_VERSION de la Lame
      try
        if Dm_Common.Que_CurrentVersionPlage.Active then
          Dm_Common.Que_CurrentVersionPlage.Close();
        Dm_Common.Que_CurrentVersionPlage.ParamByName('DEBUT_PLAGE').AsLargeInt := Dm_Common.PlageLame.Debut;
        Dm_Common.Que_CurrentVersionPlage.ParamByName('FIN_PLAGE').AsLargeInt   := Dm_Common.PlageLame.Fin;
        Dm_Common.Que_CurrentVersionPlage.Open();
        iCurrentVersionLame := Dm_Common.Que_CurrentVersionPlage.FieldByName('CURRENT_VERSION').AsLargeInt;
      finally
        Dm_Common.Que_CurrentVersionPlage.Close();
      end;


      try
        // traitement des fichiers articles et stocks
        bDoArt := False;
        bDoStk := False;
        if (mdArticle in Mode) then
        begin
          LogAction('----- Extraction des fichiers ARTICLES -----', 3);
          bDoArt := GenerateCsvArtFiles(lstFichiers, iCurrentVersionArt, iCurrentVersionLame, (bInitialisation and (not bInitStockUniquement)), bDateFicInit, bDateFic);
        end;
        if (mdStock in Mode) then
        begin
          LogAction('----- Extraction des fichiers STOCK -----', 3);
          bDoStk := GenerateCsvStkFiles(lstFichiers, iCurrentVersionStk, iCurrentVersionArt, iCurrentVersionLame, bInitialisation, bDateFicInit, bDateFic);
        end;
        if bInitialisation then
        begin
          dLastDateInit := Now;
          vIniFile.WriteDateTime('GENERIQUE', 'DATETIMEINIT', dLastDateInit);
        end;
      finally
      end;

      // Envoi des fichiers CSV sur le FTP (Stocks et articles)
      if bDoArt or bDoStk then
      begin
        if not(bZipper) then
        begin
          // récupération des infos FTP
          with Dm_Common, FTPCsv do
          begin
            FTPCsv := MySiteParams.FTPGenCSV;
            FileFilter := '*.txt';
            SourcePath := GGENPATHCSV;
            SavePath := '';
            bDeleteFile := False;
            bArchiveFile := True;
          end;
          // envoi des données vers le FTP
          AddMonitoring('Début transfert fichier', logTrace, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
          try
            if not(FTPCsv.SFTP) then
            begin
              LogAction('----- Transfert des fichiers CSV vers le FTP -----', 3);
              if GenFTPConnection(FTPCsv) then
              try
                GenFTPUploadFile(FTPCsv);
              finally
                GenFTPClose;
              end;
            end
            else
            begin
              LogAction('----- Transfert des fichiers CSV vers le SFTP -----', 3);
              if GenSFTPConnection(FTPCsv) then
              try
                GenSFTPUploadFile(FTPCsv);
              finally
                GenSFTPClose();
              end;
            end;
            AddMonitoring('Fin transfert fichier', logInfo, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
          except
            on E: Exception do
              AddMonitoring(E.Message, logError, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
          end;
        end
        else
        begin
          // Récupération du code adherent
          if Dm_Common.Que_Tmp.Active then
            Dm_Common.Que_Tmp.Close();
          Dm_Common.Que_Tmp.SQL.Clear();
          Dm_Common.Que_Tmp.SQL.Add('SELECT MAG_CODEADH');
          Dm_Common.Que_Tmp.SQL.Add('FROM GENMAGASIN');
          Dm_Common.Que_Tmp.SQL.Add('WHERE MAG_ID = :MAGID;');
          Dm_Common.Que_Tmp.ParamByName('MAGID').AsInteger := Dm_Common.MySiteParams.iMagID;
          Dm_Common.Que_Tmp.Open();
          if Dm_Common.Que_Tmp.IsEmpty() or Dm_Common.Que_Tmp.FieldByName('MAG_CODEADH').IsNull then
            raise Exception.Create('Erreur lors de la récupération du code adhérent')
          else
            CodeAdherent := Dm_Common.Que_Tmp.FieldByName('MAG_CODEADH').AsString;
          Dm_Common.Que_Tmp.Close();

          // Compresse les fichiers en Zip
          // Nom des fichiers
          if not(bInitialisation) then
            ZipName := Format('%sdiff_%s_%s.zip', [GGENPATHCSV, CodeAdherent, FormatDateTime('yyyymmdd_hhnn', Now())])
          else
            ZipName := Format('%sfull_%s_%s.zip', [GGENPATHCSV, CodeAdherent, FormatDateTime('yyyymmdd_hhnn', Now())]);

          Md5Name := ChangeFileExt(ZipName, '.md5');

          // Compression des fichiers
          if not(ZipFolder(GGENPATHCSV, ZipName, '*.txt')) then
            raise Exception.Create('Erreur lors de la compression des fichiers');

          // Déplace les fichiers
          DeplaceFichier(GGENPATHCSV + '*.txt', GGENPATHCSV + 'Send\');

          // Vérification du MD5
          try
            AssignFile(Fichier, Md5Name);
            Rewrite(Fichier);
            Writeln(Fichier, MD5FromFile(ZipName));
          finally
            CloseFile(Fichier);
          end;

          // récupération des infos FTP
          with Dm_Common, FTPCsv do
          begin
            FTPCsv        := MySiteParams.FTPGenCSV;
            SourcePath    := GGENPATHCSV;
            SavePath      := '';
            bDeleteFile   := False;
            bArchiveFile  := True;
          end;

          // Envoi des données vers le FTP
          AddMonitoring('Début transfert fichier', logTrace, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
          try
            if not(FTPCsv.SFTP) then
            begin
              LogAction('----- Transfert des fichiers Zip et MD5 vers le FTP -----', 3);
              if GenFTPConnection(FTPCsv) then
              try
                FTPCsv.FileFilter := ExtractFileName(ZipName);
                GenFTPUploadFile(FTPCsv);
                FTPCsv.FileFilter := ExtractFileName(Md5Name);
                GenFTPUploadFile(FTPCsv);
              finally
                GenFTPClose;
              end;
            end
            else
            begin
              LogAction('----- Transfert des fichiers Zip et MD5 vers le SFTP -----', 3);
              if GenSFTPConnection(FTPCsv) then
              try
                FTPCsv.FileFilter := ExtractFileName(ZipName);
                GenSFTPUploadFile(FTPCsv);
                FTPCsv.FileFilter := ExtractFileName(Md5Name);
                GenSFTPUploadFile(FTPCsv);
              finally
                GenSFTPClose();
              end;
            end;
            AddMonitoring('Fin transfert fichier', logInfo, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
          except
            on E: Exception do
              AddMonitoring(E.Message, logError, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
          end;
        end;
      end; // if or

      if Dm_Common.MySiteParams.FTPGenFacture.Host <> '' then
      begin
        // Envoi des factures
        with Dm_Common, FTPCDE do
        begin
          FTPCDE := MySiteParams.FTPGenFacture;
          FileFilter := '*.' + MySiteParams.sFTPSendExtention;
          bDeleteFile := False;
          bArchiveFile := True;
          SourcePath := MySiteParams.sLocalFolderSend;
          // TODO: Quel est le chemin pour récupérer les factures ?
          SavePath := '';
        end;
        // Envoi des données vers le FTP
        AddMonitoring('Début transfert facture', logTrace, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
        try
          if not(FTPCDE.SFTP) then
          begin
            LogAction('----- Transfert des factures vers le FTP -----', 3);
            if GenFTPConnection(FTPCDE) then
            try
              GenFTPUploadFile(FTPCDE);
            finally
              GenFTPClose;
            end;
          end
          else
          begin
            LogAction('----- Transfert des factures vers le SFTP -----', 3);
            if GenSFTPConnection(FTPCDE) then
            try
              GenSFTPUploadFile(FTPCDE);
            finally
              GenSFTPClose();
            end;
          end;
          AddMonitoring('Fin transfert facture', logInfo, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
        except
          on E: Exception do
            AddMonitoring(E.Message, logError, mdltFTP, apptSyncWeb, dm_common.MySiteParams.iMagID);
        end;
      end;

      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.Create('DoGenSend -> ' + E.Message);
      end;
    end;
  finally
    Dm_Common.Que_GetArtExportWeb.Close();
    Dm_Common.Que_GetArtExportWebLame.Close();
    lstFichiers.Free();
    vIniFile.Free;
  end;
end;

function IsTimerDone(dHeureDebut, dHeureFin: TTime; bEnd, bInitialisation, bInitStockUniquement: Boolean; dLastDateArt: TDateTime; dLastDateStk: TDateTime): TMode;
type
  TPlageHoraire = record
    HPlgDebut, HPlgFin: TDateTime;
  end;

var
  TabArtPlage, TabStkPlage: Array of TPLageHoraire;
  i, iPlage{, iPlageLast}: Integer;
  bFound, bDoArt, bDoStk: Boolean;
  dHeureArticle, dHeureStock: TTime;
  fDelaiArticle, fDelaiStock: Double;
  iActifStock: Integer; //0: Inactif, 1: On envoie les fichiers stock
  iActifArt: Integer; //0: Inactif, 1: On envoie les fichiers articles
  dHTDebut, dHTFin, dNow: TDateTime;
begin
  Result := [];

  // On utilisera dNow pour garder tout au long du traitement la même date/heure
  dNow := Now;
  // Calcul pour la date de traitement
  dHTDebut := DateOf(dNow) + dHeureDebut;
  dHTFin := DateOf(dNow) + dHeureFin;
  // Si l'heure de debut est plus grande que l'heure de fin
  // c'est que l'heure de fin est le lendemain
  if CompareDateTime(dHTDebut, dHTFin) in [EqualsValue, GreaterThanValue] then
    dHTFin := dHTFin + 1;

  // Dans le cas de la commande
//  if (dNow >= dHTDebut) and (dNow < dHTFin) then
//    Result := Result + [mdCde];

  // Récupération des paramètres
  with Dm_Common do
  begin
    dHeureArticle := GetParamFloat(400);
    fDelaiArticle := GetParamFloat(401);
    dHeureStock := GetParamFloat(402);
    fDelaiStock := GetParamFloat(403);
    iActifArt := GetParamInteger(400);
    iActifStock := GetParamInteger(402);
  end;

  if(fDelaiArticle = 0) or (fDelaiStock = 0) then
    raise Exception.Create('Configuration manquante : Délai article ou stock non configuré');

  // Génération des plages horaires
  // calcul le nombre de plages horaires pour la période dhtdebut à dhtfin
  // Ex : DHTDebut = 10/10/2009 06:00 et DHTFin = 10/10/2009 22:00, FDelaiArticle = 2h
  //      (HoursBeetween / FDelaiArticle) + 1 = (16 / 2) + 1 = 9 plages horaires (6h-8h, 8h-10, ... 18h-20h, 20h-22h)
  // article
  if(iActifArt = 1) and (CtrlIdentBaseWeb) then
  begin
    i := Round(HoursBetween((DateOf(dHTDebut) + dHeureArticle), dHTFin) / fDelaiArticle) + 1; //SR : 27/03/2015 : remplacement de div par / et suppression du Round(fDelaiArticle)
    SetLength(TabArtPlage, i);
    for i := Low(TabArtPlage) to High(TabArtPlage) do
    begin
      TabArtPlage[i].HPlgDebut := IncMinute(DateOf(dHTDebut) + dHeureArticle, Round(fDelaiArticle * 60) * i);      //SR : 27/03/2015 : Passage en Minute * 60
      TabArtPlage[i].HPlgFin := IncMinute(DateOf(dHTDebut) + dHeureArticle, Round(fDelaiArticle * 60) * (i + 1));  //SR : 27/03/2015 : Passage en Minute * 60
    end;
  end;

  // stock
  if(iActifStock = 1) then
  begin
    i := Round(HoursBetween((DateOf(dHTDebut) + dHeureArticle), dHTFin) / fDelaiStock) + 1; //SR : 27/03/2015 : remplacement de div par / et suppression du Round(fDelaiStock)
    SetLength(TabStkPlage, i);
    for i := Low(TabStkPlage) to High(TabStkPlage) do
    begin
      TabStkPlage[i].HPlgDebut := IncMinute(DateOf(dHTDebut) + dHeureStock, Round(fDelaiStock * 60) * i);        //SR : 27/03/2015 : Passage en Minute * 60
      TabStkPlage[i].HPlgFin := IncMinute(DateOf(dHTDebut) + dHeureStock, Round(fDelaiStock * 60) * (i + 1));    //SR : 27/03/2015 : Passage en Minute * 60
    end;
  end;

  // Gestion des fichiers articles
  bDoArt := False;
  if (iActifArt = 1) and (CtrlIdentBaseWeb) then
  begin
    // dans quelle plage est-on pour l'article ?
    bFound := False;      iPlage := 0;
//    iPlageLast := -1;
    for i := low(TabArtPlage) to high(TabArtPlage) do
    begin
      if(dNow >= TabArtPlage[i].HPlgDebut) and (dNow < TabArtPlage[i].HPlgFin) then
      begin
        bFound := True;
        iPlage := i;
      end;

//      if(CompareValue(dLastDateArt, TabArtPlage[i].HPlgDebut) in [GreaterThanValue, EqualsValue]) and (CompareValue(dLastDateArt, TabArtPlage[i].HPlgFin) = LessThanValue) then
//        iPlageLast := i;
    end;

    if bFound then
    begin
      // Si l'heure du dernier traitement <= à la plage trouvée c'est qu'il est nécessaire de traiter l'article
      if CompareValue(dLastDateArt, TabArtPlage[iPlage].HPlgDebut) = LessThanValue then
      begin
        // On vérifie qu'on est pas Hors horaire de traitement
        if(dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle)) then
        begin
          bDoArt := True;
          // Ajout de 5mn car il arrive parfois que la conversion depuis le ini bug et enlève des secondes
          dLastDateArt := IncMinute(TabArtPlage[iPlage].HPlgDebut, 5);
        end;
      end;
    end
    else
    begin
      // Si on est la c'est qu'on est Hors plage donc qu'on a un traitement à faire
      // alors on va vérifier si on a pas dépassé aussi l'heure de fin de traitement
      // Si on est en initialisation (et pas en mode stock uniquement): on exporte tout le temps.
      if((dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle))) or (bInitialisation and (not bInitStockUniquement)) then
      begin
        bDoArt := True;
        dLastDateArt := TabArtPlage[High(TabArtPlage)].HPlgFin;
      end;
    end;
  end;

  // Gestion des fichiers stock
  bDoStk := False;
  if (iActifStock = 1) then
  begin
    // dans quelle plage est-on pour le stock ?
//    iPlageLast := -1;
    bFound := False;      iPlage := 0;
    for i := low(TabStkPlage) to high(TabStkPlage) do
    begin
      if(dNow >= TabStkPlage[i].HPlgDebut) and (dNow < TabStkPlage[i].HPlgFin) then
      begin
        bFound := True;
        iPlage := i;
      end;

//      if(CompareValue(dLastDateStk, TabStkPlage[i].HPlgDebut) in [GreaterThanValue, EqualsValue]) and (CompareValue(dLastDateStk, TabStkPlage[i].HPlgFin) = LessThanValue) then
//        iPlageLast := i;
    end;

    if bFound then
    begin
      // Si l'heure du dernier traitement <= à la plage trouvée c'est qu'il est nécessaire de traiter l'article
      if CompareValue(dLastDateStk, TabStkPlage[iPlage].HPlgDebut) = LessThanValue then
      begin
        // On vérifie qu'on est pas Hors horaire de traitement et qu'on est vien supérieur à l'heure de début de traitement
        if(dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle)) then
        begin
          bDoStk := True;
          // Ajout de 5mn car il arrive parfois que la conversion depuis le ini bug et enlève des secondes
          dLastDateStk := IncMinute(TabStkPlage[iPlage].HPlgDebut, 5);
        end;
      end;
    end
    else
    begin
      // Si on est la c'est qu'on est Hors plage donc qu'on a un traitement à faire
      // alors on va vérifier si on a pas dépassé aussi l'heure de fin de traitement
      // Si on est en initialisation : on exporte tout le temps
      if((dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureStock))) or (bInitialisation) then
      begin
        bDoStk := True;
        dLastDateStk := TabStkPlage[High(TabStkPlage)].HPlgFin;
      end;
    end;
  end;

  if bDoArt or bDoStk then
  begin
    with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do
    try
      // sauvegarde des horaires
      if bDoArt then
      begin
        if bEnd then
          WriteDateTime('GENERIQUE', 'DATETIMEART', dLastDateArt);
        Result := Result + [mdArticle];
      end;

      if bDoStk then
      begin
        if bEnd then
          WriteDateTime('GENERIQUE', 'DATETIMESTK', dLastDateStk);
        Result := Result + [mdStock];
      end;
    finally
      free;
    end; // with try
  end; // if
end;

//MD - 23/06/2015
//procédure pour MAJ des dates dans la base après l'enregistrement du fichier
procedure MajDate(const ANomFichier: string; const ACurrentVersion: Int64);
begin
  if Dm_Common.Que_GetArtExportWeb.Locate('AWE_FICHIER', ANomFichier, [loCaseInsensitive]) then
  begin
    Dm_Common.Que_GetArtExportWeb.Edit();
    Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_DATEEXPORT').AsDateTime  := Now();
    Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt  := ACurrentVersion;
    Dm_Common.Que_GetArtExportWeb.Post();
    UpdateK(Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_ID').AsInteger);
  end;
end;

procedure MajDate(const ACurrentVersion, ACurrentVersionLame: Int64;
  const ANomFichier: string);
var
  iAweId: Integer;
begin
  with Dm_Common do
  begin
    MajDate(ANomFichier,ACurrentVersion);

    // Met à jour le CurrentVersion pour la Lame
    if Que_GetArtExportWebLame.Locate('AWE_FICHIER', ANomFichier, [loCaseInsensitive]) then
    begin
      Que_GetArtExportWebLame.Edit();
      Que_GetArtExportWebLame.FieldByName('AWE_DATEEXPORT').AsDateTime  := Now();
      Que_GetArtExportWebLame.FieldByName('AWE_LASTVERSION').AsLargeInt  := ACurrentVersionLame;
      Que_GetArtExportWebLame.Post();
      UpdateK(Que_GetArtExportWebLame.FieldByName('AWE_ID').AsInteger);
    end
    else
    begin
      iAweId := NewK('ARTEXPORTWEB');
      Que_GetArtExportWebLame.Insert();
      Que_GetArtExportWebLame.FieldByName('AWE_ID').AsInteger           := iAweId;
      Que_GetArtExportWebLame.FieldByName('AWE_ASSID').AsInteger        := MySiteParams.iAssID;
      Que_GetArtExportWebLame.FieldByName('AWE_FICHIER').AsString       := ANomFichier;
      Que_GetArtExportWebLame.FieldByName('AWE_ACTIF').AsInteger        := 1;
      Que_GetArtExportWebLame.FieldByName('AWE_DATEEXPORT').AsDateTime  := Now();
      Que_GetArtExportWebLame.FieldByName('AWE_LASTVERSION').AsLargeInt  := ACurrentVersionLame;
      Que_GetArtExportWebLame.FieldByName('AWE_MAGID').AsInteger        := 0;
      Que_GetArtExportWebLame.Post();
    end;
  end;
end;

procedure MajDate(const ACurrentVersion, ACurrentVersionLame, ACurrentVersionStock: Int64;
  const ANomFichier: string; AMagId: integer);
var
  iAweId: Integer;
begin
  with Dm_Common do
  begin
    MajDate(ACurrentVersion,ACurrentVersionLame, ANomFichier);

    // Met à jour le CurrentVersion pour le stock
    if Que_GetArtExportWeb.Locate('AWE_FICHIER', ANomFichier + '-GENSTOCK', [loCaseInsensitive]) then
    begin
      Que_GetArtExportWeb.Edit();
      Que_GetArtExportWeb.FieldByName('AWE_DATEEXPORT').AsDateTime  := Now();
      Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt  := ACurrentVersionStock;
      Que_GetArtExportWeb.Post();
      UpdateK(Que_GetArtExportWeb.FieldByName('AWE_ID').AsInteger);
    end
    else
    begin
      iAweId := NewK('ARTEXPORTWEB');
      Que_GetArtExportWeb.Insert();
      Que_GetArtExportWeb.FieldByName('AWE_ID').AsInteger           := iAweId;
      Que_GetArtExportWeb.FieldByName('AWE_ASSID').AsInteger        := MySiteParams.iAssID;
      Que_GetArtExportWeb.FieldByName('AWE_FICHIER').AsString       := ANomFichier+'-GENSTOCK';
      Que_GetArtExportWeb.FieldByName('AWE_ACTIF').AsInteger        := 1;
      Que_GetArtExportWeb.FieldByName('AWE_DATEEXPORT').AsDateTime  := Now();
      Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt  := ACurrentVersionStock;
      Que_GetArtExportWeb.FieldByName('AWE_MAGID').AsInteger        := AMagId;
      Que_GetArtExportWeb.Post();
    end;
  end;
end;

procedure GetLastVersions(var AListeNom: TStringList; AListeIndex: Array of Integer; var ALastVersion: Int64; var ALastVersionLame: Int64);
var
  LastDateExport: TDateTime;
begin
  GetLastVersions(AListeNom, AListeIndex, ALastVersion, ALastVersionLame, LastDateExport);
end;

procedure GetLastVersions(var AListeNom: TStringList; AListeIndex: Array of Integer; var ALastVersion: Int64; var ALastVersionLame: Int64; var LastDateExport: TDateTime);
var
  i: Integer;
begin
  ALastVersion := -1;
  ALastVersionLame := -1;
  LastDateExport := 0;
  for i := Low(AListeIndex) to High(AListeIndex) do
  begin
    if(AListeIndex[i] < 0) or (AListeIndex[i] > (AListeNom.Count -1)) then
      Continue;

    if Dm_Common.Que_GetArtExportWeb.Locate('AWE_ID', AListeNom.ValueFromIndex[AListeIndex[i]], [loCaseInsensitive]) then
    begin
      if(Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt < ALastVersion) or (ALastVersion = -1) then
        ALastVersion := Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt;
      LastDateExport := Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_DATEEXPORT').AsDateTime;
    end;
    if Dm_Common.Que_GetArtExportWebLame.Locate('AWE_FICHIER', AListeNom.Names[AListeIndex[i]], [loCaseInsensitive]) then
    begin
      if(Dm_Common.Que_GetArtExportWebLame.FieldByName('AWE_LASTVERSION').AsLargeInt < ALastVersionLame) or (ALastVersionLame = -1) then
        ALastVersionLame := Dm_Common.Que_GetArtExportWebLame.FieldByName('AWE_LASTVERSION').AsLargeInt;
      if LastDateExport = 0 then
        LastDateExport := Dm_Common.Que_GetArtExportWeb.FieldByName('AWE_DATEEXPORT').AsDateTime;
    end
    else if(Dm_Common.PlageLame.Debut < ALastVersionLame) or (ALastVersionLame = -1) then
      ALastVersionLame := Dm_Common.PlageLame.Debut;
  end;
end;

function GenerateCsvArtFiles(var AListeFichiers: TStringList; const ACurrentVersion, ACurrentVersionLame: Int64; const bInitialisation, bDateFicInit, bDateFic: Boolean): Boolean;
var
  iFichier, iFichier2, iNbIds: Integer;
  IdsActif: array of Integer;
  sCheminCsv: String;
  bActive: Boolean;
  i: Integer;
  iLastVersion: Int64;
  iLastVersionFile: Int64;
  iLastVersionLame: Int64;
  sDatePourFic: string;     //Chaine avec la date si on l'ajoute au nom du fichier
begin
  Result := False;
  iLastVersion := 0;
  with Dm_Common do
  try
    // Récupère le LAST_VERSION le plus base de la plage si besoin
    if not(bInitialisation) then
    begin
      iLastVersion    := IdBase();
      sCheminCsv      := GGENPATHCSV;
      if bDateFic then
        sDatePourFic  := '-' + FormatDateTime('yyyymmddhhnnss', Now)
      else
        sDatePourFic  := '';
    end
    else
    begin
      sCheminCsv      := GGENPATHCSV + 'INIT_';
      if bDateFicInit then
        sDatePourFic  := '-' + FormatDateTime('yyyymmddhhnnss', Now)
      else
        sDatePourFic  := '';
    end;
  
    {$REGION 'Génération du fichier GENRE'}
    iFichier  := AListeFichiers.IndexOfName('GENRE.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['GENRE']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from TF_WEBG_EXPGENRE');
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'GENRE.TXT', '', 'GRE_ID');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('GENRE.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier GENRE'}

    {$REGION 'Génération du fichier MAGASIN'}
    iFichier  := AListeFichiers.IndexOfName('MAGASIN.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['MAGASIN']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select MAG_ID,MAG_ENSEIGNE,VIL_NOM,SOC_NOM from GENMAGASIN');
          SQL.Add('join k on k_id=mag_id and k_enabled=1');
          SQL.Add('join genadresse on adr_id=mag_adrid');
          SQL.Add('join genville on vil_id=adr_vilid');
          SQL.Add('join gensociete on soc_id=mag_socid');
          SQL.Add('where mag_id<>0');
          SQL.Add('order by mag_id');
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'MAGASIN.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('MAGASIN.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier MAGASIN'}

    {$REGION 'Génération du fichier NOMENCLATURE'}
    iFichier  := AListeFichiers.IndexOfName('NOMENCLATURE.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['NOMENCLATURE']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from TF_WEBG_EXPNOMENCLATURE(:PSEC_TYPE)');
          ParamCheck := True;
          ParamByName('PSEC_TYPE').AsInteger := 2;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'NOMENCLATURE.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('TF_WEBG_EXPNOMENCLATURE: NOMENCLATURE.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier NOMENCLATURE'}

    {$REGION 'Génération des fichiers ARTWEB / ARTWEB_2'}
    iFichier  := AListeFichiers.IndexOfName('ARTWEB.TXT');
    iFichier2 := AListeFichiers.IndexOfName('ARTWEB_2.TXT');
    if (iFichier > -1) or (iFichier2 > -1) then
    begin
      LogAction(Format(MessDebutRequete, ['ARTWEB / ARTWEB_2']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select TF_WEBG_EXPARTWEB.*, ART_NOM NOM From TF_WEBG_EXPARTWEB(:ASSID,:MAGID)');
          SQL.Add('JOIN ARTARTICLE ON CODE_MODEL = ART_ID');
          ParamCheck := True;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          ParamByName('MAGID').AsInteger := MySiteParams.iMagID;
          Open;
        end;
        //ARTWEB.TXT -> sans les ID vers tailles.txt et couleur_stat.txt
        if iFichier > -1 then
        begin
          Try
            LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
            Application.ProcessMessages();
            DoCsv(Que_Tmp, GGENPATHCSV + 'ARTWEB.TXT','GCS_ID, TGF_ID, CODE_CHRONO, NOM', 'CODE_ARTICLE');
            Application.ProcessMessages();
            MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
          except on E: Exception do
              raise Exception.Create('TF_WEBG_EXPARTWEB: ARTWEB.TXT -> ' + E.Message);
          end;
        end;
        //ARTWEB_2.TXT -> avec les ID vers tailles.txt et couleur_stat.txt
        if iFichier2 > -1 then
        begin
          try
            LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier2]]), 3);
            Application.ProcessMessages();
            DoCsv(Que_Tmp, GGENPATHCSV + 'ARTWEB_2.TXT','NOM');
            Application.ProcessMessages();
            MajDate(AListeFichiers.Names[iFichier2],ACurrentVersion);
          except on E: Exception do
              raise Exception.Create('TF_WEBG_EXPARTWEB: ARTWEB_2.TXT -> ' + E.Message);
          end;
        end;
      except
        on E: Exception do
        begin
          raise Exception.Create('Requete TF_WEBG_EXPARTWEB -> ' + E.Message);
        end
      end;
    end;
    {$ENDREGION 'Génération des fichiers ARTWEB / ARTWEB_2'}

    {$REGION 'Génération du fichier MARQUE'}
    iFichier  := AListeFichiers.IndexOfName('MARQUE.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['MARQUE']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select distinct IDMARQUE, MARQUE From TF_WEBG_EXPARTWEB(:ASSID,:MAGID) order by MARQUE');
          ParamCheck := True;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          ParamByName('MAGID').AsInteger := MySiteParams.iMagID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'MARQUE.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('TF_WEBG_EXPARTWEB: MARQUE.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier MARQUE'}

    {$REGION 'Génération du fichier ARTNOMENK'}
    iFichier  := AListeFichiers.IndexOfName('ARTNOMENK.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['ARTNOMENK']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from TF_WEBG_EXPARTNOMENK');
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'ARTNOMENK.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except
        on E: Exception do
        begin
          raise Exception.Create('TF_WEBG_EXPARTNOMENK: ARTNOMENK.TXT -> ' + E.Message);
        end;
      end;
    end;
    {$ENDREGION 'Génération du fichier ARTNOMENK'}

    {$REGION 'Génération du fichier LOTWEB'}
    iFichier  := AListeFichiers.IndexOfName('LOTWEB.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['LOTWEB']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from TF_WEBG_EXPLOTWEB(:PASSID)');
          ParamCheck := True;
          ParamByName('PASSID').AsInteger := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'LOTWEB.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except
        on E: Exception do
        begin
          raise Exception.Create('TF_WEBG_EXPLOTWEB: LOTWEB.TXT -> ' + E.Message);
        end;
      end;
    end;
    {$ENDREGION 'Génération du fichier LOTWEB'}

    {$REGION 'Génération du fichier LOTNOMENK'}
    iFichier  := AListeFichiers.IndexOfName('LOTNOMENK.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['LOTNOMENK']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from TF_WEBG_EXPLOTNOMENK');
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'LOTNOMENK.TXT', '', 'CODE_LOT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('TF_WEBG_EXPLOTNOMENK: LOTNOMENK.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier LOTNOMENK'}

    {$REGION 'Génération du fichier CODEPROMO'}
    iFichier  := AListeFichiers.IndexOfName('CODEPROMO.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['CODEPROMO']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from TF_WEBG_EXPCODEPROMO');
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_tmp, GGENPATHCSV + 'CODEPROMO.TXT', '', 'CODE_PROMO');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('TF_WEBG_EXPCODEPROMO: CODEPROMO.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier CODEPROMO'}

    {$REGION 'Génération du fichier TAILLES'}
    iFichier  := AListeFichiers.IndexOfName('TAILLES.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['TAILLES']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from WEBG_EXPTAILLES(:ASSID)');
          ParamByName('ASSID').asInteger  := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'TAILLES.TXT', '', 'TGF_ID');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('WEBG_EXPTAILLES: TAILLES.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier TAILLES'}

    {$REGION 'Génération du fichier COULEUR_STAT'}
    iFichier  := AListeFichiers.IndexOfName('COULEUR_STAT.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['COULEUR_STAT']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from WEBG_EXPCOULEURSTAT(:ASSID)');
          ParamByName('ASSID').asInteger  := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'COULEUR_STAT.TXT', '', 'GCS_ID');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('WEBG_EXPCOULEURSTAT: COULEUR_STAT.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier COULEUR_STAT'}

    {$REGION 'Génération du fichier CB_FOURN'}
    iFichier  := AListeFichiers.IndexOfName('CB_FOURN.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['CB_FOURN']), 3);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT CODE_ARTICLE, CB_FOURN FROM CH_WEBG_EXPARTARTFOURN');
          Open;
        end;

        {$REGION 'Vérifie que les codes-barres fournisseurs sont corrects'}
        if MemD_Export.Active then
          MemD_Export.Close();
        MemD_Export.FieldDefs.Clear();
        MemD_Export.FieldDefs.Add('CODE_ARTICLE', ftString, 64);
        MemD_Export.FieldDefs.Add('CB_FOURN', ftString, 64);
        MemD_Export.CreateDataSet();

        Que_Tmp.First();
        while not(Que_Tmp.Eof) do
        begin
          MemD_Export.Append();
          MemD_Export.FieldByName('CODE_ARTICLE').AsString  := Que_Tmp.FieldByName('CODE_ARTICLE').AsString;

          if (Length(Que_Tmp.FieldByName('CB_FOURN').AsString) = 12)
            and VerifEAN13('0' + Que_Tmp.FieldByName('CB_FOURN').AsString) then
          begin
            MemD_Export.FieldByName('CB_FOURN').AsString := '0' + Que_Tmp.FieldByName('CB_FOURN').AsString;
          end
          else begin
            MemD_Export.FieldByName('CB_FOURN').AsString := Que_Tmp.FieldByName('CB_FOURN').AsString;
          end;

          MemD_Export.Post();
          Que_Tmp.Next();
        end;

        {$ENDREGION 'Vérifie que les codes-barres fournisseurs sont corrects'}
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(MemD_Export, GGENPATHCSV + 'CB_FOURN.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except on E: Exception do
          raise Exception.Create('CH_WEBG_EXPARTARTFOURN: CB_FOURN.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier CB_FOURN'}

    {$REGION 'Génération du fichier MAGASIN_2'}
    iFichier  := AListeFichiers.IndexOfName('MAGASIN_2.TXT');
    if iFichier > -1 then
    begin
      GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
      try
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT MAG_ID,');
            SQL.Add('       MAG_ENSEIGNE,');
            SQL.Add('       VIL_NOM,');
            SQL.Add('       SOC_NOM,');
            SQL.Add('       MAG_SIRET SIRET,');
            SQL.Add('       ADR_LIGNE ADRESSE,');
            SQL.Add('       ADR_TEL TELEPHONE,');
            SQL.Add('       ADR_FAX FAX,');
            SQL.Add('       ADR_GSM PORTABLE,');
            SQL.Add('       ADR_EMAIL EMAIL,');
            SQL.Add('       VIL_CP CODE_POSTAL,');
            SQL.Add('       PAY_NOM PAYS,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM GENMAGASIN');
            SQL.Add('  JOIN K KMAG     ON (KMAG.K_ID = MAG_ID AND KMAG.K_ID != 0)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = MAG_ADRID)');
            SQL.Add('  JOIN GENVILLE   ON (VIL_ID = ADR_VILID)');
            SQL.Add('  JOIN GENPAYS    ON (PAY_ID = VIL_PAYID)');
            SQL.Add('  JOIN GENSOCIETE ON (SOC_ID = MAG_SOCID)');
            SQL.Add('WHERE (KMAG.KRH_ID > :LAST_VERSION AND KMAG.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KMAG.K_VERSION > :LAST_VERSION_LAME AND KMAG.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KMAG.KRH_ID > :DEBUT_PLAGE_BASE AND KMAG.KRH_ID <= :FIN_PLAGE_BASE))');
            SQL.Add('UNION');
            SQL.Add('SELECT MAG_ID,');
            SQL.Add('       MAG_ENSEIGNE,');
            SQL.Add('       VIL_NOM,');
            SQL.Add('       SOC_NOM,');
            SQL.Add('       MAG_SIRET SIRET,');
            SQL.Add('       ADR_LIGNE ADRESSE,');
            SQL.Add('       ADR_TEL TELEPHONE,');
            SQL.Add('       ADR_FAX FAX,');
            SQL.Add('       ADR_GSM PORTABLE,');
            SQL.Add('       ADR_EMAIL EMAIL,');
            SQL.Add('       VIL_CP CODE_POSTAL,');
            SQL.Add('       PAY_NOM PAYS,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM GENMAGASIN');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = MAG_ADRID)');
            SQL.Add('  JOIN K KADR     ON (KADR.K_ID = ADR_ID AND KADR.K_ID != 0)');
            SQL.Add('  JOIN GENVILLE   ON (VIL_ID = ADR_VILID)');
            SQL.Add('  JOIN GENPAYS    ON (PAY_ID = VIL_PAYID)');
            SQL.Add('  JOIN GENSOCIETE ON (SOC_ID = MAG_SOCID)');
            SQL.Add('WHERE (KADR.KRH_ID > :LAST_VERSION AND KADR.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KADR.K_VERSION > :LAST_VERSION_LAME AND KADR.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KADR.KRH_ID > :DEBUT_PLAGE_BASE AND KADR.KRH_ID <= :FIN_PLAGE_BASE))');
            SQL.Add('ORDER BY 1;');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT MAG_ID, MAG_ENSEIGNE, VIL_NOM, SOC_NOM, MAG_SIRET SIRET,');
            SQL.Add('       ADR_LIGNE ADRESSE, ADR_TEL TELEPHONE, ADR_FAX FAX, ADR_GSM PORTABLE,');
            SQL.Add('       ADR_EMAIL EMAIL, VIL_CP CODE_POSTAL, PAY_NOM PAYS, K_ENABLED ETAT_DATA');
            SQL.Add('FROM GENMAGASIN');
            SQL.Add('  JOIN K ON (K_ID = MAG_ID AND K_ID != 0 AND KTB_ID = -11111344)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = MAG_ADRID)');
            SQL.Add('  JOIN GENVILLE ON (VIL_ID = ADR_VILID)');
            SQL.Add('  JOIN GENPAYS ON (PAY_ID = VIL_PAYID)');
            SQL.Add('  JOIN GENSOCIETE ON (SOC_ID = MAG_SOCID)');
            SQL.Add('where K_ENABLED = 1');
            SQL.Add('ORDER BY MAG_ID');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sMAGASIN_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'MAGASIN_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('MAGASIN_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier MAGASIN_2'}

    {$REGION 'Génération du fichier GENRE_2'}
    iFichier  := AListeFichiers.IndexOfName('GENRE_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['GENRE_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT GRE_ID,');
            SQL.Add('       GRE_NOM,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTGENRE');
            SQL.Add('  JOIN K ON (K_ID = GRE_ID AND K_ID != 0)');
            SQL.Add('WHERE (KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT GRE_ID, GRE_NOM, K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTGENRE');
            SQL.Add('  JOIN K ON (K_ID = GRE_ID AND K_ID != 0 AND KTB_ID = -11111388)');
            SQL.Add('where K_ENABLED = 1');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sGENRE_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'GENRE_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('GENRE_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier GENRE_2'}

    {$REGION 'Génération du fichier MARQUE_2'}
    iFichier  := AListeFichiers.IndexOfName('MARQUE_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['MARQUE_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT MRK_ID IDMARQUE,');
            SQL.Add('       MRK_NOM MARQUE,');
            SQL.Add('       MRK_CODE CODE_MARQUE,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTMARQUE');
            SQL.Add('  JOIN K ON (K_ID = MRK_ID AND K_ID != 0)');
            SQL.Add('WHERE (KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE));');

            // Si on est sur une base de données où le plan ne fonctionne pas : on l'enlève
            // Tant pis, bug InterBase : ça mettera plus longtemps !
            try
              Prepare();
            except
              on E: EIBO_ISCError do
              begin
                SQL.Delete(11);
                SQL.Delete(10);
                SQL.Delete(9);
                Prepare();
              end;
            end;

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT MRK_ID IDMARQUE, MRK_NOM MARQUE, MRK_CODE CODE_MARQUE,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTMARQUE');
            SQL.Add('  JOIN K ON (K_ID = MRK_ID AND K_ID != 0 AND KTB_ID = -11111392)');
            SQL.Add('where K_ENABLED = 1');
          end;

          Open();
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sMARQUE_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'MARQUE_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('MARQUE_2.TXT -> ' + E.ClassName + #160': ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier MARQUE_2'}

    {$REGION 'Génération du fichier NOMENCLATURE_2'}
    iFichier  := AListeFichiers.IndexOfName('NOMENCLATURE_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['NOMENCLATURE_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT DISTINCT 1 AS ID_INTERNE,');
            SQL.Add('                RAY_ID ID_GINKO,');
            SQL.Add('                RAY_NOM LIB,');
            SQL.Add('                0 ID_PARENT,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM NKLRAYON');
            SQL.Add('  JOIN K          ON (K_ID = RAY_ID AND K_ID != 0)');
            SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID AND SEC_TYPE = :SEC_TYPE)');
            SQL.Add('WHERE (KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE))');
            SQL.Add('UNION');
            SQL.Add('SELECT DISTINCT 2 AS ID_INTERNE,');
            SQL.Add('                FAM_ID ID_GINKO,');
            SQL.Add('                FAM_NOM LIB,');
            SQL.Add('                FAM_RAYID ID_PARENT,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM NKLFAMILLE');
            SQL.Add('  JOIN K          ON (K_ID = FAM_ID AND K_ID != 0)');
            SQL.Add('  JOIN NKLRAYON   ON (RAY_ID = FAM_RAYID)');
            SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID AND SEC_TYPE = :SEC_TYPE)');
            SQL.Add('WHERE (KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE))');
            SQL.Add('UNION');
            SQL.Add('SELECT DISTINCT 3 AS ID_INTERNE,');
            SQL.Add('                SSF_ID ID_GINKO,');
            SQL.Add('                SSF_NOM LIB,');
            SQL.Add('                SSF_FAMID ID_PARENT,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM NKLSSFAMILLE');
            SQL.Add('  JOIN K          ON (K_ID = SSF_ID AND K_ID != 0)');
            SQL.Add('  JOIN NKLFAMILLE ON (FAM_ID = SSF_FAMID)');
            SQL.Add('  JOIN NKLRAYON   ON (RAY_ID = FAM_RAYID)');
            SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID AND SEC_TYPE = :SEC_TYPE)');
            SQL.Add('WHERE (KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE))');
            SQL.Add('and SSF_VISIBLE = 1');
            SQL.Add('ORDER BY 1;');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT DISTINCT 1 AS ID_INTERNE, RAY_ID ID_GINKO, RAY_NOM LIB, 0 ID_PARENT,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM NKLRAYON');
            SQL.Add('  JOIN K ON (K_ID = RAY_ID AND K_ID != 0 AND KTB_ID = -11111356)');
            SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID AND SEC_TYPE = :SEC_TYPE)');
            SQL.Add('where K_ENABLED = 1');
            SQL.Add('UNION');
            SQL.Add('SELECT DISTINCT 2 AS ID_INTERNE, FAM_ID ID_GINKO, FAM_NOM LIB, FAM_RAYID ID_PARENT,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM NKLFAMILLE');
            SQL.Add('  JOIN K ON (K_ID = FAM_ID AND K_ID != 0 AND KTB_ID = -11111355)');
            SQL.Add('  JOIN NKLRAYON ON (RAY_ID = FAM_RAYID)');
            SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID AND SEC_TYPE = :SEC_TYPE)');
            SQL.Add('where K_ENABLED = 1');
            SQL.Add('UNION');
            SQL.Add('SELECT DISTINCT 3 AS ID_INTERNE, SSF_ID ID_GINKO, SSF_NOM LIB, SSF_FAMID ID_PARENT,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM NKLSSFAMILLE');
            SQL.Add('  JOIN K ON (K_ID = SSF_ID AND K_ID != 0 AND KTB_ID = -11111359)');
            SQL.Add('  JOIN NKLFAMILLE ON (FAM_ID = SSF_FAMID)');
            SQL.Add('  JOIN NKLRAYON ON (RAY_ID = FAM_RAYID)');
            SQL.Add('  JOIN NKLSECTEUR ON (SEC_ID = RAY_SECID AND SEC_TYPE = :SEC_TYPE)');
            SQL.Add('where K_ENABLED = 1');
            SQL.Add('and SSF_VISIBLE = 1');
            SQL.Add('ORDER BY 1');
          end;

          ParamByName('SEC_TYPE').AsInteger := 2;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sNOMENCLATURE_2%s.TXT', [sCheminCsv, sDatePourFic]), 'ID_INTERNE', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'NOMENCLATURE_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('NOMENCLATURE_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier NOMENCLATURE_2'}

    {$REGION 'Génération du fichier ARTDELAISWEB'}
    iFichier  := AListeFichiers.IndexOfName('ARTDELAISWEB.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['ARTDELAISWEB']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT DLW_ID ID_DELAIS,');
            SQL.Add('       DLW_LIBELLE LIBELLE,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTDELAISWEB');
            SQL.Add('  JOIN K ON (K_ID = DLW_ID AND K_ID != 0)');
            SQL.Add('WHERE ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersion<> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT DLW_ID ID_DELAIS, DLW_LIBELLE LIBELLE, K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTDELAISWEB');
            SQL.Add('  JOIN K ON (K_ID = DLW_ID AND K_ID != 0 AND KTB_ID = -11111538)');
            SQL.Add('where K_ENABLED = 1');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sARTDELAISWEB%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTDELAISWEB.TXT');
      except
        on E: Exception do
          raise Exception.Create('ARTDELAISWEB.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier ARTDELAISWEB'}

    {$REGION 'Génération du fichier TAILLES_2'}
    iFichier  := AListeFichiers.IndexOfName('TAILLES_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['TAILLES_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT TGF_ID,');
            SQL.Add('       TGT_NOM TYPE_NOM,');
            SQL.Add('       GTF_NOM GRILLE_NOM,');
            SQL.Add('       TGF_NOM,');
            SQL.Add('       TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES,');
            SQL.Add('       TGF_CODE CODE_TAILLE,');
            SQL.Add('       GTF_ID ID_GRILLE,');
            SQL.Add('       GTF_CODE CODE_GRILLE,');
            SQL.Add('       KTGF.K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTWEB           ON (ARW_ID = AQS_ARWID AND AQS_ARWID<>0)');
            SQL.Add('  JOIN ARTDISPOWEB      ON (ADW_ARTID = ARW_ARTID AND ADW_DISPO = 1)');
            SQL.Add('  JOIN K KARW           ON (KARW.K_ID = ARW_ID AND KARW.K_ENABLED = 1)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = ADW_TGFID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = TGF_GTFID)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add(' AND ((KTGF.KRH_ID > :LAST_VERSION AND KTGF.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KTGF.K_VERSION > :LAST_VERSION_LAME AND KTGF.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KTGF.KRH_ID > :DEBUT_PLAGE_BASE AND KTGF.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID,');
            SQL.Add('       TGT_NOM TYPE_NOM,');
            SQL.Add('       GTF_NOM GRILLE_NOM,');
            SQL.Add('       TGF_NOM,');
            SQL.Add('       TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES,');
            SQL.Add('       TGF_CODE CODE_TAILLE,');
            SQL.Add('       GTF_ID ID_GRILLE,');
            SQL.Add('       GTF_CODE CODE_GRILLE,');
            SQL.Add('       KGTF.K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTWEB           ON (ARW_ID = AQS_ARWID AND AQS_ARWID<>0)');
            SQL.Add('  JOIN ARTDISPOWEB      ON (ADW_ARTID = ARW_ARTID AND ADW_DISPO = 1)');
            SQL.Add('  JOIN K KARW           ON (KARW.K_ID = ARW_ID AND KARW.K_ENABLED = 1)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = ADW_TGFID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = TGF_GTFID)');
            SQL.Add('  JOIN K KGTF           ON (KGTF.K_ID = GTF_ID)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add(' AND ((KGTF.KRH_ID > :LAST_VERSION AND KGTF.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KGTF.K_VERSION > :LAST_VERSION_LAME AND KGTF.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KGTF.KRH_ID > :DEBUT_PLAGE_BASE AND KGTF.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID,');
            SQL.Add('       TGT_NOM TYPE_NOM,');
            SQL.Add('       GTF_NOM GRILLE_NOM,');
            SQL.Add('       TGF_NOM,');
            SQL.Add('       TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES,');
            SQL.Add('       TGF_CODE CODE_TAILLE,');
            SQL.Add('       GTF_ID ID_GRILLE,');
            SQL.Add('       GTF_CODE CODE_GRILLE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((ADW_DISPO = 1)');
            SQL.Add('           AND (KARW.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTWEB           ON (ARW_ID = AQS_ARWID AND AQS_ARWID<>0)');
            SQL.Add('  JOIN ARTDISPOWEB      ON (ADW_ARTID = ARW_ARTID)');
            SQL.Add('  JOIN K KARW           ON (KARW.K_ID = ARW_ID AND KARW.K_ID != 0)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = ADW_TGFID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1 AND KTGF.K_ID != 0)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = TGF_GTFID)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add(' AND ((KARW.KRH_ID > :LAST_VERSION AND KARW.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KARW.K_VERSION > :LAST_VERSION_LAME AND KARW.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KARW.KRH_ID > :DEBUT_PLAGE_BASE AND KARW.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID,');
            SQL.Add('       TGT_NOM TYPE_NOM,');
            SQL.Add('       GTF_NOM GRILLE_NOM,');
            SQL.Add('       TGF_NOM,');
            SQL.Add('       TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES,');
            SQL.Add('       TGF_CODE CODE_TAILLE,');
            SQL.Add('       GTF_ID ID_GRILLE,');
            SQL.Add('       GTF_CODE CODE_GRILLE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((ADW_DISPO = 1)');
            SQL.Add('           AND (KARW.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTWEB           ON (ARW_ID = AQS_ARWID AND AQS_ARWID<>0)');
            SQL.Add('  JOIN ARTDISPOWEB      ON (ADW_ARTID = ARW_ARTID)');
            SQL.Add('  JOIN K KADW           ON (KADW.K_ID = ADW_ID AND KADW.K_ID != 0)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = ADW_TGFID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1 AND KTGF.K_ID != 0)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = TGF_GTFID)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add(' AND ((KADW.KRH_ID > :LAST_VERSION AND KADW.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KADW.K_VERSION > :LAST_VERSION_LAME AND KADW.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KADW.KRH_ID > :DEBUT_PLAGE_BASE AND KADW.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID,');
            SQL.Add('       TGT_NOM TYPE_NOM,');
            SQL.Add('       GTF_NOM GRILLE_NOM,');
            SQL.Add('       TGF_NOM,');
            SQL.Add('       TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES,');
            SQL.Add('       TGF_CODE CODE_TAILLE,');
            SQL.Add('       GTF_ID ID_GRILLE,');
            SQL.Add('       GTF_CODE CODE_GRILLE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((KLOL.K_ENABLED = 1)');
            SQL.Add('           AND (KTGF.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTLOT           ON (LOT_ID = AQS_LOTID AND AQS_LOTID<>0)');
            SQL.Add('  JOIN ARTLOTLIGNE      ON (LOL_LOTID = LOT_ID)');
            SQL.Add('  JOIN K KLOL           ON (KLOL.K_ID = LOL_ID)');
            SQL.Add('  JOIN ARTARTICLE       ON (ART_ID = LOL_ARTID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = ART_GTFID)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_GTFID = GTF_ID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ID != 0)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add(' AND ((KTGF.KRH_ID > :LAST_VERSION AND KTGF.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KTGF.K_VERSION > :LAST_VERSION_LAME AND KTGF.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KTGF.KRH_ID > :DEBUT_PLAGE_BASE AND KTGF.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID,');
            SQL.Add('       TGT_NOM TYPE_NOM,');
            SQL.Add('       GTF_NOM GRILLE_NOM,');
            SQL.Add('       TGF_NOM,');
            SQL.Add('       TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES,');
            SQL.Add('       TGF_CODE CODE_TAILLE,');
            SQL.Add('       GTF_ID ID_GRILLE,');
            SQL.Add('       GTF_CODE CODE_GRILLE,');
            SQL.Add('       KLOL.K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTLOT           ON (LOT_ID = AQS_LOTID AND AQS_LOTID<>0)');
            SQL.Add('  JOIN ARTLOTLIGNE      ON (LOL_LOTID = LOT_ID)');
            SQL.Add('  JOIN K KLOL           ON (KLOL.K_ID = LOL_ID AND KLOL.K_ID != 0)');
            SQL.Add('  JOIN ARTARTICLE       ON (ART_ID = LOL_ARTID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = ART_GTFID)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_GTFID = GTF_ID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1 AND KTGF.K_ID != 0)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add(' AND ((KLOL.KRH_ID > :LAST_VERSION AND KLOL.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KLOL.K_VERSION > :LAST_VERSION_LAME AND KLOL.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KLOL.KRH_ID > :DEBUT_PLAGE_BASE AND KLOL.KRH_ID <= :FIN_PLAGE_BASE)));') ;

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT TGF_ID, TGT_NOM TYPE_NOM, GTF_NOM GRILLE_NOM, TGF_NOM, TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES, TGF_CODE CODE_TAILLE, GTF_ID ID_GRILLE, GTF_CODE CODE_GRILLE,');
            SQL.Add('       KTGF.K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTWEB           ON (ARW_ID = AQS_ARWID AND AQS_ARWID<>0)');
            SQL.Add('  JOIN ARTDISPOWEB      ON (ADW_ARTID = ARW_ARTID AND ADW_DISPO = 1)');
            SQL.Add('  JOIN K KARW           ON (KARW.K_ID = ARW_ID AND KARW.K_ENABLED = 1)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = ADW_TGFID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = TGF_GTFID)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID, TGT_NOM TYPE_NOM, GTF_NOM GRILLE_NOM, TGF_NOM, TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES, TGF_CODE CODE_TAILLE, GTF_ID ID_GRILLE, GTF_CODE CODE_GRILLE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (ADW_DISPO = 1) AND (KARW.K_ENABLED = 1) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTWEB           ON (ARW_ID = AQS_ARWID AND AQS_ARWID<>0)');
            SQL.Add('  JOIN ARTDISPOWEB      ON (ADW_ARTID = ARW_ARTID)');
            SQL.Add('  JOIN K KARW           ON (KARW.K_ID = ARW_ID AND KARW.K_ID != 0)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = ADW_TGFID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1 AND KTGF.K_ID != 0)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = TGF_GTFID)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID, TGT_NOM TYPE_NOM, GTF_NOM GRILLE_NOM, TGF_NOM, TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES, TGF_CODE CODE_TAILLE, GTF_ID ID_GRILLE, GTF_CODE CODE_GRILLE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (KLOL.K_ENABLED = 1) AND (KTGF.K_ENABLED = 1) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTLOT           ON (LOT_ID = AQS_LOTID AND AQS_LOTID<>0)');
            SQL.Add('  JOIN ARTLOTLIGNE      ON (LOL_LOTID = LOT_ID)');
            SQL.Add('  JOIN K KLOL           ON (KLOL.K_ID = LOL_ID)');
            SQL.Add('  JOIN ARTARTICLE       ON (ART_ID = LOL_ARTID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = ART_GTFID)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_GTFID = GTF_ID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.KTB_ID = -11111372)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID');
            SQL.Add('UNION');
            SQL.Add('SELECT TGF_ID, TGT_NOM TYPE_NOM, GTF_NOM GRILLE_NOM, TGF_NOM, TGF_ORDREAFF,');
            SQL.Add('       TGF_CORRES, TGF_CODE CODE_TAILLE, GTF_ID ID_GRILLE, GTF_CODE CODE_GRILLE,');
            SQL.Add('       KLOL.K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN ARTLOT           ON (LOT_ID = AQS_LOTID AND AQS_LOTID<>0)');
            SQL.Add('  JOIN ARTLOTLIGNE      ON (LOL_LOTID = LOT_ID)');
            SQL.Add('  JOIN K KLOL           ON (KLOL.K_ID = LOL_ID AND KLOL.K_ID != 0 AND KLOL.KTB_ID = -11111569)');
            SQL.Add('  JOIN ARTARTICLE       ON (ART_ID = LOL_ARTID)');
            SQL.Add('  JOIN PLXGTF           ON (GTF_ID = ART_GTFID)');
            SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_GTFID = GTF_ID)');
            SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1 AND KTGF.K_ID != 0)');
            SQL.Add('  JOIN PLXTYPEGT        ON (TGT_ID = GTF_TGTID)');
            SQL.Add('WHERE AQS_ASSID = :ASSID;');
          end;

          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;

          Application.ProcessMessages();
        end;

        {$REGION 'Vérifie à ne pas mettre des tailles en inactives si elle sont actives'}
        IdsActif := nil;
        SetLength(IdsActif, Que_Tmp.RecordCountAll());
        iNbIds    := 0;

        if MemD_Export.Active then
          MemD_Export.Close();
        MemD_Export.FieldDefs.Clear();
        MemD_Export.FieldDefs.Add('TGF_ID', ftInteger);
        MemD_Export.FieldDefs.Add('TYPE_NOM', ftString, 64);
        MemD_Export.FieldDefs.Add('GRILLE_NOM', ftString, 64);
        MemD_Export.FieldDefs.Add('TGF_NOM', ftString, 64);
        MemD_Export.FieldDefs.Add('TGF_ORDREAFF', ftFloat);
        MemD_Export.FieldDefs.Add('TGF_CORRES', ftString, 64);
        MemD_Export.FieldDefs.Add('CODE_TAILLE', ftString, 32);
        MemD_Export.FieldDefs.Add('ID_GRILLE', ftInteger);
        MemD_Export.FieldDefs.Add('CODE_GRILLE', ftString, 32);
        MemD_Export.FieldDefs.Add('ETAT_DATA', ftInteger);
        MemD_Export.CreateDataSet();

        while not(Que_Tmp.Eof) do
        begin
          if Que_Tmp.FieldByName('ETAT_DATA').AsInteger = 1 then
          begin
            // Ajoute la taille à la liste des tailles actives
            IdsActif[iNbIds] := Que_Tmp.FieldByName('TGF_ID').AsInteger;
            Inc(iNbIds);
          end;

          Application.ProcessMessages();
          Que_Tmp.Next();
        end;

        Que_Tmp.First();

        while not(Que_Tmp.Eof) do
        begin
          if Que_Tmp.FieldByName('ETAT_DATA').AsInteger = 1 then
          begin
            MemD_Export.Append();

            for i := 0 to MemD_Export.FieldCount - 1 do
            begin
              case MemD_Export.Fields[i].DataType of
                ftInteger:
                  MemD_Export.Fields[i].AsInteger := Que_Tmp.Fields[i].AsInteger;
                ftString:
                  MemD_Export.Fields[i].AsString  := Que_Tmp.Fields[i].AsString;
                ftFloat:
                  MemD_Export.Fields[i].AsFloat   := Que_Tmp.Fields[i].AsFloat;
              end;
            end;

            MemD_Export.Post();
          end
          else begin
            // Si la taille n'est pas active : vérifie si elle n'est pas sensée l'être
            bActive := False;

            for i := 0 to iNbIds do
            begin
              if IdsActif[i] = Que_Tmp.FieldByName('TGF_ID').AsInteger then
              begin
                bActive := True;
                Break;
              end;
            end;

            if not(bActive) then
            begin
              MemD_Export.Append();

              for i := 0 to MemD_Export.FieldCount - 1 do
              begin
                case MemD_Export.Fields[i].DataType of
                  ftInteger:
                    MemD_Export.Fields[i].AsInteger := Que_Tmp.Fields[i].AsInteger;
                  ftString:
                    MemD_Export.Fields[i].AsString  := Que_Tmp.Fields[i].AsString;
                  ftFloat:
                    MemD_Export.Fields[i].AsFloat   := Que_Tmp.Fields[i].AsFloat;
                end;
              end;

              MemD_Export.Post();
            end;
          end;

          Application.ProcessMessages();
          Que_Tmp.Next();
        end;
        {$ENDREGION 'Vérifie à ne pas mettre des tailles en inactives si elle sont actives'}

        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(MemD_Export, Format('%sTAILLES_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'TAILLES_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('TAILLES_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier TAILLES_2'}

    {$REGION 'Génération du fichier COULEUR_STAT_2'}
    iFichier  := AListeFichiers.IndexOfName('COULEUR_STAT_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['COULEUR_STAT_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT DISTINCT GCS_ID,');
            SQL.Add('                GCS_NOM,');
            SQL.Add('                K_ENABLED ETAT_DATA');
            SQL.Add('FROM PLXGCS');
            SQL.Add('JOIN K ON (K_ID = GCS_ID AND K_ID != 0)');
            SQL.Add('WHERE ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('select distinct GCS_ID, GCS_NOM, K_ENABLED ETAT_DATA');
            SQL.Add('from PLXGCS');
            SQL.Add('join K on K_ID = GCS_ID and K_ENABLED = 1');
            SQL.Add('where GCS_ID <> 0');
          end;

          //ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;
          Application.ProcessMessages();
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sCOULEUR_STAT_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'COULEUR_STAT_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('COULEUR_STAT_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier COULEUR_STAT_2'}

    // Autres fichiers (procédure trop longue).
    GenerateCsvArtFiles_2(AListeFichiers, bInitialisation, ACurrentVersion, ACurrentVersionLame, iLastVersion, sCheminCsv, sDatePourFic);

    Result := True;
  except
    on E: Exception do
    begin
      LogAction('Erreur lors de la génération des csv :  ' + E.Message, 1);
      AddMonitoring('Erreur export : ' + E.Message, logError, mdltExport,
        apptSyncWeb, MySiteParams.iMagID);
    end;
  end;
end;

procedure GenerateCsvArtFiles_2(var AListeFichiers: TStringList; const bInitialisation: Boolean; const ACurrentVersion, ACurrentVersionLame, iLastVersion: Int64; const sCheminCsv, sDatePourFic: String);
var
  vFilter: TStringList;
  iFichier, iFichier2, iFichier3, i: Integer;
  iLastVersionFile, iLastVersionLame: Int64;
  LastDateExport: TDateTime;
begin
  with Dm_Common do
  begin
    {$REGION 'Génération des fichiers ARTWEB_3 / ARTWEB_4'}
    iFichier  := AListeFichiers.IndexOfName('ARTWEB_3.TXT');
    iFichier2 := AListeFichiers.IndexOfName('ARTWEB_4.TXT');
    if(iFichier > -1) or (iFichier2 > -1) then
    begin
      LogAction(Format(MessDebutRequete, ['ARTWEB_3 / ARTWEB_4']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier, iFichier2],iLastVersionFile, iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT DISTINCT CODE_ARTICLE, CODE_MODELE, CODE_NK, IDMARQUE, MARQUE, CODE_FOURN, PRODUIT, ');
          SQL.Add('    COULEUR, GCS_ID, TAILLE, TGF_ID, TVA, GENRE, CLASSEMENT1, CLASSEMENT2, CLASSEMENT3, CLASSEMENT4, ');
          SQL.Add('    CLASSEMENT5, COLLECTION, WEB_DETAIL, WEB_COMPOSITION, POIDS, POIDSL, CODE_CHRONO, ARCHIVER, ');
          SQL.Add('    CODE_COULEUR, WEB, PREVENTE, QTE_PREVENTE, DELAIS_PREVENTE, ETAT_DATA, CODE_EAN ');
          SQL.Add('  FROM SYNCWEB_ARTWEB(:ASSID, :LAST_VERSION, :CURRENT_VERSION, ');
          SQL.Add('    :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE)');

          if not(bInitialisation) then
          begin
            if(iLastVersionFile <> 0) then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
          end
          else
          begin
            SQL.Add(' WHERE ETAT_DATA = 1');
            ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageBase.Debut;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := Dm_Common.PlageLame.Debut;
          end;
          ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
          ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
          ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
          ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;
        end;

        if iFichier > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
          begin
            try
              LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
              Application.ProcessMessages();
              DoCsv(Que_Tmp, Format('%sARTWEB_3%s.TXT', [sCheminCsv, sDatePourFic]), 'CODE_EAN', '', True);
              Application.ProcessMessages();
              MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTWEB_3.TXT');
            except
              on E: Exception do
                raise Exception.Create('ARTWEB_3.TXT -> ' + E.Message);
            end;
          end;
        end;
        if iFichier2 > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
          begin
            try
              LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier2]]), 3);
              Application.ProcessMessages();
              DoCsv(Que_Tmp, Format('%sARTWEB_4%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
              Application.ProcessMessages();
              MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTWEB_4.TXT');
            except
              on E: Exception do
                raise Exception.Create('ARTWEB_4.TXT -> ' + E.Message);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          raise Exception.Create('Requete ARTWEB_3/ARTWEB_4 -> ' + E.Message);
        end;
      end;
    end;
    
    {$ENDREGION 'Génération du fichier ARTWEB_3 / ARTWEB_4'}

    {$REGION 'Génération du fichier ARTNOMENK_2'}
    iFichier  := AListeFichiers.IndexOfName('ARTNOMENK_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['ARTNOMENK_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile, iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          SQL.Add('SELECT DISTINCT CODE_MODEL, CODE_NK, ETAT_DATA ');
          SQL.Add('  FROM SYNCWEB_ARTNOMENK(:ASSID, :LAST_VERSION, :CURRENT_VERSION, ');
          SQL.Add('  :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE)');

          if not(bInitialisation) then
          begin
            if(iLastVersionFile <> 0) then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
          end
          else
          begin
            SQL.Add(' WHERE ETAT_DATA = 1');
            ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageBase.Debut;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := Dm_Common.PlageLame.Debut;
          end;
          ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
          ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
          ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
          ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sARTNOMENK_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTNOMENK_2.TXT');

      except
        on E: Exception do
          raise Exception.Create('ARTNOMENK_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier ARTNOMENK_2'}

    {$REGION 'Génération du fichier CB_FOURN_2 / CB_FOURN_3'}
    iFichier  := AListeFichiers.IndexOfName('CB_FOURN_2.TXT');
    iFichier2  := AListeFichiers.IndexOfName('CB_FOURN_3.TXT');

    if (iFichier > -1) or (iFichier2 > -1) then
    begin
      LogAction(Format(MessDebutRequete, ['CB_FOURN_2 / CB_FOURN_3']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier,iFichier2],iLastVersionFile, iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          SQL.Add('SELECT DISTINCT CODE_ARTICLE, CB_FOURN, ETAT_DATA, CB_PRINCIPAL ');
          SQL.Add('  FROM SYNCWEB_CB_FOURN(:ASSID, :LAST_VERSION, :CURRENT_VERSION, ');
          SQL.Add('  :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE)');

          if not(bInitialisation) then
          begin
            if(iLastVersionFile <> 0) then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
          end
          else
          begin
            SQL.Add(' WHERE ETAT_DATA = 1');
            ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageBase.Debut;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := Dm_Common.PlageLame.Debut;
          end;
          ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
          ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
          ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
          ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;

          if iFichier > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sCB_FOURN_2%s.TXT', [sCheminCsv, sDatePourFic]), 'CB_PRINCIPAL', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersion, ACurrentVersionLame, 'CB_FOURN_2.TXT');
              except
                on E: Exception do
                  raise Exception.Create('CB_FOURN_2.TXT -> ' + E.Message);
              end;
            end;
          end;
          if iFichier2 > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier2]]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sCB_FOURN_3%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersion, ACurrentVersionLame, 'CB_FOURN_3.TXT');
              except
                on E: Exception do
                  raise Exception.Create('CB_FOURN_3.TXT -> ' + E.Message);
              end;
            end;
          end;
        end;
      except
        on E: Exception do
            raise Exception.Create('CB_FOURN_2.TXT / CB_FOURN_3.TXT -> ' + E.Message);
      end;
    end;

    {$ENDREGION 'Génération du fichier CB_FOURN_2 / CB_FOURN_3'}

    {$REGION 'Génération des fichiers PRIX / PRIX_2 / PRIX_3'}
    iFichier  := AListeFichiers.IndexOfName('PRIX.TXT');
    iFichier2  := AListeFichiers.IndexOfName('PRIX_2.TXT');
    iFichier3  := AListeFichiers.IndexOfName('PRIX_3.TXT');

    if (iFichier > -1) or (iFichier2 > -1) or (iFichier3 > -1) then
    begin
      LogAction(Format(MessDebutRequete, ['PRIX / PRIX_2 / PRIX_3']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier, iFichier2, iFichier3], iLastVersionFile, iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
//          AutoFetchAll := True;
          SQL.Clear;
          SQL.Add('SELECT DISTINCT CODE_ARTICLE,');
          SQL.Add('       PXVTE,');
          SQL.Add('       PXVTE_N,');
          SQL.Add('       PXDESTOCK,');
          SQL.Add('       PUMP,');
          SQL.Add('       ETAT_DATA,');
          SQL.Add('       CODE_EAN,');
          SQL.Add('       TVA');
          //SQL.Add('       (PXVTE / (1 + (TVA / 100))) AS PXVTEHT,');
          //SQL.Add('       (PXVTE_N / (1 + (TVA / 100))) AS PXVTE_NHT,');
          //SQL.Add('       (PXDESTOCK / (1 + (TVA / 100))) AS PXDESTOCKHT');
          SQL.Add('FROM SYNCWEB_PRIX(:ASSID, :LAST_VERSION, :CURRENT_VERSION,');
          SQL.Add('                       :LAST_VERSION_LAME, :CURRENT_VERSION_LAME,');
          SQL.Add('                       :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE, :INIT)');

          if not(bInitialisation) then
          begin
            ParamByName('INIT').AsInteger := 0;
            if(iLastVersionFile <> 0) then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
          end
          else
          begin
            SQL.Add(' WHERE ETAT_DATA = 1');
            ParamByName('INIT').AsInteger := 1;
            ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageBase.Debut;
            ParamByName('LAST_VERSION_LAME').AsLargeInt  := Dm_Common.PlageLame.Debut;
          end;
          ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
          ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
          ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
          ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;

          Open;
          Application.ProcessMessages();
        end;

        {$REGION 'Vérifie à ne pas mettre des tarifs en inactifs si ils sont actifs'}
          if MemD_Export.Active then
            MemD_Export.Close();
          MemD_Export.FieldDefs.Clear();
          MemD_Export.FieldDefs.Add('CODE_ARTICLE', ftString, 64);
          MemD_Export.FieldDefs.Add('PXVTE', ftFloat);
          MemD_Export.FieldDefs.Add('PXVTE_N', ftFloat);
          MemD_Export.FieldDefs.Add('PXDESTOCK', ftFloat);
          MemD_Export.FieldDefs.Add('PUMP', ftFloat);
          MemD_Export.FieldDefs.Add('ETAT_DATA', ftInteger);
          MemD_Export.FieldDefs.Add('CODE_EAN', ftString, 64);
          MemD_Export.FieldDefs.Add('TVA', ftFloat);
          MemD_Export.FieldDefs.Add('PXVTEHT', ftFloat);
          MemD_Export.FieldDefs.Add('PXVTE_NHT', ftFloat);
          MemD_Export.FieldDefs.Add('PXDESTOCKHT', ftFloat);
          MemD_Export.CreateDataSet();

          Que_Tmp.First();
          while not(Que_Tmp.Eof) do
          begin
            if not(bInitialisation) then
            begin
              if not MemD_Export.Locate('CODE_ARTICLE',Que_Tmp.FieldByName('CODE_ARTICLE').AsString,[]) then
              begin
                MemD_Export.Append;
              end
              else if MemD_Export.Locate('CODE_ARTICLE',Que_Tmp.FieldByName('CODE_ARTICLE').AsString,[])
                  and (Que_Tmp.FieldByName('ETAT_DATA').AsInteger = 1) then
              begin
                MemD_Export.Edit;
              end
              else
              begin
                Que_Tmp.Next;
                Continue;
              end;
            end
            else
            begin
              MemD_Export.Append;
            end;
            MemD_Export.FieldByName('CODE_ARTICLE').AsString := Que_Tmp.FieldByName('CODE_ARTICLE').AsString;
            MemD_Export.FieldByName('PXVTE').AsFloat         := Que_Tmp.FieldByName('PXVTE').AsFloat;
            MemD_Export.FieldByName('PXVTE_N').AsFloat       := Que_Tmp.FieldByName('PXVTE_N').AsFloat;
            MemD_Export.FieldByName('PXDESTOCK').AsFloat     := Que_Tmp.FieldByName('PXDESTOCK').AsFloat;
            MemD_Export.FieldByName('PUMP').AsFloat          := Que_Tmp.FieldByName('PUMP').AsFloat;
            MemD_Export.FieldByName('ETAT_DATA').AsInteger   := Que_Tmp.FieldByName('ETAT_DATA').AsInteger;
            MemD_Export.FieldByName('CODE_EAN').AsString     := Que_Tmp.FieldByName('CODE_EAN').AsString;
            MemD_Export.FieldByName('TVA').AsFloat           := Que_Tmp.FieldByName('TVA').AsFloat;
            // Calculs des prix HT à partir du NET + TVA sans passer par le moteur de BD pour le laisser souffler
            MemD_Export.FieldByName('PXVTEHT').AsFloat     := CalculatePriceVATexc(Que_Tmp.FieldByName('PXVTE').AsFloat, Que_Tmp.FieldByName('TVA').AsFloat);
            MemD_Export.FieldByName('PXVTE_NHT').AsFloat   := CalculatePriceVATexc(Que_Tmp.FieldByName('PXVTE_N').AsFloat, Que_Tmp.FieldByName('TVA').AsFloat);
            MemD_Export.FieldByName('PXDESTOCKHT').AsFloat := CalculatePriceVATexc(Que_Tmp.FieldByName('PXDESTOCK').AsFloat, Que_Tmp.FieldByName('TVA').AsFloat);
            MemD_Export.Post();
            Application.ProcessMessages();
            Que_Tmp.Next();
          end;
          {$ENDREGION 'Vérifie à ne pas mettre des tarifs en inactifs si ils sont actifs'}

        vFilter := TStringList.Create();
        try
          if (iFichier > -1) and Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
          begin
            try
              Application.ProcessMessages();
              vFilter.Clear();
              vFilter.Add('CODE_EAN');
              vFilter.Add('TVA');
              vFilter.Add('PXVTEHT');
              vFilter.Add('PXVTE_NHT');
              vFilter.Add('PXDESTOCKHT');
              DoCsv(MemD_Export, Format('%sPRIX%s.TXT', [sCheminCsv, sDatePourFic]), vFilter, '', True);
              Application.ProcessMessages();
              MajDate(ACurrentVersion, ACurrentVersionLame, 'PRIX.TXT');
            except
              on E: Exception do
                raise Exception.Create('PRIX.TXT -> ' + E.Message);
            end;
          end;

          if (iFichier2 > -1) and Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
          begin
            try
              Application.ProcessMessages();
              vFilter.Clear();
              vFilter.Add('TVA');
              vFilter.Add('PXVTEHT');
              vFilter.Add('PXVTE_NHT');
              vFilter.Add('PXDESTOCKHT');
              DoCsv(MemD_Export, Format('%sPRIX_2%s.TXT', [sCheminCsv, sDatePourFic]), vFilter, '', True);
              Application.ProcessMessages();
              MajDate(ACurrentVersion, ACurrentVersionLame, 'PRIX_2.TXT');
            except
              on E: Exception do
                raise Exception.Create('PRIX_2.TXT -> ' + E.Message);
            end;
          end;

          if (iFichier3 > -1) and Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier3], []) then
          begin
            try
              Application.ProcessMessages();
              vFilter.Clear();
              DoCsv(MemD_Export, Format('%sPRIX_3%s.TXT', [sCheminCsv, sDatePourFic]), vFilter, '', True);
              Application.ProcessMessages();
              MajDate(ACurrentVersion, ACurrentVersionLame, 'PRIX_3.TXT');
            except
              on E: Exception do
                raise Exception.Create('PRIX_3.TXT -> ' + E.Message);
            end;
          end;
        finally
          FreeAndNil(vFilter);
        end;
      except
        on E: Exception do
          raise Exception.Create('PRIX.TXT / PRIX_2.TXT / PRIX_3.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération des fichiers PRIX / PRIX_2 / PRIX_3'}

    {$REGION 'Génération des fichiers OC / OC_2'}
    iFichier := AListeFichiers.IndexOfName('OC.TXT');
    iFichier2 := AListeFichiers.IndexOfName('OC_2.TXT');

    if(iFichier > -1) or (iFichier2 > -1) then
    begin
      LogAction(Format(MessDebutRequete, ['OC / OC_2']), 3);
      try
        GetLastVersions(AListeFichiers, [iFichier, iFichier2], iLastVersionFile, iLastVersionLame);

        Que_Tmp.Close;
        Que_Tmp.SQL.Clear;
        Que_Tmp.SQL.Add('select distinct ID_OC, NOM_OC, TYPE_OC, DATE_DEBUT, DATE_FIN, CODE_ARTICLE,');
        Que_Tmp.SQL.Add('PRIX_ARTICLE, ETAT_DATA, CODE_EAN');
        Que_Tmp.SQL.Add('from SYNCWEB_OC(:ASSID, :LAST_VERSION, :CURRENT_VERSION,');
        Que_Tmp.SQL.Add(':LAST_VERSION_LAME, :CURRENT_VERSION_LAME,');
        Que_Tmp.SQL.Add(':DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE)');

        if not bInitialisation then
        begin
          if(iLastVersionFile <> 0) then
            Que_Tmp.ParamByName('LAST_VERSION').AsLargeInt := iLastVersionFile
          else
            Que_Tmp.ParamByName('LAST_VERSION').AsLargeInt := iLastVersion;
          Que_Tmp.ParamByName('LAST_VERSION_LAME').AsLargeInt := iLastVersionLame;
        end
        else
        begin
          Que_Tmp.SQL.Add('where ETAT_DATA = 1');
          Que_Tmp.ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageBase.Debut;
          Que_Tmp.ParamByName('LAST_VERSION_LAME').AsLargeInt := Dm_Common.PlageLame.Debut;
        end;
        Que_Tmp.ParamByName('CURRENT_VERSION').AsLargeInt := ACurrentVersion;
        Que_Tmp.ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
        Que_Tmp.ParamByName('DEBUT_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Debut;
        Que_Tmp.ParamByName('FIN_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Fin;
        Que_Tmp.ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
        Que_Tmp.Open;

        if iFichier > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
          begin
            try
              LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
              Application.ProcessMessages;
              DoCsv(Que_Tmp, Format('%sOC%s.TXT', [sCheminCsv, sDatePourFic]), 'CODE_EAN', '', True);
              Application.ProcessMessages;
              MajDate(ACurrentVersion, ACurrentVersionLame, 'OC.TXT');
            except
              on E: Exception do
                raise Exception.Create('OC.TXT -> ' + E.Message);
            end;
          end;
        end;

        if iFichier2 > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
          begin
            try
              LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier2]]), 3);
              Application.ProcessMessages;
              DoCsv(Que_Tmp, Format('%sOC_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
              Application.ProcessMessages;
              MajDate(ACurrentVersion, ACurrentVersionLame, 'OC_2.TXT');
            except
              on E: Exception do
                raise Exception.Create('OC_2.TXT -> ' + E.Message);
            end;
          end;
        end;
      except
        on E: Exception do
          raise Exception.Create('OC.TXT / OC_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération des fichiers OC / OC_2'}

    {$REGION 'Génération du fichier OC_3'}
    iFichier3 := AListeFichiers.IndexOfName('OC_3.TXT');
    if iFichier3 > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['OC_3']), 3);
      try
        GetLastVersions(AListeFichiers, [iFichier3], iLastVersionFile, iLastVersionLame, LastDateExport);

        Dm_Common.Que_Tmp.Close;
        Dm_Common.Que_Tmp.SQL.Clear;
        Dm_Common.Que_Tmp.SQL.Add('select distinct ID_OC, NOM_OC, TYPE_OC, DATE_DEBUT, DATE_FIN, CODE_ARTICLE,');
        Dm_Common.Que_Tmp.SQL.Add('PRIX_ARTICLE, ETAT_DATA, CODE_EAN');
        Dm_Common.Que_Tmp.SQL.Add('from SYNCWEB_OC_31(:ASSID, :LAST_VERSION, :CURRENT_VERSION, :LAST_VERSION_LAME, :CURRENT_VERSION_LAME,');
        Dm_Common.Que_Tmp.SQL.Add(':DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE, :DECLENCHEMENT, :INITIALISATION, :LAST_DATEEXPORT)');
        if not bInitialisation then
        begin
          Dm_Common.Que_Tmp.SQL.Add('union');
          Dm_Common.Que_Tmp.SQL.Add('select distinct ID_OC, NOM_OC, TYPE_OC, DATE_DEBUT, DATE_FIN, CODE_ARTICLE,');
          Dm_Common.Que_Tmp.SQL.Add('PRIX_ARTICLE, ETAT_DATA, CODE_EAN');
          Dm_Common.Que_Tmp.SQL.Add('from SYNCWEB_OC_32(:ASSID, :LAST_VERSION, :CURRENT_VERSION, :LAST_VERSION_LAME, :CURRENT_VERSION_LAME,');
          Dm_Common.Que_Tmp.SQL.Add(':DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE, :DECLENCHEMENT, :LAST_DATEEXPORT)');
        end;

        Dm_Common.Que_Tmp.ParamByName('ASSID').AsInteger := Dm_Common.MySiteParams.iAssID;
        if not bInitialisation then
        begin
          if(iLastVersionFile <> 0) then
            Dm_Common.Que_Tmp.ParamByName('LAST_VERSION').AsLargeInt := iLastVersionFile
          else
            Dm_Common.Que_Tmp.ParamByName('LAST_VERSION').AsLargeInt := iLastVersion;
          Dm_Common.Que_Tmp.ParamByName('LAST_VERSION_LAME').AsLargeInt := iLastVersionLame;
          Dm_Common.Que_Tmp.ParamByName('LAST_DATEEXPORT').AsDateTime := LastDateExport;
        end
        else
        begin
          Dm_Common.Que_Tmp.ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageBase.Debut;
          Dm_Common.Que_Tmp.ParamByName('LAST_VERSION_LAME').AsLargeInt := Dm_Common.PlageLame.Debut;
          Dm_Common.Que_Tmp.ParamByName('LAST_DATEEXPORT').AsDateTime := 0;
        end;
        Dm_Common.Que_Tmp.ParamByName('CURRENT_VERSION').AsLargeInt := ACurrentVersion;
        Dm_Common.Que_Tmp.ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
        Dm_Common.Que_Tmp.ParamByName('DEBUT_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Debut;
        Dm_Common.Que_Tmp.ParamByName('FIN_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Fin;
        Dm_Common.Que_Tmp.ParamByName('DECLENCHEMENT').AsInteger := Dm_Common.GetParamInteger(407);
        Dm_Common.Que_Tmp.ParamByName('INITIALISATION').AsInteger := IfThen(bInitialisation, 1, 0);
        Dm_Common.Que_Tmp.Open;

        if Dm_Common.Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier3], []) then
        begin
          try
            LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier3]]), 3);
            Application.ProcessMessages;
            DoCsv(Dm_Common.Que_Tmp, Format('%sOC_3%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
            Application.ProcessMessages;
            MajDate(ACurrentVersion, ACurrentVersionLame, 'OC_3.TXT');
          except
            on E: Exception do
              raise Exception.Create('OC_3.TXT -> ' + E.Message);
          end;
        end;
      except
        on E: Exception do
          raise Exception.Create('OC_3.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Génération des fichiers LOTWEB_2 / LOTWEB_3'}
    iFichier  := AListeFichiers.IndexOfName('LOTWEB_2.TXT');
    iFichier2  := AListeFichiers.IndexOfName('LOTWEB_3.TXT');

    if (iFichier > -1) or (iFichier2 > -1) then
    begin
      LogAction(Format(MessDebutRequete, ['LOTWEB_2 / LOTWEB_3']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier,iFichier2],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT DISTINCT LOT_ID CODE_LOT,');
            SQL.Add('                LOT_NOM NOM_LOT,');
            SQL.Add('                LOT_LIBELLE LIBELLE_LOT,');
            SQL.Add('                LOT_COMMENT COMMENT_LOT,');
            SQL.Add('                LOT_DEBUT DEBUT_LOT,');
            SQL.Add('                LOT_FIN FIN_LOT,');
            SQL.Add('                LOT_PERM,');
            SQL.Add('                LOT_PV,');
            SQL.Add('                LOT_PVWEB,');
            SQL.Add('                LOT_SSFID CODE_NK,');
            SQL.Add('                LOL_ID CODE_LIGNE,');
            SQL.Add('                LOL_ARTID CODE_MODEL,');
            SQL.Add('                ART_NOM NOM_ARTICLE,');
            SQL.Add('                TGF_NOM NOM_TAILLE,');
            SQL.Add('                TGF_ID,');
            SQL.Add('                COU_NOM NOM_COULEUR,');
            SQL.Add('                GCS_ID,');
            SQL.Add('                CBI1.CBI_CB CB_ARTICLE,');
            SQL.Add('                LOT_NUMERO CODE_CHRONO,');
            SQL.Add('                LOT_ARCHIVE ARCHIVE,');
            SQL.Add('                LOT_WEB WEB,');
            SQL.Add('                LOT_ICLID CLASSEMENT,');
            SQL.Add('                LOT_PREVENTE PREVENTE,');
            SQL.Add('                LOT_QTEVENTE QTE_PREVENT,');
            SQL.Add('                LOT_DLWIDVTE DELAIS_PREVENTE,');
            SQL.Add('                CASE');
            SQL.Add('                  WHEN ((KLOT.K_ENABLED = 1)');
            SQL.Add('                    AND (KLOL.K_ENABLED = 1)');
            SQL.Add('                    AND (KART.K_ENABLED = 1)');
            SQL.Add('                    AND (KLCT.K_ENABLED = 1)) THEN 1');
            SQL.Add('                  ELSE 0');
            SQL.Add('                END ETAT_DATA,');
            SQL.Add('                CBI2.CBI_CB CODE_EAN');
            SQL.Add('FROM ARTLOT');
            SQL.Add('     JOIN K KLOT                 ON (KLOT.K_ID = LOT_ID AND LOT_ID <> 0)');
            SQL.Add('  JOIN ARTQUELSITE            ON (AQS_LOTID = LOT_ID AND AQS_ASSID = :ASSID)');
            SQL.Add('     JOIN K KAQS                 ON (KAQS.K_ID = AQS_ID)');
            SQL.Add('  JOIN ARTLOTLIGNE            ON (LOL_LOTID = LOT_ID)');
            SQL.Add('     JOIN K KLOL                 ON (KLOL.K_ID = LOL_ID)');
            SQL.Add('  JOIN ARTARTICLE             ON (LOL_ARTID = ART_ID)');
            SQL.Add('     JOIN K KART                 ON (KART.K_ID = ART_ID)');
            SQL.Add('  JOIN ARTLOTDETAIL           ON (LCT_LOLID = LOL_ID)');
            SQL.Add('     JOIN K KLCT                 ON (KLCT.K_ID = LCT_ID)');
            SQL.Add('  JOIN PLXCOULEUR             ON (COU_ID = LCT_COUID)');
            SQL.Add('  JOIN PLXGCS                 ON (GCS_ID = COU_GCSID)');
            SQL.Add('  JOIN PLXTAILLESGF           ON (TGF_ID = LCT_TGFID)');
            SQL.Add('  JOIN ARTREFERENCE           ON (ARF_ARTID = ART_ID)');
            SQL.Add('  JOIN ARTCODEBARRE CBI1      ON (CBI1.CBI_ARFID = ARF_ID AND CBI1.CBI_TGFID = LCT_TGFID AND CBI1.CBI_COUID = LCT_COUID AND CBI1.CBI_TYPE = 1)');
            SQL.Add('  JOIN K KCBI1                ON (KCBI1.K_ID = CBI1.CBI_ID AND KCBI1.K_ENABLED = 1)');
            SQL.Add('  LEFT JOIN ARTCODEBARRE CBI2 ON (CBI2.CBI_ARFID = ARF_ID AND CBI2.CBI_TGFID = LCT_TGFID AND CBI2.CBI_COUID = LCT_COUID AND CBI2.CBI_TYPE = 3 AND CBI2.CBI_PRIN = 1)');
            SQL.Add('  LEFT JOIN K KCBI2           ON (KCBI2.K_ID = CBI2.CBI_ID)');
            SQL.Add('  JOIN ARTQUELSITE            ON (AQS_LOTID = LOT_ID)');

            if not(bInitialisation) then
            begin
              SQL.Add('WHERE ((KAQS.KRH_ID > :LAST_VERSION AND KAQS.KRH_ID <= :CURRENT_VERSION)');
              SQL.Add('   OR (KAQS.K_VERSION > :LAST_VERSION_LAME AND KAQS.K_VERSION <= :CURRENT_VERSION_LAME');
              SQL.Add('    AND NOT(KAQS.KRH_ID > :DEBUT_PLAGE_BASE AND KAQS.KRH_ID <= :FIN_PLAGE_BASE)))');
              SQL.Add('  OR (((KLOT.KRH_ID > :LAST_VERSION AND KLOT.KRH_ID <= :CURRENT_VERSION)');
              SQL.Add('   OR (KLOT.K_VERSION > :LAST_VERSION_LAME AND KLOT.K_VERSION <= :CURRENT_VERSION_LAME');
              SQL.Add('    AND NOT(KLOT.KRH_ID > :DEBUT_PLAGE_BASE AND KLOT.KRH_ID <= :FIN_PLAGE_BASE)))');
              SQL.Add('  OR ((KLOL.KRH_ID > :LAST_VERSION AND KLOL.KRH_ID <= :CURRENT_VERSION)');
              SQL.Add('   OR (KLOL.K_VERSION > :LAST_VERSION_LAME AND KLOL.K_VERSION <= :CURRENT_VERSION_LAME');
              SQL.Add('    AND NOT(KLOL.KRH_ID > :DEBUT_PLAGE_BASE AND KLOL.KRH_ID <= :FIN_PLAGE_BASE)))');
              SQL.Add('  OR ((KART.KRH_ID > :LAST_VERSION AND KART.KRH_ID <= :CURRENT_VERSION)');
              SQL.Add('   OR (KART.K_VERSION > :LAST_VERSION_LAME AND KART.K_VERSION <= :CURRENT_VERSION_LAME');
              SQL.Add('    AND NOT(KART.KRH_ID > :DEBUT_PLAGE_BASE AND KART.KRH_ID <= :FIN_PLAGE_BASE)))');
              SQL.Add('  OR ((KLCT.KRH_ID > :LAST_VERSION AND KLCT.KRH_ID <= :CURRENT_VERSION)');
              SQL.Add('   OR (KLCT.K_VERSION > :LAST_VERSION_LAME AND KLCT.K_VERSION <= :CURRENT_VERSION_LAME');
              SQL.Add('    AND NOT(KLCT.KRH_ID > :DEBUT_PLAGE_BASE AND KLCT.KRH_ID <= :FIN_PLAGE_BASE)))');
              if iFichier2 > -1 then
              begin
                SQL.Add('  OR ((KCBI2.KRH_ID > :LAST_VERSION AND KCBI2.KRH_ID <= :CURRENT_VERSION)');
                SQL.Add('   OR (KCBI2.K_VERSION > :LAST_VERSION_LAME AND KCBI2.K_VERSION <= :CURRENT_VERSION_LAME');
                SQL.Add('    AND NOT(KCBI2.KRH_ID > :DEBUT_PLAGE_BASE AND KCBI2.KRH_ID <= :FIN_PLAGE_BASE))');
              end;
              SQL.Add('));');

              if(iLastVersionFile <> 0) then
                ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
              else
                ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
              ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
              ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
              ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
              ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
              ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
            end
            else
            begin
              SQL.Add('WHERE (KLOT.K_ENABLED = 1)');
              SQL.Add('    AND (KLOL.K_ENABLED = 1)');
              SQL.Add('    AND (KART.K_ENABLED = 1)');
              SQL.Add('    AND (KLCT.K_ENABLED = 1);');
            end;

            ParamByName('ASSID').AsInteger := MySiteParams.iAssID;

            Open;
          end;
          if iFichier > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sLOTWEB_2%s.TXT', [sCheminCsv, sDatePourFic]), 'CODE_EAN', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersion, ACurrentVersionLame, 'LOTWEB_2.TXT');
              except
                on E: Exception do
                  raise Exception.Create('LOTWEB_2.TXT -> ' + E.Message);
              end;
            end;
          end;
          if iFichier2 > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier2]]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sLOTWEB_3%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersion, ACurrentVersionLame, 'LOTWEB_3.TXT');
              except
                on E: Exception do
                  raise Exception.Create('LOTWEB_3.TXT -> ' + E.Message);
              end;
            end;
          end;
      except
        on E: Exception do
          raise Exception.Create('LOTWEB_2.TXT / LOTWEB_3.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération des fichiers LOTWEB_2 / LOTWEB_3'}

    {$REGION 'Génération du fichier LOTNOMENK_2.TXT'}
    iFichier  := AListeFichiers.IndexOfName('LOTNOMENK_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['LOTNOMENK_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT ANW_LOTID CODE_LOT,');
            SQL.Add('       ANW_SSFID CODE_NK,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTNKWEB');
            SQL.Add('  JOIN K ON (K_ID = ANW_ID)');
            SQL.Add('WHERE ANW_ID <> 0');
            SQL.Add('  AND ANW_LOTID <> 0');
            SQL.Add('  AND ANW_ARWID = 0');
            SQL.Add('  AND ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if(iLastVersionFile <> 0) then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT ANW_LOTID CODE_LOT, ANW_SSFID CODE_NK, K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTNKWEB');
            SQL.Add('  JOIN K KANW ON (KANW.K_ID = ANW_ID)');
            SQL.Add('WHERE ANW_ID <> 0');
            SQL.Add('AND ANW_LOTID <> 0');
            SQL.Add('AND ANW_ARWID = 0');
            SQL.Add('and KANW.K_ENABLED = 1;');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sLOTNOMENK_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'LOTNOMENK_2.TXT');

      except
        on E: Exception do
          raise Exception.Create('LOTNOMENK_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier LOTNOMENK_2.TXT'}

    {$REGION 'Génération du fichier LOTPXBRUT.TXT'}
    iFichier  := AListeFichiers.IndexOfName('LOTPXBRUT.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['LOTPXBRUT']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT LOT_ID CODE_LOT,');
          SQL.Add('       (SELECT PX_BRUT');
          SQL.Add('        FROM FC_LOT_PRIXBRUT(ARTLOT.LOT_ID)) PRIX_BRUT');
          SQL.Add('FROM ARTLOT');
          SQL.Add('  JOIN K ON (K_ID = LOT_ID AND K_ENABLED = 1)');
          SQL.Add('  JOIN ARTQUELSITE ON AQS_LOTID = LOT_ID AND (AQS_SUPPR = ''1899-12-30'' OR AQS_SUPPR IS NULL)');
          SQL.Add('WHERE LOT_WEB = 1 AND AQS_ASSID = :ASSID;');
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, GGENPATHCSV + 'LOTPXBRUT.TXT');
        Application.ProcessMessages();
        MajDate(AListeFichiers.Names[iFichier],ACurrentVersion);
      except
        on E: Exception do
          raise Exception.Create('LOTPXBRUT.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier LOTPXBRUT.TXT'}

    // Autres fichiers (procédure trop longue).
    GenerateCsvArtFiles_3(AListeFichiers, bInitialisation, ACurrentVersion, ACurrentVersionLame, iLastVersion, sCheminCsv, sDatePourFic);
  end;
end;

procedure GenerateCsvArtFiles_3(var AListeFichiers: TStringList; const bInitialisation: Boolean; const ACurrentVersion, ACurrentVersionLame, iLastVersion: Int64; const sCheminCsv, sDatePourFic: String);
var
  iFichier, iFichier2, iNbIds, i: Integer;
  iLastVersionFile, iLastVersionLame : Int64;
  EANActif: Array of String;
  bActive: Boolean;
  bChampLameACreer: Boolean;
begin
  with Dm_Common do
  begin
    {$REGION 'Génération du fichier CODEPROMO_2.TXT'}
    iFichier  := AListeFichiers.IndexOfName('CODEPROMO_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['CODEPROMO_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT ART_ID CODE_PROMO,');
            SQL.Add('       ART_NOM LIBELLE,');
            SQL.Add('       PVT_PX PXVTE,');
            SQL.Add('       TPW_TYPE TYPE_VALEUR,');
            SQL.Add('       TPW_NOM NOM_TYPE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((KART.K_ENABLED = 1) AND (KARW.K_ENABLED = 1) AND (KPVT.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTARTICLE');
            SQL.Add('  JOIN K KART       ON (KART.K_ID = ART_ID)');
            SQL.Add('  JOIN ARTWEB       ON (ARW_ARTID = ART_ID)');
            SQL.Add('  JOIN K KARW       ON (ARW_ID = KARW.K_ID)');
            //SR - 18/11/2016 - Pour ne plus tenir compte du site.
            //SQL.Add('  JOIN ARTQUELSITE  ON (ARW_ID = AQS_ARWID AND AQS_ASSID = :ASSID)');
            SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = ART_ID)');
            SQL.Add('  JOIN TARPRIXVENTE ON (PVT_TVTID = 0 AND PVT_ARTID = ART_ID AND PVT_TGFID = 0)');
            SQL.Add('  JOIN K KPVT       ON (KPVT.K_ID = PVT_ID)');
            SQL.Add('  JOIN ARTTYPEPW    ON (TPW_ID = ARF_TPWID)');
            SQL.Add('WHERE ARW_WEB = 1');
            SQL.Add('  AND ARF_VIRTUEL = 1');
            SQL.Add('  AND ART_ID <> 0');
            SQL.Add('  AND (((KART.KRH_ID > :LAST_VERSION AND KART.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KART.K_VERSION > :LAST_VERSION_LAME AND KART.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KART.KRH_ID > :DEBUT_PLAGE_BASE AND KART.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KARW.KRH_ID > :LAST_VERSION AND KARW.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KARW.K_VERSION > :LAST_VERSION_LAME AND KARW.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KARW.KRH_ID > :DEBUT_PLAGE_BASE AND KARW.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KPVT.KRH_ID > :LAST_VERSION AND KPVT.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KPVT.K_VERSION > :LAST_VERSION_LAME AND KPVT.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KPVT.KRH_ID > :DEBUT_PLAGE_BASE AND KPVT.KRH_ID <= :FIN_PLAGE_BASE))));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT ART_ID CODE_PROMO, ART_NOM LIBELLE, PVT_PX PXVTE, TPW_TYPE TYPE_VALEUR,');
            SQL.Add('       TPW_NOM NOM_TYPE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((KART.K_ENABLED = 1) AND (KARW.K_ENABLED = 1) AND (KPVT.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTARTICLE');
            SQL.Add('  JOIN K KART ON (KART.K_ID = ART_ID)');
            SQL.Add('  JOIN ARTWEB ON (ARW_ARTID = ART_ID)');
            SQL.Add('  JOIN K KARW ON (ARW_ID = KARW.K_ID)');
            //SR - 18/11/2016 - Pour ne plus tenir compte du site.
            //SQL.Add('  JOIN ARTQUELSITE  ON (ARW_ID = AQS_ARWID AND AQS_ASSID = :ASSID)');
            SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = ART_ID)');
            SQL.Add('  JOIN TARPRIXVENTE ON (PVT_TVTID = 0 AND PVT_ARTID = ART_ID AND PVT_TGFID = 0)');
            SQL.Add('  JOIN K KPVT ON (KPVT.K_ID = PVT_ID)');
            SQL.Add('  JOIN ARTTYPEPW ON (TPW_ID = ARF_TPWID)');
            SQL.Add('WHERE ARW_WEB = 1');
            SQL.Add('AND ARF_VIRTUEL = 1');
            SQL.Add('AND ART_ID <> 0');
            SQL.Add('and ((KART.K_ENABLED = 1) and (KARW.K_ENABLED = 1) and (KPVT.K_ENABLED = 1));');
          end;
          //SR - 18/11/2016 - Pour ne plus tenir compte du site.
          //ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sCODEPROMO_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'CODEPROMO_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('CODEPROMO_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier CODEPROMO_2.TXT'}

    {$REGION 'Génération du fichier TRANSPORTEURS.TXT'}
    iFichier  := AListeFichiers.IndexOfName('TRANSPORTEURS.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['TRANSPORTEURS']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT TRA_ID ID_TRANSPORTEUR,');
            SQL.Add('       TRA_NOM NOM,');
            SQL.Add('       TRA_CODE CODE,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM NEGTRANSPORT');
            SQL.Add('  JOIN K ON (K_ID = TRA_ID)');
            SQL.Add('WHERE ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersionLame <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT TRA_ID ID_TRANSPORTEUR, TRA_NOM NOM, TRA_CODE CODE, KTRA.K_ENABLED ETAT_DATA');
            SQL.Add('FROM NEGTRANSPORT');
            SQL.Add('  JOIN K KTRA ON (KTRA.K_ID = TRA_ID AND KTRA.K_ID != 0 AND KTRA.KTB_ID = -11111576)');
            SQL.Add('where KTRA.K_ENABLED = 1;');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sTRANSPORTEURS%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'TRANSPORTEURS.TXT');
      except
        on E: Exception do
          raise Exception.Create('TRANSPORTEURS.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier TRANSPORTEURS.TXT'}

    {$REGION 'Génération du fichier COLIS.TXT'}
    iFichier  := AListeFichiers.IndexOfName('COLIS.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['COLIS']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT CBP_ID ID_COLIS,');
            SQL.Add('       BLE_IDWEB ID_COMMANDE,');
            SQL.Add('       CBP_NUM NUMERO_COLIS,');
            SQL.Add('       CBP_TRAID ID_TRANSPORTEUR,');
            SQL.Add('       CBP_TRANSMIS DATE_REMISE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((KCBP.K_ENABLED = 1) AND (KBPR.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM NEGCOLIS');
            SQL.Add('  JOIN K KCBP       ON (KCBP.K_ID = CBP_ID)');
            SQL.Add('  JOIN NEGBONPREPA  ON (BPR_ID = CBP_BPRID)');
            SQL.Add('  JOIN K KBPR       ON (KBPR.K_ID = BPR_ID)');
            SQL.Add('  JOIN NEGBL        ON (BLE_ID = BPR_BLEID)');
            SQL.Add('WHERE BPR_FINI = 2');
            SQL.Add('  AND (((KCBP.KRH_ID > :LAST_VERSION AND KCBP.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KCBP.K_VERSION > :LAST_VERSION_LAME AND KCBP.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KCBP.KRH_ID > :DEBUT_PLAGE_BASE AND KCBP.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KBPR.KRH_ID > :LAST_VERSION AND KBPR.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KBPR.K_VERSION > :LAST_VERSION_LAME AND KBPR.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KBPR.KRH_ID > :DEBUT_PLAGE_BASE AND KBPR.KRH_ID <= :FIN_PLAGE_BASE))));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT CBP_ID ID_COLIS, BLE_IDWEB ID_COMMANDE, CBP_NUM NUMERO_COLIS,');
            SQL.Add('       CBP_TRAID ID_TRANSPORTEUR, CBP_TRANSMIS DATE_REMISE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((KCBP.K_ENABLED = 1) AND (KBPR.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM NEGCOLIS');
            SQL.Add('  JOIN K KCBP ON (KCBP.K_ID = CBP_ID)');
            SQL.Add('  JOIN NEGBONPREPA ON (BPR_ID = CBP_BPRID)');
            SQL.Add('  JOIN K KBPR ON (KBPR.K_ID = BPR_ID)');
            SQL.Add('  JOIN NEGBL ON (BLE_ID = BPR_BLEID)');
            SQL.Add('WHERE BPR_FINI = 2');
            SQL.Add('and ((KCBP.K_ENABLED = 1) and (KBPR.K_ENABLED = 1));');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sCOLIS%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'COLIS.TXT');
      except
        on E: Exception do
          raise Exception.Create('COLIS.TXT -> ' + E.Message);
      end;
    end;

    {$ENDREGION 'Génération du fichier COLIS.TXT'}

    {$REGION 'Génération du fichier ARTSITEWEB.TXT'}
    iFichier  := AListeFichiers.IndexOfName('ARTSITEWEB.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['ARTSITEWEB']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT ASS_ID ID_SITE,');
            SQL.Add('       ASS_NOM NOM,');
            SQL.Add('       ASS_CODE CODE,');
            SQL.Add('       ASS_AMAJ ETAT_DATA');
            SQL.Add('FROM ARTSITEWEB');
            SQL.Add('  JOIN K ON (K_ID = ASS_ID)');
            SQL.Add('WHERE ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT ASS_ID ID_SITE, ASS_NOM NOM, ASS_CODE CODE, KASS.K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTSITEWEB');
            SQL.Add('  JOIN K KASS ON (KASS.K_ID = ASS_ID AND KASS.K_ID != 0)');
            SQL.Add('where KASS.K_ENABLED = 1;');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sARTSITEWEB%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTSITEWEB.TXT');
      except
        on E: Exception do
          raise Exception.Create('ARTSITEWEB.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier ARTSITEWEB.TXT'}

    {$REGION 'Génération du fichier ARTQUELSITE.TXT'}
    iFichier  := AListeFichiers.IndexOfName('ARTQUELSITE.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['ARTQUELSITE']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT AQS_ID ID_QUELSITE,');
            SQL.Add('       AQS_ARWID CODE_ARTICLE,');
            SQL.Add('       AQS_ASSID ID_SITE,');
            SQL.Add('       AQS_OK DATE_ENLIGNE,');
            SQL.Add('       AQS_SUPPR DATE_SUPPRESSION,');
            SQL.Add('       CASE AQS_SUPPR');
            SQL.Add('         WHEN ''1899-12-30'' THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ACTIF,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN K ON (K_ID = AQS_ID)');
            SQL.Add('WHERE AQS_ARWID <> 0');
            SQL.Add('  AND ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT AQS_ID ID_QUELSITE, AQS_ARWID CODE_ARTICLE, AQS_ASSID ID_SITE,');
            SQL.Add('       AQS_OK DATE_ENLIGNE, AQS_SUPPR DATE_SUPPRESSION,');
            SQL.Add('       CASE AQS_SUPPR');
            SQL.Add('         WHEN ''1899-12-30'' THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ACTIF,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN K ON (K_ID = AQS_ID AND KTB_ID = -11111574)');
            SQL.Add('WHERE AQS_ARWID <> 0');
            SQL.Add('and K_ENABLED = 1;');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sARTQUELSITE%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTQUELSITE.TXT');
      except
        on E: Exception do
          raise Exception.Create('ARTQUELSITE.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier ARTQUELSITE.TXT'}

    {$REGION 'Génération du fichier ARTQUELSITE_LOT.TXT'}
    iFichier  := AListeFichiers.IndexOfName('ARTQUELSITE_LOT.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['ARTQUELSITE_LOT']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT AQS_ID ID_QUELSITE,');
            SQL.Add('       AQS_LOTID CODE_LOT,');
            SQL.Add('       AQS_ASSID ID_SITE,');
            SQL.Add('       AQS_OK DATE_ENLIGNE,');
            SQL.Add('       AQS_SUPPR DATE_SUPPRESSION,');
            SQL.Add('       CASE AQS_SUPPR');
            SQL.Add('         WHEN ''1899-12-30'' THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ACTIF,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN K ON (K_ID = AQS_ID)');
            SQL.Add('WHERE AQS_LOTID <> 0');
            SQL.Add('  AND ((KRH_ID > :LAST_VERSION AND KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (K_VERSION > :LAST_VERSION_LAME AND K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KRH_ID > :DEBUT_PLAGE_BASE AND KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT AQS_ID ID_QUELSITE, AQS_LOTID CODE_LOT, AQS_ASSID ID_SITE,');
            SQL.Add('       AQS_OK DATE_ENLIGNE, AQS_SUPPR DATE_SUPPRESSION,');
            SQL.Add('       CASE AQS_SUPPR');
            SQL.Add('         WHEN ''1899-12-30'' THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ACTIF,');
            SQL.Add('       K_ENABLED ETAT_DATA');
            SQL.Add('FROM ARTQUELSITE');
            SQL.Add('  JOIN K ON (K_ID = AQS_ID AND KTB_ID = -11111574)');
            SQL.Add('WHERE AQS_LOTID <> 0');
            SQL.Add('and K_ENABLED = 1;');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sARTQUELSITE_LOT%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'ARTQUELSITE_LOT.TXT');
      except
        on E: Exception do
          raise Exception.Create('ARTQUELSITE_LOT.TXT -> ' + E.Message);
      end;

    end;
    {$ENDREGION 'Génération du fichier ARTQUELSITE_LOT.TXT'}

    {$REGION 'Génération du fichier CLIENTS.TXT'}
    iFichier  := AListeFichiers.IndexOfName('CLIENTS.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['CLIENTS']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);


        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT CLT_ID ID_CLIENT,');
            SQL.Add('       CLT_NUMERO CHRONO_CLIENT,');
            SQL.Add('       ADR_EMAIL EMAIL_CLIENT,');
            SQL.Add('       CLT_IDREF ID_CLIENT_SITE,');
            SQL.Add('       KCLT.K_ENABLED ETAT_DATA');
            SQL.Add('FROM CLTCLIENT');
            SQL.Add('  JOIN K KCLT     ON (KCLT.K_ID = CLT_ID)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('  JOIN K KADR     ON (KADR.K_ID = ADR_ID)');
            SQL.Add('left join CLTCONSENTEMENT on (CST_CLTID = CLT_ID and CST_CODEFON = 2001)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL)');
            SQL.Add('   OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('  AND (((KCLT.KRH_ID > :LAST_VERSION AND KCLT.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KCLT.K_VERSION > :LAST_VERSION_LAME AND KCLT.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KCLT.KRH_ID > :DEBUT_PLAGE_BASE AND KCLT.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KADR.KRH_ID > :LAST_VERSION AND KADR.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KADR.K_VERSION > :LAST_VERSION_LAME AND KADR.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KADR.KRH_ID > :DEBUT_PLAGE_BASE AND KADR.KRH_ID <= :FIN_PLAGE_BASE))))');
            SQL.Add('and (CST_OUI = 1 or CST_OUI is null)');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT CLT_ID ID_CLIENT, CLT_NUMERO CHRONO_CLIENT, ADR_EMAIL EMAIL_CLIENT,');
            SQL.Add('       CLT_IDREF ID_CLIENT_SITE, KCLT.K_ENABLED ETAT_DATA');
            SQL.Add('FROM CLTCLIENT');
            SQL.Add('  JOIN K KCLT ON (KCLT.K_ID = CLT_ID AND KCLT.K_ID != 0)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('left join CLTCONSENTEMENT on (CST_CLTID = CLT_ID and CST_CODEFON = 2001)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL) OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('and KCLT.K_ENABLED = 1');
            SQL.Add('and (CST_OUI = 1 or CST_OUI is null)');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sCLIENTS%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'CLIENTS.TXT');
      except
        on E: Exception do
          raise Exception.Create('CLIENTS.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier CLIENTS.TXT'}

    {$REGION 'Génération du fichier CLIENTS_2.TXT'}
    iFichier  := AListeFichiers.IndexOfName('CLIENTS_2.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['CLIENTS_2']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT CLT_ID ID_CLIENT,');
            SQL.Add('       CLT_NUMERO CHRONO_CLIENT,');
            SQL.Add('       ADR_EMAIL EMAIL_CLIENT,');
            SQL.Add('       CLT_IDREF ID_CLIENT_SITE,');
            SQL.Add('       KCLT.K_ENABLED ETAT_DATA,');
            SQL.Add('       CLT_TYPE TYPE_CLIENT');
            SQL.Add('FROM CLTCLIENT');
            SQL.Add('  JOIN K KCLT     ON (KCLT.K_ID = CLT_ID)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('  JOIN K KADR     ON (KADR.K_ID = ADR_ID)');
            SQL.Add('left join CLTCONSENTEMENT on (CST_CLTID = CLT_ID and CST_CODEFON = 2001)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL)');
            SQL.Add('   OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('  AND (((KCLT.KRH_ID > :LAST_VERSION AND KCLT.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KCLT.K_VERSION > :LAST_VERSION_LAME AND KCLT.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KCLT.KRH_ID > :DEBUT_PLAGE_BASE AND KCLT.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KADR.KRH_ID > :LAST_VERSION AND KADR.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KADR.K_VERSION > :LAST_VERSION_LAME AND KADR.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KADR.KRH_ID > :DEBUT_PLAGE_BASE AND KADR.KRH_ID <= :FIN_PLAGE_BASE))))');
            SQL.Add('and (CST_OUI = 1 or CST_OUI is null)');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT CLT_ID ID_CLIENT, CLT_NUMERO CHRONO_CLIENT, ADR_EMAIL EMAIL_CLIENT,');
            SQL.Add('       CLT_IDREF ID_CLIENT_SITE, KCLT.K_ENABLED ETAT_DATA, CLT_TYPE TYPE_CLIENT');
            SQL.Add('FROM CLTCLIENT');
            SQL.Add('  JOIN K KCLT ON (KCLT.K_ID = CLT_ID AND KCLT.K_ID != 0)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('left join CLTCONSENTEMENT on (CST_CLTID = CLT_ID and CST_CODEFON = 2001)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL) OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('and KCLT.K_ENABLED = 1');
            SQL.Add('and (CST_OUI = 1 or CST_OUI is null)');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sCLIENTS_2%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'CLIENTS_2.TXT');
      except
        on E: Exception do
          raise Exception.Create('CLIENTS_2.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier CLIENTS_2.TXT'}

    {$REGION 'Génération du fichier CLIENTS_3.TXT'}
    iFichier  := AListeFichiers.IndexOfName('CLIENTS_3.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['CLIENTS_3']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT CLT_ID ID_CLIENT,');
            SQL.Add('       CLT_NUMERO CHRONO_CLIENT,');
            SQL.Add('       ADR_EMAIL EMAIL_CLIENT,');
            SQL.Add('       CLT_IDREF ID_CLIENT_SITE,');
            SQL.Add('       KCLT.K_ENABLED ETAT_DATA,');
            SQL.Add('       CLT_TYPE TYPE_CLIENT,');
            SQL.Add('       ADR_GSM PORTABLE_CLIENT,');
            SQL.Add('       CLT_OPTINEMAIL ENVOI_MAIL,');
            SQL.Add('       CLT_OPINSMS ENVOI_SMS');
            SQL.Add('FROM CLTCLIENT');
            SQL.Add('  JOIN K KCLT     ON (KCLT.K_ID = CLT_ID)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('  JOIN K KADR     ON (KADR.K_ID = ADR_ID)');
            SQL.Add('left join CLTCONSENTEMENT on (CST_CLTID = CLT_ID and CST_CODEFON = 2001)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL)');
            SQL.Add('   OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('  AND (((KCLT.KRH_ID > :LAST_VERSION AND KCLT.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KCLT.K_VERSION > :LAST_VERSION_LAME AND KCLT.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KCLT.KRH_ID > :DEBUT_PLAGE_BASE AND KCLT.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KADR.KRH_ID > :LAST_VERSION AND KADR.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KADR.K_VERSION > :LAST_VERSION_LAME AND KADR.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KADR.KRH_ID > :DEBUT_PLAGE_BASE AND KADR.KRH_ID <= :FIN_PLAGE_BASE))))');
            SQL.Add('and (CST_OUI = 1 or CST_OUI is null)');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT CLT_ID ID_CLIENT, CLT_NUMERO CHRONO_CLIENT, ADR_EMAIL EMAIL_CLIENT,');
            SQL.Add('       CLT_IDREF ID_CLIENT_SITE, KCLT.K_ENABLED ETAT_DATA, CLT_TYPE TYPE_CLIENT,');
            SQL.Add('       ADR_GSM PORTABLE_CLIENT,');
            SQL.Add('       CLT_OPTINEMAIL ENVOI_MAIL,');
            SQL.Add('       CLT_OPINSMS ENVOI_SMS');
            SQL.Add('FROM CLTCLIENT');
            SQL.Add('  JOIN K KCLT ON (KCLT.K_ID = CLT_ID AND KCLT.K_ID != 0)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('left join CLTCONSENTEMENT on (CST_CLTID = CLT_ID and CST_CODEFON = 2001)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL) OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('and KCLT.K_ENABLED = 1');
            SQL.Add('and (CST_OUI = 1 or CST_OUI is null)');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sCLIENTS_3%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'CLIENTS_3.TXT');
      except
        on E: Exception do
          raise Exception.Create('CLIENTS_3.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier CLIENTS_3.TXT'}

    {$REGION 'Génération du fichier BONACHAT.TXT'}
    iFichier  := AListeFichiers.IndexOfName('BONACHAT.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['BONACHAT']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);
        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT BAC_ID ID_BONACHAT,');
            SQL.Add('       BAC_CLTID ID_CLIENT,');
            SQL.Add('       BAC_MONTANT MONTANT,');
            SQL.Add('       KBAC.K_ENABLED ETAT_DATA');
            SQL.Add('FROM CLTBONACHAT');
            SQL.Add('  JOIN K KBAC     ON (KBAC.K_ID = BAC_ID)');
            SQL.Add('  JOIN CLTCLIENT  ON (CLT_ID = BAC_CLTID)');
            SQL.Add('  JOIN K KCLT     ON (KCLT.K_ID = CLT_ID)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL)');
            SQL.Add('   OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('  AND ((KBAC.KRH_ID > :LAST_VERSION AND KBAC.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KBAC.K_VERSION > :LAST_VERSION_LAME AND KBAC.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KBAC.KRH_ID > :DEBUT_PLAGE_BASE AND KBAC.KRH_ID <= :FIN_PLAGE_BASE)));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT BAC_ID ID_BONACHAT, BAC_CLTID ID_CLIENT, BAC_MONTANT MONTANT,');
            SQL.Add('       KBAC.K_ENABLED ETAT_DATA');
            SQL.Add('FROM CLTBONACHAT');
            SQL.Add('  JOIN K KBAC ON (KBAC.K_ID = BAC_ID AND KBAC.K_ID != 0)');
            SQL.Add('  JOIN CLTCLIENT ON (CLT_ID = BAC_CLTID)');
            SQL.Add('  JOIN K KCLT ON (KCLT.K_ID = CLT_ID AND KCLT.K_ID != 0)');
            SQL.Add('  JOIN GENADRESSE ON (ADR_ID = CLT_ADRID)');
            SQL.Add('WHERE ((ADR_EMAIL != '''' AND ADR_EMAIL IS NOT NULL) OR (CLT_IDREF != '''' AND CLT_IDREF IS NOT NULL))');
            SQL.Add('and ((KBAC.K_ENABLED = 1) and (KCLT.K_ENABLED = 1));');
          end;

          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sBONACHAT%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'BONACHAT.TXT');
      except
        on E: Exception do
          raise Exception.Create('BONACHAT.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier BONACHAT.TXT'}

    {$REGION 'Génération du fichier MODELE.TXT'}
    iFichier  := AListeFichiers.IndexOfName('MODELE.TXT');
    if iFichier > -1 then
    begin
      LogAction(Format(MessDebutRequete, ['MODELE']), 3);
      try
        GetLastVersions(AListeFichiers,[iFichier],iLastVersionFile,iLastVersionLame);


        with Que_Tmp do
        begin
          Close;
          SQL.Clear;

          if not(bInitialisation) then
          begin
            SQL.Add('SELECT ART_ID CODE_MODELE,');
            SQL.Add('       ARW_SSFID CODE_NK,');
            SQL.Add('       MRK_ID IDMARQUE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (MRK_NOM = '''') THEN ''NON DEFINIE''');
            SQL.Add('         ELSE MRK_NOM');
            SQL.Add('       END MARQUE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (ART_REFMRK = '''') THEN ''NON DEFINI''');
            SQL.Add('         ELSE ART_REFMRK');
            SQL.Add('       END CODE_FOURN,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (ART_NOM = '''') THEN ''NON DEFINI''');
            SQL.Add('         ELSE ART_NOM');
            SQL.Add('       END PRODUIT,');
            SQL.Add('       TVA_TAUX TVA,');
            SQL.Add('       GRE_ID GENRE,');
            SQL.Add('       ICL1.ICL_NOM CLASSEMENT1,');
            SQL.Add('       ICL2.ICL_NOM CLASSEMENT2,');
            SQL.Add('       ICL3.ICL_NOM CLASSEMENT3,');
            SQL.Add('       ICL4.ICL_NOM CLASSEMENT4,');
            SQL.Add('       ICL5.ICL_NOM CLASSEMENT5,');
            SQL.Add('       (SELECT COLNOM');
            SQL.Add('        FROM SM_STAT_COLLECTION(ARTARTICLE.ART_ID)) COLLECTION,');
            SQL.Add('       ARW_DETAIL WEB_DETAIL,');
            SQL.Add('       ARW_COMPOSITION WEB_COMPOSITION,');
            SQL.Add('       ARF_CHRONO CODE_CHRONO,');
            SQL.Add('       ARF_ARCHIVER ARCHIVER,');
            SQL.Add('       ARW_WEB WEB,');
            SQL.Add('       ARW_DLWIDVTE DELAIS_PREVENTE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN ((KASS.K_ENABLED = 1)');
            SQL.Add('           AND (KARW.K_ENABLED = 1)');
            SQL.Add('           AND (KART.K_ENABLED = 1)');
            SQL.Add('           AND (KMRK.K_ENABLED = 1)');
            SQL.Add('           AND (KGRE.K_ENABLED = 1)');
            SQL.Add('           AND (KTVA.K_ENABLED = 1)) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTSITEWEB');
            SQL.Add('  JOIN ARTQUELSITE        ON (ASS_ID = AQS_ASSID AND ASS_AMAJ = 1)');
            SQL.Add('  JOIN K KASS             ON (KASS.K_ID = ASS_ID)');
            SQL.Add('  JOIN ARTWEB             ON (ARW_ID = AQS_ARWID AND ARW_WEB = 1)');
            SQL.Add('  JOIN K KARW             ON (KARW.K_ID = ARW_ID)');
            SQL.Add('  JOIN ARTARTICLE         ON (ARW_ARTID = ART_ID)');
            SQL.Add('  JOIN K KART             ON (KART.K_ID = ART_ID)');
            SQL.Add('  JOIN ARTREFERENCE       ON (ARF_ARTID = ART_ID)');
            SQL.Add('  JOIN ARTMARQUE          ON (MRK_ID = ART_MRKID)');
            SQL.Add('  JOIN K KMRK             ON (KMRK.K_ID = MRK_ID)');
            SQL.Add('  JOIN ARTGENRE           ON (GRE_ID = ART_GREID)');
            SQL.Add('  JOIN K KGRE             ON (KGRE.K_ID = GRE_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL1 ON (ICL1.ICL_ID = ARF_ICLID1)');
            SQL.Add('  LEFT JOIN K KICL1       ON (KICL1.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL2 ON (ICL2.ICL_ID = ARF_ICLID2)');
            SQL.Add('  LEFT JOIN K KICL2       ON (KICL2.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL3 ON (ICL3.ICL_ID = ARF_ICLID3)');
            SQL.Add('  LEFT JOIN K KICL3       ON (KICL3.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL4 ON (ICL4.ICL_ID = ARF_ICLID4)');
            SQL.Add('  LEFT JOIN K KICL4       ON (KICL4.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL5 ON (ICL5.ICL_ID = ARF_ICLID5)');
            SQL.Add('  LEFT JOIN K KICL5       ON (KICL5.K_ID = ICL_ID)');
            SQL.Add('  JOIN ARTTVA             ON (TVA_ID = ARF_TVAID)');
            SQL.Add('  JOIN K KTVA             ON (KTVA.K_ID = TVA_ID)');
            SQL.Add('WHERE (ASS_ID = :ASSID)');
            SQL.Add('  AND (AQS_SUPPR = ''1899-12-30''');
            SQL.Add('   OR AQS_SUPPR IS NULL)');
            SQL.Add('  AND (((KASS.KRH_ID > :LAST_VERSION AND KASS.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KASS.K_VERSION > :LAST_VERSION_LAME AND KASS.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KASS.KRH_ID > :DEBUT_PLAGE_BASE AND KASS.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KARW.KRH_ID > :LAST_VERSION AND KARW.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KARW.K_VERSION > :LAST_VERSION_LAME AND KARW.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KARW.KRH_ID > :DEBUT_PLAGE_BASE AND KARW.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KART.KRH_ID > :LAST_VERSION AND KART.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KART.K_VERSION > :LAST_VERSION_LAME AND KART.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KART.KRH_ID > :DEBUT_PLAGE_BASE AND KART.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KMRK.KRH_ID > :LAST_VERSION AND KMRK.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KMRK.K_VERSION > :LAST_VERSION_LAME AND KMRK.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KMRK.KRH_ID > :DEBUT_PLAGE_BASE AND KMRK.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KGRE.KRH_ID > :LAST_VERSION AND KGRE.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KGRE.K_VERSION > :LAST_VERSION_LAME AND KGRE.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KGRE.KRH_ID > :DEBUT_PLAGE_BASE AND KGRE.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KICL1.KRH_ID > :LAST_VERSION AND KICL1.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KICL1.K_VERSION > :LAST_VERSION_LAME AND KICL1.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KICL1.KRH_ID > :DEBUT_PLAGE_BASE AND KICL1.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KICL2.KRH_ID > :LAST_VERSION AND KICL2.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KICL2.K_VERSION > :LAST_VERSION_LAME AND KICL2.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KICL2.KRH_ID > :DEBUT_PLAGE_BASE AND KICL2.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KICL3.KRH_ID > :LAST_VERSION AND KICL3.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KICL3.K_VERSION > :LAST_VERSION_LAME AND KICL3.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KICL3.KRH_ID > :DEBUT_PLAGE_BASE AND KICL3.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KICL4.KRH_ID > :LAST_VERSION AND KICL4.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KICL4.K_VERSION > :LAST_VERSION_LAME AND KICL4.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KICL4.KRH_ID > :DEBUT_PLAGE_BASE AND KICL4.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KICL5.KRH_ID > :LAST_VERSION AND KICL5.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KICL5.K_VERSION > :LAST_VERSION_LAME AND KICL5.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KICL5.KRH_ID > :DEBUT_PLAGE_BASE AND KICL5.KRH_ID <= :FIN_PLAGE_BASE)))');
            SQL.Add('  OR ((KTVA.KRH_ID > :LAST_VERSION AND KTVA.KRH_ID <= :CURRENT_VERSION)');
            SQL.Add('   OR (KTVA.K_VERSION > :LAST_VERSION_LAME AND KTVA.K_VERSION <= :CURRENT_VERSION_LAME');
            SQL.Add('    AND NOT(KTVA.KRH_ID > :DEBUT_PLAGE_BASE AND KTVA.KRH_ID <= :FIN_PLAGE_BASE))));');

            if iLastVersionFile <> 0 then
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersionFile
            else
              ParamByName('LAST_VERSION').AsLargeInt   := iLastVersion;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersion;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
          end
          else
          begin
            SQL.Add('SELECT ART_ID CODE_MODELE, ARW_SSFID CODE_NK,');
            SQL.Add('       MRK_ID IDMARQUE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (MRK_NOM = '''') THEN ''NON DEFINIE''');
            SQL.Add('         ELSE MRK_NOM');
            SQL.Add('       END MARQUE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (ART_REFMRK = '''') THEN ''NON DEFINI''');
            SQL.Add('         ELSE ART_REFMRK');
            SQL.Add('       END CODE_FOURN,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (ART_NOM = '''') THEN ''NON DEFINI''');
            SQL.Add('         ELSE ART_NOM');
            SQL.Add('       END PRODUIT,');
            SQL.Add('       TVA_TAUX TVA, GRE_ID GENRE, ICL1.ICL_NOM CLASSEMENT1,');
            SQL.Add('       ICL2.ICL_NOM CLASSEMENT2, ICL3.ICL_NOM CLASSEMENT3,');
            SQL.Add('       ICL4.ICL_NOM CLASSEMENT4, ICL5.ICL_NOM CLASSEMENT5,');
            SQL.Add('       (SELECT COLNOM');
            SQL.Add('        FROM SM_STAT_COLLECTION(ARTARTICLE.ART_ID)) COLLECTION,');
            SQL.Add('       ARW_DETAIL WEB_DETAIL, ARW_COMPOSITION WEB_COMPOSITION,');
            SQL.Add('       ARF_CHRONO CODE_CHRONO, ARF_ARCHIVER ARCHIVER,');
            SQL.Add('       ARW_WEB WEB, ARW_PREVENTE PREVENTE,');
            SQL.Add('       CASE');
            SQL.Add('         WHEN (KASS.K_ENABLED = 1)');
            SQL.Add('           AND (KARW.K_ENABLED = 1)');
            SQL.Add('           AND (KART.K_ENABLED = 1)');
            SQL.Add('           AND (KMRK.K_ENABLED = 1)');
            SQL.Add('           AND (KGRE.K_ENABLED = 1)');
            SQL.Add('           AND (KTVA.K_ENABLED = 1) THEN 1');
            SQL.Add('         ELSE 0');
            SQL.Add('       END ETAT_DATA');
            SQL.Add('FROM ARTSITEWEB');
            SQL.Add('  JOIN ARTQUELSITE ON (ASS_ID = AQS_ASSID AND ASS_AMAJ = 1)');
            SQL.Add('  JOIN K KASS ON (KASS.K_ID = ASS_ID)');
            SQL.Add('  JOIN ARTWEB ON (ARW_ID = AQS_ARWID AND ARW_WEB = 1)');
            SQL.Add('  JOIN K KARW ON (KARW.K_ID = ARW_ID)');
            SQL.Add('  JOIN ARTARTICLE ON (ARW_ARTID = ART_ID)');
            SQL.Add('  JOIN K KART ON (KART.K_ID = ART_ID)');
            SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = ART_ID)');
            SQL.Add('  JOIN ARTMARQUE ON (MRK_ID = ART_MRKID)');
            SQL.Add('  JOIN K KMRK ON (KMRK.K_ID = MRK_ID)');
            SQL.Add('  JOIN ARTGENRE ON (GRE_ID = ART_GREID)');
            SQL.Add('  JOIN K KGRE ON (KGRE.K_ID = GRE_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL1 ON (ICL1.ICL_ID = ARF_ICLID1)');
            SQL.Add('  LEFT JOIN K KICL1 ON (KICL1.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL2 ON (ICL2.ICL_ID = ARF_ICLID2)');
            SQL.Add('  LEFT JOIN K KICL2 ON (KICL2.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL3 ON (ICL3.ICL_ID = ARF_ICLID3)');
            SQL.Add('  LEFT JOIN K KICL3 ON (KICL3.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL4 ON (ICL4.ICL_ID = ARF_ICLID4)');
            SQL.Add('  LEFT JOIN K KICL4 ON (KICL4.K_ID = ICL_ID)');
            SQL.Add('  LEFT JOIN ARTITEMC ICL5 ON (ICL5.ICL_ID = ARF_ICLID5)');
            SQL.Add('  LEFT JOIN K KICL5 ON (KICL5.K_ID = ICL_ID)');
            SQL.Add('  JOIN ARTTVA ON (TVA_ID = ARF_TVAID)');
            SQL.Add('  JOIN K KTVA ON (KTVA.K_ID = TVA_ID)');
            SQL.Add('WHERE (ASS_ID = :ASSID)');
            SQL.Add('  AND (AQS_SUPPR = ''1899-12-30'' OR AQS_SUPPR IS NULL)');
            SQL.Add('and ((KASS.K_ENABLED = 1) and (KARW.K_ENABLED = 1) and (KART.K_ENABLED = 1) and (KMRK.K_ENABLED = 1) and (KGRE.K_ENABLED = 1) and (KTVA.K_ENABLED = 1));');
          end;
          ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
          Open;
        end;
        LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + AListeFichiers.Names[iFichier]]), 3);
        Application.ProcessMessages();
        DoCsv(Que_Tmp, Format('%sMODELE%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
        Application.ProcessMessages();
        MajDate(ACurrentVersion, ACurrentVersionLame, 'MODELE.TXT');
      except
        on E: Exception do
          raise Exception.Create('MODELE.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier MODELE'}
  end;
end;

function GenerateCsvStkFiles(var AListeFichiers: TStringList; const ACurrentVersionStk, ACurrentVersionArt, ACurrentVersionLame: Int64; const bInitialisation, bDateFicInit, bDateFic: Boolean): Boolean;
const
  REGEX_PLAGE = '\[(\d+)M_';  
var
  iLocalMagId: Integer;
  //Id du magasin correspond à la base en cours d'utilisation
  iExtractMagId: Integer; //Id du magasin à extraire
  iCumulMagId: Integer; //Id du magasin à cumuler
  iLastVersionArt: Int64;
  iLastVersionLame: Int64;
  iLastVersionStk: Int64;
  iLastVersion: Int64;
  iFichier, iFichier2: Integer;
  bActive: Boolean;
  sPlage: String;
  regPlage: TPerlRegEx;
  sCheminCsv: String;
  sDatePourFic: string;     //Chaine avec la date si on l'ajoute au nom du fichier
begin
  Result := False;
  iLastVersion := 0;
  with Dm_Common do
  try
    if not(bInitialisation) then
    begin
      iLastVersion    := IdBase();
      sCheminCsv := IncludeTrailingPathDelimiter(GGENPATHCSV);
      if bDateFic then
        sDatePourFic := '-' + FormatDateTime('yyyymmddhhnnss', Now)
      else
        sDatePourFic := '';
    end
    else
    begin
      sCheminCsv := IncludeTrailingPathDelimiter(GGENPATHCSV) + 'INIT_';
      if bDateFicInit then
        sDatePourFic := '-' + FormatDateTime('yyyymmddhhnnss', Now)
      else
        sDatePourFic := '';
    end;

    //Recherche du magasin correspond à la BdD
    iLocalMagId := IdentLocalMagid;
    if iLocalMagId = 0 then
      iLocalMagId := MySiteParams.iMagID;

    // Lecture de la liste d'extraction
    iExtractMagId := 0;
    iCumulMagId := 0;
    try
        Que_Tmp.Close;
        Que_Tmp.SQL.Clear;
        Que_Tmp.SQL.Text := 'Select prm_magid, prm_pos ' +
          'from genparam ' +
          'join k on (k_id=prm_id) and (k_enabled=1) ' +
          'where (prm_type=9) and (prm_code=404) ';
        Que_Tmp.Open;
        if Que_Tmp.IsEmpty then
        begin
          //si vide et qu'on est sur la base web on exporte depuis le mag web (par défaut si aucune config)
          if CtrlIdentBaseWeb then
          begin
            iExtractMagId := MySiteParams.iMagID;
          end
          //sinon on s'en va
          else
          begin
            exit;
          end;
        end
        else
        begin
          Que_Tmp.First;
          //recherche du mag d'extraction et du mag cumulé
          if Que_Tmp.Locate('prm_magid', iLocalMagId, []) then
          begin
            iExtractMagId := Que_Tmp.FieldByName('prm_magid').AsInteger;
            iCumulMagId := Que_Tmp.FieldByName('prm_pos').AsInteger;
          end
          // mag pas dans la liste d'export
          else
          begin
            exit;
          end;
        end;
        Que_Tmp.Close;
    except on E: Exception do
        raise Exception.Create('GenerateCsvStkFiles -> ' + E.Message);
    end;

    {$REGION 'Génération du fichier STOCK_IDMAG'}
    iFichier  := AListeFichiers.IndexOfName('STOCK_IDMAG.TXT');
    if iFichier > -1 then
    begin
      if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
      begin
        try
          LogAction(Format(MessCreationFichier, [ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
          
          with Que_Tmp do
          begin
            Close;
            SQL.Clear;

            SQL.Add('SELECT CODE_ARTICLE, ID_SEUIL, LIB_SEUIL, QTE_STOCK,'+IntToStr(iExtractMagId)+' MAG_ID');
            SQL.Add('FROM SYNCWEB_STOCK_2_IDMAG(:ASSID, :LAST_VERSION_STK, :CURRENT_VERSION_STK, :LAST_VERSION_ART, :CURRENT_VERSION_ART, ');
            SQL.Add('     :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE, :MAGID, :CUMULID)');
            SQL.Add('WHERE ETAT_DATA = 1');

            ParamByName('LAST_VERSION_ART').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('LAST_VERSION_LAME').AsLargeInt    := Dm_Common.PlageLame.Debut;
            ParamByName('LAST_VERSION_STK').AsLargeInt     := 0;
            ParamByName('CURRENT_VERSION_ART').AsLargeInt  := ACurrentVersionArt;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('CURRENT_VERSION_STK').AsLargeInt  := ACurrentVersionStk;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
            ParamByName('ASSID').AsInteger                := MySiteParams.iAssID;
            ParamByName('MAGID').AsInteger                := iExtractMagId;
            ParamByName('CUMULID').AsInteger              := iCumulMagId;

            Open;
          end;
          Application.ProcessMessages();
          DoCsv(Que_Tmp, GGENPATHCSV + 'STOCK_' + IntToStr(iExtractMagId) + '.TXT');
          Application.ProcessMessages();
          MajDate(AListeFichiers.Names[iFichier],ACurrentVersionStk);
        except on E: Exception do
            raise Exception.Create('STOCK_' + IntToStr(iExtractMagId) + '.TXT -> ' + E.Message);
        end;
      end;
    end;
    {$ENDREGION 'Génération du fichier STOCK_IDMAG'}

    {$REGION 'Génération du fichier STOCKLOT_IDMAG'}
    iFichier  := AListeFichiers.IndexOfName('STOCKLOT_IDMAG.TXT');
    if iFichier > -1 then
    begin
      if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
      begin
        try
          LogAction(Format(MessCreationFichier, [ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
          
          with Que_Tmp do
          begin
            Close;
            SQL.Clear;

            SQL.Add('SELECT CODE_LOT, ID_SEUIL, LIB_SEUIL, CODE_LIGNE, CB_ARTICLE, QTE_STOCK STOCK_ARTICLE,');
            SQL.Add(IntToStr(iExtractMagId)+' MAG_ID');
            SQL.Add('FROM SYNCWEB_STOCKLOT_2_IDMAG(:MAGID, :CUMULID, :ASSID, :LAST_VERSION, :CURRENT_VERSION)');
            SQL.Add('WHERE ETAT_DATA = 1');
            ParamByName('MAGID').AsInteger            := iExtractMagId;
            ParamByName('CUMULID').AsInteger          := iCumulMagId;
            ParamByName('ASSID').AsInteger            := MySiteParams.iAssID;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersionStk;
            ParamByName('LAST_VERSION').AsLargeInt   := 0;

            Open;
          end;
          Application.ProcessMessages();
          DoCsv(Que_Tmp, GGENPATHCSV + 'STOCKLOT_' + IntToStr(iExtractMagId) +
            '.TXT');
          Application.ProcessMessages();
          MajDate(AListeFichiers.Names[iFichier],ACurrentVersionStk);
        except on E: Exception do
            raise Exception.Create('STOCKLOT_' + IntToStr(iExtractMagId) + '.TXT -> ' + E.Message);
        end;
      end;
    end;
    {$ENDREGION 'Génération du fichier STOCKLOT_IDMAG'}

    {$REGION 'Génération du fichier STOCK_2_IDMAG / STOCK_3_IDMAG'}
    iFichier  := AListeFichiers.IndexOfName('STOCK_2_IDMAG.TXT');
    iFichier2  := AListeFichiers.IndexOfName('STOCK_3_IDMAG.TXT');

    if(iFichier > -1) or (iFichier2 > -1) then
    begin
      GetLastVersions(AListeFichiers,[iFichier,iFichier2],iLastVersionArt, iLastVersionLame);
      iLastVersionStk := 0;
      if not bInitialisation then
      begin
        iLastVersionStk := -1;
        if iFichier > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_FICHIER', AListeFichiers.Names[iFichier]+'-GENSTOCK', []) then
            iLastVersionStk := Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt;
        end;
        if iFichier2 > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_FICHIER', AListeFichiers.Names[iFichier2]+'-GENSTOCK', []) then
            if(Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt < iLastVersionStk) or (iLastVersionStk = -1) then
              iLastVersionStk := Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt;
        end;
      end;

      try
        with Que_Tmp do
          begin
            Close();
            SQL.Clear();

            SQL.Add('SELECT CODE_ARTICLE, ID_SEUIL, LIB_SEUIL, QTE_STOCK,'+IntToStr(iExtractMagId)+' MAG_ID, QTE_SEUIL, ETAT_DATA, CODE_EAN, QTE_PREVENTE');
            SQL.Add('FROM SYNCWEB_STOCK_2_IDMAG(:ASSID, :LAST_VERSION_STK, :CURRENT_VERSION_STK, :LAST_VERSION_ART, :CURRENT_VERSION_ART, ');
            SQL.Add('     :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE, :MAGID, :CUMULID)');


            if not(bInitialisation) then
            begin
              if(iLastVersionArt <> 0) then
                ParamByName('LAST_VERSION_ART').AsLargeInt   := iLastVersionArt
              else
                ParamByName('LAST_VERSION_ART').AsLargeInt   := iLastVersion;
              ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
              ParamByName('LAST_VERSION_STK').AsLargeInt     := iLastVersionStk;
            end
            else
            begin
              SQL.Add(' WHERE ETAT_DATA = 1');
              ParamByName('LAST_VERSION_ART').AsLargeInt := Dm_Common.PlageBase.Debut;
              ParamByName('LAST_VERSION_LAME').AsLargeInt    := Dm_Common.PlageLame.Debut;
              ParamByName('LAST_VERSION_STK').AsLargeInt     := 0;
            end;

            ParamByName('CURRENT_VERSION_ART').AsLargeInt  := ACurrentVersionArt;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('CURRENT_VERSION_STK').AsLargeInt  := ACurrentVersionStk;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
            ParamByName('ASSID').AsInteger                := MySiteParams.iAssID;
            ParamByName('MAGID').AsInteger            := iExtractMagId;
            ParamByName('CUMULID').AsInteger          := iCumulMagId;
            Open;

          end;
          if iFichier > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sSTOCK_2_%d%s.TXT', [sCheminCsv, iExtractMagId, sDatePourFic]), 'QTE_PREVENTE, CODE_EAN', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersionArt,ACurrentVersionLame, ACurrentVersionStk, AListeFichiers.Names[iFichier], iExtractMagId);
              except
                on E: Exception do
                  raise Exception.Create(Format('STOCK_2_%d.TXT -> %s', [iExtractMagId,  E.Message]));
              end;
            end;
          end;
          if iFichier2 > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + ReplaceStr(AListeFichiers.Names[iFichier2], 'IDMAG', IntToStr(iExtractMagId))]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sSTOCK_3_%d%s.TXT', [sCheminCsv, iExtractMagId, sDatePourFic]), '', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersionArt,ACurrentVersionLame, ACurrentVersionStk, AListeFichiers.Names[iFichier2], iExtractMagId);
              except
                on E: Exception do
                  raise Exception.Create(Format('STOCK_3_%d.TXT -> %s', [iExtractMagId,  E.Message]));
              end;
            end;
          end;
      except
        on E: Exception do
            raise Exception.Create('STOCK_2_IDMAG.txt / STOCK_3_IDMAG.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier STOCK_2_IDMAG / STOCK_3_IDMAG'}

    {$REGION 'Génération du fichier STOCK_4'}
    iFichier  := AListeFichiers.IndexOfName('STOCK_4.TXT');

    if(iFichier > -1) then
    begin
      GetLastVersions(AListeFichiers,[iFichier],iLastVersionArt, iLastVersionLame);
      iLastVersionStk := 0;
      if not bInitialisation then
      begin
        iLastVersionStk := -1;
        if iFichier > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_FICHIER', AListeFichiers.Names[iFichier]+'-GENSTOCK', []) then
            iLastVersionStk := Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt;
        end;
      end;

      try
        with Que_Tmp do
          begin
            Close();
            SQL.Clear();

            SQL.Add('SELECT CODE_ARTICLE, ID_SEUIL, LIB_SEUIL, QTE_STOCK, MAG_ID, QTE_SEUIL, ETAT_DATA, CODE_EAN, QTE_PREVENTE');
            SQL.Add('FROM SYNCWEB_STOCK_4(:ASSID, :LAST_VERSION_STK, :CURRENT_VERSION_STK, :LAST_VERSION_ART, :CURRENT_VERSION_ART, ');
            SQL.Add('     :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE)');


            if not(bInitialisation) then
            begin
              if(iLastVersionArt <> 0) then
                ParamByName('LAST_VERSION_ART').AsLargeInt   := iLastVersionArt
              else
                ParamByName('LAST_VERSION_ART').AsLargeInt   := iLastVersion;
              ParamByName('LAST_VERSION_LAME').AsLargeInt    := iLastVersionLame;
              ParamByName('LAST_VERSION_STK').AsLargeInt     := iLastVersionStk;
            end
            else
            begin
              SQL.Add(' WHERE ETAT_DATA = 1');
              ParamByName('LAST_VERSION_ART').AsLargeInt := Dm_Common.PlageBase.Debut;
              ParamByName('LAST_VERSION_LAME').AsLargeInt    := Dm_Common.PlageLame.Debut;
              ParamByName('LAST_VERSION_STK').AsLargeInt     := 0;
            end;

            ParamByName('CURRENT_VERSION_ART').AsLargeInt  := ACurrentVersionArt;
            ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
            ParamByName('CURRENT_VERSION_STK').AsLargeInt  := ACurrentVersionStk;
            ParamByName('DEBUT_PLAGE_BASE').AsLargeInt     := Dm_Common.PlageBase.Debut;
            ParamByName('FIN_PLAGE_BASE').AsLargeInt       := Dm_Common.PlageBase.Fin;
            ParamByName('ASSID').AsInteger                := MySiteParams.iAssID;

            Open;

          end;
          if iFichier > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, Format('%sSTOCK_4%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
                Application.ProcessMessages();
                MajDate(ACurrentVersionArt,ACurrentVersionLame, ACurrentVersionStk, AListeFichiers.Names[iFichier], iExtractMagId);
              except
                on E: Exception do
                  raise Exception.Create('STOCK_4.txt -> ' + E.Message);
              end;
            end;
          end;
      except
        on E: Exception do
            raise Exception.Create('STOCK_4.txt -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération du fichier STOCK_4'}

    {$REGION 'Génération du fichier STOCK_5'}
    iFichier  := AListeFichiers.IndexOfName('STOCK_5.TXT');

    if(iFichier > -1) then
    begin
      GetLastVersions(AListeFichiers, [iFichier], iLastVersionArt, iLastVersionLame);
      iLastVersionStk := 0;
      if not bInitialisation then
      begin
        iLastVersionStk := -1;
        if iFichier > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_FICHIER', AListeFichiers.Names[iFichier] + '-GENSTOCK', []) then
            iLastVersionStk := Que_GetArtExportWeb.FieldByName('AWE_LASTVERSION').AsLargeInt;
        end;
      end;

      try
        Que_Tmp.Close;
        Que_Tmp.SQL.Clear;
        Que_Tmp.SQL.Add('select CODE_ARTICLE, ID_SEUIL, LIB_SEUIL, QTE_STOCK, MAG_ID, QTE_SEUIL, ETAT_DATA, CODE_EAN, QTE_PREVENTE');
        Que_Tmp.SQL.Add('from SYNCWEB_STOCK_5(:ASSID, :LAST_VERSION_STK, :CURRENT_VERSION_STK, :LAST_VERSION_ART, :CURRENT_VERSION_ART,');
        Que_Tmp.SQL.Add(':LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, :FIN_PLAGE_BASE)');

        if not bInitialisation then
        begin
          if iLastVersionArt <> 0 then
            Que_Tmp.ParamByName('LAST_VERSION_ART').AsLargeInt := iLastVersionArt
          else
            Que_Tmp.ParamByName('LAST_VERSION_ART').AsLargeInt := iLastVersion;
          Que_Tmp.ParamByName('LAST_VERSION_LAME').AsLargeInt := iLastVersionLame;
          Que_Tmp.ParamByName('LAST_VERSION_STK').AsLargeInt := iLastVersionStk;
        end
        else
        begin
          Que_Tmp.SQL.Add('where ETAT_DATA = 1');
          Que_Tmp.ParamByName('LAST_VERSION_ART').AsLargeInt := Dm_Common.PlageBase.Debut;
          Que_Tmp.ParamByName('LAST_VERSION_LAME').AsLargeInt := Dm_Common.PlageLame.Debut;
          Que_Tmp.ParamByName('LAST_VERSION_STK').AsLargeInt := 0;
        end;
        Que_Tmp.ParamByName('CURRENT_VERSION_ART').AsLargeInt  := ACurrentVersionArt;
        Que_Tmp.ParamByName('CURRENT_VERSION_LAME').AsLargeInt := ACurrentVersionLame;
        Que_Tmp.ParamByName('CURRENT_VERSION_STK').AsLargeInt := ACurrentVersionStk;
        Que_Tmp.ParamByName('DEBUT_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Debut;
        Que_Tmp.ParamByName('FIN_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Fin;
        Que_Tmp.ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
        Que_Tmp.Open;

        if iFichier > -1 then
        begin
          if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
          begin
            try
              LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
              Application.ProcessMessages;
              DoCsv(Que_Tmp, Format('%sSTOCK_5%s.TXT', [sCheminCsv, sDatePourFic]), '', '', True);
              Application.ProcessMessages;
              MajDate(ACurrentVersionArt, ACurrentVersionLame, ACurrentVersionStk, AListeFichiers.Names[iFichier], iExtractMagId);
            except
              on E: Exception do
                raise Exception.Create('STOCK_5.txt -> ' + E.Message);
            end;
          end;
        end;
      except
        on E: Exception do
            raise Exception.Create('STOCK_5.txt -> ' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Génération du fichier STOCKLOT_2_IDMAG'}
    iFichier  := AListeFichiers.IndexOfName('STOCKLOT_2_IDMAG.TXT');
    if iFichier > -1 then
    begin
      if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
      begin
        try
          //LogAction(Format(MessCreationFichier, [IfThen(bInitialisation, 'INIT_', '') + ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
          LogAction(Format(MessCreationFichier, [ReplaceStr(AListeFichiers.Names[iFichier], 'IDMAG', IntToStr(iExtractMagId))]), 3);
          with Que_Tmp do
          begin
            Close();
            SQL.Clear();

            SQL.Add('SELECT CODE_LOT, ID_SEUIL, LIB_SEUIL, CODE_LIGNE, CB_ARTICLE, QTE_STOCK STOCK_ARTICLE,');
            SQL.Add(IntToStr(iExtractMagId)+' MAG_ID, QTE_SEUIL, ETAT_DATA, QTE_PREVENTE, CODE_EAN');
            SQL.Add('FROM SYNCWEB_STOCKLOT_2_IDMAG(:MAGID, :CUMULID, :ASSID, :LAST_VERSION, :CURRENT_VERSION)');
            SQL.Add('WHERE ETAT_DATA = 1');
            ParamByName('MAGID').AsInteger            := iExtractMagId;
            ParamByName('CUMULID').AsInteger          := iCumulMagId;
            ParamByName('ASSID').AsInteger            := MySiteParams.iAssID;
            ParamByName('CURRENT_VERSION').AsLargeInt  := ACurrentVersionStk;

            // MD - 2015-10-29 - pas de delta sur les lots car fonctionnement incomplet .
            // changement suite à passage sur AGR_ID mais ne renvoie le fichier que sur modification du stock
            // et pas sur modification du lot (ajout / suppression d'article)
            //if not(bInitialisation) then
            //begin
            //    ParamByName('LAST_VERSION').AsLargeInt := iLastVersionFile;
            //end
            //else
            //begin
              ParamByName('LAST_VERSION').AsLargeInt   := 0;
            //end;

            Open();
          end;

          Application.ProcessMessages();
          //DoCsv(Que_Tmp, Format('%sSTOCKLOT_2_%d%s.TXT', [sCheminCsv, iExtractMagId, sDatePourFic]), 'ETAT_DATA', '', True);
          DoCsv(Que_Tmp, Format('%sSTOCKLOT_2_%d.TXT', [GGENPATHCSV,iExtractMagId]), 'ETAT_DATA');
          Application.ProcessMessages();
          MajDate(AListeFichiers.Names[iFichier],ACurrentVersionStk);
        except
          on E: Exception do
            raise Exception.Create(Format('STOCKLOT_2_%d.TXT -> %s', [iExtractMagId,  E.Message]));
        end;
      end;
    end;
    {$ENDREGION 'Génération du fichier STOCKLOT_2_IDMAG'}

    {$REGION 'Génération des fichiers RAL_IDMAG / RAL_2_IDMAG'}
    iFichier  := AListeFichiers.IndexOfName('RAL_IDMAG.TXT');
    iFichier2  := AListeFichiers.IndexOfName('RAL_2_IDMAG.TXT');

    if(iFichier > -1) or (iFichier2 > -1) then
    begin
      try
        with Que_Tmp do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT CBI1.CBI_CB CODE_ARTICLE,');
            SQL.Add('       CDL_LIVRAISON DATE_LIVRAISON,');
            SQL.Add('       RAL_QTE QUANTITE,');
            SQL.Add('       CBI2.CBI_CB CODE_EAN');
            SQL.Add('FROM AGRRAL');
            SQL.Add('  JOIN COMBCDEL ON (CDL_ID = RAL_CDLID)');
            SQL.Add('  JOIN K KCDL ON (KCDL.K_ID = CDL_ID AND KCDL.K_ENABLED = 1)');
            SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = CDL_ARTID)');
            SQL.Add('  JOIN ARTCODEBARRE CBI1 ON (CBI1.CBI_ARFID = ARF_ID AND CBI1.CBI_TGFID = CDL_TGFID AND CBI1.CBI_COUID = CDL_COUID AND CBI1.CBI_TYPE = 1)');
            SQL.Add('  JOIN K KCBI ON (KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1)');
            SQL.Add('  LEFT JOIN ARTCODEBARRE CBI2 ON (CBI2.CBI_ARFID = ARF_ID AND CBI2.CBI_TGFID = CDL_TGFID AND CBI2.CBI_COUID = CDL_COUID AND CBI2.CBI_TYPE = 3 AND CBI2.CBI_PRIN = 1)');
            SQL.Add('  JOIN ARTWEB ON ARW_ARTID = ARF_ARTID AND ARW_WEB = 1');
            SQL.Add('  JOIN ARTQUELSITE  ON (ARW_ID = AQS_ARWID)');
            SQL.Add('  JOIN ARTDISPOWEB ON ADW_ARTID = ARF_ARTID AND ADW_TGFID = CDL_TGFID AND ADW_COUID = CDL_COUID AND ADW_DISPO = 1');
            SQL.Add('WHERE (AQS_ASSID = :ASSID) AND (AQS_SUPPR = ''1899-12-30'' OR AQS_SUPPR IS NULL)');
            ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
            Open;
          end;
          if iFichier > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier]]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, GGENPATHCSV + 'RAL_' + IntToStr(iExtractMagId) + '.TXT','CODE_EAN');
                Application.ProcessMessages();
                MajDate(AListeFichiers.Names[iFichier],ACurrentVersionStk);
              except
                on E: Exception do
                  raise Exception.Create('RAL_IDMAG.TXT -> ' + E.Message);
              end;
            end;
          end;

          if iFichier2 > -1 then
          begin
            if Que_GetArtExportWeb.Locate('AWE_ID', AListeFichiers.ValueFromIndex[iFichier2], []) then
            begin
              try
                LogAction(Format(MessCreationFichier, [AListeFichiers.Names[iFichier2]]), 3);
                Application.ProcessMessages();
                DoCsv(Que_Tmp, GGENPATHCSV + 'RAL_2_' + IntToStr(iExtractMagId) + '.TXT');
                Application.ProcessMessages();
                MajDate(AListeFichiers.Names[iFichier2],ACurrentVersionStk);
              except
                on E: Exception do
                  raise Exception.Create('RAL_2_IDMAG.TXT -> ' + E.Message);
              end;
            end;
          end;
      except
        on E: Exception do
          raise Exception.Create('RAL_IDMAG.TXT / RAL_2_IDMAG.TXT -> ' + E.Message);
      end;
    end;
    {$ENDREGION 'Génération des fichiers RAL_IDMAG / RAL_2_IDMAG'}

    Result := True;
  except on E: Exception do
    begin
      LogAction('Erreur lors de la génération des csv : ' + E.Message, 1);
    end;
  end;
end;

function TailleFichier(const sFichier: String): Cardinal;
var
  hFile: THandle;
begin
  Result := 0;
  hFile := CreateFile(PWideChar(sFichier), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  try
    if hFile <> INVALID_HANDLE_VALUE then
      Result := GetFileSize(hFile, nil);
  finally
    CloseHandle(hFile);
  end;
end;

function DoCsv(DataSet: TDataSet; sFileName: string; AFilter: String=''; AChampUnique: String = ''; AFichierDelta: Boolean = False): Boolean;
var
  Header: TExportHeaderOL;
  i: integer;
  FLNC: TextFile;
  CountLn: Integer;
begin
  Result := True;
  Header := TExportHeaderOL.Create;
  Header.bAlign := False; // Pas de gestion de la taille des champs
  Header.bWriteHeader := True;
  // Met en première ligne la liste des noms des champs
  Header.Separator := ';'; // séparateur de champs
  // Spécifie quel champ doit être unique
  Header.sChampUnique := AChampUnique;
  try
    if FileExists(sFileName) then
      DeleteFile(PChar(sFileName));

    // On ajoute la liste des champs que l'on va devoir traiter pour le CSV
    for i := 0 to Dataset.FieldCount - 1 do
    begin
      if Pos(Dataset.Fields[i].FieldName,Afilter)=0 then
      begin
        Header.Add(Dataset.Fields[i].FieldName);
      end;
    end;

    try
      // On génère le CSV avec la source de données que l'on a
      Header.OldStr := ';';
      Header.NewStr := ',';
      Header.ConvertToCsv(DataSet, sFileName);

      // On vérifie si on n'a pas eu d'erreur d'unicité
      if Header.bErreurUnicite then
      begin
        if pos('ARTWEB',sFileName) > 0 then
        begin
          LogAction(Format('Des erreurs d''unicité ont eu lieu lors de l''export du fichier %s.',[ExtractFileName(sFileName)]), 0);
          LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
          LogAction('Tentative de résolution des problèmes de doublons lancée', 0);
          //on execute la procedure de suppression des doublons dans ARTDISPOWEB
          DoublonADW;
          DataSet.Close;
          DataSet.Open;
          //on relance l'exécution pour voir
          Header.ConvertToCsv(DataSet, sFileName);
          if Header.bErreurUnicite then
          begin
            LogAction('La résolution ne semble pas être complète. Des lignes n''ont pas été prisent en compte.', 0);
            LogAction('Merci de contacter le service client de Ginkoia afin de corriger les informations en double.', 0);
            LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
          end
          else
          begin
            LogAction('Les doublons ont été supprimés. L''erreur ne devrait plus apparaitre', 0);
          end;
        end
        else
        begin
          LogAction(Format('Des erreurs d''unicité ont eu lieu lors de l''export du fichier %s. Des lignes n''ont pas été prisent en compte.', [ExtractFileName(sFileName)]), 0);
          LogAction('Merci de contacter le service client de Ginkoia afin de corriger les informations en double.', 0);
          LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
        end;
      end;
    except
      on E: Exception do
      begin
        LogAction('Erreur lors de la génération du Csv : ' +
          ExtractFileName(sFileName), 1);
        LogAction(E.Message, 1);
        Result := False;
        Exit;
      end;
    end;
  finally
    Header.Free;
  end;

  //SR - 12/06/2015 - Si le fichier est vide et qu'il s'agit d'un fichier Delta on le supprime.
  if AFichierDelta then
  begin
    CountLn := 0;
    AssignFile(FLNC, sFileName);
    Reset(FLNC);
    try
      while not Eof(FLNC) do
      begin
        Inc(CountLn);
        Readln(FLNC);
      end;
    finally
      CloseFile(FLNC);
    end;
    if CountLn <= 1 then
    begin
      // Suppression du fichier inutile.
      if DeleteFileW(PWideChar(sFileName)) then
        LogAction(Format(MessFichierNonCree, [ExtractFileName(sFileName)]), 3)
      else
        LogAction(Format(MessFichierNonCreeErreur, [ExtractFileName(sFileName), SysErrorMessage(GetLastError)]), 3);
    end
    else
      LogAction(Format(MessFichierCree,[ExtractFileName(sFileName)]), 3);
  end
  else
    LogAction(Format(MessFichierCree,[ExtractFileName(sFileName)]), 3);

  // Si fichier vide.
  if(FileExists(sFileName)) and (TailleFichier(sFileName) = 0) then
  begin
    // Suppression du fichier vide.
    if DeleteFileW(PWideChar(sFileName)) then
      LogAction(Format(MessFichierNonCree, [ExtractFileName(sFileName)]), 3)
    else
      LogAction(Format(MessFichierNonCreeErreur, [ExtractFileName(sFileName), SysErrorMessage(GetLastError)]), 3);
  end;
end;

function DoCsv(DataSet: TDataSet; sFileName: string; AFilter: TStringList; AChampUnique: String = ''; AFichierDelta: Boolean = False): Boolean;
var
  Header: TExportHeaderOL;
  i: integer;
  FLNC: TextFile;
  CountLn: Integer;
begin
  Result := True;
  Header := TExportHeaderOL.Create;
  Header.bAlign := False; // Pas de gestion de la taille des champs
  Header.bWriteHeader := True;
  // Met en première ligne la liste des noms des champs
  Header.Separator := ';'; // séparateur de champs
  // Spécifie quel champ doit être unique
  Header.sChampUnique := AChampUnique;
  try
    if FileExists(sFileName) then
      DeleteFile(PChar(sFileName));

    // On ajoute la liste des champs que l'on va devoir traiter pour le CSV
    for i := 0 to Dataset.FieldCount - 1 do
    begin
      if (AFilter.IndexOf(Dataset.Fields[i].FieldName) = -1) then
      begin
        Header.Add(Dataset.Fields[i].FieldName);
      end;
    end;

    try
      // On génère le CSV avec la source de données que l'on a
      Header.OldStr := ';';
      Header.NewStr := ',';
      Header.ConvertToCsv(DataSet, sFileName);

      // On vérifie si on n'a pas eu d'erreur d'unicité
      if Header.bErreurUnicite then
      begin
        if pos('ARTWEB',sFileName) > 0 then
        begin
          LogAction(Format('Des erreurs d''unicité ont eu lieu lors de l''export du fichier %s.',[ExtractFileName(sFileName)]), 0);
          LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
          LogAction('Tentative de résolution des problèmes de doublons lancée', 0);
          //on execute la procedure de suppression des doublons dans ARTDISPOWEB
          DoublonADW;
          DataSet.Close;
          DataSet.Open;
          //on relance l'exécution pour voir
          Header.ConvertToCsv(DataSet, sFileName);
          if Header.bErreurUnicite then
          begin
            LogAction('La résolution ne semble pas être complète. Des lignes n''ont pas été prisent en compte.', 0);
            LogAction('Merci de contacter le service client de Ginkoia afin de corriger les informations en double.', 0);
            LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
          end
          else
          begin
            LogAction('Les doublons ont été supprimés. L''erreur ne devrait plus apparaitre', 0);
          end;
        end
        else
        begin
          LogAction(Format('Des erreurs d''unicité ont eu lieu lors de l''export du fichier %s. Des lignes n''ont pas été prisent en compte.', [ExtractFileName(sFileName)]), 0);
          LogAction('Merci de contacter le service client de Ginkoia afin de corriger les informations en double.', 0);
          LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
        end;
      end;
    except
      on E: Exception do
      begin
        LogAction('Erreur lors de la génération du Csv : ' +
          ExtractFileName(sFileName), 1);
        LogAction(E.Message, 1);
        Result := False;
        Exit;
      end;
    end;
  finally
    Header.Free;
  end;

  //SR - 12/06/2015 - Si le fichier est vide et qu'il s'agit d'un fichier Delta on le supprime.
  if AFichierDelta then
  begin
    CountLn := 0;
    AssignFile(FLNC, sFileName);
    Reset(FLNC);
    try
      while not Eof(FLNC) do
      begin
        Inc(CountLn);
        Readln(FLNC);
      end;
    finally
      CloseFile(FLNC);
    end;
    if CountLn <= 1 then
    begin
      // Suppression du fichier inutile.
      if DeleteFileW(PWideChar(sFileName)) then
        LogAction(Format(MessFichierNonCree,[ExtractFileName(sFileName)]), 3)
      else
        LogAction(Format(MessFichierNonCreeErreur, [ExtractFileName(sFileName), SysErrorMessage(GetLastError)]), 3);
    end
    else
      LogAction(Format(MessFichierCree,[ExtractFileName(sFileName)]), 3);
  end
  else
    LogAction(Format(MessFichierCree,[ExtractFileName(sFileName)]), 3);

  // Si fichier vide.
  if(FileExists(sFileName)) and (TailleFichier(sFileName) = 0) then
  begin
    // Suppression du fichier vide.
    if DeleteFileW(PWideChar(sFileName)) then
      LogAction(Format(MessFichierNonCree, [ExtractFileName(sFileName)]), 3)
    else
      LogAction(Format(MessFichierNonCreeErreur, [ExtractFileName(sFileName), SysErrorMessage(GetLastError)]), 3);
  end;
end;

function DoGenCde: Boolean;
var
  FTPCde: TFTPData;
  i: Integer;
  TabArticles: TTabArticles;
  Cde: TCde;
  sArchPath, sErreurPath: String;
begin
  Result := True;
  try
    // Récupération des commandes sur le FTP
    try
      with Dm_Common, FTPCde do
      begin
        FTPCde := MySiteParams.FTPGenGet;
        SavePath := GGENPATHCDE;
        FileFilter := '*.xml';
        SourcePath := GGENTMPPATH;
        FileList := TStringList.Create;
      end;

      sArchPath := GGENARCHCDE + FormatDateTime('YYYY\MM\DD\', Now);
      if not DirectoryExists(sArchPath) then
        ForceDirectories(sArchPath);

      sErreurPath := GGENARCHCDE + 'Erreur\';
      if not DirectoryExists(sErreurPath) then
        ForceDirectories(sErreurPath);

      if not(FTPCde.SFTP) then
      begin
        {$REGION 'Connexion au FTP'}
        if GenFTPConnection(FTPCde) then
        try
          // récupération des fichiers
          if GenFTPDownloadFile(FTPCde) then
          begin
            if (not Assigned(FTPCDE.FileList)) or (FTPCDE.FileList.Count = 0) then
            begin
              LogAction('Aucune commande à traiter', 3);
            end
            else
            begin
              FTPCde.FileList.CaseSensitive := false;
              FTPCde.FileList.Sort;
              for i := 0 to Pred(FTPCDE.FileList.Count) do
              begin
                if LowerCase(RightStr(FTPCDE.FileList[i], 4)) = LowerCase(RightStr(FTPCDE.FileFilter, 4)) then
                begin
                  // Si fichier article.
                  if UpperCase(LeftStr(FTPCDE.FileList[i], 4)) = 'ART_' then
                  begin
                    // Chargement du fichier XML.
                    try
                      TabArticles := XMLArticlesToRecord(GGENPATHCDE + FTPCDE.FileList[i]);
                    except
                      on E: Exception do
                      begin
                        LogAction('Erreur de traitement du fichier Article '+FTPCDE.FileList[i], 0);
                        LogAction(E.Message, 0);

                        AddMonitoring('Erreur de traitement du fichier Article '+FTPCDE.FileList[i],
                          logError, mdltImport, apptSyncWeb, Dm_Common.MySiteParams.iMagID);
                      end;
                    end;

                    if Length(TabArticles) > 0 then
                    begin
                      // Création des articles qui n'existent pas.
                      try
                        if ArticlesToDB(TabArticles) then
                        begin
                          LogAction('Traitement fichier article [' + FTPCDE.FileList[i] + '].', 3);

                          // Archivage du fichier.
                          if not MoveFile(PChar(GGENPATHCDE + FTPCDE.FileList[i]), PChar(sArchPath + FormatDateTime('YYYY-MM-DD-hhmmssnn_', Now) + ExtractFileName(FTPCDE.FileList[i]))) then
                            LogAction('[DoGenCde]  Erreur d''archivage de [' + FTPCDE.FileList[i] + ']' + #13#10 + SysErrorMessage(GetLastError), 1);
                        end
                        else
                        begin
                          // Archivage en erreur du fichier.
                          if not(RenameFile(GGENPATHCDE + FTPCDE.FileList[i], sErreurPath + FormatDateTime('YYYY-MM-DD hhnnss zzz_', Now) + ExtractFileName(FTPCDE.FileList[i]))) then
                            LogAction('[DoGenCde]  Erreur d''archivage en erreur de [' + FTPCDE.FileList[i] + ']' + #13#10 + SysErrorMessage(GetLastError), 1);
                        end;
                      except
                        on E: Exception do
                        begin
                          LogAction(E.Message, 0);
                          AddMonitoring(E.Message, logError, mdltImport,
                            apptSyncWeb, Dm_Common.MySiteParams.iMagID);
                        end;
                      end;
                    end
                    else
                    begin
                      // Archivage en erreur du fichier.
                      if not(RenameFile(GGENPATHCDE + FTPCDE.FileList[i], sErreurPath + FormatDateTime('YYYY-MM-DD hhnnss zzz_', Now) + ExtractFileName(FTPCDE.FileList[i]))) then
                        LogAction('[DoGenCde]  Erreur d''archivage en erreur de [' + FTPCDE.FileList[i] + ']' + #13#10 + SysErrorMessage(GetLastError), 1);
                    end;
                  end
                  else      // Enregistrement des commandes dans ginkoia
                  begin
                    try
                      Cde := DoXmlGenToRecord(GGENPATHCDE + FTPCDE.FileList[i]);
                    except
                      on E: Exception do
                      begin
                        LogAction(E.Message, 0);
                        Cde.bValid := False;

                        AddMonitoring(E.Message, logError, mdltImport, apptSyncWeb,
                          Dm_Common.MySiteParams.iMagID);
                      end;
                    end;

                    // fichier valide
                    if Cde.bValid then
                    begin
                      try
                        DoGenCdeToDb(Cde);
                        LogAction('Commande traitée [' + FTPCDE.FileList[i] + '].', 3);
                      except
                        on E: Exception do
                        begin
                          LogAction('Fichier: ' + FTPCDE.FileList[i] + ' :  ' + E.Message, 0);
                          Cde.bValid := False;

                          AddMonitoring('Fichier: ' + FTPCDE.FileList[i] + ' :  ' + E.Message,
                            logError, mdltImport, apptSyncWeb, Dm_Common.MySiteParams.iMagID);
                        end;
                      end;
                    end;

                    // archivage
                    if Cde.bValid then
                    begin
                      // Archivage du fichier
                      if not MoveFile(PChar(GGENPATHCDE + FTPCDE.FileList[i]),
                        PChar(sArchPath + FormatDateTime('YYYY-MM-DD-hhmmssnn_', Now)
                        + ExtractFileName(FTPCDE.FileList[i]))) then
                        LogAction('DoGenCde Problème d''archivage de ' +
                          FTPCDE.FileList[i], 1);
                    end
                    else      // en erreur
                    begin
                      // les log en 0 font le reste
                      if not(RenameFile(GGENPATHCDE + FTPCDE.FileList[i],
                                        sErreurPath + FormatDateTime('YYYY-MM-DD hhnnss zzz_', Now)
                                                    + ExtractFileName(FTPCDE.FileList[i]))) then
                        LogAction('DoGenCde Problème d''archivage en erreur de ' +
                          FTPCDE.FileList[i], 1);
                    end;
                  end;
                end;
              end;
            end;
          end;
        finally
          GenFTPClose;
        end;
        {$ENDREGION 'Connexion au FTP'}
      end
      else
      begin
        {$REGION 'Connexion au SFTP'}
        if GenSFTPConnection(FTPCde) then
        try
          // récupération des fichiers
          if GenSFTPDownloadFile(FTPCde) then
          begin
            // Enregistrement des commandes dans ginkoia
            if Assigned(FTPCDE.FileList) then
            begin
              for i := 0 to FTPCDE.FileList.Count - 1 do
                if (RightStr(FTPCDE.FileList[i], 4) = RightStr(FTPCDE.FileFilter, 4)) then
                begin

                  try
                    Cde := DoXmlGenToRecord(GGENPATHCDE + FTPCDE.FileList[i]);
                  except
                    on E:Exception do
                    begin
                      LogAction(E.Message,0);
                      Cde.bValid:=false;

                      AddMonitoring(E.Message, logError, mdltImport, apptSyncWeb,
                        Dm_Common.MySiteParams.iMagID);
                    end;
                  end;

                  if Cde.bValid then //fichier valide
                  begin
                    try
                      DoGenCdeToDb(Cde);
                    except
                      on E:Exception do
                      begin
                        LogAction('Fichier: '+FTPCDE.FileList[i]+' : '+E.Message,0);
                        Cde.bValid:=false;

                        AddMonitoring('Fichier: '+FTPCDE.FileList[i]+' : '+E.Message,
                          logError, mdltImport, apptSyncWeb, Dm_Common.MySiteParams.iMagID);
                      end;
                    end;
                  end;

                  if Cde.bValid then  //archivage
                  begin
                    // Archivage du fichier
                    if not MoveFile(PChar(GGENPATHCDE + FTPCDE.FileList[i]),
                      PChar(sArchPath + FormatDateTime('YYYY-MM-DD-hhmmssnn_', Now)
                      + ExtractFileName(FTPCDE.FileList[i]))) then
                      LogAction('DoGenCde Problème d''archivage de ' +
                        FTPCDE.FileList[i], 1);
                  end
                  else
                  begin //en erreur
                    //les log en 0 font le reste
                    if not(RenameFile(GGENPATHCDE + FTPCDE.FileList[i],
                                      sErreurPath + FormatDateTime('YYYY-MM-DD hhnnss zzz_', Now)
                                                  + ExtractFileName(FTPCDE.FileList[i]))) then
                      LogAction('DoGenCde Problème d''archivage en erreur de ' +
                        FTPCDE.FileList[i], 1);
                  end;
                end;
            end;
          end;
        finally
          GenSFTPClose();
        end;
        {$ENDREGION 'Connexion au SFTP'}
      end;
    finally
      FTPCde.FileList.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('DoCde -> ' + E.Message);
  end;
end;

{$REGION 'Méthodes pour le FTP'}
function GenFTPConnection(FTPCfg: TFTPData): Boolean;
var
  i: Integer;
  lst: TStringList;
begin
  Result := False;
  with Dm_Common do
  try
    // On annule toute action du FTP et on coupe la connection s'il est encore connecté
    GenFTPClose;

    // configuration du FTP
    if Trim(FTPCfg.Host) = '' then
      Exit;

    FTP.Address         := FTPCfg.Host;
    FTP.Username        := FTPCfg.User;
    FTP.Password        := FTPCfg.Psw;
    FTP.Port            := FTPCfg.Port;
    FTP.PassiveMode     := True;
    FTP.SocketTimeout   := MyIniParams.iConnect; // (3s)
//    ReadTimeout     := MyIniParams.iTransfer;
//    ReadTimeout     := MyIniParams.iRead;
    FTP.Open;

    if FTP.Active then
    begin
      FTP.Login;
      if Trim(FTPCfg.FTPDirectory) <> '' then
      begin
        // On va se positionner dans le répertoire de traitement du FTP
        lst := TStringList.Create;
        try
          lst.Text := StringReplace(FTPCfg.FTPDirectory, '/', #13#10, [rfReplaceAll]);
          for i := 0 to Lst.Count - 1 do
            if Trim(lst[i]) <> '' then
              FTP.Cwd(Trim(lst[i]));
        finally
          lst.Free;
        end;
      end;

      Result := True;
    end;
  except
    on E: Exception do
    begin
      LogAction('Erreur de connection FTP -> ' + FTPCfg.Host + ' : ' +
        E.Message, 0);
      raise Exception.Create('GenFTPConnection -> ' + E.Message);
    end;
  end;
end;

function GenFTPDownloadFile(FTPCfg: TFTPData): Boolean;
var
  i: integer;
//  lst: TStringList;
  iTry: Integer;
  bGet: Boolean;
  bDelete: Boolean;
  vListeFichiers: TList;
begin
  Result := False;
  with Dm_Common do
  try
    try
//      FTP.ReadTimeout     := 5000;
//      FTP.TransferTimeout := 5000;
      vListeFichiers := TList.Create();
      try
        FTP.ListDirectory(FTPCfg.FTPDirectory, vListeFichiers, FTPCfg.FileFilter, False, True, False);

        FTPCfg.FileList.Clear();
        for i := 0 to vListeFichiers.Count - 1 do
        begin
          FTPCfg.FileList.Add(TElFTPFileInfo(vListeFichiers[i]).Name);
        end;
      finally
        vListeFichiers.Free();
      end;
    except on E:Exception do
      begin
        LogAction('Erreur lors de la récupération de la liste des commandes', 2);
        LogAction(E.Message,2);
        exit;
      end;
    end;
    FTPCfg.FileList.text := StringReplace(FTPCfg.FileList.text, ';', #13#10,
      [rfReplaceAll]);
    for i := FTPCfg.FileList.Count - 1 downto 0 do
      if Pos('=', FTPCfg.FileList[i]) > 0 then
        FTPCfg.FileList.Delete(i)
      else
        FTPCfg.FileList[i] := Trim(FTPCfg.FileList[i]);

    for i := 0 to FTPCfg.FileList.Count - 1 do
    begin
      bGet := False;
      bDelete := False;
      iTry := 0;
      if ( UpperCase(RightStr(FTPCfg.FileList[i], 4)) = UpperCase(RightStr(FTPCfg.FileFilter, 4)) ) then
        while not bGet and not bDelete and (iTry < 3) do
        begin
          try
            FTP.DownloadFile(FTPCfg.FileList[i], FTPCfg.SavePath + FTPCfg.FileList[i], ftmOverwrite);
            if FTPCfg.bDeleteFile then
              FTP.Delete(FTPCfg.FileList[i]);
            bGet := True;
            bDelete := True;
          except on E: Exception do
            begin
              inc(iTry);
              if iTry >= 3 then
                raise
                  Exception.Create('GenFTPDownloadFile -> Nombre d''essais atteint : ' + E.Message);
              Sleep(500);
            end;
          end;
        end; // while
    end;

    // récupération des fichiers qui n'ont pas été traités et qui sont dans
    // le répertoire
    GetFileListFromDir(FTPCfg.FileList,GGENPATHCDE,'*.xml');

    Result := True;
  except on E: Exception do
    begin
      LogAction('Erreur de récupération des fichiers du FTP -> ' + FTPCfg.Host
        + ' : ' + E.Message, 0);
      raise Exception.Create('GenFTPDownloadFile -> ' + E.Message);
    end;
  end;
end;

function GenFTPUploadFile(FTPCfg: TFTPData): Boolean;
{$REGION 'GenFTPUploadFile'}
  function SupprimerFichier(const aFile: string): boolean;
  var
//    vSize: Int64;
    vDel: Boolean;
    vTry: Integer;
  begin
    // Tentative d'effacer le fichier distant 3 fois de suite
    Result := false;
    vDel := false;
    vTry := 0;
    while(not vDel) and (vTry < 3) do
    begin
      inc(vTry);
      try
        try
          vDel := not Dm_Common.FTP.FileExists(aFile);
          if not vDel then
          begin
            Dm_Common.FTP.Delete(aFile);
            vDel := not Dm_Common.FTP.FileExists(aFile);
          end;
        finally
          if(not vDel) then
            Sleep(500);   //attente d'1/2 seconde entre les essais
        end;
      except
        on E:Exception do
        begin
          LogAction('Tentative de suppression du fichier '''+aFile+''' n° '+IntToStr(vTry)+#13#10+E.Message, 1);
        end;
      end;
    end;
    if(not vDel) then
      LogAction('Impossible de supprimer le fichier distant :  ' + aFile, 1);
    Result := vDel;
  end;

  procedure TransfererFichiers(const aFile, aArchPath: String);
  var
    vSend: Boolean;
    vTry: Integer;
  begin
    SupprimerFichier(aFile);
    SupprimerFichier(aFile+'.transfert');

    // tentative de transferer 3 fois le fichier
    vSend := False;
    vTry := 0;
    while not vSend and (vTry < 3) do
    begin
      Inc(vTry);
      try
        try
          // en envoi en rajoute '.transfert' et on renomme a la fin pour etre sur que le fichier '.txt'
          // est terminé et pas en cours de transfert
          Dm_Common.FTP.UploadFile(FTPCfg.SourcePath + aFile, aFile+'.transfert',ftmOverwrite);
          Dm_Common.FTP.Rename(aFile+'.transfert',aFile);
          vSend := True;
        finally
          if not(vSend) then
            Sleep(500);   //attente d'1/2 seconde entre les essais
        end;
      except
        on E: Exception do
        begin
          LogAction('Tentative d''envoi du fichier '''+aFile+''' n° '+IntToStr(vTry)+#13#10+E.Message, 1);
        end;
      end;
    end;
    // archivage si ok, sinon log
    if vSend then
    begin
      if not ForceDirectories(aArchPath) then
        LogAction('Échec de la création du chemin [' + aArchPath + ']: ' + SysErrorMessage(GetLastError), 1);

      if FileExists(aArchPath + aFile) then
      begin
        if not SysUtils.DeleteFile(aArchPath + aFile) then
          LogAction('Échec de la suppression du fichier [' + aArchPath + aFile + ']: ' + SysErrorMessage(GetLastError), 1);
      end;

      if not MoveFile(PChar(FTPCfg.SourcePath + aFile), PChar(aArchPath + aFile)) then
        LogAction('GenFTPUploadFile Problème d''archivage de [' + aFile + ']: ' + SysErrorMessage(GetLastError), 1);
    end
    else
    begin
      LogAction('Impossible de transférer le fichier :  ' + aFile, 0);
      Result := False;
    end;
  end;
{$ENDREGION}
var
  Rec: TSearchRec;
  i: integer;
  sArchPath: string;
  LstFile, LstStocksRAL: TStringList;
  sFile: String;
begin
  Result := True;  // par défaut ok;
  
  sArchPath := FTPCfg.SourcePath + 'Send\';
  if not DirectoryExists(sArchPath) then
    ForceDirectories(sArchPath);

  LstFile := TStringList.Create;
  LstStocksRAL := TStringList.Create;
  try
    // Liste des fichiers d'un repertoire
    i := FindFirst(FTPCfg.SourcePath + FTPCfg.FileFilter, faAnyFile, Rec);
    while(i = 0) do
    begin
      sFile := ExtractFileName(rec.Name);
      if(sFile <> '.') and (sFile <> '..') and ((Rec.Attr and faDirectory) <> faDirectory) then
      begin
        // Si fichiers RAL ou STOCKS.
        if(ContainsText(sFile, 'RAL.txt')) or (ContainsText(sFile, 'RAL_2.txt')) or (ContainsText(sFile, 'STOCK_')) or (ContainsText(sFile, 'STOCKLOT_')) or (ContainsText(sFile, 'STOCK_2_')) or (ContainsText(sFile, 'STOCKLOT_2_')) then
          LstStocksRAL.Add(sFile)
        else
          LstFile.Add(sFile);
      end;
      i := FindNext(Rec);
    end;
    SysUtils.FindClose(Rec);

    // transfert FTP des fichiers 
    with Dm_Common do
    try
      sArchPath := IncludeTrailingPathDelimiter(sArchPath + IntToStr(YearOf(Now)) + '\' + FormatFloat('00', MonthOf(Now)) + '\' + FormatFloat('00', DayOf(Now)));

      for i := 1 to LstFile.Count do
      begin
        sFile := LstFile[i - 1];
        TransfererFichiers(sFile, sArchPath);
      end;

      if FTPCfg.FTPRepertoireStocksRAL <> '' then
      begin
        // Sous-répertoire pour les fichiers RAL ou STOCKS.
        FTP.Cwd(FTPCfg.FTPRepertoireStocksRAL);
      end;

      for i:=0 to Pred(LstStocksRAL.Count) do
      begin
        sFile := LstStocksRAL[i];
        TransfererFichiers(sFile, sArchPath);
      end;
    except
      on E: Exception do
      begin
        Result := False;
        LogAction('Erreur de transfert des fichiers du FTP -> ' + FTPCfg.Host + ' :  ' + E.Message, 0);
        raise Exception.Create('GenFTPUploadFile -> ' + E.Message);
      end;
    end;
  finally
    LstFile.Free;
    LstStocksRAL.Free;
  end;
end;

procedure GenFTPClose;
begin
  if Dm_Common.FTP.Active then
  begin
    try
      Dm_Common.FTP.Abort;
    finally
      Dm_Common.FTP.Close;
    end;
  end;
end;
{$ENDREGION 'Méthodes pour le FTP'}

{$REGION 'Méthodes pour le SFTP'}
function GenSFTPConnection(SFTPCfg: TFTPData): Boolean;
begin
  Result := False;

  try
    // On annule toute action du SFTP et on coupe la connection s'il est encore connecté
    GenSFTPClose();

    // Configuration du SFTP
    if Trim(SFTPCfg.Host) = '' then
      Exit;

    Dm_Common.SFTP.Address                            := SFTPCfg.Host;
    Dm_Common.SFTP.Username                           := SFTPCfg.User;
    Dm_Common.SFTP.Password                           := SFTPCfg.Psw;
    Dm_Common.SFTP.Port                               := SFTPCfg.Port;
    Dm_Common.SFTP.CompressionAlgorithms[SSH_CA_ZLIB] := True;
    Dm_Common.SFTP.AuthenticationTypes                := Dm_Common.SFTP.AuthenticationTypes and not (SSH_AUTH_TYPE_PUBLICKEY);

    Dm_Common.SFTP.Open();

    if Dm_Common.SFTP.Active then
    begin
      if Trim(SFTPCfg.FTPDirectory) <> '' then
      begin
        // On va se positionner dans le répertoire de traitement du SFTP
        if Dm_Common.SFTP.FileExists(SFTPCfg.FTPDirectory) then
        begin
          HandleSFTP := Dm_Common.SFTP.OpenDirectory(SFTPCfg.FTPDirectory);
          Result := True;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      LogAction(Format('Erreur de connexion SFTP -> %s'#160': %s - %s',
        [SFTPCfg.Host, E.ClassName, E.Message]), 0);
      raise Exception.Create(Format('GenSFTPConnection -> %s - %s', [E.ClassName, E.Message]));
    end;
  end;
end;

function GenSFTPDownloadFile(SFTPCfg: TFTPData): Boolean;
var
  lsFichiers: TList;
  i: Integer;
begin
  Result := False;

  try
    lsFichiers := TList.Create();
    try
      Dm_Common.SFTP.ListDirectory(SFTPCfg.FTPDirectory, lsFichiers, SFTPCfg.FileFilter, False,
        True, False);

      for i := 0 to lsFichiers.Count - 1 do
        SFTPCfg.FileList.Add(TElSftpFileInfo(lsFichiers[i]).Name);
    finally
      lsFichiers.Free();
    end;

    if SFTPCfg.bDeleteFile then
      Dm_Common.SFTP.DownloadFiles(SFTPCfg.FTPDirectory, SFTPCfg.FileFilter, SFTPCfg.SavePath,
        ftmOverwrite, fcmCopyAndDeleteOnCompletion, False, sccNone, False)
    else
      Dm_Common.SFTP.DownloadFiles(SFTPCfg.FTPDirectory, SFTPCfg.FileFilter, SFTPCfg.SavePath,
        ftmOverwrite, fcmCopy, False, sccNone, False);

    // Récupération des fichiers qui n'ont pas été traités et qui sont dans le répertoire
    Result := GetFileListFromDir(SFTPCfg.FileList, GGENPATHCDE, '*.xml');
  except
    on E: Exception do
    begin
      LogAction(Format('Erreur de récupération des fichiers du SFTP -> %s'#160': %s - %s',
        [SFTPCfg.Host, E.ClassName, E.Message]), 0);
      raise Exception.Create(Format('GenSFTPDownloadFile -> %s - %s', [E.ClassName, E.Message]));
    end;
  end;
end;

function GenSFTPUploadFile(SFTPCfg: TFTPData): Boolean;
var
  sArchives: String;
  Recherche: TSearchRec;
  slFichiers: TStringList;
  i: Integer;
begin
  Result := False;

  sArchives := IncludeTrailingPathDelimiter(SFTPCfg.SourcePath + 'Send' + PathDelim
    + FormatDateTime('yyyy' + PathDelim + 'mm' + PathDelim + 'dd', Today()));

  if not DirectoryExists(sArchives) then
    ForceDirectories(sArchives);

  try
    slFichiers := TStringList.Create();
    try
      // Liste les fichiers
      if SysUtils.FindFirst(SFTPCfg.SourcePath + SFTPCfg.FileFilter, faAnyFile, Recherche) = 0 then
      begin
        repeat
          slFichiers.Add(Recherche.Name);
        until (SysUtils.FindNext(Recherche) <> 0);
        SysUtils.FindClose(Recherche);
      end;

      // Envoye les fichiers sur le SFTP
      for i := 0 to slFichiers.Count - 1 do
      begin
        Dm_Common.SFTP.UploadFile(SFTPCfg.SourcePath + slFichiers[i], SFTPCfg.FTPDirectory + '/' + ExtractFileName(slFichiers[i]), ftmOverwrite);

        DeplaceFichier(SFTPCfg.SourcePath + slFichiers[i], sArchives);
      end;

      Result := True;
    finally
      slFichiers.Free();
    end;
  except
    on E: Exception do
    begin
      LogAction(Format('Erreur de récupération des fichiers du SFTP -> %s'#160': %s - %s',
        [SFTPCfg.Host, E.ClassName, E.Message]), 0);
      raise Exception.Create(Format('GenSFTPUploadFile -> %s - %s', [E.ClassName, E.Message]));
    end;
  end;
end;

procedure GenSFTPClose();
begin
  // Ferme la connection au SFTP
  if Dm_Common.SFTP.Active then
  begin
    Dm_Common.SFTP.CloseHandle(HandleSFTP);
    Dm_Common.SFTP.Close();
  end;
end;
{$ENDREGION 'Méthodes pour le SFTP'}

//emet un ou plusieur log d'erreur avec les paramètres
procedure DoErreurGeneric(AFichier: string; ANoeud: string; ACommNum: string;
  ACommId: integer; ANomCli: string; ATypeLigne: integer;
  ACodeArt: string; ALibProd: string; ALibErr: string;
  var bValid: boolean);
var
  TpS:string;
begin
  bValid := false; //affecte Cde.bValid

  TpS:='***  Erreur dans le fichier de commande: ' +
      ExtractFileName(AFichier) + '  ***'+#13#10;

  if ANoeud <> '' then
    TpS:=TpS+'    Nœud = ' + ANoeud + #13#10;

  if ACommNum <> '' then
    TpS:=TpS+'    N° Commande = ' + ACommNum + #13#10;

  if ACommId>0 then
    TpS:=TpS+'    Id Commande = ' + inttostr(ACommId) + #13#10;

  if ANomCli <> '' then
    TpS:=TpS+'    Client = ' + ANomCli + #13#10;

  case ATypeLigne of
    1: TpS:=TpS+'    Type de ligne = Ligne' + #13#10;
    2: TpS:=TpS+'    Type de ligne = Lot' + #13#10;
    3: TpS:=TpS+'    Type de ligne = CodePromo' + #13#10;
  end;

  if ACodeArt <> '' then
    TpS:=TpS+'    Code Art. = ' + ACodeArt + #13#10;

  if ALibProd <> '' then
    TpS:=TpS+'    Lib. Art. = ' + ALibProd + #13#10;

  TpS:=TpS+'    Erreur = ' + ALibErr + #13#10;

  LogAction(TpS,0);
  AddMonitoring('Erreur import : ' + ALibErr, logError, mdltImport, apptSyncWeb, Dm_Common.MySiteParams.iMagID);
end;

procedure DoErreurBalise(AFichier: string; ANoeud: string; ALibErr: string;
  var bValid: boolean);
begin
  DoErreurGeneric(AFichier, ANoeud, '', 0, '', 0, '', '', ALibErr, bValid);
end;

//Contrôle la validité de la valeur
//   Result:  0 = ok ; 1 = vide ; 2 = Err. long.
function CtrlValidStr(Value: string; bOblig: boolean; Longueur: integer):integer;
begin
  Result := 0;

  if bOblig and (Value = '') then
  begin
    result:=1;
    exit;
  end;

  if (Longueur>0) and (Length(Value)>Longueur) then
  begin
    Result:=2;
    exit;
  end;
end;

//contrôle la validité d'un mail
function CtrlValidMail(Value: string): boolean;
var
  sGauche, sDroite: string;
  LPos: integer;
begin
  result := true;
  if Pos('@', Value) = 0 then
  begin
    result := false;
    exit;
  end;
  if Pos(' ', Value) > 0 then //espace dans le mail
  begin
    result := false;
    exit;
  end;
  sGauche := Copy(Value, 1, Pos('@', Value) - 1);
  sDroite := Copy(Value, Pos('@', Value) + 1, Length(Value));
  LPos := Pos('.', sGauche);
  if LPos > 0 then
  begin
    if LPos = 1 then //commence par un point
    begin
      result := false;
      exit;
    end;
    if LPos = Length(sGauche) then //point juste à gauche de @
    begin
      result := false;
      exit;
    end;
  end;
  LPos := Pos('.', sDroite);
  if LPos > 0 then
  begin
    if LPos = 1 then //point juste à droite de @
    begin
      result := false;
      exit;
    end;
    if LPos = Length(sDroite) then //fini par un point
    begin
      result := false;
      exit;
    end;
  end
  else //pas de point à droite de @
  begin
    result := false;
    exit;
  end;
end;

//test si la balise existe dans le noeud spécifié
function IsBaliseExists(ANode:IXmlNode;AName:OleVariant):boolean;
var
  i:integer;
begin
  result:=false;
  i:=1;
  while not(Result) and (i<=ANode.ChildNodes.Count) do begin
    if ANode.ChildNodes[i-1].NodeName=AName then
      result:=true;
    Inc(i);
  end;
end;

function XMLArticlesToRecord(const sFichierXML: String): TTabArticles;
var
  XML: IXMLDocument;
  NoeudArticlesRacine, NoeudArticle: IXmlNode;
  bOk: Boolean;
begin
  XML := TXMLDocument.Create(nil);
  try
    try
      XML.LoadFromFile(sFichierXML);
      NoeudArticlesRacine := XML.DocumentElement;
      if Assigned(NoeudArticlesRacine) then
      begin
        if NoeudArticlesRacine.HasChildNodes then
        begin
          NoeudArticle := NoeudArticlesRacine.ChildNodes.First;

          // Parcours des articles.
          while Assigned(NoeudArticle) do
          begin
            SetLength(Result, Length(Result) + 1);
            Result[High(Result)].bValide := False;

            // Code article.
            if IsBaliseExists(NoeudArticle, 'CodeArticle') then
              Result[High(Result)].sCBArticle := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['CodeArticle']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <CodeArticle> trouvée !');

            // Produit.
            if IsBaliseExists(NoeudArticle, 'Produit') then
              Result[High(Result)].sDesignation := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['Produit']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <Produit> trouvée !');

            // Code fourniseur.
            if IsBaliseExists(NoeudArticle, 'CodeFourn') then
              Result[High(Result)].sRefMarqueFournisseur := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['CodeFourn']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <CodeFourn> trouvée !');

            // Taille.
            if IsBaliseExists(NoeudArticle, 'Taille') then
              Result[High(Result)].sLibelleTaille := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['Taille']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <Taille> trouvée !');

            // Couleur.
            if IsBaliseExists(NoeudArticle, 'Couleur') then
              Result[High(Result)].sLibelleCouleur := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['Couleur']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <Couleur> trouvée !');

            // Marque.
            if IsBaliseExists(NoeudArticle, 'Marque') then
            begin
              Result[High(Result)].sNomMarque := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['Marque']), 64);
              if Result[High(Result)].sNomMarque = '' then
                raise Exception.Create('# Erreur :  balise <Marque> vide !');
            end
            else
              raise Exception.Create('# Erreur :  pas de balise <Marque> trouvée !');

            // Rayon.
            if IsBaliseExists(NoeudArticle, 'Rayon') then
              Result[High(Result)].sLibelleRayon := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['Rayon']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <Rayon> trouvée !');

            // Famille.
            if IsBaliseExists(NoeudArticle, 'Famille') then
              Result[High(Result)].sLibelleFamille := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['Famille']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <Famille> trouvée !');

            // Sous-famille.
            if IsBaliseExists(NoeudArticle, 'SousFamille') then
              Result[High(Result)].sLibelleSousFamille := LeftStr(XmlStrToStr(NoeudArticle.ChildValues['SousFamille']), 64)
            else
              raise Exception.Create('# Erreur :  pas de balise <SousFamille> trouvée !');

            // Prix achat HT.
            if IsBaliseExists(NoeudArticle, 'PxAchatHT') then
            begin
              Result[High(Result)].dPrixAchatHT := XmlStrToFloat(NoeudArticle.ChildValues['PxAchatHT'], bOk);
              if not bOk then
                raise Exception.Create('# Erreur :  prix achat HT invalide !');
            end
            else
              raise Exception.Create('# Erreur :  pas de balise <PxAchatHT> trouvée !');

            // Prix vente TTC.
            if IsBaliseExists(NoeudArticle, 'PxVteTTC') then
            begin
              Result[High(Result)].dPrixVenteTTC := XmlStrToFloat(NoeudArticle.ChildValues['PxVteTTC'], bOk);
              if not bOk then
                raise Exception.Create('# Erreur :  prix vente TTC invalide !');
            end
            else
              raise Exception.Create('# Erreur :  pas de balise <PxVteTTC> trouvée !');

            // Taux TVA.
            if IsBaliseExists(NoeudArticle, 'TxTva') then
            begin
              Result[High(Result)].dTauxTVA := XmlStrToFloat(NoeudArticle.ChildValues['TxTva'], bOk);
              if not bOk then
                raise Exception.Create('# Erreur :  taux TVA invalide !');
            end
            else
              raise Exception.Create('# Erreur :  pas de balise <TxTva> trouvée !');

            Result[High(Result)].bValide := True;

//            NoeudArticle := NoeudArticlesRacine.NextSibling;
            NoeudArticle := NoeudArticlesRacine.ChildNodes.FindSibling(NoeudArticle, 1);
          end;
        end
        else
          raise Exception.Create('# Erreur :  le noeud racine <Articles> n''a pas d''enfants !');
      end
      else
        raise Exception.Create('# Erreur :  pas de noeud racine <Articles> trouvé !');
    except
      on E: Exception do
      begin
        raise Exception.Create('[' + sFichierXML + '] >>  ' + E.Message);
      end;
    end;
  finally
    XML := nil;
  end;
end;

function DoXmlGenToRecord(sXmlfile: string): TCde;
type
  TCumTva = record
    OkUse: Boolean;
    TxTva: Double;
    HT: Double;
    TTC: Double;
  end;
var
  CdeNode, ClientNode, AdrFactNode, AdrLivrNode, ColisNode, LignesNode, LigneNode, TVASNode, TVANode, ReglementsNode, ReglementNode: IXmlNode;
  i, j: Integer;

  bOk         : Boolean;        // pour le controle des champs
  NomCli      : string;         // nom du client pour les log
  CdeNum      : string;         // N° de commande pour les log
  CdeId       : Integer;        // Id de commande pour les log
  vTypLig     : Integer;        // Type de ligne pour les log  1: art  2: lot  3: code promo
  ArtInfos    : stArticleInfos; // pour tester les articles
  LstLot      : TStringList;    // pour test le lot
  vLigHT      : Double;
  vLigTVA     : Double;
  vLigTTC     : Double;
  TotLigHT    : Double;
  TotLigTTC   : Double;
  TotReglement: Currency;

  bAdrFactNode: Boolean; // balise AddressFact ok
  bAdrLivrNode: Boolean; // balise AddressLivr ok

  bOkLesLignes     : Boolean;                   // le calcul des lignes s'est bien passé  (bOkLigCtrlHTetTTC n'a jamais été à false)
  bOkLesTva        : Boolean;                   // le calcul des cumul tva s'est bien passé (bOkTvaCtrlHTetTTC n'a jamais été à false)
  bOkLesReglements : Boolean;                   // Les règlements sont ok
  bOkLigCtrlHTetTTC: Boolean;                   // test si on peut faire le controle entre le ht, tva et ttc sur la ligne
  bOkTvaCtrlHTetTTC: Boolean;                   // test si on peut faire le controle entre le ht, tva et ttc sur la tva
  bOkReglementsCtrl: Boolean;                   // Contrôle des modes de règlements
  bOkTotCtrlHTetTTC: Boolean;                   // test si on peut faire le controle entre le ht, tva et ttc sur le total
  ArrCumTva        : array [1 .. 5] of TCumTva; // pour le calcul de cumul tva par taux
  LPosCumTva       : Integer;                   // position ds l'array de ArrCumTva

  TxTVANouv: Currency;

  fTauxFP,
    fTvaFP,
    fHTFP: single;
  bTauxFPAdded: boolean;

  vCodeBarType: Integer;
begin
  // true = Format du fichier xml ok par défaut
  Result.bValid := True;
  NomCli        := '';
  CdeNum        := '';
  CdeId         := 0;
  TotLigHT      := 0;
  TotLigTTC     := 0;
  vTypLig := 0;

  bOkLesLignes := True; // le calcul des lignes s'est bien passé  (bOkLigCtrlHTetTTC n'a jamais été à false)
  bOkLesTva    := True; // le calcul des cumul tva s'est bien passé (bOkTvaCtrlHTetTTC n'a jamais été à false)
  // initialisation pour le calcul de cumul tva par taux
  for i := 1 to 5 do
  begin
    ArrCumTva[i].OkUse := False;
    ArrCumTva[i].TxTva := 0.0;
    ArrCumTva[i].HT    := 0.0;
    ArrCumTva[i].TTC   := 0.0;
  end;

  LstLot := TStringList.Create();
  try
    try
      Dm_Common.MyDoc.LoadFromFile(sXmlfile);

      // voir MyDoc.encoding

      CdeNode := Dm_Common.MyDoc.DocumentElement;

      Result.XmlFile   := sXmlfile;
      Result.InfosSupp := '';

      // ---------- Controle Commande -------------------------------------------------

      // N° Commande pas obligatoire , long max = 32
      if not(IsBaliseExists(CdeNode, 'CommandeNum')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise CommandeNum non trouvé', Result.bValid);
      end
      else
      begin
        Result.CommandeInfos.CommandeNum := ShortString(XmlStrToStr(CdeNode.ChildValues['CommandeNum']));
        CdeNum                           := string(Result.CommandeInfos.CommandeNum);
        if CtrlValidStr(string(Result.CommandeInfos.CommandeNum), False, 32) = 2 then
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Longueur N° Commande trop grande', Result.bValid);
      end;

      // CommandeId doit être >0
      if not(IsBaliseExists(CdeNode, 'CommandeId')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise CommandeId non trouvé', Result.bValid);
      end
      else
      begin
        Result.CommandeInfos.CommandeId := XmlStrToInt(CdeNode.ChildValues['CommandeId']);
        CdeId                           := Result.CommandeInfos.CommandeId;
        if Result.CommandeInfos.CommandeId <= 0 then
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Id de la commande invalide ou manquant', Result.bValid);
      end;

      // Contrôle date de commande
      if not(IsBaliseExists(CdeNode, 'CommandeDate')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise CommandeDate non trouvé', Result.bValid);
      end
      else
      begin
        Result.CommandeInfos.CommandeDate := XmlStrToDate(CdeNode.ChildValues['CommandeDate'], bOk);
        if not(bOk) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Date de commande invalide', Result.bValid);
        end
        else
        begin
          // Date de commande oblig
          if Trunc(Result.CommandeInfos.CommandeDate) = 0 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Date de commande manquant', Result.bValid);
          end;
        end;
      end;

      // Contrôle du Statut
      if not(IsBaliseExists(CdeNode, 'Statut')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise Statut non trouvé', Result.bValid);
      end
      else
      begin
        Result.CommandeInfos.Statut := UpperCase(XmlStrToStr(CdeNode.ChildValues['Statut']));
        if (Result.CommandeInfos.Statut <> 'PAYE') and (Result.CommandeInfos.Statut <> 'CHEQUE') and (Result.CommandeInfos.Statut <> 'NONPAYE') then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Statut invalide ou manquant', Result.bValid);
        end;
      end;

      // Contrôle Export
      if not(IsBaliseExists(CdeNode, 'Export')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise Export non trouvé', Result.bValid);
      end
      else
      begin
        Result.CommandeInfos.iExport := XmlStrToInt(CdeNode.ChildValues['Export'], -1);
        if (Result.CommandeInfos.iExport < 0) or (Result.CommandeInfos.iExport > 1) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Valeur export invalide', Result.bValid);
        end;
      end;

      // ---------- /Controle Commande ------------------------------------------------

      // ---------- Controle Client ---------------------------------------------------

      if not(IsBaliseExists(CdeNode, 'Client')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Noeud Client non trouvé', Result.bValid);
      end
      else
      begin
        ClientNode := CdeNode.ChildNodes['Client'];

        // Contrôle balise AddressFact
        bAdrFactNode := True;
        if not(IsBaliseExists(ClientNode, 'AddressFact')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande\Client', 'Noeud AddressFact non trouvé', Result.bValid);
          bAdrFactNode := False;
        end;
        AdrFactNode := ClientNode.ChildNodes['AddressFact'];

        // Contrôle balise AddressLivr
        bAdrLivrNode := True;
        if not(IsBaliseExists(ClientNode, 'AddressLivr')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande\Client', 'Noeud AddressLivr non trouvé', Result.bValid);
          bAdrLivrNode := False;
        end;
        AdrLivrNode := ClientNode.ChildNodes['AddressLivr'];

        // Contrôle CodeClient
        if Dm_Common.GetParamInteger(233) = 0 then
        begin
          if (IsBaliseExists(ClientNode, 'CodeClient')) then
          begin
            Result.Client.Codeclient := XmlStrToInt(ClientNode.ChildValues['CodeClient']);
            if (Result.Client.Codeclient <= 0) then
            begin
              DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '',
                'Code client invalide (' + IntToStr(Result.Client.Codeclient) + ')', Result.bValid);
            end;
          end
          else
            DoErreurBalise(sXmlfile, 'Commande\Client', 'Balise CodeClient non trouvé', Result.bValid);
        end;

        // Contrôle Mailing     SR - 01/12/2016
        if IsBaliseExists(ClientNode, 'Mailing') then
        begin
          Result.Client.Mailing := XmlStrToInt(ClientNode.ChildValues['Mailing']);
          if Result.Client.Mailing <= 0 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '',
              'Mailing invalide (' + IntToStr(Result.Client.Mailing) + ')', Result.bValid);
          end;
        end
        else
        begin
          Result.Client.Mailing := 0;
        end;

        // Contrôle SMS     SR - 01/12/2016
        if IsBaliseExists(ClientNode, 'Sms') then
        begin
          Result.Client.Sms := XmlStrToInt(ClientNode.ChildValues['Sms']);
          if Result.Client.Sms <= 0 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '',
              'Sms invalide (' + IntToStr(Result.Client.Sms) + ')', Result.bValid);
          end;
        end
        else
        begin
          Result.Client.Sms := 0;
        end;

        // IdClientGinkoia
        if Dm_Common.GetParamInteger(233) = 0 then
        begin
          Result.Client.IdGinkoiaClient := XmlStrToInt(ClientNode.ChildValues['IdGinkoiaClient']);
          if Result.Client.Codeclient <= 0 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '',
              'Code client Ginkoia invalide (' + IntToStr(Result.Client.IdGinkoiaClient) + ')', Result.bValid);
          end;
        end;

        // controle EMail, oblig., long. max = 64
        if not(IsBaliseExists(ClientNode, 'Email')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande\Client', 'Balise Email non trouvé', Result.bValid);
        end
        else
        begin
          Result.Client.Email := ShortString(XmlStrToStr(ClientNode.ChildValues['Email']));
          case CtrlValidStr(string(Result.Client.Email), True, 64) of
            1:
              DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '', 'EMail obligatoire', Result.bValid);
            2:
              DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '', 'Longueur EMail trop grande', Result.bValid);
            else
              if not(CtrlValidMail(string(Result.Client.Email))) then
                DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId, NomCli, 0, '', '', 'EMail invalide', Result.bValid);
          end;
        end;

        // les contrôles sont dans XmlAdrToAdr
        // Client Facturé
        if bAdrFactNode then
        begin
          Result.Client.AdresseFact := XmlAdrToAdr(sXmlfile, Result, AdrFactNode, Result.bValid);
          NomCli                    := Result.Client.AdresseFact.sAdr_Nom;
        end;

        // Client à livrer
        if bAdrLivrNode then
          Result.Client.AdresseLivr := XmlAdrToAdr(sXmlfile, Result, AdrLivrNode, Result.bValid);
      end;

      // ---------- /Controle Client --------------------------------------------------

      // ---------- Controle Livraison ------------------------------------------------

      if IsBaliseExists(CdeNode, 'Colis') then
      begin
        ColisNode                     := CdeNode.ChildNodes['Colis'];
        Result.Colis.Numero           := XmlStrToStr(ColisNode.ChildValues['Numero']);
        Result.Colis.CodeTransporteur := XmlStrToStr(ColisNode.ChildValues['CodeTransporteur']);
        Result.Colis.Transporteur     := XmlStrToStr(ColisNode.ChildValues['Transporteur']);
        Result.Colis.CodeProduit      := XmlStrToStr(ColisNode.ChildValues['CodeProduit']);
        Result.Colis.MagasinRetrait   := XmlStrToStr(ColisNode.ChildValues['MagasinRetrait']);
        Result.Colis.CodeRelais       := XmlStrToStr(ColisNode.ChildValues['CodeRelais']);
      end;

      // ---------- /Controle Livraison -----------------------------------------------

      // ---------- Controle Lignes ---------------------------------------------------
      if not(IsBaliseExists(CdeNode, 'Lignes')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Noeud Lignes non trouvé', Result.bValid);
        bOkLesLignes := False;
      end
      else
      begin
        LignesNode := CdeNode.ChildNodes['Lignes'];
        if LignesNode.ChildNodes.Count = 0 then
        begin
          DoErreurGeneric(sXmlfile, 'Commande\Lignes', CdeNum, CdeId, NomCli, 0, '', '', 'Aucune ligne d''article n''a été trouvée !', Result.bValid);
          bOkLesLignes := False;
        end
        else
        begin
          SetLength(Result.Lignes, LignesNode.ChildNodes.Count);
          for i := 0 to LignesNode.ChildNodes.Count - 1 do
          begin
            LigneNode := LignesNode.ChildNodes[i];

            // Contrôle type de ligne
            if not(IsBaliseExists(LigneNode, 'TypeLigne')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise TypeLigne non trouvé', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].TypeLigne := ShortString(XmlStrToStr(LigneNode.ChildValues['TypeLigne']));
              if (UpperCase(string(Result.Lignes[i].TypeLigne)) <> 'LIGNE') and (UpperCase(string(Result.Lignes[i].TypeLigne)) <> 'LOT') and
                (UpperCase(string(Result.Lignes[i].TypeLigne)) <> 'CODEPROMO') then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                  'Type de ligne invalide', Result.bValid);
              end;
            end;

            // pour les log
            vTypLig := Succ(AnsiIndexText(string(Result.Lignes[i].TypeLigne), ['LIGNE', 'LOT', 'CODEPROMO']));

            { TODO -oCH : pas de contrôle sur la désignation ?? }
            if not(IsBaliseExists(LigneNode, 'Designation')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise Designation non trouvée', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].Designation := ShortString(XmlStrToStr(LigneNode.ChildValues['Designation']));
              if CtrlValidStr(string(Result.Lignes[i].Designation), True, 0) = 1 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '', 'Designation obligatoire',
                  Result.bValid);
              end;
            end;

            // Controle du code suivant le type de ligne
            vCodeBarType := 1;
            Result.Lignes[i].Code := ShortString(XmlStrToStr(LigneNode.ChildValues['Code']));
            if not(IsBaliseExists(LigneNode, 'Code')) or (Result.Lignes[i].Code = '') then
            begin
              Result.Lignes[i].Code := ShortString(XmlStrToStr(LigneNode.ChildValues['CodeEAN']));
              if not(IsBaliseExists(LigneNode, 'CodeEAN')) or (Result.Lignes[i].Code = '') then
              begin
                DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balises Code et CodeEAN non trouvées ou vides', Result.bValid);
              end
              else // il s'agit d'un CODEEAN, on renseigne l'info
              begin
                vCodeBarType := 3;
                Result.Lignes[i].CodeEAN := Result.Lignes[i].Code;
              end;
            end;

            if Result.Lignes[i].Code <> '' then
            begin
              case vTypLig of
                1: // code article
                  begin
                    ArtInfos := Dm_Common.GetArticleInfos(string(Result.Lignes[i].Code), vCodeBarType);
                    if not(ArtInfos.IsValide) then
                    begin
                      DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                        string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Code Article invalide ou inconnu', Result.bValid);
                    end;
                  end;
                2: // code lot
                  begin
                    LstLot.Clear;
                    LstLot.Text := StringReplace(string(Result.Lignes[i].Code), '*', #13#10, [rfReplaceAll]);
                    if LstLot.Count <= 1 then
                    begin
                      DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                        string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Code lot invalide', Result.bValid);
                    end
                    else
                    begin
                      // test N° lot
                      case Dm_Common.IsLotValid(StrToIntDef(LstLot[0], -1)) of
                        1:
                          begin
                            DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                              string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'N° lot invalide: ' + Trim(LstLot[0]),
                              Result.bValid);
                          end;
                        2:
                          begin
                            DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                              string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'N° lot inconnu: ' + Trim(LstLot[0]),
                              Result.bValid);
                          end;
                        3:
                          begin
                            DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                              string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'N° lot supprimé: ' + Trim(LstLot[0]),
                              Result.bValid);
                            bOk := False;
                          end;
                      end;
                      for j := 1 to LstLot.Count - 1 do
                      begin
                        ArtInfos := Dm_Common.GetArticleInfos(Trim(LstLot[j]));
                        if not(ArtInfos.IsValide) then
                          DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                            string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation),
                            'Code article ' + Trim(LstLot[j]) + ' inconnu pour ce lot', Result.bValid);
                      end;
                    end;
                  end;
                3: // code promo
                  begin
                    if not(Dm_Common.IsCodePromoValid(StrToIntDef(string(Result.Lignes[i].Code), -1), String(Result.Lignes[i].Designation))) then
                    begin
                      // si il n'existe pas on le crée
                      Dm_Common.Que_Tmp.Close;
                      Dm_Common.Que_Tmp.SQL.Clear;
                      Dm_Common.Que_Tmp.SQL.Add('execute procedure CHAM3S_CREA_CODEPROMO(:CODEPROMO, :TYPEPROMO, :MONTANT)');
                      try
                        Dm_Common.Que_Tmp.ParamByName('CODEPROMO').AsString  := String(Result.Lignes[i].Designation);
                        Dm_Common.Que_Tmp.ParamByName('TYPEPROMO').AsInteger := 0;
                        Dm_Common.Que_Tmp.ParamByName('MONTANT').AsFloat     := 0;
                        Dm_Common.Que_Tmp.Open;
                        Result.Lignes[i].Code := ShortString(Dm_Common.Que_Tmp.FieldByName('ART_ID').AsString);
                        if StrToInt(String(Result.Lignes[i].Code)) = 0 then
                          raise Exception.Create('procedure CHAM3S_CREA_CODEPROMO : ART_ID=0');
                      except
                        on E: Exception do
                        begin
                          DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                            string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Erreur à la création du code promo'#13#10 +
                              E.Message, Result.bValid);
                        end;
                      end;
                      (* DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' +
                        inttostr(i + 1) + ')',
                        CdeNum, CdeId,
                        NomCli, vTypLig, String(Code), String(Designation),
                        'Code Promo invalide ou inconnu',
                        Result.bValid); *)
                    end;
                  end;
              end;
            end;

            // Contrôle de PUBrutHT
            if not(IsBaliseExists(LigneNode, 'PUBrutHT')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise PUBrutHT non trouvé', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].PUBrutHT := XmlStrToFloat(LigneNode.ChildValues['PUBrutHT'], bOk);
              if not(bOk) then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'PU Brut avant remise HT invalide ', Result.bValid);
              end;
            end;

            // Contrôle de PUBrutTTC
            if not(IsBaliseExists(LigneNode, 'PUBrutTTC')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise PUBrutTTC non trouvé', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].PUBrutTTC := XmlStrToFloat(LigneNode.ChildValues['PUBrutTTC'], bOk);
              if not(bOk) then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'PU Brut avant remise TTC invalide ', Result.bValid);
              end;
            end;

            // Contrôle de PUHT
            if not(IsBaliseExists(LigneNode, 'PUHT')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise PUHT non trouvé', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].PUHT := XmlStrToFloat(LigneNode.ChildValues['PUHT'], bOk);
              if not(bOk) then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'PU remisé HT invalide ', Result.bValid);
              end;
            end;

            // Contrôle de PUTTC
            if not(IsBaliseExists(LigneNode, 'PUTTC')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise PUTTC non trouvé', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].PUTTC := XmlStrToFloat(LigneNode.ChildValues['PUTTC'], bOk);
              if not(bOk) then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'PU remisé TTC invalide ', Result.bValid);
              end;
            end;

            bOkLigCtrlHTetTTC := True; // par defaut, on peut controler la cohérence entre HT, Tva, et ttc (plus bas)
            // Contrôle de TxTVA
            if not(IsBaliseExists(LigneNode, 'TxTva')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise TxTva non trouvé', Result.bValid);
              bOkLigCtrlHTetTTC := False;
              bOkLesLignes      := False;
            end
            else
            begin
              Result.Lignes[i].TxTva := XmlStrToFloat(LigneNode.ChildValues['TxTva'], bOk);
              if not(bOk) then
              begin
                bOkLigCtrlHTetTTC := False;
                bOkLesLignes      := False;
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Taux TVA invalide ', Result.bValid);
              end;
            end;

            // Contrôle de Qte
            if not(IsBaliseExists(LigneNode, 'Qte')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise Qte non trouvé', Result.bValid);
            end
            else
            begin
              Result.Lignes[i].Qte := XmlStrToInt(LigneNode.ChildValues['Qte']);
              if Result.Lignes[i].Qte = 0 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Quantité invalide ', Result.bValid);
              end;
              case vTypLig of
                2: // Lot
                  begin
                    if Result.Lignes[i].Qte <> 1 then
                    begin
                      DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                        string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Quantité doit être à 1 pour une ligne Lot ',
                        Result.bValid);
                    end;
                  end;
                3: // Code promo
                  begin
                    if Abs(Result.Lignes[i].Qte) <> 1 then
                    begin
                      DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                        string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Quantité doit être à 1 pour une ligne Code Promo ',
                        Result.bValid);
                    end;
                  end;
              end;
            end;

            // Contrôle de PXHT
            if not(IsBaliseExists(LigneNode, 'PXHT')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise PXHT non trouvé', Result.bValid);
              bOkLigCtrlHTetTTC := False;
              bOkLesLignes      := False;
            end
            else
            begin
              Result.Lignes[i].PXHT := XmlStrToFloat(LigneNode.ChildValues['PXHT'], bOk);
              if not(bOk) then
              begin
                bOkLigCtrlHTetTTC := False;
                bOkLesLignes      := False;
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Prix total HT invalide ', Result.bValid);
              end;
            end;

            // Contrôle de PXTTC
            if not(IsBaliseExists(LigneNode, 'PXTTC')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + IntToStr(i + 1) + ')', 'Balise PXTTC non trouvé', Result.bValid);
              bOkLigCtrlHTetTTC := False;
              bOkLesLignes      := False;
            end
            else
            begin
              Result.Lignes[i].PXTTC := XmlStrToFloat(LigneNode.ChildValues['PXTTC'], bOk);
              if not(bOk) then
              begin
                bOkLigCtrlHTetTTC := False;
                bOkLesLignes      := False;
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Prix total TTC invalide ', Result.bValid);
              end;
            end;

            // Contrôle de cohérence de (PUHT * QTE = PXHT) et (PUTTC * QTE = PXTTC)
            if ((Result.Lignes[i].PUHT * Result.Lignes[i].Qte <> Result.Lignes[i].PXHT)
                 and (Result.Lignes[i].PUTTC * Result.Lignes[i].Qte <> Result.Lignes[i].PXTTC)) then
            begin
                bOkLigCtrlHTetTTC := False;
                bOkLesLignes      := False;
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Prix unitaire (TTC/HT) x Qte différent de prix total (TTC/HT) ', Result.bValid);
            end;

            // Contrôle de Fidelite
            if (IsBaliseExists(LigneNode, 'Fidelite')) then
            begin
              Result.Lignes[i].Fidelite := XmlStrToInt(LigneNode.ChildValues['Fidelite']);
              if not(Result.Lignes[i].Fidelite >= 0) then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Fidelite invalide ', Result.bValid);
              end;
            end
            else
              Result.Lignes[i].Fidelite := 0;

            // contrôle cohérence HT et TTC
            if bOkLigCtrlHTetTTC then
            begin
              vLigTTC := ArrondiA2(Result.Lignes[i].PXTTC);
              vLigHT  := ArrondiA2(vLigTTC / (1 + (Result.Lignes[i].TxTva / 100)));
              if Abs(ArrondiA2(vLigHT - Result.Lignes[i].PXHT)) > 0.02 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, vTypLig,
                  string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation),
                  'Prix total HT incohérent avec le calcul prix totalTTC et le taux de TVA', Result.bValid);
              end;
              TotLigHT  := TotLigHT + Result.Lignes[i].PXHT;
              TotLigTTC := TotLigTTC + Result.Lignes[i].PXTTC;
              // cumul par tx tva
              LPosCumTva := -1;
              j          := 1;
              while (LPosCumTva = -1) and (j <= 5) do
              begin
                if (ArrondiA2(ArrCumTva[j].TxTva) = ArrondiA2(Result.Lignes[i].TxTva)) and ArrCumTva[j].OkUse then
                  LPosCumTva := j;
                Inc(j);
              end;
              if LPosCumTva > 0 then
              begin
                ArrCumTva[LPosCumTva].HT  := ArrondiA2(ArrCumTva[LPosCumTva].HT + Result.Lignes[i].PXHT);
                ArrCumTva[LPosCumTva].TTC := ArrondiA2(ArrCumTva[LPosCumTva].TTC + Result.Lignes[i].PXTTC);
              end
              else
              begin
                LPosCumTva := -1;
                j          := 1;
                while (LPosCumTva = -1) and (j <= 5) do
                begin
                  if not(ArrCumTva[j].OkUse) then
                    LPosCumTva := j;
                  Inc(j);
                end;
                if LPosCumTva = -1 then
                  raise Exception.Create('Trop de taux de tva !');
                ArrCumTva[LPosCumTva].OkUse := True;
                ArrCumTva[LPosCumTva].TxTva := ArrondiA2(Result.Lignes[i].TxTva);
                ArrCumTva[LPosCumTva].HT    := ArrondiA2(Result.Lignes[i].PXHT);
                ArrCumTva[LPosCumTva].TTC   := ArrondiA2(Result.Lignes[i].PXTTC);
              end;

            end;
          end; // for i := 0 to LignesNode.ChildNodes.Count - 1 do
        end;   // else du: if LignesNode.ChildNodes.Count=0 then
      end;     // else de test existance balise lignes

      // ---------- /Controle Lignes --------------------------------------------------

      // ---------- Controle TVA ------------------------------------------------------

      // Tvas
      if not(IsBaliseExists(CdeNode, 'TVAS')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Noeud TVAS non trouvé', Result.bValid);
        bOkLesTva := False;
      end
      else
      begin
        TVASNode := CdeNode.ChildNodes['TVAS'];
        SetLength(Result.TVAS, TVASNode.ChildNodes.Count);
        // Contrôle s'il y a au moins 1 ligne de TVA
        if TVASNode.ChildNodes.Count = 0 then
        begin
          DoErreurGeneric(sXmlfile, 'Commande\TVAS', CdeNum, CdeId, NomCli, 0, '', '', 'Il faut au moins une balise TVA !', Result.bValid);
          bOkLesTva := False;
        end;

        if TVASNode.ChildNodes.Count > 5 then
        begin
          DoErreurGeneric(sXmlfile, 'Commande\TVAS', CdeNum, CdeId, NomCli, 0, '', '', 'Trop de balise TVA ( >5 ) !', Result.bValid);
          bOkLesTva := False;
        end;

        for i := 0 to TVASNode.ChildNodes.Count - 1 do
        begin
          bOkTvaCtrlHTetTTC := True; // par defaut, on peut controler la cohérence entre HT, Tva, et ttc (plus bas)
          TVANode           := TVASNode.ChildNodes[i];

          // Controle TotalHT
          if not(IsBaliseExists(TVANode, 'TotalHT')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande\TVA (N°' + IntToStr(i + 1) + ')', 'Balise TotalHT non trouvé', Result.bValid);
            bOkTvaCtrlHTetTTC := False;
            bOkLesTva         := False;
          end
          else
          begin
            Result.TVAS[i].TotalHT := XmlStrToFloat(TVANode.ChildValues['TotalHT'], bOk);
            if not(bOk) then
            begin
              bOkTvaCtrlHTetTTC := False;
              bOkLesTva         := False;
              DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '', 'Total HT invalide !',
                Result.bValid);
            end;
          end;

          // Controle TauxTva
          if not(IsBaliseExists(TVANode, 'TauxTva')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande\TVA (N°' + IntToStr(i + 1) + ')', 'Balise TauxTva non trouvé', Result.bValid);
            bOkTvaCtrlHTetTTC := False;
            bOkLesTva         := False;
          end
          else
          begin
            Result.TVAS[i].TauxTva := XmlStrToFloat(TVANode.ChildValues['TauxTva'], bOk);
            if not(bOk) then
            begin
              bOkTvaCtrlHTetTTC := False;
              bOkLesTva         := False;
              DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '', 'Taux TVA invalide !',
                Result.bValid);
            end;
          end;

          // Controle MtTVA
          if not(IsBaliseExists(TVANode, 'MtTva')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande\TVA (N°' + IntToStr(i + 1) + ')', 'Balise MtTva non trouvé', Result.bValid);
            bOkTvaCtrlHTetTTC := False;
            bOkLesTva         := False;
          end
          else
          begin
            Result.TVAS[i].MtTVA := XmlStrToFloat(TVANode.ChildValues['MtTva'], bOk);
            if not(bOk) then
            begin
              bOkTvaCtrlHTetTTC := False;
              bOkLesTva         := False;
              DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '', 'Montant Tva invalide !',
                Result.bValid);
            end;
          end;

          // Contrôle cohérence Mt TVA
          if bOkTvaCtrlHTetTTC then
          begin
            vLigHT  := ArrondiA2(Result.TVAS[i].TotalHT);
            vLigTVA := ArrondiA2(vLigHT * (Result.TVAS[i].TauxTva / 100));
            if Abs(ArrondiA2(vLigTVA - Result.TVAS[i].MtTVA)) > 0.05 then
            begin
              DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                'Montant Tva incohérent avec le Total HT et le Taux de TVA !', Result.bValid);
            end;
          end;
        end; // for i := 0 to TVASNode.ChildNodes.Count - 1 do

        // contrôle plusieurs fois le même taux dans le cumul tva
        if bOkLesTva then
        begin
          for i := Low(Result.TVAS) to High(Result.TVAS) - 1 do
          begin
            for j := i + 1 to High(Result.TVAS) do
            begin
              if ArrondiA2(Result.TVAS[i].TauxTva) = ArrondiA2(Result.TVAS[j].TauxTva) then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                  'Il y a plusieurs fois le même taux dans le tableau des cumuls des TVA', Result.bValid);
                bOkLesTva := False;
              end;
            end;
          end;

        end;

        // Contrôle le cumul calculé dans les lignes et le tableau des cumuls
        if bOkLesTva and bOkLesLignes then
        begin
          if Result.CommandeInfos.iExport = 0 then
          begin
            for i := Low(Result.TVAS) to High(Result.TVAS) do
            begin
              LPosCumTva := -1;
              j          := 1;
              while (LPosCumTva = -1) and (j <= 5) do
              begin
                if (ArrCumTva[j].OkUse) and (ArrondiA2(ArrCumTva[j].TxTva) = ArrondiA2(Result.TVAS[i].TauxTva)) then
                  LPosCumTva := j;
                Inc(j);
              end;

              if LPosCumTva = -1 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                  'Taux Tva (' + FloatToStr(Result.TVAS[i].TauxTva) + '%) présent dans le cumul et pas dans les lignes', Result.bValid);
              end
              else
              begin
                // Compare le HT des lignes et celui du cumul TVA
                if (Abs(ArrondiA2(ArrCumTva[LPosCumTva].HT - Result.TVAS[i].TotalHT)) > 0.05) then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                    'Calcul cumul Tva des lignes (tx: ' + FloatToStr(Result.TVAS[i].TauxTva) + '%) différent du cumul TVA', Result.bValid);
                end
                else
                begin // mis en commentaire dans le BL s'il y a une différence de centimes
                  if Abs(ArrondiA2(ArrCumTva[LPosCumTva].HT - Result.TVAS[i].TotalHT)) >= 0.01 then
                  begin
                    if Result.InfosSupp <> '' then
                      Result.InfosSupp := Result.InfosSupp + #13#10;
                    Result.InfosSupp   := Result.InfosSupp + 'Avertissement: Cumul Tva (tx: ' + FloatToStr(Result.TVAS[i].TauxTva) + '%): ' +
                      'Total HT : différence de ' + FormatFloat('0.00', Abs(ArrCumTva[LPosCumTva].HT - Result.TVAS[i].TotalHT)) + ' avec les lignes';
                  end;
                end;

                // Compare le TTC des lignes et celui du cumul TVA (HT+MtTva)
                if (Abs(ArrondiA2(ArrCumTva[LPosCumTva].TTC - Result.TVAS[i].TotalHT - Result.TVAS[i].MtTVA)) > 0.05) then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + IntToStr(i + 1) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                    'Cumul HT + Cumul Mt TVA pour tx: ' + FloatToStr(Result.TVAS[i].TauxTva) + '% différent des totaux TTC des lignes',
                    Result.bValid);
                end;

              end;
            end;
          end;
        end;

      end; // TVAS

      // ---------- /Controle TVA ----------------------------------------------------- 

      // ---------- Controle Export ---------------------------------------------------
      { DONE -oLP -cDonnées:Récupérer les prix TTC à partir des prix HT et de la TVA de l'article dans Ginkoia. }
      if (Result.CommandeInfos.iExport = 1) then
      begin
        // Réinistalise le tableau des taux de TVA
        SetLength(Result.TVAS, 5);

        for i := 0 to 4 do
        begin
          Result.TVAS[i].TauxTva := -1;
          Result.TVAS[i].TotalHT := 0;
          Result.TVAS[i].MtTVA   := 0;
        end;

        for i := 0 to Length(Result.Lignes) - 1 do
        begin
          if not(SameText(String(Result.Lignes[i].TypeLigne), 'CODEPROMO')) then
          begin
            if not(Dm_Common.RecupererTTC(ArtInfos.iArtId, Result.Lignes[i].PUBrutHT, Result.Lignes[i].PUHT, Result.Lignes[i].PXHT,
                Result.Lignes[i].PUBrutTTC, Result.Lignes[i].PUTTC, Result.Lignes[i].PXTTC, TxTVANouv)) then
            begin
              DoErreurGeneric(sXmlfile, Format('Commande\Lignes\Ligne(N°%d)', [Succ(i)]), CdeNum, CdeId, NomCli, vTypLig,
                string(Result.Lignes[i].Code), string(Result.Lignes[i].Designation), 'Taux de TVA de l''article introuvable ', Result.bValid);
              bOkLigCtrlHTetTTC := False;
              bOkLesLignes      := False;
            end
            else
            begin
              // Si la TVA de l'article n'est pas la même que celle du fichier XML : on modifie la TVA pour la ligne
              // et pour la liste des taux de TVAs
              Result.Lignes[i].TxTva := TxTVANouv;
              for j := 0 to Length(Result.TVAS) - 1 do
              begin
                if (Result.TVAS[j].TauxTva = -1)
                  or SameValue(Result.TVAS[j].TauxTva, Result.Lignes[i].TxTva) then
                begin
                  Result.TVAS[j].TauxTva := Result.Lignes[i].TxTva;
                  Result.TVAS[j].TotalHT := Result.TVAS[j].TotalHT + Result.Lignes[i].PXHT;
                  Result.TVAS[j].MtTVA   := (Result.TVAS[j].TotalHT * (1 + Result.TVAS[j].TauxTva / 100)) - Result.TVAS[j].TotalHT;
                  Break;
                end;
              end;
            end;
          end
          else
          begin
            Result.Lignes[i].TxTva := 0;
            for j := 0 to Length(Result.TVAS) - 1 do
            begin
              if (Result.TVAS[j].TauxTva = -1)
                or SameValue(Result.TVAS[j].TauxTva, Result.Lignes[i].TxTva) then
              begin
                Result.TVAS[j].TauxTva := Result.Lignes[i].TxTva;
                Result.TVAS[j].TotalHT := Result.TVAS[j].TotalHT + Result.Lignes[i].PXHT;
                Result.TVAS[j].MtTVA   := (Result.TVAS[j].TotalHT * (1 + Result.TVAS[j].TauxTva / 100)) - Result.TVAS[j].TotalHT;
                Break;
              end;
            end;
          end;
        end;

        for i := 4 downto 0 do
        begin
          if (Result.TVAS[i].TauxTva = -1) then
            SetLength(Result.TVAS, i);
        end;
      end;
      // ---------- /Controle Export --------------------------------------------------

      // ---------- Controle des Totaux -----------------------------------------------

      // Controle SousTotalHT
      if not(IsBaliseExists(CdeNode, 'SousTotalHT')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise SousTotalHT non trouvé', Result.bValid);
      end
      else
      begin
        Result.SousTotalHT := XmlStrToFloat(CdeNode.ChildValues['SousTotalHT'], bOk);
        if not(bOk) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Sous total HT invalide !', Result.bValid);
        end;
      end;

      bOkTotCtrlHTetTTC := True; // par defaut, on peut controler la cohérence entre HT, Tva, et ttc (plus bas)
      // Controle TotalHT
      if not(IsBaliseExists(CdeNode, 'TotalHT')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise TotalHT non trouvé', Result.bValid);
        bOkTotCtrlHTetTTC := False;
      end
      else
      begin
        Result.TotalHT := XmlStrToFloat(CdeNode.ChildValues['TotalHT'], bOk);
        if not(bOk) then
        begin
          bOkTotCtrlHTetTTC := False;
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Total HT invalide !', Result.bValid);
        end;
      end;

      // Controle MontantTVA
      if not(IsBaliseExists(CdeNode, 'MontantTVA')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise MontantTVA non trouvé', Result.bValid);
        bOkTotCtrlHTetTTC := False;
      end
      else
      begin
        Result.MontantTVA := XmlStrToFloat(CdeNode.ChildValues['MontantTVA'], bOk);
        if not(bOk) then
        begin
          bOkTotCtrlHTetTTC := False;
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Montant Tva invalide !', Result.bValid);
        end;
      end;

      // Controle TotalTTC
      if not(IsBaliseExists(CdeNode, 'TotalTTC')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise TotalTTC non trouvé', Result.bValid);
        bOkTotCtrlHTetTTC := False;
      end
      else
      begin
        Result.TotalTTC := XmlStrToFloat(CdeNode.ChildValues['TotalTTC'], bOk);
        if not(bOk) then
        begin
          bOkTotCtrlHTetTTC := False;
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Total TTC invalide !', Result.bValid);
        end;
      end;

      // Controle FraisDePort
      if not(IsBaliseExists(CdeNode, 'FraisPort')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise FraisPort non trouvé', Result.bValid);
      end
      else
      begin
        Result.FraisDePort := XmlStrToFloat(CdeNode.ChildValues['FraisPort'], bOk);
        TotLigTTC          := ArrondiA2(TotLigTTC + Result.FraisDePort);
        if not(bOk) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Frais de port invalide !', Result.bValid);
        end
        else
        begin
          { TODO -oLP -cDonnées:Ajoute la TVA au frais de port s'ils sont HT. }
          if (Result.CommandeInfos.iExport = 1) then
          begin
            if not(IsZero(Result.FraisDePort, 0.01)) then
            begin
              Result.FraisDePort := Result.FraisDePort * (1 + GetFPTauxTVA(Dm_Common.MySiteParams.iCodeSite) / 100);
            end;
            Result.TotalTTC    := Result.TotalHT * (1 + GetFPTauxTVA(Dm_Common.MySiteParams.iCodeSite) / 100);
            Result.MontantTVA  := Result.TotalTTC - Result.TotalHT;
          end;

          fTauxFP := GetFPTauxTVA(Dm_Common.MySiteParams.iCodeSite);
          fTvaFP := (Result.FraisDePort - Result.FraisDePort * 100 / (100 + fTauxFP));
          fHTFP := Result.FraisDePort - fTvaFP;

          // Ajout des frais de port à totaux
          bTauxFPAdded := False;
          i := Low(Result.TVAS);
          while (i <= High(Result.TVAS)) and (not bTauxFPAdded) do
          begin
            if CompareValue(fTauxFP, Result.TVAS[i].TauxTva, 0.01) = EqualsValue then
            begin
              Result.TVAS[i].TotalHT := Result.TVAS[i].TotalHT + fHTFP;
              Result.TVAS[i].MtTVA := Result.TVAS[i].MtTVA + fTvaFP;
              bTauxFPAdded := True;
            end;
            inc(i);
          end; // while


          // Si on n'a pas pu ajouter le frais de port dans le tableau TVAS existant on ajoute un nouvel enregistrement
          if not bTauxFPAdded then
          begin
            if Length(Result.TVAS) = 5 then
            begin
              DoErreurGeneric(sXmlfile, 'Commande\TVAS', CdeNum, CdeId, NomCli, 0, '', '', 'A l''ajout d''une balise TVA pour les frais de port -> Trop de balise TVA ( >5 ) !', Result.bValid);
              bOkLesTva := False;
            end
            else
            begin
              i := Length(Result.TVAS);
              SetLength(Result.TVAS, i + 1);
              Result.TVAS[i].TauxTva := fTauxFP;
              Result.TVAS[i].TotalHT := fHTFP;
              Result.TVAS[i].MtTVA := fTvaFP;
            end;
          end;
        end;
      end;

      // Contrôle cohérence TotalHT + MontantTVA = TotalTTC
      if bOkTotCtrlHTetTTC and (Abs(ArrondiA2(Result.TotalTTC - Result.TotalHT - Result.MontantTVA)) > 0.02) then
      begin
        DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Total HT + Montant Tva différent de Total TTC !', Result.bValid);
      end;

      // Contrôle cohérence entre le ttc de toutes les lignes +Frais de port et le TotalTTC
      // pas de tolérance sur le TTC
      if bOkTotCtrlHTetTTC and bOkLesLignes and (Result.CommandeInfos.iExport = 0) then
      begin
        if (Abs(ArrondiA2(TotLigTTC - Result.TotalTTC)) > 0.05) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Total TTC des lignes + Frais de Port différent de Total TTC !', Result.bValid);
        end;
      end;

      // Controle NetPayer
      if not(IsBaliseExists(CdeNode, 'Netpayer')) then
      begin
        DoErreurBalise(sXmlfile, 'Commande', 'Balise Netpayer non trouvé', Result.bValid);
      end
      else
      begin
        Result.NetPayer := XmlStrToFloat(CdeNode.ChildValues['Netpayer'], bOk);
        if not(bOk) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Net à payer invalide !', Result.bValid);
        end;
      end;
      // ---------- /Controle des Totaux ----------------------------------------------

      // ---------- Reglements --------------------------------------------------------
      TotReglement                       := 0;
      Result.CommandeInfos.ModeReglement := '';
      Result.CommandeInfos.DateReglement := XmlStrToDate(CdeNode.ChildValues['DateReglement'], bOk);
      Result.Reglements                  := nil;

      if IsBaliseExists(CdeNode, 'Reglements') then
      begin
        // Mode multi-réglements : si présent ignore le mode mono-reglement (ancien mode)

        ReglementsNode := CdeNode.ChildNodes['Reglements'];
        SetLength(Result.Reglements, ReglementsNode.ChildNodes.Count);

        // Contrôle si il y a un mode de règlement
        if ReglementsNode.ChildNodes.Count = 0 then
        begin
          DoErreurGeneric(sXmlfile, 'Commande\Reglements', CdeNum, CdeId, NomCli, 0, '', '', 'Il faut au moins un mode de règlement !',
            Result.bValid);
          bOkLesReglements := False;
        end
        else
        begin
          for i := 0 to ReglementsNode.ChildNodes.Count - 1 do
          begin
            // Par défaut : contrôler la cohérence des modes de règlements
            bOkReglementsCtrl := True;
            ReglementNode     := ReglementsNode.ChildNodes[i];
            // Contrôle Mode
            if not(IsBaliseExists(ReglementNode, 'Mode')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', 'Balise Mode non trouvée', Result.bValid);
              bOkReglementsCtrl := False;
              bOkLesReglements  := False;
            end
            else
            begin
              Result.Reglements[i].Mode := XmlStrToStr(ReglementNode.ChildValues['Mode']);

              case CtrlValidStr(Result.Reglements[i].Mode, True, 32) of
                1:
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                      'Mode de règlement obligatoire', Result.bValid);
                  end;
                2:
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                      'Longueur Mode de règlement trop grande', Result.bValid);
                  end;
              end;

              if not ReglementExiste(Result.Reglements[i].Mode) then
                DoErreurGeneric(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', CdeNum, CdeId, NomCli, 0, '', '', 'Mode de règlement inconnu', Result.bValid);

              // Contrôle MontantTTC
              if not(IsBaliseExists(ReglementNode, 'MontantTTC')) then
              begin
                DoErreurBalise(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', 'Balise MontantTTC non trouvée', Result.bValid);
                bOkReglementsCtrl := False;
                bOkLesReglements  := False;
              end
              else
              begin
                Result.Reglements[i].MontantTTC := XmlStrToFloat(ReglementNode.ChildValues['MontantTTC'], bOk);
                if not(bOk) then
                begin
                  bOkReglementsCtrl := False;
                  bOkLesReglements  := False;
                  DoErreurGeneric(sXmlfile, 'Commande\Reglement (N° ' + IntToStr(Succ(i)) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                    'Montant TTC invalide !', Result.bValid);
                end
                else
                begin
                  TotReglement := TotReglement + Result.Reglements[i].MontantTTC;
                end;
              end;

              // Contrôle Date : obligatoire si commande payée
              if not(IsBaliseExists(ReglementNode, 'Date')) then
              begin
                if (Result.CommandeInfos.Statut <> 'PAYE') then
                  Result.Reglements[i].Date := XmlStrToDate(0, bOk)
                else
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', 'Balise Date non trouvée', Result.bValid);
                  bOkReglementsCtrl := False;
                  bOkLesReglements  := False;
                end;
              end
              else
              begin
                Result.Reglements[i].Date := XmlStrToDate(ReglementNode.ChildValues['Date'], bOk);
                if (not bOk) and (Result.CommandeInfos.Statut <> 'PAYE') then
                  Result.Reglements[i].Date := XmlStrToDate(0, bOk)
                else if (Result.CommandeInfos.Statut = 'PAYE') and ((DateOf(Result.Reglements[i].Date) = 0) or (not bOk)) then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\Reglement (N° ' + IntToStr(Succ(i)) + ')', CdeNum, CdeId, NomCli, 0, '', '',
                    'Date de règlement invalide', Result.bValid);
                end;
              end;

              // Contrôle ID_Bon_d_achat
              if (IsBaliseExists(ReglementNode, 'ID_Bon_d_achat')) then
              begin
                Result.Reglements[i].IdBonAchat := XmlStrToInt(ReglementNode.ChildValues['ID_Bon_d_achat']);

                if Result.Reglements[i].IdBonAchat <> 0 then
                begin
                  if not(Dm_Common.IsBonAchatValid(Result.Reglements[i].IdBonAchat, Result.Client.IdGinkoiaClient, Dm_Common.MySiteParams.iMagID)) then
                  begin
                    DoErreurBalise(sXmlfile, 'Commande\Reglement (N°' + IntToStr(Succ(i)) + ')', 'Balise bon d''achat non valide ou déjà utilisé',
                      Result.bValid);
                  end;
                end;
              end
              else
                Result.Reglements[i].IdBonAchat := 0;
            end;
          end; // for reglements[i]
          if (Result.CommandeInfos.iExport <> 0) and (TotReglement <> Result.TotalHT) then
            DoErreurGeneric(sXmlfile, 'Commande\Reglements', CdeNum, CdeId, NomCli, 0, '', '', 'Total Réglements <> Total HT', Result.bValid)
          else if (Result.CommandeInfos.iExport = 0) and (TotReglement <> Result.TotalTTC) then
            DoErreurGeneric(sXmlfile, 'Commande\Reglements', CdeNum, CdeId, NomCli, 0, '', '', 'Total Réglements <> Total TTC', Result.bValid);
        end;
      end
      else if IsBaliseExists(CdeNode, 'ModeReglement') then
      begin
        // Ancien Mode
        Result.CommandeInfos.ModeReglement := ShortString(XmlStrToStr(CdeNode.ChildValues['ModeReglement']));
        if CtrlValidStr(string(Result.CommandeInfos.ModeReglement), False, 32) = 2 then
          DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Longueur Mode de règlement trop grande', Result.bValid)
        else
        begin
          // Contrôle Date de règlement : obligatoire si commande payée
          if not(IsBaliseExists(CdeNode, 'DateReglement')) then
          begin
            if Result.CommandeInfos.Statut <> 'PAYE' then
              Result.CommandeInfos.DateReglement := XmlStrToDate(0, bOk)
            else
              DoErreurBalise(sXmlfile, 'Commande', 'Balise DateReglement non trouvé', Result.bValid);
          end
          else
          begin
            Result.CommandeInfos.DateReglement := XmlStrToDate(CdeNode.ChildValues['DateReglement'], bOk);
            if (not bOk) and (Result.CommandeInfos.Statut <> 'PAYE') then
              Result.CommandeInfos.DateReglement := XmlStrToDate(0, bOk)
            else if (Result.CommandeInfos.Statut = 'PAYE') and ((DateOf(Date) = 0) or (not bOk)) then
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Date de règlement invalide', Result.bValid)
            else if(Result.CommandeInfos.Statut = 'PAYE') and bOk then
            begin
              SetLength(Result.Reglements, 1);
              Result.Reglements[Low(Result.Reglements)].Mode := String(Result.CommandeInfos.ModeReglement);
              Result.Reglements[Low(Result.Reglements)].MontantTTC := Result.NetPayer;
              Result.Reglements[Low(Result.Reglements)].Date := Result.CommandeInfos.DateReglement;
              Result.Reglements[Low(Result.Reglements)].IdBonAchat := 0;

              if not ReglementExiste(Result.Reglements[Low(Result.Reglements)].Mode) then
                DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId, NomCli, 0, '', '', 'Mode de règlement inconnu', Result.bValid);
            end;
          end;
        end;
      end
      else
        DoErreurBalise(sXmlfile, 'Commande', 'Aucun mode de réglement n''est défini', Result.bValid);

      // ---------- /Reglements -------------------------------------------------------
    except
      on E: Exception do
      begin
        raise Exception.Create('DoXmlGenToRecord -> ' + E.Message);
      end;
    end;
  finally
    LstLot.Free;
  end;
end;

function ReglementExiste(const sMode: String): Boolean;
var
  nMAG_ID, nUSR_ID, nASS_ID, nPORTWEB_ID: Integer;
  Query: TIBOQuery;
begin
  Result := False;
  GetInfoParamWeb(Dm_Common.MySiteParams.iCodeSite, nMAG_ID, nUSR_ID, nASS_ID, nPORTWEB_ID);
  if nMAG_ID = 0 then
    Exit;

  Query := TIBOQuery.Create(nil);
  try
    Query.IB_Connection := Dm_Common.Ginkoia;
    Query.IB_Transaction := Dm_Common.IbT_Select;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select MEN_ID');
    Query.SQL.Add('from ARTMODEREGLWEB');
    Query.SQL.Add('join K on (MRW_ID = K_ID and K_ENABLED = 1)');
    Query.SQL.Add('join CSHMODEENC on (MRW_MENID = MEN_ID)');
    Query.SQL.Add('where MRW_ASSID = (select ASSID from FC_PARAMWEB(:CODESITE))');
    Query.SQL.Add('and MRW_CODEMEN = :CODE');
    try
      Query.ParamByName('CODESITE').AsInteger := Dm_Common.MySiteParams.iCodeSite;
      Query.ParamByName('CODE').AsString := sMode;
      Query.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('ReglementExiste -> ' + E.Message);
      end;
    end;
    Result := (not Query.IsEmpty);
  finally
    Query.Free;
  end;
end;

function XmlAdrToAdr(AFichier: string; ACde: TCde; XmlNode: IXmlNode; var
  bValid: boolean): stUneAdresse;
begin
  with XmlNode, Result do
  begin
    //Contrôle Civilité, pas oblig. long. max = 64    
    if not(IsBaliseExists(XmlNode,'Civ')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Civ non trouvé', bValid);
    end
    else begin
      sAdr_Civ := XmlStrToStr(ChildValues['Civ']);
      if CtrlValidStr(sAdr_Civ, false, 64) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          '', 0, '', '',
          'Longueur civilité trop grande',
          bValid);
      end;
    end;

    //Contrôle nom, oblig. long. max = 64
    if not(IsBaliseExists(XmlNode,'Nom')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Nom non trouvé', bValid);
    end
    else begin
      sAdr_Nom := XmlStrToStr(ChildValues['Nom']);
      case CtrlValidStr(sAdr_Nom, true, 64) of
        1: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Nom client obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Longueur nom client trop grande',
            bValid);
      end;
    end;

    //Contrôle prénom, pas oblig. long. max = 64
    if not(IsBaliseExists(XmlNode,'Prenom')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Prenom non trouvé', bValid);
    end
    else begin
      sAdr_Prenom := XmlStrToStr(ChildValues['Prenom']);
      if CtrlValidStr(sAdr_Prenom, false, 64) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur prénom trop grande',
          bValid);
      end;
    end;

    //Contrôle société, pas oblig. long. max = 64
    if not(IsBaliseExists(XmlNode,'Ste')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Ste non trouvé', bValid);
    end
    else begin
      sAdr_Ste := XmlStrToStr(ChildValues['Ste']);
      if CtrlValidStr(sAdr_Ste, false, 64) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur société trop grande',
          bValid);
      end;
    end;

    //Contrôle Adresse 1, oblig. long. max = 128
    if not(IsBaliseExists(XmlNode,'Adr1')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Adr1 non trouvé', bValid);
    end
    else begin
      sAdr_Adr1 := XmlStrToStr(ChildValues['Adr1']);
      case CtrlValidStr(sAdr_Adr1, true, 128) of
        1: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Adresse 1 obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Longueur adresse 1 trop grande',
            bValid);
      end;
    end;

    //Contrôle Adresse 2, pas oblig. long. max = 128
    if not(IsBaliseExists(XmlNode,'Adr2')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Adr2 non trouvé', bValid);
    end
    else begin
      sAdr_Adr2 := XmlStrToStr(ChildValues['Adr2']);
      if CtrlValidStr(sAdr_Adr2, false, 128) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur adresse 2 trop grande',
          bValid);
      end;
    end;

    //Contrôle Adresse 3, pas oblig. long. max = 128
    if not(IsBaliseExists(XmlNode,'Adr3')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Adr3 non trouvé', bValid);
    end
    else begin
      sAdr_Adr3 := XmlStrToStr(ChildValues['Adr3']);
      if CtrlValidStr(sAdr_Adr3, false, 128) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur adresse 3 trop grande',
          bValid);
      end;
    end;

    //Contrôle Code postal, oblig. long. max = 32
    if not(IsBaliseExists(XmlNode,'CP')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise CP non trouvé', bValid);
    end
    else begin
      sAdr_CP := XmlStrToStr(ChildValues['CP']);
      case CtrlValidStr(sAdr_CP, true, 32) of
        1: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Code postal obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Longueur code postal trop grande',
            bValid);
      end;
    end;

    //Contrôle Ville, oblig. long. max = 64
    if not(IsBaliseExists(XmlNode,'Ville')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Ville non trouvé', bValid);
    end
    else begin
      sAdr_Ville := XmlStrToStr(ChildValues['Ville']);
      case CtrlValidStr(sAdr_Ville, true, 64) of
        1: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Ville obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Longueur ville trop grande',
            bValid);
      end;
    end;

    //Contrôle Pays, oblig. long. max = 64
    if not(IsBaliseExists(XmlNode,'Pays')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Pays non trouvé', bValid);
    end
    else begin
      sAdr_Pays := XmlStrToStr(ChildValues['Pays']);
      case CtrlValidStr(sAdr_Pays, true, 64) of
        1: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Pays obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Longueur pays trop grande',
            bValid);
      end;
    end;

    //Contrôle Code ISO Pays, oblig. long. max = 2
    if not(IsBaliseExists(XmlNode,'PaysISO')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise PaysISO non trouvé', bValid);
    end
    else begin
      sAdr_PaysISO := XmlStrToStr(ChildValues['PaysISO']);
      case CtrlValidStr(sAdr_PaysISO, true, 2) of
        1: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Code ISO Pays obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            String(ACde.CommandeInfos.CommandeNum),
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Longueur Code ISO Pays trop grande',
            bValid);
      end;
    end;

    //Contrôle Tel, pas oblig. long. max = 32
    if not(IsBaliseExists(XmlNode,'Tel')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Tel non trouvé', bValid);
    end
    else begin
      sAdr_Tel := XmlStrToStr(ChildValues['Tel']);
      if CtrlValidStr(sAdr_Tel, false, 32) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur téléphone trop grande',
          bValid);
      end;
    end;

    //Contrôle gsm, pas oblig. long. max = 32
    if not(IsBaliseExists(XmlNode,'Gsm')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Gsm non trouvé', bValid);
    end
    else begin
      sAdr_Gsm := XmlStrToStr(ChildValues['Gsm']);
      if CtrlValidStr(sAdr_Gsm, false, 32) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur Gsm trop grande',
          bValid);
      end;
    end;

    //Contrôle fax, pas oblig. long. max = 32   
    if not(IsBaliseExists(XmlNode,'Fax')) then
    begin
      DoErreurBalise(AFichier, 'Commande\Client\' + XmlNode.NodeName,
                     'Balise Fax non trouvé', bValid);
    end
    else begin
      sAdr_Fax := XmlStrToStr(ChildValues['Fax']);
      if CtrlValidStr(sAdr_Fax, false, 32) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur fax trop grande',
          bValid);
      end;
    end;

    //Contrôle Comm, pas oblig. long. max = 1024      //SR : 30-11-2016 - Ajout pour prise en compte du commentaire dans l'adresse
    if IsBaliseExists(XmlNode,'Comm') then
    begin
      sAdr_Comm := XmlStrToStr(ChildValues['Comm']);
      if CtrlValidStr(sAdr_Comm, false, 1024) = 2 then
      begin
        DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
          String(ACde.CommandeInfos.CommandeNum),
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur Commentaire trop grande',
          bValid);
      end;
    end
    else
    begin
      sAdr_Comm := '';
    end;
  end;
end;

function XmlStrToFloat(Value: OleVariant; var bValid: boolean; const DefValue: Extended = 0.0): Extended;
var
  TpS: string;
begin  
  Result := DefValue;
  try
    //test si les bons caractères sont mis au bon endroit
    //mechant mais, ils n'ont qu'à prendre ATIPIC
    TpS:=XmlStrToStr(Value);
    if Pos(',',TpS)>0 then  //il ne faut pas de virgule !
    begin
      bValid:=false;
      exit;
    end;
    if Pos('.',Tps)=0 then   //pas de point = pas bon
    begin
      bValid:=false;
      exit;
    end;
    if Length(Copy(TpS,Pos('.',TpS)+1,Length(TpS)))<>2 then  //2 chiffres après la virgule oblig
    begin
      bValid:=false;
      exit;
    end;

    TpS[Pos('.', TpS)] := FormatSettings.DecimalSeparator;
    Result := StrToFloat(TpS);
    bValid := true;
    
  except
    on E: Exception do
      bValid:=false;
  end;
end;

function XmlStrToDate(Value: OleVariant; var bValid: boolean): TDateTime;
var
  FormatDateHeure: TFormatSettings;
begin
  // Un peu plus court...
  // Charge le format pour la France
  // -> http://msdn.microsoft.com/library/bb165625
  FormatDateHeure := TFormatSettings.Create($40C);
  FormatDateHeure.DateSeparator   := '-';
  FormatDateHeure.TimeSeparator   := ':';
  FormatDateHeure.ShortDateFormat := 'yyyy/mm/dd hh:nn:ss.z';

  // Vérifie et convertit la chaîne en date/heure
  bValid := TryStrToDateTime(XmlStrToStr(Value), Result, FormatDateHeure);
end;

function XmlStrToInt(Value: OleVariant; const DefValue: integer = 0): Integer;
begin
  if not VarIsNull(Value) then
    Result := StrToIntDef(Trim(Value), DefValue)
  else
    Result := 0;
end;

function XmlStrToStr(Value: OleVariant): string;
begin
  if not VarIsNull(Value) then
    Result := Trim(Value)
  else
    Result := '';
end;

function ArticlesToDB(TabArticles: TTabArticles): Boolean;
var
  i: Integer;
begin
  Result := true;
  for i:=Low(TabArticles) to High(TabArticles) do
  begin
    if TabArticles[i].bValide then
    begin
      Dm_Common.Que_Tmp.Close;
      Dm_Common.Que_Tmp.SQL.Clear;
      Dm_Common.Que_Tmp.SQL.Add('execute procedure CHAM3S_CREA_ARTICLE(:CODE_EAN, :ART_NOM, :REF_MRK, :TGF_NOM, :COU_NOM, :MRK_NOM, :RAY_NOM, :FAM_NOM, :SSF_NOM, :PRIX_ACHAT, :PRIX_VENTE, :TAUX_TVA, :CODE_SITE_WEB)');
      try
        Dm_Common.Que_Tmp.ParamByName('CODE_EAN').AsString := TabArticles[i].sCBArticle;
        Dm_Common.Que_Tmp.ParamByName('ART_NOM').AsString := TabArticles[i].sDesignation;
        Dm_Common.Que_Tmp.ParamByName('REF_MRK').AsString := TabArticles[i].sRefMarqueFournisseur;
        Dm_Common.Que_Tmp.ParamByName('TGF_NOM').AsString := TabArticles[i].sLibelleTaille;
        Dm_Common.Que_Tmp.ParamByName('COU_NOM').AsString := TabArticles[i].sLibelleCouleur;
        Dm_Common.Que_Tmp.ParamByName('MRK_NOM').AsString := TabArticles[i].sNomMarque;
        Dm_Common.Que_Tmp.ParamByName('RAY_NOM').AsString := TabArticles[i].sLibelleRayon;
        Dm_Common.Que_Tmp.ParamByName('FAM_NOM').AsString := TabArticles[i].sLibelleFamille;
        Dm_Common.Que_Tmp.ParamByName('SSF_NOM').AsString := TabArticles[i].sLibelleSousFamille;
        Dm_Common.Que_Tmp.ParamByName('PRIX_ACHAT').AsFloat := TabArticles[i].dPrixAchatHT;
        Dm_Common.Que_Tmp.ParamByName('PRIX_VENTE').AsFloat := TabArticles[i].dPrixVenteTTC;
        Dm_Common.Que_Tmp.ParamByName('TAUX_TVA').AsFloat := TabArticles[i].dTauxTVA;
        Dm_Common.Que_Tmp.ParamByName('CODE_SITE_WEB').AsInteger := Dm_Common.MySiteParams.iCodeSite;
        Dm_Common.Que_Tmp.ExecSQL;
      except
        on E: Exception do
        begin
          LogAction('# Erreur de création de l''article [' + TabArticles[i].sCBArticle + '][' + TabArticles[i].sDesignation + '] : ' + E.Message, 1);
          AddMonitoring('Erreur de création de l''article [' + TabArticles[i].sCBArticle
            + '][' + TabArticles[i].sDesignation + '] : ' + E.Message, logError,
            mdltImport, apptSyncWeb, Dm_Common.MySiteParams.iMagID);
          Result := false;
        end;
      end;
    end
    else
      Result := False;
  end;
end;

function DoGenCdeToDb(Cde: TCde): Boolean;
const
  PRM_CODE_TYPE_DOC = 306;
var
  i, j, iLotNum, iTkeId: Integer;
  ArtInfos: stArticleInfos;
  lstLot: TStringList;
  LineTmp: TLigneCDE;
  bLineCreate, bReglementsCreate, bCommandeExist, bIsFactureTechnique: Boolean;
  vCodeBarType: Integer;
begin
  Result := True;
  try
    bIsFactureTechnique := (Dm_Common.GetParamInteger(PRM_CODE_TYPE_DOC) = 2);
    // On vérifie que la commande n'existe pas encore, avec le numéro de la commande et commande ID

    if bIsFactureTechnique then
      bCommandeExist := isExistFacture(String(Cde.CommandeInfos.CommandeNum), Cde.CommandeInfos.CommandeId)
    else
      bCommandeExist := Dm_Common.CdeExists(Cde.CommandeInfos.CommandeId);

    if not bCommandeExist then
    begin
      Dm_Common.IbT_Modif.StartTransaction;
//      Que_Tmp.IB_Transaction.StartTransaction;
      iLotNum := 0;
      iTkeId  := 0;

      // Si elle n'existe pas, alors on va vérifier si le client n'exite pas encore.
      GenCreateClient(Cde.Client);

      // On va créer l'entete du bl / facture de la commande.
      if bIsFactureTechnique then
        GenCreateEnteteFacture(Cde, Cde.Reglements)
      else
        GenCreateEnteteBL(Cde, Cde.Reglements);

      // Puis on va créer les lignes du bl / facture de la commande.
      for i := Low(Cde.Lignes) to High(Cde.Lignes) do
      begin
        bLineCreate := False;
        Inc(iLotNum);
        Cde.Lignes[i].LotId := 0;
        Cde.Lignes[i].LotNum := 0;

        case AnsiIndexStr(Trim(UpperCase(String(Cde.Lignes[i].TypeLigne))), ['LIGNE', 'LOT', 'CODEPROMO']) of
          0:
            // Ligne.
            begin
              vCodeBarType := 1;
              if Cde.Lignes[i].CodeEAN <> '' then
                vCodeBarType := 3;

              ArtInfos := Dm_Common.GetArticleInfos(String(Cde.Lignes[i].Code), vCodeBarType);

              // Est-ce que l'article est valide ?
              if not ArtInfos.isValide then
                raise Exception.Create('La commande : ' + CDE.XmlFile + ' a un article incorrect : ' + String(Cde.Lignes[i].Code));

              if bIsFactureTechnique then
                bLineCreate := GenCreateLigneFacture(Cde, i + 1, ArtInfos, Cde.Lignes[i], False)
              else
                bLineCreate := GenCreateLineBL(Cde.CommandeInfos.CommandeId, ArtInfos, Cde.Lignes[i], iTkeId, Dm_Common.Que_Tmp.IB_Transaction);

              if not bLineCreate then
                raise Exception.Create('Problème lors de la création d''une ligne du BL : ' + IntToStr(Cde.CommandeInfos.CommandeId));
            end;

          1:
            // Lot.
            begin
              lstLot := TStringList.Create;
              try
                lstLot.Text := StringReplace(String(Cde.Lignes[i].Code), '*', #13#10, [rfReplaceAll]);
                LineTmp := Cde.Lignes[i];
                for j := 1 to Pred(lstLot.Count) do
                begin
                  LineTmp.LotId := StrToIntDef(Trim(lstLot[0]), 0);
                  LineTmp.LotNum := iLotNum;
                  ArtInfos := Dm_Common.GetArticleInfos(Trim(lstLot[j]));

                  // Est-ce que l'article est valide ?
                  if not ArtInfos.isValide then
                    raise Exception.Create('La commande : ' + CDE.XmlFile + ' a un lot incorrect : ' + IntToStr(LineTmp.LotId));

                  bLineCreate := GenCreateLineBL(Cde.CommandeInfos.CommandeId, ArtInfos, LineTmp, iTkeId, Dm_Common.Que_Tmp.IB_Transaction);
                  if not bLineCreate then
                    raise Exception.Create('Problème lors de la création d''un lot du BL :' + IntToStr(Cde.CommandeInfos.CommandeId));
                end;
              finally
                lstLot.Free;
              end;
            end;

          2:
            // CodePromo.
            begin
              ArtInfos.iArtId := StrToInt(Trim(String(Cde.Lignes[i].Code)));
              // C'est l'artid dans l'xml contrairement aux autres où c'est le CB.
              ArtInfos.iTgfId := 0;
              ArtInfos.iCouId := 0;
              //ArtInfos.fPxAchat := -Abs(Cde.Lignes[i].PXHT);
              ArtInfos.fPxAchat := Cde.Lignes[i].PXHT;
              //ArtInfos.fPxBrut := -Abs(Cde.Lignes[i].PUBrutHT);
              ArtInfos.fPxBrut := Cde.Lignes[i].PUBrutHT;
              ArtInfos.fTVA := 0;

              // Au cas où on met négatif les codepromo.
              //Cde.Lignes[i].PUBrutHT := -Abs(Cde.Lignes[i].PUBrutHT);
              //Cde.Lignes[i].PUBrutTTC := -Abs(Cde.Lignes[i].PUBrutTTC);
              //Cde.Lignes[i].PUHT := -Abs(Cde.Lignes[i].PUHT);
              //Cde.Lignes[i].PXHT := -Abs(Cde.Lignes[i].PXHT);
              //Cde.Lignes[i].PXTTC := -Abs(Cde.Lignes[i].PXTTC);

              if bIsFactureTechnique then
                bLineCreate := GenCreateLigneFacture(Cde, i, ArtInfos, Cde.Lignes[i], True)
              else
                bLineCreate := GenCreateLineBL(Cde.CommandeInfos.CommandeId, ArtInfos, Cde.Lignes[i], iTkeId, Dm_Common.Que_Tmp.IB_Transaction);

              if not bLineCreate then
                raise Exception.Create('Problème lors de la création d''un code promo du BL :' + IntToStr(Cde.CommandeInfos.CommandeId));
            end;
        else
          // Autres.
          raise Exception.Create('Type de ligne inconnu : ' + String(Cde.Lignes[i].TypeLigne) + ' - ' + IntToStr(Cde.CommandeInfos.CommandeId));
        end;
      end;

      if bIsFactureTechnique then
        GestionFidelite(Cde, Cde.Client);

      // Gére les règlements.
      if Assigned(Cde.Reglements) and (Cde.CommandeInfos.Statut = 'PAYE') then
      begin
        bReglementsCreate := GenCreateReglements(Cde.CommandeInfos.CommandeId, Cde.Reglements, iTkeId);
        if not(bReglementsCreate) then
          raise Exception.Create(Format('Problème lors de la création des règlements : %d', [Cde.CommandeInfos.CommandeId]));
      end;

      Dm_Common.IbT_Modif.Commit;

      // Gère les colis (après le Commit pour que le BL soit dans la base).
      if Frm_Main.ModuleIsEnabled(cMdl_WMS) and ((Cde.Colis.Numero <> '') or (Cde.Colis.CodeTransporteur <> '')) then
      begin
        FTableNegColisUtils.Transaction := Dm_Common.Que_Tmp.IB_Transaction;
        try
          Dm_Common.IbT_Modif.StartTransaction;
          try
            FTableNegColisUtils.AddColis(Cde.CommandeInfos.CommandeId, Cde.Colis.Numero, Cde.Colis.CodeTransporteur, Cde.Colis.Transporteur, Cde.Colis.CodeProduit, Cde.Colis.MagasinRetrait, Cde.Colis.CodeRelais);
            Dm_Common.IbT_Modif.Commit;
          except
            on E: Exception do
            begin
              Dm_Common.IbT_Modif.Rollback;
              raise;
            end;
          end;
        finally
          FTableNegColisUtils.Transaction := nil;
        end;
      end;

//      Que_Tmp.IB_Transaction.Commit;
    end
    else      // La commande existe déjà.
    begin
      raise Exception.Create('***  Erreur dans le fichier de commande: ' + ExtractFileName(Cde.XmlFile) + '  ***' + #13#10 +
                    '    N° Commande = ' + String(Cde.CommandeInfos.CommandeNum) + #13#10 +
                    '    Id Commande = ' + IntToStr(Cde.CommandeInfos.CommandeId) + #13#10 +
                    '    Erreur = La commande existe déjà !' + #13#10);
    end;
  except
    on E: Exception do
    begin
      Dm_Common.IbT_Modif.Rollback;
//      Que_Tmp.IB_Transaction.Rollback;
      raise Exception.Create('DoGenCdeToDb -> ' + E.Message);
    end;
  end;
end;

function GenCreateEnteteBL(Cde: TCDE; AReglements: TReglementsCDE): Boolean;
var
//  Reglement: TReglement;
  i: integer;
begin
  Result := True;

  if (Cde.Client.IdGinkoiaClient = 0) then
    raise Exception.Create('Aucun client trouvé pour un éventuel rapprochement. Insertion du bon de livraison annulée.');

  try
    Dm_Common.Que_Tmp.Close;
    Dm_Common.Que_Tmp.SQL.Clear;
    Dm_Common.Que_Tmp.Params.Clear;
    Dm_Common.Que_Tmp.SQL.Add('EXECUTE PROCEDURE TF_WEBG_CREER_BL(:CLTID, :ID_COMMANDE, :NUM_COMMANDE,');
    Dm_Common.Que_Tmp.SQL.Add(':MT_TTC1, :MT_HT1, :MT_TAUX_HT1, :MT_TTC2, :MT_HT2, :MT_TAUX_HT2, :MT_TTC3, :MT_HT3,');
    Dm_Common.Que_Tmp.SQL.Add(':MT_TAUX_HT3, :MT_TTC4, :MT_HT4, :MT_TAUX_HT4, :MT_TTC5, :MT_HT5, :MT_TAUX_HT5, :REMISE,');
    Dm_Common.Que_Tmp.SQL.Add(':COMENT, :HTWORK, :CODE_SITE_WEB, :DATE_CREATION, :DATE_PAIEMENT, :MONTANT_FRAIS_PORT,');
    Dm_Common.Que_Tmp.SQL.Add(':DETAXE, :ID_PAIEMENT_TYPE, :NOM_CLIENT_LIVR, :PRENOM_CLIENT_LIVR, :CODERELAIS)');
    Dm_Common.Que_Tmp.ParamCheck := True;

    Dm_Common.Que_Tmp.ParamByName('CLTID').AsInteger := Cde.Client.IdGinkoiaClient;
    Dm_Common.Que_Tmp.ParamByName('ID_COMMANDE').AsInteger := Cde.CommandeInfos.CommandeId;
    Dm_Common.Que_Tmp.ParamByName('NUM_COMMANDE').AsString := String(Cde.CommandeInfos.CommandeNum);

    for i := 1 to 5 do // init à 0 des 5 champs TVA
    begin
      Dm_Common.Que_Tmp.ParamByName(AnsiString('MT_TTC' + IntToStr(i))).AsFloat := 0;
      Dm_Common.Que_Tmp.ParamByName(AnsiString('MT_HT' + IntToStr(i))).AsFloat := 0;
      Dm_Common.Que_Tmp.ParamByName(AnsiString('MT_TAUX_HT' + IntToStr(i))).AsFloat := 0;
    end;

    for i := 0 to High(Cde.TVAS) do
    begin
      if i < 5 then
      begin
        Dm_Common.Que_Tmp.ParamByName(AnsiString('MT_TTC' + IntToStr(i + 1))).AsFloat := Cde.TVAS[i].TotalHT + Cde.TVAS[i].MtTVA;
        Dm_Common.Que_Tmp.ParamByName(AnsiString('MT_HT' + IntToStr(i + 1))).AsFloat := Cde.TVAS[i].TotalHT;
        Dm_Common.Que_Tmp.ParamByName(AnsiString('MT_TAUX_HT' + IntToStr(i + 1))).AsFloat := Cde.TVAS[i].TauxTva;
      end;
    end;

    Dm_Common.Que_Tmp.ParamByName('REMISE').AsFloat := 0;

    //SR - 26/10/2016 - Pour Bavoux on inverse l'information.
    Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := '';

    if Cde.Colis.Transporteur <> '' then
      Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := Dm_Common.Que_Tmp.ParamByName('COMENT').AsString +
        'Transporteur : ' + Cde.Colis.Transporteur + #13#10;
    if Cde.Colis.CodeTransporteur <> '' then
      Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := Dm_Common.Que_Tmp.ParamByName('COMENT').AsString +
        'Code Transporteur : ' + Cde.Colis.CodeTransporteur + #13#10;
    if Cde.Colis.CodeProduit <> '' then
      Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := Dm_Common.Que_Tmp.ParamByName('COMENT').AsString +
        'Code Produit: ' + Cde.Colis.CodeProduit + #13#10;
    if Cde.Colis.MagasinRetrait <> '' then
      Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := Dm_Common.Que_Tmp.ParamByName('COMENT').AsString +
        'Magasin retrait : ' + Cde.Colis.MagasinRetrait + #13#10;

    Dm_Common.Que_Tmp.ParamByName('CODERELAIS').AsString := Cde.Colis.CodeRelais;

    if Cde.InfosSupp <> '' then
      Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := Dm_Common.Que_Tmp.ParamByName('COMENT').AsString +
        'Info Sup : ' + Cde.InfosSupp + #13#10;

    Dm_Common.Que_Tmp.ParamByName('COMENT').AsString := Dm_Common.Que_Tmp.ParamByName('COMENT').AsString +
      'Numéro de commande : ' + String(Cde.CommandeInfos.CommandeNum);

    //   case CommandeInfos.iExport of
    //     0: begin
    Dm_Common.Que_Tmp.ParamByName('HTWORK').AsInteger := Cde.CommandeInfos.iExport;
    Dm_Common.Que_Tmp.ParamByName('DETAXE').AsInteger := Cde.CommandeInfos.iExport;

    //   end;
   //    1: begin
   //      Que_Commande.ParamByName('HTWORK').AsInteger := 0;
   //      Que_Commande.ParamByName('DETAXE').AsInteger := 0;
  //     end;
  //   end;

    Dm_Common.Que_Tmp.ParamByName('CODE_SITE_WEB').AsInteger := Dm_Common.MySiteParams.iCodeSite;
    Dm_Common.Que_Tmp.ParamByName('DATE_CREATION').AsDateTime := Cde.CommandeInfos.CommandeDate;
    Dm_Common.Que_Tmp.ParamByName('MONTANT_FRAIS_PORT').AsFloat := Cde.FraisDePort;

    // si mode multiréglements, alors ModeReglement et DateReglement sont vide
    // si on les mets dans les param, la procédure ne créditera pas le client (date = 0)
    // le réglement sera géré plus tard

    if Cde.CommandeInfos.ModeReglement <> '' then
    begin
      Dm_Common.Que_Tmp.ParamByName('ID_PAIEMENT_TYPE').AsString := String(Cde.CommandeInfos.ModeReglement);
      // si pas payé, on met date = 0 (ça crédite pas le client)
      if (Cde.CommandeInfos.Statut = 'PAYE') and (DateOf(Cde.CommandeInfos.DateReglement) <> 0) then
      begin
        Dm_Common.Que_Tmp.ParamByName('DATE_PAIEMENT').AsDateTime := Cde.CommandeInfos.DateReglement;
      end
      else
      begin
        Dm_Common.Que_Tmp.ParamByName('DATE_PAIEMENT').AsDateTime := DateOf(0);
      end;
    end;

//      end
//      else
//      begin
//        for Reglement in AReglements do
//        begin
//          ParamByName('ID_PAIEMENT_TYPE').AsString := Reglement.Mode;
//          ParamByName('DATE_PAIEMENT').AsDateTime := Reglement.Date;
//          Break;  //SR - 09/06/2015 - Pour ne prendre que le premier correction rappide de prod, voir si nous devons prendre en compte tout les mode pour l'affichage.
//        end;
//      end;

    //iPaiement;
    //SR - 01/12/2016 - Concaténation des 2 champs.
    Dm_Common.Que_Tmp.ParamByName('NOM_CLIENT_LIVR').AsString := Copy(Cde.Client.AdresseLivr.sAdr_Ste + ' ' + Cde.Client.AdresseLivr.sAdr_Nom, 1, 63);
    Dm_Common.Que_Tmp.ParamByName('PRENOM_CLIENT_LIVR').AsString := Cde.Client.AdresseLivr.sAdr_Prenom;

    Dm_Common.Que_Tmp.ExecSQL;

  except on E: Exception do
      raise Exception.Create('GenCreateEnteteBL -> ' + E.Message);
  end;
end;

function GenCreateLineBL(ID_COMMANDE: Integer; ArtInfos: stArticleInfos; LigneCDE: TLigneCDE; var ATkeId: Integer; ATransaction: TIB_Transaction): boolean;
var
  Query: TIBOQuery;
begin
  Result := True;
  try
    Query := TIBOQuery.Create(nil);
    try
      Query.IB_Connection := Dm_Common.Ginkoia;
      Query.IB_Transaction := ATransaction;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('SELECT RTKEID FROM WEBG_CREER_BLLINE( :ID_COMMANDE, :ID_PRODUIT, :ID_TAILLE,');
      Query.SQL.Add(':ID_COULEUR, :ID_PACK, :NUM_LOT, :ID_CODE_PROMO, :QTE, :PX_BRUT, :PX_NET,');
      Query.SQL.Add(':PX_NET_NET, :POINTURE, :LONGUEUR, :MONTAGE_FIXATIONS, :INFO_SUP, :TYPE_VTE,');
      Query.SQL.Add(':CODE_SITE_WEB, :FIDELITE, :TKEID, :TAUX_TVA);');
      Query.ParamCheck := True;

      Query.ParamByName('ID_COMMANDE').AsInteger := ID_COMMANDE;
      Query.ParamByName('ID_PRODUIT').AsInteger := ArtInfos.iArtId;
      Query.ParamByName('ID_TAILLE').AsInteger := ArtInfos.iTgfId;
      Query.ParamByName('ID_COULEUR').AsInteger := ArtInfos.iCouId;
      Query.ParamByName('ID_PACK').AsInteger := LigneCDE.LotId;
      Query.ParamByName('NUM_LOT').AsInteger := LigneCDE.LotNum;
      Query.ParamByName('ID_CODE_PROMO').AsInteger := 0;
      Query.ParamByName('QTE').AsInteger := Trunc(LigneCDE.Qte);
      Query.ParamByName('PX_BRUT').AsFloat := LigneCDE.PUBrutTTC; // ArtInfos.fPxBrut;
      //    IF Trunc(LigneCDE.Qte) <> 0 THEN
      Query.ParamByName('PX_NET').AsFloat := LigneCDE.PXTTC; // / Trunc(LigneCDE.Qte)
      //    ELSE
      //      ParamByName('PX_NET').AsFloat        := LigneCDE.PUTTC;

      Query.ParamByName('PX_NET_NET').AsFloat := LigneCDE.PUTTC;

      Query.ParamByName('POINTURE').AsString := '';
      Query.ParamByName('LONGUEUR').AsString := '';
      Query.ParamByName('MONTAGE_FIXATIONS').AsInteger := 1;
      Query.ParamByName('POINTURE').AsString := '';
      Query.ParamByName('INFO_SUP').AsString := '';
      Query.ParamByName('TYPE_VTE').AsInteger := 1;

      Query.ParamByName('CODE_SITE_WEB').AsInteger := Dm_Common.MySiteParams.iCodeSite;
      if (LigneCDE.Fidelite = 0) then
        Query.ParamByName('FIDELITE').AsInteger := 0
      else
        Query.ParamByName('FIDELITE').AsInteger := Dm_Common.GetFidelite(Dm_Common.MySiteParams.iMagID, LigneCDE.PXTTC) * LigneCDE.Fidelite;
      Query.ParamByName('TKEID').AsInteger := ATkeId;
      Query.ParamByName('TAUX_TVA').AsFloat := LigneCDE.TxTVA;
      Query.Open;
      ATkeId := Query.FieldByName('RTKEID').AsInteger;

    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      LogAction('Ligne Erreur : ' + E.Message, 0);
      raise Exception.Create('GenCreateLineBL -> ' + E.Message);
    end;
  end;
end;

function GenCreateReglements(AIdCommande: Integer; AReglements: TReglementsCDE; var ATkeId: Integer): Boolean;
var
  Reglement: TReglement;
begin
  with Dm_Common do
  try
    Result := True;
    if Que_Tmp.Active then
      Que_Tmp.Close();
    Que_Tmp.SQL.Clear();
    Que_Tmp.SQL.Add('SELECT RTKEID FROM WEBG_REGLEMENT(:ID_PAIMENT_TYPE, :MONTANT, :ID_COMMANDE,');
    Que_Tmp.SQL.Add(':DATE_REGLEMENT, :ID_BON_ACHAT, :CODE_SITE_WEB, :TKEID);');

    for Reglement in AReglements do
    begin
      try
        Que_Tmp.ParamByName('ID_PAIMENT_TYPE').AsString   := Reglement.Mode;
        Que_Tmp.ParamByName('MONTANT').AsCurrency         := Reglement.MontantTTC;
        Que_Tmp.ParamByName('ID_COMMANDE').AsInteger      := AIdCommande;
        Que_Tmp.ParamByName('DATE_REGLEMENT').AsDateTime  := Reglement.Date;
        Que_Tmp.ParamByName('ID_BON_ACHAT').AsInteger     := Reglement.IdBonAchat;
        Que_Tmp.ParamByName('CODE_SITE_WEB').AsInteger    := Dm_Common.MySiteParams.iCodeSite;
        Que_Tmp.ParamByName('TKEID').AsInteger            := ATkeId;
        Que_Tmp.Open();
        ATkeId := Que_Tmp.FieldByName('RTKEID').AsInteger;
      finally
        Que_Tmp.Close();
      end;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      LogAction('Règlement Erreur : ' + E.Message, 0);
      raise Exception.Create('GenCreateReglements -> ' + E.Message);
    end;
  end;
end;

function SearchClientID(Client: TClientCde): integer;
const
  PRM_CODE_SEARCH_CLT_TYPE = 233;
var
  vCLT_ID : integer;
  vSearchClientType : integer;
begin
  Result := 0;

  vSearchClientType := Dm_Common.GetParamInteger(PRM_CODE_SEARCH_CLT_TYPE);

  // Si GENPARAM(9, 233).PRM_INTEGER = 1, recherche sur adresse mail directement
  if (vSearchClientType = 1) then
  begin
    vCLT_ID := Dm_Common.GetClientByEmailFacturation(String(Client.Email));
    if (vCLT_ID = 0) then
      vCLT_ID := Dm_Common.GetClientByEmailLivraison(String(Client.Email));
  end
  else
  begin
    vCLT_ID := Dm_Common.GetClientByIDREF(Client.Codeclient);
    if (vCLT_ID = 0) then
      vCLT_ID := Dm_Common.GetClientByEmailFacturation(String(Client.Email));
    if (vCLT_ID = 0) then
      vCLT_ID := Dm_Common.GetClientByEmailLivraison(String(Client.Email));
  end;

  Result := vCLT_ID;
end;

function GenCreateClient(var Client: TClientCde): Boolean;
const
  PRM_CODE_TYPE_DOC = 306;
  PRM_CODE_UPSERT_CLIENT_ACTIF = 235;
var
  sPays: string;
  bIsFactureTechnique, bNeedUpsertclient : boolean;
begin
  Result := False;

  bIsFactureTechnique := (Dm_Common.GetParamInteger(PRM_CODE_TYPE_DOC) = 2);
  bNeedUpsertclient := (Dm_Common.GetParamInteger(PRM_CODE_UPSERT_CLIENT_ACTIF) = 1);

  // Chullanka - Lot 3 : on essaye de rapprocher le client avant l'appel à la procédure stockée
  // car plus facile en algo que par des EXECUTE STATEMENT à la con dans la procédure stockée
  // Si CLTID renseingé en paramètre de la procédure stockée, on shunte la recherche du client dedans.
  Client.IdGinkoiaClient := SearchClientID(Client);
  LogAction('CLT_ID trouvé : ' + IntToStr(Client.IdGinkoiaClient), 3);

  // Si intégration facture et pas besoin de mettre à jour le client, on sort
  if not bNeedUpsertclient then
    Exit;

  with Dm_Common do
  try
    try
      with Client do
      begin
        Que_ClientGenerique.Close;
        Que_ClientGenerique.ParamCheck := True;
        Que_ClientGenerique.ParamByName('CLTID').AsInteger     := IdGinkoiaClient;
        Que_ClientGenerique.ParamByName('ID_CLIENT').AsInteger := Codeclient;
        Que_ClientGenerique.ParamByName('SMS').AsInteger       := Sms;
        Que_ClientGenerique.ParamByName('MAILING').AsInteger   := Mailing;
        // adresse de facturation
        with AdresseFact do
        begin
          sPays := UpperCase(StrEnleveAccents(sAdr_Pays));
          if Pos('FRANCE', sPays) > 0 then
          begin
            sPays := 'FRANCE';
          end;
          Que_ClientGenerique.ParamByName('NOM_CLIENT').AsString              := sAdr_Nom;
          Que_ClientGenerique.ParamByName('PRENOM_CLIENT').AsString           := sAdr_Prenom;
          Que_ClientGenerique.ParamByName('EMAIL_CLIENT').AsString            := LowerCase(String(Email));
          Que_ClientGenerique.ParamByName('ADRESSE_FACTURATION').AsString     := AnsiReplaceStr(sAdr_Adr1 + RC + sAdr_Adr2 + RC + sAdr_Adr3, 'ð', '');
          Que_ClientGenerique.ParamByName('CP_CLIENT').AsString               := sAdr_CP;
          Que_ClientGenerique.ParamByName('VILLE_CLIENT').AsString            := sAdr_Ville;
          Que_ClientGenerique.ParamByName('ID_PAYS').AsInteger                := GetOrCreatePayID(sPays, sAdr_PaysISO);
          Que_ClientGenerique.ParamByName('TEL_CLIENT_FACTURATION').AsString  := sAdr_Tel;
          Que_ClientGenerique.ParamByName('GSM_CLIENT_FACTURATION').AsString  := sAdr_Gsm;
          Que_ClientGenerique.ParamByName('FAX_CLIENT_FACTURATION').AsString  := sAdr_Fax;
          Que_ClientGenerique.ParamByName('COM_FACTURATION').AsString         := sAdr_Comm;
        end;

        // Adresse de livraison
        with AdresseLivr do
        begin
          sPays := UpperCase(StrEnleveAccents(sAdr_Pays));
          if Pos('FRANCE', sPays) > 0 then
          begin
            sPays := 'FRANCE';
          end;
          Que_ClientGenerique.ParamByName('NOM_CLIENT_LIVRAISON').AsString      := sAdr_Nom;
          Que_ClientGenerique.ParamByName('PRENOM_CLIENT_LIVRAISON').AsString   := sAdr_Prenom;
          Que_ClientGenerique.ParamByName('EMAIL_CLIENT_LIVRAISON').AsString    := LowerCase(String(Email));
          Que_ClientGenerique.ParamByName('ADRESSE_LIVRAISON').AsString         := AnsiReplaceStr(sAdr_Adr1 + RC + sAdr_Adr2 + RC + sAdr_Adr3, 'ð', '');
          Que_ClientGenerique.ParamByName('CP_CLIENT_LIVRAISON').AsString       := sAdr_CP;
          Que_ClientGenerique.ParamByName('VILLE_CLIENT_LIVRAISON').AsString    := sAdr_Ville;
          Que_ClientGenerique.ParamByName('ID_PAYS_LIVRAISON').AsInteger        := GetOrCreatePayID(sPays, sAdr_PaysISO);
          Que_ClientGenerique.ParamByName('TEL_CLIENT_LIVRAISON').AsString      := sAdr_Tel;
          Que_ClientGenerique.ParamByName('GSM_CLIENT_LIVRAISON').AsString      := sAdr_Gsm;
          Que_ClientGenerique.ParamByName('FAX_CLIENT_LIVRAISON').AsString      := sAdr_Fax;
          Que_ClientGenerique.ParamByName('COM_LIVRAISON').AsString             := sAdr_Comm;
        end;

        Que_ClientGenerique.ParamByName('NUM_SIRET').AsString := '';
        Que_ClientGenerique.ParamByName('NUM_TVA').AsString   := '';
        Que_ClientGenerique.ParamByName('CLT_MDP').AsString   := '';
      
        Que_ClientGenerique.Open;

        if not Que_ClientGenerique.IsEmpty then
        begin
          IdGinkoiaClient := Que_ClientGenerique.FieldByName('IDGINKOIACLIENT').AsInteger;
          Result := True;
        end;
      end; // with Que_ClientGenerique
    except on E: Exception do
        raise Exception.Create('GenCreateClient -> ' + E.Message);
    end;
  finally
    Que_ClientGenerique.Close;
  end;
end;


function GenCreateLigneCompteClient(Cde: TCDE; AMAG_ID : integer): boolean;
var
  vQuery:  TIBOQuery;
begin
  Result := True;
  vQuery := TIBOQuery.Create(nil);
  try
    vQuery.IB_Connection := Dm_Common.Ginkoia;
    vQuery.IB_Transaction := Dm_Common.IbT_Modif;
    try
      vQuery.SQL.Text := 'insert into CLTCOMPTE (CTE_ID, CTE_CLTID, CTE_MAGID, CTE_LIBELLE, CTE_DATE, CTE_DEBIT, CTE_REGLER, CTE_FCEID, CTE_IDPIECE)' +
                         'values(:PID, :PCLTID, :PMAGID, :PLIBELLE, :PDATE, :PDEBIT, :PREGLER, :PFCEID, :PIDPIECE)';

      vQuery.ParamByName('PID').AsInteger      := NewK('CLTCOMPTE');
      vQuery.ParamByName('PCLTID').AsInteger   := Cde.Client.IdGinkoiaClient;
      vQuery.ParamByName('PMAGID').AsInteger   := AMAG_ID;
      vQuery.ParamByName('PLIBELLE').AsString  := 'Facture ' + String(Cde.CommandeInfos.CommandeNum);
      vQuery.ParamByName('PDATE').AsDateTime   := Now();
      vQuery.ParamByName('PDEBIT').AsFloat     := Cde.TotalTTC;
      vQuery.ParamByName('PREGLER').AsDateTime := Cde.CommandeInfos.DateReglement;
      vQuery.ParamByName('PFCEID').AsInteger   := Cde.iIDGinkoia;
      vQuery.ParamByName('PIDPIECE').AsInteger := 0;

      vQuery.ExecSQL;
    except
      on E : Exception do
        Exception.Create('GenCreateLigneCompteClient -> ' + E.Message);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function GenCreateEnteteFacture(var Cde: TCDE; AReglements: TReglementsCDE): Boolean;
const
  SOURCE = 'SYNCWEB';
  TABLENAME = 'NEGFACTURE';
var
  i : integer;
  vQuery:  TIBOQuery;
  vLigneCDE : TLigneCDE;
  vTauxTVA, vHT : Currency;
  vArtInfos : stArticleInfos;
  vMRG_ID, vCPA_ID : integer;
  vMAG_ID, vUSR_ID, vASS_ID, vPORTWEB_ID : integer;
begin
  Result := True;
  if (Cde.Client.IdGinkoiaClient = 0) then
    raise Exception.Create('Aucun client trouvé pour un éventuel rapprochement. Insertion de la facture annulée.');

  GetInfoParamWeb(Dm_Common.MySiteParams.iCodeSite, vMAG_ID, vUSR_ID, vASS_ID, vPORTWEB_ID);
  if (vMAG_ID = 0) then
    Exit;

  // Récupération info mode règlement web
  GetInfoReglementWeb(vASS_ID, String(Cde.CommandeInfos.ModeReglement), vMRG_ID, vCPA_ID);

  vQuery := TIBOQuery.Create(nil);
  try
    vQuery.IB_Connection := Dm_Common.Ginkoia;
    vQuery.IB_Transaction := Dm_Common.IbT_Modif;
    try
      Cde.iIDGinkoia := NewK(TABLENAME);

      vQuery.SQL.Text := 'INSERT INTO ' + TABLENAME + '(FCE_ID, FCE_SOURCE, FCE_IDEXTERNE, FCE_DATE, FCE_REGLEMENT, FCE_DTREGLER, FCE_SEQUENCE, ' +
                         '   FCE_COMENT, FCE_NUMCDE, FCE_NUMERO, FCE_MAGID, FCE_REMISE, FCE_USRID, FCE_TYPE, FCE_DETAXE, FCE_CLOTURE, ' +
                         '   FCE_ARCHIVE, FCE_TVAHT1, FCE_TVA1, FCE_TVATAUX1, FCE_TVAHT2, FCE_TVA2, FCE_TVATAUX2, FCE_TVAHT3, FCE_TVA3, FCE_TVATAUX3, ' +
                         '   FCE_TVAHT4, FCE_TVA4, FCE_TVATAUX4, FCE_TVAHT5, FCE_TVA5, FCE_TVATAUX5, FCE_MARGE, FCE_CPAID, FCE_MRGID, FCE_HTWORK, ' +
                         '   FCE_NMODIF, FCE_WEB, FCE_REGLER, FCE_CLTID, FCE_CLTNOM, FCE_CLTPRENOM, FCE_ADRLIGNE, FCE_VILID, FCE_PRO, ' +
                         '   FCE_PRENEUR, FCE_CLTIDPRO, FCE_IDWEB, FCE_DATECLOTURE, FCE_EXPORT, FCE_DTEXPORT, FCE_CIVID, FCE_TYPID, ' +
                         '   FCE_CODESITEWEB, FCE_MAGENSEIGNE, FCE_MAGADRID, FCE_VENDEURNOM) ' +
                         'VALUES (:PID, :PSOURCE, :PIDEXTERNE, :PDATE, :PREGLEMENT, :PDTREGLER, :PSEQUENCE, ' +
                         '   :PCOMENT, :PNUMCDE, :PNUMERO, :PMAGID, :PREMISE, :PUSRID, :PTYPE, :PDETAXE, :PCLOTURE, ' +
                         '   :PARCHIVE, :PTVAHT1, :PTVA1, :PTVATAUX1, :PTVAHT2, :PTVA2, :PTVATAUX2, :PTVAHT3, :PTVA3, :PTVATAUX3, ' +
                         '   :PTVAHT4, :PTVA4, :PTVATAUX4, :PTVAHT5, :PTVA5, :PTVATAUX5, :PMARGE, :PCPAID, :PMRGID, :PHTWORK, ' +
                         '   :PNMODIF, :PWEB, :PREGLER, :PCLTID, :PCLTNOM, :PCLTPRENOM, :PADRLIGNE, :PVILID, :PPRO, ' +
                         '   :PPRENEUR, :PCLTIDPRO, :PIDWEB, :PDATECLOTURE, :PEXPORT, :PDTEXPORT, ' +
                         '   (SELECT CLT_CIVID FROM (CLTCLIENT JOIN K ON K_ID = CLT_ID AND K_ENABLED = 1) WHERE CLT_ID = :PCLTID), ' +     // FCE_CIVID
                         '   (SELECT TYP_ID FROM GENTYPCDV WHERE TYP_CATEG = 9 AND TYP_COD = 901), ' +                                     // FCE_TYPID
                         '   (SELECT ASS_CODE FROM (ARTSITEWEB JOIN K ON K_ID = ASS_ID AND K_ENABLED = 1) WHERE ASS_ID = :PASSID), ' +     // FCE_CODESITEWEB
                         '   (SELECT MAG_ENSEIGNE FROM (GENMAGASIN JOIN K ON K_ID = MAG_ID AND K_ENABLED = 1) WHERE MAG_ID = :PMAGID), ' + // FCE_MAGENSEIGNE
                         '   (SELECT MAG_ADRID FROM (GENMAGASIN JOIN K ON K_ID = MAG_ID AND K_ENABLED = 1) WHERE MAG_ID = :PMAGID), ' +    // FCE_MAGADRID
                         '   (SELECT USR_FULLNAME FROM (UILUSERS JOIN K ON K_ID = USR_ID AND K_ENABLED = 1) WHERE USR_ID = :PUSRID)) ';    // FCE_VENDEURNOM

      vQuery.ParamByName('PID').AsInteger           := Cde.iIDGinkoia;
      vQuery.ParamByName('PSOURCE').AsString        := SOURCE;
      vQuery.ParamByName('PIDEXTERNE').AsString     := IntToStr(Cde.CommandeInfos.CommandeId);
      vQuery.ParamByName('PDATE').AsDateTime        := Cde.CommandeInfos.CommandeDate;
      vQuery.ParamByName('PREGLEMENT').AsDateTime   := Cde.CommandeInfos.DateReglement;
      vQuery.ParamByName('PDTREGLER').AsDateTime    := Cde.CommandeInfos.DateReglement;
      vQuery.ParamByName('PSEQUENCE').AsString      := String(Cde.CommandeInfos.CommandeNum);
      vQuery.ParamByName('PCOMENT').AsString        := '';
      vQuery.ParamByName('PNUMCDE').AsString        := IntToStr(Cde.CommandeInfos.CommandeId);
      vQuery.ParamByName('PNUMERO').AsString        := String(Cde.CommandeInfos.CommandeNum);
      vQuery.ParamByName('PMAGID').AsInteger        := vMAG_ID;
      vQuery.ParamByName('PREMISE').AsInteger       := 0;
      vQuery.ParamByName('PUSRID').AsInteger        := vUSR_ID;
      vQuery.ParamByName('PDETAXE').AsInteger       := Cde.CommandeInfos.iExport;
      vQuery.ParamByName('PHTWORK').AsInteger       := Cde.CommandeInfos.iExport;
      vQuery.ParamByName('PCLOTURE').AsInteger      := 1;
      vQuery.ParamByName('PARCHIVE').AsInteger      := 0;
      vQuery.ParamByName('PMARGE').AsFloat          := 0; // TO DO : Somme(TTC - PUMP)
      vQuery.ParamByName('PCPAID').AsInteger        := vCPA_ID;
      vQuery.ParamByName('PMRGID').AsInteger        := vMRG_ID;
      vQuery.ParamByName('PNMODIF').AsInteger       := 1;
      vQuery.ParamByName('PWEB').AsInteger          := 1;
      vQuery.ParamByName('PREGLER').AsInteger       := IfThen(Cde.CommandeInfos.Statut = 'PAYE', 1, 0);
      vQuery.ParamByName('PCLTID').AsInteger        := Cde.Client.IdGinkoiaClient;
      vQuery.ParamByName('PCLTNOM').AsString        := Cde.Client.AdresseLivr.sAdr_Nom;
      vQuery.ParamByName('PCLTPRENOM').AsString     := Cde.Client.AdresseLivr.sAdr_Prenom;
      vQuery.ParamByName('PADRLIGNE').AsString      := GetAddressLigne(Cde.Client.AdresseFact);
      vQuery.ParamByName('PVILID').AsInteger        := GetVilleID(Cde.Client.IdGinkoiaClient);
      vQuery.ParamByName('PPRO').AsInteger          := 0;
      vQuery.ParamByName('PTYPE').AsInteger         := 2;
      vQuery.ParamByName('PPRENEUR').AsString       := '';
      vQuery.ParamByName('PCLTIDPRO').AsInteger     := -1;
      vQuery.ParamByName('PIDWEB').AsInteger        := Cde.CommandeInfos.CommandeId;
      vQuery.ParamByName('PDATECLOTURE').AsDateTime := Now();
      vQuery.ParamByName('PEXPORT').AsInteger       := Cde.CommandeInfos.iExport;
      vQuery.ParamByName('PDTEXPORT').AsDateTime    := IfThen(Cde.CommandeInfos.iExport = 1, Cde.CommandeInfos.CommandeDate, 0);
      vQuery.ParamByName('PASSID').AsInteger        := vASS_ID;

      for i := 0 to 4 do
      begin
        if (i <= (Length(Cde.TVAS) - 1)) then
        begin
          vQuery.ParamByName('PTVAHT' + AnsiString(IntToStr(i + 1))).AsFloat   := Cde.TVAS[i].TotalHT + Cde.TVAS[i].MtTVA;
          vQuery.ParamByName('PTVA' + AnsiString(IntToStr(i + 1))).AsFloat     := Cde.TVAS[i].MtTVA;
          vQuery.ParamByName('PTVATAUX' + AnsiString(IntToStr(i + 1))).AsFloat := Cde.TVAS[i].TauxTva;
        end
        else
        begin
          vQuery.ParamByName('PTVAHT' + AnsiString(IntToStr(i + 1))).AsFloat   := 0;
          vQuery.ParamByName('PTVA' + AnsiString(IntToStr(i + 1))).AsFloat     := 0;
          vQuery.ParamByName('PTVATAUX' + AnsiString(IntToStr(i + 1))).AsFloat := 0;
        end;
      end;

      vQuery.ExecSQL;

      GenCreateLigneCompteClient(Cde, vMAG_ID);
    except
      on E : Exception do
        raise Exception.Create('GenCreateEnteteFacture -> ' + E.Message);
    end;

    if Cde.FraisDePort <> 0 then
    begin
      // Initialisation article frais de port
      vArtInfos.iArtId   := vPORTWEB_ID;
      vArtInfos.iTgfId   := 0;
      vArtInfos.iCouId   := 0;
      vArtInfos.fPxAchat := Abs(Cde.FraisDePort);
      vArtInfos.fTVA     := GetFPTauxTVA(Dm_Common.MySiteParams.iCodeSite);
      vArtInfos.IsValide := True;

      // Initialisation ligne facture
      vTauxTVA := GetFPTauxTVA(Dm_Common.MySiteParams.iCodeSite);
      vHT := Abs(Cde.FraisDePort) * (1 - (vTauxTVA / 100));

      vLigneCDE.Qte       := Sign(Cde.FraisDePort);
      vLigneCDE.PUBrutHT  := vHT;
      vLigneCDE.PUBrutTTC := Abs(Cde.FraisDePort);
      vLigneCDE.PUHT      := vHT;
      vLigneCDE.PUTTC     := Abs(Cde.FraisDePort);
      vLigneCDE.PXHT      := vHT;
      vLigneCDE.PXTTC     := Cde.FraisDePort;
      vLigneCDE.TxTVA     := vTauxTVA;

      GenCreateLigneFacture(Cde, Length(Cde.Lignes) + 1, vArtInfos, vLigneCDE, False);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function GenCreateLigneFacture(Cde : TCde; ANumLigne: Integer; ArtInfos: stArticleInfos; LigneCDE: TLigneCDE;
  APromo : boolean): boolean;
const
  SOURCE = 'SYNCWEB';
  TABLENAME = 'NEGFACTUREL';
  DOCUMENT_LINE_PROP_VALUE = 100000000000;
var
  vQuery: TIBOQuery;
begin
  Result := False;

  vQuery := TIBOQuery.Create(nil);
  try
    vQuery.IB_Connection := Dm_Common.Ginkoia;
    vQuery.IB_Transaction := Dm_Common.IbT_Modif;
    try
      vQuery.SQL.Text := 'INSERT INTO ' + TABLENAME + '(FCL_ID, FCL_IDEXTERNE, FCL_SOURCE, FCL_FCEID, FCL_DATEBLL, ' +
                         '    FCL_NOM, FCL_ARTID, FCL_TGFID, FCL_COUID, FCL_QTE, FCL_PXBRUT, FCL_PXNN, FCL_TVA, FCL_PXNET, ' +
                         '    FCL_BLLID, FCL_VALREMGLO, FCL_FROMBLL, FCL_USRID, FCL_TYPID, FCL_COMENT) ' +
                         'VALUES (:PID, :PIDEXTERNE, :PSOURCE, :PFCEID, :PDATEBLL, ' +
                         '    :PNOM, :PARTID, :PTGFID, :PCOUID, :PQTE, :PPXBRUT, :PPXNN, :PTVA, :PPXNET, ' +
                         '    :PBLLID, :PVALREMGLO, :PFROMBLL, ' +
                         '    (SELECT USRID FROM FC_PARAMWEB(:PCODESITE)), ' +                                                       // FCL_USRID
                         '    (SELECT TYP_ID FROM GENTYPCDV WHERE TYP_CATEG = 5 AND TYP_COD = 1), ' +                                // FCL_TYPID
                         '    (SELECT ART_NOM FROM (ARTARTICLE JOIN K ON K_ID = ART_ID AND K_ENABLED = 1) WHERE ART_ID = :PARTID))'; // FCL_COMENT

      vQuery.ParamByName('PID').AsInteger        := NewK(TABLENAME);
      vQuery.ParamByName('PIDEXTERNE').AsString  := String(Cde.CommandeInfos.CommandeNum) + IntToStr(ANumLigne);
      vQuery.ParamByName('PSOURCE').AsString     := SOURCE;
      vQuery.ParamByName('PFCEID').AsInteger     := Cde.iIDGinkoia;
      vQuery.ParamByName('PNOM').AsString        := IntToStr(DOCUMENT_LINE_PROP_VALUE * ANumLigne);
      vQuery.ParamByName('PARTID').AsInteger     := ArtInfos.iArtId;
      vQuery.ParamByName('PTGFID').AsInteger     := ArtInfos.iTgfId;
      vQuery.ParamByName('PCOUID').AsInteger     := ArtInfos.iCouId;
      vQuery.ParamByName('PQTE').AsFloat         := LigneCDE.Qte;
      vQuery.ParamByName('PPXBRUT').AsFloat      := LigneCDE.PUBrutTTC;
      vQuery.ParamByName('PPXNN').AsFloat        := LigneCDE.PUTTC;
      vQuery.ParamByName('PTVA').AsFloat         := LigneCDE.TxTVA;
      vQuery.ParamByName('PPXNET').AsFloat       := LigneCDE.PXTTC;
      vQuery.ParamByName('PVALREMGLO').AsInteger := 0;
      vQuery.ParamByName('PBLLID').AsInteger     := 0;
      vQuery.ParamByName('PFROMBLL').AsInteger   := 0;
      vQuery.ParamByName('PDATEBLL').AsDateTime  := 0;
      vQuery.ParamByName('PCODESITE').AsInteger  := Dm_Common.MySiteParams.iCodeSite;

      vQuery.ExecSQL;

      Result := True;
    except
      on E : Exception do
        raise Exception.Create('GenCreateLigneFacture -> ' + E.Message);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function IsExistFacture(ANumCde: string; aCdeId: Integer): boolean;
var
  vQuery: TIBOQuery;
begin
  Result := False;
  vQuery := TIBOQuery.Create(nil);
  try
    try
      vQuery.IB_Connection := Dm_Common.Ginkoia;
      vQuery.IB_Transaction := Dm_Common.IbT_Select;

      vQuery.SQL.Text := 'SELECT COUNT(*) AS NB ' +
                         'FROM NEGFACTURE ' +
                         '   JOIN K ON K_ID = FCE_ID AND K_ENABLED = 1 ' +
                         'WHERE (FCE_NUMERO = :PNUMERO) OR (FCE_IDWEB = :PCDEIDWEB)';
      vQuery.Paramcheck := True;
      vQuery.ParamByName('PNUMERO').AsString := ANumCde;
      vQuery.ParamByName('PCDEIDWEB').AsInteger := aCdeId;
      vQuery.Open();

      Result := (vQuery.FieldByName('NB').AsInteger > 0);
    except
      on E : Exception do
        raise Exception.Create(Format('IsExistFacture (%s) -> %s', [ANumCde, E.Message]));
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function GestionFidelite(Facture: TCde; Client: TClientCde): Boolean;
var
  nTypeFidelite, nMagID, nUsrID, nAssID, nPortWebID, nNbPointsAjoutes: Integer;
  FideliteClient: TFideliteClient;
  DateFacture: TDateTime;
  dMontantFacture: Double;
begin
  Result := False;

  // Recherche du client.
  Dm_Common.Que_Tmp.Close;
  Dm_Common.Que_Tmp.SQL.Clear;
  Dm_Common.Que_Tmp.SQL.Add('select CLT_FIDELITE');
  Dm_Common.Que_Tmp.SQL.Add('from CLTCLIENT');
  Dm_Common.Que_Tmp.SQL.Add('join K on (K_ID = CLT_ID and K_ENABLED = 1)');
  Dm_Common.Que_Tmp.SQL.Add('where CLT_ID = :CLTID');
  try
    Dm_Common.Que_Tmp.ParamByName('CLTID').AsInteger := Client.IdGinkoiaClient;
    Dm_Common.Que_Tmp.Open;
  except
    on E: Exception do
      raise Exception.Create('GestionFidelite -> ' + E.Message);
  end;
  if Dm_Common.Que_Tmp.IsEmpty then
    raise Exception.Create('GestionFidelite -> Client [' + IntToStr(Client.IdGinkoiaClient) + '] inconnu !')
  else
  begin
    // Si client avec fidélité.
    if Dm_Common.Que_Tmp.FieldByName('CLT_FIDELITE').AsInteger > 0 then
    begin
      nTypeFidelite := Dm_Common.Que_Tmp.FieldByName('CLT_FIDELITE').AsInteger;
      LogAction('Client [' + IntToStr(Client.IdGinkoiaClient) + '] avec fidélité [' + IntToStr(nTypeFidelite) + '].', 3);

      GetInfoParamWeb(Dm_Common.MySiteParams.iCodeSite, nMagID, nUsrID, nAssID, nPortWebID);
      if nMagID = 0 then
      begin
        LogAction('GestionFidelite -> GetInfoParamWeb -> MAG_ID = 0 !', 1);
        Exit;
      end;

      FideliteClient := TFideliteClient.Create(Dm_Common.Que_Tmp.IB_Transaction, nMagID, nTypeFidelite);
      try
        // Recherche de la facture.
        Dm_Common.Que_Tmp.Close;
        Dm_Common.Que_Tmp.SQL.Clear;
        Dm_Common.Que_Tmp.SQL.Add('select FCE_DATE, FCL_ARTID, FCL_TGFID, FCL_COUID, FCL_PXBRUT, FCL_PXNN, FCL_PXNET, ARF_VIRTUEL, ARF_FIDELITE');
        Dm_Common.Que_Tmp.SQL.Add('from NEGFACTURE');
        Dm_Common.Que_Tmp.SQL.Add('join K on (K_ID = FCE_ID and K_ENABLED = 1)');
        Dm_Common.Que_Tmp.SQL.Add('join NEGFACTUREL on (FCE_ID = FCL_FCEID)');
        Dm_Common.Que_Tmp.SQL.Add('join K on (K_ID = FCL_ID and K_ENABLED = 1)');
        Dm_Common.Que_Tmp.SQL.Add('join ARTREFERENCE on (FCL_ARTID = ARF_ARTID)');
        Dm_Common.Que_Tmp.SQL.Add('where FCE_ID = :FCEID');
        try
          Dm_Common.Que_Tmp.ParamByName('FCEID').AsInteger := Facture.iIDGinkoia;
          Dm_Common.Que_Tmp.Open;
        except
          on E: Exception do
            raise Exception.Create('GestionFidelite -> ' + E.Message);
        end;
        if Dm_Common.Que_Tmp.IsEmpty then
          raise Exception.Create('GestionFidelite -> Facture [' + IntToStr(Facture.iIDGinkoia) + '] inconnue !')
        else
        begin
          DateFacture := Dm_Common.Que_Tmp.FieldByName('FCE_DATE').AsDateTime;

          dMontantFacture := 0;
          Dm_Common.Que_Tmp.First;
          while not Dm_Common.Que_Tmp.Eof do
          begin
            // Si article, ou pseudo avec fidélité.
            if((Dm_Common.Que_Tmp.FieldByName('FCL_ARTID').AsInteger <> 0) and (Dm_Common.Que_Tmp.FieldByName('FCL_TGFID').AsInteger <> 0) and (Dm_Common.Que_Tmp.FieldByName('FCL_COUID').AsInteger <> 0)) or ((Dm_Common.Que_Tmp.FieldByName('ARF_VIRTUEL').AsInteger = 1) and (Dm_Common.Que_Tmp.FieldByName('ARF_FIDELITE').AsInteger = 1)) then
            begin
              if(Dm_Common.Que_Tmp.FieldByName('FCL_PXBRUT').AsFloat <> 0) and (CompareValue(Abs((Dm_Common.Que_Tmp.FieldByName('FCL_PXNN').AsFloat / Dm_Common.Que_Tmp.FieldByName('FCL_PXBRUT').AsFloat - 1) * 100), FideliteClient.ParamFidelite.dPourcentRemiseIgnoree) = LessThanValue) then
                dMontantFacture := dMontantFacture + Dm_Common.Que_Tmp.FieldByName('FCL_PXNET').AsFloat;
            end;

            Dm_Common.Que_Tmp.Next;
          end;

          // Si application de la fidélité.
          if FideliteClient.Fidelite(dMontantFacture, nNbPointsAjoutes) then
          begin
            // Recherche si fidélité existe déjà.
            Dm_Common.Que_Tmp.Close;
            Dm_Common.Que_Tmp.SQL.Clear;
            Dm_Common.Que_Tmp.SQL.Add('select FID_ID');
            Dm_Common.Que_Tmp.SQL.Add('from CLTFIDELITE');
            Dm_Common.Que_Tmp.SQL.Add('join K on (K_ID = FID_ID and K_ENABLED = 1)');
            Dm_Common.Que_Tmp.SQL.Add('where FID_IDPIECE = :FCEID');
            Dm_Common.Que_Tmp.SQL.Add('and FID_KTBPIECE = -11111428');
            try
              Dm_Common.Que_Tmp.ParamByName('FCEID').AsInteger := Facture.iIDGinkoia;
              Dm_Common.Que_Tmp.Open;
            except
              on E: Exception do
                raise Exception.Create('GestionFidelite -> ' + E.Message);
            end;
            if Dm_Common.Que_Tmp.IsEmpty then
            begin
              // Ajout de la fidélité.
              Dm_Common.Que_Tmp.Close;
              Dm_Common.Que_Tmp.SQL.Clear;
              Dm_Common.Que_Tmp.SQL.Add('insert into CLTFIDELITE');
              Dm_Common.Que_Tmp.SQL.Add('(FID_ID, FID_TKEID, FID_POINT, FID_DATE, FID_MAGID, FID_BACID, FID_CLTID, FID_MANUEL, FID_IDPIECE, FID_KTBPIECE)');
              Dm_Common.Que_Tmp.SQL.Add('values((select ID from pr_newk(''CLTFIDELITE'')), 0, :POINT, :FIDDATE, :MAGID, 0, :CLTID, 0, :IDPIECE, -11111428)');
              try
                Dm_Common.Que_Tmp.ParamByName('POINT').AsInteger := nNbPointsAjoutes;
                Dm_Common.Que_Tmp.ParamByName('FIDDATE').AsDateTime := Trunc(DateFacture);
                Dm_Common.Que_Tmp.ParamByName('MAGID').AsInteger := nMagID;
                Dm_Common.Que_Tmp.ParamByName('CLTID').AsInteger := Client.IdGinkoiaClient;
                Dm_Common.Que_Tmp.ParamByName('IDPIECE').AsInteger := Facture.iIDGinkoia;
                Dm_Common.Que_Tmp.ExecSQL;
              except
                on E: Exception do
                  raise Exception.Create('GestionFidelite -> ' + E.Message);
              end;

              LogAction('Ajout fidélité client [' + IntToStr(Client.IdGinkoiaClient) + ']: ' + IntToStr(nNbPointsAjoutes) + IfThen(nNbPointsAjoutes > 1, ' points.', ' point.'), 3);
            end;
          end;
        end;
      finally
        FideliteClient.Free;
      end;
    end
    else
      LogAction('Client [' + IntToStr(Client.IdGinkoiaClient) + '] sans fidélité.', 3);
  end;

  Result := True;
end;

procedure GetInfoParamWeb(ACodeSite: integer; out AMAG_ID, AUSR_ID, AASS_ID, APORTWEB_ID : integer);
var
  vQuery: TIBOQuery;
begin
  vQuery := TIBOQuery.Create(nil);
  try
    try
      vQuery.IB_Connection := Dm_Common.Ginkoia;
      vQuery.IB_Transaction := Dm_Common.IbT_Select;

      vQuery.SQL.Text := 'SELECT MAGID, USRID, ASSID, ARTID_FP FROM FC_PARAMWEB (:CODE_SITE_WEB)';
      vQuery.Paramcheck := True;
      vQuery.ParamByName('CODE_SITE_WEB').AsInteger := ACodeSite;
      vQuery.Open();

      if not vQuery.IsEmpty() then
      begin
        AMAG_ID := vQuery.FieldByName('MAGID').AsInteger;
        AUSR_ID := vQuery.FieldByName('USRID').AsInteger;
        AASS_ID := vQuery.FieldByName('ASSID').AsInteger;
        APORTWEB_ID := vQuery.FieldByName('ARTID_FP').AsInteger;
      end;
    except
      on E : Exception do
        raise Exception.Create(Format('GetInfoParamWeb (%d) -> %s', [ACodeSite, E.Message]));
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;


procedure GetInfoReglementWeb(ACodeSite: integer; AModeReglement : string; out AMRG_ID, ACPA_ID : integer);
var
  vQuery: TIBOQuery;
begin
  vQuery := TIBOQuery.Create(nil);
  try
    try
      vQuery.IB_Connection := Dm_Common.Ginkoia;
      vQuery.IB_Transaction := Dm_Common.IbT_Select;

      vQuery.SQL.Text := 'SELECT MRW_MRGID, MRW_CPAID ' +
                         'FROM ARTMODEREGLWEB ' +
                         '    JOIN K ON K_ID = MRW_ID AND K_ENABLED = 1 ' +
                         'WHERE MRW_ASSID = :PASSID AND MRW_CODEMRG = :PCODEMRG';
      vQuery.Paramcheck := True;
      vQuery.ParamByName('PASSID').AsInteger  := ACodeSite;
      vQuery.ParamByName('PCODEMRG').AsString := AModeReglement;
      vQuery.Open();

      if not vQuery.IsEmpty() then
      begin
        AMRG_ID := vQuery.FieldByName('MRW_MRGID').AsInteger;
        ACPA_ID := vQuery.FieldByName('MRW_CPAID').AsInteger;
      end;
    except
      on E : Exception do
        raise Exception.Create(Format('GetInfoReglementWeb (%d-%s) -> %s', [ACodeSite, AModeReglement, E.Message]));
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function GetFPTauxTVA(CODE_SITE_WEB: Integer): Currency;
var
  ARTID_FP: Integer;
begin
  Result := 0;
  with Dm_Common do
  begin
    with Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select ARTID_FP from FC_PARAMWEB(:PCODESITEWEB)');
      ParamCheck := True;
      ParamByName('PCODESITEWEB').AsInteger := CODE_SITE_WEB;
      Open;

      ARTID_FP := FieldByName('ARTID_FP').AsInteger;

      Close;
      SQL.Clear;
      SQL.Add('Select TVA_TAUX from ARTREFERENCE');
      SQL.Add(' Join ARTTVA on ARF_TVAID = TVA_ID');
      SQL.ADd('Where ARF_ARTID = :PARTID');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := ARTID_FP;
      Open;

      if RecordCount > 0 then
      begin
        Result := FieldByName('TVA_TAUX').AsCurrency;
      end;
    end;
  end;
end;

function CalculatePriceVATexc(ANetPriceVATinc, AVAT : Currency): Currency;
begin
  Result := (ANetPriceVATinc / (1 + (AVAT / 100)));
end;

function GetAddressLigne(AAdresse : stUneAdresse): string;
begin
  Result := LeftStr(AAdresse.sAdr_Adr1 + ' ' + AAdresse.sAdr_Adr2 + ' ' + AAdresse.sAdr_Adr3, 512);
end;

function GetVilleID(ACLT_ID : integer): integer;
var
  vQuery: TIBOQuery;
begin
  Result := 0;

  vQuery := TIBOQuery.Create(nil);
  try
    try
      vQuery.IB_Connection := Dm_Common.Ginkoia;
      vQuery.IB_Transaction := Dm_Common.IbT_Select;

      vQuery.SQL.Text := 'SELECT ADR_VILID ' +
                         'FROM CLTCLIENT ' +
                         '    JOIN K ON K_ID = CLT_ID AND K_ENABLED = 1 ' +
                         '    JOIN GENADRESSE ON CLT_ADRID = ADR_ID ' +
                         'WHERE CLT_ID = :PCLTID';
      vQuery.Paramcheck := True;
      vQuery.ParamByName('PCLTID').AsInteger := ACLT_ID;
      vQuery.Open();

      if not vQuery.IsEmpty() then
      begin
        Result := vQuery.FieldByName('ADR_VILID').AsInteger;
      end;
    except
      on E : Exception do
        raise Exception.Create(Format('GetVilleID (%d) -> %s', [ACLT_ID, E.Message]));
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

// Mouvemente un K
procedure UpdateK(AKId: Integer; ASuppression: Integer = 0);
begin
  try
    if Dm_Common.IbC_K.Active then
      Dm_Common.IbC_K.Close();

    Dm_Common.IbC_K.SQL.Clear();
    Dm_Common.IbC_K.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:KID, :SUPPRESSION)');
    Dm_Common.IbC_K.ParamByName('KID').AsInteger          := AKId;
    Dm_Common.IbC_K.ParamByName('SUPPRESSION').AsInteger  := ASuppression;
    Dm_Common.IbC_K.Open();
  except
    on E: Exception do
      raise Exception.Create(Format('PR_UPDATEK -> %s'#160': %s', [E.ClassName, E.Message]));
  end;
  Dm_Common.IbC_K.Close();
end;

// Créé un nouveau K et renvoie l'id
function NewK(ATblName: string): Integer;
var
  MyId: integer;
begin
  try
    Dm_Common.IbC_K.Close();
    Dm_Common.IbC_K.SQL.Text := 'SELECT ID FROM PR_NEWK(:TBL)';
    Dm_Common.IbC_K.ParamByName('TBL').AsString := AnsiString(ATblName);
    Dm_Common.IbC_K.Open();
    MyId := Dm_Common.IbC_K.FieldByName('ID').AsInteger;
  except
    on E: Exception do
      MyId := 0;
  end;
  Dm_Common.IbC_K.Close();

  Result := MyId;
end;

// Récupére l'ID le plus bas de la base
function IdBase(): Int64;
const
  REGEX_PLAGE = '\[(\d+)M_';
var 
  sPlage: String;
  regPlage: TPerlRegEx;  
begin
  if Dm_Common.Gestion_K_VERSION = tKV64 then
  begin
    try
      Dm_Common.Que_Plage64.Open();
      if not Dm_Common.Que_Plage64.IsEmpty then
        Result := Dm_Common.Que_Plage64.FieldByName('BAS_VERSDEB').AsLargeInt
      else
        raise Exception.Create('Générateur de base de données mal configuré');
    finally
      Dm_Common.Que_Plage64.Close();
    end;
  end
  else
  begin
    Dm_Common.Que_Plage.Open();
    if not(Dm_Common.Que_Plage.IsEmpty) then
    begin
      sPlage := Dm_Common.Que_Plage.FieldByName('BAS_PLAGE').AsString;
      Dm_Common.Que_Plage.Close();
    end
    else
    begin
      Dm_Common.Que_Plage.Close();
      raise Exception.Create('Générateur de base de données mal configuré');
    end;

    regPlage := TPerlRegEx.Create();
    try
      regPlage.RegEx    := REGEX_PLAGE;
      regPlage.Options  := [preCaseLess];
      regPlage.Subject  := UTF8String(sPlage);

      if regPlage.Match() then
      begin
        if TryStrToInt64(String(regPlage.Groups[1]), Result) then
          Result := Result * 1000000
        else
          Result := 0;
      end
      else
        Result := 0;

    finally
      regPlage.Free();
    end;
  end;
end;

function DoublonADW:boolean;
var
  lQuery: TIBOQuery;
begin
  Result := True;
  lQuery := TIBOQuery.Create(nil);
  try
    try
      lQuery.IB_Connection := Dm_Common.Ginkoia;
      lQuery.IB_Transaction := Dm_Common.IbT_Doublon;
      //on crée la procedure de suppression de doublons
      Dm_Common.IbT_Doublon.Commit;
      Dm_Common.ibs_DoublonADW.SQL.Insert(0, 'SET TERM ^ ;');
      Dm_Common.ibs_DoublonADW.SQL.ADD('^');
      Dm_Common.ibs_DoublonADW.SQL.ADD('SET TERM ; ^');
      Dm_Common.ibs_DoublonADW.SQL.ADD('COMMIT ; ');
      //Dm_Common.ibs_DoublonADW.SQL.Add('GRANT EXECUTE ON PROCEDURE INS_' + TableName + ' TO GINKOIA; ');
      Dm_Common.ibs_DoublonADW.SQL.ADD('COMMIT ; ');
      Dm_Common.ibs_DoublonADW.Execute;


      //on execute la procedure
      lQuery.SQL.Clear;
      lQuery.SQL.Add('EXECUTE PROCEDURE WEBVENTE_SUPPR_DOUBLON');
      lQuery.ExecSQL;
      lQuery.IB_Transaction.Commit;
      //et on la supprime
      lQuery.SQL.Clear;
      lQuery.SQL.Add('DROP PROCEDURE WEBVENTE_SUPPR_DOUBLON');
      lQuery.ExecSQL;
      lQuery.IB_Transaction.Commit;
    except
      Result := false;
    end;
  finally
    lQuery.Free;
  end;
end;

end.





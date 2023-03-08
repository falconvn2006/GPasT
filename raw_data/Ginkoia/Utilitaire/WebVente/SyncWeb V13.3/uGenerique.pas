unit uGenerique;

interface

uses Controls,
  DateUtils,
  uCommon_DM,
  IniFiles,
  SysUtils,
  Forms,
  Types,
  uCreateCsv,
  Db,
  uCommon,
  Classes,
  XMLDoc,
  XMLIntf,
  StrUtils,
  uGeneriqueType,
  Math,
  Windows,
  Variants,
  uCommon_Type,
  IBODataset;

function DoGenGet(dHeureDebut, dHeureFin: TTime): Boolean;
function DoGenSend(dHeureDebut, dHeureFin: TTime; bEnd: Boolean): Boolean;

// Retourne le mode de traitement à faire MODE_XXXX
function IsTimerDone(dHeureDebut, dHeureFin: TTime; bEnd: Boolean): TMode;
// function de génération des fichiers articles
function GenerateCsvArtFiles: Boolean;
// function de génération des fichiers de stocks
function GenerateCsvStkFiles: Boolean;
// function de traitement des commandes
function DoGenCde: Boolean;

// function pour récupérer le Taux TVA des frais de port
function GetFPTauxTVA(CODE_SITE_WEB: Integer): Currency;

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

// Transforme la structure en commande dans la base de données
function DoGenCdeToDb(Cde: TCde): Boolean;

// permet de créer les fichiers csv depuis un dataset
function DoCsv(DataSet: TDataSet; sFileName: string; AFilter: String=''; AChampUnique: String = ''): Boolean;

function GenFTPConnection(FTPCfg: TFTPData): Boolean;
function GenFTPDownloadFile(FTPCfg: TFTPData): Boolean;
function GenFTPUploadFile(FTPCfg: TFTPData): Boolean;
procedure GenFTPClose;

function GenCreateClient(Client: TClientCde): Boolean;
function GenCreateEnteteBL(Cde: TCDE): Boolean;
function GenCreateLineBL(ID_COMMANDE: Integer; ArtInfos: stArticleInfos;
  LigneCDE: TLigneCDE): boolean;

//Identifie le magasin correspondant à la base de donnée sur laquel on est connecté
function IdentLocalMagid: Integer;

//Contrôle si on est bien connecté sur la base web
function CtrlIdentBaseWeb: Boolean;

// fonction qui met dans une liste les fichiers d'un répertoire
function GetFileListFromDir(lst : TStringList;sDir, sFileExt : String; bRecursive : Boolean = false) : Boolean;


implementation


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
        else begin
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
  try
    QryTmp := TIBOQuery.Create(nil);
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
  try
    QryTmp := TIBOQuery.Create(nil);
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
end;

function DoGenSend(dHeureDebut, dHeureFin: TTime; bEnd: Boolean): Boolean;
var
  Mode: TMode;
  bDoArt, bDoStk: Boolean;
  FTPCsv,
    FTPCDE: TFTPData;

begin
  Result := False;
  try
    // Vérification timer
    Mode := IsTimerDone(dHeureDebut, dHeureFin, bEnd);

    // traitement des fichiers articles
    bDoArt := False;
    if (mdArticle in Mode) then
      bDoArt := GenerateCsvArtFiles;

    // traitement des fichiers stocks
    bDoStk := False;
    if (mdStock in Mode) then
      bDoStk := GenerateCsvStkFiles;

    // Envoi des fichiers CSV sur le FTP (Stocks et articles)
    if bDoArt or bDoStk then
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
      LogAction('Transfert des fichiers CSV vers le FTP', 3);
      if GenFTPConnection(FTPCsv) then
      try
        GenFTPUploadFile(FTPCsv);
      finally
        GenFTPClose;
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
      LogAction('Transfert des factures vers le FTP', 3);
      if GenFTPConnection(FTPCDE) then
      try
        GenFTPUploadFile(FTPCDE);
      finally
        GenFTPClose;
      end;
    end;

    Result := True;
  except on E: Exception do
    begin
      raise Exception.Create('DoGenSend -> ' + E.Message);
    end;
  end;
end;

function IsTimerDone(dHeureDebut, dHeureFin: TTime; bEnd: Boolean): TMode;

type
  TPlageHoraire = record
    HPlgDebut, HPlgFin: TDateTime;
  end;

var
  TabArtPlage: array of TPLageHoraire;
  TabStkPlage: array of TPLageHoraire;
  i: integer;
  bFound: Boolean;
  iPlage: Integer;
  bDoArt: Boolean;
  bDoStk: Boolean;

  dHeureArticle: TTime;
  fDelaiArticle: Double;
  dHeureStock: TTime;
  fDelaiStock: Double;
  dLastDateArt: TDateTime;
  dLastDateStk: TDateTime;
  iActifStock: Integer; //0: Inactif, 1: On envoie les fichiers stock
  iActifArt: Integer; //0: Inactif, 1: On envoie les fichiers articles

  dHTDebut,
    dHTFin,
    dNow: TDateTime;
  iPlageLast: integer;

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

  if (fDelaiArticle = 0) or (fDelaiStock = 0) then
    raise
      Exception.Create('Configuration manquante : Délai article ou stock non configuré');

  with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do
  try
    // Récupération de la dernière heure de traitement
    dLastDateArt := ReadDateTime('GENERIQUE', 'DATETIMEART', DateOf(dNow) +
      dHeureArticle);
    dLastDateStk := ReadDateTime('GENERIQUE', 'DATETIMESTK', DateOf(dNow) +
      dHeureStock);
  finally
    free;
  end;

  // Génération des plages horaires
  // calcul le nombre de plages horaires pour la période dhtdebut à dhtfin
  // Ex : DHTDebut = 10/10/2009 06:00 et DHTFin = 10/10/2009 22:00, FDelaiArticle = 2h
  //      (HoursBeetween Div FDelaiArticle) + 1 = (16 Div 2) + 1 = 9 plages horaires (6h-8h, 8h-10, ... 18h-20h, 20h-22h)
  // article
  if (iActifArt = 1) and (CtrlIdentBaseWeb) then
  begin
    i := (HoursBetween((DateOf(dHTDebut) + dHeureArticle), dHTFin) div
      Round(fDelaiArticle)) + 1;
    SetLength(TabArtPlage, i);
    for i := low(TabArtPlage) to high(TabArtPlage) do
      with TabArtPlage[i] do
      begin
        HPlgDebut := inchour(DateOf(dHTDebut) + dHeureArticle,
          Round(fDelaiArticle) * i);
        HPlgFin := inchour(DateOf(dHTDebut) + dHeureArticle, Round(fDelaiArticle)
          * (i + 1));
      end;
  end;

  // stock
  if (iActifStock = 1) then
  begin
    i := (HoursBetween((DateOf(dHTDebut) + dHeureArticle), dHTFin) div
      Round(fDelaiStock)) + 1;
    SetLength(TabStkPlage, i);
    for i := low(TabStkPlage) to High(TabStkPlage) do
      with TabStkPlage[i] do
      begin
        HPlgDebut := Inchour(DateOf(dHTDebut) + dHeureStock, Round(fDelaiStock)
          * i);
        HPlgFin := Inchour(DateOf(dHTDebut) + dHeureStock, Round(fDelaiStock) *
          (i + 1));
      end;
  end;

  //Gestion des fichiers articles
  bDoArt := False;
  if (iActifArt = 1) and (CtrlIdentBaseWeb) then
  begin
    // dans quelle plage est on pour l'article?
    bFound := False;
    iPlageLast := -1;
    for i := low(TabArtPlage) to high(TabArtPlage) do
      with TabArtPlage[i] do
      begin
        if (dNow >= HPlgDebut) and (dNow < HPlgFin) then
        begin
          bFound := True;
          iPlage := i;
        end;
        if (CompareValue(dLastDateArt, HPlgDebut) in [GreaterThanValue,
          EqualsValue]) and
          (CompareValue(dLastDateArt, HPlgFin) = LessThanValue) then
          iPlageLast := i;

      end;

    if bFound then
    begin
      // Si l'heure du dernier traitement <= à la plage trouvée c'est qu'il est nécessaire de traiter l'article
      if CompareValue(dLastDateArt, TabArtPlage[iPlage].HPlgDebut) =
        LessThanValue then
        // On vérifie qu'on est pas Hors horaire de traitement
        if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut)
          + dHeureArticle)) then
        begin
          bDoArt := True;
          // Ajout de 5mn car il arrive parfois que la conversion depuis le ini bug et enlève des secondes
          dLastDateArt := IncMinute(TabArtPlage[iPlage].HPlgDebut, 5);
        end;
    end
    else
    begin
      // Si on est la c'est qu'on est Hors plage donc qu'on a un traitement à faire
      // alors on va vérifier si on a pas dépassé aussi l'heure de fin de traitement
      if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) +
        dHeureArticle)) then
      begin
        bDoArt := True;
        dLastDateArt := TabArtPlage[High(TabArtPlage)].HPlgFin;
      end;
    end;
  end;

  //Gestion des fichiers stock
  bDoStk := False;
  if (iActifStock = 1) then
  begin
    // dans quelle plage est on pour le stock?
    iPlageLast := -1;
    bFound := False;
    for i := low(TabStkPlage) to high(TabStkPlage) do
      with TabStkPlage[i] do
      begin
        if (dNow >= HPlgDebut) and (dNow < HPlgFin) then
        begin
          bFound := True;
          iPlage := i;
        end;

        if (CompareValue(dLastDateStk, HPlgDebut) in [GreaterThanValue,
          EqualsValue]) and
          (CompareValue(dLastDateStk, HPlgFin) = LessThanValue) then
        begin
          iPlageLast := i;
        end;
      end;

    if bFound then
    begin
      // Si l'heure du dernier traitement <= à la plage trouvée c'est qu'il est nécessaire de traiter l'article
      if CompareValue(dLastDateStk, TabStkPlage[iPlage].HPlgDebut) =
        LessThanValue then
        // On vérifie qu'on est pas Hors horaire de traitement et qu'on est vien supérieur à l'heure de début de traitement
        if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut)
          + dHeureArticle)) then
        begin
          bDoStk := True;
          // Ajout de 5mn car il arrive parfois que la conversion depuis le ini bug et enlève des secondes
          dLastDateStk := IncMinute(TabStkPlage[iPlage].HPlgDebut, 5);
        end;
    end
    else
    begin
      // Si on est la c'est qu'on est Hors plage donc qu'on a un traitement à faire
      // alors on va vérifier si on a pas dépassé aussi l'heure de fin de traitement
      if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) +
        dHeureArticle)) then
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

function GenerateCsvArtFiles: Boolean;
begin
  Result := False;
  with Dm_Common do
  try

    // génération du fichier genre
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPGENRE');
        Open;
      end;

      DoCsv(Que_Tmp, GGENPATHCSV + 'GENRE.TXT', '', 'GRE_ID');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPGENRE: GENRE.TXT -> ' + E.Message);
    end;

    // Génération du fichier nomenclature
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
      DoCsv(Que_Tmp, GGENPATHCSV + 'MAGASIN.TXT');
    except on E: Exception do
        raise Exception.Create('MAGASIN.TXT -> ' + E.Message);
    end;

    // Génération du fichier magasin
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
      DoCsv(Que_Tmp, GGENPATHCSV + 'NOMENCLATURE.TXT');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPNOMENCLATURE: NOMENCLATURE.TXT -> ' + E.Message);
    end;

    // génération des fichier des articles web
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * From TF_WEBG_EXPARTWEB(:ASSID,:MAGID)');
        ParamCheck := True;
        ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
        ParamByName('MAGID').AsInteger := MySiteParams.iMagID;
        Open;
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create('Requete TF_WEBG_EXPARTWEB -> ' + E.Message);
      end
    end;
    //ARWEB.TXT -> sans les ID vers tailles.txt et couleur_stat.txt
    Try
      DoCsv(Que_Tmp, GGENPATHCSV + 'ARTWEB.TXT','GCS_ID, TGF_ID, CODE_CHRONO', 'CODE_ARTICLE');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPARTWEB: ARTWEB.TXT -> ' + E.Message);
    end;
    //ARWEB_2.TXT -> avec les ID vers tailles.txt et couleur_stat.txt
    try
      DoCsv(Que_Tmp, GGENPATHCSV + 'ARTWEB_2.TXT');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPARTWEB: ARTWEB_2.TXT -> ' + E.Message);
    end;

    // génération du fichier des marques
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
      DoCsv(Que_Tmp, GGENPATHCSV + 'MARQUE.TXT');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPARTWEB: MARQUE.TXT -> ' + E.Message);
    end;

    // génération du fichier des nomenclatures secondaires
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPARTNOMENK');
        Open;
      end;
      DoCsv(Que_Tmp, GGENPATHCSV + 'ARTNOMENK.TXT');
    except
      on E: Exception do
      begin
        raise Exception.Create('TF_WEBG_EXPARTNOMENK: ARTNOMENK.TXT -> ' + E.Message);
      end;
    end;

    // Génération du fichier des lots
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
      DoCsv(Que_Tmp, GGENPATHCSV + 'LOTWEB.TXT');
    except
      on E: Exception do
      begin
        raise Exception.Create('TF_WEBG_EXPLOTWEB: LOTWEB.TXT -> ' + E.Message);
      end;
    end;

    // Génération de la nomenclature secondaire des lots
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPLOTNOMENK');
        Open;
      end;
      DoCsv(Que_Tmp, GGENPATHCSV + 'LOTNOMENK.TXT', '', 'CODE_LOT');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPLOTNOMENK: LOTNOMENK.TXT -> ' + E.Message);
    end;

    // génération du fichier des codes Promo
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPCODEPROMO');
        Open;
      end;
      DoCsv(Que_tmp, GGENPATHCSV + 'CODEPROMO.TXT', '', 'CODE_PROMO');
    except on E: Exception do
        raise Exception.Create('TF_WEBG_EXPCODEPROMO: CODEPROMO.TXT -> ' + E.Message);
    end;

    // génération du fichier tailles
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from WEBG_EXPTAILLES(:ASSID)');
        ParamByName('ASSID').asInteger  := MySiteParams.iAssID;
        Open;
      end;

      DoCsv(Que_Tmp, GGENPATHCSV + 'TAILLES.TXT', '', 'TGF_ID');
    except on E: Exception do
        raise Exception.Create('WEBG_EXPTAILLES: TAILLES.TXT -> ' + E.Message);
    end;

    // génération du fichier couleurs statistique
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from WEBG_EXPCOULEURSTAT(:ASSID)');
        ParamByName('ASSID').asInteger  := MySiteParams.iAssID;
        Open;
      end;

      DoCsv(Que_Tmp, GGENPATHCSV + 'COULEUR_STAT.TXT', '', 'GCS_ID');
    except on E: Exception do
        raise Exception.Create('WEBG_EXPCOULEURSTAT: COULEUR_STAT.TXT -> ' + E.Message);
    end;
                
    // génération du fichier code barre fournisseur
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from CH_WEBG_EXPARTARTFOURN');
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
          MemD_Export.Post();
        end
        else begin
          MemD_Export.FieldByName('CB_FOURN').AsString := Que_Tmp.FieldByName('CB_FOURN').AsString;
        end;

        MemD_Export.Post();
        Que_Tmp.Next();
      end;
      {$ENDREGION 'Vérifie que les codes-barres fournisseurs sont corrects'}

      DoCsv(MemD_Export, GGENPATHCSV + 'CB_FOURN.TXT', '', 'CODE_ARTICLE');
    except on E: Exception do
        raise Exception.Create('CH_WEBG_EXPARTARTFOURN: CB_FOURN.TXT -> ' + E.Message);
    end;

    Result := True;
  except on E: Exception do
    begin
      LogAction('Erreur lors de la génération des csv : ' + E.Message, 1);
    end;
  end;
end;

function GenerateCsvStkFiles: Boolean;
var
  iLocalMagId: Integer;
  //Id du magasin correspond à la base en cours d'utilisation
  iExtractMagId: Integer; //Id du magasin à extraire
  iCumulMagId: Integer; //Id du magasin à cumuler
  iNbLigneExtract: Integer; //Nombre de ligne de la liste d'extraction
begin
  Result := False;
  with Dm_Common do
  try

    //Recherche du magasin correspond à la BdD
    iLocalMagId := IdentLocalMagid;
    if iLocalMagId = 0 then
      iLocalMagId := MySiteParams.iMagID;

    // Lecture de la liste d'extraction
    iExtractMagId := 0;
    iCumulMagId := 0;
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Text := 'Select prm_magid, prm_pos ' +
          'from genparam ' +
          'join k on (k_id=prm_id) and (k_enabled=1) ' +
          'where (prm_type=9) and (prm_code=404)';
        Open;
        First;
        iNbLigneExtract := RecordCount;
        //Si aucune liste d'extraction n'est défini on utilise le magasin général
        if iNbLigneExtract <= 0 then
          iExtractMagId := MySiteParams.iMagID
        else
        begin
          //Recherche du magasin dans la liste d'extraction
          if Locate('prm_magid', iLocalMagId, []) then
          begin
            iExtractMagId := FieldByName('prm_magid').AsInteger;
            iCumulMagId := FieldByName('prm_pos').AsInteger;
          end
        end;
        Close;
      end;
    except on E: Exception do
        raise Exception.Create('GenerateCsvStkFiles -> ' + E.Message);
    end;
    //Si une liste d'extraction existe mais que le magasin n'en fait pas partie on sort;
    if iExtractMagId = 0 then
      exit;
    //Si aucune liste d'extraction n'est défini et que l'on est pas connecté à la base Web par défaut on sort
    if (iNbLigneExtract <= 0) and (not CtrlIdentBaseWeb) then
      exit;

    // Génération du fichier des stocks
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select CODE_ARTICLE,ID_SEUIL,LIB_SEUIL, STOCK_ARTICLE as QTE_STOCK, ' +
          QuotedStr(IntToStr(iExtractMagId)) +
          ' as MAG_ID from TF_WEBG_EXPSTOCK(:LOT,:MAJSTK,:PMAGID,:CUMULID,:PASSID)');
        ParamCheck := True;
        ParamByName('LOT').AsInteger := 0;
        ParamByName('PMAGID').AsInteger := iExtractMagId;
        ParamByName('MAJSTK').AsInteger := 1;
        // pas de mise à jour des seuils avec 0
        ParamByName('PASSID').AsInteger := MySiteParams.iAssID;
        ParamByName('CUMULID').AsInteger := iCumulMagId;
        Open;
      end;
      DoCsv(Que_Tmp, GGENPATHCSV + 'STOCK_' + IntToStr(iExtractMagId) + '.TXT');
    except on E: Exception do
        raise Exception.Create('STOCK_' + IntToStr(iExtractMagId) + '.TXT -> ' +
          E.Message);
    end;

    // génération du fichier StockLot
    try
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select CODE_LOT, ID_SEUIL, LIB_SEUIL, CODE_LIGNE, CODE_ARTICLE as CB_ARTICLE, STOCK_ARTICLE');
        SQL.Add(', ' + QuotedStr(IntToStr(iExtractMagId)) +' as MAG_ID ');
        SQL.Add(' from TF_WEBG_EXPSTOCK(:LOT,:MAJSTK,:PMAGID,:CUMULID,:PASSID)');
        ParamByName('LOT').AsInteger := 1;
        ParamByName('MAJSTK').AsInteger := 0;
        // pas de mise à jour des seuils avec 0
        ParamByName('PMAGID').AsInteger := iExtractMagId;
        ParamByName('PASSID').AsInteger := MySiteParams.iAssID;
        ParamByName('CUMULID').AsInteger := iCumulMagId;
        Open;
      end;
      DoCsv(Que_Tmp, GGENPATHCSV + 'STOCKLOT_' + IntToStr(iExtractMagId) +
        '.TXT');
    except on E: Exception do
        raise Exception.Create('STOCKLOT_' + IntToStr(iExtractMagId) + '.TXT -> '
          + E.Message);
    end;

    Result := True;
  except on E: Exception do
    begin
      LogAction('Erreur lors de la génération des csv : ' + E.Message, 1);
    end;
  end;
end;

function DoCsv(DataSet: TDataSet; sFileName: string; AFilter: String=''; AChampUnique: String = ''): Boolean;
var
  Header: TExportHeaderOL;
  i: integer;
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
        LogAction(Format('Des erreurs d''unicité ont eu lieu lors de l''export du fichier %s. Des lignes n''ont pas été prisent en compte.', [ExtractFileName(sFileName)]), 0);
        LogAction('Merci de contacter le service client de Ginkoia afin de corriger les informations en double.', 0);
        LogAction('Liste des lignes erreur :'#13#10 + Header.sLignesDoubles, 0);
      end;
    except on E: Exception do
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
end;

function DoGenCde: Boolean;
var
  FTPCde: TFTPData;
  i: integer;
  Cde: TCde;
  sArchPath: string;
  sErreurPath: string;
begin
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

      // connexion au FTP
      if GenFTPConnection(FTPCde) then
      try
        // récupération des fichiers
        if GenFTPDownloadFile(FTPCde) then
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
                  on E:Exception do begin
                    LogAction(E.Message,0);
                    Cde.bValid:=false;
                  end;
                end;

                if Cde.bValid then //fichier valide
                begin             
                  try
                    DoGenCdeToDb(Cde);
                  except 
                    on E:Exception do begin
                      LogAction('Fichier: '+FTPCDE.FileList[i]+' : '+E.Message,0);
                      Cde.bValid:=false;
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
        GenFTPClose;
      end;
    finally
      FTPCde.FileList.Free;
    end;
  except on E: Exception do
      raise Exception.Create('DoCde -> ' + E.Message);
  end;
end;

function GenFTPConnection(FTPCfg: TFTPData): Boolean;
var
  i: Integer;
  lst: TStringList;
begin
  Result := False;
  with Dm_Common, FTP do
  try
    // On annule toute action du FTP et on coupe la connection s'il est encore connecté
    GenFTPClose;

    // configuration du FTP
    if Trim(FTPCfg.Host) = '' then
      Exit;

    Host            := FTPCfg.Host;
    Username        := FTPCfg.User;
    Password        := FTPCfg.Psw;
    Port            := FTPCfg.Port;
    Passive         := True;
    ConnectTimeout  := MyIniParams.iConnect; // (3s)
    TransferTimeout := MyIniParams.iTransfer;
    ReadTimeout     := MyIniParams.iRead;
    Connect;

    if Connected then
    begin
      if Trim(FTPCfg.FTPDirectory) <> '' then
      begin
        // On va se positionner dans le répertoire de traitement du FTP
        lst := TStringList.Create;
        try
          lst.Text := StringReplace(FTPCfg.FTPDirectory, '/', #13#10,
            [rfReplaceAll]);
          for i := 0 to Lst.Count - 1 do
            if Trim(lst[i]) <> '' then
              ChangeDir(Trim(lst[i]));
        finally
          lst.Free;
        end;
      end;

      Result := True;
    end;
  except on E: Exception do
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
  lst: TStringList;
  iTry: Integer;
  bGet: Boolean;
  bDelete: Boolean;
begin
  Result := False;
  with Dm_Common, FTP do
  try
    try
      FTP.ReadTimeout     := 5000;
      FTP.TransferTimeout := 5000;
      FTP.List(FTPCfg.FileList, FTPCfg.FileFilter, False);
    except on E:Exception do
      begin
        LogAction('Pas de commande à récupérer', 3);
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
      if (RightStr(FTPCfg.FileList[i], 4) = RightStr(FTPCfg.FileFilter, 4)) then
        while not bGet and not bDelete and (iTry < 3) do
        begin
          try
            Get(FTPCfg.FileList[i], FTPCfg.SavePath + FTPCfg.FileList[i], True);
            if FTPCfg.bDeleteFile then
              Delete(FTPCfg.FileList[i]);
            bGet := True;
            bDelete := True;
          except on E: Exception do
            begin
              inc(iTry);
              if iTry >= 3 then
                raise
                  Exception.Create('GenFTPDownloadFile -> Nombre d''essai atteint : ' + E.Message);
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
var
  Rec: TSearchRec;
  i: integer;
  sArchPath: string;
  LstFile: TStringList;
  sFile: String;
  iSize: Int64;
  bSend: Boolean;
  bDel: Boolean;
  iTry: Integer;
begin
  Result := True;  // par défaut ok;
  
  sArchPath := FTPCfg.SourcePath + 'Send\';
  if not DirectoryExists(sArchPath) then
    ForceDirectories(sArchPath);

  LstFile := TStringList.Create;
  try
    // Liste des fichiers d'un repertoire
    i := FindFirst(FTPCfg.SourcePath + FTPCfg.FileFilter, faAnyFile, Rec);
    while (i = 0) do
    begin
      sFile:=ExtractFileName(rec.Name);
      if (sFile<>'.') and (sFile<>'..') and ((Rec.Attr and faDirectory)<>faDirectory) then
        LstFile.Add(sFile);
      i:=FindNext(Rec);
    end;
    SysUtils.FindClose(Rec);

    // transfert FTP des fichiers 
    with Dm_Common, FTP do
    try
      for i := 1 to LstFile.Count do
      begin
        sFile := LstFile[i-1];

        // tentative d'effacer le fichier distant 3 fois de suite
        iSize := Size(sFile);
        bDel := (iSize < 0);
        iTry := 0;
        while (Not bDel) and (iTry < 3) do
        begin
          try
            if iSize >= 0 then
            begin
              try
                Delete(sFile);
              except
              end;
            end;
            iSize := Size(sFile);
            bDel := (iSize < 0);
            if (Not bDel) then
              Sleep(500);  //attente d'1/2 seconde entre les essais
          except
          end;
          inc(iTry);
        end;
        if (Not bDel) then
        begin
          LogAction('Impossible de supprimer le fichier distant: ' + sFile,1);
        end;

        // tentative de transferer 3 fois le fichier 
        bSend := False;
        iTry := 0;
        while not bSend and (iTry < 3) do
        begin
          try
            Put(FTPCfg.SourcePath + sFile, sFile, True);
            bSend := True;
          except
          end; // try
          if not(bSend) then
            Sleep(500);  //attente d'1/2 seconde entre les essais
          inc(iTry);
        end;

        //archivage si ok, sinon log
        if bSend then
        begin
          if FileExists(sArchPath + sFile) then
            SysUtils.DeleteFile (sArchPath + sFile);

          if not(RenameFile(FTPCfg.SourcePath + sFile, sArchPath + sFile)) then
            LogAction('GenFTPUploadFile Problème d''archivage de ' + sFile, 1);
        end
        else begin
          LogAction('Impossible de transférer le fichier: '+sFile,0);
          result := false;
        end;

      end;

    except on E: Exception do
      begin
        Result:=false;
        LogAction('Erreur de transfert des fichiers du FTP -> ' + FTPCfg.Host +
          ' : ' + E.Message, 0);
        raise Exception.Create('GenFTPUploadFile -> ' + E.Message);
      end;
    end;

  finally
    LstFile.Free;
  end;
end;

procedure GenFTPClose;
begin
  with Dm_Common, FTP do
  begin
    if Connected then
    begin
      Abort;
      Disconnect;
    end;
  end;
end;

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

  (*LogAction('***  Erreur dans le fichier de commande: ' +
    ExtractFileName(AFichier) + '  ***', 0);
  if ANoeud <> '' then
    LogAction('    Noeud = ' + ANoeud, 0);
  if ACommNum <> '' then
    LogAction('    N° Commande = ' + ACommNum, 0);
  LogAction('    Id Commande = ' + inttostr(ACommId), 0);
  if ANomCli <> '' then
    LogAction('    Client = ' + ANomCli, 0);
  case ATypeLigne of
    1: LogAction('    Type de ligne = Ligne', 0);
    2: LogAction('    Type de ligne = Lot', 0);
    3: LogAction('    Type de ligne = CodePromo', 0);
  end;
  if ACodeArt <> '' then
    LogAction('    Code Art. = ' + ACodeArt, 0);
  if ALibProd <> '' then
    LogAction('    Lib. Art. = ' + ALibProd, 0);
  LogAction('    Erreur = ' + ALibErr, 0);     *)
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

function DoXmlGenToRecord(sXmlfile: string): TCde;
type
  TCumTva=record
    OkUse:boolean;
    TxTva:Double;
    HT:Double;
    TTC:Double;
  end;
var
  CdeNode,
    ClientNode,
    AdrFactNode,
    AdrLivrNode,
    ColisNode,
    LignesNode,
    LigneNode,
    TVASNode,
    TVANode: IXmlNode;
  i, j: integer;

  bOk: boolean; // pour le controle des champs
  NomCli: string; // nom du client pour les log
  CdeNum: string; // N° de commande pour les log
  CdeId: integer; // Id de commande pour les log
  vTypLig: integer; //Type de ligne pour les log  1: art  2: lot  3: code promo
  ArtInfos: stArticleInfos; //pour tester les articles
  LstLot: TStringList; //pour test le lot
  vLigHT:Double;
  vLigTVA:Double;
  vLigTTC:Double;
  TotLigHT:Double;
  TotLigTTC:Double;

  bAdrFactNode: boolean;   //balise AddressFact ok
  bAdrLivrNode: boolean;   //balise AddressLivr ok

  bOkLesLignes: boolean;   //le calcul des lignes s'est bien passé  (bOkLigCtrlHTetTTC n'a jamais été à false)
  bOkLesTva: boolean;      //le calcul des cumul tva s'est bien passé (bOkTvaCtrlHTetTTC n'a jamais été à false)
  bOkLigCtrlHTetTTC: boolean; //test si on peut faire le controle entre le ht, tva et ttc sur la ligne
  bOkTvaCtrlHTetTTC: boolean; //test si on peut faire le controle entre le ht, tva et ttc sur la tva
  bOkTotCtrlHTetTTC: boolean; //test si on peut faire le controle entre le ht, tva et ttc sur le total
  ArrCumTva:Array [1..5] of TCumTva;  //pour le calcul de cumul tva par taux
  LPosCumTva:integer;  //position ds l'array de ArrCumTva

  TxTVANouv: Currency;
begin

  //true = Format du fichier xml ok par défaut
  Result.bValid := true;
  NomCli := '';
  CdeNum := '';
  CdeId := 0;
  TotLigHT:=0;
  TotLigTTC:=0;

  bOkLesLignes := true;   //le calcul des lignes s'est bien passé  (bOkLigCtrlHTetTTC n'a jamais été à false)
  bOkLesTva := true;      //le calcul des cumul tva s'est bien passé (bOkTvaCtrlHTetTTC n'a jamais été à false)
  //initialisation pour le calcul de cumul tva par taux
  for i:=1 to 5 do
  begin
    ArrCumTva[i].OkUse:=false;
    ArrCumTva[i].TxTva:=0.0;
    ArrCumTva[i].HT:=0.0;
    ArrCumTva[i].TTC:=0.0;
  end;

  LstLot := TStringList.Create;
  try

    with Dm_Common do
    try
      MyDoc.LoadFromFile(sXmlfile);

      //voir MyDoc.encoding

      CdeNode := MyDoc.DocumentElement;
      with CdeNode, Result do
      begin
        XmlFile := sXmlfile;
        InfosSupp := '';
        with CommandeInfos do
        begin

          //N° Commande pas obligatoire , long max = 32
          if not(IsBaliseExists(CdeNode,'CommandeNum')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise CommandeNum non trouvé', Result.bValid);
          end
          else begin
            CommandeNum := XmlStrToStr(ChildValues['CommandeNum']);
            CdeNum := CommandeNum;
            if CtrlValidStr(CommandeNum, False, 32) = 2 then
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                NomCli, 0, '', '',
                'Longueur N° Commande trop grande',
                Result.bValid);
          end;

          //CommandeId doit être >0
          if not(IsBaliseExists(CdeNode,'CommandeId')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise CommandeId non trouvé', Result.bValid);
          end
          else begin
            CommandeId := XmlStrToInt(ChildValues['CommandeId']);
            CdeId := CommandeId;
            if CommandeId <= 0 then
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                NomCli, 0, '', '',
                'Id de la commande invalide ou manquant',
                Result.bValid);
          end;

          //Contrôle date de commande
          if not(IsBaliseExists(CdeNode,'CommandeDate')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise CommandeDate non trouvé', Result.bValid);
          end
          else begin
            CommandeDate := XmlStrToDate(ChildValues['CommandeDate'], bOk);
            if not (bOk) then
            begin
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                NomCli, 0, '', '',
                'Date de commande invalide',
                Result.bValid);
            end
            else
            begin
              //Date de commande oblig
              if Trunc(CommandeDate) = 0 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                  NomCli, 0, '', '',
                  'Date de commande manquant',
                  Result.bValid);
              end;
            end;
          end;

          //Contrôle du Statut
          if not(IsBaliseExists(CdeNode,'Statut')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise Statut non trouvé', Result.bValid);
          end
          else begin
            Statut := UpperCase(XmlStrToStr(ChildValues['Statut']));
            if (Statut <> 'PAYE') and (Statut <> 'CHEQUE') then
            begin
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                NomCli, 0, '', '',
                'Statut invalide ou manquant',
                Result.bValid);
            end;
          end;

          //mode de règlement obligatoire
          if not(IsBaliseExists(CdeNode,'ModeReglement')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise ModeReglement non trouvé', Result.bValid);
          end
          else begin
            ModeReglement := XmlStrToStr(ChildValues['ModeReglement']);
            case CtrlValidStr(ModeReglement, True, 32) of
              1:DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Mode de règlement obligatoire',
                    Result.bValid);
              2:DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Longueur Mode de règlement trop grande',
                    Result.bValid);
            end;
          end;

          //Contrôle Date de règlement
          if not(IsBaliseExists(CdeNode,'DateReglement')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise DateReglement non trouvé', Result.bValid);
          end
          else begin
            DateReglement := XmlStrToDate(ChildValues['DateReglement'], bOk);
            if not (bOk) then
            begin
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                NomCli, 0, '', '',
                'Date de règlement invalide',
                Result.bValid);
            end;
          end;

          //Contrôle Export
          if not(IsBaliseExists(CdeNode,'Export')) then
          begin
            DoErreurBalise(sXmlfile, 'Commande',
                           'Balise Export non trouvé', Result.bValid);
          end
          else begin
            iExport := XmlStrToInt(ChildValues['Export'], -1);
            if (iExport < 0) or (iExport > 1) then
            begin
              DoErreurGeneric(sXmlfile, 'Commande', CdeNum, CdeId,
                NomCli, 0, '', '',
                'Valeur export invalide',
                Result.bValid);
            end;
          end;
        end;

        //Client
        if not(IsBaliseExists(CdeNode,'Client')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Noeud Client non trouvé', Result.bValid);
        end
        else begin
          ClientNode := ChildNodes['Client'];
          with Client, ClientNode do
          begin

            //Contrôle balise AddressFact
            bAdrFactNode:=true;
            if not(IsBaliseExists(ClientNode,'AddressFact')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Client',
                             'Noeud AddressFact non trouvé', Result.bValid);
              bAdrFactNode:=false;
            end;
            AdrFactNode := ChildNodes['AddressFact'];
                                               
            //Contrôle balise AddressLivr
            bAdrLivrNode:=true;
            if not(IsBaliseExists(ClientNode,'AddressLivr')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Client',
                             'Noeud AddressLivr non trouvé', Result.bValid);
              bAdrLivrNode:=false;
            end;
            AdrLivrNode := ChildNodes['AddressLivr'];

            //Contrôle CodeClient  
            if not(IsBaliseExists(ClientNode,'CodeClient')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Client',
                             'Balise CodeClient non trouvé', Result.bValid);
            end
            else begin
              Codeclient := XmlStrToInt(ChildValues['CodeClient']);
              if Codeclient <= 0 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId,
                  NomCli, 0, '', '',
                  'Code client invalide ('+inttostr(Codeclient)+')',
                  Result.bValid);
              end;
            end;

            //controle EMail, oblig., long. max = 64   
            if not(IsBaliseExists(ClientNode,'Email')) then
            begin
              DoErreurBalise(sXmlfile, 'Commande\Client',
                             'Balise Email non trouvé', Result.bValid);
            end
            else begin
              Email := XmlStrToStr(ChildValues['Email']);
              case CtrlValidStr(EMail, true, 64) of
                1: DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'EMail obligatoire',
                    Result.bValid);
                2: DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Longueur EMail trop grande',
                    Result.bValid);
              else
                if not (CtrlValidMail(EMail)) then
                  DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'EMail invalide',
                    Result.bValid);
              end;
            end;

            //les contrôles sont dans XmlAdrToAdr
            //Client Facturé
            if bAdrFactNode then begin
              AdresseFact := XmlAdrToAdr(sXmlFile, Result, AdrFactNode,
                Result.bValid);
              NomCli := AdresseFact.sAdr_Nom;
            end;
            
            //Client à livrer
            if bAdrLivrNode then
              AdresseLivr := XmlAdrToAdr(sXmlFile, Result, AdrLivrNode,
                Result.bValid);
          end;
        end;

        { TODO -oCH : pas contrôle sur colis ?? }
        ColisNode := ChildNodes['Colis'];
        with Colis, ColisNode do
        begin
          Numero := XmlStrToStr(ChildValues['Numero']);
          Transporteur := XmlStrToStr(ChildValues['Transporteur']);
          MagasinRetrait := XmlStrToStr(ChildValues['MagasinRetrait']);
        end;

        //Lignes
        if not(IsBaliseExists(CdeNode,'Lignes')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Noeud Lignes non trouvé', Result.bValid);
          bOkLesLignes:=false;
        end
        else begin
          LignesNode := ChildNodes['Lignes'];
          if LignesNode.ChildNodes.Count=0 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande\Lignes', CdeNum, CdeId,
               NomCli, 0, '', '',
               'Aucune ligne d''article n''a été trouvée !',
               Result.bValid);
            bOkLesLignes:=false;
          end
          else begin
            SetLength(Lignes, LignesNode.ChildNodes.Count);
            for i := 0 to LignesNode.ChildNodes.Count - 1 do
            begin
              LigneNode := LignesNode.ChildNodes[i];
              with LigneNode, Lignes[i] do
              begin
                //Contrôle type de ligne     
                if not(IsBaliseExists(LigneNode,'TypeLigne')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise TypeLigne non trouvé', Result.bValid);
                end
                else begin
                  TypeLigne := XmlStrToStr(ChildValues['TypeLigne']);
                  if (UpperCase(TypeLigne) <> 'LIGNE') and (Uppercase(TypeLigne) <>
                    'LOT')
                    and (UpperCase(TypeLigne) <> 'CODEPROMO') then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' + inttostr(i
                      + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, 0, '', '',
                      'Type de ligne invalide',
                      Result.bValid);
                  end;
                end;

                //pour les log
                vTypLig := 0;
                if (UpperCase(TypeLigne) = 'LIGNE') then
                  vTypLig := 1;
                if (Uppercase(TypeLigne) = 'LOT') then
                  vTypLig := 2;
                if (UpperCase(TypeLigne) = 'CODEPROMO') then
                  vTypLig := 3;

                { TODO -oCH : pas de contrôle sur la désignation ?? }
                if not(IsBaliseExists(LigneNode,'Designation')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise Designation non trouvé', Result.bValid);
                end
                else begin
                  Designation := XmlStrToStr(ChildValues['Designation']);
                  if CtrlValidStr(Designation, true, 0)=1 then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Client', CdeNum, CdeId,
                        NomCli, 0, '', '',
                        'EMail obligatoire',
                        Result.bValid);
                  end;
                end;

                //Controle du code suivant le type de ligne
                if not(IsBaliseExists(LigneNode,'Code')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise Code non trouvé', Result.bValid);
                end
                else begin
                  Code := XmlStrToStr(ChildValues['Code']);
                  case vTypLig of
                    1: //code article
                      begin
                        ArtInfos := DM_Common.GetArticleInfos(Code);
                        if not (ArtInfos.IsValide) then
                        begin
                          DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' +
                            inttostr(i + 1) + ')',
                            CdeNum, CdeId,
                            NomCli, vTypLig, Code, Designation,
                            'Code Article invalide ou inconnu',
                            Result.bValid);
                        end;
                      end;
                    2: //code lot
                      begin
                        LstLot.Clear;
                        LstLot.Text := StringReplace(Code, '*', #13#10,
                          [rfReplaceAll]);
                        if LstLot.Count <= 1 then
                        begin
                          DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' +
                            inttostr(i + 1) + ')',
                            CdeNum, CdeId,
                            NomCli, vTypLig, Code, Designation,
                            'Code lot invalide',
                            Result.bValid);
                        end
                        else
                        begin
                          //test N° lot
                          case DM_Common.IsLotValid(StrToIntDef(LstLot[0], -1)) of
                            1:
                              begin
                                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                                  + inttostr(i + 1) + ')',
                                  CdeNum, CdeId,
                                  NomCli, vTypLig, Code, Designation,
                                  'N° lot invalide: ' + Trim(LstLot[0]),
                                  Result.bValid);
                              end;
                            2:
                              begin
                                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                                  + inttostr(i + 1) + ')',
                                  CdeNum, CdeId,
                                  NomCli, vTypLig, Code, Designation,
                                  'N° lot inconnu: ' + Trim(LstLot[0]),
                                  Result.bValid);
                              end;
                            3:
                              begin
                                DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                                  + inttostr(i + 1) + ')',
                                  CdeNum, CdeId,
                                  NomCli, vTypLig, Code, Designation,
                                  'N° lot supprimé: ' + Trim(LstLot[0]),
                                  Result.bValid);
                                bOk := false;
                              end;
                          end;
                          for j := 1 to LstLot.Count do
                          begin
                            ArtInfos := DM_Common.GetArticleInfos(Trim(LstLot[j]));
                            if not (ArtInfos.IsValide) then
                              DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' +
                                inttostr(i + 1) + ')',
                                CdeNum, CdeId,
                                NomCli, vTypLig, Code, Designation,
                                'Code article ' + Trim(LstLot[j]) +
                                  ' inconnu pour ce lot',
                                Result.bValid);
                          end;
                        end;
                      end;
                    3: //code promo
                      begin
                        if not (DM_Common.IsCodePromoValid(StrTointDef(Code,-1))) then
                        begin 
                          DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°' +
                            inttostr(i + 1) + ')',
                            CdeNum, CdeId,
                            NomCli, vTypLig, Code, Designation,
                            'Code Promo invalide ou inconnu',
                            Result.bValid);
                        end;
                      end;
                  else
                    //peut pas contrôler, car on ne sais pas le type de ligne
                  end;
                end;

                //Contrôle de PUBrutHT
                if not(IsBaliseExists(LigneNode,'PUBrutHT')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise PUBrutHT non trouvé', Result.bValid);
                end
                else begin
                  PUBrutHT := XmlStrToFloat(ChildValues['PUBrutHT'],bOk);
                  if not(bOk) then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'PU Brut avant remise HT invalide ',
                      Result.bValid);
                  end;
                end;

                //Contrôle de PUBrutTTC
                if not(IsBaliseExists(LigneNode,'PUBrutTTC')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise PUBrutTTC non trouvé', Result.bValid);
                end
                else begin
                  PUBrutTTC := XmlStrToFloat(ChildValues['PUBrutTTC'],bOk);
                  if not(bOk) then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'PU Brut avant remise TTC invalide ',
                      Result.bValid);
                  end;
                end;

                //Contrôle de PUHT
                if not(IsBaliseExists(LigneNode,'PUHT')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise PUHT non trouvé', Result.bValid);
                end
                else begin
                  PUHT := XmlStrToFloat(ChildValues['PUHT'],bOk);
                  if not(bOk) then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'PU remisé HT invalide ',
                      Result.bValid);
                  end;
                end;

                //Contrôle de PUTTC
                if not(IsBaliseExists(LigneNode,'PUTTC')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise PUTTC non trouvé', Result.bValid);
                end
                else begin
                  PUTTC := XmlStrToFloat(ChildValues['PUTTC'],bOk);
                  if not(bOk) then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'PU remisé TTC invalide ',
                      Result.bValid);
                  end;
                end;
                                
                bOkLigCtrlHTetTTC:=true;  //par defaut, on peut controler la cohérence entre HT, Tva, et ttc (plus bas)
                //Contrôle de TxTVA
                if not(IsBaliseExists(LigneNode,'TxTva')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise TxTva non trouvé', Result.bValid); 
                  bOkLigCtrlHTetTTC:=false;
                  bOkLesLignes:=false;
                end
                else begin
                  TxTVA := XmlStrToFloat(ChildValues['TxTva'],bOk);
                  if not(bOk) then
                  begin                  
                    bOkLigCtrlHTetTTC:=false;
                    bOkLesLignes:=false;
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'Taux TVA invalide ',
                      Result.bValid);
                  end;
                end;
            
                //Contrôle de Qte
                if not(IsBaliseExists(LigneNode,'Qte')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise Qte non trouvé', Result.bValid);
                end
                else begin
                  Qte := XmlStrToInt(ChildValues['Qte']);
                  if Qte<=0 then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'Quantité invalide ',
                      Result.bValid);
                  end;
                  case vTypLig of
                    2:  //lot
                    begin
                      { TODO -oCH : Verifier la qté pour un lot s'il doit être obligatoirement égale à 1 ou pas }
                    end;
                    3:   //code promo
                    begin
                      if Qte<>1 then
                      begin
                        DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                          + inttostr(i + 1) + ')',
                          CdeNum, CdeId,
                          NomCli, vTypLig, Code, Designation,
                          'Quantité doit être à 1 pour ine ligne Code Promo ',
                          Result.bValid);
                      end;
                    end;
                  end;
                end;

                //Contrôle de PXHT
                if not(IsBaliseExists(LigneNode,'PXHT')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise PXHT non trouvé', Result.bValid);
                  bOkLigCtrlHTetTTC:=false;
                  bOkLesLignes:=false;
                end
                else begin
                  PXHT := XmlStrToFloat(ChildValues['PXHT'],bOk);
                  if not(bOk) then
                  begin            
                    bOkLigCtrlHTetTTC:=false;
                    bOkLesLignes:=false;
                    DoErreurGeneric(sXmlfile,'Commande\Lignes\Ligne(N°'+inttostr(i+1)+')',
                                    CdeNum, CdeId,
                                    NomCli, vTypLig, Code, Designation,
                                    'Prix total HT invalide ',
                                    Result.bValid);
                  end;
                end;
            
                //Contrôle de PXTTC
                if not(IsBaliseExists(LigneNode,'PXTTC')) then
                begin
                  DoErreurBalise(sXmlfile, 'Commande\Ligne(N°' + inttostr(i+1)+')',
                                 'Balise PXTTC non trouvé', Result.bValid);
                  bOkLigCtrlHTetTTC:=false;
                  bOkLesLignes:=false;
                end
                else begin
                  PXTTC := XmlStrToFloat(ChildValues['PXTTC'],bOk);
                  if not(bOk) then
                  begin
                    bOkLigCtrlHTetTTC:=false;
                    bOkLesLignes:=false;
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'Prix total TTC invalide ',
                      Result.bValid);
                  end;
                end;

                //contrôle cohérence HT et TTC
                if bOkLigCtrlHTetTTC then
                begin
                  vLigTTC:=ArrondiA2(PXTTC);
                  vLigHT:=ArrondiA2(vLigTTC/(1+(TxTVA/100)));
                  if Abs(ArrondiA2(vLigHT-PXHT))>0.02 then
                  begin
                    DoErreurGeneric(sXmlfile, 'Commande\Lignes\Ligne(N°'
                      + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, vTypLig, Code, Designation,
                      'Prix total HT incohérent avec le calcul prix totalTTC et le taux de TVA',
                      Result.bValid);
                  end;
                  TotLigHT:=TotLigHT+PXHT;
                  TotLigTTC:=TotLigTTC+PXTTC;
                  //cumul par tx tva
                  LPosCumTva:=-1;
                  j:=1;
                  while (LPosCumTva=-1) and (j<=5) do
                  begin
                    if (ArrondiA2(ArrCumTva[j].TxTva)=ArrondiA2(TxTVA)) and
                          ArrCumTva[j].OkUse then
                      LPosCumTva:=j;
                    Inc(j);
                  end;
                  if LPosCumTva>0 then
                  begin
                    ArrCumTva[LPosCumTva].HT:=ArrondiA2(ArrCumTva[LPosCumTva].HT+PXHT);
                    ArrCumTva[LPosCumTva].TTC:=ArrondiA2(ArrCumTva[LPosCumTva].TTC+PXTTC);
                  end
                  else
                  begin
                    LPosCumTva:=-1;
                    j:=1;
                    while (LPosCumTva=-1) and (j<=5) do
                    begin
                      if not(ArrCumTva[j].OkUse) then
                        LPosCumTva:=j;
                      Inc(j);
                    end;
                    if LPosCumTva=-1 then
                      Raise Exception.Create('Trop de taux de tva !');
                    ArrCumTva[LPosCumTva].OkUse:=true;
                    ArrCumTva[LPosCumTva].TxTva:=ArrondiA2(TxTVA);
                    ArrCumTva[LPosCumTva].HT:=ArrondiA2(PXHT);
                    ArrCumTva[LPosCumTva].TTC:=ArrondiA2(PXTTC);
                  end;

                end;
              end;
            end;    //for i := 0 to LignesNode.ChildNodes.Count - 1 do
          end;     //else du: if LignesNode.ChildNodes.Count=0 then
        end;  //else de test existance balise lignes

        //Tvas
        if not(IsBaliseExists(CdeNode,'TVAS')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Noeud TVAS non trouvé', Result.bValid);
          bOkLesTva:=false;
        end
        else begin
          TVASNode := ChildNodes['TVAS'];
          SetLength(TVAS, TVASNode.ChildNodes.Count);
          //Contrôle s'il y a au moins 1 ligne de TVA
          if TVASNode.ChildNodes.Count=0 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande\TVAS',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Il faut au moins une balise TVA !',
              Result.bValid);  
            bOkLesTva:=false;
          end;

          if TVASNode.ChildNodes.Count>5 then
          begin
            DoErreurGeneric(sXmlfile, 'Commande\TVAS',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Trop de balise TVA ( >5 ) !',
              Result.bValid);  
            bOkLesTva:=false;
          end;

          for i := 0 to TVASNode.ChildNodes.Count - 1 do
          begin
            bOkTvaCtrlHTetTTC:=true;   //par defaut, on peut controler la cohérence entre HT, Tva, et ttc (plus bas)
            TVANode := TVASNode.ChildNodes[i];
            with TVANode, TVAS[i] do
            begin
              //Controle TotalHT
              if not(IsBaliseExists(TVANode,'TotalHT')) then
              begin
                DoErreurBalise(sXmlfile, 'Commande\TVA (N°' + inttostr(i+1)+')',
                               'Balise TotalHT non trouvé', Result.bValid);
                bOkTvaCtrlHTetTTC:=false;
                bOkLesTva:=false;
              end
              else
              begin
                TotalHT := XmlStrToFloat(ChildValues['TotalHT'],bOk);
                if not(bOk) then
                begin         
                  bOkTvaCtrlHTetTTC:=false;
                  bOkLesTva:=false;
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                    CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Total HT invalide !',
                    Result.bValid);
                end;
              end;

              //Controle TauxTva
              if not(IsBaliseExists(TVANode,'TauxTva')) then
              begin
                DoErreurBalise(sXmlfile, 'Commande\TVA (N°' + inttostr(i+1)+')',
                               'Balise TauxTva non trouvé', Result.bValid);
                bOkTvaCtrlHTetTTC:=false;
                bOkLesTva:=false;
              end
              else
              begin
                TauxTva := XmlStrToFloat(ChildValues['TauxTva'],bOk);
                if not(bOk) then
                begin
                  bOkTvaCtrlHTetTTC:=false;
                  bOkLesTva:=false;
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                    CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Taux TVA invalide !',
                    Result.bValid);
                end;
              end;

              //Controle MtTVA    
              if not(IsBaliseExists(TVANode,'MtTva')) then
              begin
                DoErreurBalise(sXmlfile, 'Commande\TVA (N°' + inttostr(i+1)+')',
                               'Balise MtTva non trouvé', Result.bValid);
                bOkTvaCtrlHTetTTC:=false;    
                bOkLesTva:=false;
              end
              else
              begin
                MtTVA := XmlStrToFloat(ChildValues['MtTva'],bOk);
                if not(bOk) then
                begin            
                  bOkTvaCtrlHTetTTC:=false;
                  bOkLesTva:=false;
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                    CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Montant Tva invalide !',
                    Result.bValid);
                end;
              end;

              //Contrôle cohérence Mt TVA
              if bOkTvaCtrlHTetTTC then
              begin
                vLigHT:=ArrondiA2(TotalHT);
                vLigTVA:=ArrondiA2(vLigHT*(TauxTva/100));
                if Abs(ArrondiA2(vLigTVA-MtTVA))>0.05 then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                    CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Montant Tva incohérent avec le Total HT et le Taux de TVA !',
                    Result.bValid);
                end;
              end;
            end;
          end;    //for i := 0 to TVASNode.ChildNodes.Count - 1 do

          //contrôle plusieurs fois le même taux dans le cumul tva
          if bOkLesTva then
          begin
            for i:=0 to High(TVAS)-1 do
            begin
              for j:=i+1 to High(TVAS) do
              begin
                if ArrondiA2(TVAS[i].TauxTva)=ArrondiA2(TVAS[j].TauxTva) then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                    CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Il y a plusieurs fois le même taux dans le tableau des cumuls des TVA',
                    Result.bValid);
                  bOkLesTva:=false;
                end;
              end;
            end;
          end;

          //Contrôle le cumul calculé dans les lignes et le tableau des cumuls
          if bOkLesTvA and bOkLesLignes
            and (CommandeInfos.iExport = 0) then
          begin
            for i:=0 to High(TVAS) do
            begin
              LPosCumTva:=-1;
              j:=1;
              while (LPosCumTva=-1) and (j<=5) do
              begin
                if (ArrCumTva[j].OkUse) and (ArrondiA2(ArrCumTva[j].TxTva)=ArrondiA2(TVAS[i].TauxTva)) then
                  LPosCumTva:=j;
                Inc(j);
              end;

              if LPosCumTva=-1 then
              begin
                DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                    CdeNum, CdeId,
                    NomCli, 0, '', '',
                    'Taux Tva ('+FloatToStr(TVAS[i].TauxTva)+'%) présent dans le cumul et pas dans les lignes',
                    Result.bValid);
              end
              else
              begin
                // Compare le HT des lignes et celui du cumul TVA
                if (Abs(ArrondiA2(ArrCumTva[LPosCumTva].HT-TVAS[i].TotalHT))>0.05) then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, 0, '', '',
                      'Calcul cumul Tva des lignes (tx: '+FloatToStr(TVAS[i].TauxTva)+'%) différent du cumul TVA',
                      Result.bValid);
                end
                else begin  //mis en commentaire dans le BL s'il y a une différence de centimes
                  if Abs(ArrondiA2(ArrCumTva[LPosCumTva].HT-TVAS[i].TotalHT))>=0.01 then
                  begin
                    if InfosSupp<>'' then
                      InfosSupp := InfosSupp + #13#10;
                    InfosSupp:=InfosSupp+'Avertissement: Cumul Tva (tx: '+FloatToStr(TVAS[i].TauxTva)+'%): '+
                               'Total HT : différence de '+
                               FormatFloat('0.00',Abs(ArrCumTva[LPosCumTva].HT-TVAS[i].TotalHT))+
                               ' avec les lignes';
                  end;
                end;
                
                // Compare le TTC des lignes et celui du cumul TVA (HT+MtTva)
                if (Abs(ArrondiA2(ArrCumTva[LPosCumTva].TTC-TVAS[i].TotalHT-TVAS[i].MtTVA))>0.0) then
                begin
                  DoErreurGeneric(sXmlfile, 'Commande\TVA (N° ' + inttostr(i + 1) + ')',
                      CdeNum, CdeId,
                      NomCli, 0, '', '',
                      'Cumul HT + Cumul Mt TVA pour tx: '+FloatToStr(TVAS[i].TauxTva)+
                      '% différent des totaux TTC des lignes',
                      Result.bValid);
                end;

              end;
            end;


          end;

        end;  //TVAS

        {DONE -oLP -cDonnées:Récupérer les prix TTC à partir des prix HT et de la TVA de l'article dans Ginkoia.}
        if (CommandeInfos.iExport = 1) then
        begin
          for i := 0 to Length(Lignes) - 1 do
          begin
            if not(SameText(Lignes[i].TypeLigne, 'CODEPROMO')) then
            begin
              if not(Dm_Common.RecupererTTC(ArtInfos.iArtId, Lignes[i].PUBrutHT, Lignes[i].PUHT, Lignes[i].PXHT,
                Lignes[i].PUBrutTTC, Lignes[i].PUTTC, Lignes[i].PXTTC, TxTvaNouv)) then
              begin
                DoErreurGeneric(sXmlfile,
                  Format('Commande\Lignes\Ligne(N°%d)', [Succ(i)]),
                  CdeNum, CdeId, NomCli, vTypLig, Lignes[i].Code, Lignes[i].Designation,
                  'Taux de TVA de l''article introuvable ',
                  Result.bValid);
                bOkLigCtrlHTetTTC := False;
                bOkLesLignes      := False;
              end
              else begin
                // Si la TVA de l'article n'est pas la même que celle du fichier XML : on modifie la TVA pour la ligne
                // et pour la liste des taux de TVAs
                if not(SameValue(Lignes[i].TxTVA, TxTvaNouv)) then
                begin
                  for j := 0 to Length(TVAS) - 1 do
                  begin
                    if SameValue(TVAS[j].TauxTva, Lignes[i].TxTVA) then
                    begin
                      TVAS[j].TauxTva := TxTvaNouv;
                      Break;
                    end;
                  end;
                  Lignes[i].TxTVA := TxTvaNouv;
                end;
              end;
            end;
          end;
        end;

        //Controle SousTotalHT
        if not(IsBaliseExists(CdeNode,'SousTotalHT')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Balise SousTotalHT non trouvé', Result.bValid);
        end
        else
        begin
          SousTotalHT := XmlStrToFloat(ChildValues['SousTotalHT'],bOk);
          if not(bOk) then
          begin
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Sous total HT invalide !',
              Result.bValid);
          end;
        end;
                                                
        //Controle FraisDePort
        if not(IsBaliseExists(CdeNode,'FraisPort')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Balise FraisPort non trouvé', Result.bValid);
        end
        else
        begin
          FraisDePort := XmlStrToFloat(ChildValues['FraisPort'],bOk);
          TotLigTTC:=ArrondiA2(TotLigTTC+FraisDePort);
          if not(bOk) then
          begin
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Frais de port invalide !',
              Result.bValid);
          end;
        end;

        {DONE -oLP -cDonnées:Ajoute la TVA au frais de port s'ils sont HT.}
        if (CommandeInfos.iExport = 1) then
        begin
          if not(IsZero(FraisDePort, 0.01)) then
          begin
            FraisDePort := FraisDePort * (1 + GetFPTauxTVA(MySiteParams.iCodeSite) / 100);
            MontantTVA  := 0;
          end;
        end;

        bOkTotCtrlHTetTTC:=true; //par defaut, on peut controler la cohérence entre HT, Tva, et ttc (plus bas)
        //Controle TotalHT
        if not(IsBaliseExists(CdeNode,'TotalHT')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Balise TotalHT non trouvé', Result.bValid);
          bOkTotCtrlHTetTTC:=false;
        end
        else
        begin
          TotalHT := XmlStrToFloat(ChildValues['TotalHT'],bOk);
          if not(bOk) then
          begin           
            bOkTotCtrlHTetTTC:=false;
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Total HT invalide !',
              Result.bValid);
          end;
        end;
        
        //Controle MontantTVA
        if not(IsBaliseExists(CdeNode,'MontantTVA')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Balise MontantTVA non trouvé', Result.bValid);
          bOkTotCtrlHTetTTC:=false;
        end
        else
        begin
          MontantTVA := XmlStrToFloat(ChildValues['MontantTVA'],bOk);
          if not(bOk) then
          begin
            bOkTotCtrlHTetTTC:=false;
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Montant Tva invalide !',
              Result.bValid);
          end;
        end;
        
        //Controle TotalTTC
        if not(IsBaliseExists(CdeNode,'TotalTTC')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Balise TotalTTC non trouvé', Result.bValid);
          bOkTotCtrlHTetTTC:=false;
        end
        else
        begin
          TotalTTC := XmlStrToFloat(ChildValues['TotalTTC'],bOk);
          if not(bOk) then
          begin        
            bOkTotCtrlHTetTTC:=false;
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Total TTC invalide !',
              Result.bValid);
          end;
        end;

        //Contrôle cohérence TotalHT + MontantTVA = TotalTTC
        if bOkTotCtrlHTetTTC and (Abs(ArrondiA2(TotalTTC-TotalHT-MontantTVA))>0.02) then
        begin
          DoErreurGeneric(sXmlfile, 'Commande',
            CdeNum, CdeId,
            NomCli, 0, '', '',
            'Total HT + Montant Tva différent de Total TTC !',
            Result.bValid);
        end;

        //Contrôle cohérence entre le ttc de toutes les lignes +Frais de port et le TotalTTC
        //pas de tolérance sur le TTC
        if bOkTotCtrlHTetTTC and bOkLesLignes
          and (CommandeInfos.iExport = 0) then
        begin
          if (Abs(ArrondiA2(TotLigTTC-TotalTTC))>0.0) then
          begin
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Total TTC des lignes + Frais de Port différent de Total TTC !',
              Result.bValid);
          end;
        end;

        //Controle NetPayer  
        if not(IsBaliseExists(CdeNode,'Netpayer')) then
        begin
          DoErreurBalise(sXmlfile, 'Commande',
                         'Balise Netpayer non trouvé', Result.bValid);
        end
        else
        begin
          NetPayer := XmlStrToFloat(ChildValues['Netpayer'],bOk);
          if not(bOk) then
          begin
            DoErreurGeneric(sXmlfile, 'Commande',
              CdeNum, CdeId,
              NomCli, 0, '', '',
              'Net à payer invalide !',
              Result.bValid);
          end;
        end;

      end;
    except on E: Exception do
        raise Exception.Create('DoXmlGenToRecord -> ' + E.Message);
    end;
  finally
    LstLot.Free;
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
          ACde.CommandeInfos.CommandeNum,
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
            ACde.CommandeInfos.CommandeNum,
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Nom client obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
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
            ACde.CommandeInfos.CommandeNum,
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Adresse 1 obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
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
            ACde.CommandeInfos.CommandeNum,
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Code postal obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            ACde.CommandeInfos.CommandeNum,
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
            ACde.CommandeInfos.CommandeNum,
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Ville obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            ACde.CommandeInfos.CommandeNum,
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
            ACde.CommandeInfos.CommandeNum,
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Pays obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            ACde.CommandeInfos.CommandeNum,
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
            ACde.CommandeInfos.CommandeNum,
            ACde.CommandeInfos.CommandeId,
            sAdr_Nom, 0, '', '',
            'Code ISO Pays obligatoire',
            bValid);
        2: DoErreurGeneric(AFichier, 'Commande\Client\' + XmlNode.NodeName,
            ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
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
          ACde.CommandeInfos.CommandeNum,
          ACde.CommandeInfos.CommandeId,
          sAdr_Nom, 0, '', '',
          'Longueur fax trop grande',
          bValid);
      end;
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

    TpS[Pos('.',TpS)] := DecimalSeparator;
    Result := StrToFloat(TpS);
    bValid := true;
    
  except
    on E: Exception do
      bValid:=false;
  end;
end;

function XmlStrToDate(Value: OleVariant; var bValid: boolean): TDateTime;
var
  d, m, y, h, mn, s, zz: Word;
  TpS: string;
begin
  Result := 0.0;
  bValid := true;
  TpS := XmlStrToStr(Value);
  if TpS = '' then
    exit;

  if Length(TpS) <> 22 then
  begin
    bValid := false;
    exit;
  end;

  if TpS <> '' then //yyyy-mm-dd hh:nn:ss.zz
  begin
    try
      //test si les bons caractères sont mis au bon endroit
      //mechant mais, ils n'ont qu'à prendre ATIPIC
      if (TpS[5] <> '-') or (TpS[8] <> '-')
        or (TpS[11] <> ' ') or (TpS[14] <> ':')
        or (TpS[17] <> ':') or (TpS[20] <> '.') then
      begin
        bValid := false;
        exit;
      end;
      y := StrToIntDef(Copy(TpS, 1, 4), 3000);
      m := StrToIntDef(Copy(TpS, 6, 2), 40);
      d := StrToIntDef(Copy(TpS, 9, 2), 40);
      h := StrToIntDef(Copy(TpS, 12, 2), 40);
      mn := StrToIntDef(Copy(TpS, 15, 2), 100);
      s := StrToIntDef(Copy(TpS, 18, 2), 100);
      zz := StrToIntDef(Copy(TpS, 21, 2), 100);
      if (y = 3000) or (m = 40) or (d = 40)
        or (h = 40) or (mn = 100) or (s = 100) or (zz = 100) then
      begin
        bValid := false;
        exit;
      end;
      Result := EncodeDateTime(y, m, d, h, mn, s, zz);
      bValid := true;

    except
      bValid := false;
    end;
  end;
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

function DoGenCdeToDb(Cde: TCde): Boolean;
var
  i, j: Integer;
  ArtInfos: stArticleInfos;
  lstLot: TStringList;
  LineTmp: TLigneCDE;
  bLineCreate: Boolean;
  iLotNum: integer;
begin
  with Dm_Common, Cde do
  try
    // On vérifie que la commande n'existe pas encore
    if not CdeExists(Cde.CommandeInfos.CommandeId) then
    begin
      IbT_Modif.StartTransaction;
      iLotNum := 0;
      // si elle n'existe pas alors on va vérifier si le client n'exite pas encore
      GenCreateClient(Client);

      // On va créer l'entete du bl de la commande
      GenCreateEnteteBL(Cde);

      // Puis on va créer les lignes du bl de la commande
      for i := 0 to High(Lignes) do
      begin
        bLineCreate := False;
        with Lignes[i] do
        begin
          inc(iLotNum);
          LotId := 0;
          LotNum := 0;

          case AnsiIndexStr(Trim(UpperCase(TypeLigne)), ['LIGNE', 'LOT',
            'CODEPROMO']) of
            0:
              begin // Ligne
                ArtInfos := GetArticleInfos(Code);
                // est ce que l'article est valide
                if not ArtInfos.isValide then
                  raise Exception.Create('La commande : ' + CDE.XmlFile +
                    ' a un article incorrect : ' + Code);

                bLineCreate := GenCreateLineBL(CommandeInfos.CommandeId,
                  ArtInfos, Lignes[i]);

                if not bLineCreate then
                begin
                  Raise Exception.Create('Problème lors de la création d''une ligne du BL : '
                    + IntToStr(CommandeInfos.CommandeId));
                end;
              end;

            1:
              begin // Lot
                lstLot := TStringList.Create;
                try
                  lstLot.Text := StringReplace(Code, '*', #13#10,
                    [rfReplaceAll]);
                  LineTmp := Lignes[i];
                  for j := 1 to lstLot.Count - 1 do
                  begin
                    LineTmp.LotId := StrToIntDef(Trim(lstLot[0]), 0);
                    LineTmp.LotNum := iLotNum;
                    ArtInfos := GetArticleInfos(Trim(lstLot[j]));

                    // est ce que l'article est valide
                    if not ArtInfos.isValide then
                      raise Exception.Create('La commande : ' + CDE.XmlFile +
                        ' a un lot incorrect : ' + IntToStr(LineTmp.LotId));

                    bLineCreate := GenCreateLineBL(CommandeInfos.CommandeId,
                      ArtInfos, LineTmp);
                    if not bLineCreate then
                    begin
                      Raise Exception.Create('Problème lors de la création d''un lot du BL :'
                        + IntToStr(CommandeInfos.CommandeId));
                    end;
                  end;
                finally
                  lstLot.Free;
                end;
              end;

            2:
              begin // CodePromo

                with Lignes[i], ArtInfos do
                begin
                  iArtId := StrToInt(Trim(Code));
                  // c'est l'artid dans l'xml contrairement aux autres où c'est le CB
                  iTgfId := 0;
                  iCouId := 0;
                  fPxAchat := -abs(PXHT);
                  fPxBrut := -abs(PUBrutHT);
                  fTVA := 0;
                end;

                // aux cas où on met négatif les codepromo
                with Lignes[i] do
                begin
                  PUBrutHT := -abs(PUBrutHT);
                  PUBrutTTC := -abs(PUBrutTTC);
                  PUHT := -abs(PUHT);
                  PXHT := -abs(PXHT);
                  PXTTC := -abs(PXTTC);
                end;

                bLineCreate := GenCreateLineBL(CommandeInfos.CommandeId,
                  ArtInfos, Lignes[i]);

                if not bLineCreate then
                begin
                  Raise Exception.Create('Problème lors de la création d''un code promo du BL :'
                    + IntToStr(CommandeInfos.CommandeId));
                end;

              end;
          else // Autres
            Raise Exception.Create('Type de ligne inconnu : ' + TypeLigne + ' - ' +
              IntToStr(CommandeInfos.CommandeId));
          end; // case
        end; // with
      end; // for
      IbT_Modif.Commit;
    end
    else    //la commande existe déjà
    begin
      Raise Exception.Create('***  Erreur dans le fichier de commande: '+ExtractFileName(XmlFile)+'  ***'+#13#10+
                    '    N° Commande = '+CommandeInfos.CommandeNum+#13#10+
                    '    Id Commande = '+inttostr(CommandeInfos.CommandeId)+#13#10+
                    '    Erreur = La commande existe déjà !'+#13#10);
    end;
  except on E: Exception do
    begin
      IbT_Modif.Rollback;
      //      LogAction(E.Message,0);
      raise Exception.Create('DoGenCdeToDb -> ' + E.Message);
    end;
  end;
end;

function GenCreateEnteteBL(Cde: TCDE): Boolean;
var
  i: integer;
  fTauxFP,
    fTvaFP,
    fHTFP: single;
begin
  with Dm_Common, Cde do
  try
    // Récupation du Taux de TVA des Frais de port
    if (FraisDePort <> 0) then
    begin
      fTauxFP := GetFPTauxTVA(MySiteParams.iCodeSite);
      fTvaFP := (FraisDePort - FraisDePort * 100 / (100 + fTauxFP));
      fHTFP := FraisDePort - fTvaFP;
      // Ajout des frais de port à totaux
      i := Low(TVAS);
      while (i <= High(TVAS)) and (i <> -1) do
      begin
        if CompareValue(fTauxFP, TVAS[i].TauxTva, 0.01) = EqualsValue then
        begin
          TVAS[i].TotalHT := TVAS[i].TotalHT + fHTFP;
          TVAS[i].MtTVA := TVAS[i].MtTVA + fTvaFP;
          i := -1;
        end
        else
          inc(i);
      end; // while
    end; // if

    with Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('EXECUTE PROCEDURE TF_WEBG_CREER_BL(:ID_CLIENT, :ID_COMMANDE, :NUM_COMMANDE,');
      SQL.Add(':MT_TTC1, :MT_HT1, :MT_TAUX_HT1, :MT_TTC2, :MT_HT2, :MT_TAUX_HT2, :MT_TTC3, :MT_HT3,');
      SQL.Add(':MT_TAUX_HT3, :MT_TTC4, :MT_HT4, :MT_TAUX_HT4, :MT_TTC5, :MT_HT5, :MT_TAUX_HT5, :REMISE,');
      SQL.Add(':COMENT, :HTWORK, :CODE_SITE_WEB, :DATE_CREATION, :DATE_PAIEMENT, :MONTANT_FRAIS_PORT,');
      SQL.Add(':DETAXE, :ID_PAIEMENT_TYPE, :NOM_CLIENT_LIVR, :PRENOM_CLIENT_LIVR)');
      ParamCheck := True;

      ParamByName('ID_CLIENT').AsInteger := Client.Codeclient;
      ParamByName('ID_COMMANDE').AsInteger := CommandeInfos.CommandeId;
      ParamByName('NUM_COMMANDE').AsString := CommandeInfos.CommandeNum;

      for i := 1 to 5 do // init à 0 des 5 champs TVA
      begin
        ParamByName('MT_TTC' + IntToStr(i)).AsFloat := 0;
        ParamByName('MT_HT' + IntToStr(i)).AsFloat := 0;
        ParamByName('MT_TAUX_HT' + IntToStr(i)).AsFloat := 0;
      end;

      for i := 0 to High(TVAS) do
      begin
        if i < 5 then
        begin
          ParamByName('MT_TTC' + IntToStr(i + 1)).AsFloat := TVAS[i].TotalHT +
            TVAS[i].MtTVA;
          ParamByName('MT_HT' + IntToStr(i + 1)).AsFloat := TVAS[i].TotalHT;
          ParamByName('MT_TAUX_HT' + IntToStr(i + 1)).AsFloat :=
            TVAS[i].TauxTva;
        end;
      end;

      ParamByName('REMISE').AsFloat := 0;

      ParamByName('COMENT').AsString := CommandeInfos.CommandeNum;

      if Colis.Transporteur <> '' then
        ParamByName('COMENT').AsString := ParamByName('COMENT').AsString +
          #13#10'Transporteur : ' + Colis.Transporteur;
      if Colis.MagasinRetrait <> '' then
        ParamByName('COMENT').AsString := ParamByName('COMENT').AsString +
          #13#10'Magasin retrait : ' + Colis.MagasinRetrait;

      if InfosSupp <> '' then
        ParamByName('COMENT').AsString := ParamByName('COMENT').AsString +
          #13#10 + InfosSupp;

      //   case CommandeInfos.iExport of
      //     0: begin
      ParamByName('HTWORK').AsInteger := CommandeInfos.iExport;
      ParamByName('DETAXE').AsInteger := CommandeInfos.iExport;

      //   end;
     //    1: begin
     //      Que_Commande.ParamByName('HTWORK').AsInteger := 0;
     //      Que_Commande.ParamByName('DETAXE').AsInteger := 0;
    //     end;
    //   end;

      ParamByName('CODE_SITE_WEB').AsInteger := MySiteParams.iCodeSite;
      ParamByName('DATE_CREATION').AsDateTime := CommandeInfos.CommandeDate;
      ParamByName('DATE_PAIEMENT').AsDateTime := CommandeInfos.DateReglement;
      ParamByName('MONTANT_FRAIS_PORT').AsFloat := FraisDePort;
      ParamByName('ID_PAIEMENT_TYPE').AsString := CommandeInfos.ModeReglement;
      //iPaiement;
      ParamByName('NOM_CLIENT_LIVR').AsString := Client.AdresseLivr.sAdr_Nom;
      ParamByName('PRENOM_CLIENT_LIVR').AsString :=
        Client.AdresseLivr.sAdr_Prenom;

      ExecSQL;
    end; // with que_commande
  except on E: Exception do
      raise Exception.Create('GenCreateEnteteBL -> ' + E.Message);
  end;
end;

function GenCreateLineBL(ID_COMMANDE: Integer; ArtInfos: stArticleInfos;
  LigneCDE: TLigneCDE): boolean;
begin
  with Dm_Common, Que_Tmp do
  try
    Result := True;
    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE TF_WEBG_CREER_BLLINE( :ID_COMMANDE, :ID_PRODUIT, :ID_TAILLE,');
    SQL.Add(':ID_COULEUR, :ID_PACK, :NUM_LOT, :ID_CODE_PROMO, :QTE, :PX_BRUT, :PX_NET,');
    SQL.Add(':PX_NET_NET, :POINTURE, :LONGUEUR, :MONTAGE_FIXATIONS, :INFO_SUP, :TYPE_VTE);');
    ParamCheck := True;

    ParamByName('ID_COMMANDE').AsInteger := ID_COMMANDE;
    ParamByName('ID_PRODUIT').AsInteger := ArtInfos.iArtId;
    ParamByName('ID_TAILLE').AsInteger := ArtInfos.iTgfId;
    ParamByName('ID_COULEUR').AsInteger := ArtInfos.iCouId;
    ParamByName('ID_PACK').AsInteger := LigneCDE.LotId;
    ParamByName('NUM_LOT').AsInteger := LigneCDE.LotNum;
    ParamByName('ID_CODE_PROMO').AsInteger := 0;
    ParamByName('QTE').AsInteger := Trunc(LigneCDE.Qte);
    ParamByName('PX_BRUT').AsFloat := LigneCDE.PUBrutTTC; // ArtInfos.fPxBrut;
    //    IF Trunc(LigneCDE.Qte) <> 0 THEN
    ParamByName('PX_NET').AsFloat := LigneCDE.PXTTC; // / Trunc(LigneCDE.Qte)
    //    ELSE
    //      ParamByName('PX_NET').AsFloat        := LigneCDE.PUTTC;

    ParamByName('PX_NET_NET').AsFloat := LigneCDE.PUTTC;

    ParamByName('POINTURE').AsString := '';
    ParamByName('LONGUEUR').AsString := '';
    ParamByName('MONTAGE_FIXATIONS').AsInteger := 1;
    ParamByName('POINTURE').AsString := '';
    ParamByName('INFO_SUP').AsString := '';
    ParamByName('TYPE_VTE').AsInteger := 1;
    ExecSQL;
  except on E: Exception do
    begin
      Result := False;
      LogAction('Ligne Erreur : ' + E.Message, 0);
      raise Exception.Create('GenCreateLineBL -> ' + E.Message);
    end;
  end;
end;

function GenCreateClient(Client: TClientCde): Boolean;
var
  sPays: string;
begin
  Result := False;
  with Dm_Common do
  try
    with Que_Client, Client do
    begin
      Close;
      ParamCheck := True;
      ParamByName('ID_CLIENT').AsInteger := Codeclient;
      // adresse de facturation
      with AdresseFact do
      begin
        sPays := UpperCase(StrEnleveAccents(sAdr_Pays));
        if Pos('FRANCE', sPays) > 0 then
        begin
          sPays := 'FRANCE';
        end;

        ParamByName('NOM_CLIENT').AsString := sAdr_Nom;
        ParamByName('PRENOM_CLIENT').AsString := sAdr_Prenom;
        ParamByName('EMAIL_CLIENT').AsString := Email;
        ParamByName('ADRESSE_FACTURATION').AsString := sAdr_Adr1 + RC +
          sAdr_Adr2;
        ParamByName('CP_CLIENT').AsString := sAdr_CP;
        ParamByName('VILLE_CLIENT').AsString := sAdr_Ville;
        ParamByName('ID_PAYS').AsInteger := GetOrCreatePayID(sPays);
        ParamByName('TEL_CLIENT').AsString := sAdr_Tel;
        ParamByName('GSM_CLIENT').AsString := sAdr_Gsm;
        ParamByName('FAX_CLIENT').AsString := sAdr_Fax;
        ParamByName('SOCIETE').AsString := sAdr_Ste;
      end;

      // Adresse de livraison
      with AdresseLivr do
      begin
        sPays := UpperCase(StrEnleveAccents(sAdr_Pays));
        if Pos('FRANCE', sPays) > 0 then
        begin
          sPays := 'FRANCE';
        end;

        ParamByName('NOM_CLIENT_LIVRAISON').AsString := sAdr_Nom;
        ParamByName('PRENOM_CLIENT_LIVRAISON').AsString := sAdr_Prenom;
        ParamByName('EMAIL_CLIENT_LIVRAISON').AsString := Email;
        ParamByName('ADRESSE_LIVRAISON').AsString := sAdr_Adr1 + RC + sAdr_Adr2;
        ParamByName('CP_CLIENT_LIVRAISON').AsString := sAdr_CP;
        ParamByName('VILLE_CLIENT_LIVRAISON').AsString := sAdr_Ville;
        ParamByName('ID_PAYS_LIVRAISON').AsInteger := GetOrCreatePayID(sPays);
        ParamByName('TEL_CLIENT_LIVRAISON').AsString := sAdr_Tel;
      end;

      ParamByName('NUM_SIRET').AsString := '';
      ParamByName('NUM_TVA').AsString := '';
      ParamByName('CLT_MDP').AsString := '';
      
      ExecSQL;
      Result := True;
    end; // with que_client
  except on E: Exception do
      raise Exception.Create('GenCreateClient -> ' + E.Message);
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

end.


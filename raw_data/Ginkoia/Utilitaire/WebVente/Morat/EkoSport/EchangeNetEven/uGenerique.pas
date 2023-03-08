unit uGenerique;

interface

uses Controls, DateUtils, uCommon_DM, IniFiles, SysUtils, Forms, Types, uCreateCsv,
     Db, uCommon, Classes, XMLDoc, XMLIntf, StrUtils, uGeneriqueType,Math, Windows, Variants,uCommon_Type,
     IBODataset;


function DoGenGet (dHeureDebut,dHeureFin : TTime) : Boolean;
function DoGenSend (dHeureDebut,dHeureFin : TTime) : Boolean;


// Retourne le mode de traitement à faire MODE_XXXX
function IsTimerDone(dHeureDebut,dHeureFin : TTime) : TMode;
// function de génération des fichiers articles
function GenerateCsvArtFiles : Boolean;
// function de génération des fichiers de stocks
function GenerateCsvStkFiles : Boolean;
// function de traitement des commandes
function DoGenCde : Boolean;

// function pour récupérer le Taux TVA des frais de port
function GetFPTauxTVA(CODE_SITE_WEB : Integer) : Currency;

// Converti un fichier Xml en une Structure commande
function DoXmlGenToRecord(sXmlfile : String) : TCde;

// Fonction de convertion des données xml diverses
function XmlAdrToAdr(XmlNode : IXmlNode) : stUneAdresse;
function XmlStrToFloat(Value : OleVariant) : Extended;
function XmlStrToDate(Value : OleVariant) : TDateTime;
function XmlStrToInt(Value : OleVariant) : Integer;
function XmlStrToStr(Value : OleVariant) : String;

// Transforme la structure en commande dans la base de données
function DoGenCdeToDb(Cde : TCde) : Boolean;

// permet de créer les fichiers csv depuis un dataset
function DoCsv(DataSet : TDataSet;sFileName : String) : Boolean;

function GenFTPConnection (FTPCfg : TFTPData) : Boolean;
function GenFTPDownloadFile(FTPCfg : TFTPData) : Boolean;
function GenFTPUploadFile(FTPCfg : TFTPData) : Boolean;
procedure GenFTPClose;

function GenCreateClient(Client : TClientCde) : Boolean;
function GenCreateEnteteBL(Cde : TCDE) : Boolean;
function GenCreateLineBL(ID_COMMANDE : Integer;ArtInfos : stArticleInfos;LigneCDE : TLigneCDE) : boolean;

//Identifie le magasin correspondant à la base de donnée sur laquel on est connecté
function IdentLocalMagid : Integer;

//Contrôle si on est bien connecté sur la base web
function CtrlIdentBaseWeb : Boolean;

implementation


function CtrlIdentBaseWeb : Boolean;
//Contrôle si on est bien connecté sur la base web
Var
  iBaseWeb    : Integer;    //Id base web
  iBaseLocal  : Integer;    //Id base local
  QryTmp      : TIBOQuery;  //Query temporaire
begin
  //Recherche de la base web
  iBaseWeb  :=  Dm_Common.GetParamInteger(203);

  //Recherche de la base local
  iBaseLocal  := 0;
  try
    QryTmp  := TIBOQuery.Create(nil);
    With QryTmp do
      Begin
        Close;
        SQL.Clear;
        SQL.Add('Select par_string from genparambase where par_nom = ''IDGENERATEUR''');
        Open;
        first;
        if not eof then
          iBaseLocal  := FieldByName('PAR_STRING').AsInteger;
      End;
  finally
    QryTmp.Free;
  end;

  //Contrôle de discordance
  Result := (iBaseWeb=iBaseLocal);
end;

function IdentLocalMagid : Integer;
//Identifie le magasin correspondant à la base de donnée sur laquel on est connecté
Var
  QryTmp      : TIBOQuery;  //Query temporaire
begin
  //Recherche du magasin correspond à la BdD
  Result := 0;
  Try
    QryTmp  := TIBOQuery.Create(nil);
    With QryTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Text         := 'select bas_magid '+
                          'from GENBASES '+
                          'join genparambase on (par_nom=''IDGENERATEUR'') and (par_string=bas_ident)';
      Open;
      First;
      if not Eof then Result := FieldByName('bas_magid').AsInteger;
      Close;
    end;
  Finally
    QryTmp.Free;
  End;
End;

function DoGenGet (dHeureDebut,dHeureFin : TTime) : Boolean;
var
  dHTDebut, dHTFin, dNow : TDateTime;
begin
  Result := True;
  try
    dNow := Now;

   // Calcul pour la date de traitement
    dHTDebut := DateOf(dNow) + dHeureDebut;
    dHTFin   := DateOf(dNow) + dHeureFin;
    // Si l'heure de debut est plus grande que l'heure de fin
    // c'est que l'heure de fin est le lendemain
    if CompareDateTime(dHTDebut,dHTFin) in [EqualsValue,GreaterThanValue]  then
      dHTFin   := dHTFin + 1;

    // Dans le cas de la commande
    if (dNow >= dHTDebut) and (dNow < dHTFin) and (CtrlIdentBaseWeb) then
    begin
      // Traitement des commandes
       Result := DoGenCde;
    end;
  Except on E:Exception do
    begin
      Raise Exception.Create('DoGenGet -> ' + E.Message);
    end;
  end;
end;

function DoGenSend (dHeureDebut,dHeureFin : TTime) : Boolean;
var
  Mode : TMode;
  bDoArt, bDoStk : Boolean;
  FTPCsv ,
  FTPCDE     : TFTPData;

begin
  Result := False;
  try
    // Vérification timer
    Mode := IsTimerDone(dHeureDebut,dHeureFin);

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
        FTPCsv        := MySiteParams.FTPGenCSV;
        FileFilter   := '*.txt';
        SourcePath   := GGENPATHCSV;
        SavePath     := '';
        bDeleteFile  := False;
        bArchiveFile := True;
      end;
      // envoi des données vers le FTP
      LogAction('Transfert des fichiers CSV vers le FTP',3);
      if GenFTPConnection(FTPCsv) then
      try
        GenFTPUploadFile(FTPCsv);
      finally
        GenFTPClose;
      end;
    end; // if or

    // Envoi des factures
    With Dm_Common,FTPCDE  do
    begin
      FTPCDE       := MySiteParams.FTPGenFacture;
      FileFilter   := '*.' + MySiteParams.sFTPSendExtention;
      bDeleteFile  := False;
      bArchiveFile := True;
      SourcePath   := MySiteParams.sLocalFolderSend; // TODO: Quel est le chemin pour récupérer les factures ?
      SavePath     := '';
    end;
    // Envoi des données vers le FTP
    LogAction('Transfert des factures vers le FTP',3);
    if GenFTPConnection(FTPCDE) then
    Try
      GenFTPUploadFile(FTPCDE);
    finally
      GenFTPClose;
    end;

    Result := True;
  Except on E:Exception do
    begin
      Raise Exception.Create('DoGenSend -> ' + E.Message);
    end;
  end;
end;

function IsTimerDone(dHeureDebut,dHeureFin : TTime) : TMode;

  type TPlageHoraire = record
    HPlgDebut,HPlgFin : TDateTime;
  end;

var
  TabArtPlage   : array of TPLageHoraire;
  TabStkPlage   : Array of TPLageHoraire;
  i             : integer;
  bFound        : Boolean;
  iPlage        : Integer;
  bDoArt        : Boolean;
  bDoStk        : Boolean;

  dHeureArticle : TTime;
  fDelaiArticle : Double;
  dHeureStock   : TTime;
  fDelaiStock   : Double;
  dLastDateArt  : TDateTime;
  dLastDateStk  : TDateTime;
  iActifStock   : Integer;        //0: Inactif, 1: On envoie les fichiers stock
  iActifArt     : Integer;        //0: Inactif, 1: On envoie les fichiers articles

  dHTDebut      ,
  dHTFin        ,
  dNow          : TDateTime;
  iPlageLast    : integer;

begin
  Result := [];

  // On utilisera dNow pour garder tout au long du traitement la même date/heure
  dNow := Now;
  // Calcul pour la date de traitement
  dHTDebut := DateOf(dNow) + dHeureDebut;
  dHTFin   := DateOf(dNow) + dHeureFin;
  // Si l'heure de debut est plus grande que l'heure de fin
  // c'est que l'heure de fin est le lendemain
  if CompareDateTime(dHTDebut,dHTFin) in [EqualsValue,GreaterThanValue]  then
    dHTFin   := dHTFin + 1;

  // Dans le cas de la commande
//  if (dNow >= dHTDebut) and (dNow < dHTFin) then
//    Result := Result + [mdCde];

  // Récupération des paramètres
  With Dm_Common do
  begin
    dHeureArticle := GetParamFloat(400);
    fDelaiArticle := GetParamFloat(401);
    dHeureStock   := GetParamFloat(402);
    fDelaiStock   := GetParamFloat(403);
    iActifArt     := GetParamInteger(400);
    iActifStock   := GetParamInteger(402);
  end;

  if (fDelaiArticle = 0) or (fDelaiStock = 0)  then
    raise Exception.Create('Configuration manquante : Délai article ou stock non configuré');

  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    // Récupération de la dernière heure de traitement
    dLastDateArt := ReadDateTime('GENERIQUE','DATETIMEART',DateOf(dNow) + dHeureArticle);
    dLastDateStk := ReadDateTime('GENERIQUE','DATETIMESTK',DateOf(dNow) + dHeureStock);
  finally
    free;
  end;

  // Génération des plages horaires
  // calcul le nombre de plages horaires pour la période dhtdebut à dhtfin
  // Ex : DHTDebut = 10/10/2009 06:00 et DHTFin = 10/10/2009 22:00, FDelaiArticle = 2h
  //      (HoursBeetween Div FDelaiArticle) + 1 = (16 Div 2) + 1 = 9 plages horaires (6h-8h, 8h-10, ... 18h-20h, 20h-22h)
  // article
  if (iActifArt = 1) and (CtrlIdentBaseWeb) then
  Begin
    i := (HoursBetween((DateOf(dHTDebut) + dHeureArticle),dHTFin) Div Round(fDelaiArticle)) + 1;
    SetLength(TabArtPlage,i);
    for i := low(TabArtPlage) to high(TabArtPlage) do
      With TabArtPlage[i] do
      begin
        HPlgDebut := inchour(DateOf(dHTDebut) + dHeureArticle,Round(fDelaiArticle) * i);
        HPlgFin   := inchour(DateOf(dHTDebut) + dHeureArticle,Round(fDelaiArticle) * (i + 1));
      end;
  end;

  // stock
  if (iActifStock = 1) then
  Begin
    i := (HoursBetween((DateOf(dHTDebut) + dHeureArticle),dHTFin) Div Round(fDelaiStock)) + 1;
    SetLength(TabStkPlage,i);
    for i := low(TabStkPlage) to High(TabStkPlage) do
      With TabStkPlage[i] do
      begin
        HPlgDebut := Inchour(DateOf(dHTDebut) + dHeureStock,Round(fDelaiStock) * i);
        HPlgFin   := Inchour(DateOf(dHTDebut) + dHeureStock,Round(fDelaiStock) * (i + 1));
      end;
  end;

  //Gestion des fichiers articles
  bDoArt := False;
  if (iActifArt = 1) and (CtrlIdentBaseWeb) then
  Begin
    // dans quelle plage est on pour l'article?
    bFound := False;
    iPlageLast := -1;
    for i := low(TabArtPlage) to high(TabArtPlage) do
      With TabArtPlage[i] do
      begin
        if (dNow >= HPlgDebut) and (dNow < HPlgFin) then
        begin
          bFound := True;
          iPlage := i;
        end;
        if (CompareValue(dLastDateArt, HPlgDebut) in [GreaterThanValue,EqualsValue]) and
           (CompareValue(dLastDateArt, HPlgFin) = LessThanValue) then
          iPlageLast := i;

      end;

    if bFound then
    begin
      // Si l'heure du dernier traitement <= à la plage trouvée c'est qu'il est nécessaire de traiter l'article
      if CompareValue(dLastDateArt, TabArtPlage[iPlage].HPlgDebut) = LessThanValue then
        // On vérifie qu'on est pas Hors horaire de traitement
        if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle))  then
        begin
          bDoArt := True;
          // Ajout de 5mn car il arrive parfois que la conversion depuis le ini bug et enlève des secondes
          dLastDateArt := IncMinute(TabArtPlage[iPlage].HPlgDebut,5);
        end;
    end
    else begin
      // Si on est la c'est qu'on est Hors plage donc qu'on a un traitement à faire
      // alors on va vérifier si on a pas dépassé aussi l'heure de fin de traitement
      if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle)) then
      begin
        bDoArt := True;
        dLastDateArt := TabArtPlage[High(TabArtPlage)].HPlgFin;
      end;
    end;
  end;

  //Gestion des fichiers stock
  bDoStk := False;
  if (iActifStock = 1) then
  Begin
    // dans quelle plage est on pour le stock?
    iPlageLast := -1;
    bFound := False;
    for i := low(TabStkPlage) to high(TabStkPlage) do
      With TabStkPlage[i] do
      begin
        if (dNow >= HPlgDebut) and (dNow < HPlgFin) then
        begin
          bFound := True;
          iPlage := i;
        end;

        if (CompareValue(dLastDateStk, HPlgDebut) in [GreaterThanValue,EqualsValue]) and
           (CompareValue(dLastDateStk,HPlgFin) = LessThanValue) then
        begin
          iPlageLast := i;
        end;
      end;

    if bFound then
    begin
      // Si l'heure du dernier traitement <= à la plage trouvée c'est qu'il est nécessaire de traiter l'article
      if CompareValue(dLastDateStk,TabStkPlage[iPlage].HPlgDebut) = LessThanValue then
        // On vérifie qu'on est pas Hors horaire de traitement et qu'on est vien supérieur à l'heure de début de traitement
        if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle)) then
        begin
          bDoStk := True;
          // Ajout de 5mn car il arrive parfois que la conversion depuis le ini bug et enlève des secondes
          dLastDateStk := IncMinute(TabStkPlage[iPlage].HPlgDebut,5);
        end;
    end
    else begin
      // Si on est la c'est qu'on est Hors plage donc qu'on a un traitement à faire
      // alors on va vérifier si on a pas dépassé aussi l'heure de fin de traitement
      if (dNow >= dHTDebut) and (dNow < dHTFin) and (dNow >= (DateOf(dHTDebut) + dHeureArticle)) then
      begin
        bDoStk := True;
        dLastDateStk := TabStkPlage[High(TabStkPlage)].HPlgFin;
      end;
    end;
  end;
  
  if bDoArt or bDoStk then
  begin
    With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      // sauvegarde des horaires
      if bDoArt then
      begin
         WriteDateTime('GENERIQUE','DATETIMEART',dLastDateArt);
         Result := Result + [mdArticle];
      end;

      if bDoStk then
      begin
        WriteDateTime('GENERIQUE','DATETIMESTK',dLastDateStk);
        Result := Result + [mdStock];
      end;
    finally
      free;
    end; // with try
  end; // if
end;

function GenerateCsvArtFiles : Boolean;
begin
  Result := False;
  With Dm_Common do
  Try
    // génération du fichier genre
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPGENRE');
        Open;
      end;

      DoCsv(Que_Tmp,GGENPATHCSV + 'GENRE.TXT');
    Except on E:Exception do
      raise Exception.Create('GENRE.TXT -> ' + E.Message);
    End;

    // Génération du fichier nomenclature
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from TF_WEBG_EXPNOMENCLATURE(:PSEC_TYPE)');
        ParamCheck := True;
        ParamByName('PSEC_TYPE').AsInteger := 2;
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'NOMENCLATURE.TXT');
    Except on E:Exception do
      raise Exception.Create('NOMENCLATURE.TXT -> ' + E.Message);
    End;

    // génération du fichier des articles web
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * From TF_WEBG_EXPARTWEB(:ASSID,:MAGID)');
        ParamCheck := True;
        ParamByName('ASSID').AsInteger := MySiteParams.iAssID;
        ParamByName('MAGID').AsInteger := MySiteParams.iMagID;
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'ARTWEB.TXT');
    Except on E:Exception do
      raise Exception.Create('ARTWEB.TXT -> ' + E.Message);
    End;

    // génération du fichier des nomenclatures secondaires
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPARTNOMENK');
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'ARTNOMENK.TXT');
    Except on E:Exception do
      raise Exception.Create('ARTNOMENK.TXT -> ' + E.Message);
    End;

    // Génération du fichier des lots
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPLOTWEB(:PASSID)');
        ParamCheck := True;
        ParamByName('PASSID').AsInteger := MySiteParams.iAssID;
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'LOTWEB.TXT');
    Except on E:Exception do
      raise Exception.Create('LOTWEB.TXT -> ' + E.Message);
    End;

    // Génération de la nomenclature secondaire des lots
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPLOTNOMENK');
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'LOTNOMENK.TXT');
    Except on E:Exception do
      raise Exception.Create('LOTNOMENK.TXT -> ' + E.Message);
    End;

    // génération du fichier des codes Promo
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from TF_WEBG_EXPCODEPROMO');
        Open;
      end;
      DoCsv(Que_tmp,GGENPATHCSV + 'CODEPROMO.TXT');
    Except on E:Exception do
      raise Exception.Create('CODEPROMO.TXT -> ' + E.Message);
    End;

    Result := True;
  Except on E:Exception do
    begin
      LogAction('Erreur lors de la génération des csv : ' + E.Message,1);
    end;
  end;
end;

function GenerateCsvStkFiles : Boolean;
Var
  iLocalMagId     : Integer;    //Id du magasin correspond à la base en cours d'utilisation
  iExtractMagId   : Integer;    //Id du magasin à extraire
  iCumulMagId     : Integer;    //Id du magasin à cumuler
  iNbLigneExtract : Integer;    //Nombre de ligne de la liste d'extraction
begin
  Result := False;
  With Dm_Common do
  try

    //Recherche du magasin correspond à la BdD
    iLocalMagId := IdentLocalMagid;
    if iLocalMagId = 0 then iLocalMagId := MySiteParams.iMagID;

    // Lecture de la liste d'extraction
    iExtractMagId := 0;
    iCumulMagId   := 0;
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Text        := 'Select prm_magid, prm_pos '+
                           'from genparam '+
                           'join k on (k_id=prm_id) and (k_enabled=1) '+
                           'where (prm_type=9) and (prm_code=404)';
        Open;
        First;
        iNbLigneExtract := RecordCount;
        //Si aucune liste d'extraction n'est défini on utilise le magasin général
        if iNbLigneExtract<=0 then
          iExtractMagId := MySiteParams.iMagID
        else
          Begin
            //Recherche du magasin dans la liste d'extraction
            If Locate('prm_magid',iLocalMagId,[]) Then
              Begin
                iExtractMagId   := FieldByName('prm_magid').AsInteger;
                iCumulMagId     := FieldByName('prm_pos').AsInteger;
              End
          end;
        Close;
      end;
    Except on E:Exception do
      raise Exception.Create('GenerateCsvStkFiles -> ' + E.Message);
    End;
    //Si une liste d'extraction existe mais que le magasin n'en fait pas partie on sort;
    if iExtractMagId = 0 then exit;
    //Si aucune liste d'extraction n'est défini et que l'on est pas connecté à la base Web par défaut on sort
    if (iNbLigneExtract<=0) and (Not CtrlIdentBaseWeb) then exit;
    

    // Génération du fichier des stocks
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select CODE_ARTICLE,ID_SEUIL,LIB_SEUIL, STOCK_ARTICLE as QTE_STOCK, ' + QuotedStr(IntToStr(iExtractMagId)) + ' as MAG_ID from TF_WEBG_EXPSTOCK(:LOT,:MAJSTK,:PMAGID,:CUMULID,:PASSID)');
        ParamCheck := True;
        ParamByName('LOT').AsInteger    := 0;
        ParamByName('PMAGID').AsInteger := iExtractMagId;
        ParamByName('MAJSTK').AsInteger := 1; // pas de mise à jour des seuils avec 0
        ParamByName('PASSID').AsInteger := MySiteParams.iAssID;
        ParamByName('CUMULID').AsInteger:= iCumulMagId;
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'STOCK_'+IntToStr(iExtractMagId)+'.TXT');
    Except on E:Exception do
      raise Exception.Create('STOCK_'+IntToStr(iExtractMagId)+'.TXT -> ' + E.Message);
    End;

    // génération du fichier StockLot
    Try
      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select CODE_LOT, ID_SEUIL, LIB_SEUIL, CODE_LIGNE, CODE_ARTICLE as CB_ARTICLE, STOCK_ARTICLE');
        SQL.Add(' from TF_WEBG_EXPSTOCK(:LOT,:MAJSTK,:PMAGID,:CUMULID,:PASSID)');
        ParamByName('LOT').AsInteger    := 1;
        ParamByName('MAJSTK').AsInteger := 0; // pas de mise à jour des seuils avec 0
        ParamByName('PMAGID').AsInteger := iExtractMagId;
        ParamByName('PASSID').AsInteger := MySiteParams.iAssID;
        ParamByName('CUMULID').AsInteger:= iCumulMagId;
        Open;
      end;
      DoCsv(Que_Tmp,GGENPATHCSV + 'STOCKLOT_'+IntToStr(iExtractMagId)+'.TXT');
    Except on E:Exception do
      raise Exception.Create('STOCKLOT_'+IntToStr(iExtractMagId)+'.TXT -> ' + E.Message);
    End;

    Result := True;
  Except on E:Exception do
    begin
      LogAction('Erreur lors de la génération des csv : ' + E.Message,1);
    end;
  end;
end;


function DoCsv(DataSet : TDataSet;sFileName : String) : Boolean;
var
  Header : TExportHeaderOL;
  i : integer;
begin
  Result := True;
  Header := TExportHeaderOL.Create;
  Header.bAlign := False; // Pas de gestion de la taille des champs
  Header.bWriteHeader := True; // Met en première ligne la liste des noms des champs
  Header.Separator := ';'; // séparateur de champs
  try
    if FileExists(sFileName) then
      DeleteFile(PChar(sFileName));

    // On ajoute la liste des champs que l'on va devoir traiter pour le CSV
    for i := 0 to Dataset.FieldCount - 1 do
      Header.Add(Dataset.Fields[i].FieldName);
    Try
      // On génère le CSV avec la source de données que l'on a
      Header.OldStr := ';';
      Header.NewStr := ',';
      Header.ConvertToCsv(DataSet,sFileName);
    Except on E:Exception do
      begin
        LogAction('Erreur lors de la génération du Csv : ' + ExtractFileName(sFileName),1);
        LogAction(E.Message,1);
        Result := False;
        Exit;
      end;
    End;
  finally
    Header.Free;
  end;
end;

function DoGenCde : Boolean;
var
  FTPCde : TFTPData;
  i : integer;
  Cde : TCde;
  sArchPath : String;
begin
  try
    // Récupération des commandes sur le FTP
    try
      With Dm_Common, FTPCde do
      begin
        FTPCde := MySiteParams.FTPGenGet;
        SavePath     := GGENPATHCDE;
        FileFilter   := '*.xml';
        SourcePath   := GGENTMPPATH;
        FileList     := TStringList.Create;
      end;

      sArchPath := GGENARCHCDE + FormatDateTime('YYYY\MM\DD\',Now);
      if not DirectoryExists(sArchPath) then
        ForceDirectories(sArchPath);

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
              if (RightStr(FTPCDE.FileList[i],4) = RightStr(FTPCDE.FileFilter,4)) then
                begin
                  Cde := DoXmlGenToRecord(GGENPATHCDE + FTPCDE.FileList[i]);
                  DoGenCdeToDb(Cde);

                  // Archivage du fichier
                  if not MoveFile(PChar(GGENPATHCDE+ FTPCDE.FileList[i]),PChar(sArchPath + FormatDateTime('YYYY-MM-DD-hhmmssnn_',Now) + ExtractFileName(FTPCDE.FileList[i]))) then
                    LogAction('DoGenCde Problème d''archivage de ' + FTPCDE.FileList[i],1);

                end;
          end;
        end;
      finally
        GenFTPClose;
      end;
    finally
      FTPCde.FileList.Free;
    end;
  Except on E:Exception do
    raise Exception.Create('DoCde -> ' + E.Message);
  end;
end;

function GenFTPConnection (FTPCfg : TFTPData) : Boolean;
var
  i : Integer;
  lst : TStringList;
begin
  Result := False;
  With Dm_Common, FTP do
  Try
    // On annule toute action du FTP et on coupe la connection s'il est encore connecté
    GenFTPClose;

    // configuration du FTP
    if Trim(FTPCfg.Host) = ''  then
      Exit;
    
    Host     := FTPCfg.Host;
    Username := FTPCfg.User;
    Password := FTPCfg.Psw;
    Port     := FTPCfg.Port;
    Passive  := True;
    Connect;

    if Connected then
    begin
      if Trim(FTPCfg.FTPDirectory) <> '' then
      begin
        // On va se positionner dans le répertoire de traitement du FTP
        lst := TStringList.Create;
        try
          lst.Text := StringReplace(FTPCfg.FTPDirectory,'/',#13#10,[rfReplaceAll]);
          for i := 0 to Lst.Count - 1 do
            if Trim(lst[i]) <> '' then
              ChangeDir(Trim(lst[i]));
        finally
          lst.Free;
        end;
      end;

      Result := True;
    end;
  Except on E:Exception do
    begin
      LogAction('Erreur de connection FTP -> ' + FTPCfg.Host + ' : ' + E.Message,0);
      raise Exception.Create('GenFTPConnection -> ' + E.Message);
    end;
  end;
end;

function GenFTPDownloadFile(FTPCfg : TFTPData) : Boolean;
var
  i : integer;
  lst : TStringList;
  iTry : Integer;
  bGet : Boolean;
  bDelete : Boolean;
begin
  Result := False;
  With Dm_Common, FTP do
  try
    FTP.List(FTPCfg.FileList,FTPCfg.FileFilter,False);

    FTPCfg.FileList.text := StringReplace(FTPCfg.FileList.text,';',#13#10,[rfReplaceAll]);
    for i := FTPCfg.FileList.Count -1 downto 0 do
      if Pos('=',FTPCfg.FileList[i]) > 0 then
        FTPCfg.FileList.Delete(i)
      else
         FTPCfg.FileList[i] := Trim(FTPCfg.FileList[i]);

    for i := 0 to FTPCfg.FileList.Count - 1 do
    begin
      bGet    := False;
      bDelete := False;
      iTry := 0;
      if (RightStr(FTPCfg.FileList[i],4) = RightStr(FTPCfg.FileFilter,4)) then
        while not bGet and not bDelete and (iTry < 3) do
        begin
          try
            Get(FTPCfg.FileList[i],FTPCfg.SavePath + FTPCfg.FileList[i],True);
            if FTPCfg.bDeleteFile then
              Delete(FTPCfg.FileList[i]);
            bGet := True;
            bDelete := True;
          Except on E:Exception do
            begin
              inc(iTry);
              if iTry >= 3 then
                raise Exception.Create('GenFTPDownloadFile -> Nombre d''essai atteint : ' + E.Message);
              Sleep(500);
            end;
          end;
        end; // while
    end;

    Result := True;
  Except on E:Exception do
    begin
      LogAction('Erreur de récupération des fichiers du FTP -> ' + FTPCfg.Host + ' : ' + E.Message,0);
      raise Exception.Create('GenFTPDownloadFile -> ' + E.Message);
    end;
  end;
end;

function GenFTPUploadFile(FTPCfg : TFTPData) : Boolean;
var
  Rec : TSearchRec;
  i : integer;
  sArchPath : String;
  lst : TStringList;
  iSize : Int64;
  bSend : Boolean;
  iTry  : Integer;
begin
  Result := False;
  lst := TStringList.Create;
  try
    With Dm_Common, FTP do
    try
      // récupération de la liste des fichiers d'un répertoire
      i := FindFirst(FTPCfg.SourcePath + FTPCfg.FileFilter,0,Rec);
      while i = 0 do
      begin
        if (Rec.Name <> '.') and (Rec.Name <> '..') then
        begin
          Try
            iSize := Size(Rec.Name);
            if iSize > 0 then
              Delete(Rec.Name);
          Except
          End;
          bSend := False;
          iTry := 0;
          while not bSend and (iTry < 3) do
          begin
            try
              Put(FTPCfg.SourcePath + Rec.Name,Rec.Name,True);
              bSend := True;
            Except on E:Exception do
              begin
                inc(iTry);
                if iTry >= 3 then
                  raise Exception.Create('GenFTPUploadFile -> Nombre d''essai atteint : ' + E.Message);
                Sleep(500);
              end;
            end; // try
          end;
        end;
        // On ajoute les fichiers transferer à la liste
       lst.Add(FTPCfg.SourcePath + Rec.Name);

        i := FindNext(Rec);
      end;
      SysUtils.FindClose(Rec);

      sArchPath := FTPCfg.SourcePath + '\Send\';
      if not DirectoryExists(sArchPath) then
        ForceDirectories(sArchPath);
      for i := 0 to lst.Count - 1 do
        Begin
          if FileExists(sArchPath+ ExtractFileName(lst[i])) then
            DeleteFile(PChar(sArchPath+ ExtractFileName(lst[i])));
          if not MoveFile(PChar(lst[i]),PChar(sArchPath+ ExtractFileName(lst[i]))) then
            LogAction('GenFTPUploadFile Problème d''archivage de ' + lst[i],1);
        end;

      Result := True;

    Except on E:Exception do
      begin
        LogAction('Erreur de transfert des fichiers du FTP -> ' + FTPCfg.Host + ' : ' + E.Message,0);
        raise Exception.Create('GenFTPUploadFile -> ' + E.Message);
      end;
    end;
  finally
    lst.Free;
  end;
end;

procedure GenFTPClose;
begin
  With Dm_Common, FTP do
  begin
    if Connected then
    begin
      Abort;
      Disconnect;
    end;
  end;
end;

function DoXmlGenToRecord(sXmlfile : String) : TCde;
var
  CdeNode     ,
  ClientNode  ,
  AdrFactNode ,
  AdrLivrNode ,
  ColisNode   ,
  LignesNode  ,
  LigneNode   ,
  TVASNode    ,
  TVANode     : IXmlNode;
  i : integer;
begin
  With Dm_Common do
    Try
      MyDoc.LoadFromFile(sXmlfile);

      CdeNode := MyDoc.DocumentElement;
      With CdeNode, Result do
      begin
        XmlFile := sXmlfile;
        With CommandeInfos do
        begin
          CommandeNum   := XmlStrToStr(ChildValues['CommandeNum']);
          CommandeId    := XmlStrToInt(ChildValues['CommandeId']);
          CommandeDate  := XmlStrToDate(ChildValues['CommandeDate']);
          Statut        := XmlStrToStr(ChildValues['Statut']);
          ModeReglement := XmlStrToStr(ChildValues['ModeReglement']);
          DateReglement := XmlStrToDate(ChildValues['DateReglement']);
          iExport       := XmlStrToInt(ChildValues['Export']);
        end;

        ClientNode := ChildNodes['Client'];
        With Client, ClientNode do
        begin
          AdrFactNode    := ChildNodes['AddressFact'];
          AdrLivrNode    := ChildNodes['AddressLivr'];

          Codeclient  := XmlStrToInt(ChildValues['CodeClient']);
          Email       := XmlStrToStr(ChildValues['Email']);
          AdresseFact := XmlAdrToAdr(AdrFactNode);
          AdresseLivr := XmlAdrToAdr(AdrLivrNode);
        end;

        ColisNode := ChildNodes['Colis'];
        With Colis, ColisNode do
        begin
          Numero         := XmlStrToStr(ChildValues['Numero']);
          Transporteur   := XmlStrToStr(ChildValues['Transporteur']);
          MagasinRetrait := XmlStrToStr(ChildValues['MagasinRetrait']);
        end;

        LignesNode := ChildNodes['Lignes'];
        SetLength(Lignes,LignesNode.ChildNodes.Count);
        for i := 0 to LignesNode.ChildNodes.Count -1 do
        begin
          LigneNode := LignesNode.ChildNodes[i];
          With LigneNode, Lignes[i] do
          begin
            TypeLigne   := XmlStrToStr(ChildValues['TypeLigne']);
            Code        := XmlStrToStr(ChildValues['Code']);
            Designation := XmlStrToStr(ChildValues['Designation']);
            PUBrutHT    := XmlStrToFloat(ChildValues['PUBrutHT']);
            PUBrutTTC   := XmlStrToFloat(ChildValues['PUBrutTTC']);
            PUHT        := XmlStrToFloat(ChildValues['PUHT']);
            TxTVA       := XmlStrToFloat(ChildValues['TxTva']);
            Qte         := XmlStrToInt(ChildValues['Qte']);
            PXHT        := XmlStrToFloat(ChildValues['PXHT']);
            PXTTC       := XmlStrToFloat(ChildValues['PXTTC']);
            PUTTC       := XmlStrToFloat(ChildValues['PUTTC']);
          end;
        end;

        TVASNode := ChildNodes['TVAS'];
        SetLength(TVAS,TVASNode.ChildNodes.Count);
        for i := 0 to TVASNode.ChildNodes.Count - 1 do
        begin
          TVANode := TVASNode.ChildNodes[i];
          With TVANode, TVAS[i] do
          begin
            TotalHT := XmlStrToFloat(ChildValues['TotalHT']);
            TauxTva := XmlStrToFloat(ChildValues['TauxTva']);
            MtTVA   := XmlStrToFloat(ChildValues['MtTva']);
          end;
        end;

        SousTotalHT := XmlStrToFloat(ChildValues['SousTotalHT']);
        FraisDePort := XmlStrToFloat(ChildValues['FraisPort']);
        TotalHT     := XmlStrToFloat(ChildValues['TotalHT']);
        MontantTVA  := XmlStrToFloat(ChildValues['MontantTVA']);
        TotalTTC    := XmlStrToFloat(ChildValues['TotalTTC']);
        NetPayer    := XmlStrToFloat(ChildValues['Netpayer']);
      end;
    Except on E:Exception do
      raise Exception.Create('DoXmlGenToRecord -> ' + E.Message);
    End;
end;

function XmlAdrToAdr(XmlNode : IXmlNode) : stUneAdresse;
begin
  With XmlNode, Result do
  begin
    sAdr_Civ      := XmlStrToStr(ChildValues['Civ']);
    sAdr_Nom      := XmlStrToStr(ChildValues['Nom']);
    sAdr_Prenom   := XmlStrToStr(ChildValues['Prenom']);
    sAdr_Ste      := XmlStrToStr(ChildValues['Ste']);
    sAdr_Adr1     := XmlStrToStr(ChildValues['Adr1']);
    sAdr_Adr2     := XmlStrToStr(ChildValues['Adr2']);
    sAdr_Adr3     := XmlStrToStr(ChildValues['Adr3']);
    sAdr_CP       := XmlStrToStr(ChildValues['CP']);
    sAdr_Ville    := XmlStrToStr(ChildValues['Ville']);
    sAdr_Pays     := XmlStrToStr(ChildValues['Pays']);
    sAdr_PaysISO  := XmlStrToStr(ChildValues['PaysISO']);
    sAdr_Tel      := XmlStrToStr(ChildValues['Tel']);
    sAdr_Gsm      := XmlStrToStr(ChildValues['Gsm']);
    sAdr_Fax      := XmlStrToStr(ChildValues['Fax']);
  end;
end;

function XmlStrToFloat(Value : OleVariant) : Extended;
begin
  try
    Result := 0;
    if not VarIsNull(Value) then
      if Trim(Value) <> '' then
      begin
        if Pos('.',Value) > 0 then
          Result := StrToFloat(StringReplace(Trim(Value),'.',DecimalSeparator,[rfReplaceAll]))
        else begin
          if Pos(',',Value) > 0 then
            Result := StrToFloat(StringReplace(Trim(Value),',',DecimalSeparator,[rfReplaceAll]))
          else
            Result := StrToFloat(Trim(Value));
        end;
      end;
  Except on E:Exception do
    raise Exception.create('XmlStrTofloat -> ' + E.Message);
  end;
end;

function XmlStrToDate(Value : OleVariant) : TDateTime;
var
  d,m,y,h,mn,s : Word;
begin
  Result := 0;
  if not VarIsNull(Value) then
    if Trim(Value) <> '' then
    begin
      Try
        d  := StrToIntDef(Copy(Trim(Value),9,2),0);
        m  := StrToIntDef(Copy(Trim(Value),6,2),0);
        y  := StrToIntDef(Copy(Trim(Value),1,4),0);
        h  := StrToIntDef(Copy(Trim(Value),12,2),0);
        mn := StrToIntDef(Copy(Trim(Value),15,2),0);
        s  := StrToIntDef(Copy(Trim(Value),18,2),0);
        Result := EncodeDateTime(y,m,d,h,mn,s,0);

      Except on E:Exception do
        raise Exception.Create('XmlStrToDate -> ' + E.Message);
      End;
    end;
end;

function XmlStrToInt(Value : OleVariant) : Integer;
begin
   if not VarIsNull(Value) then
     Result := StrToIntDef(Trim(Value),0)
   else
     Result := 0;
end;

function XmlStrToStr(Value : OleVariant) : String;
begin
   if not VarIsNull(Value) then
     Result := Trim(Value)
   else
     Result := '';

end;

function DoGenCdeToDb(Cde : TCde) : Boolean;
var
 i, j : Integer;
 ArtInfos : stArticleInfos;
 lstLot : TStringList;
 LineTmp : TLigneCDE;
 bLineCreate : Boolean;
 iLotNum : integer;
begin
  With Dm_Common, Cde do
  Try
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
          With Lignes[i] do
          begin
            inc(iLotNum);
            LotId  := 0;
            LotNum := 0;

            case AnsiIndexStr(Trim(UpperCase(TypeLigne)),['LIGNE','LOT','CODEPROMO']) of
              0: begin // Ligne
                ArtInfos := GetArticleInfos(Code);
                // est ce que l'article est valide
                if not ArtInfos.isValide then
                  raise Exception.Create('La commande : ' + CDE.XmlFile + ' a un article incorrect : ' + Code);

                bLineCreate := GenCreateLineBL(CommandeInfos.CommandeId,ArtInfos,Lignes[i]);

                if not bLineCreate then
                begin
                  LogAction('Problème lors de la création d''une ligne du BL : ' + IntToStr(CommandeInfos.CommandeId),1);
                  Break;
                end;
              end;

              1: begin // Lot
                lstLot := TStringList.Create;
                try
                  lstLot.Text := StringReplace(Code,'*',#13#10,[rfReplaceAll]);
                  LineTmp := Lignes[i];
                  for j := 1 to lstLot.Count - 1 do
                  begin
                    LineTmp.LotId := StrToIntDef(Trim(lstLot[0]),0);
                    LineTmp.LotNum := iLotNum;
                    ArtInfos := GetArticleInfos(Trim(lstLot[j]));

                    // est ce que l'article est valide
                    if not ArtInfos.isValide then
                      raise Exception.Create('La commande : ' + CDE.XmlFile + ' a un lot incorrect : ' + IntToStr(LineTmp.LotId));

                    bLineCreate := GenCreateLineBL(CommandeInfos.CommandeId,ArtInfos,LineTmp);
                    if not bLineCreate then
                    begin
                      LogAction('Problème lors de la création d''un lot du BL :' + IntToStr(CommandeInfos.CommandeId),1);
                      Break;
                    end;
                  end;
                finally
                  lstLot.Free;
                end;
              end;

              2: begin // CodePromo

                With Lignes[i],ArtInfos do
                begin
                  iArtId := StrToInt(Trim(Code)); // c'est l'artid dans l'xml contrairement aux autres où c'est le CB
                  iTgfId := 0;
                  iCouId := 0;
                  fPxAchat := - abs(PXHT);
                  fPxBrut  := - abs(PUBrutHT);
                  fTVA     := 0;
                end;

                // aux cas où on met négatif les codepromo
                With Lignes[i] do
                begin
                  PUBrutHT  := - abs(PUBrutHT);
                  PUBrutTTC := - abs(PUBrutTTC);
                  PUHT      := - abs(PUHT);
                  PXHT      := - abs(PXHT);
                  PXTTC     := - abs(PXTTC);
                end;

                bLineCreate := GenCreateLineBL(CommandeInfos.CommandeId,ArtInfos,Lignes[i]);

                if not bLineCreate then
                begin
                  LogAction('Problème lors de la création d''un code promo du BL :' + IntToStr(CommandeInfos.CommandeId),1);
                  Break;
                end;

              end;
              else // Autres
                LogAction('Type de ligne inconnu : ' + TypeLigne + ' - ' + IntToStr(CommandeInfos.CommandeId),2);
            end; // case
          end; // with
        end; // for
      IbT_Modif.Commit;
    end;
  Except on E:Exception do
    begin
      IbT_Modif.Rollback;
//      LogAction(E.Message,0);
      raise Exception.Create('DoGenCdeToDb -> ' + E.Message);
    end;
  end;
end;

function GenCreateEnteteBL(Cde : TCDE) : Boolean;
var
  i : integer;
  fTauxFP ,
  fTvaFP  ,
  fHTFP   : single;
begin
  With Dm_Common, Cde do
  try
    // Récupation du Taux de TVA des Frais de port
    if (FraisDePort <> 0) then
    begin
      fTauxFP := GetFPTauxTVA(MySiteParams.iCodeSite);
      fTvaFP  := (FraisDePort - FraisDePort * 100 / (100 + fTauxFP));
      fHTFP   :=  FraisDePort - fTvaFP;
      // Ajout des frais de port à totaux
      i := Low(TVAS);
      while (i <= High(TVAS)) and (i <> -1) do
      begin
        if CompareValue(fTauxFP, TVAS[i].TauxTva,0.01) = EqualsValue then
        begin
          TVAS[i].TotalHT := TVAS[i].TotalHT + fHTFP;
          TVAS[i].MtTVA := TVAS[i].MtTVA + fTvaFP;
          i := -1;
        end else
          inc(i);
      end; // while
    end; // if

    With Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('EXECUTE PROCEDURE TF_WEBG_CREER_BL(:ID_CLIENT, :ID_COMMANDE, :NUM_COMMANDE,');
      SQL.Add(':MT_TTC1, :MT_HT1, :MT_TAUX_HT1, :MT_TTC2, :MT_HT2, :MT_TAUX_HT2, :MT_TTC3, :MT_HT3,');
      SQL.Add(':MT_TAUX_HT3, :MT_TTC4, :MT_HT4, :MT_TAUX_HT4, :MT_TTC5, :MT_HT5, :MT_TAUX_HT5, :REMISE,');
      SQL.Add(':COMENT, :HTWORK, :CODE_SITE_WEB, :DATE_CREATION, :DATE_PAIEMENT, :MONTANT_FRAIS_PORT,');
      SQL.Add(':DETAXE, :ID_PAIEMENT_TYPE, :NOM_CLIENT_LIVR, :PRENOM_CLIENT_LIVR)');
      ParamCheck := True;

      ParamByName('ID_CLIENT').AsInteger   := Client.Codeclient;
      ParamByName('ID_COMMANDE').AsInteger := CommandeInfos.CommandeId;
      ParamByName('NUM_COMMANDE').AsString := CommandeInfos.CommandeNum;

      FOR i := 1 TO 5 DO // init à 0 des 5 champs TVA
      BEGIN
        ParamByName('MT_TTC' + IntToStr(i)).AsFloat     := 0;
        ParamByName('MT_HT' + IntToStr(i)).AsFloat      := 0;
        ParamByName('MT_TAUX_HT' + IntToStr(i)).AsFloat := 0;
      END;

      FOR i := 0 TO High(TVAS) DO
      BEGIN
        if i < 5 then
        begin
          ParamByName('MT_TTC' + IntToStr(i + 1)).AsFloat     := TVAS[i].TotalHT + TVAS[i].MtTVA;
          ParamByName('MT_HT' + IntToStr(i + 1)).AsFloat      := TVAS[i].TotalHT;
          ParamByName('MT_TAUX_HT' + IntToStr(i + 1)).AsFloat := TVAS[i].TauxTva;
        end;
      END;

      ParamByName('REMISE').AsFloat := 0;

      ParamByName('COMENT').AsString := CommandeInfos.CommandeNum;

      if Colis.Transporteur <> '' then
        ParamByName('COMENT').AsString := ParamByName('COMENT').AsString + #13#10'Transporteur : ' + Colis.Transporteur;
      if Colis.MagasinRetrait <> '' then
        ParamByName('COMENT').AsString := ParamByName('COMENT').AsString + #13#10'Magasin retrait : ' + Colis.MagasinRetrait;

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

      ParamByName('CODE_SITE_WEB').AsInteger     := MySiteParams.iCodeSite;
      ParamByName('DATE_CREATION').AsDateTime    := CommandeInfos.CommandeDate;
      ParamByName('DATE_PAIEMENT').AsDateTime    := CommandeInfos.DateReglement;
      ParamByName('MONTANT_FRAIS_PORT').AsFloat  := FraisDePort;
      ParamByName('ID_PAIEMENT_TYPE').AsString   := CommandeInfos.ModeReglement ;//iPaiement;
      ParamByName('NOM_CLIENT_LIVR').AsString    := Client.AdresseLivr.sAdr_Nom;
      ParamByName('PRENOM_CLIENT_LIVR').AsString := Client.AdresseLivr.sAdr_Prenom;

      ExecSQL;
    end; // with que_commande
  Except on E:Exception do
    raise Exception.Create('GenCreateEnteteBL -> ' + E.Message);
  end;
end;

function GenCreateLineBL(ID_COMMANDE : Integer;ArtInfos : stArticleInfos;LigneCDE : TLigneCDE) : boolean;
begin
  With Dm_Common, Que_Tmp do
  try
    Result := True;
    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE TF_WEBG_CREER_BLLINE( :ID_COMMANDE, :ID_PRODUIT, :ID_TAILLE,');
    SQL.Add(':ID_COULEUR, :ID_PACK, :NUM_LOT, :ID_CODE_PROMO, :QTE, :PX_BRUT, :PX_NET,');
    SQL.Add(':PX_NET_NET, :POINTURE, :LONGUEUR, :MONTAGE_FIXATIONS, :INFO_SUP, :TYPE_VTE);');
    ParamCheck := True;

    ParamByName('ID_COMMANDE').AsInteger   := ID_COMMANDE;
    ParamByName('ID_PRODUIT').AsInteger    := ArtInfos.iArtId;
    ParamByName('ID_TAILLE').AsInteger     := ArtInfos.iTgfId;
    ParamByName('ID_COULEUR').AsInteger    := ArtInfos.iCouId;
    ParamByName('ID_PACK').AsInteger       := LigneCDE.LotId;
    ParamByName('NUM_LOT').AsInteger       := LigneCDE.LotNum;
    ParamByName('ID_CODE_PROMO').AsInteger := 0;
    ParamByName('QTE').AsInteger           := Trunc(LigneCDE.Qte);
    ParamByName('PX_BRUT').AsFloat         := LigneCDE.PUBrutTTC;// ArtInfos.fPxBrut;
//    IF Trunc(LigneCDE.Qte) <> 0 THEN
      ParamByName('PX_NET').AsFloat        := LigneCDE.PXTTC;// / Trunc(LigneCDE.Qte)
//    ELSE
//      ParamByName('PX_NET').AsFloat        := LigneCDE.PUTTC;

    ParamByName('PX_NET_NET').AsFloat      := LigneCDE.PUTTC;

    ParamByName('POINTURE').AsString       := '';
    ParamByName('LONGUEUR').AsString       := '';
    ParamByName('MONTAGE_FIXATIONS').AsInteger := 1;
    ParamByName('POINTURE').AsString           := '';
    ParamByName('INFO_SUP').AsString           := '';
    ParamByName('TYPE_VTE').AsInteger          := 1;
    ExecSQL;
  Except on E:Exception do
    begin
      Result := False;
      LogAction('Ligne Erreur : ' + E.Message,1);
      raise Exception.Create('GenCreateLineBL -> ' + E.Message);
    end;
  End;
end;

function GenCreateClient(Client : TClientCde) : Boolean;
var
 sPays : String;
begin
  Result := False;
  With Dm_Common do
  try
    With Que_Client, Client do
    begin
      Close;
      ParamByName('ID_CLIENT').AsInteger := Codeclient;
      // adresse de facturation
      With AdresseFact do
      begin
        sPays := UpperCase(StrEnleveAccents(sAdr_Pays));
        IF Pos('FRANCE', sPays) > 0 THEN
        BEGIN
          sPays := 'FRANCE';
        END;

        ParamByName('NOM_CLIENT').AsString          := sAdr_Nom;
        ParamByName('PRENOM_CLIENT').AsString       := sAdr_Prenom;
        ParamByName('EMAIL_CLIENT').AsString        := Email;
        ParamByName('ADRESSE_FACTURATION').AsString := sAdr_Adr1 + RC + sAdr_Adr2;
        ParamByName('CP_CLIENT').AsString           := sAdr_CP;
        ParamByName('VILLE_CLIENT').AsString        := sAdr_Ville;
        ParamByName('ID_PAYS').AsInteger            := GetOrCreatePayID(sPays);
        ParamByName('TEL_CLIENT').AsString          := sAdr_Tel;
        ParamByName('GSM_CLIENT').AsString          := sAdr_Gsm;
        ParamByName('FAX_CLIENT').AsString          := sAdr_Fax;
        ParamByName('SOCIETE').AsString             := sAdr_Ste;
      end;

      // Adresse de livraison
      With AdresseLivr do
      begin
        sPays := UpperCase(StrEnleveAccents(sAdr_Pays));
        IF Pos('FRANCE', sPays) > 0 THEN
        BEGIN
          sPays := 'FRANCE';
        END;

        ParamByName('NOM_CLIENT_LIVRAISON').AsString    := sAdr_Nom;
        ParamByName('PRENOM_CLIENT_LIVRAISON').AsString := sAdr_Prenom;
        ParamByName('EMAIL_CLIENT_LIVRAISON').AsString  := Email;
        ParamByName('ADRESSE_LIVRAISON').AsString       := sAdr_Adr1 + RC + sAdr_Adr2;
        ParamByName('CP_CLIENT_LIVRAISON').AsString     := sAdr_CP;
        ParamByName('VILLE_CLIENT_LIVRAISON').AsString  := sAdr_Ville;
        ParamByName('ID_PAYS_LIVRAISON').AsInteger      := GetOrCreatePayID(sPays);
        ParamByName('TEL_CLIENT_LIVRAISON').AsString    := sAdr_Tel;
      end;

      ParamByName('NUM_SIRET').AsString := '';
      ParamByName('NUM_TVA').AsString   := '';

      ExecSQL;
      Result := True;
    end; // with que_client
  Except on E:Exception do
    raise Exception.Create('GenCreateClient -> ' + E.Message);
  end;
end;

function GetFPTauxTVA(CODE_SITE_WEB : Integer) : Currency;
var
  ARTID_FP : Integer;
begin
  Result := 0;
  With Dm_Common do
  begin
    With Que_Tmp do
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

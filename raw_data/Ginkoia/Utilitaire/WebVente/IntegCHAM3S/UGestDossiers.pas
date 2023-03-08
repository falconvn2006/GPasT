unit UGestDossiers;

interface

uses
  UDossier, UBddDossier, UBddMaitre, System.Generics.Collections, system.Classes, UGestIni,
  System.SyncObjs, System.SysUtils, Vcl.Forms, Datasnap.DBClient, Data.DB, IdFTP, System.DateUtils,
  Winapi.Windows, IdFTPCommon, System.IOUtils, System.StrUtils;

type
  TListeDossiers = TObjectList<TDossier>;
  TGestDossiers = class(TThread)
    private
      FBddDossier         : TBddDossier;
      FBddMaitre          : TBddMaitre;
      FDossiers           : TListeDossiers;
      FInitAFaire         : boolean;
      FTraitementEnCours  : boolean;
      FStart              : boolean;
      FStop               : Boolean;
      FCrt                : TCriticalSection;
      FCrtLog             : TCriticalSection;
      FFTP                : TIdFTP;
      FPourcentGlobal     : integer;
      FPourcentElement    : integer;
      FLog                : TStringList;
      FLogFile            : TextFile;
      FGestIni            : TGestIni;
      FEvtPourcentEl      : TNotifyEvent;
      FEvtPourcentGl      : TNotifyEvent;
      FEvtLog             : TNotifyEvent;
      FEvtStart           : TNotifyEvent;
      FEvtFin             : TNotifyEvent;
      FDossierArchive     : string;
      FDossierTemp        : string;
      FDossierErreur      : string;
      procedure SetDossiers(pDossiers: TListeDossiers);
      function  GetDossiers : TListeDossiers;
      function GetBaseDossierOk: boolean;
      function GetBaseMaitreOk: boolean;
      function GetLog: string; //retourne une seule ligne de la pile de log
      procedure AddLog(pLog: string);
      function GetPourcentGlobal: integer;
      function GetPourcentElement: integer;
      procedure SetPourcentGlobal(pPourcent: integer);
      procedure SetPourcentElement(pPourcent: integer);
      procedure DoOnPourcentElement;
      procedure DoOnPourcentGlobal;
      procedure DoOnLog;
      procedure DoOnStart;
      procedure DoOnFin;
      procedure SupprOldData;
      function Deltree(sDir: string): Boolean;
      function GetDossierNomByID(pId: integer): string;
      function GetDateByCsv(pFileName: string): Int64;
    public
      constructor Create; reintroduce;
      destructor Destroy; reintroduce;
      procedure LoadDossiers;
      procedure StartInitialitation;
      procedure CreerDossier(pNom: string);
      procedure SupprimerDossier(pID: integer);
      procedure StartTraitement;
      procedure StopTraitement;
      property Dossiers : TListeDossiers read GetDossiers write SetDossiers;
      property TraitementEnCours : boolean read FTraitementEnCours;
      property ArretDemande : boolean read FStop;
      property BaseDossierOk: boolean read GetBaseDossierOk;
      property BaseMaitreOk: boolean read GetBaseMaitreOk;
      property PourcentGlobal: integer read GetPourcentGlobal;
      property PourcentElement: integer read GetPourcentElement;
      property Log: string read GetLog;
      property GestIni: TGestIni read FGestIni write FGestIni;
      property BddDossier: TBddDossier read FBddDossier write FBddDossier;
      property BddMaitre : TBddMaitre read FBddMaitre write FBddMaitre;
      property OnPourcentElement: TNotifyEvent read FEvtPourcentEl write FEvtPourcentEl;
      property OnPourcentGlobal : TNotifyEvent read FEvtPourcentGl write FEvtPourcentGl;
      property OnLog            : TNotifyEvent read FEvtLog write FEvtLog;
      property OnStart          : TNotifyEvent read FEvtStart write FEvtStart;
      property OnFin            : TNotifyEvent read FEvtFin write FEvtFin;
    protected
      procedure Execute; override;
  end;

implementation

{ TGestDossiers }

procedure TGestDossiers.AddLog(pLog: string);
var
  lLog: string;
begin
  lLog := DateTimeToStr(now)+' - '+pLog;
  Writeln(FLogFile,lLog);
  Flush(FLogFile);
  FCrtLog.Enter;
  FLog.Add(lLog);
  FCrtLog.Leave;
  if Assigned(FEvtLog) then
    Queue(nil,DoOnLog);
end;

constructor TGestDossiers.Create;
begin
  inherited Create(false);
  FCrt := TCriticalSection.Create;
  FCrtLog := TCriticalSection.Create;
  FGestIni := TGestIni.Create(ChangeFileExt(Application.ExeName,'.ini'));
  FBddDossier := TBddDossier.Create(FGestIni.BaseDossiers);
  FBddMaitre  := TBddMaitre.Create(FGestIni.BaseMaitre);
  FDossiers := TListeDossiers.Create(true);
  FFTP := TIdFTP.Create(nil);
  FFTP.TransferType := ftBinary;
  FFTP.Passive      := true;
  FLog := TStringList.Create;
  FInitAFaire := true;
  FTraitementEnCours := false;
  FDossierTemp := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)+'TMP');
  if not (DirectoryExists(FDossierTemp)) then
    CreateDir(FDossierTemp);
  FDossierArchive := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)+'Archives');
  if not DirectoryExists(FDossierArchive) then
    CreateDir(FDossierArchive);
  FDossierErreur := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)+'Erreurs');
  if not DirectoryExists(FDossierErreur) then
    CreateDir(FDossierErreur);
  SupprOldData;
end;

procedure TGestDossiers.CreerDossier(pNom: string);
begin
  FCrt.Enter;
  FBddDossier.CreerDossier(pNom);
  FCrt.Leave;
  LoadDossiers;
end;

destructor TGestDossiers.Destroy;
begin
  FCrt.Enter;
  FBddDossier.Free;
  FBddMaitre.Free;
  FDossiers.Free;
  FCrt.Leave;
  FCrt.Free;
  FCrtLog.Free;
  FLog.Free;
  FGestIni.Free;
  FFTP.Free;
  inherited Destroy;
end;

procedure TGestDossiers.DoOnFin;
begin
  if Assigned(FEvtFin) then
    FEvtFin(self);
end;

procedure TGestDossiers.DoOnLog;
begin
  if Assigned(FEvtLog) then
    FEvtLog(self);
end;

procedure TGestDossiers.DoOnPourcentElement;
begin
  if Assigned(FEvtPourcentEl) then
    FEvtPourcentEl(self);
end;

procedure TGestDossiers.DoOnPourcentGlobal;
begin
  if Assigned(FEvtPourcentGl) then
    FEvtPourcentGl(self);
end;

procedure TGestDossiers.DoOnStart;
begin
  if Assigned(FEvtStart) then
    FEvtStart(self);
end;

procedure TGestDossiers.Execute;
var
  lBclDossiers,
  lBclFichiers,
  lBclData    : integer;
  lFileOK     : Integer;
  lSearchRec  : TSearchRec;
  lInit       : boolean;
  lListeFiles,
  lCSV        : TStringList;
  lDossier    : string;
  lDataLine   : TStringList;
  lDate       : TDateTime;
  lData       : TStringList;
  lId         : integer;
  //lNbFichiers : integer;
  lDomaine    : integer;
  lASSCODE    : integer;
  lDossierArchive: string;
  lDossierErreur: string;
  lError      : boolean;
  lErrFichier : boolean;
begin
  lError := false;
  lDataLine := TStringList.Create;
  lDataLine.StrictDelimiter := true;
  lDataLine.Delimiter := ';';
  lDataLine.QuoteChar :=  '''';

  lCSV := TStringList.Create;
  lCSV.QuoteChar := '''';
  lListeFiles := TStringList.Create;
  lListeFiles.Sorted := true;
  lData       := TStringList.Create;

  while not(Terminated)do
  begin
    try
      if FInitAFaire then
        LoadDossiers;
      if (FStart                  // start manuel
        or (GestIni.Auto          // start auto (mode auto et tps depuis dernier lancement > à délai)
            and (Now > (IncMinute(GestIni.DateLancement,GestIni.Frequence)))))
        and not(FStop)            // stop manuel
        and not(Terminated) then  // fermeture d'application ou plantage complet non géré
      begin
        try
          Queue(nil,DoOnStart);
          FTraitementEnCours := true;
          FStart := false;
          SetPourcentGlobal(0);
          SetPourcentElement(0);
          lDate := Now;
          lError := false;
          try
            lDossierArchive := FDossierArchive+FormatDateTime('yyyymmdd-hhnnss',lDate);
            if not (DirectoryExists(lDossierArchive)) then
              CreateDir(lDossierArchive);
            AssignFile(FLogFile,lDossierArchive+'\'+ChangeFileExt(ExtractFileName(Application.ExeName),'_'+FormatDateTime('yyyymmdd-hhnnss',lDate)+'.log'));
            Rewrite(FLogFile);
          except
            on E:Exception do
            begin
              lError := true;
              AddLog('! Erreur initialisation des fichiers : '+e.Message);
            end;
          end;

          AddLog(' ---------- Démarrage du traitement ---------- ');

          SupprOldData;

          AddLog(' --> Téléchargement des fichiers <-- ');
          // -------------------------------------------------------------------- //
          // ------------- Récupération des fichiers sur le FTP ----------------- //
          // -------------------------------------------------------------------- //
          for lBclDossiers := 0 to FDossiers.Count -1 do
          begin
            if FStop or Terminated then
            begin
              AddLog(' !!! Arrêt du traitement !!!');
              break;
            end;
            AddLog(' --> '+FDossiers[lBclDossiers].Nom+' : Téléchargement des fichiers sur '+FDossiers[lBclDossiers].URL+' <--');
            lDossier := IncludeTrailingPathDelimiter(FDossierTemp+FDossiers[lBclDossiers].Nom);
            lListeFiles.Clear;
            try
              FFTP.Host         := FDossiers[lBclDossiers].URL;
              FFTP.Port         := FDossiers[lBclDossiers].Port;
              FFTP.Username     := FDossiers[lBclDossiers].User;
              FFTP.Password     := FDossiers[lBclDossiers].Password;
              //récupération des fichiers
              if not(Directoryexists(lDossier)) then
                CreateDir(lDossier);
              FFTP.Connect;
              FFTP.ChangeDir('/'+FDossiers[lBclDossiers].Repertoire);
              FFTP.List(lListeFiles,'*.TXT',false);
              for lBclFichiers := 0 to lListeFiles.Count -1 do
              begin
                SetPourcentElement(0);
                AddLog('Récupération de '+lListeFiles[lBclFichiers]);
                try
                  FFTP.Get(lListeFiles[lBclFichiers],lDossier+lListeFiles[lBclFichiers],true,false);
                  SetPourcentElement(80);
                  try
                    FFTP.Delete(lListeFiles[lBclFichiers]);
                    SetPourcentElement(100);
                  except
                    on E:Exception do
                    begin
                      lError := true;
                      AddLog('! Erreur suppression du fichier FTP '+lListeFiles[lBclFichiers]+#13#10+e.Message);
                    end;
                  end;
                except
                  on E:Exception do
                  begin
                    lError := true;
                    AddLog('! Erreur FTP sur le fichier : '+lListeFiles[lBclFichiers]+#13#10+e.Message);
                  end;
                end;
                SetPourcentGlobal((lBclDossiers * (10 div FDossiers.Count))+(((lBclFichiers + 1) * (10 div FDossiers.Count)) div lListeFiles.Count));
              end;
              FFTP.Disconnect;
              SetPourcentGlobal(((lBclDossiers + 1) * (10 div FDossiers.Count)));
            except
              on E:Exception do
              begin
                lError := true;
                AddLog('Erreur FTP'#13#10+e.Message);
              end;
            end;
            FFTP.Disconnect;
            AddLog(' --> '+FDossiers[lBclDossiers].Nom+' : Téléchargement terminé <--');
          end;
          SetPourcentGlobal(10);
          // -------------------------------------------------------------------- //
          // ------------ Envoi des fichiers dans la base Dossier --------------- //
          // -------------------------------------------------------------------- //
          for lBclDossiers := 0 to FDossiers.Count -1 do
          begin
            if FStop or Terminated then
            begin
              AddLog(' !!! Arrêt du traitement !!!');
              break;
            end;
            AddLog(' --> '+FDossiers[lBclDossiers].Nom+' : Traitement des fichiers <--');
            lDossier := IncludeTrailingPathDelimiter(FDossierTemp+FDossiers[lBclDossiers].Nom);
            // lister les fichiers
            //première boucle pour compter les fichiers
            lFileOK := FindFirst(lDossier+'*.txt',faAnyFile,lSearchRec);
            //lNbFichiers := 0;
            lBclFichiers := 0;
            lListeFiles.Clear;
            while lFileOK = 0 do
            begin
              //Inc(lNbFichiers);
              try
                lListeFiles.Add(IntToStr(GetDateByCsv(lSearchRec.Name))+'='+lSearchRec.Name);
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur récupération de la date dans le fichier '+lSearchRec.Name+#13#10+e.Message);
                end;
              end;
              lFileOK := FindNext(lSearchRec);
            end;
            // rangement par ordre de date
            lListeFiles.Sort;
            for lBclFichiers := 0 to lListeFiles.Count -1 do
            //lFileOK := FindFirst(lDossier+'*.txt',faAnyFile,lSearchRec);
            //while (lFileOK = 0) AND not(FStop) AND not(Terminated) do
            begin
              try
                SetPourcentElement(0);
                AddLog('Intégration du fichier '+lListeFiles.ValueFromIndex[lBclFichiers]+' ...');
                lErrFichier := false;
                lInit := (pos('INIT_',lListeFiles.ValueFromIndex[lBclFichiers]) > 0);

                lCSV.LoadFromFile(lDossier+lListeFiles.ValueFromIndex[lBclFichiers]);
                lCSV.Delete(0);
                if lCSV.Count > 0 then
                begin
                  try
                    //init des param de la BDD
                    FBddDossier.Dossier := FDossiers[lBclDossiers].ID;
                    try
                      FBddDossier.SetTableByCSV(lListeFiles.ValueFromIndex[lBclFichiers]);
                    except
                      on E:Exception do
                      begin
                        lError := true;
                        lErrFichier := true;
                        raise Exception.Create('! Erreur d''ouverture de la table '+FBddDossier.Table+#13#10+e.Message);
                      end;
                    end;
                    //si fichier "INIT"
                    if lInit and (FBddDossier.Table <> 'OC')  then
                    begin
                      try
                        FBddDossier.ClearTable;
                      except
                        on E:Exception do
                        begin
                          lError := true;
                          lErrFichier := true;
                          raise Exception.Create('! Erreur nettoyage de la table '+FBddDossier.Table+#13#10+e.Message);
                        end;
                      end;
                    end;
                    //SR - 03/11/2016 - Correction pour l'init des OC.
                    if lInit and (FBddDossier.Table = 'OC')  then
                    begin
                      try
                        FBddDossier.SetEtatData(0);
                      except
                        on E:Exception do
                        begin
                          lError := true;
                          lErrFichier := true;
                          raise Exception.Create('! Erreur nettoyage de la table '+FBddDossier.Table+#13#10+e.Message);
                        end;
                      end;
                    end;

                    // les champs de DATA + DOSID, DATEINSERT, DATEUPDATE, DATEDELETE doit correspondre
                    // au nombre de champs de la table
                    lDataLine.DelimitedText := lCSV[0];
                    if FBddDossier.FieldList.Count <> (lDataLine.Count + 4) then
                    begin
                      lError := true;
                      lErrFichier := true;
                      raise Exception.Create('! Nombre de champs incorrect par rapport à la table '+FBddDossier.Table);
                    end;
                    //on crée une requete insert/update par ligne (pas de multi insert/update dans interbase ...)
                    for lBclData := 0 to lCSV.Count -1 do
                    begin
                      if FStop or Terminated then
                      begin
                        AddLog(' !!! Arrêt du traitement !!!');
                        break;
                      end;
                      lDataLine.DelimitedText := lCSV[lBclData];
                        //si la ligne existe on met à jour
                        if FBddDossier.LineExist(lDataLine) then
                        begin
                          try
                            FBddDossier.UpdateLine(lDataLine);
                          except
                            on E : Exception do
                            begin
                              lError := true;
                              lErrFichier := true;
                              AddLog('! Erreur Update SQL'#13#10'DataLine:'+lDataLine.DelimitedText+#13#10+E.Message);
                            end;
                          end;
                        end
                        //si non on insert
                        else
                        begin
                          try
                            FBddDossier.InsertLine(lDataLine);
                          except
                            on E : Exception do
                            begin
                              lError := true;
                              lErrFichier := true;
                              AddLog('! Erreur Insert SQL'#13#10'DataLine:'+lDataLine.DelimitedText+#13#10+E.Message);
                            end;
                          end;
                        end;
                        SetPourcentElement(((lBclData+1)*100) div (lCSV.Count ));
                    end;
                  except
                    on E:Exception do
                    begin
                      lError := true;
                      lErrFichier := true;
                      AddLog('! Erreur d''intégration'#13#10+e.Message);
                    end;
                  end;
                end;
                // Archivage des fichiers
                try
                  if lErrFichier then
                  begin
                    lDossierErreur :=IncludeTrailingPathDelimiter(FDossierErreur+FormatDateTime('yyyymmdd-hhnnss',lDate));
                    if not (DirectoryExists(lDossierErreur)) then
                      CreateDir(lDossierErreur);
                    RenameFile(lDossier+lListeFiles.ValueFromIndex[lBclFichiers],lDossierErreur+lListeFiles.ValueFromIndex[lBclFichiers]);
                    AddLog('Fichier déplacé dans '+lDossierErreur);
                  end
                  else
                  begin
                    lDossierArchive := IncludeTrailingPathDelimiter(FDossierArchive+FormatDateTime('yyyymmdd-hhnnss',lDate)+'\'+FDossiers[lBclDossiers].Nom);
                    if not (DirectoryExists(lDossierArchive)) then
                      CreateDir(lDossierArchive);
                    RenameFile(lDossier+lListeFiles.ValueFromIndex[lBclFichiers],lDossierArchive+lListeFiles.ValueFromIndex[lBclFichiers]);
                  end;
                except
                  on E:Exception do
                  begin
                    lError := true;
                    AddLog('! Erreur archivage du fichier '+lListeFiles.ValueFromIndex[lBclFichiers]+#13#10+e.Message);
                  end;
                end;
                SetPourcentGlobal(10 + (lBclDossiers * (40 div FDossiers.Count))+((lBclFichiers + 1) * (40 div FDossiers.Count) div lListeFiles.Count));
                //lFileOK := FindNext(lSearchRec);
                //Inc(lBclFichiers);
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur dans le traitement du fichiers  '+lListeFiles.ValueFromIndex[lBclFichiers]+#13#10+e.Message);
                end;
              end;
              end;
            SetPourcentGlobal(10 + ((lBclDossiers + 1) * (40 div FDossiers.Count)));
            AddLog(' --> '+FDossiers[lBclDossiers].Nom+' : Traitement des fichiers terminée <--');
          end;
          SetPourcentGlobal(40);

          // -------------------------------------------------------------------- //
          // ------------ Envoi des données vers la base Ginkoia ---------------- //
          // -------------------------------------------------------------------- //

          lDate := Now;

          // ------------ MAJ des articles -------------------------------------- //

          SetPourcentElement(0);
          if not(FStop) and not(Terminated) then
          begin
            lDomaine := FGestIni.Domaine;
            lASSCODE := FGestIni.ASSCODE;

            AddLog(' --> Mise à jour des articles dans la base Ginkoia <--');
            try
              FBddDossier.Table := 'ARTWEB';
              FBddDossier.LoadData(FGestIni.DateLancement);
            except
              on E:Exception do
              begin
                lError := true;
                AddLog('! Erreur de récupération des données '+#13#10+e.Message);
              end;
            end;
          end;

          if not(FStop) and not(Terminated) then
          begin
            for lBclData := 0 to FBddDossier.RecordCount -1 do
            begin
              if FStop or Terminated then
              begin
                AddLog(' !!! Arrêt du traitement !!!');
                break;
              end;
              try
                if (FBddDossier.Field('ARW_CODEEAN') <> '') AND (FBddDossier.Field('ARW_ETATDATA') = '1') then
                begin
                  //recherche du ARTID
                  lId := FBddMaitre.FindARTIDbyEAN(FBddDossier.Field('ARW_CODEEAN'));
                  if lId <= 0 then
                  begin
                    lId := FBddDossier.GetIdByLink(FBddDossier.FieldInt('ARW_MODID'),FBddDossier.FieldInt('ARW_DOSID'));
                    if lId = 0 then
                    begin
                      lId := FBddMaitre.FindARTIDbyMarque(FBddDossier.Field('ARW_MRQREF'),FBddDossier.Field('MRQ_NOM'));
                    end;
                    if lId = 0 then
                    begin
                      //si pas trouvé on crée le modèle
                      try
                        lId := FBddMaitre.CreerModele(FBddDossier.Field('ARW_NOM'),FBddDossier.Field('ARW_MRQREF'),
                                              FBddDossier.Field('MRQ_NOM'),FBddDossier.Field('ARW_DETAIL'),
                                              FBddDossier.Field('ARW_COMPOSITION'),FBddDossier.Field('ARW_TVA'),
                                              FBddDossier.Field('RAY'),FBddDossier.Field('FAM'),
                                              FBddDossier.Field('SSF'),FBddDossier.Field('ARW_PREVENTE'),
                                              FBddDossier.Field('ARW_PREVENTEQTE'),FBddDossier.Field('DLW_LIBELLE'),
                                              FBddDossier.Field('GRE_NOM'),
                                              FBddDossier.Field('TGF_NOMGRILLE'),FBddDossier.Field('TGF_CODEGRILLE'),
                                              FBddDossier.Field('ARW_COLLECTION'),FBddDossier.Field('ARW_CLASSEMENT1'),
                                              FBddDossier.Field('ARW_CLASSEMENT2'),FBddDossier.Field('ARW_CLASSEMENT3'),
                                              FBddDossier.Field('ARW_CLASSEMENT4'),FBddDossier.Field('ARW_CLASSEMENT5'),
                                              lDomaine, lASSCODE);
                      except
                        on E:Exception do
                        begin
                          lError := true;
                          AddLog('! Erreur Création du modèle de l''article :'#13#10
                          +'ARW_NOM='+FBddDossier.Field('ARW_NOM')+', ARW_MRQREF='+FBddDossier.Field('ARW_MRQREF')
                          +', MRQ_NOM='+FBddDossier.Field('MRQ_NOM')+', ARW_DETAIL='+FBddDossier.Field('ARW_DETAIL')
                          +', ARW_COMPOSITION='+FBddDossier.Field('ARW_COMPOSITION')+', ARW_TVA='+FBddDossier.Field('ARW_TVA')
                          +', RAY='+FBddDossier.Field('RAY')+', FAM='+FBddDossier.Field('FAM')
                          +', SSF='+FBddDossier.Field('SSF')+', ARW_PREVENTE='+FBddDossier.Field('ARW_PREVENTE')
                          +', ARW_PREVENTEQTE='+FBddDossier.Field('ARW_PREVENTEQTE')+', DLW_LIBELLE='+FBddDossier.Field('DLW_LIBELLE')
                          +', GRE_NOM='+FBddDossier.Field('GRE_NOM')
                          +', TGF_NOMGRILLE='+FBddDossier.Field('TGF_NOMGRILLE')+', TGF_CODEGRILLE='+FBddDossier.Field('TGF_CODEGRILLE')
                          +', ARW_COLLECTION='+FBddDossier.Field('ARW_COLLECTION')+', ARW_CLASSEMENT1='+FBddDossier.Field('ARW_CLASSEMENT1')
                          +', ARW_CLASSEMENT2='+FBddDossier.Field('ARW_CLASSEMENT2')+', ARW_CLASSEMENT3='+FBddDossier.Field('ARW_CLASSEMENT3')
                          +', ARW_CLASSEMENT4='+FBddDossier.Field('ARW_CLASSEMENT4')+', ARW_CLASSEMENT5='+FBddDossier.Field('ARW_CLASSEMENT5')
                          +', DOMAINE='+IntToStr(lDomaine)+', ASSCODE='+IntToStr(lASSCODE)
                          +#13#10+e.Message);
                        end;
                      end;
                    end;
                    try
                      //création de l'article
                      if lId > 0 then
                      begin
                        FBddDossier.SetIdByLink(lId,FBddDossier.FieldInt('ARW_MODID'),FBddDossier.FieldInt('ARW_DOSID'));
                        FBddMaitre.CreerArticle(FBddDossier.Field('ARW_CODEEAN'),FBddDossier.Field('ARW_TAILLE'),
                                            FBddDossier.Field('TGF_CODETAILLE'),FBddDossier.Field('ARW_COULEUR'),
                                            FBddDossier.Field('ARW_CODECOULEUR'),FBddDossier.Field('GCS_NOM'),
                                            FBddDossier.Field('PRX_PXVTE'),FBddDossier.Field('PRX_PUMP'),lId);
                      end
                      else
                        AddLog('! Tentative de création d''article sur modèle inexistant : '+FBddDossier.Field('ARW_CODEEAN'));
                    except
                      on E:Exception do
                      begin
                        lError := true;
                        AddLog('! Erreur Création de l''article :'#13#10
                              +'CODEEAN='+FBddDossier.Field('ARW_CODEEAN')+', TAILLE='+FBddDossier.Field('ARW_TAILLE')
                              +', TGF_CODETAILLE='+FBddDossier.Field('TGF_CODETAILLE')+', ARW_COULEUR='+FBddDossier.Field('ARW_COULEUR')
                              +', ARW_COULEUR='+FBddDossier.Field('ARW_CODECOULEUR')+', GCS_NOM='+FBddDossier.Field('GCS_NOM')
                              +', PRX_PXVTE='+FBddDossier.Field('PRX_PXVTE')+', PRW_PUMP='+FBddDossier.Field('PRX_PUMP')+', MOD_ID='+IntToStr(lId)
                              +#13#10+e.Message);
                      end;
                    end;
                  end
                  else
                  begin
                    // MAJ de l'article seulement s'il est actif. pas de suppression
                    try
                      FBddDossier.SetIdByLink(lId,FBddDossier.FieldInt('ARW_MODID'),FBddDossier.FieldInt('ARW_DOSID'));
                      if (FBddDossier.Field('ARW_WEB') = '1') AND (FBddDossier.Field('ARW_ETATDATA') = '1') then
                        FBddMaitre.UpdateArticle(FBddDossier.Field('ARW_CODEEAN'),FBddDossier.Field('PRX_PXVTE'),
                                              FBddDossier.Field('PRX_PXVTEN'),FBddDossier.Field('PRX_PUMP'),
                                              FBddDossier.Field('GCS_NOM'));
                    except
                      on E:Exception do
                      begin
                        lError := true;
                        AddLog('! Erreur Mise à jour de l''article :'#13#10
                            +'CODEEAN='+FBddDossier.Field('ARW_CODEEAN')+', PRX_PXVTE='+FBddDossier.Field('PRX_PXVTE')
                            +', PRX_PXVTEN='+FBddDossier.Field('PRX_PXVTEN')+', PRX_PUMP='+FBddDossier.Field('PRX_PUMP')
                            +', GCS_NOM='+FBddDossier.Field('GCS_NOM')
                            +#13#10+e.Message);
                      end;
                    end;
                  end;
                end;
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur Traitement : '+FBddDossier.Field('ARW_CODEEAN')+#13#10+e.Message);
                end;
              end;
              FBddDossier.Next;
              SetPourcentElement(((lBclData + 1) * 100) div FBddDossier.RecordCount);
              SetPourcentGlobal(40 + (((lBclData + 1) * 40) div FBddDossier.RecordCount));
            end;
            AddLog(' --> Mise à jour des articles Terminée <--');
          end;
          SetPourcentGlobal(80);

          // ------------ MAJ des code barre ------------------------------------ //

          SetPourcentElement(0);
          if not(FStop) and not(Terminated) then
          begin
            AddLog(' --> Mise à jour des Codes Barres dans la base Ginkoia <--');
            try
              FBddDossier.Table := 'CBFOURN';
              FBddDossier.LoadData(FGestIni.DateLancement);
            except
              on E:Exception do
              begin
                lError := true;
                AddLog('! Erreur de récupération des données '+#13#10+e.Message);
              end;
            end;
          end;

          if not(FStop) and not(Terminated) then
          begin
            for lBclData := 0 to FBddDossier.RecordCount -1 do
            begin
              if FStop or Terminated then
              begin
                AddLog(' !!! Arrêt du traitement !!!');
                break;
              end;
              try
                if FBddDossier.Field('ARW_CODEEAN') <> FBddDossier.Field('CBF_CBFOURN') then
                begin
                  FBddMaitre.MAJCodeBarre(FBddDossier.Field('CBF_CBFOURN'),FBddDossier.Field('ARW_CODEEAN'),FBddDossier.Field('CBF_ETATDATA'))
                end;
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur Traitement : '+#13#10
                          + 'CODEEAN='+FBddDossier.Field('ARW_CODEEAN')+', CB='+FBddDossier.Field('CBF_CBFOURN')
                          +', CBPrin='+FBddDossier.Field('CBF_CBPRINCIPAL')+', Dossier='+FBddDossier.Field('CBF_DOSID')
                          +#13#10+e.Message);
                end;
              end;
              FBddDossier.Next;
              SetPourcentElement(((lBclData + 1) * 100) div FBddDossier.RecordCount);
              SetPourcentGlobal(80 + (((lBclData + 1) * 5) div FBddDossier.RecordCount));
            end;
            SetPourcentGlobal(85);
            AddLog(' --> Mise à jour des Codes Barres Terminée <--');
          end;

          // ------------ MAJ des nomenclatures secondaires --------------------- //

          SetPourcentElement(0);
          if not(FStop) and not(Terminated) then
          begin
            AddLog(' --> Mise à jour des nomenclatures secondaires dans la base Ginkoia <--');
            try
              FBddDossier.Table := 'ARTNOMENK';
              FBddDossier.LoadData(FGestIni.DateLancement);
            except
              on E:Exception do
              begin
                lError := true;
                AddLog('! Erreur de récupération des données '+#13#10+e.Message);
              end;
            end;
          end;

          if not(FStop) and not(Terminated) then
          begin
            for lBclData := 0 to FBddDossier.RecordCount -1 do
            begin
              if FStop or Terminated then
              begin
                AddLog(' !!! Arrêt du traitement !!!');
                break;
              end;
              try
                FBddMaitre.MAJArtNkWeb(FBddDossier.Field('ARW_CODEEAN'),FBddDossier.Field('SSF'),
                FBddDossier.Field('FAM'),FBddDossier.Field('RAY'),FBddDossier.Field('ANK_ETATDATA'),GestIni.Domaine);
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur Traitement : '+FBddDossier.Field('ARW_CODEEAN')+#13#10+e.Message);
                end;
              end;
              FBddDossier.Next;
              SetPourcentElement(((lBclData + 1) * 100) div FBddDossier.RecordCount);
              SetPourcentGlobal(85 + (((lBclData + 1) * 10) div FBddDossier.RecordCount));
            end;
            SetPourcentGlobal(95);
            AddLog(' --> Mise à jour des nomenclatures secondaires Terminée <--');
          end;

          // ----------------------- MAJ des OC --------------------------------- //

          SetPourcentElement(0);
          if not(FStop) and not(Terminated) then
          begin
            lDomaine := FGestIni.Domaine;
            AddLog(' --> Mise à jour des opérations commerciales dans la base Ginkoia <--');
            try
              FBddDossier.Table := 'OC';
              FBddDossier.LoadData(FGestIni.DateLancement);
            except
              on E:Exception do
              begin
                lError := true;
                AddLog('! Erreur de récupération des données '+#13#10+e.Message);
              end;
            end;
          end;

          if not(FStop) and not(Terminated) then
          begin
            for lBclData := 0 to FBddDossier.RecordCount -1 do
            begin
              if FStop or Terminated then
              begin
                AddLog(' !!! Arrêt du traitement !!!');
                break;
              end;
              try
                lId := FBddMaitre.FindOCTIDbyRef(FBddDossier.Field('OCM_NOM'),
                            '[OC'+GetDossierNomByID(StrToInt(FBddDossier.Field('OCM_DOSID')))+']');
                if lId <= 0 then
                  lId := FBddDossier.GetIdByLink(FBddDossier.FieldInt('OCM_ID'),FBddDossier.FieldInt('OCM_DOSID'));
                //si lId=0 on envoi 0 et la procédure crée un nouvel OC
                lId := FBddMaitre.CreerOC(lId,FBddDossier.Field('OCM_NOM'),
                          '[OC'+GetDossierNomByID(FBddDossier.FieldInt('OCM_DOSID'))+']',FBddDossier.Field('OCM_DATEDEBUT'),
                          FBddDossier.Field('OCM_DATEFIN'),FBddDossier.FieldInt('OCM_type'),FBddDossier.Field('OCM_CODEEAN'),
                          FBddDossier.Field('OCM_PRIX'),FBddDossier.FieldInt('OCM_ETATDATA'));
                FBddDossier.SetIdByLink(lId,FBddDossier.FieldInt('OCM_ID'),FBddDossier.FieldInt('OCM_DOSID'));
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur Traitement : '+FBddDossier.Field('OCM_CODEEAN')+#13#10+e.Message);
                end;
              end;
              FBddDossier.Next;
              SetPourcentElement(((lBclData + 1) * 100) div FBddDossier.RecordCount);
              SetPourcentGlobal(95 + (((lBclData + 1) * 5) div FBddDossier.RecordCount));
            end;
            SetPourcentGlobal(100);
            AddLog(' --> Mise à jour des opérations commerciales Terminée <--');
          end;

          // ------------ MAJ des TRANSPORTEURS ------------------------------ //

          SetPourcentElement(0);
          if not(FStop) and not(Terminated) then
          begin
            AddLog(' --> Mise à jour des TRANSPORTEURS dans la base Ginkoia <--');
            try
              FBddDossier.Table := 'TRANSPORTEURS';
              FBddDossier.LoadData(FGestIni.DateLancement);
            except
              on E:Exception do
              begin
                lError := true;
                AddLog('! Erreur de récupération des données '+#13#10+e.Message);
              end;
            end;
          end;

          if not(FStop) and not(Terminated) then
          begin
            for lBclData := 0 to FBddDossier.RecordCount -1 do
            begin
              if FStop or Terminated then
              begin
                AddLog(' !!! Arrêt du traitement !!!');
                break;
              end;
              try
                FBddMaitre.MAJTransporteur(FBddDossier.Field('TRA_NOM'),FBddDossier.Field('TRA_CODE'),FBddDossier.Field('TRA_ETATDATA'))
              except
                on E:Exception do
                begin
                  lError := true;
                  AddLog('! Erreur Traitement : '+#13#10
                          + 'NOM='+FBddDossier.Field('TRA_NOM')+', CODE='+FBddDossier.Field('TRA_CODE')
                          +#13#10+e.Message);
                end;
              end;
              FBddDossier.Next;
              SetPourcentElement(((lBclData + 1) * 100) div FBddDossier.RecordCount);
              SetPourcentGlobal(80 + (((lBclData + 1) * 5) div FBddDossier.RecordCount));
            end;
            SetPourcentGlobal(85);
            AddLog(' --> Mise à jour des TRANSPORTEURS Terminée <--');
          end;

          // ----------------------- Fin du traitement --------------------------------- //

          if FStop or Terminated then
            begin
              AddLog(' !!! Traitement interrompu par l''utilisateur !!!');
              FStop := false;
              lError := true;
            end;
          if lError = true then
          begin
            AddLog(' ---------- Traitement Terminé avec erreurs ----------');
          end
          else
          begin
            AddLog(' ---------- Traitement Terminé ----------');
            // date de dernière mise à jour pour par relire les même données la prochaine fois
            // mémorise seulement si pas d'erreur pour pouvoir recommencer
            FGestIni.DateUpdate := Now;
          end;
          FGestIni.dateLancement := lDate;
          FTraitementEnCours := false;
          CloseFile(FLogFile);
          SetPourcentGlobal(0);
          SetPourcentElement(0);
          Queue(nil,DoOnFin);

        except
          on E:Exception do
          begin
            AddLog('! Erreur indéterminée : '+#13#10+E.Message); // #panpanpan
          end;
        end;

      end;
      Sleep(1000);
    except
      on E:Exception do
      begin
        AddLog('! Erreur indéterminée : '+#13#10+E.Message);  // je suis pas chasseur mais je lui mettrais bien une cartouche
      end;
    end;
  end;
  lListeFiles.Free;
  lCSV.Free;
  lDataLine.Free;
end;

function TGestDossiers.GetBaseDossierOk: boolean;
begin
  try
    FBddDossier.Connect;
    result := true;
    //AddLog('Connection OK à la base Dossiers');
  except
    on E: Exception do
    begin
      Result := false;
      //AddLog('! Erreur connection à la base Dossiers'#13#10+E.Message);
    end;
  end;
end;

function TGestDossiers.GetBaseMaitreOk: boolean;
begin
  try
    FBddMaitre.Connect;
    result := true;
    //AddLog('Connection OK à la base Ginkoia');
  except
    on E: Exception do
    begin
      Result := false;
      //AddLog('! Erreur connection à la base Ginkoia '#13#10+E.Message);
    end;
  end;
end;

function TGestDossiers.GetDateByCsv(pFileName: string): Int64;
begin
  Result := 0;
  pFileName := TPath.GetFileNameWithoutExtension(pFileName);

  // on récupère la date si elle est présente
    if Pos('-',pFileName) > 0 then
      Result := StrToInt64(RightStr(pFileName,Length(pFileName) - Pos('-',pFileName)));
end;

function TGestDossiers.GetDossierNomByID(pId: integer): string;
var
  lBcl: integer;
begin
  Result := '';
  for lBcl := 0 to FDossiers.Count -1 do
  begin
    if FDossiers[lBcl].ID = pId then
    begin
      Result := FDossiers[lBcl].Nom;
      break;
    end;
  end;
end;

function TGestDossiers.GetDossiers: TListeDossiers;
begin
  FCrt.Enter;
  Result := FDossiers;
  FCrt.Leave;
end;

function TGestDossiers.GetLog: string;
begin
  FCrtLog.Enter;
  if FLog.Count > 0 then
  begin
    Result := FLog[0];
    FLog.Delete(0);
  end;
  FCrtLog.Leave;
end;

function TGestDossiers.GetPourcentElement: integer;
begin
  FCrtLog.Enter;
  Result := FPourcentElement;
  FCrtLog.Leave;
end;

function TGestDossiers.GetPourcentGlobal: integer;
begin
  FCrtLog.Enter;
  Result := FPourcentGlobal;
  FCrtLog.Leave;
end;

procedure TGestDossiers.LoadDossiers;
var
  lListeDossiers: TListeDossierInfo;
  lBclDossier: integer;
  vDossier : TDossier;
begin
  lListeDossiers := TListeDossierInfo.Create;
  //AddLog('Chargement de la configuration des dossiers ...');
  FCrt.Enter;
  FBddDossier.GetListDossiers(lListeDossiers);
  FDossiers.Clear;
  for lBclDossier := 0 to lListeDossiers.Count-1 do
  begin
    // the dark side of the moon
    vDossier := TDossier.Create(lListeDossiers[lBclDossier].ID, FBddDossier);
    FDossiers.Add( vDossier);
  end;
  FCrt.Leave;
  lListeDossiers.Free;
end;

procedure TGestDossiers.SetDossiers(pDossiers: TListeDossiers);
begin
  FCrt.Enter;
  FDossiers := pDossiers;
  FCrt.Leave;
  LoadDossiers;
end;

procedure TGestDossiers.SetPourcentElement(pPourcent: integer);
var
  lPourcentOld: integer;
begin
  FCrtLog.Enter;
  lPourcentOld := FPourcentElement;
  FPourcentElement := pPourcent;
  FCrtLog.Leave;
  //evt seulement si différent
  if (lPourcentOld <> pPourcent) and Assigned(FEvtPourcentEl) then
    Queue(nil,DoOnPourcentElement);
end;

procedure TGestDossiers.SetPourcentGlobal(pPourcent: integer);
var
  lPourcentOld: integer;
begin
  FCrtLog.Enter;
  lPourcentOld := FPourcentGlobal;
  FPourcentGlobal := pPourcent;
  FCrtLog.Leave;
  //evt seulement si différent
  if (lPourcentOld <> pPourcent) and Assigned(FEvtPourcentGl) then
    Queue(nil,DoOnPourcentGlobal);
end;

procedure TGestDossiers.StartInitialitation;
begin
  FInitAFaire := true;
end;

procedure TGestDossiers.StartTraitement;
begin
  FStart := true;
end;

procedure TGestDossiers.StopTraitement;
begin
  FStop := true;
  AddLog('!!! Demande d''arrêt du traitement !!!');
end;

procedure TGestDossiers.SupprimerDossier(pID: integer);
begin
  FCrt.Enter;
  FBddDossier.SupprDossier(pID);
  FCrt.Leave;
  LoadDossiers;
end;

procedure TGestDossiers.SupprOldData;
var
  SR: TSearchRec;
  IsFound: Boolean;
  lDateFichier: TDateTime;
  lAnnee, lMois, lJour, lHeure, lMinutes, lSecondes: integer;
begin
  try
    IsFound := FindFirst(FDossierArchive+'*.*', faDirectory, SR) = 0;
    while IsFound do
    begin
      if (SR.Name[1] <> '.') then
      begin
        try
          lAnnee    := StrToInt(copy(SR.Name,1,4));
          lMois     := StrToInt(copy(SR.Name,5,2));
          lJour     := StrToInt(copy(SR.Name,7,2));
          lHeure    := StrToInt(copy(SR.Name,10,2));
          lMinutes  := StrToInt(copy(SR.Name,12,2));
          lSecondes := StrToInt(copy(SR.Name,14,2));
          lDateFichier := EncodeDateTime(lAnnee,lMois,lJour,lHeure,lMinutes,lSecondes,0);
          if lDateFichier < (IncDay(now, - FGestIni.DelaiSupprDate)) then
            Deltree(FDossierArchive + SR.Name);
        except
        end;
      end;
      IsFound := FindNext(SR) = 0;
  end;
  finally
    System.SysUtils.FindClose(SR);
  end;
end;

function TGestDossiers.Deltree(sDir: string): Boolean;
var
  iIndex: Integer;
  SearchRec: TSearchRec;
  sFileName: string;
begin
  sDir := sDir + '\*.*';
  iIndex := FindFirst(sDir, faAnyFile, SearchRec);
  while iIndex = 0 do
  begin
    sFileName := ExtractFileDir(sDir) + '\' + SearchRec.Name;
    if SearchRec.Attr = faDirectory then
    begin
    if (SearchRec.Name <> '' ) and
       (SearchRec.Name <> '.') and
       (SearchRec.Name <> '..') then
       Deltree(sFileName);
    end else
    begin
      if SearchRec.Attr <> faArchive then
        FileSetAttr(sFileName, faArchive);
      System.SysUtils.DeleteFile(sFileName);
    end;
    iIndex := FindNext(SearchRec);
  end;
  System.SysUtils.FindClose(SearchRec);
  RemoveDir(ExtractFileDir(sDir));
  Result := True;
end;

end.

unit UThreadProcess;

interface

uses
  System.Classes, IBX.IBDatabase, IBX.IBQuery, System.SysUtils, System.SyncObjs,
  UConstantes, ULog, UConfigIni;

type

  TThreadProcess = class(TThread)
  private
    FOnMessage: TMessageEvent;
    FOnProgress: TProgressEvent;
    FDBMaint, FDBWeb: TIBDatabase;
    FQueryMaint, FQueryWeb: TIBQuery;
    FTransMaint, FTransWeb : TIBTransaction;
    FListeCSV: TStringList;
    FCrt: TCriticalSection;
    //FLog: TLog;
    FIni: TConfigIni;
    procedure DoOnMessageEvent(pText: string);
    procedure DoOnProgressEvent(pProgress: integer);
    procedure AddCsvLine(pClient: string; pNbrArt: integer; pVersion: string);overload;
    procedure AddCsvLine(pClient: string; pNbrArt: string; pVersion: string);overload;
    function GetCSV: TStringList;
    { Déclarations privées }
  protected
    procedure Execute; override;
  public
    constructor Create(pBase: string; pConfig: TConfigIni);
    destructor Destroy;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property CSV: TStringList read GetCSV;
  end;

implementation

procedure TThreadProcess.AddCsvLine(pClient: string; pNbrArt: integer; pVersion: string);
begin
  if pNbrArt < 0 then
    AddCsvLine(pClient,'Erreur','')
  else
    AddCsvLine(pClient,IntToStr(pNbrArt),pVersion);
end;

procedure TThreadProcess.AddCsvLine(pClient: string; pNbrArt: string; pVersion: string);
begin
  FCrt.Enter;
  FListeCSV.Add(pClient+';'+pNbrArt+';'+pVersion);
  FCrt.Leave;
end;

constructor TThreadProcess.Create(pBase: string; pConfig: TConfigIni);
begin
  inherited Create(true);
  //FreeOnTerminate := true;
  FCrt := TCriticalSection.Create;
  FListeCSV := TStringList.Create;
  FIni := pConfig;
  //base maintenance
  FDBMaint := TIBDatabase.Create(nil);
  FDBMaint.Params.Add('user_name=SYSDBA');
  FDBMaint.Params.Add('password=masterkey');
  FDBMaint.Params.Add('instance_name=gds_db');
  FDBMaint.DatabaseName := pBase;
  FDBMaint.LoginPrompt := false;
  FDBMaint.DefaultTransaction := FTransMaint;
  FTransMaint := TIBTransaction.Create(nil);
  FTransMaint.DefaultDatabase := FDBMaint;
  FQueryMaint := TIBQuery.Create(nil);
  FQueryMaint.Database := FDBMaint;
  FQueryMaint.Transaction := FTransMaint;
  //base pour chaque client
  FDBWeb := TIBDatabase.Create(nil);
  FDBWeb.Params.Add('user_name=SYSDBA');
  FDBWeb.Params.Add('password=masterkey');
  FDBWeb.Params.Add('instance_name=gds_db');
  FDBWeb.LoginPrompt := false;
  FDBWeb.DefaultTransaction := FTransWeb;
  FTransWeb := TIBTransaction.Create(nil);
  FTransWeb.DefaultDatabase := FDBWeb;
  FQueryWeb := TIBQuery.Create(nil);
  FQueryWeb.Database := FDBWeb;
  FQueryWeb.Transaction := FTransWeb;
  //monitoring
  Log.App := 'NbArtWebParDossier';
  Log.Open;

end;

destructor TThreadProcess.Destroy;
begin
  FQueryWeb.Close;
  FQueryWeb.Free;
  FTransWeb.Free;
  FDBWeb.Free;
  FQueryMaint.Close;
  FQueryMaint.Free;
  FTransMaint.Free;
  FDBMaint.Free;
//  FLog.Free;
  inherited Destroy;
end;

procedure TThreadProcess.DoOnMessageEvent(pText: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(FOnMessage) then
        FOnMessage(self,pText);
    end
  );
end;

procedure TThreadProcess.DoOnProgressEvent(pProgress: integer);
begin
  Synchronize(
    procedure
    begin
      if Assigned(FOnProgress) then
        FOnProgress(self,pProgress);
    end
  );
end;

procedure TThreadProcess.Execute;
var
  lNbrDatabase: integer;
  iDatabase: integer;
  lNomClient: string;
  lNbrArticle: integer;
  lVersion: string;
begin

  DoOnMessageEvent('Lecture de la configuration');
  AddCsvLine('NomDossier','NbArticleActifs','Version');
  //on récupère la base maintenance qui liste toutes les bases clients à traiter

  if FDBMaint.DatabaseName = '' then
  begin
    DoOnMessageEvent('Erreur base maintenance: pas de nom de fichier');
    Log.Log(getMachineName, '', '', '', 'Status', 'Erreur base maintenance: pas de nom de fichier', logError, True, FIni.TempsMonitoring);
  end
  else
  begin

    try
      FDBMaint.Connected := true;
    except
      on E:exception do
      begin
        DoOnMessageEvent('Erreur connexion base : '+E.Message);
        Log.Log(getMachineName, '', '', '', 'Status', 'Erreur connexion base : '+E.Message, logError, True, FIni.TempsMonitoring);
      end;
    end;

    if FDBMaint.Connected then
    begin
      //lecture de la config maintenance
      FQueryMaint.SQL.Clear;
      FQueryMaint.SQL.Add('SELECT DOSS_DATABASE, DOSS_CHEMIN FROM DOSSIER');
      FQueryMaint.SQL.Add('WHERE DOSS_ID <> 0');
      FQueryMaint.SQL.Add('ORDER BY DOSS_DATABASE');
      try
        FQueryMaint.Open;
        FQueryMaint.FetchAll;
        lNbrDatabase := FQueryMaint.RecordCount;
      except
        on E:exception do
        begin
          DoOnMessageEvent('Erreur requète base maintenance : '+E.Message);
          Log.Log(getMachineName, '', '', '', 'Status', 'Erreur requète base maintenance : '+E.Message, logError, True, FIni.TempsMonitoring);
        end;
      end;

      //boucle sur chaque base pour les calculs
      for iDatabase := 0 to lNbrDatabase - 1 do
      begin
        if Terminated then
        begin
          DoOnMessageEvent('Arret utilisateur en cours');
          Break;
        end;
        //récupération de la base client
        FQueryWeb.Close;
        FDBWeb.Connected := false;
        FDBWeb.DatabaseName := FQueryMaint.FieldByName('DOSS_CHEMIN').AsString;
        lNomClient := FQueryMaint.FieldByName('DOSS_DATABASE').AsString;
        lNbrArticle := 0;
        //test connection
        try
          FDBWeb.Connected := true;
        except
          on E:exception do
          begin
            lNbrArticle := -4;
            DoOnMessageEvent('Base '+lNomClient+' : Erreur connexion : '+E.Message);
            Log.Log(getMachineName, '', lNomClient, '', 'Status', 'Erreur connexion : '+E.Message, logError, True, FIni.TempsMonitoring);
          end;
        end;
        if FDBWeb.Connected then
        begin
          try
            //on vérifie que le module WEB est bien installé dans ce magasin
            FQueryWeb.SQL.Clear;
            FQueryWeb.SQL.Add('SELECT COUNT(*) FROM UILGRPGINKOIA');
            FQueryWeb.SQL.Add('Join K on K_ID = UGG_ID and K_Enabled = 1');
            FQueryWeb.SQL.Add('Join UILGRPGINKOIAMAG on UGM_UGGID = UGG_ID');
            FQueryWeb.SQL.Add('Join K on K_ID = UGG_Id and K_Enabled = 1');
            FQueryWeb.SQL.Add('where ugg_nom = ''WEB VENTE''');

            FQueryWeb.Open;
            if FQueryWeb.FieldByName('COUNT').AsInteger = 0 then
            begin
              lNbrArticle := -1;
              DoOnMessageEvent('Base '+lNomClient+' : Pas de module WEB');
              Log.Log(getMachineName, '', lNomClient, '', 'Status', 'OK', logInfo, True, FIni.TempsMonitoring);
              Log.Log(getMachineName, '', lNomClient, '', 'NbArticles', '0', logInfo, True, FIni.TempsMonitoring);
            end
            else
            begin
              try
                //comptage des articles dispo sur le Web
                FQueryWeb.SQL.Clear;
                FQueryWeb.SQL.Add('SELECT COUNT(ARW_ID) ');
                FQueryWeb.SQL.Add('FROM ARTWEB JOIN K ON K_ID = ARW_ID AND K_Enabled = 1 AND ARW_WEB = 1 ');
                FQueryWeb.SQL.Add('JOIN ARTDISPOWEB JOIN K ON K_ID = ADW_ID AND K_Enabled = 1 AND ADW_DISPO = 1 ON ARW_ARTID = ADW_ARTID ');
                FQueryWeb.Open;
                lNbrArticle := FQueryWeb.FieldByName('COUNT').AsInteger;
                DoOnMessageEvent('Base '+lNomClient+' : '+IntToStr(lNbrArticle)+' articles');
                Log.Log(getMachineName, '', lNomClient, '', 'Status', 'OK', logInfo, True, FIni.TempsMonitoring);
                Log.Log(getMachineName, '', lNomClient, '', 'NbArticles', IntToStr(lNbrArticle), logInfo, True, FIni.TempsMonitoring);
              except
                on E:exception do
                begin
                  lNbrArticle := -2;
                  DoOnMessageEvent('Base '+lNomClient+' : Erreur requète : '+E.Message);
                  Log.Log(getMachineName, '', lNomClient, '', 'NbArticles', 'Erreur requète : '+E.Message, logError, True, FIni.TempsMonitoring);
                end;
              end;
              try
                //recherche n° de version de la base
                FQueryWeb.SQL.Clear;
                FQueryWeb.SQL.Add('SELECT VER_VERSION FROM GENVERSION');
                FQueryWeb.SQL.Add('WHERE VER_DATE = ');
                FQueryWeb.SQL.Add('(SELECT MAX(VER_DATE) FROM GENVERSION)');
                FQueryWeb.Open;
                lVersion := FQueryWeb.FieldByName('VER_VERSION').AsString;
                DoOnMessageEvent('Base '+lNomClient+' : Version '+lVersion);
                Log.Log(getMachineName, '', lNomClient, '', 'Status', 'OK', logInfo, True, FIni.TempsMonitoring);
                Log.Log(getMachineName, '', lNomClient, '', 'NbArticles', IntToStr(lNbrArticle), logInfo, True, FIni.TempsMonitoring);
              except
                on E:exception do
                begin
                  lVersion := '';
                  DoOnMessageEvent('Base '+lNomClient+' : Erreur requète : '+E.Message);
                  Log.Log(getMachineName, '', lNomClient, '', 'Version', 'Erreur requète : '+E.Message, logError, True, FIni.TempsMonitoring);
                end;
              end;
            end;
          except
            on E:exception do
              begin
                lNbrArticle := -3;
                DoOnMessageEvent('Base '+lNomClient+' : Erreur requète : '+E.Message);
                Log.Log(getMachineName, '', lNomClient, '', 'NbArticles', 'Erreur requète : '+E.Message, logError, True, FIni.TempsMonitoring);
              end;
          end;
        end;
        AddCsvLine(lNomClient,lNbrArticle,lVersion);
        DoOnProgressEvent(((iDatabase+1)*100) div lNbrDatabase);
        FQueryMaint.Next;
      end;
      Log.Log(getMachineName, '', '', '', 'Status', 'OK', logInfo, True, FIni.TempsMonitoring);
      //FLog.Close;
    end;
  end;
end;

function TThreadProcess.GetCSV: TStringList;
begin
  FCrt.Enter;
  Result := FListeCSV;
  FCrt.Leave;
end;

end.

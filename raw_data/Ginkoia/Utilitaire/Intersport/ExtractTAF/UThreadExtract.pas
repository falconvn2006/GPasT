unit UThreadExtract;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.IniFiles, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP,
  FireDAC.Phys.IBDef, FireDAC.Phys.IBBase, FireDAC.Phys.IB,
  FireDAC.Comp.UI, dateutils, FireDAC.Stan.StorageJSON, strutils,
  Winapi.Windows, IdFTPCommon, uLog;

type
  TExtractMode = (emManu, emAuto);
  TExtractFile = (efVentes, efEncaissements, efStocks);
  TConfigFTP = record
    Host: string;
    Port: integer;
    Username: string;
    Password: string;
    Path: string;
    Passive: boolean;
    ConnectTimeout: integer;
    ReadTimeout: integer;
  end;
  TConfig = record
    FTP: TConfigFTP;
    Base: string;
    CodeMag: string;
    GUID: string;
    MagId: integer;
    HeureFermeture: TTime;
    DateVente: TDate;
    DateEncaissement: TDate;
    DateStock: TDate;
    ExtractPath: string;
    ArchivePath: string;
    EnTeteCSV: boolean;
  end;

  TThreadExtract = class(TThread)
    private
      FStart: boolean;
      FDateList: array of TDate;
      FFileList: array of TExtractFile;
      FFTP: TIdFTP;
      FQuery: TFDQuery;
      FConnection : TFDConnection;
      FCancel : boolean;
//      FLogPath: string;
      FArchivePath: string;
      FEnCours: boolean;
      FEvtMajIHM: TNotifyEvent;
      FEvtMajPourcent: TNotifyEvent;
      FEvtFinTraitement: TNotifyEvent;
      FDateEnCours: TDate;
      FStatus: string;
      FPourcent: integer;
      FLog: TLog;
      FLastDate: TDate;
      FConfig: TConfig;
      FModeAuto: boolean;
      FError: boolean;
      procedure EnvoiFTP;
      procedure SaveToCsv(AFileName: string);
      procedure DoOnMajIHM;
      function getDateDebut: TDate;
      function getDateFin: TDate;
      procedure Log(ATexte: string; ALevel: TLogLevel);
      procedure Start(ADateDebut: TDate; ADateFin: TDate; AFileList: array of TExtractFile);
      procedure LoadConfig;
      procedure SaveConfigMag;
      procedure SaveConfigDate;
      procedure SetPourcent(APourcent: integer);
    public
      property DateDebut: TDate read getDateDebut;
      property DateFin: TDate read getDateFin;
      property DateEnCours: TDate read FDateEnCours;
      property LastDate: TDate read FLastDate;
      property HeureFermeture: TTime read FConfig.HeureFermeture;
      property Status: string read FStatus;
      property Pourcent: integer read FPourcent;
      property EnCours : boolean read FEnCours;
      property Error: boolean read FError;
      property OnMajIHM: TNotifyEvent read FEvtMajIHM write FEvtMajIHM;
      property OnFinTraitement: TNotifyEvent read FEvtFinTraitement write FEvtFinTraitement;
      property OnMajPourcent: TNotifyEvent read FEvtMajPourcent write FEvtMajPourcent;
      procedure StartManu(ADateDebut: TDate; ADateFin: TDate; AFileList: array of TExtractFile);
      procedure StartAuto;
      procedure Stop;
      constructor Create; reintroduce;
      destructor Destroy; override;
    protected
      procedure Execute; override;
  end;

implementation

{ TThreadExtract }

//==============================================================================
constructor TThreadExtract.Create;
begin
  inherited Create(true);
  FStart := false;
  FModeAuto := false;
  FDateEnCours := 0;
  FPourcent := 0;
  FStatus := '';
  FDateEnCours := 0;
  LoadConfig;
  FConnection := TFDConnection.Create(nil);
  FConnection.ConnectionString := 'DriverID=IB;Database='+FConfig.Base+';User_Name=SYSDBA;Password=masterkey;'
                                    +'InstanceName=gds_db';
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
  FFTP := TIdFTP.Create(nil);
  FFTP.TransferType := ftbinary;
  FFTP.Host := FConfig.FTP.Host;
  FFTP.Port := FConfig.FTP.Port;
  FFTP.Username := FConfig.FTP.Username;
  FFTP.Password := FConfig.FTP.Password;
  FFTP.Passive := FConfig.FTP.Passive;
  FFTP.ConnectTimeout := FConfig.FTP.ConnectTimeout;
  FFTP.ReadTimeout := FConfig.FTP.ReadTimeout;

  FLastDate := FConfig.DateVente;
  if FConfig.DateEncaissement < FLastDate then
    FLastDate := FConfig.DateEncaissement;
  if FConfig.DateStock < FLastDate then
    FLastDate := FConfig.DateStock;
  if (FLastDate > Date) or (FLastDate = 0) then
  begin
    FLastDate := Date;
  end;

  if not(Directoryexists(FConfig.ExtractPath)) then
    CreateDir(FConfig.ExtractPath);
  if not(Directoryexists(FConfig.ArchivePath)) then
    CreateDir(FConfig.ArchivePath);
  FArchivePath := IncludeTrailingPathDelimiter(FConfig.ArchivePath+FormatDateTime('YYYY',Date));
  if not(Directoryexists(FArchivePath)) then
    CreateDir(FArchivePath);
  FArchivePath := IncludeTrailingPathDelimiter(FConfig.ArchivePath+FormatDateTime('YYYY',Date)+ '\' + FormatDateTime('MM',Date));
  if not(Directoryexists(FArchivePath)) then
    CreateDir(FArchivePath);
//  FArchivePath := IncludeTrailingPathDelimiter(FArchivePath + FormatDateTime('DD',Date));
//  if not(Directoryexists(FArchivePath)) then
//    CreateDir(FArchivePath);
//  FLogPath := ExtractFilePath(ParamStr(0))+'Logs\';
//  if not(Directoryexists(FLogPath)) then
//    CreateDir(FLogPath);
  FLog := TLog.Create;
  FLog.readIni(ChangeFileExt(ParamStr(0),'.ini'));
  FLog.Mag := IntToStr(FConfig.MagId);
  FLog.Ref := FConfig.GUID;
  FLog.Open;
  Suspended := false;
end;
//------------------------------------------------------------------------------
destructor TThreadExtract.Destroy;
begin
  FQuery.Free;
  FConnection.Free;
  FFTP.Free;
  if FLog.Opened then
    FLog.Close;
  FLog.Free;
  inherited;
end;
//==============================================================================
procedure TThreadExtract.DoOnMajIHM;
begin
  Synchronize(procedure
  begin
    if Assigned(FEvtMajIHM) then
      FEvtMajIHM(self);
  end);
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.EnvoiFTP;
var
  lSearchRec: TSearchRec;
  lFileOk: integer;
  lCount: integer;
  lBcl: integer;
begin
  lCount := 0;
  lFileOK := FindFirst(FConfig.ExtractPath + '*.csv',faAnyFile,lSearchRec);
  try
    while (lFileOK = 0) and not(FCancel) and not(Terminated) do
    begin
      Inc(lCount);
      lFileOK := FindNext(lSearchRec);
    end;
  except
  end;
  lBcl := 0;
  lFileOK := FindFirst(FConfig.ExtractPath + '*.csv',faAnyFile,lSearchRec);
  try
    while (lFileOK = 0) and not(FCancel) and not(Terminated) do
    begin
      Inc(lBcl);
      try
        if FCancel then
          Break;
        if not FFTP.Connected then
        begin
          Log('Connection FTP à l''adresse : '+FFTP.Host,logTrace);
          FFTP.Connect;
          FFTP.ChangeDir(FConfig.FTP.Path);
        end;

        try
          try
            FFTP.Delete(ChangeFileExt(lSearchRec.Name,'.TMP'));
            Log('Fichier '+ChangeFileExt(lSearchRec.Name,'.TMP')+' déja existant sur le FTP a été supprimé',logTrace);
          except
          end;

          FFTP.Put(FConfig.ExtractPath + lSearchRec.Name,ChangeFileExt(lSearchRec.Name,'.TMP'));
          Log('Fichier '+ChangeFileExt(lSearchRec.Name,'.TMP')+' envoyé avec succés',logTrace);
        except
          on E:Exception do
          begin
            raise Exception.Create('Impossible d''envoyer le fichier ' + ChangeFileExt(lSearchRec.Name,'.TMP') + ' sur le FTP '
              +#13#10+'Classname : '+E.ClassName+ #13#10'Exception : '+E.Message);
          end;
        end;

        try
          try
            FFTP.Delete(lSearchRec.Name);
            Log('Fichier '+lSearchRec.Name+' déja existant que le FTP a été supprimé',logTrace);
          except
          end;
          FFTP.Rename(ChangeFileExt(lSearchRec.Name,'.TMP'),lSearchRec.Name);
          Log('Fichier '+ChangeFileExt(lSearchRec.Name,'.TMP')+' renommé avec succés en '+lSearchRec.Name,logTrace);
        except
          on E:Exception do
          begin
            raise Exception.Create('Impossible de renommer le fichier ' + ChangeFileExt(lSearchRec.Name,'.TMP') + ' en ' + lSearchRec.Name + ' sur le FTP après l''envoi '
              +#13#10+'Classname : '+E.ClassName+ #13#10'Exception : '+E.Message);
          end;
        end;

        try
          if FileExists(FArchivePath+lSearchRec.Name)  then
          begin
            Log('Le fichier '+lSearchRec.Name+' existe déja dans les archives',logTrace);
            DeleteFile(PChar(FArchivePath+lSearchRec.Name));
            Log('Fichier '+lSearchRec.Name+' supprimé des archives',logTrace);
          end;
          RenameFile(FConfig.ExtractPath+lSearchRec.Name,FArchivePath+lSearchRec.Name);
          Log('Fichier '+lSearchRec.Name+' archivé avec succés',logTrace);
        except
          on E:Exception do
          begin
            raise Exception.Create('Impossible d''archiver le fichier ' + lSearchRec.Name
              + ' dans le dossier ' + FArchivePath +#13#10+'Classname : '+E.ClassName+ #13#10'Exception : '+E.Message);
          end;
        end;

      except
        on E:Exception do
        begin
          Log(E.Message,logError);
        end;
      end;
      SetPourcent(80 + ((lBcl * 20) div lCount));
      lFileOK := FindNext(lSearchRec);
    end;
  finally
    FFTP.Disconnect;
  end;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.Execute;
var
  lFileName : string;
  lBclDate, lBclFile: integer;
begin
  try
    if (FConfig.CodeMag = '') or (FConfig.MagId = 0) then
      begin
        FQuery.SQL.Text := 'SELECT MAG_ID, MAG_CODEADH, BAS_GUID FROM GENMAGASIN ' +
              'JOIN GENBASES ON BAS_MAGID = MAG_ID ' +
              'JOIN GENPARAMBASE ON BAS_IDENT = PAR_STRING ' +
              'WHERE PAR_NOM = ''IDGENERATEUR''';
        FQuery.Open;
        if not FQuery.IsEmpty then
        begin
          FConfig.CodeMag := FQuery.FieldByName('MAG_CODEADH').AsString;
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'/','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'\','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'<','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'>','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,':','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'"','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'|','');
          FConfig.CodeMag := ReplaceStr(FConfig.CodeMag,'*','');

          FConfig.MagId := FQuery.FieldByName('MAG_ID').AsInteger;
          FLog.Mag := IntToStr(FConfig.MagId);
          FConfig.GUID := FQuery.FieldByName('BAS_GUID').AsString;
          FLog.Ref := FConfig.GUID;
          SaveConfigMag;
        end;
      end;
  except
    on E:Exception do
    begin
      Log('Erreur récupération des paramètres en base'#13#10'Classname : '+e.ClassName+#13#10'Exception : '+E.Message,logError);
    end;
  end;

  while not Terminated do
  begin
    try
      if FStart and not FCancel then
      begin
        FStart := false;
        FEnCours := true;
        SetPourcent(0);

        for lBclDate := Low(FDateList) to High(FDateList) do
        begin
          FDateEnCours := FDateList[lBclDate];
          if (FDateEnCours = Date) and (Time < FConfig.HeureFermeture) then
          begin
            Log('Pas d''extraction pour le '+DateToStr(FDateEnCours)+ ' : l''heure de fermeture du magasin n''est pas passée',logInfo);
            continue;
          end;
          Log('Démarrage de l''extraction du '+DateToStr(FDateEnCours),logInfo);
          for lBclFile := Low(FFileList) to High(FFileList) do
          begin
            lFileName := '';
            FQuery.SQL.Clear;
            if FCancel then break;
            case FFileList[lBclFile] of
              efVentes:
              begin
                if (FDateEnCours > FConfig.DateVente) or not FModeAuto then
                begin
                  Log('Extraction des ventes',logInfo);
                  lFileName := FormatDateTime('YYYYMMDD',FDateEnCours)+'EXTRACTVENTE'+FConfig.CodeMag+'.CSV';
                  FQuery.SQL.Text := 'SELECT CBI1.CBI_CB CBNosymag, '
                        + 'CODEEAN CBFourn, '
                        + 'R_DATEJOUR DateVente, '
                        + 'R_ARFCHRONO Chrono, R_ARTREFMRK Ref, R_ARTNOM Libelle, MRKCODE codeMarque, R_MRKNOM Marque, '
                        + 'R_TGFNOM Taille, CODE codeCouleur, R_COUNOM Couleur, R_SECNOM Nkl1, R_RAYNOM Nkl2,  R_FAMNOM Nkl3, R_SSFNOM Nkl4, '
                        + 'R_QTE Qte, R_PXBRUT CATTCBrut, R_PXNN CATTCNET, HT CAHTNET, R_CAMV CAMV, TVA_CODE, R_TVA TauxTVA ,TVAID IdTVA '
                        + 'FROM ExtractTAF_JVDATEHISTO(:DDEB, :DFIN, :LISTEMAGS) '
                        + 'join ARTCODEBARRE CBI1 on CBI1.CBI_ARFID = ARFID and CBI1.CBI_COUID = COUID and CBI1.CBI_TGFID = TGFID and CBI1.CBI_TYPE = 1 '
                        + 'join K KCBI1 on KCBI1.K_ID = CBI1.CBI_ID and KCBI1.K_ENABLED = 1 '
                        + 'join ARTTVA on TVA_ID = TVAID '
                        + 'join K on TVA_ID = K_ID and K_ENABLED = 1 ';
                  FQuery.ParamByName('DDEB').AsDate := FDateEnCours;
                  FQuery.ParamByName('DFIN').AsDate := FDateEnCours;
                  FQuery.ParamByName('LISTEMAGS').AsString := '|' + IntToStr(FConfig.MagId) + '|';
                end;
              end ;
              efEncaissements:
              begin
                if (FDateEnCours > FConfig.DateEncaissement) or not FModeAuto then
                begin
                  Log('Extraction des encaissements',logInfo);
                  lFileName := FormatDateTime('YYYYMMDD',FDateEnCours)+'EXTRACTCAISSE'+FConfig.CodeMag+'.CSV';
                  FQuery.SQL.Text := 'SELECT TKE_DATE dateTicket, MEN_NOM modeEnc, MEN_ID idEnc, (SES_NUMERO || ''-'' || cast(TKE_NUMERO as varchar(32))) numTicket, ENC_MONTANT valeur '
                      + 'FROM CSHTICKET JOIN CSHSESSION ON TKE_SESID = SES_ID '
                      + 'JOIN CSHENCAISSEMENT ON ENC_TKEID = TKE_ID '
                      + 'JOIN CSHMODEENC ON ENC_MENID = MEN_ID '
                      + 'WHERE TKE_DATE between :DATEDEBUT and :DATEFIN  ';
                  FQuery.ParamByName('DATEDEBUT').AsDateTime := FDateEnCours;
                  FQuery.ParamByName('DATEFIN').AsDateTime := IncSecond(FDateEnCours + 1,-1);
                end;
              end;
              efStocks:
              begin
                if (FDateEnCours > FConfig.DateStock) or not FModeAuto then
                begin
                  Log('Extraction des stocks',logInfo);
                  lFileName := FormatDateTime('YYYYMMDD',FDateEnCours)+'EXTRACTSTOCK'+FConfig.CodeMag+'.CSV';
                  FQuery.SQL.Text := 'SELECT CBI_CB CBNosymag, HST_QTE Qte, HST_PUMP PUMP '
                        + 'FROM ARTCODEBARRE '
                        + 'JOIN K KCBI ON CBI_ID = KCBI.K_ID and KCBI.K_ENABLED = 1 '
                        + 'JOIN ARTREFERENCE ON CBI_ARFID = ARF_ID '
                        + 'JOIN AGRHISTOSTOCK ON HST_ARTID = ARF_ARTID AND HST_COUID = CBI_COUID AND HST_TGFID = CBI_TGFID '

                        + 'WHERE CBI_TYPE = 1 and HST_DATE <= :DATE and HST_DATEFIN >= :DATE '
                        + 'and hst_id <> 0 and cbi_id <> 0 '
                        + 'and HST_ARTID != 0 '
                        + 'and hst_magid = :MAGID ' ;
                  FQuery.ParamByName('DATE').AsDate := FDateEnCours;
                  FQuery.ParamByName('MAGID').AsInteger := FConfig.MagId;
                end;
              end;
            end; // case lFile
            if FCancel then break;
            if (lFileName <> '') and not FileExists(FConfig.ExtractPath+lFileName) then
            begin
              try
                FQuery.Open;
              except
                on E:Exception do
                begin
                  Log('Erreur lors de l''exécution de la query'#13#10
                    +'Classname : '+E.ClassName+#13#10'Exception : '+E.Message,logError);
                end;
              end;
              //FPourcent := (lBclFile/Length(FFileList)) *  + (lBclDate/Length(FDateList)) * ;
              if FCancel then break;
              Log('Enregistrement du fichier ' + lFileName,logTrace);
              try
                SaveToCsv(FConfig.ExtractPath+lFileName);
              except
                on E:Exception do
                begin
                  Log('Erreur lors l''enregistrement du fichier '+lFileName+#13#10
                  +'Classname : '+E.ClassName+#13#10'Exception : '+E.Message,logError);
                end;
              end;
            end; //FileExists
            try
              case FFileList[lBclFile] of
                efVentes:
                begin
                  FConfig.DateVente := FDateEnCours;
                  Log('Fin du traitement Vente',logInfo);
                end;
                efEncaissements:
                begin
                  FConfig.DateEncaissement := FDateEnCours;
                  Log('Fin du traitement Encaissement',logInfo);
                end;
                efStocks:
                begin
                  FConfig.DateStock := FDateEnCours;
                  Log('Fin du traitement Stock',logInfo);
                end;
              end;
              if FModeAuto then
              begin
                SaveConfigDate;
              end;
              FLastDate := FDateEnCours;
            except
              on E:Exception do
              begin
                Log('Impossible de sauvegarder la date'#13#10+'Classname : '+E.ClassName+#13#10'Exception : '+E.Message,logError);
              end;
            end;
            SetPourcent(((lBclDate * 80) div Length(FDateList)) + ((Succ(lBclFile) * (80 div Length(FDateList) )) div Length(FFileList)));
            if FCancel or Terminated then break;
          end; // for lFile
          Log('Fin de l''extraction du '+DateToStr(FDateEnCours),logInfo);
          SetPourcent((Succ(lBclDate) * 80) div Length(FDateList)) ;
          if FCancel or Terminated then break;
        end;// for lDate
        SetPourcent(80);
        if not(FCancel or Terminated) then
        begin
          if FFTP.Host <> ''  then
          begin
            Log('Envoi des fichiers sur le FTP',logInfo);
            try
              EnvoiFTP;
            except
              on E:Exception do
              begin
                Log(E.Message,logError);
              end;
            end;
            Log('Fin d''envoi des fichiers sur le FTP',logInfo);
          end;
        end;
        SetPourcent(100);

        FDateEnCours := 0;
        FEnCours := false;
        if FCancel or Terminated then
          log('Traitement arrété par l''utilisateur'#13#10'FCancel='+BoolToStr(FCancel,true)+#13#10'Terminated='+BoolToStr(Terminated,true),logError)
        else
        begin
          if FError then
            Log('Traitement terminé avec erreurs',logInfo)
          else
            Log('Traitement terminé',logInfo);
        end;

        Synchronize(procedure
        begin
          if Assigned(FEvtFinTraitement) then
            FEvtFinTraitement(self);
        end);
        if FLog.Opened then
          FLog.Close;
      end;
      sleep(100);
    except
      on E:Exception do
      begin
        Log('Erreur critique'#13#10'Classname : '+e.ClassName+#13#10'Exception : '+e.Message,logError);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TThreadExtract.getDateDebut: TDate;
begin
  if Length(FDateList) > 0 then
    Result := FDateList[Low(FDateList)]
  else
    Result := 0;
end;
//------------------------------------------------------------------------------
function TThreadExtract.getDateFin: TDate;
begin
  if Length(FDateList) > 0 then
    Result := FDateList[High(FDateList)]
  else
    Result := 0;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.LoadConfig;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  try
    FConfig.Base := lIni.ReadString('BASE','Fichier','C:\Ginkoia\Data\Ginkoia.IB');
    if not lIni.ValueExists('BASE','Fichier') then
      lIni.WriteString('BASE','Fichier',FConfig.Base);
    FConfig.FTP.Host := lIni.ReadString('FTP','Host','');
    if not lIni.ValueExists('FTP','Host') then
      lIni.WriteString('FTP','Host',FConfig.FTP.Host);
    FConfig.FTP.Port := lIni.ReadInteger('FTP','Port',21);
    if not lIni.ValueExists('FTP','Port') then
      lIni.WriteInteger('FTP','Port',FConfig.FTP.Port);
    FConfig.FTP.Username := lIni.ReadString('FTP','Username','');
    if not lIni.ValueExists('FTP','Username') then
      lIni.WriteString('FTP','Username',FConfig.FTP.Username);
    FConfig.FTP.Password := lIni.ReadString('FTP','Password','');
    if not lIni.ValueExists('FTP','Password') then
      lIni.WriteString('FTP','Password',FConfig.FTP.Password);
    FConfig.FTP.Passive := lIni.ReadBool('FTP','Passive',true);
    if not lIni.ValueExists('FTP','Passive') then
      lIni.WriteBool('FTP','Passive',FConfig.FTP.Passive);
    FConfig.FTP.ConnectTimeout := lIni.ReadInteger('FTP','ConnectTimeout',5000);
    if not lIni.ValueExists('FTP','ConnectTimeout') then
      lIni.WriteInteger('FTP','ConnectTimeout',FConfig.FTP.ConnectTimeout);
    FConfig.FTP.ReadTimeout := lIni.ReadInteger('FTP','ReadTimeout',5000);
    if not lIni.ValueExists('FTP','ReadTimeout') then
      lIni.WriteInteger('FTP','ReadTimeout',FConfig.FTP.ReadTimeout);
    FConfig.FTP.Path := lIni.ReadString('FTP','Path','/');
    if not (LeftStr(FConfig.FTP.Path,1) = '/') then
      FConfig.FTP.Path := '/' + FConfig.FTP.Path;
    if not lIni.ValueExists('FTP','Path') then
      lIni.WriteString('FTP','Path',FConfig.FTP.Path);
    FConfig.CodeMag := lIni.ReadString('MAGASIN','CodeMag','');
    if not lIni.ValueExists('MAGASIN','CodeMag') then
      lIni.WriteString('MAGASIN','CodeMag',FConfig.CodeMag);
    FConfig.MagId := lIni.ReadInteger('MAGASIN','MagId',0);
    if not lIni.ValueExists('MAGASIN','MagId') then
      lIni.WriteInteger('MAGASIN','MagId',FConfig.MagId);
    FConfig.GUID := lIni.ReadString('MAGASIN','GUID','');
    if not lIni.ValueExists('MAGASIN','GUID') then
      lIni.WriteString('MAGASIN','GUID',FConfig.GUID);
    FConfig.DateVente := lIni.ReadDate('EXTRACTIONS','DateVente',0);
    if not lIni.ValueExists('EXTRACTIONS','DateVente') then
      lIni.WriteDate('EXTRACTIONS','DateVente',FConfig.DateVente);
    FConfig.DateEncaissement := lIni.ReadDate('EXTRACTIONS','DateEncaissement',0);
    if not lIni.ValueExists('EXTRACTIONS','DateEncaissement') then
      lIni.WriteDate('EXTRACTIONS','DateEncaissement',FConfig.DateEncaissement);
    FConfig.DateStock := lIni.ReadDate('EXTRACTIONS','DateStock',0);
    if not lIni.ValueExists('EXTRACTIONS','DateStock') then
      lIni.WriteDate('EXTRACTIONS','DateStock',FConfig.DateStock);
    FConfig.HeureFermeture := lIni.ReadTime('EXTRACTIONS','HeureFermeture',StrToTime('20:00:00'));
    if not lIni.ValueExists('EXTRACTIONS','HeureFermeture') then
      lIni.WriteTime('EXTRACTIONS','HeureFermeture',FConfig.HeureFermeture);
    FConfig.ExtractPath := lIni.ReadString('EXTRACTIONS','ExtractPath',ExtractFilePath(ParamStr(0))+'Extract\');
    FConfig.ExtractPath := IncludeTrailingPathDelimiter(FConfig.ExtractPath);
    if not lIni.ValueExists('EXTRACTIONS','ExtractPath') then
      lIni.WriteString('EXTRACTIONS','ExtractPath',FConfig.ExtractPath);
    FConfig.ArchivePath := lIni.ReadString('EXTRACTIONS','ArchivePath',ExtractFilePath(ParamStr(0))+'Archives\');
    FConfig.ArchivePath := IncludeTrailingPathDelimiter(FConfig.ArchivePath);
    if not lIni.ValueExists('EXTRACTIONS','ArchivePath') then
      lIni.WriteString('EXTRACTIONS','ArchivePath',FConfig.ArchivePath);
    FConfig.EnTeteCSV := lIni.ReadBool('EXTRACTIONS','EnTeteCSV',false);
    if not lIni.ValueExists('EXTRACTIONS','EnTeteCSV') then
      lIni.WriteBool('EXTRACTIONS','EnTeteCSV',FConfig.EnTeteCSV);
  finally
    lIni.Free;
  end;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.Log(ATexte: string; ALevel: TLogLevel);
begin
  FLog.Log('','',ATexte,ALevel,false,-1,ltLocal);
  if ALevel >= logWarning then
    FError := true;
  if ALevel = logInfo then
  begin
    FStatus := ATexte;
    if ALevel = logInfo then
      DoOnMajIHM;
  end;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.SaveConfigMag;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  try
     lIni.WriteString('MAGASIN','CodeMag',FConfig.CodeMag);
     lIni.WriteInteger('MAGASIN','MagId',FConfig.MagId);
     lIni.WriteString('MAGASIN','GUID',FConfig.GUID);
  finally
    lIni.Free;
  end;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.SaveConfigDate;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  try
     lIni.WriteDate('EXTRACTIONS','DateVente',FConfig.DateVente);
     lIni.WriteDate('EXTRACTIONS','DateEncaissement',FConfig.DateEncaissement);
     lIni.WriteDate('EXTRACTIONS','DateStock',FConfig.DateStock);
  finally
    lIni.Free;
  end;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.SaveToCsv(AFileName: string);
var
  lStream: TStringStream;
  iFields: integer;
  lString: string;
begin
  lStream := TStringStream.Create;
  try
    if FConfig.EnTeteCSV then
    begin
      for iFields := 0 to FQuery.FieldDefs.Count -1 do
      begin
        if not (iFields = FQuery.FieldDefs.Count -1) then
          lStream.WriteString(FQuery.FieldDefs[iFields].Name + ';')
        else
          lStream.WriteString(FQuery.FieldDefs[iFields].Name+#13#10);
      end;
    end;
    while not FQuery.Eof do
    begin
      lString := '';
      for iFields := 0 to FQuery.Fields.Count -1 do
      begin
        if FQuery.FieldDefs[iFields].DataType in [ftFloat,ftFMTBcd] then
          lString := FormatFloat('0.##',FQuery.FieldByName(FQuery.FieldDefs[iFields].Name).AsFloat)
        else
          lString := FQuery.FieldByName(FQuery.FieldDefs[iFields].Name).AsString;
        if not (iFields = FQuery.Fields.Count -1) then
          lStream.WriteString(lString + ';')
        else
          lStream.WriteString(lString+#13#10);
      end;
      FQuery.Next;
    end;
    lStream.SaveToFile(ChangeFileExt(AFileName,'.TMP'));
    RenameFile(ChangeFileExt(AFileName,'.TMP'),AFileName);
  finally
    lStream.Free;
  end;
end;
procedure TThreadExtract.SetPourcent(APourcent: integer);
begin
  FPourcent := APourcent;
  if Assigned(FEvtMajPourcent) then
    Synchronize(procedure
      begin
        FEvtMajPourcent(nil);
      end);
end;

//------------------------------------------------------------------------------
procedure TThreadExtract.Start(ADateDebut: TDate; ADateFin: TDate; AFileList: array of TExtractFile);
var
  lFile: TExtractFile;
  iDate: integer;
begin
  if FEnCours then exit;
  FError := false;
  FCancel := false;
  SetLength(FDateList,0);

  if ADateFin > Date then
    ADateFin := Date;

  if ADateDebut > ADateFin then
    ADateDebut := ADateFin;

  for iDate := 0 to DaysBetween(ADateDebut,ADateFin) do
  begin
    SetLength(FDateList,length(FDateList)+1);
    FDateList[High(FDateList)] := ADateDebut + iDate;
  end;

  SetLength(FFileList,0);
  for lFile in AFileList do
  begin
    SetLength(FFileList,length(FFileList)+1);
    FFileList[High(FFileList)] := lFile;
  end;
  if not FLog.Opened then
    FLog.Open;
  log('Démarrage du traitement',logInfo);
  FStart := true;
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.StartAuto;
var
  lDateFin: TDate;
begin
  if FEnCours then exit;
  if not FLog.Opened then
    FLog.Open;

  if Time >= FConfig.HeureFermeture then
    lDateFin := Date
  else
    lDateFin := Date - 1;
  if not FLog.Opened then
    FLog.Open;
  Log('Démarrage mode du traitement automatique',logInfo);
  FModeAuto := true;
  Start(FLastDate,lDateFin,[efVentes,efEncaissements,efStocks]);
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.StartManu(ADateDebut, ADateFin: TDate;
  AFileList: array of TExtractFile);
begin
  if FEnCours then exit;
  if not FLog.Opened then
    FLog.Open;
  Log('Démarrage mode du traitement manuel',logInfo);
  FModeAuto := false;
  Start(ADateDebut,ADateFin,AFileList);
end;
//------------------------------------------------------------------------------
procedure TThreadExtract.Stop;
begin
  FCancel := true;
  Log('Demande d''arrêt par l''utilisateur',logError);
end;
//==============================================================================
end.

unit LaunchEvent_Dm;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBStoredProc, IBCustomDataSet, IBQuery,
  uLogFile, UMapping, LaunchMain_Dm, CstLaunch, Variants, uLog, SyncObjs,
  Dialogs;

const
  CREPLICATIONOK = 2998;
  CLASTREPLIC = 2999;
  CSYNCHROOK = 3000;
  CLASTSYNC = 3001;
  CWEBOK = 3002;
  CLASTWEB = 3003;
  CPFOK = 3004;
  CLASTPF = 3005;
  CBACKRESTOK = 3006;
  CLASTBACKREST = 3007;
  CBIOK = 3008;
  CLASTBI = 3009;

type
  TEventHisto = record
    getInfosSuccess: Boolean;
    isEOF: Boolean;
    HEV_DATE: TDateTime;
    HEV_MODULE: string;
    HEV_BASE: string;
    HEV_RESULT: Integer;
    HEV_TEMPS: TDateTime;
  end;

  TDm_LaunchEvent = class(TDataModule)
    Ib_Divers_Evt: TIBQuery;
    Ib_Event: TIBQuery;
    Sp_NewKey_Evt: TIBStoredProc;
    IBQue_Last_Repli: TIBQuery;
    IBQue_Last_RepliL_DATE: TDateField;
    IBQue_Last_RepliL_HEURE: TTimeField;
    IBStProc_BaseID: TIBStoredProc;
    Data_Evt: TIBDatabase;
    tran_evt: TIBTransaction;
    procedure Data_EvtBeforeConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CloseOpenConnexion;
    procedure CloseConnexion;
    procedure DataModuleCreate(Sender: TObject);
  private
    criticalEvent: TCriticalSection;
    { Déclarations privées }
  public
    function NouvelleClef_evt: Integer;
    procedure InsertK_Evt(Clef, Table: Integer);
    procedure Commit_Evt;
    procedure EnterCritical;
    procedure ExitCritical;
    { Déclarations publiques }
  end;

var
  Dm_LaunchEvent: TDm_LaunchEvent;

procedure Event(Base: string; LeType: Integer; Ok: Boolean; Temps: Variant);

function GetEventInfos(Base: string; LeType: Integer): TEventHisto;

implementation

{$R *.dfm}

procedure TDm_LaunchEvent.DataModuleCreate(Sender: TObject);
begin
  criticalEvent := TCriticalSection.Create;
end;

procedure TDm_LaunchEvent.DataModuleDestroy(Sender: TObject);
begin
  try
    if Data_Evt.Connected then
      Data_Evt.Close;
  except

  end;

  criticalEvent.Enter;
  try
    criticalEvent.Leave;
  finally
    criticalEvent.Free;
  end;
end;

procedure TDm_LaunchEvent.Data_EvtBeforeConnect(Sender: TObject);
begin
  if MapGinkoia.Backup then
    ABORT;
end;

procedure TDm_LaunchEvent.EnterCritical();
begin
  criticalEvent.Enter;
end;

procedure TDm_LaunchEvent.ExitCritical();
begin
  criticalEvent.Leave;
end;

procedure TDm_LaunchEvent.CloseOpenConnexion();
begin
  criticalEvent.Enter;
  try
    Data_Evt.Close;
    Data_Evt.Connected := false;
    tran_evt.Active := false;
    Ib_Event.Active := false;
    Ib_Event.Close;

    Data_Evt.Open;
    Data_Evt.DefaultTransaction := tran_evt;
    //tran_evt.Active := True;
    tran_evt.StartTransaction;
    Ib_Event.Transaction := tran_evt;
    Ib_Event.Open;
    Ib_Event.Active := true;
  finally
    // fin section critique
    criticalEvent.Leave;
  end;
end;

procedure TDm_LaunchEvent.CloseConnexion();
var
  test: Boolean;
begin
  criticalEvent.Enter;
  try
    try
      Data_Evt.Close;
      Data_Evt.Connected := false;
      tran_evt.Active := false;
      Ib_Event.Active := false;
      Ib_Event.Close;
    except

    end;
  finally
    // fin section critique
    criticalEvent.Leave;
  end;
end;

function GetEventInfos(Base: string; LeType: Integer): TEventHisto;
var
  connection: Boolean;
  BasId: Integer;
begin
  Dm_LaunchEvent.criticalEvent.Enter;
  try
    Result.getInfosSuccess := true;

    if not MapGinkoia.Backup then
    begin
      if LaBase0 <> '' then
      begin
        with Dm_LaunchEvent do
        begin
          try
            connection := Data_Evt.Connected;
            try
              if not connection then
              begin
                Data_Evt.DatabaseName := LaBase0;
                try
                  Data_Evt.Open;
                except
                  LogFile.Log('Problème d''accès à la base Event', uLogFile.logWarning, 'LaunchEvent');
                  //RAISE;
                  Result.getInfosSuccess := false;
                end;
              end;

              IBStProc_BaseID.Prepare;
              IBStProc_BaseID.ExecProc;
              BasId := IBStProc_BaseID.ParamByName('BAS_ID').AsInteger;
              IBStProc_BaseID.UnPrepare;
              IBStProc_BaseID.Close;

              Log.Log('LaunchEvent_Dm', 'GetEventInfos', 'Log', 'select GENHISTOEVT (avant).', logDebug, True, 0, ltLocal);
              with Ib_Event do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Select HEV_DATE, HEV_MODULE, HEV_BASE, HEV_RESULT, HEV_TEMPS FROM GENHISTOEVT');
                SQL.Add('  Join K on K_ID = HEV_ID and K_Enabled = 1');
                SQL.Add('Where HEV_TYPE = :PTYPE');
                SQL.Add('  And HEV_BASID = :PBASID');
                SQL.Add('  ORDER BY HEV_DATE DESC');
                ParamCheck := True;
                ParamByName('PTYPE').AsInteger := LeType;
                ParamByName('PBASID').AsInteger := BasId;
                Open;

                if not Ib_Event.Eof then
                begin
                  Result.HEV_DATE := FieldByName('HEV_DATE').AsDateTime;
                  Result.HEV_MODULE := FieldByName('HEV_MODULE').AsString;
                  Result.HEV_BASE := FieldByName('HEV_BASE').AsString;
                  Result.HEV_RESULT := FieldByName('HEV_RESULT').AsInteger;
                  Result.HEV_TEMPS := FieldByName('HEV_TEMPS').AsDateTime;
                  Result.IsEOF := False;
                end
                else
                begin
                  // si pas de ligne trouvée, on reset les valeurs pour ne pas afficher sur la tuile en cours les valeurs de la tuile précédente
                  Result.HEV_DATE := Now;
                  Result.HEV_MODULE := '';
                  Result.HEV_BASE := '';
                  Result.HEV_RESULT := 1;
                  Result.HEV_TEMPS := Now;
                  Result.IsEOF := true;
                end;
              end;
              Log.Log('LaunchEvent_Dm', 'GetEventInfos', 'Log', 'select GENHISTOEVT (après).', logDebug, True, 0, ltLocal);
            finally
  //            IF (NOT connection) AND (NOT RepliEnCours) THEN
                //Data_Evt.Close;
            end;
          except
            {$IFDEF DEBUG }
            //RAISE;
            {$ENDIF DEBUG }
          end;
        end;
      end;
    end
    else
      Result.getInfosSuccess := false;

  finally
    // fin section critique
    Dm_LaunchEvent.criticalEvent.Leave;
  end;

end;

// ---------------------------------------------------------------
// Ajout d'un evenement dans la table
// ---------------------------------------------------------------
procedure Event(Base: string; LeType: Integer; Ok: Boolean; Temps: Variant);
var
  connection: Boolean;
  Clef: Integer;
  Letemps: TDateTime;
  BasId: Integer;
begin
  Dm_LaunchEvent.CloseOpenConnexion();

  Dm_LaunchEvent.criticalEvent.Enter;
  try
    if not MapGinkoia.Backup then
    begin
      if LaBase0 <> '' then
      begin
        with Dm_LaunchEvent do
        begin
          try
            connection := Data_Evt.Connected;
            try
              if not connection then
              begin
                Data_Evt.DatabaseName := LaBase0;
                try
                  Data_Evt.Open;
                except
                  LogFile.Log('Problème d''accès à la base Event', uLogFile.logWarning, 'LaunchEvent');
                  raise;
                end;
  //              tran_evt.active := true;
                IBStProc_BaseID.Prepare;
                IBStProc_BaseID.ExecProc;
                BasId := IBStProc_BaseID.ParamByName('BAS_ID').AsInteger;
                IBStProc_BaseID.UnPrepare;
                IBStProc_BaseID.Close;
              end;

              if not tran_evt.InTransaction then
                tran_evt.StartTransaction;
              with Ib_Event do
              try
                Log.Log('LaunchEvent_Dm', 'Event', 'Log', 'execute procedure EVT_SETHISTO (avant).', logDebug, True, 0, ltLocal);

                Log.Log('LaunchEvent_Dm', 'Event', 'Log', 'Base : ' + Base + ' / Type : ' + IntToStr(LeType) + ' / BasId : ' + IntToStr(IdBase0) + ' / Result : ' + BoolToStr(Ok), logDebug, True, 0, ltLocal);

                Close;
                SQL.Clear;
                SQL.Add('EXECUTE PROCEDURE EVT_SETHISTO(:PDATE, :PMODULE, :PBASE, :PTYPE, :PRESULT, :PTEMPS, :PBASID)');
                ParamCheck := True;
                ParamByName('PDATE').AsDateTime := Now;
                ParamByName('PMODULE').AsString := '';
                ParamByName('PBASE').AsString := Base;
                ParamByName('PTYPE').AsInteger := LeType;
                if Ok then
                  ParamByName('PRESULT').AsInteger := 1
                else
                  ParamByName('PRESULT').AsInteger := 0;
                if Temps = null then
                  ParamByName('PTEMPS').Clear
                else
                  ParamByName('PTEMPS').AsDateTime := Temps;
                ParamByName('PBASID').AsInteger := IdBase0;
                ExecSQL;

                Log.Log('LaunchEvent_Dm', 'Event', 'Log', 'execute procedure EVT_SETHISTO (après).', logDebug, True, 0, ltLocal);

                case LeType of
                  CREPLICATIONOK:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Etat réplication : %s', [BoolToStr(Ok, True)]), logDebug, True, 0, ltLocal);
                  CLASTREPLIC:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Date dernière réplication : %s', [DateToStr(ParamByName('PDATE').AsDateTime)]), logDebug, True, 0, ltLocal);
                  CSYNCHROOK:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Etat Synchro : %s', [BoolToStr(Ok, True)]), logDebug, True, 0, ltLocal);
                  CLASTSYNC:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Date dernière synchro : %s', [DateToStr(ParamByName('PDATE').AsDateTime)]), logDebug, True, 0, ltLocal);
                  CWEBOK:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Etat réplication web : %s', [BoolToStr(Ok, True)]), logDebug, True, 0, ltLocal);
                  CLASTWEB:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Date dernière réplication Web : %s', [DateToStr(ParamByName('PDATE').AsDateTime)]), logDebug, True, 0, ltLocal);
                  CPFOK:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Etat réplication PF : %s', [BoolToStr(Ok, True)]), logDebug, True, 0, ltLocal);
                  CLASTPF:
                    Log.Log('LaunchEvent_Dm', 'Event', 'Log', Format('  - Date dernière réplication PF : %s', [DateToStr(ParamByName('PDATE').AsDateTime)]), logDebug, True, 0, ltLocal);
                end;

                tran_evt.Commit;
              except
                on E: Exception do
                begin
                  tran_evt.Rollback;
                  Log.Log('LaunchEvent_Dm', 'Event', 'Log', 'Exception : ' + E.Message, logError, True, 0, ltLocal);
                end;
              end;
  //            Clef                                       := NouvelleClef_evt;
  //            InsertK_Evt(Clef, CstTblEvent);
  //            Ib_Event.ParamByName('ID').AsInteger       := Clef;
  //            Ib_Event.ParamByName('BASE').AsString      := Base;
  //            Ib_Event.ParamByName('BASID').AsInteger    := IdBase0;
  //            Ib_Event.ParamByName('TYPE').AsInteger     := LeType;
  //            IF Ok THEN
  //              Ib_Event.ParamByName('RESULT').AsInteger := 1
  //            ELSE
  //              Ib_Event.ParamByName('RESULT').AsInteger := 0;
  //            IF Temps = Null THEN
  //              Ib_Event.ParamByName('TEMPS').Clear
  //            ELSE
  //            BEGIN
  //              Letemps                                  := Temps;
  //              Ib_Event.ParamByName('TEMPS').AsDateTime := Letemps;
  //            END;
  //            Ib_Event.ExecSQL;
  //            Commit_Evt;
            finally
  //            IF (NOT connection) AND (NOT RepliEnCours) THEN
                //Data_Evt.Close;
            end;
          except
            on E: Exception do
            begin
              LogFile.Log('Exception : ' + E.Message, uLogFile.logError, 'LaunchEvent');
            {$IFDEF DEBUG }
              raise;
            {$ENDIF DEBUG }
            end;
          end;
        end;
      end;
    end;
  finally
    Dm_LaunchEvent.criticalEvent.Leave;
  end;
end;

function TDm_LaunchEvent.NouvelleClef_evt: Integer;
begin
  Sp_NewKey_Evt.Prepare;
  Sp_NewKey_Evt.ExecProc;
  result := Sp_NewKey_Evt.ParamByName('NEWKEY').AsInteger;
  Sp_NewKey_Evt.UnPrepare;
  Sp_NewKey_Evt.Close;
end;

procedure TDm_LaunchEvent.InsertK_Evt(Clef, Table: Integer);
begin
  Log.Log('LaunchEvent_Dm', 'InsertK_Evt', 'Log', 'insert K (avant).', logDebug, True, 0, ltLocal);

  Ib_Divers_Evt.Sql.Clear;
  Ib_Divers_Evt.Sql.Add('Insert Into K');
  Ib_Divers_Evt.Sql.Add(' (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
  Ib_Divers_Evt.Sql.Add(' VALUES ');
  Ib_Divers_Evt.Sql.Add(' (' + Inttostr(Clef) + ',-101,' + Inttostr(Table) + ',' + Inttostr(Clef) + ',1,-1,-1,Current_Date,0,''01/01/1980'',-1,Current_Date,0,0)');
  Ib_Divers_Evt.ExecSQL;

  Log.Log('LaunchEvent_Dm', 'InsertK_Evt', 'Log', 'insert K (après).', logDebug, True, 0, ltLocal);
  Ib_Divers_Evt.Sql.Clear;
end;

procedure TDm_LaunchEvent.Commit_Evt;
begin
  try
    if tran_evt.InTransaction then
      tran_evt.Commit;
    tran_evt.active := true;
  except
    on E: EXception do
      raise Exception.Create('Commit_Evt :' + E.Message);
  end;
end;

end.


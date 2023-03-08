unit uThreadDB;

interface

Uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ComCtrls, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, System.Win.Registry,
  Vcl.ExtCtrls, Math, UWMI, System.IniFiles, System.DateUtils;

const
  C_HEARTBEATTIME = 16; // c'est toute les 15 minutes mais pour rester vert il faut mettre une minute de plus

  { CREPLICATIONOK = 2998;
    CLASTREPLIC    = 2999;



    CWEBOK         = 3002;
    CLASTWEB       = 3003;

    CPFOK          = 3004;
    CLASTPF        = 3005;
  }
  // CBACKRESTOK    = 3006 ;   // Ca c'est en fait le dernier résultat donc on a inversion avec noms des constantes du B/R !
  // CLASTBACKREST  = 3007 ;

  CBACKRESTOK = 3006;
  CLASTBACKREST = 3007;

  CBIOK = 3008;
  CLASTBI = 3009;


  CSYNCHROOK     = 3001;
  CLASTSYNC      = 3000;

Type
  EEasyNotInstalledError = class(Exception);

  TGENPARAM = record
    PRMTYPE: Integer;
    PRMCODE: Integer;
    PRMSTRING: string;
    PRMINTEGER: Integer;
    PRMFLOAT: double;
  public
    procedure Init;
  end;

  THistoEvent = record
    DATE: TDateTime;
    TUILE: string;
    LEVEL: Integer; // 0
    RESULT: Integer; // 0=ERREUR, 1='OK' ( TODO ==> 2='NE' attention en cours de test)
    TEMPS: TDateTime;
    Detail: string;
    HINT: string;
    LASTTENTATIVE: TDateTime;
  end;

  // Planif Time sert pour Verif, Backup et NettoieGinkoia
  TPlanifTime = record
    Prochain: TDateTime; // Date Heure du prochain
    Dernier: TDateTime; // Date Heure du dernier
    Tps: TTime; //
  end;

  TKInfos = record
    DATE: TDateTime;
    TUILE: string;
    TAUX: double;
    LEVEL: Integer;
    DETAIL: string;
  end;

  THistoEvents = Array of THistoEvent;

  TOptimzeDB = class(TThread)
    //
  end;







  TThreadDB = class(TThread)
  private
    { Déclarations privées }
    FDataCount    : integer;
    FOlddestBatchOk    : TDateTime;
    FOlddestBatchNotOk : TDateTime;
    FPARAM_11_60: TGENPARAM;
    FPARAM_81_1: TGENPARAM;
    FPARAM_60_1: TGENPARAM;
    FPARAM_60_3: TGENPARAM;
    FPARAM_60_6: TGENPARAM;
    FPARAM_60_8: TGENPARAM;
    FPARAM_3_36: TGENPARAM;
    FPARAM_9_414: TGENPARAM;

    FBI_INSTALLED: Boolean;
    FFirstPass: Boolean;
    FIBFILE: TFileName;
    FHisto: THistoEvents;
    FBackRest: TPlanifTime;
    FKInfos: TKInfos;
    FShutdown: Boolean;
    FGRANTprobleme: Boolean;
    FEasyNotInstalled: Boolean;
    FFailConnection: Boolean;
    FNode: string;
    FNODE_GROUP_ID : string;
    FGUID: string;
    FBASID: string;
    FIsBaseProd: Boolean;
    FSENDER: string;
    FBASNOMPOURNOUS: string;
    FBASMAGID: string;
    FVersionDB: string;
    FTriggerDiff : string;
    FLignesStock : integer;

    FBR_Visible     : Boolean;
    FOPTIM_Visible  : Boolean;
    FOPTIM_CRON_HR  : double;
    FRecalc_Stock   : Boolean;
    FSYNCHROOK       : TDateTime;
    FLASTSYNC        : TDateTime;
    FLASTSYNC_RESULT : integer;
    procedure UpdateVCL();
    procedure GetInfos();
    procedure AnalysePlage(Astring: string; aCURRENT_ID: Integer);
    function LancementAutomatique(aAUTORUN: Boolean): Boolean;
  protected
    { -- }
  public
    procedure Execute; override;
    constructor Create(CreateSuspended: Boolean; Const aFirstPass: Boolean = False; const AEvent: TNotifyEvent = nil); reintroduce;
    property IBFILE: TFileName read FIBFILE write FIBFILE;
    property Node          : string    read FNode;
    property NODE_GROUP_ID : string    read FNODE_GROUP_ID;
    property Datacount     : integer   read FDataCount;
    property OldestBatchOk    : TDateTime    read FOlddestBatchOk;
    property OldestBatchNotOk : TDateTime    read FOlddestBatchNotOk;

    property TriggerDiff   : string    read FTriggerDiff;
    property LignesStock   : integer   read FLignesStock;
    property BR_Visible    : Boolean   read FBR_Visible;
    property OPTIM_Visible : Boolean   read FOptim_Visible;
    property OPTIM_CRON_HR : double    read FOPTIM_CRON_HR;
    property Recalc_Stock  : Boolean   read FRecalc_Stock;
    property SYNCHROOK        : TDateTime  read FSYNCHROOK;
    property LASTSYNC         : TDateTime  read FLASTSYNC;
    property LASTSYNC_RESULT  : integer    read FLASTSYNC_RESULT;


  end;

implementation

Uses uDataMod, uMainForm, uLog;

{ ---------------------------- TGENPARAM ------------------------------------- }

procedure TGENPARAM.Init;
begin
  PRMTYPE := 0;
  PRMCODE := 0;
  PRMSTRING := '';
  PRMINTEGER := 0;
  PRMFLOAT   := 0;
end;

function TThreadDB.LancementAutomatique(aAUTORUN: Boolean): Boolean;
var
  reg: TRegistry;
begin
  // Vérification du lancement automatique
  TRY
    reg := TRegistry.Create(KEY_WRITE);
    TRY
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
      IF (aAUTORUN) then
      begin
        if (reg.ReadString('Launch_Replication') <> Application.exename) then
          reg.WriteString('Launch_Replication', Application.exename);
      end
      else
        reg.DeleteValue('Launch_Replication');
      RESULT := true;
    FINALLY
      reg.closekey;
      reg.free;
    END;
  EXCEPT
    RESULT := False;
  END;
end;

procedure TThreadDB.UpdateVCL();
var
  i: Integer;
  vDeltaWidth: Integer;
begin
  if FShutdown then
  begin
    Frm_Launcher.EventPanel[CID_BACKREST].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_BACKREST].DETAIL := 'Database Shutdown';
    Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].DETAIL := 'Database Shutdown';
    Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_HEARTBEAT].DETAIL := 'Database Shutdown';
    Frm_Launcher.EventPanel[CID_PLAGEK].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_PLAGEK].DETAIL := 'Database Shutdown';
    Frm_Launcher.sbar.Panels[0].Text := VGSE.Base0 + ' [shutdown]';
    exit;
  end;

  If (FFailConnection) then
  begin
    Frm_Launcher.EventPanel[CID_BACKREST].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_BACKREST].DETAIL := 'Pb INTERBASE';
    Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].DETAIL := 'Pb INTERBASE';
    Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_HEARTBEAT].DETAIL := 'Pb INTERBASE';
    Frm_Launcher.EventPanel[CID_PLAGEK].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_PLAGEK].DETAIL := 'Pb INTERBASE';
    Frm_Launcher.sbar.Panels[0].Text := VGSE.Base0 + ' [Problème Connection INTERBASE]';
    exit;
  end;
  if FGRANTprobleme then
  begin
    Frm_Launcher.EventPanel[CID_BACKREST].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_BACKREST].DETAIL := 'Droits GINKOIA';
    Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].DETAIL := 'Droits GINKOIA';
    Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_HEARTBEAT].DETAIL := 'Droits GINKOIA';
    Frm_Launcher.EventPanel[CID_PLAGEK].LEVEL := logEmergency;
    Frm_Launcher.EventPanel[CID_PLAGEK].DETAIL := 'Droits GINKOIA';
    Frm_Launcher.sbar.Panels[0].Text := VGSE.Base0 + ' [Problèmes de Droits pour GINKOIA]';
    exit;
  end;

  // Debug
  // FBackRest.Prochain := Date + EncodeTime(16,0,0,0);
  Frm_Launcher.BackupTime := FBackRest;

  if FFirstPass then
  begin
    Frm_Launcher.BasGUID := FGUID;
    Frm_Launcher.BASID := FBASID;
    Frm_Launcher.IsBaseProd := FIsBaseProd;
    Frm_Launcher.BASMAGID := FBASMAGID;
    Frm_Launcher.Caption := Format('%s • %s • %s', [Frm_Launcher.HINT, FNode, FGUID]);
    Frm_Launcher.PARAM_11_60 := FPARAM_11_60;
    Frm_Launcher.PARAM_81_1 := FPARAM_81_1;
    Frm_Launcher.PARAM_60_1 := FPARAM_60_1;
    Frm_Launcher.PARAM_60_3 := FPARAM_60_3;
    Frm_Launcher.PARAM_60_6 := FPARAM_60_6;
    Frm_Launcher.PARAM_60_8 := FPARAM_60_8;
    Frm_Launcher.PARAM_3_36 := FPARAM_3_36;
    Frm_Launcher.PARAM_9_414 := FPARAM_9_414;

    if FPARAM_81_1.PRMINTEGER = 1 then
      Frm_Launcher.EventPanel[CID_CGT].visible := true;
    // GR Hack pour le voir..
    // Frm_Launcher.eventPanel[CID_CGT].visible:=true;

    Frm_Launcher.BasNOMPOURNOUS := FBASNOMPOURNOUS;
    // --------------------------------------------------------------------

    Frm_Launcher.VersionDB := FVersionDB;
    // si on est en version supérieure (Cloture de Grands Totaux)
    // if FVersionDB>CST_CGTMinVersion
    // then Frm_Launcher.eventPanel[CID_CGT].visible:=true;

  end;
  Frm_Launcher.EventPanel[CID_PLAGEK].LEVEL := TLogLevel(FKInfos.LEVEL);
  Frm_Launcher.EventPanel[CID_PLAGEK].DETAIL := FKInfos.DETAIL;

  for i := 0 to Length(FHisto) - 1 do
  begin
    Frm_Launcher.sbar.Panels[0].Text := VGSE.Base0 + ' [ok]';
    if VGSE.AttentionBase0 then
      Frm_Launcher.sbar.Panels[0].Text := Frm_Launcher.sbar.Panels[0].Text + ' [Attention Base0]';

    if FHisto[i].TUILE = 'BACKUP_RESTORE' then
    begin
      Frm_Launcher.EventPanel[CID_BACKREST].InfoValue1 := DateTimeToIso8601(FHisto[0].DATE);

      Frm_Launcher.EventPanel[CID_BACKREST].HINT := FHisto[i].HINT + #13 + #10 + 'Prochain : ' + FormatDateTime('dd/mm/yyyy hh:nn', FBackRest.Prochain);

      If (FHisto[i].DATE + 2 < Now()) then
        Frm_Launcher.EventPanel[CID_BACKREST].LEVEL := logError
      else if (FHisto[i].DATE + 1 < Now()) then
        Frm_Launcher.EventPanel[CID_BACKREST].LEVEL := logWarning
      else
        Frm_Launcher.EventPanel[CID_BACKREST].LEVEL := logInfo;

      // If (FHisto[i].RESULT = 1) and (FHisto[i].DATE > 1) then
      // Frm_Launcher.EventPanel[CID_BACKREST].DETAIL := FormatDateTime('dd/mm/yyyy hh:nn', FHisto[i].DATE)
      // else
      // Frm_Launcher.EventPanel[CID_BACKREST].DETAIL := ' ';

      // on affiche toujours la date du dernier backup réussi
      Frm_Launcher.EventPanel[CID_BACKREST].DETAIL := FormatDateTime('dd/mm/yyyy hh:nn', FHisto[i].DATE)
    end;

    if (Frm_Launcher.EventPanel[CID_BI].visible) and (FHisto[i].TUILE = 'BI') then
    begin
      Frm_Launcher.EventPanel[CID_BI].HINT := '';
      If (FHisto[i].RESULT = 1) then
        Frm_Launcher.EventPanel[CID_BI].HINT := 'Dernier réussi : ' + FormatDateTime('dd/mm/yyyy hh:nn', FHisto[i].DATE);

      If (FHisto[i].DATE + 1 < Now()) then
        Frm_Launcher.EventPanel[CID_BI].LEVEL := logWarning
      else
        Frm_Launcher.EventPanel[CID_BI].LEVEL := logInfo;

      If (FHisto[i].RESULT = 1) and (FHisto[i].DATE > 1) then
        Frm_Launcher.EventPanel[CID_BI].DETAIL := FormatDateTime('dd/mm/yyyy hh:nn', FHisto[i].DATE)
      else
        Frm_Launcher.EventPanel[CID_BI].DETAIL := ' ';

      Frm_Launcher.EventPanel[CID_BI].InfoValue1 := DateTimeToIso8601(FHisto[i].DATE);
      Frm_Launcher.EventPanel[CID_BI].InfoValue2 := DateTimeToIso8601(FHisto[i].LASTTENTATIVE);
    end;

    if FHisto[i].TUILE = 'LAST_HEARTBEAT' then
    begin
      case FHisto[i].LEVEL of
        6:
          Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logError;
        5:
          Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logWarning;
        4:
          Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logNotice;
        3:
          Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logInfo;
      else
        Frm_Launcher.EventPanel[CID_HEARTBEAT].LEVEL := logEmergency;
      end;
      if FHisto[i].DATE > 0 then
      begin
        Frm_Launcher.EventPanel[CID_HEARTBEAT].DETAIL     := FHisto[i].Detail;
        Frm_Launcher.EventPanel[CID_HEARTBEAT].InfoValue1 := DateTimeToIso8601(FHisto[i].DATE);
      end
      else
      begin
        Frm_Launcher.EventPanel[CID_HEARTBEAT].DETAIL := ' ';
        Frm_Launcher.EventPanel[CID_HEARTBEAT].InfoValue1 := '';
      end;
    end;

    if FHisto[i].TUILE = 'LAST_REPLIC' then
    begin
      // on ne regarde plus le RESULT on le LEVEL
      case FHisto[i].LEVEL of
        6:
          Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logError;
        5:
          Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logWarning;
        4:
          Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logNotice;
        3:
          Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logInfo;
      else
        Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].LEVEL := logEmergency;
      end;
      {
        If (FHisto[i].RESULT=0)
        then Frm_Launcher.EventPanel[CID_REPLICATION].Level  := logWarning
        else Frm_Launcher.EventPanel[CID_REPLICATION].Level  := logInfo;
      }
      Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].HINT := FHisto[i].HINT;
      Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].InfoValue1 := DateTimeToIso8601(FHisto[i].DATE);

      { c'est fait dans le CallBack.... c'est pas thread Save ce truc...
      if FHisto[i].DATE > 0 then
      begin
        Frm_Launcher.EventPanel[CID_REPLICATION].DETAIL := FormatDateTime('dd/mm/yyyy hh:nn', FHisto[i].DATE);
        Frm_Launcher.EventPanel[CID_REPLICATION].InfoValue1 := DateTimeToIso8601(FHisto[i].DATE);
      end
      else
      begin
        Frm_Launcher.EventPanel[CID_REPLICATION].DETAIL := ' ';
        Frm_Launcher.EventPanel[CID_REPLICATION].InfoValue1 := '';
      end;
      }
    end;
  end;

  { Frm_GestionDatabase.StatusBar.Panels[0].text:=FStatus;
    Frm_GestionDatabase.StatusBar.Refresh;

    Frm_GestionDatabase.ProgressBar.Position:=FProgression;
    Frm_GestionDatabase.ProgressBar.Refresh;
  }
end;

procedure TThreadDB.AnalysePlage(Astring: string; aCURRENT_ID: Integer);
var
  tmp: string;
  i: Integer;
  vDebut, vFin: Integer;
begin
  FKInfos.DATE := Now();
  FKInfos.TUILE := 'K';
  FKInfos.TAUX := -1;
  FKInfos.LEVEL := 6; // Erreur
  FKInfos.DETAIL := '';
  try
    tmp := Astring;
    tmp := Copy(tmp, 2, Length(tmp) - 3);
    i := Pos('M_', tmp);
    vDebut := StrToIntDef(Copy(tmp, 0, i - 1), 0) * 1000000;
    vFin := StrToIntDef(Copy(tmp, i + 2, Length(tmp)), 0) * 1000000;
    vFin := vFin - 1;

    if (vFin - vDebut) <> 0 then
      FKInfos.TAUX := ((aCURRENT_ID - vDebut) / (vFin - vDebut)) * 100;

    if (FKInfos.TAUX >= 95) then
    begin
      Log.Log('Main', FGUID, 'PlageKLauncher', 'Attention : La plage de K est presque pleine : ' + FloatToStr(RoundTo(FKInfos.TAUX, -2)) + '%', logError, true,
        0, ltBoth);
      FKInfos.LEVEL := 6;
    end;

    if (FKInfos.TAUX < 95) then
    begin
      Log.Log('Main', FGUID, 'PlageKLauncher', 'Plage de k utilisée à  : ' + FloatToStr(RoundTo(FKInfos.TAUX, -2)) + '%', logNotice, true, 0, ltBoth);
      FKInfos.LEVEL := 5;
    end;

    if (FKInfos.TAUX < 90) then
    begin
      Log.Log('Main', FGUID, 'PlageKLauncher', 'Plage de k utilisée à  : ' + FloatToStr(RoundTo(FKInfos.TAUX, -2)) + '%', logInfo, true, 0, ltBoth);
      FKInfos.LEVEL := 3;
    end;

    FKInfos.DETAIL := Format('%.2f %%', [FKInfos.TAUX]);

  Except
    // rien
  end;
end;

procedure TThreadDB.GetInfos();
var
  vQuery: TFDQuery;
  vBASID: Integer;
  vBASNOM: string;
  vBASPLAGE: string;
  vBASSENDER: string;
  vBASGUID: string;
  vBASMAGID: string;
  vBASNOMPOURNOUS: string;
  vAutoRun: Boolean;
  vHint: string;
  vDATE: TDateTime;
  vNbSymTrig: Integer;
  vNbSymTrigAttendu: Integer;
  vMAX_START_ID      : Largeint;
  vSautLigne  : string;

begin
  if IBFILE = '' then
    exit;
  vBASID := 0;
  vQuery := TFDQuery.Create(nil);
  try
    try
      // Construction des Tuiles
      SetLength(FHisto, 4);
      FHisto[0].TUILE := 'BACKUP_RESTORE';

      FHisto[1].TUILE := 'BI';

      FHisto[2].TUILE := 'LAST_HEARTBEAT';
      FHisto[3].TUILE := 'LAST_REPLIC';

      DataMod.FDcon.Params.Database := IBFILE;
      vQuery.Connection := DataMod.FDcon;
      vQuery.Transaction := DataMod.FDtrans;
      vQuery.Transaction.Options.ReadOnly := true;
      vQuery.Close;

      // Recup du type de base pour savoir si on est en bien en base de prod
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT PAR_FLOAT FROM GENPARAMBASE');
      vQuery.SQL.Add('WHERE PAR_NOM=''BASETYPE'' AND PAR_FLOAT = 1');
      vQuery.Open();
      FIsBaseProd := False;
      If (vQuery.RecordCount = 1) then
      begin
        FIsBaseProd := true;
      end;

      // Recup du BAS_ID (on en a besoin pour GENHISTOEVT)
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_NOMPOURNOUS, BAS_MAGID FROM GENPARAMBASE        ');
      vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
      vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
      vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        vBASID := vQuery.FieldByName('BAS_ID').Asinteger;
        vBASNOM := vQuery.FieldByName('BAS_NOM').Asstring;
        vBASPLAGE := vQuery.FieldByName('BAS_PLAGE').Asstring;
        vBASSENDER := vQuery.FieldByName('BAS_SENDER').Asstring;
        vBASGUID := vQuery.FieldByName('BAS_GUID').Asstring;
        vBASNOMPOURNOUS := vQuery.FieldByName('BAS_NOMPOURNOUS').Asstring;
        vBASMAGID := vQuery.FieldByName('BAS_MAGID').Asstring;

        FSENDER := vBASSENDER;
        FBASNOMPOURNOUS := vBASNOMPOURNOUS;
        FGUID := vBASGUID;
        FBASID := vQuery.FieldByName('BAS_ID').Asstring;;
        FBASMAGID := vBASMAGID;
      end;

      // Ou est GENERAL_ID
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        AnalysePlage(vBASPLAGE, vQuery.Fields[0].Asinteger);
      end;

      // Recup de l'Horaire du Backup (attention ce n'est pas LAU_HEURE1 mais LAU_BACKTIME
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GenLaunch ');
      vQuery.SQL.Add('Join k on (K_ID = LAU_ID and K_Enabled=1) ');
      vQuery.SQL.Add('  WHERE LAU_BASID=:BASID');
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        if vQuery.FieldByName('LAU_BACK').Asinteger = 1 then
          FBackRest.Prochain := DATE + Frac(vQuery.FieldByName('LAU_BACKTIME').AsDateTime);

        // Reprogrammation du Prochain uniquement si on dépasse les 5 minutes -------
        If (FBackRest.Prochain + 5 / MinsPerDay < Now()) then
        begin
          FBackRest.Prochain := FBackRest.Prochain + 1;
        end;

        vAutoRun := vQuery.FieldByName('LAU_AUTORUN').Asinteger = 1;

        // LancementAutomatique(vAutoRun);
        LancementAutomatique(true); // il faut toujours que ca tourne ==> TRUE
      end;

      // ----------------------------------------------------------------------
      {
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT COUNT(*) FROM RDB$TRIGGERS WHERE RDB$SYSTEM_FLAG=0 AND RDB$TRIGGER_NAME LIKE ''SYM_%'' AND RDB$RELATION_NAME NOT LIKE ''SYM_%''');
        vQuery.Open();
        If (vQuery.RecordCount=1) then
        begin
        vNbSymTrig := vQuery.Fields[0].AsInteger;
        end;

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT SUM(SYNC_ON_INSERT)+SUM(SYNC_ON_UPDATE)+SUM(SYNC_ON_DELETE) FROM SYM_TRIGGER');
        vQuery.Open();
        If (vQuery.RecordCount=1) then
        begin
        vNbSymTrigAttendu := vQuery.Fields[0].AsInteger;
        end;
      }

      if FFirstPass then
      begin
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 11 AND PRM_CODE = 60    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_11_60.PRMTYPE := 11;
          FPARAM_11_60.PRMCODE := 60;
          FPARAM_11_60.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_11_60.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 81 AND PRM_CODE = 1    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_81_1.PRMTYPE := 81;
          FPARAM_81_1.PRMCODE := 1;
          FPARAM_81_1.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_81_1.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 60 AND PRM_CODE = 1    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_60_1.PRMTYPE := 60;
          FPARAM_60_1.PRMCODE := 1;
          FPARAM_60_1.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_60_1.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 60 AND PRM_CODE = 3    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_60_3.PRMTYPE := 60;
          FPARAM_60_3.PRMCODE := 3;
          FPARAM_60_3.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_60_3.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 60 AND PRM_CODE = 8    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_60_8.PRMTYPE := 60;
          FPARAM_60_8.PRMCODE := 8;
          FPARAM_60_8.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_60_8.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 60 AND PRM_CODE = 6    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_60_6.PRMTYPE := 60;
          FPARAM_60_6.PRMCODE := 6;
          FPARAM_60_6.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_60_6.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 3 AND PRM_CODE = 36    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_3_36.PRMTYPE := 3;
          FPARAM_3_36.PRMCODE := 36;
          FPARAM_3_36.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_3_36.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
        vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
        vQuery.SQL.Add(' WHERE PRM_TYPE = 9 AND PRM_CODE = 414    ');
        vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          FPARAM_9_414.PRMTYPE := 9;
          FPARAM_9_414.PRMCODE := 414;
          FPARAM_9_414.PRMSTRING := vQuery.FieldByName('PRM_STRING').Asstring;
          FPARAM_9_414.PRMINTEGER := vQuery.FieldByName('PRM_INTEGER').Asinteger;
        end;
        vQuery.Close();

        FBI_INSTALLED := False;
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT COUNT(prmmag.PRM_ID) AS NB FROM GENPARAM prmmag ');
        vQuery.SQL.Add('JOIN K ON K_ID = prmmag.PRM_ID AND K_ENABLED=1   ');
        vQuery.SQL.Add('JOIN genparam prmbase on prmbase.PRM_MAGID = prmmag.PRM_MAGID ');
        vQuery.SQL.Add('JOIN K ON K_ID = prmbase.PRM_ID AND K_ENABLED=1   ');
        vQuery.SQL.Add('WHERE prmbase.prm_integer = :BASID                ');
        vQuery.SQL.Add('AND prmbase.PRM_TYPE=25 AND prmbase.PRM_CODE=2    ');
        vQuery.SQL.Add('AND prmmag.PRM_TYPE=25 AND prmmag.PRM_CODE=1      ');
        vQuery.SQL.Add('AND prmmag.PRM_INTEGER = 1                        ');
        vQuery.ParamByName('BASID').Asinteger := vBASID;
        vQuery.Open();
        If not(vQuery.IsEmpty) then
        begin
          FBI_INSTALLED := vQuery.FieldByName('NB').Asinteger > 0;
        end;
        vQuery.Close();

        // Version de la base typequement 16.1.0.9999
        FVersionDB := '';
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT VER_VERSION FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
        vQuery.Open();
        vQuery.Open();
        If not(vQuery.IsEmpty) then
        begin
          FVersionDB := vQuery.FieldByName('VER_VERSION').Asstring;
        end;
        vQuery.Close();

      end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT PRM_INTEGER ');
      vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
      vQuery.SQL.Add(' WHERE PRM_TYPE = 80 AND PRM_CODE = 5    ');
      vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();

      // Si ce paramètre n'existe pas il faut quand meme que ca soit visible
      If (vQuery.RecordCount = 1)
        then FBR_Visible := vQuery.FieldByName('PRM_INTEGER').Asinteger=1
        else FBR_Visible := true;
      vQuery.Close();

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT ');
      vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
      vQuery.SQL.Add(' WHERE PRM_TYPE = 80 AND PRM_CODE = 6    ');
      vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
        begin
          FOPTIM_Visible  := vQuery.FieldByName('PRM_INTEGER').Asinteger=1;
          FOPTIM_CRON_HR  := vQuery.FieldByName('PRM_FLOAT').Asfloat;
        end
      else
        begin
          FOPTIM_Visible  := false;
          FOPTIM_CRON_HR  := 24;
        end;

      vQuery.Close();

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT PRM_INTEGER ');
      vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
      vQuery.SQL.Add(' WHERE PRM_TYPE = 80 AND PRM_CODE = 7    ');
      vQuery.SQL.Add('     AND PRM_POS = :BASID                ');
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();
      If (vQuery.RecordCount = 1)
        then
          begin
             FRecalc_Stock := vQuery.FieldByName('PRM_INTEGER').Asinteger=1;
          end
        else FRecalc_Stock := false;
      vQuery.Close();

      // ---------------------- 3000,3001,
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT HEV_DATE, HEV_MODULE, HEV_BASE, HEV_RESULT, HEV_TYPE, HEV_TEMPS FROM GENHISTOEVT ');
      vQuery.SQL.Add('  JOIN K ON K_ID = HEV_ID and K_ENABLED = 1 ');
      vQuery.SQL.Add('  WHERE HEV_TYPE=:TYPE AND HEV_BASID=:BASID');
      vQuery.SQL.Add('  ORDER BY HEV_DATE DESC');
      vQuery.ParamByName('TYPE').Asinteger := CSYNCHROOK;
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();
     if not(vQuery.eof) then
        begin
          FSYNCHROOK := vQuery.FieldByName('HEV_DATE').AsDateTime;
        end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT HEV_DATE, HEV_MODULE, HEV_BASE, HEV_RESULT, HEV_TYPE, HEV_TEMPS FROM GENHISTOEVT ');
      vQuery.SQL.Add('  JOIN K ON K_ID = HEV_ID and K_ENABLED = 1 ');
      vQuery.SQL.Add('  WHERE HEV_TYPE=:TYPE AND HEV_BASID=:BASID');
      vQuery.SQL.Add('  ORDER BY HEV_DATE DESC');
      vQuery.ParamByName('TYPE').Asinteger := CLASTSYNC;
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();
      If not(vQuery.eof) then
        begin
          FLASTSYNC := vQuery.FieldByName('HEV_DATE').AsDateTime;
          FLASTSYNC_RESULT := vQuery.FieldByName('HEV_RESULT').Asinteger;
        end;

      // Dernier backup restore réussi
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT HEV_DATE, HEV_MODULE, HEV_BASE, HEV_RESULT, HEV_TYPE, HEV_TEMPS FROM GENHISTOEVT ');
      vQuery.SQL.Add('  JOIN K ON K_ID = HEV_ID and K_ENABLED = 1 ');
      vQuery.SQL.Add('  WHERE HEV_TYPE IN (3006,3007,3008,3009) AND HEV_BASID=:BASID');
      vQuery.SQL.Add('  ORDER BY HEV_TYPE ASC, HEV_DATE DESC');
      vQuery.ParamByName('BASID').Asinteger := vBASID;
      vQuery.Open();
      while not(vQuery.eof) do
      begin
        if (vQuery.FieldByName('HEV_TYPE').Asinteger = CBACKRESTOK) or (vQuery.FieldByName('HEV_TYPE').Asinteger = CLASTBACKREST) then
        begin
          // Dernier résultat/Tentative
          If (vQuery.FieldByName('HEV_TYPE').Asinteger = CBACKRESTOK) // 3006
          then
          begin
            FHisto[0].HINT := 'Dernière Tentative : ' + FormatDateTime('dd/mm/yyy hh:nn', vQuery.FieldByName('HEV_DATE').AsDateTime);
            FHisto[0].DATE := vQuery.FieldByName('HEV_DATE').AsDateTime;
            FHisto[0].RESULT := vQuery.FieldByName('HEV_RESULT').Asinteger;
            FHisto[0].TEMPS := vQuery.FieldByName('HEV_TEMPS').AsDateTime;
          end;
          // Dernier OK
          if (vQuery.FieldByName('HEV_TYPE').Asinteger = CLASTBACKREST) then
          begin
            FHisto[0].HINT := FHisto[0].HINT + #13 + #10 + 'Dernier Réussi : ' + FormatDateTime('dd/mm/yyy hh:nn', vQuery.FieldByName('HEV_DATE').AsDateTime);
            FHisto[0].DATE := vQuery.FieldByName('HEV_DATE').AsDateTime;
            FHisto[0].TEMPS := vQuery.FieldByName('HEV_TEMPS').AsDateTime;
          end;
        end;

        if vQuery.FieldByName('HEV_TYPE').Asinteger = CBIOK then
        begin
          FHisto[1].DATE := vQuery.FieldByName('HEV_DATE').AsDateTime;
          FHisto[1].RESULT := vQuery.FieldByName('HEV_RESULT').Asinteger;
          FHisto[1].TEMPS := vQuery.FieldByName('HEV_TEMPS').AsDateTime;
        end;

        if vQuery.FieldByName('HEV_TYPE').Asinteger = CLASTBI then
        begin
          FHisto[1].LASTTENTATIVE := vQuery.FieldByName('HEV_DATE').AsDateTime;
        end;

        vQuery.Next;
      end;

      // Est-ce que EASY est installé ? -------------------------------------
      // C'est dommage d'effectuer cette requete à chaque fois....
      // ==> on passe en FirstPass pour economie de transaction
      if FFirstPass then
      begin
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS ');
        vQuery.SQL.Add(' WHERE RDB$RELATION_NAME = :TABLENAME       ');
        vQuery.ParamByName('TABLENAME').Asstring := 'SYM_NODE_IDENTITY';
        vQuery.Open();
        if vQuery.RecordCount = 0 then
        begin
          raise EEasyNotInstalledError.Create('Easy n''est pas installé sur la Base');
        end;

        // C'est dommage d'effectuer cette requete à chaque fois....
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT N.NODE_ID, N.NODE_GROUP_ID FROM SYM_NODE_IDENTITY I ');
        vQuery.SQL.Add('JOIN SYM_NODE N ON N.NODE_ID=I.NODE_ID ');
        vQuery.Open();
        if vQuery.RecordCount = 1 then
        begin
          FNode := vQuery.FieldByName('NODE_ID').Asstring;
          FNODE_GROUP_ID := vQuery.FieldByName('NODE_GROUP_ID').Asstring;
        end;

      end;

      // Stock
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT GEN_ID(GENTRIGGER,0) FROM RDB$DATABASE');
      vQuery.Open();
      FTriggerDiff := 'Calcul Temps Réel';
      if not(vQuery.eof) then
        begin
           If vQuery.Fields[0].AsInteger = 1
             then FTriggerDiff := 'Calcul Différé'
             else FTriggerDiff := 'Calcul Temps Réel';
        end;


      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT COUNT(*) FROM GENTRIGGERDIFF WHERE TRI_ID<>0');
      vQuery.Open();
      FLignesStock := 0;
      if not(vQuery.eof) then
        begin
           FLignesStock := vQuery.Fields[0].AsInteger;
        end;

      vQuery.Close;
      // HeartBeat
      {
      // Ancienne technique
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT BATCH_ID, CHANNEL_ID, LAST_UPDATE_TIME, STATUS, BYTE_COUNT, NODE_ID ');
      vQuery.SQL.Add(' FROM SYM_OUTGOING_BATCH WHERE CHANNEL_ID=''heartbeat'' ORDER BY BATCH_ID DESC ROWS 1');
      vQuery.Open();
      if vQuery.RecordCount = 1 then
      begin
        FHisto[2].DATE := vQuery.FieldByName('LAST_UPDATE_TIME').AsDateTime;

        FHisto[2].LEVEL := 5; // Sinon Warning

        If vQuery.FieldByName('STATUS').Asstring = 'ER' then
          FHisto[2].LEVEL := 6; // Erreur

        If vQuery.FieldByName('STATUS').Asstring = 'NE' then
          FHisto[2].LEVEL := 4; // Erreur

        If (vQuery.FieldByName('STATUS').Asstring = 'OK') and (FHisto[2].DATE + C_HEARTBEATTIME / MinsPerDay > Now()) then
          FHisto[2].LEVEL := 3;

        If (FHisto[2].DATE + 12 / 24 < Now()) then
          FHisto[2].LEVEL := 6;
      end;
      }
      // HeartBeat
      vQuery.Close;
      vQuery.SQL.Clear();

      // vQuery.SQL.Add('SELECT NODE_ID, MAX(HEARTBEAT_TIME) AS HEARTBEAT_TIME FROM SYM_NODE_HOST ');
      // vQuery.SQL.Add('GROUP BY NODE_ID');
      // vQuery.SQL.Add('ORDER BY NODE_ID');

      vQuery.SQL.Add('SELECT N.NODE_ID, MAX(H.HEARTBEAT_TIME) AS HEARTBEAT_TIME FROM ');
      vQuery.SQL.Add('SYM_NODE N LEFT JOIN SYM_NODE_HOST H ON H.NODE_ID=N.NODE_ID    ');
      vQuery.SQL.Add('GROUP BY N.NODE_ID  ');
      vQuery.SQL.Add('ORDER BY N.NODE_ID  ');

      vQuery.Open();
      FHisto[2].LEVEL := 3;
      FHisto[2].Detail := '';
      vSautLigne := '';
      While not(vQuery.Eof) do
      begin
        if not(vQuery.FieldByName('HEARTBEAT_TIME').IsNull) then
          begin
            FHisto[2].DATE := vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime;
            if (vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime + C_HEARTBEATTIME / MinsPerDay < Now())
              then FHisto[2].LEVEL := 5;

            FHisto[2].Detail := FHisto[2].Detail + vSautLigne +
                  FormatDateTime('dd/mm/yyyy hh:nn',vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime);

            vSautLigne := #13+#10;
          end;
        vQuery.next;
      end;

      // lorsqu'il y a de gros transfert la tuille reste en Notice longtemps car le dernier paquet reste en "NE"
      // Le Hint ne refete pas non plus correctement son statut
      // il faudrait faire autrement... pour le push et le pull

      // Par defaut
      FHisto[3].LEVEL := 3;
      FHisto[3].HINT := '';

      // Si EASY Arrêté il peut y avoir des données non routées
      // c'est l'indicateur essentiel pour savoir si c'est remonté
      {
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT GEN_ID(GEN_SYM_DATA_DATA_ID,0) FROM RDB$DATABASE');
      if not(vQuery.eof) then
      begin
        vLAST_DATA_DATA_ID := vQuery.Fields[0].AsLargeint;
      end;
      }

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT MAX(START_ID) FROM SYM_DATA_GAP WHERE END_ID>START_ID');
      vQuery.Open();
      vMAX_START_ID := 0;
      If not(vQuery.Eof) then
        begin
           vMAX_START_ID := vQuery.Fields[0].AsLargeint;
           vQuery.Next;
        end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT COUNT(*) FROM SYM_DATA WHERE DATA_ID>=:START_ID AND SOURCE_NODE_ID IS NULL');
      vQuery.ParamByName('START_ID').AsLargeInt :=  vMAX_START_ID;
      vQuery.Open();
      if not(vQuery.eof) then
      begin
        FDatacount  :=  vQuery.Fields[0].AsLargeint;
      end;

      Case FDatacount of
        0 : FHisto[3].HINT := 'Toutes les lignes ont été routées';
        1 : FHisto[3].HINT := Format(' %d ligne non routée ', [FDatacount]);
      else
        FHisto[3].HINT := Format(' %d lignes non routées ', [FDatacount])
      End;


      // Par defaut level 6 Erreur
      FHisto[3].LEVEL := 6;

      // moins de 1000 (c'est attention)
      if (FDatacount div 1000 < 1)
        then FHisto[3].LEVEL := 5;

      // moins de 100 (c'est "en cours")
      if (FDatacount div 100 < 1)
        then FHisto[3].LEVEL := 4;

      if (FDatacount = 0 )
        then FHisto[3].LEVEL := 3;


      // Mettre le dernier OK
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT BATCH_ID, LAST_UPDATE_TIME, DATA_EVENT_COUNT ');
      vQuery.SQL.Add('FROM SYM_OUTGOING_BATCH WHERE CHANNEL_ID=''default'' AND NODE_ID<>''-1'' ');
      vQuery.SQL.Add('AND STATUS=''OK'' ');
      vQuery.SQL.Add('ORDER BY LAST_UPDATE_TIME DESC ');
      vQuery.SQL.Add('ROWS 1 ');
      vQuery.Open();
      if vQuery.RecordCount = 1 then
      begin
        FHisto[3].DATE  := vQuery.FieldByName('LAST_UPDATE_TIME').AsDateTime;
        FOlddestBatchOK := FHisto[3].DATE;
        vHINT := 'PUSH : dernier paquet OK : ' + FormatDateTime('dd/mm/yyyy hh:nn ', FHisto[3].DATE) +
               Format(' - %d lignes ', [vQuery.FieldByName('DATA_EVENT_COUNT').AsLargeint]) + Format('(Batch %d)', [vQuery.FieldByName('BATCH_ID').Asinteger]);
        if FHisto[3].HINT = '' then
           FHisto[3].HINT := vHint
         else
           FHisto[3].HINT := FHisto[3].HINT + #13 + #10 + vHint;
      end;

      // Push encore dans les tuyaux
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT COUNT(BATCH_ID) AS NB_BATCH, MIN(LAST_UPDATE_TIME) AS LAST_UPDATE_TIME, SUM(DATA_EVENT_COUNT) AS NB_ROWS, STATUS ');
      vQuery.SQL.Add('FROM SYM_OUTGOING_BATCH WHERE NODE_ID<>''-1'' ');
      vQuery.SQL.Add('AND STATUS<>''OK'' ');
      vQuery.SQL.Add('GROUP BY STATUS    ');
      vQuery.Open();
      While not(vQuery.eof) do
        begin
          FDatacount := FDatacount + vQuery.FieldByName('NB_ROWS').Asinteger;
          FOlddestBatchNotOK := vQuery.FieldByName('LAST_UPDATE_TIME').AsDateTime;
          {
          if (vQuery.FieldByName('STATUS').Asstring = 'NE') then
          begin
            If (vQuery.FieldByName('NB_BATCH').Asinteger > 1) then
            begin
              vHint := Format('PUSH : %d paquets en cours avec %d lignes', [vQuery.FieldByName('NB_BATCH').Asinteger, vQuery.FieldByName('NB_ROWS').Asinteger]);
              if FHisto[3].HINT = '' then
                FHisto[3].HINT := vHint
              else
                FHisto[3].HINT := FHisto[3].HINT + #13 + #10 + vHint;
            end
            else
            begin
              FHisto[3].HINT := FHisto[3].HINT + #13 + #10 + Format('PUSH : %d paquet en cours avec %d lignes',
                [vQuery.FieldByName('NB_BATCH').Asinteger, vQuery.FieldByName('NB_ROWS').Asinteger]);
            end;
          end;
          // si le status de la réplication est en erreur ou que le service est arrêté ou que le heartbeat est en erreur, on passe la réplication en erreur
          if (vQuery.FieldByName('STATUS').Asstring = 'ER') or (FHisto[2].LEVEL > 4) or (Frm_Launcher.EventPanel[CID_SERVICE_EASY].LEVEL > logInfo) then
            FHisto[3].LEVEL := Max(6, FHisto[3].LEVEL); // Erreur
          }

          if vQuery.FieldByName('STATUS').Asstring = 'ER' then
            FHisto[3].LEVEL := Max(6, FHisto[3].LEVEL);

          vQuery.Next;
        end;

      // PULL
      // Dernier OK ===> Le PULL c'est plus ICI
      // SYM_INCOMING_BATCH Est très souvent VIDE !
      {
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT BATCH_ID, CHANNEL_ID, LAST_UPDATE_TIME, STATUS, STATEMENT_COUNT, BYTE_COUNT, NODE_ID ');
      vQuery.SQL.Add(' FROM SYM_INCOMING_BATCH WHERE CHANNEL_ID=''default'' ');
      vQuery.SQL.Add(' AND STATUS=''OK'' ');
      vQuery.SQL.Add(' ORDER BY LAST_UPDATE_TIME DESC ');
      vQuery.SQL.Add('ROWS 1 ');
      vQuery.Open();
      if vQuery.RecordCount = 1 then
      begin
        vDATE := vQuery.FieldByName('LAST_UPDATE_TIME').AsDateTime;
        FHisto[3].DATE := Max(FHisto[3].DATE, vDATE); // pas le min
        FHisto[3].HINT := FHisto[3].HINT + #13 + #10 + 'PULL : dernier paquet OK : ' + FormatDateTime('dd/mm/yyyy hh:nn ', vDATE) +
          Format(' - %d lignes ', [vQuery.FieldByName('STATEMENT_COUNT').AsLargeint]) + Format('(Batch %d)', [vQuery.FieldByName('BATCH_ID').Asinteger]);
      end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT COUNT(BATCH_ID) AS NB_BATCH, MIN(LAST_UPDATE_TIME) AS LAST_UPDATE_TIME, STATUS ');
      vQuery.SQL.Add(' FROM SYM_INCOMING_BATCH WHERE CHANNEL_ID=''default'' ');
      vQuery.SQL.Add('AND STATUS<>''OK'' ');
      vQuery.SQL.Add('GROUP BY STATUS    ');
      vQuery.Open();
      While not(vQuery.eof) do
      begin
        vDATE := vQuery.FieldByName('LAST_UPDATE_TIME').AsDateTime;
        if (vQuery.FieldByName('STATUS').Asstring = 'LD') then
        begin
          FHisto[3].HINT := FHisto[3].HINT + #13 + #10 + Format('PULL : %d paquet en chargement : ', [vQuery.FieldByName('NB_BATCH').Asinteger]) +
            FormatDateTime('dd/mm/yyyy hh:nn ', vDATE)
        end;
        if vQuery.FieldByName('STATUS').Asstring = 'ER' then
          FHisto[3].LEVEL := Max(6, FHisto[3].LEVEL); // Erreur

        if vQuery.FieldByName('STATUS').Asstring = 'LD' then
          FHisto[3].LEVEL := Max(4, FHisto[3].LEVEL); // Chargement

        vQuery.Next;
      end;
      }

      // Sinon voir les erreurs... ER (ERREUR) ou les LD (Loading)...
      {
        if vQuery.FieldByName('STATUS').Asstring='ER'
        then  FHisto[3].LEVEL := Max(6,FHisto[3].LEVEL);  // Erreur

        if vQuery.FieldByName('STATUS').Asstring='LD'
        then  FHisto[3].LEVEL := Max(4,FHisto[3].LEVEL);  // LOAD

        if vQuery.FieldByName('STATUS').Asstring='OK'
        then FHisto[3].LEVEL := Max(3,FHisto[3].LEVEL);  // OK
      }

    except
      On E: EIBNativeException Do
      begin
        If Pos('shutdown', E.MEssage) > 1 then
          FShutdown := true;
        If Pos('no permission', E.MEssage) > 1 then
          FGRANTprobleme := true;
        If Pos('Failed to establish a connection', E.MEssage) > 1 then
          FFailConnection := true;
      end;
      on E: EEasyNotInstalledError do
      begin
        FEasyNotInstalled := true;
      end;
    end;
  Finally
    vQuery.free;
    DataMod.FDcon.Connected := False;
  end;
end;

constructor TThreadDB.Create(CreateSuspended: Boolean; Const aFirstPass: Boolean = False; Const AEvent: TNotifyEvent = nil);
// var myDate : TDateTime;
// myHour, myMin, mySec, myMilli : Word;
begin
  inherited Create(CreateSuspended);
  FDatacount    := 0;
  FOlddestBatchOk    := 0;
  FOlddestBatchNotOk := 0;
  FIBFILE := '';
  FShutdown := False;
  FGRANTprobleme := False;
  FFailConnection := False;
  FFirstPass := aFirstPass;
  FBI_INSTALLED := False;
  FPARAM_11_60.Init;
  FPARAM_81_1.Init;
  FPARAM_60_1.Init;
  FPARAM_60_3.Init;
  FPARAM_60_6.Init;
  FPARAM_3_36.Init;
  FPARAM_9_414.Init;
  SetLength(FHisto, 0);
  {
    myDate := Now();
    DecodeTime(myDate, myHour, myMin, mySec, myMilli);
    FBackRest.Prochain  := Date+myHour/24+((MyMin div 10)*10)/1440;
  }
  FBackRest.Prochain := DATE + EncodeTime(23, 00, 0, 0);

  FreeOnTerminate := true;
  OnTerminate := AEvent;
end;

procedure TThreadDB.Execute;
begin
  try
    try
      GetInfos();
    Except
      //
    end;
  finally
    Synchronize(UpdateVCL);
  end;
end;

end.

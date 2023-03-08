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

Type
  EEasyNotInstalledError = class(Exception);


  TSynchroPath = record
    Enable: boolean;
    Nom: string;
    ServerId: Integer;
    Path: string;
  end;

  TSynchroPaths = array of TSynchroPath;

  TGENPARAM = record
    PRMTYPE: Integer;
    PRMCODE: Integer;
    PRMSTRING: string;
    PRMINTEGER: Integer;
  public
    procedure Init;
  end;

  TIndicateur = record
    DATE: TDateTime;
    LEVEL: Integer;
    Detail: string;
    HINT: string;
  end;

  TThreadDB = class(TThread)
  private
    { Déclarations privées }
    FDataCount    : integer;
    FOlddestBatch : string;
    FHeartBeatCount : integer;
    FIBUSerConnected : Integer;
    FPARAM_11_60: TGENPARAM;
    FPARAM_81_1: TGENPARAM;
    FPARAM_60_1: TGENPARAM;
    FPARAM_60_3: TGENPARAM;
    FPARAM_60_6: TGENPARAM;
    FPARAM_60_8: TGENPARAM;
    FPARAM_3_36: TGENPARAM;
    FPARAM_9_414: TGENPARAM;
    FFirstPass: Boolean;
    FIBFILE: TFileName;
    FPUSH      : TIndicateur;
    FHEARTBEAT : TIndicateur;
    FShutdown: Boolean;
    FGRANTprobleme: Boolean;
    FEasyNotInstalled: Boolean;
    FFailConnection: Boolean;
    FNode: string;
    FNode_Group :string;
    FGUID: string;
    FBAS_IDENT  : integer;
    FBASID: string;
    FIsBaseProd: Boolean;
    FSENDER: string;
    FBASNOMPOURNOUS: string;
    FBASMAGID: string;
    FVersionDB: string;
    FTriggerDiff : string;
    FLignesStock : integer;
    FSYNCHRO_NB : string;
    FGENERAL_ID : int64;
    FFileExistSYNCHRO_NB  : boolean;
    FFileExistVersion_ZIP : boolean;
    FFileSize_NB : int64;
    FFileDateTime_NB : TDateTime;
    FSynchroPaths    : TSynchroPaths;
    function GetFileDateTime(const FileTime: TFileTime):TDateTime;
    procedure Get_FileSize_NB();
    procedure GetInfos();
    function GetSynchroPaths: TSynchroPaths;
    function LancementAutomatique(aAUTORUN: Boolean): Boolean;
  protected
    { -- }
  public
    procedure Execute; override;
    constructor Create(CreateSuspended: Boolean; Const aFirstPass: Boolean = False;
      const AEvent: TNotifyEvent = nil); reintroduce;
    // Read Write
    property IBFILE: TFileName read FIBFILE write FIBFILE;
    // Read Only : retour du Thread
    property Node         : string    read FNode;
    property Node_Group   : string    read FNode_Group;
    property Datacount    : integer   read FDataCount;
    property Oldestbatch  : string    read FOlddestBatch;
    property HeartBeatCount : integer read FHeartBeatCount;
    property TriggerDiff  : string    read FTriggerDiff;
    property LignesStock  : integer   read FLignesStock;
    property PUSH         : TIndicateur read FPUSH;
    property HEARTBEAT    : TIndicateur read FHEARTBEAT;
    property BAS_IDENT    : integer     read FBAS_IDENT;
    property SENDER       : string      read FSENDER;
    property SYNCHRO_NB   : string      read FSYNCHRO_NB;
    property FileExistSYNCHRO_NB   : boolean read FFileExistSYNCHRO_NB;
    property FileExistVersion_ZIP  : boolean read FFileExistVersion_ZIP;
    property GENERAL_ID   : int64       read FGENERAL_ID;
    property FileSize_NB  : Int64       read FFileSize_NB;
    property FileDateTime_NB : TDateTime read FFileDateTime_NB;
    property IBUSerConnected : integer       read FIBUSerConnected;
    property SynchroPaths    : TSynchroPaths read FSynchroPaths;



  end;

implementation

Uses uDataMod, uLog;

{ ---------------------------- TGENPARAM ------------------------------------- }

procedure TGENPARAM.Init;
begin
  PRMTYPE := 0;
  PRMCODE := 0;
  PRMSTRING := '';
  PRMINTEGER := 0
end;


function TThreadDB.GetFileDateTime(const FileTime: TFileTime):TDateTime;
var SystemTime, LocalTime: TSystemTime;
begin
    if not FileTimeToSystemTime(FileTime, SystemTime) then
      RaiseLastOSError;
    if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
      RaiseLastOSError;
    result:= SystemTimeToDateTime(LocalTime);
 end;



procedure TThreadDB.Get_FileSize_NB();
var info: TWin32FileAttributeData;
begin
   FFileSize_NB := -1;

   if NOT GetFileAttributesEx(PWideChar(SYNCHRO_NB), GetFileExInfoStandard, @info) then
      EXIT;

  FFileSize_NB := Int64(info.nFileSizeLow) or Int64(info.nFileSizeHigh shl 32);
  FFileDateTime_NB := GetFileDateTime(info.ftLastWriteTime);
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


function TThreadDB.GetSynchroPaths: TSynchroPaths;
var vQuery: TFDQuery;
    i:integer;
begin
  setLength(Result, 0);
  vQuery := TFDQuery.Create(nil);
  vQuery.Connection  := DataMod.FDcon;
  vQuery.Transaction := DataMod.FDtrans;
  vQuery.Transaction.Options.ReadOnly := true;
  vQuery.Close;
  try
    vQuery.Close;
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT BAS_NOM, PRM_INTEGER, PRM_FLOAT, PRM_STRING, PRM_POS ');
    vQuery.SQL.Add(' FROM GENPARAM                                              ');
    vQuery.SQL.Add(' JOIN K ON K_ID = PRM_ID AND K_ENABLED=1                    ');
    vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT = CAST(PRM_POS AS VARCHAR(32))  ');
    vQuery.SQL.Add(' WHERE PRM_TYPE=3 AND PRM_CODE=33 AND PRM_FLOAT=0 AND PRM_STRING <> '''' ');
    vQuery.Open;

    i := 0;
    while not vQuery.Eof do
    begin
      setLength(Result, i + 1);
      Result[i].Enable := (vQuery.FieldByName('PRM_INTEGER').AsInteger = 1);
      Result[i].Nom := vQuery.FieldByName('BAS_NOM').AsString;
      Result[i].ServerId := Trunc(vQuery.FieldByName('PRM_POS').AsInteger);
      Result[i].Path := vQuery.FieldByName('PRM_STRING').asString;
      Inc(i);
      vQuery.Next;
    end;
    vQuery.Close;
  finally
    vQuery.DisposeOf;
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
  vBASIDENT : string;
  vAutoRun: Boolean;
  vHint: string;
  vDATE: TDateTime;
  vNbSymTrig: Integer;
  vNbSymTrigAttendu: Integer;
  vMAX_START_ID      : Largeint;
  vSautLigne  : string;
  vVERSION_ZIP : string;

begin
  if IBFILE = '' then
    exit;
  vBASID := 0;
  vQuery := TFDQuery.Create(nil);
  try
    try
      // Construction des Tuiles

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
      vQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_NOMPOURNOUS, BAS_MAGID, BAS_IDENT FROM GENPARAMBASE        ');
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
        vBASIDENT := vQuery.FieldByName('BAS_IDENT').AsString;
        FSENDER := vBASSENDER;
        FBASNOMPOURNOUS := vBASNOMPOURNOUS;
        FGUID := vBASGUID;
        FBASID := vQuery.FieldByName('BAS_ID').Asstring;;
        FBASMAGID := vBASMAGID;
        FBAS_IDENT := StrToIntDef(vBASIDENT,0);
      end;

      // Ou est GENERAL_ID
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        // AnalysePlage(vBASPLAGE, vQuery.Fields[0].Asinteger);
        FGENERAL_ID := vQuery.Fields[0].AsLargeInt;
      end;

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

      // Synchro MultiMag C'est un Tableau de Record ..
      vQuery.SQL.Add('SELECT BAS_NOM, PRM_INTEGER, PRM_FLOAT, PRM_STRING, PRM_POS FROM GENPARAM  ');
      vQuery.SQL.Add('JOIN K ON K_ID = PRM_ID AND K_ENABLED=1                                    ');
      vQuery.SQL.Add('JOIN GENBASES ON BAS_IDENT = CAST(PRM_POS AS VARCHAR(32))                  ');
      vQuery.SQL.Add('WHERE PRM_TYPE=3 AND PRM_CODE=33 AND PRM_FLOAT=0 AND PRM_STRING <> ''''    ');




      // Synchro paramètre par defaut
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING ');
      vQuery.SQL.Add(' FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
      vQuery.SQL.Add(' WHERE PRM_TYPE = 3 AND PRM_CODE = 33    ');
      vQuery.SQL.Add('     AND PRM_POS = :IDENT                ');
      vQuery.ParamByName('IDENT').Asinteger := FBAS_IDENT;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
        begin
           FSYNCHRO_NB  := vQuery.FieldByName('PRM_STRING').Asstring;
        end;
      vQuery.Close();
      if FFirstPass then
        begin
          if FSYNCHRO_NB<>'' then
            begin
                vVERSION_ZIP := IncludeTrailingPathDelimiter(ExtractFilePath(FSYNCHRO_NB))+ 'VERSION.ZIP';
                FFileExistVersion_ZIP := FileExists(vVERSION_ZIP);

                FFileExistSYNCHRO_NB := FileExists(FSYNCHRO_NB);
                Get_FileSize_NB();
                //-----------------------------------------------------------


            end;
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
        vQuery.SQL.Add('SELECT * FROM SYM_NODE_IDENTITY I JOIN SYM_NODE N ON N.NODE_ID=I.NODE_ID');
        vQuery.Open();
        if vQuery.RecordCount = 1 then
        begin
          FNode := vQuery.FieldByName('NODE_ID').Asstring;
          FNode_Group := vQuery.FieldByName('NODE_GROUP_ID').Asstring;
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
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM SYM_NODE_HOST ');
      vQuery.SQL.Add(' ORDER BY NODE_ID');
      vQuery.Open();
      FHeartBeat.LEVEL := 3;
      FHeartBeat.Detail := '';
      vSautLigne := '';
      While not(vQuery.Eof) do
      begin
        FHeartBeat.DATE := vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime;

        if (vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime + C_HEARTBEATTIME / MinsPerDay < Now())
          then FHeartBeat.LEVEL := 5;

        FHeartBeat.Detail := FHeartBeat.Detail + vSautLigne +
              FormatDateTime('dd/mm/yyyy hh:nn',vQuery.FieldByName('HEARTBEAT_TIME').AsDateTime);

        vSautLigne := #13+#10;
        vQuery.next;
      end;

      // lorsqu'il y a de gros transfert la tuille reste en Notice longtemps car le dernier paquet reste en "NE"
      // Le Hint ne refete pas non plus correctement son statut
      // il faudrait faire autrement... pour le push et le pull

      // Par defaut
      FPUSH.LEVEL := 3;
      FPUSH.HINT := '';

      // Si EASY Arrêté il peut y avoir des données non routées
      // c'est l'indicateur essentiel pour savoir si c'est remonté
      // On va  s'occuper que du "MAX START_ID" car
      // vu chez flammier sur le Serveur
      //  le MIN ne représente pas correctement
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
      vQuery.SQL.Add('SELECT TABLE_NAME FROM SYM_DATA WHERE DATA_ID>=:START_ID AND SOURCE_NODE_ID IS NULL');
      vQuery.ParamByName('START_ID').AsLargeInt :=  vMAX_START_ID;
      vQuery.Open();
      FDatacount := 0;
      while not(vQuery.eof) do
      begin
        if UpperCase(vQuery.Fields[0].AsString)<>'GENHISTOEVT'
          then Inc(FDatacount);
        vQuery.Next;
      end;

      if FDatacount<>0
        then FPUSH.HINT := Format(' %d lignes non routées ', [FDatacount])
        else FPUSH.HINT := 'Toutes les lignes ont été routées';

      // Par defaut level 6 Erreur
      FPUSH.LEVEL := 6;

      // moins de 1000 (c'est attention)
      if (FDatacount div 1000 < 1)
        then FPUSH.LEVEL := 5;

      // moins de 100 (c'est "en cours")
      if (FDatacount div 100 < 1)
        then FPUSH.LEVEL := 4;

      if (FDatacount = 0 )
        then FPUSH.LEVEL := 3;


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
        FPUSH.DATE := vQuery.FieldByName('LAST_UPDATE_TIME').AsDateTime;
        FOlddestBatch  := FormatDateTime('dd/mm/yyyy hh:nn ', FPUSH.DATE);
        vHINT := 'PUSH : dernier paquet OK : ' + FormatDateTime('dd/mm/yyyy hh:nn ', FPUSH.DATE) +
               Format(' - %d lignes ', [vQuery.FieldByName('DATA_EVENT_COUNT').AsLargeint]) + Format('(Batch %d)', [vQuery.FieldByName('BATCH_ID').Asinteger]);
        if FPUSH.HINT = '' then
           FPUSH.HINT := vHint
         else
           FPUSH.HINT := FPUSH.HINT + #13 + #10 + vHint;
      end;

      // Push encore dans les tuyaux
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT COUNT(BATCH_ID) AS NB_BATCH, MIN(LAST_UPDATE_TIME) AS LAST_UPDATE_TIME, ');
      vQuery.SQL.Add(' SUM(DATA_EVENT_COUNT) AS NB_ROWS, STATUS, CHANNEL_ID ');
      vQuery.SQL.Add(' FROM SYM_OUTGOING_BATCH WHERE NODE_ID<>''-1'' ');
      vQuery.SQL.Add(' AND STATUS<>''OK'' ');
      vQuery.SQL.Add(' GROUP BY STATUS, CHANNEL_ID ');
      vQuery.Open();

      While not(vQuery.eof) do
        begin
          if (vQuery.FieldByName('CHANNEL_ID').Asstring)<>'heartbeat'
            then FDatacount      := FDatacount      + vQuery.FieldByName('NB_ROWS').Asinteger
            else FHeartBeatCount := FHeartBeatCount + vQuery.FieldByName('NB_ROWS').Asinteger;

          if vQuery.FieldByName('STATUS').Asstring = 'ER' then
            FPUSH.LEVEL := Max(6, FPUSH.LEVEL);

          vQuery.Next;
        end;

      vQuery.SQL.Add('SELECT * FROM  TMP$ATTACHMENTS');
      vQuery.open;
      FIBUSerConnected:=0;
      While not(vQuery.eof) do
         begin
            inc(FIBUSerConnected);
            vQuery.Next;
         end;
     vQuery.Close;
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
  //  DataMod.FDcon.Connected := False;
  end;
end;

constructor TThreadDB.Create(CreateSuspended: Boolean; Const aFirstPass: Boolean = False; Const AEvent: TNotifyEvent = nil);
begin
  inherited Create(CreateSuspended);
  FDatacount    := 0;
  FHeartBeatCount := 0;
  FOlddestBatch := '';
  FIBFILE := '';
  FShutdown := False;
  FGRANTprobleme := False;
  FFailConnection := False;
  FFirstPass := aFirstPass;
  FPARAM_11_60.Init;
  FPARAM_81_1.Init;
  FPARAM_60_1.Init;
  FPARAM_60_3.Init;
  FPARAM_60_6.Init;
  FPARAM_3_36.Init;
  FPARAM_9_414.Init;
  FFileExistSYNCHRO_NB  := false;
  FFileExistVersion_ZIP := false;
  FreeOnTerminate := true;
  OnTerminate := AEvent;
end;

procedure TThreadDB.Execute;
begin
  try
    try
      GetInfos();
      FSynchroPaths := GetSynchroPaths();
    Except
      //
    end;
  finally
   //
  end;
end;

end.

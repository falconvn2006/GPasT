//$Log:
// 1    Utilitaires1.0         23/10/2014 19:29:28    Lionel Plais    
//$
//$NoKeywords$
//

UNIT UMapping;

INTERFACE
USES
    MapFiles;

TYPE
    TRecGinkoia = RECORD
        Ginkoia: Boolean;
        Caisse: Boolean;
        Launcher: Boolean;
        Backup: Boolean;
        LiveUpdate: Boolean;
        MajAuto: Boolean;
        ParamGinkoia: Boolean;
        Ping: Boolean;
        PingStop: Boolean;
        Script: Boolean;
        ScriptOK: Boolean;
        ScriptEnCours: ShortString;
        ScriptErreur: ShortString;
        piccobatch: boolean;
        Verifencours:Boolean ;
    END;

    TMapGinkoia = CLASS(TRecordMap)
    PRIVATE
        FUNCTION GetGinkoia: Boolean;
        PROCEDURE SetGinkoia(CONST Value: Boolean);
        FUNCTION GetBackup: Boolean;
        FUNCTION GetCaisse: Boolean;
        FUNCTION GetLauncher: Boolean;
        FUNCTION GetLiveUpdate: Boolean;
        FUNCTION GetMajAuto: Boolean;
        PROCEDURE SetBackup(CONST Value: Boolean);
        PROCEDURE SetCaisse(CONST Value: Boolean);
        PROCEDURE SetLauncher(CONST Value: Boolean);
        PROCEDURE SetLiveUpdate(CONST Value: Boolean);
        PROCEDURE SetMajAuto(CONST Value: Boolean);
        FUNCTION GetParamGinkoia: Boolean;
        PROCEDURE SetParamGinkoia(CONST Value: Boolean);
        FUNCTION GetPing: Boolean;
        PROCEDURE SetPing(CONST Value: Boolean);
        FUNCTION GetPingStop: Boolean;
        PROCEDURE SetPingStop(CONST Value: Boolean);
        FUNCTION GetScript: Boolean;
        PROCEDURE SetScript(CONST Value: Boolean);
        FUNCTION GetScriptOK: Boolean;
        PROCEDURE SetScriptOK(CONST Value: Boolean);
        FUNCTION GetScriptEnCours: ShortString;
        PROCEDURE SetScriptEnCours(CONST Value: ShortString);
        FUNCTION GetScriptErreur: ShortString;
        PROCEDURE SetScriptErreur(CONST Value: ShortString);
        PROCEDURE Setpiccobatch(CONST Value: Boolean);
        FUNCTION Getpiccobatch: Boolean;
        function GetVerifencours: Boolean;
        procedure SetVerifencours(const Value: Boolean);
    PROTECTED
        GinkoiaRec: TRecGinkoia;
        PROCEDURE ReadRec(VAR Rec); OVERRIDE;
        PROCEDURE WriteRec(CONST Rec); OVERRIDE;
    PUBLIC
        CONSTRUCTOR Create;
        PROPERTY Ginkoia: Boolean READ GetGinkoia WRITE SetGinkoia;
        PROPERTY Caisse: Boolean READ GetCaisse WRITE SetCaisse;
        PROPERTY Launcher: Boolean READ GetLauncher WRITE SetLauncher;
        PROPERTY Backup: Boolean READ GetBackup WRITE SetBackup;
        PROPERTY LiveUpdate: Boolean READ GetLiveUpdate WRITE SetLiveUpdate;
        PROPERTY MajAuto: Boolean READ GetMajAuto WRITE SetMajAuto;
        PROPERTY ParamGinkoia: Boolean READ GetParamGinkoia WRITE SetParamGinkoia;
        PROPERTY Ping: Boolean READ GetPing WRITE SetPing;
        PROPERTY PingStop: Boolean READ GetPingStop WRITE SetPingStop;
        PROPERTY Script: Boolean READ GetScript WRITE SetScript;
        PROPERTY ScriptOK: Boolean READ GetScriptOK WRITE SetScriptOK;
        PROPERTY ScriptEnCours: ShortString READ GetScriptEnCours WRITE SetScriptEnCours;
        PROPERTY ScriptErreur: ShortString READ GetScriptErreur WRITE SetScriptErreur;
        PROPERTY piccobatch: Boolean READ Getpiccobatch WRITE Setpiccobatch;
        PROPERTY Verifencours:Boolean READ GetVerifencours WRITE SetVerifencours;
    END;

VAR
    MapGinkoia: TMapGinkoia;

IMPLEMENTATION

CONSTRUCTOR TMapGinkoia.Create;
BEGIN
    INHERITED Create('');
    MapName := 'Ginkoia';
    HeaderSize := 10;
    RecordSize := sizeof(TRecGinkoia);
    Active := true;
    IF RecCount = 0 THEN
    BEGIN
        GinkoiaRec.Ginkoia := false;
        GinkoiaRec.Caisse := false;
        GinkoiaRec.Launcher := false;
        GinkoiaRec.Backup := false;
        GinkoiaRec.LiveUpdate := false;
        GinkoiaRec.MajAuto := false;
        GinkoiaRec.ParamGinkoia := false;
        GinkoiaRec.Ping := false;
        GinkoiaRec.PingStop := false;
        GinkoiaRec.Script := False;
        GinkoiaRec.ScriptOK := False;
        GinkoiaRec.piccobatch := false;
        GinkoiaRec.Verifencours := false;
        Appendrec(GinkoiaRec);
    END
    ELSE
    BEGIN
        First;
        ReadRec(GinkoiaRec);
    END;
END;

FUNCTION TMapGinkoia.GetBackup: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Backup;
END;

FUNCTION TMapGinkoia.GetCaisse: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Caisse;
END;

FUNCTION TMapGinkoia.GetGinkoia: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Ginkoia;
END;

FUNCTION TMapGinkoia.GetLauncher: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Launcher;
END;

FUNCTION TMapGinkoia.GetLiveUpdate: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.LiveUpdate;
END;

FUNCTION TMapGinkoia.GetMajAuto: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.MajAuto;
END;

FUNCTION TMapGinkoia.GetParamGinkoia: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.ParamGinkoia;
END;

FUNCTION TMapGinkoia.Getpiccobatch: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.piccobatch;
END;

FUNCTION TMapGinkoia.GetPing: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Ping;
END;

FUNCTION TMapGinkoia.GetPingStop: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.PingStop;
END;

FUNCTION TMapGinkoia.GetScript: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Script;
END;

FUNCTION TMapGinkoia.GetScriptEnCours: ShortString;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.ScriptEnCours;
END;

FUNCTION TMapGinkoia.GetScriptErreur: ShortString;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.ScriptErreur;
END;

FUNCTION TMapGinkoia.GetScriptOK: Boolean;
BEGIN
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.ScriptOk;
END;

function TMapGinkoia.GetVerifencours: Boolean;
begin
    First;
    ReadRec(GinkoiaRec);
    result := GinkoiaRec.Verifencours;
end;

PROCEDURE TMapGinkoia.ReadRec(VAR Rec);
BEGIN
    Read(TRecGinkoia(Rec), Sizeof(TRecGinkoia));
END;

PROCEDURE TMapGinkoia.SetBackup(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Backup := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetCaisse(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Caisse := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetGinkoia(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Ginkoia := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetLauncher(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Launcher := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetLiveUpdate(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.LiveUpdate := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetMajAuto(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.MajAuto := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetParamGinkoia(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.ParamGinkoia := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.Setpiccobatch(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.piccobatch := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetPing(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Ping := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetPingStop(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.PingStop := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetScript(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Script := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetScriptEnCours(CONST Value: ShortString);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.ScriptEnCours := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetScriptErreur(CONST Value: ShortString);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.ScriptErreur := value;
    First;
    WriteRec(GinkoiaRec);
END;

PROCEDURE TMapGinkoia.SetScriptOK(CONST Value: Boolean);
BEGIN
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.ScriptOK := value;
    First;
    WriteRec(GinkoiaRec);
END;

procedure TMapGinkoia.SetVerifencours(const Value: Boolean);
begin
    First;
    ReadRec(GinkoiaRec);
    GinkoiaRec.Verifencours := value;
    First;
    WriteRec(GinkoiaRec);
end;

PROCEDURE TMapGinkoia.WriteRec(CONST Rec);
BEGIN
    EnterCriticalSection;
    Write(TRecGinkoia(Rec), Sizeof(TRecGinkoia));
    LeaveCriticalSection;
END;

INITIALIZATION
    MapGinkoia := TMapGinkoia.Create;
FINALIZATION
    MapGinkoia.free;
END.


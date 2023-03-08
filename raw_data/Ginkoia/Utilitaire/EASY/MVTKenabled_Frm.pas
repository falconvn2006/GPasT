unit MVTKenabled_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin, Vcl.Menus,uLog;

Const CST_START  = 'Lancement...';
      CST_STOP  = 'Stop';
      CST_CYCLE = 60000;  // 5000 pour les tests
      CST_DEBUT_JOUR  = 07/24;
      CST_DEBUT_NUIT  = 20/24;

type

  TKENAThread = class(TThread)
  private
//  FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FMemTable      : TFDMemTable;
    FnbErrors      : integer;
    FWMIPROC       : boolean;
    FWMIIB         : boolean;
    FINSERT        : Boolean;
    FUPDATE        : Boolean;
    FCorrupt       : Boolean;
    FUnsent        : Boolean;
    FDeadlock      : Boolean;
    FROWS          : integer;

  protected
//    procedure StatusCallBack();
    procedure Execute; override;
  public
    constructor Create(aMemTable     : TFDMemTable;
      // aSatusCallBack : TStatusMessageCall;
      aEvent:TNotifyEvent=nil);
    destructor Destroy();

   property WMIPROC     : Boolean   read FWMIPROC   Write FWMIPROC;
   property WMIIB       : Boolean   read FWMIIB     Write FWMIIB;
   property INSERT      : Boolean   read FInsert    Write FInsert;
   property UPDATE      : Boolean   read FUpdate    Write FUpdate;
   property Corrupt     : Boolean   read FCorrupt   Write FCorrupt;
   property Unsent      : Boolean   read FUnsent    Write FUnsent;
   property Deadlock    : Boolean   read FDeadlock  Write FDeadLock;
   property Rows        : Integer   read FRows      Write FRows;

   property NBErrors: integer read FNbErrors;
//   property MemTable    : TFDMemTable read FMemTable;


  end;


  TForm18 = class(TForm)
    sb: TStatusBar;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    BMVT: TButton;
    Dossiers: TFDMemTable;
    DossiersID: TIntegerField;
    StringField1: TStringField;
    DossiersEngineName: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    dsDOSSIERS: TDataSource;
    DBGrid3: TDBGrid;
    DossiersLastResult: TStringField;
    DossiersLastScan: TStringField;
    ProgressBar1: TProgressBar;
    FProgressTimer: TTimer;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    N2: TMenuItem;
    Mettrejour: TMenuItem;
    DossiersCorrupt: TStringField;
    DossiersDEADLOCK: TStringField;
    DossiersLastResultInsert: TStringField;
    grpWMI: TGroupBox;
    cbWMIIB: TCheckBox;
    cbWMIPROC: TCheckBox;
    GroupBox2: TGroupBox;
    cbUPDATE: TCheckBox;
    cbINSERT: TCheckBox;
    GroupBox4: TGroupBox;
    cbCorrupt: TCheckBox;
    cbUnsent: TCheckBox;
    cbDeadlock: TCheckBox;
    DossiersTimeScan: TIntegerField;
    seROWS: TSpinEdit;
    Label2: TLabel;
    GroupBox5: TGroupBox;
    seTimerJOUR: TSpinEdit;
    seTimerNUIT: TSpinEdit;
    Label1: TLabel;
    Label3: TLabel;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    pOuvrir: TMenuItem;
    N1: TMenuItem;
    pQuitter: TMenuItem;
    procedure BMVTClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FProgressTimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pOuvrirClick(Sender: TObject);
    procedure pQuitterClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
  private
    FCanClose : Boolean;
    FLock  : boolean;
    FStart : cardinal;
    FKENA  : TKENAThread;
    procedure SwitchOnOff;
    procedure DoThread();
    procedure Refresh();
    procedure CallBackEnd(Sender:TObject);
//    procedure DoTraitement();
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;






var
  Form18: TForm18;

implementation

{$R *.dfm}

uses uDataMod,UWMI,UCommun,uEasy.Types, ServiceControler;


constructor TKENAThread.Create(
    aMemTable     : TFDMemTable;
//    aStatusCallBack : TStatusMessageCall;
    aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
//    FMemTable := TFDMemTable.Create(nil);
//    FMemTable.CloneCursor(aMemTable, True, False);

    FMemTable := aMemTable;

//    FStatusProc     := aStatusCallBack;

    FWMIPROC     := true;
    FWMIIB       := false;

    FINSERT      := false;
    FUPDATE      := true;
    FCorrupt     := false;
    FUnsent      := false;
    FDeadlock    := false;
    FROWS        := 50;

    FnbErrors    := 0;

    OnTerminate     := AEvent;
    FreeOnTerminate := True;

end;

procedure TKENAThread.Execute;
var vResult:string;
    vResultInsert : string;
    vCorrupt:string;
    vNow    : string;
    vlogLvl : TLogLevel;
    vIBProcess : TprocessInfos;
    vDeadLock  : string;
    vUnsentBatchs : TUnsentBatchs;
    i:Integer;
    vProc : integer;
    vStop, vStart, vTimeScan: Cardinal;
begin
    if WMIPROC then
      begin
        vProc := WMI_GetPerfOSProc;
        case vProc of
        95..100 : Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logError, True, 0, ltServer);
        85..94  : Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logWarning, True, 0, ltServer);
        70..84  : Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logNotice, True, 0, ltServer);
        else Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logInfo, True, 0, ltServer);
        end;
      end;
    if WMIIB then
      begin
        vIBProcess := WMI_GetProcessInfos('ibserver.exe');
        Log.Log('ibserver', 'ibserver.exe', 'ppt', vIBProcess.PercentProcessorTime,logInfo, True, 0, ltServer);
      end;


    // FMemTable.DisableControls;
    FMemTable.First;
    while not(FMemTable.eof) do
      begin
          vStart := GetTickCount;
          vResultInsert := '';
          vResult       := '';
          vCorrupt      := '';
          vDeadLock     := '';

          vNow     := FormatDateTime('dd/mm/yyyy hh:nn:ss',Now());
          Log.Log('Main', FMemTable.FieldByName('ServiceName').asstring, 'LastScan',vNow, logInfo, True, 0, ltServer);

          // test de l'état du service pour monitoring
          if ServiceGetStatus('',PChar(FMemTable.FieldByName('ServiceName').AsString)) = 4 then // 4 = démarré
            Log.Log('Service', PChar(FMemTable.FieldByName('ServiceName').asstring), 'Status','Démarré', logInfo, True, 0, ltServer)
          else
            Log.Log('Service', FMemTable.FieldByName('ServiceName').asstring, 'Status','Arrêté', logError, True, 0, ltServer);


          if UPDATE
            then  vResult := DataMod.EasyMvtKenabled(FMemTable.FieldByName('IBFile').asstring,ROWS);

          // Peut etre long ?  aucune idée
          if Insert
            then vResultInsert := DataMod.EasyMvtKenabled_INSERT(FMemTable.FieldByName('IBFile').asstring);

          if Corrupt then
            begin
              vCorrupt  := DataMod.DetectNodeIBCorrupt(FMemTable.FieldByName('IBFile').asstring);
            end;

          if DeadLock then
            begin
                vDeadLock := DataMod.DetectNodeIBDeadLock(FMemTable.FieldByName('IBFile').asstring);
            end;

          if Update then
            begin
              vloglvl := logInfo;
              if vResult<>'RAS' then
                begin
                    vLogLvl := logWarning;
                end;
              Log.Log('Main', FMemTable.FieldByName('ServiceName').asstring, 'MVTKENABLED',vResult, vlogLvl, True, 0, ltServer);
            end;

          if Corrupt then
            begin
                vloglvl := logInfo;
                if vCorrupt<>'' then
                  begin
                      vLogLvl := logError;
                  end;
                Log.Log('Main', FMemTable.FieldByName('ServiceName').asstring, 'Corrupt',vCorrupt, vLogLvl, True, 0, ltServer);
            end;

          if DeadLock then
            begin
              vloglvl := logInfo;
              if vDeadLock<>'' then
                begin
                    vLogLvl := logError;
                end;
              Log.Log('Main', FMemTable.FieldByName('ServiceName').asstring, 'Deadlock',vDeadLock, vLogLvl, True, 0, ltServer);
            end;

          if Unsent then
            begin
              vUnsentBatchs := DataMod.EasyUnsentBatchs(FMemTable.FieldByName('IBFile').asstring);
              for I := Low(vUnsentBatchs) to High(vUnsentBatchs) do
                begin
                    vloglvl := logInfo;
                    if vUnsentBatchs[i].DATACOUNT>100000 then
                      begin
                          vloglvl := logNotice;
                      end;
                    if vUnsentBatchs[i].DATACOUNT>500000 then
                      begin
                          vloglvl := logWarning;
                      end;
                    if vUnsentBatchs[i].DATACOUNT>1000000 then
                      begin
                          vloglvl := logError;
                      end;
                    // Quand on renomme un sender et pas un Noeud ca fout un megabordel !!!
                    // à tous les niveaux !
                    Log.Log('',
                        'UnsentBatchs',
                        vUnsentBatchs[i].SenderNode.NOMPOURNOUS,
                        vUnsentBatchs[i].SenderNode.GUID,
                        vUnsentBatchs[i].SenderNode.SENDER,
                        'DataCount',
                        IntToStr(vUnsentBatchs[i].DATACOUNT), vLogLvl, True, 0, ltServer);
                    Log.Log('',
                        'UnsentBatchs',
                        vUnsentBatchs[i].SenderNode.NOMPOURNOUS,
                        vUnsentBatchs[i].SenderNode.GUID,
                        vUnsentBatchs[i].SenderNode.SENDER,
                        'OldestBatch',
                        vUnsentBatchs[i].OLDESTBATCH, vLogLvl, True, 0, ltServer);
                end;
            end;
          FMemTable.Edit;
          FMemTable.FieldByName('LastResult').asstring := vResult;
          FMemTable.FieldByName('Corrupt').asstring := vCorrupt;
          FMemTable.FieldByName('LastScan').asstring   := vNow;
          FMemTable.FieldByName('Deadlock').asstring := vDeadLock;
          FMemTable.FieldByName('LastResultInsert').asstring := vResultInsert;
          vStop := GetTickCount;
          vTimeScan := vStop - vStart;
          FMemTable.FieldByName('TimeScan').asinteger  := vTimeScan;


          FMemTable.Post;
          FMemTable.Next;
      end;
    // FMemTable.EnableControls;
end;

destructor TKENAThread.Destroy();
begin
  // FMemTable.DisposeOf;
  Inherited;
end;

{
procedure TKENAThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;
}

{
Procedure TForm18.DoTraitement();
var vResult:string;
    vCorrupt:string;
    vNow    : string;
    vlogLvl : TLogLevel;
    vIBProcess : TprocessInfos;
    vDeadLock  : string;
    vUnsentBatchs : TUnsentBatchs;
    i:Integer;
    vProc : integer;
    vResultInsert : string;
    vBoolUpdate  : Boolean;
    vBoolInsert  : boolean;
    vBoolCorrupt : boolean;
    vBoolUnsent  : boolean;
    vBoolDeadLock : boolean;
    vNbLignes : integer;
    vStop, vStart, vTimeScan: Cardinal;
begin
    if cbWMIIB.Checked then
      begin
        vIBProcess := WMI_GetProcessInfos('ibserver.exe');
        Log.Log('ibserver', 'ibserver.exe', 'ppt', vIBProcess.PercentProcessorTime,logInfo, True, 0, ltServer);
      end;
    if cbWMIPROC.Checked then
      begin
        vProc := WMI_GetPerfOSProc;
        case vProc of
        95..100 : Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logError, True, 0, ltServer);
        85..94  : Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logWarning, True, 0, ltServer);
        70..84  : Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logNotice, True, 0, ltServer);
        else Log.Log('processeur', 'Total', 'ppt', IntToStr(vProc),logInfo, True, 0, ltServer);
        end;
      end;
    vBoolInsert   := cbINSERT.Checked;
    vBoolUpdate   := cbUPDATE.Checked;
    vBoolCorrupt  := cbCorrupt.Checked;
    vBoolUnsent   := cbUnsent.Checked;
    vBoolDeadLock := cbDeadlock.Checked;
    vNbLignes     := seROWS.Value;

    Dossiers.DisableControls;
    Dossiers.First;
    while not(Dossiers.eof) do
      begin
          vStart := GetTickCount;
          vResultInsert := '';
          vResult       := '';
          vCorrupt      := '';
          vDeadLock     := '';

          vNow     := FormatDateTime('dd/mm/yyyy hh:nn:ss',Now());
          Log.Log('Main', Dossiers.FieldByName('ServiceName').asstring, 'LastScan',vNow, logInfo, True, 0, ltServer);

          if vBoolUpdate
            then  vResult     := DataMod.EasyMvtKenabled(Dossiers.FieldByName('IBFile').asstring,vNbLignes);

          // Peut etre long ?  aucune idée
          if vBoolInsert
            then vResultInsert := DataMod.EasyMvtKenabled_INSERT(Dossiers.FieldByName('IBFile').asstring);

          if vBoolCorrupt then
            begin
              vCorrupt      := DataMod.DetectNodeIBCorrupt(Dossiers.FieldByName('IBFile').asstring);
            end;

          if vBoolDeadLock then
            begin
                vDeadLock := DataMod.DetectNodeIBDeadLock(Dossiers.FieldByName('IBFile').asstring);
            end;

          if vBoolUpdate then
            begin
              vloglvl := logInfo;
              if vResult<>'RAS' then
                begin
                    vLogLvl := logWarning;
                end;
              Log.Log('Main', Dossiers.FieldByName('ServiceName').asstring, 'MVTKENABLED',vResult, vlogLvl, True, 0, ltServer);
            end;

          if vBoolCorrupt then
            begin
                vloglvl := logInfo;
                if vCorrupt<>'' then
                  begin
                      vLogLvl := logError;
                  end;
                Log.Log('Main', Dossiers.FieldByName('ServiceName').asstring, 'Corrupt',vCorrupt, vLogLvl, True, 0, ltServer);
            end;

          if vBoolDeadLock then
            begin
              vloglvl := logInfo;
              if vDeadLock<>'' then
                begin
                    vLogLvl := logError;
                end;
              Log.Log('Main', Dossiers.FieldByName('ServiceName').asstring, 'Deadlock',vDeadLock, vLogLvl, True, 0, ltServer);
            end;

          if vBoolUnsent then
            begin
              vUnsentBatchs := DataMod.EasyUnsentBatchs(Dossiers.FieldByName('IBFile').asstring);
              for I := Low(vUnsentBatchs) to High(vUnsentBatchs) do
                begin
                    vloglvl := logInfo;
                    if vUnsentBatchs[i].DATACOUNT>100000 then
                      begin
                          vloglvl := logNotice;
                      end;
                    if vUnsentBatchs[i].DATACOUNT>500000 then
                      begin
                          vloglvl := logWarning;
                      end;
                    if vUnsentBatchs[i].DATACOUNT>1000000 then
                      begin
                          vloglvl := logError;
                      end;
                    Log.Log('',
                        'UnsentBatchs',
                        vUnsentBatchs[i].SenderNode.NOMPOURNOUS,
                        vUnsentBatchs[i].SenderNode.GUID,
                        vUnsentBatchs[i].SenderNode.SENDER,
                        'DataCount',
                        IntToStr(vUnsentBatchs[i].DATACOUNT), vLogLvl, True, 0, ltServer);
                    Log.Log('',
                        'UnsentBatchs',
                        vUnsentBatchs[i].SenderNode.NOMPOURNOUS,
                        vUnsentBatchs[i].SenderNode.GUID,
                        vUnsentBatchs[i].SenderNode.SENDER,
                        'OldestBatch',
                        vUnsentBatchs[i].OLDESTBATCH, vLogLvl, True, 0, ltServer);
                end;
            end;
          Dossiers.Edit;
          Dossiers.FieldByName('LastResult').asstring := vResult;
          Dossiers.FieldByName('Corrupt').asstring := vCorrupt;
          Dossiers.FieldByName('LastScan').asstring   := vNow;
          Dossiers.FieldByName('Deadlock').asstring := vDeadLock;
          Dossiers.FieldByName('LastResultInsert').asstring := vResultInsert;
          vStop := GetTickCount;
          vTimeScan := vStop - vStart;
          Dossiers.FieldByName('TimeScan').asinteger  := vTimeScan;


          Dossiers.Post;
          Dossiers.Next;
      end;
    Dossiers.EnableControls;
end;
}

procedure TForm18.BMVTClick(Sender: TObject);
begin
  SwitchOnOff;
end;


procedure TForm18.SwitchOnOff;
var vTemp:string;
begin
   BMVT.Enabled:=false;
   vTemp := BMVT.Caption;
   if vTemp=CST_START
    then
      begin
         seTimerJOUR.Enabled:=false;
         seTimerNUIT.Enabled:=false;
         FStart:=GetTickCount;
         FProgressTimer.Enabled:=true;
         // on est quand ? Jour ou Nuit ?
         if (Frac(Now())<CST_DEBUT_JOUR) or (Frac(Now())>CST_DEBUT_NUIT)
          then ProgressBar1.Max := CST_CYCLE*seTimerNUIT.value
          else ProgressBar1.Max := CST_CYCLE*seTimerJOUR.value;

         ProgressBar1.Position := 0;
         BMVT.Caption := CST_STOP;
         FCanClose    := false;
      end;
   if vTemp=CST_STOP
    then
      begin
         seTimerJOUR.Enabled:=true;
         seTimerNUIT.Enabled:=True;
         FProgressTimer.Enabled:=False;
         ProgressBar1.Position := 0;
         BMVT.Caption := CST_START;
         // On libère le Lock si on est Stop
         FLock        := False;
         // FCanClose    := true;
      end;
   BMVT.Enabled:=true;
end;


procedure TForm18.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Self.Hide;
  CanClose := not(FLock) and FCanClose;
end;

procedure TForm18.FormCreate(Sender: TObject);
var i:integer;
begin
   FCanClose := false;  // Seulement la reponse à la question autosie la fermeture
   FLock     := False;
   Log.App   := 'EasyScanLame';
   Log.Inst  := '' ;
   Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
   Log.SendOnClose := true ;
   Log.Open ;
   Log.SendLogLevel := logTrace;

   Log.Log('EasyScanLame', 'Main','Lancement', logInfo, True, 0, ltServer);

   // Log.Mag   := IntToStr(FInfosPassageDelos2EAsy.BAS_MAGID);
   // Log.Ref   := FInfosPassageDelos2EAsy.GUID;

   Refresh();

   Label1.Hint := FormatDateTime('hh:nn',CST_DEBUT_JOUR) + ' - ' + FormatDateTime('hh:nn',CST_DEBUT_NUIT);
   Label3.Hint := FormatDateTime('hh:nn',CST_DEBUT_NUIT) + ' - ' + FormatDateTime('hh:nn',CST_DEBUT_JOUR);

   BMVT.Caption := CST_START;

   For i:=1 to ParamCount do
    begin
        Caption := Caption + ' - Mode Auto';
        if Pos('auto',LowerCase(ParamStr(i)))>0 then
          begin
             SwitchOnOff;
          end;
    end;
end;

procedure TForm18.FormDestroy(Sender: TObject);
begin
//  if Assigned(FKENA) then FKENA.DisposeOf;
end;

procedure TForm18.FProgressTimerTimer(Sender: TObject);
var vPosition:integer;
begin
  FProgressTimer.Enabled:=false;
  vPosition := GetTickCount - FStart;
  ProgressBar1.Position := vPosition;
  // Suivant les cas....
  if (Frac(Now())<CST_DEBUT_JOUR) or (Frac(Now())>CST_DEBUT_NUIT)
     then ProgressBar1.Max := CST_CYCLE*seTimerNUIT.value
     else ProgressBar1.Max := CST_CYCLE*seTimerJOUR.value;
  //
  if vPosition>=ProgressBar1.Max then
       begin
         DoThread();
         // il ne faut pas activer le Timer..... on vient de lancer un thread
         exit;
        end;

    FProgressTimer.Enabled:=true;
end;

procedure TForm18.pOuvrirClick(Sender: TObject);
begin
  Self.Show;
  Application.BringToFront;
end;


procedure TForm18.pQuitterClick(Sender: TObject);
var vActif : boolean;  // variable locale pour savoir si lon était en actif avant la question
begin
  FLock := True;
  vActif := false;
  if BMVT.Caption=CST_STOP then
    begin
      vActif := true;
      SwitchOnOff;
    end;
  if Application.MessageBox('Voulez-vous quitter le programme ?', pchar(Self.Caption), MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDYES
  then
  begin
    FCanClose := true;
    FLock     := False;
    Close;
  end
  else
    begin
      // Si on était actif avant la question et si on répond non
      // il faut remettre l'état initial
      if vActif
        then SwitchOnOff;
    end;
end;

procedure TForm18.CallBackEnd(Sender:TObject);
begin
   ProgressBar1.Position := 0;
   FStart:=GetTickCount;
   FProgressTimer.Enabled:=true;
//   Dossiers.CloneCursor(TKENAThread(Sender).MemTable,True,False);
   Dossiers.EnableControls;
   FLock := False;
end;

procedure TForm18.DoThread();
begin
   FLock := true;
   Dossiers.DisableControls;
   FKENA  := TKENAThread.Create(Dossiers,CallBackEnd);
   FKENA.WMIPROC  := cbWMIPROC.Checked;
   FKENA.WMIIB    := cbWMIIB.Checked;
   FKENA.INSERT   := cbINSERT.Checked;
   FKENA.UPDATE   := cbUPDATE.Checked;
   FKENA.Corrupt  := cbCorrupt.Checked;
   FKENA.Unsent   := cbUnsent.Checked;
   FKENA.Deadlock := cbDeadlock.Checked;
   FKENA.Rows     := seROWS.Value;
   FKENA.Start;

end;

procedure TForm18.Refresh();
var i:integer;
    vID:integer;
begin
     vID := -1;
     Dossiers.DisableControls;
     Dossiers.Close;
     WMI_GetServicesSYMDS;
     GetDatabases;
     // Instances.Open;
     {
     for i:=0 to length(VGSYMDS)-1 do
        begin
          Instances.append;
          Instances.FieldByName('ID').asinteger         := i;
          Instances.FieldByName('ServiceName').asstring := VGSYMDS[i].ServiceName;
          Instances.FieldByName('PathName').asstring    := VGSYMDS[i].PathName;
          Instances.FieldByName('ConfigFile').asstring  := VGSYMDS[i].ConfigFile;
          Instances.FieldByName('Directory').asstring   := VGSYMDS[i].Directory;
          case CaseOfString(VGSYMDS[i].Status, ['Stopped','Running']) of
            0:Instances.FieldByName('Etat').asstring        := 'Arrêté';
            1:Instances.FieldByName('Etat').asstring        := 'En cours d''exécution';
            else Instances.FieldByName('Etat').asstring        := '?';
          end;
          Instances.FieldByName('NBBASES').AsInteger    := 0;
          Instances.FieldByName('SIZE').AsLargeInt      := 0;
          Instances.FieldByName('Ports').asstring       := Format('%d,%d,%d,%d',[
              VGSYMDS[i].http,VGSYMDS[i].https,VGSYMDS[i].jmxhttp,VGSYMDS[i].jmxagent]);
          Instances.post;
        end;
     }
     Dossiers.Open;
     for i:=0 to length(VGIB)-1 do
        begin
          if (FileExists(VGIB[i].DatabaseFile)) then
            begin
              Dossiers.append;
              Dossiers.FieldByName('ID').asinteger := i;
              Dossiers.FieldByName('EngineName').asstring  := VGIB[i].Nom;
              Dossiers.FieldByName('IBFile').asstring := VGIB[i].DatabaseFile;;
              Dossiers.FieldByName('ServiceName').asstring := VGIB[i].ServiceName;
              Dossiers.FieldByName('PropertiesFile').asstring := VGIB[i].PropertiesFile;
    //          Dossiers.FieldByName('Etat').asstring      := 'ERREUR FICHIER ABSENT';
              Dossiers.FieldByName('LastResult').asstring := '';
              Dossiers.FieldByName('LastScan').asstring   := '';
              Dossiers.post;
              //  IntToStr(NbTriggersSymDS(VGIB[i].DatabaseFile));
            end;
        end;
     Dossiers.EnableControls;
end;


procedure TForm18.TrayIcon1DblClick(Sender: TObject);
begin
  Self.Show;
  Application.BringToFront;
end;

end.




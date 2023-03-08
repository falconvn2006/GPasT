UNIT Ping_thread;

INTERFACE

USES
  idHttp,
  StdCtrls,
//  IAccesJetonLaunch,
  ScktComp,
  Windows,
  sysutils,
  SOAPHTTPClient,
  Classes;

TYPE
//------------------------------------------------------------------------------
  Tping = CLASS(TThread)
  PRIVATE
    FOnChange: TNotiFyEvent;
    PROCEDURE SetOnChange(CONST Value: TNotiFyEvent);
    { Déclarations privées }
  PROTECTED
    letemps : DWord;
    httpPing: TidHTTP;
    sResult : String;
    tsSource: TStrings;
    PROCEDURE Execute; OVERRIDE;
    PROCEDURE Change;
  PUBLIC
    LastOK: TDateTime;
    URL   : STRING;
    CONSTRUCTOR Create(URL: STRING; Temps: DWord);
    PROPERTY OnChange: TNotiFyEvent READ FOnChange WRITE SetOnChange;
  END;

//==============================================================================
  TPingResultEvent = procedure(Sender : TObject ; aUrl : string ; resultCode: integer ; resultMsg : string ; resultTime : integer) of object ;
//------------------------------------------------------------------------------
  TPingList = class(TThread)
  private
    slUrls : TStringList ;
    Http   : TIdHttp ;

    fOnPingResult : TPingResultEvent ;
    fOnFinish     : TNotifyEvent ;

    bStarted      : boolean ;
    lLock         : TRTLCriticalSection ;

    iError        : integer ;
    sMessage      : string ;
    iTime         : integer ;
    sUrl          : string ;

    procedure doPingResult ;
    procedure doFinish ;
  public
    constructor create ; reintroduce ;
    destructor destroy ; override ;

    procedure Execute ; override ;

    procedure AddUrl(aUrl : String) ;
    procedure Start ;
    procedure Stop ;
    procedure Clear ;
  published
    property onPingResult : TPingResultEvent read fOnPingResult write fOnPingResult ;
    property onFinish     : TNotifyEvent read fOnFinish write fOnFinish ;
    property Started      : boolean      read bStarted ;
  end;
//==============================================================================

IMPLEMENTATION

//==============================================================================
//==============================================================================
//==============================================================================
constructor TPingList.Create();
begin
    inherited create(true) ;

    slUrls := TStringList.Create ;

    InitializeCriticalSection(lLock) ;
    bStarted := false ;

    resume ;
end;
//------------------------------------------------------------------------------
destructor TPingList.Destroy;
begin
    Terminate ; resume ; waitfor ;

    DeleteCriticalSection(lLock) ;
    Http.Free ;
    slUrls.Free ;

    inherited ;
end;
//------------------------------------------------------------------------------
procedure TPingList.Execute;
var
  sParams : TStringList ;
  sResult : String ;
  cTime   : Cardinal ;
begin
    inherited ;

    sParams := TStringList.Create ;
    sParams.Add('Caller=TOTO') ;
    sParams.Add('Provider=TATA') ;

    while not Terminated do
    begin
        if not bStarted
          then Suspend ;

        if not Terminated then
        begin

          if slUrls.Count > 0 then
          begin

            sUrl := '' ;
            EnterCriticalSection(lLock) ;
            try
              sUrl := slUrls[0] ;
              slUrls.Delete(0) ;
            finally
              LeaveCriticalSection(lLock) ;
            end;

            if (sUrl <> '') then
            begin

                try
                  try
                    Http   := TIdHTTP.Create ;
                    Http.ConnectTimeout := 5000 ;
                    Http.ReadTimeout    := 5000 ;

                    cTime := getTickCount ;

                    sResult := Http.Post(sUrl, sParams) ;
                  finally
                    FreeAndNil(Http) ;
                  end;

                  if (Copy(sResult, 1, 4) = 'PONG') then
                  begin
                    iError := 0 ;
                    sMessage := 'Ok' ;
                  end else begin
                    iError := 1 ;
                    sMessage := 'Réponse invalide' ;
                  end;

                except
                  on E:Exception do
                  begin
                    iError := 1 ;
                    sMessage := 'Erreur de connexion : ' + E.Message ;
                  end;
                end ;

                iTime := getTickCount - cTime ;

                if Assigned(fOnPingResult)
                  then synchronize(doPingResult) ;

            end ;

          end else begin
            bStarted := false ;

            if Assigned(fOnFinish)
              then synchronize(doFinish) ;
          end;

        end;
    end;

    sParams.Free ;
end;
//------------------------------------------------------------------------------
procedure TPingList.doPingResult ;
begin
  if Assigned(fOnPingResult) then
  begin
    try
      fOnPingResult(self, sUrl, iError, sMessage, iTime) ;
    except
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TPingList.doFinish;
begin
  if Assigned(fOnFinish) then
  begin
    try
      fOnFinish(self) ;
    except
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TPingList.Start;
begin
  bStarted := true ;

  if self.Suspended
    then resume ;
end;
//------------------------------------------------------------------------------
procedure TPingList.Stop;
begin
   bStarted := false ;
end;
//------------------------------------------------------------------------------
procedure TPingList.AddUrl(aUrl: string);
begin
  aUrl := Trim(aUrl) ;
  if (aUrl = '') then Exit ;

  EnterCriticalSection(lLock) ;
  try
    if slUrls.IndexOf(aUrl) = -1 then
      slUrls.Add(aUrl) ;
  finally
    leaveCriticalSection(lLock) ;
  end;
end;
//------------------------------------------------------------------------------
procedure TPingList.Clear;
begin
  EnterCriticalSection(lLock) ;
  try
    slUrls.Clear ;
  finally
    leaveCriticalSection(lLock) ;
  end;
end;
//==============================================================================




//==============================================================================
//==============================================================================
//==============================================================================
{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

  Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

  procedure Tping.UpdateCaption;
  begin
  Form1.Caption := 'Mis à jour dans un thread';
  end; }

{ Tping }

PROCEDURE Tping.Change;
BEGIN
  FOnChange(Self);
END;

CONSTRUCTOR Tping.Create(URL: STRING; Temps: DWord);
BEGIN
  letemps  := Temps;
  Self.URL := URL;
  INHERITED Create(False);
END;

PROCEDURE Tping.Execute;
VAR
  LastAppel: DWord;
BEGIN
  { Placez le code du thread ici }
  LastAppel       := GettickCount - letemps;
  FreeOnTerminate := true;
  tsSource        := TStringList.Create;
  httpPing        := TidHTTP.Create(NIL);
  TRY
    LastOK        := Now;
    WHILE NOT Terminated DO
    BEGIN
      IF LastAppel < GettickCount THEN
      BEGIN
        LastAppel := GettickCount + letemps;
        tsSource.Add('Caller=TOTO');
        tsSource.Add('Provider=TATA');
        sResult := httpPing.Post(URL, tsSource);
        IF Copy(sResult, 1, 4) = 'PONG' THEN
        BEGIN
          LastOK := Now;
          IF assigned(FOnChange) THEN
            Synchronize(Change);
        END;
      END;
      Sleep(5000);
    END;
  FINALLY
    httpPing.free;
    tsSource.free;
  end;
END;

PROCEDURE Tping.SetOnChange(CONST Value: TNotiFyEvent);
BEGIN
  FOnChange := Value;
END;

{ TToken }


END.

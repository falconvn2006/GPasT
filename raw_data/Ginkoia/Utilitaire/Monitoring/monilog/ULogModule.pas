unit ULogModule;

interface

uses
   Classes, ActiveX;

{$M+}

Type
   TLogModule = class(TThread)
   private
     FHost : string;
     FFreq : integer;
     FNext : integer;
     procedure DoAfterTest;
   protected
     FModule : string;
     FStatus : string;
     FOnAfterTest: TNotifyEvent;
     FActiveX : Boolean;
     procedure Execute; override;
     procedure DoTest; virtual;
   public
     constructor Create(AHost: string; AFreq:integer; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
     procedure Test;
   published
     property OnAfterTest : TNotifyEvent read FOnAfterTest write FOnAfterTest;
     property Host        : string       read FHost        write FHost;
     property Module      : string       read FModule      write FModule;
     property Status      : string       read FStatus      write FStatus;
     property Freq        : integer      read FFreq        write FFreq;
     property Next        : integer      read FNext        write Fnext;
   end;

implementation

USes GestionLog;

constructor TLogModule.Create(AHost: string; AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited Create(false);
   FHost := AHost;
   FFreq := AFreq;
   Fnext := 0;
   FStatus := 'Create';
   FOnAfterTest :=ANotifyEvent;
   FActiveX:=false;
   FreeOnTerminate := False;
end;

destructor TLogModule.Destroy;
begin
   inherited;
end;

procedure TLogModule.Test;
begin
     FStatus := 'Resume';
     Resume;
end;

procedure TLogModule.DoTest;
begin
    //
    FStatus := 'DoTest';
    //
end;

procedure  TLogModule.DoAfterTest;
begin
   if Assigned(FOnAfterTest) then
     FOnAfterTest(self);
end;

procedure TLogModule.Execute;
begin
   try
     if FActiveX then
       CoInitializeEx(0, COINIT_MULTITHREADED);
     while not Terminated do
       begin
         Suspend;
         if not(Terminated) then
            begin
              DoTest;
              Synchronize(DoAfterTest);
              //
            end;
       end;
   finally
    If FActiveX then CoUnInitialize;
    // FRunning := false;
    // Synchronize(DoAfterPing);
   end;
end;


end.

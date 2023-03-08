unit UajaxThread;

interface

uses
   Classes, Uweb;

{$M+}

Type
   TAjaxThread = class(TThread)
   private
     FUrl : string;
     Fjson :string;
     FStatus : string;
     FDatas  : string;
     procedure DoAfterTest;
   protected
     FOnAfterTest: TNotifyEvent;
     procedure Execute; override;
     procedure DoTest; virtual;
   public
     constructor Create(Url: string;json :string; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
     procedure Test;
   published
     property OnAfterTest : TNotifyEvent read FOnAfterTest write FOnAfterTest;
     property Datas: string read FDatas write FDatas;
   end;

implementation

constructor TAjaxThread.Create(Url: string;json :string; ANotifyEvent: TNotifyEvent);
begin
   inherited Create(true);
   FUrl  := Url;
   FJson := json;
   FStatus := 'Create';
   FOnAfterTest :=ANotifyEvent;
   FreeOnTerminate := true;
end;

destructor TAjaxThread.Destroy;
begin
   inherited;
end;

procedure TAjaxThread.Test;
begin
     Resume;
end;

procedure TAjaxThread.DoTest;
begin
    FStatus := 'DoTest';
    FDatas:=GetURLAsString(FURL,FJson);
end;

procedure  TAjaxThread.DoAfterTest;
begin
   if Assigned(FOnAfterTest) then
     FOnAfterTest(self);
end;

procedure TAjaxThread.Execute;
begin
    try
      FreeOnTerminate := True;
      DoTest;
      Synchronize(DoAfterTest);
   finally
      FStatus := 'Execute.Finally';
    // Synchronize(DoAfterPing);
   end;
end;

end.


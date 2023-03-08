unit dlAsyncProcList;

interface

uses SysUtils, Classes, Messages, Windows;

type
  IAsyncResult = interface
    ['{F9491DFA-3EBD-4395-BA87-D78BC15AC136}']
    function GetError: String;
  end;

  TAsyncResult = class(TInterfacedObject, IAsyncResult)
    strict private
      FError: String;
    public
      constructor Create(AError: String = '');
    public
      function GetError: String;
  end;

  IAsyncObject = interface
    ['{047D5C4D-E4F4-4024-B1DC-7659625096A5}']
    procedure Run;
    procedure CallBack;
    function Data: Pointer;
  end;

  TAsyncProcRef         = reference to procedure(out AData: Pointer);
  TAsyncProcRefCallBack = reference to procedure(Sender: IAsyncObject);

  TAsyncObject = class(TInterfacedObject, IAsyncObject)
    strict private
      FProcRef        : TAsyncProcRef;
      FProcRefCallBack: TAsyncProcRefCallBack;

      FMessage: Cardinal;
      FHandle : THandle;

      FPointer: Pointer;
    public
      constructor Create(AProcRef: TAsyncProcRef); overload;
      constructor Create(AProcRef: TAsyncProcRef; AHandle: THandle = INVALID_HANDLE_VALUE;
        AMessage: Cardinal = 0); overload;
      constructor Create(AProcRef: TAsyncProcRef; ACallBack: TAsyncProcRefCallBack = nil); overload;
    public
      procedure Run;
      procedure CallBack;
      function Data: Pointer;
  end;

  TAsyncListOnError = procedure(Sender: IAsyncResult) of Object;
  TAsyncListOnEnd   = procedure of Object;
  TAsyncProcList = class(TThread)
    strict private
      FList: TInterfaceList;
    public
      constructor Create;
      destructor Destroy; override;
    public
      procedure Execute; override;
    public
      OnEndList: TAsyncListOnEnd;
      OnError  : TAsyncListOnError;
    public
      procedure Add(AAsyncObject: IAsyncObject);
      function Count: Integer;
  end;

var AsyncProcList: TAsyncProcList;

implementation

{ TAsyncProcList }

procedure TAsyncProcList.Add(AAsyncObject: IAsyncObject);
begin
  FList.Add(AAsyncObject);
end;

function TAsyncProcList.Count: Integer;
begin
  Result:= FList.Count;
end;

constructor TAsyncProcList.Create;
begin
  inherited Create(False);
  FreeOnTerminate:= False;
  FList:= TInterfaceList.Create;
end;

destructor TAsyncProcList.Destroy;
begin
  OnError  := nil;
  OnEndList:= nil;

  FreeAndNil(FList);
  inherited;
end;

procedure TAsyncProcList.Execute;
var Item: IAsyncObject;
begin
  while not Terminated do
  begin

    if FList.Count > 0 then
      try
        try
          if Supports(FList.First, IAsyncObject, Item) then
            Item.Run;

          Synchronize(nil, procedure begin
            Item.CallBack
          end);
        finally
          FList.Remove(FList.First);
        end;

        if Assigned(OnEndList) and (FList.Count < 1) then
          Synchronize(nil, OnEndList);

      except
        on e: exception do
          if Assigned(OnError) and (not Terminated) then
            OnError(TAsyncResult.Create(Format('TAsyncProcList.Execute: %s', [e.Message])));
      end;

    sleep(1);
  end;

end;

{ TAsyncObject }

constructor TAsyncObject.Create(AProcRef: TAsyncProcRef;
  AHandle: THandle = INVALID_HANDLE_VALUE; AMessage: Cardinal = 0);
begin
  FProcRef:= AProcRef;
  FProcRefCallBack:= nil;
  FMessage:= AMessage;
  FHandle:= AHandle;
end;

procedure TAsyncObject.CallBack;
begin
  if Assigned(FProcRefCallBack) then
    FProcRefCallBack(Self);
end;

constructor TAsyncObject.Create(AProcRef: TAsyncProcRef;
  ACallBack: TAsyncProcRefCallBack);
begin
  FProcRef:= AProcRef;
  FProcRefCallBack:= ACallBack;
  FMessage:= 0;
  FHandle := INVALID_HANDLE_VALUE;
end;

function TAsyncObject.Data: Pointer;
begin
  Result:= FPointer;
end;

constructor TAsyncObject.Create(AProcRef: TAsyncProcRef);
begin
  FProcRef:= AProcRef;
  FProcRefCallBack:= nil;
  FMessage:= 0;
  FHandle := INVALID_HANDLE_VALUE;
end;

procedure TAsyncObject.Run;
begin
  if not Assigned(FProcRef) then
    raise Exception.Create('Error call procedure');

  FProcRef(FPointer);

  if (FHandle <> INVALID_HANDLE_VALUE) and (FMessage > 0) then
    PostMessage(FHandle, FMessage, 0, NativeUInt(FPointer));
end;

{ TAsyncResult }

constructor TAsyncResult.Create(AError: String);
begin
  FError:= AError;
end;

function TAsyncResult.GetError: String;
begin
  Result:= FError;
end;

initialization
  AsyncProcList:= TAsyncProcList.Create;

finalization
  if Assigned(AsyncProcList) then
  begin
    AsyncProcList.Terminate;
    AsyncProcList.WaitFor;
    FreeAndNil(AsyncProcList);
  end;

end.

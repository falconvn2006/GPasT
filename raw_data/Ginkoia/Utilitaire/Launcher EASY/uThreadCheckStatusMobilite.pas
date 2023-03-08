unit uThreadCheckStatusMobilite;

interface

Uses Classes;

type
   TThreadSrvCheckStatusMobilite = class(TThread)
    private
      FStatus : integer;
      procedure Synchro;
    published
      constructor create;
      destructor Destroy();override;
      procedure Execute;override;
    public
    property Status : integer read FStatus write FStatus;
   end;

implementation

Uses ServiceControler, uMainForm;

{ TThreadSrvCheckStatusMobilite }

constructor TThreadSrvCheckStatusMobilite.create;
begin
  inherited;
  FreeOnTerminate := false;
end;

destructor TThreadSrvCheckStatusMobilite.Destroy;
begin
  Terminate;
  Resume;
  WaitFor;
  inherited;
end;

procedure TThreadSrvCheckStatusMobilite.Execute;
begin
  inherited;

  while not terminated do
  begin
    try
      FStatus := ServiceGetStatus('','GinkoiaMobiliteSvr');
      Synchronize(Synchro);
    except
    end;

    if not Terminated
      then sleep(5000);
  end;
end;

procedure TThreadSrvCheckStatusMobilite.Synchro;
begin
  try
     Frm_Launcher.MajMobilite(FStatus);
  except
  end;
end;


end.

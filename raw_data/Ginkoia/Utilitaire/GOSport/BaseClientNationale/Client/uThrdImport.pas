unit uThrdImport;

interface

uses
  Classes, Messages, SysUtils,windows;

const
  TH_MESSAGE  = WM_USER + 1; //Thread message
  TH_NEWLINE  = 1;           //Thread Submessage

type
  PThreadInfo = ^TThreadInfo;
  TThreadInfo = record
     ThreadId: Cardinal;
     MemoLine: string;
  end;

  TThrdImport = class(TThread)
  private
    FMemoLine:string;
  protected
    procedure UpdateMemo;
    procedure Execute; override;
    procedure SetMemoLine(AValue:string);
  public
    property MemoLine: string read FMemoLine Write SetMemoLine;
  end;

implementation

uses FrmMain;

{ TThrdImport }

procedure TThrdImport.Execute;
begin
  try
      MainFrm.SetImport;
  Except

  end;
end;

procedure TThrdImport.SetMemoLine(AValue:string);
begin
  FMemoLine:=AValue;
  Synchronize(UpdateMemo);
end;

procedure TThrdImport.UpdateMemo;
begin
  MainFrm.MemoImport.Lines.Add(MemoLine);
end;


end.

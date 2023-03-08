unit Parse;

interface

uses
  Classes, SysUtils, Windows,
  mudutil, HUtil32;

type
  TThreadParseList = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    IDStrList: TStringList;
    IPStrList: TStringList;
    IDList:    TQuickList;
    IPList:    TQuickList;
    BoFastLoading: boolean;
    //WorkingID, WorkingIP: Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  LMain;

{ TThreadParseList }

constructor TThreadParseList.Create;
begin
  IDStrList := TStringList.Create;
  IPStrList := TStringList.Create;
  IDList    := TQuickList.Create;
  IPList    := TQuickList.Create;
  BoFastLoading := False;
  //WorkingID := FALSE;
  //WorkingIP := FALSE;
  //FreeOnTerminate := TRUE;
  inherited Create(False);
end;

destructor TThreadParseList.Destroy;
begin
  IDStrList.Free;
  IPStrList.Free;
  IDList.Free;
  IPList.Free;
  inherited Destroy;
end;

procedure TThreadParseList.Execute;
var
  i, n, iday, ihour: integer;
  str, uid, uip, sday, shour: string;
  rtime: longword;
begin
  rtime := 0;
  while True do begin

    if GetTickCount - rtime > 5 * 60 * 1000 then begin
      rtime := GetTickCount;
      try
        if FileExists(FeedIDListFile) then begin
          IDStrList.Clear;
          IDStrList.LoadFromFile(FeedIDListFile);
          if IDStrList.Count > 0 then begin
            IDList.Clear;
            for i := 0 to IDStrList.Count - 1 do begin
              str   := Trim(IDStrList[i]);
              str   := GetValidStr3(str, uid, [' ', #9]);
              str   := GetValidStr3(str, sday, [' ', #9]);
              str   := GetValidStr3(str, shour, [' ', #9]);
              iday  := Str_ToInt(sday, 0);
              ihour := Str_ToInt(shour, 0);
              n     := MakeLong(_MAX(iday, 0), _MAX(ihour, 0));
              IDList.QAddObject(uid, TObject(n));
              if not BoFastLoading then
                if i mod 100 = 0 then
                  Sleep(1);
            end;
            FrmMain.MakeApply_ID_List(IDList);
          end;
        end;
      except
        ShowMsg('Exception] loading on IDStrList.');
      end;

      try
        if FileExists(FeedIPListFile) then begin
          IPStrList.Clear;
          IPStrList.LoadFromFile(FeedIPListFile);
          if IPStrList.Count > 0 then begin
            IPList.Clear;
            for i := 0 to IPStrList.Count - 1 do begin
              str   := Trim(IPStrList[i]);
              str   := GetValidStr3(str, uip, [' ', #9]);
              str   := GetValidStr3(str, sday, [' ', #9]);
              str   := GetValidStr3(str, shour, [' ', #9]);
              iday  := Str_ToInt(sday, 0);
              ihour := Str_ToInt(shour, 0);
              n     := MakeLong(_MAX(iday, 0), _MAX(ihour, 0));
              IPList.QAddObject(uip, TObject(n));
              if not BoFastLoading then
                if i mod 50 = 0 then
                  Sleep(1);
            end;

            FrmMain.MakeApply_IP_List(IPList);
          end;
        end;
      except
        ShowMsg('Exception] loading on IPStrList.');
      end;
    end;

    sleep(10);
    if Terminated then
      exit;
  end;
end;

end.

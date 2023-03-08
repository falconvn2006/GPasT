unit MonSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, ExtCtrls;

type
  TFrmMonSoc = class(TForm)
    MonSocket: TServerSocket;
    MonTimer:  TTimer;
    procedure FormCreate(Sender: TObject);
    procedure MonTimerTimer(Sender: TObject);
  private
  public
  end;

var
  FrmMonSoc: TFrmMonSoc;

implementation

{$R *.DFM}

uses
  MasSock;

procedure TFrmMonSoc.FormCreate(Sender: TObject);
begin
  with MonSocket do begin
    Active := False;
    Port   := 3000;
    Active := True;
  end;

end;

procedure TFrmMonSoc.MonTimerTimer(Sender: TObject);
var
  i, ccount:      integer;
  svname, sstate: string;
begin
  try
    ccount := FrmMasSoc.ServerList.Count;
    for i := 0 to FrmMasSoc.ServerList.Count - 1 do begin
      svname := PTMsgServerInfo(FrmMasSoc.ServerList[i]).ServerName;
      if svname <> '' then begin
        sstate := sstate + svname + '/' +
          IntToStr(PTMsgServerInfo(FrmMasSoc.ServerList[i]).ServerIndex) +
          '/' + IntToStr(PTMsgServerInfo(FrmMasSoc.ServerList[i]).UserCount) + '/';
        if GetTickCount - PTMsgServerInfo(FrmMasSoc.ServerList[i]).CheckTime <
          30 * 1000 then begin
          sstate := sstate + 'Good ;';
        end else
          sstate := sstate + 'Timeout ;';
      end else begin
        sstate := sstate + '-/-/-/-;';
      end;
    end;
    with MonSocket do begin
      for i := 0 to Socket.ActiveConnections - 1 do begin
        if Socket.Connections[i].Connected then
          Socket.Connections[i].SendText(IntToStr(ccount) + ';' + sstate);
      end;
    end;
  except
  end;
end;

end.

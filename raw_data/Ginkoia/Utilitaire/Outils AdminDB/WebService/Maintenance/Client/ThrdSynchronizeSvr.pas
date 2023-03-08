unit ThrdSynchronizeSvr;

interface

uses
  Classes, SysUtils, IdHTTP;

type
  TThrdSynchronizeSvr = class(TThread)
  private
  protected
    procedure Execute; override;
  end;

implementation

uses dmdClients;

procedure TThrdSynchronizeSvr.Execute;
var
  vIdHTTP: TIdHTTP;
begin
  try
    vIdHTTP:= dmClients.GetNewIdHTTP(nil);
    vIdHTTP.Get(GParams.Url + 'SynchronizeSVR');
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

end.

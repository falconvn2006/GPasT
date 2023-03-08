unit ThrdSynchronizeSvr;

interface

uses
  Classes, SysUtils, IdHTTP;

type
  TThrdSynchronizeSvr = class(TThread)
  private
    FTYPE_SYNC: String;
  protected
    procedure Execute; override;
  public
    property TYPE_SYNC: String read FTYPE_SYNC write FTYPE_SYNC;
  end;

implementation

uses dmdClients;

procedure TThrdSynchronizeSvr.Execute;
var
  vIdHTTP: TIdHTTP;
begin
  try
    vIdHTTP:= dmClients.GetNewIdHTTP(nil);
    vIdHTTP.Get(GParams.Url + 'Synchronize?TYPESYNC=' + FTYPE_SYNC);
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

end.

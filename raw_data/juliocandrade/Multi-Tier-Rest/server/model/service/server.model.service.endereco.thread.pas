unit server.model.service.endereco.thread;

interface

uses
  server.utils.thread.timer;
type
  TThreadAutalizaEnderecos = class
  private
    class var FThreadTimer : TThreadTimer;
  public
    class constructor Create;
    class destructor Finish;
    class procedure Start;
    class procedure Interval(aValue : Integer);
  end;
implementation

uses
  server.model.service.factory;

{ TThreadAutalizaEnderecos }

class constructor TThreadAutalizaEnderecos.Create;
begin
  FThreadTimer := TThreadTimer.Create(true);
  FThreadTimer.Interval(30000);
  FThreadTimer.OnTimer(
    procedure
    begin
      TServiceFactory.New.Endereco.AtualizarEnderecos;
    end);
end;

class destructor TThreadAutalizaEnderecos.Finish;
begin
  FThreadTimer.ForceTerminate;
  FThreadTimer.Free;
end;

class procedure TThreadAutalizaEnderecos.Interval(aValue: Integer);
begin
  FThreadTimer.Interval(aValue);
end;

class procedure TThreadAutalizaEnderecos.Start;
begin
  FThreadTimer.Start;
end;

end.

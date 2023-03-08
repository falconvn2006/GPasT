unit ThrdSuiviSrvReplication;

interface

uses
  Controls, Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF}, SysUtils, IdHTTP, u_Parser;

type
  TThrdSuiviSrvReplication = class(TThread)
  private
    FPRHO_SERVID: String;
    FParser: TParser;
    procedure SetName;
  protected
    procedure Execute; override;
  public
    property APRHO_SERVID: String read FPRHO_SERVID write FPRHO_SERVID;
    property AParser: TParser read FParser write FParser;
  end;

implementation

uses dmdClients, uTool;

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // doit être 0x1000
    FName: PChar;        // pointeur sur le nom (dans l'espace d'adresse de l'utilisateur)
    FThreadID: LongWord; // ID de thread (-1=thread de l'appelant)
    FFlags: LongWord;    // réservé pour une future utilisation, doit être zéro
  end;
{$ENDIF}

{ TThrdSuiviSrvReplication }

procedure TThrdSuiviSrvReplication.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'SuiviSrvReplication';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

procedure TThrdSuiviSrvReplication.Execute;
var
  vIdHTTP: TIdHTTP;
begin
  SetName;
  try
    vIdHTTP:= dmClients.GetNewIdHTTP(nil);                
    FParser:= TParser.Create(nil);
    FParser.ContentEncoding:= '';
    FParser.SizeField:= 2000;

    vIdHTTP.Disconnect;
    FParser.ARequest:= vIdHTTP.Get(GParams.Url + 'SuiviSrvReplication?SERV_ID=' + FPRHO_SERVID);
    FParser.Execute(True);

    FParser.ADataSet.First;
    FParser.ADataSet.Delete;
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

end.

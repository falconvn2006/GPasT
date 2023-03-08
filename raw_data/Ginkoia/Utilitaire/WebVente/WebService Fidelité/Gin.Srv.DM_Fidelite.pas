unit Gin.Srv.DM_Fidelite;

interface

uses System.SysUtils, System.Classes, System.Json, REST.Json,
    Datasnap.DSServer, Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter;

type
//==============================================================================
  TReturnCode = class
  private
    FCode : Integer ;
    FMsg  : string  ;
  published
    property Code : Integer     read FCode      write FCode ;
    property Msg  : string      read FMsg       write FMsg ;
  end;
//------------------------------------------------------------------------------
  TSecureKey = record
    Id   : string ;
    Date : TDateTime ;
    Hash : string ;
  end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
{$METHODINFO ON}
  TDM_Fidelite = class(TDataModule)
  private
    { Déclarations privées }
  public
    function Test : TJSONObject ;
  end;
{$METHODINFO OFF}
//==============================================================================

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


uses System.StrUtils;



{ TDM_Fidelite }

function TDM_Fidelite.Test: TJSONObject;
var
  vReturnCode : TReturnCode ;
begin
  Result := nil ;

  vReturnCode := TReturnCode.Create ;
  vReturnCode.Code := 200 ;
  vReturnCode.Msg  := 'OK' ;
  try
    Result := TJSON.ObjectToJsonObject(vReturnCode) ;
  finally
    vReturnCode.DisposeOf ;
  end;
end;

end.


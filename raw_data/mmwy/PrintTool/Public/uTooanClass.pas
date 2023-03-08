unit uTooanClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { ITooanIface }
  ITooanIface = interface(IUnknown)
  end;

  { TTooanClass }
  TTooanAbstractClass = class Abstract(TInterfacedObject, ITooanIface)
  end;

  { ITooanException }
  ITooanException = interface(ITooanIface)
    function GetErrorCode: integer;
    procedure SetErrorCode(const AErrorCode: integer);
    property ErrorCode: integer read GetErrorCode write SetErrorCode;
  end;

  { TTooanException }
  TTooanException = class(Exception, ITooanException)
  private
    FErrorCode: integer;
  protected
    function QueryInterface(constref IID: TGUID; out Obj): HResult; virtual; {$IFNDEF WINDOWS} cdecl{$ELSE} stdcall{$ENDIF};
    function _AddRef: integer; {$IFNDEF WINDOWS} cdecl{$ELSE} stdcall{$ENDIF};
    function _Release: integer; {$IFNDEF WINDOWS} cdecl{$ELSE} stdcall{$ENDIF};
  public
    constructor Create(AErrorCode: integer); overload;
    constructor Create(AErrorCode: integer; aErrorMessage: string); overload;
    destructor Destroy; override;

    function GetErrorCode: integer;
    procedure SetErrorCode(const AErrorCode: integer);

    property ErrorCode: integer read GetErrorCode write SetErrorCode;
  end;

implementation

{ TTooanException }
constructor TTooanException.Create(AErrorCode: integer);
begin
  Create(AErrorCode, 'UNKNOWN ERROR');
end;

constructor TTooanException.Create(AErrorCode: integer; aErrorMessage: string);
begin
  inherited Create(aErrorMessage);
  FErrorCode := AErrorCode;
end;

destructor TTooanException.Destroy;
begin
  inherited;
end;

procedure TTooanException.SetErrorCode(const AErrorCode: integer);
begin
  FErrorCode := AErrorCode;
end;

function TTooanException.GetErrorCode: integer;
begin
  Result := FErrorCode;
end;

function TTooanException.QueryInterface(constref IID: TGUID; out Obj): HResult; stdcall;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TTooanException._AddRef: integer;{$IFNDEF WINDOWS} cdecl{$ELSE} stdcall{$ENDIF};
begin
  Result := -1;
end;

function TTooanException._Release: integer;{$IFNDEF WINDOWS} cdecl{$ELSE} stdcall{$ENDIF};
begin
  Result := -1;
end;

end.

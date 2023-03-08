unit uDiagnosisCmd;

interface

uses
  uCommand,
  SysUtils;

type
  TDiagnosisCmd = class(TECRCommand)
  protected
    function getLength: string; override;
    function getDataBlock: string; override;
  public
    constructor Create; overload;

    function asString: string; override;
  end;

implementation

{ TDiagnosisCmd }

function TDiagnosisCmd.asString: string;
begin
  Result := 'Diagnosis (06 70)';
end;

constructor TDiagnosisCmd.Create;
begin
  inherited Create(Chr(06), AnsiChar(StrToInt('$70')));

  FCmdType := ecrcmdtMaster;
end;

function TDiagnosisCmd.getDataBlock: string;
begin
  Result := '';
end;

function TDiagnosisCmd.getLength: string;
begin
  Result := Chr(00);
end;

end.

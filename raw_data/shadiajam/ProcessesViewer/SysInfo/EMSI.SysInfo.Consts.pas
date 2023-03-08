unit EMSI.SysInfo.Consts;

interface

type
  TEMSI_Result = $0000..$FFFF;

const
  emsi_ValidResult = $0000;
  emsi_Unknown = $FFFF;

  /// Base Errors
  emsi_err_ListOutOfIndex = $0001;

  /// Processes Errors
  emsi_err_CreateToolhelp32Snapshot = $00A1;
  emsi_err_Process32First = $00A2;

  emsi_err_NoProcesssID = $00A3;
  emsi_err_ProcesssOpenError = $00A4;


function emsi_ErrorText(ErrorCode:TEMSI_Result):string;
implementation

function emsi_ErrorText(ErrorCode:TEMSI_Result):string;
begin
  Result := '';
  case ErrorCode of
    emsi_Unknown : Result := 'Unknown Error/Result';
    emsi_err_ListOutOfIndex : Result := 'List index out of index';
  end;
end;

end.

unit uFuncoes;

interface

uses Vcl.Dialogs;

  procedure MessageInfo(ATexto: String);
  procedure MessageErro(ATexto: String);
  procedure MessageWarning(ATexto: String);
  function MessageQuestion(ATexto: String): Integer;

implementation

procedure MessageInfo(ATexto: String);
begin
  MessageDlg(ATexto, TMsgDlgType.mtInformation, [mbOk], 0);
end;

procedure MessageErro(ATexto: String);
begin
  MessageDlg(ATexto, TMsgDlgType.mtError, [mbOk], 0);
end;

procedure MessageWarning(ATexto: String);
begin
  MessageDlg(ATexto, TMsgDlgType.mtWarning, [mbOk], 0);
end;

function MessageQuestion(ATexto: String): Integer;
begin
  Result := MessageDlg(ATexto, mtConfirmation, [mbYes, mbNo], 0, mbYes);
end;

end.

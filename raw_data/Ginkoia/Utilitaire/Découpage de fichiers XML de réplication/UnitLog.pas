unit UnitLog;

interface

uses System.Classes, System.SysUtils, Winapi.Windows;

type
  TLog = class(TThread)
    private
      _sFichier, _sLigne: String;
      _bNouveau: Boolean;

    protected
      procedure Execute;   override;

    public
      constructor Create(const sFichier, sLigne: String; const bNouveau: Boolean);
      procedure AjoutLog;
  end;

implementation

uses Unit1;

constructor TLog.Create(const sFichier, sLigne: String; const bNouveau: Boolean);
begin
  inherited Create(True);
  _sFichier := sFichier;
  _sLigne := sLigne;
  _bNouveau := bNouveau;
  FreeOnTerminate := True;
end;

procedure TLog.Execute;
begin
  AjoutLog;
  Terminate;
end;

procedure TLog.AjoutLog;
var
  F: TextFile;
begin
  if(not _bNouveau) and (not FileExists(_sFichier)) then
    Exit;

  EnterCriticalSection(MainForm._SectionCritiqueLog);
  try
    AssignFile(F, _sFichier);
    try
      if _bNouveau then
        Rewrite(F)
      else
        Append(F);

      Writeln(F, '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + ']  ' + _sLigne);
    finally
      CloseFile(F);
    end;
  finally
    LeaveCriticalSection(MainForm._SectionCritiqueLog);
  end;
end;

end.


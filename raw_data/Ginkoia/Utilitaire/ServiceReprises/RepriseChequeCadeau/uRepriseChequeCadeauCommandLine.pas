unit uRepriseChequeCadeauCommandLine;

interface

uses
  SysUtils, System.Classes, uRepriseChequeCadeauUtils;

type
  TRepriseChequeCadeauCommandLine = class
  private
    FAction: string;

    FMagasinOnCMDLine: boolean;
    FCMDMagId: integer;

    FDataBaseOncmdLine: boolean;

    FRepriseChequeCadeauUtils: TRepriseChequeCadeauUtils;

    procedure ShowHelp;
    procedure ReadCmdLineArgs;

    procedure InitLogs;
    procedure AddLog(ALogMessage: string);
    procedure RepriseChequeCadeauLog(Sender: TObject; ALogMessage: string);
  public
    constructor Create;
    destructor Destroy;

    procedure ParseCommandeLine;
    procedure Execute;
  end;

var
  FRepriseChequeCadeauCommandLine: TRepriseChequeCadeauCommandLine;

const
  helpActions: array[0..6] of AnsiString = ('?', '-?', '/?', '/h', '-h', '-help', '--help');
  cmlActions: array[0..0] of AnsiString = ('recoverckds');

implementation

uses
  uLogs, System.AnsiStrings;

{ TRepriseChequeCadeau }

procedure TRepriseChequeCadeauCommandLine.ShowHelp;
begin
  WriteLn('reprisechequecadeau.exe [ACTION] [OPTION]');
  WriteLn('[ACTION] : ');
  WriteLn('  - recoverckds : lance la reprise des chèques cadeaux saisis en mode déconnecté');
  WriteLn('    [OPTION] :');
  WriteLn('       - --magid : l''id ginkoia du magasin à traiter');
//  WriteLn('  - listmagasins : La liste des magasins');
//  WriteLn('  - wsurl : retourne l''url d''appel du webservice Easy2Play');
//  WriteLn('  - wsrunning : pour savoir si le webservice Easy2Play repond');
//  WriteLn('    [OPTION] :');
//  WriteLn('       - --magid(required) : l''id ginkoia du magasin à traiter');
end;

procedure TRepriseChequeCadeauCommandLine.ReadCmdLineArgs;
var
  i: integer;

  param: String;
  splitted: TArray<string>;

begin
  for i := 1 to ParamCount - 1 do
  begin
    param := ParamStr(i + 1);
    splitted := param.Split(['=']);
    if splitted[0] = '--magid' then
    begin
      FCMDMagId := StrToInt(splitted[1]);
      //TODO verifier que le magasin existe bien
      FMagasinOnCMDLine := True;
    end;
  end;
end;

procedure TRepriseChequeCadeauCommandLine.RepriseChequeCadeauLog(Sender: TObject;
  ALogMessage: String);
begin
  AddLog(ALogMessage);
end;

procedure TRepriseChequeCadeauCommandLine.ParseCommandeLine;
begin
  FAction := ParamStr(1);
  ReadCmdLineArgs;
  AddLog('Action : ' + FAction);
end;

procedure TRepriseChequeCadeauCommandLine.AddLog(ALogMessage: string);
begin
  Logs.AddToLogs(ALogMessage);
  WriteLn(ALogMessage);
end;

constructor TRepriseChequeCadeauCommandLine.Create;
begin
  FCMDMagId := 0;
  FMagasinOnCMDLine := False;
  FDataBaseOncmdLine := False;

  FRepriseChequeCadeauUtils := TRepriseChequeCadeauUtils.Create;
  FRepriseChequeCadeauUtils.OnLog := RepriseChequeCadeauLog;

  InitLogs;
  AddLog('Outil ligne de commande reprise cheques cadeaux');
end;

destructor TRepriseChequeCadeauCommandLine.Destroy;
begin
  FreeAndNil(FRepriseChequeCadeauUtils);
end;

procedure TRepriseChequeCadeauCommandLine.Execute;
var
  i: integer;
  list: TStringList;
begin
  ParseCommandeLine;

  if MatchStr(FAction, helpactions) or not MatchStr(FAction, cmlActions) then
  begin
    ShowHelp;
  end
  else
  begin

    if FAction = 'wsrunning' then
    begin
//      FEasy2PlayUtils.URL := FDataBaseUtils.getURL(FCMDMagId);
//      FEasy2PlayUtils.GUID := FDataBaseUtils.getGUID(FCMDMagId);
//      AddLog(BoolToStr(FEasy2PlayUtils.GetStatusWS.Error, True));
    end;

    if FAction = 'recoverckds' then
    begin
      if FMagasinOnCMDLine then
        FRepriseChequeCadeauUtils.RecoverMagCKDs(FCMDMagId)
      else
        FRepriseChequeCadeauUtils.RecoverBaseCKDs;
    end;

  end;

  AddLog('Traitement terminé');
end;

procedure TRepriseChequeCadeauCommandLine.InitLogs;
var
  sdate: string;
  path: string;
begin
  path := ExtractFilePath(ParamStr(0)) + '\logs\';
  if not DirectoryExists(path) then
  begin
    ForceDirectories(path);
  end;

  Logs.Path := path;
  DateTimeToString(sdate, 'yyyymmdd', Now());
  Logs.FileName := Format('reprisechequecadeaucommandlinelogs_%s.txt', [sdate]);
end;

end.

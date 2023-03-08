unit MegaIni;

{$mode objfpc}{$H+}
{
       Criado por Amaury Carvalho (amauryspires@gmail.com), 2019
}

interface

uses
  Classes, SysUtils, FileUtil, IniFiles;

type
    TMegaIni = class(TObject)
      private

      public
        TempPath, AppPath : string;
        WGetPath : string;
        DataPath : string;
        DataFileName : string;
        ImportMode : string;
        ImportURL : string;
        ImportJson : string;
        ImportFileName : string;
        BetsMaxSearch, BetsIgnoreLastHistory : integer;
        Slash : string;
        constructor Create;
        procedure Load;
        procedure Save;
      end;

implementation

constructor TMegaIni.Create;
begin
   inherited Create;
   Load;
end;

procedure TMegaIni.Load;
var oIni : TINIFile;
begin
   Slash := PathDelim;

   {$if defined(windows)}
        TempPath := GetTempDir;  {'C:\Temp';}
        AppPath := IncludeTrailingPathDelimiter(GetUserDir) + 'GMegaSena';
        WGetPath := 'wget.exe';
   {$else}
          TempPath := '/tmp';
          AppPath := IncludeTrailingPathDelimiter(GetUserDir) + '.GMegaSena';
          WGetPath := '/usr/bin/wget';
   {$ifend}
   DataPath := AppPath;
   DataFileName := 'gmegasena.csv';
   ImportMode := '0';
   ImportURL := 'http://www1.caixa.gov.br/loterias/_arquivos/loterias/D_megase.zip';
   ImportJson := 'https://servicebus2.caixa.gov.br/portaldeloterias/api/lotofacil';
   ImportFileName := 'D_MEGA.HTM';
   BetsMaxSearch := 10000;
   BetsIgnoreLastHistory := 0;

   if not DirectoryExists(AppPath) then
      CreateDir(AppPath);

   oIni := TINIFile.Create( IncludeTrailingPathDelimiter(AppPath) + 'gmegasena.ini' );

   Slash := oIni.ReadString('path', 'slash', Slash);
   TempPath := oIni.ReadString('path', 'temp', TempPath);
   AppPath := oIni.ReadString('path', 'app', AppPath);
   WGetPath := oIni.ReadString('path', 'wget', WGetPath);
   DataPath := oIni.ReadString('path', 'data', DataPath);
   DataFileName := oIni.ReadString('data', 'filename', DataFileName);
   ImportMode := oIni.ReadString('import', 'mode', ImportMode);
   ImportURL := oIni.ReadString('import', 'url', ImportURL);
   ImportJson := oIni.ReadString('import', 'json', ImportJson);
   ImportFileName := oIni.ReadString('import', 'filename', ImportFileName);
   BetsMaxSearch := oIni.ReadInteger('bets', 'max_search', BetsMaxSearch);
   BetsIgnoreLastHistory := oIni.ReadInteger('bets', 'ignore_last_history', BetsIgnoreLastHistory);

   if not DirectoryExists(DataPath) then
      CreateDir(DataPath);

   oIni.Free;
end;

procedure TMegaIni.Save;
var oIni : TINIFile;
begin
     oIni := TINIFile.Create( IncludeTrailingPathDelimiter(AppPath) + 'gmegasena.ini' );

     oIni.WriteString('path', 'slash', Slash);
     oIni.WriteString('path', 'temp', TempPath);
     oIni.WriteString('path', 'app', AppPath);
     oIni.WriteString('path', 'wget', WGetPath);
     oIni.WriteString('path', 'data', DataPath);
     oIni.WriteString('data', 'filename', DataFileName);
     oIni.WriteString('import', 'mode', ImportMode);
     oIni.WriteString('import', 'url', ImportURL);
     oIni.WriteString('import', 'json', ImportJson);
     oIni.WriteString('import', 'filename', ImportFileName);
     oIni.WriteInteger('bets', 'max_search', BetsMaxSearch);
     oIni.WriteInteger('bets', 'ignore_last_history', BetsIgnoreLastHistory);

     oIni.Free;
end;

end.


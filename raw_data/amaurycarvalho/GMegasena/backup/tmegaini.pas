unit TMegaIni;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IniFiles;

implementation

type
    TMegaIni1 = class(TObject)
      private

      public
        TempPath, AppPath : string;
        WGetPath : string;
        DataPath : string;
        DataFileName : string;
        Slash : c;
        procedure Load;
        procedure Save;
      end;

procedure TMegaIni1.Load;
begin

end;

procedure TMegaIni1.Save;
begin

end;

end.


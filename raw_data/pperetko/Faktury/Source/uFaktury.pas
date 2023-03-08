unit uFaktury;

interface
uses Classes, Inifiles,Vcl.Forms,SysUtils;

type
 TuFakturyParams=class
 private
   FConnectionString:string;
   function LoadParamsINI:boolean;
 public
   Constructor Create;
   property connectionString:string read FConnectionString;
 end;




implementation




constructor TuFakturyParams.Create;
begin
  LoadParamsINI;
end;

function TuFakturyParams.LoadParamsINI:boolean;
var
  IniFile:TIniFile;
begin
  result:=true;
  IniFile:=nil;
  try
    try
      IniFile:= TIniFile.Create( ExtractFileDir(Paramstr(0)) + '\' + 'faktury' + '.ini');
      FConnectionString:= IniFile.ReadString('Params','ConnectionString','');
    except
      result:=false;
    end;
  finally
    IniFile.Free;
  end;
end;

end.

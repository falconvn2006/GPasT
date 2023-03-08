unit uRegistryUtils;

interface

uses
  System.Win.Registry,
  Winapi.Windows;

  function GetBaseFilePath: string;

implementation

function GetBaseFilePath: string;
var
  reg: TRegistry;
begin
  try
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;

    if reg.KeyExists('\SOFTWARE\Algol\Ginkoia') then
    begin
      if reg.OpenKeyReadOnly('\SOFTWARE\Algol\Ginkoia') then
      begin
        result := reg.ReadString('Base0');
      end;
    end;
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

end.

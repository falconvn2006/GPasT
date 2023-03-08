unit uPermissions;

interface

uses
    System.Classes
    ,System.SysUtils
    ,System.StrUtils

    ,System.Permissions // Delphi Rio ou superior
    ,System.Generics.Collections


  {$IFDEF ANDROID}
  ,Androidapi.Helpers
  ,Androidapi.JNI.Os
  ,Androidapi.JNI.JavaTypes
  {$ENDIF}

  ;

type
    TMyPermissions = class
        private
            class function GetCamera: string; static;
            class function GetWifiState: string; static;
            class function GetReadExternalStorage: string; static;
            class function GetWriteExternalStorage: string; static;
            class function GetReadPhoneState: string; static;

        public
            class function RequestMyPermission(const APermission : TArray<System.string>): Boolean;

            class property Camera : string read GetCamera; //ReadOnly
            class property WifiState : string read GetWifiState;
            class property ReadExternalStorage : string read GetReadExternalStorage;
            class property WriteExternalStorage : string read GetWriteExternalStorage;
            class property ReadPhoneState : string read GetReadPhoneState;

    end;

implementation

{ TMyPermissions }

class function TMyPermissions.GetCamera: string;
begin
  {$IFDEF ANDROID}
    Result := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  {$ENDIF}


end;

class function TMyPermissions.GetReadExternalStorage: string;
begin
  {$IFDEF ANDROID}
    Result := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  {$ENDIF}

end;

class function TMyPermissions.GetReadPhoneState: string;
begin
  {$IFDEF ANDROID}
    Result := JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE);
  {$ENDIF}

end;

class function TMyPermissions.GetWifiState: string;
begin
  {$IFDEF ANDROID}
    Result := JStringToString(TJManifest_permission.JavaClass.ACCESS_WIFI_STATE);
  {$ENDIF}

end;

class function TMyPermissions.GetWriteExternalStorage: string;
begin
  {$IFDEF ANDROID}
    Result := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  {$ENDIF}

end;

class function TMyPermissions.RequestMyPermission(const APermission: TArray<System.string>): Boolean;
begin
    //
    PermissionsService.RequestPermissions(APermission,nil,nil);
    Result := true;

end;

end.

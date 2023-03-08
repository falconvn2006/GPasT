unit FDSqliteTypes;

interface

uses
  System.SysUtils, Classes, System.DateUtils;



type
   TListItemDataRegexReference = class
      public
         RegexID: Integer;
   end;

type
  TRegexsOrderBy = (robTitleAsc,
                    robTitleDesc,
                    robDateCreatedAsc,
                    robDateCreatedDesc,
                    robModifiedAsc,
                    robModifiedDesc,
                    robOpenCountAsc,
                    robOpenCoundDesc,
                    robSaveCountAsc,
                    robSaveCountDesc,
                    robRunCountAsc,
                    robRunCountDesc);

type
  TAppRegex = class
    Title: string;
    Expression: string;
    Flag_IgnoreCase: boolean;
    Flag_SingeLine: boolean;
    Flag_MultiLine: boolean;
    Flag_IgnorePatternSpace: boolean;
    Flag_ExplicitCapture: boolean;
    Flag_NotEmpty: boolean;
    DBExpressionID: Integer;

    Count_Open: Integer;
    Count_Save: Integer;
    Count_Run: Integer;

    DateCreated: Integer;
    DateModified: Integer;

  public
    Constructor Create;

  end;

type
  TAppSettingType = (astInteger, astString, astBool, astDateTime);

  TAppSetting = class
     SettingName: string;
     SettingValue: string;
     SettingType: TAppSettingType;
     SettingID: Int64;
  public
    function AsInt(Default: Int64 = 0): Int64;
    function AsString: string;
    function AsBool(Default: Boolean = false): Boolean;
    function AsDateTime: TDateTime;
    constructor Create(NewSettingName: string) overload;
  end;


type
  TDBSearchField = (sfDBProcessID, sfProcessPath);


implementation


constructor TAppRegex.Create;
begin
  self.DBExpressionID:=0;
end;

constructor TAppSetting.Create(NewSettingName: string);
begin

  SettingName:= NewSettingName;
  SettingType:=astInteger;
end;

function TAppSetting.AsInt(Default: Int64 = 0): Int64;
begin
   result:=StrToIntDef(self.SettingValue, Default);
end;

function TAppSetting.AsString: string;
begin
   result:=self.SettingValue;
end;

function TAppSetting.AsBool(Default: Boolean = false): Boolean;
begin
   if(Lowercase(self.SettingValue)='true') then
      result:=true
   else if(Lowercase(self.SettingValue)='false') then
      result:=false
   else
      result:=Default;
end;

function TAppSetting.AsDateTime: TDateTime;
begin
   result:=UnixToDateTime(self.AsInt(0), true);
end;

end.

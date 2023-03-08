unit FSP2KTypes;

interface

uses Classes;

type
  TIniStruct = record
    IsDebugMode : Boolean;
    dbDebugMode : String;
    lgDebugMode : String;
    pwDebugMode : String;
    ctDebugMode : String;

    Database : String;
    LoginDb : String;
    PasswordDb : String;
    CatalogDb : String;

    FedasFile : String;
    FedasRef  : Integer;
  end;

  TNomenclature = Record
    UNI_ID ,
    SEC_ID : Integer;
  End;

const
  CVERSION = '1.0';

var
  GAPPPATH : String;
  GLOGFILEPATH : String;
  GLOGFILENAME : String;
  IniStruct : TIniStruct;
  lstDbListDone : TStringList;
  bStopProg : Boolean;

implementation

end.

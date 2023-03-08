unit server.model.resource.interfaces;

interface

uses
  Data.DB,
  System.Classes;

type
  iRestParams = interface;
  iConexao = interface
    ['{DB069014-7641-47C0-903C-19C1F70E37ED}']
    function Connect : TCustomConnection;
    procedure Disconnect;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;

  end;

  iDataBaseConfig = interface
    ['{CA15298D-1C36-47C1-BBBA-7D7410D272AA}']
    function DriverID(aValue : String) : iDataBaseConfig; overload;
    function DriverID : String; overload;
    function Database(aValue : String) : iDataBaseConfig; overload;
    function Database : String; overload;
    function UserName(aValue : String) : iDataBaseConfig; overload;
    function UserName : String; overload;
    function Password(aValue : String) : iDataBaseConfig; overload;
    function Password : String; overload;
    function Port(aValue : String) : iDataBaseConfig; overload;
    function Port : String; overload;
    function Server(aValue : String) : iDataBaseConfig; overload;
    function Server : String; overload;
  end;

  iQuery = interface
    ['{81CDFB8B-7C76-4FC6-87A7-D9022BD49AFC}']
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iQuery;
    function ExecSQLArray(aParams : TArray<TParams>) : iQuery;
    function DataSet : TDataSet;
    function Open(aSQL : String) : iQuery; overload;
    function Open : iQuery; overload;
  end;

  iRest = interface
    ['{5CA7C6F6-39D1-4313-BAEA-15AEEF25C5D8}']
    function Content : string;
    function StatusCode : Integer;
    function Delete : iRest;
    function Get : iRest;
    function Params : iRestParams;
    function Post : iRest; overload;
    function Put : iRest;
  end;

  iRestParams = interface
    ['{4B13DC63-8CE0-4157-BBCD-59D595049504}']
    function BaseURL (aValue : string) : iRestParams; overload;
    function BaseURL : String; overload;
    function EndPoint (aValue : string) : iRestParams; overload;
    function EndPoint : String; overload;
    function Body(aValue : string) : iRestParams; overload;
    function Body : string; overload;
    function Accept(aValue : string) : iRestParams; overload;
    function Accept : string; overload;
    function &End : iRest;
  end;

  iResourceFactory = interface
    ['{6B7D5ABE-F5B7-4F32-BB3F-33409CF41B09}']
    function Query(aConexao : iConexao) : iQuery;
    function Conexao : iConexao;
    function Rest : iRest;
  end;

implementation

end.

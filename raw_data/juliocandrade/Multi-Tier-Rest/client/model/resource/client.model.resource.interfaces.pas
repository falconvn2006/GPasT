unit client.model.resource.interfaces;

interface

type
  iRestParams = interface;

  iRest = interface
    ['{5CA7C6F6-39D1-4313-BAEA-15AEEF25C5D8}']
    function Content : string;
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
  iServiceFactory = interface
    ['{9F24D8DE-A659-44B1-A43E-E45AC398DC3C}']
    function Rest : iRest;
  end;
implementation

end.

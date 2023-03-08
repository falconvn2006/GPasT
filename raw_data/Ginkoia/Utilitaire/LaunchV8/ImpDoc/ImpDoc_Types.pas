unit ImpDoc_Types;

interface

uses EuGen;

Type
  TTypFac = record
    Id : Integer;
    Lib : String;
  end;

  TGetIso = function (Mny: TMYTYP): STRING of object;
var
  GGKPATH  ,
  GIBPATH  ,
  GGKLOGS  ,
  GFACPATH : String;

  WorkInProgress : Boolean;

implementation

end.

unit uLogfile;
// *****************   version  pour Delphi 2007  *****************************//
// *****************   RD Janvier 2011            *****************************//
interface

uses Windows, Messages, SysUtils, Variants, Classes, Types ;


Type
    Tlogfile = Class(Tobject)     
    Public
      class var aList : Tstringlist ;
      class var bFifo : boolean ;   // si vrai on Insert(0) (plus récent au début) si faux on Add (plus récent à la fin)

      class function GetCount : integer ;
 

      class procedure Addline(sLine : string) ;
      class function GetLogAsString : string ;
      class procedure SaveToFile(sFile : string) ;
      class procedure SaveToFileAndClear(sFile : string) ;

      Class procedure InitLog(FiFo : boolean) ;
      Class procedure Reset ;
      
    End;


implementation

class procedure Tlogfile.InitLog(Fifo : boolean) ;
begin
  bFifo := fifo ; 
  aList := Tstringlist.Create ;
end;


class procedure Tlogfile.Reset;
begin
  aList.clear ;
  aList.Free ;
  aList := nil ;
end;

class procedure Tlogfile.Addline(sLine: string);
begin
  if bFifo then
    aList.Insert(0, sLine) else
      aList.Add(sLine)  ;
  
end;


class function Tlogfile.GetLogAsString : string;
begin
  if aList.Count > 0 then
   begin
     result := (aList.Text)
   end else result := '' ;
end;


class procedure Tlogfile.SaveToFile(sFile: string);
begin
  aList.SaveToFile(sFile);
end;

class procedure Tlogfile.SaveToFileAndClear(sFile: string);
begin
  aList.SaveToFile(sFile);
  aList.Clear ;
end;

class function Tlogfile.GetCount : integer ;
begin
 result := aList.Count ;
end;








end.

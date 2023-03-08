unit uLogfile;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Types, dateutils;


Type
    Tlogfile = Class(Tobject)     
    
    Private
      aList : Tstringlist ;

      Flogfile : string ; 
      
      function GetCount : integer ;
    Public

      bInsert : boolean ;   // si vrai on Insert(0) (plus récent au début) si faux on Add (plus récent à la fin)
    
      Constructor Create(Fifo : boolean) ;  virtual ;
      Destructor Free ;overload ; 

      procedure Addtext(sText : string) ;

      function GetLogAsString : string ;
      procedure SaveToFile(sFile : string) ;
      procedure SaveToFileAndClear(sFile : string) ;



      
      property Count : integer read GetCount ;
      property Fichierlog : string read Flogfile write Flogfile ;
      
      
    End;


implementation

Constructor Tlogfile.Create(Fifo : boolean) ;
begin
  bInsert := fifo ; 
  aList := Tstringlist.Create ;
end;


Destructor Tlogfile.Free;
begin
  aList.clear ;
  aList.Free ;
  aList := nil ;
end;



procedure Tlogfile.Addtext(sText: string);
var sl : string ;
begin
sL := '['+DateTimetostr(Now)+'] '+sText ;
  if bInsert = True then
    aList.Insert(0, sL) else
      aList.Add(sL)  ;
end;


function Tlogfile.GetLogAsString;
begin
  result := '';
  if aList.Count > 0 then
   begin
     result := aList.Text ;
   end;
end;


procedure Tlogfile.SaveToFile(sFile: string);
var y, m, d, h, mn, s, ms : word ;
    sDate : string ;
begin
Decodedatetime(Now, y, m, d, h, mn, s, ms) ;
sDate := inttostr(y)+' '+inttostr(m)+' '+inttostr(d)+'-'+inttostr(h)+' '+inttostr(mn) ;
ForceDirectories(sFile) ;
sFile := sFile+'Log_'+sdate ;
Flogfile := sFile ;
 if Alist.count>0 then
  aList.SaveToFile(sFile);
end;

procedure Tlogfile.SaveToFileAndClear(sFile: string);
begin
if Alist.Count >0 then
 begin
  Savetofile(sFile) ;
  aList.Clear ;
 end;
end;

function Tlogfile.GetCount : integer ;
begin
 result := aList.Count ;
end;








end.

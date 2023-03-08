unit uLogfile;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types,
     System.IOutils;


Type
    Tlogfile = Class(Tobject)     
    
    Private
      aList : Tstringlist ;
      bFifo : boolean ;   // si vrai on Insert(0) (plus récent au début) si faux on Add (plus récent à la fin)

      function GetCount : integer ;
    Public
      Constructor Create(Fifo : boolean) ;  overload ;
      Destructor Free ; overload ; 

      procedure Addline(sLine : string) ;
      function GetLogAsString : string ;
      procedure SaveToFile(sFile : string) ;
      procedure SaveToFileAndClear(sFile : string) ;

      property Count : integer read GetCount ;
      
      
    End;


implementation

Constructor Tlogfile.Create(Fifo : boolean) ;
begin
  bFifo := fifo ; 
  aList := Tstringlist.Create ;
end;


Destructor Tlogfile.Free;
begin
  aList.clear ;
  aList.Free ;
  aList := nil ;
end;

procedure Tlogfile.Addline(sLine: string);
begin
  if bFifo then
    aList.Insert(0, sLine) else
      aList.Add(sLine)  ;
  
end;


function Tlogfile.GetLogAsString;
begin
  if aList.Count > 0 then
   begin
     exit(aList.Text)
   end else exit('') ;
end;


procedure Tlogfile.SaveToFile(sFile: string);
begin
  aList.SaveToFile(sFile);
end;

procedure Tlogfile.SaveToFileAndClear(sFile: string);
begin
  aList.SaveToFile(sFile);
  aList.Clear ;
end;

function Tlogfile.GetCount : integer ;
begin
 exit(aList.Count) ;
end;








end.

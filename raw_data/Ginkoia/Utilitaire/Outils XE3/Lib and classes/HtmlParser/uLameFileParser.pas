unit uLameFileParser;

{* 5/10/2012 
  Unité pour extraire une liste des fichiers sur la lame .... /Algol/Bases 
  La liste se fait par analyse d'un fichier retourné par Tdownloadurl
  (fonction Delphi)
*}


interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types,
     System.IOutils, Vcl.ExtActns;



Type
   TDisplayCount = reference to procedure(Count : integer)  ; // procedure anonyme d'affichage du nbr de bases
   Tfilter = reference to function(sfile : String) : boolean ; // fonction ananyme pour filtrer le fichier 
                                             

   TLameFileParser = Class(Tobject)
    private
       aFiles  : Tstringlist ;
       sTempFile : string ;
       Fdone     : boolean ;
       sErrorMsg : string ;
       ptDisplayCount : TDisplayCount ;
       ptFilter   : Tfilter ;
       fUrl : string ;
       noFiles : boolean ;
     public
     Constructor Create(suRl : String) ;
     Destructor  Free ; overload ;


     function GetFiles(sExt : string) : Tstringlist ;
     function GetFile(iDent : string) : string ;

     property Done : boolean  read Fdone ;
     property ErrorMessage : string read sErrorMsg ;
     property Filename : string read sTempfile ;
     property DisplayCount : TDisplayCount read ptDisplayCount
       write ptDisplayCount ;
     property Filter : Tfilter write ptFilter ;
     property Url : string read Furl write furl ;
     property noFile : boolean read noFiles write noFiles ;

       
   End;


 Const
   ALL = 100000 ;   // pour le splittage du buffer
      


implementation


Constructor TLameFileParser.Create(sUrl: String);
begin
   furl := sUrl  ;
   sTempFile := Tpath.GetTempFileName ;
   aFiles := Tstringlist.Create ;
   
   With TdownloadUrl.Create(Nil) do
    begin
     Try
      URL := sUrl ;
      Filename := sTempFile ;
      Try
       ExecuteTarget(nil) ;
       Fdone := true ;
      Except
       ON E: Exception do
       begin
         sErrorMsg := E.Message ;
       end;
      End;
     Finally
       free ;
     End;
    end;
end;

function TLameFileParser.GetFiles(sExt : string) : Tstringlist ;
Var
   Memoryfile : Textfile ;
   Buffer, sHRef, sZip : string ;
   iStart, iEnd, k, ln : integer ;
begin
  AssignFile(Memoryfile, sTempfile) ;
  Try
    Reset(MemoryFile) ;
    sExt := Uppercase(sExt) ;  // '.ZIP' 
    while not EOF(Memoryfile) do
     begin
       Readln(Memoryfile, buffer);
       iStart := pos('<A HREF="', Uppercase(Buffer)) ;
       if iStart >0  then
        begin
         repeat
          
          buffer := Copy(buffer, iStart, ALL  ) ;
          iEnd := pos('</A', uppercase(buffer)) ;
          if iEnd > 0 then
           sHRef := Copy(Buffer,1, iEnd) else
            Shref := Copy(Buffer,1, length(Buffer)) ;
          
          if pos(sExt, uppercase(sHref)) > 0 then
            begin
              // c'est une base
              if sHref[1] = '<' then  sHref := Copy(sHref, 2, length(sHref)-1) ;
              k := pos('>', sHref) ;
              ln := pos('<', sHref)-k ;
              sZip := Copy(sHref,k+1,ln-1) ;
              // évalueation du filtre
              if Assigned(ptFilter) then
               begin
                 if ptfilter(sZip) then
                   aFiles.Add(sZip) ;
               end else aFiles.Add(sZip) ;

               if Assigned( ptDisplayCount) then
                  ptDisplayCount(aFiles.Count) ;
                     
            end;
          
          buffer := Copy(Buffer, iEnd+1, length(buffer)-(iEnd)) ;
          iStart :=  pos('<A HREF="', Uppercase(Buffer))
         until iStart = 0 ; 
        end;
     end;
  Finally
  End;
 if afiles.Count = 0  then 
  begin
    //pas de fichier connection ?
    noFiles := True ;
  end;
 Getfiles := aFiles ;
end;


function TLameFileParser.GetFile(iDent: string) : string ;
var sf : string ;
begin
 
  
 for sf in aFiles do
   begin
     if sf.Contains(iDent) = True then
      begin
        exit(sf) ;
      end;
   end;

end;

                               
Destructor TLameFileParser.Free;
begin
  
 if Assigned(aFiles) then
  begin
   aFiles.Clear ;
   aFiles.Free ;
   aFiles := nil ;
  end;
  

  
end;

end.             

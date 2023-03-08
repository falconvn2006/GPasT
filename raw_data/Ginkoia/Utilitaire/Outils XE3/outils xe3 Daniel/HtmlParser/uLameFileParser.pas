unit uLameFileParser;

{* 5/10/2012 
  Unité pour extraire une liste des fichiers sur la lame .... /Algol/Bases 
  La liste se fait par analyse d'un fichier retourné par Tdownloadurl
  (fonction Delphi)
*}


interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types,
     System.IOutils, Vcl.ExtActns,Generics.Collections;



Type
   TDisplayCount = reference to procedure(Count : integer)  ; // procedure anonyme d'affichage du nbr de bases
   TFilter_Perso = reference to function(sfile : String) : boolean ; // fonction ananyme pour filtrer le fichier
                                             

   TLameFileParser = Class
     public
       class var TlistFiles  : Tlist<String> ;
       class var TClientFiles : Tlist<String> ;
       class var TempFile : string ;
       class var Done     : boolean ;
       class var ErrorMsg : string ;
       class var DisplayCount : TDisplayCount ;
       class var Filter   : Tfilter_Perso ;
       class var Url : string ;
       class var noFile : boolean ;
       class var FiletoDownload : string ;
    

     class procedure SetUrl(sUrl : string) ;
     class function GetFiles(sExt : string) : TList<String> ;
     class function GetFile(iDent : string) : string ;
     class function GetClientFiles(iDent : string) : TList<String> ;
     class function GetFullFileToDownloadPath : string ;


       
   End;


 Const
   ALL = 100000 ;   // pour le splittage du buffer
      


implementation

class procedure TLameFileParser.SetUrl(sUrl: string);
begin
   url := sUrl  ;
   Tempfile := Tpath.GetTempFileName ;
   Tlistfiles := Tlist<String>.create ;
   TClientFiles := TList<String>.create ;
   With TdownloadUrl.Create(Nil) do
    begin
     Try
      URL := sUrl ;
      Filename := TempFile ;
      Try
       ExecuteTarget(nil) ;
       Done := true ;
      Except
       ON E: Exception do
       begin
         ErrorMsg := E.Message ;
       end;
      End;
     Finally
       free ;
     End;
    end;
end;

class function TLameFileParser.GetFiles(sExt : string) : TList<String> ;
Var
   Memoryfile : Textfile ;
   Buffer, sHRef, sZip : string ;
   iStart, iEnd, k, ln : integer ;
begin
  TLameFileParser.TlistFiles.Clear ;
  AssignFile(Memoryfile, Tempfile) ;
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
              if Assigned(Filter) then
               begin
                 if filter(sZip) then
                   TListfiles.Add(sZip) ;
               end else TListfiles.Add(sZip) ;

               if Assigned( DisplayCount) then
                  DisplayCount(TListFiles.Count) ;
                     
            end;
          
          buffer := Copy(Buffer, iEnd+1, length(buffer)-(iEnd)) ;
          iStart :=  pos('<A HREF="', Uppercase(Buffer))
         until iStart = 0 ; 
        end;
     end;
  Finally
  End;
 if TListfiles.Count = 0  then 
  begin
    //pas de fichier connection ?
    noFile := True ;
  end;
 Getfiles := Tlistfiles ;
end;


class function TLameFileParser.GetFile(iDent: string) : string ;
var sf : string ;
begin
 
 sf := ''; 
 for sf in Tlistfiles do
   begin
     if sf.Contains(iDent) = True then
      begin
        FiletoDownload := sf ;
        exit(sf) ;
      end;
   end;
 Getfile := sf ;
end;

class function TlamefileParser.GetClientFiles(iDent : String): TList<String> ;
var sf : string ;
begin
  TClientFiles.Clear ;
  for sf in Tlistfiles do
   begin
     if sf.Contains(iDent) = True then
      begin   
        TclientFiles.Add(sf) ;
      end;
   end;       
   GetClientFiles := TClientfiles ;
end; 

class function TlamefileParser.GetFullFileToDownloadPath;
begin
  if FileToDownload = '' then exit('') ;
  GetfullFileToDownloadPath := Url+FileToDownload ;
end;                            

end.             

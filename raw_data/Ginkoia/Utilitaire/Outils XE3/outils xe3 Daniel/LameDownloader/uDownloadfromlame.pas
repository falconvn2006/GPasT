unit uDownloadfromlame ;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types,
     System.IOutils, Vcl.ExtActns, System.DateUtils, uFunctions;



Type 
     TDisplayprogress = reference to procedure(Progress, ProgressMax :cardinal; StatusText: string; 
                        var Cancel :boolean; Pct2download : Integer )  ; // fonction anonyme d'affichage de la barre de progression

     TBeforeDownload = reference to procedure(Mode : integer) ;
     TAfterDownload = reference to procedure(Aborted, Error : boolean) ;       
     TBeforeReset  = reference to procedure(Mode : integer; Aborted , Error : boolean) ;            


      TLameFileDownloader = Class     
        Private 
           Class var Error : boolean ;
        Public        
         class var FileUrl  : string ;
         class var oDownloader : Tdownloadurl ;
         class var Done : boolean ;
         class var ErrorMsg : string ;
         class var Progress : TDisplayprogress ;
         class var AfterDownload : TAfterDownload ;
         class var BeforeDownload : TBeforeDownload ;
         class var BeforeReset : TBeforereset ;
         class var Localfile : string ;
         class var Hasbeenstopped : boolean ;
         class var iStart : cardinal ;
         class var tEstimated : TTime ;
         class var mode : integer ; // mode de chargement Lame ou URl
        
 
       
         class procedure SetUrl(sUrl : string );

         class procedure Downloadfile(FromMode : integer) ;
         class procedure DownloadEvent(Sender : TDownloadurl ; Progress, ProgressMax : cardinal ;
                                 StatusCode : TurlDownloadStatus; StatusText : string; var Cancel : boolean) ;
         class procedure Reset ;
         
      End;

implementation


Class procedure TLameFileDownloader.SetUrl(sUrl : string) ;
begin
  FileUrl := sUrl ;
  oDownloader := TDownLoadURL.Create(nil);
  oDownloader.OnDownloadProgress := DownloadEvent ;
  
end;



Class procedure TLameFileDownloader.Reset;
begin
  if Assigned(BeforeReset)then
   begin
     BeforeReset(Mode, HasbeenStopped,Error) ;
   end;
   oDownloader.Free ;
   oDownloader := nil ;
   FileUrl := '' ;
   LocalFile := '' ;
   Done := false ;
   ErrorMsg := '';
   Hasbeenstopped := False;
   iStart := 0;
   tEstimated := 0 ;
   mode := -1;
   Error := False ;
           
   
end;





class procedure TLameFileDownloader.Downloadfile(FromMode : integer) ;
var sPath : string ;
    sFile : string ;
    k : integer ;
begin

  Mode := FromMode ;
  k := (FileUrl.LastDelimiter('/')+1)  ;   // +1 pour base 0
  sFile := Copy(fileurl,k+1, length(FileUrl)-k) ; //  k+1 position après le dernier /
  
  sPath := Tpath.GetTempPath ;
  Localfile := IncludeTrailingPathDelimiter(sPath)+sFile ;
  Error := False ;
  
  With Odownloader do
   begin
     URL := FileUrl ;
     Filename := LocalFile ;
    
     try
       if Assigned(TLameFileDownloader.BeforeDownload) then
         TLameFileDownloader.BeforeDownload(FromMode );
       iStart := GetTickCount ;
       ExecuteTarget(nil) ;
       Done := true ;   
       if Assigned(TLameFileDownloader.AfterDownload) then
         TLameFileDownloader.AfterDownload(False, False) ;
     except on E: Exception do
       begin
        if Hasbeenstopped = False then
         begin
         // une erreur s'est produite
         ErrorMsg := E.Message ;
         Done := false ;
         Error := True ;
         if Assigned(TLameFileDownloader.AfterDownload) then
            TLameFileDownloader.AfterDownload(False, True) ;  
         end else 
         begin
          // arrêter par l'utilisateur
          Done := True ;
          if Assigned(TLameFileDownloader.AfterDownload) then
             TLameFileDownloader.AfterDownload(True, False) ;            
         end;
       end;
     end;
   end;
end;


class procedure TLameFileDownloader.DownloadEvent(Sender: TDownLoadURL; Progress: Cardinal; ProgressMax: Cardinal;
                  StatusCode: TURLDownloadStatus; StatusText: String; var Cancel: Boolean);
var pct, pcp : cardinal ;
begin
  if Assigned(TLameFileDownloader.Progress)  then
   begin
        Try
         if (Progress > 0) and (progressmax > 0)  then
           begin
          
            pcp :=  (progress*100) div progressmax ;
            pct := 100-pcp ;
           end else pct := 100 ;
        Except
        End;  
     
     TLameFileDownloader.Progress(Progress,ProgressMax, StatusText,  Cancel, pct) ;
     Hasbeenstopped := Cancel ;
   end;
end;


end.      

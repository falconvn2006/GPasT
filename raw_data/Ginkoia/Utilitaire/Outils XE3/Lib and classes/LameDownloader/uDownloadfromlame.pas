unit uDownloadfromlame ;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types,
     System.IOutils, Vcl.ExtActns, System.DateUtils, uFunctions;



Type 
     TDisplayprogress = reference to procedure(Progress, ProgressMax :cardinal; StatusText: string; 
                        var Cancel :boolean; Testimated : Ttime )  ; // fonction anonyme d'affichage de la barre de progression

     TBeforeDownload = reference to procedure(Sender : Tobject; Mode : integer) ;
     TAfterDownload = reference to procedure(Sender : Tobject ;Aborted, Error : boolean) ;       
     TBeforefree  = reference to procedure(Sender : Tobject; Mode : integer; Aborted , Error : boolean) ;            


      TLameFileDownloader = Class(Tobject)     
       Private
         sFileUrl  : string ;
         oDownloader : Tdownloadurl ;
         Fdone : boolean ;
         sErrorMsg : string ;
         ptProgress : TDisplayprogress ;
         ptAfterDownload : TAfterDownload ;
         ptBeforeDownload : TBeforeDownload ;
         ptBeforefree : TBeforefree ;
         sLocalfile : string ;
         bHasbeenstopped : boolean ;
         iStart : cardinal ;
         tEstimated : TTime ;
         Fmode : integer ; // mode de chargement Lame ou URl
        
       Public  
       
         Constructor Create(sUrl : string) ;
         Destructor Free ;

         procedure Downloadfile(FromMode : integer) ;
         procedure DownloadEvent(Sender : TDownloadurl ; Progress, ProgressMax : cardinal ;
                                 StatusCode : TurlDownloadStatus; StatusText : string; var Cancel : boolean) ;

         property Done : boolean  read Fdone ;
         property ErrorMessage : string read sErrorMsg ;
         property Progress : TDisplayprogress read ptProgress write ptProgress ;
         property AfterDownload : TAfterDownload read ptAfterDownload write ptAfterDownload ;
         property BeforeDownload : TBeforeDownload read ptBeforeDownload write ptBeforeDownload ;
         property Localfile : string read sLocalfile write sLocalfile ;
         property Beforefree : TBeforefree read ptBeforefree write ptBeforefree ;
         
      End;

implementation


Constructor TLameFileDownloader.Create(sUrl : string) ;
begin
  sFileUrl := suRl ;
  oDownloader := TDownLoadURL.Create(nil);
  oDownloader.OnDownloadProgress := DownloadEvent ;
end;

Destructor TLameFileDownloader.Free;
begin
  oDownloader.OnDownloadProgress := nil ;
  oDownloader.Free ;
  oDownloader := nil ;
  if Assigned(PtBeforefree) then
    PtBeforefree(Self, Fmode,bHasbeenstopped,Fdone ) ;
  
end;



procedure TLameFileDownloader.Downloadfile(FromMode : integer) ;
var sPath : string ;
    sFile : string ;
    k : integer ;
begin

  Fmode := FromMode ;
  k := (sFileUrl.LastDelimiter('/')+1)  ;   // +1 pour base 0
  sFile := Copy(sfileurl,k+1, length(sFileUrl)-k) ; //  k+1 position après le dernier /
  
  sPath := Tpath.GetTempPath ;
  sLocalfile := IncludeTrailingPathDelimiter(sPath)+sFile ;

  
  With Odownloader do
   begin
     URL := sFileUrl ;
     Filename := sLocalFile ;
     try
       if Assigned(ptBeforeDownload) then
         ptBeforeDownload(Self, FromMode );
       iStart := GetTickCount ;
       ExecuteTarget(nil) ;
       Fdone := true ;   
       if Assigned(ptAfterDownload) then
         ptAfterDownload(Self ,False, False) ;
     except on E: Exception do
       begin
        if bHasbeenstopped = False then
         begin
         // une erreur s'est produite
         sErrorMsg := E.Message ;
         Fdone := false ;
         if Assigned(ptAfterDownload) then
            ptAfterDownload(Self ,False, True) ;  
         end else 
         begin
          // arrêter par l'utilisateur
          Fdone := True ;
          if Assigned(ptAfterDownload) then
             ptAfterDownload(Self ,True, False) ;            
         end;
       end;
     end;
   end;
end;


procedure TLameFileDownloader.DownloadEvent(Sender: TDownLoadURL; Progress: Cardinal; ProgressMax: Cardinal;
                  StatusCode: TURLDownloadStatus; StatusText: String; var Cancel: Boolean);
var s : string ;                  
    k, Delta : cardinal ;
    pct, pcp : extended ;
begin
  if Assigned(ptProgress )  then
   begin
        k := GetTickCount ;
        Delta :=k-iStart ;
        Try
         if (Progress > 0) and (progressmax > 0) then
           begin
            pcp :=  (progress*100) div progressmax ;
            pct := 100-pcp ;
            if pcp > 0 then
            begin
              Try
                  Delta :=  (Delta * Trunc(Pct)) div (Trunc(pcp))  ;
                 tEstimated := GetTimefromMsc(Delta) ;
              Except
              End;
            end ;
           end else
            Begin
             Delta := 0 ;
             tEstimated := 0 ;
            End;
        Except
        End;  
     
     ptProgress(Progress, ProgressMax, StatusText,  Cancel, tEstimated) ;
     bHasbeenstopped := Cancel ;
   end;
end;


end.      

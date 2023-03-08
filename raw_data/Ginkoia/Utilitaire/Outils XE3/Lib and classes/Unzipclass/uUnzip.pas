unit uUnzip;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types,
     System.IOutils, Vcl.ExtActns, Zipforge;


 
     
Type
   Tdisplayfiletoextract = reference to procedure(sFilename : string) ;
   TOverallprogress = reference to procedure(Progress: Double;
                      Operation: TzFprocessOperation; ProgressPhase: TZfProgressPhase;
                      var Cancel: Boolean) ;    
    TGetpassword  = reference to procedure(Sender: Tobject; Filename:String;var NewPassword: Ansistring;
                var Skipfile: Boolean) ;   
    TEndOfprocess  = reference to function(sPath : string) : boolean ;   
    TOnError = reference to procedure(Sender: Tobject; Filename: string; 
                  Operation: TZFProcessOperation; NativeError, ErrorCode : integer;
                  ErrorMessage: string; var Action: TZFAction);
    TOnFilePogress = reference to procedure(Progress: Double; Filename :String;
                      Operation: TzFprocessOperation; ProgressPhase: TZfProgressPhase;
                      var Cancel: Boolean) ;                        
                 
   Tunzip = Class(Tobject) 
    Private
      oZip : Tzipforge ;
      ptDisplayfiletoextract :  Tdisplayfiletoextract ; 
      ptOverAllProgress :  TOverallprogress;
      ptOnFileProgress : TOnFilePogress ;
      ptGetpassword : Tgetpassword ;
      ptEndOfProcess : TEndOfprocess ;
      ptOnError : TOnError ;
      sFilter : string ;
      Ftransaction : boolean ;
      Fstop : boolean ;
      Fpassword : string;
      Fcount : integer ;
      Fdestination : string ;
      
      procedure zExtractfile(Sender : Tobject; var Filename:string;
              var FileAttr : cardinal; const Comment : Ansistring) ;
      procedure zOverAllProgress(Sender: Tobject; Progress: Double;
               Operation: TzFprocessOperation; ProgressPhase: TZfProgressPhase;
               var Cancel: Boolean) ;        
      procedure zFileprogress(Sender:    TObject;FileName:    WideString; 
                  Progress:    Double; Operation:    TZFProcessOperation; 
                  ProgressPhase: TZFProgressPhase; var Cancel:    Boolean ) ;         
      procedure zPassword(Sender: Tobject; Filename:String;var NewPassword: Ansistring;
                var Skipfile: Boolean) ;  
      procedure zOnError(Sender: Tobject; Filename: string; 
                  Operation: TZFProcessOperation; NativeError, ErrorCode : integer;
                  ErrorMessage: string; var Action: TZFAction);                
      function zGetCountfiles : integer ;            

      procedure SetDestination(sDestination : string) ;            

    Public
    
    
      Constructor Create(sZip, sDestination : string) ;  overload ;
      Destructor Free ; overload ;

      procedure Unzipit ;



      property Displayfiletoextract : Tdisplayfiletoextract read ptDisplayfiletoextract 
               write ptDisplayfiletoextract ;        
      property OverAllProgress :  TOverallprogress read ptOverAllProgress
                write ptOverAllProgress;
      property OnFileProgress : TOnFilePogress read ptOnFileProgress write
                     ptOnFileProgress ;          
      property Getpassword : TGetpassword read ptGetpassword write ptGetpassword ;       
      property OnEndOfProcess : TEndOfprocess read ptEndOfProcess write ptEndOfProcess ;
         
      property Filestoextract : string read sFilter write sFilter ;
     
      property Transaction : boolean write Ftransaction ;
      property Stop : boolean write Fstop ;
      property Count : integer read zGetCountfiles write Fcount  ;

      property Destination : string read Fdestination write SetDestination ;
      
   End;

     
implementation

Constructor Tunzip.Create(sZip: string; sDestination: string);
begin
   oZip := Tzipforge.Create(nil);
   oZip.Zip64Mode := zmAlways ;
   ozip.UnicodeFilenames := True ;
   
   oZip.Options.Create ;
   oZip.Options.Recurse := True ;
   oZip.Options.OverwriteMode := omAlways ;
   oZip.Options.CreateDirs := True ;
   oZip.Options.ReplaceReadOnly := True ;
   oZip.Options.SetAttributes := True ;
   oZip.Options.SearchAttr := 10431 ;
   oZip.Options.FlushBuffers := True ;
   oZip.Options.OEMFileNames := True ;
   oZip.Options.ShareMode := smShareDenyNone ;
   oZip.Options.StorePath := spRelativePath ;
   
   oZip.FileName := sZip ;
   oZip.BaseDir := sDestination ;
   oZip.OnExtractFile := zExtractfile ;
   oZip.OnOverallProgress := zOverAllProgress ;
   oZip.OnPassword := zPassword;
   ozip.OpenArchive ;
   Fcount := oZip.FileCount ;
   Fdestination := sDestination ;
   ozip.CloseArchive ;

   Ftransaction := False ;
   
end;


procedure Tunzip.SetDestination(sDestination: string);
begin
  Fdestination := sDestination ;
  oZip.BaseDir := Fdestination ;
end;

Destructor Tunzip.Free;
begin
  oZip.Free ;
  oZip := nil ;
end;



function Tunzip.zGetCountfiles;
begin
  zGetCountFiles := Fcount ;
end;

procedure Tunzip.zExtractfile(Sender: TObject; var Filename: string; var FileAttr: Cardinal; const Comment: AnsiString);
begin
    if Assigned(ptDisplayfiletoextract) then
     begin
       ptDisplayfiletoextract(Filename) ;
     end;
  
end;


procedure Tunzip.zOverAllProgress(Sender: TObject; Progress: Double; Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
   if Assigned(ptOverAllProgress) then
    begin
      ptOverAllProgress(Progress, OPeration,ProgressPhase,Cancel) ;
    end;
   Cancel := Fstop ;
end;


procedure Tunzip.zFileprogress(Sender: TObject; FileName: WideString; Progress: Double; Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  if Assigned(ptOnFileProgress) then
   begin
     ptOnFileProgress(Progress,Filename, Operation,ProgressPhase,Cancel) ;
   end;
  
end;

procedure Tunzip.Unzipit;
var sDestination, sBaseDir : string ;
begin
Try
   if Ftransaction = True then
    begin
      sDestination := oZip.BaseDir ;
      sBaseDir := sDestination+'~' ;
      oZip.BaseDir := sBaseDir ;
      ForceDirectories(sBaseDir) ;
    end;

  oZip.OpenArchive ;
  oZip.ExtractFiles(sFilter) ;
  oZip.CloseArchive ;
Finally
 if Fstop = True then
  begin
    TDirectory.Delete(sBaseDir, True);
  end;
  if Assigned(ptEndOfProcess) then
   begin
     if ptEndOfProcess(sBaseDir)  = True then
      begin
        if Ftransaction = True then
         begin
           Tdirectory.Delete(sDestination,True);
           repeat
              Sleep(1000) ;
           until  TDirectory.Exists(sDestination) = false ;
           TDirectory.Move(sBaseDir, sDestination);
           repeat
              Sleep(1000) ;
           until TDirectory.Exists(sDestination) = True  ;
         end;
        
      end;
   end;
  
    
End;
end;


procedure Tunzip.zPassword(Sender: TObject; Filename: string; var NewPassword: AnsiString; var Skipfile: Boolean);
begin
  if (Assigned(ptGetpassword)) and (Fpassword.IsEmpty = True) then
    begin
      ptGetpassword(Sender, Filename, NewPassWord, Skipfile) ;
      Fpassword := NewPassWord ;
    end else
    begin
      if Fpassword.IsEmpty = False then  NewPassword := Fpassword  ;
    end;
end;

procedure Tunzip.zOnError(Sender: TObject; Filename: string; Operation: TZFProcessOperation; NativeError: Integer; ErrorCode: Integer; ErrorMessage: string; var Action: TZFAction);
begin
   if Assigned(ptOnerror) then
    begin
      ptOnError(Sender, Filename,Operation,NativeError,ErrorCode,ErrorMessage,Action) ;
    end;
end;


end. 

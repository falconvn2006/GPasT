unit uFunctions;

interface

Uses 
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes ;

CONST
 RST_SYSTEM_32 = '32 bits' ;
 RST_SYSTEM_64 = '64 bits' ; 
 RST_VERSION = 'Version :' ;




Function GetInfoSystem : string ; 
Function GetVersion(sExename : string; Handle :cardinal) : string ;
function IsVistaOrHigher : boolean ;
function IsAvalidtype(Drive : String) : boolean;
function Is64bits : boolean ;


function GetTimefromMsc(var Msecs: cardinal) : Ttime ;  // var pour test

implementation


Function GetInfoSystem : string ;
var sSystem : string ;
begin
   if  Tosversion.Platform = pfWindows Then
   begin
     sSystem := Tosversion.Name ;
     if TOSVersion.Architecture = arIntelX64 then
       sSystem := sSystem+' '+RST_SYSTEM_64 else 
         sSystem := sSystem+' '+RST_SYSTEM_32 ;

     sSystem := sSystem+' '+IntTostr(Tosversion.Build)+' '+Inttostr(TOSVersion.ServicePackMajor)+
     ' '+Inttostr(Tosversion.ServicePackMinor) ;    
   end;
   exit(sSystem) ;
   
end ;


Function Is64Bits  : boolean ;
begin
  exit(TOSversion.Architecture = arIntelX64) ;
end;


Function GetVersion(sExename : string; Handle :cardinal) : string ;
const Infok =11 ;
      InfoStr : array[1..Infok] of String =
      ('CompanyName','FileDescription','FileVersion','InternalName','LegalCopyRight', 
       'LegalTradeMarks','OriginalFilename','ProductName','ProductVersion','Comments',
       'Author') ;
var k,i : integer ;      
    Len : cardinal ;
    Buff, Value : Pwchar ;
begin
 {* basée sur la fonction de Zarko Gajic Versioninformation *}
 
 k := GetFileVersionInfoSizeW(Pwchar(sExename),Handle)  ;
 if k > 0 then
  begin
    Try
    Buff := Allocmem(k) ;
    GetFileVersionInfoW(PWchar(sExename),0,k,buff) ;
    for i := 1 to Infok do
     begin
       if VerQueryValueW(Buff,Pwchar('StringFileInfo\040904E4\'+InfoStr[i]),
          Pointer(Value), Len) then
          begin
            if i = 3 then
             begin
               Value := Pwchar(Trim(Value)) ;
               break ;
             end;
          end;
          
     end;
    Finally
      Freemem(buff, k) ;
    End;
    exit(RST_VERSION+' '+String(value)) ;  
  end else Exit('') ;
 
end;

function IsVistaOrHigher : boolean ;
begin
 exit(TOSversion.Major>5) ; // Vista 6.0 Seven 6.1
end;


function IsAvalidtype(Drive : String) : boolean;
begin
   case GetDriveType(PWChar(Drive)) of
    DRIVE_REMOVABLE:
     exit(false) ;
    DRIVE_FIXED:
     exit(True);
    DRIVE_REMOTE:
     exit(True);
    DRIVE_CDROM:
     exit(false) ;
    DRIVE_RAMDISK:
     exit(false) ;
    end;
end;


function GetTimefromMsc(var Msecs: cardinal) : Ttime ;
const 
     secondTicks = 1000;
     minuteTicks = 1000 * 60;
     hourTicks = 1000 * 60 * 60;
     dayTicks = 1000 * 60 * 60 * 24;
var  k : cardinal ;
     ZD, ZH, ZM, ZS: Integer;    
begin
Try
  ZD := mSecs div dayTicks;
  Dec(mSecs, ZD * dayTicks) ;
  ZH := mSecs div hourTicks;
  Dec(mSecs, ZH * hourTicks) ;
  ZM := mSecs div minuteticks;
  Dec(mSecs, ZM * minuteTicks) ;
  ZS := mSecs div secondTicks;

  result := EncodeTime(zh,zm,zs,0) ;
Except
End;
end;

end.

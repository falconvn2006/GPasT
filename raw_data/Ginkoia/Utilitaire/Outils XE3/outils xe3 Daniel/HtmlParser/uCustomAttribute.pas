unit uCustomAttribute;

interface
 uses System.SysUtils ;


Type
   TcustomUrl = Class(Tcustomattribute) 
     private
       Furl : String ;
     public
       Constructor Create(sUrl : string) ;  
       
   End;
   
       

implementation
Constructor TcustomUrl.Create(sUrl: string);
begin
   Furl := sUrl ;
end;

end.

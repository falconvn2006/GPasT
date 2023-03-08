unit maintestsp2k;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, r2d2, StdCtrls, IdMessage, IdAttachment,  IdText,
        IdAttachmentfile, IdBaseComponent ;

type
  TForm4 = class(TForm)
    Btn_test: TButton;
    Memo1: TMemo;
    procedure Btn_testClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Btn_testClick(Sender: TObject);
var s : string ;
   Account : Taccount ;
   oPop3 : Tpop3Client ;
   k, i : integer ;
   sf : string ;
   idMess : Tidmessage ; 
   dd, df : string ;
   ddb, ddf : Tdatetime ;
begin
(*
     Account := Taccount.Create('reservation.twinner@ginkoia.fr', 'Touiner@74','');
     Account.Port := 995 ;
     Account.Host := 'pod51015.outlook.com' ;
     oPop3 := Tpop3Client.Create(Account, True);
     opop3.PrepareUserPass ;
     oPop3.connect ;
     idMess := Tidmessage.create(self) ;
     if oPop3.Connected then
      begin
        k := opop3.Checkmessages ;
        for i := 1 to k do
        
        begin
           oPop3.Pop3.Retrieve(i, idMess) ;
           Decodemessage(idMess, 'C:\Developpement\Ginkoia\UTILITAIRE\RIM-Location\MailImportTmp',2) ;
        end;
      end ;
     Account.free ;
     oPop3.Free ;
     idmess.Free ;
*)
    ddb := now ;
    ddf := now ;

    dd := '12/01/2012' ;
    df := '13/01/2012' ;
    
    ddb := StrTodate(dd) ;
    ddf := StrToDate(df) ;    

    sleep(1000) ;
end;

end.

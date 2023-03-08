unit Uessai;

interface

uses
  Soap_Sp2000,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton,xmlhttp;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    LMDSpeedButton1: TLMDSpeedButton;
    LMDSpeedButton2: TLMDSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure LMDSpeedButton1Click(Sender: TObject);
    procedure LMDSpeedButton2Click(Sender: TObject);
  private
    { Déclarations privées }
    FXMLHTTP: TXMLHTTP;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  ts : TSoapSp2000 ;
  tc : TClientSp2000 ;
  tcoup : TCouponSp2000 ;
  i : integer ;
begin
  ts := TSoapSp2000.create ;
  IF ts.Site_Up then
     memo1.lines.Text := 'Site up'
   ELSE
     memo1.lines.Text := 'Site down' ;
  tc := ts.InfoClt ('pascal','1254664');
  memo1.lines.add ('CLIENT ' ) ;
  memo1.lines.add (' code retour : '+ts.traduit_code_retour(tc.Codederetour)) ;
  memo1.lines.add (' balance : '+tc.balance) ;
  memo1.lines.add (' titre : '+tc.titre) ;
  memo1.lines.add (' Prenom : '+tc.Prenom) ;
  memo1.lines.add (' Nom : '+tc.Nom) ;
  memo1.lines.add (' date de naissance : '+tc.Date_naisse) ;
  memo1.lines.add (' Nom de la société : '+tc.NomSoc) ;
  memo1.lines.add (' Adresse ligne 1 : '+tc.Adr1) ;
  memo1.lines.add ('         ligne 2 : '+tc.Adr2) ;
  memo1.lines.add ('         ligne 3 : '+tc.Adr3) ;
  memo1.lines.add (' Code postal : '+tc.Cp) ;
  memo1.lines.add (' Ville : '+tc.ville) ;
  memo1.lines.add (' Pays : '+tc.Pays) ;
  memo1.lines.add (' NPAI : '+tc.npai) ;
  memo1.lines.add (' Email : '+tc.Email) ;
  for i := 0 to high(tc.tel) do
       memo1.lines.add (' '+tc.tel[i].tipe+' : '+tc.tel[i].num) ;
  tcoup := ts.InfoCoupon ('pascal','1254664','2570000000020') ;
  memo1.lines.add (' ') ;
  memo1.lines.add ('COUPON ' ) ;
  memo1.lines.add (' code retour : '+ts.traduit_code_retour(tcoup.Codederetour)) ;
  IF tcoup.ok then memo1.lines.add (' Coupon OK') ELSE memo1.lines.add (' Coupon pas OK') ;
  IF tcoup.Deja_util then memo1.lines.add (' Coupon déja utilisé')  ;
  IF tcoup.Perime then memo1.lines.add (' Coupon périmé')  ;
  IF tcoup.Pas_assoc_mag then memo1.lines.add (' Coupon non associé au magasin')  ;
  IF tcoup.Pas_assoc_carte then memo1.lines.add (' Coupon non associé à la carte')  ;
  IF tcoup.Numero_incorecte then memo1.lines.add (' Le numéro du coupon est incorrecte')  ;
  memo1.lines.add (' Valeur : '+tcoup.Valeur) ;
  memo1.lines.add (' Type valeur : '+tcoup.type_valeur) ;
  memo1.lines.add (' Numéro de la carte : '+tcoup.Num_carte) ;
  memo1.lines.add (' Type de coupon : '+tcoup.type_coupon) ;
  memo1.lines.add (' Label du coupon : '+tcoup.label_coupon) ;
  memo1.lines.add (' Fin de validité : '+tcoup.fin_validite) ;
  ts.free ;
end;



procedure TForm1.LMDSpeedButton1Click(Sender: TObject);

var
  ts : TSoapSp2000 ;
  tsol : TsoldeSp2000;
  i : integer ;
begin
  ts := TSoapSp2000.create ;
//  IF ts.Site_Up then
//     memo1.lines.Text := 'Site up'
//   ELSE
//     memo1.lines.Text := 'Site down' ;
  tsol := ts.Infosolde ('9250081000750974','1215','530107','6a29e075ec93bd24bf190d48641bc749');         //'f30f7946469da90b3ce3f4288ad05d36'
  memo1.lines.add (' code : '+tsol.Code) ;
  memo1.lines.add (' message : '+tsol.mess) ;
  memo1.lines.add (' solde : '+tsol.solde) ;
  memo1.lines.add (' url : '+tsol.url) ;

end;

procedure TForm1.LMDSpeedButton2Click(Sender: TObject);
var SoapRequest,Fresponse: WideString ;
begin
  FXMLHTTP := TXMLHTTP.Create;
  SoapRequest:='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body>';
  soapRequest:=soapRequest+'<getMessageElement xmlns="urn:soap.FideS.fr">'+'<cardNumber>9250081000750974</cardNumber><pin>1215</pin><codeBoutique>530107</codeBoutique><password>f30f7946469da90b3ce3f4288ad05d36</password></getMessageElement></SOAP-ENV:Body></SOAP-ENV:Envelope>';
  FXMLHTTP.PostData.Text := SoapRequest;
  try
  	FResponse := FXMLHTTP.Post('http://test.loyalty.to/sport2000/services/ginkoia');
  except on E: Exception do
    raise Exception.CreateFmt('TSoapOperation.Execute - Cannot invoke http action (URL=%s) ' + E.Message, []);
  end;

  MessageDlg(Fresponse, mtWarning, [], 0);



end;

end.

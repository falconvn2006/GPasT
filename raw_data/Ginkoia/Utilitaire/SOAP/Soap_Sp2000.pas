unit Soap_Sp2000;

interface
uses
   SHA1,
   XMLCursor,
   StdXML_TLB,
   soapOperation;

type
   TCouponSp2000 = record
      Codederetour: string;
      ok: boolean;
      Deja_util: boolean;
      Perime: boolean;
      Pas_assoc_mag: boolean;
      Pas_assoc_carte: boolean;
      Numero_incorecte: boolean;
      Valeur: string;
      type_valeur: string;
      Num_carte: string;
      type_coupon: string;
      label_coupon: string;
      fin_validite: string;
   end;

   TTelSp2000 = record
      num: string;
      tipe: string;
   end;
   TClientSp2000 = record
      Codederetour: string;
      balance: string;
      titre: string;
      Prenom: string;
      Nom: string;
      Date_naisse: string;
      NomSoc: string;
      Adr1: string;
      Adr2: string;
      Adr3: string;
      Cp: string;
      ville: string;
      Pays: string;
      npai: string;
      Tel: array of TTelSp2000;
      Email: string;
   end;
   TSoldeSp2000 = record
      code: string;
      mess: string;
      solde: string;
      url:string;
   END;
   TSoapSp2000 = class
   private
   protected
   public
      FUNCTION traduit_code_retour(code:string) : string ;
      function Site_Up: boolean;
      function InfoClt(Ident, carte: string): TClientSp2000;
      function InfoCoupon(Ident, carte, coupon: string): TCouponSp2000;
      FUNCTION InfoSolde(cardNumber,pin,codeBoutique,password:string):TSoldeSp2000 ;

   end;

implementation
const
   //UrlSp2000 = 'http://test.loyalty.to/sport2000/services/pointOfSale';
   UrlSp2000 = 'http://test.loyalty.to/sport2000/services/ginkoia';
{ TSoapSp2000 }

function TSoapSp2000.InfoCoupon(Ident, carte, coupon: string): TCouponSp2000;
var
   Soap: ISoapOperation;
   PassXML: IXMLCursor;
   Document: IXMLCursor;
   s:string ;
begin
   Soap := TSoapOperation.Create;
   Soap.url := UrlSp2000;
   Soap.SoapAction := 'checkCoupon';
   Soap.Message := 'checkCoupon';
   Soap.Prepare;
   PassXml := Soap.InputMessage.Select('/checkCoupon');
   PassXml := Soap.InputMessage.AppendChild('autentication', '');
   PassXml.AppendChild('ident', Ident);
   PassXml.AppendChild('hash', StrtoSha1(Ident));
   Soap.Values['cardNumber'] := carte;
   Soap.Values['couponNumber'] := coupon;
   Soap.execute;

   Document := TXMLCursor.Create;
   Document.LoadXML(Soap.Response);
   PassXml := Document.select('/soapenv:Envelope/soapenv:Body/checkCouponOutput');
   result.Codederetour := PassXml.GetValue ('returnCode') ;
   s :=  PassXml.GetValue ('validity') ;
   result.ok := s = '00000' ;
   result.Deja_util := Copy(s,5,1)='1' ;
   result.Perime := Copy(s,4,1)='1' ;
   result.Pas_assoc_mag := Copy(s,3,1)='1' ;
   result.Pas_assoc_carte := Copy(s,2,1)='1' ;
   result.Numero_incorecte := Copy(s,1,1)='1' ;
   passxml := passxml.Select ('couponDetails') ;
   result.Valeur := PassXml.GetValue ('value/amount') ;
   result.type_valeur := PassXml.GetValue ('value/type') ;
   result.Num_carte := PassXml.GetValue ('cardNumber') ;
   result.type_coupon := PassXml.GetValue ('type') ;
   result.label_coupon := PassXml.GetValue ('label') ;
   result.fin_validite := PassXml.GetValue ('endOfValidity') ;
end;

function TSoapSp2000.InfoSolde(cardNumber,pin,codeBoutique,password:string): TsoldeSp2000;
var
   Soap: ISoapOperation;
   PassXML: IXMLCursor;
   Document: IXMLCursor;
   s:string ;
begin
   Soap := TSoapOperation.Create;
   Soap.url := UrlSp2000;
   Soap.SoapAction := 'getMessage';
   Soap.Message := 'getMessageElement';
   Soap.Prepare;
   PassXml := Soap.InputMessage.Select('/getMessageElement');
//   PassXml := Soap.InputMessage.AppendChild('autentication', '');
//   PassXml.AppendChild('ident', Ident);
//   PassXml.AppendChild('hash', StrtoSha1(Ident));
   Soap.Values['cardNumber'] := cardnumber;
   Soap.Values['pin'] := pin;
   Soap.Values['codeBoutique']:=codeboutique;
   Soap.Values['password']:=password;
   Soap.execute;

   Document := TXMLCursor.Create;
   Document.LoadXML(Soap.Response);
   PassXml := Document.select('/soapenv:Envelope/soapenv:Body/getMessageReturnElement');
   result.Code := PassXml.GetValue ('code') ;
   result.mess := PassXml.GetValue ('message') ;
   result.solde := PassXml.GetValue ('solde') ;
   result.url := PassXml.GetValue ('url') ;

END;



function TSoapSp2000.InfoClt(Ident, carte: string): TClientSp2000;
var
   Soap: ISoapOperation;
   PassXML: IXMLCursor;
   PassXML2: IXMLCursor;
   Document: IXMLCursor;
begin
   Soap := TSoapOperation.Create;
   Soap.url := UrlSp2000;
   Soap.SoapAction := 'getMemberInfo';
   Soap.Message := 'getMemberInfo';
   Soap.Prepare;
   PassXml := Soap.InputMessage.Select('/getMemberInfo');
   PassXml := Soap.InputMessage.AppendChild('autentication', '');
   PassXml.AppendChild('ident', Ident);
   PassXml.AppendChild('hash', StrtoSha1(Ident));
   Soap.Values['cardNumber'] := carte;
   Soap.execute;
   Document := TXMLCursor.Create;
   Document.LoadXML(Soap.Response);

   PassXml := Document.select('/soapenv:Envelope/soapenv:Body/getMemberInfoOutput');
   result.Codederetour := PassXml.GetValue('returnCode');
   result.balance := PassXml.GetValue('balance');
   PassXml := PassXml.select('memberInfo');
   result.titre := PassXml.GetValue('title');
   result.Prenom := PassXml.GetValue('firstName');
   result.Nom := PassXml.GetValue('lastName');
   result.Date_naisse := PassXml.GetValue('birthDay');
   result.Email := PassXml.GetValue('email');
   PassXml2 := PassXml.Select('address');
   result.NomSoc := PassXml2.GetValue('companyName');
   result.Adr1 := PassXml2.GetValue('address1');
   result.Adr2 := PassXml2.GetValue('address2');
   result.Adr3 := PassXml2.GetValue('address3');
   result.Cp := PassXml2.GetValue('postCode');
   result.ville := PassXml2.GetValue('city');
   result.Pays := PassXml2.GetValue('country');
   result.npai := PassXml2.GetValue('npai');
   PassXml2 := PassXml.Select('phones');
   while not PassXml2.eof do
   begin
      SetLength(result.Tel, high(result.Tel) + 2);
      result.Tel[high(result.Tel)].num := PassXml2.GetValue('number');
      result.Tel[high(result.Tel)].tipe := PassXml2.GetValue('type');
      PassXml2.Next;
   end;
end;

function TSoapSp2000.Site_Up: boolean;
var
   Soap: ISoapOperation;
   Document: IXMLCursor;
   PassXML: IXMLCursor;
begin
   try
      Soap := TSoapOperation.Create;
      Soap.url := UrlSp2000;
      Soap.SoapAction := 'ping';
      Soap.Message := 'ping';
      Soap.Prepare;
      Soap.execute;
      Document := TXMLCursor.Create;
      Document.LoadXML(Soap.Response);
      PassXml := Document.select('/soapenv:Envelope/soapenv:Body');
      PassXml.GetValue('return');
      result := PassXml.GetValue('return') = 'true';
   except
      result := false;
   end;
end;

function TSoapSp2000.traduit_code_retour(code: string): string;
begin
  IF code = '0' then
    result := 'OK'
  ELSE IF code = '1' then
    result := 'L''identification a échoué'
  ELSE IF code = '2' then
    result := 'Le numero de carte est inconnu'
  ELSE IF code = '3' then
    result := 'La carte est perimée'
  ELSE IF code = '8' then
    result := 'Le service est temporairement indisponible'
  ELSE IF code = '9' then
    result := 'Erreur interne'
  else
    result := 'Code de retour inconnue'
end;

end.


unit NetEvenAccess;

interface

function ComputeSignature(ALogin, AStamp, ASeed, APassword : string): string;

implementation

uses
  MD5Api,
  XMLCursor,
  StdXML_TLB,
  soapOperation,
  IdCoderMIME;

function ComputeSignature(ALogin, AStamp, ASeed, APassword : string): string;
VAR
  sToCrypt, sMD5Crypted, sBase64Crypted: STRING;
  MD5Hash: TMD5Data;
  i: integer;
  Base64 : TIdEncoderMIME;
BEGIN
  Result := '';

  sToCrypt := UTF8Encode(ALogin + '/' + AStamp + '/' + ASeed + '/' + APassword);
//  exemple : 'laurent@ekosport.fr/2009-11-18T16:22:48/MySeed/2fsarl73';

  // Hachage en MD5
  MD5Hash := MD5DataFromString(sToCrypt);
  sMD5Crypted := '';
  FOR i := 0 TO 15 DO
  BEGIN
    sMD5Crypted := sMD5Crypted + Chr(MD5Hash[i]);
  END;

  // Encodage en Base64
  Base64 := TIdEncoderMime.Create;
  TRY
    sBase64Crypted := Base64.Encode(sToCrypt);
  FINALLY
    Base64.Free;
  end;
end;

function GetOrders: IXMLCursor;
VAR
  reponse: boolean;
  Soap: ISoapOperation;
  Document: IXMLCursor;
  strDate: STRING;
  sHeader : string;
BEGIN
  reponse := False;


//  sHeader :=  '<?xml version="1.0" encoding="UTF-8"?>'+
//  '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:NWS:examples">'+
//  '<SOAP-ENV:Header>'+
//  '<ns1:AuthenticationHeader><ns1:Method>*</ns1:Method><ns1:Login>laurent@ekosport.fr</ns1:Login><ns1:Seed>MySeed</ns1:Seed><ns1:Stamp>2009-11-18T16:22:48</ns1:Stamp><ns1:Signature>4qbVZWPi443pPdtAv14Jdw==</ns1:Signature></ns1:AuthenticationHeader>'+
//  '</SOAP-ENV:Header>'+
//  '</SOAP-ENV:Envelope>';

  sHeader := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:NWS:examples">'+
  '<soapenv:Header>'+
  '<ns1:AuthenticationHeader><ns1:Method>*</ns1:Method><ns1:Login>laurent@ekosport.fr</ns1:Login><ns1:Seed>MySeed</ns1:Seed><ns1:Stamp>2009-11-18T16:22:48</ns1:Stamp><ns1:Signature>4qbVZWPi443pPdtAv14Jdw==</ns1:Signature></ns1:AuthenticationHeader>'+
  '</soapenv:Header>'+
  '</soapenv:Envelope>';


  //   '<soapenv:Body>'+
//  '<ns1:GetOrders>'+
//  '<ns1:DateSaleFrom>'+
//  '</ns1:DateSaleFrom>'+
//  '<ns1:DateSaleTo></ns1:DateSaleTo>' +
//  '<ns1:DatePaymentFrom></ns1:DatePaymentFrom>' +
//  '<ns1:DatePaymentTo></ns1:DatePaymentTo>'+
//  '</ns1:GetOrders>'+
//  '</soapenv:Body>'+

//  sHeader := '<ns1:AuthenticationHeader><ns1:Method>*</ns1:Method><ns1:Login>laurent@ekosport.fr</ns1:Login><ns1:Seed>MySeed</ns1:Seed><ns1:Stamp>2009-11-18T16:22:48</ns1:Stamp><ns1:Signature>4qbVZWPi443pPdtAv14Jdw==</ns1:Signature></ns1:AuthenticationHeader>'

  //prépation de la requête
  Soap := TSoapOperation.Create;

  Soap.url := 'http://ws.neteven.com/NWS';
  //
  //  Soap.UserName := 'laurent@ekosport.fr';
  //  Soap.Password := '2fsarl73';
  Soap.SoapAction := 'TestConnection';
  //  //fonction appelée
  Soap.Message := 'ns1:TestConnectionRequest';

  Soap.Prepare(sHeader);
  //
  //  //se placer sur la balise des paramètres à passer
  ////        Soap.InputMessage.Select('/twin:add_client_datas');
  //  //ajout des balises et de leur valeurs
  //  //récupèrer le GUID de la base
  ////        IbC_GUIDBase.Close;
  ////        IbC_GUIDBase.Open;
  ////        Soap.Values['guid_base'] := IbC_GUIDBase.Fields[0].AsString;
  //  //récupèrer les informations sur le client
  ////        IbC_Client.Close;
  ////        IbC_Client.parambyname('cltid').asInteger := ACltid;
  ////        IbC_Client.Open;
  //  // récupèrer le code adherent
  ////        Soap.Values['num_adherent'] := stdginkoia.MagasinCodeAdh;
  ////        Soap.Values['cont_ginkoia_id'] := IntToStr(Acltid);
  ////        Soap.Values['cont_magasin'] := StdGinKoia.MagasinName;
  ////        Soap.Values['cont_nom'] := IbC_Client.Fields[0].AsString;
  ////        Soap.Values['cont_prenom'] := IbC_Client.Fields[1].AsString;
  ////        Soap.Values['cont_adresse'] := IbC_Client.Fields[4].AsString;
  ////        Soap.Values['cont_adresse2'] := IbC_Client.Fields[5].AsString;
  ////        Soap.Values['cont_adresse3'] := IbC_Client.Fields[6].AsString;
  ////        Soap.Values['cont_cp'] := IbC_Client.Fields[7].AsString;
  ////        Soap.Values['cont_ville'] := IbC_Client.Fields[8].AsString;
  ////        Soap.Values['cont_num_mobile'] := IbC_Client.Fields[9].AsString;
  ////        Soap.Values['cont_email'] := IbC_Client.Fields[10].AsString;
  //

  Soap.execute;

  Document := TXMLCursor.Create;

  Document.LoadXML(Soap.Response);

//  Document.Save('c:\Test.xml');
  //
  //  //        PassXml := Document.select('/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:retour_add_client');
  //          //Récupèrer la réponse
  //  reponse := (PassXml.GetValue('enregistrement_ok') = 'true');
  //  IF NOT reponse THEN //
  //  BEGIN
  //    //message de l'erreur
  //    Showmessage('Erreur');
  //  END;

    //  result := reponse;
end;

end.

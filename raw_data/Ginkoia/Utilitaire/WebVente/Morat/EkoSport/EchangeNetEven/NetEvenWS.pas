// ************************************************************************ //

// Les types déclarés dans ce fichier ont été générés à partir de données lues dans le

// fichier WSDL décrit ci-dessous :

// WSDL     : http://ws.neteven.com/NWS

//  >Import : http://ws.neteven.com/NWS:0
// Encodage : UTF-8// Version  : 1.0
// (12/11/2009 10:57:59 - - $Rev: 10138 $)
// ************************************************************************ //

UNIT NetEvenWS;

INTERFACE

USES Windows,
  Classes,
  Variants,
  InvokeRegistry,
  SOAPHTTPClient,
  SOAPPasInv,
  Types,
  XSBuiltIns,
  Dialogs;

CONST
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;
  IS_REF = $0080;

TYPE

  // ************************************************************************ //
  // Les types suivants mentionnés dans le document WSDL ne sont pas représentés

  // dans ce fichier. Ce sont soit des alias[@] de types représentés ou alors ils sont

  // référencés mais jamais[!] déclarés dans le document. Les types de la dernière catégorie

  // sont en principe mappés à des types Borland ou XML prédéfinis/connus. Toutefois, ils peuvent aussi

  // signaler des documents WSDL incorrects n'ayant pas réussi à déclarer ou importer un type de schéma.  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:integer         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:double          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]

  AuthenticationHeader = CLASS; { "urn:NWS:examples"[Hdr][GblCplx] }
  SpecificField = CLASS; { "urn:NWS:examples"[GblCplx] }
  InventoryItem = CLASS; { "urn:NWS:examples"[GblCplx] }
  InventoryItemStatusResponse = CLASS; { "urn:NWS:examples"[GblCplx] }
  MarketPlaceOrder = CLASS; { "urn:NWS:examples"[GblCplx] }
  MarketPlaceAddress = CLASS; { "urn:NWS:examples"[GblCplx] }
  MarketPlaceOrderStatusResponse = CLASS; { "urn:NWS:examples"[GblCplx] }
  EchoRequestType = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  EchoResponseType = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  GetItemsRequestType = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  TestConnectionRequest = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  TestConnectionResponse = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  AuthenticationHeader2 = CLASS; { "urn:NWS:examples"[Hdr][GblElm] }
  InventoryItemsType = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  PostItems = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  PostItemsResponse = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  GetOrders = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  GetOrdersResponse = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  PostOrders = CLASS; { "urn:NWS:examples"[Lit][GblElm] }
  PostOrdersResponse = CLASS; { "urn:NWS:examples"[Lit][GblElm] }

  { "urn:NWS:examples"[GblSmpl] }
  EtatEnum = (_1, _2, _3, _4, _5, _6, _7, _8, _10, _11);

  { "urn:NWS:examples"[GblSmpl] }
  StatusEnum = (Accepted, Canceled, NonConformantAuthorization, NonConformantFormat, Rejected, UnexpectedInformation, Inserted, Updated, Error);

  { "urn:NWS:examples"[GblSmpl] }
  OrderStatusEnum = (Confirmed, Canceled2);

  { "urn:NWS:examples"[GblSmpl] }
  PaymentMethodEnum = (CreditCard, Check, PayPal, Other, Unknown);

  // ************************************************************************ //
  // XML       : AuthenticationHeader, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // Info      : Header
  // ************************************************************************ //
  AuthenticationHeader = CLASS(TSOAPHeader)
  PRIVATE
    FMethod: WideString;
    FLogin: WideString;
    FSeed: WideString;
    FStamp: WideString;
    FSignature: WideString;
  PUBLISHED
    PROPERTY Method: WideString READ FMethod WRITE FMethod; // MyMethod
    PROPERTY Login: WideString READ FLogin WRITE FLogin; //laurent@ekosport.fr
    PROPERTY Seed: WideString READ FSeed WRITE FSeed; // MySeed
    PROPERTY Stamp: WideString READ FStamp WRITE FStamp; // date utc
    PROPERTY Signature: WideString READ FSignature WRITE FSignature; // mdp : 2fsarl73
  END;

  ArrayOfSpecificFields = ARRAY OF SpecificField; { "urn:NWS:examples"[GblCplx] }

  // ************************************************************************ //
  // XML       : SpecificField, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  SpecificField = CLASS(TRemotable)
  PRIVATE
    FName_: WideString;
    FValue: WideString;
  PUBLISHED
    PROPERTY Name_: WideString READ FName_ WRITE FName_;
    PROPERTY Value: WideString READ FValue WRITE FValue;
  END;

  ArrayOfInventoryItem = ARRAY OF InventoryItem; { "urn:NWS:examples"[GblCplx] }

  // ************************************************************************ //
  // XML       : InventoryItem, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  InventoryItem = CLASS(TRemotable)
  PRIVATE
    FTitle: WideString;
    FSubTitle: WideString;
    FSubTitle_Specified: boolean;
    FDescription: WideString;
    FDescription_Specified: boolean;
    FComment: WideString;
    FComment_Specified: boolean;
    FSKU: WideString;
    FSKUFamily: WideString;
    FSKUFamily_Specified: boolean;
    FBrand: WideString;
    FBrand_Specified: boolean;
    FCodeProduit: WideString;
    FCodeProduit_Specified: boolean;
    FTypeCodeProduit: WideString;
    FTypeCodeProduit_Specified: boolean;
    FEAN: WideString;
    FEAN_Specified: boolean;
    FUPC: WideString;
    FUPC_Specified: boolean;
    FISBN: WideString;
    FISBN_Specified: boolean;
    FASIN: WideString;
    FASIN_Specified: boolean;
    FPartNumber: WideString;
    FPartNumber_Specified: boolean;
    FQuantity: Int64;
    FCost: Double;
    FCost_Specified: boolean;
    FDateAvailability: TXSDateTime;
    FDateAvailability_Specified: boolean;
    FPriceFixed: Double;
    FPriceStarting: Double;
    FPriceStarting_Specified: boolean;
    FPriceReserved: Double;
    FPriceReserved_Specified: boolean;
    FPriceRetail: Double;
    FPriceRetail_Specified: boolean;
    FPriceSecondChance: Double;
    FPriceSecondChance_Specified: boolean;
    FPriceBestOffer: Double;
    FPriceBestOffer_Specified: boolean;
    FEtat: EtatEnum;
    FEtat_Specified: boolean;
    FLotSize: Int64;
    FLotSize_Specified: boolean;
    FSupplierName: WideString;
    FSupplierName_Specified: boolean;
    FClassification: WideString;
    FClassification_Specified: boolean;
    FWeight: Double;
    FWeight_Specified: boolean;
    FHeight: Double;
    FHeight_Specified: boolean;
    FWidth: Double;
    FWidth_Specified: boolean;
    FDepth: Double;
    FDepth_Specified: boolean;
    FPriceShippingLocal1: Double;
    FPriceShippingLocal1_Specified: boolean;
    FPriceShippingSuppLocal1: Double;
    FPriceShippingSuppLocal1_Specified: boolean;
    FPriceShippingLocal2: Double;
    FPriceShippingLocal2_Specified: boolean;
    FPriceShippingSuppLocal2: Double;
    FPriceShippingSuppLocal2_Specified: boolean;
    FPriceShippingLocal3: Double;
    FPriceShippingLocal3_Specified: boolean;
    FPriceShippingSuppLocal3: Double;
    FPriceShippingSuppLocal3_Specified: boolean;
    FPriceShippingInt1: Double;
    FPriceShippingInt1_Specified: boolean;
    FPriceShippingSuppInt1: Double;
    FPriceShippingSuppInt1_Specified: boolean;
    FPriceShippingInt2: Double;
    FPriceShippingInt2_Specified: boolean;
    FPriceShippingSuppInt2: Double;
    FPriceShippingSuppInt2_Specified: boolean;
    FPriceShippingInt3: Double;
    FPriceShippingInt3_Specified: boolean;
    FPriceShippingSuppInt3: Double;
    FPriceShippingSuppInt3_Specified: boolean;
    FImage1: WideString;
    FImage1_Specified: boolean;
    FImage2: WideString;
    FImage2_Specified: boolean;
    FImage3: WideString;
    FImage3_Specified: boolean;
    FImage4: WideString;
    FImage4_Specified: boolean;
    FImage5: WideString;
    FImage5_Specified: boolean;
    FImage6: WideString;
    FImage6_Specified: boolean;
    FAttribute1: WideString;
    FAttribute1_Specified: boolean;
    FAttribute2: WideString;
    FAttribute2_Specified: boolean;
    FAttribute3: WideString;
    FAttribute3_Specified: boolean;
    FAttribute4: WideString;
    FAttribute4_Specified: boolean;
    FAttribute5: WideString;
    FAttribute5_Specified: boolean;
    FAttribute6: WideString;
    FAttribute6_Specified: boolean;
    FAttribute7: WideString;
    FAttribute7_Specified: boolean;
    FAttribute8: WideString;
    FAttribute8_Specified: boolean;
    FAttribute9: WideString;
    FAttribute9_Specified: boolean;
    FAttribute10: WideString;
    FAttribute10_Specified: boolean;
    FAttribute11: WideString;
    FAttribute11_Specified: boolean;
    FAttribute12: WideString;
    FAttribute12_Specified: boolean;
    FAttribute13: WideString;
    FAttribute13_Specified: boolean;
    FAttribute14: WideString;
    FAttribute14_Specified: boolean;
    FAttribute15: WideString;
    FAttribute15_Specified: boolean;
    FAttribute16: WideString;
    FAttribute16_Specified: boolean;
    FAttribute17: WideString;
    FAttribute17_Specified: boolean;
    FAttribute18: WideString;
    FAttribute18_Specified: boolean;
    FAttribute19: WideString;
    FAttribute19_Specified: boolean;
    FAttribute20: WideString;
    FAttribute20_Specified: boolean;
    FArrayOfSpecificFields: ArrayOfSpecificFields;
    FArrayOfSpecificFields_Specified: boolean;
    PROCEDURE SetSubTitle(Index: Integer; CONST AWideString: WideString);
    FUNCTION SubTitle_Specified(Index: Integer): boolean;
    PROCEDURE SetDescription(Index: Integer; CONST AWideString: WideString);
    FUNCTION Description_Specified(Index: Integer): boolean;
    PROCEDURE SetComment(Index: Integer; CONST AWideString: WideString);
    FUNCTION Comment_Specified(Index: Integer): boolean;
    PROCEDURE SetSKUFamily(Index: Integer; CONST AWideString: WideString);
    FUNCTION SKUFamily_Specified(Index: Integer): boolean;
    PROCEDURE SetBrand(Index: Integer; CONST AWideString: WideString);
    FUNCTION Brand_Specified(Index: Integer): boolean;
    PROCEDURE SetCodeProduit(Index: Integer; CONST AWideString: WideString);
    FUNCTION CodeProduit_Specified(Index: Integer): boolean;
    PROCEDURE SetTypeCodeProduit(Index: Integer; CONST AWideString: WideString);
    FUNCTION TypeCodeProduit_Specified(Index: Integer): boolean;
    PROCEDURE SetEAN(Index: Integer; CONST AWideString: WideString);
    FUNCTION EAN_Specified(Index: Integer): boolean;
    PROCEDURE SetUPC(Index: Integer; CONST AWideString: WideString);
    FUNCTION UPC_Specified(Index: Integer): boolean;
    PROCEDURE SetISBN(Index: Integer; CONST AWideString: WideString);
    FUNCTION ISBN_Specified(Index: Integer): boolean;
    PROCEDURE SetASIN(Index: Integer; CONST AWideString: WideString);
    FUNCTION ASIN_Specified(Index: Integer): boolean;
    PROCEDURE SetPartNumber(Index: Integer; CONST AWideString: WideString);
    FUNCTION PartNumber_Specified(Index: Integer): boolean;
    PROCEDURE SetCost(Index: Integer; CONST ADouble: Double);
    FUNCTION Cost_Specified(Index: Integer): boolean;
    PROCEDURE SetDateAvailability(Index: Integer; CONST ATXSDateTime: TXSDateTime);
    FUNCTION DateAvailability_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceStarting(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceStarting_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceReserved(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceReserved_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceRetail(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceRetail_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceSecondChance(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceSecondChance_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceBestOffer(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceBestOffer_Specified(Index: Integer): boolean;
    PROCEDURE SetEtat(Index: Integer; CONST AEtatEnum: EtatEnum);
    FUNCTION Etat_Specified(Index: Integer): boolean;
    PROCEDURE SetLotSize(Index: Integer; CONST AInt64: Int64);
    FUNCTION LotSize_Specified(Index: Integer): boolean;
    PROCEDURE SetSupplierName(Index: Integer; CONST AWideString: WideString);
    FUNCTION SupplierName_Specified(Index: Integer): boolean;
    PROCEDURE SetClassification(Index: Integer; CONST AWideString: WideString);
    FUNCTION Classification_Specified(Index: Integer): boolean;
    PROCEDURE SetWeight(Index: Integer; CONST ADouble: Double);
    FUNCTION Weight_Specified(Index: Integer): boolean;
    PROCEDURE SetHeight(Index: Integer; CONST ADouble: Double);
    FUNCTION Height_Specified(Index: Integer): boolean;
    PROCEDURE SetWidth(Index: Integer; CONST ADouble: Double);
    FUNCTION Width_Specified(Index: Integer): boolean;
    PROCEDURE SetDepth(Index: Integer; CONST ADouble: Double);
    FUNCTION Depth_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingLocal1(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingLocal1_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingSuppLocal1(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingSuppLocal1_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingLocal2(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingLocal2_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingSuppLocal2(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingSuppLocal2_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingLocal3(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingLocal3_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingSuppLocal3(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingSuppLocal3_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingInt1(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingInt1_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingSuppInt1(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingSuppInt1_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingInt2(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingInt2_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingSuppInt2(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingSuppInt2_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingInt3(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingInt3_Specified(Index: Integer): boolean;
    PROCEDURE SetPriceShippingSuppInt3(Index: Integer; CONST ADouble: Double);
    FUNCTION PriceShippingSuppInt3_Specified(Index: Integer): boolean;
    PROCEDURE SetImage1(Index: Integer; CONST AWideString: WideString);
    FUNCTION Image1_Specified(Index: Integer): boolean;
    PROCEDURE SetImage2(Index: Integer; CONST AWideString: WideString);
    FUNCTION Image2_Specified(Index: Integer): boolean;
    PROCEDURE SetImage3(Index: Integer; CONST AWideString: WideString);
    FUNCTION Image3_Specified(Index: Integer): boolean;
    PROCEDURE SetImage4(Index: Integer; CONST AWideString: WideString);
    FUNCTION Image4_Specified(Index: Integer): boolean;
    PROCEDURE SetImage5(Index: Integer; CONST AWideString: WideString);
    FUNCTION Image5_Specified(Index: Integer): boolean;
    PROCEDURE SetImage6(Index: Integer; CONST AWideString: WideString);
    FUNCTION Image6_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute1(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute1_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute2(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute2_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute3(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute3_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute4(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute4_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute5(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute5_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute6(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute6_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute7(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute7_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute8(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute8_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute9(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute9_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute10(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute10_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute11(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute11_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute12(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute12_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute13(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute13_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute14(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute14_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute15(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute15_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute16(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute16_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute17(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute17_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute18(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute18_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute19(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute19_Specified(Index: Integer): boolean;
    PROCEDURE SetAttribute20(Index: Integer; CONST AWideString: WideString);
    FUNCTION Attribute20_Specified(Index: Integer): boolean;
    PROCEDURE SetArrayOfSpecificFields(Index: Integer; CONST AArrayOfSpecificFields: ArrayOfSpecificFields);
    FUNCTION ArrayOfSpecificFields_Specified(Index: Integer): boolean;
  PUBLIC
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY Title: WideString READ FTitle WRITE FTitle;
    PROPERTY SubTitle: WideString INDEX(IS_OPTN) READ FSubTitle WRITE SetSubTitle STORED SubTitle_Specified;
    PROPERTY Description: WideString INDEX(IS_OPTN) READ FDescription WRITE SetDescription STORED Description_Specified;
    PROPERTY Comment: WideString INDEX(IS_OPTN) READ FComment WRITE SetComment STORED Comment_Specified;
    PROPERTY SKU: WideString READ FSKU WRITE FSKU;
    PROPERTY SKUFamily: WideString INDEX(IS_OPTN) READ FSKUFamily WRITE SetSKUFamily STORED SKUFamily_Specified;
    PROPERTY Brand: WideString INDEX(IS_OPTN) READ FBrand WRITE SetBrand STORED Brand_Specified;
    PROPERTY CodeProduit: WideString INDEX(IS_OPTN) READ FCodeProduit WRITE SetCodeProduit STORED CodeProduit_Specified;
    PROPERTY TypeCodeProduit: WideString INDEX(IS_OPTN) READ FTypeCodeProduit WRITE SetTypeCodeProduit STORED TypeCodeProduit_Specified;
    PROPERTY EAN: WideString INDEX(IS_OPTN) READ FEAN WRITE SetEAN STORED EAN_Specified;
    PROPERTY UPC: WideString INDEX(IS_OPTN) READ FUPC WRITE SetUPC STORED UPC_Specified;
    PROPERTY ISBN: WideString INDEX(IS_OPTN) READ FISBN WRITE SetISBN STORED ISBN_Specified;
    PROPERTY ASIN: WideString INDEX(IS_OPTN) READ FASIN WRITE SetASIN STORED ASIN_Specified;
    PROPERTY PartNumber: WideString INDEX(IS_OPTN) READ FPartNumber WRITE SetPartNumber STORED PartNumber_Specified;
    PROPERTY Quantity: Int64 READ FQuantity WRITE FQuantity;
    PROPERTY Cost: Double INDEX(IS_OPTN) READ FCost WRITE SetCost STORED Cost_Specified;
    PROPERTY DateAvailability: TXSDateTime INDEX(IS_OPTN) READ FDateAvailability WRITE SetDateAvailability STORED DateAvailability_Specified;
    PROPERTY PriceFixed: Double READ FPriceFixed WRITE FPriceFixed;
    PROPERTY PriceStarting: Double INDEX(IS_OPTN) READ FPriceStarting WRITE SetPriceStarting STORED PriceStarting_Specified;
    PROPERTY PriceReserved: Double INDEX(IS_OPTN) READ FPriceReserved WRITE SetPriceReserved STORED PriceReserved_Specified;
    PROPERTY PriceRetail: Double INDEX(IS_OPTN) READ FPriceRetail WRITE SetPriceRetail STORED PriceRetail_Specified;
    PROPERTY PriceSecondChance: Double INDEX(IS_OPTN) READ FPriceSecondChance WRITE SetPriceSecondChance STORED PriceSecondChance_Specified;
    PROPERTY PriceBestOffer: Double INDEX(IS_OPTN) READ FPriceBestOffer WRITE SetPriceBestOffer STORED PriceBestOffer_Specified;
    PROPERTY Etat: EtatEnum INDEX(IS_OPTN) READ FEtat WRITE SetEtat STORED Etat_Specified;
    PROPERTY LotSize: Int64 INDEX(IS_OPTN) READ FLotSize WRITE SetLotSize STORED LotSize_Specified;
    PROPERTY SupplierName: WideString INDEX(IS_OPTN) READ FSupplierName WRITE SetSupplierName STORED SupplierName_Specified;
    PROPERTY Classification: WideString INDEX(IS_OPTN) READ FClassification WRITE SetClassification STORED Classification_Specified;
    PROPERTY Weight: Double INDEX(IS_OPTN) READ FWeight WRITE SetWeight STORED Weight_Specified;
    PROPERTY Height: Double INDEX(IS_OPTN) READ FHeight WRITE SetHeight STORED Height_Specified;
    PROPERTY Width: Double INDEX(IS_OPTN) READ FWidth WRITE SetWidth STORED Width_Specified;
    PROPERTY Depth: Double INDEX(IS_OPTN) READ FDepth WRITE SetDepth STORED Depth_Specified;
    PROPERTY PriceShippingLocal1: Double INDEX(IS_OPTN) READ FPriceShippingLocal1 WRITE SetPriceShippingLocal1 STORED PriceShippingLocal1_Specified;
    PROPERTY PriceShippingSuppLocal1: Double INDEX(IS_OPTN) READ FPriceShippingSuppLocal1 WRITE SetPriceShippingSuppLocal1 STORED PriceShippingSuppLocal1_Specified;
    PROPERTY PriceShippingLocal2: Double INDEX(IS_OPTN) READ FPriceShippingLocal2 WRITE SetPriceShippingLocal2 STORED PriceShippingLocal2_Specified;
    PROPERTY PriceShippingSuppLocal2: Double INDEX(IS_OPTN) READ FPriceShippingSuppLocal2 WRITE SetPriceShippingSuppLocal2 STORED PriceShippingSuppLocal2_Specified;
    PROPERTY PriceShippingLocal3: Double INDEX(IS_OPTN) READ FPriceShippingLocal3 WRITE SetPriceShippingLocal3 STORED PriceShippingLocal3_Specified;
    PROPERTY PriceShippingSuppLocal3: Double INDEX(IS_OPTN) READ FPriceShippingSuppLocal3 WRITE SetPriceShippingSuppLocal3 STORED PriceShippingSuppLocal3_Specified;
    PROPERTY PriceShippingInt1: Double INDEX(IS_OPTN) READ FPriceShippingInt1 WRITE SetPriceShippingInt1 STORED PriceShippingInt1_Specified;
    PROPERTY PriceShippingSuppInt1: Double INDEX(IS_OPTN) READ FPriceShippingSuppInt1 WRITE SetPriceShippingSuppInt1 STORED PriceShippingSuppInt1_Specified;
    PROPERTY PriceShippingInt2: Double INDEX(IS_OPTN) READ FPriceShippingInt2 WRITE SetPriceShippingInt2 STORED PriceShippingInt2_Specified;
    PROPERTY PriceShippingSuppInt2: Double INDEX(IS_OPTN) READ FPriceShippingSuppInt2 WRITE SetPriceShippingSuppInt2 STORED PriceShippingSuppInt2_Specified;
    PROPERTY PriceShippingInt3: Double INDEX(IS_OPTN) READ FPriceShippingInt3 WRITE SetPriceShippingInt3 STORED PriceShippingInt3_Specified;
    PROPERTY PriceShippingSuppInt3: Double INDEX(IS_OPTN) READ FPriceShippingSuppInt3 WRITE SetPriceShippingSuppInt3 STORED PriceShippingSuppInt3_Specified;
    PROPERTY Image1: WideString INDEX(IS_OPTN) READ FImage1 WRITE SetImage1 STORED Image1_Specified;
    PROPERTY Image2: WideString INDEX(IS_OPTN) READ FImage2 WRITE SetImage2 STORED Image2_Specified;
    PROPERTY Image3: WideString INDEX(IS_OPTN) READ FImage3 WRITE SetImage3 STORED Image3_Specified;
    PROPERTY Image4: WideString INDEX(IS_OPTN) READ FImage4 WRITE SetImage4 STORED Image4_Specified;
    PROPERTY Image5: WideString INDEX(IS_OPTN) READ FImage5 WRITE SetImage5 STORED Image5_Specified;
    PROPERTY Image6: WideString INDEX(IS_OPTN) READ FImage6 WRITE SetImage6 STORED Image6_Specified;
    PROPERTY Attribute1: WideString INDEX(IS_OPTN) READ FAttribute1 WRITE SetAttribute1 STORED Attribute1_Specified;
    PROPERTY Attribute2: WideString INDEX(IS_OPTN) READ FAttribute2 WRITE SetAttribute2 STORED Attribute2_Specified;
    PROPERTY Attribute3: WideString INDEX(IS_OPTN) READ FAttribute3 WRITE SetAttribute3 STORED Attribute3_Specified;
    PROPERTY Attribute4: WideString INDEX(IS_OPTN) READ FAttribute4 WRITE SetAttribute4 STORED Attribute4_Specified;
    PROPERTY Attribute5: WideString INDEX(IS_OPTN) READ FAttribute5 WRITE SetAttribute5 STORED Attribute5_Specified;
    PROPERTY Attribute6: WideString INDEX(IS_OPTN) READ FAttribute6 WRITE SetAttribute6 STORED Attribute6_Specified;
    PROPERTY Attribute7: WideString INDEX(IS_OPTN) READ FAttribute7 WRITE SetAttribute7 STORED Attribute7_Specified;
    PROPERTY Attribute8: WideString INDEX(IS_OPTN) READ FAttribute8 WRITE SetAttribute8 STORED Attribute8_Specified;
    PROPERTY Attribute9: WideString INDEX(IS_OPTN) READ FAttribute9 WRITE SetAttribute9 STORED Attribute9_Specified;
    PROPERTY Attribute10: WideString INDEX(IS_OPTN) READ FAttribute10 WRITE SetAttribute10 STORED Attribute10_Specified;
    PROPERTY Attribute11: WideString INDEX(IS_OPTN) READ FAttribute11 WRITE SetAttribute11 STORED Attribute11_Specified;
    PROPERTY Attribute12: WideString INDEX(IS_OPTN) READ FAttribute12 WRITE SetAttribute12 STORED Attribute12_Specified;
    PROPERTY Attribute13: WideString INDEX(IS_OPTN) READ FAttribute13 WRITE SetAttribute13 STORED Attribute13_Specified;
    PROPERTY Attribute14: WideString INDEX(IS_OPTN) READ FAttribute14 WRITE SetAttribute14 STORED Attribute14_Specified;
    PROPERTY Attribute15: WideString INDEX(IS_OPTN) READ FAttribute15 WRITE SetAttribute15 STORED Attribute15_Specified;
    PROPERTY Attribute16: WideString INDEX(IS_OPTN) READ FAttribute16 WRITE SetAttribute16 STORED Attribute16_Specified;
    PROPERTY Attribute17: WideString INDEX(IS_OPTN) READ FAttribute17 WRITE SetAttribute17 STORED Attribute17_Specified;
    PROPERTY Attribute18: WideString INDEX(IS_OPTN) READ FAttribute18 WRITE SetAttribute18 STORED Attribute18_Specified;
    PROPERTY Attribute19: WideString INDEX(IS_OPTN) READ FAttribute19 WRITE SetAttribute19 STORED Attribute19_Specified;
    PROPERTY Attribute20: WideString INDEX(IS_OPTN) READ FAttribute20 WRITE SetAttribute20 STORED Attribute20_Specified;
    PROPERTY ArrayOfSpecificFields: ArrayOfSpecificFields INDEX(IS_OPTN) READ FArrayOfSpecificFields WRITE SetArrayOfSpecificFields STORED ArrayOfSpecificFields_Specified;
  END;

  ArrayOfInventoryItemStatusResponse = ARRAY OF InventoryItemStatusResponse; { "urn:NWS:examples"[GblCplx] }

  // ************************************************************************ //
  // XML       : InventoryItemStatusResponse, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  InventoryItemStatusResponse = CLASS(TRemotable)
  PRIVATE
    FItemCode: WideString;
    FItemCode_Specified: boolean;
    FStatusResponse: StatusEnum;
    PROCEDURE SetItemCode(Index: Integer; CONST AWideString: WideString);
    FUNCTION ItemCode_Specified(Index: Integer): boolean;
  PUBLISHED
    PROPERTY ItemCode: WideString INDEX(IS_OPTN) READ FItemCode WRITE SetItemCode STORED ItemCode_Specified;
    PROPERTY StatusResponse: StatusEnum READ FStatusResponse WRITE FStatusResponse;
  END;

  ArrayOfMarketPlaceOrder = ARRAY OF MarketPlaceOrder; { "urn:NWS:examples"[GblCplx] }

  // ************************************************************************ //
  // XML       : MarketPlaceOrder, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  MarketPlaceOrder = CLASS(TRemotable)
  PRIVATE
    FID: WideString;
    FID_Specified: boolean;
    FOrderID: WideString;
    FOrderID_Specified: boolean;
    FOrderLineID: WideString;
    FOrderLineID_Specified: boolean;
    FStatus: OrderStatusEnum;
    FStatus_Specified: boolean;
    FCustomerId: WideString;
    FCustomerId_Specified: boolean;
    FMarketPlaceId: WideString;
    FMarketPlaceId_Specified: boolean;
    FMarketPlaceName: WideString;
    FMarketPlaceName_Specified: boolean;
    FMarketPlaceListingId: WideString;
    FMarketPlaceListingId_Specified: boolean;
    FMarketPlaceSaleId: WideString;
    FMarketPlaceSaleId_Specified: boolean;
    FSKU: WideString;
    FSKU_Specified: boolean;
    FDateSale: TXSDateTime;
    FDateSale_Specified: boolean;
    FDatePayment: TXSDateTime;
    FDatePayment_Specified: boolean;
    FDateShipping: TXSDateTime;
    FDateShipping_Specified: boolean;
    FTrackingNumber: WideString;
    FTrackingNumber_Specified: boolean;
    FAmountPaid: Double;
    FAmountPaid_Specified: boolean;
    FPaymentMethod: PaymentMethodEnum;
    FPaymentMethod_Specified: boolean;
    FQuantity: Double;
    FQuantity_Specified: boolean;
    FPrice: Double;
    FPrice_Specified: boolean;
    FInsuranceId: WideString;
    FInsuranceId_Specified: boolean;
    FInsuranceCost: Double;
    FInsuranceCost_Specified: boolean;
    FShippingCost: Double;
    FShippingCost_Specified: boolean;
    FFinalShippingCost: Double;
    FFinalShippingCost_Specified: boolean;
    FShipperId: WideString;
    FShipperId_Specified: boolean;
    FVAT: Double;
    FVAT_Specified: boolean;
    FTotalCostWithVAT: Double;
    FTotalCostWithVAT_Specified: boolean;
    FMarketplaceFee: Double;
    FMarketplaceFee_Specified: boolean;
    FBillingAddress: MarketPlaceAddress;
    FBillingAddress_Specified: boolean;
    FShippingAddress: MarketPlaceAddress;
    FShippingAddress_Specified: boolean;
    PROCEDURE SetID(Index: Integer; CONST AWideString: WideString);
    FUNCTION ID_Specified(Index: Integer): boolean;
    PROCEDURE SetOrderID(Index: Integer; CONST AWideString: WideString);
    FUNCTION OrderID_Specified(Index: Integer): boolean;
    PROCEDURE SetOrderLineID(Index: Integer; CONST AWideString: WideString);
    FUNCTION OrderLineID_Specified(Index: Integer): boolean;
    PROCEDURE SetStatus(Index: Integer; CONST AOrderStatusEnum: OrderStatusEnum);
    FUNCTION Status_Specified(Index: Integer): boolean;
    PROCEDURE SetCustomerId(Index: Integer; CONST AWideString: WideString);
    FUNCTION CustomerId_Specified(Index: Integer): boolean;
    PROCEDURE SetMarketPlaceId(Index: Integer; CONST AWideString: WideString);
    FUNCTION MarketPlaceId_Specified(Index: Integer): boolean;
    PROCEDURE SetMarketPlaceName(Index: Integer; CONST AWideString: WideString);
    FUNCTION MarketPlaceName_Specified(Index: Integer): boolean;
    PROCEDURE SetMarketPlaceListingId(Index: Integer; CONST AWideString: WideString);
    FUNCTION MarketPlaceListingId_Specified(Index: Integer): boolean;
    PROCEDURE SetMarketPlaceSaleId(Index: Integer; CONST AWideString: WideString);
    FUNCTION MarketPlaceSaleId_Specified(Index: Integer): boolean;
    PROCEDURE SetSKU(Index: Integer; CONST AWideString: WideString);
    FUNCTION SKU_Specified(Index: Integer): boolean;
    PROCEDURE SetDateSale(Index: Integer; CONST ATXSDateTime: TXSDateTime);
    FUNCTION DateSale_Specified(Index: Integer): boolean;
    PROCEDURE SetDatePayment(Index: Integer; CONST ATXSDateTime: TXSDateTime);
    FUNCTION DatePayment_Specified(Index: Integer): boolean;
    PROCEDURE SetDateShipping(Index: Integer; CONST ATXSDateTime: TXSDateTime);
    FUNCTION DateShipping_Specified(Index: Integer): boolean;
    PROCEDURE SetTrackingNumber(Index: Integer; CONST AWideString: WideString);
    FUNCTION TrackingNumber_Specified(Index: Integer): boolean;
    PROCEDURE SetAmountPaid(Index: Integer; CONST ADouble: Double);
    FUNCTION AmountPaid_Specified(Index: Integer): boolean;
    PROCEDURE SetPaymentMethod(Index: Integer; CONST APaymentMethodEnum: PaymentMethodEnum);
    FUNCTION PaymentMethod_Specified(Index: Integer): boolean;
    PROCEDURE SetQuantity(Index: Integer; CONST ADouble: Double);
    FUNCTION Quantity_Specified(Index: Integer): boolean;
    PROCEDURE SetPrice(Index: Integer; CONST ADouble: Double);
    FUNCTION Price_Specified(Index: Integer): boolean;
    PROCEDURE SetInsuranceId(Index: Integer; CONST AWideString: WideString);
    FUNCTION InsuranceId_Specified(Index: Integer): boolean;
    PROCEDURE SetInsuranceCost(Index: Integer; CONST ADouble: Double);
    FUNCTION InsuranceCost_Specified(Index: Integer): boolean;
    PROCEDURE SetShippingCost(Index: Integer; CONST ADouble: Double);
    FUNCTION ShippingCost_Specified(Index: Integer): boolean;
    PROCEDURE SetFinalShippingCost(Index: Integer; CONST ADouble: Double);
    FUNCTION FinalShippingCost_Specified(Index: Integer): boolean;
    PROCEDURE SetShipperId(Index: Integer; CONST AWideString: WideString);
    FUNCTION ShipperId_Specified(Index: Integer): boolean;
    PROCEDURE SetVAT(Index: Integer; CONST ADouble: Double);
    FUNCTION VAT_Specified(Index: Integer): boolean;
    PROCEDURE SetTotalCostWithVAT(Index: Integer; CONST ADouble: Double);
    FUNCTION TotalCostWithVAT_Specified(Index: Integer): boolean;
    PROCEDURE SetMarketplaceFee(Index: Integer; CONST ADouble: Double);
    FUNCTION MarketplaceFee_Specified(Index: Integer): boolean;
    PROCEDURE SetBillingAddress(Index: Integer; CONST AMarketPlaceAddress: MarketPlaceAddress);
    FUNCTION BillingAddress_Specified(Index: Integer): boolean;
    PROCEDURE SetShippingAddress(Index: Integer; CONST AMarketPlaceAddress: MarketPlaceAddress);
    FUNCTION ShippingAddress_Specified(Index: Integer): boolean;
  PUBLIC
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY ID: WideString INDEX(IS_OPTN) READ FID WRITE SetID STORED ID_Specified;
    PROPERTY OrderID: WideString INDEX(IS_OPTN) READ FOrderID WRITE SetOrderID STORED OrderID_Specified;
    PROPERTY OrderLineID: WideString INDEX(IS_OPTN) READ FOrderLineID WRITE SetOrderLineID STORED OrderLineID_Specified;
    PROPERTY Status: OrderStatusEnum INDEX(IS_OPTN) READ FStatus WRITE SetStatus STORED Status_Specified;
    PROPERTY CustomerId: WideString INDEX(IS_OPTN) READ FCustomerId WRITE SetCustomerId STORED CustomerId_Specified;
    PROPERTY MarketPlaceId: WideString INDEX(IS_OPTN) READ FMarketPlaceId WRITE SetMarketPlaceId STORED MarketPlaceId_Specified;
    PROPERTY MarketPlaceName: WideString INDEX(IS_OPTN) READ FMarketPlaceName WRITE SetMarketPlaceName STORED MarketPlaceName_Specified;
    PROPERTY MarketPlaceListingId: WideString INDEX(IS_OPTN) READ FMarketPlaceListingId WRITE SetMarketPlaceListingId STORED MarketPlaceListingId_Specified;
    PROPERTY MarketPlaceSaleId: WideString INDEX(IS_OPTN) READ FMarketPlaceSaleId WRITE SetMarketPlaceSaleId STORED MarketPlaceSaleId_Specified;
    PROPERTY SKU: WideString INDEX(IS_OPTN) READ FSKU WRITE SetSKU STORED SKU_Specified;
    PROPERTY DateSale: TXSDateTime INDEX(IS_OPTN) READ FDateSale WRITE SetDateSale STORED DateSale_Specified;
    PROPERTY DatePayment: TXSDateTime INDEX(IS_OPTN) READ FDatePayment WRITE SetDatePayment STORED DatePayment_Specified;
    PROPERTY DateShipping: TXSDateTime INDEX(IS_OPTN) READ FDateShipping WRITE SetDateShipping STORED DateShipping_Specified;
    PROPERTY TrackingNumber: WideString INDEX(IS_OPTN) READ FTrackingNumber WRITE SetTrackingNumber STORED TrackingNumber_Specified;
    PROPERTY AmountPaid: Double INDEX(IS_OPTN) READ FAmountPaid WRITE SetAmountPaid STORED AmountPaid_Specified;
    PROPERTY PaymentMethod: PaymentMethodEnum INDEX(IS_OPTN) READ FPaymentMethod WRITE SetPaymentMethod STORED PaymentMethod_Specified;
    PROPERTY Quantity: Double INDEX(IS_OPTN) READ FQuantity WRITE SetQuantity STORED Quantity_Specified;
    PROPERTY Price: Double INDEX(IS_OPTN) READ FPrice WRITE SetPrice STORED Price_Specified;
    PROPERTY InsuranceId: WideString INDEX(IS_OPTN) READ FInsuranceId WRITE SetInsuranceId STORED InsuranceId_Specified;
    PROPERTY InsuranceCost: Double INDEX(IS_OPTN) READ FInsuranceCost WRITE SetInsuranceCost STORED InsuranceCost_Specified;
    PROPERTY ShippingCost: Double INDEX(IS_OPTN) READ FShippingCost WRITE SetShippingCost STORED ShippingCost_Specified;
    PROPERTY FinalShippingCost: Double INDEX(IS_OPTN) READ FFinalShippingCost WRITE SetFinalShippingCost STORED FinalShippingCost_Specified;
    PROPERTY ShipperId: WideString INDEX(IS_OPTN) READ FShipperId WRITE SetShipperId STORED ShipperId_Specified;
    PROPERTY VAT: Double INDEX(IS_OPTN) READ FVAT WRITE SetVAT STORED VAT_Specified;
    PROPERTY TotalCostWithVAT: Double INDEX(IS_OPTN) READ FTotalCostWithVAT WRITE SetTotalCostWithVAT STORED TotalCostWithVAT_Specified;
    PROPERTY MarketplaceFee: Double INDEX(IS_OPTN) READ FMarketplaceFee WRITE SetMarketplaceFee STORED MarketplaceFee_Specified;
    PROPERTY BillingAddress: MarketPlaceAddress INDEX(IS_OPTN) READ FBillingAddress WRITE SetBillingAddress STORED BillingAddress_Specified;
    PROPERTY ShippingAddress: MarketPlaceAddress INDEX(IS_OPTN) READ FShippingAddress WRITE SetShippingAddress STORED ShippingAddress_Specified;
  END;

  // ************************************************************************ //
  // XML       : MarketPlaceAddress, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  MarketPlaceAddress = CLASS(TRemotable)
  PRIVATE
    FFirstName: WideString;
    FFirstName_Specified: boolean;
    FLastName: WideString;
    FLastName_Specified: boolean;
    FAddress1: WideString;
    FAddress1_Specified: boolean;
    FAddress2: WideString;
    FAddress2_Specified: boolean;
    FCityName: WideString;
    FCityName_Specified: boolean;
    FPostalCode: WideString;
    FPostalCode_Specified: boolean;
    FCountry: WideString;
    FCountry_Specified: boolean;
    FPhone: WideString;
    FPhone_Specified: boolean;
    FMobile: WideString;
    FMobile_Specified: boolean;
    FFax: WideString;
    FFax_Specified: boolean;
    FEmail: WideString;
    FEmail_Specified: boolean;
    PROCEDURE SetFirstName(Index: Integer; CONST AWideString: WideString);
    FUNCTION FirstName_Specified(Index: Integer): boolean;
    PROCEDURE SetLastName(Index: Integer; CONST AWideString: WideString);
    FUNCTION LastName_Specified(Index: Integer): boolean;
    PROCEDURE SetAddress1(Index: Integer; CONST AWideString: WideString);
    FUNCTION Address1_Specified(Index: Integer): boolean;
    PROCEDURE SetAddress2(Index: Integer; CONST AWideString: WideString);
    FUNCTION Address2_Specified(Index: Integer): boolean;
    PROCEDURE SetCityName(Index: Integer; CONST AWideString: WideString);
    FUNCTION CityName_Specified(Index: Integer): boolean;
    PROCEDURE SetPostalCode(Index: Integer; CONST AWideString: WideString);
    FUNCTION PostalCode_Specified(Index: Integer): boolean;
    PROCEDURE SetCountry(Index: Integer; CONST AWideString: WideString);
    FUNCTION Country_Specified(Index: Integer): boolean;
    PROCEDURE SetPhone(Index: Integer; CONST AWideString: WideString);
    FUNCTION Phone_Specified(Index: Integer): boolean;
    PROCEDURE SetMobile(Index: Integer; CONST AWideString: WideString);
    FUNCTION Mobile_Specified(Index: Integer): boolean;
    PROCEDURE SetFax(Index: Integer; CONST AWideString: WideString);
    FUNCTION Fax_Specified(Index: Integer): boolean;
    PROCEDURE SetEmail(Index: Integer; CONST AWideString: WideString);
    FUNCTION Email_Specified(Index: Integer): boolean;
  PUBLISHED
    PROPERTY FirstName: WideString INDEX(IS_OPTN) READ FFirstName WRITE SetFirstName STORED FirstName_Specified;
    PROPERTY LastName: WideString INDEX(IS_OPTN) READ FLastName WRITE SetLastName STORED LastName_Specified;
    PROPERTY Address1: WideString INDEX(IS_OPTN) READ FAddress1 WRITE SetAddress1 STORED Address1_Specified;
    PROPERTY Address2: WideString INDEX(IS_OPTN) READ FAddress2 WRITE SetAddress2 STORED Address2_Specified;
    PROPERTY CityName: WideString INDEX(IS_OPTN) READ FCityName WRITE SetCityName STORED CityName_Specified;
    PROPERTY PostalCode: WideString INDEX(IS_OPTN) READ FPostalCode WRITE SetPostalCode STORED PostalCode_Specified;
    PROPERTY Country: WideString INDEX(IS_OPTN) READ FCountry WRITE SetCountry STORED Country_Specified;
    PROPERTY Phone: WideString INDEX(IS_OPTN) READ FPhone WRITE SetPhone STORED Phone_Specified;
    PROPERTY Mobile: WideString INDEX(IS_OPTN) READ FMobile WRITE SetMobile STORED Mobile_Specified;
    PROPERTY Fax: WideString INDEX(IS_OPTN) READ FFax WRITE SetFax STORED Fax_Specified;
    PROPERTY Email: WideString INDEX(IS_OPTN) READ FEmail WRITE SetEmail STORED Email_Specified;
  END;

  ArrayOfMarketPlaceOrderStatusResponse = ARRAY OF MarketPlaceOrderStatusResponse; { "urn:NWS:examples"[GblCplx] }

  // ************************************************************************ //
  // XML       : MarketPlaceOrderStatusResponse, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  MarketPlaceOrderStatusResponse = CLASS(TRemotable)
  PRIVATE
    FOrderId: WideString;
    FOrderId_Specified: boolean;
    FStatusResponse: StatusEnum;
    PROCEDURE SetOrderId(Index: Integer; CONST AWideString: WideString);
    FUNCTION OrderId_Specified(Index: Integer): boolean;
  PUBLISHED
    PROPERTY OrderId: WideString INDEX(IS_OPTN) READ FOrderId WRITE SetOrderId STORED OrderId_Specified;
    PROPERTY StatusResponse: StatusEnum READ FStatusResponse WRITE FStatusResponse;
  END;

  // ************************************************************************ //
  // XML       : EchoRequestType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  EchoRequestType = CLASS(TRemotable)
  PRIVATE
    FEchoInput: WideString;
    FEchoInput_Specified: boolean;
    PROCEDURE SetEchoInput(Index: Integer; CONST AWideString: WideString);
    FUNCTION EchoInput_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
  PUBLISHED
    PROPERTY EchoInput: WideString INDEX(IS_OPTN) READ FEchoInput WRITE SetEchoInput STORED EchoInput_Specified;
  END;

  // ************************************************************************ //
  // XML       : EchoResponseType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  EchoResponseType = CLASS(TRemotable)
  PRIVATE
    FEchoOutput: WideString;
    FEchoOutput_Specified: boolean;
    PROCEDURE SetEchoOutput(Index: Integer; CONST AWideString: WideString);
    FUNCTION EchoOutput_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
  PUBLISHED
    PROPERTY EchoOutput: WideString INDEX(IS_OPTN) READ FEchoOutput WRITE SetEchoOutput STORED EchoOutput_Specified;
  END;

  // ************************************************************************ //
  // XML       : GetItemsRequestType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetItemsRequestType = CLASS(TRemotable)
  PRIVATE
    FGetItemsInput: WideString;
    FGetItemsInput_Specified: boolean;
    FPageNumber: Int64;
    FPageNumber_Specified: boolean;
    PROCEDURE SetGetItemsInput(Index: Integer; CONST AWideString: WideString);
    FUNCTION GetItemsInput_Specified(Index: Integer): boolean;
    PROCEDURE SetPageNumber(Index: Integer; CONST AInt64: Int64);
    FUNCTION PageNumber_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
  PUBLISHED
    PROPERTY GetItemsInput: WideString INDEX(IS_OPTN) READ FGetItemsInput WRITE SetGetItemsInput STORED GetItemsInput_Specified;
    PROPERTY PageNumber: Int64 INDEX(IS_OPTN) READ FPageNumber WRITE SetPageNumber STORED PageNumber_Specified;
  END;

  // ************************************************************************ //
  // XML       : TestConnectionRequest, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TestConnectionRequest = CLASS(TRemotable)
  PRIVATE
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
  PUBLISHED
  END;

  // ************************************************************************ //
  // XML       : TestConnectionResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TestConnectionResponse = CLASS(TRemotable)
  PRIVATE
    FTestConnectionResult: StatusEnum;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
  PUBLISHED
    PROPERTY TestConnectionResult: StatusEnum READ FTestConnectionResult WRITE FTestConnectionResult;
  END;

  // ************************************************************************ //
  // XML       : AuthenticationHeader, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Info      : Header
  // ************************************************************************ //
  AuthenticationHeader2 = CLASS(AuthenticationHeader)
  PRIVATE
  PUBLISHED
  END;

  // ************************************************************************ //
  // XML       : InventoryItemsType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  InventoryItemsType = CLASS(TRemotable)
  PRIVATE
    Fnb_pages: Int64;
    Fnb_items: Int64;
    Fcur_page: Int64;
    Fitems: ArrayOfInventoryItem;
    Fitems_Specified: boolean;
    PROCEDURE Setitems(Index: Integer; CONST AArrayOfInventoryItem: ArrayOfInventoryItem);
    FUNCTION items_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY nb_pages: Int64 READ Fnb_pages WRITE Fnb_pages;
    PROPERTY nb_items: Int64 READ Fnb_items WRITE Fnb_items;
    PROPERTY cur_page: Int64 READ Fcur_page WRITE Fcur_page;
    PROPERTY items: ArrayOfInventoryItem INDEX(IS_OPTN) READ Fitems WRITE Setitems STORED items_Specified;
  END;

  // ************************************************************************ //
  // XML       : PostItems, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostItems = CLASS(TRemotable)
  PRIVATE
    Fitems: ArrayOfInventoryItem;
    Fitems_Specified: boolean;
    PROCEDURE Setitems(Index: Integer; CONST AArrayOfInventoryItem: ArrayOfInventoryItem);
    FUNCTION items_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY items: ArrayOfInventoryItem INDEX(IS_OPTN) READ Fitems WRITE Setitems STORED items_Specified;
  END;

  // ************************************************************************ //
  // XML       : PostItemsResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostItemsResponse = CLASS(TRemotable)
  PRIVATE
    FPostItemsResult: ArrayOfInventoryItemStatusResponse;
    FPostItemsResult_Specified: boolean;
    PROCEDURE SetPostItemsResult(Index: Integer; CONST AArrayOfInventoryItemStatusResponse: ArrayOfInventoryItemStatusResponse);
    FUNCTION PostItemsResult_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY PostItemsResult: ArrayOfInventoryItemStatusResponse INDEX(IS_OPTN) READ FPostItemsResult WRITE SetPostItemsResult STORED PostItemsResult_Specified;
  END;

  // ************************************************************************ //
  // XML       : GetOrders, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetOrders = CLASS(TRemotable)
  PRIVATE
    FDateSaleFrom: TXSDateTime;
    FDateSaleTo: TXSDateTime;
    FDatePaymentFrom: TXSDateTime;
    FDatePaymentTo: TXSDateTime;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;

  PUBLISHED
    PROPERTY DateSaleFrom: TXSDateTime INDEX(IS_OPTN) READ FDateSaleFrom WRITE FDateSaleFrom;
    PROPERTY DateSaleTo: TXSDateTime INDEX(IS_OPTN) READ FDateSaleTo WRITE FDateSaleTo;
    PROPERTY DatePaymentFrom: TXSDateTime INDEX(IS_OPTN) READ FDatePaymentFrom WRITE FDatePaymentFrom;
    PROPERTY DatePaymentTo: TXSDateTime INDEX(IS_OPTN) READ FDatePaymentTo WRITE FDatePaymentTo;

  END;

  // ************************************************************************ //
  // XML       : GetOrdersResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetOrdersResponse = CLASS(TRemotable)
  PRIVATE
    FGetOrdersResult: ArrayOfMarketPlaceOrder;
    FGetOrdersResult_Specified: boolean;
    PROCEDURE SetGetOrdersResult(Index: Integer; CONST AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
    FUNCTION GetOrdersResult_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY GetOrdersResult: ArrayOfMarketPlaceOrder INDEX(IS_OPTN) READ FGetOrdersResult WRITE SetGetOrdersResult STORED GetOrdersResult_Specified;
  END;

  // ************************************************************************ //
  // XML       : PostOrders, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostOrders = CLASS(TRemotable)
  PRIVATE
    Forders: ArrayOfMarketPlaceOrder;
    Forders_Specified: boolean;
    PROCEDURE Setorders(Index: Integer; CONST AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
    FUNCTION orders_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY orders: ArrayOfMarketPlaceOrder INDEX(IS_OPTN) READ Forders WRITE Setorders STORED orders_Specified;
  END;

  // ************************************************************************ //
  // XML       : PostOrdersResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostOrdersResponse = CLASS(TRemotable)
  PRIVATE
    FPostOrdersResult: ArrayOfMarketPlaceOrderStatusResponse;
    FPostOrdersResult_Specified: boolean;
    PROCEDURE SetPostOrdersResult(Index: Integer; CONST AArrayOfMarketPlaceOrderStatusResponse: ArrayOfMarketPlaceOrderStatusResponse);
    FUNCTION PostOrdersResult_Specified(Index: Integer): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROPERTY PostOrdersResult: ArrayOfMarketPlaceOrderStatusResponse INDEX(IS_OPTN) READ FPostOrdersResult WRITE SetPostOrdersResult STORED PostOrdersResult_Specified;
  END;

  TGestionNetEven = CLASS(TComponent)
  PRIVATE
    FRIO: THTTPRIO;
    FURL, FLogin, FPassword: STRING;
    FHAppel: STRING;
    FFileNameQ: STRING;
    FFileNameR: STRING;
    FPathSvg: STRING;
    FFonction: STRING;
    FDoSaveFile: Boolean;
  PUBLIC
    PROCEDURE MyRioBeforeExecute(CONST MethodName: STRING; VAR SOAPRequest: WideString);
    PROCEDURE MyRioAfterExecute(CONST MethodName: STRING; SOAPResponse: TStream);

    CONSTRUCTOR Create(Owner: TComponent; AURL, ALogin, APassword, APath: STRING); OVERLOAD;
    DESTRUCTOR Destroy; OVERRIDE;

    FUNCTION ServerIsHere(): Boolean;
    FUNCTION TestConnection(): STRING;
    FUNCTION GetCommandes(DateDeb, DateFin: TDateTime): GetOrdersResponse;
    FUNCTION PostCommandes(ACdeIdWeb, ATypeRgl: Integer; ADateRegl, ADateEnvoi: TDateTime; ANumColis: STRING): String;
    // TODO : PostOrders pour la remontée
    // TODO : Inventaires GetItems/PostItems

    PROPERTY RIO: THTTPRIO READ FRIO WRITE FRIO;

  END;

  // ************************************************************************ //
  // Espace de nommage : urn:NWS:examples
  // soapAction : %operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // Liaison   : NWSServerBinding
  // service   : NWS
  // port      : NWSServerPortType
  // URL       : http://ws.neteven.com/NWS
  // ************************************************************************ //
  NWSServerPortType = INTERFACE(IInvokable)
    ['{1E0A8B19-B13A-49C1-A5CD-EBC508520B6F}']

    FUNCTION Echo(CONST parameters: EchoRequestType): EchoResponseType; STDCALL;

    // Headers: AuthenticationHeader:pIn
    FUNCTION GetItems(CONST parameters: GetItemsRequestType): InventoryItemsType; STDCALL;

    // Headers: AuthenticationHeader:pIn
    FUNCTION TestConnection(CONST parameters: TestConnectionRequest): TestConnectionResponse; STDCALL;

    // Headers: AuthenticationHeader:pIn
    FUNCTION PostItems(CONST parameters: PostItems): PostItemsResponse; STDCALL;

    // Headers: AuthenticationHeader:pIn
    FUNCTION GetOrders(CONST parameters: GetOrders): GetOrdersResponse; STDCALL;

    // Headers: AuthenticationHeader:pIn
    FUNCTION PostOrders(CONST parameters: PostOrders): PostOrdersResponse; STDCALL;
  END;

FUNCTION NWSServerPrepare(AURL, ALogin, APassword: STRING; ARIO: THTTPRIO): NWSServerPortType;
FUNCTION CreerNWSServer(AURL, ALogin, APassword, APath: STRING): TGestionNetEven;
PROCEDURE CloseNWSServer(ANWSToFree: TGestionNetEven);
FUNCTION ComputeSignature(ALogin, AStamp, ASeed, APassword: STRING): STRING;

IMPLEMENTATION
USES SysUtils,
  MD5Api,
  IdBaseComponent,
  IdCoder,
  IdCoder3to4,
  IdCoderMIME,
  RIO;

//var
//  MyNetEven: TGestionNetEven;

FUNCTION ComputeSignature(ALogin, AStamp, ASeed, APassword: STRING): STRING;
VAR
  sToCrypt, sMD5Crypted, sBase64Crypted: STRING;
  MD5Hash: TMD5Data;
  i: integer;
  Base64: TIdEncoderMIME;
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
    sBase64Crypted := Base64.Encode(sMD5Crypted);
  FINALLY
    Base64.Free;
  END;

  Result := sBase64Crypted;
END;

CONSTRUCTOR TGestionNetEven.Create(Owner: TComponent; AURL, ALogin, APassword, APath: STRING);
BEGIN
  INHERITED Create(Owner);

  FLogin := ALogin;
  FPassword := APassword;
  FURL := AURL;
  FPathSvg := APath;

  FRIO := THTTPRio.Create(Self);
  FRIO.OnBeforeExecute := MyRioBeforeExecute;
  FRIO.OnAfterExecute := MyRioAfterExecute;

END;

DESTRUCTOR TGestionNetEven.Destroy;
BEGIN
  //  FRIO.Free; // Inutile apparement -> Opération de pointeur non correct....

  INHERITED;
END;

PROCEDURE TGestionNetEven.MyRioAfterExecute(CONST MethodName: STRING; SOAPResponse: TStream);
BEGIN
  IF (FPathSvg <> '') AND (FDoSaveFile) THEN
    TMemoryStream(SOAPResponse).SaveToFile(FFileNameR);
END;

PROCEDURE TGestionNetEven.MyRioBeforeExecute(CONST MethodName: STRING; VAR SOAPRequest: WideString);
VAR
  bNotExist: Boolean;
  TS: TStringList;

BEGIN
  IF (FPathSvg <> '') AND (FDoSaveFile) THEN
  BEGIN
    REPEAT
      FHAppel := FormatDateTime('yyyymmddhhnnss', Now);
      FFileNameQ := FPathSvg + FFonction + '_Request_' + FHAppel + '.xml';
      FFileNameR := FPathSvg + FFonction + '_Response_' + FHAppel + '.xml';
      bNotExist := (NOT FileExists(FFileNameQ)) AND (NOT FileExists(FFileNameQ));

      sleep(100);
    UNTIL bNotExist;
  END;

  SoapRequest := StringReplace(SoapRequest, #13#10, '', [rfIgnoreCase, rfReplaceAll]);
  SoapRequest := StringReplace(SoapRequest, '<?xml version="1.0"?>', '<?xml version="1.0" encoding="UTF-8"?>', [rfIgnoreCase, rfReplaceAll]);

  IF FDoSaveFile THEN
  BEGIN
    TS := TStringList.Create;
    TRY
      TS.Text := SoapRequest;
      TS.SaveToFile(FFileNameQ);
    FINALLY
      TS.Free;
    END;
  END;

END;

FUNCTION TGestionNetEven.PostCommandes(ACdeIdWeb, ATypeRgl: Integer;
  ADateRegl, ADateEnvoi: TDateTime; ANumColis: STRING): String;

VAR
  sService: NWSServerPortType;

  rCdes: PostOrders; // Request
  aCdes: PostOrdersResponse; // Answer

  MyArray : ArrayOfMarketPlaceOrder;

BEGIN
  FFonction := 'PostOrders';
  FDoSaveFile := True;

  rCdes := PostOrders.Create;
  TRY
    //   (Accepted, Canceled, NonConformantAuthorization, NonConformantFormat, Rejected, UnexpectedInformation, Inserted, Updated, Error);

    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);


    SetLength(MyArray, 1);

    MyArray[0] := MarketPlaceOrder.Create;

    rCdes.Orders := MyArray;

    rCdes.Orders[0].OrderID := IntToStr(ACdeIdWeb);

    IF ADateRegl <> 0 THEN
    BEGIN
      IF (ATypeRgl < 0) OR (ATypeRgl > 4) THEN
        ATypeRgl := 3; // Other quand on sait pas ce que c'est

      rCdes.Orders[0].DatePayment := TXSDateTime.Create();
      rCdes.Orders[0].DatePayment.AsDateTime := ADateRegl;
      rCdes.Orders[0].PaymentMethod := PaymentMethodEnum(ATypeRgl);
    END;

    IF ADateEnvoi >= 0 THEN
    BEGIN
      rCdes.Orders[0].DateShipping := TXSDateTime.Create();

      IF ADateEnvoi = 0 THEN
        rCdes.Orders[0].DateShipping.XSToNative('')
      else
        rCdes.Orders[0].DateShipping.AsDateTime := ADateEnvoi;
        
      rCdes.Orders[0].TrackingNumber := ANumColis;
    END;

    aCdes := sService.PostOrders(rCdes);
    // (Accepted, Canceled, NonConformantAuthorization, NonConformantFormat, Rejected, UnexpectedInformation, Inserted, Updated, Error);
    CASE aCdes.PostOrdersResult[0].StatusResponse OF
      NetEvenWS.Accepted: Result := 'Accepted';
      NetEvenWS.Canceled: Result := 'Canceled';
      NetEvenWS.NonConformantAuthorization: Result := 'NCA';
      NetEvenWS.NonConformantFormat: Result := 'NCF';
      NetEvenWS.Rejected: Result := 'Rejected';
      NetEvenWS.UnexpectedInformation: Result := 'UnexpectedInformation';
      NetEvenWS.Inserted: Result := 'Inserted';
      NetEvenWS.Updated: Result := 'Updated';
      NetEvenWS.Error: Result := 'Error';
    END;

  FINALLY
    rCdes.Free;
  END;
END;

FUNCTION TGestionNetEven.ServerIsHere: Boolean;
VAR
  erTest: EchoRequestType;
  eaTest: EchoResponseType;

  sService: NWSServerPortType;
BEGIN
  FFonction := 'Echo';
  FDoSaveFile := False;

  erTest := EchoRequestType.Create;
  TRY
    erTest.EchoInput := ComputeSignature('Server', 'Are', 'You', 'Here');
    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);

    eaTest := sService.Echo(erTest);

    IF eaTest.EchoOutput = erTest.EchoInput THEN
      Result := True
    ELSE
      Result := False;

  FINALLY
    eaTest.Free;
    erTest.Free;
  END;
END;

FUNCTION TGestionNetEven.GetCommandes(DateDeb, DateFin: TDateTime): GetOrdersResponse;
VAR
  rCdes: GetOrders;

  sService: NWSServerPortType;
BEGIN
  FFonction := 'GetOrders';
  FDoSaveFile := True;

  rCdes := GetOrders.Create;
  TRY
    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);

    rCdes.DateSaleFrom.AsDateTime := DateDeb;
    rCdes.DateSaleTo.AsDateTime := DateFin;
    rCdes.DatePaymentFrom.XSToNative(''); // Une date ancienne
    rCdes.DatePaymentTo.XSToNative(''); // Demain

    Result := sService.GetOrders(rCdes);
  FINALLY
    rCdes.Free;
  END;
END;

FUNCTION TGestionNetEven.TestConnection: STRING;
VAR
  rConnect: TestConnectionRequest;
  aConnect: TestConnectionResponse;

  sService: NWSServerPortType;
BEGIN
  FFonction := 'TestConnection';
  FDoSaveFile := False;

  rConnect := TestConnectionRequest.Create;
  TRY
    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);
    TRY
      aConnect := sService.TestConnection(rConnect);

      CASE aConnect.TestConnectionResult OF
        NetEvenWS.Accepted: Result := 'OK';
        NetEvenWS.Canceled: Result := 'Cancel';
        NetEvenWS.NonConformantAuthorization: Result := 'NCA';
        NetEvenWS.NonConformantFormat: Result := 'NCF';
        NetEvenWS.Rejected: Result := 'Reject';
        NetEvenWS.UnexpectedInformation: Result := 'Unexp';
        NetEvenWS.Error: Result := 'Error';
      ELSE Result := 'Else';
      END; // CASE
    EXCEPT
      Result := 'Error';
    END;
  FINALLY
    IF Assigned(aConnect) THEN
      aConnect.Free;
    IF Assigned(rConnect) THEN
      rConnect.Free;
  END;
END;

FUNCTION CreerNWSServer(AURL, ALogin, APassword, APath: STRING): TGestionNetEven;
BEGIN
  Result := TGestionNetEven.Create(NIL, AURL, ALogin, APassword, APath);
END;

PROCEDURE CloseNWSServer(ANWSToFree: TGestionNetEven);
BEGIN
  IF Assigned(ANWSToFree) THEN
    ANWSToFree.Free;
END;

FUNCTION NWSServerPrepare(AURL, ALogin, APassword: STRING; ARIO: THTTPRIO): NWSServerPortType;
CONST
  defWSDL = 'http://ws.neteven.com/NWS';
  defURL = 'http://ws.neteven.com/NWS';
  defSvc = 'NWS';
  defPrt = 'NWSServerPortType';
VAR
  MyHeader: AuthenticationHeader;
  utcTime: SystemTime;
BEGIN
  Result := NIL;

  TRY
    IF AURL = '' THEN
      AURL := defWSDL;

    // URL et params divers
    ARIO.WSDLLocation := AURL;
    ARIO.Service := defSvc;
    ARIO.Port := defPrt;
    ARIO.URL := AURL;

    MyHeader := AuthenticationHeader.Create;
    MyHeader.Method := '*';
    MyHeader.Login := ALogin;
    MyHeader.Seed := 'MySeed';

    GetSystemTime(utcTime);
    MyHeader.Stamp := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', SystemTimeToDateTime(utcTime));
    MyHeader.Signature := ComputeSignature(MyHeader.Login, MyHeader.Stamp, MyHeader.Seed, APassword);

    (ARIO AS ISOAPHeaders).Send(MyHeader);

    Result := (ARIO AS NWSServerPortType);
  FINALLY

  END;
END;

DESTRUCTOR InventoryItem.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(FArrayOfSpecificFields) - 1 DO
    FreeAndNil(FArrayOfSpecificFields[I]);
  SetLength(FArrayOfSpecificFields, 0);
  FreeAndNil(FDateAvailability);
  INHERITED Destroy;
END;

PROCEDURE InventoryItem.SetSubTitle(Index: Integer; CONST AWideString: WideString);
BEGIN
  FSubTitle := AWideString;
  FSubTitle_Specified := True;
END;

FUNCTION InventoryItem.SubTitle_Specified(Index: Integer): boolean;
BEGIN
  Result := FSubTitle_Specified;
END;

PROCEDURE InventoryItem.SetDescription(Index: Integer; CONST AWideString: WideString);
BEGIN
  FDescription := AWideString;
  FDescription_Specified := True;
END;

FUNCTION InventoryItem.Description_Specified(Index: Integer): boolean;
BEGIN
  Result := FDescription_Specified;
END;

PROCEDURE InventoryItem.SetComment(Index: Integer; CONST AWideString: WideString);
BEGIN
  FComment := AWideString;
  FComment_Specified := True;
END;

FUNCTION InventoryItem.Comment_Specified(Index: Integer): boolean;
BEGIN
  Result := FComment_Specified;
END;

PROCEDURE InventoryItem.SetSKUFamily(Index: Integer; CONST AWideString: WideString);
BEGIN
  FSKUFamily := AWideString;
  FSKUFamily_Specified := True;
END;

FUNCTION InventoryItem.SKUFamily_Specified(Index: Integer): boolean;
BEGIN
  Result := FSKUFamily_Specified;
END;

PROCEDURE InventoryItem.SetBrand(Index: Integer; CONST AWideString: WideString);
BEGIN
  FBrand := AWideString;
  FBrand_Specified := True;
END;

FUNCTION InventoryItem.Brand_Specified(Index: Integer): boolean;
BEGIN
  Result := FBrand_Specified;
END;

PROCEDURE InventoryItem.SetCodeProduit(Index: Integer; CONST AWideString: WideString);
BEGIN
  FCodeProduit := AWideString;
  FCodeProduit_Specified := True;
END;

FUNCTION InventoryItem.CodeProduit_Specified(Index: Integer): boolean;
BEGIN
  Result := FCodeProduit_Specified;
END;

PROCEDURE InventoryItem.SetTypeCodeProduit(Index: Integer; CONST AWideString: WideString);
BEGIN
  FTypeCodeProduit := AWideString;
  FTypeCodeProduit_Specified := True;
END;

FUNCTION InventoryItem.TypeCodeProduit_Specified(Index: Integer): boolean;
BEGIN
  Result := FTypeCodeProduit_Specified;
END;

PROCEDURE InventoryItem.SetEAN(Index: Integer; CONST AWideString: WideString);
BEGIN
  FEAN := AWideString;
  FEAN_Specified := True;
END;

FUNCTION InventoryItem.EAN_Specified(Index: Integer): boolean;
BEGIN
  Result := FEAN_Specified;
END;

PROCEDURE InventoryItem.SetUPC(Index: Integer; CONST AWideString: WideString);
BEGIN
  FUPC := AWideString;
  FUPC_Specified := True;
END;

FUNCTION InventoryItem.UPC_Specified(Index: Integer): boolean;
BEGIN
  Result := FUPC_Specified;
END;

PROCEDURE InventoryItem.SetISBN(Index: Integer; CONST AWideString: WideString);
BEGIN
  FISBN := AWideString;
  FISBN_Specified := True;
END;

FUNCTION InventoryItem.ISBN_Specified(Index: Integer): boolean;
BEGIN
  Result := FISBN_Specified;
END;

PROCEDURE InventoryItem.SetASIN(Index: Integer; CONST AWideString: WideString);
BEGIN
  FASIN := AWideString;
  FASIN_Specified := True;
END;

FUNCTION InventoryItem.ASIN_Specified(Index: Integer): boolean;
BEGIN
  Result := FASIN_Specified;
END;

PROCEDURE InventoryItem.SetPartNumber(Index: Integer; CONST AWideString: WideString);
BEGIN
  FPartNumber := AWideString;
  FPartNumber_Specified := True;
END;

FUNCTION InventoryItem.PartNumber_Specified(Index: Integer): boolean;
BEGIN
  Result := FPartNumber_Specified;
END;

PROCEDURE InventoryItem.SetCost(Index: Integer; CONST ADouble: Double);
BEGIN
  FCost := ADouble;
  FCost_Specified := True;
END;

FUNCTION InventoryItem.Cost_Specified(Index: Integer): boolean;
BEGIN
  Result := FCost_Specified;
END;

PROCEDURE InventoryItem.SetDateAvailability(Index: Integer; CONST ATXSDateTime: TXSDateTime);
BEGIN
  FDateAvailability := ATXSDateTime;
  FDateAvailability_Specified := True;
END;

FUNCTION InventoryItem.DateAvailability_Specified(Index: Integer): boolean;
BEGIN
  Result := FDateAvailability_Specified;
END;

PROCEDURE InventoryItem.SetPriceStarting(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceStarting := ADouble;
  FPriceStarting_Specified := True;
END;

FUNCTION InventoryItem.PriceStarting_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceStarting_Specified;
END;

PROCEDURE InventoryItem.SetPriceReserved(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceReserved := ADouble;
  FPriceReserved_Specified := True;
END;

FUNCTION InventoryItem.PriceReserved_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceReserved_Specified;
END;

PROCEDURE InventoryItem.SetPriceRetail(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceRetail := ADouble;
  FPriceRetail_Specified := True;
END;

FUNCTION InventoryItem.PriceRetail_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceRetail_Specified;
END;

PROCEDURE InventoryItem.SetPriceSecondChance(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceSecondChance := ADouble;
  FPriceSecondChance_Specified := True;
END;

FUNCTION InventoryItem.PriceSecondChance_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceSecondChance_Specified;
END;

PROCEDURE InventoryItem.SetPriceBestOffer(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceBestOffer := ADouble;
  FPriceBestOffer_Specified := True;
END;

FUNCTION InventoryItem.PriceBestOffer_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceBestOffer_Specified;
END;

PROCEDURE InventoryItem.SetEtat(Index: Integer; CONST AEtatEnum: EtatEnum);
BEGIN
  FEtat := AEtatEnum;
  FEtat_Specified := True;
END;

FUNCTION InventoryItem.Etat_Specified(Index: Integer): boolean;
BEGIN
  Result := FEtat_Specified;
END;

PROCEDURE InventoryItem.SetLotSize(Index: Integer; CONST AInt64: Int64);
BEGIN
  FLotSize := AInt64;
  FLotSize_Specified := True;
END;

FUNCTION InventoryItem.LotSize_Specified(Index: Integer): boolean;
BEGIN
  Result := FLotSize_Specified;
END;

PROCEDURE InventoryItem.SetSupplierName(Index: Integer; CONST AWideString: WideString);
BEGIN
  FSupplierName := AWideString;
  FSupplierName_Specified := True;
END;

FUNCTION InventoryItem.SupplierName_Specified(Index: Integer): boolean;
BEGIN
  Result := FSupplierName_Specified;
END;

PROCEDURE InventoryItem.SetClassification(Index: Integer; CONST AWideString: WideString);
BEGIN
  FClassification := AWideString;
  FClassification_Specified := True;
END;

FUNCTION InventoryItem.Classification_Specified(Index: Integer): boolean;
BEGIN
  Result := FClassification_Specified;
END;

PROCEDURE InventoryItem.SetWeight(Index: Integer; CONST ADouble: Double);
BEGIN
  FWeight := ADouble;
  FWeight_Specified := True;
END;

FUNCTION InventoryItem.Weight_Specified(Index: Integer): boolean;
BEGIN
  Result := FWeight_Specified;
END;

PROCEDURE InventoryItem.SetHeight(Index: Integer; CONST ADouble: Double);
BEGIN
  FHeight := ADouble;
  FHeight_Specified := True;
END;

FUNCTION InventoryItem.Height_Specified(Index: Integer): boolean;
BEGIN
  Result := FHeight_Specified;
END;

PROCEDURE InventoryItem.SetWidth(Index: Integer; CONST ADouble: Double);
BEGIN
  FWidth := ADouble;
  FWidth_Specified := True;
END;

FUNCTION InventoryItem.Width_Specified(Index: Integer): boolean;
BEGIN
  Result := FWidth_Specified;
END;

PROCEDURE InventoryItem.SetDepth(Index: Integer; CONST ADouble: Double);
BEGIN
  FDepth := ADouble;
  FDepth_Specified := True;
END;

FUNCTION InventoryItem.Depth_Specified(Index: Integer): boolean;
BEGIN
  Result := FDepth_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingLocal1(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingLocal1 := ADouble;
  FPriceShippingLocal1_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingLocal1_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingLocal1_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingSuppLocal1(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingSuppLocal1 := ADouble;
  FPriceShippingSuppLocal1_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingSuppLocal1_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingSuppLocal1_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingLocal2(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingLocal2 := ADouble;
  FPriceShippingLocal2_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingLocal2_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingLocal2_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingSuppLocal2(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingSuppLocal2 := ADouble;
  FPriceShippingSuppLocal2_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingSuppLocal2_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingSuppLocal2_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingLocal3(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingLocal3 := ADouble;
  FPriceShippingLocal3_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingLocal3_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingLocal3_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingSuppLocal3(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingSuppLocal3 := ADouble;
  FPriceShippingSuppLocal3_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingSuppLocal3_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingSuppLocal3_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingInt1(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingInt1 := ADouble;
  FPriceShippingInt1_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingInt1_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingInt1_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingSuppInt1(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingSuppInt1 := ADouble;
  FPriceShippingSuppInt1_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingSuppInt1_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingSuppInt1_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingInt2(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingInt2 := ADouble;
  FPriceShippingInt2_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingInt2_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingInt2_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingSuppInt2(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingSuppInt2 := ADouble;
  FPriceShippingSuppInt2_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingSuppInt2_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingSuppInt2_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingInt3(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingInt3 := ADouble;
  FPriceShippingInt3_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingInt3_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingInt3_Specified;
END;

PROCEDURE InventoryItem.SetPriceShippingSuppInt3(Index: Integer; CONST ADouble: Double);
BEGIN
  FPriceShippingSuppInt3 := ADouble;
  FPriceShippingSuppInt3_Specified := True;
END;

FUNCTION InventoryItem.PriceShippingSuppInt3_Specified(Index: Integer): boolean;
BEGIN
  Result := FPriceShippingSuppInt3_Specified;
END;

PROCEDURE InventoryItem.SetImage1(Index: Integer; CONST AWideString: WideString);
BEGIN
  FImage1 := AWideString;
  FImage1_Specified := True;
END;

FUNCTION InventoryItem.Image1_Specified(Index: Integer): boolean;
BEGIN
  Result := FImage1_Specified;
END;

PROCEDURE InventoryItem.SetImage2(Index: Integer; CONST AWideString: WideString);
BEGIN
  FImage2 := AWideString;
  FImage2_Specified := True;
END;

FUNCTION InventoryItem.Image2_Specified(Index: Integer): boolean;
BEGIN
  Result := FImage2_Specified;
END;

PROCEDURE InventoryItem.SetImage3(Index: Integer; CONST AWideString: WideString);
BEGIN
  FImage3 := AWideString;
  FImage3_Specified := True;
END;

FUNCTION InventoryItem.Image3_Specified(Index: Integer): boolean;
BEGIN
  Result := FImage3_Specified;
END;

PROCEDURE InventoryItem.SetImage4(Index: Integer; CONST AWideString: WideString);
BEGIN
  FImage4 := AWideString;
  FImage4_Specified := True;
END;

FUNCTION InventoryItem.Image4_Specified(Index: Integer): boolean;
BEGIN
  Result := FImage4_Specified;
END;

PROCEDURE InventoryItem.SetImage5(Index: Integer; CONST AWideString: WideString);
BEGIN
  FImage5 := AWideString;
  FImage5_Specified := True;
END;

FUNCTION InventoryItem.Image5_Specified(Index: Integer): boolean;
BEGIN
  Result := FImage5_Specified;
END;

PROCEDURE InventoryItem.SetImage6(Index: Integer; CONST AWideString: WideString);
BEGIN
  FImage6 := AWideString;
  FImage6_Specified := True;
END;

FUNCTION InventoryItem.Image6_Specified(Index: Integer): boolean;
BEGIN
  Result := FImage6_Specified;
END;

PROCEDURE InventoryItem.SetAttribute1(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute1 := AWideString;
  FAttribute1_Specified := True;
END;

FUNCTION InventoryItem.Attribute1_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute1_Specified;
END;

PROCEDURE InventoryItem.SetAttribute2(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute2 := AWideString;
  FAttribute2_Specified := True;
END;

FUNCTION InventoryItem.Attribute2_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute2_Specified;
END;

PROCEDURE InventoryItem.SetAttribute3(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute3 := AWideString;
  FAttribute3_Specified := True;
END;

FUNCTION InventoryItem.Attribute3_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute3_Specified;
END;

PROCEDURE InventoryItem.SetAttribute4(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute4 := AWideString;
  FAttribute4_Specified := True;
END;

FUNCTION InventoryItem.Attribute4_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute4_Specified;
END;

PROCEDURE InventoryItem.SetAttribute5(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute5 := AWideString;
  FAttribute5_Specified := True;
END;

FUNCTION InventoryItem.Attribute5_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute5_Specified;
END;

PROCEDURE InventoryItem.SetAttribute6(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute6 := AWideString;
  FAttribute6_Specified := True;
END;

FUNCTION InventoryItem.Attribute6_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute6_Specified;
END;

PROCEDURE InventoryItem.SetAttribute7(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute7 := AWideString;
  FAttribute7_Specified := True;
END;

FUNCTION InventoryItem.Attribute7_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute7_Specified;
END;

PROCEDURE InventoryItem.SetAttribute8(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute8 := AWideString;
  FAttribute8_Specified := True;
END;

FUNCTION InventoryItem.Attribute8_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute8_Specified;
END;

PROCEDURE InventoryItem.SetAttribute9(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute9 := AWideString;
  FAttribute9_Specified := True;
END;

FUNCTION InventoryItem.Attribute9_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute9_Specified;
END;

PROCEDURE InventoryItem.SetAttribute10(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute10 := AWideString;
  FAttribute10_Specified := True;
END;

FUNCTION InventoryItem.Attribute10_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute10_Specified;
END;

PROCEDURE InventoryItem.SetAttribute11(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute11 := AWideString;
  FAttribute11_Specified := True;
END;

FUNCTION InventoryItem.Attribute11_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute11_Specified;
END;

PROCEDURE InventoryItem.SetAttribute12(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute12 := AWideString;
  FAttribute12_Specified := True;
END;

FUNCTION InventoryItem.Attribute12_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute12_Specified;
END;

PROCEDURE InventoryItem.SetAttribute13(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute13 := AWideString;
  FAttribute13_Specified := True;
END;

FUNCTION InventoryItem.Attribute13_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute13_Specified;
END;

PROCEDURE InventoryItem.SetAttribute14(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute14 := AWideString;
  FAttribute14_Specified := True;
END;

FUNCTION InventoryItem.Attribute14_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute14_Specified;
END;

PROCEDURE InventoryItem.SetAttribute15(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute15 := AWideString;
  FAttribute15_Specified := True;
END;

FUNCTION InventoryItem.Attribute15_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute15_Specified;
END;

PROCEDURE InventoryItem.SetAttribute16(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute16 := AWideString;
  FAttribute16_Specified := True;
END;

FUNCTION InventoryItem.Attribute16_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute16_Specified;
END;

PROCEDURE InventoryItem.SetAttribute17(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute17 := AWideString;
  FAttribute17_Specified := True;
END;

FUNCTION InventoryItem.Attribute17_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute17_Specified;
END;

PROCEDURE InventoryItem.SetAttribute18(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute18 := AWideString;
  FAttribute18_Specified := True;
END;

FUNCTION InventoryItem.Attribute18_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute18_Specified;
END;

PROCEDURE InventoryItem.SetAttribute19(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute19 := AWideString;
  FAttribute19_Specified := True;
END;

FUNCTION InventoryItem.Attribute19_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute19_Specified;
END;

PROCEDURE InventoryItem.SetAttribute20(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAttribute20 := AWideString;
  FAttribute20_Specified := True;
END;

FUNCTION InventoryItem.Attribute20_Specified(Index: Integer): boolean;
BEGIN
  Result := FAttribute20_Specified;
END;

PROCEDURE InventoryItem.SetArrayOfSpecificFields(Index: Integer; CONST AArrayOfSpecificFields: ArrayOfSpecificFields);
BEGIN
  FArrayOfSpecificFields := AArrayOfSpecificFields;
  FArrayOfSpecificFields_Specified := True;
END;

FUNCTION InventoryItem.ArrayOfSpecificFields_Specified(Index: Integer): boolean;
BEGIN
  Result := FArrayOfSpecificFields_Specified;
END;

PROCEDURE InventoryItemStatusResponse.SetItemCode(Index: Integer; CONST AWideString: WideString);
BEGIN
  FItemCode := AWideString;
  FItemCode_Specified := True;
END;

FUNCTION InventoryItemStatusResponse.ItemCode_Specified(Index: Integer): boolean;
BEGIN
  Result := FItemCode_Specified;
END;

DESTRUCTOR MarketPlaceOrder.Destroy;
BEGIN
  FreeAndNil(FDateSale);
  FreeAndNil(FDatePayment);
  FreeAndNil(FDateShipping);
  FreeAndNil(FBillingAddress);
  FreeAndNil(FShippingAddress);
  INHERITED Destroy;
END;

PROCEDURE MarketPlaceOrder.SetID(Index: Integer; CONST AWideString: WideString);
BEGIN
  FID := AWideString;
  FID_Specified := True;
END;

FUNCTION MarketPlaceOrder.ID_Specified(Index: Integer): boolean;
BEGIN
  Result := FID_Specified;
END;

PROCEDURE MarketPlaceOrder.SetOrderID(Index: Integer; CONST AWideString: WideString);
BEGIN
  FOrderID := AWideString;
  FOrderID_Specified := True;
END;

FUNCTION MarketPlaceOrder.OrderID_Specified(Index: Integer): boolean;
BEGIN
  Result := FOrderID_Specified;
END;

PROCEDURE MarketPlaceOrder.SetOrderLineID(Index: Integer; CONST AWideString: WideString);
BEGIN
  FOrderLineID := AWideString;
  FOrderLineID_Specified := True;
END;

FUNCTION MarketPlaceOrder.OrderLineID_Specified(Index: Integer): boolean;
BEGIN
  Result := FOrderLineID_Specified;
END;

PROCEDURE MarketPlaceOrder.SetStatus(Index: Integer; CONST AOrderStatusEnum: OrderStatusEnum);
BEGIN
  FStatus := AOrderStatusEnum;
  FStatus_Specified := True;
END;

FUNCTION MarketPlaceOrder.Status_Specified(Index: Integer): boolean;
BEGIN
  Result := FStatus_Specified;
END;

PROCEDURE MarketPlaceOrder.SetCustomerId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FCustomerId := AWideString;
  FCustomerId_Specified := True;
END;

FUNCTION MarketPlaceOrder.CustomerId_Specified(Index: Integer): boolean;
BEGIN
  Result := FCustomerId_Specified;
END;

PROCEDURE MarketPlaceOrder.SetMarketPlaceId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FMarketPlaceId := AWideString;
  FMarketPlaceId_Specified := True;
END;

FUNCTION MarketPlaceOrder.MarketPlaceId_Specified(Index: Integer): boolean;
BEGIN
  Result := FMarketPlaceId_Specified;
END;

PROCEDURE MarketPlaceOrder.SetMarketPlaceName(Index: Integer; CONST AWideString: WideString);
BEGIN
  FMarketPlaceName := AWideString;
  FMarketPlaceName_Specified := True;
END;

FUNCTION MarketPlaceOrder.MarketPlaceName_Specified(Index: Integer): boolean;
BEGIN
  Result := FMarketPlaceName_Specified;
END;

PROCEDURE MarketPlaceOrder.SetMarketPlaceListingId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FMarketPlaceListingId := AWideString;
  FMarketPlaceListingId_Specified := True;
END;

FUNCTION MarketPlaceOrder.MarketPlaceListingId_Specified(Index: Integer): boolean;
BEGIN
  Result := FMarketPlaceListingId_Specified;
END;

PROCEDURE MarketPlaceOrder.SetMarketPlaceSaleId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FMarketPlaceSaleId := AWideString;
  FMarketPlaceSaleId_Specified := True;
END;

FUNCTION MarketPlaceOrder.MarketPlaceSaleId_Specified(Index: Integer): boolean;
BEGIN
  Result := FMarketPlaceSaleId_Specified;
END;

PROCEDURE MarketPlaceOrder.SetSKU(Index: Integer; CONST AWideString: WideString);
BEGIN
  FSKU := AWideString;
  FSKU_Specified := True;
END;

FUNCTION MarketPlaceOrder.SKU_Specified(Index: Integer): boolean;
BEGIN
  Result := FSKU_Specified;
END;

PROCEDURE MarketPlaceOrder.SetDateSale(Index: Integer; CONST ATXSDateTime: TXSDateTime);
BEGIN
  FDateSale := ATXSDateTime;
  FDateSale_Specified := True;
END;

FUNCTION MarketPlaceOrder.DateSale_Specified(Index: Integer): boolean;
BEGIN
  Result := FDateSale_Specified;
END;

PROCEDURE MarketPlaceOrder.SetDatePayment(Index: Integer; CONST ATXSDateTime: TXSDateTime);
BEGIN
  FDatePayment := ATXSDateTime;
  FDatePayment_Specified := True;
END;

FUNCTION MarketPlaceOrder.DatePayment_Specified(Index: Integer): boolean;
BEGIN
  Result := FDatePayment_Specified;
END;

PROCEDURE MarketPlaceOrder.SetDateShipping(Index: Integer; CONST ATXSDateTime: TXSDateTime);
BEGIN
  FDateShipping := ATXSDateTime;
  FDateShipping_Specified := True;
END;

FUNCTION MarketPlaceOrder.DateShipping_Specified(Index: Integer): boolean;
BEGIN
  Result := FDateShipping_Specified;
END;

PROCEDURE MarketPlaceOrder.SetTrackingNumber(Index: Integer; CONST AWideString: WideString);
BEGIN
  FTrackingNumber := AWideString;
  FTrackingNumber_Specified := True;
END;

FUNCTION MarketPlaceOrder.TrackingNumber_Specified(Index: Integer): boolean;
BEGIN
  Result := FTrackingNumber_Specified;
END;

PROCEDURE MarketPlaceOrder.SetAmountPaid(Index: Integer; CONST ADouble: Double);
BEGIN
  FAmountPaid := ADouble;
  FAmountPaid_Specified := True;
END;

FUNCTION MarketPlaceOrder.AmountPaid_Specified(Index: Integer): boolean;
BEGIN
  Result := FAmountPaid_Specified;
END;

PROCEDURE MarketPlaceOrder.SetPaymentMethod(Index: Integer; CONST APaymentMethodEnum: PaymentMethodEnum);
BEGIN
  FPaymentMethod := APaymentMethodEnum;
  FPaymentMethod_Specified := True;
END;

FUNCTION MarketPlaceOrder.PaymentMethod_Specified(Index: Integer): boolean;
BEGIN
  Result := FPaymentMethod_Specified;
END;

PROCEDURE MarketPlaceOrder.SetQuantity(Index: Integer; CONST ADouble: Double);
BEGIN
  FQuantity := ADouble;
  FQuantity_Specified := True;
END;

FUNCTION MarketPlaceOrder.Quantity_Specified(Index: Integer): boolean;
BEGIN
  Result := FQuantity_Specified;
END;

PROCEDURE MarketPlaceOrder.SetPrice(Index: Integer; CONST ADouble: Double);
BEGIN
  FPrice := ADouble;
  FPrice_Specified := True;
END;

FUNCTION MarketPlaceOrder.Price_Specified(Index: Integer): boolean;
BEGIN
  Result := FPrice_Specified;
END;

PROCEDURE MarketPlaceOrder.SetInsuranceId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FInsuranceId := AWideString;
  FInsuranceId_Specified := True;
END;

FUNCTION MarketPlaceOrder.InsuranceId_Specified(Index: Integer): boolean;
BEGIN
  Result := FInsuranceId_Specified;
END;

PROCEDURE MarketPlaceOrder.SetInsuranceCost(Index: Integer; CONST ADouble: Double);
BEGIN
  FInsuranceCost := ADouble;
  FInsuranceCost_Specified := True;
END;

FUNCTION MarketPlaceOrder.InsuranceCost_Specified(Index: Integer): boolean;
BEGIN
  Result := FInsuranceCost_Specified;
END;

PROCEDURE MarketPlaceOrder.SetShippingCost(Index: Integer; CONST ADouble: Double);
BEGIN
  FShippingCost := ADouble;
  FShippingCost_Specified := True;
END;

FUNCTION MarketPlaceOrder.ShippingCost_Specified(Index: Integer): boolean;
BEGIN
  Result := FShippingCost_Specified;
END;

PROCEDURE MarketPlaceOrder.SetFinalShippingCost(Index: Integer; CONST ADouble: Double);
BEGIN
  FFinalShippingCost := ADouble;
  FFinalShippingCost_Specified := True;
END;

FUNCTION MarketPlaceOrder.FinalShippingCost_Specified(Index: Integer): boolean;
BEGIN
  Result := FFinalShippingCost_Specified;
END;

PROCEDURE MarketPlaceOrder.SetShipperId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FShipperId := AWideString;
  FShipperId_Specified := True;
END;

FUNCTION MarketPlaceOrder.ShipperId_Specified(Index: Integer): boolean;
BEGIN
  Result := FShipperId_Specified;
END;

PROCEDURE MarketPlaceOrder.SetVAT(Index: Integer; CONST ADouble: Double);
BEGIN
  FVAT := ADouble;
  FVAT_Specified := True;
END;

FUNCTION MarketPlaceOrder.VAT_Specified(Index: Integer): boolean;
BEGIN
  Result := FVAT_Specified;
END;

PROCEDURE MarketPlaceOrder.SetTotalCostWithVAT(Index: Integer; CONST ADouble: Double);
BEGIN
  FTotalCostWithVAT := ADouble;
  FTotalCostWithVAT_Specified := True;
END;

FUNCTION MarketPlaceOrder.TotalCostWithVAT_Specified(Index: Integer): boolean;
BEGIN
  Result := FTotalCostWithVAT_Specified;
END;

PROCEDURE MarketPlaceOrder.SetMarketplaceFee(Index: Integer; CONST ADouble: Double);
BEGIN
  FMarketplaceFee := ADouble;
  FMarketplaceFee_Specified := True;
END;

FUNCTION MarketPlaceOrder.MarketplaceFee_Specified(Index: Integer): boolean;
BEGIN
  Result := FMarketplaceFee_Specified;
END;

PROCEDURE MarketPlaceOrder.SetBillingAddress(Index: Integer; CONST AMarketPlaceAddress: MarketPlaceAddress);
BEGIN
  FBillingAddress := AMarketPlaceAddress;
  FBillingAddress_Specified := True;
END;

FUNCTION MarketPlaceOrder.BillingAddress_Specified(Index: Integer): boolean;
BEGIN
  Result := FBillingAddress_Specified;
END;

PROCEDURE MarketPlaceOrder.SetShippingAddress(Index: Integer; CONST AMarketPlaceAddress: MarketPlaceAddress);
BEGIN
  FShippingAddress := AMarketPlaceAddress;
  FShippingAddress_Specified := True;
END;

FUNCTION MarketPlaceOrder.ShippingAddress_Specified(Index: Integer): boolean;
BEGIN
  Result := FShippingAddress_Specified;
END;

PROCEDURE MarketPlaceAddress.SetFirstName(Index: Integer; CONST AWideString: WideString);
BEGIN
  FFirstName := AWideString;
  FFirstName_Specified := True;
END;

FUNCTION MarketPlaceAddress.FirstName_Specified(Index: Integer): boolean;
BEGIN
  Result := FFirstName_Specified;
END;

PROCEDURE MarketPlaceAddress.SetLastName(Index: Integer; CONST AWideString: WideString);
BEGIN
  FLastName := AWideString;
  FLastName_Specified := True;
END;

FUNCTION MarketPlaceAddress.LastName_Specified(Index: Integer): boolean;
BEGIN
  Result := FLastName_Specified;
END;

PROCEDURE MarketPlaceAddress.SetAddress1(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAddress1 := AWideString;
  FAddress1_Specified := True;
END;

FUNCTION MarketPlaceAddress.Address1_Specified(Index: Integer): boolean;
BEGIN
  Result := FAddress1_Specified;
END;

PROCEDURE MarketPlaceAddress.SetAddress2(Index: Integer; CONST AWideString: WideString);
BEGIN
  FAddress2 := AWideString;
  FAddress2_Specified := True;
END;

FUNCTION MarketPlaceAddress.Address2_Specified(Index: Integer): boolean;
BEGIN
  Result := FAddress2_Specified;
END;

PROCEDURE MarketPlaceAddress.SetCityName(Index: Integer; CONST AWideString: WideString);
BEGIN
  FCityName := AWideString;
  FCityName_Specified := True;
END;

FUNCTION MarketPlaceAddress.CityName_Specified(Index: Integer): boolean;
BEGIN
  Result := FCityName_Specified;
END;

PROCEDURE MarketPlaceAddress.SetPostalCode(Index: Integer; CONST AWideString: WideString);
BEGIN
  FPostalCode := AWideString;
  FPostalCode_Specified := True;
END;

FUNCTION MarketPlaceAddress.PostalCode_Specified(Index: Integer): boolean;
BEGIN
  Result := FPostalCode_Specified;
END;

PROCEDURE MarketPlaceAddress.SetCountry(Index: Integer; CONST AWideString: WideString);
BEGIN
  FCountry := AWideString;
  FCountry_Specified := True;
END;

FUNCTION MarketPlaceAddress.Country_Specified(Index: Integer): boolean;
BEGIN
  Result := FCountry_Specified;
END;

PROCEDURE MarketPlaceAddress.SetPhone(Index: Integer; CONST AWideString: WideString);
BEGIN
  FPhone := AWideString;
  FPhone_Specified := True;
END;

FUNCTION MarketPlaceAddress.Phone_Specified(Index: Integer): boolean;
BEGIN
  Result := FPhone_Specified;
END;

PROCEDURE MarketPlaceAddress.SetMobile(Index: Integer; CONST AWideString: WideString);
BEGIN
  FMobile := AWideString;
  FMobile_Specified := True;
END;

FUNCTION MarketPlaceAddress.Mobile_Specified(Index: Integer): boolean;
BEGIN
  Result := FMobile_Specified;
END;

PROCEDURE MarketPlaceAddress.SetFax(Index: Integer; CONST AWideString: WideString);
BEGIN
  FFax := AWideString;
  FFax_Specified := True;
END;

FUNCTION MarketPlaceAddress.Fax_Specified(Index: Integer): boolean;
BEGIN
  Result := FFax_Specified;
END;

PROCEDURE MarketPlaceAddress.SetEmail(Index: Integer; CONST AWideString: WideString);
BEGIN
  FEmail := AWideString;
  FEmail_Specified := True;
END;

FUNCTION MarketPlaceAddress.Email_Specified(Index: Integer): boolean;
BEGIN
  Result := FEmail_Specified;
END;

PROCEDURE MarketPlaceOrderStatusResponse.SetOrderId(Index: Integer; CONST AWideString: WideString);
BEGIN
  FOrderId := AWideString;
  FOrderId_Specified := True;
END;

FUNCTION MarketPlaceOrderStatusResponse.OrderId_Specified(Index: Integer): boolean;
BEGIN
  Result := FOrderId_Specified;
END;

CONSTRUCTOR EchoRequestType.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

PROCEDURE EchoRequestType.SetEchoInput(Index: Integer; CONST AWideString: WideString);
BEGIN
  FEchoInput := AWideString;
  FEchoInput_Specified := True;
END;

FUNCTION EchoRequestType.EchoInput_Specified(Index: Integer): boolean;
BEGIN
  Result := FEchoInput_Specified;
END;

CONSTRUCTOR EchoResponseType.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

PROCEDURE EchoResponseType.SetEchoOutput(Index: Integer; CONST AWideString: WideString);
BEGIN
  FEchoOutput := AWideString;
  FEchoOutput_Specified := True;
END;

FUNCTION EchoResponseType.EchoOutput_Specified(Index: Integer): boolean;
BEGIN
  Result := FEchoOutput_Specified;
END;

CONSTRUCTOR GetItemsRequestType.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

PROCEDURE GetItemsRequestType.SetGetItemsInput(Index: Integer; CONST AWideString: WideString);
BEGIN
  FGetItemsInput := AWideString;
  FGetItemsInput_Specified := True;
END;

FUNCTION GetItemsRequestType.GetItemsInput_Specified(Index: Integer): boolean;
BEGIN
  Result := FGetItemsInput_Specified;
END;

PROCEDURE GetItemsRequestType.SetPageNumber(Index: Integer; CONST AInt64: Int64);
BEGIN
  FPageNumber := AInt64;
  FPageNumber_Specified := True;
END;

FUNCTION GetItemsRequestType.PageNumber_Specified(Index: Integer): boolean;
BEGIN
  Result := FPageNumber_Specified;
END;

CONSTRUCTOR TestConnectionRequest.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

CONSTRUCTOR TestConnectionResponse.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

CONSTRUCTOR InventoryItemsType.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

DESTRUCTOR InventoryItemsType.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(Fitems) - 1 DO
    FreeAndNil(Fitems[I]);
  SetLength(Fitems, 0);
  INHERITED Destroy;
END;

PROCEDURE InventoryItemsType.Setitems(Index: Integer; CONST AArrayOfInventoryItem: ArrayOfInventoryItem);
BEGIN
  Fitems := AArrayOfInventoryItem;
  Fitems_Specified := True;
END;

FUNCTION InventoryItemsType.items_Specified(Index: Integer): boolean;
BEGIN
  Result := Fitems_Specified;
END;

CONSTRUCTOR PostItems.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

DESTRUCTOR PostItems.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(Fitems) - 1 DO
    FreeAndNil(Fitems[I]);
  SetLength(Fitems, 0);
  INHERITED Destroy;
END;

PROCEDURE PostItems.Setitems(Index: Integer; CONST AArrayOfInventoryItem: ArrayOfInventoryItem);
BEGIN
  Fitems := AArrayOfInventoryItem;
  Fitems_Specified := True;
END;

FUNCTION PostItems.items_Specified(Index: Integer): boolean;
BEGIN
  Result := Fitems_Specified;
END;

CONSTRUCTOR PostItemsResponse.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

DESTRUCTOR PostItemsResponse.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(FPostItemsResult) - 1 DO
    FreeAndNil(FPostItemsResult[I]);
  SetLength(FPostItemsResult, 0);
  INHERITED Destroy;
END;

PROCEDURE PostItemsResponse.SetPostItemsResult(Index: Integer; CONST AArrayOfInventoryItemStatusResponse: ArrayOfInventoryItemStatusResponse);
BEGIN
  FPostItemsResult := AArrayOfInventoryItemStatusResponse;
  FPostItemsResult_Specified := True;
END;

FUNCTION PostItemsResponse.PostItemsResult_Specified(Index: Integer): boolean;
BEGIN
  Result := FPostItemsResult_Specified;
END;

CONSTRUCTOR GetOrders.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];

  FDateSaleFrom := TXSDateTime.Create;
  FDateSaleTo := TXSDateTime.Create;
  FDatePaymentFrom := TXSDateTime.Create;
  FDatePaymentTo := TXSDateTime.Create;
END;

DESTRUCTOR GetOrders.Destroy;
BEGIN
  FreeAndNil(FDateSaleFrom);
  FreeAndNil(FDateSaleTo);
  FreeAndNil(FDatePaymentFrom);
  FreeAndNil(FDatePaymentTo);
  INHERITED Destroy;
END;

CONSTRUCTOR GetOrdersResponse.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

DESTRUCTOR GetOrdersResponse.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(FGetOrdersResult) - 1 DO
    FreeAndNil(FGetOrdersResult[I]);
  SetLength(FGetOrdersResult, 0);
  INHERITED Destroy;
END;

PROCEDURE GetOrdersResponse.SetGetOrdersResult(Index: Integer; CONST AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
BEGIN
  FGetOrdersResult := AArrayOfMarketPlaceOrder;
  FGetOrdersResult_Specified := True;
END;

FUNCTION GetOrdersResponse.GetOrdersResult_Specified(Index: Integer): boolean;
BEGIN
  Result := FGetOrdersResult_Specified;
END;

CONSTRUCTOR PostOrders.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

DESTRUCTOR PostOrders.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(Forders) - 1 DO
    FreeAndNil(Forders[I]);
  SetLength(Forders, 0);
  INHERITED Destroy;
END;

PROCEDURE PostOrders.Setorders(Index: Integer; CONST AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
BEGIN
  Forders := AArrayOfMarketPlaceOrder;
  Forders_Specified := True;
END;

FUNCTION PostOrders.orders_Specified(Index: Integer): boolean;
BEGIN
  Result := Forders_Specified;
END;

CONSTRUCTOR PostOrdersResponse.Create;
BEGIN
  INHERITED Create;
  FSerializationOptions := [xoLiteralParam];
END;

DESTRUCTOR PostOrdersResponse.Destroy;
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO Length(FPostOrdersResult) - 1 DO
    FreeAndNil(FPostOrdersResult[I]);
  SetLength(FPostOrdersResult, 0);
  INHERITED Destroy;
END;

PROCEDURE PostOrdersResponse.SetPostOrdersResult(Index: Integer; CONST AArrayOfMarketPlaceOrderStatusResponse: ArrayOfMarketPlaceOrderStatusResponse);
BEGIN
  FPostOrdersResult := AArrayOfMarketPlaceOrderStatusResponse;
  FPostOrdersResult_Specified := True;
END;

FUNCTION PostOrdersResponse.PostOrdersResult_Specified(Index: Integer): boolean;
BEGIN
  Result := FPostOrdersResult_Specified;
END;

INITIALIZATION
  InvRegistry.RegisterInterface(TypeInfo(NWSServerPortType), 'urn:NWS:examples', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(NWSServerPortType), '%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(NWSServerPortType), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(NWSServerPortType), ioLiteral);
  InvRegistry.RegisterExternalParamName(TypeInfo(NWSServerPortType), 'Echo', 'parameters1', 'parameters');
  InvRegistry.RegisterHeaderClass(TypeInfo(NWSServerPortType), AuthenticationHeader2, 'AuthenticationHeader', 'urn:NWS:examples');
  InvRegistry.RegisterExternalParamName(TypeInfo(NWSServerPortType), 'GetItems', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(NWSServerPortType), 'TestConnection', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(NWSServerPortType), 'PostItems', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(NWSServerPortType), 'GetOrders', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(NWSServerPortType), 'PostOrders', 'parameters1', 'parameters');
  RemClassRegistry.RegisterXSClass(AuthenticationHeader, 'urn:NWS:examples', 'AuthenticationHeader');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfSpecificFields), 'urn:NWS:examples', 'ArrayOfSpecificFields');
  RemClassRegistry.RegisterXSClass(SpecificField, 'urn:NWS:examples', 'SpecificField');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(SpecificField), 'Name_', 'Name');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfInventoryItem), 'urn:NWS:examples', 'ArrayOfInventoryItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(EtatEnum), 'urn:NWS:examples', 'EtatEnum');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_1', '1');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_2', '2');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_3', '3');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_4', '4');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_5', '5');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_6', '6');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_7', '7');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_8', '8');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_10', '10');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_11', '11');
  RemClassRegistry.RegisterXSClass(InventoryItem, 'urn:NWS:examples', 'InventoryItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfInventoryItemStatusResponse), 'urn:NWS:examples', 'ArrayOfInventoryItemStatusResponse');
  RemClassRegistry.RegisterXSInfo(TypeInfo(StatusEnum), 'urn:NWS:examples', 'StatusEnum');
  RemClassRegistry.RegisterXSClass(InventoryItemStatusResponse, 'urn:NWS:examples', 'InventoryItemStatusResponse');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfMarketPlaceOrder), 'urn:NWS:examples', 'ArrayOfMarketPlaceOrder');
  RemClassRegistry.RegisterXSInfo(TypeInfo(OrderStatusEnum), 'urn:NWS:examples', 'OrderStatusEnum');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(OrderStatusEnum), 'Canceled2', 'Canceled');
  RemClassRegistry.RegisterXSInfo(TypeInfo(PaymentMethodEnum), 'urn:NWS:examples', 'PaymentMethodEnum');
  RemClassRegistry.RegisterXSClass(MarketPlaceOrder, 'urn:NWS:examples', 'MarketPlaceOrder');
  RemClassRegistry.RegisterXSClass(MarketPlaceAddress, 'urn:NWS:examples', 'MarketPlaceAddress');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfMarketPlaceOrderStatusResponse), 'urn:NWS:examples', 'ArrayOfMarketPlaceOrderStatusResponse');
  RemClassRegistry.RegisterXSClass(MarketPlaceOrderStatusResponse, 'urn:NWS:examples', 'MarketPlaceOrderStatusResponse');
  RemClassRegistry.RegisterXSClass(EchoRequestType, 'urn:NWS:examples', 'EchoRequestType');
  RemClassRegistry.RegisterSerializeOptions(EchoRequestType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(EchoResponseType, 'urn:NWS:examples', 'EchoResponseType');
  RemClassRegistry.RegisterSerializeOptions(EchoResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(GetItemsRequestType, 'urn:NWS:examples', 'GetItemsRequestType');
  RemClassRegistry.RegisterSerializeOptions(GetItemsRequestType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(TestConnectionRequest, 'urn:NWS:examples', 'TestConnectionRequest');
  RemClassRegistry.RegisterSerializeOptions(TestConnectionRequest, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(TestConnectionResponse, 'urn:NWS:examples', 'TestConnectionResponse');
  RemClassRegistry.RegisterSerializeOptions(TestConnectionResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(AuthenticationHeader2, 'urn:NWS:examples', 'AuthenticationHeader2', 'AuthenticationHeader');
  RemClassRegistry.RegisterXSClass(InventoryItemsType, 'urn:NWS:examples', 'InventoryItemsType');
  RemClassRegistry.RegisterSerializeOptions(InventoryItemsType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PostItems, 'urn:NWS:examples', 'PostItems');
  RemClassRegistry.RegisterSerializeOptions(PostItems, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PostItemsResponse, 'urn:NWS:examples', 'PostItemsResponse');
  RemClassRegistry.RegisterSerializeOptions(PostItemsResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(GetOrders, 'urn:NWS:examples', 'GetOrders');
  RemClassRegistry.RegisterSerializeOptions(GetOrders, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(GetOrdersResponse, 'urn:NWS:examples', 'GetOrdersResponse');
  RemClassRegistry.RegisterSerializeOptions(GetOrdersResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PostOrders, 'urn:NWS:examples', 'PostOrders');
  RemClassRegistry.RegisterSerializeOptions(PostOrders, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PostOrdersResponse, 'urn:NWS:examples', 'PostOrdersResponse');
  RemClassRegistry.RegisterSerializeOptions(PostOrdersResponse, [xoLiteralParam]);

END.


// ************************************************************************ //

// Les types déclarés dans ce fichier ont été générés à partir de données lues dans le

// fichier WSDL décrit ci-dessous :

// WSDL     : http://ws2.neteven.com/NWS

//  >Import : http://ws2.neteven.com/NWS:0
// Encodage : UTF-8// Version  : 1.0
// (12/10/2010 10:56:33 - - $Rev: 10138 $)
// ************************************************************************ //

unit NetEvenWS;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

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

  AuthenticationHeader = class;                 { "urn:NWS:examples"[Hdr][GblCplx] }
  SpecificField        = class;                 { "urn:NWS:examples"[GblCplx] }
  InventoryItemStatusResponse = class;          { "urn:NWS:examples"[GblCplx] }
  MarketPlaceOrder     = class;                 { "urn:NWS:examples"[GblCplx] }
  MarketPlaceAddress   = class;                 { "urn:NWS:examples"[GblCplx] }
  MarketPlaceOrderStatusResponse = class;       { "urn:NWS:examples"[GblCplx] }
  EchoRequestType      = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  EchoResponseType     = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  GetItemsRequestType  = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  TestConnectionRequest = class;                { "urn:NWS:examples"[Lit][GblElm] }
  TestConnectionResponse = class;               { "urn:NWS:examples"[Lit][GblElm] }
  AuthenticationHeader2 = class;                { "urn:NWS:examples"[Hdr][GblElm] }
  InventoryItemsType   = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  PostItems            = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  PostItemsResponse    = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  GetOrders            = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  GetOrdersResponse    = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  PostOrders           = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  PostOrdersResponse   = class;                 { "urn:NWS:examples"[Lit][GblElm] }
  InventoryItem        = class;                 { "urn:NWS:examples"[GblCplx] }

  { "urn:NWS:examples"[GblSmpl] }
  EtatEnum = (_1, _2, _3, _4, _5, _6, _7, _8, _10, _11, _12, _13, _15);

  { "urn:NWS:examples"[GblSmpl] }
  StatusEnum = (Accepted, Canceled, NonConformantAuthorization, NonConformantFormat, Rejected, UnexpectedInformation, Inserted, Updated, Error);

  { "urn:NWS:examples"[GblSmpl] }
  OrderStatusEnum = (toConfirm, Confirmed, Canceled2, Refunded, Shipped);

  { "urn:NWS:examples"[GblSmpl] }
  PaymentMethodEnum = (CreditCard, Check, PayPal, Other, Unknown);



  // ************************************************************************ //
  // XML       : AuthenticationHeader, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // Info      : Header
  // ************************************************************************ //
  AuthenticationHeader = class(TSOAPHeader)
  private
    FMethod: WideString;
    FLogin: WideString;
    FSeed: WideString;
    FStamp: WideString;
    FSignature: WideString;
  published
    property Method:    WideString  read FMethod write FMethod;
    property Login:     WideString  read FLogin write FLogin;
    property Seed:      WideString  read FSeed write FSeed;
    property Stamp:     WideString  read FStamp write FStamp;
    property Signature: WideString  read FSignature write FSignature;
  end;

  ArrayOfSpecificFields = array of SpecificField;   { "urn:NWS:examples"[GblCplx] }


  // ************************************************************************ //
  // XML       : SpecificField, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  SpecificField = class(TRemotable)
  private
    FName_: WideString;
    FValue: WideString;
  published
    property Name_: WideString  read FName_ write FName_;
    property Value: WideString  read FValue write FValue;
  end;

  ArrayOfInventoryItem = array of InventoryItem;   { "urn:NWS:examples"[GblCplx] }
  ArrayOfInventoryItemStatusResponse = array of InventoryItemStatusResponse;   { "urn:NWS:examples"[GblCplx] }


  // ************************************************************************ //
  // XML       : InventoryItemStatusResponse, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  InventoryItemStatusResponse = class(TRemotable)
  private
    FItemCode: WideString;
    FItemCode_Specified: boolean;
    FStatusResponse: StatusEnum;
    procedure SetItemCode(Index: Integer; const AWideString: WideString);
    function  ItemCode_Specified(Index: Integer): boolean;
  published
    property ItemCode:       WideString  Index (IS_OPTN) read FItemCode write SetItemCode stored ItemCode_Specified;
    property StatusResponse: StatusEnum  read FStatusResponse write FStatusResponse;
  end;

  ArrayOfMarketPlaceOrder = array of MarketPlaceOrder;   { "urn:NWS:examples"[GblCplx] }


  // ************************************************************************ //
  // XML       : MarketPlaceOrder, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  MarketPlaceOrder = class(TRemotable)
  private
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
    FMarketPlaceInvoiceId: WideString;
    FMarketPlaceInvoiceId_Specified: boolean;
    FSKU: WideString;
    FSKU_Specified: boolean;
    FDateSale: TXSDateTime;
    FDateSale_Specified: boolean;
    FDatePayment: TXSDateTime;
    FDatePayment_Specified: boolean;
    FDateShipping: TXSDateTime;
    FDateShipping_Specified: boolean;
    FDateAvailability: TXSDateTime;
    FDateAvailability_Specified: boolean;
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
    procedure SetID(Index: Integer; const AWideString: WideString);
    function  ID_Specified(Index: Integer): boolean;
    procedure SetOrderID(Index: Integer; const AWideString: WideString);
    function  OrderID_Specified(Index: Integer): boolean;
    procedure SetOrderLineID(Index: Integer; const AWideString: WideString);
    function  OrderLineID_Specified(Index: Integer): boolean;
    procedure SetStatus(Index: Integer; const AOrderStatusEnum: OrderStatusEnum);
    function  Status_Specified(Index: Integer): boolean;
    procedure SetCustomerId(Index: Integer; const AWideString: WideString);
    function  CustomerId_Specified(Index: Integer): boolean;
    procedure SetMarketPlaceId(Index: Integer; const AWideString: WideString);
    function  MarketPlaceId_Specified(Index: Integer): boolean;
    procedure SetMarketPlaceName(Index: Integer; const AWideString: WideString);
    function  MarketPlaceName_Specified(Index: Integer): boolean;
    procedure SetMarketPlaceListingId(Index: Integer; const AWideString: WideString);
    function  MarketPlaceListingId_Specified(Index: Integer): boolean;
    procedure SetMarketPlaceSaleId(Index: Integer; const AWideString: WideString);
    function  MarketPlaceSaleId_Specified(Index: Integer): boolean;
    procedure SetMarketPlaceInvoiceId(Index: Integer; const AWideString: WideString);
    function  MarketPlaceInvoiceId_Specified(Index: Integer): boolean;
    procedure SetSKU(Index: Integer; const AWideString: WideString);
    function  SKU_Specified(Index: Integer): boolean;
    procedure SetDateSale(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateSale_Specified(Index: Integer): boolean;
    procedure SetDatePayment(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DatePayment_Specified(Index: Integer): boolean;
    procedure SetDateShipping(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateShipping_Specified(Index: Integer): boolean;
    procedure SetDateAvailability(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateAvailability_Specified(Index: Integer): boolean;
    procedure SetTrackingNumber(Index: Integer; const AWideString: WideString);
    function  TrackingNumber_Specified(Index: Integer): boolean;
    procedure SetAmountPaid(Index: Integer; const ADouble: Double);
    function  AmountPaid_Specified(Index: Integer): boolean;
    procedure SetPaymentMethod(Index: Integer; const APaymentMethodEnum: PaymentMethodEnum);
    function  PaymentMethod_Specified(Index: Integer): boolean;
    procedure SetQuantity(Index: Integer; const ADouble: Double);
    function  Quantity_Specified(Index: Integer): boolean;
    procedure SetPrice(Index: Integer; const ADouble: Double);
    function  Price_Specified(Index: Integer): boolean;
    procedure SetInsuranceId(Index: Integer; const AWideString: WideString);
    function  InsuranceId_Specified(Index: Integer): boolean;
    procedure SetInsuranceCost(Index: Integer; const ADouble: Double);
    function  InsuranceCost_Specified(Index: Integer): boolean;
    procedure SetShippingCost(Index: Integer; const ADouble: Double);
    function  ShippingCost_Specified(Index: Integer): boolean;
    procedure SetFinalShippingCost(Index: Integer; const ADouble: Double);
    function  FinalShippingCost_Specified(Index: Integer): boolean;
    procedure SetShipperId(Index: Integer; const AWideString: WideString);
    function  ShipperId_Specified(Index: Integer): boolean;
    procedure SetVAT(Index: Integer; const ADouble: Double);
    function  VAT_Specified(Index: Integer): boolean;
    procedure SetTotalCostWithVAT(Index: Integer; const ADouble: Double);
    function  TotalCostWithVAT_Specified(Index: Integer): boolean;
    procedure SetMarketplaceFee(Index: Integer; const ADouble: Double);
    function  MarketplaceFee_Specified(Index: Integer): boolean;
    procedure SetBillingAddress(Index: Integer; const AMarketPlaceAddress: MarketPlaceAddress);
    function  BillingAddress_Specified(Index: Integer): boolean;
    procedure SetShippingAddress(Index: Integer; const AMarketPlaceAddress: MarketPlaceAddress);
    function  ShippingAddress_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ID:                   WideString          Index (IS_OPTN) read FID write SetID stored ID_Specified;
    property OrderID:              WideString          Index (IS_OPTN) read FOrderID write SetOrderID stored OrderID_Specified;
    property OrderLineID:          WideString          Index (IS_OPTN) read FOrderLineID write SetOrderLineID stored OrderLineID_Specified;
    property Status:               OrderStatusEnum     Index (IS_OPTN) read FStatus write SetStatus stored Status_Specified;
    property CustomerId:           WideString          Index (IS_OPTN) read FCustomerId write SetCustomerId stored CustomerId_Specified;
    property MarketPlaceId:        WideString          Index (IS_OPTN) read FMarketPlaceId write SetMarketPlaceId stored MarketPlaceId_Specified;
    property MarketPlaceName:      WideString          Index (IS_OPTN) read FMarketPlaceName write SetMarketPlaceName stored MarketPlaceName_Specified;
    property MarketPlaceListingId: WideString          Index (IS_OPTN) read FMarketPlaceListingId write SetMarketPlaceListingId stored MarketPlaceListingId_Specified;
    property MarketPlaceSaleId:    WideString          Index (IS_OPTN) read FMarketPlaceSaleId write SetMarketPlaceSaleId stored MarketPlaceSaleId_Specified;
    property MarketPlaceInvoiceId: WideString          Index (IS_OPTN) read FMarketPlaceInvoiceId write SetMarketPlaceInvoiceId stored MarketPlaceInvoiceId_Specified;
    property SKU:                  WideString          Index (IS_OPTN) read FSKU write SetSKU stored SKU_Specified;
    property DateSale:             TXSDateTime         Index (IS_OPTN) read FDateSale write SetDateSale stored DateSale_Specified;
    property DatePayment:          TXSDateTime         Index (IS_OPTN) read FDatePayment write SetDatePayment stored DatePayment_Specified;
    property DateShipping:         TXSDateTime         Index (IS_OPTN) read FDateShipping write SetDateShipping stored DateShipping_Specified;
    property DateAvailability:     TXSDateTime         Index (IS_OPTN) read FDateAvailability write SetDateAvailability stored DateAvailability_Specified;
    property TrackingNumber:       WideString          Index (IS_OPTN) read FTrackingNumber write SetTrackingNumber stored TrackingNumber_Specified;
    property AmountPaid:           Double              Index (IS_OPTN) read FAmountPaid write SetAmountPaid stored AmountPaid_Specified;
    property PaymentMethod:        PaymentMethodEnum   Index (IS_OPTN) read FPaymentMethod write SetPaymentMethod stored PaymentMethod_Specified;
    property Quantity:             Double              Index (IS_OPTN) read FQuantity write SetQuantity stored Quantity_Specified;
    property Price:                Double              Index (IS_OPTN) read FPrice write SetPrice stored Price_Specified;
    property InsuranceId:          WideString          Index (IS_OPTN) read FInsuranceId write SetInsuranceId stored InsuranceId_Specified;
    property InsuranceCost:        Double              Index (IS_OPTN) read FInsuranceCost write SetInsuranceCost stored InsuranceCost_Specified;
    property ShippingCost:         Double              Index (IS_OPTN) read FShippingCost write SetShippingCost stored ShippingCost_Specified;
    property FinalShippingCost:    Double              Index (IS_OPTN) read FFinalShippingCost write SetFinalShippingCost stored FinalShippingCost_Specified;
    property ShipperId:            WideString          Index (IS_OPTN) read FShipperId write SetShipperId stored ShipperId_Specified;
    property VAT:                  Double              Index (IS_OPTN) read FVAT write SetVAT stored VAT_Specified;
    property TotalCostWithVAT:     Double              Index (IS_OPTN) read FTotalCostWithVAT write SetTotalCostWithVAT stored TotalCostWithVAT_Specified;
    property MarketplaceFee:       Double              Index (IS_OPTN) read FMarketplaceFee write SetMarketplaceFee stored MarketplaceFee_Specified;
    property BillingAddress:       MarketPlaceAddress  Index (IS_OPTN) read FBillingAddress write SetBillingAddress stored BillingAddress_Specified;
    property ShippingAddress:      MarketPlaceAddress  Index (IS_OPTN) read FShippingAddress write SetShippingAddress stored ShippingAddress_Specified;
  end;



  // ************************************************************************ //
  // XML       : MarketPlaceAddress, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  MarketPlaceAddress = class(TRemotable)
  private
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
    FCompany: WideString;
    FCompany_Specified: boolean;
    procedure SetFirstName(Index: Integer; const AWideString: WideString);
    function  FirstName_Specified(Index: Integer): boolean;
    procedure SetLastName(Index: Integer; const AWideString: WideString);
    function  LastName_Specified(Index: Integer): boolean;
    procedure SetAddress1(Index: Integer; const AWideString: WideString);
    function  Address1_Specified(Index: Integer): boolean;
    procedure SetAddress2(Index: Integer; const AWideString: WideString);
    function  Address2_Specified(Index: Integer): boolean;
    procedure SetCityName(Index: Integer; const AWideString: WideString);
    function  CityName_Specified(Index: Integer): boolean;
    procedure SetPostalCode(Index: Integer; const AWideString: WideString);
    function  PostalCode_Specified(Index: Integer): boolean;
    procedure SetCountry(Index: Integer; const AWideString: WideString);
    function  Country_Specified(Index: Integer): boolean;
    procedure SetPhone(Index: Integer; const AWideString: WideString);
    function  Phone_Specified(Index: Integer): boolean;
    procedure SetMobile(Index: Integer; const AWideString: WideString);
    function  Mobile_Specified(Index: Integer): boolean;
    procedure SetFax(Index: Integer; const AWideString: WideString);
    function  Fax_Specified(Index: Integer): boolean;
    procedure SetEmail(Index: Integer; const AWideString: WideString);
    function  Email_Specified(Index: Integer): boolean;
    procedure SetCompany(Index: Integer; const AWideString: WideString);
    function  Company_Specified(Index: Integer): boolean;
  published
    property FirstName:  WideString  Index (IS_OPTN) read FFirstName write SetFirstName stored FirstName_Specified;
    property LastName:   WideString  Index (IS_OPTN) read FLastName write SetLastName stored LastName_Specified;
    property Address1:   WideString  Index (IS_OPTN) read FAddress1 write SetAddress1 stored Address1_Specified;
    property Address2:   WideString  Index (IS_OPTN) read FAddress2 write SetAddress2 stored Address2_Specified;
    property CityName:   WideString  Index (IS_OPTN) read FCityName write SetCityName stored CityName_Specified;
    property PostalCode: WideString  Index (IS_OPTN) read FPostalCode write SetPostalCode stored PostalCode_Specified;
    property Country:    WideString  Index (IS_OPTN) read FCountry write SetCountry stored Country_Specified;
    property Phone:      WideString  Index (IS_OPTN) read FPhone write SetPhone stored Phone_Specified;
    property Mobile:     WideString  Index (IS_OPTN) read FMobile write SetMobile stored Mobile_Specified;
    property Fax:        WideString  Index (IS_OPTN) read FFax write SetFax stored Fax_Specified;
    property Email:      WideString  Index (IS_OPTN) read FEmail write SetEmail stored Email_Specified;
    property Company:    WideString  Index (IS_OPTN) read FCompany write SetCompany stored Company_Specified;
  end;

  ArrayOfMarketPlaceOrderStatusResponse = array of MarketPlaceOrderStatusResponse;   { "urn:NWS:examples"[GblCplx] }


  // ************************************************************************ //
  // XML       : MarketPlaceOrderStatusResponse, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  MarketPlaceOrderStatusResponse = class(TRemotable)
  private
    FOrderLineID: WideString;
    FOrderLineID_Specified: boolean;
    FOrderID: WideString;
    FOrderID_Specified: boolean;
    FStatusResponse: StatusEnum;
    FOrderId_: WideString;
    FOrderId__Specified: boolean;
    procedure SetOrderLineID(Index: Integer; const AWideString: WideString);
    function  OrderLineID_Specified(Index: Integer): boolean;
    procedure SetOrderID(Index: Integer; const AWideString: WideString);
    function  OrderID_Specified(Index: Integer): boolean;
    procedure SetOrderId_(Index: Integer; const AWideString: WideString);
    function  OrderId__Specified(Index: Integer): boolean;
  published
    property OrderLineID:    WideString  Index (IS_OPTN) read FOrderLineID write SetOrderLineID stored OrderLineID_Specified;
    property OrderID:        WideString  Index (IS_OPTN) read FOrderID write SetOrderID stored OrderID_Specified;
    property StatusResponse: StatusEnum  read FStatusResponse write FStatusResponse;
    property OrderId_:       WideString  Index (IS_OPTN) read FOrderId_ write SetOrderId_ stored OrderId__Specified;
  end;



  // ************************************************************************ //
  // XML       : EchoRequestType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  EchoRequestType = class(TRemotable)
  private
    FEchoInput: WideString;
    FEchoInput_Specified: boolean;
    procedure SetEchoInput(Index: Integer; const AWideString: WideString);
    function  EchoInput_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
  published
    property EchoInput: WideString  Index (IS_OPTN) read FEchoInput write SetEchoInput stored EchoInput_Specified;
  end;



  // ************************************************************************ //
  // XML       : EchoResponseType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  EchoResponseType = class(TRemotable)
  private
    FEchoOutput: WideString;
    FEchoOutput_Specified: boolean;
    procedure SetEchoOutput(Index: Integer; const AWideString: WideString);
    function  EchoOutput_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
  published
    property EchoOutput: WideString  Index (IS_OPTN) read FEchoOutput write SetEchoOutput stored EchoOutput_Specified;
  end;



  // ************************************************************************ //
  // XML       : GetItemsRequestType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetItemsRequestType = class(TRemotable)
  private
    FGetItemsInput: WideString;
    FGetItemsInput_Specified: boolean;
    FPageNumber: Int64;
    FPageNumber_Specified: boolean;
    FDateModificationFrom: TXSDateTime;
    FDateModificationFrom_Specified: boolean;
    FSKU: WideString;
    FSKU_Specified: boolean;
    procedure SetGetItemsInput(Index: Integer; const AWideString: WideString);
    function  GetItemsInput_Specified(Index: Integer): boolean;
    procedure SetPageNumber(Index: Integer; const AInt64: Int64);
    function  PageNumber_Specified(Index: Integer): boolean;
    procedure SetDateModificationFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateModificationFrom_Specified(Index: Integer): boolean;
    procedure SetSKU(Index: Integer; const AWideString: WideString);
    function  SKU_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property GetItemsInput:        WideString   Index (IS_OPTN) read FGetItemsInput write SetGetItemsInput stored GetItemsInput_Specified;
    property PageNumber:           Int64        Index (IS_OPTN) read FPageNumber write SetPageNumber stored PageNumber_Specified;
    property DateModificationFrom: TXSDateTime  Index (IS_OPTN) read FDateModificationFrom write SetDateModificationFrom stored DateModificationFrom_Specified;
    property SKU:                  WideString   Index (IS_OPTN) read FSKU write SetSKU stored SKU_Specified;
  end;



  // ************************************************************************ //
  // XML       : TestConnectionRequest, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TestConnectionRequest = class(TRemotable)
  private
  public
    constructor Create; override;
  published
  end;



  // ************************************************************************ //
  // XML       : TestConnectionResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TestConnectionResponse = class(TRemotable)
  private
    FTestConnectionResult: StatusEnum;
  public
    constructor Create; override;
  published
    property TestConnectionResult: StatusEnum  read FTestConnectionResult write FTestConnectionResult;
  end;



  // ************************************************************************ //
  // XML       : AuthenticationHeader, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Info      : Header
  // ************************************************************************ //
  AuthenticationHeader2 = class(AuthenticationHeader)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : InventoryItemsType, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  InventoryItemsType = class(TRemotable)
  private
    Fnb_pages: Int64;
    Fnb_items: Int64;
    Fcur_page: Int64;
    Fitems: ArrayOfInventoryItem;
    Fitems_Specified: boolean;
    procedure Setitems(Index: Integer; const AArrayOfInventoryItem: ArrayOfInventoryItem);
    function  items_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property nb_pages: Int64                 read Fnb_pages write Fnb_pages;
    property nb_items: Int64                 read Fnb_items write Fnb_items;
    property cur_page: Int64                 read Fcur_page write Fcur_page;
    property items:    ArrayOfInventoryItem  Index (IS_OPTN) read Fitems write Setitems stored items_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostItems, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostItems = class(TRemotable)
  private
    Fitems: ArrayOfInventoryItem;
    Fitems_Specified: boolean;
    procedure Setitems(Index: Integer; const AArrayOfInventoryItem: ArrayOfInventoryItem);
    function  items_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property items: ArrayOfInventoryItem  Index (IS_OPTN) read Fitems write Setitems stored items_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostItemsResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostItemsResponse = class(TRemotable)
  private
    FPostItemsResult: ArrayOfInventoryItemStatusResponse;
    FPostItemsResult_Specified: boolean;
    procedure SetPostItemsResult(Index: Integer; const AArrayOfInventoryItemStatusResponse: ArrayOfInventoryItemStatusResponse);
    function  PostItemsResult_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property PostItemsResult: ArrayOfInventoryItemStatusResponse  Index (IS_OPTN) read FPostItemsResult write SetPostItemsResult stored PostItemsResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : GetOrders, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetOrders = class(TRemotable)
  private
    FPageNumber: WideString;
    FPageNumber_Specified: boolean;
    FDateSaleFrom: TXSDateTime;
    FDateSaleFrom_Specified: boolean;
    FDateSaleTo: TXSDateTime;
    FDateSaleTo_Specified: boolean;
    FDatePaymentFrom: TXSDateTime;
    FDatePaymentFrom_Specified: boolean;
    FDatePaymentTo: TXSDateTime;
    FDatePaymentTo_Specified: boolean;
    FDateCreationFrom: TXSDateTime;
    FDateCreationFrom_Specified: boolean;
    FDateCreationTo: TXSDateTime;
    FDateCreationTo_Specified: boolean;
    FDateModificationFrom: TXSDateTime;
    FDateModificationFrom_Specified: boolean;
    FDateModificationTo: TXSDateTime;
    FDateModificationTo_Specified: boolean;
    FDateAvailabilityFrom: TXSDateTime;
    FDateAvailabilityFrom_Specified: boolean;
    FDateAvailabilityTo: TXSDateTime;
    FDateAvailabilityTo_Specified: boolean;
    FMarketPlaceId: WideString;
    FMarketPlaceId_Specified: boolean;
    FOrderID: WideString;
    FOrderID_Specified: boolean;
    procedure SetPageNumber(Index: Integer; const AWideString: WideString);
    function  PageNumber_Specified(Index: Integer): boolean;
    procedure SetDateSaleFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateSaleFrom_Specified(Index: Integer): boolean;
    procedure SetDateSaleTo(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateSaleTo_Specified(Index: Integer): boolean;
    procedure SetDatePaymentFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DatePaymentFrom_Specified(Index: Integer): boolean;
    procedure SetDatePaymentTo(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DatePaymentTo_Specified(Index: Integer): boolean;
    procedure SetDateCreationFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateCreationFrom_Specified(Index: Integer): boolean;
    procedure SetDateCreationTo(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateCreationTo_Specified(Index: Integer): boolean;
    procedure SetDateModificationFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateModificationFrom_Specified(Index: Integer): boolean;
    procedure SetDateModificationTo(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateModificationTo_Specified(Index: Integer): boolean;
    procedure SetDateAvailabilityFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateAvailabilityFrom_Specified(Index: Integer): boolean;
    procedure SetDateAvailabilityTo(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateAvailabilityTo_Specified(Index: Integer): boolean;
    procedure SetMarketPlaceId(Index: Integer; const AWideString: WideString);
    function  MarketPlaceId_Specified(Index: Integer): boolean;
    procedure SetOrderID(Index: Integer; const AWideString: WideString);
    function  OrderID_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property PageNumber:           WideString   Index (IS_OPTN) read FPageNumber write SetPageNumber stored PageNumber_Specified;
    property DateSaleFrom:         TXSDateTime  Index (IS_OPTN) read FDateSaleFrom write SetDateSaleFrom stored DateSaleFrom_Specified;
    property DateSaleTo:           TXSDateTime  Index (IS_OPTN) read FDateSaleTo write SetDateSaleTo stored DateSaleTo_Specified;
    property DatePaymentFrom:      TXSDateTime  Index (IS_OPTN) read FDatePaymentFrom write SetDatePaymentFrom stored DatePaymentFrom_Specified;
    property DatePaymentTo:        TXSDateTime  Index (IS_OPTN) read FDatePaymentTo write SetDatePaymentTo stored DatePaymentTo_Specified;
    property DateCreationFrom:     TXSDateTime  Index (IS_OPTN) read FDateCreationFrom write SetDateCreationFrom stored DateCreationFrom_Specified;
    property DateCreationTo:       TXSDateTime  Index (IS_OPTN) read FDateCreationTo write SetDateCreationTo stored DateCreationTo_Specified;
    property DateModificationFrom: TXSDateTime  Index (IS_OPTN) read FDateModificationFrom write SetDateModificationFrom stored DateModificationFrom_Specified;
    property DateModificationTo:   TXSDateTime  Index (IS_OPTN) read FDateModificationTo write SetDateModificationTo stored DateModificationTo_Specified;
    property DateAvailabilityFrom: TXSDateTime  Index (IS_OPTN) read FDateAvailabilityFrom write SetDateAvailabilityFrom stored DateAvailabilityFrom_Specified;
    property DateAvailabilityTo:   TXSDateTime  Index (IS_OPTN) read FDateAvailabilityTo write SetDateAvailabilityTo stored DateAvailabilityTo_Specified;
    property MarketPlaceId:        WideString   Index (IS_OPTN) read FMarketPlaceId write SetMarketPlaceId stored MarketPlaceId_Specified;
    property OrderID:              WideString   Index (IS_OPTN) read FOrderID write SetOrderID stored OrderID_Specified;
  end;



  // ************************************************************************ //
  // XML       : GetOrdersResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetOrdersResponse = class(TRemotable)
  private
    FPageNumber: WideString;
    FPagesTotal: WideString;
    FGetOrdersResult: ArrayOfMarketPlaceOrder;
    FGetOrdersResult_Specified: boolean;
    procedure SetGetOrdersResult(Index: Integer; const AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
    function  GetOrdersResult_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property PageNumber:      WideString               read FPageNumber write FPageNumber;
    property PagesTotal:      WideString               read FPagesTotal write FPagesTotal;
    property GetOrdersResult: ArrayOfMarketPlaceOrder  Index (IS_OPTN) read FGetOrdersResult write SetGetOrdersResult stored GetOrdersResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostOrders, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostOrders = class(TRemotable)
  private
    Forders: ArrayOfMarketPlaceOrder;
    Forders_Specified: boolean;
    procedure Setorders(Index: Integer; const AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
    function  orders_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property orders: ArrayOfMarketPlaceOrder  Index (IS_OPTN) read Forders write Setorders stored orders_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostOrdersResponse, global, <element>
  // Espace de nommage : urn:NWS:examples
  // Serializtn : [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostOrdersResponse = class(TRemotable)
  private
    FPostOrdersResult: ArrayOfMarketPlaceOrderStatusResponse;
    FPostOrdersResult_Specified: boolean;
    procedure SetPostOrdersResult(Index: Integer; const AArrayOfMarketPlaceOrderStatusResponse: ArrayOfMarketPlaceOrderStatusResponse);
    function  PostOrdersResult_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property PostOrdersResult: ArrayOfMarketPlaceOrderStatusResponse  Index (IS_OPTN) read FPostOrdersResult write SetPostOrdersResult stored PostOrdersResult_Specified;
  end;

  Array_Of_string = array of WideString;        { "http://www.w3.org/2001/XMLSchema"[GblUbnd] }


  // ************************************************************************ //
  // XML       : InventoryItem, global, <complexType>
  // Espace de nommage : urn:NWS:examples
  // ************************************************************************ //
  InventoryItem = class(TRemotable)
  private
    FTitle: Array_Of_string;
    FTitle_Specified: boolean;
    FSubTitle: Array_Of_string;
    FSubTitle_Specified: boolean;
    FDescription: Array_Of_string;
    FDescription_Specified: boolean;
    FComment: Array_Of_string;
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
    FQuantity_Specified: boolean;
    FCost: Double;
    FCost_Specified: boolean;
    FTva: Double;
    FTva_Specified: boolean;
    FKeywords: WideString;
    FKeywords_Specified: boolean;
    FDateAvailability: TXSDateTime;
    FDateAvailability_Specified: boolean;
    FPriceFixed: Double;
    FPriceFixed_Specified: boolean;
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
    FPriceAdditional1: Double;
    FPriceAdditional1_Specified: boolean;
    FPriceAdditional2: Double;
    FPriceAdditional2_Specified: boolean;
    FPriceAdditional3: Double;
    FPriceAdditional3_Specified: boolean;
    FPriceAdditional4: Double;
    FPriceAdditional4_Specified: boolean;
    FPriceAdditional5: Double;
    FPriceAdditional5_Specified: boolean;
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
    FArrayOfSpecificFields: ArrayOfSpecificFields;
    FArrayOfSpecificFields_Specified: boolean;
    procedure SetTitle(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  Title_Specified(Index: Integer): boolean;
    procedure SetSubTitle(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  SubTitle_Specified(Index: Integer): boolean;
    procedure SetDescription(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  Description_Specified(Index: Integer): boolean;
    procedure SetComment(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  Comment_Specified(Index: Integer): boolean;
    procedure SetSKUFamily(Index: Integer; const AWideString: WideString);
    function  SKUFamily_Specified(Index: Integer): boolean;
    procedure SetBrand(Index: Integer; const AWideString: WideString);
    function  Brand_Specified(Index: Integer): boolean;
    procedure SetCodeProduit(Index: Integer; const AWideString: WideString);
    function  CodeProduit_Specified(Index: Integer): boolean;
    procedure SetTypeCodeProduit(Index: Integer; const AWideString: WideString);
    function  TypeCodeProduit_Specified(Index: Integer): boolean;
    procedure SetEAN(Index: Integer; const AWideString: WideString);
    function  EAN_Specified(Index: Integer): boolean;
    procedure SetUPC(Index: Integer; const AWideString: WideString);
    function  UPC_Specified(Index: Integer): boolean;
    procedure SetISBN(Index: Integer; const AWideString: WideString);
    function  ISBN_Specified(Index: Integer): boolean;
    procedure SetASIN(Index: Integer; const AWideString: WideString);
    function  ASIN_Specified(Index: Integer): boolean;
    procedure SetPartNumber(Index: Integer; const AWideString: WideString);
    function  PartNumber_Specified(Index: Integer): boolean;
    procedure SetQuantity(Index: Integer; const AInt64: Int64);
    function  Quantity_Specified(Index: Integer): boolean;
    procedure SetCost(Index: Integer; const ADouble: Double);
    function  Cost_Specified(Index: Integer): boolean;
    procedure SetTva(Index: Integer; const ADouble: Double);
    function  Tva_Specified(Index: Integer): boolean;
    procedure SetKeywords(Index: Integer; const AWideString: WideString);
    function  Keywords_Specified(Index: Integer): boolean;
    procedure SetDateAvailability(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateAvailability_Specified(Index: Integer): boolean;
    procedure SetPriceFixed(Index: Integer; const ADouble: Double);
    function  PriceFixed_Specified(Index: Integer): boolean;
    procedure SetPriceStarting(Index: Integer; const ADouble: Double);
    function  PriceStarting_Specified(Index: Integer): boolean;
    procedure SetPriceReserved(Index: Integer; const ADouble: Double);
    function  PriceReserved_Specified(Index: Integer): boolean;
    procedure SetPriceRetail(Index: Integer; const ADouble: Double);
    function  PriceRetail_Specified(Index: Integer): boolean;
    procedure SetPriceSecondChance(Index: Integer; const ADouble: Double);
    function  PriceSecondChance_Specified(Index: Integer): boolean;
    procedure SetPriceBestOffer(Index: Integer; const ADouble: Double);
    function  PriceBestOffer_Specified(Index: Integer): boolean;
    procedure SetPriceAdditional1(Index: Integer; const ADouble: Double);
    function  PriceAdditional1_Specified(Index: Integer): boolean;
    procedure SetPriceAdditional2(Index: Integer; const ADouble: Double);
    function  PriceAdditional2_Specified(Index: Integer): boolean;
    procedure SetPriceAdditional3(Index: Integer; const ADouble: Double);
    function  PriceAdditional3_Specified(Index: Integer): boolean;
    procedure SetPriceAdditional4(Index: Integer; const ADouble: Double);
    function  PriceAdditional4_Specified(Index: Integer): boolean;
    procedure SetPriceAdditional5(Index: Integer; const ADouble: Double);
    function  PriceAdditional5_Specified(Index: Integer): boolean;
    procedure SetEtat(Index: Integer; const AEtatEnum: EtatEnum);
    function  Etat_Specified(Index: Integer): boolean;
    procedure SetLotSize(Index: Integer; const AInt64: Int64);
    function  LotSize_Specified(Index: Integer): boolean;
    procedure SetSupplierName(Index: Integer; const AWideString: WideString);
    function  SupplierName_Specified(Index: Integer): boolean;
    procedure SetClassification(Index: Integer; const AWideString: WideString);
    function  Classification_Specified(Index: Integer): boolean;
    procedure SetWeight(Index: Integer; const ADouble: Double);
    function  Weight_Specified(Index: Integer): boolean;
    procedure SetHeight(Index: Integer; const ADouble: Double);
    function  Height_Specified(Index: Integer): boolean;
    procedure SetWidth(Index: Integer; const ADouble: Double);
    function  Width_Specified(Index: Integer): boolean;
    procedure SetDepth(Index: Integer; const ADouble: Double);
    function  Depth_Specified(Index: Integer): boolean;
    procedure SetPriceShippingLocal1(Index: Integer; const ADouble: Double);
    function  PriceShippingLocal1_Specified(Index: Integer): boolean;
    procedure SetPriceShippingSuppLocal1(Index: Integer; const ADouble: Double);
    function  PriceShippingSuppLocal1_Specified(Index: Integer): boolean;
    procedure SetPriceShippingLocal2(Index: Integer; const ADouble: Double);
    function  PriceShippingLocal2_Specified(Index: Integer): boolean;
    procedure SetPriceShippingSuppLocal2(Index: Integer; const ADouble: Double);
    function  PriceShippingSuppLocal2_Specified(Index: Integer): boolean;
    procedure SetPriceShippingLocal3(Index: Integer; const ADouble: Double);
    function  PriceShippingLocal3_Specified(Index: Integer): boolean;
    procedure SetPriceShippingSuppLocal3(Index: Integer; const ADouble: Double);
    function  PriceShippingSuppLocal3_Specified(Index: Integer): boolean;
    procedure SetPriceShippingInt1(Index: Integer; const ADouble: Double);
    function  PriceShippingInt1_Specified(Index: Integer): boolean;
    procedure SetPriceShippingSuppInt1(Index: Integer; const ADouble: Double);
    function  PriceShippingSuppInt1_Specified(Index: Integer): boolean;
    procedure SetPriceShippingInt2(Index: Integer; const ADouble: Double);
    function  PriceShippingInt2_Specified(Index: Integer): boolean;
    procedure SetPriceShippingSuppInt2(Index: Integer; const ADouble: Double);
    function  PriceShippingSuppInt2_Specified(Index: Integer): boolean;
    procedure SetPriceShippingInt3(Index: Integer; const ADouble: Double);
    function  PriceShippingInt3_Specified(Index: Integer): boolean;
    procedure SetPriceShippingSuppInt3(Index: Integer; const ADouble: Double);
    function  PriceShippingSuppInt3_Specified(Index: Integer): boolean;
    procedure SetImage1(Index: Integer; const AWideString: WideString);
    function  Image1_Specified(Index: Integer): boolean;
    procedure SetImage2(Index: Integer; const AWideString: WideString);
    function  Image2_Specified(Index: Integer): boolean;
    procedure SetImage3(Index: Integer; const AWideString: WideString);
    function  Image3_Specified(Index: Integer): boolean;
    procedure SetImage4(Index: Integer; const AWideString: WideString);
    function  Image4_Specified(Index: Integer): boolean;
    procedure SetImage5(Index: Integer; const AWideString: WideString);
    function  Image5_Specified(Index: Integer): boolean;
    procedure SetImage6(Index: Integer; const AWideString: WideString);
    function  Image6_Specified(Index: Integer): boolean;
    procedure SetArrayOfSpecificFields(Index: Integer; const AArrayOfSpecificFields: ArrayOfSpecificFields);
    function  ArrayOfSpecificFields_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Title:                   Array_Of_string        Index (IS_OPTN or IS_UNBD) read FTitle write SetTitle stored Title_Specified;
    property SubTitle:                Array_Of_string        Index (IS_OPTN or IS_UNBD) read FSubTitle write SetSubTitle stored SubTitle_Specified;
    property Description:             Array_Of_string        Index (IS_OPTN or IS_UNBD) read FDescription write SetDescription stored Description_Specified;
    property Comment:                 Array_Of_string        Index (IS_OPTN or IS_UNBD) read FComment write SetComment stored Comment_Specified;
    property SKU:                     WideString             read FSKU write FSKU;
    property SKUFamily:               WideString             Index (IS_OPTN) read FSKUFamily write SetSKUFamily stored SKUFamily_Specified;
    property Brand:                   WideString             Index (IS_OPTN) read FBrand write SetBrand stored Brand_Specified;
    property CodeProduit:             WideString             Index (IS_OPTN) read FCodeProduit write SetCodeProduit stored CodeProduit_Specified;
    property TypeCodeProduit:         WideString             Index (IS_OPTN) read FTypeCodeProduit write SetTypeCodeProduit stored TypeCodeProduit_Specified;
    property EAN:                     WideString             Index (IS_OPTN) read FEAN write SetEAN stored EAN_Specified;
    property UPC:                     WideString             Index (IS_OPTN) read FUPC write SetUPC stored UPC_Specified;
    property ISBN:                    WideString             Index (IS_OPTN) read FISBN write SetISBN stored ISBN_Specified;
    property ASIN:                    WideString             Index (IS_OPTN) read FASIN write SetASIN stored ASIN_Specified;
    property PartNumber:              WideString             Index (IS_OPTN) read FPartNumber write SetPartNumber stored PartNumber_Specified;
    property Quantity:                Int64                  Index (IS_OPTN) read FQuantity write SetQuantity stored Quantity_Specified;
    property Cost:                    Double                 Index (IS_OPTN) read FCost write SetCost stored Cost_Specified;
    property Tva:                     Double                 Index (IS_OPTN) read FTva write SetTva stored Tva_Specified;
    property Keywords:                WideString             Index (IS_OPTN) read FKeywords write SetKeywords stored Keywords_Specified;
    property DateAvailability:        TXSDateTime            Index (IS_OPTN) read FDateAvailability write SetDateAvailability stored DateAvailability_Specified;
    property PriceFixed:              Double                 Index (IS_OPTN) read FPriceFixed write SetPriceFixed stored PriceFixed_Specified;
    property PriceStarting:           Double                 Index (IS_OPTN) read FPriceStarting write SetPriceStarting stored PriceStarting_Specified;
    property PriceReserved:           Double                 Index (IS_OPTN) read FPriceReserved write SetPriceReserved stored PriceReserved_Specified;
    property PriceRetail:             Double                 Index (IS_OPTN) read FPriceRetail write SetPriceRetail stored PriceRetail_Specified;
    property PriceSecondChance:       Double                 Index (IS_OPTN) read FPriceSecondChance write SetPriceSecondChance stored PriceSecondChance_Specified;
    property PriceBestOffer:          Double                 Index (IS_OPTN) read FPriceBestOffer write SetPriceBestOffer stored PriceBestOffer_Specified;
    property PriceAdditional1:        Double                 Index (IS_OPTN) read FPriceAdditional1 write SetPriceAdditional1 stored PriceAdditional1_Specified;
    property PriceAdditional2:        Double                 Index (IS_OPTN) read FPriceAdditional2 write SetPriceAdditional2 stored PriceAdditional2_Specified;
    property PriceAdditional3:        Double                 Index (IS_OPTN) read FPriceAdditional3 write SetPriceAdditional3 stored PriceAdditional3_Specified;
    property PriceAdditional4:        Double                 Index (IS_OPTN) read FPriceAdditional4 write SetPriceAdditional4 stored PriceAdditional4_Specified;
    property PriceAdditional5:        Double                 Index (IS_OPTN) read FPriceAdditional5 write SetPriceAdditional5 stored PriceAdditional5_Specified;
    property Etat:                    EtatEnum               Index (IS_OPTN) read FEtat write SetEtat stored Etat_Specified;
    property LotSize:                 Int64                  Index (IS_OPTN) read FLotSize write SetLotSize stored LotSize_Specified;
    property SupplierName:            WideString             Index (IS_OPTN) read FSupplierName write SetSupplierName stored SupplierName_Specified;
    property Classification:          WideString             Index (IS_OPTN) read FClassification write SetClassification stored Classification_Specified;
    property Weight:                  Double                 Index (IS_OPTN) read FWeight write SetWeight stored Weight_Specified;
    property Height:                  Double                 Index (IS_OPTN) read FHeight write SetHeight stored Height_Specified;
    property Width:                   Double                 Index (IS_OPTN) read FWidth write SetWidth stored Width_Specified;
    property Depth:                   Double                 Index (IS_OPTN) read FDepth write SetDepth stored Depth_Specified;
    property PriceShippingLocal1:     Double                 Index (IS_OPTN) read FPriceShippingLocal1 write SetPriceShippingLocal1 stored PriceShippingLocal1_Specified;
    property PriceShippingSuppLocal1: Double                 Index (IS_OPTN) read FPriceShippingSuppLocal1 write SetPriceShippingSuppLocal1 stored PriceShippingSuppLocal1_Specified;
    property PriceShippingLocal2:     Double                 Index (IS_OPTN) read FPriceShippingLocal2 write SetPriceShippingLocal2 stored PriceShippingLocal2_Specified;
    property PriceShippingSuppLocal2: Double                 Index (IS_OPTN) read FPriceShippingSuppLocal2 write SetPriceShippingSuppLocal2 stored PriceShippingSuppLocal2_Specified;
    property PriceShippingLocal3:     Double                 Index (IS_OPTN) read FPriceShippingLocal3 write SetPriceShippingLocal3 stored PriceShippingLocal3_Specified;
    property PriceShippingSuppLocal3: Double                 Index (IS_OPTN) read FPriceShippingSuppLocal3 write SetPriceShippingSuppLocal3 stored PriceShippingSuppLocal3_Specified;
    property PriceShippingInt1:       Double                 Index (IS_OPTN) read FPriceShippingInt1 write SetPriceShippingInt1 stored PriceShippingInt1_Specified;
    property PriceShippingSuppInt1:   Double                 Index (IS_OPTN) read FPriceShippingSuppInt1 write SetPriceShippingSuppInt1 stored PriceShippingSuppInt1_Specified;
    property PriceShippingInt2:       Double                 Index (IS_OPTN) read FPriceShippingInt2 write SetPriceShippingInt2 stored PriceShippingInt2_Specified;
    property PriceShippingSuppInt2:   Double                 Index (IS_OPTN) read FPriceShippingSuppInt2 write SetPriceShippingSuppInt2 stored PriceShippingSuppInt2_Specified;
    property PriceShippingInt3:       Double                 Index (IS_OPTN) read FPriceShippingInt3 write SetPriceShippingInt3 stored PriceShippingInt3_Specified;
    property PriceShippingSuppInt3:   Double                 Index (IS_OPTN) read FPriceShippingSuppInt3 write SetPriceShippingSuppInt3 stored PriceShippingSuppInt3_Specified;
    property Image1:                  WideString             Index (IS_OPTN) read FImage1 write SetImage1 stored Image1_Specified;
    property Image2:                  WideString             Index (IS_OPTN) read FImage2 write SetImage2 stored Image2_Specified;
    property Image3:                  WideString             Index (IS_OPTN) read FImage3 write SetImage3 stored Image3_Specified;
    property Image4:                  WideString             Index (IS_OPTN) read FImage4 write SetImage4 stored Image4_Specified;
    property Image5:                  WideString             Index (IS_OPTN) read FImage5 write SetImage5 stored Image5_Specified;
    property Image6:                  WideString             Index (IS_OPTN) read FImage6 write SetImage6 stored Image6_Specified;
    property ArrayOfSpecificFields:   ArrayOfSpecificFields  Index (IS_OPTN) read FArrayOfSpecificFields write SetArrayOfSpecificFields stored ArrayOfSpecificFields_Specified;
  end;


  // ************************************************************************ //
  // Espace de nommage : urn:NWS:examples
  // soapAction : %operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // Liaison   : NWSServerBinding
  // service   : NWS
  // port      : NWSServerPortType
  // URL       : http://ws2.neteven.com/NWS
  // ************************************************************************ //
  NWSServerPortType = interface(IInvokable)
  ['{1E0A8B19-B13A-49C1-A5CD-EBC508520B6F}']

    function  Echo(const parameters: EchoRequestType): EchoResponseType; stdcall;

    // Headers: AuthenticationHeader:pIn
    function  GetItems(const parameters: GetItemsRequestType): InventoryItemsType; stdcall;

    // Headers: AuthenticationHeader:pIn
    function  TestConnection(const parameters: TestConnectionRequest): TestConnectionResponse; stdcall;

    // Headers: AuthenticationHeader:pIn
    function  PostItems(const parameters: PostItems): PostItemsResponse; stdcall;

    // Headers: AuthenticationHeader:pIn
    function  GetOrders(const parameters: GetOrders): GetOrdersResponse; stdcall;

    // Headers: AuthenticationHeader:pIn
    function  PostOrders(const parameters: PostOrders): PostOrdersResponse; stdcall;
  end;

function GetNWSServerPortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): NWSServerPortType;


implementation
  uses SysUtils;

function GetNWSServerPortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): NWSServerPortType;
const
  defWSDL = 'http://ws2.neteven.com/NWS';
  defURL  = 'http://ws2.neteven.com/NWS';
  defSvc  = 'NWS';
  defPrt  = 'NWSServerPortType';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as NWSServerPortType);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


procedure InventoryItemStatusResponse.SetItemCode(Index: Integer; const AWideString: WideString);
begin
  FItemCode := AWideString;
  FItemCode_Specified := True;
end;

function InventoryItemStatusResponse.ItemCode_Specified(Index: Integer): boolean;
begin
  Result := FItemCode_Specified;
end;

destructor MarketPlaceOrder.Destroy;
begin
  FreeAndNil(FDateSale);
  FreeAndNil(FDatePayment);
  FreeAndNil(FDateShipping);
  FreeAndNil(FDateAvailability);
  FreeAndNil(FBillingAddress);
  FreeAndNil(FShippingAddress);
  inherited Destroy;
end;

procedure MarketPlaceOrder.SetID(Index: Integer; const AWideString: WideString);
begin
  FID := AWideString;
  FID_Specified := True;
end;

function MarketPlaceOrder.ID_Specified(Index: Integer): boolean;
begin
  Result := FID_Specified;
end;

procedure MarketPlaceOrder.SetOrderID(Index: Integer; const AWideString: WideString);
begin
  FOrderID := AWideString;
  FOrderID_Specified := True;
end;

function MarketPlaceOrder.OrderID_Specified(Index: Integer): boolean;
begin
  Result := FOrderID_Specified;
end;

procedure MarketPlaceOrder.SetOrderLineID(Index: Integer; const AWideString: WideString);
begin
  FOrderLineID := AWideString;
  FOrderLineID_Specified := True;
end;

function MarketPlaceOrder.OrderLineID_Specified(Index: Integer): boolean;
begin
  Result := FOrderLineID_Specified;
end;

procedure MarketPlaceOrder.SetStatus(Index: Integer; const AOrderStatusEnum: OrderStatusEnum);
begin
  FStatus := AOrderStatusEnum;
  FStatus_Specified := True;
end;

function MarketPlaceOrder.Status_Specified(Index: Integer): boolean;
begin
  Result := FStatus_Specified;
end;

procedure MarketPlaceOrder.SetCustomerId(Index: Integer; const AWideString: WideString);
begin
  FCustomerId := AWideString;
  FCustomerId_Specified := True;
end;

function MarketPlaceOrder.CustomerId_Specified(Index: Integer): boolean;
begin
  Result := FCustomerId_Specified;
end;

procedure MarketPlaceOrder.SetMarketPlaceId(Index: Integer; const AWideString: WideString);
begin
  FMarketPlaceId := AWideString;
  FMarketPlaceId_Specified := True;
end;

function MarketPlaceOrder.MarketPlaceId_Specified(Index: Integer): boolean;
begin
  Result := FMarketPlaceId_Specified;
end;

procedure MarketPlaceOrder.SetMarketPlaceName(Index: Integer; const AWideString: WideString);
begin
  FMarketPlaceName := AWideString;
  FMarketPlaceName_Specified := True;
end;

function MarketPlaceOrder.MarketPlaceName_Specified(Index: Integer): boolean;
begin
  Result := FMarketPlaceName_Specified;
end;

procedure MarketPlaceOrder.SetMarketPlaceListingId(Index: Integer; const AWideString: WideString);
begin
  FMarketPlaceListingId := AWideString;
  FMarketPlaceListingId_Specified := True;
end;

function MarketPlaceOrder.MarketPlaceListingId_Specified(Index: Integer): boolean;
begin
  Result := FMarketPlaceListingId_Specified;
end;

procedure MarketPlaceOrder.SetMarketPlaceSaleId(Index: Integer; const AWideString: WideString);
begin
  FMarketPlaceSaleId := AWideString;
  FMarketPlaceSaleId_Specified := True;
end;

function MarketPlaceOrder.MarketPlaceSaleId_Specified(Index: Integer): boolean;
begin
  Result := FMarketPlaceSaleId_Specified;
end;

procedure MarketPlaceOrder.SetMarketPlaceInvoiceId(Index: Integer; const AWideString: WideString);
begin
  FMarketPlaceInvoiceId := AWideString;
  FMarketPlaceInvoiceId_Specified := True;
end;

function MarketPlaceOrder.MarketPlaceInvoiceId_Specified(Index: Integer): boolean;
begin
  Result := FMarketPlaceInvoiceId_Specified;
end;

procedure MarketPlaceOrder.SetSKU(Index: Integer; const AWideString: WideString);
begin
  FSKU := AWideString;
  FSKU_Specified := True;
end;

function MarketPlaceOrder.SKU_Specified(Index: Integer): boolean;
begin
  Result := FSKU_Specified;
end;

procedure MarketPlaceOrder.SetDateSale(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateSale := ATXSDateTime;
  FDateSale_Specified := True;
end;

function MarketPlaceOrder.DateSale_Specified(Index: Integer): boolean;
begin
  Result := FDateSale_Specified;
end;

procedure MarketPlaceOrder.SetDatePayment(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDatePayment := ATXSDateTime;
  FDatePayment_Specified := True;
end;

function MarketPlaceOrder.DatePayment_Specified(Index: Integer): boolean;
begin
  Result := FDatePayment_Specified;
end;

procedure MarketPlaceOrder.SetDateShipping(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateShipping := ATXSDateTime;
  FDateShipping_Specified := True;
end;

function MarketPlaceOrder.DateShipping_Specified(Index: Integer): boolean;
begin
  Result := FDateShipping_Specified;
end;

procedure MarketPlaceOrder.SetDateAvailability(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateAvailability := ATXSDateTime;
  FDateAvailability_Specified := True;
end;

function MarketPlaceOrder.DateAvailability_Specified(Index: Integer): boolean;
begin
  Result := FDateAvailability_Specified;
end;

procedure MarketPlaceOrder.SetTrackingNumber(Index: Integer; const AWideString: WideString);
begin
  FTrackingNumber := AWideString;
  FTrackingNumber_Specified := True;
end;

function MarketPlaceOrder.TrackingNumber_Specified(Index: Integer): boolean;
begin
  Result := FTrackingNumber_Specified;
end;

procedure MarketPlaceOrder.SetAmountPaid(Index: Integer; const ADouble: Double);
begin
  FAmountPaid := ADouble;
  FAmountPaid_Specified := True;
end;

function MarketPlaceOrder.AmountPaid_Specified(Index: Integer): boolean;
begin
  Result := FAmountPaid_Specified;
end;

procedure MarketPlaceOrder.SetPaymentMethod(Index: Integer; const APaymentMethodEnum: PaymentMethodEnum);
begin
  FPaymentMethod := APaymentMethodEnum;
  FPaymentMethod_Specified := True;
end;

function MarketPlaceOrder.PaymentMethod_Specified(Index: Integer): boolean;
begin
  Result := FPaymentMethod_Specified;
end;

procedure MarketPlaceOrder.SetQuantity(Index: Integer; const ADouble: Double);
begin
  FQuantity := ADouble;
  FQuantity_Specified := True;
end;

function MarketPlaceOrder.Quantity_Specified(Index: Integer): boolean;
begin
  Result := FQuantity_Specified;
end;

procedure MarketPlaceOrder.SetPrice(Index: Integer; const ADouble: Double);
begin
  FPrice := ADouble;
  FPrice_Specified := True;
end;

function MarketPlaceOrder.Price_Specified(Index: Integer): boolean;
begin
  Result := FPrice_Specified;
end;

procedure MarketPlaceOrder.SetInsuranceId(Index: Integer; const AWideString: WideString);
begin
  FInsuranceId := AWideString;
  FInsuranceId_Specified := True;
end;

function MarketPlaceOrder.InsuranceId_Specified(Index: Integer): boolean;
begin
  Result := FInsuranceId_Specified;
end;

procedure MarketPlaceOrder.SetInsuranceCost(Index: Integer; const ADouble: Double);
begin
  FInsuranceCost := ADouble;
  FInsuranceCost_Specified := True;
end;

function MarketPlaceOrder.InsuranceCost_Specified(Index: Integer): boolean;
begin
  Result := FInsuranceCost_Specified;
end;

procedure MarketPlaceOrder.SetShippingCost(Index: Integer; const ADouble: Double);
begin
  FShippingCost := ADouble;
  FShippingCost_Specified := True;
end;

function MarketPlaceOrder.ShippingCost_Specified(Index: Integer): boolean;
begin
  Result := FShippingCost_Specified;
end;

procedure MarketPlaceOrder.SetFinalShippingCost(Index: Integer; const ADouble: Double);
begin
  FFinalShippingCost := ADouble;
  FFinalShippingCost_Specified := True;
end;

function MarketPlaceOrder.FinalShippingCost_Specified(Index: Integer): boolean;
begin
  Result := FFinalShippingCost_Specified;
end;

procedure MarketPlaceOrder.SetShipperId(Index: Integer; const AWideString: WideString);
begin
  FShipperId := AWideString;
  FShipperId_Specified := True;
end;

function MarketPlaceOrder.ShipperId_Specified(Index: Integer): boolean;
begin
  Result := FShipperId_Specified;
end;

procedure MarketPlaceOrder.SetVAT(Index: Integer; const ADouble: Double);
begin
  FVAT := ADouble;
  FVAT_Specified := True;
end;

function MarketPlaceOrder.VAT_Specified(Index: Integer): boolean;
begin
  Result := FVAT_Specified;
end;

procedure MarketPlaceOrder.SetTotalCostWithVAT(Index: Integer; const ADouble: Double);
begin
  FTotalCostWithVAT := ADouble;
  FTotalCostWithVAT_Specified := True;
end;

function MarketPlaceOrder.TotalCostWithVAT_Specified(Index: Integer): boolean;
begin
  Result := FTotalCostWithVAT_Specified;
end;

procedure MarketPlaceOrder.SetMarketplaceFee(Index: Integer; const ADouble: Double);
begin
  FMarketplaceFee := ADouble;
  FMarketplaceFee_Specified := True;
end;

function MarketPlaceOrder.MarketplaceFee_Specified(Index: Integer): boolean;
begin
  Result := FMarketplaceFee_Specified;
end;

procedure MarketPlaceOrder.SetBillingAddress(Index: Integer; const AMarketPlaceAddress: MarketPlaceAddress);
begin
  FBillingAddress := AMarketPlaceAddress;
  FBillingAddress_Specified := True;
end;

function MarketPlaceOrder.BillingAddress_Specified(Index: Integer): boolean;
begin
  Result := FBillingAddress_Specified;
end;

procedure MarketPlaceOrder.SetShippingAddress(Index: Integer; const AMarketPlaceAddress: MarketPlaceAddress);
begin
  FShippingAddress := AMarketPlaceAddress;
  FShippingAddress_Specified := True;
end;

function MarketPlaceOrder.ShippingAddress_Specified(Index: Integer): boolean;
begin
  Result := FShippingAddress_Specified;
end;

procedure MarketPlaceAddress.SetFirstName(Index: Integer; const AWideString: WideString);
begin
  FFirstName := AWideString;
  FFirstName_Specified := True;
end;

function MarketPlaceAddress.FirstName_Specified(Index: Integer): boolean;
begin
  Result := FFirstName_Specified;
end;

procedure MarketPlaceAddress.SetLastName(Index: Integer; const AWideString: WideString);
begin
  FLastName := AWideString;
  FLastName_Specified := True;
end;

function MarketPlaceAddress.LastName_Specified(Index: Integer): boolean;
begin
  Result := FLastName_Specified;
end;

procedure MarketPlaceAddress.SetAddress1(Index: Integer; const AWideString: WideString);
begin
  FAddress1 := AWideString;
  FAddress1_Specified := True;
end;

function MarketPlaceAddress.Address1_Specified(Index: Integer): boolean;
begin
  Result := FAddress1_Specified;
end;

procedure MarketPlaceAddress.SetAddress2(Index: Integer; const AWideString: WideString);
begin
  FAddress2 := AWideString;
  FAddress2_Specified := True;
end;

function MarketPlaceAddress.Address2_Specified(Index: Integer): boolean;
begin
  Result := FAddress2_Specified;
end;

procedure MarketPlaceAddress.SetCityName(Index: Integer; const AWideString: WideString);
begin
  FCityName := AWideString;
  FCityName_Specified := True;
end;

function MarketPlaceAddress.CityName_Specified(Index: Integer): boolean;
begin
  Result := FCityName_Specified;
end;

procedure MarketPlaceAddress.SetPostalCode(Index: Integer; const AWideString: WideString);
begin
  FPostalCode := AWideString;
  FPostalCode_Specified := True;
end;

function MarketPlaceAddress.PostalCode_Specified(Index: Integer): boolean;
begin
  Result := FPostalCode_Specified;
end;

procedure MarketPlaceAddress.SetCountry(Index: Integer; const AWideString: WideString);
begin
  FCountry := AWideString;
  FCountry_Specified := True;
end;

function MarketPlaceAddress.Country_Specified(Index: Integer): boolean;
begin
  Result := FCountry_Specified;
end;

procedure MarketPlaceAddress.SetPhone(Index: Integer; const AWideString: WideString);
begin
  FPhone := AWideString;
  FPhone_Specified := True;
end;

function MarketPlaceAddress.Phone_Specified(Index: Integer): boolean;
begin
  Result := FPhone_Specified;
end;

procedure MarketPlaceAddress.SetMobile(Index: Integer; const AWideString: WideString);
begin
  FMobile := AWideString;
  FMobile_Specified := True;
end;

function MarketPlaceAddress.Mobile_Specified(Index: Integer): boolean;
begin
  Result := FMobile_Specified;
end;

procedure MarketPlaceAddress.SetFax(Index: Integer; const AWideString: WideString);
begin
  FFax := AWideString;
  FFax_Specified := True;
end;

function MarketPlaceAddress.Fax_Specified(Index: Integer): boolean;
begin
  Result := FFax_Specified;
end;

procedure MarketPlaceAddress.SetEmail(Index: Integer; const AWideString: WideString);
begin
  FEmail := AWideString;
  FEmail_Specified := True;
end;

function MarketPlaceAddress.Email_Specified(Index: Integer): boolean;
begin
  Result := FEmail_Specified;
end;

procedure MarketPlaceAddress.SetCompany(Index: Integer; const AWideString: WideString);
begin
  FCompany := AWideString;
  FCompany_Specified := True;
end;

function MarketPlaceAddress.Company_Specified(Index: Integer): boolean;
begin
  Result := FCompany_Specified;
end;

procedure MarketPlaceOrderStatusResponse.SetOrderLineID(Index: Integer; const AWideString: WideString);
begin
  FOrderLineID := AWideString;
  FOrderLineID_Specified := True;
end;

function MarketPlaceOrderStatusResponse.OrderLineID_Specified(Index: Integer): boolean;
begin
  Result := FOrderLineID_Specified;
end;

procedure MarketPlaceOrderStatusResponse.SetOrderID(Index: Integer; const AWideString: WideString);
begin
  FOrderID := AWideString;
  FOrderID_Specified := True;
end;

function MarketPlaceOrderStatusResponse.OrderID_Specified(Index: Integer): boolean;
begin
  Result := FOrderID_Specified;
end;

procedure MarketPlaceOrderStatusResponse.SetOrderId_(Index: Integer; const AWideString: WideString);
begin
  FOrderId_ := AWideString;
  FOrderId__Specified := True;
end;

function MarketPlaceOrderStatusResponse.OrderId__Specified(Index: Integer): boolean;
begin
  Result := FOrderId__Specified;
end;

constructor EchoRequestType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

procedure EchoRequestType.SetEchoInput(Index: Integer; const AWideString: WideString);
begin
  FEchoInput := AWideString;
  FEchoInput_Specified := True;
end;

function EchoRequestType.EchoInput_Specified(Index: Integer): boolean;
begin
  Result := FEchoInput_Specified;
end;

constructor EchoResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

procedure EchoResponseType.SetEchoOutput(Index: Integer; const AWideString: WideString);
begin
  FEchoOutput := AWideString;
  FEchoOutput_Specified := True;
end;

function EchoResponseType.EchoOutput_Specified(Index: Integer): boolean;
begin
  Result := FEchoOutput_Specified;
end;

constructor GetItemsRequestType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetItemsRequestType.Destroy;
begin
  FreeAndNil(FDateModificationFrom);
  inherited Destroy;
end;

procedure GetItemsRequestType.SetGetItemsInput(Index: Integer; const AWideString: WideString);
begin
  FGetItemsInput := AWideString;
  FGetItemsInput_Specified := True;
end;

function GetItemsRequestType.GetItemsInput_Specified(Index: Integer): boolean;
begin
  Result := FGetItemsInput_Specified;
end;

procedure GetItemsRequestType.SetPageNumber(Index: Integer; const AInt64: Int64);
begin
  FPageNumber := AInt64;
  FPageNumber_Specified := True;
end;

function GetItemsRequestType.PageNumber_Specified(Index: Integer): boolean;
begin
  Result := FPageNumber_Specified;
end;

procedure GetItemsRequestType.SetDateModificationFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateModificationFrom := ATXSDateTime;
  FDateModificationFrom_Specified := True;
end;

function GetItemsRequestType.DateModificationFrom_Specified(Index: Integer): boolean;
begin
  Result := FDateModificationFrom_Specified;
end;

procedure GetItemsRequestType.SetSKU(Index: Integer; const AWideString: WideString);
begin
  FSKU := AWideString;
  FSKU_Specified := True;
end;

function GetItemsRequestType.SKU_Specified(Index: Integer): boolean;
begin
  Result := FSKU_Specified;
end;

constructor TestConnectionRequest.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor TestConnectionResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor InventoryItemsType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor InventoryItemsType.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fitems)-1 do
    FreeAndNil(Fitems[I]);
  SetLength(Fitems, 0);
  inherited Destroy;
end;

procedure InventoryItemsType.Setitems(Index: Integer; const AArrayOfInventoryItem: ArrayOfInventoryItem);
begin
  Fitems := AArrayOfInventoryItem;
  Fitems_Specified := True;
end;

function InventoryItemsType.items_Specified(Index: Integer): boolean;
begin
  Result := Fitems_Specified;
end;

constructor PostItems.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PostItems.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fitems)-1 do
    FreeAndNil(Fitems[I]);
  SetLength(Fitems, 0);
  inherited Destroy;
end;

procedure PostItems.Setitems(Index: Integer; const AArrayOfInventoryItem: ArrayOfInventoryItem);
begin
  Fitems := AArrayOfInventoryItem;
  Fitems_Specified := True;
end;

function PostItems.items_Specified(Index: Integer): boolean;
begin
  Result := Fitems_Specified;
end;

constructor PostItemsResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PostItemsResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FPostItemsResult)-1 do
    FreeAndNil(FPostItemsResult[I]);
  SetLength(FPostItemsResult, 0);
  inherited Destroy;
end;

procedure PostItemsResponse.SetPostItemsResult(Index: Integer; const AArrayOfInventoryItemStatusResponse: ArrayOfInventoryItemStatusResponse);
begin
  FPostItemsResult := AArrayOfInventoryItemStatusResponse;
  FPostItemsResult_Specified := True;
end;

function PostItemsResponse.PostItemsResult_Specified(Index: Integer): boolean;
begin
  Result := FPostItemsResult_Specified;
end;

constructor GetOrders.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetOrders.Destroy;
begin
  FreeAndNil(FDateSaleFrom);
  FreeAndNil(FDateSaleTo);
  FreeAndNil(FDatePaymentFrom);
  FreeAndNil(FDatePaymentTo);
  FreeAndNil(FDateCreationFrom);
  FreeAndNil(FDateCreationTo);
  FreeAndNil(FDateModificationFrom);
  FreeAndNil(FDateModificationTo);
  FreeAndNil(FDateAvailabilityFrom);
  FreeAndNil(FDateAvailabilityTo);
  inherited Destroy;
end;

procedure GetOrders.SetPageNumber(Index: Integer; const AWideString: WideString);
begin
  FPageNumber := AWideString;
  FPageNumber_Specified := True;
end;

function GetOrders.PageNumber_Specified(Index: Integer): boolean;
begin
  Result := FPageNumber_Specified;
end;

procedure GetOrders.SetDateSaleFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateSaleFrom := ATXSDateTime;
  FDateSaleFrom_Specified := True;
end;

function GetOrders.DateSaleFrom_Specified(Index: Integer): boolean;
begin
  Result := FDateSaleFrom_Specified;
end;

procedure GetOrders.SetDateSaleTo(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateSaleTo := ATXSDateTime;
  FDateSaleTo_Specified := True;
end;

function GetOrders.DateSaleTo_Specified(Index: Integer): boolean;
begin
  Result := FDateSaleTo_Specified;
end;

procedure GetOrders.SetDatePaymentFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDatePaymentFrom := ATXSDateTime;
  FDatePaymentFrom_Specified := True;
end;

function GetOrders.DatePaymentFrom_Specified(Index: Integer): boolean;
begin
  Result := FDatePaymentFrom_Specified;
end;

procedure GetOrders.SetDatePaymentTo(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDatePaymentTo := ATXSDateTime;
  FDatePaymentTo_Specified := True;
end;

function GetOrders.DatePaymentTo_Specified(Index: Integer): boolean;
begin
  Result := FDatePaymentTo_Specified;
end;

procedure GetOrders.SetDateCreationFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateCreationFrom := ATXSDateTime;
  FDateCreationFrom_Specified := True;
end;

function GetOrders.DateCreationFrom_Specified(Index: Integer): boolean;
begin
  Result := FDateCreationFrom_Specified;
end;

procedure GetOrders.SetDateCreationTo(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateCreationTo := ATXSDateTime;
  FDateCreationTo_Specified := True;
end;

function GetOrders.DateCreationTo_Specified(Index: Integer): boolean;
begin
  Result := FDateCreationTo_Specified;
end;

procedure GetOrders.SetDateModificationFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateModificationFrom := ATXSDateTime;
  FDateModificationFrom_Specified := True;
end;

function GetOrders.DateModificationFrom_Specified(Index: Integer): boolean;
begin
  Result := FDateModificationFrom_Specified;
end;

procedure GetOrders.SetDateModificationTo(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateModificationTo := ATXSDateTime;
  FDateModificationTo_Specified := True;
end;

function GetOrders.DateModificationTo_Specified(Index: Integer): boolean;
begin
  Result := FDateModificationTo_Specified;
end;

procedure GetOrders.SetDateAvailabilityFrom(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateAvailabilityFrom := ATXSDateTime;
  FDateAvailabilityFrom_Specified := True;
end;

function GetOrders.DateAvailabilityFrom_Specified(Index: Integer): boolean;
begin
  Result := FDateAvailabilityFrom_Specified;
end;

procedure GetOrders.SetDateAvailabilityTo(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateAvailabilityTo := ATXSDateTime;
  FDateAvailabilityTo_Specified := True;
end;

function GetOrders.DateAvailabilityTo_Specified(Index: Integer): boolean;
begin
  Result := FDateAvailabilityTo_Specified;
end;

procedure GetOrders.SetMarketPlaceId(Index: Integer; const AWideString: WideString);
begin
  FMarketPlaceId := AWideString;
  FMarketPlaceId_Specified := True;
end;

function GetOrders.MarketPlaceId_Specified(Index: Integer): boolean;
begin
  Result := FMarketPlaceId_Specified;
end;

procedure GetOrders.SetOrderID(Index: Integer; const AWideString: WideString);
begin
  FOrderID := AWideString;
  FOrderID_Specified := True;
end;

function GetOrders.OrderID_Specified(Index: Integer): boolean;
begin
  Result := FOrderID_Specified;
end;

constructor GetOrdersResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetOrdersResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FGetOrdersResult)-1 do
    FreeAndNil(FGetOrdersResult[I]);
  SetLength(FGetOrdersResult, 0);
  inherited Destroy;
end;

procedure GetOrdersResponse.SetGetOrdersResult(Index: Integer; const AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
begin
  FGetOrdersResult := AArrayOfMarketPlaceOrder;
  FGetOrdersResult_Specified := True;
end;

function GetOrdersResponse.GetOrdersResult_Specified(Index: Integer): boolean;
begin
  Result := FGetOrdersResult_Specified;
end;

constructor PostOrders.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PostOrders.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Forders)-1 do
    FreeAndNil(Forders[I]);
  SetLength(Forders, 0);
  inherited Destroy;
end;

procedure PostOrders.Setorders(Index: Integer; const AArrayOfMarketPlaceOrder: ArrayOfMarketPlaceOrder);
begin
  Forders := AArrayOfMarketPlaceOrder;
  Forders_Specified := True;
end;

function PostOrders.orders_Specified(Index: Integer): boolean;
begin
  Result := Forders_Specified;
end;

constructor PostOrdersResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PostOrdersResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FPostOrdersResult)-1 do
    FreeAndNil(FPostOrdersResult[I]);
  SetLength(FPostOrdersResult, 0);
  inherited Destroy;
end;

procedure PostOrdersResponse.SetPostOrdersResult(Index: Integer; const AArrayOfMarketPlaceOrderStatusResponse: ArrayOfMarketPlaceOrderStatusResponse);
begin
  FPostOrdersResult := AArrayOfMarketPlaceOrderStatusResponse;
  FPostOrdersResult_Specified := True;
end;

function PostOrdersResponse.PostOrdersResult_Specified(Index: Integer): boolean;
begin
  Result := FPostOrdersResult_Specified;
end;

destructor InventoryItem.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FArrayOfSpecificFields)-1 do
    FreeAndNil(FArrayOfSpecificFields[I]);
  SetLength(FArrayOfSpecificFields, 0);
  FreeAndNil(FDateAvailability);
  inherited Destroy;
end;

procedure InventoryItem.SetTitle(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  FTitle := AArray_Of_string;
  FTitle_Specified := True;
end;

function InventoryItem.Title_Specified(Index: Integer): boolean;
begin
  Result := FTitle_Specified;
end;

procedure InventoryItem.SetSubTitle(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  FSubTitle := AArray_Of_string;
  FSubTitle_Specified := True;
end;

function InventoryItem.SubTitle_Specified(Index: Integer): boolean;
begin
  Result := FSubTitle_Specified;
end;

procedure InventoryItem.SetDescription(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  FDescription := AArray_Of_string;
  FDescription_Specified := True;
end;

function InventoryItem.Description_Specified(Index: Integer): boolean;
begin
  Result := FDescription_Specified;
end;

procedure InventoryItem.SetComment(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  FComment := AArray_Of_string;
  FComment_Specified := True;
end;

function InventoryItem.Comment_Specified(Index: Integer): boolean;
begin
  Result := FComment_Specified;
end;

procedure InventoryItem.SetSKUFamily(Index: Integer; const AWideString: WideString);
begin
  FSKUFamily := AWideString;
  FSKUFamily_Specified := True;
end;

function InventoryItem.SKUFamily_Specified(Index: Integer): boolean;
begin
  Result := FSKUFamily_Specified;
end;

procedure InventoryItem.SetBrand(Index: Integer; const AWideString: WideString);
begin
  FBrand := AWideString;
  FBrand_Specified := True;
end;

function InventoryItem.Brand_Specified(Index: Integer): boolean;
begin
  Result := FBrand_Specified;
end;

procedure InventoryItem.SetCodeProduit(Index: Integer; const AWideString: WideString);
begin
  FCodeProduit := AWideString;
  FCodeProduit_Specified := True;
end;

function InventoryItem.CodeProduit_Specified(Index: Integer): boolean;
begin
  Result := FCodeProduit_Specified;
end;

procedure InventoryItem.SetTypeCodeProduit(Index: Integer; const AWideString: WideString);
begin
  FTypeCodeProduit := AWideString;
  FTypeCodeProduit_Specified := True;
end;

function InventoryItem.TypeCodeProduit_Specified(Index: Integer): boolean;
begin
  Result := FTypeCodeProduit_Specified;
end;

procedure InventoryItem.SetEAN(Index: Integer; const AWideString: WideString);
begin
  FEAN := AWideString;
  FEAN_Specified := True;
end;

function InventoryItem.EAN_Specified(Index: Integer): boolean;
begin
  Result := FEAN_Specified;
end;

procedure InventoryItem.SetUPC(Index: Integer; const AWideString: WideString);
begin
  FUPC := AWideString;
  FUPC_Specified := True;
end;

function InventoryItem.UPC_Specified(Index: Integer): boolean;
begin
  Result := FUPC_Specified;
end;

procedure InventoryItem.SetISBN(Index: Integer; const AWideString: WideString);
begin
  FISBN := AWideString;
  FISBN_Specified := True;
end;

function InventoryItem.ISBN_Specified(Index: Integer): boolean;
begin
  Result := FISBN_Specified;
end;

procedure InventoryItem.SetASIN(Index: Integer; const AWideString: WideString);
begin
  FASIN := AWideString;
  FASIN_Specified := True;
end;

function InventoryItem.ASIN_Specified(Index: Integer): boolean;
begin
  Result := FASIN_Specified;
end;

procedure InventoryItem.SetPartNumber(Index: Integer; const AWideString: WideString);
begin
  FPartNumber := AWideString;
  FPartNumber_Specified := True;
end;

function InventoryItem.PartNumber_Specified(Index: Integer): boolean;
begin
  Result := FPartNumber_Specified;
end;

procedure InventoryItem.SetQuantity(Index: Integer; const AInt64: Int64);
begin
  FQuantity := AInt64;
  FQuantity_Specified := True;
end;

function InventoryItem.Quantity_Specified(Index: Integer): boolean;
begin
  Result := FQuantity_Specified;
end;

procedure InventoryItem.SetCost(Index: Integer; const ADouble: Double);
begin
  FCost := ADouble;
  FCost_Specified := True;
end;

function InventoryItem.Cost_Specified(Index: Integer): boolean;
begin
  Result := FCost_Specified;
end;

procedure InventoryItem.SetTva(Index: Integer; const ADouble: Double);
begin
  FTva := ADouble;
  FTva_Specified := True;
end;

function InventoryItem.Tva_Specified(Index: Integer): boolean;
begin
  Result := FTva_Specified;
end;

procedure InventoryItem.SetKeywords(Index: Integer; const AWideString: WideString);
begin
  FKeywords := AWideString;
  FKeywords_Specified := True;
end;

function InventoryItem.Keywords_Specified(Index: Integer): boolean;
begin
  Result := FKeywords_Specified;
end;

procedure InventoryItem.SetDateAvailability(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateAvailability := ATXSDateTime;
  FDateAvailability_Specified := True;
end;

function InventoryItem.DateAvailability_Specified(Index: Integer): boolean;
begin
  Result := FDateAvailability_Specified;
end;

procedure InventoryItem.SetPriceFixed(Index: Integer; const ADouble: Double);
begin
  FPriceFixed := ADouble;
  FPriceFixed_Specified := True;
end;

function InventoryItem.PriceFixed_Specified(Index: Integer): boolean;
begin
  Result := FPriceFixed_Specified;
end;

procedure InventoryItem.SetPriceStarting(Index: Integer; const ADouble: Double);
begin
  FPriceStarting := ADouble;
  FPriceStarting_Specified := True;
end;

function InventoryItem.PriceStarting_Specified(Index: Integer): boolean;
begin
  Result := FPriceStarting_Specified;
end;

procedure InventoryItem.SetPriceReserved(Index: Integer; const ADouble: Double);
begin
  FPriceReserved := ADouble;
  FPriceReserved_Specified := True;
end;

function InventoryItem.PriceReserved_Specified(Index: Integer): boolean;
begin
  Result := FPriceReserved_Specified;
end;

procedure InventoryItem.SetPriceRetail(Index: Integer; const ADouble: Double);
begin
  FPriceRetail := ADouble;
  FPriceRetail_Specified := True;
end;

function InventoryItem.PriceRetail_Specified(Index: Integer): boolean;
begin
  Result := FPriceRetail_Specified;
end;

procedure InventoryItem.SetPriceSecondChance(Index: Integer; const ADouble: Double);
begin
  FPriceSecondChance := ADouble;
  FPriceSecondChance_Specified := True;
end;

function InventoryItem.PriceSecondChance_Specified(Index: Integer): boolean;
begin
  Result := FPriceSecondChance_Specified;
end;

procedure InventoryItem.SetPriceBestOffer(Index: Integer; const ADouble: Double);
begin
  FPriceBestOffer := ADouble;
  FPriceBestOffer_Specified := True;
end;

function InventoryItem.PriceBestOffer_Specified(Index: Integer): boolean;
begin
  Result := FPriceBestOffer_Specified;
end;

procedure InventoryItem.SetPriceAdditional1(Index: Integer; const ADouble: Double);
begin
  FPriceAdditional1 := ADouble;
  FPriceAdditional1_Specified := True;
end;

function InventoryItem.PriceAdditional1_Specified(Index: Integer): boolean;
begin
  Result := FPriceAdditional1_Specified;
end;

procedure InventoryItem.SetPriceAdditional2(Index: Integer; const ADouble: Double);
begin
  FPriceAdditional2 := ADouble;
  FPriceAdditional2_Specified := True;
end;

function InventoryItem.PriceAdditional2_Specified(Index: Integer): boolean;
begin
  Result := FPriceAdditional2_Specified;
end;

procedure InventoryItem.SetPriceAdditional3(Index: Integer; const ADouble: Double);
begin
  FPriceAdditional3 := ADouble;
  FPriceAdditional3_Specified := True;
end;

function InventoryItem.PriceAdditional3_Specified(Index: Integer): boolean;
begin
  Result := FPriceAdditional3_Specified;
end;

procedure InventoryItem.SetPriceAdditional4(Index: Integer; const ADouble: Double);
begin
  FPriceAdditional4 := ADouble;
  FPriceAdditional4_Specified := True;
end;

function InventoryItem.PriceAdditional4_Specified(Index: Integer): boolean;
begin
  Result := FPriceAdditional4_Specified;
end;

procedure InventoryItem.SetPriceAdditional5(Index: Integer; const ADouble: Double);
begin
  FPriceAdditional5 := ADouble;
  FPriceAdditional5_Specified := True;
end;

function InventoryItem.PriceAdditional5_Specified(Index: Integer): boolean;
begin
  Result := FPriceAdditional5_Specified;
end;

procedure InventoryItem.SetEtat(Index: Integer; const AEtatEnum: EtatEnum);
begin
  FEtat := AEtatEnum;
  FEtat_Specified := True;
end;

function InventoryItem.Etat_Specified(Index: Integer): boolean;
begin
  Result := FEtat_Specified;
end;

procedure InventoryItem.SetLotSize(Index: Integer; const AInt64: Int64);
begin
  FLotSize := AInt64;
  FLotSize_Specified := True;
end;

function InventoryItem.LotSize_Specified(Index: Integer): boolean;
begin
  Result := FLotSize_Specified;
end;

procedure InventoryItem.SetSupplierName(Index: Integer; const AWideString: WideString);
begin
  FSupplierName := AWideString;
  FSupplierName_Specified := True;
end;

function InventoryItem.SupplierName_Specified(Index: Integer): boolean;
begin
  Result := FSupplierName_Specified;
end;

procedure InventoryItem.SetClassification(Index: Integer; const AWideString: WideString);
begin
  FClassification := AWideString;
  FClassification_Specified := True;
end;

function InventoryItem.Classification_Specified(Index: Integer): boolean;
begin
  Result := FClassification_Specified;
end;

procedure InventoryItem.SetWeight(Index: Integer; const ADouble: Double);
begin
  FWeight := ADouble;
  FWeight_Specified := True;
end;

function InventoryItem.Weight_Specified(Index: Integer): boolean;
begin
  Result := FWeight_Specified;
end;

procedure InventoryItem.SetHeight(Index: Integer; const ADouble: Double);
begin
  FHeight := ADouble;
  FHeight_Specified := True;
end;

function InventoryItem.Height_Specified(Index: Integer): boolean;
begin
  Result := FHeight_Specified;
end;

procedure InventoryItem.SetWidth(Index: Integer; const ADouble: Double);
begin
  FWidth := ADouble;
  FWidth_Specified := True;
end;

function InventoryItem.Width_Specified(Index: Integer): boolean;
begin
  Result := FWidth_Specified;
end;

procedure InventoryItem.SetDepth(Index: Integer; const ADouble: Double);
begin
  FDepth := ADouble;
  FDepth_Specified := True;
end;

function InventoryItem.Depth_Specified(Index: Integer): boolean;
begin
  Result := FDepth_Specified;
end;

procedure InventoryItem.SetPriceShippingLocal1(Index: Integer; const ADouble: Double);
begin
  FPriceShippingLocal1 := ADouble;
  FPriceShippingLocal1_Specified := True;
end;

function InventoryItem.PriceShippingLocal1_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingLocal1_Specified;
end;

procedure InventoryItem.SetPriceShippingSuppLocal1(Index: Integer; const ADouble: Double);
begin
  FPriceShippingSuppLocal1 := ADouble;
  FPriceShippingSuppLocal1_Specified := True;
end;

function InventoryItem.PriceShippingSuppLocal1_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingSuppLocal1_Specified;
end;

procedure InventoryItem.SetPriceShippingLocal2(Index: Integer; const ADouble: Double);
begin
  FPriceShippingLocal2 := ADouble;
  FPriceShippingLocal2_Specified := True;
end;

function InventoryItem.PriceShippingLocal2_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingLocal2_Specified;
end;

procedure InventoryItem.SetPriceShippingSuppLocal2(Index: Integer; const ADouble: Double);
begin
  FPriceShippingSuppLocal2 := ADouble;
  FPriceShippingSuppLocal2_Specified := True;
end;

function InventoryItem.PriceShippingSuppLocal2_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingSuppLocal2_Specified;
end;

procedure InventoryItem.SetPriceShippingLocal3(Index: Integer; const ADouble: Double);
begin
  FPriceShippingLocal3 := ADouble;
  FPriceShippingLocal3_Specified := True;
end;

function InventoryItem.PriceShippingLocal3_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingLocal3_Specified;
end;

procedure InventoryItem.SetPriceShippingSuppLocal3(Index: Integer; const ADouble: Double);
begin
  FPriceShippingSuppLocal3 := ADouble;
  FPriceShippingSuppLocal3_Specified := True;
end;

function InventoryItem.PriceShippingSuppLocal3_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingSuppLocal3_Specified;
end;

procedure InventoryItem.SetPriceShippingInt1(Index: Integer; const ADouble: Double);
begin
  FPriceShippingInt1 := ADouble;
  FPriceShippingInt1_Specified := True;
end;

function InventoryItem.PriceShippingInt1_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingInt1_Specified;
end;

procedure InventoryItem.SetPriceShippingSuppInt1(Index: Integer; const ADouble: Double);
begin
  FPriceShippingSuppInt1 := ADouble;
  FPriceShippingSuppInt1_Specified := True;
end;

function InventoryItem.PriceShippingSuppInt1_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingSuppInt1_Specified;
end;

procedure InventoryItem.SetPriceShippingInt2(Index: Integer; const ADouble: Double);
begin
  FPriceShippingInt2 := ADouble;
  FPriceShippingInt2_Specified := True;
end;

function InventoryItem.PriceShippingInt2_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingInt2_Specified;
end;

procedure InventoryItem.SetPriceShippingSuppInt2(Index: Integer; const ADouble: Double);
begin
  FPriceShippingSuppInt2 := ADouble;
  FPriceShippingSuppInt2_Specified := True;
end;

function InventoryItem.PriceShippingSuppInt2_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingSuppInt2_Specified;
end;

procedure InventoryItem.SetPriceShippingInt3(Index: Integer; const ADouble: Double);
begin
  FPriceShippingInt3 := ADouble;
  FPriceShippingInt3_Specified := True;
end;

function InventoryItem.PriceShippingInt3_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingInt3_Specified;
end;

procedure InventoryItem.SetPriceShippingSuppInt3(Index: Integer; const ADouble: Double);
begin
  FPriceShippingSuppInt3 := ADouble;
  FPriceShippingSuppInt3_Specified := True;
end;

function InventoryItem.PriceShippingSuppInt3_Specified(Index: Integer): boolean;
begin
  Result := FPriceShippingSuppInt3_Specified;
end;

procedure InventoryItem.SetImage1(Index: Integer; const AWideString: WideString);
begin
  FImage1 := AWideString;
  FImage1_Specified := True;
end;

function InventoryItem.Image1_Specified(Index: Integer): boolean;
begin
  Result := FImage1_Specified;
end;

procedure InventoryItem.SetImage2(Index: Integer; const AWideString: WideString);
begin
  FImage2 := AWideString;
  FImage2_Specified := True;
end;

function InventoryItem.Image2_Specified(Index: Integer): boolean;
begin
  Result := FImage2_Specified;
end;

procedure InventoryItem.SetImage3(Index: Integer; const AWideString: WideString);
begin
  FImage3 := AWideString;
  FImage3_Specified := True;
end;

function InventoryItem.Image3_Specified(Index: Integer): boolean;
begin
  Result := FImage3_Specified;
end;

procedure InventoryItem.SetImage4(Index: Integer; const AWideString: WideString);
begin
  FImage4 := AWideString;
  FImage4_Specified := True;
end;

function InventoryItem.Image4_Specified(Index: Integer): boolean;
begin
  Result := FImage4_Specified;
end;

procedure InventoryItem.SetImage5(Index: Integer; const AWideString: WideString);
begin
  FImage5 := AWideString;
  FImage5_Specified := True;
end;

function InventoryItem.Image5_Specified(Index: Integer): boolean;
begin
  Result := FImage5_Specified;
end;

procedure InventoryItem.SetImage6(Index: Integer; const AWideString: WideString);
begin
  FImage6 := AWideString;
  FImage6_Specified := True;
end;

function InventoryItem.Image6_Specified(Index: Integer): boolean;
begin
  Result := FImage6_Specified;
end;

procedure InventoryItem.SetArrayOfSpecificFields(Index: Integer; const AArrayOfSpecificFields: ArrayOfSpecificFields);
begin
  FArrayOfSpecificFields := AArrayOfSpecificFields;
  FArrayOfSpecificFields_Specified := True;
end;

function InventoryItem.ArrayOfSpecificFields_Specified(Index: Integer): boolean;
begin
  Result := FArrayOfSpecificFields_Specified;
end;

initialization
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
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_12', '12');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_13', '13');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(EtatEnum), '_15', '15');
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
  RemClassRegistry.RegisterExternalPropName(TypeInfo(MarketPlaceOrderStatusResponse), 'OrderId_', 'OrderId');
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
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_string), 'http://www.w3.org/2001/XMLSchema', 'Array_Of_string');
  RemClassRegistry.RegisterXSClass(InventoryItem, 'urn:NWS:examples', 'InventoryItem');

end.
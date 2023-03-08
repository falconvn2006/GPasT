unit StdEnums;

interface

type
  /// <summary>
  ///   Ginkoia ticket type. Link to CSHTICKET.TKE_TYPE field. Match enum in Cash sources file "GinkoiaDataModel.BusinessObject.StdEnums"
  /// </summary>
  TGinTicketType = (
    /// <summary>
    ///   Before LDF management ticket (=0)
    /// </summary>
    gttNone,
    /// <summary>
    ///   Old UI LDF ticket (=1)
    /// </summary>
    gttLDF = 1,
    /// <summary>
    ///   Old UI not LDF ticket (=2)
    /// </summary>
    gttNotLDF = 2,
    /// <summary>
    ///   Cash ticket (=3)
    /// </summary>
    gttCash = 3,
    /// <summary>
    ///   Cash global cashing update ticket (=5)
    /// </summary>
    gttUpdateGlobalCashing = 5,
    /// <summary>
    ///   Cash Apport (=6)
    /// </summary>
    gttRegulImput = 6,
    /// <summary>
    ///   Cash Prélèvement (=7)
    /// </summary>
    gttRegulTaking = 7,
    /// <summary>
    ///   Cash dépense (=8)
    /// </summary>
    gttExpense = 8,
    /// <summary>
    ///   Regularization of customer account (=9)
    /// </summary>
    gttRegulCustomerAccount = 9);

implementation

end.

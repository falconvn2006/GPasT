unit uGeneriqueType;

interface
uses Classes, uCommon_Type;

type
  // Permet de traiter les modes différements
  TMode = set of (mdArticle, mdStock, mdCde);

  TArticle = packed record
    sCBArticle, sDesignation, sRefMarqueFournisseur, sLibelleTaille, sLibelleCouleur, sNomMarque, sLibelleRayon, sLibelleFamille, sLibelleSousFamille: String;
    dPrixAchatHT, dPrixVenteTTC, dTauxTVA: Double;
    bValide: Boolean;
  end;

  TTabArticles = Array of TArticle;

  TLigneCDE = packed record
      TypeLigne    ,
      Code         ,
      CodeEAN      ,
      Designation  : String[64];
      LotId        : Integer;
      LotNum       : Integer;
      PUBrutHT     ,
      PUBrutTTC    ,
      PUHT         ,
      PUTTC        ,
      TxTVA        : Currency;
      Qte          : Integer;
      PXHT         ,
      PXTTC        : Currency;
      Fidelite     : Integer;
  end;

  TReglement = record
      Mode        : String;
      MontantTTC  : Currency;
      Date        : TDateTime;
      IdBonAchat  : Integer;
  end;

  TReglementsCDE = array of TReglement;

  TClientCde = packed Record
      Codeclient      : Integer;
      IdGinkoiaClient : Integer;
      Email           : String[64];
      Mailing         : Integer;
      Sms             : Integer;
      AdresseFact     : stUneAdresse;
      AdresseLivr     : stUneAdresse;
  end;

  TCde = packed record
    XmlFile : String;
    bValid : boolean;
    iIDGinkoia : integer;
    CommandeInfos : record
      CommandeNum   : String[32];
      CommandeId    : Integer;
      CommandeDate  : TDateTime;
      Statut        : String;
      ModeReglement : String[32];
      DateReglement : TDateTime;
      iExport       : Integer;
    end;
    Client : TClientCde;
    Colis : record
      Numero         ,
      CodeTransporteur,
      Transporteur   ,
      CodeProduit,
      MagasinRetrait ,
      CodeRelais     : String;
    end;
    Lignes : array of TLigneCDE;
    TVAS : array of record
      TotalHT    ,
      TauxTva    ,
      MtTVA      : Currency;
    end;

    Reglements : TReglementsCDE;

    SousTotalHT    ,
    FraisDePort    ,
    TotalHT        ,
    MontantTVA     ,
    TotalTTC       ,
    NetPayer       : Currency;
    InfosSupp  : String;    // information supplementaire mis dans le commentaire de la commande
  end;

implementation

end.

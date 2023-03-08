unit uGeneriqueType;

interface
uses Classes, uCommon_Type;

type
  // Permet de traiter les modes différements
  TMode = set of (mdArticle, mdStock, mdCde);

  TLigneCDE = packed record
      TypeLigne    ,
      Code         ,
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
  end;

  TClientCde = packed Record
      Codeclient    : Integer;
      Email         : String[64];
      AdresseFact   : stUneAdresse;
      AdresseLivr   : stUneAdresse;
  end;

  TCde = packed record
    XmlFile : String;
    bValid : boolean;
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
      Transporteur   ,
      MagasinRetrait : String;
    end;
    Lignes : array of TLigneCDE;
    TVAS : array of record
      TotalHT    ,
      TauxTva    ,
      MtTVA      : Currency;
    end;

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

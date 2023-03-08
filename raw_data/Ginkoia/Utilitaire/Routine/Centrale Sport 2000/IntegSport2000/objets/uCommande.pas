unit uCommande;

interface

uses Contnrs, uSynchroObjBDD;

type
  {$M+}
  TCommandeLigne = class(TMyObject)
  private
    FCdeID: Integer;
    FArtID: Integer;
    FTgfID: Integer;
    FCouID: Integer;
    FQte: Double;
    FPXCTLG: Double;
    FRemise1: Double;
    FRemise2: Double;
    FRemise3: Double;
    FPXAchat: Double;
    FTVA: Double;
    FPXVente: Double;
    FOFFSET: Integer;
    FLivraison: TDateTime;
    FTARTaille: Integer;
    FVALREMGLO: Double;
    FCentrale: Integer;
    FCOLID: Integer;
    FPoste: Integer;
    FNumEcheance: Integer;
    FComent: String;

  protected
    const
      TABLE_NAME = 'COMBCDEL';
      TABLE_TRIGRAM = 'CDL';
      TABLE_PK = 'CDL_ID';

  public
    constructor Create;

  published
    property CdeID: Integer read FCdeID write FCdeID;
    property ArtID: Integer read FArtID write FArtID;
    property TgfID: Integer read FTgfID write FTgfID;
    property CouID: Integer read FCouID write FCouID;
    property Qte: Double read FQte write FQte;
    property PXCTLG: Double read FPXCTLG write FPXCTLG;
    property Remise1: Double read FRemise1 write FRemise1;
    property Remise2: Double read FRemise2 write FRemise2;
    property Remise3: Double read FRemise3 write FRemise3;
    property PXAchat: Double read FPXAchat write FPXAchat;
    property TVA: Double read FTVA write FTVA;
    property PXVente: Double read FPXVente write FPXVente;
    property OFFSET: Integer read FOFFSET write FOFFSET;
    property Livraison: TDateTime read FLivraison write FLivraison;
    property TARTaille: Integer read FTARTaille write FTARTaille;
    property VALREMGLO: Double read FVALREMGLO write FVALREMGLO;
    property Centrale: Integer read FCentrale write FCentrale;
    property COLID: Integer read FCOLID write FCOLID;
    property Poste: Integer read FPoste write FPoste;
    property NumEcheance: Integer read FNumEcheance write FNumEcheance;
    property Coment: String read FComent write FComent;
  end;

  TCommande = class(TMyObject)
  private
    FNumero: String;
    FSaison: Integer;
    FEXEID: Integer;
    FCPAID: Integer;
    FMagID: Integer;
    FFouID: Integer;
    FNumFourn: String;
    FDate: TDateTime;
    FRemise: Double;
    FTVAHT1: Double;
    FTVATaux1: Double;
    FTVA1: Double;
    FTVAHT2: Double;
    FTVATaux2: Double;
    FTVA2: Double;
    FTVAHT3: Double;
    FTVATaux3: Double;
    FTVA3: Double;
    FTVAHT4: Double;
    FTVATaux4: Double;
    FTVA4: Double;
    FTVAHT5: Double;
    FTVATaux5: Double;
    FTVA5: Double;
    FFranco: Integer;
    FModif: Integer;
    FLivraison: TDateTime;
    FOFFSET: Integer;
    FREMGLO: Double;
    FArchive: Integer;
    FReglement: TDateTime;
    FTYPID: Integer;
    FNOTVA: Integer;
    FCentrale: Integer;
    FUSRID: Integer;
    FComent: String;
    FColID: Integer;
    FCloture: Integer;
    FType: String;
    FCDTID: Integer;
    FOrigine: Integer;
    FListeCommandeLignes: TObjectList;

  protected
    const
      TABLE_NAME = 'COMBCDE';
      TABLE_TRIGRAM = 'CDE';
      TABLE_PK = 'CDE_ID';

  public
    property _Type: String read FType write FType;
    property ListeCommandeLignes: TObjectList read FListeCommandeLignes write FListeCommandeLignes;

    constructor Create;
    destructor Destroy;   override;

  published
    property Numero: String read FNumero write FNumero;
    property Saison: Integer read FSaison write FSaison;
    property EXEID: Integer read FEXEID write FEXEID;
    property CPAID: Integer read FCPAID write FCPAID;
    property MagID: Integer read FMagID write FMagID;
    property FouID: Integer read FFouID write FFouID;
    property NumFourn: String read FNumFourn write FNumFourn;
    property Date: TDateTime read FDate write FDate;
    property Remise: Double read FRemise write FRemise;
    property TVAHT1: Double read FTVAHT1 write FTVAHT1;
    property TVATaux1: Double read FTVATaux1 write FTVATaux1;
    property TVA1: Double read FTVA1 write FTVA1;
    property TVAHT2: Double read FTVAHT2 write FTVAHT2;
    property TVATaux2: Double read FTVATaux2 write FTVATaux2;
    property TVA2: Double read FTVA2 write FTVA2;
    property TVAHT3: Double read FTVAHT3 write FTVAHT3;
    property TVATaux3: Double read FTVATaux3 write FTVATaux3;
    property TVA3: Double read FTVA3 write FTVA3;
    property TVAHT4: Double read FTVAHT4 write FTVAHT4;
    property TVATaux4: Double read FTVATaux4 write FTVATaux4;
    property TVA4: Double read FTVA4 write FTVA4;
    property TVAHT5: Double read FTVAHT5 write FTVAHT5;
    property TVATaux5: Double read FTVATaux5 write FTVATaux5;
    property TVA5: Double read FTVA5 write FTVA5;
    property Franco: Integer read FFranco write FFranco;
    property Modif: Integer read FModif write FModif;
    property Livraison: TDateTime read FLivraison write FLivraison;
    property OFFSET: Integer read FOFFSET write FOFFSET;
    property REMGLO: Double read FREMGLO write FREMGLO;
    property Archive: Integer read FArchive write FArchive;
    property Reglement: TDateTime read FReglement write FReglement;
    property TYPID: Integer read FTYPID write FTYPID;
    property NOTVA: Integer read FNOTVA write FNOTVA;
    property Centrale: Integer read FCentrale write FCentrale;
    property USRID: Integer read FUSRID write FUSRID;
    property Coment: String read FComent write FComent;
    property ColID: Integer read FColID write FColID;
    property Cloture: Integer read FCloture write FCloture;
    property CDTID: Integer read FCDTID write FCDTID;
    property Origine: Integer read FOrigine write FOrigine;
  end;
  {$M-}

implementation

{ TCommandeLigne }

constructor TCommandeLigne.Create;
begin
  inherited Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

{ TCommande }

constructor TCommande.Create;
begin
  inherited Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
  FListeCommandeLignes := TObjectList.Create;
end;

destructor TCommande.Destroy;
begin
  FListeCommandeLignes.Free;

  inherited;
end;

end.


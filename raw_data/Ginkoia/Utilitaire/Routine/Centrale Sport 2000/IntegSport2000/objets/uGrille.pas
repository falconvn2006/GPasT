unit uGrille;

interface

uses
  uSynchroObjBDD;

type
  {$M+}
  TGrille = class(TMyObject)
  private
    FCode: string;
    FCentrale: integer;
    FOrdreaff: double;
    FNom: string;
    FTgtid: integer;
    FImport: integer;
    FActive: integer;
    FIdref: integer;
  protected
    const
    TABLE_NAME='PLXGTF';
    TABLE_TRIGRAM='GTF';
    TABLE_PK='GTF_ID';
  public
    constructor create(); overload;
  published
    property Idref    : integer read FIdref    write FIdref    ;
    property Nom      : string  read FNom      write FNom      ;
    property Tgtid    : integer read FTgtid    write FTgtid    ;
    property Ordreaff : Double  read FOrdreaff write FOrdreaff ; 		
    property Import   : integer read FImport   write FImport   ; 	
    property Active   : integer read FActive   write FActive   ; 	
    property Code     : string  read FCode     write FCode     ;	
    property Centrale : integer read FCentrale write FCentrale ;
  end;
  {$M-}

implementation

{ TGrille }
constructor TGrille.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;


end.

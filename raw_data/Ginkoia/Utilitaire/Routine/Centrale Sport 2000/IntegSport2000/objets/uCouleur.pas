unit uCouleur;

interface

uses
  uSynchroObjBDD;

type
  {$M+}
  TCouleur = class(TMyObject)
  private
    FRA: integer;
    FPERM: integer;
    FCODE: string;
    FCENTRALE: integer;
    FTDSC: integer;
    FNOM: string;
    FARTID: integer;
    FTAC: integer;
    FGCSID: integer;
    FSMU: integer;
    FIDREF: integer;
  protected
    const
    TABLE_NAME='PLXCOULEUR';
    TABLE_TRIGRAM='COU';
    TABLE_PK='COU_ID';
  public
    constructor create(); overload;
  published
    property ARTID : integer read FARTID write FARTID;
    property IDREF : integer read FIDREF write FIDREF;
    property GCSID : integer read FGCSID write FGCSID;
    property CODE : string read FCODE write FCODE;
    property NOM : string read FNOM write FNOM;
    property SMU : integer read FSMU write FSMU;
    property TDSC : integer read FTDSC write FTDSC;
    property CENTRALE : integer read FCENTRALE write FCENTRALE;
    property TAC : integer read FTAC write FTAC;
    property PERM : integer read FPERM write FPERM;
    property RA : integer read FRA write FRA;
  end;


implementation

{ TCouleur }
constructor TCouleur.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

end.

unit uCodeBarre;

interface

uses uSynchroObjBDD, uGestionBDD;

type
  {$M+}
  TCodeBarre = class(TMyObject)
  private
    FARFID: Integer;
    FTGFID: Integer;
    FCOUID: Integer;
    FCB: String;
    FTYPE: Integer;
    FCLTID: Integer;
    FARLID: Integer;
    FLOC: Integer;
    FMATID: Integer;
    FPRIN: Integer;
    FTCFID: Integer;

  protected
    const
      TABLE_NAME = 'ARTCODEBARRE';
      TABLE_TRIGRAM = 'CBI';
      TABLE_PK = 'CBI_ID';

  public
    constructor Create;
    procedure doLoad(aQuery: TMyQuery; aDefault: Boolean = True);   override;

  published
    property ARFID: Integer read FARFID write FARFID;
    property TGFID: Integer read FTGFID write FTGFID;
    property COUID: Integer read FCOUID write FCOUID;
    property CB: String read FCB write FCB;
    property TYPECB: Integer read FTYPE write FTYPE;
    property CLTID: Integer read FCLTID write FCLTID;
    property ARLID: Integer read FARLID write FARLID;
    property LOC: Integer read FLOC write FLOC;
    property MATID: Integer read FMATID write FMATID;
    property PRIN: Integer read FPRIN write FPRIN;
    property TCFID: Integer read FTCFID write FTCFID;
  end;
  {$M-}

implementation

{ TCodeBarre }

constructor TCodeBarre.Create;
begin
  inherited Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

procedure TCodeBarre.doLoad(aQuery: TMyQuery; aDefault: Boolean);
begin
  inherited;
  if(aQuery.Active) and (not aQuery.IsEmpty) then
    FTYPE := aQuery.FieldByName('CBI_TYPE').AsInteger;
end;

end.


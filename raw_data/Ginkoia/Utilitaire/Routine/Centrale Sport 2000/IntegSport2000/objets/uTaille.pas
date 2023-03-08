unit uTaille;

interface

uses Classes, SysUtils, uSynchroObjBDD;

type
  {$M+}
  TTaille = class(TMyObject)
  private
    FCorres: string;
    FTgfid: integer;
    FGtfid: integer;
    FCode: string;
    FColumnx: string;
    FCentrale: integer;
    FOrdreaff: double;
    FNom: string;
    FTgsid: integer;
    FActive: integer;
    FStat: integer;
    FIdref: integer;

  protected
    const
      TABLE_NAME = 'PLXTAILLESGF';
      TABLE_TRIGRAM = 'TGF';
      TABLE_PK = 'TGF_ID';

  public
    constructor Create;   overload;
    procedure Assign(Source: TPersistent);   override;

  published
    property Gtfid    : integer read FGtfid    write FGtfid   ;
    property Idref    : integer read FIdref    write FIdref   ;
    property Tgfid    : integer read FTgfid    write FTgfid   ;
    property Nom      : string  read FNom      write FNom     ;
    property Corres   : string  read FCorres   write FCorres  ;
    property Ordreaff : Double  read FOrdreaff write FOrdreaff;
    property Stat     : integer read FStat     write FStat    ;
    property Tgsid    : integer read FTgsid    write FTgsid   ;
    property Active   : integer read FActive   write FActive  ;
    property Code     : string  read FCode     write FCode    ;
    property Columnx  : string  read FColumnx  write FColumnx ;
    property Centrale : integer read FCentrale write FCentrale;
  end;
  {$M-}

implementation

{ TTaille }

constructor TTaille.Create;
begin
   inherited Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

procedure TTaille.Assign(Source: TPersistent);
begin
  if Assigned(Source) and Source.InheritsFrom(TTaille) then
  begin
    inherited;
    FCorres := TTaille(Source).FCorres;
    FTgfid := TTaille(Source).FTgfid;
    FGtfid := TTaille(Source).FGtfid;
    FCode := TTaille(Source).FCode;
    FColumnx := TTaille(Source).FColumnx;
    FCentrale := TTaille(Source).FCentrale;
    FOrdreaff := TTaille(Source).FOrdreaff;
    FNom := TTaille(Source).FNom;
    FTgsid := TTaille(Source).FTgsid;
    FActive := TTaille(Source).FActive;
    FStat := TTaille(Source).FStat;
    FIdref := TTaille(Source).FIdref;
  end
  else
    raise Exception.Create('Erreur :  l''objet source n''est pas un TTaille !');
end;

end.


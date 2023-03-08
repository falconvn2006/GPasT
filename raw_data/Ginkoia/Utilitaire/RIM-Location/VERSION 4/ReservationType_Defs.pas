unit ReservationType_Defs;

interface
  uses Contnrs, SysUtils;

  type TCFGMAIL = record
    PBT_ADRPRINC  ,
    PBT_ADRARCH   ,
    PBT_PASSW     ,
    PBT_SERVEUR   : String;
    PBT_PORT      : integer;
    PBT_MTYID     : integer;
    PBT_ARCHIVAGE : integer;
    PBT_SMTP      : String;
    PBT_PORTSMTP  : Integer;
  end;


  type TGENTYPEMAIL = Class(TObject)
    MTY_ID       : Integer;
    MTY_NOM      : String;
    MTY_CLTIDPRO : integer;
    MTY_MULTI    : integer;
    MTY_CODE     : String;
  End;

  type TListGENTYPEMAIL = class(TObjectList)
    private
      procedure SetItem (Index : integer; Value : TGENTYPEMAIL);
      function  GetItem (Index : Integer) : TGENTYPEMAIL;
    public
      function Add(AObject : TGENTYPEMAIL) : integer;
      procedure Insert(Index : integer; AObject : TGENTYPEMAIL);
      property Items[Index : Integer] : TGENTYPEMAIL read GetItem Write SetItem; default;
  end;

  function GenerateFilename(sLabel : String) : String;

  var
    GPATHMAILTMP : String;

implementation

{ TListGENTYPEMAIL }

function TListGENTYPEMAIL.Add(AObject: TGENTYPEMAIL): integer;
begin
  Result := inherited Add(AObject);
end;

function TListGENTYPEMAIL.GetItem(Index: Integer): TGENTYPEMAIL;
begin
  Result := TGENTYPEMAIL(inherited GetItem(Index));
end;

procedure TListGENTYPEMAIL.Insert(Index: integer; AObject: TGENTYPEMAIL);
begin
  inherited Insert(index, AObject);
end;

procedure TListGENTYPEMAIL.SetItem(Index: integer; Value: TGENTYPEMAIL);
begin
  inherited SetItem(Index,Value);
end;

function GenerateFilename(sLabel : String) : String;
begin
  Result := sLabel + '-' + FormatDateTime('YYYYMMDDhhmmsszzz_',Now);
end;


end.

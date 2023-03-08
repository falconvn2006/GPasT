unit uGrilleTaillesSP2K;

interface

uses SysUtils, Contnrs, uTaille;

type
  TGrilleTaillesSP2K = class
    private
      FGtfID: Integer;
      FListeTailles: TObjectList;

    public
      property GtfID: Integer read FGtfID write FGtfID;
      property ListeTailles: TObjectList read FListeTailles write FListeTailles;

      constructor Create;
      destructor Destroy;   override;
  end;

  TListeGrillesTaillesSP2K = class(TObjectList)
    public
      function Add(GrilleTaillesSP2K: TGrilleTaillesSP2K): Integer;
      procedure GetGrilleTaillesSP2K(const nGtfID: Integer; ListeTailles: TObjectList);
  end;

implementation

{ TGrilleTaillesSP2K }

constructor TGrilleTaillesSP2K.Create;
begin
  FListeTailles := TObjectList.Create;
end;

destructor TGrilleTaillesSP2K.Destroy;
begin
  FListeTailles.Free;

  inherited;
end;

{ TListeGrillesTaillesSP2K }

function TListeGrillesTaillesSP2K.Add(GrilleTaillesSP2K: TGrilleTaillesSP2K): Integer;
begin
  if not Assigned(GrilleTaillesSP2K) then
    raise Exception.Create('Erreur :  pas de TGrilleTaillesSP2K !');

  Result := inherited Add(GrilleTaillesSP2K);
end;

procedure TListeGrillesTaillesSP2K.GetGrilleTaillesSP2K(const nGtfID: Integer; ListeTailles: TObjectList);
var
  i, j: Integer;
  Taille: TTaille;
begin
  ListeTailles.Clear;
  for i:=0 to Pred(Count) do
  begin
    if(Items[i] is TGrilleTaillesSP2K) and (TGrilleTaillesSP2K(Items[i]).FGtfID = nGtfID) then
    begin
      for j:=0 to Pred(TGrilleTaillesSP2K(Items[i]).ListeTailles.Count) do
      begin
        if(TGrilleTaillesSP2K(Items[i]).ListeTailles[j] is TTaille) then
        begin
          Taille := TTaille.Create;
          Taille.Assign(TTaille(TGrilleTaillesSP2K(Items[i]).ListeTailles[j]));
          ListeTailles.Add(Taille);
        end;
      end;

      Break;
    end;
  end;
end;

end.


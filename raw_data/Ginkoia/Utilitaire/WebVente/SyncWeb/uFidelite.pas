unit uFidelite;

interface

uses SysUtils, IBODataset, IB_Components, UCommon_Dm;

type
  TTypeFidelite = (tfAucune, tfTypeA, tfTypeB, tfTypeC);

  TParamFidelite = record
    nNombrePassages, nDureeValiditePassages, nPeriodeCarte, nNombrePoints, nDureeValiditePoints, nDureeValiditeBonAchat: Integer;
    dPourcentRemiseIgnoree: Double;
  end;

  TFideliteClient = class
    private
      FQuery: TIBOQuery;
      FMagID: Integer;
      FTypeFidelite: TTypeFidelite;
      FTailleTranche: Single;
      FNbPointsTranche: Integer;
      FParamFidelite: TParamFidelite;

      function FidUtilMag: Boolean;
      function CalculNbPoints(const dMontant: Double): Integer;

    public
      property ParamFidelite: TParamFidelite read FParamFidelite;

      constructor Create(Transaction: TIB_Transaction; const nMagID, nTypeFidelite: Integer);
      function Fidelite(const dMontant: Double; out nNbPointsAjoutes: Integer): Boolean;
      destructor Destroy;   override;
  end;

implementation

{ TFideliteClient }

constructor TFideliteClient.Create(Transaction: TIB_Transaction; const nMagID, nTypeFidelite: Integer);
begin
  FMagID := nMagID;
  FTypeFidelite := TTypeFidelite(nTypeFidelite);
  FTailleTranche := 0;
  FNbPointsTranche := 0;
  FParamFidelite.nNombrePassages := -1;
  FParamFidelite.nDureeValiditePassages := -1;
  FParamFidelite.nPeriodeCarte := -1;
  FParamFidelite.nNombrePoints := -1;
  FParamFidelite.nDureeValiditePoints := -1;
  FParamFidelite.nDureeValiditeBonAchat := -1;
  FParamFidelite.dPourcentRemiseIgnoree := -1;

  FQuery := TIBOQuery.Create(nil);
  FQuery.IB_Connection := Dm_Common.Ginkoia;
  FQuery.IB_Transaction := Transaction;

  FidUtilMag;
end;

function TFideliteClient.FidUtilMag: Boolean;
begin
  Result := False;

  // Recherche paramètres.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select CTF_ID, CTF_GCFID, CTF_TYP1, CTF_TYP1NBTCK, CTF_TYP1DUREE, CTF_TYP2, CTF_TYP2PERIODE,');
  FQuery.SQL.Add('CTF_TYP3, CTF_TYP3NBPOINT, CTF_TYP3DUREE, CTF_REMISEMAX, CTF_TRANCHEPRIX, CTF_TRANCHEPOINTS,');
  FQuery.SQL.Add('CTF_VALIDITEBA, CTF_NBREPOINTPRECEDENT, CTF_MONTANTPRISENCOMPTE, CTF_NBREPOINTTOTAL,');
  FQuery.SQL.Add('CTF_NBREPOINTTCK, CTF_MONTANTBA, CTF_DATEDEB, CTF_DATEFIN, CTF_TEXTELIBRE, CTF_NOMCLIENT, CTF_TEXTEBA');
  FQuery.SQL.Add('from CSHPARAMCF');
  FQuery.SQL.Add('join K on (K_ID = CTF_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('join GENGESTIONCARTEFID on (GCF_ID = CTF_GCFID)');
  FQuery.SQL.Add('join K on (K_ID = GCF_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('join GENMAGGESTIONCF on (MCF_GCFID = GCF_ID)');
  FQuery.SQL.Add('join K on (K_ID = MCF_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where MCF_MAGID = :MAGID');
  try
    FQuery.ParamByName('MAGID').AsInteger := FMagID;
    FQuery.Open;
  except
    on E: Exception do
      raise Exception.Create('TFideliteClient.FidUtilMag -> ' + E.Message);
  end;
  if not FQuery.IsEmpty then
  begin
    case FTypeFidelite of
      tfAucune:
        Result := False;
      tfTypeA:
        Result := (FQuery.FieldByName('CTF_TYP1').AsInteger = 1);
      tfTypeB:
        Result := (FQuery.FieldByName('CTF_TYP2').AsInteger = 1);
      tfTypeC:
        Result := (FQuery.FieldByName('CTF_TYP3').AsInteger = 1);
    end;
    FTailleTranche := FQuery.FieldByName('CTF_TRANCHEPRIX').AsFloat;
    FNbPointsTranche := FQuery.FieldByName('CTF_TRANCHEPOINTS').AsInteger;

    // Paramètres de fonctionnement de la fidélité.
    FParamFidelite.nNombrePassages := FQuery.FieldByName('CTF_TYP1NBTCK').AsInteger;
    FParamFidelite.nDureeValiditePassages := FQuery.FieldByName('CTF_TYP1DUREE').AsInteger;
    FParamFidelite.nPeriodeCarte := FQuery.FieldByName('CTF_TYP2PERIODE').AsInteger;
    FParamFidelite.nNombrePoints := FQuery.FieldByName('CTF_TYP3NBPOINT').AsInteger;
    FParamFidelite.nDureeValiditePoints := FQuery.FieldByName('CTF_TYP3DUREE').AsInteger;
    FParamFidelite.nDureeValiditeBonAchat := FQuery.FieldByName('CTF_VALIDITEBA').AsInteger;
    FParamFidelite.dPourcentRemiseIgnoree := FQuery.FieldByName('CTF_REMISEMAX').AsFloat;
    FQuery.Close;
  end;
end;

function TFideliteClient.Fidelite(const dMontant: Double; out nNbPointsAjoutes: Integer): Boolean;
begin
  Result := False;

  // Si application de la fidélité.
  if FidUtilMag and (FTailleTranche <> 0) then
  begin
    nNbPointsAjoutes := CalculNbPoints(dMontant);
    Result := True;
  end;
end;

function TFideliteClient.CalculNbPoints(const dMontant: Double): Integer;
var
  nNbTranches: Integer;
begin
  // Calcul du nombre de tranches.
  try
    nNbTranches := Trunc(dMontant / FTailleTranche);
  except
    on E: Exception do
      raise Exception.Create('TFideliteClient.CalculNbPoints -> Division par zéro !');
  end;

  // Nombre de points.
  Result := (nNbTranches * FNbPointsTranche);
end;

destructor TFideliteClient.Destroy;
begin
  FQuery.Free;

  inherited;
end;

end.


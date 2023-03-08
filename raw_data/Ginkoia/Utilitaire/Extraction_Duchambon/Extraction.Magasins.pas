unit Extraction.Magasins;

interface

uses
  System.Classes, System.SysUtils,
  FireDAC.Comp.Client;

// Liste des magasins d'une base
function ListeMagasins(const ACheminBase: String; out AListe: TStringList): Boolean;

implementation

// Liste des magasins d'une base
function ListeMagasins(const ACheminBase: String; out AListe: TStringList): Boolean;
var
  FDConnection        : TFDConnection;
  QueListeMagasins    : TFDQuery;
begin
  Result := False;

  FDConnection        := TFDConnection.Create(nil);
  QueListeMagasins    := TFDQuery.Create(nil);
  try
    // Paramétre la connexion à la base de données
    FDConnection.Params.Clear();
    FDConnection.Params.Add('DriverID=IB');
    FDConnection.Params.Add('User_Name=ginkoia');
    FDConnection.Params.Add('Password=ginkoia');
    FDConnection.Params.Add(Format('Database=%s', [ACheminBase]));

    QueListeMagasins.Connection := FDConnection;
    QueListeMagasins.SQL.Clear();
    QueListeMagasins.SQL.Add('SELECT MAG_ID, MAG_NOM');
    QueListeMagasins.SQL.Add('FROM GENMAGASIN');
    QueListeMagasins.SQL.Add('  JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1 AND K_ID != 0);');
    try
      QueListeMagasins.Open();

      Result := (QueListeMagasins.RecordCount > 0);

      while not(QueListeMagasins.Eof) do
      begin
        AListe.Add(Format('%d=%s', [QueListeMagasins.FieldByName('MAG_ID').AsInteger, QueListeMagasins.FieldByName('MAG_NOM').AsString]));
        QueListeMagasins.Next();
      end;

    except
      Result := False;
    end;

    QueListeMagasins.Close();
  finally
    QueListeMagasins.Free();
    FDConnection.Free();
  end
end;

end.

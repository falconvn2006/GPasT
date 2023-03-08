unit DatasetUtils;

interface

uses
  DB,
  DBClient,
  Classes;

function DataSetToCSVStrings(Data : TDataSet; Entete : boolean = true; Quoted : boolean = false; Separator : char = ';') : TStringList;
procedure CopyDataSet(Sources : TDataSet; Destination : TClientDataSet; CopyEntete : boolean = false);

implementation

function DataSetToCSVStrings(Data : TDataSet; Entete : boolean; Quoted : boolean; Separator : char) : TStringList;
var
  i : integer;
  Ligne : string;
  Quote : string;
  bmk : TBookmark;
begin
  Result := TStringList.Create();
  // Quoted ??
  if Quoted then
    Quote := '"'
  else
    quote := '';
  // export de l'entete
  if Entete then
  begin
    Ligne := '';
    for i := 0 to Data.Fields.Count -1 do
    begin
      if Ligne = '' then
        Ligne := Quote + Data.Fields[i].FieldName + Quote
      else
        Ligne := Ligne + Separator + Quote + Data.Fields[i].FieldName + Quote;
    end;
    Result.Add(Ligne);
  end;
  try
    // sauvegarde de pos + inhibition
    bmk := Data.GetBookmark();
    Data.DisableControls();
    // export des données
    Data.First();
    while not Data.Eof do
    begin
      Ligne := '';
      for i := 0 to Data.Fields.Count -1 do
      begin
        if Ligne = '' then
          Ligne := Quote + Data.Fields[i].AsString + Quote
        else
          Ligne := Quote + Ligne + Separator + Data.Fields[i].AsString + Quote;
      end;
      Result.Add(Ligne);
      Data.Next();
    end;
  finally
    // Retour pos + desinhibition
    Data.GotoBookmark(bmk);
    Data.FreeBookmark(bmk);
    Data.EnableControls();
  end;
end;

procedure CopyDataSet(Sources : TDataSet; Destination : TClientDataSet; CopyEntete : boolean);
var
  i : Integer;
begin
  // vidage
  if Destination.Active then
  begin
    Destination.EmptyDataSet();
    Destination.Close();
  end;
  // entete ??
  if CopyEntete then
    Destination.FieldDefs.Assign(Sources.FieldDefs);
  // creation
  Destination.CreateDataSet();
  Destination.Open();
  // valeurs
  try
    Destination.DisableControls();
    Sources.First();
    while not Sources.Eof do
    begin
      Destination.Append();
      for i := 0 to Sources.FieldCount -1 do
        Destination.FieldByName(Sources.Fields[i].FieldName).Value := Sources.Fields[i].Value;
      Destination.Post();
      Sources.Next();
    end;
  finally
    Destination.EnableControls();
  end;
end;

end.

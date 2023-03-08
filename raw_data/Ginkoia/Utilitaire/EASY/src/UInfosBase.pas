unit UInfosBase;

interface

function CanConnect(Server, FileName, UserName, Password : string; Port : integer; out error :string) : boolean;
function GetInfosBase(Server, FileName, UserName, Password : string; Port : integer; out Version, Nom, GUID, Sender : string; out DateVersion : TDateTime; out Generateur : integer; out Recalcul : boolean; out error :string) : boolean;

implementation

uses
  Vcl.Dialogs,
  System.SysUtils,
  FireDAC.Comp.Client,
  uGestionBDD;

function CanConnect(Server, FileName, UserName, Password : string; Port : integer; out error :string) : boolean;
var
  Connexion : TMyConnection;
begin
  Result := false;
  error := '';

  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
        Result := true;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      error := e.ClassName + ' - ' + e.Message;
      Result := false;
    end;
  end;
end;

function GetInfosBase(Server, FileName, UserName, Password : string; Port : integer; out Version, Nom, GUID, Sender : string; out DateVersion : TDateTime; out Generateur : integer; out Recalcul : boolean; out error :string) : boolean;
var
  Connexion : TMyConnection;
  Query : TMyQuery;
begin
  Result := false;
  Version := '';
  Nom := '';
  GUID := '';
  DateVersion := 0;
  Generateur := -1;
  Recalcul := false;
  error := '';

  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          // requete
          Query := GetNewQuery(Connexion);

          // existance des tables ?
          try
            Query.SQL.Text := 'select rdb$relation_name from rdb$relations where upper(rdb$relation_name) in (''GENVERSION'', ''GENBASES'', ''K'', ''GENPARAMBASE'', ''GENTRIGGER'', ''GENTRIGGERDIFF'');';
            Query.Open();
            if Query.Eof then
              Exit
            else if not (Query.RecordCount in [5, 6]) then
              Exit;
          finally
            Query.Close();
          end;

          // Recup de la version
          try
            Query.SQL.Text := 'select ver_version, ver_date from genversion order by ver_date desc rows 1;';
            Query.Open();
            if Query.Eof then
              Exit
            else
            begin
              Version := Trim(Query.FieldByName('ver_version').AsString);
              DateVersion := Query.FieldByName('ver_date').AsDateTime;
            end;
          finally
            Query.Close();
          end;

          // recup du nom
          try
            Query.SQL.Text := 'select bas_nompournous, count(*) as nb from genbases join k on k_id = bas_id and k_enabled = 1 where bas_id != 0 group by bas_nompournous order by 2 desc rows 1;';
            Query.Open();
            if Query.Eof then
              Exit
            else
              Nom := Trim(Query.FieldByName('bas_nompournous').AsString);
          finally
            Query.Close();
          end;

          // recup du generateur
          try
            Query.SQL.Text := 'select par_string from genparambase where par_nom = ''IDGENERATEUR'';';
            Query.Open();
            if Query.Eof then
              Exit
            else
              Generateur := Query.FieldByName('par_string').AsInteger;
          finally
            Query.Close();
          end;

          // recup du recalcul...
          try
            if Version < '12' then
              Query.SQL.Text := 'select count(*) as nb from gentrigger;'
            else
              Query.SQL.Text := 'select count(*) as nb from gentriggerdiff;';
            Query.Open();
            if Query.Eof then
              Exit
            else
              Recalcul := Query.FieldByName('nb').AsInteger > 1;
          finally
            Query.Close();
          end;

          // redcup du GUID
          Query.SQL.Text := 'select bas_guid, bas_sender from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ' + QuotedStr(IntToStr(Generateur)) + ';';
          Query.Open();
          if not Query.Eof then
          begin
            GUID := Query.FieldByName('bas_guid').AsString;
            Sender := Query.FieldByName('bas_sender').AsString;
          end;
          Query.Close();
        finally
          FreeAndNil(Query);
        end;
        Result := true;
      end;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      error := e.ClassName + ' - ' + e.Message;
      Result := false;
    end;
  end;
end;

end.

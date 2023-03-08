unit UPatchXE7;

interface

uses
  System.Classes,
  FireDAC.Comp.Client;

function DoPatch(Connexion : TFDConnection; Transaction : TFDTransaction; FileName : string; Separateur : string; out LastSep : string; Logs : TStringList = nil) : boolean;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.RegularExpressions,
  uGestionBDD;

function DoPatch(Connexion : TFDConnection; Transaction : TFDTransaction; FileName : string; Separateur : string; out LastSep : string; Logs : TStringList) : boolean;

  function RemoveCommentaire(Text : string) : string;
  var
    posDeb, posFin : integer;
  begin
    Result := Text;

    posDeb := Pos('/*', Result);
    posFin := Pos('*/', Result);

    while posDeb > 0 do
    begin
      // suppression
      Delete(Result, posDeb, posFin - posDeb +2);
      // commentaire suivant ...
      posDeb := Pos('/*', Result);
      posFin := Pos('*/', Result);
    end;
  end;

  function GetSQLName(Text : string) : string;
  begin
    if (Text[1] = '"') and (Text[Length(Text)] = '"') then
      Result := Text.DeQuotedString('"')
    else
      Result := UpperCase(Text);
  end;

  function VerifExistance(Connexion : TFDConnection; Transaction : TFDTransaction; table, champ, valeur : string) : boolean;
  var
    QVerif : TFDQuery;
  begin
    Result := false;
    try
      QVerif := GetNewQuery(Connexion, Transaction);
      try
        Transaction.StartTransaction();
        QVerif.SQL.Text := 'select ' + champ + ' from ' + table + ' where ' + champ + ' = ' + QuotedStr(valeur);
        QVerif.Open();
        Result := not QVerif.Eof;
        Transaction.Commit();
      except
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(QVerif);
    end;
  end;

  function GetRelatedTable(Connexion : TFDConnection; Transaction : TFDTransaction; table, champselect, champwhere, valeur : string) : string;
  var
    QVerif : TFDQuery;
  begin
    Result := '';
    try
      QVerif := GetNewQuery(Connexion, Transaction);
      try
        Transaction.StartTransaction();
        QVerif.SQL.Text := 'select ' + champselect + ' from ' + table + ' where ' + champwhere + ' = ' + QuotedStr(valeur);
        QVerif.Open();
        if not QVerif.Eof then
          Result := QVerif.Fields[0].AsString;
        Transaction.Commit();
      except
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(QVerif);
    end;
  end;

  function DoRequeteCorrect(Connexion : TFDConnection; Transaction : TFDTransaction; Text : string; var Output : string) : boolean;
  var
    Query : TFDQuery;
    RegExpRes : TMatchCollection;
    tmpText, Instruction, ItemType, ItemName, ItemVerif, TableName : string;
    tmpSQLBefor, tmpSQLAfter : TStringList;
    Exists, DoDisconnect : boolean;
    i : integer;
  begin
    try
      tmpSQLBefor := TStringList.Create();
      tmpSQLAfter := TStringList.Create();

      Result := false;
      Output := '';
      DoDisconnect := false;

      tmpText := RemoveCommentaire(Text);
      RegExpRes := TRegEx.Matches(tmpText, '(?P<Instruction>'
                                             + '(?:create)|'
                                             + '(?:alter)|'
                                             + '(?:drop)'
                                         + ')(?:\s+(?P<Options>'
                                             + '(?:global temporary)'
                                             + '(?:unique)'
                                         + '))?\s+(?P<ItemType>'
                                             + '(?:generator)|'
                                             + '(?:trigger)|'
                                             + '(?:index)|'
                                             + '(?:procedure)|'
                                             + '(?:table)'
                                         + ')\s+(?P<ItemName>(?:\"(?:(?:[^"]|"\".)*)\")|(?:\w+))', [TRegExOption.roCompiled, TRegExOption.roIgnoreCase]);
      if RegExpRes.Count > 0 then
      begin
        Instruction := UpperCase(Trim(RegExpRes[0].Groups['Instruction'].Value));
        ItemType := UpperCase(Trim(RegExpRes[0].Groups['ItemType'].Value));
        ItemName := RegExpRes[0].Groups['ItemName'].Value;
        ItemVerif := GetSQLName(ItemName);

        case AnsiIndexText(ItemType, ['GENERATOR', 'TRIGGER', 'INDEX', 'PROCEDURE', 'TABLE']) of
          0 : // Generateur
            begin
              Exists := VerifExistance(Connexion, Transaction, 'rdb$generators', 'rdb$generator_name', ItemVerif);
              if (Instruction = 'CREATE') and Exists then
              begin
                Output := 'Generateur existant : create ' + ItemName + ' ignoré !';
                Exit(true);
              end
              else if (Instruction = 'DROP') and not Exists then
              begin
                Output := 'Generateur inexistant : drop ' + ItemName + ' ignoré !';
                Exit(true);
              end;
            end;
          1 : // Trigger
            begin
              Exists := VerifExistance(Connexion, Transaction, 'rdb$triggers', 'rdb$trigger_name', ItemVerif);
              TableName := GetRelatedTable(Connexion, Transaction, 'rdb$triggers', 'rdb$relation_name', 'rdb$trigger_name', ItemVerif);
              if (Instruction = 'CREATE') and Exists then
              begin
                Output := 'trigger existant : ' + ItemName + ' tentative d''alter';
                Text := StringReplace(Text, 'CREATE TRIGGER ' + ItemName + ' FOR ' + TableName, 'ALTER TRIGGER ' + ItemName, [rfIgnoreCase]);
              end
              else if (Instruction = 'ALTER') and not Exists then
              begin
                Output := 'trigger inexistant : ' + ItemName + ' tentative de create';
                Text := StringReplace(Text, 'ALTER TRIGGER ' + ItemName, 'CREATE TRIGGER ' + ItemName + 'FOR ' + TableName, [rfIgnoreCase]);
              end
              else if (Instruction = 'DROP') and not Exists then
              begin
                Output := 'Trigger inexistant : drop ' + ItemName + ' ignoré !';
                Exit(true);
              end;
            end;
          2 : // Index
            begin
              Exists := VerifExistance(Connexion, Transaction, 'rdb$indices', 'rdb$index_name', ItemVerif);
              if (Instruction = 'CREATE') and Exists then
              begin
                Output := 'Index existant : create ' + ItemName + ' ignoré !';
                Exit(true);
              end
              else if (Instruction = 'DROP') and not Exists then
              begin
                Output := 'Index inexistant : drop ' + ItemName + ' ignoré !';
                Exit(true);
              end;
              DoDisconnect := true;
            end;
          3 : // procedure
            begin
              Exists := VerifExistance(Connexion, Transaction, 'rdb$procedures', 'rdb$procedure_name', ItemVerif);
              if (Instruction = 'CREATE') and Exists then
              begin
                Output := 'procedure existante : ' + ItemName + ' tentative d''alter';
                Text := StringReplace(Text, 'CREATE PROCEDURE ', 'ALTER PROCEDURE ', [rfIgnoreCase]);
              end
              else if (Instruction = 'ALTER') and not Exists then
              begin
                Output := 'procedure inexistante : ' + ItemName + ' tentative de create';
                Text := StringReplace(Text, 'ALTER PROCEDURE ', 'CREATE PROCEDURE ', [rfIgnoreCase]);
              end
              else if (Instruction = 'DROP') and not Exists then
              begin
                Output := 'Procedure inexistante : drop ' + ItemName + ' ignoré !';
                Exit(true);
              end;
            end;
          4 : // table
            begin
              Exists := VerifExistance(Connexion, Transaction, 'rdb$relations', 'rdb$relation_name', ItemVerif);
              if (Instruction = 'CREATE') and Exists then
              begin
                Output := 'table existante : create table ' + ItemName + ' ignoré !';
                Exit(true);
              end;
            end;
        end;

        // a ajouter ?
        if (Instruction = 'CREATE') and (ItemType = 'TABLE') then
        begin
          tmpSQLAfter.Add('GRANT ALL ON ' + ItemName + ' TO GINKOIA;');
          tmpSQLAfter.Add('GRANT ALL ON ' + ItemName + ' TO REPL;');
        end
        else if (Instruction = 'CREATE') and (ItemType = 'PROCEDURE') then
        begin
          tmpSQLAfter.Add('GRANT EXECUTE ON PROCEDURE ' + ItemName + ' TO GINKOIA;');
          tmpSQLAfter.Add('GRANT EXECUTE ON PROCEDURE ' + ItemName + ' TO REPL;');
        end
        else if ((Instruction = 'DROP') or (Instruction = 'ALTER')) and (ItemType = 'TABLE') and
                VerifExistance(Connexion, Transaction, 'rdb$procedures', 'rdb$procedure_name', 'INS_' + ItemVerif) then
          tmpSQLBefor.Add('DROP PROCEDURE ' + ('INS_' + ItemName).QuotedString('"') + ';');
      end
      // gestion des :
      //  - COMMIT
      //  - DECONNECT
      //  - INSERT2
      else if (UpperCase(Copy(Trim(tmpText), 1, 6)) = 'COMMIT') then
      begin
        Text := '';
        Result := true;
      end
      else if (UpperCase(Copy(Trim(tmpText), 1, 9)) = 'DECONNECT') then
      begin
        Text := '';
        DoDisconnect := true;
        Result := true;
      end
      else if (UpperCase(Copy(Trim(tmpText), 1, 8)) = 'INSERT2 ') then
      begin
        // ?????
        Text := '';
        Result := false;
      end;

      // il reste une requete a faire ?
      if not (Trim(Text) = '') then
      begin
        try
          Query := GetNewQuery(Connexion, Transaction);

          // execution de la requete !
          try
            Transaction.StartTransaction();

            // a faire avant ??
            for i := 0 to tmpSQLBefor.Count -1 do
            begin
              Query.SQL.Text := tmpSQLBefor[i];
              Query.ExecSQL();
            end;
            // requete !!!
            Query.SQL.Text := Text;
            if UpperCase(Copy(Query.SQL[0], 1, 6)) = 'SELECT' then
            begin
              Query.Open();
              Query.FetchAll();
              Query.Close();
            end
            else
              Query.ExecSQL();
            // a faire apres ??
            for i := 0 to tmpSQLAfter.Count -1 do
            begin
              Query.SQL.Text := tmpSQLAfter[i];
              Query.ExecSQL();
            end;
            Transaction.Commit();
          except
            on e : Exception do
            begin
              Transaction.Rollback();
              Output := e.ClassName + ' - ' + e.Message;
              Exit;
            end;
          end;
          // arrivé ici ???
          // tout vas bien !!!!
          Result := true;
        finally
          FreeAndNil(Query);
        end;
      end;

      // Deconnexion ?
      if DoDisconnect then
      begin
        Connexion.Close();
        Sleep(1000);
        Connexion.Open();
      end;
    finally
      FreeAndNil(tmpSQLBefor);
      FreeAndNil(tmpSQLAfter);
    end;
  end;

var
  PatchLines, QueryLines : TStringList;
  scriptName, tmpSep, Output : string;
  IdxRequete : integer;
begin
  Result := true;
  IdxRequete := 0;
  tmpSep := '';
  LastSep := '';

  PatchLines := TStringList.Create();
  QueryLines := TStringList.Create();
  try
    scriptName := ExtractFileName(FileName);
    PatchLines.LoadFromFile(FileName);

    while (PatchLines.Count > 0) do
    begin
      QueryLines.Clear();
      while (PatchLines.Count > 0) do
      begin
        if (Copy(Trim(PatchLines[0]), 1, Length(Separateur)) = Separateur) then
        begin
          tmpSep := Trim(PatchLines[0]);
          PatchLines.Delete(0);
          Break;
        end
        else
        begin
          QueryLines.Add(PatchLines[0]);
          PatchLines.Delete(0);
        end;
      end;

      Inc(IdxRequete);
      if not DoRequeteCorrect(Connexion, Transaction, QueryLines.Text, Output) then
      begin
        if Assigned(Logs) then
        begin
          Logs.Add('Fichier "' + FileName + '" requete n°' + IntToStr(IdxRequete) + ' : Erreur : ' + Output + '.');
          Logs.Add('');
          Logs.Add('==========');
          Logs.Add('Requete : ');
          Logs.AddStrings(QueryLines);
          Logs.Add('==========');
          Logs.Add('');
        end;
        Result := false;
        Exit;
      end
      else if not (Trim(Output) = '') then
      begin
        if Assigned(Logs) then
          Logs.Add('Fichier "' + FileName + '" requete n°' + IntToStr(IdxRequete) + ' : Avertissement : ' + Output + '.');
      end
      else
      begin
        if Assigned(Logs) then
          Logs.Add('Fichier "' + FileName + '" requete n°' + IntToStr(IdxRequete) + ' : Execution OK.');
      end;
      LastSep := tmpSep;
    end;
  finally
    FreeAndNil(QueryLines);
    FreeAndNil(PatchLines);
  end;
end;

end.

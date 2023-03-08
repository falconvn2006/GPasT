//$Log:
// 2    Utilitaires1.1         08/07/2010 16:21:05    Loic G          Migration
//      RAD 2007
// 1    Utilitaires1.0         12/12/2007 09:37:19    pascal          
//$
//$NoKeywords$
//
unit MemDataX;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Db,
   dxmdaset,// dxmdsedt,
   IpUtils, IpSock, IpHttp,
   IpHttpClientGinkoia,DesignEditors, DesignIntf;

type
   TOnValidate = procedure(Sender: tobject; Max, Actu: integer) of object;
   TOnLoad = procedure(Sender: tobject; Max, Actu: integer) of object;
   TMonEditeur = class(TDefaultEditor)
   protected
        // PROCEDURE EditProperty(PropertyEditor: TPropertyEditor; VAR Continue, FreeEditor: Boolean); OVERRIDE;
      procedure Parametrage;
   public
      function GetVerbCount: Integer; override;
      function GetVerb(Index: Integer): string; override;
      procedure ExecuteVerb(Index: Integer); override;
   end;

   TDataBaseX = class(TComponent)
   private
      FLaPage: string;
      procedure SetLaPage(const Value: string);
   protected
   public
   published
      property LaPage: string read FLaPage write SetLaPage;
   end;

   TMemDataX = class(TdxMemData)
   private
      FLaPage: string;
      FSql: TstringList;
      FTableMaitre: string;
      FIndexMaitre: string;
      FText: string;
      FNbId: Integer;
      FOnValidate: TOnValidate;
      FOnLoad: TOnLoad;
      FDataBaseX: TDataBaseX;
      procedure TraiteReq;
      procedure SetLaPage(const Value: string);
      procedure SetSql(const Value: Tstrings);
      function GetSql: Tstrings;
      function LanceRequete: TStringList;
      procedure remplitLesChamps(tsl: tstringList);
      procedure SetIndexMaitre(const Value: string);
      procedure SetTableMaitre(const Value: string);
      procedure SetNbId(const Value: Integer);
      procedure SetOnValidate(const Value: TOnValidate);
      procedure SetOnLoad(const Value: TOnLoad);
      procedure SetDataBaseX(const Value: TDataBaseX);
      function GetLaPage: string;
    { Déclarations privées }
   protected
    { Déclarations protégées }
      Http: TIpHttpClientGinkoia;
      nbchamps: Integer;
      leschamps: TstringList;
      lesTables: TstringList;
      ListeAFaire: TstringList;
      FParams: TParams;
      LastId: integer;
      resteId: Integer;
      procedure QueryChanged(Sender: TObject);
      procedure DoOnNewRecord; override;
      procedure DoAfterEdit; override;
      procedure InternalDelete; override;
      function DonneLaPage: string;
   public
    { Déclarations publiques }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure ExecSql;
      procedure Open;
      procedure Annulation;
      procedure Validation;
      function trouve(Champs: TField; Valeur: string): Boolean;
      function trouveSuivant(Champs: TField; Valeur: string): Boolean;
      function NeedID: Integer;
      function ParamByName(const Value: string): TParam;
      function Traitechaine(S: string): string;
      function TraiteStr(S: string): string;
   published
    { Déclarations publiées }
      property LaPage: string read GetLaPage write SetLaPage;
      property Sql: Tstrings read GetSql write SetSql;
      property TableMaitre: string read FTableMaitre write SetTableMaitre;
      property IndexMaitre: string read FIndexMaitre write SetIndexMaitre;
      property NbId: Integer read FNbId write SetNbId;
      property OnValidate: TOnValidate read FOnValidate write SetOnValidate;
      property OnLoad: TOnLoad read FOnLoad write SetOnLoad;
      property DataBaseX: TDataBaseX read FDataBaseX write SetDataBaseX;
   end;
const
  timeout:integer = 30000 ;

procedure Register;

implementation
uses
   MemDataXedt;

procedure Register;
begin
   RegisterComponents('Internet', [TMemDataX, TDataBaseX]);
   RegisterComponentEditor(TMemDataX, TMonEditeur);
end;

{ TMemDataX }

procedure TMemDataX.Annulation;
begin
   ListeAFaire.clear;
   if active then
      Open;
end;

constructor TMemDataX.Create(AOwner: TComponent);
var
   AField: Tfield;
begin
   inherited;
   FDataBaseX := nil;
   Fnbid := 1;
   LastId := -1;
   resteId := 0;
   FParams := TParams.Create(Self);
   FLaPage := 'http://localhost/BD/Util_base.php?';
   ListeAFaire := TstringList.Create;
   Http := TIpHttpClientGinkoia.Create(nil);
   leschamps := TstringList.Create;
   lesTables := TstringList.Create;
   FSql := TstringList.Create;
   TStringList(SQL).OnChange := QueryChanged;
    //
   if fieldcount = 1 then
   begin
      AField := GetFieldClass(ftInteger).Create(Self);
      with AField do
      begin
         FieldName := 'Inserted';
         DataSet := Self;
         Name := Name + FieldName;
         Calculated := False;
         visible := false;
      end;
      AField := GetFieldClass(ftInteger).Create(Self);
      with AField do
      begin
         FieldName := 'Modified';
         DataSet := Self;
         Name := Name + FieldName;
         Calculated := False;
         visible := false;
      end;
   end;
    //
end;

destructor TMemDataX.Destroy;
begin
   FParams.Free;
   ListeAFaire.free;
   FSql.free;
   LesChamps.free;
   lesTables.free;
   Http.free;
   inherited;
end;

procedure TMemDataX.ExecSql;
var
   tsl: TstringList;
begin
   tsl := LanceRequete;
   tsl.free;
end;

function TMemDataX.GetSql: Tstrings;
begin
   result := FSql;
end;

procedure TMemDataX.InternalDelete;
begin
   if fields[1].AsInteger = 0 then
   begin
      if (IndexMaitre <> '') and (TableMaitre <> '') and (findfield(IndexMaitre) <> nil) then
      begin
         if findfield(IndexMaitre).DataType = ftstring then
            ListeAFaire.Add('SUP;' + TableMaitre + ';' + IndexMaitre + ';' + Traitestr(QuotedStr(findfield(IndexMaitre).AsString)))
         else
            ListeAFaire.Add('SUP;' + TableMaitre + ';' + IndexMaitre + ';' + findfield(IndexMaitre).AsString);
      end;
   end;
   inherited;
end;

procedure TMemDataX.DoAfterEdit;
begin
   inherited;
   fields[2].AsInteger := 1;
end;

procedure TMemDataX.DoOnNewRecord;
begin
   inherited;
   if state in [dsinsert, dsedit] then
   begin
      fields[1].AsInteger := 1;
      fields[2].AsInteger := 0;
   end;
end;

function TMemDataX.LanceRequete: TStringList;
var
   S: string;
   i, j: Integer;
   ok: boolean;
begin
   S := FText;
   ok := false;
   for i := 0 to FParams.count - 1 do
   begin
      j := Pos('?', S);
      if j > 0 then
      begin
         system.delete(S, j, 1);
         if FParams[i].IsNull then
            system.insert('NULL', S, j)
         else
         begin
            IF FParams[i].DataType = ftdate then
                system.insert(QuotedStr(TraiteStr(Formatdatetime('YYYY-MM-DD',FParams[i].AsDateTime))), S, j)
            ELSE IF FParams[i].DataType = ftdatetime then
                system.insert(QuotedStr(TraiteStr(Formatdatetime('YYYY-MM-DD hh:nn:ss',FParams[i].AsDateTime))), S, j)
            else
                system.insert(QuotedStr(TraiteStr(FParams[i].Asstring)), S, j);
            if pos('&', FParams[i].Asstring) > 0 then
               ok := true;
         end;
      end;
   end;
   result := TstringList.Create;
   S := Traitechaine(S);
   if ok then
   begin
//     application.messagebox(pchar(s),'param',mb_ok) ;
   end;
   if Http.OldGetWaitTimeOut(LaPage + 'Query=' + S, timeout) then
   begin
      result.text := Http.AsString(LaPage + 'Query=' + S);
   end
   else
      result.add('ERREUR connexion au serveur');
   if ok then
   begin
//     application.messagebox(pchar(result.text),'param',mb_ok) ;
   end;
end;

procedure TMemDataX.Open;
var
   I, J: integer;
   Tsl: TstringList;
   Sauvdec: Char;
   SaveA: TDataSetNotifyEvent;
   SaveB: TDataSetNotifyEvent;
   SaveScA: TDataSetNotifyEvent;
   SaveScB: TDataSetNotifyEvent;
   S: string;
begin
   SaveA := BeforeInsert;
   SaveB := AfterInsert;
   SaveScA := BeforeScroll;
   SaveScB := AfterScroll;
   BeforeInsert := nil;
   AfterInsert := nil;
   BeforeScroll := nil;
   AfterScroll := nil;
   Close;
   ListeAFaire.clear;
   tsl := LanceRequete;
   if (uppercase(Copy(TSL[0], 1, 3)) = '<BR') or
      (Copy(TSL[0], 1, 6) = 'ERREUR') then
   begin
          // erreur ;
   end
   else
   begin
      DisableControls;
      try
         remplitLesChamps(tsl);
         inherited Open;
         Sauvdec := DecimalSeparator;
         DecimalSeparator := '.';
         i := nbchamps + 1; j := 0;
         while i < tsl.count do
         begin
            if assigned(FOnLoad) then
            begin
               OnLoad(self, tsl.count, I + 1);
            end;
            if j = 0 then Append;
            if FindField(leschamps[j]) <> nil then
            begin
               if (fieldByName(leschamps[j]).DataType = ftdatetime) then
               begin
                  S := tsl[i];
                  if pos('-', S) > 0 then
                  begin
                     if Copy(S, 9, 2) = '00' then
                        FieldByName(leschamps[j]).clear
                     else
                        FieldByName(leschamps[j]).AsString := Copy(S, 9, 2) + '/' + Copy(S, 6, 2) + '/' + Copy(S, 1, 4) + Copy(S, 11, 255);
                  end
                  else
                     FieldByName(leschamps[j]).AsString := S;
               end
               else FieldByName(leschamps[j]).AsString := tsl[i];
            end;
            inc(i); inc(j);
            if j >= nbchamps then
            begin
               Fields[1].Asinteger := 0;
               Fields[2].Asinteger := 0;
               Post;
               j := 0;
            end;
         end;
         DecimalSeparator := Sauvdec;
      except
      end;
      First;
      EnableControls;
   end;
   tsl.free;
   BeforeInsert := SaveA;
   AfterInsert := SaveB;
   BeforeScroll := SaveScA;
   AfterScroll := SaveScB;
   DoAfterScroll;
end;

procedure TMemDataX.remplitLesChamps(tsl: tstringList);
var
   i: integer;
   S: string;
   AField: TField;
   tpe: string;
begin
   nbchamps := Strtoint(TSL[0]);
    // Nbr de champs
   leschamps.Clear;
   lesTables.clear;
   if FieldCount = 3 then
   begin
      for i := 1 to nbchamps do
      begin
         S := Tsl[i];
         tpe := Copy(S, pos(';', S) + 1, 255);
         system.delete(tpe, 1, pos(';', tpe));
         if copy(tpe, 1, 3) = 'int' then
         begin
            AField := GetFieldClass(ftinteger).Create(Self);
         end
         else if copy(tpe, 1, 8) = 'datetime' then
         begin
            AField := GetFieldClass(ftdatetime).Create(Self);
         end
         else if copy(tpe, 1, 8) = 'tinytext' then
         begin
            AField := GetFieldClass(ftString).Create(Self);
            AField.Size := 1024;
         end
         else if copy(tpe, 1, 7) = 'varchar' then
         begin
            AField := GetFieldClass(ftString).Create(Self);
            system.delete(tpe, 1, pos('(', tpe));
            tpe := copy(tpe, 1, pos(')', tpe) - 1);
            AField.Size := strtoint(tpe);
         end
         else if copy(tpe, 1, 6) = 'double' then
         begin
            AField := GetFieldClass(ftFloat).Create(Self);
         end
         else
         begin
            AField := GetFieldClass(ftString).Create(Self);
            AField.Size := 255;
         end;
         with AField do
         begin
            tpe := Copy(S, pos(';', S) + 1, 255);
            tpe := Copy(tpe, 1, pos(';', tpe) - 1);
            FieldName := tpe;
            DataSet := Self;
            Name := Name + tpe;
            Calculated := False;
            leschamps.add(FieldName);
            tpe := Copy(S, 1, pos(';', S) - 1);
            lesTables.add(tpe);
         end;
      end;
   end
   else
   begin
      for i := 1 to nbchamps do
      begin
         S := Tsl[i];
         tpe := Copy(S, pos(';', S) + 1, 255);
         tpe := Copy(tpe, 1, pos(';', tpe) - 1);
         leschamps.add(tpe);
         tpe := Copy(S, 1, pos(';', S) - 1);
         lesTables.add(tpe);
      end;
   end;
end;

procedure TMemDataX.SetIndexMaitre(const Value: string);
begin
   FIndexMaitre := Value;
end;

procedure TMemDataX.SetLaPage(const Value: string);
begin
   FLaPage := Value;
end;

procedure TMemDataX.SetSql(const Value: Tstrings);
begin
   FSql.Assign(Value);
   TraiteReq;
end;

procedure TMemDataX.SetTableMaitre(const Value: string);
begin
   FTableMaitre := Value;
end;

function TMemDataX.Traitechaine(S: string): string;
var
   i: integer;
begin
   while pos(#13#10, S) > 0 do
   begin
      i := pos(#13#10, S);
      system.delete(S, i, 2);
      system.Insert(' ', S, i);
   end;
   while pos(' ', S) > 0 do
   begin
      i := pos(' ', S);
      system.delete(S, i, 1);
      system.Insert('%20', S, i);
   end;
   result := trim(s);
end;

procedure TMemDataX.Validation;
var
   i: integer;
   S: string;
   Tbl: string;
   Ind: string;
   Value: string;
   Sauvdec: char;
   nbr: Integer;
   TSl: TstringList;
   NbEnAtt: Integer;
   Nbrtraite: Integer;
   SaveA: TDataSetNotifyEvent;
   SaveB: TDataSetNotifyEvent;
begin
   if not active then EXIT;
   DisableControls;
   SaveA := AfterScroll;
   SaveB := BeforeScroll;
   AfterScroll := nil;
   BeforeScroll := nil;
   Sauvdec := DecimalSeparator;
   DecimalSeparator := '.';
   First;
   TSl := TstringList.create;
   for i := 0 to ListeAFaire.count - 1 do
   begin
      S := ListeAFaire[i];
      if copy(S, 1, pos(';', S)) = 'SUP;' then
      begin
         system.delete(s, 1, 4);
         tbl := system.copy(S, 1, pos(';', S) - 1); system.delete(S, 1, pos(';', S));
         Ind := system.copy(S, 1, pos(';', S) - 1); system.delete(S, 1, pos(';', S));
         Value := S;
         S := 'SUP=' + tbl + '&ID=' + ind + '&VALEUR=' + Value;
         S := LaPage + S;
         s := Traitechaine(S);
         Http.OldGetWaitTimeOut(S, timeout);
      end;
   end;
   ListeAFaire.clear;
   NbEnAtt := 0;
   NbrTraite := 0;
   while not eof do
   begin
      inc(NbrTraite);
      if assigned(FOnValidate) then
         OnValidate(self, recordcount, Nbrtraite);
      if fields[1].Asinteger = 1 then
      begin // insertion
         Nbr := 0;
         for i := 0 to lesTables.count - 1 do
            if uppercase(TableMaitre) = uppercase(lesTables[i]) then
            begin
               if FindField(leschamps[i]) <> nil then
               begin
                  if (fieldByName(leschamps[i]).DataType = ftstring) then
                     S := QuotedStr(TraiteStr(fieldByName(leschamps[i]).AsString))
                  else if (fieldByName(leschamps[i]).DataType = ftdatetime) then
                  begin
                     S := QuotedStr(Formatdatetime('YYYY-MM-DD hh:nn:ss', fieldByName(leschamps[i]).AsDateTime));
                  end
                  else
                  begin
                     S := fieldByName(leschamps[i]).AsString;
                     if s = '' then S := '0';
                  end;
                  if tsl.count < nbr + 1 then
                     tsl.add(S)
                  else
                     tsl[nbr] := tsl[nbr] + '§' + S;
                  Inc(nbr);
               end;
            end;
         Inc(NbEnAtt);
         S := 'INS=' + TableMaitre;
         Nbr := 0;
         for i := 0 to lesTables.count - 1 do
            if uppercase(TableMaitre) = uppercase(lesTables[i]) then
            begin
               if findField(leschamps[i]) <> nil then
               begin
                  Inc(nbr);
                  S := S + '&ID' + inttostr(Nbr) + '=' + fieldByName(leschamps[i]).FieldName + '&VALEUR' + inttostr(Nbr) + '=' + TSL[nbr - 1];
               end;
            end;
         S := S + '&NBR=' + Inttostr(nbr);
         S := LaPage + S;
         s := Traitechaine(S);
         if length(S) > 1024 then
         begin
//            Application.MessageBox (pchar(S),'',mb_ok) ;
            Http.OldGetWaitTimeOut(S, timeout);
            tsl.clear;
            NbEnAtt := 0;
         end;
         edit;
         fields[1].asinteger := 0; fields[2].asinteger := 0;
         Post;
      end
      else if fields[2].Asinteger = 1 then
      begin // modification
         S := 'UPD=' + TableMaitre + '&ID=' + IndexMaitre + '&VALEUR=';
         nbr := 0;
         if fieldByName(IndexMaitre).DataType = ftstring then
            S := S + QuotedStr(TraiteStr(fieldByName(IndexMaitre).AsString))
         else
            S := S + fieldByName(IndexMaitre).AsString;
         for i := 0 to lesTables.count - 1 do
            if uppercase(TableMaitre) = uppercase(lesTables[i]) then
            begin
               if findfield(leschamps[i]) <> nil then
               begin
                  if fieldByName(IndexMaitre) <> fieldByName(leschamps[i]) then
                  begin
                     Inc(nbr);
                     S := S + '&ID' + inttostr(Nbr) + '=' + fieldByName(leschamps[i]).FieldName + '&VALEUR' + inttostr(Nbr) + '=';
                     if (fieldByName(leschamps[i]).DataType = ftstring) then
                        S := S + QuotedStr(TraiteStr(fieldByName(leschamps[i]).AsString))
                     else if (fieldByName(leschamps[i]).DataType = ftdatetime) then
                     begin
                        S := S + QuotedStr(Formatdatetime('YYYY-MM-DD hh:nn:ss', fieldByName(leschamps[i]).AsDateTime));
                     end
                     else
                     begin
                        if fieldByName(leschamps[i]).AsString = '' then
                           S := S + '0'
                        else
                           S := S + fieldByName(leschamps[i]).AsString;
                     end;
                  end;
               end;
            end;
         S := S + '&NBR=' + Inttostr(nbr);
         S := LaPage + S;
         s := Traitechaine(S);
         Http.oldGetWaitTimeOut(S, timeout);
         edit;
         fields[1].asinteger := 0; fields[2].asinteger := 0;
         Post;
      end;
      next;
   end;
   if NbEnAtt > 0 then
   begin
      S := 'INS=' + TableMaitre;
      Nbr := 0;
      for i := 0 to lesTables.count - 1 do
         if uppercase(TableMaitre) = uppercase(lesTables[i]) then
         begin
            if findfield(leschamps[i]) <> nil then
            begin
               Inc(nbr);
               S := S + '&ID' + inttostr(Nbr) + '=' + fieldByName(leschamps[i]).FieldName + '&VALEUR' + inttostr(Nbr) + '=' + TSL[nbr - 1];
            end;
         end;
      S := S + '&NBR=' + Inttostr(nbr);
      S := LaPage + S;
      s := Traitechaine(S);
//      Application.MessageBox (pchar(S),'',mb_ok) ;
      Http.OldGetWaitTimeOut(S, timeout);
      tsl.clear;
   end;
   tsl.free;
   DecimalSeparator := Sauvdec;
   EnableControls;
   AfterScroll := SaveA;
   BeforeScroll := SaveB;
end;

function TMemDataX.NeedID: Integer;
var
   s: string;
begin
   if resteId <= 0 then
   begin
      S := Traitechaine(Lapage + 'ID_PRIN&ID_NB=' + Inttostr(FNbId));
      resteId := FNbId;
      Http.oldGetWaitTimeOut(S, timeout);
      LastId := Strtoint(trim(Http.AsString(S)));
   end;
   result := LastId;
   Inc(lastId);
   dec(resteId);
end;

procedure TMemDataX.TraiteReq;
var
   List: TParams;
begin
   List := TParams.Create(Self);
   try
      FText := List.ParseSQL(FSQL.Text, True);
      if pos(#0, FText) > 0 then
         FText := Copy(FText, 1, pos(#0, FText) - 1);
      List.AssignValues(FParams);
      FParams.Clear;
      FParams.Assign(List);
   finally
      List.Free;
   end;
end;

function TMemDataX.ParamByName(const Value: string): TParam;
begin
   Result := FParams.ParamByName(Value);
end;

procedure TMemDataX.QueryChanged(Sender: TObject);
begin
   Close;
   TraiteReq;
end;

procedure TMemDataX.SetNbId(const Value: Integer);
begin
   FNbId := Value;
end;

procedure TMemDataX.SetOnValidate(const Value: TOnValidate);
begin
   FOnValidate := Value;
end;

{ TMonEditeur }
{
PROCEDURE TMonEditeur.EditProperty(PropertyEditor: TPropertyEditor; VAR Continue, FreeEditor: Boolean);
BEGIN
    Continue := false;
    FreeEditor := true;
    Parametrage;
END;
}

procedure TMonEditeur.ExecuteVerb(Index: Integer);
begin
   case Index of
      0: Parametrage;
      1: ShowdxMemDataEditor(TdxMemData(Component), Designer);
   end
end;

function TMonEditeur.GetVerb(Index: Integer): string;
begin
   case Index of
      0: result := 'Editeur';
      1: Result := 'Field Editor ...';
   end;
end;

function TMonEditeur.GetVerbCount: Integer;
begin
   result := 2;
end;

procedure TMonEditeur.Parametrage;
var
   Dial_Memedt: TDial_Memedt;
begin
   Application.createform(TDial_Memedt, Dial_Memedt);
   try
      Dial_Memedt.Init(TMemDataX(Component), Designer);
      Dial_Memedt.ShowModal;
   finally
      Dial_Memedt.release;
   end;
end;

procedure TMemDataX.SetOnLoad(const Value: TOnLoad);
begin
   FOnLoad := Value;
end;

procedure TMemDataX.Notification(AComponent: TComponent; Operation: TOperation);
begin
   if not (csLoading in ComponentState) and not (csDestroying in ComponentState) then
   begin
      if (AComponent is TDataBaseX) and (TDataBaseX(AComponent) = FDataBaseX) then
      begin
         FDataBaseX := nil;
      end;
   end;
   inherited;
end;

procedure TMemDataX.SetDataBaseX(const Value: TDataBaseX);
begin
   FDataBaseX := Value;
end;

function TMemDataX.DonneLaPage: string;
begin
end;

function TMemDataX.GetLaPage: string;
begin
   if (FDataBaseX = nil) or (FDataBaseX.LaPage = '') then
      result := FLaPage
   else
      result := FDataBaseX.LaPage;
end;

function TMemDataX.trouve(Champs: TField; Valeur: string): Boolean;
var
   SaveA: TDataSetNotifyEvent;
   SaveB: TDataSetNotifyEvent;
begin
   DisableControls;
   SaveA := AfterScroll;
   SaveB := BeforeScroll;
   AfterScroll := nil;
   BeforeScroll := nil;
   try
      First;
      while not eof and (Champs.asstring <> Valeur) do
         next;
      result := (not eof);
   finally
      EnableControls;
      AfterScroll := SaveA;
      BeforeScroll := SaveB;
   end;
end;

function TMemDataX.TraiteStr(S: string): string;
begin
   while system.pos('&', S) > 0 do
   begin
      system.Insert('¤1¤', S, system.pos('&', S));
      system.delete(S, system.pos('&', S), 1);
   end;
   result := S;
end;

function TMemDataX.trouveSuivant(Champs: TField; Valeur: string): Boolean;
var
   SaveA: TDataSetNotifyEvent;
   SaveB: TDataSetNotifyEvent;
begin
   DisableControls;
   SaveA := AfterScroll;
   SaveB := BeforeScroll;
   AfterScroll := nil;
   BeforeScroll := nil;
   Next;
   try
      while not eof and (Champs.asstring <> Valeur) do
         next;
      result := (not eof);
   finally
      EnableControls;
      AfterScroll := SaveA;
      BeforeScroll := SaveB;
   end;
end;

{ TDataBaseX }

procedure TDataBaseX.SetLaPage(const Value: string);
begin
   FLaPage := Value;
end;

end.


unit UInstallThr;

interface

uses
   SevenZip,
   forms,
   inifiles,
   Rxfileutil,
   windows,
   sysutils,
   Classes,
   Dialogs;


type
   TInstall_Thr = class(TThread)
   private
      procedure Copier(Src, Dest: string);
      procedure Recup_Generateur(Value: string);
      procedure TotalPcent(Sender: TObject; TotalSize: Int64;
         PerCent: Integer);
      procedure Supprime(Src: string);
      //Fonction de lecture d'une valeur dans le fichier Ini
      FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String;

    { Déclarations privées }
   protected
      LastOrdre: string;
      procedure Execute; override;
      procedure GetOrdre;
   public
      LastCall: TDateTime;
      running: boolean;
      id: integer;
      ordres: TStringList;
      LastTraitement: string;
      doing: string;
      msg: string;
      debug: string;
      LastOrdreError: string;
      LastError: string;
      procedure AddOrdre(s: string);
      constructor Create(suspended: boolean; id: integer);
      procedure stop;
      destructor destroy; override;
   end;

type
  TProcedure = procedure;
    Procedure Log(Fichier:String;ligne:String);

var
  LecteurLame : string;

implementation

uses
   IBDatabase, Db, IBCustomDataSet, IBQuery, Math;

{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure TInstall_Thr.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end; }

{ TInstall_Thr }

Procedure Log(Fichier:String;ligne:String);
Var
  F : TextFile;
Begin
  ForceDirectories(ExtractFilePath(Fichier));
  AssignFile(F,Fichier);
  if FileExists(Fichier) then
    Append(F)
  else
    Rewrite(F);
  Writeln(F,Ligne);
  Close(F);
End;

procedure TInstall_Thr.AddOrdre(s: string);
begin
   ordres.add(s);
end;

constructor TInstall_Thr.Create(suspended: boolean; id: integer);
begin
   inherited Create(suspended);
   FreeOnTerminate := true;
   running := false;
   LastCall := Now;
   self.id := id;
   ordres := TStringList.create;
   LastOrdre := '';
   doing := '';
   LastTraitement := '';
   msg := '';
end;

destructor TInstall_Thr.destroy;
begin
   ordres.free;
   inherited;
end;

procedure TInstall_Thr.Supprime(Src: string);
var
   f: TSearchRec;
begin
   if FindFirst(src + '*.*', faAnyFile, F) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if (f.attr and Fadirectory) = Fadirectory then
            begin
               Supprime(src + f.name + '\');
            end
            else
            begin
               msg := 'Supression de ' + src + f.name;
               DeleteFile(src + f.name);
            end;
         end;
      until findnext(f) <> 0;
      RemoveDir(src);
   end;
   findclose(f);
end;

procedure TInstall_Thr.Copier(Src, Dest: string);
var
   f: TSearchRec;
begin
   ForceDirectories(Dest);
   if FindFirst(src + '*.*', faAnyFile, F) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if (f.attr and Fadirectory) = Fadirectory then
            begin
               Copier(src + f.name + '\', dest + f.name + '\');
            end
            else
            begin
               msg := 'Copie de ' + src + f.name + ' vers ' + dest + f.name;
               CopyFile(Pchar(src + f.name), Pchar(dest + f.name), False);
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
end;

procedure TInstall_Thr.Recup_Generateur(value: string);

   procedure transforme(TAG, Valeur: string; var S2: string);
   var
      i: Integer;
   begin
      while pos('<' + TAG + '>', S2) > 0 do
      begin
         i := pos('<' + TAG + '>', S2);
         delete(S2, i, length('<' + TAG + '>'));
         while s2[i] <> '<' do delete(s2, i, 1);
         INSERT('<@@>' + Valeur, S2, I);
      end;
      while pos('<@@>', S2) > 0 do
      begin
         i := pos('<@@>', S2);
         delete(S2, i, length('<@@>'));
         INSERT('<' + TAG + '>', S2, I);
      end;
   end;

   procedure decodeplage(S: string; var Deb, fin: integer);
   begin
      if Pos('[', S) = 1 then
         delete(S, 1, 1);
      deb := Strtoint(copy(S, 1, pos('M', S) - 1));
      if Pos('_', S) > 0 then
         delete(S, 1, pos('_', S))
      else
         delete(S, 1, pos('-', S));
      fin := Strtoint(copy(S, 1, pos('M', S) - 1));
   end;

var
   ini: tinifile;
   deb, fin: Integer;
   deb2, fin2: Integer;
   def: integer;
   minimum: integer;
   num: Integer;
   num2: Integer;
   J: Integer;
   k: Integer;
   L: Integer;
   S: string;
   Table: string;
   Champs: string;
   Plus: string;
//   Pass: string;

   genid: Integer;
   genidpantin: Integer;

   Tsl: TstringList;

   Generateur: string;
   _data: TIBDatabase;
   _tran: TIBTransaction;
   IBQue_Generateur: TIBQuery;
   IBQue_Script: TIBQuery;

   Plage_pantin,
      Plage_Magasin: string;
   NumMagasin: Integer;
   Path,
      Sender,
      Database: string;
   Eai,
      Pantin,
      version: string;
   DataBaseName: string;

  Sufixes : tstringlist;   
  DoWithout : Boolean;
begin
   try
      Plage_pantin := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      Plage_Magasin := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      NumMagasin := Strtoint(copy(value, 1, pos(';', value) - 1)); delete(value, 1, pos(';', value));
      Path := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      Sender := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      Database := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      Eai := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      Pantin := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      version := copy(value, 1, pos(';', value) - 1); delete(value, 1, pos(';', value));
      DataBaseName := value;

      _data := TIBDatabase.create(nil);
      _tran := TIBTransaction.create(nil);
      _data.DefaultTransaction := _tran;
      _tran.DefaultDatabase := _data;
      _data.SQLDialect := 3;
      _data.Params.values['user_name'] := 'sysdba';
      _data.Params.values['password'] := 'masterkey';
      _data.DatabaseName := DataBaseName;
      _data.LoginPrompt := false;

      IBQue_Script := TIBQuery.create(nil);
      IBQue_Script.Database := _data;
      IBQue_Script.Transaction := _Tran;

      IBQue_Generateur := TIBQuery.create(nil);
      IBQue_Generateur.Database := _data;
      IBQue_Generateur.SQL.text := ' Select rdb$Generator_Name Name from   rdb$Generators where rdb$System_FLAG is null';

      ini := tinifile.create(LecteurLame+':\EAI\MAJ\GINKOIA\RecupBase.ini');
      try
         decodeplage(Plage_Magasin, deb, fin);
         decodeplage(plage_Pantin, deb2, fin2);
         IBQue_Generateur.Open;
         GenIdPantin := 0;
         GenId := 0;
         while not IBQue_Generateur.EOF do
         begin
            Generateur := trim(IBQue_Generateur.fields[0].AsString);
            msg := 'Recup générateur ' + Generateur;
            def := ini.readinteger(Generateur, 'Def', 0);
            minimum := ini.readinteger(Generateur, 'Min', -9999);

            case def of
              1  : // DEF=1 -> Valeur dans la plage
                begin
                   Num := 0;
                   if Uppercase(Generateur) = 'GENERAL_ID' then
                   begin // Pantin
                      num := 0;
                      j := ini.readinteger(Generateur, 'NbTable', 0);
                      for j := 1 to j do
                      begin
                         S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                         Table := copy(S, 1, pos(';', S) - 1);
                         Champs := copy(S, pos(';', S) + 1, 255);
                         IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table + ' where ' + Champs + ' between ' + Inttostr(deb2) + '*1000000 and ' + Inttostr(fin2) + '*1000000 ';
                         IBQue_Script.Open;
                         if not (IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                            Num := IBQue_Script.fields[0].Asinteger;
                         IBQue_Script.Close;
                      end;
                      if num < deb2 * 1000000 then
                         num := deb2 * 1000000;
                      if num < minimum then
                         num := minimum;
                      genidpantin := Num;
                   end;
                   if (Uppercase(Generateur) = 'GENERAL_ID') and
                      (NumMagasin = 0) then
                   begin
                      genid := genidpantin;
                      IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                      IBQue_Script.ExecSQL;
                   end
                   else
                   begin
                      num := 0;
                      j := ini.readinteger(Generateur, 'NbTable', 0);
                      for j := 1 to j do
                      begin
                         S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                         Table := copy(S, 1, pos(';', S) - 1);
                         Champs := copy(S, pos(';', S) + 1, 255);
                         IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table + ' where ' + Champs + ' between ' + Inttostr(deb) + '*1000000 and ' + Inttostr(fin) + '*1000000 ';
                         IBQue_Script.Open;
                         if not (IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                            Num := IBQue_Script.fields[0].Asinteger;
                         IBQue_Script.Close;
                      end;
                      if num < deb * 1000000 then
                         num := deb * 1000000;
                      if num < minimum then
                         num := minimum;
                      IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                      IBQue_Script.ExecSQL;
                      if (Uppercase(Generateur) = 'GENERAL_ID') and (NumMagasin <> 0) then
                         genid := Num;
                   end;
                end;
              2 : // DEF=2 -> NUmMagasin + '-' + Valeur [+ '*R'] [+ '*F']
                begin
                   num := 0;
                   j := ini.readinteger(Generateur, 'NbTable', 0);
                   for j := 1 to j do
                   begin
                      S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                      Table := copy(S, 1, pos(';', S) - 1);
                      delete(S, 1, pos(';', S));
                      if pos(';', S) > 0 then
                      begin
                         Champs := copy(S, 1, pos(';', S) - 1);
                         delete(S, 1, pos(';', S));
                         plus := S;
                      end
                      else
                      begin
                         Champs := S;
                         plus := '';
                      end;
                      IBQue_Script.sql.text := 'select Max( Cast(f_mid (' + Champs + ',' + InttoStr(Length(Inttostr(NumMagasin)) + 1) + ',12) as integer)) from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%''' +
                         'and not ' + Champs + ' Like ''%R''';
                      if plus <> '' then
                         IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
                      IBQue_Script.Open;
                      if (not IBQue_Script.eof) and (not IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                         Num := IBQue_Script.fields[0].Asinteger;
                      IBQue_Script.Close;
                   end;
                   if num < minimum then
                      num := minimum;
                   IBQue_Script.sql.TEXT := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                   IBQue_Script.ExecSQL;
                end;
              3 : // DEF=3 -> Valeur
                begin
                   num := 0;
                   j := ini.readinteger(Generateur, 'NbTable', 0);
                   for j := 1 to j do
                   begin
                      S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                      Table := copy(S, 1, pos(';', S) - 1);
                      Champs := copy(S, pos(';', S) + 1, 255);
                      IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table;
                      IBQue_Script.Open;
                      if not (IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                         Num := IBQue_Script.fields[0].Asinteger;
                      IBQue_Script.Close;
                   end;
                   if num < minimum then
                      num := minimum;
                   IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                   IBQue_Script.execSql;
                end;
              4 : // DEF=4 -> Code Barre ('2' + NumMag sur 3 chiffre + generateur + chiffre de control)
                begin
                   num := 0;
                   j := ini.readinteger(Generateur, 'NbTable', 0);
                   for j := 1 to j do
                   begin
                      S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                      Table := copy(S, 1, pos(';', S) - 1);
(*
                      IBQue_Script.sql.text := 'Select distinct rdb$Field_name Champs ' +
                         ' from   rdb$relation_fields ' +
                         ' where rdb$Relation_Name = ' + quotedstr(Table) +
                         ' order by RDB$Field_position ';
                      IBQue_Script.Open;
                      IBQue_Script.First;
                      Pass := IBQue_Script.fields[0].AsString;
                      IBQue_Script.Close;
*)
                      delete(S, 1, pos(';', S));
                      if pos(';', S) > 0 then
                      begin
                         Champs := copy(S, 1, pos(';', S) - 1);
                         delete(S, 1, pos(';', S));
                         plus := S;
                      end
                      else
                      begin
                         Champs := S;
                         plus := '';
                      end;

                      S := IntToStr(NumMagasin);
                      for L := 0 to (3 - length(S)) - 1 do
                        S :=  '0' + S;
                      IBQue_Script.sql.text  := 'Select Max(' + Champs + ') from ' + Table + ' Where ((' + Champs + ' like ''2' + S + '%'') ';
                      {IBQue_Script.sql.text := 'Select ' + Champs + ' from ' + Table + ' Where ' + Pass + ' = (' +
                         'Select Max(' + Pass + ') from ' + Table + ' Where ' + Pass + ' Between ' + Inttostr(deb) + '*1000000 and ' + Inttostr(fin) + '*1000000 ';}
                      if plus <> '' then
                         IBQue_Script.sql.Add('AND ' + Plus + ')')
                      else
                         IBQue_Script.sql.Add(')');
                      try
                         IBQue_Script.Open;
                         Num := 0;
                         if not (IBQue_Script.fields[0].IsNull) then
                         begin
                            S := IBQue_Script.fields[0].AsString;
                            Delete(S, 1, 4);
                            Delete(S, length(S), 1);
                            Val(S, Num2, k);
                            if k = 0 then
                            begin
                               if Num < Num2 then
                                  Num := Num2;
                            end;
                         end
                         else
                            Num := 0;
                         IBQue_Script.Close;
                      except
                         Num := 0;
                      end;
                   end;
                   if num < minimum then
                      num := minimum;
                   IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                   IBQue_Script.ExecSQL;
                end;
              5 : // DEF=5 -> NumMagasin + '-' + 'M' + Valeur // Modèle de facture
                begin
                  num := 0;
                  j := ini.readinteger(Generateur, 'NbTable', 0);
                  for j := 1 to j do
                  begin
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);
                    delete(S, 1, pos(';', S));
                    if pos(';', S) > 0 then
                    begin
                      Champs := copy(S, 1, pos(';', S) - 1);
                      delete(S, 1, pos(';', S));
                      plus := S;
                    end
                    else
                    begin
                      Champs := S;
                      plus := '';
                    end;
                    IBQue_Script.sql.text := 'select Max( Cast(f_mid (' + Champs + ',' + InttoStr(Length(Inttostr(NumMagasin)) + 2) + ',12) as integer)) from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%''' +
                                             'and not ' + Champs + ' Like ''%R''';
                    if plus <> '' then
                      IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
                    IBQue_Script.Open;
                    if (not IBQue_Script.eof) and (not IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                      Num := IBQue_Script.fields[0].Asinteger;
                    IBQue_Script.Close;
                  end;
                  if num < minimum then
                    num := minimum;
                  IBQue_Script.sql.text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                  IBQue_Script.execSql;
                end;
              6 : // DEF=6 -> mettre a 0
                begin
                  IBQue_Script.sql.clear;
                  IBQue_Script.sql.Add('SET GENERATOR ' + Generateur + ' to 0 ');
                  IBQue_Script.ExecSQL;
                end;
              8 : // DEF=8 -> NumMagasin + '-' + Valeur + '*F' // Facture de retro
                BEGIN
                  num := 0;
                  j := ini.readinteger(Generateur, 'NbTable', 0);
                  FOR j := 1 TO j DO
                  BEGIN
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);

                    delete(S, 1, pos(';', S));
                    IF pos(';', S) > 0 THEN
                    BEGIN
                      Champs := copy(S, 1, pos(';', S) - 1);
                      delete(S, 1, pos(';', S));
                      plus := S;
                    END
                    ELSE
                    BEGIN
                      Champs := S;
                      plus := '';
                    END;

                    IBQue_Script.close;
                    IBQue_Script.sql.text := ' Select Max( Cast(f_mid (' + champs + ',' + inttoStr(Length(Inttostr(NumMagasin)) + 1) +
                        ',f_bigstringlength(' + champs + ')-' + inttoStr(Length(Inttostr(NumMagasin)) + 3) +
                        ') as integer))' +
                        ' from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%''' +
                        ' and ' + champs + ' like ''%F'' ';
                    IF plus <> '' THEN
                      IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
                    TRY
                      IBQue_Script.Open;
                      IF (NOT IBQue_Script.eof) AND (NOT IBQue_Script.fields[0].IsNull) AND (IBQue_Script.fields[0].Asinteger > Num) THEN
                        Num := IBQue_Script.fields[0].Asinteger;
                    EXCEPT
                    END;
                    IBQue_Script.close;
                  END;
                  IF num < minimum THEN
                    num := minimum;
                  IBQue_Script.sql.text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                  IBQue_Script.execSql;
                END;
              9 : // DEF=9 -> BP du web : site sur 4 caractères + '-' + NumMag + '-' + sequence
                begin
                  num := Max(minimum, 0);
                  j := ini.readinteger(Generateur, 'NbTable', 0);
                  for j := 1 to j do
                  begin
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);
                    delete(S, 1, pos(';', S));
                    if pos(';', S) > 0 then
                    begin
                      Champs := copy(S, 1, pos(';', S) - 1);
                      delete(S, 1, pos(';', S));
                      plus := S;
                    end
                    else
                    begin
                      Champs := S;
                      plus := '';
                    end;

                    IBQue_Script.close;
                    IBQue_Script.sql.text := 'select max(cast(substr(' + champs + ', ' + inttoStr(Length(Inttostr(NumMagasin)) + 7) + ', f_bigstringlength(' + champs + ')) as integer)) '
                                           + 'from ' + table + ' '
                                           + 'where ' + champs + ' like ''____-' + Inttostr(NumMagasin) + '-%'' ';
                    if plus <> '' then
                      IBQue_Script.sql.text := IBQue_Script.sql.text + ' and ' + Plus;
                    try
                      IBQue_Script.Open;
                      if not (IBQue_Script.eof or IBQue_Script.fields[0].IsNull or (IBQue_Script.fields[0].Asinteger <= Num)) then
                        Num := IBQue_Script.fields[0].Asinteger;
                    except
                    end;
                    IBQue_Script.close;
                  end;
                  IBQue_Script.sql.text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                  IBQue_Script.execSql;
                end;
              10 : // DEF=10 -> Interclub : NumMagasin + '-' + Valeur + Terminaisons en paramètres
                begin
                  try
                    Sufixes := TStringList.Create();
                    Sufixes.Delimiter := ';';
                    Sufixes.DelimitedText := ini.ReadString(Generateur, 'Sufixes', '');
                    DoWithout := ini.ReadBool(Generateur, 'DoWithout', true);

                    num := Max(minimum, 0);
                    j := ini.readinteger(Generateur, 'NbTable', 0);

                    for j := 1 to j do
                    begin
                      S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                      Table := copy(S, 1, pos(';', S) - 1);
                      delete(S, 1, pos(';', S));
                      if pos(';', S) > 0 then
                      begin
                        Champs := copy(S, 1, pos(';', S) - 1);
                        delete(S, 1, pos(';', S));
                        plus := S;
                      end
                      else
                      begin
                        Champs := S;
                        plus := '';
                      end;

                      IBQue_Script.close;
                      IBQue_Script.SQL.Clear();
                      IBQue_Script.sql.Add('select Max(Cast(');
                      for k := 0 to Sufixes.Count -1 do
                        if k = 0 then
                          IBQue_Script.sql.Add('  case when ' + champs + ' like ''%' + Sufixes[k] + ''' then SubStr(' + champs
                                             + ', ' + inttoStr(Length(Inttostr(NumMagasin)) + 2)
                                             + ', f_bigstringlength(' + champs + ') - ' + IntToStr(Length(Sufixes[k])) + ')')
                        else
                          IBQue_Script.sql.Add('       when ' + champs + ' like ''%' + Sufixes[k] + ''' then SubStr(' + champs
                                             + ', ' + inttoStr(Length(Inttostr(NumMagasin)) + 2)
                                             + ', f_bigstringlength(' + champs + ') - ' + IntToStr(Length(Sufixes[k])) + ')');
                      if DoWithout then
                        IBQue_Script.sql.Add('       else SubStr(' + champs + ', ' + inttoStr(Length(Inttostr(NumMagasin)) + 2) + ', f_bigstringlength(' + champs + '))');
                      IBQue_Script.sql.Add('  end as integer))');
                      IBQue_Script.sql.Add('from ' + table);
                      if DoWithout then
                      begin
                        IBQue_Script.SQL.Add('where ' + champs + ' like ''' + Inttostr(NumMagasin) + '-%''');
                        if plus <> '' then
                          IBQue_Script.sql.Add('      and ' + Plus)
                      end
                      else
                      begin
                        for k := 0 to Sufixes.Count -1 do
                          if k = 0 then
                            IBQue_Script.sql.Add('where (' + champs + ' like ''' + Inttostr(NumMagasin) + '-%' + Sufixes[k] + '''')
                          else
                            IBQue_Script.sql.Add('       or ' + champs + ' like ''' + Inttostr(NumMagasin) + '-%' + Sufixes[k] + '''');
                        if plus <> '' then
                          IBQue_Script.sql.Add('      ) and ' + Plus)
                        else
                          IBQue_Script.sql.Add('  )');
                      end;
                      try
                        IBQue_Script.Open;
                        if not (IBQue_Script.eof or IBQue_Script.fields[0].IsNull or (IBQue_Script.fields[0].Asinteger <= Num)) then
                          Num := IBQue_Script.fields[0].Asinteger;
                      except
                      end;
                      IBQue_Script.close;
                    end;
                    IBQue_Script.sql.text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                    IBQue_Script.execSql;
                  finally
                    FreeAndNil(Sufixes);
                  end;
                end;
              else
                // DEF=7 -> Pas touche !!
                // DEF=0 pour ne rien faire ...
                // et autre methodes encore inconnue
                begin
                end;
            end;

            IBQue_Generateur.Next;
         end;
         IBQue_Generateur.Close;

         _data.Connected := false;
         IBQue_Generateur.free;
         IBQue_Script.free;
         _tran.free;
         _data.free;

         if (NumMagasin <> 0) and (trim(EAI) <> '') then
         begin
            msg := 'Fabrication des EAI';
            //if copy(version, 1, 1) <> 'V' then
            //   version := 'V' + version;
            ForceDirectories(Path);
            Tsl := TstringList.Create;
            try
               tsl.loadfromfile(EAI + 'DelosQPMAgent.Providers.xml');
               S := Tsl.text;

               transforme('URL', Pantin + version + '/DelosQPMAgent.dll/Batch', S);
               transforme('Sender', Sender, S);
               transforme('Database', Database, S);
               transforme('LAST_VERSION', Inttostr(GenId), S);
               Tsl.Text := S;
               tsl.savetofile(Path + '\DelosQPMAgent.Providers.xml');

               tsl.loadfromfile(EAI + 'DelosQPMAgent.Subscriptions.xml');
               S := Tsl.text;
               transforme('URL', Pantin + version + '/DelosQPMAgent.dll/Extract', S);
               transforme('GetCurrentVersion', Pantin + version + '/DelosQPMAgent.dll/GetCurrentVersion', S);

               transforme('Sender', Sender, S);
               transforme('Database', database, S);
               transforme('LAST_VERSION', Inttostr(genidpantin), S);
               Tsl.Text := S;
               tsl.savetofile(Path + '\DelosQPMAgent.Subscriptions.xml');

               tsl.loadfromfile(EAI + 'DelosQPMAgent.InitParams.xml');
               S := Tsl.text;
               transforme('QPM_BatchException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
               transforme('QPM_ExtractException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
               transforme('QPM_PullDone', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
               transforme('QPM_PullException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
               transforme('QPM_PushDone', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
               transforme('QPM_PushException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
               Tsl.Text := S;
               tsl.savetofile(Path + '\DelosQPMAgent.InitParams.xml');
            finally
               tsl.free;
            end;
         end;
      finally
         ini.free;
      end;
   except
      on E: Exception do
      begin
         msg := E.Message;
      end;
   end;
end;

procedure TInstall_Thr.TotalPcent(Sender: TObject; TotalSize: Int64;
   PerCent: Integer);
begin
   msg := 'Ziping en cours ' + Inttostr(PerCent) + '% ';
end;

procedure TInstall_Thr.Execute;
var
   s: string;
   src, dst: string;
   stkOrdre: string;
   tsl: tstringList;
   rep, Nom: string;
   Option: string;
   LstFile: string;
   Pwd:string;
   tslLog:Tstringlist;
   Result7Zip : integer;

   procedure recherche(rep, path: string);
   var
      f: TSearchRec;
   begin
      if FindFirst(rep + '*.*', FaAnyFile, f) = 0 then
      begin
         repeat
            if f.Attr and faDirectory = faDirectory then
            begin
               if f.name[1] <> '.' then
                Begin
                 recherche(rep + f.name + '\', path + f.name + '\');
                End;
            end
            else
            begin
              msg := 'Zipping : Adding ' + f.name;
              //if LstFile <> '' then LstFile := LstFile + ',';
              //LstFile := LstFile + '"' + IncludeTrailingPathDelimiter(Rep) + f.name + '"';
            end;
         until FindNext(f) <> 0;
      end;
      FindClose(f);
   end;

begin
  { Placez le code du thread ici}
   running := true;
   debug := '';
   while running do
   begin
      if LastOrdre = '' then
      begin
         try
            GetOrdre;
         except
         end;
         // traitement des ordres
         if LastOrdre <> '' then
         begin
            stkOrdre := LastOrdre;
            try
               LastCall := Now;
               msg := LastOrdre;
               if pos(';', LastOrdre) > 0 then
               begin
                  s := copy(LastOrdre, 1, pos(';', LastOrdre) - 1);
                  delete(LastOrdre, 1, pos(';', LastOrdre));
                  if pos('¤', LastOrdre) > 0 then
                  begin
                     Option := copy(LastOrdre, pos('¤', LastOrdre) + 1, 255);
                     LastOrdre := Copy(LastOrdre, 1, pos('¤', LastOrdre) - 1);
                  end
                  else
                     Option := '';

                  if s = 'COPY' then
                  begin
                     src := copy(LastOrdre, 1, pos(';', LastOrdre) - 1);
                     delete(LastOrdre, 1, pos(';', LastOrdre));
                     dst := LastOrdre;
                     doing := 'Copy';
                     msg := 'Copy de ' + src + ' vers ' + dst;
                     tsl := TstringList.create;
                     tsl.add('COPY "' + SRC + '" "' + DST + '"');
                     tsl.add('dir *.* > un_' + Inttostr(id) + '.txt');
                     while FileExists(LecteurLame+':\Tech\WEB\un_' + Inttostr(id) + '.txt') do
                     begin
                        Deletefile(LecteurLame+':\Tech\WEB\un_' + Inttostr(id) + '.txt');
                        sleep(100);
                     end;
                     tsl.SaveToFile(LecteurLame+':\Tech\WEB\Go_' + Inttostr(id) + '.AAA');
                     tsl.Free;
                     while not FileExists(LecteurLame+':\Tech\WEB\un_' + Inttostr(id) + '.txt') do
                     begin
                        Sleep(100);
                     end;
                     LastTraitement := Doing;
                     doing := 'NONE';
                     LastCall := Now;
                  end
                  else if s = 'ADD_EAI' then
                  begin
                     doing := s;
                     tsl := TstringList.create;
                     while FileExists(LecteurLame+':\Tech\WEB\comm_' + Inttostr(id) + '.FINI') do
                     begin
                        Deletefile(LecteurLame+':\Tech\WEB\comm_' + Inttostr(id) + '.FINI');
                        sleep(100);
                     end;
                     nom := copy(LastOrdre, 1, pos(';', LastOrdre) - 1);
                     delete(LastOrdre, 1, pos(';', LastOrdre));
                     tsl.add('[ADD XML]');
                     tsl.add(nom + '\DelosQPMAgent.Databases.xml');
                     tsl.add('       <DataSource>');
                     nom := copy(LastOrdre, 1, pos(';', LastOrdre) - 1);
                     delete(LastOrdre, 1, pos(';', LastOrdre));
                     tsl.add('       		<Name>' + nom + '</Name>');
                     tsl.add('       		<Connected>False</Connected>');
                     tsl.add('       		<KeepConnection>False</KeepConnection>');
                     tsl.add('       		<Middleware>FIB</Middleware>');
                     tsl.add('       		<Params>');
                     tsl.add('       			<Param>');
                     tsl.add('       				<Name>SERVER NAME</Name>');
                     tsl.add('       				<Value>' + LastOrdre + '</Value>');
                     tsl.add('       			</Param>');
                     tsl.add('       			<Param>');
                     tsl.add('       				<Name>USER NAME</Name>');
                     tsl.add('       				<Value>GINKOIA</Value>');
                     tsl.add('       			</Param>');
                     tsl.add('       			<Param>');
                     tsl.add('       				<Name>PASSWORD</Name>');
                     tsl.add('       				<Value>ginkoia</Value>');
                     tsl.add('       			</Param>');
                     tsl.add('       		</Params>');
                     tsl.add('       	</DataSource>');
                     tsl.add('[FIN]');
                     tsl.SaveToFile(LecteurLame+':\Tech\WEB\comm_' + Inttostr(id) + '.OOO');
                     while not FileExists(LecteurLame+':\Tech\WEB\comm_' + Inttostr(id) + '.FINI') do
                     begin
                        Sleep(100);
                     end;
                     Sleep(500);
                     tsl.LoadFromFile(LecteurLame+':\Tech\WEB\comm_' + Inttostr(id) + '.FINI');
                     if tsl[0] <> 'OK' then
                     begin
                        LastError := tsl[0];
                        LastOrdreError := stkOrdre;
                     end;
                     tsl.free;
                     LastCall := Now;
                     LastTraitement := Doing;
                     doing := 'NONE';
                  end
                  else if s = 'MD' then
                  begin
                     doing := 'MD';
                     tsl := TstringList.create;
                     tsl.add('md "' + LastOrdre + '"');
                     tsl.add('dir *.* > un_' + Inttostr(id) + '.txt');
                     while FileExists(LecteurLame+':\Tech\WEB\un_' + Inttostr(id) + '.txt') do
                     begin
                        Deletefile(LecteurLame+':\Tech\WEB\un_' + Inttostr(id) + '.txt');
                        sleep(100);
                     end;
                     tsl.SaveToFile(LecteurLame+':\Tech\WEB\Go_' + Inttostr(id) + '.AAA');
                     tsl.Free;
                     while not FileExists(LecteurLame+':\Tech\WEB\un_' + Inttostr(id) + '.txt') do
                     begin
                        Sleep(100);
                     end;
                     LastCall := Now;
                     LastTraitement := Doing;
                     doing := 'NONE';
                  end
                  else if s = 'COPYALL' then
                  begin
                     doing := 'COPY ALL';
                     forcedirectories(LastOrdre);
                     src := copy(LastOrdre, 1, pos(';', LastOrdre) - 1);
                     delete(LastOrdre, 1, pos(';', LastOrdre));
                     dst := LastOrdre;
                     Copier(src, dst);
                     LastCall := Now;
                     LastTraitement := Doing;
                     doing := 'NONE';
                  end
                  else if s = 'R_GENE' then
                  begin
                     doing := 'RECUP GENE';
                     Recup_Generateur(LastOrdre);
                     LastTraitement := Doing;
                     LastCall := Now;
                     doing := 'NONE';
                  end
                  else if s = 'DEL_ALL' then
                  begin
                     doing := 'VIDAGE REP';
                     Supprime(LastOrdre);
                     LastTraitement := Doing;
                     LastCall := Now;
                     doing := 'NONE';
                  end
                  else if s = 'ZIP_REP' then
                  begin
                     tslLog := TStringList.Create;
                     try
                       tslLog.Add('Début Zip');
                       doing := 'Ziping';
                       // LastOrdre
                       rep := Copy(LastOrdre, 1, pos(';', LastOrdre) - 1);
                       tslLog.Add(Rep);

                       delete(LastOrdre, 1, pos(';', LastOrdre));
                       Nom := LastOrdre;
                       tslLog.Add(Nom);
                       //recherche(rep, '');
                       msg := 'Construction du zip en cours...';
                       if option = 'NOPSW' then
                        Pwd := ''
                       else
                        Pwd := '1082';
                       tslLog.Add('Avant Load');
                       IF NOT LoadSevenZipDLL THEN
                         tslLog.Add('Erreur Load');
                         
                       tslLog.Add('Après Load');
                       Result7Zip := SevenZipCreateArchive(application.Handle,
                                             ExtractFileName(nom),
                                             ExtractFilePath(nom),
                                             '"'+Rep+'"',
                                             true,
                                             6,
                                             True,
                                             False,
                                             Pwd,
                                             True);
                       tslLog.Add('Après zippage' + IntToStr(Result7Zip));
                        UnloadSevenZipDLL;
                       tslLog.Add('Après unLoad');
                       LastTraitement := Doing;
                       LastCall := Now;
                       doing := 'NONE';
                       tslLog.Add('Fin Zip');
                     finally
//                       tslLog.SaveToFile('C:\AccesBase.log');
                       tslLog.Free;
                     end;
                  end
                  else
                     LastTraitement := LastOrdre;
               end
               else
                  LastTraitement := LastOrdre;
            except
               on E: Exception do
               begin
                  LastError := E.Message;
                  LastOrdreError := stkOrdre;
                  LastTraitement := Doing;
                  doing := 'NONE';
               end;
            end;
         end;
         LastOrdre := '';
      end;
      sleep(100);
   end;
end;

procedure TInstall_Thr.GetOrdre;
begin
   if ordres.Count > 0 then
   begin
      LastOrdre := ordres[0];
      ordres.Delete(0);
   end;
end;

function TInstall_Thr.LecteurValeurIni(AFileIni, ASection, AIdent,
  ADefault: String): String;
//Fonction de lecture d'une valeur dans le fichier Ini
Var
  FichierIni  : TIniFile;
begin
  Try
    //Ouverture ou création du fichier ini
    FichierIni  := TIniFile.Create(AFileIni);

    //Lecteur de la valeur
    Result := FichierIni.ReadString(ASection, AIdent, ADefault);
  Finally
    FichierIni.Free;
    FichierIni  := nil;
  End;
end;

procedure TInstall_Thr.stop;
begin
   running := false;
end;

initialization
end.


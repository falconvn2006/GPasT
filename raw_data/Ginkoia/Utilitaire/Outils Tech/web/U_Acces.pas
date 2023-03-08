unit U_Acces;

interface

uses
   SevenZip,
   UInstallThr,
   Windows, Messages, SysUtils, Classes, HTTPApp, IBDatabase, Db, ExtCtrls,
   IBCustomDataSet, IBQuery, IBSQL, IniFiles;

type
   TWebModule1 = class(TWebModule)
      Tim_Nettoyage: TTimer;
      procedure WebModule1WA_ChxBaseAction(Sender: TObject;
         Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
      procedure Tim_NettoyageTimer(Sender: TObject);
      procedure WebModule1WA_QryAction(Sender: TObject; Request: TWebRequest;
         Response: TWebResponse; var Handled: Boolean);
      procedure WebModule1ThreadAction(Sender: TObject; Request: TWebRequest;
         Response: TWebResponse; var Handled: Boolean);
      procedure WebModuleCreate(Sender: TObject);
      procedure WebModule1WA_RecupGeneAction(Sender: TObject;
         Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
   private
    { Déclarations privées}
    //Fonction de lecture d'une valeur dans le fichier Ini
    FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String;

   public
    { Déclarations publiques}
      LecteurLame: String;
      id: integer;
      lesModules: array of TInstall_Thr;
      _WA_ChxBase: Boolean;
      _WA_Qry: boolean;
      _Thread: boolean;
      _WA_RecupGene: Boolean;
   end;

var
   WebModule1: TWebModule1;

implementation

{$R *.DFM}

procedure TWebModule1.WebModule1WA_ChxBaseAction(Sender: TObject;
   Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   Path: string;
   f: tsearchrec;
   s: string;
begin
   while _WA_ChxBase do
      Sleep(150);
   _WA_ChxBase := true;
   try

      Path := Request.QueryFields.Values['PATH'];
      if path = '' then
         path := LecteurLame+':\';
      path := IncludeTrailingBackslash(path);
      s := path + ';DIR;' + #13#10;
      if FindFirst(Path + '*.*', faanyfile, f) = 0 then
      begin
         repeat
            if f.Attr and faDirectory = faDirectory then
            begin
               if (f.name <> '.') and (f.name <> '..') then
                  s := s + path + f.Name + '\;DIR;' + f.Name + #13#10;
            end
            else if uppercase(extractfileext(f.name)) = '.IB' then
               s := s + path + f.Name + '\;FIC;' + f.Name + #13#10
            else if uppercase(extractfileext(f.name)) = '.GDB' then
               s := s + path + f.Name + '\;FIC;' + f.Name + #13#10
         until findnext(f) <> 0
      end;
      findclose(f);
      response.content := s;
      response.SendResponse;
      Handled := s <> '';
   finally
      _WA_ChxBase := false;
   end;
end;

function TWebModule1.LecteurValeurIni(AFileIni, ASection, AIdent,
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

procedure TWebModule1.Tim_NettoyageTimer(Sender: TObject);
var
   i, j: integer;
begin
   i := 0;
   while i <= high(lesModules) do
   begin
      if (lesModules[i].doing = 'NONE') and (lesModules[i].LastCall < now - (1 / 24 / 6)) then
      begin
         lesModules[i].stop;
         for j := i to high(lesModules) - 1 do
            lesModules[j] := lesModules[j + 1];
         SetLength(lesModules, high(lesModules));
      end
      else
         inc(i);
   end;
end;

procedure TWebModule1.WebModule1WA_QryAction(Sender: TObject;
   Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   _data: TIBDatabase;
   _tran: TIBTransaction;
   _Qry: TIBQuery;
   s: string;
   count: integer;
   actu: integer;
   i: integer;
   base, qry: string;
begin
   while _WA_Qry do
      sleep(150);
   _WA_Qry := true;
   try
      Base := Request.QueryFields.Values['BASE'];
      QRY := Request.QueryFields.Values['QRY'];
      Request.QueryFields.Values['COUNT'];
      if Request.QueryFields.Values['COUNT'] = '' then
         count := -1
      else
         count := strtoint(Request.QueryFields.Values['COUNT']);
      try
         _data := TIBDatabase.create(self);
         _tran := TIBTransaction.create(self);
         _data.DefaultTransaction := _tran;
         _tran.DefaultDatabase := _data;
         _data.SQLDialect := 3;
         _data.Params.values['user_name'] := 'sysdba';
         _data.Params.values['password'] := 'masterkey';
         _data.DatabaseName := Base;
         _data.LoginPrompt := false;
      except
         Handled := true;
         response.content := 'erreur en création';
         response.SendResponse;
         EXIT;
      end;
      try
         _data.Open;
         _tran.Active := true;
      except
         Handled := true;
         response.content := 'erreur à l''ouverture';
         response.SendResponse;
         EXIT;
      end;
      try
         _Qry := TIBQuery.create(self);
         _Qry.Database := _data;
         _Qry.SQL.text := QRY;
      except
         Handled := true;
         response.content := 'erreur création query';
         response.SendResponse;
         EXIT;
      end;
      if Request.QueryFields.Values['SPE'] = 'EXEC' then
      begin
         try
            _Qry.ExecSQL;
            Handled := true;
            response.content := '<RESULT>OK</RESULT>';
            response.SendResponse;
         except
            Handled := true;
            response.content := '<RESULT>ERREUR</RESULT>';
            response.SendResponse;
         end;
      end
      else
      begin
         try
            _Qry.Open;
         except
            Handled := true;
            response.content := 'erreur ouverture query';
            response.SendResponse;
            EXIT;
         end;
         try
            _Qry.first;
            actu := 1;
            s := '<result>';
            while not _qry.eof do
            begin
               s := s + '<ENR>';
               for i := 0 to _Qry.FieldCount - 1 do
               begin
                  s := s + '<' + _Qry.Fields[i].FieldName + '>';
                  s := s + _Qry.Fields[i].AsString;
                  s := s + '</' + _Qry.Fields[i].FieldName + '>';
               end;
               _Qry.Next;
               s := s + '</ENR>';
               inc(actu);
               if (count <> -1) and (actu > count) then
                  BREAK;
            end;
            s := s + '</result>';
            _Qry.close;
         except
            Handled := true;
            response.content := 'erreur lecture query';
            response.SendResponse;
            EXIT;
         end;
      end;
      try
         if _tran.InTransaction then
            _tran.Commit;
         _data.Connected := false;
         _Qry.free;
         _tran.free;
         _data.free;
         Handled := s <> '';
         response.content := s;
         response.SendResponse;
      except
         Handled := true;
         response.content := 'erreur finallisation';
         response.SendResponse;
         EXIT;
      end;
   finally
      _WA_Qry := false;
   end;
end;

procedure TWebModule1.WebModule1ThreadAction(Sender: TObject;
   Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   thid: string;
   i: integer;
   what: string;
   thr: TInstall_Thr;
   quoi: string;
   OPTION: string;
begin
   while _Thread do
      sleep(150);
   _Thread := true;
   try
      thid := Request.QueryFields.Values['ID'];
      thr := nil;
      if thid = '' then
      begin
    // création du thread
         thid := Inttostr(id); inc(id);
         thr := TInstall_Thr.create(false, strtoint(thid));
         SetLength(lesModules, high(lesModules) + 2);
         lesModules[high(lesModules)] := thr;
      end
      else
      begin
         i := 0;
         while i <= high(lesModules) do
         begin
            if thid = inttostr(lesModules[i].id) then
            begin
               thr := lesModules[i];
            end;
            inc(i);
         end;
      end;
      if thr = nil then
      begin
         Handled := true;
         response.content := '<result><thr>' + thid + '</thr><error>thread non présent</error></result>';
         response.SendResponse;
         EXIT;
      end;
      what := Request.QueryFields.Values['WHAT'];
      if what = '' then
      begin
         Handled := true;
         response.content := '<result><thr>' + thid + '</thr><error>pas d''ordre</error></result>';
         response.SendResponse;
         EXIT;
      end;
      if what = 'QUOI' then
      begin
         Handled := true;
         try
            response.content := '<result><thr>' + thid + '</thr>' +
               '<QUOI><LAST>' + thr.LastTraitement + '</LAST>' +
               '<ENCOURS>' + thr.doing + '</ENCOURS>' +
               '<MSG>' + thr.msg + '</MSG>' +
               '<RESTE>' + inttostr(thr.ordres.count) + '</RESTE>' +
               '<LASTERROR>' + thr.LastError + '</LASTERROR>' +
               '<LASTTRAITEMENTERROR>' + thr.LastOrdreError + '</LASTTRAITEMENTERROR>' +
               '</QUOI></result>';
            response.SendResponse;
         except
            on E: Exception do
            begin
               response.content := '<result><thr>' + thid + '</thr>' +
                  '<LASTERROR>' + E.Message + '</LASTERROR>' +
                  '<LASTTRAITEMENTERROR></LASTTRAITEMENTERROR>' +
                  '</result>';
               response.SendResponse;
            end;
         end;
         EXIT;
      end;
      if what = 'ORDRE' then
      begin
         quoi := Request.QueryFields.Values['QUOI'];
         if quoi = '' then
         begin
            Handled := true;
            response.content := '<result><thr>' + thid + '</thr><error>pas de sous ordre</error></result>';
            response.SendResponse;
            EXIT;
         end;
         OPTION := Request.QueryFields.Values['OPTION'];
         if Option <> '' then
            thr.AddOrdre(quoi + '¤' + Option)
         else
            thr.AddOrdre(quoi);
         Handled := true;
         response.content := '<result><thr>' + thid + '</thr><MSG>En cours</MSG><ORDRE>' + quoi + '</ORDRE></result>';
         response.SendResponse;
         EXIT;
      end;
      response.content := '<result><thr>' + thid + '</thr><error>Non compris</error></result>';
      response.SendResponse;
      Handled := true;
   finally
      _Thread := false;
   end;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
   LecteurLame := LecteurValeurIni(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'AccesBase.ini','GENERAL','LecteurLame','D');
   id := 1;
   _WA_ChxBase := false;
   _WA_Qry := false;
   _Thread := false;
   _WA_RecupGene := false;
end;

procedure TWebModule1.WebModule1WA_RecupGeneAction(Sender: TObject;
   Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   _Plage_pantin,
      _Plage_Magasin: string;
   _NumMagasin: string;
   _Path,
      _Sender,
      _Database,
      _Eai,
      _Pantin,
      _version: string;
   thid: string;
   _data: string;
   thr: TInstall_Thr;
   i: integer;
begin
   while _WA_RecupGene do
      sleep(150);
   _WA_RecupGene := true;
   try
      thid := Request.QueryFields.Values['ID'];
      thr := nil;
      if thid = '' then
      begin
    // création du thread
         thid := Inttostr(id); inc(id);
         thr := TInstall_Thr.create(false, strtoint(thid));
         SetLength(lesModules, high(lesModules) + 2);
         lesModules[high(lesModules)] := thr;
      end
      else
      begin
         i := 0;
         while i <= high(lesModules) do
         begin
            if thid = inttostr(lesModules[i].id) then
            begin
               thr := lesModules[i];
            end;
            inc(i);
         end;
      end;
      if thr = nil then
      begin
         Handled := true;
         response.content := '<result><thr>' + thid + '</thr><error>thread non présent</error></result>';
         response.SendResponse;
         EXIT;
      end;
      _Plage_pantin := Request.QueryFields.Values['PLAGE_PANTIN'];
      _Plage_Magasin := Request.QueryFields.Values['PLAGE_MAGASIN'];
      _NumMagasin := Request.QueryFields.Values['NUMMAGASIN'];
      _Path := Request.QueryFields.Values['PATH'];
      _Sender := Request.QueryFields.Values['SENDER'];
      _Database := Request.QueryFields.Values['DATABASE'];
      _Eai := Request.QueryFields.Values['EAI'];
      _Pantin := Request.QueryFields.Values['PANTIN'];
      _version := Request.QueryFields.Values['VERSION'];
      _data := Request.QueryFields.Values['DATA'];
      thr.AddOrdre('R_GENE;' + _Plage_pantin + ';' + _Plage_Magasin + ';' + _NumMagasin + ';' +
         _Path + ';' + _Sender + ';' + _Database + ';' + _Eai + ';' + _Pantin + ';' + _version + ';' + _data);
      response.content := '<result><thr>' + thid + '</thr><MSG>En cours</MSG></result>';
      response.SendResponse;
      Handled := true;
   finally
      _WA_RecupGene := false;
   end;
end;

end.


unit FDSqliteManger;

interface

uses Data.FMTBcd,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Data.DB, Data.SqlExpr, Data.DbxSqlite, system.DateUtils, System.Generics.Collections,
  JclSysInfo, JclFileUtils, Vcl.Forms, System.Sqlite, FDSqliteTypes, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteWrapper, FireDAC.Stan.Param, FireDAC.Stan.Def, FireDAC.DApt;

type TFDSqliteManager = class
    private
      _link: TFDPhysSQLiteDriverLink;
      _conn: TFDConnection;
      _query: TFDQuery;
      _dbfilename: string;
      _CreateIfNotExist: boolean;
      class function CreateDBPath(dir: string): boolean;
      procedure LoadDBCreateCommands(var strs: TStringList);
      procedure ConnectToDatabase(dbfilename: string);
      procedure Disconnect;
      function RegexsOrderByToString(orderby: TRegexsOrderBy): string;
      function DefaultDir: string;
      function CreateDatabaseFile(out errorMessage: string): boolean;
      function IfThen(b: boolean; trueint, falseint: Integer): Integer;
      function CreateDefaultData: boolean;
    public
      procedure InsertRegex(var appRegex: TAppRegex; out errormessage: string; out success: boolean);
      procedure UpdateRegex(appRegex: TAppRegex; out errormessage: string; out success: boolean);
      procedure DeleteRegex(regexID: Integer; out errormessage: string; out success: boolean);
      procedure GetRegexs(var appRegexes: TList<TAppRegex>; out errormessage: string; out success: boolean; regexid: Integer = 0; searchText: string = ''; order: TRegexsOrderBy = robTitleAsc);


      procedure GetSettings(var settings: TDictionary<string, TAppSetting>; out errormessage: string; out success: boolean);
      procedure DeleteSetting(out errormessage: string;
                                       out success: boolean;
                                       SettingID: Int64 = -1;
                                       SettingName: string = '');
      procedure UpdateSetting(appSetting: TAppSetting; Active: boolean; out errormessage: string; out success: boolean);
      procedure UpdateSettings(appSettings: TDictionary<string, TAppSetting>; out errormessage: string; out success: boolean);
      procedure InsertSetting(var appSetting: TAppSetting; out errormessage: string; out success: boolean);


      Constructor Create(dbfilename : string; CreateIfNotExist: boolean);
      Destructor  Destroy; override;
end;

implementation

constructor TFDSqliteManager.Create(dbfilename: string; CreateIfNotExist: boolean);
begin
   _link := TFDPhysSQLiteDriverLink.Create(nil);
   _link.EngineLinkage := slStatic;
   _conn := TFDConnection.Create(nil);
   _conn.DriverName:='Sqlite';
   _query:=TFDQuery.Create(nil);
   _query.Connection:=_conn;
  _dbfilename := dbfilename;
  _CreateIfNotExist:= CreateIfNotExist;

  if (self.CreateDBPath(ExtractFileDir(self._dbfilename))) then begin
     ConnectToDatabase(dbfilename);
  end
  else begin
     raise Exception.Create('Failed to created DB file');
  end;
end;

Destructor TFDSqliteManager.Destroy;
begin
   Disconnect;
   _query.Free;
   _conn.Free;
   _link.Free;
end;


function TFDSqliteManager.DefaultDir: string;
begin
    result:=ExtractFileDir(self._dbfilename);
end;

class function TFDSqliteManager.CreateDBPath(dir: string): boolean;
begin
   if not(DirectoryExists(dir)) then
      result:=ForceDirectories(dir)
   else
      result:=true;
end;

procedure TFDSqliteManager.ConnectToDatabase(dbfilename: string);
var
   err: string;
begin

  if(self._conn.Connected) then
   exit;

   try
       with self._conn do begin
         Close;
         with Params do begin
           Clear;
           _conn.DriverName:='SQLite';
           Values['Database']:=dbfilename;
         end;
         Open;

         if (not(FileExists(dbfilename))) or (FileGetSize(dbfilename) = 0) then begin
            if(CreateDatabaseFile(err)) then begin
               self.CreateDefaultData;
            end;
         end;
       end;

   except
       raise Exception.Create('Failed to connect to DB file: ' + dbfilename);
   end;

end;

procedure TFDSqliteManager.Disconnect;
begin
  _conn.Close;
end;

function TFDSqliteManager.CreateDatabaseFile(out errorMessage: string): boolean;
var
  sqlcommands: TStringList;
  i: Integer;
begin
    sqlcommands:=TStringList.Create;
    try
      try
          LoadDBCreateCommands(sqlcommands);
          sqlcommands.SaveToFile(DefaultDir + '\createdbcommand.txt');
          for i := 0 to sqlcommands.Count-1 do begin
            _conn.ExecSQL(sqlcommands[i], []);
          end;

      except
        on E: Exception do
        begin
          errorMessage:=E.Message;
          result:=false;
          exit;
        end;
      end;
    finally
      sqlcommands.Free;
    end;
    errorMessage:='';
    result:=true;
end;






procedure TFDSqliteManager.InsertRegex(var appRegex: TAppRegex; out errormessage: string; out success: boolean);
var
  cmd: TStringList;
  UnixUTCDateTime: Int64;
begin

  cmd:=TStringList.Create;
  try
    cmd.Add('INSERT INTO main.regexlib (title, created, modified, opencount, savecount, runcount, expression, flag_ignorecase, flag_singleline, flag_multiline, flag_ignorepatternspace, flag_explicitcapture, flag_notempty) ');
    cmd.Add('VALUES (:TITLE, :CREATED, :MODIFIED , 1, 1, 0, :EXPRESSION, :FLAG_IGNORECASE , :FLAG_SINGLELINE, :FLAG_MULTILINE, :FLAG_IGNOREPATTERNSPACE, :FLAG_EXPLICITCAPTURE, :FLAG_NOTEMPTY)');
    UnixUTCDateTime:=DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now), true);

    try
       _conn.ExecSQL(cmd.Text, [appRegex.Title,
                                    UnixUTCDateTime,
                                    UnixUTCDateTime,
                                    appRegex.Expression,
                                    IfThen(appRegex.Flag_IgnoreCase, 1, 0),
                                    IfThen(appRegex.Flag_SingeLine, 1, 0),
                                    IfThen(appRegex.Flag_MultiLine, 1, 0),
                                    IfThen(appRegex.Flag_IgnorePatternSpace, 1, 0),
                                    IfThen(appRegex.Flag_ExplicitCapture, 1, 0),
                                    IfThen(appRegex.Flag_NotEmpty, 1, 0)]);

       appRegex.DBExpressionID:=Int64(_conn.GetLastAutoGenValue(''));
    except
      on E: Exception do begin
        errormessage:=E.Message;
        success:=false;
        exit;
      end;
    end;

  finally
    cmd.Free;
  end;

  errormessage:='';
  success:=true;
end;

procedure TFDSqliteManager.UpdateRegex(appRegex: TAppRegex; out errormessage: string; out success: boolean);
var
  cmd: TStringList;
  UnixUTCDateTime: Int64;
 // dbregexid: Integer;
begin

  if(appRegex.DBExpressionID=0) then begin
    success:=false;
    errormessage:='';
  end;

  cmd:=TStringList.Create;
  try
    cmd.Add('UPDATE main.regexlib SET ');
    cmd.Add('title=:TITLE, ');
    cmd.Add('modified=:MODIFIED, ');
    cmd.Add('savecount=savecount+1, ');
    cmd.Add('expression=:EXPRESSION, ');
    cmd.Add('flag_ignorecase=:FLAG_IGNORECASE, ');
    cmd.Add('flag_singleline=:FLAG_SINGLELINE,');
    cmd.Add('flag_multiline=:FLAG_MULTILINE, ');
    cmd.Add('flag_ignorepatternspace=:FLAG_IGNOREPATTERNSPACE, ');
    cmd.Add('flag_explicitcapture=:FLAG_EXPLICITCAPTURE, ');
    cmd.Add('flag_notempty=:FLAG_NOTEMPTY ');
    cmd.Add('WHERE regexid=:REGEXID;');

    UnixUTCDateTime:=DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now), true);

    try

      _conn.ExecSQL(cmd.Text , [appRegex.Title,
                                 UnixUTCDateTime,
                                 appRegex.Expression,
                                 IfThen(appRegex.Flag_IgnoreCase, 1, 0),
                                 IfThen(appRegex.Flag_SingeLine, 1, 0),
                                 IfThen(appRegex.Flag_MultiLine, 1, 0),
                                 IfThen(appRegex.Flag_IgnorePatternSpace, 1, 0),
                                 IfThen(appRegex.Flag_ExplicitCapture, 1, 0),
                                 IfThen(appRegex.Flag_NotEmpty, 1, 0),
                                 appRegex.DBExpressionID]);

    except
      on E: Exception do begin
        errormessage:=E.Message;
        success:=false;
        exit;
      end;
    end;
  finally
    cmd.Free;
  end;

  errormessage:='';
  success:=true;
end;

procedure TFDSqliteManager.DeleteRegex(regexID: Integer; out errormessage: string; out success: boolean);
var
  cmd: TStringList;
begin

  if(regexID<=0) then begin
    success:=false;
    errormessage:='DBExpressionID not specified';
    exit;
  end;

  cmd:=TStringList.Create;
  try
    cmd.Add('DELETE FROM main.regexlib WHERE regexid=:REGEXID;');

    try
      _conn.ExecSQL(cmd.Text, [regexID]);
    except
      on E: Exception do begin
        errormessage:=E.Message;
        success:=false;
        exit;
      end;
    end;
  finally
    cmd.Free;
  end;

  errormessage:='';
  success:=true;
end;




function TFDSqliteManager.RegexsOrderByToString(orderby: TRegexsOrderBy): string;
begin

  case orderby of
    robTitleAsc: result:=' ORDER BY title ASC';
    robTitleDesc: result:=' ORDER BY title DESC';
    robDateCreatedAsc: result:=' ORDER BY created ASC';
    robDateCreatedDesc: result:=' ORDER BY created DESC';
    robModifiedAsc: result:=' ORDER BY modified ASC';
    robModifiedDesc: result:=' ORDER BY modified DESC';
    robOpenCountAsc: result:=' ORDER BY opencount ASC';
    robOpenCoundDesc: result:=' ORDER BY opencount DESC';
    robSaveCountAsc:  result:=' ORDER BY savecount ASC';
    robSaveCountDesc: result:=' ORDER BY savecount DESC';
    robRunCountAsc: result:=' ORDER BY runcount ASC';
    robRunCountDesc: result:=' ORDER BY runcount DESC';
    else result:=' ORDER BY title ASC';
  end;
end;

//IN THIER ORDER
//TABLE1 RCDATA table1-regexlib.txt
//TABLE2 RCDATA table2-valuetype.txt
//INSERTS2 RCDATA tableinsert-valuetypes.txt
//TABLE3 RCDATA table3-settings.txt
procedure TFDSqliteManager.LoadDBCreateCommands(var strs: TStringList);
var
  ResStream: TResourceStream;
  tmp1, tmp2: TStringList;
  i: Integer;
begin

  if(strs = nil) or (not Assigned(strs)) then begin
    exit;
  end;

  strs.Clear;
  tmp1:=TStringList.Create;
  tmp2:=TStringList.Create;

  ResStream := TResourceStream.Create(hInstance, 'DBTEMPLATE', RT_RCDATA);
  try

      tmp1.LoadFromStream(ResStream);

      for i := 0 to tmp1.Count - 1 do begin

         if(tmp1[i] = '----------') then begin
            strs.Add(tmp2.Text);
            tmp2.Clear;
            continue;
         end
         else begin
           tmp2.Add(tmp1[i]);
         end;

      end;

  finally
     tmp1.Free;
     tmp2.Free;
     ResStream.Free;
  end;

end;

function TFDSqliteManager.IfThen(b: boolean; trueint, falseint: Integer): Integer;
begin
  if(b) then result:=trueint
  else result:=falseint;
end;




procedure TFDSqliteManager.GetRegexs(var appRegexes: TList<TAppRegex>;
          out errormessage: string;
          out success: boolean;
          regexid: Integer = 0;
          searchText: string = '';
          order: TRegexsOrderBy = robTitleAsc);
var
  orderstr: string;
  appr: TAppRegex;
begin

   try
     orderstr:=RegexsOrderByToString(order);
     appRegexes.Clear;

     try
       if(regexid>0) then begin
          _query.Params.Clear;
          _query.SQL.Text:='SELECT * FROM main.regexlib WHERE regexid=:REGEXID ' + orderstr;
          _query.ParamByName('REGEXID').AsInteger:= regexid;
       end
       else begin
         if Length(searchText)>0 then begin
            _query.Params.Clear;
            _query.SQL.Text:='SELECT * FROM main.regexlib WHERE title LIKE :TITLESEARCH ' + orderstr;
            _query.ParamByName('TITLESEARCH').AsString:= '%'+searchText+'%';
         end
         else begin
            _query.Params.Clear;
            _query.SQL.Text:='SELECT * FROM main.regexlib ' + orderstr;
         end;
       end;

       try
         _query.Open;
          while not _query.Eof do begin
               appr:=TAppRegex.Create;
               appr.Title:=_query.FieldByName('title').AsString;
               appr.Expression:=_query.FieldByName('expression').AsString;
               appr.Flag_IgnoreCase:=_query.FieldByName('flag_ignorecase').AsInteger > 0;
               appr.Flag_SingeLine:=_query.FieldByName('flag_singleline').AsInteger > 0;
               appr.Flag_MultiLine:=_query.FieldByName('flag_multiline').AsInteger > 0;
               appr.Flag_IgnorePatternSpace:=_query.FieldByName('flag_ignorepatternspace').AsInteger > 0;
               appr.Flag_ExplicitCapture:=_query.FieldByName('flag_explicitcapture').AsInteger > 0;
               appr.Flag_NotEmpty:=_query.FieldByName('flag_notempty').AsInteger > 0;
               appr.DBExpressionID:=_query.FieldByName('regexid').AsInteger;
               appRegexes.Add(appr);
               _query.Next;
          end;

       except
         On E: Exception do begin
           errormessage:=E.Message;
           success:=false;
           exit;
         end;
       end;

     finally
       _query.Close;
     end;

     errormessage:='';
     success:=true;

   except
      On Ex: Exception do begin
        errormessage:=Ex.Message;
        success:=false;
        exit;
      end;
   end;

end;




procedure TFDSqliteManager.GetSettings(var settings: TDictionary<string, TAppSetting>;
          out errormessage: string;
          out success: boolean);
var
  setting: TAppSetting;
begin

   try
     settings.Clear;

     try
       _query.Params.Clear;
       _query.SQL.Text:='SELECT settingid, settingname, settingvalue, valuetypeid FROM main.settings WHERE active=1';

       try
         _query.Open;
          while not _query.Eof do begin
               setting:=TAppSetting.Create;
               setting.SettingName:=_query.FieldByName('settingname').AsString;
               setting.SettingValue:=_query.FieldByName('settingvalue').AsString;
               setting.SettingName:=_query.FieldByName('settingname').AsString;
               setting.SettingID:=_query.FieldByName('settingid').AsInteger;
               setting.SettingType:=TAppSettingType(_query.FieldByName('valuetypeid').AsInteger);

               if not (settings.ContainsKey(setting.SettingName)) then begin
                  settings.Add(setting.SettingName, setting);
               end;

               _query.Next;
          end;

       except
         On E: Exception do begin
           errormessage:=E.Message;
           success:=false;
           exit;
         end;
       end;

     finally
       _query.Close;
     end;

     errormessage:='';
     success:=true;

   except
      On Ex: Exception do begin
        errormessage:=Ex.Message;
        success:=false;
        exit;
      end;
   end;

end;

procedure TFDSqliteManager.DeleteSetting(out errormessage: string;
                                       out success: boolean;
                                       SettingID: Int64 = -1;
                                       SettingName: string = '');
var
  cmd: string;
begin

   SettingName := Trim(SettingName);

  if (SettingID = 0) and (Length(SettingName) = 0) then begin
    success:=false;
    errormessage:='Must supply at leadt one identifier';
    exit;
  end;

   try

      if (SettingID > 0) then begin
        cmd:='DELETE FROM main.settings WHERE settingid=:SETTINGID;';
        _conn.ExecSQL(cmd, [SettingID]);
      end
      else begin
        cmd:='DELETE FROM main.settings WHERE settingname=:SETTINGNAME;';
        _conn.ExecSQL(cmd, [SettingName]);
      end;

    except
      on E: Exception do begin
        errormessage:=E.Message;
        success:=false;
        exit;
      end;
    end;


  errormessage:='';
  success:=true;
end;



procedure TFDSqliteManager.UpdateSetting(appSetting: TAppSetting; Active: boolean; out errormessage: string; out success: boolean);
var
  cmd: TStringList;
  actv: Integer;
  affected: Integer;
begin

  if(Length(appSetting.SettingName)=0) then begin
    success:=false;
    errormessage:='';

  end;

  cmd:=TStringList.Create;
  try
    cmd.Add('UPDATE main.settings SET ');
    cmd.Add('settingvalue=:SETTINGVALUE, ');
    cmd.Add('active=:ACTIVE ');
    cmd.Add('WHERE settingname=:SETTINGNAME;');
    actv:=0;
    if(Active=true) then actv:=1;


    try

      affected:=_conn.ExecSQL(cmd.Text, [appSetting.SettingValue,
                                 actv,
                                 appSetting.SettingName]);

      if(affected=0) then begin
          //Do insert
          self.InsertSetting(appSetting, errormessage, success);
      end;

    except
      on E: Exception do begin
        errormessage:=E.Message;
        success:=false;
        exit;
      end;
    end;
  finally
    cmd.Free;
  end;

  errormessage:='';
  success:=true;
end;


procedure TFDSqliteManager.UpdateSettings(appSettings: TDictionary<string, TAppSetting>; out errormessage: string; out success: boolean);
var
  cmd: TStringList;
  Item: TPair<string, TAppSetting>;
  affected: Integer;
  tmp: TAppSetting;
begin

   cmd:=TStringList.Create;

   try
      cmd.Add('UPDATE main.settings SET ');
      cmd.Add('settingvalue=:SETTINGVALUE, ');
      cmd.Add('active=:ACTIVE ');
      cmd.Add('WHERE settingname=:SETTINGNAME;');

      for Item in appSettings do begin
         if(Length(Item.Value.SettingValue)=0) then continue;

         try
            affected:=_conn.ExecSQL(cmd.Text, [Item.Value.SettingValue,
                                 1,
                                 Item.Value.SettingName]);

            if(affected=0) then begin
               //Do insert
               tmp:=Item.Value;
               self.InsertSetting(tmp, errormessage, success);
            end;

         except
           on E: Exception do begin
             errormessage:=E.Message;
             success:=false;
             exit;
           end;
         end;
      end;
   finally
     cmd.Free;
   end;

  errormessage:='';
  success:=true;
end;



procedure TFDSqliteManager.InsertSetting(var appSetting: TAppSetting; out errormessage: string; out success: boolean);
var
  cmd: TStringList;
begin

  cmd:=TStringList.Create;
  try
    cmd.Add('INSERT INTO main.settings (settingname, settingvalue, valuetypeid, active) ');
    cmd.Add('VALUES (:SETTINGNAME, :SETTINGVALUE, :VALUETYPEID, 1)');

    try
       _conn.ExecSQL(cmd.Text, [appSetting.SettingName,
                                    appSetting.SettingValue,
                                    Integer(appSetting.SettingType)]);

       appSetting.SettingID:=Int64(_conn.GetLastAutoGenValue(''));
    except
      on E: Exception do begin
        errormessage:=E.Message;
        success:=false;
        exit;
      end;
    end;

  finally
    cmd.Free;
  end;

  errormessage:='';
  success:=true;
end;


function TFDSqliteManager.CreateDefaultData: boolean;
var
  appSetting: TAppSetting;
  errormessage: string;
  success: boolean;
  appRegex: TAppRegex;
begin
   appSetting:=TAppSetting.Create;
   appRegex:=TAppRegex.Create;
   try
      try
         appSetting.SettingName := 'AutoJumpToFirstResult';
         appSetting.SettingValue:= 'true';
         appSetting.SettingType := TAppSettingType.astBool;
         self.InsertSetting(appSetting, errormessage, success);

         appSetting.SettingName := 'AdjustToDarkMode';
         appSetting.SettingValue:= 'true';
         appSetting.SettingType := TAppSettingType.astBool;
         self.InsertSetting(appSetting, errormessage, success);

         appSetting.SettingName := 'RememberState';
         appSetting.SettingValue:= 'true';
         appSetting.SettingType := TAppSettingType.astBool;
         self.InsertSetting(appSetting, errormessage, success);


         appRegex.Title:='IPV4 Address';
         appRegex.Expression:='\b[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}\b';
         appRegex.Flag_IgnoreCase:=true;
         self.InsertRegex(appRegex, errormessage, success);

         appRegex.Title:='GUID';
         appRegex.Expression:='[0-9A-F]{8}[-][0-9A-F]{4}[-][0-9A-F]{4}[-][0-9A-F]{4}[-][0-9A-F]{12}';
         appRegex.Flag_IgnoreCase:=true;
         self.InsertRegex(appRegex, errormessage, success);

         appRegex.Title:='HTML Comment';
         appRegex.Expression:='<!--.*?-->';
         appRegex.Flag_IgnoreCase:=true;
         self.InsertRegex(appRegex, errormessage, success);

         appRegex.Title:='HTML Tag';
         appRegex.Expression:='</?[a-z][a-z0-9]*[^<>]*>';
         appRegex.Flag_IgnoreCase:=true;
         self.InsertRegex(appRegex, errormessage, success);

         appRegex.Title:='ISO 8601 Date Format';
         appRegex.Expression:='([0-9]{4})-([0-9]{2})-([0-9]{2})';
         appRegex.Flag_IgnoreCase:=true;
         self.InsertRegex(appRegex, errormessage, success);


      finally
         appSetting.Free;
         appRegex.Free;
      end;

      result:=true;
      exit;
   except
      result:=false;
      exit;
   end;

end;


end.

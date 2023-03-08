Unit UHTTP.methodes;

interface

uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext, Vcl.StdCtrls,System.JSON,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,System.SysUtils, System.Variants, System.Classes, System.Math,
  IdGlobal, IdHash, IdHashMessageDigest, Winapi.Windows;

Type TIntArray = array of Integer;
  TRegLog = Record
    id   : integer;
    host : string;
    app  : string;
    inst : string;
    srv  : string;
    mdl  : string;
    dos  : string;
    ref  : string;
    key  : string;
    lvl  : integer;
    tag  : string;
    md5  : string;
  public
    procedure CalculMD5;
  End;
  TRegLogArray = array of TRegLog;

procedure addInArray(var A:TIntArray;AInt:integer);
function AvgArray(A:TIntArray):string;
function Creation_Session(ausername,apwd:string):string;
// function CreateGuid: string;
function CreateUniqid:string;
function add_abonnement(uid,nom,host,app,inst,srv,mdl,dos,ref,key,tag:string):boolean;
function Get_CURRENT_TimeStamp(ACon:TFDConnection):TDateTime;
function Get_Databases(agrp:string):string;
function Get_Config_Abonnement(uid:string):string;
function stringify(astr:string):string;
procedure complete_abonnements(logid:integer;ACon:TFDConnection);

function Index_master_color(uid:string;tag:string):string;
function Index_master_progress(uid:string;tag:string):string;
function Index_master_values(uid:string;tag:string):string;
function Index_detail(uid:string;tag:string):string;
Function UpdateSession(uid:string;Con:TFDConnection):boolean;
function MinArray(A:TIntArray):string;
function MaxArray(A:TIntArray):string;

function Nettoyage_Cascade:string;
procedure Nettoyage_Cascade_session(usrid:integer;PCon:TFDConnection);
function DateTimeToUNIXTimeFAST(DelphiTime : TDateTime): LongWord;
// function historique_log_date(uid:string;logid:integer;startdatetime:TDatetime;limit:integer):string;
function historique_log(uid:string;logid,start,limit:integer):string;
function Sec2Time(var asec:int64):string;
function Get_MD5(value: string): string;
Function ISO8601ToDateTime(Value: String):TDateTime;

implementation

Uses Unit4, gestionLog,DataMod;

Function ISO8601ToDateTime(Value: String):TDateTime;
var FormatSettings: TFormatSettings;
begin
    GetLocaleFormatSettings(GetThreadLocale, FormatSettings);
    FormatSettings.DateSeparator := '-';
    FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
    Result := StrToDateTime(Value, FormatSettings);
end;


procedure TRegLog.CalculMD5;
begin
    md5 := Get_MD5(host+app+inst+srv+mdl+dos+ref+key);
end;

function Get_MD5(value: string): string;
var
    hashMessageDigest5 : TIdHashMessageDigest5;
begin
    hashMessageDigest5 := nil;
    try
        hashMessageDigest5 := TIdHashMessageDigest5.Create;
        Result := IdGlobal.IndyLowerCase ( hashMessageDigest5.HashStringAsHex ( value ) );
    finally
        hashMessageDigest5.Free;
    end;
end;

function Sec2Time(var asec:int64):string;
var time:int64;
begin
   time:=asec;
   if (time >= 31556926) then
     begin
       result := Format('%d an ',[time div 31556926]);
       time := time mod 31556926;
     end;
    if (time >= 86400) then
      begin
        result := result + Format('%d j ',[time div 86400]);
        time := time mod 86400;
      end;
    result := result + Format('%.2d:',[time div 3600]);
    if (time >= 3600) then time := time mod 3600;
    result := result + Format('%.2d:',[time div 60]);
    if (time >= 60)   then time := time mod 60;
    result := result + Format('%.2d',[time]);
end;


function DateTimeToUNIXTimeFAST(DelphiTime : TDateTime): LongWord;
begin
Result := Round((DelphiTime - 25569) * 86400);
end;

function stringify(astr:string):string;
begin
    result := StringReplace(astr,'\','\\',[rfReplaceAll]);
    result := StringReplace(result,'"','\"',[rfReplaceAll]);
end;

procedure addInArray(var A:TIntArray;AInt:integer);
begin
     SetLength(A,Length(A)+1);
     A[High(A)]:=Aint;
end;

function AvgArray(A:TIntArray):string;
var i:integer;
    avg:integer;
begin
     result:='';
     if Length(A)>0 then
        begin
           avg:=0;
           for i:= Low(A) to High(A) do
              avg:=avg+A[i];
           result := Format('%d',[round(avg/Length(A))]);
        end;
end;

function MinArray(A:TIntArray):string;
var i:integer;
    avg:integer;
begin
     result:='';
     if Length(A)>0 then
        begin
           result := Format('%d',[MinIntValue(A)]);
        end;
end;

function MaxArray(A:TIntArray):string;
var i:integer;
    avg:integer;
begin
     result:='';
     if Length(A)>0 then
        begin
           result := Format('%d',[MaxIntValue(A)]);
        end;
end;

function CreateUniqid:string;
var ligne: string;
    w,h:integer;
    str:string;
    i:integer;
begin
  Randomize;
  ligne:='';
  try
    w:=32;
    str := '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    repeat
        ligne := ligne + str[Random(Length(str)) + 1];
     until (Length(ligne) = w);
  finally
     result:=ligne;
  end;
end;

{
function CreateGuid: string;
var
  ID: TGUID;
begin
  Result := '';
  if CoCreateGuid(ID) = S_OK then
    Result := GUIDToString(ID);
end;
 }

function Get_User(sid:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    isValidUser : boolean;
    uSRID       : integer;
begin
    result:='';
end;

function Index_master_color(uid:string;tag:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    lvl         : integer;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
       try
          If not(UpdateSession(uid,PCon)) then raise Exception.Create('Session invalide');
          PQuery.SQL.Clear;
          PQuery.SQL.Add('SELECT TIMESTAMPDIFF(SECOND,log_update,current_timestamp) as deltas, log_lvl, log_freq FROM monitor.log_session');
          PQuery.SQL.Add(' join monitor.log_register on ses_id=reg_sesid');
          PQuery.SQL.Add(' join monitor.log_reglog on ril_regid=reg_id');
          PQuery.SQL.Add(' join monitor.log_log on ril_logid=log_id');
          PQuery.SQL.Add(' WHERE ses_uid=:uid and reg_tag=:tag');
          PQuery.ParamByName('uid').Asstring:=uid;
          PQuery.ParamByName('tag').Asstring:=tag;
          PQuery.open;
          lvl:=-1;
          if PQuery.IsEmpty then raise Exception.Create('Session non valide');
           while not(PQuery.eof) do
               begin
                    lvl:=max(lvl,Pquery.FieldByName('log_lvl').AsInteger);
                    if (Pquery.FieldByName('deltas').AsInteger>1.1*Pquery.FieldByName('log_freq').asinteger)   then lvl:=max(lvl,9);
                    if (Pquery.FieldByName('deltas').AsInteger>2*Pquery.FieldByName('log_freq').asinteger)     then lvl:=max(lvl,10);
                    PQuery.next;
               end;
            result:=result + Format('{"tag":"%s","color":"%d"}',[tag,lvl]);
       Except On E:Exception do
            begin
              result:=E.Message;
            end;
       end;
    finally
     PQuery.Close;
     PQuery.Free;
     PCon.Close;
     PCon.Free;
   end;
end;


function Index_detail(uid:string;tag:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    virgule     : string;
    color       : integer;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
       try
        If not(UpdateSession(uid,PCon)) then raise Exception.Create('Session invalide');
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT monitor.log_log.*, TIMESTAMPDIFF(SECOND,monitor.log_log.log_update,current_timestamp) as deltas FROM monitor.log_session');
        PQuery.SQL.Add(' join monitor.log_register on ses_id=reg_sesid');
        PQuery.SQL.Add(' join monitor.log_reglog on ril_regid=reg_id');
        PQuery.SQL.Add(' join monitor.log_log on ril_logid=log_id');
        PQuery.SQL.Add(' WHERE ses_uid=:uid and reg_tag=:tag');
        PQuery.ParamByName('uid').Asstring:=uid;
        PQuery.ParamByName('tag').Asstring:=tag;
        PQuery.open;
        if PQuery.IsEmpty then raise Exception.Create('Session non valide');
        virgule:='';
        while not(PQuery.eof) do
            begin
                color := Pquery.FieldByName('log_lvl').AsInteger;
                if (Pquery.FieldByName('deltas').AsInteger>1.1*Pquery.FieldByName('log_freq').asinteger)   then color:=max(color,9);
                if (Pquery.FieldByName('deltas').AsInteger>2*Pquery.FieldByName('log_freq').asinteger)     then color:=max(color,10);
                result:=result + virgule + Format('{"logid":"%d","host":"%s","app":"%s","inst":"%s","srv":"%s","mdl":"%s","dos":"%s","ref":"%s","key":"%s","val":"%s","lvl":"%d","color":"%d"}',[
                    PQuery.FieldByName('log_id').Asinteger,
                    Stringify(PQuery.FieldByName('log_host').AsString),
                    Stringify(PQuery.FieldByName('log_app').AsString),
                    Stringify(PQuery.FieldByName('log_inst').AsString),
                    Stringify(PQuery.FieldByName('log_srv').AsString),
                    Stringify(PQuery.FieldByName('log_mdl').AsString),
                    Stringify(PQuery.FieldByName('log_dos').AsString),
                    Stringify(PQuery.FieldByName('log_ref').AsString),
                    Stringify(PQuery.FieldByName('log_key').AsString),
                    Stringify(PQuery.FieldByName('log_val').AsString),
                    PQuery.FieldByName('log_lvl').Asinteger,
                    color
                    ]);
                virgule:=',';
                PQuery.next;
            end;
        result:='{"values":['+result+']}';
       Except On E:Exception do
            begin
              result:=E.Message;
            end;
       end;
    finally
     PQuery.Close;
     PQuery.Free;
     PCon.Close;
     Pcon.Free;
   end;
end;


function Index_master_values(uid:string;tag:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    // ses_id      : integer;
    Virgule     : string;
    Astr        : string;
    lvl         : integer;
    I: Integer;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
       try
        If not(UpdateSession(uid,PCon)) then raise Exception.Create('Session invalide');
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT TIMESTAMPDIFF(SECOND,monitor.log_log.log_update,current_timestamp) as deltas, log_key, log_val, log_lvl, log_freq FROM monitor.log_session');
        PQuery.SQL.Add(' join monitor.log_register on ses_id=reg_sesid');
        PQuery.SQL.Add(' join monitor.log_reglog on ril_regid=reg_id');
        PQuery.SQL.Add(' join monitor.log_log on ril_logid=log_id');
        PQuery.SQL.Add(' WHERE ses_uid=:uid and reg_tag=:tag');
        PQuery.ParamByName('uid').Asstring:=uid;
        PQuery.ParamByName('tag').Asstring:=tag;
        PQuery.open;
        lvl:=-1;
        Astr:='';
        Virgule:='';
        if PQuery.IsEmpty then raise Exception.Create('Session non valide');
        while not(PQuery.eof) do
            begin
                 lvl:=max(lvl,Pquery.FieldByName('log_lvl').AsInteger);
                 if (Pquery.FieldByName('deltas').AsInteger>1.1*Pquery.FieldByName('log_freq').asinteger)   then lvl:=9;
                 if (Pquery.FieldByName('deltas').AsInteger>2*Pquery.FieldByName('log_freq').asinteger) then lvl:=10;
                 Astr:= Astr + Virgule + '"' + Pquery.FieldByName('log_val').Asstring + '"';
                 Virgule:=',';
                 PQuery.next;
            end;
        PQuery.Close;
        result:=result + Format('{"tag":"%s","color":"%d","values":[%s]}',[tag,lvl,Astr]);
       Except On E:Exception do
            begin
              result:=E.Message;
            end;
       end;
    finally
     PQuery.Close;
     PQuery.Free;
     PCon.Close;
     PCon.Free;
   end;
end;

function Index_master_progress(uid:string;tag:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    ts          : TDateTime;
    ses_id      : integer;
    lvl         : integer;
    val         : integer;
    maxArr      : TIntArray;
    minArr      : TIntArray;
    avgArr      : TIntArray;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
       try
        If not(UpdateSession(uid,PCon)) then raise Exception.Create('Session invalide');
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT TIMESTAMPDIFF(SECOND,log_update,current_timestamp) as deltas, log_key, log_val, log_lvl, log_freq FROM monitor.log_session');
        PQuery.SQL.Add(' join monitor.log_register on ses_id=reg_sesid');
        PQuery.SQL.Add(' join monitor.log_reglog on ril_regid=reg_id');
        PQuery.SQL.Add(' join monitor.log_log on ril_logid=log_id');
        PQuery.SQL.Add(' WHERE ses_uid=:uid and reg_tag=:tag');
        PQuery.ParamByName('uid').Asstring:=uid;
        PQuery.ParamByName('tag').Asstring:=tag;
        PQuery.open;
        lvl:=-1;
        SetLength(minArr, 0);
        SetLength(maxArr, 0);
        SetLength(avgArr, 0);
        if PQuery.IsEmpty then raise Exception.Create('Session non valide');
        while not(PQuery.eof) do
            begin
                 lvl:=max(lvl,Pquery.FieldByName('log_lvl').AsInteger);
                 if (Pquery.FieldByName('deltas').AsInteger>1.1*Pquery.FieldByName('log_freq').asinteger)   then lvl:=9;
                 if (Pquery.FieldByName('deltas').AsInteger>2*Pquery.FieldByName('log_freq').asinteger) then lvl:=10;
                 if (Pquery.FieldByName('log_key').AsString='min') then
                     addInArray(minArr,Pquery.FieldByName('log_val').AsInteger);
                 if (Pquery.FieldByName('log_key').AsString='max') then
                     addInArray(maxArr,Pquery.FieldByName('log_val').AsInteger);
                 if (Pquery.FieldByName('log_key').AsString='avg') then
                     addInArray(avgArr,Pquery.FieldByName('log_val').AsInteger);
                 PQuery.next;
            end;
        result:=result + Format('{"tag":"%s","min":"%s","max":"%s","value":"%s","color":"%d"}',[tag,minArray(minArr),maxArray(maxArr),AvgArray(avgArr),lvl]);
       Except On E:Exception do
            begin
              result:=E.Message;
            end;
       end;
    finally
     PQuery.Close;
     PQuery.Free;
     PCon.Close;
     PCon.Free;
   end;
end;

function Get_CURRENT_TimeStamp(ACon:TFDConnection):TDateTime;
var PQuery      : TFDQuery;
begin
    result:=Now();
    PQuery := TFDQuery.Create(nil);
    try
      PQuery.Connection:=ACon;
      PQuery.SQL.Add('SELECT CURRENT_TIMESTAMP FROM DUAL');
      PQuery.open;
      if (PQuery.RecordCount=1) then
          result:=PQuery.Fields[0].asDateTime;
    finally
      PQuery.Close;
      PQuery.Free;
    end;
end;

Function UpdateSession(uid:string;Con:TFDConnection):boolean;
var PQuery : TFDQuery;
begin
    result := false;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=Con;
    try
      PQuery.Close;
      PQuery.SQL.Clear;
      PQuery.SQL.Add('UPDATE `monitor`.`log_session` SET ses_datem=current_timestamp WHERE ses_uid=:uid');
      PQuery.ParamByName('uid').Asstring:=uid;
      PQuery.ExecSQL;
      result:=PQuery.RowsAffected=1;
    finally
      PQuery.Close;
      PQuery.Free;
    end;
end;

// on vient d'ajouter un log_id
// il y a peut-etre des abonnements associé qu'il faut liés....
procedure complete_abonnements(logid:integer;ACon:TFDConnection);
var PQuery     : TFDQuery;
    AReg       : TRegLogArray;
    i:integer;
begin
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=ACon;
    try
      try
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT log_register.* FROM `monitor`.`log_session` ');
        PQuery.SQL.Add('JOIN log_register ON reg_sesid=ses_id ');
        PQuery.SQL.Add(' WHERE ses_datem-current_timestamp<86400');
        PQuery.open;
        setLength(AReg,0);
        i:=0;
        while not(PQuery.eof) do
            begin
               setLength(AReg,length(AReg)+1);
               AReg[i].id    := PQuery.FieldByName('reg_id').Asinteger;
               AReg[i].host  := PQuery.FieldByName('reg_host').AsString;
               AReg[i].app   := PQuery.FieldByName('reg_app').AsString;
               AReg[i].inst  := PQuery.FieldByName('reg_inst').AsString;
               Areg[i].srv   := PQuery.FieldByName('reg_srv').AsString;
               Areg[i].mdl   := PQuery.FieldByName('reg_mdl').AsString;
               Areg[i].dos   := PQuery.FieldByName('reg_dos').AsString;
               Areg[i].ref   := PQuery.FieldByName('reg_ref').AsString;
               Areg[i].key   := PQuery.FieldByName('reg_key').AsString;
               Areg[i].tag   := PQuery.FieldByName('reg_tag').AsString;
               Areg[i].lvl   := PQuery.FieldByName('reg_lvl').Asinteger;
               // Areg[i].CalculMd5;
               // Ca ne sert à rien de calculer tous les md5 il ne correspondent pas...
               // il faut faire des recherche sur host... , app inst.., module
               PQuery.Next;
               inc(i);
            end;
        PQuery.Close;
        for i:=0 to length(AReg)-1 do
          begin
            PQuery.SQL.Clear;
            PQuery.SQL.Add(Format('INSERT IGNORE INTO `monitor`.`log_reglog` (SELECT NULL, %d, log_id FROM `monitor`.`log_log` WHERE log_id=%d',[AReg[i].id,logid]));
            if (AReg[i].host<>'%') and (AReg[i].host<>'') then
              begin
                PQuery.SQL.Add(Format('AND log_host=''%s''',[AReg[i].host]));
              end;
            if (AReg[i].app<>'%') and (AReg[i].app<>'') then
              begin
                PQuery.SQL.Add(Format('AND log_app=''%s''',[AReg[i].app]));
              end;
            if (AReg[i].inst<>'%') and (AReg[i].inst<>'') then
              begin
                PQuery.SQL.Add(Format('AND log_inst=''%s''',[AReg[i].inst]));
              end;
            if (AReg[i].mdl<>'%') and (AReg[i].mdl<>'')  then
              begin
                PQuery.SQL.Add(Format('AND log_mdl=''%s''',[AReg[i].mdl]));
              end;
            if (AReg[i].dos<>'%') and (AReg[i].dos<>'')  then
              begin
                PQuery.SQL.Add(Format('AND log_dos=''%s''',[AReg[i].dos]));
              end;
            if (AReg[i].ref<>'%') and (AReg[i].ref<>'')  then
              begin
                PQuery.SQL.Add(Format('AND log_ref=''%s''',[AReg[i].ref]));
              end;
            if (AReg[i].key<>'%') and (AReg[i].key<>'') then
              begin
                PQuery.SQL.Add(Format('AND log_key=''%s''',[AReg[i].key]));
              end;
            PQuery.SQL.Add(')');
            PQuery.ExecSQL;
            log_write(PQuery.SQL.Text,el_Debug);
          end;
        Except On E:Exception do
            begin
               log_write(E.Message,el_Erreur);
            end;
      end;
      finally
        PQuery.Close;
        PQuery.Free;
      end;
end;



function historique_log_distinct(uid:string;logid:integer;startdatetime:TDatetime;limit:integer):string;
type THisto=record
       first : string;
       last  : string;
       nb    : Integer;
     end;

var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    count       : integer;
    virgule     : string;
    bnew        : boolean;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
       try
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT ses_id FROM `monitor`.`log_session` WHERE ses_uid=:ses_uid');
        PQuery.ParamByName('ses_uid').Asstring:=uid;
        PQuery.open;
        if PQuery.IsEmpty then raise Exception.Create('Session Non valide');

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT COUNT(*) FROM `monitor`.`log_value` WHERE val_logid=:logid');
        PQuery.ParamByName('logid').Asinteger:=logid;
        PQuery.open;
        count:=PQuery.Fields[0].AsInteger;
        PQuery.Close;
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT * FROM `monitor`.`log_value` WHERE val_logid=:logid AND val_date>:startdatetime order by val_id asc limit 0, :limit');
        PQuery.ParamByName('logid').Asinteger:=logid;
        PQuery.ParamByName('startdatetime').AsDateTime:=startdatetime;
        PQuery.ParamByName('limit').Asinteger:=limit;
        PQuery.open;
        result:=Format('{"count":"%d","values":[',[count]);
        virgule:='';
        while not(PQuery.eof) do
            begin
                 if bnew then

                 result:=result + virgule + Format('{"first":"%s","last":"%s","nb":%s","val":"%s","lvl":"%d"}',
                    [Pquery.fieldByName('val_date').Asstring,
                    Pquery.fieldByName('val_date').Asstring,
                    stringify(Pquery.fieldByName('val_val').AsString),
                    Pquery.fieldByName('val_lvl').Asinteger]);
                 virgule:=',';


                 PQuery.Next;
            end;
        result:= result + ']}';
        Except On E:Exception do
          result:=E.Message;
       end;
    finally
       PQuery.Close;
       PQuery.Free;
       PCon.Close;
       PCon.Free;
    end;
end;


function historique_log(uid:string;logid,start,limit:integer):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    count       : integer;
    virgule     :string;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
       try
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT ses_id FROM `monitor`.`log_session` WHERE ses_uid=:ses_uid');
        PQuery.ParamByName('ses_uid').Asstring:=uid;
        PQuery.open;
        if PQuery.IsEmpty then raise Exception.Create('Session Non valide');

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT COUNT(*) FROM `monitor`.`log_value` WHERE val_logid=:logid');
        PQuery.ParamByName('logid').Asinteger:=logid;
        PQuery.open;
        count:=PQuery.Fields[0].AsInteger;
        PQuery.Close;
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT * FROM `monitor`.`log_value` WHERE val_logid=:logid order by val_id desc limit :start, :limit');
        PQuery.ParamByName('logid').Asinteger:=logid;
        PQuery.ParamByName('start').Asinteger:=start;
        PQuery.ParamByName('limit').Asinteger:=limit;
        PQuery.open;
        result:=Format('{"count":"%d","values":[',[count]);
        virgule:='';
        while not(PQuery.eof) do
            begin
                 result:=result + virgule + Format('{"date":"%s","val":"%s","lvl":"%d"}',
                    [Pquery.fieldByName('val_date').Asstring,
                    stringify(Pquery.fieldByName('val_val').AsString),
                    Pquery.fieldByName('val_lvl').Asinteger]);
                 virgule:=',';
                 PQuery.Next;
            end;
        result:= result + ']}';
        Except On E:Exception do
          result:=E.Message;
       end;
    finally
       PQuery.Close;
       PQuery.Free;
       PCon.Close;
       PCon.Free;
    end;
end;

function add_abonnement(uid,nom,host,app,inst,srv,mdl,dos,ref,key,tag:string):boolean;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    ts          : TDateTime;
    ses_id      : integer;
    regid      : integer;
begin
    result:=false;
    PCon   := UDataMod.GetNewConnexion;
    {TFDConnection.Create(nil);
    PCon.Params.Clear;
    PCon.Params.Add(Format('Server=%s',[GHTTP.Server]));
    PCon.Params.Add(Format('User_Name=%s',[GHTTP.User_Name]));
    PCon.Params.Add(Format('Database=%s',[GHTTP.Database]));
    PCon.Params.Add(Format('Password=%s',[GHTTP.Password]));
    PCon.Params.Add(Format('DriverID=%s',[GHTTP.DriverID]));
    }
    ts:=Get_CURRENT_TimeStamp(PCon);
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
      try
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT ses_id FROM `monitor`.`log_session` WHERE ses_uid=:uid');
        PQuery.ParamByName('uid').Asstring:=uid;
        PQuery.open;
        if PQuery.IsEmpty then raise Exception.Create('Session Non valide');
        ses_id:=PQuery.FieldByName('ses_id').AsInteger;

        PQuery.Close;
        PQuery.SQL.Clear;
        PQuery.SQL.Add('DELETE FROM `monitor`.`log_register` WHERE reg_sesid=:ses_id AND reg_tag=:tag');
        PQuery.parambyName('ses_id').Asinteger  := ses_id;
        PQuery.parambyName('tag').Asstring     := tag;
        // log_write(PQuery.SQL.text,el_Debug);
        PQuery.ExecSQL;

        PQuery.Close;
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT * FROM `monitor`.`log_register` WHERE 0=1');
        PQuery.open;
        PQuery.Insert;
        //---------------------- INSERT INTO `monitor`.`log_register` ----------
        PQuery.FieldByName('reg_sesid').Asinteger  := ses_id;
        PQuery.FieldByName('reg_date').AsDateTime  := ts;
        PQuery.FieldByName('reg_host').AsString    := host;
        PQuery.FieldByName('reg_app').AsString     := app;
        PQuery.FieldByName('reg_inst').AsString    := inst;
        PQuery.FieldByName('reg_srv').AsString     := srv;
        PQuery.FieldByName('reg_mdl').AsString     := mdl;
        PQuery.FieldByName('reg_dos').AsString     := dos;
        PQuery.FieldByName('reg_ref').AsString     := ref;
        PQuery.FieldByName('reg_key').AsString     := key;
        PQuery.FieldByName('reg_tag').AsString     := tag;
        PQuery.FieldByName('reg_lvl').Asinteger    := 0;
        PQuery.FieldByName('reg_ntfid').Asinteger  := 0;
        PQuery.Post;
        regid:=PQuery.FieldByName('reg_id').AsInteger;
        // il faut matcher tous les enregistrements log_log correspondants à ce et les ajouter... dans log_reglog
        PQuery.Close;
        PQuery.SQL.Clear;
        PQuery.SQL.Add(Format('INSERT IGNORE INTO `monitor`.`log_reglog` (SELECT NULL, %d, log_id FROM `monitor`.`log_log` WHERE 1=1',[regid]));
        if (host<>'%') and (host<>'') then
          begin
            PQuery.SQL.Add(Format('AND log_host=''%s''',[host]));
          end;
        if (app<>'%') and (app<>'') then
          begin
            PQuery.SQL.Add(Format('AND log_app=''%s''',[app]));
          end;
        if (inst<>'%') and (inst<>'') then
          begin
            PQuery.SQL.Add(Format('AND log_inst=''%s''',[inst]));
          end;
        if (srv<>'%') and (srv<>'')  then
          begin
            PQuery.SQL.Add(Format('AND log_srv=''%s''',[srv]));
          end;
        if (mdl<>'%') and (mdl<>'')  then
          begin
            PQuery.SQL.Add(Format('AND log_mdl=''%s''',[mdl]));
          end;
        if (dos<>'%') and (dos<>'')  then
          begin
            PQuery.SQL.Add(Format('AND log_dos=''%s''',[dos]));
          end;
        if (ref<>'%') and (ref<>'')  then
          begin
            PQuery.SQL.Add(Format('AND log_ref=''%s''',[ref]));
          end;
        if (key<>'%') and (key<>'') then
          begin
            PQuery.SQL.Add(Format('AND log_key=''%s''',[key]));
          end;
        PQuery.SQL.Add(')');
        log_write(PQuery.SQL.text,el_Debug);
        PQuery.ExecSQL;
        result:=true;
      Except On E:Exception
        do begin
           log_write(E.Message,el_Erreur);
           result:=false;
        end;
      end;
   finally
     PQuery.Close;
     PQuery.Free;
     PCon.Close;
     PCon.Free;
   end;
end;


function Get_Config_Abonnement(uid:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    str         : string;
    virgule     : string;
begin
    // il faut quand meme que la uid soit valide
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
      try
        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT ses_id FROM `monitor`.`log_session` WHERE ses_uid=:ses_uid');
        PQuery.ParamByName('ses_uid').Asstring:=uid;
        PQuery.open;
        if PQuery.IsEmpty then raise Exception.Create('Session Non valide');

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_host from log_log');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_host').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;

        result:= Format('{"host":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_app from log_log');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_app').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;

        result:= result + Format(',"app":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_inst from log_log WHERE log_inst<>'''' ');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_inst').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;
        result:= result + Format(',"inst":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_srv from log_log WHERE log_srv<>'''' ');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_srv').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;
        result:= result + Format(',"srv":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_mdl from log_log WHERE log_mdl<>'''' ');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_mdl').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;
        result:= result + Format(',"mdl":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_dos from log_log WHERE log_dos<>'''' ');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_dos').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;
        result:= result + Format(',"dos":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_ref from log_log WHERE log_ref<>'''' ');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_ref').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;
        result:= result + Format(',"ref":[%s]',[str]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('SELECT distinct log_key from log_log WHERE log_key<>'''' ');
        PQuery.open;
        virgule:='';
        Str:='';
        while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('"%s"',[stringify(PQuery.FieldByName('log_key').asstring)]);
              virgule:=',';
              PQuery.next;
           end;
        PQuery.close;
        result:= result + Format(',"key":[%s]}',[str]);

        Except on E:Exception do
          begin
             result:=E.Message;
          end;
      end;
    finally
       PQuery.Close;
       PQuery.Free;
       PCon.Close;
       PCon.Free;
    end;
end;

function Get_Databases(agrp:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    str         : string;
    virgule     : string;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    {
    TFDConnection.Create(nil);
    PCon.Params.Clear;
    PCon.Params.Add(Format('Server=%s',[GHTTP.Server]));
    PCon.Params.Add(Format('User_Name=%s',[GHTTP.User_Name]));
    PCon.Params.Add(Format('Database=%s',[GHTTP.Database]));
    PCon.Params.Add(Format('Password=%s',[GHTTP.Password]));
    PCon.Params.Add(Format('DriverID=%s',[GHTTP.DriverID]));
    }
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
      try
         PQuery.SQL.Clear;
         PQuery.SQL.Add('SELECT * from log_database WHERE ldb_grp=:GRP');
         PQuery.ParamByName('GRP').AsString:=agrp;
         PQuery.open;
         virgule:='';
         while not(PQuery.eof) do
           begin
              Str := Str + virgule + Format('{"GROUPE":"%s","LAME":"%s","DOSSIER":"%s","GINKOIA":"%s","MONITOR":"%s"}',
                [
                  PQuery.FieldByName('ldb_grp').asstring,
                  PQuery.FieldByName('ldb_lame').asstring,
                  PQuery.FieldByName('ldb_dossier').asstring,
                  stringify(PQuery.FieldByName('ldb_ginkoia').asstring),
                  stringify(PQuery.FieldByName('ldb_monitor').asstring)
                ]);
              virgule:=',';
              PQuery.next;
           end;
          //------------------
          result:='['+ Str + ']';
          Except on E:Exception do
            begin
              result:=E.Message;
            end;
      end;
    finally
       PQuery.Close;
       PQuery.Free;
       PCon.Close;
       PCon.Free;
    end;
end;

function Nettoyage_Cascade:string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    str         : string;
    virgule     : string;
    i,j         : integer;
begin
    result:='';
    PCon   := UDataMod.GetNewConnexion;
    {
    TFDConnection.Create(nil);
    PCon.Params.Clear;
    PCon.Params.Add(Format('Server=%s',[GHTTP.Server]));
    PCon.Params.Add(Format('User_Name=%s',[GHTTP.User_Name]));
    PCon.Params.Add(Format('Database=%s',[GHTTP.Database]));
    PCon.Params.Add(Format('Password=%s',[GHTTP.Password]));
    PCon.Params.Add(Format('DriverID=%s',[GHTTP.DriverID]));
    }
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;

    try
         // ici netroyage des vielles sessions (+ de 12 heures)
        PQuery.SQL.Clear;
        PQuery.SQL.Add('DELETE FROM log_session WHERE ses_datem < DATE_SUB(current_timestamp(), INTERVAL 12 HOUR)');
        PQuery.ExecSQL;
        result:= result + Format('log_session : %d enregistrements effacés<br>',[PQuery.RowsAffected]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('DELETE FROM log_register WHERE reg_sesid NOT IN (SELECT ses_id from log_session)');
        PQuery.ExecSQL;
        result:= result + Format('log_register : %d enregistrements effacés<br>',[PQuery.RowsAffected]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('DELETE FROM log_reglog WHERE ril_regid NOT IN (SELECT reg_id FROM log_register);');
        PQuery.ExecSQL;
        result:= result + Format('log_reglog : %d enregistrements effacés<br>',[PQuery.RowsAffected]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('DELETE FROM log_reglog WHERE ril_logid NOT IN (SELECT log_id FROM log_log);');
        PQuery.ExecSQL;
        result:= result +#13+#10+ Format('log_reglog : %d enregistrements effacés<br>',[PQuery.RowsAffected]);

        PQuery.SQL.Clear;
        PQuery.SQL.Add('DELETE FROM log_value WHERE val_logid NOT IN (SELECT log_id from log_log);');
        PQuery.ExecSQL;
        result:= result +#13+#10+ Format('log_value : %d enregistrements effacés<br>',[PQuery.RowsAffected]);

    finally
      PQuery.Close;
      PQuery.Free;
      PCon.Close;
      PCon.Free;
    end;
end;

procedure Nettoyage_Cascade_session(usrid:integer;PCon:TFDConnection);
var PQuery   : TFDQuery;
    sesid    : integer;
    passe    : boolean;
    iArray   : TIntArray;
    i        : integer;
begin
     PQuery := TFDQuery.Create(nil);
     PQuery.Connection:=PCon;
     try
         PQuery.SQL.Clear;
         PQuery.SQL.Add('SELECT * FROM log_session WHERE ses_usrid=:usrid');
         PQuery.ParamByName('usrid').Asinteger := usrid;
         PQuery.open;
         passe := (PQuery.RecordCount=1);
         if passe then
            begin
                sesid:=PQuery.FieldByName('ses_id').AsInteger;

                PQuery.Close;
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT reg_id FROM log_register WHERE reg_sesid=:sesid');
                PQuery.ParamByName('sesid').Asinteger := sesid;
                PQuery.open;
                SetLength(iArray,0);
                while not(PQuery.Eof) do
                    begin
                      addinArray(iArray,PQuery.FieldByName('reg_id').asinteger);
                      PQuery.next;
                    end;

                For i:=0 to Length(iArray)-1 do
                  begin
                    PQuery.Close;
                    PQuery.SQL.Clear;
                    PQuery.SQL.Add('DELETE FROM log_reglog WHERE ril_regid=:regid');
                    PQuery.ParamByName('regid').Asinteger := iArray[i];
                    PQuery.ExecSQL;
                   end;

                PQuery.Close;
                PQuery.SQL.Clear;
                PQuery.SQL.Add('DELETE FROM log_register WHERE reg_sesid=:sesid');
                PQuery.ParamByName('sesid').Asinteger := sesid;
                PQuery.ExecSQL;

                PQuery.Close;
                PQuery.SQL.Clear;
                PQuery.SQL.Add('DELETE FROM log_session WHERE ses_usrid=:usrid');
                PQuery.ParamByName('usrid').Asinteger := usrid;
                PQuery.ExecSQL;
            end;
     finally
        PQuery.Close;
        PQuery.Free;
     end;
end;

function Creation_Session(ausername,apwd:string):string;
var PQuery      : TFDQuery;
    PCon        : TFDConnection;
    isValidUser : boolean;
    uSRID       : integer;
    uid         : string;
begin
    result:='';
    uSRID:=0;
    PCon   := UDataMod.GetNewConnexion;
    {
    TFDConnection.Create(nil);
    PCon.Params.Clear;
    PCon.Params.Add(Format('Server=%s',[GHTTP.Server]));
    PCon.Params.Add(Format('User_Name=%s',[GHTTP.User_Name]));
    PCon.Params.Add(Format('Database=%s',[GHTTP.Database]));
    PCon.Params.Add(Format('Password=%s',[GHTTP.Password]));
    PCon.Params.Add(Format('DriverID=%s',[GHTTP.DriverID]));
    }
    PQuery := TFDQuery.Create(nil);
    PQuery.Connection:=PCon;
    try
      try
          PQuery.SQL.Clear;
          PQuery.SQL.Add('SELECT usr_id FROM log_user WHERE usr_username=:username and usr_pwd=:pwd');
          PQuery.ParamByName('username').AsString:=ausername;
          PQuery.ParamByName('pwd').AsString:=apwd;
          PQuery.open;
          isValidUser:=PQuery.RecordCount=1;
          If not(PQuery.IsEmpty) then
             begin
                uSRID:=PQuery.FieldByName('usr_id').AsInteger;
             end;
          PQuery.Close;
          if isValidUser then
              begin
                // On ne nettoye plus les sessions...
                // Nettoyage_Cascade_session(usrid,PCon);

                uid:=CreateUniqid;
                result := Format('{"uid":"%s"}',[uid]);

                PQuery.SQL.Clear;
                PQuery.SQL.Add('INSERT INTO `log_session` (`ses_uid`,`ses_usrid`,`ses_datec`,`ses_datem`) VALUES (:SID,:UID,current_timestamp,current_timestamp);');
                PQuery.ParamByName('SID').AsString   := uid;
                PQuery.ParamByName('UID').Asinteger  := uSRID;
                PQuery.ExecSQL;

              end;
          Except on E:Exception do
            begin
                //
            end;
      end;
    finally
       PQuery.Close;
       PQuery.Free;
       PCon.Close;
       PCon.Free;
    end;
end;


end.

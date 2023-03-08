unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext, Vcl.StdCtrls,System.JSON,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IdIOHandler, IdIOHandlerStream, IniFiles,Math;

Const gtest    = '/monitor/test.html'  ;
      gmonitor = '/monitor/monitor.php';
type
  TLPages = (test,monitor,index,histo,config);
  TLogInsert = Record
    date : string;
    host : string;
    app  : string;
    inst : string;
    srv  : string;
    mdl  : string;
    dos  : string;
    ref  : string;
    key  : string;
    val  : string;
    lvl  : string;
    nb   : string;
    ovl  : boolean;
    freq : integer;
    md5  : string;
  public
    procedure Init;
    procedure CalculMd5;
  End;
  TForm3 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Panel2: TPanel;
    Panel_NbHit: TPanel;
    Timer1: TTimer;
    Panel_uptime: TPanel;
    Panel_Receive: TPanel;
    Panel_Send: TPanel;
    Panel_query_seconde: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IdHTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FIdHTTPServer : TIdHTTPServer;
    FServer    : string;
    FUser_Name : string;
    FDatabase  : string;
    FPassword  : string;
    FDriverID  : string;
    FStart     : LongWord;
    FUptime    : integer;
    FQuerySec  : integer;
    FNbHit     : integer;
    FsReceive  : int64;
    FsSend     : int64;
   procedure LoadIni;
   // procedure SetUpTime(Avalue:string);
   procedure SetNbHit(Avalue:integer);
   procedure Page_config_abonnement(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
   procedure Page_Abonnement(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
   procedure Page_Login(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
   procedure Page_Monitor(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
    { Déclarations privées }
  procedure Page_wsdatabases(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
  procedure Page_index(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
  procedure Page_Histo(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);

  public
//    Function ISO8601ToDateTime(Value: String):TDateTime;
    property SizeReceive : int64   read FsReceive  Write FsReceive;
    property SizeSend    : int64   read FsSend     Write FsSend;
    property QuerySec    : integer read FQuerySec  Write FQuerySec;
    property Hit         : integer read FNbHit     Write SetNbHit;
    property Server      : string  read FServer    write Fserver;
    property User_name   : string  read FUser_Name write FUser_name;
    property Database    : string  read FDatabase  write FDatabase;
    property Password    : string  read FPassword  write FPassword;
    property DriverID    : string  read FDriverID  write FDriverID;
    { Déclarations publiques }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

Uses DataMod, UHTTP.methodes, GestionLog;

procedure TForm3.SetNbHit(Avalue:integer);
begin
    FNbHit:=AValue;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
var FNow  : LongWord;
    Ftime : int64;
begin
     FNow  := DateTimeToUNIXTimeFAST(Now());
     Ftime := Fnow - FStart;

     Panel_uptime.Caption:=Sec2Time(Ftime);
     Panel_uptime.Refresh;

     Panel_Receive.Caption:=Format('%d ko',[SizeReceive div 1024]);
     Panel_Receive.Refresh;

     Panel_Send.Caption:=Format('%d ko',[SizeSend div 1024]);
     Panel_Send.Refresh;

     Panel_query_seconde.Caption:=Format('%d',[FQuerySec]);
     Panel_query_seconde.refresh;
     FQuerySec:=0;

     Panel_NbHit.Caption:=Format('%d',[FNbhit]);
     Panel_NbHit.refresh;

end;

procedure TForm3.LoadIni;
var Ini:TIniFile;
begin
//  Log_Write('LoadIni', el_Info);
//  Log_Write(VAR_GLOB.Exe_Directory + , el_Info);
    Ini := TIniFile.Create(ChangeFileExt(paramstr(0), '.ini'));
    try
       Server     := Ini.ReadString('DATABASE','Server','');
       User_name  := Ini.ReadString('DATABASE','user_name','');
       password   := Ini.ReadString('DATABASE','password','');
       Database   := Ini.ReadString('DATABASE','database','');
       DriverID   := Ini.ReadString('DATABASE','DriverID','');
    finally
       Ini.Free;
    end;
end;


procedure TLogInsert.Init;
begin
    date := '';
    host := '';
    app  := '';
    inst := '';
    srv  := '';
    mdl  := '';
    dos  := '';
    ref  := '';
    key  := '';
    val  := '';
    lvl  := '';
    nb   := '1';
    ovl  := true;
    freq := 86400;
end;


procedure TLogInsert.CalculMD5;
begin
    md5 := Get_MD5(host+app+inst+srv+mdl+dos+ref+key);
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
    Button1.Enabled:=false;
    FIdHTTPServer:=TIdHTTPServer.Create(Self);
    //--------------------------------
    FIdHTTPServer.DefaultPort:=8080;
    FIdHTTPServer.KeepAlive:=false;
    FIdHTTPServer.ServerSoftware:='GHTTP';
    FIdHTTPServer.OnCommandGet:=IdHTTPServerCommandGet;
    FidhttpServer.Active:=true;
    FidhttpServer.MaxConnections:=50;
    Memo1.Lines.Add('Serveur start');
    LoadIni;
    FStart:=DateTimeToUNIXTimeFAST(Now());
    FQuerysec   := 0;
    FsReceive   := 0;
    FsSend      := 0;
    FNbHit      := 0;
    Panel_Uptime.DoubleBuffered:=true;
    Panel_NbHit.DoubleBuffered:=true;
    Panel_query_seconde.DoubleBuffered:=true;
    Panel_receive.DoubleBuffered:=true;
    Panel_Send.DoubleBuffered:=true;
    Timer1.Enabled:=true;
    Button3.Enabled:=true;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
    Memo1.Lines.Clear;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
    try
       Button3.Enabled:=false;
       Timer1.Enabled:=false;
       FidhttpServer.Active:=false;
       FidhttpServer.Free;
    finally
      Button1.Enabled:=true;
      Memo1.Lines.Add('Serveur stop');
    end;
end;

procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose:=not(Timer1.Enabled);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
    Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
end;

procedure TForm3.Page_Monitor(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    LJSONArr    : TJSONArray;
    LJsonValue  : TJSONValue;
    LItem       : TJSONValue;
    ALogInsert  : TLogInsert;
    PQuery      : TFDQuery;
    PCon        : TFDConnection;
    log_id      : integer;
    val_id      : integer;
    bupdate     : boolean;
    log_lvl     : integer;
    log_val     : string;
begin
   Astr:=TStringList.Create;
   PQuery := TFDQuery.Create(nil);
   PCon   := TFDConnection.Create(nil);
   PCon.Params.Clear;
   PCon.Params.Add(Format('Server=%s',[Server]));
   PCon.Params.Add(Format('User_Name=%s',[User_Name]));
   PCon.Params.Add(Format('Database=%s',[Database]));
   PCon.Params.Add(Format('Password=%s',[Password]));
   PCon.Params.Add(Format('DriverID=%s',[DriverID]));
   try
      try
        ARequestInfo.PostStream.Seek(0, soFromBeginning);
        Astr.LoadFromStream(ARequestInfo.PostStream);
        // AStr.Text.Trim;
        LJSONArr := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AStr.Text), 0) as TJSONArray;
        try
          if LJSONArr<>nil then
          begin
          //----------------------------------------------------------------------//
          PQuery.Connection := PCon;
          for LJsonValue in LJsonArr do
           begin
              ALogInsert.Init;
              for LItem in TJSONArray(LJsonValue) do
                begin
                    if (TJSONPair(LItem).JsonString.Value='date') then
                      begin
                          ALogInsert.date:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='host') then
                      begin
                          ALogInsert.host:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='app') then
                      begin
                          ALogInsert.app:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='inst') then
                      begin
                          ALogInsert.inst:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='srv') then
                      begin
                          ALogInsert.srv:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='mdl') then
                      begin
                          ALogInsert.mdl:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='dos') then
                      begin
                          ALogInsert.dos:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='ref') then
                      begin
                          ALogInsert.ref:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='key') then
                      begin
                          ALogInsert.key:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='val') then
                      begin
                          ALogInsert.val:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='lvl') then
                      begin
                          ALogInsert.lvl:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='nb') then
                      begin
                          ALogInsert.nb:=TJSONPair(LItem).JsonValue.Value;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='ovl') then
                      begin
                          ALogInsert.ovl:=TJSONPair(LItem).JsonValue.Value.ToBoolean;
                      end
                    else if (TJSONPair(LItem).JsonString.Value='freq') then
                      begin
                          ALogInsert.freq:=TJSONPair(LItem).JsonValue.Value.ToInteger;
                      end;
              end;
              // On zappe
              // if (ALogInsert.host='') or (ALogInsert.app='') or (ALogInsert.key='')
              //    then continue;
              ALogInsert.CalculMD5;
              PQuery.Close;
              PQuery.SQL.Clear;
              PQuery.SQL.Add('SELECT * FROM monitor.log_log  ');
              PQuery.SQL.Add(' WHERE log_md5=:logmd5');
{             PQuery.SQL.Add('    AND  log_host=:host AND log_app=:app AND log_inst=:inst ');
              PQuery.SQL.Add('    AND  log_srv=:srv  AND log_mdl=:mdl AND log_dos=:dos  ');
              PQuery.SQL.Add('    AND  log_ref=:ref  AND log_key=:key                   ');
              PQuery.ParamByName('host').AsString     := ALogInsert.host;
              PQuery.ParamByName('app').AsString      := ALogInsert.app;
              PQuery.ParamByName('inst').AsString     := ALogInsert.Inst;
              PQuery.ParamByName('srv').AsString      := ALogInsert.srv;
              PQuery.ParamByName('mdl').AsString      := ALogInsert.mdl;
              PQuery.ParamByName('dos').AsString      := ALogInsert.dos;
              PQuery.ParamByName('ref').AsString      := ALogInsert.ref;
              PQuery.ParamByName('key').AsString      := ALogInsert.key;
}
              PQuery.ParamByName('logmd5').AsString := ALogInsert.md5;
              PQuery.Open;
              bupdate:=False;
              If (PQuery.RecordCount>1)
                 then raise Exception.Create('Trop d''enregistrements');
              If (PQuery.RecordCount<=0)
                    then
                      begin
                          // memo1.Lines.Add('Insert : ');
                          PQuery.Insert;
                          PQuery.FieldByName('log_create').AsDateTime := ISO8601ToDateTime(ALogInsert.Date);
                          PQuery.FieldByName('log_date').AsDateTime   := ISO8601ToDateTime(ALogInsert.Date);
                          PQuery.FieldByName('log_remoteip').AsString := ARequestInfo.RemoteIP;
                          PQuery.FieldByName('log_host').AsString     := ALogInsert.host;
                          PQuery.FieldByName('log_app').AsString      := ALogInsert.app;
                          PQuery.FieldByName('log_inst').AsString     := ALogInsert.Inst;
                          PQuery.FieldByName('log_srv').AsString      := ALogInsert.srv;
                          PQuery.FieldByName('log_mdl').AsString      := ALogInsert.mdl;
                          PQuery.FieldByName('log_dos').AsString      := ALogInsert.dos;
                          PQuery.FieldByName('log_ref').AsString      := ALogInsert.ref;
                          PQuery.FieldByName('log_key').AsString      := ALogInsert.key;
                          PQuery.FieldByName('log_val').AsString      := ALogInsert.val;
                          PQuery.FieldByName('log_lvl').AsString      := ALogInsert.lvl;
                          PQuery.FieldByName('log_nb').AsString       := ALogInsert.nb;
                          PQuery.FieldByName('log_hdl').Asinteger     := 0;
                          PQuery.FieldByName('log_freq').Asinteger    := ALogInsert.freq;
                          PQuery.FieldByName('log_md5').Asstring      := ALogInsert.md5;
                          PQuery.Post;
                          // -----------------------------------------------------
                          log_id:=PQuery.FieldByName('log_id').AsInteger;
                          // s'il y a des abonnements en cours.... sur ce log il faut ajouter la liaison
                          Complete_abonnements(log_id,PCon);
                          // -----------------------------------------------------
                      end;
              If (PQuery.RecordCount=1)
                 then
                   begin
                        log_val := PQuery.FieldByName('log_val').Asstring;
                        log_lvl := PQuery.FieldByName('log_lvl').AsInteger;
                        log_id  := PQuery.FieldByName('log_id').AsInteger;
                        {
                        PQuery.Edit;
                        PQuery.FieldByName('date').AsDateTime  := ISO8601ToDateTime(ALogInsert.Date);
                        PQuery.FieldByName('val').AsString     := ALogInsert.val;
                        PQuery.FieldByName('lvl').Asstring     := ALogInsert.lvl;
                        PQuery.FieldByName('freq').Asinteger   := ALogInsert.freq;
                        PQuery.FieldByName('logid').Asinteger  := log_id;
                        PQuery.Post;
                        }
                        bupdate:=true;
                   end;
              // bUpdate
              PQuery.Close;
              if bupdate then
                begin
                    PQuery.SQL.Clear;
                    PQuery.SQL.Add('UPDATE log_log SET log_update=CURRENT_TIMESTAMP, ');
                    PQuery.SQL.Add(' log_date=:date, log_val=:val, log_lvl=:lvl, log_freq=:freq ');
                    PQuery.SQL.Add(' WHERE log_id=:logid');
                    PQuery.ParamByName('date').AsDateTime  := ISO8601ToDateTime(ALogInsert.Date);
                    PQuery.ParamByName('val').AsString     := ALogInsert.val;
                    PQuery.paramByName('logid').Asinteger  := log_id;
                    PQuery.paramByName('freq').Asinteger   := ALogInsert.freq;
                    if ALogInsert.ovl
                      then PQuery.paramByName('lvl').Asstring := ALogInsert.lvl
                      else PQuery.paramByName('lvl').Asinteger := Max(StrToIntDef(ALogInsert.lvl,3), log_lvl);
                    PQuery.ExecSQL;
                end;


                // On met dans log_val tout le temps !!!
                // if not(bupdate) or ((bupdate) and ((log_lvl<>StrToIntDef(ALogInsert.lvl,3)) or (ALogInsert.val<>log_val)))
                //   then
                //    begin
                PQuery.Close;
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT * FROM monitor.log_value WHERE 0=1');
                PQuery.Open;
                PQuery.Insert;
                //------------------------------------------------------
                PQuery.FieldByName('val_logid').AsInteger:=log_id;
                PQuery.FieldByName('val_remoteip').Asstring := ARequestInfo.RemoteIP;  // <-- nous permettra de tracer les elentuelles problème de parametrage des applications (mauvais ini, mauvais sender etc...)
                PQuery.FieldByName('val_date').AsDateTime:=ISO8601ToDateTime(ALogInsert.Date);
                PQuery.FieldByName('val_val').Asstring:=ALogInsert.val;
                PQuery.FieldByName('val_nb').Asstring:=ALogInsert.nb;
                PQuery.FieldByName('val_lvl').Asstring:=ALogInsert.lvl;
                If (ALogInsert.ovl = true)
                  then PQuery.FieldByName('val_ovl').Asinteger:=1
                  else PQuery.FieldByName('val_ovl').Asinteger:=0;
                PQuery.Post;
                val_id :=PQuery.FieldByName('val_id').AsInteger;
                //   end;
                {
                if ( and (val_id > 0) and (log_id > 0)) then
                  begin
                     PQuery.Close;
                     PQuery.SQL.Clear;
                     PQuery.SQL.Add('UPDATE log_value SET val_ovl = :val_id1 WHERE val_logid = :log_id AND val_ovl = 0 AND val_id <> :val_id2 ');
                     PQuery.ParamByName('val_id1').AsInteger := val_id;
                     PQuery.ParamByName('log_id').AsInteger  := log_id;
                     PQuery.ParamByName('val_id2').AsInteger := val_id;
                     PQuery.ExecSQL;
                  end;
                }
           end;
         end;
        finally
         LJSONArr.Free;
        end;
        Except on E:Exception
          do
            begin
                Log_Write(E.Message,el_Erreur);
                AResponseInfo.ResponseNo:=500;
                AResponseInfo.ResponseText:='';
            end;
      end;
     finally
         Astr.Free;
         PQuery.Close;
         PQuery.Free;
         PCon.Close;
         PCon.Free;
         AResponseInfo.ResponseNo:=200;
         AResponseInfo.ResponseText:='OK';
     end;
end;

procedure TForm3.Page_wsdatabases(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    grp         : string;
begin
   Astr:=TStringList.Create;
   try
      try
        AStr.Text:=ARequestInfo.Params.Text;
        // AStr.Text.Trim;
        grp:=Astr.Values['grp'];
        AResponseInfo.ContentText:=get_databases(grp);
        AResponseInfo.ResponseNo   := 200;
        AResponseInfo.ResponseText := 'OK';
        log_Write(Format('%s - %s : %s',[FormatDateTime('yyyy-mm-dd hh:nn:ss',Now()),ARequestInfo.RemoteIP,ARequestInfo.QueryParams.Trim]));
        Except on E:Exception
          do
            begin
                // memo1.Lines.Add(E.Message);
                Log_Write(E.Message,el_Erreur);
                AResponseInfo.ResponseNo:=500;
                AResponseInfo.ResponseText:='';
            end;
        end;
     finally
         Astr.Free;
     end;
end;

procedure TForm3.Page_Histo(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    Str         :string;
    LJSONObject : TJSONObject;
    LItem       : TJSONPair;
    uid         : string;
    logid       : integer;
    start, limit  :integer;
begin
   Astr:=TStringList.Create;
   LJSONObject := nil;
   try
      AStr.Text:=ARequestInfo.Params.Text;
      // AStr.Text.Trim;
      Str:=Astr.Values['json'];
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Str), 0) as TJSONObject;
      try
         uid:='';
         logid:=0;
         start:=0;
         limit:=50;
         if LJSONObject<>nil then
              begin
                for LItem in TJSONObject(LJSONObject) do
                 begin
                     if (TJSONPair(LItem).JsonString.Value='uid') then
                        begin
                           uid:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='logid') then
                        begin
                           logid:=TJSONPair(LItem).JsonValue.Value.ToInteger;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='start') then
                        begin
                           start:=TJSONPair(LItem).JsonValue.Value.ToInteger;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='limit') then
                        begin
                           limit:=TJSONPair(LItem).JsonValue.Value.ToInteger;
                        end;
                  end;
                  try
                    AResponseInfo.ContentText:=historique_log(uid,logid,start,limit);
                    AResponseInfo.ResponseNo:=200;
                  Except On E:Exception do
                    begin
                      AResponseInfo.ResponseNo:=500;
                      log_Write(E.Message,el_Erreur);
                      AResponseInfo.ContentText:=E.Message;
                    end;
                  end;
              end;
      finally
        LJSONObject.Free;
      end;
   finally
      Astr.Free;
   end;
end;


procedure TForm3.Page_index(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    LJSONObject : TJSONObject;
    LItem       : TJSONPair;
    Str        : string;
    PostedFile:TMemoryStream;
    typ,uid,tag:string;
begin
   typ:='';
   uid:='';
   tag:='';
   LJSONObject := nil;
   Astr:=TStringList.Create;
   try
      AStr.Text:=ARequestInfo.Params.Text;
      // AStr.Text.trim;
      Str:=Astr.Values['json'];
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Str), 0) as TJSONObject;
      try
        try
          if LJSONObject<>nil then
            begin
            for LItem in TJSONObject(LJSONObject) do
             begin
                 if (TJSONPair(LItem).JsonString.Value='uid') then
                    begin
                       uid:=TJSONPair(LItem).JsonValue.Value;
                    end;
                if (TJSONPair(LItem).JsonString.Value='typ') then
                    begin
                       typ:=TJSONPair(LItem).JsonValue.Value;
                    end;
                if (TJSONPair(LItem).JsonString.Value='tag') then
                    begin
                        tag:=TJSONPair(LItem).JsonValue.Value;
                    end;
              end;
          end;
          if typ='mc'
          then
            begin
                AResponseInfo.ContentText:=index_master_color(uid,tag);
                AResponseInfo.ResponseNo:=200;
            end
          else if typ='mp'
          then
            begin
                AResponseInfo.ContentText:=index_master_progress(uid,tag);
                AResponseInfo.ResponseNo:=200;
            end
          else if typ='mv'
          then
            begin
                AResponseInfo.ContentText:=index_master_values(uid,tag);
                AResponseInfo.ResponseNo:=200;
            end
          else if typ='detail'
            then
              begin
                AResponseInfo.ContentText:=index_detail(uid,tag);
                AResponseInfo.ResponseNo:=200;
              end
          else
             begin
               AResponseInfo.ContentText:='';
               AResponseInfo.ResponseNo:=404;
             end
          Except On E:Exception Do
              begin
                 AResponseInfo.ContentText:='';
                 AResponseInfo.ResponseNo:=500;
                 log_Write(E.Message,el_Erreur);
              end;
        end;
      finally
       LJSONObject.Free;
      end;
   finally
     Astr.Free;
   end;
end;

procedure TForm3.Page_config_abonnement(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    LJSONObject : TJSONObject;
    LItem       : TJSONPair;
    Str        : string;
    uid:string;
begin
   uid  := '';
   LJSONObject := nil;
   Astr:=TStringList.Create;
   try
     AStr.Text:=ARequestInfo.Params.Text;
     // AStr.Text.trim;
     Str:=Astr.Values['json'];
     LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Str), 0) as TJSONObject;
     try
       try
          if LJSONObject<>nil then
            begin
            for LItem in TJSONObject(LJSONObject) do
               begin
                   if (TJSONPair(LItem).JsonString.Value='uid') then
                      begin
                         uid:=TJSONPair(LItem).JsonValue.Value;
                      end;
               end;
            AResponseInfo.ContentText:=get_config_abonnement(uid);
            AResponseInfo.ResponseNo:=200;
            end;
            Except on E:Exception
             do
                begin
                    AResponseInfo.ResponseNo:=500;
                    log_Write(E.Message,el_Erreur);
                end;
        end;
        finally
           LJSONObject.Free;
        end;
     finally
        Astr.Free;
     end;
end;

procedure TForm3.Page_Abonnement(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    LJSONObject : TJSONObject;
    LItem       : TJSONPair;
    Str         : string;
    PostedFile:TMemoryStream;
    uid,nom,host,app,inst,srv,mdl,dos,ref,key,tag:string;
    Top_Depart  : TTimeStamp;
    Top_Arrivee : TTimeStamp;
    microtime   : integer;

begin
   LJSONObject := nil;
   Astr:=TStringList.Create;
   try
      AStr.Text:=ARequestInfo.Params.Text;
      // AStr.Text.Trim;
      Str:=Astr.Values['json'];
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Str), 0) as TJSONObject;
      try
        try
            uid  := '';
            nom  := '%';
            host := '%';
            app  := '%';
            inst := '%';
            srv  := '%';
            mdl  := '%';
            dos  := '%';
            ref  := '%';
            key  := '%';
            tag  := '';
            if LJSONObject<>nil then
              begin
                for LItem in TJSONObject(LJSONObject) do
                 begin
                     if (TJSONPair(LItem).JsonString.Value='uid') then
                        begin
                           uid:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='nom') then
                        begin
                           nom:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='host') then
                        begin
                            host:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='app') then
                        begin
                            app:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='inst') then
                        begin
                            inst:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='srv') then
                        begin
                            srv:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='mdl') then
                        begin
                            mdl:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='dos') then
                        begin
                            dos:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='ref') then
                        begin
                            ref:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='key') then
                        begin
                            key:=TJSONPair(LItem).JsonValue.Value;
                        end;
                    if (TJSONPair(LItem).JsonString.Value='tag') then
                        begin
                            tag:=TJSONPair(LItem).JsonValue.Value;
                        end;
                 end;
                  If not(add_abonnement(uid,nom,host,app,inst,srv,mdl,dos,ref,key,tag))
                    then raise Exception.Create('Impossible d''ajouter l''abonnement');
                  AResponseInfo.ContentText:='{"status":"OK"}';
                  AResponseInfo.ResponseNo:=200;
               end;
            Except on E:Exception
              do
                begin
                    AResponseInfo.ResponseNo:=500;
                    log_Write(E.Message,el_Erreur);
                end;
      end;
      finally
        LJSONObject.Free;
      end;
     finally
        Astr.Free;
     end;
end;

procedure TForm3.Page_Login(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo);
var AStr        : TStringList;
    LJSONObject : TJSONObject;
    LItem       : TJSONPair;
    password   : string;
    login      : string;
    Str        : string;
    PostedFile:TMemoryStream;
begin
   LJSONObject := nil;
   Astr:=TStringList.Create;
   try
      AStr.Text:=ARequestInfo.Params.Text;
      // AStr.Text.trim;
      Str:=Astr.Values['json'];
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Str), 0) as TJSONObject;
      try
        try
           if LJSONObject<>nil then
              begin
                for LItem in TJSONObject(LJSONObject) do
                 begin
                     if (TJSONPair(LItem).JsonString.Value='login') then
                        begin
                             login:=TJSONPair(LItem).JsonValue.Value;
                        end;
                if (TJSONPair(LItem).JsonString.Value='password') then
                    begin
                        password:=TJSONPair(LItem).JsonValue.Value;
                    end;
             end;
             AResponseInfo.ContentText:=Creation_Session(login,password);
             log_Write(Format('%s : %s',[ARequestInfo.From,AResponseInfo.ContentText]),el_info);
             AResponseInfo.ResponseNo:=200;
           end;
        Except on E:Exception
          do
            begin
                AResponseInfo.ResponseNo:=500;
                AResponseInfo.ContentText:='';
                log_Write(E.Message,el_Erreur);
            end;
        end;
      finally
        LJSONObject.Free;
      end;
     finally
         Astr.Free;
     end;
end;

procedure TForm3.IdHTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var Top_Depart  : TTimeStamp;
    Top_Arrivee : TTimeStamp;
    microtime   : integer;
    LocalDoc    : string;
    Position    : integer;
begin
    try
      Hit      := Hit+1;
      Top_Depart:=DateTimeToTimeStamp(now);
      Case AnsiIndexStr(ARequestInfo.Document, [  '/monitor/test.html'              , // 0
                                                  '/monitor/monitor.php'            , // 1
                                                  '/monitor/login.php'              , // 2
                                                  '/monitor/abonnement.php'         , // 3
                                                  '/monitor/databases.php'          , // 4
                                                  '/monitor/index.php'              , // 5
                                                  '/monitor/histo.php'              , // 6
                                                  '/monitor/config_abonnement.php'  ,  // 7
                                                  '/monitor/clean.php'                 // 8
                                                  ]) of
      0:begin
              LocalDoc:='test.html';
              AResponseInfo.ResponseNo := 200;
              // AResponseInfo.ContentType := GetMIMEType(LocalDoc);
              AResponseInfo.ContentStream := TFileStream.Create(LocalDoc, fmOpenRead + fmShareDenyWrite);
          end;
      1: Page_Monitor(AContext,ARequestInfo,AResponseInfo);
      2: Page_Login(AContext,ARequestInfo,AResponseInfo);
      3: Page_Abonnement(AContext,ARequestInfo,AResponseInfo);
      4: Page_wsdatabases(AContext,ARequestInfo,AResponseInfo);
      5: Page_index(AContext,ARequestInfo,AResponseInfo);
      6: Page_Histo(AContext,ARequestInfo,AResponseInfo);
      7: Page_config_abonnement(AContext,ARequestInfo,AResponseInfo);
      8: AResponseInfo.ContentText := Nettoyage_Cascade;
      else
         begin
           AResponseInfo.ResponseNo := 404;
           AResponseInfo.ContentText := '';
         end;
      End;
    finally
       QuerySec := QuerySec + 1;
       SizeReceive := SizeReceive + ARequestInfo.ContentLength;
       SizeSend    := SizeSend    + AResponseInfo.ContentText.Length;
       Top_Arrivee:=DateTimeToTimeStamp(now);
       microtime:=Top_Arrivee.Time-Top_Depart.Time;
       Log_Write(Format('%s | %s | Size %d | HTTP %d | time %d ms',[ARequestInfo.RemoteIP , ARequestInfo.Document, ARequestInfo.ContentLength , AResponseInfo.ResponseNo, microtime]),el_Info);
    end;
end;


end.

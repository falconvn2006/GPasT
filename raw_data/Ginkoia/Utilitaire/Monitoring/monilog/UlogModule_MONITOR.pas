unit UlogModule_MONITOR;

interface

uses
   Classes, IdIcmpClient, Math, UlogModule, SysUtils, ULog,
   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
   FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
   FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Phys.IB,
   FireDac.Dapt, UCommun,FireDac.Phys.SQLite,Firedac.VCLUI.Wait,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,System.Json;

type
   TLogModule_MONITOR = class(TLogModule)
   private
     FRunning  : boolean;
     Fmode     : string;
     FOnAfterTest: TNotifyEvent;
     FNbPassages : integer;
     FNBJOUR   : integer;
     FGRP      : string;
     FHost     : string;
     FWS       : string;   // Url du webservice de récupération des infos...
     FIBServer : string;
     FIBPath   : string;
     FIBConnexion  : TFDConnection;
     FJsonDatas    : string;
     FMemTable     : TFDMemTable;  // Table memoire avec les records du json
     FWSFREQ       : integer;
     function  GetVersionDBGinkoia():string;
     procedure AnalyseLigneCourante;
   protected
    procedure DoTest; override;
    procedure Rafraichissement;
    procedure CreateFields();
    procedure GetWS;
    procedure Parse_Json_Datas(astr:string);
   public
     constructor Create(Host: string; AFreq:integer; ANotifyEvent: TNotifyEvent);
     destructor Destroy; override;
     procedure Prepare;
     property Running   : boolean read FRunning  write FRunning;
     property Mode      : string  read FMode     write FMode;
     property WS        : string  read FWS       write FWS;
     property WSFREQ    : integer read FWSFREQ   write FWSFREQ;
     property GRP       : string  read FGRP      write FGRP;
     property NBJOUR    : integer read FNBJOUR   write FNBJOUR;
   end;

implementation

{ uses  SyncObjs; }

procedure TLogModule_MONITOR.GetWS;
var idhttp:TIdHttp;
    Ts : TStringList;
    resultat:string;
begin
    // est-ce qu'il y a des nettoyages à faire ?
    FNbPassages:=0;
    FMemTable.Close;
    FMemTable.open;
    idhttp:=TidHttp.Create(nil);
    Ts := TStringList.Create;
    try
      try
       Ts.Add(Format('grp=%s',[GRP]));
       idhttp.Request.ContentType := 'application/x-www-form-urlencoded';
       resultat:=idhttp.Post(FWS, Ts);
       // ----------------------------------------------------------------------
       if Length(resultat)>0 then
         begin
              // Il faut Parser le truc   et mettre ca dans MemTable
              Parse_Json_Datas(resultat);
              // ---------------------------------------------------------------
              Log.Log(Host,'INTERBASE/MONITOR','WEBSERVICE DATABASE',FWS,'GRP='+GRP,'OK',loginfo,true);
         end
       else raise Exception.Create('Retour vide du webservice');
      except On E:Exception do
         Log.Log(Host,'INTERBASE/MONITOR','WEBSERVICE DATABASE',FWS,'GRP='+GRP,E.Message,logError,true);
      end;
    finally
      Ts.free;
      idHttp.Free;
    end;
end;

procedure TLogModule_MONITOR.Parse_Json_Datas(astr:string);
var  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;
  i:integer;
  toto:string;
begin
   LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0) as TJSONArray;
   for LJsonValue in LJsonArr do
   begin
      FMemTable.Append;
      for LItem in TJSONArray(LJsonValue) do
        begin
            FMemTable.FieldByName(TJSONPair(LItem).JsonString.Value).AsString:=TJSONPair(LItem).JsonValue.Value;
        end;
      FMemTable.post;
   end;
   //---------------------------------------------------------------------------
  {
   FMemTable.First;
   While not(FMemTable.eof) do
    begin
        FMemTable.Edit;
        FMemTable.FieldByName('ETAT').Asinteger := DataMod.DB_In_WJETON(FDMemTable1);
        FMemTable.post;
        FMemTable.Next;
    end;
   }
end;



procedure TLogModule_MONITOR.Prepare;
begin
     try
       // SQLiteStartConnexion(FSQLITE,false);
//       LoadDatas;

        GetWS;
     Except

     end;
end;

constructor TLogModule_MONITOR.Create(Host: string; AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   FHost   := Host;
   FModule := 'INTERBASE/MONITOR';
   FNBJOUR := 30;
   FGRP    := '';
   FNbPassages := 0;
   FMemTable:=TFDmemTable.Create(nil);
   FIBConnexion:=TFDConnection.Create(nil);
   CreateFields();
end;

procedure TLogModule_MONITOR.CreateFields();
begin
   FMemTable.FieldDefs.Clear;
   with FMemTable.FieldDefs do begin
      with AddFieldDef do begin
          Name := 'GROUPE';
          DataType := ftString;
          Size := 50;
      end;
      with AddFieldDef do begin
          Name := 'LAME';
          DataType := ftString;
          Size := 50;
      end;
      with AddFieldDef do begin
          Name := 'DOSSIER';
          DataType := ftString;
          Size := 127;
      end;
      with AddFieldDef do begin
          Name := 'GINKOIA';
          DataType := ftString;
          Size := 127;
      end;
      with AddFieldDef do begin
          Name := 'MONITOR';
          DataType := ftString;
          Size := 127;
      end;
      with AddFieldDef do begin
          Name := 'DATEHEURE';
          DataType := ftDateTime;
      end;
      with AddFieldDef do begin
          Name := 'SENDER';
          DataType := ftString;
          Size := 127;
      end;
    end;
    FMemTable.Open;
end;

destructor TLogModule_MONITOR.Destroy;
begin
   FIBConnexion.Close;
   FIBConnexion.Free;
   FMemTable.Close;
   FMemTable.Free;
   inherited;
end;

function TLogModule_MONITOR.GetVersionDBGinkoia():string;
var SQuery:TFDQuery;
begin
     result:='';
      if FIBConnexion.Connected then
        begin
             SQuery:=TFDQuery.Create(nil);
             SQuery.Connection:=FIBConnexion;
             SQuery.close;
             SQuery.SQL.Clear;
             SQuery.SQL.Add('SELECT * FROM GENVERSION ORDER BY VER_DATE DESC');
             SQuery.Open;
             SQuery.First;
             result:=SQuery.FieldByName('VER_VERSION').asstring;
             SQuery.Close;
             SQuery.Free;
        end;
end;

{
procedure TLogModule_IB.LoadDatas;
var i:integer;
begin
     try
       try
          FMemTable.Close;
          FMemTable.open;
          if FMemTable.Active then
             begin
                  FMemTable.Append;
                  FMemTable.FieldByName('DOSSIER').aswidestring  := PQuery.FieldbyName('CON_NOM').asstring;
                  FMemTable.FieldByName('SERVER').aswidestring   := PQuery.FieldbyName('CON_SERVER').asstring;
                  FMemTable.FieldByName('DATABASE').aswidestring := PQuery.FieldbyName('CON_PATH').asstring;
                  FMemTable.
             //   NbPassageCurrent:= FNbPassage * FDQJETON.RecordCount + 1;  // le + 1 permet d'avoir un nombre premier avec recordcount
           end
        else
          begin
//              Log_Write('LoadDatas : Erreur Connexion à ' + DataMod.FDConSQLite.Params.Text);
          end;
       except on E:Exception do
//         Log_Write('LoadDatas : Erreur '+ E.Message, el_Info);
       end;
     finally
     end;
end;
}

procedure TLogModule_MONITOR.Rafraichissement;
begin
    if Running then
       begin
           try
              Running:=False;
              AnalyseLigneCourante;
              if (FMemTable.RecNo=FMemTable.RecordCount)
                  then
                      begin
                           if (WSFREQ<FNbPassages*Freq)
                            then
                                begin
                                    GetWS;
                                end;
                           FMemTable.First;
                      end
                  else FMemTable.Next;
              inc(FNbPassages);
           finally
             Running:=true;
           end;
       end;
end;


procedure TLogModule_MONITOR.AnalyseLigneCourante;
var PQuery:TFDQuery;
    Parametres:string;
    sAuto:string;
    nerror:Integer;
    astring:string;
    sNewFileName:string;
begin
    // Log_Write('AnalyseLigneCourante', el_Debug);
    if FMemTable.RecordCount=0
      then
          begin
               //  Stop:=true;
               exit;
          end;
     //-------------------------------------------------------------------------
     PQuery:=TFDQuery.Create(nil);
     try
        FIBConnexion.Params.Clear;
        FIBConnexion.Params.Add('DriverID=IB');
        FIBConnexion.Params.Add('Server=' + FMemTable.FieldByName('LAME').AsString);
        FIBConnexion.Params.Add('Database='+ FMemTable.FieldByName('MONITOR').AsString);
        FIBConnexion.Params.Add('User_Name=GINKOIA');
        FIBConnexion.Params.Add('Password=ginkoia');
        FIBConnexion.Params.Add('Protocol=TCPIP');
        FIBConnexion.Txoptions.Readonly:=true;
        Try
           FIBConnexion.open;
           If FIBConnexion.Connected then
            begin
                // -- Log_Write(Format('Connexion à IB : %s/%s : [ OK ]',[FDQJETON.FieldByName('JET_SERVER').AsString,FDQJETON.FieldByName('JET_DATABASE').AsString]), el_Info); --
                Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/MONITOR',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'connected','OK',logInfo,true);
                PQuery.Connection:=FIBConnexion;
                PQuery.Close;
                PQuery.SQL.Clear;
                PQuery.SQL.Add(Format('SELECT * FROM VMONITOR_LAST_REPLIC(%d)',[NBJOUR]));
                PQuery.Open;
                while not(PQuery.Eof) do
                    begin
                       Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/MONITOR',FMemTable.FieldByName('DOSSIER').AsString,PQuery.Fields[0].AsString,'tentative',DateTimeToISO(PQuery.Fields[1].AsDateTime),logInfo,true);
                       Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/MONITOR',FMemTable.FieldByName('DOSSIER').AsString,PQuery.Fields[0].AsString,'réussite',DateTimeToISO(PQuery.Fields[2].AsDateTime),logInfo,true);
                       PQuery.Next;
                    end;
                //-- FMemTable.Post --
            end;
            Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/MONITOR',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'status', 'OK',logInfo,true);
            Except
               On E: EFDDBEngineException  do
                    begin
                      Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/MONITOR',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'status', Format('EngineException : %d',[E.ErrorCode]),logError,true);
                    end;
               On Ex: Exception do
                   begin
                      Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/MONITOR',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'status', 'Exception '+ Ex.Message,logError,true);
                   End;
        End;
     finally
        FIBConnexion.Close;
        PQuery.Close;
        PQuery.Free;
     end;
end;

procedure TLogModule_MONITOR.DoTest;
var aversion:string;
begin
   aversion :='';
   try
    try
       FRunning := true;
       FStatus := 'Running';
       Rafraichissement;
      except
        Log.Log('',Module,FHost,'','status',99,logError,true);
      end;
    finally
       FStatus := 'Not Running';
       FRunning := false;
   end;
end;

end.

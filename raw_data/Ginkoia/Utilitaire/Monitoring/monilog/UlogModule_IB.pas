unit UlogModule_IB;

interface

uses
   Classes, IdIcmpClient, Math, UlogModule, SysUtils, ULog,
   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
   FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
   FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Phys.IB,
   FireDac.Dapt, UCommun,FireDac.Phys.SQLite,Firedac.VCLUI.Wait,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,System.Json;

type
   TLogModule_IB = class(TLogModule)
   private
     FRunning  : boolean;
     Fmode     : string;
     FOnAfterTest: TNotifyEvent;
     FNbPassages : integer;
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
   end;

implementation

{ uses  SyncObjs; }

procedure TLogModule_IB.GetWS;
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
       // ****************************************//
       if Length(resultat)>0 then
         begin
              // Il faut Parser le truc   et mettre ca dans MemTable
              Parse_Json_Datas(resultat);
              Log.Log(Host,'INTERBASE/GINKOIA','WEBSERVICE DATABASE',FWS,'GRP='+GRP,'OK',logInfo,true);
         end
       else raise Exception.Create('Retour vide du webservice');
      except On E:Exception do
         Log.Log(Host,'INTERBASE/GINKOIA','WEBSERVICE DATABASE',FWS,'GRP='+GRP,E.Message,logError,true);
      end;
    finally
      Ts.free;
      idHttp.Free;
    end;
end;

procedure TLogModule_IB.Parse_Json_Datas(astr:string);
var  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;
  i:integer;
  toto:string;
begin
   LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0) as TJSONArray;
   if LJsonArr<>nil then
    begin
         for LJsonValue in LJsonArr do
            begin
            FMemTable.Append;
            for LItem in TJSONArray(LJsonValue) do
              begin
                  FMemTable.FieldByName(TJSONPair(LItem).JsonString.Value).AsString:=TJSONPair(LItem).JsonValue.Value;
              end;
            FMemTable.post;
         end;
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



procedure TLogModule_IB.Prepare;
begin
     try
       // SQLiteStartConnexion(FSQLITE,false);
//       LoadDatas;

        GetWS;
     Except

     end;
end;

constructor TLogModule_IB.Create(Host: string; AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   FHost   := Host;
   FModule := 'INTERBASE/GINKOIA';
   FGRP    := '';
   FNbPassages := 0;
   FMemTable:=TFDmemTable.Create(nil);
   FIBConnexion:=TFDConnection.Create(nil);
   CreateFields();
end;

procedure TLogModule_IB.CreateFields();
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

destructor TLogModule_IB.Destroy;
begin
   FIBConnexion.Close;
   FIBConnexion.Free;
   FMemTable.Close;
   FMemTable.Free;
   inherited;
end;

function TLogModule_IB.GetVersionDBGinkoia():string;
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

procedure TLogModule_IB.Rafraichissement;
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


procedure TLogModule_IB.AnalyseLigneCourante;
var PQuery:TFDQuery;
    Parametres:string;
    sAuto:string;
    nerror:Integer;
    astring:string;
    sNewFileName:string;
begin
//     Log_Write('AnalyseLigneCourante', el_Debug);
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
        FIBConnexion.Params.Add('Database='+ FMemTable.FieldByName('GINKOIA').AsString);
        FIBConnexion.Params.Add('User_Name=GINKOIA');
        FIBConnexion.Params.Add('Password=ginkoia');
        FIBConnexion.Params.Add('Protocol=TCPIP');
        FIBConnexion.Txoptions.Readonly:=true;
        Try
           FIBConnexion.open;
           If FIBConnexion.Connected then
            begin
                // --- Log_Write(Format('Connexion à IB : %s/%s : [ OK ]',[FDQJETON.FieldByName('JET_SERVER').AsString,FDQJETON.FieldByName('JET_DATABASE').AsString]), el_Info); --
                Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/GINKOIA',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'connected','OK',logInfo,true);
                PQuery.Connection:=FIBConnexion;
                PQuery.Close;
                {-------------------------------------------------------------}
                { if (not(FQuery.FieldByName('JET_HRFLAG').Asboolean) ) // or (NbPassageCurrent<=0))
                    then
                        begin
                            astring:='';
                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_IDENT, BAS_JETON, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_CENTRALE, BAS_NOMPOURNOUS FROM GENBASES JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 WHERE BAS_ID<>0');

//                            astring:=DataSetToJson(TDataSet(PQuery));
//                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_bases,'EA157EDA');

                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT MAG_ID, MAG_NOM, MAG_ENSEIGNE FROM GENMAGASIN JOIN K ON K_ID=MAG_ID AND K_ENABLED=1 WHERE MAG_ID<>0');
//                            astring:=DataSetToJson(TDataSet(PQuery));
//                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_magasins,'4FEDA478');

                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT VER_DATE, VER_VERSION FROM GENVERSION order BY VER_DATE DESC ROWS 1');
//                            astring:=DataSetToJson(TDataSet(PQuery));
//                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_version,'FDZ71UIF');

                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT UGG_NOM, MAG_NOM, MAG_ENSEIGNE, UGM_DATE FROM uilgrpginkoia');
                            PQuery.SQL.Add('JOIN uilgrpginkoiamag ON UGM_UGGID=UGG_ID');
                            PQuery.SQL.Add('JOIN genmagasin ON UGM_MAGID=MAG_ID');
                            PQuery.SQL.Add('JOIN K ON K_ID=UGG_ID AND K_ENABLED=1');
                            PQuery.SQL.Add('JOIN K ON K_ID=UGM_ID AND K_ENABLED=1');
                            PQuery.SQL.Add('JOIN K ON K_ID=MAG_ID AND K_ENABLED=1');
                            PQuery.SQL.Add('WHERE UGG_ID<>0');
                            PQuery.SQL.Add('ORDER BY UGG_NOM');
//                            astring:=DataSetToJson(TDataSet(PQuery));
//                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_module,'BDE84DFA11');

                            //--------------------------------------------------
                            PQuery.Close;
                            PQuery.SQL.Clear;
                            // 2 Replications standards
                            PQuery.SQL.Add('SELECT GENBASES.BAS_SENDER, LAU_H1,');
                            PQuery.SQL.Add(' CASE');
                            PQuery.SQL.Add('     WHEN (LAU_HEURE1 IS NULL) THEN ''0'' ');
                            PQuery.SQL.Add('     ELSE CAST(((CAST(f_MID(LAU_HEURE1,11,2) AS FLOAT)+CAST(f_MID(LAU_HEURE1,14,2) AS FLOAT)/60) / 24) AS VARCHAR(15))');
                            PQuery.SQL.Add(' END AS LAU_HR1,');
                            PQuery.SQL.Add(' LAU_H2,');
                            PQuery.SQL.Add(' CASE');
                            PQuery.SQL.Add('     WHEN (LAU_HEURE2 IS NULL) THEN ''0'' ');
                            PQuery.SQL.Add('     ELSE CAST(((CAST(f_MID(LAU_HEURE2,11,2) AS FLOAT)+CAST(f_MID(LAU_HEURE2,14,2) AS FLOAT)/60) / 24) AS VARCHAR(15)) ');
                            PQuery.SQL.Add(' END AS LAU_HR2, ');
                            PQuery.SQL.Add(' LAU_AUTORUN ');
                            PQuery.SQL.Add('  FROM GENBASES ');
                            PQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
                            PQuery.SQL.Add(' JOIN GENLAUNCH ON BAS_ID=LAU_BASID ');
                            PQuery.SQL.Add(' WHERE (BAS_SENDER NOT LIKE ''% %'') AND (BAS_ID<>0) ');
                            PQuery.SQL.Add(' ORDER BY BAS_ID ');
                            PQuery.Open;
                            astring:='';
                            while not(PQuery.Eof) do
                              begin
                                   Log.Log(PQuery.FieldByName('BAS_SENDER').asstring,
                                           FQuery.FieldByName('JET_DOSSIER').AsString,
                                           'run',PQuery.FieldByName('LAU_AUTORUN').asinteger,
                                           logInfo,true);                              {

//                                           PQuery.FieldByName('LAU_H1').AsInteger,
//                                            PQuery.FieldByName('LAU_H2').AsInteger,
//                                          StringReplace(Trim(PQuery.FieldByName('LAU_HR1').asstring),',','.',[rfReplaceAll]),
//                                            StringReplace(Trim(PQuery.FieldByName('LAU_HR2').asstring),',','.',[rfReplaceAll])
//                                            ]);

                                   PQuery.Next;
                              end;
                            PQuery.close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add(' SELECT BAS_SENDER, REP_JOUR, PRM_CODE, PRM_INTEGER+PRM_FLOAT as HR ');
                            PQuery.SQL.Add(' FROM GENREPLICATION ');
                            PQuery.SQL.Add(' JOIN K ON (K_id = REP_ID and K_ENABLED=1) ');
                            PQuery.SQL.Add(' JOIN GENLAUNCH ON (LAU_ID=REP_LAUID) ');
                            PQuery.SQL.Add(' JOIN K ON (K_ID = LAU_ID and K_ENABLED=1) ');
                            PQuery.SQL.Add(' JOIN GENBASES ON (BAS_ID = LAU_BASID)  ');
                            PQuery.SQL.Add(' JOIN K ON (K_ID=BAS_ID AND K_ENABLED=1)  ');
                            PQuery.SQL.Add(' JOIN GENPARAM ON (PRM_TYPE=11 AND BAS_ID=PRM_POS AND PRM_CODE IN (31,32,33) ) ');
                            PQuery.SQL.Add(' WHERE (BAS_SENDER NOT LIKE ''% %'') ');
                            PQuery.SQL.Add(' ORDER BY BAS_ID ');
                            PQuery.Open;
                            astring:='';
                            while not(PQuery.Eof) do
                              begin
                                   Log.Log(PQuery.FieldByName('BAS_SENDER').asstring,
                                           FQuery.FieldByName('JET_DOSSIER').AsString,
                                           'rep_jour',PQuery.FieldByName('REP_JOUR').asinteger,
                                           logInfo,true);

                                   Log.Log(PQuery.FieldByName('BAS_SENDER').asstring,
                                           FQuery.FieldByName('JET_DOSSIER').AsString,
                                           'h',PQuery.FieldByName('PRM_CODE').asstring,
                                           logInfo,true);

                                   Log.Log(PQuery.FieldByName('BAS_SENDER').asstring,
                                           FQuery.FieldByName('JET_DOSSIER').AsString,
                                           's', PQuery.FieldByName('HR').asfloat,
                                           logInfo,true);
                                   PQuery.Next;
                              end;

                           PQuery.close;
                           FQuery.Edit;
                           FQuery.FieldByName('JET_HRFLAG').asboolean:=true;
                           FQuery.post;
                        end;
                }
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT JET_NOMPOSTE, JET_STAMP, BAS_NOM, BAS_SENDER FROM GENJETONS JOIN GENBASES ON JET_BASID=BAS_ID ORDER BY JET_STAMP DESC');
                PQuery.Open;
                If not(PQuery.IsEmpty) then
                     begin
                          FMemTable.Edit;
                          // FMemTable.FieldByName('POSTE').AsString := PQuery.FieldByName('JET_NOMPOSTE').AsString;
                          FMemTable.FieldByName('DATEHEURE').AsDateTime:= PQuery.FieldByName('JET_STAMP').AsDateTime;
                          // FMemTable.FieldByName('BASE').AsString  := PQuery.FieldByName('BAS_NOM').AsString;
                          FMemTable.FieldByName('SENDER').AsString:=      PQuery.FieldByName('BAS_SENDER').AsString;
                     end
                  Else
                    begin
                         FMemTable.Edit;
                         // --- FMemTable.FieldByName('POSTE').AsString:='';
                         FMemTable.FieldByName('DATEHEURE').AsString:='';
                         // --- FMemTable.FieldByName('BASE').AsString:='';
                         FMemTable.FieldByName('SENDER').AsString:='';
                    end;
                PQuery.Close;
                Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/GINKOIA',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'jeton'   , FMemTable.FieldByName('SENDER').AsString,logInfo,true);
                Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/GINKOIA',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'jeton_hr', DateTimeToISO(FMemTable.FieldByName('DATEHEURE').AsDateTime),logInfo,true);
                FMemTable.Post;
            end;
            Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/GINKOIA',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'status', 'OK',logInfo,true);
            Except
               On E: EFDDBEngineException  do
                    begin
                      Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/GINKOIA',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'status', Format('EngineException : %d',[E.ErrorCode]),logError,true);
                    end;
               On Ex: Exception do
                   begin
                      Log.Log(FMemTable.FieldByName('LAME').AsString,'INTERBASE/GINKOIA',FMemTable.FieldByName('DOSSIER').AsString,FMemTable.FieldByName('GINKOIA').AsString,'status', 'Exception '+ Ex.Message,logError,true);
                   End;
        End;
     finally
        FIBConnexion.Close;
        PQuery.Close;
        PQuery.Free;
     end;
end;


procedure TLogModule_IB.DoTest;
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

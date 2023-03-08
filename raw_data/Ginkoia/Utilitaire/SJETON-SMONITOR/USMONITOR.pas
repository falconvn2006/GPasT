unit USMONITOR;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, MidasLib, Vcl.ExtCtrls,
  Data.DB, Datasnap.DBClient,  FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.DApt,GestionLog,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys ,
  FireDAC.Comp.Client,ShellAPi,System.IniFiles, FireDAC.Stan.Intf,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TServiceMONITOR = class(TService)
    Timer1: TTimer;
    Timer2: TTimer;
    FDQMONITOR: TFDQuery;
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
  private
    FAuto    : boolean;
    FStop    : boolean;
    FOk      : Boolean;
    FPath    : string;
    Ftempo   : integer;
    FStart   : integer;
    FDBFile  : string;
    FTBLOG     : Boolean;
    procedure AnalyseLigneCourante;
    { Déclarations privées }
    function GetStop():boolean;
    procedure SetStop(avalue:boolean);
    procedure Raichissement(Const all:Boolean=False);
    function CleanMonitorLigneCourante:string;
    procedure LoadDatas;
    procedure LoadParams;
  public
    function GetServiceController: TServiceController; override;
  property
    Stop:Boolean read GetStop write setStop;
    { Déclarations publiques }
  end;

var
  ServiceMONITOR: TServiceMONITOR;

implementation

{$R *.DFM}

uses UDataMod,UCommun;


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceMONITOR.Controller(CtrlCode);
end;

function TServiceMONITOR.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


function TServiceMONITOR.GetStop():boolean;
begin
     result:=FStop;
end;

procedure TServiceMONITOR.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
    Log_Write('Reprise du service', el_Info);
    LoadParams;
    Stop:=false;
end;

procedure TServiceMONITOR.ServicePause(Sender: TService; var Paused: Boolean);
begin
    Log_Write('Pause du service', el_Info);
    Stop:=true;
end;

procedure TServiceMONITOR.ServiceStart(Sender: TService; var Started: Boolean);
begin
    Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
    Log_Write('Démarage du service', el_Info);
    LoadParams;
end;

procedure TServiceMONITOR.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
    Log_Write('Arret du service', el_Info);
    Stop:=true;
end;

procedure TServiceMONITOR.SetStop(avalue:boolean);
begin
     FStop:=avalue;
     Timer1.Enabled:=not(aValue);
end;


procedure TServiceMONITOR.Timer1Timer(Sender: TObject);
begin
    if not (Status = csRunning) then
      Exit;
    try
       Log_Write('Timer', el_Debug);
       Timer1.Enabled := False;
       Raichissement;
    finally
       Timer1.Enabled := True;
    end;
end;

procedure TServiceMONITOR.Timer2Timer(Sender: TObject);
begin
     Dec(FStart);
     Log_Write(Format('Lancement dans %d secondes',[FStart]), el_Info);
     if FStart<=0 then
      begin
          Stop:=false;
          Timer2.Enabled:=false;
      end;
end;

procedure TServiceMONITOR.LoadDatas;
var PQuery:TFDQuery;
    i:integer;
    bfound:Boolean;
begin
     Log_Write('LoadDatas', el_Info);
     PQuery:=TFDQuery.Create(DataMod);
     try
       try
        PQuery.Connection:=DataMod.FDConSQLite;
        PQuery.Connection.Open;
        if PQuery.Connection.Connected then
           begin
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT CON_ID, CON_PATH, CON_NOM, CON_SERVER, CON_MONITOR FROM CONNEXION WHERE CON_FAV=1 AND CON_MONITOR<>'''' ORDER BY CON_NOM');

                PQuery.Open;

                // On essayer de de ne plus DELETE la table
                // FDQMONITOR.close;
                // FDQMONITOR.SQL.Clear;
                // FDQMONITOR.SQL.Add('DELETE FROM VMONITOR');
                // FDQMONITOR.ExecSQL;
                // Log_Write('DELETE FROM VMONITOR');

                FDQMONITOR.Close;
                FDQMONITOR.SQL.Clear;
                FDQMONITOR.SQL.Add('SELECT * FROM VMONITOR');
                FDQMONITOR.Open;

                i:=0;
                // VMONITOR n'avait pas ce dossier ==> on ajoute
                while not(PQuery.Eof) do
                    begin
                         if not(FDQMONITOR.Locate('MON_DOSSIER',PQuery.FieldbyName('CON_NOM').asstring,[])) then
                            begin
                               // ----------------------------------------------
                               FDQMONITOR.Append;
                               // FDQMONITOR.FieldByName('MON_ID').asinteger:=i;
                               FDQMONITOR.FieldByName('MON_DOSSIER').aswidestring  := PQuery.FieldbyName('CON_NOM').asstring;
                               FDQMONITOR.FieldByName('MON_SERVER').aswidestring   := PQuery.FieldbyName('CON_SERVER').asstring;
                               FDQMONITOR.FieldByName('MON_DATABASE').aswidestring := PQuery.FieldbyName('CON_MONITOR').asstring;
                               FDQMONITOR.FieldByName('MON_LOGID').Asinteger       := 0;
                               FDQMONITOR.Post;
                               //-----------------------------------------------
                            end
                         // si locate = true : il faut mettre à jour les infos
                         // les admins change parfois de lame ou un mauvais parametrage
                         else
                           begin
                               FDQMONITOR.Edit;
                               // Lame
                               FDQMONITOR.FieldByName('MON_SERVER').aswidestring   := PQuery.FieldbyName('CON_SERVER').asstring;
                               // Chemin de la base Monitor
                               FDQMONITOR.FieldByName('MON_DATABASE').aswidestring := PQuery.FieldbyName('CON_MONITOR').asstring;
                               // On ne change pas  LOGID !
                               FDQMONITOR.Post;
                           end;
                         PQuery.Next;
                    end;

                // Vmonitor à des dossiers en trop : il faut les virer
                FDQMONITOR.Last;
                while not(FDQMONITOR.bof) do
                  begin
                      if not(PQuery.Locate('CON_NOM',FDQMONITOR.FieldbyName('MON_DOSSIER').asstring,[])) then
                         begin
                            FDQMONITOR.Delete;
                         end;
                       FDQMONITOR.Prior;
                  end;
                PQuery.Close;
           end
        else
          begin
              Log_Write('LoadDatas : Erreur Connexion à ' + DataMod.FDConSQLite.Params.Text, el_Erreur);
          end;
       except on E:Exception do
         Log_Write('LoadDatas : Erreur '+ E.Message, el_Erreur);
       end;
     finally
       PQuery.Free;
     end;
end;

procedure TServiceMONITOR.LoadParams;
var i:Integer;
    value,param:string;
    Path:string;
    Ini: TIniFile;
    vdebug : integer;
begin
    Log_Write('LoadParams', el_Info);
    Log_Write(VAR_GLOB.Exe_Directory + 'monitor.ini', el_Info);
    Ini := TIniFile.Create(VAR_GLOB.Exe_Directory + 'monitor.ini');
    try
       FDBFile := Ini.ReadString('SQLite','dbfile','');

       // niveau de log
       vdebug := Ini.Readinteger('SMONITOR','debug',0);
       Case vdebug of
        0: Log_ChangeNiv(el_silent);
        1: Log_ChangeNiv(el_Erreur);
        2: Log_ChangeNiv(el_Warning);
        3: Log_ChangeNiv(el_Info);
        4: Log_ChangeNiv(el_Debug);
       End;

       FStop   := true;
       FPath   := Ini.ReadString('SMONITOR','path',path_script);
       FAuto   := Ini.ReadInteger('SMONITOR','auto',1)=1;
       Ftempo  := Ini.Readinteger('SMONITOR','tempo',10);
       FStart  := Ini.Readinteger('SMONITOR','start',60);
       FTBLog  := Ini.ReadInteger('SMONITOR','tblog',1)=1;

       Timer1.Interval := 1000*Ftempo;
       Timer2.Enabled  := true;
       //---------------------------
       Log_Write('SQLite  : '+ FDBFile, el_Info);
       if FAuto
        then Log_Write('auto    : True', el_Info)
        else Log_Write('auto    : False', el_Info);
       Log_Write('url     : '+ FPath, el_Info);
       Log_Write('tempo   : '+ IntToStr(Ftempo), el_Info);
       Log_Write('start   : '+ IntToStr(FStart), el_Info);
       DataMod.SQLiteStartConnexion(FDBFile,false);

       LoadDatas;
       FOk:=True;
    finally
       Ini.Free;
    end;
end;

procedure TServiceMONITOR.Raichissement(Const all:Boolean=False);
begin
    if fOk then
       begin
           fOk:=False;
            if (all=true)
              then
                  begin
                       FDQMONITOR.First;
                       while not(FDQMONITOR.eof) do
                         begin
                              AnalyseLigneCourante;
                              FDQMONITOR.Next;
                         end;
                  end
              else
                 begin
                      AnalyseLigneCourante;
                      if (FDQMONITOR.RecNo=FDQMONITOR.RecordCount)
                         then
                              begin
                                  FDQMONITOR.Refresh;
                                  FDQMONITOR.First;
                              end
                         else FDQMONITOR.Next;
                 end;
             fOk:=true;
       end;
end;


function TServiceMONITOR.CleanMonitorLigneCourante:string;
var idhttp:TIdHttp;
    Ts : TStringList;
    resultat:string;
begin
    // est-ce qu'il y a des nettoyages à faire ?
    result:='';
    idhttp:=TidHttp.Create(Self);
    Ts := TStringList.Create;
    try
      try
       Ts.Add(Format('lame=%s',[FDQMONITOR.FieldByName('MON_SERVER').AsString]));
       Ts.Add(Format('dossier=%s',[FDQMONITOR.FieldByName('MON_DOSSIER').AsString]));
       idhttp.Request.ContentType := 'application/x-www-form-urlencoded';
       resultat:=idhttp.Post(FPath+ws_ordre, Ts);
       Log_Write(resultat, el_Info);
       // ****************************************//
       if Length(resultat)>0 then
         begin
             result:=resultat;
         end;
      except On E:Exception do
          // rien
          result:='';
      end;
    finally
      Ts.free;
      idHttp.Free;
    end;
end;


procedure TServiceMONITOR.AnalyseLigneCourante;
var PQuery:TFDQuery;
    Parametres:string;
    sAuto:string;
    nerror:Integer;
    astring:string;
    sNewFileName:string;
    Json_str:string;
    Delete_Senders:string;

begin
     Log_Write('AnalyseLigneCourante', el_debug);
     // Sortie si le record est en "pause"
     if FDQMONITOR.FieldByName('MON_PAUSE').Asboolean then exit;
     //
     if FAuto
      then sAuto:='-auto '
      else sAuto:='';
     //--------------
     if FDQMONITOR.RecordCount=0
      then
          begin
               Stop:=true;
               exit;
          end;
     //-------------------------------------------------------------------------
     PQuery:=TFDQuery.Create(DataMod);
     try
        DataMod.FDConIB.Params.Clear;
        DataMod.FDConIB.Params.Add('DriverID=IB');
        DataMod.FDConIB.Params.Add('Server=' + FDQMONITOR.FieldByName('MON_SERVER').AsString);
        DataMod.FDConIB.Params.Add('Database='+ FDQMONITOR.FieldByName('MON_DATABASE').AsString);
        DataMod.FDConIB.Params.Add('User_Name=GINKOIA');
        DataMod.FDConIB.Params.Add('Password=ginkoia');
        DataMod.FDConIB.Params.Add('Protocol=TCPIP');
        Try
           DataMod.FDConIB.open;
           If DataMod.FDConIB.Connected then
            begin
                Log_Write(Format('Connexion à IB : %s/%s [OK]',[FDQMONITOR.FieldByName('MON_SERVER').AsString,FDQMONITOR.FieldByName('MON_DATABASE').AsString]), el_Info);
                PQuery.Connection:=DataMod.FDConIB;
                PQuery.Transaction:=DataMod.FDtransIB;
                PQuery.Close;
                Delete_Senders:=CleanMonitorLigneCourante;
                if Delete_Senders<>'' then
                  begin
                      PQuery.Transaction.Options.ReadOnly:=false;
                      DataMod.FDTransIB.StartTransaction;
                      PQuery.SQL.Clear;
                      PQuery.SQL.Add(Format('DELETE FROM LOG WHERE LOG_SENDER IN (%s);',[Delete_Senders]));
                      Log_Write(PQuery.SQL.Text, el_Info);
                      PQuery.ExecSQL;
                      // envoyer le >>> PQuery.RowsAffected;
                      Log_Write(IntToStr(PQuery.RowsAffected), el_Info);
                      DataMod.FDtransIB.Commit;
                  end;

                PQuery.Transaction.Options.ReadOnly:=true;
                if FTBLOG then
                  begin
                       DataMod.FDTransIB.StartTransaction;
                       try
                          If (FDQMONITOR.FieldByName('MON_LOGID').asinteger=0) then
                              begin
                                  PQuery.SQL.Clear;
                                  // PQuery.SQL.Add('SELECT MAX(LOG_ID) FROM LOG');
                                  PQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE');
                                  PQuery.Open;

                                  FDQMONITOR.Edit;
                                  FDQMONITOR.FieldByName('MON_LOGID').Asinteger:=PQuery.Fields[0].Asinteger;
                                  FDQMONITOR.Post;
                              end
                          else
                              begin
                                  PQuery.SQL.Clear;
                                  PQuery.SQL.Add('SELECT * FROM LOG WHERE LOG_ID>:LASTLOGID ORDER BY LOG_ID ASC ROWS 50');
                                  PQuery.ParamByName('LASTLOGID').AsInteger:=FDQMONITOR.FieldByName('MON_LOGID').Asinteger;
                                  PQuery.Open;
                                  Json_str:='';
                                  if not(PQuery.IsEmpty)
                                     then
                                       begin
                                              While not(PQuery.Eof) do
                                                begin
                                                     // ici on pourra recuperer la table log petit bout par petit bout..
                                                     Json_str:=Json_str+Format('{LOG_ID:%d,LOG_OPERATION:%s,LOG_STATUS:%s',
                                                     [PQuery.FieldByName('LOG_ID').asinteger,
                                                      PQuery.FieldByName('LOG_OPERATION').asstring,
                                                      PQuery.FieldByName('LOG_STATUS').AsString]);
                                                     json_str:=Json_str+Format(',LOG_STARTING:%d,LOG_DONE:%d,LOG_DURATION:%s,LOG_SENDER:%s,LOG_XMLSERVICE:%s,LOG_RECORDCOUNT:%d}',
                                                     [DateTimeToUNIXTimeFAST(PQuery.FieldByName('LOG_STARTING').asDateTime),
                                                      DateTimeToUNIXTimeFAST(PQuery.FieldByName('LOG_DONE').asDateTime),
                                                      PQuery.FieldByName('LOG_DURATION').AsString,
                                                      PQuery.FieldByName('LOG_SENDER').AsString,
                                                      PQuery.FieldByName('LOG_XMLSERVICE').AsString,
                                                      PQuery.FieldByName('LOG_RECORDCOUNT').AsInteger
                                                      ]);
                                                     PQuery.Next;
                                                end;
                                            If (LancementWDPOST) then
                                              begin
                                                   if length(Json_str)>MAX_JSONLENGTH then
                                                     begin
                                                        sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_monitor_log_script','.tmp');
                                                        SaveStrToFile(sNewFileName,Format('l:%s,d:%s,j:[%s]',[
                                                            FDQMONITOR.FieldByName('MON_SERVER').AsString,
                                                            FDQMONITOR.FieldByName('MON_DOSSIER').AsString,
                                                            Json_str]));
                                                        Parametres:=Format('%s-url=%s -psk=AD8FE63 -file="%s"',[
                                                        sauto,
                                                        FPath + ws_monitor_log_script,sNewFileName]);
                                                     end
                                                   else
                                                     begin
                                                      Parametres:=Format('%s-url=%s -psk=AD8FE63 -json=l:%s,d:%s,j:[%s]',[
                                                          sAuto,
                                                          FPath + ws_monitor_log_script,
                                                          FDQMONITOR.FieldByName('MON_SERVER').AsString,
                                                          FDQMONITOR.FieldByName('MON_DOSSIER').AsString,
                                                          Json_str]);
                                                     end;
                                                   Log_Write('WDPOST.exe ' + Parametres, el_Debug);
                                                   ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                                   FDQMONITOR.Edit;
                                                   FDQMONITOR.FieldByName('MON_LOGID').Asinteger:=PQuery.FieldByName('LOG_ID').Asinteger;
                                                   FDQMONITOR.Post;
                                              end;
                                          end;
                                   end;
                                  DataMod.FDtransIB.Commit;
                            except
                                  DataMod.FDtransIB.Rollback;
                            end;
                  end;
                  PQuery.Close;
                  PQuery.SQL.Clear;
                  PQuery.SQL.Add(Format('SELECT * FROM %s',[VMonitior_procedure]));
                  PQuery.Transaction.StartTransaction;
                     try
                         PQuery.Open;
                         Json_str:='';
                         While not(PQuery.Eof) do
                              begin
                                   Json_str:=Json_str + Format('{s:%s,t1:%d,t2:%d}',[
                                      PQuery.Fields[0].AsString,
                                      DateTimeToUNIXTimeFAST(PQuery.Fields[1].AsDateTime),
                                      DateTimeToUNIXTimeFAST(PQuery.Fields[2].AsDateTime)]
                                      );
                                   PQuery.Next;
                              end;
                          // On va voir s'il n'y a pas déjà 20 process de lancé sur WDPOST.
                          If (LancementWDPOST) then
                              begin
                                   if length(Json_str)>Max_JsonLength then
                                      begin
                                        sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_monitor_script','.tmp');
                                         SaveStrToFile(sNewFileName,Format('l:%s,d:%s,j:[%s]',[
                                          FDQMONITOR.FieldByName('MON_SERVER').AsString,    // lame
                                          FDQMONITOR.FieldByName('MON_DOSSIER').AsString,Json_str]));
                                          Parametres:=Format('%s-url=%s -psk=EFC79H6 -file="%s"',[
                                                       sauto,
                                                       FPath+ws_monitor_script,
                                                       sNewFileName]);
                                      end
                                   else
                                      begin
                                           Parametres:=Format('%s-url=%s -psk=EFC79H6 -json=l:%s,d:%s,j:[%s]',[
                                                                 sAuto,
                                                                 FPath+ws_monitor_script,
                                                                 FDQMONITOR.FieldByName('MON_SERVER').AsString,  // lame
                                                                 FDQMONITOR.FieldByName('MON_DOSSIER').AsString,
                                                                 Json_str]);
                                      end;
                                   Log_Write('WDPOST.exe ' + Parametres, el_Debug);
                                   ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                   FDQMONITOR.Edit;
                                   FDQMONITOR.FieldByName('MON_LASTWDPOST').AsDateTime:=Now();
                                   FDQMONITOR.Post;
                              end;
                          DataMod.FDtransIB.Commit;
                      Except
                         DataMod.FDtransIB.Rollback;
                      end;
                      PQuery.Close;

                DataMod.FDConIB.Close;
            end;
            Except
                On E: EFDDBEngineException  do
                   begin
                      Log_Write(Format('Connexion à IB : %s/%s [ERREUR]',[FDQMONITOR.FieldByName('MON_SERVER').AsString,FDQMONITOR.FieldByName('MON_DATABASE').AsString]), el_Erreur);
                      Log_Write(Format('EFDDBEngineException %d : %s ',[E.ErrorCode,E.Message]), el_Erreur);

                   end;
               On Ex: Exception do
                   begin
                      Log_Write(Format('Connexion à IB : %s/%s [ERREUR]',[FDQMONITOR.FieldByName('MON_SERVER').AsString,FDQMONITOR.FieldByName('MON_DATABASE').AsString]), el_Erreur);
                      Log_Write(Format('Exception %s : %s [ERREUR]',[EX.ClassName,EX.Message]), el_Erreur);
                   End;
            End;
     finally
        PQuery.Close;
        PQuery.Free;
     end;
end;




end.

unit USJETON;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, MidasLib, Vcl.ExtCtrls,
  Data.DB, Datasnap.DBClient,  FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.DApt,GestionLog,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys ,
  FireDAC.Comp.Client,ShellAPi,System.IniFiles, FireDAC.Stan.Intf,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet;

type
  TServiceJETON = class(TService)
    Timer1: TTimer;
    Timer2: TTimer;
    FDQJETON: TFDQuery;
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
  private
    FCleanFlag : Integer;
    FAuto    : boolean;
    FStop    : boolean;
    FOk      : Boolean;
    FPath    : string;
    FUrl     : string;
    FUrl_hr  : string;
    FUrl_hr0 : string;
    Ftempo   : integer;
    FStart   : integer;
    FDBFile  : string;
    FNbPassage : Integer;
    NbPassageCurrent : Integer;
    procedure AnalyseLigneCourante;
    { Déclarations privées }
    function GetStop():boolean;
    procedure SetStop(avalue:boolean);
    procedure Raichissement(Const all:Boolean=False);
    // function DataSetToJson(ADataSet:TDataSet):String;
    procedure LoadDatas;
    procedure LoadParams;
  public
    function GetServiceController: TServiceController; override;
  property
    Stop:Boolean read GetStop write setStop;
    { Déclarations publiques }
  end;

var
  ServiceJETON: TServiceJETON;

implementation

{$R *.DFM}

uses UDataMod,UCommun;


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceJETON.Controller(CtrlCode);
end;

function TServiceJETON.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


function TServiceJETON.GetStop():boolean;
begin
     result:=FStop;
end;

procedure TServiceJETON.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
    Log_Write('Reprise du service', el_Info);
    LoadParams;
    Stop:=false;
end;

procedure TServiceJETON.ServicePause(Sender: TService; var Paused: Boolean);
begin
    Log_Write('Pause du service', el_Info);
    Stop:=true;
end;

procedure TServiceJETON.ServiceStart(Sender: TService; var Started: Boolean);
begin
    Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
    Log_Write('Démarage du service', el_Info);
    LoadParams;
end;

procedure TServiceJETON.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
    Log_Write('Arret du service', el_Info);
    Stop:=true;
end;

procedure TServiceJETON.SetStop(avalue:boolean);
begin
     FStop:=avalue;
     Timer1.Enabled:=not(aValue);
end;


procedure TServiceJETON.Timer1Timer(Sender: TObject);
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

procedure TServiceJETON.Timer2Timer(Sender: TObject);
begin
     Dec(FStart);
     Log_Write(Format('Lancement dans %d secondes',[FStart]), el_Info);
     if FStart<=0 then
      begin
          Stop:=false;
          Timer2.Enabled:=false;
      end;
end;

procedure TServiceJETON.LoadDatas;
var PQuery:TFDQuery;
    i:integer;
begin
     Log_Write('LoadDatas');
     PQuery:=TFDQuery.Create(DataMod);
     try
       try
        PQuery.Connection:=DataMod.FDConSQLite;
        PQuery.Connection.Open;
        if PQuery.Connection.Connected then
           begin
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT CON_ID, CON_PATH, CON_NOM, CON_SERVER, CON_PATH FROM CONNEXION WHERE CON_FAV=1 AND CON_PATH<>'''' ORDER BY CON_NOM');
                PQuery.Open;

                // FDQJETON.close;
                // FDQJETON.SQL.Clear;
                // FDQJETON.SQL.Add('DELETE FROM VJETON');
                // FDQJETON.ExecSQL;
                // Log_Write('DELETE FROM VJETON');

                FDQJETON.Close;
                FDQJETON.SQL.Clear;
                FDQJETON.SQL.Add('SELECT * FROM VJETON');
                FDQJETON.Open;

                // VJETON n'avait pas ce dossier ==> on ajoute
                while not(PQuery.Eof) do
                    begin
                         // Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
                         // Quand on est en V11.3 pour le monitor on laisse à vide la CON_PATH
                          if not(FDQJETON.Locate('JET_DOSSIER',PQuery.FieldbyName('CON_NOM').asstring,[])) then
                              begin
                                 FDQJETON.Append;
                                 FDQJETON.FieldByName('JET_DOSSIER').aswidestring:=PQuery.FieldbyName('CON_NOM').asstring;
                                 FDQJETON.FieldByName('JET_SERVER').aswidestring:=PQuery.FieldbyName('CON_SERVER').asstring;
                                 FDQJETON.FieldByName('JET_DATABASE').aswidestring:=PQuery.FieldbyName('CON_PATH').asstring;
                                 FDQJETON.FieldByName('JET_HRFLAG').AsBoolean:=false;
                                 FDQJETON.Post;
                              end
                          else
                            begin
                                 FDQJETON.Edit;
                                 // Si Changement de Lame
                                 FDQJETON.FieldByName('JET_SERVER').aswidestring:=PQuery.FieldbyName('CON_SERVER').asstring;
                                 // Si changement de Lame/chemin
                                 FDQJETON.FieldByName('JET_DATABASE').aswidestring:=PQuery.FieldbyName('CON_PATH').asstring;
                                 // réinit de HRFlag au redeamrrage du service...
                                 FDQJETON.FieldByName('JET_HRFLAG').AsBoolean:=false;
                                 FDQJETON.Post;
                            end;
                         PQuery.Next;
                    end;
                FDQJETON.Last;
                while not(FDQJETON.bof) do
                  begin
                      if not(PQuery.Locate('CON_NOM',FDQJETON.FieldbyName('JET_DOSSIER').asstring,[])) then
                         begin
                            FDQJETON.Delete;
                         end;
                       FDQJETON.Prior;
                  end;
                PQuery.Close;
                NbPassageCurrent:= FNbPassage * FDQJETON.RecordCount + 1;  // le + 1 permet d'avoir un nombre premier avec recordcount
           end
        else
          begin
              Log_Write('LoadDatas : Erreur Connexion à ' + DataMod.FDConSQLite.Params.Text);
          end;
       except on E:Exception do
         Log_Write('LoadDatas : Erreur '+ E.Message, el_Info);
       end;
     finally
       PQuery.Free;
     end;
end;

procedure TServiceJETON.LoadParams;
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
       vdebug := Ini.Readinteger('SJETON','debug',0);
       Case vdebug of
        0: Log_ChangeNiv(el_silent);
        1: Log_ChangeNiv(el_Erreur);
        2: Log_ChangeNiv(el_Warning);
        3: Log_ChangeNiv(el_Info);
        4: Log_ChangeNiv(el_Debug);
       End;

       FStop   := true;
       Path    := Ini.ReadString('SJETON','path','');
       FAuto   := Ini.ReadInteger('SJETON','auto',1)=1;
       Ftempo  := Ini.Readinteger('SJETON','tempo',10);
       FStart  := Ini.Readinteger('SJETON','start',60);
       FNbPassage := Ini.Readinteger('SJETON','nbpassage',1000);
       // Les URL
       FPath     := Path;
       FUrl      := Path + script;
       FUrl_hr   := Path + script_hr;
       FUrl_hr0  := Path + script_hr0;
       Timer1.Interval := 1000*Ftempo;
       Timer2.Enabled  := true;
       //---------------------------
       Log_Write('SQLite  : '+ FDBFile, el_Info);
       if FAuto
        then Log_Write('auto    : True', el_Info)
        else Log_Write('auto    : False', el_Info);
       Log_Write('url     : '+ FUrl, el_Info);
       Log_Write('url_hr  : '+ FUrl_hr, el_Info);
       Log_Write('url_hr0 : '+ FUrl_hr0, el_Info);
       //---------------------------
       Log_Write('tempo   : '+ IntToStr(Ftempo), el_Info);
       Log_Write('start   : '+ IntToStr(FStart), el_Info);

       DataMod.SQLiteStartConnexion(FDBFile,false);
       LoadDatas;
       FOk:=True;
    finally
       Ini.Free;
    end;
end;

procedure TServiceJETON.Raichissement(Const all:Boolean=False);
begin
    if fOk then
       begin
           try
              fOk:=False;
              if (all=true)
                 then
                      begin
                           FDQJETON.Refresh;
                           FDQJETON.First;
                           while not(FDQJETON.eof) do
                             begin
                                  AnalyseLigneCourante;
                                  FDQJETON.Next;
                             end;
                      end
                  else
                     begin
                          Log_Write('NbPassageCurrent:' + IntToStr(NbPassageCurrent), el_Debug);
                          Dec(NbPassageCurrent);
                          AnalyseLigneCourante;
                          if NbPassageCurrent<=0 then
                            begin
                              NbPassageCurrent:= FNbPassage*FDQJETON.RecordCount + 1;
                            end;
                          Log_Write('NbPassageCurrent:' + IntToStr(NbPassageCurrent), el_Debug);
                          if (FDQJETON.RecNo=FDQJETON.RecordCount)
                             then
                                 begin
                                     FDQJETON.Refresh;
                                     FDQJETON.First
                                 end
                             else FDQJETON.Next;
                     end;
           finally
             fOk:=true;
           end;
       end;
end;

procedure TServiceJETON.AnalyseLigneCourante;
var PQuery:TFDQuery;
    Parametres:string;
    sAuto:string;
    nerror:Integer;
    astring:string;
    sNewFileName:string;
begin
     Log_Write('AnalyseLigneCourante', el_Debug);
     if FDQJETON.RecordCount=0
      then
          begin
               Stop:=true;
               exit;
          end;

     if FAuto
      then sAuto:='-auto '
      else sAuto:='';

     // Gestion de la pause....
     if FDQJETON.FieldByName('JET_PAUSE').asboolean
      then
          begin
               Log_Write(Format('%s/%s : [PAUSE]',[FDQJETON.FieldByName('JET_SERVER').AsString,FDQJETON.FieldByName('JET_DATABASE').AsString]), el_Info);
               Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,pause:1',[
                                  sAuto,FUrl,
                                  FDQJETON.FieldByName('JET_DOSSIER').AsString,
                                  FDQJETON.FieldByName('JET_SERVER').AsString]
                                  );
              Log_Write('WDPOST.exe ' + Parametres, el_Erreur);
              ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
              exit;
          end;

     //-------------------------------------------------------------------------
     PQuery:=TFDQuery.Create(DataMod);
     try
        DataMod.FDConIB.Params.Clear;
        DataMod.FDConIB.Params.Add('DriverID=IB');
        DataMod.FDConIB.Params.Add('Server=' + FDQJETON.FieldByName('JET_SERVER').AsString);
        DataMod.FDConIB.Params.Add('Database='+ FDQJETON.FieldByName('JET_DATABASE').AsString);
        DataMod.FDConIB.Params.Add('User_Name=GINKOIA');
        DataMod.FDConIB.Params.Add('Password=ginkoia');
        DataMod.FDConIB.Params.Add('Protocol=TCPIP');
        DataMod.FDConIB.Txoptions.Readonly:=true;
        DataMod.FDTransIB.options.Readonly:=true;
        Try
           DataMod.FDConIB.open;
           If DataMod.FDConIB.Connected then
            begin
                Log_Write(Format('Connexion à IB : %s/%s : [ OK ]',[FDQJETON.FieldByName('JET_SERVER').AsString,FDQJETON.FieldByName('JET_DATABASE').AsString]), el_Info);
                PQuery.Connection:=DataMod.FDConIB;
                PQuery.Close;
                {-------------------------------------------------------------}
                if (not(FDQJETON.FieldByName('JET_HRFLAG').Asboolean) or (NbPassageCurrent<=0))
                    then
                        begin
                            // CustomFileCopy('\\192.168.10.86\c$\Embarcadero\interbase\interbase.log','C:\windows\temp\__interbase.log');
                            //--------------------------------------------------
                            // 'ws_ginkoia_bases'
                            //  WS_GINKOIA_BASES
                            astring:='';
                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_IDENT, BAS_JETON, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_CENTRALE, BAS_NOMPOURNOUS FROM GENBASES JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 WHERE BAS_ID<>0');
                            astring:=DataSetToJson(TDataSet(PQuery));
                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_bases,'EA157EDA');


                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT MAG_ID, MAG_NOM, MAG_ENSEIGNE FROM GENMAGASIN JOIN K ON K_ID=MAG_ID AND K_ENABLED=1 WHERE MAG_ID<>0');
                            astring:=DataSetToJson(TDataSet(PQuery));
                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_magasins,'4FEDA478');

                            PQuery.Close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add('SELECT VER_DATE, VER_VERSION FROM GENVERSION order BY VER_DATE DESC ROWS 1');
                            astring:=DataSetToJson(TDataSet(PQuery));
                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_version,'FDZ71UIF');

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
                            astring:=DataSetToJson(TDataSet(PQuery));
                            WDPost(FDQJETON.FieldByName('JET_DOSSIER').AsString,astring,sAuto,FPath+ws_ginkoia_module,'BDE84DFA11');

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
                                   astring:=astring+Format('{s:%s,run:%d,a1:%d,a2:%d,h1:%s,h2:%s}',[
                                            PQuery.FieldByName('BAS_SENDER').asstring,
                                            PQuery.FieldByName('LAU_AUTORUN').asinteger,
                                            PQuery.FieldByName('LAU_H1').AsInteger,
                                            PQuery.FieldByName('LAU_H2').AsInteger,
                                            StringReplace(Trim(PQuery.FieldByName('LAU_HR1').asstring),',','.',[rfReplaceAll]),
                                            StringReplace(Trim(PQuery.FieldByName('LAU_HR2').asstring),',','.',[rfReplaceAll])
                                            ]);
                                   PQuery.Next;
                              end;
                           PQuery.close;
                           if (astring<>'')
                              then
                                  begin
                                       if length(astring)>MAX_JSONLENGTH then
                                          begin
                                               sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_hr0','.tmp');
                                               SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[FDQJETON.FieldByName('JET_DOSSIER').AsString,astring]));
                                               Parametres:=Format('%s-url=%s -psk=DE78FA4AB -file="%s"',[
                                                 sauto,
                                                 FUrl_hr0,
                                                 sNewFileName]);
                                          end
                                          else
                                          begin
                                             Parametres:=Format('%s-url=%s -psk=DE78FA4AB -json=d:%s,j:[%s]',[
                                                          sAuto,
                                                          FUrl_hr0,
                                                          FDQJETON.FieldByName('JET_DOSSIER').AsString,
                                                          astring]
                                                          );
                                          end;
                                       Log_Write('WDPOST.exe ' + Parametres, el_Debug);
                                       ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                  end;
                            // replication ... 15 mintues
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
                                   astring:=astring+Format('{s:%s,a:%d,h%s:%8.8f}',[
                                            PQuery.FieldByName('BAS_SENDER').asstring,
                                            PQuery.FieldByName('REP_JOUR').asinteger,
                                            PQuery.FieldByName('PRM_CODE').asstring,
                                            PQuery.FieldByName('HR').asfloat
                                            ]);
                                   PQuery.Next;
                              end;

                           PQuery.close;
                           if (astring<>'')
                              then
                                  begin
                                       if length(astring)>MAX_JSONLENGTH then
                                          begin
                                               sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_hr','.tmp');
                                               SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[FDQJETON.FieldByName('JET_DOSSIER').AsString,astring]));
                                               Parametres:=Format('%s-url=%s -psk=CD789FE12D -file="%s"',[
                                                 sauto,
                                                 FUrl_hr,
                                                 sNewFileName]);
                                          end
                                       else
                                           begin
                                                Parametres:=Format('%s-url=%s -psk=CD789FE12D -json=d:%s,j:[%s]',[
                                                 sAuto,
                                                  FUrl_hr,
                                                  FDQJETON.FieldByName('JET_DOSSIER').AsString,
                                                  astring]
                                                  );
                                           end;
                                       Log_Write('WDPOST.exe ' + Parametres, el_Debug);
                                       ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                  end;
                           FDQJETON.Edit;
                           FDQJETON.FieldByName('JET_HRFLAG').asboolean:=true;
                           FDQJETON.post;
                        end;
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT JET_NOMPOSTE, JET_STAMP, BAS_NOM, BAS_SENDER FROM GENJETONS JOIN GENBASES ON JET_BASID=BAS_ID ORDER BY JET_STAMP DESC');
                PQuery.Open;
                If not(PQuery.IsEmpty) then
                     begin
                          FDQJETON.Edit;
                          FDQJETON.FieldByName('JET_POSTE').AsString:=PQuery.FieldByName('JET_NOMPOSTE').AsString;
                          FDQJETON.FieldByName('JET_DATEHEURE').AsDateTime:=PQuery.FieldByName('JET_STAMP').AsDateTime;
                          FDQJETON.FieldByName('JET_BASE').AsString:=PQuery.FieldByName('BAS_NOM').AsString;
                          FDQJETON.FieldByName('JET_SENDER').AsString:=PQuery.FieldByName('BAS_SENDER').AsString;
                           //    90.83.227.43
                     end
                  Else
                    begin
                         FDQJETON.Edit;
                         FDQJETON.FieldByName('JET_POSTE').AsString:='';
                         FDQJETON.FieldByName('JET_DATEHEURE').AsString:='';
                         FDQJETON.FieldByName('JET_BASE').AsString:='';
                         FDQJETON.FieldByName('JET_SENDER').AsString:='';
                    end;
                //***//
                PQuery.Close;
                // On va voir s'il n'y a pas déjà 20 process de lancer sur WDPOST.
                If (LancementWDPOST) then
                    begin
                         Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,t:%d,s:%s',[
                                              sAuto,
                                              FUrl,
                                              FDQJETON.FieldByName('JET_DOSSIER').AsString,
                                              FDQJETON.FieldByName('JET_SERVER').AsString,
                                               DateTimeToUNIXTimeFAST(FDQJETON.FieldByName('JET_DATEHEURE').AsDateTime),
                                               FDQJETON.FieldByName('JET_SENDER').AsString]
                                              );
                         Log_Write('WDPOST.exe ' + Parametres, el_Debug);
                         ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                         FDQJETON.FieldByName('JET_LASTWDPOST').AsDateTime:=Now();
                    end;
                FDQJETON.Post;
            end;
            Except
                On E: EFDDBEngineException  do
                    begin
                         Log_Write(Format('Connexion à IB : %s/%s : [ ERREUR ]',[FDQJETON.FieldByName('JET_SERVER').AsString,FDQJETON.FieldByName('JET_DATABASE').AsString]), el_Erreur);
                         Log_Write(Format('EFDDBEngineException %d : %s ',[E.ErrorCode,E.Message]), el_Erreur);
                         Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,e:%d',[
                                     sAuto,
                                     FUrl,
                                     FDQJETON.FieldByName('JET_DOSSIER').AsString,
                                     FDQJETON.FieldByName('JET_SERVER').AsString,
                                     E.ErrorCode]
                                     );
                         Log_Write('WDPOST.exe ' + Parametres, el_Erreur);
                         ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                    end;
               On Ex: Exception do
                   begin
                      Log_Write(Format('Connexion à IB : %s/%s [ERREUR]',[FDQJETON.FieldByName('JET_SERVER').AsString,FDQJETON.FieldByName('JET_DATABASE').AsString]), el_Erreur);
                      Log_Write(Format('Exception %s : %s [ERREUR]',[EX.ClassName,EX.Message]), el_Erreur);
                      Log_Write('WDPOST.exe ' + Parametres, el_Erreur);
                      Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,e:500,',[
                                              sAuto,
                                              FUrl,
                                              FDQJETON.FieldByName('JET_DOSSIER').AsString,
                                              FDQJETON.FieldByName('JET_SERVER').AsString]
                                             );
                      ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                   End;
        End;
     finally
        DataMod.FDConIB.Close;
        PQuery.Close;
        PQuery.Free;
     end;
end;




end.

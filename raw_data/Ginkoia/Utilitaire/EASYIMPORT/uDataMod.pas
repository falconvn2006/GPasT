unit uDataMod;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Comp.Client, Data.DB,Winapi.Windows,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, FireDAC.Phys.IBWrapper ;

type
  TStatusMessageCall = Procedure (const info:String) of object;

  TDataMod = class(TDataModule)
    FDCon: TFDConnection;
    FDTrans: TFDTransaction;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Déclarations privées }
    procedure CreateInFDManager({aServer:string;}aUser:string;aFile:string);
  public
    { Déclarations publiques }
    // procedure DROP_SYMDS(const ABaseDonnees: TFileName);
    function getNewConnexion(aRef:string): TFDConnection;
    function getNewQuery(aConnection : TFDConnection ;  aTrans: TFDTransaction): TFDQuery;
    function NbTableTriggersSymDS(const ABaseDonnees: TFileName):integer;
    function NbTriggersSymDS(const ABaseDonnees: TFileName):integer;

    function NbTriggersGINKOIA_Actifs(const ABaseDonnees: TFileName):integer;
    procedure FreeInfFDManager(aRef:string);
  end;

var
  DataMod: TDataMod;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

(*
procedure TDataMod.DROP_SYMDS(const ABaseDonnees: TFileName);
var sdirectory:string;
    sProgUninstall:string;
    vScript:TFDScript;
    vScriptFile : string;
    BufferSQL:string;
    i:integer;
    chaine:string;
    vCnx    : TFDConnection;
    vQuery  : TFDQuery;
    ResInstallateur : TResourceStream;

begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript:=TFDScript.Create(nil);
    vScript.Connection:=vCnx;

    vScriptFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'truncate_symds.sql';
    if FileExists(vScriptFile)
      then System.SysUtils.DeleteFile(vScriptFile);

    ResInstallateur := TResourceStream.Create(HInstance, 'truncate_symds', RT_RCDATA);
    try
       ResInstallateur.SaveToFile(vScriptFile);
      finally
       ResInstallateur.Free();
    end;

    try
       try
       vCnx.open;
       If vCnx.Connected then
          begin
               With TStringList.Create do
                   try
                      LoadFromFile(vScriptFile);
                      BufferSQL:='';
                      for i:= 0 to Count-1 do
                        begin
                             IF Pos('^', Strings[i]) = 0
                                then BufferSQL := BufferSQL + #13 + #10 + Strings[i];
                             IF Pos('^',  Strings[i]) = 1
                                then
                                    begin
                                        if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                                            then
                                                begin
                                                     // vQuery.Transaction.StartTransaction;
                                                     vQuery.Close;
                                                     vQuery.SQL.Clear;
                                                     vQuery.SQL.Add(BufferSQL);
                                                     vQuery.Prepare;
                                                     vQuery.Open;
                                                     vQuery.FetchAll();
                                                     // vQuery.Transaction.Commit;
                                                     vQuery.Close;
                                                end
                                            else
                                              try
                                               // vScript.Transaction.StartTransaction;
                                               vScript.SQLScripts.Clear;
                                               vScript.SQLScripts.Add;
                                               vScript.SQLScripts[0].SQL.Add(Trim(BufferSQL));
                                               vScript.ValidateAll;
                                               vScript.ExecuteAll;
                                               // vScript.Transaction.Commit;
                                               // FStatus:=Format('Ligne N°%d : [OK]' ,[i]);
                                               // Synchronize(UpdateVCL);
                                               Except On Ez:Exception do
                                                 begin
                                                    // FStatus:=Format('Ligne N°%d : [ERREUR]',[i]);
                                                    // if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                                                    exit;
                                                     // MessageDlg(Ez.Message,  mtCustom, [mbOK], 0);
                                                 end;
                                            end;
                                       BufferSQL:='';
                                    end;
                        end;
                     finally
                        Free;
                   end;
          end;
       Except On Ez : Exception do
                 begin
                    //
                 end;
        end;
     finally
        vScript.Free;
        vQuery.Close;
        vQuery.DisposeOf;
        vCnx.DisposeOf;
        // Libération du POOL
        DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
    end;

   // -----------
   Sleep(10*1000); // 10 secondes
   // -----------
   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
      try
       vScript:=TFDScript.Create(nil);
       vScript.Connection:=vCnx;
       vScript.SQLScripts.Clear;
       vScript.SQLScripts.Add;
       vScript.SQLScripts[0].SQL.Add('DELETE FROM SYM_DATA;');
       vScript.ValidateAll;
       vScript.ExecuteAll;
     Except On Ez:Exception do
       begin
         //
       end;
     end;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;

   // -----------
   Sleep(10*1000); // 10 secondes
   // -----------

   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
     try
     vScript:=TFDScript.Create(nil);
     vScript.Connection:=vCnx;

     vScript.SQLScripts.Clear;
     vScript.SQLScripts.Add;
     vScript.SQLScripts[0].SQL.Add('DELETE FROM SYM_NODE_IDENTITY;');
     vScript.ValidateAll;
     vScript.ExecuteAll;
     Except On Ez:Exception do
       begin
         //
       end;
     end;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;
end;

*)

function TDataMod.getNewQuery(aConnection : TFDConnection ;  aTrans: TFDTransaction): TFDQuery;
begin
  try
    Result := TFDQuery.Create(Self) ;
    Result.Connection := aConnection ;
    if Assigned(aTrans)
      then Result.Transaction := aTrans ;
  except
    raise ;
  end;
end;

procedure TDataMod.FreeInfFDManager(aRef:string);
var bfound: boolean;
    i:Integer;
begin
    for i:=FDManager.ConnectionDefs.Count-1 downto 0  do
        begin
          If FDManager.ConnectionDefs[i].Name=aRef
            then
              begin
                FDManager.ConnectionDefs[i].Delete;
                Break;
              end;
        end;
end;

procedure TDataMod.CreateInFDManager({aServer:string;}aUser:string;aFile:string);
var  vParams : TStringList ;
     vtext:string;
     vServer : string;
     vFile   : string;
     Splitted : TArray<string>;
begin
  vServer  := 'localhost';
  vFile    := aFile;

  Splitted := aFile.Split(['/']);
  if Length(Splitted)=2
    then
      begin
        vServer := Splitted[0];
        vFile   := Splitted[1];
      end;


  vParams := TStringList.Create ;
  try
    vParams.Add('DriverID=IB') ;
    vParams.Add('Server='+vServer) ;
    vParams.Add('Protocol=TCPIP') ;
    vParams.Add('Port=3050') ;
    vParams.Add('Database='  + vFile) ;
    if aUser='SYSDBA'
      then
        begin
          vParams.Add('User_Name=SYSDBA');
          vParams.Add('Password=masterkey');
        end;
    if aUser='GINKOIA'
      then
        begin
          vParams.Add('User_Name=GINKOIA');
          vParams.Add('Password=ginkoia');
        end;
    // vParams.Add('Pooled=true') ;
    vtext := Format('%s@%s',[aUser,aFile]);
    FDManager.AddConnectionDef(vText, 'IB', vParams);    // true
  finally
    vParams.Free;
  end;
end;

function TDataMod.getNewConnexion(aRef:string): TFDConnection;
var tc : Cardinal ;
    i  : integer;
    bFound : boolean;
    Splitted: TArray<String>;
begin
  result:=nil;
  try
    try
      tc := GetTickCount ;
      bFound :=false;
      for i:=0 to FDManager.ConnectionDefs.Count-1 do
        begin
          If FDManager.ConnectionDefs[i].Name=aRef
            then
              begin
                bFound:=true;
                Break;
              end;
        end;
      if Not(bFound) then
        begin
            Splitted := aRef.Split(['@']);
            CreateInFDManager(Splitted[0],Splitted[1]);
        end;

      Result := TFDConnection.Create(nil);
      Result.ConnectionDefName := aRef;
      tc := getTickCount - tc ;
     finally
      //
    end;
  except
    on E:Exception do
    begin
      if Assigned(result) then
      begin
        result.DisposeOf ;
        result := nil ;
      end;

      raise ;
    end;
  end;
end;


function TDataMod.NbTriggersGINKOIA_Actifs(const ABaseDonnees: TFileName):integer;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := 0;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT COUNT(*) FROM RDB$TRIGGERS                  ');
    vQuery.SQL.Add('WHERE RDB$SYSTEM_FLAG=0 AND RDB$TRIGGER_INACTIVE=0 ');
    vQuery.SQL.Add('AND RDB$TRIGGER_NAME NOT LIKE ''CHECK%''           ');
    vQuery.SQL.Add('AND RDB$RELATION_NAME NOT LIKE ''SYM%''            ');
    vQuery.open;
    while not(vQuery.eof) do
      begin
          result := vQuery.Fields[0].Asinteger;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

function TDataMod.NbTriggersSymDS(const ABaseDonnees: TFileName):integer;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  Result := 0;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT COUNT(*) FROM RDB$TRIGGERS            ');
    vQuery.SQL.Add('WHERE RDB$SYSTEM_FLAG=0                      ');
    vQuery.SQL.Add('    AND RDB$RELATION_NAME NOT LIKE ''SYM_%'' ');
    vQuery.SQL.Add('    AND RDB$TRIGGER_NAME LIKE ''SYM_%''      ');
    vQuery.open;
    while not(vQuery.eof) do
      begin
          result := vQuery.Fields[0].Asinteger;
          vQuery.Next;
      END;
    vQuery.Close();
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf();
  end;
end;

function TDataMod.NbTableTriggersSymDS(const ABaseDonnees: TFileName):integer;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    vSens  : string;
begin
  Result := 0;
  if (ABaseDonnees='') then exit;
  vCnx   := getNewConnexion('SYSDBA@'+ABaseDonnees);
  vQuery := getNewQuery(vCnx,nil);
  try
    try
      // Avant c'etait ca.... mais maintenant ca se complexifie
      // vQuery.Close();
      // vQuery.SQL.Clear;
      // vQuery.SQL.Add('SELECT SUM(SYNC_ON_UPDATE+SYNC_ON_INSERT+SYNC_ON_DELETE) FROM SYM_TRIGGER A ');
      // vQuery.SQL.Add('   JOIN SYM_TRIGGER_ROUTER B ON B.TRIGGER_ID=A.TRIGGER_ID AND ROUTER_ID=''lame_vers_mags'' ');

      // j'ai essayé ca.... mais je ne suis pas content .... il y a toujours le meme nombre que le nombre de trigger donc pas satisiferant
      // vQuery.SQL.Clear;
      // vQuery.SQL.Add('SELECT COUNT(NAME_FOR_INSERT_TRIGGER)+COUNT(NAME_FOR_UPDATE_TRIGGER)+COUNT(NAME_FOR_DELETE_TRIGGER) FROM SYM_TRIGGER_HIST ');
      // vQuery.SQL.Add(' WHERE UPPER(SOURCE_TABLE_NAME) NOT LIKE ''SYM_%'' AND INACTIVE_TIME IS NULL ');



      // Je suis quel type de noeud ?
      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT router_id FROM SYM_NODE N ');
      vQuery.SQL.Add(' JOIN SYM_NODE_IDENTITY I ON I.NODE_ID=N.NODE_ID ');
      vQuery.SQL.Add(' JOIN SYM_ROUTER R ON R.source_node_group_id=N.node_group_id ');
      vQuery.open;
      vSens := 'portables_vers_lame'; // il peut y avoir plusieurs enregsitrements (surtout sur la lame)
      If (vQuery.RecordCount=1)
        then
          begin
            vSens := vQuery.FieldByName('router_id').AsString;
          end;

      vQuery.Close();
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT SUM(SYNC_ON_UPDATE+SYNC_ON_INSERT+SYNC_ON_DELETE) FROM SYM_TRIGGER A ');
      vQuery.SQL.Add('   JOIN SYM_TRIGGER_ROUTER B ON B.TRIGGER_ID=A.TRIGGER_ID AND ROUTER_ID=:ROUTERID');
      vQuery.ParamByName('ROUTERID').AsString := vSens;
      vQuery.open;
      while not(vQuery.eof) do
        begin
            result := vQuery.Fields[0].Asinteger;
            vQuery.Next;
        END;
    vQuery.Close();
    Except
      // si la table n'existe pas encore... ca plante... faudrait
    end;
  finally
    vQuery.DisposeOf();
    vCnx.DisposeOf();
  end;
end;



end.

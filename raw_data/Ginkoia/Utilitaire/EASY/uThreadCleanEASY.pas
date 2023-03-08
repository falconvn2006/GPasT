unit uThreadCleanEASY;

interface

uses
  Winapi.Windows,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Classes,
  System.RegularExpressionsCore,
  System.Win.Registry,
  System.StrUtils,
  System.IOUtils,
  System.Variants,
  Data.DB,
  ActiveX,
  VCL.Forms,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.Phys.IBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.IBBase,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util,
  FireDAC.Comp.Script,
  FireDAC.Phys.IBWrapper,
  ServiceControler,
  System.IniFiles,
  System.Math,
  uSevenZip;
//  uPostXE,
//  uLog,
//  uKillApp,
// WMI;

const CST_HOST          = 'localhost'; // '127.0.0.1';
      CST_PORT          = 3050;
      CST_BASE_USER     = 'SYSDBA';
      CST_BASE_PASSWORD = 'masterkey';

type
  TStatusMessageCall = Procedure (const info:String) of object;
  TProgressMessageCall = Procedure (const info:integer) of object;
  //----------------------------------------------------------------------------
  TThreadCleanEASY = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FProgressProc  : TProgressMessageCall;
    FPosition        : integer;
    FStatus          : string;
    FDatabase        : string;

    FNBError        : integer;
    FErrorMessage   : string;
    procedure StatusCallBack();
    procedure ProgressCallBack();
    procedure DoPause(asec:Integer);
    procedure DROP_SYMDS(const ABaseDonnees: TFileName);
  protected
    procedure Execute; override;
  public
    constructor Create(
          aDatabase       : string;
          aStatusCallBack : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          aEvent:TNotifyEvent=nil); reintroduce;
    destructor Destroy();
   property NBError      : integer     read FNBError;
   property ErrorMessage : string      read FErrorMessage;
  end;

  TThreadRecuPBase = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FProgressProc  : TProgressMessageCall;
    FPosition        : integer;
    FStatus          : string;
    FDatabase        : string;
    FIDENT           : string;  // 1 , 2, etc...
    FNBError        : integer;
    FErrorMessage   : string;
    procedure StatusCallBack();
    procedure ProgressCallBack();
    procedure MAJ_IDENT();
    // procedure DoPause(asec:Integer);
    function Etape_RecupID(var aFile:TFileName):Integer;
    function TraiteGenerateur(Query : TFDQuery; aIdentBase:Integer; aPlage:string;GenName : string; ini : TInifile) : integer;
  protected
    procedure Execute; override;
  public
    constructor Create(
          aDatabase       : string;
          aIDENT          : string;
          aStatusCallBack : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          aEvent:TNotifyEvent=nil); reintroduce;
    destructor Destroy();
    property NBError      : integer     read FNBError;
    property ErrorMessage : string      read FErrorMessage;
  end;



implementation

uses uDataMod,UCommun;

{$REGION 'TThreadCleanEASY'}

constructor TThreadCleanEASY.Create(
          aDatabase       : string;
          aStatusCallBack    : TStatusMessageCall;
          aProgressCallBack  : TProgressMessageCall;
          aEvent:TNotifyEvent=nil);
begin
    inherited Create(true);
    OnTerminate       := AEvent;
    FreeOnTerminate   := True;
    FNBError          := 0;
    FErrorMessage     := '';
    FStatusProc       := aStatusCallBack;
    FProgressProc     := aProgressCallBack;
    FDatabase         := aDataBase;
end;

destructor TThreadCleanEASY.Destroy();
begin
  Inherited;
end;

procedure TThreadCleanEASY.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TThreadCleanEASY.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FPosition);
end;

procedure TThreadCleanEASY.DoPause(asec:Integer);
var i:Integer;
begin
    if asec=1
      then FStatus := Format('Pause de %d seconde',[aSec])
      else FStatus := Format('Pause de %d secondes',[aSec]);
    Synchronize(StatusCallBack);
end;

procedure TThreadCleanEASY.DROP_SYMDS(const ABaseDonnees: TFileName);
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

    vScriptFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'drop_symds2.sql';
    if FileExists(vScriptFile)
      then System.SysUtils.DeleteFile(vScriptFile);

    ResInstallateur := TResourceStream.Create(HInstance, 'drop_symds2', RT_RCDATA);
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
                      // FPositionDetails:=0;
                      // Synchronize(ProgressDetailsCallBack);
                      for i:= 0 to Count-1 do
                        begin
                            // if Count<>0
                            //  then FPositionDetails:= Round(100*i/Count)
                            //   else FPositionDetails:= 0;
                            // Synchronize(ProgressDetailsCallBack);
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
                                                    FStatus:='A :'+Ez.Message;
                                                    Synchronize(StatusCallBack);
//                                                    exit;
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
                   FStatus:='X :'+Ez.Message;
                   Synchronize(StatusCallBack);
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
   DoPause(10);
   // -----------
   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
      try
       vScript:=TFDScript.Create(nil);
       vScript.Connection:=vCnx;
       vScript.SQLScripts.Clear;
       vScript.SQLScripts.Add;
       vScript.SQLScripts[0].SQL.Add('DROP TABLE SYM_DATA;');
       vScript.ValidateAll;
       vScript.ExecuteAll;
     Except On Ez:Exception do
       begin
         FStatus:='Y :'+Ez.Message;
         Synchronize(StatusCallBack);
       end;
     end;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;

   DoPause(5);
   vCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
   try
     try
       vScript:=TFDScript.Create(nil);
       vScript.Connection:=vCnx;
       vScript.SQLScripts.Clear;
       vScript.SQLScripts.Add;
       vScript.SQLScripts[0].SQL.Add('DROP TABLE SYM_CONTEXT;');
       vScript.ValidateAll;
       vScript.ExecuteAll;
     Except On Ez:Exception do
       begin
         FStatus:='Z :'+Ez.Message;
         Synchronize(StatusCallBack);
       end;
     end;
    finally
       vScript.Free;
       vCnx.DisposeOf;
       // Libération du POOL
       DataMod.FreeInfFDManager('SYSDBA@'+ABaseDonnees);
   end;

end;


procedure TThreadCleanEASY.Execute;
var vQuery  : TFDQuery;
    vNow : Cardinal;
    i :integer;
    vTableTrg , vTrg : integer;
    vAttente : integer;
begin
    try
      try
         FPosition := 0;
         Synchronize(ProgressCallBack);

         DROP_SYMDS(FDataBase);

         FPosition := 100;
         Synchronize(ProgressCallBack);

         FStatus:= 'Fin : Succès';
         Synchronize(StatusCallBack);

      Except
        On E:Exception do
          begin
            FErrorMessage := E.Message;
            FSTATUS       := E.Message;
            Synchronize(StatusCallBack);
          end;
      end;

    finally
      //
    end;
end;

{$ENDREGION 'TThreadCleanEASY'}

{$REGION 'TThreadRecupBase'}

constructor TThreadRecupBase.Create(
          aDatabase       : string;
          aIDENT          : string;
          aStatusCallBack    : TStatusMessageCall;
          aProgressCallBack  : TProgressMessageCall;
          aEvent:TNotifyEvent=nil);
begin
    inherited Create(true);
    OnTerminate       := AEvent;
    FreeOnTerminate   := True;
    FNBError          := 0;
    FErrorMessage     := '';
    FIDENT            := aIDENT;
    FStatusProc       := aStatusCallBack;
    FProgressProc     := aProgressCallBack;
    FDatabase         := aDataBase;
end;

destructor TThreadRecupBase.Destroy();
begin
  Inherited;
end;


procedure TThreadRecupBase.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TThreadRecupBase.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FPosition);
end;


function TThreadRecupBase.Etape_RecupID(var aFile:TFileName):Integer;
// code de retour :
// 0 - reussite
// 1 - Erreur de Téléchargement du fichier
// 2 - IDGENERATEUR non trouver
// 3 - Plages non trouver
// 4 - Exception
// 5 - Autre erreur
var
  DestPath : string;
  ini      : TIniFile;
  vCnx     : TFDConnection;
  vPlageMagasin : string;
//  Transaction : TFDTransaction;
  vIdentBase : Integer;
  QueryLst, QueryAsk, QueryMaj : TFDQuery;
  Res : integer;
begin
  result := 5;
  FStatus:='Récupération des ID : ...';
  Synchronize(StatusCallBack);

//  if Assigned(FProgress) then
//    Synchronize(ProgressMarquee);

  try
    try
      DestPath := GetTmpDir(); // GetTempDirectory();
      ForceDirectories(DestPath);
      // recup du fichier de definition !
      if DownloadHTTP('http://lame2.no-ip.com/maj/GINKOIA/recupbase.ini', IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini') then
      begin
        try
          Ini := TIniFile.Create(IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini');
          // recalcup des geénérateur
          try
            vCnx        := DataMod.getNewConnexion('SYSDBA@' + aFile);
            try
              vCnx.Open();
              try
                QueryLst := DataMod.GetNewQuery(vCnx, nil);
                QueryAsk := DataMod.GetNewQuery(vCnx, nil);
                QueryMaj := DataMod.GetNewQuery(vCnx, nil);
                  try
                    // recupération du numero de base
                    QueryLst.SQL.Text := 'select cast(par_string as integer) as nummagasin from genparambase where par_nom = ''IDGENERATEUR'';';
                    try
                      QueryLst.Open();
                      if QueryLst.Eof then
                      begin
                        result := 2;
                        Exit;
                      end
                      else
                        vIdentBase := QueryLst.FieldByName('nummagasin').AsInteger;
                    finally
                      QueryLst.Close();
                    end;

                    // FLogs.Add('  -> ' + IntToStr(FIdentBase));
                    // FLogs.Add('Récupération des plages');

                    // recupération des plages
                    QueryLst.SQL.Text := 'select cast(bas_ident as integer) as nummagasin, bas_plage from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ''' + IntToStr(vIdentBase) + ''';';
                    try
                      QueryLst.Open();
                      if QueryLst.Eof then
                      begin
                        result := 3;
                        Exit;
                      end
                      else
                        vPlageMagasin := QueryLst.FieldByName('bas_plage').AsString;
                    finally
                      QueryLst.Close();
                    end;

                    // FLogs.Add('  -> ' + FPlageMagasin);
                    // FLogs.Add('Listing des générateurs');

                    // selection des génénrateur
                    QueryLst.SQL.Text := 'select rdb$generator_name as name from rdb$generators where rdb$system_flag is null or rdb$system_flag = 0';
                    try
                      QueryLst.Open();
                      QueryLst.FetchAll();

                      // init progress bar !
                      {
                      FMaxProgress := QueryLst.RecordCount;
                      if Assigned(FProgress) then
                        Synchronize(InitProgress);
                      }

                      while not QueryLst.Eof do
                      begin
                        // FStepProgress := 'Traitement du générateur "' + QueryLst.FieldByName('name').AsString + '"...';
                        //if Assigned(FProgress) then
                        //  Synchronize(ProgressStepLbl);
                        FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString;
                        Synchronize(StatusCallBack);
                        Res := TraiteGenerateur(QueryAsk, vIdentBase, vPlageMagasin, QueryLst.FieldByName('name').AsString, ini);
                        Case Res of
                           -2 : FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString + ' : Non pris en charge';
                           -1 : FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString + ' : Ne pas changer';
                          else
                            begin
                              FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString + ' : ' + Inttostr(Res);
                              QueryMaj.SQL.Text := 'SET GENERATOR ' + QueryLst.FieldByName('name').AsString + ' to ' + Inttostr(res) + ';';
                              QueryMaj.ExecSQL();
                            end;
                        end;
                        if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                        QueryLst.Next();
      //                ProgressStepIt();
                      end;

                      // Avant EASY
                      //  ==> FTriggerDiff = 1 sur la lame
                      //  ==> FTriggerDiff = 0 en magasin
                      (*
                      If FTriggerDiff   // Si triggerDiff alors triggers pas actifs signifie GENTIGGERS = 1
                        then
                          begin
                            QueryMaj.Close();
                            QueryMaj.SQL.Text := 'SET GENERATOR GENTRIGGER TO 1;';  // la ca posera dans GENTRIGGERDIFF
                            QueryMaj.ExecSQL();
                          end
                      else
                         begin
                           QueryMaj.Close();
                           QueryMaj.SQL.Text := 'SET GENERATOR GENTRIGGER TO 0;';   // le calcul de stock est immédiat
                           QueryMaj.ExecSQL();
                         end;
                      *)
                    finally
                      QueryLst.Close();
                    end;

                    // Transaction.Commit();
                    result := 0;
                  except
                    // Transaction.Rollback();
                    raise;
                  end;
              finally
                FreeAndNil(QueryLst);
                FreeAndNil(QueryAsk);
                FreeAndNil(QueryMaj);
              end;
            finally
              vCnx.DisposeOf;
            end;
          finally
            //
          end;
        finally
          FreeAndNil(ini);
        end;
      end
      else
        result := 1;
    finally
      // suppression du repertoire !
      // DelTree(DestPath);
    end;
  except
    on e : Exception do
    begin
      result := 4;
    end;
  end;
end;

procedure TThreadRecupBase.MAJ_IDENT();
var vIdent:string;
    vCnx : TFDConnection;
    vQuery : TFDQuery;
begin
     vCnx   := DataMod.getNewConnexion('SYSDBA@' + FDataBase);
     vQuery := DataMod.GetNewQuery(vCnx, nil);
     try
        try
          vIdent := FIDENT;
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add(Format('UPDATE GENPARAMBASE SET PAR_STRING=''%s'' WHERE PAR_NOM=''IDGENERATEUR''',[vIdent]));
          vQuery.ExecSQL;
          vQuery.Close;
        except

        end;
     finally
        vQuery.DisposeOf;
        vCnx.DisposeOf;
     end;
end;


procedure TThreadRecupBase.Execute;
var i:integer;
    vDatabase : TFileName;
begin
    try
      vDatabase := FDatabase;
      i := Etape_RecupID(vDatabase);
    except
      On E:Exception do
        begin
           Inc(FNBError);
           FErrorMessage := E.Message;
        end;
    end;
end;

function TThreadRecupBase.TraiteGenerateur(Query : TFDQuery; aIdentBase:Integer; aPlage:string;GenName : string; ini : TInifile) : integer;
var
  i, j : Integer;
  Deb, Fin : Integer;
  Methode, Minimum, nbTables : Integer;
  Table, Champ, Cond, Tmp : string;
  Sufixes : TStringList;
  DoWithout : Boolean;
begin
  Methode := ini.readinteger(GenName, 'Def', 0);
  Minimum := ini.readinteger(GenName, 'Min', -9999);
  nbTables := ini.readinteger(GenName, 'NbTable', 0);
  Result := System.Math.Max(minimum, 0);

  case Methode of
    1: // DEF=1 -> Valeur dans la plage
      begin
        decodeplage(aPlage, Deb, Fin);
        Result := System.Math.Max(Deb * 1000000, Result);
        for i := 1 to nbTables do
        begin
          GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
          RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table + ' where ' + Champ + ' between ' + Inttostr(Deb)
                              + '*1000000 and ' + Inttostr(Fin) + '*1000000;', Cond, Result);
        end;
      end;
    2: // DEF=2 -> NumMagasin + '-' + Valeur [+ '*R'] [+ '*F']
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'Select Max( Cast(f_mid (' + champ + ',' + inttoStr(Length(Inttostr(aIdentBase)) + 1)
                            + ',f_bigstringlength(' + champ + ')-' + inttoStr(Length(Inttostr(aIdentBase)) + 3)
                            + ' ) as integer))'
                            + ' from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%'''
                            + ' and ' + Champ + ' like ''%R'' ', Cond, Result);
        RecupMaxValeur(Query, 'select Max( Cast(f_mid (' + Champ + ',' + InttoStr(Length(Inttostr(aIdentBase)) + 1) + ',12) as integer)) '
                            + 'from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%'' '
                            + 'and not (' + Champ + ' like ''%R'') and not (' + Champ + ' like ''%F'') ', Cond, Result);
      end;
    3: // DEF=3 -> Valeur
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table, Cond, Result);
      end;
    4: // DEF=4 -> Code Barre ('2' + NumMag sur 3 chiffre + generateur + chiffre de control)
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);

        try
          Tmp := Format('%.3d', [aIdentBase]);
          query.SQL.Text := 'Select Max(' + Champ + ') from ' + Table + ' Where (' + Champ + ' like ''2' + Tmp + '%'') ';
          if Cond <> '' then
            query.sql.Add('AND ' + Cond);
          query.Open();
          if not (query.fields[0].IsNull) then
          begin
            Tmp := query.fields[0].AsString;
            Delete(Tmp, 1, 4);
            Delete(Tmp, length(Tmp), 1);
            Result := System.Math.Max(Result, StrToIntDef(Tmp, Result));
          end;
          query.Close();
        except
        end;
      end;
    5: // DEF=5 -> NumMagasin + '-' + 'M' + Valeur // Modèle de facture
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'select Max(Cast(f_mid (' + Champ + ',' + InttoStr(Length(Inttostr(aIdentBase)) + 2) + ',12) as integer)) '
                            + 'from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%''', Cond, Result);
      end;
    6: // DEF=6 -> mettre a 0
      Result := 0;
    7: // DEF=7 -> Pas touche !!
      Result := -1;
    8: // DEF=8 -> NumMagasin + '-' + Valeur + '*F' // Facture de retro
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, ' Select Max( Cast(f_mid (' + Champ + ',' + inttoStr(Length(Inttostr(aIdentBase)) + 1)
                            + ',f_bigstringlength(' + Champ + ')-' + inttoStr(Length(Inttostr(aIdentBase)) + 3)
                            + ') as integer))'
                            + ' from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%'''
                            + ' and ' + Champ + ' like ''%F'' ', Cond, Result);
      end;
    9: // DEF=9 -> BP du web : site sur 4 caractères + '-' + NumMag + '-' + sequence
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'select max(cast(substr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 7) + ', f_bigstringlength(' + Champ + ')) as integer)) '
                            + 'from ' + table + ' '
                            + 'where ' + Champ + ' like ''____-' + Inttostr(aIdentBase) + '-%'' ', Cond, Result);
      end;
    10: // DEF=10 -> Interclub : NumMagasin + '-' + Valeur + Terminaisons en paramètres
      begin
        try
          Sufixes := TStringList.Create();
          Sufixes.Delimiter := ';';
          Sufixes.DelimitedText := ini.ReadString(GenName, 'Sufixes', '');
          DoWithout := ini.ReadBool(GenName, 'DoWithout', true);

          for i := 1 to nbTables do
          begin
            GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);

            Tmp := 'select Max(Cast(' + #10#13;
            for j := 0 to Sufixes.Count - 1 do
              if j = 0 then
                Tmp := Tmp + '  case when ' + Champ + ' like ''%' + Sufixes[j] + ''' then SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 2)
                  + ', f_bigstringlength(' + Champ + ') - ' + IntToStr(Length(Sufixes[j])) + ')' + #10#13
              else
                Tmp := Tmp + '       when ' + Champ + ' like ''%' + Sufixes[j] + ''' then SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 2)
                  + ', f_bigstringlength(' + Champ + ') - ' + IntToStr(Length(Sufixes[j])) + ')' + #10#13;
            if DoWithout then
              Tmp := Tmp + '       else SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 2) + ', f_bigstringlength(' + Champ + '))' + #10#13;
            Tmp := Tmp + '  end as integer))' + #10#13
                       + 'from ' + table + #10#13;
            if DoWithout then
              Tmp := Tmp + 'where ' + Champ + ' like ''' + Inttostr(aIdentBase) + '-%'''
            else
            begin
              for j := 0 to Sufixes.Count - 1 do
                if j = 0 then
                  Tmp := Tmp + 'where (' + Champ + ' like ''' + Inttostr(aIdentBase) + '-%' + Sufixes[j] + '''' + #10#13
                else
                  Tmp := Tmp + '       or ' + Champ + ' like ''' + Inttostr(aIdentBase) + '-%' + Sufixes[j] + '''' + #10#13;
              Tmp := Tmp + '  )';
            end;

            RecupMaxValeur(Query, Tmp, Cond, Result);
          end;
        finally
          FreeAndNil(Sufixes);
        end;
      end;
    11: // DEF = 11 -> Acompte Web
      begin
        for i := 1 to nbTables do
        begin
          GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
          RecupMaxValeur(Query, 'select max(cast(f_mid(' + Champ + ' ,10,7) as integer)) from ' + Table + ' where %0:s starting with ' + QuotedStr('AC :') + ';', Cond, Result);
        end;
      end;
    else
      Result := -2;
  end;
end;



{$ENDREGION 'TThreadRecupBase'}


end.

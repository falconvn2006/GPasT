unit uThreadSynchro;

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
//   uSynchroTypes,
  System.Math,
  uSevenZip,
  uPostXE,
  uLog,
  uKillApp,
  UWMI;

const CST_HOST          = 'localhost'; // '127.0.0.1';
      CST_PORT          = 3050;
      CST_BASE_USER     = 'SYSDBA';
      CST_BASE_PASSWORD = 'masterkey';
      CLASTSYNC  = 3000;
      CSYNCHROOK = 3001;

      CST_ERR_ZIP        = 'La version du serveur n''est pas conforme, la synchronisation n''est pas possible actuellement. Si ce problème persiste, contactez votre support utilisateur.';
      CST_ERR_SERV_BASE  = 'La base du serveur n''est pas conforme, la synchronisation n''est pas possible actuellement. Si ce problème persiste, contactez votre support utilisateur.';

type
  TStatusMessageCall = Procedure (const info:String) of object;
  TProgressMessageCall = Procedure (const info:integer) of object;
  //----------------------------------------------------------------------------
  TThreadSynchro = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FProgressProc  : TProgressMessageCall;
    FProgressDetailsProc : TProgressMessageCall;
    FPosition      : integer;
    FPositionDetails : integer;

    FAutoStart     : Boolean;
    FDebug         : Boolean;
    FStatus        : string;
    FGINKOIA_IB    : TFileName;
    FMODE          : string;
    FServeurGINKCOPY  : TFileName;
    FGINKOIA_SAV    : TFileName;  // GINKOIA.IB
    FNBError        : integer;
    FDATADir        : string;
    FGENERATEUR_EXE : string;
    FSAV            : TFileName;
    FGENID          : int64;
    FSYMSscript     : TStringList;
    FVERSION        : TFileName;
    FAMAJDIR        : string;
    FAMAJVERSION    : TFileName;
    FFormatSQL      : TFormatSettings;
    FVersionBASE    : string;
    FGinkoiaPath    : string;
    FErrorMessage   : string;

    FBAS_ID          : integer;
    FBAS_GUID        : string;
    FRollBackOK      : integer;
    FEASYINFOS       : TEasyINFos;

    procedure StatusCallBack();
    procedure ProgressCallBack();
    procedure ProgressDetailsCallBack();

    function CopierFichier(SrcFile, NewFile: string): boolean;

    function ParseField(const aField: TField):string;
    procedure DUMP_TABLE_INFILE(aCnx:TFDConnection;aQuery:TFDQuery;aTABLENAME:string);
    procedure DUMP_QUERY_INFILE(aCnx:TFDConnection;aQuery:TFDQuery;aTableName:string;aSQL:string);
    // Etapes majeures
    procedure Etape_RE_INSERT_MY_IDENTITY();
    procedure Etape_Get_BASID();
    procedure Etape_Copie_From_Serveur();
    procedure Etape_Clean_EASY_TmpDir();
    procedure Etape_ShutDown();
    procedure Etape_Restart();
    procedure Etape_Get_TABLE_GENPARAM();
    procedure Etape_Set_TABLE_GENPARAM();
    procedure Etape_Get_TABLE_GENGENERATEUR();
    procedure Etape_Set_TABLE_GENGENERATEUR();
    procedure Etape_Copie_Sauvegarde;
    procedure Etape_Recup_SYMDS();
    procedure Etape_GetGenerateurs;
    procedure Etape_SetGenerateurs;
    procedure Etape_Controles;
    procedure Etape_Copy_VersionZip;
    procedure Etape_ALG();
    procedure RelancerLauncherEasy;
    function ExtractVersionArchive():boolean;
    procedure Ressource7z();
    function LancerVerification(sParam: string = 'AUTO'; bWaitFor: boolean = false): boolean;
    function doRestartApp: boolean;
    function setHistoEvent(aType: Integer; aDate: TDateTime; aResult: boolean; aTime: TTime; aBasId: Int64): boolean;
    function BoolToInt( aValue : Boolean) : Integer;
    procedure UpdateYellis;
    procedure Etape_StopEASY();
    procedure ForceKillJavaEASY();
    function TerminateProcessByID(ProcessID: Cardinal): Boolean;
    procedure DROP_SYMDS(const ABaseDonnees: TFileName);
    procedure DoPause(asec:Integer);
    procedure RollBack_Sauvegarde();
    procedure Etape_Group_Portables();

  protected
    procedure Execute; override;
  public
    constructor Create(aServerGINKCOPY:string;aGINKOIA: String;aGENID: int64;
        aAutoStart      : Boolean;
        aDebug          : Boolean;
        aStatusCallBack : TStatusMessageCall;
        aProgressCallBack : TProgressMessageCall;
        aProgressDetailsCallBack : TProgressMessageCall;
        aEvent:TNotifyEvent=nil); reintroduce;
    destructor Destroy();
  property NBError      : integer     read FNBError;
  property ErrorMessage : string      read FErrorMessage;
  property RollBackOK   : integer     read FRollBackOK;    // -1 rien
                                                           // 0 pas bon Rollback Echec
                                                           // 1 RollBack OK      
  end;

implementation

uses uDataMod, uProcess;

constructor TThreadSynchro.Create(aServerGINKCOPY:string;aGINKOIA: String;aGENID: int64;
          aAutoStart         : Boolean;
          aDebug          : Boolean;
          aStatusCallBack    : TStatusMessageCall;
          aProgressCallBack  : TProgressMessageCall;
          aProgressDetailsCallBack : TProgressMessageCall;
          aEvent:TNotifyEvent=nil);
begin
    inherited Create(true);
    OnTerminate      := AEvent;
    FreeOnTerminate  := True;
    FNBError         := 0;
    FErrorMessage    := '';
    FGENID           := aGENID;
    FAutoStart       := aAutoStart;
    FDebug           := aDebug;
    FStatusProc      := aStatusCallBack;
    FProgressProc    := aProgressCallBack;
    FProgressDetailsProc := aProgressDetailsCallBack;

    FEASYINFOS        := WMI_GetServicesEASY;

    FServeurGINKCOPY := aServerGINKCOPY;
    FGINKOIA_IB      := aGINKOIA;
    FDATADir         := ExtractFilePath(FGINKOIA_IB);
    FSAV             := IncludeTrailingPathDelimiter(FDATADir)+ 'Backup\SYNCHRO.OLD';
    FGENERATEUR_EXE  := FDATADir + 'generateur.exe';
    FFormatSQL       := TFormatSettings.Create(1033);
    FSYMSscript      := TStringList.Create;

    FRollBackOK      := -1;
    FBAS_ID          := 0;
    FBAS_GUID        := '';
    //------------------------------------------
    FGinkoiaPath     := IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FDATADir))));

    FVersionBASE     := '';
    FVERSION         := IncludeTrailingPathDelimiter(ExtractFilePath(aServerGINKCOPY))+ 'VERSION.ZIP';
    //
    FAMAJDIR         := IncludeTrailingPathDelimiter(FGinkoiaPath+'A_MAJ');
    FAMAJVERSION     := FAMAJDIR + 'VERSION.ZIP';
end;

destructor TThreadSynchro.Destroy();
begin
  FSYMSscript.DisposeOf;
  Inherited;
end;





procedure TThreadSynchro.Ressource7z();
var  ResInstallateur : TResourceStream;
     v7z_dll : string;
begin
    v7z_dll := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ '7z.dll';
    if FileExists(v7z_dll)
      then exit;
    ResInstallateur := TResourceStream.Create(HInstance, '7z_dll', RT_RCDATA);
    try
       ResInstallateur.SaveToFile(v7z_dll);
      finally
       ResInstallateur.Free();
    end;
end;

procedure TThreadSynchro.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TThreadSynchro.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FPosition);
end;


procedure TThreadSynchro.ProgressDetailsCallBack();
begin
   if Assigned(FProgressDetailsProc) then  FProgressDetailsProc(FPositionDetails);
end;


function TThreadSynchro.ParseField(const aField: TField):string;
begin
    if not(aField.IsNull) then
    begin
      case aField.DataType of
        // Chaîne
        ftString, ftFixedChar, ftWideString, ftFixedWideChar:
          result := AnsiQuotedStr(aField.AsString, '''');
        // Entier
        ftSmallint, ftInteger, ftLargeInt, ftWord, ftBytes, ftAutoInc, ftLongWord, ftShortint, ftByte:
          result := aField.AsString;
        // Réel
        ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended, ftSingle:
          result := FloatToStr(aField.AsFloat,FFormatSQL);
        // Date
        ftDate:
          result := AnsiQuotedStr(FormatDateTime('yyyy-mm-dd', aField.AsDateTime), '''');
        // Heure
        ftTime:
          result := AnsiQuotedStr(FormatDateTime('hh:nn:ss', aField.AsDateTime), '''');
        // Date et heure
        ftDateTime, ftTimeStamp, ftOraTimeStamp, ftTimeStampOffset:
          result := AnsiQuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', aField.AsDateTime), '''');
        // Inconnu
        ftUnknown:
          result := aField.AsString;
        // Autre
        else
          result := AnsiQuotedStr(aField.AsString, '''');
      end;
    end
    else
    begin
      result := 'NULL';
    end;
end;


procedure TThreadSynchro.Etape_RE_INSERT_MY_IDENTITY();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
//    vFields  : string;
//    vVirgule : string;
//    vValues  : string;
    vScript : TStringList;
    i:integer;
    vFile:string;    
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);  // car elle est shutdown
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript := TStringList.Create;
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
                vFile := FDATADir + 'SYMDS_IDENTITY.sql';
                if not(LocaleFileExists(vFile))
                   then raise Exception.Create('Fichier SYMDS_IDENTITY.sql introuvable !');
                vScript.LoadFromFile(vFile);
                for I:=0 to vScript.Count-1 do
                  begin
                      vQuery.Close;
                      vQuery.SQL.Clear;
                      vQuery.SQL.Add(vScript.Strings[i]);
                      vQuery.ExecSQL;
                  end;
                vQuery.Close;
               //  DeleteFile(vFile);
            end;
         FStatus:='Remplissage de SYM_IDENTITY : [OK]';
         Synchronize(StatusCallBack);
         // Test on laisse...
      Except On Ez : Exception do
          begin
            inc(FnbError);
            raise;
          end;
      end;
    finally
      vScript.DisposeOf;
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TThreadSynchro.DUMP_QUERY_INFILE(aCnx:TFDConnection;aQuery:TFDQuery;aTableName:string;aSQL:string);
var vFields  : string;
    vVirgule : string;
    vValues  : string;
    i:integer;
begin
     If aCnx.Connected then
        begin
           aQuery.Close;
           aQuery.SQL.Clear;
           aQuery.SQL.Add(aSQL);
           aQuery.Open();
           while not(aQuery.eof) do
              begin
                vVirgule := '';
                vFields := 'INSERT INTO '+ aTABLENAME +' (';
                vValues := ') VALUES (';
                for I := 0 to aQuery.FieldCount-1 do
                  begin
                    vFields := vFields + vVirgule + aQuery.Fields[i].FieldName;
                    vValues := vValues + vVirgule + ParseField(aQuery.Fields[i]);
                    vVirgule := ',';
                  end;
                FSYMSscript.Add(vFields + vValues + ');');
                aQuery.Next;
              end;
        end;
end;

procedure TThreadSynchro.DUMP_TABLE_INFILE(aCnx:TFDConnection;aQuery:TFDQuery;aTABLENAME:string);
var vFields  : string;
    vVirgule : string;
    vValues  : string;
    i:integer;
begin
     If aCnx.Connected then
        begin
           aQuery.Close;
           aQuery.SQL.Clear;
           aQuery.SQL.Add('SELECT * FROM '+ aTABLENAME);
           aQuery.Open();
           while not(aQuery.eof) do
              begin
                vVirgule := '';
                vFields := 'INSERT INTO '+ aTABLENAME +' (';
                vValues := ') VALUES (';
                for I := 0 to aQuery.FieldCount-1 do
                  begin
                    vFields := vFields + vVirgule + aQuery.Fields[i].FieldName;
                    vValues := vValues + vVirgule + ParseField(aQuery.Fields[i]);
                    vVirgule := ',';
                  end;
                FSYMSscript.Add(vFields + vValues + ');');
                aQuery.Next;
              end;
        end;
end;

function TThreadSynchro.CopierFichier(SrcFile, NewFile: string): boolean;
const
  bufSize = 262144;
var
  StreamSrc: TFileStream;
  StreamDst: TFileStream;
  pBuf: Pointer;
  Cnt: integer;
  TotCopie: Int64;
  Taille: Int64;
  vVal : Integer;
begin
  Result := false;

  StreamSrc := nil;
  StreamDst := nil;
  TotCopie := 0;

  FPositionDetails := 0;
  Synchronize(ProgressDetailsCallBack);

  try
    try

      // ouvre le fichier Source
      StreamSrc := TFileStream.Create(SrcFile, fmOpenRead or fmShareDenyWrite);
      Taille := StreamSrc.Size;

      // efface le nouveau fichier s'il existe déjà
      if FileExists(NewFile) then
        DeleteFile(NewFile);

      StreamDst := TFileStream.Create(NewFile, fmCreate or fmShareExclusive);
      GetMem(pBuf, bufSize);
      try
        repeat
          Cnt := StreamSrc.Read(pBuf^, bufSize);
          if Cnt > 0 then
          begin
            Cnt := StreamDst.Write(pBuf^, Cnt);
            TotCopie := TotCopie + Cnt;

            FPositionDetails := Round(TotCopie*100/Taille);
            Synchronize(ProgressDetailsCallBack);
          end;
        until (Cnt = 0);
        Result := true;

      finally
        FreeMem(pBuf, bufSize);
      end;
    finally
      if Assigned(StreamSrc) then
        FreeAndNil(StreamSrc);

      if Assigned(StreamDst) then
        FreeAndNil(StreamDst);

      FPositionDetails := 100;
      Synchronize(ProgressDetailsCallBack);

    end;

  except
    on E: Exception do
    begin
      Raise;
    end;
  end;

end;

procedure TThreadSynchro.Etape_Get_BASID();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vFields  : string;
    vVirgule : string;
    vValues  : string;
    i:integer;
begin
    vCnx   := DataMod.getNewConnexion('GINKOIA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
         vCnx.open;

         FBAS_ID := 0;
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_NOMPOURNOUS, BAS_MAGID, BAS_IDENT FROM GENPARAMBASE        ');
         vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
         vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
         vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
         vQuery.Open();
         If (vQuery.RecordCount = 1) then
          begin
            FBAS_ID := vQuery.FieldByName('BAS_ID').Asinteger;
            FBAS_GUID := vQuery.FieldByName('BAS_GUID').Asstring;
          end;
         vQuery.Close;
         if FBAS_ID=0
            then raise Exception.Create('Erreur de BAS_ID !');
         Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


procedure TThreadSynchro.Etape_Get_TABLE_GENPARAM();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vFields  : string;
    vVirgule : string;
    vValues  : string;
    i:integer;
begin
    vCnx   := DataMod.getNewConnexion('GINKOIA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    FSYMSscript.Clear;
    try
      try
         vCnx.open;
         (*
         FBAS_ID := 0;
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_NOMPOURNOUS, BAS_MAGID, BAS_IDENT FROM GENPARAMBASE        ');
         vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
         vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
         vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
         vQuery.Open();
         If (vQuery.RecordCount = 1) then
          begin
            FBAS_ID := vQuery.FieldByName('BAS_ID').Asinteger;
            FBAS_GUID := vQuery.FieldByName('BAS_GUID').Asstring;
          end;
         *)
         FSYMSscript.Add(Format('DELETE FROM GENPARAM WHERE PRM_POS=%d AND PRM_TYPE=80 AND PRM_CODE IN (5,6,7);',[FBAS_ID]));

         vQuery.Close();
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT K.K_ID FROM GENPARAM JOIN K ON K_ID=PRM_ID WHERE PRM_POS='+intToStr(FBAS_ID)+ ' AND PRM_TYPE=80 AND PRM_CODE IN (5,6,7);');
         vQuery.open();
         while not(vQuery.eof) do
            begin
               FSYMSscript.Add(Format('DELETE FROM K WHERE K_ID=%d;',[vQuery.FieldByName('K_ID').asinteger]));
               vQuery.next;
            end;

         vQuery.Close();
         vQuery.SQL.Clear();
         DUMP_QUERY_INFILE(vCnx,vQuery,'GENPARAM','SELECT GENPARAM.* FROM GENPARAM WHERE PRM_POS='+intToStr(FBAS_ID)+ ' AND PRM_TYPE=80 AND PRM_CODE IN (5,6,7);');

         vQuery.Close();
         vQuery.SQL.Clear();
         DUMP_QUERY_INFILE(vCnx,vQuery,'K','SELECT K.* FROM GENPARAM JOIN K ON K_ID=PRM_ID WHERE PRM_POS='+intToStr(FBAS_ID)+ ' AND PRM_TYPE=80 AND PRM_CODE IN (5,6,7);');

         DeleteFile(FDATADir + 'GENPARAM.sql');

         FSYMSscript.SaveToFile(FDATADir + 'GENPARAM.sql');
         FSYMSscript.Clear;  // Je préfere le vider après l'enregsitrement
         vQuery.Close;
      Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally

      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TThreadSynchro.Etape_Get_TABLE_GENGENERATEUR();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vFields  : string;
    vVirgule : string;
    vValues  : string;
    i:integer;
begin
    vCnx   := DataMod.getNewConnexion('GINKOIA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    FSYMSscript.Clear;
    try
      try
         vCnx.open;


         FBAS_ID := 0;
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT BAS_ID, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_NOMPOURNOUS, BAS_MAGID, BAS_IDENT FROM GENPARAMBASE        ');
         vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
         vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
         vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
         vQuery.Open();
         If (vQuery.RecordCount = 1) then
          begin
            FBAS_ID := vQuery.FieldByName('BAS_ID').Asinteger;
            FBAS_GUID := vQuery.FieldByName('BAS_GUID').Asstring;
          end;

         FSYMSscript.Add(Format('DELETE FROM GENGENERATEUR WHERE GRT_BASID=%d;',[FBAS_ID]));

         vQuery.Close();
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT K.K_ID FROM GENGENERATEUR JOIN K ON K_ID=GRT_ID WHERE GRT_BASID='+intToStr(FBAS_ID));
         vQuery.open();
         while not(vQuery.eof) do
            begin
               FSYMSscript.Add(Format('DELETE FROM K WHERE K_ID=%d;',[vQuery.FieldByName('K_ID').asinteger]));
               vQuery.next;
            end;


         vQuery.Close();
         vQuery.SQL.Clear();
         DUMP_QUERY_INFILE(vCnx,vQuery,'GENGENERATEUR','SELECT GENGENERATEUR.* FROM GENGENERATEUR WHERE GRT_BASID='+intToStr(FBAS_ID));

         vQuery.Close();
         vQuery.SQL.Clear();
         DUMP_QUERY_INFILE(vCnx,vQuery,'K','SELECT K.* FROM GENGENERATEUR JOIN K ON K_ID=GRT_ID WHERE GRT_BASID='+intToStr(FBAS_ID));

         DeleteFile(FDATADir + 'GENGENERATEUR.sql');

         FSYMSscript.SaveToFile(FDATADir + 'GENGENERATEUR.sql');
         FSYMSscript.Clear;  // Je préfere le vider après l'enregsitrement         
         vQuery.Close;
      Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


procedure TThreadSynchro.Etape_Recup_SYMDS();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vPassword : string;
    vNodeID  : string;
    i:integer;
begin
    vCnx   := DataMod.getNewConnexion('GINKOIA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    FSYMSscript.Clear;
    try
      try
         vCnx.open;

         DUMP_TABLE_INFILE(vCnx,vQuery,'SYM_NODE');
         DUMP_TABLE_INFILE(vCnx,vQuery,'SYM_NODE_IDENTITY');
         DUMP_TABLE_INFILE(vCnx,vQuery,'SYM_NODE_SECURITY');
         DUMP_TABLE_INFILE(vCnx,vQuery,'SYM_NODE_HOST');

         (* Techni recup de la lame
         vQuery.SQL.Clear;
         vQuery.SQL.Add('SELECT S.NODE_ID, S.NODE_PASSWORD FROM SYM_NODE_SECURITY S    ');
         vQuery.SQL.Add(' JOIN sym_node_identity I ON I.NODE_ID=S.NODE_ID ');
         vQuery.Open();
         if not(vQuery.IsEmpty) then
            begin
                vPassword := vQuery.FieldByName('NODE_PASSWORD').AsString;
                vNodeID   := vQuery.FieldByName('NODE_ID').AsString;
            end;


         FSYMSscript.Add(
          Format('UPDATE SYM_NODE_SECURITY SET NODE_PASSWORD=''%s'' WHERE NODE_ID=''%s'';',[vPassword,vNodeID]));
         *)

         DeleteFile(FDATADir + 'SYMDS_IDENTITY.sql');
         FSYMSscript.SaveToFile(FDATADir + 'SYMDS_IDENTITY.sql');

         FSYMSscript.Clear;  // Je préfere le vider après l'enregsitrement
         vQuery.Close;
      Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

function TThreadSynchro.ExtractVersionArchive():boolean;
var
  Zip     : I7zInArchive ;
  ia      : integer ;
  vStream : TStringStream ;
  vFound   : boolean;
  vVersion : string;
begin
  vVersion := '';
  Result := False ;
  try
    FSTATUS:= 'Dézippage';
    Synchronize(StatusCallBack);

    if not FileExists(FAMAJVERSION) then
    begin
      raise Exception.Create('Archive non trouvée : '+FAMAJVERSION ) ;
    end;

    Zip := CreateInArchive(CLSID_CFormatZip) ;
    Zip.OpenFile(FAMAJVERSION);

    // Check Version
    for ia := 0 to Zip.NumberOfItems - 1 do
    begin
      if Zip.ItemPath[ia] = 'version.txt' then
      begin
        vFound   := True;
        vStream := TStringStream.Create ;
        Zip.ExtractItem(ia, vStream, false);
        vVersion := Trim(vStream.DataString) ;
        vStream.Free ;
        break ;
      end;
    end;
    if (vVersion='') or not(vFound) then
      begin
        raise Exception.Create('aucune information dde version dans le .zip');
      end;

    if (vVersion <> FVersionBASE) then
    begin
      raise Exception.Create('Le version de l''archive est incorrecte. Archive :'+vVersion+' / Attendu : '+FVersionBASE ) ;
    end;

    // Extract All mettre un CallBack ???
    Zip.ExtractTo(FAMAJDIR) ;
    Zip.Close ;

    // --------------------------
    DeleteFile(FAMAJVERSION) ;

    Result := true ;
  except
    on E:Exception do
      begin
          inc(FnbError);
          raise Exception.Create(CST_ERR_ZIP);
      end;
  end;
end;

procedure TThreadSynchro.Etape_Copy_VersionZip;
begin
   if FileExists(FVERSION) then
      begin
          FSTATUS:= Format('Copie de la version %s > %s',[FVERSION,FAMAJVERSION]);
          Synchronize(StatusCallBack);
          try
            // TFile.Copy(FVERSION, FAMAJVERSION);
            CopierFichier(FVERSION,FAMAJVERSION);
          except
              inc(FnbError);
              raise Exception.Create('Erreur lors de la copie de la version depuis le serveur');
          end;
      end
   else
    begin
      // Raise ?
      inc(FnbError);
      raise Exception.Create('Aucun fichier zip de version');
    end;

end;

procedure TThreadSynchro.Etape_Controles;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
              // Est-ce bien tout clean de EASY ?
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add(' SELECT RDB$RELATION_NAME                   ');
              vQuery.SQL.Add(' FROM RDB$RELATIONS WHERE RDB$SYSTEM_FLAG=0 ');
              vQuery.SQL.Add('  AND RDB$RELATION_NAME = ''SYM_DATA''      ');
              If not(vQuery.IsEmpty)
                then raise Exception.Create('La Table SYM_DATA existe toujours....');


              {
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT GEN_SYM_DATA_DATA_IDRDB$GENERATOR_NAME  ');
              vQuery.SQL.Add(' FROM RDB$GENERATORS       ');
              vQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0   ');
              vQuery.SQL.Add(' AND RDB$GENERATOR_NAME='''' ');
              vQuery.Open();
              If not(vQuery.IsEmpty)
                then raise Exception.Create('Erreur au contrôle : le générateur GEN_SYM_DATA_DATA_ID existe déjà');
              }

              // les générateurs sont-t-ils bien justes ?
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE;');
              vQuery.Open();

              // On s'autorise un petit delta ? Je ne sais pas .....
              If (vQuery.Fields[0].asLargeInt<>FGENID)
                then raise Exception.Create('Erreur au contrôle : Problème dans les générateurs !');


              FStatus:=Format('Contrôles dans %s : [OK]',[ExtractFileName(FGINKOIA_IB)]);
              Synchronize(StatusCallBack);


              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT * FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
              vQuery.Open();
              If not(vQuery.eof) then
                begin
                   FVersionBASE := vQuery.FieldByName('VER_VERSION').AsString;
                end;
              vQuery.Close;

            end;
      Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TThreadSynchro.RollBack_Sauvegarde();
var vTempName : string;
begin
     try
        try
          // SI EASY est démarré on va pas pouvoir faire la copie..
          if ServiceGetStatus(PChar(''),PChar('EASY'))<>1
            then
              begin
                 Etape_StopEASY();
              end;

          vTempName := IncludeTrailingPathDelimiter(FDATADir)+ 'GINKCOPY' + FormatDateTime('yyyymmdd-hhnnsszzz',Now()) + '.SAV';
          If not(RenameFile(FGINKOIA_IB,vTempName))
            then
              begin
                FRollBackOK := 0;              
                raise Exception.Create('Erreur au RollBack Etape 1');
              end;
              
          // on repose le Synchro.OLD en GINKOIA.IB
          If not(RenameFile(FSAV,FGINKOIA_IB))
            then
              begin
                FRollBackOK := 0;              
                raise Exception.Create('Erreur au RollBack Etape 2');
              end;

          if Not(DeleteFile(vTempName)) then
            begin
              FStatus:=Format('RollBack : Erreur à la suppression de %s (non bloquant).',[vTempName]);
              Synchronize(StatusCallBack);
            end;

          FRollBackOK := 1;              
          FStatus:='RollBack : remise en place de l''ancienne base.';
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;



procedure TThreadSynchro.Etape_Copie_Sauvegarde;
begin
     try
        try
          ForceDirectories(ExtractFilePath(FSAV));
          // S'il existe déja on vire le .toto
          if FileExists(FSAV) then
            DeleteFile(FSAV);

          If not(RenameFile(FGINKOIA_IB, FSAV))
            then
              begin
                 FStatus:= 'Erreur au renommage';
                 Synchronize(StatusCallBack);

                 ServiceStart('','EASY');
                 FStatus:= 'Erreur au renommage => Démarrage Service EASY';
                 Synchronize(StatusCallBack);

                 // 20s au moins...
                 DoPause(20);

                 raise Exception.Create('Erreur au renommage');
              end;
          FStatus:=Format('Renommage de la base %s en %s : [OK]',[ExtractFileName(FGINKOIA_IB),ExtractFileName(FSAV)]);
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;

procedure TThreadSynchro.Etape_Set_TABLE_GENPARAM();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vScript : TStringList;
    i:integer;
    vFile:string;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript := TStringList.Create;
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
                vFile := FDATADir + 'GENPARAM.sql';
                if not(LocaleFileExists(vFile))
                   then raise Exception.Create('Fichier GENPARAM.sql introuvable !');
                vScript.LoadFromFile(vFile);
                for I:=0 to vScript.Count-1 do
                  begin
                      vQuery.Close;
                      vQuery.SQL.Clear;
                      vQuery.SQL.Add(vScript.Strings[i]);
                      vQuery.ExecSQL;
                  end;
                vQuery.Close;
                // on supprime le fichier 
                // DeleteFile(vFile);
            end;
         FStatus:='Remplissage de GENPARAM : [OK]';
         Synchronize(StatusCallBack);
      Except On Ez : Exception do
          begin
            inc(FnbError);
            raise;
          end;
      end;
    finally
      vScript.DisposeOf;
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TThreadSynchro.Etape_Set_TABLE_GENGENERATEUR();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vScript : TStringList;
    i:integer;
    vFile:string;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript := TStringList.Create;
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
                vFile := FDATADir + 'GENGENERATEUR.sql';
                if not(LocaleFileExists(vFile))
                   then raise Exception.Create('Fichier GENGENERATEUR.sql introuvable !');
                vScript.LoadFromFile(vFile);
                for I:=0 to vScript.Count-1 do
                  begin
                      vQuery.Close;
                      vQuery.SQL.Clear;
                      vQuery.SQL.Add(vScript.Strings[i]);
                      vQuery.ExecSQL;
                  end;
                vQuery.Close;
               // on supprime
               // DeleteFile(vFile);
            end;
         FStatus:='Remplissage de GENGENERATEUR : [OK]';
         Synchronize(StatusCallBack);
      Except On Ez : Exception do
          begin
            inc(FnbError);
            raise;
          end;
      end;
    finally
      vScript.DisposeOf;
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

(*
procedure TThreadSynchro.DROP_SYMDS(const ABaseDonnees: TFileName);
var vParams:string;
    vCall:string;
    merror  : string;
    a       : cardinal;
begin
    // dbimport %s --force --format=CSV --table %s
    FStatus := 'DROP SYMDS';
    Synchronize(StatusCallBack);
    try


      vParams := 'drop-triggers';
      vCall   := Format('%s\bin\symadmin.bat',[FEASYInfos.Directory]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
      FStatus := merror;

      vParams := 'uninstall';
      vCall   := Format('%s\bin\symadmin.bat',[FEASYInfos.Directory]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
      FStatus := merror;

      vParams := 'create-sym-tables';
      vCall   := Format('%s\bin\symadmin.bat',[FEASYInfos.Directory]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
      FStatus := merror;

      // on passe le GRANT
      // et on rempli
      // par dbimport ?



      // faut remplir avant .....
      // symadmin sync-trigger


    finally

    end;
end;

*)

procedure TThreadSynchro.DROP_SYMDS(const ABaseDonnees: TFileName);
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
                      FPositionDetails:=0;
                      Synchronize(ProgressDetailsCallBack);
                      for i:= 0 to Count-1 do
                        begin
                            if Count<>0
                              then FPositionDetails:= Round(100*i/Count)
                              else FPositionDetails:= 0;
                            Synchronize(ProgressDetailsCallBack);
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
   DoPause(5);
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
     vScript.SQLScripts[0].SQL.Add('DELETE FROM SYM_NODE_IDENTITY;');
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

procedure TThreadSynchro.Etape_Group_Portables();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
begin
    try
      vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);
      vQuery := DataMod.getNewQuery(vCnx,nil);
      try
        try
           vCnx.open;
           If vCnx.Connected then
              begin
                 vQuery.Close;
                 vQuery.SQL.Clear;
                 vQuery.SQL.Add('SELECT * FROM SYM_NODE_GROUP WHERE NODE_GROUP_ID=:GRP');
                 vQuery.ParamByName('GRP').AsString:='portables';
                 vQuery.Open();
                 If vQuery.IsEmpty
                   then raise Exception.Create('Groupe "portables" absent de la configuration');
                 vQuery.Close();
              end;
        Except On Ez : Exception do
            begin
              inc(FnbError);
              FStatus:='[ERREUR] :' +Ez.Message;
              Synchronize(StatusCallBack);
              raise;
            end;
        end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
    // Erreur on arrive meme pas à se connecter à la base
    Except On E : Exception do
        begin
           inc(FnbError);
           FStatus:='[ERREUR] :' +E.Message;
           Synchronize(StatusCallBack);
           raise Exception.Create(CST_ERR_SERV_BASE);
        end;
    end;
end;


procedure TThreadSynchro.Etape_SetGenerateurs;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vScript : TStringList;
    i:integer;
    vFile:string;
begin
    FPositionDetails:=0;
    Synchronize(ProgressDetailsCallBack);
    try
      vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);
      vQuery := DataMod.getNewQuery(vCnx,nil);
      vScript := TStringList.Create;
      try
        try
           vCnx.open;
           If vCnx.Connected then
              begin
                  vFile := FDATADir + 'generateur.sql';
                  if not(LocaleFileExists(vFile))
                     then raise Exception.Create('Fichier generateur.sql introuvable !');
                  vScript.LoadFromFile(vFile);
                  for I:=0 to vScript.Count-1 do
                    begin
                        FPositionDetails:=Round(100*i/vScript.Count);
                        Synchronize(ProgressDetailsCallBack);
                        // désormais GEN_SYM_DATA_DATA_ID n'existe plus
                        if Pos('GEN_SYM_DATA_DATA_ID',vScript.Strings[i])=0 then
                          begin
                            vQuery.Close;
                            vQuery.SQL.Clear;
                            vQuery.SQL.Add(vScript.Strings[i]);
                            vQuery.ExecSQL;
                          end;
                    end;
                  // On laisse le fichier generateur.sql
                  vQuery.Close;
              end;
           FStatus:='Affectation des générateurs : [OK]';
           Synchronize(StatusCallBack);
           FPositionDetails:=100;
           Synchronize(ProgressDetailsCallBack);
        Except On Ez : Exception do
            begin
              inc(FnbError);
              FStatus:='[ERREUR] :' +Ez.Message;
              Synchronize(StatusCallBack);
              raise;
            end;
        end;
    finally
      vScript.DisposeOf;
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
    // Erreur on arrive meme pas à se connecter à la base
    Except On E : Exception do
        begin
           inc(FnbError);
           FStatus:='[ERREUR] :' +E.Message;
           Synchronize(StatusCallBack);
           raise Exception.Create(CST_ERR_SERV_BASE);
        end;
    end;
end;

procedure TThreadSynchro.Etape_Copie_From_Serveur();
begin
     try
        try
          FSTATUS:= Format('Copie depuis le serveur %s > %s',[FServeurGINKCOPY,FGINKOIA_IB]);
          Synchronize(StatusCallBack);

          try
            // TFile.Copy(FServeurGINKCOPY, FGINKOIA_IB)
            CopierFichier(FServeurGINKCOPY,FGINKOIA_IB);
          except
              raise Exception.Create('Erreur lors de la copie depuis le serveur');
          end;

          FSTATUS:='Copie depuis le serveur : [OK]';
          Synchronize(StatusCallBack);

        Except On E:Exception do
          begin
            inc(FnbError);
            Raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;

procedure TThreadSynchro.Etape_GetGenerateurs;
var chaine:string;
    merror:string;
    a:cardinal;
    vSQLFile : string;
begin
     try
        try
          // Suppression de l'ancien fichier
          vSQLFile := FDATADir + 'generateur.sql';

          FStatus:='Suppression de '+ ExtractFileName(vSQLFile);
          Synchronize(StatusCallBack);
          DeleteFile(FDATADir + 'generateur.sql');

          chaine:='-g';  // on veut que les générateurs "LOCAUX" (bientot)
          a:=ExecAndWaitProcess(merror, FGENERATEUR_EXE, chaine);
          if (FileExists(vSQLFile))
            then
              begin
                FSTATUS:='Récupération des générateurs : [OK]';
                Synchronize(StatusCallBack);
              end
            else raise Exception.Create('Erreur générateurs');
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;

procedure TThreadSynchro.Etape_ShutDown;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try

          chaine := Format('-shut -force 5 -user SYSDBA -password masterkey %s',[FGINKOIA_IB]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

          FSTATUS:=Format('Arrêt de la base %s : [OK]',[ExtractFileName(FGINKOIA_IB)]);
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            Raise Exception.Create('Erreur Arrêt de la base');
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TThreadSynchro.Etape_Restart;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          chaine := Format('-online -user SYSDBA -password masterkey %s',[FGINKOIA_IB]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

          FSTATUS:=Format('Restart de la base %s : [OK]',[ExtractFileName(FGINKOIA_IB)]);
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            Raise Exception.Create('Erreur au Restart de la base');
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TThreadSynchro.Etape_Clean_EASY_TmpDir();
var ShOp: TSHFileOpStruct;

begin
  FStatus:= 'Nettoyage de EASY\tmp';
  Synchronize(StatusCallBack);
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(FDATADir + '..\EASY\tmp\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NO_UI or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
  SHFileOperation(ShOp);
end;

function TThreadSynchro.LancerVerification(sParam: string = 'AUTO'; bWaitFor: boolean = false): boolean;
var
  timeout: Integer;
begin
  if bWaitFor then
    timeout := INFINITE
  else
    timeout := 0;

  // rajout du deuxième paramètre
  Result := ExecuterProcess('"' + FGinkoiaPath + 'Verification.exe" ' + sParam + ' SYNCHROPORTABLE ' + FBAS_GUID, timeout);
end;

procedure TThreadSynchro.RelancerLauncherEasy;
begin
  ExecuterProcess('"' + FGinkoiaPath + 'LauncherEasy.exe"', 0);
end;


function TThreadSynchro.doRestartApp: boolean;
begin
  Result := false;
  if FAutoStart then
    begin
      FStatus:= 'Relance du Launcher Easy';
      Synchronize(StatusCallBack);
      RelancerLauncherEasy;
      DoPause(5);
    end
  else
    begin
      FStatus:= 'Le Launcher Easy ne se relance qu''en Mode AUTO';
      Synchronize(StatusCallBack);
    end;

  // Nous n'avons pas eu d'erreur bloquante on peut donc lancer Verif
  if LancerVerification('SPECIFIQUE', True) then
      begin
         FStatus:= 'Passage de Verification SPECIFIQUE [OK]';
         Synchronize(StatusCallBack);
      end
    else
      begin
         FStatus:= 'Passage de Verification SPECIFIQUE [ERREUR]';
         Synchronize(StatusCallBack);
      end;
  DoPause(1);
  If LancerVerification('MAJ', False)
    then
      begin
         FStatus:= 'Passage de Verification MAJ [OK]';
         Synchronize(StatusCallBack);
      end
    else
      begin
         FStatus:= 'Passage de Verification MAJ [ERREUR]';
         Synchronize(StatusCallBack);
      end;
  DoPause(1);
  result := true;
end;


function TThreadSynchro.BoolToInt( aValue : Boolean) : Integer;
begin
  if aValue
    then result := 1
    else result := 0;
end;

function TThreadSynchro.setHistoEvent(aType: Integer; aDate: TDateTime; aResult: boolean; aTime: TTime; aBasId: Int64): boolean;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
begin
  vCnx   := DataMod.getNewConnexion('SYSDBA@'+FGINKOIA_IB);
  vQuery := DataMod.getNewQuery(vCnx,nil);
  try
    try
      vQuery.Close;
      vQuery.SQL.Text := 'EXECUTE PROCEDURE EVT_SETHISTO(:DATE, :MODULE, :BASE, :TYPE, :RESULT, :TIME, :BASID)';
      vQuery.ParamByName('DATE').AsDateTime := aDate;
      vQuery.ParamByName('MODULE').AsString := '';
      vQuery.ParamByName('BASE').AsString := FGINKOIA_IB;
      vQuery.ParamByName('TYPE').AsInteger := aType;
      vQuery.ParamByName('RESULT').AsInteger := BoolToInt(aResult);
      vQuery.ParamByName('TIME').AsTime := aTime;
      vQuery.ParamByName('BASID').AsLargeInt := aBasId;
      vQuery.ExecSQL;
       vQuery.Close;
      Result := true;
      except
        on E: Exception do
          begin
              raise;
          end;
    end;
  finally
    vQuery.DisposeOf;
    vCnx.DisposeOf;
  end;
end;


procedure TThreadSynchro.Etape_ALG();
begin
    FStatus:= 'Etape ALG';
    Synchronize(StatusCallBack);
    if FileExists(FGinkoiaPath + 'A_Maj\Liveupdate\SYNCHRO.ALG')
      then
        begin
          FStatus:= 'Application des ALG';
          Synchronize(StatusCallBack);
          If not(LancerVerification('ALG '+ FGinkoiaPath + 'A_Maj\Liveupdate\SYNCHRO.ALG', true))
            then
              begin
                FStatus:= 'Passage de Verification SYNCHRO.ALG';
                Synchronize(StatusCallBack);
              end;
        end
      else
        begin
          FStatus:= 'ALG inexistant.';
          Synchronize(StatusCallBack);
        end;
end;

procedure TThreadSynchro.Etape_StopEASY();
begin
    ServiceStop('','EASY');
    FStatus:= 'Arrêt du Service EASY';
    Synchronize(StatusCallBack);
    DoPause(5);
    // il arrive parfois qu'il reste un processus Java associé à ce service....
    if ServiceGetStatus(PChar(''),PChar('EASY'))<>1
      then
        begin
          // On attend 5 secondes de plus
          FStatus:= 'Le service a du mal à s''arrêter...';
          Synchronize(StatusCallBack);
          DoPause(5);
          ForceKillJavaEASY();
        end
      else
        begin
          FStatus:= 'Le service EASY est arreté...';
          Synchronize(StatusCallBack);
          DoPause(5);
          ForceKillJavaEASY();
        end;
end;

  // il faut parser le fichier wrapper... ==>
  // [wrapper] Started wrapper as PID  prendre les 2 derniers...

procedure TThreadSynchro.ForceKillJavaEASY();
var j:Integer;
    regExp : TPerlRegEx;
    vDateTime:TDateTime;
    vStream : TFileStream;
    vFileLog : TStrings;
    vPid : string;
    vPID_wrapper : integer;
    vPID_server  : integer;
    vEASY : TEasyInfos;
    vJava_Easy_Wrapper, vJava_Easy_Server :TProcessPIDInfos;
begin
    FStatus:= 'Contrôle des processus java.exe';
    Synchronize(StatusCallBack);

    vEASY := WMI_GetServicesEASY;

    vFileLog := TStringList.Create;
    vStream := TFileStream.Create(IncludeTrailingPathDelimiter(vEASY.Directory)+'logs\wrapper.log',fmOpenRead or fmShareDenyNone);
    try
      vStream.Position := 0;
      vFileLog.LoadFromStream(vStream);
      regExp := TPerlRegEx.Create;
      try
        regExp.RegEx := '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) (.*?) \[([^]]*)\] (.*)';
        j:= vFileLog.count;
        vPID_wrapper:=0;
        vPID_server:=0;
        while (j>0) and ((vPID_wrapper=0) or (vPID_server=0)) do
          begin
             Dec(j);
             if Length(vFileLog[j])>1
                then
                  begin
                     regExp.Subject  := vFileLog[j];
                     regExp.Options  := [preCaseLess];
                     If (regExp.Match())
                          then
                            begin
                               // LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);
                               if (regExp.Groups[3]='wrapper') then
                                 begin
                                    if (AnsiPos('Started server as PID',regExp.Groups[4])=1)
                                      then
                                        begin
                                            vPid := Trim(Copy(regExp.Groups[4],22,Length(regExp.Groups[4])));
                                            if vPID_server=0 then
                                                begin
                                                  vPID_server := StrToIntDef(vPid,0);
                                                  // pour pas passer dans la boucle suivante
                                                  Continue;
                                                end;
                                        end;
                                   if (AnsiPos('Started wrapper as PID',regExp.Groups[4])=1)
                                      then
                                        begin
                                            vPid := Trim(Copy(regExp.Groups[4],23,Length(regExp.Groups[4])));
                                            if vPID_wrapper=0 then
                                                begin
                                                  vPID_wrapper := StrToIntDef(vPid,0);
                                                  // pour pas passer dans la boucle suivante
                                                  Continue;
                                                end;
                                        end;
                                 end;
                            end;

                   end;
           end;
      finally
        regExp.DisposeOf;
      end;
    finally
      vStream.DisposeOf;
      vFileLog.DisposeOf;
    end;
    //--------------------------------------------------------------------------
    // Théoriquement le PID1 doit correspondre à vEASY.ProcessID
    // Mais j'ai déja vu le vEASY.ProcessID=0
    // et pourtant ca tourne.....

    vJava_Easy_Wrapper  := WMI_GetPIDInfos(vPID_wrapper);
    vJava_Easy_Server   := WMI_GetPIDInfos(vPID_server);

    FStatus:= Format('PID EASY : %d',[vEASY.ProcessID]);
    Synchronize(StatusCallBack);

    FStatus:= Format('PID Wrapper : %d',[vJava_Easy_Wrapper.ProcessID]);
    Synchronize(StatusCallBack);

    FStatus:= Format('PID Server : %d',[vJava_Easy_Server.ProcessID]);
    Synchronize(StatusCallBack);

    // On Kill le Wrapper
    if (vEASY.ProcessID=0) and (vJava_Easy_Wrapper.ProcessID<>0) and (vJava_Easy_Wrapper.Caption='java.exe')
      then
        begin
          if  (AnsiPos(UpperCase(vEASY.JavaPath),UpperCase(vJava_Easy_Wrapper.ExecutablePath))=1)
            then
              begin
                 // Forcage du Kill Process....
                 FStatus:= Format('Kill de Java Wrapper PID %d',[vJava_Easy_Wrapper.ProcessID]);
                 Synchronize(StatusCallBack);
                 TerminateProcessByID(vJava_Easy_Wrapper.ProcessID);
                 DoPause(3);
              end;
        end;

    // On Kill le Server
    if (vEASY.ProcessID=0) and (vJava_Easy_Server.ProcessID<>0) and (vJava_Easy_Server.Caption='java.exe')
      then
        begin
          if  (AnsiPos(UpperCase(vEASY.JavaPath),UpperCase(vJava_Easy_Server.ExecutablePath))=1)
            then
              begin
                 // Forcage du Kill Process....
                 FStatus:= Format('Kill de Java Server PID %d',[vJava_Easy_Server.ProcessID]);
                 Synchronize(StatusCallBack);
                 TerminateProcessByID(vJava_Easy_Server.ProcessID);
                 DoPause(3);
              end;
        end;

end;


function TThreadSynchro.TerminateProcessByID(ProcessID: Cardinal): Boolean;
var
  hProcess : THandle;
begin
  Result := False;
  hProcess := OpenProcess(PROCESS_TERMINATE,False,ProcessID);
  if hProcess > 0 then
  try
    Result := Win32Check(Winapi.Windows.TerminateProcess(hProcess,0));
  finally
    CloseHandle(hProcess);
  end;
end;

procedure TThreadSynchro.DoPause(asec:Integer);
var i:Integer;
begin
    // On fait évoluer le Détails pour les pauses...
    if FDebug then
      begin
          if asec=1
            then FStatus := Format('Pause de %d seconde',[aSec])
            else FStatus := Format('Pause de %d secondes',[aSec]);
          Synchronize(StatusCallBack);
      end;

    for i := 1 to aSec do
      begin
         Sleep(1000);
         FPositionDetails := Round(100*i/aSec);
         Synchronize(ProgressDetailsCallBack);
      end;
end;

procedure TThreadSynchro.Execute;
var vQuery  : TFDQuery;
    vNow : Cardinal;
    i :integer;
    vTableTrg , vTrg : integer;
    vAttente : integer;
begin
    try
      try
         // On depose le 7z.dll
         FPosition := 1;
         Synchronize(ProgressCallBack);

         Ressource7z();

         FStatus:= 'Kill de CaisseGinkoia.exe';
         Synchronize(StatusCallBack);
         KillProcessus('CaisseGinkoia.exe');
         DoPause(1);

         FStatus:= 'Kill de ginkoia.exe';
         Synchronize(StatusCallBack);
         KillProcessus('Ginkoia.exe');
         DoPause(1);

         // Kill LauncherEASY
         FStatus:= 'Kill du LauncherEASY';
         Synchronize(StatusCallBack);
         KillProcessus('LauncherEASY.exe');
         DoPause(2);

         KillApp.Load;
         for i := 0 to KillApp.Count - 1 do
           begin
              KillProcessus(KillApp.List[i]);
              DoPause(1);
           end;

         // Stop de EASY
         Etape_StopEASY();

         // Recup du BASID

         // Nettoyage de /EASY/tmp/
         Etape_Clean_EASY_TmpDir();

         FPosition := 2;
         Synchronize(ProgressCallBack);

         Etape_Get_BASID();

         // Ecriture des Génarateur dans le fichier generateur.sql
         Etape_GetGenerateurs();
         DoPause(1);

         // Ne n'est plus réaliser par ca mais par generateur.sql
         // je conserve encore pour cette version...
         Etape_Get_TABLE_GENGENERATEUR();

         Etape_Get_TABLE_GENPARAM();

         FPosition := 3;
         Synchronize(ProgressCallBack);

         Etape_Recup_SYMDS();
         DoPause(1);

         FPosition := 4;
         Synchronize(ProgressCallBack);

         // Les Générateurs sont passé avant.... Donc si tout se passe bien
         // le GENERAL_ID sera au bon niveau
         // ici on ecrit qu'on essaye de faire unse Synchro dans l'ancienne BASE GINKOI.IB
         // Ca mange un ID du GENERAL_ID mais ce n'est pas une donnée importante
         FStatus:= 'Evenement lancement synchro';
         Synchronize(StatusCallBack);
         setHistoEvent(CLASTSYNC, Now, False, 0, FBAS_ID);

         // A partir de la on ne doit plus avoir accès à la base
         DataMod.FreeInfFDManager('SYSDBA@'+FGINKOIA_IB);

         DoPause(5);

         // GINKOIA.IB ==> SYNCHRO.OLD
         Etape_Copie_Sauvegarde();

         // C'est la partie Critique du remplacement....
         // au moindre problème on remet l'ancien...
         try
           FPosition := 5;
           Synchronize(ProgressCallBack);

           // \\SERVEUR\GINKOIA\DATA\SYNCHRO\GINKCOPY.IB ==> GINKOIA.IB
           Etape_Copie_From_Serveur();

           FPosition := 30;
           Synchronize(ProgressCallBack);

           // Shutdow de ginkoia.IB
           Etape_ShutDown();

           // Controle de l'existance de la config "portables"
           Etape_Group_Portables;

           // nettoyage de SYMDS
           FStatus:= Format('Nettoyage SymmetricDS dans %s',[ExtractFileName(FGINKOIA_IB)]);
           Synchronize(StatusCallBack);
           //
           DROP_SYMDS(FGINKOIA_IB);

           // on repose les générateurs
           Etape_SetGenerateurs();

           FPosition := 31;
           Synchronize(ProgressCallBack);

           Etape_Controles;

           FPosition := 33;
           Synchronize(ProgressCallBack);

           Etape_Set_TABLE_GENGENERATEUR();

           Etape_Set_TABLE_GENPARAM();

           Etape_RE_INSERT_MY_IDENTITY();

           // Restart de EASY....
           // Start Easy
           ServiceStart('','EASY');
           FStatus:= 'Démarrage Service EASY';
           Synchronize(StatusCallBack);

           // 20s au moins...
           DoPause(20);

           FPosition := 50;
           Synchronize(ProgressCallBack);

           // --------------------------------------------------------------------
           // Tant qu'il n'y a pas toutes les TABLES SYM_XXX il faut attendre.....
           i := 0;
           while not(DataMod.Controle_SYMDS_READY(FGINKOIA_IB)) and (i<30) do
              begin
                 inc(i);
                 DoPause(5);
              end;

           // --------------------------------------------------------------------
           if not(DataMod.Controle_SYMDS_READY(FGINKOIA_IB))
             then
               begin
                  raise Exception.Create('Erreur de configuration SYMDS');
               end;

           FPosition := 34;
           Synchronize(ProgressCallBack);

           Etape_Copy_VersionZip();

           FPosition := 35;
           Synchronize(ProgressCallBack);

           ExtractVersionArchive();

           FPosition := 40;
           Synchronize(ProgressCallBack);


         except
              On E:Exception do
                begin
                  // RollBack : SYNCHRO.OLD => GINKOIA.IB-----------------------
                  RollBack_Sauvegarde();
                  FErrorMessage := E.Message;
                  FSTATUS       := E.Message;
                  Synchronize(StatusCallBack);
                  // -----------------------------------------------------------
                  raise;
                end;
         end;

         //---------------------------------------------------------------------
         // attendre que tout soit OK ==> Creattion des Triggers est elle en cours... ?

         // Pas les ALG ??
         // Etape_ALG();


         //---------------------------------------------------------------------
         // il faut voir si ca regenere bien les triggers..... -----------------
         vTableTrg := DataMod.NbTableTriggersSymDS(FGINKOIA_IB);
         vTrg      := DataMod.NbTriggersSymDS(FGINKOIA_IB);
         if not(DataMod.Grant_SYMTABLE_TO_GINKOIA(FGINKOIA_IB)) then
            begin
              raise Exception.Create('Erreur au Grant');
            end;

         // --------------------------------------------------------------------
         FStatus   := Format('Triggers [ %d / %d ]',[vTrg,vTableTrg]);
         Synchronize(StatusCallBack);
         // --------------------------------------------------------------------
         if vTableTrg<>0
          then FPositionDetails := Round(100*vTrg / vTableTrg)
          else FPositionDetails := 0;
         Synchronize(ProgressDetailsCallBack);
         // 5 Minutes = 300 secondes   300 fois 1 seconde....
         vAttente := 300;
         // si on a toujours aucun trigger (machine lente) on ralonge encore un peu... 600 secondes donc 10 minutes
         if vTrg=0 then vAttente := 600;
         i := 0;
         while (i<vAttente) and (vTableTrg<>vTrg) do
            begin
               Inc(i);
               if (i mod 10)=0
                then
                  begin
                      vTableTrg := DataMod.NbTableTriggersSymDS(FGINKOIA_IB);
                      vTrg      := DataMod.NbTriggersSymDS(FGINKOIA_IB);
                      //--------------------------------------------------------
                      FPositionDetails := Round(100*vTrg/vTableTrg);
                      Synchronize(ProgressDetailsCallBack);
                      //--------------------------------------------------------
                      FPosition := Round(50 + 45 * (vTrg / vTableTrg));
                      Synchronize(ProgressCallBack);
                      //--------------------------------------------------------
                      FStatus   := Format('Triggers [ %d / %d ]',[vTrg,vTableTrg]);
                      Synchronize(StatusCallBack);
                  end;
               Sleep(1000);
            end;

         // Les triggers sont là On restart la BASE
         if (vTrg=vTableTrg) and (vTableTrg>100)  // 100 c'est un exemple on a plus de 100 triggers
           then
             begin
                 Etape_Restart();
                 FPosition := 32;
                 Synchronize(ProgressCallBack);
                 //---------------------------------------------------------------------
             end
           else
            begin
              // if (vTrg=0) or (vTableTrg=0) or (vTableTrg<=100)
              //    then
              FStatus:= 'Problème du nombre de triggers';
              Synchronize(StatusCallBack);

              // les 5 minutes sont passés
              // Problème dans le nombre de triggers
              FStatus:= 'Attention la base reste Shutdown';
              Synchronize(StatusCallBack);

              // Stop de EASY
              Etape_StopEASY();
              raise Exception.Create('Erreur critique');

            end;

         FPosition := 95;
         Synchronize(ProgressCallBack);

         UpdateYellis;

         // Ecriture
         FStatus:= 'Ecriture HistoEvent';
         Synchronize(StatusCallBack);

         setHistoEvent(CLASTSYNC, Now, True, 0, FBAS_ID);
         setHistoEvent(CSYNCHROOK, Now, True, 0, FBAS_ID);

         doRestartApp();

         FPositionDetails := 100;
         Synchronize(ProgressDetailsCallBack);

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


procedure TThreadSynchro.UpdateYellis;
var
  vYellis: TConnexion;
  vIdVersion: Integer;
  vNomVersion: string;
  vYRes: TStringList;
  vSyncVersion: string;
  vIdClient: Int64;
  vVersionClient: Integer;
  vBasGuid: string;
  {
  vIdVersion: Integer;

  vBasId: Int64;                1
  vBasIdent: Integer;
  vBasNom: string;

}
begin
  try
    FStatus:= 'Mise à Jour Yellis';
    Synchronize(StatusCallBack);

    {
    if not Database.Connected then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Base de données non connectée', logWarning, true, 0, ltLocal);
      Exit;
    end;

    if not getVersion(vSyncVersion) then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Récupération de la version impossible', logWarning, true, 0, ltLocal);
      Exit;
    end;




    vSyncVersion := trim(vSyncVersion);
    if vSyncVersion = '' then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Version non trouvée', logWarning, true, 0, ltLocal);
      Exit;
    end;

    if not getBasId(vBasId, vBasIdent, vBasNom, vBasGuid) then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Information de base inaccessible', logWarning, true, 0, ltLocal);
      Exit;
    end;
    }

    vSyncVersion := trim(FVersionBASE);
    vBasGuid     := trim(FBAS_GUID);
    if trim(FBAS_GUID) = '' then
    begin
      // Log.Log('Synchro', 'updateYellis', 'Log', 'Information de base invalide', logWarning, true, 0, ltLocal);
      Exit;
    end;

    CoInitialize(nil);
    vIdVersion := 0;
    vYellis := Tconnexion.create;
    try
      // recuperation de la version Yellis
      vIdVersion := 0;
      vNomVersion := '';
      vYRes := vYellis.Select('select * FROM version WHERE version="' + vSyncVersion + '"');
      try
        if vYellis.recordCount(vYRes) > 0 then
        begin
          vIdVersion := vYellis.UneValeurEntiere(vYRes, 'id', 0);
          vNomVersion := vYellis.UneValeur(vYRes, 'nomversion');
        end;
      finally
        vYRes.Free;
      end;

      if vIdVersion = 0 then
      begin
        // Log.Log('Synchro', 'updateYellis', 'Log', 'Version Yellis non trouvée', logWarning, true, 0, ltLocal);
        Exit;
      end;

      // Log.Log('Synchro', 'updateYellis', 'Log', 'Version Yellis : ' + vNomVersion, logInfo, true, 0, ltLocal);

      // Récupération des infos client
      vIdClient := 0;
      vVersionClient := 0;
      vYRes := vYellis.Select('select * FROM clients WHERE clt_GUID="' + vBasGuid + '"');
      try
        if vYellis.recordCount(vYRes) > 0 then
        begin
          vIdClient := vYellis.UneValeurEntiere(vYRes, 'id', 0);
          vVersionClient := vYellis.UneValeurEntiere(vYRes, 'version', 0);
        end;
      finally
        vYRes.Free;
      end;

      if vIdClient = 0 then
      begin
        // Log.Log('Synchro', 'updateYellis', 'Log', 'Client Yellis non trouvé' + vNomVersion, logWarning, true, 0, ltLocal);
        Exit;
      end;

      // Mise a jour de Yellis
      if not vYellis.ordre('update clients set version=' + IntToStr(vIdVersion) + ', version_max=0, patch=-1, spe_fait=-1 WHERE id=' + IntToStr(vIdClient)) then
      begin
        // Log.Log('Synchro', 'updateYellis', 'Log', 'Yellis n''a pas pu être mis à jour', logWarning, true, 0, ltLocal);
        Exit;
      end;

      // Log.Log('Synchro', 'updateYellis', 'Log', 'Yellis a été mis à jour', logInfo, true, 0, ltLocal);

      FStatus:= 'Mise à Jour Yellis : [OK] ';
      Synchronize(StatusCallBack);

    finally
      vYellis.free;
    end;
  except
    on E: Exception do
      Log.Log('Synchro', 'updateYellis', 'Log', E.Message, logError, true, 0, ltLocal);
  end;
end;



end.

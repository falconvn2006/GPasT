unit uThreadOptimizeDB;

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
  cHash,
  System.Math;


const CST_HOST          = 'localhost'; // '127.0.0.1';
      CST_PORT          = 3050;
      CST_BASE_USER     = 'SYSDBA';
      CST_BASE_PASSWORD = 'masterkey';


type
  // Quelques type dont j'ai besoin pour le thread il faudrait peut-etre les mettres dans une autre unité
  TStatusMessageCall = Procedure (const info:String) of object;
  TLogMessageCall    = Procedure (const info:string) of object;
  //
  TIndex = record
    Index : string;
    Table : string;
  end;
  // Liste des index
  TIndexs = array of TIndex;


  TOptimizeDB = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FLogProc       : TLogMessageCall;
    FStatus        : string;             // Status c'est pour savoir ou on en est relativement court
    FLog           : string;             // Log est plus précis et plus long que le Status
    FConn          : TFDConnection;
    FIBFile        : TFileName;
    Foptions       : String;
    FnbErrors       : integer;
    function  DoSweep(): boolean;
    procedure Etape_Recalcul_Index_Ginkoia();
    procedure Etape_Recalcul_Index_SYMDS();
    procedure Etape_Pre_Prurge();
  protected
    procedure StatusCallBack();
    procedure LogCallBack();
    procedure Execute; override;
  public
    constructor Create(aIBFile:TFileName;
      aOptions        : string;
      aStatusCallBack : TStatusMessageCall;
      aLogCallBack    : TLogMessageCall;
      aEvent:TNotifyEvent=nil);
    destructor Destroy();
  property NBErrors: integer read FNbErrors;
  end;

implementation

Uses uMainForm,uDataMod;

constructor TOptimizeDB.Create(aIBFile:TFileName;
    aOptions        : string;
    aStatusCallBack : TStatusMessageCall;
    aLogCallBack    : TLogMessageCall;
    aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    FConn := TFDConnection.Create(nil);
    OnTerminate     := AEvent;
    FreeOnTerminate := True;

    FStatusProc     := aStatusCallBack;
    FLogProc        := aLogCallBack;

    FIBFile         := aIBFILE;
    Foptions        := aOptions;
    FnbErrors       := 0;
    FConn.Connected := false;

    FConn.Params.DriverID := 'IB';
    FConn.Params.Add('Server='+CST_HOST);
    FConn.Params.Database := FIBFile;
    FConn.Params.UserName := CST_BASE_USER;
    FConn.Params.Password := CST_BASE_PASSWORD;
    FConn.LoginPrompt     := false;
end;

destructor TOptimizeDB.Destroy();
begin
  Inherited;
end;


procedure TOptimizeDB.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TOptimizeDB.LogCallBack();
begin
   if Assigned(FLogProc)   then  FLogProc(FLog);
end;



function TOptimizeDB.DoSweep() : boolean;
var Validate : TFDIBValidate;
begin
  FStatus   := 'Sweep';
  Synchronize(StatusCallBack);
  Result := false;
  Validate := TFDIBValidate.Create(nil);
  try
    try

      Validate.DriverLink := DataMod.FDPhysIBDriverLink1;
      Validate.Options := [roValidateFull];
      Validate.Protocol := ipTCPIP;

      Validate.Host     := CST_HOST;
      Validate.Port     := CST_PORT;
      Validate.UserName := CST_BASE_USER;
      Validate.Password := CST_BASE_PASSWORD;

      Validate.Database := FIBFile;

      Validate.Sweep();
      Sleep(1000);

      FStatus      := 'Sweep : OK';
      Synchronize(StatusCallBack);
      Result    := true;
  except
    on e : Exception do
      begin
          Inc(FNBErrors);
          FStatus := 'Sweep : Error';
          Synchronize(StatusCallBack);
          Raise;
      end;
  end;
  finally
    FreeAndNil(Validate);
  end;
end;


procedure TOptimizeDB.Etape_Pre_Prurge();
var vQuerySelect,vQueryDelete:TFDQuery;
    i:integer;
    vBefore : TDateTime;
begin
    FStatus := 'Pré-Purge';
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    FLog    := 'Pré-Purge';
    if Assigned(FLogProc) then Synchronize(LogCallBack);
    //-----------------------------------------------------
    vQuerySelect := TFDQuery.Create(nil);
    vQuerySelect.Connection := FConn;
    vQueryDelete := TFDQuery.Create(nil);
    vQueryDelete.Connection := FConn;
    try
      try
         // vCnx.Transaction.Options.AutoCommit := true;
         FConn.open;
         If FConn.Connected then
            begin
              // On en profite pour trouver le parametre de Purge ??? Non on purge tout ce qui est purgeable avant J-1
              vBefore :=  Now()-1;
              FStatus:=Format('Pré-Purge sur tous les parquets OK avant %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vBefore)]);
              // if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:=Format('Pré-Purge sur tous les parquets OK avant %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vBefore)]);
              //if Assigned(FLogProc) then Synchronize(LogCallBack);

              vQuerySelect.Close;
              vQuerySelect.SQL.Clear;
              vQuerySelect.SQL.Add('SELECT BATCH_ID FROM SYM_OUTGOING_BATCH          ');
              vQuerySelect.SQL.Add(' WHERE status = ''OK'' AND CREATE_TIME<:ABEFORE  ');
              vQuerySelect.ParamByName('ABEFORE').AsDateTime := vBefore;
              vQuerySelect.OptionsIntf.UpdateOptions.ReadOnly := true;
              i:=0;
              vQuerySelect.Open();
              while not(vQuerySelect.eof) do
                begin
                   Inc(i);
                   if ((i mod 1000)=0)
                    then
                      begin
                         FStatus:=Format('Pré-Purge de SYM_DATA_EVENT : Boucle N° %d',[i]);
                         if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                         FLog:=Format('Pré-Purge de SYM_DATA_EVENT : Boucle N° %d',[i]);
                         if Assigned(FLogProc) then Synchronize(LogCallBack);
                      end;
                   vQueryDelete.Close;
                   vQueryDelete.SQL.Clear;
                   vQueryDelete.SQL.Add('DELETE FROM SYM_DATA_EVENT WHERE BATCH_ID=:BATCHID');
                   vQueryDelete.ParamByName('BATCHID').AsLargeInt := vQuerySelect.FieldByName('BATCH_ID').AsLargeInt;
                   vQueryDelete.ExecSQL;
                   //
                   vQuerySelect.Next;
                END;
              vQuerySelect.Close;

              // ----- DELETE DES BATCHID --------------------------------------
              FStatus:=Format('Pré-Purge de SYM_DATA_EVENT terminée : %d Boucles',[i]);
              if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:=Format('Pré-Purge de SYM_DATA_EVENT terminée : %d Boucles',[i]);
              if Assigned(FLogProc) then Synchronize(LogCallBack);

              // ----- DELETE DES BATCHID --------------------------------------
              FStatus:=Format('Purge de SYM_OUTGOING_BATCH : %d enregistrements à supprimer',[i]);
              if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:=Format('Purge de SYM_OUTGOING_BATCH : %d enregistrements à supprimer',[i]);
              if Assigned(FLogProc) then Synchronize(LogCallBack);

              vQueryDelete.Close;
              vQueryDelete.SQL.Clear;
              vQueryDelete.SQL.Add('DELETE FROM SYM_OUTGOING_BATCH          ');
              vQueryDelete.SQL.Add(' WHERE status = ''OK'' AND CREATE_TIME<:ABEFORE  ');
              vQueryDelete.ParamByName('ABEFORE').AsDateTime := vBefore;
              vQueryDelete.ExecSQL;

              FStatus:='Pré-Purge Terminée';
              //if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:='Pré-Purge Terminée';
              //if Assigned(FLogProc) then Synchronize(LogCallBack);


            end;
      Except On Ez : Exception do
          begin
             inc(FnbErrors);
             raise;
          end;
      end;
    finally
      vQueryDelete.DisposeOf;
      vQuerySelect.DisposeOf;
    end;
end;




procedure TOptimizeDB.Etape_Recalcul_Index_GINKOIA();
var vQuery:TFDQuery;
    i:integer;
    vIndexs : TIndexs;
begin
    FStatus:='Recalcul des Index GINKOIA';
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FConn;
    try
      try
         FConn.open;
         If FConn.Connected then
            begin

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME NOT LIKE ''%$%''  ');
              vQuery.SQL.Add(' AND RDB$RELATION_NAME NOT LIKE ''SYM_%''  ');
              vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME               ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              // Comme j'ai pas "locker cette transaction.. le temps du traitement"
              // je vais poser dans un array
              SetLength(vIndexs,0);
              while not(vQuery.eof) do
                begin
                   i:=Length(vIndexs);
                   SetLength(vIndexs,i+1);
                   vindexs[i].Index := vQuery.Fields[0].AsString;
                   vindexs[i].TABLE := vQuery.Fields[1].AsString;
                   vQuery.Next;
                end;
              vQuery.Close;


              for i := Low(vIndexs) to High(vIndexs) do
                begin
                  FStatus:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                  FLog:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FLogProc) then Synchronize(LogCallBack);

                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add(Format('SET STATISTICS INDEX %s;',[vIndexs[i].Index]));
                  vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
                  vQuery.ExecSQL;
                end;

               vQuery.Close;
            end;
      Except On Ez : Exception do
          begin
             inc(FnbErrors);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
    end;
end;


procedure TOptimizeDB.Etape_Recalcul_Index_SYMDS();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
    vIndexs : TIndexs;
begin
    FStatus:='Recalcul des Index SYMDS';
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);

    FLog:='Recalcul des Index SYMDS';
    if Assigned(FLogProc) then Synchronize(LogCallBack);

    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FConn;
    try
      try
         FConn.open;
         If FConn.Connected then
            begin
              // On en profite pour trouver le parametre de Purge

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME NOT LIKE ''%$%''  ');
              vQuery.SQL.Add(' AND RDB$RELATION_NAME LIKE ''SYM_%''  ');
              vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME               ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              // Comme j'ai pas "locker cette transaction.. le temps du traitement"
              // je vais poser dans un array
              SetLength(vIndexs,0);
              while not(vQuery.eof) do
                begin
                   i:=Length(vIndexs);
                   SetLength(vIndexs,i+1);
                   vindexs[i].Index := vQuery.Fields[0].AsString;
                   vindexs[i].TABLE := vQuery.Fields[1].AsString;
                   vQuery.Next;
                end;
              vQuery.Close;


              for i := Low(vIndexs) to High(vIndexs) do
                begin
                  FStatus:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                  FLog:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FLogProc) then Synchronize(LogCallBack);

                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add(Format('SET STATISTICS INDEX %s;',[vIndexs[i].Index]));
                  vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
                  vQuery.ExecSQL;
                end;

               vQuery.Close;
            end;
      Except On Ez : Exception do
          begin
             inc(FnbErrors);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
    end;
end;


procedure TOptimizeDB.Execute;
begin
   try
     FStatus:=Format('Base %s',[FIBFile]);
     if Assigned(FStatusProc) then Synchronize(StatusCallBack);

     FLog:=Format('Base %s',[FIBFile]);
     if Assigned(FLogProc) then Synchronize(LogCallBack);

     if (Foptions[1] = '1') then
      begin
        DoSweep;
      end;

    if (Foptions[2]) = '1' then
      begin
        Etape_Recalcul_Index_GINKOIA();
      end;

    if (Foptions[3]) = '1' then
      begin
        Etape_Pre_Prurge
      end;

    if (Foptions[4]) = '1' then
      begin
        Etape_Recalcul_Index_SYMDS();
      end;
      FConn.close;
   Except
      //
   end;
end;

end.
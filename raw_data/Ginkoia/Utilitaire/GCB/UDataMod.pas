//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT UDataMod;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
    FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Comp.Client,
    FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Phys.IB,
    FireDAC.Stan.ExprFuncs, FireDAC.Comp.ScriptCommands, FireDAC.Comp.Script,
    FireDAC.Stan.Util, FireDAC.Phys.SQLiteDef, FireDAC.Phys.IBDef;

TYPE
    TDataMod = CLASS(TDataModule)
    FDConLiteConnexion: TFDConnection;
    FDTransConnexion: TFDTransaction;
    FDConLiteGCTRLB: TFDConnection;
    FDTransGCTRLB: TFDTransaction;
    FDSQLiteCollation1: TFDSQLiteCollation;
    FDConIB: TFDConnection;
    FDTransIB: TFDTransaction;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDScript1: TFDScript;
    SaveDialog1: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    function GetVersionDBGinkoia():string;
    procedure CSVExport(DataSet:TDataSet);
    function IBProcedureExist(AProcedure : string):Boolean;
    procedure IBVMonitor;
    procedure SQLiteStartConnexion(Connexion_DBFile:string;controle_DBFile:string);
    function  GetVersionDB_GCB():string;
    function SetVersionDB_GCB(Version:string):boolean;
    function DB_In_Connexions(ADataSet:TDataSet):integer;
    function AddDBConnexions(ADataSet:TDataSet):integer;
    { Déclarations publiques }
    END;

VAR
    DataMod: TDataMod;

IMPLEMENTATION
{$R *.DFM}

Uses UCommun;

function TDataMod.AddDBConnexions(ADataSet:TDataSet):integer;
var SQuery:TFDQuery;
begin
     result:=0;
     SQuery:=TFDQuery.Create(DataMod);
     try
      DataMod.FDConLiteConnexion.open();
      if DataMod.FDConLiteConnexion.Connected then
          begin
              SQuery.Connection:=DataMod.FDConLiteConnexion;
              SQuery.close;
              SQuery.SQL.Clear;
              SQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_NOM=:DOSSIER');
              SQuery.ParamByName('DOSSIER').asstring := ADataSet.FieldByName('DOSSIER').asstring;;
              SQuery.Open;
              if SQuery.IsEmpty
                then
                  begin
                      SQuery.Append;
                      SQuery.FieldByname('CON_NOM').asstring     := ADataSet.FieldByName('DOSSIER').asstring;
                  end
                else SQuery.Edit;
              SQuery.FieldByname('CON_SERVER').asstring  := ADataSet.FieldByName('LAME').asstring;
              SQuery.FieldByname('CON_PATH').asstring    := ADataSet.FieldByName('GINKOIA').asstring;
              SQuery.FieldByname('CON_MONITOR').asstring := ADataSet.FieldByName('MONITOR').asstring;
              SQuery.FieldByname('CON_FAV').asinteger    := 1;
              SQuery.Post;
          end;
       Finally
           SQuery.Close;
           SQuery.Free;
     end;
end;


function TDataMod.DB_In_Connexions(ADataSet:TDataSet):integer;
var SQuery:TFDQuery;
begin
     result:=0;
     SQuery:=TFDQuery.Create(DataMod);
     try
      DataMod.FDConLiteConnexion.open();
      if DataMod.FDConLiteConnexion.Connected then
          begin
              SQuery.Connection:=DataMod.FDConLiteConnexion;
              SQuery.close;
              SQuery.SQL.Clear;
              SQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_NOM=:DOSSIER');
              SQuery.ParamByName('DOSSIER').AsString:=ADataSet.FieldByName('DOSSIER').asstring;
              SQuery.Open;
              if (Squery.recordcount=1) then
                 begin
                  if Squery.FieldByName('CON_PATH').asstring<>ADataSet.FieldByName('GINKOIA').asstring then
                     result:=result+16;
                  if Squery.FieldByName('CON_MONITOR').asstring<>ADataSet.FieldByName('MONITOR').asstring then
                     result:=result+32;
                  if Squery.FieldByName('CON_SERVER').asstring<>ADataSet.FieldByName('LAME').asstring then
                     result:=result+64;
                  exit;
                 end;
              // sinon on ecrit
              result:=result+128;
        end;
       Finally
           SQuery.Close;
           SQuery.Free;
     end;
end;


procedure TDataMod.IBVMonitor;
var FDScript:TFDScript;
begin
      if DataMod.FDConIB.Connected then
        begin
             try
                FDScript:=TFDScript.Create(DataMod);
                FDScript.Connection:=DataMod.FDConIB;
                FDScript.ExecuteAll;
                finally
                FDScript.Free;
             end;
            end;
end;

function TDataMod.IBProcedureExist(AProcedure : string):Boolean;
var SQuery:TFDQuery;
begin
     result:=false;
      if DataMod.FDConIB.Connected then
        begin
             SQuery:=TFDQuery.Create(DataMod);
             try
                SQuery.Connection:=DataMod.FDConIB;
                SQuery.close;
                SQuery.SQL.Clear;
                SQuery.SQL.Add('SELECT rdb$procedure_name from rdb$procedures where rdb$procedure_name =: PROCEDURENAME');
                SQuery.Open;
                result:=not(SQuery.IsEmpty);
             Finally
               SQuery.Close;
               SQuery.Free;
             end;
        end;
end;

procedure TDataMod.DataModuleCreate(Sender: TObject);
begin
    //
end;


procedure TDataMod.SQLiteStartConnexion(Connexion_DBFile:string;controle_DBFile:string);
begin
     Try
        FDConLiteGCTRLB.Params.Clear;
        FDConLiteGCTRLB.Params.Add('DriverID=SQLite');
        FDConLiteGCTRLB.Params.Add('Database=' + ExtractFilePath(Application.ExeName) + controle_DBFile);
        FDConLiteGCTRLB.Params.Add('LockingMode=Normal');
        FDConLiteGCTRLB.Params.Add('StringFormat=UniCode');
        FDConLiteGCTRLB.Params.Add('Database encoding=UTF8');
        FDConLiteGCTRLB.Open;
        FDConLiteConnexion.DriverName:='SQLite';
        FDConLiteConnexion.Params.Clear;
        FDConLiteConnexion.Params.Add('DriverID=SQLite');
        FDConLiteConnexion.Params.Add(Format('Database=%s',[ExtractFilePath(Application.ExeName) + Connexion_DBFile ] ));
        FDConLiteConnexion.Params.Add('LockingMode=Normal');
        FDConLiteConnexion.Params.Add('StringFormat=UniCode');
        FDConLiteConnexion.Params.Add('Database encoding=UTF8');
        FDConLiteConnexion.open;
       Except
       //
     End;
end;


function  TDataMod.GetVersionDB_GCB():string;
var SQuery:TFDQuery;
begin
     result:='';
      if DataMod.FDConLiteGCTRLB.Connected then
        begin
             SQuery:=TFDQuery.Create(DataMod);
             SQuery.Connection:=DataMod.FDConLiteGCTRLB;
             SQuery.close;
             SQuery.SQL.Clear;
             SQuery.SQL.Add('SELECT SVR_VERSION FROM SCRVERSION');
             SQuery.Open;
             SQuery.First;
             result:=SQuery.FieldByName('SVR_VERSION').asstring;
             SQuery.Close;
             SQuery.Free;
        end;
end;


function TDataMod.SetVersionDB_GCB(Version:string):boolean;
var SQuery:TFDQuery;
begin
     result:=false;
     if DataMod.FDConLiteGCTRLB.Connected then
         begin
             SQuery:=TFDQuery.Create(DataMod);
             try
                SQuery.Connection:=DataMod.FDConLiteGCTRLB;
                 SQuery.close;
                 SQuery.SQL.Clear;
                 SQuery.SQL.Add('SELECT * FROM SCRVERSION');
                 SQuery.Open;
                 SQuery.First;
                 SQuery.Edit;
                 SQuery.FieldByName('SVR_VERSION').asstring:=Version;
                 SQuery.Post;
                 result:=true;
              finally
                   SQuery.Close;
                   SQuery.Free;
              end
          end;
end;


function  TDataMod.GetVersionDBGinkoia():string;
var SQuery:TFDQuery;
begin
     result:='';
      if DataMod.FDConIB.Connected then
        begin
             SQuery:=TFDQuery.Create(DataMod);
             SQuery.Connection:=DataMod.FDConIB;
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

procedure TDataMod.CSVExport(DataSet:TDataSet);
var i:Integer;
    CSV:TStringList;
    line:string;
    FirstPass:boolean;
    ASDFile:TSaveDialog;
    TheName:string;
begin
     If DataSet.IsEmpty then exit;
     CSV := TStringList.Create;
     try
        TheName:='';
        ASDFile:=TSaveDialog.Create(nil);
        ASDFile.InitialDir:=Var_Glob.Exe_Directory;
        ASDFile.Filter := 'Fichiers CSV (*.csv)|*.CSV';
        ASDFile.FileName:=FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.csv';
        if ASDFile.Execute
           then
              begin
                  DataSet.First;
                  FirstPass:=true;
                  CSV.Add(TFDQuery(DataSet).Connection.Params.text);
                  CSV.Add(TFDQuery(DataSet).SQL.text);
                   while not(DataSet.eof) do
                      begin
                           Line:='';
                           if (FirstPass) then
                             begin
                                 for i:=0 to DataSet.FieldCount-1 do
                                   begin
                                       Line := Line + DataSet.Fields[i].FieldName + ';'
                                   end;
                                 CSV.Add(Line);
                                 FirstPass:=False;
                                 Line:='';
                             end;
                           for i:=0 to DataSet.FieldCount-1 do
                                begin
                                     if DataSet.Fields[i].IsNull then
                                        Line := Line + #0 + ';'
                                     else
                                        Line := Line + DataSet.Fields[i].asstring + ';'
                                end;
                           CSV.Add(Line);
                           DataSet.Next;
                      end;
                  //---- Export au format CSV
                  CSV.SaveToFile(ASDFile.FileName);
            end;
     finally
        ASDFile.Free;
        CSV.DisposeOf;
     end;
end;

END.


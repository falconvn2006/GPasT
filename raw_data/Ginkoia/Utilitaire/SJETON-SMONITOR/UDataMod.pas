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
    FireDAC.Phys.SQLiteDef, FireDAC.Phys.IBDef, FireDAC.Stan.Util;

TYPE
    TDataMod = CLASS(TDataModule)
    FDConSQLite: TFDConnection;
    FDTransConnexion: TFDTransaction;
    FDSQLiteCollation1: TFDSQLiteCollation;
    FDConIB: TFDConnection;
    FDTransIB: TFDTransaction;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDScript1: TFDScript;
    PRIVATE
    { Déclarations privées }
    procedure Create_TABLE_SQLite_VJETON;
    procedure Create_TABLE_SQLite_VMONITOR;
    PUBLIC
    function ExecuteMyScript(AFilePath:string):Boolean;
    function GetVersionDBGinkoia():string;
    procedure CSVExport(DataSet:TDataSet);
    function IBProcedureExist(AProcedure : string):Boolean;
    procedure IBVMonitor;
    procedure SQLiteStartConnexion(DBFile:string;Const Readonly:Boolean=true);
    { Déclarations publiques }
    END;

VAR
    DataMod: TDataMod;

IMPLEMENTATION
{$R *.DFM}

Uses UCommun;


procedure TDataMod.Create_TABLE_SQLite_VMONITOR;
var SQuery:TFDQuery;
begin
      if DataMod.FDConSQLite.Connected then
        begin
             SQuery:=TFDQuery.Create(DataMod);
             try
                SQuery.Connection:=DataMod.FDConSQLite;
                // SQuery.close;
                // SQuery.SQL.Clear;
                // SQuery.SQL.text:='DROP TABLE IF EXISTS [VJETON];';
                // SQuery.ExecSQL;
                //--------------------------------------------------------------
                SQuery.close;
                SQuery.SQL.Clear;
                SQuery.SQL.text:=
                     'CREATE TABLE IF NOT EXISTS [VMONITOR] (' +
                     '[MON_ID] INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,' +
                     '[MON_DOSSIER] VARCHAR(63)  NULL,' +
                     '[MON_SERVER] VARCHAR(63)  NULL,' +
                     '[MON_DATABASE] VARCHAR(127)  NULL,' +
                     '[MON_LOGID] INTEGER NOT NULL,' +
                     '[MON_LASTWDPOST] TIMESTAMP  NULL)';
                SQuery.ExecSQL;
             Finally
               SQuery.Close;
               SQuery.Free;
             end;
        end;

end;


procedure TDataMod.Create_TABLE_SQLite_VJETON;
var SQuery:TFDQuery;
begin
      if DataMod.FDConSQLite.Connected then
        begin
             SQuery:=TFDQuery.Create(DataMod);
             try
                SQuery.Connection:=DataMod.FDConSQLite;
                // SQuery.close;
                // SQuery.SQL.Clear;
                // SQuery.SQL.text:='DROP TABLE IF EXISTS [VJETON];';
                // SQuery.ExecSQL;
                //--------------------------------------------------------------
                SQuery.close;
                SQuery.SQL.Clear;
                SQuery.SQL.text:=
                     'CREATE TABLE IF NOT EXISTS [VJETON] (' +
                     '[JET_ID] INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,' +
                     '[JET_SERVER] VARCHAR(63)  NULL,' +
                     '[JET_POSTE] VARCHAR(30)  NULL,' +
                     '[JET_DATEHEURE] TIMESTAMP  NULL,' +
                     '[JET_BASE] VARCHAR(63)  NULL,' +
                     '[JET_SENDER] VARCHAR(63)  NULL,' +
                     '[JET_DATABASE] VARCHAR(63)  NULL,' +
                     '[JET_DOSSIER] VARCHAR(63)  NULL,' +
                     '[JET_LASTWDPOST] TIMESTAMP  NULL,' +
                     '[JET_HRFLAG] BOOLEAN  NULL)';
                SQuery.ExecSQL;
             Finally
               SQuery.Close;
               SQuery.Free;
             end;
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
                // FDScript.SQLScriptFileName:='VMONITOR_LAST_REPLIC.sql';
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

function TDataMod.ExecuteMyScript(AFilePath:string):Boolean;
begin
     {
     If ConLiteConnexion.Connected
        then
            begin
                 UniScript1.Connection:=ConLiteConnexion;
                 UniScript1.SQL.LoadFromFile(AFilePath);
                 UniScript1.Execute;
                 UniScript1.Connection:=nil;
            end;
     }
     //
     result:=true;
end;


// C:\Developpement\Ginkoia\UTILITAIRE\SJETON-MONITOR\monitor.s3db

procedure TDataMod.SQLiteStartConnexion(DBFile:string;Const Readonly:Boolean=true);
var database:string;
begin
     Try
        database:='';
        if FileExists(DBFile) then
            database:=DBFile
        else
          if FileExists(VAR_GLOB.Exe_Directory + DBFile)
             then
                 database:=VAR_GLOB.Exe_Directory + DBFile;
        FDConSQLite.DriverName:='SQLite';
        FDConSQLite.Params.Clear;
        FDConSQLite.Params.Add('DriverID=SQLite');
        // Log_Write('database   : '+ database, el_Info);
        FDConSQLite.Params.Add(Format('Database=%s',[database]));
        FDConSQLite.Params.Add('StringFormat=UniCode');
        FDConSQLite.Params.Add('LockingMode=Normal');
        FDConSQLite.Params.Add('Database encoding=UTF8');
        FDConSQLite.open;
        If not(Readonly)
            then
                begin
                    Create_TABLE_SQLite_VJETON;
                    Create_TABLE_SQLite_VMONITOR;
                end;
    Finally

    End;
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
begin
     CSV := TStringList.Create;
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


    CSV.SaveToFile(VAR_GLOB.Exe_Directory+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.csv');
end;

END.


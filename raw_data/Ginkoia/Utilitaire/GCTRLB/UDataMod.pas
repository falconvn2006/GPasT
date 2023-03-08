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
  FireDAC.Stan.ExprFuncs;

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
    procedure DataModuleCreate(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    function ExecuteMyScript(AFilePath:string):Boolean;
    function GetVersionDBGinkoia():string;
    procedure CSVExport(DataSet:TDataSet);
    { Déclarations publiques }
    END;

VAR
    DataMod: TDataMod;

IMPLEMENTATION
{$R *.DFM}

Uses UCommun;

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


procedure TDataMod.DataModuleCreate(Sender: TObject);
begin
     Try
        If (Application.Title = 'Ginkoia Contrôle de la Base de données')
          then
              begin
                   FDConLiteGCTRLB.DriverName:='SQLite';
                   FDConLiteGCTRLB.Params.Clear;
                   FDConLiteGCTRLB.Params.Add('DriverID=SQLite');
                   FDConLiteGCTRLB.Params.Add('Database=' + ExtractFilePath(Application.ExeName) + 'GCTRLB.s3db');
                   FDConLiteGCTRLB.Params.Add('StringFormat=UniCode');
                   FDConLiteGCTRLB.Params.Add('Database encoding=UTF8');
                   FDConLiteGCTRLB.Open;
              end;

        FDConLiteConnexion.DriverName:='SQLite';
        FDConLiteConnexion.Params.Clear;
        FDConLiteConnexion.Params.Add('DriverID=SQLite');
        FDConLiteConnexion.Params.Add('Database=' + ExtractFilePath(Application.ExeName) + 'connexion.s3db');
        FDConLiteConnexion.Params.Add('StringFormat=UniCode');
        FDConLiteConnexion.Params.Add('Database encoding=UTF8');
        FDConLiteConnexion.open;

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


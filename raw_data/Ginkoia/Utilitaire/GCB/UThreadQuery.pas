unit UThreadQuery;

interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ComCtrls,  Grids,  DBGrids, Buttons, StdCtrls, DB, ExtCtrls,
  FireDAC.Stan.Intf,  FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS,  FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt,  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.UI.Intf,  FireDAC.Comp.ScriptCommands, FireDAC.Comp.Script, System.UITypes,
  FireDAC.Stan.Util,UDataMod;

const
  QUERY_TYPE_COUNT = 0;
  QUERY_TYPE_VALUE = 1;

type
  TThreadCorrige = class(TThread)
  private
    FOnAfterCorrige : TNotifyEvent;
    FScript  : TStringList;
    FNbErrors : integer;
    procedure DoAfterCorrige;
    procedure Corrige;
  protected
    procedure Execute; override;
  public
    constructor Create(AScript:TStringList;ANotifyEvent: TNotifyEvent);virtual;
    destructor Destroy;
    property NbErrors : integer read FnbErrors write FnbErrors;
  end;

  TLigneGrille = record
    ID          : integer;
    Checked     : Boolean;
    NBATTENDU   : integer;
    Comparateur : string;
    NbResultats : variant;
    Etat        : string;
  end;
  TGrille = array of TLigneGrille;
  TThreadScripts = class(TThread)
  private
    FGrille : TGrille;
    FI : integer;
    FOnAfterExecute : TNotifyEvent;
    FCSVPath : string;
    FDossier : string;
    procedure DoAfterExecute;
    function Analyse_Ligne(Asql:TStrings;aName:string;aExport:integer;aType:integer=QUERY_TYPE_COUNT):integer;
    procedure Boucle_Principale;
    procedure UpdateGrille;
    procedure CleanGrille;
    procedure Liberation;
    procedure Running;
  protected
    procedure Execute; override;
    procedure Export2CSV(aDataSet:TDataSet;aScriptName:string;aExport:integer);
  public
    constructor Create(AGrille:TGrille;ANotifyEvent: TNotifyEvent); virtual;
    destructor Destroy;
    property Grille  : TGrille read FGrille  Write FGrille;
    property CSVPath : string  read FCSVPath write FCSVPath;
    property Dossier : string  read FDossier write FDossier;
end;

implementation
{ TThreadQuery }

Uses Frm_Main, UCommun;

procedure TThreadCorrige.DoAfterCorrige;
begin
     if Assigned(FOnAfterCorrige) then
       FOnAfterCorrige(self);
end;

procedure TThreadCorrige.Execute;
begin
  try
    Corrige;
    Synchronize(DoAfterCorrige);
  except
    // ShowMessage('Query Error');
  end;
end;

destructor TThreadCorrige.Destroy;
begin
   FScript.Free;
   inherited;
end;

constructor TThreadCorrige.Create(AScript:TstringList;ANotifyEvent: TNotifyEvent);
begin
  inherited Create(True);
  FScript:=TStringList.Create;
  FScript.Text:=Ascript.Text;
  FOnAfterCorrige    := ANotifyEvent;
  FreeOnTerminate    := True;
end;

procedure TThreadCorrige.Corrige;
var // xSQL:TStringList;
    i:integer;
    BufferSQL:string;
    PScript:TFDScript;
    PQuery:TFDQuery;
begin
     PScript:=TFDScript.Create(DataMod);
     PScript.Connection:=DataMod.FDconIB;
     PScript.Transaction:=DataMod.FDtransIB;

     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconIB;
     PQuery.Transaction:=DataMod.FDtransIB;
     PQuery.Transaction.Options.ReadOnly:=False;
      NbErrors:=0;
     try

     for i:= 0 to FScript.Count - 1 do
        begin
             IF Pos('^', FScript.Strings[i]) = 0
                then BufferSQL := BufferSQL + #13 + #10 + FScript.Strings[i];
             IF Pos('^', FScript.Strings[i]) = 1
                then
                    begin
                         Try
                         if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                            then
                                begin
                                     PQuery.Close;
                                     PQuery.SQL.Clear;
                                     PQuery.SQL.Add(BufferSQL);
                                     PQuery.Prepare;
                                     PQuery.Open;
                                     PQuery.Close;
                                end
                            else if (Pos('EXECUTE PROCEDURE ', UPPERCASE(Trim(BufferSQL))) = 1 ) then
                              begin
                                     PQuery.Close;
                                     PQuery.SQL.Clear;
                                     PQuery.SQL.Add(BufferSQL);
                                     PQuery.Prepare;
                                     PQuery.ExecSQL;
                              end
                              else
                                begin
                                     PScript.SQLScripts.Clear;
                                     PScript.SQLScripts.Add;
                                     PScript.SQLScripts[0].SQL.Add(BufferSQL);
                                     PScript.ValidateAll;
                                     PScript.ExecuteAll;
                                end;
                         BufferSQL:='';
                          Except On Ez : Exception do
                            begin
                                 inc(FNbErrors);
                            end;
                           end;
                    End;
        end;
     Finally
        PQuery.Close;
        PQuery.Free;
        PScript.Free;
     end;
end;

procedure TThreadScripts.DoAfterExecute;
begin
     try
        if Assigned(FOnAfterExecute) then
           FOnAfterExecute(self);
     Except

     end;
end;

procedure TThreadScripts.CleanGrille;
var i:integer;
begin
    Main_Frm.Pbar.Position:=0;
    Main_Frm.Pbar.Max:=High(Grille);
    Main_Frm.Pbar.Visible:=true;
    for i := 0 to High(Grille) do
       begin
            if (Main_Frm.FDMemTable.Locate('ID',Grille[i].ID,[]))
              then
                 begin
                    Main_Frm.FDMemTable.Edit;
                    Main_Frm.FDMemTable.FieldByName('ETAT').asstring := '';
                    Main_Frm.FDMemTable.FieldByName('NBREEL').value := null;
                    Main_Frm.FDMemTable.Post;
                    Main_Frm.gridGeneral.Refresh;
                 end;
       end;
end;

procedure TThreadScripts.Running;
begin
    if (Main_Frm.FDMemTable.Locate('ID',Grille[fi].ID,[]))
      then
        begin
            Main_Frm.FDMemTable.Edit;
            Main_Frm.FDMemTable.FieldByName('ETAT').asstring := 'En Cours';
            Main_Frm.FDMemTable.Post;
            Main_Frm.gridGeneral.Refresh;
        end;
end;

procedure TThreadScripts.UpdateGrille;
begin
    if (Main_Frm.FDMemTable.Locate('ID',Grille[fi].ID,[]))
      then
        begin
            Main_Frm.Pbar.Position:=Fi+1;
            Main_Frm.Pbar.Refresh;
            Main_Frm.FDMemTable.Edit;
            Main_Frm.FDMemTable.FieldByName('ETAT').asstring := Grille[FI].Etat;
            Main_Frm.FDMemTable.FieldByName('NBREEL').value  := Grille[FI].NbResultats;
            Main_Frm.FDMemTable.Post;
            Main_Frm.gridGeneral.Refresh;
        end;
end;

procedure TThreadScripts.Liberation;
begin
    Main_Frm.CanClose:=true;
end;


procedure TThreadScripts.Boucle_Principale;
var xSQL:TStringList;
    xName:string;
    xType:integer;
    xExport : integer;
    SQuery:TFDQuery;
    i:integer;
    BufferSQL:string;
begin
     xSQL:=TStringList.Create;
     SQuery:=TFDQuery.Create(DataMod);
     Synchronize(CleanGrille);
     try
        SQuery.Connection:=DataMod.FDconliteGCTRLB;
        for i := 0 to High(Grille) do
          begin
               Fi:=i;
               if (Grille[i].Checked)
                  then
                      begin
                           try
                              Grille[i].ETAT:='En cours';
                              Synchronize(Running);
                              SQuery.Close;
                              SQuery.SQL.Clear;
                              SQuery.SQL.Add('SELECT SCT_QUERY, SCT_NOM, SCT_TYPE, SCT_EXPORT FROM SCRCTRL WHERE SCT_ID=:ID');
                              SQuery.ParamByName('ID').AsInteger:=Grille[i].ID;
                              SQuery.Prepare;
                              SQuery.Open;
                              xName := SQuery.FieldByName('SCT_NOM').Value;
                              if SQuery.FieldByName('SCT_TYPE').AsInteger = QUERY_TYPE_VALUE
                                  then xType := QUERY_TYPE_VALUE
                                  else xType := QUERY_TYPE_COUNT;
                              xSQL.Clear;
                              xSQL.Text:=SQuery.FieldByName('SCT_QUERY').Value;
                              xSQL.Add('^');
                              xExport := SQuery.FieldByName('SCT_EXPORT').AsInteger;
                              Grille[i].NbResultats := Analyse_Ligne(xSQL, xName, xExport, xType);
                              if (Grille[i].Comparateur='=') then
                                  if (Grille[i].NbResultats=Grille[i].NBATTENDU)
                                    then Grille[i].ETAT:='OK'
                                    else Grille[i].ETAT:='Erreur';
                              if (Grille[i].Comparateur='<') then
                                  if (Grille[i].NbResultats<Grille[i].NBATTENDU)
                                    then Grille[i].ETAT:='OK'
                                    else Grille[i].ETAT:='Erreur';
                              if (Grille[i].Comparateur='<=') then
                                  if (Grille[i].NbResultats<=Grille[i].NBATTENDU)
                                    then Grille[i].ETAT:='OK'
                                    else Grille[i].ETAT:='Erreur';
                              if (Grille[i].Comparateur='>') then
                                  if (Grille[i].NbResultats>Grille[i].NBATTENDU)
                                    then Grille[i].ETAT:='OK'
                                    else Grille[i].ETAT:='Erreur';
                              if (Grille[i].Comparateur='>=') then
                                  if (Grille[i].NbResultats>=Grille[i].NBATTENDU)
                                    then Grille[i].ETAT:='OK'
                                    else Grille[i].ETAT:='Erreur';
                           Except


                           end;
                      end
                  else // Nettoyage des non cochées
                      begin
                           Grille[i].NbResultats:=null;
                           Grille[i].ETAT:='';
                      end;
               Synchronize(UpdateGrille);
          end;
     Finally
        Synchronize(Liberation);
        SQuery.Close;
        SQuery.Free;
        xSQL.Free;
     end;
end;


procedure TThreadScripts.Export2CSV(aDataSet:TDataSet;aScriptName:string;aExport:integer);
var i: Integer;
    OutLine: string;
    sTemp: string;
    vFileName :string;
    vScriptName : string;
    vLineBreak : string;
    vDatas : TStringList;
begin
  if aExport<>1 then exit;
  if CSVPath = '' then
    exit;
  if aExport = 1 then
  begin
    if not DirectoryExists(CSVPath) then
      if not CreateDir(CSVPath) then
        exit;
  end;
  vScriptName := CleanFileName(aScriptName);
  vLineBreak  := #13+#10;
  vFileName := CSVPath + '/' + Dossier + '_' + vScriptName + '_' + FormatDateTime('yyymmdd_hhnnsszzz',Now()) + '.csv';
  vDatas := TStringList.Create;
  try
    if not aDataSet.Eof then
    begin
      for i := 0 to aDataSet.FieldCount - 1 do
      begin
        sTemp := aDataSet.Fields[i].FieldName;
        if i<aDataSet.FieldCount - 1
          then OutLine := OutLine + sTemp + ';'
          else OutLine := OutLine + sTemp;
      end;
      vDatas.Add(Outline);
      while not aDataSet.Eof do
      begin
        // You'll need to add your special handling here where OutLine is built
        OutLine := '';
        for i := 0 to aDataSet.FieldCount - 1 do
        begin
          sTemp := aDataSet.Fields[i].AsString;
          // Special handling to sTemp here
          if i<aDataSet.FieldCount - 1
            then OutLine := OutLine + sTemp + ';'
            else OutLine := OutLine + sTemp;
        end;
        // Write line ending
        vDatas.Add(Outline);
        aDataSet.Next;
      end;
      vDatas.SaveToFile(vFileName);
    end;
  finally
    vDatas.Free;  // Saves the file
  end;
end;


function TThreadScripts.Analyse_Ligne(Asql:TStrings;aName:string;aExport:integer;aType:integer):integer;
var PScript:TFDScript;
    PQuery:TFDQuery;
    i:integer;
    BufferSQL:string;
begin
     result:=-1;
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconIB;
     PQuery.Transaction:=DataMod.FDtransIB;

     PScript:=TFDScript.Create(DataMod);
     PScript.Connection:=DataMod.FDconIB;
     PScript.Transaction:=DataMod.FDtransIB;

     try
        for i:= 0 to Asql.Count-1 do
          begin
               IF Pos('^',  Asql.Strings[i]) = 0
                  then BufferSQL := BufferSQL + #13 + #10 + Asql.Strings[i];
               IF Pos('^',  Asql.Strings[i]) = 1
                  then
                      begin
                           Try
                           if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                              then
                                  begin
                                       PQuery.Close;
                                       PQuery.SQL.Clear;
                                       PQuery.SQL.Add(BufferSQL);
                                       PQuery.Prepare;
//                                       PQuery.FetchOptions.
                                       PQuery.Open;
                                       case aType of
                                         QUERY_TYPE_COUNT : result:=PQuery.RecordCount;
                                         QUERY_TYPE_VALUE : result:=PQuery.Fields[0].AsInteger;
                                       end;
                                       // Si on a l'option ecrire les resultats
                                       // il faut faire le CSV
                                       Export2CSV(PQuery, aName, aExport);
                                       PQuery.Close;
                                  end
                              else
                                  begin
                                       PScript.SQLScripts.Clear;
                                       PScript.SQLScripts.Add;
                                       PScript.SQLScripts[0].SQL.Add(BufferSQL);
                                       PScript.ValidateAll;
                                       PScript.ExecuteAll;
                                  end;
                            BufferSQL:='';
                            Except On Ez : Exception do
                              begin
                           //        MessageDlg(Ez.Message, mtError, [mbOK], 0);
                              end;
                             end;
                      End;
              // Synchronize(UpdateGrille);
          end;
     finally
       PQuery.Free;
       PScript.Free;
     end;
end;



procedure TThreadScripts.Execute;
begin
  try
    FreeOnTerminate    := True;
    Boucle_Principale;
    Synchronize(DoAfterExecute);
  except
    // ShowMessage('Error');
  end;
end;

destructor TThreadScripts.Destroy;
begin
     inherited;
end;

constructor TThreadScripts.Create(Agrille:TGrille;ANotifyEvent: TNotifyEvent);
begin
  inherited Create(True);
  FCSVPath           := '';
  FDossier           := '';
  FGrille            := Agrille;
  FOnAfterExecute    := ANotifyEvent;
  FreeOnTerminate    := True;
end;



end.

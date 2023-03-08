unit frm_details;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ComCtrls,  Grids,
  DBGrids, Buttons, StdCtrls, DB, ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Comp.ScriptCommands, FireDAC.Comp.Script, System.UITypes,
  FireDAC.Stan.Util,UThreadQuery;

type
  TForm_Details = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    spl1: TSplitter;
    dsliste: TDataSource;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    pnl_reccount: TPanel;
    lbl_TypeRes: TLabel;
    pnl_attendu: TPanel;
    dbgrd1: TDBGrid;
    mInfos: TMemo;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    Btn_2: TBitBtn;
    BCORRECTION: TBitBtn;
    mscript: TMemo;
    mcorrection: TMemo;
    Qliste: TFDQuery;
    FDScript1: TFDScript;
    BExport: TBitBtn;
    procedure Btn_2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BCORRECTIONClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure MyEvent(Sender:Tobject);
    procedure CallBackThread(Sender:Tobject);
    procedure BCORRECTION_2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dbgrd1TitleClick(Column: TColumn);
  private
    { Déclarations privées }
    FColumnIndex : integer;
    SCTLEVEL:Integer;
    SCTSOLUTION : TStringList;
    SCTNBRESULT : Integer;
    SCTTYPE     : Integer;

    FCanClose   : Boolean;
    procedure Corrige_par_Thread;
  public
    { Déclarations publiques }
    STCID:integer;
    procedure Load;
    procedure ParamEcranRequeteur;
  end;

var
  Form_Details: TForm_Details;

implementation

{$R *.dfm}

USes UCommun,UDataMod, Frm_Main;


procedure TForm_Details.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     SCTSOLUTION.Free;
end;

procedure TForm_Details.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose:=FCanClose;
end;

procedure TForm_Details.FormCreate(Sender: TObject);
begin
     FColumnIndex := -1;
     FCanClose:=true;
     BCORRECTION.Visible:=false;
end;

procedure TForm_Details.ParamEcranRequeteur;
begin
    if (STCID<0) then
      begin
           mscript.ReadOnly:=false;
           mscript.Color:=clWindow;
           pgc1.ActivePageIndex:=0;
           ts3.TabVisible:=false;
           ts2.TabVisible:=false;
      end;
end;

procedure TForm_Details.Load;
var SQuery:TFDQuery;
begin
     SQuery:=TFDQuery.Create(DataMod);
     try
       SQuery.Connection:=DataMod.FDconliteGCTRLB;
       SQuery.Close;
       SQuery.SQL.Clear;
       SQuery.SQL.Add('SELECT SCT_QUERY, SCT_SOLUTION, SCT_INFO, SCT_ERROR, SCT_NBRESULT, SCT_TYPE FROM SCRCTRL WHERE SCT_ID=:ID');
       SQuery.ParamByName('ID').AsInteger:=STCID;
       SQuery.Prepare;
       SQuery.Open;
       mscript.Text := SQuery.FieldByName('SCT_QUERY').AsString;
       mscript.Lines.Add('^');
       mInfos.Text:=SQuery.FieldByName('SCT_INFO').AsString;
       SCTTYPE := SQuery.FieldByName('SCT_TYPE').AsInteger;
       case SCTTYPE of
         QUERY_TYPE_COUNT : lbl_TypeRes.Caption := 'Nbr Attendu : ';
         QUERY_TYPE_VALUE : lbl_TypeRes.Caption := 'Valeur Attendu : ';
       end;
       mcorrection.Text:=SQuery.FieldByName('SCT_SOLUTION').AsString;
       SCTSOLUTION := TStringList.Create;
       SCTSOLUTION.Text:='';
       if (SQuery.FieldByName('SCT_SOLUTION').AsString<>'')
          then
              begin
                   SCTSOLUTION.Add(SQuery.FieldByName('SCT_SOLUTION').AsString);
              end;
       SCTLEVEL:=SQuery.FieldByName('SCT_ERROR').Asinteger;
       SCTNBRESULT:=SQuery.FieldByName('SCT_NBRESULT').Asinteger;
       pnl_attendu.Caption:=Format('%d',[SCTNBRESULT]);
     finally
       SQuery.Close;
       SQuery.Free;
     end;
end;

procedure TForm_Details.MyEvent(Sender:Tobject);
begin
    try
      //  If (TThreadQuery(Sender)) then
         begin

         end;
    finally
      //
    end;
end;

procedure TForm_Details.Corrige_par_Thread;
var AThreadCorrige:TThreadCorrige;
begin
     SCTSOLUTION.Text:=Trim(SCTSOLUTION.Text);
     AThreadCorrige:=TThreadCorrige.Create(SCTSOLUTION,CallBackThread);
     AThreadCorrige.Resume;
end;

procedure TForm_Details.dbgrd1TitleClick(Column: TColumn);
begin
  if DBGrd1.DataSource.DataSet is TDataSet then
  with TFDQuery(DBGrd1.DataSource.DataSet) do
  begin
    If FColumnIndex>=0 then
      DBGrd1.Columns[FColumnIndex].title.Font.Style :=
      DBGrd1.Columns[FColumnIndex].title.Font.Style - [fsBold];

    Column.title.Font.Style := Column.title.Font.Style + [fsBold];
    if (FColumnIndex=Column.Index)
      then
          begin
              if IndexFieldNames = Column.FieldName+':A' then
                 IndexFieldNames := Column.FieldName+':D'
              else
                IndexFieldNames := Column.FieldName+':A';
          end
      else IndexFieldNames := Column.FieldName+':A';
    FColumnIndex := Column.Index;
  end;
end;

procedure TForm_Details.CallBackThread(Sender:Tobject);
begin
    try
      If TThreadCorrige(Sender).NbErrors=0
          then MessageDlg('La correction a été appliquée.', mtInformation, [mbOK], 0)
          else MessageDlg('Erreur lors de la correction.', mtError, [mbOK], 0);
    Except
      //
    end;
end;

procedure TForm_Details.BCORRECTION_2Click(Sender: TObject);
var BufferSQL: STRING;
    NbError:integer;
    hSysMenu:HMENU;
begin
     case SCTLEVEL of
        0:if (MessageBox(0, 'Voulez-vous appliquer la correction ?', 'Confirmation',MB_ICONINFORMATION or MB_YESNO or MB_DEFBUTTON1) <> idYes) then Exit;
        1:if (MessageBox(0, 'Voulez-vous appliquer la correction ?', 'Attention', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> idYes) then Exit;
        else
          if (MessageBox(0, 'Mode Expérimental !'+#13+#10+'Vous ne devriez peut-être pas appliquer la correction !' +#13+#10+ 'Voulez-vous quand même appliquer la correction malgré tous ces avertissements ?', 'Attention', MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2) <> idYes) then Exit;
     end;
    Corrige_par_Thread;
end;

procedure TForm_Details.BCORRECTIONClick(Sender: TObject);
var BufferSQL: STRING;
    i:integer;
    PScript:TFDScript;
    PQuery:TFDQuery;
    NbError:integer;
    hSysMenu:HMENU;
//    AThreadQuery:TThreadQuery;
begin
     {
     // Mesures de sécurité !
     if (Main_Frm.UserLevel=ServiceClient) then
        begin
             MessageBox(0,
               'Vous ne pouvez pas appliquer de correction.' + #13#10
                + 'Veuillez demander au Service Developpement.','Erreur',
               MB_ICONERROR or MB_OK);
             Exit;
        end;
     }
     case SCTLEVEL of
        0:if (MessageBox(0, 'Voulez-vous appliquer la correction ?', 'Confirmation',MB_ICONINFORMATION or MB_YESNO or MB_DEFBUTTON1) <> idYes) then Exit;
        1:if (MessageBox(0, 'Voulez-vous appliquer la correction ?', 'Attention', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> idYes) then Exit;
        else
          if (MessageBox(0, 'Mode Expérimental !'+#13+#10+'Vous ne devriez peut-être pas appliquer la correction !' +#13+#10+ 'Voulez-vous quand même appliquer la correction malgré tous ces avertissements ?', 'Attention', MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2) <> idYes) then Exit;
     end;
     Qliste.Close;
     BCORRECTION.Visible:=false;
     Btn_2.Enabled:=false;
     BExport.Enabled:=false;
     SCTSOLUTION.Text:=Trim(SCTSOLUTION.Text);
     BufferSQL:='';

     Screen.Cursor:=CrHourGlass;
     FCanClose:=false;


     {
     PQuery:=TIBScript.Create(self);
     PQuery.Database:=Ib.IBDB;
     PQuery.Transaction:=Ib.IBTransaction;
     for i:= 0 to SCTSOLUTION.Count - 1 do
        begin
             IF Pos('^', SCTSOLUTION.Strings[i]) = 0
                then BufferSQL := BufferSQL + #13 + #10 + SCTSOLUTION.Strings[i];
             IF Pos('^', SCTSOLUTION.Strings[i]) = 1
                then
                    begin
                         PQuery.Script.Clear;
                         PQuery.Script.Add(BufferSQL);
                         // MessageDlg(BufferSQL, mtWarning, [mbOK], 0);
                         BufferSQL:='';
                         PQuery.ExecuteScript;
                         PQuery.Script.Clear;
                         PQuery.Script.Add('COMMIT;');
                         PQuery.ExecuteScript;
                    end;
        end;
     PQuery.Free;
     }
     PScript:=TFDScript.Create(self);
     PScript.Connection:=DataMod.FDconIB;
     PScript.Transaction:=DataMod.FDtransIB;

     PQuery:=TFDQuery.Create(self);
     PQuery.Connection:=DataMod.FDconIB;
     PQuery.Transaction:=DataMod.FDtransIB;
     PQuery.Transaction.Options.ReadOnly:=False;

     NbError:=0;
     for i:= 0 to SCTSOLUTION.Count - 1 do
        begin
             IF Pos('^', SCTSOLUTION.Strings[i]) = 0
                then BufferSQL := BufferSQL + #13 + #10 + SCTSOLUTION.Strings[i];
             IF Pos('^', SCTSOLUTION.Strings[i]) = 1
                then
                    begin
                         Try
                         if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                            then
                                begin
                                     // AThreadQuery:=TThreadQuery.Create(BufferSQL,MyEvent);
                                     // AThreadQuery.Resume;
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
                                     // MessageDlg('toto:' + BufferSQL, mtWarning, [mbOK], 0);
                                     PQuery.Prepare;
                                     PQuery.ExecSQL;
                                     // PQuery.Connection.Commit;
                              end
                              else
                                begin
                                     PScript.SQLScripts.Clear;
                                     PScript.SQLScripts.Add;
                                     // MessageDlg('toto:' + BufferSQL, mtWarning, [mbOK], 0);
                                     PScript.SQLScripts[0].SQL.Add(BufferSQL);
                                     PScript.ValidateAll;
                                     PScript.ExecuteAll;
                                     // PScript.Connection.Commit;
                                end;
                         BufferSQL:='';
                         // MessageDlg(BufferSQL, mtWarning, [mbOK], 0);
                         //-----
                         // PScript.SQLScripts.Clear;
                         // PScript.SQLScripts.Add;
                         // PScript.SQLScripts[0].SQL.Add('COMMIT;');
                         // PScript.ValidateAll;
                         // PScript.ExecuteAll;
                          Except On Ez : Exception do
                            begin
                                 MessageDlg(Ez.Message, mtError, [mbOK], 0);
                                 Inc(NbError);
                            end;
                           end;
                    End;
        end;
     PQuery.Close;
     PQuery.Free;
     PScript.Free;
     If NbError=0
        then MessageDlg('La correction a été appliquée.', mtInformation, [mbOK], 0)
        else MessageDlg('Erreur lors de la correction.', mtError, [mbOK], 0);

     Screen.Cursor:=CrDefault;
     FCanClose:=true;
     Btn_2.Enabled   := true;
     BExport.Enabled := true;
end;

procedure TForm_Details.BExportClick(Sender: TObject);
begin
     try
        Qliste.DisableControls;
        DataMod.CSVExport(Qliste);
     finally
        Qliste.EnableControls;
     end;
end;

procedure TForm_Details.Btn_2Click(Sender: TObject);
var  hSysMenu:HMENU;
     i:integer;
     BufferSQL: STRING;
     PScript:TFDScript;
begin
     Btn_2.Enabled:=False;
     BExport.Enabled:=False;

     Screen.Cursor:=CrHourGlass;
     FCanClose:=False;

     PScript:=TFDScript.Create(self);
     try
        PScript.Connection:=DataMod.FDconIB;
        PScript.Transaction:=DataMod.FDtransIB;
        for i:= 0 to mscript.Lines.Count-1 do
            begin
                 IF Pos('^', mscript.Lines[i]) = 0
                    then BufferSQL := BufferSQL + #13 + #10 + mscript.Lines[i];
                 IF Pos('^', mscript.Lines[i]) = 1
                    then
                        begin
                             Try
                             if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                                then
                                    begin
                                         Qliste.Close;
                                         Qliste.SQL.Clear;
                                         Qliste.SQL.Add(BufferSQL);
                                         Qliste.Prepare;
    //                                     Qliste.Options.QueryRecCount:=True;
                                         Qliste.Prepare;
                                         Qliste.Open;
                                         BCORRECTION.Visible:= (STCID>0) and (SCTNBRESULT<>Qliste.RecordCount) and (Trim(SCTSOLUTION.Text)<>'');
                                         case SCTTYPE of
                                           QUERY_TYPE_COUNT : pnl_reccount.Caption:=Format('%d',[Qliste.RecordCount]);
                                           QUERY_TYPE_VALUE : pnl_reccount.Caption:=Format('%d',[Qliste.Fields[0].AsInteger]);
                                         end;
                                    end
                                else
                                    begin
                                         PScript.SQLScripts.Clear;
                                         PScript.SQLScripts.Add;
                                         PScript.SQLScripts[0].SQL.Add(BufferSQL);
                                         PScript.ValidateAll;
                                         PScript.ExecuteAll;
                                    end;
                             // MessageDlg(BufferSQL, mtWarning, [mbOK], 0);
                             //-----
                             BufferSQL:='';
                             {
                             PScript.SQLScripts.Clear;
                             PScript.SQLScripts.Add;
                             PScript.SQLScripts[0].SQL.Add('COMMIT;');
                             PScript.ValidateAll;
                             PScript.ExecuteAll;
                             }
                              Except On Ez : Exception do
                                begin
                                     MessageDlg(Ez.Message, mtError, [mbOK], 0);
                                end;
                               end;
                        End;
            end;
     finally
        FreeAndNil(PScript);
     end;

     dbgrd1.DataSource:=dsliste;

     Btn_2.Enabled:=true;
     BExport.Enabled:=true;

     Screen.Cursor:=CrDefault;
     FCanClose:=True;
end;

end.

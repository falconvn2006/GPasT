unit DossierLame_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.ExtCtrls,System.RegularExpressionsCore, Vcl.Buttons,
  Vcl.Menus;

type
  TFrm_DossierLame = class(TForm)
    Label1: TLabel;
    edtBASE: TEdit;
    Label2: TLabel;
    edtNOM: TEdit;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    mt_KTB: TFDMemTable;
    mt_KTBTABLE_NAME: TStringField;
    mt_KTBPRIMARY_KEY: TStringField;
    dsDELOS_KTB: TDataSource;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    dbGrid_KTB: TDBGrid;
    FDMemTable2: TFDMemTable;
    StringField1: TStringField;
    StringField2: TStringField;
    DataSource2: TDataSource;
    GroupBox3: TGroupBox;
    DBGrid3: TDBGrid;
    FDMemTable3: TFDMemTable;
    StringField3: TStringField;
    DataSource3: TDataSource;
    FDMemTable3TABLE_TYPE: TStringField;
    lblVersion: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    lbl_Total1: TLabel;
    lbl_Total2: TLabel;
    lbl_Total3: TLabel;
    TabSheet3: TTabSheet;
    BCREATEGAP: TButton;
    BDectectGAP: TButton;
    DBGrid4: TDBGrid;
    FDMemGAP: TFDMemTable;
    FDMemGAPNODEID: TStringField;
    FDMemGAPDECLARED_DATAID: TLargeintField;
    FDMemGAPRECORDED_DATAID: TLargeintField;
    FDMemGAPNBRECORDS: TIntegerField;
    FDMemGAPNBPASSE: TIntegerField;
    FDMemGAPETAT: TStringField;
    dsGAP: TDataSource;
    Panel5: TPanel;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    AjouterTablelarplication1: TMenuItem;
    Label3: TLabel;
    TabSheet1: TTabSheet;
    Panel6: TPanel;
    Panel7: TPanel;
    GroupBox4: TGroupBox;
    Panel8: TPanel;
    Label4: TLabel;
    GroupBox5: TGroupBox;
    Panel9: TPanel;
    Label5: TLabel;
    TabSheet4: TTabSheet;
    GroupBox6: TGroupBox;
    DBGrid2: TDBGrid;
    Panel10: TPanel;
    lbl_TOTAL_ALL: TLabel;
    mtALL: TFDMemTable;
    TABLE_NAME: TStringField;
    PRIMARY_KEY: TStringField;
    mtALLSYNC_KEY_NAMES: TStringField;
    dsALL: TDataSource;
    DBGrid5: TDBGrid;
    mtCASH: TFDMemTable;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    dsCASH: TDataSource;
    mtEASYSUP: TFDMemTable;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    dsEASYSUP: TDataSource;
    DBGrid6: TDBGrid;
//    procedure BCREATEGAPClick(Sender: TObject);
//    procedure BDectectGAPClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
    procedure AjouterTablelarplication1Click(Sender: TObject);
  private
    { Déclarations privées }
    FIBFile  : string;
    procedure Actualiser();
    procedure SetIBFile(Avalue:string);
  public
    { Déclarations publiques }
    property IBFile      : string read FIBFile    write SetIBFile;
  end;

var
  Frm_DossierLame: TFrm_DossierLame;

implementation

{$R *.dfm}

Uses UCommun, uDataMod;

procedure TFrm_DossierLame.AjouterTablelarplication1Click(Sender: TObject);
var i:Integer;
  vTableName : string;
  vKeyField  : string;
begin
  if DBGrid3.SelectedRows.Count > 0 then
     begin
       with DBGrid3.DataSource.DataSet do
         begin
             for i := 0 to DBGrid3.SelectedRows.Count-1 do
               begin
                  // Berlin
                  (* GotoBookmark(Pointer(DBGrid3.SelectedRows.Items[i])); *)
                  // Rio
                  GotoBookmark(DBGrid3.SelectedRows.Items[i]);
                  vTableName := FDMemTable2.FieldByName('TABLE_NAME').asstring;
                  vKEYFIELD  := FDMemTable2.FieldByName('PRIMARY_KEY').asstring;
                  DataMod.MAJ_Ajoute_TABLE_REPLIC(edtBASE.Text,vTABLENAME,vKEYFIELD);
               end;
         end;
       Actualiser();
     end
end;

{
procedure TFrm_DossierLame.BCREATEGAPClick(Sender: TObject);
var vSQL:TStringList;
    vResSQL : TResourceStream;
    vFileSQL : TFileName;
begin
  BCREATEGAP.Enabled :=false;
  vSQL := TStringList.Create();
  try
    vFileSQL := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'gap.sql';
    try
      vResSQL := TResourceStream.Create(HInstance, 'gap', RT_RCDATA);
      try
        vResSQL.SaveToFile(vFileSQL);
      finally
        vResSQL.Free();
      end;
    except
       on e: Exception do
       begin
         Exit;
       end;
    end;
    if FileExists(vFileSQL) then
      begin
        vSQL.LoadFromFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'gap.sql');
        DataMod.ExecuteScript(IBFile,vSQL);
      end;
  finally
    BCREATEGAP.Enabled  := not(DataMod.IsGAPDefined(IBFile));
    BDectectGAP.Enabled := not(BCREATEGAP.Enabled);
    vSQL.DisposeOf;
  end;
end;

procedure TFrm_DossierLame.BDectectGAPClick(Sender: TObject);
begin
    if not(BCREATEGAP.Enabled)
       then DataMod.DetectGAP(IBFile,TDataSet(FDMemGAP));
end;

procedure TFrm_DossierLame.Button1Click(Sender: TObject);
begin
   DataMod.DoGap(edtBASE.Text);
end;
}

procedure TFrm_DossierLame.Actualiser();
var vValue : string;
begin
    vValue := edtBASE.Text;

    lblVersion.Caption := Format('Version : %s',[DataMod.GetGinkoiaVersion(vvalue)]);
    edtNom.Text := DataMod.GetNomPourNous(vvalue);

    DataMod.GetAllTablesReplicantes(vValue,TDataSet(mtALL));
    DataMod.GetCASHTablesReplicantes(vValue,TDataSet(mtCASH));
    DataMod.GetEASYTablesSuppReplicantes(vValue,TDataSet(mtEASYSUP));


    DataMod.GetTablesReplicantes(vValue,TDataSet(mt_KTB));
    DataMod.GetTablesExclues(vValue,TDataSet(FDMemTable2));
    DataMod.GetAllTablesExclues(vValue,TDataSet(FDMemTable3));
    //
    BCREATEGAP.Enabled := not(DataMod.IsGAPDefined(vValue));
    if not(BCREATEGAP.Enabled)
      then DataMod.DetectGAP(vvalue,TDataSet(FDMemGAP));
    BDectectGAP.Enabled := not(BCREATEGAP.Enabled);
    label5.Caption := Format('Total : %d',[mtCASH.RecordCount]);
    label4.Caption := Format('Total : %d',[mtEASYSUP.RecordCount]);
    lbl_TOTAL_ALL.Caption := Format('Total : %d',[mtALL.RecordCount]);
    lbl_Total1.Caption := Format('Total : %d',[mt_KTB.RecordCount]);
    lbl_Total2.Caption := Format('Total : %d',[FDMemTable2.RecordCount]);
    lbl_Total3.Caption := Format('Total : %d',[FDMemTable3.RecordCount]);
end;


procedure TFrm_DossierLame.SetIBFile(Avalue:string);
var i:integer;
begin
     FIBFile:=AValue;
     edtBASE.Text:=AValue;
     try
       Actualiser();
       {
       lblVersion.Caption := Format('Version : %s',[DataMod.GetGinkoiaVersion(Avalue)]);
       edtNom.Text := DataMod.GetNomPourNous(Avalue);

       DataMod.GetAllTablesReplicantes(AValue,TDataSet(mtALL));
       DataMod.GetCASHTablesReplicantes(AValue,TDataSet(mtCASH));
       DataMod.GetEASYTablesSuppReplicantes(AValue,TDataSet(mtEASYSUP));


       DataMod.GetTablesReplicantes(AValue,TDataSet(mt_KTB));
       DataMod.GetTablesExclues(AValue,TDataSet(FDMemTable2));
       DataMod.GetAllTablesExclues(AValue,TDataSet(FDMemTable3));
       //
       BCREATEGAP.Enabled := not(DataMod.IsGAPDefined(AValue));
       if not(BCREATEGAP.Enabled)
          then DataMod.DetectGAP(Avalue,TDataSet(FDMemGAP));
       BDectectGAP.Enabled := not(BCREATEGAP.Enabled);
       label5.Caption := Format('Total : %d',[mtCASH.RecordCount]);
       label4.Caption := Format('Total : %d',[mtEASYSUP.RecordCount]);
       lbl_TOTAL_ALL.Caption := Format('Total : %d',[mtALL.RecordCount]);
       lbl_Total1.Caption := Format('Total : %d',[mt_KTB.RecordCount]);
       lbl_Total2.Caption := Format('Total : %d',[FDMemTable2.RecordCount]);
       lbl_Total3.Caption := Format('Total : %d',[FDMemTable3.RecordCount]);
       }
     finally


     end;
end;

end.

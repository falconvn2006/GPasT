unit KManquants_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls,
  DB,
  ComCtrls, Buttons, Grids, DBGrids, DateUtils,Math,
  DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.Phys.IB, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TPlage=record
   Debut:int64;
   Fin:int64;
  end;
  TForm_KMANQUANTS = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    pnl2: TPanel;

    dsliste: TDataSource;
    spl1: TSplitter;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    grp1: TGroupBox;
    mm1: TMainMenu;
    Fichier1: TMenuItem;
    Aide1: TMenuItem;
    Misejour1: TMenuItem;
    Quiter1: TMenuItem;
//    de_INSERTED_FIN: TDateTimePicker;
    lbl10: TLabel;
    BANALYSE: TBitBtn;
    de_INSERTED_DEBUT: TDateTimePicker;
    de_INSERTED_FIN: TDateTimePicker;
    mmo1: TMemo;
    te_BAS_IDENT: TEdit;
    te_SERVPLAGE: TEdit;
    te_LAMEPLAGE: TEdit;
    te_LAME_BASIDENT: TEdit;
    teSERVER: TEdit;
    teDatabaseFile: TEdit;
    BitBtn1: TBitBtn;
    mscript: TMemo;
    pgcntrl1: TPageControl;
    ts1: TTabSheet;
    tsKMANQUANTS: TTabSheet;
    g1: TDBGrid;
    Pan_: TPanel;
    Pan_1: TPanel;
    Pnl_count: TPanel;
    TabSheet1: TTabSheet;
    cdsRestant: TClientDataSet;
    cdsRestantBAS_IDENT: TStringField;
    cdsRestantTRANCHE: TStringField;
    dsRESTANT: TDataSource;
    DBGrid1: TDBGrid;
    BitBtn2: TBitBtn;
    cdsRestantBAS_SENDER: TStringField;
    cdsRestantTAUXOCCUPATION: TFloatField;
    cdsRestantRESTE: TLargeintField;
    cdsRestantTRANCHE_DEBUT: TLargeintField;
    cdsRestantTRANCHE_FIN: TLargeintField;
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    FDConIB: TFDConnection;
    FDQliste: TFDQuery;
    FDTransIB: TFDTransaction;
    FDQlisteKTB_NAME: TStringField;
    FDQlisteK_ID: TIntegerField;
    FDQlisteKRH_ID: TIntegerField;
    FDQlisteKTB_ID: TIntegerField;
    FDQlisteK_VERSION: TIntegerField;
    FDQlisteK_ENABLED: TIntegerField;
    FDQlisteKSE_OWNER_ID: TIntegerField;
    FDQlisteKSE_INSERT_ID: TIntegerField;
    FDQlisteK_INSERTED: TSQLTimeStampField;
    FDQlisteKSE_DELETE_ID: TIntegerField;
    FDQlisteK_DELETED: TSQLTimeStampField;
    FDQlisteKSE_UPDATE_ID: TIntegerField;
    FDQlisteK_UPDATED: TSQLTimeStampField;
    FDQlisteKSE_LOCK_ID: TIntegerField;
    FDQlisteKMA_LOCK_ID: TIntegerField;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Favoris1: TMenuItem;
    N1: TMenuItem;
    GestionsdesConnexions1: TMenuItem;
    procedure BouvrirClick(Sender: TObject);
    procedure BANALYSEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mscriptClick(Sender: TObject);
    procedure Misejour1Click(Sender: TObject);
    procedure Quiter1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtn2Click(Sender: TObject);
    procedure cdsRestantCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées }
    procedure AfterCon;
    procedure K_Restants;
    function AnalysePlage(Astring:string):TPlage;
  public
    { Déclarations publiques }
  end;

var
  Form_KMANQUANTS: TForm_KMANQUANTS;

implementation

uses FUPDATE, UCommun;

{$R *.dfm}

procedure TForm_KMANQUANTS.BouvrirClick(Sender: TObject);
begin
     FDConIB.Params.Clear;
     FDConIB.Params.Add('DRIVERID=IB');
     FDConIB.Params.Add('Server='+teSERVER.Text);
     FDConIB.Params.Add('Database='+teDatabaseFile.Text);
     FDConIB.Params.Add('User_Name=SYSDBA');
     FDConIB.Params.Add('Password=masterkey');
     try
        FDConIB.open;
        AfterCon;
        BANALYSE.Enabled:=true;
     finally
        //
     end;


     {
     if (teDatabaseFile.Text<>'') then
        begin
             ConIB.Server:=teSERVER.Text;
             ConIB.Database:=teDatabaseFile.Text;
        end
        else
        begin
             VLP_OpenDialog:=TOpenDialog.Create(nil);
        //       VLP_OpenDialog.DefaultFolder:= Var_Glob.Export_XLS_DIR;
        //      VLP_OpenDialog.FileTypes.FilterSpecArray := 'Fichiers interbase (*.ib)|*.IB';
               if  VLP_OpenDialog.Execute
                      then
                           begin
                                ConIB.Disconnect;
                                ConIB.Server:='localhost';
                                teDatabaseFile.Text:=VLP_OpenDialog.FileName;
                                ConIB.Database:=VLP_OpenDialog.FileName;
                                try
                                   ConIB.Connect;
                                   AfterCon;
                                finally
                                    Btn_2.Enabled:=ConIB.Connected and (te_BAS_IDENT.Text<>'');
                                end;
                           end;
             VLP_OpenDialog.Free;
        end;
     }
end;


procedure TForm_KMANQUANTS.cdsRestantCalcFields(DataSet: TDataSet);
var total    : Int64;
    Consomme : Int64;
begin
    DataSet.FieldByName('TAUXOCCUPATION').AsFloat:=0;
    Total    := DataSet.FieldByName('TRANCHE_FIN').AsLargeInt -  DataSet.FieldByName('TRANCHE_DEBUT').AsLargeInt;
    Consomme := Total -  DataSet.FieldByName('RESTE').asLargeInt;
    if total<>0 then
      DataSet.FieldByName('TAUXOCCUPATION').AsFloat:= (Consomme / Total)*100


end;

procedure TForm_KMANQUANTS.K_Restants;
var PQuery:TFDQuery;
    Aplage:TPlage;
begin
     // E:\Public\BASES\13.1\TAPIE\TAPIE_RODEZ_CAISSE.IB
     PQuery:=TFDQuery.Create(nil);
     PQuery.Connection:=FDconIB;
     PQuery.Transaction:=FDtransIB;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT BAS_IDENT, BAS_PLAGE, BAS_SENDER ');
     PQuery.SQL.Add(' FROM GENBASES JOIN K ON K_ID=BAS_ID AND K_ENABLED=1');
     PQuery.SQL.Add(' WHERE BAS_ID<>0 ');
     PQuery.SQL.Add(' ORDER BY BAS_ID ');
     //PQuery.Options.QueryRecCount:=True;
     PQuery.Prepare;
     PQuery.Open;
     cdsRestant.DisableControls;
     cdsRestant.Close;
     cdsRestant.CreateDataset;
     cdsRestant.open;

     while not(PQuery.eof) do
      begin
           Aplage := AnalysePlage(PQuery.FieldByName('BAS_PLAGE').AsString);
           cdsRestant.Append;
           cdsRestant.FieldByName('BAS_SENDER').asstring:=PQuery.FieldByName('BAS_SENDER').AsString;
           cdsRestant.FieldByName('BAS_IDENT').asstring:=PQuery.FieldByName('BAS_IDENT').AsString;
           cdsRestant.FieldByName('TRANCHE').asstring:=PQuery.FieldByName('BAS_PLAGE').AsString;
           cdsRestant.FieldByName('TRANCHE_DEBUT').AsLargeInt:=Aplage.Debut;
           cdsRestant.FieldByName('TRANCHE_FIN').AsLargeInt:=Aplage.Fin;
           cdsRestant.Post;
           PQuery.Next;
      end;
     PQuery.Close;

     PQuery.SQl.Clear;
     PQuery.SQL.Add('SELECT MAX(K_ID)');
     PQuery.SQL.Add(' FROM K ');
     PQuery.SQL.Add(' WHERE K_ID>:KDEBUT AND K_ID<:KFIN');
     // PQuery.Open;

     cdsRestant.First;

     while not(cdsRestant.eof) do
      begin
           PQuery.close;
           PQuery.ParamByName('KDEBUT').AsLargeInt :=cdsRestant.FieldByName('TRANCHE_DEBUT').AsLargeInt;
           PQuery.ParamByName('KFIN').AsLargeInt :=cdsRestant.FieldByName('TRANCHE_FIN').AsLargeInt;
           PQuery.Open;
           cdsRestant.Edit;
           cdsRestant.FieldByName('RESTE').AsLargeInt :=
                cdsRestant.FieldByName('TRANCHE_FIN').AsInteger -
                Max(PQuery.fields[0].AsLargeInt,cdsRestant.FieldByName('TRANCHE_DEBUT').AsLargeInt);
           cdsRestant.Post;
           cdsRestant.Next;
      end;
     cdsRestant.EnableControls;

     PQuery.Free;
end;

procedure TForm_KMANQUANTS.BANALYSEClick(Sender: TObject);
var plageLame,plageServeur:TPlage;

begin
     if FDConIB.Connected then
      begin
           FDQliste.DisableControls;
           mscript.Lines.Clear;
           try
              If tsKMANQUANTS.TabVisible then
                begin
                     Pnl_count.Caption:=Format('%d',[0]);
                     plageLame    := AnalysePlage(te_LAMEPLAGE.Text);
                     plageServeur := AnalysePlage(te_SERVPLAGE.Text);
                     FDQliste.Connection:=FDconIB;
                     FDQliste.Transaction:=FDtransIB;
                     FDQliste.Close;
                     FDQliste.SQL.Clear;
                     FDQliste.SQL.Add('SELECT KTB.KTB_NAME, K.* FROM K JOIN KTB ON KTB.KTB_ID=K.KTB_ID WHERE K_ID>=:SERVPLAGEDEBUT AND K_ID<:SERVPLAGEFIN ');
                     FDQliste.SQL.Add(' AND (K_VERSION<=:LAMEPLAGEDEBUT OR K_VERSION>:LAMEPLAGEFIN)');
                     FDQliste.SQL.Add(' AND K_INSERTED>:INSERTED_DEBUT AND K_INSERTED<=:INSERTED_FIN');
                     FDQliste.ParamByName('SERVPLAGEDEBUT').AsInteger := plageServeur.Debut;
                     FDQliste.ParamByName('SERVPLAGEFIN').AsInteger   := plageServeur.Fin;
                     FDQliste.ParamByName('LAMEPLAGEDEBUT').AsInteger := plageLame.Debut;
                     FDQliste.ParamByName('LAMEPLAGEFIN').AsInteger   := plageLame.Fin;
                     FDQliste.ParamByName('INSERTED_DEBUT').AsDateTime:= de_INSERTED_DEBUT.Date;
                     FDQliste.ParamByName('INSERTED_FIN').AsDateTime  := de_INSERTED_FIN.Date;
                     FDQliste.open;
                     While not(FDQliste.eof) do
                      begin
                           mscript.Lines.Add(Format('EXECUTE PROCEDURE PR_UPDATEK(%d,0);',[FDQliste.FieldByName('K_ID').asinteger]));
                           FDQliste.Next;
                      end;
                      Pnl_count.Caption:=Format('%d',[ FDQliste.RecordCount]);
                 end;
                //Analyse_K_Restant
                K_Restants;

           finally
               FDQliste.EnableControls;
               pgcntrl1.ActivePageIndex:=1;
           end;
      end;
end;



procedure TForm_KMANQUANTS.BitBtn2Click(Sender: TObject);
begin
     FDConIB.Close;
end;

procedure TForm_KMANQUANTS.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     if FDconIB.Connected then FDconIB.Close;
     CanClose:=true;
end;

procedure TForm_KMANQUANTS.FormCreate(Sender: TObject);
begin
   VAR_GLOB.PathReg:='SOFTWARE\GINKOIA\KMANQUANTS\';
   de_INSERTED_DEBUT.Date:=StartOfTheMonth(StartOfTheMonth(Now())-1);
   de_INSERTED_FIN.Date:=Trunc(Now()-1);
end;

procedure TForm_KMANQUANTS.Misejour1Click(Sender: TObject);
begin
     Application.CreateForm(TFormUPDATE,FormUPDATE);
     FormUPDATE.Showmodal;
end;

procedure TForm_KMANQUANTS.mscriptClick(Sender: TObject);
begin
  mscript.SelectAll;
end;

procedure TForm_KMANQUANTS.Quiter1Click(Sender: TObject);
begin
    Close;
end;

function TForm_KMANQUANTS.AnalysePlage(Astring:string):TPlage;
var tmp:string;
    i:Integer;
begin
   try
      tmp:=Astring;
      tmp:=Copy(tmp,2,length(tmp)-3);
      i:=Pos('M_',tmp);
      result.Debut:=StrToInt(Copy(tmp,0,i-1))*1000000;
      result.Fin:=StrToInt(Copy(tmp,i+2,length(tmp)))*1000000;
   Except on E:Exception do
        MessageDlg('Erreur : '+E.CLassName
        , mtError, [mbOK], 0);
   end;
end;

procedure TForm_KMANQUANTS.AfterCon;
var PQuery:TFDQuery;

begin
     if FDConIB.Connected then
      begin
           PQuery:=TFDQuery.Create(self);
           try
               PQuery.Connection:=FDconIB;
               PQuery.Transaction:=FDtransIB;
               PQuery.Close;
               PQuery.SQL.Clear;
               PQuery.SQL.Add('SELECT BAS_IDENT,  BAS_PLAGE ');
               PQuery.SQL.Add('FROM GENPARAMBASE ');
               PQuery.SQL.Add('JOIN GENBASES ON  BAS_IDENT=PAR_STRING OR BAS_IDENT=''0''');
               PQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR'' ORDER BY BAS_IDENT ASC ');
               // PQuery.Options.QueryRecCount:=True;
               PQuery.Prepare;
               PQuery.Open;
               if PQuery.RecordCount=2 then
                begin
                     tsKMANQUANTS.TabVisible:=true;
                     PQuery.First;
                     te_LAMEPLAGE.Text:=PQuery.FieldByName('BAS_PLAGE').AsString;
                     te_LAME_BASIDENT.Text:=PQuery.FieldByName('BAS_IDENT').AsString;
                     PQuery.next;
                     te_SERVPLAGE.Text:=PQuery.FieldByName('BAS_PLAGE').AsString;
                     te_BAS_IDENT.Text:=PQuery.FieldByName('BAS_IDENT').AsString;
                end
                else
                begin
                    tsKMANQUANTS.TabVisible:=false;
                   //  MessageDlg('Cette base est une base zéro : Impossible de lancer les calculs de K Manquants', mtError, [mbOK], 0);
                end;
            finally
                  PQuery.Close;
                  PQuery.Free;
            end;
      end;
end;

end.

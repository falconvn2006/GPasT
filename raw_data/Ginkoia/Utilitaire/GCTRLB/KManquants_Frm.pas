unit KManquants_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls,
  DB, ShellAPI, MidasLib,
  ComCtrls, Buttons, Grids, DBGrids, DateUtils,Math,
  DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.Phys.IB, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  Vcl.ImgList, Vcl.ToolWin, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLite;


const ginkoia_url_kanalyse  = 'http://90.83.227.43:10074/tools/ws/';
      yellis_url_kanalyse   = 'http://ginkoia.yellis.net/v2/ws/';
      ws_script             = 'ws_kanalyse.php';

      MaxWDPOSTExe       = 20;
      clBgL0             = $00DDDDDD;
      clBgL1             = $00FFFFFF;
      clError            = $002C2AE3;
      clOK               = $0061BB8B;

type
  TPlage=record
   Debut:int64;
   Fin:int64;
  end;
  TFrm_KMANQUANTS = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl3: TLabel;

    dsliste: TDataSource;
    spl1: TSplitter;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    grp_infos: TGroupBox;
    mm1: TMainMenu;
    Fichier1: TMenuItem;
    Aide1: TMenuItem;
    Misejour1: TMenuItem;
    Quiter1: TMenuItem;
//    de_INSERTED_FIN: TDateTimePicker;
    lbl10: TLabel;
    de_INSERTED_DEBUT: TDateTimePicker;
    de_INSERTED_FIN: TDateTimePicker;
    mEXTABLE: TMemo;
    te_BAS_IDENT: TEdit;
    te_SERVPLAGE: TEdit;
    te_LAMEPLAGE: TEdit;
    te_LAME_BASIDENT: TEdit;
    teSERVER: TEdit;
    teDatabaseFile: TEdit;
    mscript: TMemo;
    pgcntrl1: TPageControl;
    ts1: TTabSheet;
    tsKMANQUANTS: TTabSheet;
    g1: TDBGrid;
    Pan_: TPanel;
    Pan_1: TPanel;
    Pnl_count: TPanel;
    tsKrestants: TTabSheet;
    cdsRestant: TClientDataSet;
    cdsRestantBAS_IDENT: TStringField;
    cdsRestantTRANCHE: TStringField;
    dsRESTANT: TDataSource;
    DBGrid1: TDBGrid;
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
    ToolBar1: TToolBar;
    BConnect: TToolButton;
    BDISCONNECT: TToolButton;
    Bbtn4: TToolButton;
    Bbtn3: TToolButton;
    ImageList1: TImageList;
    BANALYSE: TBitBtn;
    lbl11: TLabel;
    teALIAS: TEdit;
    ProgressBar1: TProgressBar;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDConLITE: TFDConnection;
    FDTransLITE: TFDTransaction;
    BHint: TBalloonHint;
    lbl_pleasewait: TLabel;
    cbAutoSend: TCheckBox;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    te_BAS_SENDER: TEdit;
    te_LAME_SENDER: TEdit;
    teGROUP: TEdit;
    Label2: TLabel;
    grp_options: TGroupBox;
    cb_all: TCheckBox;
    Timer1: TTimer;
    Label3: TLabel;
    procedure BANALYSEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mscriptClick(Sender: TObject);
    procedure Misejour1Click(Sender: TObject);
    procedure Quiter1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cdsRestantCalcFields(DataSet: TDataSet);
    procedure BDISCONNECTClick(Sender: TObject);
    procedure BConnectClick(Sender: TObject);
    procedure FDConIBAfterConnect(Sender: TObject);
    procedure FDConIBAfterDisconnect(Sender: TObject);
    procedure mscriptKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmf_Click(Sender: TObject);
    procedure Bbtn3Click(Sender: TObject);
    procedure GestionsdesConnexions1Click(Sender: TObject);
    procedure cbAutoSendClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cb_allClick(Sender: TObject);
  private
    { Déclarations privées }
    FSecondsLeft :Integer;
    Fauto     : Boolean;
    FAll      : Boolean;
    FUrlPath  : string;
    FFavori   : string;
    FbBasezero: Boolean;
    procedure AfterCon;
    procedure K_Restants;
    function AnalysePlage(Astring:string):TPlage;
    procedure CreateFavoris();
    procedure SaveFavoris();
    procedure AddFavoris;
    procedure MessageHint(AMessage:string;AControl:TControl);
    procedure Load_Param(aparam:string;avalue:string);
    procedure WSPost_Resultats;
    procedure setBaseZero(Avalue:Boolean);
    procedure ScanAllFavoris;
    procedure StartCountDown(Seconds:Integer);
  public
   property bBaseZero: boolean read fbBaseZero write setBaseZero;
    { Déclarations publiques }
  end;

var
  Frm_KMANQUANTS: TFrm_KMANQUANTS;

implementation

uses FUPDATE, UCommun, UFDThread, KConnexion_Frm;

{$R *.dfm}

procedure TFrm_KMANQUANTS.StartCountDown(Seconds:Integer);
begin
  FSecondsLeft  := Seconds;
  Timer1.Enabled :=True;
end;



procedure TFrm_KMANQUANTS.setBaseZero(Avalue:Boolean);
begin
    FbBaseZero:=AValue;
    grp_options.Visible:=not(FbBaseZero);
end;

procedure TFrm_KMANQUANTS.Timer1Timer(Sender: TObject);
begin
    Dec(FSecondsLeft);
    Label3.Caption:=Format('Scan général dans %d secondes',[FSecondsLeft]);
    if FSecondsLeft = 0 then
      begin
         Timer1.Enabled:=False;
         cb_all.Visible:=false;
         label3.Visible:=false;
         if ((Fauto) and (FAll)) then
          begin
            ScanAllFavoris;
          end;
      end;
end;

procedure TFrm_KMANQUANTS.cbAutoSendClick(Sender: TObject);
begin
    FAuto:=cbAutoSend.Checked;
end;

procedure TFrm_KMANQUANTS.cb_allClick(Sender: TObject);
begin
      Timer1.Enabled:=cb_all.checked;
end;

procedure TFrm_KMANQUANTS.cdsRestantCalcFields(DataSet: TDataSet);
var total    : Int64;
    Consomme : Int64;
begin
    DataSet.FieldByName('TAUXOCCUPATION').AsFloat:=0;
    Total    := DataSet.FieldByName('TRANCHE_FIN').AsLargeInt -  DataSet.FieldByName('TRANCHE_DEBUT').AsLargeInt;
    Consomme := Total -  DataSet.FieldByName('RESTE').asLargeInt;
    if total<>0 then
      DataSet.FieldByName('TAUXOCCUPATION').AsFloat:= (Consomme / Total)*100
end;

procedure TFrm_KMANQUANTS.K_Restants;
var PQuery:TFDQuery;
    Aplage:TPlage;
     thread : TFDThread;
    ASql:TStringList;
    aint64:int64;
begin
     // E:\Public\BASES\13.1\TAPIE\TAPIE_RODEZ_CAISSE.IB
     cdsRestant.DisableControls;
     cdsRestant.EmptyDataSet;
     thread := TFDThread.Create(teSERVER.text,teDatabaseFile.text,True,True);
     ASql:=TStringList.Create;
     try
        ASQL.Clear;
        ASQL.Add('SELECT BAS_IDENT,  BAS_SENDER , BAS_PLAGE ');
        ASQL.Add(' FROM GENBASES JOIN K ON K_ID=BAS_ID AND K_ENABLED=1');
        ASQL.Add(' WHERE BAS_ID<>0 ');
        ASQL.Add(' ORDER BY BAS_ID ');
        cdsRestant.AutoCalcFields:=false;
        cdsRestant.EmptyDataSet;
        thread.GetResultQuery(ASQL,cdsRestant);
        thread.FinaliseDB;
     finally
        ASQL.free;
        FreeAndNil(thread);
     end;
     Application.ProcessMessages;
    try
     thread := TFDThread.Create(teSERVER.text,teDatabaseFile.text,True,True);
     ASql:=TStringList.Create;
     cdsRestant.Active:=true;
     cdsRestant.First;
     while not(cdsRestant.eof) do
      begin
           Aplage := AnalysePlage(cdsRestant.FieldByName('TRANCHE').AsString);
           ASql.Clear;
           ASql.Add('SELECT MAX(K_ID) ');
           ASql.Add(' FROM K ');
           ASql.Add(Format(' WHERE K_ID>%d AND K_ID<%d',[Aplage.Debut, Aplage.Fin ]));
           cdsRestant.Edit;
           cdsRestant.FieldByName('TRANCHE_FIN').AsLargeInt := Aplage.Fin;
           cdsRestant.FieldByName('TRANCHE_DEBUT').AsLargeInt := Aplage.DEBUT;
           aint64 := thread.GetFieldInt(ASQL);
           cdsRestant.FieldByName('RESTE').AsLargeInt := Aplage.Fin - Max(aint64,Aplage.DEBUT);
           cdsRestant.Post;
           thread.CommitTrans;
           thread.FinaliseDB;
           ProgressBar1.Position:= round(100 * (cdsRestant.RecNo+1) / cdsRestant.RecordCount);
           Application.ProcessMessages;
           cdsRestant.Next;
      end;
    finally
        ProgressBar1.Position:= 100;
        ASQL.free;
        FreeAndNil(thread);
     end;
     cdsRestant.AutoCalcFields:=true;
     cdsRestant.EnableControls;
     tsKrestants.TabVisible:=True;
 {
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
     Application.ProcessMessages;
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
                Application.ProcessMessages;
      end;
     cdsRestant.EnableControls;
     tsKrestants.TabVisible:=True;
     PQuery.Free;
   }
end;

procedure TFrm_KMANQUANTS.BANALYSEClick(Sender: TObject);
var plageLame,plageServeur:TPlage;
    Tableexclusion:string;
begin
    if FDConIB.Connected then
      begin
           BANALYSE.Enabled:=False;
           BANALYSE.Visible:=False;
           lbl_pleasewait.Visible:=True;
           FDQliste.DisableControls;
           ProgressBar1.Visible:=true;
           Application.ProcessMessages;
           mscript.Lines.Clear;
           try
              If not(bBasezero) then
                begin
                     Pnl_count.Caption:=Format('%d',[0]);
                     plageLame    := AnalysePlage(te_LAMEPLAGE.Text);
                     plageServeur := AnalysePlage(te_SERVPLAGE.Text);
                     FDQliste.Connection:=FDconIB;
                     FDQliste.Transaction:=FDtransIB;
                     FDQliste.DisableControls;
                     FDQliste.Close;
                     FDQliste.SQL.Clear;
                     TableExclusion:=StringReplace(Trim(mEXTABLE.Text),',',''',''',[rfReplaceAll]);
                     FDQliste.SQL.Add('SELECT KTB.KTB_NAME, K.* FROM K JOIN KTB ON KTB.KTB_ID=K.KTB_ID WHERE K_ID>=:SERVPLAGEDEBUT AND K_ID<:SERVPLAGEFIN ');
                     FDQliste.SQL.Add(' AND (K_VERSION<=:LAMEPLAGEDEBUT OR K_VERSION>:LAMEPLAGEFIN)');
                     FDQliste.SQL.Add(' AND (K_INSERTED>:INSERTEDDEBUT AND K_INSERTED<=:INSERTEDFIN)');
                     FDQliste.SQL.Add(' AND ( (K_UPDATED<=:UPDATEDFIN AND K_ENABLED=1)  ');
                     FDQliste.SQL.Add('     OR (K_DELETED<=:DELETEDFIN  AND K_ENABLED=0) )');
                     FDQliste.SQL.Add(Format(' AND KTB.KTB_NAME NOT IN (''%s'')',[TableExclusion]));
                     FDQliste.ParamByName('SERVPLAGEDEBUT').AsInteger := plageServeur.Debut;
                     FDQliste.ParamByName('SERVPLAGEFIN').AsInteger   := plageServeur.Fin;
                     FDQliste.ParamByName('LAMEPLAGEDEBUT').AsInteger := plageLame.Debut;
                     FDQliste.ParamByName('LAMEPLAGEFIN').AsInteger   := plageLame.Fin;
                     FDQliste.ParamByName('INSERTEDDEBUT').AsDateTime:= de_INSERTED_DEBUT.Date;
                     FDQliste.ParamByName('INSERTEDFIN').AsDateTime  := de_INSERTED_FIN.Date;
                     FDQliste.ParamByName('UPDATEDFIN').AsDateTime   := de_INSERTED_FIN.Date;
                     FDQliste.ParamByName('DELETEDFIN').AsDateTime   := de_INSERTED_FIN.Date;
                     // Showmessage(FDQliste.SQL.Text);
                     FDQliste.open;

                     While not(FDQliste.eof) do
                      begin
                           mscript.Lines.Add(Format('EXECUTE PROCEDURE PR_UPDATEK(%d,0);',[FDQliste.FieldByName('K_ID').asinteger]));
                           Application.ProcessMessages;
                           ProgressBar1.Position:=Round((FDQliste.RecNo + 1) * 100 / FDQliste.RecordCount);
                           Application.ProcessMessages;
                           FDQliste.Next;
                      end;
                      Pnl_count.Caption:=Format('%d',[ FDQliste.RecordCount]);
                      FDQliste.EnableControls;
                      Application.ProcessMessages;
                      ProgressBar1.Position:=100;
                      // pgcntrl1.ActivePageIndex:=1;
                end
              else
              begin
                K_Restants;
              end;
              // -----
              if FAuto then
                begin
                     WSPost_Resultats
                end;
           finally
               FDQliste.EnableControls;
               BANALYSE.Enabled:=true;
               BANALYSE.Visible:=true;
               lbl_pleasewait.Visible:=false;
           end;
      end;
     //--------------------------------------
     if (bBasezero) then
       begin
         tsKRestants.TabVisible:=true;
         pgcntrl1.ActivePage:=tsKRestants;
       end
     else
       begin
         tsKMANQUANTS.TabVisible:=true;
         pgcntrl1.ActivePage:=tsKMANQUANTS;
       end;
end;

procedure TFrm_KMANQUANTS.WSPost_Resultats;
var Parametres:string;
    sAuto:string;
    Json_str:string;
  I: Integer;
begin                     // Envoyer au monitor les resutlats....
     if FAuto then sAuto:='-auto';
     sAuto:=sAuto + ' ';
     // sAuto:=' ';
     Json_str:='';
     //----------------------- les K MANQUANTS ---------------------------------
     if ((te_BAS_IDENT.text<>'0') and (te_BAS_IDENT.text<>'')) then
      begin
           Json_str:= Format('{snd:%s,idt:%s,mis:%s}',[te_BAS_SENDER.Text,te_BAS_IDENT.Text,Pnl_count.caption]);
           Parametres:=Format('%s-url=%s -psk=456DFEAB45 -json="d:%s,j:[%s]"',[
                     sAuto,
                     FUrlPath + ws_Script,
                     teGROUP.text, //  <--- Attention le Groupe !!
                     Json_str]);
      end
     //----------------------- les K RESTANTS (uniquement Lame)-----------------
     else
     begin
      cdsRestant.First;
      Json_str:='';
      while not(cdsRestant.eof) do
        begin
             Json_str:= Json_str + Format('{snd:%s,trn:%s,idt:%s,deb:%d,fin:%d,rst:%d}',[
                cdsRestant.FieldByName('BAS_SENDER').asstring,
                cdsRestant.FieldByName('TRANCHE').asstring,
                cdsRestant.FieldByName('BAS_IDENT').asstring,
                cdsRestant.FieldByName('TRANCHE_DEBUT').asinteger,
                cdsRestant.FieldByName('TRANCHE_FIN').asinteger,
                cdsRestant.FieldByName('RESTE').asinteger
                ]);
             cdsRestant.Next;
        end;
        Parametres:=Format('%s-url=%s -psk=EF78FDB1E -json="d:%s,j:[%s]"',[
                    sAuto,
                    FUrlPath + ws_Script,
                    teALIAS.text,  //  <--- Attention l'Alias
                    Json_str]);
     end;
     ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
end;

procedure TFrm_KMANQUANTS.Bbtn3Click(Sender: TObject);
begin
     if (teGROUP.Text='') then
       begin
         MessageHint('Veuillez saisir un Groupe pour cette connexion.',teGROUP);
         exit;
       end;
     if (teALIAS.Text='') then
        begin
          MessageHint('Veuillez saisir un Alias pour cette connexion.',teALIAS);
          exit;
        end;
     if (teSERVER.Text='') then
       begin
          MessageHint('Veuillez saisir un Serveur pour cette connexion.',teSERVER);
          exit;
       end;
     if (teDatabaseFile.Text='') then
       begin
          MessageHint('Veuillez saisir un Chemin pour cette connexion.',teDatabaseFile);
          exit;
       end;

     If FDconlite.Connected then
        begin
             AddFavoris;
             CreateFavoris;
        end;
end;


procedure TFrm_KMANQUANTS.MessageHint(AMessage:string;AControl:TControl);
var Pt: TPoint;
begin
     BHint.Title:='Attention';
     BHint.Style:=bhsBalloon;
     BHint.Description := AMessage;
     Pt.X := AControl.Width Div 2;
     Pt.Y := AControl.Height;
     BHint.ShowHint(AControl.ClientToScreen(Pt));
end;

procedure TFrm_KMANQUANTS.BConnectClick(Sender: TObject);
begin
     if (teGROUP.Text='') then
       begin
         MessageHint('Veuillez saisir un Groupe pour cette connexion.',teGROUP);
         exit;
       end;
     if (teALIAS.Text='') then
        begin
          MessageHint('Veuillez saisir un Alias pour cette connexion.',teALIAS);
          exit;
        end;
     if (teSERVER.Text='') then
       begin
          MessageHint('Veuillez saisir un Serveur pour cette connexion.',teSERVER);
          exit;
       end;
     if (teDatabaseFile.Text='') then
       begin
          MessageHint('Veuillez saisir un Chemin pour cette connexion.',teDatabaseFile);
          exit;
       end;

     bBasezero:=false;
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
     Except On E:Exception  do
        MessageHint('Exception :  '+ E.Message ,teDatabaseFile);
     end;
end;

procedure TFrm_KMANQUANTS.BDISCONNECTClick(Sender: TObject);
begin
     FDConIB.Close;
end;

procedure TFrm_KMANQUANTS.FDConIBAfterConnect(Sender: TObject);
begin
     BANALYSE.Enabled:=True;
     te_LAMEPLAGE.Text:='';
     te_LAME_BASIDENT.Text:='';
     te_LAME_SENDER.Text:='';
     te_SERVPLAGE.Text:='';
     te_BAS_IDENT.Text:='';
     te_BAS_SENDER.Text:='';
     //***************************
     teGROUP.Enabled:=false;
     teALIAS.Enabled:=false;
     teSERVER.Enabled:=false;
     teDatabaseFile.Enabled:=false;

     BDISCONNECT.Enabled:=True;
     BConnect.Enabled:=false;
     StatusBar1.Panels[0].Text:=Format(' Connecté à %s : (%s@%s)',[teALIAS.text,teSERVER.text,teDatabaseFile.text]);
end;

procedure TFrm_KMANQUANTS.FDConIBAfterDisconnect(Sender: TObject);
begin
    BANALYSE.Enabled:=false;

    te_LAMEPLAGE.Text:='';
    te_LAME_BASIDENT.Text:='';
    te_LAME_SENDER.Text:='';
    te_SERVPLAGE.Text:='';
    te_BAS_IDENT.Text:='';
    te_BAS_SENDER.Text:='';

    teGROUP.Enabled:=True;
    teALIAS.Enabled:=true;
    teSERVER.Enabled:=true;
    teDatabaseFile.Enabled:=true;

    BDISCONNECT.Enabled:=false;
    BConnect.Enabled:=true;
    ProgressBar1.Visible:=false;
    tsKMANQUANTS.TabVisible:=false;
    tsKRESTANTS.TabVisible:=false;
    pgcntrl1.ActivePage:=ts1;
    StatusBar1.Panels[0].Text:='';
end;

procedure TFrm_KMANQUANTS.FormActivate(Sender: TObject);
begin
    Timer1.Enabled:=(Fauto and FAll);
    Label3.Visible:=(Fauto and FAll);


    FSecondsLeft:=5;
end;

procedure TFrm_KMANQUANTS.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     if FDconIB.Connected then FDconIB.Close;
     CanClose:=true;
end;

procedure TFrm_KMANQUANTS.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
    AMenuItem:TMenuItem;
begin
   FbBaseZero:=True;
   VAR_GLOB.PathReg:='SOFTWARE\GINKOIA\KMANQUANTS\';
   de_INSERTED_DEBUT.Date:=StartOfTheMonth(StartOfTheMonth(Now()-150)-1);
   de_INSERTED_FIN.Date:=Trunc(Now()-1);
   CreateFavoris;

     //-------------------------------------------------------------------------
     FUrlPath := ginkoia_url_kanalyse;
     FAuto:=False;
     FAll:=false;
     FFavori:='';
     for i :=1 to ParamCount do
      begin
            If lowercase(ParamStr(i))='-auto'  then FAuto  := true;
            if lowercase(ParamStr(i))='-all'   then FAll   := true;
            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-url'     then Load_Param('url',value);
            If lowercase(param)='-favori'  then Load_Param('favori',value);  // un favori en particulier
            If lowercase(param)='-start'   then Load_Param('start',value);
      end;
     //-------------------------------------------------------------------------
     Caption := Caption + ' - Version ' + GetInfo('Version');
     cbAutoSend.Checked:=FAuto;
     if ((Fauto) and (FFavori<>'')) then
        begin
             AMenuItem:=nil;
             For i:=0 to Favoris1.Count do
              begin
                   AMenuItem:=Favoris1.Items[i].Find(FFavori);
                   if AMenuItem<>nil then
                    begin
                         AMenuItem.Click;
                         BConnect.Click;
                         exit;
                    End;
              end;
              AMenuItem:=Favoris1.Find(FFavori);
              if AMenuItem<>nil then
                begin
                     AMenuItem.Click;
                     BConnect.Click;
                     exit;
                End;
        end;
    cb_all.Visible:=(Fauto and FAll);
    label3.Visible:=(Fauto and FAll);
    cb_all.checked:=(Fauto and FAll);
end;

procedure TFrm_KMANQUANTS.FormKeyPress(Sender: TObject; var Key: Char);
begin
     BHint.HideHint;
end;

procedure TFrm_KMANQUANTS.Load_Param(aparam:string;avalue:string);
begin
     if aparam='url'      then FUrlPath := avalue;
     if aparam='favori'   then FFavori  := avalue;
     if aparam='start'    then de_INSERTED_DEBUT.Date:=Trunc(Now()-1-StrToint(avalue))
end;

procedure TFrm_KMANQUANTS.GestionsdesConnexions1Click(Sender: TObject);
begin
     Application.CreateForm(TFrm_KConnexion,Frm_KConnexion);
     Frm_KConnexion.qliste.close;
     Frm_KConnexion.qliste.Open;
     Frm_KConnexion.Showmodal;
     CreateFavoris;
end;

procedure TFrm_KMANQUANTS.Misejour1Click(Sender: TObject);
begin
     Application.CreateForm(TFormUPDATE,FormUPDATE);
     FormUPDATE.Showmodal;
end;

procedure TFrm_KMANQUANTS.mscriptClick(Sender: TObject);
begin
  mscript.SelectAll;
end;

procedure TFrm_KMANQUANTS.mscriptKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = Ord('A')) and (ssCtrl in Shift) then
   begin
     TMemo(Sender).SelectAll;
     Key := 0;
    end;
end;

procedure TFrm_KMANQUANTS.Quiter1Click(Sender: TObject);
begin
    Close;
end;

function TFrm_KMANQUANTS.AnalysePlage(Astring:string):TPlage;
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

procedure TFrm_KMANQUANTS.AfterCon;
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
               PQuery.SQL.Add('SELECT BAS_IDENT,  BAS_PLAGE, BAS_SENDER ');
               PQuery.SQL.Add('FROM GENPARAMBASE ');
               PQuery.SQL.Add('JOIN GENBASES ON  BAS_IDENT=PAR_STRING OR BAS_IDENT=''0''');
               PQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR'' ORDER BY BAS_IDENT ASC ');
               // PQuery.Options.QueryRecCount:=True;
               PQuery.Prepare;
               PQuery.Open;
               if PQuery.RecordCount=2 then
                begin
                     PQuery.First;
                     te_LAMEPLAGE.Text:=PQuery.FieldByName('BAS_PLAGE').AsString;
                     te_LAME_BASIDENT.Text:=PQuery.FieldByName('BAS_IDENT').AsString;
                     te_LAME_SENDER.Text:=PQuery.FieldByName('BAS_SENDER').AsString;
                     PQuery.next;
                     te_SERVPLAGE.Text:=PQuery.FieldByName('BAS_PLAGE').AsString;
                     te_BAS_IDENT.Text:=PQuery.FieldByName('BAS_IDENT').AsString;
                     te_BAS_SENDER.Text:=PQuery.FieldByName('BAS_SENDER').AsString;
                     bBasezero:=False;
                end
                else
                begin
                     bBasezero:=True;
                end;
           finally
                  PQuery.Close;
                  PQuery.Free;
           end;
      end;
     if (FAuto) then BANALYSE.Click;
end;


procedure TFrm_KMANQUANTS.ScanAllFavoris;
var PQuery:TFDQuery;
    i,j,k:Integer;
begin
     PQuery:=TFDQuery.Create(nil);
     PQuery.Connection:=FDconlite;
     PQuery.close;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 ORDER BY CON_NOM');
     PQuery.UpdateOptions.ReadOnly:=true;
     PQuery.Open;
     while not(PQuery.Eof) do
        begin
             teGROUP.Text:=PQuery.FieldByName('CON_GROUP').asstring;
             teALIAS.Text:=PQuery.FieldByName('CON_NOM').asstring;
             teSERVER.Text:=PQuery.FieldByName('CON_SERVER').asstring;
             teDatabaseFile.Text:=PQuery.FieldByName('CON_DATABASE').asstring;
             BConnect.Click;
             Application.ProcessMessages;
             BDISCONNECT.Click;
             Application.ProcessMessages;
             PQuery.Next;
        end;
     PQuery.Close;
     PQuery.Free;
     Close;
end;

procedure TFrm_KMANQUANTS.CreateFavoris;
var PQuery:TFDQuery;
    Menu:TMenuItem;
    i,j,k:Integer;
begin
     PQuery:=TFDQuery.Create(nil);
     PQuery.Connection:=FDconlite;
     PQuery.SQL.Clear;
     Favoris1.Clear;
     i:=0;
     PQuery.close;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT DISTINCT CON_GROUP FROM CONNEXION WHERE CON_GROUP<>'''' ORDER BY CON_GROUP');
     PQuery.UpdateOptions.ReadOnly:=true;
     PQuery.Open;
      while not(PQuery.Eof) do
        begin
             Menu := TMenuItem.Create(Self);
             Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_GROUP').asstring ]);
             Favoris1.Insert(i,Menu);
             // Menu.Tag:=PQuery.FieldByName('CON_ID').asinteger;
             Menu.ImageIndex:=4+(PQuery.RecNo-1) mod 3;
             PQuery.Next;
             Inc(i);
        end;
     j:=i;
     Menu := TMenuItem.Create(Self);
     Menu.Caption := '-';
     Favoris1.Insert(i,Menu);
     Inc(i);
     PQuery.close;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 AND CON_GROUP='''' ORDER BY CON_NOM');
     PQuery.UpdateOptions.ReadOnly:=true;
     PQuery.Open;
     while not(PQuery.Eof) do
        begin
             Menu := TMenuItem.Create(Self);
             Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
             Favoris1.Insert(i,Menu);
             Menu.Tag:=PQuery.FieldByName('CON_ID').asinteger;
             Menu.ImageIndex:=4+(PQuery.RecNo-1) mod 3;
             Menu.OnClick:=tmf_Click;
             PQuery.Next;
             Inc(i);
        end;
     PQuery.Close;
     for i:=0 to j do
      begin
           PQuery.close;
           PQuery.SQL.Clear;
           PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 AND CON_GROUP=:CONGROUP ORDER BY CON_NOM');
           PQuery.ParamByName('CONGROUP').AsString:=Favoris1.Items[i].Caption;
           PQuery.UpdateOptions.ReadOnly:=true;
           PQuery.Open;
           k:=0;
           while not(PQuery.Eof) do
                    begin

                         Menu := TMenuItem.Create(Favoris1.Items[i]);
                         Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
                         Favoris1.Items[i].Insert(k,Menu);
                         Menu.Tag:=PQuery.FieldByName('CON_ID').asinteger;
                         Menu.ImageIndex:=4+(PQuery.RecNo-1) mod 3;
                         Menu.OnClick:=tmf_Click;
                         PQuery.Next;
                         Inc(k);
                    end;
           PQuery.Close;
      end;
     PQuery.Free;
end;



procedure TFrm_KMANQUANTS.tmf_Click(Sender: TObject);
var PQuery:TFDQuery;
begin
     if not(FDconIB.Connected) then
        begin
             PQuery:=TFDQuery.Create(nil);
             PQuery.Connection:=FDconlite;
             PQuery.UpdateOptions.ReadOnly:=true;
             PQuery.SQL.Clear;
             PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 AND CON_ID=:CON_ID');
             PQuery.ParamByName('CON_ID').AsInteger:=TMenuItem(Sender).Tag;
             PQuery.Open;
             if not(PQuery.IsEmpty) then
                begin
                     teGROUP.Text:=PQuery.FieldByName('CON_GROUP').asstring;
                     teALIAS.Text:=PQuery.FieldByName('CON_NOM').asstring;
                     teSERVER.Text:=PQuery.FieldByName('CON_SERVER').asstring;
                     teDatabaseFile.Text:=PQuery.FieldByName('CON_DATABASE').asstring;
                end;
             PQuery.Close;
             PQuery.Free;
        end
        else
            begin
                 // MessageHint(Format('Veuillez au préalable vous déconnecter de %s.',[teALIAS.text]),BDISCONNECT);
            end;
end;
procedure TFrm_KMANQUANTS.SaveFavoris();
begin

end;

procedure TFrm_KMANQUANTS.AddFavoris;
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(nil);
     PQuery.Connection:=FDconlite;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_NOM=:CON_NOM');
     PQuery.ParamByName('CON_NOM').AsString:=teALIAS.Text;
     PQuery.Open;
     If (PQuery.IsEmpty)
        then
            begin
                 PQuery.Insert;
                 PQuery.FieldByName('CON_GROUP').AsString:=teGROUP.Text;
                 PQuery.FieldByName('CON_NOM').AsString:=teALIAS.Text;
                 PQuery.FieldByName('CON_SERVER').AsString:=teSERVER.Text;
                 PQuery.FieldByName('CON_DATABASE').AsString:=teDATABASEFile.Text;
                 PQuery.FieldByName('CON_FAV').Asinteger:=1;
                 PQuery.Post;
            end
        else
            begin
                 MessageHint('Alias déjà utilisé.',teALIAS);
            end;
     PQuery.Close;
     PQuery.Free;
end;

end.

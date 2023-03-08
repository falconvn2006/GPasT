unit Frm_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus,
  ImgList, ComCtrls, ToolWin, ShellAPI, DBClient, Buttons,
  DBGrids, DBCtrls, Grids, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Comp.ScriptCommands,
  FireDAC.Comp.Script,System.UITypes,System.IniFiles,UCheckUpdate,
  UThreadQuery, System.ImageList;

const ginkoia_url_path   = 'http://90.83.227.43:10074/tools/ws/';
      // yellis_url_path    = 'http://ginkoia.yellis.net/v2/ws/';
      gctrlb_script      = 'ws_gctrlb.php';
      // MaxWDPOSTExe       = 20;
      clBgL0             = $00DDDDDD;
      clBgL1             = $00FFFFFF;
      clError            = $002C2AE3;
      clOK               = $003AD932;
      GCBTitle = 'GCB - Version Client - Exe : %s / Db %s';
type
  TUserLevel = (ServiceClient,ServiceDeveloppement);    // Niveau de l'utilisateur

  TFavori = record
    Favori : string;
    Lame   : string;
    Started   : Boolean;
    CnxError  : Boolean;
    Done      : Boolean;
  end;
  TFavoris = array of TFavori;

  TMain_Frm = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    pnl2: TPanel;
    dstb: TDataSource;
    mm1: TMainMenu;
    Fichier1: TMenuItem;
    Quitter1: TMenuItem;
    N1: TMenuItem;
    Options1: TMenuItem;
    lbl2: TLabel;
    lbl3: TLabel;
    Favoris1: TMenuItem;
    Connections1: TMenuItem;
    Label1: TLabel;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    BConnect: TToolButton;
    BDISCONNECT: TToolButton;
    Bbtn4: TToolButton;
    Bbtn3: TToolButton;
    StatusBar1: TStatusBar;
    lbl_pleasewait: TLabel;
    pm_actions: TPopupMenu;
    outslctionner1: TMenuItem;
    outdsectionner1: TMenuItem;
    Pbar: TProgressBar;
    teALIAS: TEdit;
    teSERVER: TEdit;
    teDatabaseFile: TEdit;
    Btn_2: TBitBtn;
    BOuvrir: TBitBtn;
    pgc1: TPageControl;
    BHint: TBalloonHint;
    gridGeneral: TDBGrid;
    il2: TImageList;
    BSQL: TToolButton;
    ToolButton2: TToolButton;
    N2: TMenuItem;
    PublierNouvelleversion1: TMenuItem;
    TrayIcon: TTrayIcon;
    iltray: TImageList;
    pmtray: TPopupMenu;
    Restaurer1: TMenuItem;
    FDMemTable: TFDMemTable;
    FDMemTableID: TIntegerField;
    FDMemTableCHECK: TSmallintField;
    FDMemTableNOM: TStringField;
    FDMemTableNBATTENDU: TIntegerField;
    FDMemTableNBREEL: TIntegerField;
    FDMemTableETAT: TStringField;
    FDMemTableDETAILS: TStringField;
    FDMemTableCOMPARATEUR: TStringField;
    Gestion1: TMenuItem;
    Basculerdesroutinesenmasse1: TMenuItem;
    Label2: TLabel;
    TimerAllLame: TTimer;
    N3: TMenuItem;
    PauseScanLame: TMenuItem;
    procedure BouvrirClick(Sender: TObject);
    procedure Btn_2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxGrid1DBTableView1DETAILSPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Options1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Connections1Click(Sender: TObject);
    procedure tmf_Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure BConnectClick(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure teSERVERPropertiesChange(Sender: TObject);
    procedure BAnalyseDBClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure outdsectionner1Click(Sender: TObject);
    procedure outslctionner1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure gridGeneralDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gridGeneralDblClick(Sender: TObject);
    procedure gridGeneralCellClick(Column: TColumn);
    procedure gridGeneralKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BSQLClick(Sender: TObject);
    procedure teSERVERChange(Sender: TObject);
    procedure PublierNouvelleversion1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIconDblClick(Sender: TObject);
    procedure Restaurer1Click(Sender: TObject);
    procedure gridGeneralTitleClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure Basculerdesroutinesenmasse1Click(Sender: TObject);
    procedure TimerAllLameTimer(Sender: TObject);
    procedure PauseScanLameClick(Sender: TObject);
  private
    { Déclarations privées }
    FScanLame        : string;
    FFavoris         : TFavoris;
    FNbBoucleUpdates : integer;
    FExeUpdateThread : TExeUpdateThread;
    FUpdateThread  : TUpdateThread;
    FParamsExe     : string;
    FColumnIndex   : integer;
    Fauto          : Boolean;
    FNoUpdate      : Boolean;
    FLockUpdate    : Boolean;
    FDebug         : Boolean;
    FCanClose      : Boolean;
    FUrlPath       : string;
    FFavori        : string;
    FCSV           : string;
    GinkoiaVersion : string;
    DBVERSION      :string;
    FDBFile_Controle:string;
    procedure Chargement_ctrl;
    procedure InterBaseConnection;
    procedure CreateFavoris;
    procedure AddFavoris;
    procedure Parametrage_Screen;
    function Ctrl_une_ligne(Asql:TStrings):integer;
    procedure Save_Ini_BoucleUpdates();
    procedure Load_Param(aparam:string;avalue:string);
    procedure MessageHint(AMessage:string;AControl:TControl);
    procedure Lancement_Par_Thread;
    procedure SetUserLevel;
    procedure CallBackNewExeVersion(Sender:Tobject);
    procedure CallBackThreadScipts(Sender:Tobject);
    procedure CallBackNewVersion(Sender:Tobject);
    procedure CallBackWPost(Sender:Tobject);
    procedure MinimizeOnTrayIcon();
    procedure Lancement_Traitement(Const iNum:Integer=0);
    procedure SetLockUpdate(value:Boolean);
    procedure BlockAUto;
    procedure Nettoyage_OLD_Versions;
    procedure FlagScanLameDone;
  public
    property CanClose: boolean read FCanclose Write FCanClose;
    property LockUpdate : Boolean read FLockUpdate write SetLockUpdate;
    { Déclarations publiques }
  end;

var
  Main_Frm: TMain_Frm;

implementation

Uses UDataMod,UCommun, FUPDATE, frm_details, Frm_Options, Frm_Connexion,Frm_Publish, uLog,
  Frm_Bascule;

{$R *.dfm}

procedure TMain_Frm.SetLockUpdate(value:Boolean);
begin
    FLockUpdate      := Value;
    Main_Frm.Enabled := not(Value);
end;

procedure TMain_Frm.CallBackWPost(Sender:Tobject);
var I: Integer;
    vNbScans  : integer;
    vNbDone   : integer;
    vnbErrors : Integer;
begin
    // ----- en Mode "ScanLame" C'est plutot lui qui va fermer l'application
    if (FScanLame<>'') then
      begin
        // Comptage du nombre de Dossiers
        vNbScans  := 0;
        vnbDone   := 0;
        vnbErrors := 0;
        for i:= Low(FFavoris) to High(FFavoris) do
          begin
            if (FFavoris[i].Lame=FScanLame)
              then
                begin
                   Inc(vNbScans);
                   if (FFavoris[i].Done)
                      then
                        begin
                          Inc(vnbDone);
                        end;
                  If FFavoris[i].CnxError
                     then
                        begin
                          Inc(vnbErrors);
                        end;
                end;
          end;
        StatusBar1.Panels[1].Text := Format('ScanLame : %d/%d',[vnbDone+vnbErrors,vNbScans]);
        // Fermeture de la connexion
        If (CanClose and DataMod.FDConIB.Connected) then
            begin
                  DataMod.FDConIB.Close;
                  StatusBar1.Panels[0].Text:='Déconnecté';
                  BSQL.Visible:=False;
                  BSQL.Enabled:=False;
                  lbl2.Caption:='';
                  FDMemTable.Close;
                  Parametrage_Screen;
            end;
        If (vNbScans>0) then
          begin
            if (vnbDone+VnbErrors=vNbScans)
              then
                  begin
                     Close;
                  end
              else
                begin
                  // Réactivation du Timer
                  if not(PauseScanLame.Checked)
                     then TimerAllLame.Enabled:=true;
                end;
          end;
      end;
    if (Fauto) then
      begin
          Close;
      end;
end;

procedure TMain_Frm.SetUserLevel;
begin

end;

procedure TMain_Frm.Load_Param(aparam:string;avalue:string);
begin
     if aparam='urlpath'  then FUrlPath := avalue;
     if aparam='favori'   then FFavori  := avalue;
     if aparam='scanlame'     then
      begin
       FScanLame    := avalue;
       TimerAllLame.Enabled:=true;
      end;
     if aparam='csv'      then FCSV     := avalue;
end;

procedure TMain_Frm.BouvrirClick(Sender: TObject);
var VLP_OpenDialog:TOpenDialog;
begin
     If DataMod.FDConIB.Connected then exit;
     if (teDatabaseFile.Text<>'') then
        begin
             DataMod.FDConIB.Params.Clear;
             DataMod.FDConIB.Params.Add('DriverID=IB');
             DataMod.FDConIB.Params.Add('Server='+teSERVER.Text);
             DataMod.FDConIB.Params.Add('Database='+teDatabaseFile.Text);
        end
        else
        begin
             VLP_OpenDialog:=TOpenDialog.Create(nil);
             try
                VLP_OpenDialog.Filter := 'Fichiers interbase (*.ib)|*.IB';
                 if  VLP_OpenDialog.Execute
                   then
                   begin
                        teDatabaseFile.Text:=VLP_OpenDialog.FileName;
                        DataMod.FDConIB.Close;
                        DataMod.FDConIB.Params.Add('Server=localhost');
                        DataMod.FDConIB.Params.Add('Database='+VLP_OpenDialog.FileName);
                   end;
             finally
                FreeAndNil(VLP_OpenDialog);
             end;
        end;
end;

procedure TMain_Frm.BSQLClick(Sender: TObject);
begin
    {$IFDEF GCBLAME}
    Application.CreateForm(TForm_Details,Form_Details);
    Form_Details.STCID:=-1;
    Form_Details.Caption:='SQL';
    Form_Details.ParamEcranRequeteur;
    Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
    Form_Details.ShowModal;
    {$ENDIF}
end;

procedure TMain_Frm.InterBaseConnection;
var str:string;
    major_version:string;
    minor_version:string;

begin
    if (teDatabaseFile.Text<>'') then
        begin
             DataMod.FDConIB.Params.Clear;
             DataMod.FDConIB.Params.Add('DriverID=IB');
             DataMod.FDConIB.Params.Add('Server='+teSERVER.Text);
             DataMod.FDConIB.Params.Add('Database='+teDatabaseFile.Text);
             DataMod.FDConIB.Params.Add('User_Name=GINKOIA');
             DataMod.FDConIB.Params.Add('Password=ginkoia');
             DataMod.FDConIB.Params.Add('Protocol=TCPIP');
             teSERVER.Enabled:=false;
             teDatabaseFile.Enabled:=false;
             Try
                DataMod.FDConIB.open;
                str:=DataMod.GetVersionDBGinkoia;
                SplitString(str, '.', major_version, str);
                SplitString(str, '.', minor_version, str);
                GinkoiaVersion:= major_version ; //+'.'+minor_version;
                lbl2.Font.Style:=[FsBold];
                lbl2.Caption:=Format('Version de Ginkoia : %s',[GinkoiaVersion]);
                // tsGeneral.TabVisible:=true;
             except On E:Exception do
                   If not(Fauto) then MessageHint(E.Message+':'+E.ClassName,teDatabaseFile);
             End;
             if DataMod.FDConIB.Connected then
                begin
                     Chargement_ctrl;
                     if (FDMemTable.RecordCount>0) then
                      begin
                         Btn_2.Enabled:=true;
                         Btn_2.Visible:=true;
                         {$IFDEF GCBLAME}
                         BSQL.Visible:=true;
                         BSQL.Enabled:=true;
                         {$ENDIF}
                      end;
                     StatusBar1.Panels[0].Text:=Format('Connecté à %s : (%s@%s)',[teALIAS.Text,teSERVER.Text,teDatabaseFile.Text])
                end;
        end
end;

procedure TMain_Frm.CallBackThreadScipts(Sender:Tobject);
var i:integer;
    Grille:TGrille;
    Json_str:string;
    AWPOST:TWPost;
    AlogLvl:TLogLevel;
begin
    grille := TThreadScripts(Sender).Grille;
    Json_str:='';
      for i:=0 to High(Grille) do
        begin
            if (FDMemTable.Locate('ID',Grille[i].ID,[]))
              then
                begin
                    FDMemTable.Edit;
                    FDMemTable.FieldByName('ETAT').asstring := Grille[i].Etat;
                    // FDMemTable.FieldByName('COMPARATEUR').asstring := Grille[i].Comparateur;
                    FDMemTable.FieldByName('NBREEL').value  := Grille[i].NbResultats;
                    FDMemTable.Post;

                    if (FAuto) or (FScanLame<>'') then
                      begin
                          // Log nouvelle methode //
                          // Log.Log('aMdl','aRef','aKey',IntToStr(Grille[i].NbResultats),logInfo,true);
                          // Log ancienne methode //
                          if (FDMemTable.FieldByName('Check').AsInteger=1)
                              then
                                begin
                                  Json_str:=Json_str + Format('{n:%s,r:%d,o:%s,a:%d}',[
                                     stringReplace(FDMemTable.FieldByName('NOM').AsString,':','',[rfReplaceAll,rfIgnoreCase]),
                                       FDMemTable.FieldByName('NBREEL').asinteger,
                                       FDMemTable.FieldByName('COMPARATEUR').asstring,
                                       FDMemTable.FieldByName('NBATTENDU').asinteger]);
                                  AlogLvl:=Loginfo;
                                  if (FDMemTable.FieldByName('NBATTENDU').asinteger<>FDMemTable.FieldByName('NBREEL').asinteger)
                                    then AlogLvl:=LogError;
                                  Log.Log(teSERVER.Text,'',FFavori,teDatabaseFile.Text,'',FDMemTable.FieldByName('NOM').AsString,FDMemTable.FieldByName('NBREEL').asinteger,AlogLvl,true)
                                end;
                      end;
                end;
        end;
       // Log ancienne methode //
       // cdstb.Refresh;  <---- Ca fait planter le bouzin
       gridGeneral.Refresh;
       // -------------------------------------------------------------------------
       CanClose:=true;
       Pbar.Visible:=false;
       lbl_pleasewait.Visible:=False;
       Screen.Cursor:=CrDefault;
       gridGeneral.ReadOnly:=false;
       trayIcon.Animate:=false;
       TrayIcon.IconIndex:=0;
       Btn_2.Visible:=True;
       FDMemTable.EnableControls;
       // si on est en auto on pose les données
       TrayIcon.Hint := '';
       if (FAuto) or (FScanLame<>'') then
          begin
            FlagScanLameDone;

            Json_str:=Format('{d:%s,j:[%s]}',[teALIAS.text,Json_str]);
            AWPOST:=TWPost.Create(FUrlPath+gctrlb_script,Json_Str,'AB87931',CallBackWPOST);
            AWPOST.Resume;
//            DataMod.FDConIB.Close;
//            Close;
          end;
    Parametrage_Screen;
end;

procedure TMain_Frm.FlagScanLameDone;
var i:integer;
begin
  for i:= Low(FFavoris) to High(FFavoris) do
    begin
      if FFavoris[i].Started and not(FFavoris[i].Done)
        then
          begin
              FFavoris[i].Done :=true;
              exit;
          end;
    end;
end;

function TMain_Frm.Ctrl_une_ligne(Asql:TStrings):integer;
var PScript:TFDScript;
    PQuery:TFDQuery;
    i:integer;
    BufferSQL:string;
begin
     result:=-1;
     PQuery:=TFDQuery.Create(self);
     PQuery.Connection:=DataMod.FDconIB;
     PQuery.Transaction:=DataMod.FDtransIB;

     PScript:=TFDScript.Create(self);
     PScript.Connection:=DataMod.FDconIB;
     PScript.Transaction:=DataMod.FDtransIB;

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
                                     PQuery.Open;
                                     result:=PQuery.RecordCount;
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
                                 MessageDlg(Ez.Message, mtError, [mbOK], 0);
                            end;
                           end;
                    End;
        end;
     PQuery.Free;
     PScript.Free;
end;


procedure TMain_Frm.Options1Click(Sender: TObject);
begin
     Application.CreateForm(TFormOPTIONS,FormOPTIONS);
     FormOPTIONS.qliste.close;
     FormOPTIONS.qliste.Open;
     FormOPTIONS.Showmodal;
end;

procedure TMain_Frm.outdsectionner1Click(Sender: TObject);
var id:Integer;
begin
     FDMemTable.DisableControls;
     id:=FDMemTable.FieldByName('ID').AsInteger;
     FDMemTable.First;
     while not(FDMemTable.eof) do
        begin
             FDMemTable.Edit;
             FDMemTable.FieldByName('CHECK').AsInteger:=0;
             FDMemTable.Post;
             FDMemTable.Next;
        end;
     FDMemTable.Locate('ID',id,[]);
     FDMemTable.EnableControls;
end;

procedure TMain_Frm.outslctionner1Click(Sender: TObject);
var id:Integer;
begin
     FDMemTable.DisableControls;
     id:=FDMemTable.FieldByName('ID').AsInteger;
     FDMemTable.First;
     while not(FDMemTable.eof) do
        begin
             FDMemTable.Edit;
             FDMemTable.FieldByName('CHECK').AsInteger:=1;
             FDMemTable.Post;
             FDMemTable.Next;
        end;
     FDMemTable.Locate('ID',id,[]);
     FDMemTable.EnableControls;
end;

procedure TMain_Frm.Quitter1Click(Sender: TObject);
begin
     Close;
end;

procedure TMain_Frm.Restaurer1Click(Sender: TObject);
begin
   ShowWindow(Self.Handle, SW_SHOW);
   Show();
end;

procedure TMain_Frm.Lancement_Par_Thread;
var AThread:TThreadScripts;
    AGrille:TGrille;
    Ligne:TLigneGrille;
    i:integer;
    hSysMenu:HMENU;
begin
     // Désactivation
     CanClose:=false;
     TrayIcon.Animate:=true;
     Screen.Cursor:=CrHourGlass;
     FDMemTable.DisableControls;
     gridGeneral.ReadOnly:=true;
     Bouvrir.Visible:=False;
     BSQL.Enabled:=false;
     lbl_pleasewait.Visible:=True;
     // Constuction de AGrille
     SetLength(AGrille,0);
     i:=0;
     FDMemTable.First;
     while not(FDMemTable.eof) do
        begin
             SetLength(AGrille,Length(AGrille)+1);
             Ligne.ID:= FDMemTable.FieldByName('ID').AsInteger;
             Ligne.Checked := FDMemTable.FieldByName('CHECK').AsInteger=1;
             Ligne.Comparateur:=FDMemTable.FieldByName('COMPARATEUR').asstring;
             Ligne.Etat := '';
             Ligne.NBATTENDU   := FDMemTable.FieldByName('NBATTENDU').AsInteger;
             Ligne.NbResultats := null;
             AGrille[i]:=Ligne;
             inc(i);
             FDMemTable.Next;
        end;
     // Contruction du Thread
     AThread:=TThreadScripts.Create(AGrille,CallBackThreadScipts);

     AThread.Dossier := teALIAS.Text;
     if FCSV<>'' then
        AThread.CSVPath := VAR_GLOB.Exe_Directory + FCSV
     else
        AThread.CSVPath := VAR_GLOB.Exe_Directory + 'EXPORT';
     // Lancement du Thread
     AThread.Resume;
end;

procedure TMain_Frm.Btn_2Click(Sender: TObject);
begin
     Lancement_Traitement;
end;

procedure TMain_Frm.Lancement_Traitement(Const iNum:Integer=0);
begin
//     if Assigned(FUpdateThread)
//        then exit;
     if (DataMod.FDConIB.Connected) then
       begin
         TrayIcon.BalloonHint := 'Traitement en cours';
         Btn_2.Visible:=false;
         // Lancement_Ctrl;
         Lancement_Par_Thread;
       end
     else
       begin
           // Si pas connecté et en Auto on ferme l'application directe !
           if (FScanLame<>'') then
             begin
               // il faut aussi passer au suivant ==> le timer et le started/done permet de le faire
               // il faudrait dire "Erreur"
               If not(TimerAllLame.Enabled)
                 then
                    begin
                        If (iNum>=Low(FFavoris)) and (iNum<=High(FFavoris))
                          then FFavoris[iNum].CnxError:=true;
                        if Not(PauseScanLame.Checked)
                          then TimerAllLame.Enabled:=true;
                    end;
             end;
           if (FAuto) and (FScanLame='') then
             begin
               Application.ProcessMessages;
               Application.Terminate;
               exit;
             end;
       end;
    Parametrage_Screen;
end;

procedure TMain_Frm.Chargement_ctrl;
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconliteGCTRLB;
     PQuery.SQL.Clear;
     PQuery.SQL.Add(Format('SELECT * FROM SCRCTRL WHERE SUBSTR(SCT_VERSION,%d,1)=''1'' ORDER BY SCT_NOM',[GetintegerGinkoiaVX(GinkoiaVersion)]));
     PQuery.Prepare;
     PQuery.Open;
     FDMemTable.Close;
     FDMemTable.DisableControls;
     FDMemTable.CreateDataSet;
     FDMemTable.open;
     while not(PQuery.eof) do
        begin
             if FAuto then
                begin
                     if (PQuery.FieldByName('SCT_CHECK').AsInteger=1) then
                       begin
                           FDMemTable.Append;
                           FDMemTable.FieldByName('ID').asinteger:=PQuery.FieldByName('SCT_ID').asinteger;
                           FDMemTable.FieldByName('CHECK').asinteger:=PQuery.FieldByName('SCT_CHECK').asinteger;
                           FDMemTable.FieldByName('COMPARATEUR').asstring:=PQuery.FieldByName('SCT_COMPARATEUR').asstring;
                           FDMemTable.FieldByName('ETAT').asstring:='';
                           FDMemTable.FieldbyName('NOM').asstring:=PQuery.FieldByName('SCT_NOM').asstring;
                           FDMemTable.FieldbyName('NBATTENDU').asinteger:=PQuery.FieldByName('SCT_NBRESULT').asinteger;
                           FDMemTable.post;
                       end;
                end
             else
               begin
                 FDMemTable.Append;
                 FDMemTable.FieldByName('ID').asinteger:=PQuery.FieldByName('SCT_ID').asinteger;
                 FDMemTable.FieldByName('CHECK').asinteger:=PQuery.FieldByName('SCT_CHECK').asinteger;
                 FDMemTable.FieldByName('COMPARATEUR').asstring:=PQuery.FieldByName('SCT_COMPARATEUR').asstring;
                 FDMemTable.FieldByName('ETAT').asstring:='';
                 FDMemTable.FieldbyName('NOM').asstring:=PQuery.FieldByName('SCT_NOM').asstring;
                 FDMemTable.FieldbyName('NBATTENDU').asinteger:=PQuery.FieldByName('SCT_NBRESULT').asinteger;
                 FDMemTable.post;
               end;
             PQuery.Next;
        end;
     FDMemTable.EnableControls;
     PQuery.Close;
     PQuery.Free;
end;

procedure TMain_Frm.Connections1Click(Sender: TObject);

begin
     Application.CreateForm(TfrmConnexion,frmConnexion);
     frmConnexion.qliste.close;
     frmConnexion.qliste.Open;
     frmConnexion.Showmodal;
     CreateFavoris;
end;

procedure TMain_Frm.BAnalyseDBClick(Sender: TObject);
//r PQuery:TFDQuery;
begin
{    If DataMod.FDConIB.Connected then
        begin
              PQuery:=TFDQuery.Create(DataMod);
              PQuery.Connection:=DataMod.FDConIB;
              PQuery.Close;
              PQuery.UpdateOptions.ReadOnly:=true;
              PQuery.SQL.Clear;
              PQuery.SQL.Add('SELECT TMP$CACHE_BUFFERS, ');
              PQuery.SQL.Add('  TMP$ALLOCATED_PAGES,    ');
              PQuery.SQL.Add('  TMP$OLDEST_INTERESTING, ');
              PQuery.SQL.Add('  TMP$OLDEST_ACTIVE,      ');
              PQuery.SQL.Add('  TMP$NEXT_TRANSACTION,   ');
              PQuery.SQL.Add('  TMP$CACHE_POOL_MEMORY,  ');
              PQuery.SQL.Add('  TMP$CURRENT_MEMORY,     ');
              PQuery.SQL.Add('  TMP$MAXIMUM_MEMORY      ');
              PQuery.SQL.Add('FROM TMP$DATABASE');
              PQuery.Open;
              mdstatus.Close;
              mdstatus.CreateDataSet;
              mdstatus.open;
              if not(PQuery.Eof) then
                  begin
                       //------------
                       mdstatus.Insert;
                       mdstatus.FieldByName('PARAM').asstring:='Cache Buffers';
                       mdstatus.FieldByName('VALUE').AsString:=PQuery.FieldByName('TMP$CACHE_BUFFERS').AsString;
                       mdstatus.post;
                       //------------
                       mdstatus.Insert;
                       mdstatus.FieldByName('PARAM').asstring:='Taille en Pages';
                       mdstatus.FieldByName('VALUE').AsString:=PQuery.FieldByName('TMP$ALLOCATED_PAGES').AsString;
                       mdstatus.post;
                       //------------
                       mdstatus.Insert;
                       mdstatus.FieldByName('PARAM').asstring:='Current Memory';
                       mdstatus.FieldByName('VALUE').AsString:=PQuery.FieldByName('TMP$CURRENT_MEMORY').AsString;
                       mdstatus.post;
                       //------------
                       mdstatus.Insert;
                       mdstatus.FieldByName('PARAM').asstring:='Next Transaction';
                       mdstatus.FieldByName('VALUE').AsString:=PQuery.FieldByName('TMP$NEXT_TRANSACTION').AsString;
                       mdstatus.post;
                       //------------
                       mdstatus.Insert;
                       mdstatus.FieldByName('PARAM').asstring:='Oldest Active';
                       mdstatus.FieldByName('VALUE').AsString:=PQuery.FieldByName('TMP$OLDEST_ACTIVE').AsString;
                       mdstatus.post;
                       //------------
                  end;
              PQuery.Close;
              PQuery.Free;
        end;
        }
end;

procedure TMain_Frm.Basculerdesroutinesenmasse1Click(Sender: TObject);
begin
  Application.CreateForm(Tform_Bascule,Form_Bascule);
  Form_Bascule.Showmodal;
end;

procedure TMain_Frm.MessageHint(AMessage:string;AControl:TControl);
var Pt: TPoint;
begin
     BHint.Title:='Attention';
     BHint.Style:=bhsBalloon;
     BHint.Description := AMessage;
     Pt.X := AControl.Width Div 2;
     Pt.Y := AControl.Height;
     BHint.ShowHint(AControl.ClientToScreen(Pt));
end;

procedure TMain_Frm.BConnectClick(Sender: TObject);

begin
     if (teDatabaseFile.Text<>'') then
        begin
             Try
                InterBaseConnection;
                Except On E : Exception do
                  begin
                       MessageHint(Format('Erreur de Connexion à la base',[teSERVER.Text]),teSERVER);
                  end;
             End;
        end
        else
            begin
                  MessageHint(Format('Veuillez saisir le chemin relatif de la base par rapport au serveur %s.',[teSERVER.Text]),teDatabaseFile);
            end;
    Parametrage_Screen;
end;

procedure TMain_Frm.Parametrage_Screen;
begin
    if CanClose then
        begin
            BConnect.Enabled:=not(DataMod.FDConIB.Connected);
            BDISCONNECT.Enabled:=(DataMod.FDConIB.Connected);
            teALIAS.Enabled:=not(DataMod.FDConIB.Connected);
            teSERVER.Enabled:=not(DataMod.FDConIB.Connected);
            teDatabaseFile.Enabled:=not(DataMod.FDConIB.Connected);
            Btn_2.Visible:=DataMod.FDConIB.Connected;
            Favoris1.Enabled     := true;
            Bbtn3.Enabled        := true;
            Connections1.Enabled := true;
        end
    else
      begin
            BConnect.Enabled:=False;
            BSQL.Enabled:=False;
            BDISCONNECT.Enabled:=False;
            teALIAS.Enabled:=False;
            teSERVER.Enabled:=False;
            teDatabaseFile.Enabled:=False;
            Btn_2.Visible:=False;
            Favoris1.Enabled:=false;
            Bbtn3.Enabled:=false;
            Connections1.Enabled:=false;
      end;
end;


procedure TMain_Frm.PauseScanLameClick(Sender: TObject);
begin
    ///dsfgdf
    ///  A faire
    if (FScanLame<>'') then
      begin
         If PauseScanLame.Checked
          then
            begin
               StatusBar1.Panels[2].Text := 'Pause';
               // ShowMessage('ckecked')
               TimerAllLame.Enabled:=false;
//               not(TimerAllLame.Enabled);
            end
          else
            begin
               StatusBar1.Panels[2].Text := 'Continue';
                // ShowMessage('unckecked');
               TimerAllLame.Enabled:=True;
            end;
      end;
end;

procedure TMain_Frm.PublierNouvelleversion1Click(Sender: TObject);
begin
     If Var_Glob.ComputerName<>LameMaitre
        then
            begin
                 MessageDlg(
                     Format('Vous n''êtes pas sur %s. Vous êtes sur %s. ' +#13+#10 +
                            'Vous n''êtes donc pas le Maitre de la base de contrôle.',
                            [LameMaitre,Var_Glob.ComputerName])
                      ,  mtError, [mbOk], 0);
                 exit;
            end
        else
            begin
                 Application.CreateForm(TPublish_Frm,Publish_Frm);
                 Publish_Frm.eNextVersion.Text := DataMod.GetVersionDB_GCB;
                 Publish_Frm.ELocalPath.Text   := DataMod.FDConLiteGCTRLB.Params.Database;
                 Publish_Frm.EnewDBLocalFile.Text := LocalPath + 'gcb_db_version_' + StringReplace(Publish_Frm.eNextVersion.Text,'.','',[rfReplaceAll]) +  '.zip';
                 Publish_Frm.eNewURL.Text         := UrlPath + 'gcb_db_version_'   + StringReplace(Publish_Frm.eNextVersion.Text,'.','',[rfReplaceAll]) +  '.zip';
                 Publish_Frm.Showmodal;
            end;
end;

procedure TMain_Frm.cxButton1Click(Sender: TObject);
begin
//
end;

procedure TMain_Frm.cxButton2Click(Sender: TObject);
begin
    If (CanClose and DataMod.FDConIB.Connected) then
        begin
             if MessageDlg('Voulez-vous vraiment vous déconnecter de la base ?',  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
             begin
                  DataMod.FDConIB.Close;
                  StatusBar1.Panels[0].Text:='Déconnecté';
                  BSQL.Visible:=False;
                  BSQL.Enabled:=False;
                  lbl2.Caption:='';
                  FDMemTable.Close;
             end;
           Parametrage_Screen;
        end;
end;

procedure TMain_Frm.cxButton3Click(Sender: TObject);
begin
     if (teALIAS.Text='')
        then MessageHint('Veuillez saisir un Alias pour cette connexion.',teALIAS);
     if (teSERVER.Text='')
        then MessageHint('Veuillez saisir un Serveur pour cette connexion.',teSERVER);
     if (teDatabaseFile.Text='')
        then MessageHint('Veuillez saisir un Chemin pour cette connexion.',teDatabaseFile);

     if (teALIAS.Text='') or (teSERVER.Text='') or (teDatabaseFile.Text='') then exit;

     If DataMod.FDconliteconnexion.Connected then
        begin
             AddFavoris;
             CreateFavoris;
        end;
end;

procedure TMain_Frm.cxGrid1DBTableView1DETAILSPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
    if AButtonIndex=0 then
      begin
          Application.CreateForm(TForm_Details,Form_Details);
          Form_Details.STCID:=FDMemTableID.Value;
          Form_Details.Caption:=Format('Détails - %s',[FDMemTableNOM.value]);
          Form_Details.Load;
          Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
          Form_Details.Showmodal;
      end;
end;

procedure TMain_Frm.FormActivate(Sender: TObject);
begin
    FixDBGridColumnsWidth(gridgeneral);
end;

procedure TMain_Frm.MinimizeOnTrayIcon();
begin
   Self.Hide;
   ShowWindow(Application.Handle, SW_HIDE);
   SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
   Application.ProcessMessages;
   {$IfDef GCBCLIENT}
    TrayIcon.BalloonTitle  := Caption; // 'GCBClient Version ' + DBVersion;
   {$EndIf}
   {$IfDef GCBLAME}
    TrayIcon.BalloonTitle  := 'GCBLame Version ' + DBVersion;
   {$EndIf}
   If TrayIcon.BalloonHint<>''
      then TrayIcon.ShowBalloonHint();
end;



procedure TMain_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if CanClose
      then
          begin
            Action:=caFree;
            FNbBoucleUpdates := 0;
            Save_Ini_BoucleUpdates;
            If FAuto then Log.SaveIni();
          end
      else
        begin
            // Minimise l'application et cache l'icône
            MinimizeOnTrayIcon();
            Action := caNone;
        end;
end;

procedure TMain_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   // FCanClose:=true;
   // CanClose:=FCanClose;
end;

procedure TMain_Frm.CallBackNewExeVersion(Sender:Tobject);
begin
    try
      If (TExeUpdateThread(Sender).ShellUpdate) then
          begin
            Inc(FNbBoucleUpdates);
            Save_Ini_BoucleUpdates;
            //------------------ On relance-------------------------------------
            ShellExecute(0,'OPEN', PWideChar(Application.ExeName), PWideChar(FParamsExe), nil, SW_SHOW);
            // RenameFile(Application.ExeName,Application.ExeName+'.old');
            Application.Terminate;
          end
      else
          begin
            FUpdateThread := TUpdateThread.Create(DBVERSION,Lbl2,CallBackNewVersion);
            FUpdateThread.LocalFile:= ExtractFilePath(Application.ExeName) + FDBFile_Controle;
            FUpdateThread.Resume;
            LockUpdate:=true;
            // Pas d'update du programme on repasse à zéro
          end;
     finally

     end;
end;


procedure TMain_Frm.CallBackNewVersion(Sender:Tobject);
begin
    try
        If (TUpdateThread(Sender).VersionDispo) then
           begin
               // Déconnexion des bases
               DataMod.FDconliteconnexion.Connected:=false;
               DataMod.FDConLiteGCTRLB.Connected:=false;
               //---
               {
               Application.CreateForm(TFormUPDATE,FormUPDATE);
               FormUPDATE.url:=TUpdateThread(Sender).RemoteFile;
               FormUPDATE.LocalFile:= ExtractFilePath(Application.ExeName) + FDBFile_Controle;
               // 'controle.s3db';
               FormUPDATE.RemoteVersion:=TUpdateThread(Sender).RemoteVersion;
               // Caption:='....Nouvelle version disponible...';
               FormUPDATE.Showmodal;
               }

               DataMod.FDConLiteGCTRLB.open;
               DBVERSION:=DataMod.GetVersionDB_GCB;
               // := 'Contrôles Base de données Ginkoia - Version Client - DBVERSION : ' + ;
               Caption := Format(GCBTitle,[GetInfo('Version'),DBVERSION]);
            end;
     finally
         // FreeAndNil(FUpdateThread);
         LockUpdate := False;
         DataMod.FDconliteconnexion.Connected:=true;
         FNbBoucleUpdates := 0;
         Save_Ini_BoucleUpdates;
         BlockAuto;
     end;
end;

procedure TMain_Frm.Nettoyage_OLD_Versions;
begin
    // On delete les fichiers GCB*.old et GCB.new;
    Deletefiles(ExtractFilePath(ParamStr(0)),'*.old');
    Deletefiles(ExtractFilePath(ParamStr(0)),'*.new');
    FParamsExe := GetParamsExe();
    Label2.Caption := 'Params : '+ FParamsExe;
end;

procedure TMain_Frm.Save_Ini_BoucleUpdates;
var ini : TIniFile ;
    ia: Integer;
begin
    Ini := TIniFile.Create(VAR_GLOB.Exe_Directory + 'GCB.ini');
      try
        Ini.WriteInteger('GENERAL','boucleupdate',FNbBoucleUpdates);
      finally
        Ini.Free;
      end;
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
    //    AMenuItem:TMenuItem;
    Ini:TIniFile;
    DBFile_Connexion:string;
    //    bfound :boolean;
begin
     SetLength(FFavoris,0);

     // FUpdateThread := nil;
     // ExeUpdate
     Nettoyage_OLD_Versions;
     FLockUpdate  := false;
     FColumnIndex:=-1;
     FCanClose:=true;
     //-------------------------------------------------------------------------
     Ini := TIniFile.Create(VAR_GLOB.Exe_Directory + 'GCB.ini');
      try
       DBFile_Connexion := Ini.ReadString('GENERAL','connexion','');
       FDBFile_Controle := Ini.ReadString('GENERAL','controle','');
       FNbBoucleUpdates := Ini.ReadInteger('GENERAL','boucleupdate',0);
       DataMod.SQLiteStartConnexion(DBFile_Connexion,FDBFile_Controle);
      finally
        Ini.Free;
      end;
     FUrlPath := ginkoia_url_path;
     FCSV := '';
     FAuto:=False;
     FFavori:='';
     FScanLame:='';
     Fdebug:=false;
     FNoUpdate := false;

     SetUserLevel;
     for i :=1 to ParamCount do
      begin
            If lowercase(ParamStr(i))='-auto'  then FAuto  := true;
            If lowercase(ParamStr(i))='-noupdate'  then FNoUpdate := true;
            // If lowercase(ParamStr(i))='-root'  then UserLevel := ServiceDeveloppement;
            If lowercase(ParamStr(i))='-debug' then FDebug := true;
            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-urlpath' then Load_Param('urlpath',value);
            If lowercase(param)='-favori'  then Load_Param('favori',value);
            If lowercase(param)='-csv'   then Load_Param('csv',value);
            If lowercase(param)='-scanlame'  then Load_Param('scanlame',value);
      end;
     //-------------------------------------------------------------------------

     // Sécurité si jamais on boucle dans l'update !
     // c'est le cas si la version à téléchanger est plus petit que le nombre
     // indiqué dans le fichier json
     if (FNbBoucleUpdates>1) then FNoUpdate := true;

     {$IfDef GCBLAME}
        FNoUpdate:=true;
     {$ENDIF}

     {$IFDEF GCBCLIENT}
     if not(FNoUpdate)
         then
           begin
               FExeUpdateThread := TExeUpdateThread.Create(Application.ExeName,Lbl2,CallBackNewExeVersion);
               FExeUpdateThread.Resume;
               LockUpdate:=true;
            end;
     {$ENDIF}

     If DataMod.FDconliteconnexion.Connected then
        begin
             CreateFavoris;
        end;

     If DataMod.FDConLiteGCTRLB.Connected then
        begin
             // récupération de la version
             DBVERSION:=DataMod.GetVersionDB_GCB;
             {$IFDEF GCBCLIENT}
             // Fermeture du fichier... sinon il va rester locké et on pourra pas le récuperer
             DataMod.FDConLiteGCTRLB.Close;
             PublierNouvelleversion1.Visible:=false;
             PublierNouvelleversion1.Enabled:=false;
             N2.Visible:=false;
             // Si on est en Auto il faut pas lancer la maj... sinon ca merde
             if not(FNoUpdate)
               then
                 begin
                   {
                   FUpdateThread := TUpdateThread.Create(DBVERSION,Lbl2,CallBackNewVersion);
                   FUpdateThread.LocalFile:= ExtractFilePath(Application.ExeName) + FDBFile_Controle;
                   FUpdateThread.Resume;
                   FLockUpdate:=true;
                   }
                 end;
             {$ENDIF}
        end;

     Parametrage_Screen;

    { ------------- Faut attendre que le Thread d'update se termine -----------}
    { AMenuItem:=nil;
     if ((Fauto) and (FFavori<>'')) then
        begin
             I := 0;
             bfound := false;
             while not(bfound) and (i<Favoris1.Count)  do
                begin
                    AMenuItem:=Favoris1.Items[i].Find(FFavori);
                    bfound:=AMenuItem<>nil;
                    Inc(i);
                end;
             Log.App:='GCB';
             Log.Inst:='1';
             Log.Open;
             if AMenuItem<>nil then
                begin
                     AMenuItem.Click;
                     // BConnect.Click;
                End
        end
        else
          begin
              Application.MainFormOnTaskbar := true;
              Application.ShowMainForm      := true;
          end;
     }

     {$IfDef GCBCLIENT}
     // Caption := 'Contrôles Base de données Ginkoia - Version Client - DBVERSION : ' + DBVERSION;
     Caption := Format(GCBTitle,[GetInfo('Version'),DBVERSION]);
     Options1.Enabled:=false;
     Options1.Visible:=false;
     BSQL.Visible:=false;
     BSQL.Enabled:=false;
     {$EndIf}
     {$IfDef GCBLAME}
     Caption := 'Contrôles Base de données Ginkoia - Version Lame - DBVERSION : ' + DBVERSION;
     Options1.Enabled:=true;
     Options1.Visible:=true;
     {$EndIf}

     if (FNoUpdate)
       then
         begin
            BlockAuto;
         end;



{    NAN c'est plus ici mais à la fin du Thread d'update
     if (FAuto) and (FFavori<>'')
       then
           begin
              if (AMenuItem<>nil)
                then
                    begin
                        Log.Log('','',FFavori,'','status','OK',logInfo,true);
                        Lancement_Traitement;
                        MinimizeOnTrayIcon();
                    end
                else
                    begin
                        // Mode Auto mais favori introuvable !
                        // il faut sortir...
                        Log.Log('','',FFavori,'','status','KO',logError,true);
                        CanClose:=true;
                        // Close;
                        // Application.Terminate;
                    end;
           end;
}
end;

// On va passer par un Timer








procedure TMain_Frm.BlockAuto;
var i:integer;
    AMenuItem:TMenuItem;
    bfound :boolean;
begin
     AMenuItem:=nil;
     if ((Fauto) and (FFavori<>'')) then
        begin
             I := 0;
             bfound := false;
             while not(bfound) and (i<Favoris1.Count)  do
                begin
                    AMenuItem:=Favoris1.Items[i].Find(FFavori);
                    bfound:=AMenuItem<>nil;
                    Inc(i);
                end;
             Log.App:='GCB';
             Log.Inst:='1';
             Log.Open;
             if AMenuItem<>nil then
                begin
                     AMenuItem.Click;
                     BConnect.Click;
                End;
           Application.MainFormOnTaskbar := false;
           Application.ShowMainForm      := false;
        end;
    if (FAuto) and (FFavori<>'')
       then
             begin
              if (AMenuItem<>nil)
                then
                    begin
                        Log.Log('','',FFavori,'','','status','OK',logInfo,true);
                        Lancement_Traitement;
                        MinimizeOnTrayIcon();
                    end
                else
                    begin
                        // Mode Auto mais favori introuvable !
                        // il faut sortir...
                        Log.Log('','',FFavori,'','','status','KO',logError,true);
                        CanClose:=true;
                        Close;
                        Application.Terminate;
                    end;
             end;
end;

procedure TMain_Frm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     BHint.HideHint;
end;

procedure TMain_Frm.FormShow(Sender: TObject);
begin
    // if (FAuto) and (FCanClose) and (FFavori<>'') then close;
end;

procedure TMain_Frm.gridGeneralCellClick(Column: TColumn);
var Coord: TGridCoord;
    mouseInGrid : TPoint;
begin
    If FDMemTable.IsEmpty then Exit;
    if gridGeneral.ReadOnly then exit;
    mouseInGrid := gridGeneral.ScreenToClient(Mouse.CursorPos) ;
    Coord := gridGeneral.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
    if not (dgTitles in gridGeneral.Options) then Exit;
    If (Coord.X=7) then
    begin
         Application.CreateForm(TForm_Details,Form_Details);
         Form_Details.STCID:=FDMemTableID.Value;
         Form_Details.Caption:=Format('Détails - %s',[FDMemTableNOM.value]);
         Form_Details.Load;
         Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
         Form_Details.Showmodal;
    end;
    If (Coord.X=1) then
    begin
         FDMemTable.DisableControls;
         FDMemTable.Edit;
         FDMemTable.FieldByName('CHECK').AsInteger:=(FDMemTable.FieldByName('CHECK').AsInteger+1) mod 2;
         FDMemTable.Post;
         FDMemTable.EnableControls;
    end;
end;

procedure TMain_Frm.gridGeneralDblClick(Sender: TObject);
var Coord: TGridCoord;
    mouseInGrid : TPoint;
begin
    If FDMemTable.IsEmpty then Exit;
    mouseInGrid := gridGeneral.ScreenToClient(Mouse.CursorPos) ;
    Coord := gridGeneral.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
    if not (dgTitles in gridGeneral.Options) then Exit;
    If (Coord.X=7) then
    begin
         Application.CreateForm(TForm_Details,Form_Details);
         Form_Details.STCID:=FDMemTableID.Value;
         Form_Details.Caption:=Format('Détails - %s',[FDMemTableNOM.value]);
         Form_Details.Load;
         Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
         Form_Details.Showmodal;
    end;
    If (Coord.X=1) then
    begin
         FDMemTable.DisableControls;
         FDMemTable.Edit;
         FDMemTable.FieldByName('CHECK').AsInteger:=(FDMemTable.FieldByName('CHECK').AsInteger+1) mod 2;
         FDMemTable.Post;
         FDMemTable.EnableControls;
    end;
end;

procedure TMain_Frm.gridGeneralDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var  BRect:TRect;
begin
  if (Column.Field.FieldName = 'CHECK') then
    begin
        if (gdFocused in State) or (gdSelected In State) then
        begin
             // gridGeneral.Canvas.FillRect(Rect);
             TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
             // gridGeneral.Canvas.FillRect(Rect);
        end
          else
          begin
            if (TDBGrid(Sender).DataSource.DataSet.RecNo mod 2) = 0
             then TDBGrid(Sender).Canvas.Brush.Color := clBgL0
             else TDBGrid(Sender).Canvas.Brush.Color := clBgL1;
          end;
        gridGeneral.Canvas.FillRect(Rect);

        il2.draw(gridGeneral.Canvas,
            rect.Left + ((rect.Right - rect.Left - il2.Width) div 2),
            rect.Top,
        column.Field.AsInteger);
    end;
  if (Column.Field.FieldName = 'DETAILS') then
    begin
        {
        if (gdFocused in State) or (gdSelected In State) then
          begin
               // gridGeneral.Canvas.FillRect(Rect);
               TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
               // gridGeneral.Canvas.FillRect(Rect);
          end
         else
         begin
               gridGeneral.Canvas.Brush.Color:=pnl1.Color;
         end;
         gridGeneral.Canvas.FillRect(Rect);
         }
         if (gdFocused in State) or (gdSelected In State) then
          begin
               // gridGeneral.Canvas.FillRect(Rect);
               TDBGrid(Sender).Canvas.Pen.Color:= $00FFFFFF;
               TDBGrid(Sender).Canvas.Brush.Color := clHighlight;
               gridGeneral.Canvas.FillRect(Rect);
          end
          else
          begin
            TDBGrid(Sender).Canvas.Pen.Color:= $00FFFFFF;
            if (TDBGrid(Sender).DataSource.DataSet.RecNo mod 2) = 0
             then TDBGrid(Sender).Canvas.Brush.Color := clBgL0
             else TDBGrid(Sender).Canvas.Brush.Color := clBgL1;
            gridGeneral.Canvas.FillRect(Rect);
          end;
//         TDBGrid(Sender).Canvas.FillRect(Rect);

         BRect:=Rect;
         BRect.left:=BRect.left+1;
         BRect.Right:=BRect.Right-1;
         BRect.top:=BRect.top+1;
         BRect.bottom:=BRect.bottom-1;
         TDBGrid(Sender).Canvas.Pen.Color:= $00FFFFFF;
         TDBGrid(Sender).Canvas.Brush.Color := $00BBBBBB;
         // TDBGrid(Sender).Canvas.FillRect(Rect);
         TDBGrid(Sender).Canvas.Rectangle(BRect);
         TDBGrid(Sender).Canvas.Pen.Color:= $00FFFFFF;
         TDBGrid(Sender).Canvas.Font.Size := 8;
         TDBGrid(Sender).Canvas.TextOut(Rect.Left+10,Rect.Top+2,'Détails..');


         // gridGeneral.Canvas.Pen.Color:=clRed;
         // gridGeneral.Canvas.TextRect(Rect,5,2,'Voir...');
    end;

  if (Column.Field.FieldName = 'ETAT') then
      begin
          if  (FDMemTable.FieldByName('ETAT').asstring='Erreur') then
            begin
              gridGeneral.Canvas.Brush.Color := clError;
              gridGeneral.Canvas.Font.Color  := clblack;
              gridGeneral.Canvas.FillRect(Rect);
              TDBGrid(Sender).Canvas.TextOut(Rect.Left,Rect.Top+2,'Erreur');
               exit;
            end;
          if  (FDMemTable.FieldByName('ETAT').asstring='OK') then
            begin
              gridGeneral.Canvas.Brush.Color := clOK;
              gridGeneral.Canvas.Font.Color  := clBlack;
              gridGeneral.Canvas.FillRect(Rect);
              TDBGrid(Sender).Canvas.TextOut(Rect.Left+2,Rect.Top+2,'OK');
               exit;
            end;
      end;
  // Sinon
  if (Column.Field.FieldName <> 'CHECK') and (Column.Field.FieldName <> 'DETAILS') then
     begin
          if gdSelected in State then
            begin
               gridGeneral.Canvas.Brush.Color := clHighlight;
               gridGeneral.Canvas.Font.Color := clHighlightText;
               gridGeneral.Canvas.FillRect(Rect);
            end
          else
            begin
                if (TDBGrid(Sender).DataSource.DataSet.RecNo mod 2) = 0
                  then TDBGrid(Sender).Canvas.Brush.Color := clBgL0
                  else TDBGrid(Sender).Canvas.Brush.Color := clBgL1;
            end;
          gridGeneral.DefaultDrawColumnCell(rect,datacol,column,state);
     end;
end;

procedure TMain_Frm.gridGeneralKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If FDMemTable.IsEmpty then Exit;
     if Key=VK_SPACE then
        begin
         FDMemTable.DisableControls;
         FDMemTable.Edit;
         FDMemTable.FieldByName('CHECK').AsInteger:=(FDMemTable.FieldByName('CHECK').AsInteger+1) mod 2;
         FDMemTable.Post;
         FDMemTable.EnableControls;
        end;
     if Key=VK_RETURN then
        begin
         Application.CreateForm(TForm_Details,Form_Details);
         Form_Details.STCID:=FDMemTableID.Value;
         Form_Details.Caption:=Format('Détails - %s',[FDMemTableNOM.value]);
         Form_Details.Load;
         Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
         Form_Details.Showmodal;
        end;
end;

procedure TMain_Frm.gridGeneralTitleClick(Column: TColumn);
begin
  If not(CanClose) then exit;
  if GridGeneral.DataSource.DataSet is TDataSet then
  with TFDMemTable(Gridgeneral.DataSource.DataSet) do
  begin
    If FColumnIndex>=0 then
      Gridgeneral.Columns[FColumnIndex].title.Font.Style :=
      Gridgeneral.Columns[FColumnIndex].title.Font.Style - [fsBold];

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

procedure TMain_Frm.AddFavoris;
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconliteconnexion;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_NOM=:CON_NOM');
     PQuery.ParamByName('CON_NOM').AsString:=teALIAS.Text;
     PQuery.Open;
     If (PQuery.IsEmpty)
        then
            begin
                 PQuery.Insert;
                 PQuery.FieldByName('CON_NOM').AsString:=teALIAS.Text;
                 PQuery.FieldByName('CON_SERVER').AsString:=teSERVER.Text;
                 PQuery.FieldByName('CON_PATH').AsString:=teDATABASEFile.Text;
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


procedure TMain_Frm.CreateFavoris;
var PQuery:TFDQuery;
    Menu,ParentMenu:TMenuItem;
    i,j:integer;
begin
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconliteconnexion;
     PQuery.SQL.Clear;
     Favoris1.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 ORDER BY CON_NOM');
     PQuery.UpdateOptions.ReadOnly:=true;
     PQuery.Open;
     // faire par lettre
     for i:=65 to 90 do
      begin
          Menu := TMenuItem.Create(Self);
          Menu.Name:='Menu_Favori_'+Chr(i);
          Menu.Caption := Format('%s',[Chr(i)]);
          // Menu.ImageIndex:=4+i mod 3;
          Favoris1.Insert(i-65,Menu);
          Menu.Tag:=0;
      end;

     while not(PQuery.Eof) do
        begin
             // il faut trouver la première lettre
             ParentMenu:=TMenuItem(FindComponent('Menu_Favori_'+PQuery.FieldbyName('CON_NOM').asstring[1]));
             if (ParentMenu<>nil)
              then
                 begin
                     Menu := TMenuItem.Create(Self);
                     Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
                     ParentMenu.Add(Menu);
                     Menu.Tag:=PQuery.FieldByName('CON_ID').asinteger;
                     Menu.ImageIndex:=4+(PQuery.RecNo-1) mod 3;
                     Menu.OnClick:=tmf_Click;
                     // On va remplir un
                     j:=Length(FFavoris);
                     SetLength(FFavoris,j+1);
                     FFavoris[j].Favori := PQuery.FieldbyName('CON_NOM').asstring;
                     FFavoris[j].Lame   := PQuery.FieldbyName('CON_SERVER').asstring;
                     FFavoris[j].Started   := false;
                     FFavoris[j].Done      := false;
                     FFavoris[j].CnxError  := false;
                 end;
             PQuery.Next;
        end;
     PQuery.Close;
     PQuery.Free;
end;

procedure TMain_Frm.teSERVERChange(Sender: TObject);
begin
     BOuvrir.Visible:= (teSERVER.Text='') or (Pos('localhost',teSERVER.Text)>0)
end;

procedure TMain_Frm.teSERVERPropertiesChange(Sender: TObject);
begin
     Bouvrir.Enabled:=(UpperCase(teSERVER.Text)='LOCALHOST') or
                      (UpperCase(teSERVER.text)='127.0.0.1') or
                      (UpperCase(teSERVER.text)='')
end;

procedure TMain_Frm.TimerAllLameTimer(Sender: TObject);
var AMenuItem:TMenuItem;
    bfound :boolean;
    i,j:Integer;
begin
     TimerAllLame.Enabled:=False;
     for I := Low(FFavoris) to High(FFavoris) do
      begin
         if (FFavoris[i].Lame=FScanLame) and not(FFavoris[i].Started) and not(FFavoris[i].Done)
           then
              begin
                 AMenuItem:=nil;
                 j := 0;
                 bfound := false;
                 while not(bfound) and (j<Favoris1.Count)  do
                    begin
                        AMenuItem:=Favoris1.Items[j].Find(FFavoris[i].Favori);
                        bfound:=AMenuItem<>nil;
                        Inc(j);
                    end;
                 if AMenuItem<>nil then
                    begin
                         AMenuItem.Click;
                         BConnect.Click;
                         Application.ProcessMessages;
                         FFavoris[i].Started:=true;
                         Lancement_Traitement(i);
                         exit;
                        // MinimizeOnTrayIcon();
                    end
              end;
          //--------------------------------------------------------------------
          if (i=High(FFavoris)) and (FFavoris[i].Started) and (FFavoris[i].Done)
            then
              begin
                Close;
              end;
      end;
end;

{     AMenuItem:=nil;
     if ((Fauto) and (FLame<>'')) then
        begin
             // On passe au suivant
             bfound := false;
             i:=0;
             while not(bfound) and (i<Favoris1.Count)  do
                begin
                    while not(bfound) and (j<Favoris1.Items[i].Count) do
                       begin
                            AMenuItem:=Favoris1.Items[i].Items[j].Tag=FNextCONID;
                            bfound:=AMenuItem<>nil;
                            Inc(i);
                       end;
                end;
             if AMenuItem<>nil then
                begin
                     AMenuItem.Click;
                     BConnect.Click;
                End;
           Application.MainFormOnTaskbar := false;
           Application.ShowMainForm      := false;
        end;
        }


procedure TMain_Frm.tmf_Click(Sender: TObject);
var PQuery:TFDQuery;
begin
     if not(DataMod.FDconIB.Connected) then
        begin
             PQuery:=TFDQuery.Create(DataMod);
             PQuery.Connection:=DataMod.FDconliteconnexion;
             PQuery.UpdateOptions.ReadOnly:=true;
             PQuery.SQL.Clear;
             PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 AND CON_ID=:CON_ID');
             PQuery.ParamByName('CON_ID').AsInteger:=TMenuItem(Sender).Tag;
             PQuery.Open;
             if not(PQuery.IsEmpty) then
                begin
                     teALIAS.Text:=PQuery.FieldByName('CON_NOM').asstring;
                     teSERVER.Text:=PQuery.FieldByName('CON_SERVER').asstring;
                     teDatabaseFile.Text:=PQuery.FieldByName('CON_PATH').asstring;
                end;
             PQuery.Close;
             PQuery.Free;
        end
        else
            begin
                 MessageHint(Format('Veuillez au préalable vous déconnecter de %s.',[teALIAS.text]),BDISCONNECT);
            end;
end;

procedure TMain_Frm.TrayIconDblClick(Sender: TObject);
begin
   ShowWindow(Self.Handle, SW_SHOW);
   Show();
end;

end.

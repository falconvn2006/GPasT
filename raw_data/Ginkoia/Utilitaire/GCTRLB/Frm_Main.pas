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
  FireDAC.Comp.Script,System.UITypes,MidasLib;

const ginkoia_url_path   = 'http://90.83.227.43:10074/tools/ws/';
      yellis_url_path   = 'http://ginkoia.yellis.net/v2/ws/';
      gctrlb_script      = 'ws_gctrlb.php';
      MaxWDPOSTExe       = 20;
      clBgL0             = $00DDDDDD;
      clBgL1             = $00FFFFFF;
      clError            = $002C2AE3;
      clOK               = $003AD932;

type
  TUserLevel = (ServiceClient,ServiceDeveloppement);    // Niveau de l'utilisateur
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
    Aide1: TMenuItem;
    Misejour1: TMenuItem;
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
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    dsjetons: TDataSource;
    Panel2: TPanel;
    dsStatus: TDataSource;
    lbl_pleasewait: TLabel;
    dsconnexions: TDataSource;
    pm_actions: TPopupMenu;
    outslctionner1: TMenuItem;
    outdsectionner1: TMenuItem;
    bJetons: TBitBtn;
    Pbar: TProgressBar;
    teALIAS: TEdit;
    teSERVER: TEdit;
    teDatabaseFile: TEdit;
    mdJETONS: TClientDataSet;
    mdJETONSPoste: TStringField;
    mdJETONSDateHeure: TDateTimeField;
    mdJETONSBase: TStringField;
    mdJETONSSender: TStringField;
    BAnalyseDB: TBitBtn;
    Btn_2: TBitBtn;
    BOuvrir: TBitBtn;
    cdstb: TClientDataSet;
    cdstbID: TIntegerField;
    cdstbCHECK: TSmallintField;
    cdstbNOM: TStringField;
    cdstbCTRLNBRESULT: TIntegerField;
    cdstbNBLIGNES: TIntegerField;
    mdstatus: TClientDataSet;
    mdstatusPARAM: TStringField;
    mdstatusVALUE: TStringField;
    mdconnexions: TClientDataSet;
    mdconnexionsUSER: TStringField;
    mdconnexionsIP: TStringField;
    mdconnexionsHOST: TStringField;
    mdconnexionsTIMESTAMP: TDateTimeField;
    mdconnexionsQUANTUM: TIntegerField;
    pgc1: TPageControl;
    tsgeneral: TTabSheet;
    tsConnexions: TTabSheet;
    tsEtat: TTabSheet;
    dbgrd1: TDBGrid;
    BHint: TBalloonHint;
    dbgrd2: TDBGrid;
    dbgrd_jetons: TDBGrid;
    gridGeneral: TDBGrid;
    il2: TImageList;
    cdstbDETAILS: TStringField;
    cdstbETAT: TStringField;
    N2: TMenuItem;
    Motdepasse1: TMenuItem;
    BSQL: TToolButton;
    ToolButton2: TToolButton;
    procedure BouvrirClick(Sender: TObject);
    procedure Btn_2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Misejour1Click(Sender: TObject);
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
    procedure BJetons1Click(Sender: TObject);
    procedure BAnalyseDBClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure ScriptsqlsurConnexion1Click(Sender: TObject);
    procedure outdsectionner1Click(Sender: TObject);
    procedure outslctionner1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure gridGeneralDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gridGeneralDblClick(Sender: TObject);
    procedure gridGeneralCellClick(Column: TColumn);
    procedure gridGeneralKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Motdepasse1Click(Sender: TObject);
    procedure BSQLClick(Sender: TObject);
    procedure teSERVERChange(Sender: TObject);
  private
    { Déclarations privées }
    FUserLevel  : TUserLevel;
    Fauto       : Boolean;
    FDebug      : Boolean;
    FUrlPath    : string;
    FFavori     : string;
    GinkoiaVersion : string;
    procedure Chargement_ctrl;
    procedure InterBaseConnection;
    procedure Lancement_Ctrl;
    procedure CreateFavoris;
    procedure AddFavoris;
    procedure Parametrage_Screen;
    function  Ctrl_une_ligne(Asql:TStrings):integer;
    procedure Load_Param(aparam:string;avalue:string);
    procedure MessageHint(AMessage:string;AControl:TControl);
    procedure FSetUserLevel(Avalue:TUserLevel);
  public
    { Déclarations publiques }
    property UserLevel: TUserLevel read FUserLevel write FSetUserLevel;
  end;

var
  Main_Frm: TMain_Frm;

implementation

Uses UDataMod,UCommun, FUPDATE, frm_details, Frm_Options, Frm_Connexion,
  PASSWORD;

{$R *.dfm}

procedure TMain_Frm.FSetUserLevel(Avalue:TUserLevel);
begin
     FUserLevel:=Avalue;
     if UserLevel=ServiceClient then
       begin
           Caption := 'Contrôles Base de données Ginkoia - Version ' + GetInfo('Version');
           Options1.Enabled:=false;
           BSQL.Visible:=false;
           BSQL.Enabled:=false;
       end
     else
       begin
           Caption := 'Contrôles Base de données Ginkoia - Version ' + GetInfo('Version') + ' - Mode : Service Développement';
           Options1.Enabled:=true;
       end;
end;

procedure TMain_Frm.Load_Param(aparam:string;avalue:string);
begin
     if aparam='urlpath'  then FUrlPath := avalue;
     if aparam='favori'   then FFavori  := avalue;
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
     if UserLevel=ServiceDeveloppement then
        begin
           Application.CreateForm(TForm_Details,Form_Details);
           Form_Details.STCID:=-1;
           Form_Details.Caption:='SQL';
           Form_Details.ParamEcranRequeteur;
           Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
           Form_Details.ShowModal;
        end;
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
             DataMod.FDConIB.Params.Add('User_Name=SYSDBA');
             DataMod.FDConIB.Params.Add('Password=masterkey');
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
                if (UserLevel=ServiceDeveloppement) then
                  begin
                      tsconnexions.TabVisible:=true;
                      If (StrToInt(major_version)>=12) { and (UserLevel=ServiceDeveloppement) }
                        then
                            begin
                                 tsconnexions.Caption:='Connexions && Jetons';
                                 dbgrd_jetons.Visible:=true;
                                 tsEtat.TabVisible:=true;
                            end
                        else
                          begin
                               tsconnexions.Caption:='Connexions';
                               dbgrd_jetons.Visible:=false;
                               tsEtat.TabVisible:=true;
                          end;
                  end;
                tsGeneral.TabVisible:=true;
             except On E:Exception do
                   If not(Fauto) then MessageHint(E.Message+':'+E.ClassName,teDatabaseFile);
             End;
             if DataMod.FDConIB.Connected then
                begin
                     Btn_2.Enabled:=true;
                     Btn_2.Visible:=true;
                     BSQL.Visible:=UserLevel=ServiceDeveloppement;
                     BSQL.Enabled:=UserLevel=ServiceDeveloppement;
                     Chargement_ctrl;
                     StatusBar1.Panels[0].Text:=Format('Connecté à %s : (%s@%s)',[teALIAS.Text,teSERVER.Text,teDatabaseFile.Text])
                end;
        end
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

     for i:= 0 to  Asql.Count-1 do
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
                                     // PQuery.Prepare;
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



procedure TMain_Frm.Lancement_Ctrl;
var SQuery:TFDQuery;
    chknb:Integer;
    hSysMenu:HMENU;
    nbresultats:Integer;
    xSQL:TStringList;
    Json_str:string;
    Parametres:string;
    sAuto:string;
    sNewFileName:string;
begin
     if FAuto
      then sAuto:='-auto '
      else sAuto:='';
     // Pour les tests "-debug"
     if FDebug then sAuto:='';

     Self.Enabled:=false;
     Screen.Cursor:=CrHourGlass;
     hSysMenu:=GetSystemMenu(Self.Handle, False);
      if hSysMenu<>0 then
        begin
             EnableMenuItem(hSysMenu,SC_CLOSE,MF_BYCOMMAND or MF_GRAYED);
             DrawMenuBar(Self.Handle);
        end;
     Bouvrir.Visible:=False;
     lbl_pleasewait.Visible:=True;

     SQuery:=TFDQuery.Create(DataMod);
     SQuery.Connection:=DataMod.FDconliteGCTRLB;

     cdstb.DisableControls;
     chknb:=0;
     if not(cdstb.IsEmpty) then
       begin
           cdstb.First;
           while not(cdstb.eof) do
              begin
                   if (cdstb.FieldByName('CHECK').AsInteger=1)
                      then Inc(chknb);
                   cdstb.Edit;
                   cdstb.FieldByName('NBREEL').Value:=null;
                   cdstb.FieldByName('ETAT').asstring:='';
                   cdstb.Post;
                   cdstb.Next;
              end;
       end;
     cdstb.EnableControls;
     Pbar.Position:=0;
     Pbar.Max:=chknb;
     Pbar.Visible:=true;
     cdstb.First;
     xSQL:=TStringList.Create;
     while not(cdstb.eof) do
        begin
             if (cdstb.FieldByName('CHECK').AsInteger=1)
                then
                    begin
                         try
                            cdstb.Edit;
                            cdstb.FieldByName('ETAT').asstring:='En cours';
                            cdstb.Post;
                            Application.ProcessMessages;
                            SQuery.Close;
                            SQuery.SQL.Clear;
                            SQuery.SQL.Add('SELECT SCT_QUERY FROM SCRCTRL WHERE SCT_ID=:ID');
                            SQuery.ParamByName('ID').AsInteger:=cdstb.FieldByName('ID').asinteger;
                            SQuery.Prepare;
                            SQuery.Open;

                            // PQuery.Close;
                            // PQuery.SQL.Clear;
                            // PQuery.SQL.Add(SQuery.FieldByName('SCT_QUERY').AsString);
                            // MessageDlg(PQuery.SQL.Text, mtWarning, [mbOK], 0);


                            // PQuery.Prepare;
                            Application.ProcessMessages;
                            // PQuery.Open;
                            xSQL.Clear;
                            xSQL.Text:=SQuery.FieldByName('SCT_QUERY').Value;
                            xSQL.Add('^');
                            nbresultats := Ctrl_une_ligne(xSQL);

                            cdstb.Edit;
                            cdstb.FieldByName('NBREEL').asinteger:=nbresultats;
                            if (cdstb.FieldbyName('NBATTENDU').asinteger<>nbresultats)
                              then cdstb.FieldByName('ETAT').asstring:='Erreur'
                              else cdstb.FieldByName('ETAT').asstring:='OK';

//                            if (PQuery.IsEmpty)
//                                then dxmdtmdttb.FieldByName('ETAT').asinteger:=1
//                                else dxmdtmdttb.FieldByName('ETAT').asinteger:=0;
                            cdstb.Post;
                            Pbar.Position:=Pbar.Position+1;
                            Application.ProcessMessages;
                         Except


                         end;
                    end
                else
                    begin
                         cdstb.Edit;
                         cdstb.FieldByName('NBREEL').Value:=null;
                         cdstb.FieldByName('ETAT').asstring:='';
                         cdstb.Post;
                    end;
             cdstb.Next;
             Pbar.Refresh;
             Application.ProcessMessages;
        end;

     cdstb.First;
     { ----------- si en Auto on envoie les résultats à wdpost ----------------}
     if FAuto then
        begin
             Json_str:='';
             while not(cdstb.Eof) do
              begin
                   if (cdstb.FieldByName('Check').AsInteger=1) then
                      begin
                          Json_str:=Json_str + Format('{n:%s,a:%d,r:%d}',[
                              stringReplace(cdstb.FieldByName('NOM').AsString,':','',[rfReplaceAll,rfIgnoreCase]),
                              cdstb.FieldByName('NBATTENDU').asinteger,
                              cdstb.FieldByName('NBREEL').asinteger
                              ]
                           );
                      end;
                   cdstb.Next;
                   // MessageDlg(Json_str, mtWarning, [mbOK], 0);
              end;
              if length(Json_str)>MAX_JSONLENGTH then
                 begin
                    sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_gctrlb','.tmp');
                    SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[teALIAS.text,Json_str]));
                    Parametres:=Format('%s-url=%s -psk=AB87931 -file="%s"',[
                    sauto,
                    FUrlPath+gctrlb_script,
                    sNewFileName]);
                 end
               else
                 begin
                  Parametres:=Format('%s-url=%s -psk=AB87931 -json="d:%s,j:[%s]"',[
                      sAuto,
                      FUrlPath+gctrlb_script,
                      teALIAS.text,
                      Json_str]);
                 end;
             ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
        end;
     //cdstb.Refresh;
     cdstb.EnableControls;
    // cdstb.Refresh;

     xSQL.Free;
     // PQuery.Close;
     // PQuery.Free;

     SQuery.Close;
     SQuery.Free;
     Pbar.Visible:=false;
     hSysMenu:=GetSystemMenu(Self.Handle, False);
     if hSysMenu<>0 then
        begin
             EnableMenuItem(hSysMenu, SC_CLOSE, MF_BYCOMMAND);
             DrawMenuBar(Self.Handle);
        end;
     lbl_pleasewait.Visible:=False;
     Screen.Cursor:=CrDefault;
     Self.Enabled:=True;
end;

procedure TMain_Frm.Misejour1Click(Sender: TObject);
begin
     Application.CreateForm(TFormUPDATE,FormUPDATE);
     FormUPDATE.Showmodal;
end;

procedure TMain_Frm.Motdepasse1Click(Sender: TObject);
begin
     Application.CreateForm(TFormPASSWORD,FormPASSWORD);
     FormPASSWORD.ShowModal;
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
     cdstb.DisableControls;
     id:=cdstb.FieldByName('ID').AsInteger;
     cdstb.First;
     while not(cdstb.eof) do
        begin
             cdstb.Edit;
             cdstb.FieldByName('CHECK').AsInteger:=0;
             cdstb.Post;
             cdstb.Next;
        end;
     cdstb.Locate('ID',id,[]);
     cdstb.EnableControls;
end;

procedure TMain_Frm.outslctionner1Click(Sender: TObject);
var id:Integer;
begin
     cdstb.DisableControls;
     id:=cdstb.FieldByName('ID').AsInteger;
     cdstb.First;
     while not(cdstb.eof) do
        begin
             cdstb.Edit;
             cdstb.FieldByName('CHECK').AsInteger:=1;
             cdstb.Post;
             cdstb.Next;
        end;
     cdstb.Locate('ID',id,[]);
     cdstb.EnableControls;
end;

procedure TMain_Frm.Quitter1Click(Sender: TObject);
begin
     Close;
end;

procedure TMain_Frm.ScriptsqlsurConnexion1Click(Sender: TObject);
begin
     if DataMod.FDconliteconnexion.Connected
       then
           begin
               DataMod.FDconliteconnexion.open;
               DataMod.ExecuteMyScript('myscript.sql');
           end;
end;

procedure TMain_Frm.Btn_2Click(Sender: TObject);
begin
     if (DataMod.FDConIB.Connected) then
       begin
         Btn_2.Visible:=false;
         Lancement_Ctrl;
         Btn_2.Visible:=True;
         // si on auto on ferme
          if FAuto then
            begin
              DataMod.FDConIB.Close;
              Close;
            end;
       end
     else
       begin
           // Si pas connecté et en Auto on ferme l'application directe !
           if FAuto then
            begin
              Close;
            end;
       end;
end;

procedure TMain_Frm.Chargement_ctrl;
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconliteGCTRLB;
     PQuery.SQL.Clear;
     PQuery.SQL.Add(Format('SELECT * FROM SCRCTRL WHERE SUBSTR(SCT_VERSION,%d,1)=''1'' ORDER BY SCT_NOM',[GetintegerGinkoiaVX(GinkoiaVersion)]));
     // MessageDlg(PQuery.SQL.Text, mtWarning, [mbOK], 0);
     PQuery.Prepare;
     PQuery.Open;
     cdstb.Close;
     cdstb.DisableControls;
     cdstb.CreateDataSet;
     cdstb.open;
     while not(PQuery.eof) do
        begin
             if (PQuery.FieldByName('SCT_CHECK').AsInteger=1) or (UserLevel=ServiceDeveloppement) then
               begin
                     cdstb.Append;
                     cdstb.FieldByName('ID').asinteger:=PQuery.FieldByName('SCT_ID').asinteger;
                     cdstb.FieldByName('CHECK').asinteger:=PQuery.FieldByName('SCT_CHECK').asinteger;
                     cdstb.FieldByName('ETAT').asstring:='';
                     cdstb.FieldbyName('NOM').asstring:=PQuery.FieldByName('SCT_NOM').asstring;
                     cdstb.FieldbyName('NBATTENDU').asinteger:=PQuery.FieldByName('SCT_NBRESULT').asinteger;
                     cdstb.post;
               end;
             PQuery.Next;
        end;
     cdstb.EnableControls;
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
var PQuery:TFDQuery;
begin
     If DataMod.FDConIB.Connected then
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
    BConnect.Enabled:=not(DataMod.FDConIB.Connected);
    BDISCONNECT.Enabled:=(DataMod.FDConIB.Connected);
    teALIAS.Enabled:=not(DataMod.FDConIB.Connected);
    teSERVER.Enabled:=not(DataMod.FDConIB.Connected);
    teDatabaseFile.Enabled:=not(DataMod.FDConIB.Connected);
    Btn_2.Visible:=DataMod.FDConIB.Connected;
end;


procedure TMain_Frm.BJetons1Click(Sender: TObject);
var PQuery:TFDquery;
begin
     If DataMod.FDConIB.Connected then
        begin
              PQuery:=TFDQuery.Create(DataMod);
              PQuery.Connection:=DataMod.FDConIB;
              PQuery.Close;
              PQuery.UpdateOptions.ReadOnly:=true;
              PQuery.Close;
              PQuery.SQL.Clear;
              PQuery.SQL.Add('Select * FROM TMP$ATTACHMENTS');
              PQuery.Open;
              mdconnexions.Close;
              mdconnexions.CreateDataSet;
              mdconnexions.Open;
              while not(PQuery.eof) do
                          begin
                                mdconnexions.Insert;
                                mdconnexions.FieldByName('USER').AsString:=PQuery.FieldByName('TMP$USER').asstring;
                                mdconnexions.FieldByName('IP').AsString:=PQuery.FieldByName('TMP$USER_IP_ADDR').asstring;
                                mdconnexions.FieldByName('HOST').AsString:=PQuery.FieldByName('TMP$USER_HOST').asstring;
                                mdconnexions.FieldByName('TIMESTAMP').asdatetime:=PQuery.FieldByName('TMP$TIMESTAMP').asdatetime;
                                mdconnexions.FieldByName('QUANTUM').asinteger:=PQuery.FieldByName('TMP$QUANTUM').asinteger;
                                mdconnexions.Post;
                                PQuery.Next;
                          end;
             PQuery.Close;
             if dbgrd_jetons.Visible then
                begin
                      PQuery.Close;
                      PQuery.SQL.Clear;
                      PQuery.SQL.Add('SELECT JET_NOMPOSTE, JET_STAMP, BAS_NOM, BAS_SENDER FROM GENJETONS JOIN GENBASES ON JET_BASID=BAS_ID');
                      PQuery.Open;
                      mdJETONS.DisableControls;
                      mdJETONS.Close;
                      mdJETONS.CreateDataSet;
                      mdJETONS.open;
                      while not(PQuery.eof) do
                          begin
                               mdJETONS.Insert;
                               mdJETONS.FieldByName('Poste').AsString:=PQuery.FieldByName('JET_NOMPOSTE').AsString;
                               mdJETONS.FieldByName('DateHeure').AsDateTime:=PQuery.FieldByName('JET_STAMP').AsDateTime;
                               mdJETONS.FieldByName('Base').AsString:=PQuery.FieldByName('BAS_NOM').AsString;
                               mdJETONS.FieldByName('Sender').AsString:=PQuery.FieldByName('BAS_SENDER').AsString;
                               mdJETONS.Post;
                               PQuery.Next;
                          end;
                      mdJETONS.EnableControls;
                end;
             PQuery.Close;
             PQuery.Free;
        end;
end;

procedure TMain_Frm.cxButton1Click(Sender: TObject);
begin
//
end;

procedure TMain_Frm.cxButton2Click(Sender: TObject);
begin
     If DataMod.FDConIB.Connected then
        begin
             if MessageDlg('Voulez-vous vraiment vous déconnecter de la base ?',  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
             begin
                  DataMod.FDConIB.Close;
                  StatusBar1.Panels[0].Text:='Déconnecté';
                  tsconnexions.TabVisible:=false;
                  tsEtat.TabVisible:=false;
                  BSQL.Visible:=False;
                  BSQL.Enabled:=False;
                  lbl2.Caption:='';
                  cdstb.Close;
             end;
        end;
    Parametrage_Screen;
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
          Form_Details.STCID:=cdstbID.Value;
          Form_Details.Caption:=Format('Détails - %s',[cdstbNOM.value]);
          Form_Details.Load;
          Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
          Form_Details.Showmodal;
      end;
end;

procedure TMain_Frm.FormActivate(Sender: TObject);
begin
    FixDBGridColumnsWidth(gridgeneral);

    if FAuto
      then Btn_2.Click;


end;

procedure TMain_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action:=caFree;
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
    AMenuItem:TMenuItem;
begin
     //-------------------------------------------------------------------------
     FUrlPath:=ginkoia_url_path;
     FAuto:=False;
     FFavori:='';
     Fdebug:=false;
     UserLevel := ServiceClient;
     for i :=1 to ParamCount do
      begin
            If lowercase(ParamStr(i))='-auto'  then FAuto  := true;
            If lowercase(ParamStr(i))='-root'  then UserLevel := ServiceDeveloppement;
            If lowercase(ParamStr(i))='-debug' then FDebug := true;
            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-urlpath' then Load_Param('urlpath',value);
            If lowercase(param)='-favori'  then Load_Param('favori',value);
      end;
     //-------------------------------------------------------------------------

     If DataMod.FDconliteconnexion.Connected then
        begin
             CreateFavoris;
        end;
     tsConnexions.TabVisible:=False;
     tsEtat.TabVisible:=false;
     Parametrage_Screen;

     if ((Fauto) and (FFavori<>'')) then
        begin
             AMenuItem:=Favoris1.Find(FFavori);
             if AMenuItem<>nil then
                begin
                     AMenuItem.Click;
                     BConnect.Click;
                End;
        end;
end;

procedure TMain_Frm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     BHint.HideHint;
end;

procedure TMain_Frm.gridGeneralCellClick(Column: TColumn);
var Coord: TGridCoord;
    mouseInGrid : TPoint;
begin
    If cdstb.IsEmpty then Exit;
    mouseInGrid := gridGeneral.ScreenToClient(Mouse.CursorPos) ;
    Coord := gridGeneral.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
    if not (dgTitles in gridGeneral.Options) then Exit;
    If (Coord.X=6) then
    begin
         Application.CreateForm(TForm_Details,Form_Details);
         Form_Details.STCID:=cdstbID.Value;
         Form_Details.Caption:=Format('Détails - %s',[cdstbNOM.value]);
         Form_Details.Load;
         Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
         Form_Details.Showmodal;
    end;
    If (Coord.X=1) then
    begin
         cdstb.DisableControls;
         cdstb.Edit;
         cdstb.FieldByName('CHECK').AsInteger:=(cdstb.FieldByName('CHECK').AsInteger+1) mod 2;
         cdstb.Post;
         cdstb.EnableControls;
    end;
end;

procedure TMain_Frm.gridGeneralDblClick(Sender: TObject);
var Coord: TGridCoord;
    mouseInGrid : TPoint;
begin
    If cdstb.IsEmpty then Exit;
    mouseInGrid := gridGeneral.ScreenToClient(Mouse.CursorPos) ;
    Coord := gridGeneral.MouseCoord(mouseInGrid.X, mouseInGrid.Y);
    if not (dgTitles in gridGeneral.Options) then Exit;
    If (Coord.X=6) then
    begin
         Application.CreateForm(TForm_Details,Form_Details);
         Form_Details.STCID:=cdstbID.Value;
         Form_Details.Caption:=Format('Détails - %s',[cdstbNOM.value]);
         Form_Details.Load;
         Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
         Form_Details.Showmodal;
    end;
    If (Coord.X=1) then
    begin
         cdstb.DisableControls;
         cdstb.Edit;
         cdstb.FieldByName('CHECK').AsInteger:=(cdstb.FieldByName('CHECK').AsInteger+1) mod 2;
         cdstb.Post;
         cdstb.EnableControls;
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
          if  (cdstb.FieldByName('ETAT').asstring='Erreur') then
            begin
              gridGeneral.Canvas.Brush.Color := clError;
              gridGeneral.Canvas.Font.Color  := clblack;
              gridGeneral.Canvas.FillRect(Rect);
              TDBGrid(Sender).Canvas.TextOut(Rect.Left,Rect.Top+2,'Erreur');
               exit;
            end;
          if  (cdstb.FieldByName('ETAT').asstring='OK') then
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
     If cdstb.IsEmpty then Exit;
     if Key=VK_SPACE then
        begin
         cdstb.DisableControls;
         cdstb.Edit;
         cdstb.FieldByName('CHECK').AsInteger:=(cdstb.FieldByName('CHECK').AsInteger+1) mod 2;
         cdstb.Post;
         cdstb.EnableControls;
        end;
     if Key=VK_RETURN then
        begin
         Application.CreateForm(TForm_Details,Form_Details);
         Form_Details.STCID:=cdstbID.Value;
         Form_Details.Caption:=Format('Détails - %s',[cdstbNOM.value]);
         Form_Details.Load;
         Form_Details.StatusBar.Panels[0].Text:=StatusBar1.Panels[0].Text;
         Form_Details.Showmodal;
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
    Menu:TMenuItem;
begin
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDconliteconnexion;
     PQuery.SQL.Clear;
     Favoris1.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 ORDER BY CON_NOM');
     PQuery.UpdateOptions.ReadOnly:=true;
     PQuery.Open;
     while not(PQuery.Eof) do
        begin
             Menu := TMenuItem.Create(Self);
             Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
             Favoris1.Insert(PQuery.RecNo-1,Menu);
             Menu.Tag:=PQuery.FieldByName('CON_ID').asinteger;
             Menu.ImageIndex:=4+(PQuery.RecNo-1) mod 3;
             Menu.OnClick:=tmf_Click;
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

end.

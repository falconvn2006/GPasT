unit Frm_JetMon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Datasnap.DBClient, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, Data.DB, Vcl.Menus, Vcl.AppEvnts, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Samples.Spin, ShellAPI, Vcl.Buttons,Math, MidasLib,
  Vcl.ComCtrls, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, WinSvc,System.IniFiles,ServiceControler;

const ServiceJeton   = 'ServiceJETON';
      ServiceMonitor = 'ServiceMonitor';

type
  TFormVJETON = class(TForm)
    dsjeton: TDataSource;
    TimerJETON: TTimer;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    Quitter1: TMenuItem;
    Ouvrir1: TMenuItem;
    N2: TMenuItem;
    TimerMONITOR: TTimer;
    PageControl1: TPageControl;
    TSJETON: TTabSheet;
    TSMONITOR: TTabSheet;
    DBGrid1: TDBGrid;
    FDQJETON: TFDQuery;
    BStartMonitor: TBitBtn;
    BStopMonitor: TBitBtn;
    spMonitor: TSpinEdit;
    Label4: TLabel;
    FDQMONITOR: TFDQuery;
    DBGrid2: TDBGrid;
    dsMonitor: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    BStartJETON: TBitBtn;
    BstopJETON: TBitBtn;
    spJETON: TSpinEdit;
    BConnexion: TBitBtn;
    PopupMenu2: TPopupMenu;
    jPause: TMenuItem;
    jreprendre: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TimerJETONTimer(Sender: TObject);
    procedure spJETONChange(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Ouvrir1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Quitter1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure btnBConnexionClick(Sender: TObject);
    procedure BstopJETONClick(Sender: TObject);
    procedure BStartJETONClick(Sender: TObject);
    procedure mStopClick(Sender: TObject);
    procedure mStartClick(Sender: TObject);
    procedure TimerMONITORTimer(Sender: TObject);
    procedure Dsactiver1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure BStopMonitorClick(Sender: TObject);
    procedure BStartMonitorClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure Mettreenpause1Click(Sender: TObject);
    procedure JetonPauseOnOffClick(Sender: TObject);
  private
    FStop    : boolean;
    Ftempo   : Integer;        // tempo en seconde
    procedure Rafraichissement(DataSet:TDataset);
    procedure DefaultHandler(var Msg); override;
    procedure Ecran;
    { Déclarations privées }
  public
    procedure ActiveDesactiveFavori(Const AIBFILE:string='';AEnable:Boolean=true);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    function GetStop():boolean;
    procedure SetStop(Avalue:Boolean);

    { Déclarations publiques }
  property
    Stop:Boolean read GetStop write setStop;
  end;

var
  FormVJETON: TFormVJETON;
  MyMsg: Cardinal;
  MessageSys_Kill : UINT; // Message recherché
  MessageSys_Stop : UINT; // Message recherché
  MessageSys_Show : UINT; // Message recherché
  MessageSys_Resume : UINT; // Message recherché
  MessageSys_DBStop : UINT;
  MessageSys_DBResume : UINT;

implementation

{$R *.dfm}

Uses UDataMod,UCommun, Frm_Connexion;


function TFormVJETON.GetStop():boolean;
begin
     result:=FStop;
end;

procedure TFormVJETON.MenuItem1Click(Sender: TObject);
begin
     ServiceStop('',ServiceJeton);
     ActiveDesactiveFavori(FDQJETON.FieldByName('JET_DATABASE').asstring,true);
     ServiceStart('',ServiceJeton);
end;

procedure TFormVJETON.Mettreenpause1Click(Sender: TObject);
begin
  ///
  ///
  ///
end;

procedure TFormVJETON.DefaultHandler;
var HandleAppliExt: THandle;
    HandleRecepteur: THandle;
    MonEdit: THandle;
    MonTexte: Array [0..255] of Char; // Message à afficher
    bstop:boolean;
begin
  inherited DefaultHandler(Msg);
  if (TMessage(Msg).Msg=MessageSys_Kill) then
    begin
      Stop:=true;
      Application.Terminate; // On ferme l'application
    end;
  if (TMessage(Msg).Msg=MessageSys_Stop) then
    begin
      Stop:=true;
    end;
  if (TMessage(Msg).Msg=MessageSys_Resume) then
    begin
      Stop:=false;
    end;
  if (TMessage(Msg).Msg=MessageSys_DBStop) then
    begin
      bstop:=Stop;
      Stop:=True;
      MonEdit := (TMessage(Msg).WParam);
      SendMessage(MonEdit,WM_GETTEXT,255,integer(@MonTexte));  // On récupère le message
      if MonTexte<>'' then
      Stop:=bstop;
    end;
  if (TMessage(Msg).Msg=MessageSys_DBResume) then
    begin
      bstop:=Stop;
      Stop:=True;
      MonEdit := (TMessage(Msg).WParam);
      SendMessage(MonEdit,WM_GETTEXT,255,integer(@MonTexte));  // On récupère le message
      if MonTexte<>'' then  ActiveDesactiveFavori(MonTexte,true);
      Stop:=bstop;
    end;
  if (TMessage(Msg).Msg=MessageSys_Show) then
    begin
        Show();
        WindowState := wsNormal;
        Application.BringToFront();
        Application.ProcessMessages;
    end;
end;

procedure TFormVJETON.Dsactiver1Click(Sender: TObject);
begin
     ServiceStop('',ServiceJeton);
     ActiveDesactiveFavori(FDQJETON.FieldByName('JET_DATABASE').asstring,false);
     ServiceStart('',ServiceJeton);
end;

procedure TFormVJETON.SetStop(avalue:boolean);
begin
     FStop:=Avalue;
     TimerJETON.Enabled:=not(Avalue);
     BstartJETON.Enabled:=Avalue;
     BstopJETON.Enabled:=not(BstartJETON.Enabled);
     BConnexion.Enabled:=avalue;
end;


procedure TFormVJETON.spJETONChange(Sender: TObject);
begin
     TimerJETON.Interval:=1000*SpJETON.Value;
end;

procedure TFormVJETON.TimerJETONTimer(Sender: TObject);
begin
     Rafraichissement(FDQJETON);
end;

procedure TFormVJETON.TimerMONITORTimer(Sender: TObject);
begin
     Rafraichissement(FDQMONITOR);
end;

procedure TFormVJETON.TrayIcon1DblClick(Sender: TObject);
begin
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
  Application.ProcessMessages;
end;


procedure TFormVJETON.Ecran;
begin
    BstopJETON.Enabled  := ServiceGetStatus('',ServiceJeton) = SERVICE_RUNNING;
    BstartJETON.Enabled := not(BstopJETON.Enabled);

    BstopMONITOR.Enabled  := ServiceGetStatus('',ServiceMonitor) = SERVICE_RUNNING;
    BstartMONITOR.Enabled := not(BstopMONITOR.Enabled);

end;

procedure TFormVJETON.ApplicationEvents1Minimize(Sender: TObject);
begin
  Hide();
  WindowState := wsMinimized;

  { Show the animated tray icon and also a hint balloon. }
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TFormVJETON.btnBConnexionClick(Sender: TObject);
begin
     Application.CreateForm(TfrmConnexion,frmConnexion);
     frmConnexion.qliste.close;
     frmConnexion.qliste.Open;
     frmConnexion.Showmodal;
end;

procedure TFormVJETON.ActiveDesactiveFavori(Const AIBFILE:string='';AEnable:Boolean=true);
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     try
        PQuery.Connection:=DataMod.FDConSQLite;
        PQuery.Connection.Open;
        if PQuery.Connection.Connected then
           begin
                PQuery.SQL.Clear;
                PQuery.SQL.Add('UPDATE CONNEXION SET CON_FAV=:CONFAV WHERE ');
                PQuery.SQL.Add(' (  UPPER( :CONFULLPATH1 ) LIKE ''%'' || CON_PATH ) OR ');
                PQuery.SQL.Add(' (  UPPER( :CONFULLPATH2 ) LIKE ''%'' || CON_SERVER || ''%'' ) ');
                if AEnable
                  then PQuery.ParamByName('CONFAV').AsInteger:=1
                  else PQuery.ParamByName('CONFAV').AsInteger:=0;
                PQuery.ParamByName('CONFULLPATH1').Asstring:=AIBFILE;
                PQuery.ParamByName('CONFULLPATH2').Asstring:=AIBFILE;
                PQuery.Prepare;
                PQuery.ExecSQL;
           end;
     finally
        PQuery.Close;
        PQuery.Free;
     end;
end;

procedure TFormVJETON.Rafraichissement(DataSet:TDataset);
var id:Integer;
begin
     try
        DataSet.Disablecontrols;
        If DataSet.Active
          then DataSet.Refresh
          else DataSet.open;
      finally
        DataSet.EnableControls;
     end;
end;


procedure TFormVJETON.JetonPauseOnOffClick(Sender: TObject);
begin
    If PageControl1.ActivePage=TSjeton  then
    begin
      FDQJeton.Edit;
      FDQJeton.FieldByName('JET_PAUSE').AsBoolean:=not(FDQJeton.FieldByName('JET_PAUSE').AsBoolean);
      FDQJeton.Post;
    end;
    If PageControl1.ActivePage=TSmonitor then
    begin
      FDQMONITOR.Edit;
      FDQMONITOR.FieldByName('MON_PAUSE').AsBoolean:=not(FDQMONITOR.FieldByName('MON_PAUSE').AsBoolean);
      FDQMONITOR.Post;
    end;
end;

procedure TFormVJETON.BitBtn1Click(Sender: TObject);
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     try
        PQuery.Connection:=DataMod.FDConSQLite;
        PQuery.Connection.Open;
        if PQuery.Connection.Connected then
           begin
                PQuery.SQL.Clear;
                PQuery.SQL.Add('UPDATE VJETON SET JET_HRFLAG=0');
                PQuery.Prepare;
                PQuery.ExecSQL;
                PQuery.Connection.Commit;
           end;
     finally
        PQuery.Close;
        PQuery.Free;
     end;
   Rafraichissement(FDQJETON);
end;

procedure TFormVJETON.BStartJETONClick(Sender: TObject);
begin
     BStartJETON.Enabled:=false;
     ServiceStart('',ServiceJeton);
     Ecran;
end;

procedure TFormVJETON.BStartMonitorClick(Sender: TObject);
begin
     BStartMonitor.Enabled:=false;
     ServiceStart('',ServiceMonitor);
     Ecran;
end;

procedure TFormVJETON.BstopJETONClick(Sender: TObject);
begin
     BstopJETON.Enabled:=false;
     ServiceStop('',ServiceJeton);
     Ecran;
end;

procedure TFormVJETON.BStopMonitorClick(Sender: TObject);
begin
     BStartMonitor.Enabled:=false;
     ServiceStop('',ServiceMonitor);
     Ecran;
end;

procedure TFormVJETON.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action:=caFree;
end;

procedure TFormVJETON.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := False;
    // Remove the main form from the Task bar
    Self.Hide;
    ShowWindow(Application.Handle, SW_HIDE) ;
    SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
end;

procedure TFormVJETON.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
   if Msg.Message = MyMsg then
   begin
      Application.Restore;
      SetForeGroundWindow(Application.MainForm.Handle);
      Handled := true;
   end;
end;

procedure TFormVJETON.FormCreate(Sender: TObject);
var i:Integer;
    Ini : TIniFile;
    DBFile:string;
begin
     FStop:=false;
     MessageSys_Kill       := RegisterWindowMessage('MsgSys_C4Kill');
     MessageSys_Stop       := RegisterWindowMessage('MsgSys_C4Stop');
     MessageSys_Show       := RegisterWindowMessage('MsgSys_C4Show');
     MessageSys_Resume     := RegisterWindowMessage('MsgSys_C4Resume');
     MessageSys_DBStop     := RegisterWindowMessage('MsgSys_C4DBStop');
     MessageSys_DBResume   := RegisterWindowMessage('MsgSys_C4DBResume');
     Application.OnMessage := AppMessage;
     Ini := TIniFile.Create(VAR_GLOB.Exe_Directory + 'monitor.ini');
      try
       DBFile := Ini.ReadString('SQLite','dbfile','');

       DataMod.SQLiteStartConnexion(DBFile,false);

       TimerJETON.Interval:=1000*SPJETON.Value;
       Rafraichissement(FDQJETON);
       TimerJETON.Enabled:=not(Stop);

       TimerMONITOR.Interval:=1000*SPMONITOR.Value;
       Rafraichissement(FDQMONITOR);
       TimerMONITOR.Enabled:=not(Stop);

       ShowWindow(Application.Handle, SW_HIDE) ;
       SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
       // ShowWindow(Application.Handle, SW_SHOW) ;
    finally
        Ini.Free;
    end;
end;

procedure TFormVJETON.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (Key=VK_F5) then
        begin
            if PageControl1.ActivePage=TSJETON
               then Rafraichissement(FDQJETON);
            if PageControl1.ActivePage=TSMONITOR
               then Rafraichissement(FDQMONITOR);
        end;
end;

procedure TFormVJETON.mStartClick(Sender: TObject);
begin
     Stop:=False;
end;

procedure TFormVJETON.mStopClick(Sender: TObject);
begin
    Stop:=true;
end;

procedure TFormVJETON.Ouvrir1Click(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFormVJETON.PageControl1Change(Sender: TObject);
begin
    Ecran;
end;

procedure TFormVJETON.PopupMenu2Popup(Sender: TObject);
begin
    If PageControl1.ActivePage=TSjeton  then
    begin
      jPause.Enabled:=not(FDQJeton.FieldByName('JET_PAUSE').asboolean);
      jReprendre.Enabled:=not(jPause.Enabled);
    end;
    If PageControl1.ActivePage=TSmonitor then
    begin
      jPause.Enabled:=not(FDQMONITOR.FieldByName('MON_PAUSE').asboolean);
      jReprendre.Enabled:=not(jPause.Enabled);
    end;
end;

procedure TFormVJETON.Quitter1Click(Sender: TObject);
begin
     Application.Terminate;
end;

end.

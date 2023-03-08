unit Frm_VMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ImgList, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin, Data.DB, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Menus, Vcl.AppEvnts,MidasLib,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,ShellAPI;

const ws_monitor_script     = 'ws_monitor.php';
      ws_monitor_log_script = 'ws_monitor_log.php';
      ginkoia_path_monitor  = 'http://194.206.223.11:8000/tools/';
      yellis_path_monitor   = 'http://ginkoia.yellis.net/v2/ws/';
      Max_JsonLenght        = 200;   // au dela on passe en fichier
      MaxWDPOSTExe          = 20;
      VMonitior_procedure   = 'VMONITOR_LAST_REPLIC(30)';   // SM_BILAN_REPLIC

type
  TFormVMonitor = class(TForm)
    dsmonitor: TDataSource;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    Ouvrir1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    N2: TMenuItem;
    mstart: TMenuItem;
    mStop: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    BStart: TBitBtn;
    Bstop: TBitBtn;
    BConnexion: TBitBtn;
    BACTUALISER: TBitBtn;
    DBGrid1: TDBGrid;
    cdsMonitor: TClientDataSet;
    cdsMonitorDOSSIER: TStringField;
    cdsMonitorSERVER: TStringField;
    cdsMonitorDATABASE: TStringField;
    cdsMonitorLASTLOGID: TLargeintField;
    cdsMonitorLASTWDPOST: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure Ouvrir1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpinEdit1Change(Sender: TObject);
    procedure mstartClick(Sender: TObject);
    procedure mStopClick(Sender: TObject);
    procedure BStartClick(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure BACTUALISERClick(Sender: TObject);
    procedure BConnexionClick(Sender: TObject);
  private
    FStop     : Boolean;
    FOk       : Boolean;        // Variable qui permet de lancer ou pas le rafraichissement
    Fauto     : Boolean;
    FTBLOG    : boolean;
    FUrlPath  : string;
    FFile     : string;
    Ftempo    : Integer;  // Tempo en seconde
    FVmonitor_Procedure : string;
    procedure Raichissement(Const All:Boolean=false);
    procedure Load_Param(aparam:string;avalue:string);
    procedure AnalyseLigneCourante;
    function LancementWDPOST:boolean;
    { Déclarations privées }
  public
    nbWDPOSTexe : Integer;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    { Déclarations publiques }
    function GetStop():boolean;
    procedure SetStop(Avalue:Boolean);
    procedure Rechargement();
    { Déclarations publiques }
  property
    Stop:Boolean read GetStop write setStop;
  end;
  function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;
var
  FormVMonitor: TFormVMonitor;
  MyMsg: Cardinal;

implementation

{$R *.dfm}

Uses UDataMod,UCommun, Frm_Connexion;


function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;
var
  pPid : DWORD;
  title, ClassName : string;
  x:integer;
begin
  if (hHwnd=NULL) then
  begin
    result := false;
  end
  else
  begin
    GetWindowThreadProcessId(hHwnd,pPid);
    SetLength(ClassName, 255);
    SetLength(ClassName,
              GetClassName(hHwnd,
                           PChar(className),
                           Length(className)));
    SetLength(title, 255);
    SetLength(title, GetWindowText(hHwnd, PChar(title), Length(title)));
    if (UpperCase(title)='WDPOST') AND (UpperCase(className)='TAPPLICATION')
      then FormVMonitor.nbWDPOSTexe:=FormVMonitor.nbWDPOSTexe+1;
    Result := true;
  end;
end;


procedure TFormVMonitor.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
   if Msg.Message = MyMsg then
   begin
      Application.Restore;
      SetForeGroundWindow(Application.MainForm.Handle);
      Handled := true;
   end;
end;


function TFormVMonitor.GetStop():boolean;
begin
     result:=FStop;
end;


procedure TFormVMonitor.SetStop(avalue:boolean);
begin
     FStop:=avalue;
     Timer1.Enabled:=not(Avalue);
     Bstart.Enabled:=Avalue;
     mStart.Enabled:=Avalue;
     Bstop.Enabled:=not(Bstart.Enabled);
     mStop.Enabled:=not(Bstart.Enabled);
end;




procedure TFormVMonitor.BACTUALISERClick(Sender: TObject);
begin
     Raichissement(True);
end;

procedure TFormVMonitor.BConnexionClick(Sender: TObject);
begin
      Stop:=True;
     Application.CreateForm(TfrmConnexion,frmConnexion);
     frmConnexion.qliste.close;
     frmConnexion.qliste.Open;
     frmConnexion.Showmodal;
     Rechargement();
end;

function TFormVMonitor.LancementWDPOST:boolean;
begin
     nbWDPOSTexe:=0;
     result:=false;
     if EnumWindows(@EnumProcess,0) = false then exit;
     if (nbWDPOSTexe < MaxWDPOSTExe)
       then result:=true
       else result:=false;
end;


procedure TFormVMonitor.Raichissement(Const All:Boolean=false);
begin
     if fOk then
        begin
             fOk:=False;
             bActualiser.Enabled:=false;
             cdsmonitor.DisableControls;
             if (all=true)
               then
                   begin
                        cdsmonitor.First;
                        while not(cdsmonitor.eof) do
                          begin
                               AnalyseLigneCourante;
                               cdsmonitor.Next;
                          end;
                   end
               else
                  begin
                       AnalyseLigneCourante;
                       if (cdsmonitor.RecNo=cdsmonitor.RecordCount)
                          then cdsmonitor.First
                          else cdsmonitor.Next;
                  end;
             cdsmonitor.EnableControls;
             bActualiser.Enabled:=true;
             fOk:=True;
        end;
end;


procedure TFormVMonitor.SpinEdit1Change(Sender: TObject);
begin
     Timer1.Interval:=1000*SpinEdit1.Value;
end;

procedure TFormVMonitor.AnalyseLigneCourante;
var PQuery:TFDQuery;
    Parametres:string;
    sAuto:string;
    nerror:Integer;
    Json_str:string;
    sNewFileName:string;
begin
     if FAuto
      then sAuto:='-auto '
      else sAuto:='';
     PQuery:=TFDQuery.Create(DataMod);
     try
        DataMod.FDConIB.Params.Clear;
        DataMod.FDConIB.Params.Add('DriverID=IB');
        DataMod.FDConIB.Params.Add('Server=' + cdsmonitor.FieldByName('Server').AsString);
        DataMod.FDConIB.Params.Add('Database='+ cdsmonitor.FieldByName('Database').AsString);
        DataMod.FDConIB.Params.Add('User_Name=SYSDBA');
        DataMod.FDConIB.Params.Add('Password=masterkey');
        DataMod.FDConIB.Params.Add('Protocol=TCPIP');
        Try
           DataMod.FDConIB.Open;
           If DataMod.FDConIB.Connected then
                  begin
                      PQuery.Connection:=DataMod.FDConIB;
                      PQuery.Transaction:=DataMod.FDtransIB;
                      PQuery.Close;
                      PQuery.Transaction.Options.ReadOnly:=true;
                      if FTBLOG then
                        begin
                            DataMod.FDTransIB.StartTransaction;
                            try
                                If (cdsmonitor.FieldByName('LASTLOGID').asinteger=0) then
                                   begin
                                        PQuery.SQL.Clear;
                                        PQuery.SQL.Add('SELECT MAX(LOG_ID) FROM LOG');
                                        PQuery.Open;
                                        cdsmonitor.Edit;
                                        cdsmonitor.FieldByName('LASTLOGID').Asinteger:=PQuery.Fields[0].Asinteger;
                                        cdsMonitor.Post;
                                   end
                                 else
                                   begin
                                        PQuery.SQL.Clear;
                                        PQuery.SQL.Add('SELECT * FROM LOG WHERE LOG_ID>:LASTLOGID ORDER BY LOG_ID ASC ROWS 50');
                                        PQuery.ParamByName('LASTLOGID').AsInteger:=cdsmonitor.FieldByName('LASTLOGID').Asinteger;
                                        PQuery.Open;
                                        Json_str:='';
                                        if not(PQuery.IsEmpty)
                                          then
                                          begin
                                              While not(PQuery.Eof) do
                                                begin
                                                     // ici on pourra recuperer la table log petit bout par petit bout..
                                                     Json_str:=Json_str+Format('{LOG_ID:%d,LOG_OPERATION:%s,LOG_STATUS:%s',
                                                     [PQuery.FieldByName('LOG_ID').asinteger,
                                                      PQuery.FieldByName('LOG_OPERATION').asstring,
                                                      PQuery.FieldByName('LOG_STATUS').AsString]);
                                                     json_str:=Json_str+Format(',LOG_STARTING:%d,LOG_DONE:%d,LOG_DURATION:%s,LOG_SENDER:%s,LOG_XMLSERVICE:%s,LOG_RECORDCOUNT:%d}',
                                                     [DateTimeToUNIXTimeFAST(PQuery.FieldByName('LOG_STARTING').asDateTime),
                                                      DateTimeToUNIXTimeFAST(PQuery.FieldByName('LOG_DONE').asDateTime),
                                                      PQuery.FieldByName('LOG_DURATION').AsString,
                                                      PQuery.FieldByName('LOG_SENDER').AsString,
                                                      PQuery.FieldByName('LOG_XMLSERVICE').AsString,
                                                      PQuery.FieldByName('LOG_RECORDCOUNT').AsInteger
                                                      ]);
                                                     PQuery.Next;
                                                end;
                                            If (LancementWDPOST) then
                                              begin
                                                   if length(Json_str)>Max_JsonLenght then
                                                     begin
                                                        sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_monitor_log_script','.tmp');
                                                        SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[cdsmonitor.FieldByName('Dossier').AsString,Json_str]));
                                                        Parametres:=Format('%s-url=%s -psk=AD8FE63 -file="%s"',[
                                                        sauto,
                                                        FUrlPath+ws_monitor_log_script,sNewFileName]);
                                                     end
                                                   else
                                                     begin
                                                      Parametres:=Format('%s-url=%s -psk=AD8FE63 -json=d:%s,j:[%s]',[
                                                          sAuto,
                                                          FUrlPath+ws_monitor_log_script,
                                                          cdsmonitor.FieldByName('Dossier').AsString,
                                                          Json_str]);
                                                     end;
                                                   ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                                   cdsmonitor.Edit;
                                                   cdsmonitor.FieldByName('LASTLOGID').Asinteger:=PQuery.FieldByName('LOG_ID').Asinteger;
                                                   cdsmonitor.Post;
                                              end;
                                          end;
                                   end;
                                  DataMod.FDtransIB.Commit;
                            except
                                  DataMod.FDtransIB.Rollback;
                            end;
                        end;
                      PQuery.Close;
                      PQuery.SQL.Clear;
                      PQuery.SQL.Add(Format('SELECT * FROM %s',[FVmonitor_Procedure]));
                      PQuery.Transaction.StartTransaction;
                      try
                         PQuery.Open;
                         Json_str:='';
                         While not(PQuery.Eof) do
                              begin
                                   Json_str:=Json_str + Format('{s:%s,t1:%d,t2:%d}',[
                                      PQuery.Fields[0].AsString,
                                      DateTimeToUNIXTimeFAST(PQuery.Fields[1].AsDateTime),
                                      DateTimeToUNIXTimeFAST(PQuery.Fields[2].AsDateTime)]
                                      );
                                   PQuery.Next;
                              end;
                          // On va voir s'il n'y a pas déjà 20 process de lancé sur WDPOST.
                          If (LancementWDPOST) then
                              begin
                                   if length(Json_str)>Max_JsonLenght then
                                      begin
                                        sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_monitor_script','.tmp');
                                        SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[cdsmonitor.FieldByName('Dossier').AsString,Json_str]));
                                        Parametres:=Format('%s-url=%s -psk=EFC79H6 -file="%s"',[
                                                       sauto,
                                                       FUrlPath+ws_monitor_script,
                                                       sNewFileName]);
                                      end
                                   else
                                      begin
                                           Parametres:=Format('%s-url=%s -psk=EFC79H6 -json=d:%s,j:[%s]',[
                                                                 sAuto,
                                                                 FUrlPath+ws_monitor_script,
                                                                 cdsmonitor.FieldByName('Dossier').AsString,
                                                                 Json_str]);
                                      end;
                                   ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                   cdsmonitor.Edit;
                                   cdsmonitor.FieldByName('LASTWDPOST').AsDateTime:=Now();
                                   cdsmonitor.Post;
                              end;
                          DataMod.FDtransIB.Commit;
                      Except
                          DataMod.FDtransIB.Rollback;
                      end;
                      PQuery.Close;
                  end;
                  Except
                      {
                      On E : EUniError do
                        begin
                              Parametres:=Format('%s-url=%s -psk=EFC79H6 -json=d:%s,b:%s,e:%d',[
                                           sAuto,
                                           FUrlPath+ws_monitor_script,
                                           cdsmonitor.FieldByName('Dossier').AsString,
                                           cdsmonitor.FieldByName('Server').AsString,
                                           E.ErrorCode]
                                           );
                               ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                        end;
                        }
                      On E: EFDDBEngineException  do
                          begin
                               // On repouse le tempo de 10s Non ?!
                               // Il faudrait flagger ce Monitor pour eviter de pénaliser les autres qui fonctionnent
                               Parametres:=Format('%s-url=%s -psk=EFC79H6 -json=d:%s,b:%s,e:%d',[
                                           sAuto,
                                           FUrlPath+ws_monitor_script,
                                           cdsmonitor.FieldByName('Dossier').AsString,
                                           cdsmonitor.FieldByName('Server').AsString,
                                           E.ErrorCode]
                                           );
                               ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                          end
                      else
                       begin
                            Parametres:=Format('%s-url=%s -psk=EFC79H6 -json=d:%s,b:%s,e:500,',[
                                                   sAuto,
                                                   FUrlPath+ws_monitor_script,
                                                   cdsmonitor.FieldByName('Dossier').AsString,
                                                   cdsmonitor.FieldByName('Server').AsString]
                                                   );
                              ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                       end;
        End;
        DataMod.FDConIB.Close;
     finally
      PQuery.Close;
      PQuery.Free;
     end;
end;

procedure TFormVMonitor.Timer1Timer(Sender: TObject);
begin
     Raichissement;
end;

procedure TFormVMonitor.BStartClick(Sender: TObject);
begin
      Stop:=false;
end;

procedure TFormVMonitor.BStopClick(Sender: TObject);
begin
    Stop:=true;
end;

procedure TFormVMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action:=caFree;
end;

procedure TFormVMonitor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := False;
    // Remove the main form from the Task bar
    Self.Hide;
    ShowWindow(Application.Handle, SW_HIDE) ;
    SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;

end;

procedure TFormVMonitor.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
begin
     //-------------------------------------------------------------------------
     FUrlPath:=ginkoia_path_monitor;
     FFile:='';
     Fstop:=true;
     FAuto:=False;
     FTBLOG:=false;
     FVmonitor_Procedure := VMonitior_procedure;
     for i :=1 to ParamCount do
      begin
            If lowercase(ParamStr(i))='-start' then Stop:=false;
            If lowercase(ParamStr(i))='-auto'  then FAuto  := true;
            If lowercase(ParamStr(i))='-tblog' then FTBLOG := true;
            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-urlpath' then Load_Param('urlpath',value);
            If lowercase(param)='-tempo'  then Load_Param('tempo',value);
            If lowercase(param)='-proc'   then Load_Param('proc',value);
      end;
     Timer1.Interval:=1000*SpinEdit1.Value;
     FOk:=true;
     Timer1.Enabled:=not(Stop);
     Rechargement();

     ShowWindow(Application.Handle, SW_HIDE) ;
     SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
     // ShowWindow(Application.Handle, SW_SHOW) ;
end;

procedure TFormVMonitor.Rechargement();
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     try
     try
     PQuery.Connection:=DataMod.FDconliteconnexion;
     DataMod.FDconliteconnexion.Open;
     if DataMod.FDconliteconnexion.Connected then
        begin
           PQuery.SQL.Clear;
           PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 AND CON_MONITOR!='''' ORDER BY CON_NOM');
           PQuery.Open;
           cdsmonitor.Close;
           cdsmonitor.Open;
           cdsmonitor.EmptyDataSet;
           while not(PQuery.Eof) do
              begin
                   // Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
                   cdsmonitor.Append;
                   cdsmonitor.FieldByName('DOSSIER').asstring:=PQuery.FieldbyName('CON_NOM').asstring;
                   cdsmonitor.FieldByName('SERVER').asstring:=PQuery.FieldbyName('CON_SERVER').asstring;
                   cdsmonitor.FieldByName('DATABASE').asstring:=PQuery.FieldbyName('CON_MONITOR').asstring;
                   // pour les tests
                   cdsmonitor.FieldByName('LASTLOGID').asinteger:=0; { 805488000 : Pour les tests }
                   cdsmonitor.Post;
                   PQuery.Next;
              end;
           PQuery.Close;
           cdsmonitor.First;
        end;
     DataMod.FDconliteconnexion.Close;
     Except

     end;
     finally
       PQuery.Free;
     end;
end;


procedure TFormVMonitor.Load_Param(aparam:string;avalue:string);
begin
     if aparam='urlpath'  then FUrlPath  := avalue;
     if aparam='tempo' then
        begin
             Ftempo   := StrToInt(avalue);
             SpinEdit1.Value :=Ftempo;
        end;
     if aparam='proc'     then FVmonitor_Procedure  := avalue;
end;


procedure TFormVMonitor.mstartClick(Sender: TObject);
begin
    Stop:=false;
end;

procedure TFormVMonitor.mStopClick(Sender: TObject);
begin
     Stop:=true;
end;

procedure TFormVMonitor.Ouvrir1Click(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFormVMonitor.Quitter1Click(Sender: TObject);
begin
     Application.Terminate;
end;

end.

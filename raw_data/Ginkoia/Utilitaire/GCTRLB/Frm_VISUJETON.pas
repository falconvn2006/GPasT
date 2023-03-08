unit Frm_VISUJETON;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Datasnap.DBClient, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, Data.DB, Vcl.Menus, Vcl.AppEvnts, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Samples.Spin, ShellAPI, Vcl.Buttons,Math, MidasLib;


const script        = 'ws.php';
      script_hr     = 'ws_hr.php';
      script_hr0    = 'ws_hr0.php';
      path_script   = 'http://194.206.223.11:8000/tools/';
      // ginkoia_url   = 'http://194.206.223.11:8000/tools/ws.php';
      // yellis_url    = 'http://ginkoia.yellis.net/v2/ws/ws.php';
      MaxWDPOSTExe  = 20;
      Max_JsonLenght = 200;


type
  TFormVJETON = class(TForm)
    Panel1: TPanel;
    dsjetons: TDataSource;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    Quitter1: TMenuItem;
    Ouvrir1: TMenuItem;
    N1: TMenuItem;
    Label1: TLabel;
    N2: TMenuItem;
    mStart: TMenuItem;
    mStop: TMenuItem;
    DBGrid1: TDBGrid;
    cdsJETONS: TClientDataSet;
    cdsJETONSPOSTE: TStringField;
    cdsJETONSDATEHEURE: TDateTimeField;
    cdsJETONSBASE: TStringField;
    cdsJETONSSENDER: TStringField;
    cdsJETONSDATABASE: TStringField;
    cdsJETONSSERVER: TStringField;
    cdsJETONSDOSSIER: TStringField;
    cdsJETONSLASTWDPOST: TDateTimeField;
    cdsJETONSHRFLAG: TBooleanField;
    SpinEdit1: TSpinEdit;
    BStart: TBitBtn;
    Bstop: TBitBtn;
    BConnexion: TBitBtn;
    BACTUALISER: TBitBtn;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Ouvrir1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Quitter1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure btnBConnexionClick(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure BStartClick(Sender: TObject);
    procedure mStopClick(Sender: TObject);
    procedure mStartClick(Sender: TObject);
    procedure BACTUALISERClick(Sender: TObject);
  private
    FStop : Boolean;
    FOk   : Boolean;
    Fauto : Boolean;
    FUrl  : string;
    FUrl_hr  : string;
    FUrl_hr0 : string;
    // FFile : string;
    Ftempo   : Integer;        // tempo en seconde
    procedure Raichissement(Const all:Boolean=False);
    procedure Load_Param(aparam:string;avalue:string);
    procedure AnalyseLigneCourante;
    function LancementWDPOST:boolean;
    procedure Rechargement();
    { Déclarations privées }
  public
    nbWDPOSTexe : Integer;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    function GetStop():boolean;
    procedure SetStop(Avalue:Boolean);
    { Déclarations publiques }
  property
    Stop:Boolean read GetStop write setStop;
  end;
   function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;

var
  FormVJETON: TFormVJETON;
  MyMsg: Cardinal;

implementation

{$R *.dfm}

Uses UDataMod,UCommun, Frm_Connexion;


function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;
var
  pPid : DWORD;
  title, ClassName : string;
//  x:integer;
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
      then FormVJETON.nbWDPOSTexe:=FormVJETON.nbWDPOSTexe+1;
    Result := true;
  end;
end;

function TFormVJETON.GetStop():boolean;
begin
     result:=FStop;
end;


procedure TFormVJETON.SetStop(avalue:boolean);
begin
     FStop:=avalue;
     Timer1.Enabled:=not(Avalue);
     Bstart.Enabled:=Avalue;
     mStart.Enabled:=Avalue;
     Bstop.Enabled:=not(Bstart.Enabled);
     mStop.Enabled:=not(Bstart.Enabled);
end;


function TFormVJETON.LancementWDPOST:boolean;
begin
     nbWDPOSTexe:=0;
     result:=false;
     if EnumWindows(@EnumProcess,0) = false then exit;
     if (nbWDPOSTexe < MaxWDPOSTExe)
       then result:=true
       else result:=false;
end;


procedure TFormVJETON.AnalyseLigneCourante;
var PQuery:TFDQuery;
    Parametres:string;
    sAuto:string;
    nerror:Integer;
    astring:string;
    sNewFileName:string;
begin
     if FAuto
      then sAuto:='-auto '
      else sAuto:='';
     PQuery:=TFDQuery.Create(DataMod);
     try
        DataMod.FDConIB.Params.Clear;
        DataMod.FDConIB.Params.Add('DriverID=IB');
        DataMod.FDConIB.Params.Add('Server=' + cdsJETONS.FieldByName('Server').AsString);
        DataMod.FDConIB.Params.Add('Database='+ cdsJETONS.FieldByName('Database').AsString);
        DataMod.FDConIB.Params.Add('User_Name=SYSDBA');
        DataMod.FDConIB.Params.Add('Password=masterkey');
        DataMod.FDConIB.Params.Add('Protocol=TCPIP');
        Try
           DataMod.FDConIB.open;
           If DataMod.FDConIB.Connected then
            begin
                PQuery.Connection:=DataMod.FDConIB;
                PQuery.Close;
                {-------------------------------------------------------------}
                if not(cdsJETONS.FieldByName('HRFLAG').AsBoolean)
                    then
                        begin
                            PQuery.SQL.Clear;
                            // 2 Replications standards
                            PQuery.SQL.Add('SELECT GENBASES.BAS_SENDER, LAU_H1,');
                            PQuery.SQL.Add(' CASE');
                            PQuery.SQL.Add('     WHEN (LAU_HEURE1 IS NULL) THEN ''0'' ');
                            PQuery.SQL.Add('     ELSE CAST(((CAST(f_MID(LAU_HEURE1,11,2) AS FLOAT)+CAST(f_MID(LAU_HEURE1,14,2) AS FLOAT)/60) / 24) AS VARCHAR(15))');
                            PQuery.SQL.Add(' END AS LAU_HR1,');
                            PQuery.SQL.Add(' LAU_H2,');
                            PQuery.SQL.Add(' CASE');
                            PQuery.SQL.Add('     WHEN (LAU_HEURE2 IS NULL) THEN ''0'' ');
                            PQuery.SQL.Add('     ELSE CAST(((CAST(f_MID(LAU_HEURE2,11,2) AS FLOAT)+CAST(f_MID(LAU_HEURE2,14,2) AS FLOAT)/60) / 24) AS VARCHAR(15)) ');
                            PQuery.SQL.Add(' END AS LAU_HR2, ');
                            PQuery.SQL.Add(' LAU_AUTORUN ');
                            PQuery.SQL.Add('  FROM GENBASES ');
                            PQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
                            PQuery.SQL.Add(' JOIN GENLAUNCH ON BAS_ID=LAU_BASID ');
                            PQuery.SQL.Add(' WHERE (BAS_SENDER NOT LIKE ''% %'') AND (BAS_ID<>0) ');
                            PQuery.SQL.Add(' ORDER BY BAS_ID ');
                            PQuery.Open;
                            astring:='';
                            while not(PQuery.Eof) do
                              begin
                                   astring:=astring+Format('{s:%s,run:%d,a1:%d,a2:%d,h1:%s,h2:%s}',[
                                            PQuery.FieldByName('BAS_SENDER').asstring,
                                            PQuery.FieldByName('LAU_AUTORUN').asinteger,
                                            PQuery.FieldByName('LAU_H1').AsInteger,
                                            PQuery.FieldByName('LAU_H2').AsInteger,
                                            StringReplace(Trim(PQuery.FieldByName('LAU_HR1').asstring),',','.',[rfReplaceAll]),
                                            StringReplace(Trim(PQuery.FieldByName('LAU_HR2').asstring),',','.',[rfReplaceAll])
                                            ]);
                                   PQuery.Next;
                              end;
                           PQuery.close;
                           if (astring<>'')
                              then
                                  begin
                                       if length(astring)>Max_JsonLenght then
                                          begin
                                               sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_hr0','.tmp');
                                               SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[cdsJETONS.FieldByName('Dossier').AsString,astring]));
                                               Parametres:=Format('%s-url=%s -psk=DE78FA4AB -file="%s"',[
                                                 sauto,
                                                 FUrl_hr0,
                                                 sNewFileName]);
                                          end
                                          else
                                          begin
                                             Parametres:=Format('%s-url=%s -psk=DE78FA4AB -json=d:%s,j:[%s]',[
                                                          sAuto,
                                                          FUrl_hr0,
                                                          cdsJETONS.FieldByName('Dossier').AsString,
                                                          astring]
                                                          );
                                          end;
                                       ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                  end;
                            // replication ... 15 mintues
                            PQuery.close;
                            PQuery.SQL.Clear;
                            PQuery.SQL.Add(' SELECT BAS_SENDER, REP_JOUR, PRM_CODE, PRM_INTEGER+PRM_FLOAT as HR ');
                            PQuery.SQL.Add(' FROM GENREPLICATION ');
                            PQuery.SQL.Add(' JOIN K ON (K_id = REP_ID and K_ENABLED=1) ');
                            PQuery.SQL.Add(' JOIN GENLAUNCH ON (LAU_ID=REP_LAUID) ');
                            PQuery.SQL.Add(' JOIN K ON (K_ID = LAU_ID and K_ENABLED=1) ');
                            PQuery.SQL.Add(' JOIN GENBASES ON (BAS_ID = LAU_BASID)  ');
                            PQuery.SQL.Add(' JOIN K ON (K_ID=BAS_ID AND K_ENABLED=1)  ');
                            PQuery.SQL.Add(' JOIN GENPARAM ON (PRM_TYPE=11 AND BAS_ID=PRM_POS AND PRM_CODE IN (31,32,33) ) ');
                            PQuery.SQL.Add(' WHERE (BAS_SENDER NOT LIKE ''% %'') ');
                            PQuery.SQL.Add(' ORDER BY BAS_ID ');
                            PQuery.Open;
                            astring:='';
                            while not(PQuery.Eof) do
                              begin
                                   astring:=astring+Format('{s:%s,a:%d,h%s:%8.8f}',[
                                            PQuery.FieldByName('BAS_SENDER').asstring,
                                            PQuery.FieldByName('REP_JOUR').asinteger,
                                            PQuery.FieldByName('PRM_CODE').asstring,
                                            PQuery.FieldByName('HR').asfloat
                                            ]);
                                   PQuery.Next;
                              end;

                           PQuery.close;
                           if (astring<>'')
                              then
                                  begin
                                       if length(astring)>MAX_JSONLENGHT then
                                          begin
                                               sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_hr','.tmp');
                                               SaveStrToFile(sNewFileName,Format('d:%s,j:[%s]',[cdsJETONS.FieldByName('Dossier').AsString,astring]));
                                               Parametres:=Format('%s-url=%s -psk=CD789FE12D -file="%s"',[
                                                 sauto,
                                                 FUrl_hr,
                                                 sNewFileName]);
                                          end
                                       else
                                           begin
                                                Parametres:=Format('%s-url=%s -psk=CD789FE12D -json=d:%s,j:[%s]',[
                                                 sAuto,
                                                  FUrl_hr,
                                                  cdsJETONS.FieldByName('Dossier').AsString,
                                                  astring]
                                                  );
                                           end;
                                       ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                                  end;
                           cdsJETONS.Edit;
                           cdsJETONS.FieldByName('HRFLAG').Value:=true;
                           cdsJETONS.post;
                        end;
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT JET_NOMPOSTE, JET_STAMP, BAS_NOM, BAS_SENDER FROM GENJETONS JOIN GENBASES ON JET_BASID=BAS_ID ORDER BY JET_STAMP DESC');
                PQuery.Open;
                If not(PQuery.IsEmpty) then
                     begin
                           cdsJETONS.Edit;
                           cdsJETONS.FieldByName('Poste').AsString:=PQuery.FieldByName('JET_NOMPOSTE').AsString;
                           cdsJETONS.FieldByName('DateHeure').AsDateTime:=PQuery.FieldByName('JET_STAMP').AsDateTime;
                           cdsJETONS.FieldByName('Base').AsString:=PQuery.FieldByName('BAS_NOM').AsString;
                           cdsJETONS.FieldByName('Sender').AsString:=PQuery.FieldByName('BAS_SENDER').AsString;
                           //    90.83.227.43
                     end
                  Else
                    begin
                         cdsJETONS.Edit;
                         cdsJETONS.FieldByName('Poste').AsString:='';
                         cdsJETONS.FieldByName('DateHeure').AsString:='';
                         cdsJETONS.FieldByName('Base').AsString:='';
                         cdsJETONS.FieldByName('Sender').AsString:='';
                    end;
                //***//
                PQuery.Close;
                // On va voir s'il n'y a pas déjà 20 process de lancer sur WDPOST.
                If (LancementWDPOST) then
                    begin
                         Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,t:%d,s:%s',[
                                              sAuto,
                                              FUrl,
                                              cdsJETONS.FieldByName('Dossier').AsString,
                                              cdsJETONS.FieldByName('Server').AsString,
                                               DateTimeToUNIXTimeFAST(cdsJETONS.FieldByName('DateHeure').AsDateTime),
                                               cdsJETONS.FieldByName('Sender').AsString]
                                              );
                         ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                         cdsJETONS.FieldByName('LASTWDPOST').AsDateTime:=Now();
                    end;
                cdsJETONS.Post;
                DataMod.FDConIB.Close;
            end;
            Except
                On E: EFDDBEngineException  do
                    begin
                         // On repouse le tempo de 10s
                         // SpinEdit1.Value:=SpinEdit1.Value+10;
                         Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,e:%d',[
                                     sAuto,
                                     FUrl,
                                     cdsJETONS.FieldByName('Dossier').AsString,
                                     cdsJETONS.FieldByName('Server').AsString,
                                     E.ErrorCode]
                                     );
                         ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                    end
                else
                 begin
                      Parametres:=Format('%s-url=%s -psk=EF84HEA -json=d:%s,b:%s,e:500,',[
                                              sAuto,
                                              FUrl,
                                              cdsJETONS.FieldByName('Dossier').AsString,
                                              cdsJETONS.FieldByName('Server').AsString]
                                             );
                        ShellExecute(Handle,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
                 end;
        End;
     finally
        PQuery.Close;
        PQuery.Free;
     end;
end;


procedure TFormVJETON.Raichissement(Const all:Boolean=False);
begin
     if fOk then
        begin
             fOk:=False;
             cdsJETONS.DisableControls;
             if (all=true)
               then
                   begin
                        cdsJETONS.First;
                        while not(cdsJETONS.eof) do
                          begin
                               AnalyseLigneCourante;
                               cdsJETONS.Next;
                          end;
                   end
               else
                  begin
                       AnalyseLigneCourante;
                       if (cdsJETONS.RecNo=cdsJETONS.RecordCount)
                          then cdsJETONS.First
                          else cdsJETONS.Next;
                  end;
             cdsJETONS.EnableControls;
             fOk:=true;
        end;
end;

procedure TFormVJETON.SpinEdit1Change(Sender: TObject);
begin
     Timer1.Interval:=1000*SpinEdit1.Value;
end;

procedure TFormVJETON.Timer1Timer(Sender: TObject);
begin
     Raichissement;
end;

procedure TFormVJETON.TrayIcon1DblClick(Sender: TObject);
begin
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
  Application.ProcessMessages;
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
     Stop:=True;
     Application.CreateForm(TfrmConnexion,frmConnexion);
     frmConnexion.qliste.close;
     frmConnexion.qliste.Open;
     frmConnexion.Showmodal;
     Rechargement();
     // Rechargement
end;


procedure TFormVJETON.Rechargement();
var PQuery:TFDQuery;
begin
     PQuery:=TFDQuery.Create(DataMod);
     try
        PQuery.Connection:=DataMod.FDConLiteConnexion;
        PQuery.Connection.Open;
        if PQuery.Connection.Connected then
           begin
                PQuery.SQL.Clear;
                PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 ORDER BY CON_NOM');
                PQuery.Open;
                cdsJETONS.close;
                cdsJETONS.Open;
                cdsJETONS.EmptyDataSet;
                while not(PQuery.Eof) do
                    begin
                         // Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
                         // Quand on est en V11.3 pour le monitor on laisse à vide la CON_PATH
                         if PQuery.FieldbyName('CON_PATH').asstring<>'' then
                          begin
                               cdsJETONS.Append;
                               cdsJETONS.FieldByName('DOSSIER').asstring:=PQuery.FieldbyName('CON_NOM').asstring;
                               cdsJETONS.FieldByName('SERVER').asstring:=PQuery.FieldbyName('CON_SERVER').asstring;
                               cdsJETONS.FieldByName('DATABASE').asstring:=PQuery.FieldbyName('CON_PATH').asstring;
                               cdsJETONS.FieldByName('HRFLAG').AsBoolean:=false;
                               cdsJETONS.Post;
                          end;
                         PQuery.Next;
                    end;

                PQuery.Close;
           end;
        DataMod.FDConLiteConnexion.Close;
     finally
       PQuery.Free;
     end;
end;


procedure TFormVJETON.BStartClick(Sender: TObject);
begin
      Stop:=False;
end;

procedure TFormVJETON.BStopClick(Sender: TObject);
begin
     Stop:=true;

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

procedure TFormVJETON.BACTUALISERClick(Sender: TObject);
begin
     Raichissement(True);
end;

procedure TFormVJETON.FormCreate(Sender: TObject);
var PQuery:TFDQuery;
    i:Integer;
    param:string;
    value:string;
begin
     Application.OnMessage := AppMessage;
     // DecimalSeparator:='.';
     FStop:=true;
     //-------------------------------------------------------------------------
     FUrl     := path_script + script;
     FUrl_hr  := path_script + script_hr;
     FUrl_hr0 := path_script + script_hr0;
     // FFile:='';
     FAuto:=False;
     for i :=1 to ParamCount do
      begin
            If lowercase(ParamStr(i))='-start' then Stop:=false;
            If lowercase(ParamStr(i))='-auto'  then FAuto:=true;
            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-path'      then Load_Param('path',value);
            If lowercase(param)='-tempo'     then Load_Param('tempo',value);
      end;
     PQuery:=TFDQuery.Create(DataMod);
     PQuery.Connection:=DataMod.FDConLiteConnexion;
     PQuery.SQL.Clear;
     PQuery.SQL.Add('SELECT * FROM CONNEXION WHERE CON_FAV=1 ORDER BY CON_NOM');
     PQuery.Open;
     cdsJETONS.CreateDataSet;
     cdsJETONS.Open;
     while not(PQuery.Eof) do
        begin
             // Menu.Caption := Format('%s',[PQuery.FieldbyName('CON_NOM').asstring ]);
             // Quand on est en V11.3 pour le monitor on laisse à vide la CON_PATH
             if PQuery.FieldbyName('CON_PATH').asstring<>'' then
              begin
                   cdsJETONS.Append;
                   cdsJETONS.FieldByName('DOSSIER').asstring:=PQuery.FieldbyName('CON_NOM').asstring;
                   cdsJETONS.FieldByName('SERVER').asstring:=PQuery.FieldbyName('CON_SERVER').asstring;
                   cdsJETONS.FieldByName('DATABASE').asstring:=PQuery.FieldbyName('CON_PATH').asstring;
                   cdsJETONS.FieldByName('HRFLAG').AsBoolean:=false;
                   cdsJETONS.Post;
              end;
             PQuery.Next;
        end;
     PQuery.Close;
     PQuery.Free;
     Timer1.Interval:=1000*SpinEdit1.Value;
     cdsJETONS.First;
     FOk:=True;
     // Raichissement;
     Timer1.Enabled:=not(Stop);
     ShowWindow(Application.Handle, SW_HIDE) ;
     SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
     // ShowWindow(Application.Handle, SW_SHOW) ;
end;

procedure TFormVJETON.Load_Param(aparam:string;avalue:string);
begin
     if aparam='path'   then
      begin
           FUrl      := avalue + script;
           FUrl_hr   := avalue + script_hr;
           FUrl_hr0  := avalue + script_hr0;
      end;
     // if aparam='file' then FFile := avalue;
     if aparam='tempo' then
        begin
             Ftempo   := StrToInt(avalue);
             SpinEdit1.Value :=Ftempo;
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

procedure TFormVJETON.Quitter1Click(Sender: TObject);
begin
     Application.Terminate;
end;

end.

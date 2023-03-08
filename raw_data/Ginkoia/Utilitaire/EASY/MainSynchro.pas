/// <summary>
/// Unité Fenetre Principale de la Synchronisation Offline
/// </summary>
unit MainSynchro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uOfflineSynchroThread,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Menus, {cxButtons,} Vcl.Buttons, Math {,
  dxGDIPlusClasses};

Const IsReleaseMode : Boolean = {$IFDEF RELEASE}True{$ELSE}False{$ENDIF};

type
  TFrm_MainSynchro = class(TForm)
    lbl_status: TLabel;
    mLog: TMemo;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar: TProgressBar;
    Panel3: TPanel;
    Lbl_Last: TLabel;
    BSynchroniser: TBitBtn;
    Timer: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    pOurvir: TMenuItem;
    pQuitter: TMenuItem;
    Panel4: TPanel;
    Label1: TLabel;
    Panel5: TPanel;
    procedure BSynchronizeClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure pOurvirClick(Sender: TObject);
    procedure pQuitterClick(Sender: TObject);
  private
    { Déclarations privées }
    FCanClose  : Boolean;
    FService   : string;  // EASY
    FAuto      : boolean;
    FFrequence : integer;  // en secondes
    FTimeLeft  : integer;
    FOfflineSynchroTHread : TOfflineSynchroThread;

    FFTP_USER     : string;
    FFTP_PASSWORD : string;
    FFTP_HOST     : string;

    procedure SYNCHRO(const aMessage:Boolean=False);
    procedure LastSynchroDateTime;
    procedure StatusCallBack(Const s:String);
    Procedure ProgressCallBack(Const value:integer);
    procedure OfflineEndCallBack(Sender: TObject);
    procedure SetFrequence(nbsec:string);
    procedure SetService(serviceName:string);
    procedure SetFTP(ftpcnx:string);
  public
  // property Frequence : integer read FFrequence write SetFrequence;
    { Déclarations publiques }
  end;

var
  Frm_MainSynchro: TFrm_MainSynchro;

implementation

{$R *.dfm}

Uses UCommun;

Procedure TFrm_MainSynchro.ProgressCallBack(Const value:integer);
begin
    ProgressBar.Visible  := true;
    ProgressBar.Position := value;
end;


procedure TFrm_MainSynchro.BSynchronizeClick(Sender: TObject);
begin
   SYNCHRO(true);
end;

procedure TFrm_MainSynchro.SYNCHRO(const aMessage:Boolean=False);
begin
  if FService=''
    then
      begin
          if aMessage
            then  MessageDlg('Vous devez lancer cette application avec un paramètre',  mtError, [mbOK], 0);
          exit;
      end;
  BSynchroniser.Enabled:=False;
  mLog.Lines.Clear; // pas forcement
  FCanClose := false;
  FOfflineSynchroTHread := TOfflineSynchroThread.Create(FService,IsReleaseMode,StatusCallBack,ProgressCallBack,OfflineEndCallBack);
  // Les paramètres devrait venir du "service" non ?
  FOfflineSynchroTHread.FTP_Username := FFTP_USER;
  FOfflineSynchroTHread.FTP_Password := FFTP_PASSWORD;
  FOfflineSynchroTHread.FTP_Host     := FFTP_HOST;

  FOfflineSynchroTHread.Start;
end;

Procedure TFrm_MainSynchro.StatusCallBack(Const s:String);
begin
  Lbl_Status.Caption  := s;
  mLog.Lines.Add(FormatDateTime('[yyyy-mm-dd hh:nn:ss]',Now) + ' : ' +s);
end;


procedure TFrm_MainSynchro.TimerTimer(Sender: TObject);
var vTime:TDateTime;
begin
   Dec(FTimeLeft);
   if FTimeLeft<=0 then
     begin
       Timer.Enabled := false;
       Ftimeleft := FFrequence;
       SYNCHRO(false);
     end;
  vTime := FTimeLeft / SecsPerDay;
  label1.Caption := FormatDateTime('hh:nn:ss', vTime);
end;

procedure TFrm_MainSynchro.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    Self.Hide;
    CanClose:=FCanClose;
end;

procedure TFrm_MainSynchro.SetFrequence(nbsec:string);
begin
     FFrequence:=Math.Max(StrToIntDef(nbSec,60),60);
end;

procedure TFrm_MainSynchro.SetService(ServiceName:string);
begin
   FService := ServiceName;
end;

procedure TFrm_MainSynchro.SetFTP(ftpcnx:string);
var vSeparator1,vSeparator2 :Integer;
begin
  vSeparator1    := Pos(':',ftpcnx);
  vSeparator2    := Pos('@',ftpcnx);
  FFTP_USER      := Copy(ftpcnx,1,vSeparator1-1);
  FFTP_Password  := Copy(ftpcnx,vSeparator1+1,vSeparator2-vSeparator1-1);
  FFTP_Host      := Copy(ftpcnx,vSeparator2+1,Length(ftpcnx));
end;


procedure TFrm_MainSynchro.FormCreate(Sender: TObject);
var I: Integer;
    param:string;
    value:string;
begin
    FCanClose := false;
    FAuto := false;
    FFTP_USER      := '';
    FFTP_Password  := '';
    FFTP_Host      := '';

    for I := 1 to ParamCount do
      begin
        If lowercase(ParamStr(i))='-auto' then FAUTO:=true;
        // ---------------------------------------------------------------------
        param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
        value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
        If lowercase(param)='-f'   then SetFrequence(value);
        If lowercase(param)='-s'   then SetService(value);
        if LowerCase(param)='-ftp' then SetFTP(value);
      end;

    If FService<>''
      then Caption := Caption + ' / ' + FService ;


    If not(IsReleaseMode)
      then Caption := Caption + ' :: Mode Debug' ;

    // Recup de la dernière fois qu'on a fait le synchro... dans le .ini
    LastSynchroDateTime();
    Timer.Enabled := FAuto;
    FTimeLeft := 1;
    TrayIcon1.Hint := Caption;
end;

procedure TFrm_MainSynchro.LastSynchroDateTime;
var vStrDate : string;
begin
    // Recup de la dernière fois qu'on a fait le synchro... dans le .ini
    vStrDate := LoadStrFromIniFile('Synchro','Last');
    if vStrDate<>''
      then Lbl_Last.Caption := vStrDate;
end;

procedure TFrm_MainSynchro.OfflineEndCallBack(Sender: TObject);
begin
  // lbl_Status.Caption:='Traitement Terminé avec Succès';
  ProgressCallBack(100);
  LastSynchroDateTime();
  Lbl_Status.Caption  := '';
  // ProgressBar.Visible  := false;
  BSynchroniser.Enabled:=true;
  if FAuto then Timer.Enabled := true;
  // FCanClose := true;
end;


procedure TFrm_MainSynchro.pOurvirClick(Sender: TObject);
begin
   Self.Show;
   Application.BringToFront;
end;

procedure TFrm_MainSynchro.pQuitterClick(Sender: TObject);
begin
    FCanClose:=False;
    if Application.MessageBox('Voulez-vous quitter la Synchro EASY ?',
      PChar('Synchro EASY'), MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 +
      MB_TOPMOST) = IDYES then
       begin
         FCanClose:=true;
         Close;
       end;
end;

end.

unit Main_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uLogs, StdCtrls, LMDPNGImage, ExtCtrls, StrUtils, IBServices,
  IdMessage, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, Registry;

type
  Tfrm_Main = class(TForm)
    Pan_Top: TPanel;
    Pan_Client: TPanel;
    mmLogs: TMemo;
    Img_Logo: TImage;
    Tim_AutoMode: TTimer;
    IBServerProperties: TIBServerProperties;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdMessage1: TIdMessage;
    Lab_Titre: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Tim_AutoModeTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
    bAutoMode, bRestartMode, bStandardMail, bWorkInProgress : Boolean;
    sSENDTO, sNOMMAG : String;

    GAPPPATH, GPATHLOGS : string;

  public
    { Déclarations publiques }

    // procédure de reboot et de redémarrage du logiciel
    procedure RestartAndRunOnce(AFileToRestart : String);
    // procédure d'attente du démarrage du service
    Procedure WaitService;

    procedure SendMail(ASujet, AText, ASendTo : string);
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not bWorkInProgress;
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  bWorkInProgress := False;
  GAPPPATH := ExtractFilePath(Application.ExeName);
  GPATHLOGS := GAPPPATH + 'Logs\';

  ForceDirectories(GPATHLOGS);

  // Paramétrage du fichier de logs
  Logs.Path := GPATHLOGS;
  Logs.FileName := 'RebootMachine.txt';
  Logs.Memo := mmLogs;

   // Gestion des paramètres passés au logiciel
   bAutoMode := False;
   bRestartMode := False;
   bStandardMail := True;
   sSENDTO := 'adminginkoia@gmail.com';
   if ParamCount > 0 then
   begin
     for i := 1 to ParamCount do
     begin
       case AnsiIndexStr(UpperCase(ParamStr(i)),['AUTO','RESTART']) of
         // AUTO
         0: bAutoMode := True;
         // RESTART
         1: begin
           bRestartMode := True;
           if FileExists(GPATHLOGS + Logs.FileName) then
             mmLogs.Lines.LoadFromFile(GPATHLOGS + Logs.FileName);
         end;
         else begin
           if Pos('EMAIL:',UpperCase(ParamStr(i))) > 0 then
           begin
             sSENDTO := Copy(ParamStr(i),7, Length(ParamStr(i)));
             bStandardMail := False;
           end;

           if Pos('NOM:',UpperCase(ParamStr(i))) > 0 then
             sNOMMAG := Copy(ParamStr(i),5,Length(ParamStr(i)));
         end;
       end;
     end;
   end;

   if bAutoMode or bRestartMode then
   begin
     Lab_Titre.Visible := True;
     Tim_AutoMode.Enabled := True;
   end;
end;

procedure Tfrm_Main.RestartAndRunOnce(AFileToRestart: String);
var
  Reg : TRegistry;
  hToken,
  hProcess  : THandle;
  tp,
  prev_tp   : TTokenPrivileges;
  Len       : DWORD;

begin
  reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
    reg.WriteString('RESTARTAPP', AFileToRestart);
  finally
    reg.free;
  end;

  hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
  if OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    CloseHandle(hProcess);
    if LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.PrivilegeCount := 1;
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      if AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) then
      begin
        CloseHandle(hToken);

        ExitWindowsEx(EWX_FORCE or EWX_REBOOT, 0);
        HALT;
      end;
    end;
  end;
end;

procedure Tfrm_Main.SendMail(ASujet, AText, ASendTo : string);
begin
  With IdMessage1 do
  begin
    Subject := ASujet;
    Body.Text := AText;
    From.Text := 'Admin@ginkoia.fr';
    Recipients.EMailAddresses := ASendTo;
  end;

  With IdSMTP1 do
  Try
    Host     := 'pod51015.outlook.com';
    Username := 'Admin@ginkoia.fr';
    Password := 'Duda7196741';

    Try
      Port := 587;
      Connect;
    Except on E:Exception do
      begin
        try
        Port := 25;
        Connect;
        Except on E:Exception do
          Logs.AddToLogs('  -> SendMailList Connexion -> ' + E.Message);
        end;
      end;
    End;

    Send(IdMessage1);
  Except on E:Exception do
    begin
      Logs.AddToLogs('  -> SendMailList Envoi -> ' + E.Message);
    end;
  end;

end;

procedure Tfrm_Main.Tim_AutoModeTimer(Sender: TObject);
var
  sRebootCmd : String;
begin
  Tim_AutoMode.Enabled := False;
  bWorkInProgress := True;
  Try
  if not bRestartMode then
  begin
    Logs.AddToLogs('----------------------------------------------------------');
    Logs.AddToLogs('Début du traitement');
    Logs.AddToLogs('----------------------------------------------------------');
    // Envoi du mail
    Logs.AddToLogs('Mail de démarrage');
    SendMail(Format('RM - %s - Mail d''informations 1/2',[sNOMMAG]),'Démarrage de l''application',sSENDTO);

    // reboot de la machine
    sRebootCmd := Format('%s %s NOM:%s',[ParamStr(0),'RESTART',sNOMMAG]);
    if not bStandardMail then
    begin
      sRebootCmd := sRebootCmd + ' EMAIL:' + sSENDTO;
      Logs.AddToLogs('Sender : ' + sSENDTO);
    end;
    Logs.AddToLogs('Reboot du poste');
    RestartAndRunOnce(sRebootCmd);
  end
  else begin
    Logs.AddToLogs('Redémarrage effectué attente du démarrage du service interbase');

    // attente démarrage service interbase
    WaitService;

    // Envoi du mail
    Logs.AddToLogs('Mail de fin de traitement');
    SendMail(Format('RM - %s - Mail d''informations 2/2',[sNOMMAG]),'Reboot Ok',sSENDTO);
  end;
  Except on E:Exception do
    Logs.AddToLogs('DoProcess -> ' + E.Message);
  End;

  Logs.AddToLogs('Fin du traitement');
  bWorkInProgress := False;
  Application.Terminate;
end;

procedure Tfrm_Main.WaitService;
var
  bConnexion : Boolean;
  i : integer;
begin
  bConnexion := False;
  With IBServerProperties do
    while not bConnexion do
    begin
      try
        Active := True;
        bConnexion := True;
      except on E: Exception do
        begin
          Logs.AddToLogs('Echec connexion service Interbase');
          for i := 1 to 5000 do
          begin
            Sleep(1);
            Application.ProcessMessages;
          end;
        end;
      end;
    end;
end;

end.

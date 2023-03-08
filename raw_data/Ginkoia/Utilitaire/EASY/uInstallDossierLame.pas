unit uInstallDossierLame;

interface

Uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ComCtrls, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,System.Win.Registry,
  Vcl.ExtCtrls, Math, UWMI,System.IniFiles, UCommun, uLog;

type
  TInstallDossierLameThread = class(TThread)
  private
    FStatusProc   : TStatusMessageCall;
    FProgressProc : TProgressMessageCall;
    FProgress     : integer;
    FStatus       : string;
    FDB           : TDossierInfos;
    FEASY         : TSymmetricDS;
    FNumError     : integer;
    Procedure StatusCallBack;
    Procedure ProgressCallBack;
  protected
    {--}
  public
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil); reintroduce;
    property DB   : TDossierINfos read FDB    write FDB;
    property EASY : TSymmetricDS  read FEASY  write FEASY;
    property NumError : Integer   read FNumError write FNumError;
  end;


implementation

Uses uDataMod, ServiceControler;

procedure TInstallDossierLameThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TInstallDossierLameThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;

constructor TInstallDossierLameThread.Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FStatusProc         := aStatusCallBack;
    FProgressProc       := aProgressCallBack;
    OnTerminate         := aEvent;
    FProgress           := 0;
    FNumError           := 1;
    FStatus             := 'Init';
    FreeOnTerminate     := true;
end;

procedure TInstallDossierLameThread.Execute;
var i:Integer;
    vTotal,vCurrent:integer;
begin
   try
      try
      Synchronize(StatusCallBack);

      if not(JAVAInstalled(0)) then
        begin
          FStatus:='Installation de JAVA';
          FProgress := 2;
          Synchronize(StatusCallBack);
          Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_JAVA, logNotice, True, 0, ltServer);
          InstallJAVA(0);
        end;

      FStatus:='Installation de SymmetricDS ' + Easy.Nom;
      Synchronize(StatusCallBack);

      // FNumError := 9;
      // raise Exception.Create('Erreur à l''installation de SymmetricDS');         // Pour TEST

      FProgress := 5;
      Synchronize(ProgressCallBack);
      Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_SYMDS, logNotice, True, 0, ltServer);
      If not(DataMod.InstallationSymmetricDS(EASY,false))
        then
          begin
              FNumError := 3;
              raise Exception.Create('Erreur à l''installation de SymmetricDS');
          end;

      FStatus:='Liaison avec le Dossier...';
      Synchronize(StatusCallBack);

      FProgress := 30;
      Synchronize(ProgressCallBack);

      if not(DataMod.Installation_Master(DB))
        then
          begin
              FNumError := 4;
              raise Exception.Create('Erreur à l''installation du noeaud maitre');
          end;

      FStatus:='Démarrage du Service ' + EASY.Nom;
      Synchronize(StatusCallBack);

      FProgress := 40;
      Synchronize(ProgressCallBack);

      // Pour TEST
      // FNumError := 5;
      // raise Exception.Create('Erreur au démarrage du service');
      // Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_START_SERVICE , logError, True, 0, ltServer);

      If ServiceStart('',EASY.Nom)
        then Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_START_SERVICE , logNotice, True, 0, ltServer)
        else
          begin
              FNumError := 5;
              raise Exception.Create('Erreur au démarrage du service');
              Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_START_SERVICE , logError, True, 0, ltServer);
          end;

      Sleep(10000); // Attente de 10 secondes le temps de passer les Grants ??

      FStatus:='Installation des Triggers...';
      Synchronize(StatusCallBack);
      Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_TRIGGERS_BEGIN , logNotice, True, 0, ltServer);

      FProgress := 50;
      Synchronize(ProgressCallBack);

      vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);
      vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
      i:=0;
      while (vCurrent<vTotal) and (i<100) do
        begin
          vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
          vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);
          if (i mod 15=0) then  // donc trace toutes les 30 s
            begin
                Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', Format(MSG_CC_INSTALL_TRIGGERS,[vCurrent,vTotal]) , logNotice, True, 0, ltServer);
            end;
          FProgress := 50 + Round(50*vCurrent/vTotal);
          inc(i);
          Synchronize(ProgressCallBack);
          Sleep(2000);
        end;

      // Dernier controle
      vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
      vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);

      if vCurrent=vTotal
        then
          begin
            Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', Format(MSG_CC_INSTALL_TRIGGERS,[vCurrent,vTotal]) , logNotice, True, 0, ltServer);
            Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_TRIGGERS_END , logNotice, True, 0, ltServer);
          end
        else
          begin
            Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', Format(MSG_CC_INSTALL_TRIGGERS,[vCurrent,vTotal]) , logError, True, 0, ltServer);
            Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_TRIGGERS_END , logError, True, 0, ltServer);
          end;
      //--- On Ajoute le dossier dans le .ini du BackupLame --------------------
      try
        DataMod.AjouteDossierBackupLame(DB);
      Except
        // C'est pas grave on le fera à la main...
      end;
      // -----------------------------------------------------------------------
      FStatus:='Fin...';
      Synchronize(StatusCallBack);
      // On arrive ca donc on passe a NumError=0
      FNumError := 0;
      except
        On E:Exception do
          begin
              Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_CC_INSTALL_ERROR + E.Message , logError, True, 0, ltServer);
          end;
      end;
   finally
      FProgress := 100;
      Synchronize(ProgressCallBack);
   end;
end;

end.

unit uThreadWMI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, System.IniFiles, Winapi.WinSvc, System.RegularExpressionsCore, uLog, UWMI, IdURI, Math;

Type
  TMenuServiceAction = (MenuServiceStop, MenuServiceStart, MenuServiceRestart);
  TMenuExeAction = (MenuExeStop, MenuExeStart);

  TThreadWMI = class(TThread)
  private
    { Déclarations privées }
    PI_BackupRest: TprocessInfos;
    PI_Ginkoia: TprocessInfos;
    PI_Interbase: TprocessInfos;
    PI_Verification: TprocessInfos;
    PI_PG: TGroupProcessInfos;
    PI_Piccobatch: TprocessInfos;
    SE_EASY: TEASYInfos;
    SE_MAJ: TServiceInfos;
    SE_MOB: TServiceInfos;
    SE_REPR: TServiceInfos;
    SE_BI: TServiceInfos;
    DRIVES: TDrives;
    FURL       : string;
    procedure GetProcessInfos;
    procedure GetServicesInfos;
    procedure GetDrivesInfos;
    procedure UpdateVCL();
    function ParseRegistrationURL(aURL: string): string;
  public
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean; const AEvent: TNotifyEvent = nil); reintroduce;
    property URL     : string       read FURL;
    { Déclarations publiques }
  end;

implementation

Uses uMainForm;

procedure TThreadWMI.UpdateVCL();
var
  i, errorCount: integer;
  vLibre: double;
  vLibreMo: double;
  vRAM: double;
  vCPU1: double;
  vCPU: double;
  vPrcLibre: double;
  // vBase0     : string;
  vRamPG: double;
  vTotal: double;
  vDriveBase: string;
  vBase0Size: double;
  vMessage: string;
  maxLvl: TLogLevel;
begin
  // On récup le configDir de EASY Sert pour le LOG (autre Thread)
  If (Frm_Launcher.EasyLog <> SE_EASY.ConfigDir + '\..\logs\symmetric.log') then
    Frm_Launcher.EasyLog := SE_EASY.ConfigDir + '\..\logs\symmetric.log';

  // Postgresql
  if PI_PG.NbProcess > 0 then
  begin
    vRamPG := StrToInt64Def(PI_PG.SumProcess.WorkingSetSize, 0) / 1024 / 1024;
    Frm_Launcher.EventPanel[CID_PG].Detail := Format('PROC:%d' + #13 + #10 + 'RAM: %0.2fMo', [PI_PG.NbProcess, vRamPG]);
    Frm_Launcher.EventPanel[CID_PG].Hint := FormatDateTime('dd/mm/yyyy hh:nn', Now()) + #13 + #10 + Format('PROC:%d' + #13 + #10 + 'RAM: %0.2fMo',
      [PI_PG.NbProcess, vRamPG]);
    Frm_Launcher.EventPanel[CID_PG].Level := logInfo;
  end
  else // on est surment pas en EASY
    Frm_Launcher.EventPanel[CID_PG].Visible := false;

  // Interbase
  if PI_Interbase.PID <> '' then
  begin
    vRAM := StrToInt64Def(PI_Interbase.WorkingSetSize, 0) / 1024 / 1024;

    // sur quand on est proche du 100 sur un proc ca commence à être chaud
    vCPU1 := StrToIntDef(PI_Interbase.PercentProcessorTime, 0);
    Frm_Launcher.EventPanel[CID_Interbase].Level := logInfo;
    if vCPU1 > 80 then
    begin
      Frm_Launcher.EventPanel[CID_Interbase].Level := logNotice;
    end;
    if vCPU1 = 100 then
    begin
      Frm_Launcher.EventPanel[CID_Interbase].Level := logWarning; // Ca chauffre !
    end;
    // la valeur du Gestionnaire de Taches
    // il faur diviser par le nombre de preocesseur logiques
    vCPU := vCPU1 / VGSE.OSInfos.NbProcessors;

    Frm_Launcher.EventPanel[CID_Interbase].Detail := Format('CPU: %0.1f%% (%0.1f%%)' + #13 + #10 + 'RAM: %0.2fMo', [vCPU, vCPU1, vRAM]);
    Frm_Launcher.EventPanel[CID_Interbase].Hint := FormatDateTime('dd/mm/yyyy hh:nn', Now()) + #13 + #10 +
      Format('CPU: %0.1f%% (%0.1f%%)' + #13 + #10 + 'RAM: %0.2fMo', [vCPU, vCPU1, vRAM]);
  end
  else
  begin
    Frm_Launcher.EventPanel[CID_Interbase].Level := logEmergency;
    Frm_Launcher.EventPanel[CID_Interbase].Detail := 'Aucun Processus';
    Frm_Launcher.EventPanel[CID_Interbase].Hint := '';
  end;

  // Service de mobilité
  Frm_Launcher.EventPanel[CID_MOBILITE].Hint := 'Mobilité';
  if SE_MOB.Status = '' then
  begin
    Frm_Launcher.EventPanel[CID_MOBILITE].Detail := 'Pas installé'; // c'est pas forcement une erreur
    Frm_Launcher.EventPanel[CID_MOBILITE].Level := logNone;
    Frm_Launcher.EventPanel[CID_MOBILITE].Visible := false;
  end
  else
    Frm_Launcher.EventPanel[CID_MOBILITE].Visible := true;

  if (SE_MOB.Status = 'Stopped') then
  begin
    Frm_Launcher.EventPanel[CID_MOBILITE].Detail := 'Arrêté';
    Frm_Launcher.EventPanel[CID_MOBILITE].Level := logError;
  end;

  if SE_MOB.Status = 'Running' then
  begin
    Frm_Launcher.EventPanel[CID_MOBILITE].Detail := 'En Cours...';
    Frm_Launcher.EventPanel[CID_MOBILITE].Level := logInfo;
  end;

  // gestion du popupmenu en fonction de l'état du service
  if Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu <> nil then
  begin
    For i := 0 to Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items.Count - 1 do
    begin
      if (TMenuServiceAction(Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Tag) = MenuServiceStop) or
        (TMenuServiceAction(Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Tag) = MenuServiceRestart) then
      begin
        if (SE_MOB.Status = 'Stopped') then
          Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Enabled := true;
      end;

      if TMenuServiceAction(Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Tag) = MenuServiceStart then
      begin
        if (SE_MOB.Status = 'Running') then
          Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_MOBILITE].PopMenu.Items[i].Enabled := true;
      end;
    end;
  end;

  // Service de reprise
  Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Hint := 'Service reprise';
  if SE_REPR.Status = '' then
  begin
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Detail := 'Pas installé'; // c'est pas forcement une erreur
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Level := logNone;
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Visible := false;
  end
  else
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Visible := true;

  if (SE_REPR.Status = 'Stopped') then
  begin
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Detail := 'Arrêté';
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Level := logError;
  end;

  if SE_REPR.Status = 'Running' then
  begin
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Detail := 'En Cours...';
    Frm_Launcher.EventPanel[CID_SERVICEREPRISE].Level := logInfo;
  end;

  // gestion du popupmenu en fonction de l'état du service
  if Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu <> nil then
  begin
    For i := 0 to Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items.Count - 1 do
    begin
      if (TMenuServiceAction(Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Tag) = MenuServiceStop) or
        (TMenuServiceAction(Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Tag) = MenuServiceRestart) then
      begin
        if (SE_REPR.Status = 'Stopped') then
          Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Enabled := true;
      end;

      if TMenuServiceAction(Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Tag) = MenuServiceStart then
      begin
        if (SE_REPR.Status = 'Running') then
          Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_SERVICEREPRISE].PopMenu.Items[i].Enabled := true;
      end;
    end;
  end;

  // SERVICE BI
  Frm_Launcher.EventPanel[CID_BI].Hint := 'Service BI';
  if SE_BI.Status = '' then
  begin
    Frm_Launcher.EventPanel[CID_BI].Detail := 'Pas installé'; // c'est pas forcement une erreur
    Frm_Launcher.EventPanel[CID_BI].Level := logNone;
    Frm_Launcher.EventPanel[CID_BI].Visible := false;
  end
  else
    Frm_Launcher.EventPanel[CID_BI].Visible := true;

  if (SE_BI.Status = 'Stopped') then
  begin
    Frm_Launcher.EventPanel[CID_BI].Detail := 'Arrêté';
    Frm_Launcher.EventPanel[CID_BI].Level := logError;
  end;

  if SE_BI.Status = 'Running' then
  begin
    Frm_Launcher.EventPanel[CID_BI].Detail := 'En Cours...';
    Frm_Launcher.EventPanel[CID_BI].Level := logInfo;
  end;

  // gestion du popupmenu en fonction de l'état du service
  if Frm_Launcher.EventPanel[CID_BI].PopMenu <> nil then
  begin
    For i := 0 to Frm_Launcher.EventPanel[CID_BI].PopMenu.Items.Count - 1 do
    begin
      // Si le service n'est pas installé, on désactive tout
      if SE_BI.Status = '' then
        Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Enabled := false
      else
      begin
        if (TMenuServiceAction(Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Tag) = MenuServiceStop) or
          (TMenuServiceAction(Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Tag) = MenuServiceRestart) then
        begin
          if (SE_BI.Status = 'Stopped') then
            Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Enabled := false
          else
            Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Enabled := true;
        end;

        if TMenuServiceAction(Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Tag) = MenuServiceStart then
        begin
          if (SE_BI.Status = 'Running') then
            Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Enabled := false
          else
            Frm_Launcher.EventPanel[CID_BI].PopMenu.Items[i].Enabled := true;
        end;
      end;
    end;
  end;

  // tuile de Piccobatch quand configuré en démarrage automatique
  Frm_Launcher.EventPanel[CID_PICCOBATCH].Hint := 'Piccobatch';

  if (PI_Piccobatch.PID <> '') then
  begin
    // Signifie en cours...
    Frm_Launcher.EventPanel[CID_PICCOBATCH].Level := logInfo;
    Frm_Launcher.EventPanel[CID_PICCOBATCH].Detail := 'Démarré';
    Frm_Launcher.VerifRunning := 1;
  end
  else
  begin
    Frm_Launcher.EventPanel[CID_PICCOBATCH].Level := logError;
    Frm_Launcher.EventPanel[CID_PICCOBATCH].Detail := 'Arrêté';
    Frm_Launcher.VerifRunning := 1;
  end;

  // gestion du popupmenu en fonction de l'état du service
  if Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu <> nil then
  begin
    For i := 0 to Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items.Count - 1 do
    begin
      if (TMenuExeAction(Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items[i].Tag) = MenuExeStop) then
      begin
        if (PI_Piccobatch.PID <> '') then
          Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items[i].Enabled := true
        else
          Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items[i].Enabled := false;
      end;

      if TMenuExeAction(Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items[i].Tag) = MenuExeStart then
      begin
        if (PI_Piccobatch.PID <> '') then
          Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_PICCOBATCH].PopMenu.Items[i].Enabled := true;
      end;
    end;
  end;

  // Service de MAJ
  if SE_MAJ.Status = '' then
  begin
    Frm_Launcher.EventPanel[CID_MAJ].Detail := 'Pas installé';
    Frm_Launcher.EventPanel[CID_MAJ].Level := logNone;
    Frm_Launcher.EventPanel[CID_MAJ].Visible := false;
  end
  else
    Frm_Launcher.EventPanel[CID_MAJ].Visible := true;

  if (SE_MAJ.Status = 'Stopped') then
  begin
    Frm_Launcher.EventPanel[CID_MAJ].Detail := 'Arrêté';
    Frm_Launcher.EventPanel[CID_MAJ].Level := logWarning;
  end;
  if SE_MAJ.Status = 'Running' then
  begin
    Frm_Launcher.EventPanel[CID_MAJ].Detail := 'En Cours...';
    Frm_Launcher.EventPanel[CID_MAJ].Level := logInfo;
  end;

  If (SE_EASY.Status = '') then
  begin
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].Detail := 'Pas Installé';
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].Level := logEmergency;
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].InfoValue1 := 'Service EASY pas installé';
    Frm_Launcher.EASYRunning := 0;
  end;

  If (SE_EASY.Status = 'Stopped') then
  begin
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].Detail := 'Service EASY Arrêté';
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].Level := logError;
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].InfoValue1 := 'Service EASY Arrêté';
    Frm_Launcher.EASYRunning := 0;
  end;
  If (SE_EASY.Status = 'Running') then
  begin
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].Detail := FormatDateTime('dd/mm/yyyy hh:nn', Now());
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].Level := logInfo;
    Frm_Launcher.EventPanel[CID_SERVICE_EASY].InfoValue1 := 'Service EASY OK';
    Frm_Launcher.EASYRunning := 1;
  end;

  // Gestion du popup menu sur la tuile du service easy en fonction du service
  // gestion du popupmenu en fonction de l'état du service
  if Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu <> nil then
  begin
    For i := 0 to Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items.Count - 1 do
    begin
      if (TMenuServiceAction(Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Tag) = MenuServiceStop) or
        (TMenuServiceAction(Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Tag) = MenuServiceRestart) then
      begin
        if (SE_EASY.Status = 'Stopped') then
          Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Enabled := true;
      end;

      if TMenuServiceAction(Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Tag) = MenuServiceStart then
      begin
        if (SE_EASY.Status = 'Running') then
          Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Enabled := false
        else
          Frm_Launcher.EventPanel[CID_SERVICE_EASY].PopMenu.Items[i].Enabled := true;
      end;
    end;
  end;

  // Chemin Java ==> Parse version Java '/bin/java'

  // on remonte l'URL de registration pour l'administration directement depuis le monitoring
  Log.Log('ServiceEASY', Frm_Launcher.BasGUID, 'RegistrationURL', FURL, logInfo, true, 0, ltServer);

  Frm_Launcher.EventPanel[CID_JAVA_VERSION].Detail := SE_EASY.JavaFullVersion;
  Frm_Launcher.EventPanel[CID_JAVA_VERSION].Hint := SE_EASY.JavaPath;

  if (PI_Verification.PID <> '') then
  begin
    // Signifie en cours...
    Frm_Launcher.EventPanel[CID_MAJ].Level := logNotice;
    Frm_Launcher.EventPanel[CID_MAJ].Detail := 'En cours...';
    Frm_Launcher.VerifRunning := 1;
  end
  else
  begin
    If (Frm_Launcher.EventPanel[CID_MAJ].Level = logNotice) then
    begin
      // On passe en Terminé
      // Frm_Launcher.EventPanel[CID_MAJ].Detail  := 'Terminé';
      // Frm_Launcher.EventPanel[CID_MAJ].Level   := logInfo;
      // Ne tourne Plus
      Frm_Launcher.UpdateVerif();
    end;
    Frm_Launcher.VerifRunning := 0;
    // Frm_Launcher.VerifTime
  end;

  Frm_Launcher.EventPanel[CID_DRIVES].Detail := FormatDateTime('dd/mm/yyyy hh:nn', Now());
  Frm_Launcher.EventPanel[CID_DRIVES].Level := logInfo;
  Frm_Launcher.EventPanel[CID_DRIVES].Hint := '';
  vDriveBase := ExtractFileDrive(VGSE.Base0);
  // Il faut recup la taille du fichier VGSE.BASE0 ici en Go
  vBase0Size := FileSize(VGSE.Base0) / 1024 / 1024;

  Frm_Launcher.EventPanel[CID_DRIVES].Level := logInfo;
  For i := Low(DRIVES) to High(DRIVES) do
  begin
    // Taille en Mo
    vLibre := StrToInt64(DRIVES[i].FreeSpace) / 1024 / 1024;
    vTotal := StrToInt64(DRIVES[i].Size) / 1024 / 1024;

    vPrcLibre := (vLibre * 100 / vTotal);
    { --- Finalement on ne log pas spécalement le C---
      if (Drives[i].DeviceID='C:') and (vPrcLibre<2)  // inférieur à 2%
      then
      begin
      Frm_Launcher.EventPanel[CID_DRIVES].Level  := logWarning;
      end;

      if (Drives[i].DeviceID='C:') and (vPrcLibre<1)  // inférieur à 1%
      then
      begin
      Frm_Launcher.EventPanel[CID_DRIVES].Level  := logError;
      end;
    }
    // lettre de la base
    vMessage := '';
    if vDriveBase = DRIVES[i].DeviceID then
    begin
      Frm_Launcher.EventPanel[CID_DRIVES].InfoValue1 := FloatToStr(Ceil(vBase0Size));
      Frm_Launcher.EventPanel[CID_DRIVES].InfoValue2 := FloatToStr(Ceil(vLibre));
      Frm_Launcher.Base0Size := Ceil(vBase0Size);
      if (vLibre < 2 * vBase0Size) then
      begin
        If (Frm_Launcher.EventPanel[CID_DRIVES].Level < logError) then
          Frm_Launcher.EventPanel[CID_DRIVES].Level := logWarning;
        vMessage := ' (Erreur : Pas assez de place pour la sauvegarde)';
      end
    end;
    Frm_Launcher.EventPanel[CID_DRIVES].Hint := Frm_Launcher.EventPanel[CID_DRIVES].Hint + Format('%s %.2f Mo de libre (%.2f%% de libre) %s',
      [DRIVES[i].DeviceID, vLibre, vPrcLibre, vMessage]);
    If i < High(DRIVES) then
      Frm_Launcher.EventPanel[CID_DRIVES].Hint := Frm_Launcher.EventPanel[CID_DRIVES].Hint + #13 + #10;
  end;

  if (PI_BackupRest.PID <> '') then
  begin
    // Signifie en cours...
    Frm_Launcher.EventPanel[CID_BACKREST].Level := logNotice;
    Frm_Launcher.EventPanel[CID_BACKREST].Detail := 'En cours...';
    Frm_Launcher.BackRestRunning := 1; // théoriquement c'est aussi à 1
  end
  else
  begin
    If (Frm_Launcher.BackRestRunning = 1) then
    begin
      Frm_Launcher.EventPanel[CID_BACKREST].Detail := 'Terminé';
      Frm_Launcher.BackRestEnd := true;
    end;
    Frm_Launcher.BackRestRunning := 0;
  end;

  {
    Calcul de la tuile de synchro basé sur
    service Easy
    heartbeat
    traffic
    interbase
  }
  maxLvl := TLogLevel(0);
  if (Frm_Launcher.EventPanel[CID_SERVICE_EASY].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_SERVICE_EASY].Level;
  if (Frm_Launcher.EventPanel[CID_HEARTBEAT].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_HEARTBEAT].Level;
  if (Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].Level;
  if (Frm_Launcher.EventPanel[CID_Interbase].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_Interbase].Level;

  // on affiche pas cette tuile en bleu, on la laisse en vert si en cours de traitement
  if (maxLvl = logNotice) then
    maxLvl := logInfo;

  // on récupère le lvl max des 4 tuiles NON !
  // Frm_Launcher.EventPanel[CID_SYNCHRONISATION].Level := maxLvl;
  // on met la date de la dernière réplication dans le détail
  // Frm_Launcher.EventPanel[CID_SYNCHRONISATION].Detail := Frm_Launcher.EventPanel[CID_TRAFFIC_ASC].Detail;

  {
    Calcul de la tuile de système basé sur
    occupation de la plage des K
    cloture des grands totaux
    verification.exe
    espace disque disponible
    java
    Easy log
    postgre
  }
  maxLvl := TLogLevel(0);
  // pour la plage de K on ne récupère le lvl que si c'est critique (lvl > 4)
  if (Frm_Launcher.EventPanel[CID_PLAGEK].Level > maxLvl) and (Frm_Launcher.EventPanel[CID_PLAGEK].Level > logWarning) then
    maxLvl := Frm_Launcher.EventPanel[CID_PLAGEK].Level;
  if (Frm_Launcher.EventPanel[CID_CGT].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_CGT].Level;
  if (Frm_Launcher.EventPanel[CID_VERIF].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_VERIF].Level;
  if (Frm_Launcher.EventPanel[CID_DRIVES].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_DRIVES].Level;
  if (Frm_Launcher.EventPanel[CID_JAVA_VERSION].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_JAVA_VERSION].Level;
  if (Frm_Launcher.EventPanel[CID_EASY_LOG].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_EASY_LOG].Level;
  if (Frm_Launcher.EventPanel[CID_PG].Level > maxLvl) then
    maxLvl := Frm_Launcher.EventPanel[CID_PG].Level;

  // on compte le nombre d'erreurs totales pour afficher dans le système
  errorCount := 0;
  if (Frm_Launcher.EventPanel[CID_PLAGEK].Level > logNotice) then
    errorCount := errorCount + 1;
  if (Frm_Launcher.EventPanel[CID_CGT].Level > logNotice) then
    errorCount := errorCount + 1;
  if (Frm_Launcher.EventPanel[CID_VERIF].Level > logNotice) then
    errorCount := errorCount + 1;
  if (Frm_Launcher.EventPanel[CID_DRIVES].Level > logNotice) then
    errorCount := errorCount + 1;
  if (Frm_Launcher.EventPanel[CID_JAVA_VERSION].Level > logNotice) then
    errorCount := errorCount + 1;
  if (Frm_Launcher.EventPanel[CID_EASY_LOG].Level > logNotice) then
    errorCount := errorCount + 1;
  if (Frm_Launcher.EventPanel[CID_PG].Level > logNotice) then
    errorCount := errorCount + 1;

  // on récupère le lvl max des 4 tuiles
  Frm_Launcher.EventPanel[CID_SYSTEME].Level := maxLvl;
  // on met le nombre d'erreurs dans le détail
  if errorCount > 0 then
    Frm_Launcher.EventPanel[CID_SYSTEME].Detail := '(' + IntToStr(errorCount) + ')'
  else
    Frm_Launcher.EventPanel[CID_SYSTEME].Detail := '';

end;

constructor TThreadWMI.Create(CreateSuspended: boolean; Const AEvent: TNotifyEvent = nil);

begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
  OnTerminate := AEvent;
end;

procedure TThreadWMI.Execute;
var vPort:word;
begin
  try
    GetDrivesInfos;
    GetServicesInfos;
    GetProcessInfos;
    FURL := ParseRegistrationURL(SE_EASY.registration_url);
  finally
    Synchronize(UpdateVCL);
  end;
end;


function TThreadWMI.ParseRegistrationURL(aURL: string): string;
var
  URI: TIdURI;
  vProtocol, vHost, vPort: string;
begin
  if aURL <> '' then
  begin
    URI := TIdURI.Create(aURL);
    try
      vProtocol := URI.Protocol;
      vHost := URI.Host;
      vPort := URI.Port;

      Result := vProtocol + '://' + vHost + ':' + vPort;
    finally
      URI.Free;
    end;
  end;
end;

procedure TThreadWMI.GetProcessInfos;
begin
  PI_BackupRest := WMI_GetProcessInfos('BackRest.exe');
  PI_Ginkoia := WMI_GetProcessInfos('Ginkoia.exe');
  PI_Verification := WMI_GetProcessInfos('verification.exe');
  PI_Interbase := WMI_GetProcessInfos('ibserver.exe');
  PI_PG := WMI_GetGroupProcessInfos('postgres.exe');
  PI_Piccobatch := WMI_GetProcessInfos('piccobatch.exe');
end;

procedure TThreadWMI.GetServicesInfos;
begin
  SE_EASY := WMI_GetServicesEASY();
  SE_MAJ  := WMI_GetService('SerMAJGINKOIA'); // GInkoiaMAJSvr
  SE_MOB  := WMI_GetService('GinkoiaMobiliteSvr');
  SE_REPR := WMI_GetService('GinkoiaServiceReprises');
  SE_BI   := WMI_GetService('Service_BI_Ginkoia');
end;

procedure TThreadWMI.GetDrivesInfos;
begin
  DRIVES := WMI_GetDrivesInfos;
end;

end.

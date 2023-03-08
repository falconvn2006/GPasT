unit USymDS;

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
  Vcl.ExtCtrls, Math, UWMI,System.IniFiles, UCommun, System.StrUtils,
  SymmetricDS.Commun, cHash,  ServiceControler,  System.RegularExpressionsCore;

type TThreadInstallSymDS = class(TThread)
       private
         FSYMDS : TSymmetricDS;
         FEvent : TNotifyEvent;
         FErrorMessage : string;
         FState        : string;
      protected
        procedure DoFinish;
        procedure DoRefreshState();
      public
        function Install()   : Boolean;
        procedure Execute; override;
    public
      constructor Create(CreateSuspended:boolean;aSymDS:TSymmetricDS); reintroduce;
    property ErrorMessage : string read FErrorMessage;
    property State        : string read FState;
    end;
    TThreadUnInstallSymDS = class(TThread)
       private
         FSYMDS : TSymmetricDS;
         FEvent : TNotifyEvent;
         FErrorMessage : string;
         FState        : string;
      protected
        procedure DoFinish;
        procedure DoRefreshState();
      public
        function UnInstall()   : Boolean;
        procedure Execute; override;
    public
        constructor Create(CreateSuspended:boolean;aSymDS:TSymmetricDS); reintroduce;
    property ErrorMessage : string read FErrorMessage;
    property State        : string read FState;
  end;

implementation

Uses FormUnit1;

procedure TThreadUnInstallSymDS.DoFinish;
begin
    VGSE.Lock :=false;
end;


constructor TThreadUnInstallSymDS.Create(CreateSuspended:boolean;aSymDS:TSymmetricDS);
begin
    inherited Create(CreateSuspended);
    FSYMDS           := aSymDS;
    FreeOnTerminate  := true;
end;


procedure TThreadUnInstallSymDS.Execute;
begin
    try
      UnInstall();
    finally
      Synchronize(DoFinish);
    end;
end;

function TThreadUnInstallSymDS.UnInstall(): Boolean;
var sdirectory:string;
    sProgUninstall:string;
begin
  FState := 'Désinstallation de l''Instance ' + FSYMDS.Nom ;
  Synchronize(DoRefreshState);

  setCurrentDir(ParamStr(0));
  sdirectory:=ParamStr(0);
  sProgUninstall:=FSymDS.Repertoire+'\Uninstaller\Uninstaller.jar';
  if ExecuterAdministrateur(VGSE.JavaPath+'\bin\javaw', Format('-jar %s', [sProgUninstall]), sdirectory) then
  else begin
    Result := False;
    Exit;
  end;

  FState := 'Suppresion du service ' + FSYMDS.Nom ;
  Synchronize(DoRefreshState);

  if ExecuterAdministrateur('sc.exe',Format('delete %s',[FSYMDS.Nom]),'') then
  else begin
    Result := False;
    Exit;
  end;
  result:=true;
end;

procedure TThreadUnInstallSymDS.DoRefreshState();
begin
    Form1.State := FState;
end;

procedure TThreadInstallSymDS.DoRefreshState();
begin
    Form1.State := FState;
end;

procedure TThreadInstallSymDS.DoFinish;
begin
    VGSE.Lock :=false;
end;


constructor TThreadInstallSymDS.Create(CreateSuspended:boolean;aSymDS:TSymmetricDS);
begin
    inherited Create(CreateSuspended);
    FSYMDS           := aSymDS;
    FreeOnTerminate  := true;
    FState           := '';
    FErrorMessage    := '';
end;


procedure TThreadInstallSymDS.Execute;
begin
    try
      Install();
    finally
      Synchronize(DoFinish);
    end;
end;


function TThreadInstallSymDS.Install(): Boolean;
Const
  REGEXP_VERSION      = '(\d+)\.(\d+)';
  REGEXP_RECUP_CHEMIN = '^"(.+)"|^(\S+)';
var
  Registre          : TRegistry;
  reExpression      : TPerlRegEx;
  ResInstallateur   : TResourceStream;
  sVersionJava      : string;
  sProgInstall      : TFileName;
  sAutoInstall      : TFileName;
  sFichParams       : TFileName;
  sCheminInterBase  : TFileName;
  sFichierConf      : TFileName;
  XMLFile           : TextFile;
  slConfFile        : TStringList;
  iIndex            : Integer;
  pos               : integer;
begin
  sProgInstall  := IncludeTrailingPathDelimiter(FSymDS.Repertoire) + 'symmetric-pro-3.7.36-setup.jar';
  sAutoInstall  := IncludeTrailingPathDelimiter(FSymDS.Repertoire) + 'master-autoinstall.xml';
  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape Vérification';
  Synchronize(DoRefreshState);
  {$REGION 'Vérification du répertoire d’installation'}
  // Journaliser('Vérification du répertoire d’installation.');
  if not(DirectoryExists(FSymDS.Repertoire)) then
  begin
    // Création du répertoire d'installation
    // Journaliser('Création du répertoire d’installation.');
    if not(ForceDirectories(FSymDS.Repertoire)) then
    begin
      // Le répertoire d'installation ne peux pas être créé
      // Journaliser('Le répertoire d’installation ne peux pas être créé.', NivErreur);
      Result := False;
      Exit;
    end;
  end;
  {$ENDREGION 'Vérification du répertoire d’installation'}

  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [1/8] : Extraction Programme d''installation';
  Synchronize(DoRefreshState);

  {$REGION 'Extraction du programme d’installation'}
  // Journaliser('Extraction du programme d’installation.');
  try
    // Pour les tests c'est un peu long de mettre ca en ressource
    // on va le copier depuis le répertoire de l'exe
    CopyFile(PWideChar(VGSE.ExePath+'res\symmetric-pro-3.7.36-setup.jar'),PWideChar(sProgInstall),true);
    {
    ResInstallateur := TResourceStream.Create(HInstance, 'SymmetricDS', RT_RCDATA);
    try
      ResInstallateur.SaveToFile(sProgInstall);
      // Journaliser('Programme d’installation extrait.');
    finally
      ResInstallateur.Free();
    end;
    }
    ResInstallateur := TResourceStream.Create(HInstance, 'masterautoinstall', RT_RCDATA);
    try
      ResInstallateur.SaveToFile(sAutoInstall);
      // Journaliser('Paramétrage d’installation extrait.');
    finally
      ResInstallateur.Free();
    end;
  except
    on e: Exception do
    begin
      // Impossible d'extraire les ressources
      // Journaliser('Impossible d’extraire les ressources.', NivErreur);
      Result := False;
      Exit;
    end;
  end;
  {$ENDREGION 'Extraction du programme d’installation'}


  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [2/8] : Etape Modification paramètres';
  Synchronize(DoRefreshState);

  {$REGION 'Modification des paramètres d’installation automatique'}

  // Chargement du fichier XML

  // Enregistrement du fichier XML modifié
  With TStringList.create do
    try
        LoadFromfile(sAutoInstall);
        Text:=Replacetext(Text,'%installpath%',FSymDS.Repertoire);
        Text:=Replacetext(Text,'%servicename%',FSymDS.Nom);
        Text:=Replacetext(Text,'%agent%',IntToStr(FSymDS.agent));
        Text:=Replacetext(Text,'%http%',IntToStr(FSymDS.http));
        Text:=Replacetext(Text,'%https%',IntToStr(FSymDS.https));
        Text:=Replacetext(Text,'%jmx%',IntToStr(FSymDS.jmx));
        Text:=Replacetext(Text,'%programmegroup%',FSymDS.Nom);
        SaveTofile(sAutoInstall);
    finally
        free;
    end;
  {$ENDREGION 'Modification des paramètres d’installation automatique'}


  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [3/8] : Lancement programme d''Installation';
  Synchronize(DoRefreshState);

  {$REGION 'Lancement du programme d’installation en mode automatique'}
  // Mode caché
  if ExecuterAdministrateur(VGSE.JavaPath + '\bin\javaw', Format('-jar %s %s', [sProgInstall, sAutoInstall]), FSymDS.Repertoire) then
  // if ExecuterAdministrateur(VGSE.JavaPath + '\bin\java', Format('-jar %s %s', [sProgInstall, sAutoInstall]), ASym.Repertoire) then
  else begin
    Result := False;
    Exit;
  end;

  // Vérification du service SymmetricDS
  if ServiceExiste(FSymDS.Nom) then
  begin
    // Journaliser('Le service SymmetricDS a bien été installé.');
  end
  else begin
    // Journaliser('Erreur lors de la vérification du service SymmetricDS.', NivErreur);
    Result := False;
    Exit;
  end;
  {$ENDREGION 'Lancement du programme d’installation en mode automatique'}

  ServiceStop('',FSymDS.Nom);

  {$REGION 'Mise à la corbeille des fichiers d’installation'}
  if not(MettreCorbeille(sProgInstall) and MettreCorbeille(sFichParams)) then
  begin
//    Journaliser('Erreur lors de la suppression des fichiers d’installation.', NivErreur);
  end;
  {$ENDREGION 'Mise à la corbeille des fichiers d’installation'}

  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [4/8] : Interbase';
  Synchronize(DoRefreshState);

  {$REGION 'Récupération du chemin d’InterBase'}
  reExpression      := TPerlRegEx.Create();
  try
    try
      sCheminInterBase          := InfoSurService('IBS_gds_db').BinaryPathName;
      reExpression.RegEx        := REGEXP_RECUP_CHEMIN;
      reExpression.Subject      := sCheminInterBase;

      if reExpression.Match() then
        sCheminInterBase := reExpression.Groups[1] + reExpression.Groups[2];

      sCheminInterBase   := ExtractFilePath(sCheminInterBase);
    except
      on E: Exception do
      begin
//        Journaliser(Format('Erreur lors de la récupération du chemin d’InterBase.' + sLineBreak + '%s - %s',
//          [E.ClassName, E.Message]), NivErreur);
        Result := False;
        Exit;
      end;
    end;
  finally
    reExpression.Free();
  end;
  {$ENDREGION 'Récupération du chemin d’InterBase'}

  {$REGION 'Installation des UDF de SymmetricDS'}
//  Journaliser('Installation des UDF de SymmetricDS.');
  if not(FileExists(Format('%s\..\UDF\sym_udf.dll', [ExcludeTrailingPathDelimiter(sCheminInterBase)])))
      then
          begin
              if not(CopierFichier(Format('%s\databases\interbase\sym_udf.dll', [ExcludeTrailingPathDelimiter(FSymDS.Repertoire)]),
                  Format('%s\..\UDF\sym_udf.dll', [ExcludeTrailingPathDelimiter(sCheminInterBase)])))
                  then
                    begin
                      Result := False;
                      Exit;
                    end;
          end;
  {$ENDREGION 'Installation des UDF de SymmetricDS'}

  {$REGION 'Installation de InterClient'}
  if CopierFichier(Format('%s\..\SDK\lib\interclient.jar', [ExcludeTrailingPathDelimiter(sCheminInterBase)]),
    Format('%s\lib\interclient.jar', [ExcludeTrailingPathDelimiter(FSymDS.Repertoire)])) then
  begin
  end
  else begin
    Result := False;
    Exit;
  end;
  {$ENDREGION 'Installation de InterClient'}

  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [5/8] : Config Java';
  Synchronize(DoRefreshState);

  {$REGION 'Configuration de Java pour SymmetricDS'}
  slConfFile        := TStringList.Create();
  try
    sFichierConf                  := Format('%s\conf\sym_service.conf', [ExcludeTrailingPathDelimiter(FSymDS.Repertoire)]);
    slConfFile.NameValueSeparator := '=';
    slConfFile.LoadFromFile(sFichierConf);

    // Passe en mode serveur
    iIndex:=1;
    while slConfFile.IndexOfName(Format('wrapper.java.additional.%d',[iIndex]))>-1 do
      begin
        pos:=slConfFile.IndexOfName(Format('wrapper.java.additional.%d',[iIndex]));
        inc(iIndex);
      end;
    // sur certains poste il ne faut pas mettre la ligne suivante...
    {
    if FSymDS.server_java
      then
          begin
              slConfFile.Insert(Pos+1,Format('wrapper.java.additional.%d=-server',[iIndex]));
              inc(iIndex);
          end;
    }
    slConfFile.Insert(Pos+2,Format('wrapper.java.additional.%d=-Dfile.encoding=ISO8859_15',[iIndex]));
    inc(iIndex);
    slConfFile.Insert(Pos+3,Format('wrapper.java.additional.%d=-XX:-UseGCOverheadLimit',[iIndex]));
    inc(iIndex);

    // Change les tailles pour la RAM allouée 1024 sur les magasins ca serait mieux...
    slConfFile.Values['wrapper.java.initmemory']      := IntToStr(FSymDS.memory);
    slConfFile.Values['wrapper.java.maxmemory']       := IntToStr(FSymDS.memory);

    slConfFile.SaveToFile(sFichierConf);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Configuration de Java pour SymmetricDS'}


  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [6/8] : Config SymmetricDS pour Interbase';
  Synchronize(DoRefreshState);

  {$REGION 'Configuration de SymmetricDS 3.7.36 pour InterBase'}
  slConfFile        := TStringList.Create();
  try
    sFichierConf                  := Format('%s\conf\symmetric.properties', [ExcludeTrailingPathDelimiter(FSymDS.Repertoire)]);
    slConfFile.NameValueSeparator := '=';

    // Change l'"initial load"
    slConfFile.Values['initial.load.concat.csv.in.sql.enabled'] := 'true';

    slConfFile.SaveToFile(sFichierConf);
  finally
    slConfFile.Free();
  end;
  {$ENDREGION 'Configuration de SymmetricDS 3.7.10 pour InterBase'}

  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [7/8] : Demarrage Service';
  Synchronize(DoRefreshState);

  {$REGION 'Démarrage du service SymmetricDS'}
  try
    ServiceStart('',FSymDS.Nom);
  except
    on E: Exception do
    begin
      Result := False;
      Exit;
    end;
  end;
  {$ENDREGION 'Démarrage du service SymmetricDS'}

  FState := 'Installation Instance ' + FSYMDS.Nom + ' : Etape [8/8] : Terminé : OK';
  Synchronize(DoRefreshState);

  Result := True;
end;


end.

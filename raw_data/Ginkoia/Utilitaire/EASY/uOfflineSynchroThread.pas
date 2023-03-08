/// <summary>
/// Unité de Synchronisation Offline (échange de fichier)
/// </summary>
unit uOfflineSynchroThread;

interface

Uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCommun,IdBaseComponent, IdComponent, UWMI, System.IOUtils,
  IdTCPConnection, IdTCPClient, IdFTP, IdExplicitTLSClientServerBase,IdFTPList,System.DateUtils,IdFTPCommon,
  System.RegularExpressionsCore;

Const CST_7Z_PASSWORD = 'ch@mon1x';

Type
  TTypeNode = (tnLame,tnMag);
  // liste les fichiers à synchroniser avec un Noeud
  TNodeOutgoingFiles  = record
    FDossier         : string;
    FSourceNode      : string;
    FDestinationNode : string;
    FTotalFilesSize  : Int64;        // en octets
    F7ZFile          : TFileName;    // nom du zip
    FFiles           : TStringList;  // liste des fichiers à compresser
    FCanPurge        : boolean;      // Si tout s'est bien passé on supprime les fichier
  public
    procedure Init(aDossier:string;aSourceNode:string;aDestinationNode:string);
    procedure Destroy;
  end;

  // Liste des Noeuds
  TNodesOutgoingFiles = array of TNodeOutgoingFiles;

  TOfflineSynchroThread = class(TThread)
  private
    { -------- Déclarations privées ----------- }
    FCreateTime        : TDateTime; // Date de Création du thread va nous permettre de calculer le DLC
    FStatusProc      : TStatusMessageCall;
    FProgressProc    : TProgressMessageCall;
    FFTP_Username    : string;
    FFTP_Password    : string;
    FFTP_Host        : string;
//    FFTP_Port        : integer;  toujours 21
    FFTP_Passive     : Boolean;
    FnbError         : integer;


    FTypeNode        : TTypeNode;   // LameNode ou MagNode
    FModeDebug       : boolean;
    FServiceName     : string;
    FProgress        : integer;
    FStatus          : string;
    FNodeId          : string; // Node Local
    FLameNodeID      : string; // Node Lame
    FDossier         : string; // Nom du Dossier
    FGinkoiaPath     : string;
    FEASY            : TSYMDSInfos;
    FArchivePath     : string;

    FTmpoutgoingPath : string;
    FTmpincomingPath : string;

    // FDestinations    : TStringList; // Destinations
    // FoutgoingFiles   : TStringList;
    FNodesOutgoingFiles  : TNodesOutgoingFiles;

    FincomingFiles   : TStringList;

    Procedure StatusCallBack;
    Procedure ProgressCallBack;
    procedure AddNodeOutgoingFile(aDossier,aFileName:string);

  protected

    // procedure ZipFiles();
    procedure Etape_Init;
    procedure Etape_7ZFiles(aNodeOutgoingFiles:TNodeOutgoingFiles);
    procedure Etape_PushFTP();
    procedure Etape_PullFTP();
    procedure Etape_Un7ZFiles();
    procedure Etape_Archive();
  public
    procedure Execute; override;
  public
    constructor Create(
          aServiceName      : string;
          aModeReleased     : Boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil); reintroduce;
    property CreateTime     : TDateTime read FCreateTime;
    property NbError        : integer     read FnbError           write FnbError;
    property FTP_Username    : string  read FFTP_Username write FFTP_Username;
    property FTP_Password    : string  read FFTP_Password write FFTP_Password;
    property FTP_Host        : string  read FFTP_HOST     Write FFTP_Host;



  end;

implementation

Uses uSevenZip;

procedure TNodeOutgoingFiles.Init(aDossier,aSourceNode,aDestinationNode:string);
begin
    Self.FDossier         := aDossier;
    Self.FSourceNode      := aSourceNode;
    Self.FDestinationNode := aDestinationNode;
    Self.F7ZFile := ExcludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+ '\EASY_OFFLINE_SYNCHRO\'+ FDossier+'\outgoing\' + aSourceNode + '_to_' + aDestinationNode + '_'+FormatDateTime('yyyymmddhhnnsszzz',Now()) + '.7z';
    Self.FFiles  := TStringList.Create;
end;

procedure TNodeOutgoingFiles.Destroy;
begin
    FreeAndNil(Self.FFiles);
end;

procedure TOfflineSynchroThread.Etape_Archive();
var i,j:Integer;
    vIsOk : Boolean;
    vTry : integer;
    vDeleted  : Integer;
    vArchived : Integer;
begin
    if (FModeDebug) then
      begin
        FStatus:='ARCHIVE : [EN COURS]';
        Synchronize(StatusCallBack);
      end;

    try
      vDeleted := 0;
      vArchived := 0;
      // Archivage des outgoing.7z
      for I :=Low(FNodesOutgoingFiles) to High(FNodesOutgoingFiles) do
      begin
         // théoriquement c'est toujours le cas.... non ?
         if FNodesOutgoingFiles[i].FCanPurge then
           begin
              // on deplace le 7z
              TFile.Move(FNodesOutgoingFiles[i].F7ZFile,FArchivePath+'\outgoing_to_'+FNodesOutgoingFiles[i].FDestinationNode+'_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.7z');
              Inc(vArchived);
              // On supprimer les fichiers qu'on avait dans le record
              // interdiction de supprimer autres les fichiers csv du répertoire outgoing... ils n'ont pas été exporter !
              for j := 0 to FNodesOutgoingFiles[i].FFiles.Count-1 do
                begin
                   DeleteFile(FNodesOutgoingFiles[i].FFiles[j]);
                   Inc(vDeleted);
                end;
           end;

      end;
      //----------------------
      for i := 0 to FincomingFiles.Count-1 do
        begin
          vIsOk := False;
          vTry  := 0;
          while not(vIsOk) and (vTry<50) do
            begin
              try
                inc(vTry);
                Sleep(100);
                TFile.Move(FTmpincomingPath+'\'+FincomingFiles.Strings[i],FArchivePath+'\incoming_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.7z');
                Inc(vArchived);
                vIsOk:=true;
              except
                //
              end;
            end;
          if vTry>=50 then
            raise Exception.Create('Erreur Archivage');
        end;
      //-----------------------------------------------------------------------
      Case vArchived of
        0 : FStatus:='ARCHIVE : Rien à archiver [OK]';
        1 : FStatus:=Format('ARCHIVE : %d fichier archivé [OK]',[vArchived]);
        else
          FStatus:=Format('ARCHIVE : %d fichiers archivés [OK]',[vArchived]);
      end;
      Synchronize(StatusCallBack);
      Case vDeleted of
        0 : FStatus:='ARCHIVE : Rien à supprimer [OK]';
        1 : FStatus:=Format('ARCHIVE : %d fichier supprimé [OK]',[vDeleted]);
        else
          FStatus:=Format('ARCHIVE : %d fichiers supprimés [OK]',[vDeleted]);
      end;
      Synchronize(StatusCallBack);
    except
      FStatus:='ARCHIVE : [ERREUR]';
      Synchronize(StatusCallBack);
    end;

    {
 // on deplace dans le incoming "local"
    // et on pose dans '/archives' le .7z
    // ----- tmp\nodeid\offline\outgoing\Source_to_destination_xxxxxx.csv
    vPath    := Format('%s\tmp\%s\offline\incoming\',[ExcludeTrailingPathDelimiter(FEASY.Directory),FNodeId]);
    vPattern := FtmpincomingPath + ;

    SetLength(FNodesOutgoingFiles,0);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
      begin
         repeat
           TFile.Move(, vPath);

           AddNodeOutgoingFile(Format('%s\tmp\%s\offline\outgoing\%s',[ExcludeTrailingPathDelimiter(FEASY.Directory),FNodeId,searchResult.Name]));
         until FindNext(searchResult) <> 0;
        FindClose(searchResult);
      end;
}
end;

procedure TOfflineSynchroThread.Etape_Un7zFiles();
var outDir:string;
    i,j:integer;
    vIncomingPath : string;
    vNumberOfItems : Integer;
    vSize : Int64;
begin
  if FincomingFiles.Count=0
    then
      begin
        exit;
      end;
  vIncomingPath := Format('%s\tmp\%s\offline\incoming\',[ExcludeTrailingPathDelimiter(FEASY.Directory),FNodeId]);
  if FModeDebug then
    begin
        FStatus:='UNZIP : [EN COURS]';
        Synchronize(StatusCallBack);
    end;
  try
    try
      vNumberOfItems := 0;
      vSize := 0;
      for i := 0 to FincomingFiles.Count-1 do
        begin
          with CreateInArchive(CLSID_CFormat7z) do
            begin
                SetPassword(CST_7Z_PASSWORD);
                OpenFile(FTmpincomingPath + '\'+ FincomingFiles.Strings[i]);
                // On extract directe dans
                ExtractTo(vIncomingPath);
                vNumberOfItems := vNumberOfItems + NumberOfItems;
                for j:=0 to NumberOfItems-1 do
                    begin
                        vSize := vSize + ItemSize[j];
                    end;
            end;
        end;
      case vNumberOfItems of
        1: FStatus:=Format('UNZIP : %d fichier / %0.2f Ko [OK]',[vNumberOfItems,vSize/1024]);
      else
           FStatus:=Format('UNZIP : %d fichiers / %0.2f Ko [OK]',[vNumberOfItems,vSize/1024]);
      end;
      Synchronize(StatusCallBack);
    Except on E:Exception do
        begin
          FStatus:='UNZIP : [ERREUR] ' + E.MEssage;
          Synchronize(StatusCallBack);
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;

procedure TOfflineSynchroThread.Etape_7zFiles(aNodeOutgoingFiles:TNodeOutgoingFiles);
var Arch : I7zOutArchive;
    i : Integer;
    vSize : Int64;
begin
  if FModeDebug then
    begin
        FStatus:=Format('ZIP : Noeud %s [EN COURS]',[aNodeOutgoingFiles.FDestinationNode]);
        Synchronize(StatusCallBack);
    end;
  Arch := CreateOutArchive(CLSID_CFormat7z);
  try
    try
      for I := 0 to aNodeOutgoingFiles.FFiles.Count-1 do
        begin
          Arch.AddFile(aNodeOutgoingFiles.FFiles.Strings[i],ExtractFileName(aNodeOutgoingFiles.FFiles.Strings[i]));
        end;

      SetCompressionLevel(Arch,3);
      Arch.SetPassword(CST_7Z_PASSWORD);
      Arch.SaveToFile(aNodeOutgoingFiles.F7ZFile);
      vSize := FileSize(aNodeOutgoingFiles.F7ZFile);
      FStatus:=Format('ZIP : %d fichiers %0.2f Ko =>  %0.2f Ko [OK]',[
                aNodeOutgoingFiles.FFiles.Count,
                aNodeOutgoingFiles.FTotalFilesSize/1024,
                vSize/1024]);
      Synchronize(StatusCallBack);
    Except on E:Exception do
        begin
          FStatus:='ZIP : [ERREUR] '+ E.Message ;
          Synchronize(StatusCallBack);
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;

procedure TOfflineSynchroThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TOfflineSynchroThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;

procedure TOfflineSynchroThread.Etape_PullFTP();
var vIdFTP    : TIdFTP;
    vDirExist : Boolean;
    i         : integer;
    vSize : Int64;
begin
  if FModeDebug then
    begin
       FStatus:='PULL : [En Cours]';
       Synchronize(StatusCallBack);
    end;
  vIdFTP:= TIdFTP.Create(nil);
   try
    try
     // vPath := ExcludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+'\offline\';
     vIdFTP.Username := FFTP_Username;
     vIdFTP.Password := FFTP_Password;
     vIdFTP.Host     := FFTP_Host;
     vIdFTP.Port     := 21;
     vIdFTP.UseTLS   := utNoTLSSupport;
     vIdFTP.TransferType := ftBinary;
     vIdFTP.Passive := FFTP_PASSIVE;   // Mais si en Test Sur mon poste commenter cette ligne
     vIdFTP.Connect;
     //-----------------------------------------
     try
        vIdFTP.ChangeDir('easy_offline_synchro/' +FNodeID);
     except
       //
     end;
     vIDFTP.List;
     vSize := 0;
     for I := 0 to vIdFTP.DirectoryListing.Count-1 do
        begin
           if (vIDFTP.DirectoryListing[I].ItemType=ditFile)
             and (Pos(Format('_to_%s',[FNodeID]),vIDFTP.DirectoryListing[I].FileName)>0)
              then
                begin
                   vSize   := vSize + vIdFTP.Size(vIDFTP.DirectoryListing[I].FileName);
                   FincomingFiles.Add(vIDFTP.DirectoryListing[I].FileName);
                   vIDFTP.Get(vIDFTP.DirectoryListing[I].FileName,
                        FTmpincomingPath+'\'+vIDFTP.DirectoryListing[I].FileName,True,true);
                   vIdFTP.Delete(vIDFTP.DirectoryListing[I].FileName);
                end;
        end;
      case FincomingFiles.Count Of
        0: FStatus:='PULL : Aucun fichier [OK]';
        1: FStatus:=Format('PULL : %d fichier de %0.2f Ko [OK]',[FincomingFiles.Count,vSize/1024])
        else
        FStatus:=Format('PULL : %d fichiers / Taille %0.2f Ko (total) [OK]',[FincomingFiles.Count,vSize/1024]);
        end;
        Synchronize(StatusCallBack);
    except On E:Exception do
      begin
        NbError := NbError +1;
        FStatus:='PULL : '+ E.Message +'[ERREUR]';
        Synchronize(StatusCallBack);
      end;
    end;
   finally
      if vIdFTP.Connected then
      vIdFTP.Disconnect;
      FreeAndNil(vIdFTP);
   end;
end;

procedure TOfflineSynchroThread.Etape_PushFTP();
var vIdFTP:TIdFTP;
    v:string;
    i,j:Integer;
    vDirExist : Boolean;
begin
    If Length(FNodesOutgoingFiles)=0
      then
        begin
            FStatus:='PUSH : Aucun fichier [OK]';
            Synchronize(StatusCallBack);
            exit;
        end;
    if FModeDebug then
      begin
          FStatus:='PUSH : [En Cours]';
          Synchronize(StatusCallBack);
      end;
    vIdFTP:= TIdFTP.Create(nil);
    try
       vIdFTP.Username := FFTP_Username;
       vIdFTP.Password := FFTP_Password;
       vIdFTP.Host     := FFTP_Host;
       vIdFTP.Port     := 21;
       vIdFTP.UseTLS   := utNoTLSSupport;
       vIdFTP.TransferType := ftBinary;
       try
        // vIdFTP.Passive := True;  // problème sur replic3 sans cette ligne ça ne fonctionne pas
         vIdFTP.Passive := False;   // Mais si en Test Sur mon poste commenter cette ligne
         vIdFTP.Connect;
         //-----------------------------------------
         // vIdFTP.ChangeDir('easy_offline_synchro');
         vIDFTP.List;
         vDirExist := false;
         for I := 0 to vIdFTP.DirectoryListing.Count-1 do
            begin
                if (vIDFTP.DirectoryListing[I].ItemType=ditDirectory)
                   and (vIDFTP.DirectoryListing[I].FileName='easy_offline_synchro')
                    then
                      begin
                        vDirExist := True;
                        break;
                      end;
            end;

         If not(vDirExist)
             then vIdFTP.MakeDir('easy_offline_synchro');
         vIdFTP.ChangeDir('easy_offline_synchro');
         //---------------------------------------------------------------
         vIDFTP.List;
         for i:=Low(FNodesOutgoingFiles) to High(FNodesOutgoingFiles) do
            begin
                vDirExist := false;
                for j := 0 to vIdFTP.DirectoryListing.Count-1 do
                  begin
                       if (vIDFTP.DirectoryListing[j].ItemType=ditDirectory)
                          and (vIDFTP.DirectoryListing[j].FileName=FNodesOutgoingFiles[i].FDestinationNode)
                           then
                             begin
                               vDirExist := True;
                               break;
                             end;
                  end;
                 If not(vDirExist)
                   then vIdFTP.MakeDir(FNodesOutgoingFiles[i].FDestinationNode);
                 vIdFTP.ChangeDir(FNodesOutgoingFiles[i].FDestinationNode);
                 vIdFTP.Put(FNodesOutgoingFiles[i].F7Zfile,ExtractFileName(FNodesOutgoingFiles[i].F7Zfile));
                 FNodesOutgoingFiles[i].FCanPurge := true;
                 vIdFTP.ChangeDir('..');
            end;
         if Length(FNodesOutgoingFiles)=1
            then FStatus:='PUSH : 1 fichier 7z [OK]'
            else FStatus:=Format('PUSH : %d fichiers 7z [OK]',[Length(FNodesOutgoingFiles)]);
         Synchronize(StatusCallBack);
       except
          On E:Exception do
             begin
                NbError := NbError +1;
                FStatus:=E.Message;
                Synchronize(StatusCallBack);
             end;
       end;
    finally
        if vIdFTP.Connected then
           vIdFTP.Disconnect;
        FreeAndNil(vIdFTP);
    end;
end;


constructor TOfflineSynchroThread.Create(
          aServiceName      : string;
          aModeReleased     : boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(true);
    FServiceName        := aServiceName;
    FModeDebug          := not(aModeReleased);
    {
    FFTP_Username       := LoadStrFromIniFile('FTP','USERNAME');
    FFTP_Password       := LoadStrFromIniFile('FTP','PASSWORD');
    FFTP_Host           := LoadStrFromIniFile('FTP','HOST');
    // FFTP_Port           := LoadIntFromIniFile('FTP','Port');
    }
    FFTP_Passive        := LoadBoolFromIniFile('FTP','Passive');  // false
    FStatusProc         := aStatusCallBack;
    FProgressProc       := aProgressCallBack;
    FCreateTime         := Now();
    FreeOnTerminate     := true;
    OnTerminate         := AEvent;

    // FNodesOutgoingFiles.Init;
    FincomingFiles       := TStringList.Create;  // liste des fichiers qu'on va prendre du serveur FTP pour les jouer en local
end;

procedure TOfflineSynchroThread.Execute;
var I: integer;
    vStart : TDateTime;
begin
    try
      FProgress := 10;
      Synchronize(ProgressCallBack);
      vStart := Now();

      if (NbError>0) then exit;
      Etape_Init;

      if (NbError>0) then exit;
      for I := Low(FNodesOutgoingFiles) to High(FNodesOutgoingFiles) do
        begin
            Etape_7ZFiles(FNodesOutgoingFiles[i]);
        end;

      FProgress := 30;
      Synchronize(ProgressCallBack);
      Etape_PushFTP();
      if (NbError>0) then exit;

      FProgress := 50;
      Synchronize(ProgressCallBack);

      Etape_PullFTP();
      if (NbError>0) then exit;

      FProgress := 60;
      Synchronize(ProgressCallBack);

      Etape_Un7zFiles();

      FProgress := 70;
      Synchronize(ProgressCallBack);

      Etape_Archive();
      if (NbError>0) then exit;

      SaveStrToIniFile('Synchro','Last',FormatDateTime('dd/mm/yyyy hh:nn:ss',vStart));

      FProgress := 99;
      Synchronize(ProgressCallBack);

    finally
      for I := Low(FNodesOutgoingFiles) to High(FNodesOutgoingFiles) do
        begin
            FNodesOutgoingFiles[i].Destroy;
        end;
    end;
end;

{
procedure TOfflineSynchroThread.GetDestination(aFileName:string);
begin
  //
  // to_*.csv
end;
}


procedure TOfflineSynchroThread.AddNodeOutgoingFile(aDossier,aFileName:string);
var vDestination : string;
    vSource      : string;
    regExp : TPerlRegEx;
    i:Integer;
    vFound : Boolean;
begin
  // parse le nom du fichier "aFileName" pour trouver la destination
  // on cherche la destination dans FNodesOutgoingFiles
  // si pas trouvé on ajoute cette destination à FNodesOutgoingFiles
  // vDestination := GetDestination(aFileName);
  // 'tmp\\([^\\]*)?\\([^\\]*)?\\outgoing\\([^\\]*)?_to_(.*)?_(\d{13}).csv';
  regExp := TPerlRegEx.Create;
  vDestination := '';
  try
    regExp.RegEx := 'tmp\\([^\\]*)?\\offline\\outgoing\\([^\\]*)?_to_(.*)?_(\d{13}).csv';
    regExp.Subject  := aFileName;
    regExp.Options  := [preCaseLess];
    If (regExp.Match())
      then
        begin
           vSource      := regExp.Groups[2];
           vDestination := regExp.Groups[3];
        end;
  finally
    regExp.Free;
  end;
  if vDestination<>'' then
    begin
        vFound:=false;
        for I :=Low(FNodesOutgoingFiles)  to High(FNodesOutgoingFiles) do
          begin
            if FNodesOutgoingFiles[i].FDestinationNode=vDestination then
                begin
                  vFound:=True;
                  FNodesOutgoingFiles[i].FFiles.Add(aFileName);
                  FNodesOutgoingFiles[i].FTotalFilesSize := FNodesOutgoingFiles[i].FTotalFilesSize + FileSize(aFileName);
                  // FStatus := 'Ajout Fichier : ' + aFileName;
                  // Synchronize(StatusCallBack);
                  exit;
                end;
          end;
        if not(vFound)
          then
            begin
              i:=Length(FNodesOutgoingFiles);
              SetLength(FNodesOutgoingFiles,i+1);
              FNodesOutgoingFiles[i].Init(aDossier,vSource,vDestination);
              // FStatus := 'Création Node Destination : ' + vDestination;
              // Synchronize(StatusCallBack);

              FNodesOutgoingFiles[i].FFiles.Add(aFileName);
              FNodesOutgoingFiles[i].FTotalFilesSize := FNodesOutgoingFiles[i].FTotalFilesSize + FileSize(aFileName);
              // FStatus := 'Ajout Fichier : ' + aFileName;
              // Synchronize(StatusCallBack);
            end;
    end;
end;

procedure TOfflineSynchroThread.Etape_Init;
var i: Integer;
    vPropertiesFile: TFileName;
    searchResult : TSearchRec;
    vPattern : string;
    vFind    : integer;
//    vPath    : string;
    vURL : string;
begin
    // il faut lancer un WMI pour le service EASY
    if FModeDebug then
      begin
        FStatus := 'Recupération des Infos';
        Synchronize(StatusCallBack);
      end;
    FEasy.ServiceName := '';
    vPropertiesFile   := '';
    WMI_GetServicesSYMDS;
    if FServiceName='EASY'
      then FTypeNode := tnMag
      else FTypeNode := tnLame;
    for i := Low(VGSYMDS) to High(VGSYMDS) do
      begin
        if VGSYMDS[i].ServiceName=FServiceName then
          begin
              FEasy := VGSYMDS[i];
              if FModeDebug then
                 begin
                   FStatus := 'Service trouvé : ' + VGSYMDS[i].ServiceName;
                   Synchronize(StatusCallBack);
                 end;
              // on cherche le fichier  "engine.name".properties
              vPattern := Format('%s\engines\*.properties',[ExcludeTrailingPathDelimiter(FEASY.Directory)]);
              if findfirst(vPattern, faAnyFile, searchResult) = 0 then
                  begin
                    vFind := 0;
                    repeat
                      inc(vFind);  // S'il y en a plusieur ===> STOP exit erreur
                      vPropertiesFile := searchResult.Name;
                    until FindNext(searchResult) <> 0;
                    FindClose(searchResult);
                  end;
          end;
      end;

    if (vPropertiesFile='') or (FEasy.ServiceName='')
      then
         begin
           FStatus := 'Service introuvable : '+ FServiceName + ' [ERREUR]';
           Synchronize(StatusCallBack);
           NbError := NbError +1;
           exit;
         end;

    FNodeId  := TPath.GetFileNameWithoutExtension(vPropertiesFile);
    // il faut aller voir dans le vPropertieFile
    With TStringList.Create do
       begin
         try
          LoadFromFile(Format('%s\engines\%s.properties',[ExcludeTrailingPathDelimiter(FEASY.Directory),FNodeId]));
          NameValueSeparator  := '=';
          if FTypeNode=tnLame then
            begin
              FDossier    := StringReplace(FNodeId,'easy_','',[rfReplaceAll,rfIgnoreCase]);
              FLameNodeID := 'lame-'+FNodeId+'-id';
              FNodeID     := 'lame-'+FNodeId+'-id';
              // vNodeURL    := StringReplace(Values['registration.url'],'\','',[rfReplaceAll]);
            end;
          if FTypeNode=tnMag then
            begin
              vURL        := StringReplace(Values['registration.url'],'\','',[rfReplaceAll]);
              // Ca c'est le nom du service sur la lame"
              FLameNodeID := Copy(vURL,LastDelimiter('/',vURL)+1,length(vURL));
              FDossier    := StringReplace(FLameNodeID,'easy_','',[rfReplaceAll,rfIgnoreCase]);
              FLameNodeID := 'lame-'+FLameNodeID+'-id';
            end;
          //
         finally
          free;
         end;
       end;
    if FModeDebug then
      begin
        FStatus := 'Noeud Local : ' + FNodeId;
        Synchronize(StatusCallBack);
      end;
    // ----- tmp\nodeid\offline\outgoing\Source_to_destination_xxxxxx.csv
    vPattern := Format('%s\tmp\%s\offline\outgoing\*.csv',[ExcludeTrailingPathDelimiter(FEASY.Directory),FNodeId]);
    SetLength(FNodesOutgoingFiles,0);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
      begin
         repeat
           AddNodeOutgoingFile(FDossier,Format('%s\tmp\%s\offline\outgoing\%s',[ExcludeTrailingPathDelimiter(FEASY.Directory),FNodeId,searchResult.Name]));
         until FindNext(searchResult) <> 0;
        FindClose(searchResult);
      end;

//   FStatus := Format('push : %d fichiers à deposer',[]);
//   Synchronize(StatusCallBack);

   FArchivePath  := ExcludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+'\EASY_OFFLINE_SYNCHRO\'+FDossier+'\archive\' +FormatDateTime('yyyy\mm\dd',Now());
   ForceDirectories(FArchivePath);

   FtmpoutgoingPath := ExcludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+'\EASY_OFFLINE_SYNCHRO\'+FDossier+'\outgoing';
   ForceDirectories(FTmpoutgoingPath);

   FtmpincomingPath := ExcludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+'\EASY_OFFLINE_SYNCHRO\'+FDossier+'\incoming';
   ForceDirectories(FTmpincomingPath);
   {
   if FTypeNode=tnLame
    then
      begin
         F7ZFile := FTmpoutgoingPath + '\pull_'+FLameNodeID+ '_' + FormatDateTime('yyyymmddhhnnsszzz',Now()) + '.7z';
      end
    else
      begin
         F7ZFile := FTmpoutgoingPath + '\push_'+FNodeID+'_' + FormatDateTime('yyyymmddhhnnsszzz',Now()) + '.7z';
      end;
   }
end;


end.

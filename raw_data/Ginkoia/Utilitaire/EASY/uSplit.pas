unit uSplit;

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
  Vcl.ExtCtrls, Math, UWMI,System.IniFiles, uCommun,IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, IdExplicitTLSClientServerBase,IdFTPList,
  System.DateUtils,IdFTPCommon, uLog, IdSSLOpenSSL;

const CST_7Z_PASSWORD = 'ch@mon1x';

Type
  TSplitThread = class(TThread)
  private
    { Déclarations privées }
    FCreateTime        : TDateTime; // Date de Création du thread va nous permettre de calculer le DLC
    FDLC               : TDateTime; // la DLC du split Create + 1 Jour
    FnbError           : integer;
    // FStopService       : boolean;
    FForceRecreate     : Boolean;   //
    FDepotFTP          : Boolean;   // Depot FTP par défaut NON
    FMode              : Integer;   // mode = 0 split Complet (déclaration Noeud
                                    //         + création fichiers .IB,.info dans .split)
                                    //
                                    // mode = 1 Mini split (déclaration Noeud + fichiers .sql & .info dans .split
                                    //         Mais attention pas de création du fichier IB !!
                                    //
    // Nom de la LAME, sur laquelle est la base qu'on veut spliter
    // car il faudra pouvoir le faire à distance (depuis une lame outil par exemple)....
    FLAME              : string;
//  FSplit             : Boolean;
    FTriggerDiff       : Boolean;
//  FTypeArchive       : TGUID;   // toujours 7z
    FEngine            : string;
    FListBases         : TStringList;  // Bases Magasins ou portable ?
    FNOMPOURNOUS       : string;
//  FProgression       : integer;
//  FLevel             : cardinal;

    FORIGINE_IB        : TFileName;

    FCOPY_IB           : TFileName;
    FScriptFile        : TFileName;
    FSYMDSInfos        : TSYMDSInfos;
//  FDeleteSplitIBFile : boolean;      // Toujours

//  FSplitInfoFile     : TFileName;
    FSENDER       : string;
    FNODE         : string;
    FVERSION      : string;

    FStatusProc   : TStatusMessageCall;
    FProgressProc : TProgressMessageCall;
    FProgress     : integer;
    FStatus       : string;

    FFTP_Username  : string;
    FFTP_Password  : string;
    FFTP_Host      : string;
    FFTP_Port      : integer;

    FNODE_GROUP_ID : string;

    Procedure StatusCallBack;
    Procedure ProgressCallBack;

    // procedure UpdateVCL();
    procedure Etape_Splittage;
    procedure Etape_MiniSplittage;

    function GetBases():string;
    procedure SetBases(value:string);
    function ZipFile(aFileName,aSplitInfoFile:TFileName;numero:integer):TFileName;
    function  EveryBody_Disconnected():Boolean;
    function DiskIsOK():Boolean;
    procedure Etape_Restart_ORIGINE_IB;
    procedure Etape_Start_Service;
    procedure Etape_Stop_Service;
    procedure Etape_Creation_Noeuds_Mags;
    procedure Etape_ShutDown_Copy;
    procedure Etape_Script;
    function Create_Fichier_INF(Const aFile:TFileName):TFileName;
    function Etape_ZipFile(aFileName,aSplitInfoFile:TFileName;numero:integer):TFileName;

    function Etape_MiniSplitZipFile(aSplitInfoFile:TFileName;numero:integer):TFileName;
    function MiniZipFile(aSplitInfoFile:TFileName;numero:integer):TFileName;

    function Etape_RecupID(var aFile:TFileName):Integer;
    function TraiteGenerateur(Query : TFDQuery; aIdentBase:Integer; aPlage:string ;GenName : string; ini : TInifile) : integer;
    procedure EtapeDepotFTP(a7ZFile:TFileName);
    //    procedure SetORIGINEIB(aValue:TFileName);
  protected
    {--}
  public
    constructor Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil); reintroduce;
    procedure Execute; override;
    // Toutes les options du Thread
    property CreateTime     : TDateTime read FCreateTime;
    property sORIGINE_IB    : TFileName   read FORIGINE_IB     write FORIGINE_IB;
    property sCOPY_IB       : TFileName   read FCOPY_IB        write FCOPY_IB;
    property sScriptFile    : TFileName   read FScriptFile     write FScriptFile;
    property sBases         : string      read GetBases        Write SetBases;
    property SYMDSInfos     : TSYMDSInfos read FSYMDSInfos     Write FSYMDSInfos;
    property Engine         : string      read FEngine         write FEngine;
    property NOMPOURNOUS    : string      read FNOMPOURNOUS    write FNOMPOURNOUS;
    property bForceRecreate : Boolean     read FForceRecreate  write FForceRecreate;
    property bTriggerDiff   : Boolean     read FTriggerDiff    write FTriggerDiff;
//    property bSplit         : Boolean     read FSplit          write FSplit;
// Mode de split (0:split complet ou 1:mini split)
    property Mode           : Integer     read FMode           write FMode;
    property NbError        : integer     read FnbError        write FnbError;
    property DepotFTP       : Boolean     read FDepotFTP       write FDepotFTP;
    property NODE_GROUP_ID  : string      read FNODE_GROUP_ID  write FNODE_GROUP_ID;

//    property sDLC           : string      read FDLC            write FDLC;
//    property bStopService   : Boolean     read FStopService    write FstopService;
//  property TypeArchive    : TGUID       read FTypeArchive    write FTypeArchive;  // toujours 7z
//    property iLevel         : cardinal    read FLevel          write FLevel;      // Toujours 5
// toujours à vrai
//  property bDeleteSplitIBFile : Boolean read FDeleteSplitIBFile write FDeleteSplitIBFile;   // Pour supprimer le fichier ib après zip

  end;

implementation

Uses LaunchProcess, uSevenZip, ServiceControler, uDataMod{, MainLame_Frm};



procedure TSplitThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TSplitThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;


function TSplitThread.GetBases():string;
begin
    result:=FListBases.Text;
end;

procedure TSplitThread.SetBases(value:string);
begin
   FListBases.Clear;
   FListBases.Text:=value;
end;

function TSplitThread.Etape_MiniSplitZipFile(aSplitInfoFile:TFileName;numero:integer):TFileName;
begin
    result := MiniZipFile(aSplitInfoFile,numero);
end;

function TSplitThread.MiniZipFile(aSplitInfoFile:TFileName;numero:integer):TFileName;
var Arch : I7zOutArchive;
    ext :string;
    vDir : string;
begin
  vDir := IncludeTrailingPathDelimiter(ExtractFilePath(aSplitInfoFile));
  FStatus:=Format('Compression fichier %d/%d : [En Cours]',[numero,FListBases.Count]);
  if Assigned(FStatusProc) then Synchronize(StatusCallBack);
  Arch := CreateOutArchive(CLSID_CFormat7z);
  try
    try
      Arch.SetPassword(CST_7Z_PASSWORD);
      Arch.AddFile(aSplitInfoFile,ExtractFileName(aSplitInfoFile));
      Arch.AddFile(vDir+'K.csv','K.csv');
      Arch.AddFile(vDir+'GENPARAM.csv','GENPARAM.csv');

      //-----------------------------------
      SetCompressionLevel(Arch,3);    // la on peut laisser 3 c'est un minisplit donc tout petit
      ext := '.split';
      result := ChangeFileExt(aSplitInfoFile,ext);

      Arch.SaveToFile(result);
      // si il n'y a pas eu d'erreur on supprime la source du zip si

      FStatus:=Format('Compression fichier %d/%d : [OK]',[numero,FListBases.Count]);
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);

      // DeleteFile(AFileName);
      Except on E:Exception do
        begin
          FStatus:=Format('Compression fichier %d/%d : [ERREUR]',[numero,FListBases.Count]);
          if Assigned(FStatusProc) then Synchronize(StatusCallBack);
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;

function TSplitThread.Etape_ZipFile(aFileName,aSplitInfoFile:TFileName;numero:integer):TFileName;
begin
    result := ZipFile(aFileName,aSplitInfoFile,numero);
end;

procedure TSplitThread.EtapeDepotFTP(a7ZFile:TFileName);
var vIdFTP:TIdFTP;
    v:string;
    i:Integer;
    vDirExist : Boolean;
    vIdSSLIOHandler : TIdSSLIOHandlerSocketOpenSSL;
begin
    FStatus:='Dépot FTP : En cours sur ' + FFTP_Host;
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    if FileExists(a7ZFile) then
      begin
          vIdSSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
//          vIdSSLIOHandler.SSLOptions.Mode := sslmClient;
//          vIdSSLIOHandler.OnStatusInfoEx := Self.OnStatusInfoEx;
          vIdSSLIOHandler.SSLOptions.Method := sslvTLSv1_2;
            // sslvTLSv1; sslvTLSv1_2; sslvSSLv2; sslvSSLv23;
          vIdSSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
//          vIdSSLIOHandler.SSLOptions.Method := sslvSSLv3;
//          vIdSSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_1];

          vIdFTP:= TIdFTP.Create(nil);
          vIdFTP.IOHandler:=vIdSSLIOHandler;
          try
             vIdFTP.Username := FFTP_Username;   // 'backup';
             vIdFTP.Password := FFTP_Password;  // 'ch@mon1x'; //
             vIdFTP.Host     := FFTP_Host;  // 'storage.easy.local'; //
             vIdFTP.Port     := FFTP_Port;
             vIdFTP.UseTLS   := utUseExplicitTLS;
             vIdFTP.DataPortProtection := ftpdpsClear;  // ftpdpsPrivate;
             vIdFTP.TransferType := ftBinary;
             try
               vIdFTP.Passive := True;   // problème sur replic3 sans cette ligne ça ne fonctionne pas
               // vIdFTP.Passive := False;
               vIdFTP.Connect;

               //-----------------------------------------
               vIdFTP.ChangeDir('splits');
               vIDFTP.List;

               vDirExist := false;
               for I := 0 to vIdFTP.DirectoryListing.Count-1 do
                      begin
                        if (vIDFTP.DirectoryListing[I].ItemType=ditDirectory) and (vIDFTP.DirectoryListing[I].FileName=NOMPOURNOUS)
                          then
                            begin
                              vDirExist := True;
                              break;
                            end;
                      end;
                    If not(vDirExist)
                      then vIdFTP.MakeDir(NOMPOURNOUS);
                    vIdFTP.ChangeDir(NOMPOURNOUS);
                    vIdFTP.Put(a7ZFile,ExtractFileName(a7ZFile));
             except
                  On E:Exception do
                    begin
                      NbError := NbError +1;
                      FStatus := E.Message;
                      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                    end;
              end;
          finally
             if vIdFTP.Connected then
               vIdFTP.Disconnect;
            vIdSSLIOHandler.Free;
            FreeAndNil(vIdFTP);
          end;
      end;
end;

function TSplitThread.ZipFile(aFileName,aSplitInfoFile:TFileName;numero:integer):TFileName;
var Arch : I7zOutArchive;
    ext :string;
begin
  FStatus:=Format('Compression fichier %d/%d : [En Cours]',[numero,FListBases.Count]);
  if Assigned(FStatusProc) then Synchronize(StatusCallBack);
  Arch := CreateOutArchive(CLSID_CFormat7z);
  try
    try
      Arch.AddFile(aFileName,ExtractFileName(aFileName));
      Arch.AddFile(aSplitInfoFile,ExtractFileName(aSplitInfoFile));

      //-----------------------------------
      // SetCompressionLevel(Arch,3);  // il faut plutot mettre 1 l'ecart et trop important en temps..
      SetCompressionLevel(Arch,1);     // après calcul le temps de transfert et plus impactant pour isf
      SetMultiThreading(Arch,2);       //

      ext := '.split';
      // Arch.SetProgressCallback(nil,ProgressCallback);
      // if TypeArchive=CLSID_CFormat7z  then ext:='.7z';
      // if TypeArchive=CLSID_CFormatzip then ext:='.zip';

      result := ChangeFileExt(AFileName,ext);

      Arch.SetPassword(CST_7Z_PASSWORD);
      // SevenZipSetCompressionMethod(Arch, T7zCompressionMethod.m7Deflate64);

      Arch.SaveToFile(result);
      // si il n'y a pas eu d'erreur on supprime la source du zip si

      FStatus:=Format('Compression fichier %d/%d : [OK]',[numero,FListBases.Count]);
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);

      // DeleteFile(AFileName);
      Except on E:Exception do
        begin
          FStatus:=Format('Compression fichier %d/%d : [ERREUR]',[numero,FListBases.Count]);
          if Assigned(FStatusProc) then Synchronize(StatusCallBack);
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;

{
procedure TSplitThread.UpdateVCL();
begin
    Frm_MainLame.Lbl_Status.Caption:=FStatus;
    Frm_MainLame.Lbl_Status.Refresh;

    Frm_MainLame.ProgressBar.Visible := true;
    Frm_MainLame.ProgressBar.Position:=FProgression;
    Frm_MainLame.ProgressBar.Refresh;
end;
}

constructor TSplitThread.Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);

    FFTP_Username       := LoadStrFromIniFile('FTP','USERNAME');
    FFTP_Password       := LoadStrFromIniFile('FTP','PASSWORD');
    FFTP_Host           := LoadStrFromIniFile('FTP','HOST');
    FFTP_Port           := LoadIntFromIniFile('FTP','Port');

    FDepotFTP           := False;

    FStatusProc         := aStatusCallBack;
    FProgressProc       := aProgressCallBack;
    FCreateTime         := Now();
    FDLC                := IncMinute(FCreateTime,5*MinsPerDay);
    FnbError            := 0;
    FListBases          := TStringList.Create;
    FListBases.Clear;
    FORIGINE_IB         := '';
    FCOPY_IB            := '';
    FEngine             := '';
    // FSplit              := false;
    FVERSION            := '';
    FScriptFile         := '';
    FreeOnTerminate     := true;
    OnTerminate         := AEvent;
    FSENDER             := '';
    FNODE_GROUP_ID      := 'mags';  // Par defaut c'est mags
    FMode               := 0;  // 0 : par defaut Mode Splittage complet
                               // 1 : Mode mini split
end;


procedure TSplitThread.Etape_Stop_Service;
begin
    try
      FStatus:=Format('Arrêt du Service %s : en cours...',[FSYMDSInfos.ServiceName]);
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
      ServiceStop(FLAME,FSYMDSInfos.ServiceName);
      FStatus:=Format('Arrêt du Service %s : [OK]',[FSYMDSInfos.ServiceName]);
    except
      FStatus:=Format('Arrêt du Service %s : [ERREUR]',[FSYMDSInfos.ServiceName]);
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    end;

end;

procedure TSplitThread.Etape_Start_Service;
begin
    try
      FStatus:=Format('Démarrage du Service %s : EN COURS...',[FSYMDSInfos.ServiceName]);
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
      ServiceStart(FLAME,FSYMDSInfos.ServiceName);
      FStatus:=Format('Démarrage du Service %s : [OK]',[FSYMDSInfos.ServiceName]);
    except
      FStatus:=Format('Démarrage du Service %s : [ERREUR]',[FSYMDSInfos.ServiceName]);
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    end;
end;



procedure TSplitThread.Etape_Creation_Noeuds_Mags;
var i : integer;
    sengine : string;
    chaine  : string;
    merror  : string;
    a       : cardinal;
    vCnx    : TFDConnection;
    vQuery  : TFDQuery;

begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FORIGINE_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        if bForceRecreate then
            begin
                FStatus:='Suppression des Noeuds : [...]';
                if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                // vQuery.Connection:=FConnexion;
                // vQuery.Transaction:=FTransaction;
                // FConnexion.open;
                vCnx.Open();
                If vCnx.Connected then
                    begin
                       for i := 0 to FListBases.Count-1 do
                           begin
                               // Je ne pense pas qu'il faille enlever ce Noeud
                               {
                               vQuery.CLose;
                               vQuery.SQL.Clear;
                               vQuery.SQL.Add(Format('DELETE FROM SYM_NODE_SECURITY WHERE NODE_ID=''%s'' ',[Sender_To_Node(FListBases.Strings[i])]));
                               vQuery.ExecSQL;
                               // vQuery.Transaction.Commit;

                               // vQuery.Transaction.StartTransaction;
                               vQuery.CLose;
                               vQuery.SQL.Clear;
                               vQuery.SQL.Add(Format('DELETE FROM SYM_NODE WHERE NODE_ID=''%s'' ',[Sender_To_Node(FListBases.Strings[i])]));
                               vQuery.ExecSQL;
                               }
                               // vQuery.Transaction.Commit;

                               // suppresion des OutGoingBatch de cette base puisqu'on va la redescendre....
                               // >>> si on supprime pas il faudrait au moins les passer à IGN
                               // vQuery.Transaction.StartTransaction;

                               // On passe à IGNORE les paquets "NEW" car on va faire un splittage pour ce noeud : inutile de lui laisser des vieux paquets dans le tuyaux
                               vQuery.CLose;
                               vQuery.SQL.Clear;
                               vQuery.SQL.Add(Format('UPDATE SYM_OUTGOING_BATCH SET STATUS=''IG'' WHERE NODE_ID=''%s'' AND STATUS=''NE'' AND CHANNEL_ID=''default'' ',[Sender_To_Node(FListBases.Strings[i])]));
                               vQuery.ExecSQL;
                               // vQuery.Transaction.Commit;

                            end;
                    end;
                FStatus:='Suppression des Batch trop vieux : [...]';
                Synchronize(StatusCallBack);
            end;

        sengine := Engine;

        // Creation de symadmin_new.bat a cause du Path
        { Non maintenant on a notre propre chemin de "JAVA"
        with TStringList.Create do
          try
            LoadFromFile(Format('%s\bin\symadmin.bat',[FSYMDSInfos.Directory]));
            Insert(0,Format('SET PATH=%%PATH%%;%s\bin',[VGSE.JavaPath]));
            SaveToFile(Format('%s\bin\symadmin_new.bat',[FSYMDSInfos.Directory]));
          finally
            Free;
          end;
        }
        FStatus:='Création des Noeuds Base Magasins : [OK]';
        if Assigned(FStatusProc) then Synchronize(StatusCallBack);
        //------------------------------------------------------------------------
        for i := 0 to FListBases.Count-1 do
            begin
                chaine := Format('--engine %s open-registration %s %s',[
                    sengine,
                    FNODE_GROUP_ID,
                    Sender_To_Node(FListBases.Strings[i])]
                    );
                a:=ExecAndWaitProcess(merror,
                  Format('%s\bin\symadmin.bat',[FSYMDSInfos.Directory]),
                  chaine);
            end;

        FStatus:='Activation des Noeuds Base Magasins : En cours...';
        if Assigned(FStatusProc) then Synchronize(StatusCallBack);
        // il faut encore les activés... SYM_ENABLED=1
        //
        // PQuery.Connection:=FConnexion;
        // vPQuery.Transaction:=FTransaction;
        // FConnexion.open;
        If vCnx.Connected then
            begin
               for i := 0 to FListBases.Count-1 do
                   begin
                       // vQuery.Transaction.StartTransaction;
                       vQuery.CLose;
                       vQuery.SQL.Clear;
                       vQuery.SQL.Add(Format('UPDATE SYM_NODE SET SYNC_ENABLED=1 WHERE SYNC_ENABLED=0 AND NODE_ID=''%s'' ',[Sender_To_Node(FListBases.Strings[i])]));
                       vQuery.ExecSQL;
                       // Pas très grave ???
                       //if vQuery.RowsAffected<>1
                       // then
                       //    begin
                       //       raise Exception.Create('Noeud déjà actif !');
                       //    end;
                       // vQuery.Transaction.Commit;
                    end;
            end;
        FStatus:='Activation des Noeuds Base Magasins : [OK]';
        if Assigned(FStatusProc) then Synchronize(StatusCallBack);
        FProgress  := 10;

        Except On E:Exception do
          begin
            FStatus:='Création des Noeuds Base Magasins : [ERREUR] ' + E.Message;
            if Assigned(FStatusProc) then Synchronize(StatusCallBack);
            inc(FnbError);
            Exit;
          end;
        end;
      Finally
        vQuery.Close();
        vQuery.DisposeOf;
        vCnx.DisposeOf;
    end;
end;

procedure TSplitThread.Etape_Script;
var sdirectory:string;
    sProgUninstall:string;
    vScript:TFDScript;
    BufferSQL:string;
    sTmpFile:string;
    i:integer;
    chaine:string;
    merror:string;
    a:cardinal;
    vCnx    : TFDConnection;
    vQuery  : TFDQuery;

begin
    try
      FStatus:='Restart de la copie : [En Cours]';
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);

      chaine := Format('-online -user SYSDBA -password masterkey %s',[FCOPY_IB]);
      a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

      // Ce n'est plus fait ici !!!! important
      // chaine := Format('-online -user SYSDBA -password masterkey %s',[FORIGINE_IB]);
      // a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

      FStatus:='Restart de la copie : [OK]';
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
      Except On E:Exception do
        begin
          FStatus:='Restart de la copie : [ERREUR] ' + E.Message;
          Synchronize(StatusCallBack);

          inc(FnbError);
          Exit;
        end;
      end;

    FStatus:='Nettoyage de la Copie : [En Cours]';
    Synchronize(StatusCallBack);

    Sleep(15*1000); // Pause de 15s


    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FCOPY_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);

    {
    FConnexion.Close();
    FConnexion.Params.Clear();
    FConnexion.Params.Add('DriverID=IB');
    FConnexion.Params.Add('User_Name=SYSDBA');
    FConnexion.Params.Add('Password=masterkey');
    FConnexion.Params.Add('Protocol=TCPIP');
    FConnexion.Params.Add('Server=localhost');
    FConnexion.Params.Add('Port=3050');
    FConnexion.Params.Add(Format('Database=%s', [FCOPY_IB]));
    // Resume;
    // Copie du fichier
    PQuery:=TFDQuery.Create(nil);
    PQuery.Connection:=FConnexion;
    PQuery.Transaction:=FTransaction;
    // PQuery.Transaction.Options.AutoStart:=true;
    // PQuery.Transaction.Options.AutoCommit:=true;
    }
    vScript:=TFDScript.Create(nil);
    vScript.Connection:=vCnx;
//  vScript.Transaction:=FTransaction;
//  PScript.Transaction.Options.AutoStart:=true;
//  PScript.Transaction.Options.AutoCommit:=true;
//  PScript.Transaction:=TransSymmDS;
//  vScript.Transaction.Options.AutoStart:=true;
//  PScript.Transaction.Options.AutoCommit:=true;

    try
       try
       vCnx.open;
       If vCnx.Connected then
          begin
               With TStringList.Create do
                   try
                      LoadFromFile(FScriptFile);
                      BufferSQL:='';
                      for i:= 0 to Count-1 do
                        begin
                             IF Pos('^', Strings[i]) = 0
                                then BufferSQL := BufferSQL + #13 + #10 + Strings[i];
                             IF Pos('^',  Strings[i]) = 1
                                then
                                    begin
                                        if (Pos('SELECT ', UPPERCASE(Trim(BufferSQL))) = 1 )
                                            then
                                                begin
                                                     // vQuery.Transaction.StartTransaction;
                                                     vQuery.Close;
                                                     vQuery.SQL.Clear;
                                                     vQuery.SQL.Add(BufferSQL);
                                                     vQuery.Prepare;
                                                     vQuery.Open;
                                                     // vQuery.Transaction.Commit;
                                                     vQuery.Close;
                                                end
                                            else
                                              try
                                               // vScript.Transaction.StartTransaction;
                                               vScript.SQLScripts.Clear;
                                               vScript.SQLScripts.Add;
                                               vScript.SQLScripts[0].SQL.Add(Trim(BufferSQL));
                                               vScript.ValidateAll;
                                               vScript.ExecuteAll;
                                               // vScript.Transaction.Commit;
                                               // FStatus:=Format('Ligne N°%d : [OK]' ,[i]);
                                               // Synchronize(UpdateVCL);
                                               Except On Ez:Exception do
                                                 begin
                                                    FStatus:=Format('Ligne N°%d : [ERREUR]',[i]);
                                                    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                                                    exit;
                                                     // MessageDlg(Ez.Message,  mtCustom, [mbOK], 0);
                                                 end;
                                            end;
                                       BufferSQL:='';
                                    end;
                        end;
                     finally
                        Free;
                   end;
            FStatus:='Nettoyage de la Copie : [OK]';
            if Assigned(FStatusProc) then Synchronize(StatusCallBack);
            // FProgress :=
            if Assigned(FProgressProc) then Synchronize(ProgressCallBack);
          end;
       Except On Ez : Exception do
                 begin
                    FStatus:='Nettoyage de la Copie : [ERREUR] ' + Ez.Message;
                    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                    // MessageDlg(Ez.Message,  mtCustom, [mbOK], 0);
                 end;
        end;
     finally
        vScript.Free;
        vQuery.Close;
        vQuery.DisposeOf;
        vCnx.DisposeOf;
        // Libération du POOL
        DataMod.FreeInfFDManager('SYSDBA@'+FCOPY_IB);
     end;
end;

procedure TSplitThread.Etape_Restart_ORIGINE_IB;
var chaine:string;
    a:cardinal;
    merror:string;

begin
    try
      FStatus:='Restart de la base de production : [En Cours]';
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);

      chaine := Format('-online -user SYSDBA -password masterkey %s',[FORIGINE_IB]);
      a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

      FStatus:='Restart de la base de production : [OK]';
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
      Except On E:Exception do
        begin
          FStatus:='Restart de la base de production : [ERREUR] ' + E.Message;
          Synchronize(StatusCallBack);

          inc(FnbError);
          Exit;
        end;
      end;

end;


procedure TSplitThread.Etape_ShutDown_Copy;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          FStatus:='Arrêt de la base...';
          if Assigned(FStatusProc) then Synchronize(StatusCallBack);
          DeleteFile(FCOPY_IB);
          chaine := Format('-shut -force 5 -user SYSDBA -password masterkey %s',[FORIGINE_IB]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);
          FStatus:='Copie de la base...';
          if Assigned(FStatusProc) then Synchronize(StatusCallBack);
          // Force la création du répertoire de FCOPY_IB
          ForceDirectories(ExtractFilePath(FCOPY_IB));
          //
          CopyFile(PChar(FORIGINE_IB), PChar(FCOPY_IB), False);
          FSTATUS:='Arrêt de la base et Copie de la base : [OK]';
          if Assigned(FStatusProc) then Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            FStatus:='Arrêt de la base et Copie de la base : [ERREUR] ' + E.Message;
            if Assigned(FStatusProc) then Synchronize(StatusCallBack);
            inc(FnbError);
          end;
        end;
     finally
       if Assigned(FStatusProc) then Synchronize(StatusCallBack);
     end;
end;

procedure TSplitThread.Etape_MiniSplittage;
var vQuery : TFDQuery;
    vCnx   : TFDConnection;
    i : Integer;
    vligne, vVirgule:string;
    vFile : TStringList;
    vDir  : string;
    vZipFile  : TFileName;
    vInfoFile : TFileName;
    vField    : string;

begin
     FStatus:='Mini Splittage : ...';
     Synchronize(StatusCallBack);
     vCnx   := DataMod.getNewConnexion('SYSDBA@'+sORIGINE_IB);
     try

        vQuery := DataMod.getNewQuery(vCnx,nil);
        vFile := TStringList.Create;
        vDir := IncludeTrailingPathDelimiter(ExtractFilePath(sORIGINE_IB))+'splits\';
        ForceDirectories(vDir);

        // Suppression des anciens .split du même Sender
        for i := 0 to FListBases.Count-1 do
           begin
             DeleteFiles(vDir,FListBases.Strings[i]+'_*.split');
           end;

        try
          vFile.Clear;
          // Recup de la version
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT VER_VERSION FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
          vQuery.Open();
          If not(vQuery.Eof) then
            begin
              FVERSION := vQuery.FieldByName('VER_VERSION').asstring;
            end;

          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT * FROM GENPARAM WHERE PRM_TYPE=80 AND PRM_CODE=1');
          vQuery.Open();
          If not(vQuery.Eof) then
            begin
              vligne   := '';
              vVirgule := '';
              for i := 0 to vQuery.FieldCount-1 do
                begin
                  vField := QuotedStr(vQuery.Fields[i].asstring);
                  if (vQuery.Fields[i].DataType=ftTimeStamp) or (vQuery.Fields[i].DataType=ftDateTime)
                    then vField := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',vQuery.Fields[i].Value));
                  vligne := vligne + vVirgule +  vField;
                  vVirgule := ',';
                end;
              vFile.Add(vLigne);
              vQuery.Next;
            end;
          vFile.SaveToFile(vDir + 'GENPARAM.csv');
          vQuery.Close;

          vFile.Clear;
          vQuery.Close;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT K.* FROM GENPARAM JOIN K ON K_ID=PRM_ID WHERE PRM_TYPE=80 AND PRM_CODE=1');
          vQuery.Open();
          If not(vQuery.Eof) then
            begin
              vligne   := '';
              vVirgule := '';
              for i := 0 to vQuery.FieldCount-1 do
                begin
                  vField := QuotedStr(vQuery.Fields[i].asstring);
                  if (vQuery.Fields[i].DataType=ftTimeStamp) or (vQuery.Fields[i].DataType=ftDateTime)
                    then vField := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',vQuery.Fields[i].Value));
                  vligne := vligne + vVirgule + vField;
                  vVirgule := ',';
                end;
              vFile.Add(vLigne);
              vQuery.Next;
            end;
          vFile.SaveToFile(vDir + 'K.csv');
          vQuery.Close;

          Log.App   := 'Delos2Easy';
          for i := 0 to FListBases.Count-1 do
              begin
                FSENDER  := FListBases.Strings[i];
                FNODE    := Sender_To_Node(FListBases.Strings[i]);
                Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT + ' ' + FSENDER, logNotice, True, 0, ltServer);
                try
                  vInfoFile := Create_Fichier_INF(vDir+FSENDER+FormatDateTime('_yyyymmdd_hhnnss',FCreateTime));

                  vZipFile  := Etape_MiniSplitZipFile(vInfoFile,i+1);

                  SupprimerFichier(vInfoFile);

                  EtapeDepotFTP(vZipFile);

                  Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT_OK + ' ' + FSENDER, logInfo, True, 0, ltServer);
                except
                  Log.Log('InstallEasyLame', Log.Ref, Log.Doss, 'InstallOk', MSG_SPLIT + ' ' + FSENDER, logError, True, 0, ltServer);
                  raise;
                end;
              end;
          //--------------------------------------------------------------------
          // Suppression des fichiers en dehors (cas de plusieurs splits)
          SupprimerFichier(vDir + 'K.csv');
          SupprimerFichier(vDir + 'GENPARAM.csv');
          // -------------------------------------------------------------------
        finally
          vQuery.DisposeOf;
          FreeAndNil(vFile);
        end;
     finally
       vCnx.DisposeOf;
     end;
end;


procedure TSplitThread.Etape_Splittage;
var NewSplitBase:TFileName;
    merror:string;
   // a:cardinal;
    i:Integer;
    vQuery : TFDQuery;
    vCnx   : TFDConnection;
    Chaine:string;
    aIDENT: string;
    a :Integer;
    vZipFile  : TFileName;
    vInfoFile : TFileName;
begin
    try
        try
          FStatus:='Splittage Base : ...';
          Synchronize(StatusCallBack);
          // Suppression des anciens .split du même Sender
          for i := 0 to FListBases.Count-1 do
              begin
                DeleteFiles(IncludeTrailingPathDelimiter(ExtractFilePath(FCOPY_IB)),FListBases.Strings[i]+'_*.split');
              end;
          for i := 0 to FListBases.Count-1 do
              begin

                NewSplitBase := IncludeTrailingPathDelimiter(ExtractFilePath(FCOPY_IB))
                              + Format('%s_%s.ib',[FListBases.Strings[i],FormatDateTime('yyyymmdd_hhnnss',FCreateTime)]);
                FStatus:='Splittage Base : [Copie en Cours]';
                Synchronize(StatusCallBack);

                // variable pour .inf;
                FSENDER  := FListBases.Strings[i];
                FNODE    := Sender_To_Node(FListBases.Strings[i]);

                CopyFile(PChar(FCOPY_IB), PChar(NewSplitBase), False);
                FStatus:=Format('Splittage Base : [Parametrage Base %s]',[FListBases.Strings[i]]);

                Synchronize(StatusCallBack);
                vCnx   := DataMod.getNewConnexion('SYSDBA@'+NewSplitBase);
                try
                  vQuery := DataMod.getNewQuery(vCnx,nil);

                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add('SELECT VER_VERSION FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
                  vQuery.Open();
                  If not(vQuery.Eof) then
                    begin
                      FVERSION := vQuery.FieldByName('VER_VERSION').asstring;
                    end;


                  vQuery.Close;
                  vQuery.SQL.Clear;
                  // il me faut le N° de la base j'ai que son NOM...
                  vQuery.SQL.Add('SELECT BAS_IDENT FROM GENBASES WHERE BAS_SENDER=:BASSENDER');
                  vQuery.ParamByName('BASSENDER').AsString:=FListBases.Strings[i];
                  vQuery.Open();
                  aIDENT:='';
                  If not(vQuery.Eof) then
                    begin
                      aIDENT := vQuery.FieldByName('BAS_IDENT').asstring;
                    end;

                  // vQuery.SQL.Add
                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add(Format('UPDATE GENPARAMBASE SET PAR_STRING=''%s'' WHERE PAR_NOM=''IDGENERATEUR''',[aIDENT]));
                  vQuery.ExecSQL;
                  // vQuery.Transaction.Commit;

                  vQuery.Close;
                  vQuery.DisposeOf;

                finally
                  vCnx.DisposeOf;
                end;

                // chaine := Format('AUTO=%s GENERATEUR',[NewSplitBase]);
                // a:=ExecAndWaitProcess(merror, 'C:\Ginkoia\Data\RecupBase.exe', chaine);

                // Recupbase....
                a:=Etape_RecupID(NewSplitBase);

                DataMod.FreeInfFDManager('SYSDBA@'+NewSplitBase);

                //------------------------------
                vInfoFile := Create_Fichier_INF(NewSplitBase);
                vZipFile  := Etape_ZipFile(NewSplitBase,vInfoFile,i+1);

                SupprimerFichier(NewSplitBase);
                SupprimerFichier(vInfoFile);

                // Faudrait faire ca dans un autre Thread y compris les suppressions

                if (FDepotFTP) then
                  begin
                    EtapeDepotFTP(vZipFile);
                  end;
                // SupprimerFichier(vZipFile);

              end;
          FSTATUS:='Splittage Base : [OK]';

          // suppression du fichier .tmp
          DeleteFile(FCOPY_IB);

          FSTATUS:='Suppresion fichier temporaire : [OK]';

        Except On E:Exception do
          begin
            FStatus:='Splittage Base : [ERREUR] ' + E.Message;
            inc(FnbError);
          end;
        end;
     finally
       if Assigned(FStatusProc) then Synchronize(StatusCallBack);
     end;
end;


function TSplitThread.Create_Fichier_INF(Const aFile:TFileName):TFileName;
var vFInfo: TIniFile;
    vFile : TFileName;
begin
    result := '';
    vFile := ChangeFileExt(aFile,'.inf');
    vFInfo := TIniFile.Create(vFile);
    try
      vFInfo.WriteString('SPLIT','CREATE',FormatDateTime('dd/mm/yyyy hh:nn:ss',FCreateTime));
      vFInfo.WriteString('SPLIT','DLC',FormatDateTime('dd/mm/yyyy hh:nn:ss',FDLC));
      vFInfo.WriteString('SPLIT','NOMPOURNOUS',NOMPOURNOUS);
      vFInfo.WriteString('SPLIT','SENDER',FSENDER);
      vFInfo.WriteString('SPLIT','NOEUD',FNODE);
      vFInfo.WriteString('SPLIT','NODE_GROUP_ID',FNODE_GROUP_ID);
      vFInfo.WriteString('SPLIT','VERSION',FVERSION);
      vFInfo.UpdateFile;
      result:=vFInfo.FileName;
    finally
      vFInfo.Free;
    end;
end;

function TSplitThread.Etape_RecupID(var aFile:TFileName):Integer;
// code de retour :
// 0 - reussite
// 1 - Erreur de Téléchargement du fichier
// 2 - IDGENERATEUR non trouver
// 3 - Plages non trouver
// 4 - Exception
// 5 - Autre erreur
var
  DestPath : string;
  ini      : TIniFile;
  vCnx     : TFDConnection;
  vPlageMagasin : string;
//  Transaction : TFDTransaction;
  vIdentBase : Integer;
  QueryLst, QueryAsk, QueryMaj : TFDQuery;
  Res : integer;
begin
  result := 5;
  FStatus:='Récupération des ID : ...';
  Synchronize(StatusCallBack);

//  if Assigned(FProgress) then
//    Synchronize(ProgressMarquee);

  try
    try
      DestPath := GetTmpDir(); // GetTempDirectory();
      ForceDirectories(DestPath);
      // recup du fichier de definition !
      if DownloadHTTP('http://lame2.no-ip.com/maj/GINKOIA/recupbase.ini', IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini') then
      begin
        try
          Ini := TIniFile.Create(IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini');
          // recalcup des geénérateur
          try
            vCnx        := DataMod.getNewConnexion('SYSDBA@' + aFile);
            try
              vCnx.Open();
              try
                QueryLst := DataMod.GetNewQuery(vCnx, nil);
                QueryAsk := DataMod.GetNewQuery(vCnx, nil);
                QueryMaj := DataMod.GetNewQuery(vCnx, nil);
                  try
                    // recupération du numero de base
                    QueryLst.SQL.Text := 'select cast(par_string as integer) as nummagasin from genparambase where par_nom = ''IDGENERATEUR'';';
                    try
                      QueryLst.Open();
                      if QueryLst.Eof then
                      begin
                        result := 2;
                        Exit;
                      end
                      else
                        vIdentBase := QueryLst.FieldByName('nummagasin').AsInteger;
                    finally
                      QueryLst.Close();
                    end;

                    // FLogs.Add('  -> ' + IntToStr(FIdentBase));
                    // FLogs.Add('Récupération des plages');

                    // recupération des plages
                    QueryLst.SQL.Text := 'select cast(bas_ident as integer) as nummagasin, bas_plage from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ''' + IntToStr(vIdentBase) + ''';';
                    try
                      QueryLst.Open();
                      if QueryLst.Eof then
                      begin
                        result := 3;
                        Exit;
                      end
                      else
                        vPlageMagasin := QueryLst.FieldByName('bas_plage').AsString;
                    finally
                      QueryLst.Close();
                    end;

                    // FLogs.Add('  -> ' + FPlageMagasin);
                    // FLogs.Add('Listing des générateurs');

                    // selection des génénrateur
                    QueryLst.SQL.Text := 'select rdb$generator_name as name from rdb$generators where rdb$system_flag is null or rdb$system_flag = 0';
                    try
                      QueryLst.Open();
                      QueryLst.FetchAll();

                      // init progress bar !
                      {
                      FMaxProgress := QueryLst.RecordCount;
                      if Assigned(FProgress) then
                        Synchronize(InitProgress);
                      }

                      while not QueryLst.Eof do
                      begin
                        // FStepProgress := 'Traitement du générateur "' + QueryLst.FieldByName('name').AsString + '"...';
                        //if Assigned(FProgress) then
                        //  Synchronize(ProgressStepLbl);
                        FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString;
                        Synchronize(StatusCallBack);
                        Res := TraiteGenerateur(QueryAsk, vIdentBase, vPlageMagasin, QueryLst.FieldByName('name').AsString, ini);
                        Case Res of
                           -2 : FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString + ' : Non pris en charge';
                           -1 : FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString + ' : Ne pas changer';
                          else
                            begin
                              FStatus := 'Récupération des ID : ' + QueryLst.FieldByName('name').AsString + ' : ' + Inttostr(Res);
                              QueryMaj.SQL.Text := 'SET GENERATOR ' + QueryLst.FieldByName('name').AsString + ' to ' + Inttostr(res) + ';';
                              QueryMaj.ExecSQL();
                            end;
                        end;
                        if Assigned(FStatusProc) then Synchronize(StatusCallBack);
                        QueryLst.Next();
      //                ProgressStepIt();
                      end;

                      // Avant EASY
                      //  ==> FTriggerDiff = 1 sur la lame
                      //  ==> FTriggerDiff = 0 en magasin

                      If FTriggerDiff   // Si triggerDiff alors triggers pas actifs signifie GENTIGGERS = 1
                        then
                          begin
                            QueryMaj.Close();
                            QueryMaj.SQL.Text := 'SET GENERATOR GENTRIGGER TO 1;';  // la ca posera dans GENTRIGGERDIFF
                            QueryMaj.ExecSQL();
                          end
                      else
                         begin
                           QueryMaj.Close();
                           QueryMaj.SQL.Text := 'SET GENERATOR GENTRIGGER TO 0;';   // le calcul de stock est immédiat
                           QueryMaj.ExecSQL();
                         end;

                    finally
                      QueryLst.Close();
                    end;

                    // Transaction.Commit();
                    result := 0;
                  except
                    // Transaction.Rollback();
                    raise;
                  end;
              finally
                FreeAndNil(QueryLst);
                FreeAndNil(QueryAsk);
                FreeAndNil(QueryMaj);
              end;
            finally
              vCnx.DisposeOf;
            end;
          finally
            //
          end;
        finally
          FreeAndNil(ini);
        end;
      end
      else
        result := 1;
    finally
      // suppression du repertoire !
      // DelTree(DestPath);
    end;
  except
    on e : Exception do
    begin
      result := 4;
    end;
  end;
end;


function TSplitThread.TraiteGenerateur(Query : TFDQuery; aIdentBase:Integer; aPlage:string;GenName : string; ini : TInifile) : integer;
var
  i, j : Integer;
  Deb, Fin : Integer;
  Methode, Minimum, nbTables : Integer;
  Table, Champ, Cond, Tmp : string;
  Sufixes : TStringList;
  DoWithout : Boolean;
begin
  Methode := ini.readinteger(GenName, 'Def', 0);
  Minimum := ini.readinteger(GenName, 'Min', -9999);
  nbTables := ini.readinteger(GenName, 'NbTable', 0);
  Result := Math.Max(minimum, 0);

  case Methode of
    1: // DEF=1 -> Valeur dans la plage
      begin
        decodeplage(aPlage, Deb, Fin);
        Result := Math.Max(Deb * 1000000, Result);
        for i := 1 to nbTables do
        begin
          GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
          RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table + ' where ' + Champ + ' between ' + Inttostr(Deb)
                              + '*1000000 and ' + Inttostr(Fin) + '*1000000;', Cond, Result);
        end;
      end;
    2: // DEF=2 -> NumMagasin + '-' + Valeur [+ '*R'] [+ '*F']
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'Select Max( Cast(f_mid (' + champ + ',' + inttoStr(Length(Inttostr(aIdentBase)) + 1)
                            + ',f_bigstringlength(' + champ + ')-' + inttoStr(Length(Inttostr(aIdentBase)) + 3)
                            + ' ) as integer))'
                            + ' from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%'''
                            + ' and ' + Champ + ' like ''%R'' ', Cond, Result);
        RecupMaxValeur(Query, 'select Max( Cast(f_mid (' + Champ + ',' + InttoStr(Length(Inttostr(aIdentBase)) + 1) + ',12) as integer)) '
                            + 'from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%'' '
                            + 'and not (' + Champ + ' like ''%R'') and not (' + Champ + ' like ''%F'') ', Cond, Result);
      end;
    3: // DEF=3 -> Valeur
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table, Cond, Result);
      end;
    4: // DEF=4 -> Code Barre ('2' + NumMag sur 3 chiffre + generateur + chiffre de control)
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);

        try
          Tmp := Format('%.3d', [aIdentBase]);
          query.SQL.Text := 'Select Max(' + Champ + ') from ' + Table + ' Where (' + Champ + ' like ''2' + Tmp + '%'') ';
          if Cond <> '' then
            query.sql.Add('AND ' + Cond);
          query.Open();
          if not (query.fields[0].IsNull) then
          begin
            Tmp := query.fields[0].AsString;
            Delete(Tmp, 1, 4);
            Delete(Tmp, length(Tmp), 1);
            Result := Math.Max(Result, StrToIntDef(Tmp, Result));
          end;
          query.Close();
        except
        end;
      end;
    5: // DEF=5 -> NumMagasin + '-' + 'M' + Valeur // Modèle de facture
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'select Max(Cast(f_mid (' + Champ + ',' + InttoStr(Length(Inttostr(aIdentBase)) + 2) + ',12) as integer)) '
                            + 'from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%''', Cond, Result);
      end;
    6: // DEF=6 -> mettre a 0
      Result := 0;
    7: // DEF=7 -> Pas touche !!
      Result := -1;
    8: // DEF=8 -> NumMagasin + '-' + Valeur + '*F' // Facture de retro
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, ' Select Max( Cast(f_mid (' + Champ + ',' + inttoStr(Length(Inttostr(aIdentBase)) + 1)
                            + ',f_bigstringlength(' + Champ + ')-' + inttoStr(Length(Inttostr(aIdentBase)) + 3)
                            + ') as integer))'
                            + ' from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(aIdentBase) + '-%'''
                            + ' and ' + Champ + ' like ''%F'' ', Cond, Result);
      end;
    9: // DEF=9 -> BP du web : site sur 4 caractères + '-' + NumMag + '-' + sequence
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'select max(cast(substr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 7) + ', f_bigstringlength(' + Champ + ')) as integer)) '
                            + 'from ' + table + ' '
                            + 'where ' + Champ + ' like ''____-' + Inttostr(aIdentBase) + '-%'' ', Cond, Result);
      end;
    10: // DEF=10 -> Interclub : NumMagasin + '-' + Valeur + Terminaisons en paramètres
      begin
        try
          Sufixes := TStringList.Create();
          Sufixes.Delimiter := ';';
          Sufixes.DelimitedText := ini.ReadString(GenName, 'Sufixes', '');
          DoWithout := ini.ReadBool(GenName, 'DoWithout', true);

          for i := 1 to nbTables do
          begin
            GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);

            Tmp := 'select Max(Cast(' + #10#13;
            for j := 0 to Sufixes.Count - 1 do
              if j = 0 then
                Tmp := Tmp + '  case when ' + Champ + ' like ''%' + Sufixes[j] + ''' then SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 2)
                  + ', f_bigstringlength(' + Champ + ') - ' + IntToStr(Length(Sufixes[j])) + ')' + #10#13
              else
                Tmp := Tmp + '       when ' + Champ + ' like ''%' + Sufixes[j] + ''' then SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 2)
                  + ', f_bigstringlength(' + Champ + ') - ' + IntToStr(Length(Sufixes[j])) + ')' + #10#13;
            if DoWithout then
              Tmp := Tmp + '       else SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(aIdentBase)) + 2) + ', f_bigstringlength(' + Champ + '))' + #10#13;
            Tmp := Tmp + '  end as integer))' + #10#13
                       + 'from ' + table + #10#13;
            if DoWithout then
              Tmp := Tmp + 'where ' + Champ + ' like ''' + Inttostr(aIdentBase) + '-%'''
            else
            begin
              for j := 0 to Sufixes.Count - 1 do
                if j = 0 then
                  Tmp := Tmp + 'where (' + Champ + ' like ''' + Inttostr(aIdentBase) + '-%' + Sufixes[j] + '''' + #10#13
                else
                  Tmp := Tmp + '       or ' + Champ + ' like ''' + Inttostr(aIdentBase) + '-%' + Sufixes[j] + '''' + #10#13;
              Tmp := Tmp + '  )';
            end;

            RecupMaxValeur(Query, Tmp, Cond, Result);
          end;
        finally
          FreeAndNil(Sufixes);
        end;
      end;
    11: // DEF = 11 -> Acompte Web
      begin
        for i := 1 to nbTables do
        begin
          GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
          RecupMaxValeur(Query, 'select max(cast(f_mid(' + Champ + ' ,10,7) as integer)) from ' + Table + ' where %0:s starting with ' + QuotedStr('AC :') + ';', Cond, Result);
        end;
      end;
    else
      Result := -2;
  end;
end;


function TSplitThread.DiskIsOK():Boolean;
var vDrive     : string;
    vFreeSpace : Int64;
begin
   result:=false;
   try
     vDrive:=ExtractFileDrive(FORIGINE_IB);
     // ---------------------------------------------
     vFreeSpace := DiskFree(Ord(vDrive[1])-64);

     if (filesize(FORIGINE_IB) * 3 < vFreeSpace)
        then result:=true;
   except

   end;
end;

function TSplitThread.EveryBody_Disconnected():Boolean;
Var vQuery:TFDQuery;
    i:Integer;
    vCnx   : TFDConnection;
begin
    result:=false;
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FORIGINE_IB);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    i:=0;
    try
      FStatus:='Connexions sur la base de données : ...';
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM  TMP$ATTACHMENTS');
      vQuery.open;
      While not(vQuery.eof) do
         begin
            Inc(i);
            vQuery.Next;
         end;
      result:=i=2;
      vQuery.Close;
    finally
      FStatus:=Format('Connexions sur la base de données : %d',[i]);
      vQuery.DisposeOf;
      vCnx.DisposeOf;
      {
      If (Result)
        then FStatus:=Format('Connexions sur la base de données : %d',[i])
        else
          begin
            Inc(FNBError);
            FStatus:='Connexions sur la base de données : [ERREUR] ';
          end;
      }
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    end;
end;


procedure TSplitThread.Execute;
var vBool:Boolean;
begin
    try
      try
        // il faudra dissocié correctement les 2 MODES

        // Debut

        // Tronc Commun
        if not(DiskIsOK())
          then exit;
        FProgress := 10;
        if Assigned(FProgressProc) then  Synchronize(ProgressCallBack);
        EveryBody_Disconnected();
        if FNBError=0 then Etape_Creation_Noeuds_Mags;
        FProgress := 20;
        if Assigned(FProgressProc) then Synchronize(ProgressCallBack);
        Sleep(20*1000); // Pause de 20 secondes


        // NoFTP si on est en mode Complet et qu'on a dit NoFTP
        vBool := DepotFTP;
        DepotFTP := ((FMode=1) or (vBool));

        // Mode Complet !
        Case FMode of
          0:
            begin
                if (FNBError=0) then Etape_Stop_Service;
                Sleep(20*1000); // Pause de 20 secondes

                FProgress := 30;
                if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

                if (FNBError=0)
                   then Etape_ShutDown_Copy;

                FProgress := 35;
                if Assigned(FProgressProc) then Synchronize(ProgressCallBack);
                if (FNBError=0)
                   then Etape_Restart_ORIGINE_IB();

                FProgress := 40;
                if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

                Sleep(10*1000); // Pause de 10 secondes
                if (FNBError=0) then Etape_Start_Service;

                Sleep(20*1000); // Pause de 20 secondes

                FProgress := 50;
                if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

                if (FNBError=0)
                   then Etape_Script;

                FProgress := 60;
                if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

                if (FNBError=0)
                    then Etape_Splittage;
            end;
          // Mode MiniSplit
          1:
            begin
              Etape_MiniSplittage; // valable pour tous les noeuds
            end;
        End;

{
        if (FNBError=0) then Etape_Stop_Service;
        Sleep(20*1000); // Pause de 20 secondes

        FProgress := 30;
        if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

        if (FNBError=0) and (FMode=0)
           then Etape_ShutDown_Copy;


        FProgress := 35;
        if Assigned(FProgressProc) then Synchronize(ProgressCallBack);
        if (FNBError=0)
           then Etape_Restart_ORIGINE_IB();


        FProgress := 40;
        if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

        Sleep(10*1000); // Pause de 10 secondes
        if (FNBError=0) then Etape_Start_Service;

        Sleep(20*1000); // Pause de 20 secondes

        FProgress := 50;
        if Assigned(FProgressProc) then Synchronize(ProgressCallBack);

        if (FNBError=0) and (FMode=0)
            then Etape_Script;

        FProgress := 60;
        if Assigned(FProgressProc) then Synchronize(ProgressCallBack);
        if (FNBError=0) then
           begin
              if (FMode=0)
                then Etape_Splittage;

              if (FMode=1)

           end;
        }
        if (FNBError>0) then
          raise Exception.Create('Erreur');
      except
        On E:Exception do
          begin

          end;
        end;
    finally
      FListBases.Free;
      FProgress:=100;
      if Assigned(FProgressProc) then Synchronize(ProgressCallBack);
    end;
end;

end.

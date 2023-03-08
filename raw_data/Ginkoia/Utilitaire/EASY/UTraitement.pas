unit UTraitement;

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
  Vcl.ExtCtrls, Math, UWMI,System.IniFiles;

Type
  TTraitementThread = class(TThread)
  private
    { Déclarations privées }
    FnbError           : integer;
    FStopService       : boolean;
    FForceRecreate     : Boolean;
    FSplit             : Boolean;
    FTriggerDiff       : Boolean;
    FTypeArchive       : TGUID;
    FEngine            : string;
    FListBases         : TStringList;
    FProgression       : integer;
    FStatus            : string;
    FLevel             : cardinal;
    FORIGINE_IB        : TFileName;
    FCOPY_IB           : TFileName;
    FScriptFile        : TFileName;
    FSYMDSInfos        : TSYMDSInfos;
    FDeleteSplitIBFile : boolean;
    procedure UpdateVCL();
    procedure Etape_Splittage;
    function GetBases():string;
    procedure SetBases(value:string);
    procedure ZipFile(AFileName:TFileName;numero:integer);
    function  EveryBody_Disconnected():Boolean;
  protected
    {--}
  public
    function DiskIsOK():Boolean;
    procedure Etape_Start_Service;
    procedure Etape_Stop_Service;
    procedure Etape_Creation_Noeuds_Mags;
    procedure Etape_ShutDown_Copy;
    procedure Etape_Script;
    procedure Etape_ZipFile(aFileToZip:string;numero:integer);
    function Etape_RecupID(var aFile:TFileName):Integer;
    function TraiteGenerateur(Query : TFDQuery; aIdentBase:Integer; aPlage:string ;GenName : string; ini : TInifile) : integer;
    procedure Execute; override;

  public
    constructor Create(CreateSuspended:boolean;Const AEvent:TNotifyEvent=nil); reintroduce;
    // Toutes les options du Thread
    property sORIGINE_IB    : TFileName   read FORIGINE_IB     write FORIGINE_IB;
    property sCOPY_IB       : TFileName   read FCOPY_IB        write FCOPY_IB;
    property sScriptFile    : TFileName   read FScriptFile     write FScriptFile;
    property sBases         : string      read GetBases        Write SetBases;
    property SYMDSInfos     : TSYMDSInfos read FSYMDSInfos     Write FSYMDSInfos;
    property Engine         : string      read FEngine         write FEngine;
    property bStopService   : Boolean     read FStopService    write FstopService;
    property bForceRecreate : Boolean     read FForceRecreate  write FForceRecreate;
    property bTriggerDiff   : Boolean     read FTriggerDiff    write FTriggerDiff;
    property bSplit         : Boolean     read FSplit          write FSplit;
    property TypeArchive    : TGUID       read FTypeArchive    write FTypeArchive;
    property iLevel         : cardinal    read FLevel          write FLevel;
    property NbError        : integer     read FnbError           write FnbError;
    property bDeleteSplitIBFile : Boolean read FDeleteSplitIBFile write FDeleteSplitIBFile;   // Pour supprimer le fichier ib après zip

  end;

implementation

Uses LaunchProcess, Symetric.Gestion.Database, uSevenZip, ServiceControler,
     uDataMod, UCommun;

function TTraitementThread.GetBases():string;
begin
    result:=FListBases.Text;
end;

procedure TTraitementThread.SetBases(value:string);
begin
   FListBases.Clear;
   FListBases.Text:=value;
end;


procedure TTraitementThread.Etape_ZipFile(aFileToZip:string;numero:integer);
begin
    ZipFile(aFileToZip,numero);
end;

procedure TTraitementThread.ZipFile(AFileName:TFileName;numero:integer);
var Arch : I7zOutArchive;
    ext :string;
begin
  FStatus:=Format('Compression fichier %d/%d : [En Cours]',[numero,FListBases.Count]);
  Synchronize(UpdateVCL);
  Arch := CreateOutArchive(TypeArchive);
  try
    try
      Arch.AddFile(AFileName,'');
      SetCompressionLevel(Arch,Flevel);

      // Arch.SetProgressCallback(nil,ProgressCallback);
      if TypeArchive=CLSID_CFormat7z  then ext:='.7z';
      if TypeArchive=CLSID_CFormatzip then ext:='.zip';

      Arch.SaveToFile(ChangeFileExt(AFileName,ext));
      // si il n'y a pas eu d'erreur on supprime la source du zip si

      FStatus:=Format('Compression fichier %d/%d : [OK]',[numero,FListBases.Count]);
      Synchronize(UpdateVCL);

      // DeleteFile(AFileName);
      Except on E:Exception do
        begin
          FStatus:=Format('Compression fichier %d/%d : [ERREUR]',[numero,FListBases.Count]);
          Synchronize(UpdateVCL);
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;


procedure TTraitementThread.UpdateVCL();
begin
    Frm_GestionDatabase.StatusBar.Panels[0].text:=FStatus;
    Frm_GestionDatabase.StatusBar.Refresh;

    Frm_GestionDatabase.ProgressBar.Position:=FProgression;
    Frm_GestionDatabase.ProgressBar.Refresh;
end;


constructor TTraitementThread.Create(CreateSuspended:boolean;Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FnbError         := 0;
    FListBases       := TStringList.Create;
    FListBases.Clear;
    FORIGINE_IB      := '';
    FCOPY_IB         := '';
    FEngine          := '';
    FSplit           := false;
    FTypeArchive     := CLSID_CFormat7z;
    FLevel           := 5;
    FScriptFile      := '';
    FDeleteSplitIBFile  := True;
    FreeOnTerminate     := true;
    OnTerminate         := AEvent;
end;


procedure TTraitementThread.Etape_Stop_Service;
begin
    try
      FStatus:=Format('Arrêt du Service %s : en cours...',[FSYMDSInfos.ServiceName]);
      Synchronize(UpdateVCL);
      ServiceStop('',FSYMDSInfos.ServiceName);
      FStatus:=Format('Arrêt du Service %s : [OK]',[FSYMDSInfos.ServiceName]);
    except
      FStatus:=Format('Arrêt du Service %s : [ERREUR]',[FSYMDSInfos.ServiceName]);
      Synchronize(UpdateVCL);
    end;

end;

procedure TTraitementThread.Etape_Start_Service;
begin
    try
      FStatus:=Format('Démarrage du Service %s : EN COURS...',[FSYMDSInfos.ServiceName]);
      Synchronize(UpdateVCL);
      ServiceStart('',FSYMDSInfos.ServiceName);
      FStatus:=Format('Démarrage du Service %s : [OK]',[FSYMDSInfos.ServiceName]);
    except
      FStatus:=Format('Démarrage du Service %s : [ERREUR]',[FSYMDSInfos.ServiceName]);
      Synchronize(UpdateVCL);
    end;
end;



procedure TTraitementThread.Etape_Creation_Noeuds_Mags;
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
                Synchronize(UpdateVCL);

                // vQuery.Connection:=FConnexion;
                // vQuery.Transaction:=FTransaction;
                // FConnexion.open;
                If vCnx.Connected then
                    begin
                       for i := 0 to FListBases.Count-1 do
                           begin
                               // vQuery.Transaction.StartTransaction;
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
                               // vQuery.Transaction.Commit;

                               // suppresion des OutGoingBatch de cette base puisqu'on va la redescendre....
                               // >>> si on supprime pas il faudrait au moins les passer à OK
                               // vQuery.Transaction.StartTransaction;
                               vQuery.CLose;
                               vQuery.SQL.Clear;
                               vQuery.SQL.Add(Format('DELETE FROM SYM_OUTGOING_BATCH WHERE NODE_ID=''%s'' ',[Sender_To_Node(FListBases.Strings[i])]));
                               vQuery.ExecSQL;
                               // vQuery.Transaction.Commit;

                            end;
                    end;
                FStatus:='Suppression des Noeuds : [...]';
                Synchronize(UpdateVCL);
            end;

        FStatus:='Création des Noeuds Base Magasins';
        Synchronize(UpdateVCL);
        //
        sengine := Engine;
        // Creation de symadmin_new.bat a cause du Path
        with TStringList.Create do
          try
            LoadFromFile(Format('%s\bin\symadmin.bat',[FSYMDSInfos.Directory]));
            Insert(0,Format('SET PATH=%%PATH%%;%s\bin',[VGSE.JavaPath]));
            SaveToFile(Format('%s\bin\symadmin_new.bat',[FSYMDSInfos.Directory]));
          finally
            Free;
          end;

        FStatus:='Création des Noeuds Base Magasins : [OK]';
        Synchronize(UpdateVCL);
        //------------------------------------------------------------------------
        for i := 0 to FListBases.Count-1 do
            begin
                chaine := Format('--engine %s open-registration mags %s',[
                    sengine,
                    Sender_To_Node(FListBases.Strings[i])]
                    );
                a:=ExecAndWaitProcess(merror,
                  Format('%s\bin\symadmin_new.bat',[FSYMDSInfos.Directory]),
                  chaine);
            end;

        FStatus:='Activation des Noeuds Base Magasins : En cours...';
        Synchronize(UpdateVCL);
        // il faut encore les activés... SYM_ENABLED=1
        //
        // PQuery.Connection:=FConnexion;
        //vPQuery.Transaction:=FTransaction;
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
                       if vQuery.RowsAffected<>1
                        then
                           begin
                              raise Exception.Create('Noeud déjà actif !');
                           end;
                       // vQuery.Transaction.Commit;
                    end;
            end;
        FStatus:='Activation des Noeuds Base Magasins : [OK]';
        FProgression:=1;
        Synchronize(UpdateVCL);
        Except On E:Exception do
          begin
            FStatus:='Création des Noeuds Base Magasins : [ERREUR] ' + E.Message;
            Synchronize(UpdateVCL);
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

procedure TTraitementThread.Etape_Script;
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
      Synchronize(UpdateVCL);
      chaine := Format('-online -user SYSDBA -password masterkey %s',[FCOPY_IB]);
      a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

      chaine := Format('-online -user SYSDBA -password masterkey %s',[FORIGINE_IB]);
      a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

      FStatus:='Restart de la copie : [OK]';
      Synchronize(UpdateVCL);
      Except On E:Exception do
        begin
          FStatus:='Restart de la copie : [ERREUR] ' + E.Message;
          Synchronize(UpdateVCL);

          inc(FnbError);
          Exit;
        end;
      end;

    FStatus:='Nettoyage de la Copie : [En Cours]';
    Synchronize(UpdateVCL);


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
                                                    Synchronize(UpdateVCL);
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
            Inc(FProgression);
            Synchronize(UpdateVCL);
          end;
       Except On Ez : Exception do
                 begin
                    FStatus:='Nettoyage de la Copie : [ERREUR] ' + Ez.Message;
                    Synchronize(UpdateVCL);
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

procedure TTraitementThread.Etape_ShutDown_Copy;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          FStatus:='Arrêt de la base...';
          Synchronize(UpdateVCL);
          DeleteFile(FCOPY_IB);
          chaine := Format('-shut -force 5 -user SYSDBA -password masterkey %s',[FORIGINE_IB]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);
          FStatus:='Copie de la base...';
          Synchronize(UpdateVCL);
          CopyFile(PChar(FORIGINE_IB), PChar(FCOPY_IB), False);
          FSTATUS:='Arrêt de la base et Copie de la base : [OK]';
          Synchronize(UpdateVCL);
          Inc(FProgression);
        Except On E:Exception do
          begin
            FStatus:='Arrêt de la base et Copie de la base : [ERREUR] ' + E.Message;
            Synchronize(UpdateVCL);
            inc(FnbError);
          end;
        end;
     finally
       Synchronize(UpdateVCL);
     end;
end;



procedure TTraitementThread.Etape_Splittage;
var NewSplitBase:TFileName;
    merror:string;
   // a:cardinal;
    i:Integer;
    vQuery : TFDQuery;
    vCnx   : TFDConnection;
    Chaine:string;
    aIDENT: string;
    a :Integer;
begin
    try
        try
          FStatus:='Splittage Base : ...';
          Synchronize(UpdateVCL);
          for i := 0 to FListBases.Count-1 do
              begin
                NewSplitBase := Format(FCOPY_IB + '_%s.ib',[FListBases.Strings[i]]);
                FStatus:='Splittage Base : [Copie en Cours]';
                Synchronize(UpdateVCL);

                CopyFile(PChar(FCOPY_IB), PChar(NewSplitBase), False);
                FStatus:=Format('Splittage Base : [Parametrage Base %s]',[FListBases.Strings[i]]);

                Synchronize(UpdateVCL);
                vCnx   := DataMod.getNewConnexion('SYSDBA@'+NewSplitBase);
                try
                  vQuery := DataMod.getNewQuery(vCnx,nil);

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
                Etape_ZipFile(NewSplitBase,i+1);

                if bDeleteSplitIBFile then
                   SupprimerFichier(NewSplitBase);
              end;
          FSTATUS:='Splittage Base : [OK]';
          Inc(FProgression);

          // suppression du fichier .tmp
          DeleteFile(FCOPY_IB);

          FSTATUS:='Suppresion fichier temporaire : [OK]';
          Inc(FProgression);

        Except On E:Exception do
          begin
            FStatus:='Splittage Base : [ERREUR] ' + E.Message;
            inc(FnbError);
          end;
        end;
     finally
       Synchronize(UpdateVCL);
     end;
end;


function TTraitementThread.Etape_RecupID(var aFile:TFileName):Integer;
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
  Synchronize(UpdateVCL);

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
                        Synchronize(UpdateVCL);
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
                        Synchronize(UpdateVCL);
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


function TTraitementThread.TraiteGenerateur(Query : TFDQuery; aIdentBase:Integer; aPlage:string;GenName : string; ini : TInifile) : integer;
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
  Result := Max(minimum, 0);

  case Methode of
    1: // DEF=1 -> Valeur dans la plage
      begin
        decodeplage(aPlage, Deb, Fin);
        Result := Max(Deb * 1000000, Result);
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
            Result := Max(Result, StrToIntDef(Tmp, Result));
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


function TTraitementThread.DiskIsOK():Boolean;
var vDrive     : string;
    vFreeSpace : Int64;
begin
   result:=false;
   try
     vDrive:=ExtractFileDrive(FORIGINE_IB);
     //
     vFreeSpace := DiskFree(Ord(vDrive[1])-64);

     if (filesize(FORIGINE_IB) * 3 < vFreeSpace)
        then result:=true;
   except

   end;
end;

function TTraitementThread.EveryBody_Disconnected():Boolean;
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
      Synchronize(UpdateVCL);
    end;
end;


procedure TTraitementThread.Execute;
begin
    try
      if not(DiskIsOK())
        then exit;


      EveryBody_Disconnected();
      if FNBError=0 then Etape_Creation_Noeuds_Mags;
      if (FNBError=0) and (FStopService) then Etape_Stop_Service;
      if FNBError=0 then Etape_ShutDown_Copy;
      if (FNBError=0) and (FStopService) then Etape_Start_Service;
      if FNBError=0 then Etape_Script;

      if (FSplit) and (FNBError=0)
        then Etape_Splittage;

    finally
      FListBases.Free;
      FProgression:=6;
      Synchronize(UpdateVCL);
    end;
end;

end.

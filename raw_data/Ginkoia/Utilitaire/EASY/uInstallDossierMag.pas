/// <summary>
/// Unité du Thread d'installation de EASY sur un Noeud Magasin.
/// </summary>
unit uInstallDossierMag;

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
  Vcl.ExtCtrls, Math, UWMI,System.IniFiles, UCommun;

type
  /// <summary>
  /// Thread de Post Installation
  /// </summary>
  TPostControlesThread = class(TThread)
  private
    FStatusProc   : TStatusMessageCall;
    FProgressProc : TProgressMessageCall;
    // FLogProc      : TLogMessageCall;
    FProgress     : integer;
    FStatus       : string;
    FDB           : TDossierInfos;
    FEASY         : TSymmetricDS;
    FError        : string;
    FNbTrig       : Integer;
    FNbTableTrig  : Integer;
    Procedure StatusCallBack;
//    procedure LogCallBack;
    Procedure ProgressCallBack;
  protected
    //-------------------------------------
    function Etape_Controle_Noeud():string;
    procedure Etape_Controle_Triggers();
    function  Etape_Droits_TABLES():boolean;
    procedure Etape_LastHeartBeat();
    // procedure Etape_Migration_FromDELOS();
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
//          aLogCallBack      : TLogMessageCall;
          Const AEvent:TNotifyEvent=nil); reintroduce;
    function GetErrorLibelle(ret : integer) : string;
    property DB    : TDossierINfos read FDB    write FDB;
    property EASY  : TSymmetricDS  read FEASY  write FEASY;
    property ReturnValue;

  end;

  /// <summary>
  /// Thread d'Installation de EASY sur un Magasin
  /// </summary>
  TInstallDossierMagThread = class(TThread)
  private
    FStatusProc   : TStatusMessageCall;
    FProgressProc : TProgressMessageCall;
    FLogProc      : TLogMessageCall;
    FProgress     : integer;
    FStatus       : string;
    FDB           : TDossierInfos;
    FEASY         : TSymmetricDS;
    Procedure StatusCallBack;
    Procedure ProgressCallBack;
  protected
    //-------------------------------------
    procedure Etape_Installation_JAVA();
    procedure Etape_Installation_SymmetricDS;
    procedure Etape_Liaison_Dossier();
    procedure Etape_Demarrage_Service_EASY;
    procedure Etape_Recuperation_Infos_LAME();
//  procedure Etape_Controle_Triggers();
//  procedure Etape_Droits_TABLES;
//  procedure Etape_Migration_FromDELOS();
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil); reintroduce;
    property DB   : TDossierINfos read FDB    write FDB;
    property EASY : TSymmetricDS  read FEASY  write FEASY;
    function GetErrorLibelle(ret : integer) : string;
    property ReturnValue;
  end;

implementation

Uses uDataMod, ServiceControler;

{$REGION 'TPostControlesThread'}

{
procedure TPostControlesThread.LogCallBack;
begin
  if Assigned(FLogProc) then FLogProc(FError);
end;
}

procedure TPostControlesThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TPostControlesThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;

function TPostControlesThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur au GRANT sur les TABLES SYM_';
    2 : Result := 'Noeud Vide : Contrôler sur la Lame que ce Noeud arrive bien à s''enregistrer';
    3 : Result := 'Erreur sur le nombre de Triggers SymmetricDS';
  else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

procedure TPostControlesThread.Execute;
var
  vLocalNode:string;
  i: integer;
begin
   try
      vLocalNode := '';
      ReturnValue := 0;

      FStatus := 'Post-Contrôles Début';
      Synchronize(StatusCallBack);
      If not(Etape_Droits_TABLES())
        then
          begin
            ReturnValue := 1;
            exit;
          end;

      // on fait plusieurs tentatives car des fois le noeud n'est pas encore enregistré
      for i := 0 to 5 do // 3 minutes d'attente au max
      begin
        vLocalNode := DataMod.GetLocalNode(DB.DatabaseFile);
        if vLocalNode <> '' then
          Break;

        Sleep(30000);
      end;
      // si le node n'a pas été trouvé on sort
      if( vLocalNode = '') then
      begin
        ReturnValue := 2;
        exit;
      end;


      Etape_Controle_Triggers();
      if (FNbTrig<>FNbTableTrig) or (FNbTableTrig<100)
        then
          begin
            ReturnValue := 3;
            exit;
          end;

      Etape_LastHeartBeat();
      // il faut peut etre mettre une condition (si les triggers sym_ds sont bien la...)
      // Etape_Migration_FromDELOS();
      FStatus:='Post Contrôles : Fin ';
      Synchronize(StatusCallBack);

      FProgress := 100;
      Synchronize(ProgressCallBack);
   finally


   end;
end;

constructor TPostControlesThread.Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
//          aLogCallBack      : TLogMessageCall;
          Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FStatusProc         := aStatusCallBack;
    FProgressProc       := aProgressCallBack;
//    FLogProc            := aLogCallBack;
    OnTerminate         := aEvent;
    FProgress           := 0;
    FStatus             := 'Init';
    FreeOnTerminate     := true;
end;

function TPostControlesThread.Etape_Controle_Noeud():string;
begin
    result := DataMod.GetLocalNode(DB.DatabaseFile);
end;

procedure TPostControlesThread.Etape_Controle_Triggers();
var i:Integer;
    vTotal,vCurrent:integer;
begin
    FStatus:='Calcul Nombre de Triggers...';
    Synchronize(StatusCallBack);
    vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);
    vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
    i:=0;
    while (vCurrent<vTotal) and (i<100) do
       begin
         FStatus:=Format('Génération des Triggers en cours ... %d/%d',[vCurrent,vTotal]);
         Synchronize(StatusCallBack);
         vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
         vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);
         FProgress := 50 + Round(50*vCurrent/vTotal);
         inc(i);
         Synchronize(ProgressCallBack);
         Sleep(2000);
       end;
    FNbTrig      := vCurrent;
    FNbTableTrig := vTotal;
    FStatus:=Format('Triggers : %d/%d',[vCurrent,vTotal]);
    Synchronize(StatusCallBack);
end;

function TPostControlesThread.Etape_Droits_TABLES():boolean;
begin
    // passer le GRANT sur les tables SymmetricDS ...
    try
      FStatus:='Passage des droits sur les TABLES.';
      Synchronize(StatusCallBack);
      DataMod.Grant_SYMTABLE_TO_GINKOIA(FDB.DatabaseFile);
      Sleep(200);
      result:=true;
    except
      result:=false;
    end;
end;

procedure TPostControlesThread.Etape_LastHeartBeat();
var vNode:string;
    vresult:string;
begin
  vresult:='';
  try
    FStatus:='Calcul Last HeartBeat...';
    Synchronize(StatusCallBack);
    vNode := DataMod.GetLocalNode(FDB.DatabaseFile);
    vresult := DataMod.GetLastHeartBeat(FDB.DatabaseFile,vNode);
    FStatus:='Last HeartBeat : ' +vresult;
    Synchronize(StatusCallBack);
  except
    ReturnValue := 5;
  end;
end;

{$ENDREGION 'TPostControlesThread'}

{$REGION 'TInstallDossierMagThread'}
procedure TInstallDossierMagThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TInstallDossierMagThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;

constructor TInstallDossierMagThread.Create(CreateSuspended:boolean;
          aStatusCallBack   : TStatusMessageCall;
          aProgressCallBack : TProgressMessageCall;
          Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FStatusProc         := aStatusCallBack;
    FProgressProc       := aProgressCallBack;
    OnTerminate         := aEvent;
    FProgress           := 0;
    FStatus             := 'Init';
    FreeOnTerminate     := true;
end;

procedure TInstallDossierMagThread.Etape_Installation_JAVA();
begin
    Synchronize(StatusCallBack);
    If not(JAVAInstalled(1))
       then
         begin
           FStatus:='Installation de JAVA...';
           FProgress := 2;
           Synchronize(StatusCallBack);
           InstallJAVA(1);
         end
    else FStatus:='Installation de JAVA : déjà faite';
end;

{
procedure TInstallDossierMagThread.Etape_Migration_FromDELOS();
var vSQL:TStringList;
    vResSQL : TResourceStream;
    vFileSQL : TFileName;
begin
  FStatus:='Ajout des données non repliquées avec DELOS';
  Synchronize(StatusCallBack);
  Sleep(2000);
  // En Boucle Execute j'utilsait "total" pour avoir le nombre de triggers...


  vSQL := TStringList.Create();
  try
    vFileSQL := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'migration_delos_easy.sql';
    try
      vResSQL := TResourceStream.Create(HInstance, 'migrdelos', RT_RCDATA);
      try
        vResSQL.SaveToFile(vFileSQL);
      finally
        vResSQL.Free();
      end;
    except
       on e: Exception do
       begin
         Exit;
       end;
    end;
    if FileExists(vFileSQL) then
      begin
        vSQL.LoadFromFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'migration_delos_easy.sql');
        DataMod.ExecuteScript(FDB.DatabaseFile,vSQL);
        // Suppression du fichier sql
        DeleteFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'migration_delos_easy.sql');
        //----------------------------------------------------------------------
        // Après il faut faire le JOB....
        if DataMod.IsPushMissingDELOSDefined(FDB.DatabaseFile)
          then DataMod.DoPushMissingDELOS(FDB.DatabaseFile);
      end;
  finally
    vSQL.DisposeOf;
  end;
end;
}

procedure TInstallDossierMagThread.Etape_Installation_SymmetricDS;
begin
     FStatus:='Installation de SymmetricDS...';
     Synchronize(StatusCallBack);
     FProgress := 25;
     Synchronize(ProgressCallBack);
     DataMod.InstallationSymmetricDS(EASY,false);
end;


procedure TInstallDossierMagThread.Etape_Liaison_Dossier();
begin
     FStatus:='Liaison avec le Dossier...';
     FProgress := 75;
     Synchronize(StatusCallBack);
     Synchronize(ProgressCallBack);
     DataMod.Installation_BASE(DB);
end;

procedure TInstallDossierMagThread.Etape_Demarrage_Service_EASY;
begin
   FStatus:='Démarrage du Service ' + EASY.Nom;
   Synchronize(StatusCallBack);

   FProgress := 80;
   Synchronize(ProgressCallBack);

   ServiceStart('',EASY.Nom);
   Sleep(10000);
end;

procedure TInstallDossierMagThread.Etape_Recuperation_Infos_LAME();
var i:Integer;
begin
    FStatus:='Récupération des Informations de la Lame...';
    Synchronize(StatusCallBack);
    For i:=30 downto 1 do
        begin
            if ((i mod 10)=0) or (i<=10) then
              begin
                FStatus:=Format('Veuillez patienter %d secondes',[i]);
                Synchronize(StatusCallBack);
              end;
            Sleep(1000);
        end;
end;

{ en PostControles Maintenant
procedure TInstallDossierMagThread.Etape_Controle_Triggers();
var i:Integer;
    vTotal,vCurrent:integer;
begin
      vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);
      vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
      i:=0;
      while (vCurrent<vTotal) and (i<100) do
        begin
          FStatus:=Format('Génération des Triggers %d/%d',[vCurrent,vTotal]);
          Synchronize(StatusCallBack);
          vCurrent := DataMod.NbTriggersSymDS(DB.DatabaseFile);
          vTotal   := DataMod.NbTableTriggersSymDS(DB.DatabaseFile);
          FProgress := 50 + Round(50*vCurrent/vTotal);
          inc(i);
          Synchronize(ProgressCallBack);
          Sleep(2000);
        end;
end;
}
{ en PostControles Maintenant
procedure TInstallDossierMagThread.Etape_Droits_TABLES;
begin
     // passer le GRANT sur les tables SymmetricDS ...
     FStatus:='Passage des droits sur les TABLES.';
     Synchronize(StatusCallBack);
     DataMod.Grant_SYMTABLE_TO_GINKOIA(FDB.DatabaseFile);
     Sleep(2000);
end;
}

function TInstallDossierMagThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur à l''installation de JAVA';
    2 : Result := '';
    3 : Result := '';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;



procedure TInstallDossierMagThread.Execute;
begin
   try
      Etape_Installation_JAVA;

      Etape_Installation_SymmetricDS;

      Etape_Liaison_Dossier();

      Etape_Demarrage_Service_EASY();

      Etape_Recuperation_Infos_LAME(); // 1ère Synchro avec la LAME (triggers...)

      // Etape_Droits_TABLES();

      // Etape_Controle_Triggers();

      // il faut peut etre mettre une condition (si les triggers sym_ds sont bien la...)
      // Etape_Migration_FromDELOS();

      FStatus:='Fin installation...';
      Synchronize(StatusCallBack);
   finally
      FProgress := 100;
      Synchronize(ProgressCallBack);
   end;
end;

{$ENDREGION 'TInstallDossierMagThread'}

end.

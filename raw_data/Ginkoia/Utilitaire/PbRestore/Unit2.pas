unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ComCtrls, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,System.Win.Registry,
  Vcl.ExtCtrls, Math, System.UITypes;

type
  TTraitementThread = class(TThread)
  private
    FnbError           : integer;
    FPathDirGinkoia    : string;
    FProgression       : integer;
    FStatus            : string;
    FORIGINE_IB        : string ;
    FCOPY_IB           : string;
    FSAV_GBK           : string;
    FRES_IB            : string;
    FConOrigine        : TFDConnection;
    FConDestination    : TFDConnection;
    procedure UpdateVCL();
    { Déclarations privées }
  protected
    procedure Etape_ShutDown_Copy;
    procedure Etape_PhotoMetadata_Origine;
    procedure Etape_Drop_Constraint;
    procedure Etape_Backup;
    procedure Etape_Restore;
    procedure Etape_GFIX;
    procedure Etape_Nettoyage_Domaines;
    procedure Etape_index;
      procedure Create_Check_Constraints;
      procedure Active_Index;
    procedure Etape_procedure;
      function Get_All_Procedure():TStringList;
      function Create_All_Procedure():Boolean;
      function Alter_All_Procedure():Boolean;
      function CreateProcedure(AProc:string):Boolean;
      function AlterProcedure(AProc:string):Boolean;

    function EveryBody_Disconnected(ACon:TFDconnection):Boolean;
    function EscapeProcName(AProcName:string):string;

    procedure Etape_Triggers;
      function Create_Trigger(ATrig:string):boolean;
      function Get_All_Trigger():TStringList;
      function Create_All_Trigger():Boolean;

    procedure Etape_Grant;
      function Grant_TABLES():TStringList;
      function Grant_All_Tables():boolean;
      function Grant_procedures():TStringList;
      function List_Tables(ACon:TFDConnection):TStringList;
      function Count_Table(ACon:TFDConnection;ATable:string):integer;

    procedure Etape_Repose_Contrainte;

    procedure Etape_PhotoMetadata_Destination;

    procedure Etape_Compte_Records;

    procedure Etape_CopyFinale;

    procedure Etape_BackupRestoreGinkoia;

    procedure Execute; override;

  public
    constructor Create(AConOrigine,AConDestination:TFDConnection;
                        AORIGINE,ACOPY,ABackup,ARESTORE:string;CreateSuspended:boolean;Const AEvent:TNotifyEvent=nil); reintroduce;
  end;

  TForm2 = class(TForm)
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDConnection2: TFDConnection;
    FDTransaction2: TFDTransaction;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    BBackup: TButton;
    BRestore: TButton;
    BProcedure: TButton;
    BTRIGGERS: TButton;
    BGRANT: TButton;
    BCTRL: TButton;
    BGFix: TButton;
    BIndex: TButton;
    BTMPORIGINE: TButton;
    BTMP2: TButton;
    BSHUTORIGINE_0: TButton;
    BMETA_ORIGINE: TButton;
    BMETA_FINAL: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    teIBORIGINE: TEdit;
    teBCK: TEdit;
    teIBINTER: TEdit;
    teIBORIGINE_0: TEdit;
    Label1: TLabel;
    Panel3: TPanel;
    ProgressBar: TProgressBar;
    BAUTO: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lbl_mytimer: TLabel;
    MyTimer: TTimer;
    BCOPYFINAL: TButton;
    BBR_GINKOIA: TButton;
    FDIBValidate1: TFDIBValidate;
    BCLEANDOMAIN: TButton;
    OpenDialog1: TOpenDialog;
    procedure BBackupClick(Sender: TObject);
    procedure BRestoreClick(Sender: TObject);
    procedure ProceduresClick(Sender: TObject);
    procedure BTRIGGERSClick(Sender: TObject);
    procedure BGRANTClick(Sender: TObject);
    procedure BCTRLClick(Sender: TObject);
    procedure BGFixClick(Sender: TObject);
    procedure BIndexClick(Sender: TObject);
    procedure BTMPORIGINEClick(Sender: TObject);
    procedure BTMP2Click(Sender: TObject);
    procedure BSHUTORIGINE_0Click(Sender: TObject);
    procedure BMETA_ORIGINEClick(Sender: TObject);
    procedure BMETA_FINALClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BAUTOClick(Sender: TObject);
    procedure CallBackThread(Sender:TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MyTimerTimer(Sender: TObject);
    procedure BCOPYFINALClick(Sender: TObject);
    procedure BBR_GINKOIAClick(Sender: TObject);
    procedure BCLEANDOMAINClick(Sender: TObject);
    procedure BCHOOSEIBClick(Sender: TObject);
  private
    FCanClose:boolean;
    inbError:integer;
    MonThread:TTraitementThread;
    Top_Depart:TTimeStamp;
//    Top_Arrivee:TTimeStamp;
    function Sec2Time(seconds:integer):string;
    procedure LockEcran(Enabled:boolean);
    procedure Readbase0;
    function Precontrols():Boolean;
    function GetFileSize(const APath: string): int64;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

USes LaunchProcess;


{TraitementThread}

constructor TTraitementThread.Create(AConOrigine,AConDestination:TFDConnection;
                        AORIGINE,ACOPY,ABackup,ARESTORE:string;CreateSuspended:boolean;Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FnbError        := 0;
    FORIGINE_IB     := AORIGINE;
    FCOPY_IB        := ACopy;
    FSAV_GBK        := ABACKUP;
    FRES_IB         := ARESTORE;
    FPathDirGinkoia := StringReplace(ExtractFilePath(AORIGINE),'DATA\','',[rfIgnoreCase]);
    FConOrigine     := AConOrigine;
    FConDestination := AConDestination;
    OnTerminate:= AEvent;
end;

procedure TTraitementThread.Etape_Nettoyage_Domaines;
var AQuery:TFDQuery;
    PDomains:TStrings;
    i:integer;
begin
     PDomains:=TStringList.Create;
     AQuery:=TFDQuery.Create(nil);
     try
         FConDestination.Params.Database:= FRES_IB;
         AQuery.Connection:=FConDestination;
         AQuery.SQL.Clear;
         AQuery.SQL.Add('SELECT rdb$field_name AS DOMAINE FROM RDB$FIELDS WHERE rdb$field_name NOT IN (SELECT RDB$FIELD_SOURCE FROM RDB$RELATION_FIELDS)');
         AQuery.Open();
         while Not(AQuery.Eof) do
             begin
                  PDomains.Add(AQuery.FieldByName('DOMAINE').asstring);
                  AQuery.Next;
             end;
         AQuery.Close;
         for i:=0 to PDomains.Count-1 do
             begin
               AQuery.SQL.Clear;
               AQuery.SQL.Add(Format('DROP DOMAIN %s ',[PDomains[i]]));
               AQuery.ExecSQL;
             end;
     finally
       AQuery.Close;
       AQuery.Free;
     end;
end;


procedure TTraitementThread.Active_Index;
var AQuery:TFDQuery;
    PIndex:TStrings;
    i:integer;
begin
     PIndex:=TStringList.Create;
     AQuery:=TFDQuery.Create(nil);
     try
         AQuery.Connection:=FConOrigine;
         AQuery.SQL.Clear;
         AQuery.SQL.Add('SELECT RDB$INDEX_NAME AS INDEX_NAME FROM RDB$INDICES WHERE RDB$INDEX_INACTIVE=0 AND RDB$INDEX_NAME NOT LIKE ''%$%'' ');
         AQuery.Open();
         while Not(AQuery.Eof) do
             begin
                  PIndex.Add(AQuery.FieldByName('INDEX_NAME').asstring);
                  AQuery.Next;
             end;
         AQuery.Close;
         AQuery.Connection:=FConDestination;
         for i:=0 to PIndex.Count-1 do
             begin
               AQuery.SQL.Clear;
               AQuery.SQL.Add(Format('ALTER INDEX %s ACTIVE',[PIndex[i]]));
               AQuery.ExecSQL;
             end;
         for i:=0 to PIndex.Count-1 do
             begin
               AQuery.SQL.Clear;
               AQuery.SQL.Add(Format('SET STATISTICS INDEX %s',[PIndex[i]]));
               AQuery.ExecSQL;
             end;
     finally
       AQuery.Close;
       AQuery.Free;
     end;
end;


procedure TTraitementThread.Create_Check_Constraints;
var AQuery:TFDQuery;
    PCheck:TStrings;
    i:integer;
begin
     PCheck:=TStringList.Create;
     PCheck.Clear;
     AQuery:=TFDQuery.Create(nil);
     try
        try
         AQuery.Connection:=FConorigine;
         AQuery.SQL.Clear;
         AQuery.SQL.Add('SELECT DISTINCT RDB$RELATION_NAME AS TABLE_NAME, RDB$TRIGGER_SOURCE AS SOURCE FROM RDB$TRIGGERS ');
         AQuery.SQL.Add('WHERE  RDB$TRIGGER_NAME LIKE ''CHECK%'' AND  RDB$SYSTEM_FLAG=0 AND RDB$TRIGGER_TYPE=1 ');
         AQuery.SQL.Add('ORDER BY RDB$TRIGGER_NAME');
         AQuery.Open();
         while Not(AQuery.Eof) do
             begin
                 PCheck.Add(Format('ALTER TABLE %s ADD %s;',
                      [ AQuery.FieldByName('TABLE_NAME').asstring,
                        AQuery.FieldByName('SOURCE').asstring]));
                 AQuery.Next;
             end;
         AQuery.Close;
         AQuery.Connection:=FConDestination;
         for i:=0 to PCheck.Count-1 do
             begin
               AQuery.SQL.Clear;
               AQuery.SQL.Add(PCheck[i]);
               Showmessage(AQuery.SQL.Text);
               AQuery.ExecSQL;
             end;
      Except On E:Exception do
        begin
          FStatus:='Activation des Index : [ERREUR]' + E.Message;
          inc(FNbError);
        end;
      end;
     finally
       PCheck.Free;
       AQuery.Close;
       AQuery.Free;
     end;
end;

procedure TTraitementThread.Etape_procedure;
begin
   try
      try
        FProgression:=7;
        FStatus := 'Création des procedures stockées en cours...';
        SynChronize(UpdateVCL);

        FConDestination.Close();
        FConDestination.open();
        Create_All_Procedure();
        FStatus := 'Modification des procedures stockées en cours...';
        SynChronize(UpdateVCL);

        FConDestination.Close();
        FConDestination.open();
        Alter_All_Procedure();
        FConDestination.close();
        FStatus := 'Procedures stockées : [OK]';
        Fprogression:=8;

      Except On E:Exception do
        begin
          FStatus := 'Procedures stockées : [ERREUR]';
        end;
      end;
   finally
      SynChronize(UpdateVCL);
   end;
end;

procedure TTraitementThread.Etape_Grant;
begin
   try
      try
        FProgression:=9;
        FStatus := 'Grant en cours...';
        SynChronize(UpdateVCL);
        Grant_All_Tables();
        FStatus := 'Grant : [OK]';
        FProgression:=10;
      Except On E:Exception do
        begin
          FStatus := 'Grant : [ERREUR]';
        end;
       end;
    finally
            SynChronize(UpdateVCL);
     end;
end;

procedure TTraitementThread.Etape_index;
begin
   try
      try
        FProgression:=6;
        FStatus:='Activation des Index en cours...';
        SynChronize(UpdateVCL);
        FConOrigine.Params.Database  := FCOPY_IB;
        FConDestination.Params.Database:= FRES_IB;
        Create_Check_Constraints;
        Active_Index;
        FStatus:='Activation des Index : [OK]';
        FProgression:=7;
      Except On E:Exception do
        begin
          FStatus:='Activation des Index : [ERREUR]' + E.Message;
          inc(FNbError);
        end;
      end;
   finally
      SynChronize(UpdateVCL);
   end;
end;


procedure TTraitementThread.Execute;
begin
    try
      Etape_ShutDown_Copy;
      if FNBError=0 then Etape_PhotoMetadata_Origine;
      if FNBError=0 then Etape_Drop_Constraint;
      if FNBError=0 then Etape_Backup;
      if FNBError=0 then Etape_restore;
      if FNBError=0 then Etape_GFIX;
      if FNBError=0 then Etape_Nettoyage_Domaines;
      if FNBError=0 then Etape_Index;
      if FNBError=0 then Etape_procedure;
      if FNBError=0 then Etape_Triggers;
      if FNBError=0 then Etape_Grant;
      if FNBError=0 then Etape_Repose_Contrainte;
      if FNBError=0 then Etape_PhotoMetadata_Destination;
      if FNBError=0 then Etape_Compte_Records;
      if FNBError=0 then Etape_CopyFinale;
      if FNBError=0 then Etape_BackupRestoreGinkoia;
    finally
      if FNBError=0 then
          begin
            //
          end;

    end;
end;


procedure TTraitementThread.UpdateVCL();
begin
//    if Form2.Assigned then
//      begin
        Form2.StatusBar1.Panels[0].text:=FStatus;
        Form2.StatusBar1.Refresh;

        Form2.ProgressBar.Position:=FProgression;
        Form2.ProgressBar.Refresh;
//      end;
end;

procedure TTraitementThread.Etape_GFIX;
var Chaine:string;
    mError:string;
    a,b,c,d:cardinal;
begin
    try
      try
        FProgression:=5;
        FStatus:='GFIX en cours... ';
        Synchronize(UpdateVCL);
        chaine := Format('-shut -force 3 -user SYSDBA -password masterkey %s',[FRES_IB]);
        a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

        chaine := Format('-buffers 131072 -user SYSDBA -password masterkey  %s',[FRES_IB]);
        b:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

        chaine := Format('-sweep -user SYSDBA -password masterkey  %s',[FRES_IB]);
        c:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

        chaine := Format('-validate -user SYSDBA -password masterkey  %s',[FRES_IB]);
        d:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);
        FStatus := 'GFIX : [OK]';
        FProgression:=6;
      Except On E:Exception do
        begin
          FStatus := 'GFIX : [ERREUR] : ' + E.Message;
        end;
      end;
    finally
      Synchronize(UpdateVCL);
    end;
end;



procedure TTraitementThread.Etape_Restore;
var FDIBRestore:TFDIBRestore;
begin
    FDIBRestore:=TFDIBRestore.Create(nil);
    try
      try
        FProgression:=4;
        FStatus:='Restore en cours...';
        Synchronize(updateVCL);
        DeleteFile(FRES_IB);
        FDIBRestore.DriverLink :=  Form2.FDPhysIBDriverLink1;
        FDIBRestore.Options  := [roDeactivateIdx,roCreate,roValidate];
        FDIBRestore.Verbose  := true;
        FDIBRestore.UserName := 'SYSDBA';
        FDIBRestore.Password := 'masterkey';
        FDIBRestore.Host     := 'localhost';
        FDIBRestore.Protocol := ipTCPIP;
        FDIBRestore.Database := FRES_IB;
        FDIBRestore.BackupFiles.Add(FSAV_GBK);
        FDIBRestore.Restore;
        FStatus:='Restore : [OK]';
        Synchronize(updateVCL);
        FProgression:=5;
        Except On E:Exception
             do
              begin
                   // StatusBar1.Panels[0].text:=E.Message;
                   if Pos('cannot be used in the specified plan',E.Message)>1
                      then FStatus:='Restore : [OK] : INFO/MESSAGE PLAN NORMAL'
                      else FStatus:='Restore : [ERREUR] : ' + E.Message;
              end;
          end;
   finally
     FDIBRestore.Free;
     Synchronize(updateVCL);
   end;
end;


procedure TTraitementThread.Etape_Backup;
var FDIBBackup:TFDIBBackup;
begin
    FDIBBackup:=TFDIBBackup.Create(nil);
    try
      try
      FProgression:=3;
      DeleteFile(FSAV_GBK);
      FConOrigine.Params.Database := FCOPY_IB;
      FStatus:='Backup en cours...';
      Synchronize(UpdateVCL);
      FDIBBackup.DriverLink := Form2.FDPhysIBDriverLink1;
      FDIBBackup.UserName := 'sysdba';
      FDIBBackup.Password := 'masterkey';
      FDIBBackup.Host := 'localhost';
      FDIBBackup.Protocol := ipTCPIP;
      FDIBBackup.Database := FCOPY_IB;
      FDIBBackup.BackupFiles.Add(FSAV_GBK);
      FDIBBackup.Backup;
      FStatus:='Backup : [OK]';
      Synchronize(UpdateVCL);
      FProgression:=4;
      Except ON
        E:Exception do
           FStatus:='Backup : [ERREUR] : ' + E.Message;
      end;
     finally
      FDIBBackup.Free;
      Synchronize(UpdateVCL);
     end;
end;

procedure TTraitementThread.Etape_BackupRestoreGinkoia;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        FProgression:=14;
        try
          FStatus:='Lancement du Backup Restore traditionnel de Ginkoia...';
          Synchronize(UpdateVCL);
          chaine := 'AUTO';
          a:=ExecAndWaitProcess(merror, FPathDirGinkoia + 'BackRest.exe', chaine);
          FProgression:=15;
          FStatus:='Terminé : Tout semble correcte';
        Except
          //
        end;
     finally
          Synchronize(UpdateVCL);
     end;
end;



procedure TTraitementThread.Etape_CopyFinale;
// var  chaine:string;
//    merror:string;
//    a:cardinal;
begin
     try
        FProgression:=0;
        try
          FStatus:=Format('Suppression du fichier %s',[FCOPY_IB]);
          Synchronize(UpdateVCL);
          DeleteFile(FCOPY_IB);
          FStatus:=Format('Suppression du fichier %s',[FSAV_GBK]);
          Synchronize(UpdateVCL);
          DeleteFile(FSAV_GBK);

          // en cas de grois problème : seulement .old.sav est valable !
          // -------------------
          Deletefile(FORIGINE_IB+'.old.sav');
          //--------------------
          FStatus:=Format('Renommage du fichier d''origine %s en %s.old.sav',[FORIGINE_IB,FORIGINE_IB]);
          Synchronize(UpdateVCL);
          If not(RenameFile(FORIGINE_IB,FORIGINE_IB + '.old.sav')) then
            begin
               inc(FnbError);
               exit;
               raise Exception.Create('Erreur : '+FStatus);
            end;

          FStatus:=Format('Renommage du fichier %s en %s',[FRES_IB,FORIGINE_IB]);
          Synchronize(UpdateVCL);
          If not(RenameFile(FRES_IB,FORIGINE_IB)) then
            begin
               inc(FnbError);
               exit;
               raise Exception.Create('Erreur : '+FStatus);
            end;
          FProgression:=14;
        Except On E:Exception do
          begin
            FStatus:='Erreur dans le Nettoyage et copies Finales : [ERREUR] ' + E.Message;
          end;
        end;
     finally
      Synchronize(UpdateVCL);
     end;
end;

procedure TTraitementThread.Etape_ShutDown_Copy;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        FProgression:=0;
        try
          FStatus:='Arrêt de la base...';
          Synchronize(UpdateVCL);
          DeleteFile(FCOPY_IB);
          // ----
          chaine := Format('-shut -force 3 -user SYSDBA -password masterkey %s',[FORIGINE_IB]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);
          FStatus:='Copie de la base...';
          CopyFile(PChar(FORIGINE_IB), PChar(FCOPY_IB), False);
          FSTATUS:='Arrêt de la base et Copie de la base : [OK]';
          FProgression:=1;
        Except On E:Exception do
          begin
            FStatus:='Arrêt de la base et Copie de la base : [ERREUR] ' + E.Message;
            inc(FnbError);
          end;
        end;
     finally
      Synchronize(UpdateVCL);
     end;
end;

procedure TTraitementThread.Etape_PhotoMetadata_Destination;
var chaine,mError:string;
    a:cardinal;
    FileName:string;
begin
   try
      try
        FProgression:=11;
        FStatus:='Photographie du metadata en cours...';
        Synchronize(UpdateVCL);
        FileName:= FRES_IB + '.meta.sql';
        DeleteFile(FileName);
        chaine := Format(' %s -o %s -x -u SYSDBA -p masterkey',[FRES_IB,FileName]);
        a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\isql', chaine);
        FStatus:='Photographuie du Metadata : [OK]';
        FProgression:=12;
        Synchronize(UpdateVCL);
        Except On E:Exception
          do
            begin
                inc(FnbError);
                FStatus:='Photographie du metadata : [ERREUR]';
            end;
        end;
   finally
      Synchronize(UpdateVCL);
   end;
end;


procedure TTraitementThread.Etape_PhotoMetadata_Origine;
var chaine,mError:string;
    a:cardinal;
    FileName:string;
begin
   try
      try
        FProgression:=1;
        FStatus:='Photographie du metadata en cours...';
        FileName:= FCOPY_IB + '.meta.sql';
        Synchronize(UpdateVCL);
        DeleteFile(FileName);
        chaine := Format(' %s -o %s -x -u SYSDBA -p masterkey',[FCOPY_IB,FileName]);
        a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\isql', chaine);
        FStatus:='Photographuie du Metadata : [OK]';
        FProgression:=2;
        Synchronize(UpdateVCL);
        Except On E:Exception
          do
            begin
                inc(FnbError);
                FStatus:='Photographie du metadata : [ERREUR]';
            end;
        end;
   finally
      Synchronize(UpdateVCL);
   end;
end;

procedure TTraitementThread.Etape_Drop_Constraint;
var FQuery:TFDQuery;
    aCONST:TStringList;
    i:integer;
begin
    FQuery:=TFDQuery.Create(nil);
    try
      FProgression:=2;
      FStatus:='Suppression contrainte en cours...';
      Synchronize(UpdateVCL);
      aCONST:=TStringList.Create;
      FConorigine.Params.Database := FCOPY_IB;
      FQuery.Connection:=FConorigine;
      try
         FQuery.SQL.Clear;
         FQuery.SQL.Add('SELECT RDB$CONSTRAINT_NAME AS CONSTRAINT_NAME FROM RDB$RELATION_CONSTRAINTS WHERE RDB$CONSTRAINT_TYPE=''CHECK'' AND RDB$RELATION_NAME=''TMPBACKUPRESTORE'' ');
         FQuery.open;
         while Not(FQuery.eof) do
            begin
               aCONST.Add(Format('ALTER TABLE TMPBACKUPRESTORE DROP CONSTRAINT %s',[FQuery.FieldByName('CONSTRAINT_NAME').Asstring]));
               FQuery.Next;
            end;
        FQuery.Close;
        for i:= 0 to aCONST.Count - 1 do
            begin
                FQuery.SQL.Clear;
                FQuery.SQL.Add(aCONST[i]);
                FQuery.ExecSQL;
            end;
        FQuery.Connection.Close();
        FStatus:='Suppression contrainte : [OK]';
        FProgression:=3;
       Except On E:Exception do
        begin
            FStatus:='Suppression contrainte : [ERREUR]';
            inc(FnbError);
        end;
      end;
    finally
     Synchronize(UpdateVCL);
     FQuery.Close;
     FQuery.Free;
    end;
end;

function TTraitementThread.EscapeProcName(AProcName:string):string;
begin
     if UpperCase(AProcName)=AProcName
      then result:=AProcName
      else result:=Format('"%s"',[AProcName]);
end;

function TTraitementThread.Alter_All_Procedure():Boolean;
var All_Proc:TStringList;
    i:integer;
begin
     All_Proc:=Get_All_Procedure();
        try
            if (EveryBody_Disconnected(FConDestination)) then
                begin
                     result:=True;
                     for i:= 0 to All_Proc.Count - 1 do
                        begin
                             result:=result and AlterProcedure(Trim(All_Proc.Strings[i]));
                        end;
                end
            else
                begin
                     result:=false;
                end;
        finally
             All_Proc.Free;
        end;
end;

function TTraitementThread.Grant_procedures():TStringList;
Var FQuery:TFDQuery;
begin
    result:=TStringList.Create;
    result.Clear;
    FQuery:=TFDQuery.Create(nil);
    try
        FQuery.Connection:=FConOrigine;
        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT RDB$USER,          ');
        FQuery.SQL.Add(' CASE RDB$PRIVILEGE       ');
        FQuery.SQL.Add('   WHEN ''X'' THEN ''1''  ');
        FQuery.SQL.Add('   END AS priv,           ');
        FQuery.SQL.Add('   RDB$RELATION_NAME      ');
        FQuery.SQL.Add(' FROM RDB$USER_PRIVILEGES WHERE RDB$OBJECT_TYPE=5 AND RDB$RELATION_NAME NOT LIKE ''%$%'' AND RDB$USER NOT IN (''SYSDBA'',''SYSDSO'')');
        FQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME, RDB$USER, RDB$PRIVILEGE ');
        FQuery.open;
        While not(FQuery.eof) do
           begin
               result.Add(Format('GRANT EXECUTE ON PROCEDURE %s TO %s',[FQuery.FieldByName('RDB$RELATION_NAME').asstring,FQuery.FieldByName('RDB$USER').asstring]));
               FQuery.Next;
           end;
    finally
        FQuery.Close;
        FQuery.Free;
    end;
end;



function TTraitementThread.Grant_TABLES():TStringList;
Var FQuery:TFDQuery;
    temp:string;
//    changement : boolean;
    mUSER:string;
    mTable:string;
    First:boolean;
//    MyCar:string;
begin
    result:=TStringList.Create;
    result.Clear;
    FQuery:=TFDQuery.Create(nil);
    try
        FQuery.Connection:=FConorigine;
        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT DISTINCT RDB$USER, ');
        FQuery.SQL.Add(' CASE RDB$PRIVILEGE       ');
        FQuery.SQL.Add('   WHEN ''D'' THEN ''1''  ');
        FQuery.SQL.Add('   WHEN ''I'' THEN ''2''  ');
        FQuery.SQL.Add('   WHEN ''R'' THEN ''3''  ');
        FQuery.SQL.Add('   WHEN ''S'' THEN ''4''  ');
        FQuery.SQL.Add('   WHEN ''U'' THEN ''5''  ');
        FQuery.SQL.Add('   WHEN ''T'' THEN ''6''  ');
        FQuery.SQL.Add('   END AS priv,           ');
        FQuery.SQL.Add('   RDB$RELATION_NAME      ');
        FQuery.SQL.Add(' FROM RDB$USER_PRIVILEGES WHERE (RDB$OBJECT_TYPE=0 AND RDB$RELATION_NAME NOT LIKE ''%$%'' AND RDB$USER NOT IN (''SYSDBA'',''SYSDSO'')) OR (RDB$OBJECT_TYPE=0  AND RDB$GRANTOR=''SYSDBA'' AND RDB$USER=''PUBLIC'') ');
        FQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME, RDB$USER, RDB$PRIVILEGE ');
        FQuery.open;
        temp:='';
        mUSER:='';
        mTable:='';
        First:=true;
        While not(FQuery.eof) do
           begin
               if not(First) and ( (mTable<>FQuery.FieldByName('RDB$RELATION_NAME').asstring)
                                 or  (mUSER<>FQuery.FieldByName('RDB$USER').asstring))
                  then
                      begin
                          // Effacement du dernier ","
                          temp:=Copy(temp,1,Length(temp)-1);
                          result.Add(Format('GRANT %s ON %s TO %s',[temp,mTable,mUser]));
                          temp:='';
                      end;
               case FQuery.FieldByName('priv').asinteger of
                  1:temp:=temp +'DELETE,';
                  2:temp:=temp +'INSERT,';
                  3:temp:=temp +'REFERENCES,';
                  4:temp:=temp +'SELECT,';
                  5:temp:=temp +'UPDATE,';
                  6:temp:=temp +'DECRYPT,';
                  else //
               end;
               mTable:=FQuery.FieldByName('RDB$RELATION_NAME').asstring;
               mUSER:=FQuery.FieldByName('RDB$USER').asstring;
               First:=false;
               FQuery.Next;
           end;
          // Effacement du dernier ","
          temp:=Copy(temp,1,Length(temp)-1);
          result.Add(Format('GRANT %s ON %s TO %s',[temp,mTable,mUser]));
    finally
        // result.SaveToFile('D:\grant.sql');
        FQuery.Close;
        FQuery.Free;
    end;
end;



function TTraitementThread.Get_All_Trigger():TStringList;
Var FQuery:TFDQuery;
begin
    result:=TStringList.Create;
    result.Clear;
    FQuery:=TFDQuery.Create(nil);
    try
        FQuery.Connection:=FConOrigine;
        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT RDB$TRIGGER_NAME AS trigger_name FROM RDB$TRIGGERS WHERE RDB$SYSTEM_FLAG=0 AND RDB$TRIGGER_NAME NOT LIKE ''CHECK%'' ORDER BY RDB$TRIGGER_NAME');
        FQuery.open;
        While not(FQuery.eof) do
           begin
               result.Add(FQuery.Fields[0].asstring);
               FQuery.Next;
           end;
    finally
        FQuery.Close;
        FQuery.Free;
    end;
end;

function TTraitementThread.Create_All_Trigger():Boolean;
var All_Trig:TStringList;
    i:integer;
begin
     All_Trig:=Get_All_Trigger();
        try
            if (EveryBody_Disconnected(FConDestination)) then
                begin
                     result:=True;
                     for i:= 0 to All_Trig.Count - 1 do
                        begin
                             result:=result and Create_Trigger(Trim(All_Trig.Strings[i]));
                        end;
                end
            else
                begin
                     result:=false;
                end;
        finally
             All_Trig.Free;
        end;
end;

function TTraitementThread.Create_All_Procedure():Boolean;
var All_Proc:TStringList;
    i:integer;
begin
     All_Proc:=Get_All_Procedure();
        try
            if (EveryBody_Disconnected(FConDestination)) then
                begin
                     result:=True;
                     for i:= 0 to All_Proc.Count - 1 do
                        begin
                             result:=result and CreateProcedure(Trim(All_Proc.Strings[i]));
                        end;
                end
            else
                begin
                     result:=false;
                end;
        finally
             All_Proc.Free;
        end;
end;

function TTraitementThread.Create_Trigger(ATrig:string):boolean;
var FQuery:TFDQuery;
    body       : TStrings;
//    ms: TMemoryStream;         // Permet de charger le Body avec un BlobField
//    i:integer;
    script     : TStrings;
begin
   result:=true;
   script := TStringList.Create;
   body   := TStringList.Create;
   FQuery:=TFDQuery.Create(nil);
   FQuery.Connection:=FConORIGINE;
   try
       FQuery.Close;
       FQuery.SQL.Clear;
       FQuery.SQL.Add('SELECT RDB$TRIGGER_NAME AS trigger_name, ');
       FQuery.SQL.Add('       RDB$RELATION_NAME AS table_name, ');
       FQuery.SQL.Add('       RDB$TRIGGER_SOURCE AS trigger_body, ');
       FQuery.SQL.Add('       CASE RDB$TRIGGER_TYPE ');
       FQuery.SQL.Add('        WHEN 1 THEN ''BEFORE'' ');
       FQuery.SQL.Add('        WHEN 2 THEN ''AFTER'' ');
       FQuery.SQL.Add('        WHEN 3 THEN ''BEFORE'' ');
       FQuery.SQL.Add('        WHEN 4 THEN ''AFTER'' ');
       FQuery.SQL.Add('        WHEN 5 THEN ''BEFORE'' ');
       FQuery.SQL.Add('        WHEN 6 THEN ''AFTER'' ');
       FQuery.SQL.Add('       END AS trigger_type, ');
       FQuery.SQL.Add('       CASE RDB$TRIGGER_TYPE ');
       FQuery.SQL.Add('        WHEN 1 THEN ''INSERT''   ');
       FQuery.SQL.Add('        WHEN 2 THEN ''INSERT''   ');
       FQuery.SQL.Add('        WHEN 3 THEN ''UPDATE''   ');
       FQuery.SQL.Add('        WHEN 4 THEN ''UPDATE''   ');
       FQuery.SQL.Add('        WHEN 5 THEN ''DELETE''   ');
       FQuery.SQL.Add('        WHEN 6 THEN ''DELETE''   ');
       FQuery.SQL.Add('       END AS trigger_event,     ');
       FQuery.SQL.Add('       CASE RDB$TRIGGER_INACTIVE ');
       FQuery.SQL.Add('        WHEN 1 THEN 0 ELSE 1     ');
       FQuery.SQL.Add('       END AS trigger_enabled,   ');
       FQuery.SQL.Add('       RDB$TRIGGER_SEQUENCE as trigger_position, ');
       FQuery.SQL.Add('       RDB$DESCRIPTION AS trigger_comment');
       FQuery.SQL.Add('  FROM RDB$TRIGGERS');
       FQuery.SQL.Add(Format(' WHERE UPPER(RDB$TRIGGER_NAME)=''%s''',[UpperCase(ATrig)]));
       FQuery.Open;
       body.Text:=FQuery.FieldByName('trigger_body').asstring;
//     TBlobField(FQuery.FieldByName('trigger_body')).SaveToStream(ms);
//     ms.Position := 0;
//     Le body contient le corps de la procedure
//     body.LoadFromStream(ms);

       Script.Add(Format('CREATE TRIGGER %s FOR %s',[EscapeProcName(Trim(ATrig)),FQuery.FieldByName('TABLE_NAME').asstring]));
       Script.Add(Format('ACTIVE %s %s POSITION %d',[FQuery.FieldByName('trigger_type').asstring,FQuery.FieldByName('trigger_event').asstring,FQuery.FieldByName('trigger_position').asinteger]));
       FQuery.Connection.Close();

       FQuery.Close;
       FQuery.Connection:=FConDestination;
       FQuery.Connection.open();
       FQuery.close;
       FQuery.SQL.Clear;
       FQuery.SQL.Add(Script.Text);
       body.Text:=StringReplace(body.Text,'!','!!',[rfReplaceAll]);
       FQuery.SQL.Add(body.Text);
       // -- FQuery.SQL.SaveToFile(Format('c:\temp\TRIGGER_%s.sql',[Trim(ATrig)]));
       try
          FQuery.ExecSQL;
        Except On E:Exception
          do
          begin
             result:=false;
             MessageDlg(Trim(ATrig)+#10+'ClassName'+E.ClassName+#10+'Message'+E.Message, mtWarning, [mbOK], 0);
          end;
       End;
    finally
     body.Free;
     Script.Free;
     FQuery.Close;
     FQuery.Free;
    end;

end;


function TTraitementThread.CreateProcedure(AProc:string):Boolean;
Var FQuery     : TFDQuery;     // Requete
    script     : TStrings;     // Texte du script
    body       : TStrings;     // Corps de la procedure
    params_in  : TStrings;     // Les Parametres IN
    params_out : TStrings;     // Les Parametres OUT (Returns)
    ms: TMemoryStream;         // Permet de charger le Body avec un BlobField
    i:integer;
begin
   result:=true;
   FQuery:=TFDQuery.Create(nil);
   FQuery.Connection:=FConORIGINE;

   script := TStringList.Create;
   body   := TStringList.Create;
   params_in := TStringList.Create;
   params_out := TStringList.Create;
   ms := TMemoryStream.Create;
   try
       FQuery.Close;
       FQuery.SQL.Clear;
       FQuery.SQL.Add('select RDB$PROCEDURE_NAME AS PROC_NAME, rdb$procedure_source  AS BODY ');
       FQuery.SQL.Add(' FROM RDB$PROCEDURES ');
       FQuery.SQL.Add(Format(' WHERE RDB$PROCEDURE_NAME=''%s''',[AProc]));
       FQuery.Open;
       // Le body contient le corps de la procedure
       // pas besoin pour le create
       // TBlobField(FQuery.FieldByName('BODY')).SaveToStream(ms);
       // ms.Position := 0;
       //  body.LoadFromStream(ms);
        try
           //---------------
           FQuery.close;
           FQuery.SQL.Clear;
           FQuery.SQL.Add('select C.rdb$parameter_number,');
           FQuery.SQL.Add(' rdb$parameter_name, rdb$parameter_type, F.rdb$field_type, ');
           FQuery.SQL.Add('  CASE F.RDB$FIELD_TYPE ');
           FQuery.SQL.Add('    WHEN 7 THEN ');
           FQuery.SQL.Add('      CASE F.RDB$FIELD_LENGTH ');
           FQuery.SQL.Add('        WHEN 2 THEN ''SMALLINT'' ');
           FQuery.SQL.Add('      END ');
           FQuery.SQL.Add('    WHEN 8 THEN ');
           FQuery.SQL.Add('      CASE F.RDB$FIELD_SUB_TYPE ');
           FQuery.SQL.Add('        WHEN 0 THEN ''INTEGER'' ');
           FQuery.SQL.Add('        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('        WHEN 2 THEN ''DECIMAL(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('       ELSE ''INTEGER'' ');
           FQuery.SQL.Add('      END ');
           FQuery.SQL.Add('    WHEN 9 THEN ''QUAD'' ');
           FQuery.SQL.Add('    WHEN 10 THEN ''FLOAT'' ');
           FQuery.SQL.Add('    WHEN 12 THEN ''DATE'' ');
           FQuery.SQL.Add('    WHEN 13 THEN ''TIME'' ');
           FQuery.SQL.Add('    WHEN 14 THEN ''CHAR('' || CAST(F.RDB$FIELD_LENGTH AS VARCHAR(10))  || '')'' ');
           FQuery.SQL.Add('    WHEN 16 THEN ');
           FQuery.SQL.Add('      CASE F.RDB$FIELD_SUB_TYPE ');
           FQuery.SQL.Add('        WHEN 0 THEN ''BIGINT'' ');
           FQuery.SQL.Add('        WHEN 1 THEN ''NUMERIC('' || CAST(F.RDB$FIELD_PRECISION AS VARCHAR(10)) || '',''|| (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('        WHEN 2 THEN ''DECIMAL('' || CAST(F.RDB$FIELD_PRECISION AS VARCHAR(10)) || '',''|| (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('      END  ');
           FQuery.SQL.Add('    WHEN 17 THEN ''BOOLEAN'' ');
           FQuery.SQL.Add('    WHEN 27 THEN ''DOUBLE'' ');
           FQuery.SQL.Add('    WHEN 35 THEN ''TIMESTAMP'' ');
           FQuery.SQL.Add('    WHEN 37 THEN ''VARCHAR('' || (F.RDB$FIELD_LENGTH) || '')'' ');
           FQuery.SQL.Add('    WHEN 40 THEN ''CSTRING'' || (F.RDB$FIELD_LENGTH) || '')'' ');
           FQuery.SQL.Add('    WHEN 45 THEN ''BLOB_ID'' ');
           FQuery.SQL.Add('    WHEN 261 THEN ''BLOB SUB_TYPE '' || F.RDB$FIELD_SUB_TYPE ');
           FQuery.SQL.Add('    ELSE ''INCONNU '' ');
           FQuery.SQL.Add('  END FIELD_TYPE ');
           FQuery.SQL.Add(' from RDB$PROCEDURES B ');
           FQuery.SQL.Add(' LEFT JOIN RDB$PROCEDURE_PARAMETERS C ON (B.rdb$procedure_name=C.rdb$procedure_name) ');
           FQuery.SQL.Add(' JOIN RDB$FIELDS F ON F.rdb$field_name=C.rdb$field_source ' );
           FQuery.SQL.Add(Format('  WHERE B.RDB$PROCEDURE_NAME=''%s'' ',[AProc]));
           FQuery.SQL.Add(' ORDER BY C.rdb$parameter_type, C.rdb$parameter_number ');
           FQuery.open;
           while not(FQuery.eof) do
              begin
                   if FQuery.FieldByName('rdb$parameter_type').asinteger=0
                      then
                          params_in.Add(
                              Format(' "%s" %s',[
                                Trim(FQuery.FieldByName('rdb$parameter_name').asstring),
                                FQuery.FieldByName('FIELD_TYPE').asstring
                                     ])
                                );
                   if FQuery.FieldByName('rdb$parameter_type').asinteger=1
                      then
                          params_out.Add(
                              Format(' "%s" %s',[
                                Trim(FQuery.FieldByName('rdb$parameter_name').asstring),
                                FQuery.FieldByName('FIELD_TYPE').asstring
                                     ])
                                );
                   FQuery.Next;
              end;
           FQuery.Close;
           for I := 0 to params_in.Count - 1 do
              begin
                   if i<params_in.Count - 1 then
                       params_in.Strings[i]:=params_in.Strings[i] + ',';
                   if i=params_in.Count - 1  then
                       params_in.Strings[i]:=params_in.Strings[i] + ')';
              end;
           for I := 0 to params_out.Count - 1 do
              begin
                   if i<params_out.Count - 1 then
                       params_out.Strings[i]:=params_out.Strings[i] + ',';
                   if i=params_out.Count - 1  then
                       params_out.Strings[i]:=params_out.Strings[i] + ')';
              end;
          if params_in.Count>0 then
              begin
                   Script.Add(FORMAT('CREATE PROCEDURE %s(',[EscapeProcName(Trim(AProc))]));
                   Script.AddStrings(params_in);
              end
            else Script.Add(FORMAT('CREATE PROCEDURE %s',[EscapeProcName(Trim(AProc))]));
          if params_out.Count>0 then
              begin
                   Script.Add('returns (');
                   Script.AddStrings(params_out);
              end;
          Script.Add('AS');

          // FScriptSQL.SQLScripts.Add;
          // Si la procedure est vide : "body Vide" alors on ne recompile pas
          // Cela arrive lorsqu'on à Droppé la procedure entre le moment
          // ou on a stockée son nom et le moment ou on décide de la recompiler
//          if body.Count<>0 then
//              begin
                  FQuery.Close();
                  FQuery.Connection.Close();
                  FQuery.Connection:=FConDESTINATION;
                  FQuery.SQL.Clear;
                  FQuery.SQL.Add(Script.Text);
                  FQuery.SQL.Add('BEGIN EXIT; END;');
                  // FDQuery2.SQL.Add(body.Text);
                  // FDQuery2.SQL.SaveToFile(Format('c:\temp\CREATE_%s.sql',[Trim(AProc)]));
                  try
                     // Comme les " en nom de fichier Windows n'aime pas....
                     FQuery.ExecSQL;

                  // FScriptSQL.SQLScripts[0].SQL.Text:=Script.Text;
                  // FScriptSQL.SQLScripts[0].SQL.Add('BEGIN EXIT; END;');
                  // FScriptSQL.SQLScripts[0].SQL.Add(body)
//                  try
                     // Comme les " en nom de fichier Windows n'aime pas....
                     // FScriptSQL.SQLScripts[0].FScriptSQL.SQL.SaveToFile(Format('c:\temp\%s_recompile.sql',[Trim(AProc)]));
                     //FScriptSQL.ValidateAll;
                     // FScriptSQL.ExecuteAll;
                     // Application.ProcessMessages;
                     // FScriptSQL.Transaction.commit;
                     // FScriptSQL.Connection.Close();
                  Except
                     on E:Exception do
                        begin
                             result:=false;
                             // FScriptSQL.SQL.SaveToFile(Format('c:\temp\%s_recompile.sql',[Trim(AProc)]));
                              MessageDlg(Trim(AProc)+#10+'ClassName'+E.ClassName+#10+
                                    'Message'+E.Message, mtWarning, [mbOK], 0);
                        end;
                  end;
             // end;
        finally
          //--------------
        end;
     //-------------------
     finally
        params_in.Free;
        params_out.Free;
        body.free;
        ms.free;
        Script.Free;
        FQuery.Close;
        FQuery.Free;
     end;
end;

function TTraitementThread.AlterProcedure(AProc:string):Boolean;
Var FQuery     : TFDQuery;     // Requete
    script     : TStrings;     // Texte du script
    body       : TStrings;     // Corps de la procedure
    params_in  : TStrings;     // Les Parametres IN
    params_out : TStrings;     // Les Parametres OUT (Returns)
    ms: TMemoryStream;         // Permet de charger le Body avec un BlobField
    i:integer;
begin
   FQuery:=TFDQuery.Create(nil);
   script := TStringList.Create;
   body   := TStringList.Create;
   params_in := TStringList.Create;
   params_out := TStringList.Create;
   ms := TMemoryStream.Create;

   try
     result:=true;
     FQuery.Connection:=FConORIGINE;
     FQuery.Connection.open();
  // FQuery.Transaction:=ATransaction;

     FQuery.Close;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('select RDB$PROCEDURE_NAME AS PROC_NAME, rdb$procedure_source  AS BODY ');
     FQuery.SQL.Add(' FROM RDB$PROCEDURES ');
     FQuery.SQL.Add(Format(' WHERE RDB$PROCEDURE_NAME=''%s''',[AProc]));
     FQuery.Open;
     TBlobField(FQuery.FieldByName('BODY')).SaveToStream(ms);
     ms.Position := 1;
       // Le body contient le corps de la procedure
       body.LoadFromStream(ms);
       try
           //---------------
           FQuery.close;
           FQuery.SQL.Clear;
           FQuery.SQL.Add('select C.rdb$parameter_number,');
           FQuery.SQL.Add(' rdb$parameter_name, rdb$parameter_type, F.rdb$field_type, ');
           FQuery.SQL.Add('  CASE F.RDB$FIELD_TYPE ');
           FQuery.SQL.Add('    WHEN 7 THEN ');
           FQuery.SQL.Add('      CASE F.RDB$FIELD_LENGTH ');
           FQuery.SQL.Add('        WHEN 2 THEN ''SMALLINT'' ');
           FQuery.SQL.Add('      END ');
           FQuery.SQL.Add('    WHEN 8 THEN ');
           FQuery.SQL.Add('      CASE F.RDB$FIELD_SUB_TYPE ');
           FQuery.SQL.Add('        WHEN 0 THEN ''INTEGER'' ');
           FQuery.SQL.Add('        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('        WHEN 2 THEN ''DECIMAL(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('       ELSE ''INTEGER'' ');
           FQuery.SQL.Add('      END ');
           FQuery.SQL.Add('    WHEN 9 THEN ''QUAD'' ');
           FQuery.SQL.Add('    WHEN 10 THEN ''FLOAT'' ');
           FQuery.SQL.Add('    WHEN 12 THEN ''DATE'' ');
           FQuery.SQL.Add('    WHEN 13 THEN ''TIME'' ');
           FQuery.SQL.Add('    WHEN 14 THEN ''CHAR('' || CAST(F.RDB$FIELD_LENGTH AS VARCHAR(10))  || '')'' ');
           FQuery.SQL.Add('    WHEN 16 THEN ');
           FQuery.SQL.Add('      CASE F.RDB$FIELD_SUB_TYPE ');
           FQuery.SQL.Add('        WHEN 0 THEN ''BIGINT'' ');
           FQuery.SQL.Add('        WHEN 1 THEN ''NUMERIC('' || CAST(F.RDB$FIELD_PRECISION AS VARCHAR(10)) || '',''|| (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('        WHEN 2 THEN ''DECIMAL('' || CAST(F.RDB$FIELD_PRECISION AS VARCHAR(10)) || '',''|| (-F.RDB$FIELD_SCALE) || '')'' ');
           FQuery.SQL.Add('      END  ');
           FQuery.SQL.Add('    WHEN 17 THEN ''BOOLEAN'' ');
           FQuery.SQL.Add('    WHEN 27 THEN ''DOUBLE'' ');
           FQuery.SQL.Add('    WHEN 35 THEN ''TIMESTAMP'' ');
           FQuery.SQL.Add('    WHEN 37 THEN ''VARCHAR('' || (F.RDB$FIELD_LENGTH) || '')'' ');
           FQuery.SQL.Add('    WHEN 40 THEN ''CSTRING'' || (F.RDB$FIELD_LENGTH) || '')'' ');
           FQuery.SQL.Add('    WHEN 45 THEN ''BLOB_ID'' ');
           FQuery.SQL.Add('    WHEN 261 THEN ''BLOB SUB_TYPE '' || F.RDB$FIELD_SUB_TYPE ');
           FQuery.SQL.Add('    ELSE ''INCONNU '' ');
           FQuery.SQL.Add('  END FIELD_TYPE ');
           FQuery.SQL.Add(' from RDB$PROCEDURES B ');
           FQuery.SQL.Add(' LEFT JOIN RDB$PROCEDURE_PARAMETERS C ON (B.rdb$procedure_name=C.rdb$procedure_name) ');
           FQuery.SQL.Add(' JOIN RDB$FIELDS F ON F.rdb$field_name=C.rdb$field_source ' );
           FQuery.SQL.Add(Format('  WHERE B.RDB$PROCEDURE_NAME=''%s'' ',[AProc]));
           FQuery.SQL.Add(' ORDER BY C.rdb$parameter_type, C.rdb$parameter_number ');
           FQuery.open;
           while not(FQuery.eof) do
              begin
                   if FQuery.FieldByName('rdb$parameter_type').asinteger=0
                      then
                          params_in.Add(
                              Format(' "%s" %s',[
                                Trim(FQuery.FieldByName('rdb$parameter_name').asstring),
                                FQuery.FieldByName('FIELD_TYPE').asstring
                                     ])
                                );
                   if FQuery.FieldByName('rdb$parameter_type').asinteger=1
                      then
                          params_out.Add(
                              Format(' "%s" %s',[
                                Trim(FQuery.FieldByName('rdb$parameter_name').asstring),
                                FQuery.FieldByName('FIELD_TYPE').asstring
                                     ])
                                );
                   FQuery.Next;
              end;
           FQuery.Close;
           for I := 0 to params_in.Count - 1 do
              begin
                   if i<params_in.Count - 1 then
                       params_in.Strings[i]:=params_in.Strings[i] + ',';
                   if i=params_in.Count - 1  then
                       params_in.Strings[i]:=params_in.Strings[i] + ')';
              end;
           for I := 0 to params_out.Count - 1 do
              begin
                   if i<params_out.Count - 1 then
                       params_out.Strings[i]:=params_out.Strings[i] + ',';
                   if i=params_out.Count - 1  then
                       params_out.Strings[i]:=params_out.Strings[i] + ')';
              end;
          if params_in.Count>0 then
              begin
                   Script.Add(FORMAT('ALTER PROCEDURE %s(',[EscapeProcName(Trim(AProc))]));
                   Script.AddStrings(params_in);
              end
            else Script.Add(FORMAT('ALTER PROCEDURE %s',[EscapeProcName(Trim(AProc))]));
          if params_out.Count>0 then
              begin
                   Script.Add('returns (');
                   Script.AddStrings(params_out);
              end;
          Script.Add('AS');
          // Si la procedure est vide : "body Vide" alors on ne recompile pas
          // Cela arrive lorsqu'on à Droppé la procedure entre le moment
          // ou on a stockée son nom et le moment ou on décide de la recompiler
          if body.Count<>0 then
              begin
                  FQuery.Close();
                  FQuery.Connection.Close();
                  FQuery.Connection:=FConDestination;
                  FQuery.SQL.Clear;
                  FQuery.SQL.Add(Script.Text);
//                  body.Text:=StringReplace(body.Text,'\''','/\''',[rfReplaceAll]);
                  body.Text:=StringReplace(body.Text,'!','!!',[rfReplaceAll]);
                  // body.Text:=StringReplace(body.Text,'\''',#92+#92+'''',[rfReplaceAll]);
                  FQuery.SQL.Add(body.Text);
                  // FDQuery2.SQL.SaveToFile(Format('c:\temp\ALTER_%s.sql',[Trim(AProc)]));
                  try
                     // Comme les " en nom de fichier Windows n'aime pas....
                     // FDQuery2.SQL.Clear;
                     // FDQuery2.SQL.LoadFromFile(Format('c:\temp\ALTER_%s.sql',[Trim(AProc)]));
                     FQuery.ExecSQL;
                  Except
                     on E:Exception do
                        begin
                             result:=false;
                             // FScriptSQL.SQLScripts[0].SQL.SaveToFile(Format('c:\temp\%s_recompile.sql',[Trim(AProc)]));
                             MessageDlg(Trim(AProc)+#10+'ClassName'+E.ClassName+#10+
                                    'Message'+E.Message, mtWarning, [mbOK], 0);
                        end;
                  end;
              end;
        finally
          //--------------
        end;
     //-------------------
     finally
        params_in.Free;
        params_out.Free;
        body.free;
        ms.free;
        Script.Free;
        FQuery.Close;
        FQuery.Free;
     end;
end;

procedure TTraitementThread.Etape_Triggers;
begin
    try
      try
        FProgression:=8;
        FStatus:='Création des Triggers en cours...';
        Synchronize(UpdateVCL);
        Create_All_Trigger();
        FStatus:='Triggers : [OK]';
        FProgression :=9;
      Except ON
        E:Exception do
           FStatus:='Triggers : [ERREUR] : ' + E.Message;
      end;
    finally
        Synchronize(UpdateVCL);
    end;
end;


function TTraitementThread.Get_All_Procedure():TStringList;
Var FQuery:TFDQuery;
begin
    result:=TStringList.Create;
    result.Clear;
    FQuery:=TFDQuery.Create(nil);
    try
        FQuery.Connection:=FConOrigine;
        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT RDB$PROCEDURE_NAME AS PROC_NAME');
        FQuery.SQL.Add(' FROM  RDB$PROCEDURES ');
        FQuery.SQL.Add(' ORDER BY RDB$PROCEDURE_NAME ');
        FQuery.open;
        While not(FQuery.eof) do
           begin
               result.Add(FQuery.Fields[0].asstring);
               FQuery.Next;
           end;
    finally
        FQuery.Close;
        FQuery.Free;
    end;
end;

procedure TForm2.LockEcran(Enabled:boolean);
begin
    Form2.Enabled:=Enabled;
end;

procedure TForm2.MyTimerTimer(Sender: TObject);
var Top_Arrivee:TTimeStamp;
begin
    try
      Top_Arrivee:=DateTimeToTimeStamp(now);
    finally
      lbl_mytimer.Visible:=true;
      lbl_mytimer.Caption:=Sec2Time((Top_Arrivee.Time-Top_Depart.Time) div 1000);
    end;
end;

procedure TForm2.BTRIGGERSClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BTriggers.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Triggers;
    finally
       BTriggers.Enabled := A.FnbError<>0;
       BGrant.Enabled := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

function TForm2.Sec2Time(seconds:integer):string;
var hours,Mins,Secs:integer;
begin
    hours := floor(seconds / 3600);
    mins  :=  floor((seconds - (hours*3600)) / 60);
    secs   :=  floor(seconds mod 60);
    result:= Format('%d:%.2d:%.2d',[hours,mins,secs]);
    if hours=0
      then result:= Format('%.2d:%.2d',[mins,secs]);
end;

procedure TForm2.BAUTOClick(Sender: TObject);
begin
    If not(Precontrols) then exit;
    Top_Depart:=DateTimeToTimeStamp(now);
    MyTimer.Enabled:=true;
    FCanClose:=false;
    BAUTO.Enabled:=false;
    BSHUTORIGINE_0.Enabled:=false;
    teIBORIGINE_0.Enabled:=false;
    teIBORIGINE.Enabled:=false;
    teBCK.Enabled:=false;
    teIBINTER.Enabled:=false;
    MonThread:=TTraitementThread.Create(
              FDConnection1, FDConnection2,
              teIBORIGINE_0.Text,
              teIBORIGINE.Text,
              teBCK.text,
              teIBINTER.text,
              true,
              CallBackThread
              );
//    MonThread.Resume;
    MonThread.Start;
end;

function TForm2.GetFileSize(const APath: string): int64;
var
  Sr : TSearchRec;
begin
  if FindFirst(APath,faAnyFile,Sr)=0 then
  try
    Result := Int64(Sr.FindData.nFileSizeHigh) shl 32 + Sr.FindData.nFileSizeLow;
  finally
    FindClose(Sr);
  end
  else
    Result := 0;
end;


function TForm2.Precontrols():Boolean;
var space,fz:int64;
BEGIN
    result:=true;
    try
      space    := DiskFree(ord(teIBORIGINE_0.Text[1])-64) div 1024;
      fz       := GetFileSize(teIBORIGINE_0.text) div 1024;
      if space<4*fz then
        begin
           MessageDlg('Pas assez de place.',mtError,[mbOK],0);
           result:=FALSE;
           exit;
        end;

     if FileExists(teIBORIGINE.text) or
        FileExists(teBCK.text)       or
        FileExists(teIBINTER.text)   or
        FileExists(teIBORIGINE.text+'.old.sav')
        then
          begin
            If not(MessageDlg('Des fichiers du traitement existent déjà ils seront supprimés.'#13+#10+'Voulez-vous continuer ?',mtWarning, mbOKCancel, 0)= mrOK)
              then
                begin
                     result:=FALSE;
                end
          end;
    finally

    end;

END;

procedure TForm2.BBackupClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BBackup.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_backup;
    finally
       BBackup.Enabled := A.FnbError<>0;
       BRestore.Enabled := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;

{    BBackup.Enabled:=false;
    try
      try
      ProgressBar.Position:=3;
      DeleteFile(teBCK.Text);
      FDConnection1.Params.Database:=teIBORIGINE.Text;
      FDConnection2.Params.Database:=teIBINTER.Text;
      StatusBar1.Panels[0].text:='Backup en cours...';
      StatusBar1.Refresh;
      FDIBBackup1.DriverLink := FDPhysIBDriverLink1;
      FDIBBackup1.UserName := 'sysdba';
      FDIBBackup1.Password := 'masterkey';
      FDIBBackup1.Host := 'localhost';
      FDIBBackup1.Protocol := ipTCPIP;
      FDIBBackup1.Database := teIBORIGINE.Text;
      FDIBBackup1.BackupFiles.Add(teBCK.Text);
      FDIBBackup1.Backup;
      StatusBar1.Panels[0].text:='Backup : [OK]';
      isOk:=true;
      ProgressBar.Position:=4;
      Except ON
        E:Exception do
           StatusBar1.Panels[0].text:='Backup : [ERREUR] : ' + E.Message;
      end;
     finally
       BBackup.Enabled:=not(isOk);
       BRestore.Enabled:=isOk;
     end;
     }
end;

procedure TForm2.BBR_GINKOIAClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BBR_GINKOIA.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_BackupRestoreGinkoia
    finally
//       Bindex.Enabled := A.FnbError<>0;
//       BProcedure.Enabled := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

procedure TForm2.BIndexClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       Bindex.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_index
    finally
       Bindex.Enabled := A.FnbError<>0;
       BProcedure.Enabled := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;

   {try
      try
        ProgressBar.Position:=6;

        isOk:=false;
        BIndex.Enabled:=false;
        StatusBar1.Panels[0].Text:='Activation des Index en cours...';
        StatusBar1.Refresh;
        FDConnection1.Params.Database:=teIBORIGINE.Text;
        FDConnection2.Params.Database:=teIBINTER.Text;
        Create_Check_Constraints(FDConnection1,FDConnection2);
        Active_Index(FDConnection1,FDConnection2);
        StatusBar1.Panels[0].Text:='Activation des Index : [OK]';
        StatusBar1.Refresh;
        isOk:=true;
        ProgressBar.Position:=7;
      Except On E:Exception do
        begin
          StatusBar1.Panels[0].Text:='Activation des Index : [ERREUR]' + E.Message;
          isOk:=false;
        end;
      end;
   finally
      Bprocedure.Enabled:=isOk;
      BIndex.Enabled:=not(isOk);
   end;
   }
end;

procedure TForm2.BMETA_FINALClick(Sender: TObject);
var  A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BMETA_FINAL.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_PhotoMetadata_Destination;
    finally
       BMETA_FINAL.Enabled := A.FnbError<>0;
       BCTRL.Enabled       := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

procedure TForm2.BMETA_ORIGINEClick(Sender: TObject);
var  A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BMETA_ORIGINE.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_PhotoMetadata_Origine;
    finally
       BMETA_ORIGINE.Enabled := A.FnbError<>0;
       BTMPORIGINE.Enabled   := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;

{   try
      try
        ProgressBar.Position:=1;
        BMETA_ORIGINE.Enabled:=false;
        isOk:=true;
        StatusBar1.Panels[0].text:='Photographie du metadata en cours...';
        chaine := Format(' %s -o D:\meta_sav_origine.sql -x -u SYSDBA -p masterkey',[teIBORIGINE.text]);
        a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\isql', chaine);
        StatusBar1.Panels[0].text:='Photographuie du Metadata : [OK]';
        ProgressBar.Position:=2;
        Except On E:Exception
          do
            begin
                isOk:=false;
                StatusBar1.Panels[0].text:='Photographie du metadata : [ERREUR]';
                inc(inbError);
            end;
        end;
   finally
      BTMPORIGINE.Enabled:=isOk;
      BMETA_ORIGINE.Enabled:=not(isOk);
   end;
   }
end;

procedure TForm2.BCHOOSEIBClick(Sender: TObject);
var PDialog:TopenDialog;
begin
    PDialog:=TopenDialog.Create(nil);
    PDialog.InitialDir:='C:\Ginkoia\';
    try
       PDialog.Filter := 'Fichiers interbase (*.ib)|*.IB';
       if PDialog.Execute
         then
             begin
                 teIBORIGINE_0.Text := PDialog.FileName;
                 teIBORIGINE.text   := ExtractFilePath(teIBORIGINE_0.Text) + FormatDateTime('yyyy_mm_dd_',Now()) + 'SAV00.ib';
                 teBCK.text         := ExtractFilePath(teIBORIGINE_0.Text) + FormatDateTime('yyyy_mm_dd_',Now()) + 'SAV00.gbk';
                 teIBINTER.text     := ExtractFilePath(teIBORIGINE_0.Text) + FormatDateTime('yyyy_mm_dd_',Now()) + 'REST00.ib';
             end;
    finally
      PDialog.Free;
    end;
end;

procedure TForm2.BCLEANDOMAINClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BCleanDomain.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Nettoyage_Domaines;
    finally
       BCleanDomain.Enabled := A.FnbError<>0;
       Bindex.Enabled := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

procedure TForm2.BCOPYFINALClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BCOPYFINAL.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_CopyFinale;
    finally
       BBR_GINKOIA.Enabled := A.FnbError=0;
       // Pas de réactivation du Bouton en cas d'echec...
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

procedure TForm2.BCTRLClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BCTRL.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Compte_Records
    finally
       BCTRL.Enabled       := A.FnbError<>0;
       BCOPYFINAL.Enabled  := A.FnbError=0;
       if A.FnbError=0
          then
              begin
                  Label1.Font.Color:=$0000EE00;
                  Label1.Caption:='OK'
              end
          else
              begin
                  Label1.Caption:='ERREUR';
                  Label1.Font.Color:=$000000EE;
              end;
       FreeAndNil(A);
       FCanClose:=true;
    end;



 {   ProgressBar.Position:=12;
    BCTRL.Enabled:=False;
    StatusBar1.Panels[0].Text:='Contrôle du nombre d''enregistrements en cours...';
    StatusBar1.Refresh;
    mTB_ORIGINE:=TStringList.Create;
    mTB_RESTORE:=TStringList.Create;
    try
      try
       FDConnection1.Params.Database:=teIBORIGINE.Text;
       mTB_ORIGINE.Clear;
        sTables := List_tables(FDConnection1);
        Total:=0;
        try
           for i:= 0 to sTables.Count - 1 do
               begin
                  Nb := Count_Table(FDConnection1,sTables.Strings[i]);
                  mTB_ORIGINE.Add(Format('%s : %d',[sTables.Strings[i],Nb]));
                  Total:=Total+Nb;
                end;
          finally
            sTables.Free;
          end;
        FDConnection2.Params.Database:=teIBINTER.Text;

        Total:=0;
        mTB_RESTORE.Clear;
        sTables := List_tables(FDConnection2);
          try
             for i:= 0 to sTables.Count - 1 do
                 begin
                    Nb := Count_Table(FDConnection2,sTables.Strings[i]);
                    mTB_RESTORE.Add(Format('%s : %d',[sTables.Strings[i],Nb]));
                    Total:=Total+Nb;
                 end;
          finally
            sTables.Free;
          end;
       if mTB_RESTORE.Text=mTB_ORIGINE.Text
          then
              begin
                  Label1.Font.Color:=$0000EE00;
                  Label1.Caption:='OK'
              end
          else
              begin
                  Label1.Caption:='ERREUR';
                  Label1.Font.Color:=$000000EE;
              end;
        StatusBar1.Panels[0].Text:='Contrôle du nombre d''enregistrements : [OK]';
        ProgressBar.Position:=13;
      Except
        on E:Exception do
          begin
            StatusBar1.Panels[0].Text:='Contrôle du nombre d''enregistrements : [ERREUR]';
          end;
      end;
    finally
      mTB_ORIGINE.Free;
      mTB_RESTORE.Free;
    end;
    }
end;

procedure TForm2.BTMPORIGINEClick(Sender: TObject);
var // FQuery:TFDQuery;
    // aCONST:TStringList;
    // i:integer;
    A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BTMPORIGINE.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Drop_Constraint;
    finally
       BTMPORIGINE.Enabled := A.FnbError<>0;
       BBACKUP.Enabled     := A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;


{    try
      ProgressBar.Position:=2;
      BTMPORIGINE.Enabled:=false;
      aCONST:=TStringList.Create;
      FQuery:=TFDQuery.Create(nil);
      FDConnection1.Params.Database:=teIBORIGINE.Text;
      FQuery.Connection:=FDConnection1;
      try
         FQuery.SQL.Clear;
         FQuery.SQL.Add('SELECT RDB$CONSTRAINT_NAME AS CONSTRAINT_NAME FROM RDB$RELATION_CONSTRAINTS WHERE RDB$CONSTRAINT_TYPE=''CHECK'' AND RDB$RELATION_NAME=''TMPBACKUPRESTORE'' ');
         FQuery.open;
         while Not(FQuery.eof) do
            begin
               aCONST.Add(Format('ALTER TABLE TMPBACKUPRESTORE DROP CONSTRAINT %s',[FQuery.FieldByName('CONSTRAINT_NAME').Asstring]));
               FQuery.Next;
            end;
        FQuery.Close;
        for i:= 0 to aCONST.Count - 1 do
            begin
                FQuery.SQL.Clear;
                FQuery.SQL.Add(aCONST[i]);
                FQuery.ExecSQL;
            end;
       ProgressBar.Position:=3;
       Except On E:Exception do
        begin
            inc(inbError);
        end;
      end;
    finally
     BBackup.Enabled:=true;
     FQuery.Close;
     FQuery.Free;
    end;
    }
end;

procedure TForm2.BTMP2Click(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BTMP2.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Repose_Contrainte;
    finally
       BTMP2.Enabled:=A.FnbError<>0;
       BMETA_FINAL.Enabled:=A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

procedure TTraitementThread.Etape_Repose_Contrainte;
var FQuery:TFDQuery;
begin
    FQuery:=TFDQuery.Create(nil);
    FQuery.Connection:=FConDestination;
    try
      try
        FProgression:=10;
        FStatus:='Repose de la contrainte sur TMPBACKUPRESTORE en cours...';
        SynChronize(UpdateVCL);
        FQuery.SQL.Clear;
        FQuery.SQL.Add('ALTER TABLE TMPBACKUPRESTORE ADD CHECK (TBR_ID >= 0)');
        FQuery.ExecSQL;
        FQuery.SQL.Clear;
        FQuery.SQL.Add('ALTER TABLE TMPBACKUPRESTORE ADD CHECK (TBR_FIELDSCOUNT >= 0)' );
        FQuery.ExecSQL;
        FProgression:=11;
        FStatus:='Repose de la contrainte sur TMPBACKUPRESTORE : [OK]';
      Except on E:Exception do
        begin
            FStatus:='Repose de la contrainte sur TMPBACKUPRESTORE : [ERREUR]';
        end;
      end;
    finally
     SynChronize(UpdateVCL);
     FQuery.Close;
     FQuery.Free;
    end;
end;

procedure TForm2.BSHUTORIGINE_0Click(Sender: TObject);
var A:TTraitementThread;
begin
    If not(MessageDlg('Voulez-vous lancer le traitement en mode manuel ?',mtWarning, mbOKCancel, 0)= mrOK) then exit;
    If not(Precontrols) then exit;
    try
       FCanClose:=false;
       BAUTO.Enabled:=false;
       BSHUTORIGINE_0.Enabled:=false;

       teIBORIGINE_0.Enabled:=false;
       teIBORIGINE.Enabled:=false;
       teBCK.Enabled:=false;
       teIBINTER.Enabled:=false;

        A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_ShutDown_Copy;
    finally
       BSHUTORIGINE_0.Enabled:=A.FnbError<>0;
       BMETA_ORIGINE.Enabled:=A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
{
     try
        BSHUTORIGINE_0.Enabled:=false;
        teIBORIGINE_0.Enabled:=false;
        teIBORIGINE.Enabled:=false;
        teBCK.Enabled:=false;
        teIBINTER.Enabled:=false;
        ProgressBar.Position:=0;
        isOk:=false;
        try
          StatusBar1.Panels[0].text:='Arrêt de la base...';
          StatusBar1.Refresh;
          DeleteFile(teIBORIGINE.Text);
          ///
          chaine := Format('-shut -force 3 -user SYSDBA -password masterkey %s',[teIBORIGINE_0.Text]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);
          StatusBar1.Panels[0].text:='Copie de la base...';
          StatusBar1.Refresh;
          CopyFile(PChar(teIBORIGINE_0.Text), PChar(teIBORIGINE.Text), False);
          isOk:=true;
          StatusBar1.Panels[0].text:='Arrêt de la base et Copie de la base : [OK]';
          ProgressBar.Position:=1;
        Except On E:Exception do
          begin
            isOk:=false;
            StatusBar1.Panels[0].text:='Arrêt de la base et Copie de la base : [ERREUR] ' + E.Message;
            inc(inbError);
          end;
        end;
     finally
       BSHUTORIGINE_0.Enabled:=not(isOk);
       BMETA_ORIGINE.Enabled:=isOK;
       StatusBar1.Refresh;
     end;
     }
end;

procedure TForm2.BRestoreClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BRestore.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Restore;
    finally
       BRESTORE.Enabled:=A.FnbError<>0;
       BGFIX.Enabled:=A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;


{   try
    try
      ProgressBar.Position:=4;
      StatusBar1.Panels[0].text:='Restore en cours...';
      StatusBar1.Refresh;
      BRestore.Enabled:=false;
      DeleteFile(teIBINTER.Text);
      FDIBRestore1.DriverLink :=  FDPhysIBDriverLink1;
      FDIBRestore1.UserName := 'SYSDBA';
      FDIBRestore1.Password := 'masterkey';
      FDIBRestore1.Host     := 'localhost';
      FDIBRestore1.Protocol := ipTCPIP;
      FDIBRestore1.Database := teIBINTER.Text;
      FDIBRestore1.BackupFiles.Add(teBCK.Text);
      FDIBRestore1.Restore;
      StatusBar1.Panels[0].text:='Restore : [OK]';
      ProgressBar.Position:=5;
    Except On E:Exception
         do
          begin
               // StatusBar1.Panels[0].text:=E.Message;
               if Pos('cannot be used in the specified plan',E.Message)>1
                  then StatusBar1.Panels[0].text:='Restore : [OK] : INFO PLAN NORMAL]'
                  else StatusBar1.Panels[0].text:='Restore : [ERREUR] : ' + E.Message;
          end;
      end;
   finally
       StatusBar1.Refresh;
       BGFix.Enabled:=true;
   end;
   }
end;

procedure TForm2.BGRANTClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BGRANT.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_Grant;
    finally
       BGRANT.Enabled:=A.FnbError<>0;
       BTMP2.Enabled:=A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
{  try
    ProgressBar.Position:=9;
    BGRANT.Enabled:=false;
    Grant_All_Tables();
    ProgressBar.Position:=10;
  finally
    BTMP2.Enabled:=true;
  end;
  }
end;

procedure TForm2.BGFixClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BGFIX.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_GFIX;
    finally
       BGFIX.Enabled:=A.FnbError<>0;
       BCleanDomain.Enabled:=A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
end;

procedure TTraitementThread.Etape_Compte_Records;
var mTB_ORIGINE:TStringList;
    mTB_RESTORE:TStringList;
    sTables:TStrings;
    i:integer;
    Nb:integer;
begin
    mTB_ORIGINE:=TStringList.Create;
    mTB_RESTORE:=TStringList.Create;
    try
      try
        FProgression:=12;
        FStatus:='Contrôle du nombre d''enregistrements en cours...';
        mTB_ORIGINE.Clear;
        SynChronize(UpdateVCL);
        sTables := List_tables(FConOrigine);
        try
           for i:= 0 to sTables.Count - 1 do
               begin
                  Nb := Count_Table(FConOrigine,sTables.Strings[i]);
                  mTB_ORIGINE.Add(Format('%s : %d',[sTables.Strings[i],Nb]));
                end;
          finally
            sTables.Free;
          end;

        mTB_RESTORE.Clear;
        sTables := List_tables(FConDestination);
          try
             for i:= 0 to sTables.Count - 1 do
                 begin
                    Nb := Count_Table(FConDestination,sTables.Strings[i]);
                    mTB_RESTORE.Add(Format('%s : %d',[sTables.Strings[i],Nb]));
                 end;
          finally
            sTables.Free;
          end;
       if mTB_RESTORE.Text=mTB_ORIGINE.Text
          then
              begin
                  FProgression:=13;
                  FStatus:='Contrôle du nombre d''enregistrements : [OK]';
              end
          else
              begin
                  inc(FNbError);
                  FStatus:='Contrôle du nombre d''enregistrements : [ERREUR : il y a des différences]';
              end;
      Except on E:Exception
        do
        begin
           FStatus:='Contrôle du nombre d''enregistrements : [ERREUR] : ' + E.MEssage;
        end;
      end;
    finally
       FConOrigine.Close();
       FConDestination.Close;
       SynChronize(UpdateVCL);
    end;
end;


function TTraitementThread.Grant_All_Tables():boolean;
var All_Grant,All_Grant_Proc:TStringList;
    i:integer;
    FQuery:TFDQuery;
begin
     FQuery:=TFDQuery.Create(nil);
     FQuery.Connection:=FConDestination;
     All_Grant := Grant_tables();
     try
         if (EveryBody_Disconnected(FConDestination)) then
               begin
                   result:=True;
                   for i:= 0 to All_Grant.Count - 1 do
                        begin
                            FQuery.Close;
                            FQuery.SQL.Clear;
                            FQuery.SQL.Add(All_Grant.Strings[i]);
                            try
                               FQuery.ExecSQL;
                               Except
                            on E:Exception do
                                 begin
                                     result:=false;
                                     MessageDlg(Trim(All_Grant.Strings[i])+#10+'ClassName'+E.ClassName+#10+
                                          'Message'+E.Message, mtWarning, [mbOK], 0);
                                    exit;
                                end;
                              end;
                        end;
              end
         else
          begin
             result:=false;
          end;
        finally
           All_Grant.Free;
        end;
     All_Grant_Proc := Grant_Procedures();
     All_Grant_Proc.Add('REVOKE INSERT ON GENGESTIONCARTEFID FROM INIT;');
     All_Grant_Proc.Add('REVOKE INSERT ON GENGESTIONCLT FROM INIT;');
     All_Grant_Proc.Add('REVOKE INSERT ON GENGESTIONCLTCPT FROM INIT;');
     All_Grant_Proc.Add('REVOKE INSERT ON K FROM INIT;');
        try
            if (EveryBody_Disconnected(FConDestination)) then
                begin
                     result:=True;
                     for i:= 0 to All_Grant_Proc.Count - 1 do
                        begin
                            FQuery.Close;
                            FQuery.SQL.Clear;
                            FQuery.SQL.Add(All_Grant.Strings[i]);
                               try
                                 FQuery.ExecSQL;
                                  Except
                                on E:Exception do
                                   begin
                                       result:=false;
                                       MessageDlg(Trim(All_Grant_Proc.Strings[i])+#10+'ClassName'+E.ClassName+#10+
                                            'Message'+E.Message, mtWarning, [mbOK], 0);
                                      exit;
                                  end;
                              end;
                       end;
                end
            else result:=false;
        finally
           All_Grant_Proc.Free;
        end;

end;

function TTraitementThread.Count_Table(ACon:TFDConnection;ATable:string):integer;
var // chaine:string;
    FQuery:TFDQuery;
begin
    result:=0;
    FQuery:=TFDQuery.Create(nil);
    FQuery.Connection:=ACon;
    try
       FQuery.SQL.Clear;
       FQuery.SQL.Add(Format('SELECT COUNT(*) AS NB FROM %s ',[Atable]));
       FQuery.open;
       If Not(FQuery.eof) then
         result:=FQuery.FieldByName('NB').Asinteger;
    finally
     FQuery.Close;
     FQuery.Free;
    end;
end;


function TTraitementThread.EveryBody_Disconnected(ACon:TFDConnection):Boolean;
Var FQuery:TFDQuery;
    i:Integer;
begin
    result:=false;
    FQuery:=TFDQuery.Create(nil);
    try
        FQuery.Connection:=ACon;
        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT * FROM  TMP$ATTACHMENTS');
        FQuery.open;
        i:=0;
        While not(FQuery.eof) do
           begin
               Inc(i);
               FQuery.Next;
           end;
        result:=i=2;
    finally
        FQuery.Close;
        FQuery.Free;
    end;
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose:=FCanClose;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
    inbError:=0;
    Readbase0;
    FCanClose:=true;
end;

procedure TForm2.CallBackThread(Sender:TObject);
begin
    if (TTraitementThread(Sender).FnbError=0) then
      begin
         Label1.Caption:='OK';
      end
    else begin
       Label1.Caption:='ERREUR';
    end;
    MyTimer.Enabled:=false;
    FCanClose:=true;
end;


procedure TForm2.Readbase0;
Const C_KEY='Software\Algol\Ginkoia\';
var
  RegistryEntry: TRegistry;
begin
  RegistryEntry := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    RegistryEntry.RootKey := HKEY_LOCAL_MACHINE;
    RegistryEntry.Access := KEY_READ {or KEY_WOW64_64KEY};
    if RegistryEntry.OpenKey(C_KEY, false) then
      begin
        teIBORIGINE_0.Text := RegistryEntry.ReadString('Base0');
        teIBORIGINE.text   := ExtractFilePath(teIBORIGINE_0.Text) + FormatDateTime('yyyy_mm_dd_',Now()) + 'SAV00.ib';
        teBCK.text         := ExtractFilePath(teIBORIGINE_0.Text) + FormatDateTime('yyyy_mm_dd_',Now()) + 'SAV00.gbk';
        teIBINTER.text     := ExtractFilePath(teIBORIGINE_0.Text) + FormatDateTime('yyyy_mm_dd_',Now()) + 'REST00.ib';
      end;
    RegistryEntry.CloseKey();
  finally
    RegistryEntry.Free;
  end;
end;


function TTraitementThread.List_Tables(ACon:TFDConnection):TStringList;
var // chaine:string;
    FQuery:TFDQuery;
begin
    result:=TStringList.Create;
    result.Clear;
    FQuery:=TFDQuery.Create(nil);
    FQuery.Connection:=ACon;
    try
       FQuery.SQL.Clear;
       FQuery.SQL.Add('SELECT DISTINCT RDB$RELATION_NAME AS TABLE_NAME ');
       FQuery.SQL.Add('     FROM RDB$RELATION_FIELDS     ');
       FQuery.SQL.Add('      WHERE RDB$SYSTEM_FLAG=0     ');
       FQuery.open;
       while Not(FQuery.eof) do
          begin
             result.Add(FQuery.FieldByName('TABLE_NAME').AsString);
             FQuery.Next;
          end;
    finally
     FQuery.Close;
     FQuery.Free;
    end;
end;


procedure TForm2.ProceduresClick(Sender: TObject);
var A:TTraitementThread;
begin
    try
       FCanClose:=false;
       BProcedure.Enabled:=false;
       A:=TTraitementThread.Create(
            FDConnection1, FDConnection2,
            teIBORIGINE_0.Text,
            teIBORIGINE.Text,
            teBCK.text,
            teIBINTER.text,
            true
            );
        A.Etape_procedure;
    finally
       BProcedure.Enabled:=A.FnbError<>0;
       BTRIGGERS.Enabled:=A.FnbError=0;
       FreeAndNil(A);
       FCanClose:=true;
    end;
{   try
      try
        ProgressBar.Position:=7;

        StatusBar1.Panels[0].text := 'Création des procedures stockées en cours...';
        StatusBar1.Refresh;

        Bprocedure.Enabled:=false;
        FDConnection2.Close();
        FDConnection2.open();
        Create_All_Procedure(FDConnection1,FDConnection2);

        StatusBar1.Panels[0].text := 'Modification des procedures stockées en cours...';
        StatusBar1.Refresh;

        FDConnection2.Close;
        FDConnection2.open;
        Alter_All_Procedure(FDConnection1,FDConnection2);
        FDConnection2.Close;
        StatusBar1.Panels[0].text := 'Procedures stockées : [OK]';
        ProgressBar.Position:=8;

      Except On E:Exception do
        begin
          StatusBar1.Panels[0].text := 'Procedures stockées : [ERREUR]';
        end;
      end;
   finally
      StatusBar1.Refresh;
      BTRIGGERS.Enabled:=true;
   end;
   }
end;

end.

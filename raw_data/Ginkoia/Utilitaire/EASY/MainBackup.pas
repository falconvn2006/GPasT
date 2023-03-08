/// <summary>
/// Unité Fenetre du Backup Restore LAME
/// </summary>

unit MainBackup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Def, FireDAC.VCLUI.Wait,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Stan.Intf, FireDAC.Phys,
  Vcl.StdCtrls, Vcl.ComCtrls,  System.Diagnostics,
  Vcl.ExtCtrls,Math, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, IniFiles, Vcl.Grids,
  Vcl.DBGrids,DateUtils, Vcl.Buttons, Vcl.Menus,uCheckUpdate,Winapi.ShellAPI, uEasy.Threads, uEasy.Types,
  Vcl.Samples.Spin;

Const CST_TERMINE    = 'B/R Fin';
      CST_HORS_PLAGE = 'Hors Plage Horaire';
      // --------------------------------------
      CST_ETAPE_BR    = 'Backup/Restore...';
//      CST_ETAPE_OPTIM = 'Optimisation...';
      CST_ETAPE_END   = 'Terminé';

type
  TFrm_MainBackup = class(TForm)
    lbl_EtapeActuelle: TLabel;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    lbl_DossierEncours: TLabel;
    pgEstimation: TProgressBar;
    tmEstimate: TTimer;
    FDMemTable1: TFDMemTable;
    FDMemTable1DOSSIER: TStringField;
    FDMemTable1IBFILE: TStringField;
    FDMemTable1EASYSERVICE: TStringField;
    FDMemTable1LAST: TDateTimeField;
    FDMemTable1TIME: TFloatField;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label3: TLabel;
    FDMemTable1CAL_TIME: TStringField;
    tAuto: TTimer;
    GroupBox1: TGroupBox;
    lbl_EstimateTimeLeft: TLabel;
    FDMemTable1LASTRESULT: TIntegerField;
    FDMemTable1CAL_RESULT: TStringField;
    FDMemTable1LASTOK: TDateTimeField;
    lbl_EstimTotal: TLabel;
    BSuspend: TSpeedButton;
    FDMemTable1BACKUP_WITH_OLD_IB: TIntegerField;
    FDMemTable1BACKUP_Compression_7Z: TIntegerField;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    N2: TMenuItem;
    Mettrejour: TMenuItem;
    Lbl_Update: TLabel;
    N1: TMenuItem;
    Aide1: TMenuItem;
    FDMemTable1ID: TIntegerField;
    PageControl1: TPageControl;
    tsDossiers: TTabSheet;
    Log: TTabSheet;
    mLog: TMemo;
    tsOptions: TTabSheet;
    lbl_Plage: TLabel;
    dtDEBUT: TDateTimePicker;
    dtFIN: TDateTimePicker;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    cbCompress: TComboBox;
    Label4: TLabel;
    seBRMax: TSpinEdit;
    teBR_DIR: TEdit;
    Label5: TLabel;
    FDMemTable1LASTOPTIM: TDateTimeField;
    tmAutoCloseInX: TTimer;
    Label6: TLabel;
    cbPageBuffers: TComboBox;
    Label7: TLabel;
    teOLD_DIR: TEdit;
    seOLDMAX: TSpinEdit;
    teInstanceName: TEdit;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmEstimateTimer(Sender: TObject);
    procedure FDMemTable1CalcFields(DataSet: TDataSet);
    procedure tAutoTimer(Sender: TObject);
    procedure BBRClick(Sender: TObject);
    procedure BSuspendClick(Sender: TObject);
    procedure MettrejourClick(Sender: TObject);

    procedure CallBackCheckVersion(Sender:Tobject);
    procedure CallBackNewExeInstall(Sender:Tobject);


    procedure Aide1Click(Sender: TObject);


//    procedure OptimiseEndCallback(Sender: TObject);
    procedure ParamsGenerauxChange(Sender: TObject);
    procedure tmAutoCloseInXTimer(Sender: TObject);
//    procedure tmOPTIMISETimer(Sender: TObject);

  private
    FCanClose   : boolean;
    FCanSave    : Boolean;
    FBRGrid     : TBRArray;
    FStart      : Cardinal;

    FNext   : string;  // ProchainDossier;
    FETAPE  : string;

    FCheckUpdateThread : TCheckUpdateThread;
    FExeUpdateThread   : TExeUpdateThread;
    FLockUpdate    : Boolean;

    FTimeClose       : integer;
    FAuto            : Boolean;
    // FRunning         : Boolean;
    FSuspend         : Boolean;  //< Pause du Programme
    FDEBUT           : TTime;    //< Plage de Début
    FFIN             : TTime;
    FBACKUP_MAX      : Integer;
    FOLD_MAX         : Integer;
    FBACKUP_DIR      : string;
    FOLD_DIR         : string;
    FGENERAL_BACKUP_Compression_7Z : integer;
    FInstanceName    : string;
    FPAGEBUFFERS     : Integer;


(*
    FOPTIM         : integer;
    FOPTIM_OPTIONS : string;
*)
    // Threads
    FBackupRestore : TBackupRestore;
//    FOptimize      : TOptimizeDB;

    FCurrentDossier : string;
    FEASYService  : string;
    FBACKUP_Compression_7Z : Integer;
    FCurrentIB : TFileName;

    FStopwatch : TStopwatch;

    // Gestion de fin de thread
    procedure OnTerminateThread(Sender : TObject);
//    procedure OnStdIn(Sender : TObject);
    procedure LoadDossiers;
    procedure BRDossier();
    procedure ModeEnchainementAuto;
//    procedure TraitementOptimisations();

    procedure ChoixProchaineBase();
    procedure LoadParamsGeneraux;
    procedure SaveParamsGeneraux();
    procedure MAJMemData(aResult:Integer;aSecondes:integer;LibResult:string);
    procedure Lancement;
    function GetPropertiesFile(aServiceName:string):String;
    procedure SetLockUpdate(value:Boolean);

    procedure StatusCallback(Const s:string);


    procedure LogCallback(Const s:string);

    function GridLocate2BRRec():TBRRecord;
    procedure GetEasyInfos();
    procedure LoadDatasGrid();
    function LocateInFBRGrid(aDossier:string):Boolean;
    function LocateFNextInFBRGrid():TBRRecord;
    procedure DoLog(aMsg:string);
    procedure Ordonne_By_LAST_OK();
    procedure ProgrammeDeLaNuit(aMsg:string);
    procedure InfosEstimation();
    procedure CloseInXseconds(const aSec:integer=30);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property LockUpdate : Boolean read FLockUpdate write SetLockUpdate;

  end;

var
  Frm_MainBackup: TFrm_MainBackup;

implementation

{$R *.dfm}
uses System.TimeSpan, uCommun, UWMI;

procedure TFrm_MainBackup.ProgrammeDeLaNuit(aMsg:string);
begin
   mLOG.Lines.Add(aMsg);
end;

procedure TFrm_MainBackup.DoLog(aMsg:string);
begin
   mLOG.Lines.Add(FormatDateTime('yyyy-dd-mm hh:nn:ss : ',Now()) + aMsg);
end;

function TFrm_MainBackup.GridLocate2BRRec():TBRRecord;
var i:integer;
begin
    result.Init;
    for I := Low(FBRGrid) to High(FBRGrid) do
      begin
        if (FDMemTable1.FieldByName('DOSSIER').AsString = FBRGrid[i].DOSSIER)
          then
            begin
                result := FBRGrid[i];
                break;
            end;
      end;
end;


function TFrm_MainBackup.LocateFNextInFBRGrid():TBRRecord;
var i:integer;
begin
    result.Init;
    for I := Low(FBRGrid) to High(FBRGrid) do
      begin
        if (FBRGrid[i].DOSSIER = FNext)
          then
            begin
                result := FBRGrid[i];
                break;
            end;
      end;
end;



function TFrm_MainBackup.LocateInFBRGrid(aDossier:string):Boolean;
var i:integer;
begin
    result := False;
    for I := Low(FBRGrid) to High(FBRGrid) do
      begin
        if (aDossier = FBRGrid[i].DOSSIER)
          then
            begin
                result := true;
                break;
            end;
      end;
end;

procedure TFrm_MainBackup.SetLockUpdate(value:Boolean);
begin
    FLockUpdate  := Value;
    Self.Enabled := not(Value);
end;

procedure TFrm_MainBackup.Lancement;
var i:integer;
    vFound : Boolean;
begin
    ChoixProchaineBase();
    vFound    := false;
    for I := Low(FBRGrid) to High((FBRGrid)) do
      begin
        if FNext=FBRGrid[i].DOSSIER then
          begin
              ModeEnchainementAuto;
              vFound := true;
              Break;
          end;
      end;
    // pas trouvé
    if not(vFound)
      then Label3.Caption := FNext;
end;


// Permet d'Ordonner le tableau
procedure TFrm_MainBackup.Ordonne_By_LAST_OK();
var i,j:Integer;
    t:TBRRecord;
begin;
    for i := High(FBRGrid)-1 downto 0 do
      for j := 0 to i do
      begin
         if (FBRGrid[j+1].LASTBR<FBRGrid[j].LastBR) then
             begin
                t := FBRGrid[j+1];
                FBRGrid[j+1] := FBRGrid[j];
                FBRGrid[j] := t;
             end;
      end;
    for i := Low(FBRGrid) to High(FBRGrid) do
      begin
         FBRGrid[i].ID:=i+1;
      end;
end;

procedure TFrm_MainBackup.InfosEstimation();
var i      : integer;
    vCur   : TDateTime;
    vDebut : TDateTime;
    vFin   : TDateTime;
begin
    ProgrammeDeLaNuit('--- POUR INFO : ESTIMATION ---');
    ProgrammeDeLaNuit('Estimation Prochain B/R Lame Auto :');
    vCur := Now();
    If (Frac(FDEBUT)<Frac(FFIN)) then
      begin
          while (vCur<Trunc(vCur)+Frac(FDEBUT)) or (vCur>=Trunc(vCur)+Frac(FFIN)) do
            begin
                vCur:=IncSecond(vCur,1);
            end;
      end;

    If (Frac(FDEBUT)>Frac(FFIN)) then
      begin
          while (vCur<Trunc(vCur)+Frac(FDEBUT)) or (vCur>=Trunc(vCur+1)+Frac(FFIN)) do
            begin
                vCur:=IncSecond(vCur,1);
            end;
      end;

    // Le prochain Départ
    vDebut := vCur;

    // Calcul de la prochaine Fin
    If (Frac(FDEBUT)<Frac(FFIN)) then
      begin
        vFin := Trunc(vDebut) + Frac(FFin);
      end;
    If (Frac(FDEBUT)>Frac(FFIN)) then
      begin
        vFin := Trunc(vDebut+1) + Frac(FFin);
      end;

    ProgrammeDeLaNuit(Format('Début %s ',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vDebut)]));
    ProgrammeDeLaNuit(Format('Fin %s ',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vFin)]));
    //----------------------------
    for i := Low(FBRGrid) to High(FBRGrid) do
      begin
          If vCur<vFin then
            begin
                ProgrammeDeLaNuit(Format('Vers %s Dossier %s  B/R pendant %s',[
                    FormatDateTime('dd/mm/yyyy hh:nn:ss',vCur),FBRGrid[i].DOSSIER,
                   SecondToTime(FBRGrid[i].TIME)]));
                vCur := vCur + FBRGrid[i].TIME / SecsPerDay;
            end
          else
            begin
                ProgrammeDeLaNuit(Format('Le Dossier %s ne sera pas B/R pendant le cycle',[FBRGrid[i].DOSSIER]));
            end;
      end;

    (* L'optimisation c'est plus ici
    //----- en fait comme il s'auto adapte c'est surmement pas dans le bon ordre...
    //-----
    for i := Low(FBRGrid) to High(FBRGrid) do
      begin
          // il n'y a pas de test... il faut que les optimisations passent...
           ProgrammeDeLaNuit(Format('Vers %s Dossier %s  Optimisation pendant %s',[
                   FormatDateTime('dd/mm/yyyy hh:nn:ss',vCur),FBRGrid[i].DOSSIER,
                   SecondToTime(FBRGrid[i].TIME_OPTIMIZE)]));
           vCur := vCur + FBRGrid[i].TIME_OPTIMIZE / SecsPerDay;
      end;
    //---------------------------
    *)
    ProgrammeDeLaNuit(Format('Terminé vers %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vCur)]));
    ProgrammeDeLaNuit('--- POUR INFO : ESTIMATION ---');

    // AutoClose dans 30 secondes si la prochaine est dans plus de 12h
    If FAuto then
      begin
         if ((vDebut-Now())>12/24)
           then
            begin
              // Sauvegarde uniquement en Mode Auto et si prochain cycle dans plus de 12h
              mLog.Lines.SaveToFile(ChangeFileExt(Application.ExeName,'.log')) ;
              //
              CloseInXseconds(30);
              exit;
            end;
         if ((vDebut-Now())>1/24)
           then
            begin
              DoLog('Mode AUTO, prochain Cycle dans plus d''une heure...');
            end;
      end;
end;

procedure TFrm_MainBackup.ModeEnchainementAuto;
var vBRRec : TBRRecord;
begin
    if LocateInFBRGrid(FNext)
      then
       begin
          vBRRec := LocateFNextInFBRGrid();
          if vBRRec.ID>0 then
            begin
              FCurrentDossier        := vBRRec.DOSSIER;
              FCurrentIB             := vBRRec.IBFILE;
              FEASYService           := vBRRec.EASYSERVICE;
              FBACKUP_Compression_7Z := vBRRec.COMPRESS7Z;
              FPAGEBUFFERS           := vBRRec.PAGEBUFFERS;
              BRDossier();
            end;
       end
    else
      begin
        LoadDossiers;
      end;
end;

procedure TFrm_MainBackup.Aide1Click(Sender: TObject);
begin
    ShellExecute(0, 'OPEN', PChar('http://lame2.no-ip.com/algol/SRV_DEV/products/EASY/help.html'), '', '', SW_SHOWNORMAL);
end;

procedure TFrm_MainBackup.BBRClick(Sender: TObject);
begin
//    Lancement;
end;

procedure TFrm_MainBackup.LogCallback(Const s:string);
begin
   DoLog(s);
end;

procedure TFrm_MainBackup.StatusCallback(Const s:string);
begin
   StatusBar1.Panels[0].Text := s;
   lbl_EtapeActuelle.Caption := s;
end;

{
        for i := Low(FBRGrid) to High(FBRGrid) do
          begin
            // FBRGrid[i].LASTOPTIM := FBRGrid[i].LASTOPTIM;
            vNow := Now();
            if (vNow-FBRGrid[i].LASTOPTIM)>12/24 then
              begin
                DoLog('Optimisation :' + FBRGrid[i].DOSSIER);
                // 1 thread à la fois.... ==> donc Break
                // Si le BR est Ok et a moins de 12h c'est qu'il est bien passé....
                If (vNow-FBRGrid[i].LASTBROK)<12/24
                  then
                    begin
                      vOPTIM_OPTIONS := Copy(FOPTIM_OPTIONS,1,6);
                    end
                  else
                    begin
                      vOPTIM_OPTIONS := Copy(FOPTIM_OPTIONS,7,6);
                    end;

                FBRGrid[i].LASTOPTIM := vNow;
                SaveStrToIniFile(FBRGrid[i].DOSSIER,'LASTOPTIM',FormatDateTime('dd/mm/yyyy hh:nn:ss',vNow));
}

(*
procedure TFrm_MainBackup.OptimiseEndCallback(Sender: TObject);
begin
   StatusBar1.Panels[0].Text := '';
   DoLog('Fin Optimise pour '+TOptimizeDB(Sender).DOSSIER);
   SaveIntToIniFile(TOptimizeDB(Sender).DOSSIER,'TIME_OPTIMIZE',TOptimizeDB(Sender).Time);
   FOptimize:=nil;
   //
   // then
   //   begin
   //      // Permet de savoir le prochain "programme"
   //      InfosEstimation;
   //      FCanClose := True;
   //      CloseInXSeconds(30);
   //   end;
   tmOPTIMISE.Enabled:=true;
end;
*)


// Remplissage des Champs EASYDir et PropertiesFile (champs supplémentaires)
procedure TFrm_MainBackup.GetEasyInfos();
var i,j:Integer;
    vEasy:TSYMDSInfos;
    vFind:Integer;
    vPattern:string;
    SearchResult:TSearchRec;
begin
    WMI_GetServicesSYMDS;
    for i := Low(VGSYMDS) to High(VGSYMDS) do
      begin
          for j := Low(FBRGrid) to High(FBRGrid) do
          begin
              if UpperCase(VGSYMDS[i].ServiceName)=UpperCase(FBRGrid[j].EASYSERVICE) then
                begin
                  vEasy := VGSYMDS[i];
                  FBRGrid[j].EASYDIR        :=  ExcludeTrailingPathDelimiter(vEASY.Directory);
                  // ca sera dans le init
                  FBRGrid[j].PropertiesFile := '';
                  // on cherche le fichier  "engine.name".properties
                  vPattern := Format('%s\engines\*.properties',[ExcludeTrailingPathDelimiter(vEASY.Directory)]);
                  if findfirst(vPattern, faAnyFile, searchResult) = 0 then
                     begin
                        vFind := 0;
                         repeat
                           inc(vFind);  // S'il y en a plusieur ===> STOP exit erreur
                           FBRGrid[j].PropertiesFile := ExcludeTrailingPathDelimiter(vEASY.Directory) + '\engines\' + searchResult.Name;
                         until FindNext(searchResult) <> 0;
                        FindClose(searchResult);
                     end;
                end;
            end;
      end;
end;

function TFrm_MainBackup.GetPropertiesFile(aServiceName:string):String;
var i:Integer;
    vEasy:TSYMDSInfos;
    vFind:Integer;
    vPattern:string;
    SearchResult:TSearchRec;
begin
    result := '';
    WMI_GetServicesSYMDS;
    for i := Low(VGSYMDS) to High(VGSYMDS) do
      begin
        if VGSYMDS[i].ServiceName=aServiceName then
          begin
              vEasy := VGSYMDS[i];
              // on cherche le fichier  "engine.name".properties
              vPattern := Format('%s\engines\*.properties',[ExcludeTrailingPathDelimiter(vEASY.Directory)]);
              if findfirst(vPattern, faAnyFile, searchResult) = 0 then
                  begin
                    vFind := 0;
                    repeat
                      inc(vFind);  // S'il y en a plusieur ===> STOP exit erreur
                      result := ExcludeTrailingPathDelimiter(vEASY.Directory) + '\engines\' + searchResult.Name;
                    until FindNext(searchResult) <> 0;
                    FindClose(searchResult);
                  end;
          end;
      end;
end;


procedure TFrm_MainBackup.BRDossier();
var
  LogName : string;
  Password : string;
  vTime : string;
  vNow : TDateTime;
  vAncienIB : string;
  i:integer;
  vBRRec : TBRRecord;

begin
  lbl_DossierEncours.Caption := Format('Dossier : %s' + #13+#10
                                      +'Fichier : %s' + #13+#10
                                      +'Niveau Compression : %d' + #13+#10
                                      ,[FCurrentDossier,FCurrentIB,FBACKUP_Compression_7Z]);
  lbl_EtapeActuelle.Caption := 'Lancement..';
  FCanClose:=False;
  vTime := LoadStrFromIniFile(FCurrentDossier,'TIME');
  pgEstimation.Visible:=true;
  pgEstimation.Position:=0;
  pgEstimation.Max := Math.Ceil(StrToFloatDef(vtime,0));
  pgEstimation.Step:=1;

  FStopwatch := TStopwatch.StartNew;
  vNow := Now();
  SaveStrToIniFile(FCurrentDossier,'LAST',DateTimeToStr(vNow));
  try
     for I := Low(FBRGrid) to High(FBRGrid) do
      begin
        if (FCurrentDossier = FBRGrid[i].DOSSIER)
          then
            begin
                FBRGrid[i].LASTBR := vNow;
                break;
            end;
      end;


   vBRRec := LocateFNextInFBRGrid();
   if vBRRec.ID>0 then
        begin
          DoLog('B/R du dossier :'+ vBRRec.DOSSIER);
          FBackupRestore := TBackupRestore.Create(vBRRec,
              FBACKUP_MAX, FBACKUP_DIR,
              FOLD_MAX, FOLD_DIR,
              StatusCallback,LogCallBack,OnTerminateThread);
          lbl_EtapeActuelle.Visible := True;
          lbl_EstimateTimeLeft.Visible :=  true;
          tmEstimate.Enabled        := true;

          FBackupRestore.Start;


        end;
  finally
     ChoixProchaineBase();  // Ca Set FNEXT
     Label3.Caption := 'Prochain Dossier : '+ FNext;
     if (FNext=CST_HORS_PLAGE)
       then Label3.Caption := CST_HORS_PLAGE;
     if (FNext=CST_TERMINE)
       then Label3.Caption := CST_TERMINE;
  end;

  {
  FThread := TBaseBackRestLameThread.Create(OnTerminateThread, FStdStream, LogName, FEASYService,'localhost',
          FCurrentIB , 3050, DoValidate, CST_PAGE_BUFFER_LAME,
          FBACKUP_MAX,
          FBACKUP_DIR,
          FBACKUP_WITH_OLD_IB,
          FBACKUP_Compression_7Z,
          GetPropertiesFile(FEASYService),
          pgEtapes, lbl_EtapeActuelle);
  }

end;



procedure TFrm_MainBackup.FDMemTable1CalcFields(DataSet: TDataSet);
begin
    DataSet.FieldByName('CAL_TIME').AsString := SecondToTime(DataSet.FieldByName('TIME').asfloat);
    if not(VarIsNull(DataSet.FieldByName('LASTRESULT').Value))
      then
          case DataSet.FieldByName('LASTRESULT').asinteger of
            0: DataSet.FieldByName('CAL_RESULT').AsString := 'OK'
            else
              DataSet.FieldByName('CAL_RESULT').AsString := Format('ERREUR %d',[DataSet.FieldByName('LASTRESULT').asinteger]);
          end;
end;

procedure TFrm_MainBackup.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := FCanClose;
end;

procedure TFrm_MainBackup.ChoixProchaineBase();
var vLast:TDateTime;
    vNextDossier : string;
    vNow : double;
    i:integer;
begin
    vNextDossier := '';
    vLast := Tomorrow;
    for I := Low(FBRGrid) to High((FBRGrid)) do
      begin
         if (FBRGrid[i].LASTBR<vLast)
           then
             begin
                vNextDossier := FBRGrid[i].DOSSIER;
                vLast        := FBRGrid[i].LASTBR
             end;
      end;

  FNEXT  := vNextDossier;
  FETAPE := CST_ETAPE_BR;

   //***  partie décimale ==> Heure de la journée ***//
   vNow := Frac(Now());
   if (FDEBUT<FFin)
       then
         begin
             if not((FDEBUT<vNow) and (vNow<FFin))
                then
                 begin
                   FNEXT  := CST_HORS_PLAGE;
                   FETAPE := CST_ETAPE_END;
                   exit;
                 end;
         end;

    if (FFin<FDEBUT)
        then
           begin
               if ((FFIN<vNow) and (vNow<FDebut))
                then
                  begin
                    FNEXT  := CST_HORS_PLAGE;
                    FETAPE := CST_ETAPE_END;
                    exit;
                  end;
           end;

     // Mais si ca date de moins de 12 heures c'est tout pour aujourd'hui
     if SecondsBetween(vLast,Now()) < (SecsPerDay div 2)
        then
          begin
             FNEXT  := CST_TERMINE;
             FETAPE := CST_ETAPE_END;
          end;



{
   vDisabled :=  FDMemTable1.ControlsDisabled;
   if not(vDisabled)
     then FDMemTable1.DisableControls;

   try
       // C'est pas forcement le dossier en cours... seulement celui qui a le focus...
       vDossier := FDMemTable1.FieldByName('DOSSIER').AsString;
       vLast        := Tomorrow; // EncodeDate(2100,1,1);
       vNextDossier := '';
       FDMemTable1.First;
       while not(FDMemTable1.eof) do
          begin
            if (FDMemTable1.FieldByName('LAST').AsDateTime<vLast)
              then
                begin
                   vNextDossier := FDMemTable1.FieldByName('DOSSIER').AsString;
                   vLast        := FDMemTable1.FieldByName('LAST').AsDateTime;
                end;
            FDMemTable1.Next;
          end;
       FDMemTable1.Locate('DOSSIER',vDossier,[]);
       // Nous donne l plus vieux dossier....
       Result := vNextDossier;

       //***  partie décimale ==> Heure de la journée ***//
       vNow := Frac(Now());
       if (FDEBUT<FFin)
          then
            begin
               if not((FDEBUT<vNow) and (vNow<FFin))
                 then
                  begin
                    result := CST_HORS_PLAGE;
                    exit;
                  end;
            end;

       if (FFin<FDEBUT)
          then
            begin
               if ((FFIN<vNow) and (vNow<FDebut))
                 then
                  begin
                    result:=CST_HORS_PLAGE;
                    exit;
                  end;
            end;

       // Mais si ca date de moins de 12 heures c'est tout pour aujourd'hui
       if SecondsBetween(vLast,Now()) < (SecsPerDay div 2)
          then result:=CST_TERMINE;
   finally
     if not(vDisabled)
      then FDMemTable1.EnableControls;
   end;
   }
end;

procedure TFrm_MainBackup.ParamsGenerauxChange(Sender: TObject);
begin
  if FCanSave then
    begin
        FDEBUT := dtDEBUT.Time;
        FFIN   := dtFIN.Time;

        FBACKUP_DIR := teBR_DIR.Text;

        FOLD_DIR    := teOLD_DIR.Text;

        FGENERAL_BACKUP_Compression_7Z := StrToIntDef(cbCompress.Text,1);
        FBACKUP_MAX := seBRMax.Value;
        FOLD_MAX    := seOLDMax.Value;

        FPAGEBUFFERS   := StrToIntDef(cbPageBuffers.text,4096);
        FInstanceName  := teInstanceName.Text;

        (*
        if cbOPTIM.Checked
          then
            begin
              FOPTIM := 1;
              gbOptimisation1.Visible:=true;
              gbOptimisation2.Visible:=true;
            end
          else
            begin
              FOPTIM := 0;
              gbOptimisation1.Visible:=False;
              gbOptimisation2.Visible:=False;
            end;

        FOPTIM_OPTIONS := '';

        if cbStop1.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbSWEEP1.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbINDEX1.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbPREPURGE1.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbIDXSYMDS1.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbStart1.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        //

        if cbStop2.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbSWEEP2.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbINDEX2.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbPREPURGE2.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbIDXSYMDS2.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';

        if cbStart2.Checked
          then FOPTIM_OPTIONS := FOPTIM_OPTIONS +'1'
          else FOPTIM_OPTIONS := FOPTIM_OPTIONS +'0';
       *)

        SaveParamsGeneraux();
    end;
end;


procedure TFrm_MainBackup.SaveParamsGeneraux;
var appINI    : TIniFile;
begin
  //----------------------------------------------------------------------------
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  try
    ///
    appINI.WriteString('GENERAL','DEBUT',TimeToStr(Frac(FDEBUT)));
    appINI.WriteString('GENERAL','FIN',TimeToStr(Frac(FFIN)));

    appINI.WriteString('GENERAL','BACKUP_DIR',FBACKUP_DIR);
    appINI.WriteString('GENERAL','OLD_DIR',FOLD_DIR);

    appINI.WriteInteger('GENERAL','BACKUP_Compression_7Z',FGENERAL_BACKUP_Compression_7Z);
    appINI.WriteInteger('GENERAL','BACKUP_MAX',FBACKUP_MAX);
    appINI.WriteInteger('GENERAL','OLD_MAX',FOLD_MAX);
    appINI.WriteInteger('GENERAL','PAGEBUFFERS',FPAGEBUFFERS);

    appINI.WriteString('GENERAL','INSTANCENAME',FInstanceName);


//    appINI.WriteInteger('GENERAL','OPTIM',FOPTIM);

//    appINI.WriteString('GENERAL','OPTIM_OPTIONS',FOPTIM_OPTIONS);

  finally
    appINI.Free;
  end;
end;




procedure TFrm_MainBackup.LoadParamsGeneraux;
var appINI    : TIniFile;
begin
  //----------------------------------------------------------------------------
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  try
    FDEBUT := Frac(StrToTime(appINI.ReadString('GENERAL','DEBUT','0')));
    FFIN   := Frac(StrToTime(appINI.ReadString('GENERAL','FIN','')));

    FBACKUP_DIR := appINI.ReadString('GENERAL','BACKUP_DIR','backup');
    FOLD_DIR := appINI.ReadString('GENERAL','OLD_DIR','old');

    FGENERAL_BACKUP_Compression_7Z := appINI.ReadInteger('GENERAL','BACKUP_Compression_7Z',1);

    FBACKUP_MAX := appINI.ReadInteger('GENERAL','BACKUP_MAX',3);
    FBACKUP_MAX := Min(Max(FBACKUP_MAX,1),5);

    FOLD_MAX := appINI.ReadInteger('GENERAL','OLD_MAX',2);

    FPAGEBUFFERS := appINI.Readinteger('GENERAL','PAGEBUFFERS',4096);
    cbPageBuffers.Text := IntToStr(FPAGEBUFFERS);

//    FOPTIM         := appINI.Readinteger('GENERAL','OPTIM',0);
//    FOPTIM_OPTIONS := appINI.ReadString('GENERAL','OPTIM_OPTIONS','100111111111');
    FInstanceName := appINI.ReadString('GENERAL','INSTANCENAME','');


    dtDEBUT.Time := FDEBUT;
    dtFIN.Time   := FFIN;

    teBR_DIR.Text   := FBACKUP_DIR;
    teOLD_DIR.Text  := FOLD_DIR;
    cbCompress.Text := IntToStr(FGENERAL_BACKUP_Compression_7Z);

    seBRMax.Value     := FBACKUP_MAX;
    seOLDMAX.Value    := FOLD_MAX;
    teInstanceName.Text := FInstanceName;
    (*
    cbOPTIM.Checked    := FOPTIM=1;

    cbSTOP1.Checked     := FOPTIM_OPTIONS[1]='1';
    cbSWEEP1.Checked    := FOPTIM_OPTIONS[2]='1';
    cbINDEX1.Checked    := FOPTIM_OPTIONS[3]='1';
    cbPREPURGE1.Checked := FOPTIM_OPTIONS[4]='1';
    cbIDXSYMDS1.Checked := FOPTIM_OPTIONS[5]='1';
    cbSTART1.Checked    := FOPTIM_OPTIONS[6]='1';

    cbSTOP2.Checked     := FOPTIM_OPTIONS[7]='1';
    cbSWEEP2.Checked    := FOPTIM_OPTIONS[8]='1';
    cbINDEX2.Checked    := FOPTIM_OPTIONS[9]='1';
    cbPREPURGE2.Checked := FOPTIM_OPTIONS[10]='1';
    cbIDXSYMDS2.Checked := FOPTIM_OPTIONS[11]='1';
    cbSTART2.Checked    := FOPTIM_OPTIONS[12]='1';
    *)

  finally
    appINI.Free;
  end;
end;

procedure TFrm_MainBackup.LoadDossiers;
var appINI    : TIniFile;
    vSections : TStringList;
    i         : Integer ;
    vNext     : string;
    vTotal    : double;
    vLastOK   : string;
    vLast     : string;
    vLastOPTIM : string;
    j         : integer;
begin
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  vSections:=TStringList.Create;
  vTotal := 0;
  j:=0;
  SetLength(FBRGrid,0);
  try
    appINI.ReadSections(vSections);
    for i:=0 to vSections.Count-1 do
      begin
        //-----------------------------
        if (vSections.Strings[i]<>'GENERAL')
          then
            begin
              Inc(j);
              SetLength(FBRGrid,j);
              FBRGrid[j-1].ID := j;
              FBRGrid[j-1].DOSSIER     := vSections.Strings[i];
              FBRGrid[j-1].EASYSERVICE := appINI.ReadString(vSections.Strings[i],'EASYSERVICE','');
              FBRGrid[j-1].IBFILE      := appINI.ReadString(vSections.Strings[i],'IBFILE','');
              vLastOK := appINI.ReadString(vSections.Strings[i],'LASTOK','');
              if vLastOK<>''
                then FBRGrid[j-1].LASTBROK := StrToDateTime(vLastOK);
              vLast := appINI.ReadString(vSections.Strings[i],'LAST','');
              if (vLast<>'')
                then FBRGrid[j-1].LASTBR := StrToDateTime(vLast);

              FBRGrid[j-1].TIME := Ceil(appINI.ReadFloat(vSections.Strings[i],'TIME',1000));
              vTotal := vTotal + FBRGrid[j-1].TIME;
              FBRGrid[j-1].LASTRESULT   := appINI.ReadInteger(vSections.Strings[i],'LASTRESULT',-1);
              FBRGrid[j-1].COMPRESS7Z   := appINI.ReadInteger(vSections.Strings[i],'BACKUP_Compression_7Z',FGENERAL_BACKUP_Compression_7Z);
              FBRGrid[j-1].PAGEBUFFERS  := appINI.ReadInteger(vSections.Strings[i],'PAGEBUFFERS',FPAGEBUFFERS);
              FBRGrid[j-1].InstanceName := FInstanceName;

//              FBRGrid[j-1].TIME_OPTIMIZE := appINI.ReadInteger(vSections.Strings[i],'TIME_OPTIMIZE',300);

//              vLastOPTIM := appINI.ReadString(vSections.Strings[i],'LASTOPTIM','');
//              if vLASTOPTIM<>''
//                then FBRGrid[j-1].LASTOPTIM := StrToDateTime(vLastOPTIM)
//                else FBRGrid[j-1].LASTOPTIM := 0;


              {
              FDMemTable1.Append;
              FDMemTable1.FieldByName('ID').Asinteger := j;
              FDMemTable1.FieldByName('DOSSIER').AsString := vSections.Strings[i];
              FDMemTable1.FieldByName('EASYSERVICE').AsString := appINI.ReadString(vSections.Strings[i],'EASYSERVICE','');
              FDMemTable1.FieldByName('IBFILE').AsString := appINI.ReadString(vSections.Strings[i],'IBFILE','');
              vLastOK := appINI.ReadString(vSections.Strings[i],'LASTOK','');
              if vLastOK<>''
                then FDMemTable1.FieldByName('LASTOK').AsDateTime := StrToDateTime(vLastOK);
              vLast := appINI.ReadString(vSections.Strings[i],'LAST','');
              if (vLast<>'')
                then FDMemTable1.FieldByName('LAST').AsDateTime := StrToDateTime(vLast);
              //
              FDMemTable1.FieldByName('TIME').Asfloat := StrToFloatDef(appINI.ReadString(vSections.Strings[i],'TIME',''),1000);
              vTotal := vTotal + FDMemTable1.FieldByName('TIME').Asfloat + 1;
              FDMemTable1.FieldByName('LASTRESULT').Asinteger := appINI.ReadInteger(vSections.Strings[i],'LASTRESULT',-1);

              FDMemTable1.FieldByName('BACKUP_Compression_7Z').AsInteger := appINI.ReadInteger(vSections.Strings[i],'BACKUP_Compression_7Z',FGENERAL_BACKUP_Compression_7Z);
              FDMemTable1.FieldByName('BACKUP_WITH_OLD_IB').AsInteger := appINI.ReadInteger(vSections.Strings[i],'BACKUP_WITH_OLD_IB',FGENERAL_BACKUP_WITH_OLD_IB);

              FDMemTable1.Post();
              }
            end;
      end;
  finally
    vSections.Free;
    appINI.Free;
  end;

  // On complète le Tableau
  GetEasyInfos;
  Ordonne_By_LAST_OK();

  LoadDatasGrid();

  lbl_EstimTotal.Caption := 'Estimation du temps total nécessaire pour tous les B/R : ' + SecondToTime(vTotal);

  ChoixProchaineBase();

  Label3.Caption := 'Prochain Dossier : '+ FNext;
  if (FNext=CST_HORS_PLAGE)
    then Label3.Caption := CST_HORS_PLAGE;
  if (FNext=CST_TERMINE)
    then Label3.Caption := CST_TERMINE;
end;

procedure TFrm_MainBackup.LoadDatasGrid();
var i:integer;
begin
    FDMemTable1.DisableControls;
    FDMemTable1.Close;
    FDMemTable1.open;
    for I := Low(FBRGrid) to High(FBRGrid) do
        begin
           FDMemTable1.Append;
           FDMemTable1.FieldByName('ID').Asinteger     := FBRGrid[i].ID;
           FDMemTable1.FieldByName('DOSSIER').AsString := FBRGrid[i].DOSSIER;
           FDMemTable1.FieldByName('EASYSERVICE').AsString := FBRGrid[i].EASYSERVICE;
           FDMemTable1.FieldByName('IBFILE').AsString := FBRGrid[i].IBFILE;
           FDMemTable1.FieldByName('LASTOK').AsDateTime := FBRGrid[i].LASTBROK;
           FDMemTable1.FieldByName('LAST').AsDateTime   := FBRGrid[i].LASTBR;
           FDMemTable1.FieldByName('TIME').Asinteger    := FBRGrid[i].TIME;
           FDMemTable1.FieldByName('LASTRESULT').Asinteger := FBRGrid[i].LASTRESULT;
           FDMemTable1.FieldByName('BACKUP_Compression_7Z').AsInteger := FBRGrid[i].COMPRESS7Z;
           // FDMemTable1.FieldByName('BACKUP_WITH_OLD_IB').AsInteger := FBRGrid[i].WITHOLDIB;
//           FDMemTable1.FieldByName('LASTOPTIM').AsDateTime  := FBRGrid[i].LASTOPTIM;
           FDMemTable1.Post();
       end;
    FDMemTable1.EnableControls;
end;



procedure TFrm_MainBackup.FormCreate(Sender: TObject);
begin
  FStart := GetTickCount;
  SetLength(FBRGrid,0);
  FCanSave := false;
  FAuto := false;
  FSuspend := False;
  FETAPE   := '';
//  FStdStream := TStdStream.Create();
//  FStdStream.OnStdIn := OnStdIn;
  FCanClose       := true;
  lbl_EstimateTimeLeft.Visible:=false;
  LoadParamsGeneraux;
  LoadDossiers;
  FAuto := ParamStr(1)='AUTO';
  BSuspend.Visible:=false;
  if FAuto then
     begin
      BSuspend.Visible:=true;
      tAuto.Enabled:=true; /// Lancement dans x secondes...
      Caption := Caption + ' - Mode Auto';
      // on ne change pas les paramètres en mode AUTO
      tsOptions.Enabled:=false;
      // tsOptimisation.Enabled:=false;
     end;
  InfosEstimation;


   // Caption := Caption + ' - ' + FileVersion(ParamStr(0));
   Caption := Caption + ' - ' + GetInfo('Version');

   FCanSave:=true;
end;

// Met à jour la ligne (si on la trouve)
// on ne met jamais a jour directement !!! il faut toujours passer par FBRGrid maintenant
procedure TFrm_MainBackup.MAJMemData(aResult:Integer;aSecondes:integer;LibResult:string);
var vNow:TDateTime;
    i:integer;
begin
  for I := Low(FBRGrid) to High(FBRGrid) do
     begin
       if (FCurrentDossier = FBRGrid[i].DOSSIER)
          then
           begin
                //------------
                StatusBar1.Panels[0].Text := FCurrentIB;
                vNow := Now();
                SaveIntToIniFile(FCurrentDossier,'LASTRESULT',aResult);
                if (aResult=0) then
                  begin
                    SaveStrToIniFile(FCurrentDossier,'TIME',IntToStr(aSecondes));
                    SaveStrToIniFile(FCurrentDossier,'LASTOK',FormatDateTime('dd/mm/yyyy hh:nn:ss',vNow));
                    // SaveStrToIniFile(FCurrentDossier,'LASTOPTIM',FormatDateTime('dd/mm/yyyy hh:nn:ss',vNow));
                  end;
                FBRGrid[i].LASTRESULT :=aResult;
                if (aResult=0) then
                  begin
                    FBRGrid[i].TIME:= aSecondes;
                    FBRGrid[i].LASTBROK:=vNow;
                    // FBRGrid[i].LASTOPTIM:=vNow;
                  end;
              break;
           end;
     end;
  LoadDatasGrid();
{
   // FDMemTable1.DisableControls;
   if (FDMemTable1.Locate('DOSSIER',FCurrentDossier,[]))
     then
        begin
          //------------
          StatusBar1.Panels[0].Text := FCurrentIB;
          StatusBar1.Panels[2].Text := Format('%0.3f',[aSecondes]);
          If (aResult=0) then
            begin
              StatusBar1.Panels[1].Text := 'OK : Terminé';
            end
          else
            begin
              StatusBar1.Panels[1].Text := 'Erreur : ' + LibResult;
            end;
          // L'Etat du Dernier le temps et s'il a réussi le DernierLASTOK
          // dans le .ini
          vNow := Now();
          SaveIntToIniFile(FCurrentDossier,'LASTRESULT',aResult);
          if (aResult=0) then
            begin
              SaveStrToIniFile(FCurrentDossier,'TIME',FloatToStr(aSecondes));
              SaveStrToIniFile(FCurrentDossier,'LASTOK',FormatDateTime('dd/mm/yyyy hh:nn:ss',vNow));
            end;
          FDMemTable1.EnableControls;
          FDMemTable1.Edit;
          FDMemTable1.FieldByName('LASTRESULT').asinteger:=aResult;
          if (aResult=0) then
            begin
              FDMemTable1.FieldByName('TIME').AsFloat:=aSecondes;
              FDMemTable1.FieldByName('LASTOK').asDateTime:=vNow;
            end;
          FDMemTable1.Post;
          FDMemTable1.DisableControls;
        end;
   // FDMemTable1.EnableControls;
}
end;

procedure TFrm_MainBackup.CallBackCheckVersion(Sender:Tobject);
var vUrl:string;
begin
    try
       If (CompareVersion(TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion)<0)
        then
           begin
            If MessageDlg(PChar(Format('Nouvelle version disponible :  Voulez-vous faire la mise à jour ? '+#13+#10+#13+#10+
                                    'Votre version : %s '  +#13+#10+
                                    'Version disponible : %s '  +#13+#10
                              , [TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion ])),
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                begin
                   vUrl := TCheckUpdateThread(Sender).RemoteFile;
                   FExeUpdateThread := TExeUpdateThread.Create(Application.ExeName,vUrl,Lbl_Update,CallBackNewExeInstall);
                   FExeUpdateThread.Resume;
                   LockUpdate:=true;
                end
                else LockUpdate:=false;
           end
        else
          begin
            MessageDlg(PChar(Format('Le programme %s est à jour.'+#13+#10+#13+#10+
                                    'Votre version : %s '  +#13+#10+
                                    'Version disponible : %s '  +#13+#10
                              , [ExtractFileName(Application.ExeName),TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion ])),
             mtInformation, [mbOK], 0);
            LockUpdate:=false;
          end;
    finally
      // LockUpdate:=false; non pas là l'autre thread peut-etre lancer...
    end;
end;



procedure TFrm_MainBackup.CallBackNewExeInstall(Sender:Tobject);
begin
    try
      If (TExeUpdateThread(Sender).ShellUpdate) then
        begin
            // Inc(FNbBoucleUpdates);
            // Save_Ini_BoucleUpdates;
            //------------------ On relance-------------------------------------
            ShellExecute(0,'OPEN', PWideChar(Application.ExeName), nil, nil, SW_SHOW);
            Application.Terminate;
        end

    finally
      LockUpdate:=false;
    end;
end;


procedure TFrm_MainBackup.MettrejourClick(Sender: TObject);
begin
   FCheckUpdateThread := TCheckUpdateThread.Create(Application.ExeName,Lbl_Update,CallBackCheckVersion);
   FCheckUpdateThread.Resume;
   LockUpdate:=true;
end;

(*
procedure TFrm_MainBackup.TraitementOptimisations();
var i:integer;
    vIBFile:string;
    vBR : TBRRecord;
    vNow : TDateTime;
    vOPTIM_OPTIONS : string;
begin
  LoadDossiers;
  if not(Assigned(FOptimize))
    then
      begin
        for i := Low(FBRGrid) to High(FBRGrid) do
          begin
            // FBRGrid[i].LASTOPTIM := FBRGrid[i].LASTOPTIM;
            vNow := Now();
            if (vNow-FBRGrid[i].LASTOPTIM)>12/24 then
              begin
                DoLog('Optimisation :' + FBRGrid[i].DOSSIER);
                // 1 thread à la fois.... ==> donc Break
                // Si le BR est Ok et a moins de 12h c'est qu'il est bien passé....
                If (vNow-FBRGrid[i].LASTBROK)<12/24
                  then
                    begin
                      vOPTIM_OPTIONS := Copy(FOPTIM_OPTIONS,1,6);
                    end
                  else
                    begin
                      vOPTIM_OPTIONS := Copy(FOPTIM_OPTIONS,7,6);
                    end;

                FBRGrid[i].LASTOPTIM := vNow;
                SaveStrToIniFile(FBRGrid[i].DOSSIER,'LASTOPTIM',FormatDateTime('dd/mm/yyyy hh:nn:ss',vNow));

                FOptimize := TOptimizeDB.Create(
                  FBRGrid[i].IBFILE,
                  FBRGrid[i].DOSSIER,
                  // FBRGrid[i].EASYSERVICE,
                  vOPTIM_OPTIONS,
                  StatusCallback,
                  LogCallback,
                  OptimiseEndCallback);
                FOptimize.Start;
                exit;
              end;
          end;
         // --------------------------------------------------------------------
         // Si on passe la c'est que c'est tout fini////
         FETAPE:=CST_ETAPE_END;
         if FAuto and (FETAPE=CST_ETAPE_END)
            then
              begin
                  LoadDossiers;
                  FCanClose:=true;
                  InfosEstimation;
                  mLog.Lines.SaveToFile(ChangeFileExt(Application.ExeName,'.log')) ;
                  // Close;   //  Pour les Test je CLose pas
                  CloseInXSeconds(30);
                  exit;
              end;
         //---------------------------------------------------------------------
      end;
end;
*)


procedure TFrm_MainBackup.CloseInXseconds(const aSec:integer=30);
begin
   FTimeClose := aSec;
   tmAutoCloseInX.Enabled := true;
end;


procedure TFrm_MainBackup.OnTerminateThread(Sender: TObject);
var Ret : integer;
    vElapsed: TTimeSpan;
    vSecondes : integer;
    vTime     : TDateTime;
begin
  tmEstimate.Enabled:=false;
  pgEstimation.Visible:=false;
  if Assigned(FBackupRestore) then
  begin
    vElapsed := FStopwatch.Elapsed;
    vSecondes := Round(vElapsed.TotalSeconds);
    MAJMemData(FBackupRestore.ReturnValue,vSecondes,'');
  end;


  Lbl_EtapeActuelle.Caption:='';
  Lbl_EtapeActuelle.Visible:=false;
  lbl_EstimateTimeLeft.Visible:=False;
  lbl_DossierEncours.Caption := 'Dossier en cours : Aucun';
  ChoixProchaineBase();
  // Debut block à revoir
  if FAuto and (FETAPE=CST_ETAPE_END)
    then
      begin
          LoadDossiers;
          FCanClose:=true;
          // Close;   //  Pour les Test je CLose pas
          CloseInXSeconds(30);
          exit;
      end;
  // Fin block à revoir
  (*
  if FAuto and not(FSuspend) and (FETAPE=CST_ETAPE_OPTIM) then
    begin
        if (FOPTIM=1)
          then
             begin
                //  : Les Backup/Restore sont terminés pour ce cycle.
                DoLog('Etape des Optimisations');
                tmOPTIMISE.Enabled:=True;
                //--------------------------------------------------------------
                exit;
             end
        // Si on a pas coché... il faut bien sortir
        else
          begin
              FETAPE:=CST_ETAPE_END;
          end;
    end;
  *)
  if FAuto and not(FSuspend) and ((FETAPE=CST_TERMINE) or (FNext=CST_HORS_PLAGE)) then
    begin
      FETAPE:=CST_ETAPE_END;
      exit;
    end;

  if not(FSuspend) and (FNext<>CST_TERMINE) and (FNext<>CST_HORS_PLAGE)
      and (FETAPE=CST_ETAPE_BR) and LocateInFBRGrid(FNext)
    then
      begin
        ModeEnchainementAuto;
      end
    else
      begin
        LoadDossiers;
        FCanClose:=true;
      end;
end;

procedure TFrm_MainBackup.BSuspendClick(Sender: TObject);
begin
   FSuspend:=BSuspend.Down;
   if FSuspend
    then BSuspend.Caption:='Suspendu'
    else BSuspend.Caption:='Suspendre';
end;

procedure TFrm_MainBackup.tAutoTimer(Sender: TObject);
var vTc:Cardinal;
begin
   tAuto.Enabled := false;
   vTc := GetTickCount;
   StatusBar1.Panels[1].Text := FormatDateTime('hh:nn:ss',Now());
   If (FAuto) and (FCanClose) and not(FSuspend)
     then
      begin
        if (vTc-FStart>10000)
          then Lancement;
      end;
   tAuto.Enabled := true;
   // En Mode Auto Seulement
   // Time toute les minutes pour voir si on est dans la plage...
end;

procedure TFrm_MainBackup.tmAutoCloseInXTimer(Sender: TObject);
begin
   tmAutoCloseInX.Enabled := false;
   If (FAuto) and (FCanClose) and not(FSuspend)
     then
      begin
         Dec(FTimeClose);
         StatusBar1.Panels[0].Text := Format('Fermerture de l''application dans %d secondes',[FTimeClose]);
         if (FTimeClose<=0)
            then Close;
      end;
   tmAutoCloseInX.Enabled := true;
end;

procedure TFrm_MainBackup.tmEstimateTimer(Sender: TObject);
var vTimeLeft : Integer;
begin
  tmEstimate.Enabled:=false;
  try
    pgEstimation.StepIt;
    vTimeLeft := Math.Max(pgEstimation.Max-pgEstimation.Position,0);
    lbl_EstimateTimeLeft.Caption :=Format('Estimation du temps restant :  %s',[SecondToTime(vTimeLeft)]);
  finally
    tmEstimate.Enabled:=true;
  end;
end;


end.

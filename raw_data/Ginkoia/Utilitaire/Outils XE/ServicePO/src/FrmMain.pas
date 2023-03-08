unit FrmMain;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  SvcMgr,
  Dialogs,
  ExtCtrls,
  IniFiles,
  Generics.Collections,
  Traitements;

type
  TMainFrm = class(TService)
    TimerTrt: TTimer;
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure TimerTrtTimer(Sender: TObject);
  private
    { Déclarations privées }
    FIni : TIniFile;
    FTempo : integer;
    FNbTraitement : integer;
    FTraitements : TObjectList<TTraitement>;

    procedure ReadIni();
    procedure Traitement();
  public
    { Déclarations publiques }
    function GetServiceController: TServiceController; override;
  end;

var
  MainFrm: TMainFrm;

implementation

uses
  DateUtils,
  GestionLog,
  TypInfo;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MainFrm.Controller(CtrlCode);
end;

function TMainFrm.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TMainFrm.ServiceAfterInstall(Sender: TService);
begin
  Log_Write('  INSTALLATION !!');
end;

procedure TMainFrm.ServiceAfterUninstall(Sender: TService);
begin
  Log_Write('  DESINSTALLATION !!');
end;

procedure TMainFrm.ServiceCreate(Sender: TObject);
begin
  FTraitements := TObjectList<TTraitement>.Create(true);
  ReadIni();
  Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
  Log_Write('==============================');
  Log_Write('Démarage du service', el_Info);
end;

procedure TMainFrm.ServiceDestroy(Sender: TObject);
begin
  FreeAndNil(FTraitements);
  Log_Write('Fermture du service', el_Info);
  Log_Write('==============================');
  FreeAndNil(FIni);
end;

procedure TMainFrm.TimerTrtTimer(Sender: TObject);
begin
  if not (Status = csRunning) then
    Exit;

  Log_Write('Timer !!', el_Debug);
  try
    TimerTrt.Enabled := false;
    Traitement();
    TimerTrt.Interval := FTempo;
    Log_Write('Prochain time a : ' + FormatDateTime('hh:nn:ss.zzz', IncMilliSecond(Now(), TimerTrt.Interval)), el_Debug);
  finally
    TimerTrt.Enabled := true;
  end;
end;

procedure TMainFrm.ReadIni();
var
  i, idx : integer;
  Sections : TStringList;
  TraitementType : TTraitementClass;
begin
  if not Assigned(FIni) then
    FIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));

  FTempo := FIni.ReadInteger('Conf', 'Tempo', 60000);
  Log_ChangeNiv(TErrorLevel(FIni.ReadInteger('Conf', 'Log', 0)));

  Log_Write('Relecture du fichie de conf : ', el_Debug);
  Log_Write('  Interval : ' + IntToStr(FTempo) + 'ms', el_Debug);

  FTraitements.Clear();

  try
    i := 0;
    Sections := TStringList.Create();
    FIni.ReadSections(Sections);
    while i < Sections.Count do
    begin
      if not (Sections[i] = 'Conf') then
      begin
        TraitementType := TTraitement.GetTraitementClass(FIni.ReadInteger(Sections[i], 'Type', 0));
        if TraitementType = TDirTraitement then
          FTraitements.Add(TDirTraitement.Create(Sections[i],
                                                 Trim(FIni.ReadString(Sections[i], 'Source', '')),
                                                 Trim(FIni.ReadString(Sections[i], 'Destination', '')),
                                                 Trim(FIni.ReadString(Sections[i], 'Extention', '')),
                                                 FIni.ReadInteger(Sections[i], 'NbFichier', 0)))
        else if TraitementType = TFileTraitement then
          FTraitements.Add(TFileTraitement.Create(Sections[i],
                                                  Trim(FIni.ReadString(Sections[i], 'Source', '')),
                                                  Trim(FIni.ReadString(Sections[i], 'Destination', ''))))
        else if TraitementType = TZipTraitement then
          FTraitements.Add(TZipTraitement.Create(Sections[i],
                                                 Trim(FIni.ReadString(Sections[i], 'Source', '')),
                                                 Trim(FIni.ReadString(Sections[i], 'Destination', '')),
                                                 FIni.ReadInteger(Sections[i], 'NbFichier', 0)))
      end;
      Inc(i);
    end;
    Log_Write(' Status : ' + GetEnumName(TypeInfo(TCurrentStatus), Ord(Status)));
  finally
    FreeAndNil(Sections);
  end;
end;

procedure TMainFrm.Traitement();
var
  res, i, j : integer;
begin
  Log_Write('Traitement !!', el_Debug);

  try
    ReadIni();
    for i := 0 to FTraitements.Count -1 do
    begin
      FTraitements[i].Execute();
    end;
  except
    on e : Exception do
    begin
      Log_Write('Exception dans le traitement : ' + e.ClassName + ' - ' + e.Message, el_Erreur)
    end;
  end;
end;

end.

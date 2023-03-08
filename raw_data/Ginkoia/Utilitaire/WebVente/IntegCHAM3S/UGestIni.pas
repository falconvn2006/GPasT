unit UGestIni;

interface

uses System.IniFiles, System.IOUtils;

type
  TGestIni = class(TObject)
    private
      FIni : TIniFile;
      function GetBaseDossiers: string;
      procedure SetBaseDossiers(pCheminBase: string);
      function GetBaseMaitre: string;
      procedure SetBaseMaitre(pCheminBase: string);
      function GetDomaine: integer;
      procedure SetDomaine(pACTID: integer);
      function GetDateUpdate: TDateTime;
      procedure SetDateUpdate(pDate: TDateTime);
      function GetDelaiSupprDate: integer;
      procedure SetDelaiSupprDate(pDelai: integer);
      function GetASSCODE: integer;
      procedure SetASSCODE(pASSCODE: integer);
      function GetFrequence: integer;
      procedure SetFrequence(pMinutes: integer);
      function GetAuto: boolean;
      procedure SetAuto(pActif: boolean);
      function GetDateLancement: TDateTime;
      procedure SetDateLancement(pDate: TDateTime);
    public
      constructor Create(pIniFile: string); reintroduce;
      destructor Destroy; reintroduce;
      property BaseDossiers : string read GetBaseDossiers write SetBaseDossiers;
      property BaseMaitre   : string read GetBaseMaitre write SetBaseMaitre;
      property Domaine : integer read GetDomaine write SetDomaine;
      property ASSCODE : integer read GetASSCODE write SetASSCODE;
      property Frequence : integer read GetFrequence write SetFrequence;
      property DateUpdate: TDateTime read GetDateUpdate write SetDateUpdate;
      property DateLancement: TDateTime read GetDateLancement write SetDateLancement;
      property Auto: boolean read GetAuto write SetAuto;
      property DelaiSupprDate: integer read GetDelaiSupprDate write SetDelaiSupprDate;
  end;

implementation

{ TGestIni }

constructor TGestIni.Create(pIniFile: string);
begin
  inherited Create;
  FIni := TIniFile.Create(pIniFile);
end;

destructor TGestIni.Destroy;
begin
  FIni.Free;
  inherited Destroy;
end;

function TGestIni.GetASSCODE: integer;
begin
  Result :=  FIni.ReadInteger('GENERAL','ASSCODE',-1);
end;

function TGestIni.GetAuto: boolean;
begin
  Result := FIni.ReadBool('GENERAL','Auto',false);
end;

function TGestIni.GetBaseDossiers: string;
begin
  Result :=  FIni.ReadString('GENERAL','Base','');
end;

procedure TGestIni.SetASSCODE(pASSCODE: integer);
begin
    FIni.WriteInteger('GENERAL','ASSCODE',pASSCODE);
end;

procedure TGestIni.SetAuto(pActif: boolean);
begin
  FIni.WriteBool('GENERAL','Auto',pActif);
end;

procedure TGestIni.SetBaseDossiers(pCheminBase: string);
begin
  FIni.WriteString('GENERAL','Base',pCheminBase);
end;

function TGestIni.GetBaseMaitre: string;
begin
  Result :=  FIni.ReadString('GENERAL','BaseMaitre','');
end;

function TGestIni.GetDateLancement: TDateTime;
begin
  Result :=  FIni.ReadDateTime('GENERAL','DateLancement',0);
end;

function TGestIni.GetDateUpdate: TDateTime;
begin
  Result :=  FIni.ReadDateTime('GENERAL','DateUpdate',0);
end;

function TGestIni.GetDelaiSupprDate: integer;
begin
  Result :=  FIni.ReadInteger('GENERAL','DelaiSupprDate',30);
end;

function TGestIni.GetDomaine: integer;
begin
  Result :=  FIni.ReadInteger('GENERAL','Domaine',-1);
end;

function TGestIni.GetFrequence: integer;
begin
  Result :=  FIni.ReadInteger('GENERAL','Frequence',60);
end;

procedure TGestIni.SetBaseMaitre(pCheminBase: string);
begin
  FIni.WriteString('GENERAL','BaseMaitre',pCheminBase);
end;

procedure TGestIni.SetDateLancement(pDate: TDateTime);
begin
  FIni.WriteDateTime('GENERAL','DateLancement',pDate);
end;

procedure TGestIni.SetDateUpdate(pDate: TDateTime);
begin
  FIni.WriteDateTime('GENERAL','DateUpdate',pDate);
end;

procedure TGestIni.SetDelaiSupprDate(pDelai: integer);
begin
  FIni.WriteInteger('GENERAL','DelaiSupprDate',pDelai);
end;

procedure TGestIni.SetDomaine(pACTID: integer);
begin
  FIni.WriteInteger('GENERAL','Domaine',pACTID);
end;

procedure TGestIni.SetFrequence(pMinutes: integer);
begin
  FIni.WriteInteger('GENERAL','Frequence',pMinutes);
end;

end.

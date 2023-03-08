unit uMdlGinkoia;

interface

uses
  Classes, SysUtils, DB,

{$IFDEF CLIENT}
  dmdGINKOIA,
{$ELSE}
  dmdGINKOIA_XE7,
  System.Types,
{$ENDIF}
  Contnrs;

Const
  cRC = #13#10;
  cSqlListFieldByTableName = 'SELECT Distinct(s.rdb$field_name) as Field_Name' + cRC + 'FROM rdb$relation_fields s' + cRC +
    'WHERE rdb$Relation_Name = ''%s''';

Type
  { forward Declaration }
  TGnkPoste = Class;
  TGnkSociete = Class;
  TGnkConnexion = Class;

  TCustomGnk = Class(TComponent)
  private
    FUsedTransaction: Boolean;
    FFreeDmGINKOIA: Boolean;
  protected
    FADmGINKOIA: TdmGINKOIA;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); virtual;
    property UsedTransaction: Boolean read FUsedTransaction write FUsedTransaction;
    property ADmGINKOIA: TdmGINKOIA read FADmGINKOIA write FADmGINKOIA;
    property FreeDmGINKOIA: Boolean read FFreeDmGINKOIA write FFreeDmGINKOIA;
  End;

  TGnk = Class(TCustomGnk)
  private
    FDOSS_ID: integer;
  protected
    procedure SetDOSS_ID(const Value: integer); virtual;
  public
  published
    property DOSS_ID: integer read FDOSS_ID write SetDOSS_ID;
  End;

  TGnkGenerique = Class(TCustomGnk)
  private
    FVALUE: String;
  public
  published
    property Value: String read FVALUE write FVALUE;
  End;

  TGnkGrp = Class(TCustomGnk)
  private
    FGROU_NOM: String;
    FGROU_ID: integer;
  public
  published
    property GROU_ID: integer read FGROU_ID write FGROU_ID;
    property GROU_NOM: String read FGROU_NOM write FGROU_NOM;
  End;

  TGnkVersion = Class(TCustomGnk)
  private
    FVERS_NOMVERSION: String;
    FVERS_ID: integer;
    FVERS_EAI: String;
    FVERS_VERSION: String;
    FVERS_PATCH: integer;
  public
    procedure SetValuesByDataSet(const ADS: TDataSet); virtual;
  published
    property VERS_ID: integer read FVERS_ID write FVERS_ID;
    property VERS_VERSION: String read FVERS_VERSION write FVERS_VERSION;
    property VERS_NOMVERSION: String read FVERS_NOMVERSION write FVERS_NOMVERSION;
    property VERS_PATCH: integer read FVERS_PATCH write FVERS_PATCH;
    property VERS_EAI: String read FVERS_EAI write FVERS_EAI;
  End;

  TGnkGroupPump = Class(TCustomGnk)
  private
    FGCP_ID: integer;
    FGCP_NOM: string;
  published
    property GCP_ID: integer read FGCP_ID write FGCP_ID;
    property GCP_NOM: string read FGCP_NOM write FGCP_NOM;
  End;

  TGnkModule = Class(TCustomGnk)
  private
    FUGM_ID: integer;
    FUGG_ID: integer;
    FUGM_DATE: TDateTime;
    FUGM_MAGID: integer;
  published
    property UGM_ID: integer read FUGM_ID write FUGM_ID;
    property UGM_MAGID: integer read FUGM_MAGID write FUGM_MAGID;
    property UGG_ID: integer read FUGG_ID write FUGG_ID;
    property UGM_DATE: TDateTime read FUGM_DATE write FUGM_DATE;
  End;

  TGnkMagasin = Class(TCustomGnk)
  private
    FMAGA_ID: integer;
    FMAGA_NOM: String;
    FMAGA_ENSEIGNE: String;
    FMAGA_K_ENABLED: integer;
    FMAGA_CODEADH: String;
    FMAG_IDENT: String;
    FMAG_SOCID: integer;
    FMAG_NATURE: integer;
    FMAG_SS: integer;
    FMPU_ID: integer;
    FMPU_GCPID: integer;
    FCreateGrpPump: Boolean;
    FSociete: TGnkSociete;
    FIsExcludeGnkMAJ: Boolean;
    function GetModuleGnk(index: integer): TGnkModule;
    function GetModuleGnkByID(AUGM_ID: integer): TGnkModule;
    function GetCountMdl: integer;
    function GetCountPoste: integer;
    function GetPosteGnk(index: integer): TGnkPoste;
    function GetPosteGnkByID(APOST_POSID: integer): TGnkPoste;
  protected
    FListModule: TObjectList;
    FListPoste: TObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property IsExcludeGnkMAJ: Boolean read FIsExcludeGnkMAJ write FIsExcludeGnkMAJ;
    property CreateGrpPump: Boolean read FCreateGrpPump write FCreateGrpPump;

    procedure SetValuesByDataSet(const ADS: TDataSet); virtual;

    property CountMdl: integer read GetCountMdl;
    property ModuleGnk[index: integer]: TGnkModule read GetModuleGnk;
    property ModuleGnkByID[AUGM_ID: integer]: TGnkModule read GetModuleGnkByID;
    procedure AppendMdlGnk(Const AMdl: TGnkModule);
    procedure DeleteMdlGnk(Const AMdl: TGnkModule);

    property CountPoste: integer read GetCountPoste;
    property PosteGnk[index: integer]: TGnkPoste read GetPosteGnk;
    property PosteByID[APOST_ID: integer]: TGnkPoste read GetPosteGnkByID;
    property PosteGnkByID[APOST_POSID: integer]: TGnkPoste read GetPosteGnkByID;
    procedure AppendPosteGnk(Const APoste: TGnkPoste);
    procedure DeletePosteGnk(Const APoste: TGnkPoste);

    property ASociete: TGnkSociete read FSociete write FSociete;
  published
    property MAGA_ID: integer read FMAGA_ID write FMAGA_ID;
    property MAGA_NOM: String read FMAGA_NOM write FMAGA_NOM;
    property MAGA_ENSEIGNE: String read FMAGA_ENSEIGNE write FMAGA_ENSEIGNE;
    property MAGA_K_ENABLED: integer read FMAGA_K_ENABLED write FMAGA_K_ENABLED;
    property MAGA_CODEADH: String read FMAGA_CODEADH write FMAGA_CODEADH;
    property MAG_IDENT: String read FMAG_IDENT write FMAG_IDENT;
    property MAG_SOCID: integer read FMAG_SOCID write FMAG_SOCID;
    property MAG_NATURE: integer read FMAG_NATURE write FMAG_NATURE;
    property MAG_SS: integer read FMAG_SS write FMAG_SS;
    property MPU_ID: integer read FMPU_ID write FMPU_ID;
    property MPU_GCPID: integer read FMPU_GCPID write FMPU_GCPID;
    //property MAGA_BASID: Integer read FMAGA_BASID write FMAGA_BASID;
  End;

  TGnkSociete = Class(TCustomGnk)
  private
    FSOC_NOM: String;
    FSOC_ID: integer;
    FSOC_CLOTURE: TDateTime;
    FSOC_SSID: integer;
    function GetCountMag: integer;
    function GetMagasinGnk(index: integer): TGnkMagasin;
    function GetMagasinGnkByID(AMAG_ID: integer): TGnkMagasin;
  protected
    FListMag: TObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property CountMag: integer read GetCountMag;
    property MagasinGnk[index: integer]: TGnkMagasin read GetMagasinGnk;
    property MagasinGnkByID[AMAG_ID: integer]: TGnkMagasin read GetMagasinGnkByID;
    procedure AppendMagGnk(Const AMag: TGnkMagasin);
    procedure DeleteMagGnk(Const AMag: TGnkMagasin);
  published
    property SOC_ID: integer read FSOC_ID write FSOC_ID;
    property SOC_NOM: String read FSOC_NOM write FSOC_NOM;
    property SOC_CLOTURE: TDateTime read FSOC_CLOTURE write FSOC_CLOTURE;
    property SOC_SSID: integer read FSOC_SSID write FSOC_SSID;
  End;

  TGnkPoste = Class(TCustomGnk)
  private
    FPOST_ID: integer;
    FPOST_POSID: integer;
    FPOST_NOM: String;
    FPOST_INFO: String;
    FPOST_MAGID: integer;
    FPOST_COMPTA: String;
    FIsExcludeGnkMAJ: Boolean;
  public
    property IsExcludeGnkMAJ: Boolean read FIsExcludeGnkMAJ write FIsExcludeGnkMAJ;
    procedure SetValuesByDataSet(const ADS: TDataSet); virtual;
  published
    property POST_ID: integer read FPOST_ID write FPOST_ID;
    property POST_POSID: integer read FPOST_POSID write FPOST_POSID;
    property POST_NOM: String read FPOST_NOM write FPOST_NOM;
    property POST_INFO: String read FPOST_INFO write FPOST_INFO;
    property POST_MAGID: integer read FPOST_MAGID write FPOST_MAGID;
    property POST_COMPTA: String read FPOST_COMPTA write FPOST_COMPTA;
  End;

  TGnkBase = Class(TCustomGnk)
  private
  var
    FBAS_ID: integer;
    FBAS_NOM: String;
    FBAS_IDENT: String;
    FBAS_JETON: integer;
    FBAS_PLAGE: String;
    FBAS_SENDER: String;
    FBAS_GUID: String;
    FBAS_CENTRALE: String;
    FBAS_NOMPOURNOUS: String;
    FBAS_RGPID: integer;
    FBAS_TYPE: integer;
    FBAS_MAGID: integer;
    FBAS_SECBASID: integer;
    FBAS_SYNCHRO: integer;
    FBAS_CODETIERS: String;
    FVersion: TGnkVersion;
    FVERS_VERSION: String;
    FLAU_AUTORUN: integer;
    FLAU_BACKTIME: TDateTime;
    FLAU_BACK: integer;
    FLAU_ID: integer;
    FPRM_ID: integer;
    FPRM_POS: integer;
    FVERS_ID: integer;
    FIsExcludeGnkMAJ: Boolean;
    FLAU_HEURE2: TDateTime;
    FLAU_HEURE1: TDateTime;
    FLAU_H2: integer;
    FLAU_H1: integer;
    function GetConnexionGnk(index: integer): TGnkConnexion;
    function GetConnexionGnkByID(ACON_ID: integer): TGnkConnexion;
    function GetCountConnexion: integer;
    function GetVERS_ID: integer;
    function GetVERS_VERSION: String;
  protected
    FListCon: TObjectList;
    function GetBAS_NOM: String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property IsExcludeGnkMAJ: Boolean read FIsExcludeGnkMAJ write FIsExcludeGnkMAJ;

    procedure SetValuesByDataSet(Const ADS: TDataSet); virtual;

    property CountConnexion: integer read GetCountConnexion;
    property ConnexionGnk[index: integer]: TGnkConnexion read GetConnexionGnk;
    property ConnexionGnkByID[ACON_ID: integer]: TGnkConnexion read GetConnexionGnkByID;
    procedure AppendConnexionGnk(Const ACon: TGnkConnexion);
    procedure DeleteConnexionGnk(Const ACon: TGnkConnexion);

    property AVersion: TGnkVersion read FVersion write FVersion;
  published
    property VERS_VERSION: String read GetVERS_VERSION write FVERS_VERSION;
    property VERS_ID: integer read GetVERS_ID write FVERS_ID;

    property BAS_ID: integer read FBAS_ID write FBAS_ID;
    property BAS_NOM: String read GetBAS_NOM write FBAS_NOM;
    property BAS_IDENT: String read FBAS_IDENT write FBAS_IDENT;
    property BAS_JETON: integer read FBAS_JETON write FBAS_JETON;
    property BAS_PLAGE: String read FBAS_PLAGE write FBAS_PLAGE;
    property BAS_SENDER: String read FBAS_SENDER write FBAS_SENDER;
    property BAS_GUID: String read FBAS_GUID write FBAS_GUID;
    property BAS_CENTRALE: String read FBAS_CENTRALE write FBAS_CENTRALE;
    property BAS_NOMPOURNOUS: String read FBAS_NOMPOURNOUS write FBAS_NOMPOURNOUS;
    property BAS_RGPID: integer read FBAS_RGPID write FBAS_RGPID;
    property BAS_TYPE: integer read FBAS_TYPE write FBAS_TYPE;
    property BAS_MAGID: integer read FBAS_MAGID write FBAS_MAGID;
    property BAS_SECBASID: integer read FBAS_SECBASID write FBAS_SECBASID;
    property BAS_SYNCHRO: integer read FBAS_SYNCHRO write FBAS_SYNCHRO;
    property BAS_CODETIERS: String read FBAS_CODETIERS write FBAS_CODETIERS;
    property LAU_ID: integer read FLAU_ID write FLAU_ID;
    property LAU_HEURE1: TDateTime read FLAU_HEURE1 write FLAU_HEURE1;
    property LAU_H1: integer read FLAU_H1 write FLAU_H1;
    property LAU_HEURE2: TDateTime read FLAU_HEURE2 write FLAU_HEURE2;
    property LAU_H2: integer read FLAU_H2 write FLAU_H2;
    property LAU_AUTORUN: integer read FLAU_AUTORUN write FLAU_AUTORUN;
    property LAU_BACK: integer read FLAU_BACK write FLAU_BACK;
    property LAU_BACKTIME: TDateTime read FLAU_BACKTIME write FLAU_BACKTIME;
    property PRM_ID: integer read FPRM_ID write FPRM_ID;
    property PRM_POS: integer read FPRM_POS write FPRM_POS;
  End;

  TGnkConnexion = Class(TCustomGnk)
  private
    FCON_ORDRE: integer;
    FCON_NOM: String;
    FCON_ID: integer;
    FCON_TEL: String;
    FCON_TYPE: integer;
    FCON_LAUID: integer;
    FBase: TGnkBase;
  protected
    function GetCON_LAUID: integer; virtual;
  public
    procedure SetValuesByDataSet(const ADS: TDataSet); virtual;

    property ABase: TGnkBase read FBase write FBase;
  published
    property CON_ID: integer read FCON_ID write FCON_ID;
    property CON_LAUID: integer read GetCON_LAUID write FCON_LAUID;
    property CON_NOM: String read FCON_NOM write FCON_NOM;
    property CON_TEL: String read FCON_TEL write FCON_TEL;
    property CON_TYPE: integer read FCON_TYPE write FCON_TYPE;
    property CON_ORDRE: integer read FCON_ORDRE write FCON_ORDRE;
  End;

  TGnkArticle = Class(TCustomGnk)
  private
    FART_ID: integer;
    FART_GAMME: string;
    FART_CODECENTRALE: string;
    FART_DESCRIPTION: string;
    FART_CPTANA: string;
    FART_SUPPRIME: integer;
    FART_POS: string;
    FART_COMENT2: string;
    FART_COMENT3: string;
    FART_REFREMPLACE: integer;
    FART_TAILLES: string;
    FART_COMENT1: string;
    FART_GAMPRODUIT: string;
    FART_GARID: integer;
    FART_ORIGINE: integer;
    FART_COMENT4: string;
    FART_COMENT5: string;
    FART_PUB: integer;
    FART_POINT: string;
    FART_SESSION: string;
    FART_IDREF: integer;
    FART_GAMPF: string;
    FART_THEME: string;
    FART_GREID: integer;
    FART_GTFID: integer;
    FART_SSFID: integer;
    FART_CODEGS: integer;
    FART_MRKID: integer;
    FART_REFMRK: string;
    FART_NOM: string;
    FCOU_CODE: string;
    FCOU_NOM: string;
    FCOU_ID: integer;
    FTGF_NOM: string;
    FTGF_ID: integer;
    FSTC_ID: integer;
    FSTC_QTE: integer;
    FPVT_PX: Real;
    FPVT_ID: integer;
  public
  published
    property ART_ID: integer read FART_ID write FART_ID;
    property ART_IDREF: integer read FART_IDREF write FART_IDREF;
    property ART_NOM: string read FART_NOM write FART_NOM;
    property ART_ORIGINE: integer read FART_ORIGINE write FART_ORIGINE;
    property ART_DESCRIPTION: string read FART_DESCRIPTION write FART_DESCRIPTION;
    property ART_MRKID: integer read FART_MRKID write FART_MRKID;
    property ART_REFMRK: string read FART_REFMRK write FART_REFMRK;
    property ART_SSFID: integer read FART_SSFID write FART_SSFID;
    property ART_PUB: integer read FART_PUB write FART_PUB;
    property ART_GTFID: integer read FART_GTFID write FART_GTFID;
    property ART_SESSION: string read FART_SESSION write FART_SESSION;
    property ART_GREID: integer read FART_GREID write FART_GREID;
    property ART_THEME: string read FART_THEME write FART_THEME;
    property ART_GAMME: string read FART_GAMME write FART_GAMME;
    property ART_CODECENTRALE: string read FART_CODECENTRALE write FART_CODECENTRALE;
    property ART_TAILLES: string read FART_TAILLES write FART_TAILLES;
    property ART_POS: string read FART_POS write FART_POS;
    property ART_GAMPF: string read FART_GAMPF write FART_GAMPF;
    property ART_POINT: string read FART_POINT write FART_POINT;
    property ART_GAMPRODUIT: string read FART_GAMPRODUIT write FART_GAMPRODUIT;
    property ART_SUPPRIME: integer read FART_SUPPRIME write FART_SUPPRIME;
    property ART_REFREMPLACE: integer read FART_REFREMPLACE write FART_REFREMPLACE;
    property ART_GARID: integer read FART_GARID write FART_GARID;
    property ART_CODEGS: integer read FART_CODEGS write FART_CODEGS;
    property ART_COMENT1: string read FART_COMENT1 write FART_COMENT1;
    property ART_COMENT2: string read FART_COMENT2 write FART_COMENT2;
    property ART_COMENT3: string read FART_COMENT3 write FART_COMENT3;
    property ART_COMENT4: string read FART_COMENT4 write FART_COMENT4;
    property ART_COMENT5: string read FART_COMENT5 write FART_COMENT5;
    property ART_CPTANA: string read FART_CPTANA write FART_CPTANA;
    { Couleur }
    property COU_ID: integer read FCOU_ID write FCOU_ID;
    property COU_CODE: string read FCOU_CODE write FCOU_CODE;
    property COU_NOM: string read FCOU_NOM write FCOU_NOM;
    { Taille }
    property TGF_ID: integer read FTGF_ID write FTGF_ID;
    property TGF_NOM: string read FTGF_NOM write FTGF_NOM;
    { Stock }
    property STC_ID: integer read FSTC_ID write FSTC_ID;
    property STC_QTE: integer read FSTC_QTE write FSTC_QTE;
    { Tarif }
    property PVT_ID: integer read FPVT_ID write FPVT_ID;
    property PVT_PX: Real read FPVT_PX write FPVT_PX;
  End;

implementation

{ TGnkMagasin }

procedure TGnkMagasin.AppendMdlGnk(const AMdl: TGnkModule);
begin
  if ModuleGnkByID[AMdl.UGG_ID] = nil then
    FListModule.Add(AMdl);
end;

procedure TGnkMagasin.AppendPosteGnk(const APoste: TGnkPoste);
begin
  if PosteGnkByID[APoste.POST_POSID] = nil then
    FListPoste.Add(APoste);
end;

constructor TGnkMagasin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListModule := TObjectList.Create(False);
  FListPoste := TObjectList.Create(True);
  FIsExcludeGnkMAJ := False;
  FCreateGrpPump := False;
end;

procedure TGnkMagasin.DeleteMdlGnk(const AMdl: TGnkModule);
begin
  FListModule.Extract(AMdl);
end;

procedure TGnkMagasin.DeletePosteGnk(const APoste: TGnkPoste);
begin
  FListPoste.Remove(APoste);
end;

destructor TGnkMagasin.Destroy;
begin
  FreeAndNil(FListModule);
  FreeAndNil(FListPoste);
  inherited Destroy;
end;

function TGnkMagasin.GetCountMdl: integer;
begin
  Result := FListModule.Count;
end;

function TGnkMagasin.GetCountPoste: integer;
begin
  Result := FListPoste.Count;
end;

function TGnkMagasin.GetModuleGnk(index: integer): TGnkModule;
begin
  Result := TGnkModule(FListModule.Items[index]);
end;

function TGnkMagasin.GetModuleGnkByID(AUGM_ID: integer): TGnkModule;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListModule.Count - 1 do
  begin
    if ModuleGnk[i].UGM_ID = AUGM_ID then
    begin
      Result := ModuleGnk[i];
      Break;
    end;
  end;
end;

function TGnkMagasin.GetPosteGnk(index: integer): TGnkPoste;
begin
  Result := TGnkPoste(FListPoste.Items[index]);
end;

function TGnkMagasin.GetPosteGnkByID(APOST_POSID: integer): TGnkPoste;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListPoste.Count - 1 do
  begin
    if PosteGnk[i].POST_POSID = APOST_POSID then
    begin
      Result := PosteGnk[i];
      Break;
    end;
  end;
end;

procedure TGnkMagasin.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('MAGA_ENSEIGNE');
  if vField <> nil then
    MAGA_ENSEIGNE := vField.AsString;

  vField := ADS.FindField('MAGA_K_ENABLED');
  if vField <> nil then
    MAGA_K_ENABLED := vField.AsInteger;

  vField := ADS.FindField('MAGA_CODEADH');
  if vField <> nil then
    MAGA_CODEADH := vField.AsString;

  vField := ADS.FindField('MAGA_NOM');
  if vField <> nil then
    MAGA_NOM := vField.AsString;

  vField := ADS.FindField('MAGA_ID');
  if vField <> nil then
    MAGA_ID := vField.AsInteger;

  vField := ADS.FindField('MAG_SOCID');
  if vField <> nil then
    MAG_SOCID := vField.AsInteger;

  vField := ADS.FindField('MAG_SS');
  if vField <> nil then
    MAG_SS := vField.AsInteger;

  vField := ADS.FindField('MAG_NATURE');
  if vField <> nil then
    MAG_NATURE := vField.AsInteger;

  vField := ADS.FindField('MAG_IDENT');
  if vField <> nil then
    MAG_IDENT := vField.AsString;

  vField := ADS.FindField('MPU_ID');
  if vField <> nil then
    MPU_ID := vField.AsInteger;

  vField := ADS.FindField('MPU_GCPID');
  if vField <> nil then
    MPU_GCPID := vField.AsInteger;

//  vField := ADS.FindField('MAGA_BASID');
//  if vField <> nil then
//    MAGA_BASID := vField.AsInteger;
//  MAGA_BASID := 50;

end;

{ TGnkSociete }

procedure TGnkSociete.AppendMagGnk(const AMag: TGnkMagasin);
begin
  if MagasinGnkByID[AMag.MAGA_ID] = nil then
    FListMag.Add(AMag);
end;

constructor TGnkSociete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListMag := TObjectList.Create(False);
end;

procedure TGnkSociete.DeleteMagGnk(const AMag: TGnkMagasin);
begin
  FListMag.Extract(AMag);
end;

destructor TGnkSociete.Destroy;
begin
  FreeAndNil(FListMag);
  inherited Destroy;
end;

function TGnkSociete.GetCountMag: integer;
begin
  Result := FListMag.Count;
end;

function TGnkSociete.GetMagasinGnk(index: integer): TGnkMagasin;
begin
  Result := TGnkMagasin(FListMag.Items[index]);
end;

function TGnkSociete.GetMagasinGnkByID(AMAG_ID: integer): TGnkMagasin;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMag.Count - 1 do
  begin
    if MagasinGnk[i].MAGA_ID = AMAG_ID then
    begin
      Result := MagasinGnk[i];
      Break;
    end;
  end;
end;

{ TGnkBase }

procedure TGnkBase.AppendConnexionGnk(const ACon: TGnkConnexion);
begin
  if ConnexionGnkByID[ACon.CON_ID] = nil then
    FListCon.Add(ACon);
end;

constructor TGnkBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsExcludeGnkMAJ := False;
  FListCon := TObjectList.Create(True);
end;

procedure TGnkBase.DeleteConnexionGnk(const ACon: TGnkConnexion);
begin
  FListCon.Remove(ACon);
end;

destructor TGnkBase.Destroy;
begin
  FreeAndNil(FListCon);
  inherited Destroy;
end;

function TGnkBase.GetBAS_NOM: String;
begin
  Result := FBAS_NOM;
end;

function TGnkBase.GetConnexionGnk(index: integer): TGnkConnexion;
begin
  Result := TGnkConnexion(FListCon.Items[index]);
end;

function TGnkBase.GetConnexionGnkByID(ACON_ID: integer): TGnkConnexion;
var
  i: integer;
begin
  Result := nil;
  if FListCon <> nil then
  begin
    for i := 0 to FListCon.Count - 1 do
    begin
      if ConnexionGnk[i].CON_ID = ACON_ID then
      begin
        Result := ConnexionGnk[i];
        Break;
      end;
    end;
  end;
end;

function TGnkBase.GetCountConnexion: integer;
begin
  Result := FListCon.Count;
end;

function TGnkBase.GetVERS_ID: integer;
begin
  Result := FVERS_ID;
  if FVersion <> nil then
    Result := FVersion.VERS_ID;
end;

function TGnkBase.GetVERS_VERSION: String;
begin
  Result := FVERS_VERSION;
  if FVersion <> nil then
    Result := FVersion.VERS_VERSION;
end;

procedure TGnkBase.SetValuesByDataSet(Const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('BAS_SECBASID');
  if vField <> nil then
    BAS_SECBASID := vField.AsInteger;

  vField := ADS.FindField('BAS_CENTRALE');
  if vField <> nil then
    BAS_CENTRALE := vField.AsString;

  vField := ADS.FindField('BAS_RGPID');
  if vField <> nil then
    BAS_RGPID := vField.AsInteger;

  vField := ADS.FindField('BAS_ID');
  if vField <> nil then
    BAS_ID := vField.AsInteger;

  vField := ADS.FindField('BAS_SYNCHRO');
  if vField <> nil then
    BAS_SYNCHRO := vField.AsInteger;

  vField := ADS.FindField('BAS_TYPE');
  if vField <> nil then
    BAS_TYPE := vField.AsInteger;

  vField := ADS.FindField('BAS_SENDER');
  if vField <> nil then
    BAS_SENDER := vField.AsString;

  vField := ADS.FindField('BAS_NOMPOURNOUS');
  if vField <> nil then
    BAS_NOMPOURNOUS := vField.AsString;

  vField := ADS.FindField('VERS_VERSION');
  if vField <> nil then
    VERS_VERSION := vField.AsString;

  vField := ADS.FindField('LAU_AUTORUN');
  if vField <> nil then
    LAU_AUTORUN := vField.AsInteger;

  vField := ADS.FindField('LAU_BACKTIME');
  if vField <> nil then
    LAU_BACKTIME := vField.AsDateTime;

  vField := ADS.FindField('LAU_BACK');
  if vField <> nil then
    LAU_BACK := vField.AsInteger;

  vField := ADS.FindField('LAU_ID');
  if vField <> nil then
    LAU_ID := vField.AsInteger;

  vField := ADS.FindField('PRM_ID');
  if vField <> nil then
    PRM_ID := vField.AsInteger;

  vField := ADS.FindField('PRM_POS');
  if vField <> nil then
    PRM_POS := vField.AsInteger;

  vField := ADS.FindField('BAS_GUID');
  if vField <> nil then
    BAS_GUID := vField.AsString;

  vField := ADS.FindField('BAS_NOM');
  if vField <> nil then
    BAS_NOM := vField.AsString;

  vField := ADS.FindField('VERS_ID');
  if vField <> nil then
    VERS_ID := vField.AsInteger;

  vField := ADS.FindField('BAS_MAGID');
  if vField <> nil then
    BAS_MAGID := vField.AsInteger;

  vField := ADS.FindField('BAS_CODETIERS');
  if vField <> nil then
    BAS_CODETIERS := vField.AsString;

  vField := ADS.FindField('BAS_IDENT');
  if vField <> nil then
    BAS_IDENT := vField.AsString;

  vField := ADS.FindField('BAS_JETON');
  if vField <> nil then
    BAS_JETON := vField.AsInteger;

  vField := ADS.FindField('BAS_PLAGE');
  if vField <> nil then
    BAS_PLAGE := vField.AsString;

  vField := ADS.FindField('LAU_HEURE2');
  if vField <> nil then
    LAU_HEURE2 := vField.AsDateTime;

  vField := ADS.FindField('LAU_HEURE1');
  if vField <> nil then
    LAU_HEURE1 := vField.AsDateTime;

  vField := ADS.FindField('LAU_H2');
  if vField <> nil then
    LAU_H2 := vField.AsInteger;

  vField := ADS.FindField('LAU_H1');
  if vField <> nil then
    LAU_H1 := vField.AsInteger;
end;

{ TGnkConnexion }

function TGnkConnexion.GetCON_LAUID: integer;
begin
  Result := FCON_LAUID;
end;

procedure TGnkConnexion.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('CON_ORDRE');
  if vField <> nil then
    CON_ORDRE := vField.AsInteger;

  vField := ADS.FindField('CON_NOM');
  if vField <> nil then
    CON_NOM := vField.AsString;

  vField := ADS.FindField('CON_ID');
  if vField <> nil then
    CON_ID := vField.AsInteger;

  vField := ADS.FindField('CON_TEL');
  if vField <> nil then
    CON_TEL := vField.AsString;

  vField := ADS.FindField('CON_TYPE');
  if vField <> nil then
    CON_TYPE := vField.AsInteger;

  vField := ADS.FindField('CON_LAUID');
  if vField <> nil then
    CON_LAUID := vField.AsInteger;
end;

{ TCustomGnk }

constructor TCustomGnk.Create(AOwner: TComponent);
begin
  inherited;
  FADmGINKOIA := nil;
  FFreeDmGINKOIA := True;
end;

destructor TCustomGnk.Destroy;
begin
  if (FADmGINKOIA <> nil) and (FFreeDmGINKOIA) then
    FreeAndNil(FADmGINKOIA);
  inherited;
end;

procedure TCustomGnk.MAJ(const AAction: TUpdateKind);
begin
  // -->
end;

{ TGnkVersion }

procedure TGnkVersion.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('VERS_ID');
  if vField <> nil then
    VERS_ID := vField.AsInteger;

  vField := ADS.FindField('VERS_VERSION');
  if vField <> nil then
    VERS_VERSION := vField.AsString;

  vField := ADS.FindField('VERS_NOMVERSION');
  if vField <> nil then
    VERS_NOMVERSION := vField.AsString;

  vField := ADS.FindField('VERS_PATCH');
  if vField <> nil then
    VERS_PATCH := vField.AsInteger;

  vField := ADS.FindField('VERS_EAI');
  if vField <> nil then
    VERS_EAI := vField.AsString;
end;

{ TGnk }

procedure TGnk.SetDOSS_ID(const Value: integer);
begin
  FDOSS_ID := Value;
end;

{ TGnkPoste }

procedure TGnkPoste.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('POST_POSID');
  if vField <> nil then
    POST_POSID := vField.AsInteger;

  vField := ADS.FindField('POST_NOM');
  if vField <> nil then
    POST_NOM := vField.AsString;

  vField := ADS.FindField('POST_INFO');
  if vField <> nil then
    POST_INFO := vField.AsString;

  vField := ADS.FindField('POST_MAGID');
  if vField <> nil then
    POST_MAGID := vField.AsInteger;

  vField := ADS.FindField('POST_COMPTA');
  if vField <> nil then
    POST_COMPTA := vField.AsString;
end;

end.

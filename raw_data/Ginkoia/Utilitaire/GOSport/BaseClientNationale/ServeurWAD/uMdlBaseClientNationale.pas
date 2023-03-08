unit uMdlBaseClientNationale;

interface

{$M+}

uses
  Classes, SysUtils, Contnrs, ADODB, DB, Variants;

Type
  TCustomGnk = Class
  private
  protected
    function ControlRequiedField: String; virtual;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify; Import : boolean = false); virtual;
    procedure SetValuesByDataSet(const ADS: TDataSet); virtual; abstract;
  End;

  TExportLog = Class(TCustomGnk)
  private
    FEXP_DATELASTEXPORT: TDate;
    FEXP_FICHIER: String;
    FEXP_HEURE: TDateTime;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify; Import : boolean = false); override;
    procedure SetValuesByDataSet(const ADS: TDataSet); override;
  published
    property EXP_HEURE: TDateTime read FEXP_HEURE write FEXP_HEURE;
    property EXP_FICHIER: String read FEXP_FICHIER write FEXP_FICHIER;
    property EXP_DATELASTEXPORT: TDate read FEXP_DATELASTEXPORT write FEXP_DATELASTEXPORT;
  End;

  TBonRepris = Class(TCustomGnk)
  private
    FBRP_CODEBON: String;
    FBRP_ENSID: integer;
    FBRP_NUMCARTE: String;
    FBRP_MAG: String;
    FBRP_DATE: TDateTime;
    FBRP_TRAITE: integer;
    FBRP_NUMTCK: integer;
    FBRP_ID: integer;
  protected
    function ControlRequiedField: String; override;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify; Import : boolean = false); override;
    procedure SetValuesByDataSet(const ADS: TDataSet); override;
  published
    property BRP_ID: integer read FBRP_ID write FBRP_ID;
    property BRP_ENSID: integer read FBRP_ENSID write FBRP_ENSID;
    property BRP_NUMTCK: integer read FBRP_NUMTCK write FBRP_NUMTCK;
    property BRP_MAG: String read FBRP_MAG write FBRP_MAG;
    property BRP_DATE: TDateTime read FBRP_DATE write FBRP_DATE;
    property BRP_CODEBON: String read FBRP_CODEBON write FBRP_CODEBON;
    property BRP_NUMCARTE: String read FBRP_NUMCARTE write FBRP_NUMCARTE;
    property BRP_TRAITE: integer read FBRP_TRAITE write FBRP_TRAITE;
  End;

  TCliOldCards = Class(TCustomGnk)
  private
    FCOC_NUMCARTE: String;
    FCOC_CLIID: integer;
    FCOC_ID: integer;
  protected
    function IsExist: Boolean;
  public
    procedure MAJ; overload;
    procedure SetValuesByDataSet(const ADS: TDataSet); override;
  published
    property COC_ID: integer read FCOC_ID write FCOC_ID;
    property COC_CLIID: integer read FCOC_CLIID write FCOC_CLIID;
    property COC_NUMCARTE: String read FCOC_NUMCARTE write FCOC_NUMCARTE;
  End;

  TPoints = Class(TCustomGnk)
  private
    FPTS_NBPOINTS: real;
    FPTS_DATE: TDateTime;
    FPTS_ID: integer;
    FPTS_ENSID: integer;
    FPTS_NUMCARTE: String;
  protected
    function ControlRequiedField: String; override;
    function IsExist: Boolean;
  public
    constructor Create;
    procedure MAJ(Const AAction: TUpdateKind = ukModify; Import : boolean = false); override;
    procedure SetValuesByDataSet(const ADS: TDataSet); override;
  published
    property PTS_ID: integer read FPTS_ID write FPTS_ID;
    property PTS_NUMCARTE: String read FPTS_NUMCARTE write FPTS_NUMCARTE;
    property PTS_ENSID: integer read FPTS_ENSID write FPTS_ENSID;
    property PTS_NBPOINTS: real read FPTS_NBPOINTS write FPTS_NBPOINTS;
    property PTS_DATE: TDateTime read FPTS_DATE write FPTS_DATE;
  End;

  TClient = Class(TCustomGnk)
  private
    FListBonRepris: TObjectList;
    FListCliOldCards: TObjectList;
    FCLI_CREATION: integer;
    FCLI_TOPVIB: String;
    FCLI_IDETO: String;
    FCLI_OPTIN: String;
    FCLI_TOPVIBUTIL: integer;
    FCLI_MAGMODIF: String;
    FCLI_TOPSAL: String;
    FCLI_CP: String;
    FCLI_TOPNPAI: String;
    FCLI_MODIF: integer;
    FCLI_MAGORIG: String;
    FCLI_EMAIL: String;
    FCLI_ADR2: String;
    FCLI_CIV: String;
    FCLI_CODEPROF: String;
    FCLI_ADR3: String;
    FCLI_DTCREATION: TDateTime;
    FCLI_TEL2: String;
    FCLI_ADR1: String;
    FCLI_DTNAISS: TDateTime;
    FCLI_TEL1: String;
    FCLI_ADR4: String;
    FCLI_PRENOM: String;
    FCLI_NOM: String;
    FCLI_DTMODIF: TDateTime;
    FCLI_DTRENOUV: TDateTime;
    FCLI_CODERFM: String;
    FCLI_ID: integer;
    FCLI_REMRENOUV: integer;
    FCLI_MAGCREA: String;
    FCLI_CODEPAYS: String;
    FCLI_DTVAL: TDateTime;
    FCLI_VILLE: String;
    FCLI_OPTINPART: String;
    FCLI_ENSID: integer;
    FCLI_DTSUP: TDateTime;
    FCLI_CODECLUB: String;
    FCLI_BLACKLIST: String;
    FCLI_AUTRESP: String;
    FCLI_NUMCARTE: String;

    FCLI_RETMAIL : string;
    FCLI_QUALITE : string;

    FCLI_TYPEFID : integer;

    FCLI_CSTTEL : string;
    FCLI_CSTMAIL : string;
    FCLI_CSTCGV : string;
    FCLI_DESACTIVE: Integer;

    FPoints: TPoints;

    function GetBonRepris(index: integer): TBonRepris;
    function GetBonReprisByBRP_CODEBON(const ABRP_CODEBON: String): TBonRepris;
  protected
    function ControlRequiedField: String; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify; Import : boolean = false); override;
    procedure SetValuesByDataSet(const ADS: TDataSet); override;

    { BonRepris }
    function CountBonRepris: integer;
    property BonRepris[index: integer]: TBonRepris read GetBonRepris;
    property BonReprisByBRP_CODEBON[Const ABRP_CODEBON: String]: TBonRepris read GetBonReprisByBRP_CODEBON;
    procedure AddBonRepris(Const ABonRepris: TBonRepris);
    procedure LoadBonRepris;

  published
    property CLI_ID: integer read FCLI_ID write FCLI_ID;
    property CLI_IDETO: String read FCLI_IDETO write FCLI_IDETO;
    property CLI_NUMCARTE: String read FCLI_NUMCARTE write FCLI_NUMCARTE;
    property CLI_ENSID: integer read FCLI_ENSID write FCLI_ENSID;
    property CLI_DTVAL: TDateTime read FCLI_DTVAL write FCLI_DTVAL;
    property CLI_CODECLUB: String read FCLI_CODECLUB write FCLI_CODECLUB;
    property CLI_CIV: String read FCLI_CIV write FCLI_CIV;
    property CLI_NOM: String read FCLI_NOM write FCLI_NOM;
    property CLI_PRENOM: String read FCLI_PRENOM write FCLI_PRENOM;
    property CLI_ADR1: String read FCLI_ADR1 write FCLI_ADR1;
    property CLI_ADR2: String read FCLI_ADR2 write FCLI_ADR2;
    property CLI_ADR3: String read FCLI_ADR3 write FCLI_ADR3;
    property CLI_ADR4: String read FCLI_ADR4 write FCLI_ADR4;
    property CLI_CP: String read FCLI_CP write FCLI_CP;
    property CLI_VILLE: String read FCLI_VILLE write FCLI_VILLE;
    property CLI_CODEPAYS: String read FCLI_CODEPAYS write FCLI_CODEPAYS;
    property CLI_TEL1: String read FCLI_TEL1 write FCLI_TEL1;
    property CLI_TEL2: String read FCLI_TEL2 write FCLI_TEL2;
    property CLI_DTNAISS: TDateTime read FCLI_DTNAISS write FCLI_DTNAISS;
    property CLI_CODEPROF: String read FCLI_CODEPROF write FCLI_CODEPROF;
    property CLI_AUTRESP: String read FCLI_AUTRESP write FCLI_AUTRESP;
    property CLI_BLACKLIST: String read FCLI_BLACKLIST write FCLI_BLACKLIST;
    property CLI_EMAIL: String read FCLI_EMAIL write FCLI_EMAIL;
    property CLI_DTCREATION: TDateTime read FCLI_DTCREATION write FCLI_DTCREATION;
    property CLI_TOPSAL: String read FCLI_TOPSAL write FCLI_TOPSAL;
    property CLI_CODERFM: String read FCLI_CODERFM write FCLI_CODERFM;
    property CLI_OPTIN: String read FCLI_OPTIN write FCLI_OPTIN;
    property CLI_OPTINPART: String read FCLI_OPTINPART write FCLI_OPTINPART;
    property CLI_MAGORIG: String read FCLI_MAGORIG write FCLI_MAGORIG;
    property CLI_TOPNPAI: String read FCLI_TOPNPAI write FCLI_TOPNPAI;
    property CLI_TOPVIB: String read FCLI_TOPVIB write FCLI_TOPVIB;
    property CLI_REMRENOUV: integer read FCLI_REMRENOUV write FCLI_REMRENOUV;
    property CLI_DTSUP: TDateTime read FCLI_DTSUP write FCLI_DTSUP;
    property CLI_DTRENOUV: TDateTime read FCLI_DTRENOUV write FCLI_DTRENOUV;
    property CLI_CREATION: integer read FCLI_CREATION write FCLI_CREATION;
    property CLI_MAGCREA: String read FCLI_MAGCREA write FCLI_MAGCREA;
    property CLI_MODIF: integer read FCLI_MODIF write FCLI_MODIF;
    property CLI_MAGMODIF: String read FCLI_MAGMODIF write FCLI_MAGMODIF;
    property CLI_DTMODIF: TDateTime read FCLI_DTMODIF write FCLI_DTMODIF;
    property CLI_TOPVIBUTIL: integer read FCLI_TOPVIBUTIL write FCLI_TOPVIBUTIL;

    property CLI_RETMAIL: string read FCLI_RETMAIL write FCLI_RETMAIL;
    property CLI_QUALITE: string read FCLI_QUALITE write FCLI_QUALITE;

    property CLI_TYPEFID: integer read FCLI_TYPEFID write FCLI_TYPEFID;

    property CLI_CSTTEL : string read FCLI_CSTTEL write FCLI_CSTTEL;
    property CLI_CSTMAIL : string read FCLI_CSTMAIL write FCLI_CSTMAIL;
    property CLI_CSTCGV : string read FCLI_CSTCGV write FCLI_CSTCGV;
    property CLI_DESACTIVE : Integer read FCLI_DESACTIVE write FCLI_DESACTIVE;

    property Points: TPoints read FPoints write FPoints;
  End;

implementation

uses dmdGinkoia, uConst, uTool;

{ TClient }

procedure TClient.AddBonRepris(const ABonRepris: TBonRepris);
begin
  if BonReprisByBRP_CODEBON[ABonRepris.BRP_CODEBON] = nil then
    FListBonRepris.Add(ABonRepris);
end;

function TClient.ControlRequiedField: String;
var
  vSL: TStringList;
begin
  inherited;
  Result:= '';
  vSL:= TStringList.create;
  try
    if CLI_ENSID = -1 then
      vSL.Append(rs_FieldMissing_ENSID);

    if CLI_NUMCARTE = '' then
      vSL.Append(rs_FieldMissing_NUMCARTE);

    if CLI_NOM = '' then
      vSL.Append(rs_FieldMissing_NOM);


{ *** Deprecated sur demande de BN le 13/08/2013 ***

    if CLI_MAGORIG = '' then
      vSL.Append(rs_FieldMissing_MAGORIG);

    if (CLI_ADR1 = '') and (CLI_ADR2 = '') and (CLI_ADR3 = '') and (CLI_ADR4 = '') then
      vSL.Append(rs_FieldMissing_ADR);

    if CLI_CP = '' then
      vSL.Append(rs_FieldMissing_CP);

    if CLI_VILLE = '' then
      vSL.Append(rs_FieldMissing_VILLE);

    if CLI_CODEPAYS = '' then
      vSL.Append(rs_FieldMissing_CODEPAYS); }

    if vSL.Count <> 0 then
      Result:= vSL.Text;
  finally
    FreeAndNil(vSL);
  end;
end;

function TClient.CountBonRepris: integer;
begin
  Result:= FListBonRepris.Count;
end;

constructor TClient.Create;
begin
  FPoints:= TPoints.Create;
  FListBonRepris:= TObjectList.Create(True);
  FListCliOldCards:= TObjectList.Create(True);
  CLI_ENSID:= 0;
  CLI_DTVAL:= 0;
  CLI_DTNAISS:= 0;
  CLI_REMRENOUV:= -1;
  CLI_DTRENOUV:= 0;
  CLI_TOPVIBUTIL:= 0;
  CLI_DTSUP:= 0;
  CLI_DTRENOUV:= 0;
  CLI_TYPEFID:= 0;
  CLI_CSTTEL:= '';
  CLI_CSTMAIL:= '';
  CLI_CSTCGV:= '';
  CLI_DESACTIVE := 0;
end;

destructor TClient.Destroy;
begin
  FreeAndNil(FPoints);
  FreeAndNil(FListBonRepris);
  FreeAndNil(FListCliOldCards);
  inherited;
end;

function TClient.GetBonRepris(index: integer): TBonRepris;
begin
  Result:= TBonRepris(FListBonRepris.Items[index]);
end;

function TClient.GetBonReprisByBRP_CODEBON(
  const ABRP_CODEBON: String): TBonRepris;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to FListBonRepris.Count -1 do
    begin
      if BonRepris[i].BRP_CODEBON = ABRP_CODEBON then
        begin
          Result:= BonRepris[i];
          Break;
        end;
    end;
end;

procedure TClient.LoadBonRepris;
var
  vQry: TADOQuery;
  vBonRepris: TBonRepris;
begin
  if CLI_ENSID = 0 then
    Exit;

  FListBonRepris.Clear;
  try
    vQry:= dmGinkoia.GetNewQry;

    vQry.SQL.Text:= 'SELECT * FROM BONREPRIS WHERE BRP_ENSID=:PBRP_ENSID AND BRP_NUMCARTE=:PBRP_NUMCARTE';
    vQry.Parameters.ParamByName('PBRP_ENSID').Value:= CLI_ENSID;
    vQry.Parameters.ParamByName('PBRP_NUMCARTE').Value:= CLI_NUMCARTE;

    vQry.Open;

    while not vQry.Eof do
      begin
        vBonRepris:= TBonRepris.Create;
        vBonRepris.SetValuesByDataSet(vQry);
        vQry.Next;
      end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TClient.MAJ(const AAction: TUpdateKind; Import : boolean);
var
  vQry: TADOQuery;
  vParam: TParameter;
  vLastField: String;
  vAction: String;
begin
  inherited MAJ(AAction);
  try
    vLastField := 'None';
    vAction := 'None';
    vQry:= dmGinkoia.GetNewQry;
    try
      dmGinkoia.ADOConnection.BeginTrans;
      case AAction of
        ukInsert:
          begin
            vAction := 'Insert';
            vQry.SQL.Text:= cSqlInsertClient;
            vQry.ParamCheck := True;
            vQry.Parameters.ParamByName('PCLI_DTCREATION').Value:= DateToStr(CLI_DTCREATION);
          end;
        ukModify:
          begin
            vAction := 'Update';
            vQry.SQL.Append('UPDATE CLIENTS SET');

            if CLI_IDETO <> '' then
              vQry.SQL.Append('CLI_IDETO=:PCLI_IDETO,');

            if CLI_ENSID <> 0 then
              vQry.SQL.Append('CLI_ENSID=:PCLI_ENSID,');

            if CLI_DTVAL <> 0 then
              vQry.SQL.Append('CLI_DTVAL=:PCLI_DTVAL,');

            if CLI_CODECLUB <> '' then
              vQry.SQL.Append('CLI_CODECLUB=:PCLI_CODECLUB,');

            if CLI_CIV <> '' then
              vQry.SQL.Append('CLI_CIV=:PCLI_CIV,');

            if CLI_NOM <> '' then
              vQry.SQL.Append('CLI_NOM=:PCLI_NOM,');

            if CLI_PRENOM <> '' then
              vQry.SQL.Append('CLI_PRENOM=:PCLI_PRENOM,');

            // Mise à jour de l'adresse complète ! dans tous les cas !
            if (CLI_ADR1 <> '') or (CLI_ADR2 <> '')  or (CLI_ADR3 <> '') or (CLI_ADR4 <> '') then
            begin
              vQry.SQL.Append('CLI_ADR1=:PCLI_ADR1,');
              vQry.SQL.Append('CLI_ADR2=:PCLI_ADR2,');
              vQry.SQL.Append('CLI_ADR3=:PCLI_ADR3,');
              vQry.SQL.Append('CLI_ADR4=:PCLI_ADR4,');
            end;

            if CLI_CP <> '' then
              vQry.SQL.Append('CLI_CP=:PCLI_CP,');

            if CLI_VILLE <> '' then
              vQry.SQL.Append('CLI_VILLE=:PCLI_VILLE,');

            if CLI_CODEPAYS <> '' then
              vQry.SQL.Append('CLI_CODEPAYS=:PCLI_CODEPAYS,');

            if CLI_TEL1 <> '' then
              vQry.SQL.Append('CLI_TEL1=:PCLI_TEL1,');

            if CLI_TEL2 <> '' then
              vQry.SQL.Append('CLI_TEL2=:PCLI_TEL2,');

            if CLI_DTNAISS <> 0 then
              vQry.SQL.Append('CLI_DTNAISS=:PCLI_DTNAISS,');

            if CLI_CODEPROF <> '' then
              vQry.SQL.Append('CLI_CODEPROF=:PCLI_CODEPROF,');

            if CLI_AUTRESP <> '' then
              vQry.SQL.Append('CLI_AUTRESP=:PCLI_AUTRESP,');

            if CLI_BLACKLIST <> '' then
              vQry.SQL.Append('CLI_BLACKLIST=:PCLI_BLACKLIST,');

            if CLI_EMAIL <> '' then
              vQry.SQL.Append('CLI_EMAIL=:PCLI_EMAIL,');

            if CLI_TOPSAL <> '' then
              vQry.SQL.Append('CLI_TOPSAL=:PCLI_TOPSAL,');

            if CLI_CODERFM <> '' then
              vQry.SQL.Append('CLI_CODERFM=:PCLI_CODERFM,');

            if CLI_OPTIN <> '' then
              vQry.SQL.Append('CLI_OPTIN=:PCLI_OPTIN,');

            if CLI_OPTINPART <> '' then
              vQry.SQL.Append('CLI_OPTINPART=:PCLI_OPTINPART,');

            if CLI_MAGORIG <> '' then
              vQry.SQL.Append('CLI_MAGORIG=:PCLI_MAGORIG,');

            if CLI_TOPNPAI <> '' then
              vQry.SQL.Append('CLI_TOPNPAI=:PCLI_TOPNPAI,');

            if CLI_TOPVIB <> '' then
              vQry.SQL.Append('CLI_TOPVIB=:PCLI_TOPVIB,');

            if CLI_REMRENOUV <> -1 then
              vQry.SQL.Append('CLI_REMRENOUV=:PCLI_REMRENOUV,');

            if CLI_DTRENOUV <> 0 then
              vQry.SQL.Append('CLI_DTRENOUV=:PCLI_DTRENOUV,');

            if CLI_MAGCREA <> '' then
              vQry.SQL.Append('CLI_MAGCREA=:PCLI_MAGCREA,');

            if CLI_MAGMODIF <> '' then
              vQry.SQL.Append('CLI_MAGMODIF=:PCLI_MAGMODIF,');

            if CLI_TOPVIBUTIL <> -1 then
              vQry.SQL.Append('CLI_TOPVIBUTIL=:PCLI_TOPVIBUTIL,');

            if CLI_MAGCREA <> '' then
              vQry.SQL.Append('CLI_QAADRESSE=:PCLI_QAADRESSE,');

            if CLI_MAGCREA <> '' then
              vQry.SQL.Append('CLI_QAMAIL=:PCLI_QAMAIL,');

            if CLI_TYPEFID <> -1 then
              vQry.SQL.Append('CLI_TYPEFID=:PCLI_TYPEFID,');

            if CLI_CSTTEL <> '' then
              vQry.SQL.Append('CLI_CSTTEL=:PCLI_CSTTEL,');

            if CLI_CSTMAIL <> '' then
              vQry.SQL.Append('CLI_CSTMAIL=:PCLI_CSTMAIL,');

            if CLI_CSTCGV <> '' then
              vQry.SQL.Append('CLI_CSTCGV=:PCLI_CSTCGV,');

            if CLI_DESACTIVE = 1 then
              vQry.SQL.Append('CLI_DESACTIVE=1,')
            else
              vQry.SQL.Append('CLI_DESACTIVE=0,');

            if Import then
              vQry.SQL.Append('CLI_CREATION=:PCLI_CREATION,');
            vQry.SQL.Append('CLI_MODIF=:PCLI_MODIF,');
            vQry.SQL.Append('CLI_DTMODIF=:PCLI_DTMODIF');

            vQry.SQL.Append('WHERE');
            vQry.SQL.Append('CLI_NUMCARTE=:PCLI_NUMCARTE');
          end;
        ukDelete:
          begin
            vAction := 'Delete';
            vQry.SQL.Append('UPDATE CLIENTS SET');
            vQry.SQL.Append('CLI_DTSUP=:PCLI_DTSUP');
            vQry.SQL.Append('WHERE');
            vQry.SQL.Append('CLI_NUMCARTE=:PCLI_NUMCARTE');

            vQry.Parameters.ParamByName('PCLI_DTSUP').Value:= DateToStr(CLI_DTSUP);
            vQry.Parameters.ParamByName('PCLI_NUMCARTE').Value:= CLI_NUMCARTE;
          end;
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vLastField := 'PCLI_IDETO';
        vParam:= vQry.Parameters.FindParam('PCLI_IDETO');
        if vParam <> nil then
          vParam.Value:= CLI_IDETO;

        vLastField := 'PCLI_NUMCARTE';
        vParam:= vQry.Parameters.FindParam('PCLI_NUMCARTE');
        if vParam <> nil then
          vParam.Value:= CLI_NUMCARTE;

        vLastField := 'PCLI_IDETO';
        vParam:= vQry.Parameters.FindParam('PCLI_ENSID');
        if vParam <> nil then
          vParam.Value:= CLI_ENSID;

        vLastField := 'PCLI_DTVAL';
        vParam:= vQry.Parameters.FindParam('PCLI_DTVAL');
        if vParam <> nil then
          vParam.Value:= DateToStr(CLI_DTVAL);

        vLastField := 'PCLI_CODECLUB';
        vParam:= vQry.Parameters.FindParam('PCLI_CODECLUB');
        if vParam <> nil then
          vParam.Value:= CLI_CODECLUB;

        vLastField := 'PCLI_CIV';
        vParam:= vQry.Parameters.FindParam('PCLI_CIV');
        if vParam <> nil then
          vParam.Value:= CLI_CIV;

        vLastField := 'PCLI_NOM';
        vParam:= vQry.Parameters.FindParam('PCLI_NOM');
        if vParam <> nil then
          vParam.Value:= CLI_NOM;

        vLastField := 'PCLI_PRENOM';
        vParam:= vQry.Parameters.FindParam('PCLI_PRENOM');
        if vParam <> nil then
          vParam.Value:= CLI_PRENOM;

        vLastField := 'PCLI_ADR1';
        vParam:= vQry.Parameters.FindParam('PCLI_ADR1');
        if vParam <> nil then
          vParam.Value:= Trim(CLI_ADR1);

        vLastField := 'PCLI_ADR2';
        vParam:= vQry.Parameters.FindParam('PCLI_ADR2');
        if vParam <> nil then
          vParam.Value:= Trim(CLI_ADR2);

        vLastField := 'PCLI_ADR3';
        vParam:= vQry.Parameters.FindParam('PCLI_ADR3');
        if vParam <> nil then
          vParam.Value:= Trim(CLI_ADR3);

        vLastField := 'PCLI_ADR4';
        vParam:= vQry.Parameters.FindParam('PCLI_ADR4');
        if vParam <> nil then
          vParam.Value:= Trim(CLI_ADR4);

        vLastField := 'PCLI_CP';
        vParam:= vQry.Parameters.FindParam('PCLI_CP');
        if vParam <> nil then
          vParam.Value:= CLI_CP;

        vLastField := 'PCLI_VILLE';
        vParam:= vQry.Parameters.FindParam('PCLI_VILLE');
        if vParam <> nil then
          vParam.Value:= CLI_VILLE;

        vLastField := 'PCLI_CODEPAYS';
        vParam:= vQry.Parameters.FindParam('PCLI_CODEPAYS');
        if vParam <> nil then
          vParam.Value:= CLI_CODEPAYS;

        vLastField := 'PCLI_TEL1';
        vParam:= vQry.Parameters.FindParam('PCLI_TEL1');
        if vParam <> nil then
          vParam.Value:= CLI_TEL1;

        vLastField := 'PCLI_TEL2';
        vParam:= vQry.Parameters.FindParam('PCLI_TEL2');
        if vParam <> nil then
          vParam.Value:= CLI_TEL2;

        vLastField := 'PCLI_DTNAISS';
        vParam:= vQry.Parameters.FindParam('PCLI_DTNAISS');
        if vParam <> nil then
          vParam.Value:= DateToStr(CLI_DTNAISS);

        vLastField := 'PCLI_CODEPROF';
        vParam:= vQry.Parameters.FindParam('PCLI_CODEPROF');
        if vParam <> nil then
          vParam.Value:= CLI_CODEPROF;

        vLastField := 'PCLI_AUTRESP';
        vParam:= vQry.Parameters.FindParam('PCLI_AUTRESP');
        if vParam <> nil then
          vParam.Value:= CLI_AUTRESP;

        vLastField := 'PCLI_BLACKLIST';
        vParam:= vQry.Parameters.FindParam('PCLI_BLACKLIST');
        if vParam <> nil then
          vParam.Value:= CLI_BLACKLIST;

        vLastField := 'PCLI_EMAIL';
        vParam:= vQry.Parameters.FindParam('PCLI_EMAIL');
        if vParam <> nil then
          vParam.Value:= CLI_EMAIL;

        vLastField := 'PCLI_TOPSAL';
        vParam:= vQry.Parameters.FindParam('PCLI_TOPSAL');
        if vParam <> nil then
          vParam.Value:= CLI_TOPSAL;

        vLastField := 'PCLI_CODERFM';
        vParam:= vQry.Parameters.FindParam('PCLI_CODERFM');
        if vParam <> nil then
          vParam.Value:= CLI_CODERFM;

        vLastField := 'PCLI_OPTIN';
        vParam:= vQry.Parameters.FindParam('PCLI_OPTIN');
        if vParam <> nil then
          vParam.Value:= CLI_OPTIN;

        vLastField := 'PCLI_OPTINPART';
        vParam:= vQry.Parameters.FindParam('PCLI_OPTINPART');
        if vParam <> nil then
          vParam.Value:= CLI_OPTINPART;

        vLastField := 'PCLI_MAGORIG';
        vParam:= vQry.Parameters.FindParam('PCLI_MAGORIG');
        if vParam <> nil then
          vParam.Value:= CLI_MAGORIG;

        vLastField := 'PCLI_TOPNPAI';
        vParam:= vQry.Parameters.FindParam('PCLI_TOPNPAI');
        if vParam <> nil then
          vParam.Value:= CLI_TOPNPAI;

        vLastField := 'PCLI_TOPVIB';
        vParam:= vQry.Parameters.FindParam('PCLI_TOPVIB');
        if vParam <> nil then
          vParam.Value:= CLI_TOPVIB;

        vLastField := 'PCLI_REMRENOUV';
        vParam:= vQry.Parameters.FindParam('PCLI_REMRENOUV');
        if vParam <> nil then
          vParam.Value:= CLI_REMRENOUV;

        vLastField := 'PCLI_DTRENOUV';
        vParam:= vQry.Parameters.FindParam('PCLI_DTRENOUV');
        if vParam <> nil then
          vParam.Value:= DateToStr(CLI_DTRENOUV);

        vLastField := 'PCLI_IDETO';
        vParam:= vQry.Parameters.FindParam('PCLI_MAGCREA');
        if vParam <> nil then
          vParam.Value:= CLI_MAGCREA;

        vLastField := 'PCLI_MAGMODIF';
        vParam:= vQry.Parameters.FindParam('PCLI_MAGMODIF');
        if vParam <> nil then
          vParam.Value:= CLI_MAGMODIF;

        vLastField := 'PCLI_TYPEFID';
        vParam:= vQry.Parameters.FindParam('PCLI_TYPEFID');
        if vParam <> nil then
          vParam.Value:= CLI_TYPEFID;

        vLastField := 'PCLI_CSTTEL';
        vParam:= vQry.Parameters.FindParam('PCLI_CSTTEL');
        if vParam <> nil then
        begin
          if Trim(CLI_CSTTEL) = '' then
            vParam.Value := Null
          else
            vParam.Value:= StrToInt(Trim(CLI_CSTTEL));
        end;

        vLastField := 'PCLI_CSTMAIL';
        vParam:= vQry.Parameters.FindParam('PCLI_CSTMAIL');
        if vParam <> nil then
        begin
          if Trim(CLI_CSTMAIL) = '' then
            vParam.Value := Null
          else
            vParam.Value:= StrToInt(Trim(CLI_CSTMAIL));
        end;

        vLastField := 'PCLI_CSTCGV';
        vParam:= vQry.Parameters.FindParam('PCLI_CSTCGV');
        if vParam <> nil then
        begin
          if Trim(CLI_CSTCGV) = '' then
            vParam.Value := Null
          else
            vParam.Value:= StrToInt(Trim(CLI_CSTCGV));
        end;

        vLastField := 'PCLI_DESACTIVE';
        vParam:= vQry.Parameters.FindParam('PCLI_DESACTIVE');
        if vParam <> nil then
          vParam.Value:= CLI_DESACTIVE;

        vLastField := 'PCLI_QAADRESSE';
        vParam:= vQry.Parameters.FindParam('PCLI_QAADRESSE');
        if vParam <> nil then
        begin
          if CLI_QUALITE = '' then
            vParam.Value := Null
          else
            vParam.Value:= CLI_QUALITE;
        end;

        vLastField := 'PCLI_QAMAIL';
        vParam:= vQry.Parameters.FindParam('PCLI_QAMAIL');
        if vParam <> nil then
        begin
          if CLI_RETMAIL = '' then
            vParam.Value := Null
          else
            vParam.Value:= CLI_RETMAIL;
        end;

        vLastField := 'PCLI_TOPVIBUTIL';
        vParam:= vQry.Parameters.FindParam('PCLI_TOPVIBUTIL');
        if vParam <> nil then
        begin
          if Import = True
          then vParam.Value:= 0
          else vParam.Value:= CLI_TOPVIBUTIL;
        end;

        vLastField := 'CLI_MODIF/CLI_DTMODIF/CLI_CREATION';
        if Import then
        begin
          CLI_MODIF:= 0;
          CLI_DTMODIF:= 0;
          CLI_CREATION:= 0;
        end
        else
        begin
          case AAction of
            ukInsert:
              begin
                CLI_MODIF:= 0;
                CLI_DTMODIF:= 0;
                CLI_CREATION:= 1;
              end;
            ukModify:
              begin
                CLI_MODIF:= 1;
//                CLI_DTMODIF:= Now; // BPY : la date est maintenant spécifié dans l'appel
//JB                CLI_CREATION:= 0;
              end;
          end;
        end;

        vLastField := 'PCLI_MODIF';
        vQry.Parameters.ParamByName('PCLI_MODIF').Value:= CLI_MODIF;
        vLastField := 'PCLI_DTMODIF';
        vQry.Parameters.ParamByName('PCLI_DTMODIF').Value:= DateToStr(CLI_DTMODIF);

        vLastField := 'PCLI_CREATION';
        if (Import = True) or (AAction = ukInsert) then
          vQry.Parameters.ParamByName('PCLI_CREATION').Value:= CLI_CREATION;
      end;

      vQry.ExecSQL;

      if AAction = ukInsert then
        CLI_ID:= dmGinkoia.GetNewID('CLIENTS');

      dmGinkoia.ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        if dmGinkoia.ADOConnection.InTransaction then
          begin
            dmGinkoia.ADOConnection.RollbackTrans;

            Raise Exception.Create('TClient.MAJ : ' + E.Message + ' (LastField=' + vLastField + '; Action=' + vAction + ')');
          end
        else
          Raise;
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TClient.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField:= ADS.FindField('CLI_ID');
  if vField <> nil then
    CLI_ID:= vField.AsInteger;

  vField:= ADS.FindField('CLI_IDETO');
  if vField <> nil then
    CLI_IDETO:= vField.AsString;

  vField:= ADS.FindField('CLI_NUMCARTE');
  if vField <> nil then
    CLI_NUMCARTE:= vField.AsString;

  vField:= ADS.FindField('CLI_ENSID');
  if vField <> nil then
    CLI_ENSID:= vField.AsInteger;

  vField:= ADS.FindField('CLI_DTVAL');
  if vField <> nil then
    CLI_DTVAL:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('CLI_CODECLUB');
  if vField <> nil then
    CLI_CODECLUB:= vField.AsString;

  vField:= ADS.FindField('CLI_CIV');
  if vField <> nil then
    CLI_CIV:= vField.AsString;

  vField:= ADS.FindField('CLI_NOM');
  if vField <> nil then
    CLI_NOM:= vField.AsString;

  vField:= ADS.FindField('CLI_PRENOM');
  if vField <> nil then
    CLI_PRENOM:= vField.AsString;

  vField:= ADS.FindField('CLI_ADR1');
  if vField <> nil then
    CLI_ADR1:= vField.AsString;

  vField:= ADS.FindField('CLI_ADR2');
  if vField <> nil then
    CLI_ADR2:= vField.AsString;

  vField:= ADS.FindField('CLI_ADR3');
  if vField <> nil then
    CLI_ADR3:= vField.AsString;

  vField:= ADS.FindField('CLI_ADR4');
  if vField <> nil then
    CLI_ADR4:= vField.AsString;

  vField:= ADS.FindField('CLI_CP');
  if vField <> nil then
    CLI_CP:= vField.AsString;

  vField:= ADS.FindField('CLI_VILLE');
  if vField <> nil then
    CLI_VILLE:= vField.AsString;

  vField:= ADS.FindField('CLI_CODEPAYS');
  if vField <> nil then
    CLI_CODEPAYS:= vField.AsString;

  vField:= ADS.FindField('CLI_TEL1');
  if vField <> nil then
    CLI_TEL1:= vField.AsString;

  vField:= ADS.FindField('CLI_TEL2');
  if vField <> nil then
    CLI_TEL2:= vField.AsString;

  vField:= ADS.FindField('CLI_DTNAISS');
  if vField <> nil then
    CLI_DTNAISS:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('CLI_CODEPROF');
  if vField <> nil then
    CLI_CODEPROF:= vField.AsString;

  vField:= ADS.FindField('CLI_AUTRESP');
  if vField <> nil then
    CLI_AUTRESP:= vField.AsString;

  vField:= ADS.FindField('CLI_BLACKLIST');
  if vField <> nil then
    CLI_BLACKLIST:= vField.AsString;

  vField:= ADS.FindField('CLI_EMAIL');
  if vField <> nil then
    CLI_EMAIL:= vField.AsString;

  vField:= ADS.FindField('CLI_DTCREATION');
  if vField <> nil then
    CLI_DTCREATION:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('CLI_TOPSAL');
  if vField <> nil then
    CLI_TOPSAL:= vField.AsString;

  vField:= ADS.FindField('CLI_CODERFM');
  if vField <> nil then
    CLI_CODERFM:= vField.AsString;

  vField:= ADS.FindField('CLI_OPTIN');
  if vField <> nil then
    CLI_OPTIN:= vField.AsString;

  vField:= ADS.FindField('CLI_OPTINPART');
  if vField <> nil then
    CLI_OPTINPART:= vField.AsString;

  vField:= ADS.FindField('CLI_MAGORIG');
  if vField <> nil then
    CLI_MAGORIG:= vField.AsString;

  vField:= ADS.FindField('CLI_TOPNPAI');
  if vField <> nil then
    CLI_TOPNPAI:= vField.AsString;

  vField:= ADS.FindField('CLI_REMRENOUV');
  if vField <> nil then
    CLI_REMRENOUV:= vField.AsInteger;

  vField:= ADS.FindField('CLI_DTSUP');
  if vField <> nil then
    CLI_DTSUP:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('CLI_DTRENOUV');
  if vField <> nil then
    CLI_DTRENOUV:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('CLI_CREATION');
  if vField <> nil then
    CLI_CREATION:= vField.AsInteger;

  vField:= ADS.FindField('CLI_MAGCREA');
  if vField <> nil then
    CLI_MAGCREA:= vField.AsString;

  vField:= ADS.FindField('CLI_MODIF');
  if vField <> nil then
    CLI_MODIF:= vField.AsInteger;

  vField:= ADS.FindField('CLI_MAGMODIF');
  if vField <> nil then
    CLI_MAGMODIF:= vField.AsString;

  vField:= ADS.FindField('CLI_DTMODIF');
  if vField <> nil then
    CLI_DTMODIF:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('CLI_TOPVIB');
  if vField <> nil then
    CLI_TOPVIB:= vField.AsString;

  vField:= ADS.FindField('CLI_TOPVIBUTIL');
  if vField <> nil then
    CLI_TOPVIBUTIL:= vField.AsInteger;

  vField:= ADS.FindField('CLI_QAADRESSE');
  if vField <> nil then
    CLI_QUALITE:= vField.AsString;

  vField:= ADS.FindField('CLI_QAMAIL');
  if vField <> nil then
    CLI_RETMAIL:= vField.AsString;

  vField:= ADS.FindField('CLI_TYPEFID');
  if vField <> nil then
    CLI_TYPEFID:= vField.AsInteger;

  vField:= ADS.FindField('CLI_CSTTEL');
  if vField <> nil then
    CLI_CSTTEL:= vField.AsString;

  vField:= ADS.FindField('CLI_CSTMAIL');
  if vField <> nil then
    CLI_CSTMAIL:= vField.AsString;

  vField:= ADS.FindField('CLI_CSTCGV');
  if vField <> nil then
    CLI_CSTCGV:= vField.AsString;

  vField:= ADS.FindField('CLI_DESACTIVE');
  if vField <> nil then
    CLI_DESACTIVE:= vField.AsInteger;

  FPoints.SetValuesByDataSet(ADS);
end;

{ TPoints }

function TPoints.ControlRequiedField: String;
var
  vSL: TStringList;
begin
  inherited;
  Result:= '';
  vSL:= TStringList.create;
  try
    if PTS_ENSID = -1 then
      vSL.Append(rs_FieldMissing_ENSID);

    if PTS_NUMCARTE = '' then
      vSL.Append(rs_FieldMissing_NUMCARTE);

    if vSL.Count <> 0 then
      Result:= vSL.Text;
  finally
    FreeAndNil(vSL);
  end;
end;

constructor TPoints.Create;
begin
  PTS_ID:= 0;
  PTS_NBPOINTS:= -1;
  PTS_DATE:= 0;
end;

function TPoints.IsExist: Boolean;
var
  vQry: TADOQuery;
begin
  inherited;
  vQry:= dmGinkoia.GetNewQry;
  try
    vQry.SQL.Text:= 'SELECT PTS_ID FROM POINTS WHERE PTS_NUMCARTE=:PPTS_NUMCARTE';
    vQry.Parameters.ParamByName('PPTS_NUMCARTE').Value:= PTS_NUMCARTE;
    vQry.Open;
    Result:= not vQry.Eof;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TPoints.MAJ(Const AAction: TUpdateKind; Import : boolean);
var
  vQry: TADOQuery;
begin
  inherited;
  try
    vQry:= dmGinkoia.GetNewQry;
    try
      dmGinkoia.ADOConnection.BeginTrans;
      case AAction of
        ukInsert: vQry.SQL.Text:= cSqlInsertPoints;
        ukModify: vQry.SQL.Text:= cSqlUpdatePoints;
//        ukDelete: ;
      end;

      if AAction in [ukInsert, ukModify] then
        begin
          vQry.Parameters.ParamByName('PPTS_NBPOINTS').Value:= PTS_NBPOINTS;
          vQry.Parameters.ParamByName('PPTS_DATE').Value:= PTS_DATE;
          vQry.Parameters.ParamByName('PPTS_ENSID').Value:= PTS_ENSID;
          vQry.Parameters.ParamByName('PPTS_NUMCARTE').Value:= PTS_NUMCARTE;

          vQry.ExecSQL;

          if AAction = ukInsert then
            PTS_ID:= dmGinkoia.GetNewID('POINTS');
        end;

      dmGinkoia.ADOConnection.CommitTrans;
    except
      on E: Exception do
        begin
          dmGinkoia.ADOConnection.RollbackTrans;
          Raise Exception.Create('TPoints.MAJ : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TPoints.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField:= ADS.FindField('PTS_NBPOINTS');
  if (vField <> nil) and (not vField.IsNull) then
    PTS_NBPOINTS:= vField.AsFloat;

  vField:= ADS.FindField('PTS_DATE');
  if (vField <> nil) and (VarToDateTimeDef(vField.Value) <> 0) then
    PTS_DATE:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('PTS_ID');
  if vField <> nil then
    PTS_ID:= vField.AsInteger;

  vField:= ADS.FindField('PTS_ENSID');
  if vField <> nil then
    PTS_ENSID:= vField.AsInteger;

  vField:= ADS.FindField('PTS_NUMCARTE');
  if vField <> nil then
    PTS_NUMCARTE:= vField.AsString;
end;

{ TBonRepris }

function TBonRepris.ControlRequiedField: String;
var
  vSL: TStringList;
begin
  inherited;
  Result:= '';
  vSL:= TStringList.create;
  try
    if BRP_ENSID = -1 then
      vSL.Append(rs_FieldMissing_ENSID);

    if BRP_NUMTCK = -1 then
      vSL.Append(rs_FieldMissing_NUMTICKET);

    if BRP_MAG = '' then
      vSL.Append(rs_FieldMissing_MAGORIG);

    if BRP_DATE = 0 then
      vSL.Append(rs_FieldMissing_DATE);

    if BRP_CODEBON = '' then
      vSL.Append(rs_FieldMissing_NUMBON);

    if BRP_NUMCARTE = '' then
      vSL.Append(rs_FieldMissing_NUMCARTE);

    if vSL.Count <> 0 then
      Result:= vSL.Text;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TBonRepris.MAJ(const AAction: TUpdateKind; Import : boolean);
var
  vQry: TADOQuery;
begin
  inherited;
  try
    vQry:= dmGinkoia.GetNewQry;
    try
      dmGinkoia.ADOConnection.BeginTrans;
      case AAction of
        ukInsert:
          begin
            vQry.SQL.Append('INSERT INTO BONREPRIS (');
            vQry.SQL.Append('BRP_CODEBON');
            vQry.SQL.Append(',BRP_ENSID');
            vQry.SQL.Append(',BRP_NUMCARTE');
            vQry.SQL.Append(',BRP_MAG');
            vQry.SQL.Append(',BRP_DATE');
            vQry.SQL.Append(',BRP_TRAITE');
            vQry.SQL.Append(',BRP_NUMTCK');
            vQry.SQL.Append(') VALUES (');
            vQry.SQL.Append(':PBRP_CODEBON');
            vQry.SQL.Append(',:PBRP_ENSID');
            vQry.SQL.Append(',:PBRP_NUMCARTE');
            vQry.SQL.Append(',:PBRP_MAG');
            vQry.SQL.Append(',:PBRP_DATE');
            vQry.SQL.Append(',:PBRP_TRAITE');
            vQry.SQL.Append(',:PBRP_NUMTCK');
            vQry.SQL.Append(')');

            vQry.Parameters.ParamByName('PBRP_CODEBON').Value:= BRP_CODEBON;
            vQry.Parameters.ParamByName('PBRP_ENSID').Value:= BRP_ENSID;
            vQry.Parameters.ParamByName('PBRP_NUMCARTE').Value:= BRP_NUMCARTE;
            vQry.Parameters.ParamByName('PBRP_MAG').Value:= BRP_MAG;
            vQry.Parameters.ParamByName('PBRP_DATE').Value:= BRP_DATE;
            vQry.Parameters.ParamByName('PBRP_TRAITE').Value:= BRP_TRAITE;
            vQry.Parameters.ParamByName('PBRP_NUMTCK').Value:= BRP_NUMTCK;
          end;
        ukModify:
          begin
            vQry.SQL.Append('UPDATE BONREPRIS SET');
//            vQry.SQL.Append('BRP_CODEBON=:PBRP_CODEBON');
//            vQry.SQL.Append(',BRP_ENSID=:PBRP_ENSID');
//            vQry.SQL.Append(',BRP_MAG=:PBRP_MAG');
//            vQry.SQL.Append(',BRP_DATE=:PBRP_DATE');
            vQry.SQL.Append('BRP_TRAITE=:PBRP_TRAITE');
//            vQry.SQL.Append(',BRP_NUMTCK=:PBRP_NUMTCK');
            vQry.SQL.Append('WHERE');
//            vQry.SQL.Append('BRP_NUMCARTE=:PBRP_NUMCARTE');
            vQry.SQL.Append('BRP_ID=:PBRP_ID');

            vQry.Parameters.ParamByName('PBRP_TRAITE').Value:= BRP_TRAITE;
            vQry.Parameters.ParamByName('PBRP_ID').Value:= BRP_ID;
          end;
//        ukDelete: ;
      end;

      if AAction in [ukInsert, ukModify] then
        begin
          vQry.ExecSQL;

          if AAction = ukInsert then
            BRP_ID:= dmGinkoia.GetNewID('BONREPRIS');
        end;

      dmGinkoia.ADOConnection.CommitTrans;
    except
      on E: Exception do
        begin
          dmGinkoia.ADOConnection.RollbackTrans;
          Raise Exception.Create('TBonRepris.MAJ : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TBonRepris.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField:= ADS.FindField('BRP_CODEBON');
  if vField <> nil then
    BRP_CODEBON:= vField.AsString;

  vField:= ADS.FindField('BRP_ENSID');
  if vField <> nil then
    BRP_ENSID:= vField.AsInteger;

  vField:= ADS.FindField('BRP_NUMCARTE');
  if vField <> nil then
    BRP_NUMCARTE:= vField.AsString;

  vField:= ADS.FindField('BRP_MAG');
  if vField <> nil then
    BRP_MAG:= vField.AsString;

  vField:= ADS.FindField('BRP_DATE');
  if vField <> nil then
    BRP_DATE:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('BRP_TRAITE');
  if vField <> nil then
    BRP_TRAITE:= vField.AsInteger;

  vField:= ADS.FindField('BRP_NUMTCK');
  if vField <> nil then
    BRP_NUMTCK:= vField.AsInteger;

  vField:= ADS.FindField('BRP_ID');
  if vField <> nil then
    BRP_ID:= vField.AsInteger;
end;

{ TCliOldCards }

function TCliOldCards.IsExist: Boolean;
var
  vQry: TADOQuery;
begin
  inherited;
  vQry:= dmGinkoia.GetNewQry;
  try
    vQry.SQL.Text:= 'SELECT COC_ID FROM CLIOLDCARDS WHERE COC_CLIID=:PCOC_CLIID AND COC_NUMCARTE=:PCOC_NUMCARTE';
    vQry.Parameters.ParamByName('PCOC_CLIID').Value:= COC_CLIID;
    vQry.Parameters.ParamByName('PCOC_NUMCARTE').Value:= COC_NUMCARTE;
    vQry.Open;
    Result:= not vQry.Eof;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TCliOldCards.MAJ;
var
  vQry: TADOQuery;
begin
  if IsExist then
    Exit;
  try
    vQry:= dmGinkoia.GetNewQry;
    try
      dmGinkoia.ADOConnection.BeginTrans;

      vQry.SQL.Append('INSERT INTO CLIOLDCARDS (');
      vQry.SQL.Append('COC_NUMCARTE');
      vQry.SQL.Append(',COC_CLIID');
      vQry.SQL.Append(') VALUES (');
      vQry.SQL.Append(':PCOC_NUMCARTE');
      vQry.SQL.Append(',:PCOC_CLIID');
      vQry.SQL.Append(')');

      vQry.Parameters.ParamByName('PCOC_NUMCARTE').Value:= COC_NUMCARTE;
      vQry.Parameters.ParamByName('PCOC_CLIID').Value:= COC_CLIID;

      vQry.ExecSQL;

      COC_ID:= dmGinkoia.GetNewID('CLIOLDCARDS');

      dmGinkoia.ADOConnection.CommitTrans;
    except
      on E: Exception do
        begin
          dmGinkoia.ADOConnection.RollbackTrans;
          Raise Exception.Create('TCliOldCards.MAJ : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TCliOldCards.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField:= ADS.FindField('COC_NUMCARTE');
  if vField <> nil then
    COC_NUMCARTE:= vField.AsString;

  vField:= ADS.FindField('COC_CLIID');
  if vField <> nil then
    COC_CLIID:= vField.AsInteger;

  vField:= ADS.FindField('COC_ID');
  if vField <> nil then
    COC_ID:= vField.AsInteger;
end;

{ TExportLog }

procedure TExportLog.MAJ(const AAction: TUpdateKind; Import : boolean);
var
  vQry: TADOQuery;
begin
  inherited;
  try
    vQry:= dmGinkoia.GetNewQry;
    try
      dmGinkoia.ADOConnection.BeginTrans;
      case AAction of
        ukInsert:
          begin
            vQry.SQL.Append('INSERT INTO EXPORTS (');
            vQry.SQL.Append('EXP_HEURE');
            vQry.SQL.Append(',EXP_FICHIER');
            vQry.SQL.Append(',EXP_DATELASTEXPORT');
            vQry.SQL.Append(') VALUES (');
            vQry.SQL.Append(':PEXP_HEURE');
            vQry.SQL.Append(',:PEXP_FICHIER');
            vQry.SQL.Append(',:PEXP_DATELASTEXPORT');
            vQry.SQL.Append(')');
          end;
        ukModify:
          begin
            //-->
          end;
//        ukDelete: ;
      end;

      vQry.Parameters.ParamByName('PEXP_HEURE').Value:= DateTimeToStr(EXP_HEURE);
      vQry.Parameters.ParamByName('PEXP_FICHIER').Value:= EXP_FICHIER;
      vQry.Parameters.ParamByName('PEXP_DATELASTEXPORT').Value:= DateToStr(EXP_DATELASTEXPORT);
      vQry.ExecSQL;

      dmGinkoia.ADOConnection.CommitTrans;
    except
      on E: Exception do
        begin
          dmGinkoia.ADOConnection.RollbackTrans;
          Raise Exception.Create('TExportLog.MAJ : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TExportLog.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField:= ADS.FindField('EXP_HEURE');
  if vField <> nil then
    EXP_HEURE:= VarToDateTimeDef(vField.Value);

  vField:= ADS.FindField('EXP_FICHIER');
  if vField <> nil then
    EXP_FICHIER:= vField.AsString;

  vField:= ADS.FindField('EXP_DATELASTEXPORT');
  if vField <> nil then
    EXP_DATELASTEXPORT:= VarToDateTimeDef(vField.Value);
end;

{ TCustomGnk }

function TCustomGnk.ControlRequiedField: String;
begin
  Result:= '';
end;

procedure TCustomGnk.MAJ(const AAction: TUpdateKind; Import : boolean);
var
 Buffer: String;
begin
  Buffer:= ControlRequiedField;
  if Buffer <> '' then
    Raise Exception.Create(rs_FieldMissing_EnteteMsg + cRC + Buffer);
end;

end.


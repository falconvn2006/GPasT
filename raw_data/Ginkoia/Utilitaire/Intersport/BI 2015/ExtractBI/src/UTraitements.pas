unit UTraitements;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.Script,
  FireDAC.Stan.Intf,
  uGestionBDD,
  UInfosDatabase,
  uLog,
  uCreateProcess;

const
  // Acces DB
  DATABASE_USER_ADM = 'sysdba';
  DATABASE_PASSWORD_ADM = 'masterkey';
  DATABASE_USER_GNK = 'ginkoia';
  DATABASE_PASSWORD_GNK = 'ginkoia';
  DATABASE_USER_TPN = 'ginkoia';
  DATABASE_PASSWORD_TPN = 'ginkoia';
  // taille des scripts
  CST_MAX_ITEMS_SCRIPT = 50000;

type
  TEnumTypeTraitement = (ett_None,
                         ett_CreateBase, ett_UpdateBase, ett_ClearBase, ett_Purge,
                         ett_ReExport, ett_ReInitialisation, ett_ReMouvement, ett_DelImport,
                         ett_GestionMagasins, ett_GestionExercices, ett_GestionCollections, ett_GestionFournisseurs,
                         ett_CompletArticles, ett_CompletTickets, ett_CompletFactures, ett_CompletMouvements, ett_CompletCommandes, ett_CompletReceptions, ett_CompletRetours,
                         ett_DeltaArticles, ett_DeltaTickets, ett_DeltaFactures, ett_DeltaMouvements, ett_DeltaCommandes, ett_DeltaReceptions, ett_DeltaRetours,
                         ett_HistoStock, ett_ResetStock,
                         ett_LogForce,
                         ett_DoSleep, ett_ForceSleep);
  TSetTraitementTodo = set of TEnumTypeTraitement;

type
  TEnumResult = (ers_Succeded, ers_Interrupted, ers_Failed);
  TReInitLvl = (erl_None, erl_ReExport, erl_ReInitialisation, erl_ReMouvement);

type
  TListLastIDs = TObjectDictionary<integer, TDictionary<string, integer>>;

type
  TListeChamps = array of string;

type
  TTraitement = class(TThread)
  protected
    FStartTime : TDateTime;
    FLogDos, FLogMdl, FLogRef, FLogMag, FLogKey : string;
    FListMag : TListMagasin;
    FDateMinArt, FDateMinVte, FDateMinMvt, FDateMinCmd, FDateMinRap, FDateMinStk, FDateMax : TDate;

    FNomBaseTampon : string;
    FConnexionGnk, FConnexionTpn : TMyConnection;
    FTransactionGnk, FTransactionTpn : TMyTransaction;
    FWhatToDo : TSetTraitementTodo;
    FWhatIsDoing : TEnumTypeTraitement;
    FDoNull, FDoErrArt : boolean;

    FFieldToIgnore : array of string;

    // communication via std in/out/err
    FStdStream : TStdStream;

    procedure LoadResourceTxtFile(Nom : string; Liste : TStrings);
    procedure DecodePlage(S: string; var Deb, fin: integer);
    function GetFieldData(FieldSrc : TField; DoNull : boolean) : string;
    function GetFieldNullValue(FieldSrc : TField; DoNull : boolean) : string;
    function GetFieldDiffStr(FieldSrc, FieldDst : TField) : string;
    function GetFieldDiffInt(FieldSrc, FieldDst : TField) : integer;
    function GetFieldDiffExt(FieldSrc, FieldDst : TField) : extended;
    function GetFieldInv(FieldSrc : TField) : string;

    procedure DoLogInfosUtils();
    procedure DoLogMultiLine(Msg : string; level : TLogLevel; Ovl : boolean = false); overload;
    procedure DoLogMultiLine(Msg : string; level : TLogLevel; Magasin : TMagasin; Ovl : boolean = false); overload;
    function GetExceptionMessage(e : Exception) : string;

    function GetPlages(out LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer) : boolean;
    function GetListLastID(var ListeLastId : TListLastIDs) : boolean;
    procedure GetMaxKVersionOf(Query : TMyQuery; PlageDeb, PlageFin : integer; var CurrentID : integer);
    function GetOneFieldOf(Query : TMyQuery; List : array of string) : TField;

    function GetWhere(Query : TMyQuery; NomCle : array of string; DoNull : boolean) : string;
    function GetWhereNotID0(NomCle : array of string; DoNull : boolean) : string;
    function GetIdentArticle(ModId, TgfId, CouId : integer) : string;
    function GetInsertRequete(Query : TMyQuery; NomTable : string; DoNull : boolean; ListeChamps : TListeChamps = []) : string;
    function GetUpdateRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean; ListeChamps : TListeChamps = []) : string;
    function GetDummyUpdateRequete(QuerySrc : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;
    function GetInsertMajRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
    function GetInsertDelRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
    function GetUpdateDelRequete(QuerySrc : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
    function GetDeleteRequete(QuerySrc : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;

    function GetLastVersion(MagId : integer; Name : string; ListeLastId : TListLastIDs) : integer;
    function SetLastVersion(MagId : integer; Name : string; Value : integer; ListeLastId : TListLastIDs; Force : boolean = false) : string;

    function ReLaunchScriptError(Script : TMyScript; Query : TMyQuery) : string;
    procedure SaveScript(Libelle : string; Scripts : TMyScript);

    function DoGestionArticle(QueryGnk, QueryTpn, QueryMaj : TMyQuery; ModId, TgfId, CouId : integer; DoMaj, DoNull : boolean) : boolean;
    function DoGestionCollection(QueryGnk, QueryTpn, QueryMaj : TMyQuery; ModId : integer; DoMaj, DoNull : boolean) : boolean;
    function DoGestionFournisseur(QueryGnk, QueryTpn, QueryMaj : TMyQuery; FouId : integer; DoMaj, DoNull : boolean) : boolean;

    function CopieTable(Magasin : TMagasin;
                        LamePlageDeb, LamePlageFin : integer; var LameLastID : integer;
                        MagPlageDeb, MagPlageFin : integer; var MagLastId : integer;
                        NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                        ListeChamps : TListeChamps = []) : TEnumResult; overload;
    function CopieTable(LamePlageDeb, LamePlageFin : integer; var LameLastID : integer;
                        MagPlageDeb, MagPlageFin : integer; var MagLastId : integer;
                        NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                        ListeChamps : TListeChamps = []) : TEnumResult; overload;
    function CopieTable(Magasin : TMagasin; var LastID : integer; NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                        ListeChamps : TListeChamps = []) : TEnumResult; overload;
    function CopieTable(Magasin : TMagasin; NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                        ListeChamps : TListeChamps = []) : TEnumResult; overload;
    function CopieTable(NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                        ListeChamps : TListeChamps = []) : TEnumResult; overload;

    function DoExportMagasins(DoNull : boolean) : integer;
    function DoExportExercices(LvlReinit : TReInitLvl; DoNull : boolean) : integer;
    function DoExportCollections(LvlReinit : TReInitLvl; DoNull : boolean) : integer;
    function DoExportFournisseurs(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoNull : boolean) : integer;

    function DoExportArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoNull : boolean) : integer;
    function DoExportTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportCommande(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportReception(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportRetour(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;

    function DoExportBI(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportCrossCanal(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
    function DoExportRapproAuto(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;

    function DoDeltaArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoNull : boolean) : integer;
    function DoDeltaTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaCommande(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaReception(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaRetour(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;

    function DoDeltaBI(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaCrossCanal(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaRapproAuto(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;

    function DoHistoStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
    function DoResetStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
    function DoValideStock(OK : boolean) : boolean;

    function HasDonneesImport(TmpConn : TMyConnection; TmpTrans : TMyTransaction) : boolean;

    function ActivationTrigger(Active : boolean) : boolean;

    function CreateBase() : integer;
    function UpdateBase(DoTrt : boolean; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer) : integer;
    function ClearBase() : integer;
    function DoPurges(ListeMagasins : TListMagasin) : integer;

    procedure DoHistoEvent(Start, Reset : boolean; Resultat : integer);

    procedure Execute(); override;
  public
    constructor Create(FctTerminate: TNotifyEvent; StdStream : TStdStream;
                       BaseGin, BaseTpn, LogDos, LogMdl, LogRef, LogKey : string;
                       DateMinVte, DateMinMvt, DateMinCmd, DateMinRap, DateMinStk : TDate;
                       LogInterval : integer;
                       ListMag : TListMagasin;
                       WhatToDo : TSetTraitementTodo; NbDaysReMouvement : integer;
                       DoNull : boolean = false;
                       DoErrArt : boolean = false;
                       CreateSuspended: Boolean = false); reintroduce;
    destructor Destroy(); override;

    procedure Terminate(); reintroduce;

    property ReturnValue;
    property WhatIsDoing : TEnumTypeTraitement read FWhatIsDoing;
  end;

implementation

uses
  Winapi.ActiveX,
  Winapi.ShlObj,
  Winapi.Winsock,
  System.Win.Registry,
  System.Types,
  System.TypInfo,
  System.StrUtils,
  System.DateUtils,
  System.Math,
  Vcl.Forms,
  FireDAC.Stan.Option,
  FireDAC.Comp.ScriptCommands,
  uMessage,
  uIntervalText,
  uConstHistoEvent,
  LaunchProcess,
  UFileUtils,
  VersionInfo;

const
  // les champs
  FIELD_KENABLED : array [0..0] of string = ('KENABLED');
  FIELD_ARTICLE_MODID : array [0..5] of string = ('MODID', 'STKMODID', 'TKLMODID', 'FCLMODID', 'MVLMODID', 'CMDMODID');
  FIELD_ARTICLE_TGFID : array [0..5] of string = ('TGFID', 'STKTGFID', 'TKLTGFID', 'FCLTGFID', 'MVLTGFID', 'CMDTGFID');
  FIELD_ARTICLE_COUID : array [0..5] of string = ('COUID', 'STKCOUID', 'TKLCOUID', 'FCLCOUID', 'MVLCOUID', 'CMDCOUID');
  FIELDS_KVERSION : array [0..2] of string = ('KVERSION', 'KVERSIONBASE', 'KVERSIONLAME');
  FIELDS_MAGID : array [0..2] of string = ('MAGID', 'STKMAGID', 'CMDMAGID');

const
  LISTE_MODULE_MONITORING : array [0..2] of string = ('BI', 'Commandes', 'RapprochementAuto');
  MODULE_MONITORING_BI = 0;
  MODULE_MONITORING_CROSSCANAL = 1;
  MODULE_MONITORING_RAPPROCHEMENT = 2;

{ TTraitement }

// utils

procedure TTraitement.LoadResourceTxtFile(Nom : string; Liste : TStrings);
var
  ScriptStream : TResourceStream;
begin
  if FileExists('Scripts\' + Nom + '.sql') then
    Liste.LoadFromFile('Scripts\' + Nom + '.sql')
  else if FileExists('..\..\Scripts\' + Nom + '.sql') then
    Liste.LoadFromFile('..\..\Scripts\' + Nom + '.sql')
  else
  begin
    try
      ScriptStream := TResourceStream.Create(HInstance, Nom, RT_RCDATA);
      Liste.LoadFromStream(ScriptStream);
    finally
      FreeAndNil(ScriptStream);
    end;
  end;
end;

procedure TTraitement.DecodePlage(S: string; var Deb, fin: integer);
var
  S1: string;
begin
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  deb := Strtoint(S1) * 1000000;
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  fin := Strtoint(S1) * 1000000 -1;
end;

function TTraitement.GetFieldData(FieldSrc : TField; DoNull : boolean) : string;
begin
  if DoNull and FieldSrc.IsNull then
    Result := 'NULL'
  else
  begin
    case FieldSrc.DataType of
      // non géré
      TFieldType.ftUnknown,
      TFieldType.ftVarBytes,
      TFieldType.ftBlob,
      TFieldType.ftMemo,
      TFieldType.ftGraphic,
      TFieldType.ftFmtMemo,
      TFieldType.ftParadoxOle,
      TFieldType.ftDBaseOle,
      TFieldType.ftTypedBinary,
      TFieldType.ftCursor,
      TFieldType.ftADT,
      TFieldType.ftArray,
      TFieldType.ftReference,
      TFieldType.ftDataSet,
      TFieldType.ftOraBlob,
      TFieldType.ftOraClob,
      TFieldType.ftVariant,
      TFieldType.ftInterface,
      TFieldType.ftIDispatch,
      TFieldType.ftGuid,
      TFieldType.ftWideMemo,
      TFieldType.ftOraInterval,
      TFieldType.ftConnection,
      TFieldType.ftParams,
      TFieldType.ftStream,
      TFieldType.ftObject
        : raise EConvertError.Create('Type non pris en charge');
      // string
      TFieldType.ftString,
      TFieldType.ftFixedChar,
      TFieldType.ftWideString,
      TFieldType.ftFixedWideChar
        : if FieldSrc.IsNull then
            Result := QuotedStr('')
          else
            Result := QuotedStr(FieldSrc.AsString);
      // entier
      TFieldType.ftSmallint,
      TFieldType.ftInteger,
      TFieldType.ftWord,
      TFieldType.ftBytes,
      TFieldType.ftAutoInc,
      TFieldType.ftLargeint,
      TFieldType.ftLongWord,
      TFieldType.ftShortint,
      TFieldType.ftByte
        : if FieldSrc.IsNull then
            Result := '0'
          else
            Result := FieldSrc.AsString;
      // boolean
      TFieldType.ftBoolean
        : if FieldSrc.IsNull then
            Result := 'false'
          else
            Result := BoolToStr(FieldSrc.AsBoolean, true);
      // flotant
      TFieldType.ftFloat,
      TFieldType.ftCurrency,
      TFieldType.ftBCD,
      TFieldType.ftFMTBcd,
      TFieldType.ftExtended,
      TFieldType.ftSingle
        : if FieldSrc.IsNull then
            Result := '0.0'
          else
            Result := StringReplace(FloatToStr(RoundTo(FieldSrc.AsFloat, -2)), FormatSettings.DecimalSeparator, '.', []);
      // DateTime
      TFieldType.ftDate
        : if FieldSrc.IsNull then
            Result := QuotedStr('1899-12-30')
          else
            Result := QuotedStr(FormatDateTime('yyyy-mm-dd', FieldSrc.AsDateTime));
      TFieldType.ftTime
        : if FieldSrc.IsNull then
            Result := QuotedStr('00:00:00')
          else
            Result := QuotedStr(FormatDateTime('hh:nn:ss', FieldSrc.AsDateTime));
      TFieldType.ftDateTime,
      TFieldType.ftTimeStamp,
      TFieldType.ftOraTimeStamp,
      TFieldType.ftTimeStampOffset
        : if FieldSrc.IsNull then
            Result := QuotedStr('1899-12-30 00:00:00')
          else
            Result := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', FieldSrc.AsDateTime));
    end;
  end;
end;

function TTraitement.GetFieldNullValue(FieldSrc : TField; DoNull : boolean) : string;
begin
  if DoNull then
    Result := 'NULL'
  else
  begin
    case FieldSrc.DataType of
      // non géré
      TFieldType.ftUnknown,
      TFieldType.ftVarBytes,
      TFieldType.ftBlob,
      TFieldType.ftMemo,
      TFieldType.ftGraphic,
      TFieldType.ftFmtMemo,
      TFieldType.ftParadoxOle,
      TFieldType.ftDBaseOle,
      TFieldType.ftTypedBinary,
      TFieldType.ftCursor,
      TFieldType.ftADT,
      TFieldType.ftArray,
      TFieldType.ftReference,
      TFieldType.ftDataSet,
      TFieldType.ftOraBlob,
      TFieldType.ftOraClob,
      TFieldType.ftVariant,
      TFieldType.ftInterface,
      TFieldType.ftIDispatch,
      TFieldType.ftGuid,
      TFieldType.ftWideMemo,
      TFieldType.ftOraInterval,
      TFieldType.ftConnection,
      TFieldType.ftParams,
      TFieldType.ftStream,
      TFieldType.ftObject
        : raise EConvertError.Create('Type non pris en charge');
      // string
      TFieldType.ftString,
      TFieldType.ftFixedChar,
      TFieldType.ftWideString,
      TFieldType.ftFixedWideChar
        : if FieldSrc.IsNull then
            Result := QuotedStr('')
          else
            Result := QuotedStr('');
      // entier
      TFieldType.ftSmallint,
      TFieldType.ftInteger,
      TFieldType.ftWord,
      TFieldType.ftBytes,
      TFieldType.ftAutoInc,
      TFieldType.ftLargeint,
      TFieldType.ftLongWord,
      TFieldType.ftShortint,
      TFieldType.ftByte
        : Result := '0';
      // boolean
      TFieldType.ftBoolean
        : Result := 'false';
      // flotant
      TFieldType.ftFloat,
      TFieldType.ftCurrency,
      TFieldType.ftBCD,
      TFieldType.ftFMTBcd,
      TFieldType.ftExtended,
      TFieldType.ftSingle
        : Result := '0.0';
      // DateTime
      TFieldType.ftDate
        : Result := QuotedStr('1899-12-30');
      TFieldType.ftTime
        : Result := QuotedStr('00:00:00');
      TFieldType.ftDateTime,
      TFieldType.ftTimeStamp,
      TFieldType.ftOraTimeStamp,
      TFieldType.ftTimeStampOffset
        : Result := QuotedStr('1899-12-30 00:00:00');
    end;
  end;
end;

function TTraitement.GetFieldDiffStr(FieldSrc, FieldDst : TField) : string;
begin
  case FieldSrc.DataType of
    // non géré
    TFieldType.ftUnknown,
    TFieldType.ftVarBytes,
    TFieldType.ftBlob,
    TFieldType.ftMemo,
    TFieldType.ftGraphic,
    TFieldType.ftFmtMemo,
    TFieldType.ftParadoxOle,
    TFieldType.ftDBaseOle,
    TFieldType.ftTypedBinary,
    TFieldType.ftCursor,
    TFieldType.ftADT,
    TFieldType.ftArray,
    TFieldType.ftReference,
    TFieldType.ftDataSet,
    TFieldType.ftOraBlob,
    TFieldType.ftOraClob,
    TFieldType.ftVariant,
    TFieldType.ftInterface,
    TFieldType.ftIDispatch,
    TFieldType.ftGuid,
    TFieldType.ftWideMemo,
    TFieldType.ftOraInterval,
    TFieldType.ftConnection,
    TFieldType.ftParams,
    TFieldType.ftStream,
    TFieldType.ftObject
      : raise EConvertError.Create('Type non pris en charge');
    // string
    TFieldType.ftString,
    TFieldType.ftFixedChar,
    TFieldType.ftWideString,
    TFieldType.ftFixedWideChar
      : raise EConvertError.Create('Type non pris en charge');
    // entier
    TFieldType.ftSmallint,
    TFieldType.ftInteger,
    TFieldType.ftWord,
    TFieldType.ftBytes,
    TFieldType.ftAutoInc,
    TFieldType.ftLargeint,
    TFieldType.ftLongWord,
    TFieldType.ftShortint,
    TFieldType.ftByte
      : Result := IntToStr(FieldSrc.AsInteger - FieldDst.AsInteger);
    // boolean
    TFieldType.ftBoolean
      : raise EConvertError.Create('Type non pris en charge');
    // flotant
    TFieldType.ftFloat,
    TFieldType.ftCurrency,
    TFieldType.ftBCD,
    TFieldType.ftFMTBcd,
    TFieldType.ftExtended,
    TFieldType.ftSingle
      : Result := StringReplace(FloatToStr(RoundTo(FieldSrc.AsFloat - FieldDst.AsFloat, -2)), FormatSettings.DecimalSeparator, '.', []);
    // DateTime
    TFieldType.ftDate
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftTime
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftDateTime,
    TFieldType.ftTimeStamp,
    TFieldType.ftOraTimeStamp,
    TFieldType.ftTimeStampOffset
      : raise EConvertError.Create('Type non pris en charge');
  end;
end;

function TTraitement.GetFieldDiffInt(FieldSrc, FieldDst : TField) : integer;
begin
  case FieldSrc.DataType of
    // non géré
    TFieldType.ftUnknown,
    TFieldType.ftVarBytes,
    TFieldType.ftBlob,
    TFieldType.ftMemo,
    TFieldType.ftGraphic,
    TFieldType.ftFmtMemo,
    TFieldType.ftParadoxOle,
    TFieldType.ftDBaseOle,
    TFieldType.ftTypedBinary,
    TFieldType.ftCursor,
    TFieldType.ftADT,
    TFieldType.ftArray,
    TFieldType.ftReference,
    TFieldType.ftDataSet,
    TFieldType.ftOraBlob,
    TFieldType.ftOraClob,
    TFieldType.ftVariant,
    TFieldType.ftInterface,
    TFieldType.ftIDispatch,
    TFieldType.ftGuid,
    TFieldType.ftWideMemo,
    TFieldType.ftOraInterval,
    TFieldType.ftConnection,
    TFieldType.ftParams,
    TFieldType.ftStream,
    TFieldType.ftObject
      : raise EConvertError.Create('Type non pris en charge');
    // string
    TFieldType.ftString,
    TFieldType.ftFixedChar,
    TFieldType.ftWideString,
    TFieldType.ftFixedWideChar
      : raise EConvertError.Create('Type non pris en charge');
    // entier
    TFieldType.ftSmallint,
    TFieldType.ftInteger,
    TFieldType.ftWord,
    TFieldType.ftBytes,
    TFieldType.ftAutoInc,
    TFieldType.ftLargeint,
    TFieldType.ftLongWord,
    TFieldType.ftShortint,
    TFieldType.ftByte
      : Result := FieldSrc.AsInteger - FieldDst.AsInteger;
    // boolean
    TFieldType.ftBoolean
      : raise EConvertError.Create('Type non pris en charge');
    // flotant
    TFieldType.ftFloat,
    TFieldType.ftCurrency,
    TFieldType.ftBCD,
    TFieldType.ftFMTBcd,
    TFieldType.ftExtended,
    TFieldType.ftSingle
      : raise EConvertError.Create('Type non pris en charge');
    // DateTime
    TFieldType.ftDate
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftTime
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftDateTime,
    TFieldType.ftTimeStamp,
    TFieldType.ftOraTimeStamp,
    TFieldType.ftTimeStampOffset
      : raise EConvertError.Create('Type non pris en charge');
    else
      raise EConvertError.Create('Type non pris en charge');
  end;
end;

function TTraitement.GetFieldDiffExt(FieldSrc, FieldDst : TField) : extended;
begin
  case FieldSrc.DataType of
    // non géré
    TFieldType.ftUnknown,
    TFieldType.ftVarBytes,
    TFieldType.ftBlob,
    TFieldType.ftMemo,
    TFieldType.ftGraphic,
    TFieldType.ftFmtMemo,
    TFieldType.ftParadoxOle,
    TFieldType.ftDBaseOle,
    TFieldType.ftTypedBinary,
    TFieldType.ftCursor,
    TFieldType.ftADT,
    TFieldType.ftArray,
    TFieldType.ftReference,
    TFieldType.ftDataSet,
    TFieldType.ftOraBlob,
    TFieldType.ftOraClob,
    TFieldType.ftVariant,
    TFieldType.ftInterface,
    TFieldType.ftIDispatch,
    TFieldType.ftGuid,
    TFieldType.ftWideMemo,
    TFieldType.ftOraInterval,
    TFieldType.ftConnection,
    TFieldType.ftParams,
    TFieldType.ftStream,
    TFieldType.ftObject
      : raise EConvertError.Create('Type non pris en charge');
    // string
    TFieldType.ftString,
    TFieldType.ftFixedChar,
    TFieldType.ftWideString,
    TFieldType.ftFixedWideChar
      : raise EConvertError.Create('Type non pris en charge');
    // entier
    TFieldType.ftSmallint,
    TFieldType.ftInteger,
    TFieldType.ftWord,
    TFieldType.ftBytes,
    TFieldType.ftAutoInc,
    TFieldType.ftLargeint,
    TFieldType.ftLongWord,
    TFieldType.ftShortint,
    TFieldType.ftByte
      : Result := FieldSrc.AsInteger - FieldDst.AsInteger;
    // boolean
    TFieldType.ftBoolean
      : raise EConvertError.Create('Type non pris en charge');
    // flotant
    TFieldType.ftFloat,
    TFieldType.ftCurrency,
    TFieldType.ftBCD,
    TFieldType.ftFMTBcd,
    TFieldType.ftExtended,
    TFieldType.ftSingle
      : Result := RoundTo(FieldSrc.AsFloat - FieldDst.AsFloat, -2);
    // DateTime
    TFieldType.ftDate
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftTime
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftDateTime,
    TFieldType.ftTimeStamp,
    TFieldType.ftOraTimeStamp,
    TFieldType.ftTimeStampOffset
      : raise EConvertError.Create('Type non pris en charge');
    else
      raise EConvertError.Create('Type non pris en charge');
  end;
end;

function TTraitement.GetFieldInv(FieldSrc : TField) : string;
begin
  case FieldSrc.DataType of
    // non géré
    TFieldType.ftUnknown,
    TFieldType.ftVarBytes,
    TFieldType.ftBlob,
    TFieldType.ftMemo,
    TFieldType.ftGraphic,
    TFieldType.ftFmtMemo,
    TFieldType.ftParadoxOle,
    TFieldType.ftDBaseOle,
    TFieldType.ftTypedBinary,
    TFieldType.ftCursor,
    TFieldType.ftADT,
    TFieldType.ftArray,
    TFieldType.ftReference,
    TFieldType.ftDataSet,
    TFieldType.ftOraBlob,
    TFieldType.ftOraClob,
    TFieldType.ftVariant,
    TFieldType.ftInterface,
    TFieldType.ftIDispatch,
    TFieldType.ftGuid,
    TFieldType.ftWideMemo,
    TFieldType.ftOraInterval,
    TFieldType.ftConnection,
    TFieldType.ftParams,
    TFieldType.ftStream,
    TFieldType.ftObject
      : raise EConvertError.Create('Type non pris en charge');
    // string
    TFieldType.ftString,
    TFieldType.ftFixedChar,
    TFieldType.ftWideString,
    TFieldType.ftFixedWideChar
      : raise EConvertError.Create('Type non pris en charge');
    // entier
    TFieldType.ftSmallint,
    TFieldType.ftInteger,
    TFieldType.ftWord,
    TFieldType.ftBytes,
    TFieldType.ftAutoInc,
    TFieldType.ftLargeint,
    TFieldType.ftLongWord,
    TFieldType.ftShortint,
    TFieldType.ftByte
      : Result := IntToStr(-FieldSrc.AsInteger);
    // boolean
    TFieldType.ftBoolean
      : raise EConvertError.Create('Type non pris en charge');
    // flotant
    TFieldType.ftFloat,
    TFieldType.ftCurrency,
    TFieldType.ftBCD,
    TFieldType.ftFMTBcd,
    TFieldType.ftExtended,
    TFieldType.ftSingle
      : Result := StringReplace(FloatToStr(-FieldSrc.AsFloat), FormatSettings.DecimalSeparator, '.', []);
    // DateTime
    TFieldType.ftDate
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftTime
      : raise EConvertError.Create('Type non pris en charge');
    TFieldType.ftDateTime,
    TFieldType.ftTimeStamp,
    TFieldType.ftOraTimeStamp,
    TFieldType.ftTimeStampOffset
      : raise EConvertError.Create('Type non pris en charge');
  end;
end;

// Gestion de log

procedure TTraitement.DoLogInfosUtils();

  function GetIPAddress() : TStringList;
  type
    pu_long = ^u_long;
  var
    varTWSAData : TWSAData;
    namebuf : Array[0..255] of ansichar;
    varPHostEnt : PHostEnt;
    i : integer;
    varTInAddr : TInAddr;
  begin
    Result := TStringList.Create();
    try
      if WSAStartup($101, varTWSAData) = 0 Then
      begin
        gethostname(namebuf, sizeof(namebuf));
        varPHostEnt := gethostbyname(namebuf);
        i := 0;
        while varPHostEnt^.h_addr_list[i] <> nil do
        begin
          varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list[i])^);
          Result.Add(String(inet_ntoa(varTInAddr)));
          Inc(i);
        end;
      end;
    finally
      WSACleanup();
    end;
  end;

var
  i, j, nbSec : integer;
  ListIps : TStringList;
  tmpLogApp : string;
begin
  nbSec := 48 * 60 * 60; // deux jours !

  try
    ListIps := GetIPAddress();
    for i := 0 to FListMag.Count -1 do
    begin
      if FListMag[i].Actif then
      begin
        // version des exe
        Log.Log(FLogMdl, FLogRef, IntToStr(FListMag[i].MagId), 'Version', ReadFileVersion('ExtractBI.exe'), logInfo, true, nbSec);
        try
          tmpLogApp := Log.App;
          Log.App := 'ServiceBI';
          Log.Log(FLogMdl, FLogRef, IntToStr(FListMag[i].MagId), 'Version', ReadFileVersion('ServiceBI.exe'), logInfo, true, nbSec);
        finally
          Log.App := tmpLogApp;
        end;
        // Liste des IPs
        for j := 0 to ListIps.Count -1 do
          Log.Log(FLogMdl, FLogRef, IntToStr(FListMag[i].MagId), 'IP' + IntToStr(j), ListIps[j], logInfo, true, nbSec);
        // log de temporisation des module
        for j := 0 to Length(LISTE_MODULE_MONITORING) do
          Log.Log(LISTE_MODULE_MONITORING[j], FLogRef, IntToStr(FListMag[i].MagId), FLogKey, 'Fin', logInfo, true);
      end;
    end;
  finally
    FreeAndNil(ListIps);
  end;
end;

procedure TTraitement.DoLogMultiLine(Msg : string; level : TLogLevel; Ovl : boolean);
var
  i : integer;
begin
  if level > logTrace then
  begin
    for i := 0 to FListMag.Count -1 do
    begin
      if FListMag[i].Actif then
        Log.Log(FLogMdl, FLogRef, IntToStr(FListMag[i].MagId), FLogKey, Msg, level, Ovl);
    end;
  end
  else
    Log.Log(FLogMdl, FLogRef, '', FLogKey, Msg, level, Ovl);
end;

procedure TTraitement.DoLogMultiLine(Msg : string; level : TLogLevel; Magasin : TMagasin; Ovl : boolean);
begin
  if level > logTrace then
    Log.Log(FLogMdl, FLogRef, IntToStr(Magasin.MagId), FLogKey, Msg, level, Ovl)
  else
    Log.Log(FLogMdl, FLogRef, '', FLogKey, Msg, level, Ovl);
end;

function TTraitement.GetExceptionMessage(e : Exception) : string;
begin
  Result := StringReplace(StringReplace(e.ClassName + ' - ' + e.Message, #13, '', [rfReplaceAll, rfIgnoreCase]), #10, ' ', [rfReplaceAll, rfIgnoreCase]);
end;

// Recupeartion des plages !

function TTraitement.GetPlages(out LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer) : boolean;
var
  QueryGnk : TMyQuery;
  Requete : string;
  IdGenerateur : string;
begin
  Result := false;
  Requete := '';
  QueryGnk := nil;
  IdGenerateur := '';
  LamePlageDeb := 0;
  LamePlageFin := 0;
  MagPlageDeb := 0;
  MagPlageFin := 0;

  DoLogMultiLine('TTraitement.GetPlages', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();
      try
        QueryGnk := GetNewQuery(FConnexionGnk, FTransactionGnk);
        // recup du generateur
        Requete := 'select par_string from genparambase where par_nom = ''IDGENERATEUR'';';
        QueryGnk.SQL.Text := Requete;
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            IdGenerateur := QueryGnk.FieldByName('par_string').AsString
          else
            raise Exception.Create('ID Generateur non trouvé');
        finally
          QueryGnk.Close();
        end;
        // recup de la plage lame
        Requete := 'select bas_plage from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ''0'';';
        QueryGnk.SQL.Text := Requete;
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            DecodePlage(QueryGnk.FieldByName('bas_plage').AsString, LamePlageDeb, LamePlageFin)
          else
            raise Exception.Create('Plage de la lame non trouvé');
        finally
          QueryGnk.Close();
        end;
        // recup de la plage magasin
        Requete := 'select bas_plage from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ' + QuotedStr(IdGenerateur) + ';';
        QueryGnk.SQL.Text := Requete;
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            DecodePlage(QueryGnk.FieldByName('bas_plage').AsString, MagPlageDeb, MagPlageFin)
          else
            raise Exception.Create('Plage magasin non trouvé');
        finally
          QueryGnk.Close();
        end;

        // si on arrive ici ...
        Result := true;
      finally
        FreeAndNil(QueryGnk);
      end;
    finally
      FTransactionGnk.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := false;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.GetListLastID(var ListeLastId : TListLastIDs) : boolean;
var
  QueryTpn : TMyQuery;
  Requete : string;
begin
  Result := false;
  Requete := '';
  QueryTpn := nil;
  if Assigned(ListeLastId) then
    ListeLastId.Clear()
  else
    ListeLastId := TListLastIDs.Create([doOwnsValues]);

  DoLogMultiLine('TTraitement.GetListLastID', logTrace);

  try
    try
      FTransactionTpn.StartTransaction();
      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
        // recup du generateur
        Requete := 'select VerMagId, VerNomTable, VerLastVersion from TVersion;';
        QueryTpn.SQL.Text := Requete;
        try
          QueryTpn.Open();
          while not QueryTpn.Eof do
          begin
            if not ListeLastId.ContainsKey(QueryTpn.FieldByName('VerMagId').AsInteger) then
              ListeLastId.Add(QueryTpn.FieldByName('VerMagId').AsInteger, TDictionary<string, integer>.Create());
            ListeLastId[QueryTpn.FieldByName('VerMagId').AsInteger].Add(QueryTpn.FieldByName('VerNomTable').AsString, QueryTpn.FieldByName('VerLastVersion').AsInteger);
            QueryTpn.Next();
          end;
        finally
          QueryTpn.Close();
        end;

        // si on arrive ici ...
        Result := true;
      finally
        FreeAndNil(QueryTpn);
      end;
    finally
      FTransactionTpn.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := false;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

procedure TTraitement.GetMaxKVersionOf(Query : TMyQuery; PlageDeb, PlageFin : integer; var CurrentID : integer);
var
  i : integer;
  Champ : TField;
begin
  for i := 0 to Length(FIELDS_KVERSION) -1 do
  begin
    Champ := Query.FindField(FIELDS_KVERSION[i]);
    if Assigned(Champ) then
    begin
      if (Champ.AsInteger >= PlageDeb) and (Champ.AsInteger <= PlageFin) then
        CurrentID := Max(CurrentID, Champ.AsInteger);
    end;
  end;
end;

function TTraitement.GetOneFieldOf(Query : TMyQuery; List : array of string) : TField;
var
  i : integer;
begin
  result := nil;
  for i := 0 to Length(List) -1 do
  begin
    Result := Query.FindField(List[i]);
    if Assigned(Result) then
      Exit;
  end;
end;

// Preparation des requete

function TTraitement.GetWhere(Query : TMyQuery; NomCle : array of string; DoNull : boolean) : string;
var
  i : integer;
begin
  Result := '';

  // creation du where avec la clé !
  if Assigned(Query) then
  begin
    for i := 0 to Query.Fields.Count -1 do
    begin
      if IndexText(Query.Fields[i].FieldName, NomCle) >= 0 then
      begin
        if Result = '' then
          Result := Query.Fields[i].FieldName + ' = ' + GetFieldData(Query.Fields[i], DoNull)
        else
          Result := Result + ' and ' + Query.Fields[i].FieldName + ' = ' + GetFieldData(Query.Fields[i], DoNull);
      end;
    end;
  end
  else
  begin
    for i := 0 to Length(NomCle) -1 do
    begin
      if Result = '' then
        Result := NomCle[i] + ' is null'
      else
        Result := Result + ' and ' + NomCle[i] + ' is null';
    end;
  end;
end;

function TTraitement.GetWhereNotID0(NomCle : array of string; DoNull : boolean) : string;
var
  i : integer;
begin
  Result := '';

  for i := 0 to Length(NomCle) -1 do
  begin
    // il y a des date dans les cles ...
    // et nous ne traiterons pas les date ici !
    if Pos('DATE', UpperCase(NomCle[i])) = 0 then
    begin
      if Result = '' then
        Result := NomCle[i] + ' != 0'
      else
        Result := Result + ' and ' + NomCle[i] + ' != 0';
    end;
  end;
end;

function TTraitement.GetIdentArticle(ModId, TgfId, CouId : integer) : string;
begin
  Result := 'ModId = ' + IntToStr(ModId) + ' and TgfId = ' + IntToStr(TgfId) + ' and CouId = ' + IntToStr(CouId);
end;

function TTraitement.GetInsertRequete(Query : TMyQuery; NomTable : string; DoNull : boolean; ListeChamps : TListeChamps) : string;
var
  i : integer;
  LstChamps, LstValeurs : string;
begin
  Result := '';
  LstChamps := '';
  LstValeurs := '';

  // requete d'insert
  for i := 0 to Query.Fields.Count -1 do
  begin
    if (IndexText(Query.Fields[i].FieldName, FFieldToIgnore) < 0) and
       ((Length(ListeChamps) = 0) or (IndexText(Query.Fields[i].FieldName, ListeChamps) >= 0)) then
    begin
      if LstChamps = '' then
        LstChamps := Query.Fields[i].FieldName
      else
        LstChamps := LstChamps + ', ' + Query.Fields[i].FieldName;
      if LstValeurs = '' then
        LstValeurs := GetFieldData(Query.Fields[i], DoNull)
      else
        LstValeurs := LstValeurs + ', ' + GetFieldData(Query.Fields[i], DoNull);
    end;
  end;
  // seulement s'il y a qqchose
  if not (Trim(LstChamps) = '') then
    Result := 'insert into ' + NomTable + ' (' + LstChamps + ') values (' + LstValeurs + ');';
end;

function TTraitement.GetUpdateRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean; ListeChamps : TListeChamps) : string;
var
  i : integer;
  LstUpdate, WhereCle : string;
begin
  Result := '';
  LstUpdate := '';
  WhereCle := '';

  // requete de mise-à-jour
  for i := 0 to QuerySrc.Fields.Count -1 do
  begin
    if (IndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (IndexText(QuerySrc.Fields[i].FieldName, NomCle) < 0) then
      begin
        if (Length(ListeChamps) = 0) or (IndexText(QuerySrc.Fields[i].FieldName, ListeChamps) >= 0) then
        begin
          if (GetFieldData(QuerySrc.Fields[i], DoNull) <> GetFieldData(QueryDst.FieldByName(QuerySrc.Fields[i].FieldName), DoNull)) then
          begin
            if LstUpdate = '' then
              LstUpdate := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull)
            else
              LstUpdate := LstUpdate + ', ' + QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull);
          end;
        end;
      end
      else
      begin
        if WhereCle = '' then
          WhereCle := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull)
        else
          WhereCle := WhereCle + ' and ' + QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull);
      end;
    end;
  end;
  // seulement si qqchose a changer
  if not (Trim(LstUpdate) = '') then
    Result := 'update ' + NomTable + ' set ' + LstUpdate + ' where ' + WhereCle + ';';
end;

function TTraitement.GetDummyUpdateRequete(QuerySrc : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;
var
  i : integer;
  LstUpdate, WhereCle : string;
begin
  Result := '';
  LstUpdate := '';
  WhereCle := '';

  // requete de mise-à-jour
  for i := 0 to QuerySrc.Fields.Count -1 do
  begin
    if (IndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (IndexText(QuerySrc.Fields[i].FieldName, NomCle) < 0) then
      begin
        if LstUpdate = '' then
          LstUpdate := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull)
      end
      else
      begin
        if WhereCle = '' then
          WhereCle := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull)
        else
          WhereCle := WhereCle + ' and ' + QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull);
      end;
    end;
  end;
  Result := 'update ' + NomTable + ' set ' + LstUpdate + ' where ' + WhereCle + ';';
end;

function TTraitement.GetInsertMajRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
var
  i : integer;
  LstChamps, LstValeurs, LstChpDiff, LstValDiff : string;
begin
  Result := '';
  LstChamps := '';
  LstValeurs := '';
  LstChpDiff := '';
  LstValDiff := '';

  // requete d'inster
  for i := 0 to QuerySrc.Fields.Count -1 do
  begin
    if (IndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (IndexText(QuerySrc.Fields[i].FieldName, FieldDiff) < 0) then
      begin
        if LstChamps = '' then
          LstChamps := QuerySrc.Fields[i].FieldName
        else
          LstChamps := LstChamps + ', ' + QuerySrc.Fields[i].FieldName;
        if LstValeurs = '' then
          LstValeurs := GetFieldData(QuerySrc.Fields[i], DoNull)
        else
          LstValeurs := LstValeurs + ', ' + GetFieldData(QuerySrc.Fields[i], DoNull);
      end
      else
      begin
        if (GetFieldData(QuerySrc.Fields[i], DoNull) <> GetFieldData(QueryDst.FieldByName(QuerySrc.Fields[i].FieldName), DoNull)) then
        begin
          LstChpDiff := LstChpDiff + ', ' + QuerySrc.Fields[i].FieldName;
          LstValDiff := LstValDiff + ', ' + GetFieldDiffStr(QuerySrc.Fields[i], QueryDst.FieldByName(QuerySrc.Fields[i].FieldName));
        end;
      end;
    end;
  end;
  // seulement si qqchose a changer
  if not (Trim(LstChpDiff) = '') then
    Result := 'insert into ' + NomTable + ' (' + LstChamps + LstChpDiff + ') values (' + LstValeurs + LstValDiff + ');';
end;

function TTraitement.GetInsertDelRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
var
  i : integer;
  LstChamps, LstValeurs, LstChpDiff, LstValDiff : string;
begin
  Result := '';
  LstChamps := '';
  LstValeurs := '';
  LstChpDiff := '';
  LstValDiff := '';

  // requete d'insert
  for i := 0 to QuerySrc.Fields.Count -1 do
  begin
    if (IndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (IndexText(QuerySrc.Fields[i].FieldName, FieldDiff) < 0) then
      begin
        if LstChamps = '' then
          LstChamps := QuerySrc.Fields[i].FieldName
        else
          LstChamps := LstChamps + ', ' + QuerySrc.Fields[i].FieldName;
        if LstValeurs = '' then
          LstValeurs := GetFieldData(QuerySrc.Fields[i], DoNull)
        else
          LstValeurs := LstValeurs + ', ' + GetFieldData(QuerySrc.Fields[i], DoNull);
      end
      else
      begin
        LstChpDiff := LstChpDiff + ', ' + QuerySrc.Fields[i].FieldName;
        LstValDiff := LstValDiff + ', ' + GetFieldInv(QueryDst.FieldByName(QuerySrc.Fields[i].FieldName)); // la valeur inverse de ce qu'il y a deja !
      end;
    end;
  end;
  // seulement si qqchose a changer
  if not (Trim(LstChpDiff) = '') then
    Result := 'insert into ' + NomTable + ' (' + LstChamps + LstChpDiff + ') values (' + LstValeurs + LstValDiff + ');';
end;

function TTraitement.GetUpdateDelRequete(QuerySrc : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
var
  i : integer;
  LstUpdate, WhereCle : string;
begin
  Result := '';
  LstUpdate := '';
  WhereCle := '';

  // requete de mise-à-jour
  for i := 0 to QuerySrc.Fields.Count -1 do
  begin
    if (IndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (IndexText(QuerySrc.Fields[i].FieldName, NomCle) < 0) then
      begin
        if (IndexText(QuerySrc.Fields[i].FieldName, FieldDiff) >= 0) then
        begin
          if LstUpdate = '' then
            LstUpdate := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldNullValue(QuerySrc.Fields[i], DoNull)
          else
            LstUpdate := LstUpdate + ', ' + QuerySrc.Fields[i].FieldName + ' = ' + GetFieldNullValue(QuerySrc.Fields[i], DoNull);
        end;
      end
      else
      begin
        if WhereCle = '' then
          WhereCle := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull)
        else
          WhereCle := WhereCle + ' and ' + QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull);
      end;
    end;
  end;
  // seulement si qqchose a changer
  if not (Trim(LstUpdate) = '') then
    Result := 'update ' + NomTable + ' set ' + LstUpdate + ' where ' + WhereCle + ';';
end;

function TTraitement.GetDeleteRequete(QuerySrc : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;
begin
  Result := 'delete from ' + NomTable + ' where ' + GetWhere(QuerySrc, NomCle, DoNull) + ';';
end;

function TTraitement.GetLastVersion(MagId : integer; Name : string; ListeLastId : TListLastIDs) : integer;
begin
  if ListeLastId.ContainsKey(MagId) then
  begin
    if ListeLastId[MagId].ContainsKey(Name) then
      Result := ListeLastId[MagId][Name]
    else
      Result := -1;
  end
  else
    Result := -1;
end;

function TTraitement.SetLastVersion(MagId : integer; Name : string; Value : integer; ListeLastId : TListLastIDs; Force : boolean) : string;
begin
  if ListeLastId.ContainsKey(MagId) then
  begin
    if ListeLastId[MagId].ContainsKey(Name) then
    begin
      if Force then
        ListeLastId[MagId][Name] := Value
      else
        ListeLastId[MagId][Name] := Max(ListeLastId[MagId][Name], Value);
      Result := 'update TVersion set VerLastVersion = ' + IntToStr(ListeLastId[MagId][Name]) + ' where VerMagId = ' + IntToStr(MagId) + ' and VerNomTable = ' + QuotedStr(Name) + ';'
    end
    else
    begin
      ListeLastId[MagId].Add(Name, Value);
      Result := 'insert into TVersion (VerMagId, VerNomTable, VerLastVersion) values (' + IntToStr(MagId) + ', ' + QuotedStr(Name) + ', ' + IntToStr(ListeLastId[MagId][Name]) + ');';
    end;
  end
  else
  begin
    ListeLastId.Add(MagId, TDictionary<string, integer>.Create());
    ListeLastId[MagId].Add(Name, Value);
    Result := 'insert into TVersion (VerMagId, VerNomTable, VerLastVersion) values (' + IntToStr(MagId) + ', ' + QuotedStr(Name) + ', ' + IntToStr(ListeLastId[MagId][Name]) + ');';
  end;
end;

// gestion d'erreur de script !

function TTraitement.ReLaunchScriptError(Script : TMyScript; Query : TMyQuery) : string;
var
  Start : string;
begin
  Result := '';
  if Script.Status = ssFinishWithErrors then
  begin
    // recup de la fin du script !
    Start := TrimLeft(ReverseString(Copy(Script.SQLScripts[0].SQL.Text, 0, Script.TotalJobDone)));
    if Trim(Start) = '' then
      raise Exception.Create('Unknown SQL error...');
    // recup de la premiere requete (celle qui plante !!)
    Result := ReverseString(Copy(Start, 1, Pos(#10#13, Start) -1));
    if Trim(Result) = '' then
      raise Exception.Create('Unknown SQL error...');
    if Assigned(Query) then
    begin
      // execution de la requete pour lever l'exception !
      Query.SQL.Text := Result;
      Query.ExecSQL();
      // si on arrive ici ???
      raise Exception.Create('Unknown SQL error...');
    end;
  end;
end;

procedure TTraitement.SaveScript(Libelle : string; Scripts : TMyScript);
var
  FileDir, FileDate : string;
  i : integer;
begin
  FileDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(getApplicationFileName()) + 'logs') + 'Scripts');
  FileDate := FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now());
  ForceDirectories(FileDir);
  for i := 0 to Scripts.SQLScripts.Count -1 do
    Scripts.SQLScripts[i].SQL.SaveToFile(FileDir + FileDate + '_' + Libelle + '_' + IntToStr(i) + '.sql');
end;

// gestion au cas par cas

function TTraitement.DoGestionArticle(QueryGnk, QueryTpn, QueryMaj : TMyQuery; ModId, TgfId, CouId : integer; DoMaj, DoNull : boolean) : boolean;
var
  WhereCle, Requete : string;
begin
  Requete := '';
  WhereCle := '';

  // pas de transaction ici
  // ... car il doit y avoir une transaction autour de l'appele de catte fonction normalement !!

  if (ModId = 0) and (TgfId = 0) and (CouId = 0) then
    Result := true
  else
  begin
    Result := false;

    try
      Requete := 'select * from BI15_TARTICLE_ID(' + IntToStr(ModId) + ', ' + IntToStr(TgfId) + ', ' +  IntToStr(CouId) + ');';
      QueryGnk.SQL.Text := Requete;
      try
        QueryGnk.Open();
        if not QueryGnk.Eof then
        begin
          // test sur l'article ...
          if not ((ModId = QueryGnk.FieldByName('ModId').AsInteger) and (TgfId = QueryGnk.FieldByName('TgfId').AsInteger) and (CouId = QueryGnk.FieldByName('CouId').AsInteger)) then
            Exit;

          WhereCle := GetIdentArticle(ModId, TgfId, CouId);
          Requete := 'select * from TArticle where ' + WhereCle + ';';
          QueryTpn.SQL.Text := Requete;
          try
            QueryTpn.Open();
            if QueryTpn.Eof then
            begin
              // l'article n'existe pas ???
              // il faut le créer
              Requete := GetInsertRequete(QueryGnk, 'TArticle', DoNull);
              DoLogMultiLine('Creation d''article : "' + WhereCle + '"', logDebug);
              DoLogMultiLine('  requete : ' + Requete, logNone);
              QueryMaj.SQL.Text := Requete;
              QueryMaj.ExecSQL();
            end
            else
            begin
              // ancien -> Update
              if DoMaj then
              begin
                Requete := GetUpdateRequete(QueryGnk, QueryTpn, 'TArticle', ['ModId', 'TgfId', 'CouId'], DoNull);
                if not (Trim(Requete) = '') then
                begin
                  DoLogMultiLine('Mise-a-jour d''article : "' + WhereCle + '"', logDebug);
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryMaj.SQL.Text := Requete;
                  QueryMaj.ExecSQL();
                end
                else
                  DoLogMultiLine('  Attention : Pas de MAJ pour l''article "' + WhereCle + '"', logNone);
              end
              else
                DoLogMultiLine('  Attention : Update skipped pour l''article "' + WhereCle + '"', logNone);
            end;
            Result := true;
          finally
            QueryTpn.Close();
          end;
        end;
      finally
        QueryGnk.Close();
      end;
      // maj des collection du modèle
      if Result then
        Result := DoGestionCollection(QueryGnk, QueryTpn, QueryMaj, ModId, DoMaj, DoNull);
    except
      on e : Exception do
      begin
        Result := false;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

function TTraitement.DoGestionCollection(QueryGnk, QueryTpn, QueryMaj : TMyQuery; ModId : integer; DoMaj, DoNull : boolean) : boolean;
var
  WhereCle, Requete : string;
begin
  Requete := '';
  WhereCle := '';

  // pas de transaction ici
  // ... car il doit y avoir une transaction autour de l'appele de catte fonction normalement !!

  if (ModId = 0) then
    Result := true
  else
  begin
    Result := false;

    try
      Requete := 'select * from BI15_TARTICLECOL_ID(' + IntToStr(ModId) + ');';
      QueryGnk.SQL.Text := Requete;
      try
        QueryGnk.Open();
        while not QueryGnk.Eof do
        begin
          // test sur l'article ...
          if not (ModId = QueryGnk.FieldByName('ModId').AsInteger) then
            Exit;

          WhereCle := GetWhere(QueryGnk, ['ModId', 'ColId'], DoNull);
          Requete := 'select * from tarticlecol where ' + WhereCle + ';';
          QueryTpn.SQL.Text := Requete;
          try
            QueryTpn.Open();
            if QueryTpn.Eof then
            begin
              // la collection n'existe pas ???
              // il faut le créer
              Requete := GetInsertRequete(QueryGnk, 'tarticlecol', DoNull);
              DoLogMultiLine('  requete : ' + Requete, logNone);
              QueryMaj.SQL.Text := Requete;
              QueryMaj.ExecSQL();
            end
            else
            begin
              // ancien -> Update
              if DoMaj then
              begin
                Requete := GetUpdateRequete(QueryGnk, QueryTpn, 'tarticlecol', ['ModId', 'ColId'], DoNull);
                if not (Trim(Requete) = '') then
                begin
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryMaj.SQL.Text := Requete;
                  QueryMaj.ExecSQL();
                end;
              end;
            end;
          finally
            QueryTpn.Close();
          end;
          QueryGnk.Next();
        end;
        Result := true;
      finally
        QueryGnk.Close();
      end;
    except
      on e : Exception do
      begin
        Result := false;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

function TTraitement.DoGestionFournisseur(QueryGnk, QueryTpn, QueryMaj : TMyQuery; FouId : integer; DoMaj, DoNull : boolean) : boolean;
var
  WhereCle, Requete : string;
begin
  Requete := '';
  WhereCle := '';

  // pas de transaction ici
  // ... car il doit y avoir une transaction autour de l'appele de catte fonction normalement !!

  if (FouId = 0) then
    Result := true
  else
  begin
    Result := false;

    try
      WhereCle := 'FouId = ' + IntToStr(FouId);
      Requete := 'select * from TFournisseur where ' + WhereCle + ';';
      QueryTpn.SQL.Text := Requete;
      try
        QueryTpn.Open();
        if QueryTpn.Eof then
        begin
          // le fournisseur n'existe pas ???
          // il faut le créer
          Requete := 'select * from BI15_TFOURNISSEUR_ID(' + IntToStr(FouId) + ');';
          QueryGnk.SQL.Text := Requete;
          try
            QueryGnk.Open();
            if not QueryGnk.Eof then
            begin
              Requete := GetInsertRequete(QueryGnk, 'TFournisseur', DoNull);
              DoLogMultiLine('Creation du fournisseur : "' + WhereCle + '"', logDebug);
              DoLogMultiLine('  requete : ' + Requete, logNone);
              QueryMaj.SQL.Text := Requete;
              QueryMaj.ExecSQL();
              Result := true;
            end;
          finally
            QueryGnk.Close();
          end;
        end
        else
        begin
          Result := true;
          // ancien -> Update
          if DoMaj then
          begin
            Requete := 'select * from BI15_TFOURNISSEUR_ID(' + IntToStr(FouId) + ');';
            QueryGnk.SQL.Text := Requete;
            try
              QueryGnk.Open();
              if not QueryGnk.Eof then
              begin
                Requete := GetUpdateRequete(QueryGnk, QueryTpn, 'TFournisseur', ['FouId'], DoNull);
                if not (Trim(Requete) = '') then
                begin
                  DoLogMultiLine('Mise-a-jour du fournisseur : "' + WhereCle + '"', logDebug);
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryMaj.SQL.Text := Requete;
                  QueryMaj.ExecSQL();
                end
                else
                  DoLogMultiLine('  Attention : Pas de MAJ pour le fournisseur "' + WhereCle + '"', logNone);
              end;
            finally
              QueryGnk.Close();
            end;
          end
          else
            DoLogMultiLine('  Attention : Update skipped pour le fournisseur "' + WhereCle + '"', logNone);
        end;
      finally
        QueryTpn.Close();
      end;
    except
      on e : Exception do
      begin
        Result := false;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

// fonction de copie de table !

function TTraitement.CopieTable(Magasin : TMagasin;
                                LamePlageDeb, LamePlageFin : integer; var LameLastID : integer;
                                MagPlageDeb, MagPlageFin : integer; var MagLastId : integer;
                                NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                                LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                                ListeChamps : TListeChamps) : TEnumResult;
var
  MagIdName, WhereCle, Requete : string;
  tmpLameLastID, tmpMagLastID, NbLignes, NbEnreg : integer;
  QueryGnkLst, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  FieldMagId, FieldSuppr, FieldModId, FieldTgfId, FieldCouId : TField;
begin
  Result := ers_Failed;
  Requete := '';
  QueryGnkLst := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  ScriptTpn := nil;
  ScriptText := nil;
  tmpLameLastID := LameLastID;
  tmpMagLastID := MagLastId;
  NbLignes := 0;
  NbEnreg := 0;

  DoLogMultiLine('TTraitement.CopieTable(' + NomTable + ', ' + Magasin.CodeAdh + ')', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();

      QueryGnkLst := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);
      ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
      ScriptText := ScriptTpn.SQLScripts.Add();

      case LvlReinit of
        erl_ReInitialisation :
          begin
            // recherche du champs MAGID
            Requete := 'select * from ' + NomTable + ' where ' + GetWhere(nil, NomCle, DoNull);
            QueryTpnMaj.SQL.Text := Requete;
            try
              QueryTpnMaj.Open();
              FieldMagId := GetOneFieldOf(QueryTpnMaj, FIELDS_MAGID);
              if Assigned(FieldMagId) then
                MagIdName := FieldMagId.FieldName
              else
                MagIdName := '';
            finally
              QueryTpnMaj.Close();
            end;
            // vidage de la table
            if not (MagIdName = '') then
            begin
              Requete := 'select count(*) from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ' and ' + GetWhereNotID0(NomCle, DoNull) + ';';
              QueryTpnMaj.SQL.Text := Requete;
              try
                QueryTpnMaj.Open();
                if QueryTpnMaj.Eof then
                  NbEnreg := 0
                else
                  NbEnreg := QueryTpnMaj.Fields[0].AsInteger;
              finally
                QueryTpnMaj.Close();
              end;
              if NbEnreg > 0 then
              begin
                DoLogMultiLine('  -> Nettoyage', logTrace);
                Requete := 'delete from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ' and ' + GetWhereNotID0(NomCle, DoNull) + ';';
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();
              end
              else
                DoLogMultiLine('  -> Pas de nettoyage, table vide', logTrace);
            end
            else
              DoLogMultiLine('  -> Pas de nettoyage, champs magid non trouvé', logTrace);
            // reinit des last ID
            tmpLameLastID := -1;
            tmpMagLastID := -1;
          end;
        erl_ReExport, erl_ReMouvement :
          begin
            tmpLameLastID := -1;
            tmpMagLastID := -1;
          end;
      end;

      if (DateMin > 1) and (DateMax > 1) then
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(MagPlageDeb)
                                                           + ', ' + IntToStr(MagPlageFin)
                                                           + ', ' + IntToStr(tmpMagLastID)
                                                           + ', ' + IntToStr(LamePlageDeb)
                                                           + ', ' + IntToStr(LamePlageFin)
                                                           + ', ' + IntToStr(tmpLameLastID)
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMax))
                                                           + ', ' + IntToStr(Magasin.MagId) + ');'
      else if (DateMin > 1) then
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(MagPlageDeb)
                                                           + ', ' + IntToStr(MagPlageFin)
                                                           + ', ' + IntToStr(tmpMagLastID)
                                                           + ', ' + IntToStr(LamePlageDeb)
                                                           + ', ' + IntToStr(LamePlageFin)
                                                           + ', ' + IntToStr(tmpLameLastID)
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                           + ', ' + IntToStr(Magasin.MagId) + ');'
      else
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(MagPlageDeb)
                                                           + ', ' + IntToStr(MagPlageFin)
                                                           + ', ' + IntToStr(tmpMagLastID)
                                                           + ', ' + IntToStr(LamePlageDeb)
                                                           + ', ' + IntToStr(LamePlageFin)
                                                           + ', ' + IntToStr(tmpLameLastID)
                                                           + ', ' + IntToStr(Magasin.MagId) + ');';

      QueryGnkLst.SQL.Text := Requete;
      try
        QueryGnkLst.Open();
        if not QueryGnkLst.Eof then
        begin
          DoLogMultiLine('  -> Creation du script', logTrace);

          while not ((IsInterruptible and Terminated) or QueryGnkLst.Eof) do
          begin
            // recup de la version
            GetMaxKVersionOf(QueryGnkLst, LamePlageDeb, LamePlageFin, tmpLameLastID);
            GetMaxKVersionOf(QueryGnkLst, MagPlageDeb, MagPlageFin, tmpMagLastID);
            // Fileds spéciaux
            FieldSuppr := GetOneFieldOf(QueryGnkLst, FIELD_KENABLED);
            FieldModId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_MODID);
            FieldTgfId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_TGFID);
            FieldCouId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_COUID);
            // recherche si existant
            WhereCle := GetWhere(QueryGnkLst, NomCle, DoNull);
            Requete := 'select * from ' + NomTable + ' where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
              begin
                if (not (DoArt and Assigned(FieldModId) and Assigned(FieldTgfId) and Assigned(FieldCouId))) or // pas demander ou pas de quoi l'identifié ?
                   DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj, FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger, DoMaj, DoNull) then // gestion article
                begin
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoIns then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Insert skipped : "' + Requete + '"', logDebug);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj or (LvlReinit = erl_ReMouvement) then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end
                    else if LvlReinit = erl_ReMouvement then
                    begin
                      Requete := GetDummyUpdateRequete(QueryTpnExt, NomTable, NomCle, DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      ScriptText.SQL.Add(Requete);
                      Inc(NbLignes);
                    end;
                  end;
                end
                else
                begin
                  if FDoErrArt then
                  begin
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logError);
                    Exit;
                  end
                  else
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
                end;
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                if not (Trim(Requete) = '') then
                begin
                  if DoSup then
                  begin
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                    DoLogMultiLine('  Attention : Delete skipped : "' + Requete + '"', logDebug);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                try
                  if not ScriptTpn.ExecuteAll() then
                  begin
                    SaveScript(NomTable, ScriptTpn);
                    Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  end;
                except
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  raise;
                end;
              end
              else
              begin
                SaveScript(NomTable, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              ScriptText.SQL.Clear();
              DoLogMultiLine('  -> re-Creation du script', logTrace);
            end;

            // suivant !!
            QueryGnkLst.Next();
          end;

          // Il en reste ??
          if ScriptText.SQL.Count > 0 then
          begin
            DoLogMultiLine('  -> Execution du script', logTrace);
            if ScriptTpn.ValidateAll() then
            begin
              try
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                end;
              except
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                raise;
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if QueryGnkLst.Eof then
            Result := ers_Succeded
          else
            Result := ers_Interrupted;
          LameLastID := tmpLameLastID;
          MagLastId := tmpMagLastID;
        end
        else
        begin
          DoLogMultiLine('  -> Pas de lignes a traiter', logTrace);
          Result := ers_Succeded;
        end;
      finally
        QueryGnkLst.Close();
      end;
    finally
      FreeAndNil(QueryGnkLst);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FreeAndNil(ScriptText);
      FreeAndNil(ScriptTpn);
      FTransactionGnk.Rollback();
    end;

    DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées', logTrace);

  except
    on e : Exception do
    begin
      Result := ers_Failed;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.CopieTable(LamePlageDeb, LamePlageFin : integer; var LameLastID : integer;
                                MagPlageDeb, MagPlageFin : integer; var MagLastId : integer;
                                NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                                LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                                ListeChamps : TListeChamps) : TEnumResult;
var
  WhereCle, Requete : string;
  tmpLameLastID, tmpMagLastID, NbLignes, NbEnreg : integer;
  QueryGnkLst, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  FieldSuppr, FieldModId, FieldTgfId, FieldCouId : TField;
begin
  Result := ers_Failed;
  Requete := '';
  QueryGnkLst := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  ScriptTpn := nil;
  ScriptText := nil;
  tmpLameLastID := LameLastID;
  tmpMagLastID := MagLastId;
  NbLignes := 0;
  NbEnreg := 0;

  DoLogMultiLine('TTraitement.CopieTable(' + NomTable + ')', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();

      QueryGnkLst := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);
      ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
      ScriptText := ScriptTpn.SQLScripts.Add();

      case LvlReinit of
        erl_ReInitialisation :
          begin
            // vidage de la table
            Requete := 'select count(*) from ' + NomTable + ' where ' + GetWhereNotID0(NomCle, DoNull) + ';';
            QueryTpnMaj.SQL.Text := Requete;
            try
              QueryTpnMaj.Open();
              if QueryTpnMaj.Eof then
                NbEnreg := 0
              else
                NbEnreg := QueryTpnMaj.Fields[0].AsInteger;
            finally
              QueryTpnMaj.Close();
            end;
            if NbEnreg > 0 then
            begin
              DoLogMultiLine('  -> Nettoyage', logTrace);
              Requete := 'delete from ' + NomTable + ' where ' + GetWhereNotID0(NomCle, DoNull) + ';';
              QueryTpnMaj.SQL.Text := Requete;
              QueryTpnMaj.ExecSQL();
            end
            else
              DoLogMultiLine('  -> Pas de nettoyage, table vide', logTrace);
            // reinit des last ID
            tmpLameLastID := -1;
            tmpMagLastID := -1;
          end;
        erl_ReExport, erl_ReMouvement :
          begin
            tmpLameLastID := -1;
            tmpMagLastID := -1;
          end;
      end;

      if (DateMin > 1) and (DateMax > 1) then
        Requete := 'select * from BI15_' + NomTable + '(' + IntToStr(MagPlageDeb)
                                                   + ', ' + IntToStr(MagPlageFin)
                                                   + ', ' + IntToStr(tmpMagLastID)
                                                   + ', ' + IntToStr(LamePlageDeb)
                                                   + ', ' + IntToStr(LamePlageFin)
                                                   + ', ' + IntToStr(tmpLameLastID)
                                                   + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                   + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMax)) + ');'
      else if (DateMin > 1) then
        Requete := 'select * from BI15_' + NomTable + '(' + IntToStr(MagPlageDeb)
                                                   + ', ' + IntToStr(MagPlageFin)
                                                   + ', ' + IntToStr(tmpMagLastID)
                                                   + ', ' + IntToStr(LamePlageDeb)
                                                   + ', ' + IntToStr(LamePlageFin)
                                                   + ', ' + IntToStr(tmpLameLastID)
                                                   + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin)) + ');'
      else
        Requete := 'select * from BI15_' + NomTable + '(' + IntToStr(MagPlageDeb)
                                                   + ', ' + IntToStr(MagPlageFin)
                                                   + ', ' + IntToStr(tmpMagLastID)
                                                   + ', ' + IntToStr(LamePlageDeb)
                                                   + ', ' + IntToStr(LamePlageFin)
                                                   + ', ' + IntToStr(tmpLameLastID) + ');';

      QueryGnkLst.SQL.Text := Requete;
      try
        QueryGnkLst.Open();
        if not QueryGnkLst.Eof then
        begin
          DoLogMultiLine('  -> Creation du script', logTrace);

          while not ((IsInterruptible and Terminated) or QueryGnkLst.Eof) do
          begin
            // recup de la version
            GetMaxKVersionOf(QueryGnkLst, LamePlageDeb, LamePlageFin, tmpLameLastID);
            GetMaxKVersionOf(QueryGnkLst, MagPlageDeb, MagPlageFin, tmpMagLastID);
            // Fileds spéciaux
            FieldSuppr := GetOneFieldOf(QueryGnkLst, FIELD_KENABLED);
            FieldModId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_MODID);
            FieldTgfId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_TGFID);
            FieldCouId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_COUID);
            // recherche si existant
            WhereCle := GetWhere(QueryGnkLst, NomCle, DoNull);
            Requete := 'select * from ' + NomTable + ' where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
              begin
                if (not (DoArt and Assigned(FieldModId) and Assigned(FieldTgfId) and Assigned(FieldCouId))) or // pas demander ou pas de quoi l'identifié ?
                   DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj, FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger, DoMaj, DoNull) then // gestion article
                begin
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoIns then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Insert skipped : "' + Requete + '"', logDebug);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj or (LvlReinit = erl_ReMouvement) then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end
                    else if LvlReinit = erl_ReMouvement then
                    begin
                      Requete := GetDummyUpdateRequete(QueryTpnExt, NomTable, NomCle, DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      ScriptText.SQL.Add(Requete);
                      Inc(NbLignes);
                    end;
                  end;
                end
                else
                begin
                  if FDoErrArt then
                  begin
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logError);
                    Exit;
                  end
                  else
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
                end;
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                if not (Trim(Requete) = '') then
                begin
                  if DoSup then
                  begin
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                    DoLogMultiLine('  Attention : Delete skipped : "' + Requete + '"', logDebug);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                try
                  if not ScriptTpn.ExecuteAll() then
                  begin
                    SaveScript(NomTable, ScriptTpn);
                    Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  end;
                except
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  raise;
                end;
              end
              else
              begin
                SaveScript(NomTable, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              ScriptText.SQL.Clear();
              DoLogMultiLine('  -> re-Creation du script', logTrace);
            end;

            // suivant !!
            QueryGnkLst.Next();
          end;

          // Il en reste ??
          if ScriptText.SQL.Count > 0 then
          begin
            DoLogMultiLine('  -> Execution du script', logTrace);
            if ScriptTpn.ValidateAll() then
            begin
              try
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                end;
              except
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                raise;
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if QueryGnkLst.Eof then
            Result := ers_Succeded
          else
            Result := ers_Interrupted;
          LameLastID := tmpLameLastID;
          MagLastId := tmpMagLastID;
        end
        else
        begin
          DoLogMultiLine('  -> Pas de lignes a traiter', logTrace);
          Result := ers_Succeded;
        end;
      finally
        QueryGnkLst.Close();
      end;
    finally
      FreeAndNil(QueryGnkLst);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FreeAndNil(ScriptText);
      FreeAndNil(ScriptTpn);
      FTransactionGnk.Rollback();
    end;

    DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées', logTrace);

  except
    on e : Exception do
    begin
      Result := ers_Failed;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.CopieTable(Magasin : TMagasin; var LastID : integer; NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                                LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                                ListeChamps : TListeChamps) : TEnumResult;
var
  MagIdName, WhereCle, Requete : string;
  tmpLastID, NbLignes, NbEnreg : integer;
  QueryGnkLst, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  FieldMagId, FieldSuppr, FieldModId, FieldTgfId, FieldCouId : TField;
begin
  Result := ers_Failed;
  Requete := '';
  QueryGnkLst := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  ScriptTpn := nil;
  ScriptText := nil;
  tmpLastID := LastID;
  NbLignes := 0;
  NbEnreg := 0;

  DoLogMultiLine('TTraitement.CopieTable(' + NomTable + ', ' + Magasin.CodeAdh + ')', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();

      QueryGnkLst := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);
      ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
      ScriptText := ScriptTpn.SQLScripts.Add();

      case LvlReinit of
        erl_ReInitialisation :
          begin
            // recherche du champs MAGID
            Requete := 'select * from ' + NomTable + ' where ' + GetWhere(nil, NomCle, DoNull);
            QueryTpnMaj.SQL.Text := Requete;
            try
              QueryTpnMaj.Open();
              FieldMagId := GetOneFieldOf(QueryTpnMaj, FIELDS_MAGID);
              if Assigned(FieldMagId) then
                MagIdName := FieldMagId.FieldName
              else
                MagIdName := '';
            finally
              QueryTpnMaj.Close();
            end;
            // vidage de la table
            if not (MagIdName = '') then
            begin
              Requete := 'select count(*) from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ' and ' + GetWhereNotID0(NomCle, DoNull) + ';';
              QueryTpnMaj.SQL.Text := Requete;
              try
                QueryTpnMaj.Open();
                if QueryTpnMaj.Eof then
                  NbEnreg := 0
                else
                  NbEnreg := QueryTpnMaj.Fields[0].AsInteger;
              finally
                QueryTpnMaj.Close();
              end;
              if NbEnreg > 0 then
              begin
                DoLogMultiLine('  -> Nettoyage', logTrace);
                Requete := 'delete from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ' and ' + GetWhereNotID0(NomCle, DoNull) + ';';
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();
              end
              else
                DoLogMultiLine('  -> Pas de nettoyage, table vide', logTrace);
            end
            else
              DoLogMultiLine('  -> Pas de nettoyage, champs magid non trouvé', logTrace);
            // reinit des last ID
            tmpLastID := -1;
          end;
        erl_ReExport, erl_ReMouvement :
          begin
            tmpLastID := -1;
          end;
      end;

      if (DateMin > 1) and (DateMax > 1) then
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(tmpLastID)
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMax))
                                                           + ', ' + IntToStr(Magasin.MagId) + ');'
      else if (DateMin > 1) then
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(tmpLastID)
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                           + ', ' + IntToStr(Magasin.MagId) + ');'
      else
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(tmpLastID)
                                                           + ', ' + IntToStr(Magasin.MagId) + ');';

      QueryGnkLst.SQL.Text := Requete;
      try
        QueryGnkLst.Open();
        if not QueryGnkLst.Eof then
        begin
          DoLogMultiLine('  -> Creation du script', logTrace);

          while not ((IsInterruptible and Terminated) or QueryGnkLst.Eof) do
          begin
            // recup de la version
            GetMaxKVersionOf(QueryGnkLst, 0, MaxInt, tmpLastID);
            // Fileds spéciaux
            FieldSuppr := GetOneFieldOf(QueryGnkLst, FIELD_KENABLED);
            FieldModId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_MODID);
            FieldTgfId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_TGFID);
            FieldCouId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_COUID);
            // recherche d'existance
            WhereCle := GetWhere(QueryGnkLst, NomCle, DoNull);
            Requete := 'select * from ' + NomTable + ' where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
              begin
                if (not (DoArt and Assigned(FieldModId) and Assigned(FieldTgfId) and Assigned(FieldCouId))) or // pas demander ou pas de quoi l'identifié ?
                   DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj, FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger, DoMaj, DoNull) then // gestion article
                begin
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoIns then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Insert skipped : "' + Requete + '"', logDebug);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj or (LvlReinit = erl_ReMouvement) then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end
                    else if LvlReinit = erl_ReMouvement then
                    begin
                      Requete := GetDummyUpdateRequete(QueryTpnExt, NomTable, NomCle, DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      ScriptText.SQL.Add(Requete);
                      Inc(NbLignes);
                    end;
                  end;
                end
                else
                begin
                  if FDoErrArt then
                  begin
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logError);
                    Exit;
                  end
                  else
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
                end;
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                if not (Trim(Requete) = '') then
                begin
                  if DoSup then
                  begin
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                    DoLogMultiLine('  Attention : Delete skipped : "' + Requete + '"', logDebug);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                try
                  if not ScriptTpn.ExecuteAll() then
                  begin
                    SaveScript(NomTable, ScriptTpn);
                    Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  end;
                except
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  raise;
                end;
              end
              else
              begin
                SaveScript(NomTable, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              ScriptText.SQL.Clear();
              DoLogMultiLine('  -> re-Creation du script', logTrace);
            end;

            // suivant !!
            QueryGnkLst.Next();
          end;

          // Il en reste ??
          if ScriptText.SQL.Count > 0 then
          begin
            DoLogMultiLine('  -> Execution du script', logTrace);
            if ScriptTpn.ValidateAll() then
            begin
              try
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                end;
              except
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                raise;
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if QueryGnkLst.Eof then
            Result := ers_Succeded
          else
            Result := ers_Interrupted;
          LastID := tmpLastID;
        end
        else
        begin
          DoLogMultiLine('  -> Pas de lignes a traiter', logTrace);
          result := ers_Succeded;
        end;
      finally
        QueryGnkLst.Close();
      end;
    finally
      FreeAndNil(QueryGnkLst);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FreeAndNil(ScriptText);
      FreeAndNil(ScriptTpn);
      FTransactionGnk.Rollback();
    end;

    DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées', logTrace);

  except
    on e : Exception do
    begin
      Result := ers_Failed;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.CopieTable(Magasin : TMagasin; NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                                LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                                ListeChamps : TListeChamps) : TEnumResult;
var
  MagIdName, WhereCle, Requete : string;
  NbLignes, NbEnreg : integer;
  QueryGnkLst, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  FieldMagId, FieldSuppr, FieldModId, FieldTgfId, FieldCouId : TField;
begin
  Result := ers_Failed;
  Requete := '';
  QueryGnkLst := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  ScriptTpn := nil;
  ScriptText := nil;
  NbLignes := 0;
  NbEnreg := 0;

  DoLogMultiLine('TTraitement.CopieTable(' + NomTable + ', ' + Magasin.CodeAdh + ')', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();

      QueryGnkLst := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);
      ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
      ScriptText := ScriptTpn.SQLScripts.Add();

      case LvlReinit of
        erl_ReInitialisation :
          begin
            // recherche du champs MAGID
            Requete := 'select * from ' + NomTable + ' where ' + GetWhere(nil, NomCle, DoNull);
            QueryTpnMaj.SQL.Text := Requete;
            try
              QueryTpnMaj.Open();
              FieldMagId := GetOneFieldOf(QueryTpnMaj, FIELDS_MAGID);
              if Assigned(FieldMagId) then
                MagIdName := FieldMagId.FieldName
              else
                MagIdName := '';
            finally
              QueryTpnMaj.Close();
            end;
            // vidage de la table
            if not (MagIdName = '') then
            begin
              Requete := 'select count(*) from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ' and ' + GetWhereNotID0(NomCle, DoNull) + ';';
              QueryTpnMaj.SQL.Text := Requete;
              try
                QueryTpnMaj.Open();
                if QueryTpnMaj.Eof then
                  NbEnreg := 0
                else
                  NbEnreg := QueryTpnMaj.Fields[0].AsInteger;
              finally
                QueryTpnMaj.Close();
              end;
              if NbEnreg > 0 then
              begin
                DoLogMultiLine('  -> Nettoyage', logTrace);
                Requete := 'delete from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ' and ' + GetWhereNotID0(NomCle, DoNull) + ';';
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();
              end
              else
                DoLogMultiLine('  -> Pas de nettoyage, table vide', logTrace);
            end
            else
              DoLogMultiLine('  -> Pas de nettoyage, champs magid non trouvé', logTrace);
          end;
      end;

      if (DateMin > 1) and (DateMax > 1) then
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                           + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMax))
                                                           + ', ' + IntToStr(Magasin.MagId) + ');'
      else if (DateMin > 1) then
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin))
                                                           + ', ' + IntToStr(Magasin.MagId) + ');'
      else
        Requete := 'select * from BI15_' + NomTable + '_MAGASIN(' + IntToStr(Magasin.MagId) + ');';

      QueryGnkLst.SQL.Text := Requete;
      try
        QueryGnkLst.Open();
        if not QueryGnkLst.Eof then
        begin
          DoLogMultiLine('  -> Creation du script', logTrace);

          while not ((IsInterruptible and Terminated) or QueryGnkLst.Eof) do
          begin
            // Fileds spéciaux
            FieldSuppr := GetOneFieldOf(QueryGnkLst, FIELD_KENABLED);
            FieldModId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_MODID);
            FieldTgfId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_TGFID);
            FieldCouId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_COUID);
            // recherche d'existance
            WhereCle := GetWhere(QueryGnkLst, NomCle, DoNull);
            Requete := 'select * from ' + NomTable + ' where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
              begin
                if (not (DoArt and Assigned(FieldModId) and Assigned(FieldTgfId) and Assigned(FieldCouId))) or // pas demander ou pas de quoi l'identifié ?
                   DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj, FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger, DoMaj, DoNull) then // gestion article
                begin
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoIns then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Insert skipped : "' + Requete + '"', logDebug);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj or (LvlReinit = erl_ReMouvement) then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end
                    else if LvlReinit = erl_ReMouvement then
                    begin
                      Requete := GetDummyUpdateRequete(QueryTpnExt, NomTable, NomCle, DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      ScriptText.SQL.Add(Requete);
                      Inc(NbLignes);
                    end;
                  end;
                end
                else
                begin
                  if FDoErrArt then
                  begin
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logError);
                    Exit;
                  end
                  else
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logwarning);
                end;
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                if not (Trim(Requete) = '') then
                begin
                  if DoSup then
                  begin
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                    DoLogMultiLine('  Attention : Delete skipped : "' + Requete + '"', logDebug);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                try
                  if not ScriptTpn.ExecuteAll() then
                  begin
                    SaveScript(NomTable, ScriptTpn);
                    Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  end;
                except
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  raise;
                end;
              end
              else
              begin
                SaveScript(NomTable, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              ScriptText.SQL.Clear();
              DoLogMultiLine('  -> re-Creation du script', logTrace);
            end;

            // suivant !!
            QueryGnkLst.Next();
          end;

          // Il en reste ??
          if ScriptText.SQL.Count > 0 then
          begin
            DoLogMultiLine('  -> Execution du script', logTrace);
            if ScriptTpn.ValidateAll() then
            begin
              try
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                end;
              except
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                raise;
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if QueryGnkLst.Eof then
            Result := ers_Succeded
          else
            Result := ers_Interrupted;
        end
        else
        begin
          DoLogMultiLine('  -> Pas de lignes a traiter', logTrace);
          result := ers_Succeded;
        end;
      finally
        QueryGnkLst.Close();
      end;
    finally
      FreeAndNil(QueryGnkLst);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FreeAndNil(ScriptText);
      FreeAndNil(ScriptTpn);
      FTransactionGnk.Rollback();
    end;

    DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées', logTrace);

  except
    on e : Exception do
    begin
      Result := ers_Failed;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.CopieTable(NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                                LvlReinit : TReInitLvl; DoArt, DoIns, DoMaj, DoSup, DoNull : boolean; IsInterruptible : boolean;
                                ListeChamps : TListeChamps) : TEnumResult;
var
  WhereCle, Requete : string;
  NbLignes, NbEnreg : integer;
  QueryGnkLst, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  FieldSuppr, FieldModId, FieldTgfId, FieldCouId : TField;
begin
  Result := ers_Failed;
  Requete := '';
  QueryGnkLst := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  ScriptTpn := nil;
  ScriptText := nil;
  NbLignes := 0;
  NbEnreg := 0;

  DoLogMultiLine('TTraitement.CopieTable(' + NomTable + ')', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();

      QueryGnkLst := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);
      ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
      ScriptText := ScriptTpn.SQLScripts.Add();

      case LvlReinit of
        erl_ReInitialisation :
          begin
            Requete := 'select count(*) from ' + NomTable + ' where ' + GetWhereNotID0(NomCle, DoNull) + ';';
            QueryTpnMaj.SQL.Text := Requete;
            try
              QueryTpnMaj.Open();
              if QueryTpnMaj.Eof then
                NbEnreg := 0
              else
                NbEnreg := QueryTpnMaj.Fields[0].AsInteger;
            finally
              QueryTpnMaj.Close();
            end;
            if NbEnreg > 0 then
            begin
              DoLogMultiLine('  -> Nettoyage', logTrace);
              Requete := 'delete from ' + NomTable + ' where ' + GetWhereNotID0(NomCle, DoNull) + ';';
              QueryTpnMaj.SQL.Text := Requete;
              QueryTpnMaj.ExecSQL();
            end
            else
              DoLogMultiLine('  -> Pas de nettoyage, table vide', logTrace);
          end;
      end;

      if (DateMin > 1) and (DateMax > 1) then
        Requete := 'select * from BI15_' + NomTable + '(' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin)) + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMax)) + ');'
      else if (DateMin > 1) then
        Requete := 'select * from BI15_' + NomTable + '(' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateMin)) + ');'
      else
        Requete := 'select * from BI15_' + NomTable + ';';

      QueryGnkLst.SQL.Text := Requete;
      try
        QueryGnkLst.Open();
        if not QueryGnkLst.Eof then
        begin
          DoLogMultiLine('  -> Creation du script', logTrace);

          while not ((IsInterruptible and Terminated) or QueryGnkLst.Eof) do
          begin
            // Fileds spéciaux
            FieldSuppr := GetOneFieldOf(QueryGnkLst, FIELD_KENABLED);
            FieldModId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_MODID);
            FieldTgfId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_TGFID);
            FieldCouId := GetOneFieldOf(QueryGnkLst, FIELD_ARTICLE_COUID);
            // recherche d'existance
            WhereCle := GetWhere(QueryGnkLst, NomCle, DoNull);
            Requete := 'select * from ' + NomTable + ' where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
              begin
                if (not (DoArt and Assigned(FieldModId) and Assigned(FieldTgfId) and Assigned(FieldCouId))) or // pas demander ou pas de quoi l'identifié ?
                   DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj, FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger, DoMaj, DoNull) then // gestion article
                begin
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoIns then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Insert skipped : "' + Requete + '"', logDebug);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull, ListeChamps);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj or (LvlReinit = erl_ReMouvement) then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end
                    else if LvlReinit = erl_ReMouvement then
                    begin
                      Requete := GetDummyUpdateRequete(QueryTpnExt, NomTable, NomCle, DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      ScriptText.SQL.Add(Requete);
                      Inc(NbLignes);
                    end;
                  end;
                end
                else
                begin
                  if FDoErrArt then
                  begin
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logError);
                    Exit;
                  end
                  else
                    DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
                end;
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                if not (Trim(Requete) = '') then
                begin
                  if DoSup then
                  begin
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                    DoLogMultiLine('  Attention : Delete skipped : "' + Requete + '"', logDebug);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                try
                  if not ScriptTpn.ExecuteAll() then
                  begin
                    SaveScript(NomTable, ScriptTpn);
                    Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  end;
                except
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                  raise;
                end;
              end
              else
              begin
                SaveScript(NomTable, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              ScriptText.SQL.Clear();
              DoLogMultiLine('  -> re-Creation du script', logTrace);
            end;

            // suivant !!
            QueryGnkLst.Next();
          end;

          // Il en reste ??
          if ScriptText.SQL.Count > 0 then
          begin
            DoLogMultiLine('  -> Execution du script', logTrace);
            if ScriptTpn.ValidateAll() then
            begin
              try
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                end;
              except
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
                raise;
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if QueryGnkLst.Eof then
            Result := ers_Succeded
          else
            Result := ers_Interrupted;
        end
        else
        begin
          DoLogMultiLine('  -> Pas de lignes a traiter', logTrace);
          Result := ers_Succeded;
        end;
      finally
        QueryGnkLst.Close();
      end;
    finally
      FreeAndNil(QueryGnkLst);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FreeAndNil(ScriptText);
      FreeAndNil(ScriptTpn);
      FTransactionGnk.Rollback();
    end;

    DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées', logTrace);

  except
    on e : Exception do
    begin
      Result := ers_Failed;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

// traitements complet

function TTraitement.DoExportMagasins(DoNull : boolean) : integer;
var
  Ret : TEnumResult;
begin
  Result := 2101;
  FWhatIsDoing := ett_GestionMagasins;

  DoLogMultiLine('TTraitement.DoExportMagasins', logTrace);

  try
    // Attention : pas de reset des magasins a cause des clés étrangères
    FTransactionTpn.StartTransaction();
    Ret := CopieTable('TMagasin', ['MagId'], 0, 0, erl_None, false, true, true, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Interrupted :
        begin
          FTransactionTpn.Commit();
          Result := 96;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 2103;
        end;
    end;
  except
    on e : Exception do
    begin
      Result := 2102;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.DoExportExercices(LvlReinit : TReInitLvl; DoNull : boolean) : integer;
var
  Ret : TEnumResult;
begin
  Result := 2201;
  FWhatIsDoing := ett_GestionExercices;

  DoLogMultiLine('TTraitement.DoExportExercices', logTrace);

  try
    FTransactionTpn.StartTransaction();
    Ret := CopieTable('TExerciceCom', ['ExeId'], 0, 0, LvlReinit, false, true, true, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Interrupted :
        begin
          FTransactionTpn.Commit();
          Result := 96;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 2203;
        end;
    end;
  except
    on e : Exception do
    begin
      Result := 2202;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.DoExportCollections(LvlReinit : TReInitLvl; DoNull : boolean) : integer;
var
  Ret : TEnumResult;
begin
  Result := 2301;
  FWhatIsDoing := ett_GestionCollections;

  DoLogMultiLine('TTraitement.DoExportCollections', logTrace);

  try
    FTransactionTpn.StartTransaction();
    Ret := CopieTable('TCollection', ['ColId'], 0, 0, LvlReinit, false, true, true, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Interrupted :
        begin
          FTransactionTpn.Commit();
          Result := 96;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 2303;
        end;
    end;
  except
    on e : Exception do
    begin
      Result := 2302;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.DoExportFournisseurs(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoNull : boolean) : integer;
var
  QueryTpn : TMyQuery;
  LameLastID, MagLastId : integer;
  Ret : TEnumResult;
  Requete : string;
begin
  Result := 2401;
  FWhatIsDoing := ett_GestionFournisseurs;
  Requete := '';
  QueryTpn := nil;

  DoLogMultiLine('TTraitement.DoExportFournisseurs', logTrace);

  try
    // gestion des fournisseurs
    LameLastID := GetLastVersion(0, 'TFournisseur_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TFournisseur_Mag', ListeLastId);

    // Attention : pas de reset des fournisseurs a cause des clés étrangères
    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TFournisseur', ['FouId'], FDateMinRap, FDateMax, TReInitLvl(Min(Ord(LvlReinit), Ord(erl_ReExport))),
                      false, true, true, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

            Requete := SetLastVersion(0, 'TFournisseur_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TFournisseur_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

            Requete := SetLastVersion(0, 'TFournisseur_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TFournisseur_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 2403;
        end;
    end;

  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 2402;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

// traitement d'export complet

function TTraitement.DoExportArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoNull : boolean) : integer;
var
  QueryTpn : TMyQuery;
  LameLastID, MagLastId : integer;
  Ret : TEnumResult;
  Requete : string;
begin
  Result := 2501;
  FWhatIsDoing := ett_CompletArticles;
  Requete := '';
  QueryTpn := nil;

  DoLogMultiLine('TTraitement.DoExportArticles', logTrace);

  try
    // gestion des articles
    LameLastID := GetLastVersion(0, 'TArticle_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TArticle_Mag', ListeLastId);

    // Attention : pas de reset des articles a cause des clés étrangères
    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TArticle', ['ModId', 'TgfId', 'CouId'], FDateMinArt, FDateMax, TReInitLvl(Min(Ord(LvlReinit), Ord(erl_ReExport))),
                      false, true, true, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

            Requete := SetLastVersion(0, 'TArticle_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TArticle_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

            Requete := SetLastVersion(0, 'TArticle_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TArticle_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 2503;
          Exit;
        end;
    end;

    // gestion des liens avec les collections
    LameLastID := GetLastVersion(0, 'TArticleCol_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TArticleCol_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TArticleCol', ['ModId', 'ColId'], FDateMinArt, FDateMax, LvlReinit,
                      false, true, true, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

            Requete := SetLastVersion(0, 'TArticleCol_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TArticleCol_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

            Requete := SetLastVersion(0, 'TArticleCol_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TArticleCol_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 2504;
          Exit;
        end;
    end;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 2502;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoExportTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  LameLastID, MagLastId : integer;
  Ret : TEnumResult;
  Requete : string;
  DateMax : TDate;
begin
  Result := 3101;
  FWhatIsDoing := ett_CompletTickets;
  Requete := '';
  DateMax := Min(IncDay(Date(), -1), FDateMax);

  DoLogMultiLine('TTraitement.DoExportTicket', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        // gestion des entetes
        LameLastID := GetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', ListeLastId);
        MagLastId := GetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                          'TVENTE_ENTETE', ['TkeId'], FDateMinVte, DateMax, LvlReinit,
                          false, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3103;
              Exit;
            end;
        end;

        // gestion des lignes
        LameLastID := GetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', ListeLastId);
        MagLastId := GetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                          'TVENTE_LIGNE', ['TklId'], FDateMinVte, DateMax, LvlReinit,
                          DoArt, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3104;
              Exit;
            end;
        end;

        // gestion des encaissement
        LameLastID := GetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', ListeLastId);
        MagLastId := GetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                          'TVENTE_ENCAISSEMENT', ['EncId'], FDateMinVte, DateMax, LvlReinit,
                          false, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3105;
              Exit;
            end;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 3102;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoExportFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  Ret : TEnumResult;
  LameLastID, MagLastId : integer;
  Requete : string;
  DateMax : TDate;
begin
  Result := 3201;
  FWhatIsDoing := ett_CompletFactures;
  Requete := '';
  DateMax := Min(IncDay(Date(), -1), FDateMax);

  DoLogMultiLine('TTraitement.DoExportFacture', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        // gestion des entete
        LameLastID := GetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', ListeLastId);
        MagLastId := GetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                          'TFACTURE_ENTETE', ['FceId'], FDateMinVte, DateMax, LvlReinit,
                          false, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3203;
              Exit;
            end;
        end;

        // gestion des lignes
        LameLastID := GetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', ListeLastId);
        MagLastId := GetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                          'TFACTURE_LIGNE', ['FclId'], FDateMinVte, DateMax, LvlReinit,
                          DoArt, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3204;
              Exit;
            end;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 3202;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoExportMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  LastIDEnt, LastIDLig : integer;
  Ret : TEnumResult;
  Requete : string;
  DateMax : TDate;
begin
  Result := 3301;
  FWhatIsDoing := ett_CompletMouvements;
  Requete := '';
  DateMax := Min(IncDay(Date(), -1), FDateMax);

  DoLogMultiLine('TTraitement.DoExportMouvement', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        // gestion des entete
        LastIDEnt := GetLastVersion(Magasin.MagId, 'TMVT', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LastIDEnt,
                          'TMVT_ENTETE', ['MagId', 'MvtId'], FDateMinMvt, DateMax, LvlReinit,
                          false, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              // Ici pas de mise a jour d'Id... il est géré via les lignes !
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              // Ici pas de mise a jour d'Id... il est géré via les lignes !
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3303;
              Exit;
            end;
        end;

        // gestion des lignes
        LastIDLig := GetLastVersion(Magasin.MagId, 'TMVT', ListeLastId);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, LastIDLig,
                          'TMVT_LIGNE', ['MagId', 'MvtId', 'MvlId'], FDateMinMvt, DateMax, LvlReinit,
                          DoArt, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TMVT', LastIDLig, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              try
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                Requete := SetLastVersion(Magasin.MagId, 'TMVT', LastIDLig, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL();
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 3304;
              Exit;
            end;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 3302;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoExportCommande(ListeMagasins: TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin: integer; ListeLastId: TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull: boolean): integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  LameLastID, MagLastID: Integer;
  Ret : TEnumResult;
  Requete : string;
  DateMax : TDate;
begin
  Result := 4101;
  FWhatIsDoing := ett_CompletCommandes;
  DateMax := IncDay(Date, -1);

  DoLogMultiLine('TTraitement.DoExportCommande', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        // gestion des entete
        LameLastID := GetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', ListeLastId);
        MagLastId := GetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', ListeLastId);

        FTransactionTpn.StartTransaction;
        Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                          'TCOMMANDESTATUT', ['CmdBllId', 'CmdBlhId'], FDateMinCmd, DateMax, LvlReinit,
                          DoArt, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded :
            begin
              QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
              try
                Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL;
                Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL;
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
            end;
          ers_Interrupted :
            begin
              QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
              try
                Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL;
                Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
                QueryTpn.SQL.Text := Requete;
                QueryTpn.ExecSQL;
              finally
                FreeAndNil(QueryTpn);
              end;
              FTransactionTpn.Commit();
              Result := 96;
              Exit;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 4103;
              Exit;
            end;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on E: Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 4102;
      DoLogMultiLine('Eception : ' + GetExceptionMessage(E), logCritical);
      if not string.IsNullOrWhiteSpace(Requete) then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoExportReception(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  QueryTpn : TMyQuery;
  Ret : TEnumResult;
  LameLastID, MagLastId : integer;
  Requete : string;
  DateMax : TDate;
begin
  Result := 5101;
  FWhatIsDoing := ett_CompletReceptions;
  Requete := '';
  DateMax := Min(IncDay(Date(), -1), FDateMax);

  DoLogMultiLine('TTraitement.DoExportReception', logTrace);

  try
    // gestion des entete
    LameLastID := GetLastVersion(0, 'TRECEPTION_ENTETE_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TRECEPTION_ENTETE_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TRECEPTION_ENTETE', ['BreId', 'Sens'], FDateMinRap, DateMax, LvlReinit,
                      false, true, false, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRECEPTION_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRECEPTION_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 5103;
          Exit;
        end;
    end;

    // gestion des lignes
    LameLastID := GetLastVersion(0, 'TRECEPTION_LIGNE_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TRECEPTION_LIGNE_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TRECEPTION_LIGNE', ['BrlId', 'Sens'], FDateMinRap, DateMax, LvlReinit,
                      DoArt, true, false, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRECEPTION_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRECEPTION_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 5104;
          Exit;
        end;
    end;

    // gestion des Pied
    LameLastID := GetLastVersion(0, 'TRECEPTION_TVA_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TRECEPTION_TVA_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TRECEPTION_TVA', ['BreId', 'Sens', 'BreTaux'], FDateMinRap, DateMax, LvlReinit,
                      false, true, false, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRECEPTION_TVA_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_TVA_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRECEPTION_TVA_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_TVA_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 5105;
          Exit;
        end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 5102;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoExportRetour(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  QueryTpn : TMyQuery;
  Ret : TEnumResult;
  LameLastID, MagLastId : integer;
  Requete : string;
  DateMax : TDate;
begin
  Result := 5201;
  FWhatIsDoing := ett_CompletRetours;
  Requete := '';
  DateMax := Min(IncDay(Date(), -1), FDateMax);

  DoLogMultiLine('TTraitement.DoExportRetour', logTrace);

  try
    // gestion des entete
    LameLastID := GetLastVersion(0, 'TRETOUR_ENTETE_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TRETOUR_ENTETE_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TRETOUR_ENTETE', ['RetId', 'Sens'], FDateMinRap, DateMax, LvlReinit,
                      false, true, false, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRETOUR_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRETOUR_ENTETE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_ENTETE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 5203;
          Exit;
        end;
    end;

    // gestion des lignes
    LameLastID := GetLastVersion(0, 'TRETOUR_LIGNE_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TRETOUR_LIGNE_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TRETOUR_LIGNE', ['RelId', 'Sens'], FDateMinRap, DateMax, LvlReinit,
                      DoArt, true, false, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRETOUR_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRETOUR_LIGNE_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_LIGNE_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 5204;
          Exit;
        end;
    end;

    // gestion des Pied
    LameLastID := GetLastVersion(0, 'TRETOUR_TVA_Lame', ListeLastId);
    MagLastId := GetLastVersion(0, 'TRETOUR_TVA_Mag', ListeLastId);

    FTransactionTpn.StartTransaction();
    Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId,
                      'TRETOUR_TVA', ['RetId', 'Sens', 'BreTaux'], FDateMinRap, DateMax, LvlReinit,
                      false, true, false, false, DoNull, false);
    case Ret of
      ers_Succeded :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRETOUR_TVA_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_TVA_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
        end;
      ers_Interrupted :
        begin
          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            Requete := SetLastVersion(0, 'TRETOUR_TVA_Lame', LameLastID, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_TVA_Mag', MagLastId, ListeLastId, LvlReinit = erl_ReInitialisation);
            QueryTpn.SQL.Text := Requete;
            QueryTpn.ExecSQL();
          finally
            FreeAndNil(QueryTpn);
          end;
          FTransactionTpn.Commit();
          Result := 96;
          Exit;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 5205;
          Exit;
        end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 5202;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

//---- Groupe fonctionnel (monitoring)

function TTraitement.DoExportBI(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  tmpLogMdl : string;
  tmpRes : integer;
begin
  Result := 0;

  DoLogMultiLine('TTraitement.DoExportBI', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := LISTE_MODULE_MONITORING[MODULE_MONITORING_BI];
    DoLogMultiLine('Début', logNotice, true);

    // gestion de l'extraction des tickets !
    if not Terminated and (ett_CompletTickets in FWhatToDo) then
    begin
      tmpRes := DoExportTicket(ListeMagasins, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, DoArt, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;
    // gestion de l'extraction des factures !
    if not Terminated and (ett_CompletFactures in FWhatToDo) then
    begin
      tmpRes := DoExportFacture(ListeMagasins, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, DoArt, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;
    // gestion de l'extraction des mouvement !
    if not Terminated and (ett_CompletMouvements in FWhatToDo) then
    begin
      tmpRes := DoExportMouvement(ListeMagasins, ListeLastId, LvlReinit, DoArt, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

function TTraitement.DoExportCrossCanal(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  tmpLogMdl : string;
  tmpRes : integer;
begin
  Result := 0;

  DoLogMultiLine('TTraitement.DoExportCrossCanal', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := LISTE_MODULE_MONITORING[MODULE_MONITORING_CROSSCANAL];
    DoLogMultiLine('Début', logNotice, True);

    // gestion de l'extraction des tickets !
    if not Terminated and (ett_CompletCommandes in FWhatToDo) then
    begin
      tmpRes := DoExportCommande(ListeMagasins, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, DoArt, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

function TTraitement.DoExportRapproAuto(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoArt, DoNull : boolean) : integer;
var
  tmpLogMdl : string;
  tmpRes : integer;
begin
  Result := 0;

  DoLogMultiLine('TTraitement.DoExportRapproAuto', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := LISTE_MODULE_MONITORING[MODULE_MONITORING_RAPPROCHEMENT];
    DoLogMultiLine('Début', logNotice, true);

    // gestion de l'extraction des receptions !
    if not Terminated and (ett_CompletReceptions in FWhatToDo) then
    begin
      tmpRes := DoExportReception(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, DoArt, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;
    // gestion de l'extraction des retours !
    if not Terminated and (ett_CompletRetours in FWhatToDo) then
    begin
      tmpRes := DoExportRetour(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, DoArt, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

// traitement delta

function TTraitement.DoDeltaArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; LvlReinit : TReInitLvl; DoNull : boolean) : integer;
var
  WhereCle, Requete : string;
  QueryGnkArt, QueryGnkCol, QueryTpnLst, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  LameLastID, MagLastId, NbArticle, NbLien : integer;
  svgModId, svgTgfId, svgCouId : integer;
  SvgKVersionBase, SvgKVersionLame : integer;
  FieldSuppr : TField;
begin
  Result := 2551;
  FWhatIsDoing := ett_DeltaArticles;
  QueryGnkArt := nil;
  QueryGnkCol := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';
  NbArticle := 0;
  NbLien := 0;
  SvgKVersionBase := 0;
  SvgKVersionLame := 0;

  DoLogMultiLine('TTraitement.DoDeltaArticles', logTrace);

  try
    try
      FTransactionGnk.StartTransaction;
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkCol := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnLst := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      // Gestion des articles
      LameLastID := GetLastVersion(0, 'TArticle_Lame', ListeLastId);
      MagLastId := GetLastVersion(0, 'TArticle_Mag', ListeLastId);

      Requete := 'select * from BI15_TARTICLE(' + IntToStr(MagPlageDeb)
                                         + ', ' + IntToStr(MagPlageFin)
                                         + ', ' + IntToStr(MagLastId)
                                         + ', ' + IntToStr(LamePlageDeb)
                                         + ', ' + IntToStr(LamePlageFin)
                                         + ', ' + IntToStr(LameLastID)
                                         + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinArt))
                                         + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax))
                                         + ') ORDER BY KVERSIONBASE, KVERSIONLAME;';

      QueryGnkArt.SQL.Text := Requete;
      QueryGnkArt.Open;
      try
        while not QueryGnkArt.Eof and
              not (Terminated and
                   (not ((SvgKVersionBase = QueryGnkArt.FieldByName('kversionbase').AsInteger) or
                         (SvgKVersionLame = QueryGnkArt.FieldByName('kversionlame').AsInteger))
                   )
                  ) do
        begin
          try
            FTransactionTpn.StartTransaction;

            // recup du dernier ID
            GetMaxKVersionOf(QueryGnkArt, LamePlageDeb, LamePlageFin, LameLastID);
            GetMaxKVersionOf(QueryGnkArt, MagPlageDeb, MagPlageFin, MagLastID);
            // Fileds spéciaux
            FieldSuppr := GetOneFieldOf(QueryGnkArt, FIELD_KENABLED);
            // sauvegarde pour la boucle
            SvgKVersionBase := QueryGnkArt.FieldByName('kversionbase').AsInteger;
            SvgKVersionLame := QueryGnkArt.FieldByName('kversionlame').AsInteger;

            // recherche d'existence
            WhereCle := GetWhere(QueryGnkArt, ['ModId', 'TgfId', 'CouId'], False);
            Requete := 'select * from TARTICLE where ' + WhereCle + ';';

            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open;
              if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
              begin
                if QueryTpnExt.Eof then
                begin
                  // nouveau -> Insertion
                  Requete := GetInsertRequete(QueryGnkArt, 'TARTICLE', DoNull);
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL;
                  Inc(NbArticle);
                end
                else
                begin
                  // ancien -> Update
                  Requete := GetUpdateRequete(QueryGnkArt, QueryTpnExt, 'TARTICLE', ['ModId', 'TgfId', 'CouId'], DoNull);
                  if not (Trim(Requete) = '') then
                  begin
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL;
                    Inc(NbArticle);
                  end;
                end;
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer (pas de suppression article)
                Requete := GetDeleteRequete(QueryGnkArt, 'TARTICLE', ['ModId', 'TgfId', 'CouId'], DoNull);
                if not (Trim(Requete) = '') then
                  DoLogMultiLine('  Attention : Delete skipped : "' + Requete + '"', logDebug);
              end;
            finally
              QueryTpnExt.Close;
            end;

            // les collections pour cet article !
            DoGestionCollection(QueryGnkCol, QueryTpnExt, QueryTpnMaj, QueryGnkArt.FieldByName('ModId').AsInteger, true, DoNull);

            //=================================================================
            // les max d'ID !
            Requete := SetLastVersion(0, 'TArticle_Lame', LameLastID, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL;
            Requete := SetLastVersion(0, 'TArticle_Mag', MagLastID, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL;

            FTransactionTpn.Commit;
          except
            on E : Exception do
            begin
              FTransactionTpn.Rollback;
              DoLogMultiLine('Exception : ' + GetExceptionMessage(E), logCritical);
              if not (Trim(Requete) = '') then
                DoLogMultiLine('  requete : ' + Requete, logDebug);
              raise;
            end;
          end;
          QueryGnkArt.Next;
        end;
      finally
        QueryGnkArt.Close;
      end;

      // Gestion des liens collection
      LameLastID := GetLastVersion(0, 'TArticleCol_Lame', ListeLastId);
      MagLastId := GetLastVersion(0, 'TArticleCol_Mag', ListeLastId);

      Requete := 'select * from BI15_TARTICLECOL(' + IntToStr(MagPlageDeb)
                                            + ', ' + IntToStr(MagPlageFin)
                                            + ', ' + IntToStr(MagLastId)
                                            + ', ' + IntToStr(LamePlageDeb)
                                            + ', ' + IntToStr(LamePlageFin)
                                            + ', ' + IntToStr(LameLastID)
                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinArt))
                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax))
                                            + ') ORDER BY KVERSION;';

      QueryGnkCol.SQL.Text := Requete;
      QueryGnkCol.Open();
      try
        while not (Terminated or QueryGnkCol.Eof) do
        begin
          try
            FTransactionTpn.StartTransaction;

            // recup du dernier ID
            GetMaxKVersionOf(QueryGnkCol, LamePlageDeb, LamePlageFin, LameLastID);
            GetMaxKVersionOf(QueryGnkCol, MagPlageDeb, MagPlageFin, MagLastID);

            // recherche d'existence
            WhereCle := GetWhere(QueryGnkCol, ['ModId', 'ColId'], False);
            Requete := 'select * from TARTICLECOL where ' + WhereCle + ';';

            QueryTpnExt.SQL.Text := Requete;
            QueryTpnExt.Open;
            try
              if QueryTpnExt.Eof then
              begin
                // nouveau -> Insertion
                Requete := GetInsertRequete(QueryGnkCol, 'TARTICLECOL', DoNull);
                DoLogMultiLine('  requete : ' + Requete, logNone);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL;
                Inc(NbLien);
              end
              else
              begin
                // ancien -> Update
                Requete := GetUpdateRequete(QueryGnkCol, QueryTpnExt, 'TARTICLECOL', ['ModId', 'ColId'], DoNull);
                if not (Trim(Requete) = '') then
                begin
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL;
                  Inc(NbLien);
                end;
              end;
            finally
              QueryTpnExt.Close;
            end;

            //=================================================================
            // les max d'ID !
            Requete := SetLastVersion(0, 'TArticleCol_Lame', LameLastID, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL;
            Requete := SetLastVersion(0, 'TArticleCol_Mag', MagLastID, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL;

            FTransactionTpn.Commit;
          except
            on E : Exception do
            begin
              FTransactionTpn.Rollback;
              DoLogMultiLine('Exception : ' + GetExceptionMessage(E), logCritical);
              if not (Trim(Requete) = '') then
                DoLogMultiLine('  requete : ' + Requete, logDebug);
              raise;
            end;
          end;
          QueryGnkCol.Next;
        end;
      finally
        QueryGnkCol.Close;
      end;

      DoLogMultiLine('  -> ' + IntToStr(NbArticle) + ' articles et ' + IntToStr(NbLien) + ' liens traitées', logTrace);
      Result := 0;

{$REGION '      Gestion des doublons de CodeBarre '}
      try
        FTransactionTpn.StartTransaction();
        // gestion des doublons de CBIID
        Requete := 'select cbiid from tarticle group by cbiid having count(*) > 1 order by cbiid;';
        QueryTpnLst.SQL.Text := Requete;
        QueryTpnLst.Open();
        try
          if not QueryTpnLst.Eof then
          begin
            QueryTpnLst.FetchAll();
            QueryTpnLst.First();
            DoLogMultiLine('Traitement des doublons de CB - Nombre de doublons ' + IntToStr(QueryTpnLst.RecordCount) + ' ', logWarning);

            try
              ActivationTrigger(false);

              while not QueryTpnLst.Eof do
              begin
                // recherche dans ginkoia de l'article qui vas bien !
                Requete := 'select arf_artid, cbi_tgfid, cbi_couid '
                         + 'from artcodebarre join artreference on arf_id = cbi_arfid '
                         + 'where cbi_id = ' + QueryTpnLst.FieldByName('cbiid').AsString + ';';
                QueryGnkArt.SQL.Text := Requete;
                QueryGnkArt.Open();
                try
                  if QueryGnkArt.Eof or (QueryGnkArt.RecordCount > 1) then
                  begin
                    QueryTpnLst.Next();
                    Continue;
                  end
                  else
                  begin
                    svgModId := QueryGnkArt.FieldByName('arf_artid').AsInteger;
                    svgTgfId := QueryGnkArt.FieldByName('cbi_tgfid').AsInteger;
                    svgCouId := QueryGnkArt.FieldByName('cbi_couid').AsInteger;
                  end;
                finally
                  QueryGnkArt.Close();
                end;

                // Recherche dans la base tampon des article en doublons
                Requete := 'select cbiid, modid, tgfid, couid, mdfrecversion, mdftimestamp from tarticle where cbiid = ' + QueryTpnLst.FieldByName('cbiid').AsString + ' order by mdfrecversion desc;';
                QueryTpnArt.SQL.Text := Requete;
                QueryTpnArt.Open();
                try
                  while not QueryTpnArt.Eof do
                  begin
                    if QueryTpnArt.FieldByName('modid').AsInteger = svgModId then
                    begin
                      if not ((svgTgfId = QueryTpnArt.FieldByName('tgfid').AsInteger) and
                              (svgCouId = QueryTpnArt.FieldByName('couid').AsInteger)) then
                      begin
                        DoLogMultiLine('Traitement des doublons de CB - Traitement de ' + QueryTpnLst.FieldByName('cbiid').AsString + ' '
                                     + '(modid ' + QueryTpnArt.FieldByName('modid').AsString + ', tgfid ' + QueryTpnArt.FieldByName('tgfid').AsString + ', couid ' + QueryTpnArt.FieldByName('couid').AsString + ' vers '
                                     +  'modid ' + intToStr(svgModId) + ', tgfid ' + IntToStr(svgTgfId) + ', couid ' + IntToStr(svgCouId) + ')', logWarning);

                        // "Fusion" des article : set de tous les mouvement vers le "nouveau" et suppression de l'"ancien"
                        Requete := 'update tvente_ligne '
                                 + 'set tkltgfid = ' + IntToStr(svgTgfId) + ', tklcouid = ' + IntToStr(svgCouId) + ' '
                                 + 'where tklmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and tkltgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and tklcouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        Requete := 'update tfacture_ligne '
                                 + 'set fcltgfid = ' + IntToStr(svgTgfId) + ', fclcouid = ' + IntToStr(svgCouId) + ' '
                                 + 'where fclmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and fcltgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and fclcouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        Requete := 'update tmvt_ligne '
                                 + 'set mvltgfid = ' + IntToStr(svgTgfId) + ', mvlcouid = ' + IntToStr(svgCouId) + ' '
                                 + 'where mvlmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and mvltgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and mvlcouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        requete := 'update tcommandestatut '
                                 + 'set cmdtgfid = ' + IntToStr(svgTgfId) + ', cmdcouid = ' + IntToStr(svgCouId) + ' '
                                 + 'where cmdmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and cmdtgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and cmdcouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        requete := 'update treception_ligne '
                                 + 'set tgfid = ' + IntToStr(svgTgfId) + ', couid = ' + IntToStr(svgCouId) + ' '
                                 + 'where modid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and tgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and couid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        requete := 'update tretour_ligne '
                                 + 'set tgfid = ' + IntToStr(svgTgfId) + ', couid = ' + IntToStr(svgCouId) + ' '
                                 + 'where modid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and tgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and couid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        // pour la gestion des stocks...
                        requete := 'update tstock_compl '
                                 + 'set stctgfid = ' + IntToStr(svgTgfId) + ', stccouid = ' + IntToStr(svgCouId) + ' '
                                 + 'where stcmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and stctgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and stccouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        // ici on ne peut faire que du delete...
                        // les stocks seront "faux" jusqu'au soir
                        requete := 'delete from tstock '
                                 + 'where stkmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and stktgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and stkcouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        requete := 'delete from tstock '
                                 + 'where stkmodid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and stktgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and stkcouid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                        // et enfin ... le delete de l'article !
                        requete := 'delete from tarticle '
                                 + 'where modid = ' + QueryTpnArt.FieldByName('modid').AsString
                                 + '  and tgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                                 + '  and couid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
                      end;
                    end
                    else
                    begin
                      DoLogMultiLine('Traitement des doublons de CB - Non traitement de ' + QueryTpnLst.FieldByName('cbiid').AsString + ' modèle different '
                                   + '(modid ' + QueryTpnArt.FieldByName('modid').AsString + ', tgfid ' + QueryTpnArt.FieldByName('tgfid').AsString + ', couid ' + QueryTpnArt.FieldByName('couid').AsString + ' vers '
                                   +  'modid ' + intToStr(svgModId) + ', tgfid ' + IntToStr(svgTgfId) + ', couid ' + IntToStr(svgCouId) + ')', logWarning);

                      // si ce n'est pas le même article...
                      // suppression du CB de type 1
                      requete := 'update tarticle '
                               + 'set cbicodebarres = '''', cbiid = (select min(cbiid) from tarticle) -1'
                               + 'where modid = ' + QueryTpnArt.FieldByName('modid').AsString
                               + '  and tgfid = ' + QueryTpnArt.FieldByName('tgfid').AsString
                               + '  and couid = ' + QueryTpnArt.FieldByName('couid').AsString + ';';
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                    end;
                    QueryTpnArt.Next();
                  end;
                finally
                  QueryTpnArt.Close();
                end;
                // mouvement de l'aricle destinataire
                if svgModId <> 0 then
                begin
                  Requete := 'update tarticle set cbiid = ' + QueryTpnLst.FieldByName('cbiid').AsString + ' where modid = ' + intToStr(svgModId) + ' and tgfid = ' + IntToStr(svgTgfId) + ' and couid = ' + IntToStr(svgCouId) + ';';
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                end;
                // suivant !
                QueryTpnLst.Next();
              end;
            finally
              ActivationTrigger(true);
            end;
          end
        finally
          QueryTpnLst.Close();
        end;
        // ici verification des CBIID négatif !
        Requete := 'select cbiid, '
                 + '   (select count(*) from tvente_ligne where tvente_ligne.tklmodid = tarticle.modid and tvente_ligne.tkltgfid = tarticle.tgfid and tvente_ligne.tklcouid = tarticle.couid) as nbticket, '
                 + '   (select count(*) from tfacture_ligne where tfacture_ligne.fclmodid = tarticle.modid and tfacture_ligne.fcltgfid = tarticle.tgfid and tfacture_ligne.fclcouid = tarticle.couid) as nbfacture, '
                 + '   (select count(*) from tmvt_ligne where tmvt_ligne.mvlmodid = tarticle.modid and tmvt_ligne.mvltgfid = tarticle.tgfid and tmvt_ligne.mvlcouid = tarticle.couid) as nbmouvement, '
                 + '   (select count(*) from tcommandestatut where tcommandestatut.cmdmodid = tarticle.modid and tcommandestatut.cmdtgfid = tarticle.tgfid and tcommandestatut.cmdcouid = tarticle.couid) as nbcommande, '
                 + '   (select count(*) from treception_ligne where treception_ligne.modid = tarticle.modid and treception_ligne.tgfid = tarticle.tgfid and treception_ligne.couid = tarticle.couid) as nbreception, '
                 + '   (select count(*) from tretour_ligne where tretour_ligne.modid = tarticle.modid and tretour_ligne.tgfid = tarticle.tgfid and tretour_ligne.couid = tarticle.couid) as nbretour '
                 + 'from tarticle '
                 + 'where cbiid < 0';
        QueryTpnLst.SQL.Text := Requete;
        QueryTpnLst.Open();
        try
          while not QueryTpnLst.Eof do
          begin
            if (QueryTpnLst.FieldByName('nbticket').AsInteger +
                QueryTpnLst.FieldByName('nbfacture').AsInteger +
                QueryTpnLst.FieldByName('nbmouvement').AsInteger +
                QueryTpnLst.FieldByName('nbcommande').AsInteger +
                QueryTpnLst.FieldByName('nbreception').AsInteger +
                QueryTpnLst.FieldByName('nbretour').AsInteger = 0) then
            begin
              DoLogMultiLine('Traitement des doublons de CB - suppression de cbiid ' + QueryTpnLst.FieldByName('cbiid').AsString, logDebug);
              Requete := 'delete from tarticle where cbiid = ' + QueryTpnLst.FieldByName('cbiid').AsString + ';';
              QueryTpnMaj.SQL.Text := Requete;
              QueryTpnMaj.ExecSQL();
            end
            else
              DoLogMultiLine('Traitement des doublons de CB - cbiid ' + QueryTpnLst.FieldByName('cbiid').AsString + ' avec des mouvement !!', logWarning);
            QueryTpnLst.Next();
          end;
        finally
          QueryTpnLst.Close();
        end;

        FTransactionTpn.Commit();
      except
        on e : Exception do
        begin
          DoLogMultiLine('Traitement des doublons de CB - Exception : ' + GetExceptionMessage(e), logWarning);
          if not (Trim(Requete) = '') then
            DoLogMultiLine('Traitement des doublons de CB -   requete : ' + Requete, logDebug);
          FTransactionTpn.Rollback();
        end;
      end;
{$ENDREGION}
    finally
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryGnkCol);
      FreeAndNil(QueryTpnLst);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback;
    end;
  except
    on e : Exception do
    begin
      if FTransactionTpn.Active then
        FTransactionTpn.Rollback();
      Result := 2552;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryGnkEnt, QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  EnteteID, LameLastIDEnt, MagLastIDEnt, LameLastIDLig, MagLastIDLig, LameLastIDEnc, MagLastIDEnc, NbEntetes, NbLignes, NbEncs : integer;
  WhereCle, Requete : string;
begin
  Result := 3151;
  FWhatIsDoing := ett_DeltaTickets;
  QueryGnkEnt := nil;
  QueryGnkDet := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';

  DoLogMultiLine('TTraitement.DoDeltaTicket', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();
      QueryGnkEnt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkDet := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      for Magasin in ListeMagasins do
      begin
        if Magasin.Actif then
        begin
          DoLogMultiLine('  -> Magasin : ' + Magasin.CodeAdh, logTrace);
          NbEntetes := 0;
          NbLignes := 0;
          NbEncs := 0;

          LameLastIDEnt := GetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', ListeLastId);
          MagLastIDEnt := GetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', ListeLastId);
          LameLastIDLig := GetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', ListeLastId);
          MagLastIDLig := GetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', ListeLastId);
          LameLastIDEnc := GetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', ListeLastId);
          MagLastIDEnc := GetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', ListeLastId);

          Requete := 'select * from BI15_TVENTE_ENTETE_MAGASIN(' + IntToStr(MagPlageDeb)
                                                          + ', ' + IntToStr(MagPlageFin)
                                                          + ', ' + IntToStr(MagLastIDEnt)
                                                          + ', ' + IntToStr(LamePlageDeb)
                                                          + ', ' + IntToStr(LamePlageFin)
                                                          + ', ' + IntToStr(LameLastIDEnt)
                                                          + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinVte))
                                                          + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax))
                                                          + ', ' + IntToStr(Magasin.MagId) + ') '
                                                          + 'ORDER BY KVERSION;';
          QueryGnkEnt.SQL.Text := Requete;
          try
            QueryGnkEnt.Open();
            while not (Terminated or QueryGnkEnt.Eof) do
            begin
              try
                FTransactionTpn.StartTransaction();

                // ====================================
                // Si c'est un ticket de fin de session
                if (QueryGnkEnt.FieldByName('TkeType').AsInteger = 2) then
                begin
                  // recherche d'existance
                  WhereCle := GetWhere(QueryGnkEnt, ['MagId', 'TkeId'], false);
                  Requete := 'select * from TVENTE_ENTETE where ' + WhereCle + ';';
                  QueryTpnExt.SQL.Text := Requete;
                  try
                    QueryTpnExt.Open();
                    if QueryTpnExt.Eof then
                    begin
                      // nouveau -> Insertion
                      Requete := GetInsertRequete(QueryGnkEnt, 'TVENTE_ENTETE', DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbEntetes);
                    end
                    else
                    begin
                      // ancien -> Update
                      Requete := GetUpdateRequete(QueryGnkEnt, QueryTpnExt, 'TVENTE_ENTETE', ['TkeId'], DoNull);
                      if not (Trim(Requete) = '') then
                      begin
                        DoLogMultiLine('  Attention : Tentative d''update de session "' + WhereCle + '"', logWarning);
                        DoLogMultiLine('  requete : ' + Requete, logDebug);
                      end;
                    end;
                  finally
                    QueryTpnExt.Close();
                  end;
                end
                // ===========================================
                // Si ce n'est pas un ticket de fin de session
                else if (QueryGnkEnt.FieldByName('TkeType').AsInteger = 1) then
                begin
                  // recup de l'ID entete
                  EnteteID := QueryGnkEnt.FieldByName('TkeId').AsInteger;
                  // recup du dernier ID
                  GetMaxKVersionOf(QueryGnkEnt, LamePlageDeb, LamePlageFin, LameLastIDEnt);
                  GetMaxKVersionOf(QueryGnkEnt, MagPlageDeb, MagPlageFin, MagLastIDEnt);

                  // recherche d'existance
                  WhereCle := GetWhere(QueryGnkEnt, ['MagId', 'TkeId'], false);
                  Requete := 'select * from TVENTE_ENTETE where ' + WhereCle + ';';
                  QueryTpnExt.SQL.Text := Requete;
                  try
                    QueryTpnExt.Open();
                    if QueryTpnExt.Eof then
                    begin
                      // nouveau -> Insertion
                      Requete := GetInsertRequete(QueryGnkEnt, 'TVENTE_ENTETE', DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbEntetes);
                    end
                    else
                    begin
                      // ancien -> Update
                      Requete := GetUpdateRequete(QueryGnkEnt, QueryTpnExt, 'TVENTE_ENTETE', ['MagId', 'TkeId'], DoNull);
                      if not (Trim(Requete) = '') then
                      begin
                        DoLogMultiLine('  Attention : Tentative d''update de ticket "' + WhereCle + '"', logWarning);
                        DoLogMultiLine('  requete : ' + Requete, logDebug);
                      end;
                      // mise a jour des max
                      Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', LameLastIDEnt, ListeLastId);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', MagLastIDEnt, ListeLastId);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      // Suite
                      FTransactionTpn.Commit();
                      QueryGnkEnt.Next();
                      Continue;
                    end;
                  finally
                    QueryTpnExt.Close();
                  end;

                  //=================================================================
                  // les lignes ??
                  Requete := 'select * from BI15_TVENTE_LIGNE_ID(' + IntToStr(EnteteID) + ');';
                  QueryGnkDet.SQL.Text := Requete;
                  try
                    QueryGnkDet.Open();
                    while not QueryGnkDet.Eof do
                    begin
                      // recup du dernier ID
                      GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDLig);
                      GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDLig);

                      // recherche d'existance
                      WhereCle := GetWhere(QueryGnkDet, ['TklId'], false);
                      Requete := 'select * from TVENTE_LIGNE where ' + WhereCle + ';';
                      QueryTpnExt.SQL.Text := Requete;
                      try
                        QueryTpnExt.Open();
                        if QueryTpnExt.Eof then
                        begin
                          if DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                              QueryGnkDet.FieldByName('TklModId').AsInteger,
                                              QueryGnkDet.FieldByName('TklTgfId').AsInteger,
                                              QueryGnkDet.FieldByName('TklCouId').AsInteger, true, DoNull) then
                          begin
                            // nouveau -> Insertion
                            Requete := GetInsertRequete(QueryGnkDet, 'TVENTE_LIGNE', DoNull);
                            DoLogMultiLine('  requete : ' + Requete, logNone);
                            QueryTpnMaj.SQL.Text := Requete;
                            QueryTpnMaj.ExecSQL();
                            Inc(NbLignes);

                            // Gestion des stocks
                            Requete := 'insert into TStock_Compl (StcMagId, StcModId, StcTgfId, StcCouId, StcQte) '
                                     + 'values ('
                                     +   IntToStr(Magasin.MagId) + ', '
                                     +   QueryGnkDet.FieldByName('TklModId').AsString + ', '
                                     +   QueryGnkDet.FieldByName('TklTgfId').AsString + ', '
                                     +   QueryGnkDet.FieldByName('TklCouId').AsString + ', '
                                     +   FloatToStr(-1 * QueryGnkDet.FieldByName('TklQteVte').AsFloat)
                                     + ');';
                            DoLogMultiLine('  requete : ' + Requete, logNone);
                            QueryTpnMaj.SQL.Text := Requete;
                            QueryTpnMaj.ExecSQL();
                          end
                          else
                          begin
                            if FDoErrArt then
                            begin
                              DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ticket "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logError);
                              Result := 3153;
                              Exit;
                            end
                            else
                              DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ticket "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logWarning);
                          end;
                        end
                        else
                        begin
                          // ancien -> Update
                          Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TVENTE_LIGNE', ['TklId'], DoNull);
                          if not (Trim(Requete) = '') then
                          begin
                            DoLogMultiLine('  Attention : Tentative d''update d''une ligne de ticket "' + WhereCle + '"', logWarning);
                            DoLogMultiLine('  requete : ' + Requete, logDebug);
                          end;
                        end;
                      finally
                        QueryTpnExt.Close();
                      end;
                      QueryGnkDet.Next();
                    end;
                  finally
                    QueryGnkDet.Close();
                  end;

                  //=================================================================
                  // les encaissement ??
                  Requete := 'select * from BI15_TVENTE_ENCAISSEMENT_ID(' + IntToStr(EnteteID) + ');';
                  QueryGnkDet.SQL.Text := Requete;
                  try
                    QueryGnkDet.Open();
                    while not QueryGnkDet.Eof do
                    begin
                      // recup du dernier ID
                      GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDEnc);
                      GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDEnc);

                      // recherche d'existance
                      WhereCle := GetWhere(QueryGnkDet, ['EncId'], false);
                      Requete := 'select * from TVENTE_ENCAISSEMENT where ' + WhereCle + ';';
                      QueryTpnExt.SQL.Text := Requete;
                      try
                        QueryTpnExt.Open();
                        if QueryTpnExt.Eof then
                        begin
                          // nouveau -> Insertion
                          Requete := GetInsertRequete(QueryGnkDet, 'TVENTE_ENCAISSEMENT', DoNull);
                          DoLogMultiLine('  requete : ' + Requete, logNone);
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                          Inc(NbEncs);
                        end
                        else
                        begin
                          // ancien -> Update
                          Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TVENTE_ENCAISSEMENT', ['EncId'], DoNull);
                          if not (Trim(Requete) = '') then
                          begin
                            DoLogMultiLine('  Attention : Tentative d''update d''encaissement "' + WhereCle + '"', logWarning);
                            DoLogMultiLine('  requete : ' + Requete, logDebug);
                          end;
                        end;
                      finally
                        QueryTpnExt.Close();
                      end;
                      QueryGnkDet.Next();
                    end;
                  finally
                    QueryGnkDet.Close();
                  end;

                  //=================================================================
                  // les max d'ID !
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', LameLastIDEnt, ListeLastId);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', MagLastIDEnt, ListeLastId);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', LameLastIDLig, ListeLastId);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', MagLastIDLig, ListeLastId);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', LameLastIDEnc, ListeLastId);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', MagLastIDEnc, ListeLastId);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                end;

                FTransactionTpn.Commit();
              except
                on e : Exception do
                begin
                  FTransactionTpn.Rollback();
                  DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
                  if not (Trim(Requete) = '') then
                    DoLogMultiLine('  requete : ' + Requete, logDebug);
                  Raise;
                end;
              end;
              QueryGnkEnt.Next();
            end;
          finally
            QueryGnkEnt.Close();
          end;

          DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes et ' + IntToStr(NbEncs) + ' encaissements traitées pour ' + IntToStr(NbEntetes) + ' entêtes', logTrace);
        end;
      end;

      // si on arrive ici !
      Result := 0;
    finally
      FreeAndNil(QueryGnkEnt);
      FreeAndNil(QueryGnkDet);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := 3152;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryGnkEnt, QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  EnteteID, LameLastIDEnt, MagLastIDEnt, LameLastIDLig, MagLastIDLig, NbEntetes, NbLignes : integer;
  WhereCle, Requete : string;
begin
  Result := 3251;
  FWhatIsDoing := ett_DeltaFactures;
  QueryGnkEnt := nil;
  QueryGnkDet := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';

  DoLogMultiLine('TTraitement.DoDeltaFacture', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();
      QueryGnkEnt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkDet := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      for Magasin in ListeMagasins do
      begin
        if Magasin.Actif then
        begin
          DoLogMultiLine('  -> Magasin : ' + Magasin.CodeAdh, logTrace);
          NbEntetes := 0;
          NbLignes := 0;

          LameLastIDEnt := GetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', ListeLastId);
          MagLastIDEnt := GetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', ListeLastId);
          LameLastIDLig := GetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', ListeLastId);
          MagLastIDLig := GetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', ListeLastId);

          Requete := 'select * from BI15_TFACTURE_ENTETE_MAGASIN(' + IntToStr(MagPlageDeb)
                                                            + ', ' + IntToStr(MagPlageFin)
                                                            + ', ' + IntToStr(MagLastIDEnt)
                                                            + ', ' + IntToStr(LamePlageDeb)
                                                            + ', ' + IntToStr(LamePlageFin)
                                                            + ', ' + IntToStr(LameLastIDEnt)
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinVte))
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax))
                                                            + ', ' + IntToStr(Magasin.MagId) + ') '
                                                            + 'ORDER BY KVERSION;';
          QueryGnkEnt.SQL.Text := Requete;
          try
            QueryGnkEnt.Open();
            while not (Terminated or QueryGnkEnt.Eof) do
            begin
              try
                FTransactionTpn.StartTransaction();

                // recup de l'ID entete
                EnteteID := QueryGnkEnt.FieldByName('FceId').AsInteger;
                // recup du dernier ID
                GetMaxKVersionOf(QueryGnkEnt, LamePlageDeb, LamePlageFin, LameLastIDEnt);
                GetMaxKVersionOf(QueryGnkEnt, MagPlageDeb, MagPlageFin, MagLastIDEnt);

                // recherche d'existance
                WhereCle := GetWhere(QueryGnkEnt, ['MagId', 'FceId'], false);
                Requete := 'select * from TFACTURE_ENTETE where ' + WhereCle + ';';
                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkEnt, 'TFACTURE_ENTETE', DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL();
                    Inc(NbEntetes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkEnt, QueryTpnExt, 'TFACTURE_ENTETE', ['MagId', 'FceId'], DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      DoLogMultiLine('  Attention : Tentative d''update de facture "' + WhereCle + '"', logWarning);
                      DoLogMultiLine('  requete : ' + Requete, logDebug);
                    end;
                    // mise a jour des max
                    Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', LameLastIDEnt, ListeLastId);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL();
                    Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', MagLastIDEnt, ListeLastId);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL();
                    // suite !
                    FTransactionTpn.Commit();
                    QueryGnkEnt.Next();
                    Continue;
                  end;
                finally
                  QueryTpnExt.Close();
                end;

                //=================================================================
                // les lignes ??
                Requete := 'select * from BI15_TFACTURE_LIGNE_ID(' + IntToStr(EnteteID) + ');';
                QueryGnkDet.SQL.Text := Requete;
                try
                  QueryGnkDet.Open();
                  while not QueryGnkDet.Eof do
                  begin
                    // recup du dernier ID
                    GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDLig);
                    GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDLig);

                    // recherche d'existance
                    WhereCle := GetWhere(QueryGnkDet, ['FclId'], false);
                    Requete := 'select * from TFACTURE_LIGNE where ' + WhereCle + ';';
                    QueryTpnExt.SQL.Text := Requete;
                    try
                      QueryTpnExt.Open();
                      if QueryTpnExt.Eof then
                      begin
                        if DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                            QueryGnkDet.FieldByName('FclModId').AsInteger,
                                            QueryGnkDet.FieldByName('FclTgfId').AsInteger,
                                            QueryGnkDet.FieldByName('FclCouId').AsInteger, true, DoNull) then
                        begin
                          // nouveau -> Insertion
                          Requete := GetInsertRequete(QueryGnkDet, 'TFACTURE_LIGNE', DoNull);
                          DoLogMultiLine('  requete : ' + Requete, logNone);
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                          Inc(NbLignes);
                        end
                        else
                        begin
                          if FDoErrArt then
                          begin
                            DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de facture "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('FclModId').AsInteger, QueryGnkDet.FieldByName('FclTgfId').AsInteger, QueryGnkDet.FieldByName('FclCouId').AsInteger) + '"', logError);
                            Result := 3253;
                            Exit;
                          end
                          else
                            DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de facture "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('FclModId').AsInteger, QueryGnkDet.FieldByName('FclTgfId').AsInteger, QueryGnkDet.FieldByName('FclCouId').AsInteger) + '"', logWarning);
                        end;
                      end
                      else
                      begin
                        // ancien -> Update
                        Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TFACTURE_LIGNE', ['FclId'], DoNull);
                        if not (Trim(Requete) = '') then
                        begin
                          DoLogMultiLine('  Attention : Tentative d''update d''une ligne de facture "' + WhereCle + '"', logWarning);
                          DoLogMultiLine('  requete : ' + Requete, logDebug);
                        end;
                      end;
                    finally
                      QueryTpnExt.Close();
                    end;
                    QueryGnkDet.Next();
                  end;
                finally
                  QueryGnkDet.Close();
                end;

                //=================================================================
                // les max d'ID !
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', LameLastIDEnt, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', MagLastIDEnt, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', LameLastIDLig, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();
                Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', MagLastIDLig, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();

                FTransactionTpn.Commit();
              except
                on e : Exception do
                begin
                  FTransactionTpn.Rollback();
                  DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
                  if not (Trim(Requete) = '') then
                    DoLogMultiLine('  requete : ' + Requete, logDebug);
                  Raise;
                end;
              end;
              QueryGnkEnt.Next();
            end;
          finally
            QueryGnkEnt.Close();
          end;

          DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées pour ' + IntToStr(NbEntetes) + ' entêtes', logTrace);
        end;
      end;

      // si on arrive ici !
      Result := 0;
    finally
      FreeAndNil(QueryGnkEnt);
      FreeAndNil(QueryGnkDet);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := 3252;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryGnkEnt, QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  MagasinID, EnteteID, LastID, QteDiff, NbEntetes, NbLignes : integer;
  WhereCle, Requete : string;
  FieldSuppr : TField;
begin
  Result := 3351;
  FWhatIsDoing := ett_DeltaMouvements;
  QueryGnkEnt := nil;
  QueryGnkDet := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';

  DoLogMultiLine('TTraitement.DoDeltaMouvement', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();
      QueryGnkEnt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkDet := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      for Magasin in ListeMagasins do
      begin
        if Magasin.Actif then
        begin
          DoLogMultiLine('  -> Magasin : ' + Magasin.CodeAdh, logTrace);
          NbEntetes := 0;
          NbLignes := 0;

          LastID := GetLastVersion(Magasin.MagId, 'TMVT', ListeLastId);

          Requete := 'select * from BI15_TMVT_ENTETE_MAGASIN(' + IntToStr(LastID)
                                                        + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt))
                                                        + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax))
                                                        + ', ' + IntToStr(Magasin.MagId) + ') '
                                                        + 'ORDER BY KVERSION;';
          QueryGnkEnt.SQL.Text := Requete;
          try
            QueryGnkEnt.Open();
            while not (Terminated or QueryGnkEnt.Eof) do
            begin
              try
                FTransactionTpn.StartTransaction();

                // recup de l'ID entete
                MagasinID := QueryGnkEnt.FieldByName('MagId').AsInteger;
                EnteteID := QueryGnkEnt.FieldByName('MvtId').AsInteger;

                // recherche d'existance
                WhereCle := GetWhere(QueryGnkEnt, ['MagId', 'MvtId'], false);
                Requete := 'select * from TMVT_ENTETE where ' + WhereCle + ';';
                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkEnt, 'TMVT_ENTETE', DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL();
                    Inc(NbEntetes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkEnt, QueryTpnExt, 'TMVT_ENTETE', ['MvtId'], DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      // pas de modif des entete ... juste les quantité en lignes !
                      DoLogMultiLine('  Attention : update d''entete de mouvement "' + WhereCle + '" requete : ' + Requete, logDebug);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbEntetes);
                    end;
                  end;
                finally
                  QueryTpnExt.Close();
                end;

                //=================================================================
                // les lignes ??
                Requete := 'select * from BI15_TMVT_LIGNE_ID(' + IntToStr(MagasinID) + ', ' + IntToStr(EnteteID) + ');';
                QueryGnkDet.SQL.Text := Requete;
                try
                  QueryGnkDet.Open();
                  while not QueryGnkDet.Eof do
                  begin
                    // recup du dernier ID
                    GetMaxKVersionOf(QueryGnkDet, 0, MaxInt, LastID);
                    // Fileds spéciaux
                    FieldSuppr := GetOneFieldOf(QueryGnkDet, FIELD_KENABLED);

                    // recherche d'existance
                    WhereCle := GetWhere(QueryGnkDet, ['MagId', 'MvtId', 'MvlId'], false);
                    Requete := 'select MagId, MvtId, MvlId, MvlModId, MvlTgfId, MvlCouId, MvlNumCde, MvtNumFacture, MvtTypeFacture, '
                             + '       sum(MvlQte) as MvlQte, avg(MvlPxPump) as MvlPxPump, avg(MvlPx) as MvlPx, max(MvlColId) as MvlColId, '
                             + '       count(*) as nblig '
                             + 'from TMVT_LIGNE '
                             + 'where ' + WhereCle + ' '
                             + 'group by MagId, MvtId, MvlId, MvlModId, MvlTgfId, MvlCouId, MvlNumCde, MvtNumFacture, MvtTypeFacture;';
                    QueryTpnExt.SQL.Text := Requete;
                    try
                      QueryTpnExt.Open();
                      if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
                      begin
                        if QueryTpnExt.Eof then
                        begin
                          if DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                              QueryGnkDet.FieldByName('MvlModId').AsInteger,
                                              QueryGnkDet.FieldByName('MvlTgfId').AsInteger,
                                              QueryGnkDet.FieldByName('MvlCouId').AsInteger, true, DoNull) then
                          begin
                            // nouveau -> Insertion
                            Requete := GetInsertRequete(QueryGnkDet, 'TMVT_LIGNE', DoNull);
                            DoLogMultiLine('  requete : ' + Requete, logNone);
                            QueryTpnMaj.SQL.Text := Requete;
                            QueryTpnMaj.ExecSQL();
                            Inc(NbLignes);

                            // Gestion des stocks
                            Requete := 'insert into TStock_Compl (StcMagId, StcModId, StcTgfId, StcCouId, StcQte) '
                                     + 'values ('
                                     +   IntToStr(Magasin.MagId) + ', '
                                     +   QueryGnkDet.FieldByName('MvlModId').AsString + ', '
                                     +   QueryGnkDet.FieldByName('MvlTgfId').AsString + ', '
                                     +   QueryGnkDet.FieldByName('MvlCouId').AsString + ', '
                                     +   IntToStr(QueryGnkEnt.FieldByName('MvtSens').AsInteger * QueryGnkDet.FieldByName('MvlQte').AsInteger)
                                     + ');';
                            DoLogMultiLine('  requete : ' + Requete, logNone);
                            QueryTpnMaj.SQL.Text := Requete;
                            QueryTpnMaj.ExecSQL;
                          end
                          else
                          begin
                            if FDoErrArt then
                            begin
                              DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de mouvement "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('MvlModId').AsInteger, QueryGnkDet.FieldByName('MvlTgfId').AsInteger, QueryGnkDet.FieldByName('MvlCouId').AsInteger) + '"', logError);
                              Result := 3353;
                              Exit;
                            end
                            else
                              DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de mouvement "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('MvlModId').AsInteger, QueryGnkDet.FieldByName('MvlTgfId').AsInteger, QueryGnkDet.FieldByName('MvlCouId').AsInteger) + '"', logWarning);
                          end;
                        end
                        else
                        begin
                          // ancien -> Update
                          Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TMVT_LIGNE', ['MagId', 'MvtId', 'MvlId'], DoNull);
                          if not (Trim(Requete) = '') then
                          begin
                            DoLogMultiLine('  Attention : update d''une ligne de mouvement "' + WhereCle + '" requete : ' + Requete, logDebug);
                            // cas de la maj si une seul ligne !
                            if QueryTpnExt.FieldByName('nblig').AsInteger = 1 then
                            begin
                              QueryTpnMaj.SQL.Text := Requete;
                              QueryTpnMaj.ExecSQL();
                              Inc(NbLignes);
                            end
                            // cas de la maj de plusieur lignes... suppression puis reinsertion
                            else if QueryTpnExt.FieldByName('nblig').AsInteger > 1 then
                            begin
                              // suppression du vieux
                              Requete := GetDeleteRequete(QueryGnkDet, 'TMVT_LIGNE', ['MagId', 'MvtId', 'MvlId'], DoNull);
                              DoLogMultiLine('  requete : ' + Requete, logNone);
                              QueryTpnMaj.SQL.Text := Requete;
                              QueryTpnMaj.ExecSQL();
                              // re-insertion de la donnée
                              Requete := GetInsertRequete(QueryGnkDet, 'TMVT_LIGNE', DoNull);
                              DoLogMultiLine('  requete : ' + Requete, logNone);
                              QueryTpnMaj.SQL.Text := Requete;
                              QueryTpnMaj.ExecSQL();
                              Inc(NbLignes);
                            end;

                            // Gestion des stocks
                            QteDiff := QueryGnkEnt.FieldByName('MvtSens').AsInteger * GetFieldDiffInt(QueryGnkDet.FieldByName('MvlQte'), QueryTpnExt.FieldByName('MvlQte'));
                            if qteDiff <> 0 then
                            begin
                              Requete := 'insert into TStock_Compl (StcMagId, StcModId, StcTgfId, StcCouId, StcQte) '
                                       + 'values ('
                                       +   IntToStr(Magasin.MagId) + ', '
                                       +   QueryGnkDet.FieldByName('MvlModId').AsString + ', '
                                       +   QueryGnkDet.FieldByName('MvlTgfId').AsString + ', '
                                       +   QueryGnkDet.FieldByName('MvlCouId').AsString + ', '
                                       +   IntToStr(QteDiff)
                                       + ');';
                              DoLogMultiLine('  requete : ' + Requete, logNone);
                              QueryTpnMaj.SQL.Text := Requete;
                              QueryTpnMaj.ExecSQL();
                            end;
                          end;
                        end;
                      end
                      else if not QueryTpnExt.Eof then
                      begin
                        // ancien -> a supprimer
                        Requete := GetUpdateDelRequete(QueryGnkDet, 'TMVT_LIGNE', ['MvlQte'], ['MagId', 'MvtId', 'MvlId'], DoNull);
                        DoLogMultiLine('  Attention : suppression d''une ligne de mouvement "' + WhereCle + '" requete : ' + Requete, logDebug);
                        // cas de la maj si une seul ligne !
                        if QueryTpnExt.FieldByName('nblig').AsInteger = 1 then
                        begin
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                          Inc(NbLignes);
                        end
                        // cas de la maj de plusieur lignes... suppression puis reinsertion puis suppression
                        else if QueryTpnExt.FieldByName('nblig').AsInteger > 1 then
                        begin
                          // suppression du vieux
                          Requete := GetDeleteRequete(QueryGnkDet, 'TMVT_LIGNE', ['MagId', 'MvtId', 'MvlId'], DoNull);
                          DoLogMultiLine('  requete : ' + Requete, logNone);
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                          // re-insertion de la donnée
                          Requete := GetInsertRequete(QueryGnkDet, 'TMVT_LIGNE', DoNull);
                          DoLogMultiLine('  requete : ' + Requete, logNone);
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                          // suppression
                          Requete := GetUpdateDelRequete(QueryGnkDet, 'TMVT_LIGNE', ['MvlQte'], ['MagId', 'MvtId', 'MvlId'], DoNull);
                          DoLogMultiLine('  requete : ' + Requete, logNone);
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                          Inc(NbLignes);
                        end;

                        // Gestion des stocks
                        QteDiff := -1 * QueryGnkEnt.FieldByName('MvtSens').AsInteger * QueryTpnExt.FieldByName('MvlQte').AsInteger;
                        if QteDiff <> 0 then
                        begin
                          Requete := 'insert into TStock_Compl (StcMagId, StcModId, StcTgfId, StcCouId, StcQte) '
                                   + 'values ('
                                   +   IntToStr(Magasin.MagId) + ', '
                                   +   QueryGnkDet.FieldByName('MvlModId').AsString + ', '
                                   +   QueryGnkDet.FieldByName('MvlTgfId').AsString + ', '
                                   +   QueryGnkDet.FieldByName('MvlCouId').AsString + ', '
                                   +   IntToStr(QteDiff)
                                   + ');';
                          DoLogMultiLine('  requete : ' + Requete, logNone);
                          QueryTpnMaj.SQL.Text := Requete;
                          QueryTpnMaj.ExecSQL();
                        end;
                      end;
                    finally
                      QueryTpnExt.Close();
                    end;
                    QueryGnkDet.Next();
                  end;
                finally
                  QueryGnkDet.Close();
                end;

                //=================================================================
                // les max d'ID !
                Requete := SetLastVersion(Magasin.MagId, 'TMVT', LastID, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL();

                FTransactionTpn.Commit();
              except
                on e : Exception do
                begin
                  FTransactionTpn.Rollback();
                  DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
                  if not (Trim(Requete) = '') then
                    DoLogMultiLine('  requete : ' + Requete, logDebug);
                  Raise;
                end;
              end;
              QueryGnkEnt.Next();
            end;
          finally
            QueryGnkEnt.Close();
          end;

          DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées pour ' + IntToStr(NbEntetes) + ' entêtes', logTrace);
        end;
      end;

      // si on arrive ici :
      Result := 0;
    finally
      FreeAndNil(QueryGnkEnt);
      FreeAndNil(QueryGnkDet);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := 3352;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaCommande(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin: integer; ListeLastId: TListLastIDs; DoNull: boolean): integer;
var
  WhereCle, Requete: string;
  Magasin: TMagasin;
  QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj: TMyQuery;
  LameLastID, MagLastId, NbLignes: integer;
  FieldSuppr : TField;
begin
  Result := 4151;
  FWhatIsDoing := ett_DeltaCommandes;
  QueryGnkDet := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';

  DoLogMultiLine('TTraitement.DoDeltaCommande', logTrace);

  try
    try
      FTransactionGnk.StartTransaction;
      QueryGnkDet := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      for Magasin in ListeMagasins do
      begin
        if Magasin.Actif then
        begin
          DoLogMultiLine('  -> Magasin : ' + Magasin.CodeAdh, logTrace);
          NbLignes := 0;

          LameLastID := GetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', ListeLastId);

          Requete := 'select * from BI15_TCOMMANDESTATUT_MAGASIN(' + IntToStr(MagPlageDeb)
                                                            + ', ' + IntToStr(MagPlageFin)
                                                            + ', ' + IntToStr(MagLastId)
                                                            + ', ' + IntToStr(LamePlageDeb)
                                                            + ', ' + IntToStr(LamePlageFin)
                                                            + ', ' + IntToStr(LameLastID)
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinCmd))
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax))
                                                            + ', ' + IntToStr(Magasin.MagId) + ') '
                                                            + 'ORDER BY KVERSION;';

          QueryGnkDet.SQL.Text := Requete;
          QueryGnkDet.Open;
          try
            while not (Terminated or QueryGnkDet.Eof) do
            begin
              try
                FTransactionTpn.StartTransaction;

                // recup du dernier ID
                GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastID);
                GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastID);
                // Fileds spéciaux
                FieldSuppr := GetOneFieldOf(QueryGnkDet, FIELD_KENABLED);

                // recherche d'existence
                WhereCle := GetWhere(QueryGnkDet, ['MagId', 'CmdBlhId', 'CmdBllId'], False);
                Requete := 'select * from TCOMMANDESTATUT where ' + WhereCle + ';';

                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if not (Assigned(FieldSuppr) and (FieldSuppr.AsInteger = 0)) then
                  begin
                    if QueryTpnExt.Eof then
                    begin
                      if DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                        QueryGnkDet.FieldByName('CmdModId').AsInteger,
                        QueryGnkDet.FieldByName('CmdTgfId').AsInteger,
                        QueryGnkDet.FieldByName('CmdCouId').AsInteger, True, DoNull) then
                      begin
                        // nouveau -> Insertion
                        Requete := GetInsertRequete(QueryGnkDet, 'TCOMMANDESTATUT', DoNull);
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL;
                        Inc(NbLignes);
                      end
                      else
                      begin
                        if FDoErrArt then
                        begin
                          DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de commande "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('CmdModId').AsInteger, QueryGnkDet.FieldByName('CmdTgfId').AsInteger, QueryGnkDet.FieldByName('CmdCouId').AsInteger) + '"', logError);
                          Result := 4153;
                          Exit;
                        end
                        else
                          DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de commande "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('CmdModId').AsInteger, QueryGnkDet.FieldByName('CmdTgfId').AsInteger, QueryGnkDet.FieldByName('CmdCouId').AsInteger) + '"', logWarning);
                      end;
                    end
                    else
                    begin
                      // ancien -> Update
                      Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TCOMMANDESTATUT', ['MagId', 'CmdBlhId', 'CmdBllId'], DoNull);
                      if not string.IsNullOrWhiteSpace(Requete) then
                      begin
                        DoLogMultiLine('  Attention : Tentative d''update d''une ligne de commande "' + WhereCle + '"', logWarning);
                        DoLogMultiLine('  requete : ' + Requete, logDebug);
                      end;
                    end;
                  end
                  else if not QueryTpnExt.Eof then
                  begin
                    // ancien -> a supprimer
                    // en fait traitement spécifique ... le status n'est plus le statut courant ...
                    Requete := 'update TCommandeStatut set CmdIsCurrent = false where ' + WhereCle + ';';
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL;
                    Inc(NbLignes);
                  end;
                finally
                  QueryTpnExt.Close;
                end;

                //=================================================================
                // les max d'ID !
                Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', LameLastID, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL;
                Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', MagLastID, ListeLastId);
                QueryTpnMaj.SQL.Text := Requete;
                QueryTpnMaj.ExecSQL;

                FTransactionTpn.Commit;
              except
                on E : Exception do
                begin
                  FTransactionTpn.Rollback;
                  DoLogMultiLine('Exception : ' + GetExceptionMessage(E), logCritical);
                  if not string.IsNullOrWhiteSpace(Requete) then
                    DoLogMultiLine('  requete : ' + Requete, logDebug);
                  raise;
                end;
              end;
              QueryGnkDet.Next;
            end;
          finally
            QueryGnkDet.Close;
          end;

          DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes traitées', logTrace);
        end;
      end;

      Result := 0;
    finally
      FreeAndNil(QueryGnkDet);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback;
    end;
  except
    on E : Exception do
    begin
      Result := 4152;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(E), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaReception(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  QueryGnkEnt, QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  EnteteID, LameLastIDEnt, MagLastIDEnt, LameLastIDLig, MagLastIDLig, LameLastIDTVA, MagLastIDTVA, NbEntetes, NbLignes, NbTVA : integer;
  WhereCle, Requete : string;
begin
  Result := 5151;
  FWhatIsDoing := ett_DeltaReceptions;
  QueryGnkEnt := nil;
  QueryGnkDet := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';

  DoLogMultiLine('TTraitement.DoDeltaReception', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();
      QueryGnkEnt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkDet := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      NbEntetes := 0;
      NbLignes := 0;
      NbTVA := 0;

      LameLastIDEnt := GetLastVersion(0, 'TRECEPTION_ENTETE_Lame', ListeLastId);
      MagLastIDEnt := GetLastVersion(0, 'TRECEPTION_ENTETE_Mag', ListeLastId);
      LameLastIDLig := GetLastVersion(0, 'TRECEPTION_LIGNE_Lame', ListeLastId);
      MagLastIDLig := GetLastVersion(0, 'TRECEPTION_LIGNE_Mag', ListeLastId);
      LameLastIDTVA := GetLastVersion(0, 'TRECEPTION_TVA_Lame', ListeLastId);
      MagLastIDTVA := GetLastVersion(0, 'TRECEPTION_TVA_Mag', ListeLastId);

      Requete := 'select * from BI15_TRECEPTION_ENTETE(' + IntToStr(MagPlageDeb)
                                                  + ', ' + IntToStr(MagPlageFin)
                                                  + ', ' + IntToStr(MagLastIDEnt)
                                                  + ', ' + IntToStr(LamePlageDeb)
                                                  + ', ' + IntToStr(LamePlageFin)
                                                  + ', ' + IntToStr(LameLastIDEnt)
                                                  + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinRap))
                                                  + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax)) + ') '
                                                  + 'ORDER BY KVERSION;';
      QueryGnkEnt.SQL.Text := Requete;
      try
        QueryGnkEnt.Open();
        while not (Terminated or QueryGnkEnt.Eof) do
        begin
          try
            FTransactionTpn.StartTransaction();

            // recup de l'ID entete
            EnteteID := QueryGnkEnt.FieldByName('BreId').AsInteger;
            // recup du dernier ID
            GetMaxKVersionOf(QueryGnkEnt, LamePlageDeb, LamePlageFin, LameLastIDEnt);
            GetMaxKVersionOf(QueryGnkEnt, MagPlageDeb, MagPlageFin, MagLastIDEnt);

            // recherche d'existance
            WhereCle := GetWhere(QueryGnkEnt, ['BreId', 'Sens'], false);
            Requete := 'select * from TRECEPTION_ENTETE where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if QueryTpnExt.Eof then
              begin
                if DoGestionFournisseur(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                        QueryGnkEnt.FieldByName('FouId').AsInteger, true, DoNull) then
                begin
                  // nouveau -> Insertion
                  Requete := GetInsertRequete(QueryGnkEnt, 'TRECEPTION_ENTETE', DoNull);
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Inc(NbEntetes);
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une réception "' + WhereCle + '" avec un fournisseur inexistant "FouId = ' + QueryGnkDet.FieldByName('FouId').AsString + '"', logWarning);
              end
              else
              begin
                // ancien -> Update
                Requete := GetUpdateRequete(QueryGnkEnt, QueryTpnExt, 'TRECEPTION_ENTETE', ['BreId', 'Sens'], DoNull);
                if not (Trim(Requete) = '') then
                begin
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Inc(NbEntetes);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            //=================================================================
            // les lignes ??
            Requete := 'select * from BI15_TRECEPTION_LIGNE_ID(' + IntToStr(EnteteID) + ');';
            QueryGnkDet.SQL.Text := Requete;
            try
              QueryGnkDet.Open();
              while not QueryGnkDet.Eof do
              begin
                // recup du dernier ID
                GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDLig);
                GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDLig);

                // recherche d'existance
                WhereCle := GetWhere(QueryGnkDet, ['BrlId', 'Sens'], false);
                Requete := 'select * from TRECEPTION_LIGNE where ' + WhereCle + ';';
                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if QueryTpnExt.Eof then
                  begin
                    if DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                        QueryGnkDet.FieldByName('ModId').AsInteger,
                                        QueryGnkDet.FieldByName('TgfId').AsInteger,
                                        QueryGnkDet.FieldByName('CouId').AsInteger, true, DoNull) then
                    begin
                      // nouveau -> Insertion
                      Requete := GetInsertRequete(QueryGnkDet, 'TRECEPTION_LIGNE', DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbLignes);
                    end
                    else
                    begin
                      if FDoErrArt then
                      begin
                        DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de réception "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logError);
                        Result := 5153;
                        Exit;
                      end
                      else
                        DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de réception "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logWarning);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TRECEPTION_LIGNE', ['BrlId', 'Sens'], DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbLignes);
                    end;
                  end;
                finally
                  QueryTpnExt.Close();
                end;
                QueryGnkDet.Next();
              end;
            finally
              QueryGnkDet.Close();
            end;

            //=================================================================
            // les lignes de TVA ??
            Requete := 'select * from BI15_TRECEPTION_TVA_ID(' + IntToStr(EnteteID) + ');';
            QueryGnkDet.SQL.Text := Requete;
            try
              QueryGnkDet.Open();
              while not QueryGnkDet.Eof do
              begin
                // recup du dernier ID
                GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDTVA);
                GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDTVA);

                // recherche d'existance
                WhereCle := GetWhere(QueryGnkDet, ['BreId', 'Sens', 'BreTaux'], false);
                Requete := 'select * from TRECEPTION_TVA where ' + WhereCle + ';';
                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkDet, 'TRECEPTION_TVA', DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL();
                    Inc(NbTVA);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TRECEPTION_TVA', ['BreId', 'Sens', 'BreTaux'], DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbTVA);
                    end;
                  end;
                finally
                  QueryTpnExt.Close();
                end;
                QueryGnkDet.Next();
              end;
            finally
              QueryGnkDet.Close();
            end;

            //=================================================================
            // les max d'ID !
            Requete := SetLastVersion(0, 'TRECEPTION_ENTETE_Lame', LameLastIDEnt, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_ENTETE_Mag', MagLastIDEnt, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_LIGNE_Lame', LameLastIDLig, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_LIGNE_Mag', MagLastIDLig, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_TVA_Lame', LameLastIDTVA, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRECEPTION_TVA_Mag', MagLastIDTVA, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();

            FTransactionTpn.Commit();
          except
            on e : Exception do
            begin
              FTransactionTpn.Rollback();
              DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
              if not (Trim(Requete) = '') then
                DoLogMultiLine('  requete : ' + Requete, logDebug);
              Raise;
            end;
          end;
          QueryGnkEnt.Next();
        end;
      finally
        QueryGnkEnt.Close();
      end;

      DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes et ' + IntToStr(NbTVA) + ' TVA traitées pour ' + IntToStr(NbEntetes) + ' entêtes', logTrace);

      // si on arrive ici !
      Result := 0;
    finally
      FreeAndNil(QueryGnkEnt);
      FreeAndNil(QueryGnkDet);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := 5152;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaRetour(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  QueryGnkEnt, QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  EnteteID, LameLastIDEnt, MagLastIDEnt, LameLastIDLig, MagLastIDLig, LameLastIDTVA, MagLastIDTVA, NbEntetes, NbLignes, NbTVA : integer;
  WhereCle, Requete : string;
begin
  Result := 5251;
  FWhatIsDoing := ett_DeltaRetours;
  QueryGnkEnt := nil;
  QueryGnkDet := nil;
  QueryGnkArt := nil;
  QueryTpnArt := nil;
  QueryTpnExt := nil;
  QueryTpnMaj := nil;
  Requete := '';
  WhereCle := '';

  DoLogMultiLine('TTraitement.DoDeltaRetour', logTrace);

  try
    try
      FTransactionGnk.StartTransaction();
      QueryGnkEnt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkDet := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryGnkArt := GetNewQuery(FConnexionGnk, FTransactionGnk);
      QueryTpnArt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnExt := GetNewQuery(FConnexionTpn, FTransactionTpn);
      QueryTpnMaj := GetNewQuery(FConnexionTpn, FTransactionTpn);

      NbEntetes := 0;
      NbLignes := 0;
      NbTVA := 0;

      LameLastIDEnt := GetLastVersion(0, 'TRETOUR_ENTETE_Lame', ListeLastId);
      MagLastIDEnt := GetLastVersion(0, 'TRETOUR_ENTETE_Mag', ListeLastId);
      LameLastIDLig := GetLastVersion(0, 'TRETOUR_LIGNE_Lame', ListeLastId);
      MagLastIDLig := GetLastVersion(0, 'TRETOUR_LIGNE_Mag', ListeLastId);
      LameLastIDTVA := GetLastVersion(0, 'TRETOUR_TVA_Lame', ListeLastId);
      MagLastIDTVA := GetLastVersion(0, 'TRETOUR_TVA_Mag', ListeLastId);

      Requete := 'select * from BI15_TRETOUR_ENTETE(' + IntToStr(MagPlageDeb)
                                               + ', ' + IntToStr(MagPlageFin)
                                               + ', ' + IntToStr(MagLastIDEnt)
                                               + ', ' + IntToStr(LamePlageDeb)
                                               + ', ' + IntToStr(LamePlageFin)
                                               + ', ' + IntToStr(LameLastIDEnt)
                                               + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinRap))
                                               + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMax)) + ') '
                                               + 'ORDER BY KVERSION;';
      QueryGnkEnt.SQL.Text := Requete;
      try
        QueryGnkEnt.Open();
        while not (Terminated or QueryGnkEnt.Eof) do
        begin
          try
            FTransactionTpn.StartTransaction();

            // recup de l'ID entete
            EnteteID := QueryGnkEnt.FieldByName('RetId').AsInteger;
            // recup du dernier ID
            GetMaxKVersionOf(QueryGnkEnt, LamePlageDeb, LamePlageFin, LameLastIDEnt);
            GetMaxKVersionOf(QueryGnkEnt, MagPlageDeb, MagPlageFin, MagLastIDEnt);

            // recherche d'existance
            WhereCle := GetWhere(QueryGnkEnt, ['RetId', 'Sens'], false);
            Requete := 'select * from TRETOUR_ENTETE where ' + WhereCle + ';';
            QueryTpnExt.SQL.Text := Requete;
            try
              QueryTpnExt.Open();
              if QueryTpnExt.Eof then
              begin
                if DoGestionFournisseur(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                        QueryGnkEnt.FieldByName('FouId').AsInteger, true, DoNull) then
                begin
                  // nouveau -> Insertion
                  Requete := GetInsertRequete(QueryGnkEnt, 'TRETOUR_ENTETE', DoNull);
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Inc(NbEntetes);
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une retour "' + WhereCle + '" avec un fournisseur inexistant "FouId = ' + QueryGnkDet.FieldByName('FouId').AsString + '"', logWarning);
              end
              else
              begin
                // ancien -> Update
                Requete := GetUpdateRequete(QueryGnkEnt, QueryTpnExt, 'TRETOUR_ENTETE', ['RetId', 'Sens'], DoNull);
                if not (Trim(Requete) = '') then
                begin
                  DoLogMultiLine('  requete : ' + Requete, logNone);
                  QueryTpnMaj.SQL.Text := Requete;
                  QueryTpnMaj.ExecSQL();
                  Inc(NbEntetes);
                end;
              end;
            finally
              QueryTpnExt.Close();
            end;

            //=================================================================
            // les lignes ??
            Requete := 'select * from BI15_TRETOUR_LIGNE_ID(' + IntToStr(EnteteID) + ');';
            QueryGnkDet.SQL.Text := Requete;
            try
              QueryGnkDet.Open();
              while not QueryGnkDet.Eof do
              begin
                // recup du dernier ID
                GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDLig);
                GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDLig);

                // recherche d'existance
                WhereCle := GetWhere(QueryGnkDet, ['RelId', 'Sens'], false);
                Requete := 'select * from TRETOUR_LIGNE where ' + WhereCle + ';';
                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if QueryTpnExt.Eof then
                  begin
                    if DoGestionArticle(QueryGnkArt, QueryTpnArt, QueryTpnMaj,
                                        QueryGnkDet.FieldByName('ModId').AsInteger,
                                        QueryGnkDet.FieldByName('TgfId').AsInteger,
                                        QueryGnkDet.FieldByName('CouId').AsInteger, true, DoNull) then
                    begin
                      // nouveau -> Insertion
                      Requete := GetInsertRequete(QueryGnkDet, 'TRETOUR_LIGNE', DoNull);
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbLignes);
                    end
                    else
                    begin
                      if FDoErrArt then
                      begin
                        DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de retour "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logError);
                        Result := 5253;
                        Exit;
                      end
                      else
                        DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de retour "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logWarning);
                    end;
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TRETOUR_LIGNE', ['RelId', 'Sens'], DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbLignes);
                    end;
                  end;
                finally
                  QueryTpnExt.Close();
                end;
                QueryGnkDet.Next();
              end;
            finally
              QueryGnkDet.Close();
            end;

            //=================================================================
            // les lignes de TVA ??
            Requete := 'select * from BI15_TRETOUR_TVA_ID(' + IntToStr(EnteteID) + ');';
            QueryGnkDet.SQL.Text := Requete;
            try
              QueryGnkDet.Open();
              while not QueryGnkDet.Eof do
              begin
                // recup du dernier ID
                GetMaxKVersionOf(QueryGnkDet, LamePlageDeb, LamePlageFin, LameLastIDTVA);
                GetMaxKVersionOf(QueryGnkDet, MagPlageDeb, MagPlageFin, MagLastIDTVA);

                // recherche d'existance
                WhereCle := GetWhere(QueryGnkDet, ['RetId', 'Sens', 'RetTaux'], false);
                Requete := 'select * from TRETOUR_TVA where ' + WhereCle + ';';
                QueryTpnExt.SQL.Text := Requete;
                try
                  QueryTpnExt.Open();
                  if QueryTpnExt.Eof then
                  begin
                    // nouveau -> Insertion
                    Requete := GetInsertRequete(QueryGnkDet, 'TRETOUR_TVA', DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    QueryTpnMaj.SQL.Text := Requete;
                    QueryTpnMaj.ExecSQL();
                    Inc(NbTVA);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkDet, QueryTpnExt, 'TRETOUR_TVA', ['RetId', 'Sens', 'RetTaux'], DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      DoLogMultiLine('  requete : ' + Requete, logNone);
                      QueryTpnMaj.SQL.Text := Requete;
                      QueryTpnMaj.ExecSQL();
                      Inc(NbTVA);
                    end;
                  end;
                finally
                  QueryTpnExt.Close();
                end;
                QueryGnkDet.Next();
              end;
            finally
              QueryGnkDet.Close();
            end;

            //=================================================================
            // les max d'ID !
            Requete := SetLastVersion(0, 'TRETOUR_ENTETE_Lame', LameLastIDEnt, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_ENTETE_Mag', MagLastIDEnt, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_LIGNE_Lame', LameLastIDLig, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_LIGNE_Mag', MagLastIDLig, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_TVA_Lame', LameLastIDTVA, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();
            Requete := SetLastVersion(0, 'TRETOUR_TVA_Mag', MagLastIDTVA, ListeLastId);
            QueryTpnMaj.SQL.Text := Requete;
            QueryTpnMaj.ExecSQL();

            FTransactionTpn.Commit();
          except
            on e : Exception do
            begin
              FTransactionTpn.Rollback();
              DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
              if not (Trim(Requete) = '') then
                DoLogMultiLine('  requete : ' + Requete, logDebug);
              Raise;
            end;
          end;
          QueryGnkEnt.Next();
        end;
      finally
        QueryGnkEnt.Close();
      end;

      DoLogMultiLine('  -> ' + IntToStr(NbLignes) + ' lignes et ' + IntToStr(NbTVA) + ' TVA traitées pour ' + IntToStr(NbEntetes) + ' entêtes', logTrace);

      // si on arrive ici !
      Result := 0;
    finally
      FreeAndNil(QueryGnkEnt);
      FreeAndNil(QueryGnkDet);
      FreeAndNil(QueryGnkArt);
      FreeAndNil(QueryTpnArt);
      FreeAndNil(QueryTpnExt);
      FreeAndNil(QueryTpnMaj);
      FTransactionGnk.Rollback();
    end;
  except
    on e : Exception do
    begin
      Result := 5252;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

//---- Groupe fonctionnel (monitoring)

function TTraitement.DoDeltaBI(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  tmpLogMdl : string;
  tmpRes : integer;
begin
  Result := 0;

  DoLogMultiLine('TTraitement.DoDeltaBI', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := 'BI';
    DoLogMultiLine('Début', logNotice, true);

    // gestion de l'extraction des tickets !
    if not Terminated and (ett_DeltaTickets in FWhatToDo) then
    begin
      tmpRes := DoDeltaTicket(ListeMagasins, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;
    // gestion de l'extraction des factures !
    if not Terminated and (ett_DeltaFactures in FWhatToDo) then
    begin
      tmpRes := DoDeltaFacture(ListeMagasins, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;
    // gestion de l'extraction des mouvement !
    if not Terminated and (ett_DeltaMouvements in FWhatToDo) then
    begin
      tmpRes := DoDeltaMouvement(ListeMagasins, ListeLastId, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

function TTraitement.DoDeltaCrossCanal(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  tmpLogMdl : string;
  tmpRes : integer;
begin
  Result := 0;

  DoLogMultiLine('TTraitement.DoDeltaCrossCanal', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := 'Commandes';
    DoLogMultiLine('Début', logNotice, True);

    // gestion de l'extraction des tickets !
    if not Terminated and (ett_DeltaCommandes in FWhatToDo) then
    begin
      tmpRes := DoDeltaCommande(ListeMagasins, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

function TTraitement.DoDeltaRapproAuto(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  tmpLogMdl : string;
  tmpRes : integer;
begin
  Result := 0;

  DoLogMultiLine('TTraitement.DoDeltaRapproAuto', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := 'RapprAuto';
    DoLogMultiLine('Début', logNotice, true);

    // gestion de l'extraction des receptions !
    if not Terminated and (ett_DeltaReceptions in FWhatToDo) then
    begin
      tmpRes := DoDeltaReception(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;
    // gestion de l'extraction des retours !
    if not Terminated and (ett_DeltaRetours in FWhatToDo) then
    begin
      tmpRes := DoDeltaRetour(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
      if not (tmpRes = 0) then
      begin
        Result := tmpRes;
        Exit;
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

// Gestion des stock

function TTraitement.DoHistoStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  tmpDate : TDate;
  Ret : TEnumResult;
begin
  Result := 8101;
  FWhatIsDoing := ett_HistoStock;

  DoLogMultiLine('TTraitement.DoHistoStock', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        tmpDate := EndOfTheMonth(FDateMinStk);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin,
                          'TStockDate', ['StkDate', 'StkMagId', 'StkModId', 'StkTgfId', 'StkCouId'], tmpDate, 0, erl_ReInitialisation,
                          DoArt, true, false, false, DoNull, false);
        case Ret of
          ers_Succeded, ers_Interrupted :
            begin
              FTransactionTpn.Commit();
              tmpDate := EndOfTheMonth(IncDay(tmpDate, 1));
              while not Terminated and (tmpDate < Now()) do
              begin
                FTransactionTpn.StartTransaction();
                Ret := CopieTable(Magasin,
                                  'TStockDate', ['StkDate', 'StkMagId', 'StkModId', 'StkTgfId', 'StkCouId'], tmpDate, 0, erl_ReInitialisation,
                                  DoArt, true, false, false, DoNull, false);
                case Ret of
                  ers_Succeded, ers_Interrupted :
                    begin
                      FTransactionTpn.Commit();
                    end;
                  ers_Failed :
                    begin
                      FTransactionTpn.Rollback();
                      Result := 8104;
                      Exit;
                    end;
                end;
                tmpDate := EndOfTheMonth(IncDay(tmpDate, 1));
              end;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 8103;
              Exit;
            end;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      Result := 8102;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.DoResetStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  tmpLogMdl : string;
  Requete : string;
  Ret : TEnumResult;
begin
  Result := 8201;
  FWhatIsDoing := ett_ResetStock;
  Requete := '';

  DoLogMultiLine('TTraitement.DoResetStock', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := 'Stock';
    DoLogMultiLine('Début', logNotice, true);

    try
      FTransactionTpn.StartTransaction();
      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

        Requete := 'delete from TVerificationStocks;';
        QueryTpn.SQL.Text := Requete;
        QueryTpn.ExecSQL();
      finally
        FreeAndNil(QueryTpn);
      end;
      FTransactionTpn.Commit();
    except
      on e : Exception do
      begin
        FTransactionTpn.Rollback();
        Result := 8205;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
        Exit;
      end;
    end;

    try
      for Magasin in ListeMagasins do
      begin
        if Magasin.Actif then
        begin
          FTransactionTpn.StartTransaction();

          try
            try
              QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

              Requete := 'delete from TStock_Compl where StcMagId = ' + IntToStr(Magasin.MagId) + ';';
              QueryTpn.SQL.Text := Requete;
              QueryTpn.ExecSQL();
            finally
              FreeAndNil(QueryTpn);
            end;
          except
            on e : Exception do
            begin
              FTransactionTpn.Rollback();
              Result := 8203;
              DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
              if not (Trim(Requete) = '') then
                DoLogMultiLine('  requete : ' + Requete, logDebug);
              Exit;
            end;
          end;

          Ret := CopieTable(Magasin,
                            'TStock', ['StkMagId', 'StkModId', 'StkTgfId', 'StkCouId'], 0, 0, erl_ReInitialisation,
                            DoArt, true, false, false, DoNull, false);
          case Ret of
            ers_Succeded :
              begin
                FTransactionTpn.Commit();
              end;
            ers_Interrupted :
              begin
                FTransactionTpn.Commit();
                Result := 96;
                Exit;
              end;
            ers_Failed :
              begin
                FTransactionTpn.Rollback();
                Result := 8204;
                Exit;
              end;
          end;
        end;
      end;

      // si on arrive ici :
      Result := 0;
    except
      on e : Exception do
      begin
        Result := 8202;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      end;
    end;

    if Result = 0 then
      DoLogMultiLine('Fin', logInfo, true);
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

function TTraitement.DoValideStock(OK : boolean) : boolean;
var
  QueryTpn : TMyQuery;
  Requete : string;
begin
  Result := false;
  Requete := '';

  DoLogMultiLine('TTraitement.DoValideStock', logTrace);

  try
    try
      FTransactionTpn.StartTransaction();
      QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
      try
        Requete := 'insert into TverificationStocks (VstTimestamp, VstStatut, VstKVersion) values (Current_Timestamp, ' + QuotedStr(IfThen(OK, 'OK', 'KO')) + ', GEN_ID(GenMdf, 0));';
        QueryTpn.SQL.Text := Requete;
        QueryTpn.ExecSQL();
        FTransactionTpn.Commit();
      finally
        QueryTpn.Free;
      end;
    except
      FTransactionTpn.Rollback();
      raise
    end;

    // si on arrive ici ...
    Result := true;
  except
    on e : Exception do
    begin
      Result := false;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

// Exist il des données d'import ?

function TTraitement.HasDonneesImport(TmpConn : TMyConnection; TmpTrans : TMyTransaction) : boolean;
var
  QueryTpn : TMyQuery;
begin
  Result := false;

  try
    TmpTrans.StartTransaction();

    try
      QueryTpn := GetNewQuery(TmpConn, TmpTrans);

      // verif d'existance d'element d'import
      QueryTpn.SQL.Text := 'select count(*) as nb from TReception_Entete where Sens = 1;';
      try
        QueryTpn.Open();
        if not QueryTpn.Eof then
        begin
          if not (QueryTpn.FieldByName('nb').AsInteger = 0) then
          begin
            Result := true;
            Exit;
          end;
        end;
      finally
        QueryTpn.Close();
      end;
      QueryTpn.SQL.Text := 'select count(*) as nb from TRetour_Entete where Sens = 1;';
      try
        QueryTpn.Open();
        if not QueryTpn.Eof then
        begin
          if not (QueryTpn.FieldByName('nb').AsInteger = 0) then
          begin
            Result := true;
            Exit;
          end;
        end;
      finally
        QueryTpn.Close();
      end;
      QueryTpn.SQL.Text := 'select count(*) as nb from TAch_Entete;';
      try
        QueryTpn.Open();
        if not QueryTpn.Eof then
        begin
          if not (QueryTpn.FieldByName('nb').AsInteger = 0) then
          begin
            Result := true;
            Exit;
          end;
        end;
      finally
        QueryTpn.Close();
      end;
    finally
      FreeAndNil(QueryTpn);
    end;
  finally
    TmpTrans.Rollback();
  end;
end;

// Gestion de la base !

function TTraitement.ActivationTrigger(Active : boolean) : boolean;
var
  tmpConnexionTpn : TMyConnection;
  tmpTransactionTpn : TMyTransaction;
  tmpQueryTpn : TMyQuery;
  Requete : string;
begin
  Result := false;
  try
    tmpConnexionTpn := GetNewConnexion(FNomBaseTampon, DATABASE_USER_ADM, DATABASE_PASSWORD_ADM, false);
    tmpTransactionTpn := GetNewTransaction(tmpConnexionTpn, false);
    tmpQueryTpn := GetNewQuery(tmpConnexionTpn, tmpTransactionTpn);

    tmpConnexionTpn.Open();
    tmpTransactionTpn.StartTransaction();
    try
      Requete  := 'select rdb$trigger_name as name from rdb$triggers where ((rdb$system_flag = 0) or (rdb$system_flag is null)) and rtrim(rdb$trigger_name) like ''T%_BU'' order by rdb$trigger_name;';
      tmpQueryTpn.SQL.Text := Requete;
      try
        tmpQueryTpn.Open();
        while not tmpQueryTpn.Eof do
        begin
          if Active then
            Requete := 'alter trigger ' + tmpQueryTpn.FieldByName('name').AsString + ' active;'
          else
            Requete := 'alter trigger ' + tmpQueryTpn.FieldByName('name').AsString + ' inactive;';
          tmpConnexionTpn.ExecSQL(Requete);
          tmpQueryTpn.Next();
        end;
      finally
        tmpQueryTpn.Close();
      end;
      tmpTransactionTpn.Commit();
      Result := true;
    except
      on e : Exception do
      begin
        tmpTransactionTpn.Rollback();
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  finally
    FreeAndNil(tmpQueryTpn);
    FreeAndNil(tmpTransactionTpn);
    FreeAndNil(tmpConnexionTpn);
  end;
end;

function TTraitement.CreateBase() : integer;
const
  CmdFile = 'cmd.exe';
  ExeFile = 'GSEC.EXE';
  Login_Intersport = 'intersport';
  Password_Intersport = 'intersport';
var
  Reg : TRegistry;
  Res : cardinal;
  ExePath, error : string;
  tmpConnexionTpn : TMyConnection;
  tmpTransactionTpn : TMyTransaction;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  QueryTpn : TMyQuery;
  Requete : string;
//  BkpLogName : string;
//  BkpFileName : string;
//  BkpThread : TBaseBackupThread;
begin
  Result := 9101;
  FWhatIsDoing := ett_CreateBase;
  Requete := '';

  DoLogMultiLine('TTraitement.CreateBase', logTrace);

  try
    // Creation de l'utilisateur !
    // -> enfin tentative, si ca marche pas ....
    //    on considerera qu'il existe !!!
    try
      ExePath := '';
      try
        Reg := TRegistry.Create(KEY_READ);
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
        begin
          if Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', false) then
          begin
            ExePath := IncludeTrailingPathDelimiter(Reg.ReadString('ServerDirectory'));
          end;
        end;
      finally
        FreeAndNil(Reg);
      end;
      if Trim(ExePath) = '' then
        ExePath := 'C:\Embarcadera\Interbase\bin\';

      if FileExists(ExePath + ExeFile) then
      begin
        Res := ExecAndWaitProcess(error, ExePath + ExeFile, '-user sysdba -password masterkey -add ' + Login_Intersport + ' -pw ' + Password_Intersport, false, ExePath, true);
        if Res = 0 then
          DoLogMultiLine('  -> Creation d''utilisateur OK', logDebug)
        else
          DoLogMultiLine('  -> Creation d''utilisateur KO (' + IntToStr(Res) + ' : ' + error + ')', logDebug);
      end
      else
        DoLogMultiLine('  -> Creation d''utilisateur KO (' + ExeFile + ' non trouvé)', logDebug);
    except
      // on fait rien on considère qu'il existe !
    end;

    // suppression du fichier
    if FileExists(FNomBaseTampon) then
    begin
      // verification de l'existance de données d'import
      try
        tmpConnexionTpn := GetNewConnexion(FNomBaseTampon, DATABASE_USER_ADM, DATABASE_PASSWORD_ADM, false);
        tmpTransactionTpn := GetNewTransaction(tmpConnexionTpn, false);
        try
          tmpConnexionTpn.Open();

          try
            if HasDonneesImport(tmpConnexionTpn, tmpTransactionTpn) then
            begin
              DoLogMultiLine('Données d''import presente en base. Remplacement refusé.', logError);
              Result := 9103;
              Exit;
            end;
          except
            // s'il y a une erreur ici ...
            // osef !!
          end;

        finally
          tmpConnexionTpn.Close();
        end;
      finally
        FreeAndNil(tmpTransactionTpn);
        FreeAndNil(tmpConnexionTpn);
      end;

      // attente vue que l'on vien de se connecté ...
      // il faut qu'Interbase relache la base ...
      Sleep(5000);

      // TODO -obpy : sauvegarde de la base tampon ??

      if not DeleteFile(FNomBaseTampon) then
      begin
        Result := 9105;
        Exit;
      end;
    end;

    // creation + init de la base
    try
      tmpConnexionTpn := GetNewConnexion(FNomBaseTampon, DATABASE_USER_ADM, DATABASE_PASSWORD_ADM, false);
      tmpConnexionTpn.Params.Values['ExtendedMetadata'] := 'True';
      tmpConnexionTpn.Params.Values['CreateDatabase'] := 'True';
      tmpTransactionTpn := GetNewTransaction(tmpConnexionTpn, false);
      tmpConnexionTpn.Open();
      try
        tmpTransactionTpn.StartTransaction();
        try
          QueryTpn := GetNewQuery(tmpConnexionTpn, tmpTransactionTpn);
          ScriptTpn := GetNewScript(tmpConnexionTpn, tmpTransactionTpn);
          ScriptText := ScriptTpn.SQLScripts.Add();
          LoadResourceTxtFile('Structure_1', ScriptText.SQL);
          if ScriptTpn.ValidateAll() then
          begin
            if not ScriptTpn.ExecuteAll() then
            begin
              SaveScript('CreateBase_Structure_1', ScriptTpn);
              Requete := ReLaunchScriptError(ScriptTpn, QueryTpn);
            end;
          end
          else
          begin
            SaveScript('CreateBase_Structure_1', ScriptTpn);
            raise Exception.Create('Erreur a la validation du script !');
          end;
        finally
          ScriptText.SQL.Clear();
          FreeAndNil(ScriptText);
          FreeAndNil(ScriptTpn);
          FreeAndNil(QueryTpn);
        end;
        tmpTransactionTpn.Commit();
      except
        on e : Exception do
        begin
          tmpTransactionTpn.Rollback();
          Result := 9106;
          DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
          if not (Trim(Requete) = '') then
            DoLogMultiLine('  requete : ' + Requete, logDebug);
          Exit;
        end;
      end;
    finally
      FreeAndNil(tmpTransactionTpn);
      FreeAndNil(tmpConnexionTpn);
    end;

    // interstion des données de base
    try
      FTransactionTpn.StartTransaction();

      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
        ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
        ScriptText := ScriptTpn.SQLScripts.Add();
        LoadResourceTxtFile('Valeurs_1', ScriptText.SQL);
        if ScriptTpn.ValidateAll() then
        begin
          if not ScriptTpn.ExecuteAll() then
          begin
            SaveScript('CreateBase_Valeurs_1', ScriptTpn);
            Requete := ReLaunchScriptError(ScriptTpn, QueryTpn);
          end;
        end
        else
        begin
          SaveScript('CreateBase_Valeurs_1', ScriptTpn);
          raise Exception.Create('Erreur a la validation du script !');
        end;
      finally
        ScriptText.SQL.Clear();
        FreeAndNil(ScriptText);
        FreeAndNil(ScriptTpn);
        FreeAndNil(QueryTpn);
      end;

      FTransactionTpn.Commit();
    except
      on e : Exception do
      begin
        FTransactionTpn.Rollback();
        Result := 9107;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
        Exit;
      end;
    end;

    // ici mettre a jour la version de structure !
    try
      FTransactionTpn.StartTransaction();

      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
        Requete := 'insert into TBase (BasVersion, BasDate) values (1, Current_Timestamp);';
        QueryTpn.SQL.Text := Requete;
        QueryTpn.ExecSQL();
      finally
        FreeAndNil(QueryTpn);
      end;

      FTransactionTpn.Commit();
    except
      on e : Exception do
      begin
        FTransactionTpn.Rollback();
        Result := 9108;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
        Exit;
      end;
    end;

    // si on arrive ici
    // faire les mise a jour !
    Result := UpdateBase(false, 0, 0, 0, 0);
  except
    on e : Exception do
    begin
      Result := 9102;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.UpdateBase(DoTrt : boolean; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer) : integer;

  procedure SplitTrtString(TrtString : string; var TrtOrdre : string; var TrtListFields : TListeChamps);
  var
    PosSep : integer;
  begin
    // init
    TrtOrdre := '';
    SetLength(TrtListFields, 0);

    // recherche de la limite ordre et liste
    PosSep := Pos(';', TrtString);
    if PosSep > 0 then
    begin
      TrtOrdre := Copy(TrtString, 1, PosSep -1);
      System.Delete(TrtString, 1, PosSep);
      // recup de la liste
      while TrtString <> '' do
      begin
        SetLength(TrtListFields, Length(TrtListFields) +1);
        PosSep := Pos(',', TrtString);
        if PosSep > 0 then
        begin
          TrtListFields[Length(TrtListFields) -1] := Copy(TrtString, 1, PosSep -1);
          System.Delete(TrtString, 1, PosSep);
        end
        else
        begin
          TrtListFields[Length(TrtListFields) -1] := TrtString;
          TrtString := '';
        end;
      end;
    end
    else
    begin
      TrtOrdre := TrtString;
    end;
  end;

var
  Num : integer;
  ResStructName, ResValName, ResTrtName : string;
  tmpConnexionTpn : TMyConnection;
  tmpTransactionTpn : TMyTransaction;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  QueryTpn : TMyQuery;
  Requete : string;
  // nouveau traitement complementaire
  TrtListe : TStringList;
  TrtString, TrtOrdre : string;
  TrtListFields : TListeChamps;
  Magasin : TMagasin;
  DoArt : boolean;
  IdLame, IdMag : integer;
  Ret : TEnumResult;
begin
  Result := 9201;
  FWhatIsDoing := ett_UpdateBase;
  Requete := '';
  tmpConnexionTpn := nil;
  tmpTransactionTpn := nil;
  ScriptTpn := nil;
  ScriptText := nil;
  QueryTpn := nil;
  DoArt := false;
  Ret := ers_Failed;

  DoLogMultiLine('TTraitement.UpdateBase', logTrace);

  try
    try
      QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
      Requete := 'select max(BasVersion) as BasVersion from TBase;';
      QueryTpn.SQL.Text := Requete;
      try
        QueryTpn.Open();
        if QueryTpn.Eof then
          Num := 2
        else
          Num := QueryTpn.FieldByName('BasVersion').AsInteger +1;
      finally
        QueryTpn.Close();
      end;
    finally
      FreeAndNil(QueryTpn);
    end;

    ResStructName := 'Structure_' + IntToStr(Num);
    ResValName := 'Valeurs_' + IntToStr(Num);
    ResTrtName := 'Traitement_' + IntToStr(Num);

    while (FindResource(HInstance, PChar(ResStructName), RT_RCDATA) <> 0) or
          (FindResource(HInstance, PChar(ResValName), RT_RCDATA) <> 0) or
          (FindResource(HInstance, PChar(ResTrtName), RT_RCDATA) <> 0) do
    begin
{$REGION '      Passage du patch de structure '}
      if FindResource(HInstance, PChar(ResStructName), RT_RCDATA) <> 0 then
      begin
        DoLogMultiLine('  -> Fichier ' + ResStructName, logDebug);

        try
          tmpConnexionTpn := GetNewConnexion(FNomBaseTampon, DATABASE_USER_ADM, DATABASE_PASSWORD_ADM, false);
          tmpTransactionTpn := GetNewTransaction(tmpConnexionTpn, false);
          try
            QueryTpn := GetNewQuery(tmpConnexionTpn, tmpTransactionTpn);
            ScriptTpn := GetNewScript(tmpConnexionTpn, tmpTransactionTpn);
            ScriptText := ScriptTpn.SQLScripts.Add();
            try
              tmpConnexionTpn.Open();
              tmpTransactionTpn.StartTransaction();
              LoadResourceTxtFile(ResStructName, ScriptText.SQL);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript('UpdateBase_' + ResStructName, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpn);
                end;
              end
              else
              begin
                SaveScript('UpdateBase_' + ResStructName, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              tmpTransactionTpn.Commit();
            except
              on e : Exception do
              begin
                tmpTransactionTpn.Rollback();
                Result := 9203;
                DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
                Requete := ReLaunchScriptError(ScriptTpn, nil);
                if not (Trim(Requete) = '') then
                  DoLogMultiLine('  requete : ' + Requete, logDebug);
                Exit;
              end;
            end;
          finally
            ScriptText.SQL.Clear();
            FreeAndNil(ScriptText);
            FreeAndNil(ScriptTpn);
            FreeAndNil(QueryTpn);
          end;
        finally
          FreeAndNil(tmpTransactionTpn);
          FreeAndNil(tmpConnexionTpn);
        end;
      end;
{$ENDREGION}

      try
{$REGION '        Desactivation des triggers '}
        if not ActivationTrigger(false) then
        begin
          Result := 9204;
          Exit;
        end;
{$ENDREGION}

{$REGION '        Passage du patch de valeur '}
        if FindResource(HInstance, PChar(ResValName), RT_RCDATA) <> 0 then
        begin
          DoLogMultiLine('  -> Fichier ' + ResValName, logDebug);

          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
            ScriptText := ScriptTpn.SQLScripts.Add();
            try
              FTransactionTpn.StartTransaction();
              LoadResourceTxtFile(ResValName, ScriptText.SQL);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript('UpdateBase_' + ResValName, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpn);
                end;
              end
              else
              begin
                SaveScript('UpdateBase_' + ResValName, ScriptTpn);
                raise Exception.Create('Erreur a la validation du script !');
              end;
              FTransactionTpn.Commit();
            except
              on e : Exception do
              begin
                FTransactionTpn.Rollback();
                Result := 9205;
                DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
                if not (Trim(Requete) = '') then
                  DoLogMultiLine('  requete : ' + Requete, logDebug);
                Exit;
              end;
            end;
          finally
            ScriptText.SQL.Clear();
            FreeAndNil(ScriptText);
            FreeAndNil(ScriptTpn);
            FreeAndNil(QueryTpn);
          end;
        end;
{$ENDREGION}

{$REGION '        Passage du script de traitement '}
        if DoTrt and (FindResource(HInstance, PChar(ResTrtName), RT_RCDATA) <> 0) then
        begin
          DoLogMultiLine('  -> Fichier ' + ResTrtName, logDebug);

          try
            TrtListe := TStringList.Create();
            LoadResourceTxtFile(ResTrtName, TrtListe);
            for TrtString in TrtListe do
            begin
              if not (Trim(TrtString) = '') then
              begin
                IdLame := -1;
                IdMag := -1;

                try
                  SplitTrtString(TrtString, TrtOrdre, TrtListFields);
                  FTransactionTpn.StartTransaction();
                  case IndexText(TrtOrdre, ['TMagasin',
                                            'TExerciceCom', 'TCollection',
                                            'TFournisseur', 'TArticle', 'TArticleCol',
                                            'TVente_Entete', 'TVente_Ligne', 'TVente_Encaissement',
                                            'TFacture_Entete', 'TFacture_Ligne',
                                            'TMVT_Entete', 'TMVT_Ligne',
                                            'TCommandeStatut',
                                            'TReception_Entete', 'TReception_Ligne', 'TReception_TVA',
                                            'TRetour_Entete', 'TRetour_Ligne', 'TRetour_TVA']) of
                    00 : Ret := CopieTable('TMagasin', ['MagId'], 0, 0, erl_None, false, false, true, false, FDoNull, false, TrtListFields);
                    01 : Ret := CopieTable('TExerciceCom', ['ExeId'], 0, 0, erl_None, false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    02 : Ret := CopieTable('TCollection', ['ColId'], 0, 0, erl_None, false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    03 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TFournisseur', ['FouId'], FDateMinRap, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    04 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TArticle', ['ModId', 'TgfId', 'CouId'], FDateMinArt, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    05 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TArticleCol', ['ModId', 'ColId'], FDateMinArt, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    06 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                              'TVENTE_ENTETE', ['TkeId'], FDateMinVte, FDateMax, erl_ReExport,
                                              false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    07 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                              'TVENTE_LIGNE', ['TklId'], FDateMinVte, FDateMax, erl_ReExport,
                                              DoArt, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    08 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                              'TVENTE_ENCAISSEMENT', ['EncId'], FDateMinVte, FDateMax, erl_ReExport,
                                              false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    09 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                              'TFACTURE_ENTETE', ['FceId'], FDateMinVte, FDateMax, erl_ReExport,
                                              false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    10 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                              'TFACTURE_LIGNE', ['FclId'], FDateMinVte, FDateMax, erl_ReExport,
                                              DoArt, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    11 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, IdMag,
                                              'TMVT_ENTETE', ['MagId', 'MvtId'], FDateMinMvt, FDateMax, erl_ReExport,
                                              false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    12 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, IdMag,
                                              'TMVT_LIGNE', ['MagId', 'MvtId', 'MvlId'], FDateMinMvt, FDateMax, erl_ReExport,
                                              DoArt, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    13 :
                      begin
                        for Magasin in FListMag do
                          if Magasin.Actif then
                          begin
                            Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                              'TCOMMANDESTATUT', ['CmdBllId', 'CmdBlhId'], FDateMinCmd, FDateMax, erl_ReExport,
                                              DoArt, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                            if not (Ret = ers_Succeded) then
                              Break;
                          end;
                      end;
                    14 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TRECEPTION_ENTETE', ['BreId', 'Sens'], FDateMinRap, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    15 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TRECEPTION_LIGNE', ['BrlId', 'Sens'], FDateMinRap, FDateMax, erl_ReExport,
                                           DoArt, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    16 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TRECEPTION_TVA', ['BreId', 'Sens', 'BreTaux'], FDateMinRap, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    17 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TRETOUR_ENTETE', ['RetId', 'Sens'], FDateMinRap, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    18 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TRETOUR_LIGNE', ['RelId', 'Sens'], FDateMinRap, FDateMax, erl_ReExport,
                                           DoArt, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    19 : Ret := CopieTable(LamePlageDeb, LamePlageFin, IdLame, MagPlageDeb, MagPlageFin, IdMag,
                                           'TRETOUR_TVA', ['RetId', 'Sens', 'BreTaux'], FDateMinRap, FDateMax, erl_ReExport,
                                           false, Length(TrtListFields) = 0, true, false, FDoNull, false, TrtListFields);
                    else
                      begin
                        FTransactionTpn.Rollback();
                        Result := 9207;
                        Exit;
                      end;
                  end;

                  // gestion du ret ici !!
                  if Ret = ers_Succeded then
                    FTransactionTpn.Commit()
                  else
                  begin
                    FTransactionTpn.Rollback();
                    Result := 9206;
                    Exit;
                  end;
                finally
                  SetLength(TrtListFields, 0);
                end;
              end;
            end;
          finally
            FreeAndNil(TrtListe);
          end;
        end;
{$ENDREGION}

      finally
{$REGION '        Réactivation des triggers '}
        if not ActivationTrigger(True) then
          Result := 9208;
{$ENDREGION}
      end;
      if Result = 9208 then
        Exit;

      // ici mettre a jour la version de structure !
      try
        FTransactionTpn.StartTransaction();

        try
          QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
          Requete := 'insert into TBase (BasVersion, BasDate) values (' + IntToStr(Num) + ', Current_Timestamp);';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
        finally
          FreeAndNil(QueryTpn);
        end;

        FTransactionTpn.Commit();
      except
        on e : Exception do
        begin
          FTransactionTpn.Rollback();
          Result := 9209;
          DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
          if not (Trim(Requete) = '') then
            DoLogMultiLine('  requete : ' + Requete, logDebug);
          Exit;
        end;
      end;

      // resource suivante ??
      Inc(Num);
      ResStructName := 'Structure_' + IntToStr(Num);
      ResValName := 'Valeurs_' + IntToStr(Num);
      ResTrtName := 'Traitement_' + IntToStr(Num);
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      Result := 9202;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.ClearBase() : integer;
var
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  QueryTpn : TMyQuery;
  Requete : string;
begin
  Result := 9301;
  FWhatIsDoing := ett_ClearBase;

  ScriptTpn := nil;

  DoLogMultiLine('TTraitement.ClearBase', logTrace);

  // verification de l'existance de données d'impirt
  if HasDonneesImport(FConnexionTpn, FTransactionTpn) then
  begin
    DoLogMultiLine('Données d''import presente e base. Nettoyage refusé.', logError);
    Result := 9303;
    Exit;
  end;

  try
    try
      FTransactionTpn.StartTransaction();
      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
        ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
        ScriptText := ScriptTpn.SQLScripts.Add();

        // nettoyage effectif
        LoadResourceTxtFile('Nettoyage', ScriptText.SQL);
        if ScriptTpn.ValidateAll() then
        begin
          if not ScriptTpn.ExecuteAll() then
          begin
            SaveScript('ClearBase', ScriptTpn);
            Requete := ReLaunchScriptError(ScriptTpn, QueryTpn);
          end;
        end
        else
        begin
          SaveScript('ClearBase', ScriptTpn);
          raise Exception.Create('Erreur a la validation du script !');
        end;
      finally
        ScriptText.SQL.Clear();
        FreeAndNil(ScriptText);
        FreeAndNil(ScriptTpn);
        FreeAndNil(QueryTpn);
      end;
      FTransactionTpn.Commit();
    except
      on e : Exception do
      begin
        FTransactionTpn.Rollback();
        Result := 9304;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
        Exit;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      Result := 9302;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.DoPurges(ListeMagasins : TListMagasin) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  tmpLogMdl : string;
  Requete : string;
begin
  Result := 9401;
  FWhatIsDoing := ett_Purge;

  QueryTpn := nil;

  DoLogMultiLine('TTraitement.DoPurges', logTrace);

  tmpLogMdl := FLogMdl;
  try
    // modification des param du log
    FLogMdl := 'Purge';
    DoLogMultiLine('Début', logNotice, true);

    try
      FTransactionTpn.StartTransaction();
      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
        for Magasin in ListeMagasins do
        begin
          // tables du BI
          Requete := 'delete from TVENTE_ENTETE where tkedate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinVte)) + ' and magid = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TFACTURE_ENTETE where fcedate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinVte)) + ' and magid = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TMVT_ENTETE where mvtdate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and magid = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();

          // tables de CrossCanal
          Requete := 'delete from TCOMMANDESTATUT where CmdDateCmd < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinCmd)) + ' and CmdMagId = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();

          // tables du rapprochement auto
          Requete := 'delete from TRECEPTION_ENTETE where BreDate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinRap)) + ' and MagId = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TRETOUR_ENTETE where RetDate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinRap)) + ' and MagId = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TACH_ENTETE where RpeDateFact < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinRap)) + ' and MagId = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := '';
        end;
      finally
        FreeAndNil(QueryTpn);
      end;

      // si on arrive ici :
      FTransactionTpn.Commit();
      Result := 0;
    except
      on e : Exception do
      begin
        FTransactionTpn.Rollback();
        Result := 9402;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  finally
    // reinit des param du log
    FLogMdl := tmpLogMdl;
  end;
end;

// Enregistrement dans HistoEvent !

procedure TTraitement.DoHistoEvent(Start, Reset : boolean; Resultat : integer);
var
  Requete, StrDateRst : string;
  QueryGnk : TMyQuery;
  IdBase, IdEvent : integer;
  TimeReset : TTime;
begin
  Requete := '';
  StrDateRst := '';
  QueryGnk := nil;
  IdBase := 0;
  TimeReset := 0;

  DoLogMultiLine('TTraitement.DoHistoEvent', logTrace);

  try
    FTransactionGnk.StartTransaction();
    try
      QueryGnk := GetNewQuery(FConnexionGnk, FTransactionGnk);
      // recup du bas id
      Requete := 'select bas_id '
               + 'from genparambase '
               + 'join genbases join k on k_id = bas_id and k_enabled = 1 on bas_ident = par_string '
               + 'where par_nom = ''IDGENERATEUR'';';
      DoLogMultiLine('  requete : ' + Requete, logNone);
      QueryGnk.SQL.Text := Requete;
      try
        QueryGnk.Open();
        if QueryGnk.Eof then
          raise Exception.Create('bas_id non trouver')
        else
          IdBase := QueryGnk.FieldByName('bas_id').AsInteger;
      finally
        QueryGnk.Close();
      end;

      // intervalle pour l'extraction
      Requete := 'select prm_float from genparam join k on k_id = prm_id and k_enabled = 1 where prm_type = 25 and prm_code = 3;';
      DoLogMultiLine('  requete : ' + Requete, logNone);
      QueryGnk.SQL.Text := Requete;
      try
        QueryGnk.Open();
        if QueryGnk.Eof then
          raise Exception.Create('Pas de paramètre trouver')
        else
          TimeReset := Frac(TDateTime(QueryGnk.FieldByName('prm_float').AsFloat));
      finally
        QueryGnk.Close();
      end;

      //==================================
      // Gestion du dernier traitement !
      IdEvent := 0;
      // le paramètre existe t-il ?
      Requete := 'select hev_id from genhistoevt join k on k_id = hev_id and k_enabled = 1 where hev_type = ' + CBIOK + ' and hev_basid = ' + IntToStr(IdBase) + ';';
      DoLogMultiLine('  requete : ' + Requete, logNone);
      QueryGnk.SQL.Text := Requete;
      try
        QueryGnk.Open();
        if not QueryGnk.Eof then
          IdEvent := QueryGnk.FieldByName('hev_id').AsInteger;
      finally
        QueryGnk.Close();
      end;
      if IdEvent = 0 then
      begin
        // creation !!
        Requete := 'insert into genhistoevt (hev_id, hev_date, hev_type, hev_module, hev_base, hev_result, hev_temps, hev_basid) '
                 + 'values ((select id from pr_newk(''genhistoevt'')), '                                                             // ID
                 + 'current_timestamp, '                                                                                             // date courante
                 + CBIOK + ', '                                                                                                      // type
                 + QuotedStr(IfThen(Start, '', IntToStr(Resultat))) + ', '                                                           // code de retour !
                 + QuotedStr(FConnexionGnk.Params.Database) + ', '                                                                   // chemin de base
                 + IfThen(Start, '0', IfThen(Resultat = 0, '1', '0')) + ', '                                                         // '1' si OK, '0' sinon (inconu au start)
                 + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', IfThen(Start, 0, FStartTime - Now()))) + ', '                 // Temps de traitement (inconu au start)
                 + IntToStr(IdBase) + ')';                                                                                           // lien bas_id
        DoLogMultiLine('  requete : ' + Requete, logNone);
        QueryGnk.SQL.Text := Requete;
        QueryGnk.ExecSQL();
      end
      else
      begin
        // modification !!
        Requete := 'update genhistoevt set '
                 + 'hev_date = current_timestamp, '                                                                                  // date courante
                 + 'hev_base = ' + QuotedStr(FConnexionGnk.Params.Database) + ', '                                                   // chemin de base
                 + 'hev_module = ' + QuotedStr(IfThen(Start, '', IntToStr(Resultat))) + ', '                                         // code de retour !
                 + 'hev_result = ' + IfThen(Start, '0', IfThen(Resultat = 0, '1', '0')) + ', '                                       // '1' si OK, '0' sinon (inconu au start)
                 + 'hev_temps = ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', IfThen(Start, 0, FStartTime - Now()))) + ' ' // Temps de traitement (inconu au start)
                 + 'where hev_id = ' + IntToStr(IdEvent) + ';';
        DoLogMultiLine('  requete : ' + Requete, logNone);
        QueryGnk.SQL.Text := Requete;
        QueryGnk.ExecSQL();
        Requete := 'execute procedure pr_updatek(' + IntToStr(IdEvent) + ', 0);';
        DoLogMultiLine('  requete : ' + Requete, logNone);
        QueryGnk.SQL.Text := Requete;
        QueryGnk.ExecSQL();
      end;

      //==================================
      // Gestion de la dernière reussite !
      if not Start and (Resultat = 0) then
      begin
        IdEvent := 0;
        // le paramètre existe t-il ?
        Requete := 'select hev_id from genhistoevt join k on k_id = hev_id and k_enabled = 1 where hev_type = ' + CLASTBI + ' and hev_basid = ' + IntToStr(IdBase) + ';';
        DoLogMultiLine('  requete : ' + Requete, logNone);
        QueryGnk.SQL.Text := Requete;
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            IdEvent := QueryGnk.FieldByName('hev_id').AsInteger;
        finally
          QueryGnk.Close();
        end;
        if IdEvent = 0 then
        begin
          // creation !!
          Requete := 'insert into genhistoevt (hev_id, hev_date, hev_type, hev_module, hev_base, hev_result, hev_temps, hev_basid) '
                   + 'values ((select id from pr_newk(''genhistoevt'')), '                                           // ID
                   + 'current_timestamp, '                                                                           // date courante
                   + CLASTBI + ', '                                                                                  // type
                   + QuotedStr(IntToStr(Resultat)) + ', '                                                            // code de retour !
                   + QuotedStr(FConnexionGnk.Params.Database) + ', '                                                 // chemin de base
                   + '1, '                                                                                           // '1' parce que c'est OK
                   + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', FStartTime - Now())) + ', '                 // Temps de traitement
                   + IntToStr(IdBase) + ')';                                                                         // lien bas_id
          DoLogMultiLine('  requete : ' + Requete, logNone);
          QueryGnk.SQL.Text := Requete;
          QueryGnk.ExecSQL();
        end
        else
        begin
          // modification !!
          Requete := 'update genhistoevt set '
                   + 'hev_date = current_timestamp, '                                                                // date courante
                   + 'hev_base = ' + QuotedStr(FConnexionGnk.Params.Database) + ', '                                 // chemin de base
                   + 'hev_module = ' + QuotedStr(IntToStr(Resultat)) + ', '                                          // code de retour !
                   + 'hev_result = 1, '                                                                              // '1' parce que c'est OK
                   + 'hev_temps = ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', FStartTime - Now())) + ' ' // Temps de traitement
                   + 'where hev_id = ' + IntToStr(IdEvent) + ';';
          DoLogMultiLine('  requete : ' + Requete, logNone);
          QueryGnk.SQL.Text := Requete;
          QueryGnk.ExecSQL();
          Requete := 'execute procedure pr_updatek(' + IntToStr(IdEvent) + ', 0);';
          DoLogMultiLine('  requete : ' + Requete, logNone);
          QueryGnk.SQL.Text := Requete;
          QueryGnk.ExecSQL();
        end;
      end;

      //==================================
      // Gestion du reset de stock !
      if Reset then
      begin
        IdEvent := 0;
        StrDateRst := IfThen(Frac(Now()) >= TimeReset, 'current_timestamp', QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', IncMinute(StartOfTheDay(Now()), -1))));
        // le paramètre existe t-il ?
        Requete := 'select hev_id from genhistoevt join k on k_id = hev_id and k_enabled = 1 where hev_type = ' + CLASTRS + ' and hev_basid = ' + IntToStr(IdBase) + ';';
        DoLogMultiLine('  requete : ' + Requete, logNone);
        QueryGnk.SQL.Text := Requete;
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            IdEvent := QueryGnk.FieldByName('hev_id').AsInteger;
        finally
          QueryGnk.Close();
        end;
        if IdEvent = 0 then
        begin
          // creation !!
          Requete := 'insert into genhistoevt (hev_id, hev_date, hev_type, hev_module, hev_base, hev_result, hev_temps, hev_basid) '
                   + 'values ((select id from pr_newk(''genhistoevt'')), '                                                             // ID
                   + StrDateRst + ', '                                                                                                 // date du reset, avec gestion des init !
                   + CLASTRS + ', '                                                                                                    // type
                   + QuotedStr(IfThen(Start, '', IntToStr(Resultat))) + ', '                                                           // code de retour !
                   + QuotedStr(FConnexionGnk.Params.Database) + ', '                                                                   // chemin de base
                   + IfThen(Start, '0', IfThen(Resultat = 0, '1', '0')) + ', '                                                         // '1' si OK, '0' sinon (inconu au start)
                   + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', IfThen(Start, 0, FStartTime - Now()))) + ', '                 // Temps de traitement (inconu au start)
                   + IntToStr(IdBase) + ')';                                                                                           // lien bas_id
          DoLogMultiLine('  requete : ' + Requete, logNone);
          QueryGnk.SQL.Text := Requete;
          QueryGnk.ExecSQL();
        end
        else
        begin
          // modification !!
          Requete := 'update genhistoevt set '
                   + 'hev_date = ' + StrDateRst + ', '                                                                                 // date du reset, avec gestion des init !
                   + 'hev_base = ' + QuotedStr(FConnexionGnk.Params.Database) + ', '                                                   // chemin de base
                   + 'hev_module = ' + QuotedStr(IfThen(Start, '', IntToStr(Resultat))) + ', '                                         // code de retour !
                   + 'hev_result = ' + IfThen(Start, '0', IfThen(Resultat = 0, '1', '0')) + ', '                                       // '1' si OK, '0' sinon (inconu au start)
                   + 'hev_temps = ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', IfThen(Start, 0, FStartTime - Now()))) + ' ' // Temps de traitement (inconu au start)
                   + 'where hev_id = ' + IntToStr(IdEvent) + ';';
          DoLogMultiLine('  requete : ' + Requete, logNone);
          QueryGnk.SQL.Text := Requete;
          QueryGnk.ExecSQL();
          Requete := 'execute procedure pr_updatek(' + IntToStr(IdEvent) + ', 0);';
          DoLogMultiLine('  requete : ' + Requete, logNone);
          QueryGnk.SQL.Text := Requete;
          QueryGnk.ExecSQL();
        end;
      end;
    finally
      FreeAndNil(QueryGnk);
    end;
    FTransactionGnk.Commit();
  except
    on e : Exception do
    begin
      FTransactionGnk.Rollback();
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logWarning);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

// point d'entré

procedure TTraitement.Execute();
var
  tmpTraitement : TEnumTypeTraitement;
  ListeLastId : TListLastIDs;
  LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, tmpRes, i : integer;
  LvlReinit : TReInitLvl;
begin
  ReturnValue := 1101;
  FWhatIsDoing := ett_None;
  ListeLastId := nil;
  LamePlageDeb := 0;
  LamePlageFin := 0;
  MagPlageDeb := 0;
  MagPlageFin := 0;

  if (ett_ReInitialisation in FWhatToDo) then
    LvlReinit := erl_ReInitialisation
  else if (ett_ReExport in FWhatToDo) then
    LvlReinit := erl_ReExport
  else if (ett_ReMouvement in FWhatToDo) then
    LvlReinit := erl_ReMouvement
  else
    LvlReinit := erl_None;

  try
    CoInitialize(nil);

    DoLogMultiLine('TTraitement.DoTraitement', logTrace);
    DoLogMultiLine('WhatToDo : ', logDebug);
    for tmpTraitement in FWhatToDo do
      DoLogMultiLine('         - ' + GetEnumName(TypeInfo(TEnumTypeTraitement), Ord(tmpTraitement)), logDebug);

    try
      FConnexionGnk.Open();
    except
      on e : Exception do
      begin
        ReturnValue := 1103;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logEmergency);
        Exit;
      end;
    end;

    try
      //==================================================
      // recup des plages !
      if not GetPlages(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin) then
      begin
        ReturnValue := 1104;
        Exit;
      end;

      //==================================================
      // gestion de l'histoEvent
      DoHistoEvent(true, (ett_ResetStock in FWhatToDo), ReturnValue);

      //==================================================
      // Logs des informations
      if (ett_LogForce in FWhatToDo) then
      begin
        FWhatIsDoing := ett_LogForce;
        DoLogInfosUtils();
      end;

      //==================================================
      // Attente ... pour test (2h)
      if (ett_ForceSleep in FWhatToDo) then
      begin
        FWhatIsDoing := ett_ForceSleep;
        Sleep(7200000);
        ReturnValue := 0;
      end
      else if (ett_DoSleep in FWhatToDo) then
      begin
        FWhatIsDoing := ett_DoSleep;
        for i := 0 to 120 do
        begin
          if Terminated then
            Break;
          Sleep(60000);
        end;
        ReturnValue := 0;
      end
      //==================================================
      // creation de la base !
      else if (ett_CreateBase in FWhatToDo) then
      begin
        ReturnValue := CreateBase();
      end
      //==================================================
      // Autres traitement ?
      else
      begin
        try
          FConnexionTpn.Open();
        except
          on e : Exception do
          begin
            DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
            ReturnValue := 1105;
            Exit;
          end;
        end;

        try
          try
            try
              //==================================================
              // recup des ID !
              ListeLastId := TListLastIDs.Create([doOwnsValues]);
              if not GetListLastID(ListeLastId) then
              begin
                ReturnValue := 1105;
                Exit;
              end;

              //==================================================
              // Mise a jour de la base
              if not Terminated and (ett_UpdateBase in FWhatToDo) then
              begin
                tmpRes := UpdateBase(true, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin);
                if not (tmpRes = 0) then
                begin
                  ReturnValue := tmpRes;
                  Exit;
                end;
              end;

              //==================================================
              // nettoyage de la base !!
              if (ett_ClearBase in FWhatToDo) then
                ReturnValue := ClearBase()
              else
              begin
                //==================================================
                // Traitement Commun

                // gestion des magasin
                if not Terminated and (ett_GestionMagasins in FWhatToDo) then
                begin
                  tmpRes := DoExportMagasins(FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion des exercices
                if not Terminated and (ett_GestionExercices in FWhatToDo) then
                begin
                  tmpRes := DoExportExercices(LvlReinit, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion des collections
                if not Terminated and (ett_GestionCollections in FWhatToDo) then
                begin
                  tmpRes := DoExportCollections(LvlReinit, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction des fournisseurs !
                if not Terminated and (ett_GestionFournisseurs in FWhatToDo) then
                begin
                  tmpRes := DoExportFournisseurs(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;

                //==================================================
                // Purges ...

                if not Terminated and (ett_Purge in FWhatToDo) then
                begin
                  tmpRes := DoPurges(FListMag);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;

                //==================================================
                // Gestion des extraction complete

                // gestion de l'extraction des articles !
                if not Terminated and (ett_CompletArticles in FWhatToDo) then
                begin
                  tmpRes := DoExportArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction complete des informations BI !
                if not Terminated and (([ett_CompletTickets, ett_CompletFactures, ett_CompletMouvements] * FWhatToDo) <> []) then
                begin
                  tmpRes := DoExportBI(FListMag, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, true, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction complete des informations CrossCanal !
                if not Terminated and (ett_CompletCommandes in FWhatToDo) then
                begin
                  tmpRes := DoExportCrossCanal(FListMag, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, true, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction complete des informations RapproAuto !
                if not Terminated and (([ett_CompletReceptions, ett_CompletRetours] * FWhatToDo) <> []) then
                begin
                  tmpRes := DoExportRapproAuto(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, true, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;

                //==================================================
                // Gestion des deltas !

                // gestion de l'extraction des articles !
                if not Terminated and (ett_DeltaArticles in FWhatToDo) then
                begin
                  tmpRes := DoDeltaArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, LvlReinit, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction du delta des informations BI !
                if not Terminated and (([ett_DeltaTickets, ett_DeltaFactures, ett_DeltaMouvements] * FWhatToDo) <> []) then
                begin
                  tmpRes := DoDeltaBI(FListMag, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction du delta des informations CrossCanal !
                if not Terminated and (ett_DeltaCommandes in FWhatToDo) then
                begin
                  tmpRes := DoDeltaCrossCanal(FListMag, LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;
                // gestion de l'extraction du delta des informations RapproAuto !
                if not Terminated and (([ett_DeltaReceptions, ett_DeltaRetours] * FWhatToDo) <> []) then
                begin
                  tmpRes := DoDeltaRapproAuto(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin, ListeLastId, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;

                //==================================================
                // hitorique des stock !
                if not Terminated and (ett_HistoStock in FWhatToDo) then
                begin
                  tmpRes := DoHistoStock(FListMag, true, FDoNull);
                  if not (tmpRes = 0) then
                  begin
                    ReturnValue := tmpRes;
                    Exit;
                  end;
                end;

                //==================================================
                // MAJ de l'image du stock !
                if not Terminated and (ett_ResetStock in FWhatToDo) then
                begin
                  tmpRes := DoResetStock(FListMag, true, FDoNull);
                  if (tmpRes = 0) then
                  begin
                    if not DoValideStock(true) then
                    begin
                      ReturnValue := 8206;
                      Exit;
                    end;
                  end
                  else
                  begin
                    ReturnValue := tmpRes;
                    DoValideStock(false);
                    Exit;
                  end;
                end;

                // si on arrive ici :
                ReturnValue := 0;
              end;
            finally
              FreeAndNil(ListeLastId);
            end;
          except
            on e : Exception do
            begin
              ReturnValue := 1102;
              DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
            end;
          end;
        finally
          FConnexionTpn.Close();
        end;
      end;
    finally
      DoHistoEvent(false, (ett_ResetStock in FWhatToDo), ReturnValue);
      FConnexionGnk.Close();
    end;
  finally
    CoUninitialize();
  end;
end;

// Contructeur/Destructeur

constructor TTraitement.Create(FctTerminate: TNotifyEvent; StdStream : TStdStream;
                               BaseGin, BaseTpn, LogDos, LogMdl, LogRef, LogKey : string;
                               DateMinVte, DateMinMvt, DateMinCmd, DateMinRap, DateMinStk : TDate;
                               LogInterval : integer;
                               ListMag : TListMagasin;
                               WhatToDo : TSetTraitementTodo; NbDaysReMouvement : integer;
                               DoNull : boolean;
                               DoErrArt : boolean;
                               CreateSuspended: Boolean);
var
  i : integer;
begin
  Inherited Create(CreateSuspended);
  OnTerminate := FctTerminate;
  FreeOnTerminate := true;
  StdStream := StdStream;
  // logs
  FLogDos := LogDos;
  FLogMdl := LogMdl;
  FLogRef := LogRef;
  FLogKey := LogKey;
  FListMag := ListMag;
  log.Doss := LogDos;
  Log.Frequence := LogInterval;
  // premier log utils
  DoLogMultiLine('TTraitement.Create', logTrace);
  DoLogMultiLine('Début', logNotice, true);
  // connexion a la source
  FConnexionGnk := GetNewConnexion(BaseGin, DATABASE_USER_GNK, DATABASE_PASSWORD_GNK, false);
  FConnexionGnk.FetchOptions.Unidirectional := true;
  FCOnnexionGnk.UpdateOptions.ReadOnly := true;
  FConnexionGnk.FetchOptions.RowsetSize := 500;
  FTransactionGnk := GetNewTransaction(FConnexionGnk, false);
  FTransactionGnk.Options.Isolation := xiSnapshot;
  // connexion a la destination
  FNomBaseTampon := BaseTpn;
  FConnexionTpn := GetNewConnexion(FNomBaseTampon, DATABASE_USER_TPN, DATABASE_PASSWORD_TPN, false);
  FConnexionTpn.FetchOptions.Unidirectional := true;
  FConnexionTpn.UpdateOptions.ReadOnly := true;
  FConnexionTpn.FetchOptions.RowsetSize := 500;
  FTransactionTpn := GetNewTransaction(FConnexionTpn, false);
  // traitement a faire
  FWhatToDo := WhatToDo;
  // Histo
  FStartTime := Now();
  // date minimum d'export
  FDateMinVte := DateMinVte;
  FDateMinMvt := DateMinMvt;
  FDateMinCmd := DateMinCmd;
  FDateMinRap := DateMinRap;
  FDateMinStk := DateMinStk;
  FDateMinArt := Min(Min(Min(Min(DateMinVte, DateMinMvt), DateMinCmd), DateMinRap), DateMinStk);
  if (ett_ReMouvement in FWhatToDo) and (NbDaysReMouvement > 0) then
    FDateMax := IncDay(FDateMinArt, NbDaysReMouvement)
  else
    FDateMax := Date();
  // champs a ne pas prendre en compte
  SetLength(FFieldToIgnore, Length(FIELDS_KVERSION) + Length(FIELD_KENABLED));
  for i := 0 to Length(FIELDS_KVERSION) -1 do
    FFieldToIgnore[i] := FIELDS_KVERSION[i];
  for i := 0 to Length(FIELD_KENABLED) -1 do
    FFieldToIgnore[Length(FIELDS_KVERSION) + i] := FIELD_KENABLED[i];
  // options
  FDoNull := DoNull;
  FDoErrArt := DoErrArt;
end;

destructor TTraitement.Destroy();
begin
  // informations
  if ReturnValue = 0 then
    DoLogMultiLine('Fin', logInfo, true);
  DoLogMultiLine('TTraitement.Destroy (Resultat : "' + IntToStr(ReturnValue) + '"; Durée : "' + GetIntervalText(FStartTime, Now()) + '")', logTrace);
  // liberation !
  SetLength(FFieldToIgnore, 0);
  FreeAndNil(FConnexionGnk);
  FreeAndNil(FConnexionTpn);
  FreeAndNil(FTransactionGnk);
  FreeAndNil(FTransactionTpn);
  // Inherited
  Inherited Destroy();
end;

procedure TTraitement.Terminate();
begin
  DoLogMultiLine('TTraitement.Terminate', logDebug);
  inherited Terminate();
end;

end.

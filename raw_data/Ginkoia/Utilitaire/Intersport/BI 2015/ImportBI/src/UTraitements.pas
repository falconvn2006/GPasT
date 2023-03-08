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
  uImportRapprochement;

const
  // Acces DB
  DATABASE_USER_ADM = 'sysdba';
  DATABASE_PASSWORD_ADM = 'masterkey';
  DATABASE_USER_GNK = 'sysdba';
  DATABASE_PASSWORD_GNK = 'masterkey';
  DATABASE_USER_TPN = 'ginkoia';
  DATABASE_PASSWORD_TPN = 'ginkoia';
  // taille des scripts
  CST_MAX_ITEMS_SCRIPT = 50000;

type
  TEnumTypeTraitement = (ett_ImportRapprochement,
                         ett_LogForce,
                         ett_DoSleep, ett_ForceSleep);
  TSetTraitementTodo = set of TEnumTypeTraitement;

type
  TEnumResult = (ers_Succeded, ers_Interrupted, ers_Failed);

type
  TListLastIDs = TObjectDictionary<integer, TDictionary<string, integer>>;

type
  TTraitement = class(TThread)
  protected
    FStartTime : TDateTime;
    FLogDos, FLogMdl, FLogRef, FLogMag, FLogKey : string;
    FListMag : TListMagasin;
    FDateMinMvt, FDateMinStk : TDate;

    FNomBaseTampon : string;
    FConnexionGnk, FConnexionTpn : TMyConnection;
    FTransactionGnk, FTransactionTpn : TMyTransaction;
    FWhatToDo : TSetTraitementTodo;
    FDoNull : boolean;

    FFieldToIgnore : array of string;

    FImportRapprochement : TImportRapprochement;

    procedure LoadScriptSQL(Nom : string; Liste : TStrings);
    procedure DecodePlage(S: string; var Deb, fin: integer);
    function GetFieldData(FieldSrc : TField; DoNull : boolean) : string;
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
    function GetIdentArticle(ModId, TgfId, CouId : integer) : string;
    function GetInsertRequete(Query : TMyQuery; NomTable : string; DoNull : boolean) : string;
    function GetUpdateRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;
    function GetInsertMajRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
    function GetInsertDelRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; FieldDiff, NomCle : array of string; DoNull : boolean) : string;
    function GetDeleteRequete(QuerySrc : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;

    function GetLastVersion(MagId : integer; Name : string; ListeLastId : TListLastIDs) : integer;
    function SetLastVersion(MagId : integer; Name : string; Value : integer; ListeLastId : TListLastIDs) : string;

    function ReLaunchScriptError(Script : TMyScript; Query : TMyQuery) : string;
    procedure SaveScript(Libelle : string; Scripts : TMyScript);

    function DoGestionArticle(QueryGnk, QueryTpn, QueryMaj : TMyQuery; ModId, TgfId, CouId : integer; DoMaj, DoNull : boolean) : boolean;

    function CopieTable(Magasin : TMagasin;
                        LamePlageDeb, LamePlageFin : integer; var LameLastID : integer;
                        MagPlageDeb, MagPlageFin : integer; var MagLastId : integer;
                        NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean = false) : TEnumResult; overload;
    function CopieTable(LamePlageDeb, LamePlageFin : integer; var LameLastID : integer;
                        MagPlageDeb, MagPlageFin : integer; var MagLastId : integer;
                        NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean = false) : TEnumResult; overload;
    function CopieTable(Magasin : TMagasin; var LastID : integer; NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean = false) : TEnumResult; overload;
    function CopieTable(Magasin : TMagasin; NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean = false) : TEnumResult; overload;
    function CopieTable(NomTable : string; NomCle : array of string; DateMin, DateMax : TDate;
                        DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean = false) : TEnumResult; overload;

    function DoExportMagasins(DoDel, DoNull : boolean) : integer;
    function DoExportArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoNull : boolean) : integer;

    function DoExportTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
    function DoExportFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
    function DoExportMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
    function DoExportCommande(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
    function DoExportReception(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
    function DoExportRetour(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;


    function DoDeltaTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaCommande(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaReception(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
    function DoDeltaRetour(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;


    function DoHistoStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
    function DoResetStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
    function DoValideStock(OK : boolean) : boolean;

    function CreateBase() : integer;
    function UpdateBase() : integer;
    function ClearBase() : integer;
    function DoPurges(ListeMagasins : TListMagasin) : integer;

    procedure DoHistoEvent(Start, Reset : boolean; Resultat : integer);

    procedure Execute(); override;
  public
    constructor Create(FctTerminate: TNotifyEvent;
                       BaseGin, BaseTpn, LogDos, LogMdl, LogRef, LogKey : string;
                       DateMinMvt, DateMinStk : TDate; LogInterval : integer;
                       ListMag : TListMagasin;
                       WhatToDo : TSetTraitementTodo;
                       DoNull : boolean = false;
                       CreateSuspended: Boolean = false); reintroduce;
    destructor Destroy(); override;

    procedure Terminate(); reintroduce;

    property ReturnValue;
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

{ TTraitement }

// utils

procedure TTraitement.LoadScriptSQL(Nom : string; Liste : TStrings);
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
        Log.Log(FLogMdl, FLogRef, IntToStr(FListMag[i].MagId), 'Version', ReadFileVersion('ImportBI.exe'), logInfo, true, nbSec);
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
      if AnsiIndexText(Query.Fields[i].FieldName, NomCle) >= 0 then
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

function TTraitement.GetIdentArticle(ModId, TgfId, CouId : integer) : string;
begin
  Result := 'ModId = ' + IntToStr(ModId) + ' and TgfId = ' + IntToStr(TgfId) + ' and CouId = ' + IntToStr(CouId);
end;

function TTraitement.GetInsertRequete(Query : TMyQuery; NomTable : string; DoNull : boolean) : string;
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
    if (AnsiIndexText(Query.Fields[i].FieldName, FFieldToIgnore) < 0) then
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
  Result := 'insert into ' + NomTable + ' (' + LstChamps + ') values (' + LstValeurs + ');';
end;

function TTraitement.GetUpdateRequete(QuerySrc, QueryDst : TMyQuery; NomTable : string; NomCle : array of string; DoNull : boolean) : string;
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
    if (AnsiIndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (AnsiIndexText(QuerySrc.Fields[i].FieldName, NomCle) < 0) then
      begin
        if (GetFieldData(QuerySrc.Fields[i], DoNull) <> GetFieldData(QueryDst.FieldByName(QuerySrc.Fields[i].FieldName), DoNull)) then
        begin
          if LstUpdate = '' then
            LstUpdate := QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull)
          else
            LstUpdate := LstUpdate + ', ' + QuerySrc.Fields[i].FieldName + ' = ' + GetFieldData(QuerySrc.Fields[i], DoNull);
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
    if (AnsiIndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (AnsiIndexText(QuerySrc.Fields[i].FieldName, FieldDiff) < 0) then
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
    if (AnsiIndexText(QuerySrc.Fields[i].FieldName, FFieldToIgnore) < 0) then
    begin
      if (AnsiIndexText(QuerySrc.Fields[i].FieldName, FieldDiff) < 0) then
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

function TTraitement.SetLastVersion(MagId : integer; Name : string; Value : integer; ListeLastId : TListLastIDs) : string;
begin
  if ListeLastId.ContainsKey(MagId) then
  begin
    if ListeLastId[MagId].ContainsKey(Name) then
    begin
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
    // execution de la requete pour lever l'exception !
    Query.SQL.Text := Result;
    Query.ExecSQL();
    // si on arrive ici ???
    raise Exception.Create('Unknown SQL error...');
  end;
end;

procedure TTraitement.SaveScript(Libelle : string; Scripts : TMyScript);
var
  FileDir, FileDate : string;
  i : integer;
begin
  FileDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(getApplicationFileName) + 'logs') + 'Scripts');
  FileDate := FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now());
  ForceDirectories(FileDir);
  for i := 0 to Scripts.SQLScripts.Count -1 do
    Scripts.SQLScripts[i].SQL.SaveToFile(FileDir + FileDate + '_' + Libelle + '_' + IntToStr(i) + '.sql');
end;

// gestion des article au cas par cas

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
      WhereCle := GetIdentArticle(ModId, TgfId, CouId);
      Requete := 'select * from TArticle where ' + WhereCle + ';';
      QueryTpn.SQL.Text := Requete;
      try
        QueryTpn.Open();
        if QueryTpn.Eof then
        begin
          // l'article n'existe pas ???
          // il faut le créer
          Requete := 'select * from BI15_TARTICLE_ID(' + IntToStr(ModId) + ', ' + IntToStr(TgfId) + ', ' +  IntToStr(CouId) + ');';
          QueryGnk.SQL.Text := Requete;
          try
            QueryGnk.Open();
            if not QueryGnk.Eof then
            begin
              Requete := GetInsertRequete(QueryGnk, 'TArticle', DoNull);
              DoLogMultiLine('Creation d''article : "' + WhereCle + '"', logDebug);
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
            Requete := 'select * from BI15_TARTICLE_ID(' + IntToStr(ModId) + ', ' + IntToStr(TgfId) + ', ' +  IntToStr(CouId) + ');';
            QueryGnk.SQL.Text := Requete;
            try
              QueryGnk.Open();
              if not QueryGnk.Eof then
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
              end;
            finally
              QueryGnk.Close();
            end;
          end
          else
            DoLogMultiLine('  Attention : Update skipped pour l''article "' + WhereCle + '"', logNone);
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
                                DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean) : TEnumResult;
var
  MagIdName, WhereCle, Requete : string;
  tmpLameLastID, tmpMagLastID, NbLignes : integer;
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

      if DoDel then
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
          QueryTpnMaj.Close();
          DoLogMultiLine('  -> Nettoyage', logTrace);
          Requete := 'delete from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpnMaj.SQL.Text := Requete;
          QueryTpnMaj.ExecSQL();
        end
        else
          DoLogMultiLine('  -> Pas de nettoyage, champs magid non trouvé', logTrace);
        // reinit des last ID
        tmpLameLastID := -1;
        tmpMagLastID := -1;
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

          while not (Terminated or QueryGnkLst.Eof) do
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
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end;
                  end;
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                DoLogMultiLine('  requete : ' + Requete, logNone);
                ScriptText.SQL.Add(Requete);
                Inc(NbLignes);
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
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
              if not ScriptTpn.ExecuteAll() then
              begin
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if Terminated then
            Result := ers_Interrupted
          else
            Result := ers_Succeded;
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
                                DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean) : TEnumResult;
var
  WhereCle, Requete : string;
  tmpLameLastID, tmpMagLastID, NbLignes : integer;
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

      if DoDel then
      begin
        // vidage de la table
        DoLogMultiLine('  -> Nettoyage', logTrace);
        Requete := 'delete from ' + NomTable + ';';
        QueryTpnMaj.SQL.Text := Requete;
        QueryTpnMaj.ExecSQL();
        // reinit des last ID
        tmpLameLastID := -1;
        tmpMagLastID := -1;
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

          while not (Terminated or QueryGnkLst.Eof) do
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
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end;
                  end;
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                DoLogMultiLine('  requete : ' + Requete, logNone);
                ScriptText.SQL.Add(Requete);
                Inc(NbLignes);
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
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
              if not ScriptTpn.ExecuteAll() then
              begin
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if Terminated then
            Result := ers_Interrupted
          else
            Result := ers_Succeded;
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
                                DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean) : TEnumResult;
var
  MagIdName, WhereCle, Requete : string;
  tmpLastID, NbLignes : integer;
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

      if DoDel then
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
          QueryTpnMaj.Close();
          DoLogMultiLine('  -> Nettoyage', logTrace);
          Requete := 'delete from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpnMaj.SQL.Text := Requete;
          QueryTpnMaj.ExecSQL();
        end
        else
          DoLogMultiLine('  -> Pas de nettoyage, champs magid non trouvé', logTrace);
        // reinit des last ID
        tmpLastID := -1;
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

          while not (Terminated or QueryGnkLst.Eof) do
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
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end;
                  end;
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                DoLogMultiLine('  requete : ' + Requete, logNone);
                ScriptText.SQL.Add(Requete);
                Inc(NbLignes);
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
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
              if not ScriptTpn.ExecuteAll() then
              begin
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if Terminated then
            Result := ers_Interrupted
          else
            Result := ers_Succeded;
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
                                DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean) : TEnumResult;
var
  MagIdName, WhereCle, Requete : string;
  NbLignes : integer;
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

      if DoDel then
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
          QueryTpnMaj.Close();
          DoLogMultiLine('  -> Nettoyage', logTrace);
          Requete := 'delete from ' + NomTable + ' where ' + MagIdName + ' = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpnMaj.SQL.Text := Requete;
          QueryTpnMaj.ExecSQL();
        end
        else
          DoLogMultiLine('  -> Pas de nettoyage, champs magid non trouvé', logTrace);
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

          while not (Terminated or QueryGnkLst.Eof) do
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
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end;
                  end;
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                DoLogMultiLine('  requete : ' + Requete, logNone);
                ScriptText.SQL.Add(Requete);
                Inc(NbLignes);
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
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
              if not ScriptTpn.ExecuteAll() then
              begin
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if Terminated then
            Result := ers_Interrupted
          else
            Result := ers_Succeded;
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
                                DoDel, DoArt, DoMaj, DoNull : boolean; IsInterruptible : boolean) : TEnumResult;
var
  WhereCle, Requete : string;
  NbLignes : integer;
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

      if DoDel then
      begin
        DoLogMultiLine('  -> Nettoyage', logTrace);
        Requete := 'delete from ' + NomTable + ';';
        QueryTpnMaj.SQL.Text := Requete;
        QueryTpnMaj.ExecSQL();
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

          while not (Terminated or QueryGnkLst.Eof) do
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
                    Requete := GetInsertRequete(QueryGnkLst, NomTable, DoNull);
                    DoLogMultiLine('  requete : ' + Requete, logNone);
                    ScriptText.SQL.Add(Requete);
                    Inc(NbLignes);
                  end
                  else
                  begin
                    // ancien -> Update
                    Requete := GetUpdateRequete(QueryGnkLst, QueryTpnExt, NomTable, NomCle, DoNull);
                    if not (Trim(Requete) = '') then
                    begin
                      if DoMaj then
                      begin
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        ScriptText.SQL.Add(Requete);
                        Inc(NbLignes);
                      end
                      else
                        DoLogMultiLine('  Attention : Update skipped : "' + Requete + '"', logDebug);
                    end;
                  end;
                end
                else
                  DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ' + NomTable + ' avec un article inexistant "' + GetIdentArticle(FieldModId.AsInteger, FieldTgfId.AsInteger, FieldCouId.AsInteger) + '"', logWarning);
              end
              else if not QueryTpnExt.Eof then
              begin
                // ancien -> a supprimer
                Requete := GetDeleteRequete(QueryGnkLst, NomTable, NomCle, DoNull);
                DoLogMultiLine('  requete : ' + Requete, logNone);
                ScriptText.SQL.Add(Requete);
                Inc(NbLignes);
              end;
            finally
              QueryTpnExt.Close();
            end;

            if ScriptText.SQL.Count >= CST_MAX_ITEMS_SCRIPT then
            begin
              DoLogMultiLine('  -> Execution du script', logTrace);
              if ScriptTpn.ValidateAll() then
              begin
                if not ScriptTpn.ExecuteAll() then
                begin
                  SaveScript(NomTable, ScriptTpn);
                  Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
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
              if not ScriptTpn.ExecuteAll() then
              begin
                SaveScript(NomTable, ScriptTpn);
                Requete := ReLaunchScriptError(ScriptTpn, QueryTpnMaj);
              end;
            end
            else
            begin
              SaveScript(NomTable, ScriptTpn);
              raise Exception.Create('Erreur a la validation du script !');
            end;
          end;

          if Terminated then
            Result := ers_Interrupted
          else
            Result := ers_Succeded;
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

// traitements inits

function TTraitement.DoExportMagasins(DoDel, DoNull : boolean) : integer;
var
  Ret : TEnumResult;
begin
  Result := 201;

  DoLogMultiLine('TTraitement.DoExportMagasins', logTrace);

  try
    FTransactionTpn.StartTransaction();
    Ret := CopieTable('TMagasin', ['MagId'], 0, 0, false, false, true, DoNull);
    case Ret of
      ers_Succeded, ers_Interrupted :
        begin
          FTransactionTpn.Commit();
          Result := 0;
        end;
      ers_Failed :
        begin
          FTransactionTpn.Rollback();
          Result := 203;
        end;
    end;
  except
    on e : Exception do
    begin
      Result := 202;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.DoExportArticles(LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoNull : boolean) : integer;
var
  QueryTpn : TMyQuery;
  LameLastID, MagLastId : integer;
  Ret : TEnumResult;
  Requete : string;
begin
  Result := 301;
  Requete := '';
  QueryTpn := nil;

  DoLogMultiLine('TTraitement.DoExportArticles', logTrace);

  try
    try
      FTransactionTpn.StartTransaction();

      LameLastID := GetLastVersion(0, 'TArticle_Lame', ListeLastId);
      MagLastId := GetLastVersion(0, 'TArticle_Mag', ListeLastId);

      Ret := CopieTable(LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TArticle', ['ModId', 'TgfId', 'CouId'], FDateMinMvt, Date(), false, false, true, DoNull);
      case Ret of
        ers_Succeded, ers_Interrupted :
          begin
            try
              QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

              Requete := SetLastVersion(0, 'TArticle_Lame', LameLastID, ListeLastId);
              QueryTpn.SQL.Text := Requete;
              QueryTpn.ExecSQL();
              Requete := SetLastVersion(0, 'TArticle_Mag', MagLastId, ListeLastId);
              QueryTpn.SQL.Text := Requete;
              QueryTpn.ExecSQL();
            finally
              FreeAndNil(QueryTpn);
            end;
          end;
        ers_Failed :
          begin
            Result := 303;
            raise exception.Create('303');
          end;
      end;

      FTransactionTpn.Commit();
      // si on arrive ici :
      Result := 0;
    except
      FTransactionTpn.Rollback();
      raise;
    end;
  except
    on e : Exception do
    begin
      if Result = 301 then
      begin
        Result := 302;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

// traitement d'export complet

function TTraitement.DoExportTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  LameLastID, MagLastId : integer;
  Ret : TEnumResult;
  Requete : string;
  DateMax : TDate;
begin
  Result := 401;
  Requete := '';
  DateMax := IncDay(Date(), -1);

  DoLogMultiLine('TTraitement.DoExportTicket', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        FTransactionTpn.StartTransaction();
        try
          // gestion des entetes
          LameLastID := GetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', ListeLastId);

          Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TVENTE_ENTETE', ['TkeId'], FDateMinMvt, DateMax, DoDel, false, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                try
                  QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Lame', LameLastID, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENTETE_Mag', MagLastId, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 403;
                raise exception.Create('403');
              end;
          end;

          // gestion des lignes
          LameLastID := GetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', ListeLastId);

          Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TVENTE_LIGNE', ['TklId'], FDateMinMvt, DateMax, DoDel, DoArt, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                try
                  QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Lame', LameLastID, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_LIGNE_Mag', MagLastId, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 404;
                raise exception.Create('404');
              end;
          end;

          // gestion des encaissement
          LameLastID := GetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', ListeLastId);

          Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TVENTE_ENCAISSEMENT', ['EncId'], FDateMinMvt, DateMax, DoDel, false, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                try
                  QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Lame', LameLastID, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TVENTE_ENCAISSEMENT_Mag', MagLastId, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 405;
                raise exception.Create('405');
              end;
          end;

          FTransactionTpn.Commit();
        except
          FTransactionTpn.Rollback();
          raise;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if Result = 401 then
      begin
        Result := 402;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

function TTraitement.DoExportFacture(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  Ret : TEnumResult;
  LameLastID, MagLastId : integer;
  Requete : string;
  DateMax : TDate;
begin
  Result := 501;
  Requete := '';
  DateMax := IncDay(Date(), -1);

  DoLogMultiLine('TTraitement.DoExportFacture', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        FTransactionTpn.StartTransaction();
        try
          // gestion des entete
          LameLastID := GetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', ListeLastId);

          Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TFACTURE_ENTETE', ['FceId'], FDateMinMvt, DateMax, DoDel, false, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                try
                  QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                  Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Lame', LameLastID, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_ENTETE_Mag', MagLastId, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 503;
                raise exception.Create('503');
              end;
          end;

          // gestion des lignes
          LameLastID := GetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', ListeLastId);

          Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TFACTURE_LIGNE', ['FclId'], FDateMinMvt, DateMax, DoDel, DoArt, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                try
                  QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                  Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Lame', LameLastID, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                  Requete := SetLastVersion(Magasin.MagId, 'TFACTURE_LIGNE_Mag', MagLastId, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 504;
                raise exception.Create('504');
              end;
          end;

          FTransactionTpn.Commit();
        except
          FTransactionTpn.Rollback();
          raise;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if Result = 501 then
      begin
        Result := 502;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

function TTraitement.DoExportMouvement(ListeMagasins : TListMagasin; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  LastIDEnt, LastIDLig : integer;
  Ret : TEnumResult;
  Requete : string;
  DateMax : TDate;
begin
  Result := 601;
  Requete := '';
  DateMax := IncDay(Date(), -1);

  DoLogMultiLine('TTraitement.DoExportMouvement', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        FTransactionTpn.StartTransaction();
        try
          // gestion des entete
          LastIDEnt := GetLastVersion(Magasin.MagId, 'TMVT', ListeLastId);

          Ret := CopieTable(Magasin, LastIDEnt, 'TMVT_ENTETE', ['MagId', 'MvtId'], FDateMinMvt, DateMax, DoDel, false, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                // Ici pas de mise a jour d'Id... il est géré via les lignes !
              end;
            ers_Failed :
              begin
                Result := 603;
                raise exception.Create('603');
              end;
          end;

          // gestion des lignes
          LastIDLig := GetLastVersion(Magasin.MagId, 'TMVT', ListeLastId);

          Ret := CopieTable(Magasin, LastIDLig, 'TMVT_LIGNE', ['MagId', 'MvtId', 'MvlId'], FDateMinMvt, DateMax, DoDel, DoArt, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                try
                  QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);

                  Requete := SetLastVersion(Magasin.MagId, 'TMVT', LastIDLig, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL();
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 604;
                raise exception.Create('604');
              end;
          end;

          FTransactionTpn.Commit();
        except
          FTransactionTpn.Rollback();
          raise;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      if Result = 601 then
      begin
        Result := 602;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      end;
    end;
  end;
end;

function TTraitement.DoExportCommande(ListeMagasins: TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin: integer; ListeLastId: TListLastIDs; DoDel, DoArt, DoNull: boolean): integer;
var
  Magasin : TMagasin;
  QueryTpn : TMyQuery;
  LameLastID, MagLastID: Integer;
  Ret : TEnumResult;
  Requete : string;
  DateMax : TDate;
begin
  Result := 701;
  DateMax := IncDay(Date, -1);

  DoLogMultiLine('TTraitement.DoExportCommande', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        FTransactionTpn.StartTransaction;
        try
          // gestion des entete
          LameLastID := GetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', ListeLastId);
          MagLastId := GetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', ListeLastId);

          Ret := CopieTable(Magasin, LamePlageDeb, LamePlageFin, LameLastID, MagPlageDeb, MagPlageFin, MagLastId, 'TCOMMANDESTATUT', ['CmdBllId', 'CmdBlhId'], FDateMinMvt, DateMax, DoDel, DoArt, False, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
                try
                  Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Lame', LameLastID, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL;
                  Requete := SetLastVersion(Magasin.MagId, 'TCOMMANDESTATUT_Mag', MagLastId, ListeLastId);
                  QueryTpn.SQL.Text := Requete;
                  QueryTpn.ExecSQL;
                finally
                  FreeAndNil(QueryTpn);
                end;
              end;
            ers_Failed :
              begin
                Result := 703;
                raise exception.Create('703');
              end;
          end;

          FTransactionTpn.Commit;
        except
          FTransactionTpn.Rollback;
          raise;
        end;
      end;
    end;

    // si on arrive ici :
    Result := 0;
  except
    on E: Exception do
    begin
      if Result = 701 then
      begin
        Result := 702;
        DoLogMultiLine('Eception : ' + GetExceptionMessage(E), logCritical);
        if not string.IsNullOrWhiteSpace(Requete) then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
      end;
    end;
  end;
end;

function TTraitement.DoExportReception(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
begin
  Result := 796;
end;

function TTraitement.DoExportRetour(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoDel, DoArt, DoNull : boolean) : integer;
begin
  Result := 797;
end;

//---- Groupe fonctionnel (monitoring)


function TTraitement.DoDeltaTicket(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  QueryGnkEnt, QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj : TMyQuery;
  EnteteID, LameLastIDEnt, MagLastIDEnt, LameLastIDLig, MagLastIDLig, LameLastIDEnc, MagLastIDEnc, NbEntetes, NbLignes : integer;
  WhereCle, Requete : string;
begin
  Result := 451;
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
                                                          + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt))
                                                          + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Date()))
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
                            DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de ticket "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('TklModId').AsInteger, QueryGnkDet.FieldByName('TklTgfId').AsInteger, QueryGnkDet.FieldByName('TklCouId').AsInteger) + '"', logWarning);
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
                          Inc(NbLignes);
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
      Result := 452;
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
  Result := 551;
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
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt))
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Date()))
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
                          DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de facture "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('FclModId').AsInteger, QueryGnkDet.FieldByName('FclTgfId').AsInteger, QueryGnkDet.FieldByName('FclCouId').AsInteger) + '"', logWarning);
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
      Result := 552;
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
  MagasinID, EnteteID, LastID, NbEntetes, NbLignes : integer;
  WhereCle, Requete : string;
  FieldSuppr : TField;
begin
  Result := 651;
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
                                                        + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Date()))
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
                      // pas de modif des entete ... juste les quantité en lignes !
                      DoLogMultiLine('  Attention : update d''entete de mouvement "' + WhereCle + '" requete : ' + Requete, logDebug);
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
                             + '       sum(MvlQte) as MvlQte, avg(MvlPx) as MvlPx '
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
                            DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de mouvement "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('MvlModId').AsInteger, QueryGnkDet.FieldByName('MvlTgfId').AsInteger, QueryGnkDet.FieldByName('MvlCouId').AsInteger) + '"', logWarning);
                        end
                        else
                        begin
                          // ancien -> Update
                          Requete := GetInsertMajRequete(QueryGnkDet, QueryTpnExt, 'TMVT_LIGNE', ['MvlQte'], ['MagId', 'MvtId', 'MvlId'], DoNull);
                          if not (Trim(Requete) = '') then
                          begin
                            DoLogMultiLine('  Attention : update d''une ligne de mouvement "' + WhereCle + '" requete : ' + Requete, logDebug);
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
                                     +   IntToStr(QueryGnkEnt.FieldByName('MvtSens').AsInteger * GetFieldDiffInt(QueryGnkDet.FieldByName('MvlQte'), QueryTpnExt.FieldByName('MvlQte')))
                                     + ');';
                            DoLogMultiLine('  requete : ' + Requete, logNone);
                            QueryTpnMaj.SQL.Text := Requete;
                            QueryTpnMaj.ExecSQL();
                          end;
                        end;
                      end
                      else if not QueryTpnExt.Eof then
                      begin
                        // ancien -> a supprimer
                        Requete := GetInsertDelRequete(QueryGnkDet, QueryTpnExt, 'TMVT_LIGNE', ['MvlQte'], ['MagId', 'MvtId', 'MvlId'], DoNull);
                        DoLogMultiLine('  Attention : suppression d''une ligne de mouvement "' + WhereCle + '" requete : ' + Requete, logDebug);
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
                                 +   IntToStr(-1 * QueryGnkEnt.FieldByName('MvtSens').AsInteger * QueryGnkDet.FieldByName('MvlQte').AsInteger)
                                 + ');';
                        DoLogMultiLine('  requete : ' + Requete, logNone);
                        QueryTpnMaj.SQL.Text := Requete;
                        QueryTpnMaj.ExecSQL();
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
      Result := 652;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
      if not (Trim(Requete) = '') then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaCommande(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin: integer; ListeLastId: TListLastIDs; DoNull: boolean): integer;
var
  tmpLogMdl, WhereCle, Requete: string;
  Magasin: TMagasin;
  QueryGnkDet, QueryGnkArt, QueryTpnArt, QueryTpnExt, QueryTpnMaj: TMyQuery;
  LameLastID, MagLastId, NbLignes: integer;
begin
  Result := 751;
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
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt))
                                                            + ', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Date))
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

                // recherche d'existence
                WhereCle := GetWhere(QueryGnkDet, ['MagId', 'CmdBlhId', 'CmdBllId'], False);
                Requete := 'select * from TCOMMANDESTATUT where ' + WhereCle + ';';

                QueryTpnExt.SQL.Text := Requete;
                QueryTpnExt.Open;
                try
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
                      DoLogMultiLine('  Attention : Tentative d''insert d''une ligne de commande "' + WhereCle + '" avec un article inexistant "' + GetIdentArticle(QueryGnkDet.FieldByName('CmdModId').AsInteger, QueryGnkDet.FieldByName('CmdTgfId').AsInteger, QueryGnkDet.FieldByName('CmdCouId').AsInteger) + '"', logWarning);
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
      Result := 752;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(E), logCritical);
      if not string.IsNullOrWhiteSpace(Requete) then
        DoLogMultiLine('  requete : ' + Requete, logDebug);
    end;
  end;
end;

function TTraitement.DoDeltaReception(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
begin
  Result := 798;
end;

function TTraitement.DoDeltaRetour(ListeMagasins : TListMagasin; LamePlageDeb, LamePlageFin, MagPlageDeb, MagPlageFin : integer; ListeLastId : TListLastIDs; DoNull : boolean) : integer;
begin
  Result := 799;
end;

//---- Groupe fonctionnel (monitoring)




// Gestion des stock

function TTraitement.DoHistoStock(ListeMagasins : TListMagasin; DoArt, DoNull : boolean) : integer;
var
  Magasin : TMagasin;
  tmpDate : TDate;
  Ret : TEnumResult;
begin
  Result := 801;

  DoLogMultiLine('TTraitement.DoHistoStock', logTrace);

  try
    for Magasin in ListeMagasins do
    begin
      if Magasin.Actif then
      begin
        tmpDate := EndOfTheMonth(FDateMinStk);

        FTransactionTpn.StartTransaction();
        Ret := CopieTable(Magasin, 'TStockDate', ['StkDate', 'StkMagId', 'StkModId', 'StkTgfId', 'StkCouId'], tmpDate, 0, true, DoArt, false, DoNull);
        case Ret of
          ers_Succeded, ers_Interrupted :
            begin
              FTransactionTpn.Commit();
              tmpDate := EndOfTheMonth(IncDay(tmpDate, 1));
              while not Terminated and (tmpDate < Now()) do
              begin
                FTransactionTpn.StartTransaction();
                Ret := CopieTable(Magasin, 'TStockDate', ['StkDate', 'StkMagId', 'StkModId', 'StkTgfId', 'StkCouId'], tmpDate, 0, false, DoArt, false, DoNull);
                case Ret of
                  ers_Succeded, ers_Interrupted :
                    begin
                      FTransactionTpn.Commit();
                    end;
                  ers_Failed :
                    begin
                      FTransactionTpn.Rollback();
                      Result := 804;
                      Exit;
                    end;
                end;
                tmpDate := EndOfTheMonth(IncDay(tmpDate, 1));
              end;
            end;
          ers_Failed :
            begin
              FTransactionTpn.Rollback();
              Result := 803;
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
      Result := 802;
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
  Result := 851;
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
        Result := 898;
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
              Result := 853;
              DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
              if not (Trim(Requete) = '') then
                DoLogMultiLine('  requete : ' + Requete, logDebug);
              Exit;
            end;
          end;

          Ret := CopieTable(Magasin, 'TStock', ['StkMagId', 'StkModId', 'StkTgfId', 'StkCouId'], 0, 0, true, DoArt, false, DoNull);
          case Ret of
            ers_Succeded, ers_Interrupted :
              begin
                FTransactionTpn.Commit();
              end;
            ers_Failed :
              begin
                FTransactionTpn.Rollback();
                Result := 854;
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
        Result := 852;
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

// Gestion de la base !

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
begin
  Result := 901;
  Requete := '';

  DoLogMultiLine('TTraitement.CreateBase', logTrace);

  try
    // fermeture
    FConnexionTpn.Close();

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
      if not DeleteFile(FNomBaseTampon) then
      begin
        Result := 903;
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
          LoadScriptSQL('Structure_1', ScriptText.SQL);
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
          Result := 904;
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
        LoadScriptSQL('Valeurs_1', ScriptText.SQL);
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
        Result := 905;
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
        Result := 906;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
        if not (Trim(Requete) = '') then
          DoLogMultiLine('  requete : ' + Requete, logDebug);
        Exit;
      end;
    end;

    // si on arrive ici
    // faire les mise a jour !
    Result := UpdateBase();
  except
    on e : Exception do
    begin
      Result := 902;
      DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
    end;
  end;
end;

function TTraitement.UpdateBase() : integer;
var
  Num : integer;
  ResStructName, ResValName : string;
  tmpConnexionTpn : TMyConnection;
  tmpTransactionTpn : TMyTransaction;
  ScriptTpn : TMyScript;
  ScriptText : TFDSQLScript;
  QueryTpn : TMyQuery;
  Requete : string;
begin
  Result := 911;
  Requete := '';

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

    while (FindResource(HInstance, PChar(ResStructName), RT_RCDATA) <> 0) or
          (FindResource(HInstance, PChar(ResValName), RT_RCDATA) <> 0) do
    begin
      // Passage du patch de structure
      if FindResource(HInstance, PChar(ResStructName), RT_RCDATA) <> 0 then
      begin
        DoLogMultiLine('  -> Fichier ' + ResStructName, logDebug);

        try
          tmpConnexionTpn := GetNewConnexion(FNomBaseTampon, DATABASE_USER_ADM, DATABASE_PASSWORD_ADM, false);
          tmpTransactionTpn := GetNewTransaction(tmpConnexionTpn, false);
          tmpConnexionTpn.Open();
          try
            tmpTransactionTpn.StartTransaction();
            try
              QueryTpn := GetNewQuery(tmpConnexionTpn, tmpTransactionTpn);
              ScriptTpn := GetNewScript(tmpConnexionTpn, tmpTransactionTpn);
              ScriptText := ScriptTpn.SQLScripts.Add();
              LoadScriptSQL(ResStructName, ScriptText.SQL);
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
              Result := 913;
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
      end;

      // Passage du patch de valeur
      if FindResource(HInstance, PChar(ResValName), RT_RCDATA) <> 0 then
      begin
        DoLogMultiLine('  -> Fichier ' + ResValName, logDebug);

        try
          FTransactionTpn.StartTransaction();

          try
            QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
            ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
            ScriptText := ScriptTpn.SQLScripts.Add();
            LoadScriptSQL(ResValName, ScriptText.SQL);
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
            Result := 914;
            DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
            if not (Trim(Requete) = '') then
              DoLogMultiLine('  requete : ' + Requete, logDebug);
            Exit;
          end;
        end;
      end;

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
          Result := 915;
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
    end;

    // si on arrive ici :
    Result := 0;
  except
    on e : Exception do
    begin
      Result := 912;
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
  Result := 921;

  ScriptTpn := nil;

  DoLogMultiLine('TTraitement.ClearBase', logTrace);

  try
    try
      FTransactionTpn.StartTransaction();
      try
        QueryTpn := GetNewQuery(FConnexionTpn, FTransactionTpn);
        ScriptTpn := GetNewScript(FConnexionTpn, FTransactionTpn);
        ScriptText := ScriptTpn.SQLScripts.Add();
        LoadScriptSQL('Nettoyage', ScriptText.SQL);
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
        Result := 923;
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
      Result := 922;
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
  Result := 931;

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
          Requete := 'delete from TVENTE_ENTETE where tkedate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and magid = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TFACTURE_ENTETE where fcedate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and magid = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TMVT_ENTETE where mvtdate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and magid = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();

          // tables de CrossCanal
          Requete := 'delete from TCOMMANDESTATUT where CmdDateCmd < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and CmdMagId = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();

          // tables du rapprochement auto
          Requete := 'delete from TRECEPTETE where BreDate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and BreMagID = ' + IntToStr(Magasin.MagId) + ';';
          QueryTpn.SQL.Text := Requete;
          QueryTpn.ExecSQL();
          Requete := 'delete from TRETOURTETE where RetDate < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FDateMinMvt)) + ' and RetMagID = ' + IntToStr(Magasin.MagId) + ';';
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
        Result := 932;
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
                   + 'hev_base = ' + QuotedStr(FConnexionGnk.Params.Database) + ', '                                                         // chemin de base
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
begin
  ReturnValue := 101;
  ListeLastId := nil;
  LamePlageDeb := 0;
  LamePlageFin := 0;
  MagPlageDeb := 0;
  MagPlageFin := 0;

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
        ReturnValue := 103;
        DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logEmergency);
        Exit;
      end;
    end;

    try

      //==================================================
      // Logs des informations
      if (ett_LogForce in FWhatToDo) then
        DoLogInfosUtils();

      //==================================================
      // Attente ... pour test (2h)
      if (ett_ForceSleep in FWhatToDo) then
      begin
        Sleep(7200000);
        ReturnValue := 0;
      end
      else if (ett_DoSleep in FWhatToDo) then
      begin
        for i := 0 to 120 do
        begin
          if Terminated then
            Break;
          Sleep(60000);
        end;
        ReturnValue := 0;
      end
      // Autres traitement ?
      else
      begin
        try
          FConnexionTpn.Open();
        except
          on e : Exception do
          begin
            DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
            ReturnValue := 104;
            Exit;
          end;
        end;

        try
          begin
            try
              FImportRapprochement := TImportRapprochement.Create(FConnexionGnk,FConnexionTpn,FTransactionGnk,FTransactionTpn);
              try
                FImportRapprochement.LogModule := FLogMdl;
                FImportRapprochement.LogRef    := FLogRef;
                FImportRapprochement.LogKey    := FLogKey;

                FImportRapprochement.DoLogMulti := DoLogMultiLine;
                FImportRapprochement.GetGenerateurs;

                // traitement des réceptions
                if not Terminated then
                begin
                  Log.Log(FLogMdl, FLogRef, '', FLogKey, 'Traitement réception en cours', logNotice,True,-1,ltServer);
                  FImportRapprochement.ImportReception;
                  Log.Log(FLogMdl, FLogRef, '', FLogKey, 'Traitement réception terminé', logInfo,False,-1,ltServer);
                end;

                // traitement des bon de retour
                if not Terminated then
                begin
                  Log.Log(FLogMdl, FLogRef, '', FLogKey, 'Traitement Bon de retour en cours', logNotice,True,-1,ltServer);
                  FImportRapprochement.ImportBonRetour;
                  Log.Log(FLogMdl, FLogRef, '', FLogKey, 'Traitement Bon de retour terminé', logInfo,False,-1,ltServer);
                end;

                // traitement des bon de rapprochement
                if not Terminated then
                begin
                  Log.Log(FLogMdl, FLogRef, '', FLogKey, 'Traitement Rapprochement en cours', logNotice,True,-1,ltServer);
                  FImportRapprochement.ImportRapprochement;
                  Log.Log(FLogMdl, FLogRef, '', FLogKey, 'Traitement Rapprochement terminé', logInfo,False,-1,ltServer);

                end;

              finally
                FreeAndNil(FImportRapprochement);
              end;

              // si on arrive ici :
              ReturnValue := 0;
            except
              on e : Exception do
              begin
                ReturnValue := 102;
                DoLogMultiLine('Exception : ' + GetExceptionMessage(e), logCritical);
              end;
            end;
          end;
        finally
          FConnexionTpn.Close();
        end;
      end;
    finally
//      DoHistoEvent(false, (ett_ResetStock in FWhatToDo), ReturnValue);
      FConnexionGnk.Close();
    end;
  finally
    CoUninitialize();
  end;
end;

// Contructeur/Destructeur

constructor TTraitement.Create(FctTerminate: TNotifyEvent;
                               BaseGin, BaseTpn, LogDos, LogMdl, LogRef, LogKey : string;
                               DateMinMvt, DateMinStk : TDate; LogInterval : integer;
                               ListMag : TListMagasin;
                               WhatToDo : TSetTraitementTodo;
                               DoNull : boolean;
                               CreateSuspended: Boolean);
var
  i : integer;
begin
  Inherited Create(CreateSuspended);
  OnTerminate := FctTerminate;
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
  // Histo
  FStartTime := Now();
  // date minimum d'export
  FDateMinMvt := DateMinMvt;
  FDateMinStk := DateMinStk;
  // champs a ne pas prendre en compte
  SetLength(FFieldToIgnore, Length(FIELDS_KVERSION) + Length(FIELD_KENABLED));
  for i := 0 to Length(FIELDS_KVERSION) -1 do
    FFieldToIgnore[i] := FIELDS_KVERSION[i];
  for i := 0 to Length(FIELD_KENABLED) -1 do
    FFieldToIgnore[Length(FIELDS_KVERSION) + i] := FIELD_KENABLED[i];
  // traitement a faire
  FWhatToDo := WhatToDo;
  FDoNull := DoNull;
end;

destructor TTraitement.Destroy();
begin
  // liberation !
  SetLength(FFieldToIgnore, 0);
  FreeAndNil(FConnexionGnk);
  FreeAndNil(FConnexionTpn);
  FreeAndNil(FTransactionGnk);
  FreeAndNil(FTransactionTpn);
  if ReturnValue = 0 then
    DoLogMultiLine('Fin', logInfo, true);
  DoLogMultiLine('TTraitement.Destroy (Resultat : "' + IntToStr(ReturnValue) + '"; Durée : "' + GetIntervalText(FStartTime, Now()) + '")', logTrace);
  Inherited Destroy();
end;

procedure TTraitement.Terminate();
begin
  DoLogMultiLine('TTraitement.Terminate', logDebug);
  inherited Terminate();
end;

end.

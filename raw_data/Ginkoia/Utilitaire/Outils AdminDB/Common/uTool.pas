{===============================================================================
 Projet    : <Ginkoia> - <Tool>
===============================================================================}

unit uTool;

{===============================================================================
 Module    : Aucun
 Création  : 06/10/2008
 Auteur(s) : Gregory Ben Hamza

--- Description ----------------------------------------------------------------
  Unit regroupant les Fonctions et Procedures génériques
===============================================================================}

interface

uses
  Windows, SysUtils, Classes, ComCtrls, DB, dbtables, grids, stdctrls, checklst,
  Messages, Graphics, Dialogs, Forms, DBGrids, DBCtrls, DateUtils, ShlObj, ActiveX,
  ShellApi, TlHelp32, IdSMTP, IdMessage, {IdAttachment, IdAttachmentFile,}
  DBClient, Controls, Mask, ExtCtrls, TypInfo, midasLib, cxGrid, cxGridExportLink,
  IdText, IdFTP, IdFTPCommon, IdExplicitTLSClientServerBase, IdAllFTPListParsers,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridDBBandedTableView, cxGridBandedTableView, cxStyles,
  //use Perso
  uLogs,
  //Ajout Mail
  IdSSLOpenSSL, IdGlobal, IdLogFile;
  //Fin Mail


Const
  JoursFeriesFixes: array[0..7] of String = ('01/01', // Jour de l'an
                                             '01/05', // Fête du travail
                                             '08/05', // Armistice 1945
                                             '14/07', // Fête nationale
                                             '15/08', // L’Assomption
                                             '01/11', // La Toussaint
                                             '11/11', // Armistice 1918
                                             '25/12'); // Noël

  Unite: array[1..16] of String = ('un','deux','trois','quatre','cinq','six',
                                   'sept','huit','neuf','dix','onze','douze',
                                   'treize','quatorze','quinze','seize');
  Dizaine: array[2..8] of String = ('vingt','trente','quarante','cinquante',
                                    'soixante','','quatre-vingt');
  Coefs: array[0..3] of String = ('cent','mille','million','milliard');

type
  TAlignCellH = (achLeft, achCenter, achRight);
  TAlignCellV = (acvTop, acvCenter, acvBottom);
  TFileType = (ftNone, ftExcel, ftPDF);

{ Dates }
function GetCurrentDateTime: TSystemTime;
function GetLastDayOfMonth(Const AMonth, AYear: Word): Word;
function GetIntervalMonth(Const DateStart, DateEnd: TDateTime): integer;
function GetIntervalDay(Const DateStart, DateEnd: TDateTime; Const WithoutDayOff: Boolean = False): integer;
function DateStartMonthToStr(Const AMonth, AYear: Word): String;
function DateEndMonthToStr(Const AMonth, AYear: Word): String;
function DateStartMonth(Const AMonth, AYear: Word): TDateTime;
function StartMonth(Const ADate: TDateTime; Const N: integer = 0): TDateTime;
function DateTimeToStartMonth(Const ADate: TDateTime): TDateTime;
function DateEndMonth(Const AMonth, AYear: Word): TDateTime;
function DateIsFerie(Const ADate: TDateTime): Boolean;
function DateInWeekEnd(Const ADate: TDateTime): Boolean;
function DayOpen(Const ADate: TDateTime; Const WeekOnly: Boolean = False): Boolean;
function GetNextDateOpen(Const ADate: TDateTime; Const WeekOnly: Boolean = False): TDateTime;
function GetPriorDateOpen(Const ADate: TDateTime; Const WeekOnly: Boolean = False): TDateTime;
function DateTimeToDate(Const ADate: Real): TDate;
function OuvrablePlus(Const pDate: TDateTime; const pPlus: integer): TDateTime;

{ Conversion de Chaine }
function SeparMillier(Const Value: String; Const Separe: Boolean = True): String;
function StrToDateDef(Const S: String; Const Default: TDateTime = 0): TDateTime;
function GetStrDef(Const S, SearchVal: String; Const SetVal: String = ''): String;
function FloatToCharacter(Const Value: String; Const DeviseName: String = 'EUROS'): String;
function UpdateKindToStr(Const AUpdateKind: TUpdateKind): String;
function SplitString(chaine : String; delimiteur : string): TStringList;
{ Manipulation d'Objet - ListView, CheckList, Etc.. }
function PosAlignStringGrid(const AStringGrid: TStringGrid; const ACol, ARow: integer;
                            Const AAlignCellH: TAlignCellH; Const AAlignCellV: TAlignCellV = acvCenter): TPoint;
function ResizeText(var S: String; Const SizeCell: integer; Const FontSize: integer = 8;
                    Const NewResize: Boolean = False): Boolean;
function TextSize(Const S: String; Const AFont: TFont = nil): TPoint;
function PosAlign(Const S: String; Const ARect: TRect; Const AAlignCellH: TAlignCellH;
                  Const AAlignCellV: TAlignCellV = acvCenter;
                  Const AFont: TFont = nil): TPoint;
function GetItemValue(Const AList: TStrings; Const Index: integer): String;
function FindColumn(Const ColumnName: String; Const ListColumns: TListColumns): TListColumn;
function LocateListItem(Const AlistView: TListView; Const KeyFields, Values: String): TListItem;
procedure DataSetToList(const ADataSetSource: TDataSet; const AFieldNameSource: String; const AListCible: TStrings);
procedure AppendItemsInListBox(const AListBoxSource, AListBoxCible: TListBox; Const DeleteAfterAppend: Boolean = False);
procedure DeleteItemsInListBox(const AListBox: TListBox);
procedure CheckedListBox(const ACheckListBox: TCheckListBox; Const UnChecked: Boolean = True);
procedure CheckedListToCheckList(const AListSource: TStringList; Const ACheckListBoxCible: TCheckListBox);
procedure CheckedCheckListToList(Const ACheckListBoxSource: TCheckListBox; const AListCible: TStringList);
procedure GroupCheckInCheckListBox(const ACheckListBox: TCheckListBox);
procedure DataSetToListView(Const ADataset: TDataSet; Const AlistView: TListView);
procedure StringListToListView(Const Values: TStringList; Const AlistView: TListView;
                               Const KeyFields, KeyValues: String; Const DefaultImg: integer = 0; Const Delete: Boolean = False);
procedure AppendItemsInListView(Const AListViewSource, AListViewCible: TListView);
procedure DeleteItemsInListView(const AListView: TListView; Const AListViewModel: TListView = nil);
procedure AlignCell(const AStringGrid: TStringGrid; const ACol, ARow: integer;
                    Const AAlignCellH: TAlignCellH; Const AAlignCellV: TAlignCellV = acvCenter;
                    Const AFont: TFont = nil; Const MonoLine: Boolean = True);
procedure StringGridClear(const AStringGrid: TStringGrid);
procedure SetTextMultiligne(Const S: String; Const ACanvas: TCanvas; Const ARect: TRect;
                            Const AAlignCellH: TAlignCellH; Const AAlignCellV: TAlignCellV = acvCenter);
procedure MoveItemListBox(Const AListBox: TListBox; Const AUp: Boolean);
procedure CloneProperty(Const InstanceSource, InstanceCible: TObject);

{ Procedures d'Evenements }
procedure EnterAsTabFormKeyPress(Sender: TForm; var Key: Char); overload;
procedure EnterAsTabFormKeyPress(Sender: TForm; var Key: Word); overload;
procedure NumberEditKeyPress(var Key: Char; Const AllowValueNeg: Boolean = True);

{ System API }
function GetVersion(Const FileName: String; Const WithBuild: Boolean = True): String;
function GetFolderWindows(Const CSIDLValue: integer): String;
function ExecAndWaitProcess(Const AFileName, AParams, ADirectory: String; var AError: String; Const AUsedByThread: Boolean = False): integer;
function GetUserNameWindows: String;
function GetComputerNameLocal: string;
function GetBoxFolder(AOwnerHdl: THandle; var AFolder: string; const ATitle: string;
                      Const AddBtnNewFolder: Boolean): boolean;
function GetProcessusRUN(Const NameAppli: String; Const Alist: TStringList;
                         Const WithDetail: Boolean = False): Cardinal;
function IsApplicationRUN(Const NameApplication: ShortString; Const ATerminateProcess: Boolean = False): Boolean;
function UpDirectory(Const ADir: String; Const ANbNiv: Integer): String;

procedure InitializeIHM(Const AControl: TWinControl; Const UnInitialize: Boolean = False;
                        Const UseTag: Boolean = True);
function DeleteDirectory(Const ADir: String): Boolean;
function GetValeurParametre(const AParamName: String): String;
function IsInteger(Const S: String): Boolean;
function CompareVersion(const AVER_1, AVER_2: String): integer;

{ Tracage }
procedure WriteLog(Const AExeName: String; Const Values: array of string; Const LogActif: Boolean);

{ DB }
procedure MoveRec(Const ADataSet: TDataSet; Const Down: Boolean = False);
procedure RecalcOrdre(Const ADataSet: TDataSet);
procedure CloneClientDataSet(Const ASource: TClientDataSet; var ACible: TClientDataSet;
                             Const AppendData: Boolean = True);
procedure BatchRecord(Const ASource, ACible: TDataSet; Const AutoPost: Boolean = True);
procedure BatchMove(Const ASource, ACible: TDataSet; Const AutoPost: Boolean = True);
procedure DataSetToFile(Const ADS: TDataSet; Const AFileName, ASep: String);
procedure EmptyClientDataSet(Const ADataSet: TDataSet);

{ SMTP }
procedure SendMail(Const AHost, APassword, AFrom, AFromAdrMail, AFromAdrMailReply, ASujet: String;
                     const ARecipients: TStrings; const AMessage: TStrings;
                     Const AAttachmentList: TStrings = nil; Const AFileIsTempFile: Boolean = False;
                     Const ACCList: TStrings = nil; Const ABCCList: TStrings = nil;
                     Const APort: integer = 25);
procedure SendMailLite(const ARecipients, ASubject, ABody, AHost, AUser, APassword: string; const APort: Integer);

{ FTP }
procedure SendFileToFTP(Const AUserName, APassword, AHost, ARemoteDir, ALocalPathAndFileName: String;
                        Const AProxySettings: TIdFtpProxySettings = nil; Const DeleteAfterSend: Boolean = False;
                        Const APort: integer = 21; Const AUseTLS: TIdUseTLS = utNoTLSSupport);
procedure DownloadByFTP(Const AUserName, APassword, AHost, ARemoteDir, ALocalDest, AFileName: String;
                        Const DeleteAfterDownload: Boolean = False; Const AProxySettings: TIdFtpProxySettings = nil;
                        Const AFileList: TStringList = nil; Const APort: integer = 21; Const AProgess: TProgressBar = nil;
                        Const AUseTLS: TIdUseTLS = utNoTLSSupport);

{ -------------------------------- Dependency --------------------------------- }

{ Export }
procedure SaveGridToXLS(ACxGrid: TCxGrid; Const OpenAfterSave: Boolean = False;
                        const AFileName: string = ''; Const PromptSaveDialog: Boolean = False);

procedure OnClickColumnHeaderForSearch(Const AGridTableView: TcxGridTableView;
                                       Const AColumn: TcxGridColumn; Const AColorSearch: TcxStyle);

{ ----------------------------------------------------------------------------- }

implementation

{===============================================================================
 Fonction     : GetCurrentDateTime
 Description  : permet d'obtenir toutes les valeurs séparées d'un DateTime(Year,
                Month, DayOfWeek, Day, Hour, Minute, Second, Milliseconds) en cours
===============================================================================}
function GetCurrentDateTime: TSystemTime;
begin
  GetLocalTime(Result);
end;

{===============================================================================
 Fonction     : GetLastDayOfMonth
 Description  : permet d'obtenir le dernier jour d'un mois spécifié en tenant
                compte si l'année spécifiée est bissextile ou non
===============================================================================}
function GetLastDayOfMonth(Const AMonth, AYear: Word): Word;
begin
  Result:= MonthDays[IsLeapYear(AYear), AMonth];
end;

{===============================================================================
 Fonction     : GetIntervalMonth
 Description  : permet d'obtenir le nombre de mois entre la "DateStart" et la
                "DateEnd"
===============================================================================}
function GetIntervalMonth(Const DateStart, DateEnd: TDateTime): integer;
var
  vBufDateTime: Double;
  vYS, vYE, vMS, vME, vDS, vDE: Word;
  vReturn: Boolean;
begin
  vBufDateTime:= DateStart;
  DecodeDate(DateStart, vYS, vMS, vDS);
  DecodeDate(DateEnd, vYE, vME, vDE);
  Result:= 1;
  if DateStart > DateEnd then
    Raise Exception.create('La date de début doit être inferieur à la date de fin.');
  if (vYS = vYE) and (vMS = vME) then
    Exit;
  vReturn:= True;
  while vReturn do
    begin
      vBufDateTime:= IncMonth(vBufDateTime, 1);
      DecodeDate(vBufDateTime, vYS, vMS, vDS);
      Inc(Result);
      vReturn:= (vYS < vYE) or (vMS < vME);
    end;
end;

{===============================================================================
 Fonction     : GetIntervalDay
 Description  : permet d'obtenir le nombre de jour entre la "DateStart" et la
                "DateEnd" en incluant ou non les jours ouvrés.
===============================================================================}
function GetIntervalDay(Const DateStart, DateEnd: TDateTime;
  Const WithoutDayOff: Boolean): integer;
var
  vCptJ, vCptBuf: integer;
begin
  vCptJ:= 0;
  if DateStart > DateEnd then
    Raise Exception.create('La date de début doit être inferieur à la date de fin.');
  Result:= Trunc(DateEnd) - Trunc(DateStart) + 1;
  if WithoutDayOff then
    begin
      vCptBuf:= Trunc(DateStart);
      while vCptBuf <= Trunc(DateEnd) do
        begin
          if DayOpen(vCptBuf) then
            Inc(vCptJ);
          Inc(vCptBuf);
        end;
      Result:= vCptJ;
    end;
end;

{===============================================================================
 Fonction     : DateStartMonthToStr
 Description  : permet la recuperation de la date du 1er jour du mois au format
                String en fonction de "AMonth" et "AYear"
===============================================================================}
function DateStartMonthToStr(Const AMonth, AYear: Word): String;
begin
  Result:= DateToStr(EncodeDate(AYear, AMonth, 01));
end;

{===============================================================================
 Fonction     : DateEndMonthToStr
 Description  : permet la recuperation de la date du dernier jour du mois au
                format String en fonction de "AMonth" et "AYear"
===============================================================================}
function DateEndMonthToStr(Const AMonth, AYear: Word): String;
begin
  Result:= DateToStr(EncodeDate(AYear, AMonth, GetLastDayOfMonth(AMonth, AYear)));
end;

{===============================================================================
 Fonction     : DateStartMonth
 Description  : permet la recuperation de la date du 1er jour du mois au format
                TDateTime en fonction de "AMonth" et "AYear"
===============================================================================}
function DateStartMonth(Const AMonth, AYear: Word): TDateTime;
begin
  Result:= EncodeDate(AYear, AMonth, 01);
end;

{===============================================================================
 Fonction     : StartMonth
 Description  : permet la recuperation de la date du 1er jour du mois au format
                TDateTime en fonction de "N".
                Le parametre "N" permet d'incrementer ou de decrementer
                la position du mois en fonction de la date du jour.
 Exemple      : StartMonth(Now, -1) = le 1er jour du mois precedent
                StartMonth(Now, +1) = le 1er jour du mois suivant
===============================================================================}
function StartMonth(Const ADate: TDateTime; Const N: integer): TDateTime;
begin
  Result:= StartOfTheMonth(IncMonth(ADate, N));
end;

{===============================================================================
 Fonction     : DateTimeToStartMonth
 Description  : permet la recuperation de la date du 1er jour du mois au format
                TDateTime en fonction de "ADate"
===============================================================================}
function DateTimeToStartMonth(Const ADate: TDateTime): TDateTime;
var
  vY, vM, vD: Word;
begin
  DecodeDate(ADate, vY, vM, vD);
  Result:= DateStartMonth(vM, vY);
end;


{===============================================================================
 Fonction     : DateEndMonth
 Description  : permet la recuperation de la date du dernier jour du mois au
                format TDateTime en fonction de "AMonth" et "AYear"
===============================================================================}
function DateEndMonth(Const AMonth, AYear: Word): TDateTime;
begin
  Result:= EncodeDate(AYear, AMonth, GetLastDayOfMonth(AMonth, AYear));
end;

{===============================================================================
 Fonction     : SeparMillier
 Description  : permet la separation des milliers du parametre "Value".
                Le parametre "Separe" permet la suppression des sparateurs
                de milliers.
===============================================================================}
function SeparMillier(Const Value: String; Const Separe: Boolean): String;
var
  Idx, Cpt, vNbSpace: integer;
  Buffer: String;
begin
  Result:= StringReplace(Value, ' ', '', [rfReplaceAll]);
  if Separe then
    begin
      Idx:= Pos(DecimalSeparator, Result);
      if Idx <> 0 then
        begin
          Buffer:= Copy(Result, Idx, Length(Result) - Idx +1);
          Result:= Copy(Result, 1, Idx-1);
        end;
      vNbSpace:= Length(Result) div 3;
      if vNbSpace <> 0 then
        begin
          Cpt:= Length(Result) - 2;
          while vNbSpace <> 0 do
            begin
              Insert(' ', Result, Cpt);
              Dec(Cpt, 3);
              Dec(vNbSpace);
            end;
        end;
      Result:= Trim(Result) + Buffer;
    end;
end;

{===============================================================================
 procedure    : DataSetToList
 Description  : permet le remplissage de "AListCible" à partir d'un DateSet
                source "ADateSetSource".
===============================================================================}
procedure DataSetToList(const ADataSetSource: TDataSet; const AFieldNameSource: String;
  const AListCible: TStrings);
begin
  try
    if not ADataSetSource.active then
      ADataSetSource.Open;
    AListCible.Clear;
    ADataSetSource.First;
    while not ADataSetSource.Eof do
      begin
        AListCible.Append(ADataSetSource.FieldByName(AFieldNameSource).AsString);
        ADataSetSource.Next;
      end;
  finally
    ADataSetSource.close;
  end;
end;

{===============================================================================
 Fonction     : StrToDateDef
 Description  : permet la conversion d'un String en DateTime en vérifiant si la
                valeur "S" est vide ou pas.
                - Si "S" est vide le result renvoie le "Default" si ce dernier
                est different de 0.
                - Si "S" est vide et "Default" à 0 le result renvoie la date
                du jour
===============================================================================}
function StrToDateDef(Const S: String; Const Default: TDateTime): TDateTime;
begin
  if Trim(S) <> '' then
    Result:= StrToDateTime(S)
  else
    if Default <> 0 then
      Result:= Default
    else
      Result:= Now;
end;

{===============================================================================
 Fonction     : SplitString
 Description  : permet de créer une stringlist depuis une chaine de charactère.
===============================================================================}
function SplitString(chaine : String; delimiteur : string) : TStringList;
var
L : TStringList;
begin
  L:=TStringList.create;
  L.text := StringReplace(chaine, delimiteur, #13#10, [rfReplaceAll]);
  Result:=L;
end;

{===============================================================================
 Fonction     : DateIsFerie
 Description  : permet de savoir si "Adate" est férié
===============================================================================}
function DateIsFerie(Const ADate: TDateTime): Boolean;

  function Paques(Const AYear: word = 0): TDateTime;
  var
    a, b, c, d, e, mois, jour: integer;
    vYear: Word;
  begin
    vYear:= AYear;
    if vYear = 0 then
      vYear:= GetCurrentDateTime.wYear;
    a:= vYear mod 19;
    b:= vYear div 100;
    c:= (b - (b div 4) - ((8 * b + 13) div 25) + (19 * a) + 15) mod 30;
    d:= c - (c div 28) * (1 - (c div 28) * (29 div (c + 1)) * ((21 - a) div 11));
    e:= d - ((vYear + (vYear div 4) + d + 2 - b + (b div 4)) mod 7);
    mois:= 3 + ((e + 40) div 44);
    jour:= e + 28 - (31 * (mois div 4));
    Result:= EncodeDate(vYear, mois, jour);
  end;

var
  i: integer;
  Buffer: String;
  vJoursFeries: TStringList;
  vYear, vMonth, vDay: Word;
begin
  vJoursFeries:= TStringList.Create;
  try
    { Chargement des jours feries fixes }
    for i:= Low(JoursFeriesFixes) to High(JoursFeriesFixes) do
      vJoursFeries.Append(JoursFeriesFixes[i]);

    { Chargement des jours feries variables }
    DecodeDate(ADate, vYear, vMonth, vDay);
    vJoursFeries.Append(FormatDateTime('dd/mm', Paques(vYear)+1)); // Lundi de Pâques
    vJoursFeries.Append(FormatDateTime('dd/mm', Paques(vYear)+39)); // L’Ascension
//    vJoursFeries.Append(FormatDateTime('dd/mm', Paques(vYear)+50)); // Lundi de Pentecôte(pas obligatoire)

    Buffer:= FormatDateTime('dd/mm', Adate);
    Result:= vJoursFeries.IndexOf(Buffer) <> -1;
  finally
    FreeAndNil(vJoursFeries);
  end;
end;

{===============================================================================
 Fonction     : DateInWeekEnd
 Description  : permet de savoir si "ADate" tombe un samedi ou un dimanche
===============================================================================}
function DateInWeekEnd(Const ADate: TDateTime): Boolean;
begin
  Result:= DayOfWeek(ADate) in [1, 7];
end;

{===============================================================================
 Fonction     : DayOpen
 Description  : permet de savoir si "ADate" est un jour ouvré. c'est à dire ni
                férié ni samedi et ni dimanche
                Le paramètre "WeekOnly" indique si l'on souhaite tenir compte
                que des Week-end sans les jours fériés ou les deux.
===============================================================================}
function DayOpen(Const ADate: TDateTime; Const WeekOnly: Boolean): Boolean;
begin
  if WeekOnly then
    Result:= not DateInWeekEnd(ADate)
  else
    Result:= (not DateIsFerie(ADate)) and (not DateInWeekEnd(ADate));
end;

{===============================================================================
 Fonction     : GetNextDateOpen
 Description  : permet d'obtenir la prochaine date ouvrée.
                A noter que la fonction renvoie "ADate" si "ADate" est un
                jour ouvré.
                Le paramètre "WeekOnly" indique si l'on souhaite tenir compte
                que des Week-end sans les jours fériés ou les deux.
===============================================================================}
function GetNextDateOpen(Const ADate: TDateTime; Const WeekOnly: Boolean): TDateTime;
begin
  Result:= ADate;
  while not DayOpen(Result, WeekOnly) do
    Result:= Result +1;
end;

{===============================================================================
 Fonction     : GetPriorDateOpen
 Description  : permet d'obtenir la précédente date ouvrée.
                A noter que la fonction renvoie "ADate" si "ADate" est un
                jour ouvré.
                Le paramètre "WeekOnly" indique si l'on souhaite tenir compte
                que des Week-end sans les jours fériés ou les deux.
===============================================================================}
function GetPriorDateOpen(Const ADate: TDateTime; Const WeekOnly: Boolean = False): TDateTime;
begin
  Result:= ADate;
  while not DayOpen(Result, WeekOnly) do
    Result:= Result -1;
end;

{===============================================================================
 Fonction     : DateTimeToDate
 Description  : renvoie un TDate contenant la valeur de date sans les
                valeurs : hh:mm:ss.
                Note : utile pour les problemes de type entre dbExpress et Oracle
===============================================================================}
function DateTimeToDate(Const ADate: Real): TDate;
begin
  Result:= Trunc(ADate);
end;

{===============================================================================
 Fonction     : OuvrablePlus
 Description  : renvoie une date = (pDate + pPlus jours ouvrés)
                A 100 jours fériés trouvés, on considère qu'on est dans une boucle
===============================================================================}
function OuvrablePlus(Const pDate: TDateTime; const pPlus: integer): TDateTime;
var
  i, j: integer;
begin
  Result:= pdate;
  i := 1;
  j := 1;
  while i <= pPlus do
    begin
      result := pdate + j;
      if DayOpen(Result, True) then
        inc(i);
      inc(j);
    end;
end;

{===============================================================================
 Fonction     : GetStrDef
 Description  : renvoie la valeur "SetVal" si "S" = "SearchVal" si non la
                fonction renvoie "S".
===============================================================================}
function GetStrDef(Const S, SearchVal: String; Const SetVal: String = ''): String;
begin
  Result:= S;
  if S = SearchVal then
    Result:= SetVal;
end;

{===============================================================================
 Fonction     : FloatToCharacter
 Description  : renvoie la valeur en lettre d'une valeur en chiffre. Le parametre
                "DeviseName" permet de dire si c'est des €, $, etc...
===============================================================================}
function FloatToCharacter(Const Value: String; Const DeviseName: String): String;

  function IntToCharacter(const Value: integer): String;
  var
    vVal: integer;
    I: Word;
    C, D, U, Coef: Byte;
    Buffer: String;
    vNeg: Boolean;
  begin
    if Value = 0 then
      begin
        Result:= ' Zero';
        Exit;
      end;
    Result:= '';
    vVal:= Value;
    vNeg:= Value < 0;
    if vNeg then
      vVal:= - vVal;
    Coef:= 0;
    Repeat
      U:= vVal mod 10;
      vVal := vVal div 10;
      D:= vVal mod 10;
      vVal := vVal div 10;
      if D in [1,7,9] then
        begin
          Dec(D);
          Inc(U, 10);
        end;
      Buffer:= '';
      if D > 1 then
        begin
          Buffer:= ' ' + Dizaine[D];
          If (D < 8) and ((U = 1) or (U = 11)) then
            Buffer:= Buffer + ' et';
        end;
      if U > 16 then
        begin
          Buffer:= Buffer + ' ' + Unite[10];
          Dec(U,10);
        end;
      if U > 0 then
        Buffer:= Buffer + ' ' + Unite[U];
      If (Result = '') and (D = 8) and (U = 0) then
        Result:= 's';
      Result:= Buffer + Result;
      C:= vVal mod 10;
      vVal := vVal div 10;
      if C > 0 then
        begin
          Buffer:= '';
          if C > 1 then
            Buffer:= ' ' + Unite[C] + Buffer;
          Buffer:= Buffer + ' ' + Coefs[0];
          if (Result = '') and (C > 1) then
            Result:= 's';
          Result:= Buffer + Result;
        end;
      if vVal > 0 then
        begin
          Inc(Coef);
          I:= vVal mod 1000;
          if (I > 1) and (Coef > 1) then
            Result:= 's' + Result;
          if I > 0 then
            Result:= ' ' + Coefs[Coef] + Result;
          if (I= 1) and (Coef = 1) then
            Dec(vVal);
        end;
    until vVal = 0;
    if vNeg then
      Result:= 'Moins' + Result
    else
      Result[2]:= UpCase(Result[2]);
  end;

var
  i: integer;
  vValInt, vCents, vValChar, vDeviseName: string;
begin
  Result:= Value;
  if Result = '' then
    Exit;
  vDeviseName:= DeviseName;
  if vDeviseName[Length(vDeviseName)] <> 'S' then
    vDeviseName:= vDeviseName + 'S';
  i:= Pos(DecimalSeparator, Result);
  if i <> 0 then
    begin
      vValInt:= copy(Result, 1, (i-1));
      vValChar:= IntToCharacter(StrToInt(vValInt));
      vCents:= copy(Result, i+1, (Length(Result)-i));
      if StrToInt(vCents) > 0 then
        vCents:= ' et' + IntToCharacter(StrToInt(vCents)) + ' Cents'
      else
       vCents:= '';
      Result:= UpperCase(vValChar + ' ' + vDeviseName + vCents);
    end
  else
    begin
      vValInt:= copy(Result, 1, (length(Result)));
      vValChar:= IntToCharacter(StrToInt(vValInt));
      Result:= UpperCase(vValChar + ' ' + vDeviseName);
    end;
end;

{===============================================================================
 Fonction     : UpdateKindToStr
 Description  : permet la conversion du type UpdateKind en libelle.
===============================================================================}
function UpdateKindToStr(Const AUpdateKind: TUpdateKind): String;
begin
  case AUpdateKind of
    ukModify: Result:= 'Update';
    ukInsert: Result:= 'Insert';
    ukDelete: Result:= 'Delete';
  end;
end;

{===============================================================================
 Fonction     : PosAlignStringGrid
 Description  : permet le positionnement horizontal et vertical des valeurs de
                "AStringGrid" en fonction des parametres "ACol" et "ARow".
===============================================================================}
function PosAlignStringGrid(const AStringGrid: TStringGrid; const ACol, ARow: integer;
  Const AAlignCellH: TAlignCellH; Const AAlignCellV: TAlignCellV = acvCenter): TPoint;
var
  vSHeight, vSWidth, vRowHeight, vColWidth: integer;
  vRect: TRect;
  Buffer: String;
begin
  vRect:= AStringGrid.CellRect(ACol, ARow);
  Buffer:= AStringGrid.Cells[ACol, ARow];
  vSHeight:= AStringGrid.Canvas.TextHeight(Buffer);
  vSWidth:= AStringGrid.Canvas.TextWidth(Buffer);
  vRowHeight:= AStringGrid.RowHeights[ARow];
  vColWidth:= AStringGrid.ColWidths[ACol];
  case AAlignCellH of
    achLeft: Result.x:= vRect.Left + 2;
    achCenter: Result.x:= vRect.Left + (vColWidth - vSWidth) div 2;
    achRight: Result.x:= vRect.Right - vSWidth - 2;
  end;
  case AAlignCellV of
    acvTop: Result.y:= vRect.Top + 2;
    acvCenter: Result.y:= vRect.Top + ((vRowHeight - vSHeight) div 2);
    acvBottom: Result.y:= vRect.Bottom - vSHeight - 2;
  end;
end;

{===============================================================================
 Fonction     : ResizeText
 Description  : permet de retailler le text "S" en fonction d'une taille de
                Cellule et de Font.
===============================================================================}
function ResizeText(var S: String; Const SizeCell: integer;
  Const FontSize: integer = 8; Const NewResize: Boolean = False): Boolean;
var
  i, NbChar: integer;
  vSL, vSLResult: TStringList;
  vLine, Buffer, vBufOld: String;
  vPoint: TPoint;
  vReturn: Boolean;
begin
  vReturn:= True;
  if NewResize then
    S:= StringReplace(S, #$D#$A, '', [rfReplaceAll]);
  vBufOld:= S;
  vSL:= TStringList.create;
  vSLResult:= TStringList.create;
  try
    vSL.Text:= S;
    for i:= 0 to vSL.Count -1 do
      begin
        vLine:= vSL.Strings[i];
        vPoint:= TextSize(vLine);
        if vPoint.x > SizeCell then
          begin
            NbChar:= (SizeCell div FontSize) -1;
            while vReturn do
              begin
                if NbChar > Length(vLine) then
                  begin
                    NbChar:= Length(vLine);
                    vReturn:= False;
                  end;
                Buffer:= copy(vLine, 1, NbChar);
                Delete(vLine, 1, NbChar);
                vSLResult.Append(Buffer);
              end;
          end
        else
          vSLResult.Append(vLine);
      end;
    S:= vSLResult.Text;
    Result:= vSLResult.Count > 1;
    if not Result then
      S:= vBufOld;
  finally
    FreeAndNil(vSL);
    FreeAndNil(vSLResult);
  end;
end;

{===============================================================================
 Fonction     : TextSize
 Description  : permet de récuperer la haut et la largeur de "S" dans un retour
                de type TPoint. c'est à dire "x" = Largeur et "y" = Hauteur.
===============================================================================}
function TextSize(Const S: String; Const AFont: TFont = nil): TPoint;
var
  vDC: HDC;
  vRect: TRect;
  vImg: TBitmap;
begin
  vDC:= 0;
  vImg:= TBitmap.create;
  try
    if AFont <> nil then
      vImg.canvas.Font:= AFont;
    vRect.Left:= 0;
    vRect.Top:= 0;
    vRect.Right:= 0;
    vRect.Bottom:= 0;
    vDC:= GetDC(0);
    vImg.Canvas.Handle:= vDC;
    DrawText(vImg.Canvas.Handle, PChar(S), -1, vRect, (DT_EXPANDTABS or DT_CALCRECT));
    vImg.Canvas.Handle:= 0;
    Result.X:= vRect.Right - vRect.Left;
    Result.Y:= vRect.Bottom - vRect.Top;
  finally
    ReleaseDC(0, vDC);
    FreeAndNil(vImg);
  end;
end;

{===============================================================================
 Fonction     : PosAlign
 Description  : permet le positionnement horizontal et vertical de "S" en
                fonction du parametre "ARect".
===============================================================================}
function PosAlign(Const S: String; Const ARect: TRect; Const AAlignCellH: TAlignCellH;
  Const AAlignCellV: TAlignCellV = acvCenter;
  Const AFont: TFont = nil): TPoint;
var
  vHeight, vWidth: integer;
  vPoint: TPoint;
begin
  vHeight:= ARect.Bottom - ARect.Top;
  vWidth:= ARect.Right - ARect.Left;
  vPoint:= TextSize(S, AFont);
  case AAlignCellV of
    acvTop: Result.y:= ARect.Top + 2;
    acvCenter: Result.y:= ARect.Top + ((vHeight - vPoint.y) div 2);
    acvBottom: Result.y:= ARect.Bottom - vPoint.y - 2;
  end;
  case AAlignCellH of
    achLeft: Result.x:= ARect.Left + 2;
    achCenter: Result.x:= ARect.Left + (vWidth - vPoint.x) div 2;
    achRight: Result.x:= ARect.Right - vPoint.x - 2;
  end;
end;

{===============================================================================
 Fonction     : GetItemValue
 Description  : renvoie la valeur de l'item "AList" designé par "Index".
                si  "Index"  = -1 la fonction renvoie rien.
===============================================================================}
function GetItemValue(Const AList: TStrings; Const Index: integer): String;
begin
  Result:= '';
  if Index <> -1 then
    Result:= AList.Strings[Index];
end;

{===============================================================================
 procedure    : AppendItemsInListBox
 Description  : permet la creation du ou des items selectionnés du parametre
                "AListBoxSource" vers le parametre "AListBoxCible".
                le parametre "DeleteAfterAppend" permet de supprimer les items
                selectionnés de la source apres l'ajout dans la cible.
===============================================================================}
procedure AppendItemsInListBox(const AListBoxSource, AListBoxCible: TListBox;
  Const DeleteAfterAppend: Boolean);
var
  i: integer;
begin
  for i:= 0 to AListBoxSource.Items.Count -1 do
    begin
      if (AListBoxSource.Selected[i]) and (AListBoxCible.Items.IndexOf(AListBoxSource.Items.Strings[i]) = -1) then
        AListBoxCible.Items.AddObject(AListBoxSource.Items.Strings[i], AListBoxSource.Items.Objects[i]);
    end;
  if DeleteAfterAppend then
    DeleteItemsInListBox(AListBoxSource);
end;

{===============================================================================
 procedure    : DeleteItemsInListBox
 Description  : permet la suppression des items selectionnés du parametre "AListBox".
===============================================================================}
procedure DeleteItemsInListBox(const AListBox: TListBox);
var
  i: integer;
begin
  for i:= AListBox.Items.Count -1 Downto 0 do
    begin
      if AListBox.Selected[i] then
        AListBox.Items.Delete(i);
    end;
end;

{===============================================================================
 procedure    : CheckedListBox
 Description  : permet suivant la valeur du parametre "UnChecked" de coché ou
                de décocher tous les items du parametre "ACheckListBox"
===============================================================================}
procedure CheckedListBox(const ACheckListBox: TCheckListBox;
  Const UnChecked: Boolean);
var
  i: integer;
begin
  for i:= 0 to ACheckListBox.Items.Count -1 do
    ACheckListBox.Checked[i]:= not UnChecked;
end;

{===============================================================================
 procedure    : CheckedListToCheckList
 Description  : permet de cocher les items du parametre "ACheckListBoxCible" en
                fonction de la liste du parametre "AListSource".
===============================================================================}
procedure CheckedListToCheckList(const AListSource: TStringList;
  Const ACheckListBoxCible: TCheckListBox);
var
  i, Idx: integer;
begin
  for i:= 0 to AListSource.Count -1 do
    begin
      Idx:= ACheckListBoxCible.Items.IndexOf(AListSource.Strings[i]);
      if Idx <> -1 then
        ACheckListBoxCible.Checked[Idx]:= True;
    end;
end;

{===============================================================================
 procedure    : CheckedCheckListToList
 Description  : permet la recuperation dans le parametre "AListCible" de tous les
                items cochés du parametre "ACheckListBoxSource".
===============================================================================}
procedure CheckedCheckListToList(Const ACheckListBoxSource: TCheckListBox;
  const AListCible: TStringList);
var
  i: integer;
begin
  AListCible.Clear;
  for i:= 0 to ACheckListBoxSource.Items.Count -1 do
    begin
      if ACheckListBoxSource.Checked[i] then
        AListCible.Append(ACheckListBoxSource.Items.Strings[i]);
    end;
end;

{===============================================================================
 procedure    : GroupCheckInCheckListBox
 Description  : permet d'afficher tous les items cochés en debut de liste
===============================================================================}
procedure GroupCheckInCheckListBox(const ACheckListBox: TCheckListBox);
var
  i: integer;
  vSL, vSL1: TStringList;
begin
  vSL:= TStringList.Create;
  vSL1:= TStringList.Create;
  try
    for i:= 0 to ACheckListBox.Items.Count -1 do
      begin
        if ACheckListBox.Checked[i] then
          vSL1.Append(ACheckListBox.Items.Strings[i])
        else
          vSL.Append(ACheckListBox.Items.Strings[i]);
      end;
    ACheckListBox.Items.Text:= vSL1.Text + vSL.Text;
    for i:= 0 to vSL1.Count -1 do
      ACheckListBox.Checked[i]:= True;
  finally
    FreeAndNil(vSL);
    FreeAndNil(vSL1);
  end;
end;

{===============================================================================
 procedure    : WriteLog
 Description  : permet le tracage dans un fichier log du même nom que l'application.
===============================================================================}
procedure WriteLog(Const AExeName: String; Const Values: array of string;
  Const LogActif: Boolean);
var
  i: integer;
  vSL: TStringList;
  vFileName, vTime, Buffer: String;
begin
  if not LogActif then
    Exit;
  vSL:= TStringList.create;
  vFileName:= ChangeFileExt(AExeName, '.log');
  try
    if FileExists(vFileName) then
      vSL.LoadFromFile(vFileName);
    vTime:= FormatDateTime('dd/mm/yyyy - hh:nn:ss:zzz ==> ', Now);
    for i:= low(Values) to high(Values) do
      Buffer:= Buffer + ' - ' + Values[i];
    Buffer:= copy(Buffer, 4, Length(Buffer) -3);
    if Length(Values) > 0 then
      vSL.Append(vTime + Buffer);
    vSL.SaveToFile(vFileName);
  finally
    FreeAndNil(vSL);
  end;
end;

{===============================================================================
 fonction     : FindColumn
 Description  : permet la recuperation d'un objet "TListColumn" par son nom.
===============================================================================}
function FindColumn(Const ColumnName: String; Const ListColumns: TListColumns): TListColumn;
var
  i: Integer;
  vLstCol: TListColumn;
begin
  Result:= nil;
  for i:= 0 to ListColumns.Count -1 do
    begin
      vLstCol:= ListColumns.Items[i];
      if UpperCase(vLstCol.Caption) = UpperCase(ColumnName) then
        begin
          Result:= vLstCol;
          Break;
        end;
    end;
end;

{===============================================================================
 fonction     : LocateListItem
 Description  : A l'instar du Locate d'un Dataset la fonction "LocateListItem"
                permet la recuperation d'un objet "TListItem" d'un ListView suivant
                un ou plusieurs "KeyFields" et de leurs "Values".
===============================================================================}
function LocateListItem(Const AlistView: TListView; Const KeyFields, Values: String): TListItem;
var
  i, j, Idx: Integer;
  vSLFields, vSLVal, vSL: TStringList;
begin
  Result:= nil;
  if (KeyFields = '') or (Values = '') then
    Exit;
  vSLFields:= TStringList.Create;
  vSLVal:= TStringList.Create;
  vSL:= TStringList.Create;
  try
    vSLFields.Text:= StringReplace(KeyFields, ';', #13#10, [rfReplaceAll]);
    for i:= 0 to AlistView.Columns.Count -1 do
      begin
        Idx:= vSLFields.IndexOf(AlistView.Columns.Items[i].Caption);
        if Idx <> -1 then
          vSLFields.Strings[Idx]:= IntToStr(i);
      end;
    vSLVal.Text:= StringReplace(Values, ';', #13#10, [rfReplaceAll]);
    for i:= 0 to AlistView.Items.Count -1 do
      begin
        vSL.Clear;
        for j:= 0 to vSLFields.Count -1 do
          begin
            Idx:= StrToInt(vSLFields.Strings[j]);
            if Idx = 0 then
              vSL.Append(AlistView.Items.Item[i].Caption)
            else
              vSL.Append(AlistView.Items.Item[i].SubItems.Strings[Idx-1]);
          end;
        if vSL.Text = vSLVal.Text then
          begin
            Result:= AlistView.Items.Item[i];
            Break;
          end;
      end;
  finally
    FreeAndNil(vSLFields);
    FreeAndNil(vSLVal);
    FreeAndNil(vSL);
  end;
end;

{===============================================================================
 procedure    : DataSetToListView
 Description  : Permet le remplissage d'un "ListView" avec un "Dataset".
===============================================================================}
procedure DataSetToListView(Const ADataset: TDataSet; Const AlistView: TListView);
var
  i: integer;
  vLstCol: TListColumn;
  vLstItem: TListItem;
begin
  if not ADataset.Active then
    ADataset.Active:= True;
  if ADataset.RecordCount = 0 then
    Exit;
  AlistView.Clear;
  for i:= 0 to ADataset.FieldCount -1 do
    begin
      vLstCol:= FindColumn(ADataset.Fields[i].FieldName, AlistView.Columns);
      if vLstCol = nil then
        begin
          vLstCol:= AlistView.Columns.Add;
          //vLstCol.AutoSize:= True;
          vLstCol.Width:= 120;
          vLstCol.Caption:= ADataset.Fields[i].FieldName;
        end;
    end;
  ADataset.First;
  while not ADataset.Eof do
    begin
      vLstItem:= AlistView.Items.Add;
      vLstItem.Caption:= ADataset.Fields[0].AsString;
      for i:= 1 to ADataset.FieldCount -1 do
        vLstItem.SubItems.Add(ADataset.Fields[i].AsString);
      ADataset.Next;
    end;
end;

{===============================================================================
 procedure    : StringListToListView
 Description  : Permet le remplissage d'un "ListView" avec un "StringList"
                consideré comme un record. Il faut voir cette procedure comme un
                3 en 1 c'est à dire : un "Append", un "Edit" et un "Delete".
                - les parametes "KeyFields" et "KeyValues" permettent de faire
                  un locate donc un Update dans le listView.
                - le parametre permet la suppression de L'ItemList trouvé.
===============================================================================}
procedure StringListToListView(const Values: TStringList;
  const AlistView: TListView; Const KeyFields, KeyValues: String;
  Const DefaultImg: integer; Const Delete: Boolean);
var
  vLstItem: TListItem;
begin
  vLstItem:= LocateListItem(AlistView, KeyFields, KeyValues);
  if vLstItem = nil then
    vLstItem:= AlistView.Items.Add;
  if Delete then
    vLstItem.Delete
  else
    begin
      vLstItem.Caption:= Values.Strings[0];
      vLstItem.ImageIndex:= DefaultImg;
      Values.Delete(0);
      vLstItem.SubItems.Text:= Values.Text;
    end;
end;

{===============================================================================
 procedure    : EnterAsTabFormKeyPress
 Description  : Permet avec la touche "Enter" de passer le focus d'un composant
                à un autre suivant l'ordre de tabulation.
===============================================================================}
procedure EnterAsTabFormKeyPress(Sender: TForm; var Key: Char);
begin
  if Key = #13 then
    begin
      if (Sender.ActiveControl is TDBLookupComboBox) then
        begin
          if not TDBLookupComboBox(Sender.ActiveControl).ListVisible then
            Sender.Perform(WM_NEXTDLGCTL, 0, 0);
        end
      else
        if (Sender.ActiveControl is TDBGrid) then
          begin
            with TDBGrid(Sender.ActiveControl) do
              begin
                if selectedindex < (fieldcount -1) then
                  selectedindex:= selectedindex +1
                else
                  selectedindex:= 0;
              end;
          end
      else
        if not ((Sender.ActiveControl is TDBMemo) or (Sender.ActiveControl is TMemo) or
                (Sender.ActiveControl is TRichEdit) or (Sender.ActiveControl is TDBRichEdit))  then
          begin
            Key:= #0;
            Sender.Perform(WM_NEXTDLGCTL, 0, 0);
          end;
    end;
end;

{===============================================================================
 procedure    : EnterAsTabFormKeyPress
 Description  : Permet avec la touche "Enter" de passer le focus d'un composant
                à un autre suivant l'ordre de tabulation.
===============================================================================}
procedure EnterAsTabFormKeyPress(Sender: TForm; var Key: Word);
begin
  if Key = VK_RETURN then
    begin
      if (Sender.ActiveControl is TDBLookupComboBox) then
        begin
          if not TDBLookupComboBox(Sender.ActiveControl).ListVisible then
            Sender.Perform(WM_NEXTDLGCTL, 0, 0);
        end
      else
        if (Sender.ActiveControl is TDBGrid) then
          begin
            with TDBGrid(Sender.ActiveControl) do
              begin
                if selectedindex < (fieldcount -1) then
                  selectedindex:= selectedindex +1
                else
                  selectedindex:= 0;
              end;
          end
      else
        if not ((Sender.ActiveControl is TDBMemo) or (Sender.ActiveControl is TMemo) or
                (Sender.ActiveControl is TRichEdit) or (Sender.ActiveControl is TDBRichEdit)) then
          Sender.Perform(WM_NEXTDLGCTL, 0, 0);
    end;
end;

{===============================================================================
 procedure    : AppendItemsInListView
 Description  : Permet la copie d'un ou plusieurs Items d'un ListView vers un autre.
                - Idéal pour implémenter le Drag and Drop entre deux ListView.
===============================================================================}
procedure AppendItemsInListView(Const AListViewSource, AListViewCible: TListView);
var
  i: integer;
  vLI: TListItem;
begin
  for i:= 0 to AListViewSource.Items.Count -1 do
    begin
      if (AListViewSource.Items.Item[i].Selected) and (AListViewCible.Items.IndexOf(AListViewSource.Items.Item[i]) = -1) then
        begin
          vLI:= AListViewCible.Items.Add;
          vLI.Caption:= AListViewSource.Items.Item[i].Caption;
          vLI.ImageIndex:= AListViewSource.Items.Item[i].ImageIndex;
          vLI.SubItems.Text:= AListViewSource.Items.Item[i].SubItems.Text;
        end;
    end;
end;

{===============================================================================
 procedure    : DeleteItemsInListView
 Description  : Permet la suppresion d'un ou plusieurs Items selectionnés d'un
                ListView ou en fonction d'un ListView Modele.
 Exemple      : Prenons un ListView1 dans lequel il y a 3 Items (A, B, C)
                puis prenons un ListView2 dans lequel il y a 3 Items (C, D, E)
                Si l'on appel DeleteItemsInListView(ListView2, ListView1) la
                ListView2 n'aura plus que 2 Items (D, E).
===============================================================================}
procedure DeleteItemsInListView(const AListView: TListView;
  Const AListViewModel: TListView);
var
  i: integer;
begin
  for i:= AListView.Items.Count -1 Downto 0 do
    begin
      if AListViewModel = nil then
        begin
          if AListView.Items.Item[i].Selected then
            AListView.Items.Delete(i);
        end
      else
        begin
          if AListViewModel.FindCaption(0, AListView.Items.Item[i].Caption, False, True, True) <> nil then
            AListView.Items.Delete(i);
        end;
    end;
end;

{===============================================================================
 procedure    : AlignCell
 Description  : permet l'alignement horizontal et vertical des valeurs des
                cellules du parametre "AStringGrid".
                Le parametre "AFont" permet d'appliquer les notions de : Taille,
                Couleur, Style, etc...
===============================================================================}
procedure AlignCell(const AStringGrid: TStringGrid; const ACol, ARow: integer;
  Const AAlignCellH: TAlignCellH; Const AAlignCellV: TAlignCellV;
  Const AFont: TFont; Const MonoLine: Boolean);
var
  vRect: TRect;
  vPos: Tpoint;
  vFont: TFont;
  Buffer: String;
begin
  vRect:= AStringGrid.CellRect(ACol, ARow);
  Buffer:= AStringGrid.Cells[ACol, ARow];
  vFont:= AStringGrid.Canvas.Font;
  if AFont <> nil then
    AStringGrid.Canvas.Font:= AFont;
  if (not MonoLine) and (ResizeText(Buffer, vRect.Right - vRect.Left, vFont.Size)) then
    SetTextMultiligne(Buffer, AStringGrid.Canvas, vRect, AAlignCellH, AAlignCellV)
  else
    begin
      vPos:= PosAlignStringGrid(AStringGrid, ACol, ARow, AAlignCellH, AAlignCellV);
      AStringGrid.Canvas.TextRect(vRect, vPos.x, vPos.y, Buffer);
    end;
  AStringGrid.Canvas.Font:= vFont;
end;

{===============================================================================
 procedure    : SetTextMultiligne
 Description  : permet d'ecrire le text de "S" sur plusieurs lignes dans un
                Canvas avec les propriétés d'alignements.
===============================================================================}
procedure SetTextMultiligne(Const S: String; Const ACanvas: TCanvas; Const ARect: TRect;
  Const AAlignCellH: TAlignCellH; Const AAlignCellV: TAlignCellV = acvCenter);
var
  vRect: TRect;
  vTop, vLeft: Integer;
  vPoint: TPoint;
  vRgn: HRGN;
begin
  with ACanvas do
    begin
      Lock;
      vPoint:= PosAlign(S, ARect, AAlignCellH, AAlignCellV, Font);
      vTop:= vPoint.y;
      vLeft:= vPoint.x;
      vRect:= Bounds(vLeft, vTop, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
      FillRect(ARect);
      with ARect do
        vRgn:= CreateRectRgn(Left, Top, Right, Bottom);
      SelectClipRgn(Handle, vRgn);
      DrawText(Handle, PChar(S), -1, vRect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
      SelectClipRgn(Handle, 0);
      DeleteObject(vRgn);
      Unlock;
    end;
end;

{===============================================================================
 procedure    : MoveItemListBox
 Description  : permet le deplacement d'un item dans une ListBox.
===============================================================================}
procedure MoveItemListBox(Const AListBox: TListBox; Const AUp: Boolean);
var
  vNewIdx: integer;
begin
  AListBox.Sorted:= False;
  if AListBox.Count <= 1 then
    Exit;
  if AUp then
    vNewIdx:= AListBox.ItemIndex -1
  else
    vNewIdx:= AListBox.ItemIndex +1;
  if vNewIdx in [0..AListBox.Count -1] then
    begin
      AListBox.Items.Move(AListBox.ItemIndex, vNewIdx);
      AListBox.Selected[vNewIdx]:= True;
    end;
end;

{===============================================================================
 procedure    : StringGridClear
 Description  : permet de vide la StringGrid.
===============================================================================}
procedure StringGridClear(const AStringGrid: TStringGrid);
var
  i: integer;
begin
  for i:= 0 to AStringGrid.ColCount -1 do
    AStringGrid.Cols[i].Clear;
  AStringGrid.RowCount:= AStringGrid.FixedRows +1;
end;

{===============================================================================
 procedure    : NumberEditKeyPress
 Description  : permet la saisie exclusivement : numérique, DecimalSeparator,
                "enter", "Suppr" et "Del".
               - le parametre "AllowValueNeg" permet ou non de gérer les valeurs
                 négatives.
===============================================================================}
procedure NumberEditKeyPress(var Key: Char; Const AllowValueNeg: Boolean);
var
  vSysCharSet: TSysCharSet;
begin
  vSysCharSet:= ['0'..'9', '-', #27, #13, #8, DecimalSeparator];
  if not AllowValueNeg then
    vSysCharSet:= vSysCharSet - ['-'];
  if not (Key in vSysCharSet) then
    Key:= #0;
end;

{===============================================================================
 fonction     : GetVersion
 Description  : Renvoie le numero de version d'une application avec ou sans le
                numero de Build.
===============================================================================}
function GetVersion(Const FileName: String; Const WithBuild: Boolean): String;
Var
  vSize, vLen: DWord;
  Buffer, vVersion: PChar;
  vSL: TStringList;
begin
  Result:= '';
  Buffer:= '';
  vSize:= GetFileVersionInfoSize(PChar(FileName), vSize);
  if vSize > 0 then
    begin
      vSL:= TStringList.Create;
      try
        Buffer:= AllocMem(vSize);
        GetFileVersionInfo(PChar(FileName), 0, vSize, Buffer);
        if VerQueryValue(Buffer, PChar('\StringFileInfo\040C04E4\FileVersion'), Pointer(vVersion), vLen) then
          begin
            Result:= vVersion;
            if not WithBuild then
              begin
                vSL.Text:= StringReplace(Result, '.', #13#10, [rfReplaceAll]);
                vSL.Delete(vSL.Count -1);
                Result:= StringReplace(vSL.Text, #13#10, '.', [rfReplaceAll]);
                Result:= copy(Result, 1, Length(Result)-1);
              end;
          end;
      finally
        FreeMem(Buffer, vSize);
        FreeAndNil(vSL);
      end;
    end;
end;

{===============================================================================
 procedure    : GetFolderWindows
 Description  : Permet d'obtenir un chemin de répertoire Windows avec la
                valeur 'CSIDL'.
===============================================================================}
function GetFolderWindows(Const CSIDLValue: integer): String;
var
  vIdList: PITEMIDLIST;
  vFolder: array[0..MAX_PATH] of Char;
begin
  if not Failed(SHGetSpecialFolderLocation(0, CSIDLValue, vIdList)) then
    begin
      SHGetPathFromIDList(vIdList, vFolder);
      Result:= vFolder;
    end;
end;

{===============================================================================
 procedure    : InitializeIHM
 Description  : permet d'effectuer un certain nombre d'initialisation sur
                les composants d'une fiche.
 INFO         : "UseTag" = False : Tous les composants de "AForm" seront
                                   initialisés.
                "UseTag" = True  : Tous les composants avec le tag à 99 seront
                                   initialisés.
===============================================================================}
procedure InitializeIHM(Const AControl: TWinControl; Const UnInitialize: Boolean;
  Const UseTag: Boolean);
var
  i: integer;
  vAllow: Boolean;
  BufferBool, BufferColor: String;
begin
  BufferBool:= 'False';
  BufferColor:= IntToStr(clCream);
  if UnInitialize then
    begin
      BufferColor:= IntToStr(clWindow);
      BufferBool:= 'True';
    end;
  for i:= 0 to AControl.ComponentCount -1 do
    begin
      vAllow:= True;
      if (UseTag) and (AControl.components[i].Tag <> 99) then
        vAllow:= False;
      if vAllow then
        begin
          if AControl.Components[i] is TFrame then
            InitializeIHM(TFrame(AControl.Components[i]), UnInitialize, UseTag)
          else
            begin
              if not (AControl.components[i] is TCustomGroupBox) and
                 not (AControl.components[i] is TButtonControl) then
                begin
                  if (not IsPublishedProp(AControl.Components[i], 'DisabledColor')) and
                     (IsPublishedProp(AControl.Components[i], 'Color')) and
                     (PropIsType(AControl.Components[i], 'Color', tkInteger)) then
                    SetEnumProp(AControl.Components[i], 'Color', BufferColor);
                end;

              if (IsPublishedProp(AControl.Components[i], 'Enabled')) and
                 (PropIsType(AControl.Components[i], 'Enabled', tkEnumeration)) then
                SetEnumProp(AControl.Components[i], 'Enabled', BufferBool);
            end;
        end;
    end;
end;

{===============================================================================
 procedure    : SaveGridToXLS
 Description  : Exporte une cxGrid dans Excel
 Paramètres   : PromptSaveDialog : Ouvre une boite de dialogue pour un enregistrer sous
                AFileName        : Nom de sauvegarde du fichier si PromptSaveDialog à false
                OpenAfterSave    : Si true, ouvre Excel avec le fichier exporté
===============================================================================}
procedure SaveGridToXLS(ACxGrid: TCxGrid; Const OpenAfterSave: Boolean;
  const AFileName: string; Const PromptSaveDialog: Boolean);
var
	fn: string;
  Sd        : TSaveDialog;
  DoExport  : boolean;
begin
  DoExport := true;

  if PromptSaveDialog then
  begin
    Sd       := TSaveDialog.Create(nil);
    if AFileName <> '' then
       Sd.FileName := AFileName;
    DoExport := Sd.execute;
    fn       := Sd.FileName;
  end
  else
  begin
    if AFileName = '' then
    begin
      fn:= GetFolderWindows(CSIDL_PERSONAL) + '\tempo.xls';
//      fn:= extractfilepath(application.ExeName) + 'tempo.xls';
    end
    else
    begin
      fn := AFileName;
    end;
  end;

  try
    if DoExport then
    begin
      ExportGridToExcel(fn , ACxGrid);
      if OpenAfterSave then
      begin
        shellexecute(Application.handle , '' , pchar(fn) , '' , '' ,SW_SHOW);
      end;
    end;
  finally
    if PromptSaveDialog then
    begin
      FreeAndNil(Sd);
    end;
  end;
end;

{===============================================================================
 procedure    : MoveRec
 Description  : permet le deplacement des records d'un DataSet contenant un
                champ 'ORDRE'.
===============================================================================}
procedure MoveRec(Const ADataSet: TDataSet; Const Down: Boolean = False);
begin
  if (ADataSet = nil) or (not ADataSet.Active) or
     (ADataSet.FindField('ORDRE') = nil) or (ADataSet.RecordCount < 2) then
    Exit;
  ADataSet.DisableControls;
  try
  if not Down then
    begin
      { Up }
      if ADataSet.FieldByName('ORDRE').AsInteger > 1 then
        begin
          ADataSet.Edit;
          ADataSet.FieldByName('ORDRE').AsInteger:= ADataSet.FieldByName('ORDRE').AsInteger -1;
          ADataSet.Post;
          ADataSet.Prior;
          ADataSet.Edit;
          ADataSet.FieldByName('ORDRE').AsInteger:= ADataSet.FieldByName('ORDRE').AsInteger +1;
          ADataSet.Post;
          ADataSet.Prior;
        end;
    end
  else
    begin
      { Down }
      if ADataSet.FieldByName('ORDRE').AsInteger < ADataSet.RecordCount then
        begin
          ADataSet.Edit;
          ADataSet.FieldByName('ORDRE').AsInteger:= ADataSet.FieldByName('ORDRE').AsInteger +1;
          ADataSet.Post;
          ADataSet.Prior;
          ADataSet.Edit;
          ADataSet.FieldByName('ORDRE').AsInteger:= ADataSet.FieldByName('ORDRE').AsInteger -1;
          ADataSet.Post;
          ADataSet.Next;
        end;
    end;
  finally
    ADataSet.EnableControls;
  end;
end;

{===============================================================================
 procedure    : RecalcOrdre
 Description  : permet la renumérotation du champ 'ORDRE'. Utile apres une
                suppression de record.
===============================================================================}
procedure RecalcOrdre(Const ADataSet: TDataSet);
var
  vOrdre: Integer;
begin
  if (not ADataSet.Active) or (ADataSet.FindField('ORDRE') = nil) or (ADataSet.RecordCount < 2) then
    Exit;
  vOrdre:= ADataSet.RecordCount;
  ADataSet.Last;
  while not ADataSet.Bof do
    begin
      ADataSet.Edit;
      ADataSet.FieldByName('ORDRE').AsInteger:= vOrdre;
      ADataSet.Post;
      Dec(vOrdre);
      ADataSet.Prior;
    end;
end;

{===============================================================================
 procedure    : CloneClientDataSet
 Description  : permet de cloner un TClientDataSet de le remplir ou pas.
===============================================================================}
procedure CloneClientDataSet(Const ASource: TClientDataSet; var ACible: TClientDataSet;
  Const AppendData: Boolean);
var
  i, vSize: integer;
begin
  if ACible = nil then
    ACible:= TClientDataSet.Create(nil);

  { Creation des Fields }
  for i:= 0 to ASource.FieldCount - 1 do
    begin
      vSize:= 0;
      if ASource.Fields.Fields[i].DataType = ftString then
        vSize:= ASource.Fields.Fields[i].Size;
      ACible.FieldDefs.Add(ASource.Fields.Fields[i].FieldName, ASource.Fields.Fields[i].DataType, vSize);
    end;

  ACible.CreateDataSet;

  { Initialisation des property des Fields }
  for i:= 0 to ASource.FieldCount - 1 do
    begin
      ACible.Fields.Fields[i].DisplayLabel:= ASource.Fields.Fields[i].DisplayLabel;
      ACible.Fields.Fields[i].Visible:= ASource.Fields.Fields[i].Visible;
    end;

  { Creation des indexs }
  if (ASource.IndexName <> '') and (ASource.IndexDefs.Count <> 0) then
    begin
      for i:= 0 to ASource.IndexDefs.Count - 1 do
        ACible.IndexDefs.Add(ASource.IndexDefs.Items[i].Name, ASource.IndexDefs.Items[i].Fields, ASource.IndexDefs.Items[i].Options);
    end;

  ACible.IndexName:= ASource.IndexName;

  { Ajout des données de la source vers la cible }
  if AppendData then
    begin
      ASource.First;
      while not ASource.Eof do
        begin
          ACible.Append;
          for i:= 0 to ASource.FieldCount - 1 do
            ACible.Fields.Fields[i].Value:= ASource.Fields.Fields[i].Value;
          ACible.Post;
          ASource.Next;
        end;
      ACible.First;
    end;
end;

{===============================================================================
 procedure    : BatchRecord
 Description  : permet de transferer les données d'un Record de DataSet vers
                un autre DataSet.
===============================================================================}
procedure BatchRecord(Const ASource, ACible: TDataSet; Const AutoPost: Boolean = True);
var
  i: integer;
  vField: TField;
begin
  if (not ASource.Active) or (not ACible.Active) then
    Exit;
  if ACible.State = dsBrowse then
    ACible.Append;
  for i:= 0 to ASource.FieldCount - 1 do
    begin
      vField:= ACible.FindField(ASource.Fields.Fields[i].FieldName);
      if vField <> nil then
        vField.Value:= ASource.Fields.Fields[i].Value;
    end;
  if AutoPost then
    ACible.Post;
end;

{===============================================================================
 procedure    : BatchMove
 Description  : permet de transferer les données d'un DataSet vers un autre.
===============================================================================}
procedure BatchMove(Const ASource, ACible: TDataSet; Const AutoPost: Boolean);
begin
  if not ACible.Active then
    Exit;
  if not ASource.Active then
    ASource.Open;
  ASource.DisableControls;
  ACible.DisableControls;
  try
    ASource.First;
    while not ASource.Eof do
      begin
        BatchRecord(ASource, ACible, AutoPost);
        ASource.Next;
      end;
  finally
    if AutoPost then
      ACible.First;
    ASource.EnableControls;
    ACible.EnableControls;
  end;
end;

{===============================================================================
 procedure    : DataSetToFile
 Description  : permet d'exporter les données d'un DataSet dans un fichier.
===============================================================================}
procedure DataSetToFile(Const ADS: TDataSet; Const AFileName, ASep: String);
var
  i: integer;
  vSL: TStringList;
  vField: TField;
  Buffer: String;
begin
  if not ADS.Active then
    Exit;
  vSL:= TStringList.Create;
  try
    ADS.First;
    while not ADS.Eof do
      begin
        Buffer:= '';
        for i:= 0 to ADS.FieldCount - 1 do
          begin
            vField:= ADS.FindField(ADS.Fields.Fields[i].FieldName);
            if vField <> nil then
              Buffer:= Buffer + ADS.Fields.Fields[i].AsString + ASep;
          end;

        if Buffer <> '' then
          vSL.Append(Buffer);

        ADS.Next;
      end;

    if vSL.Count <> 0 then
      vSL.SaveToFile(AFileName);
  finally
    FreeAndNil(vSL);
  end;
end;

{===============================================================================
 procedure    : EmptyClientDataSet
 Description  : permet de vider un TClientDataSet avec un parametre de type TDataSet.
===============================================================================}
procedure EmptyClientDataSet(Const ADataSet: TDataSet);
begin
  if (ADataSet <> nil) and (ADataSet is TClientDataSet) then
    TClientDataSet(ADataSet).EmptyDataSet;
end;

{===============================================================================
 procedure    : SendMail
 Description  : permet d'envoyer un mail.
===============================================================================}
procedure SendMail(const AHost, APassword, AFrom, AFromAdrMail, AFromAdrMailReply,
  ASujet: String; const ARecipients, AMessage: TStrings;
  Const AAttachmentList: TStrings; Const AFileIsTempFile: Boolean;
  Const ACCList, ABCCList: TStrings; Const APort: integer);
var
  i: integer;
  vEMail: TIdSMTP;
  vMess: TIdMessage;
//  vAttachment: TIdAttachmentFile;
  Buffer: String;
begin
  vEMail:= TIdSMTP.Create(nil);
  vMess:= TIdMessage.Create(vEMail);
  try
    vMess.Organization:= 'Ginkoia';

    { From }
    vMess.From.Text:= AFrom;
    vMess.From.Address:= AFromAdrMail;
    Buffer:= AFromAdrMailReply;
    if Buffer = '' then
      Buffer:= AFromAdrMail;
    vMess.ReplyTo.EMailAddresses:= Buffer;

    { To }
    if (ARecipients = nil) or (ARecipients.Count = 0) then
      Raise Exception.Create('Ce mail n''a aucun destinataire.');
    for i:= 0 to ARecipients.Count - 1 do
      vMess.Recipients.Add.Address:= ARecipients.Strings[i];

    { CC }
    if ACCList <> nil then
      begin
        for i:= 0 to ACCList.Count - 1 do
          vMess.CCList.Add.Address:= ACCList.Strings[i];
      end;

    { BCC }
    if ABCCList <> nil then
      begin
        for i:= 0 to ABCCList.Count - 1 do
          vMess.BccList.Add.Address:= ABCCList.Strings[i];
      end;

    { Sujet }
    vMess.Subject:= ASujet;

    { Message }
    if AMessage <> nil then
      vMess.Body.Text:= AMessage.Text;

    { Attachment }
    if AAttachmentList <> nil then
      begin
        for i:= 0 to AAttachmentList.Count - 1 do
          begin
            if FileExists(AAttachmentList.Strings[i]) then
              begin
//                vAttachment:= TIdAttachmentFile.Create(vMess.MessageParts, AAttachmentList.Strings[i]);
//                vAttachment.FileIsTempFile:= AFileIsTempFile;
              end;
          end;
      end;

    { Parametres Mail }
//    vEMail.AuthType:= satDefault; //satNone;
    vEMail.Username:= AFrom;
    vEMail.UseEhlo:= False;
    vEMail.Host:= AHost;
    vEMail.Port:= APort;
    vEMail.Password:= APassword;
    vEMail.MailAgent:= Application.Title;
    vEMail.Connect;

    { Post Mail }
    if vEMail.Connected then
      vEMail.Send(vMess)
    else
      Raise Exception.Create('Envoi impossible, problème de connexion.');
  finally
    vEMail.Disconnect;
    FreeAndNil(vEMail);
  end;
end;

procedure SendMailLite(const ARecipients, ASubject, ABody, AHost, AUser, APassword: string; const APort: Integer);
var
  SMTP        : TIdSMTP;
  IdMessage   : TIdMessage;
  IdSSL       : TIdSSLIOHandlerSocketOpenSSL;
begin
  SMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Try
    Try
      IdSSL.SSLOptions.Method    := sslvTLSv1;
      IdSSL.SSLOptions.Mode      := sslmUnassigned;

      IdMessage.Clear;
      IdMessage.ContentType := 'multipart/mixed';
      IdMessage.Subject := ASubject;
      IdMessage.Body.Text := ABody;

      IdMessage.From.Text := AUser;
      IdMessage.Recipients.EMailAddresses := ARecipients;

      SMTP.IOHandler  := IdSSL;
      SMTP.UseTLS     := utUseExplicitTLS;
      SMTP.Host       := AHost;
      SMTP.Username   := AUser;
      SMTP.Password   := APassword;

      Try
        SMTP.Port := APort;
        SMTP.Connect;
      Except on E:Exception do
        begin
          try
            SMTP.Port := 25;
            SMTP.Connect;
          Except
          end;
        end;
      End;

      SMTP.Send(IdMessage);

    Except
    End;
  finally
    SMTP.Free;
    IdMessage.Free;
    IdSSL.Free;
    if SMTP.Connected then
      SMTP.Disconnect(True);
  End;
end;

{===============================================================================
 function     : ExecAndWaitProcess
 Description  : Execute un process et attend la fin de traitement de ce dernier.
===============================================================================}
function ExecAndWaitProcess(Const AFileName, AParams, ADirectory: String; var AError: String;
  Const AUsedByThread: Boolean): integer;
var
  vSeInfos: SHELLEXECUTEINFO;
  vProcessRet: Cardinal;
begin
  Result:= -1;
  AError:= '';

  ZeroMemory(@vSeInfos, SizeOf(vSeInfos));
  vSeInfos.cbSize := SizeOf(vSeInfos);
  vSeInfos.fMask := SEE_MASK_NOCLOSEPROCESS;
  vSeInfos.Wnd := 0;
  vSeInfos.lpVerb := 'open';
  vSeInfos.lpFile := PWideChar(AFileName);
  vSeInfos.lpParameters := PWideChar(AParams);
  vSeInfos.lpDirectory := PWideChar(ADirectory);
  vSeInfos.nShow := SW_HIDE;

  if not ShellExecuteEx(@vSeInfos) then
    begin
      Result:= GetLastError;
      AError:= 'Code : "' + IntToStr(Result) + '" - Libelle : "' + SysErrorMessage(Result) + '"';
    end
  else
    begin
      while WaitForSingleObject(vSeInfos.hProcess, 1000) = WAIT_TIMEOUT do
        begin
          if AUsedByThread then
            Sleep(1000)
          else
            Application.ProcessMessages;
        end;

      if GetExitCodeProcess(vSeInfos.hProcess, vProcessRet) then
        Result:= vProcessRet;

      AError:= 'Retour du process : "' + IntToStr(Result) + '"';

      CloseHandle(vSeInfos.hProcess);
    end;
end;

{===============================================================================
 function     : GetUserNameWindows
 Description  : permet de recuperer le nom d'utilisateur de windows.
===============================================================================}
function GetUserNameWindows: String;
var
  vUserName: array[0..80] of Char;
  vSize: DWORD;
begin
  vSize:= SizeOf(vUserName);
  GetUserName(vUserName, vSize);
  Result:= vUserName;
end;

{===============================================================================
 function     : GetComputerNameLocal
 Description  : permet de recuperer le nom de l'ordinateur visible sur le
                reseau local.
===============================================================================}
function GetComputerNameLocal: string;
var
  vlpBuffer: array[0..MAX_COMPUTERNAME_LENGTH] of char;
  vSize: dword;
begin
  vSize:= Length(vlpBuffer);
  if GetComputerName(vlpBuffer, vSize) then
    Result:= vlpBuffer
  else
    Result:= '';
end;

{===============================================================================
 Function     : getValeurParametre
 Description  : Renvoie la valeur du paramètre de ligne de commande donné
===============================================================================}
function GetValeurParametre(const AParamName: String): String;
var
  i: integer;
  vParamItem, vParamPrefix: String;
begin
  Result:= '';
  vParamPrefix:= AParamName + '=';
  if ParamCount > 0 then
    begin
      for i:= 1 to ParamCount do
        begin
          vParamItem:= ParamStr(i);
          if UpperCase(copy(vParamItem, 2, Length(vParamPrefix))) = UpperCase(vParamPrefix) then
            begin
              Result:= Copy(vParamItem, length(vParamPrefix)+2, length(vParamItem)-length(vParamPrefix));
              Break;
            end;
        end;
    end;
end;

{===============================================================================
 Function     : DeleteDirectory
 Description  : Permet la suppression d'un repertoire et son contenu
===============================================================================}
function DeleteDirectory(Const ADir: String): Boolean;
var
  vFOS: TSHFileOpStruct;
begin
  ZeroMemory(@vFOS, SizeOf(vFOS));

  vFOS.wFunc:= FO_DELETE;
  vFOS.fFlags:= FOF_SILENT or FOF_NOCONFIRMATION;
  vFOS.pFrom:= PChar(ADir + #0);

  Result:= ShFileOperation(vFOS) = 0;
end;

function IsInteger(Const S: String): Boolean;
var
  i: integer;
begin
  Result:= True;
  for i:= 1 to Length(S) do
    begin
      if not (S[i] in ['0'..'9']) then
        begin
          Result:= False;
          Break;
        end;
    end;
end;

function GetBoxFolder(AOwnerHdl: THandle; var AFolder: string; const ATitle: string;
  Const AddBtnNewFolder: Boolean): boolean;
var
  vDisplayname: array[0..MAX_PATH] of char;
  vBi: TBrowseInfo;
  vPidl: PItemIdList;

const
  BIF_BROWSEINCLUDEURLS  = $0080;
  BIF_BROWSEINCLUDEFILES = $4000;
  BIF_SHAREABLE          = $8000;
  BIF_RETURNFSANCESTORS  = $0008;
  BIF_EDITBOX            = $0010;
  BIF_VALIDATE           = $0020;
  BIF_NEWDIALOGSTYLE     = $0040;

  function StripPathSlash(const APath: String): string;
  var
    i: integer;
  begin
    Result:= APath;
    i:= Length(APath);
    if (i > 3) and (APath[i] = '\') then
      SetLength(Result, i-1);
  end;

  function BrowseProc(Ahwnd: HWnd; AMsg: integer; AlParam, AlpData: LPARAM): integer; stdcall;
  var
    vDir: array[0..MAX_PATH] of char;
  begin
    case AMsg of
      BFFM_INITIALIZED:
        begin
          SendMessage(Ahwnd, BFFM_SETSTATUSTEXT, 0, AlpData);
          SendMessage(Ahwnd, BFFM_SETSELECTION, 1, AlpData);
        end;
      BFFM_SELCHANGED:
        begin
          if(SHGetPathFromIDList(PItemIDList(AlParam), vDir)) then
            SendMessage(Ahwnd, BFFM_SETSTATUSTEXT, 0, integer(@vDir[0]));
        end;
    end;
    Result:= 0;
  end;

begin
  CoInitialize(NIL);
  vBi.hWndOwner:= AOwnerHdl;
  vBi.pIDLRoot:= nil;
  vBi.pszDisplayName := pchar(@vDisplayname[0]);
  vBi.lpszTitle:= pchar(ATitle);
  if AddBtnNewFolder then
    vBi.ulFlags:= BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT or BIF_NEWDIALOGSTYLE
  else
    vBi.ulFlags:= BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT;
  if AFolder = '' then
    begin
      vBi.lpfn:= nil;
      vBi.lParam:= 0;
    end
  else
    begin
      AFolder := StripPathSlash(AFolder);
      vBi.lpfn := @BrowseProc;
      vBi.lParam := integer(pchar(AFolder));
    end;
  vBi.iImage := 0;
  vPidl:= SHBrowseForFolder(vBi);
  Result:= vPidl <> nil;
  if not Result then
    Exit;
  try
    Result:= SHGetPathFromIDList(vPidl, pchar(@vDisplayname[0]));
    AFolder:= vDisplayname;
  finally
    CoTaskMemFree(vPidl);
  end;
end;

{===============================================================================
 Fonction     : GetProcessusRUN
 Description  : permet d'obtenir une liste des processus actifs avec leurs details
===============================================================================}
function GetProcessusRUN(Const NameAppli: String; Const Alist: TStringList;
  Const WithDetail: Boolean = False): Cardinal;
var
  vSnaph: THandle;
  vProc: TProcessEntry32;
  Buffer, vNameAppli: String;
Const
  RC = #13#10;
  ProcessusDetail = '   ExeFile = %s' + RC + '   Size = %x' + RC + '   cntUsage = %x' + RC +
                    '   th32ProcessID = %x' + RC + '   th32DefaultHeapID = %x' + RC + '   th32ModuleID = %x' + RC +
                    '   cntThreads = %x' + RC + '   th32ParentProcessID = %x' + RC + '   pcPriClassBase = %x' + RC +
                    '   Flags = %x' + RC;

  function ControlSyntaxeEXE(Const S: ShortString): ShortString;
  var
    Buffer: String;
  begin
    Result:= S;
    Buffer:= copy(S, Length(S) -3, 4);
    if UpperCase(Buffer) <> '.EXE' then
      Result:= Result + '.EXE';
  end;

  procedure SetDetail;
  begin
    Buffer:= vProc.szExeFile;
    if (Trim(NameAppli) <> '') and (UpperCase(Buffer) = vNameAppli) then
      Result:= vProc.th32ProcessID;
    if WithDetail then
      begin
        with vProc do
          Buffer:= Format(ProcessusDetail, [szExeFile, dwSize, cntUsage, th32ProcessID,
                                            th32DefaultHeapID, th32ModuleID, cntThreads,
                                            th32ParentProcessID, pcPriClassBase, dwFlags]);
      end;
    if Assigned(Alist) then
      Alist.Append(Buffer);
  end;

begin
  Result:= 0;
  vNameAppli:= UpperCase(ControlSyntaxeEXE(NameAppli));
  vProc.dwSize:= sizeof(vProc);
  vSnaph:= CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  try
    if Assigned(Alist) then
      Alist.Clear;
    Process32First(vSnaph, vProc);
    SetDetail;
    while Process32Next(vSnaph, vProc) do
      SetDetail;
  finally
    CloseHandle(vSnaph);
  end;
end;

{===============================================================================
 Fonction     : IsApplicationRUN
 Description  : permet de savoir si un processus est actif et de l'arreter ou non.
===============================================================================}
function IsApplicationRUN(Const NameApplication: ShortString; Const ATerminateProcess: Boolean = False): Boolean;
var
  vHdlProc: THandle;
  vId: Cardinal;
begin
  vId:= GetProcessusRUN(NameApplication, nil);
  Result:= vId <> 0;
  if (ATerminateProcess) and (Result) then
    begin
      vHdlProc:= OpenProcess(PROCESS_ALL_ACCESS, True, vId);
      Result:= TerminateProcess(vHdlProc, vId);
    end;
end;

{===============================================================================
 Fonction     : UpDirectory
 Description  : permet de remonter les niveaux d'un chemin.
===============================================================================}
function UpDirectory(Const ADir: String; Const ANbNiv: Integer): String;
var
  i, vCpt: integer;
begin
  Result:= ADir;
  if Result = '' then
    Exit;

  Result:= ExcludeTrailingBackslash(Result);

  vCpt:= 0;
  for i:= Length(Result)-1 Downto 0 do
    begin
      if ADir[i] = '\' then
        begin
         Inc(vCpt);
         if vCpt = ANbNiv then
           begin
             Result:= copy(Result, 1, i-1);
             Break;
           end;
        end;
    end;
end;

{===============================================================================
 Procedure    : SendFileToFTP
 Description  : permet d'envoyer un fichier sur un serveur FTP.
===============================================================================}
procedure SendFileToFTP(Const AUserName, APassword, AHost, ARemoteDir,
  ALocalPathAndFileName: String; Const AProxySettings: TIdFtpProxySettings;
  Const DeleteAfterSend: Boolean; Const APort: integer; Const AUseTLS: TIdUseTLS);
var
  vIdFTP: TIdFTP;
begin
  vIdFTP:= TIdFTP.Create(nil);
  try
    vIdFTP.Username:= AUserName;
    vIdFTP.Password:= APassword;
    vIdFTP.Host:= AHost;
    vIdFTP.Port:= APort;
    vIdFTP.UseTLS:= AUseTLS;
    if AProxySettings <> nil then
      vIdFTP.ProxySettings:= AProxySettings;
    vIdFTP.Connect;
    if not vIdFTP.Connected then
      Raise Exception.Create('Connexion FTP impossible.');
    vIdFTP.ChangeDir(ARemoteDir);
    vIdFTP.Put(ALocalPathAndFileName, ExtractFileName(ALocalPathAndFileName));
    if (DeleteAfterSend) and (FileExists(ALocalPathAndFileName)) then
      DeleteFile(ALocalPathAndFileName);
  finally
    if vIdFTP.Connected then
      vIdFTP.Disconnect;
    FreeAndNil(vIdFTP);
  end;
end;

{===============================================================================
 Procedure    : DownloadByFTP
 Description  : permet le téléchargement d'un fichier depuis un serveur FTP.
===============================================================================}
procedure DownloadByFTP(Const AUserName, APassword, AHost, ARemoteDir, ALocalDest, AFileName: String;
  Const DeleteAfterDownload: Boolean = False; Const AProxySettings: TIdFtpProxySettings = nil;
  Const AFileList: TStringList = nil; Const APort: integer = 21;
  Const AProgess: TProgressBar = nil; Const AUseTLS: TIdUseTLS = utNoTLSSupport);
var
  i, idx: integer;
  vIdFTP: TIdFTP;
  Buffer: String;
  vIsDot, vIsDoubleDot: Boolean;
begin
  vIdFTP:= TIdFTP.Create(nil);
  try
    if AFileList <> nil then
      AFileList.Clear;
    vIdFTP.Username:= AUserName;
    vIdFTP.Password:= APassword;
    vIdFTP.Host:= AHost;
    vIdFTP.Port:= APort;
    vIdFTP.UseTLS:= AUseTLS;
    vIdFTP.TransferType:= ftBinary;
    if AProxySettings <> nil then
      vIdFTP.ProxySettings:= AProxySettings;
    vIdFTP.Connect;
    if not vIdFTP.Connected then
      Raise Exception.Create('Connexion FTP impossible.');
    vIdFTP.ChangeDir(ARemoteDir);
    vIdFTP.List;

    vIsDot:= False;
    vIsDoubleDot:= False;
    i:= 0;
    while i < vIdFTP.DirectoryListing.Count do
      begin
        if Trim(vIdFTP.DirectoryListing[i].FileName) = '.' then
          begin
            vIdFTP.DirectoryListing.Delete(i);
            vIsDot:= True;
          end;
        if Trim(vIdFTP.DirectoryListing[i].FileName) = '..' then
          begin
            vIdFTP.DirectoryListing.Delete(i);
            vIsDoubleDot:= True;
          end;
        if vIsDot and vIsDoubleDot then
          Break;
        Inc(i);
      end;

    if vIdFTP.DirectoryListing.Count = 0 then
      Exit;

    if AProgess <> nil then
      begin
        AProgess.Position:= 0;
        AProgess.Max:= vIdFTP.DirectoryListing.Count -1;
      end;

    for i:= 0 to vIdFTP.DirectoryListing.Count - 1 do
      begin
        Buffer:= vIdFTP.DirectoryListing[i].FileName;
        if Trim(Buffer) <> '' then
          begin
            Idx:= Pos(UpperCase(AFileName), UpperCase(Buffer));
            if Idx <> 0 then
              begin
                vIdFTP.Get(Buffer, ALocalDest + Buffer, True, False);

                if DeleteAfterDownload then
                  vIdFTP.Delete(Buffer);

                if AFileList <> nil then
                  AFileList.Append(ALocalDest + Buffer);

                if AProgess <> nil then
                  AProgess.Position:= AProgess.Position +1;
              end;
          end;
      end;
  finally
    if vIdFTP.Connected then
      vIdFTP.Disconnect;
    FreeAndNil(vIdFTP);
  end;
end;

{===============================================================================
 Procedure    : OnClickColumnHeaderForSearch
 Description  : permet la recherche partielle sur une colonne.
 INFO         : Pour activer cette option, il faut mettre la property
                OptionsBehavior.IncSearch à True dans l'inspecteur d'objet.
===============================================================================}
procedure OnClickColumnHeaderForSearch(Const AGridTableView: TcxGridTableView;
  Const AColumn: TcxGridColumn; Const AColorSearch: TcxStyle);
var
  i: integer;
begin
  if not AGridTableView.OptionsBehavior.IncSearch then
    Exit;
  for i:= 0 to AGridTableView.ColumnCount - 1 do
    begin
      if AGridTableView.Columns[i].Visible then
        AGridTableView.Columns[i].Styles.Header:= nil;
    end;
  AGridTableView.OptionsBehavior.IncSearchItem:= AColumn;

  { Permet de coloriser le Header de recherche
    INFO : fonctionne uniquement si la property LookAndFeel.King <> lfOffice11 }
  TcxGridDBColumn(AColumn).Styles.Header:= AColorSearch;
end;

{===============================================================================
 Procedure    : CloneProperty
 Description  : permet la copie des property published d'un composant vers un
                autre du même ancêtre.
===============================================================================}
procedure CloneProperty(Const InstanceSource, InstanceCible: TObject);
var
  i, index, Count, Count2: Integer;
  Buffer: String;
  BufferExt: Extended;
  BufferWS: WideString;
  BufferV: Variant;
  BufferInt64: Int64;
  vMethode: TMethod;
  vObj: TObject;
  PropInfoSource, PropInfoCible: PPropInfo;
  TempList, TempList2: PPropList;
begin
  Count:= GetPropList(InstanceSource, TempList);
  Count2:= GetPropList(InstanceCible, TempList2);
  if (Count > 0) and (Count2 > 0) and (Count = Count2) then
    begin
      for i:= 0 to Count -1 do
        begin
          PropInfoSource:= TempList^[i];
          PropInfoCible:= TempList2^[i];
          if (Assigned(PropInfoSource^.GetProc)) and (Assigned(PropInfoSource^.SetProc)) then
            begin
              if PropInfoSource^.PropType^.Kind = tkClass then
                begin
                  vObj:= GetObjectProp(InstanceSource, PropInfoSource);
                  SetObjectProp(InstanceCible, PropInfoSource, vObj);
                end
              else
                begin
                  if (PropInfoSource^.Name = PropInfoCible^.Name) and
                     (UpperCase(PropInfoSource^.Name) <> 'NAME') then
                    begin
                      case PropInfoSource.PropType^.Kind of
                        tkInteger:
                          begin
                            index:= GetOrdProp(InstanceSource, PropInfoSource);
                            SetOrdProp(InstanceCible, PropInfoSource, index);
                          end;
                        tkEnumeration:
                          begin
                             Buffer:= GetEnumProp(InstanceSource, PropInfoSource);
                             if UpperCase(PropInfoSource^.Name) <> 'ACTIVE' then
                               SetEnumProp(InstanceCible, PropInfoSource, Buffer);
                          end;
                        tkFloat:
                          begin
                            BufferExt:= GetFloatProp(InstanceSource, PropInfoSource);
                            SetFloatProp(InstanceCible, PropInfoSource, BufferExt);
                          end;
                        tkString, tkUString, tkLString:
                          begin
                            Buffer:= GetStrProp(InstanceSource, PropInfoSource);
                            SetStrProp(InstanceCible, PropInfoSource, Buffer);
                          end;
                        tkSet:
                          begin
                            Buffer:= GetSetProp(InstanceSource, PropInfoSource);
                            SetSetProp(InstanceCible, PropInfoSource, Buffer);
                          end;
                        tkMethod:
                          begin
                            vMethode:= GetMethodProp(InstanceSource, PropInfoSource);
                            SetMethodProp(InstanceCible, PropInfoSource, vMethode);
                          end;
                        tkWString:
                          begin
                            BufferWS:= GetWideStrProp(InstanceSource, PropInfoSource);
                            SetWideStrProp(InstanceCible, PropInfoSource, BufferWS);
                          end;
                        tkVariant:
                          begin
                            BufferV:= GetVariantProp(InstanceSource, PropInfoSource);
                            SetVariantProp(InstanceCible, PropInfoSource, BufferV);
                          end;
                        tkInt64:
                          begin
                            BufferInt64:= GetInt64Prop(InstanceSource, PropInfoSource);
                            SetInt64Prop(InstanceCible, PropInfoSource, BufferInt64);
                          end;
                      end;
                    end;
                end;
            end;
        end;
    end;
end;

{===============================================================================
 Procedure    : CompareVersion
 Description  : permet la comparaison entre deux version afin de determiner
                si "AVER_1" est > à "AVER_2".

 RESULT        -1 : "AVER_1" n'a pas un format correct.
                0 : "AVER_1" = "AVER_2".
                1 : "AVER_1" > "AVER_2"
                2 : "AVER_1" < "AVER_2"
===============================================================================}
function CompareVersion(const AVER_1, AVER_2: String): integer;
var
  i: integer;
  vVer1, vVer2: TStringList;
begin
  Result:= -1;

  if AVER_1 = AVER_2 then
    begin
      Result:= 0;
      Exit;
    end;

  vVer1:= TStringList.Create;
  vVer2:= TStringList.Create;
  try
    if Length(AVER_1) < 7 then
      Exit;

    vVer1.Text:= StringReplace(AVER_1, '.', #13#10, [rfReplaceAll]);
    vVer2.Text:= StringReplace(AVER_2, '.', #13#10, [rfReplaceAll]);

    for i:= 0 to vVer1.Count -1 do
      begin
        if StrToInt(vVer1.Strings[i]) > StrToInt(vVer2.Strings[i]) then
          begin
            Result:= 1;
            Break;
          end
        else
          if StrToInt(vVer1.Strings[i]) < StrToInt(vVer2.Strings[i]) then
            begin
              Result:= 2;
              Break;
            end;
      end;

  finally
    FreeAndNil(vVer1);
    FreeAndNil(vVer2);
  end;
end;

end.

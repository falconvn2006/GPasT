{ ==============================================================================
    SQLLocal DB :
    ���Ӿȿ��� ���Ǵ� ����Ÿ���̽��� �о���̴� Ŭ���� ����
        StdItems    : ������  ����
        Monster     : ���� ����
        MonsterItem : ���Ͱ� ������ ������ ����
        Magic       : ��� (����) ����

    �ܺ� ȭ��   : .\!DBSETUP.TXT    : DB ���� ����
        ALIAS NAME=                 : BDE Alias Setting
        SERVER NAME=                : Name or IP
        DATABASE NAME=              : Resource DataBase Name
        USER NAME=                  : DB Owner's User Name
        PASSWORD=                   : Password
        TABLE_STDITEMS=             : Table Name of StdItems
        TABLE_MONSTER=              : Table Name of Monster
        TABLE_MOBITEM=              : Table Name of Monster's Drop Items
        TABLE_MAGIC=                : Table Name of Magic

    Ŭ���� ����
        TDataMgr        =  Base Class of Data Manager ( Don't Use Directly )
        TItemMgr        = class of TDataMgr
        TMonsterMgr     = class of TDataMgr
        TMonsterItemMgr = class of TDataMgr
        TMagicMgr       = class of TDAtaMgr

    �ۼ��� : �ڴ뼺 ,2003.2.24
===============================================================================}
unit SQLLocalDB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, Grobal2, HUtil32, ADODB;

const
  LinkInfoFileName = '.\!DBSETUP.TXT';

type
  TLoadType = (ltFILE, ltSQL); // �����͸� �д¹�� ���� , FILE OR SQL
  PInteger  = ^integer;
  PString   = ^string;

  TSQLDetails = record
    Alias:    string;
    Server:   string;
    Database: string;
    User:     string;
    Pass:     string;

  end;

  // Base Class --------------------------------------------------------------
  TDataMgr = class(TObject)
  private
    FInfos:      TStringList;   // ������������ ������ ����� ����
    FLoadType:   TLoadType;     // �����͸� �д� ���
    FLinkInfo:   TStringList;   // DB ���� ����
    FQuery:      TAdoQuery;     // DB �� ����� ����
    FCompareStr: string;        // �񱳹��� ���� ��Ʈ��
    FDataBase:   TADOConnection;// BDE �� ������ �����ͺ��̽�
    FConnected:  boolean;       // DataBase �� �������� �Ǵ�

    FTableName:      string;       // ���̺� �̸�
    FTableNameIndex: string;       // �ܺ��������� ���̺��̸��� ã�� �ε���

    procedure AddBDEalias(SQLDetails: TSQLDetails); // DB�� �������� ALias ����
    function GetLinkInfo(LinkInfo: TStringList): boolean; // DB ���������б�
    function DBConnect: boolean;        // TQuery ������ DB �����ϱ�
    procedure DBDisConnect;             // TQuery ���� �� DB ���� ����

    // ���� ������ ��� �κ�
    procedure OnGetSelectQuery(Query: TStrings;
      TableName, CompareStr: string); virtual;
    // ��ӹ��� Ŭ���¿��� �޸� ��ü�� ����� �ָ� �ȴ�.
    function OnMakeData(pDataName: PString; pDataIndex: PInteger;
      Fields: TFields): pointer; virtual;

    function LoadFromFile(DataList: TList): boolean; // ȭ�Ϸ� ���� ���
    function LoadFromSQL(DataList: TList; TableKind: integer): boolean;
    // SQL �� ���� ���
  public

    constructor Create;
    destructor Destroy; override;

    function Load(DataList: TList; LoadType: TLoadType;
      TableKind: integer): boolean;
    procedure SetCompareStr(CompareStr: string);
    // SQL �� WHERE ���� ���� ��Ʈ��
    function GetLoadedDataInfos: TStrings;
    // ������ ������ ������ ������ ��´�.

    property IsConected: boolean Read FConnected;
    // DB �� ���ӵǾ����� �̼��ִ�.
  end;

  // ItemMgr Class -----------------------------------------------------------
  TItemMgr = class(TDataMgr)
  private
    procedure OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
      override;
    function OnMakeData(pDataName: PString; pDataIndex: PInteger;
      Fields: TFields): pointer; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // MonsterMgr Class --------------------------------------------------------
  TMonsterMgr = class(TDataMgr)
  private
    procedure OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
      override;
    function OnMakeData(pDataName: PString; pDataIndex: PInteger;
      Fields: TFields): pointer; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // MonsterItem Class -------------------------------------------------------
  TMonsterItemMgr = class(TDataMgr)
  private
    procedure OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
      override;
    function OnMakeData(pDataName: PString; pDataIndex: PInteger;
      Fields: TFields): pointer; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // MagicMgr Class ----------------------------------------------------------
  TMagicMgr = class(TDataMgr)
  private
    procedure OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
      override;
    function OnMakeData(pDataName: PString; pDataIndex: PInteger;
      Fields: TFields): pointer; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var

  // �⺻���� ������ �ܺ� ���� ������ �����ص� ������
  gItemMgr:    TItemMgr;
  gMonsterMgr: TMOnsterMgr;
  gMonsterItemMgr: TMonsterItemMgr;
  gMagicMgr:   TMagicMgr;

implementation

uses
  svMain;

// Class TDataMgr ==============================================================
constructor TDataMgr.Create;
begin
  inherited;

  FQuery     := TAdoQuery.Create(nil);
  FDataBase  := TADOConnection.Create(nil);
  FInfos     := TStringList.Create;
  FLinkInfo  := TStringList.Create;
  FConnected := False;
  FTableName := '';

end;

destructor TDataMgr.Destroy;
begin

  DBDisConnect;
  FQuery.Free;
  FDataBase.Free;
  FInfos.Free;
  FLinkInfo.Free;

  // TODO
  inherited;
end;

 //------------------------------------------------------------------------------
 // DBE �� �������� Alias ����
 //------------------------------------------------------------------------------
procedure TDataMgr.AddBDEalias(SQLDetails: TSQLDetails);
var
  sAlias: string;
  slParams, slaliasList: TStringList;
begin
  slParams    := nil;
  slaliasList := nil;
  try
    slParams    := TStringList.Create;
    slaliasList := TStringList.Create;
    sAlias      := SQLDetails.alias;
    slParams.Add('SERVER NAME=' + SQLDetails.Server);
    slParams.Add('DATABASE NAME=' + SQLDetails.Database);
    slParams.Add('USER NAME=' + SQLDetails.User);
    slParams.Add('PASSWORD=' + SQLDetails.Pass);
    begin
      begin

        try
          Session.ConfigMode := cmPersistent;
          Session.GetAliasNames(slaliasList);

          if slAliasList.IndexOf(salias) > -1 then begin
            Session.DeleteAlias(salias);
            Session.SaveConfigFile;
          end;

          Session.AddAlias(salias, 'MSSQL', slParams);
          Session.SaveConfigFile;

        except
          On E: Exception do
            MessageDlg({TranslateString(MSG_ADDaliasFAIL)+}':' +
              E.Message, mtWarning, [mbOK], 0);
        end;

      end;

    end;

  finally
    if slParams <> nil then
      slParams.Free;
    if slaliasList <> nil then
      slaliasList.Free;
  end;
end;

 //------------------------------------------------------------------------------
 // DB ���������б�
 //------------------------------------------------------------------------------
function TDataMgr.GetLinkInfo(LinkInfo: TStringList): boolean;
begin
  Result := False;

  if FileExists(LinkInfoFileName) then begin
    LinkInfo.LoadFromFile(LinkInfoFileName);
    Result := True;
  end;
end;

 //------------------------------------------------------------------------------
 // ȭ�Ϸ� ���� ���
 // ���� ���� ���� ����� �ʿ��� �Լ��� �����س��� ����
 //------------------------------------------------------------------------------
function TDataMgr.LoadFromFile(DataList: TList): boolean;
begin
  Result := False;
end;

 //------------------------------------------------------------------------------
 // SQL �� ������ ����
 //------------------------------------------------------------------------------
function TDataMgr.LoadFromSQL(DataList: TList; TableKind: integer): boolean;
var
  i:     integer;
  pItem: pointer;
  DataName: string;
  DataIndex: integer;
begin
  Result := False;

  // �����Ͱ� �����ϸ�
  if (FQuery.RecordCount > 0) then begin
    Result := True;
    pItem  := nil;

    // ó������ �����͸� ���������� �о���δ�.
    FQuery.First;
    for i := 0 to FQuery.RecordCount - 1 do begin
      pItem := OnMakeData(@DataName, @DataIndex, FQuery.Fields);

      // TableKind : 0�̻��̸� Index�� ������ �ݵ�� �¾ƾ� �ϴ� ���̺�(0 : 0���� ����, 1 : 1���� ����)
      //             -1�̸� Index�� ������ ������� ���̺�
      //Zero-based
      if (TableKind = 0) and (i <> DataIndex) then
        MainOutMessage('CRITICAL ERROR!!! Record Index does not match in StdItem DB '
          + IntToStr(DataIndex))
      //One-based
      else if (TableKind = 1) and (i + 1 <> DataIndex) then
        MainOutMessage('CRITICAL ERROR!!! Record Index does not match in StdItem DB '
          + IntToStr(DataIndex));

      if pItem <> nil then begin
        DataList.Add(pItem);

        // TOTEST...
        // FInfos.Add ( IntToStr(DataIndex ) +' / '+Dataname  );

        pItem := nil;
      end;

      FQuery.Next;
    end; // for...

    // ������ ���� ����
    FInfos.Clear;
    FInfos.Add(FTableName + ':' + FCompareStr + ' Load. Count Is ' +
      IntToStr(FQuery.RecordCount));
  end;// if ...

end;

 //------------------------------------------------------------------------------
 // ������ �б�
 // ltFILE : ���Ϸ� ���� �б�
 // ltSQL  : SQL�� ���� �б�
 // DataList �� �ʱ�ȭ�� �޸𸮴� ���� ��Ű�� ������ �˾Ƽ� ó���ϱ� �ٶ�
 //------------------------------------------------------------------------------
function TDataMgr.Load(DataList: TList; LoadType: TLoadType;
  TableKind: integer): boolean;
begin
  // TableKind : 0�̻��̸� Index�� ������ �ݵ�� �¾ƾ� �ϴ� ���̺�(0 : 0���� ����, 1 : 1���� ����)
  //             -1�̸� Index�� ������ ������� ���̺�
  Result := False;

  FLoadType := LoadType;

  if (DBConnect) then begin
    case LoadType of
      ltFILE: Result := LoadFromFile(DataList);
      ltSQL: Result  := LoadFromSQL(DataList, TableKind);
    end;
  end;

  DBDisConnect;
end;

 //------------------------------------------------------------------------------
 // �����͸� ������ ���������� ������ ������ ����µ� �������� �о����
 //------------------------------------------------------------------------------
function TDataMgr.GetLoadedDataInfos: TStrings;
begin
  Result := FInfos;
end;

 //------------------------------------------------------------------------------
 // SQL �񱳽� WHERE ���� �ش�Ǵ� ���ڿ��� �ִ´�.
 // ���� ���������� ���� �� ���� �̸��� WHERE = MONNAME �ִ´�.
 //------------------------------------------------------------------------------
procedure TDataMgr.SetCompareStr(CompareStr: string);
begin
  FCompareStr := CompareStr;
end;

 //------------------------------------------------------------------------------
 // SELECT �� ���õ� QUERY�� �Է��ϴ� �κ�
 // ����Ŭ�������� �� ��üȭ ���Ѿ� �Ѵ�.
 //------------------------------------------------------------------------------
procedure TDataMgr.OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
begin
  Query.Clear;
  // TODO : ADD SQL QUERY To Query
end;

 //------------------------------------------------------------------------------
 // QUERY �ʵ忡�� ����ü�� �����͸� �����ϴ� �κ�
 // ����Ŭ�������� �� ��üȭ ���Ѿ� �Ѵ�.
 //------------------------------------------------------------------------------
function TDataMgr.OnMakeData(pDataName: PString; pDataIndex: PInteger;
  Fields: TFields): pointer;
begin
  Result := nil;
end;

 //------------------------------------------------------------------------------
 // SQL2K �� �����ͺ��̽� ������ SQL �� �����Ѵ�.
 //------------------------------------------------------------------------------
function TDataMgr.DBConnect: boolean;
var
  SQLDetails: TSQLDetails;
begin
  Result := False;

  // �ܺ� ȯ�� ���� ȭ���� �д´�. ( ./!DBSETUP.TXT )
  if (GetLinkInfo(FLinkInfo)) then begin

    // ������ ���� �ʾҴٸ�  ȯ�溯���� ���� ����
    if not FConnected then begin
      with FDataBase do begin
        LoginPrompt := False;

        // Params.Assign( FLinkInfo );

        SQLDetails.Alias    := 'MIR_RES';
        SQLDetails.Server   := FLinkInfo.Values['SERVER NAME'];
        SQLDetails.Database := FLinkInfo.Values['DATABASE NAME'];
        SQLDetails.User     := FLinkInfo.Values['USER NAME'];
        SQLDetails.Pass     := FLinkInfo.Values['PASSWORD'];

        // ADO Connection Info
        ConnectionString :=
          'Provider=SQLOLEDB.1;Password=' + SQLDetails.Pass +
          ';Persist Security Info=True;User ID=' + SQLDetails.User +
          ';Initial Catalog=' + SQLDetails.Database + ';Data Source=' +
          SQLDetails.Server;

        // AddBDEalias(SQLDetails );

        // AliasName  := SQLDetails.Alias;
        FTableName := FLinkInfo.Values[FTableNameIndex];

        //DataBaseName := 'InterBase';
        Connected  := True;
        FConnected := Connected;
      end;

    end; // if not...

    // ������ �Ǿ��ٸ�
    if FConnected then begin
      // TQuery �� ������ ���̽� ����
      FQuery.Connection := FDataBase;
      // SELECT �� ���õ� ������ �а�
      OnGetSelectQuery(FQuery.SQL, FTableName, FCompareStr);

      // ������ �����ϸ� ��������
      if (FQuery.SQL.Count > 0) then begin
        FQuery.Active := False;
        FQuery.Active := True;
        Result := FQuery.Active;
      end;
    end; // if FCon...
  end;
end;

 //------------------------------------------------------------------------------
 // ������ ���̽� ����
 //------------------------------------------------------------------------------
procedure TDataMgr.DBDisConnect;
begin
  FQuery.Active := False;
  FDataBase.Connected := False;
end;

// Class TItemMgr  =============================================================
constructor TItemMgr.Create;
begin
  inherited;
  FTableNameIndex := 'TABLE_STDITEMS';
end;

destructor TItemMgr.Destroy;
begin
  // TODO
  inherited;
end;

procedure TItemMgr.OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
begin
  Query.Clear;
  Query.Add('SELECT * FROM ' + TableName);
end;

function TItemMgr.OnMakeData(pDataName: PString; pDataIndex: PInteger;
  Fields: TFields): pointer;
var
  pitem: PTStdItem;
begin

  new(pitem);
  if (pitem <> nil) then begin
    with Fields do begin
      pDataIndex^    := FieldByName('ID').AsInteger;
      pitem^.Name    := FieldByName('NAME').AsString;
      pitem^.StdMode := FieldByName('STDMode').AsInteger;
      pitem^.Shape   := FieldByName('SHAPE').AsInteger;
      pitem^.Weight  := FieldByName('WEIGHT').AsInteger;
      pitem^.AniCount := FieldByName('ANICOUNT').AsInteger;
      pitem^.SpecialPwr := FieldByName('SOURCE').AsInteger;
      pitem^.ItemDesc := FieldByName('RESERVED').AsInteger;
      pitem^.Looks   := FieldByName('IMGINDEX').AsInteger;
      pitem^.DuraMax := FieldByName('DURAMAX').AsInteger;
      pitem^.Ac      :=
        MakeWord(FieldByName('AC').AsInteger, FieldByName('ACMAX').AsInteger);
      pitem^.Mac     :=
        MakeWord(FieldByName('MAC').AsInteger, FieldByName('MACMAX').AsInteger);
      pitem^.Dc      :=
        MakeWord(FieldByName('DC').AsInteger, FieldByName('DCMAX').AsInteger);
      pitem^.Mc      :=
        MakeWord(FieldByName('MC').AsInteger, FieldByName('MCMAX').AsInteger);
      pitem^.Sc      :=
        MakeWord(FieldByName('SC').AsInteger, FieldByName('SCMAX').AsInteger);
      pitem^.Need    := FieldByName('NEED').AsInteger;
      pitem^.NeedLevel := FieldByName('NEEDLEVEL').AsInteger;
      pitem^.Price   := FieldByName('PRICE').AsInteger;
      // 2003/03/15 ������ �κ��丮 Ȯ��
      pitem^.Stock   := FieldByName('STOCK').AsInteger;
      pitem^.AtkSpd  := FieldByName('ATKSPD').AsInteger;
      pitem^.Agility := FieldByName('AGILITY').AsInteger;
      pitem^.Accurate := FieldByName('ACCURATE').AsInteger;
      pitem^.MgAvoid := FieldByName('MGAVOID').AsInteger;
      pitem^.Strong  := FieldByName('STRONG').AsInteger;
      pitem^.Undead  := FieldByName('UNDEAD').AsInteger;
      pitem^.HpAdd   := FieldByName('HPADD').AsInteger;
      pitem^.MpAdd   := FieldByName('MPADD').AsInteger;
      pitem^.ExpAdd  := FieldByName('EXPADD').AsInteger;
      pitem^.EffType1 := FieldByName('EFFTYPE1').AsInteger;
      pitem^.EffRate1 := FieldByName('EFFRATE1').AsInteger;
      pitem^.EffValue1 := FieldByName('EFFVALUE1').AsInteger;
      pitem^.EffType2 := FieldByName('EFFTYPE2').AsInteger;
      pitem^.EffRate2 := FieldByName('EFFRATE2').AsInteger;
      pitem^.EffValue2 := FieldByName('EFFVALUE2').AsInteger;
      pitem^.Slowdown := FieldByName('SLOWDOWN').AsInteger;
      pitem^.Tox     := FieldByName('TOX').AsInteger;
      pitem^.ToxAvoid := FieldByName('TOXAVOID').AsInteger;
      pitem^.UniqueItem := FieldByName('UNIQUEITEM').AsInteger;
      pitem^.OverlapItem := FieldByName('OVERLAPITEM').AsInteger;
      pitem^.light   := FieldByName('LIGHT').AsInteger;
      pitem^.ItemType := FieldByName('ITEMTYPE').AsInteger;
      pitem^.ItemSet := FieldByName('ITEMSET').AsInteger;
      pitem^.Reference := FieldByName('REFERENCE').AsString;
    end;
  end;

  pDataName^ := pitem^.Name;

  Result := pitem;
end;

// Class TMonsterMgr ===========================================================
constructor TMonsterMgr.Create;
begin
  inherited;
  FTableNameIndex := 'TABLE_MONSTER';
end;

destructor TMonsterMgr.Destroy;
begin
  // TODO
  inherited;
end;

procedure TMonsterMgr.OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
begin
  Query.Clear;
  Query.Add('SELECT * FROM ' + TableName);

end;

function TMonsterMgr.OnMakeData(pDataName: PString; pDataIndex: PInteger;
  Fields: TFields): pointer;
var
  pitem: PTMonsterInfo;
begin

  new(pitem);
  if (pitem <> nil) then begin
    with Fields do begin
      pDataIndex^    := FieldByName('ID').AsInteger;
      pitem^.Name    := FieldByName('NAME').AsString;
      pitem^.Race    := FieldByName('RACE').AsInteger;
      pitem^.RaceImg := FieldByName('RACEIMG').AsInteger;
      pitem^.Appr    := FieldByName('IMGINDEX').AsInteger;
      pitem^.Level   := FieldByName('LV').AsInteger;
      pitem^.LifeAttrib := FieldByName('UNDEAD').AsInteger;
      pitem^.CoolEye := FieldByName('COOLEYE').AsInteger;
      pitem^.Exp     := FieldByName('EXP').AsInteger;
      pitem^.HP      := FieldByName('HP').AsInteger;
      pitem^.MP      := FieldByName('MP').AsInteger;
      pitem^.AC      := FieldByName('AC').AsInteger;
      pitem^.MAC     := FieldByName('MAC').AsInteger;
      pitem^.DC      := FieldByName('DC').AsInteger;
      pitem^.MaxDC   := FieldByName('DCMAX').AsInteger;
      pitem^.MC      := FieldByName('MC').AsInteger;
      pitem^.SC      := FieldByName('SC').AsInteger;
      pitem^.Speed   := FieldByName('AGILITY').AsInteger;
      pitem^.Hit     := FieldByName('ACCURATE').AsInteger;
      pitem^.WalkSpeed := _MAX(200, FieldByName('WALK_SPD').AsInteger);
      pitem^.WalkStep := _MAX(1, FieldByName('WALKSTEP').AsInteger);
      pitem^.WalkWait := FieldByName('WALKWAIT').AsInteger;
      pitem^.AttackSpeed := FieldByName('ATTACK_SPD').AsInteger;
      // newly added by sonmg.
      pitem^.Tame    := FieldByName('TAME').AsInteger;
      pitem^.AntiPush := FieldByName('ANTIPUSH').AsInteger;
      pitem^.AntiUndead := FieldByName('ANTIUNDEAD').AsInteger;
      pitem^.SizeRate := FieldByName('SIZERATE').AsInteger;
      pitem^.AntiStop := FieldByName('ANTISTOP').AsInteger;

      if (pitem^.WalkSpeed < 200) then
        pitem^.WalkSpeed := 200;
      if (pitem^.AttackSpeed < 200) then
        pitem^.AttackSpeed := 200;

    end;
  end;
  pDataName^ := pitem^.Name;

  Result := pitem;

end;

// Class TMonsterMgr ===========================================================
constructor TMonsterItemMgr.Create;
begin
  inherited;
  FTableNameIndex := 'TABLE_MOBITEM';
end;

destructor TMonsterItemMgr.Destroy;
begin
  // TODO
  inherited;
end;

procedure TMonsterItemMgr.OnGetSelectQuery(Query: TStrings;
  TableName, CompareStr: string);
begin
  Query.Clear;
  Query.Add('SELECT * FROM ' + TableName + ' WHERE MOBNAME=''' + CompareStr + '''');

end;

function TMonsterItemMgr.OnMakeData(pDataName: PString; pDataIndex: PInteger;
  Fields: TFields): pointer;
var
  pitem: PTMonItemInfo;
begin

  new(pitem);
  if (pitem <> nil) then begin
    with Fields do begin
      pDataIndex^     := FieldByName('ID').AsInteger;
      pitem^.SelPoint := FieldByName('SELPOINT').AsInteger - 1;
      pitem^.MaxPoint := FieldByName('MAXPOINT').AsInteger;
      pitem^.ItemName := FieldByName('ITEMNAME').AsString;
      pitem^.Count    := FieldByName('COUNT').AsInteger;
    end;
  end;
  pDataName^ := pitem^.ItemName;

  Result := pitem;

end;

 //==============================================================================
 // Class TMagicMgr
 //==============================================================================
constructor TMagicMgr.Create;
begin
  inherited;
  FTableNameIndex := 'TABLE_MAGIC';
end;

destructor TMagicMgr.Destroy;
begin
  // TODO
  inherited;
end;

procedure TMagicMgr.OnGetSelectQuery(Query: TStrings; TableName, CompareStr: string);
begin
  Query.Clear;
  Query.Add('SELECT * FROM ' + TableName);

end;

function TMagicMgr.OnMakeData(pDataName: PString; pDataIndex: PInteger;
  Fields: TFields): pointer;
var
  pitem: PTDefMagic;
begin
  new(pitem);

  if (pitem <> nil) then begin
    with Fields do begin
      pitem^.MagicId  := FieldByName('ID').AsInteger;
      pitem^.MagicName := FieldByName('NAME').AsString;
      pitem^.EffectType := FieldByName('EFFECTTYPE').AsInteger;
      pitem^.Effect   := FieldByName('EFFECT').AsInteger;
      pitem^.Spell    := FieldByName('SPELL').AsInteger;
      pitem^.MinPower := FieldByName('POWER').AsInteger;
      pitem^.MaxPower := FieldByName('MAXPOWER').AsInteger;
      pitem^.Job      := FieldByName('JOB').AsInteger;
      pitem^.NeedLevel[0] := FieldByName('NEEDL1').AsInteger;
      pitem^.NeedLevel[1] := FieldByName('NEEDL2').AsInteger;
      pitem^.NeedLevel[2] := FieldByName('NEEDL3').AsInteger;
      pitem^.NeedLevel[3] := FieldByName('NEEDL3').AsInteger;
      pitem^.MaxTrain[0] := FieldByName('L1TRAIN').AsInteger;
      pitem^.MaxTrain[1] := FieldByName('L2TRAIN').AsInteger;
      pitem^.MaxTrain[2] := FieldByName('L3TRAIN').AsInteger;
      pitem^.MaxTrain[3] := pitem^.MaxTrain[2];//FieldByName('L2Train').AsInteger;
      pitem^.MaxTrainLevel := 3; ///FieldByName('TrainLevel').AsInteger;
      pitem^.DelayTime := FieldByName('DELAY').AsInteger * 10;
      pitem^.DefSpell := FieldByName('DEFSPELL').AsInteger;
      pitem^.DefMinPower := FieldByName('DEFPOWER').AsInteger;
      pitem^.DefMaxPower := FieldByName('DEFMAXPOWER').AsInteger;
      pitem^.Desc     := FieldByName('DESCR').AsString;
    end;
  end;

  pDataIndex^ := pitem^.MagicId;
  pDataName^  := pitem^.MagicName;

  Result := pitem;

end;

end.
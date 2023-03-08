unit uVerificationBase;

interface

uses
  Generics.Collections,
  System.Classes,
  Xml.XMLIntf,
  uGestionBDD;

const
  // recup du type de champs
  SQL_FIELD_TYPE = '  f.rdb$field_type as field_type, '
                 + '  f.rdb$field_precision as field_precision, '
                 + '  f.rdb$field_scale as field_scale, '
                 + '  f.rdb$character_length as character_length, '
                 + '  f.rdb$collation_id as collation_id, '
                 + '  f.rdb$character_set_id as character_set_id, '
                 + '  f.rdb$segment_length as segment_length, '
                 + '  f.rdb$field_sub_type as field_sub_type';
  // pour les collation (avec celle par defaut dans default_collate_name)
  SQL_COLLATION = 'select cst.rdb$character_set_name as character_set_name, '
                + '       col.rdb$collation_name as collation_name, '
                + '       cst.rdb$default_collate_name as default_collate_name '
                + 'from rdb$collations col join rdb$character_sets cst on col.rdb$character_set_id = cst.rdb$character_set_id '
                + 'where col.rdb$collation_id = %d and cst.rdb$character_set_id = %d '
                + 'order by col.rdb$collation_name, cst.rdb$character_set_name';
  // requetes de recup global
  SQL_ASK_TABLES = 'select rdb$relation_name as name '
                 + 'from rdb$relations '
                 + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) '
                 + 'order by rdb$relation_name;';
  SQL_ASK_TABLES_COUNT = 'select count(*) as nombre from %s;';
  SQL_ASK_CHAMPS = 'select r.rdb$relation_name as table_name, '
                 + '       r.rdb$field_position as field_position, '
                 + '       r.rdb$field_name as field_name, '
                 + SQL_FIELD_TYPE + ', '
                 + '       r.rdb$null_flag as field_nullable, '
                 + '       r.rdb$default_source as field_default, '
                 + '       f.rdb$field_name as domain_type, '
                 + '       f.rdb$null_flag as domain_nullable, '
                 + '       f.rdb$default_source as domain_default '
                 + 'from rdb$relation_fields r '
                 + 'left join rdb$fields f on f.rdb$field_name = r.rdb$field_source '
                 + 'where ((r.rdb$system_flag = 0) or (r.rdb$system_flag is null)) '
                 + 'order by r.rdb$relation_name, r.rdb$field_position;';
  SQL_ASK_INDEXES = 'select i.rdb$relation_name as tablename, i.rdb$index_name as indexname, i.rdb$unique_flag as flagunique, s.rdb$field_name as fieldname '
                  + 'from rdb$indices i '
                  + 'left join rdb$index_segments s on s.rdb$index_name = i.rdb$index_name '
                  + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) '
                  + 'order by i.rdb$relation_name, i.rdb$index_name, s.rdb$field_position;';
  SQL_ASK_GENERATEURS = 'select rdb$generator_name as name '
                      + 'from rdb$generators '
                      + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) '
                      + 'order by rdb$generator_name;';
  SQL_ASK_GENERATEURS_LEVEL = 'select gen_id(%s, 0) as nombre from rdb$database;';
  SQL_ASK_PROCEDURES = 'select rdb$procedure_name as name, rdb$procedure_source as source '
                     + 'from rdb$procedures '
                     + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) '
                     + 'order by rdb$procedure_name;';
  SQL_ASK_PARAMETERS = 'select p.rdb$procedure_name as procedure_name, '
                     + '       p.rdb$parameter_type as in_or_out, '
                     + '       p.rdb$parameter_number as parameter_number, '
                     + '       p.rdb$parameter_name as parameter_name, '
                     + SQL_FIELD_TYPE + ', '
                     + '       f.rdb$null_flag as parameter_nullable, '
                     + '       f.rdb$default_source as parameter_default '
                     + 'from rdb$procedure_parameters p '
                     + 'left join rdb$fields f on f.rdb$field_name = p.rdb$field_source '
                     + 'where ((p.rdb$system_flag = 0) or (p.rdb$system_flag is null)) '
                     + 'order by p.rdb$procedure_name, p.rdb$parameter_type, p.rdb$parameter_number;';
  SQL_ASK_TRIGGERS = 'select rdb$trigger_name as name, rdb$trigger_source as source '
                   + 'from rdb$triggers '
                   + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) '
                   + 'order by rdb$trigger_name;';
  // requete pour une seule procedure
  SQL_ASK_RECOMPILE  = 'select cast(''trigger'' as varchar(32)) as "TYPE", rdb$trigger_name as name '
                     + 'from rdb$triggers '
                     + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) and ((rdb$flags = 0) or (rdb$flags is null)) '
                     + 'union all '
                     + 'select cast(''procedure'' as varchar(32)), rdb$procedure_name as name '
                     + 'from rdb$procedures '
                     + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) '
                     + 'order by 2;';
  SQL_ASK_PROCEDURE  = 'select rdb$procedures.* '
                     + 'from rdb$procedures '
                     + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) and rdb$procedure_name = %s;';
  SQL_ASK_TRIGGER    = 'select rdb$triggers.* '
                     + 'from rdb$triggers '
                     + 'where ((rdb$system_flag = 0) or (rdb$system_flag is null)) and rdb$trigger_name = %s;';
  SQL_ASK_PROCPARAM  = 'select p.rdb$parameter_type as in_or_out, '
                     + '       p.rdb$parameter_name as parameter_name, '
                     + SQL_FIELD_TYPE + ' '
                     + 'from rdb$procedure_parameters p '
                     + 'left join rdb$fields f on f.rdb$field_name = p.rdb$field_source '
                     + 'where ((p.rdb$system_flag = 0) or (p.rdb$system_flag is null)) and p.rdb$procedure_name = %s '
                     + 'order by p.rdb$parameter_type, p.rdb$parameter_number;';

const
  SubTypes : Array[0..8] of String = (
    'UNKNOWN',
    'TEXT',
    'BLR',
    'ACL',
    'RANGES',
    'SUMMARY',
    'FORMAT',
    'TRANSACTION_DESCRIPTION',
    'EXTERNAL_FILE_DESCRIPTION');

  IntegralSubtypes : Array[0..2] of String = (
    'UNKNOWN',
    'NUMERIC',
    'DECIMAL');

  TriggerTypes : Array[0..6] of String = (
    '',
    'BEFORE INSERT',
    'AFTER INSERT',
    'BEFORE UPDATE',
    'AFTER UPDATE',
    'BEFORE DELETE',
    'AFTER DELETE');

type
  TInfoIndex = class;
  TInfoChamp = class;
  TInfoTable = class;
  TInfoProcedure = class;

  TDicStringInteger = class(TDictionary<string, integer>)
  public
    procedure SaveToXml(ParentNode : IXmlNode; ItemName : string = 'Item');
    procedure LoadFromXml(ParentNode : IXmlNode);
  end;

  TDicStringString = class(TDictionary<string, string>)
  public
    procedure SaveToXml(ParentNode : IXmlNode; ItemName : string = 'Item');
    procedure LoadFromXml(ParentNode : IXmlNode);
  end;

  TDicStringInfoIndex = class(TObjectDictionary<string, TInfoIndex>)
  public
    procedure SaveToXml(ParentNode : IXmlNode; ItemName : string = 'Item');
    procedure LoadFromXml(ParentNode : IXmlNode);
  end;

  TDicStringInfoChamp = class(TObjectDictionary<string, TInfoChamp>)
  public
    procedure SaveToXml(ParentNode : IXmlNode; ItemName : string = 'Item');
    procedure LoadFromXml(ParentNode : IXmlNode);
  end;

  TDicStringInfoTable = class(TObjectDictionary<string, TInfoTable>)
  public
    procedure SaveToXml(ParentNode : IXmlNode; ItemName : string = 'Item');
    procedure LoadFromXml(ParentNode : IXmlNode);
  end;

  TDicStringInfoProcedure = class(TObjectDictionary<string, TInfoProcedure>)
  public
    procedure SaveToXml(ParentNode : IXmlNode; ItemName : string = 'Item');
    procedure LoadFromXml(ParentNode : IXmlNode);
  end;

  TListeIndexes = TDicStringInfoIndex;
  TListeChamps = TDicStringInfoChamp;
  TListeTables = TDicStringInfoTable;
  TListeGenerateurs = TDicStringInteger;
  TListeProcedures = TDicStringInfoProcedure;
  TListeTriggers = TDicStringString;

  TInfoIndex = class(TObject)
  private
    FName : string;
    FUnique : boolean;
    FChamps : TStringList;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    function CompareWith(Other : TInfoIndex) : TStringList;

    procedure SaveToXml(ParentNode : IXmlNode);
    procedure LoadFromXml(ParentNode : IXmlNode);

    property Name : string read FName write FName;
    property Unique : boolean read FUnique write FUnique;
    property Champs : TStringList read FChamps;
  end;

  TInfoChamp = class(TObject)
  type
    TTypeInfos = class(TObject)
      FType : string;
      FNullable : boolean;
      FDefault : string;

      procedure SaveToXml(ParentNode : IXmlNode);
      procedure LoadFromXml(ParentNode : IXmlNode);
    end;
  private
    Fname : string;
    FIdx : integer;
    FType : TTypeInfos;
    FDomaine : TTypeInfos;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    function CompareWith(Other : TInfoChamp; TestOrdre : boolean = false) : TStringList;

    procedure SaveToXml(ParentNode : IXmlNode);
    procedure LoadFromXml(ParentNode : IXmlNode);

    property Name : string read Fname write Fname;
    property Idx : integer read FIdx write FIdx;
    property Field_Type : TTypeInfos read FType;
    property Field_Domain : TTypeInfos read FDomaine;
  end;

  TInfoTable = class(TObject)
  private
    FName : string;
    FNbEnreg : integer;
    FChamps : TListeChamps;
    FIndexes : TListeIndexes;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    function CompareWith(Other : TInfoTable; StructOnly : boolean = false) : TStringList;

    procedure SaveToXml(ParentNode : IXmlNode);
    procedure LoadFromXml(ParentNode : IXmlNode);

    property Name : string read FName write FName;
    property NbEnreg : integer read FNbEnreg write FNbEnreg;
    property Champs : TListeChamps read FChamps;
    property Indexes : TListeIndexes read FIndexes;
  end;

  TInfoProcedure = class(TObject)
  private
    Fname : string;
    FMd5Source : string;
    FChampsIn : TListeChamps;
    FChampsOut : TListeChamps;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    function CompareWith(Other : TInfoProcedure) : TStringList;

    procedure SaveToXml(ParentNode : IXmlNode);
    procedure LoadFromXml(ParentNode : IXmlNode);

    property Name : string read Fname write Fname;
    property Md5Source : string read FMd5Source write FMd5Source;
    property ChampsIn : TListeChamps read FChampsIn;
    property ChampsOut : TListeChamps read FChampsOut;
  end;

type
  TDataBaseVerif = class(TObject)
  private
    FListeTables : TListeTables;
    FListeGenerateurs : TListeGenerateurs;
    FListeProcedures : TListeProcedures;
    FListeTriggers : TListeTriggers;
  protected
    function GetCount() : integer;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    function FillFromDatabase(Server, DataBase, Login, Password : string; Port : integer; Extract : boolean = false) : boolean;
    function CompareWith(Other : TDataBaseVerif; StructOnly : boolean = false) : TStringList;
    function CompareWithDatabase(Server, DataBase, Login, Password : string; Port : integer) : TStringList;
    procedure Clear();

    procedure SaveToXml(ParentNode : IXmlNode); overload;
    procedure SaveToXml(FileName : string); overload;
    procedure LoadFromXml(ParentNode : IXmlNode); overload;
    procedure LoadFromXml(FileName : string); overload;

    procedure SaveToJSon(FileName : string);
    class function LoadFromJSon(FileName : string) : TDataBaseVerif;

    property Count : integer read GetCount;

    property ListeTables : TListeTables read FListeTables;
    property ListeGenerateurs : TListeGenerateurs read FListeGenerateurs;
    property ListeProcedures : TListeProcedures read FListeProcedures;
    property ListeTriggers : TListeTriggers read FListeTriggers;
  end;

// Conversion du type de champs en string ...
function GetTypeFromDB(Query : TMyQuery) : string;

implementation

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  IdHashMessageDigest,
  idHash,
  Xml.XMLDoc,
  uXmlUtils,
  Data.DBXJson,
  DBXJSonReflect,
  System.JSon;

// Conversion du type de champs en string ...
function GetTypeFromDB(Query : TMyQuery) : string;
begin
  case Query.FieldByName('field_type').AsInteger of
    07 :
      if (not Query.FieldByName('field_precision').IsNull) and
         (Query.FieldByName('field_sub_type').AsInteger > 0) and
         (Query.FieldByName('field_sub_type').AsInteger <= high(IntegralSubtypes)) then
        result := IntegralSubtypes[Query.FieldByName('field_sub_type').AsInteger] + '(' + Query.FieldByName('field_precision').AsString + ',' + IntToStr(Query.FieldByName('field_scale').AsInteger * -1) + ')'
      else
        result := 'smallint';
    08 :
      if (not Query.FieldByName('field_precision').IsNull) and
         (Query.FieldByName('field_sub_type').AsInteger > 0) and
         (Query.FieldByName('field_sub_type').AsInteger <= high(IntegralSubtypes)) then
        result := IntegralSubtypes[Query.FieldByName('field_sub_type').AsInteger] + '(' + Query.FieldByName('field_precision').AsString + ',' + IntToStr(Query.FieldByName('field_scale').AsInteger * -1) + ')'
      else
        result := 'integer';
    09 : result := 'quad';
    10 : result := 'float';
    11 : result := 'd_float';
    12 : result := 'date';
    13 : result := 'time';
    14 : result := 'char';
    16 :
      if (not Query.FieldByName('field_precision').IsNull) and
         (Query.FieldByName('field_sub_type').AsInteger > 0) and
         (Query.FieldByName('field_sub_type').AsInteger <= high(IntegralSubtypes)) then
        result := IntegralSubtypes[Query.FieldByName('field_sub_type').AsInteger] + '(' + Query.FieldByName('field_precision').AsString + ',' + IntToStr(Query.FieldByName('field_scale').AsInteger * -1) + ')'
      else
        result := 'int64';
    17 : Result := 'boolean';
    27 : result := 'numeric(' + Query.FieldByName('field_precision').AsString + ',' + IntToStr(Query.FieldByName('field_scale').AsInteger * -1) + ')';
    35 : result := 'timestamp';
    37 : result := 'varchar(' + Query.FieldByName('character_length').AsString + ')'; // TODO -obpy : la collation ....
    40 : result := 'cstring';
    45 : result := 'blob_id';
    261 :
      if (Query.FieldByName('field_sub_type').AsInteger > 0) and
         (Query.FieldByName('field_sub_type').AsInteger <= high(SubTypes)) then
        result := 'blob sub_type ' + SubTypes[Query.FieldByName('field_sub_type').AsInteger] + ' segment size ' + Query.FieldByName('segment_length').AsString
      else
        result := 'blob sub_type ' + Query.FieldByName('field_sub_type').AsString + ' segment size ' + Query.FieldByName('segment_length').AsString
    else result := 'unknown';
  end;
end;

{ TDicStringInteger }

procedure TDicStringInteger.SaveToXml(ParentNode : IXmlNode; ItemName : string);
var
  NodeItem : IXmlNode;
  Key : String;
begin
  try
    for Key in Keys do
    begin
      NodeItem := ParentNode.AddChild(ItemName);
      NodeItem.Attributes['Key'] := Key;
      NodeItem.NodeValue := Items[Key];
    end;
  except
    // ...
  end;
end;

procedure TDicStringInteger.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
begin
  Clear();
  try
    for i := 0 to ParentNode.ChildNodes.Count -1 do
      Add(ParentNode.ChildNodes[i].Attributes['Key'], ParentNode.ChildNodes[i].NodeValue);
  except
    // ...
  end;
end;

{ TDicStringString }

procedure TDicStringString.SaveToXml(ParentNode : IXmlNode; ItemName : string);
var
  NodeItem : IXmlNode;
  Key : String;
begin
  try
    for Key in Keys do
    begin
      NodeItem := ParentNode.AddChild(ItemName);
      NodeItem.Attributes['Key'] := Key;
      NodeItem.NodeValue := Items[Key];
    end;
  except
    // ...
  end;
end;

procedure TDicStringString.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
begin
  Clear();
  try
    for i := 0 to ParentNode.ChildNodes.Count -1 do
      Add(ParentNode.ChildNodes[i].Attributes['Key'], ParentNode.ChildNodes[i].NodeValue);
  except
    // ...
  end;
end;

{ TDicStringInfoIndex }

procedure TDicStringInfoIndex.SaveToXml(ParentNode : IXmlNode; ItemName : string);
var
  NodeItem : IXmlNode;
  Key : String;
begin
  try
    for Key in Keys do
    begin
      NodeItem := ParentNode.AddChild(ItemName);
      NodeItem.Attributes['Key'] := Key;
      Items[Key].SaveToXml(NodeItem);
    end;
  except
    // ...
  end;
end;

procedure TDicStringInfoIndex.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
  tmp : TInfoIndex;
begin
  Clear();
  try
    for i := 0 to ParentNode.ChildNodes.Count -1 do
    begin
      tmp := TInfoIndex.Create();
      tmp.LoadFromXml(ParentNode.ChildNodes[i]);
      Add(ParentNode.ChildNodes[i].Attributes['Key'], tmp);
    end;
  except
    // ...
  end;
end;

{ TDicStringInfoChamp }

procedure TDicStringInfoChamp.SaveToXml(ParentNode : IXmlNode; ItemName : string);
var
  NodeItem : IXmlNode;
  Key : String;
begin
  try
    for Key in Keys do
    begin
      NodeItem := ParentNode.AddChild(ItemName);
      NodeItem.Attributes['Key'] := Key;
      Items[Key].SaveToXml(NodeItem);
    end;
  except
    // ...
  end;
end;

procedure TDicStringInfoChamp.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
  tmp : TInfoChamp;
begin
  Clear();
  try
    for i := 0 to ParentNode.ChildNodes.Count -1 do
    begin
      tmp := TInfoChamp.Create();
      tmp.LoadFromXml(ParentNode.ChildNodes[i]);
      Add(ParentNode.ChildNodes[i].Attributes['Key'], tmp);
    end;
  except
    // ...
  end;
end;

{ TDicStringInfoTable }

procedure TDicStringInfoTable.SaveToXml(ParentNode : IXmlNode; ItemName : string);
var
  NodeItem : IXmlNode;
  Key : String;
begin
  try
    for Key in Keys do
    begin
      NodeItem := ParentNode.AddChild(ItemName);
      NodeItem.Attributes['Key'] := Key;
      Items[Key].SaveToXml(NodeItem);
    end;
  except
    // ...
  end;
end;

procedure TDicStringInfoTable.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
  tmp : TInfoTable;
begin
  Clear();
  try
    for i := 0 to ParentNode.ChildNodes.Count -1 do
    begin
      tmp := TInfoTable.Create();
      tmp.LoadFromXml(ParentNode.ChildNodes[i]);
      Add(ParentNode.ChildNodes[i].Attributes['Key'], tmp);
    end;
  except
    // ...
  end;
end;

{ TDicStringInfoProcedure }

procedure TDicStringInfoProcedure.SaveToXml(ParentNode : IXmlNode; ItemName : string);
var
  NodeItem : IXmlNode;
  Key : String;
begin
  try
    for Key in Keys do
    begin
      NodeItem := ParentNode.AddChild(ItemName);
      NodeItem.Attributes['Key'] := Key;
      Items[Key].SaveToXml(NodeItem);
    end;
  except
    // ...
  end;
end;

procedure TDicStringInfoProcedure.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
  tmp : TInfoProcedure;
begin
  Clear();
  try
    for i := 0 to ParentNode.ChildNodes.Count -1 do
    begin
      tmp := TInfoProcedure.Create();
      tmp.LoadFromXml(ParentNode.ChildNodes[i]);
      Add(ParentNode.ChildNodes[i].Attributes['Key'], tmp);
    end;
  except
    // ...
  end;
end;

(******************************************************************************)
(******************************************************************************)

{ TInfoIndex }

constructor TInfoIndex.Create();
begin
  Inherited Create();
  FChamps := TStringList.Create();
end;

destructor TInfoIndex.Destroy();
begin
  FreeAndNil(FChamps);
  Inherited Destroy();
end;

function TInfoIndex.CompareWith(Other : TInfoIndex) : TStringList;
var
  i, idx : integer;
begin
  Result := TStringList.Create();
  // les champs
  for i := 0 to FChamps.Count -1 do
  begin
    idx := Other.Champs.IndexOf(FChamps[i]);
    if idx < 0 then
      Result.Add('Index "' + Name + '" champ "' + FChamps[i] + '" : non présent')
    else if idx <> i then
      Result.Add('Index "' + Name + '" champ "' + FChamps[i] + '" : pas dans le bon ordre (' + IntToStr(idx) + ' pour ' + IntToStr(i) + ' attendu)');
  end;
  if Other.Champs.Count <> FChamps.Count then
    Result.Add('Index "' + Name + '" pas le même nombre de champ (' + IntToStr(Other.Champs.Count) + ' pour ' + IntToStr(FChamps.Count) + ' attendu)');
  // unique ?
  if Other.Unique <> FUnique then
    Result.Add('Index "' + Name + '" pas le même flag unique (' + BoolToStr(Other.Unique, true) + ' pour ' + BoolToStr(FUnique, true) + ' attendu)');
end;

procedure TInfoIndex.SaveToXml(ParentNode : IXmlNode);
var
  i : integer;
  NodeListe, NodeChamp : IXmlNode;
begin
  ParentNode.Attributes['Name'] := FName;
  ParentNode.Attributes['Unique'] := FUnique;
  NodeListe := ParentNode.AddChild('ListeChamps');
  for i := 0 to FChamps.Count -1 do
  begin
    NodeChamp := NodeListe.AddChild('Champ');
    NodeChamp.Attributes['Name'] := FChamps[i];
  end;
end;

procedure TInfoIndex.LoadFromXml(ParentNode : IXmlNode);
var
  i : integer;
  NodeListe : IXmlNode;
begin
  FChamps.Clear();
  FName := ParentNode.Attributes['Name'];
  FUnique := ParentNode.Attributes['Unique'];
  NodeListe := GetNodeFromName('ListeChamps', ParentNode);
  for i := 0 to NodeListe.ChildNodes.Count -1 do
    FChamps.Add(NodeListe.ChildNodes[i].Attributes['Name'])
end;

{ TInfoChamp }

  { TTypeInfos }

  procedure TInfoChamp.TTypeInfos.SaveToXml(ParentNode : IXmlNode);
  begin
    ParentNode.Attributes['Type'] := FType;
    ParentNode.Attributes['Nullable'] := FNullable;
    ParentNode.Attributes['Default'] := FDefault;
  end;

  procedure TInfoChamp.TTypeInfos.LoadFromXml(ParentNode : IXmlNode);
  begin
    FType := ParentNode.Attributes['Type'];
    FNullable := ParentNode.Attributes['Nullable'];
    FDefault := ParentNode.Attributes['Default'];
  end;

constructor TInfoChamp.Create();
begin
  Inherited Create();
  FType := TTypeInfos.Create();
  FDomaine := TTypeInfos.Create();
end;

destructor TInfoChamp.Destroy();
begin
  FreeAndNil(FType);
  FreeAndNil(FDomaine);
  Inherited Destroy();
end;

function TInfoChamp.CompareWith(Other : TInfoChamp; TestOrdre : boolean = false) : TStringList;
begin
  Result := TStringList.Create();

  // le nom
  if (FName <> Other.Name) then
    Result.Add('Champ "' + Name + '" : nom différent');
  // l'index ??
  if TestOrdre then
  begin
    if FIdx <> Other.Idx then
      Result.Add('Champ "' + Name + '" : pas dans le bon ordre (' + IntToStr(Other.Idx) + ' pour ' + IntToStr(FIdx) + ' attendu)');
  end;
  // doit on comparé le domaine ??
  if Copy(Field_Domain.FType, 1, 4) <> 'RDB$' then
  begin
    // même domaine ?
    if Field_Domain.FType <> Other.Field_Domain.FType then
      Result.Add('Champ "' + Name + '" : domaine différent ("' + Other.Field_Domain.FType + '" pour "' + Field_Domain.FType + '" attendu)');
    if Field_Domain.FNullable <> Other.Field_Domain.FNullable then
      Result.Add('Champ "' + Name + '" : flag nullable du domaine différent (' + BoolToStr(Other.Field_Domain.FNullable, true) + ' pour ' + BoolToStr(Field_Domain.FNullable, true) + ' attendu)');
    if Field_Domain.FDefault <> Other.Field_Domain.FDefault then
      Result.Add('Champ "' + Name + '" : valeur par défaut du domaine différente ("' + Other.Field_Domain.FDefault + '" pour "' + Field_Domain.FDefault + '" attendu)');
  end;
  // le type ?
  if Field_Type.FType <> Other.Field_Type.FType then
    Result.Add('Champ "' + Name + '" : type différent ("' + Other.Field_Type.FType + '" pour "' + Field_Type.FType + '" attendu)');
  if Field_Type.FNullable <> Other.Field_Type.FNullable then
    Result.Add('Champ "' + Name + '" : flag nullable différent (' + BoolToStr(Other.Field_Type.FNullable, true) + ' pour ' + BoolToStr(Field_Type.FNullable, true) + ' attendu)');
  if Field_Type.FDefault <> Other.Field_Type.FDefault then
    Result.Add('Champ "' + Name + '" : valeur par défaut différente ("' + Other.Field_Type.FDefault + '" pour "' + Field_Type.FDefault + '" attendu)');
end;

procedure TInfoChamp.SaveToXml(ParentNode : IXmlNode);
var
  NodeType, NodeDomaine : IXmlNode;
begin
  ParentNode.Attributes['Name'] := FName;
  ParentNode.Attributes['Idx'] := FIdx;
  NodeType := ParentNode.AddChild('InfoType');
  Field_Type.SaveToXml(NodeType);
  NodeDomaine := ParentNode.AddChild('InfoDomaine');
  Field_Domain.SaveToXml(NodeDomaine);
end;

procedure TInfoChamp.LoadFromXml(ParentNode : IXmlNode);
var
  NodeType, NodeDomaine : IXmlNode;
begin
  FName := ParentNode.Attributes['Name'];
  FIdx := ParentNode.Attributes['Idx'];
  NodeType := GetNodeFromName('InfoType', ParentNode);
  if Assigned(NodeType) then
    Field_Type.LoadFromXml(NodeType);
  NodeDomaine := GetNodeFromName('InfoDomaine', ParentNode);
  if Assigned(NodeDomaine) then
    Field_Domain.LoadFromXml(NodeDomaine);
end;

{ TInfoTable }

constructor TInfoTable.Create();
begin
  Inherited Create();
  FChamps := TDicStringInfoChamp.Create([doOwnsValues]);
  FIndexes := TDicStringInfoIndex.Create([doOwnsValues]);
end;

destructor TInfoTable.Destroy();
begin
  FreeAndNil(FIndexes);
  FreeAndNil(FChamps);
  Inherited Destroy();
end;

function TInfoTable.CompareWith(Other : TInfoTable; StructOnly : boolean = false) : TStringList;
var
  ItemName : string;
  TmpRes : TStringList;
  i : integer;
begin
  Result := TStringList.Create();

  // le nom
  if (FName <> Other.Name) then
      Result.Add('Table "' + Name + '" : nom différent');
  // Les champs
  for ItemName in FChamps.Keys do
  begin
    if Other.Champs.ContainsKey(ItemName) then
    begin
      try
        TmpRes := FChamps[ItemName].CompareWith(Other.Champs[ItemName]);
        for i := 0 to TmpRes.Count -1 do
          Result.Add('Table "' + Name + '" ' + TmpRes[i]);
      finally
        FreeAndNil(tmpRes);
      end;
    end
    else
      Result.Add('Table "' + Name + '" champ "' + ItemName + '" : non présent');
  end;
  if Other.Champs.Count <> FChamps.Count then
    Result.Add('Table "' + Name + '" pas le même nombre de champ (' + IntToStr(Other.Champs.Count) + ' pour ' + IntToStr(FChamps.Count) + ' attendu)');
  // les indexes
  for ItemName in FIndexes.Keys do
  begin
    if Other.Indexes.ContainsKey(ItemName) then
    begin
      try
        TmpRes := FIndexes[ItemName].CompareWith(Other.Indexes[ItemName]);
        for i := 0 to TmpRes.Count -1 do
          Result.Add('Table "' + Name + '" ' + TmpRes[i]);
      finally
        FreeAndNil(tmpRes);
      end;
    end
    else
      Result.Add('Table "' + Name + '" index "' + ItemName + '" : non présent');
  end;
  if Other.Indexes.Count <> FIndexes.Count then
    Result.Add('Table "' + Name + '" pas le même nombre d''indexes (' + IntToStr(Other.Indexes.Count) + ' pour ' + IntToStr(FIndexes.Count) + ' attendu)');
  // le contenu ?
  if not StructOnly then
  begin
    if (FNbEnreg <> Other.NbEnreg) then
      Result.Add('Table "' + Name + '" : nombre d''enregistrement différent (' + IntToStr(Other.NbEnreg) + ' pour ' + IntToStr(FNbEnreg) + ' attendu)');
  end;
end;

procedure TInfoTable.SaveToXml(ParentNode : IXmlNode);
var
  NodeChamps, NodeIndex : IXmlNode;
begin
  ParentNode.Attributes['Name'] := FName;
  ParentNode.Attributes['NbEnreg'] := FNbEnreg;
  NodeChamps := ParentNode.AddChild('ListeChamps');
  FChamps.SaveToXml(NodeChamps, 'Champ');
  NodeIndex := ParentNode.AddChild('ListeIndexes');
  FIndexes.SaveToXml(NodeIndex, 'Index');
end;

procedure TInfoTable.LoadFromXml(ParentNode : IXmlNode);
var
  NodeChamps, NodeIndex : IXmlNode;
begin
  FName := ParentNode.Attributes['Name'];
  FNbEnreg := ParentNode.Attributes['NbEnreg'];
  NodeChamps := GetNodeFromName('ListeChamps', ParentNode);
  if Assigned(NodeChamps) then
    FChamps.LoadFromXml(NodeChamps);
  NodeIndex := GetNodeFromName('ListeIndexes', ParentNode);
  if Assigned(NodeIndex) then
    FIndexes.LoadFromXml(NodeIndex);
end;

{ TInfoProcedure }

constructor TInfoProcedure.Create();
begin
  Inherited Create();
  FChampsIn := TListeChamps.Create([doOwnsValues]);
  FChampsOut := TListeChamps.Create([doOwnsValues]);
end;

destructor TInfoProcedure.Destroy();
begin
  FreeAndNil(FChampsIn);
  FreeAndNil(FChampsOut);
  Inherited Destroy();
end;

function TInfoProcedure.CompareWith(Other : TInfoProcedure) : TStringList;
var
  ItemName : string;
  TmpRes : TStringList;
  i : integer;
begin
  Result := TStringList.Create();

  // le nom
  if (FName <> Other.Name) then
    Result.Add('Procedure "' + Name + '" : nom différent');
  if (FMd5Source <> Other.Md5Source) then
    Result.Add('Procedure "' + Name + '" : source différente');
  // Les champs en entrée
  for ItemName in FChampsIn.Keys do
  begin
    if Other.ChampsIn.ContainsKey(ItemName) then
    begin
      try
        TmpRes := FChampsIn[ItemName].CompareWith(Other.ChampsIn[ItemName], true);
        for i := 0 to TmpRes.Count -1 do
          Result.Add('Procedure "' + Name + '" - in - ' + TmpRes[i]);
      finally
        FreeAndNil(tmpRes);
      end;
    end
    else
      Result.Add('Procedure "' + Name + '" - in - champ "' + ItemName + '" : non présent');
  end;
  if Other.ChampsIn.Count <> FChampsIn.Count then
    Result.Add('Procedure "' + Name + '" - in - pas le même nombre de champ (' + IntToStr(Other.ChampsIn.Count) + ' pour ' + IntToStr(FChampsIn.Count) + ' attendu)');
  // Les champs en sortie
  for ItemName in FChampsOut.Keys do
  begin
    if Other.ChampsOut.ContainsKey(ItemName) then
    begin
      try
        TmpRes := FChampsOut[ItemName].CompareWith(Other.ChampsOut[ItemName], true);
        for i := 0 to TmpRes.Count -1 do
          Result.Add('Procedure "' + Name + '" - out - ' + TmpRes[i]);
      finally
        FreeAndNil(tmpRes);
      end;
    end
    else
      Result.Add('Procedure "' + Name + '" - out - champ "' + ItemName + '" : non présent');
  end;
  if Other.ChampsOut.Count <> FChampsOut.Count then
    Result.Add('Procedure "' + Name + '" - out - pas le même nombre de champ (' + IntToStr(Other.ChampsOut.Count) + ' pour ' + IntToStr(FChampsOut.Count) + ' attendu)');
end;

procedure TInfoProcedure.SaveToXml(ParentNode : IXmlNode);
var
  NodeChampsIn, NodeChampsOut : IXmlNode;
begin
  ParentNode.Attributes['Name'] := FName;
  ParentNode.Attributes['source'] := FMd5Source;
  NodeChampsIn := ParentNode.AddChild('ListeChampsIn');
  FChampsIn.SaveToXml(NodeChampsIn, 'Champ');
  NodeChampsOut := ParentNode.AddChild('ListeChampsOut');
  FChampsOut.SaveToXml(NodeChampsOut, 'Champ');
end;

procedure TInfoProcedure.LoadFromXml(ParentNode : IXmlNode);
var
  NodeChampsIn, NodeChampsOut : IXmlNode;
begin
  FName := ParentNode.Attributes['Name'];
  FMd5Source := ParentNode.Attributes['source'];
  NodeChampsIn := GetNodeFromName('ListeChampsIn', ParentNode);
  if Assigned(NodeChampsIn) then
    FChampsIn.LoadFromXml(NodeChampsIn);
  NodeChampsOut := GetNodeFromName('ListeChampsOut', ParentNode);
  if Assigned(NodeChampsOut) then
    FChampsOut.LoadFromXml(NodeChampsOut);
end;

(******************************************************************************)
(******************************************************************************)

{ TDataBaseVerif }

function TDataBaseVerif.GetCount() : integer;
begin
  Result := FListeTables.Count + FListeGenerateurs.Count + FListeProcedures.Count + FListeTriggers.Count;
end;

constructor TDataBaseVerif.Create();
begin
  inherited Create();
  FListeTables := TListeTables.Create([doOwnsValues]);
  FListeGenerateurs := TListeGenerateurs.Create();
  FListeProcedures := TListeProcedures.Create([doOwnsValues]);
  FListeTriggers := TListeTriggers.Create();
end;

destructor TDataBaseVerif.Destroy();
begin
  FreeAndNil(FListeTables);
  FreeAndNil(FListeGenerateurs);
  FreeAndNil(FListeProcedures);
  FreeAndNil(FListeTriggers);
  inherited Destroy();
end;

function TDataBaseVerif.FillFromDatabase(Server, DataBase, Login, Password : string; Port : integer; Extract : boolean) : boolean;
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  QueryList, QueryCount : TMyQuery;
  tmpSrcProc : TStringList;
  MD5 : TIdHashMessageDigest5;
  i : integer;
  tmpTable : TInfoTable;
  tmpIndex : TInfoIndex;
  tmpChamp : TInfoChamp;
  tmpProcedure : TInfoProcedure;
begin
  Result := False;
  Clear();

  Connexion := nil;
  Transaction := nil;
  QueryList := nil;
  QueryCount := nil;
  tmpSrcProc := nil;
  MD5 := nil;

  if Extract and (Server = CST_BASE_SERVEUR) then
    ForceDirectories(IncludeTrailingPathDelimiter(ChangeFileExt(DataBase, '')));

  try
    Connexion := GetNewConnexion(Server, DataBase, Login, Password, Port, false);
    Transaction := GetNewTransaction(Connexion, false);
    QueryList := GetNewQuery(Connexion, Transaction);
    QueryCount := GetNewQuery(Connexion, Transaction);

    Connexion.Open();

    try
      Transaction.StartTransaction();

      // recup des nombre d'enregistrement
      QueryList.SQL.Text := SQL_ASK_TABLES;
      try
        QueryList.Open();
        while not QueryList.Eof do
        begin
          QueryCount.SQL.Text := Format(SQL_ASK_TABLES_COUNT, [Trim(QueryList.FieldByName('name').AsString)]);
          try
            QueryCount.Open();
            if not QueryCount.Eof then
            begin
              tmpTable := TInfoTable.Create();
              tmpTable.Name := Trim(QueryList.FieldByName('name').AsString);
              tmpTable.NbEnreg := QueryCount.FieldByName('nombre').AsInteger;
              FListeTables.Add(Trim(QueryList.FieldByName('name').AsString), tmpTable);
            end
            else
              Raise Exception.Create('Pas de resultat pour le count(*) de ' + QueryList.FieldByName('name').AsString);
          finally
            QueryCount.Close();
          end;
          QueryList.Next();
        end;
      finally
        QueryList.Close();
      end;

      // recup des Champs
      QueryList.SQL.Text := SQL_ASK_CHAMPS;
      try
        QueryList.Open();
        while not QueryList.Eof do
        begin
          if FListeTables.ContainsKey(Trim(QueryList.FieldByName('table_name').AsString)) then
          begin
            tmpChamp := TInfoChamp.Create();
            tmpChamp.Name := Trim(QueryList.FieldByName('field_name').AsString);
            tmpChamp.Idx := QueryList.FieldByName('field_position').AsInteger;
            tmpChamp.Field_Type.FType := Trim(GetTypeFromDB(QueryList));
            tmpChamp.Field_Type.FNullable := not (QueryList.FieldByName('field_nullable').AsInteger = 1);
            tmpChamp.Field_Type.FDefault := Trim(QueryList.FieldByName('field_default').AsString);
            tmpChamp.Field_Domain.FType := Trim(QueryList.FieldByName('domain_type').AsString);
            tmpChamp.Field_Domain.FNullable := not (QueryList.FieldByName('domain_nullable').AsInteger = 1);
            tmpChamp.Field_Domain.FDefault := Trim(QueryList.FieldByName('domain_default').AsString);
            FListeTables[Trim(QueryList.FieldByName('table_name').AsString)].Champs.Add(Trim(QueryList.FieldByName('field_name').AsString), tmpChamp);
          end;
          QueryList.Next();
        end;
      finally
        QueryList.Close();
      end;

      // recup des Indexes
      QueryList.SQL.Text := SQL_ASK_INDEXES;
      try
        QueryList.Open();
        while not QueryList.Eof do
        begin
          if FListeTables.ContainsKey(Trim(QueryList.FieldByName('tablename').AsString)) then
          begin
            if FListeTables[Trim(QueryList.FieldByName('tablename').AsString)].Indexes.ContainsKey(QueryList.FieldByName('indexname').AsString) then
              FListeTables[Trim(QueryList.FieldByName('tablename').AsString)].Indexes[Trim(QueryList.FieldByName('indexname').AsString)].Champs.Add(Trim(QueryList.FieldByName('fieldname').AsString))
            else
            begin
              tmpIndex := TInfoIndex.Create();
              tmpIndex.Name := Trim(QueryList.FieldByName('indexname').AsString);
              tmpIndex.Unique := (QueryList.FieldByName('flagunique').AsInteger = 1);
              tmpIndex.Champs.Add(Trim(QueryList.FieldByName('fieldname').AsString));
              FListeTables[Trim(QueryList.FieldByName('tablename').AsString)].Indexes.Add(Trim(QueryList.FieldByName('indexname').AsString), tmpIndex);
            end;
          end;
          QueryList.Next();
        end;
      finally
        QueryList.Close();
      end;

      // recup du niveau des generateur
      QueryList.SQL.Text := SQL_ASK_GENERATEURS;
      try
        QueryList.Open();
        while not QueryList.Eof do
        begin
          QueryCount.SQL.Text := Format(SQL_ASK_GENERATEURS_LEVEL, [Trim(QueryList.FieldByName('name').AsString)]);
          try
            QueryCount.Open();
            if not QueryCount.Eof then
              FListeGenerateurs.Add(Trim(QueryList.FieldByName('name').AsString), QueryCount.FieldByName('nombre').AsInteger)
            else
              Raise Exception.Create('Pas de resultat pour le niveau de "' + Trim(QueryList.FieldByName('name').AsString) + '"');
          finally
            QueryCount.Close();
          end;
          QueryList.Next();
        end;
      finally
        QueryList.Close();
      end;

      try
        MD5 := TIdHashMessageDigest5.Create();
        tmpSrcProc := TStringList.Create();
        tmpSrcProc.Delimiter := #10;
        tmpSrcProc.StrictDelimiter := true;

        // recup des sources des procedures
        QueryList.SQL.Text := SQL_ASK_PROCEDURES;
        try
          QueryList.Open();
          while not QueryList.Eof do
          begin
            tmpProcedure := TInfoProcedure.Create;
            tmpProcedure.Name := Trim(QueryList.FieldByName('name').AsString);
            tmpSrcProc.DelimitedText := Trim(StringReplace(QueryList.FieldByName('source').AsString, #13#10, #10, [rfReplaceAll]));
            if Extract and (Server = CST_BASE_SERVEUR) then
              tmpSrcProc.SaveToFile(IncludeTrailingPathDelimiter(ChangeFileExt(DataBase, '')) + tmpProcedure.Name + '.sql');
            for i := 0 to tmpSrcProc.Count -1 do
              tmpSrcProc[i] := Trim(tmpSrcProc[i]);
            tmpProcedure.Md5Source := MD5.HashStringAsHex(tmpSrcProc.Text);
            FListeProcedures.Add(Trim(QueryList.FieldByName('name').AsString), tmpProcedure);
            QueryList.Next();
          end;
        finally
          QueryList.Close();
        end;

        // recup des paramètre
        QueryList.SQL.Text := SQL_ASK_PARAMETERS;
        try
          QueryList.Open();
          while not QueryList.Eof do
          begin
            if FListeProcedures.ContainsKey(Trim(QueryList.FieldByName('procedure_name').AsString)) then
            begin
              tmpChamp := TInfoChamp.Create();
              tmpChamp.Name := Trim(QueryList.FieldByName('parameter_name').AsString);
              tmpChamp.Idx := QueryList.FieldByName('parameter_number').AsInteger;
              tmpChamp.Field_Type.FType := Trim(GetTypeFromDB(QueryList));
              tmpChamp.Field_Type.FNullable := not (QueryList.FieldByName('parameter_nullable').AsInteger = 1);
              tmpChamp.Field_Type.FDefault := Trim(QueryList.FieldByName('parameter_default').AsString);
//              tmpChamp.Domain_Type.FType := '';
//              tmpChamp.Domain_Type.FNullable := false;
//              tmpChamp.Domain_Type.FDefault := '';
              if QueryList.FieldByName('in_or_out').AsInteger = 0 then
                FListeProcedures[Trim(QueryList.FieldByName('procedure_name').AsString)].ChampsIn.Add(Trim(QueryList.FieldByName('parameter_name').AsString), tmpChamp)
              else
                FListeProcedures[Trim(QueryList.FieldByName('procedure_name').AsString)].ChampsOut.Add(Trim(QueryList.FieldByName('parameter_name').AsString), tmpChamp);
            end;
            QueryList.Next();
          end;
        finally
          QueryList.Close();
        end;

        // recup des sources des triggers
        QueryList.SQL.Text := SQL_ASK_TRIGGERS;
        try
          QueryList.Open();
          while not QueryList.Eof do
          begin
            tmpSrcProc.DelimitedText := Trim(StringReplace(QueryList.FieldByName('source').AsString, #13#10, #10, [rfReplaceAll]));
            if Extract and (Server = CST_BASE_SERVEUR) then
              tmpSrcProc.SaveToFile(IncludeTrailingPathDelimiter(ChangeFileExt(DataBase, '')) + tmpProcedure.Name + '.sql');
            for i := 0 to tmpSrcProc.Count -1 do
              tmpSrcProc[i] := Trim(tmpSrcProc[i]);
            tmpProcedure.Md5Source := MD5.HashStringAsHex(tmpSrcProc.Text);
            FListeTriggers.Add(Trim(QueryList.FieldByName('name').AsString), MD5.HashStringAsHex(tmpSrcProc.Text));
            QueryList.Next();
          end;
        finally
          QueryList.Close();
        end;

      finally
        FreeAndNil(tmpSrcProc);
        FreeAndNil(MD5);
      end;

      Transaction.Commit();
      Result := true;
    except
      Transaction.Rollback();
      raise;
    end;
  finally
    FreeAndNil(QueryList);
    FreeAndNil(QueryCount);
    FreeAndNil(Transaction);
    FreeAndNil(Connexion);
  end;
end;

function TDataBaseVerif.CompareWith(Other : TDataBaseVerif; StructOnly : boolean) : TStringList;
var
  ItemName : string;
  TmpRes : TStringList;
begin
  Result := TStringList.Create();

  // liste des tables ?
  for ItemName in FListeTables.Keys do
  begin
    if Other.ListeTables.ContainsKey(ItemName) then
    begin
      try
        TmpRes := FListeTables[ItemName].CompareWith(Other.ListeTables[ItemName], StructOnly);
        Result.AddStrings(TmpRes);
      finally
        FreeAndNil(tmpRes);
      end;
    end
    else
      Result.Add('Table "' + ItemName + '" : non présente');
  end;
  if Other.ListeTables.Count <> FListeTables.Count then
    Result.Add('Pas le même nombre de tables (' + IntToStr(Other.ListeTables.Count) + ' pour ' + IntToStr(FListeTables.Count) + ' attendu)');
  // liste des générateurs ?
  for ItemName in FListeGenerateurs.Keys do
  begin
    if Other.ListeGenerateurs.ContainsKey(ItemName) then
    begin
      if not (StructOnly or (FListeGenerateurs[ItemName] = Other.ListeGenerateurs[ItemName])) then
        Result.Add('Générateur "' + ItemName + '" : niveau différent');
    end
    else
      Result.Add('Générateur "' + ItemName + '" : non présente');
  end;
  if Other.ListeGenerateurs.Count <> FListeGenerateurs.Count then
    Result.Add('Pas le même nombre de générateurs (' + IntToStr(Other.ListeGenerateurs.Count) + ' pour ' + IntToStr(FListeGenerateurs.Count) + ' attendu)');
  // liste des procedures ?
  for ItemName in FListeProcedures.Keys do
  begin
    if Other.ListeProcedures.ContainsKey(ItemName) then
    begin
      try
        TmpRes := ListeProcedures[ItemName].CompareWith(Other.ListeProcedures[ItemName]);
        Result.AddStrings(TmpRes);
      finally
        FreeAndNil(tmpRes);
      end;
    end
    else
      Result.Add('Procédure "' + ItemName + '" : non présente');
  end;
  if Other.ListeProcedures.Count <> FListeProcedures.Count then
    Result.Add('Pas le même nombre de procédures (' + IntToStr(Other.ListeProcedures.Count) + ' pour ' + IntToStr(FListeProcedures.Count) + ' attendu)');
  // liste des Trigger ?
  for ItemName in FListeTriggers.Keys do
  begin
    if Other.ListeTriggers.ContainsKey(ItemName) then
    begin
      if not (ListeTriggers[ItemName] = Other.ListeTriggers[ItemName]) then
        Result.Add('Trigger "' + ItemName + '" : source différente');
    end
    else
      Result.Add('Trigger "' + ItemName + '" : non présente');
  end;
  if Other.ListeTriggers.Count <> FListeTriggers.Count then
    Result.Add('Pas le même nombre de triggers (' + IntToStr(Other.ListeTriggers.Count) + ' pour ' + IntToStr(FListeTriggers.Count) + ' attendu)');
end;

function TDataBaseVerif.CompareWithDatabase(Server, DataBase, Login, Password : string; Port : integer) : TStringList;
var
  Other : TDataBaseVerif;
begin
  try
    Other := TDataBaseVerif.Create();
    Other.FillFromDatabase(Server, DataBase, Login, Password, Port);
    Result := CompareWith(Other);
  finally
    FreeAndNil(Other);
  end;
end;

procedure TDataBaseVerif.Clear();
begin
  FListeTables.Clear();
  FListeGenerateurs.Clear();
  FListeProcedures.Clear();
  FListeTriggers.Clear();
end;

procedure TDataBaseVerif.SaveToXml(ParentNode : IXmlNode);
var
  BaseNode, NodeList : IXmlNode;
begin
  BaseNode := ParentNode.AddChild('DataBaseVerif');
  NodeList := BaseNode.AddChild('ListeTables');
  FListeTables.SaveToXml(NodeList, 'Table');
  NodeList := BaseNode.AddChild('ListeGenerateurs');
  FListeGenerateurs.SaveToXml(NodeList, 'Generateur');
  NodeList := BaseNode.AddChild('ListeProcedures');
  FListeProcedures.SaveToXml(NodeList, 'Procedure');
  NodeList := BaseNode.AddChild('ListeTriggers');
  FListeTriggers.SaveToXml(NodeList, 'Trigger');
end;

procedure TDataBaseVerif.SaveToXml(FileName : string);
var
  XmlDoc : IXMLDocument;
begin
  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.Active := true;
  XmlDoc.Options := XmlDoc.Options + [doNodeAutoIndent];
  XMLDoc.DocumentElement := XMLDoc.CreateNode('Root');
  SaveToXml(XMLDoc.DocumentElement);
  XmlDoc.SaveToFile(FileName);
end;

procedure TDataBaseVerif.LoadFromXml(ParentNode : IXmlNode);
var
  BaseNode, NodeList : IXmlNode;
begin
  Clear();
  BaseNode := GetNodeFromName('DataBaseVerif', ParentNode);
  if Assigned(BaseNode) then
  begin
    NodeList := GetNodeFromName('ListeTables', BaseNode);
    if Assigned(NodeList) then
      FListeTables.LoadFromXml(NodeList);
    NodeList := GetNodeFromName('ListeGenerateurs', BaseNode);
    if Assigned(NodeList) then
      FListeGenerateurs.LoadFromXml(NodeList);
    NodeList := GetNodeFromName('ListeProcedures', BaseNode);
    if Assigned(NodeList) then
      FListeProcedures.LoadFromXml(NodeList);
    NodeList := GetNodeFromName('ListeTriggers', BaseNode);
    if Assigned(NodeList) then
      FListeTriggers.LoadFromXml(NodeList);
  end;
end;

procedure TDataBaseVerif.LoadFromXml(FileName : string);
var
  XmlDoc : IXMLDocument;
begin
  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.LoadFromFile(FileName);
  LoadFromXml(XMLDoc.DocumentElement);
end;

procedure TDataBaseVerif.SaveToJSon(FileName : string);
var
  Fichier : TStringList;
  vMarshal : TJSONMarshal;
begin
  try
    Fichier := TStringList.Create();
    try
      vMarshal := TJSONMarshal.Create();
      Fichier.Text := vMarshal.Marshal(Self).ToString;
    finally
      FreeAndNil(vMarshal);
    end;
    Fichier.SaveToFile(FileName);
  finally
    FreeAndNil(Fichier);
  end;
end;

class function TDataBaseVerif.LoadFromJSon(FileName : string) : TDataBaseVerif;
var
  Fichier : TStringList;
  vUnMarshal : TJSONUnMarshal;
  vJsonValue : TJsonValue;
begin
  try
    Fichier := TStringList.Create();
    Fichier.LoadFromFile(FileName);
    try
      vJsonValue := TJSONObject.ParseJSONValue(Fichier.Text);
      vUnMarshal := TJSONUnMarshal.Create();
      Result := TDataBaseVerif(vUnMarshal.Unmarshal(vJsonValue));
    finally
      FreeAndNil(vUnMarshal);
      FreeAndNil(vJsonValue);
    end;
  finally
    FreeAndNil(Fichier);
  end;
end;

end.

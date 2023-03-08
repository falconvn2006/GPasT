unit uTypes;

interface

uses Classes, Contnrs, SysUtils, DB, DBClient, StdCtrls ,ComCtrls, kpZipObj;

type TTableHF = Class(TObject)
    TableName : String;
    TablePseudo : String;
    Traiter   : Boolean;
    FieldList : TStringList;
    FieldPseudoList : TStringList;
    CDataSet   : TClientDataset;
    public
      // remplace le fieldByName du dataset afin qu'il gère les champ pseudo
      // Ne fonctionne qu'en lecture
      function NFieldByName(FieldName : String) : TField;
      // Remplace la fonction locate afin qu'il gère les champ pseudo
      function NLocate(const Keyfield : String;KeyValues : Variant;Options : TLocateOptions) : Boolean;

      constructor Create;
      destructor Destroy;
End;

type TTailleId = record
  TGF_ID ,
  GTF_ID ,
  TTV_ID : integer;
end;

type TNomenclature = Record
  SEC_ID,
  RAY_ID,
  FAM_ID,
  SSF_ID,
  CTF_ID,
  CAT_ID : Integer;
End;

type TGENIMPORT = record
  IMP_ID      ,
  IMP_KTBID  ,
  IMP_GINKOIA ,
  IMP_REF     ,
  IMP_NUM     : Integer;
  IMP_REFSTR  : String
end;

type TCommande = record
    CDE_NUMFOURN ,
    CDE_COMENT   : String;
    CDE_DATE     : TDateTime;
    CDE_USRID    : Integer;
    CDE_MAGID    : Integer;
    TVALignes    : array of record
      CDE_TVAHT   ,
      CDE_TVATAUX ,
      CDE_TVA     : currency;
    end;
    Lignes       : array of record
      CDL_CDEID     ,
      CDL_ARTID     ,
      CDL_TGFID     ,
      CDL_COUID     : Integer;
      CDL_QTE       : Single;
      CDL_PXACHAT   ,
      CDL_TVA       ,
      CDL_PXVENTE   : Currency;
      CDL_LIVRAISON : TDateTime;
    end;
end;

type TListCommande = array of TCommande;

type TGenParam = record
  PRM_ID      , 
  PRM_CODE    ,
  PRM_INTEGER : integer;
  PRM_FLOAT   : single;
  PRM_STRING  : String;
  PRM_TYPE    ,
  PRM_MAGID   : Integer;
  PRM_INFO    : String;
  PRM_POS     : integer;
end;

type TParamDefaut = record
  UNI_ID ,
  TVA_ID ,
  GAR_ID ,
  TCT_ID ,
  FOU_ID : integer;
  Collection ,
  Verrou     : Boolean;
  ModuleAccessOK : Boolean;  
end;

type TListTableHF = class(TObjectList)
    private
      procedure SetItem (Index : integer; Value : TTableHF);
      function  GetItem (Index : Integer) : TTableHF;
    public
      Lab : TLabel;
      Memo : TMemo;
      Progress : TProgressBar;
      lstCommande : TListbox;
      iSaison           ,
      IdFournIntersport ,
      IdFournCPAID      ,
      IdCOLID           ,
      IdTypeGT          : integer;
      function Add(AObject : TTableHF) : integer;
      procedure Insert(Index : integer; AObject : TTableHF);
      property Items[Index : Integer] : TTableHF read GetItem Write SetItem; default;
      function GetTable(sTableName : String) : TTableHF;
      constructor Create; 
  end;

type TVCLZipClass = class
  private
    FLabel : TLabel;
    FProgress : TProgressBar;
    FFileEnCours : String;
    FArchiveType : String;
  public
    property Text : TLabel read FLabel write FLabel;
    property Progress : TProgressBar read FProgress write FProgress;
    property ArchiveType : String read FArchiveType write FArchiveType;
    procedure VCLZip1FilePercentDone(Sender : TObject; PercentDone : integer);
    procedure VCLZip1TotalPercentDone(Sender: TObject; Percent: Integer);
    procedure VCLZip1StartZip(Sender: TObject; FName: string; var ZipHeader: TZipHeaderInfo; var Skip: Boolean);

end;

implementation

{ TTableHF }

constructor TTableHF.Create;
begin
  FieldList  := TStringList.Create;
  FieldPseudoList := TStringList.Create;
  CDataSet   := TClientDataSet.Create(nil);
  Traiter    := False;
end;

destructor TTableHF.Destroy;
begin
  if Assigned(FieldList) then
    FieldList.Free;
  if Assigned(FieldPseudoList) then
    FieldPseudoList.Free;
  if Assigned(CDataSet) then
    CDataSet.Free;
end;

function TTableHF.NFieldByName(FieldName: String): TField;
var
  sField : String;
  i : integer;
begin
 // On récupère le champ de la table en rapport avec le champ Pseudo
 sField := FieldName;
 for i  := 0 to FieldPseudoList.Count - 1 do
   if Pos(FieldPseudoList[i],sField) >= 1  then
     sField := StringReplace(sField,FieldPseudoList[i],FieldList[i],[rfReplaceAll]);

 Result := CDataSet.FieldByName(sField);
end;

function TTableHF.NLocate(const Keyfield: String; KeyValues: Variant;
  Options: TLocateOptions): Boolean;
var
  sKeyField : String;
  i : integer;
begin
    sKeyField := Keyfield;
    for i := 0 to FieldPseudoList.Count - 1 do
      if Pos(FieldPseudoList[i],sKeyField) >= 1 then
        sKeyField := StringReplace(sKeyField,FieldPseudoList[i],FieldList[i],[rfReplaceAll]);

    Result := CDataSet.Locate(sKeyField,KeyValues,Options);
end;

{ TListTableHF }

function TListTableHF.Add(AObject: TTableHF): integer;
begin
  Result := inherited Add(AObject);
end;

constructor TListTableHF.Create;
begin
  inherited;

end;

function TListTableHF.GetItem(Index: Integer): TTableHF;
begin
  Result := TTableHF(inherited GetItem(Index));
end;

function TListTableHF.GetTable(sTableName: String): TTableHF;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if LowerCase(Items[i].TablePseudo) = LowerCase(sTableName) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
end;

procedure TListTableHF.Insert(Index: integer; AObject: TTableHF);
begin
  inherited Insert(index, AObject);
end;

procedure TListTableHF.SetItem(Index: integer; Value: TTableHF);
begin
  inherited SetItem(Index,Value);
end;

{ TVCLZipClass }

procedure TVCLZipClass.VCLZip1FilePercentDone(Sender: TObject;
  PercentDone: integer);
begin
  FLabel.Caption := FArchiveType + ' -> Fichier : ' + ExtractFileName(FFileEnCours) + ' (' + IntToStr(PercentDone) + '%)';
//  FProgress.Position := PercentDone;
end;

procedure TVCLZipClass.VCLZip1StartZip(Sender: TObject; FName: string;
  var ZipHeader: TZipHeaderInfo; var Skip: Boolean);
begin
  FFileEnCours := FName;
end;

procedure TVCLZipClass.VCLZip1TotalPercentDone(Sender: TObject;
  Percent: Integer);
begin
  FProgress.Position := Percent;
end;

end.

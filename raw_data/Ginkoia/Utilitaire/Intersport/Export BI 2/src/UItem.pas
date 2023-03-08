unit UItem;

interface

uses
  system.Generics.Collections;

type
  TItem = class(TObject)
  strict private
    FId : integer;
    FCode, FNom : string;
    FActif : boolean;
  public
    constructor Create(); reintroduce; overload;
    constructor Create(Id : integer; Code, Nom : string; Actif : boolean); reintroduce; overload;
    procedure Assign(Source : TItem); virtual;
    function Clone() : TItem; virtual;
    property Id : integer read FId write FId;
    property Code : string read FCode write FCode;
    property Nom : string read FNom write FNom;
    property Actif : boolean read FActif write FActif;
  end;

  TItemClass = class of TItem;

  TDossierItem = class(TItem)
  strict private
    FServeur, FFileName : string;
  public
    constructor Create(); reintroduce; overload;
    constructor Create(Id : integer; Code, Nom, Serveur, FileName : string; Actif : boolean); reintroduce; overload;
    procedure Assign(Source : TItem); override;
    property Serveur : string read FServeur write FServeur;
    property FileName : string read FFileName write FFileName;
  end;

  TMagasinItem = class(TItem)
  strict private
    FIsInit : boolean;
    FDateInit : TDate;
    FDateDrnTrt : TDate;
    FDossier : TDossierItem;
  public
    constructor Create(); reintroduce; overload;
    constructor Create(Id : integer; Code, Nom : string; Actif, IsInit : boolean; DateInit, DateDrnTrt : TDate; Dossier : TDossierItem); reintroduce; overload;
    procedure Assign(Source : TItem); override;
    property IsInit : boolean read FIsInit write FIsInit;
    property DateInit : TDate read FDateInit write FDateInit;
    property DateDrnTrt : TDate read FDateDrnTrt write FDateDrnTrt;
    property Dossier : TDossierItem read FDossier write FDossier;
  end;

type
  TItemDictionary<TKey : TItem; TValue : TItem> = class(TObjectDictionary<TKey, TObjectList<TValue>>)
  protected
    function GetCountValues() : integer;
  public
    property CountValues: Integer read GetCountValues;
  end;

implementation

{ TItem }

constructor TItem.Create();
begin
  inherited Create();
  FId := 0;
  FCode := '';
  FNom := '';
  FActif := false;
end;

constructor TItem.Create(Id : integer; Code, Nom : string; Actif : boolean);
begin
  inherited Create();
  FId := id;
  FCode := Code;
  FNom := Nom;
  FActif := Actif;
end;

procedure TItem.Assign(Source : TItem);
begin
//  inherited Assign(Source);
  FId := Source.Id;
  FCode := Source.Code;
  FNom := Source.Nom;
  FActif := Source.Actif;
end;

function TItem.Clone() : TItem;
begin
  Result := TItemClass(Self.ClassType).Create();
  Result.Assign(self);
end;

{ TDossierItem }

constructor TDossierItem.Create();
begin
  inherited Create();
  FServeur := '';
  FFileName := '';
end;

constructor TDossierItem.Create(Id : integer; Code, Nom, Serveur, FileName : string; Actif : boolean);
begin
  inherited Create(Id, Code, Nom, Actif);
  FServeur := Serveur;
  FFileName := FileName;
end;

procedure TDossierItem.Assign(Source : TItem);
begin
  inherited Assign(Source);
  FServeur := TDossierItem(Source).Serveur;
  FFileName := TDossierItem(Source).FileName;
end;

{ TMagasinItem }

constructor TMagasinItem.Create();
begin
  inherited Create();
  FIsInit := false;
  FDateInit := 0;
  FDossier := nil;
end;

constructor TMagasinItem.Create(Id : integer; Code, Nom : string; Actif, IsInit : boolean; DateInit, DateDrnTrt : TDate; Dossier : TDossierItem);
begin
  inherited Create(Id, Code, Nom, Actif);
  FIsInit := IsInit;
  FDateInit := DateInit;
  FDateDrnTrt := DateDrnTrt;
  FDossier := Dossier;
end;

procedure TMagasinItem.Assign(Source : TItem);
begin
  inherited Assign(Source);
  FIsInit := TMagasinItem(Source).IsInit;
  FDateInit := TMagasinItem(Source).DateInit;
  FDateDrnTrt := TMagasinItem(Source).DateDrnTrt;
  FDossier := nil;
end;

{ TItemDictionary<TKey, TValue> }

function TItemDictionary<TKey, TValue>.GetCountValues() : integer;
var
  Key : TKey;
begin
  Result := 0;
  for Key in Keys do
    Inc(Result, Items[Key].Count);
end;

end.

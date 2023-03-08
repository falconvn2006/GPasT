unit GSDataSelection_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  DB,
  Buttons,
  Generics.Collections;

type
  TResultList = TList<Integer>;

  Tfrm_SelectListe = class(TForm)
    lv_ListeItems: TListView;
    Btn_Valider: TBitBtn;
    Btn_Annuler: TBitBtn;
    Lab_Infos: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure lv_ListeItemsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_ListeItemsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);

    procedure lv_ListeItemsDblClick(Sender: TObject);
    procedure Btn_AnnulerClick(Sender: TObject);
    procedure Btn_ValiderClick(Sender: TObject);
  private
    { Déclarations privées }
    // pour la gestion du trie
    FSortIdx : integer;

    // données
    FDataSet : TDataset;
    FFieldID : string;
    FFieldsToShow : TStringList;

    FSelectedID : TResultList;

    // accesseur de property
    procedure SetDataSet(Value : TDataset);
    procedure SetFieldID(Value : string);
    function GetFieldsToShow() : TStringList;
    procedure SetFieldsToShow(Value : TStringList);
    function GetHeaders() : TStringList;
    procedure SetHeaders(Value : TStringList);
    function GetSelectedID() : TResultList;
//    procedure SetSelectedID(Value : TResultList);

    // chargement
    procedure LoadData();
  public
    { Déclarations publiques }

    property DataSet : TDataSet read FDataSet write SetDataSet;
    property FieldID : string read FFieldID write SetFieldID;
    property FieldsToShow : TStringList read GetFieldsToShow write SetFieldsToShow;
    property Headers : TStringList read GetHeaders write SetHeaders;
    property SelectedID : TResultList read GetSelectedID write FSelectedID;
  end;

function SelectInListe(ParentFrm : TForm; Caption : string; DataSet : TDataSet; FieldID : string; FieldsToShow, Headers : array of string;SelectedID : TResultList) : boolean; overload;
function SelectInListe(ParentFrm : TForm; Caption : string; DataSet : TDataSet; FieldID : string; FieldsToShow, Headers : TStringList; SelectedID : TResultList) : boolean; overload;

implementation

uses
  Math,
  IdGlobal,
  CommCtrl;

{$R *.dfm}

function SelectInListe(ParentFrm : TForm; Caption : string; DataSet : TDataSet; FieldID : string; FieldsToShow, Headers : array of string; SelectedID : TResultList) : boolean;
var
  i : integer;
  tmpFieldsToShow, tmpHeaders : TStringList;
begin
  try
    tmpFieldsToShow := TStringList.Create();
    for i := 0 to Length(FieldsToShow) -1 do
      tmpFieldsToShow.Add(FieldsToShow[i]);
    tmpHeaders := TStringList.Create();
    for i := 0 to Length(Headers) -1 do
      tmpHeaders.Add(Headers[i]);
    Result := SelectInListe(ParentFrm, Caption, DataSet, FieldID, tmpFieldsToShow, tmpHeaders, SelectedID);
  finally
    FreeAndNil(tmpFieldsToShow);
    FreeAndNil(tmpHeaders);
  end;
end;

function SelectInListe(ParentFrm : TForm; Caption : string; DataSet : TDataSet; FieldID : string; FieldsToShow, Headers : TStringList; SelectedID : TResultList) : boolean;
var
  Fiche : Tfrm_SelectListe;
begin
  Result := false;
  try
    Fiche := Tfrm_SelectListe.Create(ParentFrm);

    Fiche.Caption := Caption;

    Fiche.DataSet := DataSet;
    Fiche.FieldID := FieldID;
    Fiche.FieldsToShow := FieldsToShow;
    Fiche.Headers := Headers;
    Fiche.SelectedID := SelectedID;

    if (Fiche.lv_ListeItems.Items.Count = 1) and (Fiche.SelectedID.Count = 1) then
    begin
      SelectedID := Fiche.SelectedID;
      Result := true;
    end
    else
    begin
      if Fiche.ShowModal() = mrOK then
      begin
        SelectedID := Fiche.SelectedID;
        if SelectedID.Count > 0 then
          Result := true;
      end;
    end;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ Tfrm_SelectListe }

procedure Tfrm_SelectListe.FormCreate(Sender: TObject);
begin
  FSortIdx := 0;
  FDataSet := nil;
  FFieldID := '';
  FFieldsToShow := TStringList.Create();
end;

procedure Tfrm_SelectListe.FormShow(Sender: TObject);
begin
  // eurf
end;

procedure Tfrm_SelectListe.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // eurf
end;

procedure Tfrm_SelectListe.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFieldsToShow);
end;

// enevement !

procedure Tfrm_SelectListe.lv_ListeItemsColumnClick(Sender: TObject; Column: TListColumn);
begin
  try
    lv_ListeItems.SortType := stNone;
    if (Column.Index +1 = FSortIdx) then
      FSortIdx := -FSortIdx
    else
      FSortIdx := Column.Index +1;
  finally
    lv_ListeItems.SortType := stBoth;
  end;
end;

procedure Tfrm_SelectListe.lv_ListeItemsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FSortIdx = 0 then
    Compare := 0
  else
  begin
    if Abs(FSortIdx) = 1 then
    begin
      if (Item1.Caption = 'XICKET') then
        Compare := -2
      else if (Item2.Caption = 'XICKET') then
        Compare := 2
      else
        Compare := Sign(FSortIdx) * CompareStr(Item1.Caption, Item2.Caption);
    end
    else
    begin
      if IsNumeric(Item1.SubItems[Abs(FSortIdx) -2]) and IsNumeric(Item2.SubItems[Abs(FSortIdx) -2]) then
        Compare := Sign(FSortIdx) * CompareValue(StrToFloat(Item1.SubItems[Abs(FSortIdx) -2]), StrToFloat(Item2.SubItems[Abs(FSortIdx) -2]))
      else
        Compare := Sign(FSortIdx) * CompareStr(Item1.SubItems[Abs(FSortIdx) -2], Item2.SubItems[Abs(FSortIdx) -2]);
    end;
  end;
end;

procedure Tfrm_SelectListe.lv_ListeItemsDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure Tfrm_SelectListe.Btn_AnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_SelectListe.Btn_ValiderClick(Sender: TObject);
begin
  if lv_ListeItems.ItemIndex >= 0 then
    ModalResult := mrOk
  else
    ModalResult := mrCancel;
end;

// accesseur de property

procedure Tfrm_SelectListe.SetDataSet(Value : TDataset);
begin
  if not (FDataSet = Value) then
  begin
    FDataSet := Value;
    LoadData();
  end;
end;

procedure Tfrm_SelectListe.SetFieldID(Value : string);
begin
  if not (FFieldID = Value) then
  begin
    FFieldID := Value;
    LoadData();
  end;
end;

function Tfrm_SelectListe.GetFieldsToShow() : TStringList;
begin
  Result := TStringList.Create();
  Result.AddStrings(FFieldsToShow);
end;

procedure Tfrm_SelectListe.SetFieldsToShow(Value : TStringList);
begin
  FFieldsToShow.Clear();
  FFieldsToShow.AddStrings(Value);
  LoadData();
end;

function Tfrm_SelectListe.GetHeaders() : TStringList;
var
  i : integer;
begin
  Result := TStringList.Create();
  for i := 0 to lv_ListeItems.Columns.Count -1 do
    Result.Add(lv_ListeItems.Columns[i].Caption);
end;

procedure Tfrm_SelectListe.SetHeaders(Value : TStringList);
var
  i : integer;
  Colonne : TListColumn;
begin
  for i := 0 to Value.Count -1 do
  begin
    Colonne := lv_ListeItems.Columns.Add();
    Colonne.Caption := Value[i];
    // AutoSize des columns
    case i of
      0:
        begin
          lv_ListeItems.Columns[0].Width := LVSCW_AUTOSIZE_USEHEADER;
        end;
      1:
        begin
          Colonne.AutoSize := True;
          lv_ListeItems.Columns[1].Width := LVSCW_AUTOSIZE;
        end;
    end;
  end;
  LoadData();
end;

function Tfrm_SelectListe.GetSelectedID() : TResultList;
var
  i : Integer;
begin
  FSelectedID.Clear;
  for i := 0 to lv_ListeItems.Items.Count -1 do
    if lv_ListeItems.Items[i].Selected then
      FSelectedID.Add(Integer(lv_ListeItems.Items[i].Data));
  Result := FSelectedID;
end;

//procedure Tfrm_SelectListe.SetSelectedID(Value : TResultList);
//var
//  i : integer;
//begin


//  for i := 0 to lv_ListeItems.Items.Count -1 do
//  begin
//    if Integer(Pointer(lv_ListeItems.Items[i].Data)) = Value then
//    begin
//      lv_ListeItems.ItemIndex := i;
//      Break;
//    end;
//  end;
//end;

// remplisage de la liste !

procedure Tfrm_SelectListe.LoadData();
var
  Bookmark : TBookmark;
  Item : TListItem;
  i, j : integer;
begin
  if Assigned(FDataSet) and
     (not (Trim(FFieldID) = '')) and
     (FFieldsToShow.Count > 0) and
     (lv_ListeItems.Columns.Count > 0) then
  begin
    try
      FDataSet.DisableControls();
      try
        Bookmark := FDataSet.GetBookmark();

        FDataSet.First();
        while not FDataSet.Eof do
        begin
          // ajout de l'item
          Item := lv_ListeItems.Items.Add();
          Item.Caption := FDataSet.FieldByName(FFieldsToShow[0]).AsString;
          for i := 1 to FFieldsToShow.Count -1 do
            Item.SubItems.Add(FDataSet.FieldByName(FFieldsToShow[i]).AsString);
          Item.Data := Pointer(FDataSet.FieldByName(FFieldID).AsInteger);
          // suivant
          FDataSet.Next();
        end;
      finally
        FDataSet.GotoBookmark(Bookmark);
        FDataSet.FreeBookmark(Bookmark);
      end;
    finally
      FDataSet.EnableControls();
    end;
    if (lv_ListeItems.Items.Count > 1) and (lv_ListeItems.Columns.Count = 1) then
    begin
      FSortIdx := 1;
      lv_ListeItems.SortType := stNone;
      lv_ListeItems.SortType := stBoth;
    end;

    // sélection par défaut !
    if lv_ListeItems.Items.Count > 0 then
      lv_ListeItems.ItemIndex := 0;
    // activation des bouton !
    Btn_Annuler.Enabled := true;
    Btn_Valider.Enabled := true;
  end;
end;

end.

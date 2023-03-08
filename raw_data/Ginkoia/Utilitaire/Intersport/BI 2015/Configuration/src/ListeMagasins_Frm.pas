unit ListeMagasins_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  FireDAC.Comp.Client,
  uGestionBDD;

type
  TInfosMag = class
  protected
    FCodeAdh, FNom, FEnseigne, FBasSender : string;
    FActif : boolean;
  public
    constructor Create(CodeAdh, Nom, Enseigne, BasSender : string; Actif : boolean); reintroduce;

    property CodeAdh : string read FCodeAdh;
    property Nom : string read FNom;
    property Enseigne : string read FEnseigne;
    property BasSender : string read FBasSender;
    property Actif : boolean read FActif;
  end;

type
  Tfrm_ListeMagasins = class(TForm)
    chk_CodeAdh: TCheckBox;
    chk_Nom: TCheckBox;
    chk_Enseigne: TCheckBox;
    lv_ListeMagasins: TListView;
    btn_Quitter: TButton;
    btn_Parametrer: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure chk_LibelleMagClick(Sender: TObject);
    procedure lv_ListeMagasinsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_ListeMagasinsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure btn_QuitterClick(Sender: TObject);
    procedure btn_ParametrerClick(Sender: TObject);
  private
    { Déclarations privées }
  protected
    // Connexion
    FServeur, FDatabase : string;
    // la Liste
    FInfosMag : TObjectList<TInfosMag>;
    // gestion du tri !
    FSortIdx : integer;
    // refresh ??
    FHasToRefresh : boolean;

    function GetServeur() : string;
    procedure SetServeur(Value : string);
    function GetDataBase() : string;
    procedure SetDataBase(Value : string);

    procedure LoadMagasins();
    procedure ShowMagasins();
  public
    { Déclarations publiques }
    property Serveur : string read GetServeur write SetServeur;
    property DataBase : string read GetDataBase write SetDataBase;
    property HasToRefresh : boolean read FHasToRefresh;
  end;

procedure ShowListeMagasins(ParentFrm : TForm; BaseGnk : string; out HasToRefresh : boolean); overload;
procedure ShowListeMagasins(ParentFrm : TForm; Serveur, BaseGnk : string; out HasToRefresh : boolean); overload;

implementation

uses
  System.Math,
  IdGlobal,
  Param_Frm,
  ULectureIniFile;

{$R *.dfm}

const
  CST_COLONNE_CODE = 'Code';
  CST_COLONNE_NOM = 'Nom';
  CST_COLONNE_ENSEIGNE = 'Enseigne';
  CST_COLONNE_SENDER = 'Sender';
  CST_COLONNE_ACTIF = 'Actif';

procedure ShowListeMagasins(ParentFrm : TForm; BaseGnk : string; out HasToRefresh : boolean);
begin
  ShowListeMagasins(ParentFrm, CST_BASE_SERVEUR, BaseGnk, HasToRefresh)
end;

procedure ShowListeMagasins(ParentFrm : TForm; Serveur, BaseGnk : string; out HasToRefresh : boolean);
var
  Fiche : Tfrm_ListeMagasins;
begin
  try
    Fiche := Tfrm_ListeMagasins.Create(ParentFrm);
    Fiche.Serveur := Serveur;
    Fiche.DataBase := BaseGnk;
    Fiche.ShowModal();
    HasToRefresh := Fiche.HasToRefresh;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ TInfosMag }

constructor TInfosMag.Create(CodeAdh, Nom, Enseigne, BasSender : string; Actif : boolean);
begin
  inherited Create();
  FCodeAdh := CodeAdh;
  FNom := Nom;
  FEnseigne := Enseigne;
  FBasSender := BasSender;
  FActif := Actif;
end;

{ Tfrm_ListeMagasins }

procedure Tfrm_ListeMagasins.FormCreate(Sender: TObject);
var
  Code, Nom, Enseigne : boolean;
begin
  FSortIdx := 0;
  FServeur := 'localhost';
  FDatabase := '';
  FInfosMag := TObjectList<TInfosMag>.Create(True);
  FHasToRefresh := false;

  // valeur par defaut d'affichage
  if ReadIniColonneListeMagasin(Code, Nom, Enseigne) then
  begin
    chk_CodeAdh.Checked := Code;
    chk_Nom.Checked := Nom;
    chk_Enseigne.Checked := Enseigne;
  end;
end;

procedure Tfrm_ListeMagasins.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FInfosMag);
  WriteIniColonneListeMagasin(chk_CodeAdh.Checked, chk_Nom.Checked, chk_Enseigne.Checked);
end;

procedure Tfrm_ListeMagasins.chk_LibelleMagClick(Sender: TObject);
begin
  if not (chk_CodeAdh.Checked or chk_Nom.Checked or chk_Enseigne.Checked) then
    chk_Nom.Checked := true;
  ShowMagasins();
end;

procedure Tfrm_ListeMagasins.lv_ListeMagasinsColumnClick(Sender: TObject; Column: TListColumn);
begin
  try
    lv_ListeMagasins.SortType := stNone;
    if (Column.Index +1 = FSortIdx) then
      FSortIdx := -FSortIdx
    else
      FSortIdx := Column.Index +1;
  finally
    lv_ListeMagasins.SortType := stBoth;
  end;
end;

procedure Tfrm_ListeMagasins.lv_ListeMagasinsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FSortIdx = 0 then
    Compare := 0
  else
  begin
    if Abs(FSortIdx) = 1 then
      Compare := Sign(FSortIdx) * CompareStr(Item1.Caption, Item2.Caption)
    else
    begin
      if IsNumeric(Item1.SubItems[Abs(FSortIdx) -2]) and IsNumeric(Item2.SubItems[Abs(FSortIdx) -2]) then
        Compare := Sign(FSortIdx) * CompareValue(StrToFloat(Item1.SubItems[Abs(FSortIdx) -2]), StrToFloat(Item2.SubItems[Abs(FSortIdx) -2]))
      else
        Compare := Sign(FSortIdx) * CompareStr(Item1.SubItems[Abs(FSortIdx) -2], Item2.SubItems[Abs(FSortIdx) -2]);
    end;
  end;
end;

procedure Tfrm_ListeMagasins.btn_ParametrerClick(Sender: TObject);
begin
  DoParametrage(Self, Serveur, DataBase, FHasToRefresh);
  if FHasToRefresh then
    LoadMagasins();
end;

procedure Tfrm_ListeMagasins.btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// accesseur

function Tfrm_ListeMagasins.GetServeur() : string;
begin
  result := FServeur;
end;

procedure Tfrm_ListeMagasins.SetServeur(Value : string);
begin
  if not (FServeur = Value) then
  begin
    FServeur := Value;

    if not ((Trim(FServeur) = '') or (Trim(FDatabase) = '')) then
      LoadMagasins();
  end;
end;

function Tfrm_ListeMagasins.GetDataBase() : string;
begin
  result := FDatabase;
end;

procedure Tfrm_ListeMagasins.SetDataBase(Value : string);
begin
  if not (FDataBase = Value) then
  begin
    FDataBase := Value;

    if not ((Trim(FServeur) = '') or (Trim(FDatabase) = '')) then
      LoadMagasins();
  end;
end;

// recherche en base

procedure Tfrm_ListeMagasins.LoadMagasins();
var
  Connexion : TMyConnection;
  Query : TMyQuery;
  BasNomPourNous : string;
begin
  BasNomPourNous := '';
  FInfosMag.Clear();

  Connexion := GetNewConnexion(FServeur, FDatabase, 'sysdba', 'masterkey', false);
  try
    Query := GetNewQuery(Connexion);
    try
      Connexion.Open();

      // nom du dossier
      Query.SQL.Text := 'select bas_nompournous, count(*) from genbases join k on k_id = bas_id and k_enabled = 1 where bas_id != 0 group by bas_nompournous order by 2 rows 1;';
      try
        Query.Open();
        if not Query.Eof then
          BasNomPourNous := Query.FieldByName('bas_nompournous').AsString;
      finally
        Query.Close();
      end;

      // Liste des magasins
      Query.SQL.Text := 'select mag_codeadh, mag_nom, mag_enseigne, bas_sender, prmactif.prm_integer as actif '
                      + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                      + 'join genparam prmactif join k on k_id = prmactif.prm_id and k_enabled = 1 on prmactif.prm_type = 25 and prmactif.prm_code = 1 and prmactif.prm_magid = mag_id '
                      + 'join genparam prmaffect join k on k_id = prmaffect.prm_id and k_enabled = 1 on prmaffect.prm_type = 25 and prmaffect.prm_code = 2 and prmaffect.prm_magid = mag_id '
                      + 'join genbases join k on k_id = bas_id and k_enabled = 1 on bas_id = prmaffect.prm_integer '
                      + 'where mag_id != 0 '
                      + 'order by mag_codeadh;';
      try
        Query.Open();
        while not Query.Eof do
        begin
          FInfosMag.Add(TInfosMag.Create(Query.FieldByName('mag_codeadh').AsString,
                                         Query.FieldByName('mag_nom').AsString,
                                         Query.FieldByName('mag_enseigne').AsString,
                                         Query.FieldByName('bas_sender').AsString,
                                         (Query.FieldByName('actif').AsInteger = 1)));
          Query.Next();
        end;
      finally
        Query.Close();
      end;
    finally
      FreeAndNil(Query);
    end;
  finally
    FreeAndNil(Connexion);
  end;

  //=========================================================================
  // affichage du libelle !
  if Trim(BasNomPourNous) = '' then
    Self.Caption := 'Liste des magasins'
  else
    Self.Caption := 'Liste des magasins (Dossier : ' + BasNomPourNous + ')';

  //=========================================================================
  // Affichage des magasin
  ShowMagasins();
end;

procedure Tfrm_ListeMagasins.ShowMagasins();
const
  marge = 14;
var
  Colonne : TListColumn;
  Magasin : TInfosMag;
  Item : TListItem;
  i : integer;
begin
  lv_ListeMagasins.Items.Clear();
  lv_ListeMagasins.Columns.Clear();
  lv_ListeMagasins.SortType := stNone;
  FSortIdx := 0;

  try
    lv_ListeMagasins.Items.BeginUpdate();

    // recréation de la liste des colonne !
    if chk_CodeAdh.Checked then
    begin
      Colonne := lv_ListeMagasins.Columns.Add();
      Colonne.Caption := CST_COLONNE_CODE;
      Colonne.Width := 40;
    end;
    if chk_Nom.Checked then
    begin
      Colonne := lv_ListeMagasins.Columns.Add();
      Colonne.Caption := CST_COLONNE_NOM;
      Colonne.Width := 75;
    end;
    if chk_Enseigne.Checked then
    begin
      Colonne := lv_ListeMagasins.Columns.Add();
      Colonne.Caption := CST_COLONNE_ENSEIGNE;
      Colonne.Width := 75;
    end;
    Colonne := lv_ListeMagasins.Columns.Add();
    Colonne.Caption := CST_COLONNE_SENDER;
    Colonne.Width := 70;
    Colonne := lv_ListeMagasins.Columns.Add();
    Colonne.Caption := CST_COLONNE_ACTIF;
    Colonne.Width := 40;

    for Magasin in FInfosMag do
    begin
      Item := lv_ListeMagasins.Items.Add();
      // le libelle
      if chk_CodeAdh.Checked then
        Item.Caption := Magasin.CodeAdh;
      if chk_Nom.Checked then
      begin
        if not chk_CodeAdh.Checked then
          Item.Caption := Magasin.Nom
        else
          Item.SubItems.Add(Magasin.Nom);
      end;
      if chk_Enseigne.Checked then
      begin
        if not (chk_CodeAdh.Checked or chk_Nom.Checked) then
          Item.Caption := Magasin.Enseigne
        else
          Item.SubItems.Add(Magasin.Enseigne);
      end;
      // autres infos
      Item.SubItems.Add(Magasin.BasSender);
      if Magasin.BasSender = '' then
        Item.SubItems.Add('')
      else if Magasin.Actif then
        Item.SubItems.Add('oui')
      else
        Item.SubItems.Add('non');

      // redimentionnement !
      lv_ListeMagasins.Columns[0].Width := Max(lv_ListeMagasins.Columns[0].Width, lv_ListeMagasins.Canvas.TextWidth(Item.Caption) + marge);
      for i := 1 to lv_ListeMagasins.Columns.Count -1 do
        lv_ListeMagasins.Columns[i].Width := Max(lv_ListeMagasins.Columns[i].Width, lv_ListeMagasins.Canvas.TextWidth(Item.SubItems[i -1]) + marge);
    end;
  finally
    lv_ListeMagasins.Items.EndUpdate();
  end;
end;

end.

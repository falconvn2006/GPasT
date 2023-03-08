unit MainFrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Generics.Collections;

type
  TListMagasins = TList<integer>;

type
  TInfosCodeBarre = class(TObject)
  private
    FCodeType : integer;
    FEAN : string;
  public
    constructor Create(CodeType : integer; EAN : string); reintroduce;
    property CodeType : integer read FCodeType write FCodeType;
    property EAN : string read FEAN write FEAN;
  end;
  TListCodesBarres = TObjectList<TInfosCodeBarre>;
  TListInfosCodesBarres = TObjectDictionary<string, TListCodesBarres>;
  TInfosCouleur = class(TObject)
  private
    FNewID : integer;
    FCode, FNom : string;
    FListCodeBarre : TListInfosCodesBarres;
  public
    constructor Create(newID : integer; Code, Nom : string); reintroduce;
    destructor Destroy(); override;
    property newID : integer read FNewID write FNewID;
    property Code : string read FCode write FCode;
    property Nom : string read FNom write FNom;
    property ListeCodeBarre : TListInfosCodesBarres read FListCodeBarre;
  end;
  TListNewCouleurs = TObjectDictionary<integer, TInfosCouleur>;
  TArticleInfos = class(TObject)
  private
    FCode, FNom : string;
    FIdArf : integer;
    FListCouleur : TListNewCouleurs;
  public
    constructor Create(Code, Nom : string); reintroduce;
    destructor Destroy(); override;
    property Code : string read FCode write FCode;
    property Nom : string read FNom write FNom;
    property IdArf : integer read FIdArf write FIdArf;
    property ListeCouleur : TListNewCouleurs read FListCouleur;
  end;
  TListArticles = TObjectDictionary<integer, TArticleInfos>;

type
  TResTraitement = record
    nbArticles : integer;
    nbNewCouleurs : integer;
    nbNewGin : integer;
    nbMovedCB : integer;
    nbExistsCB : integer;
    nbNewCB : integer;
    nbDelCB : integer;
  end;
  TResCodeBareFourn = record
    nbMovedCB : integer;
    nbExistsCB : integer;
    nbNewCB : integer;
    nbDelCB : integer;
  end;

type
  Tfrm_Main = class(TForm)
    lbl_Base: TLabel;
    edt_Base: TEdit;
    btn_Base: TSpeedButton;
    lbl_Articles: TLabel;
    edt_Articles: TEdit;
    btn_Articles: TSpeedButton;
    Panel2: TPanel;
    btn_Traitement: TButton;
    btn_Close: TButton;
    Panel1: TPanel;
    lbl_Etape: TLabel;
    pb_Progress: TProgressBar;
    btn_SaveLog: TSpeedButton;
    mmo_Resultat: TMemo;
    edt_CodeBarre: TEdit;
    lbl_CodeBarre: TLabel;
    btn_CodeBarre: TSpeedButton;
    lbl_Tailles: TLabel;
    edt_Tailles: TEdit;
    btn_Tailles: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_BaseChange(Sender: TObject);
    procedure btn_BaseClick(Sender: TObject);
    procedure edt_ArticlesChange(Sender: TObject);
    procedure btn_ArticlesClick(Sender: TObject);
    procedure edt_CodeBarreChange(Sender: TObject);
    procedure btn_CodeBarreClick(Sender: TObject);
    procedure btn_SaveLogClick(Sender: TObject);
    procedure btn_TraitementClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure edt_TaillesChange(Sender: TObject);
    procedure btn_TaillesClick(Sender: TObject);
  private
    { Déclarations privées }

    // traitement du programme !
    function Traitement(out error : string) : boolean;
    function ReadFile(FileArticle, FileCodeBarre, FileTaille : string) : TListArticles;
    function CreateCouleurEtCodeBarre(FileBDD : string; ListeArticle : TListArticles) : TResTraitement;
    function SaveNewFile(ListeArticle : TListArticles) : boolean;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
    // activation
    procedure GestionInterface(Enabled : Boolean);
    // acces BDD
    function CanConnect(DataBaseFile : string) : boolean;
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  System.UITypes,
  Winapi.ShellAPI,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait;

{$R *.dfm}

{ TInfosCodeBarre }

constructor TInfosCodeBarre.Create(CodeType : integer; EAN : string);
begin
  inherited Create();
  FCodeType := CodeType;
  FEAN := EAN;
end;

{ TInfoCouleur }

constructor TInfosCouleur.Create(newID : integer; Code, Nom : string);
begin
  inherited Create();
  FNewID := newID;
  FCode := Code;
  FNom := Nom;

  FListCodeBarre := TListInfosCodesBarres.Create([doOwnsValues]);
end;

destructor TInfosCouleur.Destroy();
begin
  inherited Destroy();
end;

{ TArticleInfos }

constructor TArticleInfos.Create(Code, Nom : string);
begin
  inherited Create();
  FCode := Code;
  FNom := Nom;

  FListCouleur := TListNewCouleurs.Create([doOwnsValues]);
end;

destructor TArticleInfos.Destroy();
begin
  FreeAndNil(FListCouleur);
  inherited Destroy();
end;

{ Tfrm_Main }

// evenements

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  // arf !
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btn_Close.Enabled;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  // arf !
end;

procedure Tfrm_Main.edt_BaseChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_BaseClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_Base.Text);
    Open.InitialDir := ExtractFilePath(edt_Base.Text);
    Open.Filter := 'IB Database|*.IB';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'IB';
    edt_Base.Text := '';
    if Open.Execute() then
      edt_Base.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.edt_ArticlesChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_ArticlesClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_Articles.Text);
    Open.InitialDir := ExtractFilePath(edt_Articles.Text);
    Open.Filter := 'Fichier CSV|*.CSV';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'CSV';
    edt_Articles.Text := '';
    if Open.Execute() then
      edt_Articles.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.edt_CodeBarreChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_CodeBarreClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_CodeBarre.Text);
    Open.InitialDir := ExtractFilePath(edt_CodeBarre.Text);
    Open.Filter := 'Fichier CSV|*.CSV';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'CSV';
    edt_CodeBarre.Text := '';
    if Open.Execute() then
      edt_CodeBarre.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.edt_TaillesChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_TaillesClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_Tailles.Text);
    Open.InitialDir := ExtractFilePath(edt_Tailles.Text);
    Open.Filter := 'Fichier CSV|*.CSV';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'CSV';
    edt_Tailles.Text := '';
    if Open.Execute() then
      edt_Tailles.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.btn_SaveLogClick(Sender: TObject);
var
  Save : TSaveDialog;
begin
  try
    Save := TSaveDialog.Create(Self);
    Save.Filter := 'Fichier text|*.TXT';
    Save.FilterIndex := 0;
    Save.DefaultExt := 'txt';
    if Save.Execute() then
      mmo_Resultat.Lines.SaveToFile(Save.FileName);
  finally
    FreeAndNil(Save);
  end;
end;

procedure Tfrm_Main.btn_TraitementClick(Sender: TObject);
var
  error : string;
begin
  try
    GestionInterface(false);
    if Traitement(error) then
      MessageDlg('Traitement effectué correctement.', mtInformation, [mbOK], 0)
    else
      MessageDlg('Erreur lors du traitement : ' + error, mtError, [mbOK], 0);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_CloseClick(Sender: TObject);
begin
  Close();
end;

// Traitement !

function Tfrm_Main.Traitement(out error : string) : boolean;

  function GetNbCouleurs(ListeArticles : TListArticles) : integer;
  var
    IdArt : integer;
  begin
    Result := 0;
    for IdArt in ListeArticles.Keys do
      Result := Result + ListeArticles[IdArt].ListeCouleur.Count;
  end;

var
  ListeArticles : TListArticles;
  ResTraitement : TResTraitement;
begin
  result := false;
  error := '';
  mmo_Resultat.Lines.Clear();

  try
    try
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Debut du traitement.');
      // Lecture des fichiers
      ListeArticles := ReadFile(edt_Articles.Text, edt_CodeBarre.Text, edt_Tailles.Text);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de lecture des articles (' + IntToStr(ListeArticles.Count) + ' articles, ' + IntToStr(GetNbCouleurs(ListeArticles)) + ' couleurs).');
      // Traitement
      ResTraitement := CreateCouleurEtCodeBarre(edt_Base.Text, ListeArticles);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de traitement des articles :');
      mmo_Resultat.Lines.Add('    Articles traités : ' + IntToStr(ResTraitement.nbArticles));
      mmo_Resultat.Lines.Add('    Nouvelles Couleurs : ' + IntToStr(ResTraitement.nbNewCouleurs));
      mmo_Resultat.Lines.Add('    Nouveaux Codes ginkoia : ' + IntToStr(ResTraitement.nbNewGin));
      mmo_Resultat.Lines.Add('    Nouveaux Codes barres : ' + IntToStr(ResTraitement.nbNewCB));
      mmo_Resultat.Lines.Add('    Codes barres préexistant: ' + IntToStr(ResTraitement.nbExistsCB));
      mmo_Resultat.Lines.Add('    Codes barres Déplacés : ' + IntToStr(ResTraitement.nbMovedCB));
      mmo_Resultat.Lines.Add('    Codes barres Supprimés : ' + IntToStr(ResTraitement.nbDelCB));
      // Generation du fichier de sortie !
      if SaveNewFile(ListeArticles) then
      begin
        mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin du traitement.');
        Result := true;
      end
      else
        mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Erreur lors de l''enregistrement du fichier.');
    finally
      FreeAndNil(ListeArticles);
    end;
  except
    on e : Exception do
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
  end;
end;

function Tfrm_Main.ReadFile(FileArticle, FileCodeBarre, FileTaille : string) : TListArticles;

  procedure GetLigneInfos(Ligne : string; Infos : TStringList; nbChamps : integer = 0);
  var
    Value : string;
  begin
    Infos.Clear();
    while Pos(';', Ligne) > 0 do
    begin
      Value := Copy(Ligne, 1, Pos(';', Ligne) -1);
      if Length(Value) > 0 then
      begin
        if Value[1] = '"' then
          Delete(Value, 1, 1);
        if Value[Length(Value)] = '"' then
          Delete(Value, Length(Value), 1);
      end;
      Infos.Add(Value);
      Delete(Ligne, 1, Pos(';', Ligne));
    end;
    if Ligne <> '' then
      Infos.Add(Ligne);
    while Infos.Count < nbChamps do
      Infos.Add('');
  end;

const
  // fichier article
  ART_ID = 0;
  ART_CODE = 1;
  ART_NOM = 2;
  COULEUR_OLD_ID = 7;
  COULEUR_CODE = 8;
  COULEUR_NOM = 10;
  TODO = 11;
  COULEUR_NEW_ID = 12;
  // fichier CB
  CB_CODE_ART = 0;
  CB_CODE_TAI = 1;
  CB_CODE_COU = 2;
  CB_EAN = 3;
  CB_TYPE = 4;
  // fichier Taille
  TAILLE_GRILLE_ID = 0;
  TAILLE_NOM = 1;
  TAILLE_CODE = 2;
  TAILLE_ID = 3;
var
  LstArticle : TStringList;
  LstCodeBarre : TStringList;
  LstTailles : TStringList;
  LstChamps : TStringList;
  i : integer;
  // Dictionnaire des CB :       code art                  code cou                  code tai
  tmpListeCB : TObjectDictionary<string, TObjectDictionary<string, TObjectDictionary<string, TListCodesBarres>>>;
  // Dictionnaire des taille
  tmpListeTailles : TDictionary<string, string>;
  tmpInfoCouleur : TInfosCouleur;
  tmpCodeTai : string;
begin
  Result := TListArticles.Create([doOwnsValues]);

  try
    LstArticle := TStringList.Create();
    LstArticle.LoadFromFile(FileArticle);
    LstCodeBarre := TStringList.Create();
    LstCodeBarre.LoadFromFile(FileCodeBarre);
    LstTailles := TStringList.Create();
    LstTailles.LoadFromFile(FileTaille);
    LstChamps := TStringList.Create();

    tmpListeCB := TObjectDictionary<string, TObjectDictionary<string, TObjectDictionary<string, TListCodesBarres>>>.Create([doOwnsValues]);
    tmpListeTailles := TDictionary<string, string>.Create();

    // init progress bar !
    lbl_Etape.Caption := 'Etape 1 / 3';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := LstArticle.Count + LstCodeBarre.Count + LstTailles.Count;

    // lectures des tailles
    for i := 1 to LstTailles.Count -1 do
    begin
      GetLigneInfos(LstTailles[i], LstChamps, 4);
      if not tmpListeTailles.ContainsKey(LstChamps[TAILLE_CODE]) then
        tmpListeTailles.Add(LstChamps[TAILLE_CODE], LstChamps[TAILLE_NOM]);
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;

    // lecture des code barre
    for i := 1 to LstCodeBarre.Count -1 do
    begin
      GetLigneInfos(LstCodeBarre[i], LstChamps, 5);
      if tmpListeTailles.ContainsKey(LstChamps[CB_CODE_TAI]) then
        tmpCodeTai := tmpListeTailles[LstChamps[CB_CODE_TAI]]
      else
        Raise Exception.Create('Taille inexistante !!');

      if not tmpListeCB.ContainsKey(LstChamps[CB_CODE_ART]) then
        tmpListeCB.Add(LstChamps[CB_CODE_ART], TObjectDictionary<string, TObjectDictionary<string, TListCodesBarres>>.Create([doOwnsValues]));
      if not tmpListeCB[LstChamps[CB_CODE_ART]].ContainsKey(LstChamps[CB_CODE_COU]) then
        tmpListeCB[LstChamps[CB_CODE_ART]].Add(LstChamps[CB_CODE_COU], TObjectDictionary<string, TListCodesBarres>.Create());

      if not tmpListeCB[LstChamps[CB_CODE_ART]][LstChamps[CB_CODE_COU]].ContainsKey(tmpCodeTai) then
        tmpListeCB[LstChamps[CB_CODE_ART]][LstChamps[CB_CODE_COU]].Add(tmpCodeTai, TListCodesBarres.Create());
      tmpListeCB[LstChamps[CB_CODE_ART]][LstChamps[CB_CODE_COU]][tmpCodeTai].Add(TInfosCodeBarre.Create(StrToIntDef(LstChamps[CB_TYPE], 0), LstChamps[CB_EAN]));
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;

    // lecture des articles
    for i := 1 to LstArticle.Count -1 do
    begin
      GetLigneInfos(LstArticle[i], LstChamps, 13);
      if LstChamps[TODO] <> '0' then
      begin
        if not Result.ContainsKey(StrToInt(LstChamps[ART_ID])) then
          Result.Add(StrToInt(LstChamps[ART_ID]), TArticleInfos.Create(LstChamps[ART_CODE], LstChamps[ART_NOM]));
        tmpInfoCouleur := TInfosCouleur.Create(StrToIntDef(LstChamps[COULEUR_NEW_ID], 0), LstChamps[COULEUR_CODE], LstChamps[COULEUR_NOM]);
        if tmpListeCB.ContainsKey(LstChamps[ART_CODE]) and tmpListeCB[LstChamps[ART_CODE]].ContainsKey(LstChamps[COULEUR_CODE]) then
          for tmpCodeTai in tmpListeCB[LstChamps[ART_CODE]][LstChamps[COULEUR_CODE]].Keys do
            tmpInfoCouleur.ListeCodeBarre.Add(tmpCodeTai, tmpListeCB[LstChamps[ART_CODE]][LstChamps[COULEUR_CODE]][tmpCodeTai]);
        Result[StrToInt(LstChamps[ART_ID])].ListeCouleur.Add(StrToInt(LstChamps[COULEUR_OLD_ID]), tmpInfoCouleur);
      end;
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;
  finally
    FreeAndNil(LstArticle);
    FreeAndNil(LstCodeBarre);
    FreeAndNil(LstTailles);
    FreeAndNil(LstChamps);

    FreeAndNil(tmpListeCB);
    FreeAndNil(tmpListeTailles);
  end;
end;

function Tfrm_Main.CreateCouleurEtCodeBarre(FileBDD : string; ListeArticle : TListArticles) : TResTraitement;

  function GetNewCodeCouleur(Query : TFDQuery; IdArt : integer; OldCode : string) : string;
  begin
    Result := OldCode;
    try
      Query.SQL.Text := 'select cou_code from plxcouleur join k on k_id = cou_id and k_enabled = 1 where cou_artid = ' + IntToStr(IdArt) + ';';
      Query.Open();
      while Query.Locate('cou_code', Result, []) do
      begin
        if Result[1] in ['0'..'8'] then
          Result[1] := Char(Ord(Result[1]) + 1)
        else if Result[1] = '9' then
          Result[1] := 'A'
        else if Result[1] in ['A'..'Y'] then
          Result[1] := Char(Ord(Result[1]) + 1)
        else
          Raise Exception.Create('Merde le code couleur !');
      end;
    finally
      Query.Close();
    end;
  end;

  function CreateNewCouleur(Query : TFDQuery; IdArt : integer; CodeCouleur, NomCouleur : string) : Integer;
  begin
    Result := 0;
    // identifiant
    try
      Query.SQL.Text := 'select id from pr_newk(''PLXCOULEUR'')';
      Query.Open();
      if Query.Eof or (Query.FieldByName('id').AsInteger = 0) then
        Raise Exception.Create('pr_newk failed !!')
      else
        Result := Query.FieldByName('id').AsInteger;
    finally
      Query.Close();
    end;
    // valeur
    Query.SQL.Text := 'insert into plxcouleur (COU_ID, COU_ARTID, COU_IDREF, COU_GCSID, COU_CODE, COU_NOM, COU_SMU, COU_TDSC, COU_CENTRALE) '
                    + 'values (' + IntToStr(Result) + ', ' + IntToStr(IdArt) + ', 0, 0, ' + QuotedStr(CodeCouleur) + ', ' + QuotedStr(NomCouleur) +', 0, 0, 0);';
    Query.ExecSQL();
  end;

  function CreateNewCodeBarreGinkoia(Query : TFDQuery; IdArt, IdCou : integer) : integer;
  var
    QueryLst, QueryCB : TFDQuery;
    NewCB : string;
    NewId, ArfId, TgfId : integer;
  begin
    Result := 0;
    try
      QueryCB := TFDQuery.Create(Self);
      QueryCB.Connection := Query.Connection;
      QueryCB.Transaction := Query.Transaction;
      QueryCB.SQL.Text := 'select cbi_cb from artcodebarre join k on k_id = cbi_cb and k_enabled = 1 where cbi_arfid = :arfid and cbi_tgfid = :tgfid and cbi_couid = :couid and cbi_type = 1;';
      QueryCB.Prepare();

      QueryLst := TFDQuery.Create(Self);
      QueryLst.Connection := Query.Connection;
      QueryLst.Transaction := Query.Transaction;
      QueryLst.SQL.Text := 'select arf_id, ttv_tgfid as tgf_id '
                         + 'from plxtaillestrav join k on k_id = ttv_id and k_enabled = 1 '
                         + 'join artreference on arf_artid = ttv_artid '
                         + 'where ttv_artid = ' + IntToStr(IdArt) + ';';
      QueryLst.Open();
      while not QueryLst.Eof do
      begin
        ArfId := QueryLst.FieldByName('arf_id').AsInteger;
        TgfId := QueryLst.FieldByName('tgf_id').AsInteger;

        QueryCB.ParamByName('arfid').AsInteger := ArfId;
        QueryCB.ParamByName('tgfid').AsInteger := TgfId;
        QueryCB.ParamByName('couid').AsInteger := IdCou;
        try
          QueryCB.Open();

          // pour chaque taille qui n'as pas de code barre ...
          if QueryCB.Eof then
          begin
            NewId := 0;

            // identifiant
            Query.SQL.Text := 'select id from pr_newk(''ARTCODEBARRE'');';
            try
              Query.Open();
              if Query.Eof then
                Raise Exception.Create('pr_newk failed !!')
              else
                NewId := Query.FieldByName('id').AsInteger;
            finally
              Query.Close();
            end;

            // CodeBarre
            Query.SQL.Text := 'select newnum from ART_CB;';
            try
              Query.Open();
              if Query.Eof then
                Raise Exception.Create('pr_newk failed !!')
              else
                NewCB := Query.FieldByName('newnum').AsString;
            finally
              Query.Close();
            end;

            // insertion
            Query.SQL.Text := 'insert into artcodebarre (CBI_ID, CBI_ARFID, CBI_TGFID, CBI_COUID, CBI_CB, CBI_TYPE, CBI_CLTID, CBI_ARLID, CBI_LOC, CBI_MATID) '
                            + 'values (' + IntToStr(NewId) + ', ' + IntToStr(ArfId) + ', ' + IntToStr(TgfId) + ', ' + IntToStr(IdCou) + ', ' + QuotedStr(NewCB) + ', 1, 0, 0, 0, 0);';
            Query.ExecSQL();
            Inc(Result);
          end;
        finally
          QueryCB.Close();
        end;
        QueryLst.Next();
      end;
    finally
      QueryLst.Close();
      FreeAndNil(QueryLst);
      FreeAndNil(QueryCB);
    end;
  end;

  function CreateNewCodeBarreFournisseur(Query : TFDQuery; IdArt, IdOldCou, IdNewCou : integer; NomTaille : string; InfosCB : TListCodesBarres) : TResCodeBareFourn;
  var
    QueryLst : TFDQuery;
    NewId, ArfId, TgfId, i : integer;
    Prems : boolean;
  begin
    Result.nbMovedCB := 0;
    Result.nbExistsCB := 0;
    Result.nbNewCB := 0;
    Result.nbDelCB := 0;
    try
      QueryLst := TFDQuery.Create(Self);
      QueryLst.Connection := Query.Connection;
      QueryLst.Transaction := Query.Transaction;

      // recherche des codes barres
      for i := 0 to InfosCB.Count -1 do
      begin
        try
          QueryLst.SQL.Text := 'select cbi_id, cbi_couid '
                             + 'from artreference '
                             + 'join artcodebarre join k on k_id = cbi_id and k_enabled = 1 on cbi_arfid = arf_id '
                             + 'where arf_artid = ' + IntToStr(IdArt) + ' and cbi_couid in (' + IntToStr(IdOldCou) + ', ' + IntToStr(IdNewCou) + ') '
                             + '  and cbi_type = 3 and cbi_cb = ' + QuotedStr(InfosCB[i].EAN) + ';';
          QueryLst.Open();
          if Querylst.Eof then
          begin
            QueryLst.Close();
            // Le code barre n'est ni sur l'ancienne couleur, ni sur la nouvelle
            // le créer
            QueryLst.SQL.Text := 'select arf_id, tgf_id, '
                               + '(select ttv_id '
                               + ' from plxtaillestrav join k on k_id = ttv_id and k_enabled = 1 '
                               + ' where ttv_artid = artarticle.art_id and ttv_tgfid = plxtaillesgf.tgf_id) as travailler '
                               + 'from artarticle join artreference on arf_artid = art_id '
                               + 'join plxtaillesgf join k on k_id = tgf_id and k_enabled = 1 on tgf_gtfid = art_gtfid '
                               + 'where art_id = ' + IntToStr(IdArt) + ' and tgf_nom = ' + QuotedStr(NomTaille) + ';';
            QueryLst.Open();
            if QueryLst.Eof then
            begin
              mmo_Resultat.Lines.Add('  ATTENTION : taille (nom = "' + NomTaille + '") non trouvé pour l''article (id = "' + IntToStr(IdArt) + '")...');
            end
            else
            begin
              while not QueryLst.Eof do
              begin
                if QueryLst.FieldByName('travailler').IsNull then
                  mmo_Resultat.Lines.Add('  ATTENTION : taille (nom = "' + NomTaille + '") non travaillé pour l''article (id = "' + IntToStr(IdArt) + '")...');

                NewId := 0;

                ArfId := QueryLst.FieldByName('arf_id').AsInteger;
                TgfId := QueryLst.FieldByName('tgf_id').AsInteger;

                // identifiant
                Query.SQL.Text := 'select id from pr_newk(''ARTCODEBARRE'');';
                try
                  Query.Open();
                  if Query.Eof then
                    Raise Exception.Create('pr_newk failed !!')
                  else
                    NewId := Query.FieldByName('id').AsInteger;
                finally
                  Query.Close();
                end;

                // insertion
                Query.SQL.Text := 'insert into artcodebarre (CBI_ID, CBI_ARFID, CBI_TGFID, CBI_COUID, CBI_CB, CBI_TYPE, CBI_CLTID, CBI_ARLID, CBI_LOC, CBI_MATID) '
                                + 'values (' + IntToStr(NewId) + ', ' + IntToStr(ArfId) + ', ' + IntToStr(TgfId) + ', ' + IntToStr(IdNewCou) + ', ' + QuotedStr(InfosCB[i].EAN) + ', 3, 0, 0, 0, 0);';
                Query.ExecSQL();
                Inc(Result.nbNewCB);

                // suivant ...
                QueryLst.Next();
              end;
            end;
          end
          else
          begin
            Prems := true;
            while not Querylst.Eof do
            begin
              if prems and (QueryLst.FieldByName('cbi_couid').AsInteger = IdOldCou) then
              begin
                // Le code barre est sur l'ancienne couleur !
                // le positionné sur la nouvelle !
                Query.SQL.Text := 'update artcodebarre set cbi_couid = ' + IntToStr(IdNewCou) + ' where cbi_id = ' + QueryLst.FieldByName('cbi_id').AsString + ';';
                Query.ExecSQL();
                Query.SQL.Text := 'execute procedure pr_updatek(' + QueryLst.FieldByName('cbi_id').AsString + ', 0);';
                Query.ExecSQL();
                Inc(Result.nbMovedCB);
              end
              else if Prems then
                Inc(Result.nbExistsCB)
              else
              begin
                // Le code barre est sur l'ancienne couleur et la nouvelle
                // le supprimer de l'ancienne
                Query.SQL.Text := 'execute procedure pr_updatek(' + QueryLst.FieldByName('cbi_id').AsString + ', 1);';
                Query.ExecSQL();
                Inc(Result.nbDelCB);
              end;

              Prems := false;
              Querylst.Next();
            end;
          end;
        finally
          QueryLst.Close();
        end;
      end;
    finally
      FreeAndNil(QueryLst);
    end;
  end;

var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  StringMagasins : string;
  IdArt, IdOldCou, IdNewCou : integer;
  NomTaille : string;
  InfosCB : TListCodesBarres;
  ResCbFourn : TResCodeBareFourn;
begin
  Result.nbArticles := 0;
  Result.nbNewCouleurs := 0;
  Result.nbMovedCB := 0;
  Result.nbNewCB := 0;
  Result.nbDelCB := 0;

  if FileExists(FileBDD) then
  begin
    try
      Connexion := TFDConnection.Create(Self);
      Connexion.DriverName := 'IB';
      Connexion.Params.Clear();
      Connexion.Params.Add('Database=' + FileBDD);
      Connexion.Params.Add('User_Name=ginkoia');
      Connexion.Params.Add('Password=ginkoia');
      Connexion.Params.Add('Protocol=TCPIP');
      Connexion.Params.Add('DriverID=IB');
      Connexion.Open();

      Transaction := TFDTransaction.Create(Self);
      Transaction.Connection := Connexion;
      Transaction.StartTransaction();
      try
        Query := TFDQuery.Create(Self);
        Query.Connection := Connexion;
        Query.Transaction := Transaction;

        // init progress bar !
        lbl_Etape.Caption := 'Etape 2 / 3';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := ListeArticle.Count;

        for IdArt in ListeArticle.Keys do
        begin
          for IdOldCou in ListeArticle[IdArt].ListeCouleur.Keys do
          begin
            // creation de la couleur et des code barre type 1
            IdNewCou := ListeArticle[IdArt].ListeCouleur[IdOldCou].newID;
            if IdNewCou = 0 then
            begin
              IdNewCou := CreateNewCouleur(Query, IdArt, GetNewCodeCouleur(Query, IdArt, ListeArticle[IdArt].ListeCouleur[IdOldCou].Code), ListeArticle[IdArt].ListeCouleur[IdOldCou].Nom);
              ListeArticle[IdArt].ListeCouleur[IdOldCou].newID := IdNewCou;
              Result.nbNewGin := Result.nbNewGin + CreateNewCodeBarreGinkoia(Query, IdArt, IdNewCou);
              Inc(Result.nbNewCouleurs);
            end;
            // Creation/modification des CB type 3
            for NomTaille in ListeArticle[IdArt].ListeCouleur[IdOldCou].ListeCodeBarre.Keys do
            begin
              InfosCB := ListeArticle[IdArt].ListeCouleur[IdOldCou].ListeCodeBarre[NomTaille];
              // les type3 sont dans le fichier
              // verifier si le code barre existe sur l'ancienne couleur (IdOldCou)
              //  - si oui : la deplacer sur la nouvelle couleur (IdNewCou)
              //             ou les supprimés s'ils existent deja
              //  - si non : creer la nouvelle couleur
              ResCbFourn := CreateNewCodeBarreFournisseur(Query, IdArt, IdOldCou, IdNewCou, NomTaille, InfosCB);
              Inc(Result.nbMovedCB, ResCbFourn.nbMovedCB);
              Inc(Result.nbExistsCB, ResCbFourn.nbExistsCB);
              Inc(Result.nbNewCB, ResCbFourn.nbNewCB);
              Inc(Result.nbDelCB, ResCbFourn.nbDelCB);
            end;
          end;
          Inc(Result.nbArticles);
          pb_Progress.StepIt();
          Application.ProcessMessages();
        end;
        Transaction.Commit();
      except
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      Connexion.Close();
      FreeAndNil(Connexion);
    end;
  end;
end;

function Tfrm_Main.SaveNewFile(ListeArticle : TListArticles) : boolean;
var
  Sep, Quot : char;
  Fichier : TextFile;
  Ligne : string;
  IdArt, IdOldCou, IdNewCou : integer;
begin
  result := false;
  Sep := ';';
  Quot := '"';

  // renomage de l'ancien fichier
  if RenameFile(edt_Articles.Text, ChangeFileExt(edt_Articles.Text, '.old' + ExtractFileExt(edt_Articles.Text))) then
  begin
    // init progress bar !
    lbl_Etape.Caption := 'Etape 3 / 3';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := ListeArticle.Count;

    try
      AssignFile(Fichier, ChangeFileExt(edt_Articles.Text, '.new' + ExtractFileExt(edt_Articles.Text)));
      Rewrite(Fichier);
      Ligne := '"art_id";"old_cou_id";"new_cou_id";';
      Writeln(Fichier, Ligne);

      for IdArt in ListeArticle.Keys do
      begin
        for IdOldCou in ListeArticle[IdArt].ListeCouleur.Keys do
        begin
          IdNewCou := ListeArticle[IdArt].ListeCouleur[IdOldCou].newID;
          if IdNewCou = 0 then
            Raise Exception.Create('Couleur non créé !!');
          Ligne := Quot + IntToStr(IdArt) + Quot + Sep + Quot + IntToStr(IdOldCou) + Quot + Sep + Quot + IntToStr(IdNewCou) + Quot + Sep;
          Writeln(Fichier, Ligne);
        end;
        pb_Progress.StepIt();
        Application.ProcessMessages();
      end;
      Result := true;
    finally
      CloseFile(Fichier);
    end;
  end;
end;

// fonctions utilitaires

procedure Tfrm_Main.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count : integer;
  Fichier : array [0..MAXFILENAME] of char;
  FileName, FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, Fichier, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, Fichier, MAXFILENAME);

      FileExt := UpperCase(ExtractFileExt(Fichier));
      FileName := UpperCase(ExtractFileName(Fichier));
      if FileExt = '.IB' then
        edt_Base.Text := Fichier
      else if FileExt = '.CSV' then
      begin
        if FileName = 'LISTEDOUBLONSCOULEURS.CSV' then
          edt_Articles.Text := Fichier
        else if FileName = 'CODE_BARRE.CSV' then
          edt_CodeBarre.Text := Fichier
        else if FileName = 'GR_TAILLE_LIG.CSV' then
          edt_Tailles.Text := Fichier
        else if edt_Articles.Text = '' then
          edt_Articles.Text := Fichier
        else if edt_CodeBarre.Text = '' then
          edt_CodeBarre.Text := Fichier
        else if edt_Tailles.Text = '' then
          edt_Tailles.Text := Fichier;
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;
  Application.ProcessMessages();

  try
    // blocage temporaire
    Self.Enabled := False;

    lbl_Base.Enabled := Enabled;
    edt_base.Enabled := Enabled;
    btn_base.Enabled := Enabled;

    lbl_Articles.Enabled := Enabled;
    edt_Articles.Enabled := Enabled;
    btn_Articles.Enabled := Enabled;

    lbl_CodeBarre.Enabled := Enabled;
    edt_CodeBarre.Enabled := Enabled;
    btn_CodeBarre.Enabled := Enabled;

    lbl_Tailles.Enabled := Enabled;
    edt_Tailles.Enabled := Enabled;
    btn_Tailles.Enabled := Enabled;

    btn_SaveLog.Enabled := Enabled;

    btn_Traitement.Enabled := Enabled and
                              ((Trim(edt_Articles.Text) <> '') and FileExists(edt_Articles.Text)) and
                              ((Trim(edt_CodeBarre.Text) <> '') and FileExists(edt_CodeBarre.Text)) and
                              ((Trim(edt_Tailles.Text) <> '') and FileExists(edt_Tailles.Text)) and
                              ((Trim(edt_Base.Text) <> '') and FileExists(edt_Base.Text) and CanConnect(edt_Base.Text));
    btn_Close.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

function Tfrm_Main.CanConnect(DataBaseFile : string) : boolean;
var
  Connexion : TFDConnection;
begin
  Result := false;

  if FileExists(DataBaseFile) then
  begin
    try
      try
        Connexion := TFDConnection.Create(Self);
        Connexion.DriverName := 'IB';
        Connexion.Params.Clear();
        Connexion.Params.Add('Database=' + DataBaseFile);
        Connexion.Params.Add('User_Name=ginkoia');
        Connexion.Params.Add('Password=ginkoia');
        Connexion.Params.Add('Protocol=TCPIP');
        Connexion.Params.Add('DriverID=IB');
        Connexion.Open();
        if Connexion.Connected then
          Result := true;
      finally
        Connexion.Close();
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.

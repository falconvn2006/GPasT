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
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Generics.Collections;

type
  TInfosCouleur = class(TObject)
  private
    FOldNom, FNewNom : string;
  public
    constructor Create(OldNom, NewNom : string); reintroduce;
    property OldNom : string read FOldNom write FOldNom;
    property NewNom : string read FNewNom write FNewNom;
  end;
  TListCouleurs = TObjectDictionary<string, TInfosCouleur>;
  TListArticles = TObjectDictionary<string, TListCouleurs>;
  TUpdatedCouleurs = TList<TPair<integer, integer>>;

type
  TInfosLigne = class(TObject)
  private
    FQte : integer;
    Article : record
      FId : integer;
      FChrono, FRefMrk : string;
    end;
    Couleur : record
      FId : integer;
      FCode, FOldNom, FNewNom : string;
    end;
    Taille : record
      FId : integer;
      FCode, FNom : string;
    end;
  public
    constructor Create(ArtId, CouId, TgfId : integer; ArtChrono, ArtRefMrk, CouCode, CouOldNom, CouNewNom, TgfCode, TgfNom : string; Qte : Integer); reintroduce;
    property Qte : integer read FQte write FQte;
    Property ArtId : integer read Article.FId write Article.FId;
    Property ArtChrono : string read Article.FChrono write Article.FChrono;
    Property ArtRefMrk : string read Article.FRefMrk write Article.FRefMrk;
    Property CouId : integer read Couleur.FId write Couleur.FId;
    Property CouCode : string read Couleur.FCode write Couleur.FCode;
    Property CouOldNom : string read Couleur.FOldNom write Couleur.FOldNom;
    Property CouNewNom : string read Couleur.FNewNom write Couleur.FNewNom;
    Property TgfId : integer read Taille.FId write Taille.FId;
    Property TgfCode : string read Taille.FCode write Taille.FCode;
    Property TgfNom : string read Taille.FNom write Taille.FNom;
  end;
  TListLignes = TObjectDictionary<integer, TInfosLigne>;
  TInfosCommande = class(TObject)
  private
    FNumero : string;
    Fournisseur : record
      FId : integer;
      FCode, FNom : string;
    end;
    FLslLignes : TListLignes;
  public
    constructor Create(Numero : string; FournId : integer; FournCode, FournNom : string); reintroduce;
    destructor Destroy(); override;
    property Numero : string read FNumero write FNumero;
    Property FournId : integer read Fournisseur.FId write Fournisseur.FId;
    Property FournCode : string read Fournisseur.FCode write Fournisseur.FCode;
    Property FournNom : string read Fournisseur.FNom write Fournisseur.FNom;
    property LslLignes : TListLignes read FLslLignes;
  end;
  TListCommandes = TObjectDictionary<integer, TInfosCommande>;

type
  Tfrm_Main = class(TForm)
    lbl_Base: TLabel;
    edt_Base: TEdit;
    btn_Base: TSpeedButton;
    lbl_Articles: TLabel;
    edt_Articles: TEdit;
    btn_Articles: TSpeedButton;
    lbl_Magasins: TLabel;
    lst_Magasins: TListBox;
    Panel3: TPanel;
    mmo_Resultat: TMemo;
    lbl_Etape: TLabel;
    pb_Progress: TProgressBar;
    btn_SaveLog: TSpeedButton;
    Panel2: TPanel;
    btn_Traitement: TButton;
    btn_Close: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_BaseChange(Sender: TObject);
    procedure btn_BaseClick(Sender: TObject);
    procedure edt_ArticlesChange(Sender: TObject);
    procedure btn_ArticlesClick(Sender: TObject);
    procedure lst_MagasinsClick(Sender: TObject);
    procedure btn_SaveLogClick(Sender: TObject);
    procedure btn_TraitementClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Déclarations privées }

    // traitement du programme !
    function Traitement(out error : string) : boolean;
    function GetMagasinID() : integer;
    function ReadFile(FileArticle : string) : TListArticles;
    function UpdateCouleurs(FileBDD : string; LstArticles : TListArticles) : TUpdatedCouleurs;
    function UpdateCommandes(FileBDD : string; MagasinID : integer; LstArticles : TListArticles; LstCouleurs : TUpdatedCouleurs) : TListCommandes;
    function RecalcCommandes(FileBDD : string; LstCommandes : TListCommandes) : boolean;
    function SaveNewFile(LstCommandes : TListCommandes) : boolean;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
    // activation
    procedure GestionInterface(Enabled : Boolean);
    // acces BDD, et remplisage magasin
    function GestionMagasin(DataBaseFile : string) : boolean;
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

{ TInfosCouleur }

constructor TInfosCouleur.Create(OldNom, NewNom : string);
begin
  Inherited Create();
  FOldNom := OldNom;
  FNewNom := NewNom;
end;

{ TInfosLigne }

constructor TInfosLigne.Create(ArtId, CouId, TgfId : integer; ArtChrono, ArtRefMrk, CouCode, CouOldNom, CouNewNom, TgfCode, TgfNom : string; Qte : Integer);
begin
  Inherited Create();
  Article.FId := ArtId;
  Article.FChrono := ArtChrono;
  Article.FRefMrk := ArtRefMrk;
  Couleur.FId := CouId;
  Couleur.FCode := CouCode;
  Couleur.FOldNom := CouOldNom;
  Couleur.FNewNom := CouNewNom;
  Taille.FId := TgfId;
  Taille.FCode := TgfCode;
  Taille.FNom := TgfNom;
  FQte := Qte;
end;

{ TInfosCommande }

constructor TInfosCommande.Create(Numero : string; FournId : integer; FournCode, FournNom : string);
begin
  Inherited Create();
  FNumero := Numero;
  Fournisseur.FId := FournId;
  Fournisseur.FCode := FournCode;
  Fournisseur.FNom := FournNom;
  FLslLignes := TListLignes.Create([doOwnsValues]);
end;

destructor TInfosCommande.Destroy();
begin
  FreeAndNil(FLslLignes);
  Inherited Destroy();
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
  // arf
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btn_Close.Enabled;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  // arf
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

procedure Tfrm_Main.lst_MagasinsClick(Sender: TObject);
begin
  // arf !
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

  function GetNbCouleurs(LstArticles : TListArticles) : integer;
  var
    ChronoArt : string;
  begin
    Result := 0;
    for ChronoArt in LstArticles.Keys do
      Result := Result + LstArticles[ChronoArt].Count;
  end;

  function GetNbLignes(LstCommandes : TListCommandes) : integer;
  var
    CommandeID : integer;
  begin
    Result := 0;
    for CommandeID in LstCommandes.Keys do
      Result := Result + LstCommandes[CommandeID].LslLignes.Count;
  end;

var
  IdMagasin : integer;
  LstArticles : TListArticles;
  LstCouleurs : TUpdatedCouleurs;
  LstCommandes : TListCommandes;
begin
  result := false;
  error := '';
  mmo_Resultat.Lines.Clear();

  try
    try
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Debut du traitement.');
      IdMagasin := GetMagasinID();
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de reup de l''ID du magasin.');
      LstArticles := ReadFile(edt_Articles.Text);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de lecture des articles (' + IntToStr(LstArticles.Count) + ' articles, ' + IntToStr(GetNbCouleurs(LstArticles)) + ' couleurs).');
      LstCouleurs := UpdateCouleurs(edt_Base.Text, LstArticles);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de mise a jours des couleurs (' + IntToStr(LstCouleurs.Count) + ' couleurs).');
      LstCommandes := UpdateCommandes(edt_Base.Text, IdMagasin, LstArticles, LstCouleurs);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de suppression des lignes de commandes (' + IntToStr(LstCommandes.Count) + ' commandes, ' + IntToStr(GetNbLignes(LstCommandes)) + ' lignes).');
      if RecalcCommandes(edt_Base.Text, LstCommandes) then
      begin
        mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de recalcul des commandes.');
        if SaveNewFile(LstCommandes) then
        begin
          mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin du traitement.');
          Result := true;
        end
        else
          mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Erreur lors de l''enregistrement du fichier.');
      end
      else
        mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Erreur lors du recalcul des commandes.');
    finally
      FreeAndNil(LstArticles);
      FreeAndNil(LstCouleurs);
      FreeAndNil(LstCommandes);
    end;
  except
    on e : Exception do
    begin
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + error);
    end;
  end;
end;

function Tfrm_Main.GetMagasinID() : integer;
begin
  // init progress bar !
  lbl_Etape.Caption := 'Etape 1 / 6';
  Application.ProcessMessages();
  pb_Progress.Position := 0;
  pb_Progress.Step := 1;
  pb_Progress.Max := 1;

  if lst_Magasins.ItemIndex < 0 then
    Raise Exception.Create('Pas de magasin selectionné...')
  else
    Result := Integer(Pointer(lst_Magasins.Items.Objects[lst_Magasins.ItemIndex]));

  pb_Progress.StepIt();
  Application.ProcessMessages();
end;

function Tfrm_Main.ReadFile(FileArticle : string) : TListArticles;

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
  ART_CHRONO = 0;
  COULEUR_CODE = 4;
  COULEUR_OLD_NOM = 5;
  COULEUR_NEW_NOM = 6;
  TODO = 7;
var
  LstArticle : TStringList;
  LstChamps : TStringList;
  i : integer;
begin
  Result := TListArticles.Create([doOwnsValues]);

  try
    LstArticle := TStringList.Create();
    LstArticle.LoadFromFile(FileArticle);
    LstChamps := TStringList.Create();

    // init progress bar !
    lbl_Etape.Caption := 'Etape 2 / 6';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := LstArticle.Count;

    // lecture des articles
    for i := 1 to LstArticle.Count -1 do
    begin
      GetLigneInfos(LstArticle[i], LstChamps, 8);
      if LstChamps[TODO] = '1' then
      begin
        if not Result.ContainsKey(LstChamps[ART_CHRONO]) then
          Result.Add(LstChamps[ART_CHRONO], TListCouleurs.Create([doOwnsValues]));
        Result[LstChamps[ART_CHRONO]].Add(LstChamps[COULEUR_CODE], TInfosCouleur.Create(LstChamps[COULEUR_OLD_NOM], LstChamps[COULEUR_NEW_NOM]));
      end;
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;
  finally
    FreeAndNil(LstArticle);
    FreeAndNil(LstChamps);
  end;
end;

function Tfrm_Main.UpdateCouleurs(FileBDD : string; LstArticles : TListArticles) : TUpdatedCouleurs;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  ArtCode, CouCode : string;
  ArtId, CouId : integer;
begin
  Result := TUpdatedCouleurs.Create();

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
        lbl_Etape.Caption := 'Etape 3 / 6';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := LstArticles.Count;

        for ArtCode in LstArticles.Keys do
        begin
          for CouCode in LstArticles[ArtCode].Keys do
          begin
            // init !
            ArtId := 0;
            CouId := 0;

            // recup des ids pour la suite !
            try
              Query.SQL.Text := 'select arf_artid, cou_id '
                              + 'from artreference join k on k_id = arf_id and k_enabled = 1 '
                              + 'join plxcouleur join k on k_id = cou_id and k_enabled = 1 on cou_artid = arf_artid '
                              + 'where arf_chrono = ' + QuotedStr(ArtCode) + ' and cou_code = ' + QuotedStr(CouCode) + ';';
              Query.Open();
              if query.RecordCount = 1 then
              begin
                ArtId := Query.FieldByName('arf_artid').AsInteger;
                CouId := Query.FieldByName('cou_id').AsInteger;
                Result.Add(TPair<integer, integer>.Create(ArtId, CouId));
              end;
            finally
              Query.Close();
            end;

            // update du libelle de la couleur !
            if (ArtId > 0) and (CouId > 0) then
            begin
              Query.SQL.Text := 'update plxcouleur '
                              + 'set cou_nom = ' + QuotedStr(LstArticles[ArtCode][CouCode].NewNom) + ' '
                              + 'where cou_id = ' + IntToStr(CouId) + ' and cou_artid = ' + IntToStr(ArtId) + ';';
              Query.ExecSQL();
              Query.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(CouId) + ', 0);';
              Query.ExecSQL();
            end;
          end;
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

function Tfrm_Main.UpdateCommandes(FileBDD : string; MagasinID : integer; LstArticles : TListArticles; LstCouleurs : TUpdatedCouleurs) : TListCommandes;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  QueryLst, QueryUpd : TFDQuery;
  i : integer;
begin
  Result := TListCommandes.Create();

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
        QueryLst := TFDQuery.Create(Self);
        QueryLst.Connection := Connexion;
        QueryLst.Transaction := Transaction;

        QueryUpd := TFDQuery.Create(Self);
        QueryUpd.Connection := Connexion;
        QueryUpd.Transaction := Transaction;

        // init progress bar !
        lbl_Etape.Caption := 'Etape 4 / 6';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := LstCouleurs.Count;

        // triatement des lignes
        for i := 0 to LstCouleurs.Count -1 do
        begin
          QueryLst.SQL.Text := 'select cde_id, cde_numero, fou_id, fou_code, fou_nom, cdl_id, cdl_qte, art_id, arf_chrono, art_refmrk, cou_id, cou_code, cou_nom, tgf_id, tgf_code, tgf_nom '
                             + 'from combcde '
                             + 'join combcdel join k on k_id = cdl_id and k_enabled = 1 on cdl_cdeid = cde_id '
                             + 'join artfourn on fou_id = cde_fouid '
                             + 'join artarticle on art_id = cdl_artid '
                             + 'join artreference on arf_artid = art_id '
                             + 'join plxcouleur on cou_id = cdl_couid '
                             + 'join plxtaillesgf on tgf_id = cdl_tgfid '
                             + 'where cde_magid = ' + IntToStr(MagasinID) + ' and cdl_artid = ' + IntToStr(LstCouleurs[i].Key) + ' and cdl_couid = ' + IntToStr(LstCouleurs[i].Value) + ';';
          QueryLst.Open();
          while not QueryLst.Eof do
          begin
            // ajout a la liste
            if not Result.ContainsKey(QueryLst.FieldByName('cde_id').AsInteger) then
              Result.Add(QueryLst.FieldByName('cde_id').AsInteger, TInfosCommande.Create(QueryLst.FieldByName('cde_numero').AsString,
                                                                                         QueryLst.FieldByName('fou_id').AsInteger,
                                                                                         QueryLst.FieldByName('fou_code').AsString,
                                                                                         QueryLst.FieldByName('fou_nom').AsString));
            Result[QueryLst.FieldByName('cde_id').AsInteger].LslLignes.Add(QueryLst.FieldByName('cdl_id').AsInteger, TInfosLigne.Create(QueryLst.FieldByName('art_id').AsInteger,
                                                                                                                                        QueryLst.FieldByName('cou_id').AsInteger,
                                                                                                                                        QueryLst.FieldByName('tgf_id').AsInteger,
                                                                                                                                        QueryLst.FieldByName('arf_chrono').AsString,
                                                                                                                                        QueryLst.FieldByName('art_refmrk').AsString,
                                                                                                                                        QueryLst.FieldByName('cou_code').AsString,
                                                                                                                                        LstArticles[QueryLst.FieldByName('arf_chrono').AsString][QueryLst.FieldByName('cou_code').AsString].OldNom,
                                                                                                                                        QueryLst.FieldByName('cou_nom').AsString,
                                                                                                                                        QueryLst.FieldByName('tgf_code').AsString,
                                                                                                                                        QueryLst.FieldByName('tgf_nom').AsString,
                                                                                                                                        QueryLst.FieldByName('cdl_qte').AsInteger));
            // suppression...
            QueryUpd.SQL.Text := 'execute procedure pr_updatek(' + QueryLst.FieldByName('cdl_id').AsString + ', 1);';
            QueryUpd.ExecSQL();
            // Gestion du RAL...
            QueryUpd.SQL.Text := 'delete from agrral where ral_cdlid = ' + QueryLst.FieldByName('cdl_id').AsString + ';';
            QueryUpd.ExecSQL();
            // suivante !
            QueryLst.Next();
          end;
          pb_Progress.StepIt();
          Application.ProcessMessages();
        end;

        Transaction.Commit();
      except
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(QueryLst);
      FreeAndNil(QueryUpd);
      FreeAndNil(Transaction);
      Connexion.Close();
      FreeAndNil(Connexion);
    end;
  end;
end;

function Tfrm_Main.RecalcCommandes(FileBDD : string; LstCommandes : TListCommandes) : boolean;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  CommandeID : integer;
begin
  Result := false;

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
        lbl_Etape.Caption := 'Etape 5 / 6';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := LstCommandes.Count;

        // Creation de la procedure de correction
        Query.SQL.Add('create procedure TMP_BCDE_RECALC_ENTETE (');
        Query.SQL.Add('    identete varchar(32))');
        Query.SQL.Add('AS');
        Query.SQL.Add('declare variable idxtva integer;');
        Query.SQL.Add('declare variable tauxtva numeric(18, 7);');
        Query.SQL.Add('declare variable mntht numeric(18, 7);');
        Query.SQL.Add('declare variable mnttva numeric(18, 7);');
        Query.SQL.Add('declare variable cderemise numeric(18, 7);');
        Query.SQL.Add('declare variable pantin integer;');
        Query.SQL.Add('begin');
        Query.SQL.Add('/***********************************************************************************/');
        Query.SQL.Add('/* date        | nom | commentaire                                                 */');
        Query.SQL.Add('/* 2014-09-11  | TF  | Recalcule un entête de commande par son Chrono              */');
        Query.SQL.Add('/***********************************************************************************/');
        Query.SQL.Add('');
        Query.SQL.Add('  select retour from bn_only_pantin into :pantin;');
        Query.SQL.Add('  if (pantin != 1) then');
        Query.SQL.Add('    exit;');
        Query.SQL.Add('');
        Query.SQL.Add('  /* reinitialisation */');
        Query.SQL.Add('  update COMBCDE set cde_tvaht1 = 0, cde_tvataux1 = 0, cde_tva1 = 0,');
        Query.SQL.Add('                     cde_tvaht2 = 0, cde_tvataux2 = 0, cde_tva2 = 0,');
        Query.SQL.Add('                     cde_tvaht3 = 0, cde_tvataux3 = 0, cde_tva3 = 0,');
        Query.SQL.Add('                     cde_tvaht4 = 0, cde_tvataux4 = 0, cde_tva4 = 0,');
        Query.SQL.Add('                     cde_tvaht5 = 0, cde_tvataux5 = 0, cde_tva5 = 0');
        Query.SQL.Add('  where cde_id = :identete;');
        Query.SQL.Add('');
        Query.SQL.Add('  /* recup de la remise */');
        Query.SQL.Add('  select cde_remise from combcde where cde_id = :identete into :cderemise;');
        Query.SQL.Add('');
        Query.SQL.Add('  /* recalcul */');
        Query.SQL.Add('  idxtva = 1;');
        Query.SQL.Add('  for select cdl_tva,');
        Query.SQL.Add('             cast(sum((cdl_qte * cdl_pxachat * (100 - :cderemise) / 100)) as numeric(18, 2)),');
        Query.SQL.Add('             cast(sum((cdl_qte * cdl_pxachat * (100 - :cderemise) / 100) * (cdl_tva / 100)) as numeric(18, 2))');
        Query.SQL.Add('      from combcdel join k on k_id = cdl_id and k_enabled = 1');
        Query.SQL.Add('      where cdl_cdeid = :identete');
        Query.SQL.Add('      group by cdl_tva');
        Query.SQL.Add('      into :tauxtva, :mntht, :mnttva do');
        Query.SQL.Add('  begin');
        Query.SQL.Add('    if (idxtva = 1) then');
        Query.SQL.Add('      update combcde set cde_tvaht1 = :mntht, cde_tva1 = :mnttva, cde_tvataux1 = :tauxtva where cde_id = :identete;');
        Query.SQL.Add('    else if (idxtva = 2) then');
        Query.SQL.Add('      update combcde set cde_tvaht2 = :mntht, cde_tva2 = :mnttva, cde_tvataux2 = :tauxtva where cde_id = :identete;');
        Query.SQL.Add('    else if (idxtva = 3) then');
        Query.SQL.Add('      update combcde set cde_tvaht3 = :mntht, cde_tva3 = :mnttva, cde_tvataux3 = :tauxtva where cde_id = :identete;');
        Query.SQL.Add('    else if (idxtva = 4) then');
        Query.SQL.Add('      update combcde set cde_tvaht4 = :mntht, cde_tva4 = :mnttva, cde_tvataux4 = :tauxtva where cde_id = :identete;');
        Query.SQL.Add('    else if (idxtva = 5) then');
        Query.SQL.Add('      update combcde set cde_tvaht5 = :mntht, cde_tva5 = :mnttva, cde_tvataux5 = :tauxtva where cde_id = :identete;');
        Query.SQL.Add('    else');
        Query.SQL.Add('      exception ALGOL_EXCEPTION;');
        Query.SQL.Add('    idxtva = idxtva +1;');
        Query.SQL.Add('  end');
        Query.SQL.Add('');
        Query.SQL.Add('  execute procedure pr_updatek(:identete, 0);');
        Query.SQL.Add('end;');
        Query.ExecSQL();

        // triatement des lignes
        for CommandeID in LstCommandes.Keys do
        begin
          Query.SQL.Text := 'execute procedure TMP_BCDE_RECALC_ENTETE(' + IntToStr(CommandeID) + ');';
          Query.ExecSQL();
        end;

        Query.SQL.Text := 'drop procedure TMP_BCDE_RECALC_ENTETE;';
        Query.ExecSQL();

        Transaction.Commit();
        Result := true;
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

function Tfrm_Main.SaveNewFile(LstCommandes : TListCommandes) : boolean;
var
  Sep, Quot : char;
  Fichier : TextFile;
  Ligne : string;
  CommandeID, LigneID : integer;
begin
  result := false;
  Sep := ';';
  Quot := '"';

  // init progress bar !
  lbl_Etape.Caption := 'Etape 6 / 6';
  Application.ProcessMessages();
  pb_Progress.Position := 0;
  pb_Progress.Step := 1;
  pb_Progress.Max := LstCommandes.Count;

  try
    AssignFile(Fichier, ExtractFilePath(edt_Articles.Text) + 'Rapport.csv');
    Rewrite(Fichier);
    Ligne := '"Commande";"Fournisseur";""   ;"Modele";""         ;"Couleur";""          ;"Taille";""   ;"Qte";';
    Writeln(Fichier, Ligne);
    Ligne := '"Numéro"  ;"Code"       ;"Nom";"Chrono";"Référence";"Code"   ;"Ancien nom";"Code"  ;"Nom";""   ;';
    Writeln(Fichier, Ligne);

    for CommandeID in LstCommandes.Keys do
    begin
      for LigneID in LstCommandes[CommandeID].LslLignes.Keys do
      begin
        Ligne := Quot + LstCommandes[CommandeID].Numero + Quot + Sep
               + Quot + LstCommandes[CommandeID].FournCode + Quot + Sep
               + Quot + LstCommandes[CommandeID].FournNom + Quot + Sep
               + Quot + LstCommandes[CommandeID].LslLignes[LigneID].ArtChrono + Quot + Sep
               + Quot + LstCommandes[CommandeID].LslLignes[LigneID].ArtRefMrk + Quot + Sep
               + Quot + LstCommandes[CommandeID].LslLignes[LigneID].CouCode + Quot + Sep
               + Quot + LstCommandes[CommandeID].LslLignes[LigneID].CouOldNom + Quot + Sep
//                 + Quot + LstCommandes[CommandeID].LslLignes[LigneID].CouNewNom + Quot + Sep
               + Quot + LstCommandes[CommandeID].LslLignes[LigneID].TgfCode + Quot + Sep
               + Quot + LstCommandes[CommandeID].LslLignes[LigneID].TgfNom + Quot + Sep
               + Quot + IntToStr(LstCommandes[CommandeID].LslLignes[LigneID].Qte) + Quot + Sep;
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
      if FileExt = '.CSV' then
        edt_Articles.Text := Fichier
      else if FileExt = '.IB' then
        edt_Base.Text := Fichier;
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
    edt_Base.Enabled := Enabled;
    btn_Base.Enabled := Enabled;

    lbl_Articles.Enabled := Enabled;
    edt_Articles.Enabled := Enabled;
    btn_Articles.Enabled := Enabled;

    lbl_Magasins.Enabled := Enabled;
    lst_Magasins.Enabled := Enabled;

    btn_SaveLog.Enabled := Enabled;

    btn_Traitement.Enabled := Enabled and
                              ((Trim(edt_Articles.Text) <> '') and FileExists(edt_Articles.Text)) and
                              ((Trim(edt_Base.Text) <> '') and FileExists(edt_Base.Text) and GestionMagasin(edt_Base.Text));
    btn_Close.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

function Tfrm_Main.GestionMagasin(DataBaseFile : string) : boolean;
var
  Connexion : TFDConnection;
  Query : TFDQuery;
begin
  Result := false;

  lst_Magasins.Items.Clear();

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

        Query := TFDQuery.Create(Self);
        Query.Connection := Connexion;
        Query.SQL.Text := 'select mag_id, mag_enseigne from genmagasin join k on k_id = mag_id and k_enabled = 1 where mag_id != 0;';
        try
          Query.Open();
          while not Query.Eof do
          begin
            lst_Magasins.AddItem(Query.FieldByName('mag_enseigne').AsString, Pointer(Query.FieldByName('mag_id').AsInteger));
            Query.Next();
          end;
        finally
          Query.Close();
        end;
      finally
        FreeAndNil(Query);
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

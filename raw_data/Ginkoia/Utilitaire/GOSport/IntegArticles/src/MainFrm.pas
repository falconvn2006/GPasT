unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TTabString = Array of Array of String;

  Tfrm_Main = class(TForm)
    Lab_Base: TLabel;
    edt_Base: TEdit;
    Nbt_Base: TSpeedButton;
    Lab_Fichier: TLabel;
    edt_Fichier: TEdit;
    Nbt_Fichier: TSpeedButton;
    chk_UseFournisseur: TCheckBox;
    Btn_Quitter: TButton;
    Btn_Traitement: TButton;
    tv_Nomenk: TTreeView;
    Lab_ssFamille: TLabel;
    Btn_TraitementBelgique: TButton;
    Lab_Etape: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure edt_BaseChange(Sender: TObject);
    procedure Nbt_BaseClick(Sender: TObject);
    procedure edt_FichierChange(Sender: TObject);
    procedure Nbt_FichierClick(Sender: TObject);

    procedure Btn_TraitementClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Btn_TraitementBelgiqueClick(Sender: TObject);
  private
    { Déclarations privées }
    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;

    // activation de l'interface
    procedure GestionInterface(Enabled : boolean);

    // Gestion de l'arbre de la nomenclature

  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  Math,
  ShellAPI,
  uGestionBDD,
  IB_Components,
  IBODataset;

type
  TssFamille = class
    act_id : integer;
    act_nom : string;
    uni_id : integer;
    uni_nom : string;
    sec_id : integer;
    sec_nom : string;
    ray_id : integer;
    ray_nom : string;
    fam_id : integer;
    fam_nom : string;
    ssf_id : integer;
    ssf_nom : string;
    ssf_code : string;

    Constructor Create(Query : TIBOQuery);
  end;

{$R *.dfm}

{ TssFamille }

Constructor TssFamille.Create(Query : TIBOQuery);
begin
  Inherited Create();
  act_id := Query.FieldByName('act_id').AsInteger;
  act_nom := Query.FieldByName('act_nom').AsString;
  uni_id := Query.FieldByName('uni_id').AsInteger;
  uni_nom := Query.FieldByName('uni_nom').AsString;
  sec_id := Query.FieldByName('sec_id').AsInteger;
  sec_nom := Query.FieldByName('sec_nom').AsString;
  ray_id := Query.FieldByName('ray_id').AsInteger;
  ray_nom := Query.FieldByName('ray_nom').AsString;
  fam_id := Query.FieldByName('fam_id').AsInteger;
  fam_nom := Query.FieldByName('fam_nom').AsString;
  ssf_id := Query.FieldByName('ssf_id').AsInteger;
  ssf_nom := Query.FieldByName('ssf_nom').AsString;
  ssf_code := Query.FieldByName('ssf_codefinal').AsString;
end;

{ Tfrm_Main }

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  // arf
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  // arf
end;

procedure Tfrm_Main.edt_BaseChange(Sender: TObject);
var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  Activite, Univers, Secteur, Rayon, Famille, ssFamille : TTreeNode;
begin
  if FileExists(edt_Base.Text) then
  begin
    tv_Nomenk.Items.Clear();
    Activite := nil;
    Univers := nil;
    Secteur := nil;
    Rayon := nil;
    Famille := nil;
    ssFamille := nil;

    try
      Connexion := GetNewConnexion(edt_Base.Text, 'ginkoia', 'ginkoia');
      Transaction := GetNewTransaction(Connexion);
      Query := GetNewQuery(Transaction);

      Query.SQL.Text := 'select act_id, act_nom, uni_id, uni_nom, sec_id, sec_nom, ray_id, ray_nom, fam_id, fam_nom, ssf_id, ssf_nom, ssf_codefinal '
                      + 'from nklactivite join k on k_id = act_id and k_enabled = 1 '
                      + 'join nklunivers join k on k_id = uni_id and k_enabled = 1 on uni_actid = act_id '
                      + 'join nklsecteur join k on k_id = sec_id and k_enabled = 1 on sec_uniid = uni_id '
                      + 'join nklrayon join k on k_id = ray_id and k_enabled = 1 on ray_secid = sec_id '
                      + 'join nklfamille join k on k_id = fam_id and k_enabled = 1 on fam_rayid = ray_id '
                      + 'join nklssfamille join k on k_id = ssf_id and k_enabled = 1 on ssf_famid = fam_id '
                      + 'where uni_obligatoire = 1 '
                      + 'order by sec_ordreaff, ray_ordreaff, fam_ordreaff, ssf_ordreaff;';
      Query.Open();
      while not Query.Eof do
      begin
        if (ssFamille = nil) or (not (TssFamille(ssFamille.Data).act_id = Query.FieldByName('act_id').AsInteger)) then
          Activite := tv_Nomenk.Items.Add(nil, Query.FieldByName('act_nom').AsString);
        if (ssFamille = nil) or (not (TssFamille(ssFamille.Data).uni_id = Query.FieldByName('uni_id').AsInteger)) then
          Univers := tv_Nomenk.Items.AddChild(Activite, Query.FieldByName('uni_nom').AsString);
        if (ssFamille = nil) or (not (TssFamille(ssFamille.Data).sec_id = Query.FieldByName('sec_id').AsInteger)) then
          Secteur := tv_Nomenk.Items.AddChild(Univers, Query.FieldByName('sec_nom').AsString);
        if (ssFamille = nil) or (not (TssFamille(ssFamille.Data).ray_id = Query.FieldByName('ray_id').AsInteger)) then
          Rayon := tv_Nomenk.Items.AddChild(Secteur, Query.FieldByName('ray_nom').AsString);
        if (ssFamille = nil) or (not (TssFamille(ssFamille.Data).fam_id = Query.FieldByName('fam_id').AsInteger)) then
          Famille := tv_Nomenk.Items.AddChild(Rayon, Query.FieldByName('fam_nom').AsString);

        ssFamille := tv_Nomenk.Items.AddChild(Famille, Query.FieldByName('ssf_nom').AsString);
        ssFamille.Data := TssFamille.Create(Query);

        Query.Next();
      end;

      tv_Nomenk.Select(ssFamille);
    finally
      Query.Close();
      FreeAndNil(Query);
      Transaction.Rollback();
      FreeAndNil(Transaction);
      Connexion.Close();
      FreeAndNil(Connexion);
    end;
  end;

  GestionInterface(true);
end;

procedure Tfrm_Main.Nbt_BaseClick(Sender: TObject);
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

procedure Tfrm_Main.edt_FichierChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.Nbt_FichierClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_Fichier.Text);
    Open.InitialDir := ExtractFilePath(edt_Fichier.Text);
    Open.Filter := 'Fichier CSV|*.csv|Fichier texte|*.txt'; // '|Vieux fichier Excel|*.xls|Nouveau fichier Excel|*.xlsx';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'csv';
    edt_Fichier.Text := '';
    if Open.Execute() then
      edt_Fichier.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.Btn_TraitementBelgiqueClick(Sender: TObject);
{$REGION 'Btn_TraitementBelgiqueClick'}
  procedure SplitLine(Ligne: String; Values: TStringList; sep: Char = ';');
  begin
    Values.Clear;
    while Pos(sep, Ligne) > 0 do
    begin
      Values.Add(Copy(Ligne, 1, Pos(sep, Ligne) - 1));
      Delete(Ligne, 1, Pos(sep, Ligne));
    end;
    Values.Add(Ligne);
  end;

  procedure ChargerTabFichier(Fichier: TStringList; var Tab: TTabString);
  var
    i: Integer;
    sLigne: String;
  begin
    for i:=1 to Pred(Fichier.Count) do
    begin
      SetLength(Tab, Length(Tab) + 1);
      sLigne := Fichier[i];
      while Pos(';', sLigne) > 0 do
      begin
        SetLength(Tab[High(Tab)], Length(Tab[High(Tab)]) + 1);
        Tab[High(Tab)][High(Tab[High(Tab)])] := Copy(sLigne, 1, Pos(';', sLigne) - 1);
        Delete(sLigne, 1, Pos(';', sLigne));
      end;
      SetLength(Tab[High(Tab)], Length(Tab[High(Tab)]) + 1);
      Tab[High(Tab)][High(Tab[High(Tab)])] := sLigne;
    end;
  end;

  function GetLibelleSecteur(TabArticleGroupe: TTabString; const sSecteur: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i:=Low(TabArticleGroupe) to High(TabArticleGroupe) do
    begin
      if(TabArticleGroupe[i][0] = sSecteur) and (TabArticleGroupe[i][1] = 'NULL') and (TabArticleGroupe[i][2] = 'NULL') and (TabArticleGroupe[i][3] = 'NULL') then
      begin
        Result := TabArticleGroupe[i][4];
        Exit;
      end;
    end;

    raise Exception.Create('Erreur recherche libellé secteur !');
  end;

  function GetLibelleRayon(TabArticleGroupe: TTabString; const sSecteur, sRayon: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i:=Low(TabArticleGroupe) to High(TabArticleGroupe) do
    begin
      if(TabArticleGroupe[i][0] = sSecteur) and (TabArticleGroupe[i][1] = sRayon) and (TabArticleGroupe[i][2] = 'NULL') and (TabArticleGroupe[i][3] = 'NULL') then
      begin
        Result := TabArticleGroupe[i][4];
        Exit;
      end;
    end;

    raise Exception.Create('Erreur recherche libellé rayon !');
  end;

  function GetLibelleFamille(TabArticleGroupe: TTabString; const sSecteur, sRayon, sFamille: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i:=Low(TabArticleGroupe) to High(TabArticleGroupe) do
    begin
      if(TabArticleGroupe[i][0] = sSecteur) and (TabArticleGroupe[i][1] = sRayon) and (TabArticleGroupe[i][2] = sFamille) and (TabArticleGroupe[i][3] = 'NULL') then
      begin
        Result := TabArticleGroupe[i][4];
        Exit;
      end;
    end;

    raise Exception.Create('Erreur recherche libellé famille !');
  end;

  function GetLibelleSousFamille(TabArticleGroupe: TTabString; const sSecteur, sRayon, sFamille, sSousFamille: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i:=Low(TabArticleGroupe) to High(TabArticleGroupe) do
    begin
      if(TabArticleGroupe[i][0] = sSecteur) and (TabArticleGroupe[i][1] = sRayon) and (TabArticleGroupe[i][2] = sFamille) and (TabArticleGroupe[i][3] = sSousFamille) then
      begin
        Result := TabArticleGroupe[i][4];
        Exit;
      end;
    end;

    raise Exception.Create('Erreur recherche libellé sous-famille !');
  end;

  procedure GetMarqueFournisseur(TabMarque: TTabString; const sCodeArticle: String; out sMarque, sFournisseur: String);
  var
    i: Integer;
  begin
    sMarque := 'Sans marque';      sFournisseur := 'Sans marque';
    for i:=Low(TabMarque) to High(TabMarque) do
    begin
      if TabMarque[i][0] = sCodeArticle then
      begin
        sFournisseur := TabMarque[i][1];
        sMarque := TabMarque[i][2];
        Exit;
      end;
    end;
  end;

  function GetTarif(TabArticleEAN, TabTarif: TTabString; const sModeDeBase: String): Double;
  var
    i, j: Integer;
  begin
    Result := 0;
    for i:=Low(TabArticleEAN) to High(TabArticleEAN) do
    begin
      if TabArticleEAN[i][5] = sModeDeBase then
      begin
        for j:=Low(TabTarif) to High(TabTarif) do
        begin
          if TabTarif[j][3] = TabArticleEAN[i][0] then
          begin
            if not TryStrToFloat(TabTarif[j][5], Result) then
              raise Exception.Create('Erreur StrToFloat tarif [' + TabTarif[j][5] + '] !');
            Exit;
          end;
        end;

        raise Exception.Create('Erreur recherche tarif !');
      end;
    end;

    raise Exception.Create('Erreur recherche tarif !');
  end;

  function GetPrixAchat(TabStock, TabArticleEAN, TabTarif: TTabString; const sCodeArticle, sModeDeBase: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i:=Low(TabStock) to High(TabStock) do
    begin
      if TabStock[i][1] = sCodeArticle then
      begin
        Result := TabStock[i][4];
        Exit;
      end;
    end;

    try
      Result := FloatToStr(GetTarif(TabArticleEAN, TabTarif, sModeDeBase) / 2);
    except
      on E: Exception do
      begin
        raise Exception.Create('Erreur recherche prix d''achat :  ' + E.Message);
      end;
    end;
  end;

  function GetCodeBarre(TabArticleEAN: TTabString; const sCodeArticle: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i:=Low(TabArticleEAN) to High(TabArticleEAN) do
    begin
      if TabArticleEAN[i][1] = sCodeArticle then
      begin
        Result := TabArticleEAN[i][4];
        Exit;
      end;
    end;

//    raise Exception.Create('Erreur recherche code barre !');
  end;

// ---
{
  function GetLibelleSecteur(ArticleGroupe: TStringList; const sSecteur: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(ArticleGroupe.Count) do
      begin
        SplitLine(ArticleGroupe[i], Ligne);
        if(Ligne[0] = sSecteur) and (Ligne[1] = 'NULL') and (Ligne[2] = 'NULL') and (Ligne[3] = 'NULL') then
        begin
          Result := Ligne[4];
          Exit;
        end;
      end;

      raise Exception.Create('Erreur recherche libellé secteur !');
    finally
      Ligne.Free;
    end;
  end;

  function GetLibelleRayon(ArticleGroupe: TStringList; const sSecteur, sRayon: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(ArticleGroupe.Count) do
      begin
        SplitLine(ArticleGroupe[i], Ligne);
        if(Ligne[0] = sSecteur) and (Ligne[1] = sRayon) and (Ligne[2] = 'NULL') and (Ligne[3] = 'NULL') then
        begin
          Result := Ligne[4];
          Exit;
        end;
      end;

      raise Exception.Create('Erreur recherche libellé rayon !');
    finally
      Ligne.Free;
    end;
  end;

  function GetLibelleFamille(ArticleGroupe: TStringList; const sSecteur, sRayon, sFamille: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(ArticleGroupe.Count) do
      begin
        SplitLine(ArticleGroupe[i], Ligne);
        if(Ligne[0] = sSecteur) and (Ligne[1] = sRayon) and (Ligne[2] = sFamille) and (Ligne[3] = 'NULL') then
        begin
          Result := Ligne[4];
          Exit;
        end;
      end;

      raise Exception.Create('Erreur recherche libellé famille !');
    finally
      Ligne.Free;
    end;
  end;

  function GetLibelleSousFamille(ArticleGroupe: TStringList; const sSecteur, sRayon, sFamille, sSousFamille: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(ArticleGroupe.Count) do
      begin
        SplitLine(ArticleGroupe[i], Ligne);
        if(Ligne[0] = sSecteur) and (Ligne[1] = sRayon) and (Ligne[2] = sFamille) and (Ligne[3] = sSousFamille) then
        begin
          Result := Ligne[4];
          Exit;
        end;
      end;

      raise Exception.Create('Erreur recherche libellé sous-famille !');
    finally
      Ligne.Free;
    end;
  end;

  function GetMarque(Marque: TStringList; const sCodeArticle: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(Marque.Count) do
      begin
        SplitLine(Marque[i], Ligne);
        if Ligne[0] = sCodeArticle then
        begin
          Result := Ligne[2];
          Exit;
        end;
      end;

      raise Exception.Create('Erreur recherche marque !');
    finally
      Ligne.Free;
    end;
  end;

  function GetPrixAchat(Stock: TStringList; const sCodeArticle: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(Stock.Count) do
      begin
        SplitLine(Stock[i], Ligne);
        if Ligne[1] = sCodeArticle then
        begin
          Result := Ligne[4];
          Exit;
        end;
      end;

      raise Exception.Create('Erreur recherche prix d''achat !');
    finally
      Ligne.Free;
    end;
  end;

  function GetCodeBarre(ArticleEAN: TStringList; const sCodeArticle: String): String;
  var
    i: Integer;
    Ligne: TStringList;
  begin
    Result := '';
    Ligne := TStringList.Create;
    try
      for i:=1 to Pred(ArticleEAN.Count) do
      begin
        SplitLine(ArticleEAN[i], Ligne);
        if Ligne[1] = sCodeArticle then
        begin
          Result := Ligne[4];
          Exit;
        end;
      end;

//      raise Exception.Create('Erreur recherche code barre !');
    finally
      Ligne.Free;
    end;
  end;

  function GetTarif(ArticleEAN, Tarif: TStringList; const sModeDeBase: String): Double;
  var
    i, j: Integer;
    LigneEAN, LigneTarif: TStringList;
  begin
    Result := 0;
    LigneEAN := TStringList.Create;
    try
      for i:=1 to Pred(ArticleEAN.Count) do
      begin
        SplitLine(ArticleEAN[i], LigneEAN);
        if LigneEAN[5] = sModeDeBase then
        begin
          LigneTarif := TStringList.Create;
          try
            for j:=1 to Pred(Tarif.Count) do
            begin
              SplitLine(Tarif[j], LigneTarif);
              if LigneTarif[3] = LigneEAN[0] then
              begin
                if not TryStrToFloat(LigneTarif[5], Result) then
                  raise Exception.Create('Erreur StrToFloat tarif [' + LigneTarif[5] + '] !');
                Exit;
              end;
            end;
          finally
            LigneTarif.Free;
          end;

          raise Exception.Create('Erreur recherche tarif !');
        end;
      end;

      raise Exception.Create('Erreur recherche tarif !');
    finally
      LigneEAN.Free;
    end;
  end;  }

  function FormateTauxTVA(const sTauxTVA: String): Double;
  begin
    Result := 0;
    if TryStrToFloat(sTauxTVA, Result) then
      Result := (Result / 100) + 1
    else
      raise Exception.Create('Erreur StrToFloat taux TVA [' + sTauxTVA + '] !');
  end;
{$ENDREGION}
const
  COL_CODE_ARTICLE = 0;
  COL_NOM_MODELE = 1;
  COL_NK1 = 3;
  COL_NK2 = 4;
  COL_NK3 = 5;
  COL_NK4 = 6;
  COL_TAUX_TVA = 9;
  COL_MODELE_DE_BASE = 10;
  COL_TAILLE = 11;
var
  Connexion: TIB_Connection;
  Transaction: TIB_Transaction;
  Query: TIBOQuery;
  Rapport, Rapport2, FichierSourceAPD, FichierSourceArticleGroupe, FichierSourceArticleEAN, FichierTarif, FichierStock, FichierMarque, FichierDest, LigneAPD: TStringList;
  TabArticleGroupe, TabArticleEAN, TabTarif, TabStock, TabMarque: TTabString;
  i: Integer;
  sMarque, sFournisseur, sLigne: String;
  SaveDialog: TSaveDialog;
begin
  try
    GestionInterface(False);
    Lab_Etape.Caption := '';
    Lab_Etape.Show;
    try
      Connexion := GetNewConnexion(edt_Base.Text, 'ginkoia', 'ginkoia');
      Transaction := GetNewTransaction(Connexion);
      Query := GetNewQuery(Transaction);
      try
        Rapport := TStringList.Create;
        Rapport2 := TStringList.Create;
        FichierSourceAPD := TStringList.Create;
        FichierSourceArticleGroupe := TStringList.Create;
        FichierSourceArticleEAN := TStringList.Create;
        FichierTarif := TStringList.Create;
        FichierStock := TStringList.Create;
        FichierMarque := TStringList.Create;
        FichierDest := TStringList.Create;
        LigneAPD := TStringList.Create;
        try
          FichierSourceAPD.LoadFromFile(edt_Fichier.Text);
          FichierSourceArticleGroupe.LoadFromFile(ExtractFilePath(edt_Fichier.Text) + 'articles_groupe.txt');
          FichierSourceArticleEAN.LoadFromFile(ExtractFilePath(edt_Fichier.Text) + 'articles_aen_apd2011.txt');
          FichierTarif.LoadFromFile(ExtractFilePath(edt_Fichier.Text) + 'tarifs_artciles_apd2011.txt');
          FichierStock.LoadFromFile(ExtractFilePath(edt_Fichier.Text) + 'STOCK-311214.txt');
          FichierMarque.LoadFromFile(ExtractFilePath(edt_Fichier.Text) + 'ref_marques_300415.csv');

          ChargerTabFichier(FichierSourceArticleGroupe, TabArticleGroupe);
          ChargerTabFichier(FichierSourceArticleEAN, TabArticleEAN);
          ChargerTabFichier(FichierTarif, TabTarif);
          ChargerTabFichier(FichierStock, TabStock);
          ChargerTabFichier(FichierMarque, TabMarque);

          FichierDest.Add('Identifiant du magasin;'
                       + 'Numéro du bon de réception;'
                       + 'Saison;'
                       + 'Nom de la collection;'
                       + 'Frais de port HT;'
                       + 'Taux de TVA sur Frais de port;'
                       + 'Identifiant unique;'
                       + 'Référence Fournisseur;'
                       + 'Nom du modèle;'
                       + 'Secteur;'
                       + 'Rayon;'
                       + 'Famille;'
                       + 'Sous Famille;'
                       + 'Nom de la marque;'
                       + 'Nom du fournisseur;'
                       + 'Genre;'
                       + 'Taux de tva;'
                       + 'Prix d’achat catalogue;'
                       + 'Prix d’achat net;'
                       + 'Prix de vente;'
                       + 'ID Grille de taille;'
                       + 'Nom grille de taille;'
                       + 'ID taille;'
                       + 'Nom de la taille;'
                       + 'ID couleur;'
                       + 'Code de la couleur;'
                       + 'Nom de la couleur;'
                       + 'Code barre;'
                       + 'Prix achat catalogue taille;'
                       + 'Prix achat net taille;'
                       + 'Prix de vente taille;'
                       + 'Qté réceptionnée;'
                       + 'Classement 1;'
                       + 'Classement 2;'
                       + 'Classement 3;'
                       + 'Classement 4;'
                       + 'Classement 5;'
                       + 'Modèle CC;');

          // Lecture source (pas les entête).
          for i:=1 to Pred(FichierSourceAPD.Count) do
          begin
            Lab_Etape.Caption := IntToStr(i) + ' / ' + IntToStr(Pred(FichierSourceAPD.Count));
            Application.ProcessMessages;
            try
              // Chargement des données.
              SplitLine(FichierSourceAPD[i], LigneAPD);

              // Si pas de modèle de base :  pas traité.
              if LigneAPD[COL_MODELE_DE_BASE] = '' then
              begin
                Rapport2.Add('Pas de modèle de base [ ' + FichierSourceAPD[i] + ' ]');
                Continue;
              end;

              GetMarqueFournisseur(TabMarque, LigneAPD[COL_CODE_ARTICLE], sMarque, sFournisseur);
              sLigne := ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + LigneAPD[COL_CODE_ARTICLE] + ';'
               + LigneAPD[COL_CODE_ARTICLE] + ';'
               + LigneAPD[COL_NOM_MODELE] + ' (Taille :  ' + LigneAPD[COL_TAILLE] + ');'
               + GetLibelleSecteur(TabArticleGroupe, LigneAPD[COL_NK1]) + ';'
               + GetLibelleRayon(TabArticleGroupe, LigneAPD[COL_NK1], LigneAPD[COL_NK2]) + ';'
               + GetLibelleFamille(TabArticleGroupe, LigneAPD[COL_NK1], LigneAPD[COL_NK2], LigneAPD[COL_NK3]) + ';'
               + GetLibelleSousFamille(TabArticleGroupe, LigneAPD[COL_NK1], LigneAPD[COL_NK2], LigneAPD[COL_NK3], LigneAPD[COL_NK4]) + ';'
               + sMarque + ';'
               + sFournisseur + ';'
               + ';'
               + LigneAPD[COL_TAUX_TVA] + ';'
               + GetPrixAchat(TabStock, TabArticleEAN, TabTarif, LigneAPD[COL_CODE_ARTICLE], LigneAPD[COL_MODELE_DE_BASE]) + ';'
               + GetPrixAchat(TabStock, TabArticleEAN, TabTarif, LigneAPD[COL_CODE_ARTICLE], LigneAPD[COL_MODELE_DE_BASE]) + ';'
               + FormatFloat('0.00', GetTarif(TabArticleEAN, TabTarif, LigneAPD[COL_MODELE_DE_BASE]) * FormateTauxTVA(LigneAPD[COL_TAUX_TVA])) + ';'
               + 'UNITAILLE;'
               + 'UNITAILLE;'
               + 'UNITAILLE;'
               + 'UNITAILLE;'
               + 'UC;'
               + 'UC;'
               + 'UC;'
               + GetCodeBarre(TabArticleEAN, LigneAPD[COL_CODE_ARTICLE]) + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';';
{
              sLigne := ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + LigneAPD[COL_CODE_ARTICLE] + ';'
               + LigneAPD[COL_CODE_ARTICLE] + ';'
               + LigneAPD[COL_NOM_MODELE] + ' (Taille :  ' + LigneAPD[COL_TAILLE] + ');'
               + GetLibelleSecteur(FichierSourceArticleGroupe, LigneAPD[COL_NK1]) + ';'
               + GetLibelleRayon(FichierSourceArticleGroupe, LigneAPD[COL_NK1], LigneAPD[COL_NK2]) + ';'
               + GetLibelleFamille(FichierSourceArticleGroupe, LigneAPD[COL_NK1], LigneAPD[COL_NK2], LigneAPD[COL_NK3]) + ';'
               + GetLibelleSousFamille(FichierSourceArticleGroupe, LigneAPD[COL_NK1], LigneAPD[COL_NK2], LigneAPD[COL_NK3], LigneAPD[COL_NK4]) + ';'
               + GetMarque(FichierMarque, LigneAPD[COL_CODE_ARTICLE]) + ';'
               + ';'
               + ';'
               + LigneAPD[COL_TAUX_TVA] + ';'
               + GetPrixAchat(FichierStock, LigneAPD[COL_CODE_ARTICLE]) + ';'
               + GetPrixAchat(FichierStock, LigneAPD[COL_CODE_ARTICLE]) + ';'
               + FormatFloat('0.00', GetTarif(FichierSourceArticleEAN, FichierTarif, LigneAPD[COL_MODELE_DE_BASE]) * FormateTauxTVA(LigneAPD[COL_TAUX_TVA])) + ';'
               + 'UNITAILLE;'
               + 'UNITAILLE;'
               + 'UNITAILLE;'
               + 'UNITAILLE;'
               + 'UC;'
               + 'UC;'
               + 'UC;'
               + GetCodeBarre(FichierSourceArticleEAN, LigneAPD[COL_CODE_ARTICLE]) + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';'
               + ';';  }
              FichierDest.Add(sLigne);
            except
              on E: Exception do
              begin
                Rapport.Add('Erreur :  ' + E.ClassName + ' - ' + E.Message);
                Rapport.Add(' sur la ligne [ ' + FichierSourceAPD[i] + ' ]');
              end;
            end;
          end;

          SaveDialog := TSaveDialog.Create(Self);
          try
            SaveDialog.InitialDir := ExtractFileDir(edt_Fichier.Text);
            SaveDialog.FileName := '';
            SaveDialog.Filter := 'Fichier CSV|*.csv';
            SaveDialog.DefaultExt := 'csv';
            SaveDialog.Title := ' Enregistrer le Fichier à intégrer dans Ginkoia';
            if(FichierDest.Count > 0) and SaveDialog.Execute then
              FichierDest.SaveToFile(SaveDialog.FileName);
          finally
            SaveDialog.Free;
          end;

          //
//          FichierDest.SaveToFile(ExtractFilePath(edt_Fichier.Text) + 'Résultat.txt');

          if(Rapport.Count > 0) then
            Rapport.SaveToFile(ExtractFilePath(Application.ExeName) + 'Rapport erreurs.txt');
//            Rapport.SaveToFile(ExtractFilePath(edt_Fichier.Text) + 'Rapport erreurs.txt');
          if(Rapport2.Count > 0) then
            Rapport2.SaveToFile(ExtractFilePath(Application.ExeName) + 'Rapport exclu.txt');
//            Rapport2.SaveToFile(ExtractFilePath(edt_Fichier.Text) + 'Rapport exclu.txt');
        finally
          LigneAPD.Free;
          FichierDest.Free;
          FichierMarque.Free;
          FichierStock.Free;
          FichierTarif.Free;
          FichierSourceArticleEAN.Free;
          FichierSourceArticleGroupe.Free;
          FichierSourceAPD.Free;
          Rapport.Free;
          Rapport2.Free;
        end;
      finally
        Query.Free;
        Transaction.Free;
        Connexion.Free;
      end;

      Application.MessageBox('Traitement terminé.', PChar(Caption + ' - message'), MB_ICONINFORMATION + MB_OK);
    finally
      Lab_Etape.Hide;
      GestionInterface(True);
    end;
  except
    on E: Exception do
      MessageDlg('Erreur lors du traitement :  ' + E.ClassName + ' - ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure Tfrm_Main.Btn_TraitementClick(Sender: TObject);

  procedure SplitLine(Ligne : string; Values : TStringList; sep : char = ';');
  begin
    Values.Clear();
    while Pos(sep, Ligne) > 0 do
    begin
      Values.Add(Copy(Ligne, 1, Pos(sep, Ligne) -1));
      Delete(Ligne, 1, Pos(sep, Ligne));
    end;
    Values.Add(Ligne);
  end;

  function GetNomMarque(Query : TIBOQuery; CodeMrk : string) : string;
  begin
    Result := '';

    Query.SQL.Text := 'select mrk_nom from artmarque join k on k_id = mrk_id and k_enabled = 1 where upper(mrk_code) = upper(' + QuotedStr(CodeMrk) + ');';
    Query.Open();
    if not Query.Eof then
      Result := Query.Fields[0].AsString
    else
      Raise Exception.Create('Marque inexistante (mrk : "' + CodeMrk + '")');
  end;

  function TrimLeadingZeros(txt : string) : string;
  var
    i : integer;
  begin
    Result := '';
    for i := 1 to Length(txt) do
      if txt[i] <> '0' then
      begin
        Result := Copy(txt, i, Length(txt));
        Exit;
      end;
  end;

  function GetNomFournisseur(Query : TIBOQuery; CodeMrk, CodeFourn : string) : string;
  begin
    Result := '';

    if chk_UseFournisseur.checked and (not (trim(CodeFourn) = '')) then
    begin
      // recup du fournisseur principal de la marque
      Query.SQL.Text := 'select fou_nom from artfourn join k on k_id = fou_id and k_enabled = 1 where upper(fou_code) = upper(' + QuotedStr(CodeFourn) + ');';
      Query.Open();
      if not Query.Eof then
        Result := Query.Fields[0].AsString;
    end;

    if Result = '' then
    begin
      // recup du fournisseur
      Query.SQL.Text := 'select fou_nom '
                      + 'from artmarque join k on k_id = mrk_id and k_enabled = 1 '
                      + 'join artmrkfourn join k on k_id = fmk_id and k_enabled = 1 on fmk_mrkid = mrk_id '
                      + 'join artfourn join k on k_id = fou_id and k_enabled = 1 on fou_id = fmk_fouid '
                      + 'where upper(mrk_code) = upper(' + QuotedStr(CodeMrk) + ') '
                      + 'order by fmk_prin desc rows 1';
      Query.Open();
      if not Query.Eof then
        Result := Query.Fields[0].AsString
      else
        Raise Exception.Create('Fournisseur inexistant (fou : "' + CodeFourn + '" - mrk : "' + CodeMrk + '" "' + GetNomMarque(Query, CodeMrk) + '")');
    end;
  end;

  procedure GetArticleNomenclature(Query : TIBOQuery; CodeFinal : string; out secteur, rayon, famille, ssfamille : string);

    function GetNodeByssfCode(Tree : TTreeView; ssfCode : string) : TTreeNode;
    var
      Node : TTreeNode;
    begin
      Result := nil;
      if Tree.Items.Count > 0 then
      begin
        Node := Tree.Items[0];
        while Assigned(Node) do
        begin
          if Assigned(Node.Data) and
             (TssFamille(Node.Data).ssf_code = ssfCode) then
          begin
            Result := Node;
            Break;
          end;
          Node := Node.GetNext();
        end;
      end;
    end;

  var
    ssfNode : TTreeNode;
  begin
    ssfNode := nil;

    if not (trim(CodeFinal) = '') then
      ssfNode := GetNodeByssfCode(tv_Nomenk, CodeFinal);

    if not Assigned(ssfNode) then
      ssfNode := tv_Nomenk.Selected;

    if Assigned(ssfNode) and Assigned(ssfNode.Data) then
    begin
      secteur := TssFamille(ssfNode.Data).sec_nom;
      rayon := TssFamille(ssfNode.Data).ray_nom;
      famille := TssFamille(ssfNode.Data).fam_nom;
      ssfamille := TssFamille(ssfNode.Data).ssf_nom;
    end;
  end;

const
  COL_CODE_ADH = 4;
  COL_ARTICLE_REF = 5;
  COL_ARTICLE_DESIGN = 6;
  COL_ARTICLE_EAN = 7;
  COL_ARTICLE_PRIX_ACHAT = 10;
  COL_ARTICLE_QTE = 11;
  COL_ARTICLE_PRIX_VENTE = 13;
  COL_FOURNISSEUR_CODE = 8;
  COL_MARQUE_CODE = 9;
  COL_SSFAMILLE_CODE = 15;
var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  oldFichier, newFichier, Rapport, Ligne : TStringList;
  secteur, rayon, famille, ssfamille : string;
  i : integer;
  Save : TSaveDialog;
begin
  try
    try
      GestionInterface(false);

      try
        Connexion := GetNewConnexion(edt_Base.Text, 'ginkoia', 'ginkoia');
        Transaction := GetNewTransaction(Connexion);
        Query := GetNewQuery(Transaction);

        try
          Rapport := TStringList.Create();
          oldFichier := TStringList.Create();
          oldFichier.LoadFromFile(edt_Fichier.Text);
          newFichier := TStringList.Create();
          newFichier.Add('Identifiant du magasin;'
                       + 'Numéro du bon de réception;'
                       + 'Saison;'
                       + 'Nom de la collection;'
                       + 'Frais de port HT;'
                       + 'Taux de TVA sur Frais de port;'
                       + 'Identifiant unique;'
                       + 'Référence Fournisseur;'
                       + 'Nom du modèle;'
                       + 'Secteur;'
                       + 'Rayon;'
                       + 'Famille;'
                       + 'Sous Famille;'
                       + 'Nom de la marque;'
                       + 'Nom du fournisseur;'
                       + 'Genre;'
                       + 'Taux de tva;'
                       + 'Prix d’achat catalogue;'
                       + 'Prix d’achat net;'
                       + 'Prix de vente;'
                       + 'ID Grille de taille;'
                       + 'Nom grille de taille;'
                       + 'ID taille;'
                       + 'Nom de la taille;'
                       + 'ID couleur;'
                       + 'Code de la couleur;'
                       + 'Nom de la couleur;'
                       + 'Code barre;'
                       + 'Prix achat catalogue taille;'
                       + 'Prix achat net taille;'
                       + 'Prix de vente taille;'
                       + 'Qté réceptionnée'
                        );
          Ligne := TStringList.Create();

          // lecture (pas les entete)
          for i := 1 to oldFichier.Count -1 do
          begin
            try
              // recup des valeurs
              SplitLine(oldFichier[i], Ligne);
              // rejet ?
              if (Trim(Ligne[COL_ARTICLE_REF]) = '') then
              begin
                Rapport.Add('Erreur : pas de reference article');
                Rapport.Add('  sur la ligne : "' + oldFichier[i] + '"');
                Continue;
              end
              else if (Ligne.Count < COL_SSFAMILLE_CODE) then
              begin
                Rapport.Add('Erreur : pas assez de colonnes');
                Rapport.Add('  sur la ligne : "' + oldFichier[i] + '"');
                Continue;
              end;
              // nomenclature
              if Ligne.Count > COL_SSFAMILLE_CODE then
                GetArticleNomenclature(Query, Ligne[COL_SSFAMILLE_CODE], secteur, rayon, famille, ssfamille)
              else
                GetArticleNomenclature(Query, '', secteur, rayon, famille, ssfamille);
              // Ecriture du nouveau fichier
              newFichier.Add(Ligne[COL_CODE_ADH] + ';' // Identifiant du magasin
                           + 'TEST_IMPORT_GOSPORT;' // Numéro du bon de réception
                           + '1;' // Saison
                           + ';' // Nom de la collection
                           + ';' // Frais de port HT
                           + ';' // Taux de TVA sur Frais de port
                           + Copy(Ligne[COL_ARTICLE_REF], 1, 32) + ';' // Identifiant unique
                           + Copy(Ligne[COL_ARTICLE_REF], 1, 64) + ';' // Référence Fournisseur
                           + Copy(Ligne[COL_ARTICLE_DESIGN], 1, 64) + ';' // Nom du modèle
                           + Copy(secteur, 1, 64) + ';' // Secteur
                           + Copy(rayon, 1, 64) + ';' // Rayon
                           + Copy(famille, 1, 64) + ';' // Famille
                           + Copy(ssfamille, 1, 64) + ';' // Sous Famille
                           + Copy(GetNomMarque(Query, Ligne[COL_MARQUE_CODE]), 1, 64) + ';' // Nom de la marque
                           + Copy(GetNomFournisseur(Query, Ligne[COL_MARQUE_CODE], TrimLeadingZeros(Ligne[COL_FOURNISSEUR_CODE])), 1, 64) + ';' // Nom du fournisseur
                           + 'UNISEXE;' // Genre
                           + '20;'// Taux de tva
                           + Ligne[COL_ARTICLE_PRIX_ACHAT] + ';' // Prix d’achat catalogue
                           + Ligne[COL_ARTICLE_PRIX_ACHAT] + ';' // Prix d’achat net
                           + Ligne[COL_ARTICLE_PRIX_VENTE] + ';' // Prix de vente
                           + ';' // ID Grille de taille
                           + Copy(Ligne[COL_ARTICLE_REF], 1, 64) + ';' // Nom grille de taille
                           + ';' // ID taille
                           + 'UNIQUE;' // Nom de la taille
                           + ';' // ID couleur
                           + 'UNI;' // Code de la couleur
                           + 'UNICOLOR;' // Nom de la couleur
                           + Copy(Ligne[COL_ARTICLE_EAN], 1, 64) + ';' // Code barre
                           + ';' // Prix achat catalogue taille
                           + ';' // Prix achat net taille
                           + ';' // Prix de vente taille
                           + IntToStr(Trunc(StrToFloat(Ligne[COL_ARTICLE_QTE]))) // Qté réceptionnée
                            );
            except
              on e : Exception do
              begin
                Rapport.Add('Exception : ' + e.ClassName + ' - ' + e.Message);
                Rapport.Add('  sur la ligne : "' + oldFichier[i] + '"');
              end;
            end;
          end;

          // ecriture du nouveau fichier
          try
            Save := TSaveDialog.Create(Self);

            // sortie
            Save.InitialDir := ExtractFileDir(edt_Fichier.Text);
            Save.FileName := '';
            Save.Filter := 'Fichier CSV|*.csv';
            Save.DefaultExt := 'csv';
            Save.Title := 'Enregistrer le Fichier a intégré dans Ginkoia';
            if (newFichier.Count > 0) and Save.Execute() then
              newFichier.SaveToFile(Save.FileName);

            // rapport
            Save.InitialDir := ExtractFileDir(edt_Fichier.Text);
            Save.FileName := '';
            Save.Filter := 'Fichier TXT|*.txt';
            Save.DefaultExt := 'txt';
            Save.Title := 'Enregistrer le Rapport';
            if (Rapport.Count > 0) and Save.Execute() then
              Rapport.SaveToFile(Save.FileName);
          finally
            FreeAndNil(Save);
          end;
          MessageDlg('Traitement terminé', mtInformation, [mbOK], 0);
        finally
          FreeAndNil(Rapport);
          FreeAndNil(oldFichier);
          FreeAndNil(newFichier);
          FreeAndNil(Ligne);
        end;
      finally
        Query.Close();
        FreeAndNil(Query);
        Transaction.Rollback();
        FreeAndNil(Transaction);
        Connexion.Close();
        FreeAndNil(Connexion);
      end;
    finally
      GestionInterface(true);
    end;
  except
    on e : Exception do
      MessageDlg('Erreur lors du traitement : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
  end;
end;

procedure Tfrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

procedure TFrm_Main.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);
      FileExt := UpperCase(ExtractFileExt(FileName));
      if FileExt = '.IB' then
        edt_Base.Text := FileName
      else if FileExt = '.CSV' then
        edt_Fichier.Text := FileName
// TODO -obpy :
//      else if (FileExt = '.XLS') or (FileExt = '.XLS') then
//        edt_Fichier.Text := FileName
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

procedure TFrm_Main.GestionInterface(Enabled : boolean);
begin
  Lab_Base.Enabled := Enabled;
  edt_Base.Enabled := Enabled;
  Nbt_Base.Enabled := Enabled;
  Lab_Fichier.Enabled := Enabled;
  edt_Fichier.Enabled := Enabled;
  Nbt_Fichier.Enabled := Enabled;
  chk_UseFournisseur.Enabled := Enabled;
  Lab_ssFamille.Enabled := Enabled;
  tv_Nomenk.Enabled := Enabled;

  if Enabled then
    Btn_Traitement.Enabled := FileExists(edt_Base.Text) and FileExists(edt_Fichier.Text)
  else
    Btn_Traitement.Enabled := False;
  Btn_TraitementBelgique.Enabled := Btn_Traitement.Enabled;

  Btn_Quitter.Enabled := Enabled;

  Application.ProcessMessages();
end;

end.


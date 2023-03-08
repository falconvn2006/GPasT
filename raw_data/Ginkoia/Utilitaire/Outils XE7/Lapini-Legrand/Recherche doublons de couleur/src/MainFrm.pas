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
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Generics.Collections;

type
  TInfosCouleurs = TDictionary<string, string>;
  TInfosArticle = class(TObject)
  private
    FCodeArt, FCodeMrk, FCodeGT : string;
    FListCouleur : TInfosCouleurs;
  public
    constructor Create(CodeArt, CodeMrk, CodeGT : string); reintroduce;
    destructor Destroy(); override;
    property CodeArt : string read FCodeArt write FCodeArt;
    property CodeMrk : string read FCodeMrk write FCodeMrk;
    property CodeGT : string read FCodeGT write FCodeGT;
    property ListeCouleur : TInfosCouleurs read FListCouleur;
  end;
  TListInfosArticles = TObjectDictionary<string, TInfosArticle>;
  TListCouleurErrors = TObjectList<TStringList>;
  TResultSearch = record
    nbTraite : integer;
    nbDoublons : integer;
    nbNotFound : integer;
    nbNoColor : integer;
    ListeCouleurError : TListCouleurErrors;
  end;

type
  Tfrm_Main = class(TForm)
    lbl_Base: TLabel;
    edt_Base: TEdit;
    btn_Base: TSpeedButton;
    lbl_Articles: TLabel;
    edt_Articles: TEdit;
    btn_Articles: TSpeedButton;
    lbl_Couleurs: TLabel;
    edt_Couleurs: TEdit;
    btn_Couleurs: TSpeedButton;
    Panel1: TPanel;
    lbl_Etape: TLabel;
    pb_Progress: TProgressBar;
    btn_SaveLog: TSpeedButton;
    Panel2: TPanel;
    btn_Traitement: TButton;
    btn_Close: TButton;
    mmo_Resultat: TMemo;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_BaseChange(Sender: TObject);
    procedure btn_BaseClick(Sender: TObject);
    procedure edt_ArticlesChange(Sender: TObject);
    procedure btn_ArticlesClick(Sender: TObject);
    procedure edt_CouleursChange(Sender: TObject);
    procedure btn_CouleursClick(Sender: TObject);
    procedure btn_SaveLogClick(Sender: TObject);
    procedure btn_TraitementClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Déclarations privées }

    // traitement du programme !
    function Traitement(out error : string) : boolean;
    function ReadFiles(FileArticle, FileCouleur : string) : TListInfosArticles;
    function SeekBDDForCouleur(FileBDD : string; InfoArticles : TListInfosArticles) : TResultSearch;
    function SaveNewFile(InfoPBCouleur : TListCouleurErrors) : boolean;

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
  System.Math,
  System.UITypes,
  Winapi.ShellAPI,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait;

{$R *.dfm}

{ TInfosArticle }


constructor TInfosArticle.Create(CodeArt, CodeMrk, CodeGT : string);
begin
  inherited Create();
  FCodeArt := CodeArt;
  FCodeMrk := CodeMrk;
  FCodeGT := CodeGT;
  FListCouleur := TInfosCouleurs.Create();
end;

destructor TInfosArticle.Destroy();
begin
  FreeAndNil(FListCouleur);
  inherited Destroy();
end;

{ Tfrm_Main }

// evenement !

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

procedure Tfrm_Main.edt_CouleursChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_CouleursClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_Couleurs.Text);
    Open.InitialDir := ExtractFilePath(edt_Couleurs.Text);
    Open.Filter := 'Fichier CSV|*.CSV';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'CSV';
    edt_Couleurs.Text := '';
    if Open.Execute() then
      edt_Couleurs.Text := Open.FileName;
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

  function GetNbCouleurs(InfoCouleurFile : TListInfosArticles) : integer;
  var
    CodeArt : string;
  begin
    Result := 0;
    for CodeArt in InfoCouleurFile.Keys do
      Result := Result + InfoCouleurFile[CodeArt].ListeCouleur.Count;
  end;

var
  InfoCouleurFile : TListInfosArticles;
  InfoPBCouleur : TResultSearch;
begin
  result := false;
  error := '';
  mmo_Resultat.Lines.Clear();
  
  try
    try
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Debut du traitement.');
      // Lecture des fichiers
      InfoCouleurFile := ReadFiles(edt_Articles.Text, edt_Couleurs.Text);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de lecture des articles (' + IntToStr(InfoCouleurFile.Count) + ' articles, ' + IntToStr(GetNbCouleurs(InfoCouleurFile)) + ' couleurs).');
      // Traitement
      InfoPBCouleur := SeekBDDForCouleur(edt_Base.Text, InfoCouleurFile);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de recherche des problèmes :');
      mmo_Resultat.Lines.Add('    Article non trouvé : '  + IntToStr(InfoPBCouleur.nbNotFound));
      mmo_Resultat.Lines.Add('    Article en doublons : '  + IntToStr(InfoPBCouleur.nbDoublons));
      mmo_Resultat.Lines.Add('    Article sans couleur : '  + IntToStr(InfoPBCouleur.nbNoColor));
      mmo_Resultat.Lines.Add('    Article traité : '  + IntToStr(InfoPBCouleur.nbTraite));
      mmo_Resultat.Lines.Add('    Lignes de couples articles/couleurs problématique : ' + IntToStr(InfoPBCouleur.ListeCouleurError.Count));
      // Generation du fichier de sortie !
      if SaveNewFile(InfoPBCouleur.ListeCouleurError) then
      begin
        mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin du traitement.');
        Result := true;
      end
      else
        mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Erreur lors de l''enregistrement du fichier.');
    finally
      FreeAndNil(InfoCouleurFile);
      FreeAndNil(InfoPBCouleur.ListeCouleurError);
    end;
  except
    on e : Exception do
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
  end;
end;

function Tfrm_Main.ReadFiles(FileArticle, FileCouleur : string) : TListInfosArticles;

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
  ART_CODE = 0;
  ART_MARQUE = 1;
  ART_CODE_GT = 2;
  COULEUR_CODE = 2;
  COULEUR_NOM = 1;
var
  LstArticle : TStringList;
  LstCouleur : TStringList;
  LstChamps : TStringList;
  i : integer;
begin
  Result := TListInfosArticles.Create([doOwnsValues]);

  try
    LstArticle := TStringList.Create();
    LstArticle.LoadFromFile(FileArticle);
    LstChamps := TStringList.Create();
    LstCouleur := TStringList.Create();
    LstCouleur.LoadFromFile(FileCouleur);

    // init progress bar !
    lbl_Etape.Caption := 'Etape 1 / 3';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := LstArticle.Count + LstCouleur.Count;

    // lecture des articles
    for i := 1 to LstArticle.Count -1 do
    begin
      GetLigneInfos(LstArticle[i], LstChamps, 3);
      Result.Add(LstChamps[ART_CODE], TInfosArticle.Create(LstChamps[ART_CODE], LstChamps[ART_MARQUE], LstChamps[ART_CODE_GT]));
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;

    // lecture des couleurs
    for i := 1 to LstCouleur.Count -1 do
    begin
      GetLigneInfos(LstCouleur[i], LstChamps);
      if Result.ContainsKey(LstChamps[ART_CODE]) then
        Result[LstChamps[ART_CODE]].ListeCouleur.Add(LstChamps[COULEUR_CODE], LstChamps[COULEUR_NOM])
      else
        raise Exception.Create('Article dans les couleur mais non trouver dans les articles');
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end
  finally
    FreeAndNil(LstArticle);
    FreeAndNil(LstCouleur);
    FreeAndNil(LstChamps);
  end;
end;

function Tfrm_Main.SeekBDDForCouleur(FileBDD : string; InfoArticles : TListInfosArticles) : TResultSearch;
var
  Connexion : TFDConnection;
  QueryArt, QueryMrk, QueryGtf, QueryCou : TFDQuery;
  ArtCode : string;
  Idx, i, nbAdded : integer;
begin
  Result.nbTraite := 0;
  Result.nbDoublons := 0;
  Result.nbNotFound := 0;
  Result.nbNoColor := 0;
  Result.ListeCouleurError := TListCouleurErrors.Create(True);

  if FileExists(FileBDD) then
  begin
    // init progress bar !
    lbl_Etape.Caption := 'Etape 2 / 3';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := InfoArticles.Count;

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

      QueryArt := TFDQuery.Create(Self);
      QueryArt.Connection := Connexion;
      QueryArt.SQL.Text := 'select art_id, art_code, art_nom, art_refmrk '
                         + 'from artarticle '
                         + 'where art_code = :codeart;';
      QueryArt.Prepare();

      QueryMrk := TFDQuery.Create(Self);
      QueryMrk.Connection := Connexion;
      QueryMrk.SQL.Text := 'select mrk_id, mrk_code, mrk_nom '
                         + 'from artmarque '
                         + 'where mrk_code = :codemrk;';
      QueryMrk.Prepare();

      QueryGtf := TFDQuery.Create(Self);
      QueryGtf.Connection := Connexion;
      QueryGtf.SQL.Text := 'select f_stripstring(gtf_code, ''.'') as gtf_code '
                         + 'from artarticle join plxgtf on gtf_id = art_gtfid '
                         + 'where art_id = :idart;';
      QueryGtf.Prepare();

      QueryCou := TFDQuery.Create(Self);
      QueryCou.Connection := Connexion;
      QueryCou.SQL.Text := 'select cou_id, cou_code, cou_nom '
                         + 'from plxcouleur '
                         + 'where cou_artid = :idart;';
      QueryCou.Prepare();

      for ArtCode in InfoArticles.Keys do
      begin
        try
          QueryArt.ParamByName('codeart').AsString := ArtCode;
          QueryArt.Open();
          QueryMrk.ParamByName('codemrk').AsString := InfoArticles[ArtCode].CodeMrk;
          QueryMrk.Open();

          if QueryArt.RecordCount = 0 then
          begin
            mmo_Resultat.Lines.Add('  ATTENTION : article non trouvé : Code = "' + ArtCode + '"');
            Inc(Result.nbNotFound);
          end
          else if QueryArt.RecordCount = 1 then
          begin
            try
              QueryCou.ParamByName('idart').AsInteger := QueryArt.FieldByName('art_id').AsInteger;
              QueryCou.Open();
              if QueryCou.Eof then
              begin
                mmo_Resultat.Lines.Add('  ATTENTION : pas de couleur pour cet article : Code = "' + ArtCode + '"');
                Inc(Result.nbNoColor);
              end
              else
              begin
                while not QueryCou.Eof do
                begin
                  if InfoArticles[ArtCode].ListeCouleur.ContainsKey(QueryCou.FieldByName('cou_code').AsString) and
                     (Trim(UpperCase(InfoArticles[ArtCode].ListeCouleur[QueryCou.FieldByName('cou_code').AsString])) <> Trim(UpperCase(QueryCou.FieldByName('cou_nom').AsString))) then
                  begin
                    Idx := Result.ListeCouleurError.Add(TStringList.Create());
                    for i := 0 to QueryArt.Fields.Count -1 do
                      Result.ListeCouleurError[Idx].Add(QueryArt.Fields[i].AsString);
                    for i := 0 to QueryMrk.Fields.Count -1 do
                      Result.ListeCouleurError[Idx].Add(QueryMrk.Fields[i].AsString);
                    for i := 0 to QueryCou.Fields.Count -1 do
                      Result.ListeCouleurError[Idx].Add(QueryCou.Fields[i].AsString);
                    Result.ListeCouleurError[Idx].Add(InfoArticles[ArtCode].ListeCouleur[QueryCou.FieldByName('cou_code').AsString]);
                  end;
                  QueryCou.Next();
                end;
                Inc(Result.nbTraite);
              end;
            finally
              QueryCou.Close();
            end;
          end
          else
          begin
            nbAdded := 0;
            while not QueryArt.Eof do
            begin
              try
                QueryGtf.ParamByName('idart').AsInteger := QueryArt.FieldByName('art_id').AsInteger;
                QueryGtf.Open();
                if QueryGtf.FieldByName('gtf_code').AsString = InfoArticles[ArtCode].CodeGT then
                begin
                  Inc(nbAdded);
                  try
                    QueryCou.ParamByName('idart').AsInteger := QueryArt.FieldByName('art_id').AsInteger;
                    QueryCou.Open();
                    if QueryCou.Eof then
                    begin
                      mmo_Resultat.Lines.Add('  ATTENTION : pas de couleur pour cet article : Code = "' + ArtCode + '"');
                      Inc(Result.nbNoColor);
                    end
                    else
                    begin
                      while not QueryCou.Eof do
                      begin
                        if InfoArticles[ArtCode].ListeCouleur.ContainsKey(QueryCou.FieldByName('cou_code').AsString) and
                           (Trim(UpperCase(InfoArticles[ArtCode].ListeCouleur[QueryCou.FieldByName('cou_code').AsString])) <> Trim(UpperCase(QueryCou.FieldByName('cou_nom').AsString))) then
                        begin
                          Idx := Result.ListeCouleurError.Add(TStringList.Create());
                          for i := 0 to QueryArt.Fields.Count -1 do
                            Result.ListeCouleurError[Idx].Add(QueryArt.Fields[i].AsString);
                          for i := 0 to QueryMrk.Fields.Count -1 do
                            Result.ListeCouleurError[Idx].Add(QueryMrk.Fields[i].AsString);
                          for i := 0 to QueryCou.Fields.Count -1 do
                            Result.ListeCouleurError[Idx].Add(QueryCou.Fields[i].AsString);
                          Result.ListeCouleurError[Idx].Add(InfoArticles[ArtCode].ListeCouleur[QueryCou.FieldByName('cou_code').AsString]);
                        end;
                        QueryCou.Next();
                      end;
                      Inc(Result.nbTraite);
                    end;
                  finally
                    QueryCou.Close();
                  end;
                end;
              finally
                QueryGtf.Close();
              end;
              QueryArt.Next();
            end;
            mmo_Resultat.Lines.Add('  ATTENTION : multiple articles (' + IntToStr(QueryArt.RecordCount) + ') trouvés : Code = "' + ArtCode + '", ' + IntToStr(nbAdded) + ' traitées');
            Inc(Result.nbDoublons);
          end;
        finally
          QueryArt.Close();
          QueryMrk.Close();
        end;
        pb_Progress.StepIt();
        Application.ProcessMessages();
      end;
    finally
      FreeAndNil(QueryArt);
      FreeAndNil(QueryMrk);
      FreeAndNil(QueryCou);
      Connexion.Close();
      FreeAndNil(Connexion);
    end;
  end;
end;

function Tfrm_Main.SaveNewFile(InfoPBCouleur : TListCouleurErrors) : boolean;
var
  Sep, Quot : char;
  Fichier : TextFile;
  Ligne : string;
  i, j : integer;
begin
  result := false;
  Sep := ';';
  Quot := '"';

  // init progress bar !
  lbl_Etape.Caption := 'Etape 3 / 3';
  Application.ProcessMessages();
  pb_Progress.Position := 0;
  pb_Progress.Step := 1;
  pb_Progress.Max := InfoPBCouleur.Count;

  try
    AssignFile(Fichier, ExtractFilePath(edt_Base.Text) + 'ListeDoublonsCouleurs.csv');
    Rewrite(Fichier);

    // entete
    Ligne := '"art_id";"art_code";"art_nom";"art_refmrk";"mrk_id";"mrk_code";"mrk_nom";"cou_id";"cou_code";"base_cou_nom";"fic_cou_nom";"todo";"new_cou_id"';
    Writeln(Fichier, Ligne);

    // lignes
    for i := 0 to InfoPBCouleur.Count -1 do
    begin
      Ligne := '';
      for j := 0 to InfoPBCouleur[i].Count -1 do
        Ligne := Ligne + Quot + InfoPBCouleur[i][j] + Quot + Sep;
      Ligne := Ligne + Quot + Quot + Sep + Quot + Quot + Sep;
      Writeln(Fichier, Ligne);
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
      if FileExt = '.IB' then
        edt_Base.Text := Fichier
      else if FileExt = '.CSV' then
      begin
        if FileName = 'ARTICLE.CSV' then
          edt_Articles.Text := Fichier
        else if FileName = 'COULEUR.CSV' then
          edt_Couleurs.Text := Fichier
        else if edt_Articles.Text = '' then
          edt_Articles.Text := Fichier
        else if edt_Couleurs.Text = '' then
          edt_Couleurs.Text := Fichier;
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

    lbl_Couleurs.Enabled := Enabled;
    edt_Couleurs.Enabled := Enabled;
    btn_Couleurs.Enabled := Enabled;

    btn_SaveLog.Enabled := Enabled;

    btn_Traitement.Enabled := Enabled and
                              ((Trim(edt_Articles.Text) <> '') and FileExists(edt_Articles.Text)) and
                              ((Trim(edt_Couleurs.Text) <> '') and FileExists(edt_Couleurs.Text)) and
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

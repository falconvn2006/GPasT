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
  TInfosCorrection = class(TObject)
  private
    FTodo : boolean;
    FNewIdCou : integer;
  public
    constructor Create(Todo : boolean; NewIdCou : integer); reintroduce;
    property Todo : boolean read FTodo write FTodo;
    property NewIdCou : integer read FNewIdCou write FNewIdCou;
  end;
  TInfosCouleur = TObjectDictionary<integer, TInfosCorrection>;
  TInfosArticle = TObjectDictionary<integer, TInfosCouleur>;

  TResTraiteNewFile = record
    nbNotFound : integer;
    nbToTraiteNew : integer;
    nbToTraiteId : integer;
    nbDoNothing : integer;
  end;

type
  Tfrm_Main = class(TForm)
    lbl_OldFile: TLabel;
    lbl_NewFile: TLabel;
    edt_OldFile: TEdit;
    edt_NewFile: TEdit;
    btn_OldFile: TSpeedButton;
    btn_NewFile: TSpeedButton;
    Panel1: TPanel;
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

    procedure edt_OldFileChange(Sender: TObject);
    procedure btn_OldFileClick(Sender: TObject);
    procedure edt_NewFileChange(Sender: TObject);
    procedure btn_NewFileClick(Sender: TObject);
    procedure btn_SaveLogClick(Sender: TObject);
    procedure btn_TraitementClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Déclarations privées }

    // traitement du programme !
    function Traitement(out error : string) : boolean;
    function ReadOldFile(OldFile : string) : TInfosArticle;
    function TraiteNewFile(NewFile : string; OldFile : TInfosArticle) : TResTraiteNewFile;

    // decoupage de lignes
    procedure GetLigneInfos(Ligne : string; Infos : TStringList; nbChamps : integer = 0);
    function SetLigneInfos(Infos : TStringList; Quot : Char = '"'; Sep : Char = ';') : string;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
    // activation
    procedure GestionInterface(Enabled : Boolean);
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  System.UITypes,
  Winapi.ShellAPI;

{$R *.dfm}

{ TInfosCorrection }

constructor TInfosCorrection.Create(Todo : boolean; NewIdCou : integer);
begin
  Inherited Create();
  FTodo := Todo;
  FNewIdCou := NewIdCou;
end;

{ Tfrm_Main }

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

procedure Tfrm_Main.edt_OldFileChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_OldFileClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_OldFile.Text);
    Open.InitialDir := ExtractFilePath(edt_OldFile.Text);
    Open.Filter := 'Fichier CSV|*.CSV';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'CSV';
    edt_OldFile.Text := '';
    if Open.Execute() then
      edt_OldFile.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.edt_NewFileChange(Sender: TObject);
begin
  GestionInterface(true);
end;

procedure Tfrm_Main.btn_NewFileClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_NewFile.Text);
    Open.InitialDir := ExtractFilePath(edt_NewFile.Text);
    Open.Filter := 'Fichier CSV|*.CSV';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'CSV';
    edt_NewFile.Text := '';
    if Open.Execute() then
      edt_NewFile.Text := Open.FileName;
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

  function GetNbCouleurs(ListeArticles : TInfosArticle) : integer;
  var
    IdArt : integer;
  begin
    Result := 0;
    for IdArt in ListeArticles.Keys do
      Result := Result + ListeArticles[IdArt].Count;
  end;

var
  LstOldArticles : TInfosArticle;
  ResTraite : TResTraiteNewFile;
begin
  result := false;
  error := '';
  mmo_Resultat.Lines.Clear();

  try
    try
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Debut du traitement.');
      // Lecture de l'ancien fichier
      LstOldArticles := ReadOldFile(edt_OldFile.Text);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de lecture des articles (' + IntToStr(LstOldArticles.Count) + ' articles, ' + IntToStr(GetNbCouleurs(LstOldArticles)) + ' couleurs).');
      // traitement du fichier !
      ResTraite := TraiteNewFile(edt_NewFile.Text, LstOldArticles);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de recherche des correction : ');
      mmo_Resultat.Lines.Add('    Non trouvé dans l''ancien fichier : '  + IntToStr(ResTraite.nbNotFound));
      mmo_Resultat.Lines.Add('    Traitement avec nouvelle couleur : '  + IntToStr(ResTraite.nbToTraiteNew));
      mmo_Resultat.Lines.Add('    Traitement couleur existante : '  + IntToStr(ResTraite.nbToTraiteId));
      mmo_Resultat.Lines.Add('    Pas de traitement : '  + IntToStr(ResTraite.nbDoNothing));
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin du traitement.');

      Result := true;
    finally
      FreeAndNil(LstOldArticles);
    end;
  except
    on e : Exception do
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
  end;
end;

function Tfrm_Main.ReadOldFile(OldFile : string) : TInfosArticle;
const
  ART_ID = 0;
  COU_OLD_ID = 6;
  TODO = 10;
  COU_NEW_ID = 11;
var
  LstArticle : TStringList;
  LstChamps : TStringList;
  i : integer;
begin
  Result := TInfosArticle.Create([doOwnsValues]);

  try
    LstArticle := TStringList.Create();
    LstArticle.LoadFromFile(OldFile);
    LstChamps := TStringList.Create();

    // init progress bar !
    lbl_Etape.Caption := 'Etape 1 / 2';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := LstArticle.Count;

    // lecture des articles
    for i := 1 to LstArticle.Count -1 do
    begin
      GetLigneInfos(LstArticle[i], LstChamps, 12);
      if not Result.ContainsKey(StrToInt(LstChamps[ART_ID])) then
        Result.Add(StrToInt(LstChamps[ART_ID]), TInfosCouleur.Create([doOwnsValues]));
      if not Result[StrToInt(LstChamps[ART_ID])].ContainsKey(StrToInt(LstChamps[COU_OLD_ID])) then
        Result[StrToInt(LstChamps[ART_ID])].Add(StrToInt(LstChamps[COU_OLD_ID]), TInfosCorrection.Create((LstChamps[TODO] <> '0'), StrToIntDef(LstChamps[COU_NEW_ID], 0)));
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;
  finally
    FreeAndNil(LstArticle);
    FreeAndNil(LstChamps);
  end;
end;

function Tfrm_Main.TraiteNewFile(NewFile : string; OldFile : TInfosArticle) : TResTraiteNewFile;
const
  ART_ID = 0;
  COU_OLD_ID = 7;
  TODO = 11;
  COU_NEW_ID = 12;
var
  LstArticle : TStringList;
  LstChamps : TStringList;
  i : integer;
begin
  Result.nbNotFound := 0;
  Result.nbToTraiteNew := 0;
  Result.nbToTraiteId := 0;
  Result.nbDoNothing := 0;

  try
    LstArticle := TStringList.Create();
    LstArticle.LoadFromFile(NewFile);
    LstChamps := TStringList.Create();

    // init progress bar !
    lbl_Etape.Caption := 'Etape 2 / 2';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := LstArticle.Count;

    // lecture des articles
    for i := 1 to LstArticle.Count -1 do
    begin
      GetLigneInfos(LstArticle[i], LstChamps, 13);
      if OldFile.ContainsKey(StrToInt(LstChamps[ART_ID])) then
      begin
        if OldFile[StrToInt(LstChamps[ART_ID])].ContainsKey(StrToInt(LstChamps[COU_OLD_ID])) then
        begin
          if OldFile[StrToInt(LstChamps[ART_ID])][StrToInt(LstChamps[COU_OLD_ID])].Todo then
          begin
            LstChamps[TODO] := '1';
            if OldFile[StrToInt(LstChamps[ART_ID])][StrToInt(LstChamps[COU_OLD_ID])].NewIdCou <> 0 then
            begin
              LstChamps[COU_NEW_ID] := IntToStr(OldFile[StrToInt(LstChamps[ART_ID])][StrToInt(LstChamps[COU_OLD_ID])].NewIdCou);
              Inc(Result.nbToTraiteId);
            end
            else
            begin
              LstChamps[COU_NEW_ID] := '';
              Inc(Result.nbToTraiteNew);
            end;
          end
          else
          begin
            LstChamps[TODO] := '0';
            Inc(Result.nbDoNothing);
          end;
        end
        else
        begin
          mmo_Resultat.Lines.Add('  ATTENTION : Ligne sans correspondance : ' + LstArticle[i]);
          Inc(Result.nbNotFound);
        end;
      end
      else
      begin
        mmo_Resultat.Lines.Add('  ATTENTION : Ligne sans correspondance : ' + LstArticle[i]);
        Inc(Result.nbNotFound);
      end;
      LstArticle[i] := SetLigneInfos(LstChamps);
    end;
    LstArticle.SaveToFile(NewFile);
  finally
    FreeAndNil(LstArticle);
    FreeAndNil(LstChamps);
  end;
end;

// fonctions utilitaires

procedure Tfrm_Main.GetLigneInfos(Ligne : string; Infos : TStringList; nbChamps : integer = 0);
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

function Tfrm_Main.SetLigneInfos(Infos : TStringList; Quot : Char; Sep : Char) : string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to Infos.Count -1 do
    Result := Result + Quot + Infos[i] + Quot + Sep;
end;

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
      begin
        if FileName = 'LISTEDOUBLONSCOULEURSBIS.CSV' then
          edt_OldFile.Text := Fichier
        else if FileName = 'LISTEDOUBLONSCOULEURS.CSV' then
          edt_NewFile.Text := Fichier
        else if edt_OldFile.Text = '' then
          edt_OldFile.Text := Fichier
        else if edt_NewFile.Text = '' then
          edt_NewFile.Text := Fichier;
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

    lbl_OldFile.Enabled := Enabled;
    edt_OldFile.Enabled := Enabled;
    btn_OldFile.Enabled := Enabled;

    lbl_NewFile.Enabled := Enabled;
    edt_NewFile.Enabled := Enabled;
    btn_NewFile.Enabled := Enabled;

    btn_SaveLog.Enabled := Enabled;

    btn_Traitement.Enabled := Enabled and
                              ((Trim(edt_OldFile.Text) <> '') and FileExists(edt_OldFile.Text)) and
                              ((Trim(edt_NewFile.Text) <> '') and FileExists(edt_NewFile.Text));
    btn_Close.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

end.

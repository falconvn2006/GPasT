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

const
  WM_LAUNCH_AUTO = WM_APP + 1;

type
  TListMagasins = TList<integer>;
  TListPairCouleurs = TDictionary<integer, integer>;
  TListArticles = TObjectDictionary<integer, TListPairCouleurs>;
  TResTraitement = record
    nbArticles : integer;
    nbCouleurs : integer;
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
    Panel3: TPanel;
    pnl_Magasins: TGridPanel;
    pnl_OldMagasins: TPanel;
    pnl_CtrlMagasins: TPanel;
    pnl_NewMagasin: TPanel;
    btn_MoveRight: TSpeedButton;
    btn_MoveLeft: TSpeedButton;
    lbl_OldMagasins: TLabel;
    lbl_NewMagasins: TLabel;
    lst_OldMagasins: TListBox;
    lst_NewMagasins: TListBox;

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
    procedure btn_MoveRightClick(Sender: TObject);
    procedure btn_MoveLeftClick(Sender: TObject);
    procedure btn_SaveLogClick(Sender: TObject);
    procedure btn_TraitementClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Déclarations privées }
    FListIdMags : string;
    FAuto : boolean;

    // traitement du programme !
    function Traitement(out error : string) : boolean;
    function GetListMagasin() : TListMagasins;
    function ReadFile(FileArticle : string) : TListArticles;
    function DesactiveTrigger(FileBDD : string) : TStringList;
    function ChangeCouleurMouvement(FileBDD : string; ListeArticle : TListArticles; ListeMagasins : TListMagasins) : TResTraitement;
    function ReactiveTrigger(FileBDD : string; ListeTriggers : TStringList) : boolean;
    function RecalculeStockArticles(FileBDD : string; ListeArticle : TListArticles) : boolean;

    function EnableDifferTrigger(FileBDD : string; enabled : boolean; etape : integer) : boolean;
    function TraiteTRiggerDiffere(FileBDD : string; etape : integer) : boolean;
    procedure DoBackup();

    // Gestion du traitement Auto !
    procedure MessageTrtAuto(var msg : TWMDropFiles); message WM_LAUNCH_AUTO;

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
  System.Math,
  System.UITypes,
  Winapi.ShellAPI,
  System.Win.Registry,
  System.StrUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait,
  LaunchProcess;

{$R *.dfm}

{ Tfrm_Main }

// evenements

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  Reg : TRegistry;
  i : integer;
  Param : string;
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);

  FListIdMags := '';
  FAuto := false;

  // recup de valeur ar default ...
  // - base0
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Algol\Ginkoia\') then
    begin
      if (Trim(edt_Base.Text) = '') and not (Trim(Reg.ReadString('Base0')) = '') then
        edt_Base.Text := Reg.ReadString('Base0');
    end;
  finally
    FreeAndNil(Reg);
  end;
  // - fichier dans la meme repertoire !!!
  if FileExists(ExtractFilePath(ParamStr(0)) + 'ListeDoublonsCouleurs.new.csv') then
    edt_Articles.Text := ExtractFilePath(ParamStr(0)) + 'ListeDoublonsCouleurs.new.csv';

  // paramètre a la ligne de commande
  if ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
    begin
      if Pos('=', ParamStr(i)) > 0 then
        Param := Copy(ParamStr(i), 1, Pos('=', ParamStr(i)) -1)
      else
        Param := ParamStr(i);

      case IndexText(Param, ['AUTO', 'BASE', 'FILE', 'MAGID']) of
        0 : FAuto := true;
        1 : edt_Base.Text := Copy(ParamStr(i), Pos('=', ParamStr(i)) +1, Length(ParamStr(i)));
        2 : edt_Articles.Text := Copy(ParamStr(i), Pos('=', ParamStr(i)) +1, Length(ParamStr(i)));
        3 : FListIdMags := Copy(ParamStr(i), Pos('=', ParamStr(i)) +1, Length(ParamStr(i)));
      end;
    end;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  if FAuto then
    PostMessage(Handle, WM_LAUNCH_AUTO, 0, 0);
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

procedure Tfrm_Main.btn_MoveRightClick(Sender: TObject);
begin
  if lst_OldMagasins.ItemIndex >= 0 then
  begin
    lst_NewMagasins.AddItem(lst_OldMagasins.Items[lst_OldMagasins.ItemIndex], lst_OldMagasins.Items.Objects[lst_OldMagasins.ItemIndex]);
    lst_OldMagasins.DeleteSelected();
  end;
end;

procedure Tfrm_Main.btn_MoveLeftClick(Sender: TObject);
begin
  if lst_NewMagasins.ItemIndex >= 0 then
  begin
    lst_OldMagasins.AddItem(lst_NewMagasins.Items[lst_NewMagasins.ItemIndex], lst_NewMagasins.Items.Objects[lst_NewMagasins.ItemIndex]);
    lst_NewMagasins.DeleteSelected();
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
      Result := Result + ListeArticles[IdArt].Count;
  end;

var
  ListeMagasins : TListMagasins;
  ListeArticles : TListArticles;
  ListeTrigger : TStringList;
  ResTraitement : TResTraitement;
begin
  result := false;
  error := '';
  mmo_Resultat.Lines.Clear();

  try
    try
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Debut du traitement.');
      TraiteTRiggerDiffere(edt_Base.Text, 1);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de traitement des triggers différés.');
      ListeMagasins := GetListMagasin();
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de gestion des magasins (' + IntToStr(ListeMagasins.Count) + ' magasins).');
      ListeArticles := ReadFile(edt_Articles.Text);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de lecture des articles (' + IntToStr(ListeArticles.Count) + ' articles, ' + IntToStr(GetNbCouleurs(ListeArticles)) + ' couleurs).');
      ListeTrigger := DesactiveTrigger(edt_Base.Text);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de desactivation des triggers (' + IntToStr(ListeTrigger.Count) + ' triggers).');
      ResTraitement := ChangeCouleurMouvement(edt_Base.Text, ListeArticles, ListeMagasins);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de traitement des articles (' + IntToStr(ResTraitement.nbArticles) + ' articles ' + IntToStr(ResTraitement.nbCouleurs) + ' couleurs).');
      ReactiveTrigger(edt_Base.Text, ListeTrigger);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de reactivation des triggers (' + IntToStr(ListeTrigger.Count) + ' triggers).');
      EnableDifferTrigger(edt_Base.Text, True, 7);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de l''activation des trigger differe.');
      RecalculeStockArticles(edt_Base.Text, ListeArticles);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de recalcule des articles (' + IntToStr(ListeArticles.Count) + ' articles).');
      EnableDifferTrigger(edt_Base.Text, false, 7);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de la desactivation des trigger differe.');
      TraiteTRiggerDiffere(edt_Base.Text, 10);
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin de traitement des triggers différés.');
      DoBackup();
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin du backup/restore.');
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - Fin du traitement.');

      Result := true;
    finally
      FreeAndNil(ListeMagasins);
      FreeAndNil(ListeArticles);
      FreeAndNil(ListeTrigger);
    end;
  except
    on e : Exception do
    begin
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
      mmo_Resultat.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + error);
    end;
  end;
end;

function Tfrm_Main.GetListMagasin() : TListMagasins;
var
  i : integer;
begin
  Result := TListMagasins.Create();

  // init progress bar !
  lbl_Etape.Caption := 'Etape 2 / 11';
  Application.ProcessMessages();
  pb_Progress.Position := 0;
  pb_Progress.Step := 1;
  pb_Progress.Max := lst_NewMagasins.Items.Count;

  for i := 0 to lst_NewMagasins.Count -1 do
  begin
    Result.Add(Integer(Pointer(lst_NewMagasins.Items.Objects[i])));
    pb_Progress.StepIt();
    Application.ProcessMessages();
  end;
  if Result.Count = 0 then
    Raise Exception.Create('Pas de nouveaux magasins séléctionné.');
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
  ART_ID = 0;
  COULEUR_OLD_ID = 1;
  COULEUR_NEW_ID = 2;
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
    lbl_Etape.Caption := 'Etape 3 / 11';
    Application.ProcessMessages();
    pb_Progress.Position := 0;
    pb_Progress.Step := 1;
    pb_Progress.Max := LstArticle.Count;

    // lecture des articles
    for i := 1 to LstArticle.Count -1 do
    begin
      GetLigneInfos(LstArticle[i], LstChamps, 14);
      if not Result.ContainsKey(StrToInt(LstChamps[ART_ID])) then
        Result.Add(StrToInt(LstChamps[ART_ID]), TListPairCouleurs.Create());
      Result[StrToInt(LstChamps[ART_ID])].Add(StrToInt(LstChamps[COULEUR_OLD_ID]), StrToInt(LstChamps[COULEUR_NEW_ID]));
      pb_Progress.StepIt();
      Application.ProcessMessages();
    end;
  finally
    FreeAndNil(LstArticle);
    FreeAndNil(LstChamps);
  end;
end;

function Tfrm_Main.DesactiveTrigger(FileBDD : string) : TStringList;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  TrigerName : string;
begin
  Result := TStringList.Create();

  if FileExists(FileBDD) then
  begin
    try
      Connexion := TFDConnection.Create(Self);
      Connexion.DriverName := 'IB';
      Connexion.Params.Clear();
      Connexion.Params.Add('Database=' + FileBDD);
      Connexion.Params.Add('User_Name=sysdba');
      Connexion.Params.Add('Password=masterkey');
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

        // Liste des trigger
        Query.SQL.Text := 'select rdb$trigger_name from rdb$triggers where rdb$system_flag = 0;';
        try
          Query.Open();
          while not Query.Eof do
          begin
            Result.Add(Query.FieldByName('rdb$trigger_name').AsString);
            Query.Next()
          end;
        finally
          Query.Close();
        end;

        // init progress bar !
        lbl_Etape.Caption := 'Etape 4 / 11';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := Result.Count;

        // desactivation
        for TrigerName in Result do
        begin
          Query.SQL.Text := 'alter trigger "' + TrigerName + '" inactive;';
          Query.ExecSQL();
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

function Tfrm_Main.ChangeCouleurMouvement(FileBDD : string; ListeArticle : TListArticles; ListeMagasins : TListMagasins) : TResTraitement;

  function GetListeMagasins(ListeMagasins : TListMagasins) : string;
  var
    i : integer;
  begin
    Result := '';
    for i := 0 to ListeMagasins.Count -1 do
      if Result = '' then
        Result := IntToStr(ListeMagasins[i])
      else
        Result := Result + ', ' + IntToStr(ListeMagasins[i]);
  end;

  function GetIdCouTampon(old : integer) : integer;
  begin
    Result := old + 1;
  end;

  procedure UpdateCouleurTable(Query : TFDQuery; IdMag, TableEntete, IdEnete, TableLigne, IdLien, ArtLigne, CouLigne : string; ListeMagasins : string; idart, idoldcou, idnewcou : integer);
  begin
    if Trim(TableEntete) = '' then
    begin
      Query.SQL.Text := 'update ' + TableLigne + ' '
                      + 'set ' + CouLigne + ' = ' + IntToStr(idnewcou) + ' '
                      + 'where ' + ArtLigne + ' = ' + IntToStr(idart) + ' '
                      + '  and ' + CouLigne + ' = ' + IntToStr(idoldcou) + ' '
                      + '  and ' + IdMag + ' in (' + ListeMagasins + ')';
    end
    else
    begin
      Query.SQL.Text := 'update ' + TableLigne + ' '
                      + 'set ' + CouLigne + ' = ' + IntToStr(idnewcou) + ' '
                      + 'where ' + ArtLigne + ' = ' + IntToStr(idart) + ' '
                      + '  and ' + CouLigne + ' = ' + IntToStr(idoldcou) + ' '
                      + '  and exists(select ' + IdEnete + ' '
                                   + 'from ' + TableEntete + ' '
                                   + 'where ' + IdMag + ' in (' + ListeMagasins + ') '
                                   + '  and ' + IdEnete + ' = ' + TableLigne + '.' + IdLien
                                   + ')';
    end;
    Query.ExecSQL();
  end;

var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  StringMagasins : string;
  IdArt, IdOldCou, IdNewCou, IdCouTampon : integer;
  CouleurTampon : TDictionary<integer, integer>;
begin
  Result.nbArticles := 0;
  Result.nbCouleurs := 0;
  StringMagasins := GetListeMagasins(ListeMagasins);

  if FileExists(FileBDD) then
  begin
    try
      CouleurTampon := TDictionary<integer, integer>.Create();;

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
        lbl_Etape.Caption := 'Etape 5 / 11';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := ListeArticle.Count;

        for IdArt in ListeArticle.Keys do
        begin
          // nettoyage du tampon !
          CouleurTampon.Clear();
          IdCouTampon := 999000000;

          for IdOldCou in ListeArticle[IdArt].Keys do
          begin
            // Nouvelle couleur !
            IdNewCou := ListeArticle[IdArt][IdOldCou];
            if IdNewCou = 0 then
              Raise Exception.Create('Couleur non fournis !!!');
            // Attention si la nouvelle couleur est aussi une ancienne
            // il faut passé par un tampon ...
            if ListeArticle[IdArt].ContainsKey(IdNewCou) then
            begin
              IdCouTampon := GetIdCouTampon(IdCouTampon);
              CouleurTampon.Add(IdCouTampon, IdNewCou);
              IdNewCou := IdCouTampon;
            end;

            // tables de mouvements ...
            UpdateCouleurTable(Query, 'STI_MAGID', '', '', 'ARTIDEAL', '', 'STI_ARTID', 'STI_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'CDE_MAGID', 'COMBCDE', 'CDE_ID', 'COMBCDEL', 'CDL_CDEID', 'CDL_ARTID', 'CDL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'RET_MAGID', 'COMRETOUR', 'RET_ID', 'COMRETOURL', 'REL_RETID', 'REL_ARTID', 'REL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'CDV_MAGID', '', '', 'CONSODIV', '', 'CDV_ARTID', 'CDV_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'POS_MAGID', 'CSHTICKET join CSHSESSION on SES_ID = TKE_SESID join GENPOSTE on POS_ID = SES_POSID', 'TKE_ID', 'CSHTICKETL', 'TKL_TKEID', 'TKL_ARTID', 'TKL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'INV_MAGID', 'INVENTETE', 'INV_ID', 'INVENTETEL', 'INL_INVID', 'INL_ARTID', 'INL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'INF_MAGID', 'INVIMGSTKFISCAL', 'INF_ID', 'INVIMGSTKFISCALL', 'IFL_INFID', 'IFL_ARTID', 'IFL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'INV_MAGID', 'INVSESSION join INVENTETE on INV_ID = SAI_INVID', 'SAI_ID', 'INVSESSIONL', 'SAL_SAIID', 'SAL_ARTID', 'SAL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'BLE_MAGID', 'NEGBL', 'BLE_ID', 'NEGBLL', 'BLL_BLEID', 'BLL_ARTID', 'BLL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'DVE_MAGID', 'NEGDEVIS', 'DVE_ID', 'NEGDEVISL', 'DVL_DVEID', 'DVL_ARTID', 'DVL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'FCE_MAGID', 'NEGFACTURE', 'FCE_ID', 'NEGFACTUREL', 'FCL_FCEID', 'FCL_ARTID', 'FCL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'PCD_MAGID', '', '', 'PRECDE', '', 'PCD_ARTID', 'PCD_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'BLA_MAGID', 'RECAUTOP join RECAUTO on BLA_ID = BLP_BLAID', 'BLP_ID', 'RECAUTOL', 'LPA_BLPID', 'LPA_ARTID', 'LPA_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'BLA_MAGID', 'RECAUTO', 'BLA_ID', 'RECAUTOU', 'LPU_BLAID', 'LPU_ARTID', 'LPU_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'BRE_MAGID', 'RECBR', 'BRE_ID', 'RECBRL', 'BRL_BREID', 'BRL_ARTID', 'BRL_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'SAV_MAGID', 'SAVFICHEE', 'SAV_ID', 'SAVFICHEART', 'SAA_SAVID', 'SAA_ARTID', 'SAA_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'IMA_MAGOID', 'TRANSFERTIM', 'IMA_ID', 'TRANSFERTIMCONTROLE', 'IMC_IMAID', 'IMC_ARTID', 'IMC_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            UpdateCouleurTable(Query, 'IMA_MAGOID', 'TRANSFERTIM', 'IMA_ID', 'TRANSFERTIML', 'IML_IMAID', 'IML_ARTID', 'IML_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            // Tables d'agregats ...
            UpdateCouleurTable(Query, 'MVT_MAGID', '', '', 'AGRMOUVEMENT', '', 'MVT_ARTID', 'MVT_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);
            // Triggers differe !
            UpdateCouleurTable(Query, 'TRI_MAGID', '', '', 'GENTRIGGERDIFF', '', 'TRI_ARTID', 'TRI_COUID', StringMagasins, IdArt, IdOldCou, IdNewCou);

            Inc(Result.nbCouleurs);
            Application.ProcessMessages();
          end;

          for IdCouTampon in CouleurTampon.Keys do
          begin
            IdNewCou := CouleurTampon[IdCouTampon];

            // tables de mouvements ...
            UpdateCouleurTable(Query, 'STI_MAGID', '', '', 'ARTIDEAL', '', 'STI_ARTID', 'STI_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'CDE_MAGID', 'COMBCDE', 'CDE_ID', 'COMBCDEL', 'CDL_CDEID', 'CDL_ARTID', 'CDL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'RET_MAGID', 'COMRETOUR', 'RET_ID', 'COMRETOURL', 'REL_RETID', 'REL_ARTID', 'REL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'CDV_MAGID', '', '', 'CONSODIV', '', 'CDV_ARTID', 'CDV_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'POS_MAGID', 'CSHTICKET join CSHSESSION on SES_ID = TKE_SESID join GENPOSTE on POS_ID = SES_POSID', 'TKE_ID', 'CSHTICKETL', 'TKL_TKEID', 'TKL_ARTID', 'TKL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'INV_MAGID', 'INVENTETE', 'INV_ID', 'INVENTETEL', 'INL_INVID', 'INL_ARTID', 'INL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'INF_MAGID', 'INVIMGSTKFISCAL', 'INF_ID', 'INVIMGSTKFISCALL', 'IFL_INFID', 'IFL_ARTID', 'IFL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'INV_MAGID', 'INVSESSION join INVENTETE on INV_ID = SAI_INVID', 'SAI_ID', 'INVSESSIONL', 'SAL_SAIID', 'SAL_ARTID', 'SAL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'BLE_MAGID', 'NEGBL', 'BLE_ID', 'NEGBLL', 'BLL_BLEID', 'BLL_ARTID', 'BLL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'DVE_MAGID', 'NEGDEVIS', 'DVE_ID', 'NEGDEVISL', 'DVL_DVEID', 'DVL_ARTID', 'DVL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'FCE_MAGID', 'NEGFACTURE', 'FCE_ID', 'NEGFACTUREL', 'FCL_FCEID', 'FCL_ARTID', 'FCL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'PCD_MAGID', '', '', 'PRECDE', '', 'PCD_ARTID', 'PCD_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'BLA_MAGID', 'RECAUTOP join RECAUTO on BLA_ID = BLP_BLAID', 'BLP_ID', 'RECAUTOL', 'LPA_BLPID', 'LPA_ARTID', 'LPA_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'BLA_MAGID', 'RECAUTO', 'BLA_ID', 'RECAUTOU', 'LPU_BLAID', 'LPU_ARTID', 'LPU_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'BRE_MAGID', 'RECBR', 'BRE_ID', 'RECBRL', 'BRL_BREID', 'BRL_ARTID', 'BRL_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'SAV_MAGID', 'SAVFICHEE', 'SAV_ID', 'SAVFICHEART', 'SAA_SAVID', 'SAA_ARTID', 'SAA_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'IMA_MAGOID', 'TRANSFERTIM', 'IMA_ID', 'TRANSFERTIMCONTROLE', 'IMC_IMAID', 'IMC_ARTID', 'IMC_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            UpdateCouleurTable(Query, 'IMA_MAGOID', 'TRANSFERTIM', 'IMA_ID', 'TRANSFERTIML', 'IML_IMAID', 'IML_ARTID', 'IML_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            // Tables d'agregats ...
            UpdateCouleurTable(Query, 'MVT_MAGID', '', '', 'AGRMOUVEMENT', '', 'MVT_ARTID', 'MVT_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);
            // Triggers differe !
            UpdateCouleurTable(Query, 'TRI_MAGID', '', '', 'GENTRIGGERDIFF', '', 'TRI_ARTID', 'TRI_COUID', StringMagasins, IdArt, IdCouTampon, IdNewCou);

            Application.ProcessMessages();
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

function Tfrm_Main.ReactiveTrigger(FileBDD : string; ListeTriggers : TStringList) : boolean;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  TrigerName : string;
begin
  Result := false;

  if FileExists(FileBDD) then
  begin
    try
      Connexion := TFDConnection.Create(Self);
      Connexion.DriverName := 'IB';
      Connexion.Params.Clear();
      Connexion.Params.Add('Database=' + FileBDD);
      Connexion.Params.Add('User_Name=sysdba');
      Connexion.Params.Add('Password=masterkey');
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
        lbl_Etape.Caption := 'Etape 6 / 11';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := ListeTriggers.Count;

        // desactivation
        for TrigerName in ListeTriggers do
        begin
          Query.SQL.Text := 'alter trigger "' + TrigerName + '" active;';
          Query.ExecSQL();
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

function Tfrm_Main.RecalculeStockArticles(FileBDD : string; ListeArticle : TListArticles) : boolean;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  IdArt : integer;
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
        lbl_Etape.Caption := 'Etape 8 / 11';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := ListeArticle.Count;

        for IdArt in ListeArticle.Keys do
        begin
          Query.SQL.Text := 'execute procedure pr_trig_rec_stk(' + IntToStr(IdArt) + ');';
          Query.ExecSQL();
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

function Tfrm_Main.EnableDifferTrigger(FileBDD : string; enabled : boolean; etape : integer) : boolean;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
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
        lbl_Etape.Caption := 'Etape 8 / 11';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := 1;

        Query.SQL.Text := 'select retour from bn_only_pantin;';
        Query.Open();
        if not Query.Eof and (query.Fields[0].AsInteger = 0) then
        begin
          if enabled then
            Query.SQL.Text := 'SET GENERATOR GENTRIGGER TO 1'
          else
            Query.SQL.Text := 'SET GENERATOR GENTRIGGER TO 0';
          Query.ExecSQL();
        end;
        pb_Progress.StepIt();
        Application.ProcessMessages();

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

function Tfrm_Main.TraiteTRiggerDiffere(FileBDD : string; etape : integer) : boolean;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  nblig, ret : integer;
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

        // nombre d'enreg !
        try
          Query.SQL.Text := 'select count(*) as nb from gentriggerdiff;';
          QUery.Open();
          if Query.Eof then
            nblig := 0
          else
            nblig := Query.Fields[0].AsInteger
        finally
          Query.Close();
        end;

        // init progress bar !
        lbl_Etape.Caption := 'Etape ' + IntToStr(etape) + ' / 11';
        Application.ProcessMessages();
        pb_Progress.Position := 0;
        pb_Progress.Step := 1;
        pb_Progress.Max := Ceil(nblig / 200);

        // nouveau recalcul
        QUery.SQL.Text := 'execute procedure eai_trigger_pretraite;';
        Query.ExecSQL();
        // boucle de traitement
        ret := 1;
        while ret > 0 do
        begin
          Query.SQL.Text := 'select retour from eai_trigger_differe(200);';
          try
            Query.Open();
            if Query.Eof then
              Raise Exception.Create('Pas de retour de "eai_trigger_differe"')
            else
              ret := Query.FieldByName('retour').AsInteger;
          finally
            Query.Close();
          end;
          pb_Progress.StepIt();
          Application.ProcessMessages();
        end;

        Result := true;
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

procedure Tfrm_Main.DoBackup();
var
  Reg : TRegistry;
  RepGinkoia, error : string;
begin
  // recherche du repertoire Ginkoia, Base0 !!
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Algol\Ginkoia\') then
    begin
      if not (Trim(Reg.ReadString('Base0')) = '') then
        RepGinkoia := ExtractFilePath(ExtractFileDir(Reg.ReadString('Base0')));
    end;
  finally
    FreeAndNil(Reg);
  end;

  if FileExists(RepGinkoia + 'BackRest.exe') then
  begin
    ExecAndWaitProcess(error, RepGinkoia + 'BackRest.exe', 'AUTO');
  end;
end;

// traitement automatique

procedure Tfrm_Main.MessageTrtAuto(var msg : TWMDropFiles);
var
  error : string;
begin
  if btn_Traitement.Enabled then
  begin
    Traitement(error);
    mmo_Resultat.Lines.SaveToFile(ChangeFileExt(ParamStr(0), '.log'));
    btn_CloseClick(nil);
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
        edt_Articles.Text := Fichier;
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

    lbl_OldMagasins.Enabled := Enabled;
    lst_OldMagasins.Enabled := Enabled;
    btn_MoveRight.Enabled := Enabled;
    btn_MoveLeft.Enabled := Enabled;
    lbl_NewMagasins.Enabled := Enabled;
    lst_NewMagasins.Enabled := Enabled;

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

  lst_OldMagasins.Items.Clear();
  lst_NewMagasins.Items.Clear();

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
            if Pos(Query.FieldByName('mag_id').AsString, FListIdMags) > 0 then
              lst_NewMagasins.AddItem(Query.FieldByName('mag_enseigne').AsString, Pointer(Query.FieldByName('mag_id').AsInteger))
            else
              lst_OldMagasins.AddItem(Query.FieldByName('mag_enseigne').AsString, Pointer(Query.FieldByName('mag_id').AsInteger));
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

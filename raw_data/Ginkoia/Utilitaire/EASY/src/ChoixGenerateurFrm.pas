unit ChoixGenerateurFrm;

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
  Vcl.StdCtrls;

type
  TFrm_ChoixGenerateur = class(TForm)
    Btn_Cancel: TButton;
    Btn_Valider: TButton;
    Chk_MagAssociate: TCheckBox;
    Lab_Magasin: TLabel;
    cbx_ChoixGenerateur: TComboBox;
    Btn_BasePantin: TButton;

    procedure FormCreate(Sender: TObject);
    procedure Chk_MagAssociateClick(Sender: TObject);
    procedure cbx_ChoixGenerateurChange(Sender: TObject);
  private
    { Déclarations privées }
    FServeur, FFileBase, FLogin, FPassword : string;
    FPort : integer;
    FBasePantin : integer;
    FMagID : integer;
    FIdent : integer;

    procedure SetServeur(Value : string);
    procedure SetFileBase(Value : string);
    procedure SetPort(Value : integer);
    procedure SetLogin(Value : string);
    procedure SetPassword(Value : string);
    procedure SetIdent(Value : integer);
    procedure SetMagID(Value : integer);
    function GetSelectedGenerateur() : integer;

    procedure LoadDatas();
  public
    { Déclarations publiques }
    property Serveur : string read FServeur write SetServeur;
    property FileBase : string read FFileBase write SetFileBase;
    property Port : integer read FPort write SetPort;
    property Login : string read FLogin write SetLogin;
    property Password : string read FPassword write SetPassword;

    property Ident : integer read FIdent write SetIdent;
    property MagID : integer read FMagID write SetMagID;

    property SelectedGenerateur : integer read GetSelectedGenerateur;
    property BasePantin : integer read FBasePantin;
  end;

function ChoixGenerateur(ParentFrm : TForm; Serveur, FileBase : string; Port : integer; MagID : integer; var IdentBase : integer) : boolean; overload;
function ChoixGenerateur(ParentFrm : TForm; Serveur, FileBase : string; Port : integer; Login, Password : string; MagID : integer; var IdentBase : integer) : boolean; overload;

implementation

uses
  System.Math,
  uGestionBDD;

{$R *.dfm}

function ChoixGenerateur(ParentFrm : TForm; Serveur, FileBase : string; Port : integer; MagID : integer; var IdentBase : integer) : boolean;
begin
  Result := ChoixGenerateur(ParentFrm, Serveur, FileBase, Port, CST_BASE_LOGIN, CST_BASE_PASSWORD, MagID, IdentBase)
end;

function ChoixGenerateur(ParentFrm : TForm; Serveur, FileBase : string; Port : integer; Login, Password : string; MagID : integer; var IdentBase : integer) : boolean;
var
  Fiche : TFrm_ChoixGenerateur;
  Ret : integer;
begin
  Result := false;
  try
    Fiche := TFrm_ChoixGenerateur.Create(ParentFrm);
    Fiche.Serveur := Serveur;
    Fiche.FileBase := FileBase;
    Fiche.Port := Port;
    Fiche.Login := Login;
    Fiche.Password := Password;
    Fiche.Ident := IdentBase;
    Fiche.MagID := MagID;

    Ret := Fiche.ShowModal();
    if Ret in [mrOK, mrYes] then
    begin
      Result := true;
      case Ret of
        mrOK : IdentBase := Fiche.SelectedGenerateur;
        mrYes : IdentBase := Fiche.BasePantin;
      end;
    end;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ TFrm_ChoixGenerateur }

procedure TFrm_ChoixGenerateur.FormCreate(Sender: TObject);
begin
  FServeur := '';
  FFileBase := '';
  FPort := 0;
  FLogin := '';
  FPassword := '';
  FBasePantin := 0;
  FIdent := 0;
  FMagID := 0;
end;

procedure TFrm_ChoixGenerateur.Chk_MagAssociateClick(Sender: TObject);
begin
  if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '') or (FMagID = 0)) then
    LoadDatas();
end;

procedure TFrm_ChoixGenerateur.cbx_ChoixGenerateurChange(Sender: TObject);
begin
  Btn_Valider.Enabled := (cbx_ChoixGenerateur.ItemIndex >= 0);
end;

procedure TFrm_ChoixGenerateur.SetServeur(Value : string);
begin
  if not (FServeur = Value) then
  begin
    FServeur := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

procedure TFrm_ChoixGenerateur.SetFileBase(Value : string);
begin
  if (not (FFileBase = Value)) then
  begin
    FFileBase := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

procedure TFrm_ChoixGenerateur.SetPort(Value : integer);
begin
  if not (FPort = Value) then
  begin
    FPort := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

procedure TFrm_ChoixGenerateur.SetLogin(Value : string);
begin
  if not (FLogin = Value) then
  begin
    FLogin := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

procedure TFrm_ChoixGenerateur.SetPassword(Value : string);
begin
  if not (FPassword = Value) then
  begin
    FPassword := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

procedure TFrm_ChoixGenerateur.SetIdent(Value : integer);
begin
  if not (FIdent = Value) then
  begin
    FIdent := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

procedure TFrm_ChoixGenerateur.SetMagID(Value : integer);
begin
  if not (FMagID = Value) then
  begin
    Chk_MagAssociate.Enabled := (FMagID > 0);
    Chk_MagAssociate.Checked := (FMagID > 0);

    FMagID := Value;
    if not ((FServeur = '') or (FFileBase = '') or (FPort = 0) or (FLogin = '') or (FPassword = '')) then
      LoadDatas();
  end;
end;

function TFrm_ChoixGenerateur.GetSelectedGenerateur() : integer;
begin
  if cbx_ChoixGenerateur.ItemIndex < 0 then
    Result := -1
  else
    Result := Integer(Pointer(cbx_ChoixGenerateur.Items.Objects[cbx_ChoixGenerateur.ItemIndex]));
end;

procedure TFrm_ChoixGenerateur.LoadDatas();
var
  Connexion : TMyConnection;
  Query : TMyQuery;
  i : integer;
begin
  cbx_ChoixGenerateur.Items.Clear();
  
  try
    Connexion := GetNewConnexion(FServeur, FFileBase, FLogin, FPassword, FPort);
    Query := GetNewQuery(Connexion);

    // recup du nom du magasin
    Query.SQL.Text := 'select mag_enseigne from genmagasin join k on k_id = mag_id and k_enabled = 1 where mag_id = ' + IntToStr(FMagID) + ';';
    try
      Query.Open();
      if Query.Eof then
        Lab_Magasin.Caption := '???'
      else
        Lab_Magasin.Caption := Query.FieldByName('mag_enseigne').AsString;
    finally
      Query.Close();
    end;

    // recup de l'ID base pantin
    Query.SQL.Text := 'select bas_ident from genbases join k on k_id = bas_id and k_enabled = 1 where bas_id != 0 and bas_ident = ''0'';';
    try
      Query.Open();
      if not Query.Eof then
        FBasePantin := Query.FieldByName('bas_ident').AsInteger;
    finally
      Query.Close();
    end;

    // Liste des autres ID de base
    try
      // recherche de bas_ident !
      if Chk_MagAssociate.Checked then
      begin
        Query.SQL.Text := 'select bas_ident, bas_nom '
                        + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                        + 'where bas_id != 0 and bas_ident != ''0'' and bas_magid = '
                        + IntToStr(FMagID) + ' '
                        + 'order by bas_ident;';
        Query.Open();

        if Query.RecordCount = 0 then
        begin
          Query.Close();
          Query.SQL.Text := 'select bas_ident, bas_nom '
                          + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                          + 'join genmagasin join k on k_id = mag_id and k_enabled = 1 on bas_nom like ''%'' || mag_ident || ''%'' '
                          + 'where bas_id != 0 and bas_ident != ''0'' and mag_id = '
                          + IntToStr(FMagID) + ' '
                          + 'order by bas_ident;';
          Query.Open();
        end;
      end;

      // pas de resultat ?
      if Query.RecordCount = 0 then
      begin
        Query.Close();
        Query.SQL.Text := 'select bas_ident, bas_nom '
                        + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                        + 'where bas_id != 0 and bas_ident != ''0'' '
                        + 'order by bas_ident;';
        Query.Open();
      end;

      // affichage !
      while not Query.Eof do
      begin
        cbx_ChoixGenerateur.AddItem(Query.FieldByName('bas_nom').AsString + ' (' + Query.FieldByName('bas_ident').AsString + ')', Pointer(Query.FieldByName('bas_ident').AsInteger));
        Query.Next();
      end;
    finally
      Query.Close();
    end;

    // selection ?
    if cbx_ChoixGenerateur.Items.Count > 0 then
    begin
      if FIdent <> 0 then
        cbx_ChoixGenerateur.ItemIndex := Max(0, cbx_ChoixGenerateur.Items.IndexOfObject(Pointer(FIdent)))
      else
        cbx_ChoixGenerateur.ItemIndex := 0;
    end;
    cbx_ChoixGenerateurChange(nil);
  finally
    FreeAndNil(Query);
    FReeAndNil(Connexion);
  end;
end;

end.

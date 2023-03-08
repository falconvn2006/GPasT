unit Paramlame_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellApi,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils,
  // Début Uses Perso
  ufunctions,
  uParams,
  IniFiles,
  uRessourcestr,
  UPatchDll,
  // Fin Uses Perso
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ImgList, Data.DB, Datasnap.DBClient, Xml.xmldom,
  Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, Vcl.Buttons, System.ImageList;

type
{$REGION 'Documentation'}
  /// <summary>
  /// Programme de paramétrage des URLs pour l'application de déploiement.
  /// </summary>
{$ENDREGION}
  TFrm_Paramlame = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    ImageList1: TImageList;

{$REGION 'Documentation'}
    /// <summary>
    /// Clientdataset utilisé par gérer le fichier XML.
    /// </summary>
{$ENDREGION}
    DSParam: TClientDataSet;
    GroupBox1: TGroupBox;
    edtTicket: TButtonedEdit;
    GroupBox3: TGroupBox;
    XMLDocParam: TXMLDocument;
    edtLocalfile: TButtonedEdit;
    OpenFileXP: TOpenDialog;
    Openfile: TFileOpenDialog;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    EdtMajISF: TButtonedEdit;
    Cbx_LstISF: TComboBox;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    EdtMajGinkoia: TButtonedEdit;
    Cbx_LstGinkoia: TComboBox;
    grp_LancementExe: TGroupBox;
    btn_Verification: TBitBtn;
    btn_Patch5: TBitBtn;

{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Cet événement est utilisé pour les deux zones d'édition.
    /// </para>
    /// <para>
    /// Un bouton , à la droite de la zone d'édition devient visible si la
    /// longueure du texte dépasse 10 caractères. Ce bouton permet de
    /// tester la validité de l'Url saisie.
    /// </para>
    /// </summary>
    /// <remarks>
    /// Noter l'utilisation des string helpers
    /// </remarks>
{$ENDREGION}
    procedure edtLameChange(Sender: TObject);

{$REGION 'Documentation'}
    /// <summary>
    /// Lancement du navigateur par défaut pour tester la validité de la
    /// l'Url.
    /// </summary>
{$ENDREGION}
    procedure edtLameRightButtonClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

{$REGION 'Documentation'}
    /// <summary>
    /// A l'affichage de la fenêtre on crée dynamiquement le clientdataset.
    /// Si le fichier XML existe il est chargé.. Les zones d'édition
    /// recoivent alors le texte concerné décodé. Si non le fichier XML est
    /// créé par le clientdataset et les zones d'édition reçoivent les
    /// valeurs par défaut codées en dur.
    /// </summary>
{$ENDREGION}
    procedure FormShow(Sender: TObject);

{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// L'enregistrement des paramétres se fait dans un fichier XML placé
    /// dans le même répertoire que l'exe . Le fichir XML est nomé
    /// "Deploiement.xml"
    /// </para>
    /// <para>
    /// Les données sont encryptées dans le fichier.
    /// </para>
    /// <para>
    /// On enregistre le fichier que si  les deux champs sont renseignés.
    /// </para>
    /// </summary>
    /// <seealso cref="uFunctions|EnCryptDeCrypt">
    /// Fonction d'encryptage et de décryptage
    /// </seealso>
{$ENDREGION}
    procedure btnOkClick(Sender: TObject);

{$REGION 'Documentation'}
    /// <summary>
    /// On ferme le clientdataset qui sera sauvegardé dans le fichier XML
    /// </summary>
{$ENDREGION}
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtLocalfileRightButtonClick(Sender: TObject);
    procedure Cbx_LstISFChange(Sender: TObject);
    procedure Cbx_LstGinkoiaChange(Sender: TObject);
    procedure btn_Patch5Click(Sender: TObject);
    procedure btn_VerificationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ParamUnity: TransportParam;
    Function LoadXmlParam: Boolean;
    procedure GetLstLame;
    procedure GetInfoParam;
  end;

var
  Frm_Paramlame: TFrm_Paramlame;

implementation

{$R *.dfm}

procedure TFrm_Paramlame.btnCancelClick(Sender: TObject);
begin
  modalresult := mrCancel;
end;

procedure TFrm_Paramlame.btnOkClick(Sender: TObject);
Var
  IniParam: TIniFile;
  ValTicket, ValBaseTest: String;
begin
  try
    IniParam := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));

    ValTicket := IniParam.ReadString('TICKET', 'Ticket', '');
    ValBaseTest := IniParam.ReadString('BASE_TEST', 'BaseTest', '');

    if ((edtLocalfile.Text <> ValBaseTest) and (edtLocalfile.Text <> '')) then
      IniParam.WriteString('BASE_TEST', 'BaseTest', edtLocalfile.Text);

    if ((edtTicket.Text <> ValTicket) and (edtTicket.Text <> '')) then
      IniParam.WriteString('TICKET', 'Ticket', edtTicket.Text);

  finally
    IniParam.Free;
  end;

  modalresult := mrOk;
end;

procedure TFrm_Paramlame.btn_Patch5Click(Sender: TObject);
begin
  VerifDll(True);
end;

procedure TFrm_Paramlame.btn_VerificationClick(Sender: TObject);
begin
  LunchVerif;
end;

procedure TFrm_Paramlame.Cbx_LstGinkoiaChange(Sender: TObject);
Var
  iLstIndex: Integer;
  IniParam: TIniFile;
  Value: String;
begin
  // Call when I changed selection
  iLstIndex := Cbx_LstGinkoia.ItemIndex + 1;

  try
    IniParam := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));
    Value := IniParam.ReadString('LAME_GINKOIA', 'MAJ' + IntToStr(iLstIndex), '');
    EdtMajGinkoia.Text := EnCryptDeCrypt(Value);
  finally
    IniParam.Free;
  end;

end;

procedure TFrm_Paramlame.Cbx_LstISFChange(Sender: TObject);
Var
  iLstIndex: Integer;
  IniParam: TIniFile;
  Value: String;
begin
  // Call when I changed selection
  iLstIndex := Cbx_LstISF.ItemIndex + 1;

  try
    IniParam := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));
    Value := IniParam.ReadString('LAME_ISF', 'MAJ' + IntToStr(iLstIndex), '');
    EdtMajISF.Text := EnCryptDeCrypt(Value);
  finally
    IniParam.Free;
  end;

end;

procedure TFrm_Paramlame.edtLameChange(Sender: TObject);
var
  fs: string;
begin
  fs := TButtonedEdit(Sender).Text;
  if fs.Length > 0 then
  begin
    TButtonedEdit(Sender).RightButton.Visible := True;
    TButtonedEdit(Sender).Update;
  end
  else
  begin
    TButtonedEdit(Sender).RightButton.Visible := false;
    TButtonedEdit(Sender).Update;
  end;
end;

procedure TFrm_Paramlame.edtLameRightButtonClick(Sender: TObject);
var
  sUrl: string;
begin
  sUrl := TButtonedEdit(Sender).Text;
  if sUrl.IsEmpty = false then
  begin
    ShellExecute(handle, 'open', Pwchar(sUrl), nil, nil, SW_NORMAL);
  end;
end;

procedure TFrm_Paramlame.edtLocalfileRightButtonClick(Sender: TObject);
var
  sFilename, sFiletoInstall: String;
begin
  // Select a file
  if IsVistaOrHigher then
  begin
    Openfile.DefaultFolder := Tpath.GetTempPath;
    if Openfile.Execute then
    begin
      sFilename := Openfile.FileName;
      sFiletoInstall := sFilename;
    end;
  end
  else
  begin
    // xp
    OpenFileXP.InitialDir := Tpath.GetTempPath;
    if OpenFileXP.Execute then
      sFilename := OpenFileXP.FileName;
  end;
  edtLocalfile.Text := sFilename;
end;

procedure TFrm_Paramlame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DSParam.Close;
end;

procedure TFrm_Paramlame.FormCreate(Sender: TObject);
var
  sFile: string;
  FirsLunch: Boolean;
begin
  // mise en place pour sauter cette form pour l'utilisateur
  if not FileExists(IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(ParamStr(0))) + 'Deploiement.ini') then
    FirsLunch := True
  else
    FirsLunch := false;

  // on ne se sert plus du fichier INI
  ParamUnity.CreateIni(IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(ParamStr(0))) + 'Deploiement.ini');

  GetLstLame;
  GetInfoParam;

  GroupBox5.Visible := True;

  if ufunctions.UsrLogged = UsrISF then
  begin
    GroupBox5.Visible := false;
    if FirsLunch then
      VerifDll(false);
  end;

  if FirsLunch then
   btnOkClick(Sender);
end;

procedure TFrm_Paramlame.FormShow(Sender: TObject);
var
  sFile: string;
  FirsLunch: Boolean;
begin
  if not FileExists(IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(ParamStr(0))) + 'Deploiement.ini') then
    FirsLunch := True
  else
    FirsLunch := false;

  ParamUnity.CreateIni(IncludeTrailingPathDelimiter(Tpath.GetDirectoryName(ParamStr(0))) + 'Deploiement.ini');

  GetLstLame;
  GetInfoParam;

  GroupBox5.Visible := True;

  if ufunctions.UsrLogged = UsrISF then
  begin
    GroupBox5.Visible := false;
    if FirsLunch then
      VerifDll(false);
  end;
end;

procedure TFrm_Paramlame.GetInfoParam;
var
  IniParam: TIniFile;
  ValBaseTest, ValTicket: String;
begin
  // Use to get param's ini info

  try
    IniParam := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));
    ValTicket := IniParam.ReadString('TICKET', 'Ticket', '');
    ValBaseTest := IniParam.ReadString('BASE_TEST', 'BaseTest', '');

    edtTicket.Text := ValTicket;
    edtLocalfile.Text := ValBaseTest;
  finally
    IniParam.Free;
  end;
end;

procedure TFrm_Paramlame.GetLstLame;
Var
  IniParam: TIniFile;
  LstISF, LstGin: TStringList;
  iISF, iGINKOIA: Integer;
  I: Integer;
  ValueISF, ValueGinkoia: String;
begin
  // procedure use to get LAME lime from ini file
  try
    IniParam := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));
    LstISF := TStringList.Create;
    LstGin := TStringList.Create;

    IniParam.ReadSection('LAME_ISF', LstISF);
    IniParam.ReadSection('LAME_GINKOIA', LstGin);

    // Look over and fill the combobox lame ISF
    iISF := LstISF.Count;

    for I := 0 to iISF do
    begin
      ValueISF := IniParam.ReadString('LAME_ISF', 'SYMR' + IntToStr(I), '');
      if ValueISF <> '' then
        Cbx_LstISF.Items.Add(EnCryptDeCrypt(ValueISF));
    end;
    if (Cbx_LstISF.Items.Count > -1) then
    begin
      Cbx_LstISF.ItemIndex := 0;
      Cbx_LstISF.OnChange(Self);
    end;

    // Look over and fill Ginkoia Lst Lame
    iGINKOIA := LstGin.Count;

    for I := 0 to iGINKOIA do
    begin
      ValueGinkoia := IniParam.ReadString('LAME_GINKOIA', 'LAME' + IntToStr(I), '');
      if ValueGinkoia <> '' then
        Cbx_LstGinkoia.Items.Add(EnCryptDeCrypt(ValueGinkoia));
    end;
    if (Cbx_LstGinkoia.Items.Count > -1) then
    begin
      Cbx_LstGinkoia.ItemIndex := 0;
      Cbx_LstGinkoia.OnChange(Self);
    end;

  finally
    IniParam.Free;
    LstISF.Free;
    LstGin.Free;
  end;
end;

function TFrm_Paramlame.LoadXmlParam: Boolean;
begin
  // Fonction permettant de charger le contenu du fichier XML de paramétrage
  Result := false;
end;

end.

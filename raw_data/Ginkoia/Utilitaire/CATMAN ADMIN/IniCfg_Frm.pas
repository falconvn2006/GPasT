unit IniCfg_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, GinPanel, AdvGlowButton, ExtCtrls, RzPanel,
  AdvOfficePager, AdvOfficePagerStylers, StdCtrls, Spin, TypInfo, Mask, RzButton,
  RzRadChk, IniFiles, uToolsXE, ADODB, StdActns,
  {$REGION 'Doit toujours être positionner à la fin'}
  IniCfg_ClassSurcharge, RzRadGrp, AdvGroupBox, AdvOfficeButtons
  {$ENDREGION}
  ;

const
  MSSQLCONNETION = 'Provider=SQLOLEDB.1;Password=%s;Persist Security Info=%s;' +
                   'User ID=%s;Initial Catalog=%s;Data Source=%s;' +
                   'Use Procedure for Prepare=1;Auto Translate=%s;Packet Size=%d;' +
                   'Use Encryption for Data=%s;Tag with column collation when possible=False';
Type
  TIniCfg = record
    private
      FUseEncryption: Boolean;
      FServeurPacketSize: Integer;
      FServeurCatalog: string;
      FServeurPassWord: String;
      FServeurLogin: string;
      FServeurUrl: string;
      FServeurAutoTranslate: Boolean;
      FServeurPersistSecurity: Boolean;
      FServeurTestMode: Boolean;
      FAdoConnection: TAdoconnection;
      FAdoQuery: TADOQuery;
      FAdoBaseLocale: TAdoconnection;
      FAdoAddidasTSL: TAdoconnection;
      FAdoBaseTest: TAdoconnection;
      FMODE: Integer;
      FBTServeurPersistSecurity: Boolean;
      FBLServeurLogin: string;
      FBLServeurUrl: string;
      FBLServeurAutoTranslate: Boolean;
      FATServeurPersistSecurity: Boolean;
      FBTUseEncryption: Boolean;
      FATUseEncryption: Boolean;
      FBLServeurPersistSecurity: Boolean;
      FBLUseEncryption: Boolean;
      FBTServeurPacketSize: Integer;
      FBTServeurCatalog: string;
      FATServeurPacketSize: Integer;
      FATServeurCatalog: string;
      FBLServeurPacketSize: Integer;
      FBLServeurCatalog: string;
      FBTServeurPassWord: String;
      FBTServeurLogin: string;
      FBTServeurUrl: string;
      FATServeurPassWord: String;
      FBTServeurAutoTranslate: Boolean;
      FATServeurLogin: string;
      FATServeurUrl: string;
      FBLServeurPassWord: String;
      FATServeurAutoTranslate: Boolean;
    FCatalogDir: String;
    FSenderRSM: String;
      function GetMsSqlConnectionString: string;
    function GetMsSqlConnectionStringAT: String;
    function GetMsSqlConnectionStringBL: String;
    function GetMsSqlConnectionStringBT: String;

    public
      procedure LoadIni;
      procedure SaveIni;
      function ShowCfgInterface : TModalResult;

      // Paramétrage Serveur Réelle
      property ServeurUrl : string read FServeurUrl;
      property ServeurLogin : string read FServeurLogin;
      property ServeurPassWord : String read FServeurPassWord;
      property ServeurCatalog : string read FServeurCatalog;
      property ServeurPersistSecurity : Boolean read FServeurPersistSecurity;
      property ServeurAutoTranslate : Boolean read FServeurAutoTranslate;
      property ServeurPacketSize : Integer read FServeurPacketSize;
      property ServeurUseEncryption : Boolean read FUseEncryption;

      // Paramétrage Addidas TSL
      property ATServeurUrl : string read FATServeurUrl;
      property ATServeurLogin : string read FATServeurLogin;
      property ATServeurPassWord : String read FATServeurPassWord;
      property ATServeurCatalog : string read FATServeurCatalog;
      property ATServeurPersistSecurity : Boolean read FATServeurPersistSecurity;
      property ATServeurAutoTranslate : Boolean read FATServeurAutoTranslate;
      property ATServeurPacketSize : Integer read FATServeurPacketSize;
      property ATServeurUseEncryption : Boolean read FATUseEncryption;

      // Paramétrage Base Test
      property BTServeurUrl : string read FBTServeurUrl;
      property BTServeurLogin : string read FBTServeurLogin;
      property BTServeurPassWord : String read FBTServeurPassWord;
      property BTServeurCatalog : string read FBTServeurCatalog;
      property BTServeurPersistSecurity : Boolean read FBTServeurPersistSecurity;
      property BTServeurAutoTranslate : Boolean read FBTServeurAutoTranslate;
      property BTServeurPacketSize : Integer read FBTServeurPacketSize;
      property BTServeurUseEncryption : Boolean read FBTUseEncryption;

      // Paramétrage Base Locale
      property BLServeurUrl : string read FBLServeurUrl;
      property BLServeurLogin : string read FBLServeurLogin;
      property BLServeurPassWord : String read FBLServeurPassWord;
      property BLServeurCatalog : string read FBLServeurCatalog;
      property BLServeurPersistSecurity : Boolean read FBLServeurPersistSecurity;
      property BLServeurAutoTranslate : Boolean read FBLServeurAutoTranslate;
      property BLServeurPacketSize : Integer read FBLServeurPacketSize;
      property BLServeurUseEncryption : Boolean read FBLUseEncryption;

      property ServeurTestMode : Boolean read FServeurTestMode;

      property MsSqlConnectionString : string read GetMsSqlConnectionString;
      property MsSQLConnectionStringAT : String read GetMsSqlConnectionStringAT;
      property MsSQLConnectionStringBT : String read GetMsSqlConnectionStringBT;
      property MsSQLConnectionStringBL : String read GetMsSqlConnectionStringBL;

      // Connection et Query de test
      property AdoConnection : TAdoconnection read FAdoConnection write FAdoConnection;
      property AdoAddidasTSL : TAdoconnection read FAdoAddidasTSL write FAdoAddidasTSL;
      property AdoBaseTest : TAdoconnection read FAdoBaseTest write FAdoBaseTest;
      property AdoBaseLocale : TAdoconnection read FAdoBaseLocale write FAdoBaseLocale;
      property AdoQuery : TADOQuery read FAdoQuery write FAdoQuery;

      // Permet d'indiquer le mode de connexion
      property Mode : Integer read FMODE Write FMode;

      // permet la gestion du répertoire des catalogues
      property CatalogDir : String read FCatalogDir;
      // permet de configurer le Sender RSM
      property SenderRSM : String read FSenderRSM;

  end;

  Tfrm_IniCfg = class(TAlgolDialogForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AOO_Principale: TAdvOfficePagerOfficeStyler;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    GinPanel1: TGinPanel;
    Lab_URL: TLabel;
    Lab_Login: TLabel;
    Lab_PassWord: TLabel;
    Lab_Catalog: TLabel;
    Lab_PacketSize: TLabel;
    edtMSSQLUrl: TEdit;
    edtMSSQLLogin: TEdit;
    edtMSSQLPassword: TEdit;
    edtMSSQLCatalog: TEdit;
    Chp_PacketSize: TSpinEdit;
    BalloonHint1: TBalloonHint;
    Chk_PersistSecurity: TRzCheckBox;
    Chk_autotranslate: TRzCheckBox;
    Chk_UseEncryption: TRzCheckBox;
    nbt_ConnexionTest: TAdvGlowButton;
    AdvOfficePage1: TAdvOfficePage;
    Lab_Catalogue: TLabel;
    Lab_CLCatalogDir: TLabel;
    edt_CLCatalogDir: TEdit;
    AdvGlowButton3: TAdvGlowButton;
    Lab_CLRSM: TLabel;
    Lab_CLSENDER: TLabel;
    edt_CLRSM: TEdit;
    AdvGlowButton4: TAdvGlowButton;
    OD_Files: TOpenDialog;
    GRb_Mode: TRzRadioGroup;
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure nbt_ConnexionTestClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure GRb_ModeChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
  private
    function CheckData : Boolean;
    procedure LoadComposantInIni(AIndex : Integer);
    procedure LoadIniIncomposant(AIndex : Integer);

    procedure ComponentConfiguration;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

  var
    IniCfg : TIniCfg;

implementation

{$R *.dfm}

procedure Tfrm_IniCfg.AdvGlowButton1Click(Sender: TObject);
begin
  if CheckData then
    ModalResult := mrOk;
end;

procedure Tfrm_IniCfg.AdvGlowButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_IniCfg.AdvGlowButton3Click(Sender: TObject);
var
  BFF : TBrowseForFolder;
begin
  BFF := TBrowseForFolder.Create(Self);
  Try
    BFF.DialogCaption := 'Sélectionner un répertoire pour les catalogues';
    BFF.BrowseOptions := [bifBrowseIncludeURLS, bifNoNewFolderButton, bifUseNewUI];
    if BFF.Execute then
      edt_CLCatalogDir.Text := BFF.Folder;
  Finally
    BFF.Free;
  End;
end;

procedure Tfrm_IniCfg.AdvGlowButton4Click(Sender: TObject);
begin
  if OD_Files.Execute then
    edt_CLRSM.Text := OD_Files.FileName;

end;

procedure Tfrm_IniCfg.AlgolDialogFormCreate(Sender: TObject);
begin
  AdvOfficePager1.ActivePageIndex := 0;

  GRb_Mode.ItemIndex := IniCfg.Mode;

  ComponentConfiguration;
end;

function Tfrm_IniCfg.CheckData: Boolean;
var
  ObjInfo : PPropInfo;
  OnError : Boolean;
  i: Integer;
  ComponentToFocus : TComponent;
  ParentPageControl : TWinControl;
begin
  OnError := False;
  ComponentToFocus := nil;

  // Initialisation des composants ayant la propriété IsState
  InitComposantState(Self,clWhite,clBlack);

  // Vérification de l'état des composants ayant IsState comme propriété
  OnError := SetComposantStateError(Self,clRed,clWhite, ComponentToFocus);

  // Affichage du message d'erreur + focus sur le premier élément en erreur
  if OnError then
  begin
    if ComponentToFocus <> nil then
    begin
      ParentPageControl := TWinControl(ComponentToFocus).Parent;
      while not(ParentPageControl is TAdvOfficePage) do
        ParentPageControl := ParentPageControl.Parent;

     AdvOfficePager1.ActivePage := TAdvOfficePage(ParentPageControl);

     FocusControl(TWinControl(ComponentToFocus));
    end;
   ShowMessage('Vous n''avez pas rempli tous les champs correctement (champs en rouge)');
  end;

  Result := not OnError;
end;

procedure Tfrm_IniCfg.ComponentConfiguration;
begin
  edtMSSQLUrl.IsConfiguration         := csObligatoire;
  edtMSSQLLogin.IsConfiguration       := csObligatoire;
  edtMSSQLPassword.IsConfiguration    := csObligatoire;
  edtMSSQLCatalog.IsConfiguration     := csObligatoire;
  Chp_PacketSize.IsConfiguration      := csObligatoire;

  edt_CLCatalogDir.IsConfiguration    := csObligatoire;
  edt_CLRSM.IsConfiguration           := csNormal;
end;

procedure Tfrm_IniCfg.GRb_ModeChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
  if CheckData then
  begin
    LoadComposantInIni(IniCfg.Mode);
    LoadIniIncomposant(NewIndex);
    IniCfg.Mode := NewIndex;
  end
  else
    AllowChange := False;
end;

procedure Tfrm_IniCfg.LoadComposantInIni(AIndex : Integer);
begin
  With IniCfg do
  begin
    case AIndex of
      0: begin // Addidas TSL
        FATServeurUrl             := edtMSSQLUrl.Text;
        FATServeurLogin           := edtMSSQLLogin.Text;
        FATServeurPassWord        := edtMSSQLPassword.Text;
        FATServeurCatalog         := edtMSSQLCatalog.Text;
        FATServeurPersistSecurity := Chk_PersistSecurity.Checked;
        FATServeurAutoTranslate   := Chk_AutoTranslate.Checked;
        FATUseEncryption          := Chk_UseEncryption.Checked;
        FATServeurPacketSize      := Chp_PacketSize.Value;
      end;
      1: begin // Base Test
        FBTServeurUrl             := edtMSSQLUrl.Text;
        FBTServeurLogin           := edtMSSQLLogin.Text;
        FBTServeurPassWord        := edtMSSQLPassword.Text;
        FBTServeurCatalog         := edtMSSQLCatalog.Text;
        FBTServeurPersistSecurity := Chk_PersistSecurity.Checked;
        FBTServeurAutoTranslate   := Chk_AutoTranslate.Checked;
        FBTUseEncryption          := Chk_UseEncryption.Checked;
        FBTServeurPacketSize      := Chp_PacketSize.Value;
      end;
      2: begin  // Base Locale
        FBLServeurUrl             := edtMSSQLUrl.Text;
        FBLServeurLogin           := edtMSSQLLogin.Text;
        FBLServeurPassWord        := edtMSSQLPassword.Text;
        FBLServeurCatalog         := edtMSSQLCatalog.Text;
        FBLServeurPersistSecurity := Chk_PersistSecurity.Checked;
        FBLServeurAutoTranslate   := Chk_AutoTranslate.Checked;
        FBLUseEncryption          := Chk_UseEncryption.Checked;
        FBLServeurPacketSize      := Chp_PacketSize.Value;
      end;
      3: begin // Base réelle
        FServeurUrl             := edtMSSQLUrl.Text;
        FServeurLogin           := edtMSSQLLogin.Text;
        FServeurPassWord        := edtMSSQLPassword.Text;
        FServeurCatalog         := edtMSSQLCatalog.Text;
        FServeurPersistSecurity := Chk_PersistSecurity.Checked;
        FServeurAutoTranslate   := Chk_AutoTranslate.Checked;
        FUseEncryption          := Chk_UseEncryption.Checked;
        FServeurPacketSize      := Chp_PacketSize.Value;
      end;
    end; // case

    FCatalogDir := edt_CLCatalogDir.Text;
    FSenderRSM  := edt_CLRSM.Text;
  end;

end;

procedure Tfrm_IniCfg.LoadIniIncomposant(AIndex : Integer);
begin
With IniCfg do
  begin
    case AIndex of
      0: begin // Addidas TSL
        edtMSSQLUrl.Text            := FATServeurUrl;
        edtMSSQLLogin.Text          := FATServeurLogin;
        edtMSSQLPassword.Text       := FATServeurPassWord;
        edtMSSQLCatalog.Text        := FATServeurCatalog;
        Chk_PersistSecurity.Checked := FATServeurPersistSecurity;
        Chk_AutoTranslate.Checked   := FATServeurAutoTranslate;
        Chk_UseEncryption.Checked   := FATUseEncryption;
        Chp_PacketSize.Value        := FATServeurPacketSize;
      end;
      1: begin // Base Test
        edtMSSQLUrl.Text            := FBTServeurUrl;
        edtMSSQLLogin.Text          := FBTServeurLogin;
        edtMSSQLPassword.Text       := FBTServeurPassWord;
        edtMSSQLCatalog.Text        := FBTServeurCatalog;
        Chk_PersistSecurity.Checked := FBTServeurPersistSecurity;
        Chk_AutoTranslate.Checked   := FBTServeurAutoTranslate;
        Chk_UseEncryption.Checked   := FBTUseEncryption;
        Chp_PacketSize.Value        := FBTServeurPacketSize;
      end;
      2: begin  // Base Locale
        edtMSSQLUrl.Text            := FBLServeurUrl;
        edtMSSQLLogin.Text          := FBLServeurLogin;
        edtMSSQLPassword.Text       := FBLServeurPassWord;
        edtMSSQLCatalog.Text        := FBLServeurCatalog;
        Chk_PersistSecurity.Checked := FBLServeurPersistSecurity;
        Chk_AutoTranslate.Checked   := FBLServeurAutoTranslate;
        Chk_UseEncryption.Checked   := FBLUseEncryption;
        Chp_PacketSize.Value        := FBLServeurPacketSize;
      end;
      3: begin // Base réelle
        edtMSSQLUrl.Text            := FServeurUrl;
        edtMSSQLLogin.Text          := FServeurLogin;
        edtMSSQLPassword.Text       := FServeurPassWord;
        edtMSSQLCatalog.Text        := FServeurCatalog;
        Chk_PersistSecurity.Checked := FServeurPersistSecurity;
        Chk_AutoTranslate.Checked   := FServeurAutoTranslate;
        Chk_UseEncryption.Checked   := FUseEncryption;
        Chp_PacketSize.Value        := FServeurPacketSize;
      end;
    end; // case

    edt_CLCatalogDir.Text := FCatalogDir;
    edt_CLRSM.Text        := FSenderRSM;
  end;
end;

procedure Tfrm_IniCfg.nbt_ConnexionTestClick(Sender: TObject);
var
  AdoCo : TADOConnection;
  AdoCT : String;
begin
  case IniCfg.Mode of
    0: begin
      AdoCo := IniCfg.AdoAddidasTSL;
      AdoCT := IniCfg.MsSQLConnectionStringAT;
    end;
    1: begin
      AdoCo := IniCfg.AdoBaseTest;
      AdoCT := IniCfg.MsSQLConnectionStringBT;
    end;
    2: begin
      AdoCo := IniCfg.AdoBaseLocale;
      AdoCT := IniCfg.MsSQLConnectionStringBL;
    end;
    3: begin
      AdoCo := IniCfg.AdoConnection;
      AdoCT := Inicfg.MsSqlConnectionString;
    end;
  end;

  if AdoCo <> nil then
  begin
    LoadComposantInIni(IniCfg.Mode);
    AdoCo.Close;
    AdoCo.ConnectionString := AdoCT;
    try
      AdoCo.Open;
      ShowMessage('Connexion réussit');
    Except on E: Exception do
      ShowMessage('Erreur de connexion : ' + E.Message);
    End;
  end
  else
    Showmessage('Pas de composant disponible');
end;

{ TIniCfg }

function TIniCfg.GetMsSqlConnectionString: string;
begin
  Result := Format(MSSQLCONNETION,[FServeurPassWord,
                                   BoolToStr(FServeurPersistSecurity,True),
                                   FServeurLogin,
                                   FServeurCatalog,
                                   FServeurUrl,
                                   BoolToStr(FServeurAutoTranslate,True),
                                   FServeurPacketSize,
                                   BoolToStr(FUseEncryption,True)]);
end;

function TIniCfg.GetMsSqlConnectionStringAT: String;
begin
  Result := Format(MSSQLCONNETION,[FATServeurPassWord,
                                   BoolToStr(FATServeurPersistSecurity,True),
                                   FATServeurLogin,
                                   FATServeurCatalog,
                                   FATServeurUrl,
                                   BoolToStr(FATServeurAutoTranslate,True),
                                   FATServeurPacketSize,
                                   BoolToStr(FATUseEncryption,True)]);

end;

function TIniCfg.GetMsSqlConnectionStringBL: String;
begin
  Result := Format(MSSQLCONNETION,[FBLServeurPassWord,
                                   BoolToStr(FBLServeurPersistSecurity,True),
                                   FBLServeurLogin,
                                   FBLServeurCatalog,
                                   FBLServeurUrl,
                                   BoolToStr(FBLServeurAutoTranslate,True),
                                   FBLServeurPacketSize,
                                   BoolToStr(FBLUseEncryption,True)]);

end;

function TIniCfg.GetMsSqlConnectionStringBT: String;
begin
  Result := Format(MSSQLCONNETION,[FBTServeurPassWord,
                                   BoolToStr(FBTServeurPersistSecurity,True),
                                   FBTServeurLogin,
                                   FBTServeurCatalog,
                                   FBTServeurUrl,
                                   BoolToStr(FBTServeurAutoTranslate,True),
                                   FBTServeurPacketSize,
                                   BoolToStr(FBTUseEncryption,True)]);

end;

procedure TIniCfg.LoadIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    FMode := ReadInteger('SERVER','MODE',3);

    // Connexion Base Réelle
    FUseEncryption := ReadBool('MSSQL','ENCRYPTION',False);
    FServeurPacketSize := ReadInteger('MSSQL','PACKETSIZE',4096);
    FServeurCatalog := ReadString('MSSQL','CATALOG','');
    FServeurPassWord := DoUnCryptPass(ReadString('MSSQL','PASSWORD',''));
    FServeurLogin := ReadString('MSSQL','LOGIN','');
    FServeurUrl:= ReadString('MSSQL','URL','');
    FServeurAutoTranslate:= ReadBool('MSSQL','AUTOTRANSLATE',True);
    FServeurPersistSecurity:= ReadBool('MSSQL','PERSISTSECURITY',True);

    // Connexion Addidas TSL
    FATUseEncryption := ReadBool('MSSQL-AT','ENCRYPTION',False);
    FATServeurPacketSize := ReadInteger('MSSQL-AT','PACKETSIZE',4096);
    FATServeurCatalog := ReadString('MSSQL-AT','CATALOG','');
    FATServeurPassWord := DoUnCryptPass(ReadString('MSSQL-AT','PASSWORD',''));
    FATServeurLogin := ReadString('MSSQL-AT','LOGIN','');
    FATServeurUrl:= ReadString('MSSQL-AT','URL','');
    FATServeurAutoTranslate:= ReadBool('MSSQL-AT','AUTOTRANSLATE',True);
    FATServeurPersistSecurity:= ReadBool('MSSQL-AT','PERSISTSECURITY',True);

    // Connexion Base Test
    FBTUseEncryption := ReadBool('MSSQL-BT','ENCRYPTION',False);
    FBTServeurPacketSize := ReadInteger('MSSQL-BT','PACKETSIZE',4096);
    FBTServeurCatalog := ReadString('MSSQL-BT','CATALOG','');
    FBTServeurPassWord := DoUnCryptPass(ReadString('MSSQL-BT','PASSWORD',''));
    FBTServeurLogin := ReadString('MSSQL-BT','LOGIN','');
    FBTServeurUrl:= ReadString('MSSQL-BT','URL','');
    FBTServeurAutoTranslate:= ReadBool('MSSQL-BT','AUTOTRANSLATE',True);
    FBTServeurPersistSecurity:= ReadBool('MSSQL-BT','PERSISTSECURITY',True);

    // connexion Base Locale
    FBLUseEncryption := ReadBool('MSSQL-BL','ENCRYPTION',False);
    FBLServeurPacketSize := ReadInteger('MSSQL-BL','PACKETSIZE',4096);
    FBLServeurCatalog := ReadString('MSSQL-BL','CATALOG','');
    FBLServeurPassWord := DoUnCryptPass(ReadString('MSSQL-BL','PASSWORD',''));
    FBLServeurLogin := ReadString('MSSQL-BL','LOGIN','');
    FBLServeurUrl:= ReadString('MSSQL-BL','URL','');
    FBLServeurAutoTranslate:= ReadBool('MSSQL-BL','AUTOTRANSLATE',True);
    FBLServeurPersistSecurity:= ReadBool('MSSQL-BL','PERSISTSECURITY',True);

    FCatalogDir := ReadString('REP','CATA','');
    FSenderRSM  := ReadString('REP','RSM','');
  finally
    Free;
  end;
end;

procedure TIniCfg.SaveIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    WriteInteger('SERVER','MODE',FMode);

    // Connexion Base Réelle
    WriteBool('MSSQL','ENCRYPTION',FUseEncryption);
    WriteInteger('MSSQL','PACKETSIZE',FServeurPacketSize);
    WriteString('MSSQL','CATALOG',FServeurCatalog);
    WriteString('MSSQL','PASSWORD',DoCryptPass(FServeurPassWord));
    WriteString('MSSQL','LOGIN',FServeurLogin);
    WriteString('MSSQL','URL',FServeurUrl);
    WriteBool('MSSQL','AUTOTRANSLATE',FServeurAutoTranslate);
    WriteBool('MSSQL','PERSISTSECURITY',FServeurPersistSecurity);

    // Connexion Addidas TSL
    WriteBool('MSSQL-AT','ENCRYPTION',FATUseEncryption);
    WriteInteger('MSSQL-AT','PACKETSIZE',FATServeurPacketSize);
    WriteString('MSSQL-AT','CATALOG',FATServeurCatalog);
    WriteString('MSSQL-AT','PASSWORD',DoCryptPass(FATServeurPassWord));
    WriteString('MSSQL-AT','LOGIN',FATServeurLogin);
    WriteString('MSSQL-AT','URL',FATServeurUrl);
    WriteBool('MSSQL-AT','AUTOTRANSLATE',FATServeurAutoTranslate);
    WriteBool('MSSQL-AT','PERSISTSECURITY',FATServeurPersistSecurity);

    // Connexion Base Test
    WriteBool('MSSQL-BT','ENCRYPTION',FBTUseEncryption);
    WriteInteger('MSSQL-BT','PACKETSIZE',FBTServeurPacketSize);
    WriteString('MSSQL-BT','CATALOG',FBTServeurCatalog);
    WriteString('MSSQL-BT','PASSWORD',DoCryptPass(FBTServeurPassWord));
    WriteString('MSSQL-BT','LOGIN',FBTServeurLogin);
    WriteString('MSSQL-BT','URL',FBTServeurUrl);
    WriteBool('MSSQL-BT','AUTOTRANSLATE',FBTServeurAutoTranslate);
    WriteBool('MSSQL-BT','PERSISTSECURITY',FBTServeurPersistSecurity);

    // connexion Base Locale
    WriteBool('MSSQL-BL','ENCRYPTION',FBLUseEncryption);
    WriteInteger('MSSQL-BL','PACKETSIZE',FBLServeurPacketSize);
    WriteString('MSSQL-BL','CATALOG',FBLServeurCatalog);
    WriteString('MSSQL-BL','PASSWORD',DoCryptPass(FBLServeurPassWord));
    WriteString('MSSQL-BL','LOGIN',FBLServeurLogin);
    WriteString('MSSQL-BL','URL',FBLServeurUrl);
    WriteBool('MSSQL-BL','AUTOTRANSLATE',FBLServeurAutoTranslate);
    WriteBool('MSSQL-BL','PERSISTSECURITY',FBLServeurPersistSecurity);

    WriteString('REP','CATA',FCatalogDir);
    WriteString('REP','RSM',FSenderRSM);
  finally
    Free;
  end;
end;

function TIniCfg.ShowCfgInterface : TModalResult;
begin
  With Tfrm_IniCfg.Create(nil) do
  try
    LoadIni;
    LoadIniIncomposant(IniCfg.Mode);
    Result := ShowModal;
    if Result = mrOk then
    begin
      LoadComposantInIni(IniCfg.Mode);
      SaveIni;
    end
  finally
    Release;
  end;

end;
end.


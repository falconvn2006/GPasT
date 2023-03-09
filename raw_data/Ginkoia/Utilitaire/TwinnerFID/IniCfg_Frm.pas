unit IniCfg_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, GinPanel, AdvGlowButton, ExtCtrls, RzPanel,
  AdvOfficePager, AdvOfficePagerStylers, StdCtrls, Spin, TypInfo, Mask, RzButton,
  RzRadChk, IniFiles, uToolsXE, ADODB, GinkoiaStyle_Dm,
  {$REGION 'Doit toujours �tre positionner � la fin'}
  IniCfg_ClassSurcharge
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
      FFTPDir: String;
      FFTPPort: Integer;
      FFTPass: string;
      FProcStockee: string;
      FFTPHost: string;
      FFTPUSer: string;
      function GetMsSqlConnectionString: string;

    public
      procedure LoadIni(ALoadAll : Boolean = True);
      procedure SaveIni;
      function ShowCfgInterface : TModalResult;

      // Param�trage Serveur
      property ServeurUrl : string read FServeurUrl;
      property ServeurLogin : string read FServeurLogin;
      property ServeurPassWord : String read FServeurPassWord;
      property ServeurCatalog : string read FServeurCatalog;
      property ServeurPersistSecurity : Boolean read FServeurPersistSecurity;
      property ServeurAutoTranslate : Boolean read FServeurAutoTranslate;
      property ServeurPacketSize : Integer read FServeurPacketSize;
      property ServeurUseEncryption : Boolean read FUseEncryption;

      property ServeurTestMode : Boolean read FServeurTestMode;

      property MsSqlConnectionString : string read GetMsSqlConnectionString;

      // Connection et Query de test
      property AdoConnection : TAdoconnection read FAdoConnection write FAdoConnection;
      property AdoQuery : TADOQuery read FAdoQuery write FAdoQuery;

      // Param�tre du logiciel
      property ProcStockee : string read FProcStockee;
      property FTPHost : string read FFTPHost;
      property FTPUser : string read FFTPUSer;
      property FTPPass : string read FFTPass;
      property FTPPort : Integer read FFTPPort;
      property FTPDir : String read FFTPDir;

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
    chk_ServeurTest: TRzCheckBox;
    nbt_ConnexionTest: TAdvGlowButton;
    AdvOfficePage1: TAdvOfficePage;
    Lab_PLProcedureStockee: TLabel;
    edt_PLProcedureStockee: TEdit;
    Lab_PLFTPHost: TLabel;
    edt_PLFtpHost: TEdit;
    Lab_PLFTP: TLabel;
    Lab_PLOTHER: TLabel;
    Lab_PLUser: TLabel;
    edt_PLUsername: TEdit;
    Lab_PLPassword: TLabel;
    edt_PLPassWord: TEdit;
    Lab_PLDirectory: TLabel;
    edt_PLRepertoire: TEdit;
    Lab_PLFTPPort: TLabel;
    Chp_PLFTPPort: TSpinEdit;
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure chk_ServeurTestClick(Sender: TObject);
    procedure nbt_ConnexionTestClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
  private
    function CheckData : Boolean;
    procedure LoadComposantInIni;
    procedure LoadIniIncomposant;

    procedure ComponentConfiguration;

    { D�clarations priv�es }
  public
    { D�clarations publiques }
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

procedure Tfrm_IniCfg.AlgolDialogFormCreate(Sender: TObject);
var
  i : Integer;
begin
  for i := 1 to ComponentCount do
  begin
    if Components[i-1] is TAdvGlowButton then
      Dm_GinkoiaStyle.AppliqueStyleAdvGlowButton(TAdvGlowButton(Components[i-1]));
  end;

  AdvOfficePager1.ActivePageIndex := 0;
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

  // Initialisation des comopsants ayant la propri�t� IsState
  InitComposantState(Self,clWhite,clBlack);

   // V�rification de l'�tat des composants ayant IsState comme propri�t�
  OnError := SetComposantStateError(Self,clRed,clWhite, ComponentToFocus);

  // Affichage du message d'erreur + focus sur le premier �l�ment en erreur
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

procedure Tfrm_IniCfg.chk_ServeurTestClick(Sender: TObject);
begin
  With IniCfg do
  begin
    FServeurTestMode := TRzCheckBox(Sender).Checked;

    // Chargement des informations
    LoadIni(False);

    edtMSSQLUrl.Text := FServeurUrl;
    edtMSSQLLogin.Text := FServeurLogin;
    edtMSSQLPassword.Text := FServeurPassWord;
    edtMSSQLCatalog.Text := FServeurCatalog;
    Chk_PersistSecurity.Checked := FServeurPersistSecurity;
    Chk_AutoTranslate.Checked := FServeurAutoTranslate;
    Chk_UseEncryption.Checked := FUseEncryption;
    Chp_PacketSize.Value := FServeurPacketSize;
  end;
end;

procedure Tfrm_IniCfg.ComponentConfiguration;
begin
  edtMSSQLUrl.IsConfiguration         := csObligatoire;
  edtMSSQLLogin.IsConfiguration       := csObligatoire;
  edtMSSQLPassword.IsConfiguration    := csObligatoire;
  edtMSSQLCatalog.IsConfiguration     := csObligatoire;
  Chp_PacketSize.IsConfiguration      := csObligatoire;

  edt_PLProcedureStockee.IsConfiguration         := csObligatoire;
  edt_PLRepertoire.IsConfiguration         := csObligatoire;
  Chp_PLFTPPort.IsConfiguration         := csObligatoire;
  edt_PLPassWord.IsConfiguration         := csObligatoire;
  edt_PLFtpHost.IsConfiguration         := csObligatoire;
  edt_PLUsername.IsConfiguration         := csObligatoire;

end;

procedure Tfrm_IniCfg.LoadComposantInIni;
begin
  With IniCfg do
  begin
    FServeurUrl             := edtMSSQLUrl.Text;
    FServeurLogin           := edtMSSQLLogin.Text;
    FServeurPassWord        := edtMSSQLPassword.Text;
    FServeurCatalog         := edtMSSQLCatalog.Text;
    FServeurPersistSecurity := Chk_PersistSecurity.Checked;
    FServeurAutoTranslate   := Chk_AutoTranslate.Checked;
    FUseEncryption          := Chk_UseEncryption.Checked;
    FServeurPacketSize      := Chp_PacketSize.Value;

    FProcStockee := edt_PLProcedureStockee.Text;
    FFTPDir      := edt_PLRepertoire.Text;
    FFTPPort     := Chp_PLFTPPort.Value;
    FFTPass      := edt_PLPassWord.Text;
    FFTPHost     := edt_PLFtpHost.Text;
    FFTPUSer     := edt_PLUsername.Text;
  end;
end;

procedure Tfrm_IniCfg.LoadIniIncomposant;
begin
  With IniCfg do
  begin
    edtMSSQLUrl.Text            := FServeurUrl;
    edtMSSQLLogin.Text          := FServeurLogin;
    edtMSSQLPassword.Text       := FServeurPassWord;
    edtMSSQLCatalog.Text        := FServeurCatalog;
    Chk_PersistSecurity.Checked := FServeurPersistSecurity;
    Chk_AutoTranslate.Checked   := FServeurAutoTranslate;
    Chk_UseEncryption.Checked   := FUseEncryption;
    Chp_PacketSize.Value        := FServeurPacketSize;

    edt_PLProcedureStockee.Text := FProcStockee;
    edt_PLRepertoire.Text       :=      FFTPDir;
    Chp_PLFTPPort.Value         :=     FFTPPort;
    edt_PLPassWord.Text         :=      FFTPass;
    edt_PLFtpHost.Text          :=     FFTPHost;
    edt_PLUsername.Text         :=     FFTPUSer;


  end;
end;

procedure Tfrm_IniCfg.nbt_ConnexionTestClick(Sender: TObject);
begin
  if IniCfg.AdoConnection <> nil then
  begin
    LoadComposantInIni;
    IniCfg.AdoConnection.Close;
    IniCfg.AdoConnection.ConnectionString := IniCfg.GetMsSqlConnectionString;
    try
      IniCfg.AdoConnection.Open;
      ShowMessage('Connexion r�ussit');
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

procedure TIniCfg.LoadIni(ALoadAll : Boolean = True);
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    if ALoadAll then
    begin
      FServeurTestMode := ReadBool('DEBUG','TESTMODE',False);

      // Gestion du FTP
      FFTPHost := ReadString('FtpExtraction', 'Host', '');
      FFTPUSer := ReadString('FtpExtraction', 'User', '');
      FFTPass := ReadString('FtpExtraction', 'Pass', '');
      FFTPPort := ReadInteger('FtpExtraction', 'Port', 21);
      FFTPDir := ReadString('FtpExtraction', 'ReperFTP', '');

      // Autre
      FProcStockee := ReadString('Extraction', 'ProcStockee', '');
    end;

    if not FServeurTestMode then
    begin
      FUseEncryption          := ReadBool('MSSQL','ENCRYPTION',False);
      FServeurPacketSize      := ReadInteger('MSSQL','PACKETSIZE',4096);
      FServeurCatalog         := ReadString('MSSQL','CATALOG','');
      FServeurPassWord        := DoUnCryptPass(ReadString('MSSQL','PASSWORD',''));
      FServeurLogin           := ReadString('MSSQL','LOGIN','');
      FServeurUrl             := ReadString('MSSQL','URL','');
      FServeurAutoTranslate   := ReadBool('MSSQL','AUTOTRANSLATE',True);
      FServeurPersistSecurity := ReadBool('MSSQL','PERSISTSECURITY',True);
    end
    else begin
      FUseEncryption          := ReadBool('MSSQL-TEST','ENCRYPTION',False);
      FServeurPacketSize      := ReadInteger('MSSQL-TEST','PACKETSIZE',4096);
      FServeurCatalog         := ReadString('MSSQL-TEST','CATALOG','');
      FServeurPassWord        := DoUnCryptPass(ReadString('MSSQL-TEST','PASSWORD',''));
      FServeurLogin           := ReadString('MSSQL-TEST','LOGIN','');
      FServeurUrl             := ReadString('MSSQL-TEST','URL','');
      FServeurAutoTranslate   := ReadBool('MSSQL-TEST','AUTOTRANSLATE',True);
      FServeurPersistSecurity := ReadBool('MSSQL-TEST','PERSISTSECURITY',True);
    end;
  finally
    Free;
  end;
end;

procedure TIniCfg.SaveIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try

    WriteBool('DEBUG','TESTMODE',FServeurTestMode);

    // Gestion du FTP
    WriteString('FtpExtraction', 'Host', FFTPHost);
    WriteString('FtpExtraction', 'User', FFTPUSer);
    WriteString('FtpExtraction', 'Pass', FFTPass);
    WriteInteger('FtpExtraction', 'Port', FFTPPort);
    WriteString('FtpExtraction', 'ReperFTP', FFTPDir);

    // Autre
    WriteString('Extraction', 'ProcStockee', FProcStockee);

    if FServeurTestMode then
    begin
      WriteBool('MSSQL-TEST','ENCRYPTION',FUseEncryption);
      WriteInteger('MSSQL-TEST','PACKETSIZE',FServeurPacketSize);
      WriteString('MSSQL-TEST','CATALOG',FServeurCatalog);
      WriteString('MSSQL-TEST','PASSWORD',DoCryptPass(FServeurPassWord));
      WriteString('MSSQL-TEST','LOGIN',FServeurLogin);
      WriteString('MSSQL-TEST','URL',FServeurUrl);
      WriteBool('MSSQL-TEST','AUTOTRANSLATE',FServeurAutoTranslate);
      WriteBool('MSSQL-TEST','PERSISTSECURITY',FServeurPersistSecurity);
    end
    else begin
      WriteBool('MSSQL','ENCRYPTION',FUseEncryption);
      WriteInteger('MSSQL','PACKETSIZE',FServeurPacketSize);
      WriteString('MSSQL','CATALOG',FServeurCatalog);
      WriteString('MSSQL','PASSWORD',DoCryptPass(FServeurPassWord));
      WriteString('MSSQL','LOGIN',FServeurLogin);
      WriteString('MSSQL','URL',FServeurUrl);
      WriteBool('MSSQL','AUTOTRANSLATE',FServeurAutoTranslate);
      WriteBool('MSSQL','PERSISTSECURITY',FServeurPersistSecurity);
    end;
  finally
    Free;
  end;
end;

function TIniCfg.ShowCfgInterface : TModalResult;
begin
  With Tfrm_IniCfg.Create(nil) do
  try
    LoadIni;
    LoadIniIncomposant;
    Result := ShowModal;
    if Result = mrOk then
    begin
      LoadComposantInIni;
      SaveIni;
    end
  finally
    Release;
  end;

end;
end.

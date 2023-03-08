
unit NewDossierLame_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, UWMI, UCommun,
  ComObj, ActiveX, Math;

type
  TFrm_NewDossierLame = class(TForm)
    GroupBox1: TGroupBox;
    lbclient: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    teIBFile: TEdit;
    Button1: TButton;
    teNOMPOURNOUS: TEdit;
    teNODE: TEdit;
    teGUID: TEdit;
    teVersion: TEdit;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    BVALIDER: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    teNOM: TEdit;
    teDirectory: TEdit;
    tehttp: TEdit;
    tehttps: TEdit;
    tejmx: TEdit;
    teagent: TEdit;
    BHint: TBalloonHint;
    BCHANGENOM: TButton;
    procedure BVALIDERClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BCHANGENOMClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDB   : TDossierInfos;
    FEASY : TSymmetricDS;
    procedure MessageHint(AMessage: string; AControl: TControl);
    function Controle_Instance(): boolean;
    function Controle_DB(): Boolean;
    function RecupInfosDB():Boolean;
    { Déclarations privées }
  public
    property DB   : TDossierInfos read FDB     write FDB;   // obligé en Var
    property EASY : TSymmetricDS  read FEASY;
    { Déclarations publiques }
  end;

var
  Frm_NewDossierLame: TFrm_NewDossierLame;

implementation

{$R *.dfm}

USes uDataMod;

procedure TFrm_NewDossierLame.MessageHint(AMessage: string; AControl: TControl);
var
  Pt: TPoint;
begin
  BHint.Title := 'Attention';
  BHint.Style := bhsBalloon;
  BHint.Description := AMessage;
  Pt.X := AControl.Width div 2;
  Pt.Y := AControl.Height - 10;
  BHint.ShowHint(AControl.ClientToScreen(Pt));
end;

procedure TFrm_NewDossierLame.BVALIDERClick(Sender: TObject);
var  bsuccess: boolean;
     sMessage :string;
begin
  FEASY.Nom := teNom.Text;
  FEASY.Repertoire := teDirectory.Text;
  FEASY.http := StrToIntDef(tehttp.text, 0);
  FEASY.https := StrToIntDef(tehttps.text, 0);
  FEASY.jmx := StrToIntDef(tejmx.text, 0);
  FEASY.agent := StrToIntDef(teagent.text, 0);
  FEASY.server_java := true;
  FEASY.memory := 512;   // 2048;
  FEASY.IsLame := true;
  //
  if (FEASY.http-VGSE.EASY_PORTS>=CST_MAX_PORTS) then
    begin
       // pas plus de 2000 ports par lame
       sMessage := Format('Le Port %d n''est pas dans la plage réservée de la machine',[FEASY.http]);
       MessageDlg(sMessage, mtError, [mbOk], 0);
       ModalResult := mrNone;
       exit;
    end;
  if Controle_Instance() and Controle_DB() then
  begin
    ModalResult := mrOk;
  end;
end;

function TFrm_NewDossierLame.Controle_Instance(): boolean;
var
  i: integer;
begin
  result := true;
  i := 0;
  while ((result) and (i < Length(VGSYMDS))) do
  begin
    if VGSYMDS[i].ServiceName = FEASY.Nom then
    begin
      MessageHint('Ce nom est déjà pris', teNOM);
      result := false;
      exit;
    end;
    if ExcludeTrailingPathDelimiter(VGSYMDS[i].Directory) = ExcludeTrailingPathDelimiter(FEASY.Repertoire) then
    begin
      MessageHint('Ce répertoire est déjà occupé par une autre instance', teDirectory);
      result := false;
      exit;
    end;
    if VGSYMDS[i].http = FEASY.http then
    begin
      MessageHint('Ce Port est déjà occupé par une autre instance', tehttp);
      result := false;
      exit;
    end;
    inc(i);
  end;
end;

procedure TFrm_NewDossierLame.FormCreate(Sender: TObject);
var vmyhttp,vmyhttps:integer;
    vmyjmx:integer;
    vmyagent:Integer;
    i:Integer;
begin
    // 40000
    vmyhttp  := VGSE.EASY_PORTS + 5;
    vmyjmx   := VGSE.EASY_PORTS + 6;
    vmyhttps := VGSE.EASY_PORTS + 7;
    vmyagent := VGSE.EASY_PORTS + 8;
    i:=0;
    While i<length(VGSYMDS) do
      begin
         vmyhttp  := Math.max(vmyhttp,VGSYMDS[i].http);
         vmyhttps := Math.max(vmyhttps,VGSYMDS[i].https);
         vmyagent := Math.max(vmyagent,VGSYMDS[i].jmxagent);
         vmyjmx   := Math.max(vmyjmx,VGSYMDS[i].jmxhttp);
         Inc(i);
      end;
    tehttp.text      := IntToStr(vmyhttp  + 10);
    tehttps.text     := IntToStr(vmyhttps + 10);
    teAgent.text     := IntToStr(vmyagent + 10);
    tejmx.text       := IntToStr(vmyjmx   + 10);
end;

function TFrm_NewDossierLame.RecupInfosDB():Boolean;
var DB: TDossierInfos;
    i:integer;
    sMessage: string;
begin
    result := false;
    FDB.DatabaseFile := teIBFile.Text;
    for i := 0 to length(VGIB) - 1 do
    begin
      if FDB.DatabaseFile = VGIB[i].DatabaseFile then
      begin
        sMessage := 'Cette base de données est déjà associée à une Instance.' + #13 + #10 + 'Impossible de l''ajouter à nouveau.';
        MessageDlg(sMessage, mtError, [mbOk], 0);
        exit;
      end;
      if FDB.Nom = VGIB[i].Nom then
      begin
        sMessage := 'Ce nom est déjà associée à une Instance.' + #13 + #10 + 'Impossible d''utiliser ce même nom.';
        MessageDlg(sMessage, mtError, [mbOk], 0);
        exit;
      end;
    end;

    DB.init;
    DB.DatabaseFile:=teIBFile.Text;
    DataMod.Ouverture_IBFile(DB);
    teNOMPOURNOUS.Text:=DB.Nom;
    teNOMPOURNOUS.Refresh;
    teNODE.Text:=IntToStr(DB.BAS_IDENT);
    if DB.BAS_IDENT = 0
      then
        begin
          BCHANGENOM.Enabled := true;
          BVALIDER.Enabled   := true;
        end;

    teGUID.Text:=DB.BAS_GUID;
    teVersion.Text := DB.Version;
    // mTablesExclues.Text := DB.TablesExclues;
    teNOM.Text := Format('EASY_%s',[UpperCase(DB.Nom)]);  /// ATTENTION ici du coup ==> ENGINE.NAME=EASY_BAS_NOMPOURNOUS
//  teNOM.Text := UpperCase(DB.Nom);  /// ATTENTION ici du coup ==> ENGINE.NAME=EASY_BAS_NOMPOURNOUS
    teDirectory.Text := Format('%s%s\',[IncludeTrailingPathDelimiter(VGSE.EASY_PATHDIR),UpperCase(teNOM.Text)]);
    result := true;
end;


procedure TFrm_NewDossierLame.Button1Click(Sender: TObject);
var dlgopenFile:TOpenDialog;
begin
  // Ouvre un fichier de base de données
  dlgopenFile:=TOpenDialog.Create(self);
  try
    dlgOpenFile.InitialDir  := ExtractFileDir(teIBFile.Text);
    if dlgopenFile.Execute()
      then
          begin
              teIBFile.Text := dlgopenFile.FileName;
              If not(RecupInfosDB())
                then teIBFile.Text:='';
          end;
  finally
    dlgopenFile.Free;
  end;
end;

procedure TFrm_NewDossierLame.BCHANGENOMClick(Sender: TObject);
var value:string;
    i:integer;
    sMessage: string;
begin
  {
  FDB.DatabaseFile := teIBFile.Text;
  for i := 0 to length(VGIB) - 1 do
  begin
    if FDB.DatabaseFile = VGIB[i].DatabaseFile then
    begin
      sMessage := 'Cette base de données est déjà associée à une Instance.' + #13 + #10 + 'Impossible de l''ajouter à nouveau.';
      MessageDlg(sMessage, mtError, [mbOk], 0);
      exit;
    end;
    if FDB.Nom = VGIB[i].Nom then
    begin
      sMessage := 'Ce nom est déjà associée à une Instance.' + #13 + #10 + 'Impossible d''utiliser ce même nom.';
      MessageDlg(sMessage, mtError, [mbOk], 0);
      exit;
    end;
  end;
  }
  value := inputbox('Nouveau Nom', 'Nouveau Nom', '');
  if value<>''
    then
      begin
          Button1.Enabled:=false;
          BCHANGENOM.Enabled:=false;
          BVALIDER.Enabled:=false;
          DataMod.DeleteGenParamURL(teIBFile.Text);
//          DataMod.DROP_TRIGGERS_SYMDS(teIBFile.Text);
          DataMod.DROP_SYMDS(teIBFile.Text);
          DataMod.CLEAN_MAGCODE(teIBFile.Text);
          DataMod.SetNomPourNous(teIBFile.Text,value);
          RecupInfosDB;
          Button1.Enabled:=true;
          BCHANGENOM.Enabled:=true;
          BVALIDER.Enabled:=true;
      end;
end;

function TFrm_NewDossierLame.Controle_DB(): Boolean;
var sMessage: string;
    i: integer;
begin
  result:= false;
  if (teIBFile.Text = '') then
  begin
    MessageHint('Veuillez choisir une base de donnéees.', teIBFile);
    exit;
  end;
  if (teNOM.Text = '') then
  begin
    MessageHint('Veuillez choisir une nom pour le noeud maitre.', teNOM);
    exit;
  end;

  if (teNode.Text <> '0') then
  begin
    MessageHint('Ce n''est pas la base zéro !', teNode);
    exit;
  end;

  FDB.init;
  FDB.ServiceName := FEASY.Nom;
  FDB.DatabaseFile := teIBFile.Text;
  FDB.Nom := teNOM.Text;
  FDB.SymDir   := teDirectory.Text;
  FDB.Version  := teVersion.Text;
  FDB.httpport := StrToInt(tehttp.Text);
  for i := 0 to length(VGIB) - 1 do
  begin
    if FDB.DatabaseFile = VGIB[i].DatabaseFile then
    begin
      sMessage := 'Cette base de données est déjà associée à une Instance.' + #13 + #10 + 'Impossible de l''ajouter à nouveau.';
      MessageDlg(sMessage, mtError, [mbOk], 0);
      exit;
    end;
    if FDB.Nom = VGIB[i].Nom then
    begin
      sMessage := 'Ce nom est déjà associée à une Instance.' + #13 + #10 + 'Impossible d''utiliser ce même nom.';
      MessageDlg(sMessage, mtError, [mbOk], 0);
      exit;
    end;
  end;
  result :=true;
end;

end.



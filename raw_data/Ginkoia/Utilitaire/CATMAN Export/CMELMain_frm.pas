unit CMELMain_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CMELMain_DM, StrUtils, StdCtrls, LMDCustomButton, LMDButton,
  ComCtrls, ExtCtrls, Buttons, DateUtils, IniFiles,  uHeaderCsv, 
  uExportStock, uExportVentes,uExportCommandes, uDefs, CMELParam_frm, DB,
  DBCtrls;

type
  TFrm_CMELMain = class(TForm)
    mmLogs: TMemo;
    Pan_Top: TPanel;
    Rgr_Choix: TRadioGroup;
    Nbt_Export: TLMDButton;
    Gbx_Progression: TGroupBox;
    Lab_Clients: TLabel;
    pbClient: TProgressBar;
    Lab_Articles: TLabel;
    pbArticle: TProgressBar;
    Nbt_Param: TLMDButton;
    Chk_Debug: TCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Ds_MagLevis: TDataSource;
    Nbt_Compare: TBitBtn;
    Tim_Traitement: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_ExportClick(Sender: TObject);
    procedure Nbt_ParamClick(Sender: TObject);
    procedure Nbt_CompareClick(Sender: TObject);
    procedure Chk_DebugClick(Sender: TObject);
    procedure Tim_TraitementTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Procedure LoadCFG;
    Procedure SaveCFG;

  end;

var
  Frm_CMELMain: TFrm_CMELMain;

implementation

{$R *.dfm}

procedure TFrm_CMELMain.Chk_DebugClick(Sender: TObject);
begin
  MainCFG.Debug := Chk_Debug.Checked;
end;

procedure TFrm_CMELMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM_CMEL.Free;
end;

procedure TFrm_CMELMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Pan_Top.Enabled;
end;

procedure TFrm_CMELMain.FormCreate(Sender: TObject);
var
  bAutoExeApp : Boolean;
begin
  Caption := 'ExtractLevis V' + CVERSION;

  GAPPPATH  := ExtractFilePath(Application.ExeName);
  GPATHQRY  := GAPPPATH + 'Fichiers\';
  GPATHSAVE := GAPPPATH + 'TmpFile\';
  GPATHIMG  := GAPPPATH + 'Images\';
  GPATHARCHIV := GAPPPATH + 'Archive\' + FormatDateTime('YYYY\MM\DD\',Now);

  if not DirectoryExists(GPATHSAVE) then
    ForceDirectories(GPATHSAVE);
  if not DirectoryExists(GPATHARCHIV) then
    ForceDirectories(GPATHARCHIV);
  

  DM_CMEL := TDM_CMEL.Create(self);
  DM_CMEL.Memo := mmLogs;
  DM_CMEL.ProgBarArticle := pbArticle;
  DM_CMEL.ProgBarClient  := pbClient;

  With DM_CMEL do
  begin
    if not Open2kDatabase then
    begin
      ShowMessage('Echec de connexion à la base de données');
      Application.Terminate;
    end;

    // Chargement de la configuration
    MainCFG.Debug := False;
    LoadCFG;

    if MainCFG.Debug then
    begin
      Chk_Debug.Checked := True;
      Chk_Debug.Visible := True;
      DBLookupComboBox1.Visible := True;
      Nbt_Compare.Visible := True;
    end;

    if ParamCount > 0 then
    begin
      bAutoExeApp := True;
      case AnsiIndexStr(ParamStr(1),['S','V','C']) of
        0: Rgr_Choix.ItemIndex := 0; // Export Stock
        1: Rgr_Choix.ItemIndex := 1; // Export Vente
        2: Rgr_Choix.ItemIndex := 2; // Export Commande
        else begin
          bAutoExeApp := False;
        end;
      end;

      // déclenchement du timer pour l'exécution du logiciel automatiquement
      Tim_Traitement.Enabled := bAutoExeApp;
    end;
  end;
end;

procedure TFrm_CMELMain.Nbt_ParamClick(Sender: TObject);
begin
  With Tfrm_CMELParam.Create(Self) do
  try
    if ShowModal = mrOk then
      SaveCFG;
  finally
    Release;
  end;
end;

procedure TFrm_CMELMain.Nbt_CompareClick(Sender: TObject);
var
  sBasePath : String;
  Header : TExportHeaderOL;
  sFileName : String;
begin
  With DM_CMEL do
  begin
    if MainCFG.Debug then
      sBasePath := GBASEPATHDEBUG
    else
      sBasePath := aQue_MagList.FieldByName('MAG_CHEMINBASE').AsString;

    // conenxion à la base de données Ginkoia
    InitGinkoiaDB(sBasePath,0);

    MemD_Compare.Close;
    MemD_Compare.Open;
    
    With Que_Tmp do
    begin
      aQue_Levis.First;
      // Parcours des cb levis pour rechercher dans la base ginkoia
      while not aQue_Levis.EOF do
      begin

         Close;
         SQL.CLear;
         SQL.Add('Select ARF_CHRONO,ART_NOM,MRK_NOM, TGF_NOM, COU_NOM FROM ARTARTICLE');
         SQL.Add('  join ARTREFERENCE on ARF_ARTID = ART_ID');
         SQL.Add('  join ARTMARQUE on MRK_ID = ART_MRKID');
         SQL.Add('  join ARTCODEBARRE on CBI_ARFID = ARF_ID');
         SQL.Add('  join PLXTAILLESGF on TGF_ID = CBI_TGFID');
         SQL.Add('  join PLXCOULEUR on COU_ID = CBI_COUID');
         SQL.Add('Where CBI_TYPE = 3');
         SQL.Add('  and CBI_CB = :PCB');
         ParamCheck := True;
         ParamByName('PCB').AsString := aQue_Levis.FieldByName('LEV_EAN').AsString;
         Open;

         if RecordCount > 0 then
         begin
           if not MemD_Compare.Locate('EAN;ART_NOM',VarArrayOf([aQue_Levis.FieldByName('LEV_EAN').AsString,FieldByName('ART_NOM').AsString]),[loCaseInsensitive]) then
           begin
             MemD_Compare.Append;
             MemD_Compare.FieldByName('EAN').AsString := aQue_Levis.FieldByName('LEV_EAN').AsString;
             MemD_Compare.FieldByName('ART_NOM').AsString := FieldByName('ART_NOM').AsString;
             MemD_Compare.FieldByName('ARF_CHRONO').AsString := FieldByName('ARF_CHRONO').AsString;
             MemD_Compare.FieldByName('MRK_NOM').AsString    := FieldByName('MRK_NOM').AsString;
             MemD_Compare.FieldByName('TGF_NOM').AsString    := FieldByName('TGF_NOM').AsString;
             MemD_Compare.FieldByName('COU_NOM').AsString    := FieldByName('COU_NOM').AsString;
             MemD_Compare.Post;
           end;

         end;
        aQue_Levis.Next;
        pbArticle.Position := aQue_Levis.RecNo * 100 Div aQue_Levis.RecordCount;
        Application.ProcessMessages;
      end; // while
    end; // With

    if MemD_Compare.RecordCount > 0 then
    begin
      Header := TExportHeaderOL.Create;
      try
        Header.bAlign := False;
        Header.Separator := ';';
        Header.bWriteHeader := True;
        Header.Add('EAN');
        Header.Add('ART_NOM');
        Header.Add('ARF_CHRONO');
        Header.Add('MRK_NOM');
        Header.Add('TGF_NOM');
        Header.Add('COU_NOM');

        sFileName := GAPPPATH + aQue_MagList.FieldByName('MAG_CODE').AsString + '_' +
                                aQue_MagList.FieldByName('MAG_NOM').AsString + '_' +
                                FormatDAteTime('YYYYMMDD',Now) + '.csv';

        Header.ConvertToCsv(MemD_Compare,sFileName);
      finally
        Header.Free;
      end;
    end;

  end; //  with
end;

procedure TFrm_CMELMain.Nbt_ExportClick(Sender: TObject);
begin
  pbArticle.Position := 0;
  pbClient.Position  := 0;

  Pan_Top.Enabled := false;

  try

    if Rgr_Choix.ItemIndex <> -1 then
    begin
      case Rgr_Choix.ItemIndex of
        0: GenerateExportStock;
        1: GenerateExportVente;
        2: GenerateExportCMD;
      end; // case
    end; // if
  finally
    Pan_Top.Enabled := True;
  end;
end;

procedure TFrm_CMELMain.LoadCFG;
var
  sTemp : String;
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    MainCFG.EMail.ExpMail  := ReadString('MAIL','EXPMAIL','admin@ginkoia.fr');
    sTemp                  := ReadString('MAIL','PASSW','');
    MainCFG.EMail.Password := DeCryptPW(sTemp);
    MainCFG.EMail.AdrSMTP  := ReadString('MAIL','SMTPADR','');
    MainCFG.EMail.Port     := ReadInteger('MAIL','PORT',25);

    MainCFG.FTP.Host       := ReadString('FTP','HOST','');
    MainCFG.FTP.UserName   := ReadString('FTP','USR','');
    sTemp                  := ReadString('FTP','PASSW','');
    MainCFG.FTP.Password   := DeCryptPW(sTemp);
    MainCFG.FTP.Dir        := ReadString('FTP','DIR','');

    if ParamCount > 0 then
      if ParamStr(1) = 'DEBUG' then
      begin
        GBASEPATHDEBUG := ReadString('DEBUG','BASE','C:\Developpement\Ginkoia\Data\Sorin-S2K\ginkoia.ib');
        MainCFG.DebugMagCode := ReadString('DEBUG','MAGCODE','951225');
        MainCfg.DebugMagID   := ReadInteger('DEBUG','MAGID',23);
        MainCfg.DebugKIdCDE  := ReadInteger('DEBUG','KIDCDE',0);
        MainCFG.Debug := True;
      end;
    MainCfg.MntMiniCde     := ReadFloat('CDE','MNTMINI',500);
  finally
    Free;
  end;
end;

procedure TFrm_CMELMain.SaveCFG;
var
 sTemp : String;
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    WriteString('MAIL','EXPMAIL',MainCFG.EMail.ExpMail);
    sTemp := CryptPW(MainCFG.EMail.Password);
    WriteString('MAIL','PASSW',sTemp);
    WriteString('MAIL','SMTPADR',MainCFG.EMail.AdrSMTP);
    WriteInteger('MAIL','PORT',MainCFG.EMail.Port);

    WriteString('FTP','HOST',MainCFG.FTP.Host);
    WriteString('FTP','USR',MainCFG.FTP.UserName);
    sTemp := CryptPW(MainCFG.FTP.Password);
    WriteString('FTP','PASSW',sTemp);
    WriteString('FTP','DIR',MainCFG.FTP.Dir);
    WriteFloat('CDE','MNTMINI',MainCfg.MntMiniCde);
  finally
    Free;
  end;
end;

procedure TFrm_CMELMain.Tim_TraitementTimer(Sender: TObject);
begin
  Tim_Traitement.Enabled := False;
  Nbt_Export.Click;
  Application.Terminate;
end;

end.

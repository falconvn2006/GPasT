unit GSCFGSMParametre_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, IniFiles, FileCtrl;

type
  TFParametre = class(TForm)
    Lab_chemin: TLabel;
    txt_Chemin: TEdit;
    Nbt_CheminBase: TBitBtn;
    Pan_Connexion: TPanel;
    Pan_NomMagasin: TPanel;
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    opd_Base: TOpenDialog;
    Nbt_DBLan: TBitBtn;
    Lab_ValDefaut: TLabel;
    Chp_CheminRecup: TEdit;
    Nbt_CheminDepose: TBitBtn;
    Lab_CheminDepose: TLabel;
    Lab_CheminRecup: TLabel;
    Chp_CheminDepose: TEdit;
    Nbt_CheminRecup: TBitBtn;
    opd_CheminDepose: TOpenDialog;
    opd_CheminRecup: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CheminBaseClick(Sender: TObject);
    procedure Nbt_DBLanClick(Sender: TObject);
    procedure Nbt_CheminDeposeClick(Sender: TObject);
    procedure Nbt_CheminRecupClick(Sender: TObject);
  private
    function  ConnexionBaseGOSport(vpChemin : String): Boolean;
    function  BaseGSConfig : Boolean;

    procedure AffichageSelonLaConnexion;

    procedure EcrireIni;

    Function  SauvDossFic(CheminRecup, CheminDepos : String) : Boolean;
    Procedure CharDossFic;
  public
    { Déclarations publiques }
  end;

var
  FParametre: TFParametre;

implementation

{$R *.dfm}

uses GSCFG_Types, GSCFGMain_DM;

procedure TFParametre.FormCreate(Sender: TObject);
begin
  txt_Chemin.Text := GCHEMINBASE;

  AffichageSelonLaConnexion;

  if ConnexionBaseGOSport(txt_Chemin.Text) then
  begin
    BaseGSConfig;
    CharDossFic;
  end;
end;

procedure TFParametre.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := CaFree;
end;

procedure TFParametre.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_Escape then
    Close;
end;


//------------------------------------------------------------------------------
//                                                               +-------------+
//                                                               |    OBJET    |
//                                                               +-------------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Bouton

procedure TFParametre.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFParametre.Nbt_CheminBaseClick(Sender: TObject);
var
  vChemin : String;
begin
  vChemin := '';

  if opd_Base.Execute then
    begin
      vChemin := opd_Base.FileName;
      txt_Chemin.Text := vChemin;

      if Trim(vChemin) = '' then
        Exit;

      if ConnexionBaseGOSport(vChemin) then
        BaseGSConfig;
    end;
end;

procedure TFParametre.Nbt_CheminDeposeClick(Sender: TObject);
var
  CheminDepos : string;
begin

  if SelectDirectory(CheminDepos, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    Chp_CheminDepose.Text := CheminDepos;
  end;

end;

procedure TFParametre.Nbt_CheminRecupClick(Sender: TObject);
Var
  CheminRecup : String;
begin
  if SelectDirectory(CheminRecup, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    Chp_CheminRecup.Text := CheminRecup;
  end;
end;

procedure TFParametre.Nbt_DBLanClick(Sender: TObject);
begin
  AffichageSelonLaConnexion;

  if Trim(txt_chemin.Text) = '' then
    Exit;

  if ConnexionBaseGOSport(Trim(txt_chemin.Text)) then
    BaseGSConfig
end;

procedure TFParametre.Nbt_PostClick(Sender: TObject);
begin
  txt_Chemin.text := Trim(txt_Chemin.text);

  FMain_DM.cds_Dossier.EmptyDataSet;

  if ConnexionBaseGOSport(txt_Chemin.text) then
  begin
    if BaseGSConfig then
      FMain_DM.OuvrirTable;


  end;

  if not FMain_DM.idb_GoSport.Connected then
    if application.MessageBox('Aucune base n''a été connectée.' + chr(13) +
                              'Etes-vous sûr de vouloir enregistrer le paramétrage?',
                              'Base non connectée', MB_IconExclamation
                              + MB_OKCANCEL) = IDCANCEL then
    begin
      Exit;
    end;

  EcrireIni;

  //Enregistrement des dossiers par défaut dans le fichier Ini
  SauvDossFic(Chp_CheminRecup.Text, Chp_CheminDepose.Text);
  Close;
end;

function TFParametre.SauvDossFic(CheminRecup, CheminDepos: String): Boolean;
var
  SavInIni                    : TIniFile;
  DirIni, DirRecup, DirDepos  : String;
  bOk                         : Boolean;
  IdDossier                   : Integer;
begin
  //Function qui permettra de sauvegarder dans la base les chemins de recup et depose des fichiers d'extraction
  DirRecup := Trim(Chp_CheminRecup.Text);
  DirDepos := Trim(Chp_CheminDepose.Text);
  DirIni   := ExtractFilePath(Application.ExeName)
              + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');

  try
    SavInIni := TIniFile.Create(DirIni);

    if SavInIni.SectionExists('DOSSIER EXTRACT') then
    begin
      SavInIni.WriteString('DOSSIER EXTRACT', 'CHEMIN DEPOSE FICHIER', DirDepos);
    end;

    if SavInIni.SectionExists('DOSSIER INTEGRE') then
    begin
      SavInIni.WriteString('DOSSIER INTEGRE', 'CHEMIN RECUP FICHIER', DirRecup);
    end;
  finally
    SavInIni.Free;
  end;

end;

//---------------------------------------------------------------> EcrireIni

procedure TFParametre.EcrireIni;
var
  vIniFile : TIniFile;
  vChemin, vBase : String;
begin
  vBase   := Trim(txt_Chemin.text);
  vChemin := ExtractFilePath(Application.ExeName)
             + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');

  if FileExists(vChemin) then
  begin
//JB
    try
      vInifile := TIniFile.Create(vChemin);

      vInifile.WriteString('CONNEXION', 'CHEMINBASE', vBase);

      GCHEMINBASE := vBase;
    finally
      vInifile.Free;
    end;
  end;
//
end;

//------------------------------------------------------------------------------
//                                                        +--------------------+
//                                                        |   CONNEXION BASE   |
//                                                        +--------------------+
//------------------------------------------------------------------------------

procedure TFParametre.CharDossFic;
var
  FicIni                        : TIniFile;
  DirIni, DirExtract, DirIntegr : String;
begin
  //J'ouvre le fichier INI
  DirIni := ExtractFilePath(Application.ExeName)
             + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
  try
    FicIni := TIniFile.Create(DirIni);

    //Verification si la section existe
    if FicIni.SectionExists('DOSSIER EXTRACT') then
    begin
      Chp_CheminDepose.Text := IncludeTrailingPathDelimiter(FicIni.ReadString('DOSSIER EXTRACT', 'CHEMIN DEPOSE FICHIER', 'C:\'));
    end;

    if FicIni.SectionExists('DOSSIER INTEGRE') then
    begin
      Chp_CheminRecup.Text := IncludeTrailingPathDelimiter(FicIni.ReadString('DOSSIER INTEGRE', 'CHEMIN RECUP FICHIER', 'C:\'));
    end;

  finally
    FicIni.Free;
  end;

end;

function TFParametre.ConnexionBaseGOSport(vpChemin : String): Boolean;
begin
  Result := False;
  pan_Connexion.Color := $009F9FFF;              // Couleur rouge

  if Trim(vpChemin) = '' then
    Exit;

  With FMain_DM.idb_GoSport do
  begin
    Disconnect;

    DatabaseName := vpChemin;

    try
      Connect;
      Result := Connected;

      if Connected then
        pan_Connexion.Color := $00DCF5C0;        // Couleur Verte

    except
      Disconnect;
      Result := False;
      //ShowMessage('Erreur de connexion à la base de données');
    end;
  end;
end;

//-------------------------------------------------------------> BaseGinkoia

function TFParametre.BaseGSConfig : Boolean;
begin
  Result := False;

  // On va tester si la base est bien une base ginkoia
  if FMain_DM.idb_GoSport.Connected then
    with FMain_DM.Que_Dossier do
    begin
      try
        Open;
        Close;

        Result := True;
      except
        FMain_DM.idb_GoSport.Disconnect;

        ShowMessage('La base n''est pas une base GOSport_Config correcte.');
      end;
    end;

  AffichageSelonLaConnexion;
end;

//-----------------------------------------------> AffichageSelonLaConnexion

procedure TFParametre.AffichageSelonLaConnexion;
begin
  if FMain_DM.idb_GoSport.Connected then
    pan_Connexion.Color := $00DCF5C0     // Couleur verte
  else
    pan_Connexion.Color := $009F9FFF;    // Couleur rouge
end;


end.

unit Main_Dm;

interface

uses
  SysUtils, Forms, Classes, DB, ADODB, inicfg_frm;

type
  TDm_Main = class(TDataModule)
    ado: TADOConnection;
    Qdos: TADOQuery;
    QdosDOS_ID: TAutoIncField;
    QdosDOS_NOM: TStringField;
    QdosDOS_COMMENT: TStringField;
    QdosDOS_ENABLED: TIntegerField;
    QdosDOS_GUID: TStringField;
    QdosDOS_UNIID: TIntegerField;
    Qmag: TADOQuery;
    Qmagmag_id: TAutoIncField;
    Qmagmag_actif: TIntegerField;
    Qmagmag_dateactivation: TDateTimeField;
    Qmagmag_code: TStringField;
    Qmagmag_nom: TStringField;
    Qmagmag_ville: TStringField;
    Qmagmag_cheminbase: TStringField;
    Qmagmag_dosid: TIntegerField;
    Qmagdos_nom: TStringField;
    Qmagmag_senderid: TIntegerField;
    Ds_Dos: TDataSource;
    Ds_mag: TDataSource;
    Tmag: TADOTable;
    TmagMAG_ID: TAutoIncField;
    TmagMAG_DOSID: TIntegerField;
    TmagMAG_REGID: TIntegerField;
    TmagMAG_TYMID: TIntegerField;
    TmagMAG_CODE: TStringField;
    TmagMAG_NOM: TStringField;
    TmagMAG_DIRECTEUR: TStringField;
    TmagMAG_VILLE: TStringField;
    TmagMAG_LEARDERSHIP: TIntegerField;
    TmagMAG_ENABLED: TIntegerField;
    TmagMAG_CHEMINBASE: TStringField;
    TmagMAG_DATEACTIVATION: TDateTimeField;
    TmagMAG_ACTIF: TIntegerField;
    TmagMAG_X: TSmallintField;
    TmagMAG_Y: TSmallintField;
    TmagMAG_INDICGENERAL: TWordField;
    TmagMAG_SENDERID: TIntegerField;
    TmagMAG_RAPPINTEG: TIntegerField;
    TmagMAG_CATMAN: TIntegerField;
    Ds_TMag: TDataSource;
    Qreg: TADOQuery;
    QregREG_NOM: TStringField;
    QregREG_ID: TAutoIncField;
    Ds_Reg: TDataSource;
    TmagMAG_LEVIS: TWordField;
    TmagMAG_DATEACTIVATIONLEVIS: TDateTimeField;
    TmagMAG_CMDLEVIS: TWordField;
    TmagMAG_DATABASE: TWordField;
    TmagMAG_DTBDATEACTIVATION: TDateTimeField;
    Qmagmag_database: TWordField;
    Qmagmag_dtbdateactivation: TDateTimeField;
    QHisto: TADOQuery;
    QHistomhi_datedeb: TDateTimeField;
    QHistomhi_datefin: TDateTimeField;
    QHistoCOLUMN1: TDateTimeField;
    QHistomhi_kdeb: TIntegerField;
    QHistomhi_kfin: TIntegerField;
    QHistomhi_ok: TBooleanField;
    QHistomhi_info: TStringField;
    Qrapport: TADOQuery;
    Ds_Rapport: TDataSource;
    Qrapportmag_id: TAutoIncField;
    Qrapportdos_nom: TStringField;
    Qrapportmag_nom: TStringField;
    Qrapportmag_ville: TStringField;
    Qrapportmag_code: TStringField;
    Qrapportmag_database: TWordField;
    Qrapportmag_dtbdateactivation: TDateTimeField;
    QrapportDernierTicket: TDateTimeField;
    QrapportDernierResultat: TIntegerField;
    QrapportDerniereSynchroOk: TDateTimeField;
    QrapportDateInit: TDateTimeField;
    QrapportDernierResultatStr: TStringField;
    QListOC: TADOQuery;
    QListOcMag: TADOQuery;
    QRapportOC: TADOQuery;
    Ds_listoc: TDataSource;
    QTemp: TADOQuery;
    QlistMag: TADOQuery;
    QListOCOSO_ID: TAutoIncField;
    QListOCOSO_NOM: TStringField;
    QlistMagmag_id: TAutoIncField;
    QlistMagmag_actif: TIntegerField;
    QlistMagmag_dateactivation: TDateTimeField;
    QlistMagmag_code: TStringField;
    QlistMagmag_nom: TStringField;
    QlistMagmag_ville: TStringField;
    QlistMagmag_cheminbase: TStringField;
    QlistMagmag_dosid: TIntegerField;
    QlistMagdos_nom: TStringField;
    QlistMagmag_senderid: TIntegerField;
    QlistMagmag_database: TWordField;
    QlistMagmag_dtbdateactivation: TDateTimeField;
    QRapportOCOSH_ID: TAutoIncField;
    QRapportOCOSH_MAGCODE: TStringField;
    QRapportOCOSH_ACTIF: TWordField;
    QRapportOCOSH_OSOID: TIntegerField;
    QRapportOCOSH_DEBUT: TDateTimeField;
    QRapportOCOSH_FIN: TDateTimeField;
    QRapportOCOSH_DATE: TDateTimeField;
    QRapportOCMAG_ID: TAutoIncField;
    QRapportOCMAG_CODE: TStringField;
    QRapportOCMAG_NOM: TStringField;
    QRapportOCMAG_VILLE: TStringField;
    QRapportOCMAG_ACTIF: TIntegerField;
    QRapportOCOSO_ID: TAutoIncField;
    QRapportOCOSO_NOM: TStringField;
    QRapportOCOSO_SUPP: TWordField;
    Ds_listOCMag: TDataSource;
    QListOcMagOSM_ID: TAutoIncField;
    QListOcMagOSM_OSOID: TIntegerField;
    QListOcMagOSM_MAGCODE: TStringField;
    QListOcMagOSM_DEBUT: TDateTimeField;
    QListOcMagOSM_FIN: TDateTimeField;
    QListOcMagMAG_CODE: TStringField;
    QListOcMagMAG_NOM: TStringField;
    QListOcMagMAG_VILLE: TStringField;
    QListOcMagDOS_ID: TAutoIncField;
    QListOcMagDOS_NOM: TStringField;
    Qrapportmag_cheminbase: TStringField;
    TmagMAG_EXTRACTCLT: TIntegerField;
    TmagMAG_EXTRACTCLTLASTK: TIntegerField;
    Qmagmag_extractclt: TIntegerField;
    Qmagmag_extractcltlastk: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure QrapportCalcFields(DataSet: TDataSet);
    procedure Ds_listocDataChange(Sender: TObject; Field: TField);
  private
    { Déclarations privées }
  public
    dtDateInit : TDateTime;
    sSource : string;
    procedure RefreshRapport;
    // Connexion à la base de données
    procedure DatabaseConnection;
    { Déclarations publiques }
  end;

var
  Dm_Main: TDm_Main;

implementation

{$R *.dfm}

USES IniFiles, Start_Frm;

procedure TDm_Main.DatabaseConnection;
begin
  dtDateInit := IniCfg.DateInit;

  //Ouverture de la connexion
  ado.Connected:=false;
  // Définition de la connection string
  ado.ConnectionString := IniCfg.MsSqlConnectionString;
  //Ouverture de la connexion
  ado.Connected:=true;

  QMag.Open;
  QDos.Open;
  QReg.Open;
  TMag.Open;

  QListOC.Open;
end;

procedure TDm_Main.DataModuleCreate(Sender: TObject);
var
  sPathIni             : string;     // Chemin vers l'ini
  iniConfigAppli       : TIniFile;   // Manipulation du Fichier Ini
begin
  IniCfg.LoadIni;
  DatabaseConnection;
//  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
//  try
//    iniConfigAppli := TIniFile.Create(sPathIni);
//    sSource        := iniConfigAppli.ReadString('DATABASE', 'URL', '');
//    dtDateInit     := iniConfigAppli.ReadDate('DATABASE', 'DATEINIT', EncodeDate(2011, 06, 01)); // Par défaut 1er juin 2011. Rendu paramétrable dans l'ini, on sait jamais.
//  finally
//    iniConfigAppli.Free;
//  end;
////  sSource := 'sp2kcat.no-ip.org';
//
//  // Définition de la connection string
//  ado.ConnectionString := 'Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Initial Catalog=SP2000CATMAN;' +
//      'Data Source=' + sSource +
//      ';Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=BRUNON_NB;Use Encryption for Data=False;Tag with column collation when possible=False';
//
//  //Ouverture de la connexion
//  ado.Connected:=true;
end;

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  Qrapport.Close;
  TMag.Close;
  QReg.Close;
  QDos.Close;
  QMag.Close;

  //Fermeture de la connexion
  ado.Connected:=False;

end;

procedure TDm_Main.Ds_listocDataChange(Sender: TObject; Field: TField);
begin
  QListOcMag.Close;
  if QListOC.RecordCount > 0 then
  begin
    QListOcMag.Parameters.ParamByName('POSOID').Value := QListOC.FieldByName('OSO_ID').AsInteger;
    QListOcMag.Open;
  end;
end;

procedure TDm_Main.QrapportCalcFields(DataSet: TDataSet);
begin
  CASE QrapportDernierResultat.AsInteger Of
    0 : Begin
      QrapportDernierResultatStr.AsString := 'Anomalie';
    End;
    1 : Begin
      QrapportDernierResultatStr.AsString := 'OK';
    End;
    2 : Begin
      QrapportDernierResultatStr.AsString := 'Non initialisé';
    End;
  END;
end;

procedure TDm_Main.RefreshRapport;
begin
  //Affichage d'un splash screen
  //Frm_Start := TFrm_Start.create(application);
  try
    Frm_Start.Show;
    Frm_Start.Update;

    Dm_Main.Qrapport.Close;
    Dm_Main.Qrapport.Open;
  finally
    //Fermeture de splash screen
    Frm_Start.Close;
  end;
end;

end.

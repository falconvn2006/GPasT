unit GSCFGMain_DM;

interface

uses
  SysUtils, Classes, DB, DBClient, Inifiles, Dialogs,
  IBODataset, IB_Components, IB_Access, Forms, MidasLib, Controls, ShellAPI, Windows;

type
  TMagType = (mtNone, mtGoSport, mtCourir) ;
  TMagMode = (mtAucun, mtAffilie, mtCAF, mtMandat) ;

  TFMain_DM = class(TDataModule)
    cds_Parametre: TClientDataSet;
    IbT_Select: TIB_Transaction;
    IbT_Maj_GoSport: TIB_Transaction;
    Que_Dossier: TIBOQuery;
    Que_Parametre: TIBOQuery;
    cds_ParametrePRM_ID: TIntegerField;
    cds_ParametrePRM_TYPE: TIntegerField;
    cds_ParametrePRM_INFO: TStringField;
    cds_ParametrePRM_DSTRING: TStringField;
    IbC_Maj_GoSport: TIB_Cursor;
    Que_ListeTVA: TIBOQuery;
    Que_ListeTVATVA_TAUX: TIBOFloatField;
    Que_ListeTVATVA_ID: TIntegerField;
    Que_ListeTypeComptable: TIBOQuery;
    Que_ListeDomaine: TIBOQuery;
    Que_ListeDomaineACT_ID: TIntegerField;
    Que_ListeDomaineACT_NOM: TStringField;
    Que_ListeAxe: TIBOQuery;
    Que_ListeAxeUNI_ID: TIntegerField;
    Que_ListeAxeUNI_NOM: TStringField;
    Que_ListeGarantie: TIBOQuery;
    Que_ListeFournisseur: TIBOQuery;
    idb_Ginkoia: TIBODatabase;
    cds_Magasin: TClientDataSet;
    Que_Select_Ginkoia: TIBOQuery;
    cds_MagasinNomMagasin: TStringField;
    cds_MagasinidMagasin: TIntegerField;
    cds_MagasinVille: TStringField;
    cds_MagasinNumero: TStringField;
    cds_Magasinutilisateur: TStringField;
    cds_MagasinidUtilisateur: TIntegerField;
    cds_MagasinType: TIntegerField;
    cds_MagasinLibelleType: TStringField;
    Que_Magasin: TIBOQuery;
    IBODatabase1: TIBODatabase;
    Que_MagasinMAG_ID: TIntegerField;
    Que_MagasinMAGASIN: TStringField;
    Que_MagasinVILLE: TStringField;
    Que_MagasinNUMERO: TStringField;
    Que_MagasinIDUSER: TIntegerField;
    Que_MagasinNOMUSER: TStringField;
    Que_MagasinLETYPE: TIntegerField;
    Que_ListeUser: TIBOQuery;
    Que_ListeUserUSR_USERNAME: TStringField;
    Que_ListeUserUSR_ID: TIntegerField;
    stp_NewId: TIB_StoredProc;
    IbT_Maj_Ginkoia: TIB_Transaction;
    Que_InfoMagasin: TIBOQuery;
    IbC_Maj_Ginkoia: TIB_Cursor;
    idb_GoSport: TIBODatabase;
    Que_MagasinIDPARAMETRE6: TIntegerField;
    Que_MagasinIDPARAMETRE7: TIntegerField;
    cds_MagasinIdParametre6: TIntegerField;
    cds_MagasinIdParametre7: TIntegerField;
    Que_DossierDOS_LIBELLEACTIVE: TStringField;
    Que_DossierDOS_ID: TIntegerField;
    Que_DossierDOS_NOM: TStringField;
    Que_DossierDOS_ACTIVE: TIntegerField;
    Que_DossierDOS_DTCREATE: TDateField;
    Que_DossierDOS_DTUPDATE: TDateField;
    Que_DossierDOS_DTDELETE: TDateField;
    Que_DossierDOS_ENABLED: TIntegerField;
    Que_DossierDOS_COMENT: TMemoField;
    Que_DossierDOS_IDGS: TIntegerField;
    Que_DossierDOS_IDMAGASIN: TStringField;
    Que_DossierDOS_PATH: TMemoField;
    Que_GoSport_ReUsable: TIBOQuery;
    cds_MagasinImport: TBooleanField;
    cds_MagasinExport: TBooleanField;
    Que_Horaire: TIBOQuery;
    Que_Tmp: TIBOQuery;
    Que_DossierDOS_EXTRACT: TIntegerField;
    Que_DossierDOS_EXTRACTDIR: TStringField;
    Que_DossierDOS_EXTRACTLASTDATE: TDateField;
    Que_DossierDOS_EXTRACTID: TStringField;
    Que_DossierDOS_INTEGREDIR: TStringField;
    Que_DossierDOS_INTEGRELASTDATE: TDateField;
    Que_DossierDOS_INTEGREINIT: TIntegerField;
    Que_DossierDOS_INTEGREINITDATE: TDateField;
    cds_Dossier: TClientDataSet;
    cds_DossierDOS_ID: TIntegerField;
    cds_DossierDOS_NOM: TStringField;
    cds_DossierDOS_ACTIVE: TIntegerField;
    cds_DossierDOS_DTCREATE: TDateField;
    cds_DossierDOS_DTUPDATE: TDateField;
    cds_DossierDOS_DTDELETE: TDateField;
    cds_DossierDOS_ENABLED: TIntegerField;
    cds_DossierDOS_COMENT: TMemoField;
    cds_DossierDOS_IDGS: TIntegerField;
    cds_DossierDOS_IDMAGASIN: TStringField;
    cds_DossierDOS_PATH: TMemoField;
    cds_DossierDOS_LIBELLEACTIVE: TStringField;
    cds_DossierDOS_EXTRACT: TIntegerField;
    cds_DossierDOS_EXTRACTDIR: TStringField;
    cds_DossierDOS_EXTRACTLASTDATE: TDateField;
    cds_DossierDOS_EXTRACTID: TStringField;
    cds_DossierDOS_INTEGREDIR: TStringField;
    cds_DossierDOS_INTEGRELASTDATE: TDateField;
    cds_DossierDOS_INTEGREINIT: TIntegerField;
    cds_DossierDOS_INTEGREINITDATE: TDateField;
    Que_ListeTVATVA_CODE: TStringField;
    cds_MagasinMode: TIntegerField;
    Que_MagasinLEMODE: TIntegerField;
    cds_MagasinLibelleMode: TStringField;
    Que_MagasinIDPARAMETRE8: TIntegerField;
    cds_MagasinIdParametre8: TIntegerField;
  private
    procedure Charger_CDS_Dossier;
    procedure Charger_CDS_Parametre;

    function  ChargerIni : String;
    function  ConnexionALaBase(vpChemin : String): Boolean;
  public
    function  InitiliaserConnexion : Boolean;

    procedure OuvrirTable;

    function UpdateFieldDatabase : Boolean;
  end;

var
  FMain_DM: TFMain_DM;

implementation

{$R *.dfm}

uses GSCFG_Types;


procedure TFMain_DM.OuvrirTable;
begin
  Charger_CDS_Dossier;
  Charger_CDS_Parametre;
end;

function TFMain_DM.UpdateFieldDatabase: Boolean;
var
  LastFields : TStringList;
  bUpdate    : Boolean;
begin
  //cette partie servira création des champs dans la table Dossier , si il existe pas
  bUpdate := False;

  // ----------------------------
  // Mise à jour DOSSIERS
  // ----------------------------
  with Que_Tmp do
  begin
    try
      LastFields := TStringList.Create;
      SQL.Clear;
      Close;
      SQL.Text := 'SELECT * FROM DOSSIERS';
      Open;
      GetFieldNames(LastFields);
      Close;

      if (LastFields.IndexOf('DOS_EXTRACT') = -1) then
      begin
        //Les nouveaux champs pour les offres de réductions ne sont pas crée dans la base
        idb_GoSport.StartTransaction;
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_EXTRACT INTEGER DEFAULT 0');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_EXTRACTDIR VARCHAR(512)');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_EXTRACTLASTDATE TIMESTAMP');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_EXTRACTID VARCHAR(16)');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_INTEGREDIR VARCHAR(512)');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_INTEGRELASTDATE TIMESTAMP');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_INTEGREINIT INTEGER DEFAULT 0');
        idb_GoSport.ExecSQL('ALTER TABLE DOSSIERS ADD DOS_INTEGREINITDATE TIMESTAMP');
        idb_GoSport.Commit;
        bUpdate := True
      end;
    finally
      LastFields.Free;
    end;

    if bUpdate then
    begin
      Showmessage('La base de données a été mise à jour. Redémarrage de l''aplication');
      ShellExecute(0,'OPEN',PWideChar(ParamStr(0)),nil,PWideChar(ExtractFilePath(ParamStr(0))), SW_SHOW);
      Application.Terminate;
    end;

  end;

end;

//-----------------------------------------------------> Charger_CDS_Dossier

procedure TFMain_DM.Charger_CDS_Dossier;
begin
  que_Dossier.Close;
  que_Dossier.Open;

  cds_Dossier.EmptyDataSet;

  while not que_Dossier.Eof do
  begin
    with cds_Dossier do
    begin
      Append;

      FieldByName('DOS_ID').AsInteger               := que_Dossier.FieldByName('DOS_ID').AsInteger;
      FieldByName('DOS_NOM').AsString               := que_Dossier.FieldByName('DOS_NOM').AsString;
      FieldByName('DOS_ACTIVE').AsInteger           := que_Dossier.FieldByName('DOS_ACTIVE').AsInteger;
      FieldByName('DOS_DTCREATE').AsDateTime        := que_Dossier.FieldByName('DOS_DTCREATE').AsDateTime;
      FieldByName('DOS_DTUPDATE').AsDateTime        := que_Dossier.FieldByName('DOS_DTUPDATE').AsDateTime;
      FieldByName('DOS_DTDELETE').AsDateTime        := que_Dossier.FieldByName('DOS_DTDELETE').AsDateTime;
      FieldByName('DOS_ENABLED').AsInteger          := que_Dossier.FieldByName('DOS_ENABLED').AsInteger;
      FieldByName('DOS_COMENT').AsString            := que_Dossier.FieldByName('DOS_COMENT').AsString;
      FieldByName('DOS_IDGS').AsString              := que_Dossier.FieldByName('DOS_IDGS').AsString;
      FieldByName('DOS_IDMAGASIN').AsInteger        := que_Dossier.FieldByName('DOS_IDMAGASIN').AsInteger;
      FieldByName('DOS_PATH').AsString              := que_Dossier.FieldByName('DOS_PATH').AsString;
      FieldByName('DOS_EXTRACT').AsInteger          := Que_Dossier.FieldByName('DOS_EXTRACT').AsInteger;
      FieldByName('DOS_EXTRACTLASTDATE').AsDateTime := Que_Dossier.FieldByName('DOS_EXTRACTLASTDATE').AsDateTime;
      FieldByName('DOS_EXTRACTDIR').AsString        := Que_Dossier.FieldByName('DOS_EXTRACTDIR').AsString;
      FieldByName('DOS_INTEGREDIR').AsString        := Que_Dossier.FieldByName('DOS_INTEGREDIR').AsString;
      FieldByName('DOS_INTEGREINIT').AsInteger      := Que_Dossier.FieldByName('DOS_INTEGREINIT').AsInteger;
      FieldByName('DOS_INTEGRELASTDATE').AsDateTime := Que_Dossier.FieldByName('DOS_INTEGRELASTDATE').AsDateTime;
      FieldByName('DOS_INTEGREINITDATE').AsDateTime := Que_Dossier.FieldByName('DOS_INTEGREINITDATE').AsDateTime;
      FieldByName('DOS_EXTRACTID').AsString         := Que_Dossier.FieldByName('DOS_EXTRACTID').AsString;

      Post;
    end;

    que_Dossier.Next;
  end;

  que_Dossier.Close;
end;

//---------------------------------------------------> Charger_CDS_Parametre

procedure TFMain_DM.Charger_CDS_Parametre;
begin
  que_Parametre.Close;
  que_Parametre.Open;

  cds_Parametre.EmptyDataSet;

  while not que_Parametre.Eof do
  begin
    with cds_Parametre do
    begin
      Append;

      FieldByName('PRM_ID').AsInteger     := que_Parametre.FieldByName('PRM_ID').AsInteger;
      FieldByName('PRM_TYPE').AsInteger   := que_Parametre.FieldByName('PRM_TYPE').AsInteger;
      FieldByName('PRM_INFO').AsString    := que_Parametre.FieldByName('PRM_INFO').AsString;
      FieldByName('PRM_DSTRING').AsString := que_Parametre.FieldByName('PRM_DSTRING').AsString;

      Post;
    end;

    que_Parametre.Next;
  end;

  que_Parametre.Close;
end;

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |  CONNEXION BASE  |
//                                                          +------------------+
//------------------------------------------------------------------------------

//----------------------------------------------------> InitiliaserConnexion

function TFMain_DM.InitiliaserConnexion : Boolean;
begin
  Result := False;

  GCHEMINBASE := ChargerIni;

  if GCHEMINBASE <> '' then
    Result := ConnexionALaBase(GCHEMINBASE);
end;

//--------------------------------------------------------------> ChargerIni

function TFMain_DM.ChargerIni : String;
var
  vChemin, vBase : String;
  vInifile       : TInifile;
begin
  vBase := '';
  vChemin := ExtractFilePath(Application.ExeName)
             + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');

  if FileExists(vChemin) then
  begin
//JB
    try
      vInifile := TIniFile.Create(vChemin);
      vBase := vIniFile.ReadString('CONNEXION', 'CHEMINBASE', '');
    finally
      vInifile.Free;
    end;
  end;
//
  Result := vBase;
end;

//--------------------------------------------------------> ConnexionALaBase

function TFMain_DM.ConnexionALaBase(vpChemin : String): Boolean;
begin
  Result := False;

  with Idb_GoSport do
  begin
    Disconnect;

    DatabaseName := vpChemin;

    try
      Connect;
      Result := Connected;

    except
      ShowMessage('Aucune base de données n''a été trouvée.');
    end;
  end;
end;


end.

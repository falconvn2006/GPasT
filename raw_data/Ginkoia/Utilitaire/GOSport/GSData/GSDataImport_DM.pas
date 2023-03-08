unit GSDataImport_DM;

interface

uses
  SysUtils, Classes, DB, DBClient, Forms,
  GSData_Types, IdReplyRFC, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdIntercept, IdLogBase, IdLogFile, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdFTP, GSData_TErreur, Generics.Collections, Generics.Defaults,
  SBSimpleSftp, SBSSHKeyStorage;

type
  TFTPData = record
    FileName :string;
    OnError : Boolean;
    Temoin,
    Number,
    Date : String;
    public
      procedure DecoupeFilename;
  end;

  TTemoinCompare = class(TComparer<TFTPData>)
    function Compare(const Left, Right: TFTPData): Integer; override;
  end;

  TDM_GSDataImport = class(TDataModule)
    cds_GRPCAF: TClientDataSet;
    cds_ARBCAF: TClientDataSet;
    cds_MARQUE: TClientDataSet;
    cds_MODELE: TClientDataSet;
    cds_ARTICL: TClientDataSet;
    cds_MODSFA: TClientDataSet;
    cds_OPECOM: TClientDataSet;
    cds_PRXVTE: TClientDataSet;
    cds_MULTCO: TClientDataSet;
    cds_PACKENT: TClientDataSet;
    cds_PACKAG: TClientDataSet;
    IdFTP: TIdFTP;
    IdLogFile: TIdLogFile;
    IdOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    cds_ARBCAFCGRP_P: TStringField;
    cds_ARBCAFCGRP_F: TStringField;
    cds_GRPCAFCODE_LANGUE: TStringField;
    cds_GRPCAFCODE_GROUPE: TStringField;
    cds_GRPCAFLIBELLE_GROUPE: TStringField;
    cds_MARQUECODE_MARQUE: TStringField;
    cds_MARQUELIBELLE_MARQUE: TStringField;
    cds_MODELECODE_MODELE: TStringField;
    cds_MODELELMOD: TStringField;
    cds_MODELESAISON: TStringField;
    cds_MODELEANNEE: TStringField;
    cds_MODELEGRP_MARCH: TStringField;
    cds_MODELECODE_MARQUE: TStringField;
    cds_ARTICLCODE_MODELE: TStringField;
    cds_ARTICLCODE_ARTICLE: TStringField;
    cds_ARTICLCODE_POINT1: TStringField;
    cds_ARTICLLIB_POINT1: TStringField;
    cds_ARTICLCODE_POINT2: TStringField;
    cds_ARTICLLIB_POINT2: TStringField;
    cds_ARTICLLIB_CAISSE: TStringField;
    cds_ARTICLCODE_TYP_VAL: TStringField;
    cds_ARTICLDATE_VALEUR: TStringField;
    cds_ARTICLVALEUR: TStringField;
    cds_ARTICLCODE_INFO1: TStringField;
    cds_ARTICLCODE_INFO2: TStringField;
    cds_ARTICLTYPE_PT1: TStringField;
    cds_ARTICLTYPE_PT2: TStringField;
    cds_MODSFACODE_MODELE: TStringField;
    cds_MODSFASFA: TStringField;
    cds_MODSFADATE_DEBUT_VALIDITE: TStringField;
    cds_MODSFADATE_FIN_VALIDITE: TStringField;
    cds_OPECOMCODE_OPERATION: TStringField;
    cds_OPECOMLIBELLE: TStringField;
    cds_OPECOMDATE_DEBUT: TStringField;
    cds_OPECOMDATE_FIN: TStringField;
    cds_OPECOMTYPE_OC: TStringField;
    cds_PRXVTECODE_MODELE: TStringField;
    cds_PRXVTECODE_ARTICLE: TStringField;
    cds_PRXVTECODE_MAGASIN: TStringField;
    cds_PRXVTECODE_OPERATION: TStringField;
    cds_PRXVTEDATE_VALEUR: TStringField;
    cds_PRXVTETYPE_CONDITION: TStringField;
    cds_PRXVTEPRIX: TStringField;
    cds_PRXVTETYPE: TStringField;
    cds_PRXVTEMOTIF_CHGT_PRIX: TStringField;
    cds_PRXVTEDATE_FIN: TStringField;
    cds_MULTCOCODE_LANGUE: TStringField;
    cds_MULTCONUM: TStringField;
    cds_MULTCOLIB: TStringField;
    cds_MULTCODTVAL: TStringField;
    cds_MULTCOCODE_ART: TStringField;
    cds_PACKLIG: TClientDataSet;
    cds_PACKENTCODE: TStringField;
    cds_PACKENTNOM: TStringField;
    cds_PACKENTCODEBARRE: TStringField;
    cds_PACKENTSFA: TStringField;
    cds_PACKENTCODE_MARQUE: TStringField;
    cds_PACKENTPRIX: TStringField;
    cds_PACKLIGCODEENETETE: TStringField;
    cds_PACKLIGCODE_ARTICLE: TStringField;
    cds_PACKLIGQUANTITE: TStringField;
    cds_PACKAGTYPE_PACKAGE: TStringField;
    cds_PACKAGCODE_LANGUE: TStringField;
    cds_PACKAGCODE_PACK: TStringField;
    cds_PACKAGLPACK: TStringField;
    cds_PACKAGCODE_POSTE: TStringField;
    cds_PACKAGLPOST: TStringField;
    cds_PACKAGTYP_TICKET: TStringField;
    cds_PACKAGPVPACK: TStringField;
    cds_PACKAGDATE_DEB: TStringField;
    cds_PACKAGDATE_FIN: TStringField;
    cds_PACKAGCODEARTSAP: TStringField;
    cds_PACKAGNBART: TStringField;
    cds_ADRFRN: TClientDataSet;
    cds_WCDEHA: TClientDataSet;
    cds_EXPCAF: TClientDataSet;
    cds_ADRFRNField01_CODE_SITE: TStringField;
    cds_ADRFRNField02_LIBELLE: TStringField;
    cds_ADRFRNField03_TYPE_SITE: TStringField;
    cds_ADRFRNField04_TYPE_MAGASIN: TStringField;
    cds_ADRFRNField05_INFO_ADR1: TStringField;
    cds_ADRFRNField06_INFO_ADR2: TStringField;
    cds_ADRFRNField07_NUM_RUE: TStringField;
    cds_ADRFRNField08_RUE: TStringField;
    cds_ADRFRNField09_CODE_POSTAL: TStringField;
    cds_ADRFRNField10_VILLE: TStringField;
    cds_EXPCAFField01_CODE_EXPEDITEUR: TStringField;
    cds_EXPCAFField02_NUM_BT: TStringField;
    cds_EXPCAFField03_DIVISION_DEST: TStringField;
    cds_EXPCAFField04_ENTREPOT_STOCK: TStringField;
    cds_EXPCAFField05_DATE_LIVRAISON: TStringField;
    cds_EXPCAFField06_NUM_LIVRAISON: TStringField;
    cds_EXPCAFField07_NUM_CARTON: TStringField;
    cds_EXPCAFField08_CODE_ARTICLE: TStringField;
    cds_EXPCAFField09_EAN_ARTICLE: TStringField;
    cds_EXPCAFField10_QTE: TStringField;
    cds_EXPCAFField11_CODE_ART_PREPACK: TStringField;
    cds_CESMAG: TClientDataSet;
    cds_CESMAGStringField01_CODE_EXPEDITEUR: TStringField;
    cds_CESMAGStringField02_NUM_BT: TStringField;
    cds_CESMAGStringField03_DIVISION_DEST: TStringField;
    cds_CESMAGStringField04_ENTREPOT_STOCK: TStringField;
    cds_CESMAGStringField05_DATE_LIVRAISON: TStringField;
    cds_CESMAGStringField06_NUM_LIVRAISON: TStringField;
    cds_CESMAGStringField07_NUM_CARTON: TStringField;
    cds_CESMAGStringField08_CODE_ARTICLE: TStringField;
    cds_CESMAGStringField09_EAN_ARTICLE: TStringField;
    cds_CESMAGStringField10_QTE: TStringField;
    cds_CESMAGStringField11_CODE_ART_PREPACK: TStringField;
    ElSimpleSFTPClient: TElSimpleSFTPClient;
    cds_CDEAFF: TClientDataSet;
    cds_EXPCAFField12_COMMANDE_SAP: TStringField;
    cds_CESMAGField12_COMMANDE_SAP: TStringField;
    cds_WCDEHAStringField01_CDE_SAP: TStringField;
    cds_WCDEHAStringField02_TYPE_CDE_SAP: TStringField;
    cds_WCDEHAStringField03_DATE_CREATION_CDE: TStringField;
    cds_WCDEHAStringField04_CODE_FOURN_SAP: TStringField;
    cds_WCDEHAStringField05_CODE_DIVISION: TStringField;
    cds_WCDEHAStringField06_CODE_MAG_DEST: TStringField;
    cds_WCDEHAStringField07_NUM_POSTE_CDE: TStringField;
    cds_WCDEHAStringField08_DATE_LIV_POSTE: TStringField;
    cds_WCDEHAStringField09_CODE_ART_SAP: TStringField;
    cds_WCDEHAStringField10_QTE_COMMANDE: TStringField;
    cds_WCDEHAStringField11_POSTE_ANNULE: TStringField;
    cds_WCDEHAStringField12_PRIX_ACHAT_NET: TStringField;
    cds_WCDEHAIntegerField13_NUM_ECHEANCE: TIntegerField;
    cds_CDEAFFStringField01_CDE_SAP: TStringField;
    cds_CDEAFFStringField02_TYPE_CDE_SAP: TStringField;
    cds_CDEAFFStringField03_DATE_CREATION_CDE: TStringField;
    cds_CDEAFFStringField04_CODE_FOURN_SAP: TStringField;
    cds_CDEAFFStringField05_CODE_DIVISION: TStringField;
    cds_CDEAFFStringField06_CODE_MAG_DEST: TStringField;
    cds_CDEAFFStringField07_NUM_POSTE_CDE: TStringField;
    cds_CDEAFFStringField08_DATE_LIV_POSTE: TStringField;
    cds_CDEAFFStringField09_CODE_ART_SAP: TStringField;
    cds_CDEAFFStringField10_QTE_COMMANDE: TStringField;
    cds_CDEAFFStringField11_POSTE_ANNULE: TStringField;
    cds_CDEAFFStringField12_PRIX_ACHAT_NET: TStringField;
    cds_CDEAFFIntegerField13_NUM_ECHEANCE: TIntegerField;
    cds_CDEAFFField14_COLLECTION: TStringField;
    cds_WCDEHAField14_COLLECTION: TStringField;
    cds_ADRFRNField11_ACTIF: TStringField;
    cds_CESMAGField13_PRIX_ACHAT: TStringField;
    cds_EXPCAFField13_PRIX_ACHAT: TStringField;
    procedure ElSimpleSFTPClientKeyValidate(Sender: TObject;
      ServerKey: TElSSHKey; var Validate: Boolean);
  private
    { Déclarations privées }
    function BuildPath(const AFolders: array of String): String; overload;
    function BuildPath: String; overload;
  public
    { Déclarations publiques }
    // Ouverture/ fermeture du FTP
    Function OpenFTP : Boolean;
    Function CloseFTP : Boolean;

    {$REGION 'Récupération des fichiers sur le FTP'}
    {
      AMAGNUM : Numéro du magasin à traiter
      AModeMag :
        0 : Répertoire Courrir
        1 : Répertoire GOSport

      AModeType :
        0 : Répertoire Envoi
        1 : Répertoire RECEPTION

      ADIRFILE : Nom du répertoire à traiter (REFERENTIEL, FIDELITE, etc ...)
    }
    {$ENDREGION}
    Function GetFileFromFTP(AMAGNUM : String; AModeMag, AModeType : Integer; ADIRFILE : String) : Boolean;

    {$REGION 'Methode SFTP'}
    function  OpenSFTP: Boolean;
    procedure CloseSFTP(const Silent: Boolean = False);
    function  GetFileFromSFTP(const AMAGNUM: String; const AModeMag, AModeType: Integer; const ADIRFILE: String): Boolean;
    {$ENDREGION}

    // fonction de chargement des fichiers dans les clientDataset
    Function LoadCsvToCDS (AFileName : String; ACDS : TClientDataset; AEmpty : Boolean = True) : Boolean;
    // fonction de nettoyage des CDS
    function ClearCds : Boolean;
  end;

var
  DM_GSDataImport: TDM_GSDataImport;

implementation

uses StrUtils, SBSSHConstants, SBSftpCommon, SBTypes , uLog, GSDataMain_DM;

{$R *.dfm}

{ TDM_GSDataImport }

function TDM_GSDataImport.BuildPath(const AFolders: array of String): String;
var
  i: Integer;
begin
  (*****************************************************************************
  Cette fonction concatène chacun des dossiers AFolders en intercalant entre
  chacun d'entres eux le séparateur '\'.
  *****************************************************************************)
  Result := '/';
  for i := Low( AFolders ) to High( AFolders ) do
    Result := Result + AFolders[i] + '/';
end;

function TDM_GSDataImport.BuildPath: String;
begin
  (*****************************************************************************
  Cette fonction retourne le path "de base" : '\'
  *****************************************************************************)
  Result := BuildPath( [] );
end;

function TDM_GSDataImport.ClearCds: Boolean;
var
  i: Integer;
begin
  for i := 0 to ComponentCount -1 do
    if Components[i] is TClientDataSet then
      TClientDataSet(Components[i]).EmptyDataSet;
end;

function TDM_GSDataImport.CloseFTP: Boolean;
begin
  if IdFTP.Connected then
    IdFTP.Disconnect;
end;

procedure TDM_GSDataImport.CloseSFTP(const Silent: Boolean);
begin
  if ElSimpleSFTPClient.Active then
    ElSimpleSFTPClient.Close( Silent );
end;

procedure TDM_GSDataImport.ElSimpleSFTPClientKeyValidate(Sender: TObject;
  ServerKey: TElSSHKey; var Validate: Boolean);
begin
  Validate := True;
end;

function TDM_GSDataImport.GetFileFromFTP(AMAGNUM: String; AModeMag, AModeType : Integer; ADIRFILE : String): Boolean;
var
  LstFileTemoin, lstFileGroup, lstDecoupe : TStringList;
  Error : TErreur;
  i, j : Integer;

  lstTemoin : TList<TFTPData>;
  Temoin : TFTPData;
begin
  Result := False;
  Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', 'Téléchargement...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  Try
    LstFileTemoin := TStringList.Create;
    lstFileGroup  := TStringList.Create;
//    lstDecoupe    := TStringList.Create;

    lstTemoin := TList<TFTPData>.Create(TTemoinCompare.Create);
    try
      // Revenir au répertoire de base
      while IdFTP.RetrieveCurrentDir <> '/' do
        IdFTP.ChangeDirUp;

      // Positionnement sur le répertoire de test ou de production
      if IniStruct.FTPDir.Mode = 1 then
        IdFtp.ChangeDir(IniStruct.FTPDir.Test) // Test
      else
        IdFtp.ChangeDir(IniStruct.FTPDir.Principal); // Principal

      // Postionnement sur le répertoire courrir ou GOSport
      case AModeMag of
        1: IdFTP.ChangeDir(IniStruct.FTPDir.GoSport); // Gosport
        2: IdFTP.ChangeDir(IniStruct.FTPDir.Courir); // courir
      end;

      // Postionnement sur le répertoire d'envoi ou de réception
      case AModeType of
        0: IdFTP.ChangeDir(IniStruct.FTPDir.Envoi);
        1: IdFTP.ChangeDir(IniStruct.FTPDir.reception);
      end;

      // Positionnement sur le réperetoire des fichiers
      IdFtp.ChangeDir(ADIRFILE);

      // récupération de la liste des fichiers TEMOIN du Magasin
      IdFTP.List(LstFileTemoin,'TEMOIN' + AMAGNUM + '*.*', False);

      // Copie des données dans le générique + Trie des données
      for i := 0 to LstFileTemoin.Count - 1 do
      begin
        Temoin.FileName := LstFileTemoin[i];
        Temoin.DecoupeFilename;
        lstTemoin.Add(Temoin);
      end;
      lstTemoin.Sort;

      // Récupération des fichiers associé au fichier témoin
      for i := 0 to lstTemoin.Count -1 do
      begin
//        // Découpe du nom du fichier pour récupérer les différentes parties
//        lstDecoupe.Text := LstFileTemoin[i];
//        lstDecoupe.Text := StringReplace(lstDecoupe.Text,'.',#13#10,[rfReplaceAll]);

//        if lstDecoupe.Count <> 3 then
        if lstTemoin[i].OnError then
        begin
          // Le nom fichier n'a pas le nombre de section nécessaire TEMOIN+NumMagasin, Num Incrément, Date
          Error := TErreur.Create;
          Error.AddError(lstTemoin[i].FileName,'FTP','Structure du nom de fichier incorrecte',0,teGetFtp,0,'');
          GERREURS.Add(Error);

          for j := (i + 1) to lstTemoin.Count -1 do
          begin
            Error := TErreur.Create;
            Error.AddError(lstTemoin[j].FileName,'FTP','Fichier non traité à cause d''une erreur d''un fichier précédent',0,teGetFtpWarning,0,'');
            GERREURS.Add(Error);
          end;

          // on sort du traitement mais on laisse continuer le logiciel
          Break;
        end;

        IdFTP.List(lstFileGroup,Format('*%s.*.%s',[AMAGNUM,lstTemoin[i].Date]),False);
        Try
          for j := 0 to lstFileGroup.Count -1 do
          begin
            Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
              DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Téléchargement...', [ lstFileGroup[j] ] ), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
            IdFTP.Get(lstFileGroup[j],GAPPFTP + lstFileGroup[j],True);
            Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
              DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Téléchargé', [ lstFileGroup[j] ] ), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
          end;

          if IniStruct.FTPDir.DeleteFileFromFTP then
            for j := 0 to lstFileGroup.Count -1 do
              IdFTP.Delete(lstFileGroup[j]);

        Except on E:Exception do
          begin
            Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
              DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : %s', [ lstFileGroup[j], E.Message ] ), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
            Error := TErreur.Create;
            Error.AddError(lstTemoin[i].FileName,'FTP',
                           Format('Problème lors du traitement du groupe de fichier : %s - %s',[lstTemoin[i].FileName,E.Message]),0,teGetFtp,0,'');
            GERREURS.Add(Error);
            // Suppression de tous les fichiers correspondant sur dans le répertoire
            for j := 0 to lstFileGroup.Count -1 do
              if FileExists(GAPPFTP + lstFileGroup[j]) then
                DeleteFile(GAPPFTP + lstFileGroup[j]);

            for j := (i + 1) to lstTemoin.Count -1 do
            begin
              Error := TErreur.Create;
              Error.AddError(lstTemoin[j].FileName,'FTP','Fichier non traité à cause d''une erreur d''un fichier précédent',0,teGetFtpWarning,0,'');
              GERREURS.Add(Error);
            end;
            // en cas d'erreur on sort
            Break;
          end;
        End;
      end;
    finally
      LstFileTemoin.Free;
      lstFileGroup.Free;
//      lstDecoupe.Free;

      lstTemoin.Free;
    end;
    Result := True;
  Except
     on E:EIdReplyRFCError do
      raise EIdReplyRFCError.Create('Pas de fichier à traiter');
     on E:Exception do
      raise Exception.Create('GetFileFromFTP -> ' + E.Message);
  End;
end;

function TDM_GSDataImport.GetFileFromSFTP(const AMAGNUM: String; const AModeMag,
  AModeType: Integer; const ADIRFILE: String): Boolean;
var
  LstFileTemoin, lstFileGroup : TList;
  i, j, iTentative : Integer;
  RemotePath, RemoteFilename: String;
  FilesList : TList;
  lstDecoupe, lstDelete : TStringList;
  Error : TErreur;

  lstTemoin, lstFile : TList<TFTPData>;
  Temoin : TFTPData;

  bContinue : Boolean;
begin
  Result     := False;
  with IniStruct.SFTPDir do
    RemotePath := BuildPath([
                    IfThen(      Mode = 1, Test  , Principal ),
                    IfThen(  AModeMag = 2, Courir, GoSport   ),
                    IfThen( AModeType = 0, Envoi , Reception ),
                    ADIRFILE
                  ]);
  try
    iTentative := 1;

    if ElSimpleSFTPClient.FileExists( RemotePath ) then
    begin
      Repeat
        Try
          (* Le dossier existe *)
          // Listing des fichiers présents dans ce repertoire
          lstDecoupe := TStringList.Create;
          FilesList  := TList.Create;

          lstTemoin := TList<TFTPData>.Create(TTemoinCompare.Create);
          try
            ElSimpleSFTPClient.ListDirectory( RemotePath, FilesList, Format( 'TEMOIN%s*.*', [ AMAGNUM ]), False, True, False );

            if FilesList.Count = 0 then
              Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
                    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', 'Pas de fichier à traiter', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

            {$REGION 'Copie des données dans le générique + Trie des données'}
            for i := 0 to FilesList.Count - 1 do
            begin
              Temoin.FileName := TElSftpFileInfo(FilesList[i]).Name;
              Temoin.DecoupeFilename;
              lstTemoin.Add(Temoin);
            end;
            lstTemoin.Sort;
            {$ENDREGION}

            for i := 0 to lstTemoin.Count-1 do
            begin (* Pour chacun des fichiers *)

              if lstTemoin[i].OnError then
              begin
                {$REGION 'Le nom fichier n''a pas le nombre de section nécessaire TEMOIN+NumMagasin, Num Incrément, Date'}
                Error := TErreur.Create;
                Error.AddError(lstTemoin[i].FileName,'FTP','Structure du nom de fichier incorrecte',0,teGetFtp,0,'');
                GERREURS.Add(Error);


                for j := (i + 1) to lstTemoin.Count -1 do
                begin
                  Error := TErreur.Create;
                  Error.AddError(lstTemoin[j].FileName,'FTP','Fichier non traité à cause d''une erreur d''un fichier précédent',0,teGetFtpWarning,0,'');
                  GERREURS.Add(Error);
                end;
                {$ENDREGION}

                // On passe au fichier suivant
                Break;
              end;

              FilesList.Clear;
              {$REGION 'Récupération des fichiers qui match le témoin'}
              ElSimpleSFTPClient.ListDirectory( RemotePath, FilesList, Format( '*%s*.%s*', [ AMAGNUM, lstTemoin[i].Date ]), False, True, False );
              try
                // Téléchargement des fichiers UN par UN
                for j := 0 to Pred( FilesList.Count ) do
                begin
                  Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
                    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Téléchargement...', [ TElSftpFileInfo( FilesList[j]).Name ] ), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

                  ElSimpleSFTPClient.DownloadFile(
                    RemotePath + TElSftpFileInfo( FilesList[j]).Name,
                    GAPPFTP + TElSftpFileInfo( FilesList[j]).Name,
                    ftmOverwrite // cf: documentation/ref_type_sbfiletransfermode.html#declared
                  );

                  Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
                    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Téléchargé', [ TElSftpFileInfo( FilesList[j]).Name ] ), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                end;


                // Suppression des fichiers du Sftp
                if IniStruct.SFTPDir.DeleteFileFromFTP then
                begin
                  // TODO: Mettre en place la suppression des fichiers sur le FTP s'il n'y a pas eu d'erreur)
                  ElSimpleSFTPClient.RemoveFiles(RemotePath,Format( '*%s.*.%s', [AMAGNUM,lstTemoin[i].Date]),False,False);
                end;
              Except on E:eXception do
                begin
                  Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
                    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : %s', [ TElSftpFileInfo( FilesList[j]).Name, E.Message ] ), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

                  Error := TErreur.Create;
                  Error.AddError(lstTemoin[i].FileName,'FTP','Erreur lors de la récupération des fichiers : ' + E.Message,0,teGetFtp,0,'');
                  GERREURS.Add(Error);

                  for j := (i + 1) to lstTemoin.Count -1 do
                  begin
                    Error := TErreur.Create;
                    Error.AddError(lstTemoin[j].FileName,'FTP','Fichier non traité à cause d''une erreur d''un fichier précédent',0,teGetFtpWarning,0,'');
                    GERREURS.Add(Error);
                  end;
                // Suppression de tous les fichiers correspondant dans le répertoire
                  lstDelete := GetFileFromDir(GAPPFTP, '*' + AMAGNUM + '*.' + lstTemoin[i].Date);
                  try
                    for j := 0 to lstDelete.Count -1 do
                      if FileExists(GAPPFTP + lstDelete[j]) then
                        DeleteFile(GAPPFTP + lstDelete[j]);
                  finally
                    lstDelete.Free;
                  end;
                  // Arret de la procédure en cours
                  Break;
                end;
              end;
              {$ENDREGION}
            end;
            Result := True;
          finally
            FilesList.Free;
            lstDecoupe.Free;
            lstTemoin.Free;
          end;
          bContinue := True;
        except on E:Exception do
          begin
            if iTentative >= 5 then
            begin
              raise Exception.Create('Nombre de tentatives dépassées : ' + E.Message);
            end
            else begin
              bContinue := False;
              Inc(iTentative);
              Sleep(10000); // 10s
            end;
          end;
        End;
      until bContinue;
    end
    else
    begin
      raise Exception.CreateFmt('Le repertoire "%s" est inexistant',[ RemotePath ]);
    end;
  except
    on E: EIdReplyRFCError do
      raise EIdReplyRFCError.Create('Pas de fichier à traiter');
    on E: Exception do
    begin

      raise Exception.Create('GetFileFromSFTP -> ' + E.Message);
    end;
  end;
end;

function TDM_GSDataImport.LoadCsvToCDS(AFileName: String; ACDS : TClientDataset; AEmpty : Boolean): Boolean;
var
  lstFile, lstCsv : TStringList;
  i, j : integer;
begin
  Result := False;

  // Vidage du CSD si besoin
  if AEmpty then
    ACDS.EmptyDataSet;

  try
    lstFile := TStringList.Create;
    lstCsv  := TStringList.Create;
    Try
      // chargement du ficheir en mémoire
      lstFile.LoadFromFile(AFileName);
      for i := 0 to lstFile.Count -1 do
      begin
        // copuie dans le cds
        lstCsv.Text := StringReplace(lstFile[i], '|',#13#10,[rfReplaceAll]);
        With ACDS do
        begin
          Append;
          for j := 0 to lstCsv.Count -1 do
//            if j < Fields.Count - 1 then
              Fields.Fields[j].AsString := lstCsv[j];
          Post;
          Application.ProcessMessages ;
        end;
      end;

      Result := True;
    Finally
      lstFile.Free;
      lstCsv.Free;
    End;
  Except on E:exception do
    raise Exception.Create('LoadCsvToCDS -> ' + ExtractFileName(AFileName) + ' : ' + E.Message);
  end;
end;

function TDM_GSDataImport.OpenFTP: Boolean;
var
  Error: TErreur;
begin
  Result := False;
  Try
    // configuration du FTP
    if IdFTP.Connected then
      IdFTP.Disconnect;

    IdFTP.Host := IniStruct.FTP.Host;
    IdFTP.Username := IniStruct.FTP.UserName;
    IdFTP.Password := IniStruct.FTP.PassWord;
    IDFTP.Port := IniStruct.FTP.Port;
    IdFTP.Passive := IniStruct.FTP.Passif;
    if IniStruct.FTP.SSL then
      IdFTP.IOHandler := IdOpenSSL
    else
      IdFTP.IOHandler := nil;

    IdFTP.Connect;
    Result := True;
  Except
    on E:Exception do
    begin
      Error := TErreur.Create;
      Error.AddError('','FTP',E.Message,0,teGetFtp,0,'');
      GERREURS.Add(Error);
      raise Exception.Create('OpenFTP -> ' + E.Message);
    end;
  End;
end;

function TDM_GSDataImport.OpenSFTP: Boolean;
var
  Error: TErreur;
  iTentative : Integer;
begin
  Result := False;
  iTentative := 1;
  Repeat
    try
      CloseSFTP;
      // configuration du SFTP
      ElSimpleSFTPClient.Address                              := IniStruct.SFTP.Host;
      ElSimpleSFTPClient.Username                             := IniStruct.SFTP.UserName;
      ElSimpleSFTPClient.Password                             := IniStruct.SFTP.PassWord;
      ElSimpleSFTPClient.Port                                 := IniStruct.SFTP.Port;
      ElSimpleSFTPClient.CompressionAlgorithms[ SSH_CA_ZLIB ] := True;
      ElSimpleSFTPClient.AuthenticationTypes                  := ElSimpleSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;
      ElSimpleSFTPClient.Open;
      Result := True;
    except
      on E:Exception do
      begin
        if iTentative >= 5 then
        begin
          Error := TErreur.Create;
          Error.AddError('','FTP',E.Message,0,teGetFtp,0,'');
          GERREURS.Add(Error);
          raise Exception.Create('OpenSFTP -> ' + E.Message);
        end
        else begin
          Result := False;
          Inc(iTentative);
          Sleep(10000); // 10s
        end;
      end;
    end;
  Until Result;
end;

{ TFTPData }

procedure TFTPData.DecoupeFilename;
var
  lst : TStringList;
begin
  lst := TStringList.Create;
  try
    lst.Text := StringReplace(FileName,'.',#13#10,[rfReplaceAll]);
    if lst.Count = 3 then
    begin
      Temoin := lst[0];
      Number := lst[1];
      Date   := lst[2];
      OnError := False;
    end
    else begin
      OnError := True;
      Date := lst[lst.Count -1];
    end;
  finally
    lst.free;
  end;
end;

{ TTemoinCompare }

function TTemoinCompare.Compare(const Left, Right: TFTPData): Integer;
begin
  Result := CompareText(Left.Date,Right.Date);
end;

end.

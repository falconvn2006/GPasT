unit CopierTable;

interface

uses
  Contnrs, IB_Components, IBODataSet, SysUtils, Dialogs, Constante_CBR,
  Main_Frm, MonitorConsolide_DM, Maintenance_DM, Yellis_DM, DB, DBClient,
  StrUtils, Erreur_CBR, Variants;

  function  IndiqueCDSACopier(vpTable : TTypeMaTable) : TClientDataSet;
  function  IndiqueOldId(vpTable : TTypeMaTable; vpCDS : TClientDataSet) : Integer;

  procedure RenseignerLog(vpTable, vpRef, vpDetailErreur : String;
                          vpNumeroLigne, vpIdTable : Integer);

  procedure RenseignerTable(vpTable : TTypeMaTable;
                            vpIdTraite, vpIdTraiteSansErreur : Integer);

  function  GenID(vpGenerateur : String) : Integer;
  function  ViderTable(vpQuery : TIB_Cursor; vpProvenance : TTypeTableProvenance) : Boolean;

  function  IntegrerLaTableVersMaintenance(vpTable : TTypeMaTable;
                                           vpQuery : TIB_Cursor) : Boolean;

  function  Add_SQL(vpTable : TTypeMaTable; vpCDS : TClientDataSet;
                    vpQueryDestination : TIB_Cursor) : Integer;

  function  SQL_Version   (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_Fichiers  (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_PlageMAJ  (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_Histo     (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_Specifique(vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;

  function  SQL_SRV   (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_GRP   (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_FOLDER(vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_HDB   (vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_RAISON(vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  function  SQL_SENDER(vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;

implementation


//------------------------------------------------------------------------------
//                                                   +-------------------------+
//                                                   |   INTEGRER LES TABLES   |
//                                                   +-------------------------+
//------------------------------------------------------------------------------
{$REGION ' Intégrer les tables '}
//-----------------------------------------------------------> CopierLaTable

function IntegrerLaTableVersMaintenance(vpTable : TTypeMaTable;
vpQuery : TIB_Cursor) : Boolean;
var
  vLig, vNbLigne, vNewId, vOldId : Integer;
  vNbErreur, vNbTraite     : Integer;
  vIdSansErreur, vIdTraite : Integer;
  vDetailErreur : String;
  vCDSACopier   : TClientDataSet;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result        := False;
  vNbErreur     := 0;
  vNbTraite     := 0;
  vIdTraite     := vpTable.Last_IdSVG;
  vIdSansErreur := vpTable.Last_IdSVG;
  vDetailErreur := '';

  // Si le vidage de la table a échoué, on sort
  if not ViderTable(vpQuery, vpTable.TypeProvenance) then
  begin
    RenseignerLog(vpTable.Libelle, 'Vidage', 'Impossible de vider la table', 0, 0);
    Exit;
  end;

  // va indiquer le CDS à copier
  vCDSACopier := IndiqueCDSACopier(vpTable);

  // Si l'initialisation du CDS a échoué, on sort
  if vCDSACopier = nil then
  begin
    ShowMessage('Table non trouvée');
    Exit;
  end;

  // on se place sur le premier enregistrement du CDS
  vCDSACopier.First;

  {$ENDREGION ' Initialisation des variables '}

  // on parcourt le CDS et on le copie en base
  while not vCDSACopier.Eof do
  begin
    vpQuery.SQL.Clear;

    try
      // on écrit la commande SQL.text et on ramène l'ID de la ligne à insérer
      vNewId := Add_SQL(vpTable, vCDSACopier, vpQuery);

      // si l'enregistrement s'est bien passé, on enregistre le nouvel Id dans le CDS
      if vNewId <> 0 then
      begin
        vpQuery.IB_Transaction.StartTransaction;

        // Attention!!!! l'execution de la requête se fait ici pour pouvoir
        // capter les erreurs et les traiter de manière globale
        vpQuery.ExecSQL;
        vpQuery.Close;

        vpQuery.IB_Transaction.Commit;

        // on indique le nouvel Id dans le ClientDataSet pour les clés étrangères
        vCDSACopier.Edit;
        vCDSACopier.FieldByName('NewId').AsInteger := vNewId;
        vCDSACopier.Post;

        vIdTraite := vNewId;
      end;
    except
      INC(vNbErreur);

      // indique l'id initiale en fonction de la provenance
      vOldId := IndiqueOldId(vpTable, vCDSACopier);

      vIdSansErreur := vIdTraite;
      vDetailErreur := vDetailErreur + ',' + IntToStr(vOldId);

      vpQuery.IB_Transaction.RollBack;
    end;

    INC(vNbTraite);

    vCDSACopier.Next;
  end;

  // On stock les infos pour les logs et pour la table pour l'enregistrer ensuite
  RenseignerTable(vpTable, vIdTraite, vIdSansErreur);

  if Trim(vDetailErreur) <> '' then
    vDetailErreur := ' Id en erreur : ' + vDetailErreur + chr(13);

  RenseignerLog(vpTable.Libelle, 'Resumé de migration', vDetailErreur
               + ' - nb de lignes traitées : ' + IntToStr(vNbTraite)
               + ' (' + IntToStr(vNbTraite - vNbErreur) + ' Succès / '
               + IntToStr(vNbErreur) + ' Erreurs )',0, 0);

  Result := True;
end;
{$ENDREGION ' Intégrer les tables '}

//------------------------------------------------------------------------------
//                                                                 +-----------+
//                                                                 |    LOG    |
//                                                                 +-----------+
//------------------------------------------------------------------------------
{$REGION ' LOG '}

//---------------------------------------------------------> RenseignerTable

procedure RenseignerTable(vpTable : TTypeMaTable;
vpIdTraite, vpIdTraiteSansErreur : Integer);
begin
  vpTable.Last_Id    := vpIdTraite;
  vpTable.Last_IdSVG := vpIdTraiteSansErreur;

  if vgIniFile <> nil then
  begin
    vgIniFile.WriteString(vpTable.Libelle, 'LAST_ID', IntToStr(vpTable.Last_Id));
    vgIniFile.WriteString(vpTable.Libelle, 'LAST_IDSVG', IntToStr(vpTable.Last_IdSVG));
  end;
end;

//-----------------------------------------------------------> RenseignerLog

procedure RenseignerLog(vpTable, vpRef, vpDetailErreur : String;
vpNumeroLigne, vpIdTable : Integer);
var
  vErreur : TErreur;
begin
  vErreur := TErreur.Create;

  vErreur.AddError(vpTable, vpRef, vpDetailErreur, vpNumeroLigne, vpIdTable);

  vgObjlLog.Add(vErreur);
end;

{$ENDREGION ' LOG '}

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   ACTION TABLE   |
//                                                          +------------------+
//------------------------------------------------------------------------------
{$REGION ' Action Table '}

//-------------------------------------------------------------------> GenID

function GenID(vpGenerateur : String) : Integer;
begin
  Result := 0;

  try
    with FMaintenance_DM do
    begin
      stp_NewId.Close;
      stp_NewId.Prepared := True;
      stp_NewId.ParamByName('NOM_GENERATEUR').AsString := vpGenerateur;

      stp_NewId.ExecProc;

      Result := stp_NewId.ParamByName('ID').AsInteger;

      stp_NewId.Close;
      stp_NewId.Unprepare;
    end;
  except
    on E : Exception do
    begin
      Raise Exception.Create(E.Message);
      Result := -1;
    end;
  end;
end;

//--------------------------------------------------------------> ViderTable

function ViderTable(vpQuery : TIB_Cursor; vpProvenance : TTypeTableProvenance) : Boolean;
var
  vNomTable : String;
begin
  vNomTable := '';

  // on change les noms pour qu'ils correspondent à la dénomination de la base Maintenance
  case vpProvenance of
    tpClients, tpEmetteur : vNomTable := 'EMETTEUR';
    tpPlageMAJ   : vNomTable := 'PLAGEMAJ';
    tpHDB        : vNomTable := 'HDB';
    tpRAISON     : vNomTable := 'RAISON';
    tpDossier    : vNomTable := 'DOSSIER';
    tpFichiers   : vNomTable := 'FICHIERS';
    tpVersion    : vNomTable := 'VERSION';
    tpHisto      : vNomTable := 'HISTO';
    tpSpecifique : vNomTable := 'SPECIFIQUE';
    tpSRV        : vNomTable := 'SRV';
    tpGRP        : vNomTable := 'GRP';
  end;

  if vNomTable = '' then
  begin
    Result := False;
    Exit;
  end;

  // on vide la table pour repartir sur une table vierge
  with vpQuery do
  begin
    SQL.Clear;
    IB_Transaction.StartTransaction;

    try
      try
        SQL.Add(' DELETE');
        SQL.Add(' FROM ' + vNomTable);

        ExecSQL;

        Close;

        IB_Transaction.Commit;

        Result := True;
      except
        Result := False;

        IB_Transaction.RollBack;
      end;

    finally
      //
    end;
  end;
end;
{$ENDREGION ' Action Table '}

//------------------------------------------------------------------------------
//                                                           +-----------------+
//                                                           |   INDICATION    |
//                                                           +-----------------+
//------------------------------------------------------------------------------
{$REGION ' Indication '}
//-----------------------------------------------------> IndiqueTableACopier

function IndiqueCDSACopier(vpTable : TTypeMaTable) : TClientDataSet;
var
  vMonCDS : TClientDataSet;
begin
  vMonCDS := nil;

  case vpTable.TypeProvenance of
    tpClients    : vMonCDS := FYellis_DM.CDS_Clients;
    tpFichiers   : vMonCDS := FYellis_DM.CDS_Fichiers;
    tpHisto      : vMonCDS := FYellis_DM.CDS_Histo;
    tpPlageMAJ   : vMonCDS := FYellis_DM.CDS_PlageMAJ;
    tpSpecifique : vMonCDS := FYellis_DM.CDS_Specifique;
    tpVersion    : vMonCDS := FYellis_DM.CDS_Version;
    tpEmetteur   : vMonCDS := FMonitorConsolide_DM.CDS_SENDER;
    tpDossier    : vMonCDS := FMonitorConsolide_DM.CDS_FOLDER;
    tpSRV        : vMonCDS := FMonitorConsolide_DM.CDS_SRV;
    tpGRP        : vMonCDS := FMonitorConsolide_DM.CDS_GRP;
    tpHDB        : vMonCDS := FMonitorConsolide_DM.CDS_HDB;
    tpRAISON     : vMonCDS := FMonitorConsolide_DM.CDS_RAISON;
  end;

  Result := vMonCDS;
end;

//------------------------------------------------------------> IndiqueOldId

function IndiqueOldId(vpTable : TTypeMaTable;
vpCDS : TClientDataSet) : Integer;
begin
  Result := 0;

  // selon le type de l'objet "table", on va ramener l'Id correspondant
  case vpTable.TypeProvenance of
    tpClients    : Result := vpCDS.FieldByName('ID').AsInteger;
    tpFichiers   : Result := vpCDS.FieldByName('ID_FIC').AsInteger;
    tpHisto      : Result := vpCDS.FieldByName('ID').AsInteger;
    tpPlageMAJ   : Result := vpCDS.FieldByName('PLG_ID').AsInteger;
    tpSpecifique : Result := vpCDS.FieldByName('SPE_ID').AsInteger;
    tpVersion    : Result := vpCDS.FieldByName('ID').AsInteger;
    tpEmetteur   : Result := vpCDS.FieldByName('SENDER_ID').AsInteger;
    tpDossier    : Result := vpCDS.FieldByName('FLD_ID').AsInteger;
    tpSRV        : Result := vpCDS.FieldByName('SRV_ID').AsInteger;
    tpGRP        : Result := vpCDS.FieldByName('GRP_ID').AsInteger;
    tpHDB        : Result := vpCDS.FieldByName('HDB_ID').AsInteger;
    tpRAISON     : Result := vpCDS.FieldByName('RAISON_ID').AsInteger;
  end;
end;

{$ENDREGION ' Indication '}

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   ECRITURE SQL   |
//                                                          +------------------+
//------------------------------------------------------------------------------
{$REGION ' Ecriture SQL '}
//-----------------------------------------------------------------> Add_SQL

function Add_SQL(vpTable : TTypeMaTable; vpCDS : TClientDataSet;
  vpQueryDestination : TIB_Cursor) : Integer;
begin
  Result := 0;

  // selon le type de l'objet "table", on va ramener la requete SQL correpondante
  case vpTable.TypeProvenance of
    tpFichiers   : Result := SQL_Fichiers  (vpCDS, vpQueryDestination);
    tpHisto      : Result := SQL_Histo     (vpCDS, vpQueryDestination);
    tpPlageMAJ   : Result := SQL_PlageMAJ  (vpCDS, vpQueryDestination);
    tpSpecifique : Result := SQL_Specifique(vpCDS, vpQueryDestination);
    tpVersion    : Result := SQL_Version   (vpCDS, vpQueryDestination);
    tpEmetteur   : Result := SQL_SENDER    (vpCDS, vpQueryDestination);
    tpDossier    : Result := SQL_FOLDER    (vpCDS, vpQueryDestination);
    tpSRV        : Result := SQL_SRV       (vpCDS, vpQueryDestination);
    tpGRP        : Result := SQL_GRP       (vpCDS, vpQueryDestination);
    tpHDB        : Result := SQL_HDB       (vpCDS, vpQueryDestination);
    tpRAISON     : Result := SQL_RAISON    (vpCDS, vpQueryDestination);
  end;
end;

//------------------------------------------------------------------------------
//                                          +----------------------------------+
//                                          |   ECRITURE SQL - CONSO-MONITOR   |
//                                          +----------------------------------+
//------------------------------------------------------------------------------
{$REGION ' Ecriture SQL - Conso-Monitor'}
//-----------------------------------------------------------------> SQL_GRP

function SQL_GRP(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
begin
  vNewId := 0;

  // on va copier l'enregistrement de la table GRP de ConsoMonitor vers Maintenance
  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('GRP');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO GRP ');
      SQL.Add(' (GRP_ID, GRP_NOM)');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PNOM)');

      ParamCheck := True;
      ParamByName('PID').AsInteger := vNewId;
      ParamByName('PNOM').AsString := vpCDS.FieldByName('GRP_NOM').AsString;
    end;
  end;

  Result := vNewId;
end;

//-----------------------------------------------------------------> SQL_SRV

function SQL_SRV(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
begin
  vNewId := 0;

  // on va copier l'enregistrement de la table SRV de ConsoMonitor vers Maintenance
  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('SRV');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO SRV ');
      SQL.Add(' (SRV_ID, SRV_NOM, SRV_IP) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PNOM, :PIP)');

      ParamCheck := True;
      ParamByName('PID').AsInteger := vNewId;
      ParamByName('PNOM').AsString := vpCDS.FieldByName('SRV_NAME').AsString;
      ParamByName('PIP').AsString  := vpCDS.FieldByName('SRV_IP').AsString;
    end;
  end;

  Result := vNewId;
end;

//--------------------------------------------------------------> SQL_FOLDER

function SQL_FOLDER(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
  vOldIdSRV, vOldIdGRP : Integer;
  vNewIdSRV, vNewIdGRP : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result    := 0;
  vNewId    := 0;
  vNewIdSRV := 0;
  vNewIdGRP := 0;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdSRV := vpCDS.FieldByName('SRV_ID').AsInteger;
  vOldIdGRP := vpCDS.FieldByName('GRP_ID').AsInteger;

  // On recupérè les Id nouvellement crées
  if FMonitorConsolide_DM.cds_SRV.Locate('SRV_ID', vOldIdSRV, []) then
    vNewIdSRV := FMonitorConsolide_DM.cds_SRV.FieldByName('NewId').AsInteger;

  if FMonitorConsolide_DM.cds_GRP.Locate('GRP_ID', vOldIdGRP, []) then
    vNewIdGRP := FMonitorConsolide_DM.cds_GRP.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if (vNewIdSRV = 0) or (vNewIdGRP = 0) then
    Exit;

  {$ENDREGION}

  // on va copier l'enregistrement de la table FOLDER de ConsoMonitor vers Maintenance
  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('DOSSIER');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO DOSSIER ');
      SQL.Add(' (DOS_ID, DOS_DATABASE, SRV_ID, DOS_CHEMIN, GRP_ID, DOS_INSTALL, ');
      SQL.Add('  DOS_VIP, DOS_PLATEFORME, DOS_EMAIL) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PDATABASE, :PSRV_ID, :PCHEMIN, :PGRP_ID, :PINSTALL, ');
      SQL.Add('  :PVIP, :PPLATEFORME, :PEMAIL)');

      ParamCheck := True;
      ParamByName('PID').AsInteger        := vNewId;
      ParamByName('PDATABASE').AsString   := vpCDS.FieldByName('FLD_DATABASE').AsString;
      ParamByName('PSRV_ID').AsInteger    := vNewIdSRV;
      ParamByName('PCHEMIN').AsString     := vpCDS.FieldByName('FLD_PATH').AsString;
      ParamByName('PGRP_ID').AsInteger    := vNewIdGRP;
      ParamByName('PINSTALL').AsDateTime  := vpCDS.FieldByName('FLD_INSTALL').AsDateTime;
      ParamByName('PVIP').AsInteger       := 0;
      ParamByName('PPLATEFORME').AsString := '';
      ParamByName('PEMAIL').AsString      := '';
    end;
  end;

  Result := vNewId;
end;

//--------------------------------------------------------------> SQL_RAISON

function SQL_RAISON(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
begin
  vNewId := 0;

  // on va copier l'enregistrement de la table RAISON de ConsoMonitor vers Maintenance
  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('RAISON');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO RAISON ');
      SQL.Add(' (RAISON_ID, RAISON_NOM)');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PNOM)');

      ParamCheck := True;
      ParamByName('PID').AsInteger := vNewId;
      ParamByName('PNOM').AsString := vpCDS.FieldByName('RAISON_NAME').AsString;
    end;
  end;

  Result := vNewId;
end;

//-----------------------------------------------------------------> SQL_HDB

function SQL_HDB(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
  vOldIdSENDER, vOldIdRAISON : Integer;
  vNewIdSENDER, vNewIdRAISON : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result       := 0;
  vNewId       := 0;
  vNewIdSENDER := 0;
  vNewIdRAISON := 0;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdSENDER := vpCDS.FieldByName('SENDER_ID').AsInteger;
  vOldIdRAISON := vpCDS.FieldByName('RAISON_ID').AsInteger;

  // On recupérè les Id nouvellement crées
  if FMonitorConsolide_DM.cds_SENDER.Locate('SENDER_ID', vOldIdSENDER, []) then
    vNewIdSENDER := FMonitorConsolide_DM.cds_SENDER.FieldByName('NewId').AsInteger;

  if FMonitorConsolide_DM.cds_RAISON.Locate('RAISON_ID', vOldIdRAISON, []) then
    vNewIdRAISON := FMonitorConsolide_DM.cds_RAISON.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if (vNewIdSENDER = 0) or (vNewIdRAISON = 0) then
    Exit;

  {$ENDREGION}

  // on va copier l'enregistrement de la table FOLDER de ConsoMonitor vers Maintenance
  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('HDB');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO HDB ');
      SQL.Add(' (HDB_ID, SENDER_ID, HDB_CYCLE, HDB_OK, RAISON_ID, ');
      SQL.Add('  HDB_COMENTAIRE, HDB_ARCHIVER, HDB_DATE) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PSENDER_ID, :PCYCLE, :POK, :PRAISON_ID, ');
      SQL.Add('  :PCOMENTAIRE, :PARCHIVER, :PDATE)');

      ParamCheck := True;
      ParamByName('PID').AsInteger        := vNewId;
      ParamByName('PSENDER_ID').AsInteger := vNewIdSENDER;
      ParamByName('PCYCLE').AsDateTime    := vpCDS.FieldByName('HDB_CYCLE').AsDateTime;
      ParamByName('POK').AsInteger        := vpCDS.FieldByName('HDB_OK').AsInteger;
      ParamByName('PRAISON_ID').AsInteger := vNewIdRAISON;
      ParamByName('PCOMENTAIRE').AsString := vpCDS.FieldByName('HDB_COMENTAIRE').AsString;
      ParamByName('PARCHIVER').AsInteger  := vpCDS.FieldByName('HDB_ARCHIVER').AsInteger;
      ParamByName('PDATE').AsDateTime     := vpCDS.FieldByName('HDB_DATE').AsDateTime;
    end;
  end;

  Result := vNewId;
end;

//--------------------------------------------------------------> SQL_SENDER

function SQL_SENDER(vpCDS : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId      : Integer;
  vSenderName: String;
  vOldIdFOLDER, vNewIdFOLDER   : Integer;
  vOldIdVERSION, vNewIdVERSION : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result        := 0;
  vNewId        := 0;
  vNewIdFOLDER  := 0;
  vNewIdVERSION := 0;

  vSenderName   := vpCDS.FieldByName('SENDER_NAME').AsString;

  // si on ne trouve pas le nom dans la base yellis, on n'enregistre pas en base.
  // Par contre, on le note comme étant "Orphelin" pour un contrôle ultérieur
  if not FYellis_DM.cds_Clients.Locate('nom', vSenderName, [loCaseInsensitive]) then
  begin
    vpCDS.Edit;
    vpCDS.FieldByName('EstOrphelin').AsBoolean := True;
    vpCDS.Post;

    Exit;
  end;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdFOLDER  := vpCDS.FieldByName('FLD_ID').AsInteger;
  vOldIdVERSION := FYellis_DM.cds_Clients.FieldByName('version').AsInteger;

  // On recupérè les Id nouvellement crées
  if FMonitorConsolide_DM.cds_FOLDER.Locate('FLD_ID', vOldIdFOLDER, []) then
    vNewIdFOLDER := FMonitorConsolide_DM.cds_FOLDER.FieldByName('NewId').AsInteger;

  // On recupérè les Id nouvellement crées
  if FYellis_DM.cds_Version.Locate('id', vOldIdVERSION, []) then
    vNewIdVERSION := FYellis_DM.cds_Version.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if (vNewIdVERSION = 0) or (vNewIdFOLDER = 0) then
    Exit;

  {$ENDREGION}

  // Si on trouve les mêmes noms dans ConsoMonitor et Yellis, on copie vers Maintenance
  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('EMETTEUR');

    {$REGION ' Insertion en base '}
    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO EMETTEUR ');
      SQL.Add(' (EMET_ID, EMET_NOM, EMET_DONNEES, DOS_ID, EMET_INSTALL, EMET_MAGID, ');
      SQL.Add('  EMET_GUID, VER_ID, EMET_PATCH, EMET_VERSION_MAX, EMET_SPE_PATCH, ');
      SQL.Add('  EMET_SPE_FAIT, EMET_BCKOK, EMET_DERNBCK, EMET_RESBCK) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PNOM, :PDONNEES, :PDOS_ID, :PINSTALL, :PMAGID, ');
      SQL.Add('  :PGUID, :PVER_ID, :PPATCH, :PVERSION_MAX, :PSPE_PATCH, ');
      SQL.Add('  :PSPE_FAIT, :PBCKOK, :PDERNBCK, :PRESBCK) ');

      ParamCheck := True;
      // Champs ConsoMonitor
      ParamByName('PID').AsInteger          := vNewId;
      ParamByName('PNOM').AsString          := vSenderName;
      ParamByName('PDONNEES').AsString      := vpCDS.FieldByName('SENDER_DATA').AsString;
      ParamByName('PDOS_ID').AsInteger      := vNewIdFOLDER;
      ParamByName('PINSTALL').AsDateTime    := vpCDS.FieldByName('SENDER_INSTALL').AsDateTime;
      ParamByName('PMAGID').AsInteger       := vpCDS.FieldByName('SENDER_MAGID').AsInteger;

      // Champs Yellis
      ParamByName('PGUID').AsString         := FYellis_DM.cds_Clients.FieldByName('clt_guid').AsString;
      ParamByName('PVER_ID').AsInteger      := vNewIdVERSION;
      ParamByName('PPATCH').AsInteger       := FYellis_DM.cds_Clients.FieldByName('patch').AsInteger;
      ParamByName('PVERSION_MAX').AsInteger := FYellis_DM.cds_Clients.FieldByName('version_max').AsInteger;
      ParamByName('PSPE_PATCH').AsInteger   := FYellis_DM.cds_Clients.FieldByName('spe_patch').AsInteger;
      ParamByName('PSPE_FAIT').AsInteger    := FYellis_DM.cds_Clients.FieldByName('spe_fait').AsInteger;
      ParamByName('PBCKOK').AsDateTime      := FYellis_DM.cds_Clients.FieldByName('bckok').AsDateTime;
      ParamByName('PDERNBCK').AsDateTime    := FYellis_DM.cds_Clients.FieldByName('dernbck').AsDateTime;
      ParamByName('PRESBCK').AsString       := FYellis_DM.cds_Clients.FieldByName('resbck').AsString;

      // on copie aussi le nouvel Id dans le CDS_clients de la base Yellis
      FYellis_DM.cds_Clients.Edit;
      FYellis_DM.cds_Clients.FieldByName('NewId').AsInteger := vNewId;
      FYellis_DM.cds_Clients.Post;

      {$ENDREGION ' Insertion en base '}
    end;
  end;

  Result := vNewId;
end;

{$ENDREGION ' Ecriture SQL - Conso-Monitor'}

//------------------------------------------------------------------------------
//                                                 +---------------------------+
//                                                 |   ECRITURE SQL - YELLIS   |
//                                                 +---------------------------+
//------------------------------------------------------------------------------
{$REGION ' Ecriture SQL - Yellis'}

//-------------------------------------------------------------> SQL_Version

function SQL_Version(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
begin
  vNewId := 0;

  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('VERSION');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO VERSION ');
      SQL.Add(' (VER_ID, VER_VERSION, VER_NOMVERSION, VER_PATCH, VER_EAI) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PVERSION, :PNOMVERSION, :PPATCH, :PEAI) ');

      ParamCheck := True;
      ParamByName('PID').AsInteger        := vNewId;
      ParamByName('PVERSION').AsString    := vpCDS.FieldByName('version').AsString;
      ParamByName('PNOMVERSION').AsString := vpCDS.FieldByName('nomversion').AsString;
      ParamByName('PPATCH').AsInteger     := vpCDS.FieldByName('patch').AsInteger;
      ParamByName('PEAI').AsString        := vpCDS.FieldByName('EAI').AsString;
    end;
  end;

  Result := vNewId;
end;

//------------------------------------------------------------> SQL_Fichiers

function SQL_Fichiers(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
  vOldIdVERSION, vNewIdVERSION : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result        := 0;
  vNewId        := 0;
  vNewIdVERSION := 0;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdVERSION := vpCDS.FieldByName('id_ver').AsInteger;

  // On recupérè les Id nouvellement crées
  if FYellis_DM.cds_VERSION.Locate('id', vOldIdVERSION, []) then
    vNewIdVERSION := FYellis_DM.cds_VERSION.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if vNewIdVERSION = 0 then
    Exit;

 {$ENDREGION ' Initialisation des variables '}

  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('FICHIERS');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO FICHIERS ');
      SQL.Add(' (FIC_ID, VER_ID, FIC_FICHIER, FIC_CRC) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PVER_ID, :PFICHIER, :PCRC) ');

      ParamCheck := True;
      ParamByName('PID').AsInteger     := vNewId;
      ParamByName('PVER_ID').AsInteger := vNewIdVERSION;
      ParamByName('PFICHIER').AsString := vpCDS.FieldByName('fichier').AsString;
      ParamByName('PCRC').AsString     := vpCDS.FieldByName('crc').AsString;
    end;
  end;

  Result := vNewId;
end;

//------------------------------------------------------------> SQL_PlageMAJ

function SQL_PlageMAJ(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
  vOldIdCLIENT, vNewIdCLIENT : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result       := 0;
  vNewId       := 0;
  vNewIdCLIENT := 0;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdCLIENT := vpCDS.FieldByName('plg_cltid').AsInteger;

  // On recupérè les Id nouvellement crées
  if FYellis_DM.cds_Clients.Locate('id', vOldIdCLIENT, []) then
    vNewIdCLIENT := FYellis_DM.cds_Clients.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if vNewIdCLIENT = 0 then
    Exit;

 {$ENDREGION ' Initialisation des variables '}

  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('PLAGEMAJ');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO  PLAGEMAJ');
      SQL.Add(' (PLG_ID, EMET_ID, PLG_DATEDEB, PLG_DATEFIN, PLG_VERSIONMAX) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PEMET_ID, :PDATEDEB, :PDATEFIN, :PVERSIONMAX) ');

      ParamCheck := True;
      ParamByName('PID').AsInteger         := vNewId;
      ParamByName('PEMET_ID').AsInteger    := vNewIdCLIENT;
      ParamByName('PDATEDEB').AsDateTime   := vpCDS.FieldByName('plg_datedeb').AsDateTime;
      ParamByName('PDATEFIN').AsDateTime   := vpCDS.FieldByName('plg_datefin').AsDateTime;
      ParamByName('PVERSIONMAX').AsInteger := vpCDS.FieldByName('plg_versionmax').AsInteger;
    end;
  end;

  Result := vNewId;
end;

//----------------------------------------------------------> SQL_Specifique

function SQL_Specifique(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
  vOldIdCLIENT, vNewIdCLIENT : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  Result       := 0;
  vNewId       := 0;
  vNewIdCLIENT := 0;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdCLIENT := vpCDS.FieldByName('spe_cltid').AsInteger;

  // On recupérè les Id nouvellement crées
  if FYellis_DM.cds_Clients.Locate('id', vOldIdCLIENT, []) then
    vNewIdCLIENT := FYellis_DM.cds_Clients.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if vNewIdCLIENT = 0 then
    Exit;

  {$ENDREGION ' Initialisation des variables '}

  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('SPECIFIQUE');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO SPECIFIQUE ');
      SQL.Add(' (SPE_ID, EMET_ID, SPE_FICHIER, SPE_FAIT, SPE_DATE) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PEMET_ID, :PFICHIER, :PFAIT, :PDATE) ');

      ParamCheck := True;
      ParamByName('PID').AsInteger      := vNewId;
      ParamByName('PEMET_ID').AsInteger := vNewIdCLIENT;
      ParamByName('PFICHIER').AsString  := vpCDS.FieldByName('spe_fichier').AsString;
      ParamByName('PFAIT').AsInteger    := vpCDS.FieldByName('spe_fait').AsInteger;
      ParamByName('PDATE').AsDateTime   := vpCDS.FieldByName('spe_date').AsDateTime;
    end;
  end;

  Result := vNewId;
end;

//---------------------------------------------------------------> SQL_Histo

function SQL_Histo(vpCDS : TClientDataSet;
vpQueryDestination : TIB_Cursor) : Integer;
var
  vNewId : Integer;
  vOldIdCLIENT, vNewIdCLIENT : Integer;
begin

  {$REGION ' Initialisation des variables. >> Attention ! Sortie possible << '}
  vNewId       := 0;
  vNewIdCLIENT := 0;

  // on stocke les anciennes valeurs de clés étrangères
  vOldIdCLIENT := vpCDS.FieldByName('id_cli').AsInteger;

  // On recupérè les Id nouvellement crées
  if FYellis_DM.cds_Clients.Locate('id', vOldIdCLIENT, []) then
    vNewIdCLIENT := FYellis_DM.cds_Clients.FieldByName('NewId').AsInteger;

  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
  // plus de ligne associée. Il ne faut donc pas l'enregister en base
  if vNewIdCLIENT = 0 then
    Exit;

 {$ENDREGION ' Initialisation des variables '}

  with vpQueryDestination do
  begin
    SQL.Clear;

    vNewId := GenID('HISTO');

    if vNewId <> 0 then
    begin
      SQL.Add(' INSERT INTO HISTO ');
      SQL.Add(' (HISTO_ID, EMET_ID, HISTO_LADATE, HISTO_ACTION,  ');
      SQL.Add(' ,HISTO_ACTIONSTR, HISTO_VAL1, HISTO_VAL2, HISTO_VAL3 ');
      SQL.Add(' ,HISTO_STR1, HISTO_STR2, HISTO_STR3, HISTO_FAIT) ');
      SQL.Add(' VALUES ');
      SQL.Add(' (:PID, :PEMET_ID, :PLADATE, :PACTION,  ');
      SQL.Add('  :PACTIONSTR, :PVAL1, :PVAL2, :PVAL3, ');
      SQL.Add('  :PSTR1, :PSTR2, :PSTR3, :PFAIT) ');

      ParamCheck := True;
      ParamByName('PID').AsInteger       := vNewId;
      ParamByName('PEMET_ID').AsInteger  := vNewIdCLIENT;
      ParamByName('PLADATE').AsDateTime  := vpCDS.FieldByName('ladate').AsDateTime;
      ParamByName('PACTION').AsInteger   := vpCDS.FieldByName('action').AsInteger;
      ParamByName('PACTIONSTR').AsString := vpCDS.FieldByName('actionstr').AsString;
      ParamByName('PVAL1').AsInteger     := vpCDS.FieldByName('val1').AsInteger;
      ParamByName('PVAL2').AsInteger     := vpCDS.FieldByName('val2').AsInteger;
      ParamByName('PVAL3').AsInteger     := vpCDS.FieldByName('val3').AsInteger;
      ParamByName('PSTR1').AsString      := vpCDS.FieldByName('str1').AsString;
      ParamByName('PSTR2').AsString      := vpCDS.FieldByName('str2').AsString;
      ParamByName('PSTR3').AsString      := vpCDS.FieldByName('str3').AsString;
      ParamByName('PFAIT').AsInteger     := vpCDS.FieldByName('fait').AsInteger;
    end;
  end;

  Result := vNewId;
end;

{$ENDREGION ' Ecriture SQL - Yellis'}


{$ENDREGION ' Ecriture SQL '}

end.

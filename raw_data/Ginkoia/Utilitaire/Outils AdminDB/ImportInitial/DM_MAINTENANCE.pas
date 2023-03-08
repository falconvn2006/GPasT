unit DM_MAINTENANCE;

//Tables de la nouvelle base
//Fonctions du traitement de l'import

interface

uses
  SysUtils, Classes, Forms, DB, DBClient, IBODataset, IB_Components, SqlExpr,
  Generics.Collections;

type
  TChampFonc = reference to function(var Stop: boolean): TField;
  TMapping = TDictionary<string, TChampFonc>;  //Champ destination, fonctions de lookup et mémorisation FK
  TDatasetMapping = TPair<TIBOTable, TMapping>; //Table destination, Mapping des champs
  TImport = TPair<TDataset, TDatasetMapping>;  //Table source, Mapping destination <--> champs
  TListeImport = TList<TImport>;               //Liste ordonnée des traitements

  TDMMaintenance = class(TDataModule)
    IBCNX_MAINTENANCE: TIB_Connection;
    TBL_EMETTEUR: TIBOTable;
    TBL_VERSION: TIBOTable;
    TBL_SPECIFIQUE: TIBOTable;
    TBL_HISTO: TIBOTable;
    TBL_PLAGEMAJ: TIBOTable;
    TBL_SRV: TIBOTable;
    TBL_GRP: TIBOTable;
    TBL_DOSSIER: TIBOTable;
    TBL_HDB: TIBOTable;
    STP_NOUVELID: TIBOStoredProc;
    TBL_FICHIERS: TIBOTable;
    TBL_MAGASINS: TIBOTable;
    TBL_MODULES: TIBOTable;
    TBL_MODULES_MAGASINS: TIBOTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TBL_VERSIONAfterInsert(DataSet: TDataSet);

  private
    YellisVersion    : TMapping;
    YellisFichiers   : TMapping;
    YellisClients    : TMapping;
    YellisSpecifique : TMapping;
    YellisHisto     : TMapping; //doit être traité en plusieurs paquets
    YellisPlageMAJ   : TMapping;
    MonitorSRV       : TMapping;
    MonitorGRP       : TMapping;
    MonitorFolder    : TMapping;
    MonitorSender    : TMapping;
    MonitorHDB       : TMapping;
    GinkoiaMagasins  : TMapping;
    GinkoiaModules   : TMapping;
    GinkoiaModMag    : TMapping;
    ListeImport      : TListeImport;
    ListeImportGinkoia : TListeImport;
    EnregNull : Boolean;

    procedure OuvrirTables(DM : TDataModule; DSClass : TDatasetClass);
    procedure FermerTables(DM : TDataModule; DSClass : TDatasetClass);
    procedure CreerEnregNull;

    procedure ImportChamps(DSMap : TDatasetMapping); //boucle sur une table pour tous les champs mappés
    procedure ImportTable(Import : TImport); //boucle principale sur la liste des tables de ListeImport
    procedure UpdateSender; //code spécifique pour traiter le cas particulier

    function FabriqueLookupFonc(Src : TDataset; NomChamp : string; Suivant : boolean = False) : TChampFonc; //récupère la valeur d'un champ dans une table source
    function FabriqueFKFonc(Src, FK : TDataset; NomChamp: string) : TChampFonc; //récupération du nouvel ID selon la FK de la base source
    function FabriqueMemoFKFonc(Src, Dest, FK : TDataset; NomChamp : string) : TChampFonc; //mémorisation des FK des bases sources et des nouveaux ID de la base cible

  public
    procedure Log(Msg : string);
    function BaseVide : boolean;
    procedure LancerImport;
  end;

var
  DMMaintenance: TDMMaintenance;

implementation

{$R *.dfm}

uses Main, DM_MONITOR, DM_YELLIS, DM_GINKOIA, DM_MemoFK;

{ TDMMaintenance }

function TDMMaintenance.BaseVide: boolean;
begin
   if TBL_EMETTEUR.State = dsInactive then
      TBL_EMETTEUR.Open;
   Result := TBL_EMETTEUR.RecordCount = 0;
end;

procedure TDMMaintenance.CreerEnregNull;
begin
   EnregNull := True;
   try
      with TBL_VERSION do
           begin
           Append;
           FieldByName('VER_ID').AsInteger := 0;
           FieldByName('VER_VERSION').AsString := 'non renseigné';
           FieldByName('VER_NOMVERSION').AsString := 'non renseigné';
           Post;
           end;
      with TBL_SRV do
           begin
           Append;
           FieldByName('SRV_ID').AsInteger := 0;
           FieldByName('SRV_NOM').AsString := 'non renseigné';
           Post;
           end;
      with TBL_GRP do
           begin
           Append;
           FieldByName('GRP_ID').AsInteger := 0;
           FieldByName('GRP_NOM').AsString := 'non renseigné';
           Post;
           end;
      with TBL_DOSSIER do
           begin
           Append;
           FieldByName('DOS_ID').AsInteger := 0;
           FieldByName('DOS_DATABASE').AsString := 'non renseigné';
           FieldByName('SRV_ID').AsInteger := 0;
           FieldByName('GRP_ID').AsInteger := 0;
           Post;
           end;
      with TBL_EMETTEUR do
           begin
           Append;
           FieldByName('EMET_ID').AsInteger := 0;
           FieldByName('EMET_NOM').AsString := 'non renseigné';
           FieldByName('DOS_ID').AsInteger := 0;
           FieldByName('VER_ID').AsInteger := 0;
           Post;
           end;
   finally
      EnregNull := False;
   end;
end;

procedure TDMMaintenance.DataModuleCreate(Sender: TObject);
begin
  YellisVersion := TMapping.Create;
  with YellisVersion do
       begin
       Add('VER_ID',           FabriqueMemoFKFonc(DMYellis.CDS_VERSION, TBL_VERSION, DMMemoFK.YELLIS_VERSION, 'id'));
       Add('VER_VERSION',      FabriqueLookupFonc(DMYellis.CDS_VERSION, 'version'));
       Add('VER_NOMVERSION',   FabriqueLookupFonc(DMYellis.CDS_VERSION, 'nomversion'));
       Add('VER_PATCH',        FabriqueLookupFonc(DMYellis.CDS_VERSION, 'Patch'));
       Add('VER_EAI',          FabriqueLookupFonc(DMYellis.CDS_VERSION, 'EAI', True));
       end;
  YellisFichiers := TMapping.Create;
  with YellisFichiers do
       begin
       Add('VER_ID',           FabriqueFKFonc(DMYellis.CDS_FICHIERS, DMMemoFK.YELLIS_VERSION, 'id_ver'));
       Add('FIC_FICHIER',      FabriqueLookupFonc(DMYellis.CDS_FICHIERS, 'fichier'));
       Add('FIC_CRC',          FabriqueLookupFonc(DMYellis.CDS_FICHIERS, 'crc', True));
       end;
  YellisClients := TMapping.Create;
  with YellisClients do
       begin
       Add('EMET_ID',          FabriqueMemoFKFonc(DMYellis.CDS_CLIENTS, TBL_EMETTEUR, DMMemoFK.YELLIS_CLIENT, 'id'));
       Add('EMET_GUID',        FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'clt_GUID'));
       Add('EMET_NOM',         FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'nom'));
       Add('EMET_SOC_NOM',     FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'site'));
       Add('VER_ID',           FabriqueFKFonc(DMYellis.CDS_CLIENTS, DMMemoFK.YELLIS_VERSION, 'version'));
       Add('EMET_PATCH',       FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'patch'));
       Add('EMET_VERSION_MAX', FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'version_max'));
       Add('EMET_SPE_PATCH',   FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'spe_patch'));
       Add('EMET_SPE_FAIT',    FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'spe_fait'));
       Add('EMET_BCKOK',       FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'bckok'));
       Add('EMET_DERNBCK',     FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'dernbck'));
       Add('EMET_RESBCK',      FabriqueLookupFonc(DMYellis.CDS_CLIENTS, 'resbck', True));
       end;
  YellisSpecifique := TMapping.Create;
  with YellisSpecifique do
       begin
       Add('EMET_ID',          FabriqueFKFonc(DMYellis.CDS_SPECIFIQUE, DMMemoFK.YELLIS_CLIENT, 'spe_cltid'));
       Add('SPE_FICHIER',      FabriqueLookupFonc(DMYellis.CDS_SPECIFIQUE, 'spe_fichier'));
       Add('SPE_FAIT',         FabriqueLookupFonc(DMYellis.CDS_SPECIFIQUE, 'spe_fait'));
       Add('SPE_DATE',         FabriqueLookupFonc(DMYellis.CDS_SPECIFIQUE, 'spe_date', True));
       end;
  YellisHisto := TMapping.Create;
  with YellisHisto do
       begin
       Add('EMET_ID',          FabriqueFKFonc(DMYellis.CDS_HISTO, DMMemoFK.YELLIS_CLIENT, 'id_cli'));
       Add('HISTO_LADATE',     FabriqueLookupFonc(DMYellis.CDS_HISTO, 'ladate'));
       Add('HISTO_ACTION',     FabriqueLookupFonc(DMYellis.CDS_HISTO, 'action'));
       Add('HISTO_ACTIONSTR',  FabriqueLookupFonc(DMYellis.CDS_HISTO, 'actionstr'));
       Add('HISTO_VAL1',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'val1'));
       Add('HISTO_VAL2',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'val2'));
       Add('HISTO_VAL3',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'val3'));
       Add('HISTO_STR1',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'str1'));
       Add('HISTO_STR2',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'str2'));
       Add('HISTO_STR3',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'str3'));
       Add('HISTO_FAIT',       FabriqueLookupFonc(DMYellis.CDS_HISTO, 'fait', True));
       end;
  YellisPlageMAJ := TMapping.Create;
  with YellisPlageMAJ do
       begin
       Add('EMET_ID',          FabriqueFKFonc(DMYellis.CDS_PLAGEMAJ, DMMemoFK.YELLIS_CLIENT, 'plg_cltid'));
       Add('PLG_DATEDEB',      FabriqueLookupFonc(DMYellis.CDS_PLAGEMAJ, 'plg_datedeb'));
       Add('PLG_DATEFIN',      FabriqueLookupFonc(DMYellis.CDS_PLAGEMAJ, 'plg_datefin'));
       Add('PLG_VERSIONMAX',   FabriqueLookupFonc(DMYellis.CDS_PLAGEMAJ, 'plg_versionmax', True));
       end;

  MonitorSRV := TMapping.Create;
  with MonitorSRV do
       begin
       Add('SRV_ID',           FabriqueMemoFKFonc(DMMonitor.TBL_SRV, TBL_SRV, DMMemoFK.MONITOR_SRV, 'SRV_ID'));
       Add('SRV_NOM',          FabriqueLookupFonc(DMMonitor.TBL_SRV, 'SRV_NAME'));
       Add('SRV_IP',           FabriqueLookupFonc(DMMonitor.TBL_SRV, 'SRV_IP', True));
       end;
  MonitorGRP := TMapping.Create;
  with MonitorGRP do
       begin
       Add('GRP_ID',           FabriqueMemoFKFonc(DMMonitor.TBL_GRP, TBL_GRP, DMMemoFK.MONITOR_GRP, 'GRP_ID'));
       Add('GRP_NOM',          FabriqueLookupFonc(DMMonitor.TBL_GRP, 'GRP_NOM', True));
       end;
  MonitorFolder := TMapping.Create;
  with MonitorFolder do
       begin
       Add('DOS_ID',           FabriqueMemoFKFonc(DMMonitor.TBL_FOLDER, TBL_DOSSIER, DMMemoFK.MONITOR_FOLDER, 'FLD_ID'));
       Add('DOS_DATABASE',     FabriqueLookupFonc(DMMonitor.TBL_FOLDER, 'FLD_DATABASE'));
       Add('SRV_ID',           FabriqueFKFonc(DMMonitor.TBL_FOLDER, DMMemoFK.MONITOR_SRV, 'SRV_ID'));
       Add('DOS_CHEMIN',       FabriqueLookupFonc(DMMonitor.TBL_FOLDER, 'FLD_PATH'));
       Add('GRP_ID',           FabriqueFKFonc(DMMonitor.TBL_FOLDER, DMMemoFK.MONITOR_GRP, 'GRP_ID'));
       Add('DOS_INSTALL',      FabriqueLookupFonc(DMMonitor.TBL_FOLDER, 'FLD_INSTALL', True));
       end;
  MonitorSender := TMapping.Create;
  with MonitorSender do
       begin
       Add('EMET_ID',           FabriqueMemoFKFonc(DMMonitor.TBL_SENDER, TBL_EMETTEUR, DMMemoFK.MONITOR_SENDER, 'SENDER_ID'));
       Add('EMET_DONNEES',      FabriqueLookupFonc(DMMonitor.TBL_SENDER, 'SENDER_DATA'));
       Add('DOS_ID',            FabriqueFKFonc(DMMonitor.TBL_SENDER, DMMemoFK.MONITOR_FOLDER, 'FLD_ID'));
       Add('EMET_INSTALL',      FabriqueLookupFonc(DMMonitor.TBL_SENDER, 'SENDER_INSTALL'));
       Add('EMET_MAGID',        FabriqueLookupFonc(DMMonitor.TBL_SENDER, 'SENDER_MAGID', True));
       end;
  MonitorHDB := TMapping.Create;
  with MonitorHDB do
       begin
       Add('EMET_ID',           FabriqueFKFonc(DMMonitor.TBL_SENDER, DMMemoFK.MONITOR_SENDER, 'SENDER_ID'));
       Add('HDB_CYCLE',         FabriqueLookupFonc(DMMonitor.TBL_HDB, 'HDB_CYCLE'));
       Add('HDB_OK',            FabriqueLookupFonc(DMMonitor.TBL_HDB, 'HDB_OK'));
       Add('HDB_COMMENTAIRE',   FabriqueLookupFonc(DMMonitor.TBL_HDB, 'HDB_COMMENTAIRE'));
       Add('HDB_ARCHIVER',      FabriqueLookupFonc(DMMonitor.TBL_HDB, 'HDB_ARCHIVER'));
       Add('HDB_DATE',          FabriqueLookupFonc(DMMonitor.TBL_HDB, 'HDB_DATE', True));
       end;
  GinkoiaMagasins := TMapping.Create;
  with GinkoiaMagasins do
       begin
       Add('MAG_ID',            FabriqueMemoFKFonc(DMGinkoia.TBL_GENMAGASIN, TBL_MAGASINS, DMMemoFK.GINKOIA_GENMAGASIN, 'MAG_ID'));
       Add('DOS_ID',            FabriqueLookupFonc(TBL_EMETTEUR, 'DOS_ID')); //reporter la jointure dossier de l'EMETTEUR courant, le locate a été fait dans la boucle principale
       Add('MAG_ID_GINKOIA',    FabriqueLookupFonc(DMGinkoia.TBL_GENMAGASIN, 'MAG_ID'));
       Add('MAG_NOM',           FabriqueLookupFonc(DMGinkoia.TBL_GENMAGASIN, 'MAG_NOM'));
       Add('MAG_ENSEIGNE',      FabriqueLookupFonc(DMGinkoia.TBL_GENMAGASIN, 'MAG_ENSEIGNE', True));
       end;
  GinkoiaModules := TMapping.Create;
  with GinkoiaModules do
       begin
       Add('MOD_ID',            FabriqueMemoFKFonc(DMGinkoia.TBL_UILGRPGINKOIA, TBL_MODULES, DMMemoFK.GINKOIA_UILGRPGINKOIA, 'UGG_ID'));
       Add('UGG_NOM',           FabriqueLookupFonc(DMGinkoia.TBL_UILGRPGINKOIA, 'UGG_NOM', True));
       end;
  GinkoiaModMag := TMapping.Create;
  with GinkoiaModMag do
       begin
       Add('MOD_ID',            FabriqueFKFonc(DMGinkoia.TBL_UILGRPGINKOIAMAG, DMMemoFK.GINKOIA_UILGRPGINKOIA, 'UGM_UGGID'));
       Add('MAG_ID',            FabriqueFKFonc(DMGinkoia.TBL_UILGRPGINKOIAMAG, DMMemoFK.GINKOIA_GENMAGASIN, 'UGM_MAGID'));
       Add('MODMAG_DATE',       FabriqueLookupFonc(DMGinkoia.TBL_UILGRPGINKOIAMAG, 'UGM_DATE', True));
       end;

  ListeImport := TListeImport.Create;
  with ListeImport do
       begin
       Add(TImport.Create(DMYellis.CDS_VERSION, TDatasetMapping.Create(TBL_VERSION, YellisVersion)));
       Add(TImport.Create(DMYellis.CDS_FICHIERS, TDatasetMapping.Create(TBL_FICHIERS, YellisFichiers)));
       Add(TImport.Create(DMYellis.CDS_CLIENTS, TDatasetMapping.Create(TBL_EMETTEUR, YellisClients)));
       Add(TImport.Create(DMYellis.CDS_SPECIFIQUE, TDatasetMapping.Create(TBL_SPECIFIQUE, YellisSpecifique)));
       Add(TImport.Create(DMYellis.CDS_HISTO, TDatasetMapping.Create(TBL_HISTO, YellisHisto)));
       Add(TImport.Create(DMYellis.CDS_PLAGEMAJ, TDatasetMapping.Create(TBL_PLAGEMAJ, YellisPlageMAJ)));

       Add(TImport.Create(DMMonitor.TBL_SRV, TDatasetMapping.Create(TBL_SRV, MonitorSRV)));
       Add(TImport.Create(DMMonitor.TBL_GRP, TDatasetMapping.Create(TBL_GRP, MonitorGRP)));
       Add(TImport.Create(DMMonitor.TBL_FOLDER, TDatasetMapping.Create(TBL_DOSSIER, MonitorFolder)));
//       Add(TImport.Create(DMMonitor.TBL_HDB, TDatasetMapping.Create(TBL_HDB, MonitorHDB)));
       end;

  ListeImportGinkoia := TListeImport.Create;
  with ListeImportGinkoia do
       begin
       Add(TImport.Create(DMGinkoia.TBL_GENMAGASIN, TDatasetMapping.Create(TBL_MAGASINS, GinkoiaMagasins)));
       Add(TImport.Create(DMGinkoia.TBL_UILGRPGINKOIA, TDatasetMapping.Create(TBL_MODULES, GinkoiaModules)));
       Add(TImport.Create(DMGinkoia.TBL_UILGRPGINKOIAMAG, TDatasetMapping.Create(TBL_MODULES_MAGASINS, GinkoiaModMag)));
       end;
  OuvrirTables(DMMemoFK, TClientDataset);
  DMMemoFK.InitialiserCDSNULL;
end;

procedure TDMMaintenance.DataModuleDestroy(Sender: TObject);
begin
   FermerTables(DMMemoFK, TClientDataset);
   FermerTables(DMGinkoia, TIBOQuery);
   FermerTables(DMMonitor, TIBOTable);
   FermerTables(DMYellis, TSQLTable);
   YellisVersion.Free;
   YellisFichiers.Free;
   YellisClients.Free;
   YellisSpecifique.Free;
   YellisHisto.Free;
   YellisPlageMAJ.Free;
   MonitorSRV.Free;
   MonitorGRP.Free;
   MonitorFolder.Free;
   MonitorSender.Free;
   MonitorHDB.Free;
   GinkoiaMagasins.Free;
   GinkoiaModules.Free;
   GinkoiaModMag.Free;
   ListeImport.Free;

end;

procedure TDMMaintenance.Log(Msg: string);
begin
   MainForm.MEMO_LOG.Lines.Add(Msg);
   Application.ProcessMessages;
end;

procedure TDMMaintenance.OuvrirTables(DM: TDataModule; DSClass: TDatasetClass);
var cpt : integer;
    cmp : TComponent;
begin
   if DM = nil then
      raise Exception.Create('DataModule à nil (' + DM.ToString + ')');
   for cpt := 0 to DM.ComponentCount - 1 do
       begin
       cmp := DM.Components[cpt];
       if cmp is TClientDataset then //DMMemoFK
          (cmp as TClientDataset).CreateDataset;
       if cmp is DSClass then
          (cmp as DSClass).Open;
       end;
end;

procedure TDMMaintenance.TBL_VERSIONAfterInsert(DataSet: TDataSet);
begin
   //Code réutilisé dans touts les AfterInsert du module
   if EnregNull then
      exit; //gestion de l'id 0 pour l'enreg 'non renseigné'

   STP_NOUVELID.ParamByName('NOM_GENERATEUR').AsString := string((Dataset as TIBOTable).TableName);
   STP_NOUVELID.ExecProc;
   Dataset.Fields[0].AsInteger := STP_NOUVELID.ParamByName('ID').AsInteger;
end;

procedure TDMMaintenance.FermerTables(DM: TDataModule; DSClass: TDatasetClass);
var cpt : integer;
begin
   for cpt := 0 to DM.ComponentCount - 1 do
       if DM.Components[cpt] is DSClass then
          (DM.Components[cpt] as DSClass).Close;
end;

function TDMMaintenance.FabriqueFKFonc(Src, FK : TDataset; NomChamp: string): TChampFonc;
begin
   Result := function(var Stop : Boolean) : TField
             begin
                Stop := False;
                Result := DMMemoFK.CDS_NULL.Fields[0]; //force les FK non trouvées à pointer sur un enregistrement factice
                                                       //toutes les tables dont l'ID est FK d'une autre table doivent donc avoir un premier
                                                       //enreg d'ID 0
                if (FK as TClientDataset).Locate('ID', Src.FieldByName(NomChamp).Value, []) then
                   Result := FK.Fields[1];
             end;
end;

function TDMMaintenance.FabriqueLookupFonc(Src: TDataset; NomChamp: string; Suivant : boolean): TChampFonc;
begin
   Result := function(var Stop : Boolean) : TField
             begin
                Result := Src.FieldByName(NomChamp);
                if Suivant then
                     begin
                     Src.Next;
                     if Src.Eof then
                        Stop := True;
                     end;
             end;
end;

function TDMMaintenance.FabriqueMemoFKFonc(Src, Dest, FK: TDataset; NomChamp: string): TChampFonc;
begin
   Result := function(var Stop : Boolean) : TField
             begin
                Stop := False;
                Result := nil;
                Dest.Post;
                FK.AppendRecord([Src.FieldByName(NomChamp).Value, Dest.Fields[0].Value]);
                Dest.Edit;
             end;
end;

procedure TDMMaintenance.ImportTable(Import: TImport);
var Limite : integer;
begin
   Log('Import de la table : ' + string(Import.Value.Key.TableName));
   if Import.Key = DMYellis.CDS_HISTO then
      begin
      Limite := 1;
      repeat
         Log(Format('Paquet de %d à %d', [Limite, Limite+1000]));
         DMYellis.OuvrirTableHisto(Limite);
         ImportChamps(Import.Value);
         Import.Key.Close;
         inc(Limite, 1000);
      until DMYellis.NbLignesHisto < 1000;
      end
   else
      begin
      Import.Key.Open;
      ImportChamps(Import.Value);
      Import.Key.Close;
      end;
end;

procedure TDMMaintenance.ImportChamps(DSMap : TDatasetMapping);
var Fini : Boolean;
    cpt : integer;
    Fonc : TChampFonc;
    Champ : TField;
    Dest : TIBOTable;
    Map : TMapping;
    NbEnregs : integer;
begin
   Fini := False;
   Dest := DSMap.Key;
   Map := DSMap.Value;
   NbEnregs := 0;
   try
      while not Fini do
            begin
            Dest.Append;
            for cpt := 0 to Dest.FieldCount-1 do
                if Map.TryGetValue(Dest.Fields[cpt].FieldName, Fonc) then
                   begin
                   Champ := Fonc(Fini);
                   if (Champ <> nil) and not Champ.IsNull then
                      Dest.Fields[cpt].Value := Champ.Value;
                   end;
            Dest.Post;
            inc(NbEnregs);
            end;
   except
      on E : Exception do
         Log(E.Message);
   end;
   Log(IntToStr(NbEnregs) + ' enregistrement(s)');
   Log('');
end;

procedure TDMMaintenance.UpdateSender;
var Fini : Boolean;
    Fonc : TChampFonc;
    Champ : TField;
    cpt : integer;
    imp : integer;
    NbEnregs : integer;
//    SL : TStringList;
begin
   Fini := False;
   NbEnregs := 0;
   DMMonitor.TBL_SENDER.Open;
   DMMonitor.TBL_SENDER.First;
   Log('Mise à jour de la table EMETTEUR');
//   SL := TStringList.Create;
   try
      while not DMMonitor.TBL_SENDER.Eof do
            begin
            if TBL_EMETTEUR.Locate('EMET_NOM',  DMMonitor.TBL_SENDER.FieldByName('SENDER_NAME').AsString, [loCaseInsensitive]) then
               begin
               TBL_EMETTEUR.Edit;
               for cpt := 0 to TBL_EMETTEUR.FieldCount-1 do
                   if MonitorSender.TryGetValue(TBL_EMETTEUR.Fields[cpt].FieldName, Fonc) then
                      begin
                      Champ := Fonc(Fini);
                      if Champ <> nil then
                         TBL_EMETTEUR.Fields[cpt].Value := Champ.Value;
//                      if Champ = DMMemoFK.CDS_NULLID then
//                         SL.Add('FK Dossier incorrecte, SENDER : ' + DMMonitor.TBL_SENDER.FieldByName('SENDER_NAME').AsString + ' ' + DMMonitor.TBL_SENDER.FieldByName('FLD_ID').AsString);
                      end;
               //le TBL_SENDER.Next est géré dans la fonction de Lookup
               TBL_EMETTEUR.Post;
               inc(NbEnregs);
               end
            else
               begin
//               SL.Add('SENDER_NAME différent de Yellis : ' + DMMonitor.TBL_SENDER.FieldByName('SENDER_NAME').AsString);
               DMMonitor.TBL_SENDER.Next;
               end;
            end;

      TBL_EMETTEUR.First;
      //MAJ depuis Ginkoia
      while not TBL_EMETTEUR.Eof do
            begin
            if TBL_DOSSIER.Locate('DOS_ID', TBL_EMETTEUR.FieldByName('DOS_ID').AsInteger, []) and
               (TBL_DOSSIER.FieldByName('DOS_CHEMIN').AsString <> '') then
               begin
               try
                  MainForm.SetIBConnexion(DMGinkoia.IBCNX_GINKOIA, TBL_DOSSIER.FieldByName('DOS_CHEMIN').AsString);
               except
                  Log('Connexion impossible à : ' + TBL_DOSSIER.FieldByName('DOS_CHEMIN').AsString);
                  continue;
               end;
               DMGinkoia.QR_GENLAUNCH.Close;
               DMGinkoia.QR_GENLAUNCH.ParamByName('GU').AsString := TBL_EMETTEUR.FieldByName('EMET_GUID').AsString;
               DMGinkoia.QR_GENLAUNCH.Open;
               //Mises à jour poncuelles, pas de mémorisation d'ID, pas de bénéfice à utiliser un mapping
               if DMGinkoia.QR_GENLAUNCH.RecordCount > 0 then
                  begin
                  TBL_EMETTEUR.Edit;
                  TBL_EMETTEUR.FieldByName('EMET_HEURE1').Value := DMGinkoia.QR_GENLAUNCH.FieldByName('LAU_HEURE1').Value;
                  TBL_EMETTEUR.FieldByName('EMET_H1').Value := DMGinkoia.QR_GENLAUNCH.FieldByName('LAU_H1').Value;
                  TBL_EMETTEUR.FieldByName('EMET_HEURE2').Value := DMGinkoia.QR_GENLAUNCH.FieldByName('LAU_HEURE2').Value;
                  TBL_EMETTEUR.FieldByName('EMET_H2').Value := DMGinkoia.QR_GENLAUNCH.FieldByName('LAU_H2').Value;
                  TBL_EMETTEUR.Post;
                  end;
               //Ajout des tables module de Ginkoia. Ici on peut venir greffer la structure standard d'un import
               //qui sera exécuté pour chaque émetteur
               DMMemoFK.ViderFKGinkoia; //les FK seront différentes pour chaque émetteur
               for imp := 0 to ListeImportGinkoia.Count - 1 do
                   ImportTable(ListeImportGinkoia.Items[imp]);
               end;
            TBL_EMETTEUR.Next;
            end;
   except
      on E : Exception do
         Log(E.Message);
   end;
//   SL.SaveToFile('C:\YBE\LogSender.Txt');
//   SL.Free;
   Log(IntToStr(NbEnregs) + ' enregistrement(s)');
   Log('');
end;

procedure TDMMaintenance.LancerImport;
var cpt : integer;
begin
   OuvrirTables(Self, TIBOTable);
   CreerEnregNull;
   try
      DMYellis.OuvrirTables; //fonctionne différemment : doit d'abord accéder au serveur web
   except
      on E : Exception do
         Log(E.Message);
   end;
   for cpt := 0 to ListeImport.Count - 2 do //traitement séquentiel selon l'ordre d'ajout, pas d'itérateur
       ImportTable(ListeImport.Items[cpt]);
   UpdateSender; //seul conflit dans le modèle : la table EMETTEUR est alimentée par trois sources

   // HDB désactivé pour les tests, car 1,6M de lignes
   //Testé sur 10 enregs

   //   ImportTable(ListeImport.Items[ListeImport.Count - 1]); //HDB en dernier

end;



end.

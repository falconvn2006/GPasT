unit uHistorique;

interface

uses
  Windows, SysUtils, Classes, DB, DBClient, StrUtils, uCommon, Main_Dm, Dialogs,
  IBODataset, Load_Frm, GinkoiaStyle_Dm, IBSQL, IBStoredProc, Forms,
  Generics.Collections, uLog;

type
  THistorique = Class(TThread)
    private
      bRepriseTicket: boolean;
      bEnabledProcessold : Boolean;
      bRecalStock: boolean;
      bCorrectionTVA: Boolean;

      sPathCaisse             : string;
      sPathReception          : string;
      sPathConsodiv           : string;
      sPathTransfert          : string;
      sPathCommandes          : string;
      sPathRetourFou          : string;
      sPathAvoir              : string;
      sPathBonLivraison       : string;
      sPathBonLivraisonL      : string;
      sPathBonLivraisonHisto  : string;

      sError: string;
      iMaxProgress: integer;
      iProgress: integer;
      iTraitement: integer;
      NbTraitement: integer;

      InfoLigne : TStringList;    // Découpe la ligne en cours de traitement
      LigneLecture: string;

      cds_Magasin: TClientDataSet;
      cds_TypeVen: TClientDataSet;
      cds_TypePaie: TClientDataSet;
      cds_GroupPump: TClientDataSet;
      cds_CdlLiv: TClientDataSet;
      cds_FouMrk: TClientDataSet;
      cds_TypeVenBL: TClientDataSet;
      cds_StatutBL: TClientDataSet;
      cds_MotifBL: TClientDataSet;

      cds_Caisse            : TStringList;
      cds_Reception         : TStringList;
      cds_Consodiv          : TStringList;
      cds_Transfert         : TStringList;
      cds_Commandes         : TStringList;
      cds_Retourfou         : TStringList;
      cds_Avoir             : TStringList;
      cds_BonLivraison      : TStringList;
      cds_BonLivraisonL     : TStringList;
      cds_BonLivraisonHisto : TStringList;

      ListeUsedMagasin : TStringList;

      StProc_PrepareRecalStk  : TIBSQL;

      StProc_Caisse_Poste     : TIBSQL;
      StProc_Caisse_Session   : TIBSQL;
      StProc_Caisse_Entete    : TIBSQL;
      StProc_Caisse_Ligne     : TIBSQL;
      StProc_Init_BI          : TIBStoredProc;
      Que_Init_BI             : TIBSQL;
      StProc_Caisse_RecalTick : TIBStoredProc;

      StProc_Reception_Entete : TIBSQL;
      StProc_Reception_Ligne  : TIBSQL;
      StProc_Reception_RecalTick : TIBStoredProc;

      StProc_Fourn          : TIBSQL;
      StProc_Consodiv       : TIBSQL;

      StProc_Transfert       : TIBSQL;
      StProc_Transfert_Recal : TIBStoredProc;

      StProc_Commande_Entete  : TIBSQL;
      StProc_Commande_Ligne   : TIBSQL;
      StProc_Commande_Recal   : TIBStoredProc;

      StProc_RetourFou_Entete  : TIBSQL;
      StProc_RetourFou_Ligne   : TIBSQL;
      StProc_RetourFou_Recal   : TIBStoredProc;

      StProc_Avoir  : TIBSQL;

      StProc_BonLivraison       : TIBSQL;
      StProc_BonLivraisonL      : TIBSQL;
      StProc_BonLivraisonHisto  : TIBSQL;

      StProc_FouMarque         : TIBSQL;

      procedure SortReception(iDeb, iFin: integer);

      function LoadFile:Boolean;

      function GetValueCaisseImp(AChamp: string): string;
      function GetValueReceptionImp(AChamp: string): string;
      function GetValueConsodivImp(AChamp: string): string;
      function GetValueTransfertImp(AChamp: string): string;
      function GetValueCommandesImp(AChamp: string): string;
      function GetValueRetourFouImp(AChamp: string): string;
      function GetValueAvoirImp(AChamp: string): string;
      function GetValueBonLivraisonImp(AChamp: string): string;
      function GetValueBonLivraisonLImp(AChamp: string): string;
      function GetValueBonLivraisonHistoImp(AChamp: string): string;

      procedure AjoutInfoLigne(ALigne: string; ADefColonne: array of string);

      // ajoute ArtID dans tmpstat (id=9999) en prévision de récalculer son stock
      procedure AjoutPrepareRecalStk(AArtID: integer);

      function DesactiveTrigger    : Boolean;    // desactive les trigger
      function TraiterCaisse       : Boolean;    // Caisse
      function TraiterReception    : Boolean;    // Réception
      function TraiterConsodiv     : Boolean;    // Consodiv
      function TraiterTransfert    : Boolean;    // Transfert
      function TraiterCommandes    : Boolean;    // Commandes
      function TraiterRetourfou    : Boolean;    // Retour Fournisseur
      function TraiterAvoir        : Boolean;    // Avoir
      function TraiterBonLivraison      : Boolean;    // Bon de livraison
      function TraiterBonLivraisonL     : Boolean;    // Bon de livraison Ligne
      function TraiterBonLivraisonHisto : Boolean;    // Bon de livraison Histo
      // function OldRecalculStock    : Boolean;    // Recalcul du stock  // ! ancienne méthode
      function TraiteForcePump     : Boolean;    // met la valeur du pump d'Intersys
      function ActiveTrigger       : Boolean;    // réactive les triggers
      function TraiterBackupRestore: boolean;    // backup restore de la base

      function RecalculStock       : Boolean;    // Recalcul du stock

      //Mise à jour de la fenêtre d'attente
      procedure InitFrm;          // initilisation
      procedure InitExecute;      // début execution
      procedure UpdateFrm;        // Mise à jour
      procedure ErrorFrm;         // traitement des erreurs
      procedure EndFrm;           // fin du traitement
      procedure InitProgressFrm ; // initialisation progression
      procedure UpdProgressFrm ;  // maj progression
      procedure CanAnnuleRecalcul;     // on rend visible le bouton "Stop Recalcul Stock"
      procedure NotCanAnnuleRecalcul;  // on rend invisible le bouton "Stop Recalcul Stock"
      procedure GetStatutStopRecalcul;  // donne l'état si besoin de stopper le recalcul

      //*********************************//
    private
      type
        TUpdatePumpRec = record // Définition d'un forcage de pump
          MAG_ID, ART_ID, TGF_ID, COU_ID: Integer;
          DATE: TDateTime;
          constructor Create(const MAG_ID, ART_ID, TGF_ID, COU_ID: Integer;
            const DATE: TDateTime);
        end;

      var
        DicUpdatePump: TDictionary<TUpdatePumpRec, Double>; // Liste des forcage de pump à réaliser

      procedure UpdatePumps; // Traite la file d'update
    strict private
      FnoBackup: Boolean;

      procedure doLog(aVal : string; aLvl : TLogLevel);
    protected
      bRetirePtVirg: boolean;
    public
      bStopRecal: boolean;
      bBackupRestore: boolean;
      sEtat1: string;
      sEtat2: string;
      bError: boolean;
      procedure UpdateEtat2;        // Mise à jour
      property noBackup : Boolean write FnoBackup;
      constructor Create(aCreateSuspended, aEnabledProcess, aRecalStock, aRepriseTicket, aCorrectionTVA:boolean);
      destructor Destroy; override;
      procedure InitThread(ARetirePtVirg: boolean; aPathCaisse, aPathReception, aPathConsodiv,
        aPathTransfert, aPathCommandes, aPathRetourfou, aPathAvoir, aPathBonLivraison,
        aPathBonLivraisonL, aPathBonLivraisonHisto : string);

    protected
      procedure Execute; override;

  End;

implementation

uses
  Graphics, uDefs, IBQuery, DateUtils, Variants;

var
  HisSoiMeme: THistorique;

{ THistorique }

function AjouteTemps(ADelai1, ADelai2: TDatetime): TDatetime;
var
  hh,nn,ss,ms: word;
begin
  DecodeTime(ADelai2, hh,nn,ss,ms);
  Result := ADelai1;
  Result := IncMilliSecond(Result, ms);
  Result := IncSecond(Result, ss);
  Result := IncMinute(Result, nn);
  Result := IncHour(Result, hh);
end;

function ReceptionOrderby(List: TStringList; Index1, Index2: Integer): Integer;
var
  sLigne1: string;
  sLigne2: string;
  sNumBon1: string;
  sNumBon2: string;
  dDate1: TDateTime;
  dDate2: TDateTime;
  sCodeFou1: string;
  sCodeFou2: string;
  sCodeMag1: string;
  sCodeMag2: string;
  sCodeArt1: string;
  sCodeArt2: string;
begin
  sLigne1 := List[Index1];
  sLigne2 := List[Index2];
  // Ordre par NUMBON
  sNumBon1 := GetValueImp('NUMBON', Reception_COL, sLigne1, HisSoiMeme.bRetirePtVirg);
  sNumBon2 := GetValueImp('NUMBON', Reception_COL, sLigne2, HisSoiMeme.bRetirePtVirg);
  Result := CompareStr(sNumBon1, sNumBon2);
  if Result<>0 then
    exit;

  // puis par DATE
  dDate1 := ConvertStrToDate(GetValueImp('DATE', Reception_COL, sLigne1, HisSoiMeme.bRetirePtVirg), 0);
  dDate2 := ConvertStrToDate(GetValueImp('DATE', Reception_COL, sLigne2, HisSoiMeme.bRetirePtVirg), 0);
  Result := CompareDate(dDate1, dDate2);
  if Result<>0 then
    exit;

  // puis par CODE_FOURN
  sCodeFou1 := GetValueImp('CODE_FOURN', Reception_COL, sLigne1, HisSoiMeme.bRetirePtVirg);
  sCodeFou2 := GetValueImp('CODE_FOURN', Reception_COL, sLigne2, HisSoiMeme.bRetirePtVirg);
  Result := CompareStr(sCodeFou1, sCodeFou2);
  if Result<>0 then
    exit;

  // puis par CODE_MAG
  sCodeMag1 := GetValueImp('CODE_MAG', Reception_COL, sLigne1, HisSoiMeme.bRetirePtVirg);
  sCodeMag2 := GetValueImp('CODE_MAG', Reception_COL, sLigne2, HisSoiMeme.bRetirePtVirg);
  Result := CompareStr(sCodeMag1, sCodeMag2);
  if Result<>0 then
    exit;

  // puis par CODE_ART
  sCodeArt1 := GetValueImp('CODE_ART', Reception_COL, sLigne1, HisSoiMeme.bRetirePtVirg);
  sCodeArt2 := GetValueImp('CODE_ART', Reception_COL, sLigne2, HisSoiMeme.bRetirePtVirg);
  Result := CompareStr(sCodeArt1, sCodeArt2);
  if Result<>0 then
    exit;
end;


procedure THistorique.doLog(aVal : string; aLvl : TLogLevel);
begin
  uLog.Log.Log('uHistorique', 'log', aVal, aLvl, False, -1, ltLocal);
end;

procedure THistorique.AjoutInfoLigne(ALigne: string; ADefColonne: array of string);
var
  sLigne: string;
  NBre: integer;
begin
  LigneLecture := ALigne;
  sLigne := ALigne;
  if (bRetirePtVirg) and (sLigne<>'') and (sLigne[Length(sLigne)]=';') then
    sLigne := Copy(sLigne, 1, Length(sLigne)-1);

  if (sLigne<>'') and (sLigne[1]='"') then
  begin
    Nbre := 1;
    while Pos('";"', sLigne)>0 do
    begin
      sLigne := Copy(sLigne, Pos('";"', sLigne)+2, Length(sLigne));
      Inc(Nbre);
    end;
  end
  else
  begin
    Nbre := 1;
    while Pos(';', sLigne)>0 do
    begin
      sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
      Inc(Nbre);
    end;
  end;

  if High(ADefColonne)<>(Nbre-1) then
    Raise Exception.Create('Nombre de champs invalide par rapport à l''entête:'+#13#10+
                           '  - Moins de champ: surement un retour chariot dans la ligne'+#13#10+
                           '  - Plus de champ: surement un ; ou un " de trop dans la ligne');
end;

// on rend visible le bouton "Stop Recalcul Stock"
procedure THistorique.CanAnnuleRecalcul;
begin
  Frm_Load.DoCanStopRecal(true);
end;

constructor THistorique.Create(aCreateSuspended, aEnabledProcess, aRecalStock, aRepriseTicket, aCorrectionTVA:boolean);
var
  InfoErreur: string;
begin
  bRepriseTicket := ARepriseTicket;
  InfoErreur := '';
  FnoBackup := False;
  inherited Create(aCreateSuspended);

  try
    InfoErreur := 'Début';
    bRecalStock := aRecalStock;
    bError := false;

    bBackupRestore := false;

    InfoLigne := TStringList.Create; // decoupage de ligne d'import

    DicUpdatePump := TDictionary<TUpdatePumpRec, Double>.Create;

    FreeOnTerminate := true;
    Priority := tpHigher;
    bEnabledProcessold := aEnabledProcess;
    bCorrectionTVA := aCorrectionTVA;

    sEtat1 := '';
    sEtat2 := '';
    sError := '';

    Dm_Main.TransacHis.Active := true;

    // liste des magasin impacté !
    ListeUsedMagasin := TStringList.Create();
    ListeUsedMagasin.Sorted := true;
    ListeUsedMagasin.Duplicates := dupIgnore;

    cds_Caisse            := TStringList.Create;
    cds_Reception         := TStringList.Create;
    cds_Consodiv          := TStringList.Create;
    cds_Transfert         := TStringList.Create;
    cds_Commandes         := TStringList.Create;
    cds_Retourfou         := TStringList.Create;
    cds_Avoir             := TStringList.Create;
    cds_BonLivraison      := TStringList.Create;
    cds_BonLivraisonL     := TStringList.Create;
    cds_BonLivraisonHisto := TStringList.Create;

    // magasin en mémoire
    InfoErreur := 'cds_Magasin ';
    cds_Magasin := TClientDataSet.Create(nil);
    cds_Magasin.FieldDefs.Add('MAG_ID',ftInteger,0);
    cds_Magasin.FieldDefs.Add('MAG_CODEADH',ftString,32);
    cds_Magasin.CreateDataSet;
    cds_Magasin.LogChanges := False;
    cds_Magasin.Open;

    // type de vente en mémoire
    InfoErreur := 'cds_TypeVen ';
    cds_TypeVen := TClientDataSet.Create(nil);
    cds_TypeVen.FieldDefs.Add('TYP_COD',ftInteger,0);
    cds_TypeVen.FieldDefs.Add('TYP_ID',ftInteger,0);
    cds_TypeVen.CreateDataSet;
    cds_TypeVen.LogChanges := False;
    cds_TypeVen.Open;

    // type de vente BL en mémoire
    InfoErreur := 'cds_TypeVenBL ';
    cds_TypeVenBL := TClientDataSet.Create(nil);
    cds_TypeVenBL.FieldDefs.Add('TYP_COD',ftInteger,0);
    cds_TypeVenBL.FieldDefs.Add('TYP_CATEG',ftInteger,0);
    cds_TypeVenBL.FieldDefs.Add('TYP_ID',ftInteger,0);
    cds_TypeVenBL.CreateDataSet;
    cds_TypeVenBL.LogChanges := False;
    cds_TypeVenBL.Open;

    // Statut des BL
    InfoErreur := 'cds_StatutBL ';
    cds_StatutBL := TClientDataSet.Create(nil);
    cds_StatutBL.FieldDefs.Add('BLS_CODE',ftString,32);
    cds_StatutBL.FieldDefs.Add('BLS_ID',ftInteger,0);
    cds_StatutBL.CreateDataSet;
    cds_StatutBL.LogChanges := False;
    cds_StatutBL.Open;

    // Motif des BL
    InfoErreur := 'cds_MotifBL ';
    cds_MotifBL := TClientDataSet.Create(nil);
    cds_MotifBL.FieldDefs.Add('BLM_CODE',ftString,32);
    cds_MotifBL.FieldDefs.Add('BLM_ID',ftInteger,0);
    cds_MotifBL.CreateDataSet;
    cds_MotifBL.LogChanges := False;
    cds_MotifBL.Open;

    // type de paiement en mémoire
    InfoErreur := 'cds_TypePaie ';
    cds_TypePaie := TClientDataSet.Create(nil);
    cds_TypePaie.FieldDefs.Add('CPA_CODE',ftInteger,0);
    cds_TypePaie.FieldDefs.Add('CPA_ID',ftInteger,0);
    cds_TypePaie.CreateDataSet;
    cds_TypePaie.LogChanges := False;
    cds_TypePaie.Open;

    // groupe de Pump en mémoire
    cds_GroupPump := TClientDataSet.Create(nil);
    cds_GroupPump.FieldDefs.Add('MPU_MAGID',ftInteger,0);
    cds_GroupPump.FieldDefs.Add('MPU_GCPID',ftInteger,0);
    cds_GroupPump.CreateDataSet;
    cds_GroupPump.LogChanges := False;
    cds_GroupPump.Open;

    // table virtuel pour la date de livraison des bons de reception
    cds_CdlLiv := TClientDataSet.Create(nil);
    cds_CdlLiv.FieldDefs.Add('ARTID',ftInteger,0);
    cds_CdlLiv.FieldDefs.Add('TGFID',ftInteger,0);
    cds_CdlLiv.FieldDefs.Add('COUID',ftInteger,0);
    cds_CdlLiv.FieldDefs.Add('HEURE',ftDatetime,0);
    cds_CdlLiv.CreateDataSet;
    cds_CdlLiv.LogChanges := False;
    cds_CdlLiv.Open;

    // table virtuel pour créer les relations manquantes marque <--> fournisseur
    cds_FouMrk := TClientDataSet.Create(nil);
    cds_FouMrk.FieldDefs.Add('FOUID',ftInteger,0);
    cds_FouMrk.FieldDefs.Add('MRKID',ftInteger,0);
    cds_FouMrk.FieldDefs.Add('FAIT',ftInteger,0);
    cds_FouMrk.CreateDataSet;
    cds_FouMrk.LogChanges := False;
    cds_FouMrk.Open;


    case Dm_Main.Provenance of
      ipUnderterminate:;
      ipGinkoia, ipInterSys, ipDataMag, ipNosymag, ipGoSport, ipExotiqueISF, ipLocalBase:{$REGION 'Process: common'}
      begin
        if not(bRecalStock) then
        begin
          if bRepriseTicket then
          begin
            NbTraitement := 8;
          end
          else
          begin
            case Dm_Main.Provenance of
              ipUnderterminate: raise Exception.Create( 'Empty' );
              ipGinkoia, ipNosymag, ipGoSport, ipLocalBase: NbTraitement := 17;
              else NbTraitement := 15;
            end;
          end;

          // preparation liste article pour recalcul stock
          InfoErreur := 'MG10_STOCK_TMPSTAT: ';
          StProc_PrepareRecalStk := TIBSQL.Create(nil);
          with StProc_PrepareRecalStk do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add('EXECUTE PROCEDURE MG10_STOCK_TMPSTAT(:ARTID)');
            Prepare;
          end;

          // caisse - poste
          InfoErreur := 'MG10_CAISSE_POSTE: ';
          StProc_Caisse_Poste := TIBSQL.Create(nil);
          with StProc_Caisse_Poste do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CAISSE_POSTE);
            Prepare;
          end;

          // caisse - Session
          InfoErreur := 'MG10_CAISSE_SESSION: ';
          StProc_Caisse_Session := TIBSQL.Create(nil);
          with StProc_Caisse_Session do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CAISSE_SESSION);
            Prepare;
          end;

          // caisse - Entete
          InfoErreur := 'MG10_CAISSE_ENTETE: ';
          StProc_Caisse_Entete := TIBSQL.Create(nil);
          with StProc_Caisse_Entete do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
              SQL.Add(cSql_MG10_CAISSE_ENTETE_2)
            else
              SQL.Add(cSql_MG10_CAISSE_ENTETE);
            Prepare;
          end;

          // caisse - Ligne
          InfoErreur := 'MG10_CAISSE_LIGNE: ';
          StProc_Caisse_Ligne := TIBSQL.Create(nil);
          with StProc_Caisse_Ligne do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CAISSE_LIGNE);
            Prepare;
          end;

          // caisse - Init BI
          InfoErreur := 'MG10_INIT_BI: ';
          StProc_Init_BI := TIBStoredProc.Create(nil);
          Que_Init_BI := TIBSQL.Create(nil);
          with StProc_Init_BI do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'ISFBI_ADDMVT';
            Prepare;
          end;
          with Que_Init_BI do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
          end;

          // Caisse - Recalcul entete ticket
          InfoErreur := 'MG10_CAISSE_RECALTICK: ';
          StProc_Caisse_RecalTick := TIBStoredProc.Create(nil);
          with StProc_Caisse_RecalTick do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'MG10_CAISSE_RECALTICK';
            Prepare;
          end;

          // réception - Entete
          InfoErreur := 'MG10_RECEPTION_ENTETE: ';
          StProc_Reception_Entete := TIBSQL.Create(nil);
          with StProc_Reception_Entete do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            SQL.Add(cSql_MG10_RECEPTION_ENTETE);
            Prepare;
          end;

          // réception - Ligne
          InfoErreur := 'MG10_RECEPTION_LIGNE: ';
          StProc_Reception_Ligne := TIBSQL.Create(nil);
          with StProc_Reception_Ligne do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            SQL.Add(cSql_MG10_RECEPTION_LIGNE);
            Prepare;
          end;

          // réception - Recalcul entete ticket
          InfoErreur := 'MG10_RECEPTION_RECALTICK: ';
          StProc_Reception_RecalTick := TIBStoredProc.Create(nil);
          with StProc_Reception_RecalTick do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'MG10_RECEPTION_RECALTICK';
            Prepare;
          end;

          // pour la création d'un faux fournisseur pour l'init du pump
          InfoErreur := 'MG10_FOURN: ';
          StProc_Fourn := TIBSQL.Create(nil);
          with StProc_Fourn do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            if (Dm_Main.Provenance in [ipNosymag, ipLocalBase]) then
              SQL.Add(cSql_MG10_FOURN_2)
            else
              SQL.Add(cSql_MG10_FOURN);
            Prepare;
          end;

          // consodiv
          InfoErreur := 'MG10_CONSODIV: ';
          StProc_Consodiv := TIBSQL.Create(nil);
          with StProc_Consodiv do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CONSODIV);
            Prepare;
          end;

          // transfert
          InfoErreur := 'MG10_TRANSFERT: ';
          StProc_Transfert := TIBSQL.Create(nil);
          with StProc_Transfert do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_TRANSFERT);
            Prepare;
          end;

          // transfert - recalcul entete
          InfoErreur := 'MG10_TRANSFERT_RECAL: ';
          StProc_Transfert_Recal := TIBStoredProc.Create(nil);
          with StProc_Transfert_Recal do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'MG10_TRANSFERT_RECAL';
            Prepare;
          end;

          // Commande - Entete
          InfoErreur := 'MG10_COMMANDE_ENTETE: ';
          StProc_Commande_Entete := TIBSQL.Create(nil);
          with StProc_Commande_Entete do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_COMMANDE_ENTETE);
            Prepare;
          end;

          // Commande - Ligne
          InfoErreur := 'MG10_COMMANDE_LIGNE: ';
          StProc_Commande_Ligne := TIBSQL.Create(nil);
          with StProc_Commande_Ligne do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_COMMANDE_LIGNE);
            Prepare;
          end;

          // Commande - Recalcul entete
          InfoErreur := 'MG10_COMMANDE_RECAL: ';
          StProc_Commande_Recal := TIBStoredProc.Create(nil);
          with StProc_Commande_Recal do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'MG10_COMMANDE_RECAL';
            Prepare;
          end;

          // Retour fournisseur - entete
          InfoErreur := 'MG10_RETOURFOU_ENTETE: ';
          StProc_RetourFou_Entete := TIBSQL.Create(nil);
          with StProc_RetourFou_Entete do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_RETOURFOU_ENTETE);
            Prepare;
          end;

          // Retour fournisseur - ligne
          InfoErreur := 'MG10_RETOURFOU_LIGNE: ';
          StProc_RetourFou_Ligne := TIBSQL.Create(nil);
          with StProc_RetourFou_Ligne do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_RETOURFOU_LIGNE);
            Prepare;
          end;

          // Retour fournisseur - Recalcul entete
          InfoErreur := 'MG10_RETOURFOU_RECALCTICK: ';
          StProc_RetourFou_Recal := TIBStoredProc.Create(nil);
          with StProc_RetourFou_Recal do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'MG10_RETOURFOU_RECALCTICK';
            Prepare;
          end;

          // Avoir
          InfoErreur := 'MG10_AVOIR: ';
          StProc_Avoir := TIBSQL.Create(nil);
          with StProc_Avoir do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_AVOIR);
            Prepare;
          end;

          // Bon livraison Entete
          InfoErreur := 'MG10_BL_Entete: ';
          StProc_BonLivraison := TIBSQL.Create(nil);
          with StProc_BonLivraison do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_BONLIVRAISON_ENTETE);
            Prepare;
          end;

          // Bon livraison Ligne
          InfoErreur := 'MG10_BL_Ligne: ';
          StProc_BonLivraisonL := TIBSQL.Create(nil);
          with StProc_BonLivraisonL do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_BONLIVRAISON_LIGNE);
            Prepare;
          end;

          // Bon livraison Histo
          InfoErreur := 'MG10_BL_Histo: ';
          StProc_BonLivraisonHisto := TIBSQL.Create(nil);
          with StProc_BonLivraisonHisto do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_BONLIVRAISON_HISTO);
            Prepare;
          end;

          // relation fournisseur <--> marque manquante
          InfoErreur := 'MG10_FOUMARQUE: ';
          StProc_FouMarque := TIBSQL.Create(nil);
          with StProc_FouMarque do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_FOUMARQUE);
            Prepare;
          end;

        end
        else
        begin
          case Dm_Main.Provenance of
            ipUnderterminate: raise Exception.Create( 'Empty' );
            ipGinkoia, ipNosymag, ipGoSport, ipLocalBase: NbTraitement := 4;
            else NbTraitement := 5;
          end;
        end;
      end;{$ENDREGION 'Process: common'}
      ipOldGoSport:{$REGION 'Process: OldGoSport'}
      begin
        NbTraitement := 7;//
        {$REGION 'Preparation liste article pour recalcul stock'}
        InfoErreur := 'MG10_STOCK_TMPSTAT: ';
        StProc_PrepareRecalStk := TIBSQL.Create(nil);
        with StProc_PrepareRecalStk do
        begin
          Database := Dm_Main.Database;
          Transaction := Dm_Main.TransacHis;
          ParamCheck := True;
          SQL.Add('EXECUTE PROCEDURE MG10_STOCK_TMPSTAT(:ARTID)');
          Prepare;
        end;
        {$ENDREGION 'Preparation liste article pour recalcul stock'}
        {$REGION 'Caisse (5)'}
          {$REGION 'Poste'}
          InfoErreur := 'MG10_CAISSE_POSTE: ';
          StProc_Caisse_Poste := TIBSQL.Create(nil);
          with StProc_Caisse_Poste do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CAISSE_POSTE);
            Prepare;
          end;
          {$ENDREGION 'Poste'}
          {$REGION 'Session'}
          InfoErreur := 'MG10_CAISSE_SESSION: ';
          StProc_Caisse_Session := TIBSQL.Create(nil);
          with StProc_Caisse_Session do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CAISSE_SESSION);
            Prepare;
          end;
          {$ENDREGION 'Session'}
          {$REGION 'Entête'}
          InfoErreur := 'MG10_CAISSE_ENTETE: ';
          StProc_Caisse_Entete := TIBSQL.Create(nil);
          with StProc_Caisse_Entete do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
              SQL.Add(cSql_MG10_CAISSE_ENTETE_2)
            else
              SQL.Add(cSql_MG10_CAISSE_ENTETE);
            Prepare;
          end;
          {$ENDREGION 'Entête'}
          {$REGION 'Ligne'}
          InfoErreur := 'MG10_CAISSE_LIGNE: ';
          StProc_Caisse_Ligne := TIBSQL.Create(nil);
          with StProc_Caisse_Ligne do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            ParamCheck := True;
            SQL.Add(cSql_MG10_CAISSE_LIGNE);
            Prepare;
          end;
          {$ENDREGION 'Ligne'}
          {$REGION 'Recalcul entete ticket'}
          InfoErreur := 'MG10_CAISSE_RECALTICK: ';
          StProc_Caisse_RecalTick := TIBStoredProc.Create(nil);
          with StProc_Caisse_RecalTick do
          begin
            Database := Dm_Main.Database;
            Transaction := Dm_Main.TransacHis;
            StoredProcName := 'MG10_CAISSE_RECALTICK';
            Prepare;
          end;
          {$ENDREGION 'Recalcul entete ticket'}
        {$ENDREGION 'Caisse (5)'}
        {$REGION 'Consodiv'}
        InfoErreur := 'MG10_CONSODIV: ';
        StProc_Consodiv := TIBSQL.Create(nil);
        with StProc_Consodiv do
        begin
          Database := Dm_Main.Database;
          Transaction := Dm_Main.TransacHis;
          ParamCheck := True;
          SQL.Add(cSql_MG10_CONSODIV);
          Prepare;
        end;
        {$ENDREGION 'Consodiv'}
      end;{$ENDREGION 'Process: GoSport'}
    end;
  except
    on E: Exception do
    begin
      MessageDlg('Erreur: '+ InfoErreur, mterror, [mbok],0);
      Raise;
    end;
  end;
end;

destructor THistorique.Destroy;
begin
  inherited;

  Dm_Main.TransacHis.Active := false;
  FreeAndNil(InfoLigne);
  DicUpdatePump.Free;

  if not(bRecalStock) then
  begin
    FreeAndNil(cds_Caisse);
    FreeAndNil(cds_Reception);
    FreeAndNil(cds_Consodiv);
    FreeAndNil(cds_Transfert);
    FreeAndNil(cds_Commandes);
    FreeAndNil(cds_Retourfou);
    FreeAndNil(cds_Avoir);
    FreeAndNil(cds_BonLivraison);
    FreeAndNil(cds_BonLivraisonL);
    FreeAndNil(cds_BonLivraisonHisto);

    FreeAndNil(StProc_PrepareRecalStk);
    FreeAndNil(StProc_Caisse_Poste);
    FreeAndNil(StProc_Caisse_Session);
    FreeAndNil(StProc_Caisse_Entete);
    FreeAndNil(StProc_Caisse_Ligne);
    FreeAndNil(StProc_Init_BI);
    FreeAndNil(Que_Init_BI);
    FreeAndNil(StProc_Caisse_RecalTick);
    FreeAndNil(StProc_Reception_Entete);
    FreeAndNil(StProc_Reception_Ligne);
    FreeAndNil(StProc_Reception_RecalTick);
    FreeAndNil(StProc_Fourn);
    FreeAndNil(StProc_Consodiv);
    FreeAndNil(StProc_Transfert);
    FreeAndNil(StProc_Transfert_Recal);
    FreeAndNil(StProc_Commande_Entete);
    FreeAndNil(StProc_Commande_Ligne);
    FreeAndNil(StProc_Commande_Recal);
    FreeAndNil(StProc_FouMarque);
    FreeAndNil(cds_Magasin);
    FreeAndNil(cds_TypeVen);
    FreeAndNil(cds_TypeVenBL);
    FreeAndNil(cds_StatutBL);
    FreeAndNil(cds_MotifBL);
    FreeAndNil(cds_TypePaie);
    FreeAndNil(cds_GroupPump);
    FreeAndNil(cds_CdlLiv);
    FreeAndNil(cds_FouMrk);
  end;

  FreeAndNil(ListeUsedMagasin);
end;

procedure THistorique.UpdateEtat2;
begin
  Synchronize(UpdateFrm);
end;

procedure THistorique.UpdateFrm;
begin
  Frm_Load.Lab_EtatHis1.Caption := sEtat1;
  Frm_Load.Lab_EtatHis2.Caption := sEtat2;
  Frm_Load.Lab_EtatHis2.Hint := sEtat2;
end;

procedure THistorique.UpdatePumps;
var
  Query: TIBSQL;
//  SQL: TStringBuilder;
  UpdatePumpRec: TUpdatePumpRec;
begin
  Assert(Assigned(DicUpdatePump));

  // Ne pas aller plus loin si aucun update n'est à réaliser...
  if DicUpdatePump.Count = 0 then
    Exit;

  Query := TIBSQL.Create(nil);
  try
    // Création du query
    Query.Database := Dm_Main.Database;
    Query.Transaction := Dm_Main.TransacHis;
    Query.ParamCheck := True;

    // Préparation de la requête
    Query.SQL.Add('update AGRHISTOSTOCK');
    Query.SQL.Add('set HST_ANNEE = extract(year from HST_DATE),');
    Query.SQL.Add('    HST_PUMP = :PUMP');
    Query.SQL.Add('where HST_MAGID = :MAGID');
    Query.SQL.Add('  and HST_ARTID = :ARTID');
    Query.SQL.Add('  and HST_TGFID = :TGFID');
    Query.SQL.Add('  and HST_COUID = :COUID');
    Query.SQL.Add('  and HST_DATE  = :DATE;');

    // Ouverture de la transaction
    Query.Transaction.StartTransaction;
    try
      // Pour chacune des updates à réaliser...
      for UpdatePumpRec in DicUpdatePump.Keys do
      begin
        // Préparation de chacun des updates
        Query.ParamByName('MAGID').AsInteger := UpdatePumpRec.MAG_ID;
        Query.ParamByName('ARTID').AsInteger := UpdatePumpRec.ART_ID;
        Query.ParamByName('TGFID').AsInteger := UpdatePumpRec.TGF_ID;
        Query.ParamByName('COUID').AsInteger := UpdatePumpRec.COU_ID;
        Query.ParamByName('DATE').AsDateTime := UpdatePumpRec.DATE;
        Query.ParamByName('PUMP').AsDouble := DicUpdatePump.Items[UpdatePumpRec];
        // Exécution de l'update
        Query.ExecQuery;
        Query.Close;
      end;
      Query.Transaction.Commit;
      // Nettoyage des updates
      DicUpdatePump.Clear;
    except
      Query.Transaction.Rollback;
      raise;
    end;
  finally
    Query.Free;
  end;
end;

procedure THistorique.UpdProgressFrm;
begin
  Frm_Load.Lab_EtatHis2.Caption := sEtat2;
  Frm_Load.Lab_EtatHis2.Hint := sEtat2;
  Frm_Load.pb_EtatHis.Position := iProgress;
end;

procedure THistorique.EndFrm;
var
  bm: tbitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(0, bm);
    Frm_Load.img_Historiques.Picture := nil;
    Frm_Load.img_Historiques.Picture.Assign(bm);
    Frm_Load.img_Historiques.Transparent := false;
    Frm_Load.img_Historiques.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.Lab_EtatHis1.Caption := 'Importation';
  Frm_Load.Lab_EtatHis2.Caption := 'Terminé';
  Frm_Load.Lab_EtatHis2.Hint := '';
end;

procedure THistorique.ErrorFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(10, bm);
    Frm_Load.img_Historiques.Picture := nil;
    Frm_Load.img_Historiques.Picture.Assign(bm);
    Frm_Load.img_Historiques.Transparent := false;
    Frm_Load.img_Historiques.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.DoErreurHis(sError);
end;

procedure THistorique.Execute;
var
  sFile: string;
  bContinue: boolean;
  tTot: TDateTime;
  tProc: TDateTime;
  tpListeDelai: TStringList;

  procedure EnreListeDelai;
  begin
    try
      tpListeDelai.SaveToFile(sFile);
    except
    end;
  end;

begin
  inherited;

  bError := false;
  bContinue := true;
  tpListeDelai:= TStringList.Create;
  sFile := Dm_Main.ReperBase + Dm_Main.GetSubjectMail + '_Delai_Import_Histo_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt';
  tTot := Now;
  try
    tpListeDelai.Add('  Démarrage: '+formatdatetime('hh:nn:ss:zzz', now));
    if Dm_Main.GetDoMail(AllMail) then
      SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Démarrage: '+formatdatetime('hh:nn:ss:zzz', now));
    EnreListeDelai;
    iTraitement := 0;
    Synchronize(InitExecute);

    case Dm_Main.Provenance of
      ipUnderterminate:;
      ipGinkoia, ipInterSys, ipDataMag, ipNosymag, ipGoSport, ipExotiqueISF, ipLocalBase:{$REGION 'Process: common'}
      begin
        if not(bRecalStock) then
        begin
          // Chargement des fichiers;
          if bContinue then
          begin
            tProc := Now;
            bContinue := LoadFile;
            tpListeDelai.Add('  Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Désactive les triggers
          if (bContinue) then
          begin
            tProc := Now;
            bContinue := DesactiveTrigger;
            tpListeDelai.Add('  Désactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            tpListeDelai.Add('  Etat Continue : '+BoolToStr(bContinue));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Désactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Caisse
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterCaisse;
            if bRepriseTicket then
            begin
              tpListeDelai.Add('  Reprise Ticket caisse: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Reprise Ticket caisse: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end
            else
            begin
              tpListeDelai.Add('  Caisse: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Caisse: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end;
            EnreListeDelai;
          end;

          if not(bRepriseTicket) then
          begin
{$REGION '            Si pas en reprise de tickets '}
            // Réception
            if bContinue then
            begin
              tProc := Now;
              bContinue := TraiterReception;
              tpListeDelai.Add('  Réception: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Réception: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;

            // Consodiv
            if bContinue then
            begin
              tProc := Now;
              bContinue := TraiterConsodiv;
              tpListeDelai.Add('  Consodiv: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Consodiv: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;

            // Transfert
            if bContinue then
            begin
              tProc := Now;
              bContinue := TraiterTransfert;
              tpListeDelai.Add('  Transfert: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Transfert: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;

            // Commandes
            if bContinue then
            begin
              tProc := Now;
              bContinue := TraiterCommandes;
              tpListeDelai.Add('  Commandes: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Commandes: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;

            // Retour Fournisseur
            if bContinue then
            begin
              tProc := Now;
              bContinue := TraiterRetourfou;
              tpListeDelai.Add('  Retour Fournisseur: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Retour Fournisseur: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;
{$ENDREGION}
          end;

          // Avoir
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterAvoir;
            if bRepriseTicket then
            begin
              tpListeDelai.Add('  Reprise Avoir: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Reprise Avoir: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end
            else
            begin
              tpListeDelai.Add('  Avoir: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Avoir: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end;
            EnreListeDelai;
          end;

          // BL
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterBonLivraison;
            if bRepriseTicket then
            begin
              tpListeDelai.Add('  Reprise Bon de livraison: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Reprise Bon de livraison: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end
            else
            begin
              tpListeDelai.Add('  Bon de livraison: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Bon de livraison: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end;
            EnreListeDelai;
          end;

          // BL Ligne
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterBonLivraisonL;
            if bRepriseTicket then
            begin
              tpListeDelai.Add('  Reprise Bon de livraison Ligne: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Reprise Bon de livraison Ligne: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end
            else
            begin
              tpListeDelai.Add('  Bon de livraison Ligne: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Bon de livraison Ligne: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end;
            EnreListeDelai;
          end;

          // BL Histo
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterBonLivraisonHisto;
            if bRepriseTicket then
            begin
              tpListeDelai.Add('  Reprise Bon de livraison Histo: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Reprise Bon de livraison Histo: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end
            else
            begin
              tpListeDelai.Add('  Bon de livraison Histo: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Bon de livraison Histo: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end;
            EnreListeDelai;
          end;

          if not(bRepriseTicket) then
          begin
            // Backup - Restore
            if bContinue then
            begin
              tProc := Now;
              bContinue := TraiterBackupRestore;
              tpListeDelai.Add('  Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;
          end;

          // Recalcul Stock
          if not(Dm_Main.NePasFaireLeStock) then
          begin
            if bContinue then
            begin
              tProc := Now;
              bContinue := RecalculStock;
              tpListeDelai.Add('  Recalcul Stock: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Recalcul Stock: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;

            if not(bRepriseTicket) then
            begin
              // Forçage Pump Intersys
              if bContinue and not(bStopRecal) and (Dm_Main.Provenance in [ipInterSys]) then
              begin
                tProc := Now;
                bContinue := TraiteForcePump;
                tpListeDelai.Add('  Forçage Pump Intersys: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
                if Dm_Main.GetDoMail(AllMail) then
                  SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Forçage Pump Intersys: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
                EnreListeDelai;
              end;
            end;
          end;

          // Réactive les triggers
          if (bContinue) then
          begin
            tProc := Now;
            bContinue := ActiveTrigger;
            tpListeDelai.Add('  Réactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Réactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          if not(bRepriseTicket) then
          begin
            // Backup - Restore
            if bContinue and (not(bStopRecal) or bBackupRestore)  then
            begin
              tProc := Now;
              bContinue := TraiterBackupRestore;
              tpListeDelai.Add('  Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;
          end;
        end
        else
        begin

          // Chargement des fichiers;
          if bContinue then
          begin
            tProc := Now;
            bContinue := LoadFile;
            tpListeDelai.Add('  Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Backup - Restore
          if bContinue and bBackupRestore  then
          begin
            bBackupRestore := false;
            tProc := Now;
            bContinue := TraiterBackupRestore;
            tpListeDelai.Add('  Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Recalcul Stock
          if bContinue then
          begin
            tProc := Now;
            bContinue := RecalculStock;
            tpListeDelai.Add('  Recalcul Stock: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Recalcul Stock: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Forçage Pump Intersys
          if bContinue and not(bStopRecal) and (Dm_Main.Provenance in [ipInterSys]) then
          begin
            tProc := Now;
            bContinue := TraiteForcePump;
            tpListeDelai.Add('  Forçage Pump Intersys: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Forçage Pump Intersys: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Réactive les triggers
          if (bContinue) then
          begin
            tProc := Now;
            bContinue := ActiveTrigger;
            tpListeDelai.Add('  Réactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Réactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;

          // Backup - Restore
          if bContinue and (not(bStopRecal) or bBackupRestore)  then
          begin
            tProc := Now;
            bContinue := TraiterBackupRestore;
            tpListeDelai.Add('  Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
        end;
      end;{$ENDREGION 'Process: common'}
      ipOldGoSport:{$REGION 'Process: OldGoSport'}
      begin
        //if not(bRecalStock) then
        begin
          {$REGION 'Chargement des fichiers'}
          if bContinue then
          begin
            tProc := Now;
            bContinue := LoadFile;
            tpListeDelai.Add('  Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Chargement des fichiers'}
          {$REGION 'Désactive les triggers'}
          if (bContinue) then
          begin
            tProc := Now;
            bContinue := DesactiveTrigger;
            tpListeDelai.Add('  Désactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Désactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Désactive les triggers'}
          {$REGION 'Caisse'}
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterCaisse;
            tpListeDelai.Add('  Caisse: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Caisse: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Caisse'}
          {$REGION 'Consodiv'}
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterConsodiv;
            tpListeDelai.Add('  Consodiv: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Consodiv: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Consodiv'}
          {$REGION 'Backup - Restore'}
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterBackupRestore;
            tpListeDelai.Add('  Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Backup - Restore'}
          if not Dm_Main.NePasFaireLeStock then
          begin
            {$REGION 'Recalcul Stock'}
            if bContinue then
            begin
              tProc := Now;
              bContinue := RecalculStock;
              tpListeDelai.Add('  Recalcul Stock: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              if Dm_Main.GetDoMail(AllMail) then
                SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Recalcul Stock: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              EnreListeDelai;
            end;
            {$ENDREGION 'Recalcul Stock'}
          end;

//          UpdatePumps;

          {$REGION 'Réactive les triggers'}
          if (bContinue) then
          begin
            tProc := Now;
            bContinue := ActiveTrigger;
            tpListeDelai.Add('  Réactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Réactive les triggers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Réactive les triggers'}
          {$REGION 'Backup - Restore'}
          if bContinue and (not(bStopRecal) or bBackupRestore)  then
          begin
            tProc := Now;
            bContinue := TraiterBackupRestore;
            tpListeDelai.Add('  Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Backup-Restore: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            EnreListeDelai;
          end;
          {$ENDREGION 'Backup - Restore'}
        end;
      end;{$ENDREGION 'Process: GoSport'}
    end;// Case Dm_Main.Provenance

    if sError<>'' then
    begin
      tpListeDelai.Add(sError);
      if Dm_Main.GetDoMail(ErreurMail) then
        SendEmail(Dm_Main.GetMailLst, '[ALERT - ERREUR] - ' + Dm_Main.GetSubjectMail,'Historique - ' + sError);
    end;

    tpListeDelai.Add('  Fin: '+formatdatetime('hh:nn:ss:zzz', now));
    tpListeDelai.Add('');
    tpListeDelai.Add('');
    tpListeDelai.Add('Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));
    if Dm_Main.GetDoMail(CliArtHistBonRAtelier) then
      SendEmail(Dm_Main.GetMailLst, '[Fin Historique] - ' + Dm_Main.GetSubjectMail,'Historique - Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));

    if bContinue then
      Synchronize(EndFrm);
  finally
    bError := not(bContinue);

    EnreListeDelai;

    FreeAndNil(tpListeDelai);
  end;
end;

// donne l'état si besoin de stopper le recalcul
procedure THistorique.GetStatutStopRecalcul;
begin
  bStopRecal := Frm_Load.bStopRecal;
  bBackupRestore := Frm_Load.bBackupRestore;
end;

function THistorique.GetValueAvoirImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Avoir_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueBonLivraisonHistoImp(AChamp: string): string;
begin
    Result := GetValueImp(AChamp, BonLivraisonHisto_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueBonLivraisonImp(AChamp: string): string;
begin
    Result := GetValueImp(AChamp, BonLivraison_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueBonLivraisonLImp(AChamp: string): string;
begin
    Result := GetValueImp(AChamp, BonLivraisonL_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueCaisseImp(AChamp: string): string;
begin
  if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
    Result := GetValueImp(AChamp, Caisse_2_COL, LigneLecture, bRetirePtVirg)
  else
    Result := GetValueImp(AChamp, Caisse_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueCommandesImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Commandes_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueRetourFouImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, RetourFou_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueConsodivImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Consodiv_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueReceptionImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Reception_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.GetValueTransfertImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Transfert_COL, LigneLecture, bRetirePtVirg);
end;

function THistorique.LoadFile: Boolean;
var
  Que_Tmp: TIBQuery;
begin
  result := true;

  cds_Caisse.Clear;
  cds_Reception.Clear;
  cds_Consodiv.Clear;
  cds_Transfert.Clear;
  cds_Commandes.Clear;
  cds_Retourfou.Clear;
  cds_Avoir.Clear;
  cds_BonLivraison.Clear;
  cds_BonLivraisonL.Clear;
  cds_BonLivraisonHisto.Clear;

  sEtat1 := 'Chargement:';
  Dm_Main.TransacHis.Active := true;

  // Chargement Id article, client, ...
  Que_Tmp := TIbQuery.Create(nil);
  try
    try
      Que_Tmp.Database := dm_Main.Database;

      sEtat2 := 'Id en mémoire ';
      Synchronize(UpdateFrm);
      Dm_Main.LoadListeFournID;          // founisseur par id
      Dm_Main.LoadListeFournCodeIS;      // fournisseur par code
      Dm_Main.LoadListeClientID;         // client
      Dm_Main.LoadListeArticleID;        // article
      Dm_Main.LoadListeGrTailleLigID;    // taille
      Dm_Main.LoadListeCouleurID;        // couleur
      Dm_Main.LoadListeCollectionID;     // Collection mode ID
      Dm_Main.LoadListeCollectionCodeIS; // Collection Mode Code InterSport
      // mise en mémoire de la liste des magasins
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select MAG_ID, MAG_CODEADH from genmagasin');
        SQL.Add('  join k on k_id=mag_id and k_enabled=1');
        Open;
        First;
        While not(Eof) do
        begin
          cds_Magasin.Append;
          cds_Magasin.FieldByName('MAG_ID').AsInteger := FieldByName('MAG_ID').AsInteger;
          cds_Magasin.FieldByName('MAG_CODEADH').AsString := FieldByName('MAG_CODEADH').AsString;
          cds_Magasin.Post;
          Next;
        end;
        Close;
        cds_Magasin.IndexFieldNames := 'MAG_CODEADH';
      end;
      // mise en mémoire de la liste des type de ventes
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select TYP_COD, TYP_ID from gentypcdv');
        SQL.Add('  join k on k_id=typ_id and k_enabled=1');
        Open;
        First;
        While not(Eof) do
        begin
          cds_TypeVen.Append;
          cds_TypeVen.FieldByName('TYP_COD').AsInteger := FieldByName('TYP_COD').AsInteger;
          cds_TypeVen.FieldByName('TYP_ID').AsInteger := FieldByName('TYP_ID').AsInteger;
          cds_TypeVen.Post;
          Next;
        end;
        Close;
        cds_TypeVen.IndexFieldNames := 'TYP_COD';
      end;
      // mise en mémoire de la liste des type de ventes BL
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select TYP_COD, TYP_ID, TYP_CATEG from gentypcdv');
        SQL.Add('  join k on k_id=typ_id and k_enabled=1');
        Open;
        First;
        While not(Eof) do
        begin
          cds_TypeVenBL.Append;
          cds_TypeVenBL.FieldByName('TYP_COD').AsInteger := FieldByName('TYP_COD').AsInteger;
          cds_TypeVenBL.FieldByName('TYP_CATEG').AsInteger := FieldByName('TYP_CATEG').AsInteger;
          cds_TypeVenBL.FieldByName('TYP_ID').AsInteger := FieldByName('TYP_ID').AsInteger;
          cds_TypeVenBL.Post;
          Next;
        end;
        Close;
        cds_TypeVenBL.IndexFieldNames := 'TYP_COD;TYP_CATEG';
      end;
      // mise en mémoire de la liste des Statut BL
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select BLS_CODE, BLS_ID from NEGBLSTATUT');
        SQL.Add('  join k on k_id=BLS_id and k_enabled=1');
        Open;
        First;
        While not(Eof) do
        begin
          cds_StatutBL.Append;
          cds_StatutBL.FieldByName('BLS_CODE').AsString := FieldByName('BLS_CODE').AsString;
          cds_StatutBL.FieldByName('BLS_ID').AsInteger := FieldByName('BLS_ID').AsInteger;
          cds_StatutBL.Post;
          Next;
        end;
        Close;
        cds_StatutBL.IndexFieldNames := 'BLS_CODE';
      end;
      // mise en mémoire de la liste des Motif BL
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select BLM_CODE, BLM_ID from NEGBLMOTIF');
        SQL.Add('  join k on k_id=BLM_id and k_enabled=1');
        Open;
        First;
        While not(Eof) do
        begin
          cds_MotifBL.Append;
          cds_MotifBL.FieldByName('BLM_CODE').AsString := FieldByName('BLM_CODE').AsString;
          cds_MotifBL.FieldByName('BLM_ID').AsInteger := FieldByName('BLM_ID').AsInteger;
          cds_MotifBL.Post;
          Next;
        end;
        Close;
        cds_MotifBL.IndexFieldNames := 'BLM_CODE';
      end;
      // mise en mémoire de la liste des type de paiement
      with Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT CPA_CODE, CPA_ID FROM gencdtpaiement');
        SQL.Add('  join k on k_id=cpa_id and k_enabled=1');
        Open;
        First;
        While not(Eof) do
        begin
          cds_TypePaie.Append;
          cds_TypePaie.FieldByName('CPA_CODE').AsInteger := FieldByName('CPA_CODE').AsInteger;
          cds_TypePaie.FieldByName('CPA_ID').AsInteger := FieldByName('CPA_ID').AsInteger;
          cds_TypePaie.Post;
          Next;
        end;
        Close;
        cds_TypePaie.IndexFieldNames := 'CPA_CODE';
      end;
      // mise en mémoire du groupe de pump pour Intersys
      if Dm_Main.Provenance in [ipInterSys] then
      begin
        with Que_Tmp do
        begin
          SQL.Clear;
          SQL.Add('SELECT MPU_MAGID,MPU_GCPID FROM GENMAGGESTIONPUMP');
          SQL.Add('  JOIN K ON K_ID=MPU_ID AND K_ENABLED=1');
          SQL.Add(' where mpu_id<>0');
          Open;
          First;
          while not(Eof) do
          begin
            cds_GroupPump.Append;
            cds_GroupPump.FieldByName('MPU_MAGID').AsInteger := FieldByName('MPU_MAGID').AsInteger;
            cds_GroupPump.FieldByName('MPU_GCPID').AsInteger := FieldByName('MPU_GCPID').AsInteger;
            cds_GroupPump.Post;
            Next;
          end;
          Close;
        end;
      end;
    except
      on E:Exception do
      begin
        Result := false;
        sError := E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  finally
    Que_Tmp.Close;
    FreeAndNil(Que_Tmp);
  end;

  // Chargement Caisse
  if sPathCaisse<>'' then
  begin
    try
      sEtat2 := 'Fichier ' + Caisse_CSV;
      Synchronize(UpdateFrm);
      cds_Caisse.LoadFromFile(sPathCaisse);
      cds_Caisse.Clear;
      Dm_Main.LoadListeCaisseID;
    except
      on E:Exception do
      begin
        Result := false;
        sError := 'Fichier CAISSE: '+E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

  if not(bRepriseTicket) then
  begin
{$REGION '    Si pas reprise de ticket '}
    // Chargement Reception
    if sPathReception<>'' then
    begin
      try
        sEtat2 := 'Fichier ' + Reception_CSV;
        Synchronize(UpdateFrm);
        cds_Reception.LoadFromFile(sPathReception);
        cds_Reception.Clear;
        Dm_Main.LoadListeReceptionID;
      except
        on E:Exception do
        begin
          Result := false;
          sError := 'Fichier RECEPTION: '+E.Message;
          Synchronize(ErrorFrm);
          exit;
        end;
      end;
    end;

    // Chargement Consodiv
    if sPathConsodiv<>'' then
    begin
      try
        sEtat2 := 'Fichier ' + Consodiv_CSV;
        Synchronize(UpdateFrm);
        cds_Consodiv.LoadFromFile(sPathConsodiv);
        cds_Consodiv.Clear;
        Dm_Main.LoadListeConsodivID;
      except
        on E:Exception do
        begin
          Result := false;
          sError := 'Fichier CONSODIV: '+E.Message;
          Synchronize(ErrorFrm);
          exit;
        end;
      end;
    end;

    // Chargement Transfert
    if sPathTransfert<>'' then
    begin
      try
        sEtat2 := 'Fichier ' + Transfert_CSV;
        Synchronize(UpdateFrm);
        cds_Transfert.LoadFromFile(sPathTransfert);
        cds_Transfert.Clear;
        Dm_Main.LoadListeTransfertID;
      except
        on E:Exception do
        begin
          Result := false;
          sError := 'Fichier TRANSFERT: '+E.Message;
          Synchronize(ErrorFrm);
          exit;
        end;
      end;
    end;

    // Chargement Commandes
    if sPathCommandes<>'' then
    begin
      try
        sEtat2 := 'Fichier ' + Commandes_CSV;
        Synchronize(UpdateFrm);
        cds_Commandes.LoadFromFile(sPathCommandes);
        cds_Commandes.Clear;
        Dm_Main.LoadListeCommandesID;
      except
        on E:Exception do
        begin
          Result := false;
          sError := 'Fichier COMMANDE: '+E.Message;
          Synchronize(ErrorFrm);
          exit;
        end;
      end;
    end;

    // Chargement RetourFou
    if sPathRetourfou<>'' then
    begin
      try
        sEtat2 := 'Fichier ' + RetourFou_CSV;
        Synchronize(UpdateFrm);
        cds_Retourfou.LoadFromFile(sPathRetourfou);
        cds_Retourfou.Clear;
        Dm_Main.LoadListeRetourfouID;
      except
        on E:Exception do
        begin
          Result := false;
          sError := 'Fichier RETOUR FOURNISSEUR: '+E.Message;
          Synchronize(ErrorFrm);
          exit;
        end;
      end;
    end;
{$ENDREGION}
  end;

  // Avoir
  if sPathAvoir<>'' then
  begin
    try
      sEtat2 := 'Fichier ' + Avoir_CSV;
      Synchronize(UpdateFrm);
      cds_Avoir.LoadFromFile(sPathAvoir);
      cds_Avoir.Clear;
      Dm_Main.LoadListeAvoirID;
    except
      on E:Exception do
      begin
        Result := false;
        sError := 'Fichier Avoir: '+E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

  // Bon Livraison Entete
  if sPathBonLivraison<>'' then
  begin
    try
      sEtat2 := 'Fichier ' + BonLivraison_CSV;
      Synchronize(UpdateFrm);
      cds_BonLivraison.LoadFromFile(sPathBonLivraison);
      cds_BonLivraison.Clear;
      Dm_Main.LoadListeBonLivraisonID;
    except
      on E:Exception do
      begin
        Result := false;
        sError := 'Fichier Bon Livraison Entete: '+E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

  // Bon Livraison Ligne
  if sPathBonLivraisonL<>'' then
  begin
    try
      sEtat2 := 'Fichier ' + BonLivraisonL_CSV;
      Synchronize(UpdateFrm);
      cds_BonLivraisonL.LoadFromFile(sPathBonLivraisonL);
      cds_BonLivraisonL.Clear;
      Dm_Main.LoadListeBonLivraisonLID;
    except
      on E:Exception do
      begin
        Result := false;
        sError := 'Fichier Bon Livraison Ligne: '+E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

  // Bon Livraison Histo
  if sPathBonLivraisonHisto<>'' then
  begin
    try
      sEtat2 := 'Fichier ' + BonLivraisonHisto_CSV;
      Synchronize(UpdateFrm);
      cds_BonLivraisonHisto.LoadFromFile(sPathBonLivraisonHisto);
      cds_BonLivraisonHisto.Clear;
      Dm_Main.LoadListeBonLivraisonHistoID;
    except
      on E:Exception do
      begin
        Result := false;
        sError := 'Fichier Bon Livraison Histo: '+E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;
end;

// on rend invisible le bouton "Stop Recalcul Stock"
procedure THistorique.NotCanAnnuleRecalcul;
begin
  Frm_Load.DoCanStopRecal(false);
end;

procedure THistorique.InitExecute;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(3, bm);
    Frm_Load.img_Historiques.Picture:=nil;
    Frm_Load.img_Historiques.Picture.Assign(bm);
    Frm_Load.img_Historiques.Transparent := false;
    Frm_Load.img_Historiques.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
end;

procedure THistorique.InitFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(11, bm);
    Frm_Load.img_Historiques.Picture:=nil;
    Frm_Load.img_Historiques.Picture.Assign(bm);
    Frm_Load.img_Historiques.Transparent := false;
    Frm_Load.img_Historiques.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.Lab_EtatHis1.Caption := 'Initialisation';
  Frm_Load.Lab_EtatHis2.Caption := '';
  Frm_Load.Lab_EtatHis2.Hint := '';
end;

procedure THistorique.InitProgressFrm;
begin
  Frm_Load.pb_EtatHis.Position := 0;
  Frm_Load.pb_EtatHis.Max := iMaxProgress;
end;

procedure THistorique.InitThread(ARetirePtVirg: boolean; aPathCaisse, aPathReception,
  aPathConsodiv, aPathTransfert, aPathCommandes, aPathRetourfou, aPathAvoir,
  aPathBonLivraison, aPathBonLivraisonL, aPathBonLivraisonHisto : string);
begin
  bStopRecal := false;
  Synchronize(InitFrm);

  bRetirePtVirg := ARetirePtVirg;

  sPathCaisse     := aPathCaisse;
  sPathReception  := aPathReception;
  sPathConsodiv   := aPathConsodiv;
  sPathTransfert  := aPathTransfert;
  sPathCommandes  := aPathCommandes;
  sPathRetourfou  := aPathRetourfou;
  sPathAvoir      := aPathAvoir;
  sPathBonLivraison := aPathBonLivraison;
  sPathBonLivraisonL := aPathBonLivraisonL;
  sPathBonLivraisonHisto := aPathBonLivraisonHisto;
end;

function THistorique.DesactiveTrigger : Boolean;    // desactive les trigger
var
  StProc_DesactiveTrigger : TIBSQL;
begin
  Result := false;

  iMaxProgress := 1;
  iProgress := 0;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') " Désactive Trigger ":';
  sEtat2 := '';
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  StProc_DesactiveTrigger := TIBSQL.Create(nil);
  try
    try
      with StProc_DesactiveTrigger do
      begin
        Database := Dm_Main.Database;
        Transaction := Dm_Main.TransacHis;
        ParamCheck := True;
        SQL.Add('EXECUTE PROCEDURE BN_ACTIVETRIGGER(0)');
        Prepare;

        if not(Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.StartTransaction;

        ExecQuery;

        Dm_Main.TransacHis.Commit;

        Result := true;

      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_DesactiveTrigger.Close;
    FreeAndNil(StProc_DesactiveTrigger);
  end;
end;

// ajoute ArtID dans tmpstat (id=9999) en prévision de récalculer son stock
procedure THistorique.AjoutPrepareRecalStk(AArtID: integer);
begin
  try
    StProc_PrepareRecalStk.Close;
    StProc_PrepareRecalStk.ParamByName('ARTID').AsInteger := AArtID;
    StProc_PrepareRecalStk.ExecQuery;
    StProc_PrepareRecalStk.Close;
  except
    on E: Exception do
    begin
      E.Message := 'AjoutPrepareRecalStk '+E.Message;
      raise;
    end;
  end;
end;

function THistorique.TraiterCaisse: Boolean;
var
  bActifBI: Boolean;
  bInitBI: Boolean;
  iMagID: integer;
  MagCode: String;
  sTmpMag: string;
  iPosID: integer;
  PosCode: string;
  iSesID: integer;
  SesCode: string;
  iTypID: integer;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  sTmpPos: string;
  sTmpSes: string;
  iNTick: integer;
  iNumeroTickBase: integer;
  iTmpNTi: integer;
  sTmpNTi: string;
  sCmpNTi: string;
  vPrevNTi: string;
  dDate  : TDateTime;
  iCliID: integer;
  sTmpCli: string;

  sCode: string;
  iTkeID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  NumTick: integer;
  bStop: boolean;
  LstErreur: TStringList;
  ProcErr: string;

  vRem: Double;
  vPxBrut: double;
  vPxNet: Double;
  vPxNN: Double;
  vQte: integer;

  sFilePath : string;
  iNumFile : Integer;

  dTemp: TDatetime;

  dtot: TDatetime;

  itRecal: integer;
  dRecal: TDatetime;
  itEntete: integer;
  dEntete: TDatetime;
  itLigne: integer;
  dLigne: TDatetime;
  itSession: integer;
  dSession: TDatetime;
  itPoste: integer;
  dPoste: TDatetime;
  itRech: integer;
  dRech: TDatetime;
  itCommit: integer;
  dCommit: TDatetime;
  itPrepare: integer;
  dPrepare: TDatetime;

  Que_EAN: TIBQuery;


  Maintenant: TDateTime;
  LstDelaiCai: TStringList;

  {$IFDEF DEBUG}
  procedure EnreDelai(ACompter: integer);
  begin
    LstDelaiCai.Add('Enregistrement position = '+inttostr(ACompter));
    LstDelaiCai.Add('  Total: '+formatdatetime('hh:nn:ss:zzz', now-dtot));
    LstDelaiCai.Add('  Recal: '+formatdatetime('hh:nn:ss:zzz', dRecal)+' = '+inttostr(itRecal)+' passages');
    LstDelaiCai.Add('  Entete: '+formatdatetime('hh:nn:ss:zzz', dEntete)+' = '+inttostr(itEntete)+' passages');
    LstDelaiCai.Add('  Ligne: '+formatdatetime('hh:nn:ss:zzz', dLigne)+' = '+inttostr(itLigne)+' passages');
    LstDelaiCai.Add('  Session: '+formatdatetime('hh:nn:ss:zzz', dSession)+' = '+inttostr(itSession)+' passages');
    LstDelaiCai.Add('  Poste: '+formatdatetime('hh:nn:ss:zzz', dPoste)+' = '+inttostr(itPoste)+' passages');
    LstDelaiCai.Add('  Recherche: '+formatdatetime('hh:nn:ss:zzz', dRech)+' = '+inttostr(itRech)+' passages');
    LstDelaiCai.Add('  Commit: '+formatdatetime('hh:nn:ss:zzz', dCommit)+' = '+inttostr(itCommit)+' passages');
    LstDelaiCai.Add('  Prepare Stk: '+formatdatetime('hh:nn:ss:zzz', dPrepare)+' = '+inttostr(itPrepare)+' passages');
    LstDelaiCai.SaveToFile(Dm_Main.ReperBase+'Delai_Caisse_'+FormatDateTime('yy-mm-dd hhnnss', Maintenant)+'.txt');
    dtot := now;
    itRecal := 0;
    dRecal := 0.0;
    itEntete := 0;
    dEntete := 0.0;
    itLigne := 0;
    dLigne := 0.0;
    itSession := 0;
    dSession := 0.0;
    itPoste := 0;
    dPoste := 0.0;
    itRech := 0;
    dRech := 0.0;
    itCommit := 0;
    dCommit := 0.0;
    itPrepare := 0;
    dPrepare := 0.0;
  end;
  {$ENDIF}

begin
  bActifBI := False;
  bInitBI := False;
  Maintenant := now;
  dtot := now;
  dRecal := 0.0;
  itRecal := 0;
  itEntete := 0;
  dEntete := 0.0;
  itLigne := 0;
  dLigne := 0.0;
  itSession := 0;
  dSession := 0.0;
  itPoste := 0;
  dPoste := 0.0;
  itRech := 0;
  dRech := 0.0;
  itCommit := 0;
  dCommit := 0.0;
  itPrepare := 0;
  dPrepare := 0.0;

  Result := false;
  iNumFile := 0;
  sFilePath := sPathCaisse;

  iMagID := 0;
  MagCode := '';
  iPosID  := 0;
  PosCode := '';
  iSesID  := 0;
  SesCode := '';
  iTkeId  := 0;
  sTmpNTi := '';
  sCmpNTi := '';
  iNTick  := 0;
  NumTick := 1;
  bStop := false;
  ProcErr := '';
  iNumeroTickBase := 1;

  i := 1;

  inc(iTraitement);

  LstDelaiCai := TStringList.Create;
  LstErreur := TStringList.Create;

  NbRech := Dm_Main.ListeIDCaisse.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID

  Que_EAN := TIBQuery.Create( nil );
  Que_EAN.Database := Dm_Main.Database;
  Que_EAN.SQL.Add( 'select ARA_ARTID, ARA_TGFID, ARA_COUID' );
  Que_EAN.SQL.Add( 'from ARTRELATIONART join K on K_ID = ARA_ID and K_ENABLED = 1' );
  Que_EAN.SQL.Add( 'where ARA_CODEART = :EAN;' );

  if bRepriseTicket then  //Init fait uniquement en reprise de caisse
  begin
    if not(Dm_Main.TransacHis.InTransaction) then
      Dm_Main.TransacHis.StartTransaction;

    Que_Init_BI.Close;
    Que_Init_BI.SQL.Text := 'SELECT Max(DOS_FLOAT) AS DOS_FLOAT FROM GENDOSSIER JOIN K ON (K_ID = DOS_ID AND K_ENABLED = 1) WHERE DOS_NOM = :DOSNOM';
    Que_Init_BI.ParamByName('DOSNOM').AsString  := 'EXPORTBI';
    Que_Init_BI.ExecQuery;

    if (not Que_Init_BI.Eof) AND (Que_Init_BI.FieldByName('DOS_FLOAT').AsFloat = 1) then
    begin
      bActifBI := True;
    end
    else
    begin
      bActifBI := False;
    end;
  end;


  try
    try
      while FileExists(sFilePath) do
      begin
        i := 1;
        try
          cds_Caisse.Clear;
          cds_Caisse.LoadFromFile(sFilePath);
        except
          on E: Exception do
          begin
            if bRepriseTicket then
              sError := 'Traitement Reprise Ticket ' + E.Message
            else
              sError := 'Traitement Caisse ' + E.Message;
            DoLog(sError, logError);
            Synchronize(ErrorFrm);
            exit;
          end;
        end;

        iMaxProgress := cds_Caisse.Count-1;
        doLog('nombre de lignes à traiter : ' + IntToStr(iMaxProgress), logInfo);
        iProgress := 0;
        AvancePc := Round((iMaxProgress/100)*2);
        if AvancePc<=0 then
          AvancePc := 1;
        if AvancePc>1000 then
          AvancePc := 1000;
        if bRepriseTicket then
          sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "Reprise Ticket":'
        else
          sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "'+ExtractFileName(sFilePath)+'":';
        sEtat2 := '0 / '+inttostr(iMaxProgress);
        Synchronize(UpdateFrm);
        Synchronize(InitProgressFrm);

        NbEnre := cds_Caisse.Count-1;
        while (i<=NbEnre) do
        begin
          // maj de la fenetre
          sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
          begin
            {$IFDEF DEBUG}
            EnreDelai(i);
            {$ENDIF}
            Synchronize(UpdProgressFrm);
          end;

          if cds_Caisse[i]<>'' then
          begin
            // ajout ligne
            if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
              AjoutInfoLigne(cds_Caisse[i], Caisse_2_COL)
            else
              AjoutInfoLigne(cds_Caisse[i], Caisse_COL);

            // poste et mag
            sTmpMag := GetValueCaisseImp('CODE_MAG');
            sTmpPos := GetValueCaisseImp('CODE_POSTE');

{$REGION '             Recalcul si changement de magasin/poste '}
            if (MagCode<>sTmpMag) or (sTmpPos<>PosCode) then
            begin
              doLog(format('changement de mag/poste ligne %d', [I+1]), logDebug);
              if (iTkeID<>0) then
              begin
                {$IFDEF DEBUG}
                dTemp := now;
                {$ENDIF}
                ProcErr := 'MG10_CAISSE_RECALTICK';
                StProc_Caisse_RecalTick.ParamByName('TKEID').AsInteger := iTkeID;
                StProc_Caisse_RecalTick.ExecProc;
                {$IFDEF DEBUG}
                dTemp := now-dTemp;
                inc(itRecal);
                dRecal := AjouteTemps(dRecal, dTemp);
                {$ENDIF}
                {$IFDEF DEBUG}
                dTemp := now;
                {$ENDIF}
                Dm_Main.TransacHis.Commit;
                {$IFDEF DEBUG}
                dTemp := now-dTemp;
                inc(itCommit);
                dCommit := AjouteTemps(dCommit, dTemp);
                {$ENDIF}
                if ( Dm_Main.Provenance in [ipInterSys]) and (sTmpNTi <> '') then // intersys et n° de ticket pas vide
                begin
                  Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+sTmpNTi);
                  doLog(Format('ajout dans fichier ID : %s (actuellement sur "%s", precedent : "%s")', [PosCode+';'+SesCode+';'+sTmpNTi, GetValueCaisseImp('NUM_TICKET'), sCmpNTi]), logDebug);
                end
                else
                begin
                  Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+inttostr(iNTick));
                  doLog(Format('ajout dans fichier ID : %s (actuellement sur "%s", precedent : "%s")', [PosCode+';'+SesCode+';'+inttostr(iNTick), GetValueCaisseImp('NUM_TICKET'), sCmpNTi]), logDebug);
                end
              end;
              iTkeID := 0;
              NumTick := 1;
              // magasin
              MagCode := sTmpMag;
              iMagID := 0;
              if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
                iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
              if iMagID=0 then
                raise Exception.Create('Magasin non trouvé pour:' +#13#10+ '  - CODE_MAG = '+MagCode);
              ListeUsedMagasin.Add(IntToStr(iMagID));

              if bRepriseTicket AND bActifBI then  //Init fait uniquement en reprise de caisse
              begin
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;

                Que_Init_BI.Close;
                Que_Init_BI.SQL.Text := 'SELECT PRM_INTEGER FROM GENPARAM WHERE PRM_MAGID = :MAGID AND PRM_TYPE = 3 AND PRM_CODE = 67';
                Que_Init_BI.ParamByName('MAGID').AsInteger  := iMagID;
                Que_Init_BI.ExecQuery;
                if (not Que_Init_BI.Eof) AND (Que_Init_BI.FieldByName('PRM_INTEGER').AsFloat = 1) then
                begin
                  bInitBI := True;
                end
                else
                begin
                  bInitBI := False;
                end;
              end;

              // poste
              ProcErr := 'MG10_CAISSE_POSTE';
              PosCode := sTmpPos;
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;
              {$IFDEF DEBUG}
              dTemp := now;
              {$ENDIF}
              StProc_Caisse_Poste.Close;
              StProc_Caisse_Poste.ParamByName('MAGID').AsInteger := iMagID;
              StProc_Caisse_Poste.ParamByName('CODE_POSTE').AsString := PosCode;
              StProc_Caisse_Poste.ExecQuery;
              iPosID := StProc_Caisse_Poste.FieldByName('POSID').AsInteger;
              StProc_Caisse_Poste.Close;
              {$IFDEF DEBUG}
              dTemp := now-dTemp;
              inc(itPoste);
              dPoste := AjouteTemps(dPoste, dTemp);
              {$ENDIF}
              {$IFDEF DEBUG}
              dTemp := now;
              {$ENDIF}
              Dm_Main.TransacHis.Commit;
              {$IFDEF DEBUG}
              dTemp := now-dTemp;
              inc(itCommit);
              dCommit := AjouteTemps(dCommit, dTemp);
              {$ENDIF}
              if (iPosID=0) then
                raise Exception.Create('Poste non trouvé pour:'+#13#10+
                                       '  - CODE_MAG = '+MagCode+#13#10+
                                       '  - CODE_POSTE = '+PosCode);
            end;
{$ENDREGION}

            // session
            sTmpSes := GetValueCaisseImp('CODE_SESSION');
            dDate := ConvertStrToDate(GetValueCaisseImp('DATE'));
            if sTmpSes='' then
              sTmpSes := FormatDateTime('yyyy-mm-dd', dDate)+MagCode;

{$REGION '             Recalcul si changement de session'}
            if (SesCode<>sTmpSes) then
            begin
              doLog(format('changement de session ligne %d', [I+1]), logDebug);
              if (iTkeID<>0) then
              begin
                if not(bStop) then
                begin
                  ProcErr := 'MG10_CAISSE_RECALTICK';
                  StProc_Caisse_RecalTick.ParamByName('TKEID').AsInteger := iTkeID;
                  {$IFDEF DEBUG}
                  dTemp := now;
                  {$ENDIF}
                  StProc_Caisse_RecalTick.ExecProc;
                  {$IFDEF DEBUG}
                  dTemp := now-dTemp;
                  inc(itRecal);
                  dRecal := AjouteTemps(dRecal, dTemp);
                  {$ENDIF}
                  {$IFDEF DEBUG}
                  dTemp := now;
                  {$ENDIF}
                  Dm_Main.TransacHis.Commit;
                  {$IFDEF DEBUG}
                  dTemp := now-dTemp;
                  inc(itCommit);
                  dCommit := AjouteTemps(dCommit, dTemp);
                  {$ENDIF}
                  if ( Dm_Main.Provenance = ipInterSys ) and ( sTmpNTi <> '' ) then // intersys et n° de ticket pas vide
                  begin
                    Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+sTmpNTi);
                    doLog(Format('ajout dans fichier ID : %s (actuellement sur "%s", precedent : "%s")', [PosCode+';'+SesCode+';'+sTmpNTi, GetValueCaisseImp('NUM_TICKET'), sCmpNTi]), logDebug);
                  end
                  else
                  begin
                    Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+inttostr(iNTick));
                    doLog(Format('ajout dans fichier ID : %s (actuellement sur "%s", precedent : "%s")', [PosCode+';'+SesCode+';'+inttostr(iNTick), GetValueCaisseImp('NUM_TICKET'), sCmpNTi]), logDebug);
                  end;
                end
                else
                  doLog(' - bstop', logDebug);
                bStop := false;
              end;
              iTkeID := 0;
              SesCode := sTmpSes;
              NumTick := 1;
              // nouvelle session
              ProcErr := 'MG10_CAISSE_SESSION';
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;
              {$IFDEF DEBUG}
              dTemp := now;
              {$ENDIF}
              StProc_Caisse_Session.Close;
              StProc_Caisse_Session.ParamByName('POSID').AsInteger := iPosID;
              StProc_Caisse_Session.ParamByName('DATEVTE').AsDateTime := dDate;
              StProc_Caisse_Session.ParamByName('CODESESSION').AsString := GetValueCaisseImp('CODE_SESSION');
              StProc_Caisse_Session.ExecQuery;
              iSesID := StProc_Caisse_Session.FieldByName('SESID').AsInteger;
              iNumeroTickBase := StProc_Caisse_Session.FieldByName('NTICK').AsInteger;
              StProc_Caisse_Session.Close;
              {$IFDEF DEBUG}
              dTemp := now-dTemp;
              inc(itSession);
              dSession := AjouteTemps(dSession, dTemp);
              {$ENDIF}
              sCmpNTi := '';        //SR 17/03/2014 : Si nouvelle session on efface la variable corrige bug Session 1 ticket, session suivante sans premier ticket
              Dm_Main.TransacHis.Commit;

            end;
{$ENDREGION}

            // numero ticket
            sTmpNTi := GetValueCaisseImp('NUM_TICKET');
            iTmpNTi := StrToIntDef(GetValueCaisseImp('NUM_TICKET'), 0);
            sTmpCli := GetValueCaisseImp('CODE_CLIENT');
            if (sTmpCli='0') then
              sTmpCli := '';

           // if (iNTick<>iTmpNTi) or (iTmpNTi=0) or (iTkeID=0) then
            if (sCmpNTi<>sTmpNTi) or (sCmpNTi='') or (sTmpNTi='') then
            begin
              doLog(format('changement de ticket ligne %d', [I+1]), logDebug);
              vPrevNTi := sCmpNTi;
              sCmpNTi := sTmpNTi;
              if (iTkeID<>0) then
              begin
                if not(bStop) then
                begin
                  ProcErr := 'MG10_CAISSE_RECALTICK';
                  StProc_Caisse_RecalTick.ParamByName('TKEID').AsInteger := iTkeID;
                  {$IFDEF DEBUG}
                  dTemp := now;
                  {$ENDIF}
                  StProc_Caisse_RecalTick.ExecProc;
                  {$IFDEF DEBUG}
                  dTemp := now-dTemp;
                  inc(itRecal);
                  dRecal := AjouteTemps(dRecal, dTemp);
                  {$ENDIF}
                  {$IFDEF DEBUG}
                  dTemp := now;
                  {$ENDIF}
                  Dm_Main.TransacHis.Commit;
                  {$IFDEF DEBUG}
                  dTemp := now-dTemp;
                  inc(itCommit);
                  dCommit := AjouteTemps(dCommit, dTemp);
                  {$ENDIF}
                  if ( Dm_Main.Provenance = ipInterSys ) and ( sTmpNTi <> '' ) then // intersys et n° de ticket pas vide
                  begin
                    Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+sTmpNTi);
                    doLog(Format('ajout dans fichier ID : %s (actuellement sur "%s", precedent : "%s")', [PosCode+';'+SesCode+';'+sTmpNTi, GetValueCaisseImp('NUM_TICKET'), vPrevNTi]), logDebug);
                  end
                  else
                  begin
                    Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+inttostr(iNTick));
                    doLog(Format('ajout dans fichier ID : %s (actuellement sur "%s", precedent : "%s")', [PosCode+';'+SesCode+';'+inttostr(iNTick), GetValueCaisseImp('NUM_TICKET'), vPrevNTi]), logDebug);
                  end;
                end
                else
                  doLog(' - bstop', logDebug);
                bStop := false;
              end;
              if iTmpNTi=0 then
                iNTick := NumTick
              else
                iNTick := iTmpNTi;
              inc(NumTick);
              if sTmpCli<>'' then
                iCliID := Dm_Main.GetClientID(sTmpCli)
              else
                iCliID := 0;
              if iCliID=-1 then
                iCliID := 0;

              //SR - 20/10/2016 - Correction pour prendre en compte l'id client
              if ( Dm_Main.Provenance in [ipLocalBase, ipOldGoSport] ) and ( iCliID = 0 ) and (sTmpCli <> '') then
                iCliID := StrToInt(sTmpCli);

              // recherche si pas déjà importé
              if ( Dm_Main.Provenance = ipInterSys ) and ( sTmpNTi <> '' ) then
                sCode := PosCode+';'+SesCode+';'+sTmpNTi
              else
                sCode := PosCode+';'+SesCode+';'+inttostr(iNTick);

              {$IFDEF DEBUG}
              dTemp := now;
              {$ENDIF}
              LRechID := Dm_Main.RechercheCaisseID(sCode, NbRech);
              iTkeID := 0;
              {$IFDEF DEBUG}
              dTemp := now-dTemp;
              inc(itRech);
              dRech := AjouteTemps(dRech, dTemp);
              {$ENDIF}

              if (LRechID=-1) then
              begin
                ProcErr := 'MG10_CAISSE_ENTETE';
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;
                {$IFDEF DEBUG}
                dTemp := now;
                {$ENDIF}
                StProc_Caisse_Entete.Close;
                StProc_Caisse_Entete.ParamByName('SESID').AsInteger := iSesID;
                StProc_Caisse_Entete.ParamByName('DATEVTE').AsDateTime := dDate;
                StProc_Caisse_Entete.ParamByName('TIMEVTE').AsDateTime := StrToTime(GetValueCaisseImp('HEURE'));
                if StrToIntDef(GetValueCaisseImp('NUM_TICKET'), 0)=0 then
                  StProc_Caisse_Entete.ParamByName('NUMTICKET').AsInteger := iNumeroTickBase
                else
                  StProc_Caisse_Entete.ParamByName('NUMTICKET').AsInteger := StrToIntDef(GetValueCaisseImp('NUM_TICKET'), 0);
                inc(iNumeroTickBase);
                StProc_Caisse_Entete.ParamByName('CLTID').AsInteger := iCliID;
                if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
                  StProc_Caisse_Entete.ParamByName('OLDTKEID').AsInteger := StrToInt(GetValueCaisseImp('TKEID'));
                StProc_Caisse_Entete.ExecQuery;
                {$IFDEF DEBUG}
                dTemp := now-dTemp;
                inc(itEntete);
                dEntete := AjouteTemps(dEntete, dTemp);
                {$ENDIF}
                iTkeID := StProc_Caisse_Entete.FieldByName('TKEID').AsInteger;
                StProc_Caisse_Entete.Close;
              end
              else
                doLog(Format('ligne %d pas de création d''entete car déja dans fichier ID (%s)', [I+1, sCode]), logDebug);
            end;

            // recherche si pas déjà importé
            if ( Dm_Main.Provenance = ipInterSys ) and ( sTmpNTi <> '' ) then // intersys et n° de ticket pas vide
              sCode := PosCode+';'+SesCode+';'+sTmpNTi
            else
              sCode := PosCode+';'+SesCode+';'+inttostr(iNTick);

            {$IFDEF DEBUG}
            dTemp := now;
            {$ENDIF}
            LRechID := Dm_Main.RechercheCaisseID(sCode, NbRech);
            {$IFDEF DEBUG}
            dTemp := now-dTemp;
            inc(itRech);
            dRech := AjouteTemps(dRech, dTemp);
            {$ENDIF}

            // création si pas déjà créé
            if (LRechID=-1) then
            begin
              // type de vente
              iTypID := 0;
              if (cds_TypeVen.Locate('TYP_COD', StrToIntDef(GetValueCaisseImp('TYPEVTE'), 0), [])) then
                iTypID := cds_TypeVen.FieldByName('TYP_ID').AsInteger;

              iArtID := 0;
              iTgfID := 0;
              iCouID := 0;
              case Dm_Main.Provenance of
                ipLocalBase: begin
                  iArtID := StrToInt(GetValueCaisseImp('CODE_ART'));
                  iTgfID := StrToInt(GetValueCaisseImp('CODE_TAILLE'));
                  iCouID := StrToInt(GetValueCaisseImp('CODE_COUL'));
                end;
                ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
                  iArtID := Dm_Main.GetArtID(GetValueCaisseImp('CODE_ART'));
                  iTgfID := Dm_Main.GetTgfID(GetValueCaisseImp('CODE_TAILLE'));
                  iCouID := Dm_Main.GetCouID(GetValueCaisseImp('CODE_COUL'));
                end;
                ipInterSys, ipExotiqueISF : begin
                  iArtID := Dm_Main.GetArtID(GetValueCaisseImp('CODE_ART'));
                  iTgfID := Dm_Main.GetTgfID(GetValueCaisseImp('CODE_TAILLE'));
                  iCouID := Dm_Main.GetCouID(GetValueCaisseImp('CODE_COUL')+GetValueCaisseImp('CODE_ART'));
                end;
                ipOldGoSport: begin
                  Que_EAN.ParamByName( 'EAN' ).AsString := GetValueCaisseImp( 'EAN' );
                  Que_EAN.Open;
                  iArtID := Que_EAN.FieldByName( 'ARA_ARTID' ).AsInteger;
                  iTgfID := Que_EAN.FieldByName( 'ARA_TGFID' ).AsInteger;
                  iCouID := Que_EAN.FieldByName( 'ARA_COUID' ).AsInteger;
                  Que_EAN.Close;
                end;
              end;

              // article
              if iArtID<=0 then
              begin
                bStop := true;
                if (Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.Rollback;
                LstErreur.Add(Format('Ligne %d/%d: Article non trouvé - EAN = "%s"', [
                  i + 1,
                  NbEnre + 1,
                  GetValueCaisseImp('EAN')
                ]));
              end;
              // taille
              if iTgfID<0 then
                iTgfID := 0;
              if (iTgfID=0) and (GetValueCaisseImp('CODE_TAILLE')<>'0') then
              begin
                bStop := true;
                if (Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.Rollback;

                LstErreur.Add(Format('Ligne %d/%d: Code taille non trouvé: "%s" pour l''article: "%s"', [
                  i + 1,
                  NbEnre + 1,
                  GetValueCaisseImp('CODE_TAILLE'),
                  GetValueCaisseImp('EAN')
                ]));
              end;

              // Couleur
              if iCouID<0 then
                iCouID := 0;
              if (iCouID=0) and (GetValueCaisseImp('CODE_COUL')<>'0') then
              begin
                bStop := true;
                if (Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.Rollback;

                LstErreur.Add(Format('Ligne %d/%d: Code couleur non trouvé: "%s" pour l''article: "%s"', [
                  i + 1,
                  NbEnre + 1,
                  GetValueCaisseImp('CODE_COUL'),
                  GetValueCaisseImp('EAN')
                ]));
              end;

              if not(bStop) then
              begin
                {$IFDEF DEBUG}
                dTemp := now;
                {$ENDIF}
                vPxNN := ConvertStrToFloat(GetValueCaisseImp('PXNN'));
                vPxBrut := ConvertStrToFloat(GetValueCaisseImp('PXBRUT'));
                vQte := StrToIntDef(GetValueCaisseImp('QTE'), 0);
                vRem := 0;
                if (Abs(vPxBrut)>0.001) and (vQte<>0) then
                  vRem := ArrondiA2(((vPxBrut-vPxNN)/vPxBrut)*100);

                vPxNet := ArrondiA2(vPxNN*vQte);
                //Traitement des lignes
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;

                ProcErr := 'MG10_CAISSE_LIGNE';
                StProc_Caisse_Ligne.Close;
                StProc_Caisse_Ligne.ParamByName('TKEID').AsInteger      := iTkeID;
                StProc_Caisse_Ligne.ParamByName('ARTID').AsInteger      := iArtID;
                StProc_Caisse_Ligne.ParamByName('TGFID').AsInteger      := iTgfID;
                StProc_Caisse_Ligne.ParamByName('COUID').AsInteger      := iCouID;
                StProc_Caisse_Ligne.ParamByName('PXBRUT').AsDouble      := vPxBrut;
                StProc_Caisse_Ligne.ParamByName('REMISE').AsDouble      := vRem;
                StProc_Caisse_Ligne.ParamByName('PXNET').AsDouble       := vPxNet;
                StProc_Caisse_Ligne.ParamByName('PXNN').AsDouble        := vPxNN;
                StProc_Caisse_Ligne.ParamByName('TVA').AsDouble         := ConvertStrToFloat(GetValueCaisseImp('TVA'));
                StProc_Caisse_Ligne.ParamByName('QTE').AsInteger        := vQte;
                StProc_Caisse_Ligne.ParamByName('TYPID').AsInteger      := iTypID;
                StProc_Caisse_Ligne.ExecQuery;

                //SR - 10/09/2014 - Ajout de l'init BI
                if bRepriseTicket AND bActifBI AND bInitBI then  //Init fait uniquement en reprise de caisse et que le BI soit actif et que l'init BI soit fait.
                begin
                  StProc_Init_BI.Close;
                  StProc_Init_BI.ParamByName('MAGID').AsInteger      := iTkeID;
                  StProc_Init_BI.ParamByName('ARTID').AsInteger      := iArtID;
                  StProc_Init_BI.ParamByName('TGFID').AsInteger      := iTgfID;
                  StProc_Init_BI.ParamByName('COUID').AsInteger      := iCouID;
                  StProc_Init_BI.ParamByName('LADATE').AsDateTime    := vPxBrut;
                  StProc_Init_BI.ExecProc;
                end;

                if Dm_Main.Provenance = ipOldGoSport then
                begin
                  // Correction pour Stanley
                  DicUpdatePump.AddOrSetValue(
                    TUpdatePumpRec.Create(iMagID, iArtID, iTgfID, iCouID, ConvertStrToDate(GetValueCaisseImp('DATE'))),
                    ConvertStrToFloat(GetValueCaisseImp('PUMP'))
                  );
                end;

                {$IFDEF DEBUG}
                dTemp := now-dTemp;
                inc(itLigne);
                dLigne := AjouteTemps(dLigne, dTemp);
                {$ENDIF}
                StProc_Caisse_Ligne.Close;

                {$IFDEF DEBUG}
                dTemp := now;
                {$ENDIF}
                AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock
                {$IFDEF DEBUG}
                dTemp := now-dTemp;
                inc(itPrepare);
                dPrepare := AjouteTemps(dPrepare, dTemp);
                {$ENDIF}

                { TODO : Gerer le PUMP provenant d'InterSys }
                if (Dm_Main.Provenance in [ipInterSys]) then  // donc InterSys
                begin
                  // Gerer la valeur du PUMP  GetValue..('PUMP')
                end;
              end
              else
                doLog(' - bStop', logDebug);

            end
            else
                doLog(Format('ligne %d pas de création de la ligne car déja dans fichier ID (%s)', [I+1, sCode]), logDebug);
          end
          else
            doLog(Format('ligne %d vide !', [I+1]), logError);

          Inc(i);
        end;
        Inc(iNumFile);
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Historique - Caisse' + IntToStr(iNumFile) + ' : '+formatdatetime('hh:nn:ss:zzz', now));

        if ((iNumFile mod 2)=0) then
        begin
          TraiterBackupRestore;
          Dec(iTraitement);
        end;
        sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'caisse' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
        doLog('changement de fichier', logNotice);
      end;

      if iTkeID<>0 then
      begin
        doLog('dernier TKEid pas vide', logDebug);
        if not(bStop) then
        begin
          ProcErr := 'MG10_CAISSE_RECALTICK';
          StProc_Caisse_RecalTick.ParamByName('TKEID').AsInteger := iTkeID;
          {$IFDEF DEBUG}
          dTemp := now;
          {$ENDIF}
          StProc_Caisse_RecalTick.ExecProc;
          {$IFDEF DEBUG}
          dTemp := now-dTemp;
          inc(itRecal);
          dRecal := AjouteTemps(dRecal, dTemp);
          {$ENDIF}
          Dm_Main.TransacHis.Commit;
          if (Dm_Main.Provenance in [ipInterSys]) and (sTmpNTi<>'') then   // intersys et n° de ticket pas vide
          begin
            Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+sTmpNTi);
            doLog(Format('dernier ajout dans fichier ID : %s', [PosCode+';'+SesCode+';'+sTmpNTi]), logDebug);
          end
          else
          begin
            Dm_Main.AjoutInListeCaisseID(PosCode+';'+SesCode+';'+inttostr(iNTick));
            doLog(Format('dernier ajout dans fichier ID : %s', [PosCode+';'+SesCode+';'+inttostr(iNTick)]), logDebug);
          end;
        end
        else
          doLog(' - bStop', logDebug);
      End;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+'): '+ProcErr+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Que_EAN.Free;

    Dm_Main.SaveListeCaisseID;
    StProc_Caisse_Ligne.Close;
    if LstErreur.Count>0 then
    begin
      if bRepriseTicket then
        LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_RepriseTicket_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt')
      else
        LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Caisse_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    end;
    FreeAndNil(LstErreur);
    cds_Caisse.Clear;
    {$IFDEF DEBUG}
    EnreDelai(i);
    {$ENDIF}
    FreeAndNil(LstDelaiCai);
  end;
end;

procedure THistorique.SortReception(iDeb, iFin: integer);
var
  I, J, P: Integer;
begin
  repeat
    I := iDeb;
    J := iFin;
    P := (iDeb + iFin) shr 1;
    repeat
      while ReceptionOrderby(cds_Reception, I, P) < 0 do Inc(I);
      while ReceptionOrderby(cds_Reception, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        if I <> J then
          cds_Reception.Exchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if iDeb < J then
      SortReception(iDeb, J);
    iDeb := I;
  until I >= iFin;
end;

function THistorique.TraiterReception: Boolean;
var
  iFouID: integer;
  FouCode: string;
  sTmpFou: string;
  iMagID: integer;
  MagCode: String;
  sTmpMag: string;
  dDate: TDateTime;
  tHeure: TDateTime;
  dCdlLiv: TDateTime;
  sNumBon: string;
  sTmpBon: string;
  sGardeBon: string;
  sNumFourn: string;
  iMrkID: integer;
  iBreID: integer;
  iCpaID: integer;
  iColID: integer;
  sTmpCol: string;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  iPseudo: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  NbRech: integer;
  LRechID: integer;
  LstErreur: TStringList;
  bStop: boolean;
  PxBrut: Double;
  Remise: Double;
  PxNet: Double;
  PxVente: Double;
  dTva: Double;
  Que_GetPxVente: TIBQuery;
  Que_GetTVA: TIBQuery;

  LstDelaiRcp: TStringList;
  Maintenant: TDatetime;
  dTot: TDatetime;
  dTemp: TDatetime;
  itRecal: integer;
  dRecal: TDatetime;
  itEntete: integer;
  dEntete: TDatetime;
  itLigne: integer;
  dLigne: TDatetime;

  sFilePath : string;
  iNumFile : Integer;

  function GetCdlLiv(AArtId, ATgfId, ACouId: integer): TDatetime;
  begin
    Result := Frac(tHeure);
    if cds_CdlLiv.Locate('ARTID;TGFID;COUID', VarArrayOf([AArtId, ATgfId, ACouId]), []) then
    begin
      Result := IncSecond(Frac(cds_CdlLiv.FieldByName('HEURE').AsDateTime), 1);
      cds_CdlLiv.Edit;
      cds_CdlLiv.FieldByName('HEURE').AsDateTime := Frac(tHeure);
      cds_CdlLiv.Post;
    end
    else
    begin
      cds_CdlLiv.Append;
      cds_CdlLiv.FieldByName('ARTID').AsInteger := AArtId;
      cds_CdlLiv.FieldByName('TGFID').AsInteger := ATgfId;
      cds_CdlLiv.FieldByName('COUID').AsInteger := ACouId;
      cds_CdlLiv.FieldByName('HEURE').AsDateTime := Frac(tHeure);
      cds_CdlLiv.Post;
    end;
    Result := Trunc(dCdlLiv)+Frac(Result);
  end;

  {$IFDEF DEBUG}
  procedure EnreDelai(ACompter: integer);
  begin
    LstDelaiRcp.Add('Enregistrement position = '+inttostr(ACompter));
    LstDelaiRcp.Add('  Total: '+formatdatetime('hh:nn:ss:zzz', now-dtot));
    LstDelaiRcp.Add('  Recal: '+formatdatetime('hh:nn:ss:zzz', dRecal)+' = '+inttostr(itRecal)+' passages');
    LstDelaiRcp.Add('  Entete: '+formatdatetime('hh:nn:ss:zzz', dEntete)+' = '+inttostr(itEntete)+' passages');
    LstDelaiRcp.Add('  Ligne: '+formatdatetime('hh:nn:ss:zzz', dLigne)+' = '+inttostr(itLigne)+' passages');
    LstDelaiRcp.SaveToFile(Dm_Main.ReperBase+'Delai_Reception_'+FormatDateTime('yy-mm-dd hhnnss', Maintenant)+'.txt');
    dtot := now;
    itRecal := 0;
    dRecal := 0.0;
    itEntete := 0;
    dEntete := 0.0;
    itLigne := 0;
    dLigne := 0.0;
  end;
  {$ENDIF}

begin
  Result  := false;
  iColID  := 0;

  Maintenant := now;
  dtot := now;
  itRecal := 0;
  dRecal := 0.0;
  itEntete := 0;
  dEntete := 0.0;
  itLigne := 0;
  dLigne := 0.0;

  iFouID := 0;
  FouCode := '';
  iMagID := 0;
  MagCode := '';
  sNumBon := '';
  iBreID := 0;
  bStop := false;
  tHeure := Frac(Time);

  i := 1;

  inc(iTraitement);

  iNumFile := 0;
  sFilePath := sPathReception;

  LstDelaiRcp := TStringList.Create;
  Que_GetPxVente := TIBQuery.Create(nil);
  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDReception.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID

  // preparation pour avoir le prix vente
  Que_GetPxVente.Database := Dm_Main.Database;
  Que_GetPxVente.Transaction := Dm_Main.Transaction;
  Que_GetPxVente.ParamCheck := True;
  Que_GetPxVente.SQL.Clear;
  Que_GetPxVente.SQL.Add('select R_PRIX from GETPRIXDEVENTE(:MAGID,');
  Que_GetPxVente.SQL.Add('                                  :ARTID,');
  Que_GetPxVente.SQL.Add('                                  :TGFID,');
  Que_GetPxVente.SQL.Add('                                  :COUID)');

  // preparation pour avoir la TVA
  Que_GetTVA := TIBQuery.Create(nil);
  Que_GetTVA.Database := Dm_Main.Database;
  Que_GetTVA.Transaction := Dm_Main.Transaction;
  Que_GetTVA.ParamCheck := True;
  Que_GetTVA.SQL.Clear;
  Que_GetTVA.SQL.Add('select TVA_TAUX ' +
                     'from ARTTVA ' +
                        'JOIN K ON (K_ID = TVA_ID AND K_ENABLED = 1) ' +
                        'JOIN ARTREFERENCE ON (ARF_TVAID = TVA_ID) ' +
                     'where ARF_ARTID = :ARTID');

  try
    try
      while FileExists(sFilePath) do
      begin
        i := 1;

        try
          cds_Reception.LoadFromFile(sFilePath);
        except
          on E: Exception do
          begin
            sError := 'Traitement Réception' +E.Message;
            DoLog(sError, logError);
            Synchronize(ErrorFrm);
            exit;
          end;
        end;

        iMaxProgress := cds_Reception.Count-1;
        iProgress := 0;
        AvancePc := Round((iMaxProgress/100)*2);
        if AvancePc<=0 then
          AvancePc := 1;
        if AvancePc>1000 then
          AvancePc := 1000;

        sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + ExtractFileName(sFilePath) + '":';
        sEtat2 := '0 / '+inttostr(iMaxProgress);
        Synchronize(UpdateFrm);
        Synchronize(InitProgressFrm);
        DoLog(sEtat1, logInfo);

        // ordre du fichier par NUMBON;DATE;CODE_FOU;CODE_MAG;CODEART pour Intersys
        if Dm_Main.Provenance in [ipInterSys, ipDataMag, ipExotiqueISF] then
        begin
          sEtat2 := 'Initialisation du fichier';
          Synchronize(UpdProgressFrm);;
          HisSoiMeme := Self;
          if cds_Reception.Count>2 then
            SortReception(1, cds_Reception.Count-1);
          sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Synchronize(UpdProgressFrm);
        end;

        NbEnre := cds_Reception.Count-1;
        while (i<=NbEnre) do
        begin
          // maj de la fenetre
          sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
          begin
            {$IFDEF DEBUG}
            EnreDelai(i);
            {$ENDIF}
            Synchronize(UpdProgressFrm);
          end;

          if cds_Reception[i]<>'' then
          begin
            // ajout ligne
            AjoutInfoLigne(cds_Reception[i], Reception_COL);

            // fournisseur
            sTmpFou := GetValueReceptionImp('CODE_FOURN');
            if (FouCode<>sTmpFou) or (iFouID=0) then
            begin
              FouCode := sTmpFou;
              iFouID := 0;
              if FouCode<>'' then
                iFouID := Dm_Main.GetFouID(FouCode);
              if iFouID=-1 then
                iFouID := 0;
            end;
            if iFouID=0 then
              Raise Exception.Create('Fournisseur non trouvé pour:'+#13#10+
                                       '  - CODE_FOURN = '+FouCode);

            // magasin
            sTmpMag := GetValueReceptionImp('CODE_MAG');
            if sTmpMag<>MagCode then
            begin
              MagCode := sTmpMag;
              iMagID := 0;
              if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
                iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
            end;
            if iMagID=0 then
              raise Exception.Create('Magasin non trouvé pour:' +#13#10+ '  - CODE_MAG = '+MagCode);
            ListeUsedMagasin.Add(IntToStr(iMagID));

            // N° de bon
            dDate := ConvertStrToDate(GetValueReceptionImp('DATE'));
            dCdlLiv := Trunc(Date);
            if (Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport, ipLocalBase]) then
            begin
              sGardeBon := Trim(GetValueReceptionImp('NUMBON'));
              sNumFourn := '';
              if Pos('##', sGardebon)>0 then
              begin
                sNumFourn := Copy(sGardeBon, Pos('##', sGardebon)+2, Length(sGardebon));
                sGardeBon := Copy(sGardeBon, 1, Pos('##', sGardebon)-1);
              end;
            end
            else
            begin
              sGardeBon := '';
              sNumFourn := Trim(GetValueReceptionImp('NUMBON'));
            end;

            sTmpBon := sGardeBon;
            if (sTmpBon='') then
              sTmpBon := sNumFourn+';'+inttostr(iFouID)+';'+inttostr(iMagID)+';'+sNumFourn+';'+FormatDateTime('yy-mm-dd', dDate);

            if (sTmpBon<>sNumBon) then
            begin
              if (iBreID<>0) then
              begin
                // validation du bon
                if not(bStop) then
                begin
                  if (iBreID<>0) then
                  begin
                    if (Dm_Main.Provenance in [ipInterSys, ipDataMag, ipExotiqueISF]) then  // intersys
                    begin
                      {$IFDEF DEBUG}
                      dTemp := now;
                      {$ENDIF}
                      try
                        StProc_Reception_RecalTick.ParamByName('NUMBON').AsString := '';
                        StProc_Reception_RecalTick.ParamByName('BREID').AsInteger := iBreID;
                        StProc_Reception_RecalTick.ExecProc;
                      except
                        on E: Exception do
                        begin
                          if (Dm_Main.TransacHis.InTransaction) then
                            Dm_Main.TransacHis.Rollback;
                          Result := false;
                          if sError <> '' then
                            sError := sError + cRC;
                          sError := sError + 'RecalTicket : ' + E.Message + ' - BREID = ' + IntToStr(iBreID);
                          DoLog(sError, logError);
                          Synchronize(UpdProgressFrm);
                          Synchronize(ErrorFrm);
                        end;
                      end;
                      {$IFDEF DEBUG}
                      dTemp := now-dTemp;
                      inc(itRecal);
                      dRecal := AjouteTemps(dRecal, dTemp);
                      {$ENDIF}
                    end;
                  end;
                  Dm_Main.TransacHis.Commit;
                  Dm_Main.AjoutInListeReceptionID(sNumBon, iBreID);
                end;
                bStop := false;
              end;
              // recherche si pas déjà importé
              LRechID := Dm_Main.RechercheReceptionID(sTmpBon, NbRech);
              iBreID := 0;
              sNumBon := sTmpBon;

              if (LRechID=-1) then
              begin
                {$IFDEF DEBUG}
                dTemp := now;
                {$ENDIF}
                // effacement de la table tempo qui gère la date de liv
                cds_CdlLiv.Close;
                cds_CdlLiv.Open;
                cds_CdlLiv.EmptyDataSet;
                tHeure := Frac(Time);
                // collection
                iColID := 0;
                sTmpCol := GetValueReceptionImp('CODE_COLLEC');
                if sTmpCol<>'' then
                  iColID := Dm_Main.GetColID(sTmpCol);
                if (iColID=-1) then
                  iColID := 0;
                // type de paiement
                iCpaID := 0;
                if cds_TypePaie.Locate('CPA_CODE', GetValueReceptionImp('CONDREG'), []) then
                  iCpaID := cds_TypePaie.FieldByName('CPA_ID').AsInteger;
                // entete de reception
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;
                try
                  StProc_Reception_Entete.Close;
                  StProc_Reception_Entete.ParamByName('NUMBON').AsString          := sGardeBon;
                  StProc_Reception_Entete.ParamByName('NUMFOURN').AsString        := sNumFourn;
                  StProc_Reception_Entete.ParamByName('BREDATE').AsDateTime       := dDate;
                  StProc_Reception_Entete.ParamByName('FOUID').AsInteger          := iFouID;
                  StProc_Reception_Entete.ParamByName('MAGID').AsInteger          := iMagID;
                  StProc_Reception_Entete.ParamByName('MRGLIB').AsString          := GetValueReceptionImp('MODEREG');
                  StProc_Reception_Entete.ParamByName('CPAID').AsInteger          := iCpaID;
                  StProc_Reception_Entete.ParamByName('COLID').AsInteger          := iColID;
                  StProc_Reception_Entete.ParamByName('DATEREGLEMENT').AsDateTime := ConvertStrToDate(GetValueReceptionImp('DATEREG'));
                  StProc_Reception_Entete.ParamByName('CLOTURE').AsInteger        := StrToIntDef(GetValueReceptionImp('CLOTURE'), 1);
                  StProc_Reception_Entete.ParamByName('TOTTVA1').AsDouble         := ConvertStrToFloat(GetValueReceptionImp('TOTTVA1'));
                  StProc_Reception_Entete.ParamByName('TVA1').AsDouble            := ConvertStrToFloat(GetValueReceptionImp('TVA1'));
                  StProc_Reception_Entete.ParamByName('TOTTVA2').AsDouble         := ConvertStrToFloat(GetValueReceptionImp('TOTTVA2'));
                  StProc_Reception_Entete.ParamByName('TVA2').AsDouble            := ConvertStrToFloat(GetValueReceptionImp('TVA2'));
                  StProc_Reception_Entete.ParamByName('TOTTVA3').AsDouble         := ConvertStrToFloat(GetValueReceptionImp('TOTTVA3'));
                  StProc_Reception_Entete.ParamByName('TVA3').AsDouble            := ConvertStrToFloat(GetValueReceptionImp('TVA3'));
                  StProc_Reception_Entete.ParamByName('TOTTVA4').AsDouble         := ConvertStrToFloat(GetValueReceptionImp('TOTTVA4'));
                  StProc_Reception_Entete.ParamByName('TVA4').AsDouble            := ConvertStrToFloat(GetValueReceptionImp('TVA4'));
                  StProc_Reception_Entete.ParamByName('TOTTVA5').AsDouble         := ConvertStrToFloat(GetValueReceptionImp('TOTTVA5'));
                  StProc_Reception_Entete.ParamByName('TVA5').AsDouble            := ConvertStrToFloat(GetValueReceptionImp('TVA5'));
                  StProc_Reception_Entete.ParamByName('ARCHIVER').AsInteger       := StrToIntDef(GetValueReceptionImp('ARCHIVER'), 1);
                  StProc_Reception_Entete.ParamByName('NUMFACT').AsString         := GetValueReceptionImp('NUMFACT');
                  StProc_Reception_Entete.ExecQuery;
                except
                  on E: Exception do
                  begin
                    if (Dm_Main.TransacHis.InTransaction) then
                      Dm_Main.TransacHis.Rollback;
                    Result := false;
                    if sError <> '' then
                      sError := sError + cRC;
                    sError := sError + 'Reception_Entete : ' + E.Message + cRC +
                      'NUMBON : ' + sGardeBon + cRC +
                      'NUMFOURN : ' + sNumFourn + cRC +
                      'BREDATE : ' + DateTimeToStr(dDate) + cRC +
                      'FOUID : ' + IntToStr(iFouID) + cRC +
                      'MAGID : ' + IntToStr(iMagID) + cRC +
                      'MRGLIB : ' + GetValueReceptionImp('MODEREG') + cRC +
                      'CPAID : ' + IntToStr(iCpaID) + cRC +
                      'COLID : ' + IntToStr(iColID) + cRC +
                      'DATEREGLEMENT : ' + GetValueReceptionImp('DATEREG') + cRC +
                      'CLOTURE : ' + GetValueReceptionImp('CLOTURE') + cRC +
                      'TOTTVA1 : ' + GetValueReceptionImp('TOTTVA1') + cRC +
                      'TVA1 : ' + GetValueReceptionImp('TVA1') + cRC +
                      'TOTTVA2 : ' + GetValueReceptionImp('TOTTVA2') + cRC +
                      'TVA2 : ' + GetValueReceptionImp('TVA2') + cRC +
                      'TOTTVA3 : ' + GetValueReceptionImp('TOTTVA3') + cRC +
                      'TVA3 : ' + GetValueReceptionImp('TVA3') + cRC +
                      'TOTTVA4 : ' + GetValueReceptionImp('TOTTVA4') + cRC +
                      'TVA4 : ' + GetValueReceptionImp('TVA4') + cRC +
                      'TOTTVA5 : ' + GetValueReceptionImp('TOTTVA5') + cRC +
                      'TVA5 : ' + GetValueReceptionImp('TVA5') + cRC +
                      'ARCHIVER : ' + GetValueReceptionImp('ARCHIVER') + cRC +
                      'NUMFACT : ' + GetValueReceptionImp('NUMFACT');
                    DoLog(sError, logError);
                    Synchronize(UpdProgressFrm);
                    Synchronize(ErrorFrm);
                  end;
                end;
                {$IFDEF DEBUG}
                dTemp := now-dTemp;
                inc(itEntete);
                dEntete := AjouteTemps(dEntete, dTemp);
                {$ENDIF}
                iBreID := StProc_Reception_Entete.FieldByName('BREID').AsInteger;
                StProc_Reception_Entete.Close;
              end;
            end;

            // ligne de reception
            LRechID := Dm_Main.RechercheReceptionID(sNumBon, NbRech);
            if (LRechID=-1) then
            begin
              // article virtuel ?
              iPseudo := Dm_Main.GetArfVirtuel(GetValueReceptionImp('CODE_ART'));
              if iPseudo=0 then
              begin
                iArtID := 0;
                iTgfID := 0;
                iCouID := 0;
                case Dm_Main.Provenance of
                  ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
                    iArtID := Dm_Main.GetArtID(GetValueReceptionImp('CODE_ART'));
                    iTgfID := Dm_Main.GetTgfID(GetValueReceptionImp('CODE_TAILLE'));
                    iCouID := Dm_Main.GetCouID(GetValueReceptionImp('CODE_COUL'))
                  end;
                  ipInterSys, ipExotiqueISF : begin
                    iArtID := Dm_Main.GetArtID(GetValueReceptionImp('CODE_ART'));
                    iTgfID := Dm_Main.GetTgfID(GetValueReceptionImp('CODE_TAILLE'));
                    iCouID := Dm_Main.GetCouID(GetValueReceptionImp('CODE_COUL')+GetValueReceptionImp('CODE_ART'));
                  end;
                end;

                // article
                if iArtID<=0 then
                begin
                  bStop := true;
                  if (Dm_Main.TransacHis.InTransaction) then
                    Dm_Main.TransacHis.Rollback;

                  LstErreur.Add('Article non trouvé - CODEART = '+GetValueReceptionImp('CODE_ART')+
                                ' pour la reception: "'+sNumBon+'"');
                end;

                // taille
                if iTgfID<0 then
                  iTgfID := 0;
                if (iTgfID=0) and (GetValueReceptionImp('CODE_TAILLE')<>'0') then
                begin
                  bStop := true;
                  if (Dm_Main.TransacHis.InTransaction) then
                    Dm_Main.TransacHis.Rollback;
                  LstErreur.Add('Code taille non trouvé: "'+GetValueReceptionImp('CODE_TAILLE')+'" '+
                                'pour l''article: "'+GetValueReceptionImp('CODE_ART')+'" '+
                                'pour la reception: "'+sNumBon+'"');
                end;
                // Couleur
                if iCouID<0 then
                  iCouID := 0;
                if (iCouID=0) and (GetValueReceptionImp('CODE_COUL')<>'0') then
                begin
                  bStop := true;
                  if (Dm_Main.TransacHis.InTransaction) then
                    Dm_Main.TransacHis.Rollback;
                  LstErreur.Add('Code couleur non trouvé: "'+GetValueReceptionImp('CODE_COUL')+'" '+
                                'pour l''article: "'+GetValueReceptionImp('CODE_ART')+'" '+
                                'pour la reception: "'+sNumBon+'"');
                end;

                if not(bStop) then
                begin
                  {$IFDEF DEBUG}
                  dTemp := now;
                  {$ENDIF}
                  PxVente := ConvertStrToFloat(GetValueReceptionImp('PXVTE'));
                  if (abs(PxVente)<0.001) then
                  begin
                    Que_GetPxVente.ParamByName('MAGID').AsInteger := iMagID;
                    Que_GetPxVente.ParamByName('ARTID').AsInteger := iArtID;
                    Que_GetPxVente.ParamByName('TGFID').AsInteger := iTgfID;
                    Que_GetPxVente.ParamByName('COUID').AsInteger := iCouID;
                    Que_GetPxVente.Open;
                    PxVente := Que_GetPxVente.FieldByName('R_PRIX').AsFloat;
                    Que_GetPxVente.Close;
                  end;

                  if (Length(GetValueReceptionImp('PXBRUT')) < 10) then
                    PxBrut := ConvertStrToFloat(GetValueReceptionImp('PXBRUT'))
                  else
                  begin
                    LstErreur.Add('Le Prix Brut trouvé n''est pas correct : "'+GetValueReceptionImp('PXBRUT')+'" '+
                                  'pour l''article: "'+GetValueReceptionImp('CODE_ART')+'"');
                    PxBrut := 0;
                  end;

                  if (Length(GetValueReceptionImp('PXNET')) < 10) then
                    PxNet := ConvertStrToFloat(GetValueReceptionImp('PXNET'))
                  else
                  begin
                    LstErreur.Add('Le Prix Net trouvé n''est pas correct : "'+GetValueReceptionImp('PXNET')+'" '+
                                  'pour l''article: "'+GetValueReceptionImp('CODE_ART')+'"');
                    PxNet := 0;
                  end;

                  Remise := 0;
                  if Abs(PxBrut)>=0.01 then
                    Remise := ((PxBrut-PxNet)/PxBrut)*100;

                  dTva := ConvertStrToFloat(GetValueReceptionImp('TVA'));

                  if (bCorrectionTVA and (dTva = 0)) then
                  begin
                    Que_GetTVA.ParamByName('ARTID').AsInteger := iArtID;
                    Que_GetTVA.Open;
                    dTva := Que_GetTVA.FieldByName('TVA_TAUX').AsFloat;
                    Que_GetTVA.Close;

                    if (dTva = 20) then
                    begin
                      if (CompareDate(StrToDate(GetValueReceptionImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                        dTva := 19.6;
                    end
                    else
                      if (dTva = 10) then
                      begin
                        if (CompareDate(StrToDate(GetValueReceptionImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                          dTva := 7;
                      end;

                    LstErreur.Add('TVA non trouvé: "'+GetValueReceptionImp('TVA')+'" '+
                                'pour l''article: "'+GetValueReceptionImp('CODE_ART')+'"');
                  end;

{                  if (dTva = 0) then
                  begin
                    if (Dm_Main.TransacHis.InTransaction) then
                      Dm_Main.TransacHis.Rollback;
                    Result := false;
                    sError := '('+inttostr(i)+')'+#13#10+
                              'Ligne: '+LigneLecture+#13#10+
                              'Taux de TVA non trouvé dans TraiterReception pour l''article  : ' + IntToStr(iArtID);
                    Synchronize(UpdProgressFrm);
                    Synchronize(ErrorFrm);

                    Exit;
                  end;  }

                  // insertion de la ligne
                  try
                    StProc_Reception_Ligne.Close;
                    StProc_Reception_Ligne.ParamByName('BREID').AsInteger := iBreID;
                    StProc_Reception_Ligne.ParamByName('ARTID').AsInteger := iArtID;
                    StProc_Reception_Ligne.ParamByName('TGFID').AsInteger := iTgfID;
                    StProc_Reception_Ligne.ParamByName('COUID').AsInteger := iCouID;
                    StProc_Reception_Ligne.ParamByName('COLID').AsInteger := iColID;
                    StProc_Reception_Ligne.ParamByName('PXBRUT').AsDouble := PxBrut;
                    StProc_Reception_Ligne.ParamByName('REMISE').AsDouble := Remise;
                    StProc_Reception_Ligne.ParamByName('PXNET').AsDouble  := PxNet;
                    StProc_Reception_Ligne.ParamByName('PXVTE').AsDouble := ArrondiA2(PxVente);
                    StProc_Reception_Ligne.ParamByName('QTE').AsInteger   := StrToIntDef(GetValueReceptionImp('QTE'), 0);
                    StProc_Reception_Ligne.ParamByName('CDLLIV').AsDateTime := GetCdlLiv(iArtId, iTgfId, iCouId);
                    StProc_Reception_Ligne.ParamByName('TVA').AsDouble := dTva;
                    StProc_Reception_Ligne.ExecQuery;
                  except
                    on E: Exception do
                    begin
                      if (Dm_Main.TransacHis.InTransaction) then
                        Dm_Main.TransacHis.Rollback;
                      Result := false;
                      if sError <> '' then
                        sError := sError + cRC;
                      sError := sError + 'Reception_Ligne : ' + E.Message + cRC +
                        'BREID : ' + IntToStr(iBreID) + cRC +
                        'ARTID : ' + IntToStr(iArtID) + cRC +
                        'TGFID : ' + IntToStr(iTgfID) + cRC +
                        'COUID : ' + IntToStr(iCouID) + cRC +
                        'COLID : ' + IntToStr(iColID) + cRC +
                        'PXBRUT : ' + FloatToStr(PxBrut) + cRC +
                        'REMISE : ' + FloatToStr(Remise) + cRC +
                        'PXNET : ' + FloatToStr(PxNet) + cRC +
                        'PXVTE : ' + FloatToStr(ArrondiA2(PxVente)) + cRC +
                        'QTE : ' + GetValueReceptionImp('QTE') + cRC +
                        'CDLLIV : ' + DateTimeToStr(GetCdlLiv(iArtId, iTgfId, iCouId)) + cRC +
                        'TVA : ' + FloatToStr(dTva);
                      DoLog(sError, logError);
                      Synchronize(UpdProgressFrm);
                      Synchronize(ErrorFrm);
                    end;
                  end;
                  Dm_Main.AjoutInListeLigneReceptionID(GetValueReceptionImp('ID_LIGNE') + GetValueReceptionImp('CODE_ART') + GetValueReceptionImp('CODE_TAILLE') + GetValueReceptionImp('CODE_COUL'), StProc_Reception_Ligne.FieldByName('BRLID').AsInteger);

                  iMrkID := StProc_Reception_Ligne.FieldByName('MRKID').AsInteger;
                  StProc_Reception_Ligne.Close;
                  {$IFDEF DEBUG}
                  dTemp := now-dTemp;
                  inc(itLigne);
                  dLigne := AjouteTemps(dLigne, dTemp);
                  {$ENDIF}
                  // pour les relations fournisseur <-> marque
                  if (iMrkID>0) and not(cds_FouMrk.Locate('FOUID;MRKID', VarArrayOf([iFouId, iMrkId]), [])) then
                  begin
                    cds_FouMrk.Append;
                    cds_FouMrk.FieldByName('FOUID').AsInteger := iFouId;
                    cds_FouMrk.FieldByName('MRKID').AsInteger := iMrkId;
                    cds_FouMrk.FieldByName('FAIT').AsInteger := 0;
                    cds_FouMrk.Post;
                  end;

                  AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock
                end;
              end;
            end;
          end;

          Inc(i);
        end;
        Inc(iNumFile);
        sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'reception' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
      end;

      if (iBreID<>0) then
      begin
        // validation du bon
        if not(bStop) then
        begin
          if (iBreID<>0) then
          begin
            if Dm_Main.Provenance in [ipInterSys, ipDataMag, ipExotiqueISF] then  // intersys
            begin
              try
                StProc_Reception_RecalTick.ParamByName('NUMBON').AsString := '';
                StProc_Reception_RecalTick.ParamByName('BREID').AsInteger := iBreID;
                StProc_Reception_RecalTick.ExecProc;
              except
                on E: Exception do
                begin
                  if (Dm_Main.TransacHis.InTransaction) then
                    Dm_Main.TransacHis.Rollback;
                  Result := false;
                  if sError <> '' then
                    sError := sError + cRC;
                  sError := sError + 'RecalTicket : ' + E.Message + ' - BREID = ' + IntToStr(iBreID);
                  DoLog(sError, logError);
                  Synchronize(UpdProgressFrm);
                  Synchronize(ErrorFrm);
                end;
              end;
            end;
          end;
          Dm_Main.TransacHis.Commit;
          Dm_Main.AjoutInListeReceptionID(sNumBon, iBreID);
        end;
      end;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

      // traite les relations Marque <--> fournisseur manquante
      iMaxProgress := cds_FouMrk.RecordCount;
      iProgress := 0;
      AvancePc := Round((iMaxProgress/100)*2);
      if AvancePc<=0 then
        AvancePc := 1;
      if AvancePc>1000 then
        AvancePc := 1000;
      inc(iTraitement);
      sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Reception_CSV + ' (Fourn<->Marq)":';
      sEtat2 := '0 / '+inttostr(iMaxProgress);
      Synchronize(UpdateFrm);
      Synchronize(InitProgressFrm);
      i := 1;
      cds_FouMrk.First;
      while not(cds_FouMrk.Eof) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_FouMrk.FieldByName('FAIT').AsInteger=0 then
        begin
          if not(Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.StartTransaction;
          StProc_FouMarque.Close;
          StProc_FouMarque.ParamByName('FOUID').AsInteger := cds_FouMrk.FieldByName('FOUID').AsInteger;
          StProc_FouMarque.ParamByName('MRKID').AsInteger := cds_FouMrk.FieldByName('MRKID').AsInteger;
          StProc_FouMarque.ParamByName('PRINCIPAL').AsInteger := 1;     // sera permuté dans la prk stockée si nécessaire
          StProc_FouMarque.ExecQuery;
          StProc_FouMarque.Close;
          Dm_Main.TransacHis.Commit;
          cds_FouMrk.Edit;
          cds_FouMrk.FieldByName('FAIT').AsInteger := 1;
          cds_FouMrk.Post;
        end;
        cds_FouMrk.Next;
        inc(i);
      end;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        if sError <> '' then
          sError := sError + cRC;
        sError := sError + '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeReceptionID;
    Dm_Main.SaveListeLigneReceptionID;
    StProc_Reception_Entete.Close;
    StProc_Reception_Ligne.Close;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Reception_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
    FreeAndNil(Que_GetPxVente);
    FreeAndNil(Que_GetTVA);
    cds_Reception.Clear;
    {$IFDEF DEBUG}
    EnreDelai(i);
    {$ENDIF}
    FreeAndNil(LstDelaiRcp);
  end;
end;

function THistorique.TraiterConsodiv: Boolean;
var
  iMagID: integer;
  sTmpMag: string;
  MagCode: string;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  iTypID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  iTypCod: integer;
  bErr: boolean;
  LstErreur: TStringList;
  vQte: integer;
  sComent: string;

  NbRech: integer;
  LRechID: integer;

  iBreID: integer;
  iFouID: integer;
  iCpaID: integer;
  iCpaCode: integer;
  sChronoBr: string;
  ListeBre, LstMagID: TStringList;
  iGcpId: integer;
  dTva: Double;
  Que_GetTVA: TIBQuery;
  Que_PumpHistoStock, Que_PumpStockCour: TIBSQL;
  Que_LastPump: TIBQuery;
  j: Integer;

  // retourne le BreId déjà créé
  function RechercheBre(sBreChrono: string): integer;
  var
    ij: integer;
    sTmp: string;
    TmpBreID: string;
  begin
    Result := 0;
    ij := 1;
    while (Result=0) and (ij<=ListeBre.Count) do
    begin
      sTmp := ListeBre[ij-1];
      TmpBreID := '';
      if Pos('|', sTmp)>0 then
      begin
        TmpBreID := Copy(sTmp, Pos('|', sTmp)+1, Length(sTmp));
        sTmp := Copy(sTmp, 1, Pos('|', sTmp)-1);
      end;
      if sTmp=sBreChrono then
        Result := StrToIntDef(TmpBreID, 0);

      inc(ij);
    end;
  end;
begin
  Result := false;

  try
    cds_Consodiv.LoadFromFile(sPathConsodiv);
  except
    on E:Exception do
    begin
      sError := 'Traitement ConsoDiv' +E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_Consodiv.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Consodiv_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  iMagID := 0;
  iBreID := 0;
  iFouID := 0;
  MagCode := '';
  iGcpId := -1;

  ListeBre := TStringList.Create;
  LstErreur := TStringList.Create;
  Que_GetTVA := TIBQuery.Create(nil);
  NbRech := Dm_Main.ListeIDConsodiv.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  LstMagID := TStringList.Create;
  try
    // preparation pour avoir la TVA
    Que_GetTVA.Database := Dm_Main.Database;
    Que_GetTVA.Transaction := Dm_Main.Transaction;
    Que_GetTVA.ParamCheck := True;
    Que_GetTVA.SQL.Clear;
    Que_GetTVA.SQL.Add('select TVA_TAUX ' +
                       'from ARTTVA ' +
                          'JOIN K ON (K_ID = TVA_ID AND K_ENABLED = 1) ' +
                          'JOIN ARTREFERENCE ON (ARF_TVAID = TVA_ID) ' +
                       'where ARF_ARTID = :ARTID');
    // préparation pour mise à jour du Pump
    Que_PumpHistoStock := TIBSQL.Create( nil );
    Que_PumpHistoStock.Database := Dm_Main.Database;
    Que_PumpHistoStock.Transaction := Dm_Main.TransacHis;
    Que_PumpHistoStock.ParamCheck := True;
    Que_PumpHistoStock.SQL.Add( 'update AGRHISTOSTOCK set' );
    Que_PumpHistoStock.SQL.Add( '  HST_ANNEE = extract( year from HST_DATE ),' );
    Que_PumpHistoStock.SQL.Add( '  HST_PUMP = :PUMP' );
    Que_PumpHistoStock.SQL.Add( 'where HST_MAGID = :MAGID' );
    Que_PumpHistoStock.SQL.Add( '  and HST_ARTID = :ARTID' );
    Que_PumpHistoStock.SQL.Add( '  and HST_TGFID = :TGFID' );
    Que_PumpHistoStock.SQL.Add( '  and HST_COUID = :COUID' );
    Que_PumpHistoStock.SQL.Add( '  and HST_DATE  = :DATE;' );

    Que_PumpStockCour := TIBSQL.Create( nil );
    Que_PumpStockCour.Database := Dm_Main.Database;
    Que_PumpStockCour.Transaction := Dm_Main.TransacHis;
    Que_PumpStockCour.ParamCheck := True;
    Que_PumpStockCour.SQL.Add( 'update AGRSTOCKCOUR set' );
    Que_PumpStockCour.SQL.Add( '  STC_PUMP = :PUMP' );
    Que_PumpStockCour.SQL.Add( 'where STC_MAGID = :MAGID' );
    Que_PumpStockCour.SQL.Add( '  and STC_ARTID = :ARTID' );
    Que_PumpStockCour.SQL.Add( '  and STC_TGFID = :TGFID' );
    Que_PumpStockCour.SQL.Add( '  and STC_COUID = :COUID;' );

    Que_LastPump := TIBQuery.Create( nil );
    Que_LastPump.Database := Dm_Main.Database;
    Que_LastPump.Transaction := Dm_Main.TransacHis;
    Que_LastPump.ParamCheck := True;
    Que_LastPump.SQL.Add( 'select HST_PUMP from AGRHISTOSTOCK' );
    Que_LastPump.SQL.Add( 'where HST_MAGID = :MAGID' );
    Que_LastPump.SQL.Add( '  and HST_ARTID = :ARTID' );
    Que_LastPump.SQL.Add( '  and HST_TGFID = :TGFID' );
    Que_LastPump.SQL.Add( '  and HST_COUID = :COUID' );
    Que_LastPump.SQL.Add( '  and HST_DATE <= CURRENT_DATE' );
    Que_LastPump.SQL.Add( '  and HST_DATEFIN >= CURRENT_DATE;' );

    i := 1;
    try
      NbEnre := cds_Consodiv.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Consodiv[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Consodiv[i], Consodiv_COL);

          // magasin
          sTmpMag := GetValueConsodivImp('CODE_MAG');
          if sTmpMag<>MagCode then
          begin
            MagCode := sTmpMag;
            iMagID := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID=0 then
            raise Exception.Create('Magasin non trouvé pour:' +#13#10+ '  - CODE_MAG = '+MagCode);
          ListeUsedMagasin.Add(IntToStr(iMagID));

          sComent := UpperCase(GetValueConsodivImp('MOTIF'));

          bErr := false;

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
              iArtID := Dm_Main.GetArtID(GetValueConsodivImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueConsodivImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueConsodivImp('CODE_COUL'));
            end;
            ipInterSys, ipExotiqueISF: begin
              iArtID := Dm_Main.GetArtID(GetValueConsodivImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueConsodivImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueConsodivImp('CODE_COUL')+GetValueConsodivImp('CODE_ART'));
            end;
            ipOldGoSport: begin
              iArtID := StrToIntDef( GetValueConsoDivImp( 'CODE_ART' ), -1 );
              iTgfID := StrToIntDef( GetValueConsoDivImp( 'CODE_TAILLE' ), -1 );
              iCouID := StrToIntDef( GetValueConsoDivImp( 'CODE_COUL' ), -1 );
            end;
          end;
          // article
          if iArtID<=0 then
          begin
            bErr := true;
            LstErreur.Add('Article non trouvé - CODEART = '+GetValueConsodivImp('CODE_ART'));
          end;
          // taille
          if iTgfID<0 then
            iTgfID := 0;
          if (iTgfID=0) and (GetValueConsodivImp('CODE_TAILLE')<>'0') then
          begin
            bErr := true;
            LstErreur.Add('Code taille non trouvé: "'+GetValueConsodivImp('CODE_TAILLE')+'" '+
                          'pour l''article: "'+GetValueConsodivImp('CODE_ART')+'"');
          end;
          // Couleur
          if iCouID<0 then
            iCouID := 0;
          if (iCouID=0) and (GetValueConsodivImp('CODE_COUL')<>'0') then
          begin
            bErr := true;
            LstErreur.Add('Code couleur non trouvé: "'+GetValueConsodivImp('CODE_COUL')+'" '+
                          'pour l''article: "'+GetValueConsodivImp('CODE_ART')+'"');
          end;

          if not(bErr) then
          begin

            if (Pos('INIT TRANSFERT', sComent)=1) or
                (Pos('INIT MIGRATION', sComent)=1) or
                (Pos('INITIALISATION STOCK', sComent)=1) then
            begin
              // init pump et stock

              if (iFouID=0) then
              begin
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;
                // création d'un fournisseur bidon
                StProc_Fourn.Close;
                StProc_Fourn.ParamByName('CODEIS').AsString    := 'INIT TRANSFERT 11.2-->12.1';
                StProc_Fourn.ParamByName('FOUNOM').AsString    := 'INIT TRANSFERT 11.2-->12.1';
                StProc_Fourn.ParamByName('ADRESSE').AsString   := '';
                StProc_Fourn.ParamByName('CP').AsString        := '';
                StProc_Fourn.ParamByName('VILLE').AsString     := '';
                StProc_Fourn.ParamByName('PAYS').AsString      := '';
                StProc_Fourn.ParamByName('TEL').AsString       := '';
                StProc_Fourn.ParamByName('FAX').AsString       := '';
                StProc_Fourn.ParamByName('PORTABLE').AsString  := '';
                StProc_Fourn.ParamByName('EMAIL').AsString     := '';
                StProc_Fourn.ParamByName('COMMENT').AsString   := '';
                StProc_Fourn.ParamByName('NUMCLT').AsString    := '';
                StProc_Fourn.ParamByName('NUMCOMPTA').AsString := '';
                StProc_Fourn.ParamByName('ACTIF').AsInteger    := 0;
                StProc_Fourn.ParamByName('CENTRALE').AsInteger := 0;
                StProc_Fourn.ParamByName('FOUILN').AsString    := '';
                if (Dm_Main.Provenance in [ipNosymag, ipLocalBase]) then
                  StProc_Fourn.ParamByName('FOUERPNO').AsString    := '';
                StProc_Fourn.ExecQuery;
                // récupération du nouvel ID fournisseur
                iFouID := StProc_Fourn.FieldByName('FOUID').AsInteger;
                StProc_Fourn.Close;
                Dm_Main.TransacHis.Commit;
              end;

              // entete reception si besoin
              sChronoBr := 'I-'+MagCode;
              iBreID := RechercheBre(sChronoBr);
              if (iBreID=0) then
              begin

                // type de paiement
                iCpaID := 0;
                iCpaCode := 1;  // date à saisir
                if cds_TypePaie.Locate('CPA_CODE', iCpaCode, []) then
                  iCpaID := cds_TypePaie.FieldByName('CPA_ID').AsInteger;
                // entete de reception
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;
                StProc_Reception_Entete.Close;
                StProc_Reception_Entete.ParamByName('NUMBON').AsString          := sChronoBr;
                StProc_Reception_Entete.ParamByName('NUMFOURN').AsString        := '';
                StProc_Reception_Entete.ParamByName('BREDATE').AsDateTime       := ConvertStrToDate(GetValueConsodivImp('DATE'));
                StProc_Reception_Entete.ParamByName('FOUID').AsInteger          := iFouID;
                StProc_Reception_Entete.ParamByName('MAGID').AsInteger          := iMagID;
                StProc_Reception_Entete.ParamByName('MRGLIB').AsString          := 'En votre aimable règlement';
                StProc_Reception_Entete.ParamByName('CPAID').AsInteger          := iCpaID;
                StProc_Reception_Entete.ParamByName('COLID').AsInteger          := 0;
                StProc_Reception_Entete.ParamByName('DATEREGLEMENT').AsDateTime := ConvertStrToDate(GetValueConsodivImp('DATE'));
                StProc_Reception_Entete.ParamByName('CLOTURE').AsInteger        := 1;
                StProc_Reception_Entete.ParamByName('TOTTVA1').AsDouble         := 0;
                StProc_Reception_Entete.ParamByName('TVA1').AsDouble            := 0;
                StProc_Reception_Entete.ParamByName('TOTTVA2').AsDouble         := 0;
                StProc_Reception_Entete.ParamByName('TVA2').AsDouble            := 0;
                StProc_Reception_Entete.ParamByName('TOTTVA3').AsDouble         := 0;
                StProc_Reception_Entete.ParamByName('TVA3').AsDouble            := 0;
                StProc_Reception_Entete.ParamByName('TOTTVA4').AsDouble         := 0;
                StProc_Reception_Entete.ParamByName('TVA4').AsDouble            := 0;
                StProc_Reception_Entete.ParamByName('TOTTVA5').AsDouble         := 0;
                StProc_Reception_Entete.ParamByName('TVA5').AsDouble            := 0;
                StProc_Reception_Entete.ExecQuery;
                iBreID := StProc_Reception_Entete.FieldByName('BREID').AsInteger;
                StProc_Reception_Entete.Close;
                Dm_Main.TransacHis.Commit;
                ListeBre.Add(sChronoBr+'|'+inttostr(iBreID));
              end;

              // recherche si pas déjà importé
              LRechID := Dm_Main.RechercheConsodivID(LigneLecture, NbRech);

              Que_GetTVA.ParamByName('ARTID').AsInteger := iArtID;
              Que_GetTVA.Open;
              dTva := Que_GetTVA.FieldByName('TVA_TAUX').AsFloat;
              Que_GetTVA.Close;

              if (dTva = 20) then
              begin
                if (CompareDate(StrToDate(GetValueConsodivImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                  dTva := 19.6;
              end
              else if (dTva = 10) then
              begin
                if (CompareDate(StrToDate(GetValueConsodivImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                  dTva := 7;
              end;

{              if (dTva = 0) then
              begin
                if (Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.Rollback;
                Result := false;
                sError := '('+inttostr(i)+')'+#13#10+
                          'Ligne: '+LigneLecture+#13#10+
                          'Taux de TVA non trouvé dans TraiterConsodiv pour l''article  : ' + IntToStr(iArtID);
                Synchronize(UpdProgressFrm);
                Synchronize(ErrorFrm);
                Exit;
              end; }

              if LRechID=-1 then
              begin
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;
                vQte := -StrToIntDef(GetValueConsodivImp('QTE'), 0);
                // insertion de la ligne
                StProc_Reception_Ligne.Close;
                StProc_Reception_Ligne.ParamByName('BREID').AsInteger := iBreID;
                StProc_Reception_Ligne.ParamByName('ARTID').AsInteger := iArtID;
                StProc_Reception_Ligne.ParamByName('TGFID').AsInteger := iTgfID;
                StProc_Reception_Ligne.ParamByName('COUID').AsInteger := iCouID;
                StProc_Reception_Ligne.ParamByName('PXBRUT').AsDouble := ConvertStrToFloat(GetValueConsodivImp('PUMP'));
                StProc_Reception_Ligne.ParamByName('REMISE').AsDouble := 0;
                StProc_Reception_Ligne.ParamByName('PXNET').AsDouble  := ConvertStrToFloat(GetValueConsodivImp('PUMP'));
                StProc_Reception_Ligne.ParamByName('QTE').AsInteger   := vQte;
                StProc_Reception_Ligne.ParamByName('TVA').AsDouble    := dTva;
                StProc_Reception_Ligne.ExecQuery;
                StProc_Reception_Ligne.Close;

                AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock

                Dm_Main.TransacHis.Commit;
                Dm_Main.AjoutInListeConsodivID(LigneLecture);
              end;

            end
            else
            begin
              if Dm_Main.Provenance in [ ipGinkoia, ipGoSport, ipOldGoSport , ipNosymag, ipLocalBase] then
              begin
                iTypCod := StrToIntDef(GetValueConsodivImp('TYPEGINKOIA'), 0);
                iTypID := 0;
                if cds_TypeVen.Locate('TYP_COD', iTypCod, []) then
                  iTypID := cds_TypeVen.FieldByName('TYP_ID').AsInteger;
              end
              else
              begin
                // Récupération de l'ID du type de la vente
                Case StrToIntDef(GetValueConsodivImp('TYPE'), 0) of
                  1: iTypCod := 24;
                  2: iTypCod := 26;
                  3: iTypCod := 25;
                  4: iTypCod := 23;
                  5: iTypCod := 22;
                  6: iTypCod := 21;
                  7: iTypCod := 20;
                else
                  iTypCod := StrToIntDef(GetValueConsodivImp('TYPE'), 0);
                end;
                iTypID := 0;
                if cds_TypeVen.Locate('TYP_COD', iTypCod, []) then
                  iTypID := cds_TypeVen.FieldByName('TYP_ID').AsInteger;
              end;

              // recherche si pas déjà importé
              LRechID := Dm_Main.RechercheConsodivID(LigneLecture, NbRech);

              // création si pas déjà créé
              if (LRechID=-1)
               and (GetValueConsodivImp('CODE_ART')<>'')
               and (GetValueConsodivImp('CODE_TAILLE')<>'')
               and (GetValueConsodivImp('CODE_COUL')<>'')
               and (GetValueConsodivImp('CODE_MAG')<>'')
               and (GetValueConsodivImp('DATE')<>'')
               and (GetValueConsodivImp('TYPE')<>'')
               and (GetValueConsodivImp('QTE')<>'') then
              begin
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;

                //Traitement des Consodiv

                vQte := StrToIntDef(GetValueConsodivImp('QTE'), 0);
                //if sComent='RETOUR FOURNISSEUR TRANSPO' then
                //  vQte := -vQte;

                StProc_Consodiv.ParamByName('MAGID').AsInteger := iMagID;
                StProc_Consodiv.ParamByName('ARTID').AsInteger := iArtID;
                StProc_Consodiv.ParamByName('TGFID').AsInteger := iTgfID;
                StProc_Consodiv.ParamByName('COUID').AsInteger := iCouID;
                StProc_Consodiv.ParamByName('CDVDATE').AsDateTime := ConvertStrToDate(GetValueConsodivImp('DATE'));
                StProc_Consodiv.ParamByName('TYPID').AsInteger := iTypID;
                StProc_Consodiv.ParamByName('CDVQTE').AsInteger := vQte;
                StProc_Consodiv.ParamByName('CDVCOMENT').AsString   := sComent;
                StProc_Consodiv.ExecQuery;
                StProc_Consodiv.Close;

//                AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock

//                Dm_Main.TransacHis.Commit;
//                Dm_Main.AjoutInListeConsodivID(LigneLecture);

                {$REGION 'OldGoSport => Forcage du Pump'}
                if Dm_Main.Provenance = ipOldGoSport then
                begin// liste des mag concernés par le Groupe de Pump
                  cds_GroupPump.Locate('MPU_MAGID', iMagId, []);
                  if (iGcpId=-1) or (iGcpId<>cds_GroupPump.FieldByName('MPU_GCPID').AsInteger) then
                  begin
                    iGcpId := cds_GroupPump.FieldByName('MPU_GCPID').AsInteger;
                    LstMagID.Clear;
                    cds_GroupPump.First;
                    while not(cds_GroupPump.Eof) do
                    begin
                      if (cds_GroupPump.FieldByName('MPU_GCPID').AsInteger=iGcpId) then
                        LstMagID.Add(inttostr(cds_GroupPump.FieldByName('MPU_MAGID').AsInteger));
                      cds_GroupPump.Next;
                    end;
                  end;

                  for j := 0 to LstMagID.Count - 1 do
                  begin
                    Que_PumpHistoStock.ParamByName( 'MAGID' ).AsString  := LstMagID[ j ];
                    Que_PumpHistoStock.ParamByName( 'ARTID' ).AsInteger := iArtID;
                    Que_PumpHistoStock.ParamByName( 'TGFID' ).AsInteger := iTgfID;
                    Que_PumpHistoStock.ParamByName( 'COUID' ).AsInteger := iCouID;
                    Que_PumpHistoStock.ParamByName( 'DATE' ).AsDateTime := ConvertStrToDate(GetValueConsodivImp('DATE'));
                    Que_PumpHistoStock.ParamByName( 'PUMP' ).AsDouble := ConvertStrToFloat( GetValueConsodivImp( 'PUMP' ) );
                    Que_PumpHistoStock.ExecQuery;
                    Que_PumpHistoStock.Close;

                    Que_LastPump.ParamByName( 'MAGID' ).AsString  := LstMagID[ j ];
                    Que_LastPump.ParamByName( 'ARTID' ).AsInteger := iArtID;
                    Que_LastPump.ParamByName( 'TGFID' ).AsInteger := iTgfID;
                    Que_LastPump.ParamByName( 'COUID' ).AsInteger := iCouID;
                    Que_LastPump.Open;
                    Que_LastPump.First;
                    if not Que_LastPump.IsEmpty then
                    begin
                      Que_PumpStockCour.ParamByName( 'MAGID' ).AsString := LstMagID[ j ];
                      Que_PumpStockCour.ParamByName( 'ARTID' ).AsInteger := iArtID;
                      Que_PumpStockCour.ParamByName( 'TGFID' ).AsInteger := iTgfID;
                      Que_PumpStockCour.ParamByName( 'COUID' ).AsInteger := iCouID;
                      Que_PumpStockCour.ParamByName( 'PUMP' ).AsFloat := Que_LastPump.FieldByName( 'HST_PUMP' ).AsFloat;
                      Que_PumpStockCour.ExecQuery;
                      Que_PumpStockCour.Close;
                    end;
                    Que_LastPump.Close;
                  end;

                  // Correction pour Stanley
                  DicUpdatePump.AddOrSetValue(
                    TUpdatePumpRec.Create(iMagID, iArtID, iTgfID, iCouID, ConvertStrToDate(GetValueConsodivImp('DATE'))),
                    ConvertStrToFloat(GetValueConsodivImp('PUMP'))
                  );
                end;
                {$ENDREGION}

                AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock
//
                Dm_Main.TransacHis.Commit;
                Dm_Main.AjoutInListeConsodivID(LigneLecture);

              end;
            end;
          end;
        end;

        Inc(i);
      end;
      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    for i := 1 to ListeBre.Count do
    begin
      sChronoBr := ListeBre[i-1];
      iBreID := 0;
      if Pos('|', sChronoBr)>0 then
      begin
        iBreID := StrToIntDef(Copy(sChronoBr, Pos('|', sChronoBr)+1, Length(sChronoBr)), 0);
        sChronoBr := Copy(sChronoBr, 1, Pos('|', sChronoBr)-1);
      end;
      if iBreID<>0 then
      begin
        try
          if not(Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.StartTransaction;

          StProc_Reception_RecalTick.ParamByName('NUMBON').AsString := Copy(sChronoBr, 1, 9);
          StProc_Reception_RecalTick.ParamByName('BREID').AsInteger := iBreID;
          StProc_Reception_RecalTick.ExecProc;
          Dm_Main.TransacHis.Commit;
        except
          // si pb de base, on recalcul un autre jour
          if (Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.Rollback;
        end;
      end;
    end;
    LstMagID.Free;
    Dm_Main.SaveListeConsodivID;
    StProc_Consodiv.Close;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_ConsoDiv_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
    FreeAndNil(ListeBre);
    FreeAndNil(Que_GetTVA);
    FreeAndNil(Que_PumpHistoStock);
    FreeAndNil(Que_PumpStockCour);
    FreeAndNil(Que_LastPump);
    cds_Consodiv.Clear;
  end;
end;

function THistorique.TraiterTransfert: Boolean;
var
  iMagImport: integer;
  iImaID: integer;
  iTmpImaID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  iTypID: integer;
  iTypCod: integer;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  NumBon: string;
  dTva: Double;

  NbRech: integer;
  LRechID: integer;

  bErr: boolean;
  LstErreur: TStringList;
  Que_GetTVA: TIBQuery;

  CodeMag : string;
  iMagID : integer;
begin
  Result := false;

  try
    cds_Transfert.LoadFromFile(sPathTransfert);
  except
    on E:Exception do
    begin
      sError := 'Traitement Transfert' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_Transfert.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Transfert_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  if Dm_Main.OkTousMag then
    iMagImport := 0
  else
    iMagImport := Dm_Main.MagID;

  iImaID := 0;
  NumBon := '';

  LstErreur := TStringList.Create;
  Que_GetTVA := TIBQuery.Create(nil);
  NbRech := Dm_Main.ListeIDTransfert.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;

    // preparation pour avoir la TVA
    Que_GetTVA.Database := Dm_Main.Database;
    Que_GetTVA.Transaction := Dm_Main.Transaction;
    Que_GetTVA.ParamCheck := True;
    Que_GetTVA.SQL.Clear;
    Que_GetTVA.SQL.Add('select TVA_TAUX ' +
                       'from ARTTVA ' +
                          'JOIN K ON (K_ID = TVA_ID AND K_ENABLED = 1) ' +
                          'JOIN ARTREFERENCE ON (ARF_TVAID = TVA_ID) ' +
                       'where ARF_ARTID = :ARTID');

    try
      // type de conso div
      iTypID := 0;
      iTypCod := 26;
      if cds_TypeVen.Locate('TYP_COD', iTypCod, []) then
        iTypID := cds_TypeVen.FieldByName('TYP_ID').AsInteger;

      NbEnre := cds_Transfert.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Transfert[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Transfert[i], Transfert_COL);

          bErr := false;

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
              iArtID := Dm_Main.GetArtID(GetValueTransfertImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueTransfertImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueTransfertImp('CODE_COUL'))
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(GetValueTransfertImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueTransfertImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueTransfertImp('CODE_COUL')+GetValueTransfertImp('CODE_ART'));
            end;
          end;

          // article
          if iArtID<=0 then
          begin
            LstErreur.Add('Article non trouvé - CODEART = '+GetValueTransfertImp('CODE_ART'));
            bErr := true;
          end;
          // taille
          if iTgfID<0 then
            iTgfID := 0;
          if (iTgfID=0) and (GetValueTransfertImp('CODE_TAILLE')<>'0') then
          begin
            bErr := true;
            LstErreur.Add('Code taille non trouvé: "'+GetValueTransfertImp('CODE_TAILLE')+'" '+
                          'pour l''article: "'+GetValueTransfertImp('CODE_ART')+'"');
          end;
          // Couleur
          if iCouID<0 then
            iCouID := 0;
          if (iCouID=0) and (GetValueTransfertImp('CODE_COUL')<>'0') then
          begin
            bErr := true;
            LstErreur.Add('Code couleur non trouvé: "'+GetValueTransfertImp('CODE_COUL')+'" '+
                          'pour l''article: "'+GetValueTransfertImp('CODE_ART')+'"');
          end;

          // SR - 03/05/2017 - Correction de la prise en compte de la TVA
          dTva := ConvertStrToFloat(GetValueTransfertImp('TVA'));

          if (bCorrectionTVA and (dTva = 0)) then
          begin
            Que_GetTVA.ParamByName('ARTID').AsInteger := iArtID;
            Que_GetTVA.Open;
            dTva := Que_GetTVA.FieldByName('TVA_TAUX').AsFloat;
            Que_GetTVA.Close;

            if (dTva = 20) then
            begin
              if (CompareDate(StrToDate(GetValueTransfertImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                dTva := 19.6;
            end
            else
              if (dTva = 10) then
              begin
                if (CompareDate(StrToDate(GetValueTransfertImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                  dTva := 7;
              end;
            LstErreur.Add('TVA non trouvé: "'+GetValueTransfertImp('TVA')+'" '+
                          'pour l''article: "'+GetValueTransfertImp('CODE_ART')+'"');
          end;

{          if (dTva = 0) then
          begin
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;
            Result := false;
            sError := '('+inttostr(i)+')'+#13#10+
                      'Ligne: '+LigneLecture+#13#10+
                      'Taux de TVA non trouvé dans TraiterTransfert pour l''article  : ' + IntToStr(iArtID);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);

            Exit;
          end;  }

          // magasins
          CodeMag := GetValueTransfertImp('CODE_MAGO');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
          begin
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
            ListeUsedMagasin.Add(IntToStr(iMagID));
          end;
          CodeMag := GetValueTransfertImp('CODE_MAGD');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
          begin
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
            ListeUsedMagasin.Add(IntToStr(iMagID));
          end;

          if not(bErr) then
          begin
            // recherche si pas déjà importé
            LRechID := Dm_Main.RechercheTransfertID(LigneLecture, NbRech);

            // N° de transfert si transfert multimag
            if (iMagImport=0) then
              NumBon := GetValueTransfertImp('NUMBON');

            // création si pas déjà créé
            if (LRechID=-1)
             and (GetValueTransfertImp('CODE_ART')<>'')
             and (GetValueTransfertImp('CODE_TAILLE')<>'')
             and (GetValueTransfertImp('CODE_COUL')<>'')
             and (GetValueTransfertImp('CODE_MAGO')<>'')
             and (GetValueTransfertImp('CODE_MAGD')<>'')
             and (GetValueTransfertImp('DATE')<>'')
             and (GetValueTransfertImp('QTE')<>'')
             and (GetValueTransfertImp('PXBRUT')<>'')
             and (GetValueTransfertImp('TAUX')<>'') then
            begin
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;

              //Traitement des Transferts
              StProc_Transfert.Close;
              StProc_Transfert.ParamByName('NUMBON').AsString        := NumBon;
              StProc_Transfert.ParamByName('MAGID_IMPORT').AsInteger := iMagImport;
              StProc_Transfert.ParamByName('TYPID').AsInteger        := iTypID;
              StProc_Transfert.ParamByName('ARTID').AsInteger        := iArtID;
              StProc_Transfert.ParamByName('TGFID').AsInteger        := iTgfID;
              StProc_Transfert.ParamByName('COUID').AsInteger        := iCouID;
              StProc_Transfert.ParamByName('CODEEAN').AsString       := GetValueTransfertImp('EAN');
              StProc_Transfert.ParamByName('CODEMAGO').AsString      := GetValueTransfertImp('CODE_MAGO');
              StProc_Transfert.ParamByName('CODEMAGD').AsString      := GetValueTransfertImp('CODE_MAGD');
              StProc_Transfert.ParamByName('IMADATE').AsDateTime     := ConvertStrToDate(GetValueTransfertImp('DATE'));
              StProc_Transfert.ParamByName('IMLQTE').AsInteger       := StrToInt(GetValueTransfertImp('QTE'));
              StProc_Transfert.ParamByName('IMLPXN').AsDouble        := ConvertStrToFloat(GetValueTransfertImp('PXBRUT'));
              StProc_Transfert.ParamByName('IMLTAUX').AsDouble       := ConvertStrToFloat(GetValueTransfertImp('TAUX'));
              StProc_Transfert.ParamByName('IMLTVA').AsDouble        := dTva;
              StProc_Transfert.ExecQuery;

              AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock

              { TODO : Gerer le PUMP provenant d'InterSys }
              if (Dm_Main.Provenance in [ipInterSys]) then  // donc InterSys
              begin
                // Gerer la valeur du PUMP  GetValue..('PUMP')
              end;

              // récupération du nouvel ID Transfert
              iTmpImaID := StProc_Transfert.FieldByName('IMAID').AsInteger;
              Dm_Main.AjoutInListeTransfertID(LigneLecture);

              StProc_Transfert.Close;

              Dm_Main.TransacHis.Commit;
              if (iMagImport=0) and (iImaID<>iTmpImaID) then
              begin
                if (iImaID<>0) then
                begin
                  if not(Dm_Main.TransacHis.InTransaction) then
                    Dm_Main.TransacHis.StartTransaction;
                  StProc_Transfert_Recal.ParamByName('IMAID').AsInteger := iImaID;
                  StProc_Transfert_Recal.ExecProc;
                  StProc_Transfert_Recal.Close;
                  Dm_Main.TransacHis.Commit;
                end;
                iImaID := iTmpImaID;
              end;
            end
            else
              LstErreur.Add('Elements non renseignés, import inhibé pour la ligne n°' + IntToStr(i) + ' (valeur : ' + cds_Transfert[i] + ')');
          end;
        end;

        Inc(i);
      end;

      if (iMagImport=0) and (iImaID<>0) then
      begin
        if not(Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.StartTransaction;
        StProc_Transfert_Recal.ParamByName('IMAID').AsInteger := iImaID;
        StProc_Transfert_Recal.ExecProc;
        StProc_Transfert_Recal.Close;
        Dm_Main.TransacHis.Commit;
      end;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeTransfertID;
    StProc_Transfert.Close;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Transfert_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
    FreeAndNil(Que_GetTVA);
    cds_Transfert.Clear;
  end;
end;

function THistorique.TraiterCommandes: Boolean;
var
  iFouID: integer;
  FouCode: string;
  sTmpFou: string;
  iMagID: integer;
  MagCode: String;
  sTmpMag: string;
  dDate: TDateTime;
  sGardeBon: string;
  sNumFourn: string;
  sNumBon: string;
  sTmpBon: string;
  iCpaID: integer;
  iColID: integer;
  sTmpCol: string;
  iTypID: integer;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  iMrkId: integer;

  sCode: string;
  iCdeID: integer;
  iCdlID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  PxBrut: Double;
  PxAchat: Double;
  Rem1: Double;
  Rem2: Double;
  Rem3: Double;
  dTva: Double;

  PxVente: Double;

  NbRech: integer;
  LRechID: integer;

  bStop: boolean;

  LstErreur: TStringList;
  Que_GetPxVente: TIBQuery;
  Que_GetTVA: TIBQuery;
begin
  Result := false;
  iColID  := 0;

  try
    cds_Commandes.LoadFromFile(sPathCommandes);
  except
    on E: Exception do
    begin
      sError := 'Traitement Commande' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_Commandes.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Commandes_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  iFouID := 0;
  FouCode := '';
  iMagID := 0;
  MagCode := '';
  sNumBon := '';
  iCdeID := 0;
  bStop := false;

  Que_GetPxVente := TIBQuery.Create(nil);
  Que_GetTVA := TIBQuery.Create(nil);
  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDCommandes.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    // preparation pour avoir le prix vente
    Que_GetPxVente.Database := Dm_Main.Database;
    Que_GetPxVente.Transaction := Dm_Main.Transaction;
    Que_GetPxVente.ParamCheck := True;
    Que_GetPxVente.SQL.Clear;
    Que_GetPxVente.SQL.Add('select R_PRIX from GETPRIXDEVENTE(:MAGID,');
    Que_GetPxVente.SQL.Add('                                  :ARTID,');
    Que_GetPxVente.SQL.Add('                                  :TGFID,');
    Que_GetPxVente.SQL.Add('                                  :COUID)');

    // preparation pour avoir la TVA
    Que_GetTVA.Database := Dm_Main.Database;
    Que_GetTVA.Transaction := Dm_Main.Transaction;
    Que_GetTVA.ParamCheck := True;
    Que_GetTVA.SQL.Clear;
    Que_GetTVA.SQL.Add('select TVA_TAUX ' +
                       'from ARTTVA ' +
                          'JOIN K ON (K_ID = TVA_ID AND K_ENABLED = 1) ' +
                          'JOIN ARTREFERENCE ON (ARF_TVAID = TVA_ID) ' +
                       'where ARF_ARTID = :ARTID');

    i := 1;
    try
      NbEnre := cds_Commandes.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Commandes[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Commandes[i], Commandes_COL);

          // fournisseur
          sTmpFou := GetValueCommandesImp('CODE_FOURN');
          if (FouCode<>sTmpFou) or (iFouID=0) then
          begin
            FouCode := sTmpFou;
            iFouID := 0;
            if FouCode<>'' then
              iFouID := Dm_Main.GetFouID(FouCode);
            if iFouID=-1 then
              iFouID := 0;
          end;
          if iFouID=0 then
            Raise Exception.Create('Fournisseur non trouvé pour:'+#13#10+
                                     '  - CODE_FOURN = '+FouCode);

          // magasin
          sTmpMag := GetValueCommandesImp('CODE_MAG');
          if sTmpMag<>MagCode then
          begin
            MagCode := sTmpMag;
            iMagID := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID=0 then
            raise Exception.Create('Magasin non trouvé pour:' +#13#10+ '  - CODE_MAG = '+MagCode);
          ListeUsedMagasin.Add(IntToStr(iMagID));

          // N° de bon
          dDate := ConvertStrToDate(GetValueCommandesImp('DATE'));
          sGardeBon := Trim(GetValueReceptionImp('NUMBON'));
          sNumFourn := '';
          if Pos('##', sGardebon)>0 then
          begin
            sNumFourn := Copy(sGardeBon, Pos('##', sGardebon)+2, Length(sGardebon));
            sGardeBon := Copy(sGardeBon, 1, Pos('##', sGardebon)-1);
          end
          else
          begin
            sGardeBon := '';
            sNumFourn := Trim(GetValueReceptionImp('NUMBON'));
          end;

          if Length(sGardeBon) > 32 then
          begin
            LstErreur.Add('N° Bon trop long : '+sGardeBon);
            sGardeBon := AnsiLeftStr(sGardeBon, 32);
          end;

          if Length(sNumFourn) > 32 then
          begin
            LstErreur.Add('N° Fourn trop long : '+sNumFourn);
            sNumFourn := AnsiLeftStr(sNumFourn, 32);
          end;

          sTmpBon := sGardeBon;
          if (sTmpBon='') then
            sTmpBon := sNumFourn+';'+inttostr(iFouID)+';'+inttostr(iMagID)+';'+FormatDateTime('yy-mm-dd', dDate);
          if (sTmpBon<>sNumBon) then
          begin
            if (iCdeID<>0) then
            begin
              // validation du bon
              if not(bStop) then
              begin
                if iCdeID<>0 then
                begin
                  StProc_Commande_Recal.ParamByName('CDEID').AsInteger := iCdeID;
                  StProc_Commande_Recal.ExecProc;
                  StProc_Commande_Recal.Close;
                  if (Dm_Main.TransacHis.InTransaction) then
                    Dm_Main.TransacHis.Commit;
                  Dm_Main.AjoutInListeCommandesID(sNumBon, iCdeID);
                end;
              end;
              bStop := false;
            end;
            // recherche si pas déjà importé
            LRechID := Dm_Main.RechercheCommandesID(sTmpBon, NbRech);
            iCdeID := 0;
            sNumBon := sTmpBon;

            if (LRechID=-1) then
            begin
              // collection
              iColID := 0;
              sTmpCol := GetValueCommandesImp('CODE_COLLEC');
              if sTmpCol<>'' then
                iColID := Dm_Main.GetColID(sTmpCol);
              if (iColID=-1) then
                iColID := 0;
              // type de paiement
              iCpaID := 0;
              if cds_TypePaie.Locate('CPA_CODE', GetValueCommandesImp('CONDREG'), []) then
                iCpaID := cds_TypePaie.FieldByName('CPA_ID').AsInteger;
              // type d'achat
              iTypID := 0;
              if cds_TypeVen.Locate('TYP_COD', StrToIntDef(GetValueCommandesImp('TYPE'), 0), []) then
                iTypID := cds_TypeVen.FieldByName('TYP_ID').AsInteger;
              // entete de reception
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;
              StProc_Commande_Entete.Close;
              StProc_Commande_Entete.ParamByName('NUMBON').AsString := sGardebon;
              StProc_Commande_Entete.ParamByName('NUMFOURN').AsString := sNumFourn;
              StProc_Commande_Entete.ParamByName('FOUID').AsInteger := iFouID;
              StProc_Commande_Entete.ParamByName('MAGID').AsInteger := iMagID;
              StProc_Commande_Entete.ParamByName('CDEDATE').AsDateTime := dDate;
              StProc_Commande_Entete.ParamByName('TYPID').AsInteger := iTypID;
              StProc_Commande_Entete.ParamByName('CPAID').AsInteger := iCpaID;
              StProc_Commande_Entete.ParamByName('COLID').AsInteger := iColID;
              StProc_Commande_Entete.ParamByName('DATELIV').AsDateTime := ConvertStrToDate(GetValueCommandesImp('DATELIV'));
              StProc_Commande_Entete.ParamByName('RETARD').AsInteger := StrToIntDef(GetValueCommandesImp('RETARD'), 0);
              StProc_Commande_Entete.ParamByName('DATEREG').AsDateTime := ConvertStrToDate(GetValueCommandesImp('DATEREG'));
              StProc_Commande_Entete.ExecQuery;
              iCdeID := StProc_Commande_Entete.FieldByName('CDEID').AsInteger;
              StProc_Commande_Entete.Close;
            end;
          end;

          // ligne de Commande
          LRechID := Dm_Main.RechercheCommandesID(sNumBon, NbRech);
          if (LRechID=-1)
               and (GetValueCommandesImp('CODE_ART')<>'')
               and (GetValueCommandesImp('CODE_TAILLE')<>'')
               and (GetValueCommandesImp('CODE_COUL')<>'')
               and (GetValueCommandesImp('CODE_MAG')<>'')
               and (GetValueCommandesImp('CODE_FOURN')<>'')
               and ((Dm_Main.Provenance = ipExotiqueISF) OR (GetValueCommandesImp('NUMBON')<>''))  //SR - 18-12-2015 : Au cas
               and (GetValueCommandesImp('DATE')<>'')
               and (GetValueCommandesImp('TYPE')<>'') then
          begin

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
              iArtID := Dm_Main.GetArtID(GetValueCommandesImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueCommandesImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueCommandesImp('CODE_COUL'))
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(GetValueCommandesImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueCommandesImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueCommandesImp('CODE_COUL')+GetValueCommandesImp('CODE_ART'));
            end;
          end;

          // article
          if iArtID<=0 then
          begin
            bStop := true;
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;
            LstErreur.Add('Article non trouvé - CODEART = '+GetValueCommandesImp('CODE_ART'));
          end;

          // taille
          if iTgfID<0 then
            iTgfID := 0;
          if (iTgfID=0) and (GetValueCommandesImp('CODE_TAILLE')<>'0') then
          begin
            bStop := true;
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;
            LstErreur.Add('Code taille non trouvé: "'+GetValueCommandesImp('CODE_TAILLE')+'" '+
                          'pour l''article: "'+GetValueCommandesImp('CODE_ART')+'"');
          end;

          // Couleur
          if iCouID<0 then
            iCouID := 0;
          if (iCouID=0) and (GetValueCommandesImp('CODE_COUL')<>'0') then
          begin
            bStop := true;
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;
            LstErreur.Add('Code couleur non trouvé: "'+GetValueCommandesImp('CODE_COUL')+'" '+
                          'pour l''article: "'+GetValueCommandesImp('CODE_ART')+'"');
          end;

          if not(bStop) then
          begin
            PxVente := ConvertStrToFloat(GetValueCommandesImp('PXVTE'));
            if (abs(PxVente)<0.001) then
            begin
              Que_GetPxVente.ParamByName('MAGID').AsInteger := iMagID;
              Que_GetPxVente.ParamByName('ARTID').AsInteger := iArtID;
              Que_GetPxVente.ParamByName('TGFID').AsInteger := iTgfID;
              Que_GetPxVente.ParamByName('COUID').AsInteger := iCouID;
              Que_GetPxVente.Open;
              PxVente := Que_GetPxVente.FieldByName('R_PRIX').AsFloat;
              Que_GetPxVente.Close;
            end;

            PxBrut := ConvertStrToFloat(GetValueCommandesImp('PXBRUT'));
            Rem1 := ConvertStrToFloat(GetValueCommandesImp('REM1'));
            Rem2 := ConvertStrToFloat(GetValueCommandesImp('REM2'));
            Rem3 := ConvertStrToFloat(GetValueCommandesImp('REM3'));
            PxAchat := ((PxBrut*(1-(Rem1/100))) * (1-(Rem2/100))) * (1-(Rem3/100));
            PxAchat := ArrondiA2(PxAchat);

            // SR - 03/05/2017 - Correction de la prise en compte de la TVA
            dTva := ConvertStrToFloat(GetValueCommandesImp('TVA'));

            if (bCorrectionTVA and (dTva = 0)) then
            begin
              Que_GetTVA.ParamByName('ARTID').AsInteger := iArtID;
              Que_GetTVA.Open;
              dTva := Que_GetTVA.FieldByName('TVA_TAUX').AsFloat;
              Que_GetTVA.Close;

              if (dTva = 20) then
              begin
                if (CompareDate(StrToDate(GetValueCommandesImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                  dTva := 19.6;
              end
              else
                if (dTva = 10) then
                begin
                  if (CompareDate(StrToDate(GetValueCommandesImp('DATE')),StrToDate('31/12/2013')) <= 0) then
                    dTva := 7;
                end;

              LstErreur.Add('TVA non trouvé: "'+GetValueCommandesImp('TVA')+'" '+
                                'pour l''article: "'+GetValueCommandesImp('CODE_ART')+'"');
            end;

{            if (dTva = 0) then
            begin
              if (Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.Rollback;
              Result := false;
              sError := '('+inttostr(i)+')'+#13#10+
                        'Ligne: '+LigneLecture+#13#10+
                        'Taux de TVA non trouvé dans TraiterCommandes pour l''article  : ' + IntToStr(iArtID);
              Synchronize(UpdProgressFrm);
              Synchronize(ErrorFrm);

              Exit;
            end;  }

              // insertion de la ligne
              StProc_Commande_Ligne.Close;
              StProc_Commande_Ligne.ParamByName('CDEID').AsInteger := iCdeID;
              StProc_Commande_Ligne.ParamByName('ARTID').AsInteger := iArtID;
              StProc_Commande_Ligne.ParamByName('TGFID').AsInteger := iTgfID;
              StProc_Commande_Ligne.ParamByName('COUID').AsInteger := iCouID;
              StProc_Commande_Ligne.ParamByName('COLID').AsInteger := iColID;
              StProc_Commande_Ligne.ParamByName('QTE').AsInteger := StrToIntDef(GetValueCommandesImp('QTE'), 0);
              StProc_Commande_Ligne.ParamByName('PXACHAT').AsDouble := PxAchat;
              StProc_Commande_Ligne.ParamByName('PXBRUT').AsDouble := PxBrut;
              StProc_Commande_Ligne.ParamByName('REM1').AsDouble := Rem1;
              StProc_Commande_Ligne.ParamByName('REM2').AsDouble := Rem2;
              StProc_Commande_Ligne.ParamByName('REM3').AsDouble := Rem3;
              StProc_Commande_Ligne.ParamByName('PXVTE').AsDouble := ArrondiA2(PxVente);
              StProc_Commande_Ligne.ParamByName('DATELIV').AsDateTime := ConvertStrToDate(GetValueCommandesImp('DATELIV'));
              StProc_Commande_Ligne.ParamByName('TVA').AsDouble := dTva;
              StProc_Commande_Ligne.ExecQuery;
              iMrkID := StProc_Commande_Ligne.FieldByName('MRKID').AsInteger;
              StProc_Commande_Ligne.Close;
              // pour les relations fournisseur <-> marque
              if (iMrkID>0) and not(cds_FouMrk.Locate('FOUID;MRKID', VarArrayOf([iFouId, iMrkId]), [])) then
              begin
                cds_FouMrk.Append;
                cds_FouMrk.FieldByName('FOUID').AsInteger := iFouId;
                cds_FouMrk.FieldByName('MRKID').AsInteger := iMrkId;
                cds_FouMrk.FieldByName('FAIT').AsInteger := 0;
                cds_FouMrk.Post;
              end;

            end;
          end;  //if (LRechID=-1)
        end;

        Inc(i);
      end;

      if not(bStop) then
      begin
        if iCdeID<>0 then
        begin
          StProc_Commande_Recal.ParamByName('CDEID').AsInteger := iCdeID;
          StProc_Commande_Recal.ExecProc;
          StProc_Commande_Recal.Close;
          if (Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.Commit;
          Dm_Main.AjoutInListeCommandesID(sNumBon, iCdeID);
        end;
      end;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

      // traite les relations Marque <--> fournisseur manquante
      iMaxProgress := cds_FouMrk.RecordCount;
      iProgress := 0;
      AvancePc := Round((iMaxProgress/100)*2);
      if AvancePc<=0 then
        AvancePc := 1;
      if AvancePc>1000 then
        AvancePc := 1000;
      inc(iTraitement);
      sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Reception_CSV + ' (Fourn<->Marq)":';
      sEtat2 := '0 / '+inttostr(iMaxProgress);
      Synchronize(UpdateFrm);
      Synchronize(InitProgressFrm);
      i := 1;
      cds_FouMrk.First;
      while not(cds_FouMrk.Eof) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_FouMrk.FieldByName('FAIT').AsInteger=0 then
        begin
          if not(Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.StartTransaction;
          StProc_FouMarque.Close;
          StProc_FouMarque.ParamByName('FOUID').AsInteger := cds_FouMrk.FieldByName('FOUID').AsInteger;
          StProc_FouMarque.ParamByName('MRKID').AsInteger := cds_FouMrk.FieldByName('MRKID').AsInteger;
          StProc_FouMarque.ParamByName('PRINCIPAL').AsInteger := 1;  // sera permuté dans la prk stockée si nécessaire
          StProc_FouMarque.ExecQuery;
          StProc_FouMarque.Close;
          Dm_Main.TransacHis.Commit;
          cds_FouMrk.Edit;
          cds_FouMrk.FieldByName('FAIT').AsInteger := 1;
          cds_FouMrk.Post;
        end;
        cds_FouMrk.Next;
        inc(i);
      end;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeCommandesID;
    StProc_Commande_Entete.Close;
    StProc_Commande_Ligne.Close;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Commande_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
    FreeAndNil(Que_GetPxVente);
    FreeAndNil(Que_GetTVA);
    cds_Commandes.Clear;
  end;

end;

// Retour Fournisseur
function THistorique.TraiterRetourfou: Boolean;
var
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  NbRech: integer;
  LstErreur: TStringList;

  iFouID: integer;
  FouCode: string;
  sTmpFou: string;
  iMagID: integer;
  MagCode: String;
  sTmpMag: string;
  dDate: TDateTime;
  sNumBon: string;
  sTmpBon: string;
  sGardeBon: string;
  //sNumFourn: string;
  iRetID: integer;
  //iCpaID: integer;
  //iColID: integer;
  //sTmpCol: string;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  bStop: boolean;
  LRechID: integer;
begin
  Result := false;

  try
    cds_Retourfou.LoadFromFile(sPathRetourfou);
  except
    on E:Exception do
    begin
      sError := 'Traitement RetourFourn' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_RetourFou.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + RetourFou_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  iFouID := 0;
  FouCode := '';
  iMagID := 0;
  MagCode := '';
  sNumBon := '';
  iRetID := 0;
  bStop := false;

  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDRetourFou.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_RetourFou.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_RetourFou[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_RetourFou[i], RetourFou_COL);

          // fournisseur
          sTmpFou := GetValueRetourFouImp('CODE_FOURN');
          if (FouCode<>sTmpFou) or (iFouID=0) then
          begin
            FouCode := sTmpFou;
            iFouID := 0;
            if FouCode<>'' then
              iFouID := Dm_Main.GetFouID(FouCode);
            if iFouID=-1 then
              iFouID := 0;
          end;
          if iFouID=0 then
            Raise Exception.Create('Fournisseur non trouvé pour:'+#13#10+
                                     '  - CODE_FOURN = '+FouCode);

          // magasin
          sTmpMag := GetValueRetourFouImp('CODE_MAG');
          if sTmpMag<>MagCode then
          begin
            MagCode := sTmpMag;
            iMagID := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID=0 then
            raise Exception.Create('Magasin non trouvé pour:' +#13#10+ '  - CODE_MAG = '+MagCode);
          ListeUsedMagasin.Add(IntToStr(iMagID));

          // N° de bon
          dDate := ConvertStrToDate(GetValueRetourFouImp('DATE_RET'));
          sTmpBon := Trim(GetValueRetourFouImp('NUMCHRONO'));
          sGardeBon := sTmpbon;
          if (sTmpBon='') then
            sTmpBon := inttostr(iFouID)+';'+inttostr(iMagID)+';'+FormatDateTime('yy-mm-dd', dDate);
          if (sTmpBon<>sNumBon) then
          begin
            if (iRetID<>0) then
            begin
              // validation du bon
              if not(bStop) then
              begin
                if (iRetID<>0) then
                begin
             //     StProc_RetourFou_RecalTick.ParamByName('RETID').AsInteger := iRetID;
            //      StProc_RetourFou_RecalTick.ExecProc;
                end;
                Dm_Main.TransacHis.Commit;
                Dm_Main.AjoutInListeRetourFouID(sNumBon, iRetID);
              end;
              bStop := false;
            end;
            // recherche si pas déjà importé
            LRechID := Dm_Main.RechercheRetourFouID(sTmpBon, NbRech);
            iRetID := 0;
            sNumBon := sTmpBon;

            if (LRechID=-1) then
            begin
              // entete de reception
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;

              StProc_RetourFou_Entete.Close;
              StProc_RetourFou_Entete.ParamByName('NUMBON').AsString          := sGardeBon;
              StProc_RetourFou_Entete.ParamByName('NUMFOURN').AsString        := GetValueRetourFouImp('NUMBON');
              StProc_RetourFou_Entete.ParamByName('RETDATE').AsDateTime       := dDate;
              StProc_RetourFou_Entete.ParamByName('FOUID').AsInteger          := iFouID;
              StProc_RetourFou_Entete.ParamByName('MAGID').AsInteger          := iMagID;
              StProc_RetourFou_Entete.ParamByName('MRGLIB').AsString          := GetValueRetourFouImp('MODEREG');
              StProc_RetourFou_Entete.ParamByName('DATEREGLEMENT').AsDateTime := ConvertStrToDate(GetValueRetourFouImp('DATEREG'));
              StProc_RetourFou_Entete.ParamByName('COMMENT_E').AsString       := GetValueRetourFouImp('COMMENT_E');
              StProc_RetourFou_Entete.ParamByName('CLOTURE').AsInteger        := StrToIntDef(GetValueRetourFouImp('CLOTURE'), 1);
              StProc_RetourFou_Entete.ParamByName('TOTTVA1').AsDouble         := ConvertStrToFloat(GetValueRetourFouImp('TOTTVA1'));
              StProc_RetourFou_Entete.ParamByName('TVA1').AsDouble            := ConvertStrToFloat(GetValueRetourFouImp('TVA1'));
              StProc_RetourFou_Entete.ParamByName('TOTTVA2').AsDouble         := ConvertStrToFloat(GetValueRetourFouImp('TOTTVA2'));
              StProc_RetourFou_Entete.ParamByName('TVA2').AsDouble            := ConvertStrToFloat(GetValueRetourFouImp('TVA2'));
              StProc_RetourFou_Entete.ParamByName('TOTTVA3').AsDouble         := ConvertStrToFloat(GetValueRetourFouImp('TOTTVA3'));
              StProc_RetourFou_Entete.ParamByName('TVA3').AsDouble            := ConvertStrToFloat(GetValueRetourFouImp('TVA3'));
              StProc_RetourFou_Entete.ParamByName('TOTTVA4').AsDouble         := ConvertStrToFloat(GetValueRetourFouImp('TOTTVA4'));
              StProc_RetourFou_Entete.ParamByName('TVA4').AsDouble            := ConvertStrToFloat(GetValueRetourFouImp('TVA4'));
              StProc_RetourFou_Entete.ParamByName('TOTTVA5').AsDouble         := ConvertStrToFloat(GetValueRetourFouImp('TOTTVA5'));
              StProc_RetourFou_Entete.ParamByName('TVA5').AsDouble            := ConvertStrToFloat(GetValueRetourFouImp('TVA5'));
              StProc_RetourFou_Entete.ParamByName('ARCHIVER').AsInteger       := StrToIntDef(GetValueRetourFouImp('ARCHIVER'), 1);
              StProc_RetourFou_Entete.ExecQuery;
              iRetID := StProc_RetourFou_Entete.FieldByName('RETID').AsInteger;
              StProc_RetourFou_Entete.Close;
            end;
          end;

          // ligne de retour
          LRechID := Dm_Main.RechercheRetourFouID(sNumBon, NbRech);
          if (LRechID=-1) then
          begin
            iArtID := 0;
            iTgfID := 0;
            iCouID := 0;
            case Dm_Main.Provenance of
              ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
                iArtID := Dm_Main.GetArtID(GetValueRetourFouImp('CODE_ART'));
                iTgfID := Dm_Main.GetTgfID(GetValueRetourFouImp('CODE_TAILLE'));
                iCouID := Dm_Main.GetCouID(GetValueRetourFouImp('CODE_COUL'))
              end;
              ipInterSys, ipExotiqueISF : begin
                iArtID := Dm_Main.GetArtID(GetValueRetourFouImp('CODE_ART'));
                iTgfID := Dm_Main.GetTgfID(GetValueRetourFouImp('CODE_TAILLE'));
                iCouID := Dm_Main.GetCouID(GetValueRetourFouImp('CODE_COUL')+GetValueRetourFouImp('CODE_ART'));
              end;
            end;

            // article
            if iArtID<=0 then
            begin
              bStop := true;
              if (Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.Rollback;

              LstErreur.Add('Article non trouvé - CODEART = '+GetValueRetourFouImp('CODE_ART'));
            end;

            // taille
            if iTgfID<0 then
              iTgfID := 0;
            if (iTgfID=0) and (GetValueRetourFouImp('CODE_TAILLE')<>'0') then
            begin
              bStop := true;
              if (Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.Rollback;
              LstErreur.Add('Code taille non trouvé: "'+GetValueRetourFouImp('CODE_TAILLE')+'" '+
                            'pour l''article: "'+GetValueRetourFouImp('CODE_ART')+'"');
            end;
            // Couleur
            if iCouID<0 then
              iCouID := 0;
            if (iCouID=0) and (GetValueRetourFouImp('CODE_COUL')<>'0') then
            begin
              bStop := true;
              if (Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.Rollback;
              LstErreur.Add('Code couleur non trouvé: "'+GetValueRetourFouImp('CODE_COUL')+'" '+
                            'pour l''article: "'+GetValueRetourFouImp('CODE_ART')+'"');
            end;

            if not(bStop) then
            begin
              // insertion de la ligne
              StProc_RetourFou_Ligne.Close;
              StProc_RetourFou_Ligne.ParamByName('RETID').AsInteger     := iRetID;
              StProc_RetourFou_Ligne.ParamByName('ARTID').AsInteger     := iArtID;
              StProc_RetourFou_Ligne.ParamByName('TGFID').AsInteger     := iTgfID;
              StProc_RetourFou_Ligne.ParamByName('COUID').AsInteger     := iCouID;
              StProc_RetourFou_Ligne.ParamByName('PXNET').AsDouble      := ConvertStrToFloat(GetValueRetourFouImp('PXNET'));
              StProc_RetourFou_Ligne.ParamByName('QTE').AsInteger       := StrToIntDef(GetValueRetourFouImp('QTE'), 0);
              StProc_RetourFou_Ligne.ParamByName('COMMENT_L').AsString  := GetValueRetourFouImp('COMMENT_L');
              StProc_RetourFou_Ligne.ParamByName('TXTVA').AsDouble      := ConvertStrToFloat(GetValueRetourFouImp('TXTVA'));
              StProc_RetourFou_Ligne.ParamByName('CODELIGNE').AsInteger := StrToIntDef(GetValueRetourFouImp('CODELIGNE'), 0);
              StProc_RetourFou_Ligne.ExecQuery;
              StProc_RetourFou_Ligne.Close;

              Dm_Main.AjoutInListeLigneRetourFouID(GetValueRetourFouImp('NUMBON') + GetValueRetourFouImp('CODE_ART') + GetValueRetourFouImp('CODE_TAILLE') + GetValueRetourFouImp('CODE_COUL'), StProc_RetourFou_Ligne.FieldByName('RELID').AsInteger);
              AjoutPrepareRecalStk(iArtID); // mis de coté pour recalcul du stock
            end;
          end;

        end;
        Inc(i);
      end;

      if (iRetID<>0) then
      begin
        // validation du bon
        if not(bStop) then
        begin
          if (iRetID<>0) then
          begin
      //      StProc_RetourFou_RecalTick.ParamByName('BREID').AsInteger := iBreID;
      //      StProc_RetourFou_RecalTick.ExecProc;
          end;
          Dm_Main.TransacHis.Commit;
          Dm_Main.AjoutInListeRetourFouID(sNumBon, iRetID);
        end;
      end;

      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeRetourFouID;
    StProc_RetourFou_Entete.Close;
    StProc_RetourFou_Ligne.Close;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_RetourFou_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
    cds_Retourfou.Clear;
  end;
end;

// Recalcul du stock
function THistorique.RecalculStock: Boolean;

  function StringListToSQL(Liste : TStringList) : string;
  var
    i : integer;
  begin
    Result := '';
    for i := 0 to Liste.count -1 do
    begin
      if not ( (Liste[i] = '') or (Liste[i] = '0') ) then
      begin
        if Result = '' then
          Result := Liste[i]
        else
          Result := Result + ', ' + Liste[i];
      end;
    end;
  end;

var
  //StProc_RecalculStock: TIBQuery;
  Sel_SQL : TIBQuery;
  Upd_SQL : TIBQuery;
  Rec_SQL : TIBQuery;
  //Retour: integer;
  AvancePc: integer;
  dDelai: DWord;
begin
  result := false;
  Sel_SQL := nil;
  Upd_SQL := nil;

  // mise à jour
  Dm_Main.Transaction.Active := false;
  Dm_Main.Transaction.Active := true;
  Dm_Main.TransacHis.Active := false;
  Dm_Main.TransacHis.Active := true;

//  bOkBI := false;
  iMaxProgress := 1;
  iProgress := 0;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') " RecalculStock ":';
  sEtat2 := '';
  Synchronize(UpdateFrm);
  iMaxProgress := 1;
  iProgress := 0;

  try
    Sel_SQL := TIBQuery.Create(nil);
    Sel_SQL.Database := Dm_Main.Database;
    Sel_SQL.Transaction := Dm_Main.Transaction;
    Sel_SQL.ParamCheck := True;

    Upd_SQL := TIBQuery.Create(nil);
    Upd_SQL.Database := Dm_Main.Database;
    Upd_SQL.Transaction := Dm_Main.TransacHis;
    Upd_SQL.ParamCheck := True;

    Rec_SQL := TIBQuery.Create(nil);
    Rec_SQL.Database := Dm_Main.Database;
    Rec_SQL.Transaction := Dm_Main.TransacHis;
    Rec_SQL.ParamCheck := True;

    try
      Sel_SQL.SQL.Clear();
      Sel_SQL.SQL.Add('select count(*) as nbre');
      Sel_SQL.SQL.Add('from tmpstock');
      Sel_SQL.SQL.Add('join agrmouvement on mvt_artid = tmp_artid and mvt_kenabled = 1');
      Sel_SQL.SQL.Add('where tmp_id = 9999 and mvt_magid in (' + StringListToSQL(ListeUsedMagasin) + ')');
      Sel_SQL.SQL.Add('group by mvt_magid, mvt_artid, mvt_tgfid, mvt_couid;');
      try
        Sel_SQL.Open();
        iMaxProgress := Sel_SQL.FieldByName('nbre').AsInteger;
      finally
        Sel_SQL.Close();
      end;

      // supprimer de la liste des triggerDiff
      if not(Dm_Main.TransacHis.InTransaction) then
        Dm_Main.TransacHis.StartTransaction;
      Upd_SQL.SQL.Clear;
      Upd_SQL.SQL.Add('delete from GENTRIGGERDIFF where TRI_ID != 0');
      Upd_SQL.ExecSQL();
      Dm_Main.TransacHis.Commit();
    except
      on E: Exception do
      begin
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;

    Synchronize(InitProgressFrm);

    bStopRecal := false;
    Synchronize(CanAnnuleRecalcul);

    // préparation Sql
    Sel_SQL.SQL.Clear();
    Sel_SQL.SQL.Add('select mvt_magid, mvt_artid, mvt_tgfid, mvt_couid, min(mvt_datex) as mvt_datex');
    Sel_SQL.SQL.Add('from tmpstock');
    Sel_SQL.SQL.Add('join agrmouvement on mvt_artid = tmp_artid and mvt_kenabled = 1');
    Sel_SQL.SQL.Add('where tmp_id = 9999 and mvt_magid in (' + StringListToSQL(ListeUsedMagasin) + ')');
    Sel_SQL.SQL.Add('group by mvt_magid, mvt_artid, mvt_tgfid, mvt_couid;');

    Rec_SQL.SQL.Clear();
    Rec_SQL.SQL.Add('execute procedure recalc_pump_and_stock(:magid, :artid, :tgfid, :couid, :datex);');
    Rec_SQL.Prepare();

    Upd_SQL.SQL.Clear();
    Upd_SQL.SQL.Add('delete from TMPSTOCK where TMP_ID = 9999 and TMP_ARTID = :artid;');
    Upd_SQL.Prepare();

    // mise à jour
    Dm_Main.Transaction.Active := false;
    Dm_Main.Transaction.Active := true;
    Dm_Main.TransacHis.Active := false;
    Dm_Main.TransacHis.Active := true;

    try
      Application.ProcessMessages;
      sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
      AvancePc := Round((iMaxProgress/100)*(0.5));
      if AvancePc<=0 then
        AvancePc := 1;
      if AvancePc>15 then
        AvancePc := 15;
      Synchronize(UpdProgressFrm);
      Application.ProcessMessages;

      // pour tous les articles non speudo
      dDelai := GetTickCount;
      Sel_SQL.Open;
      Sel_SQL.First;
      while not(Sel_SQL.Eof) and not(bStopRecal) do
      begin
        // maj de la fenetre
        Inc(iProgress);
        if iProgress>iMaxProgress then
          iProgress := iMaxProgress;
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        if ((GetTickCount-dDelai)>4000) or ((iProgress mod AvancePc)=0) then
        begin
          dDelai := GetTickCount;
          Application.ProcessMessages;
          Synchronize(UpdProgressFrm);
          Synchronize(GetStatutStopRecalcul);
        end;

        if not(Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.StartTransaction;

        // Recalcule
        Rec_SQL.ParamByName('magid').AsInteger := Sel_SQL.FieldByName('mvt_magid').AsInteger;
        Rec_SQL.ParamByName('artid').AsInteger := Sel_SQL.FieldByName('mvt_artid').AsInteger;
        Rec_SQL.ParamByName('tgfid').AsInteger := Sel_SQL.FieldByName('mvt_tgfid').AsInteger;
        Rec_SQL.ParamByName('couid').AsInteger := Sel_SQL.FieldByName('mvt_couid').AsInteger;
        Rec_SQL.ParamByName('datex').AsDateTime := Sel_SQL.FieldByName('mvt_datex').AsDateTime;
        Rec_SQL.ExecSQL();

        // supprimer de la liste à faire
        Upd_SQL.ParamByName('artid').AsInteger := Sel_SQL.FieldByName('mvt_artid').AsInteger;
        Upd_SQL.ExecSQL();

        Dm_Main.TransacHis.Commit();

        Sel_SQL.Next();
      end;

      Result := true;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Synchronize(NotCanAnnuleRecalcul);
    FreeAndNil(Sel_SQL);
    FreeAndNil(Upd_SQL);
    FreeAndNil(Rec_SQL);
  end;

end;

//// Recalcul du stock  // ancienne méthode
//function THistorique.OldRecalculStock: Boolean;
//var
//  StProc_RecalculStock: TIBQuery;
//  Retour: integer;
//  AvancePc: integer;
//  dDelai: DWord;
//begin
//  result := false;
//
//  iMaxProgress := 1;
//  iProgress := 0;
//  inc(iTraitement);
//  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') " RecalculStock ":';
//  sEtat2 := '';
//  Synchronize(UpdateFrm);
//
//  // nombre d'enregistrement
//  iMaxProgress := 1;
//  iProgress := 0;
//  StProc_RecalculStock := TIBQuery.Create(nil);
//  try
//    try
//      with StProc_RecalculStock do
//      begin
//        Database := Dm_Main.Database;
//        Transaction := Dm_Main.TransacHis;
//        ParamCheck := True;
//        SQL.Add('SELECT count(*) as NBRE FROM GENTRIGGERDIFF');
//	      SQL.Add(' WHERE TRI_ID <> 0');
//        SQL.Add('   AND TRI_MAGID <> 0');
//        if not(Dm_Main.TransacHis.InTransaction) then
//          Dm_Main.TransacHis.StartTransaction;
//        Open;
//        iMaxProgress := FieldByName('NBRE').AsInteger;
//        Close;
//        Dm_Main.TransacHis.Commit;
//      end;
//
//    except
//      on E:Exception do
//      begin
//        sError := E.Message;
//        Synchronize(UpdProgressFrm);
//        Synchronize(ErrorFrm);
//      end;
//    end;
//  finally
//    StProc_RecalculStock.Close;
//    FreeAndNil(StProc_RecalculStock);
//  end;
//
//  Synchronize(InitProgressFrm);
//
//  dDelai := GetTickCount;
//  bStopRecal := false;
//  Synchronize(CanAnnuleRecalcul);
//  try
//    try
//      Application.ProcessMessages;
//      sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
//      AvancePc := Round((iMaxProgress/100)*(0.5));
//      if AvancePc<=0 then
//        AvancePc := 1;
//      if AvancePc>200 then
//        AvancePc := 200;
//      Synchronize(UpdProgressFrm);
//      Application.ProcessMessages;
//      Retour := 1;
//      while (Retour=1) and not(bStopRecal) do
//      begin
//        StProc_RecalculStock := TIBQuery.Create(nil);
//        try
//          with StProc_RecalculStock do
//          begin
//            Database := Dm_Main.Database;
//            Transaction := Dm_Main.TransacHis;
//            ParamCheck := True;
//          //  SQL.Add('select RETOUR from BN_TRIGGERDIFFERE');
//            SQL.Add('select RETOUR from EAI_TRIGGER_DIFFERE(1)');
//            Prepared := true;
//          end;
//
//          if not(Dm_Main.TransacHis.InTransaction) then
//            Dm_Main.TransacHis.StartTransaction;
//          StProc_RecalculStock.Open;
//          Retour := StProc_RecalculStock.FieldByName('RETOUR').AsInteger;
//          StProc_RecalculStock.Close;
//          Dm_Main.TransacHis.Commit;
//
//        finally
//          StProc_RecalculStock.Close;
//          FreeAndNil(StProc_RecalculStock);
//        end;
//
//        //Inc(iProgress, 500);
//        Inc(iProgress);
//        if iProgress>iMaxProgress then
//          iProgress := iMaxProgress;
//        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
//        if ((GetTickCount-dDelai)>4000) or ((iProgress mod AvancePc)=0) then
//        begin
//          dDelai := GetTickCount;
//          Application.ProcessMessages;
//          Synchronize(UpdProgressFrm);
//          Synchronize(GetStatutStopRecalcul);
//          Application.ProcessMessages;
//        end;
//      end;
//
//      StProc_RecalculStock := TIBQuery.Create(nil);
//      try
//        with StProc_RecalculStock do
//        begin
//          Database := Dm_Main.Database;
//          Transaction := Dm_Main.TransacHis;
//          ParamCheck := True;
//          SQL.Add('select RETOUR from BN_TRIGGERDIFFERE');
//        //  SQL.Add('select RETOUR from EAI_TRIGGER_DIFFERE(1)');
//          Prepared := true;
//        end;
//
//        Application.ProcessMessages;
//        if not(Dm_Main.TransacHis.InTransaction) then
//          Dm_Main.TransacHis.StartTransaction;
//        StProc_RecalculStock.Open;
//        Retour := StProc_RecalculStock.FieldByName('RETOUR').AsInteger;
//        StProc_RecalculStock.Close;
//        Dm_Main.TransacHis.Commit;
//        Application.ProcessMessages;
//      finally
//        StProc_RecalculStock.Close;
//        FreeAndNil(StProc_RecalculStock);
//      end;
//
//      Result := true;
//
//      sEtat2 := '';
//      iProgress := 0;
//      Synchronize(UpdProgressFrm);
//    except
//      on E:Exception do
//      begin
//        if (Dm_Main.TransacHis.InTransaction) then
//          Dm_Main.TransacHis.Rollback;
//        sError := E.Message;
//        Synchronize(UpdProgressFrm);
//        Synchronize(ErrorFrm);
//      end;
//    end;
//  finally
//    Synchronize(NotCanAnnuleRecalcul);
//  end;
//
//end;

function THistorique.TraiteForcePump: Boolean;    // met la valeur du pump d'Intersys
var
  Sel_SQL: TIBQuery;
  Sel_SQL2: TIBQuery;
  Upd_SQL: TIBSQL;
  AvancePc: Integer;
  i, j: integer;
  NbEnre: integer;

  iMagImport: integer;

  iMagID: integer;
  iMagID2: integer;
  MagCode: String;
  MagCode2: String;
  sTmpMag: string;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  dDate: TDateTime;
  bOk: boolean;
  vPump: Double;
  LstErreur: TStringList;
  LstMagID: TStringList;
  LstMagID2: TStringList;
  LstMagIDTout: TStringList;
  iGcpId: integer;
  iGcpId2: integer;

  Ph2_Count: integer;
  Ph2_Deb  : integer;
  Ph2_Fin  : integer;
  Ph2_Pas  : integer;

  sFilePath : string;
  iNumFile : Integer;

  sPhaseError: string;

  procedure Ph2_Select(FirstPassage: boolean);
  begin
    if FirstPassage then
    begin
      Ph2_Deb := 1;
      Ph2_Fin := Ph2_Deb+Ph2_Pas-1;
    end
    else
    begin
      Ph2_Deb := Ph2_Deb+Ph2_Pas;
      Ph2_Fin := Ph2_Deb+Ph2_Pas-1;
    end;
    if Ph2_Deb<Ph2_Count then
    begin
      Sel_SQL.Close;
      Sel_SQL.SQL.Clear;
      Sel_SQL.SQL.Add('select * from AGRHISTOSTOCK');
      Sel_SQL.SQL.Add('where hst_id<>0');
      if iMagImport>0 then
        Sel_SQL.SQL.Add('  and hst_magid='+inttostr(iMagImport));
      Sel_SQL.SQL.Add('order by hst_magid, hst_artid, hst_tgfid, hst_couid, hst_date');
      if Ph2_Pas<Ph2_Count then
        Sel_SQL.SQL.Add('rows '+inttostr(Ph2_Deb)+' to '+inttostr(Ph2_Fin));
      Sel_SQL.Open;
      Sel_SQL.First;
    end;
  end;

begin
  iMagID    := 0;
  iMagID2   := 0;
  iNumFile  := 0;

  if Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport, ipLocalBase] then
    Exit( True );

  Result := False;
  try
    cds_Reception.LoadFromFile(sPathReception);
  except
    on E: Exception do
    begin
      sError := 'Traitement TraiteForcePump' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  if Dm_Main.OkTousMag then
    iMagImport := 0
  else
    iMagImport := Dm_Main.MagID;

  sPhaseError := '';
  LstErreur := TStringList.Create;
  LstMagID := TStringList.Create;
  LstMagID2 := TStringList.Create;
  LstMagIDTout := TStringList.Create;
  MagCode := '';
  MagCode2 := '';
  Sel_SQL := TIBQuery.Create(nil);
  Sel_SQL2 := TIBQuery.Create(nil);
  Upd_SQL := TIBSQL.Create(nil);
  try
    // préparation Sql
    Sel_SQL.Database := Dm_Main.Database;
    Sel_SQL.Transaction := Dm_Main.Transaction;
    Sel_SQL.ParamCheck := True;
    Sel_SQL2.Database := Dm_Main.Database;
    Sel_SQL2.Transaction := Dm_Main.Transaction;
    Sel_SQL2.ParamCheck := True;

    // préparation update
    Upd_SQL.Database := Dm_Main.Database;
    Upd_SQL.Transaction := Dm_Main.TransacHis;
    Upd_SQL.ParamCheck := True;
    Upd_SQL.SQL.Clear;
    Upd_SQL.SQL.Add('update AGRHISTOSTOCK set');
    Upd_SQL.SQL.Add('hst_annee=9999,');
    Upd_SQL.SQL.Add('hst_pump=:PUMP');
    Upd_SQL.SQL.Add('where hst_magid=:MAGID');
    Upd_SQL.SQL.Add('  and hst_artid=:ARTID');
    Upd_SQL.SQL.Add('  and hst_tgfid=:TGFID');
    Upd_SQL.SQL.Add('  and hst_couid=:COUID');
    Upd_SQL.SQL.Add('  and hst_date =:HSTDATE');

    sFilePath := sPathReception;
    sPhaseError := 'Phase 1';

    try
      // reception
      while FileExists(sFilePath) do
      begin
        i := 1;
        // phase 1
        iGcpId := -1;

        sPhaseError := 'Phase 1 ; '+ExtractFileName(sFilePath);

        try
          cds_Reception.Clear;
          cds_Reception.LoadFromFile(sFilePath);
        except
          on E:Exception do
          begin
            sError := 'Traitement TraiteForcePump load '+ExtractFilePath(sFilePath)+': ' +E.Message;
            Synchronize(ErrorFrm);
            exit;
          end;
        end;

        iMaxProgress := cds_Reception.Count-1;
        iProgress := 0;
        AvancePc := Round((iMaxProgress/100)*2);
        if AvancePc<=0 then
          AvancePc := 1;
        if AvancePc>1000 then
          AvancePc := 1000;

        sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') " Forçage Pump Intersys ' + ExtractFileName(sFilePath) + '":';
        sEtat2 := '0 / '+inttostr(iMaxProgress);
        Synchronize(UpdateFrm);
        Synchronize(InitProgressFrm);

        NbEnre := cds_Reception.Count-1;
        while (i<=NbEnre) do
        begin
          // maj de la fenetre
          sEtat2 := 'Phase 1/4: '+inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
            Synchronize(UpdProgressFrm);

          if cds_Reception[i]<>'' then
          begin
            // ajout ligne
            AjoutInfoLigne(cds_Reception[i], Reception_COL);

            bOk := true;
            // magasin
            sTmpMag := GetValueReceptionImp('CODE_MAG');
            if sTmpMag<>MagCode then
            begin
              MagCode := sTmpMag;
              iMagID := 0;
              if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
                iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
            end;
            if iMagID=0 then
            begin
              LstErreur.Add('Magasin non trouvé: '+sTmpMag);
              bOk := false;
            end;

            // date de reception
            dDate := ConvertStrToDate(GetValueReceptionImp('DATE'));

            iArtID := 0;
            iTgfID := 0;
            iCouID := 0;
            case Dm_Main.Provenance of
              ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
                iArtID := Dm_Main.GetArtID(GetValueReceptionImp('CODE_ART'));
                iTgfID := Dm_Main.GetTgfID(GetValueReceptionImp('CODE_TAILLE'));
                iCouID := Dm_Main.GetCouID(GetValueReceptionImp('CODE_COUL'))
              end;
              ipInterSys, ipExotiqueISF : begin
                iArtID := Dm_Main.GetArtID(GetValueReceptionImp('CODE_ART'));
                iTgfID := Dm_Main.GetTgfID(GetValueReceptionImp('CODE_TAILLE'));
                iCouID := Dm_Main.GetCouID(GetValueReceptionImp('CODE_COUL')+GetValueReceptionImp('CODE_ART'));
              end;
            end;

            // article
            if iArtID<=0 then
            begin
              bOk := false;
              LstErreur.Add('Article non trouvé: '+GetValueReceptionImp('CODE_ART'));
            end;

            // taille
            if iTgfID<0 then
              iTgfID := 0;
            if (iTgfID=0) and (GetValueReceptionImp('CODE_TAILLE')<>'0') then
            begin
              bOk := false;
              LstErreur.Add('Taille non trouvé: '+GetValueReceptionImp('CODE_TAILLE')+' pour l''article: '+GetValueReceptionImp('CODE_ART'));
            end;

            // Couleur
            if iCouID<0 then
              iCouID := 0;
            if (iCouID=0) and (GetValueReceptionImp('CODE_COUL')<>'0') then
            begin
              bOk := false;
              LstErreur.Add('couleur non trouvé: '+GetValueReceptionImp('CODE_COUL')+' pour l''article: '+GetValueReceptionImp('CODE_ART'));
            end;

            // Pump
            vPump := ConvertStrToFloat(GetValueReceptionImp('PUMP'));

            // liste des mag concernés par le Groupe de Pump
            cds_GroupPump.Locate('MPU_MAGID', iMagId, []);
            if (iGcpId=-1) or (iGcpId<>cds_GroupPump.FieldByName('MPU_GCPID').AsInteger) then
            begin
              iGcpId := cds_GroupPump.FieldByName('MPU_GCPID').AsInteger;
              LstMagID.Clear;
              cds_GroupPump.First;
              while not(cds_GroupPump.Eof) do
              begin
                if (cds_GroupPump.FieldByName('MPU_GCPID').AsInteger=iGcpId) then
                  LstMagID.Add(inttostr(cds_GroupPump.FieldByName('MPU_MAGID').AsInteger));
                cds_GroupPump.Next;
              end;
            end;

            if bOk then
            begin
              for j := 1 to LstMagID.Count do
              begin
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;
                Upd_SQL.ParamByName('MAGID').AsInteger := StrToInt(LstMagID[j-1]);
                Upd_SQL.ParamByName('ARTID').AsInteger := iArtID;
                Upd_SQL.ParamByName('TGFID').AsInteger := iTgfID;
                Upd_SQL.ParamByName('COUID').AsInteger := iCouID;
                Upd_SQL.ParamByName('HSTDATE').AsDateTime := Trunc(dDate);
                Upd_SQL.ParamByName('PUMP').AsDouble := vPump;
                Upd_SQL.ExecQuery;
                Upd_SQL.Close;
                Dm_Main.TransacHis.Commit;
              end;
            end;
          end;

          Inc(i);
        end;
        Inc(iNumFile);
        sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'reception' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
      end;
      cds_Reception.Clear;

      // transfert intermag
      i := 1;
      // phase 1
      iGcpId := -1;
      iGcpId2 := -1;

      sPhaseError := 'Phase 1 ; '+ExtractFileName(sPathTransfert);

      try
        cds_Transfert.Clear;
        cds_Transfert.LoadFromFile(sPathTransfert);
      except
        on E:Exception do
        begin
          sError := 'Traitement TraiteForcePump load '+ExtractFilePath(sPathTransfert)+': ' +E.Message;
          Synchronize(ErrorFrm);
          exit;
        end;
      end;

      iMaxProgress := cds_Transfert.Count-1;
      iProgress := 0;
      AvancePc := Round((iMaxProgress/100)*2);
      if AvancePc<=0 then
        AvancePc := 1;
      if AvancePc>1000 then
        AvancePc := 1000;

      sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') " Forçage Pump Intersys ' + ExtractFileName(sPathTransfert) + '":';
      sEtat2 := '0 / '+inttostr(iMaxProgress);
      Synchronize(UpdateFrm);
      Synchronize(InitProgressFrm);

      NbEnre := cds_Transfert.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := 'Phase 1/4: '+inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Transfert[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Transfert[i], Transfert_COL);

          bOk := true;
          // magasin
          sTmpMag := GetValueTransfertImp('CODE_MAGO');
          if sTmpMag<>MagCode then
          begin
            MagCode := sTmpMag;
            iMagID := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID=0 then
          begin
            LstErreur.Add('Magasin origine non trouvé: '+sTmpMag);
            bOk := false;
          end;
          sTmpMag := GetValueTransfertImp('CODE_MAGD');
          if sTmpMag<>MagCode2 then
          begin
            MagCode2 := sTmpMag;
            iMagID2 := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID2 := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID2=0 then
          begin
            LstErreur.Add('Magasin Destination non trouvé: '+sTmpMag);
            bOk := false;
          end;

          // date de reception
          dDate := ConvertStrToDate(GetValueTransfertImp('DATE'));

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipLocalBase: begin
              iArtID := Dm_Main.GetArtID(GetValueTransfertImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueTransfertImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueTransfertImp('CODE_COUL'))
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(GetValueTransfertImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueTransfertImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueTransfertImp('CODE_COUL')+GetValueTransfertImp('CODE_ART'));
            end;
          end;

          // article
          if iArtID<=0 then
          begin
            bOk := false;
            LstErreur.Add('Article non trouvé: '+GetValueTransfertImp('CODE_ART'));
          end;

          // taille
          if iTgfID<0 then
            iTgfID := 0;
          if (iTgfID=0) and (GetValueTransfertImp('CODE_TAILLE')<>'0') then
          begin
            bOk := false;
            LstErreur.Add('Taille non trouvé: '+GetValueTransfertImp('CODE_TAILLE')+' pour l''article: '+GetValueTransfertImp('CODE_ART'));
          end;

          // Couleur
          if iCouID<0 then
            iCouID := 0;
          if (iCouID=0) and (GetValueTransfertImp('CODE_COUL')<>'0') then
          begin
            bOk := false;
            LstErreur.Add('couleur non trouvé: '+GetValueTransfertImp('CODE_COUL')+' pour l''article: '+GetValueTransfertImp('CODE_ART'));
          end;

          // Pump
          vPump := ConvertStrToFloat(GetValueTransfertImp('PUMP'));

          // liste des mag concernés par le Groupe de Pump
          cds_GroupPump.Locate('MPU_MAGID', iMagId, []);
          if (iGcpId=-1) or (iGcpId<>cds_GroupPump.FieldByName('MPU_GCPID').AsInteger) then
          begin
            iGcpId := cds_GroupPump.FieldByName('MPU_GCPID').AsInteger;
            LstMagID.Clear;
            cds_GroupPump.First;
            while not(cds_GroupPump.Eof) do
            begin
              if (cds_GroupPump.FieldByName('MPU_GCPID').AsInteger=iGcpId) then
                LstMagID.Add(inttostr(cds_GroupPump.FieldByName('MPU_MAGID').AsInteger));
              cds_GroupPump.Next;
            end;
          end;
          cds_GroupPump.Locate('MPU_MAGID', iMagId2, []);
          if (iGcpId2=-1) or (iGcpId2<>cds_GroupPump.FieldByName('MPU_GCPID').AsInteger) then
          begin
            iGcpId2 := cds_GroupPump.FieldByName('MPU_GCPID').AsInteger;
            LstMagID2.Clear;
            cds_GroupPump.First;
            while not(cds_GroupPump.Eof) do
            begin
              if (cds_GroupPump.FieldByName('MPU_GCPID').AsInteger=iGcpId2) then
                LstMagID2.Add(inttostr(cds_GroupPump.FieldByName('MPU_MAGID').AsInteger));
              cds_GroupPump.Next;
            end;
          end;
          LstMagIDTout.Clear;
          LstMagIDTout.AddStrings(LstMagID);
          for j := 1 to LstMagID2.Count do
          begin
            if LstMagIDTout.IndexOf(LstMagID2[j-1])<0 then
              LstMagIdTout.Add(LstMagID2[j-1]);
          end;

          if bOk then
          begin
            for j := 1 to LstMagIdTout.Count do
            begin
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;
              Upd_SQL.ParamByName('MAGID').AsInteger := StrToInt(LstMagIdTout[j-1]);
              Upd_SQL.ParamByName('ARTID').AsInteger := iArtID;
              Upd_SQL.ParamByName('TGFID').AsInteger := iTgfID;
              Upd_SQL.ParamByName('COUID').AsInteger := iCouID;
              Upd_SQL.ParamByName('HSTDATE').AsDateTime := Trunc(dDate);
              Upd_SQL.ParamByName('PUMP').AsDouble := vPump;
              Upd_SQL.ExecQuery;
              Upd_SQL.Close;
              Dm_Main.TransacHis.Commit;
            end;
          end;
        end;

        Inc(i);
      end;
      cds_Transfert.Clear;

      // mise à jour
      Dm_Main.Transaction.Active := false;
      Dm_Main.Transaction.Active := true;
      Dm_Main.TransacHis.Active := false;
      Dm_Main.TransacHis.Active := true;

      // phase 2
      sPhaseError := 'Phase 2 ';
      // préparation update
      Upd_SQL.SQL.Clear;
      Upd_SQL.SQL.Add('update AGRHISTOSTOCK set');
      Upd_SQL.SQL.Add('hst_pump=:PUMP');
      Upd_SQL.SQL.Add('where hst_id=:HSTID');

      Sel_SQL.SQL.Clear;
      Sel_SQL.SQL.Add('select count(*) as NBRE from AGRHISTOSTOCK');
      Sel_SQL.SQL.Add('where hst_id<>0');
      if iMagImport>0 then
        Sel_SQL.SQL.Add('  and hst_magid='+inttostr(iMagImport));
      Sel_SQL.Open;
      iMaxProgress := Sel_SQL.FieldByName('NBRE').AsInteger;

      Ph2_Count := iMaxProgress;
      Ph2_Pas   := Ph2_Count;
      if Ph2_Pas>750000 then
        Ph2_Pas := 750000;

      Sel_SQL.Close;
      iProgress := 0;
      AvancePc := Round((iMaxProgress/100)*2);
      if AvancePc<=0 then
        AvancePc := 1;
      if AvancePc>1000 then
        AvancePc := 1000;
      sEtat2 := 'Phase 2/4: 0 / '+inttostr(iMaxProgress);
      Synchronize(UpdateFrm);
      Synchronize(InitProgressFrm);
      iMagID := -1;
      iArtID := -1;
      iTgfID := -1;
      iCouID := -1;
      vPump := -1;

      Ph2_Select(true);
      while Ph2_Deb<Ph2_Count do
      begin
        if not(Sel_SQL.Eof) then
        begin
          // maj de la fenetre
          sEtat2 := 'Phase 2/4: '+inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
            Synchronize(UpdProgressFrm);

          if Sel_SQL.FieldByName('HST_ANNEE').AsInteger=9999 then
          begin
            // ligne de reception
            iMagID := Sel_SQL.FieldByName('HST_MAGID').AsInteger;
            iArtID := Sel_SQL.FieldByName('HST_ARTID').AsInteger;
            iTgfID := Sel_SQL.FieldByName('HST_TGFID').AsInteger;
            iCouID := Sel_SQL.FieldByName('HST_COUID').AsInteger;
            vPump := Sel_SQL.FieldByName('HST_PUMP').AsFloat;
          end
          else
          begin
            // modif du pump avec la valeur mémorisé
            // le HST_QTE>0 car on garde la valeur du prix d'achat de la fiche article qd qte<=0
            if (iMagID = Sel_SQL.FieldByName('HST_MAGID').AsInteger) and
               (iArtID = Sel_SQL.FieldByName('HST_ARTID').AsInteger) and
               (iTgfID = Sel_SQL.FieldByName('HST_TGFID').AsInteger) and
               (iCouID = Sel_SQL.FieldByName('HST_COUID').AsInteger) {and
               (Sel_SQL.FieldByName('HST_QTE').AsFloat>0)} then
            begin
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;
              Upd_SQL.ParamByName('PUMP').AsDouble := vPump;
              Upd_SQL.ParamByName('HSTID').AsInteger := Sel_SQL.FieldByName('HST_ID').AsInteger;
              Upd_SQL.ExecQuery;
              Upd_SQL.Close;
              Dm_Main.TransacHis.Commit;
            end;
          end;
        end;

        Sel_SQL.Next;
        if Sel_SQL.Eof then
          Ph2_Select(false);   // tranche suivante

      end;

      // mise à jour
      Dm_Main.Transaction.Active := false;
      Dm_Main.Transaction.Active := true;
      Dm_Main.TransacHis.Active := false;
      Dm_Main.TransacHis.Active := true;

      // Phase 3    stock courant
      sPhaseError := 'Phase 3 ';
      // préparation update
      Upd_SQL.SQL.Clear;
      Upd_SQL.SQL.Add('update AGRSTOCKCOUR set');
      Upd_SQL.SQL.Add('stc_pump=:PUMP');
      Upd_SQL.SQL.Add('where stc_id=:STCID');

      // preparation sql pour avoir le dernier pump
      Sel_SQL2.SQL.Clear;
      Sel_SQL2.SQL.Add('select hst_pump from AGRHISTOSTOCK');
      Sel_SQL2.SQL.Add('where hst_magid=:MAGID');
      Sel_SQL2.SQL.Add('  and hst_artid=:ARTID');
      Sel_SQL2.SQL.Add('  and hst_tgfid=:TGFID');
      Sel_SQL2.SQL.Add('  and hst_couid=:COUID');
      Sel_SQL2.SQL.Add('  and hst_date<=CURRENT_DATE');
      Sel_SQL2.SQL.Add('  and hst_datefin>=CURRENT_DATE');

      Sel_SQL.SQL.Clear;
      Sel_SQL.SQL.Add('select count(*) as NBRE from AGRSTOCKCOUR');
      Sel_SQL.SQL.Add('where STC_ID<>0');
      if iMagImport>0 then
        Sel_SQL.SQL.Add('  and stc_magid='+inttostr(iMagImport));
      Sel_SQL.Open;
      iMaxProgress := Sel_SQL.FieldByName('NBRE').AsInteger;
      Sel_SQL.Close;
      iProgress := 0;
      AvancePc := Round((iMaxProgress/100)*2);
      if AvancePc<=0 then
        AvancePc := 1;
      if AvancePc>1000 then
        AvancePc := 1000;
      sEtat2 := 'Phase 3/4: 0 / '+inttostr(iMaxProgress);
      Synchronize(UpdateFrm);
      Synchronize(InitProgressFrm);
      Sel_SQL.SQL.Clear;
      Sel_SQL.SQL.Add('select * from AGRSTOCKCOUR');
      Sel_SQL.SQL.Add('where STC_ID<>0');
      if iMagImport>0 then
        Sel_SQL.SQL.Add('  and stc_magid='+inttostr(iMagImport));
      Sel_SQL.Open;
      Sel_SQL.First;
      while not(Sel_SQL.Eof) do
      begin
        // maj de la fenetre
        sEtat2 := 'Phase 3/4: '+inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        // va chercher le dernier pump dans historique
        vPump:=-1;
        Sel_SQL2.ParamByName('MAGID').AsInteger := Sel_SQL.FieldByName('STC_MAGID').AsInteger;
        Sel_SQL2.ParamByName('ARTID').AsInteger := Sel_SQL.FieldByName('STC_ARTID').AsInteger;
        Sel_SQL2.ParamByName('TGFID').AsInteger := Sel_SQL.FieldByName('STC_TGFID').AsInteger;
        Sel_SQL2.ParamByName('COUID').AsInteger := Sel_SQL.FieldByName('STC_COUID').AsInteger;
        Sel_SQL2.Open;
        Sel_SQL2.First;
        if not(Sel_SQL2.Eof) then
          vPump := Sel_SQL2.FieldByName('HST_PUMP').AsFloat;
        Sel_SQL2.Close;

        // mise à jour du pump courant
        if vPump<>-1 then
        begin
          if not(Dm_Main.TransacHis.InTransaction) then
            Dm_Main.TransacHis.StartTransaction;
          Upd_SQL.ParamByName('PUMP').AsDouble := vPump;
          Upd_SQL.ParamByName('STCID').AsInteger := Sel_SQL.FieldByName('STC_ID').AsInteger;
          Upd_SQL.ExecQuery;
          Upd_SQL.Close;
          Dm_Main.TransacHis.Commit;
        end;

        Sel_SQL.Next;
      end;

      // mise à jour
      Dm_Main.Transaction.Active := false;
      Dm_Main.Transaction.Active := true;
      Dm_Main.TransacHis.Active := false;
      Dm_Main.TransacHis.Active := true;

      // remettre hst_annee à jour
      sPhaseError := 'Phase 4 ';
      sEtat2 := 'Phase 4/4: Finalisation';
      Synchronize(UpdateFrm);
      Upd_SQL.SQL.Clear;
      Upd_SQL.SQL.Add('update AGRHISTOSTOCK set');
      Upd_SQL.SQL.Add('HST_ANNEE=Extract(year from HST_DATE)');
      Upd_SQL.SQL.Add('where HST_ANNEE=9999');
      if not(Dm_Main.TransacHis.InTransaction) then
        Dm_Main.TransacHis.StartTransaction;
      Upd_SQL.ExecQuery;
      Upd_SQL.Close;
      Dm_Main.TransacHis.Commit;

      // mise à jour
      Dm_Main.Transaction.Active := false;
      Dm_Main.Transaction.Active := true;
      Dm_Main.TransacHis.Active := false;
      Dm_Main.TransacHis.Active := true;

      result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        sError := sPhaseError+' '+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Upd_SQL.Close;
    FreeAndNil(Upd_SQL);
    Sel_SQL.Close;
    FreeAndNil(Sel_SQL);
    Sel_SQL2.Close;
    FreeAndNil(Sel_SQL2);
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_ForcePump_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
    FreeAndNil(LstMagID);
    FreeAndNil(LstMagID2);
    FreeAndNil(LstMagIDTout);
    cds_Reception.Clear;
    cds_Transfert.Clear;
  end;
end;

// réactive les triggers
function THistorique.ActiveTrigger: Boolean;
var
  StProc_ActiveTrigger : TIBSQL;
begin
  Result := false;

  iMaxProgress := 1;
  iProgress := 0;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') " Désactive Trigger ":';
  sEtat2 := '';
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  StProc_ActiveTrigger := TIBSQL.Create(nil);
  try
    try
      // ne pas faire sur la base 0
//      with StProc_ActiveTrigger do
//      begin
//        Database := Dm_Main.Database;
//        Transaction := Dm_Main.TransacHis;
//        ParamCheck := True;
//        SQL.Add('EXECUTE PROCEDURE BN_ACTIVETRIGGER(1)');
//
//        if not(Dm_Main.TransacHis.InTransaction) then
//          Dm_Main.TransacHis.StartTransaction;
//
//        Prepare;
//
//        ExecQuery;
//
//        Dm_Main.TransacHis.Commit;
//
//        Result := true;
//      end;
      Result := true;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_ActiveTrigger.Close;
    FreeAndNil(StProc_ActiveTrigger);
  end;
end;

procedure BackupLogArt(ALigneLog: string);
begin
  HisSoiMeme.sEtat2 := Trim(ALigneLog);
  HisSoiMeme.UpdateEtat2;
end;

function THistorique.TraiterAvoir: Boolean;
var
  iAvrID: integer;
  //iBacID: integer;
  iCltID: integer;
  iMagID: integer;
  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  try
    cds_Avoir.LoadFromFile(sPathAvoir);
  except
    on E: Exception do
    begin
      if bRepriseTicket then
        sError := 'Traitement Reprise Avoir ' +E.Message
      else
        sError := 'Traitement Avoir : ' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_Avoir.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  if bRepriseTicket then
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "Reprise ' + Avoir_CSV + '":'
  else
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Avoir_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDAvoir.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Avoir.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_Avoir[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Avoir[i], Avoir_COL);

          // magasin
          CodeMag := GetValueAvoirImp('CODE_MAG');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          ListeUsedMagasin.Add(IntToStr(iMagID));

          //Recherche du client
          iCltID := Dm_Main.GetClientID(GetValueAvoirImp('CODE_CLIENT'));
          if iCltID=-1 then
            iCltID := 0;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheAvoirID(GetValueAvoirImp('CODE'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1) and (GetValueAvoirImp('CODE')<>'') then
          begin
            if not(Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.StartTransaction;

            //Traitement des Avoirs
            StProc_Avoir.Close;
            StProc_Avoir.ParamByName('CLTID').AsInteger             := iCltID;
            StProc_Avoir.ParamByName('CHRONO').AsString             := GetValueAvoirImp('CHRONO');
            StProc_Avoir.ParamByName('TKEID').AsInteger             := 0;
            StProc_Avoir.ParamByName('CODE_POSTE').AsString         := GetValueAvoirImp('CODE_POSTE');
            StProc_Avoir.ParamByName('CODE_SESSION').AsString       := GetValueAvoirImp('CODE_SESSION');
            StProc_Avoir.ParamByName('NUM_TICKET').AsString         := GetValueAvoirImp('NUM_TICKET');
            StProc_Avoir.ParamByName('MAGID').AsInteger             := iMagID;
            StProc_Avoir.ParamByName('DATEEMI').AsDate              := StrToDate(GetValueAvoirImp('DATEEMI'));
            StProc_Avoir.ParamByName('DATEVAL').AsDate              := StrToDate(GetValueAvoirImp('DATEVAL'));
            StProc_Avoir.ParamByName('VALEUR').AsDouble             := ConvertStrToFloat(GetValueAvoirImp('VALEUR'));
            StProc_Avoir.ParamByName('UTIL').AsInteger              := 0;
            StProc_Avoir.ParamByName('CODE_POSTE_UTIL').AsString    := '';
            StProc_Avoir.ParamByName('CODE_SESSION_UTIL').AsString  := '';
            StProc_Avoir.ParamByName('NUM_TICKET_UTIL').AsString    := '';
            StProc_Avoir.ParamByName('SUPPR').AsInteger             := 0;
            StProc_Avoir.ParamByName('REPRISE').AsInteger           := 0;
            StProc_Avoir.ExecQuery;

            // récupération du nouvel ID Client
            iAvrID := StProc_Avoir.FieldByName('AVRID').AsInteger;
            Dm_Main.AjoutInListeAvoirID(GetValueAvoirImp('CODE'), iAvrID);

            StProc_Avoir.Close;

            Dm_Main.TransacHis.Commit;
          end
          else
            if bRepriseTicket then    //Si déjà intégré et reprise de Ticket
            begin
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;

              //Traitement des Avoirs
              StProc_Avoir.Close;
              StProc_Avoir.ParamByName('CLTID').AsInteger             := iCltID;
              StProc_Avoir.ParamByName('CHRONO').AsString             := GetValueAvoirImp('CHRONO');
              StProc_Avoir.ParamByName('TKEID').AsInteger             := 0;
              StProc_Avoir.ParamByName('CODE_POSTE').AsString         := GetValueAvoirImp('CODE_POSTE');
              StProc_Avoir.ParamByName('CODE_SESSION').AsString       := GetValueAvoirImp('CODE_SESSION');
              StProc_Avoir.ParamByName('NUM_TICKET').AsString         := GetValueAvoirImp('NUM_TICKET');
              StProc_Avoir.ParamByName('MAGID').AsInteger             := iMagID;
              StProc_Avoir.ParamByName('DATEEMI').AsDate              := StrToDate(GetValueAvoirImp('DATEEMI'));
              StProc_Avoir.ParamByName('DATEVAL').AsDate              := StrToDate(GetValueAvoirImp('DATEVAL'));
              StProc_Avoir.ParamByName('VALEUR').AsDouble             := ConvertStrToFloat(GetValueAvoirImp('VALEUR'));
              StProc_Avoir.ParamByName('UTIL').AsInteger              := StrToInt(GetValueAvoirImp('UTIL'));
              StProc_Avoir.ParamByName('CODE_POSTE_UTIL').AsString    := GetValueAvoirImp('CODE_POSTE_UTIL');
              StProc_Avoir.ParamByName('CODE_SESSION_UTIL').AsString  := GetValueAvoirImp('CODE_SESSION_UTIL');
              StProc_Avoir.ParamByName('NUM_TICKET_UTIL').AsString    := GetValueAvoirImp('NUM_TICKET_UTIL');
              StProc_Avoir.ParamByName('SUPPR').AsInteger             := StrToInt(GetValueAvoirImp('SUPPR'));
              StProc_Avoir.ParamByName('REPRISE').AsInteger           := Dm_Main.GetAvoirID(GetValueAvoirImp('CODE'));
              StProc_Avoir.ExecQuery;

              StProc_Avoir.Close;

              Dm_Main.TransacHis.Commit;
            end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeAvoirID;
    StProc_Avoir.Close;
  end;
end;

//  Backup - Restore
function THistorique.TraiterBackupRestore: boolean;    // backup restore de la base
var
  ADataBase: string;
  AFileBack: string;
  AFileRest: string;
  AFileLogBack: string;
  AFileLogRest: string;
  Delai: DWord;
  Passe: DWord;
begin
  Result := false;

  if not FnoBackup then
  begin
    HisSoiMeme := Self;

    iMaxProgress := 5;
    iProgress := 0;
    inc(iTraitement);
    sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Arrêt de la base';
    sEtat2 := '';
    Synchronize(UpdateFrm);
    Synchronize(InitProgressFrm);

    ADataBase := Dm_Main.Database.DatabaseName;

    // fichier backup
    AFileBack := ChangeFileExt(AdataBase, '.ibk');
    if FileExists(AFileBack) then
      DeleteFile(AFileBack);

    // fichier log erreur backup (créé si backup plante)
    AFileLogBack := ExtractFilePath(ADatabase);
    if AFileLogBack[Length(AFileLogBack)]<>'\' then
      AFileLogBack := AFileLogBack+'\';
    AFileLogBack := AFileLogBack+'Log_Backup_'+
                    Copy(ADatabase, 1, Length(ADatabase)-Length(ExtractFileExt(ADatabase)))+'.txt';

    // fichier log erreur restore (créé si retore plante)
    AFileLogRest := ExtractFilePath(ADatabase);
    if AFileLogRest[Length(AFileLogRest)]<>'\' then
      AFileLogRest := AFileLogRest+'\';
    AFileLogRest := AFileLogRest+'Log_Restore_'+
                    Copy(ADatabase, 1, Length(ADatabase)-Length(ExtractFileExt(ADatabase)))+'.txt';

    // fichier restore avant renomage
    AFileRest := ChangeFileExt(AdataBase, '_Rest'+ExtractFileExt(AdataBase));
    if FileExists(AFileRest) then
      DeleteFile(AFileRest);

    try
      // arrêt de la base
      Dm_Main.Database.Connected := false;
      if not(Dm_Main.ArretBase(ADataBase)) then
        Raise Exception.Create('Problème sur l''arrêt de la base');

      // attente virtuel de l'arret
      Delai := GetTickCount;
      while GetTickCount-Delai<5500 do  // 5sec et...
      begin
        Passe := GetTickCount-Delai;
      end;

      sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Backup de la base';
      sEtat2 := '';
      inc(iProgress);
      Synchronize(UpdateFrm);
      Synchronize(UpdProgressFrm);
      // backup
      if not(Dm_Main.Backup(ADataBase, AFileBack, AFileLogBack, BackupLogArt)) then
        Raise Exception.Create('Problème sur le backup de la base: Voir les log');

      sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Restore de la base';
      sEtat2 := '';
      inc(iProgress);
      Synchronize(UpdateFrm);
      Synchronize(UpdProgressFrm);
      // restore
      if not(Dm_Main.Restore(AFileRest, AFileBack, AFileLogRest, BackupLogArt)) then
        Raise Exception.Create('Problème sur le restore de la base: Voir les log');

      sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Arrêt de la base';
      sEtat2 := '';
      inc(iProgress);
      Synchronize(UpdateFrm);
      Synchronize(UpdProgressFrm);
      // arrêt de la base
      if not(Dm_Main.ArretBase(ADataBase)) then
        Raise Exception.Create('Problème sur l''arrêt de la base');

      // attente virtuel de l'arret
      Delai := GetTickCount;
      while GetTickCount-Delai<5500 do  // 5sec et...
      begin
        Passe := GetTickCount-Delai;
      end;

      sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Démarrage de la base';
      sEtat2 := '';
      inc(iProgress);
      Synchronize(UpdateFrm);
      Synchronize(UpdProgressFrm);
      if FileExists(ADataBase) then
        DeleteFile(ADataBase);
      if FileExists(ADataBase) then
        Raise Exception.Create('Impossible de renommer la base');
      RenameFile(AFileRest, ADataBase);
      Dm_Main.Database.Connected := true;
      Dm_Main.TransacHis.Active := true;

      Result := true;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

    except
      on E: Exception do
      begin
        Result := false;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  end
  else
  begin
    Result := True;
    doLog('Backup désactivé', logNotice);
  end;
end;

function THistorique.TraiterBonLivraison: Boolean;
var
  iBleID,
  iCltID,
  iMagID,
  iTypID,
  iBlsID,
  iBlmID  : Integer;
  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  try
    cds_BonLivraison.LoadFromFile(sPathBonLivraison);
  except
    on E: Exception do
    begin
      if bRepriseTicket then
        sError := 'Traitement Reprise Bon Livraison ' +E.Message
      else
        sError := 'Traitement Bon Livraison : ' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_BonLivraison.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  if bRepriseTicket then
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "Reprise ' + BonLivraison_CSV + '":'
  else
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + BonLivraison_CSV  + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDBonLivraison.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_BonLivraison.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_BonLivraison[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_BonLivraison[i], BonLivraison_COL);

          // magasin
          CodeMag := GetValueBonLivraisonImp('CODE_MAG');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          ListeUsedMagasin.Add(IntToStr(iMagID));

          //Recherche du client
          iCltID := Dm_Main.GetClientID(GetValueBonLivraisonImp('CODE_CLIENT'));
          if iCltID=-1 then
            iCltID := 0;

          //Recherche type de vente BL
          iTypID := 0;
          if (cds_TypeVenBL.Locate('TYP_COD;TYP_CATEG', VarArrayOf([StrToIntDef(GetValueBonLivraisonImp('TYPCODBL'), 0), StrToIntDef(GetValueBonLivraisonImp('TYPCATEG'), 0)]), [])) then
            iTypID := cds_TypeVenBL.FieldByName('TYP_ID').AsInteger;

          //Recherche Statut BL
          iBlsID := 0;
          if (cds_StatutBL.Locate('BLS_CODE', GetValueBonLivraisonImp('BLSCODE'), [])) then
            iBlsID := cds_StatutBL.FieldByName('BLS_ID').AsInteger;

          //Recherche Motif BL
          iBlmID := 0;
          if (cds_MotifBL.Locate('BLM_CODE', GetValueBonLivraisonImp('BLMCODE'), [])) then
            iBlmID := cds_MotifBL.FieldByName('BLM_ID').AsInteger;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheBonLivraisonID(GetValueBonLivraisonImp('CODE_BL'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1) and (GetValueBonLivraisonImp('CODE_BL')<>'') then
          begin
            if not(Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.StartTransaction;

            //Traitement des Bon Livraison En-tête
            StProc_BonLivraison.Close;
            StProc_BonLivraison.ParamByName('MAGID').AsInteger          := iMagID;
            StProc_BonLivraison.ParamByName('CLTID').AsInteger          := iCltID;
            StProc_BonLivraison.ParamByName('TYPBL').AsInteger          := StrToInt(GetValueBonLivraisonImp('TYPBL'));
            StProc_BonLivraison.ParamByName('NUMERO').AsString          := GetValueBonLivraisonImp('NUMERO');
            StProc_BonLivraison.ParamByName('DATEBL').AsDateTime        := StrToDateTime(GetValueBonLivraisonImp('DATEBL'));
            StProc_BonLivraison.ParamByName('REMISE').AsFloat           := ConvertStrToFloat(GetValueBonLivraisonImp('REMISE'));
            StProc_BonLivraison.ParamByName('DETAXE').AsInteger         := StrToInt(GetValueBonLivraisonImp('DETAXE'));
            StProc_BonLivraison.ParamByName('TOTTVA1').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA1'));
            StProc_BonLivraison.ParamByName('TVA1').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA1'));
            StProc_BonLivraison.ParamByName('TOTTVA2').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA2'));
            StProc_BonLivraison.ParamByName('TVA2').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA2'));
            StProc_BonLivraison.ParamByName('TOTTVA3').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA3'));
            StProc_BonLivraison.ParamByName('TVA3').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA3'));
            StProc_BonLivraison.ParamByName('TOTTVA4').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA4'));
            StProc_BonLivraison.ParamByName('TVA4').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA4'));
            StProc_BonLivraison.ParamByName('TOTTVA5').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA5'));
            StProc_BonLivraison.ParamByName('TVA5').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA5'));
            StProc_BonLivraison.ParamByName('CLOTURE').AsInteger        := StrToInt(GetValueBonLivraisonImp('CLOTURE'));;
            StProc_BonLivraison.ParamByName('ARCHIVER').AsInteger       := StrToInt(GetValueBonLivraisonImp('ARCHIVER'));;
            StProc_BonLivraison.ParamByName('CLIENT_NOM').AsString      := GetValueBonLivraisonImp('CLIENT_NOM');
            StProc_BonLivraison.ParamByName('CLIENT_PRENOM').AsString   := GetValueBonLivraisonImp('CLIENT_PRENOM');
            StProc_BonLivraison.ParamByName('CIVILITE').AsString        := GetValueBonLivraisonImp('CIVILITE');
            StProc_BonLivraison.ParamByName('VILLE').AsString           := GetValueBonLivraisonImp('VILLE');
            StProc_BonLivraison.ParamByName('CP').AsString              := GetValueBonLivraisonImp('CP');
            StProc_BonLivraison.ParamByName('PAYS').AsString            := GetValueBonLivraisonImp('PAYS');
            StProc_BonLivraison.ParamByName('ADRLIGNE').AsString        := GetValueBonLivraisonImp('ADRLIGNE');
            StProc_BonLivraison.ParamByName('COMENT').AsString          := GetValueBonLivraisonImp('COMENT');
            StProc_BonLivraison.ParamByName('MARGE').AsFloat            := ConvertStrToFloat(GetValueBonLivraisonImp('MARGE'));
            StProc_BonLivraison.ParamByName('TYPID').AsInteger          := iTypID;
            StProc_BonLivraison.ParamByName('BLSID').AsInteger          := iBlsID;
            StProc_BonLivraison.ParamByName('BLMID').AsInteger          := iBlmID;
            StProc_BonLivraison.ParamByName('DTLIMRETRAIT').AsDateTime  := StrToDateTime(GetValueBonLivraisonImp('DTLIMRETRAIT'));
            StProc_BonLivraison.ParamByName('NUMCARTEFID').AsString     := GetValueBonLivraisonImp('NUMCARTEFID');
            StProc_BonLivraison.ParamByName('REPRISE').AsInteger        := 0;
            StProc_BonLivraison.ExecQuery;

            // récupération du nouvel ID Bon Livraison En-tête
            iBleID := StProc_BonLivraison.FieldByName('BLEID').AsInteger;
            Dm_Main.AjoutInListeBonLivraisonID(GetValueBonLivraisonImp('CODE_BL'), iBleID);

            StProc_BonLivraison.Close;

            Dm_Main.TransacHis.Commit;
          end
          else
          begin
            if bRepriseTicket then    //Si déjà intégré et reprise de Ticket
            begin
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;

              //Traitement des Bon Livraison En-tête
              StProc_BonLivraison.Close;
              StProc_BonLivraison.ParamByName('MAGID').AsInteger          := iMagID;
              StProc_BonLivraison.ParamByName('CLTID').AsInteger          := iCltID;
              StProc_BonLivraison.ParamByName('TYPBL').AsInteger          := StrToInt(GetValueBonLivraisonImp('TYPBL'));
              StProc_BonLivraison.ParamByName('NUMERO').AsString          := GetValueBonLivraisonImp('NUMERO');
              StProc_BonLivraison.ParamByName('DATEBL').AsDateTime        := StrToDateTime(GetValueBonLivraisonImp('DATEBL'));
              StProc_BonLivraison.ParamByName('REMISE').AsFloat           := ConvertStrToFloat(GetValueBonLivraisonImp('REMISE'));
              StProc_BonLivraison.ParamByName('DETAXE').AsInteger         := StrToInt(GetValueBonLivraisonImp('DETAXE'));
              StProc_BonLivraison.ParamByName('TOTTVA1').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA1'));
              StProc_BonLivraison.ParamByName('TVA1').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA1'));
              StProc_BonLivraison.ParamByName('TOTTVA2').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA2'));
              StProc_BonLivraison.ParamByName('TVA2').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA2'));
              StProc_BonLivraison.ParamByName('TOTTVA3').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA3'));
              StProc_BonLivraison.ParamByName('TVA3').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA3'));
              StProc_BonLivraison.ParamByName('TOTTVA4').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA4'));
              StProc_BonLivraison.ParamByName('TVA4').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA4'));
              StProc_BonLivraison.ParamByName('TOTTVA5').AsFloat          := ConvertStrToFloat(GetValueBonLivraisonImp('TOTTVA5'));
              StProc_BonLivraison.ParamByName('TVA5').AsFloat             := ConvertStrToFloat(GetValueBonLivraisonImp('TVA5'));
              StProc_BonLivraison.ParamByName('CLOTURE').AsInteger        := StrToInt(GetValueBonLivraisonImp('CLOTURE'));;
              StProc_BonLivraison.ParamByName('ARCHIVER').AsInteger       := StrToInt(GetValueBonLivraisonImp('ARCHIVER'));;
              StProc_BonLivraison.ParamByName('CLIENT_NOM').AsString      := GetValueBonLivraisonImp('CLIENT_NOM');
              StProc_BonLivraison.ParamByName('CLIENT_PRENOM').AsString   := GetValueBonLivraisonImp('CLIENT_PRENOM');
              StProc_BonLivraison.ParamByName('CIVILITE').AsString        := GetValueBonLivraisonImp('CIVILITE');
              StProc_BonLivraison.ParamByName('VILLE').AsString           := GetValueBonLivraisonImp('VILLE');
              StProc_BonLivraison.ParamByName('CP').AsString              := GetValueBonLivraisonImp('CP');
              StProc_BonLivraison.ParamByName('PAYS').AsString            := GetValueBonLivraisonImp('PAYS');
              StProc_BonLivraison.ParamByName('ADRLIGNE').AsString        := GetValueBonLivraisonImp('ADRLIGNE');
              StProc_BonLivraison.ParamByName('COMENT').AsString          := GetValueBonLivraisonImp('COMENT');
              StProc_BonLivraison.ParamByName('MARGE').AsFloat            := ConvertStrToFloat(GetValueBonLivraisonImp('MARGE'));
              StProc_BonLivraison.ParamByName('TYPID').AsInteger          := iTypID;
              StProc_BonLivraison.ParamByName('BLSID').AsInteger          := iBlsID;
              StProc_BonLivraison.ParamByName('BLMID').AsInteger          := iBlmID;
              StProc_BonLivraison.ParamByName('DTLIMRETRAIT').AsDateTime  := StrToDateTime(GetValueBonLivraisonImp('DTLIMRETRAIT'));
              StProc_BonLivraison.ParamByName('NUMCARTEFID').AsString     := GetValueBonLivraisonImp('NUMCARTEFID');
              StProc_BonLivraison.ParamByName('REPRISE').AsInteger        := Dm_Main.GetBonLivraisonID(GetValueBonLivraisonImp('CODE_BL'));
              StProc_BonLivraison.ExecQuery;

              StProc_BonLivraison.Close;

              Dm_Main.TransacHis.Commit;
            end;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeBonLivraisonID;
    StProc_BonLivraison.Close;
  end;
end;

function THistorique.TraiterBonLivraisonHisto: Boolean;
var
  iBleID,
  iBlhID  : Integer;
  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  try
    cds_BonLivraisonHisto.LoadFromFile(sPathBonLivraisonHisto);
  except
    on E: Exception do
    begin
      if bRepriseTicket then
        sError := 'Traitement Reprise Bon Livraison Histo' +E.Message
      else
        sError := 'Traitement Bon Livraison Histo : ' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_BonLivraisonHisto.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  if bRepriseTicket then
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "Reprise ' + BonLivraisonHisto_CSV + '":'
  else
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + BonLivraisonHisto_CSV  + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDBonLivraisonHisto.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_BonLivraisonHisto.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_BonLivraisonHisto[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_BonLivraisonHisto[i], BonLivraisonHisto_COL);

          //Recherche du BL
          iBleID := Dm_Main.GetBonLivraisonID(GetValueBonLivraisonHistoImp('CODE_BL'));
          if iBleID=-1 then
            iBleID := 0;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheBonLivraisonHistoID(GetValueBonLivraisonHistoImp('CODE_HISTO'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1) and (GetValueBonLivraisonHistoImp('CODE_HISTO')<>'') then
          begin
            if not(Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.StartTransaction;

            //Traitement des Clients
            StProc_BonLivraisonHisto.Close;
            StProc_BonLivraisonHisto.ParamByName('BLEID').AsInteger         := iBleID;
            StProc_BonLivraisonHisto.ParamByName('DATEHISTO').AsDateTime    := StrToDateTime(GetValueBonLivraisonHistoImp('DATEHISTO'));
            StProc_BonLivraisonHisto.ParamByName('BLSCODE').AsString        := GetValueBonLivraisonHistoImp('BLSCODE');
            StProc_BonLivraisonHisto.ParamByName('BLSLIB').AsString         := GetValueBonLivraisonHistoImp('BLSLIB');
            StProc_BonLivraisonHisto.ParamByName('BLMCODE').AsString        := GetValueBonLivraisonHistoImp('BLMCODE');
            StProc_BonLivraisonHisto.ParamByName('BLMLIB').AsString         := GetValueBonLivraisonHistoImp('BLMLIB');
            StProc_BonLivraisonHisto.ParamByName('NUMCARTEFIS').AsString    := GetValueBonLivraisonHistoImp('NUMCARTEFIS');
            StProc_BonLivraisonHisto.ParamByName('DTLIMRETRAIT').AsDateTime := StrToDateTime(GetValueBonLivraisonHistoImp('DTLIMRETRAIT'));
            StProc_BonLivraisonHisto.ParamByName('BLHETAT').AsInteger       := StrToInt(GetValueBonLivraisonHistoImp('BLHETAT'));
            StProc_BonLivraisonHisto.ExecQuery;

            // récupération du nouvel ID Client
            iBlhID := StProc_BonLivraisonHisto.FieldByName('BLHID').AsInteger;
            Dm_Main.AjoutInListeBonLivraisonHistoID(GetValueBonLivraisonHistoImp('CODE_HISTO'), iBlhID);

            StProc_BonLivraisonHisto.Close;

            Dm_Main.TransacHis.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeBonLivraisonHistoID;
    StProc_BonLivraisonHisto.Close;
  end;
end;

function THistorique.TraiterBonLivraisonL: Boolean;
var
  iBleID,
  iBllID,
  iTypID,
  iBlmID,
  iArtID,
  iTgfID,
  iCouID  : Integer;
//  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;

  bStop: boolean;
  LstErreur: TStringList;
begin
  Result := true;

  bStop := False;
  LstErreur := TStringList.Create;

  try
    cds_BonLivraisonL.LoadFromFile(sPathBonLivraisonL);
  except
    on E: Exception do
    begin
      if bRepriseTicket then
        sError := 'Traitement Reprise Bon Livraison Ligne ' +E.Message
      else
        sError := 'Traitement Bon Livraison Ligne : ' +E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  iMaxProgress := cds_BonLivraisonL.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  if bRepriseTicket then
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "Reprise ' + BonLivraisonL_CSV + '":'
  else
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + BonLivraisonL_CSV  + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDBonLivraisonL.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_BonLivraisonL.Count-1;
      while (i<=NbEnre) do
      begin
        bStop := false;

        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_BonLivraisonL[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_BonLivraisonL[i], BonLivraisonL_COL);

          //Recherche du BL
          iBleID := Dm_Main.GetBonLivraisonID(GetValueBonLivraisonLImp('CODE_BL'));
          if iBleID=-1 then
            iBleID := 0;

          //Recherche type de vente BL
          iTypID := 0;
          if (cds_TypeVenBL.Locate('TYP_COD;TYP_CATEG', VarArrayOf([StrToIntDef(GetValueBonLivraisonLImp('TYPCODBL'), 0), StrToIntDef(GetValueBonLivraisonLImp('TYPCATEG'), 0)]), [])) then
            iTypID := cds_TypeVenBL.FieldByName('TYP_ID').AsInteger;

          //Recherche Motif BL
          iBlmID := 0;
          if (cds_MotifBL.Locate('BLM_CODE', GetValueBonLivraisonLImp('BLMCODE'), [])) then
            iBlmID := cds_MotifBL.FieldByName('BLM_ID').AsInteger;

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipLocalBase: begin
              iArtID := StrToInt(GetValueBonLivraisonLImp('CODE_ART'));
              iTgfID := StrToInt(GetValueBonLivraisonLImp('CODE_TAILLE'));
              iCouID := StrToInt(GetValueBonLivraisonLImp('CODE_COUL'));
            end;
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
              iArtID := Dm_Main.GetArtID(GetValueBonLivraisonLImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueBonLivraisonLImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueBonLivraisonLImp('CODE_COUL'));
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(GetValueBonLivraisonLImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueBonLivraisonLImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueBonLivraisonLImp('CODE_COUL')+GetValueBonLivraisonLImp('CODE_ART'));
            end;
          end;

          // article
          if iArtID<=0 then
          begin
            bStop := true;
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;
            LstErreur.Add(Format('Ligne %d/%d: Article non trouvé = "%s"', [
              i + 1,
              NbEnre + 1,
              GetValueBonLivraisonLImp('CODE_ART')
            ]));
          end;

          // taille
          if iTgfID<0 then
            iTgfID := 0;
          if (iTgfID=0) and (GetValueBonLivraisonLImp('CODE_TAILLE')<>'0') then
          begin
            bStop := true;
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;

                LstErreur.Add(Format('Ligne %d/%d: Code taille non trouvé: "%s" pour l''article: "%s"', [
                  i + 1,
                  NbEnre + 1,
                  GetValueBonLivraisonLImp('CODE_TAILLE'),
                  GetValueBonLivraisonLImp('CODE_ART')
                ]));
          end;

          // Couleur
          if iCouID<0 then
            iCouID := 0;
          if (iCouID=0) and (GetValueCaisseImp('CODE_COUL')<>'0') then
          begin
            bStop := true;
            if (Dm_Main.TransacHis.InTransaction) then
              Dm_Main.TransacHis.Rollback;

            LstErreur.Add(Format('Ligne %d/%d: Code couleur non trouvé: "%s" pour l''article: "%s"', [
              i + 1,
              NbEnre + 1,
              GetValueBonLivraisonLImp('CODE_COUL'),
              GetValueBonLivraisonLImp('CODE_ART')
            ]));
          end;

          if not(bStop) then
          begin
            // recherche si pas déjà importé
            LRechID := Dm_Main.RechercheBonLivraisonLID(GetValueBonLivraisonLImp('CODE_BLL'), NbRech);

            // création si pas déjà créé
            if (LRechID=-1) and (GetValueBonLivraisonLImp('CODE_BLL')<>'') then
            begin
              if not(Dm_Main.TransacHis.InTransaction) then
                Dm_Main.TransacHis.StartTransaction;

              //Traitement des Bon Livraison Ligne
              StProc_BonLivraisonL.Close;
              StProc_BonLivraisonL.ParamByName('BLEID').AsInteger   := iBleID;
              StProc_BonLivraisonL.ParamByName('ARTID').AsInteger   := iArtID;
              StProc_BonLivraisonL.ParamByName('TGFID').AsInteger   := iTgfID;
              StProc_BonLivraisonL.ParamByName('COUID').AsInteger   := iCouID;
              StProc_BonLivraisonL.ParamByName('NOM').AsString      := GetValueBonLivraisonLImp('NOM');
              StProc_BonLivraisonL.ParamByName('TYPVTE').AsInteger  := StrToInt(GetValueBonLivraisonLImp('TYPVTE'));
              StProc_BonLivraisonL.ParamByName('QTE').AsInteger     := StrToInt(GetValueBonLivraisonLImp('QTE'));
              StProc_BonLivraisonL.ParamByName('PXBRUT').AsFloat    := ConvertStrToFloat(GetValueBonLivraisonLImp('PXBRUT'));
              StProc_BonLivraisonL.ParamByName('PXNET').AsFloat     := ConvertStrToFloat(GetValueBonLivraisonLImp('PXNET'));
              StProc_BonLivraisonL.ParamByName('PXNN').AsFloat      := ConvertStrToFloat(GetValueBonLivraisonLImp('PXNN'));
              StProc_BonLivraisonL.ParamByName('TVA').AsFloat       := ConvertStrToFloat(GetValueBonLivraisonLImp('TVA'));
              StProc_BonLivraisonL.ParamByName('COMENT').AsString   := GetValueBonLivraisonLImp('COMENT');
              StProc_BonLivraisonL.ParamByName('QTECMD').AsFloat    := ConvertStrToFloat(GetValueBonLivraisonLImp('QTECMD'));
              StProc_BonLivraisonL.ParamByName('QTEPREP').AsFloat   := ConvertStrToFloat(GetValueBonLivraisonLImp('QTEPREP'));
              StProc_BonLivraisonL.ParamByName('QTERETIRE').AsFloat := ConvertStrToFloat(GetValueBonLivraisonLImp('QTERETIRE'));
              StProc_BonLivraisonL.ParamByName('QTERETOUR').AsFloat := ConvertStrToFloat(GetValueBonLivraisonLImp('QTERETOUR'));
              StProc_BonLivraisonL.ParamByName('TYPID').AsInteger   := iTypID;
              StProc_BonLivraisonL.ParamByName('BLMID').AsInteger   := iBlmID;
              StProc_BonLivraisonL.ParamByName('REPRISE').AsInteger := 0;
              StProc_BonLivraisonL.ExecQuery;

              // récupération du nouvel ID Bon Livraison Ligne
              iBllID := StProc_BonLivraisonL.FieldByName('BLLID').AsInteger;
              if (Dm_Main.GetBonLivraisonLID(GetValueBonLivraisonLImp('CODE_BLL')) <> iBllID) then
                Dm_Main.AjoutInListeBonLivraisonLID(GetValueBonLivraisonLImp('CODE_BLL'), iBllID);

              StProc_BonLivraisonL.Close;

              Dm_Main.TransacHis.Commit;
            end
            else
            begin
              if bRepriseTicket then    //Si déjà intégré et reprise de Ticket
              begin
                if not(Dm_Main.TransacHis.InTransaction) then
                  Dm_Main.TransacHis.StartTransaction;

                //Traitement des Bon Livraison Ligne
                StProc_BonLivraisonL.Close;
                StProc_BonLivraisonL.ParamByName('BLEID').AsInteger   := iBleID;
                StProc_BonLivraisonL.ParamByName('ARTID').AsInteger   := iArtID;
                StProc_BonLivraisonL.ParamByName('TGFID').AsInteger   := iTgfID;
                StProc_BonLivraisonL.ParamByName('COUID').AsInteger   := iCouID;
                StProc_BonLivraisonL.ParamByName('NOM').AsString      := GetValueBonLivraisonLImp('NOM');
                StProc_BonLivraisonL.ParamByName('TYPVTE').AsInteger  := StrToInt(GetValueBonLivraisonLImp('TYPVTE'));
                StProc_BonLivraisonL.ParamByName('QTE').AsInteger     := StrToInt(GetValueBonLivraisonLImp('QTE'));
                StProc_BonLivraisonL.ParamByName('PXBRUT').AsFloat    := ConvertStrToFloat(GetValueBonLivraisonLImp('PXBRUT'));
                StProc_BonLivraisonL.ParamByName('PXNET').AsFloat     := ConvertStrToFloat(GetValueBonLivraisonLImp('PXNET'));
                StProc_BonLivraisonL.ParamByName('PXNN').AsFloat      := ConvertStrToFloat(GetValueBonLivraisonLImp('PXNN'));
                StProc_BonLivraisonL.ParamByName('TVA').AsFloat       := ConvertStrToFloat(GetValueBonLivraisonLImp('TVA'));
                StProc_BonLivraisonL.ParamByName('COMENT').AsString   := GetValueBonLivraisonLImp('COMENT');
                StProc_BonLivraisonL.ParamByName('QTECMD').AsFloat    := ConvertStrToFloat(GetValueBonLivraisonLImp('QTECMD'));
                StProc_BonLivraisonL.ParamByName('QTEPREP').AsFloat   := ConvertStrToFloat(GetValueBonLivraisonLImp('QTEPREP'));
                StProc_BonLivraisonL.ParamByName('QTERETIRE').AsFloat := ConvertStrToFloat(GetValueBonLivraisonLImp('QTERETIRE'));
                StProc_BonLivraisonL.ParamByName('QTERETOUR').AsFloat := ConvertStrToFloat(GetValueBonLivraisonLImp('QTERETOUR'));
                StProc_BonLivraisonL.ParamByName('TYPID').AsInteger   := iTypID;
                StProc_BonLivraisonL.ParamByName('BLMID').AsInteger   := iBlmID;
                StProc_BonLivraisonL.ParamByName('REPRISE').AsInteger := Dm_Main.GetBonLivraisonLID(GetValueBonLivraisonLImp('CODE_BLL'));
                StProc_BonLivraisonL.ExecQuery;

                StProc_BonLivraisonL.Close;

                Dm_Main.TransacHis.Commit;
              end;
            end;
            bStop := False;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacHis.InTransaction) then
          Dm_Main.TransacHis.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    if LstErreur.Count>0 then
    begin
      if bRepriseTicket then
        LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Reprise_Ligne_BL_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt')
      else
        LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Ligne_BL_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    end;
    FreeAndNil(LstErreur);

    Dm_Main.SaveListeBonLivraisonLID;
    StProc_BonLivraisonL.Close;
  end;
end;

{ THistorique.TUpdatePumpRec }

constructor THistorique.TUpdatePumpRec.Create(const MAG_ID, ART_ID, TGF_ID,
  COU_ID: Integer; const DATE: TDateTime);
begin
  Self.MAG_ID := MAG_ID;
  Self.ART_ID := ART_ID;
  Self.TGF_ID := TGF_ID;
  Self.COU_ID := COU_ID;
  Self.DATE := DATE;
end;

end.


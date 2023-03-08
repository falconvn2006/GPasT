unit loc_dm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  dxmdaset, DB, IBTable, IBDatabase, IBCustomDataSet, IBQuery, DateUtils,
  ComCtrls, DBCtrls, ExtCtrls, Dialogs, StdCtrls, DBClient, StrUtils,
  IBStoredProc, MidasLib;

const
  cPrUpdateK_Mvt  = 0;  //Mouvementer K
  cPrUpdateK_Sup  = 1;  //Supprimer K
  cPrUpdateK_Act  = 2;  //Réactiver K

type
  TDm_Loc = class(TDataModule)
    Que_LstMagLocali: TIBQuery;
    Que_LstMagLocaliMAG_ID: TIntegerField;
    Que_LstMagLocaliMAG_ENSEIGNE: TIBStringField;
    Ds_ListMagLocali: TDataSource;
    Que_LstMagProprio: TIBQuery;
    Que_LstMagProprioMAG_ID: TIntegerField;
    Que_LstMagProprioMAG_ENSEIGNE: TIBStringField;
    Ds_ListMagProprio: TDataSource;
    Ds_LstMag: TDataSource;
    Que_LstMag: TIBQuery;
    Que_LstMagMAG_ID: TIntegerField;
    Que_LstMagMAG_ENSEIGNE: TIBStringField;
    Ginkoia: TIBDatabase;
    tran: TIBTransaction;
    ibc_ktb: TIBQuery;
    IbC_BL: TIBQuery;
    IbC_Loc: TIBQuery;
    IbC_Loa: TIBQuery;
    ibc_cb: TIBQuery;
    ibc_cbCBI_ARLID: TIntegerField;
    ibc_cbCAL_NOM: TIBStringField;
    ibc_locart: TIBQuery;
    ibc_locartARL_ID: TIntegerField;
    ibc_locartCAL_NOM: TIBStringField;
    ibc_clt: TIBQuery;
    ibc_cltCLT_ID: TIntegerField;
    ibc_tva: TIBQuery;
    Qmax: TIBQuery;
    QUE_gt: TIBQuery;
    QUE_gtTGF_ID: TIntegerField;
    IBQue_chrono: TIBQuery;
    IBQue_chronoNEWNUM: TIBStringField;
    T_GTF: TIBTable;
    T_GTFGTF_ID: TIntegerField;
    T_GTFGTF_IDREF: TIntegerField;
    T_GTFGTF_NOM: TIBStringField;
    T_GTFGTF_TGTID: TIntegerField;
    T_GTFGTF_ORDREAFF: TFloatField;
    T_GTFGTF_IMPORT: TIntegerField;
    T_statut: TIBTable;
    T_statutSTA_ID: TIntegerField;
    T_statutSTA_NOM: TIBStringField;
    T_statutSTA_DISPOLOC: TIntegerField;
    Qry: TIBQuery;
    T_Typgt: TIBTable;
    T_TypgtTGT_ID: TIntegerField;
    T_TypgtTGT_NOM: TIBStringField;
    T_TypgtTGT_ORDREAFF: TFloatField;
    Que_cb: TIBQuery;
    IBStringField1: TIBStringField;
    T_artloc: TIBTable;
    T_artlocARL_ID: TIntegerField;
    T_artlocARL_ARLID: TIntegerField;
    T_artlocARL_STAID: TIntegerField;
    T_artlocARL_MRKID: TIntegerField;
    T_artlocARL_TGFID: TIntegerField;
    T_artlocARL_CALID: TIntegerField;
    T_artlocARL_CDVID: TIntegerField;
    T_artlocARL_TKEID: TIntegerField;
    T_artlocARL_ICLID1: TIntegerField;
    T_artlocARL_ICLID2: TIntegerField;
    T_artlocARL_ICLID3: TIntegerField;
    T_artlocARL_ICLID4: TIntegerField;
    T_artlocARL_ICLID5: TIntegerField;
    T_artlocARL_CHRONO: TIBStringField;
    T_artlocARL_NOM: TIBStringField;
    T_artlocARL_DESCRIPTION: TIBStringField;
    T_artlocARL_NUMSERIE: TIBStringField;
    T_artlocARL_COMENT: TIBStringField;
    T_artlocARL_SESSALOMON: TIntegerField;
    T_artlocARL_DATEACHAT: TDateTimeField;
    T_artlocARL_PRIXACHAT: TFloatField;
    T_artlocARL_PRIXVENTE: TFloatField;
    T_artlocARL_DATECESSION: TDateTimeField;
    T_artlocARL_PRIXCESSION: TFloatField;
    T_artlocARL_DUREEAMT: TIntegerField;
    T_artlocARL_SOMMEAMT: TFloatField;
    T_artlocARL_ARCHIVER: TIntegerField;
    T_artlocARL_VIRTUEL: TIntegerField;
    T_artlocARL_REFMRK: TIBStringField;
    T_artlocARL_TVATAUX: TFloatField;
    T_artlocARL_LOUEAUFOURN: TIntegerField;
    T_artlocARL_PROPRIOMAGID: TIntegerField;
    T_artlocARL_LOCALIMAGID: TIntegerField;
    T_Marque: TIBTable;
    T_MarqueMRK_ID: TIntegerField;
    T_MarqueMRK_IDREF: TIntegerField;
    T_MarqueMRK_NOM: TIBStringField;
    T_MarqueMRK_CONDITION: TIBStringField;
    T_MarqueMRK_CODE: TIBStringField;
    T_Categ: TIBTable;
    T_CategCAL_ID: TIntegerField;
    T_CategCAL_TCAID: TIntegerField;
    T_CategCAL_NOM: TIBStringField;
    T_CategCAL_DESCRIPTION: TIBStringField;
    T_CategCAL_BATON: TIntegerField;
    T_CategCAL_REGLAGE: TIntegerField;
    T_CategCAL_DUREEAMT: TIntegerField;
    T_CategCAL_GTFID: TIntegerField;
    T_CategCAL_GARJOUR: TFloatField;
    T_CategCAL_GARFORF: TFloatField;
    T_CategCAL_GARSAIS: TFloatField;
    T_CategCAL_FLAGASS: TIntegerField;
    que_idprinc: TIBQuery;
    que_idprincCBI_ARLID: TIntegerField;
    T_prd: TIBTable;
    T_prdPRD_ID: TIntegerField;
    T_prdPRD_NOM: TIBStringField;
    T_prdPRD_DESCRIPTION: TIBStringField;
    T_prdPRD_CAUTION: TFloatField;
    T_prdPRD_COMID: TIntegerField;
    T_prdPRD_MAGASIN: TIntegerField;
    T_prdPRD_RAPIDO: TIBStringField;
    T_prdPRD_CHRONO: TIBStringField;
    T_session: TIBTable;
    T_sessionSES_ID: TIntegerField;
    T_sessionSES_POSID: TIntegerField;
    T_sessionSES_NUMERO: TIBStringField;
    T_sessionSES_DEBUT: TDateTimeField;
    T_sessionSES_FIN: TDateTimeField;
    T_sessionSES_CAISOUV: TIBStringField;
    T_sessionSES_CAISFIN: TIBStringField;
    T_sessionSES_NBTKT: TIntegerField;
    T_sessionSES_ETAT: TIntegerField;
    memd_loc: TdxMemData;
    memd_locCODE: TStringField;
    memd_locLIBELLE: TStringField;
    memd_locREFMARQUE: TStringField;
    memd_locNUMSERIE: TStringField;
    memd_locCATEGORIE: TStringField;
    memd_locCOMMENTAIRE: TStringField;
    memd_locMARQUE: TStringField;
    memd_locGRILLETAILLE: TStringField;
    memd_locTAILLE: TStringField;
    memd_locCB1: TStringField;
    memd_locCB2: TStringField;
    memd_locCB3: TStringField;
    memd_locCB4: TStringField;
    memd_locSTATUT: TStringField;
    memd_locDATEACHAT: TStringField;
    memd_locPRIXACHAT: TStringField;
    memd_locPRIXVENTE: TStringField;
    memd_locDATECESSION: TStringField;
    memd_locPRIXCESSION: TStringField;
    memd_locDUREEAMT: TStringField;
    memd_locSOUSFICHE: TStringField;
    memd_locSFCODE: TStringField;
    memd_locRESULTAT: TStringField;
    memd_histo: TdxMemData;
    memd_histoCLIENT: TStringField;
    memd_histoDATE: TStringField;
    memd_histoCODE: TStringField;
    memd_histoCATEGORIE: TStringField;
    memd_histoBRUT: TFloatField;
    memd_histoNET: TFloatField;
    memd_histoGARANTIE: TFloatField;
    memd_histoNBJ: TFloatField;
    OD_Base: TOpenDialog;
    ODI: TOpenDialog;
    memd_marque: TdxMemData;
    memd_marqueCODE: TStringField;
    memd_marqueLIBELLE: TStringField;
    memd_marqueCODECENTRALE: TStringField;
    memd_marqueFLAG: TStringField;
    memd_marqueNBMODELE: TStringField;
    memd_locDESCRIPTION: TStringField;
    memd_locARCHIVER: TStringField;
    memd_locLOUEAUFOURN: TStringField;
    memd_locDATEFAB: TStringField;
    memd_locDUREEVIE: TStringField;
    memd_locCHRONO: TStringField;
    memd_locCLASSEMENT1: TStringField;
    memd_locCLASSEMENT2: TStringField;
    memd_locCLASSEMENT3: TStringField;
    memd_locCLASSEMENT4: TStringField;
    memd_locCLASSEMENT5: TStringField;
    T_artlocARL_DATEFAB: TDateTimeField;
    T_artlocARL_DUREEVIE: TIntegerField;
    Que_Select: TIBQuery;
    Que_Delete: TIBQuery;
    Que_Insert: TIBQuery;
    T_TypgtTGT_CODE: TIBStringField;
    T_TypgtTGT_CENTRALE: TIntegerField;
    T_GTFGTF_ACTIVE: TIntegerField;
    T_GTFGTF_CODE: TIBStringField;
    T_GTFGTF_CENTRALE: TIntegerField;
    StProc_PrUpdateK: TIBStoredProc;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
    UseMarque : Boolean;
    Log : TStringList;
    procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
    procedure AjouterLog(Texte:String; Err:Boolean = False);
    function Tva(fTaux : Real):Integer;
    function TypeCategorie(sNom : string):Integer;
    function ProduitTypeCategorie(iComId, iTcaId : Integer; fRat : Double):Integer;
    procedure UpdateK(iKid : Integer; iEtat : Integer);
  public
    { Déclarations publiques }
    procedure TraitementHistorique;
    procedure TraitementArticle;
    procedure CorrectionArticle;
    procedure ViderNomenclature(cDeletePhisique : Boolean);
    procedure TraitementNomenclature(cPathFile : string);
    function ConnectionBase:string;
    function ChargementArticle:string;
    function ChargementHistorique:string;
    function ChargementMarque:string;
  end;

var
  Dm_Loc: TDm_Loc;

implementation

Uses
  loc_frm;

{$R *.dfm}

{ TDm_Loc }

function TDm_Loc.ChargementArticle: string;
begin
  Result := '';
  try
    memd_loc.close;
    if ODI.Execute then
    begin
      try
        Result := ODI.files[0];
        memd_loc.DelimiterChar := ';';
        memd_loc.LoadFromTextFile(Result);
      finally
        ShowMessage('Chargement du fichier Article réussi.');
      end;
    end;
  except on e:Exception do
    begin
      ShowMessage('Problème au chargement du fichier Article, avec le message suivant : ' + e.Message);
      Result := '';
    end;
  end;
end;

function TDm_Loc.ChargementHistorique: string;
begin
  Result := '';
  try
    memd_histo.close;
    if ODI.Execute then
    begin
      try
        Result := ODI.files[0];
        memd_histo.DelimiterChar := ';';
        memd_histo.LoadFromTextFile(Result);
      finally
        ShowMessage('Chargement du fichier Historique réussi.');
      end;
    end;
  except on e:Exception do
    begin
      ShowMessage('Problème au chargement du fichier Historique, avec le message suivant : ' + e.Message);
      Result := '';
    end;
  end;
end;

function TDm_Loc.ChargementMarque: string;
begin
  Result := '';
  UseMarque := False;
  try
    memd_marque.close;
    if ODI.Execute then
    begin
      try
        Result := ODI.files[0];
        memd_marque.DelimiterChar := ';';
        memd_marque.LoadFromTextFile(Result);
      finally
        ShowMessage('Chargement du fichier Marque réussi.');
        UseMarque := True;
      end;
    end;
  except on e:Exception do
    begin
      ShowMessage('Problème au chargement du fichier Marque, avec le message suivant : ' + e.Message);
      Result := '';
    end;
  end;
end;

function TDm_Loc.ConnectionBase;
begin
  Result := '';
  try
    try
      if OD_Base.Execute then
      begin
        Result := OD_Base.files[0];
        ginkoia.close;
        ginkoia.databasename := Result;
        ginkoia.Open;

        //Ouverture de la liste des magasins
        Que_LstMag.Open;
        Que_LstMag.FetchAll;
        Que_LstMag.First;
        //Frm_Loc.Cbx_LstMag.KeyValue := Que_LstMag.FieldByName('MAG_ENSEIGNE').AsString;

        //Ouverture de la liste des magasins Proprio
        Que_LstMagProprio.Open;
        Que_LstMagProprio.FetchAll;
        Que_LstMagProprio.First;
        //Frm_Loc.Cbx_LstMagProprio.KeyValue := Que_LstMagProprioMAG_ENSEIGNE.AsString;

        //Ouverture de la liste des magasins Localisation
        Que_LstMagLocali.Open;
        Que_LstMagLocali.FetchAll;
        Que_LstMagLocali.First;
        //Frm_Loc.Cbx_LstMagLocali.KeyValue := Que_LstMagLocaliMAG_ENSEIGNE.AsString;
      end;
    finally
      ShowMessage('Connexion de la base de données réussie.');
    end;
  except on e:Exception do
    begin
      ShowMessage('Problème à la connexion de la base de données, avec le message suivant : ' + e.Message);
      Result := '';
    end;
  end;
end;

procedure TDm_Loc.CorrectionArticle;
VAR
  id,
  arl_id   : Integer;    //Id pour affectation du magasin au classement
  Log     : TstringList;
BEGIN
  try
    Log := TStringList.Create;

    t_marque.open;
    t_categ.open;
    t_statut.open;
    t_artloc.Open;

    Frm_Loc.Prgb_Iec.Max := memd_loc.RecordCount;
    Frm_Loc.Prgb_Iec.Position := 0;
    memd_loc.first;
    WHILE NOT memd_loc.eof DO
    BEGIN
      Log.Add(memd_locCODE.AsString + ' - ' +memd_locLIBELLE.AsString);
      Log.SaveToFile(ExtractFilePath(Application.Name) + 'Import.Log');
      Frm_Loc.PrgB_IEC.StepBy(1);

      //Recherche de la catégorie


      IF NOT t_categ.locate('cal_nom', memd_locCATEGORIE.asstring, []) THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCCATEGORIE'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;

        T_categ.insert;
        T_CategCAL_ID.asinteger         := id;
        T_CategCAL_TCAID.asinteger      := 0;
        T_CategCAL_NOM.asstring         := memd_locCATEGORIE.asstring;
        T_CategCAL_DESCRIPTION.asstring := '';
        T_CategCAL_BATON.asinteger      := 0;
        T_CategCAL_REGLAGE.AsInteger    := 0;
        T_CategCAL_DUREEAMT.asinteger   := 0;
        T_CategCAL_GTFID.asinteger      := 0;
        T_CategCAL_GARJOUR.asfloat      := 0;
        T_CategCAL_GARFORF.asfloat      := 0;
        T_CategCAL_GARSAIS.asfloat      := 0;
        T_CategCAL_FLAGASS.asinteger    := 0;
        T_categ.post;
        //tran.commit;
        //tran.active:=true;
      END;

      Qry.Close;
      Qry.SQL.Text := 'Select arl_id from locarticle ' +
                      'join k on (k_id = arl_id and K_Enabled = 1) ' +
                      'join artcodebarre on (ARL_ID = CBI_ARLID AND CBI_TYPE = 4) ' +
                      'where (CBI_CB = :CB2) ' +
                      'Group by arl_id';
      Qry.ParamByName('CB2').asstring := memd_locCODE.AsString;
      Qry.Open;

      if Qry.RecordCount > 1 then
      begin
        Qry.Close;
        Qry.SQL.Text := 'Select arl_id from locarticle ' +
                        'join k on (k_id = arl_id and K_Enabled = 1) ' +
                        'join artcodebarre on (ARL_ID = CBI_ARLID AND CBI_TYPE = 4) ' +
                        'where (CBI_CB = :CB1 OR CBI_CB = :CB2) ' +
                        'Group by arl_id';
        Qry.ParamByName('CB1').asstring := memd_locCB1.AsString;
        Qry.ParamByName('CB2').asstring := memd_locCODE.AsString;
        Qry.Open;
      end;

      arl_id := qry.Fields[0].Asinteger;

      Qry.Close;
      Qry.SQL.Text:= 'Update locarticle set ARL_CALID = ' + IntToStr(T_CategCAL_ID.AsInteger) + ' where ARL_ID = ' + IntToStr(arl_id);
      Qry.ExecSQL;
      Qry.Close;
      Qry.SQL.Text:= 'Update locarticle set ARL_COMENT = ''' + memd_locCOMMENTAIRE.AsString + ''' where ARL_ID = ' + IntToStr(arl_id);
      Qry.ExecSQL;
      Qry.Close;
      Qry.SQL.Text  := 'Execute Procedure PR_updatek(' + IntToStr(arl_id) +',0)';
      Qry.ExecSQL;

      memd_loc.Next;
    END;
    tran.commit;
    memd_loc.SaveToTextFile(Frm_Loc.edArticle.Text);
    ShowMessage('Traitement (Articles) terminé');
  except on e: Exception do
    ShowMessage('Erreur dans le traitement avec le message :' + e.Message);
  end;
end;

procedure TDm_Loc.DataModuleCreate(Sender: TObject);
begin
  UseMarque := False;
  Log := TStringList.Create;
end;

procedure TDm_Loc.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(Log);
end;

function TDm_Loc.ProduitTypeCategorie(iComId, iTcaId: Integer;
  fRat: Double): Integer;
begin
  try
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT TYC_ID, K_ENABLED FROM LOCPRODUITTYPECATEG JOIN K ON (K_ID = TYC_ID) WHERE TYC_COMID = :TYCCOMID AND TYC_TCAID = :TYCTCAID AND TYC_ID <> 0 ORDER BY K_ENABLED DESC';
    Que_Select.ParamByName('TYCCOMID').AsInteger := iComId;
    Que_Select.ParamByName('TYCTCAID').AsInteger := iTcaId;
    Que_Select.Open;
    if Que_Select.Eof then
    begin
      Que_Select.Close;
      Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCPRODUITTYPECATEG') + ')';
      Que_Select.Open;
      Result := Que_Select.FieldByName('ID').AsInteger;

      Que_Insert.SQL.Text := 'INSERT INTO LOCPRODUITTYPECATEG (TYC_ID, TYC_COMID, TYC_TCAID, TYC_RAT) ' +
                            'VALUES (:TYCID, :TYCCOMID, :TYCTCAID, :TYCRAT)';
      Que_Insert.ParamByName('TYCID').AsInteger := Result;
      Que_Insert.ParamByName('TYCCOMID').AsInteger := iComId;
      Que_Insert.ParamByName('TYCTCAID').AsInteger := iTcaId;
      Que_Insert.ParamByName('TYCRAT').AsFloat := fRat;
      Que_Insert.ExecSQL;
    end
    else
    begin
      Result := Que_Select.FieldByName('TYC_ID').AsInteger;
      if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
        UpdateK(Result, cPrUpdateK_Act);
    end;
  except on e: Exception do
    begin
      Result := -1;
      ShowMessage('Erreur dans le traitement des ProduitTypeCategorie avec le message :' + e.Message);
    end;
  end;
end;

procedure TDm_Loc.TraitementArticle;
VAR
  id,
  arl_id,
  tgtid,
  gtfid,
  tgfid   : Integer;    //Id pour affectation du magasin au classement
  Log     : TstringList;

  function GetICLID(iNum:Integer;sICL_NOM:string):Integer;
  var
    iCLAID,
    iICLID,
    iCITID : Integer;
  begin
    //Recherche de l'id du classement
    Qry.Close;
    Qry.SQL.Text := 'SELECT CLA_ID ' +
                    'FROM ARTCLASSEMENT ' +
                    'JOIN K ON K_ID=CLA_ID AND K_ENABLED=1 ' +
                    'WHERE CLA_NUM = ' + IntToStr(iNum) + ' ' +
                    'AND CLA_TYPE = ''LOC''';
    Qry.open;
    Qry.First;
    iCLAID := Qry.FieldByName('CLA_ID').AsInteger;
    Qry.Close;

    //Recherche et création de la valeur du classement
    Qry.SQL.Text := 'SELECT ICL_ID ' +
                    'FROM ARTITEMC ' +
                    'JOIN K ON K_ID=ICL_ID AND K_ENABLED=1 ' +
                    'WHERE ICL_NOM = ''' + sICL_NOM + ''' ' +
                    'AND ICL_ID <> 0';
    Qry.Open;
    Qry.First;
    if Qry.RecordCount<1 then
    begin
      Qry.close;
      Qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
      Qry.Open;
      iICLID := qry.Fields[0].Asinteger;
      Qry.Close;
      Qry.SQL.Text := 'INSERT INTO ARTITEMC(ICL_ID,ICL_NOM) VALUES (' + IntTostr(iICLID) + ',''' + sICL_NOM + ''')';
      Qry.ExecSQL;
    end
    else begin
      iICLID := Qry.FieldByName('ICL_ID').AsInteger;
    end;

    //Affectation de la valeur au classement
    Qry.Close;
    Qry.SQL.Text := 'SELECT CIT_ID ' +
                    'FROM ARTCLAITEM ' +
                    'JOIN K ON K_ID=CIT_ID AND K_ENABLED=1 ' +
                    'WHERE CIT_CLAID = ' + IntToStr(iCLAID) + ' ' +
                    'AND CIT_ICLID = ' + IntToStr(iICLID) + ' ' +
                    'AND CIT_ID<>0';
    Qry.Open;
    Qry.First;
    if Qry.RecordCount<1 then
    begin
      Qry.Close;
      Qry.SQL.Text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
      Qry.Open;
      iCITID := Qry.Fields[0].Asinteger;
      Qry.Close;
      Qry.SQL.Text := 'INSERT INTO ARTCLAITEM(CIT_ID,CIT_CLAID,CIT_ICLID) VALUES (' + IntTostr(iCITID) + ',' + IntTostr(iCLAID) + ',' + IntTostr(iICLID) + ')';
      Qry.ExecSQL;
    end;

    Result := iICLID;
  end;
BEGIN
  try
    Log := TStringList.Create;
    tgtid := 0;
    //tran.StartTransaction;
    t_marque.open;
    t_categ.open;
    t_statut.open;
    t_artloc.Open;

    Frm_Loc.Prgb_Iec.Max := memd_loc.RecordCount;
    Frm_Loc.Prgb_Iec.Position := 0;
    memd_loc.first;
    WHILE NOT memd_loc.eof DO
    BEGIN
      Log.Add(memd_locCODE.AsString + ' - ' +memd_locLIBELLE.AsString);
      Log.SaveToFile(ExtractFilePath(Application.Name) + 'Import.Log');
      Frm_Loc.PrgB_IEC.StepBy(1);

      //Recherche de la marque
      if UseMarque then
      begin
        if memd_marque.Locate('LIBELLE', memd_locMARQUE.asstring,[]) then
        begin
          if not t_marque.locate('mrk_code', memd_marqueCODECENTRALE.asstring, []) then
            ShowMessage('Marque non trouvé dans la base : "' + memd_locMARQUE.asstring + '" - CodeCentrale : "' + memd_marqueCODECENTRALE.asstring + '"');
        end
        else
          ShowMessage('Marque non trouvé dans le fichier : "' + memd_locMARQUE.asstring + '"');
      end
      else
      begin
        IF NOT t_marque.locate('mrk_nom', memd_locMARQUE.asstring, []) THEN
        BEGIN
          qry.close;
          qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTMARQUE'')';
          qry.Open;
          id := qry.Fields[0].Asinteger;

          t_marque.insert;
          T_MarqueMRK_ID.asinteger := id;
          T_MarqueMRK_IDREF.asinteger := 0;
          T_MarqueMRK_NOM.asstring := memd_locMARQUE.asstring;
          T_MarqueMRK_CONDITION.asstring := '';
          T_MarqueMRK_CODE.asstring := '';
          t_marque.post;
          //tran.commit;
        END;
      end;

      //Recherche de la catégorie
      IF NOT t_categ.locate('cal_nom', memd_locCATEGORIE.asstring, []) THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCCATEGORIE'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;

        T_categ.insert;
        T_CategCAL_ID.asinteger         := id;
        T_CategCAL_TCAID.asinteger      := 0;
        T_CategCAL_NOM.asstring         := memd_locCATEGORIE.asstring;
        T_CategCAL_DESCRIPTION.asstring := '';
        T_CategCAL_BATON.asinteger      := 0;
        T_CategCAL_REGLAGE.AsInteger    := 0;
        T_CategCAL_DUREEAMT.asinteger   := 0;
        T_CategCAL_GTFID.asinteger      := 0;
        T_CategCAL_GARJOUR.asfloat      := 0;
        T_CategCAL_GARFORF.asfloat      := 0;
        T_CategCAL_GARSAIS.asfloat      := 0;
        T_CategCAL_FLAGASS.asinteger    := 0;
        T_categ.post;
        //tran.commit;
        //tran.active:=true;
      END;

      //Recherche du statut
      IF NOT t_statut.locate('sta_nom', memd_locSTATUT.asstring, []) THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCSTATUT'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;
        t_statut.Insert;
        T_statutSTA_ID.asinteger := id;
        T_statutSTA_NOM.asstring := memd_locSTATUT.asstring;
        T_statutSTA_DISPOLOC.AsInteger := 1;
        t_statut.Post;
        //tran.commit;
        //tran.active:=true;
      END;

      //Insertion dans la table
      qry.close;
      qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCARTICLE'')';
      qry.Open;
      arl_id := qry.Fields[0].Asinteger;

      t_artloc.Insert;
      T_artlocARL_ID.asinteger := arl_id;

//      que_idprinc.close;
//      que_idprinc.ParamByName('CODE').asstring := memd_locCODE.asstring;
//      que_idprinc.open;
//      IF NOT que_idprinc.eof THEN
//      BEGIN
//        //C'est une sous fiche on recherche l'id. de la fiche principale
//        T_artlocARL_ARLID.asinteger := que_idprincCBI_ARLID.asinteger;
//      END
//      else
//        T_artlocARL_ARLID.asinteger := arl_id; //Fiche Principale

      IF memd_locSOUSFICHE.asstring = 'N' THEN
      BEGIN
        T_artlocARL_ARLID.asinteger := arl_id; //Fiche Principale
      END
      ELSE
      BEGIN
        //C'est une sous fiche on recherche l'id. de la fiche principale
        que_idprinc.close;
        que_idprinc.ParamByName('CODE').asstring := memd_locSFCODE.asstring;
        que_idprinc.open;
        IF NOT que_idprinc.eof THEN
        BEGIN
          //C'est une sous fiche on recherche l'id. de la fiche principale
          T_artlocARL_ARLID.asinteger := que_idprincCBI_ARLID.asinteger;
        END
        ELSE
          if Frm_Loc.Chk_SSFiche.Checked = False then
            T_artlocARL_ARLID.asinteger := arl_id   //ça devient une fiche Principale
          else
            T_artlocARL_ARLID.asinteger := 0;
      END;

      T_artlocARL_STAID.asinteger := T_statutSTA_ID.asinteger;
      T_artlocARL_MRKID.asinteger := T_MarqueMRK_ID.asinteger;
      T_artlocARL_COMENT.asstring := memd_locCOMMENTAIRE.asstring;

      //Gestion de la grille de taille suivant la categorie
      if Frm_Loc.Cbx_GrilleTaille.Checked then
      begin
        memd_loc.Edit;
        memd_locGRILLETAILLE.asstring := memd_locCATEGORIE.AsString;
        memd_loc.Post;

        que_gt.Close;
        que_gt.SQL.Text := 'select tgf_id from plxtaillesgf ' +
                           'join plxgtf on gtf_id=tgf_gtfid ' +
                           'join plxtypegt on tgt_id=gtf_tgtid ' +
                           'where tgf_nom=:taille and gtf_nom=:GT and tgt_nom=:TGTNOM';
      end;

      //Recherche de la taille
      que_gt.close;
      que_gt.parambyname('GT').asstring := memd_locGRILLETAILLE.asstring;
      que_gt.parambyname('TAILLE').asstring := memd_locTAILLE.asstring;
      if Frm_Loc.Cbx_GrilleTaille.Checked then
      begin
        que_gt.parambyname('TGTNOM').asstring := 'IMPORT LOCATION';
      end;
      que_gt.open;
      IF NOT que_gt.eof THEN
        T_artlocARL_TGFID.asinteger := QUE_gtTGF_ID.asinteger
      ELSE
      BEGIN
        //Tailles pas trouvée
        IF (QUE_gt.parambyname('GT').asstring <> '') AND (que_gt.parambyname('TAILLE').asstring <> '') THEN
        BEGIN
          //Les info sur les tailles ne sont pas vides on va donc créé la taille
          // - Type
          // - Entete
          // - Ligne

          //Type de GT
          IF tgtid = 0 THEN
          BEGIN // Il faut creer le type de GT
            //SR - 09/11/2016 - Correction pour ne pas recrer si déjà existant
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT TGT_ID FROM PLXTYPEGT WHERE UPPER(TGT_NOM) = UPPER(:TGTNOM) AND TGT_ID <> 0';
            Que_Select.ParamByName('TGTNOM').AsString := 'IMPORT LOCATION';
            Que_Select.Open;

            if Que_Select.Eof then    //SR - Si non trouvé on créer le type
            begin
              Qmax.close;
              Qmax.SQL.Text := 'select max(tgt_ordreaff)+10 from plxtypegt';
              Qmax.open;

              Qry.close;
              Qry.sql.text := 'SELECT ID FROM PR_NEWK (''PLXTYPEGT'')';
              Qry.Open;
              tgtid := Qry.Fields[0].Asinteger;

              T_Typgt.Open;
              T_Typgt.Insert;
              T_TypgtTGT_ID.AsInteger := tgtid;
              T_TypgtTGT_NOM.AsString := 'IMPORT LOCATION';
              T_TypgtTGT_ORDREAFF.AsFloat := Qmax.Fields[0].AsFloat;
              T_TypgtTGT_CODE.AsString := '';
              T_TypgtTGT_CENTRALE.AsInteger := 0;
              T_Typgt.Post;
            end
            else
              tgtid := Que_Select.FieldByName('TGT_ID').AsInteger;
          end;

          //Entete GT
          T_GTF.open;
          if ((not Frm_Loc.Cbx_GrilleTaille.Checked) and (not T_GTF.Locate('GTF_NOM',memd_locGRILLETAILLE.asstring,[]))) or
             ((Frm_Loc.Cbx_GrilleTaille.Checked) and (not T_GTF.Locate('GTF_TGTID;GTF_NOM',VarArrayOf([tgtid,memd_locGRILLETAILLE.asstring]),[]))) then
          begin
            Qmax.close;
            Qmax.SQL.Text := 'select max(gtf_ordreaff)+10 from plxgtf where gtf_id <> 0 and gtf_tgtid = :gtftgtid';
            Qmax.ParamByName('gtftgtid').AsInteger:=tgtid;
            Qmax.open;

            qry.close;
            qry.sql.text := 'SELECT ID FROM PR_NEWK (''PLXGTF'')';
            qry.Open;
            GTFID := qry.Fields[0].Asinteger;

            T_GTF.Insert;
            T_GTFGTF_ID.AsInteger:=GTFID;
            T_GTFGTF_IDREF.AsInteger:=0;
            T_GTFGTF_NOM.AsString:=memd_locGRILLETAILLE.AsString;
            T_GTFGTF_TGTID.AsInteger:=tgtid;
            T_GTFGTF_ORDREAFF.AsFloat := qmax.Fields[0].AsFloat;
            T_GTFGTF_IMPORT.AsInteger:=0;
            T_GTFGTF_ACTIVE.AsInteger := 1;
            T_GTFGTF_CODE.AsString := '';
            T_GTFGTF_CENTRALE.AsInteger := 0;
            T_GTF.post;
          end
          else
            gtfid:=T_GTFGTF_ID.AsInteger;

          //Lignes de la GT
          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT TGF_ID FROM PLXTAILLESGF WHERE TGF_GTFID=:TGFGTFID AND  TGF_NOM=:TGFNOM AND TGF_ID <> 0';
          Que_Select.ParamByName('TGFGTFID').AsInteger:=gtfid;
          Que_Select.ParamByName('TGFNOM').AsString:=memd_locTAILLE.AsString;
          Que_Select.Open;

          if Que_Select.eof then
          begin
            qmax.close;
            qmax.SQL.Text := 'select max(tgf_ordreaff)+10 from plxtaillesgf where tgf_id <> 0 and tgf_gtfid = :tgfgtfid';
            Qmax.ParamByName('tgfgtfid').AsInteger:=gtfid;
            qmax.open;

            qry.close;
            qry.sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESGF'')';
            qry.Open;
            tgfid := qry.Fields[0].Asinteger;

            Que_Insert.close;
            Que_Insert.SQL.Text := 'INSERT INTO PLXTAILLESGF ' +
              '(TGF_ID,TGF_GTFID,TGF_IDREF,TGF_TGFID,TGF_NOM,TGF_CORRES,TGF_ORDREAFF,TGF_STAT,TGF_TGSID,TGF_ACTIVE,TGF_CODE,TGF_COLUMNX,TGF_CENTRALE) ' +
              'VALUES (:TGFID,:TGFGTFID,:TGFIDREF,:TGFTGFID,:TGFNOM,:TGFCORRES,:TGFORDREAFF,:TGFSTAT,:TGFTGSID,:TGFACTIVE,:TGFCODE,:TGFCOLUMNX,:TGFCENTRALE)';
            Que_Insert.ParamByName('TGFID').AsInteger := tgfid;
            Que_Insert.ParamByName('TGFGTFID').AsInteger := gtfid;
            Que_Insert.ParamByName('TGFIDREF').AsInteger := 0;
            Que_Insert.ParamByName('TGFTGFID').AsInteger := tgfid;
            Que_Insert.ParamByName('TGFNOM').AsString := memd_locTAILLE.AsString;
            Que_Insert.ParamByName('TGFCORRES').AsString := '';
            Que_Insert.ParamByName('TGFORDREAFF').AsFloat := Qmax.Fields[0].AsFloat;
            Que_Insert.ParamByName('TGFSTAT').AsInteger := 1;
            Que_Insert.ParamByName('TGFTGSID').AsInteger := 0;
            Que_Insert.ParamByName('TGFACTIVE').AsInteger := 1;
            Que_Insert.ParamByName('TGFCODE').AsString := '';
            Que_Insert.ParamByName('TGFCOLUMNX').AsString := '';
            Que_Insert.ParamByName('TGFCENTRALE').AsInteger := 0;
            Que_Insert.ExecSQL;
          end
          else
            tgfid:=Que_Select.FieldByName('TGF_ID').AsInteger;

          T_artlocARL_TGFID.asinteger:=tgfid;
        END
        ELSE
        BEGIN //On a pas toutes les infos pour crééer proprement les tailles, on ajoute dans le commentaire
          T_artlocARL_TGFID.asinteger := 0;
          IF T_artlocARL_COMENT.asstring <> '' THEN
            T_artlocARL_COMENT.asstring := T_artlocARL_COMENT.asstring + #13 + #10 + 'Taille : ' + memd_locTAILLE.asstring
          ELSE
            T_artlocARL_COMENT.asstring := 'Taille : ' + memd_locTAILLE.asstring;
        END;

      END;

      T_artlocARL_CALID.asinteger := T_CategCAL_ID.asinteger;
      T_artlocARL_CDVID.asinteger := 0;
      T_artlocARL_TKEID.asinteger := 0;

      if memd_locCLASSEMENT1.AsString <> '' then
        T_artlocARL_ICLID1.asinteger := GetICLID(1,memd_locCLASSEMENT1.AsString)
      else
        T_artlocARL_ICLID1.asinteger := 0;

      if memd_locCLASSEMENT2.AsString <> '' then
        T_artlocARL_ICLID2.asinteger := GetICLID(2,memd_locCLASSEMENT2.AsString)
      else
        T_artlocARL_ICLID2.asinteger := 0;

      if memd_locCLASSEMENT3.AsString <> '' then
        T_artlocARL_ICLID3.asinteger := GetICLID(3,memd_locCLASSEMENT3.AsString)
      else
        T_artlocARL_ICLID3.asinteger := 0;

      if memd_locCLASSEMENT4.AsString <> '' then
        T_artlocARL_ICLID4.asinteger := GetICLID(4,memd_locCLASSEMENT4.AsString)
      else
        T_artlocARL_ICLID4.asinteger := 0;

      if memd_locCLASSEMENT5.AsString <> '' then
        T_artlocARL_ICLID5.asinteger := GetICLID(5,memd_locCLASSEMENT5.AsString)
      else
        T_artlocARL_ICLID5.asinteger := 0;

      ibque_chrono.Close;
      ibque_chrono.Open;

      if memd_locCHRONO.asstring = '' then
        T_artlocARL_CHRONO.asstring := IBQue_chronoNEWNUM.asstring
      else
        T_artlocARL_CHRONO.asstring := memd_locCHRONO.asstring;

      T_artlocARL_NOM.asstring := memd_locLIBELLE.asstring;
      T_artlocARL_DESCRIPTION.asstring := memd_locDESCRIPTION.asstring;
      T_artlocARL_NUMSERIE.asstring := memd_locNUMSERIE.asstring;

      T_artlocARL_SESSALOMON.asinteger := 0;

      if memd_locDATEACHAT.AsString<>'' then
            T_artlocARL_DATEACHAT.asdateTime := strtodate(memd_locDATEACHAT.AsString)
      else
        T_artlocARL_DATEACHAT.asfloat:=0;

      if memd_locPRIXACHAT.AsString<>'' then
        T_artlocARL_PRIXACHAT.asfloat := memd_locPRIXACHAT.Asfloat;

      if memd_locPRIXVENTE.AsString<>'' then
        T_artlocARL_PRIXVENTE.asfloat := memd_locPRIXVENTE.asfloat;

      IF memd_locDATECESSION.AsString <> '' THEN
      BEGIN
        T_artlocARL_DATECESSION.asdateTime := strtodate(memd_locDATECESSION.AsString);
      END;


      IF memd_locPRIXCESSION.asstring <> '' THEN
        T_artlocARL_PRIXCESSION.asfloat := memd_locPRIXCESSION.asfloat
      ELSE
        T_artlocARL_PRIXCESSION.asfloat := 0;

      IF memd_locDUREEAMT.asstring <> '' THEN
        T_artlocARL_DUREEAMT.asinteger := memd_locDUREEAMT.asinteger;

      T_artlocARL_SOMMEAMT.asfloat := 0;

      IF memd_locARCHIVER.asstring <> '' THEN
        T_artlocARL_ARCHIVER.asinteger := memd_locARCHIVER.asinteger
      else
        T_artlocARL_ARCHIVER.asinteger := 0;    //SR - 22/10/2015 - Si je n'ai pas l'information je ne créé pas archivé.

      T_artlocARL_VIRTUEL.asinteger := 0;

      T_artlocARL_REFMRK.asstring := memd_locREFMARQUE.asstring;

      T_artlocARL_TVATAUX.asfloat := 0;

      IF memd_locLOUEAUFOURN.asstring <> '' THEN
        T_artlocARL_LOUEAUFOURN.asinteger := memd_locLOUEAUFOURN.asinteger;

      if memd_locDATEFAB.AsString<>'' then
        T_artlocARL_DATEFAB.asdateTime := strtodate(memd_locDATEFAB.AsString)
      else
        T_artlocARL_DATEFAB.asfloat:=0;

      IF memd_locDUREEVIE.asstring <> '' THEN
        T_artlocARL_DUREEVIE.asinteger := memd_locDUREEVIE.asinteger;

      T_artlocARL_PROPRIOMAGID.AsInteger := Que_LstMagProprioMAG_ID.AsInteger;
      T_artlocARL_LOCALIMAGID.AsInteger := Que_LstMagLocaliMAG_ID.AsInteger;

      //Rapport
      memd_loc.Edit;
      IF T_artlocARL_TGFID.asinteger = 0 THEN
        memd_locRESULTAT.ASSTRING := 'Taille non créé'
      ELSE
        memd_locRESULTAT.asstring := 'OK';
      memd_loc.Post;

      t_artloc.post;
      //tran.active:=true;

      //Les codes Code + 4 cb
      qry.close;
      qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
      qry.Open;
      id := qry.Fields[0].Asinteger;
      que_cb.close;
      que_cb.parambyname('cbi_id').asinteger := id;
      que_cb.parambyname('cbi_arlid').asinteger := arl_id;
      que_cb.parambyname('cbi_cb').asstring := memd_locCODE.asstring;
      que_cb.parambyname('cbi_loc').asinteger:=1;
      que_cb.ExecSQL;
      //tran.active:=true;

      IF ((memd_locCB1.asstring <> '') AND (memd_locCB1.asstring <> memd_locCODE.asstring)) THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;
        que_cb.close;
        que_cb.parambyname('cbi_id').asinteger := id;
        que_cb.parambyname('cbi_arlid').asinteger := arl_id;
        que_cb.parambyname('cbi_cb').asstring := memd_locCB1.asstring;
        que_cb.parambyname('cbi_loc').asinteger:=0;
        que_cb.ExecSQL;
        //tran.active:=true;
      END;

      IF memd_locCB2.asstring <> '' THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;
        que_cb.close;
        que_cb.parambyname('cbi_id').asinteger := id;
        que_cb.parambyname('cbi_arlid').asinteger := arl_id;
        que_cb.parambyname('cbi_cb').asstring := memd_locCB2.asstring;
        que_cb.parambyname('cbi_loc').asinteger:=0;
        que_cb.ExecSQL;
        //tran.active:=true;
      END;

      IF memd_locCB3.asstring <> '' THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;
        que_cb.close;
        que_cb.parambyname('cbi_id').asinteger := id;
        que_cb.parambyname('cbi_arlid').asinteger := arl_id;
        que_cb.parambyname('cbi_cb').asstring := memd_locCB3.asstring;
        que_cb.parambyname('cbi_loc').asinteger:=0;
        que_cb.ExecSQL;
        //tran.active:=true;
      END;

      IF memd_locCB4.asstring <> '' THEN
      BEGIN
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
        qry.Open;
        id := qry.Fields[0].Asinteger;
        que_cb.close;
        que_cb.parambyname('cbi_id').asinteger := id;
        que_cb.parambyname('cbi_arlid').asinteger := arl_id;
        que_cb.parambyname('cbi_cb').asstring := memd_locCB4.asstring;
        que_cb.parambyname('cbi_loc').asinteger:=0;
        que_cb.ExecSQL;
        //tran.active:=true;
      END;

      memd_loc.Next;
    END;
    tran.commit;
    memd_loc.SaveToTextFile(Frm_Loc.edArticle.Text);
    ShowMessage('Traitement (Articles) terminé');
  except on e: Exception do
    ShowMessage('Erreur dans le traitement avec le message :' + e.Message);
  end;
end;

procedure TDm_Loc.TraitementHistorique;
VAR
  //nbart   : Integer;
  //ktb_TK  : string;
  //ktb_loc : string;
  //ktb_loa : string;
  id_tk,
  id_loc,
  id_loa,
  clt,
  dat,
  libcat  : string;
  id,
  tvaid,
  cltid,
  sesid   : Integer;
BEGIN
  clt := '';
  dat := '';

  //    ibc_ktb.close;
  //    ibc_ktb.parambyname('ktb_name').asstring := 'CSHTICKET';
  //    ibc_ktb.open;
  //    ktb_TK := ibc_ktb.fieldbyname('ktb_id').asstring;

  //    ibc_ktb.close;
  //    ibc_ktb.parambyname('ktb_name').asstring := 'LOCBONLOCATION';
  //    ibc_ktb.open;
  //    ktb_loc := ibc_ktb.fieldbyname('ktb_id').asstring;

  //    ibc_ktb.close;
  //    ibc_ktb.parambyname('ktb_name').asstring := 'LOCBONLOCATIONLIGNE';
  //    ibc_ktb.open;
  //    ktb_loa := ibc_ktb.fieldbyname('ktb_id').asstring;

  IbC_bl.Close;
  IbC_bl.SQL.Clear;
  IbC_bl.SQL.Add('insert into CSHTICKET (TKE_ID,TKE_SESID,TKE_CLTID,TKE_USRID,TKE_NUMERO,' +
    'TKE_DATE,TKE_DETAXE,TKE_CAISSIER,TKE_NUM,TKE_ARCHIVE,' +
    'TKE_TOTBRUTA1,TKE_REMA1,TKE_TOTNETA1,TKE_QTEA1,' +
    'TKE_TOTBRUTA2,TKE_REMA2,TKE_TOTNETA2,TKE_QTEA2,' +
    'TKE_TOTBRUTA3,TKE_REMA3,TKE_TOTNETA3,TKE_QTEA3,' +
    'TKE_TOTBRUTA4,TKE_REMA4,TKE_TOTNETA4,TKE_QTEA4,' +
    'TKE_DIVINT,TKE_DIVFLOAT,TKE_DIVCHAR,' +
    'TKE_CHEFCLTID,TKE_CTEID) ' +
    'values (:TKE_ID,:TKE_SESID,:tke_cltid,0,:TKE_NUMERO,' +
    ':TKE_DATE,0,:TKE_CAISSIER,:TKE_NUM,1,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,:TKE_DIVCHAR,' +
    '0,0)');
  Ibc_bl.Prepare;

  IbC_loc.Close;
  IbC_loc.SQL.Clear;
  IbC_loc.SQL.Add('insert into LOCBONLOCATION (LOC_ID,LOC_NUMERO,LOC_DATE,LOC_TYPEDOC,' +
    'LOC_CLTID,LOC_TKEID,LOC_REMISE,LOC_NUM,loc_sortie,loc_retour,loc_sesid,loc_orgcltid)' +
    'values (:LOC_ID,:LOC_NUMERO,:LOC_DATE,:LOC_TYPEDOC,' +
    ':LOC_CLTID,:LOC_TKEID,:LOC_REMISE,:LOC_NUM,0,0,0,0)');
  Ibc_loc.Prepare;

  IbC_loa.Close;
  IbC_loa.SQL.Clear;
  IbC_loa.SQL.Add('insert into LOCBONLOCATIONligne (  LOA_ID ,LOA_LOCID ,LOA_ARLID ,LOA_PRDID ,' +
    'LOA_LOAID ,LOA_CLIENT ,LOA_DEBUT ,LOA_FIN ,LOA_ETAT ,' +
    'LOA_ARTICLESEUL ,LOA_TYPELIGNE ,LOA_ORDREAFF ,LOA_PXBRUT ,LOA_REMISE ,' +
    'LOA_PXNET ,LOA_ASSUR ,LOA_PXNN ,LOA_DJPPRIX , LOA_DJPASSUR ,' +
    'LOA_SORTIEREEL , LOA_REGFIX , LOA_USRID , LOA_FLAGASS , LOA_TVAID  ,' +
    ' LOA_TXTVA,loa_cltid ,loa_topxnn)' +
    'values (  :LOA_ID ,:LOA_LOCID ,:LOA_ARLID ,:LOA_PRDID ,' +
    ':LOA_LOAID ,:LOA_CLIENT ,:LOA_DEBUT ,:LOA_FIN ,:LOA_ETAT ,' +
    ':LOA_ARTICLESEUL ,:LOA_TYPELIGNE ,:LOA_ORDREAFF ,:LOA_PXBRUT ,:LOA_REMISE ,' +
    ':LOA_PXNET ,:LOA_ASSUR ,:LOA_PXNN ,:LOA_DJPPRIX , :LOA_DJPASSUR ,' +
    ':LOA_SORTIEREEL ,:LOA_REGFIX , :LOA_USRID , :LOA_FLAGASS , :LOA_TVAID  ,' +
    ' :LOA_TXTVA,0,0)');
  Ibc_loa.Prepare;

  qry.close;
  qry.sql.text := 'SELECT ID FROM PR_NEWK (''CSHSESSION'')';
  qry.Open;
  id := qry.Fields[0].Asinteger;
  T_session.open;
  T_session.insert;
  T_session.fieldbyname('SES_ID').asinteger := id;
  T_session.fieldbyname('SES_POSID').asinteger := 0;
  T_session.fieldbyname('SES_NUMERO').asstring := '0-0';
  T_session.fieldbyname('SES_DEBUT').asdatetime := Date;
  T_session.fieldbyname('SES_FIN').asdatetime := Date;
  T_session.fieldbyname('SES_CAISOUV').asstring := 'Reprise HISTORIQUE';
  T_session.fieldbyname('SES_CAISFIN').asstring := 'Reprise HISTORIQUE';
  T_session.fieldbyname('SES_NBTKT').asinteger := 0;
  T_session.fieldbyname('SES_ETAT').asinteger := 2;
  T_session.post;
  sesid := T_session.fieldbyname('SES_ID').asinteger;
  tran.commit;
  screen.Cursor := crSQLWait;

  ibc_tva.open;
  tvaid := ibc_tva.fieldbyname('tva_id').asinteger;
  T_prd.Open;
  TRY
    //dm_main.starttransaction;

//---C'est parti mon quiqui...

    //Nbart := 0;
    memd_histo.First;
    Frm_Loc.Pb_histo.Max := memd_histo.RecordCount;
    Frm_Loc.Pb_histo.Position := 0;

    WHILE NOT memd_histo.eof DO
    BEGIN
      Frm_Loc.Pb_histo.StepBy(1);

      IF memd_histoNET.asfloat <> 0 THEN
      BEGIN

        dat := memd_histoDATE.asstring;

        //Recherche du client
        ibc_clt.close;
        ibc_clt.ParamByName('clt').asstring := memd_histoCLIENT.asstring;
        ibc_clt.open;
        cltid := ibc_clt.FieldByName('clt_id').asinteger;

        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''CSHTICKET'')';
        qry.Open;
        id_TK := qry.Fields[0].Asstring;

        Ibc_bl.parambyname('tke_id').asstring := id_TK;
        Ibc_bl.parambyname('tke_cltid').asinteger := cltid;
        Ibc_bl.parambyname('tke_sesid').asinteger := sesid;
        Ibc_bl.parambyname('tke_date').AsString := memd_histoDATE.asstring;
        Ibc_bl.parambyname('tke_caissier').asstring := '';
        Ibc_bl.parambyname('tke_num').asstring := '';
        Ibc_bl.parambyname('tke_numero').asstring := '';
        ibc_bl.ExecSQL;
        tran.commit;

        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCBONLOCATION'')';
        qry.Open;
        id_loc := qry.Fields[0].Asstring;

        Ibc_loc.parambyname('loc_id').asstring := id_loc;
        Ibc_loc.parambyname('loc_numero').asinteger := 0;
        Ibc_loc.parambyname('loc_date').asstring := memd_histoDATE.asstring;
        Ibc_loc.parambyname('loc_typedoc').asinteger := 2;
        Ibc_loc.parambyname('loc_cltid').asinteger := cltid;
        Ibc_loc.parambyname('loc_tkeid').asstring := id_tk;
        Ibc_loc.parambyname('loc_remise').asfloat := 0;
        Ibc_loc.parambyname('loc_num').asstring := '';
        Ibc_loc.ExecSQL;
        tran.commit;

        //Lignes de facture
        qry.close;
        qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCBONLOCATIONLIGNE'')';
        qry.Open;
        id_loa := qry.Fields[0].Asstring;

        Ibc_loa.parambyname('loa_id').asstring := id_loa;
        Ibc_loa.parambyname('loa_LOCID').asstring := id_LOC;

        //Recherche fiche article
        ibc_locart.close;
        ibc_locart.parambyname('chrono').asstring := memd_histoCODE.asstring;
        ibc_locart.open;
        IF ibc_locart.eof THEN
        BEGIN //Rechreche via les codes d'acces
          ibc_cb.close;
          ibc_cb.parambyname('code').asstring := memd_histoCODE.asstring;
          ibc_cb.open;
          Ibc_loa.parambyname('loa_ARLID').asinteger := ibc_cb.fieldbyname('cbi_arlid').asinteger;
          libcat := ibc_cb.fieldbyname('cal_nom').asstring;

        END
        ELSE
        BEGIN
          Ibc_loa.parambyname('loa_ARLID').asinteger := ibc_locart.fieldbyname('arl_id').asinteger;
          libcat := ibc_locart.fieldbyname('cal_nom').asstring;
        END;

        //Recherche du produit fictif correspondant en fonction du libellé de la catégorie
        t_prd.open;
        IF NOT T_prd.locate('PRD_NOM;PRD_COMID', VarArrayOf([libcat, 0]), []) THEN
        BEGIN //Le produit n'existe pas , on va le créer
          qry.close;
          qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCPRODUIT'')';
          qry.Open;
          T_prd.insert;
          T_prdPRD_ID.asinteger := qry.Fields[0].Asinteger;
          T_prdPRD_NOM.asstring := libcat;
          T_prdPRD_COMID.asinteger := 0;
          T_prd.Open;
          T_prd.post;
        END;

        Ibc_loa.parambyname('loa_prdID').asinteger := T_prdPRD_ID.asinteger;

        //Ibc_loa.parambyname('loa_orgid').asinteger := 0;
        Ibc_loa.parambyname('loa_loaid').asinteger := 0;
        Ibc_loa.parambyname('loa_client').asstring := '';

        Ibc_loa.parambyname('loa_debut').asstring := memd_histoDATE.asstring;
        Ibc_loa.parambyname('loa_debut').asdatetime := Ibc_loa.parambyname('loa_debut').asdatetime -
          int(memd_histoNBJ.asfloat) + 1.3333; //Loc à 8 H

        IF int(memd_histoNBJ.asfloat) <> memd_histoNBJ.asfloat THEN
        BEGIN //Il y a une demi journee
          Ibc_loa.parambyname('loa_debut').asdatetime := Ibc_loa.parambyname('loa_debut').asdatetime - 0.75; //La veille à 14 H
        END;

        Ibc_loa.parambyname('loa_fin').asstring := memd_histoDATE.asstring;
        Ibc_loa.parambyname('loa_fin').asdatetime := Ibc_loa.parambyname('loa_fin').asdatetime + 0.75; //Retour à18H
        Ibc_loa.parambyname('loa_etat').asinteger := 2;
        Ibc_loa.parambyname('loa_articleseul').asinteger := 0;
        Ibc_loa.parambyname('loa_typeligne').asinteger := 1;
        Ibc_loa.parambyname('loa_ordreaff').asfloat := 0;

        Ibc_loa.parambyname('loa_pxbrut').asfloat := memd_histoBRUT.asfloat;
        Ibc_loa.parambyname('loa_remise').asfloat := 0;
        Ibc_loa.parambyname('loa_pxnet').asfloat := memd_histoNET.asfloat;
        Ibc_loa.parambyname('loa_assur').asfloat := memd_histoGARANTIE.asfloat;
        Ibc_loa.parambyname('loa_pxnn').asfloat := memd_histoNET.asfloat;
        Ibc_loa.parambyname('loa_djpprix').asfloat := memd_histoNET.asfloat;
        Ibc_loa.parambyname('loa_djpassur').asfloat := 0;
        Ibc_loa.parambyname('loa_SORTIEREEL').asstring := memd_histoDATE.asstring;
        Ibc_loa.parambyname('loa_regfix').asinteger := 0;
        Ibc_loa.parambyname('loa_usrid').asinteger := 0;
        IF memd_histoGARANTIE.asfloat <> 0 THEN
          Ibc_loa.parambyname('loa_flagass').asinteger := 1
        ELSE
          Ibc_loa.parambyname('loa_flagass').asinteger := 0;

        Ibc_loa.parambyname('loa_tvaid').asinteger := tvaid;
        Ibc_loa.parambyname('loa_txtva').asfloat := 19.6;

        Ibc_loa.ExecSQL;
        tran.commit;
      END;

      memd_histo.next;
    END;
    //dm_main.commit;

  EXCEPT
    ShowMessage(memd_histoCODE.asstring);
    RAISE;
    //dm_main.rollback;
  END;
  ibc_tva.close;
end;

procedure TDm_Loc.TraitementNomenclature(cPathFile : string);
var
  iRapId : Integer;
  iRapOrdreaff : Integer;
  iFapId : Integer;
  iFapOrdreaff : Integer;
  iComId : Integer;
  iComOrdreaff,
  iTgtOrdreaff,
  iGtfOrdreaff : Integer;
  iTvaId,
  iTctId,
  iLpeId,
  iTcaId,
  iTycId,
  iPrdId,
  iCalId,
  iPrlId,
  iTgtId,
  iGtfId,
  iArlId,
  iStaId : Integer;
  sTgtNom,
  sTgtCode,
  sGtfNom,
  sGtfCode,
  sChrono : string;
  cdsNomenclature,
  cdsTypeArt,
  cdsCategorie : TClientDataSet;
begin
  try
    cdsNomenclature := TClientDataSet.Create(nil);
    cdsTypeArt := TClientDataSet.Create(nil);
    cdsCategorie := TClientDataSet.Create(nil);
    try
      if not tran.InTransaction then
        tran.StartTransaction;

      //Traitement du Type Comptable.
      Que_Select.Close;
      Que_Select.SQL.Text := 'SELECT TCT_ID, K_ENABLED FROM ARTTYPECOMPTABLE JOIN K ON (K_ID = TCT_ID) WHERE UPPER(TCT_NOM) = UPPER(' + QuotedStr('LOCATION') + ') AND TCT_ID <> 0 ORDER BY K_ENABLED DESC';
      Que_Select.Open;
      if Que_Select.Eof then
      begin
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('ARTTYPECOMPTABLE') + ')';
        Que_Select.Open;
        iTctId := Que_Select.FieldByName('ID').AsInteger;

        Que_Insert.SQL.Text := 'INSERT INTO ARTTYPECOMPTABLE (TCT_ID, TCT_NOM, TCT_CODE) ' +
                                'VALUES (:TCTID, ' + QuotedStr('LOCATION') +', (SELECT MAX(TCT_CODE) FROM ARTTYPECOMPTABLE))';
        Que_Insert.ParamByName('TCTID').AsInteger := iTctId;
        Que_Insert.ExecSQL;
      end
      else
      begin
        iTctId := Que_Select.FieldByName('TCT_ID').AsInteger;
        if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
          UpdateK(iTctId, cPrUpdateK_Act);
      end;

      //Traitement du Type de location.
      Que_Select.Close;
      Que_Select.SQL.Text := 'SELECT LPE_ID, K_ENABLED FROM LOCPARAMNONKE JOIN K ON (K_ID = LPE_ID) WHERE UPPER(LPE_NOM) = UPPER(' + QuotedStr('Location Journée') + ') AND LPE_ID <> 0 ORDER BY K_ENABLED DESC';
      Que_Select.Open;
      if Que_Select.Eof then
      begin
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCPARAMNONKE') + ')';
        Que_Select.Open;
        iLpeId := Que_Select.FieldByName('ID').AsInteger;

        Que_Insert.SQL.Text := 'INSERT INTO LOCPARAMNONKE (LPE_ID, LPE_NOM, LPE_TYPE) ' +
                                'VALUES (:LPEID, ' + QuotedStr('Location Journée') +', 0)';
        Que_Insert.ParamByName('LPEID').AsInteger := iLpeId;
        Que_Insert.ExecSQL;
      end
      else
      begin
        iLpeId := Que_Select.FieldByName('LPE_ID').AsInteger;
        if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
          UpdateK(iLpeId, cPrUpdateK_Act);
      end;

      //Statut de location
      Que_Select.Close;
      Que_Select.SQL.Text := 'SELECT STA_ID, K_ENABLED FROM LOCSTATUT JOIN K ON (K_ID = STA_ID) WHERE UPPER(STA_NOM) = UPPER(' + QuotedStr('LOCATION') + ') AND STA_ID <> 0 ORDER BY K_ENABLED DESC';
      Que_Select.Open;
      if Que_Select.Eof then
      begin
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCSTATUT') + ')';
        Que_Select.Open;
        iStaId := Que_Select.FieldByName('ID').AsInteger;

        Que_Insert.SQL.Text := 'INSERT INTO LOCSTATUT (STA_ID, STA_NOM, STA_DISPOLOC) ' +
                                'VALUES (:STAID, ' + QuotedStr('LOCATION') +', 1)';
        Que_Insert.ParamByName('STAID').AsInteger := iStaId;
        Que_Insert.ExecSQL;
      end
      else
      begin
        iStaId := Que_Select.FieldByName('STA_ID').AsInteger;
        if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
          UpdateK(iLpeId, cPrUpdateK_Act);
      end;

      //Chargement des fichiers csv
      CSV_To_ClientDataSet(cPathFile+'NOMENCLATURE_LOC.csv',cdsNomenclature,'ID');
      CSV_To_ClientDataSet(cPathFile+'TYPES_ARTICLES.csv',cdsTypeArt,'ID_NOMENCLATURE;TYPE ARTICLE');
      CSV_To_ClientDataSet(cPathFile+'CATEGORIE.csv',cdsCategorie,'ID_NOMENCLATURE;Nom');

      cdsNomenclature.First;
      while not cdsNomenclature.Eof do
      begin
        //Création des rayons
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT RAP_ID, K_ENABLED FROM LOCNKRAYON JOIN K ON (K_ID = RAP_ID) WHERE RAP_NOM = :RAPNOM AND RAP_ID <> 0 ORDER BY K_ENABLED DESC';
        Que_Select.ParamByName('RAPNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 1').AsString;
        Que_Select.Open;

        if Que_Select.Eof then
        begin
          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCNKRAYON') + ')';
          Que_Select.Open;
          iRapId := Que_Select.FieldByName('ID').AsInteger;

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT MAX(RAP_ORDREAFF)+10 AS ORDREAFF FROM LOCNKRAYON WHERE RAP_ID <> 0';
          Que_Select.Open;
          iRapOrdreaff := Que_Select.FieldByName('ORDREAFF').AsInteger;

          Que_Insert.SQL.Text := 'INSERT INTO LOCNKRAYON (RAP_ID, RAP_NOM, RAP_ORDREAFF, RAP_THEO, RAP_VISIBLE) ' +
                                  'VALUES (:RAPID, :RAPNOM, :RAPORDREAFF, 0, 1)';
          Que_Insert.ParamByName('RAPID').AsInteger := iRapId;
          Que_Insert.ParamByName('RAPNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 1').AsString;
          Que_Insert.ParamByName('RAPORDREAFF').AsInteger := iRapOrdreaff;
          Que_Insert.ExecSQL;
        end
        else
        begin
          iRapId := Que_Select.FieldByName('RAP_ID').AsInteger;
          if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
            UpdateK(iRapId, cPrUpdateK_Act);
        end;

        //Création des familles
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT FAP_ID, K_ENABLED FROM LOCNKFAMILLE JOIN K ON (K_ID = FAP_ID) WHERE FAP_NOM = :FAPNOM AND FAP_ID <> 0 AND FAP_RAPID = :FAPRAPID ORDER BY K_ENABLED DESC';
        Que_Select.ParamByName('FAPNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 2').AsString;
        Que_Select.ParamByName('FAPRAPID').AsInteger := iRapId;
        Que_Select.Open;

        if Que_Select.Eof then
        begin
          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCNKFAMILLE') + ')';
          Que_Select.Open;
          iFapId := Que_Select.FieldByName('ID').AsInteger;

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT MAX(FAP_ORDREAFF)+10 AS ORDREAFF FROM LOCNKFAMILLE WHERE FAP_ID <> 0 AND FAP_RAPID = :FAPRAPID';
          Que_Select.ParamByName('FAPRAPID').AsInteger := iRapId;
          Que_Select.Open;
          iFapOrdreaff := Que_Select.FieldByName('ORDREAFF').AsInteger;

          Que_Insert.SQL.Text := 'INSERT INTO LOCNKFAMILLE (FAP_ID, FAP_RAPID, FAP_NOM, FAP_ORDREAFF, FAP_THEO, FAP_CFLID, FAP_COUL, FAP_VISIBLE) ' +
                                  'VALUES (:FAPID, :FAPRAPID, :FAPNOM, :FAPORDREAFF, 0, 0, 0, 1)';
          Que_Insert.ParamByName('FAPID').AsInteger := iFapId;
          Que_Insert.ParamByName('FAPRAPID').AsInteger := iRapId;
          Que_Insert.ParamByName('FAPNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 2').AsString;
          Que_Insert.ParamByName('FAPORDREAFF').AsInteger := iFapOrdreaff;
          Que_Insert.ExecSQL;
        end
        else
        begin
          iFapId := Que_Select.FieldByName('FAP_ID').AsInteger;
          if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
            UpdateK(iFapId, cPrUpdateK_Act);
        end;

        //Création des compositions
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT COM_ID, K_ENABLED FROM LOCNKCOMPOSITION JOIN K ON (K_ID = COM_ID) WHERE COM_NOM = :COMNOM AND COM_ID <> 0 AND COM_FAPID = :COMFAPID ORDER BY K_ENABLED DESC';
        Que_Select.ParamByName('COMNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 3').AsString;
        Que_Select.ParamByName('COMFAPID').AsInteger := iFapId;
        Que_Select.Open;

        if Que_Select.Eof then
        begin
          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCNKCOMPOSITION') + ')';
          Que_Select.Open;
          iComId := Que_Select.FieldByName('ID').AsInteger;

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT MAX(COM_ORDREAFF)+10 AS ORDREAFF FROM LOCNKCOMPOSITION WHERE COM_ID <> 0 AND COM_FAPID = :COMFAPID';
          Que_Select.ParamByName('COMFAPID').AsInteger := iFapId;
          Que_Select.Open;
          iComOrdreaff := Que_Select.FieldByName('ORDREAFF').AsInteger;

          iTvaId := Tva(cdsNomenclature.FieldByName('TVA').AsFloat);

          Que_Insert.SQL.Text := 'INSERT INTO LOCNKCOMPOSITION (COM_ID, COM_FAPID, COM_NOM, COM_ORDREAFF, COM_THEO, COM_TVAID, COM_TCTID, COM_VISIBLE, COM_LPEID) ' +
                                  'VALUES (:COMID, :COMFAPID, :COMNOM, :COMORDREAFF, 0, :COMTVAID, :COMTCTID, 1, :COMLPEID)';
          Que_Insert.ParamByName('COMID').AsInteger := iComId;
          Que_Insert.ParamByName('COMFAPID').AsInteger := iFapId;
          Que_Insert.ParamByName('COMNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 3').AsString;
          Que_Insert.ParamByName('COMORDREAFF').AsInteger := iComOrdreaff;
          Que_Insert.ParamByName('COMTVAID').AsInteger := iTvaId;
          Que_Insert.ParamByName('COMTCTID').AsInteger := iTctId;
          Que_Insert.ParamByName('COMLPEID').AsInteger := iLpeId;
          Que_Insert.ExecSQL;
        end
        else
        begin
          iComId := Que_Select.FieldByName('COM_ID').AsInteger;
          if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
            UpdateK(iComId, cPrUpdateK_Act);
        end;

        cdsTypeArt.Filtered  := False;
        cdsTypeArt.Filter    := 'ID_NOMENCLATURE = ' + QuotedStr(cdsNomenclature.FieldByName('ID').AsString);
        cdsTypeArt.Filtered  := True;
        cdsTypeArt.First;

        while not cdsTypeArt.Eof do
        begin
          //Création des Liens Produit-Type Catégorie
          iTcaId := TypeCategorie(cdsTypeArt.FieldByName('TYPE ARTICLE').AsString);
          iTycId := ProduitTypeCategorie(iComId,iTcaId,cdsTypeArt.FieldByName('%').AsFloat);
          cdsTypeArt.Next;
        end;

        cdsCategorie.Filtered  := False;
        cdsCategorie.Filter    := 'ID_NOMENCLATURE = ' + QuotedStr(cdsNomenclature.FieldByName('ID').AsString);
        cdsCategorie.Filtered  := True;
        cdsCategorie.First;

        while not cdsCategorie.Eof do
        begin
          //Création du type de Grille de tailles
          sTgtNom := cdsCategorie.FieldByName('NOM TYPE GT').AsString;
          sTgtCode := cdsCategorie.FieldByName('CODE TYPE GT').AsString;

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT TGT_ID, K_ENABLED FROM PLXTYPEGT JOIN K ON (K_ID = TGT_ID) WHERE UPPER(TGT_NOM) = UPPER(:TGTNOM) AND UPPER(TGT_CODE) = UPPER(:TGTCODE) AND TGT_ID <> 0 ORDER BY K_ENABLED DESC';
          Que_Select.ParamByName('TGTNOM').AsString := sTgtNom;
          Que_Select.ParamByName('TGTCODE').AsString := sTgtCode;
          Que_Select.Open;
          if ((Que_Select.Eof) AND (sTgtNom = '') AND (sTgtCode = '')) then
          begin
            sTgtNom := 'IMPORT LOCATION';
            sTgtCode := '';

            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT TGT_ID, K_ENABLED FROM PLXTYPEGT JOIN K ON (K_ID = TGT_ID) WHERE UPPER(TGT_NOM) = UPPER(:TGTNOM) AND TGT_ID <> 0 ORDER BY K_ENABLED DESC';
            Que_Select.ParamByName('TGTNOM').AsString := sTgtNom;
            Que_Select.Open;
          end;

          if Que_Select.Eof then
          begin
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('PLXTYPEGT') + ')';
            Que_Select.Open;
            iTgtId := Que_Select.FieldByName('ID').AsInteger;

            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT MAX(TGT_ORDREAFF)+10 AS ORDREAFF FROM PLXTYPEGT WHERE TGT_ID <> 0';
            Que_Select.Open;
            iTgtOrdreaff := Que_Select.FieldByName('ORDREAFF').AsInteger;

            Que_Insert.SQL.Text := 'INSERT INTO PLXTYPEGT (TGT_ID, TGT_NOM, TGT_ORDREAFF, TGT_CODE, TGT_CENTRALE) ' +
                                  'VALUES (:TGTID, :TGTNOM, :TGTORDREAFF, :TGTCODE, :TGTCENTRALE)';
            Que_Insert.ParamByName('TGTID').AsInteger := iTgtId;
            Que_Insert.ParamByName('TGTNOM').AsString := sTgtNom;
            Que_Insert.ParamByName('TGTORDREAFF').AsFloat := iTgtOrdreaff;
            Que_Insert.ParamByName('TGTCODE').AsString := sTgtCode;
            Que_Insert.ParamByName('TGTCENTRALE').AsInteger := 0;
            Que_Insert.ExecSQL;
          end
          else
          begin
            iTgtId := Que_Select.FieldByName('TGT_ID').AsInteger;
            if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
              UpdateK(iTgtId, cPrUpdateK_Act);
          end;

          //Création des Grilles de tailles
          sGtfNom := cdsCategorie.FieldByName('NOM GT').AsString;
          sGtfCode := cdsCategorie.FieldByName('CODE GT').AsString;

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT GTF_ID, K_ENABLED FROM PLXGTF JOIN K ON (K_ID = GTF_ID) WHERE UPPER(GTF_NOM) = UPPER(:GTFNOM) AND UPPER(GTF_CODE) = UPPER(:GTFCODE) AND GTF_ID <> 0 AND GTF_TGTID = :GTFTGTID ORDER BY K_ENABLED DESC';
          Que_Select.ParamByName('GTFNOM').AsString := sGtfNom;
          Que_Select.ParamByName('GTFCODE').AsString := sGtfCode;
          Que_Select.ParamByName('GTFTGTID').AsInteger := iTgtId;
          Que_Select.Open;

          if ((Que_Select.Eof) AND (sGtfNom = '') AND (sGtfCode = '')) then
          begin
            sGtfNom := 'IMPORT LOCATION';
            sGtfCode := '';
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT GTF_ID, K_ENABLED FROM PLXGTF JOIN K ON (K_ID = GTF_ID) WHERE UPPER(GTF_NOM) = UPPER(:GTFNOM) AND GTF_ID <> 0 AND GTF_TGTID = :GTFTGTID ORDER BY K_ENABLED DESC';
            Que_Select.ParamByName('GTFNOM').AsString := sGtfNom;
            Que_Select.ParamByName('GTFTGTID').AsInteger := iTgtId;
            Que_Select.Open;
          end;

          if Que_Select.Eof then
          begin
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('PLXGTF') + ')';
            Que_Select.Open;
            iGtfId := Que_Select.FieldByName('ID').AsInteger;

            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT MAX(GTF_ORDREAFF)+10 AS ORDREAFF FROM PLXGTF WHERE GTF_ID <> 0 AND GTF_TGTID = :GTFTGTID';
            Que_Select.ParamByName('GTFTGTID').AsInteger := iTgtId;
            Que_Select.Open;
            iGtfOrdreaff := Que_Select.FieldByName('ORDREAFF').AsInteger;

            Que_Insert.SQL.Text := 'INSERT INTO PLXGTF (GTF_ID, GTF_IDREF, GTF_NOM, GTF_TGTID, GTF_ORDREAFF, GTF_IMPORT, GTF_CENTRALE, GTF_ACTIVE, GTF_CODE) ' +
                                    'VALUES (:GTFID, :GTFIDREF, :GTFNOM, :GTFTGTID, :GTFORDREAFF, :GTFIMPORT, :GTFCENTRALE, :GTFACTIVE, :GTFCODE)';
            Que_Insert.ParamByName('GTFID').AsInteger := iGtfId;
            Que_Insert.ParamByName('GTFIDREF').AsInteger := 0;
            Que_Insert.ParamByName('GTFNOM').AsString := sGtfNom;
            Que_Insert.ParamByName('GTFTGTID').AsInteger := iTgtId;
            Que_Insert.ParamByName('GTFORDREAFF').AsFloat := iGtfOrdreaff;
            Que_Insert.ParamByName('GTFIMPORT').AsInteger := 0;
            Que_Insert.ParamByName('GTFCENTRALE').AsInteger := 0;
            Que_Insert.ParamByName('GTFACTIVE').AsInteger := 1;
            Que_Insert.ParamByName('GTFCODE').AsString := sGtfCode;
            Que_Insert.ExecSQL;
          end
          else
          begin
            iGtfId := Que_Select.FieldByName('GTF_ID').AsInteger;
            if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
              UpdateK(iGtfId, cPrUpdateK_Act);
          end;

          //Création des Catégories
          iTcaId := TypeCategorie(cdsCategorie.FieldByName('TYPE ARTICLE').AsString);

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT CAL_ID, K_ENABLED FROM LOCCATEGORIE JOIN K ON (K_ID = CAL_ID) WHERE UPPER(CAL_NOM) = UPPER(:CALNOM) AND CAL_TCAID = :CALTCAID AND CAL_ID <> 0 ORDER BY K_ENABLED DESC';
          Que_Select.ParamByName('CALNOM').AsString := cdsCategorie.FieldByName('PREFIXE CAT').AsString + cdsCategorie.FieldByName('Nom').AsString;
          Que_Select.ParamByName('CALTCAID').AsInteger := iTcaId;
          Que_Select.Open;
          if Que_Select.Eof then
          begin
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCCATEGORIE') + ')';
            Que_Select.Open;
            iCalId := Que_Select.FieldByName('ID').AsInteger;

            Que_Insert.SQL.Text := 'INSERT INTO LOCCATEGORIE (CAL_ID, CAL_TCAID, CAL_NOM, CAL_DESCRIPTION, CAL_BATON, CAL_REGLAGE, CAL_DUREEAMT, CAL_GTFID, CAL_GARJOUR, CAL_GARFORF, CAL_GARSAIS, CAL_FLAGASS) ' +
                                    'VALUES (:CALID, :CALTCAID, :CALNOM, :CALDESCRIPTION, 0, 0, 3, :CALGTFID, 0, 0, 0, 0)';
            Que_Insert.ParamByName('CALID').AsInteger := iCalId;
            Que_Insert.ParamByName('CALTCAID').AsInteger := iTcaId;
            Que_Insert.ParamByName('CALNOM').AsString := cdsCategorie.FieldByName('PREFIXE CAT').AsString + cdsCategorie.FieldByName('Nom').AsString;
            Que_Insert.ParamByName('CALDESCRIPTION').AsString := '';
            Que_Insert.ParamByName('CALGTFID').AsInteger := iGtfId;
            Que_Insert.ExecSQL;
          end
          else
          begin
            iCalID := Que_Select.FieldByName('CAL_ID').AsInteger;
            if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
              UpdateK(iCalID, cPrUpdateK_Act);
          end;

          //Création des Pseudo
          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT ARL_ID, K_ENABLED FROM LOCARTICLE JOIN K ON (K_ID = ARL_ID) WHERE UPPER(ARL_NOM) = UPPER(:ARLNOM) AND ARL_CALID = :ARLCALID AND ARL_ID <> 0 ORDER BY K_ENABLED DESC';
          Que_Select.ParamByName('ARLNOM').AsString := cdsCategorie.FieldByName('PREFIXE CAT').AsString + cdsCategorie.FieldByName('Nom').AsString;
          Que_Select.ParamByName('ARLCALID').AsInteger := iCalId;
          Que_Select.Open;
          if Que_Select.Eof then
          begin
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCARTICLE') + ')';
            Que_Select.Open;
            iArlId := Que_Select.FieldByName('ID').AsInteger;

            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT NEWNUM FROM LOC_CHRONO';
            Que_Select.Open;
            sChrono := Que_Select.FieldByName('NEWNUM').AsString;

            Que_Insert.SQL.Text := 'INSERT INTO LOCARTICLE (ARL_ID, ARL_ARLID, ARL_STAID, ARL_MRKID, ARL_TGFID, ARL_CALID, ARL_CDVID, ARL_TKEID, ARL_ICLID1, ARL_ICLID2, ' +
                                                           'ARL_ICLID3, ARL_ICLID4, ARL_ICLID5, ARL_CHRONO, ARL_NOM, ARL_DESCRIPTION, ARL_NUMSERIE, ARL_COMENT, ARL_SESSALOMON, ' +
                                                           'ARL_DATEACHAT, ARL_PRIXACHAT, ARL_PRIXVENTE, ARL_DATECESSION, ARL_PRIXCESSION, ARL_DUREEAMT, ARL_SOMMEAMT, ' +
                                                           'ARL_ARCHIVER, ARL_VIRTUEL, ARL_REFMRK, ARL_TVATAUX, ARL_LOUEAUFOURN, ARL_DATEFAB, ARL_DUREEVIE, ARL_PROPRIOMAGID, ' +
                                                           'ARL_LOCALIMAGID) ' +
                                    'VALUES (:ARLID, :ARLARLID, :ARLSTAID, 0, 0, :ARLCALID, 0, 0, 0, 0, ' +
                                            '0, 0, 0, :ARLCHRONO, :ARLNOM, :ARLDESCRIPTION, :ARLNUMSERIE, :ARLCOMENT, 0, ' +
                                            ':ARLDATEACHAT, 0, 0, :ARLDATECESSION, 0, 0, 0, ' +
                                            '0, 1, :ARLREFMRK, 0, 0, :ARLDATEFAB, 0, 0, ' +
                                            '0)';
            Que_Insert.ParamByName('ARLID').AsInteger := iArlId;
            Que_Insert.ParamByName('ARLARLID').AsInteger := iArlId;
            Que_Insert.ParamByName('ARLSTAID').AsInteger := iStaId;
            Que_Insert.ParamByName('ARLCALID').AsInteger := iCalId;
            Que_Insert.ParamByName('ARLCHRONO').AsString := sChrono;
            Que_Insert.ParamByName('ARLNOM').AsString := cdsCategorie.FieldByName('PREFIXE CAT').AsString + cdsCategorie.FieldByName('Nom').AsString;
            Que_Insert.ParamByName('ARLDESCRIPTION').AsString := '';
            Que_Insert.ParamByName('ARLNUMSERIE').AsString := '';
            Que_Insert.ParamByName('ARLCOMENT').AsString := '';
            Que_Insert.ParamByName('ARLDATEACHAT').AsDate := Now;
            Que_Insert.ParamByName('ARLDATECESSION').AsDate := StrToDate('31/12/1899');
            Que_Insert.ParamByName('ARLREFMRK').AsString := '';
            Que_Insert.ParamByName('ARLDATEFAB').AsDate := StrToDate('31/12/1899');
            Que_Insert.ExecSQL;
          end
          else
          begin
            iArlID := Que_Select.FieldByName('ARL_ID').AsInteger;
            if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
              UpdateK(iArlID, cPrUpdateK_Act);
          end;

          //Création du lien Produit Ligne
          iTycId := ProduitTypeCategorie(iComId,iTcaId,100);

          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT PRL_ID, K_ENABLED FROM LOCPRODUITLIGNE JOIN K ON (K_ID = PRL_ID) WHERE PRL_CALID = :PRLCALID AND PRL_TYCID = :PRLTYCID AND PRL_ID <> 0 ORDER BY K_ENABLED DESC';
          Que_Select.ParamByName('PRLCALID').AsInteger := iCalId;
          Que_Select.ParamByName('PRLTYCID').AsInteger := iTycId;
          Que_Select.Open;
          if Que_Select.Eof then
          begin
            Que_Select.Close;
            Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCPRODUITLIGNE') + ')';
            Que_Select.Open;
            iPrlId := Que_Select.FieldByName('ID').AsInteger;

            Que_Insert.SQL.Text := 'INSERT INTO LOCPRODUITLIGNE (PRL_ID, PRL_CALID, PRL_TYCID) ' +
                                  'VALUES (:PRLID, :PRLCALID, :PRLTYCID)';
            Que_Insert.ParamByName('PRLID').AsInteger := iPrlId;
            Que_Insert.ParamByName('PRLCALID').AsInteger := iCalId;
            Que_Insert.ParamByName('PRLTYCID').AsInteger := iTycId;
            Que_Insert.ExecSQL;
          end
          else
          begin
            iPrlId := Que_Select.FieldByName('PRL_ID').AsInteger;
            if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
              UpdateK(iPrlId, cPrUpdateK_Act);
          end;
          cdsCategorie.Next;
        end;

        //Création des Offres Commerciales LOCPRODUIT
        Que_Select.Close;
        Que_Select.SQL.Text := 'SELECT PRD_ID, K_ENABLED FROM LOCPRODUIT JOIN K ON (K_ID = PRD_ID) WHERE UPPER(PRD_NOM) = UPPER(:PRDNOM) AND PRD_ID <> 0 AND PRD_COMID = :PRDCOMID ORDER BY K_ENABLED DESC';
        Que_Select.ParamByName('PRDNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 3').AsString;
        Que_Select.ParamByName('PRDCOMID').AsInteger := iComId;
        Que_Select.Open;
        if Que_Select.Eof then
        begin
          Que_Select.Close;
          Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCPRODUIT') + ')';
          Que_Select.Open;
          iPrdId := Que_Select.FieldByName('ID').AsInteger;

          Que_Insert.SQL.Text := 'INSERT INTO LOCPRODUIT (PRD_ID, PRD_NOM, PRD_DESCRIPTION, PRD_CAUTION, PRD_COMID, PRD_MAGASIN, PRD_RAPIDO, PRD_CHRONO) ' +
                                  'VALUES (:PRDID, :PRDNOM, :PRDDESCRIPTION, :PRDCAUTION, :PRDCOMID, :PRDMAGASIN, :PRDRAPIDO, (SELECT NEWNUM FROM BN_NUMOC))';
          Que_Insert.ParamByName('PRDID').AsInteger := iPrdId;
          Que_Insert.ParamByName('PRDNOM').AsString := cdsNomenclature.FieldByName('NIVEAU 3').AsString;
          Que_Insert.ParamByName('PRDDESCRIPTION').AsString := '';
          Que_Insert.ParamByName('PRDCAUTION').AsFloat := 0;
          Que_Insert.ParamByName('PRDCOMID').AsInteger := iComId;
          Que_Insert.ParamByName('PRDMAGASIN').AsInteger := 1;
          Que_Insert.ParamByName('PRDRAPIDO').AsString := '';
          Que_Insert.ExecSQL;
        end
        else
        begin
          iPrdId := Que_Select.FieldByName('PRD_ID').AsInteger;
          if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
            UpdateK(iPrdId, cPrUpdateK_Act);
        end;
        cdsNomenclature.Next;
      end;

    finally
      FreeAndNil(cdsNomenclature);
      FreeAndNil(cdsTypeArt);
      FreeAndNil(cdsCategorie);
      tran.Commit;
      ShowMessage('Traitement (Articles) terminé');
    end;
  except on e: Exception do
    begin
      tran.Rollback;
      ShowMessage('Erreur dans le traitement avec le message :' + e.Message);
    end;
  end;
end;

function TDm_Loc.TypeCategorie(sNom : string):Integer;
//SR - 21/11/2016 - Permet de récupérer l'id d'un Type de catégorie, de la créer si elle n'héxiste pas
begin
  try
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT TCA_ID, K_ENABLED FROM LOCTYPECATEGORIE JOIN K ON (K_ID = TCA_ID) WHERE UPPER(TCA_NOM) = UPPER(:TCANOM) AND TCA_ID <> 0 ORDER BY K_ENABLED DESC';
    Que_Select.ParamByName('TCANOM').AsString := sNom;
    Que_Select.Open;

    if Que_Select.Eof then
    begin
      Que_Select.Close;
      Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('LOCTYPECATEGORIE') + ')';
      Que_Select.Open;
      Result := Que_Select.FieldByName('ID').AsInteger;

      Que_Insert.SQL.Text := 'INSERT INTO LOCTYPECATEGORIE (TCA_ID, TCA_NOM) ' +
                            'VALUES (:TCAID, :TCANOM)';
      Que_Insert.ParamByName('TCAID').AsInteger := Result;
      Que_Insert.ParamByName('TCANOM').AsString := sNom;
      Que_Insert.ExecSQL;
    end
    else
    begin
      Result := Que_Select.FieldByName('TCA_ID').AsInteger;
      if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
        UpdateK(Result, cPrUpdateK_Act);
    end;
  except on e: Exception do
    begin
      Result := -1;
      ShowMessage('Erreur dans le traitement des TypeCategorie avec le message :' + e.Message);
    end;
  end;
end;

function TDm_Loc.Tva(fTaux: Real): Integer;
//SR - 21/11/2016 - Permet de récupérer l'id d'une TVA, de la créer si elle n'héxiste pas
begin
  try
    if fTaux = 0 then
      fTaux := 20;

    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT TVA_ID, K_ENABLED FROM ARTTVA JOIN K ON (K_ID = TVA_ID) WHERE TVA_TAUX = :TVATAUX AND TVA_ID <> 0 ORDER BY K_ENABLED DESC';
    Que_Select.ParamByName('TVATAUX').AsFloat := fTaux;
    Que_Select.Open;
    if Que_Select.Eof then
    begin
      Que_Select.Close;
      Que_Select.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr('ARTTVA') + ')';
      Que_Select.Open;
      Result := Que_Select.FieldByName('ID').AsInteger;

      Que_Insert.SQL.Text := 'INSERT INTO ARTTVA (TVA_ID, TVA_TAUX, TVA_CODE, TVA_COMPTA) ' +
                           'VALUES (:TVAID, :TVATAUX, (SELECT MAX(TVA_CODE) FROM ARTTVA), ' + QuotedStr('ne plus utiliser -> TVC_CPTVTE') + ')';
      Que_Insert.ParamByName('TVAID').AsInteger := Result;
      Que_Insert.ParamByName('TVATAUX').AsFloat := fTaux;
      Que_Insert.ExecSQL;
    end
    else
    begin
      Result := Que_Select.FieldByName('TVA_ID').AsInteger;
      if Que_Select.FieldByName('K_ENABLED').AsInteger = 0 then
        UpdateK(Result, cPrUpdateK_Act);
    end;
  except on e: Exception do
    begin
      Result := -1;
      ShowMessage('Erreur dans le traitement des TVA avec le message :' + e.Message);
    end;
  end;
end;

procedure TDm_Loc.UpdateK(iKid, iEtat: Integer);
begin
    StProc_PrUpdateK.ParamByName('K_ID').AsInteger := iKid;
    StProc_PrUpdateK.ParamByName('SUPRESSION').AsInteger := iEtat;
    StProc_PrUpdateK.ExecProc;
end;

procedure TDm_Loc.ViderNomenclature(cDeletePhisique : Boolean);

begin
  try
    if not tran.InTransaction then
      tran.StartTransaction;

    //Vidage table LOCNKRAYON
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT RAP_ID FROM LOCNKRAYON WHERE RAP_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCNKRAYON WHERE RAP_ID = :RAPID';
        Que_Delete.ParamByName('RAPID').AsInteger := Que_Select.FieldByName('RAP_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :RAPID';
        Que_Delete.ParamByName('RAPID').AsInteger := Que_Select.FieldByName('RAP_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('RAP_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage table LOCNKFAMILLE
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT FAP_ID FROM LOCNKFAMILLE WHERE FAP_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCNKFAMILLE WHERE FAP_ID = :FAPID';
        Que_Delete.ParamByName('FAPID').AsInteger := Que_Select.FieldByName('FAP_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :FAPID';
        Que_Delete.ParamByName('FAPID').AsInteger := Que_Select.FieldByName('FAP_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('FAP_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage table LOCNKCOMPOSITION
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT COM_ID FROM LOCNKCOMPOSITION WHERE COM_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCNKCOMPOSITION WHERE COM_ID = :COMID';
        Que_Delete.ParamByName('COMID').AsInteger := Que_Select.FieldByName('COM_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :COMID';
        Que_Delete.ParamByName('COMID').AsInteger := Que_Select.FieldByName('COM_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('COM_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage des liens Catégories Associées
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT PRL_ID FROM LOCPRODUITLIGNE WHERE PRL_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCPRODUITLIGNE WHERE PRL_ID = :PRLID';
        Que_Delete.ParamByName('PRLID').AsInteger := Que_Select.FieldByName('PRL_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :PRLID';
        Que_Delete.ParamByName('PRLID').AsInteger := Que_Select.FieldByName('PRL_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('PRL_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage des Offres Commercial
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT PRD_ID FROM LOCPRODUIT WHERE PRD_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCPRODUIT WHERE PRD_ID = :PRDID';
        Que_Delete.ParamByName('PRDID').AsInteger := Que_Select.FieldByName('PRD_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :PRDID';
        Que_Delete.ParamByName('PRDID').AsInteger := Que_Select.FieldByName('PRD_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('PRD_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage des Liens Produit-Type Catégorie
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT TYC_ID FROM LOCPRODUITTYPECATEG WHERE TYC_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCPRODUITTYPECATEG WHERE TYC_ID = :TYCID';
        Que_Delete.ParamByName('TYCID').AsInteger := Que_Select.FieldByName('TYC_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :TYCID';
        Que_Delete.ParamByName('TYCID').AsInteger := Que_Select.FieldByName('TYC_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('TYC_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage des Catégorie
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT CAL_ID FROM LOCCATEGORIE WHERE CAL_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCCATEGORIE WHERE CAL_ID = :CALID';
        Que_Delete.ParamByName('CALID').AsInteger := Que_Select.FieldByName('CAL_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :CALID';
        Que_Delete.ParamByName('CALID').AsInteger := Que_Select.FieldByName('CAL_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('CAL_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    //Vidage des Liens Produit-Ligne
    Que_Select.Close;
    Que_Select.SQL.Text := 'SELECT PRL_ID FROM LOCPRODUITLIGNE WHERE PRL_ID <> 0';
    Que_Select.Open;

    Frm_Loc.PrgB_Nomenclature.Max := Que_Select.RecordCount;
    Frm_Loc.PrgB_Nomenclature.Position := 0;
    Que_Select.First;
    while not Que_Select.eof do
    begin
      if cDeletePhisique then
      begin
        Que_Delete.SQL.Text := 'DELETE FROM LOCPRODUITLIGNE WHERE PRL_ID = :PRLID';
        Que_Delete.ParamByName('PRLID').AsInteger := Que_Select.FieldByName('PRL_ID').AsInteger;
        Que_Delete.ExecSQL;
        Que_Delete.SQL.Text := 'DELETE FROM K WHERE K_ID = :PRLID';
        Que_Delete.ParamByName('PRLID').AsInteger := Que_Select.FieldByName('PRL_ID').AsInteger;
        Que_Delete.ExecSQL;
      end
      else
      begin
        UpdateK(Que_Select.FieldByName('PRL_ID').AsInteger, cPrUpdateK_Sup);
      end;
      Frm_Loc.PrgB_Nomenclature.StepBy(1);
      Que_Select.Next;
    end;

    tran.Commit;
    ShowMessage('Traitement (Articles) terminé');
  except on e: Exception do
    begin
      tran.Rollback;
      ShowMessage('Erreur dans le traitement avec le message :' + e.Message);
    end;
  end;
end;

Procedure TDm_Loc.CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
//Transfert le contenu du CSV dans un clientdataset en prenant la ligne d'entête pour la création des champs
Var
  Donnees	  : TStringList;    //Charge le fichier csv
  InfoLigne : TStringList;    //Découpe la ligne en cours de traitement
  I,J       : Integer;        //Variable de boucle
  Chaine    : String;         //Variable de traitement des lignes
Begin
  try
    //Création des variables
    Donnees   := TStringList.Create;
    InfoLigne := TStringList.Create;

    //Chargement du csv
    Donnees.LoadFromFile(FichCsv);

    //Traitement de la ligne d'entête
    InfoLigne.Clear;
    InfoLigne.Delimiter := ';';
    InfoLigne.StrictDelimiter := True;
    InfoLigne.DelimitedText := Donnees.Strings[0];
    for I := 0 to InfoLigne.Count - 1 do
      Begin
        CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
      End;
    CDS.CreateDataSet;

    //Traitement des lignes de données
    CDS.Open;

    for I := 1 to Donnees.Count - 1 do
      begin
        InfoLigne.Clear;
        InfoLigne.Delimiter := ';';
        InfoLigne.StrictDelimiter := True;
        InfoLigne.QuoteChar := '''';
        Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
        Chaine  := ReplaceStr(Chaine,';',''';''');
        Chaine  := Chaine + '''';

        InfoLigne.DelimitedText := Chaine;
        CDS.Insert;
        for J := 0 to CDS.FieldCount - 1 do
          Begin
            CDS.Fields[J].AsString  := InfoLigne.Strings[J];
          End;
        CDS.Post;
      end;
    //CDS.Close;

    CDS.AddIndex('idx', Index, []);
    CDS.IndexName := 'idx';

    //Suppression des variables en mémoire
    Donnees.free;
    InfoLigne.Free;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur dans CSV_To_ClientDataSet : ' + E.Message, True);
      Exit;
    end;
  end;
End;

procedure TDm_Loc.AjouterLog(Texte:String;Err:Boolean);
begin
  try
    if Err then
    begin
      AjouterLog('------------------------------------------------------------------');
      Log.Add(DateTimeToStr(Now) + '  ' + Texte);
      AjouterLog('------------------------------------------------------------------');
      ShowMessage('Erreur lors du traitement. Consulter les logs');
    end
    else
      Log.Add(DateTimeToStr(Now) + '  ' + Texte);

    Log.SaveToFile('c:\Log_Location.log');
  except
  end;
end;

end.

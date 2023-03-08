//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT RapRv_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  AlgolStdFrm,
  Printers,
  IBOPipelineUnit,
  Db,
  ppDB,
  ppBands,
  ppCache,
  ppClass,
  ppProd,
  ppReport,
  ppRptExp,
  ppEndUsr,
  ppComm,
  ppRelatv,
  ppDBPipe,
  ppDsgnDB,
  ppTypes,
  ppArchiv,
  ppModule,
  ppRTTI,
  ppCTDsgn,
  ppCTMain,
  ppCtrls,
  ppViewr,
  ppPrnabl,
  ppStrtch,
  ppMemo,
  ppVar,
  ppRegion,
  ppSubRpt,
  EuGen,
  TXtraDev,
  TXComp,
  BuilderControls,
  IBODataset,
  raCodMod,
  ppRichTx,
  ppBarCod,
  ppParameter,
  ppPageBreak, ImpDoc_Types, ConvertorRv;

TYPE
  TFacture = record
    Public
      Origine, IdToTwinner : Integer;
      ImpLine, ImpTva, ImpTailCoul, ImpRem, ImpVend, ImpTete, ImpPayMag, ImpPayClt,
      ImpPied, ImpPg, ImpTextePied, ImpEuro : Boolean;
      LabFactor, TxtFactor, TxtRgltDef, TxtFinFact, sMonnaieActuelle : String;
      TipFacRetro : TTypFac;
      TipFacLoc : TTypFac;
  end;

  TFrm_RapRV = CLASS(TAlgolStdFrm)
    ppr_RapRv: TPPReport;
    pip_RaprvLine: TppDBPipeline;
    pip_RaprvTet: TppDBPipeline;
    pip_RaprvDiv: TppDBPipeline;
    DS_RaprvLine: TDatasource;
    DS_RaprvTet: TDatasource;
    DS_RaprvDiv: TDatasource;
    ExtraOptions1: TExtraOptions;
    Que_HistoImp: TIBOQuery;
    Que_HistoImpHTI_ID: TIntegerField;
    Que_HistoImpHTI_MAGID: TIntegerField;
    Que_HistoImpHTI_DOCID: TIntegerField;
    Que_HistoImpHTI_TIPDOC: TIntegerField;
    Que_HistoImpHTI_DATEIMP: TDateTimeField;
    Que_HistoImpHTI_USRID: TIntegerField;
    Que_HistoImpHTI_MODIFIE: TIntegerField;
    Que_ParamImp: TIBOQuery;
    Que_ParamImpPRM_ID: TIntegerField;
    Que_ParamImpPRM_CODE: TIntegerField;
    Que_ParamImpPRM_INTEGER: TIntegerField;
    Que_ParamImpPRM_FLOAT: TIBOFloatField;
    Que_ParamImpPRM_STRING: TStringField;
    Que_ParamImpPRM_TYPE: TIntegerField;
    Que_ParamImpPRM_MAGID: TIntegerField;
    Que_ParamImpPRM_INFO: TStringField;
    ppTitleBand1: TppTitleBand;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppGrid_Tail: TSimpleGrid;
    ppFooterBand1: TppFooterBand;
    ppSummaryBand1: TppSummaryBand;
    ppPageStyle1: TppPageStyle;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppGroup3: TppGroup;
    ppGroupHeaderBand3: TppGroupHeaderBand;
    ppGroupFooterBand3: TppGroupFooterBand;
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppGroupFooterBand4: TppGroupFooterBand;
    ppGroup5: TppGroup;
    ppGroupHeaderBand5: TppGroupHeaderBand;
    ppGroupFooterBand5: TppGroupFooterBand;

    PROCEDURE Ppr_RapRvPreviewFormCreate(Sender: TObject);
    PROCEDURE Ppr_RapRvStartPage(Sender: TObject);
    PROCEDURE Ppr_RapRvBeforePrint(Sender: TObject);
    PROCEDURE ppDetailBand1AfterGenerate(Sender: TObject);
    PROCEDURE Que_HistoImpAfterPost(DataSet: TDataSet);
    PROCEDURE Que_HistoImpUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);

    { Attention ici il ne doit subsister une fois le rapport mis au point
    que les bandes et les procédures génériques à tous les rapports !
    tout le reste doit être viré ! dans le code spécifique on atteint les
    objets de façon relative à leur index....
    Aucune autre déclaration d'objet ici.  }

  PRIVATE
    DoInitCads, DefCad1, Defcad2, DefCad3: Boolean;
    CptDetail: Integer;
    RhtPied: Double;
    Rimptete: Boolean;
    RImpPied: Boolean;
    RImpPg: Boolean;
    RImpDate: Boolean;
    nbComent: integer;

    PROCEDURE SetGlobalParamImp(AMAGID : Integer);
    procedure FACppFooterBandCUMBeforePrint(Sender: TObject);
    procedure FACppHeaderBandCUMBeforePrint(Sender: TObject);
    procedure FACppTitleCumBeforePrint(Sender: TObject);
    procedure NegBPSummaryBand1BeforePrint(Sender: TObject);
    procedure NKRVBeforePrint;
    procedure NkRVDetailBand1BeforePrint(Sender: TObject);
    procedure NKRVGroupHeaderBand1BeforePrint(Sender: TObject);
    procedure NkRVGroupHeaderBand2BeforePrint(Sender: TObject);
    procedure NKRVHeaderBand1BeforePrint(Sender: TObject);

    { Private declarations }
  PROTECTED
    { Protected declarations }
  PUBLIC
    { Public declarations }
    FFacture : TFacture;
    Imp_QueTet   ,
    Imp_queLigne ,
    Imp_QueMags  : TIboQuery;
    Convertor, ConvertorEtik : TConvertorRv;
    GetIso : TGetIso;

    CadFirstPg, CadPg, CadLastPg: Integer;

    Letat: STRING;
    FirstLineOfPg: Boolean;
    FlagComent: Boolean;

    OkLinesTablo: Boolean;
    Tablo: ARRAY OF Integer;
    PROCEDURE Imprime(APdfName : String;ShowPreview, ChoixI: Boolean; AIsPdf : Boolean = False);
    PROCEDURE InitCadresPageStyle;

  PUBLISHED
    { Published declarations }
    PROCEDURE GetTextEuro(Sender: TObject; VAR Text: STRING);
    PROCEDURE GetTextEuroDevise(Sender: TObject; VAR Text: STRING);
    PROCEDURE GetTextAutreDevise(Sender: TObject; VAR Text: STRING);
    PROCEDURE PhoneGetText(Sender: TObject; VAR Text: STRING);

    // BonDeTransfert
//    PROCEDURE TRFDetailBeforePrint(Sender: TObject);
//    PROCEDURE TRFEnteteBeforePrint(Sender: TObject);
//    PROCEDURE TRFFooterBand1BeforePrint(Sender: TObject);
//    PROCEDURE TRFSummaryBand1BeforePrint(Sender: TObject);
//    PROCEDURE TRFTitleBand1BeforePrint(Sender: TObject);
    // Facture negoce
    PROCEDURE NegFacDetailBeforePrint(Sender: TObject);
    PROCEDURE NegFacEnteteBeforePrint(Sender: TObject);
    PROCEDURE NegFacTitleBand1BeforePrint(Sender: TObject);
    PROCEDURE NegFacFooterBand1BeforePrint(Sender: TObject);
    PROCEDURE NegFacSummaryBand1BeforePrint(Sender: TObject);
    // BL négoce
//    PROCEDURE NegBLDetailBeforePrint(Sender: TObject);
//    PROCEDURE NegBLEnteteBeforePrint(Sender: TObject);
//    PROCEDURE NegBLTitleBand1BeforePrint(Sender: TObject);
//    PROCEDURE NegBLFooterBand1BeforePrint(Sender: TObject);
//    PROCEDURE NegBLSummaryBand1BeforePrint(Sender: TObject);
    // Devis négoce
//    PROCEDURE NegDevDetailBeforePrint(Sender: TObject);
//    PROCEDURE NegDevEnteteBeforePrint(Sender: TObject);
//    PROCEDURE NegDevTitleBand1BeforePrint(Sender: TObject);
//    PROCEDURE NegDevFooterBand1BeforePrint(Sender: TObject);
//    PROCEDURE NegDevSummaryBand1BeforePrint(Sender: TObject);
    // Bon prépa négoce
//    PROCEDURE NegBPDetailBeforePrint(Sender: TObject);
//    PROCEDURE NegBPEnteteBeforePrint(Sender: TObject);
//    PROCEDURE NegBPTitleBand1BeforePrint(Sender: TObject);
//    PROCEDURE NegBPFooterBand1BeforePrint(Sender: TObject);
//    PROCEDURE NegBPSummaryBand1BeforePrint(Sender: TObject);

    // Noté en devis mais pointé par BL et facture
    PROCEDURE NegDevTitleBand1BeforeGenerate(Sender: TObject);
    PROCEDURE NegDevHeaderBand1BeforeGenerate(Sender: TObject);
    PROCEDURE NegDevSummaryBand1BeforeGenerate(Sender: TObject);
    PROCEDURE NegDevStartPage;

    // Nomenclature
//    PROCEDURE NKRVHeaderBand1BeforePrint(Sender: TObject);
//    PROCEDURE NKRVGroupHeaderBand1BeforePrint(Sender: TObject);
//    PROCEDURE NKRVGroupHeaderBand2BeforePrint(Sender: TObject);
//    PROCEDURE NKRVDetailBand1BeforePrint(Sender: TObject);
//    PROCEDURE NKRVBeforePrint;

    // BCDE
//    PROCEDURE BCDEppDetailBand1BeforePrint(Sender: TObject);
//    PROCEDURE BCDEppTitleBand1BeforePrint(Sender: TObject);
//    PROCEDURE BCDEFooterBand1BeforePrint(Sender: TObject);
    // Annul
//    PROCEDURE AnnulppDetailBand1BeforePrint(Sender: TObject);
//    PROCEDURE AnnulppTitleBand1BeforePrint(Sender: TObject);
//    PROCEDURE AnnulppTitleBand1AfterGenerate(Sender: TObject);
//    PROCEDURE ANNULFooterBand1BeforePrint(Sender: TObject);

    // RETOURFOURN
//    PROCEDURE RETFppDetailBand1BeforePrint(Sender: TObject);
//    PROCEDURE RETFppHeaderBand1BeforePrint(Sender: TObject);
//    PROCEDURE RETFppTitleBand1BeforePrint(Sender: TObject);

    // CUMDocs
//    PROCEDURE FACppTitleCumBeforePrint(Sender: TObject);
//    PROCEDURE FACppHeaderBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE FACppFooterBandCUMBeforePrint(Sender: TObject);
//
//    PROCEDURE BLppTitleBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE BLppHeaderBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE BLppFooterBandCUMBeforePrint(Sender: TObject);
//
//    PROCEDURE DEVppTitleBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE DEVppHeaderBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE DEVppFooterBandCUMBeforePrint(Sender: TObject);
//
//    PROCEDURE BPppTitleBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE BPppHeaderBandCUMBeforePrint(Sender: TObject);
//    PROCEDURE BPppFooterBandCUMBeforePrint(Sender: TObject);
  END;

VAR
  Frm_RapRV: TFrm_RapRV;
  ExisteRapRv: Boolean = False;
FUNCTION ChargeRap(Tete, Lines, Divs: TDataset; TabloLines: Boolean; Rapport: STRING; HtPiedPage: extended = 0): Boolean;

IMPLEMENTATION

USES
  ginkoiaresStr,
  StdCalcs,
  Main_Dm,
  StdUtils;

//  Uil_Dm,
//  GinkoiaStd,
//  negBL_Dm,
//  negFac_dm,
//  negDev_dm,
//  NkRv_Frm, // (Obsolete)
//  ImpBcde_Dm,
//  Ral_Dm,
//  RapMail_Frm,
//  BonPrepa_dm; //lab 08/07/08

{$R *.DFM}

// Procédures standard de fonctionnement;
// **************************************

FUNCTION ChargeRap(Tete, Lines, Divs: TDataset; TabloLines: Boolean; Rapport: STRING; HtPiedPage: extended = 0): Boolean;
VAR
  sCheminPdf: STRING; //lab 08/07/08 chemin de sauvegarde du pdf
BEGIN
  TRY
    Result := False;
//    IF NOT ExisteRapRv THEN
//      Application.CreateForm(TFrm_raprv, Frm_Raprv);
//    ExisteRapRv := True;
    WITH Frm_RapRv DO
    BEGIN

      // Gestion du tablo repérant la dernière bande détail imprimée
      // de chaque page...
      DoInitCads := False;
      setLength(Tablo, 1);
      Tablo[0] := 0;
      SetGlobalParamImp(Imp_QueMags.FieldByName('MAG_ID').AsInteger);

      OkLinesTablo := TabloLines;

      TRY
        Ppr_raprv.SavePrinterSetup := True; // stdGinkoia.FlagSavePrinterSetup_RapRV; // CBR - Modif - 10/04/2013 - CR:2000

        Ppr_raprv.Template.FileName :=  GFACPATH + Rapport; // StdGinkoia.PathRapport + Rapport;
        Ppr_raprv.Template.LoadFromFile;

        IF Tete = NIL THEN Tete := Lines;
        IF Lines = NIL THEN Lines := Tete;

        Ppr_raprv.OnPreviewFormCreate := Ppr_RapRvPreviewFormCreate;
        Ppr_raprv.DataPipeline := Pip_RapRvLine;
        ppr_RapRv.PrinterSetup.printerName := Printer.Printers[0]; //Printer.PrinTerIndex];

        Ds_RapRvTet.dataset := Tete;
        Ds_RapRvLine.dataset := Lines;
        Ds_RapRvDiv.dataset := Divs;

        Letat := Uppercase(Copy(Rapport, 1, Pos('.', Rapport) - 1));

        IF HtPiedPage > 0 THEN
        BEGIN
          IF ppSummaryBand1.PrintPosition > 0 THEN
            ppSummaryBand1.PrintPosition := ppSummaryBand1.PrintPosition - (HtPiedPage - ppFooterBand1.Height);
          ppFooterBand1.Height := HtPiedPage;
        END;

        defcad1 := False;
        defcad2 := False;
        defcad3 := False;

        Result := True;
      FINALLY
      END;
    END;
  EXCEPT
    RAISE;
  END;

END;

PROCEDURE TFrm_RapRv.SetGlobalParamImp(AMAGID : Integer);
VAR
  ch: STRING;
  i, j: Integer;
BEGIN

  TRY
    Que_ParamIMP.Close;
    que_ParamIMP.ParamByName('MAGID').asInteger := AMAGID;
    Que_ParamIMP.Open;

    IF que_ParamImp.IsEmpty THEN
    BEGIN
      RhtPied := 11.642;
      Rimptete := True;
      RImpPied := True;
      RImpPg := True;
      RImpDate := True;
    END
    ELSE BEGIN

      IF Que_ParamImp.Locate('PRM_CODE', 1, []) THEN
      BEGIN
        ch := que_ParamImpPRM_STRING.asstring;
        RHtPied := que_ParamImpPRM_FLOAT.asFloat;
      END
      ELSE
      BEGIN
        FOR j := 1 TO 100 DO
          ch := ch + '1';
        RHtPied := 11.642;
      END;

      IF ch[1] = '1' THEN
        RImpTete := True
      ELSE
        RImpTete := False;

      IF ch[2] = '1' THEN
        RImpPied := True
      ELSE
        RImpPied := False;

      IF ch[4] = '1' THEN
        RImpPg := True
      ELSE
        RImpPg := False;

      IF ch[22] = '1' THEN
        RImpDate := True
      ELSE
        RImpDate := False;
    END;
  FINALLY
    Que_ParamImp.Close;
  END;
END;

PROCEDURE TFrm_RapRv.Imprime(APdfName : String; ShowPreview, ChoixI, AIsPdf : Boolean);
VAR
  sCheminPdf: STRING;
BEGIN
  nbComent := 0;
  Ppr_RapRv.ShowPrintDialog := ChoixI;
  IF ShowPreview THEN
    Ppr_RapRv.DeviceType := dtScreen
  ELSE
    //lab 08/07/08
  BEGIN
    //si option pdf par e-mail cochée
    IF {(stdGinkoia.apdfEmail.pdfByEmail) OR} AIsPdf THEN // FC 02/03/09 : Print to PDF, sans envoi de mail
    BEGIN
      //créer le pdf
      ppr_RapRv.DeviceType := 'PDFFile';
      ppr_RapRv.allowPrintTofile := true;
      ppr_RapRv.TextFileName := APdfName; // FC 02/03/09 : Print to PDF, sans envoi de mail
    END
      //sinon envoyer sur l'imprimante
    ELSE
    BEGIN
      Ppr_RapRv.DeviceType := dtPrinter;
    END;
  END;

  //intercepter la violation d'accès du composant ppReport
  TRY
    //imprimer
    Ppr_RapRv.Print;

  Except on E:Exception do
    raise Exception.Create('  Imprime -> ' + E.Message);
  END;
END;


PROCEDURE TFrm_RapRV.Ppr_RapRvPreviewFormCreate(Sender: TObject);
BEGIN
  ppr_RapRv.PreviewForm.WindowState := wsMaximized;
  TppViewer(ppr_RapRv.PreviewForm.viewer).ZoomPercentage := 100;
  TppViewer(ppr_RapRv.PreviewForm.viewer).ZoomSetting := zsPercentage;
END;

PROCEDURE TFrm_RapRV.GetTextEuro(Sender: TObject; VAR Text: STRING);
VAR
  name: ShortString;
BEGIN
  name := TppDbText(sender).DataField;
  //si ne s'agit pas d'un champs du 'cartouche tva' forcer les montants vide à '0.00'
  IF (pos('TVA', TppDbText(sender).DataField) = 0)
    AND (pos('HT1', TppDbText(sender).DataField) = 0) AND (pos('HT2', TppDbText(sender).DataField) = 0)
    AND (pos('HT3', TppDbText(sender).DataField) = 0) AND (pos('HT4', TppDbText(sender).DataField) = 0) AND (pos('HT5', TppDbText(sender).DataField) = 0) THEN
  BEGIN
    IF StrToFloatTry(Text) = 0 THEN
      Text := '0.00' //lab 27/10/08 afficher 0.00 au lieu de vide
    ELSE
      Text := Convertor.Convert(StrToFloatTry(Text));
  END
  ELSE //s'il s'agit d'un champs du cartouche tva arrondir les montant à 2 chiffres
  BEGIN
    IF StrToFloatTry(Text) <> 0 THEN
      Text := Convertor.Convert(StrToFloatTry(Text));
  END
END;

PROCEDURE TFrm_RapRV.GetTextEuroDevise(Sender: TObject; VAR Text: STRING);
VAR
  ch, sTmp: STRING;
BEGIN
  IF GetIso(Convertor.MnyRef) <> 'EUR' THEN
    ch := ' ' + DevisePays
  ELSE
  BEGIN
    //lab 15/07/08 si envoie pdf par e-mail, le symbole € de deviseEuro n'est pas transformé dans le document pdf. Mettre en toute lettre EUR
    IF {(StdGinKoia.aPdfEmail.pdfByEmail) OR} (FFaCture.sMonnaieActuelle <> 'EUR') THEN
    BEGIN
      ch := ' ' + FFaCture.sMonnaieActuelle;
    END
    ELSE
    BEGIN
      ch := ' ' + DeviseEuro;
    END;
  END;

  sTmp := Convertor.Convert(strToFloatTry(Text));
  IF strToFloatTry(sTmp) = 0 THEN
    sTmp := '';
  Text := sTmp;
  IF abs(strToFloatTry(text)) < 0.01 THEN
    Text := '0.00' + ch //lab 27/10/08 afficher 0.00 au lieu de vide
  ELSE
    Text := Text + ch;
END;

PROCEDURE TFrm_RapRV.GetTextAutreDevise(Sender: TObject; VAR Text: STRING);
VAR
  ch: STRING;
BEGIN
  IF GetIso(Convertor.MnyRef) <> 'EUR' THEN
    ch := ' ' + DeviseEuro
  ELSE
    ch := ' ' + DevisePays;
  Text := ConvertorEtik.Convert(StrToFloatTry(Text));
  IF Abs(strtoFloatTry(text)) < 0.01 THEN
    Text := '0.00' //lab 27/10/08 afficher 0.00 au lieu de vide
  ELSE
    Text := text + ch;
END;

PROCEDURE TFrm_RapRV.Ppr_RapRvStartPage(Sender: TObject);
BEGIN
  FirstLineOfPg := True;
  FlagComent := False;
  IF OkLinesTablo AND (NOT ppr_Raprv.SecondPass) THEN
  BEGIN
    IF High(Tablo) < ppr_RapRv.AbsolutePageNo THEN
      setLength(Tablo, ppr_RapRv.AbsolutePageNo + 1);

    Tablo[ppr_RapRv.AbsolutePageNo] := 0;
    CptDetail := 0;
  END;

  IF Copy(Letat, 1, 5) = 'DEVIS' THEN NegDevStartPage;
  IF Copy(Letat, 1, 7) = 'BONLIVR' THEN NegDevStartPage;
  IF Copy(Letat, 1, 7) = 'FACTURE' THEN NegDevStartPage;
  IF Copy(Letat, 1, 5) = 'BTTRF' THEN NegDevStartPage;
  IF Copy(Letat, 1, 7) = 'BONPREPA' THEN NegDevStartPage;

END;

PROCEDURE TFrm_RapRV.Ppr_RapRvBeforePrint(Sender: TObject);
VAR
  Lid, Ldoc: Integer;
  MAG_ID, USR_ID : integer;
BEGIN
  Ldoc := 0;
  IF Copy(Letat, 1, 4) = 'NKRV' THEN NKRVBeforePrint;
//  IF Copy(Letat, 1, 5) = 'DEVIS' THEN
//    ppSummaryBand1.Visible := Dm_NegDev.ImpSumDev;

  IF (Copy(Letat, 1, 5) = 'DEVIS') OR
    (Copy(Letat, 1, 7) = 'BONLIVR') OR
    (Copy(Letat, 1, 5) = 'BTTRF') OR
    (Copy(Letat, 1, 7) = 'FACTURE') OR
    (Copy(Letat, 1, 8) = 'BONPREPA') THEN InitCadresPageStyle;

  IF (Copy(Letat, 1, 5) = 'DEVIS') THEN
  BEGIN
//    ppTitleBand1.Visible := Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId;
//    ppFooterBand1.Visible := Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId;
//    ppSummaryBand1.Visible := Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId;
  END;

  IF (Ppr_RapRv.DeviceType = 'Printer') OR (Ppr_RapRv.DeviceType = 'PDFFile') THEN
  BEGIN

    Lid := 0;
    IF (Copy(Letat, 1, 5) = 'DEVIS') THEN
    BEGIN
      // pas d'histo pour les modèles
//      IF Dm_NegDev.Que_TetImpNPR_CODE.asInteger <> 100 THEN
//      BEGIN
//        Lid := Dm_NegDev.Que_TetImpDVE_ID.asInteger;
//        LDoc := 1;
//      END;
    END;
    IF (Copy(Letat, 1, 7) = 'BONLIVR') THEN
    BEGIN
//      Lid := Dm_NegBL.Que_TetImpBLE_ID.asInteger;
      LDoc := 2;
    END;
    IF (Copy(Letat, 1, 7) = 'FACTURE') THEN
    BEGIN
      // pas d'histo sur les modèles
      IF Imp_QueTet.fieldByName('FCE_MODELE').asInteger = 0 THEN
//      IF Dm_NegFac.Que_TetImpFCE_MODELE.asInteger = 0 THEN
      BEGIN
        Lid := Imp_QueTet.fieldByName('FCE_ID').asInteger;
//        Lid := Dm_NegFac.Que_TetImpFCE_ID.asInteger;
        LDoc := 3;
      END;
    END;
    IF (Uppercase(Copy(Letat, 1, 5)) = 'BCDES') THEN
    BEGIN
//      Lid := dm_ImpBcde.Que_ImpTet.ParamByName('CDEID').asInteger;
      LDoc := 4;
    END;
    IF (Uppercase(Copy(Letat, 1, 5)) = 'ANNUL') THEN
    BEGIN
//      Lid := dm_Ral.Que_ImpTet.ParamByName('ANUID').asInteger;
      LDoc := 5;
//      IF dm_Ral.que_ImpTetANU_ENVOYE.asInteger = 0 THEN
//        dm_Ral.Str_CtrlEnvoye.strings.add(dm_Ral.que_ImpTetANU_ID.asString);
    END;
    IF (Uppercase(Copy(Letat, 1, 4)) = 'RETF') THEN
    BEGIN
      Lid := ds_RapRvTet.Dataset.FieldByName('RET_ID').asInteger;
      LDoc := 6;
    END;

    IF (Copy(Letat, 1, 8) = 'BONPREPA') THEN
    BEGIN
      Lid := ds_RapRvTet.dataset.FieldByName('BLE_ID').asInteger;
      LDoc := 7;
    END;

    IF Lid <> 0 THEN
    BEGIN

      TRY
        IF (Copy(Letat, 1, 7) = 'FACTURE') THEN
        begin
          MAG_ID := Imp_QueMags.FieldByName('MAG_ID').AsInteger;
          USR_ID := Imp_QueTet.FieldByName('FCE_USRID').AsInteger;
        end;

        que_HistoImp.Close;
        que_HistoImp.Open;
        que_HistoImp.Insert;
        IF NOT Dm_Main.IBOMajPkKey(Que_HistoImp, 'HTI_ID') THEN
          que_HistoImp.Cancel
        ELSE BEGIN
          que_HistoImpHTI_MAGID.asInteger := MAG_ID;
          que_HistoImpHTI_DOCID.asInteger := Lid;
          que_HistoImpHTI_TIPDOC.asInteger := LDoc;
          que_HistoImpHTI_DATEIMP.asDateTime := Now;
          que_HistoImpHTI_USRID.asInteger := USR_ID;
          que_HistoImpHTI_MODIFIE.asInteger := 0;
          que_HistoImp.Post;
        END;
      FINALLY
        que_HistoImp.Close;
      END;
    END;
  END;

END;

PROCEDURE TFrm_RapRV.InitCadresPageStyle;
BEGIN
  IF doInitCads THEN EXIT;
  DoInitCads := True;
  WITH PPr_Raprv.PrinterSetup DO
    ppPageStyle1.Height := PaperHeight - (MarginBottom + MarginTop);

  ppPageStyle1.ObjectByName(CadFirstPg, 'Cads1');
  ppPageStyle1.ObjectByName(CadPg, 'Cads2');
  ppPageStyle1.ObjectByName(CadLastPg, 'Cads3');

  ppPageStyle1.Objects[CadFirstPg].Visible := False;
  ppPageStyle1.Objects[CadPg].Visible := False;
  ppPageStyle1.Objects[CadLastPg].Visible := False;

  WITH (ppPageStyle1.Objects[CadFirstPg] AS TppShape) DO
  BEGIN
    Left := 0;
    Top := 0;
    Width := 187.061;
  END;
  WITH (ppPageStyle1.Objects[CadPg] AS TppShape) DO
  BEGIN
    Left := 0;
    Top := 0;
    Width := 187.061;
  END;
  WITH (ppPageStyle1.Objects[CadLastPg] AS TppShape) DO
  BEGIN
    Left := 0;
    Top := 0;
    Width := 187.061;
  END;

END;

PROCEDURE TFrm_RapRV.ppDetailBand1AfterGenerate(Sender: TObject);
BEGIN
  FirstLineOfPg := False;
  IF OkLinesTablo AND (NOT Ppr_RapRV.SecondPass) THEN
    Inc(Tablo[ppr_RapRv.AbsolutePageNo]);

  { si besoin de gérer un évent spécifique de ce type dans le rapport
    chaîner sur une proc perso comme suit ...
     IF Copy(Letat,1,5) = 'DEVIS' THEN  NegDevAfterGenerate;
    Voir ce que j'ai fait juste au dessus. Cela n'a d'intéret que de regrouper
    le code de chaque rapport... }

END;

// ********************************************************
// Procédures spécifiques aux éditions à ranger par module
// ********************************************************

{_________________ FACTURES NEGOCE ____________________________________________}

PROCEDURE TFrm_RapRV.NegFacDetailBeforePrint(Sender: TObject);
VAR
  i: Integer;
  com, lmg, lmd, lbs, lht, tail, coul, ref: Integer;
  rm, dtva, LT, LC, st, vc, mtl: Integer;
BEGIN
  ppdetailBand1.Visible := Imp_queLigne.FieldByName('FCL_GPSSTOTAL').AsInteger = 0;
//    dm_NegFac.que_LineImpFCL_GPSSTOTAL.asInteger = 0;

  ppdetailBand1.ObjectByName(rm, 'ppChp_Remise');

  ppdetailBand1.ObjectByName(ST, 'ppChp_Soustot');
  ppdetailBand1.ObjectByName(mtl, 'ppChp_MTLine');
  ppdetailBand1.ObjectByName(VC, 'ppChp_ValComent');
  ppdetailBand1.ObjectByName(com, 'ppChp_Coment');
  ppdetailBand1.ObjectByName(lmg, 'LineMG');
  ppdetailBand1.ObjectByName(lmd, 'LineMD');
  ppdetailBand1.ObjectByName(lbs, 'LineBas');
  ppdetailBand1.ObjectByName(lht, 'LineHaut');

  ppdetailBand1.ObjectByName(tail, 'ppChp_Taille');
  ppdetailBand1.ObjectByName(coul, 'ppChp_Coul');
  ppdetailBand1.ObjectByName(ref, 'ppChp_Ref');

  ppdetailBand1.ObjectByName(LT, 'LineTail');
  ppdetailBand1.ObjectByName(LC, 'LineCoul');

  ppdetailBand1.Objects[st].Visible := False;
  ppdetailBand1.Objects[vc].Visible := False;
  ppdetailBand1.Objects[mtl].Visible := True;

  ppdetailBand1.ObjectByName(dtva, 'ppChp_DetTVA');
  ppDetailBand1.Objects[dtva].visible := True;

  if Imp_QueTet.FieldByName('FCE_DETAXE').AsInteger = 1 then
//  IF dm_NegFAC.Que_TetImpFCE_DETAXE.asInteger = 1 THEN
    ppDetailBand1.Objects[dtva].visible := False;

  ppdetailBand1.Objects[com].Font.Style := [];
  IF (ppdetailBand1.Objects[com] AS TppDBMemo).Lines.Count > 1 THEN
  BEGIN
    if Imp_queLigne.FieldByName('FCL_LINETIP').AsInteger = 0 then
//    IF Dm_NegFac.que_LineImpFCL_LINETIP.AsInteger = 0 THEN
      ppdetailBand1.Objects[com].Font.Size := 10
    ELSE
      ppdetailBand1.Objects[com].Font.Size := 9;
  END
  ELSE
    ppdetailBand1.Objects[com].Font.Size := 8;

  ppdetailBand1.Objects[com].Left := 23.813;

  if FFacture.Origine = 2 then
//  IF StdGinkoia.Origine = 2 THEN // BRUN
    ppdetailBand1.Objects[com].Width := 94
  ELSE
    ppdetailBand1.Objects[com].Width := 60;

  if Imp_queLigne.FieldByName('FCL_LINETIP').AsInteger <> 0 then
//  IF Dm_NegFac.que_LineImpFCL_LINETIP.AsInteger <> 0 THEN
  BEGIN
    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
    BEGIN
      IF (i = com) OR (i = lmg) OR (i = lmd) THEN
        ppdetailBand1.Objects[i].Visible := True
      ELSE
        ppdetailBand1.Objects[i].Visible := False;
    END;

    ppdetailBand1.Objects[mtl].Visible := False;
    ppdetailBand1.Objects[st].Visible := (Imp_queLigne.FieldByName('FCL_PXNN').AsFloat <> 0) And
                                         (Imp_queLigne.FieldByName('FCL_LINETIP').AsInteger = 3);
//      (dm_negFac.Que_LineImpFCL_PXNN.asFloat <> 0) AND
//      (Dm_NegFac.que_LineImpFCL_LINETIP.AsInteger = 3);

    ppdetailBand1.Objects[vc].Visible := (Imp_queLigne.FieldByName('FCL_PXBRUT').AsFloat <> 0) and
                                         (Imp_queLigne.FieldByName('FCL_LINETIP').AsInteger in [1,4]);
//      (dm_negFac.Que_LineImpFCL_PXBRUT.asFloat <> 0) AND
//      (Dm_NegFac.que_LineImpFCL_LINETIP.AsInteger IN [1, 4]);
    case Imp_queLigne.FieldByName('FCL_LINETIP').AsInteger of
//    CASE Dm_NegFac.que_LineImpFCL_LINETIP.AsInteger OF
      1:
        BEGIN
          ppdetailBand1.Objects[Com].Width := 142;
          ppdetailBand1.Objects[com].Font.Style := [];
          ppdetailBand1.Objects[st].Font.Size := 8;
          ppdetailBand1.Objects[st].Font.Style := [];
          ppdetailBand1.Objects[vc].Font.Size := 8;
          ppdetailBand1.Objects[vc].Font.Style := [];
        END;
      2:
        BEGIN
          ppdetailBand1.Objects[Com].Width := 165;
          ppdetailBand1.Objects[com].Left := 1;
          ppdetailBand1.Objects[com].Font.Style := [fsBold];
          ppdetailBand1.Objects[com].Font.Size := 10;
          ppdetailBand1.Objects[st].Font.Size := 10;
          ppdetailBand1.Objects[st].Font.Style := [];
          ppdetailBand1.Objects[vc].Font.Size := 10;
          ppdetailBand1.Objects[vc].Font.Style := [];
        END;
      3:
        BEGIN
          ppdetailBand1.Objects[Com].Width := 142;
          ppdetailBand1.Objects[com].Left := 1;
          ppdetailBand1.Objects[com].Font.Size := 10;
          ppdetailBand1.Objects[st].Font.Size := 10;
          ppdetailBand1.Objects[vc].Font.Size := 10;
          ppdetailBand1.Objects[com].Font.Style := [];
          ppdetailBand1.Objects[st].Font.Style := [];
          ppdetailBand1.Objects[vc].Font.Style := [];
          ppdetailBand1.Objects[rm].Visible := True;
        END;
      4:
        BEGIN
          ppdetailBand1.Objects[Com].Width := 165;
          ppdetailBand1.Objects[com].Left := 1;
          ppdetailBand1.Objects[com].Font.Size := 10;
          ppdetailBand1.Objects[st].Font.Size := 10;
          ppdetailBand1.Objects[vc].Font.Size := 10;
          ppdetailBand1.Objects[com].Font.Style := [];
          ppdetailBand1.Objects[st].Font.Style := [];
          ppdetailBand1.Objects[vc].Font.Style := [];
        END;

    END;

    IF NOT FirstLineOfPg AND (NOT FlagComent) THEN
      ppdetailBand1.Objects[lht].Visible := True;

    FlagComent := True;
  END
  ELSE
  BEGIN
    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
    BEGIN
      if FFacture.Origine = 2 then
      //IF stdGinkoia.Origine = 2 THEN // brun
      BEGIN
        IF (i = tail) OR (i = coul) OR (i = LT) OR (i = LC) OR
          (i = lht) OR (i = vc) OR (i = st) THEN
          ppdetailBand1.Objects[i].Visible := False
        ELSE
          ppdetailBand1.Objects[i].Visible := True;
      END
      ELSE
      BEGIN
        IF (i = lht) OR (i = st) OR (i = VC) THEN
          ppdetailBand1.Objects[i].Visible := False
        ELSE
          ppdetailBand1.Objects[i].Visible := True;
      END;
    END;

    if Imp_queLigne.FieldByName('FCL_SSTOTAL').AsInteger <> 0 then
//    IF Dm_NegFac.que_LineImpFCL_SSTOTAL.asInteger <> 0 THEN
      ppdetailBand1.Objects[rm].Visible := False;

    FlagComent := False;
  END;

  ppdetailBand1.Objects[lbs].Visible := True;

  IF ppr_RapRv.SecondPass THEN
  BEGIN
    IF ppdetailband1.visible THEN Inc(cptDetail);
    IF CptDetail = Tablo[ppr_RapRv.AbsolutePageNo] THEN
    BEGIN
      //      IF FlagComent THEN
//      BEGIN
        ppdetailBand1.Objects[lbs].Visible := true;
        //remettre le compteur de ligne de la page à 0
        CptDetail := 0;
//      END;;
    END
    ELSE
      IF NOT FlagComent THEN ppdetailBand1.Objects[lbs].Visible := False;
  END;

  IF NOT FFacture.ImpLine THEN
    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
      IF Uppercase(Copy(ppdetailBand1.Objects[i].Name, 1, 4)) = 'LINE' THEN
        ppdetailBand1.Objects[i].Visible := False;

END;

PROCEDURE TFrm_RapRV.NegFacEnteteBeforePrint(Sender: TObject);
VAR
  Exprt, f1, f2, f3, f4, pxu, mt, n, ec, et, elr, elt, rm: Integer;
  ctva, ltva, labtva, chptva: Integer;
  labclt, nm, dt, des, etva, eqt, vu, vd, lvd,
    usrTel, usrFax, usrGsm, usrEmail, Empl: Integer;

BEGIN
  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
  //ppHeaderBand1.ObjectByName(ref, 'Entet_Ref');
  ppHeaderBand1.ObjectByName(des, 'Entet_Des');
//  ppHeaderBand1.ObjectByName(Empl, 'Entet_Empl');
  ppHeaderBand1.ObjectByName(etva, 'Entet_Tva');
  ppHeaderBand1.ObjectByName(eqt, 'Entet_Qte');

  ppHeaderBand1.ObjectByName(pxu, 'Entet_Pxu');
  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');
  ppHeaderBand1.ObjectByName(ec, 'Entet_Coul');
  ppHeaderBand1.ObjectByName(et, 'Entet_Tail');
  ppHeaderBand1.ObjectByName(rm, 'Entet_Rem');
  ppHeaderBand1.ObjectByName(mt, 'Entet_Mt');

  //lab 16/10/08 786 Coordonnées utilisateurs
  ppHeaderBand1.ObjectByName(vd, 'ppChp_UserName');
  ppHeaderBand1.ObjectByName(lvd, 'LabVendeur');
  ppHeaderBand1.ObjectByName(vu, 'ppChp_UsrVend');
  ppHeaderBand1.ObjectByName(usrTel, 'ppChp_USRTEL');
  ppHeaderBand1.ObjectByName(usrFax, 'ppChp_USRFAX');
  ppHeaderBand1.ObjectByName(usrGsm, 'ppChp_USRGSM');
  ppHeaderBand1.ObjectByName(usrEmail, 'ppChp_USREMAIL');
  (ppHeaderBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;

  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
  //(ppHeaderBand1.Objects[ref] AS TppLabel).Caption := Negtetref;
  (ppHeaderBand1.Objects[des] AS TppLabel).Caption := Negtetdes;
//  (ppHeaderBand1.Objects[Empl] AS TppLabel).Caption := NegTetEmpl;
  (ppHeaderBand1.Objects[etva] AS TppLabel).Caption := Negtettva;
  (ppHeaderBand1.Objects[eqt] AS TppLabel).Caption := Negtetqte;

  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;
  (ppHeaderBand1.Objects[ec] AS TppLabel).Caption := Negtetcoul;
  (ppHeaderBand1.Objects[et] AS TppLabel).Caption := NegtetTail;
  (ppHeaderBand1.Objects[rm] AS TppLabel).Caption := NegtetRem;

  ppHeaderBand1.ObjectByName(n, 'ppLab_NFac');
  ppHeaderBand1.ObjectByName(Exprt, 'ppLab_Export');
  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
  ppHeaderBand1.ObjectByName(elr, 'Entet_LCoul');
  ppHeaderBand1.ObjectByName(elt, 'Entet_LTail');

  ppHeaderBand1.ObjectByName(f1, 'Factor_Cadre');
  ppHeaderBand1.ObjectByName(f2, 'Factor_Line');
  ppHeaderBand1.ObjectByName(f3, 'Factor_Codeclt');
  ppHeaderBand1.ObjectByName(f4, 'Factor_Lab');

  (ppHeaderBand1.Objects[f4] AS TppLabel).Caption := FFActure.LabFactor;

  (ppHeaderBand1.Objects[f4] AS TppLabel).Caption := NegTetFactor;
  //-------------------------------------------_
  ppHeaderBand1.Objects[etva].visible := True;
  if Imp_QueTet.FieldByName('FCE_DETAXE').AsInteger = 1 then
//  IF dm_NegFac.Que_TetImpFCE_DETAXE.asInteger = 1 THEN
  BEGIN
    ppHeaderBand1.Objects[etva].visible := False;
    ppHeaderBand1.Objects[Exprt].visible := True;
  END
  ELSE ppHeaderBand1.Objects[Exprt].visible := False;

  IF FFacture.ImpTva THEN
  BEGIN
    ppHeaderBand1.Objects[ctva].visible := True;
    ppHeaderBand1.Objects[ltva].visible := True;
    ppHeaderBand1.Objects[labtva].visible := True;
    ppHeaderBand1.Objects[chptva].visible := True;
  END
  ELSE BEGIN
    ppHeaderBand1.Objects[ctva].visible := False;
    ppHeaderBand1.Objects[ltva].visible := False;
    ppHeaderBand1.Objects[labtva].visible := False;
    ppHeaderBand1.Objects[chptva].visible := False;
  END;

  if Imp_QueTet.FieldByName('FCE_FACTOR').AsInteger = 1 then
//  IF dm_NegFac.Que_TetImpFCE_FACTOR.asInteger = 1 THEN
  BEGIN
    ppHeaderBand1.Objects[f1].visible := True;
    ppHeaderBand1.Objects[f2].visible := True;
    ppHeaderBand1.Objects[f3].visible := True;
    ppHeaderBand1.Objects[f4].visible := True;
  END
  ELSE
  BEGIN
    ppHeaderBand1.Objects[f1].visible := False;
    ppHeaderBand1.Objects[f2].visible := False;
    ppHeaderBand1.Objects[f3].visible := False;
    ppHeaderBand1.Objects[f4].visible := False;
  END;

  if Imp_QueTet.FieldByName('FCE_HTWORK').AsInteger = 0 then
//  IF Dm_NegFac.Que_TetImpFCE_HTWORK.asInteger = 0 THEN
  BEGIN
    //        (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuTTC;
    (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuHT;
    (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtTTC;
  END
  ELSE
  BEGIN
    (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuHT;
    (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtHT;
  END;

  if Imp_QueTet.FieldByName('TOTTTC').AsFloat < 0 then
//  IF Dm_NegFac.Que_TetImpTOTTTC.asFloat < 0 THEN
    (ppHeaderBand1.Objects[n] AS TppLabel).Caption := AvoirLib
  ELSE
  BEGIN
    if Imp_QueTet.FieldByName('FCE_TYPID').AsInteger = FFActure.TipFacRetro.Id then
//    IF Dm_NegFac.Que_TetImpFCE_TYPID.asInteger = Dm_NegFac.TipFacRetro THEN
      (ppHeaderBand1.Objects[n] AS TppLabel).Caption := FacRetroLib
    ELSE
      (ppHeaderBand1.Objects[n] AS TppLabel).Caption := FacLib;
  END;

  (ppHeaderBand1.Objects[n] AS TppLabel).Visible := ppr_raprv.absolutePageNo = 1;

  // Paramétrage des entêtes de pages

  IF FFActure.Origine = 2 THEN // BRUN
  BEGIN
    ppHeaderBand1.Objects[ec].visible := False;
    ppHeaderBand1.Objects[et].visible := False;
    ppHeaderBand1.Objects[elr].visible := False;
    ppHeaderBand1.Objects[elt].visible := False;
  END
  ELSE
  BEGIN

    IF FFActure.ImpTailCoul THEN
    BEGIN
      ppHeaderBand1.Objects[ec].visible := True;
      ppHeaderBand1.Objects[et].visible := True;
    END
    ELSE BEGIN
      ppHeaderBand1.Objects[ec].visible := False;
      ppHeaderBand1.Objects[et].visible := False;
    END;

    ppHeaderBand1.Objects[elr].visible := True;
    ppHeaderBand1.Objects[elt].visible := True;
  END;

  IF FFacture.ImpRem THEN
    ppHeaderBand1.Objects[rm].visible := True
  ELSE
    ppHeaderBand1.Objects[rm].visible := False;

  ppHeaderBand1.Objects[vd].Visible := False;
  ppHeaderBand1.Objects[vu].Visible := False;
  //ppHeaderBand1.Objects[lvd].Visible := False;
  //lab 16/10/08 786  Plus de détail sur l'utilisateur
  ppHeaderBand1.Objects[usrTel].Visible := False;
  ppHeaderBand1.Objects[usrFax].Visible := False;
  ppHeaderBand1.Objects[usrGsm].Visible := False;
  ppHeaderBand1.Objects[usrEmail].Visible := False;
  IF FFacture.ImpVend THEN
    if Imp_QueTet.FieldByName('USR_FULLNAME').AsString <> '' then
//    IF dm_negFAC.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
    BEGIN
      ppHeaderBand1.Objects[vd].Visible := True;
      //ppHeaderBand1.Objects[lvd].Visible := True;
      //lab 16/10/08 786  Plus de détail sur l'utilisateur
      ppHeaderBand1.Objects[usrTel].Visible := True;
      ppHeaderBand1.Objects[usrFax].Visible := True;
      ppHeaderBand1.Objects[usrGsm].Visible := True;
      ppHeaderBand1.Objects[usrEmail].Visible := True;
    END
    ELSE
    BEGIN
      if (Imp_QueTet.FieldByName('USR_USERNAME').AsString <> '') and
         (Imp_QueTet.FieldByName('USR_USERNAME').AsString <> '.') then
//      IF (dm_negFAC.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_negFAC.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
      BEGIN
        ppHeaderBand1.Objects[vu].Visible := True;
        //ppHeaderBand1.Objects[lvd].Visible := True;
        //lab 16/10/08 786  Plus de détail sur l'utilisateur
        ppHeaderBand1.Objects[usrTel].Visible := True;
        ppHeaderBand1.Objects[usrFax].Visible := True;
        ppHeaderBand1.Objects[usrGsm].Visible := True;
        ppHeaderBand1.Objects[usrEmail].Visible := True;
      END;
    END;

END;

PROCEDURE TFrm_RapRV.NegFacTitleBand1BeforePrint(Sender: TObject);
VAR
  clc, i, z, Tar, Cmt, FilComment1: Integer;
  s, m, a, aclt, cht: Integer;
  lht: ARRAY[1..5] OF Integer;
BEGIN
  ppTitleBand1.ObjectByName(cmt, 'ppChp_Fcecoment');
  //  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
  //  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
  //  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');

  //  (ppTitleBand1.Objects[Lvd] as TppLabel).Caption := LibVendeur;

  ppSummaryBand1.ObjectByName(clc, 'ppDBCalc_Smry');
  ppSummaryBand1.ObjectByName(tar, 'ppChp_ToTAR');
  ppSummaryBand1.ObjectByName(cht, 'ppChp_CumHT');

  (ppTitleBand1.Objects[Cmt] AS TppDBMemo).Visible :=
      (Imp_QueTet.FieldByName('FCE_TYPID').AsInteger = FFacture.TipFacLoc.Id) and
      (Imp_QueTet.FieldByName('FCE_CLTID').AsInteger = FFacture.IdToTwinner);
//    (Dm_NegFac.Que_TetImpFCE_TYPID.asInteger = Dm_NegFac.TipFacLoc) AND
//    (Dm_NegFac.Que_TetImpFCE_CLTID.asInteger = StdGinkoia.IdToTwinner);

  FOR i := 1 TO 5 DO
    ppSummaryBand1.ObjectByName(lht[i], 'ppChp_HT' + intToStr(i));

  ppSummaryBand1.Objects[clc].Visible := True;

  if Imp_QueTet.FieldByName('FCE_HTWORK').AsInteger = 0 then
//  IF Dm_NegFac.Que_TetImpFCE_HTWORK.asInteger = 0 THEN
  BEGIN
    (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTTTC';

    (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTTTC';
    FOR i := 1 TO 5 DO
      (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'FCE_TVAHT' + IntToStr(i);

  END
  ELSE
  BEGIN
    (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTHT';
    (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTHT';

    FOR i := 1 TO 5 DO
      (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'HT' + IntToStr(i);

  END;

  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');

  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');

  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
  BEGIN
    IF (i = s) OR (i = m) OR (i = a) THEN
      ppTitleBand1.Objects[i].Visible := FFacture.ImpTete;
  END;

  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := Imp_QueTet.FieldByName('MAGADR').AsString;
  //dm_negfac.que_TetImpMAGADR.asString;
  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;

  IF z > 2 THEN
  BEGIN
    FOR i := z DOWNTO 3 DO
      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
  END;
  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('MAGCP').AsString + ' ' +
                                                 Imp_QueTet.FieldByName('MAGVILLE').AsString);
  //dm_negfac.que_TetImpMAGCP.asString + ' ' +
//    dm_negfac.que_TetImpMAGVILLE.asString);
  IF FFacture.ImpPayMag THEN
    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('MAGPAYS').AsString);
    //dm_negfac.que_TetImpMAGPAYS.asString);

  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := Imp_QueTet.FieldByName('FCE_ADRLIGNE').AsString;
  //dm_negfac.que_TetImpFCE_ADRLIGNE.asString;
  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;

  IF z > 2 THEN
  BEGIN
    FOR i := z DOWNTO 3 DO
      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
  END;
  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('CLTCP').AsString + ' ' +
                                                    Imp_QueTet.FieldByName('CLTVILLE').AsString);
  //dm_negfac.que_TetImpCLTCP.asString + ' ' +
//    dm_negfac.que_TetImpCLTVILLE.asString);
  IF FFacture.ImpPayClt THEN
    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('CLTPAYS').AsString);
    //dm_negfac.que_TetImpCLTPAYS.asString);

  //ppTitleBand1.Objects[vd].Visible := False;
//  ppTitleBand1.Objects[vu].Visible := False;
//  ppTitleBand1.Objects[lvd].Visible := False;
//  if dm_negFac.ImpVend then
//    if dm_negFac.Que_TetImpUSR_FULLNAME.asstring <> '' then
//    begin
//      ppTitleBand1.Objects[vd].Visible := True;
//      ppTitleBand1.Objects[lvd].Visible := True;
//    end
//    else
//    begin
//      if (dm_negFac.Que_TetImpUSR_USERNAME.asstring <> '') and
//        (dm_negFac.Que_TetImpUSR_USERNAME.asstring <> '.') then
//      begin
//        ppTitleBand1.Objects[vu].Visible := True;
//        ppTitleBand1.Objects[lvd].Visible := True;
//      end;
//    end;

  // Filiale
  if Imp_QueTet.FieldByName('FIL_ID').AsInteger <> 0 then
//  if Dm_NegFac.Que_TetImp.FieldByName('FIL_ID').AsInteger <> 0 then
  begin
    ppTitleBand1.ObjectByName(FilComment1, 'ppChp_FILCOMMENT1');
    if FilComment1 > 0 then
      TppMemo(ppTitleBand1.Objects[FilComment1]).Lines.Text := Imp_QueTet.FieldByName('FIL_COMMENT1').AsString;
      //Dm_NegFac.Que_TetImp.FieldByName('FIL_COMMENT1').AsString;
  end;
END;

PROCEDURE TFrm_RapRV.NegFacFooterBand1BeforePrint(Sender: TObject);
VAR
  i, bp : Integer;
  ch, ptel, pfax: STRING;
BEGIN

  // Paramétrage du pied de page
  IF FFActure.ImpPied = False THEN
  BEGIN
    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
      ppFooterBand1.Objects[i].Visible := False;

    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
    ppFooterBand1.Objects[i].visible := FFActure.ImpPg;
  END
  ELSE
  BEGIN

    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
      ppFooterBand1.Objects[i].Visible := True;

    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;

    ch := '';
    if Imp_QueMags.FieldByName('SOC_FORME').AsString <> '' then
//    IF dm_NegFac.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
    BEGIN
      ch := Imp_QueMags.FieldByName('SOC_FORME').asString;
      //dm_NegFac.que_Mags.FieldByName('SOC_FORME').asString;
      if Imp_QueMags.FieldByName('SOC_NOM').asString <> '' THEN
//      IF dm_NegFac.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
        ch := ch + ' : '
      ELSE
        ch := ch + ' -';
    END;
    IF Imp_QueMags.FieldByName('SOC_NOM').asString <> '' THEN
//    IF dm_NegFac.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
      ch := ch + Imp_QueMags.FieldByName('SOC_NOM').asString + ' -';
//      ch := ch + dm_NegFac.que_Mags.FieldByName('SOC_NOM').asString + ' -';
    IF Imp_QueMags.FieldByName('SOC_RCS').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
      ch := ch + ' RCS ' + Imp_QueMags.FieldByName('SOC_RCS').asString + ' -';
//      ch := ch + ' RCS ' + dm_negfac.que_Mags.FieldByName('SOC_RCS').asString + ' -';
    IF Imp_QueMags.FieldByName('MAG_SIRET').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
      ch := ch + ' SIRET ' + Imp_QueMags.FieldByName('MAG_SIRET').asString + ' -';
//      ch := ch + ' SIRET ' + dm_negfac.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
    IF Imp_QueMags.FieldByName('SOC_APE').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
      ch := ch + ' NAF ' + Imp_QueMags.FieldByName('SOC_APE').asString + ' -';
//      ch := ch + ' NAF ' + dm_negfac.que_Mags.FieldByName('SOC_APE').asString + ' -';
    IF Imp_QueMags.FieldByName('SOC_TVA').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
      ch := ch + ' N° TVA ' + Imp_QueMags.FieldByName('SOC_TVA').asString;
//      ch := ch + ' N° TVA ' + dm_negfac.que_Mags.FieldByName('SOC_TVA').asString;

    ch := Trim(ch);
    IF ch <> '' THEN
    BEGIN
      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
      Ch := Trim(ch);
      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
    END;
    ch := '';
    ptel := 'Tel ';
    pfax := ' - Fax ';

    IF Imp_QueMags.FieldByName('ADR_TEL').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
    BEGIN
      IF Uppercase(Copy(Imp_QueMags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      IF Uppercase(Copy(dm_negfac.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
      ch := ptel + Imp_QueMags.FieldByName('ADR_TEL').asString;
//      ch := ptel + dm_negfac.que_Mags.FieldByName('ADR_TEL').asString;
    END;
    IF Imp_QueMags.FieldByName('ADR_FAX').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
    BEGIN
      IF Uppercase(Copy(Imp_QueMags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      IF Uppercase(Copy(dm_negfac.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
      ch := ch + pfax + Imp_QueMags.FieldByName('ADR_FAX').asString;
//      ch := ch + pfax + dm_negfac.que_Mags.FieldByName('ADR_FAX').asString;
    END;
    IF Imp_QueMags.FieldByName('ADR_EMAIL').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
      ch := ch + ' - EMail ' + Imp_QueMags.FieldByName('ADR_EMAIL').asString;
//      ch := ch + ' - EMail ' + dm_negfac.que_Mags.FieldByName('ADR_EMAIL').asString;

    IF ch <> '' THEN
      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);

    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
    ppFooterBand1.Objects[i].visible := FFActure.ImpPg;
  END;
END;

PROCEDURE TFrm_RapRV.NegFacSummaryBand1BeforePrint(Sender: TObject);
VAR
  tx, tmt, toto, i, c, smt, sto, stv, Mdef, rm, DDef, cpa, FilComment2: Integer;
  mpied, stl, ac, cdt, sttc, nap, sht, drglt, factor: Integer;
  CadreHT, LineHT, LabelHT, ChpHT: Integer;
BEGIN
  ppSummaryBand1.ObjectByName(factor, 'ppChp_TxtFactor');

  ppSummaryBand1.ObjectByName(LabelHT, 'ppLab_LabelHT');
  ppSummaryBand1.ObjectByName(CadreHT, 'ppShape_CadreHT');
  ppSummaryBand1.ObjectByName(LineHT, 'ppLine_LineHT');
  ppSummaryBand1.ObjectByName(ChpHT, 'ppChp_ChpHT');

  FOR i := 0 TO ppSummaryBand1.ObjectCount - 1 DO
  BEGIN
    ppSummaryBand1.Objects[i].Visible := True;
    IF Imp_QueTet.FieldByName('FCE_DETAXE').asInteger = 1 THEN
//    IF dm_negFac.Que_TetImp.FieldByName('FCE_DETAXE').asInteger = 1 THEN
      ppSummaryBand1.Objects[i].Visible := ppSummaryBand1.Objects[i].Tag <> 1;
    IF ppSummaryBand1.Objects[i].Visible THEN
    BEGIN
      IF Imp_QueTet.FieldByName('FCE_FACTOR').asInteger = 1 THEN
//      IF dm_NegFac.Que_TetImpFCE_FACTOR.asInteger = 1 THEN
        IF ppSummaryBand1.Objects[i].Tag = 2 THEN ppSummaryBand1.Objects[i].Visible := False;
    END;
  END;
  //IF dm_negFac.Que_TetImp.FieldByName('FCE_DETAXE').asInteger = 1 THEN
  //    (ppSummaryBand1.Objects[sht] AS TppLabel).Visible := False;
  // detaxe par rapport à tag = 1
  // si factor tag = 2 invisible

//    ppSummaryBand1.ObjectByName(Ac, 'ppLab_Acompte');
  ppSummaryBand1.ObjectByName(stl, 'ppLab_Soitle');
  ppSummaryBand1.ObjectByName(cdt, 'ppLab_Cdtrglt');
  ppSummaryBand1.ObjectByName(nap, 'LabNap');

  ppSummaryBand1.ObjectByName(rm, 'LabRemSUM');

  //    (ppSummaryBand1.Objects[ac] AS TppLabel).Caption := NegSumAcompte;
  (ppSummaryBand1.Objects[stl] AS TppLabel).Caption := NegSumSoitle;
  (ppSummaryBand1.Objects[cdt] AS TppLabel).Caption := NegSumCdt;
  (ppSummaryBand1.Objects[nap] AS TppLabel).Caption := NegSumNap;
  //    (ppSummaryBand1.Objects[sttc] AS TppLabel).Caption := NegSumTotalTTC;
  //    (ppSummaryBand1.Objects[sht] AS TppLabel).Caption := NegSumTotalHT;
  (ppSummaryBand1.Objects[rm] AS TppLabel).Caption := NegSumRemglo;

  // label acompte no visible car pas de champ associé géré
//    (ppSummaryBand1.Objects[ac] AS TppLabel).Visible := False;
  (ppSummaryBand1.Objects[rm] AS TppLabel).Visible :=
    (Imp_QueTet.FieldByName('FCE_REMISE').asFloat <> 0);
//    (dm_negFac.Que_TetImp.FieldByName('FCE_REMISE').asFloat <> 0);

  ppSummaryBand1.ObjectByName(tx, 'ppLab_Sumtvatx');
  ppSummaryBand1.ObjectByName(tmt, 'ppLab_Sumtvamt');
  ppSummaryBand1.ObjectByName(toto, 'ppLab_Sumtvatoto');

  ppSummaryBand1.ObjectByName(c, 'ppChp_NapEuro');
  ppSummaryBand1.ObjectByName(cpa, 'ppChp_CPA');
  ppSummaryBand1.ObjectByName(Ddef, 'NegFac_DateDef');
  ppSummaryBand1.ObjectByName(Drglt, 'ppChp_DateRglt');
  ppSummaryBand1.ObjectByName(MDef, 'NegFac_ModeDef');

  ppSummaryBand1.ObjectByName(mpied, 'ppChp_MemPied');

  ppSummaryBand1.ObjectByName(smt, 'SumryMt');
  ppSummaryBand1.ObjectByName(sto, 'SumryTotal');
  ppSummaryBand1.ObjectByName(stv, 'SumryMtTva');

  (ppSummaryBand1.Objects[tx] AS TppLabel).Caption := NegSumTvatx;
  (ppSummaryBand1.Objects[tmt] AS TppLabel).Caption := NegSumTvamt;
  (ppSummaryBand1.Objects[toto] AS TppLabel).Caption := NegSumTvatoto;

  (ppSummaryBand1.Objects[MDef] AS TppLabel).Visible := False;
  (ppSummaryBand1.Objects[DDef] AS TppSystemVariable).Visible := False;
  (ppSummaryBand1.Objects[DRglt] AS TppDBText).Visible := True;

  ppSummaryBand1.Objects[factor].visible := False;
  IF Imp_QueTet.FieldByName('FCE_FACTOR').asInteger = 1 THEN
  BEGIN
    (ppSummaryBand1.Objects[Factor] AS TppMemo).Visible := True;
    (ppSummaryBand1.Objects[Factor] AS TppMemo).Lines.Text := FFacture.TxtFactor;
  END
  ELSE BEGIN
    IF Imp_QueTet.fieldbyName('CPA_CODE').asInteger = 1 THEN
//    IF dm_NegFac.que_TetImpCPA_CODE.asInteger = 1 THEN
    BEGIN
      // date à saisir
      ppSummaryBand1.Objects[Cpa].visible := False;
      (ppSummaryBand1.Objects[MDef] AS TppLabel).Caption := FacImpDateDef; // Dm_NegFac.TxtRgltDef;
      (ppSummaryBand1.Objects[MDef] AS TppLabel).Visible := True;
    END
    ELSE ppSummaryBand1.Objects[Cpa].visible := True;

    IF (Imp_QueTet.FieldByName('DateRglt').asDateTime = 0) THEN
//    IF (Dm_NegFac.Que_TetImpDateRglt.asDateTime = 0) THEN
    BEGIN
      (ppSummaryBand1.Objects[DRglt] AS TppDBText).Visible := False;
      ppSummaryBand1.Objects[Cpa].visible := False;
      (ppSummaryBand1.Objects[MDef] AS TppLabel).Caption := FFacture.TxtRgltDef; //FacImpDateDef;
      (ppSummaryBand1.Objects[MDef] AS TppLabel).Visible := True;
      (ppSummaryBand1.Objects[DDef] AS TppSystemVariable).Visible := True;
    END;
  END;

  (ppSummaryBand1.Objects[mpied] AS TppMemo).Lines.Text := FFacture.TxtFinFact;
  ppSummaryBand1.Objects[mpied].visible := FFacture.ImpTextePied;

  ppSummaryBand1.Objects[c].visible :=
    ((FFacture.ImpEuro) AND (ABS(Imp_QueTet.fieldByName('TTCEURO').asFloat) > 0.01));
//    ((dm_NegFac.ImpEuro = True) AND (ABS(Dm_NegFac.Que_TetImp.fieldByName('TTCEURO').asFloat) > 0.01));

  IF Imp_QueTet.fieldbyname('FCE_HTWORK').asInteger = 0 THEN
//  IF Dm_NegFac.Que_TetImpFCE_HTWORK.asInteger = 0 THEN
  BEGIN
    (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtTTC;
    (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalTTC;
    (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtTTC;

    IF Imp_QueTet.FieldByName('FCE_DETAXE').asInteger = 0 THEN
//    IF dm_negFac.Que_TetImp.FieldByName('FCE_DETAXE').asInteger = 0 THEN
    BEGIN
      ppSummaryBand1.Objects[CadreHT].visible := True;
      ppSummaryBand1.Objects[LineHT].visible := True;
      ppSummaryBand1.Objects[LabelHT].visible := True;
      ppSummaryBand1.Objects[ChpHT].visible := True;
    END;
  END
  ELSE
  BEGIN
    ppSummaryBand1.Objects[CadreHT].visible := False;
    ppSummaryBand1.Objects[LineHT].visible := False;
    ppSummaryBand1.Objects[LabelHT].visible := False;
    ppSummaryBand1.Objects[ChpHT].visible := False;

    (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtHT;
    IF Imp_QueTet.fieldByName('FCE_DETAXE').asInteger <> 1 THEN
//    IF dm_NegFac.Que_TetImpFCE_DETAXE.asInteger <> 1 THEN
      (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalTTC
    ELSE
      (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalHT;
    (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalHT;
    (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtHT;

  END;

  // Filiale
  if (Imp_QueTet.FieldByName('FIL_ID').AsInteger <> 0) then
//  if (Dm_NegFac.Que_TetImp.FieldByName('FIL_ID').AsInteger <> 0) then
  begin
    ppSummaryBand1.ObjectByName(FilComment2, 'ppChp_FILCOMMENT2');
    if (FilComment2 > 0) then
      TppMemo(ppSummaryBand1.Objects[FilComment2]).Lines.Text := Imp_QueTet.FieldByName('FIL_COMMENT2').AsString;
//      TppMemo(ppSummaryBand1.Objects[FilComment2]).Lines.Text := Dm_NegFac.Que_TetImp.FieldByName('FIL_COMMENT2').AsString;
  end;

END;

{_________________ Bons de Livraison Négoce ____________________________________________}

//PROCEDURE TFrm_RapRV.NegBLDetailBeforePrint(Sender: TObject);
//VAR
//  i: Integer;
//  com, lmg, lmd, lbs, lht, tail, coul, ref, st: Integer;
//  rm, dtva, LT, LC, vc, mtl, pxu: Integer;
//BEGIN
//  ppdetailBand1.Visible :=
//    dm_NegBL.que_LineImpBLL_GPSSTOTAL.asInteger = 0;
//
//  ppdetailBand1.ObjectByName(rm, 'ppChp_Remise');
//
//  ppdetailBand1.ObjectByName(ST, 'ppChp_Soustot');
//  ppdetailBand1.ObjectByName(pxu, 'ppChp_PXU');
//  ppdetailBand1.ObjectByName(mtl, 'ppChp_MTLine');
//  ppdetailBand1.ObjectByName(vc, 'ppChp_ValComent');
//  ppdetailBand1.ObjectByName(com, 'ppChp_Coment');
//  ppdetailBand1.ObjectByName(lmg, 'LineMG');
//  ppdetailBand1.ObjectByName(lmd, 'LineMD');
//  ppdetailBand1.ObjectByName(lbs, 'LineBas');
//  ppdetailBand1.ObjectByName(lht, 'LineHaut');
//
//  ppdetailBand1.ObjectByName(tail, 'ppChp_Taille');
//  ppdetailBand1.ObjectByName(coul, 'ppChp_Coul');
//  ppdetailBand1.ObjectByName(ref, 'ppChp_Ref');
//
//  ppdetailBand1.ObjectByName(LT, 'LineTail');
//  ppdetailBand1.ObjectByName(LC, 'LineCoul');
//
//  ppdetailBand1.Objects[st].Visible := False;
//  ppdetailBand1.Objects[vc].Visible := False;
//  ppdetailBand1.Objects[mtl].Visible := True;
//
//  ppdetailBand1.ObjectByName(dtva, 'ppChp_DetTVA');
//  ppDetailBand1.Objects[dtva].visible := True;
//  IF dm_NegBL.Que_TetImpBLE_DETAXE.asInteger = 1 THEN
//    ppDetailBand1.Objects[dtva].visible := False;
//
//  ppdetailBand1.Objects[com].Font.Style := [];
//  IF (ppdetailBand1.Objects[com] AS TppDBMemo).Lines.Count > 1 THEN
//  BEGIN
//    IF Dm_NegBL.que_LineImpBLL_LINETIP.AsInteger = 0 THEN
//      ppdetailBand1.Objects[com].Font.Size := 10
//    ELSE
//      ppdetailBand1.Objects[com].Font.Size := 9;
//  END
//  ELSE
//    ppdetailBand1.Objects[com].Font.Size := 8;
//
//  ppdetailBand1.Objects[com].Left := 23.813;
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//    ppdetailBand1.Objects[com].Width := 94
//  ELSE
//    ppdetailBand1.Objects[com].Width := 60;
//
//  IF Dm_NegBL.que_LineImpBLL_LINETIP.AsInteger <> 0 THEN
//  BEGIN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//    BEGIN
//      IF (i = com) OR (i = lmg) OR (i = lmd) THEN
//        ppdetailBand1.Objects[i].Visible := True
//      ELSE
//        ppdetailBand1.Objects[i].Visible := False;
//    END;
//
//    ppdetailBand1.Objects[mtl].Visible := False;
//    ppdetailBand1.Objects[st].Visible :=
//      (dm_negBL.Que_LineImpBLL_PXNN.asFloat <> 0) AND
//      (Dm_NegBL.que_LineImpBLL_LINETIP.AsInteger = 3);
//
//    ppdetailBand1.Objects[vc].Visible :=
//      (dm_negBL.Que_LineImpBLL_PXBRUT.asFloat <> 0) AND
//      (Dm_NegBL.que_LineImpBLL_LINETIP.AsInteger IN [1, 4]);
//
//    CASE Dm_NegBL.que_LineImpBLL_LINETIP.AsInteger OF
//      1:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 142;
//          ppdetailBand1.Objects[com].Font.Style := [];
//          ppdetailBand1.Objects[st].Font.Size := 8;
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Size := 8;
//          ppdetailBand1.Objects[vc].Font.Style := [];
//        END;
//      2:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 165;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Style := [fsBold];
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Size := 10;
//          ppdetailBand1.Objects[vc].Font.Style := [];
//        END;
//      3:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 142;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Size := 10;
//          ppdetailBand1.Objects[vc].Font.Size := 10;
//          ppdetailBand1.Objects[com].Font.Style := [];
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Style := [];
//          ppdetailBand1.Objects[rm].Visible := True;
//        END;
//      4:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 165;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Size := 10;
//          ppdetailBand1.Objects[vc].Font.Size := 10;
//          ppdetailBand1.Objects[com].Font.Style := [];
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Style := [];
//        END;
//
//    END;
//
//    IF NOT FirstLineOfPg AND (NOT FlagComent) THEN
//      ppdetailBand1.Objects[lht].Visible := True;
//    FlagComent := True;
//
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//    BEGIN
//      IF stdGinkoia.Origine = 2 THEN // brun
//      BEGIN
//        IF (i = tail) OR (i = coul) OR (i = LT) OR (i = LC) OR
//          (i = lht) OR (i = vc) OR (i = st) THEN
//          ppdetailBand1.Objects[i].Visible := False
//        ELSE
//          ppdetailBand1.Objects[i].Visible := True;
//      END
//      ELSE
//      BEGIN
//        IF (i = lht) OR (i = st) OR (i = VC) THEN
//          ppdetailBand1.Objects[i].Visible := False
//        ELSE
//          ppdetailBand1.Objects[i].Visible := True;
//      END;
//    END;
//
//    IF Dm_NegBL.que_LineImpBLL_SSTOTAL.asInteger <> 0 THEN
//      ppdetailBand1.Objects[rm].Visible := False;
//
//    FlagComent := False;
//  END;
//
//  ppdetailBand1.Objects[lbs].Visible := True;
//
//  IF ppr_RapRv.SecondPass THEN
//  BEGIN
//    IF ppdetailband1.visible THEN Inc(cptDetail);
//    IF CptDetail = Tablo[ppr_RapRv.AbsolutePageNo] THEN
//    BEGIN
////      IF FlagComent THEN
////      BEGIN
//        ppdetailBand1.Objects[lbs].Visible := true;
//        //remettre le compteur de ligne de la page à 0
//        CptDetail := 0;
////      END;
//    END
//    ELSE
//      IF NOT FlagComent THEN ppdetailBand1.Objects[lbs].Visible := False;
//
//  END;
//
//  IF NOT Dm_NegBL.ImpLine THEN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//      IF Uppercase(Copy(ppdetailBand1.Objects[i].Name, 1, 4)) = 'LINE' THEN
//        ppdetailBand1.Objects[i].Visible := False;
//
//  IF Dm_NegBL.FlagEditNV THEN
//  BEGIN
//    ppdetailBand1.Objects[rm].Visible := False;
//    ppdetailBand1.Objects[pxu].Visible := False;
//    ppdetailBand1.Objects[st].Visible := False;
//    ppdetailBand1.Objects[vc].Visible := False;
//    ppdetailBand1.Objects[mtl].Visible := False;
//    ppdetailBand1.Objects[dtva].Visible := False;
//
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.NegBLTitleBand1BeforePrint(Sender: TObject);
//VAR
//  clc, i, z, Tar: Integer;
//  cmht, s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//  //  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
//  //  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
//  //  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  // (ppTitleBand1.Objects[Lvd] as TppLabel).Caption := LibVendeur;
//
//  ppSummaryBand1.ObjectByName(clc, 'ppDBCalc_Smry');
//  ppSummaryBand1.ObjectByName(tar, 'ppChp_ToTAR');
//  ppSummaryBand1.ObjectByName(cht, 'ppChp_CumHT');
//
//  ppSummaryBand1.ObjectByName(Cmht, 'ppChp_CumHT');
//  FOR i := 1 TO 5 DO
//    ppSummaryBand1.ObjectByName(lht[i], 'ppChp_HT' + intToStr(i));
//
//  ppSummaryBand1.Objects[clc].Visible := True;
//
//  IF Dm_NegBL.Que_TetImpBLE_HTWORK.asInteger = 0 THEN
//  BEGIN
//    (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTTTC';
//
//    (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTTTC';
//    FOR i := 1 TO 5 DO
//      (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'BLE_TVAHT' + IntToStr(i);
//
//  END
//  ELSE
//  BEGIN
//    (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTHT';
//    (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTHT';
//
//    FOR i := 1 TO 5 DO
//      (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'HT' + IntToStr(i);
//
//  END;
//
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := dm_NegBL.ImpTete;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_negBL.que_TetImpMAGADR.asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negBL.que_TetImpMAGCP.asString + ' ' +
//    dm_negBL.que_TetImpMAGVILLE.asString);
//  IF dm_negBL.ImpPayMag THEN
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negBL.que_TetImpMAGPAYS.asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_negBL.que_TetImpBLE_ADRLIGNE.asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negBL.que_TetImpCLTCP.asString + ' ' +
//    dm_negBL.que_TetImpCLTVILLE.asString);
//  IF dm_negBL.ImpPayClt THEN
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negBL.que_TetImpCLTPAYS.asString);
//
//  //  ppTitleBand1.Objects[vd].Visible := False;
//  //  ppTitleBand1.Objects[vu].Visible := False;
//  //  ppTitleBand1.Objects[lvd].Visible := False;
//  //  if dm_negBL.ImpVend then
//  //    if dm_negBL.Que_TetImpUSR_FULLNAME.asstring <> '' then
//  //    begin
//  //      ppTitleBand1.Objects[vd].Visible := True;
//  //      ppTitleBand1.Objects[lvd].Visible := True;
//  //    end
//  //    else
//  //    begin
//  //      if (dm_negBL.Que_TetImpUSR_USERNAME.asstring <> '') and
//  //        (dm_negBL.Que_TetImpUSR_USERNAME.asstring <> '.') then
//  //      begin
//  //        ppTitleBand1.Objects[vu].Visible := True;
//  //        ppTitleBand1.Objects[lvd].Visible := True;
//  //      end;
//  //    end;
//
//END;
//
//PROCEDURE TFrm_RapRV.NegBPDetailBeforePrint(Sender: TObject);
//VAR
//  i: Integer;
//  com, lmg, lmd, lbs, lht, tail, coul, ref, st: Integer;
//  rm, dtva, LT, LC, vc, mtl, pxu, SR, SF: Integer;
//BEGIN
//  ppdetailBand1.ObjectByName(com, 'ppChp_Coment');
//  ppdetailBand1.ObjectByName(lmg, 'LineMG');
//  ppdetailBand1.ObjectByName(lmd, 'LineMD');
//  ppdetailBand1.ObjectByName(lbs, 'LineBas');
//  ppdetailBand1.ObjectByName(lht, 'LineHaut');
//
//  ppdetailBand1.ObjectByName(tail, 'ppChp_Taille');
//  ppdetailBand1.ObjectByName(coul, 'ppChp_Coul');
//  ppdetailBand1.ObjectByName(ref, 'ppChp_Ref');
//
//  ppdetailBand1.ObjectByName(LT, 'LineTail');
//  ppdetailBand1.ObjectByName(SR, 'ppSide_Right');
//  ppdetailBand1.ObjectByName(SF, 'ppSide_Left');
//  ppdetailBand1.ObjectByName(LC, 'LineCoul');
//
//  ppdetailBand1.Objects[com].Font.Style := [];
//  IF (ppdetailBand1.Objects[com] AS TppDBMemo).Lines.Count > 1 THEN
//  BEGIN
//    IF dm_BonPrepa.que_LineImpBLL_LINETIP.AsInteger = 0 THEN
//      ppdetailBand1.Objects[com].Font.Size := 10
//    ELSE
//      ppdetailBand1.Objects[com].Font.Size := 9;
//  END
//  ELSE
//    ppdetailBand1.Objects[com].Font.Size := 8;
//
// //  if Copy(Letat, 1, 8) = 'BONPREPA' then
//     ppdetailBand1.Objects[com].Left := 12;
// //  else
// //   ppdetailBand1.Objects[com].Left := 23.813;
//
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//    ppdetailBand1.Objects[com].Width := 94
//  ELSE
//    ppdetailBand1.Objects[com].Width := 60;
//
//  IF dm_BonPrepa.que_LineImpBLL_LINETIP.AsInteger <> 0 THEN
//  BEGIN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//    BEGIN
//      IF (i = com) OR (i = lmg) OR (i = lmd) OR (i = SR) OR (i = SF) THEN
//        ppdetailBand1.Objects[i].Visible := True
//      ELSE
//        ppdetailBand1.Objects[i].Visible := False;
//    END;
//
//    CASE dm_BonPrepa.que_LineImpBLL_LINETIP.AsInteger OF
//      1:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 142;
//          ppdetailBand1.Objects[com].Font.Style := [];
//        END;
//      2:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 165;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Style := [fsBold];
//          ppdetailBand1.Objects[com].Font.Size := 10;
//        END;
//      3:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 142;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[com].Font.Style := [];
//        END;
//      4:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 165;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Size := 10;
//        END;
//
//    END;
//    IF NOT FirstLineOfPg AND (NOT FlagComent) THEN
//      ppdetailBand1.Objects[lht].Visible := True;
//    FlagComent := True;
//    inc(nbComent);
//  END
//  ELSE
//  BEGIN
//
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//    BEGIN
//      IF stdGinkoia.Origine = 2 THEN // brun
//      BEGIN
//        IF (i = tail) OR (i = coul) OR (i = LT) OR (i = LC) OR (i = lht) THEN
//          ppdetailBand1.Objects[i].Visible := False
//        ELSE
//          ppdetailBand1.Objects[i].Visible := True;
//      END
//      ELSE
//      BEGIN
//        IF (i = lht) THEN
//          ppdetailBand1.Objects[i].Visible := False
//        ELSE
//          ppdetailBand1.Objects[i].Visible := True;
//      END;
//    END;
//
//    IF FirstLineOfPg THEN
//    BEGIN
//      ppdetailBand1.Objects[lbs].Visible := True;
//    END;
//
//    IF (nbComent > 0) THEN
//      ppdetailBand1.Objects[lht].Visible := True;
//    FlagComent := False;
//    nbComent := 0;
//  END;
//
//  IF (nbComent > 0) THEN
//  BEGIN
//    ppdetailBand1.Objects[lbs].Visible := false;
//  END;
//
//  IF ppr_RapRv.SecondPass THEN
//  BEGIN
//    IF ppdetailband1.visible THEN Inc(cptDetail);
//    IF CptDetail = Tablo[ppr_RapRv.AbsolutePageNo] THEN
//    BEGIN
//      //IF FlagComent THEN
//      ppdetailBand1.Objects[lbs].Visible := True;
//      //remettre le compteur de ligne de la page à 0
//      CptDetail := 0;
//    END
//    ELSE
//      IF NOT FlagComent THEN ppdetailBand1.Objects[lbs].Visible := False;
//
//  END;
//
//  IF NOT dm_BonPrepa.ImpLine THEN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//      IF Uppercase(Copy(ppdetailBand1.Objects[i].Name, 1, 4)) = 'LINE' THEN
//        ppdetailBand1.Objects[i].Visible := False;
//END;
//
//PROCEDURE TFrm_RapRV.NegBPEnteteBeforePrint(Sender: TObject);
//VAR
//  Exprt, pxu, mt, rm, ec, et, elr, Tbl, elt: Integer;
//  ctva, ltva, labtva, chptva: Integer;
//  labclt, nm, dt, ref, des, etva, eqt, fax, lfax, vu, lvd, vd,
//    usrTel, usrFax, usrGsm, usrEmail, fclt, z, i, Empl: Integer;
//
//BEGIN
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(lfax, 'ppLab_Fax');
//  ppHeaderBand1.ObjectByName(fax, 'ppchp_Fax');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//  ppHeaderBand1.ObjectByName(ref, 'Entet_Ref');
//  ppHeaderBand1.ObjectByName(des, 'Entet_Des');
//  ppHeaderBand1.ObjectByName(Empl, 'Entet_Empl');
//  ppHeaderBand1.ObjectByName(eqt, 'Entet_Qte');
//
//  ppHeaderBand1.ObjectByName(pxu, 'Entet_Pxu');
//  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
//  ppHeaderBand1.ObjectByName(ec, 'Entet_Coul');
//  ppHeaderBand1.ObjectByName(et, 'Entet_Tail');
//  ppHeaderBand1.ObjectByName(rm, 'Entet_Rem');
//
//  //lab 16/10/08 786 Coordonnées utilisateurs
//  ppHeaderBand1.ObjectByName(vd, 'ppChp_UserName');
//  ppHeaderBand1.ObjectByName(lvd, 'LabVendeur');
//  ppHeaderBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  ppHeaderBand1.ObjectByName(usrTel, 'ppChp_USRTEL');
//  ppHeaderBand1.ObjectByName(usrFax, 'ppChp_USRFAX');
//  ppHeaderBand1.ObjectByName(usrGsm, 'ppChp_USRGSM');
//  ppHeaderBand1.ObjectByName(usrEmail, 'ppChp_USREMAIL');
//  (ppHeaderBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//  (ppHeaderBand1.Objects[Empl] AS TppLabel).Caption := NegTetEmpl;
//  (ppHeaderBand1.Objects[eqt] AS TppLabel).Caption := Negtetqte;
//
//  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
//  (ppHeaderBand1.Objects[ec] AS TppLabel).Caption := Negtetcoul;
//  (ppHeaderBand1.Objects[et] AS TppLabel).Caption := NegtetTail;
//  (ppHeaderBand1.Objects[rm] AS TppLabel).Caption := NegtetRem;
//
//  ppHeaderBand1.ObjectByName(Tbl, 'Entet_TipBl');
//  ppHeaderBand1.ObjectByName(elr, 'Entet_LCoul');
//  ppHeaderBand1.ObjectByName(elt, 'Entet_LTail');
//  ppHeaderBand1.ObjectByName(Exprt, 'ppLab_Export');
//  ppHeaderBand1.ObjectByName(fclt, 'ppchp_AdrFactClt');
//
//  ppHeaderBand1.Objects[Tbl].Visible := ppr_raprv.absolutePageNo = 1;
//
//  (ppHeaderBand1.Objects[des] AS TppLabel).Caption := Negtetdes;
//
//
//  TRY
//    ppHeaderBand1.Objects[lfax].visible := dm_BonPrepa.Que_TetImpBLE_PRO.asInteger = 1;
//    ppHeaderBand1.Objects[fax].visible := dm_BonPrepa.Que_TetImpBLE_PRO.asInteger = 1;
//  EXCEPT
//  END;
//  //-------------------------------------------_
//  IF dm_BonPrepa.ImpTva THEN
//  BEGIN
//    ppHeaderBand1.Objects[ctva].visible := True;
//    ppHeaderBand1.Objects[ltva].visible := True;
//    ppHeaderBand1.Objects[chptva].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//  // Paramétrage des entêtes de pages
//
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//  BEGIN
//    ppHeaderBand1.Objects[ec].visible := False;
//    ppHeaderBand1.Objects[et].visible := False;
//    ppHeaderBand1.Objects[elr].visible := False;
//    ppHeaderBand1.Objects[elt].visible := False;
//  END
//  ELSE
//  BEGIN
//    IF dm_BonPrepa.ImpTailCoul THEN
//    BEGIN
//      ppHeaderBand1.Objects[ec].visible := True;
//      ppHeaderBand1.Objects[et].visible := True;
//    END
//    ELSE BEGIN
//      ppHeaderBand1.Objects[ec].visible := False;
//      ppHeaderBand1.Objects[et].visible := False;
//    END;
//    ppHeaderBand1.Objects[elr].visible := True;
//    ppHeaderBand1.Objects[elt].visible := True;
//  END;
//
////  IF dm_BonPrepa.ImpRem THEN
////    ppHeaderBand1.Objects[rm].visible := True
////  ELSE
////    ppHeaderBand1.Objects[rm].visible := False;
//
//  ppHeaderBand1.Objects[vd].Visible := False;
//  ppHeaderBand1.Objects[vu].Visible := False;
//  //lab 16/10/08 786  Plus de détail sur l'utilisateur
//  ppHeaderBand1.Objects[usrTel].Visible := False;
//  ppHeaderBand1.Objects[usrFax].Visible := False;
//  ppHeaderBand1.Objects[usrGsm].Visible := False;
//  ppHeaderBand1.Objects[usrEmail].Visible := False;
//  IF dm_BonPrepa.ImpVend THEN
//    IF dm_BonPrepa.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
//    BEGIN
//      ppHeaderBand1.Objects[vd].Visible := True;
//      //lab 16/10/08 786  Plus de détail sur l'utilisateur
//      ppHeaderBand1.Objects[usrTel].Visible := True;
//      ppHeaderBand1.Objects[usrFax].Visible := True;
//      ppHeaderBand1.Objects[usrGsm].Visible := True;
//      ppHeaderBand1.Objects[usrEmail].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (dm_BonPrepa.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_BonPrepa.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
//      BEGIN
//        ppHeaderBand1.Objects[vu].Visible := True;
//        //lab 16/10/08 786  Plus de détail sur l'utilisateur
//        ppHeaderBand1.Objects[usrTel].Visible := True;
//        ppHeaderBand1.Objects[usrFax].Visible := True;
//        ppHeaderBand1.Objects[usrGsm].Visible := True;
//        ppHeaderBand1.Objects[usrEmail].Visible := True;
//      END;
//    END;
//
//END;
//
//PROCEDURE TFrm_RapRV.NegBPFooterBand1BeforePrint(Sender: TObject);
//VAR
//  i, bp, lbp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  ppFooterBand1.ObjectByName(lbp, 'ppLine_BasPage');
//  // Paramétrage du pied de page
//  IF dm_BonPrepa.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_BonPrepa.ImpPg;
//
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_BonPrepa.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_BonPrepa.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + dm_BonPrepa.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_BonPrepa.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_BonPrepa.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_BonPrepa.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_BonPrepa.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_BonPrepa.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_BonPrepa.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_BonPrepa.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_BonPrepa.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_BonPrepa.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_BonPrepa.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_BonPrepa.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_BonPrepa.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_BonPrepa.ImpPg;
//
//  END;
//  //n'afficher la ligne de séparation de la raison sociale que sur la dernière page
//  ppFooterBand1.Objects[lbp].Visible := (length(Tablo) - 1 = ppr_RapRv.AbsolutePageNo);
//END;

PROCEDURE TFrm_RapRV.NegBPSummaryBand1BeforePrint(Sender: TObject);
BEGIN
  //
END;

//PROCEDURE TFrm_RapRV.NegBPTitleBand1BeforePrint(Sender: TObject);
//VAR
//  clc, i, z, Tar: Integer;
//  cmht, s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := dm_BonPrepa.ImpTete;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_BonPrepa.que_TetImpMAGADR.asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpMAGCP.asString + ' ' +
//    dm_BonPrepa.que_TetImpMAGVILLE.asString);
//  IF dm_BonPrepa.ImpPayMag THEN
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpMAGPAYS.asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_BonPrepa.que_TetImpBLE_ADRLIGNE.asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpCLTCP.asString + ' ' +
//    dm_BonPrepa.que_TetImpCLTVILLE.asString);
//  IF dm_BonPrepa.ImpPayClt THEN
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpCLTPAYS.asString);
//
//END;
//
//PROCEDURE TFrm_RapRV.NegBLFooterBand1BeforePrint(Sender: TObject);
//VAR
//  i, bp : Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_NegBL.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_NegBL.ImpPg;
//
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_NegBl.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_NegBl.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_NegBL.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_NegBL.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + dm_NegBl.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_NegBL.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_NegBL.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_NegBL.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_NegBL.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_negBL.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negBL.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_negBL.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_negBL.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negBL.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_negBL.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_NegBL.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_NegBL.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_NegBL.ImpPg;
//
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.NegBLSummaryBand1BeforePrint(Sender: TObject);
//VAR
//  tx, tmt, toto, i, c, rm, smt, sto, stv, star: Integer;
//BEGIN
//  ppSummaryBand1.Visible := NOT dm_NegBL.FlagEditNV;
//
//  FOR i := 0 TO ppSummaryBand1.ObjectCount - 1 DO
//  BEGIN
//    ppSummaryBand1.Objects[i].Visible := True;
//    IF dm_negBL.Que_TetImp.FieldByName('BLE_DETAXE').asInteger = 1 THEN
//      ppSummaryBand1.Objects[i].Visible := ppSummaryBand1.Objects[i].Tag <> 1;
//  END;
//
//  ppSummaryBand1.ObjectByName(tx, 'ppLab_Sumtvatx');
//  ppSummaryBand1.ObjectByName(tmt, 'ppLab_Sumtvamt');
//  ppSummaryBand1.ObjectByName(toto, 'ppLab_Sumtvatoto');
//  (ppSummaryBand1.Objects[tx] AS TppLabel).Caption := NegSumTvatx;
//  (ppSummaryBand1.Objects[tmt] AS TppLabel).Caption := NegSumTvamt;
//  (ppSummaryBand1.Objects[toto] AS TppLabel).Caption := NegSumTvatoto;
//
//  // Paramétrage du sommaire
//  ppSummaryBand1.ObjectByName(c, 'ppChp_NapEuro');
//
//  ppSummaryBand1.ObjectByName(smt, 'SumryMt');
//  ppSummaryBand1.ObjectByName(sto, 'SumryTotal');
//  ppSummaryBand1.ObjectByName(star, 'SumryTotAR');
//
//  ppSummaryBand1.ObjectByName(stv, 'SumryMtTva');
//  ppSummaryBand1.ObjectByName(rm, 'LabRemSUM');
//
//  (ppSummaryBand1.Objects[rm] AS TppLabel).Caption := NegSumRemGlo;
//  ;
//
//  (ppSummaryBand1.Objects[rm] AS TppLabel).Visible :=
//    (dm_negBL.Que_TetImp.FieldByName('BLE_REMISE').asFloat <> 0);
//
//  ppSummaryBand1.Objects[c].visible :=
//    (dm_NegBL.ImpEuro = True) AND (ABS(Dm_NegBL.Que_TetImp.fieldByName('TTCEURO').asFloat) > 0.01);
//
//  IF Dm_NegBL.Que_TetImpBLE_HTWORK.asInteger = 0 THEN
//  BEGIN
//    (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtTTC;
//    (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalTTC;
//    (ppSummaryBand1.Objects[star] AS TppLabel).Caption := NegSumTotalTTC;
//    (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtTTC;
//  END
//  ELSE
//  BEGIN
//    (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtHT;
//    IF dm_NegBl.Que_TetImpBLE_DETAXE.asInteger <> 1 THEN
//      (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalTTC
//    ELSE
//      (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalHT;
//    (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtHT;
//    (ppSummaryBand1.Objects[star] AS TppLabel).Caption := NegSumTotalHT;
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.NegBLEnteteBeforePrint(Sender: TObject);
//VAR
//  Exprt, pxu, mt, rm, ec, et, elr, Tbl, elt: Integer;
//  ctva, ltva, labtva, chptva: Integer;
//  labclt, nm, dt, ref, des, etva, eqt, fax, lfax, vu, lvd, vd,
//    usrTel, usrFax, usrGsm, usrEmail, Empl : Integer;
//
//BEGIN
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(lfax, 'ppLab_Fax');
//  ppHeaderBand1.ObjectByName(fax, 'ppchp_Fax');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//  ppHeaderBand1.ObjectByName(ref, 'Entet_Ref');
//  ppHeaderBand1.ObjectByName(des, 'Entet_Des');
////  ppHeaderBand1.ObjectByName(Empl, 'Entet_Empl');
//  ppHeaderBand1.ObjectByName(etva, 'Entet_Tva');
//  ppHeaderBand1.ObjectByName(eqt, 'Entet_Qte');
//
//  ppHeaderBand1.ObjectByName(pxu, 'Entet_Pxu');
//  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
//  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');
//  ppHeaderBand1.ObjectByName(ec, 'Entet_Coul');
//  ppHeaderBand1.ObjectByName(et, 'Entet_Tail');
//  ppHeaderBand1.ObjectByName(rm, 'Entet_Rem');
//  ppHeaderBand1.ObjectByName(mt, 'Entet_Mt');
//
//  //lab 16/10/08 786 Coordonnées utilisateurs
//  ppHeaderBand1.ObjectByName(vd, 'ppChp_UserName');
//  ppHeaderBand1.ObjectByName(lvd, 'LabVendeur');
//  ppHeaderBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  ppHeaderBand1.ObjectByName(usrTel, 'ppChp_USRTEL');
//  ppHeaderBand1.ObjectByName(usrFax, 'ppChp_USRFAX');
//  ppHeaderBand1.ObjectByName(usrGsm, 'ppChp_USRGSM');
//  ppHeaderBand1.ObjectByName(usrEmail, 'ppChp_USREMAIL');
//  (ppHeaderBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//  (ppHeaderBand1.Objects[ref] AS TppLabel).Caption := Negtetref;
//  (ppHeaderBand1.Objects[des] AS TppLabel).Caption := Negtetdes;
////  (ppHeaderBand1.Objects[Empl] AS TppLabel).Caption := NegTetEmpl;
//  (ppHeaderBand1.Objects[etva] AS TppLabel).Caption := Negtettva;
//  (ppHeaderBand1.Objects[eqt] AS TppLabel).Caption := Negtetqte;
//
//  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
//  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;
//  (ppHeaderBand1.Objects[ec] AS TppLabel).Caption := Negtetcoul;
//  (ppHeaderBand1.Objects[et] AS TppLabel).Caption := NegtetTail;
//  (ppHeaderBand1.Objects[rm] AS TppLabel).Caption := NegtetRem;
//
//  ppHeaderBand1.ObjectByName(Tbl, 'Entet_TipBl');
//  ppHeaderBand1.ObjectByName(elr, 'Entet_LCoul');
//  ppHeaderBand1.ObjectByName(elt, 'Entet_LTail');
//  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
//  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
//  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
//  ppHeaderBand1.ObjectByName(Exprt, 'ppLab_Export');
//
//  ppHeaderBand1.Objects[Tbl].Visible := ppr_raprv.absolutePageNo = 1;
//
//  TRY
//    ppHeaderBand1.Objects[lfax].visible := Dm_NegBL.Que_TetImpBLE_PRO.asInteger = 1;
//    ppHeaderBand1.Objects[fax].visible := Dm_NegBL.Que_TetImpBLE_PRO.asInteger = 1;
//  EXCEPT
//  END;
//  //-------------------------------------------_
//  ppHeaderBand1.Objects[etva].visible := True;
//  IF dm_NegBL.Que_TetImpBLE_DETAXE.asInteger = 1 THEN
//  BEGIN
//    ppHeaderBand1.Objects[etva].visible := False;
//    ppHeaderBand1.Objects[Exprt].visible := True;
//  END
//  ELSE ppHeaderBand1.Objects[Exprt].visible := False;
//
//  IF dm_NegBL.ImpTva THEN
//  BEGIN
//    ppHeaderBand1.Objects[ctva].visible := True;
//    ppHeaderBand1.Objects[ltva].visible := True;
//    ppHeaderBand1.Objects[labtva].visible := True;
//    ppHeaderBand1.Objects[chptva].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//  IF Dm_NegBL.Que_TetImpBLE_HTWORK.asInteger = 0 THEN
//  BEGIN
//    (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuTTC;
//    (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtTTC;
//  END
//  ELSE
//  BEGIN
//    (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuHT;
//    (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtHT;
//  END;
//
//  // Paramétrage des entêtes de pages
//
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//  BEGIN
//    ppHeaderBand1.Objects[ec].visible := False;
//    ppHeaderBand1.Objects[et].visible := False;
//    ppHeaderBand1.Objects[elr].visible := False;
//    ppHeaderBand1.Objects[elt].visible := False;
//  END
//  ELSE
//  BEGIN
//    IF dm_NegBl.ImpTailCoul THEN
//    BEGIN
//      ppHeaderBand1.Objects[ec].visible := True;
//      ppHeaderBand1.Objects[et].visible := True;
//    END
//    ELSE BEGIN
//      ppHeaderBand1.Objects[ec].visible := False;
//      ppHeaderBand1.Objects[et].visible := False;
//    END;
//    ppHeaderBand1.Objects[elr].visible := True;
//    ppHeaderBand1.Objects[elt].visible := True;
//  END;
//
//  IF dm_negBl.ImpRem THEN
//    ppHeaderBand1.Objects[rm].visible := True
//  ELSE
//    ppHeaderBand1.Objects[rm].visible := False;
//
//  IF Dm_NegBL.FlagEditNV THEN
//  BEGIN
//    ppHeaderBand1.Objects[pxu].Visible := False;
//    ppHeaderBand1.Objects[mt].Visible := False;
//    ppHeaderBand1.Objects[rm].Visible := False;
//    ppHeaderBand1.Objects[etva].Visible := False;
//  END;
//
//  ppHeaderBand1.Objects[vd].Visible := False;
//  ppHeaderBand1.Objects[vu].Visible := False;
//  //ppHeaderBand1.Objects[lvd].Visible := False;
//  //lab 16/10/08 786  Plus de détail sur l'utilisateur
//  ppHeaderBand1.Objects[usrTel].Visible := False;
//  ppHeaderBand1.Objects[usrFax].Visible := False;
//  ppHeaderBand1.Objects[usrGsm].Visible := False;
//  ppHeaderBand1.Objects[usrEmail].Visible := False;
//  IF dm_negBL.ImpVend THEN
//    IF dm_negBL.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
//    BEGIN
//      ppHeaderBand1.Objects[vd].Visible := True;
//      //ppHeaderBand1.Objects[lvd].Visible := True;
//      //lab 16/10/08 786  Plus de détail sur l'utilisateur
//      ppHeaderBand1.Objects[usrTel].Visible := True;
//      ppHeaderBand1.Objects[usrFax].Visible := True;
//      ppHeaderBand1.Objects[usrGsm].Visible := True;
//      ppHeaderBand1.Objects[usrEmail].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (dm_negBL.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_negBL.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
//      BEGIN
//        ppHeaderBand1.Objects[vu].Visible := True;
//        //ppHeaderBand1.Objects[lvd].Visible := True;
//        //lab 16/10/08 786  Plus de détail sur l'utilisateur
//        ppHeaderBand1.Objects[usrTel].Visible := True;
//        ppHeaderBand1.Objects[usrFax].Visible := True;
//        ppHeaderBand1.Objects[usrGsm].Visible := True;
//        ppHeaderBand1.Objects[usrEmail].Visible := True;
//      END;
//    END;
//
//END;

{_________________ Devis Négoce ____________________________________________}

//PROCEDURE TFrm_RapRV.NegDevDetailBeforePrint(Sender: TObject);
//VAR
//  i: Integer;
//  com, lmg, lmd, lbs, lht, tail, coul, ref: Integer;
//  rm, dtva, LT, LC, st, vc, mtl: Integer;
//
//BEGIN
//  ppdetailBand1.Visible :=
//    dm_NegDev.que_LineImpDVL_GPSSTOTAL.asInteger = 0;
//
//  ppdetailBand1.ObjectByName(rm, 'ppChp_Remise');
//
//  ppdetailBand1.ObjectByName(ST, 'ppChp_Soustot');
//  ppdetailBand1.ObjectByName(mtl, 'ppChp_MTLine');
//  ppdetailBand1.ObjectByName(VC, 'ppChp_ValComent');
//
//  ppdetailBand1.ObjectByName(com, 'ppChp_Coment');
//  ppdetailBand1.ObjectByName(lmg, 'LineMG');
//  ppdetailBand1.ObjectByName(lmd, 'LineMD');
//  ppdetailBand1.ObjectByName(lbs, 'LineBas');
//  ppdetailBand1.ObjectByName(lht, 'LineHaut');
//
//  ppdetailBand1.ObjectByName(tail, 'ppChp_Taille');
//  ppdetailBand1.ObjectByName(coul, 'ppChp_Coul');
//  ppdetailBand1.ObjectByName(ref, 'ppChp_Ref');
//
//  ppdetailBand1.ObjectByName(LT, 'LineTail');
//  ppdetailBand1.ObjectByName(LC, 'LineCoul');
//
//  ppdetailBand1.Objects[st].Visible := False;
//  ppdetailBand1.Objects[vc].Visible := False;
//  ppdetailBand1.Objects[mtl].Visible := True;
//
//  ppdetailBand1.Objects[com].Font.Style := [];
//  IF (ppdetailBand1.Objects[com] AS TppDBMemo).Lines.Count > 1 THEN
//  BEGIN
//    IF Dm_NegDev.que_LineImpDVL_LINETIP.AsInteger = 0 THEN
//      ppdetailBand1.Objects[com].Font.Size := 10
//    ELSE
//      ppdetailBand1.Objects[com].Font.Size := 9;
//  END
//  ELSE
//    ppdetailBand1.Objects[com].Font.Size := 8;
//
//  ppdetailBand1.Objects[com].Left := 23.813;
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//    ppdetailBand1.Objects[com].Width := 94
//  ELSE
//    ppdetailBand1.Objects[com].Width := 60;
//
//  ppdetailBand1.ObjectByName(dtva, 'ppChp_DetTVA');
//  ppDetailBand1.Objects[dtva].visible := True;
//  IF dm_NegDev.Que_TetImpDVE_DETAXE.asInteger = 1 THEN
//    ppDetailBand1.Objects[dtva].visible := False;
//
//  IF Dm_NegDEv.que_LineImpDvL_LINETIP.AsInteger <> 0 THEN
//  BEGIN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//    BEGIN
//      IF (i = com) OR (i = lmg) OR (i = lmd) THEN
//        ppdetailBand1.Objects[i].Visible := True
//      ELSE
//        ppdetailBand1.Objects[i].Visible := False;
//    END;
//
//    ppdetailBand1.Objects[mtl].Visible := False;
//
//    ppdetailBand1.Objects[st].Visible :=
//      (dm_negDev.Que_LineImpDVL_PXNN.asFloat <> 0) AND
//      (Dm_NegDev.que_LineImpDVL_LINETIP.AsInteger = 3);
//
//    ppdetailBand1.Objects[vc].Visible :=
//      (dm_negDev.Que_LineImpDVL_PXBRUT.asFloat <> 0) AND
//      (Dm_NegDev.que_LineImpDVL_LINETIP.AsInteger IN [1, 4]);
//
//    CASE Dm_NegDev.que_LineImpDVL_LINETIP.AsInteger OF
//      1:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 142;
//          ppdetailBand1.Objects[com].Font.Style := [];
//          ppdetailBand1.Objects[st].Font.Size := 8;
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Size := 8;
//          ppdetailBand1.Objects[vc].Font.Style := [];
//        END;
//      2:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 165;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Style := [fsBold];
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Size := 10;
//          ppdetailBand1.Objects[vc].Font.Style := [];
//        END;
//      3:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 142;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Size := 10;
//          ppdetailBand1.Objects[vc].Font.Size := 10;
//          ppdetailBand1.Objects[com].Font.Style := [];
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Style := [];
//          ppdetailBand1.Objects[rm].Visible := True;
//        END;
//      4:
//        BEGIN
//          ppdetailBand1.Objects[Com].Width := 165;
//          ppdetailBand1.Objects[com].Left := 1;
//          ppdetailBand1.Objects[com].Font.Size := 10;
//          ppdetailBand1.Objects[st].Font.Size := 10;
//          ppdetailBand1.Objects[vc].Font.Size := 10;
//          ppdetailBand1.Objects[com].Font.Style := [];
//          ppdetailBand1.Objects[st].Font.Style := [];
//          ppdetailBand1.Objects[vc].Font.Style := [];
//        END;
//
//    END;
//
//    IF NOT FirstLineOfPg AND (NOT FlagComent) THEN
//      ppdetailBand1.Objects[lht].Visible := True;
//    FlagComent := True;
//
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//    BEGIN
//      IF stdGinkoia.Origine = 2 THEN // brun
//      BEGIN
//        IF (i = tail) OR (i = coul) OR (i = LT) OR (i = LC) OR
//          (i = lht) OR (i = vc) OR (i = st) THEN
//          ppdetailBand1.Objects[i].Visible := False
//        ELSE
//          ppdetailBand1.Objects[i].Visible := True;
//      END
//      ELSE
//      BEGIN
//        IF (i = lht) OR (i = vc) OR (i = st) THEN
//          ppdetailBand1.Objects[i].Visible := False
//        ELSE
//          ppdetailBand1.Objects[i].Visible := True;
//      END;
//    END;
//    IF Dm_NegDev.que_LineImpDVL_SSTOTAL.asInteger <> 0 THEN
//      ppdetailBand1.Objects[rm].Visible := False;
//
//    FlagComent := False;
//  END;
//
//  ppdetailBand1.Objects[lbs].Visible := True;
//
//  IF ppr_RapRv.SecondPass THEN
//  BEGIN
//    IF ppdetailband1.visible THEN Inc(cptDetail);
//    IF CptDetail = Tablo[ppr_RapRv.AbsolutePageNo] THEN
//    BEGIN
//      //      IF FlagComent THEN
////      BEGIN
//        ppdetailBand1.Objects[lbs].Visible := true;
//        //remettre le compteur de ligne de la page à 0
//        CptDetail := 0;
////      END;
//    END
//    ELSE
//      IF NOT FlagComent THEN ppdetailBand1.Objects[lbs].Visible := False;
//
//  END;
//
//  IF NOT Dm_NegDev.ImpLine THEN
//    FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//      IF Uppercase(Copy(ppdetailBand1.Objects[i].Name, 1, 4)) = 'LINE' THEN
//        ppdetailBand1.Objects[i].Visible := False;
//END;
//
//PROCEDURE TFrm_RapRV.NegDevTitleBand1BeforePrint(Sender: TObject);
//VAR
//  clc, clcHT, i, z, Tar: Integer;
//  obj, s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//  ppTitleBand1.ObjectByName(Obj, 'ppChp_Objet');
//  //  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
//  //  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
//  //  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  //  (ppTitleBand1.Objects[Lvd] as TppLabel).Caption := LibVendeur;
//
//  ppSummaryBand1.ObjectByName(clc, 'ppDBCalc_Smry');
//  ppSummaryBand1.ObjectByName(clcHT, 'ppDBCalc_SmryHT');
//  ppSummaryBand1.ObjectByName(tar, 'ppChp_ToTAR');
//  ppSummaryBand1.ObjectByName(cht, 'ppChp_CumHT');
//  FOR i := 1 TO 5 DO
//    ppSummaryBand1.ObjectByName(lht[i], 'ppChp_HT' + intToStr(i));
//
//  ppSummaryBand1.Objects[clc].Visible := True;
//
//  IF Dm_NegDev.Que_TetImpDVE_HTWORK.asInteger = 0 THEN
//  BEGIN
//    (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTTTC';
//
//    (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTTTC';
//    FOR i := 1 TO 5 DO
//      (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'DVE_TVAHT' + IntToStr(i);
//  END
//  ELSE
//  BEGIN
//    (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTHT';
//    (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTHT';
//
//    FOR i := 1 TO 5 DO
//      (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'HT' + IntToStr(i);
//
//  END;
//
//  ppTitleBand1.Objects[obj].Visible := Dm_NegDev.ImpObjet;
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := dm_NegDev.ImpTete;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_negDev.que_TetImpMAGADR.asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negDev.que_TetImpMAGCP.asString + ' ' +
//    dm_negDev.que_TetImpMAGVILLE.asString);
//  IF dm_negDev.ImpPayMag THEN
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negDev.que_TetImpMAGPAYS.asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_negDev.que_TetImpDVE_ADRLIGNE.asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negDev.que_TetImpCLTCP.asString + ' ' +
//    dm_negDev.que_TetImpCLTVILLE.asString);
//  IF dm_negDev.ImpPayClt THEN
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negDev.que_TetImpCLTPAYS.asString);
//
//  //  ppTitleBand1.Objects[vd].Visible := False;
//  //  ppTitleBand1.Objects[vu].Visible := False;
//  //  ppTitleBand1.Objects[lvd].Visible := False;
//  //  if dm_negDev.ImpVend then
//  //    if dm_negDev.Que_TetImpUSR_FULLNAME.asstring <> '' then
//  //    begin
//  //      ppTitleBand1.Objects[vd].Visible := True;
//  //      ppTitleBand1.Objects[lvd].Visible := True;
//  //    end
//  //    else
//  //    begin
//  //      if (dm_negDev.Que_TetImpUSR_USERNAME.asstring <> '') and
//  //        (dm_negDev.Que_TetImpUSR_USERNAME.asstring <> '.') then
//  //      begin
//  //        ppTitleBand1.Objects[vu].Visible := True;
//  //        ppTitleBand1.Objects[lvd].Visible := True;
//  //      end;
//  //    end;
//
//END;
//
//PROCEDURE TFrm_RapRV.NegDevFooterBand1BeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_NegDev.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_NegDev.ImpPg;
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_NegDev.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_NegDev.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_NegDev.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + dm_NegDev.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_NegDev.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_NegDev.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_NegDev.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_NegDev.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_negdev.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negDev.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_negDev.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_negDev.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negDev.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_negDev.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_NegDev.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_NegDev.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_NegDev.ImpPg;
//
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.NegDevSummaryBand1BeforePrint(Sender: TObject);
//VAR
//  tx, tmt, toto, i, c, rm, smt, sto, stv, star: Integer;
//BEGIN
//
//  FOR i := 0 TO ppSummaryBand1.ObjectCount - 1 DO
//  BEGIN
//    ppSummaryBand1.Objects[i].Visible := True;
//    IF dm_negdev.Que_TetImp.FieldByName('DVE_DETAXE').asInteger = 1 THEN
//      ppSummaryBand1.Objects[i].Visible := ppSummaryBand1.Objects[i].Tag <> 1;
//  END;
//
//  ppSummaryBand1.ObjectByName(tx, 'ppLab_Sumtvatx');
//  ppSummaryBand1.ObjectByName(tmt, 'ppLab_Sumtvamt');
//  ppSummaryBand1.ObjectByName(toto, 'ppLab_Sumtvatoto');
//  (ppSummaryBand1.Objects[tx] AS TppLabel).Caption := NegSumTvatx;
//  (ppSummaryBand1.Objects[tmt] AS TppLabel).Caption := NegSumTvamt;
//  (ppSummaryBand1.Objects[toto] AS TppLabel).Caption := NegSumTvatoto;
//
//  ppSummaryBand1.ObjectByName(smt, 'SumryMt');
//  ppSummaryBand1.ObjectByName(sto, 'SumryTotal');
//  ppSummaryBand1.ObjectByName(star, 'SumryTotAR');
//
//  ppSummaryBand1.ObjectByName(stv, 'SumryMtTva');
//  ppSummaryBand1.ObjectByName(rm, 'LabRemSUM');
//
//  (ppSummaryBand1.Objects[rm] AS TppLabel).Caption := NegSumRemGlo;
//  ;
//  (ppSummaryBand1.Objects[rm] AS TppLabel).Visible :=
//    (dm_negDev.Que_TetImp.FieldByName('DVE_REMISE').asFloat <> 0);
//
//  ppSummaryBand1.ObjectByName(c, 'ppChp_NapEuro');
//  ppSummaryBand1.Objects[c].visible :=
//    (dm_NegDev.ImpEuro = True) AND (ABS(Dm_NegDev.Que_TetImp.fieldByName('TTCEURO').asFloat) > 0.01);
//
//  IF Dm_NegDev.Que_TetImpDVE_HTWORK.asInteger = 0 THEN
//  BEGIN
//    (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtTTC;
//    (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalTTC;
//    (ppSummaryBand1.Objects[star] AS TppLabel).Caption := NegSumTotalTTC;
//    (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtTTC;
//  END
//  ELSE
//  BEGIN
//    (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtHT;
//    IF dm_Negdev.Que_TetImpDVE_DETAXE.asInteger <> 1 THEN
//      (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalTTC
//    ELSE
//      (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalHT;
//    (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtHT;
//    (ppSummaryBand1.Objects[star] AS TppLabel).Caption := NegSumTotalHT;
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.NegDevEnteteBeforePrint(Sender: TObject);
//VAR
//  Exprt, pxu, mt, rm, ec, et, elr, ett, elt: Integer;
//  ctva, ltva, labtva, chptva, labclt, clt: Integer;
//  nm, dt, ref, des, etva, eqt, fax, lfax, vu, vd, lvd,
//    usrTel, usrFax, usrGsm, usrEmail, Empl: Integer;
//BEGIN
//  ppHeaderBand1.ObjectByName(lfax, 'ppLab_Fax');
//  ppHeaderBand1.ObjectByName(fax, 'ppchp_Fax');
//
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//  ppHeaderBand1.ObjectByName(ref, 'Entet_Ref');
//  ppHeaderBand1.ObjectByName(des, 'Entet_Des');
////  ppHeaderBand1.ObjectByName(Empl, 'Entet_Empl');
//  ppHeaderBand1.ObjectByName(etva, 'Entet_Tva');
//  ppHeaderBand1.ObjectByName(eqt, 'Entet_Qte');
//
//  ppHeaderBand1.ObjectByName(pxu, 'Entet_Pxu');
//  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
//  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');
//  ppHeaderBand1.ObjectByName(ec, 'Entet_Coul');
//  ppHeaderBand1.ObjectByName(et, 'Entet_Tail');
//  ppHeaderBand1.ObjectByName(rm, 'Entet_Rem');
//  ppHeaderBand1.ObjectByName(mt, 'Entet_Mt');
//
//  //lab 16/10/08 786 Coordonnées utilisateurs
//  ppHeaderBand1.ObjectByName(vd, 'ppChp_UserName');
//  ppHeaderBand1.ObjectByName(lvd, 'LabVendeur');
//  ppHeaderBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  ppHeaderBand1.ObjectByName(usrTel, 'ppChp_USRTEL');
//  ppHeaderBand1.ObjectByName(usrFax, 'ppChp_USRFAX');
//  ppHeaderBand1.ObjectByName(usrGsm, 'ppChp_USRGSM');
//  ppHeaderBand1.ObjectByName(usrEmail, 'ppChp_USREMAIL');
//  (ppHeaderBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//  (ppHeaderBand1.Objects[ref] AS TppLabel).Caption := Negtetref;
//  (ppHeaderBand1.Objects[des] AS TppLabel).Caption := Negtetdes;
////  (ppHeaderBand1.Objects[Empl] AS TppLabel).Caption := NegTetEmpl;
//  (ppHeaderBand1.Objects[etva] AS TppLabel).Caption := Negtettva;
//  (ppHeaderBand1.Objects[eqt] AS TppLabel).Caption := Negtetqte;
//
//  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
//  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;
//  (ppHeaderBand1.Objects[ec] AS TppLabel).Caption := Negtetcoul;
//  (ppHeaderBand1.Objects[et] AS TppLabel).Caption := NegtetTail;
//  (ppHeaderBand1.Objects[rm] AS TppLabel).Caption := NegtetRem;
//
//  ppHeaderBand1.ObjectByName(elr, 'Entet_LCoul');
//  ppHeaderBand1.ObjectByName(elt, 'Entet_LTail');
//  ppHeaderBand1.ObjectByName(clt, 'ppChp_Clt');
//  ppHeaderBand1.ObjectByName(ett, 'Entet_Titre');
//  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
//  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
//  ppHeaderBand1.ObjectByName(Exprt, 'ppLab_Export');
//
//  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
//  //-------------------------------------------
//  TRY
//    ppHeaderBand1.Objects[lfax].visible := Dm_Negdev.Que_TetImpDVE_PRO.asInteger = 1;
//    ppHeaderBand1.Objects[fax].visible := Dm_NegDev.Que_TetImpDVE_PRO.asInteger = 1;
//  EXCEPT
//  END;
//
//  ppHeaderBand1.Objects[etva].visible := True;
//  IF dm_NegDev.Que_TetImpDVE_DETAXE.asInteger = 1 THEN
//  BEGIN
//    ppHeaderBand1.Objects[etva].visible := False;
//    ppHeaderBand1.Objects[Exprt].visible := True;
//  END
//  ELSE ppHeaderBand1.Objects[Exprt].visible := False;
//
//  IF dm_NegDev.ImpTva THEN // intracomunautaire
//  BEGIN
//    ppHeaderBand1.Objects[ctva].visible := True;
//    ppHeaderBand1.Objects[ltva].visible := True;
//    ppHeaderBand1.Objects[labtva].visible := True;
//    ppHeaderBand1.Objects[chptva].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//  IF Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId THEN
//  BEGIN
//    ppHeaderBand1.Objects[clt].visible := True;
//    ppHeaderBand1.Objects[labclt].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[clt].visible := False;
//    ppHeaderBand1.Objects[labclt].visible := False;
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//  IF Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId THEN
//    (ppHeaderBand1.Objects[ett] AS TppLabel).Caption := dm_Negdev.ImpDevForma
//  ELSE (ppHeaderBand1.Objects[ett] AS TppLabel).Caption := Copy(dm_Negdev.que_TetImpDVE_MODELE.asstring, 1, 50);
//
//  (ppHeaderBand1.Objects[ett] AS TppLabel).Visible := ppr_raprv.absolutePageNo = 1;
//
//  IF Dm_NegDev.Que_TetImpDVE_HTWORK.asInteger = 0 THEN
//  BEGIN
//    (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuTTC;
//    (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtTTC;
//  END
//  ELSE
//  BEGIN
//    (ppHeaderBand1.Objects[pxu] AS TppLabel).Caption := NegEntetPxuHT;
//    (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtHT;
//  END;
//
//  // Paramétrage des entêtes de pages
//
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//  BEGIN
//    ppHeaderBand1.Objects[ec].visible := False;
//    ppHeaderBand1.Objects[et].visible := False;
//    ppHeaderBand1.Objects[elr].visible := False;
//    ppHeaderBand1.Objects[elt].visible := False;
//  END
//  ELSE
//  BEGIN
//    IF dm_NegDev.ImpTailCoul THEN
//    BEGIN
//      ppHeaderBand1.Objects[ec].visible := True;
//      ppHeaderBand1.Objects[et].visible := True;
//    END
//    ELSE BEGIN
//      ppHeaderBand1.Objects[ec].visible := False;
//      ppHeaderBand1.Objects[et].visible := False;
//    END;
//    ppHeaderBand1.Objects[elr].visible := True;
//    ppHeaderBand1.Objects[elt].visible := True;
//  END;
//
//  IF dm_negDev.ImpRem THEN
//    ppHeaderBand1.Objects[rm].visible := True
//  ELSE
//    ppHeaderBand1.Objects[rm].visible := False;
//
//  ppHeaderBand1.Objects[vd].Visible := False;
//  ppHeaderBand1.Objects[vu].Visible := False;
//  //ppHeaderBand1.Objects[lvd].Visible := False;
//  //lab 16/10/08 786  Plus de détail sur l'utilisateur
//  ppHeaderBand1.Objects[usrTel].Visible := False;
//  ppHeaderBand1.Objects[usrFax].Visible := False;
//  ppHeaderBand1.Objects[usrGsm].Visible := False;
//  ppHeaderBand1.Objects[usrEmail].Visible := False;
//  IF dm_negDev.ImpVend THEN
//    IF dm_negDev.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
//    BEGIN
//      ppHeaderBand1.Objects[vd].Visible := True;
//      //ppHeaderBand1.Objects[lvd].Visible := True;
//      //lab 16/10/08 786  Plus de détail sur l'utilisateur
//      ppHeaderBand1.Objects[usrTel].Visible := True;
//      ppHeaderBand1.Objects[usrFax].Visible := True;
//      ppHeaderBand1.Objects[usrGsm].Visible := True;
//      ppHeaderBand1.Objects[usrEmail].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (dm_negDev.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_negDev.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
//      BEGIN
//        ppHeaderBand1.Objects[vu].Visible := True;
//        //ppHeaderBand1.Objects[lvd].Visible := True;
//        //lab 16/10/08 786  Plus de détail sur l'utilisateur
//        ppHeaderBand1.Objects[usrTel].Visible := True;
//        ppHeaderBand1.Objects[usrFax].Visible := True;
//        ppHeaderBand1.Objects[usrGsm].Visible := True;
//        ppHeaderBand1.Objects[usrEmail].Visible := True;
//      END;
//    END;
//
//END;
//
PROCEDURE TFrm_RapRV.NegDevTitleBand1BeforeGenerate(Sender: TObject);
VAR
  obj, i, h: Integer;
BEGIN
  // le titre n'est que sur la 1ère page
  IF ppr_RapRv.AbsolutePageNo = 1 THEN
  BEGIN
    IF Copy(Letat, 1, 5) = 'DEVIS' THEN
    BEGIN
      // Objet dynamique Pour les devis seulement !
      ppTitleBand1.ObjectByName(Obj, 'ppChp_Objet');
      i := (ppTitleBand1.Objects[obj] AS TppDBMemo).Lines.Count;
      IF i = 0 THEN
      BEGIN
        ppTitleBand1.Height := 70.641;
        ppTitleBand1.Objects[obj].Height := 0;
      END
      ELSE BEGIN
        IF i > 10 THEN i := 10;
        h := 10 - i;
        ppTitleBand1.Height := 110.331 - (3.939 * h);
        (ppTitleBand1.Objects[obj] AS TppDBMemo).Height := 3.939 * i;
      END;
      (ppTitleBand1.Objects[obj] AS TppDBMemo).Top := 70.641;
    END;

    ppPageStyle1.Objects[CadFirstPg].Top := (ppTitleBand1.Height + pptitleBand1.BottomOffset);
    ppPageStyle1.Objects[CadFirstPg].Height := ppPageStyle1.Height - (ppPageStyle1.Objects[CadFirstPg].Top + ppFooterBand1.Height);

  END;

END;

PROCEDURE TFrm_RapRV.NegDevHeaderBand1BeforeGenerate(Sender: TObject);
BEGIN
  IF ppr_RapRv.AbsolutePageNo = 1 THEN
  BEGIN
    ppPageStyle1.Objects[CadFirstPg].Top := ppPageStyle1.Objects[CadFirstPg].top + (ppHeaderBand1.Height + ppHeaderBand1.BottomOffset);
    ppPageStyle1.Objects[CadFirstPg].Height := ppPageStyle1.Height - (ppPageStyle1.Objects[CadFirstPg].Top + ppFooterBand1.Height);
  END
  ELSE
  BEGIN
    ppPageStyle1.Objects[CadPg].Top := ppHeaderBand1.Height + ppHeaderBand1.BottomOffset;
    ppPageStyle1.Objects[CadPg].Height := ppPageStyle1.Height - (ppPageStyle1.Objects[CadPg].Top + ppFooterBand1.Height);

    IF ppr_RapRv.AbsolutePageNo = ppr_RapRv.PageCount THEN
    BEGIN
      ppPageStyle1.Objects[CadLastPg].Top := ppHeaderBand1.Height + ppHeaderBand1.BottomOffset;
      ppPageStyle1.Objects[CadLastPg].Height := ppSummaryBand1.PrintPosition - (ppPageStyle1.Objects[CadLastPg].Top +
        PPr_Raprv.PrinterSetup.MarginTop)
    END;
  END;
END;
//
PROCEDURE TFrm_RapRV.NegDevSummaryBand1BeforeGenerate(Sender: TObject);
BEGIN
  // Le summary ne peut être dans une page intermédiaire
  IF ppr_RapRv.AbsolutePageNo = 1 THEN
    ppPageStyle1.Objects[CadFirstPg].Height := ppSummaryBand1.PrintPosition - (ppPageStyle1.Objects[CadFirstPg].Top +
      PPr_Raprv.PrinterSetup.MarginTop)
END;

PROCEDURE TFrm_RapRV.NegDevStartPage;
BEGIN
  ppPageStyle1.Objects[CadFirstPg].Visible := ppr_RapRv.AbsolutePageNo = 1;
  ppPageStyle1.Objects[CadPg].Visible := (ppr_RapRv.AbsolutePageNo <> 1) AND
    (ppr_RapRv.AbsolutePageNo <> ppr_RapRv.AbsolutePageCount);
  ppPageStyle1.Objects[CadLastPg].Visible :=
    (ppr_RapRv.AbsolutePageNo = ppr_RapRv.AbsolutePageCount) AND
    (ppr_RapRv.AbsolutePageNo <> 1);
END;

// -------------------- Nomenclature -------------------------------------

PROCEDURE TFrm_RapRV.NKRVGroupHeaderBand1BeforePrint(Sender: TObject);
//VAR
//  linT, lin, lab, chp, ft, ray: Integer;
BEGIN
//  ppGroupHeaderBand1.ObjectByName(lin, 'LineRay');
//  ppGroupHeaderBand1.ObjectByName(linT, 'LineRayT');
//  ppGroupHeaderBand1.ObjectByName(lab, 'LabSec');
//  ppGroupHeaderBand1.ObjectByName(chp, 'ppChp_Sec');
//  ppGroupHeaderBand1.ObjectByName(Ray, 'ppChp_Ray');

//  ft := 9 + (2 * (frm_NkRV.Levimp - 1));
//  (ppGroupHeaderBand1.Objects[Ray] AS TppdbText).Font.Size := ft;
//  IF frm_NkRV.Levimp > 1 THEN
//    (ppGroupHeaderBand1.Objects[Ray] AS TppdbText).Font.Style := [fsBold]
//  ELSE
//    (ppGroupHeaderBand1.Objects[Ray] AS TppdbText).Font.Style := [];

//  ppGroupHeaderBand1.Objects[lin].Visible := frm_NkRV.Levimp > 1;
//  ppGroupHeaderBand1.Objects[chp].Visible := frm_NkRV.SecVis AND
//    (Trim(frm_NkRv.que_ImpNkSEC_NOM.asstring) <> '');
//  ppGroupHeaderBand1.Objects[lab].Visible := ppGroupHeaderBand1.Objects[chp].Visible;
//
//  ppGroupHeaderBand1.Objects[linT].Visible := (frm_NkRV.Levimp > 1) AND
//    ppGroupHeaderBand1.Objects[chp].Visible;

END;

PROCEDURE TFrm_RapRV.NkRVGroupHeaderBand2BeforePrint(Sender: TObject);
//VAR
//  lin, lab, chp, ft, fam, lint: Integer;
BEGIN
//  ppGroupHeaderBand2.Visible := frm_NkRV.Levimp > 1;
//  IF ppGroupHeaderBand2.Visible THEN
//  BEGIN
//    ppGroupHeaderBand2.ObjectByName(lin, 'LineFam');
//    ppGroupHeaderBand2.ObjectByName(lab, 'LabCtf');
//    ppGroupHeaderBand2.ObjectByName(chp, 'ppChp_Ctf');
//    ppGroupHeaderBand2.ObjectByName(fam, 'ppChp_Fam');
//    ppGroupHeaderBand1.ObjectByName(linT, 'LineRayT');
//
//    ft := 9 + (2 * (frm_NkRV.Levimp - 2));
//    (ppGroupHeaderBand2.Objects[fam] AS TppdbText).Font.Size := ft;
//    IF frm_NkRV.Levimp > 2 THEN
//      (ppGroupHeaderBand2.Objects[fam] AS TppdbText).Font.Style := [fsBold]
//    ELSE
//      (ppGroupHeaderBand2.Objects[fam] AS TppdbText).Font.Style := [];
//
//    ppGroupHeaderBand2.Objects[lin].Visible := frm_NkRV.Levimp > 2;
//    ppGroupHeaderBand2.Objects[chp].Visible := frm_NkRV.CtfVis AND
//      (Trim(frm_NkRv.que_ImpNkCTF_NOM.asstring) <> '');
//    ppGroupHeaderBand2.Objects[lab].Visible := ppGroupHeaderBand2.Objects[chp].Visible;
//
//    ppGroupHeaderBand2.Objects[linT].Visible := (frm_NkRV.Levimp > 2) AND
//      ppGroupHeaderBand2.Objects[chp].Visible AND frm_NkRV.CatVis;
//
//  END;
END;

PROCEDURE TFrm_RapRV.NkRVDetailBand1BeforePrint(Sender: TObject);
//VAR
//  lab, chp: Integer;
BEGIN
//  ppDetailBand1.Visible := frm_NkRV.Levimp > 2;
//  IF ppDetailBand1.Visible THEN
//  BEGIN
//    ppDetailBand1.ObjectByName(lab, 'LabCat');
//    ppDetailBand1.ObjectByName(chp, 'ppChp_Cat');
//
//    ppDetailBand1.Objects[chp].Visible := frm_NkRV.CatVis AND
//      (Trim(frm_NkRv.que_ImpNkCAT_NOM.asstring) <> '');
//    ppDetailBand1.Objects[lab].Visible := ppDetailBand1.Objects[chp].Visible;
//  END;

END;

PROCEDURE TFrm_RapRV.NKRVHeaderBand1BeforePrint(Sender: TObject);
//VAR
//  lab: Integer;
BEGIN
//  ppHeaderBand1.Visible := Trim(Frm_NkRv.ImpCap) <> '';
//  IF ppHeaderBand1.Visible THEN
//  BEGIN
//    ppHeaderBand1.ObjectByName(lab, 'LabTitre');
//    (ppHeaderBand1.Objects[lab] AS TppLabel).Caption := Frm_NkRv.ImpCap;
//  END;

END;

PROCEDURE TFrm_RapRV.NKRVBeforePrint;
BEGIN
//  ppGroupHeaderBand1.Group.NewPage := Frm_Nkrv.Levimp > 1;
//  IF (NOT ppGroupHeaderBand1.Group.NewPage) AND (Frm_Nkrv.Levimp = 2) THEN ppGroupHeaderBand1.Group.NewPageThreshold := 100;
END;

//PROCEDURE TFrm_RapRV.BCDEppDetailBand1BeforePrint(Sender: TObject);
//BEGIN
//  IF (stdGinkoia.Origine = 2) OR ((dm_ImpBcde.Que_ImpcdeNBTAIL.asInteger < 2) AND
//    (dm_ImpBcde.Que_ImpcdeNBCOUL.asInteger < 2)) THEN
//    ppDetailBand1.Visible := False
//  ELSE BEGIN
//    ppDetailBand1.Visible := True;
//    IF dm_ImpBcde.que_ImpCdeTipLine.asInteger = 2 THEN
//    BEGIN
//      IF dm_ImpBcde.que_ImpCdeMultiPx.asInteger = 0 THEN
//        ppDetailBand1.Visible := dm_ImpBcde.ImpPxu AND (dm_ImpBcde.Que_ImpcdeMULTIPX.asInteger <> 0)
//    END;
//  END;
//END;

//PROCEDURE TFrm_RapRV.BCDEppTitleBand1BeforePrint(Sender: TObject);
//VAR
//  i, LabCde, NomSoc, Page, NomMag, AdrMag, LabLivr, AdrLivr, RemGlo, LabRemGlo: Integer;
//  Datimp, LabDatImp, LabDatLivr, Tcde, FCde: Integer;
//  BasGrp, LabCadDef, CadDef, LabQteCum, QteCum, LabMtCum, MtCum: Integer;
//BEGIN
//
//  ppTitleBand1.ObjectByName(Datimp, 'ppSysVar_DatImpCde');
//  ppTitleBand1.ObjectByName(TCDE, 'ppChp_TetCde');
//  ppTitleBand1.ObjectByName(LabDatimp, 'ppLab_DatImpCde');
//  ppTitleBand1.ObjectByName(LabCde, 'ppLab_Cde');
//  ppTitleBand1.ObjectByName(NomSoc, 'ppChp_NomSocCde');
//  ppTitleBand1.ObjectByName(NomMag, 'ppChp_NomMagCde');
//  ppTitleBand1.ObjectByName(AdrMag, 'ppChp_AdrMagCde');
//  ppTitleBand1.ObjectByName(LabLivr, 'ppLab_AdrLivrCde');
//  ppTitleBand1.ObjectByName(AdrLivr, 'ppChp_AdrLivrCde');
//  ppTitleBand1.ObjectByName(LabCadDef, 'ppLab_CadDefCde');
//  ppTitleBand1.ObjectByName(CadDef, 'ppChp_CadDefCde');
//
//  //    ppFooterBand1.ObjectByName ( Pied, 'ppChp_PiedCde' ) ;
//  //    ( ppFooterBand1.Objects[Pied] As TPPDbMemo).Top := ppFooterBand1.Height - 9.525;
//  ppFooterBand1.ObjectByName(Page, 'ppSysVar_Page');
//  (ppFooterBand1.Objects[Page] AS TPPSystemVariable).Top := ppFooterBand1.Height - 4;
//
//  ppSummaryBand1.ObjectByName(FCDE, 'ppChp_FinCde');
//  ppSummaryBand1.ObjectByName(RemGlo, 'ppChp_RemGloCde');
//  ppSummaryBand1.ObjectByName(LabRemGlo, 'ppLab_RemGloCde');
//  ppSummaryBand1.ObjectByName(LabQteCum, 'ppLab_QteCumCde');
//  ppSummaryBand1.ObjectByName(QteCum, 'ppChp_QteCumCde');
//  ppSummaryBand1.ObjectByName(LabMtCum, 'ppLab_MtCumHTCde');
//  ppSummaryBand1.ObjectByName(MtCum, 'ppChp_MtCumHTCde');
//
//  ppSummaryBand1.Objects[RemGlo].Visible := dm_ImpBcde.Que_ImpTetCDE_REMGLO.asFloat <> 0;
//  ppSummaryBand1.Objects[LabRemGlo].Visible := ppSummaryBand1.Objects[RemGlo].Visible;
//
//  ppTitleBand1.Objects[LabLivr].Visible := dm_ImpBcde.Que_ImpTetADRLIVR.asstring <> '';
//  ppTitleBand1.Objects[LabCadDef].Visible := NOT dm_ImpBcde.ImpCadence;
//  ppTitleBand1.Objects[CadDef].Visible := NOT dm_ImpBcde.ImpCadence;
//
//  IF dm_ImpBcde.ImpValCum THEN
//  BEGIN
//    FOR i := 0 TO ppSummaryBand1.ObjectCount - 1 DO
//      ppSummaryBand1.Objects[i].Visible := True;
//  END
//  ELSE BEGIN
//    (ppSummaryBand1.Objects[LabQteCum] AS TppLabel).Left := (ppSummaryBand1.Objects[LabMtCum] AS TppLabel).Left;
//    (ppSummaryBand1.Objects[QteCum] AS TppDBText).Left := (ppSummaryBand1.Objects[MtCum] AS TppDBText).Left;
//
//    FOR i := 0 TO ppSummaryBand1.ObjectCount - 1 DO
//    BEGIN
//      IF (Uppercase(ppSummaryBand1.Objects[i].Name) = 'PPLAB_QTECUMCDE') OR
//        (Uppercase(ppSummaryBand1.Objects[i].Name) = 'PPCHP_QTECUMCDE') OR
//        (Uppercase(ppSummaryBand1.Objects[i].Name) = 'PPSHAPE_QTECUMCDE') OR
//        (Uppercase(ppSummaryBand1.Objects[i].Name) = 'PPCHP_FINCDE') THEN
//        ppSummaryBand1.Objects[i].Visible := True
//      ELSE
//        ppSummaryBand1.Objects[i].Visible := False;
//    END;
//  END;
//
//  (ppTitleBand1.Objects[TCde] AS TppMemo).Lines.Text := '';
//  IF (Trim(dm_ImpBcde.TetImpCde) <> '') AND dm_ImpBcde.ImpDebCde THEN
//    (ppTitleBand1.Objects[TCde] AS TppMemo).Lines.Text := dm_ImpBcde.TetImpCde;
//  (ppSummaryBand1.Objects[FCde] AS TppMemo).Lines.Text := '';
//  IF (Trim(dm_ImpBcde.FinImpCde) <> '') AND dm_ImpBcde.ImpFinCde THEN
//    (ppSummaryBand1.Objects[FCde] AS TppMemo).Lines.Text := dm_ImpBcde.FinImpCde;
//
//  ppTitleBand1.Objects[NomSoc].Visible := dm_ImpBcde.ImpTete;
//  ppTitleBand1.Objects[LabCde].Visible := dm_ImpBcde.ImpTete;
//  ppTitleBand1.Objects[NomMag].Visible := dm_ImpBcde.ImpTete;
//  ppTitleBand1.Objects[AdrMag].Visible := dm_ImpBcde.ImpTete;
//
//  ppTitleBand1.Objects[DatImp].Visible := dm_ImpBcde.ImpDate;
//  ppTitleBand1.Objects[LabDatImp].Visible := dm_ImpBcde.ImpDate;
//
//  IF dm_ImpBcde.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//  END
//  ELSE BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//  END;
//  ppFooterBand1.Objects[Page].visible := dm_ImpBcde.ImpPg;
//
//  // *** HeaderBand1 & GroupHeaderBand1 ******************************************************
//
//  IF (stdGinkoia.Origine = 2) OR ((dm_ImpBcde.Que_ImpcdeNBTAIL.asInteger < 2) AND
//    (dm_ImpBcde.Que_ImpcdeNBCOUL.asInteger < 2)) THEN
//  BEGIN
//    ppGroupHeaderBand1.ObjectByName(BasGrp, 'ppLine_BasGrp');
//    ppGroupFooterBand1.Visible := False;
//    ppGroupHeaderBand1.BottomOffset := 0.5;
//    ppGroupHeaderBand1.Height :=
//      (ppGroupHeaderBand1.Objects[BasGrp] AS TppLine).Top +
//      (ppGroupHeaderBand1.Objects[BasGrp] AS TppLine).Height;
//  END
//  ELSE BEGIN
//    // Dans ce cas le PxU n'est jamais imprimé si multipx d'achat donc je force
//    IF (dm_ImpBcde.Que_ImpcdeMULTIPX.asInteger <> 0) THEN dm_ImpBcde.ImpPxu := False;
//    ppGroupFooterBand1.Visible := True;
//    ppGroupHeaderBand1.BottomOffset := 0;
//    ppGroupHeaderBand1.Height := 5.027;
//  END;
//
//  ppHeaderBand1.ObjectByName(LabDatLivr, 'ppLab_Livraison');
//  IF dm_ImpBcde.ImpDelai THEN
//    (ppHeaderBand1.Objects[LabDatLivr] AS TppLabel).Caption := LibCadDelai
//  ELSE
//    (ppHeaderBand1.Objects[LabDatLivr] AS TppLabel).Caption := LibDatLivr;
//
//  FOR i := 0 TO ppHeaderBand1.ObjectCount - 1 DO
//  BEGIN
//    CASE ppHeaderBand1.Objects[i].Tag OF
//      4: ppHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpPxU;
//      5: ppHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpMtPxCat;
//      6: ppHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpLineRem;
//      7: ppHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpMtLine;
//      8: ppHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpCadence;
//      9: ppHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpDelai AND dm_ImpBcde.ImpCadence;
//    END;
//  END;
//
//  FOR i := 0 TO ppGroupHeaderBand1.ObjectCount - 1 DO
//  BEGIN
//    CASE ppGroupHeaderBand1.Objects[i].Tag OF
//      4: ppGroupHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpPxU;
//      5: ppGroupHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpMtPxCat;
//      6: ppGroupHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpLineRem;
//      7: ppGroupHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpMtLine;
//      8: ppGroupHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpCadence;
//      9: ppGroupHeaderBand1.Objects[i].Visible := dm_ImpBcde.ImpDelai AND dm_ImpBcde.ImpCadence;
//    END;
//  END;
//
//END;

PROCEDURE TFrm_RapRV.Que_HistoImpAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_RapRV.Que_HistoImpUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

//PROCEDURE TFrm_RapRV.BCDEFooterBand1BeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_ImpBcde.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_ImpBcde.ImpPg;
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_PiedCde');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_ImpBcde.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_ImpBcde.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_ImpBcde.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_ImpBcde.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + dm_ImpBcde.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_ImpBcde.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_ImpBcde.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_ImpBcde.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_ImpBcde.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_ImpBcde.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_ImpBcde.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_ImpBcde.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_ImpBcde.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_ImpBcde.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_ImpBcde.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_ImpBcde.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_ImpBcde.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_ImpBcde.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_ImpBcde.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_ImpBcde.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_ImpBcde.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_ImpBcde.ImpPg;
//
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.AnnulppDetailBand1BeforePrint(Sender: TObject);
//BEGIN
//  IF (stdGinkoia.Origine = 2) OR ((dm_Ral.Que_ImpAnuNBTAIL.asInteger < 2) AND
//    (dm_Ral.Que_ImpAnuNBCOUL.asInteger < 2)) THEN
//    ppDetailBand1.Visible := False
//  ELSE BEGIN
//    ppDetailBand1.Visible := True;
//    IF dm_Ral.que_ImpAnuTipLine.asInteger = 2 THEN
//    BEGIN
//      IF dm_Ral.que_ImpAnuMultiPx.asInteger = 0 THEN
//        ppDetailBand1.Visible := dm_Ral.ImpPxu AND (dm_Ral.Que_ImpAnuMULTIPX.asInteger <> 0)
//    END;
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.AnnulppTitleBand1BeforePrint(Sender: TObject);
//VAR
//  i, LabCde, NomSoc, Page, NomMag, AdrMag, LabLivr, AdrLivr: Integer;
//  Datimp, LabDatImp, LabDatLivr: Integer;
//  BasGrp, LabQteCum, QteCum: Integer;
//BEGIN
//
//  ppTitleBand1.ObjectByName(Datimp, 'ppSysVar_DatImpCde');
//  ppTitleBand1.ObjectByName(LabDatimp, 'ppLab_DatImpCde');
//  ppTitleBand1.ObjectByName(LabCde, 'ppLab_Cde');
//  ppTitleBand1.ObjectByName(NomSoc, 'ppChp_NomSocCde');
//  ppTitleBand1.ObjectByName(NomMag, 'ppChp_NomMagCde');
//  ppTitleBand1.ObjectByName(AdrMag, 'ppChp_AdrMagCde');
//  ppTitleBand1.ObjectByName(LabLivr, 'ppLab_AdrLivrCde');
//  ppTitleBand1.ObjectByName(AdrLivr, 'ppChp_AdrLivrCde');
//
//  //    ppFooterBand1.ObjectByName ( Pied, 'ppChp_PiedCde' ) ;
//  //    ( ppFooterBand1.Objects[Pied] As TPPDbMemo).Top := ppFooterBand1.Height - 9.525;
//  ppFooterBand1.ObjectByName(Page, 'ppSysVar_Page');
//  (ppFooterBand1.Objects[Page] AS TPPSystemVariable).Top := ppFooterBand1.Height - 4;
//
//  ppSummaryBand1.ObjectByName(LabQteCum, 'ppLab_QteCumCde');
//  ppSummaryBand1.ObjectByName(QteCum, 'ppChp_QteCumCde');
//
//  ppTitleBand1.Objects[LabLivr].Visible := Dm_Ral.Que_ImpTetADRLIVR.asstring <> '';
//  ppTitleBand1.Objects[NomSoc].Visible := dm_Ral.ImpTete;
//  ppTitleBand1.Objects[Labcde].Visible := dm_Ral.ImpTete;
//  ppTitleBand1.Objects[NomMag].Visible := dm_Ral.ImpTete;
//  ppTitleBand1.Objects[AdrMag].Visible := dm_Ral.ImpTete;
//
//  ppTitleBand1.Objects[DatImp].Visible := dm_Ral.ImpDate;
//  ppTitleBand1.Objects[LabDatImp].Visible := dm_Ral.ImpDate;
//
//  FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//  BEGIN
//    IF dm_Ral.ImpPied = False THEN
//      ppFooterBand1.Objects[i].Visible := False
//    ELSE
//      ppFooterBand1.Objects[i].Visible := True;
//  END;
//  ppFooterBand1.Objects[Page].visible := dm_Ral.ImpPg;
//
//  // *** HeaderBand1 & GroupHeaderBand1 ******************************************************
//
//  IF (stdGinkoia.Origine = 2) OR ((dm_Ral.Que_ImpAnuNBTAIL.asInteger < 2) AND
//    (dm_Ral.Que_ImpAnuNBCOUL.asInteger < 2)) THEN
//  BEGIN
//    ppGroupHeaderBand1.ObjectByName(BasGrp, 'ppLine_BasGrp');
//    ppGroupFooterBand1.Visible := False;
//    ppGroupHeaderBand1.BottomOffset := 0.5;
//    ppGroupHeaderBand1.Height :=
//      (ppGroupHeaderBand1.Objects[BasGrp] AS TppLine).Top +
//      (ppGroupHeaderBand1.Objects[BasGrp] AS TppLine).Height;
//  END
//  ELSE BEGIN
//    // Dans ce cas le PxU n'est jamais imprimé si multipx d'achat donc je force
//    IF (dm_Ral.Que_ImpAnuMULTIPX.asInteger <> 0) THEN Dm_Ral.ImpPxu := False;
//    ppGroupFooterBand1.Visible := True;
//    ppGroupHeaderBand1.BottomOffset := 0;
//    ppGroupHeaderBand1.Height := 5.027;
//  END;
//
//  ppHeaderBand1.ObjectByName(LabDatLivr, 'ppLab_Livraison');
//  IF dm_Ral.ImpDelai THEN
//    (ppHeaderBand1.Objects[LabDatLivr] AS TppLabel).Caption := LibCadDelai
//  ELSE
//    (ppHeaderBand1.Objects[LabDatLivr] AS TppLabel).Caption := LibDatLivr;
//
//  FOR i := 0 TO ppHeaderBand1.ObjectCount - 1 DO
//  BEGIN
//    CASE ppHeaderBand1.Objects[i].Tag OF
//      4: ppHeaderBand1.Objects[i].Visible := Dm_Ral.ImpPxU;
//      5: ppHeaderBand1.Objects[i].Visible := Dm_Ral.ImpMtPxCat;
//      6: ppHeaderBand1.Objects[i].Visible := Dm_Ral.ImpLineRem;
//      7: ppHeaderBand1.Objects[i].Visible := Dm_Ral.ImpMtLine;
//      8: ppHeaderBand1.Objects[i].Visible := Dm_Ral.ImpCadence;
//      9: ppHeaderBand1.Objects[i].Visible := Dm_Ral.ImpDelai AND dm_Ral.ImpCadence;
//    END;
//  END;
//
//  FOR i := 0 TO ppGroupHeaderBand1.ObjectCount - 1 DO
//  BEGIN
//    CASE ppGroupHeaderBand1.Objects[i].Tag OF
//      4: ppGroupHeaderBand1.Objects[i].Visible := Dm_Ral.ImpPxU;
//      5: ppGroupHeaderBand1.Objects[i].Visible := Dm_Ral.ImpMtPxCat;
//      6: ppGroupHeaderBand1.Objects[i].Visible := Dm_Ral.ImpLineRem;
//      7: ppGroupHeaderBand1.Objects[i].Visible := Dm_Ral.ImpMtLine;
//      8: ppGroupHeaderBand1.Objects[i].Visible := Dm_Ral.ImpCadence;
//      9: ppGroupHeaderBand1.Objects[i].Visible := Dm_Ral.ImpDelai AND dm_Ral.ImpCadence;
//    END;
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.AnnulppTitleBand1AfterGenerate(Sender: TObject);
//VAR
//  obj, i, h: Integer;
//BEGIN
//  // le titre n'est que sur la 1ère page
//  IF ppr_RapRv.AbsolutePageNo = 1 THEN
//  BEGIN
//    IF Copy(Letat, 1, 5) = 'ANNUL' THEN
//    BEGIN
//      ppTitleBand1.ObjectByName(Obj, 'ppChp_Objet');
//      i := (ppTitleBand1.Objects[obj] AS TppDBMemo).Lines.Count;
//      IF i = 0 THEN
//      BEGIN
//        ppTitleBand1.Height := 97.896;
//        ppTitleBand1.Objects[obj].Height := 0;
//      END
//      ELSE BEGIN
//        IF i > 10 THEN i := 10;
//        h := 10 - i;
//        ppTitleBand1.Height := 137.584 - (3.939 * h);
//        (ppTitleBand1.Objects[obj] AS TppDBMemo).Height := 3.939 * i;
//      END;
//      (ppTitleBand1.Objects[obj] AS TppDBMemo).Top := 97.896;
//    END;
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.ANNULFooterBand1BeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_RAL.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_RAL.ImpPg;
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_PiedCde');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_RAL.que_MagsImp.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_RAL.que_MagsImp.FieldByName('SOC_FORME').asString;
//      IF dm_RAL.que_MagsImp.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_RAL.que_MagsImp.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + dm_RAL.que_MagsImp.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_RAL.que_MagsImp.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_RAL.que_MagsImp.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_RAL.que_MagsImp.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_RAL.que_MagsImp.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_RAL.que_MagsImp.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_RAL.que_MagsImp.FieldByName('SOC_APE').asString + ' -';
//    IF dm_RAL.que_MagsImp.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_RAL.que_MagsImp.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_RAL.que_MagsImp.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_RAL.que_MagsImp.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_RAL.que_MagsImp.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_RAL.que_MagsImp.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_RAL.que_MagsImp.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_RAL.que_MagsImp.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_RAL.que_MagsImp.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_RAL.que_MagsImp.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//    ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//    ppFooterBand1.Objects[i].visible := dm_RAL.ImpPg;
//
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.TRFDetailBeforePrint(Sender: TObject);
//VAR
//  i: Integer;
//  com, lmg, lmd, lbs, lht, tail, coul, ref: Integer;
//  dtva, LT, LC, mtl: Integer;
//BEGIN
//
//  ppdetailBand1.ObjectByName(mtl, 'ppChp_MTLine');
//  ppdetailBand1.ObjectByName(com, 'ppChp_Coment');
//  ppdetailBand1.ObjectByName(lmg, 'LineMG');
//  ppdetailBand1.ObjectByName(lmd, 'LineMD');
//  ppdetailBand1.ObjectByName(lbs, 'LineBas');
//  ppdetailBand1.ObjectByName(lht, 'LineHaut');
//
//  ppdetailBand1.ObjectByName(tail, 'ppChp_Taille');
//  ppdetailBand1.ObjectByName(coul, 'ppChp_Coul');
//  ppdetailBand1.ObjectByName(ref, 'ppChp_Ref');
//
//  ppdetailBand1.ObjectByName(LT, 'LineTail');
//  ppdetailBand1.ObjectByName(LC, 'LineCoul');
//
//  ppdetailBand1.Objects[mtl].Visible := True;
//
//  ppdetailBand1.ObjectByName(dtva, 'ppChp_DetTVA');
//  ppDetailBand1.Objects[dtva].visible := True;
//
//  ppdetailBand1.Objects[com].Font.Style := [];
//  IF (ppdetailBand1.Objects[com] AS TppDBMemo).Lines.Count > 1 THEN
//    ppdetailBand1.Objects[com].Font.Size := 10
//  ELSE
//    ppdetailBand1.Objects[com].Font.Size := 8;
//
//  ppdetailBand1.Objects[com].Left := 23.813;
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//    ppdetailBand1.Objects[com].Width := 94
//  ELSE
//    ppdetailBand1.Objects[com].Width := 60;
//
//  FOR i := 0 TO ppdetailBand1.ObjectCount - 1 DO
//  BEGIN
//    IF stdGinkoia.Origine = 2 THEN // brun
//    BEGIN
//      IF (i = tail) OR (i = coul) OR (i = LT) OR (i = LC) OR
//        (i = lht) THEN
//        ppdetailBand1.Objects[i].Visible := False
//      ELSE
//        ppdetailBand1.Objects[i].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (i = lht) THEN
//        ppdetailBand1.Objects[i].Visible := False
//      ELSE
//        ppdetailBand1.Objects[i].Visible := True;
//    END;
//  END;
//
//  FlagComent := False;
//
//  ppdetailBand1.Objects[lbs].Visible := True;
//
//  IF ppr_RapRv.SecondPass THEN
//  BEGIN
//    IF ppdetailband1.visible THEN Inc(cptDetail);
//    IF CptDetail <> Tablo[ppr_RapRv.AbsolutePageNo] THEN
//      ppdetailBand1.Objects[lbs].Visible := False;
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.TRFEnteteBeforePrint(Sender: TObject);
//VAR
//  pxu, mt, n, ec, et, elr, elt: Integer;
//  ctva, ltva, chptva: Integer;
//  nm, dt, ref, des, etva, eqt: Integer;
//  Desig, lbo, Empl: integer;
//BEGIN
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//  ppHeaderBand1.ObjectByName(ref, 'Entet_Ref');
//  ppHeaderBand1.ObjectByName(des, 'Entet_Des');
////  ppHeaderBand1.ObjectByName(Empl, 'Entet_Empl');
//  ppHeaderBand1.ObjectByName(etva, 'Entet_Tva');
//  ppHeaderBand1.ObjectByName(eqt, 'Entet_Qte');
//
//  ppHeaderBand1.ObjectByName(pxu, 'Entet_Pxu');
//  ppHeaderBand1.ObjectByName(ec, 'Entet_Coul');
//  ppHeaderBand1.ObjectByName(et, 'Entet_Tail');
//  ppHeaderBand1.ObjectByName(mt, 'Entet_Mt');
//  ppHeaderBand1.ObjectByName(n, 'ppLab_NFac');
//  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
//  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
//  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
//  ppHeaderBand1.ObjectByName(elr, 'Entet_LCoul');
//  ppHeaderBand1.ObjectByName(elt, 'Entet_LTail');
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//  (ppHeaderBand1.Objects[ref] AS TppLabel).Caption := Negtetref;
//  (ppHeaderBand1.Objects[des] AS TppLabel).Caption := Negtetdes;
////  (ppHeaderBand1.Objects[Empl] AS TppLabel).Caption := NegTetEmpl;
//  (ppHeaderBand1.Objects[etva] AS TppLabel).Caption := Negtettva;
//  (ppHeaderBand1.Objects[eqt] AS TppLabel).Caption := Negtetqte;
//
//  (ppHeaderBand1.Objects[ec] AS TppLabel).Caption := Negtetcoul;
//  (ppHeaderBand1.Objects[et] AS TppLabel).Caption := NegtetTail;
//
//  ppHeaderBand1.ObjectByName(lbo, 'ppLab_NoBonOrig');
//  ppDetailBand1.ObjectByName(desig, 'ppChp_Coment');
//  //-------------------------------------------_
//  ppHeaderBand1.Objects[etva].visible := True;
//
//  ppHeaderBand1.Objects[ctva].visible := True;
//  ppHeaderBand1.Objects[ltva].visible := True;
//  ppHeaderBand1.Objects[chptva].visible := True;
//
//  (ppHeaderBand1.Objects[mt] AS TppLabel).Caption := NegEntetMtHT;
//
//  IF (Ds_RaprvTet.dataset.fieldByName('IMA_FACT').asinteger = 0) THEN // AND ( ds_RaprvTet.dataset.Tag = 1 ) THEN
//    (ppHeaderBand1.Objects[n] AS TppLabel).Caption := BonTransfert
//  ELSE
//    (ppHeaderBand1.Objects[n] AS TppLabel).Caption := FacRetroLib;
//
//  IF Pos('R', Ds_RaprvTet.dataset.fieldByName('IMA_NUMERO').asstring) > 0 THEN
//  BEGIN
//    (ppHeaderBand1.Objects[n] AS TppLabel).Caption := (ppHeaderBand1.Objects[n] AS TppLabel).Caption + ' ( ' + LibRecap + ' )';
//    (ppHeaderBand1.Objects[lbo] AS TppLabel).Visible := True;
//    (ppDetailBand1.Objects[Desig] AS TppDBMemo).Datafield := 'COMENT';
//  END
//  ELSE BEGIN
//    (ppHeaderBand1.Objects[lbo] AS TppLabel).Visible := False;
//    (ppDetailBand1.Objects[Desig] AS TppDBMemo).Datafield := 'ART_NOM';
//  END;
//  // (ppHeaderBand1.Objects[n] AS TppLabel).Visible := ppr_raprv.absolutePageNo = 1;
//
//  // Paramétrage des entêtes de pages
//
////    ppHeaderBand1.Objects[ec].visible := False;
////    ppHeaderBand1.Objects[et].visible := False;
//
//  IF StdGinkoia.Origine = 2 THEN // BRUN
//  BEGIN
//    ppHeaderBand1.Objects[ec].visible := False;
//    ppHeaderBand1.Objects[et].visible := False;
//    ppHeaderBand1.Objects[elr].visible := False;
//    ppHeaderBand1.Objects[elt].visible := False;
//  END
//  ELSE
//  BEGIN
//    ppHeaderBand1.Objects[ec].visible := True;
//    ppHeaderBand1.Objects[et].visible := True;
//    ppHeaderBand1.Objects[elr].visible := True;
//    ppHeaderBand1.Objects[elt].visible := True;
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.TRFFooterBand1BeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//
//  // Paramétrage du pied de page
//  FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//    ppFooterBand1.Objects[i].Visible := True;
//
//  ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//  (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//  ch := '';
//  IF ds_RaprvDiv.dataset.FieldByName('SOC_FORME').asString <> '' THEN
//  BEGIN
//    ch := ds_RaprvDiv.dataset.FieldByName('SOC_FORME').asString;
//    IF ds_RaprvDiv.dataset.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + ' : '
//    ELSE
//      ch := ch + ' -';
//  END;
//  IF ds_RaprvDiv.dataset.FieldByName('SOC_NOM').asString <> '' THEN
//    ch := ch + ds_RaprvDiv.dataset.FieldByName('SOC_NOM').asString + ' -';
//  IF ds_RaprvDiv.dataset.FieldByName('SOC_RCS').asString <> '' THEN
//    ch := ch + ' RCS ' + ds_RaprvDiv.dataset.FieldByName('SOC_RCS').asString + ' -';
//  IF ds_RaprvDiv.dataset.FieldByName('MAG_SIRET').asString <> '' THEN
//    ch := ch + ' SIRET ' + ds_RaprvDiv.dataset.FieldByName('MAG_SIRET').asString + ' -';
//  IF ds_RaprvDiv.dataset.FieldByName('SOC_APE').asString <> '' THEN
//    ch := ch + ' NAF ' + ds_RaprvDiv.dataset.FieldByName('SOC_APE').asString + ' -';
//  IF ds_RaprvDiv.dataset.FieldByName('SOC_TVA').asString <> '' THEN
//    ch := ch + ' N° TVA ' + ds_RaprvDiv.dataset.FieldByName('SOC_TVA').asString;
//
//  ch := Trim(ch);
//  IF ch <> '' THEN
//  BEGIN
//    IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//    Ch := Trim(ch);
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//  END;
//  ch := '';
//  ptel := 'Tel ';
//  pfax := ' - Fax ';
//  IF ds_RaprvDiv.dataset.FieldByName('ADR_TEL').asString <> '' THEN
//  BEGIN
//    IF Uppercase(Copy(ds_RaprvDiv.dataset.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//    ch := ptel + ds_RaprvDiv.dataset.FieldByName('ADR_TEL').asString;
//  END;
//  IF ds_RaprvDiv.dataset.FieldByName('ADR_FAX').asString <> '' THEN
//  BEGIN
//    IF Uppercase(Copy(ds_RaprvDiv.dataset.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//    ch := ch + pfax + ds_RaprvDiv.dataset.FieldByName('ADR_FAX').asString;
//  END;
//  IF ds_RaprvDiv.dataset.FieldByName('ADR_EMAIL').asString <> '' THEN
//    ch := ch + ' - EMail ' + ds_RaprvDiv.dataset.FieldByName('ADR_EMAIL').asString;
//
//  IF ch <> '' THEN
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//  ppFooterBand1.ObjectByName(i, 'ppSysVar_Page');
//  ppFooterBand1.Objects[i].visible := true;
//END;
//
//PROCEDURE TFrm_RapRV.TRFSummaryBand1BeforePrint(Sender: TObject);
//VAR
//  tx, tmt, toto, i, c, smt, sto, stv, cpa: Integer;
//  mpied, sttc, sht, nap: Integer;
//BEGIN
//  ppSummaryBand1.Visible := true;
//
//  FOR i := 0 TO ppSummaryBand1.ObjectCount - 1 DO
//  BEGIN
//    ppSummaryBand1.Objects[i].Visible := True;
//  END;
//  ppSummaryBand1.ObjectByName(sttc, 'ppLab_Sumtotttc');
//  ppSummaryBand1.ObjectByName(sht, 'ppLab_Sumtotht');
//  ppSummaryBand1.ObjectByName(nap, 'LabNap');
//
//  ppSummaryBand1.ObjectByName(tx, 'ppLab_Sumtvatx');
//  ppSummaryBand1.ObjectByName(tmt, 'ppLab_Sumtvamt');
//  ppSummaryBand1.ObjectByName(toto, 'ppLab_Sumtvatoto');
//
//  ppSummaryBand1.ObjectByName(c, 'ppChp_NapEuro');
//  ppSummaryBand1.ObjectByName(cpa, 'ppChp_CPA');
//
//  ppSummaryBand1.ObjectByName(mpied, 'ppChp_MemPied');
//
//  ppSummaryBand1.ObjectByName(smt, 'SumryMt');
//  ppSummaryBand1.ObjectByName(sto, 'SumryTotal');
//  ppSummaryBand1.ObjectByName(stv, 'SumryMtTva');
//
//  (ppSummaryBand1.Objects[nap] AS TppLabel).Caption := NegSumNap;
//  (ppSummaryBand1.Objects[sttc] AS TppLabel).Caption := NegSumTotalTTC;
//  (ppSummaryBand1.Objects[sht] AS TppLabel).Caption := NegSumTotalHT;
//
//  (ppSummaryBand1.Objects[tx] AS TppLabel).Caption := NegSumTvatx;
//  (ppSummaryBand1.Objects[tmt] AS TppLabel).Caption := NegSumTvamt;
//  (ppSummaryBand1.Objects[toto] AS TppLabel).Caption := NegSumTvatoto;
//
//  ppSummaryBand1.Objects[c].visible := true;
//
//  (ppSummaryBand1.Objects[smt] AS TppLabel).Caption := NegSumMtHT;
//  (ppSummaryBand1.Objects[sto] AS TppLabel).Caption := NegSumTotalHT;
//  (ppSummaryBand1.Objects[stv] AS TppLabel).Caption := NegSumMtHT;
//
//END;
//
//PROCEDURE TFrm_RapRV.TRFTitleBand1BeforePrint(Sender: TObject);
//VAR
//  clc, i, z, Tar: Integer;
//  s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//  ppSummaryBand1.ObjectByName(clc, 'ppDBCalc_Smry');
//  ppSummaryBand1.ObjectByName(tar, 'ppChp_ToTAR');
//  ppSummaryBand1.ObjectByName(cht, 'ppChp_CumHT');
//  FOR i := 1 TO 5 DO
//    ppSummaryBand1.ObjectByName(lht[i], 'ppChp_HT' + intToStr(i));
//
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  ppSummaryBand1.Objects[clc].Visible := True;
//
//  (ppSummaryBand1.Objects[cht] AS TppDBText).Datafield := 'TOTHT';
//
//  (ppSummaryBand1.Objects[Tar] AS TppDBText).Datafield := 'TOTHT';
//  FOR i := 1 TO 5 DO
//    (ppSummaryBand1.Objects[lht[i]] AS TppDBText).DataField := 'HT' + IntToStr(i);
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := true;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := ds_RaprvTet.dataset.FieldByName('MAGADR').asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(ds_RaprvTet.dataset.FieldByName('MAGCP').asString + ' ' +
//    ds_RaprvTet.dataset.FieldByName('MAGVILLE').asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := ds_RaprvTet.dataset.FieldByName('CLTADR').asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(ds_RaprvTet.dataset.FieldByName('CLTCP').asString + ' ' +
//    ds_RaprvTet.dataset.FieldByName('CLTVILLE').asString);
//END;
//
//PROCEDURE TFrm_RapRV.RETFppDetailBand1BeforePrint(Sender: TObject);
//VAR
//  tgf, cou, li, mt, c: Integer;
//BEGIN
//  ppDetailBand1.ObjectByName(Tgf, 'ppChp_TgfNomRetf');
//  ppDetailBand1.ObjectByName(cou, 'ppChp_CouNomRetf');
//  ppDetailBand1.ObjectByName(li, 'ppLine_DTailRetf');
//
//  ppDetailBand1.Objects[tgf].Visible := stdGinkoia.Origine <> 2;
//  ppDetailBand1.Objects[cou].Visible := stdGinkoia.Origine <> 2;
//  ppDetailBand1.Objects[li].Visible := stdGinkoia.Origine <> 2;
//
//END;
//
//PROCEDURE TFrm_RapRV.RETFppHeaderBand1BeforePrint(Sender: TObject);
//VAR
//  tgf, cou, li, mt: Integer;
//BEGIN
//  ppHeaderBand1.ObjectByName(Tgf, 'ppLab_HTailRetf');
//  ppHeaderBand1.ObjectByName(cou, 'ppLab_HCoulRetf');
//  ppHeaderBand1.ObjectByName(li, 'ppLine_HTailRetf');
//  ppHeaderBand1.Objects[tgf].Visible := stdGinkoia.Origine <> 2;
//  ppHeaderBand1.Objects[cou].Visible := stdGinkoia.Origine <> 2;
//  ppHeaderBand1.Objects[li].Visible := stdGinkoia.Origine <> 2;
//END;
//
//PROCEDURE TFrm_RapRV.RETFppTitleBand1BeforePrint(Sender: TObject);
//VAR
//  soc, mag, adr, dat1, dat2, psoc, pg: Integer;
//BEGIN
//  ppTitleBand1.ObjectByName(soc, 'ppChp_NomSocRetf');
//  ppTitleBand1.ObjectByName(Mag, 'ppChp_NomMagRetf');
//  ppTitleBand1.ObjectByName(adr, 'ppChp_AdrMagRetf');
//  ppTitleBand1.ObjectByName(dat1, 'ppSysVar_DatImpRetf');
//  ppTitleBand1.ObjectByName(dat2, 'ppLab_DatImpRetf');
//  ppFooterBand1.ObjectByName(pg, 'ppSysVar_PageRetf');
//  ppFooterBand1.ObjectByName(psoc, 'ppChp_PiedSocRetf');
//
//  ppTitleBand1.Objects[soc].Visible := RImpTete;
//  ppTitleBand1.Objects[Mag].Visible := RImpTete;
//  ppTitleBand1.Objects[adr].Visible := RImpTete;
//  ppTitleBand1.Objects[dat1].Visible := RImpdate;
//  ppTitleBand1.Objects[dat2].Visible := RImpDate;
//  ppFooterBand1.Objects[pg].Visible := RImpPg;
//  ppFooterBand1.Objects[psoc].Visible := RImpPied;
//END;

PROCEDURE TFrm_RapRV.PHONEGetText(Sender: TObject; VAR Text: STRING);
BEGIN
  IF Text = '' THEN
    Text := ''
  ELSE
    text := PhoneFormat(Text, False);
END;

PROCEDURE TFrm_RapRV.FACppTitleCumBeforePrint(Sender: TObject);
VAR
  vu, vd, lvd, i, z, Cmt: Integer;
  s, m, a, aclt : Integer;
  lht: ARRAY[1..5] OF Integer;
BEGIN
  ppTitleBand1.ObjectByName(cmt, 'ppChp_Fcecoment');
  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');

  (ppTitleBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;

  (ppTitleBand1.Objects[Cmt] AS TppDBMemo).Visible :=
    (Imp_QueTet.FieldByName('FCE_TYPID').asInteger = FFacture.TipFacLoc.Id) AND
    (Imp_QueTet.FieldByName('FCE_CLTID').asInteger = FFacture.IdToTwinner);
//    (Dm_NegFac.Que_TetImpFCE_TYPID.asInteger = Dm_NegFac.TipFacLoc) AND
//    (Dm_NegFac.Que_TetImpFCE_CLTID.asInteger = StdGinkoia.IdToTwinner);

  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');

  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');

  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
  BEGIN
    IF (i = s) OR (i = m) OR (i = a) THEN
      ppTitleBand1.Objects[i].Visible := FFaCture.ImpTete;
  END;

  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := Imp_QueTet.FieldByName('MAGADR').asString;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_negfac.que_TetImpMAGADR.asString;
  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;

  IF z > 2 THEN
  BEGIN
    FOR i := z DOWNTO 3 DO
      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
  END;
  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('MAGCP').asString + ' ' +
                                                 Imp_QueTet.FieldByName('MAGVILLE').asString);
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negfac.que_TetImpMAGCP.asString + ' ' +
//    dm_negfac.que_TetImpMAGVILLE.asString);
  IF FFacture.ImpPayMag THEN
    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('MAGPAYS').asString);
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negfac.que_TetImpMAGPAYS.asString);

  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := Imp_QueTet.FieldByName('FCE_ADRLIGNE').asString;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_negfac.que_TetImpFCE_ADRLIGNE.asString;
  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;

  IF z > 2 THEN
  BEGIN
    FOR i := z DOWNTO 3 DO
      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
  END;
  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('CLTCP').asString + ' ' +
                                                    Imp_QueTet.FieldByName('CLTVILLE').asString);
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negfac.que_TetImpCLTCP.asString + ' ' +
//    dm_negfac.que_TetImpCLTVILLE.asString);
  IF FFacture.ImpPayClt THEN
    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(Imp_QueTet.FieldByName('CLTPAYS').asString);
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negfac.que_TetImpCLTPAYS.asString);

  ppTitleBand1.Objects[vd].Visible := False;
  ppTitleBand1.Objects[vu].Visible := False;
  ppTitleBand1.Objects[lvd].Visible := False;
  IF FFacture.ImpVend THEN
    IF Imp_QueTet.FieldByName('USR_FULLNAME').asstring <> '' THEN
//    IF dm_negFac.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
    BEGIN
      ppTitleBand1.Objects[vd].Visible := True;
      ppTitleBand1.Objects[lvd].Visible := True;
    END
    ELSE
    BEGIN
      IF (Imp_QueTet.FieldByName('USR_USERNAME').asstring <> '') AND
        (Imp_QueTet.FieldByName('USR_USERNAME').asstring <> '.') THEN
//      IF (dm_negFac.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_negFac.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
      BEGIN
        ppTitleBand1.Objects[vu].Visible := True;
        ppTitleBand1.Objects[lvd].Visible := True;
      END;
    END;
END;

PROCEDURE TFrm_RapRV.FACppHeaderBandCUMBeforePrint(Sender: TObject);
VAR
  f1, f2, f3, f4, pxu, mt, n, ec, et, elr, elt, rm: Integer;
  ctva, ltva, labtva, chptva: Integer;
  labclt, nm, dt, ref, des, etva, eqt : Integer;

BEGIN
  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
  ppHeaderBand1.ObjectByName(ref, 'Entet_Ref');
  ppHeaderBand1.ObjectByName(des, 'Entet_Des');

  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');

  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;

  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;

  ppHeaderBand1.ObjectByName(n, 'ppLab_NFac');
  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');

  ppHeaderBand1.ObjectByName(f1, 'Factor_Cadre');
  ppHeaderBand1.ObjectByName(f2, 'Factor_Line');
  ppHeaderBand1.ObjectByName(f3, 'Factor_Codeclt');
  ppHeaderBand1.ObjectByName(f4, 'Factor_Lab');

  (ppHeaderBand1.Objects[f4] AS TppLabel).Caption := FFacture.LabFactor;

  (ppHeaderBand1.Objects[f4] AS TppLabel).Caption := NegTetFactor;

  IF FFacture.ImpTva THEN
  BEGIN
    ppHeaderBand1.Objects[ctva].visible := True;
    ppHeaderBand1.Objects[ltva].visible := True;
    ppHeaderBand1.Objects[labtva].visible := True;
    ppHeaderBand1.Objects[chptva].visible := True;
  END
  ELSE BEGIN
    ppHeaderBand1.Objects[ctva].visible := False;
    ppHeaderBand1.Objects[ltva].visible := False;
    ppHeaderBand1.Objects[labtva].visible := False;
    ppHeaderBand1.Objects[chptva].visible := False;
  END;

  IF Imp_QueTet.FieldByName('FCE_FACTOR').asInteger = 1 THEN
//  IF dm_NegFac.Que_TetImpFCE_FACTOR.asInteger = 1 THEN
  BEGIN
    ppHeaderBand1.Objects[f1].visible := True;
    ppHeaderBand1.Objects[f2].visible := True;
    ppHeaderBand1.Objects[f3].visible := True;
    ppHeaderBand1.Objects[f4].visible := True;
  END
  ELSE
  BEGIN
    ppHeaderBand1.Objects[f1].visible := False;
    ppHeaderBand1.Objects[f2].visible := False;
    ppHeaderBand1.Objects[f3].visible := False;
    ppHeaderBand1.Objects[f4].visible := False;
  END;

  IF Imp_QueTet.FieldByName('TOTTTC').asFloat < 0 THEN
//  IF Dm_NegFac.Que_TetImpTOTTTC.asFloat < 0 THEN
    (ppHeaderBand1.Objects[n] AS TppLabel).Caption := AvoirLib
  ELSE
  BEGIN
    IF Imp_QueTet.FieldByName('FCE_TYPID').asInteger = FFacture.TipFacRetro.id THEN
//    IF Dm_NegFac.Que_TetImpFCE_TYPID.asInteger = Dm_NegFac.TipFacRetro THEN
      (ppHeaderBand1.Objects[n] AS TppLabel).Caption := FacRetroLib
    ELSE
      (ppHeaderBand1.Objects[n] AS TppLabel).Caption := FacLib;
  END;

  (ppHeaderBand1.Objects[n] AS TppLabel).Visible := ppr_raprv.absolutePageNo = 1;

END;

PROCEDURE TFrm_RapRV.FACppFooterBandCUMBeforePrint(Sender: TObject);
VAR
  i, bp : Integer;
  ch, ptel, pfax: STRING;
BEGIN

  // Paramétrage du pied de page
  IF FFacture.ImpPied = False THEN
  BEGIN
    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
      ppFooterBand1.Objects[i].Visible := False;
  END
  ELSE
  BEGIN

    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
      ppFooterBand1.Objects[i].Visible := True;

    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;

    ch := '';
    IF Imp_QueMags.FieldByName('SOC_FORME').asString <> '' THEN
//    IF dm_NegFac.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
    BEGIN
      ch := Imp_QueMags.FieldByName('SOC_FORME').asString;
//      ch := dm_NegFac.que_Mags.FieldByName('SOC_FORME').asString;
      IF Imp_QueMags.FieldByName('SOC_NOM').asString <> '' THEN
//      IF dm_NegFac.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
        ch := ch + ' : '
      ELSE
        ch := ch + ' -';
    END;
    IF Imp_QueMags.FieldByName('SOC_NOM').asString <> '' THEN
//    IF dm_NegFac.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
      ch := ch + Imp_QueMags.FieldByName('SOC_NOM').asString + ' -';
//      ch := ch + dm_NegFac.que_Mags.FieldByName('SOC_NOM').asString + ' -';
    IF Imp_QueMags.FieldByName('SOC_RCS').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
      ch := ch + ' RCS ' + Imp_QueMags.FieldByName('SOC_RCS').asString + ' -';
//      ch := ch + ' RCS ' + dm_negfac.que_Mags.FieldByName('SOC_RCS').asString + ' -';
    IF Imp_QueMags.FieldByName('MAG_SIRET').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
      ch := ch + ' SIRET ' + Imp_QueMags.FieldByName('MAG_SIRET').asString + ' -';
//      ch := ch + ' SIRET ' + dm_negfac.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
    IF Imp_QueMags.FieldByName('SOC_APE').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
      ch := ch + ' NAF ' + Imp_QueMags.FieldByName('SOC_APE').asString + ' -';
//      ch := ch + ' NAF ' + dm_negfac.que_Mags.FieldByName('SOC_APE').asString + ' -';
    IF Imp_QueMags.FieldByName('SOC_TVA').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
      ch := ch + ' N° TVA ' + Imp_QueMags.FieldByName('SOC_TVA').asString;
//      ch := ch + ' N° TVA ' + dm_negfac.que_Mags.FieldByName('SOC_TVA').asString;

    ch := Trim(ch);
    IF ch <> '' THEN
    BEGIN
      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
      Ch := Trim(ch);
      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
    END;
    ch := '';
    ptel := 'Tel ';
    pfax := ' - Fax ';
    IF Imp_QueMags.FieldByName('ADR_TEL').asString <> '' THEN
//    IF dm_negfac.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
    BEGIN
      IF Uppercase(Copy(Imp_QueMags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
  //    IF Uppercase(Copy(dm_negfac.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
      ch := ptel + Imp_QueMags.FieldByName('ADR_TEL').asString;
  //    ch := ptel + dm_negfac.que_Mags.FieldByName('ADR_TEL').asString;
    END;
    IF Imp_QueMags.FieldByName('ADR_FAX').asString <> '' THEN
 //   IF dm_negfac.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
    BEGIN
      IF Uppercase(Copy(Imp_QueMags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
  //    IF Uppercase(Copy(dm_negfac.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
      ch := ch + pfax + Imp_QueMags.FieldByName('ADR_FAX').asString;
  //    ch := ch + pfax + dm_negfac.que_Mags.FieldByName('ADR_FAX').asString;
    END;
    IF Imp_QueMags.FieldByName('ADR_EMAIL').asString <> '' THEN
 //   IF dm_negfac.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
      ch := ch + ' - EMail ' + Imp_QueMags.FieldByName('ADR_EMAIL').asString;
  //    ch := ch + ' - EMail ' + dm_negfac.que_Mags.FieldByName('ADR_EMAIL').asString;

    IF ch <> '' THEN
      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
  END;


END;

//PROCEDURE TFrm_RapRV.BLppTitleBandCUMBeforePrint(Sender: TObject);
//VAR
//  vu, lvd, vd, clc, i, z, Tar: Integer;
//  s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
//  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
//  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  (ppTitleBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;
//
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := dm_NegBL.ImpTete;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_negBL.que_TetImpMAGADR.asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negBL.que_TetImpMAGCP.asString + ' ' +
//    dm_negBL.que_TetImpMAGVILLE.asString);
//  IF dm_negBL.ImpPayMag THEN
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negBL.que_TetImpMAGPAYS.asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_negBL.que_TetImpBLE_ADRLIGNE.asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negBL.que_TetImpCLTCP.asString + ' ' +
//    dm_negBL.que_TetImpCLTVILLE.asString);
//  IF dm_negBL.ImpPayClt THEN
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negBL.que_TetImpCLTPAYS.asString);
//
//  ppTitleBand1.Objects[vd].Visible := False;
//  ppTitleBand1.Objects[vu].Visible := False;
//  ppTitleBand1.Objects[lvd].Visible := False;
//  IF dm_negBL.ImpVend THEN
//    IF dm_negBL.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
//    BEGIN
//      ppTitleBand1.Objects[vd].Visible := True;
//      ppTitleBand1.Objects[lvd].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (dm_negBL.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_negBL.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
//      BEGIN
//        ppTitleBand1.Objects[vu].Visible := True;
//        ppTitleBand1.Objects[lvd].Visible := True;
//      END;
//    END;
//
//END;
//
//PROCEDURE TFrm_RapRV.BPppFooterBandCUMBeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_BonPrepa.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_BonPrepa.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_BonPrepa.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + ch + dm_BonPrepa.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_BonPrepa.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_BonPrepa.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_BonPrepa.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_BonPrepa.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_BonPrepa.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_BonPrepa.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_BonPrepa.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_BonPrepa.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_BonPrepa.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_BonPrepa.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_BonPrepa.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_BonPrepa.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_BonPrepa.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.BPppHeaderBandCUMBeforePrint(Sender: TObject);
//VAR
//  pxu, mt, rm, ec, et, elr, Tbl, elt: Integer;
//  ctva, ltva, labtva, chptva: Integer;
//  fax, lfax, labclt, nm, dt, ref, des, etva, eqt: Integer;
//
//BEGIN
//  ppHeaderBand1.ObjectByName(lfax, 'ppLab_Fax');
//  ppHeaderBand1.ObjectByName(fax, 'ppchp_Fax');
//
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//
//  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
//  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//
//  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
//  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;
//
//  ppHeaderBand1.ObjectByName(Tbl, 'Entet_TipBl');
//  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
//  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
//  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
//
//  ppHeaderBand1.Objects[Tbl].Visible := ppr_raprv.absolutePageNo = 1;
//
//  TRY
//    ppHeaderBand1.Objects[lfax].visible := dm_BonPrepa.Que_TetImpBLE_PRO.asInteger = 1;
//    ppHeaderBand1.Objects[fax].visible := dm_BonPrepa.Que_TetImpBLE_PRO.asInteger = 1;
//  EXCEPT
//  END;
//
//  //-------------------------------------------_
//  IF dm_BonPrepa.ImpTva THEN
//  BEGIN
//    ppHeaderBand1.Objects[ctva].visible := True;
//    ppHeaderBand1.Objects[ltva].visible := True;
//    ppHeaderBand1.Objects[labtva].visible := True;
//    ppHeaderBand1.Objects[chptva].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//END;
//
//PROCEDURE TFrm_RapRV.BPppTitleBandCUMBeforePrint(Sender: TObject);
//VAR
//  vu, lvd, vd, clc, i, z, Tar: Integer;
//  s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
//  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
//  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  (ppTitleBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;
//
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := dm_BonPrepa.ImpTete;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_BonPrepa.que_TetImpMAGADR.asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpMAGCP.asString + ' ' +
//    dm_BonPrepa.que_TetImpMAGVILLE.asString);
//  IF dm_BonPrepa.ImpPayMag THEN
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpMAGPAYS.asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_BonPrepa.que_TetImpBLE_ADRLIGNE.asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpCLTCP.asString + ' ' +
//    dm_BonPrepa.que_TetImpCLTVILLE.asString);
//  IF dm_BonPrepa.ImpPayClt THEN
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_BonPrepa.que_TetImpCLTPAYS.asString);
//
//  ppTitleBand1.Objects[vd].Visible := False;
//  ppTitleBand1.Objects[vu].Visible := False;
//  ppTitleBand1.Objects[lvd].Visible := False;
//  IF dm_BonPrepa.ImpVend THEN
//    IF dm_BonPrepa.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
//    BEGIN
//      ppTitleBand1.Objects[vd].Visible := True;
//      ppTitleBand1.Objects[lvd].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (dm_BonPrepa.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_BonPrepa.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
//      BEGIN
//        ppTitleBand1.Objects[vu].Visible := True;
//        ppTitleBand1.Objects[lvd].Visible := True;
//      END;
//    END;
//END;
//
//PROCEDURE TFrm_RapRV.BLppHeaderBandCUMBeforePrint(Sender: TObject);
//VAR
//  pxu, mt, rm, ec, et, elr, Tbl, elt: Integer;
//  ctva, ltva, labtva, chptva: Integer;
//  fax, lfax, labclt, nm, dt, ref, des, etva, eqt: Integer;
//
//BEGIN
//  ppHeaderBand1.ObjectByName(lfax, 'ppLab_Fax');
//  ppHeaderBand1.ObjectByName(fax, 'ppchp_Fax');
//
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//
//  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
//  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//
//  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
//  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;
//
//  ppHeaderBand1.ObjectByName(Tbl, 'Entet_TipBl');
//  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
//  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
//  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
//
//  ppHeaderBand1.Objects[Tbl].Visible := ppr_raprv.absolutePageNo = 1;
//
//  TRY
//    ppHeaderBand1.Objects[lfax].visible := Dm_NegBL.Que_TetImpBLE_PRO.asInteger = 1;
//    ppHeaderBand1.Objects[fax].visible := Dm_NegBL.Que_TetImpBLE_PRO.asInteger = 1;
//  EXCEPT
//  END;
//
//  //-------------------------------------------_
//  IF dm_NegBL.ImpTva THEN
//  BEGIN
//    ppHeaderBand1.Objects[ctva].visible := True;
//    ppHeaderBand1.Objects[ltva].visible := True;
//    ppHeaderBand1.Objects[labtva].visible := True;
//    ppHeaderBand1.Objects[chptva].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.BLppFooterBandCUMBeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_NegBL.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_NegBl.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_NegBl.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_NegBL.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_NegBL.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + ch + dm_NegBl.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_NegBL.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_NegBL.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_NegBL.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_NegBL.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_NegBL.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_negBL.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negBL.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_negBL.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_negBL.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negBL.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_negBL.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_NegBL.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_NegBL.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//
//  END;
//
//END;
//
//PROCEDURE TFrm_RapRV.DEVppTitleBandCUMBeforePrint(Sender: TObject);
//VAR
//  vu, vd, lvd, clc, clcHT, i, z, Tar: Integer;
//  obj, s, m, a, aclt, cht: Integer;
//  lht: ARRAY[1..5] OF Integer;
//BEGIN
//  ppTitleBand1.ObjectByName(Obj, 'ppChp_Objet');
//  ppTitleBand1.ObjectByName(vd, 'ppChp_Vendeur');
//  ppTitleBand1.ObjectByName(lvd, 'LabVendeur');
//  ppTitleBand1.ObjectByName(vu, 'ppChp_UsrVend');
//  (ppTitleBand1.Objects[Lvd] AS TppLabel).Caption := LibVendeur;
//
//  ppTitleBand1.Objects[obj].Visible := Dm_NegDev.ImpObjet;
//  ppTitleBand1.ObjectByName(a, 'ppChp_MagAdr');
//  ppTitleBand1.ObjectByName(aclt, 'ppChp_AdrClt');
//
//  ppTitleBand1.ObjectByName(s, 'ppChp_SocNom');
//  ppTitleBand1.ObjectByName(m, 'ppChp_MagNom');
//
//  FOR i := 0 TO ppTitleBand1.ObjectCount - 1 DO
//  BEGIN
//    IF (i = s) OR (i = m) OR (i = a) THEN
//      ppTitleBand1.Objects[i].Visible := dm_NegDev.ImpTete;
//  END;
//
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.Text := dm_negDev.que_TetImpMAGADR.asString;
//  z := (ppTitleBand1.Objects[a] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[a] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negDev.que_TetImpMAGCP.asString + ' ' +
//    dm_negDev.que_TetImpMAGVILLE.asString);
//  IF dm_negDev.ImpPayMag THEN
//    (ppTitleBand1.Objects[a] AS TppMemo).Lines.add(dm_negDev.que_TetImpMAGPAYS.asString);
//
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Text := dm_negDev.que_TetImpDVE_ADRLIGNE.asString;
//  z := (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Count - 1;
//
//  IF z > 2 THEN
//  BEGIN
//    FOR i := z DOWNTO 3 DO
//      (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.Delete(i);
//  END;
//  (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negDev.que_TetImpCLTCP.asString + ' ' +
//    dm_negDev.que_TetImpCLTVILLE.asString);
//  IF dm_negDev.ImpPayClt THEN
//    (ppTitleBand1.Objects[aclt] AS TppMemo).Lines.add(dm_negDev.que_TetImpCLTPAYS.asString);
//
//  ppTitleBand1.Objects[vd].Visible := False;
//  ppTitleBand1.Objects[vu].Visible := False;
//  ppTitleBand1.Objects[lvd].Visible := False;
//  IF dm_negDev.ImpVend THEN
//    IF dm_negDev.Que_TetImpUSR_FULLNAME.asstring <> '' THEN
//    BEGIN
//      ppTitleBand1.Objects[vd].Visible := True;
//      ppTitleBand1.Objects[lvd].Visible := True;
//    END
//    ELSE
//    BEGIN
//      IF (dm_negDev.Que_TetImpUSR_USERNAME.asstring <> '') AND
//        (dm_negDev.Que_TetImpUSR_USERNAME.asstring <> '.') THEN
//      BEGIN
//        ppTitleBand1.Objects[vu].Visible := True;
//        ppTitleBand1.Objects[lvd].Visible := True;
//      END;
//    END;
//END;
//
//PROCEDURE TFrm_RapRV.DEVppHeaderBandCUMBeforePrint(Sender: TObject);
//VAR
//  pxu, mt, rm, ec, et, elr, ett, elt: Integer;
//  ctva, ltva, labtva, chptva, labclt, clt: Integer;
//  nm, dt, ref, des, etva, eqt, lfax, fax: Integer;
//
//BEGIN
//  ppHeaderBand1.ObjectByName(lfax, 'ppLab_Fax');
//  ppHeaderBand1.ObjectByName(fax, 'ppchp_Fax');
//
//  ppHeaderBand1.ObjectByName(nm, 'ppLab_Numero');
//  ppHeaderBand1.ObjectByName(dt, 'ppLab_Date');
//  ppHeaderBand1.ObjectByName(LabClt, 'ppLab_Clt');
//  ppHeaderBand1.ObjectByName(labtva, 'ppLab_Tva');
//
//  (ppHeaderBand1.Objects[nm] AS TppLabel).Caption := Negtetnum;
//  (ppHeaderBand1.Objects[dt] AS TppLabel).Caption := Negtetdate;
//
//  (ppHeaderBand1.Objects[labclt] AS TppLabel).Caption := Negtetclt;
//  (ppHeaderBand1.Objects[labtva] AS TppLabel).Caption := NegtetLabtva;
//
//  ppHeaderBand1.ObjectByName(clt, 'ppChp_Clt');
//  ppHeaderBand1.ObjectByName(ett, 'Entet_Titre');
//  ppHeaderBand1.ObjectByName(ctva, 'CadTva');
//  ppHeaderBand1.ObjectByName(ltva, 'LinTva');
//
//  ppHeaderBand1.ObjectByName(chptva, 'ppChp_Tva');
//  //-------------------------------------------
//  TRY
//    ppHeaderBand1.Objects[lfax].visible := Dm_Negdev.Que_TetImpDVE_PRO.asInteger = 1;
//    ppHeaderBand1.Objects[fax].visible := Dm_NegDev.Que_TetImpDVE_PRO.asInteger = 1;
//  EXCEPT
//  END;
//
//  IF dm_NegDev.ImpTva THEN // intracomunautaire
//  BEGIN
//    ppHeaderBand1.Objects[ctva].visible := True;
//    ppHeaderBand1.Objects[ltva].visible := True;
//    ppHeaderBand1.Objects[labtva].visible := True;
//    ppHeaderBand1.Objects[chptva].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//  IF Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId THEN
//  BEGIN
//    ppHeaderBand1.Objects[clt].visible := True;
//    ppHeaderBand1.Objects[labclt].visible := True;
//  END
//  ELSE BEGIN
//    ppHeaderBand1.Objects[clt].visible := False;
//    ppHeaderBand1.Objects[labclt].visible := False;
//    ppHeaderBand1.Objects[ctva].visible := False;
//    ppHeaderBand1.Objects[ltva].visible := False;
//    ppHeaderBand1.Objects[labtva].visible := False;
//    ppHeaderBand1.Objects[chptva].visible := False;
//  END;
//
//  IF Dm_NegDev.Que_TetImpDVE_NPRID.asInteger <> Dm_Negdev.DevModeleId THEN
//    (ppHeaderBand1.Objects[ett] AS TppLabel).Caption := dm_Negdev.ImpDevForma
//  ELSE (ppHeaderBand1.Objects[ett] AS TppLabel).Caption := Copy(dm_Negdev.que_TetImpDVE_MODELE.asstring, 1, 50);
//
//  (ppHeaderBand1.Objects[ett] AS TppLabel).Visible := ppr_raprv.absolutePageNo = 1;
//
//END;
//
//PROCEDURE TFrm_RapRV.DEVppFooterBandCUMBeforePrint(Sender: TObject);
//VAR
//  i, bp: Integer;
//  ch, ptel, pfax: STRING;
//BEGIN
//  // Paramétrage du pied de page
//  IF dm_NegDev.ImpPied = False THEN
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := False;
//  END
//  ELSE
//  BEGIN
//    FOR i := 0 TO ppFooterBand1.ObjectCount - 1 DO
//      ppFooterBand1.Objects[i].Visible := True;
//
//    ppFooterBand1.ObjectByName(bp, 'ppChp_BasPg');
//    (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Clear;
//
//    ch := '';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_FORME').asString <> '' THEN
//    BEGIN
//      ch := dm_NegDev.que_Mags.FieldByName('SOC_FORME').asString;
//      IF dm_NegDev.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//        ch := ch + ' : '
//      ELSE
//        ch := ch + ' -';
//    END;
//    IF dm_NegDev.que_Mags.FieldByName('SOC_NOM').asString <> '' THEN
//      ch := ch + dm_NegDev.que_Mags.FieldByName('SOC_NOM').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_RCS').asString <> '' THEN
//      ch := ch + ' RCS ' + dm_NegDev.que_Mags.FieldByName('SOC_RCS').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('MAG_SIRET').asString <> '' THEN
//      ch := ch + ' SIRET ' + dm_NegDev.que_Mags.FieldByName('MAG_SIRET').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_APE').asString <> '' THEN
//      ch := ch + ' NAF ' + dm_NegDev.que_Mags.FieldByName('SOC_APE').asString + ' -';
//    IF dm_NegDev.que_Mags.FieldByName('SOC_TVA').asString <> '' THEN
//      ch := ch + ' N° TVA ' + dm_NegDev.que_Mags.FieldByName('SOC_TVA').asString;
//
//    ch := Trim(ch);
//    IF ch <> '' THEN
//    BEGIN
//      IF ch[Length(ch)] = '-' THEN ch[length(ch)] := ' ';
//      Ch := Trim(ch);
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//    END;
//
//    ch := '';
//    ptel := 'Tel ';
//    pfax := ' - Fax ';
//    IF dm_negdev.que_Mags.FieldByName('ADR_TEL').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negDev.que_Mags.FieldByName('ADR_TEL').asString, 1, 1)) = 'T' THEN ptel := ' ';
//      ch := ptel + dm_negDev.que_Mags.FieldByName('ADR_TEL').asString;
//    END;
//    IF dm_negDev.que_Mags.FieldByName('ADR_FAX').asString <> '' THEN
//    BEGIN
//      IF Uppercase(Copy(dm_negDev.que_Mags.FieldByName('ADR_FAX').asString, 1, 1)) = 'F' THEN pfax := ' - ';
//      ch := ch + pfax + dm_negDev.que_Mags.FieldByName('ADR_FAX').asString;
//    END;
//    IF dm_NegDev.que_Mags.FieldByName('ADR_EMAIL').asString <> '' THEN
//      ch := ch + ' - EMail ' + dm_NegDev.que_Mags.FieldByName('ADR_EMAIL').asString;
//
//    IF ch <> '' THEN
//      (ppFooterBand1.Objects[bp] AS TppMemo).Lines.Add(ch);
//  END;
//
//END;

{_________________ Bons de Préparation Négoce ____________________________________________}

END.


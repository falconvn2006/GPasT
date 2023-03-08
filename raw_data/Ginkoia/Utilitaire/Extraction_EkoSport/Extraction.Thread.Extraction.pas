unit Extraction.Thread.Extraction;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBBase,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Extraction.Ressourses;

type
  TThreadExtraction = class(TThread)
  private
    { Déclarations privées }
    FDConnection      : TFDConnection;
    FDTransaction     : TFDTransaction;
    QueRequete        : TFDQuery;
    QueTarif          : TFDQuery;
    QueTarifAchat     : TFDQuery;
    QuePumpCourant    : TFDQuery;
    QueCodeBarresGin  : TFDQuery;
    QueCodeBarresFou  : TFDQuery;
    MemTModeles       : TFDMemTable;
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    procedure ExportDataSetToDVS(ADataSet: TDataSet;
      const AFichier: TFileName; const ATxtMsg: string;
      const AAjouter: Boolean = False);
  protected
    procedure Execute(); override;
  public
    { Déclarations publiques }
    BaseDonnees                 : TFileName;
    FichierMarques              : TFileName;
    FichierFournisseurs         : TFileName;
    FichierMarquesFournisseurs  : TFileName;
    FichierModeles              : TFileName;
    FichierRAL                  : TFileName;
    FichierStocks               : TFileName;
    ExtraireMarques             : Boolean;
    ExtraireFournisseurs        : Boolean;
    ExtraireMarquesFournisseurs : Boolean;
    ExtraireModeles             : Boolean;
    ExtraireRAL                 : Boolean;
    ExtraireStocks              : Boolean;
    LblProgression              : TLabel;
    PbProgression               : TProgressBar;
    ImgMarques                  : TImage;
    ImgFournisseurs             : TImage;
    ImgMarquesFournisseurs      : TImage;
    ImgModeles                  : TImage;
    ImgRAL                      : TImage;
    ImgStocks                   : TImage;
  end;
  TLigne = record
    ART_ID      : Integer;
    TGF_ID      : Integer;
    COU_ID      : Integer;
    ART_NOM     : string;
    COU_NOM     : string;
    COU_CODE    : string;
    TGF_NOM     : string;
    GEN_PVT_PX  : Currency;
    WEB_PVT_PX  : Currency;
    ARW_WEB     : SmallInt;
    GIN_CBI_CB  : string;
    FOU_CBI_CB  : string;
    MRK_ID      : Integer;
    FOU_ID      : Integer;
    ARF_CHRONO  : string;
    PXNEGO      : Currency;
    PXCTLG      : Currency;
    PUMPCOURANT : Currency;
    TVA_TAUX    : Double;
  end;

implementation

{ TThreadExtraction }

procedure TThreadExtraction.Execute();
var
  Champ: TField;
  iMagId, iTvtIdGen, iTvtIdWeb, iNbLignes, iPosProg, iMaxProg, iCbiId: Integer;
  bPremiereExtraction: Boolean;
  lLigne: TLigne;
begin
  FDConnection            := TFDConnection.Create(nil);
  FDTransaction           := TFDTransaction.Create(nil);
  QueRequete              := TFDQuery.Create(nil);
  QueTarif                := TFDQuery.Create(nil);
  QueTarifAchat           := TFDQuery.Create(nil);
  QuePumpCourant          := TFDQuery.Create(nil);
  QueCodeBarresGin        := TFDQuery.Create(nil);
  QueCodeBarresFou        := TFDQuery.Create(nil);
  MemTModeles             := TFDMemTable.Create(nil);
  FDPhysIBDriverLink      := TFDPhysIBDriverLink.Create(nil);

  try
    LblProgression.Caption := RS_CONNEXION;

    {$REGION 'Paramètrage de la connexion'}
    FDConnection.Params.Clear();
    FDConnection.Params.Add('DriverID=IB');
    FDConnection.Params.Add('User_Name=ginkoia');
    FDConnection.Params.Add('Password=ginkoia');
    FDConnection.Params.Add(Format('Database=%s', [BaseDonnees]));
    FDConnection.Transaction := FDTransaction;

    FDTransaction.Connection := FDConnection;

    QueRequete.Connection               := FDConnection;
    QueRequete.Transaction              := FDTransaction;
    QueRequete.FetchOptions.Mode        := fmAll;
    QueTarif.Connection                 := FDConnection;
    QueTarif.Transaction                := FDTransaction;
    QueTarifAchat.Connection            := FDConnection;
    QueTarifAchat.Transaction           := FDTransaction;
    QuePumpCourant.Connection           := FDConnection;
    QuePumpCourant.Transaction          := FDTransaction;
    QueCodeBarresGin.Connection         := FDConnection;
    QueCodeBarresGin.Transaction        := FDTransaction;
    QueCodeBarresFou.Connection         := FDConnection;
    QueCodeBarresFou.Transaction        := FDTransaction;
    {$ENDREGION 'Paramètrage de la connexion'}

    try
      // Ouverture de la connexion
      FDConnection.Open();

      // Si l'arrêt du thread est demandée : on arrête
      if Terminated then
        Exit;

      {$REGION 'Extraction des marques'}
      if Self.ExtraireMarques then
      begin
        ImgMarques.Picture.Bitmap.LoadFromResourceName(HInstance, 'RUNNING');
        LblProgression.Caption  := RS_EXT_MARQUES;
        PbProgression.Position  := 0;

        // Création de la requête d'extraction
        QueRequete.SQL.Clear();
        QueRequete.SQL.Add('SELECT MRK_ID, MRK_NOM');
        QueRequete.SQL.Add('FROM ARTMARQUE');
        QueRequete.SQL.Add('  JOIN K ON (K_ID = MRK_ID AND K_ENABLED = 1 AND K_ID != 0)');
        QueRequete.SQL.Add('ORDER BY MRK_NOM;');

        // Exécution de la requête d'extraction
        QueRequete.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Enregistrement du résultat
        ExportDataSetToDVS(QueRequete, FichierMarques, RS_ENR_MARQUES);
        QueRequete.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgMarques.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      end
      else
        ImgMarques.Picture.Bitmap.LoadFromResourceName(HInstance, 'STOP');
      {$ENDREGION 'Extraction des marques'}

      {$REGION 'Extraction des fournisseurs'}
      if Self.ExtraireFournisseurs then
      begin
        ImgFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'RUNNING');
        LblProgression.Caption  := RS_EXT_FOURNISSEURS;
        PbProgression.Position  := 0;

        // Création de la requête d'extraction
        QueRequete.SQL.Clear();
        QueRequete.SQL.Add('SELECT FOU_ID, FOU_NOM,');
        QueRequete.SQL.Add('       (SELECT ADR1 FROM PR_ADRDECOUPE(GENADRESSE.ADR_LIGNE)) ADR_1,');
        QueRequete.SQL.Add('       (SELECT ADR2 FROM PR_ADRDECOUPE(GENADRESSE.ADR_LIGNE)) ADR_2,');
        QueRequete.SQL.Add('       (SELECT ADR3 FROM PR_ADRDECOUPE(GENADRESSE.ADR_LIGNE)) ADR_3,');
        QueRequete.SQL.Add('       VIL_NOM, VIL_CP, PAY_NOM, ADR_TEL, ADR_FAX, ADR_EMAIL');
        QueRequete.SQL.Add('FROM ARTFOURN');
        QueRequete.SQL.Add('  JOIN K ON (K_ID = FOU_ID AND K_ENABLED = 1 AND FOU_ID != 0)');
        QueRequete.SQL.Add('  LEFT JOIN GENADRESSE ON (ADR_ID = FOU_ADRID)');
        QueRequete.SQL.Add('  LEFT JOIN GENVILLE ON (VIL_ID = ADR_VILID)');
        QueRequete.SQL.Add('  LEFT JOIN GENPAYS ON (PAY_ID = VIL_PAYID)');
        QueRequete.SQL.Add('ORDER BY FOU_NOM;');

        // Exécution de la requête d'extraction
        QueRequete.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Enregistrement du résultat
        ExportDataSetToDVS(QueRequete, FichierFournisseurs, RS_ENR_FOURNISSEURS);
        QueRequete.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      end
      else
        ImgFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'STOP');
      {$ENDREGION 'Extraction des fournisseurs'}

      {$REGION 'Extraction des marques/fournisseurs'}
      if Self.ExtraireMarquesFournisseurs then
      begin
        ImgMarquesFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'RUNNING');
        LblProgression.Caption  := RS_EXT_MARQUESFOURNISSEURS;
        PbProgression.Position  := 0;

        // Création de la requête d'extraction
        QueRequete.SQL.Clear();
        QueRequete.SQL.Add('SELECT MRK_ID, FOU_ID, FMK_PRIN');
        QueRequete.SQL.Add('FROM ARTMARQUE');
        QueRequete.SQL.Add('  JOIN K KMRK ON (KMRK.K_ID = MRK_ID AND KMRK.K_ENABLED = 1 AND MRK_ID != 0)');
        QueRequete.SQL.Add('  JOIN ARTMRKFOURN ON (FMK_MRKID = MRK_ID)');
        QueRequete.SQL.Add('  JOIN K KFMK ON (KFMK.K_ID = FMK_ID AND KFMK.K_ENABLED = 1)');
        QueRequete.SQL.Add('  JOIN ARTFOURN ON (FOU_ID = FMK_FOUID)');
        QueRequete.SQL.Add('  JOIN K KFOU ON (KFOU.K_ID = FOU_ID AND KFOU.K_ENABLED = 1);');

        // Exécution de la requête d'extraction
        QueRequete.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Enregistrement du résultat
        ExportDataSetToDVS(QueRequete, FichierMarquesFournisseurs, RS_ENR_MARQUESFOURNISSEURS);
        QueRequete.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgMarquesFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      end
      else
        ImgMarquesFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'STOP');
      {$ENDREGION 'Extraction des marques/fournisseurs'}

      {$REGION 'Extraction des modèles'}
      if Self.ExtraireModeles then
      begin
        ImgModeles.Picture.Bitmap.LoadFromResourceName(HInstance, 'RUNNING');
        LblProgression.Caption  := RS_EXT_MODELES;
        PbProgression.Position  := 0;

        // Création de la table en mémoire
        MemTModeles.FieldDefs.Clear();
        MemTModeles.FieldDefs.Add('ART_ID', ftInteger, 0, True);
        MemTModeles.FieldDefs.Add('TGF_ID', ftInteger, 0, False);
        MemTModeles.FieldDefs.Add('COU_ID', ftInteger, 0, False);
        MemTModeles.FieldDefs.Add('ART_NOM', ftString, 64, True);
        MemTModeles.FieldDefs.Add('COU_NOM', ftString, 64, False);
        MemTModeles.FieldDefs.Add('COU_CODE', ftString, 64, False);
        MemTModeles.FieldDefs.Add('TGF_NOM', ftString, 64, False);
        MemTModeles.FieldDefs.Add('GEN_PVT_PX', ftCurrency, 0, False);
        MemTModeles.FieldDefs.Add('WEB_PVT_PX', ftCurrency, 0, False);
        MemTModeles.FieldDefs.Add('ARW_WEB', ftSmallint, 0, False);
        MemTModeles.FieldDefs.Add('GIN_CBI_CB', ftString, 64, False);
        MemTModeles.FieldDefs.Add('FOU_CBI_CB', ftString, 64, False);
        MemTModeles.FieldDefs.Add('MRK_ID', ftInteger, 0, False);
        MemTModeles.FieldDefs.Add('FOU_ID', ftInteger, 0, False);
        MemTModeles.FieldDefs.Add('ARF_CHRONO', ftString, 32, False);
        MemTModeles.FieldDefs.Add('PXNEGO', ftCurrency, 0, False);
        MemTModeles.FieldDefs.Add('PXCTLG', ftCurrency, 0, False);
        MemTModeles.FieldDefs.Add('PUMPCOURANT', ftCurrency, 0, False);
        MemTModeles.FieldDefs.Add('TVA_TAUX', ftFloat, 0, False);

        // Récupère le TVT_ID général
        QueTarif.SQL.Clear();
        QueTarif.SQL.Add('SELECT MAG_ID, MAG_TVTID');
        QueTarif.SQL.Add('FROM GENMAGASIN');
        QueTarif.SQL.Add('  JOIN GENBASES ON (BAS_MAGID = MAG_ID)');
        QueTarif.SQL.Add('  JOIN GENPARAMBASE ON (BAS_IDENT = PAR_STRING AND PAR_NOM = ''IDGENERATEUR'');');
        QueTarif.Open();

        if QueTarif.RecordCount > 0 then
        begin
          iMagId    := QueTarif.FieldByName('MAG_ID').AsInteger;
          iTvtIdGen := QueTarif.FieldByName('MAG_TVTID').AsInteger;
        end;

        QueTarif.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Récupère le TVT_ID Web
        try
          QueTarif.SQL.Clear();
          QueTarif.SQL.Add('SELECT MIN(TVT_ID) AS TVT_ID');
          QueTarif.SQL.Add('FROM TARVENTE');
          QueTarif.SQL.Add('  JOIN K ON (K_ID = TVT_ID AND K_ENABLED = 1)');
          QueTarif.SQL.Add('WHERE TVT_NOM = ''WEB'';');
          QueTarif.Open();

          if QueTarif.RecordCount > 0 then
            iTvtIdWeb := QueTarif.FieldByName('TVT_ID').AsInteger;
        finally
          QueTarif.Close();
        end;

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Création de la requête d'extraction
        QueRequete.SQL.Clear();
        QueRequete.SQL.Add('SELECT DISTINCT ART_ID,');
        QueRequete.SQL.Add('                ARF_ID,');
        QueRequete.SQL.Add('                TGF_ID,');
        QueRequete.SQL.Add('                COU_ID,');
        QueRequete.SQL.Add('                ART_NOM,');
        QueRequete.SQL.Add('                COU_NOM,');
        QueRequete.SQL.Add('                COU_CODE,');
        QueRequete.SQL.Add('                TGF_NOM,');
        QueRequete.SQL.Add('                (SELECT MAX(ARW_WEB)');
        QueRequete.SQL.Add('                 FROM   ARTWEB');
        QueRequete.SQL.Add('                 WHERE  ARW_ARTID = ARTARTICLE.ART_ID) ARW_WEB,');
        QueRequete.SQL.Add('                ART_MRKID MRK_ID,');
        QueRequete.SQL.Add('                FMK_FOUID FOU_ID,');
        QueRequete.SQL.Add('                ARF_CHRONO,');
        QueRequete.SQL.Add('                TVA_TAUX');
        QueRequete.SQL.Add('FROM AGRSTOCKCOUR');
        QueRequete.SQL.Add('  JOIN ARTREFERENCE     ON (ARF_ARTID = STC_ARTID)');
        QueRequete.SQL.Add('  JOIN ARTARTICLE       ON (ART_ID = STC_ARTID)');
        QueRequete.SQL.Add('  JOIN K KART           ON (KART.K_ID = ART_ID AND KART.K_ENABLED = 1 AND ART_ID != 0)');
        QueRequete.SQL.Add('  JOIN PLXTAILLESGF     ON (TGF_ID = STC_TGFID)');
        QueRequete.SQL.Add('  JOIN K KTGF           ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1)');
        QueRequete.SQL.Add('  JOIN PLXCOULEUR       ON (COU_ID = STC_COUID)');
        QueRequete.SQL.Add('  JOIN K KCOU           ON (KCOU.K_ID = COU_ID AND KCOU.K_ENABLED = 1)');
        QueRequete.SQL.Add('  JOIN ARTMRKFOURN      ON (FMK_MRKID = ART_MRKID AND FMK_PRIN = 1)');
        QueRequete.SQL.Add('  JOIN K KFMK           ON (KFMK.K_ID = FMK_ID AND KFMK.K_ENABLED = 1)');
        QueRequete.SQL.Add('  JOIN ARTTVA           ON (ARF_TVAID = TVA_ID)');
        QueRequete.SQL.Add('  JOIN K KTVA           ON (KTVA.K_ID = TVA_ID AND KTVA.K_ENABLED = 1)');
        QueRequete.SQL.Add('WHERE STC_QTE != 0;');

        QueTarif.SQL.Clear();
        QueTarif.SQL.Add('SELECT R_PRIX');
        QueTarif.SQL.Add('FROM GETTVTPXVTE(:TVTID, :ARTID, :TGFID, :COUID);');

        QueTarifAchat.SQL.Clear();
        QueTarifAchat.SQL.Add('SELECT PXNEGO, PXCTLG');
        QueTarifAchat.SQL.Add('FROM GETPXACHAT(0, :ARTID, :TGFID, :COUID);');

        QuePumpCourant.SQL.Clear();
        QuePumpCourant.SQL.Add('SELECT R_PUMP');
        QuePumpCourant.SQL.Add('FROM GETPUMPCOUR(:MAGID, :ARTID, :TGFID, :COUID);');

        QueCodeBarresGin.SQL.Clear();
        QueCodeBarresGin.SQL.Add('SELECT CBI_ID, CBI_CB');
        QueCodeBarresGin.SQL.Add('FROM   ARTCODEBARRE');
        QueCodeBarresGin.SQL.Add('  JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
        QueCodeBarresGin.SQL.Add('WHERE CBI_ARFID = :ARFID');
        QueCodeBarresGin.SQL.Add('  AND CBI_TGFID = :TGFID');
        QueCodeBarresGin.SQL.Add('  AND CBI_COUID = :COUID');
        QueCodeBarresGin.SQL.Add('  AND CBI_TYPE = 1');
        QueCodeBarresGin.SQL.Add('ORDER BY K_INSERTED ASC ROWS 1;');

        QueCodeBarresFou.SQL.Clear();
        QueCodeBarresFou.SQL.Add('SELECT CBI_CB');
        QueCodeBarresFou.SQL.Add('FROM ARTCODEBARRE');
        QueCodeBarresFou.SQL.Add('  JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
        QueCodeBarresFou.SQL.Add('WHERE CBI_ARFID = :ARFID');
        QueCodeBarresFou.SQL.Add('  AND CBI_TGFID = :TGFID');
        QueCodeBarresFou.SQL.Add('  AND CBI_COUID = :COUID');
        QueCodeBarresFou.SQL.Add('  AND CBI_TYPE IN (3, 1)');
        QueCodeBarresFou.SQL.Add('  AND CBI_ID != :CBIID');
        QueCodeBarresFou.SQL.Add('ORDER BY CBI_TYPE DESC ROWS 1;');

        // Exécution de la requête d'extraction
        QueRequete.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Récupèration des tarifs
        LblProgression.Caption  := RS_EXT_TARIFS_MODELES;
        PbProgression.Max       := QueRequete.RecordCount;

        MemTModeles.Open();

        // Initialise le nombre de lignes pour faire des pas de 1000
        iNbLignes := 0;
        bPremiereExtraction := False;
        iCbiId := 0;

        while not(QueRequete.Eof) do
        begin
          MemTModeles.Append();

          // Récupère tout les champs de la requête
          for Champ in QueRequete.Fields do
          begin
            if MatchText(Champ.FieldName, MemTModeles.FieldList.ToStringArray()) then
              MemTModeles.FieldByName(Champ.FieldName).AsVariant := QueRequete.FieldByName(Champ.FieldName).AsVariant;
          end;

          // Met "Unicolor" si la couleur n'a pas de nom
          if MemTModeles.FieldByName('COU_CODE').AsString = '' then
            MemTModeles.FieldByName('COU_CODE').AsString := 'Uni';
          if MemTModeles.FieldByName('COU_NOM').AsString = '' then
            MemTModeles.FieldByName('COU_NOM').AsString := 'Unicolor';

          // Met le champ ARW_WEB à zéro si besoin
          if MemTModeles.FieldByName('ARW_WEB').IsNull then
            MemTModeles.FieldByName('ARW_WEB').AsInteger := 0;

          // Récupère le tarif de vente général
          try
            QueTarif.Close();
            QueTarif.ParamByName('TVTID').AsInteger := iTvtIdGen;
            QueTarif.ParamByName('ARTID').AsInteger := QueRequete.FieldByName('ART_ID').AsInteger;
            QueTarif.ParamByName('TGFID').AsInteger := QueRequete.FieldByName('TGF_ID').AsInteger;
            QueTarif.ParamByName('COUID').AsInteger := QueRequete.FieldByName('COU_ID').AsInteger;
            QueTarif.Open();

            // Si l'arrêt du thread est demandée : on arrête
            if Terminated then
              Exit;

            if QueTarif.RecordCount > 0 then
              MemTModeles.FieldByName('GEN_PVT_PX').AsCurrency := QueTarif.FieldByName('R_PRIX').AsCurrency;
          finally
            QueTarif.Close();
          end;

          // Récupère le tarif de vente Web
          try
            QueTarif.Close();
            QueTarif.ParamByName('TVTID').AsInteger := iTvtIdWeb;
            QueTarif.ParamByName('ARTID').AsInteger := QueRequete.FieldByName('ART_ID').AsInteger;
            QueTarif.ParamByName('TGFID').AsInteger := QueRequete.FieldByName('TGF_ID').AsInteger;
            QueTarif.ParamByName('COUID').AsInteger := QueRequete.FieldByName('COU_ID').AsInteger;
            QueTarif.Open();

            // Si l'arrêt du thread est demandée : on arrête
            if Terminated then
              Exit;

            if QueTarif.RecordCount > 0 then
              MemTModeles.FieldByName('WEB_PVT_PX').AsCurrency := QueTarif.FieldByName('R_PRIX').AsCurrency;
          finally
            QueTarif.Close();
          end;

          // Récupère le prix d'achat négocié
          try
            QueTarifAchat.Close();
            QueTarifAchat.ParamByName('ARTID').AsInteger := QueRequete.FieldByName('ART_ID').AsInteger;
            QueTarifAchat.ParamByName('TGFID').AsInteger := QueRequete.FieldByName('TGF_ID').AsInteger;
            QueTarifAchat.ParamByName('COUID').AsInteger := QueRequete.FieldByName('COU_ID').AsInteger;
            QueTarifAchat.Open();

            // Si l'arrêt du thread est demandée : on arrête
            if Terminated then
              Exit;

            if QueTarifAchat.RecordCount > 0 then
            begin
              MemTModeles.FieldByName('PXNEGO').AsCurrency := QueTarifAchat.FieldByName('PXNEGO').AsCurrency;
              MemTModeles.FieldByName('PXCTLG').AsCurrency := QueTarifAchat.FieldByName('PXCTLG').AsCurrency;
            end;
          finally
            QueTarifAchat.Close();
          end;

          // Récupère le PUMP courant
          try
            QuePumpCourant.Close();
            QuePumpCourant.ParamByName('MAGID').AsInteger := iMagId;
            QuePumpCourant.ParamByName('ARTID').AsInteger := QueRequete.FieldByName('ART_ID').AsInteger;
            QuePumpCourant.ParamByName('TGFID').AsInteger := QueRequete.FieldByName('TGF_ID').AsInteger;
            QuePumpCourant.ParamByName('COUID').AsInteger := QueRequete.FieldByName('COU_ID').AsInteger;
            QuePumpCourant.Open();

            // Si l'arrêt du thread est demandée : on arrête
            if Terminated then
              Exit;

            if QuePumpCourant.RecordCount > 0 then
              MemTModeles.FieldByName('PUMPCOURANT').AsCurrency := QuePumpCourant.FieldByName('R_PUMP').AsCurrency;
          finally
            QuePumpCourant.Close();
          end;

          // Récupère le codes-barre Ginkoia
          try
            QueCodeBarresGin.Close();
            QueCodeBarresGin.ParamByName('ARFID').AsInteger := QueRequete.FieldByName('ARF_ID').AsInteger;
            QueCodeBarresGin.ParamByName('TGFID').AsInteger := QueRequete.FieldByName('TGF_ID').AsInteger;
            QueCodeBarresGin.ParamByName('COUID').AsInteger := QueRequete.FieldByName('COU_ID').AsInteger;
            QueCodeBarresGin.Open();

            if not(QueCodeBarresGin.IsEmpty()) then
            begin
              MemTModeles.FieldByName('GIN_CBI_CB').AsString := QueCodeBarresGin.FieldByName('CBI_CB').AsString;
              iCbiId := QueCodeBarresGin.FieldByName('CBI_ID').AsInteger;
            end
            else begin
              iCbiId := 0;
            end;
          finally
            QueCodeBarresGin.Close();
          end;

          // Récupère les codes-barres fournisseur
          try
            QueCodeBarresFou.Close();
            QueCodeBarresFou.ParamByName('ARFID').AsInteger := QueRequete.FieldByName('ARF_ID').AsInteger;
            QueCodeBarresFou.ParamByName('TGFID').AsInteger := QueRequete.FieldByName('TGF_ID').AsInteger;
            QueCodeBarresFou.ParamByName('COUID').AsInteger := QueRequete.FieldByName('COU_ID').AsInteger;
            QueCodeBarresFou.ParamByName('CBIID').AsInteger := iCbiId;
            QueCodeBarresFou.Open();

            if not(QueCodeBarresFou.IsEmpty()) then
            begin
              MemTModeles.FieldByName('FOU_CBI_CB').AsString := QueCodeBarresFou.FieldByName('CBI_CB').AsString;
              QueCodeBarresFou.Next();

              while not(QueCodeBarresFou.Eof) do
              begin
                MemTModeles.Post();

                lLigne.ART_ID       := MemTModeles.FieldByName('ART_ID').AsInteger;
                lLigne.TGF_ID       := MemTModeles.FieldByName('TGF_ID').AsInteger;
                lLigne.COU_ID       := MemTModeles.FieldByName('COU_ID').AsInteger;
                lLigne.ART_NOM      := MemTModeles.FieldByName('ART_NOM').AsString;
                lLigne.COU_NOM      := MemTModeles.FieldByName('COU_NOM').AsString;
                lLigne.COU_CODE     := MemTModeles.FieldByName('COU_CODE').AsString;
                lLigne.TGF_NOM      := MemTModeles.FieldByName('TGF_NOM').AsString;
                lLigne.GEN_PVT_PX   := MemTModeles.FieldByName('GEN_PVT_PX').AsCurrency;
                lLigne.WEB_PVT_PX   := MemTModeles.FieldByName('WEB_PVT_PX').AsCurrency;
                lLigne.ARW_WEB      := MemTModeles.FieldByName('ARW_WEB').AsInteger;
                lLigne.GIN_CBI_CB   := MemTModeles.FieldByName('GIN_CBI_CB').AsString;
                lLigne.MRK_ID       := MemTModeles.FieldByName('MRK_ID').AsInteger;
                lLigne.FOU_ID       := MemTModeles.FieldByName('FOU_ID').AsInteger;
                lLigne.ARF_CHRONO   := MemTModeles.FieldByName('ARF_CHRONO').AsString;
                lLigne.PXNEGO       := MemTModeles.FieldByName('PXNEGO').AsCurrency;
                lLigne.PXCTLG       := MemTModeles.FieldByName('PXCTLG').AsCurrency;
                lLigne.PUMPCOURANT  := MemTModeles.FieldByName('PUMPCOURANT').AsCurrency;
                lLigne.TVA_TAUX     := MemTModeles.FieldByName('TVA_TAUX').AsFloat;

                MemTModeles.AppendRecord([
                  lLigne.ART_ID,
                  lLigne.TGF_ID,
                  lLigne.COU_ID,
                  lLigne.ART_NOM,
                  lLigne.COU_NOM,
                  lLigne.COU_CODE,
                  lLigne.TGF_NOM,
                  lLigne.GEN_PVT_PX,
                  lLigne.WEB_PVT_PX,
                  lLigne.ARW_WEB,
                  lLigne.GIN_CBI_CB,
                  '',
                  lLigne.MRK_ID,
                  lLigne.FOU_ID,
                  lLigne.ARF_CHRONO,
                  lLigne.PXNEGO,
                  lLigne.PXCTLG,
                  lLigne.PUMPCOURANT,
                  lLigne.TVA_TAUX]);

                MemTModeles.Edit();
                MemTModeles.FieldByName('FOU_CBI_CB').AsString := QueCodeBarresFou.FieldByName('CBI_CB').AsString;

                QueCodeBarresFou.Next();
              end;
            end;
          finally
            QueCodeBarresFou.Close();
          end;

          MemTModeles.Post();

          // Incrémente le nombre de lignes
          Inc(iNbLignes);

          // Si on est arrivé à 10000 lignes, on les enregistre dans le fichier
          // avant de vider le MemTable
          if iNbLignes >= 10000 then
          begin
            iPosProg                := PbProgression.Position;
            iMaxProg                := PbProgression.Max;
            ExportDataSetToDVS(MemTModeles, FichierModeles, RS_ENR_MODELES, bPremiereExtraction);
            MemTModeles.EmptyDataSet();
            bPremiereExtraction     := True;
            iNbLignes               := 0;
            PbProgression.Position  := iPosProg;
            PbProgression.Max       := iMaxProg;
          end;

          QueRequete.Next();

          // Si l'arrêt du thread est demandée : on arrête
          if Terminated then
            Exit;

          PbProgression.StepBy(1);
          LblProgression.Caption := Format(RS_EXT_TARIFS_MODELES, [PbProgression.Position, QueRequete.RecordCount]);
        end;

        // Enregistrement du résultat
        ExportDataSetToDVS(MemTModeles, FichierModeles, RS_ENR_MODELES, bPremiereExtraction);
        QueRequete.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgModeles.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      end
      else
        ImgModeles.Picture.Bitmap.LoadFromResourceName(HInstance, 'STOP');
      {$ENDREGION 'Extraction des modèles'}

      {$REGION 'Extraction des restes à livrer'}
      if Self.ExtraireRAL then
      begin
        ImgRAL.Picture.Bitmap.LoadFromResourceName(HInstance, 'RUNNING');
        LblProgression.Caption  := RS_EXT_RAL;
        PbProgression.Position  := 0;

        // Création de la requête d'extraction
        QueRequete.SQL.Clear();
        QueRequete.SQL.Add('SELECT CDE_MAGID AS IDMAGASIN, FOU_ID AS IDFOURNISSEUR, FOU_NOM AS NOMFOURNISSEUR,');
        QueRequete.SQL.Add('       EXTRACT(YEAR FROM CDE_DATE) || SUBSTR(100 + EXTRACT(MONTH FROM CDE_DATE), 2, 3) || SUBSTR(100 + EXTRACT(DAY FROM CDE_DATE), 2, 3) AS DATECOMMANDE,');
        QueRequete.SQL.Add('       CDE_NUMERO AS NUMCOMMANDE, CDE_NUMFOURN AS NUMCDEFOURN,');
        QueRequete.SQL.Add('       EXTRACT(YEAR FROM CDL_LIVRAISON) || SUBSTR(100 + EXTRACT(MONTH FROM CDL_LIVRAISON), 2, 3) || SUBSTR(100 + EXTRACT(DAY FROM CDL_LIVRAISON), 2, 3) AS LIVRPREVUE,');
        QueRequete.SQL.Add('       CDL_PXCTLG PXACHATBRUT, CDL_REMISE1 REMISE1ENPOURCENT, CDL_REMISE2 REMISE2ENPOURCENT,');
        QueRequete.SQL.Add('       CDL_REMISE3 REMISE3ENPOURCENT, CDL_PXACHAT PXACHATNET, CBI_CB AS SKU, CDL_QTE AS QTECOMMANDE,');
        QueRequete.SQL.Add('       RAL_QTE AS QTERAL');
        QueRequete.SQL.Add('FROM AGRRAL');
        QueRequete.SQL.Add('  JOIN COMBCDEL ON (RAL_CDLID = CDL_ID)');
        QueRequete.SQL.Add('  JOIN K KCDL ON (KCDL.K_ID = CDL_ID AND KCDL.K_ENABLED = 1)');
        QueRequete.SQL.Add('  JOIN COMBCDE ON (CDL_CDEID = CDE_ID)');
        QueRequete.SQL.Add('  JOIN K KCDE ON (KCDE.K_ID = CDE_ID AND KCDE.K_ENABLED = 1)');
        QueRequete.SQL.Add('  JOIN ARTFOURN ON (CDE_FOUID = FOU_ID)');
        QueRequete.SQL.Add('  JOIN ARTREFERENCE ON (CDL_ARTID = ARF_ARTID)');
        QueRequete.SQL.Add('  JOIN ARTCODEBARRE ON (CBI_ARFID = ARF_ID AND CBI_TGFID = CDL_TGFID AND CBI_COUID = CDL_COUID AND CBI_TYPE = 1)');
        QueRequete.SQL.Add('  JOIN K KCBI ON (KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1)');
        QueRequete.SQL.Add('WHERE RAL_ID <> 0');
        QueRequete.SQL.Add('ORDER BY CDE_MAGID, FOU_NOM, CDE_DATE;');

        // Exécution de la requête d'extraction
        QueRequete.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Enregistrement du résultat
        ExportDataSetToDVS(QueRequete, FichierRAL, RS_ENR_RAL);
        QueRequete.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgRAL.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      end
      else
        ImgRAL.Picture.Bitmap.LoadFromResourceName(HInstance, 'STOP');
      {$ENDREGION 'Extraction des restes à livrer'}

      {$REGION 'Extraction des stocks'}
      if Self.ExtraireStocks then
      begin
        ImgStocks.Picture.Bitmap.LoadFromResourceName(HInstance, 'RUNNING');
        LblProgression.Caption  := RS_EXT_STOCKS;
        PbProgression.Position  := 0;

        // Création de la requête d'extraction
        QueRequete.SQL.Clear();
        QueRequete.SQL.Add('SELECT STC_MAGID AS IDMAGASIN, CBI_CB AS SKU, STC_QTE AS QTESTOCK');
        QueRequete.SQL.Add('FROM AGRSTOCKCOUR');
        QueRequete.SQL.Add('  JOIN ARTREFERENCE ON (STC_ARTID = ARF_ARTID)');
        QueRequete.SQL.Add('  JOIN ARTCODEBARRE ON (CBI_ARFID = ARF_ID AND CBI_TGFID = STC_TGFID AND CBI_COUID = STC_COUID AND CBI_TYPE = 1)');
        QueRequete.SQL.Add('  JOIN K KCBI ON (KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1)');
        QueRequete.SQL.Add('WHERE STC_QTE <> 0');
        QueRequete.SQL.Add('ORDER BY STC_MAGID, CBI_CB;');

        // Exécution de la requête d'extraction
        QueRequete.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Enregistrement du résultat
        ExportDataSetToDVS(QueRequete, FichierStocks, RS_ENR_STOCKS);
        QueRequete.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgStocks.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      end
      else
        ImgStocks.Picture.Bitmap.LoadFromResourceName(HInstance, 'STOP');
      {$ENDREGION 'Extraction des stocks'}

      LblProgression.Caption := RS_TERMINEE;
    except
      on E: Exception do
      begin
        LblProgression.Caption    := Format('Erreur : %s - %s', [E.ClassName, E.Message]);
        LblProgression.Font.Color := $0000FF;
      end;
    end;
  finally
    FDConnection.Free();
    FDTransaction.Free();
    QueRequete.Free();
    QueTarif.Free();
    QueTarifAchat.Free();
    QuePumpCourant.Free();
    QueCodeBarresGin.Free();
    QueCodeBarresFou.Free();
    MemTModeles.Free();
    FDPhysIBDriverLink.Free();
  end;
end;

procedure TThreadExtraction.ExportDataSetToDVS(ADataSet: TDataSet;
  const AFichier: TFileName; const ATxtMsg: string;
  const AAjouter: Boolean = False);
var
  fChamp: TField;
  slLigne: TStringList;
  bActive: Boolean;
  twFichier: TTextWriter;
begin
  // Vérifie que le répertoire existe
  if ForceDirectories(ExtractFileDir(AFichier)) then
  begin
    twFichier := TStreamWriter.Create(AFichier, AAjouter);
    try
      slLigne := TStringList.Create();
      try
        bActive := ADataSet.Active;
        try
          ADataSet.Active             := True;
          PbProgression.Max           := ADataSet.RecordCount;
          PbProgression.Position      := 0;
          ADataSet.GetFieldNames(slLigne);
          slLigne.Delimiter           := '|';
          slLigne.StrictDelimiter     := True;
          if not(AAjouter) then
            twFichier.WriteLine(slLigne.DelimitedText);
          ADataSet.First();
          while not ADataSet.Eof do
          begin
            slLigne.Clear();
            for fChamp in ADataSet.Fields do
              slLigne.Add(StringReplace(fChamp.Text, sLineBreak, ' ', [rfReplaceAll]));
            twFichier.WriteLine(slLigne.DelimitedText);
            ADataSet.Next();
            PbProgression.StepBy(1);
            LblProgression.Caption := Format(ATxtMsg, [PbProgression.Position, ADataSet.RecordCount]);

            // Si l'arrêt du thread est demandée : on arrête
            if Terminated then
              Exit;
          end;
        finally
          ADataSet.Active := bActive;
        end;
      finally
        slLigne.Free();
      end;
    finally
      twFichier.Free();
    end;
  end;
end;

end.

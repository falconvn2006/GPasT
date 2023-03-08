unit Extraction.Thread.Extraction;

interface

uses
  System.Classes, System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.IBBase, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.StdCtrls, Vcl.ComCtrls,  Vcl.ExtCtrls,
  Extraction.Ressourses;

type
  TArticle = record
    Sku_Ginkoia           : string[64];
    Sku_Fournisseur       : string[64];
    Designation           : string[64];
    Stock                 : Double;
    Date_Creation         : string[8];
    Date_Modification     : string[8];
    Id_Produit            : Integer;
    Id_Taille             : Integer;
    Id_Couleur            : Integer;
    Prix_Achat            : Currency;
  end;

  TDescription = record
    Sku_Ginkoia           : string[64];
    Sku_Fournisseur       : string[64];
    Designation           : string[64];
    Description           : string[255];
    Id_Produit            : Integer;
    Id_Taille             : Integer;
    Id_Couleur            : Integer;
  end;

  TThreadExtraction = class(TThread)
  private
    { Déclarations privées }
    FDConnection          : TFDConnection;
    FDTransaction         : TFDTransaction;
    FDPhysIBDriverLink    : TFDPhysIBDriverLink;
    QueArticles           : TFDQuery;
    QueSKUGinkoia         : TFDQuery;
    QueSKUFournisseurs    : TFDQuery;
    QueTarifNego          : TFDQuery;
    QueStock              : TFDQuery;
    MemTArticles          : TFDMemTable;
    QueDescriptions       : TFDQuery;
    MemTDescriptions      : TFDMemTable;
    procedure ExportDataSetToDVS(DataSet: TDataSet; const FileName: TFileName; const TxtMsg: string);
  protected
    procedure Execute(); override;
  public
    { Déclarations publiques }
    BaseDonnees           : TFileName;
    FichierArticles       : TFileName;
    FichierDescriptions   : TFileName;
    LblProgression        : ^TLabel;
    PbProgression         : ^TProgressBar;
    ImgArticles           : ^TImage;
    ImgDescriptions       : ^TImage;
    iMagId                : Integer;
    ExtraireArticles      : Boolean;
    ExtraireDescriptions  : Boolean;
  end;

implementation

{ TThreadExtraction }

procedure TThreadExtraction.Execute();
var
  Champ       : TField;
  Article     : TArticle;
  Description : TDescription;
begin
  FDConnection            := TFDConnection.Create(nil);
  FDTransaction           := TFDTransaction.Create(nil);
  FDPhysIBDriverLink      := TFDPhysIBDriverLink.Create(nil);
  QueArticles             := TFDQuery.Create(nil);
  QueSKUGinkoia           := TFDQuery.Create(nil);
  QueSKUFournisseurs      := TFDQuery.Create(nil);
  QueTarifNego            := TFDQuery.Create(nil);
  QueStock                := TFDQuery.Create(nil);
  MemTArticles            := TFDMemTable.Create(nil);
  QueDescriptions         := TFDQuery.Create(nil);
  MemTDescriptions        := TFDMemTable.Create(nil);

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

    QueArticles.Connection              := FDConnection;
    QueArticles.Transaction             := FDTransaction;
    QueArticles.FetchOptions.Mode       := fmAll;
    QueTarifNego.Connection             := FDConnection;
    QueTarifNego.Transaction            := FDTransaction;
    QueSKUGinkoia.Connection            := FDConnection;                                                   
    QueSKUGinkoia.Transaction           := FDTransaction;   
    QueSKUFournisseurs.Connection       := FDConnection;                       
    QueSKUFournisseurs.Transaction      := FDTransaction; 
    QueStock.Connection                 := FDConnection;
    QueStock.Transaction                := FDTransaction;
    QueDescriptions.Connection          := FDConnection;
    QueDescriptions.Transaction         := FDTransaction;
    QueDescriptions.FetchOptions.Mode   := fmAll;
    {$ENDREGION 'Paramètrage de la connexion'}

    try
      // Ouverture de la connexion
      FDConnection.Open();

      // Si l'arrêt du thread est demandée : on arrête
      if Self.Terminated then
        Exit;

      {$REGION 'Extraction des articles'}
      if Self.ExtraireArticles then
      begin
        ImgArticles.Picture.Bitmap.LoadFromResourceName(HInstance, 'INDENT_TASK');
        LblProgression.Caption  := RS_EXT_ARTICLES;
        PbProgression.Position  := 0;

        // Création de la table en mémoire
        MemTArticles.FieldDefs.Clear();
        MemTArticles.FieldDefs.Add('SKU_GINKOIA', ftString, 64, True);
        MemTArticles.FieldDefs.Add('SKU_FOURNISSEUR', ftString, 64, False);
        MemTArticles.FieldDefs.Add('DESIGNATION', ftString, 64, False);
        MemTArticles.FieldDefs.Add('STOCK', ftFloat, 0, False);
        MemTArticles.FieldDefs.Add('DATE_CREATION', ftString, 8, False);
        MemTArticles.FieldDefs.Add('DATE_MODIFICATION', ftString, 8, False);
        MemTArticles.FieldDefs.Add('ID_PRODUIT', ftInteger, 0, True);
        MemTArticles.FieldDefs.Add('ID_TAILLE', ftInteger, 0, True);
        MemTArticles.FieldDefs.Add('ID_COULEUR', ftInteger, 0, True);
        MemTArticles.FieldDefs.Add('PRIX_ACHAT', ftCurrency, 0, False);
        MemTArticles.CreateDataSet();

        // Création de la requête d'extraction des articles
        QueArticles.SQL.Clear();
        QueArticles.SQL.Add('SELECT ART_NOM "DESIGNATION", ');
        QueArticles.SQL.Add('       EXTRACT(YEAR FROM ARF_CREE) || SUBSTR(100 + EXTRACT(MONTH FROM ARF_CREE), 2, 3) || SUBSTR(100 + EXTRACT(DAY FROM ARF_CREE), 2, 3) "DATE_CREATION",');
        QueArticles.SQL.Add('       EXTRACT(YEAR FROM ARF_MODIF) || SUBSTR(100 + EXTRACT(MONTH FROM ARF_MODIF), 2, 3) || SUBSTR(100 + EXTRACT(DAY FROM ARF_MODIF), 2, 3) "DATE_MODIFICATION",');
        QueArticles.SQL.Add('       ART_ID "ID_PRODUIT", TGF_ID "ID_TAILLE", COU_ID "ID_COULEUR"');
        QueArticles.SQL.Add('FROM ARTARTICLE');
        QueArticles.SQL.Add('  JOIN K KART ON (KART.K_ID = ART_ID AND KART.K_ENABLED = 1 AND K_ID != 0)');
        QueArticles.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ARTID = ART_ID)');
        QueArticles.SQL.Add('  JOIN PLXTAILLESTRAV ON (TTV_ARTID = ART_ID)');
        QueArticles.SQL.Add('  JOIN K KTTV ON (KTTV.K_ID = TTV_ID AND KTTV.K_ENABLED = 1)');
        QueArticles.SQL.Add('  JOIN PLXTAILLESGF ON (TGF_ID = TTV_TGFID)');
        QueArticles.SQL.Add('  JOIN K KTGF ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1)');
        QueArticles.SQL.Add('  JOIN PLXCOULEUR ON (COU_ARTID = ART_ID)');
        QueArticles.SQL.Add('  JOIN K KCOU ON (KCOU.K_ID = COU_ID AND KCOU.K_ENABLED = 1)');

        // Création des requêtes pour la récupération des prix d'achat
        QueTarifNego.SQL.Clear();
        QueTarifNego.SQL.Add('SELECT CLG_PXNEGO "PRIX_ACHAT"');
        QueTarifNego.SQL.Add('FROM RV_TARCLGFOURN(:ARTID, 0, :MAGID)');
        QueTarifNego.SQL.Add('ORDER BY TGF_ORDREAFF');
        QueTarifNego.Prepare();

        // Création de la requête pour la récupération des codes-barres Ginkoia
        QueSKUGinkoia.SQL.Clear();
        QueSKUGinkoia.SQL.Add('SELECT CBI_CB "SKU_GINKOIA"');
        QueSKUGinkoia.SQL.Add('FROM ARTCODEBARRE');
        QueSKUGinkoia.SQL.Add('  JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
        QueSKUGinkoia.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ID = CBI_ARFID)');
        QueSKUGinkoia.SQL.Add('WHERE CBI_TYPE = 1');
        QueSKUGinkoia.SQL.Add('  AND ARF_ARTID = :ARTID');
        QueSKUGinkoia.SQL.Add('  AND CBI_TGFID = :TGFID');
        QueSKUGinkoia.SQL.Add('  AND CBI_COUID = :COUID ROWS 1');
        QueSKUGinkoia.Prepare();

        // Création de la requête pour la récupération des codes-barres fournisseurs
        QueSKUFournisseurs.SQL.Clear();
        QueSKUFournisseurs.SQL.Add('SELECT CBI_CB "SKU_FOURNISSEUR"');
        QueSKUFournisseurs.SQL.Add('FROM ARTCODEBARRE');
        QueSKUFournisseurs.SQL.Add('  JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
        QueSKUFournisseurs.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ID = CBI_ARFID)');
        QueSKUFournisseurs.SQL.Add('WHERE CBI_TYPE = 3');
        QueSKUFournisseurs.SQL.Add('  AND ARF_ARTID = :ARTID');
        QueSKUFournisseurs.SQL.Add('  AND CBI_TGFID = :TGFID');
        QueSKUFournisseurs.SQL.Add('  AND CBI_COUID = :COUID');
        QueSKUFournisseurs.Prepare();

        // Création de la requête pour les stocks
        QueStock.SQL.Clear();
        QueStock.SQL.Add('SELECT STC_QTE "STOCK"');
        QueStock.SQL.Add('FROM AGRSTOCKCOUR');
        QueStock.SQL.Add('WHERE STC_MAGID = :MAGID');
        QueStock.SQL.Add('  AND STC_ARTID = :ARTID');
        QueStock.SQL.Add('  AND STC_TGFID = :TGFID');
        QueStock.SQL.Add('  AND STC_COUID = :COUID');
        QueStock.Prepare();

        // Ouverture de la requête pour les articles
        try
          QueArticles.Open();

          // Si l'arrêt du thread est demandée : on arrête
          if Self.Terminated then
            Exit;

          MemTArticles.Open();

          PbProgression.Max := QueArticles.RecordCount;

          // Parcours tout les articles récupérés
          while not(QueArticles.Eof) do
          begin
            MemTArticles.Append();

            // Récupère tout les champs de la requête
            for Champ in QueArticles.Fields do
              if not(SameText(Champ.FieldName, 'DATE_MODIFICATION') and SameStr(QueArticles.FieldByName(Champ.FieldName).AsString, '18991230')) then
                MemTArticles.FieldByName(Champ.FieldName).AsVariant := QueArticles.FieldByName(Champ.FieldName).AsVariant;

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            // Récupère le prix d'achat négocié au SKU
            try
              QueTarifNego.ParamByName('ARTID').AsInteger := QueArticles.FieldByName('ID_PRODUIT').AsInteger;
              QueTarifNego.ParamByName('MAGID').AsInteger := Self.iMagId;
              QueTarifNego.Open();

              if QueTarifNego.RecordCount > 0 then
              begin
                MemTArticles.FieldByName('PRIX_ACHAT').AsCurrency := QueTarifNego.FieldByName('PRIX_ACHAT').AsCurrency;
              end;
            finally
              QueTarifNego.Close();
            end;

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            // Récupère le stock
            try
              QueStock.ParamByName('MAGID').AsInteger := Self.iMagId;
              QueStock.ParamByName('ARTID').AsInteger := QueArticles.FieldByName('ID_PRODUIT').AsInteger;
              QueStock.ParamByName('TGFID').AsInteger := QueArticles.FieldByName('ID_TAILLE').AsInteger;
              QueStock.ParamByName('COUID').AsInteger := QueArticles.FieldByName('ID_COULEUR').AsInteger;
              QueStock.Open();

              if QueStock.RecordCount > 0 then
                MemTArticles.FieldByName('STOCK').AsFloat := QueStock.FieldByName('STOCK').AsFloat
              else
                MemTArticles.FieldByName('STOCK').AsFloat := 0;
            finally
              QueStock.Close();
            end;

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            // Récupère le code-barres Ginkoia
            try
              QueSKUGinkoia.ParamByName('ARTID').AsInteger := QueArticles.FieldByName('ID_PRODUIT').AsInteger;
              QueSKUGinkoia.ParamByName('TGFID').AsInteger := QueArticles.FieldByName('ID_TAILLE').AsInteger;
              QueSKUGinkoia.ParamByName('COUID').AsInteger := QueArticles.FieldByName('ID_COULEUR').AsInteger;
              QueSKUGinkoia.Open();

              if QueSKUGinkoia.RecordCount > 0 then
              begin
                MemTArticles.FieldByName('SKU_GINKOIA').AsString := QueSKUGinkoia.FieldByName('SKU_GINKOIA').AsString;
              end
              else begin
                // L'article n'a pas de code-barres : on ne l'exporte pas
                MemTArticles.Cancel();
                QueArticles.Next();
                Continue;
              end;
            finally
              QueSKUGinkoia.Close();
            end;

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            // Récupère les codes-barres fournisseurs
            try
              QueSKUFournisseurs.ParamByName('ARTID').AsInteger := QueArticles.FieldByName('ID_PRODUIT').AsInteger;
              QueSKUFournisseurs.ParamByName('TGFID').AsInteger := QueArticles.FieldByName('ID_TAILLE').AsInteger;
              QueSKUFournisseurs.ParamByName('COUID').AsInteger := QueArticles.FieldByName('ID_COULEUR').AsInteger;
              QueSKUFournisseurs.Open();

              if QueSKUFournisseurs.RecordCount > 0 then
              begin
                // Récupére le premier code-barres fournisseur
                MemTArticles.FieldByName('SKU_FOURNISSEUR').AsString := QueSKUFournisseurs.FieldByName('SKU_FOURNISSEUR').AsString;

                // Récupére les autres codes-barres
                QueSKUFournisseurs.Next();
                while not(QueSKUFournisseurs.Eof) do
                begin
                  MemTArticles.Post();

                  Article.Sku_Ginkoia         := MemTArticles.FieldByName('SKU_GINKOIA').AsString;
                  Article.Sku_Fournisseur     := QueSKUFournisseurs.FieldByName('SKU_FOURNISSEUR').AsString;
                  Article.Designation         := MemTArticles.FieldByName('DESIGNATION').AsString;
                  Article.Stock               := MemTArticles.FieldByName('STOCK').AsFloat;
                  Article.Date_Creation       := MemTArticles.FieldByName('DATE_CREATION').AsString;
                  Article.Date_Modification   := MemTArticles.FieldByName('DATE_MODIFICATION').AsString;
                  Article.Id_Produit          := MemTArticles.FieldByName('ID_PRODUIT').AsInteger;
                  Article.Id_Taille           := MemTArticles.FieldByName('ID_TAILLE').AsInteger;
                  Article.Id_Couleur          := MemTArticles.FieldByName('ID_COULEUR').AsInteger;
                  Article.Prix_Achat          := MemTArticles.FieldByName('PRIX_ACHAT').AsCurrency;

                  MemTArticles.Append();

                  // Récupère tout les champs des requêtes précédentes
                  MemTArticles.FieldByName('SKU_GINKOIA').AsString        := Article.Sku_Ginkoia;
                  MemTArticles.FieldByName('SKU_FOURNISSEUR').AsString    := Article.Sku_Fournisseur;
                  MemTArticles.FieldByName('DESIGNATION').AsString        := Article.Designation;
                  MemTArticles.FieldByName('STOCK').AsFloat               := Article.Stock;
                  MemTArticles.FieldByName('DATE_CREATION').AsString      := Article.Date_Creation;
                  MemTArticles.FieldByName('DATE_MODIFICATION').AsString  := Article.Date_Modification;
                  MemTArticles.FieldByName('ID_PRODUIT').AsInteger        := Article.Id_Produit;
                  MemTArticles.FieldByName('ID_TAILLE').AsInteger         := Article.Id_Taille;
                  MemTArticles.FieldByName('ID_COULEUR').AsInteger        := Article.Id_Couleur;
                  MemTArticles.FieldByName('PRIX_ACHAT').AsCurrency       := Article.Prix_Achat;

                  QueSKUFournisseurs.Next();
                end;
              end;
            finally
              QueSKUFournisseurs.Close();
            end;

            // Enregistre la ligne en mémoire
            MemTArticles.Post();
            QueArticles.Next();

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            PbProgression.StepBy(1);
            LblProgression.Caption := Format(RS_EXT_TARIFS_ARTICLES, [PbProgression.Position, QueArticles.RecordCount]);
          end;

          // Enregistrement du résultat
          ExportDataSetToDVS(MemTArticles, FichierArticles, RS_ENR_ARTICLES);
        finally
          QueArticles.Close();
          MemTArticles.Close();
        end;

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgArticles.Picture.Bitmap.LoadFromResourceName(HInstance, 'AGT_ACTION_SUCCESS');
      end;
      {$ENDREGION 'Extraction des articles'}

      {$REGION 'Extraction des descriptions'}
      if Self.ExtraireDescriptions then
      begin
        ImgDescriptions.Picture.Bitmap.LoadFromResourceName(HInstance, 'INDENT_TASK');
        LblProgression.Caption  := RS_EXT_DESCRIPTIONS;
        PbProgression.Position  := 0;

        // Création de la table en mémoire
        MemTDescriptions.FieldDefs.Clear();
        MemTDescriptions.FieldDefs.Add('SKU_GINKOIA', ftString, 64, True);
        MemTDescriptions.FieldDefs.Add('SKU_FOURNISSEUR', ftString, 64, False);
        MemTDescriptions.FieldDefs.Add('DESIGNATION', ftString, 64, False);
        MemTDescriptions.FieldDefs.Add('DESCRIPTION', ftString, 255, False);
        MemTDescriptions.FieldDefs.Add('ID_PRODUIT', ftInteger, 0, True);
        MemTDescriptions.FieldDefs.Add('ID_TAILLE', ftInteger, 0, True);
        MemTDescriptions.FieldDefs.Add('ID_COULEUR', ftInteger, 0, True);
        MemTDescriptions.CreateDataSet();

        // Création de la requête d'extraction des descriptions
        QueDescriptions.SQL.Clear();
        QueDescriptions.SQL.Add('SELECT ART_NOM "DESIGNATION", ART_DESCRIPTION "DESCRIPTION", ART_ID "ID_PRODUIT",');
        QueDescriptions.SQL.Add('       TGF_ID "ID_TAILLE", COU_ID "ID_COULEUR"');
        QueDescriptions.SQL.Add('FROM ARTARTICLE');
        QueDescriptions.SQL.Add('  JOIN K KART ON (KART.K_ID = ART_ID AND KART.K_ENABLED = 1 AND K_ID != 0)');
        QueDescriptions.SQL.Add('  JOIN PLXTAILLESTRAV ON (TTV_ARTID = ART_ID)');
        QueDescriptions.SQL.Add('  JOIN K KTTV ON (KTTV.K_ID = TTV_ID AND KTTV.K_ENABLED = 1)');
        QueDescriptions.SQL.Add('  JOIN PLXTAILLESGF ON (TGF_ID = TTV_TGFID)');
        QueDescriptions.SQL.Add('  JOIN K KTGF ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1)');
        QueDescriptions.SQL.Add('  JOIN PLXCOULEUR ON (COU_ARTID = ART_ID)');
        QueDescriptions.SQL.Add('  JOIN K KCOU ON (KCOU.K_ID = COU_ID AND KCOU.K_ENABLED = 1)');
        QueDescriptions.SQL.Add('  JOIN ARTDISPOWEB ON (ADW_ARTID = ART_ID AND ADW_TGFID = TGF_ID AND ADW_COUID = COU_ID AND ADW_DISPO = 1)');
        QueDescriptions.SQL.Add('  JOIN K KADW ON (KADW.K_ID = ADW_ID AND KADW.K_ENABLED = 1);');

        // Création de la requête pour la récupération des codes-barres Ginkoia
        QueSKUGinkoia.SQL.Clear();
        QueSKUGinkoia.SQL.Add('SELECT CBI_CB "SKU_GINKOIA"');
        QueSKUGinkoia.SQL.Add('FROM ARTCODEBARRE');
        QueSKUGinkoia.SQL.Add('  JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
        QueSKUGinkoia.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ID = CBI_ARFID)');
        QueSKUGinkoia.SQL.Add('WHERE CBI_TYPE = 1');
        QueSKUGinkoia.SQL.Add('  AND ARF_ARTID = :ARTID');
        QueSKUGinkoia.SQL.Add('  AND CBI_TGFID = :TGFID');
        QueSKUGinkoia.SQL.Add('  AND CBI_COUID = :COUID ROWS 1;');
        QueSKUGinkoia.Prepare();

        // Création de la requête pour la récupération des codes-barres fournisseurs
        QueSKUFournisseurs.SQL.Clear();
        QueSKUFournisseurs.SQL.Add('SELECT CBI_CB "SKU_FOURNISSEUR"');
        QueSKUFournisseurs.SQL.Add('FROM ARTCODEBARRE');
        QueSKUFournisseurs.SQL.Add('  JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
        QueSKUFournisseurs.SQL.Add('  JOIN ARTREFERENCE ON (ARF_ID = CBI_ARFID)');
        QueSKUFournisseurs.SQL.Add('WHERE CBI_TYPE = 3');
        QueSKUFournisseurs.SQL.Add('  AND ARF_ARTID = :ARTID');
        QueSKUFournisseurs.SQL.Add('  AND CBI_TGFID = :TGFID');
        QueSKUFournisseurs.SQL.Add('  AND CBI_COUID = :COUID;');
        QueSKUFournisseurs.Prepare();

        // Ouverture de la requête pour les descriptions
        try
          QueDescriptions.Open();

          // Si l'arrêt du thread est demandée : on arrête
          if Self.Terminated then
            Exit;

          MemTDescriptions.Open();

          PbProgression.Max := QueDescriptions.RecordCount;

          // Parcours toutes les descriptions récupérées
          while not(QueDescriptions.Eof) do
          begin
            MemTDescriptions.Append();

            // Récupère tout les champs de la requête
            for Champ in QueDescriptions.Fields do
              MemTDescriptions.FieldByName(Champ.FieldName).AsVariant := Champ.AsVariant;

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            // Récupère le code-barres Ginkoia
            try
              QueSKUGinkoia.ParamByName('ARTID').AsInteger := QueDescriptions.FieldByName('ID_PRODUIT').AsInteger;
              QueSKUGinkoia.ParamByName('TGFID').AsInteger := QueDescriptions.FieldByName('ID_TAILLE').AsInteger;
              QueSKUGinkoia.ParamByName('COUID').AsInteger := QueDescriptions.FieldByName('ID_COULEUR').AsInteger;
              QueSKUGinkoia.Open();

              if not(QueSKUGinkoia.IsEmpty) then
              begin
                MemTDescriptions.FieldByName('SKU_GINKOIA').AsString := QueSKUGinkoia.FieldByName('SKU_GINKOIA').AsString;
              end
              else begin
                // L'article n'a pas de code-barres : on ne l'exporte pas
                MemTDescriptions.Cancel();
                QueDescriptions.Next();
                Continue;
              end;
            finally
              QueSKUGinkoia.Close();
            end;

            // Récupère les codes-barres fournisseurs
            try
              QueSKUFournisseurs.ParamByName('ARTID').AsInteger := QueDescriptions.FieldByName('ID_PRODUIT').AsInteger;
              QueSKUFournisseurs.ParamByName('TGFID').AsInteger := QueDescriptions.FieldByName('ID_TAILLE').AsInteger;
              QueSKUFournisseurs.ParamByName('COUID').AsInteger := QueDescriptions.FieldByName('ID_COULEUR').AsInteger;
              QueSKUFournisseurs.Open();

              if not(QueSKUFournisseurs.IsEmpty) then
              begin
                // Récupére le premier code-barres fournisseur
                MemTDescriptions.FieldByName('SKU_FOURNISSEUR').AsString := QueSKUFournisseurs.FieldByName('SKU_FOURNISSEUR').AsString;

                // Récupére les autres codes-barres
                QueSKUFournisseurs.Next();
                while not(QueSKUFournisseurs.Eof) do
                begin
                  MemTDescriptions.Post();

                  Description.Sku_Ginkoia     := MemTDescriptions.FieldByName('SKU_GINKOIA').AsString;
                  Description.Sku_Fournisseur := QueSKUFournisseurs.FieldByName('SKU_FOURNISSEUR').AsString;
                  Description.Designation     := MemTDescriptions.FieldByName('DESIGNATION').AsString;
                  Description.Description     := MemTDescriptions.FieldByName('DESCRIPTION').AsString;
                  Description.Id_Produit      := MemTDescriptions.FieldByName('ID_PRODUIT').AsInteger;
                  Description.Id_Taille       := MemTDescriptions.FieldByName('ID_TAILLE').AsInteger;
                  Description.Id_Couleur      := MemTDescriptions.FieldByName('ID_COULEUR').AsInteger;

                  MemTDescriptions.Append();

                  // Récupère tout les champs des requêtes précédentes
                  MemTDescriptions.FieldByName('SKU_GINKOIA').AsString      := Description.Sku_Ginkoia;
                  MemTDescriptions.FieldByName('SKU_FOURNISSEUR').AsString  := Description.Sku_Fournisseur;
                  MemTDescriptions.FieldByName('DESIGNATION').AsString      := Description.Designation;
                  MemTDescriptions.FieldByName('DESCRIPTION').AsString      := Description.Description;
                  MemTDescriptions.FieldByName('ID_PRODUIT').AsInteger      := Description.Id_Produit;
                  MemTDescriptions.FieldByName('ID_TAILLE').AsInteger       := Description.Id_Taille;
                  MemTDescriptions.FieldByName('ID_COULEUR').AsInteger      := Description.Id_Couleur;

                  QueSKUFournisseurs.Next();
                end;
              end;
            finally
              QueSKUFournisseurs.Close();
            end;

            // Enregistre la ligne en mémoire
            MemTDescriptions.Post();
            QueDescriptions.Next();

            // Si l'arrêt du thread est demandée : on arrête
            if Self.Terminated then
              Exit;

            PbProgression.StepBy(1);
            LblProgression.Caption := Format(RS_EXT_INFOS_DESCRIPTIONS, [PbProgression.Position, QueDescriptions.RecordCount]);
          end;

          // Enregistrement du résultat
          ExportDataSetToDVS(MemTDescriptions, FichierDescriptions, RS_ENR_DESCRIPTIONS);
        finally
          QueDescriptions.Close();
          MemTDescriptions.Close();
        end;
      end;
      {$ENDREGION 'Extraction des descriptions'}

      LblProgression.Caption := RS_TERMINEE;
    except
      on E: Exception do
      begin
        LblProgression.Caption    := Format('Erreur : %s - %s', [E.ClassName, E.Message]);
        LblProgression.Hint       := LblProgression.Caption;
        LblProgression.Font.Color := $0000FF;
      end;
    end;
  finally
    FDConnection.Free();
    FDTransaction.Free();
    FDPhysIBDriverLink.Free();
    QueArticles.Free();
    QueSKUGinkoia.Free();
    QueSKUFournisseurs.Free();
    QueTarifNego.Free();
    QueStock.Free();  
    MemTArticles.Free();
    QueDescriptions.Free();
    MemTDescriptions.Free();
  end;
end;

procedure TThreadExtraction.ExportDataSetToDVS(DataSet: TDataSet;
  const FileName: TFileName; const TxtMsg: string);
var
  fld: TField;
  lst: TStringList;
  wasActive: Boolean;
  writer: TTextWriter;
begin
  writer := TStreamWriter.Create(FileName);
  try
    lst := TStringList.Create();
    try
      wasActive := DataSet.Active;
      try
        DataSet.Active          := True;
        PbProgression.Max       := DataSet.RecordCount;
        PbProgression.Position  := 0;
//        PbProgression.Style     := pbstNormal;
        DataSet.GetFieldNames(lst);
        lst.Delimiter           := '|';
        lst.StrictDelimiter     := True;
        writer.WriteLine(lst.DelimitedText);
        DataSet.First();
        while not DataSet.Eof do
        begin
          lst.Clear();
          for fld in DataSet.Fields do
          begin
            lst.Add(StringReplace(StringReplace(fld.Text, sLineBreak, ' ', [rfReplaceAll]), #10, ' ', [rfReplaceAll]));
          end;
          writer.WriteLine(lst.DelimitedText);
          DataSet.Next();
          PbProgression.StepBy(1);
          LblProgression.Caption := Format(TxtMsg, [PbProgression.Position, DataSet.RecordCount]);

          // Si l'arrêt du thread est demandée : on arrête
          if Terminated then
            Exit;
        end;
      finally
        DataSet.Active := wasActive;
      end;
    finally
      lst.Free();
    end;
  finally
    writer.Free();
  end;
end;

end.

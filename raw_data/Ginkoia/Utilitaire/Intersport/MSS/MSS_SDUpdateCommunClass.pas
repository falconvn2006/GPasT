unit MSS_SDUpdateCommunClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type, Types,
     MSS_PeriodsClass, Math;

type
  TUpdateMode = (umInsert, umUpdate);

  TArticleInfos = record
    COU_ID,
    TGF_ID : Integer;
    COU_NOM,
    TGF_NOM : String;
  end;

  TSDUpdateCommun = Class(TMainClass)
  private
    FCatalogList ,
    FModelList   ,
    FModelRecDateList ,
    FColorList   ,
    FItemList    ,
    FEanList     ,
    FTARCLGFOUNR    ,
    FTARPRIXVENTE   ,
    FTARVALID       ,
    FTAILLETRAV     ,
    FCOULEUR        ,
    FARTFUSIONLIGNE : TMainClass;

    FMode: TUpdateMode;

    FDs_CatalogList ,
    FDs_ModelList   ,
    FDs_ModelRecDate ,
    FDs_ColorList   ,
    FDs_ItemList    : TDataSource;

    function GetModeleInfos(AMODEL, ABrand, ASizeRange : string; AModelType : Integer) : TArtArticle;
    function GetArticleInfos(AModele : TArtArticle; ACOLORNUMBER, ACOLUMNX, AEAN : string) : TArticleInfos;
    // Fonction de gestion des prrix recommandés à date
    function SetTarPreco(ATPO_ARTID : Integer; ATPO_DT : TDate; ATPO_PX : Currency; ATPO_ETAT, ATPO_COLID : Integer) : Integer;
    function UpdTarPreco(ATPO_ID : Integer; ATPO_DT : TDate; ATPO_PX : Currency; ATPO_ETAT, ATPO_COLID : Integer) : Integer;

    function CleanOldTPO(TPO_ID, TPO_ARTID,TPO_COLID : Integer; TPO_DT : TDate) : Integer;

    function DoGetTarifVente(AModele : TArtArticle) : Boolean;
    function DoGetTarifPrecoSpe(ATPO_ID : Integer) : Boolean;
    function DoGetArtFusion(AModele : TArtArticle) : Boolean;

    // Fonction de gestion des tarifs Préco
    function DoTarifPreco(AArticle : TArtArticle; ATGF_ID, ACOU_ID, ATPO_ID : Integer) : Boolean;
    // fonction qui génère les prix de vente des articles
    function SetArtPrixVente(PVT_ARTID,PVT_TGFID, PVT_COUID, PVT_TVTID : Integer;PVT_PX : single;PVT_CENTRALE : Integer) : Integer;
    // fonctions de gestion des prix spécifique recommandé (TARVALID)
    function SetTarValid(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID, ATVD_TGFID, ATVD_COUID : Integer; ATVD_PX : Currency; ATVD_DT : TDate; ATVD_ETAT : Integer) : Integer;
    function UpdTarValid(ATVD_ID : Integer; ATVD_DT : TDate; ATVD_PX : Currency) : Integer;
    function SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,
      ACBI_TYPE: Integer; ACBI_CB: String): Integer;
    function GetCollectionID(ACOL_CODE : String) : Integer;
    function CheckTarPreco(AModele : TArtArticle; AMontant : Currency; ADate : TDate) : Boolean;
  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;
    function ClearIdField : Boolean;override;





    Constructor Create;override;
    destructor destroy;override;
  published
  End;

implementation

{ TSDUpdateCommun }



function TSDUpdateCommun.CheckTarPreco(AModele: TArtArticle;
  AMontant: Currency; ADate : TDate): Boolean;
begin
  Result := False;
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.add('SELECT TPO_DT, TPO_ID, TPO_PX FROM TARPRECO');
    SQL.Add('JOIN K ON K_ID = TPO_ID AND K_Enabled = 1');
    SQL.Add('WHERE TPO_ARTID = :PTPOARTID');
    SQL.Add(' AND TPO_DT <= :PTPODT');
    SQL.Add(' AND TPO_ETAT = 0');
    SQL.Add('ORDER BY TPO_DT DESC');
    ParamCheck := true;
    ParamByName('PTPOARTID').AsInteger := AModele.ART_ID;
    ParamByName('PTPODT').AsDate := ADate;
    Open;
    First;
    if RecordCount > 0 then
    begin 
      Result := (CompareValue(AMontant,FieldbyName('TPO_PX').AsCurrency,0.001) <> EqualsValue);
    end;
  end;
end;

function TSDUpdateCommun.ClearIdField: Boolean;
begin

end;

constructor TSDUpdateCommun.Create;
begin
  inherited Create;
  FCatalogList := TMainClass.Create;
  FCatalogList.Title := 'CatalogList';
  FModelList   := TMainClass.Create;
  FModelList.Title := 'ModelList';
  FModelRecDateList := TMainClass.Create;
  FModelRecDateList.Title := 'ModelRecDate';
  FColorList   := TMainClass.Create;
  FColorList.Title := 'ColorList';
  FItemList    := TMainClass.Create;
  FItemList.Title := 'ItemList';
  FEanList := TMainClass.Create;
  FEanList.Title := 'EanList';
  FTARPRIXVENTE   := TMainClass.Create;
  FTARVALID       := TMainClass.Create;
  FCOULEUR        := TMainClass.Create;
  FARTFUSIONLIGNE := TMainClass.Create;

  FDs_CatalogList := TDataSource.Create(nil);
  FDs_CatalogList.DataSet := FCatalogList.ClientDataSet;

  FDs_ModelList := TDataSource.Create(nil);
  FDs_ModelList.DataSet := FModelList.ClientDataSet;

  FDs_ModelRecDate := TDataSource.Create(nil);
  FDs_ModelRecDate.DataSet := FModelRecDateList.ClientDataSet;

  FDs_ColorList := TDataSource.Create(nil);
  FDs_ColorList.DataSet := FColorList.ClientDataSet;

  FDs_ItemList := TDataSource.Create(nil);
  FDs_ItemList.DataSet := FItemList.ClientDataSet;
end;

destructor TSDUpdateCommun.destroy;
begin
  FCatalogList.Free;
  FModelList.Free;
  FModelRecDateList.Free;
  FColorList.Free;
  FItemList.Free;
  FEanList.Free;
  FTARPRIXVENTE.Free;
  FTARVALID.Free;
  FCOULEUR.Free;
  FARTFUSIONLIGNE.Free;

  FDs_CatalogList.Free;
  FDs_ModelList.Free;
  FDs_ModelRecDate.Free;
  FDs_ColorList.Free;
  FDs_ItemList.Free;

end;

function TSDUpdateCommun.DoGetArtFusion(AModele: TArtArticle): Boolean;
begin
  Result := False;
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from ARTFUSIONLIGNE');
    SQL.Add('  Join K on K_ID = AFL_ID and K_enabled = 1');
    SQL.Add('Where AFL_OLDARTID = :POLDARTID');
    SQL.Add('  and AFL_NEWARTID = :PNEWARTID');
    ParamCheck := True;
    ParamByName('POLDARTID').AsInteger := AModele.ART_ID;
    ParamByName('PNEWARTID').AsInteger := AModele.ART_FUSARTID;
    Open;

    FARTFUSIONLIGNE.ClientDataSet.EmptyDataSet;
    while not EOF do
    begin
      FARTFUSIONLIGNE.Append;
      FARTFUSIONLIGNE.FieldByName('AFL_AFEID').AsInteger := FieldByName('AFL_AFEID').AsInteger;
      FARTFUSIONLIGNE.FieldByName('AFL_OLDTGFID').AsInteger := FieldByName('AFL_OLDTGFID').AsInteger;
      FARTFUSIONLIGNE.FieldByName('AFL_OLDCOUID').AsInteger := FieldByName('AFL_OLDCOUID').AsInteger;
      FARTFUSIONLIGNE.FieldByName('AFL_NEWARTID').AsInteger := FieldByName('AFL_NEWARTID').AsInteger;
      FARTFUSIONLIGNE.FieldByName('AFL_NEWTGFID').AsInteger := FieldByName('AFL_NEWTGFID').AsInteger;
      FARTFUSIONLIGNE.FieldByName('AFL_NEWCOUID').AsInteger := FieldByName('AFL_NEWCOUID').AsInteger;
      FARTFUSIONLIGNE.Post;
      Next;
    end;

  Except on E:Exception do
    raise Exception.Create('DoGetTarifPrecoSpe -> ' + E.Message);
  end;
end;

function TSDUpdateCommun.DoGetTarifPrecoSpe(ATPO_ID: Integer): Boolean;
begin
  Result := False;
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select TVD_ID, TVD_ARTID, TVD_TGFID, TGF_COLUMNX, TVD_COUID, COU_CODE, TVD_PX, TVD_DT, TVD_ETAT,TVD_TVTID from TARVALID');
    SQL.Add('  join K on K_ID = TVD_ID and K_Enabled = 1');
    SQL.Add('  join PLXTAILLESGF on TGF_ID = TVD_TGFID');
    SQL.Add('  join PLXCOULEUR on COU_ID = TVD_COUID');
    SQL.Add('Where TVD_TPOID = :PTPOID');
    SQL.Add('  and TVD_TVTID = 0');
    ParamCheck := True;
    ParamByName('PTPOID').AsInteger := ATPO_ID;
    Open;

    FTARVALID.ClientDataSet.EmptyDataSet;
    while not EOF do
    begin
      FTARVALID.Append;
      FTARVALID.FieldByName('TVD_ID').AsInteger := FieldByName('TVD_ID').AsInteger;
      FTARVALID.FieldByName('TVD_TVTID').AsInteger := FieldByName('TVD_TVTID').AsInteger;
      FTARVALID.FieldByName('TVD_TGFID').AsInteger := FieldByName('TVD_TGFID').AsInteger;
      FTARVALID.FieldByName('TVD_COUID').AsInteger := FieldByName('TVD_COUID').AsInteger;
      FTARVALID.FieldByName('TVD_DT').AsDateTime := FieldByName('TVD_DT').AsDateTime;
      FTARVALID.FieldByName('TVD_PX').AsCurrency := FieldByName('TVD_PX').AsCurrency;
      FTARVALID.FieldByName('TVD_ETAT').AsInteger := FieldByName('TVD_ETAT').AsInteger;
      FTARVALID.FieldByName('TGF_COLUMNX').AsString := FieldByName('TGF_COLUMNX').AsString;
      FTARVALID.FieldByName('COU_CODE').AsString := FieldByName('COU_CODE').AsString;
      FTARVALID.FieldByName('TRAITER').AsInteger := 0;
      FTARVALID.Post;

      Next;
    end;
    Result := True;

  Except on E:Exception do
    raise Exception.Create('DoGetTarifPrecoSpe -> ' + E.Message);
  end;

end;

function TSDUpdateCommun.DoGetTarifVente(AModele: TArtArticle): Boolean;
begin
  Result := False;
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select PVT_ID, PVT_TGFID, TGF_COLUMNX, PVT_COUID, COU_CODE, PVT_TVTID, PVT_PX from TARPRIXVENTE');
    SQL.Add('  Join K on K_ID = PVT_ID and K_Enabled = 1');
    SQL.Add('  Join PLXTAILLESGF on TGF_ID = PVT_TGFID');
    SQL.Add('  Join PLXCOULEUR on COU_ID = PVT_COUID');
    SQL.Add('Where PVT_ARTID = :PARTID');
    SQL.Add('  And PVT_TVTID = 0');
    ParamCheck := True;
    if AModele.ART_FUSARTID = 0 then
      ParamByName('PARTID').AsInteger := AModele.ART_ID
    else
      ParamByName('PARTID').AsInteger := AModele.ART_FUSARTID;
    Open;

    FTARPRIXVENTE.ClientDataSet.EmptyDataSet;
    while not EOF do
    begin
      FTARPRIXVENTE.Append;
      FTARPRIXVENTE.FieldByName('PVT_ID').AsInteger := FieldByName('PVT_ID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := FieldByName('PVT_TVTID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := FieldByName('PVT_TGFID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := FieldByName('PVT_COUID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := FieldByName('PVT_PX').AsCurrency;
      FTARPRIXVENTE.FieldByName('TGF_COLUMNX').AsString := FieldByName('TGF_COLUMNX').AsString;
      FTARPRIXVENTE.FieldByName('COU_CODE').AsString := FieldByName('COU_CODE').AsString;
      FTARPRIXVENTE.Post;
      Next;
    end;
  Except on E:Exception do
    raise Exception.Create('DoGetTarifVente -> ' + E.Message);
  end;

end;

function TSDUpdateCommun.DoMajTable(ADoMaj: Boolean): Boolean;
var
  Modele, ModeleFus : TArtArticle;
  Article : TArticleInfos;

  TPO_ID, TPO_ETAT : Integer;
  TPO_FOUND : Boolean;
  TPO_DT : TDate;
  TPO_PX : Currency;

  DoCreateTpo, DoUpdateTpo, DoCreateLigne, DoUpdateLigne, DoCleanTPOCOL, DoCreateLigneOne : Boolean;
  bFound : Boolean;
  BookColor, BookItem : TBookmark;
begin
  Inherited DoMajTable(ADoMaj);

  if not FModelList.ClientDataSet.Active then
    Exit;

  FModelList.First;
  while not FModelList.EOF do
  begin
    try
      if not FIboQuery.IB_Transaction.InTransaction then
        FIboQuery.IB_Transaction.StartTransaction;

      if CompareDateTime(FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,StrToDate('30/12/1899')) = EqualsValue then
        raise Exception.Create(Format('%s%s - Sizerange : %s -> Date du prix recommandé vide',[FModelList.FieldByName('MODELNUMBER').AsString,
                       FModelList.FieldByName('BRANDNUMBER').AsString,
                       FModelList.FieldByName('SIZERANGE').AsString]));

      if CompareDate(Filedate,FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime) in [GreaterThanValue,EqualsValue] then
        raise Exception.Create(Format('%s%s - Sizerange : %s -> Date inférieure à la date du fichier',[FModelList.FieldByName('MODELNUMBER').AsString,
                       FModelList.FieldByName('BRANDNUMBER').AsString,
                       FModelList.FieldByName('SIZERANGE').AsString]));

      {$REGION 'Est ce que le model existe ?'}
      Try
        if CompareValue(FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0, 0.001) = EqualsValue  then
          raise Exception.Create('Montant recommandé à 0');

        Modele := GetModeleInfos(
                     FModelList.FieldByName('MODELNUMBER').AsString,
                     FModelList.FieldByName('BRANDNUMBER').AsString,
                     FModelList.FieldByName('SIZERANGE').AsString,
                     FModelList.FieldByName('MODELTYPE').AsInteger);

        Modele.COL_ID := GetCollectionID(FModelList.FieldByName('CODECOLL').AsString);

      Except
        on E:EERRORANDCANCEL do
          begin
            raise EERRORANDCANCEL.Create(Format('Erreur -> Code: %s%s - SizeRange : %s - %s',
                      [FModelList.FieldByName('MODELNUMBER').AsString,
                       FModelList.FieldByName('BRANDNUMBER').AsString,
                       FModelList.FieldByName('SIZERANGE').AsString,
                       E.Message]));
          end;
        on ENOTFIND do
          begin
            // Le model n'a pas été trouvé on passe au suivant
            if IniStruct.LogSdUpdate then
              FErrLogs.Add(Format('Code: %s%s - SizeRange :%s - Modèle non présent',
                                [FModelList.FieldByName('MODELNUMBER').AsString,
                                 FModelList.FieldByName('BRANDNUMBER').AsString,
                                 FModelList.FieldByName('SIZERANGE').AsString]));
            FIboQuery.IB_Transaction.Rollback;
            FModelList.Next;
            Continue;
            end;
        on E:Exception do
          begin
            raise EERRORANDCANCEL.Create(Format('Erreur -> Code: %s%s - SizeRange : %s - %s',
                                [FModelList.FieldByName('MODELNUMBER').AsString,
                                 FModelList.FieldByName('BRANDNUMBER').AsString,
                                 FModelList.FieldByName('SIZERANGE').AsString,
                                 E.MEssage]));
          end;
      End;
      {$ENDREGION}

      // Premier passage pour détecter les SKU en base
      FColorList.First;
      while not FColorList.EOF do
      begin
        FItemList.First;
        while not FItemList.EOF do
        begin
          // Est ce que l'article existe ?
          Try
            if CompareValue(FItemList.FieldByName('RETAILPRICE').AsCurrency, 0, 0.001) = EqualsValue then
              raise Exception.Create('Montant de l''article est à 0');

            Article := GetArticleInfos(
                         Modele,
                         FColorList.FieldByName('COLORNUMBER').AsString,
                         FItemList.FieldByName('COLUMNX').AsString,
                         FItemList.FieldByName('EAN').AsString);

            FItemList.ClientDataSet.Edit;
            FItemList.FieldByName('ART_ID').AsInteger := Modele.ART_ID;
            FItemList.FieldByName('COU_ID').AsInteger := Article.COU_ID;
            FItemList.FieldByName('TGF_ID').AsInteger := Article.TGF_ID;
            FItemList.FieldByName('OnError').AsInteger := 0;
            FItemList.Post;

          Except
            on ENOTFIND do
              begin
                FItemList.ClientDataSet.Edit;
                FItemList.FieldByName('OnError').AsInteger := 1;
                FItemList.Post;
                if IniStruct.LogSdUpdate then
                  FErrLogs.Add(Format('Code: %s%s - SizeRange :%s - Couleur : %s/%s - Taille : %s/%s - EAN : %s - Article non présent',
                                    [FModelList.FieldByName('MODELNUMBER').AsString,
                                     FModelList.FieldByName('BRANDNUMBER').AsString,
                                     FModelList.FieldByName('SIZERANGE').AsString,
                                     FColorList.FieldByName('COLORNUMBER').AsString,
                                     FColorList.FieldbyName('COLORDENOTATION').AsString,
                                     FItemList.FieldByName('COLUMNX').AsString,
                                     FItemList.FieldByName('SIZELABEL').AsString,
                                     FItemList.FieldByName('EAN').AsString]));

              end;
            on E:Exception do
              begin
                FItemList.ClientDataSet.Edit;
                FItemList.FieldByName('OnError').AsInteger := 1;
                FItemList.Post;

                raise EERRORANDCANCEL.Create(Format('Code: %s%s - SizeRange :%s - Couleur : %s/%s - Taille : %s/%s - EAN : %s - %s',
                                    [FModelList.FieldByName('MODELNUMBER').AsString,
                                     FModelList.FieldByName('BRANDNUMBER').AsString,
                                     FModelList.FieldByName('SIZERANGE').AsString,
                                     FColorList.FieldByName('COLORNUMBER').AsString,
                                     FColorList.FieldbyName('COLORDENOTATION').AsString,
                                     FItemList.FieldByName('COLUMNX').AsString,
                                     FItemList.FieldByName('SIZELABEL').AsString,
                                     FItemList.FieldByName('EAN').AsString,
                                     E.Message]));
              end;
          End;

          FItemList.Next;
        end;
        FColorList.Next;
      end;


      FColorList.First;
      TPO_FOUND := False;
      DoCreateTpo := False;
      DoUpdateTpo := False;
      DoCreateLigne := False;
      DoUpdateLigne := False;
      DoCleanTPOCOL := False;

      // 2em passage pour intégration
      while not FColorList.EOF do
      begin
        FItemList.First;
        while not FItemList.EOF do
        begin
          if FItemList.FieldByName('OnError').AsInteger = 0 then
          begin

            if not TPO_FOUND then
            begin
              // Est ce que le modèle est un modèle fusionné ?
//UNICOUL
              if Modele.ART_FUSARTID <> 0 then
//              if Modele.ART_FUSARTID > 0 then
                DoGetArtFusion(Modele);

              {$REGION 'Récupération du dernier prix recommandé du modèle'}
              With FIboQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT * from TARPRECO');
                SQL.Add('  join K on K_ID = TPO_ID and K_Enabled = 1');
                SQL.Add('Where TPO_ARTID = :PTPOARTID');
                SQL.Add('  and TPO_DT <= :PTPODT');
                SQL.Add('  and TPO_DT > CURRENT_DATE');
                SQL.Add('ORDER BY TPO_DT DESC');
                SQL.Add('ROWS 1');
                ParamCheck := True;
//UNICOUL
                if Modele.ART_FUSARTID <> 0 then
//                if Modele.ART_FUSARTID > 0 then
                  ParamByName('PTPOARTID').AsInteger := Modele.ART_FUSARTID
                else
                  ParamByName('PTPOARTID').AsInteger := Modele.ART_ID;
                ParamByName('PTPODT').AsDate := FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime;
                Open;

                if RecordCount > 0 then
                begin
                  TPO_FOUND := True;
                  TPO_ID    := FieldByName('TPO_ID').AsInteger;
                  TPO_DT    := FieldByName('TPO_DT').AsDateTime;
                  TPO_PX    := FieldByName('TPO_PX').AsCurrency;
                  TPO_ETAT  := FieldByName('TPO_ETAT').AsInteger;
                end;
              end;
              {$ENDREGION}

              if not TPO_FOUND then
              begin
                // -- Pas de prix préconisé trouvé
                TPO_FOUND := True; // Pour que le logiciel n'y passe qu'une fois par modèle

                // Récupération des prix de vente du modèle.
                DoGetTarifVente(Modele);

                // Est-ce que les SKU ont un tarif <> de celui du modèle ?
                if FModelList.FieldByName('IsDiff').AsInteger = 0 then
                begin
                  // -- Pas de différence
                  // Est-ce que le prix préconisé est identique au tarif général du modèle ?
                  if FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
                  begin
                    if CompareValue(FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency,FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency, 0.001) <> EqualsValue then
                    begin
                      // Point 3 dans l'orgranigramme
                      DoCreateTpo := True;
                      DoCreateLigne := False;
                      DoCleanTPOCOL := True;

                      DoUpdateTpo := False;
                      DoUpdateLigne := False;

                    end
                    else begin
                      // Point 4 Dans l'organigramme
                      DoCreateTpo := False;
                      DoCreateLigne := False;
                      DoCleanTPOCOL := True;

                      DoUpdateTpo := False;
                      DoUpdateLigne := False;
                    end;
                  end
                  else
                    raise Exception.Create('Le modèle n''a pas de prix de vente général');
                end
                else begin
                  // -- Le prix du modèle et des SKU sont différents

                  // Vérification si au moins un des éléments est différents des prix de vente
                  if FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
                  begin
                    // est ce que le prix du modèle est différent du tarif général ?
                    if CompareValue(FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency,FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency, 0.001) <> EqualsValue then
                    begin
                      // -- Oui, donc création Point 2 Orgranigramme
                      DoCreateTpo := True;
                      DoCreateLigne := True;
                      DoCleanTPOCOL := True;

                      DoUpdateTpo := False;
                      DoUpdateLigne := False;

                    end
                    else begin
                      // Vérification si il y a au moins un SKU qui est différent des tarifs de vente.
                      bFound := False;
                      BookColor := FColorList.ClientDataSet.GetBookmark;
                      BookItem := FItemList.ClientDataSet.GetBookmark;
                      try
                        while not bFound and not FColorList.EOF do
                        begin
                          while not FItemList.EOF and not bFound do
                          begin
                            if FItemList.FieldByName('OnError').AsInteger = 0 then
                            begin
                              // Vérification s'il y a au moins un SKU préco <> du SKU vente
                              if FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([FItemList.FieldByName('TGF_ID').AsInteger,FColorList.FieldByName('COU_ID').AsInteger,0]),[loCaseInsensitive]) then
                              begin
                                if CompareValue(FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency,FItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue then
                                  bFound := True;
                              end
                              else begin
                                if FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
                                  if CompareValue(FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency,FItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue then
                                    bFound := True;
                              end;
                            end;

                            FItemList.Next;
                          end;
                          FColorList.Next;
                        end;
                      finally
                        FColorList.ClientDataSet.GotoBookmark(BookColor);
                        FItemList.ClientDataSet.GotoBookmark(BookItem);
                      end;

                      if bFound then
                      begin
                        // Point 2 organigramme
                        DoCreateTpo := True;
                        DoCreateLigne := (FModelList.FieldByName('IsDiff').AsInteger = 1);
                        DoCleanTPOCOL := True;

                        DoUpdateTpo := False;
                        DoUpdateLigne := False;
                      end
                      else begin
                        // Point 1 organigramme
                        DoCreateTpo := False;
                        DoCreateLigne := False;
                        DoCleanTPOCOL := True;

                        DoUpdateTpo := False;
                        DoUpdateLigne := False;
                      end;
                    end;
                  end
                  else
                    raise Exception.Create('Le modèle n''a pas de prix de vente général');
                end;
              end
              else begin
                // -- Prix préconisé trouvé
                TPO_FOUND := True; // Pour que le logiciel n'y passe qu'une fois par modèle

                // Vérification s'il y a des ecarts entre les deux prix préco
                bFound := False;
                // Est ce que les montants de base sont différents ?
                if CompareValue(TPO_PX,FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0.001) <> EqualsValue then
                  bFound := true;

                if not bFound then
                begin
                  // Récupératon des SKU du Prix Préco en base (TARVALID)
                  DoGetTarifPrecoSpe(TPO_ID);

                  BookColor := FColorList.ClientDataSet.GetBookmark;
                  BookItem := FItemList.ClientDataSet.GetBookmark;
                  try
                    while not bFound and not FColorList.EOF do
                    begin
                      while not bFound and not FItemList.EOF do
                      begin
                        // On ne traite que les items sans erreur
                        if FItemList.FieldByName('OnError').AsInteger = 0 then
                        begin
                          if FTARVALID.ClientDataSet.Locate('TGF_COLUMNX;COU_CODE',VarArrayOf([FItemList.FieldByName('COLUMNX').AsString,FColorList.FieldByName('COLORNUMBER').AsString]),[loCaseInsensitive]) then
                          begin
                            if CompareValue(FTARVALID.FieldByName('TVD_PX').AsCurrency,FItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue then
                              bFound := True;
                          end;
                        end;

                        FItemList.Next;
                      end;
                      FColorList.Next;
                    end;
                  finally
                    FColorList.ClientDataSet.GotoBookmark(BookColor);
                    FItemList.ClientDataSet.GotoBookmark(BookItem);
                  end;
                end;

                if bFound then
                begin
                  // -- Au moins une différence a été trouvé

                  // est ce que les dates sont différentes ?
                  if CompareDate(TPO_DT,FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime) <> EqualsValue then
                  begin
                    // Point 8 Orgranigramme
                    DoCreateTpo := True;

                    DoCreateLigne := (FModelList.FieldByName('IsDiff').AsInteger = 1);
                    DoCleanTPOCOL := True;

                    DoUpdateTpo := False;
                    DoUpdateLigne := False;
                  end
                  else begin
                    // Point 7 Orgranigramme
                    DoCreateTpo := False;
                    DoCreateLigne := False;
                    DoCleanTPOCOL := True;

                    DoUpdateTpo := True;
                    DoUpdateLigne := True;
                  end;
                end
                else begin
                  // -- Pas de différence
                  case TPO_ETAT of
                    2: begin // Ne plus proposer
                      // Point 6 Organigramme
                      DoCreateTpo := False;
                      DoCreateLigne := False; //(FModelList.FieldByName('IsDiff').AsInteger = 1);
                      DoCleanTPOCOL := True;

                      DoUpdateTpo := False;
                      DoUpdateLigne := False;
                    end;
                    else begin
                      // Point 5 Organigramme
                      DoCreateTpo := False;
                      DoCreateLigne := False;
                      DoCleanTPOCOL := True;

                      DoUpdateTpo := False;
                      DoUpdateLigne := False;
                    end;
                  end; // case
                end;  // if
              end;
            end;

            {$REGION 'Gestion des prix recommandé'}
            // Vérification de l'existance du prix recommandé (TARPRECO) et création si nécessaire
            if DoCreateTpo then
            begin
              DoCreateTpo := False; // on ne fait qu'une fois la création
              if Modele.ART_FUSARTID = 0 then
                TPO_ID := SetTarPreco(Modele.ART_ID,
                                      FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,
                                      FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,
                                      0,
                                      Modele.COL_ID)
              else
                TPO_ID := SetTarPreco(Modele.ART_FUSARTID,
                                      FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,
                                      FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,
                                      0,
                                      Modele.COL_ID);
            end;

            if DoUpdateTpo then
            begin
              DoUpdateTpo := False; // On ne fait qu'une fois la mise à jour
              UpdTarPreco(TPO_ID,
                            FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,
                            FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,
                            0,
                            Modele.COL_ID)
            end;

            if DoUpdateLigne then
            begin
             if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID',VarArrayOf([FItemList.FieldByName('TGF_ID').AsInteger,FItemList.FieldByName('COU_ID').AsInteger]),[]) then
             begin
               UpdTarValid(FTARVALID.FieldByName('TVD_ID').AsInteger, FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime, FItemList.FieldByName('RETAILPRICE').AsCurrency);

               FTARVALID.ClientDataSet.Edit;
               FTARVALID.FieldByName('TRAITER').AsInteger := 1;
               FTARVALID.Post;
             end
             else
               DoCreateLigneOne := True;
            end;

            // Mise à jour des prix préco.
            if DoCreateLigne or DoCreateLigneOne then
            begin
              DoCreateLigneOne := False; // Dans le cas où l'on est en mise à jour de ligne et qu'on doit créer un nouvelle ligne.
              if Modele.ART_FUSARTID = 0 then
                SetTarValid(TPO_ID,
                            0,
                            Modele.ART_ID,
                            FItemList.FieldByName('TGF_ID').AsInteger,
                            FItemList.FieldByName('COU_ID').AsInteger,
                            FItemList.FieldByName('RETAILPRICE').AsCurrency,
                            FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,
                            0)
              else begin
                if FARTFUSIONLIGNE.ClientDataSet.Locate('AFL_OLDTGFID;AFL_OLDCOUID',VarArrayOf([FItemList.FieldByName('TGF_ID').AsInteger,FItemList.FieldByName('COU_ID').AsInteger]),[]) then
                begin
                SetTarValid(TPO_ID,
                            0,
                            Modele.ART_FUSARTID,
                            FARTFUSIONLIGNE.FieldByName('AFL_NEWTGFID').AsInteger,
                            FARTFUSIONLIGNE.FieldByName('AFL_NEWCOUID').AsInteger,
                            FItemList.FieldByName('RETAILPRICE').AsCurrency,
                            FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,
                            0);
                end
                else
                  raise Exception.Create('Article fusionné, pas de correspondance trouvé');
              end;
            end;

            {$ENDREGION}

//UNICOUL
            {$REGION 'Gestion des codes à barres EAN'}
            if FItemList.FieldByName('EAN').AsString <> '' then
            begin
              SetARTCodeBarre(Modele.ARF_ID,
                              FItemList.FieldByName('TGF_ID').AsInteger,
                              FItemList.FieldByName('COU_ID').AsInteger,3,
                              FItemList.FieldByName('EAN').AsString);
            end;

            while not FEanList.Eof do
            begin
               if Trim(FEanList.FieldByName('EANLIST').AsString) <> '' then
               begin
                 SetARTCodeBarre(Modele.ARF_ID,
                                 FItemList.FieldByName('TGF_ID').AsInteger,
                                 FItemList.FieldByName('COU_ID').AsInteger,3,
                                 FEanList.FieldByName('EANLIST').AsString);
               end;
               FEanList.Next;
            end;
            {$ENDREGION}
//

          end;

          FItemList.Next;
        end; // while item

        FColorList.Next;
      end; // while colot

      if DoUpdateLigne then
      begin
        // Suppression des lignes qui n'ont pas été traité lors de la mise à jour des lignes
        FTARVALID.First;
        With FIboQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PTVDID,1)');
          ParamCheck := True;
          while not FTARVALID.EOF do
          begin
            if FTARVALID.FieldByName('TRAITER').AsInteger = 0 then
            begin
              Close;
              ParamByName('PTVDID').AsInteger := FTARVALID.FieldByName('TVD_ID').AsInteger;
              ExecSQL;

              Inc(FMajCount);
            end;
            FTARVALID.Next;
          end;
        end;
      end;

      if DoCleanTPOCOL then
      begin
        CleanOldTPO(TPO_ID,Modele.ART_ID,Modele.COL_ID,FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime);
      end;

      FIboQuery.IB_Transaction.Commit;
    except
      on E:EERRORANDCANCEL do
      begin
        FIboQuery.IB_Transaction.Rollback;
        FErrLogs.Add(E.Message);
      end;
      on E:Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;
        FErrLogs.Add(E.Message);
      end;
    end;
    FModelList.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FModelList.ClientDataSet.RecNo * 100 Div FModelList.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end; // while model

  // valide la derniere transaction
  if FIboQuery.IB_Transaction.InTransaction then
      FIboQuery.IB_Transaction.Commit;

end;

function TSDUpdateCommun.DoTarifPreco(AArticle: TArtArticle; ATGF_ID, ACOU_ID,
  ATPO_ID: Integer): Boolean;
Var
  bContinue : Boolean;
  cRecommendedPriceBase, cVentePrixBaseActuel : Currency;
  LocalTVT_ID, TVD_ID : Integer;
  bVerifTarifVte : Boolean;
begin
  try
    bVerifTarifVte := False;
    // Récupération du tarif recommandé à date comme prix de base
    cRecommendedPriceBase := FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency;

    // Y a-t-il un tarif de base pour le tarif général ?
    if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
        raise Exception.Create('Le modèle n''a pas de prix de vente de base');
    cVentePrixBaseActuel := FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency;

      // Est ce que le tarif du modèle <> du tarif de l'article ?
    if CompareValue(cRecommendedPriceBase,FItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue then
    begin // Oui Tarif différent

      // Y a-t-il un tarif PR spécifique déja existant ?
      if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID;TVD_TVTID',VarArrayOf([ATGF_ID,ACOU_ID,0]),[]) then
      begin
        {$REGION 'Oui donc Mise à jour du spécifique'}
        UpdTarValid(
                     FTARVALID.FieldByName('TVD_ID').AsInteger,      //  ATVD_ID: Integer;
                     FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,  //  ATVD_DT: TDate;
                     FItemList.FieldByName('RETAILPRICE').AsCurrency //  ATVD_PX: Currency
                   );

        FTARVALID.ClientDataSet.Edit;
        FTARVALID.FieldByName('TVD_ID').AsInteger := TVD_ID;
        FTARVALID.FieldByName('TVD_DT').AsDateTime := FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime;
        FTARVALID.FieldByName('TVD_PX').AsCurrency := FItemList.FieldByName('RETAILPRICE').AsCurrency;
        FTARVALID.Post;
        {$ENDREGION}
      end
      else begin
        {$REGION 'Non pas de tarif PR Spécifique donc création'}
        TVD_ID := SetTarValid(
                     ATPO_ID,                                              // ATVD_TPOID,
                     0,                                                    // ATVD_TVTID,
                     AArticle.ART_ID,                                      // ATVD_ARTID,
                     ATGF_ID,                                              // ATVD_TGFID,
                     ACOU_ID,                                              // ATVD_COUID : Integer;
                     FItemList.FieldByName('RETAILPRICE').AsCurrency,      // ATVD_PX : Currency;
                     FItemList.FieldByName('VALIDFROM').AsDateTime,        // ATVD_DT : TDate;
                     0                                                     // ATVD_ETAT : Integer
                   );

        FTARVALID.Append;
        FTARVALID.FieldByName('TVD_ID').AsInteger := TVD_ID;
        FTARVALID.FieldByName('TVD_TVTID').AsInteger := 0;
        FTARVALID.FieldByName('TVD_COUID').AsInteger := ACOU_ID;
        FTARVALID.FieldByName('TVD_TGFID').AsInteger := ATGF_ID;
        FTARVALID.FieldByName('TVD_DT').AsDateTime := FItemList.FieldByName('VALIDFROM').AsDateTime;
        FTARVALID.FieldByName('TVD_PX').AsCurrency := FItemList.FieldByName('RETAILPRICE').AsCurrency;
        FTARVALID.FieldByName('TVD_ETAT').AsInteger := 0;
        FTARVALID.Post;
        {$ENDREGION}
      end;
      // Active la création d'un tarif de vente spécifique s'il n'existe pas
      bVerifTarifVte := True;
    end
    else begin // Non le montant est identique.
      // y a-t-il un PR spécifique qui existe déjà ?
      if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID;TVD_TVTID',VarArrayOf([ATGF_ID,ACOU_ID,0]),[])  then
      begin
        // Oui, Est ce que les dates sont différentes ?
        case CompareDateTime(FTARVALID.FieldByName('TVD_DT').AsDateTime, FItemList.FieldByName('VALIDFROM').AsDateTime) of
          GreaterThanValue: begin
            {$REGION 'Mise à jour de la date car VALIDFROM est avant TVD_DT'}
            UpdTarValid(
                         FTARVALID.FieldByName('TVD_ID').AsInteger,      //  ATVD_ID: Integer;
                         FItemList.FieldByName('VALIDFROM').AsDateTime,  //  ATVD_DT: TDate;
                         FItemList.FieldByName('RETAILPRICE').AsCurrency //  ATVD_PX: Currency
                       );

            FTARVALID.ClientDataSet.Edit;
            FTARVALID.FieldByName('TVD_ID').AsInteger := TVD_ID;
            FTARVALID.FieldByName('TVD_DT').AsDateTime := FItemList.FieldByName('VALIDFROM').AsDateTime;
            FTARVALID.FieldByName('TVD_PX').AsCurrency := FItemList.FieldByName('RETAILPRICE').AsCurrency;
            FTARVALID.Post;
            {$ENDREGION}
             bVerifTarifVte := True;
          end;
          else begin
            // est ce que les tarifs sont différent ?
            if (CompareValue(FTARVALID.FieldByName('TVD_PX').AsCurrency, FItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue) or
               (FTARVALID.FieldByName('TVD_ETAT').AsInteger = 2)  then
            begin
              UpdTarValid(
                           FTARVALID.FieldByName('TVD_ID').AsInteger,      //  ATVD_ID: Integer;
                           FTARVALID.FieldByName('TVD_DT').AsDateTime,  //  ATVD_DT: TDate;  // date inférieure mais changement de tarif donc on change juste le tarif
                           FItemList.FieldByName('RETAILPRICE').AsCurrency //  ATVD_PX: Currency
                         );

              FTARVALID.ClientDataSet.Edit;
              FTARVALID.FieldByName('TVD_ID').AsInteger := TVD_ID;
              FTARVALID.FieldByName('TVD_PX').AsCurrency := FItemList.FieldByName('RETAILPRICE').AsCurrency;
              FTARVALID.Post;

            end;
          end;
        end;
      end;
    end;

    {$REGION 'Est-ce qu''il exite un tarif spécifique pour le prix de vente du modèle ?'}
    if bVerifTarifVte then
      if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([ATGF_ID,ACOU_ID,0]),[]) then
      begin
        // Pas de spécifique existant, pour éviter les problèmes de réplication on crée un prix de vente pour l'article
        // Et on met son prix à celui du prix de base du modèle.
        SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID, 0, cVentePrixBaseActuel,1);

        // Ajout au CSD (Dans le cas où il y est deux fois le même article dans les fichiers)
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
        FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cVentePrixBaseActuel;
        FTARPRIXVENTE.Post;
      end;
    {$ENDREGION}
  Except on E:Exception do
    raise Exception.Create('DoTarifVente -> ' + E.Message);
  end;
end;

function TSDUpdateCommun.GetArticleInfos(AModele: TArtArticle; ACOLORNUMBER,
  ACOLUMNX, AEAN: string): TArticleInfos;
begin
  With FIboQuery do
  begin
  try
      Close;
      SQL.Clear;
      SQL.Add('Select COU_ID, COU_NOM, TGF_ID, TGF_NOM');
      SQL.Add(' From ARTCODEBARRE join K on K_ID = CBI_ID and K_Enabled = 1');
      SQL.Add(' Join PLXCOULEUR on CBI_COUID = COU_ID');
      SQL.Add(' join PLXTAILLESGF on CBI_TGFID = TGF_ID');
      SQL.Add('Where CBI_ARFID = :PCBIARFID');
      SQL.Add('  and COU_CODE = :PCOUCODE');
      SQL.Add('  and COU_ARTID = :PARTID');
      SQL.Add('  and TGF_COLUMNX = :PTGFCOLUMNX');
      SQL.Add('  and TGF_GTFID = :PTGFGTFID');
//      SQL.Add('  and CBI_CB = :PCBICB');
//      SQL.Add('  and CBI_TYPE = 3');
      ParamCheck := true;
      ParamByName('PCBIARFID').AsInteger := AModele.ARF_ID;
      ParamByName('PCOUCODE').AsString := Trim(ACOLORNUMBER);
      ParamByName('PARTID').AsInteger := AModele.ART_ID;
      ParamByName('PTGFCOLUMNX').AsString := Trim(ACOLUMNX);
      ParamByName('PTGFGTFID').AsInteger := AModele.GTF_ID;
//      ParamByName('PCBICB').AsString := Trim(AEAN);
      Open;
    Except on E:Exception do
      raise Exception.Create('GetArticleInfos -> ' + E.Message);
    end;

    if RecordCount > 0 then
    begin
      Result.COU_ID := FieldByName('COU_ID').AsInteger;
      Result.TGF_ID := FieldByName('TGF_ID').AsInteger;
      Result.COU_NOM := FieldByName('COU_NOM').AsString;
      Result.TGF_NOM := FieldByName('TGF_NOM').AsString;
    end
    else
      raise ENOTFIND.Create('Non trouvé');
  end;
end;

function TSDUpdateCommun.GetCollectionID(ACOL_CODE: String): Integer;
begin
  if Trim(ACOL_CODE) = '' then
    raise EERRORANDCANCEL.Create('Pas de collection disponible');

  With FIboQuery do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT COL_ID FROM ARTCOLLECTION');
      SQL.Add('  Join K on K_ID = COL_ID and K_Enabled = 1');
      SQL.Add('Where Upper(COL_CODE) = :PCOLCODE');
      SQL.Add('  and COL_ID <> 0');
      ParamCheck := True;
      ParamByName('PCOLCODE').AsString := UpperCase(ACOL_CODE);
      Open;
    Except on E:Exception do
      raise EERRORANDCANCEL.Create('GetCollectionID -> ' + E.Message);
    end;

    if Recordcount > 0 then
    begin
      Result := FieldByName('COL_ID').AsInteger;
    end
    else
      raise EERRORANDCANCEL.Create('Code collection non trouvé ' + ACOL_CODE);
  end;
end;

function TSDUpdateCommun.GetModeleInfos(AMODEL, ABrand, ASizeRange: string;
  AModelType: Integer): TArtArticle;
begin
  With FIboQuery do
  begin
    Try
      Close;
      SQL.Clear;
      SQL.Add('Select ART_ID , ARF_ID, ART_GTFID, ART_MRKID, ARF_CHRONO, ART_FUSARTID');
      SQL.Add(' From ARTARTICLE Join K on K_ID = ART_ID and K_Enabled = 1');
      SQL.Add(' Join ARTREFERENCE on ARF_ARTID = ART_ID');
      SQL.Add(' Join PLXGTF on ART_GTFID = GTF_ID');
      SQL.Add('Where ART_CODE = :PARTCODE');
      SQL.Add('  and GTF_CODE = :PGTFCODE');
      SQL.Add('  and ART_CENTRALE = :PARTCENTRALE');
      ParamCheck := True;
      ParamByName('PARTCODE').AsString := Trim(AMODEL) + Trim(ABrand);
      ParamByName('PGTFCODE').AsString := Trim(ASizeRange);
      case AModelType of
        1: ParamByName('PARTCENTRALE').AsInteger := 1;
        2: ParamByName('PARTCENTRALE').AsInteger := 5;
      end;
      Open;
    Except on E:Exception do
      raise Exception.Create('GetModeleInfos -> ' + E.Message);
    end;

    if RecordCount > 0 then
    begin
      Result.ART_ID := FieldByName('ART_ID').AsInteger;
      Result.ARF_ID := FieldByName('ARF_ID').AsInteger;
      Result.GTF_ID := FieldByName('ART_GTFID').AsInteger;
      Result.MRK_ID := FieldByName('ART_MRKID').AsInteger;
      Result.Chrono := FieldByName('ARF_CHRONO').AsString;
      Result.ART_FUSARTID := FieldByName('ART_FUSARTID').AsInteger;
    end
    else
       raise ENOTFIND.Create('Non trouvé');
  end;
end;

procedure TSDUpdateCommun.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eCatalogListNode,
  eCatalogNode,
  eCatalogAdditionnalNode,
  eCatalogCatAddNode,
  eModelListNode,
  eModelNode,
  eModelAdditionnalNode,
  eModelModAddNode,
  eModelRecomdPriceNode,
  eModelSalesPriceNode,
  eColorListNode,
  eColorNode,
  eColorAdditionnalNode,
  eItemListNode,
  eItemNode,
  eItemAdditionnalNode,
  eItemEanListNode : IXMLNode;

  i, iCount : Integer;

  // Cataloglist
  IndexKey, SupplierKey, SupplierDenotation, CatalogKey, CatalogDenotation,
  Add_SupplierKey, Add_SupplierErp, Add_SupplierDenotation, FOUID : TFieldCFG;

  // ModelList
  {IndexKey, CatalogKey,} ModelNumber, BrandNumber, Fedas, SizeRange, VAT, Denotation,
  DenotationLong, RecommendedSalesPrice, RecommendedSalesDate, Add_Pub, Add_Supplier2Key,
  Add_Supplier2Erp, Add_Supplier2Denotation, ARTID, ARFID, ModelType, CODECOLL, IsDiff : TFieldCFG;

  // ColorList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,} ColorNumber, ColorDenotation, COUID : TFieldCFG;

  // ItemList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber,} EAN, Columnx, SizeLabel,
  ItemDenotation, PurchasePrice, RetailPrice, SMU, TDSC, ValidFrom, ART_ID, COU_ID, TGF_ID, OnError : TFieldCFG;

  // EanList
  {EAN ,} EanList, CBIID : TFieldCFG;

  // Recommandé à date
  TPO_ID : TFieldCFG;

  // Table TARCLGFOURN
  CLG_ID, CLG_FOUID, CLG_ARTID, CLG_TGFID, CLG_COUID, CLG_PX, CLG_PRINCIPAL : TFieldCfg;

  // Table TARPRIXVENTE
  PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_PX, TGF_COLUMNX, COU_CODE : TFieldCfg;

  // Table TARVALID
  TVD_ID, TVD_TVTID, TVD_COUID, TVD_TGFID, TVD_DT, TVD_PX, TVD_ETAT, TRAITER : TFieldCfg;

  // Table ArtFusionLigne
  AFL_AFEID, AFL_OLDTGFID, AFL_OLDCOUID, AFL_NEWARTID, AFL_NEWTGFID, AFL_NEWCOUID : TFieldCFG;

  // Commun
  NePlusTraiter : TFieldCFG;

begin
   if not IniStruct.SdUpdateActif then
   begin
    FErrLogs.Add('SdUpdate désactivé');
    Exit;
   end;

  if not CheckFileDate(IniStruct.SdUpdatePeriode) then
  begin
    FErrLogs.Add('Erreur : Le fichier SDUpdate est trop ancien : ' + FFile);
    Exit;
  end;

  NePlusTraiter.FieldName := 'NePlusTraiter';
  NePlusTraiter.FieldType := ftInteger;
  INDEXKEY.FieldName := 'INDEXKEY';
  INDEXKEY.FieldType := ftInteger;
  CatalogKey.FieldName             := 'CATALOGKEY';
  CatalogKey.FieldType             := ftString;

  {$REGION 'CatalogList'}
  SupplierKey.FieldName            := 'SUPPLIERKEY';
  SupplierKey.FieldType            := ftString;
  SupplierDenotation.FieldName     := 'SUPPLIERDENOTATION';
  SupplierDenotation.FieldType     := ftString;
  CatalogDenotation.FieldName      := 'CATALOGDENOTATION';
  CatalogDenotation.FieldType      := ftString;
  Add_SupplierKey.FieldName        := 'ADDSUPPLIERKEY';
  Add_SupplierKey.FieldType        := ftString;
  Add_SupplierErp.FieldName        := 'ADDSUPPLIERERP';
  Add_SupplierErp.FieldType        := ftString;
  Add_SupplierDenotation.FieldName := 'ADDSUPPLIERDENOTATION';
  Add_SupplierDenotation.FieldType := ftString;
  FOUID.FieldName                  := 'FOU_ID';
  FOUID.FieldType                  := ftInteger;

  FCatalogList.CreateField([SupplierKey, SupplierDenotation, CatalogKey, CatalogDenotation,
                             Add_SupplierKey, Add_SupplierErp, Add_SupplierDenotation, FOUID]);
  FCatalogList.IboQuery := FIboQuery;
  FCatalogList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FCatalogList.ClientDataSet.AddIndex('Idx','CATALOGKEY',[]);
  FCatalogList.ClientDataSet.IndexName := 'Idx';
  {$ENDREGION}

  {$REGION 'ModelList'}
  {IndexKey, CatalogKey,}
  ModelNumber.FieldName             := 'MODELNUMBER';
  ModelNumber.FieldType             := ftString;
  ModelType.FieldName               := 'MODELTYPE';
  ModelType.FieldType               := ftInteger;
  BrandNumber.FieldName             := 'BRANDNUMBER';
  BrandNumber.FieldType             := ftString;
  Fedas.FieldName                   := 'FEDAS';
  Fedas.FieldType                   := ftString;
  SizeRange.FieldName               := 'SIZERANGE';
  SizeRange.FieldType               := ftString;
  VAT.FieldName                     := 'VAT';
  VAT.FieldType                     := ftCurrency;
  Denotation.FieldName              := 'DENOTATION';
  Denotation.FieldType              := ftString;
  DenotationLong.FieldName          := 'DENOTATIONLONG';
  DenotationLong.FieldType          := ftString;
{  RecommendedSalesPrice.FieldName   := 'RECOMMENDEDSALESPRICE';
  RecommendedSalesPrice.FieldType   := ftCurrency;
  RecommendedSalesDate.FieldName    := 'RECOMMENDEDSALESDATE';
  RecommendedSalesDate.FieldType    := ftDate;}
  Add_Pub.FieldName                 := 'PUB';
  Add_Pub.FieldType                 := ftInteger;
  Add_Supplier2Key.FieldName        := 'SUPPLIER2KEY';
  Add_Supplier2Key.FieldType        := ftString;
  Add_Supplier2Erp.FieldName        := 'SUPPLIER2ERP';
  Add_Supplier2Erp.FieldType        := ftString;
  Add_Supplier2Denotation.FieldName := 'SUPPLIER2DENOTATION';
  Add_Supplier2Denotation.FieldType := ftString;
  ARTID.FieldName                   := 'ART_ID';
  ARTID.FieldType                   := ftInteger;
  ARFID.FieldName                   := 'ARF_ID';
  ARFID.FieldType                   := ftInteger;
  CODECOLL.FieldName                := 'CODECOLL';
  CODECOLL.FieldType                := ftString;
  IsDiff.FieldName                  := 'IsDiff';
  IsDiff.FieldType                  := ftInteger;

  FModelList.CreateField([ IndexKey, CatalogKey, ModelNumber, BrandNumber, Fedas,
                           SizeRange, VAT, Denotation, Denotationlong, {RecommendedSalesPrice,
                           RecommendedSalesDate,} Add_Pub, Add_Supplier2Key, Add_Supplier2Erp,
                           Add_Supplier2Denotation, ARTID, ARFID, ModelType, NePlusTraiter, CODECOLL, IsDiff]);
  FModelList.IboQuery := FIboQuery;
  FModelList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FModelList.ClientDataSet.AddIndex('Idx','INDEXKEY;ModelNumber;BrandNumber',[]);
  FModelList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Catalog
//  FModelList.ClientDataSet.MasterSource := FDs_CatalogList;
//  FModelList.ClientDataSet.MasterFields := 'CatalogKey';
  {$ENDREGION}

  {$REGION 'Gestion des prix recommandés à date'}
  RecommendedSalesPrice.FieldName   := 'RECOMMENDEDSALESPRICE';
  RecommendedSalesPrice.FieldType   := ftCurrency;
  RecommendedSalesDate.FieldName    := 'RECOMMENDEDSALESDATE';
  RecommendedSalesDate.FieldType    := ftDate;
  TPO_ID.FieldName := 'TPO_ID';
  TPO_ID.FieldType := ftInteger;

  FModelRecDateList.CreateField([IndexKey,CatalogKey, ModelNumber, BrandNumber,RecommendedSalesPrice,RecommendedSalesDate, TPO_ID]);
  FModelRecDateList.IboQuery := FIboQuery;
  FModelRecDateList.StpQuery := FStpQuery;
  FModelRecDateList.ClientDataSet.AddIndex('Idx','INDEXKEY;ModelNumber;BrandNumber',[]);
  FModelRecDateList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Model
  FModelRecDateList.ClientDataSet.MasterSource := FDs_ModelList;
  FModelRecDateList.ClientDataSet.MasterFields := 'INDEXKEY;ModelNumber;BrandNumber';
  {$ENDREGION}

  {$REGION 'ColorList'}
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,}
  ColorNumber.FieldName     := 'COLORNUMBER';
  ColorNumber.FieldType     := ftString;
  ColorDenotation.FieldName := 'COLORDENOTATION';
  ColorDenotation.FieldType := ftString;
  COUID.FieldName           := 'COU_ID';
  COUID.FieldType           := ftInteger;

  FColorList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, ColorDenotation, COUID]);
  FColorList.IboQuery := FIboQuery;
  FColorList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FColorList.ClientDataSet.AddIndex('Idx','INDEXKEY;ModelNumber;BrandNumber;ColorNumber',[]);
  FColorList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Model
  FColorList.ClientDataSet.MasterSource := FDs_ModelList;
  FColorList.ClientDataSet.MasterFields := 'INDEXKEY;ModelNumber;BrandNumber';
  {$ENDREGION}

  {$REGION 'ItemList'}
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,ColorNumber,}
  EAN.FieldName            := 'EAN';
  EAN.FieldType            := ftString;
  Columnx.FieldName        := 'COLUMNX';
  Columnx.FieldType        := ftString;
  SizeLabel.FieldName      := 'SIZELABEL';
  SizeLabel.FieldType      := ftString;
  ItemDenotation.FieldName := 'ITEMDENOTATION';
  ItemDenotation.FieldType := ftString;
  PurchasePrice.FieldName  := 'PURCHASEPRICE';
  PurchasePrice.FieldType  := ftCurrency;
  RetailPrice.FieldName    := 'RETAILPRICE';
  RetailPrice.FieldType    := ftCurrency;
  SMU.FieldName            := 'SMU';
  SMU.FieldType            := ftInteger;
  TDSC.FieldName           := 'TDSC';
  TDSC.FieldType           := ftInteger;
  ValidFrom.FieldName      := 'VALIDFROM';
  ValidFrom.FieldType      := ftDate;
  ART_ID.FieldName         := 'ART_ID';
  ART_ID.FieldType         := ftInteger;
  COU_ID.FieldName         := 'COU_ID';
  COU_ID.FieldType         := ftInteger;
  TGF_ID.FieldName         := 'TGF_ID';
  TGF_ID.FieldType         := ftInteger;
  OnError.FieldName        := 'OnError';
  OnError.FieldType        := ftInteger;

  FItemList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, EAN, Columnx, SizeLabel,
                         ItemDenotation, PurchasePrice, RetailPrice, SMU, TDSC, ValidFrom, ART_ID, COU_ID, TGF_ID, OnError]);
  FItemList.IboQuery := FIboQuery;
  FItemList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FItemList.ClientDataSet.AddIndex('Idx','INDEXKEY;ModelNumber;BrandNumber;ColorNumber;EAN',[]);
  FItemList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Color
  FItemList.ClientDataSet.MasterSource := FDs_ColorList;
  FItemList.ClientDataSet.MasterFields := 'INDEXKEY;ModelNumber;BrandNumber;ColorNumber';
  {$ENDREGION}

  {$REGION 'EanList'}
  {EAN ,}
  EanList.FieldName := 'EANLIST';
  EanList.FieldType := ftString;
  CBIID.FieldName   := 'CBI_ID';
  CBIID.FieldType   := ftInteger;

  FEanList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, EAN, EanList, CBIID]);
  FEanList.IboQuery := FIboQuery;
  FEanList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FEanList.ClientDataSet.AddIndex('Idx','INDEXKEY;ModelNumber;BrandNumber;ColorNumber;EAN',[]);
  FEanList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Item
  FEanList.ClientDataSet.MasterSource := FDs_ItemList;
  FEanList.ClientDataSet.MasterFields := 'INDEXKEY;ModelNumber;BrandNumber;ColorNumber;EAN';
  {$ENDREGION}

  {$REGION 'Table TARPRIXVENTE'}
  PVT_ID.FieldName := 'PVT_ID';
  PVT_ID.FieldType := ftInteger;
  PVT_ARTID.FieldName := 'PVT_ARTID';
  PVT_ARTID.FieldType := ftInteger;
  PVT_TGFID.FieldName := 'PVT_TGFID';
  PVT_TGFID.FieldType := ftInteger;
  PVT_COUID.FieldName := 'PVT_COUID';
  PVT_COUID.FieldType := ftInteger;
  PVT_TVTID.FieldName := 'PVT_TVTID';
  PVT_TVTID.FieldType := ftInteger;
  PVT_PX.FieldName := 'PVT_PX';
  PVT_PX.FieldType := ftCurrency;
  TGF_COLUMNX.FieldName := 'TGF_COLUMNX';
  TGF_COLUMNX.FieldType := ftString;
  COU_CODE.FieldName := 'COU_CODE';
  COU_CODE.FieldType := ftString;

  FTARPRIXVENTE.CreateField([PVT_ID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_TVTID, PVT_PX, TGF_COLUMNX, COU_CODE]);
  {$ENDREGION}

  {$REGION 'Table TARVALID'}
  TVD_ID.FieldName := 'TVD_ID';
  TVD_ID.FieldType := ftInteger;
  TVD_TVTID.FieldName := 'TVD_TVTID';
  TVD_TVTID.FieldType := ftInteger;
  TVD_COUID.FieldName := 'TVD_COUID';
  TVD_COUID.FieldType := ftInteger;
  TVD_TGFID.FieldName := 'TVD_TGFID';
  TVD_TGFID.FieldType := ftInteger;
  TVD_DT.FieldName := 'TVD_DT';
  TVD_DT.FieldType := ftDate;
  TVD_PX.FieldName := 'TVD_PX';
  TVD_PX.FieldType := ftCurrency;
  TVD_ETAT.FieldName := 'TVD_ETAT';
  TVD_ETAT.FieldType := ftInteger;
  TRAITER.FieldName := 'TRAITER';
  TRAITER.FieldType := ftInteger;

  FTARVALID.CreateField([TVD_ID, TVD_TVTID, TVD_COUID, TVD_TGFID, TVD_DT, TVD_PX, TVD_ETAT,  TGF_COLUMNX, COU_CODE, TRAITER]);
  {$ENDREGION}

  {$REGION 'Table ARTFUSIONLIGNE'}
  AFL_AFEID.FieldName := 'AFL_AFEID';
  AFL_AFEID.FieldType := ftInteger;
  AFL_OLDTGFID.FieldName := 'AFL_OLDTGFID';
  AFL_OLDTGFID.FieldType := ftInteger;
  AFL_OLDCOUID.FieldName := 'AFL_OLDCOUID';
  AFL_OLDCOUID.FieldType := ftInteger;
  AFL_NEWARTID.FieldName := 'AFL_NEWARTID';
  AFL_NEWARTID.FieldType := ftInteger;
  AFL_NEWTGFID.FieldName := 'AFL_NEWTGFID';
  AFL_NEWTGFID.FieldType := ftInteger;
  AFL_NEWCOUID.FieldName := 'AFL_NEWCOUID';
  AFL_NEWCOUID.FieldType := ftInteger;
  FARTFUSIONLIGNE.CreateField([AFL_AFEID, AFL_OLDTGFID, AFL_OLDCOUID, AFL_NEWARTID, AFL_NEWTGFID, AFL_NEWCOUID]);
  {$ENDREGION}

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;

  {$REGION 'Récupération du mode de traitement du fichier'}
      case XmlStrToInt(nXmlBase.ChildValues['ALLOWINSERTS']) of
        0: FMode := umUpdate;
        1: Exit; // FMode := umInsert;
      end;
  {$ENDREGION}

      eCatalogListNode := nXmlBase.ChildNodes.FindNode('CATALOGLIST');
      eCatalogNode     := eCatalogListNode.ChildNodes['CATALOG'];

      While eCatalogNode <> nil do
      begin
        With FCatalogList.ClientDataSet do
        begin
          Append;
          FieldByName('SUPPLIERKEY').AsString        := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERKEY']);
          FieldByName('SUPPLIERDENOTATION').AsString := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERDENOTATION']);

          if trim(XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY'])) = '' then
            FieldByName('CATALOGKEY').AsString         := '0'
          else
            FieldByName('CATALOGKEY').AsString         := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
          FieldByName('CATALOGDENOTATION').AsString  := XmlStrToStr(eCatalogNode.ChildValues['CATALOGDENOTATION']);

          eCatalogAdditionnalNode := eCatalogNode.ChildNodes['CATALOGADDITIONAL'];
          eCatalogCatAddNode      := eCatalogAdditionnalNode.ChildNodes['ADDITIONAL'];
          if eCatalogCatAddNode <> nil then
          begin
            FieldByName('ADDSUPPLIERKEY').AsString := XmlStrToStr(eCatalogCatAddNode.ChildValues['SUPPLIERKEY']);
            FieldByName('ADDSUPPLIERERP').AsString := XmlStrToStr(eCatalogCatAddNode.ChildValues['SUPPLIERERP']);
            FieldByName('ADDSUPPLIERDENOTATION').AsString := XmlStrToStr(eCatalogCatAddNode.ChildValues['SUPPLIERDENOTATION']);
          end;
          FieldByName('FOU_ID').AsInteger := -1;
          Post;
        end; // with

        eModelListNode := eCatalogNode.ChildNodes['MODELLIST'];
        eModelNode     := eModelListNode.ChildNodes['MODEL'];

        iCount := 0; // Sert pour générer un index unique

        while eModelNode <> nil do
        begin
          eModelRecomdPriceNode := eModelNode.ChildNodes['RECOMMENDEDSALESPRICE'];
          eModelSalesPriceNode := nil;
          if eModelRecomdPriceNode <> nil then
            eModelSalesPriceNode  := eModelRecomdPriceNode.ChildNodes['SALESPRICE'];

          With FModelList.ClientDataSet do
          begin
            Inc(iCount);

            Append;
            FieldByName('INDEXKEY').AsInteger      := iCount;
            FieldByName('CATALOGKEY').AsString     := FCatalogList.FieldByName('CATALOGKEY').AsString;
            FieldByName('MODELNUMBER').AsString    := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
            FieldByName('MODELTYPE').AsInteger     := XmlStrToInt(eModelNode.ChildValues['MODELTYPE']);
            FieldByName('BRANDNUMBER').AsString    := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
            FieldByName('FEDAS').AsString          := XmlStrToStr(eModelNode.ChildValues['FEDAS']);
            FieldByName('SIZERANGE').AsString      := XmlStrToStr(eModelNode.ChildValues['SIZERANGE']);
            FieldByName('VAT').AsCurrency          := XmlStrToFloat(eModelNode.ChildValues['VAT']);
            FieldByName('DENOTATION').AsString     := XmlStrToStr(eModelNode.ChildValues['DENOTATION']);
            FieldByName('DENOTATIONLONG').AsString := XmlStrToStr(eModelNode.ChildValues['DENOTATIONLONG']);
            FieldByName('NePlusTraiter').AsInteger   := 0;
            FieldByName('IsDiff').AsInteger          := 0;

            eModelAdditionnalNode := eModelNode.ChildNodes['MODELADDITIONAL'];
            eModelModAddNode :=  eModelAdditionnalNode.ChildNodes['ADDITIONAL'];
            if eModelModAddNode <> nil then
            begin
              FieldByName('PUB').AsInteger                := XmlStrToInt(eModelModAddNode.ChildValues['PUB']);
              FieldByName('SUPPLIER2KEY').AsString        := XmlStrToStr(eModelModAddNode.ChildValues['SUPPLIER2KEY']);
              FieldByName('SUPPLIER2ERP').AsString        := XmlStrToStr(eModelModAddNode.ChildValues['SUPPLIER2ERP']);
              FieldByName('SUPPLIER2DENOTATION').AsString := XmlStrToStr(eModelModAddNode.ChildValues['SUPPLIER2DENOTATION']);
              FieldByName('CODECOLL').AsString            := XmlStrToStr(eModelModAddNode.ChildValues['CODECOLL']);
            end;
            FieldByName('ART_ID').AsInteger := -1;
            FieldByName('ARF_ID').AsInteger := -1;
            Post;
          end; // with

          // Prix recommandés à date
          With FModelRecDateList.ClientDataSet do
          begin
            while eModelSalesPriceNode <> nil do
            begin
              Append;
              FieldByName('INDEXKEY').AsInteger               := iCount;
              FieldByName('CATALOGKEY').AsString              := FCatalogList.FieldByName('CATALOGKEY').AsString;
              FieldByName('MODELNUMBER').AsString             := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
              FieldByName('BRANDNUMBER').AsString             := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
              FieldByName('RECOMMENDEDSALESPRICE').AsCurrency := XmlStrToFloat(eModelSalesPriceNode.ChildValues['PRICE']);
              FieldByName('RECOMMENDEDSALESDATE').AsDateTime  := XmlStrToDate(eModelSalesPriceNode.ChildValues['DATE']);
              FieldByName('TPO_ID').AsInteger                 := 0;
              Post;
              eModelSalesPriceNode := eModelSalesPriceNode.NextSibling;
            end;
          end;

          eColorListNode := eModelNode.ChildNodes['COLORLIST'];
          eColorNode     := eColorListNode.ChildNodes['COLOR'];

          while eColorNode <> nil do
          begin

            With FColorList.ClientDataSet do
            begin
              Append;
              FieldByName('INDEXKEY').AsInteger   := iCount;
              FieldByName('CATALOGKEY').AsString  := FCatalogList.FieldByName('CATALOGKEY').AsString;
              FieldByName('MODELNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
              FieldByName('BRANDNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
              FieldbyName('COLORNUMBER').AsString := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
              FieldbyName('COLORDENOTATION').AsString := XmlStrToStr(eColorNode.ChildValues['COLORDENOTATION']);


              eColorAdditionnalNode := eColorNode.ChildNodes['COLORADDITIONAL'].ChildNodes['ADDITIONAL'];
              if eColorAdditionnalNode <> nil then
              begin
                // Rien pour l'instant mais mis en place pour des modifications futures
              end;

              Post;
            end; // with

            eItemListNode := eColorNode.ChildNodes['ITEMLIST'];
            eItemNode     := eItemListNode.ChildNodes['ITEM'];

            while eItemNode <> nil do
            begin
              eItemEanListNode := eItemNode.ChildNodes['EANLIST'];
              eItemAdditionnalNode := eItemNode.ChildNodes['ITEMADDITIONAL'].ChildNodes['ADDITIONAL'];

              With FItemList.ClientDataSet do
              begin
                Append;
                FieldByName('INDEXKEY').AsInteger       := iCount;
                FieldByName('CATALOGKEY').AsString      := FCatalogList.FieldByName('CATALOGKEY').AsString;
                FieldByName('MODELNUMBER').AsString     := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
                FieldByName('BRANDNUMBER').AsString     := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
                FieldbyName('COLORNUMBER').AsString     := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                FieldByName('EAN').AsString             := XmlStrToStr(eItemNode.ChildValues['EAN']);
                FieldByName('COLUMNX').AsString         := XmlStrToStr(eItemNode.ChildValues['COLUMNX']);
                FieldByName('SIZELABEL').AsString       := XmlStrToStr(eItemNode.ChildValues['SIZELABEL']);
                FieldByName('ITEMDENOTATION').AsString  := XmlStrToStr(eItemNode.ChildValues['ITEMDENOTATION']);
                FieldByName('PURCHASEPRICE').AsCurrency := XmlStrToFloat(eItemNode.ChildValues['PURCHASEPRICE']);
                FieldByName('RETAILPRICE').AsCurrency   := XmlStrToFloat(eItemNode.ChildValues['RETAILPRICE']);
                FieldByName('SMU').AsInteger            := XmlStrToInt(eItemNode.ChildValues['SMU']);
                FieldByName('TDSC').AsInteger           := XmlStrToInt(eItemNode.ChildValues['TDSC']);
                FieldByName('VALIDFROM').AsDateTime     := XmlStrToDate(eItemNode.ChildValues['VALIDFROM']);
                Post;

                // Indique que le montant entre le modèle et un des articles est différent.
                if FModelList.FieldByName('IsDiff').AsInteger = 0 then
                  if CompareValue(FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency, FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
                  begin
                    FModelList.ClientDataSet.Edit;
                    FModelList.FieldByName('IsDiff').AsInteger := 1;
                    FModelList.Post;
                  end;
              end; // with

//              while eItemEanListNode <> nil do
              for i := 0 to eItemEanListNode.childNodes.Count -1 do
              begin
          //      If eItemEanListNode.childNodes.Count > 0 then
                With FEanList.ClientDataSet do
                begin
                  Append;
                  FieldByName('INDEXKEY').AsInteger   := iCount;
                  FieldByName('CATALOGKEY').AsString  := FCatalogList.FieldByName('CATALOGKEY').AsString;
                  FieldByName('MODELNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
                  FieldByName('BRANDNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
                  FieldbyName('COLORNUMBER').AsString := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                  FieldByName('EAN').AsString := XmlStrToStr(eItemNode.ChildValues['EAN']);
                  FieldByName('EANLIST').AsString := XmlStrToStr( eItemEanListNode.ChildNodes.Get(i).NodeValue); //eItemEanListNode.ChildValues['EAN']);

                  Post;
                end;
           //     eItemEanListNode := eItemEanListNode.NextSibling;
              end; // while

              eItemNode := eItemNode.NextSibling;
            end;  // while eItemNode

            eColorNode := eColorNode.NextSibling;
          end; // while eColorNode

          eModelNode := eModelNode.NextSibling;
        end; // while eModelNode

        eCatalogNode := eCatalogNode.NextSibling;
      end; // while eCatalogNode

      // Analyse des données en mémoire pour savoir si on va les traiter.
      FCatalogList.First;
      FModelList.First;
      while not FModelList.EOF do
      begin
        while not FColorList.EOF do
        begin
          while not FItemList.EOF do
          begin
            // Sert à ne passer qu'une fois s'il y a un changement dans les dates du modèle
            if FModelList.FieldByName('NePlusTraiter').AsInteger = 0 then
              // Est ce que la date RECOMMANDED <> à la date du jour
              if CompareDate(FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,FItemList.FieldByName('VALIDFROM').AsDateTime) <> EqualsValue  then
              begin
                    FModelRecDateList.ClientDataSet.Edit;
                    FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime := FItemList.FieldByName('VALIDFROM').AsDateTime;
                    FModelRecDateList.Post;

                    FModelList.ClientDataSet.Edit;
                    FModelList.FieldByName('NePlusTraiter').AsInteger := 1;
                    FModelList.Post;
              end;
            FItemList.Next;
          end;
          FColorList.Next;
        end;
        FModelList.Next;
      end;

    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
    TXMLDocument(Xml).Free;
  end;
end;

function TSDUpdateCommun.SetArtPrixVente(PVT_ARTID, PVT_TGFID, PVT_COUID,
  PVT_TVTID: Integer; PVT_PX: single; PVT_CENTRALE: Integer): Integer;
var
  iPVTID : Integer;
begin
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TVENTE_CREATE';
      ParamCheck := True;
      ParamByName('PVT_ARTID').AsInteger := PVT_ARTID;
      ParamByName('PVT_TGFID').AsInteger := PVT_TGFID;
      ParamByName('PVT_COUID').AsInteger := PVT_COUID;
      ParamByName('PVT_TVTID').AsInteger := PVT_TVTID;
      ParamByName('PVT_PX').AsCurrency := PVT_PX;
      ParamByName('PVT_CENTRALE').AsInteger := PVT_CENTRALE;
      Open;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente -> ' + E.Message);
  End;
end;

function TSDUpdateCommun.SetTarPreco(ATPO_ARTID: Integer; ATPO_DT: TDate;
  ATPO_PX: Currency; ATPO_ETAT, ATPO_COLID : Integer): Integer;
begin
  With StpQuery do
  Try
    Close;
    StoredProcName := 'MSS_SETTARPRECO_COL';
    ParamByName('TPO_ARTID').AsInteger := ATPO_ARTID;
    ParamByName('TPO_DT').AsDate       := ATPO_DT;
    ParamByName('TPO_PX').AsCurrency   := ATPO_PX;
    ParamByName('TPO_ETAT').AsInteger  := ATPO_ETAT;
    ParamByName('TPO_COLID').AsInteger := ATPO_COLID;
    Open;

    Result := FieldByName('TPO_ID').AsInteger;
  Except on E:Exception do
    raise EMODELERROR.Create('SetTarPreco -> ' + E.Message);
  end;
end;

function TSDUpdateCommun.SetTarValid(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID,
  ATVD_TGFID, ATVD_COUID: Integer; ATVD_PX: Currency; ATVD_DT: TDate;
  ATVD_ETAT: Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETTARVALID(:PTPOID, :PTVTID, :PARTID, :PTGFID, :PCOUID, :PTVDPX, :PTVDDT, :PTVDETAT)');
    ParamCheck := True;
    ParamByName('PTPOID').AsInteger := ATVD_TPOID;
    ParamByName('PTVTID').AsInteger := ATVD_TVTID;
    ParamByName('PARTID').AsInteger := ATVD_ARTID;
    ParamByName('PTGFID').AsInteger := ATVD_TGFID;
    ParamByName('PCOUID').AsInteger := ATVD_COUID;
    ParamByName('PTVDPX').AsCurrency := ATVD_PX;
    ParamByName('PTVDDT').AsDate     := ATVD_DT;
    ParamByName('PTVDETAT').AsInteger := ATVD_ETAT;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('TVD_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('SetTarValid -> ' + E.Message);
  End;
end;

function TSDUpdateCommun.UpdTarPreco(ATPO_ID: Integer; ATPO_DT: TDate;
  ATPO_PX: Currency; ATPO_ETAT, ATPO_COLID: Integer): Integer;
begin
  With StpQuery do
  Try
    Close;
    StoredProcName := 'MSS_UPDTARPRECO_COL';
    ParamByName('TPO_ID').AsInteger := ATPO_ID;
    ParamByName('TPO_DT').AsDate       := ATPO_DT;
    ParamByName('TPO_PX').AsCurrency   := ATPO_PX;
    ParamByName('TPO_ETAT').AsInteger  := ATPO_ETAT;
    ParamByName('TPO_COLID').AsInteger := ATPO_COLID;
    Open;

    FMajCount := FMajCount + FieldByName('FMAJ').AsInteger;
    Result := ATPO_ID;
  Except on E:Exception do
    raise EMODELERROR.Create('SetTarPreco -> ' + E.Message);
  end;

end;

function TSDUpdateCommun.CleanOldTPO(TPO_ID, TPO_ARTID, TPO_COLID: Integer;
  TPO_DT: TDate): Integer;
begin
 With FIboQuery do
 try
   Close;
   SQL.Clear;
   SQL.Add('Select * from MSS_CLEANOLDTARPRECO(:PTPO_ID, :PTPO_ARTID, :PTPO_DT, :PTPO_COLID)');
   ParamCheck := True;
   ParamByName('PTPO_ID').AsInteger := TPO_ID;
   ParamByName('PTPO_ARTID').AsInteger := TPO_ARTID;
   ParamByName('PTPO_COLID').AsInteger := TPO_COLID;
   ParamByName('PTPO_DT').AsDate := TPO_DT;
   Open;

   FMajCount := FieldByName('FMAJ').AsInteger;

  Except on E:Exception do
    raise Exception.Create('CleanOldTPO -> ' + E.Message);
  end;
end;


function TSDUpdateCommun.UpdTarValid(ATVD_ID: Integer; ATVD_DT: TDate;
  ATVD_PX: Currency): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_UPDTARVALID(:PTVDID, :PTVDDT, :PTVDPX)');
    ParamCheck := True;
    ParamByName('PTVDID').AsInteger := ATVD_ID;
    ParamByName('PTVDDT').AsDate := ATVD_DT;
    ParamByName('PTVDPX').AsCurrency := ATVD_PX;
    Open;

    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
  Except on E:Exception do
    Raise Exception.Create('UpdArtPrixAchat -> ' + E.Message);
  End;
end;

//UNICOUL
function TSDUpdateCommun.SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,
  ACBI_TYPE: Integer; ACBI_CB: String): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETARTCODEBARRE(:CBIARFID,:CBITGFID,:CBICOUID,:CBITYPE,:CBICB)');
    ParamCheck := True;
    ParamByName('CBIARFID').AsInteger := ACBI_ARFID;
    ParamByName('CBITGFID').AsInteger := ACBI_TGFID;
    ParamByName('CBICOUID').AsInteger := ACBI_COUID;
    ParamByName('CBITYPE').AsInteger  := ACBI_TYPE;
    ParamByName('CBICB').AsString     := ACBI_CB;
    Open;

    Result := FieldByName('CBI_ID').AsInteger;
    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    Inc(FMajCount, FieldByName('FMAJ').AsInteger);

  Except on E:Exception Do
    raise EMODELERROR.Create('SetARTCodeBarre -> ' + E.Message);
  end;
end;
//
end.

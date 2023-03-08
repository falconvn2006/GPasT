unit uIntNikeBL;

interface

uses IBDatabase, IBQuery, SysUtils, XMLDoc, XMLIntf, XMLSchema, xmldom, Variants, Math, Forms, Windows,
     DBClient, MidasLib, Db, Classes, uLog,uDefs, Types;

type
  TENOTFOUND = Exception;

  TArticle = record
    ART_ID,
    ARF_ID,
    TGF_ID,
    COU_ID : Integer;
  end;

  TBlLigne = record
    EANFRS1 ,
    EANFRS2 ,
    NUMCDE : string;
    CodeMovex : string;
    Qte    : Integer;
    PXACH  ,
    PXVTE  : Currency;
    PreEtik : Integer;
    Comment : string;
    Marque : string;
    RefMarque : string;
    Couleur : string;
    Taille : String;
    Article : TArticle;
    Error : integer;
  end;

  TBlPalette = record
    NUMPALETTE , // Numéro de palette si vide mettre NUMPAQ
    NUMPAQ     : string; // Numéro de carton/paquet/colis
    PAQQTE : Integer;
    Univers : string;
    CumulQte   : Integer;

    BLLignes : array of TBlLigne;
  end;

  TBlEntete = record
    IDBLF         : string; // Code du bon de livraison
    IDFOURNISSEUR : String; // Identifiant du fournisseur (Fichier FOU_*.XML)
    CFOU,
    LFOU : string;
    IDMAGASIN : String;
    TRANSPORTEUR  : string; // Nom du transporteur (Peut être vide)
    DATELIVRAISON : TDateTime;
    NBPal,
    NBPaq,
    NBArt : Integer;
    Comment : string;
    TypeBL : Integer;

    BLPalettes : array of TBlPalette;
  end;

  TFileXml = record
    FileName : string;
    MAG_ID   : Integer;
    NbError    : Integer;
    Archive  : Boolean;
    ErrorTxt : String;
    BL       : TBlEntete
  end;

  TBLAuto = Class
    private
      FDatabase : TIBDatabase;
      FIbQuery  : TIbQuery;
      FBlDirectory: string;

      FLstFile : array of TFileXml;
      FXML: IXMLDocument;

      FISV17 : Boolean;
      FTYPNORMAL, FTYPEREASSORT : Integer;

      procedure ScanDirectory;
      procedure OpenFileXml(var AFile : TFileXml);
      procedure CheckFileXml(var AFile : TFileXml);
//      function CheckCB(AEAN : string) : TArticle;
      function CheckCB(var AFile : TFileXml; iPal, iLig : integer) : TArticle;
      function GetK (ATableName : string) : Integer;
      procedure ArchiveFileXml(AFile : TFileXml);
      procedure AddToDB(var AFile : TFileXml);

      function XmlStrToStr(AValue: IXMLNode; AFieldName : string; AErrorOnBlank : Boolean = True): string;
      function XmlStrToDate(AValue: IXMLNode; AFieldName : string): TDateTime;
      function XmlStrToInt(AValue: IXMLNode; AFieldName : string;  AErrorOnBlank : Boolean = True): Integer;
      function XmlStrToIntDef(AValue: IXMLNode; AFieldName : string; DefaultInt : Integer; AErrorOnBlank : Boolean = True): Integer;
      function XmlStrToCurr(AValue: IXMLNode; AFieldName : string; APrecision : Integer = 2; AErrorOnBlank : Boolean = True): Currency;

      function IsFieldExists (AFieldName, ATableName : string) : Boolean;
      function GetGenTypeCdv( ACod, ACateg : Integer) : Integer;
    public
      constructor Create(ADatabase : TIbDatabase);
      destructor Destroy;override;

      procedure ImportBLAuto;
      function GenerationRapport(ARapportList : TStringList) : Boolean;

    published
      property BLDirectory : string read FBlDirectory write FBlDirectory;


  end;

implementation

{ TBLAuto }

procedure TBLAuto.AddToDB(var AFile: TFileXml);
var
  FOU_ID, BLA_ID, BLP_ID, LPA_ID, i, j,
  QteATraite, QteAInserer, CDL_ID, iCas : Integer;
  CdsTemp : TClientDataset;
begin

  CdsTemp := TClientDataSet.Create(nil);
  CdsTemp.FieldDefs.Add('CDL_ID',ftInteger);
  CdsTemp.FieldDefs.Add('RAL_QTE',ftInteger);
  CdsTemp.CreateDataSet;
  CdsTemp.Open;
  Try
    try
      if not FIbQuery.Transaction.InTransaction then
        FIbQuery.Transaction.StartTransaction;
      {$REGION 'création de l''entête'}
      // Vérification de l'existence du fournisseur
      with FIbQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT IMP_GINKOIA, count(*) as Resultat FROM GENIMPORT');
        SQL.Add('  join K on K_ID = IMP_ID and K_Enabled = 1');
        SQL.Add('Where IMP_REF = :PIMPREF');
        SQL.Add('  and  IMP_NUM=4 and IMP_KTBID=-11111385');
        SQL.Add('GROUP BY IMP_GINKOIA');
        ParamCheck := True;
        ParamByName('PIMPREF').AsInteger := StrToInt(AFile.BL.IDFOURNISSEUR);
        Open;
        if FieldByName('Resultat').AsInteger = 0 then
        begin
          if Trim(AFile.BL.CFOU) <> '' then
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT FOU_ID, count(*) as Resultat FROM ARTFOURN');
            SQL.Add('  join K on K_ID = FOU_ID and K_Enabled = 1');
            SQL.Add('Where FOU_CODE = :PCODE');
            SQL.Add('GROUP BY FOU_ID');
            ParamCheck := True;
            ParamByName('PCODE').AsString := AFile.BL.CFOU;
            Open;
          end;

          if FieldByName('Resultat').AsInteger = 0 then
            raise Exception.Create('Fournisseur non trouvé');

          FOU_ID := FieldByName('FOU_ID').AsInteger;
        end
        else
          FOU_ID := FieldByName('IMP_GINKOIA').AsInteger;
      end;

      // Vérification de l'existance du BL Auto
      with FIbQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT count(*) as Resultat FROM RECAUTO');
        SQL.Add('  join K on K_ID = BLA_ID and K_Enabled = 1');
        SQL.Add('Where BLA_NUMERO = :PNUM');
        SQL.Add('  And BLA_FOUID = :PFOUID');
        ParamCheck := True;
        ParamByName('PNUM').AsString := AFile.BL.IDBLF;
        ParamByName('PFOUID').AsInteger := FOU_ID;
        Open;

        if FieldByName('Resultat').AsInteger <> 0 then
          raise Exception.Create('Le bon existe déjà');
      end;

      // Création du BL
      with FIbQuery do
      begin
        BLA_ID := GetK('RECAUTO');

        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO RECAUTO(BLA_ID, BLA_NUMERO, BLA_DATE, BLA_FOUID, BLA_TRANS,BLA_MAGID,');
        if FISV17 then
          SQL.Add('BLA_TYPID,');
        
        SQL.Add('BLA_COMENT, BLA_ETAT, BLA_NBPAL, BLA_NBPAQ, BLA_NBART, BLA_REFMAG)');
        SQL.Add('VALUES(:PBLAID, :PBLANUMERO, :PBLADATE, :PBLAFOUID, :PBLATRANS, :PBLAMAGID,');
        if FISV17 then
          SQL.Add(':PBLATYPID,');
        SQL.Add(':PBLACOMENT, 0, :PBLANBPAL, :PBLANBPAQ, :PBLANBART, '''')');
        ParamCheck                          := True;
        ParamByName('PBLAID').AsInteger     := BLA_ID;
        ParamByName('PBLANUMERO').AsString  := AFile.BL.IDBLF;
        ParamByName('PBLADATE').AsDate      := AFile.BL.DATELIVRAISON;
        ParamByName('PBLAFOUID').AsInteger  := FOU_ID;
        ParamByName('PBLATRANS').AsString   := AFile.BL.TRANSPORTEUR;
        ParamByName('PBLAMAGID').AsInteger  := AFile.MAG_ID;
        ParamByName('PBLACOMENT').AsString  := AFile.BL.Comment;
        ParamByName('PBLANBPAL').AsInteger  := AFile.BL.NBPal;
        ParamByName('PBLANBPAQ').AsInteger  := AFile.BL.NBPaq;
        ParamByName('PBLANBART').AsInteger  := AFile.BL.NBArt;
        if FISV17 then
          ParamByName('PBLATYPID').AsInteger := IfThen(AFile.BL.TypeBL = 0,FTYPNORMAL,FTYPEREASSORT);
        ExecSQL;
      end;
      {$ENDREGION}

      for i := 0 to Length(AFile.BL.BLPalettes) - 1 do
      begin
        {$REGION 'Création du package'}
        with FIbQuery do
        begin
          BLP_ID := GetK('RECAUTOP');

          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO RECAUTOP (BLP_ID, BLP_BLAID, BLP_NUMERO, BLP_PALETTE, BLP_QTE,');
          SQL.Add(' BLP_UNIVERS, BLP_SCAN, BLP_ETAT, BLP_BREID, BLP_CTRLART)');
          SQL.Add('  VALUES (:PBLPID, :PBLPBLAID, :PBLPNUMERO, :PBLPPALETTE, :PBLPQTE,');
          SQL.Add(':PBLPUNIVERS, :PBLPSCAN, :PBLPETAT, :PBLPBREID, :PBLPCTRLART)');
          ParamCheck := True;
          ParamByName('PBLPID').AsInteger      := BLP_ID;
          ParamByName('PBLPBLAID').AsInteger   := BLA_ID;
          ParamByName('PBLPNUMERO').AsString   := AFile.BL.BLPalettes[i].NUMPAQ;
          ParamByName('PBLPPALETTE').AsString  := AFile.BL.BLPalettes[i].NUMPALETTE;
          ParamByName('PBLPQTE').AsInteger     := AFile.BL.BLPalettes[i].PAQQTE;
          ParamByName('PBLPUNIVERS').AsString  := AFile.BL.BLPalettes[i].Univers;
          ParamByName('PBLPSCAN').AsInteger    := 0;
          ParamByName('PBLPETAT').AsInteger    := 0;
          ParamByName('PBLPBREID').AsInteger   := 0;
          ParamByName('PBLPCTRLART').AsInteger := 0;
          ExecSQL;
        end;
        {$ENDREGION}

        {$REGION 'Création des lignes'}
        for j := 0 to Length(AFile.BL.BLPalettes[i].BLLignes) - 1 do
        begin

          if Trim(AFile.BL.BLPalettes[i].BLLignes[j].NUMCDE) <> '' then
            iCas := 0
          else
            iCas := 1;

          while iCas <> -1 do
          begin

            with FIbQuery do
            begin
              case iCas of
                0: begin
                  // Recherche de la commande correspondante
                    Close;
                    SQL.Clear;
                    SQL.Add('SELECT CDL_ID, RAL_QTE, Cast(Sum(LPA_QTE) as Integer) as QTEBL from COMBCDEL');
                    SQL.Add('join K on K_ID = CDL_ID and K_Enabled = 1');
                    SQL.Add('Join COMBCDE on CDE_ID = CDL_CDEID');
                    SQL.Add('join K on K_ID = CDE_ID and K_Enabled = 1');
                    SQL.Add('Join AGRRAL on RAL_CDLID = CDL_ID');
                    SQL.Add('LEFT join (RECAUTOL join k on k_id = lpa_id and K_Enabled = 1) on LPA_CDLID = CDL_ID');
                    SQL.Add('Where CDE_NUMFOURN = :PNUMFOURN');
                    SQL.Add('and CDL_ARTID = :PARTID');
                    SQL.Add('and CDL_TGFID = :PTGFID');
                    SQL.Add('and CDL_COUID = :PCOUID');
                    SQL.Add('GROUP BY CDL_ID, RAL_QTE');
                    SQL.Add('ORDER BY CDL_LIVRAISON, CDL_ID, RAL_QTE');

                    ParamCheck := True;
                    ParamByName('PNUMFOURN').AsString := AFile.BL.BLPalettes[i].BLLignes[j].NUMCDE;
                    ParamByName('PARTID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.ART_ID;
                    ParamByName('PTGFID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.TGF_ID;
                    ParamByName('PCOUID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.COU_ID;
                    Open;
                end;

                1: begin
                  // Recherche dans toutes les commandes pour cet article
                    Close;
                    SQL.Clear;
                    SQL.Add('SELECT CDL_ID, RAL_QTE, Cast(Sum(LPA_QTE) as Integer) as QTEBL from COMBCDEL');
                    SQL.Add('join K on K_ID = CDL_ID and K_Enabled = 1');
                    SQL.Add('Join COMBCDE on CDE_ID = CDL_CDEID');
                    SQL.Add('join K on K_ID = CDE_ID and K_Enabled = 1');
                    SQL.Add('Join AGRRAL on RAL_CDLID = CDL_ID');
                    SQL.Add('LEFT join (RECAUTOL join k on k_id = lpa_id and K_Enabled = 1) on LPA_CDLID = CDL_ID');
                    SQL.Add('Where RAL_QTE <> 0 ');
                    if Trim(AFile.BL.BLPalettes[i].BLLignes[j].NUMCDE) <> '' then
                      SQL.Add('and CDE_NUMFOURN <> :PNUMFOURN');
                    SQL.Add('and CDL_ARTID = :PARTID');
                    SQL.Add('and CDL_TGFID = :PTGFID');
                    SQL.Add('and CDL_COUID = :PCOUID');
                    SQL.Add('GROUP BY CDL_ID, RAL_QTE');
                    SQL.Add('ORDER BY CDL_LIVRAISON, CDL_ID, RAL_QTE');

                    ParamCheck := True;
                    if Trim(AFile.BL.BLPalettes[i].BLLignes[j].NUMCDE) <> '' then
                      ParamByName('PNUMFOURN').AsString := AFile.BL.BLPalettes[i].BLLignes[j].NUMCDE;
                    ParamByName('PARTID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.ART_ID;
                    ParamByName('PTGFID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.TGF_ID;
                    ParamByName('PCOUID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.COU_ID;
                    Open;
                end;
                2: begin
                // Cas
                  Close;
                  SQL.Clear;
                end
                else begin
                  iCas := -1;
                  Continue;
                end;
              end; // case

              // Sauvegarde des informations dans un CDS
              CdsTemp.EmptyDataSet;
              while not Eof do
              begin
                CdsTemp.Append;
                CdsTemp.FieldByName('CDL_ID').AsInteger := FieldByName('CDL_ID').AsInteger;
                CdsTemp.FieldByName('RAL_QTE').AsInteger := FieldByName('RAL_QTE').AsInteger - FieldByName('QTEBL').AsInteger;
                CdsTemp.Post;
                Next;
              end;

              if (iCas = 0) and (CdsTemp.RecordCount = 0) then
              begin
                if (AFile.BL.TypeBL = 1) then
                  iCas := 2
                else
                  Inc(iCas);
                Continue;
              end;
           end; // with

            QteATraite := AFile.BL.BLPalettes[i].BLLignes[j].Qte;

            while QteATraite > 0 do
            begin
              // recherche s'il y a une ligne avec la quantité correspondante
              if CdsTemp.Locate('RAL_QTE', QteATraite, []) then
              begin
                QteAInserer := QteATraite;
                CDL_ID := CdsTemp.FieldByName('CDL_ID').AsInteger;
              end
              else begin
                CdsTemp.First;
                while (CdsTemp.FieldByName('RAL_QTE').AsInteger <= 0) and not CdsTemp.Eof do
                  CdsTemp.Next;
                if CdsTemp.FieldByName('RAL_QTE').AsInteger > 0 then
                begin
                  if CdsTemp.FieldByName('RAL_QTE').AsInteger > QteATraite then
                    QteAInserer := QteATraite
                  else
                    QteAInserer := CdsTemp.FieldByName('RAL_QTE').AsInteger;
                  CDL_ID := CdsTemp.FieldByName('CDL_ID').AsInteger;

                  CdsTemp.Edit;
                  CdsTemp.FieldByName('RAL_QTE').AsInteger := CdsTemp.FieldByName('RAL_QTE').AsInteger - QteAInserer;
                  CdsTemp.Post;
                end
                else begin
                  QteAInserer := QteATraite;
                  CDL_ID := 0;
                end;
              end;

              // Création des lignes

              {$REGION 'Est-ce que le prix de vente est à 0 ?'}
              if CompareValue(AFile.BL.BLPalettes[i].BLLignes[j].PXVTE,0, 0.0001) = EqualsValue then
              begin
                with FIbQuery do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('SELECT R_PRIX FROM GETPRIXDEVENTE(0,:PARTID, :PTGFID, :PCOUID)');
                  ParamCheck := True;
                  ParamByName('PARTID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.ART_ID;
                  ParamByName('PTGFID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.TGF_ID;
                  ParamByName('PCOUID').AsInteger := AFile.BL.BLPalettes[i].BLLignes[j].Article.COU_ID;
                  Open;

                  if Recordcount > 0 then
                    AFile.BL.BLPalettes[i].BLLignes[j].PXVTE := FieldByName('R_PRIX').AsCurrency;
                end;
              end;
              {$ENDREGION}

              with FIbQuery do
              begin
                  LPA_ID := GetK('RECAUTOL');
                  Close;
                  SQL.Clear;
                  SQL.Add('INSERT INTO RECAUTOL (LPA_ID, LPA_BLPID, LPA_ARTID, LPA_TGFID, LPA_COUID,LPA_CDLID,');
                  SQL.Add(' LPA_QTE, LPA_PREETIK, LPA_COMENT, LPA_PA, LPA_PV, LPA_INCONU, LPA_EAN, LPA_PREPACK, LPA_QTESCAN)');
                  SQL.Add('  VALUES (:PLPAID, :PLPABLPID, :PLPAARTID, :PLPATGFID, :PLPACOUID, :PLPACDLID,');
                  SQL.Add(':PLPAQTE, :PLPAPREETIK, :PLPACOMENT, :PLPAPA, :PLPAPV, :PLPAINCONU, :PLPAEAN, :PLPAPREPACK, :PLPAQTESCAN)');
                  ParamCheck                           := True;
                  ParamByName('PLPAID').AsInteger      := LPA_ID;
                  ParamByName('PLPABLPID').AsInteger   := BLP_ID;
                  ParamByName('PLPAARTID').AsInteger   := AFile.BL.BLPalettes[i].BLLignes[j].Article.ART_ID;
                  ParamByName('PLPATGFID').AsInteger   := AFile.BL.BLPalettes[i].BLLignes[j].Article.TGF_ID;
                  ParamByName('PLPACOUID').AsInteger   := AFile.BL.BLPalettes[i].BLLignes[j].Article.COU_ID;
                  ParamByName('PLPACDLID'). AsInteger  := CDL_ID;
                  ParamByName('PLPAQTE').AsInteger     := QteAInserer;
                  ParamByName('PLPAPREETIK').AsInteger := 0;
                  ParamByName('PLPACOMENT').AsString   := AFile.BL.BLPalettes[i].BLLignes[j].Comment;
                  ParamByName('PLPAPA').AsCurrency     := AFile.BL.BLPalettes[i].BLLignes[j].PXACH;
                  ParamByName('PLPAPV').AsCurrency     := AFile.BL.BLPalettes[i].BLLignes[j].PXVTE;
                  ParamByName('PLPAINCONU').AsInteger := 0;
                  ParamByName('PLPAEAN').AsString      := AFile.BL.BLPalettes[i].BLLignes[j].EANFRS1;
                  ParamByName('PLPAPREPACK').AsInteger := 0;
                  ParamByName('PLPAQTESCAN').AsInteger := 0;
                  ExecSQL;
              end;

              QteATraite := QteATraite - QteAInserer;
            end;

            if (iCas = 0) and (QteATraite <> 0) and (AFile.BL.TypeBL = 1) then
            begin
              iCas := 2;
              Continue;
            end;

            if QteATraite = 0 then
              iCas := -1
            else
              Inc(iCas);

          end; // while
        end;
        {$ENDREGION}
      end;
      FIbQuery.Transaction.Commit;
      AFile.Archive := True;

    except on E:Exception do
      begin
        FIbQuery.Transaction.Rollback;

        inc(AFile.NbError);
        AFile.Archive := True;
        AFile.ErrorTxt := E.Message;
      end;
    end;
  Finally
    FreeAndNil(CdsTemp);
  end;

end;

procedure TBLAuto.ArchiveFileXml(AFile: TFileXml);
Var
  sDirectory,
  sFileName  : string;
begin
  if AFile.Archive then
  begin
    sDirectory := FBlDirectory;
    if AFile.NbError > 0 then
      sDirectory := sDirectory + 'REJETES\' + FormatDateTime('YYYY\MM\DD\',Now)
    else
      sDirectory := sDirectory + 'INTEGRES\' + FormatDateTime('YYYY\MM\DD\',Now);

    sFileName := sDirectory + FormatDateTime('YYYYMMDDhhmmss-',Now) + AFile.FileName;

    ForceDirectories(sDirectory);
    MoveFile(PAnsiChar(FBlDirectory + AFile.FileName),PAnsiChar(sFileName));
  end;
end;

//function TBLAuto.CheckCB(AEAN: string): TArticle;
//begin
//  with FIbQuery do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('SELECT CBI_ARFID, CBI_TGFID, CBI_COUID, ARF_ARTID, CBI_PRIN FROM ARTCODEBARRE');
//    SQL.Add('  Join K on K_ID = CBI_ID and K_Enabled = 1');
//    SQL.Add('  Join ARTREFERENCE on ARF_ID = CBI_ARFID');
//    SQL.Add('  Join K on K_ID = ARF_ID and K_Enabled = 1');
//    SQL.Add('Where CBI_TYPE = 3 and CBI_CB = :PCB');
//    SQL.Add('Order By CBI_PRIN DESC, K_INSERTED DESC');
//    SQL.Add('ROWS 1');
//    ParamCheck := True;
//    ParamByName('PCB').AsString := AEAN;
//    Open;
//
//    if RecordCount = 0 then
//    begin
//      raise TENOTFOUND.Create(Format('Code à barres %s non trouvé',[AEAN]));
//    end
//    else begin
//      Result.ART_ID := FieldByName('ARF_ARTID').AsInteger;
//      Result.ARF_ID := FieldByName('CBI_ARFID').AsInteger;
//      Result.TGF_ID := FieldByName('CBI_TGFID').AsInteger;
//      Result.COU_ID := FieldByName('CBI_COUID').AsInteger;
//    end;
//  end;
//end;

function TBLAuto.CheckCB(var AFile : TFileXml; iPal, iLig : integer): TArticle;
var
  iArt, iArf, iTgf, iCou : integer;
  bCBFound : Boolean;
begin
  with FIbQuery do
  begin
    bCBFound := True;
    Close;
    SQL.Clear;
    SQL.Add('SELECT CBI_ARFID, CBI_TGFID, CBI_COUID, ARF_ARTID, CBI_PRIN FROM ARTCODEBARRE');
    SQL.Add('  Join K on K_ID = CBI_ID and K_Enabled = 1');
    SQL.Add('  Join ARTREFERENCE on ARF_ID = CBI_ARFID');
    SQL.Add('  Join K on K_ID = ARF_ID and K_Enabled = 1');
    SQL.Add('Where CBI_TYPE = 3 and CBI_CB = :PCB');
    SQL.Add('Order By CBI_PRIN DESC, K_INSERTED DESC');
    SQL.Add('ROWS 1');
    ParamCheck := True;
    ParamByName('PCB').AsString := AFile.BL.BLPalettes[iPal].BLLignes[iLig].EANFRS1;
    Open;
    if RecordCount = 0 then
    begin
      if AFile.BL.BLPalettes[iPal].BLLignes[iLig].EANFRS2 <> '' then
      begin
        Close;
        ParamByName('PCB').AsString := AFile.BL.BLPalettes[iPal].BLLignes[iLig].EANFRS2;
        Open;
        if RecordCount = 0 then
        begin
          inc(AFile.NbError);
          AFile.BL.BLPalettes[iPal].BLLignes[iLig].Error := 2;
          bCBFound := False;
        end;
      end
      else
      begin
        inc(AFile.NbError);
        bCBFound := False;
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Error := 1;
      end;
    end;

    if bCBFound then
    begin
      iArt := FieldByName('ARF_ARTID').AsInteger;
      iArf := FieldByName('CBI_ARFID').AsInteger;
      iTgf := FieldByName('CBI_TGFID').AsInteger;
      iCou := FieldByName('CBI_COUID').AsInteger;
      Close;
      SQL.Clear;
      SQL.Add('SELECT ttv_id from (PLXTAILLESTRAV join k on k_id=ttv_id and k_enabled=1) where ttv_artid=:artid and ttv_tgfid=:tgfid');
      ParamCheck := True;
      ParamByName('artid').AsInteger := iArt;
      ParamByName('tgfid').AsInteger := iTgf;
      Open;
      if RecordCount = 0 then
      begin
        inc(AFile.NbError);
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Error := 3;
        Close;
        SQL.Clear;
        SQL.Add('SELECT tgf_nom from PLXTAILLESGF where tgf_id=:tgfid rows 1');
        ParamCheck := True;
        ParamByName('tgfid').AsInteger := iTgf;
        Open;
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Taille := FieldByName('TGF_NOM').AsString;
      end else
      begin
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Article.ART_ID := iArt;
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Article.ARF_ID := iArf;
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Article.TGF_ID := iTgf;
        AFile.BL.BLPalettes[iPal].BLLignes[iLig].Article.COU_ID := iCou;
      end;
    end;
  end;
end;

procedure TBLAuto.CheckFileXml(var AFile: TFileXml);
var
  IdxPalette,IdxLignes : Integer;
begin
  // Vérification que le fichier est bien pour cette base de données.
  with FIbQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT MAG_ID, Count(*) as Resultat FROM GENMAGASIN');
    SQL.Add('  Join K on K_ID = MAG_ID and K_Enabled = 1');
    SQL.Add('Where MAG_ID <> 0 ');
    SQL.Add('  And MAG_CODEADH = :PCODE');
    SQL.Add('GROUP BY MAG_ID');
    ParamCheck := True;
    ParamByName('PCODE').AsString := AFile.BL.IDMAGASIN;
    Open;

    if FieldByName('Resultat').AsInteger = 0 then
    begin
        Inc(AFile.NbError);
        AFile.Archive := True;
        AFile.ErrorTxt := AFile.BL.IDBLF + ' : Le BL n''est pas pour les magasins de ce dossier' ;
        Exit;
    end;

    AFile.MAG_ID := FieldByName('MAG_ID').AsInteger;
  end;

  // Vérification de la présence des articles dans la base de données
  Try
    IdxPalette := 0;
    while IdxPalette < Length(AFile.BL.BLPalettes) do
    begin

      IdxLignes := 0;
      while IdxLignes < Length(AFile.BL.BLPalettes[IdxPalette].BLLignes) do
      begin
        try
//          AFile.BL.BLPalettes[IdxPalette].BLLignes[IdxLignes].Article := CheckCb(AFile.BL.BLPalettes[IdxPalette].BLLignes[IdxLignes].EANFRS1);
          CheckCb(AFile, IdxPalette, IdxLignes);

        except
//          on E:TENOTFOUND do
//            begin
//              if Trim(AFile.BL.BLPalettes[IdxPalette].BLLignes[IdxLignes].EANFRS2) <> '' then
//                AFile.BL.BLPalettes[IdxPalette].BLLignes[IdxLignes].Article := CheckCb(AFile.BL.BLPalettes[IdxPalette].BLLignes[IdxLignes].EANFRS2)
//              else
//                raise;
//            end;
          on E:Exception do
            raise;
        end;

        Inc(IdxLignes);
      end;
      Inc(IdxPalette);
    end;
  except
//    on E:TENOTFOUND do
//      begin
//        AFile.Error := True;
//        AFile.Archive := False;
//        AFile.ErrorTxt.Add(AFile.BL.IDBLF + ' ' + E.Message);
//      end;

    on E:Exception do
      begin
        inc(AFile.NbError);
        AFile.Archive := True;
        AFile.ErrorTxt := AFile.BL.IDBLF + ' ' + E.Message;
      end;
  end;

end;

constructor TBLAuto.Create(ADatabase: TIbDatabase);
begin
  FXML := TXMLDocument.Create(nil);
  FXML.ParseOptions := [poResolveExternals, poValidateOnParse];
  FDatabase := ADatabase;
  FIbQuery := Tibquery.Create(nil);
  FIbQuery.Database := FDatabase;
end;

destructor TBLAuto.Destroy;
var
 i : integer;
begin
  FreeAndNil(FXML);
  FreeAndNil(FIbQuery);
  inherited;
end;

function TBLAuto.GenerationRapport(ARapportList: TStringList) : Boolean;
var
  iFic, iPal, iLig, y : Integer;
  sFont : String;
  I: TStringList;
begin
  Result := False;
  if Length(FLstFile) > 0 then
    with ARapportList do
    begin

      Add('<HTML>');
      Add('<head>');
      Add('<title>' + 'Importation ' + Datetostr(Date) + '</title>');

      Add('<style>');
      Add('table.List {');
      Add('    border-collapse: collapse;');
      Add('    width: 100%;');
      Add('    border: 1;');
      Add('}');
      Add('table.List th, table.List td {');
      Add('    text-align: left;');
      Add('    padding: 8px;');
      Add('}');
      Add('table.List tr:nth-child(even) {background-color: #f2f2f2;}');
      Add('</style>');

      Add('</head>');
      Add('<body>');
      Add('<FONT SIZE="-2">');
      Add('Ce document est sauvegardé dans le répertoire de votre importation, il peut être imprimé par le menu fichier imprimer ou par la combinaison de touches CTRL-P<BR>');
      Add('</FONT>');
      Add('<P>');
      Add('<H2><CENTER>' + 'Importation des bons de livraison automatique</CENTER></H2>');
      Add('<H3><CENTER>' + 'Le ' + DateTostr(Date) + '</CENTER></H3>');
      // légende
      Add('<Table>');
      Add('<tr><td><FONT SIZE="2">Légende</FONT></td><td/></tr>');
      Add('<tr><td/><td><font SIZE="-1" color="red">Le fichier a une erreur que le logiciel ne peut pas traiter. Il a été déplacé dans un répertoire REJETES\ANNEE\MOIS\JOUR</font></td></tr>');
      Add('<tr><td/><td><font SIZE="-1" color="blue">Le fichier n''a pas été traité mais il est encore disponible pour un futur traitement.</font></td></tr>');
      Add('<tr><td/><td><font SIZE="-1" color="green">Le fichier a été traité avec succès. Il a été déplacé dans un répertoire INTEGRES\ANNEE\MOIS\JOUR</font></td></tr>');
      Add('</Table>');
      Add('<P><P>');
      //////////
      Add('<table class="List">');
      Add('<tr><th>N° du Bon</th><th>N° de Cde</th><th>Messages</th><th>Marque</th><th>Ref. Marque</th><th>Couleur</th></tr>');
      for iFic := 0 To Length(FLstFile) - 1 do
      begin
        if FLstFile[iFic].NbError = 0 then
          sFont := 'green'
        else
        begin
          if FLstFile[iFic].Archive then
          begin
            sFont := 'red';
            Log.Log('MAIN', GREF, IntToStr(GMAGID), 'STATUS', 'BL -> ' + FLstFile[iFic].ErrorTxt ,logError, False);
          end
          else sFont := 'blue'
        end;

        if FLstFile[iFic].NbError = 0 // N° du Bon
          then Add('<tr><td><font color="'+sFont+'">' + FLstFile[iFic].BL.IDBLF + '</font></td><td/><td><font color="'+sFont+'">Ok</font></td><td/><td/><td/></tr>')
          else Add('<tr><td><font color="'+sFont+'">' + FLstFile[iFic].BL.IDBLF + '</font></td><td/><td><font color="'+sFont+'">'+FLstFile[iFic].ErrorTxt+'</font></td><td/><td/><td/></tr>');

        for iPal := 0 to length(FLstFile[iFic].BL.BLPalettes) -1 do
        begin
          for iLig := 0 to length(FLstFile[iFic].BL.BLPalettes[iPal].BLLignes) - 1 do
          begin
            if FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].Error > 0 then
            begin
              Add('<tr><td/><td>'); // N° de Cde
              Add('<font color="'+sFont+'">'+FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].NUMCDE+'</font>');
              Add('</td><td>'); // Messages
              case FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].Error of
                1:Add('<font color="'+sFont+'">'+Format('Code à barres "%s" non trouvé',[FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS1])+'</font>');
                2:Add('<font color="'+sFont+'">'+Format('Codes à barres "%s" et "%s" non trouvés',[FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS1, FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS2])+'</font>');
                3:Add('<font color="'+sFont+'">'+Format('La taille %s n''est pas une taille travaillée de l''article',[FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].Taille])+'</font>');
              end;
//              if FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS2 = ''
//                then Add('<font color="'+sFont+'">'+Format('Code à barres "%s" non trouvé',[FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS1])+'</font>')
//                else Add('<font color="'+sFont+'">'+Format('Codes à barres "%s" et "%s" non trouvés',[FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS1, FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].EANFRS2])+'</font>');
//
              Add('</td><td>'); // Marque
              Add('<font color="'+sFont+'">'+FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].Marque+'</font>');
              Add('</td><td>'); // RefMarque
              Add('<font color="'+sFont+'">'+FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].RefMarque+'</font>');
              Add('</td><td>'); // Couleur
              Add('<font color="'+sFont+'">'+FLstFile[iFic].BL.BLPalettes[iPal].BLLignes[iLig].Couleur+'</font>');
              Add('</td></tr>');
            end;
          end;
        end;
        Result := True;
      end;
      Add('</table>');
      Add('<P>');
      Add('</body>');
      Add('</HTML>');
    end;
end;

function TBLAuto.GetGenTypeCdv(ACod, ACateg: Integer): Integer;
begin
  with FIbQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select TYP_ID FROM GENTYPCDV');
    SQL.Add('  join K on K_ID = TYP_ID and K_Enabled = 1');
    SQL.Add('Where TYP_COD = :PTYPCOD');
    SQL.Add('  And TYP_CATEG = :PTYPCATEG');
    ParamCheck := True;
    ParamByName('PTYPCOD').AsInteger := ACod;
    ParamByName('PTYPCATEG').AsInteger := ACateg;
    Open;

    if Recordcount > 0 then
      Result := FieldByName('TYP_ID').AsInteger
    else
      raise Exception.Create(Format('GENTYPECDV non trouvé - COD : %d | Categ : %d',[ACod,ACateg]));

  except on E:Exception do
    raise Exception.Create('GetGenTypeCdv -> ' + E.Message);
  end;
end;

function TBLAuto.GetK(ATableName: string): Integer;
begin
  with FIbQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ID FROM PR_NEWK(:PTABLE)');
    ParamCheck := True;
    ParamByName('PTABLE').AsString := ATableName;
    Open;
    Result := FieldByName('ID').AsInteger;
  end;
end;

procedure TBLAuto.ImportBLAuto;
var
  i : Integer;
begin
  // Vérification qu'on est bien en version 17 ou +
  FISV17 := IsFieldExists('BLA_TYPID','RECAUTO');

  FTYPNORMAL := 0;
  FTYPEREASSORT := GetGenTypeCdv(50,10);

  // Récupération des Fichiers
  ScanDirectory;

  for i := 0 to Length(FLstFile) - 1 do
  begin
    // Ouverture du fichier
    OpenFileXml(FLstFile[i]);

    if not FLstFile[i].Archive then
    begin
      // analyse du fichier
      CheckFileXml(FLstFile[i]);
      // Intégration du Fichier

      if FLstFile[i].NbError = 0 then
        AddToDB(FLstFile[i]);
    end;

    // Archivage du fichier
    ArchiveFileXml(FLstFile[i]);
  end;

end;

function TBLAuto.IsFieldExists(AFieldName, ATableName: string): Boolean;
begin
  with FIbQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat from RDB$RELATION_FIELDS');
    SQL.Add('Where RDB$FIELD_NAME = :PFIELDNAME');
    SQL.Add('  And RDB$RELATION_NAME = :PTABLENAME');
    ParamCheck := True;
    ParamByName('PFIELDNAME').AsString := AFieldName;
    ParamByName('PTABLENAME').AsString := ATableName;
    Open;

    Result := FieldByName('Resultat').AsInteger > 0;

  except on E:Exception do
    raise Exception.Create('IsFieldExists -> ' + E.Message);
  end;
end;

procedure TBLAuto.OpenFileXml(var AFile: TFileXml);
var
  nXmlBase, nItemNode, nArtsNode, nArtNode : IXMLNode;
  IdxPalette, IdxLigne : Integer;
  bFound : Boolean;
  sNumPalette : string;

//  Xml : IXmlDOMDOCUMENT2;
begin
  FXML.LoadFromFile(FBlDirectory + AFile.FileName);
  try
    FXML.Active := True;

    nXmlBase := FXML.DocumentElement;
    nItemNode := nXmlBase.ChildNodes['ENTETE'];

    if nItemNode <> Nil then
    begin
      AFile.BL.IDBLF         := XmlStrToStr(nItemNode,'IDBLF');
      AFile.BL.IDFOURNISSEUR := XmlStrToStr(nItemNode,'IDFOURNISSEUR');
      AFile.BL.TRANSPORTEUR  := XmlStrToStr(nItemNode,'TRANSPORTEUR',False);
      AFile.BL.DATELIVRAISON := XmlStrToDate(nItemNode,'DATELIVRAISON');
      AFile.BL.CFOU          := XmlStrToStr(nItemNode,'CFOU',False);
      AFile.BL.LFOU          := XmlStrToStr(nItemNode,'LFOU');
      AFile.BL.IDMAGASIN     := XmlStrToStr(nItemNode, 'IDMAGASIN');
      AFile.BL.NBPal         := XmlStrToInt(nItemNode,'NBPAL', False);
      AFile.BL.NBPaq         := XmlStrToInt(nItemNode,'NBPAQ');
      AFile.BL.NBArt         := XmlStrToInt(nItemNode,'NBART');
      AFile.BL.Comment       := XmlStrToStr(nItemNode, 'COMMENT',False);
      AFile.BL.TypeBL        := XmlStrToInt(nItemNode,'TYPE');

      if not AFile.BL.TypeBL in [0,1] then
        raise Exception.Create('Le type de BL doit être 0 ou 1');

      AFile.NbError := 0;
      AFile.Archive := False;
    end
    else
      raise Exception.Create('Erreur dans les données d''entête');

    nItemNode := nXmlBase.ChildNodes['PAQUETS'];
    nItemNode := nItemNode.ChildNodes.FindNode('PAQUET');
    
    while nItemNode <> Nil do
    begin
     sNumPalette := XmlStrToStr(nItemNode,'NUMPALETTE',False);
     if Trim(sNumPalette) = '' then
       sNumPalette := XmlStrToStr(nItemNode,'NUMPAQ');
     
     if ( AFile.BL.BLPalettes = nil) or (AFile.BL.BLPalettes[High(AFile.BL.BLPalettes)].NUMPALETTE <> sNumPalette) then
     begin
        IdxPalette := Low(AFile.BL.BLPalettes);
        bFound := False;
        while (IdxPalette <= High(AFile.BL.BLPalettes)) and not bFound do
        begin
          if (AFile.BL.BLPalettes <> nil) and (AFile.BL.BLPalettes[IdxPalette].NUMPALETTE = sNumPalette) then
            bFound := True
          else
            Inc(IdxPalette);
        end; // while

        if not bFound then
        begin
          // création d'une nouvelle palette
          SetLength(AFile.BL.BLPalettes,Length(AFile.BL.BLPalettes) + 1);
          IdxPalette := High(AFile.BL.BLPalettes);

          with AFile.BL.BLPalettes[IdxPalette] do
          begin
            NUMPALETTE := sNumPalette;
            NUMPAQ     := XmlStrToStr(nItemNode,'NUMPAQ');
            PAQQTE     := XmlStrToInt(nItemNode,'PAQQTE');
            Univers    := XmlStrToStr(nItemNode,'UNIVERS',False);
            CumulQte := 0;
          end; // with
        end; // if
     end
     else begin
       IdxPalette := High(AFile.BL.BLPalettes);
     end;

      with AFile.BL.BLPalettes[IdxPalette] do
      begin
        nArtsNode := nItemNode.ChildNodes.First;
        while nArtsNode.NodeName <> 'ARTICLES' do
           nArtsNode := nArtsNode.NextSibling;

        nArtNode := nArtsNode.ChildNodes['ARTICLE'];

//        nArtNode.ChildValues['EANFRS1']

        while nArtNode <> nil do
        begin
          SetLength(BLLignes, Length(BLLignes) + 1);
          with BLLignes[High(BLLignes)] do
          begin
            if AFile.BL.TypeBL = 0 then
              NUMCDE  := XmlStrToStr(nArtNode,'NUMCDE',False)
            else begin
              NUMCDE  := XmlStrToStr(nArtNode,'NUMCDE');
            end;

            CodeMovex := XmlStrToStr(nArtNode,'CODE_MOVEX',False);
            EANFRS1 := XmlStrToStr(nArtNode,'EAN1FRS');
            EANFRS2 := XmlStrToStr(nArtNode,'EAN2FRS',False);
            Qte     := XmlStrToInt(nArtNode, 'QTE');
            PXACH   := XmlStrToCurr(nArtNode, 'PXACH');
            PXVTE   := XmlStrToCurr(nArtNode, 'PXVTE');
            PreEtik := XmlStrToInt(nArtNode, 'PREETIK');
            Comment := XmlStrToStr(nArtNode,'COMMENT',False);
            Marque := XmlStrToStr(nArtNode,'MARQUE',False);
            RefMarque := XmlStrToStr(nArtNode,'REFMARQUE',False);
            Couleur := XmlStrToStr(nArtNode,'COULEUR',False);
            // Cumul de la quantité de la palette
            CumulQte := CumulQte + Qte;
          end;
          nArtNode := nArtNode.NextSibling;

        end;

      end;

      nItemNode := nItemNode.NextSibling;
    end;
  except on E:Exception do
    begin
      inc(AFile.NbError);
      AFile.Archive := True;
      AFile.ErrorTxt := {'OpenFile : ' +} E.Message;
    end;
  end;
end;

procedure TBLAuto.ScanDirectory;
var
  i : Integer;
  Search : TSearchRec;
begin

   i := FindFirst(FBlDirectory + '\BLF_*.xml',faAnyFile,Search);
   while i = 0 do
   begin
     SetLength(FLstFile, Length(FLstFile) + 1);
     with FLstFile[High(FLstFile)] do
     begin
       FileName := Search.Name;
       NbError := 0;
       ErrorTxt := '';
     end;

     i := FindNext(Search);
   end;
end;

function TBLAuto.XmlStrToCurr(AValue: IXMLNode; AFieldName: string; APrecision : Integer;
  AErrorOnBlank: Boolean): Currency;
var
  TpS: string;
  TmpExt : Extended;
begin
  try
    if VarIsNull(AValue.ChildValues[AFieldName]) or VarIsType(AValue.ChildValues[AFieldName],varUnknown) then
    begin
      if not AErrorOnBlank then
      begin
        Result := 0;
        Exit;
      end
      else
        raise Exception.Create('Ne doit pas être vide');
    end;
    TpS := AValue.ChildValues[AFieldName];
    if Pos('.',TpS) > 0 then
      TpS[Pos('.',TpS)] := DecimalSeparator;
    if not TryStrToFloat(TpS,TmpExt) then
      raise Exception.Create(Format('La valeur %s n''est pas une valeur numérique correcte',[AValue.ChildValues[AFieldName]]));
    Result := TmpExt;
    if APrecision > 0 then
      Result := Result / Power(10,APrecision);

  except
    on E: Exception do
      raise Exception.Create('Le champ ' + AFieldName + ' a rencontré une erreur : ' + E.Message);
  end;
end;

function TBLAuto.XmlStrToDate(AValue: IXMLNode; AFieldName : string): TDateTime;
var
  d, m, y : Word;
  TpS: string;
begin
  Result := 0.0;
  if not VarIsNull(AValue.ChildValues[AFieldName]) and not VarIsType(AValue.ChildValues[AFieldName],varUnknown) then
  Try
    y := StrToInt(Copy(AValue.ChildValues[AFieldName], 1, 4));
    m := StrToInt(Copy(AValue.ChildValues[AFieldName], 6, 2));
    d := StrToInt(Copy(AValue.ChildValues[AFieldName], 9, 2));
    Result := EncodeDate(y, m, d);
  except on E:Exception do
    raise Exception.Create('Le champ ' + AFieldName + ' a rencontré une erreur : ' + E.Message);
  end;
end;

function TBLAuto.XmlStrToInt(AValue: IXMLNode; AFieldName: string; AErrorOnBlank : Boolean = True): Integer;
begin
  Try
    if Not VarIsNull(AValue.ChildValues[AFieldName]) and not VarIsType(AValue.ChildValues[AFieldName],varUnknown) then
      Result := StrToInt(Trim(AValue.ChildValues[AFieldName]))
    else
      if not AErrorOnBlank then
        Result := 0
      else
        raise Exception.Create('Le champ ne peut pas être vide');
  Except on E:Exception do
    raise Exception.Create('Le champ ' + AFieldName + ' a rencontré une erreur : ' + E.Message);
  End;
end;

function TBLAuto.XmlStrToIntDef(AValue: IXMLNode; AFieldName: string;
  DefaultInt: Integer; AErrorOnBlank : Boolean): Integer;
begin
  Try
    if Not VarIsNull(AValue.ChildValues[AFieldName]) and not VarIsType(AValue.ChildValues[AFieldName],varUnknown) then
      Result := StrToIntDef(Trim(AValue.ChildValues[AFieldName]),DefaultInt)
    else
      if not AerrorOnBlank then
        Result := DefaultInt
      else
        raise Exception.Create('Le champ ne peut pas être vide');
  Except on E:Exception do
    raise Exception.Create('Le champ ' + AFieldName + ' a rencontré une erreur : ' + E.Message);
  End;
end;


function TBLAuto.XmlStrToStr(AValue: IXMLNode; AFieldName : string; AErrorOnBlank : Boolean): string;
begin
  if not VarIsNull(AValue.ChildValues[AFieldName]) and not VarIsType(AValue.ChildValues[AFieldName],varUnknown) then
    Result := Trim(AValue.ChildValues[AFieldName])
  else
    if not AErrorOnBlank then
      Result := ''
    else
      raise Exception.Create('Le champ ' + AFieldName + ' ne doit pas être vide');
end;

end.

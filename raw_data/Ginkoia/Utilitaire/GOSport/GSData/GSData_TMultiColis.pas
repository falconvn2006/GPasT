unit GSData_TMultiColis;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types, GSDataImport_DM, StrUtils,
     DBClient, SysUtils, IBODataset, Db, Variants, Classes;

type
  TMulticolis = class(TMainClass)
    private
      FCOLISENTETE : TMainClass;
      FCOLISLIGNE  : TMainClass;
      DS_COLISENTETE : TDataSource;

      FCOLISLIGNETMP : TMainClass;

      FMULTICOLIS_File : String;

      vgStrlIdASupprimer : TStringList;

      FRelationArticle: TMainClass;

      // Création / Mise à jour de l'entête de multicolis
      function SetMULTICOENTETE(AMCE_NUM, AMCE_LIBELLE : String; AMCE_DTVAL : TDate) : Integer;
      // Création des lignes de multicolis
      function SetMULTICOLIGNE(AMCL_MCEID, AMCL_ARTID, AMCL_TGFID, AMCL_COUID : Integer) : Integer;
      // Vérification et mise à jour du champ ART_MULTICO
      procedure SetArticleMultiCo(AMAG_ID, AMCL_ARTID, AMCL_TGFID, AMCL_COUID : integer);
    public
      procedure Import; override;
      function  DoMajTable : Boolean; override;

      Constructor Create; override;
      Destructor  Destroy; override;
    published
      property RelationArticle : TMainClass read FRelationArticle write FRelationArticle;
  end;


implementation


uses GSDataMain_DM;

Constructor TMulticolis.Create;
begin
  Inherited;

  FCOLISENTETE := TMainClass.Create;
  DS_COLISENTETE := TDataSource.Create(nil);
  DS_COLISENTETE.DataSet := FCOLISENTETE.ClientDataset;
  FCOLISLIGNE  := TMainClass.Create;

  FCOLISLIGNETMP := TMainClass.Create;

  vgStrlIdASupprimer := TStringList.Create;
end;

Destructor TMulticolis.Destroy;
begin
  vgStrlIdASupprimer.Clear;
  vgStrlIdASupprimer.Free;

  FCOLISLIGNE.Free;
  FCOLISLIGNETMP.Free;
  FCOLISENTETE.Free;

  Inherited;
end;

procedure TMultiColis.Import;
var
  vOldNum, vNewNum, vNumero   : Integer;
  vARTID, vTGFID, vCOUID, vIx : Integer;

  Article : TCodeArticle;
  vErreur  : TErreur;
  vPrefixe : String;
begin

  {$REGION ' Mise du nom de fichier en variable générale'}
  for vIx := Low(FilesPath) to High(FilesPath) do
  begin
    vPrefixe := Copy(FilesPath[vIx],1,6);
    case AnsiIndexStr(UpperCase(vPrefixe),['MULTCO']) of
      0 : FMULTICOLIS_File := FilesPath[vIx];
    end;
  end;
  {$ENDREGION 'Mise du nom de fichier en variable générale'}

  {$REGION ' Initialisation des CDS et des tables'}
  // Création du CDS COLISENTETE (venant du fichier) en mémoire
  FCOLISENTETE.CreateField(['MCE_ID', 'MCE_NUM', 'MCE_LIBELLE',
                            'MCE_DTVAL', 'Error'],
                           [ftInteger, ftString, ftString,
                            ftDate, ftInteger]);
  FCOLISENTETE.ClientDataset.AddIndex('Idx','MCE_NUM',[]);
  FCOLISENTETE.ClientDataset.IndexName := 'Idx';

  // Création du CDS COLISLIGNE (venant du fichier) en mémoire
  FCOLISLIGNE.CreateField(['MCL_ID', 'MCE_NUM', 'MCL_ARTID', 'MCL_TGFID',
                           'MCL_COUID', 'ACTIONTABLE', 'NBLIGNE'],
                           [ftInteger, ftInteger, ftInteger, ftInteger,
                            ftInteger, ftInteger, ftInteger]);
  FCOLISLIGNE.ClientDataset.AddIndex('Idx','MCE_NUM',[]);
  FCOLISLIGNE.ClientDataset.IndexName := 'Idx';
  FCOLISLIGNE.ClientDataset.MasterFields := 'MCE_NUM';
  FCOLISLIGNE.ClientDataset.MasterSource := DS_COLISENTETE;


  FCOLISLIGNETMP.CreateField(['MCL_ID','MCL_MCEID','MCL_ARTID','MCL_TGFID','MCL_COUID','CANDELETE'],
                             [ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger]);
  {$ENDREGION 'Initialisation des CDS'}

  LabCaption('Importation du fichier ' + FMULTICOLIS_File);
  BarPosition(0);

  with DM_GSDataImport.cds_MULTCO do
  begin
    First;

    while not EOF do
    begin
      try
        try
          // traitement de l'entête
          if not FCOLISENTETE.ClientDataset.Locate('MCE_NUM',FieldByName('NUM').AsString,[loCaseInsensitive]) then
          begin
            FCOLISENTETE.Append;
            FCOLISENTETE.FieldByName('MCE_ID').AsInteger      := 0;
            FCOLISENTETE.FieldByName('MCE_NUM').AsString      := FieldByName('NUM').AsString;
            FCOLISENTETE.FieldByName('MCE_LIBELLE').AsString  := FieldByName('LIB').AsString;
            FCOLISENTETE.FieldByName('MCE_DTVAL').AsDateTime  := FieldByName('DTVAL').AsDateTime;
            FCOLISENTETE.FieldByName('Error').AsInteger       := 0;
            FCOLISENTETE.Post;
          end;
        Except on E:Exception do
          begin
            if FCOLISENTETE.ClientDataset.State in [dsInsert] then
            begin
              FCOLISENTETE.FieldByName('Error').AsInteger := 1;
              FCOLISENTETE.Post;
            end;

            raise Exception.Create('Entête : ' + E.Message);
          end;
        end;
                        
        Try
          // Récupération des informations sur l'article
          if RelationArticle.ClientDataset.Active and RelationArticle.ClientDataset.Locate('CODE_ARTICLE',FieldByName('CODE_ART').AsString,[locaseinsensitive]) then
          begin
            Article.ART_ID := RelationArticle.FieldByName('ARA_ARTID').AsInteger;
            Article.TGF_ID := RelationArticle.FieldByName('ARA_TGFID').AsInteger;
            Article.COU_ID := RelationArticle.FieldByName('ARA_COUID').AsInteger;
            // il arrive parfois que la donnée en mémoire retourne 0, il faut donc chercher dans la base
            if (Article.ART_ID = 0) or (Article.TGF_ID = 0) or (Article.COU_ID = 0) then
              Article := GetCodeArticle(FieldByName('CODE_ART').AsString);  
          end
          else begin
            Article := GetCodeArticle(FieldByName('CODE_ART').AsString)
          end;

          // Traitement des lignes
          if FCOLISLIGNE.ClientDataset.Locate('MCL_ARTID;MCL_TGFID;MCL_COUID',
                                   VarArrayOf([Article.ART_ID,
                                               Article.TGF_ID,
                                               Article.COU_ID]),[]) then
          begin
            FCOLISLIGNE.Edit;
            FCOLISLIGNE.FieldByName('NBLIGNE').AsInteger := FCOLISLIGNE.FieldByName('NBLIGNE').AsInteger + 1;
            FCOLISLIGNE.Post;
          end
          else begin
            FCOLISLIGNE.Append;
            FCOLISLIGNE.FieldbyName('MCL_ARTID').AsInteger := Article.ART_ID;
            FCOLISLIGNE.FieldByName('MCL_TGFID').AsInteger := Article.TGF_ID;
            FCOLISLIGNE.FieldByName('MCL_COUID').AsInteger := Article.COU_ID;
            FCOLISLIGNE.FieldByName('NBLIGNE').AsInteger   := 1;
            FCOLISLIGNE.FieldByName('MCE_NUM').AsString    := FCOLISENTETE.FieldByName('MCE_NUM').AsString;
            FCOLISLIGNE.Post;
          end;
        Except on E:Exception do
          begin
            FCOLISENTETE.Edit;
            FCOLISENTETE.FieldByName('Error').AsInteger := 1;
            FCOLISENTETE.Post;

            raise Exception.Create('Lignes : ' + E.Message);
          end;
        End;
      except on E: Exception do
       begin
         vErreur := TErreur.Create;
         vErreur.AddError(FMULTICOLIS_File,'Import',E.Message,RecNo,teMultiColis,0,'');
         GERREURS.Add(vErreur);
         IncError ;
       end;
      end;
      Next;
      BarPosition(RecNo * 100 Div RecordCount);
    end;
  end;
end;

procedure TMulticolis.SetArticleMultiCo(AMAG_ID,AMCL_ARTID, AMCL_TGFID,
  AMCL_COUID: integer);
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.add('SELECT * from GOS_SETMULTICOVERIF(:PMAGID, :PARTID, :PTGFID, :PCOUID)');
    ParamCheck := True;
    ParamByName('PMAGID').AsInteger := AMAG_ID;
    ParamByName('PARTID').AsInteger := AMCL_ARTID;
    ParamByName('PTGFID').AsInteger := AMCL_TGFID;
    ParamByName('PCOUID').AsInteger := AMCL_COUID;
    Open;

    if Recordcount > 0 then
    begin
      Inc(FMajcount,FieldByName('FMAJ').AsInteger);
    end;
  except on E: Exception do
    raise Exception.Create('SetArticleMultiCo -> ' + E.Message);
  end;
end;

function TMulticolis.SetMULTICOENTETE(AMCE_NUM, AMCE_LIBELLE: String;
  AMCE_DTVAL: TDate): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETMULTICOENTETE(:PMCENUM, :PMCELIBELLE, :PMCEDTVAL)');
    ParamCheck := True;
    ParamByName('PMCENUM').AsString := AMCE_NUM;
    ParamByName('PMCELIBELLE').AsString := AMCE_LIBELLE;
    ParamByName('PMCEDTVAL').AsDate := AMCE_DTVAL;
    Open;

    if Recordcount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajcount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('MCE_ID').AsInteger;
    end;
  except on E: Exception do
    raise Exception.Create('SetMULTICOENTETE -> ' + E.Message);
  end;

end;

function TMulticolis.SetMULTICOLIGNE(AMCL_MCEID, AMCL_ARTID, AMCL_TGFID,
  AMCL_COUID: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETMULTICOLIGNE(:PMCEID, :PARTID, :PTGFID, :PCOUID)');
    ParamCheck := true;
    ParamByName('PMCEID').AsInteger := AMCL_MCEID;
    ParamByName('PARTID').AsInteger := AMCL_ARTID;
    ParamByName('PTGFID').AsInteger := AMCL_TGFID;
    ParamByName('PCOUID').AsInteger := AMCL_COUID;
    Open;

    if Recordcount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Result := FieldByName('MCL_ID').AsInteger;
    end;
  except on E: Exception do
    raise Exception.Create('SetMULTICOLIGNE -> ' + E.Message);
  end;
end;

function TMulticolis.DoMajTable : Boolean;
var
//  vTypeAction : TTypeActionTable;
//  vNumero     : Integer;
  MCE_ID : Integer;
  i : integer;
  vErreur : TErreur;
begin
  FCOLISENTETE.ClientDataset.Filtered := False;
  FCOLISENTETE.ClientDataset.Filter := 'Error = 0';
  FCOLISENTETE.ClientDataset.Filtered := True;

  FCOLISENTETE.First;
  while not FCOLISENTETE.EOF do
  begin
    FIboQuery.IB_Transaction.StartTransaction;
    try
      // Création/Mise à jour de l'entête de multicolis
      MCE_ID := SetMULTICOENTETE(
                                 FCOLISENTETE.FieldByName('MCE_NUM').AsString,     // AMCE_NUM,
                                 FCOLISENTETE.FieldByName('MCE_LIBELLE').AsString, // AMCE_LIBELLE: String;
                                 FCOLISENTETE.FieldByName('MCE_DTVAL').AsDateTime  // AMCE_DTVAL: TDate
                                );

      {$REGION 'Récupération des lignes déjà existante du multicolis'}
      With FIboQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select MCL_ID, MCL_ARTID, MCL_TGFID, MCL_COUID from MULTICOLIGNE');
        SQL.Add('  Join K on K_ID = MCL_ID and K_enabled = 1');
        SQL.Add('Where MCL_MCEID = :PMCEID');
        ParamCheck := True;
        ParamByName('PMCEID').AsInteger := MCE_ID;
        Open;

        FCOLISLIGNETMP.ClientDataset.EmptyDataSet;
        while not EOF do
        begin
          FCOLISLIGNETMP.Append;
          FCOLISLIGNETMP.FieldByName('MCL_ID').AsInteger := FieldByName('MCL_ID').AsInteger;
          FCOLISLIGNETMP.FieldByName('MCL_ARTID').AsInteger := FieldByName('MCL_ARTID').AsInteger;
          FCOLISLIGNETMP.FieldByName('MCL_TGFID').AsInteger := FieldByName('MCL_TGFID').AsInteger;
          FCOLISLIGNETMP.FieldByName('MCL_COUID').AsInteger := FieldByName('MCL_COUID').AsInteger;
          FCOLISLIGNETMP.FieldByName('CANDELETE').AsInteger := 1;
          FCOLISLIGNETMP.Post;

          Next;
        end;
      end;
      {$ENDREGION}

      // traitement des lignes du multicolis
      FCOLISLIGNE.First;
      while not FCOLISLIGNE.EOF do
      begin
        // Traitement de toutes les lignes
        for I := 1 to FCOLISLIGNE.FieldByName('NBLIGNE').AsInteger do
        begin
          // Est ce que la ligne existe déjà dans la liste temporaire des lignes du multicolis ?
          if FCOLISLIGNETMP.ClientDataset.Locate('MCL_ARTID;MCL_TGFID;MCL_COUID;CANDELETE',
                                      VarArrayOf([FCOLISLIGNE.FieldByName('MCL_ARTID').AsInteger,
                                                  FCOLISLIGNE.FieldByName('MCL_TGFID').AsInteger,
                                                  FCOLISLIGNE.FieldByName('MCL_COUID').AsInteger,
                                                  1]),[]) then
          begin
            // Oui alors on déflag la ligne en question
            FCOLISLIGNETMP.Edit;
            FCOLISLIGNETMP.FieldByName('CANDELETE').AsInteger := 0;
            FCOLISLIGNETMP.Post;
          end
          else begin
            // Non alors on va créer la ligne
            SetMULTICOLIGNE(
                            MCE_ID, //  AMCL_MCEID,
                            FCOLISLIGNE.FieldByName('MCL_ARTID').AsInteger, // AMCL_ARTID,
                            FCOLISLIGNE.FieldByName('MCL_TGFID').AsInteger, // AMCL_TGFID,
                            FCOLISLIGNE.FieldByName('MCL_COUID').AsInteger  // AMCL_COUID: Integer
                           );
          end;
        end;

        // Pour chaque ligne on va vérifier son type dans la table article
        // ART_MULTICOLI 1 pour principal / 2 pour secondaire
        SetArticleMultiCo(
                          MAG_ID,                                         // AMAG_ID,
                          FCOLISLIGNE.FieldByName('MCL_ARTID').AsInteger, // AMCL_ARTID,
                          FCOLISLIGNE.FieldByName('MCL_TGFID').AsInteger, // AMCL_TGFID,
                          FCOLISLIGNE.FieldByName('MCL_COUID').AsInteger  // AMCL_COUID: Integer
                         );

        FCOLISLIGNE.Next;
      end;

      // Suppréssion des lignes qui n'ont pas été traité
      FCOLISLIGNETMP.ClientDataset.Filtered := false;
      FCOLISLIGNETMP.ClientDataset.Filter := 'CANDELETE = 1';
      FCOLISLIGNETMP.ClientDataset.Filtered := True;

      FCOLISLIGNETMP.First;
      With FIboQuery do
      begin
        while not FCOLISLIGNETMP.EOF do
        begin
          Close;
          SQL.Clear;
          SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PID,1)');
          ParamCheck := True;
          ParamByName('PID').AsInteger := FCOLISLIGNETMP.FieldByName('MCL_ID').AsInteger;
          ExecSQL;

          FCOLISLIGNETMP.Next;
        end;
      end;

      FIboQuery.IB_Transaction.Commit;

    Except on E:Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;

        vErreur := TErreur.Create;
        vErreur.AddError(FMULTICOLIS_File,'Intégration',E.Message,0,teMultiColis,0,'');
        GERREURS.Add(vErreur);
        IncError ;
      end;
    end;
    FCOLISENTETE.Next;
  end;
end;

end.

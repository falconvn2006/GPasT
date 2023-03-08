unit uImportRapprochement;

interface
uses uGestionBDD,sysutils, Db, Math, types, FireDAC.Stan.Intf, ulog;

Type
  TProcLogMulti = procedure (Msg : string; level : TLogLevel; Ovl : boolean = false) of object;

  TImportRapprochement = class
    private
      FConnGnk, FConnTpn : TMyConnection;
      FTransGnk, FTransTpn, FTransLog : TMyTransaction;
      QryTpnLog, QryTpnErr : TMyQuery;

      F_MAIN_GENERATOR,
      F_VRECEPT_ENTETEISF,
      F_VRECEPT_LIGNEISF,
      F_VRETOUR_ENTETEISF,
      F_VRETOUR_LIGNEISF,
      F_VACH_ENTETEISF,
      F_VACH_RELATIONISF,
      F_VACH_TVAISF : Integer;

      FProcLog : TProcLogMulti;
      FLogRef: String;
      FLogKey: String;
      FLogModule: String;

      procedure SetGenerateur(ATableName : String; AValue : Integer);

      procedure LogInteg(AMAG_ID, ATypeDoc, AIdLigne : Integer; ALOGMessage : String; ASens : Integer);
    public
      constructor Create(AConnexionGnk, AConnexionTpn : TMyConnection; ATransactionGnk, ATransactionTpn : TMyTransaction);
      destructor destroy;override;

      procedure GetGenerateurs;
      procedure ImportReception;
      procedure ImportBonRetour;
      procedure ImportRapprochement;

      property DoLogMulti : TProcLogMulti read FProcLog write FProcLog;

      property LogModule : String read FLogModule write FLogModule;
      property LogRef : String read FLogRef write FLogRef;
      property LogKey : String read FLogKey write FLogKey;

  end;


implementation

constructor TImportRapprochement.Create(AConnexionGnk,
  AConnexionTpn: TMyConnection; ATransactionGnk,
  ATransactionTpn: TMyTransaction);
begin
  FConnGnk := AConnexionGnk;
  FConnTpn := AConnexionTpn;

  FTransGnk := ATransactionGnk;
  FTransTpn := ATransactionTpn;

  // Pour la gestion des logs en base de données
  FTransLog := GetNewTransaction(FConnTpn);
  QryTpnLog := GetNewQuery(FConnTpn,FTransLog);
  QryTpnErr := GetNewQuery(FConnTpn,FTransLog);
end;

destructor TImportRapprochement.destroy;
begin
  FreeAndnil(QryTpnLog);

  inherited;
end;

procedure TImportRapprochement.GetGenerateurs;

  function GetGenerateur(ANomTable : String) : integer;
  var
    QryTpn : TMyQuery;
  begin
    QryTpn := GetNewQuery(FConnTpn,FTransTpn);
    Try
      QryTpn.SQL.Clear;
      QryTpn.SQL.Add('Select VERLASTVERSION from TVERSION');
      QryTpn.SQL.Add('Where VERNOMTABLE = :PNOMTABLE');
      QryTpn.ParamByName('PNOMTABLE').AsString := ANomTable;
      QryTpn.Open();
      if QryTpn.RecordCount > 0 then
        Result := QryTpn.FieldByName('VERLASTVERSION').AsInteger
      else begin
        // Création du générateur
        FTransTpn.StartTransaction;
        QryTpn.Close;
        QryTpn.SQL.Clear;
        QryTpn.SQL.Add('INSERT INTO TVERSION(VERMAGID,VERNOMTABLE,VERLASTVERSION)');
        QryTpn.SQL.Add('VALUES (0, :PVERNOM, 0)');
        QryTpn.ParamByName('PVERNOM').AsString := ANomTable;
        QryTpn.ExecSQL;
        FTransTpn.Commit;
//        raise Exception.Create('Nom table non trouvé : ' + ANomTable);
      end;
    Finally
      QryTpn.Close;
      FreeAndNil(QryTpn);
    End;
  end;
var
  QryTpn : TMyQuery;
begin
  FProcLog('-----------------------------------' + #13#10 +
           'Récupération des générateurs' + #13#10 +
           '-----------------------------------',logDebug);

  // Récupération du générateur principal
  QryTpn := GetNewQuery(FConnTpn,FTransTpn);
  Try
    QryTpn.SQL.Add('Select GEN_ID(GENIMPRAPP,0) as MainGenerator from RDB$database;');
    QryTpn.Open();
    F_MAIN_GENERATOR := QryTpn.FieldByName('MainGenerator').AsInteger;
    FProcLog(format('Générateur principal : %d', [F_MAIN_GENERATOR]),logDebug);
  Finally
    QryTpn.Close;
    FreeAndNil(QryTpn);
  End;

  // Récupération des dernières positions des tables
  F_VRECEPT_ENTETEISF := GetGenerateur('TRECEPTIONENTETE_ISF');
  FProcLog(format('Reception Entete : %d', [F_VRECEPT_ENTETEISF]),logDebug);
  F_VRECEPT_LIGNEISF  := GetGenerateur('TRECEPTIONLIGNE_ISF');
  FProcLog(format('Reception Ligne : %d', [F_VRECEPT_LIGNEISF]),logDebug);
  F_VRETOUR_ENTETEISF := GetGenerateur('TRETOURENTETE_ISF');
  FProcLog(format('Retour Entete : %d', [F_VRETOUR_ENTETEISF]),logDebug);
  F_VRETOUR_LIGNEISF  := GetGenerateur('TRETOURLIGNE_ISF');
  FProcLog(format('Retour Ligne : %d', [F_VRETOUR_LIGNEISF]),logDebug);
  F_VACH_ENTETEISF    := GetGenerateur('TACHENTETE_ISF');
  FProcLog(format('Rapprochement Entete : %d', [F_VACH_ENTETEISF]),logDebug);
  F_VACH_RELATIONISF  := GetGenerateur('TACHENTVA_ISF');
  FProcLog(format('Rapprochement Relation : %d', [F_VACH_RELATIONISF]),logDebug);
  F_VACH_TVAISF       := GetGenerateur('TACHRELATION_ISF');
  FProcLog(format('Rapprochement TVA : %d', [F_VACH_TVAISF]),logDebug);
end;

procedure TImportRapprochement.ImportBonRetour;
var
  QryGnk, QryGnkUpd, QryTpnEntete, QryTpnLigne, QryTpnTva : TMyQuery;
  DsTpnEntete : TDataSource;
  i, IDEntete, IDLigne, iExeID, iCPAID, iMRGID, iCOLID, iMdcRecVersionLigne : integer;

begin
  // Récupération des réceptions à traiter
  QryTpnEntete        := GetNewQuery(FConnTpn,FTransTpn);
  DsTpnEntete := TDataSource.Create(nil);
  DsTpnEntete.DataSet := QryTpnEntete;
  QryTpnLigne         := GetNewQuery(FConnTpn,FTransTpn);
  QryTpnTva           := GetNewQuery(FConnTpn,FTransTpn);
  QryGnk              := GetNewQuery(FConnGnk,FTransGnk);
  QryGnkUpd           := GetNewQuery(FConnGnk,FTransGnk);

  Try

    FProcLog('-- Traitement des bons de retour --',logDebug);

    {$REGION 'Récupération des entêtes'}
    with QryTpnEntete do
    begin
      SQL.Clear;
      SQL.Add('Select * from TRETOUR_ENTETE');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  And SENS = 1 and VALIDER = 1');
      SQL.Add('ORDER BY MDFRECVERSION');
      ParamByName('PMINID').AsInteger := F_VRETOUR_ENTETEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','MDFRECVERSION;RETID;RETNUMFOURN','MDFRECVERSION',[]);
      IndexName := 'Idx';
      FProcLog(Format('Nombre de document à traiter : %d',[RecordCount]),logDebug);
    end;
    {$ENDREGION}

    {$REGION 'Récupération des lignes'}
    With QryTpnLigne do
    begin
      SQL.Clear;
      SQL.Add('Select * from TRETOUR_LIGNE');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  and SENS = 1 and VALIDER = 1');
      ParamByName('PMINID').AsInteger := F_VRETOUR_LIGNEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','RETID;RETNUMFOURN','',[]);
      IndexName := 'Idx';
//      MasterFields := 'RETID;RETNUMFOURN';
//      MasterSource := DsTpnEntete;
    end;
    {$ENDREGION}

    {$REGION 'Récupération des TVA'}
    With QryTpnTva do
    begin
      SQL.Clear;
      SQL.Add('Select TRETOUR_TVA.* from TRETOUR_TVA');
      SQL.Add('  join TRETOUR_ENTETE on (TRETOUR_TVA.RETNUMFOURN = TRETOUR_ENTETE.RETNUMFOURN');
      SQL.Add('                     and TRETOUR_TVA.RETID = TRETOUR_ENTETE.RETID)');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  And TRETOUR_ENTETE.SENS = 1 and VALIDER = 1 and TRETOUR_TVA.SENS = 1');
      ParamByName('PMINID').AsInteger := F_VRETOUR_ENTETEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','RETID;RETNUMFOURN;RETTAUX','RETTAUX',[soDescending]);
      IndexName := 'Idx';
//      MasterFields := 'RETID;RETNUMFOURN';
//      MasterSource := DsTpnEntete;
    end;
    {$ENDREGION}

    // Intégration dans la base ginkoia.
    QryTpnEntete.First;
    while not QryTpnEntete.Eof do
    begin
      try
        FProcLog(Format('Retour |Document  : %s |MAG : %d | Début traitement',[QryTpnEntete.FieldByName('RETNUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger]),logDebug);

        // Filtre des lignes et TVA
        QryTpnLigne.Filtered := False;
        QryTpnLigne.Filter := Format('RETID = %d AND RETNUMFOURN = %s',[QryTpnEntete.FieldByName('RETID').AsInteger, QuotedStr(QryTpnEntete.FieldByName('RETNUMFOURN').AsString)]);
        QryTpnLigne.Filtered := True;

        QryTpnTva.Filtered := False;
        QryTpnTva.Filter := Format('RETID = %d AND RETNUMFOURN = %s',[QryTpnEntete.FieldByName('RETID').AsInteger, QuotedStr(QryTpnEntete.FieldByName('RETNUMFOURN').AsString)]);
        QryTpnTva.Filtered := True;

        FTransGnk.StartTransaction;
        FTransTpn.StartTransaction;

        if QryTpnEntete.FieldByName('RETID').AsInteger = 0 then
        begin
          {$REGION 'Recherche des informations d''entête'}
          // Vérification du type de la première ligne.
//          QryTpnLigne.First;
//
//          With QryGnk do
//          begin
//            SQL.Clear;
//            SQL.Add('SELECT RET_MRGID');
//            SQL.Add('From COMRETOUR join COMRETOURL on REL_RETID = RET_ID');
//            SQL.Add('Where REL_ID = :PRELID');
//            ParamByName('PRELID').AsInteger := // ????;
//            Open;
//
//            iMRGID := FieldByName('RET_MRGID').AsInteger;
//            Close;
//          end;
          iMRGID := 0;
          {$ENDREGION}

          {$REGION 'Création d''un Bon de retour'}
          // Création de l'entête
          Try
            With QryGnk do
            begin
              SQL.Clear;
              SQL.Add('SELECT RET_ID FROM BI15_RAPP_NEWCOMRETOUR(:PMAGID, :PFOUID, :PRETNUMFOURN, :PRETDATE,');
              for i := 1 to 5 do
                SQL.Add(Format(':PRETTVAHT%0:d, :PRETTVATAUX%0:d, :PRETTVA%0:d,',[i]));
              SQL.Add(':PMRGID)');
              ParamByName('PMAGID').AsInteger := QryTpnEntete.FieldByName('MAGID').AsInteger;
              ParamByName('PFOUID').AsInteger := QryTpnEntete.FieldByName('FOUID').AsInteger;
              ParamByName('PRETNUMFOURN').AsString := QryTpnEntete.FieldByName('RETNUMFOURN').AsString;
              ParamByName('PRETDATE').AsDate := QryTpnEntete.FieldByName('RETDATE').AsDateTime;

              QryTpnTva.First;
              for i := 1 to 5 do
              begin
                if not QryTpnTva.Eof then
                begin
                  ParamByName('PRETTVAHT' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('RETMTHT').AsCurrency;
                  ParamByName('PRETTVATAUX' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('RETTAUX').AsCurrency;
                  ParamByName('PRETTVA' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('RETTVA').AsCurrency;
                  QryTpnTva.Next;
                end
                else begin
                  ParamByName('PRETTVAHT' + IntToStr(i)).AsCurrency := 0;
                  ParamByName('PRETTVATAUX' + IntToStr(i)).AsCurrency := 0;
                  ParamByName('PRETTVA' + IntToStr(i)).AsCurrency := 0;
                end;
              end;
              ParamByName('PMRGID').AsInteger := iMRGID;
              Open;
              // récupération de l'ID de l'entête nouvellement créé.
              IdEntete := FieldByname('RET_ID').AsInteger;

              Close;
            end;
          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnEntete.FieldByName('IDREF').AsInteger,'BI15_RAPP_NEWCOMRETOUR : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_NEWCOMRETOUR |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('RETNUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
              raise;
            end;
          End;

          // création des lignes
          QryTpnLigne.First;
          iMdcRecVersionLigne := QryTpnLigne.FieldByName('MDFRECVERSION').AsInteger;
          while not QryTpnLigne.Eof do
          begin
            Try
              With QryGnk do
              begin
                SQL.Clear;
                SQL.Add('SELECT REL_ID from BI15_RAPP_NEWCOMRETOURL(:PRELRETID,');
                SQL.Add(':PRELARTID, :PRELTGFID, :PRELCOUID, :PRELQTE, :PRELPX, :PRELTVA)');
                ParamByName('PRELRETID').AsInteger := IdEntete;
                ParamByName('PRELARTID').AsInteger := QryTpnLigne.FieldByName('MODID').AsInteger;
                ParamByName('PRELTGFID').AsInteger := QryTpnLigne.FieldByName('TGFID').AsInteger;
                ParamByName('PRELCOUID').AsInteger := QryTpnLigne.FieldByName('COUID').AsInteger;
                ParamByName('PRELQTE').AsInteger   := QryTpnLigne.FieldByName('RELQTE').AsInteger;
                ParamByName('PRELPX').AsCurrency := QryTpnLigne.FieldByName('RELPX').AsCurrency;
                ParamByName('PRELTVA').AsCurrency := QryTpnLigne.FieldByName('RELTVA').AsCurrency;
                Open;
              end;

              QryTpnLigne.Next;
            Except on E:Exception do
              begin
                LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnLigne.FieldByName('IDREF').AsInteger, 'BI15_RAPP_NEWCOMRETOURL : ' + E.Message, 1);
                FProcLog(Format('BI15_RAPP_NEWCOMRETOURL |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('RETNUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
                raise;
              end;
            End;

          end;
          {$ENDREGION}
        end
        else begin
          // Mise à jour d'un bon de retour

          // traitement des lignes
          QryTpnLigne.First;
          iMdcRecVersionLigne := QryTpnLigne.FieldByName('MDFRECVERSION').AsInteger;
          while not QryTpnLigne.Eof do
          begin
            Try
            {$REGION 'Mise à jour de la ligne du bon de retour'}
            With QryGnkUpd do
            begin
              SQL.Clear;
              SQL.Add('EXECUTE PROCEDURE BI15_RAPP_UPDCOMRETOURL (:PRELID, :PRELQTE, :PRELPX)');
              ParamByName('PRELQTE').AsCurrency := QryTpnLigne.FieldByName('RELQTE').AsCurrency;
              ParamByName('PRELPX').AsCurrency  := QryTpnLigne.FieldByName('RELPX').AsCurrency;
              ParamByName('PRELID').AsInteger   := QryTpnLigne.FieldByName('RELID').AsInteger;
              ExecSQL;
            end;
            {$ENDREGION}
            QryGnk.Close;
            QryTpnLigne.Next;
            Except on E:Exception do
              begin
                LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnEntete.FieldByName('IDREF').AsInteger,'BI15_RAPP_UPDCOMRETOURL : ' + E.Message, 1);
                FProcLog(Format('BI15_RAPP_UPDCOMRETOURL |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('RETNUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
                Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
                raise;
              end;
            End;
          end;

          {$REGION 'Traitement de l''entête'}
          try
          With QryGnk do
          begin
            SQL.Clear;
            SQL.Add('EXECUTE PROCEDURE BI15_RAPP_UPDCOMRETOUR(:PRETID,');
            SQL.Add(' :PRETTVAHT1, :PRETTVATAUX1, :PRETTVA1, :PRETTVAHT2, :PRETTVATAUX2, :PRETTVA2,');
            SQL.Add(' :PRETTVAHT3, :PRETTVATAUX3, :PRETTVA3, :PRETTVAHT4, :PRETTVATAUX4, :PRETTVA4,');
            SQL.Add(' :PRETTVAHT5, :PRETTVATAUX5, :PRETTVA5)');
            ParamByName('PRETID').AsInteger := QryTpnEntete.FieldByName('RETID').AsInteger;

            QryTpnTva.First;
            for i := 1 to 5 do
            begin
              if not QryTpnTva.Eof then
              begin
                ParamByName('PRETTVAHT' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('RETMTHT').AsCurrency;
                ParamByName('PRETTVATAUX' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('RETTAUX').AsCurrency;
                ParamByName('PRETTVA' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('RETTVA').AsCurrency;
                QryTpnTva.Next;
              end
              else begin
                ParamByName('PRETTVAHT' + IntToStr(i)).AsCurrency := 0;
                ParamByName('PRETTVATAUX' + IntToStr(i)).AsCurrency := 0;
                ParamByName('PRETTVA' + IntToStr(i)).AsCurrency := 0;
              end;
            end;
            ExecSQL();
          end;
          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnEntete.FieldByName('IDREF').AsInteger,'BI15_RAPP_UPDCOMRETOUR : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_UPDCOMRETOUR |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('RETNUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
              raise;
            end;
          end;
          {$ENDREGION}
        end;

        // Mise à jour du générateur des lignes
        SetGenerateur('TRETOURLIGNE_ISF', iMdcRecVersionLigne);

        // Mise à jour du générateur de l'entête
        SetGenerateur('TRETOURENTETE_ISF',QryTpnEntete.FieldByName('MDFRECVERSION').AsInteger);

        FTransGnk.Commit;
        FTransTpn.Commit;

        FProcLog(Format('Retour |Document  : %s |MAG : %d | Fin traitement OK',[QryTpnEntete.FieldByName('RETNUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger]),logDebug);

      Except on E:Exception do
        begin
          FTransGnk.Rollback;
          FTransTpn.Rollback;

          {$REGION  'Mise à jour du MDFRECVERSION de l''entête et des lignes du doc en erreur'}
          With QryTpnErr do
          Begin
            FTransTpn.StartTransaction;
            // Mise à jour Entête
            Close;
            SQL.Clear;
            SQL.Add('UPDATE RETOUR_ENTETE SET MDFRECVERSION = GEN_ID(GENIMPRAPP,1)');
            SQL.Add('Where RETID = :PRETID AND RETNUMFOURN = :PRETNUMFOURN AND SENS = 1');
            ParamByName('PRETNUMFOURN').AsString := QryTpnEntete.FieldByName('RETNUMFOURN').AsString;
            ParamByName('PRETID').AsInteger := QryTpnEntete.FieldByName('RETID').AsInteger;
            ExecSQL;

            // Mise à jour Lignes
            Close;
            SQL.Clear;
            SQL.Add('UPDATE RETOUR_LIGNE SET MDFRECVERSION = GEN_ID(GENIMPRAPP,0)');
            SQL.Add('Where RETID = :PRETID AND RETNUMFOURN = :PRETNUMFOURN AND SENS = 1');
            ParamByName('PRETNUMFOURN').AsString := QryTpnEntete.FieldByName('RETNUMFOURN').AsString;
            ParamByName('PRETID').AsInteger := QryTpnEntete.FieldByName('RETID').AsInteger;
            ExecSQL;

            FTransTpn.Commit;
          End;
          {$ENDREGION}

        end;
      end;

      QryTpnEntete.Next;
    end;

  Finally
    FreeAndNil(DsTpnEntete);
    QryTpnTva.Close;
    FreeAndNil(QryTpnTva);
    QryTpnLigne.Close;
    FreeAndNil(QryTpnLigne);
    QryTpnEntete.Close;
    FreeAndNil(QryTpnEntete);
    QryGnk.Close;
    FreeAndNil(QryGnk);
    QryGnkUpd.Close;
    FreeAndNil(QryGnkUpd);
  End;

end;

procedure TImportRapprochement.ImportRapprochement;
var
  QryGnk, QryGnkUpd, QryTpnEntete, QryTpnLigne, QryTpnTva : TMyQuery;
  DsTpnEntete : TDataSource;
  RPE_ID, iMDFRECVERSIONLIGNE, IMDFRECVERSIONTVA, iTVA : INTEGER;
begin
  QryTpnEntete        := GetNewQuery(FConnTpn,FTransTpn);
  DsTpnEntete := TDataSource.Create(nil);
  DsTpnEntete.DataSet := QryTpnEntete;
  QryTpnLigne         := GetNewQuery(FConnTpn,FTransTpn);
  QryTpnTva           := GetNewQuery(FConnTpn,FTransTpn);
  QryGnk              := GetNewQuery(FConnGnk,FTransGnk);
  QryGnkUpd           := GetNewQuery(FConnGnk,FTransGnk);

  Try
    FProcLog('-- Traitement des Bon de rapprochement --',logDebug);

    {$REGION 'Récupération des entêtes'}
    with QryTpnEntete do
    begin
      SQL.Add('Select * from TACH_ENTETE');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  And VALIDER = 1');
      SQL.Add('ORDER BY MDFRECVERSION');
      ParamByName('PMINID').AsInteger := F_VACH_ENTETEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','MDFRECVERSION;FOUID;RPENUMFACT','MDFRECVERSION',[]);
      IndexName := 'Idx';
      FProcLog(Format('Nombre de document à traiter : %d',[RecordCount]),logDebug);
    end;
    {$ENDREGION}

    {$REGION 'Récupération des relations'}
    With QryTpnLigne do
    begin
      SQL.Add('Select * from TACH_RELATION');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  and VALIDER = 1');
      ParamByName('PMINID').AsInteger := F_VACH_RELATIONISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','FOUID;RPENUMFACT','',[]);
      IndexName := 'Idx';
//      MasterFields := 'FOUID;RPENUMFACT';
//      MasterSource := DsTpnEntete;
    end;
    {$ENDREGION}

    {$REGION 'Récupération des TVA'}
    With QryTpnTva do
    begin
      SQL.Add('Select TACH_TVA.* from TACH_TVA');
      SQL.Add('  join TACH_ENTETE on (TACH_TVA.RPENUMFACT = TACH_ENTETE.RPENUMFACT');
      SQL.Add('                  and TACH_TVA.FOUID = TACH_ENTETE.FOUID)');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  And VALIDER = 1');
      ParamByName('PMINID').AsInteger := F_VACH_TVAISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','FOUID;RPENUMFACT','TVATAUX',[soDescending]);
      IndexName := 'Idx';
//      MasterFields := 'FOUID;RPENUMFACT';
//      MasterSource := DsTpnEntete;
    end;
    {$ENDREGION}

    // Intégration dans la base ginkoia.
    QryTpnEntete.First;
    while not QryTpnEntete.Eof do
    begin

      // Filtre des lignes et TVA
      QryTpnLigne.Filtered := False;
      QryTpnLigne.Filter := Format('FOUID = %d AND RPENUMFACT = %s',[QryTpnEntete.FieldByName('FOUID').AsInteger, QuotedStr(QryTpnEntete.FieldByName('RPENUMFACT').AsString)]);
      QryTpnLigne.Filtered := True;

      QryTpnTva.Filtered := False;
      QryTpnTva.Filter := Format('FOUID = %d AND RPENUMFACT = %s',[QryTpnEntete.FieldByName('FOUID').AsInteger, QuotedStr(QryTpnEntete.FieldByName('RPENUMFACT').AsString)]);
      QryTpnTva.Filtered := True;

      FTransGnk.StartTransaction;
      FTransTpn.StartTransaction;

      FProcLog(Format('Rapprochement |Document  : %s |MAG : %d | Début traitement',[QryTpnEntete.FieldByName('RPENUMFACT').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger]),logDebug);

      Try
        {$REGION 'Création de l''entete'}
        Try
          With QryGnk do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM BI15_RAPP_NEWACHENTETE(:PMAGID, :PFOUID, :PRPEDATEFACT,');
            SQL.Add(':PRPEDATERGLT, :PRPEMONTANT, :PNUMFACT)');
            ParamByName('PMAGID').AsInteger       := QryTpnEntete.FieldByName('MAGID').AsInteger;
            ParamByName('PFOUID').AsInteger       := QryTpnEntete.FieldByName('FOUID').AsInteger;
            ParamByName('PRPEDATEFACT').AsDate    := QryTpnEntete.FieldByName('RPEDATEFACT').AsDateTime;
            ParamByName('PRPEDATERGLT').AsDate    := QryTpnEntete.FieldByName('RPEDATEREGL').AsDateTime;
            ParamByName('PRPEMONTANT').AsCurrency := QryTpnEntete.FieldByName('RPEMONTANT').AsCurrency;
            ParamByName('PNUMFACT').AsString      := QryTpnEntete.FieldByName('RPENUMFACT').AsString;
            Open;

            RPE_ID := FieldByName('RPE_ID').AsInteger;

            Close;
          end;
        Except on E:Exception do
          begin
            LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,3,0,Format('BI15_RAPP_NEWACHENTETE Facture %s : %s',[E.Message, QryTpnEntete.FieldByName('RPENUMFACT').AsString]) + E.Message, 1);
            FProcLog(Format('BI15_RAPP_NEWACHENTETE |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('NUMFACT').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
            Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
            raise;
          end;
        End;
        {$ENDREGION}


        {$REGION 'Création de la TVA'}
        QryTpnTva.First;
        IMDFRECVERSIONTVA := QryTpnTva.FieldByName('MDFRECVERSION').asInteger;
        while not QryTpnTva.Eof do
        begin
          try
            with QryGnk do
            begin
              // vérification de l'existance de la TVA
              Close;
              SQL.Clear;
              SQL.Add(' SELECT TVA_ID FROM ARTTVA Where TVA_TAUX =:PRPTTXTVA');
              ParamByName('PRPTTXTVA').AsCurrency := QryTpnTva.FieldByName('TVATAUX').AsCurrency;
              Open;

              if Recordcount = 0 then
                raise Exception.Create(Format('La TVA %f n''existe pas dans la base de données',[QryTpnTva.FieldByName('TVATAUX').AsCurrency]));
              Close;

              // Création de la ligne de TVA
              SQL.Clear;
              SQL.Add('SELECT * FROM BI15_RAPP_NEWACHTVA(:PRPTRPEID, :PRPTTXTVA, :PRPTMTTTC,');
              SQL.Add(':PRPTMTHT, :PRPTBRUT, :PRPTREMISE, :PRPTNET, :PRPTPORT, :RPTFRAIS)');
              ParamByName('PRPTRPEID').AsInteger   := RPE_ID;
              ParamByName('PRPTTXTVA').AsCurrency  := QryTpnTva.FieldByName('TVATAUX').AsCurrency;
              ParamByName('PRPTMTTTC').AsCurrency  := QryTpnTva.FieldByName('RPTMTTTC').AsCurrency;
              ParamByName('PRPTMTHT').AsCurrency   := QryTpnTva.FieldByName('RPTMTHT').AsCurrency;
              ParamByName('PRPTBRUT').AsCurrency   := QryTpnTva.FieldByName('RPTBRUT').AsCurrency;
              ParamByName('PRPTREMISE').AsCurrency := QryTpnTva.FieldByName('RPTREMISE').AsCurrency;
              ParamByName('PRPTNET').AsCurrency    := QryTpnTva.FieldByName('RPTNET').AsCurrency;
              ParamByName('PRPTPORT').AsCurrency   := QryTpnTva.FieldByName('RPTPORT').AsCurrency;
              ParamByName('RPTFRAIS').AsCurrency   := QryTpnTva.FieldByName('RPTFRAIS').AsCurrency;
              Open;
              Close;
            end;

            QryTpnTva.Next;

          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,0,'BI15_RAPP_NEWACHTVA : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_NEWACHTVA |Document %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('RPENUMFACT').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
              raise;
            end;
          End;

        end;
        {$ENDREGION}

        {$REGION 'Création des relations'}
        QryTpnLigne.First;
        iMDFRECVERSIONLIGNE := QryTpnLigne.fieldByName('MDFRECVERSION').AsInteger;
        while not QryTpnLigne.Eof do
        begin
          Try
            With QryGnk do
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT * FROM BI15_RAPP_NEWACHRELATION(:PRPRRPEID, :PTYPEDOC , :PIDLIGNE)');
              ParamByName('PRPRRPEID').AsInteger := RPE_ID;
              ParamByName('PTYPEDOC').AsInteger := QryTpnLigne.FieldByName('TYPEDOC').AsInteger;
              ParamByName('PIDLIGNE').AsInteger := QryTpnLigne.FieldByName('IDLIGNE').AsInteger;
              Open;
              Close;
            end;

            QryTpnLigne.Next;
          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnLigne.FieldByName('IDLIGNE').AsInteger,'BI15_RAPP_NEWACHRELATION : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_NEWACHRELATION |Document %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('RPENUMFACT').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
              raise;
            end;
          End;
        end;

        {$ENDREGION}

        // Mise à jour des générateurs
        SetGenerateur('TACHTVA_ISF',IMDFRECVERSIONTVA);
        SetGenerateur('TACHRELATION_ISF',iMDFRECVERSIONLIGNE);
        SetGenerateur('TACHENTETE_ISF',QryTpnEntete.FieldByName('MDFRECVERSION').AsInteger);

        FTransGnk.Commit;
        FTransTpn.Commit;
        FProcLog(Format('Rapprochement |Document  : %s |MAG : %d | Fin de Traitement Ok',[QryTpnEntete.FieldByName('RPENUMFACT').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger]),logDebug);
      Except on E:Exception do
        begin
          FTransGnk.Rollback;
          FTransTpn.Rollback;

          {$REGION  'Mise à jour du MDFRECVERSION de l''entête et des lignes du doc en erreur'}
          With QryTpnErr do
          Begin
            FTransTpn.StartTransaction;
            // Mise à jour Entête
            Close;
            SQL.Clear;
            SQL.Add('UPDATE TACH_ENTETE SET MDFRECVERSION = GEN_ID(GENIMPRAPP,1)');
            SQL.Add('Where RPENUMFACT = :PRPENUMFACT AND FOUID = :PFOUID');
            ParamByName('PRPENUMFACT').AsString := QryTpnEntete.FieldByName('RPENUMFACT').AsString;
            ParamByName('PFOUID').AsInteger := QryTpnEntete.FieldByName('FOUID').AsInteger;
            ExecSQL;

            // Mise à jour Lignes
            Close;
            SQL.Clear;
            SQL.Add('UPDATE TACH_RELATION SET MDFRECVERSION = GEN_ID(GENIMPRAPP,0)');
            SQL.Add('Where RPENUMFACT = :PRPENUMFACT AND FOUID = :PFOUID');
            ParamByName('PRPENUMFACT').AsString := QryTpnEntete.FieldByName('RPENUMFACT').AsString;
            ParamByName('PFOUID').AsInteger := QryTpnEntete.FieldByName('FOUID').AsInteger;
            ExecSQL;

            FTransTpn.Commit;
          End;
          {$ENDREGION}

        end;
      End;

      QryTpnEntete.Next;
    end;

  finally
    FreeAndNil(DsTpnEntete);
    QryTpnTva.Close;
    FreeAndNil(QryTpnTva);
    QryTpnLigne.Close;
    FreeAndNil(QryTpnLigne);
    QryTpnEntete.Close;
    FreeAndNil(QryTpnEntete);
    QryGnk.Close;
    FreeAndNil(QryGnk);
    QryGnkUpd.Close;
    FreeAndNil(QryGnkUpd);
  end;
end;

procedure TImportRapprochement.ImportReception;
var
  QryGnk, QryGnkUpd, QryTpnEntete, QryTpnLigne, QryTpnTva : TMyQuery;
  DsTpnEntete : TDataSource;
  i, IDEntete, IDLigne, iExeID, iCPAID, iMRGID, iCOLID, iMdcRecVersionLigne : integer;
  sQryMain, sUpdBody : String;
  bUpdated : Boolean;
begin

  // Récupération des réceptions à traiter
  QryTpnEntete        := GetNewQuery(FConnTpn,FTransTpn);
  DsTpnEntete := TDataSource.Create(nil);
  DsTpnEntete.DataSet := QryTpnEntete;
  QryTpnLigne         := GetNewQuery(FConnTpn,FTransTpn);
  QryTpnTva           := GetNewQuery(FConnTpn,FTransTpn);
  QryGnk              := GetNewQuery(FConnGnk,FTransGnk);
  QryGnkUpd           := GetNewQuery(FConnGnk,FTransGnk);

  Try
    FProcLog('-- Traitement des réceptions --',logDebug);

    {$REGION 'Récupération des entêtes'}
    with QryTpnEntete do
    begin
      SQL.Add('Select * from TRECEPTION_ENTETE');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  And SENS = 1 and VALIDER = 1');
      SQL.Add('ORDER BY MDFRECVERSION');
      ParamByName('PMINID').AsInteger := F_VRECEPT_ENTETEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','MDFRECVERSION;BREID;BRENUMFOURN','MDFRECVERSION',[]);
      IndexName := 'Idx';
      FProcLog(Format('Nombre de document à traiter : %d',[RecordCount]),logDebug);
    end;
    {$ENDREGION}

    {$REGION 'Récupération des lignes'}
    With QryTpnLigne do
    begin
      SQL.Add('Select * from TRECEPTION_LIGNE');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  and SENS = 1 and VALIDER = 1');
      ParamByName('PMINID').AsInteger := F_VRECEPT_LIGNEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','BREID;BRENUMFOURN','',[]);
      IndexName := 'Idx';
//      MasterFields := 'BREID;BRENUMFOURN';
//      MasterSource := DsTpnEntete;
    end;
    {$ENDREGION}

    {$REGION 'Récupération des TVA'}
    With QryTpnTva do
    begin
      SQL.Add('Select TRECEPTION_TVA.* from TRECEPTION_TVA');
      SQL.Add('  join TRECEPTION_ENTETE on TRECEPTION_TVA.BRENUMFOURN = TRECEPTION_ENTETE.BRENUMFOURN');
      SQL.Add('                        AND TRECEPTION_TVA.BREID = TRECEPTION_ENTETE.BREID');
      SQL.Add('Where MDFRECVERSION > :PMINID and MDFRECVERSION <= :PMAXID');
      SQL.Add('  And TRECEPTION_ENTETE.SENS = 1 and VALIDER = 1 and TRECEPTION_TVA.SENS = 1');
      ParamByName('PMINID').AsInteger := F_VRECEPT_ENTETEISF;
      ParamByName('PMAXID').AsInteger := F_MAIN_GENERATOR;
      OptionsIntf.FetchOptions.Unidirectional:=false;
      Open();
      AddIndex('Idx','BREID;BRENUMFOURN','BRETAUX',[soDescending]);
      IndexName := 'Idx';
//      MasterFields := 'BREID;BRENUMFOURN';
//      MasterSource := DsTpnEntete;
    end;
    {$ENDREGION}

    // Intégration dans la base ginkoia.
    QryTpnEntete.First;
    while not QryTpnEntete.Eof do
    begin
      FTransGnk.StartTransaction;
      FTransTpn.StartTransaction;

      FProcLog(Format('Réception |Document %s |MAG : %d |Début traitement',[QryTpnEntete.FieldByName('BRENUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger]),logDebug);

      // Filtre des lignes et TVA
      QryTpnLigne.Filtered := False;
      QryTpnLigne.Filter := Format('BREID = %d AND BRENUMFOURN = %s',[QryTpnEntete.FieldByName('BREID').AsInteger, QuotedStr(QryTpnEntete.FieldByName('BRENUMFOURN').AsString)]);
      QryTpnLigne.Filtered := True;

      QryTpnTva.Filtered := False;
      QryTpnTva.Filter := Format('BREID = %d AND BRENUMFOURN = %s',[QryTpnEntete.FieldByName('BREID').AsInteger, QuotedStr(QryTpnEntete.FieldByName('BRENUMFOURN').AsString)]);
      QryTpnTva.Filtered := True;

      Try
        if QryTpnEntete.FieldByName('BREID').AsInteger = 0 then
        begin
          {$REGION 'Recherche des informations d''entête'}
          // Vérification du type de la première ligne.
          QryTpnLigne.First;

          Case QryTpnLigne.FieldByName('TYPEDOC').AsInteger of
            1: begin
              // Réception
              With QryGnk do
              begin
                SQL.Clear;
                SQL.Add('SELECT BRE_EXEID, BRE_CPAID, BRE_MRGID, BRE_COLID, BRL_COLID');
                SQL.Add('From RECBR join RECBRL on BRL_BREID = BRE_ID');
                SQL.Add('Where BRL_ID = :PBRLID');
                ParamByName('PBRLID').AsInteger := QryTpnLigne.FieldByName('IDREF').AsInteger;
                Open;

                iExeID := FieldByName('BRE_EXEID').AsInteger;
                iCPAID := FieldByName('BRE_CPAID').AsInteger;
                iMRGID := FieldByName('BRE_MRGID').AsInteger;
                if FieldByName('BRE_COLID').AsInteger <> 0 then
                  iCOLID := FieldByName('BRE_COLID').AsInteger
                else
                  iCOLID := FieldByName('BRL_COLID').AsInteger;
                Close;
              end;
            end;
            2: begin
              // Bon de retour
              iExeID := 0;
              iCPAID := 0;
              iCOLID := 0;

              With QryGnk do
              begin
                SQL.Clear;
                SQL.Add('SELECT RET_MRGID');
                SQL.Add('From COMRETOUR join COMRETOURL on REL_RETID = RET_ID');
                SQL.Add('Where REL_ID = :PRELID');
                ParamByName('PRELID').AsInteger := QryTpnLigne.FieldByName('IDREF').AsInteger;
                Open;

                iMRGID := FieldByName('RET_MRGID').AsInteger;
                Close;
              end;
            end;
          end;
          {$ENDREGION}

          {$REGION 'Création d''une réception'}
          Try
            // Création de l'entête
            With QryGnk do
            begin
              SQL.Clear;
              SQL.Add('SELECT BRE_ID FROM BI15_RAPP_NEWRECBR(:PMAGID, :PFOUID, :PBRENUMFOURN, :PBREDATE,');
              for i := 1 to 5 do
                SQL.Add(Format(':PBRETVAHT%0:d, :PBRETVATAUX%0:d, :PBRETVA%0:d,',[i]));
              SQL.Add(':PBREEXEID, :PBRECPAID, :PMRGID, :PCOLID)');
              ParamByName('PMAGID').AsInteger := QryTpnEntete.FieldByName('MAGID').AsInteger;
              ParamByName('PFOUID').AsInteger := QryTpnEntete.FieldByName('FOUID').AsInteger;
              ParamByName('PBRENUMFOURN').AsString := QryTpnEntete.FieldByName('BRENUMFOURN').AsString;
              ParamByName('PBREDATE').AsDateTime := QryTpnEntete.FieldByName('BREDATE').AsDateTime;

              QryTpnTva.First;
              for i := 1 to 5 do
              begin
                if not QryTpnTva.Eof then
                begin
                  ParamByName('PBRETVAHT' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('BREMTHT').AsCurrency;
                  ParamByName('PBRETVATAUX' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('BRETAUX').AsCurrency;
                  ParamByName('PBRETVA' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('BRETVA').AsCurrency;
                  QryTpnTva.Next;
                end
                else begin
                  ParamByName('PBRETVAHT' + IntToStr(i)).AsCurrency := 0;
                  ParamByName('PBRETVATAUX' + IntToStr(i)).AsCurrency := 0;
                  ParamByName('PBRETVA' + IntToStr(i)).AsCurrency := 0;
                end;
              end;
              ParamByName('PBREEXEID').AsInteger := iExeID;
              ParamByName('PBRECPAID').AsInteger := iCPAID;
              ParamByName('PMRGID').AsInteger := iMRGID;
              ParamByName('PCOLID').AsInteger := iCOLID;
              Open;
              // récupération de l'ID de l'entête nouvellement créé.
              IdEntete := FieldByname('BRE_ID').AsInteger;

              Close;
            end;
          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnEntete.FieldByName('IDREF').AsInteger,'BI15_RAPP_NEWRECBR : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_NEWRECBR |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('BRENUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);

              raise;
            end;
          End;

          // création des lignes
          Try
            QryTpnLigne.First;
            iMdcRecVersionLigne := QryTpnLigne.FieldByName('MDFRECVERSION').AsInteger;
            while not QryTpnLigne.Eof do
            begin
              With QryGnk do
              begin
                SQL.Clear;
                SQL.Add('SELECT BRL_ID from BI15_RAPP_NEWRECBRL(:POLDBRLID, :PMAGID, :PBRLBREID,');
                SQL.Add(' :PBRLARTID, :PBRLTGFID, :PBRLCOUID, :PBRLQTE, :PBRLPXCTLG, :PBRLPXACHAT, :PBRLTVA)');
                ParamByName('POLDBRLID').AsInteger := QryTpnLigne.FieldByName('IDREF').AsInteger;
                ParamByName('PMAGID').AsInteger := QryTpnEntete.FieldByName('MAGID').AsInteger;
                ParamByName('PBRLBREID').AsInteger := IdEntete;
                ParamByName('PBRLARTID').AsInteger := QryTpnLigne.FieldByName('MODID').AsInteger;
                ParamByName('PBRLTGFID').AsInteger := QryTpnLigne.FieldByName('TGFID').AsInteger;
                ParamByName('PBRLCOUID').AsInteger := QryTpnLigne.FieldByName('COUID').AsInteger;
                ParamByName('PBRLQTE').AsExtended   := QryTpnLigne.FieldByName('BRLQTE').AsExtended;
                ParamByName('PBRLPXCTLG').AsCurrency := QryTpnLigne.FieldByName('BRLPXCTLG').AsCurrency;
                ParamByName('PBRLPXACHAT').AsCurrency := QryTpnLigne.FieldByName('BRLPXACHAT').AsCurrency;
                ParamByName('PBRLTVA').AsCurrency := QryTpnLigne.FieldByName('BRLTVA').AsCurrency;
                Open;
              end;

              QryTpnLigne.Next;
            end;
          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnLigne.FieldByName('IDREF').AsInteger, 'BI15_RAPP_NEWRECBRL : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_NEWRECBRL |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('BRENUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
              raise;
            end;
          End;
          {$ENDREGION}
        end
        else begin
          // Mise à jour d'une réception

          // traitement des lignes
          QryTpnLigne.First;
          iMdcRecVersionLigne := QryTpnLigne.FieldByName('MDFRECVERSION').AsInteger;
          while not QryTpnLigne.Eof do
          begin
            Try
              {$REGION 'Mise à jour de la ligne de réception'}
              With QryGnkUpd do
              begin
                SQL.Clear;
                SQL.Add('EXECUTE PROCEDURE BI15_RAPP_UPDRECBRL (:PBRLID, :PBRLQTE, :PBRLPXACHAT)');
                ParamByName('PBRLQTE').AsCurrency     := QryTpnLigne.FieldByName('BRLQTE').AsCurrency;
                ParamByName('PBRLPXACHAT').AsCurrency := QryTpnLigne.FieldByName('BRLPXACHAT').AsCurrency;
                ParamByName('PBRLID').AsInteger       := QryTpnLigne.FieldByName('BRLID').AsInteger;
                ExecSQL;
                Close;
              end;
              {$ENDREGION}
            Except on E:Exception do
              begin
                LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnEntete.FieldByName('IDREF').AsInteger,'BI15_RAPP_UPDRECBRL : ' + E.Message, 1);
                FProcLog(Format('BI15_RAPP_UPDRECBRL |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('BRENUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
                Log.Log(FLogModule, FLogRef, '', FLogKey, E.Message, logError,False);
                raise;
              end;
            End;
            QryTpnLigne.Next;
          end;

          {$REGION 'Traitement de l''entête'}
          Try
            With QryGnk do
            begin
              SQL.Clear;
              SQL.Add('EXECUTE PROCEDURE BI15_RAPP_UPDRECBR(:PBREID,');
              SQL.Add(' :PBRETVAHT1, :PBRETVATAUX1, :PBRETVA1, :PBRETVAHT2, :PBRETVATAUX2, :PBRETVA2,');
              SQL.Add(' :PBRETVAHT3, :PBRETVATAUX3, :PBRETVA3, :PBRETVAHT4, :PBRETVATAUX4, :PBRETVA4,');
              SQL.Add(' :PBRETVAHT5, :PBRETVATAUX5, :PBRETVA5)');
              ParamByName('PBREID').AsInteger := QryTpnEntete.FieldByName('BREID').AsInteger;

              QryTpnTva.First;
              for i := 1 to 5 do
              begin
                if not QryTpnTva.Eof then
                begin
                  ParamByName('PBRETVAHT' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('BREMTHT').AsCurrency;
                  ParamByName('PBRETVATAUX' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('BRETAUX').AsCurrency;
                  ParamByName('PBRETVA' + IntToStr(i)).AsCurrency := QryTpnTva.FieldByName('BRETVA').AsCurrency;
                  QryTpnTva.Next;
                end
                else begin
                  ParamByName('PBRETVAHT' + IntToStr(i)).AsCurrency := 0;
                  ParamByName('PBRETVATAUX' + IntToStr(i)).AsCurrency := 0;
                  ParamByName('PBRETVA' + IntToStr(i)).AsCurrency := 0;
                end;
              end;
              ExecSQL();
            end;
          Except on E:Exception do
            begin
              LogInteg(QryTpnEntete.FieldByName('MAGID').AsInteger,1,QryTpnEntete.FieldByName('IDREF').AsInteger,'BI15_RAPP_UPDRECBR : ' + E.Message, 1);
              FProcLog(Format('BI15_RAPP_UPDRECBR |Document  : %s |MAG : %d |Erreur : %s',[QryTpnEntete.FieldByName('BRENUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger, E.Message ]),logDebug);
              raise;
            end;
          End;

          {$ENDREGION}
        end;

        // Mise à jour du générateur des lignes
        if QryTpnLigne.RecordCount > 0 then
          SetGenerateur('TRECEPTIONLIGNE_ISF', iMdcRecVersionLigne);

        // Mise à jour du générateur de l'entête
        SetGenerateur('TRECEPTIONENTETE_ISF',QryTpnEntete.FieldByName('MDFRECVERSION').AsInteger);

        FTransGnk.Commit;
        FTransTpn.Commit;

        FProcLog(Format('Réception |Réception  : %s |MAG : %d | Fin de traitement OK',[QryTpnEntete.FieldByName('BRENUMFOURN').AsString, QryTpnEntete.FieldByName('MAGID').AsInteger]),logDebug);

      Except on E:Exception do
        begin
          FTransGnk.Rollback;
          FTransTpn.Rollback;

          {$REGION  'Mise à jour du MDFRECVERSION de l''entête et des lignes du doc en erreur'}
          With QryTpnErr do
          Begin
            FTransTpn.StartTransaction;
            // Mise à jour Entête
            Close;
            SQL.Clear;
            SQL.Add('UPDATE RECEPTION_ENTETE SET MDFRECVERSION = GEN_ID(GENIMPRAPP,1)');
            SQL.Add('Where BREID = :PBREID AND BRENUMFOURN = :PBRENUMFOURN AND SENS = 1');
            ParamByName('PBRENUMFOURN').AsString := QryTpnEntete.FieldByName('BRENUMFOURN').AsString;
            ParamByName('PBREID').AsInteger := QryTpnEntete.FieldByName('BREID').AsInteger;
            ExecSQL;

            // Mise à jour Lignes
            Close;
            SQL.Clear;
            SQL.Add('UPDATE RECEPTION_LIGNE SET MDFRECVERSION = GEN_ID(GENIMPRAPP,0)');
            SQL.Add('Where BREID = :PBREID AND BRENUMFOURN = :PBRENUMFOURN AND SENS = 1');
            ParamByName('PBRENUMFOURN').AsString := QryTpnEntete.FieldByName('BRENUMFOURN').AsString;
            ParamByName('PBREID').AsInteger := QryTpnEntete.FieldByName('BREID').AsInteger;
            ExecSQL;

            FTransTpn.Commit;
          End;
          {$ENDREGION}

        end;
      end;

      QryTpnEntete.Next;
    end;

  Finally
    FreeAndNil(DsTpnEntete);
    QryTpnTva.Close;
    FreeAndNil(QryTpnTva);
    QryTpnLigne.Close;
    FreeAndNil(QryTpnLigne);
    QryTpnEntete.Close;
    FreeAndNil(QryTpnEntete);
    QryGnk.Close;
    FreeAndNil(QryGnk);
    QryGnkUpd.Close;
    FreeAndNil(QryGnkUpd);
  End;
end;

procedure TImportRapprochement.LogInteg(AMAG_ID, ATypeDoc, AIdLigne: Integer;
  ALOGMessage: String; ASens: Integer);
begin
  FTransLog.StartTransaction;

  With QryTpnLog do
  Try
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TLOG_INTEG(MAGID, TYPEDOC, IDLIGNE, LOGMESSAGE, SENS, VALIDER, MDFRECVERSION, MDFTIMESTAMP)');
    SQL.Add('VALUES(:PMAGID, :PTYPEDOC, :PIDLIGNE, :PLOGMESS, :PSENS, :PVALIDER, GEN_ID(GENIMPRAPP,1), CURRENT_DATE)');
    ParamByName('PMAGID').AsInteger   := AMAG_ID;
    ParamByName('PTYPEDOC').AsInteger := ATypeDoc;
    ParamByName('PIDLIGNE').AsInteger := AIdLigne;
    ParamByName('PLOGMESS').AsString  := ALOGMessage;
    ParamByName('PSENS').AsInteger    := ASens;
    ParamByName('PVALIDER').AsInteger := 1;
    ExecSQL;

    FTransLog.Commit;
    Close;
  Except on E:Exception do
    begin
      FTransLog.Rollback;
    end;
  end;
end;

procedure TImportRapprochement.SetGenerateur(ATableName: String;
  AValue: Integer);
var
  QryTpn : TMyQuery;
begin
  QryTpn := GetNewQuery(FConnTpn,FTransTpn);
  Try
    QryTpn.SQL.Add('Update TVERSION SET');
    QryTpn.SQL.Add('VERLASTVERSION = :PLASTVERSION');
    QryTpn.SQL.Add('Where VERNOMTABLE = :PNOMTABLE');
    QryTpn.ParamByName('PLASTVERSION').AsInteger := AValue;
    QryTpn.ParamByName('PNOMTABLE').AsString := ATableName;
    QryTpn.ExecSQL;
  Finally
    QryTpn.Close;
    FreeAndNil(QryTpn);
  End;
end;

end.

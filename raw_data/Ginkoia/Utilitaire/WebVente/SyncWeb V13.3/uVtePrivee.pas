UNIT uVtePrivee;

INTERFACE

USES
  Controls,
  Classes,
  uCommon_DM,
  SysUtils,
  Forms,
  Types,
  uCommon_Type,
  Dialogs,
  Progression_Frm,
  dxmdaset,
  uCommon,
  db;

//test que les paramètres soit valide
FUNCTION TestParametreVtePriv: boolean;
//traitement de l'intégration
PROCEDURE TraiterVtePriv(ARep: STRING; VAR NbOk, NbEchec: integer);

IMPLEMENTATION

VAR
  NRapportVtePriv: integer;

  //arrondi à 2 decimal après la virgule
FUNCTION ArrondiA2(v: Double): Double;
VAR
  TpV: Currency;
  v1: integer;
  s: STRING;
  Ecart: integer;
BEGIN
  TpV := v;
  s := inttostr(Trunc(TpV * 1000));
  Ecart := 0;
  TRY
    v1 := StrToInt(s[Length(s)]);
    IF v1 >= 5 THEN
    BEGIN
      IF v < 0 THEN
        Ecart := -1
      ELSE
        Ecart := 1;
    END;
  EXCEPT
  END;
  Result := (Trunc(TpV * 100) + Ecart) / 100;
END;

//Trim et Contrôle eventuel de validité du String

FUNCTION CtrlString(Value: STRING; OkOblig: boolean; VAR OkValid: boolean): STRING;
BEGIN
  Result := Trim(Value);
  IF OkOblig AND (Result = '') THEN
    OkValid := false
  ELSE
    OkValid := true;
END;

//Trim et Contrôle eventuel de validité de la ville (si champ entierement numerique, alors champ ville pas bon

FUNCTION CtrlVille(Value: STRING; VAR OkValid: boolean): STRING;
VAR
  i: integer;
BEGIN
  Result := CtrlString(Value, true, OkValid);
  IF NOT (OkValid) THEN
    exit;
  OkValid := false; //test si champ uniquement numérique
  FOR i := 1 TO Length(Result) DO
  BEGIN
    IF NOT (Result[i] IN ['0'..'9']) THEN
      OkValid := true;
  END;
END;

//Contrôle si le Str est convertible en Float

FUNCTION CtrlFloat(Value: STRING; VAR OkValid: boolean): STRING;
VAR
  Tps: STRING;
  TpV: Double;
BEGIN
  Result := Trim(Value);
  IF Result = '' THEN
  BEGIN
    OkValid := false;
    exit;
  END;
  Tps := Result;
  IF Pos('.', TpS) > 0 THEN
    TpS[Pos('.', TpS)] := DecimalSeparator;
  IF Pos(',', TpS) > 0 THEN
    TpS[Pos(',', TpS)] := DecimalSeparator;
  TpV := StrToFloatDef(TpS, -1);
  IF TpV = -1 THEN
    OkValid := false
  ELSE
  BEGIN
    OkValid := true;
    Result := Tps;
  END;
END;

//controle si le Str est convertible en datetime

FUNCTION CtrlDateTime(Value: STRING; VAR OkValid: boolean): STRING;
VAR
  dd, mm, yy: word;
  hh, nn, ss, ms: word;
  TpS, TpS2: STRING;
  TpD: TDateTime;
BEGIN
  dd := 40; //date obligatoire --> rend la date invalide par défaut
  mm := 0;
  ms := 0;
  TpS := Trim(Value);
  result := Tps;
  IF Pos('/', Tps) > 0 THEN
  BEGIN
    dd := StrToIntDef(Copy(TpS, 1, Pos('/', Tps) - 1), 40);
    TpS := Copy(TpS, Pos('/', Tps) + 1, Length(TpS));
  END;
  IF Pos('/', Tps) > 0 THEN
  BEGIN
    mm := StrToIntDef(Copy(TpS, 1, Pos('/', Tps) - 1), 40);
    TpS := Copy(TpS, Pos('/', Tps) + 1, Length(TpS));
  END;
  TpS2 := TpS;
  IF Pos(' ', TpS) > 0 THEN
  BEGIN
    TpS2 := Copy(TpS, 1, Pos(' ', Tps) - 1);
    TpS := Copy(TpS, Pos(' ', Tps) + 1, Length(TpS));
  END;
  yy := StrToIntDef(TpS2, 3000);
  IF yy = 3000 THEN
  BEGIN
    OkValid := false;
    exit;
  END;
  Tps2 := Trim(Tps);
  IF Pos(':', TpS) > 0 THEN
  BEGIN
    TpS2 := Copy(TpS, 1, Pos(':', Tps) - 1);
    TpS := Copy(TpS, Pos(':', Tps) + 1, Length(TpS));
  END;
  hh := StrToIntDef(TpS2, 0);
  Tps2 := Tps;
  IF Pos(':', TpS) > 0 THEN
  BEGIN
    TpS2 := Copy(TpS, 1, Pos(':', Tps) - 1);
    TpS := Copy(TpS, Pos(':', Tps) + 1, Length(TpS));
  END
  ELSE
    TpS := '';
  nn := StrToIntDef(TpS2, 0);
  Tps2 := Tps;
  IF Pos(':', TpS) > 0 THEN
  BEGIN
    TpS2 := Copy(TpS, 1, Pos(':', Tps) - 1);
    TpS := Copy(TpS, Pos(':', Tps) + 1, Length(TpS));
  END
  ELSE
    TpS := '';
  ss := StrToIntDef(TpS2, 0);
  TRY
    TpD := EncodeDate(yy, mm, dd) + EncodeTime(hh, nn, ss, ms);
    OkValid := true;
  EXCEPT
    OkValid := false;
    exit;
  END;
  Result := DateTimeToStr(TpD);
END;

//contrôle la validité d'un mail

FUNCTION CtrlMail(Value: STRING; VAR OkValid: boolean): STRING;
VAR
  sGauche, sDroite: STRING;
  LPos: integer;
BEGIN
  Result := Trim(Value);
  OkValid := true;
  IF Pos('@', Result) = 0 THEN
  BEGIN
    OkValid := false;
    exit;
  END;
  IF Pos(' ', Result) > 0 THEN
  BEGIN //espace dans le mail
    OkValid := false;
    exit;
  END;
  sGauche := Copy(Result, 1, Pos('@', Result) - 1);
  sDroite := Copy(Result, Pos('@', Result) + 1, Length(Result));
  LPos := Pos('.', sGauche);
  IF LPos > 0 THEN
  BEGIN
    IF LPos = 1 THEN
    BEGIN //commence par un point
      OkValid := false;
      exit;
    END;
    IF LPos = Length(sGauche) THEN
    BEGIN //point juste à gauche de @
      OkValid := false;
      exit;
    END;
  END;
  LPos := Pos('.', sDroite);
  IF LPos > 0 THEN
  BEGIN
    IF LPos = 1 THEN
    BEGIN //point juste à droite de @
      OkValid := false;
      exit;
    END;
    IF LPos = Length(sDroite) THEN
    BEGIN //fini par un point
      OkValid := false;
      exit;
    END;
  END
  ELSE
  BEGIN //pas de point à droite de @
    OkValid := false;
    exit;
  END;
END;

//crée une ligne d'erreur dans le rapport

PROCEDURE DoRapport(AFichier: STRING; ALigErr: integer; ALibErr, ANumCom, ANumArt, ADateCom, ALibProd: STRING);
var
  d: TDateTime;
  CvtDate: string;
BEGIN
  //enleve l'heure de la date de commande si possible
  try
    d := StrToDateTime(ADateCom);
    CvtDate := DateToStr(d);
  except
    CvtDate := ADateCom;
  end;

  Dm_Common.MemD_Rapport.Append;
  Dm_Common.MemD_Rapport.fieldbyname('NOLIGNE').AsInteger := NRapportVtePriv;
  Dm_Common.MemD_Rapport.fieldbyname('FICHIER').AsString := AFichier;
  Dm_Common.MemD_Rapport.fieldbyname('JDATE').AsDateTime := Date;
  Dm_Common.MemD_Rapport.fieldbyname('JTIME').AsDateTime := Time;
  Dm_Common.MemD_Rapport.fieldbyname('LIGERR').AsInteger := ALigErr;
  Dm_Common.MemD_Rapport.fieldbyname('LIBERR').AsString := ALibErr;
  Dm_Common.MemD_Rapport.fieldbyname('NUMCOM').AsString := ANumCom;
  Dm_Common.MemD_Rapport.fieldbyname('NUMART').AsString := ANumArt;
  Dm_Common.MemD_Rapport.fieldbyname('DATECOM').AsString := CvtDate;
  Dm_Common.MemD_Rapport.fieldbyname('LIBPROD').AsString := ALibProd;
  Dm_Common.MemD_Rapport.Post;
  inc(NRapportVtePriv);
END;

//test le paramètrage avant l'importation

FUNCTION TestParametreVtePriv: boolean;
VAR
  savASS_ID: integer;
  sDest: STRING;
BEGIN
  result := true;

  //lit les paramètres du site
  savASS_ID := Dm_Common.Que_SitePriv.fieldbyname('ASS_ID').AsInteger;
  DM_Common.Que_GetSites.Close;
  DM_Common.Que_GetSites.Open;
  IF DM_Common.Que_GetSites.Locate('ASS_ID', savASS_ID, []) THEN
  BEGIN
    IF NOT (Dm_Common.LitParams(true)) THEN
    BEGIN
      DM_Common.Que_GetSites.Close;
      result := false;
      MessageDlg('Erreur de paramètrage !', mterror, [mbok], 0);
      exit;
    END;
  END
  ELSE
  BEGIN
    DM_Common.Que_GetSites.Close;
    result := false;
    MessageDlg('Impossible de trouver le sîte !', mterror, [mbok], 0);
    exit;
  END;
  DM_Common.Que_GetSites.Close;

  //verification du paramètrage
  WITH Dm_Common.Que_SitePriv DO
  BEGIN
    IF (fieldbyname('ASS_USRID').AsInteger = 0) OR (fieldbyname('ASS_POSID').AsInteger = 0) THEN
    BEGIN
      result := false;
      MessageDlg('Vendeur par défaut et/ou caisse à créditer non paramétré pour ce site !', mterror, [mbok], 0);
      exit;
    END;
  END;

  //test si le répertoire paramétré dans ginkoia est valide
  sDest := Dm_Common.MySiteParams.sLocalFolderGet;
  IF (sDest = '') OR NOT (DirectoryExists(sDest)) THEN
  BEGIN
    result := false;
    MessageDlg('Répertoire paramétré dans Ginkoia invalide !', mterror, [mbok], 0);
    exit;
  END;

  //test si le paramètrage Mode de règlement est valide dans Ginkoia
  WITH DM_Common.Que_Trv DO
  BEGIN
    Active := false;
    ParamByName('ASSID').AsInteger := Dm_Common.Que_SitePriv.fieldbyname('ASS_ID').AsInteger;
    Active := true;
    TRY
      IF Eof THEN
        result := false;
    FINALLY
      Active := false;
    END;
    IF NOT (result) THEN
    BEGIN
      MessageDlg('Paramètrage mode de règlement invalide !', mterror, [mbok], 0);
      exit;
    END;
  END;
END;

FUNCTION MemD_ImportVtePriv: TdxMemData;
BEGIN
  Result := Dm_Common.MemD_ImportVtePriv;
END;

FUNCTION TestLigneVide(ADataSet: TDataSet): boolean;
VAR
  i: integer;
BEGIN
  Result := true;
  FOR i := 1 TO ADataSet.FieldCount DO
  BEGIN
    IF (ADataSet.Fields[i - 1].FieldName <> 'RecId')
      AND (ADataSet.Fields[i - 1].FieldName <> 'NoLigne')
      AND (ADataSet.Fields[i - 1].AsString <> '') THEN
      Result := false;
  END;
END;

//test et Importation des fichiers sélectionné

PROCEDURE TraiterVtePriv(ARep: STRING; VAR NbOk, NbEchec: integer);
VAR
  bOk: boolean;
  bOk2: boolean;
  sRepSrc: STRING;
  sDest: STRING;
  sDestOK: STRING;
  sDestOKARCHIVE: STRING;
  sDestECHEC: STRING;
  sDestRAPPORT: STRING;
  sDestARCHIVE: STRING;
  sExt: STRING;
  sFicSrc: STRING;
  sFicDst: STRING;
  sFicRapp: STRING;
  sTemp: STRING;
  TPListeATraiter: TStringList;
  TPListe: TStringList;
  TPListeAvecLig: TStringList;
  savLocateATraiter: STRING;
  i, j, k: integer;
  dTraite: TDateTime;
  DebNoLigne: integer;

  TpComm: STRING;
  TotAff: Double;
  TotCal: Double;
  TotLig: Double;

  IdCommande: integer;
  IdCommandeExists: integer;
  OkFaireCommande: boolean;
  ASS_Code: integer;
  IDPays: integer;
  IDClt: integer;
  TauTvaEnt: Double;
  ArtInfos: stArticleInfos;
  LstLot: TStringList;
  sCodBar: STRING;
  sErreur: STRING;
  NumLot: integer;
  NoLigne: integer;
BEGIN
  TPListeATraiter := TStringList.Create;
  TPListe := TStringList.Create;
  TPListeAvecLig := TStringList.Create;
  LstLot := TStringList.Create;
  Frm_Progression := TFrm_Progression.Create(Application);
  Application.ProcessMessages;
  TRY

    ASS_Code := Dm_Common.Que_SitePriv.fieldbyname('ASS_CODE').AsInteger;

    //va chercher tous les fichiers à traiter
    TPListeATraiter.Clear;
    WITH Dm_Common.MemD_ATraiterVtePriv DO
    BEGIN
      savLocateATraiter := fieldbyname('fichier').AsString;
      DisableControls;
      TRY
        First;
        WHILE NOT (Eof) DO
        BEGIN
          IF FieldByName('ATraiter').AsInteger = 1 THEN
            TPListeATraiter.Add(FieldByName('fichier').AsString);
          Next;
        END;
      FINALLY
        Locate('fichier', savLocateATraiter, []);
        EnableControls;
      END;
    END;

    IF TPListeATraiter.Count = 0 THEN
    BEGIN
      MessageDlg('Aucun fichier sélectionné !', mterror, [mbok], 0);
      exit;
    END;

    //repertoire source
    sRepSrc := ARep;
    IF (sRepSrc <> '') AND (sRepSrc[Length(sRepSrc)] <> '\') THEN
      sRepSrc := sRepSrc + '\';

    sDest := Dm_Common.MySiteParams.sLocalFolderGet;
    IF sDest[Length(sDest)] <> '\' THEN
      sDest := sDest + '\';
    sDestOK := sDest + 'OK\';
    sDestOKARCHIVE := sDest + 'OK\ARCHIVE\';
    sDestECHEC := sDest + 'ECHEC\';
    sDestRAPPORT := sDest + 'RAPPORT\';
    sDestARCHIVE := sDest + 'RAPPORT\ARCHIVE\';
    ForceDirectories(sDestOk);
    ForceDirectories(sDestOKARCHIVE);
    ForceDirectories(sDestECHEC);
    ForceDirectories(sDestRAPPORT);
    ForceDirectories(sDestARCHIVE);

    dTraite := now;
    MemD_ImportVtePriv.DelimiterChar := ';';
    //initialise la fenetre de progression
    Frm_Progression.Init(TPListeATraiter[0], TPListeATraiter.Count);
    FOR i := 1 TO TPListeATraiter.Count DO
    BEGIN
      sFicSrc := TPListeATraiter[i - 1];
      sExt := ExtractFileExt(sFicSrc);
      sFicDst := Copy(sFicSrc, 1, Length(sFicSrc) - Length(sext));

      NRapportVtePriv := 1;
      Dm_Common.MemD_Rapport.DelimiterChar := ';';
      Dm_Common.MemD_Rapport.Active := false;
      Dm_Common.MemD_Rapport.Active := true;
      sFicRapp := 'Rapport_' + sFicDst + '_' + FormatDateTime('yyyymmdd_hhnnss', now) + '.csv';

      sFicDst := sFicDst + '_' + FormatDateTime('yyyymmdd hhnnss', dTraite) + sExt;
      TPListe.Clear;
      TPListe.LoadFromFile(sRepSrc + sFicSrc);

      Frm_Progression.SetFichier(sFicSrc, ((TPListe.Count - 1) * 3) + 20);
      //+20 pour simuler le temps de chargement ds le memdata
      IF TPListe.Count = 0 THEN
      BEGIN
        bOk := false;
        DoRapport(sFicSrc, 0, 'Aucune ligne dans le fichier', '', '', '', '');
      END
      ELSE
      BEGIN
        //j'ai besoin du N° de ligne excel
        TPListeAvecLig.Clear;
        TPListeAvecLig.Add('NoLigne;CodeIntComm;MntTotComm;FraisPort;CodeIntProd;Qte;StatuCom;DateCom;LibProd;' +
          'PxUnit;SKUProd;PA;Vente;EMail;PrenomFact;NomFact;NumCom;AdrLiv1;AdrLiv2;Vil;' +
          'Pays;Tel;CodePostal;PrenomLiv;NomLiv;Taille');
        FOR j := 2 TO TPListe.Count DO
          TPListeAvecLig.Add(inttostr(j) + ';' + TPListe[j - 1]);

        //chargement du fichier
        sTemp := sDest + 'temp_' + FormatDateTime('yyyymmdd hhnnss', now) + '.csv';
        //fichier temporaire car LoadFromStream ne marche pas !!!
        bOk := false;
        MemD_ImportVtePriv.SortedField := '';
        MemD_ImportVtePriv.Active := false;
        MemD_ImportVtePriv.Active := true;
        TRY
          TPListeAvecLig.SaveToFile(sTemp);
          MemD_ImportVtePriv.LoadFromTextFile(sTemp);
          bOk := true;
        EXCEPT
          DoRapport(sFicSrc, 0, 'Erreur de chargement du fichier', '', '', '', '');
        END;
        Frm_Progression.IncLigne(20);
        IF FileExists(sTemp) THEN
          DeleteFile(sTemp);

        //Contrôle du fichier
        IF bOk THEN
        BEGIN
          WITH MemD_ImportVtePriv DO
          BEGIN
            First;
            WHILE NOT (Eof) DO
            BEGIN

              IF NOT (TestLigneVide(MemD_ImportVtePriv)) THEN
              BEGIN
                //controle de la validité des champs
                Edit;

                //Date de commande et Libellé du produit sont en premier
                //pour qu'ils soient correctement mis dans le rapport d'erreur si besoin
                //Date de commande
                fieldbyname('DateCom').AsString := CtrlDateTime(fieldbyname('DateCom').AsString, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Date de commande (Col. 7) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //Libellé du produit
                fieldbyname('LibProd').AsString := UpperCase(CtrlString(fieldbyname('LibProd').AsString, true, bOk2));
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Libellé du produit (Col. 8) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //Code interne de la commande
                fieldbyname('CodeIntComm').AsString := CtrlString(fieldbyname('CodeIntComm').AsString, true, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Code interne de la commande (Col. 1) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                if Length(fieldbyname('CodeIntComm').AsString) > 32 then
                begin
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Code interne de la commande (Col. 1) trop long',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                end;

                //Montant total de la commande
                fieldbyname('MntTotComm').AsString := CtrlFloat(fieldbyname('MntTotComm').AsString, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Montant total de la commande (Col. 2) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //Frais de port
                fieldbyname('FraisPort').AsString := CtrlFloat(fieldbyname('FraisPort').AsString, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Frais de port (Col. 3) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //pas de controle sur Code interne de produit

                //Quantité
                fieldbyname('Qte').AsString := CtrlFloat(fieldbyname('Qte').AsString, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Quantité (Col. 5) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //pas besoin pour Statut de la commande (StatuCom)

                //Prix unitaire
                fieldbyname('PxUnit').AsString := CtrlFloat(fieldbyname('PxUnit').AsString, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Prix unitaire (Col. 9) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //SKU du produit
                fieldbyname('SKUProd').AsString := CtrlString(fieldbyname('SKUProd').AsString, true, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'SKU du produit (Col. 10) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END
                ELSE
                BEGIN
                  //test validité du code SKU
                  sCodBar := UpperCase(fieldbyname('SKUProd').AsString);
                  IF Pos('*', sCodBar) = 0 THEN
                  BEGIN //article seul
                    ArtInfos := DM_Common.GetArticleInfos(sCodBar);
                    IF NOT (ArtInfos.IsValide) THEN
                    BEGIN
                      bOk := false;
                      DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger,
                        'SKU du produit (Col. 10) non valide ou non trouvé',
                        fieldbyname('CodeIntComm').AsString, sCodBar,
                        fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                    END;
                  END
                  ELSE
                  BEGIN
                    LstLot.Clear;
                    LstLot.Text := StringReplace(sCodBar, '*', #13#10, [rfReplaceAll]);
                    IF LstLot.Count <= 1 THEN
                    BEGIN
                      bOk := false;
                      DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'SKU du produit (Col. 10) invalide',
                        fieldbyname('CodeIntComm').AsString, sCodBar,
                        fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                    END
                    ELSE
                    BEGIN
                      // le format est CB * CB * ....* CB * N° lot
                      //test N° lot --> 0 = Ok
                      case DM_Common.IsLotValid(StrToIntDef(LstLot[LstLot.Count - 1], -1)) of
                        1:
                          begin
                            bOk := false;
                            DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'N° lot invalide',
                              fieldbyname('CodeIntComm').AsString, Trim(LstLot[0]),
                              fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                          end;
                        2:
                          begin
                            bOk := false;
                            DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'N° lot inconnu',
                              fieldbyname('CodeIntComm').AsString, Trim(LstLot[0]),
                              fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                          end;
                        3:
                          begin
                            bOk := false;
                            DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'N° lot supprimé',
                              fieldbyname('CodeIntComm').AsString, Trim(LstLot[0]),
                              fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                          end;
                      end;
                      //test les articles
                      FOR j := 0 TO LstLot.Count - 2 DO
                      BEGIN
                        ArtInfos := DM_Common.GetArticleInfos(Trim(LstLot[j]));
                        IF NOT (ArtInfos.IsValide) THEN
                        BEGIN
                          bOk := false;
                          DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger,
                            'SKU du produit (Col. 10) non valide ou non trouvé',
                            fieldbyname('CodeIntComm').AsString, Trim(LstLot[j]),
                            fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                        END;
                      END;
                    END;
                  END;
                END;
                //pas besoin de tester le PA

                //Vente (pas de contrôle dessus: champ non obligatoire)
                fieldbyname('Vente').AsString := UpperCase(CtrlString(fieldbyname('Vente').AsString, false, bOk2));

                //EMail du client
                fieldbyname('EMail').AsString := CtrlMail(fieldbyname('EMail').AsString, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'EMail du client (Col. 13) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                //Prénom facturation  (champ non obligatoire ?)
                fieldbyname('PrenomFact').AsString := UpperCase(CtrlString(fieldbyname('PrenomFact').AsString, false,
                  bOk2));

                //Nom facturation
                fieldbyname('NomFact').AsString := UpperCase(CtrlString(fieldbyname('NomFact').AsString, true, bOk2));
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Nom facturation (Col. 15) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                //Numéro de commande
                fieldbyname('NumCom').AsString := CtrlString(fieldbyname('NumCom').AsString, true, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Numéro de commande (Col. 16) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                //Adresse livraison N°1
                fieldbyname('AdrLiv1').AsString := UpperCase(CtrlString(fieldbyname('AdrLiv1').AsString, true, bOk2));
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Adresse livraison  (Col. 17) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                //Adresse livraison N°2  (champ non obligatoire)
                fieldbyname('AdrLiv2').AsString := UpperCase(CtrlString(fieldbyname('AdrLiv2').AsString, false, bOk2));

                //Ville
                fieldbyname('Vil').AsString := UpperCase(CtrlVille(fieldbyname('Vil').AsString, bOk2));
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Ville  (Col. 19) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                //Pays
                fieldbyname('Pays').AsString := UpperCase(CtrlString(fieldbyname('Pays').AsString, true, bOk2));
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Pays (Col. 20) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                //Téléphone du client  (champ non obligatoire)
                fieldbyname('Tel').AsString := CtrlString(fieldbyname('Tel').AsString, false, bOk2);
                //rajout d'un zero si le tel fait 9 carac
                if Length(fieldbyname('Tel').AsString) = 9 then
                  fieldbyname('Tel').AsString := '0' + fieldbyname('Tel').AsString;

                //Code postal
                fieldbyname('CodePostal').AsString := CtrlString(fieldbyname('CodePostal').AsString, true, bOk2);
                IF NOT (bOk2) THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Code postal (Col. 22) invalide',
                    fieldbyname('CodeIntComm').AsString, fieldbyname('SKUProd').AsString,
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;

                //Prénom Livraison  (champ non obligatoire)
                fieldbyname('PrenomLiv').AsString := UpperCase(CtrlString(fieldbyname('PrenomLiv').AsString, false,
                  bOk2));

                //Nom Livraison  (champ non obligatoire)
                fieldbyname('NomLiv').AsString := UpperCase(CtrlString(fieldbyname('NomLiv').AsString, false, bOk2));

                //Taille Livraison  (champ non obligatoire)
                fieldbyname('Taille').AsString := UpperCase(CtrlString(fieldbyname('Taille').AsString, false, bOk2));

                Post;
              END;

              Frm_Progression.IncLigne;
              Next;
            END;
          END;

          //Contrôle des totaux
          TpComm := '';
          totAff := 0.0;
          TotCal := 0.0;
          DebNoLigne := MemD_ImportVtePriv.fieldbyname('NoLigne').AsInteger;
          WITH MemD_ImportVtePriv DO
          BEGIN
            SortedField := 'CodeIntComm';
            First;
            WHILE NOT (Eof) DO
            BEGIN
              IF NOT (TestLigneVide(MemD_ImportVtePriv)) THEN
              BEGIN
                IF fieldbyname('CodeIntComm').AsString <> TpComm THEN
                BEGIN
                  IF TotCal <> TotAff THEN
                  BEGIN
                    bOk := false;
                    DoRapport(sFicSrc, DebNoLigne, 'Le total des lignes ne correspond pas à l''entête de commande',
                      TpComm, '',
                      fieldbyname('DateCom').AsString, '');
                  END;
                  TpComm := fieldbyname('CodeIntComm').AsString;
                  TotCal := 0.0;
                  DebNoLigne := fieldbyname('NoLigne').AsInteger;
                END;
                TotAff := ArrondiA2(StrToFloatDef(fieldbyname('MntTotComm').AsString, 0) -
                  StrToFloatDef(fieldbyname('FraisPort').AsString, 0));
                IF TotAff <= 0.0 THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger,
                    '(Total - Frais de port) inférieur ou égal à zéro',
                    TpComm, '',
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                TotLig := ArrondiA2(StrToFloatDef(fieldbyname('Qte').AsString, 0) *
                  StrToFloatDef(fieldbyname('PxUnit').AsString, 0));
                IF TotLig <= 0.0 THEN
                BEGIN
                  bOk := false;
                  DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, '(Qté*Px Unit) inférieur ou égal à zéro',
                    TpComm, '',
                    fieldbyname('DateCom').AsString, fieldbyname('LibProd').AsString);
                END;
                TotCal := ArrondiA2(TotCal + TotLig);
              END;

              Frm_Progression.IncLigne;
              Next;
            END;
            IF TotCal <> TotAff THEN
            BEGIN
              bOk := false;
              DoRapport(sFicSrc, DebNoLigne, 'Le total des lignes ne correspond pas à l''entête de commande',
                TpComm, '',
                fieldbyname('DateCom').AsString, '');
            END;

          END;
        END;

        //intégration des données
        IF bOk THEN
        BEGIN
          IdCommande := 0;
          sErreur := '';
          NoLigne := 2;
          TpComm := '';
          IDPays := 0;
          IDClt := 0;
          NumLot := 1;
          Dm_Common.IbT_GenSku.StartTransaction;
          TRY
            WITH MemD_ImportVtePriv DO
            BEGIN
              SortedField := 'CodeIntComm';
              First;
              WHILE NOT (Eof) DO
              BEGIN
                NoLigne := fieldbyname('NoLigne').AsInteger;
                IF NOT (TestLigneVide(MemD_ImportVtePriv)) THEN
                BEGIN
                  IF TpComm <> fieldbyname('CodeIntComm').AsString THEN
                  BEGIN //différent donc nouveau client
                    //recherche ou crée le pays
                    sErreur := '(Pays)';
                    IDPays := 0;
                    WITH Dm_Common.Que_GetPayPriv DO
                    BEGIN
                      Active := false;
                      ParamByName('PAYNOM').asString := MemD_ImportVtePriv.fieldbyname('Pays').AsString;
                      Active := true;
                      IDPays := FieldByName('PAY_ID').AsInteger;
                      Active := false;
                    END;

                    //Recherche d'un ID pour la commande à partir du code interne
                    with Dm_Common.Que_GetNumCommPriv do
                    begin
                      Active := false;
                      ParamByName('IDREF').AsString := MemD_ImportVtePriv.fieldbyname('CodeIntComm').AsString;
                      Active := true;
                      IdCommande := fieldbyname('ID').AsInteger;
                      IdCommandeExists := fieldbyname('OKEXISTS').AsInteger;
                      Active := false;
                    end;
                    OkFaireCommande := (IdCommandeExists = 0);
                    if not (OkFaireCommande) then
                    begin
                      bOk := false;
                      DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Commande déja intégrée !',
                        fieldbyname('CodeIntComm').AsString, '',
                        fieldbyname('DateCom').AsString, '');
                    end;

                    if OkFaireCommande then
                    begin
                      //Création du client
                      sErreur := '(Création client)';
                      IDClt := 0;
                      WITH Dm_Common.Que_CreClientPriv DO
                      BEGIN
                        Active := false;
                        ParamByName('NOM_CLIENT').AsString := MemD_ImportVtePriv.fieldbyname('NomFact').AsString;
                        ParamByName('PRENOM_CLIENT').AsString := MemD_ImportVtePriv.fieldbyname('PrenomFact').AsString;
                        ParamByName('EMAIL_CLIENT').AsString := MemD_ImportVtePriv.fieldbyname('EMail').AsString;
                        ParamByName('ADRESSE_FACTURATION').AsString := MemD_ImportVtePriv.fieldbyname('AdrLiv1').AsString
                          +
                          #13#10 +
                          MemD_ImportVtePriv.fieldbyname('AdrLiv2').AsString;
                        ParamByName('CP_CLIENT').AsString := MemD_ImportVtePriv.fieldbyname('CodePostal').AsString;
                        ParamByName('VILLE_CLIENT').AsString := MemD_ImportVtePriv.fieldbyname('Vil').AsString;
                        ParamByName('ID_PAYS').AsInteger := IDPays;
                        ParamByName('TEL_CLIENT').AsString := '';
                        ParamByName('GSM_CLIENT').AsString := '';
                        ParamByName('FAX_CLIENT').AsString := '';
                        ParamByName('NOM_CLIENT_LIVRAISON').AsString :=
                          MemD_ImportVtePriv.fieldbyname('NomLiv').AsString;
                        ParamByName('PRENOM_CLIENT_LIVRAISON').AsString :=
                          MemD_ImportVtePriv.fieldbyname('PrenomLiv').AsString;
                        ParamByName('EMAIL_CLIENT_LIVRAISON').AsString :=
                          MemD_ImportVtePriv.fieldbyname('EMail').AsString;
                        ParamByName('ADRESSE_LIVRAISON').AsString := MemD_ImportVtePriv.fieldbyname('AdrLiv1').AsString
                          +
                          #13#10 +
                          MemD_ImportVtePriv.fieldbyname('AdrLiv2').AsString;
                        ParamByName('CP_CLIENT_LIVRAISON').AsString :=
                          MemD_ImportVtePriv.fieldbyname('CodePostal').AsString;
                        ParamByName('VILLE_CLIENT_LIVRAISON').AsString :=
                          MemD_ImportVtePriv.fieldbyname('Vil').AsString;
                        ParamByName('ID_PAYS_LIVRAISON').AsInteger := IDPays;
                        ParamByName('TEL_CLIENT_LIVRAISON').AsString := MemD_ImportVtePriv.fieldbyname('Tel').AsString;
                        ParamByName('SOCIETE').AsString := '';
                        ParamByName('NUM_SIRET').AsString := '';
                        ParamByName('NUM_TVA').AsString := '';
                        Active := true;
                        IDClt := fieldbyname('RET_CLTID').AsInteger;
                        IF IDClt = 0 THEN
                        BEGIN
                          DoRapport(sFicSrc, fieldbyname('NoLigne').AsInteger, 'Client non créé', '', '', '', '');
                          bOk := false;
                        END;
                        Active := false;
                      END;

                      //recherche du taux de tva du premier article
                      sErreur := '(Recherche TVA)';
                      sCodBar := UpperCase(MemD_ImportVtePriv.fieldbyname('SKUProd').AsString);
                      IF Pos('*', sCodBar) = 0 THEN //article seul
                        ArtInfos := DM_Common.GetArticleInfos(sCodBar)
                      ELSE
                      BEGIN
                        LstLot.Clear;
                        LstLot.Text := StringReplace(sCodBar, '*', #13#10, [rfReplaceAll]);
                        ArtInfos := DM_Common.GetArticleInfos(Trim(LstLot[1]));
                      END;
                      TauTvaEnt := ArtInfos.fTVA;

                      //Creation entête commande
                      TotAff := StrToFloat(MemD_ImportVtePriv.fieldbyname('MntTotComm').AsString);
                      sErreur := '(Entête Commande)';
                      WITH Dm_Common.Que_CreCommEnt DO
                      BEGIN
                        Active := false;
                        ParamByName('IDCLT').AsInteger := IDClt;
                        ParamByName('ID_COMMANDE').AsInteger := IdCommande;
                        ParamByName('NUM_COMMANDE').AsString := MemD_ImportVtePriv.fieldbyname('NumCom').AsString;
                        ParamByName('MT_TTC1').AsFloat := ArrondiA2(TotAff);
                        ParamByName('MT_HT1').AsFloat := ArrondiA2(TotAff / (1 + (TauTvaEnt / 100)));
                        ParamByName('MT_TAUX_HT1').AsFloat := TauTvaEnt;
                        ParamByName('MT_TTC2').AsFloat := 0.0;
                        ParamByName('MT_HT2').AsFloat := 0.0;
                        ParamByName('MT_TAUX_HT2').AsFloat := 0.0;
                        ParamByName('MT_TTC3').AsFloat := 0.0;
                        ParamByName('MT_HT3').AsFloat := 0.0;
                        ParamByName('MT_TAUX_HT3').AsFloat := 0.0;
                        ParamByName('MT_TTC4').AsFloat := 0.0;
                        ParamByName('MT_HT4').AsFloat := 0.0;
                        ParamByName('MT_TAUX_HT4').AsFloat := 0.0;
                        ParamByName('MT_TTC5').AsFloat := 0.0;
                        ParamByName('MT_HT5').AsFloat := 0.0;
                        ParamByName('MT_TAUX_HT5').AsFloat := 0.0;
                        ParamByName('REMISE').AsFloat := 0.0;
                        ParamByName('COMENT').AsString := MemD_ImportVtePriv.fieldbyname('Vente').AsString;
                        ParamByName('HTWORK').AsInteger := 0;
                        ParamByName('CODE_SITE_WEB').AsInteger := ASS_Code;
                        ParamByName('DATE_CREATION').AsDateTime :=
                          StrToDateTime(MemD_ImportVtePriv.fieldbyname('DateCom').AsString);
                        ParamByName('DATE_PAIEMENT').AsDateTime :=
                          StrToDateTime(MemD_ImportVtePriv.fieldbyname('DateCom').AsString);
                        ParamByName('MONTANT_FRAIS_PORT').AsFloat :=
                          ArrondiA2(StrToFloat(MemD_ImportVtePriv.fieldbyname('FraisPort').AsString));
                        ParamByName('DETAXE').AsInteger := 0;
                        ParamByName('ID_PAIEMENT_TYPE').AsInteger := 0;
                        ParamByName('NOM_CLIENT_LIVR').AsString := MemD_ImportVtePriv.fieldbyname('NomLiv').AsString;
                        ParamByName('PRENOM_CLIENT_LIVR').AsString :=
                          MemD_ImportVtePriv.fieldbyname('PrenomLiv').AsString;
                        ExecSQL;   
                        Active := false;
                      END;
                    end;

                    TpComm := fieldbyname('CodeIntComm').AsString;
                  END;

                  if OkFaireCommande then
                  begin
                    //Création des lignes
                    sErreur := '(Ligne de Commande)';
                    sCodBar := UpperCase(MemD_ImportVtePriv.fieldbyname('SKUProd').AsString);
                    IF Pos('*', sCodBar) = 0 THEN
                    BEGIN //article seul
                      ArtInfos := DM_Common.GetArticleInfos(sCodBar);

                      WITH Dm_Common.Que_CreCommLig DO
                      BEGIN
                        Active := false;
                        ParamByName('ID_COMMANDE').AsInteger := IdCommande;
                        ParamByName('ID_PRODUIT').AsInteger := ArtInfos.iArtId;
                        ParamByName('ID_TAILLE').AsInteger := ArtInfos.iTgfId;
                        ParamByName('ID_COULEUR').AsInteger := ArtInfos.iCouId;
                        ParamByName('ID_PACK').AsInteger := 0;
                        ParamByName('NUM_LOT').AsInteger := 0;
                        ParamByName('ID_CODE_PROMO').AsInteger := 0;
                        ParamByName('QTE').AsInteger := StrToInt(MemD_ImportVtePriv.fieldbyname('Qte').AsString);
                        ParamByName('PX_BRUT').AsFloat := ArtInfos.fPxBrut;
                        ParamByName('PX_NET').AsFloat :=
                          ArrondiA2(StrToInt(MemD_ImportVtePriv.fieldbyname('Qte').AsString) *
                          StrToFloat(MemD_ImportVtePriv.fieldbyname('PxUnit').AsString));
                        ParamByName('PX_NET_NET').AsFloat :=
                          ArrondiA2(StrToFloat(MemD_ImportVtePriv.fieldbyname('PxUnit').AsString));
                        ParamByName('POINTURE').AsString := '';
                        IF Pos('UNIQUE', UpperCase(MemD_ImportVtePriv.fieldbyname('Taille').AsString)) = 0 THEN
                          ParamByName('LONGUEUR').AsString := MemD_ImportVtePriv.fieldbyname('Taille').AsString
                        ELSE
                          ParamByName('LONGUEUR').AsString := '';
                        ParamByName('MONTAGE_FIXATIONS').AsInteger := 1;
                        ParamByName('INFO_SUP').AsString := '';
                        ParamByName('TYPE_VTE').AsInteger := 1;
                        ExecSQL;    
                        Active := false;
                      END;
                    END
                    ELSE
                    BEGIN //lot
                      //boucle sur les qté car il qté à 1 pour les lots
                      for k := 1 to StrToInt(MemD_ImportVtePriv.fieldbyname('Qte').AsString) do
                      begin
                        LstLot.Clear;
                        LstLot.Text := StringReplace(sCodBar, '*', #13#10, [rfReplaceAll]);
                        FOR j := 0 TO LstLot.Count - 2 DO
                        BEGIN
                          ArtInfos := DM_Common.GetArticleInfos(Trim(LstLot[j]));
                          WITH Dm_Common.Que_CreCommLig DO
                          BEGIN
                            Active := false;
                            ParamByName('ID_COMMANDE').AsInteger := IdCommande;
                            ParamByName('ID_PRODUIT').AsInteger := ArtInfos.iArtId;
                            ParamByName('ID_TAILLE').AsInteger := ArtInfos.iTgfId;
                            ParamByName('ID_COULEUR').AsInteger := ArtInfos.iCouId;
                            ParamByName('ID_PACK').AsInteger := StrToInt(Trim(LstLot[LstLot.Count - 1]));
                            ParamByName('NUM_LOT').AsInteger := NumLot;
                            ParamByName('ID_CODE_PROMO').AsInteger := 0;
                            ParamByName('QTE').AsInteger := 1;
                            ParamByName('PX_BRUT').AsFloat := ArtInfos.fPxBrut;
                            ParamByName('PX_NET').AsFloat := StrToFloat(MemD_ImportVtePriv.fieldbyname('PxUnit').AsString);
                            ParamByName('PX_NET_NET').AsFloat :=
                              ArrondiA2(StrToFloat(MemD_ImportVtePriv.fieldbyname('PxUnit').AsString));
                            ParamByName('POINTURE').AsString := '';
                            IF Pos('UNIQUE', UpperCase(MemD_ImportVtePriv.fieldbyname('Taille').AsString)) = 0 THEN
                              ParamByName('LONGUEUR').AsString := MemD_ImportVtePriv.fieldbyname('Taille').AsString;
                            ParamByName('MONTAGE_FIXATIONS').AsInteger := 1;
                            ParamByName('INFO_SUP').AsString := '';
                            ParamByName('TYPE_VTE').AsInteger := 1;
                            ExecSQL;
                            Active := false;
                          END;
                        END;
                        inc(NumLot);
                      end;   //for Qté
                    END;
                  end; //if OkFaireCommande
                END; // if not(testlignevide)

                Frm_Progression.IncLigne;
                Next;
              END;
            END;

            IF bOk THEN
              Dm_Common.IbT_GenSku.Commit
            ELSE
              Dm_Common.IbT_GenSku.Rollback;
          EXCEPT
            ON E: Exception DO
            BEGIN
              Dm_Common.IbT_GenSku.Rollback;
              LogAction('Erreur lors de l''intégration des commande GENERIQUE_SKU', 0);
              LogAction(E.Message, 0);
              DoRapport(sFicSrc, NoLigne, 'Erreur lors de l''intégration des commandes GENERIQUE_SKU ' + sErreur, '',
                '', '', '');
              bOk := false;
            END;
          END;
        END;

      END;
      IF bOk THEN
      BEGIN
        RenameFile(sRepSrc + sFicSrc, sDestOK + sFicDst);
        inc(NbOk);
      END
      ELSE
      BEGIN
        RenameFile(sRepSrc + sFicSrc, sDestECHEC + sFicDst);
        inc(NbEchec);
      END;
      IF Dm_Common.MemD_Rapport.RecordCount > 0 THEN
        Dm_Common.MemD_Rapport.SaveToTextFile(sDestRAPPORT + sFicRapp);
    END;

  FINALLY
    Application.ProcessMessages;
    MemD_ImportVtePriv.Active := false;
    Dm_Common.MemD_Rapport.Active := false;
    TPListeATraiter.Free;
    TPListe.Free;
    TPListeAvecLig.Free;
    LstLot.Free;
    Frm_Progression.Free;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  END;
END;

END.


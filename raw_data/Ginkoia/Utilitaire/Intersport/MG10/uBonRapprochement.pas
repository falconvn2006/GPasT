unit uBonRapprochement;

interface

uses
  Classes, SysUtils, IBSQL, IBQuery, Graphics, uLog;

type
  TBonRapprochement = class(TThread)
    private
      bRetirePtVirg: Boolean;
      sFichierBonRapprochement: String;
      sFichierBonRapprochementLien: String;
      sFichierBonRapprochementTVA: String;
      sFichierBonRapprochementLigneReception: String;
      sFichierBonRapprochementLigneRetour: String;

      sEtat1, sEtat2, sError, sLigneLecture: String;
      iMaxProgress, iProgress, iTraitement, iNbTraitement: Integer;

      cds_BonRapprochement: TStringList;
      cds_BonRapprochementLien: TStringList;
      cds_BonRapprochementTVA: TStringList;
      cds_BonRapprochementLigneReception: TStringList;
      cds_BonRapprochementLigneRetour: TStringList;

      StProc_BonRapprochement: TIBSQL;
      StProc_BonRapprochementLien: TIBSQL;
      StProc_BonRapprochementTVA: TIBSQL;
      StProc_BonRapprochementLigneReception: TIBSQL;
      StProc_BonRapprochementLigneRetour: TIBSQL;

      procedure DoLog(const sVal: String; const aLvl: TLogLevel);
      function LoadFile: Boolean;
      function TraiterBonRapprochement: Boolean;
      function TraiterBonRapprochementLien: Boolean;
      function TraiterBonRapprochementTVA: Boolean;
      function TraiterBonRapprochementLigneReception: Boolean;
      function TraiterBonRapprochementLigneRetour: Boolean;
      procedure AjoutInfoLigne(const ALigne: String; ADefColonne: Array of String);
      function GetValueBonRapprochementImp(const AChamp: String): String;
      function GetValueBonRapprochementLienImp(const AChamp: String): String;
      function GetValueBonRapprochementTVAImp(const AChamp: String): String;
      function GetValueBonRapprochementLigneReceptionImp(const AChamp: String): String;
      function GetValueBonRapprochementLigneRetourImp(const AChamp: String): String;

      // Mise-à-jour de la fenêtre d'attente.
      procedure InitFrm;           // Initialisation.
      procedure InitExecute;       // Début exécution.
      procedure UpdateFrm;         // Mise à jour.
      procedure InitProgressFrm;   // Initialisation progression.
      procedure UpdProgressFrm;    // Maj progression.
      procedure ErrorFrm;          // Traitement des erreurs.
      procedure EndFrm;            // Fin du traitement.

    protected
      procedure Execute;   override;

    public
      bError: Boolean;

      constructor Create(const aCreateSuspended, aEnabledProcess: Boolean);
      procedure InitThread(const aRetirePtVirg: Boolean; const aFichierBonRapprochement, aFichierBonRapprochementLien, aFichierBonRapprochementTVA, aFichierBonRapprochementLigneReception, aFichierBonRapprochementLigneRetour: String);
      destructor Destroy;   override;
  end;

implementation

uses Main_Dm, uDefs, GinkoiaStyle_Dm, Load_Frm, uCommon;

{ TBonRapprochement }

constructor TBonRapprochement.Create(const aCreateSuspended, aEnabledProcess: Boolean);
begin
  inherited Create(aCreateSuspended);
  FreeOnTerminate := True;
  Priority := tpHigher;

  sEtat1 := '';      sEtat2 := '';      sError := '';
  bError := False;
  iNbTraitement := 5;

  cds_BonRapprochement := TStringList.Create;
  cds_BonRapprochementLien := TStringList.Create;
  cds_BonRapprochementTVA := TStringList.Create;
  cds_BonRapprochementLigneReception := TStringList.Create;
  cds_BonRapprochementLigneRetour := TStringList.Create;

  Dm_Main.TransacBonR.Active := True;

  // Bon de rapprochement.
  StProc_BonRapprochement := TIBSQL.Create(nil);
  StProc_BonRapprochement.Database := Dm_Main.Database;
  StProc_BonRapprochement.Transaction := Dm_Main.TransacBonR;
  StProc_BonRapprochement.ParamCheck := True;
  StProc_BonRapprochement.SQL.Add(cSql_MG10_BON_RAPPROCHEMENT);
  StProc_BonRapprochement.Prepare;

  // Bon de rapprochement - lien.
  StProc_BonRapprochementLien := TIBSQL.Create(nil);
  StProc_BonRapprochementLien.Database := Dm_Main.Database;
  StProc_BonRapprochementLien.Transaction := Dm_Main.TransacBonR;
  StProc_BonRapprochementLien.ParamCheck := True;
  StProc_BonRapprochementLien.SQL.Add(cSql_MG10_BON_RAPPROCHEMENT_LIEN);
  StProc_BonRapprochementLien.Prepare;

  // Bon de rapprochement - TVA.
  StProc_BonRapprochementTVA := TIBSQL.Create(nil);
  StProc_BonRapprochementTVA.Database := Dm_Main.Database;
  StProc_BonRapprochementTVA.Transaction := Dm_Main.TransacBonR;
  StProc_BonRapprochementTVA.ParamCheck := True;
  StProc_BonRapprochementTVA.SQL.Add(cSql_MG10_BON_RAPPROCHEMENT_TVA);
  StProc_BonRapprochementTVA.Prepare;

  // Bon de rapprochement - ligne réception.
  StProc_BonRapprochementLigneReception := TIBSQL.Create(nil);
  StProc_BonRapprochementLigneReception.Database := Dm_Main.Database;
  StProc_BonRapprochementLigneReception.Transaction := Dm_Main.TransacBonR;
  StProc_BonRapprochementLigneReception.ParamCheck := True;
  StProc_BonRapprochementLigneReception.SQL.Add(cSql_MG10_BON_RAPPROCHEMENT_LIGNE_RECEPTION);
  StProc_BonRapprochementLigneReception.Prepare;

  // Bon de rapprochement - ligne retour.
  StProc_BonRapprochementLigneRetour := TIBSQL.Create(nil);
  StProc_BonRapprochementLigneRetour.Database := Dm_Main.Database;
  StProc_BonRapprochementLigneRetour.Transaction := Dm_Main.TransacBonR;
  StProc_BonRapprochementLigneRetour.ParamCheck := True;
  StProc_BonRapprochementLigneRetour.SQL.Add(cSql_MG10_BON_RAPPROCHEMENT_LIGNE_RETOUR);
  StProc_BonRapprochementLigneRetour.Prepare;
end;

procedure TBonRapprochement.DoLog(const sVal: String; const aLvl: TLogLevel);
begin
  uLog.Log.Log('uBonRapprochement', 'log', sVal, aLvl, False, -1, ltLocal);
end;

procedure TBonRapprochement.InitThread(const aRetirePtVirg: Boolean; const aFichierBonRapprochement, aFichierBonRapprochementLien, aFichierBonRapprochementTVA, aFichierBonRapprochementLigneReception, aFichierBonRapprochementLigneRetour: String);
begin
  Synchronize(InitFrm);

  bRetirePtVirg := aRetirePtVirg;

  sFichierBonRapprochement := aFichierBonRapprochement;
  sFichierBonRapprochementLien := aFichierBonRapprochementLien;
  sFichierBonRapprochementTVA := aFichierBonRapprochementTVA;
  sFichierBonRapprochementLigneReception := aFichierBonRapprochementLigneReception;
  sFichierBonRapprochementLigneRetour := aFichierBonRapprochementLigneRetour;
end;

procedure TBonRapprochement.Execute;
var
  bContinue: Boolean;
  tTot, tProc: TDateTime;
  tpListeDelai: TStringList;
begin
  bError := False;
  bContinue := True;
  tTot := Now;

  tpListeDelai := TStringList.Create;
  try
    iTraitement := 0;
    Synchronize(InitExecute);

    // Si pas de correspondances de lignes de réception.
    if(Dm_Main.ListeIDLigneReception.Count = 0) and (Dm_Main.ListeIDLigneRetourfou.Count = 0) then
    begin
      bError := True;
      sError := 'Erreur :  les réceptions et les retours fournisseur n''ont pas été importées !';
    end
    else
    begin
      // Chargement des fichiers.
      if bContinue then
      begin
        tProc := Now;
        bContinue := LoadFile;
        tpListeDelai.Add('  Chargement des fichiers: ' + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Bon de rapprochement - Chargement des fichiers: ' + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // Bon rapprochement.
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterBonRapprochement;
        tpListeDelai.Add('  Bon rapprochement: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Bon rapprochement: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // Bon rapprochement - lien.
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterBonRapprochementLien;
        tpListeDelai.Add('  Bon rapprochement lien: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Bon rapprochement lien: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // Bon rapprochement - TVA.
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterBonRapprochementTVA;
        tpListeDelai.Add('  Bon rapprochement TVA: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Bon rapprochement TVA: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // Bon rapprochement - ligne réception.
      if bContinue and (Dm_Main.ListeIDLigneReception.Count > 0) then
      begin
        tProc := Now;
        bContinue := TraiterBonRapprochementLigneReception;
        tpListeDelai.Add('  Bon rapprochement ligne réception: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Bon rapprochement ligne réception: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // Bon rapprochement - ligne retour fournisseur.
      if bContinue and (Dm_Main.ListeIDLigneRetourfou.Count > 0) then
      begin
        tProc := Now;
        bContinue := TraiterBonRapprochementLigneRetour;
        tpListeDelai.Add('  Bon rapprochement ligne retour: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Bon rapprochement ligne retour: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;
    end;

    if sError <> '' then
    begin
      tpListeDelai.Add(sError);
      if Dm_Main.GetDoMail(ErreurMail) then
        SendEmail(Dm_Main.GetMailLst, '[ALERT - ERREUR] - ' + Dm_Main.GetSubjectMail, 'Bon rapprochement - ' + sError);
    end;

    tpListeDelai.Add('');
    tpListeDelai.Add('');
    tpListeDelai.Add('Temps total: ' + FormatDateTime('hh:nn:ss:zzz', Now - tTot));
    if Dm_Main.GetDoMail(CliArtHistBonRAtelier) then
        SendEmail(Dm_Main.GetMailLst, '[Fin bon rapprochement] - ' + Dm_Main.GetSubjectMail, 'Bon rapprochement - Temps total: ' + FormatDateTime('hh:nn:ss:zzz', Now - tTot));

    try
      tpListeDelai.SaveToFile(Dm_Main.ReperBase + Dm_Main.GetSubjectMail + '_Delai_Import_BonR_' + FormatDateTime('yyyy-mm-dd hhnnss', Now) + '.txt');
    except
    end;

    if bContinue then
      Synchronize(EndFrm);
  finally
    FreeAndNil(tpListeDelai);
    bError := not bContinue;
  end;
end;

function TBonRapprochement.LoadFile: Boolean;
begin
  Result := True;
  cds_BonRapprochement.Clear;
  cds_BonRapprochementLien.Clear;
  cds_BonRapprochementTVA.Clear;
  cds_BonRapprochementLigneReception.Clear;
  cds_BonRapprochementLigneRetour.Clear;
  sEtat1 := 'Chargement:';

  // Chargement bons rapprochement.
  try
    sEtat2 := 'Fichier ' + BonRapprochement_CSV;
    Synchronize(UpdateFrm);
    cds_BonRapprochement.LoadFromFile(sFichierBonRapprochement);
    Dm_Main.LoadListeBonRapprochementID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement liens bons rapprochement.
  try
    sEtat2 := 'Fichier ' + BonRapprochementLien_CSV;
    Synchronize(UpdateFrm);
    cds_BonRapprochementLien.LoadFromFile(sFichierBonRapprochementLien);
    Dm_Main.LoadListeBonRapprochementLienID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement TVA bons rapprochement.
  try
    sEtat2 := 'Fichier ' + BonRapprochementTVA_CSV;
    Synchronize(UpdateFrm);
    cds_BonRapprochementTVA.LoadFromFile(sFichierBonRapprochementTVA);
    Dm_Main.LoadListeBonRapprochementTVAID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement lignes réception bons rapprochement.
  try
    sEtat2 := 'Fichier ' + BonRapprochementLigneReception_CSV;
    Synchronize(UpdateFrm);
    cds_BonRapprochementLigneReception.LoadFromFile(sFichierBonRapprochementLigneReception);
    Dm_Main.LoadListeBonRapprochementLigneReceptionID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement lignes retour bons rapprochement.
  try
    sEtat2 := 'Fichier ' + BonRapprochementLigneRetour_CSV;
    Synchronize(UpdateFrm);
    cds_BonRapprochementLigneRetour.LoadFromFile(sFichierBonRapprochementLigneRetour);
    Dm_Main.LoadListeBonRapprochementLigneRetourID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;
end;

function TBonRapprochement.TraiterBonRapprochement: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDFourn: Integer;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_BonRapprochement.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + BonRapprochement_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDBonRapprochement.Count;
  try
    for i:=1 to Pred(cds_BonRapprochement.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_BonRapprochement[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_BonRapprochement[i], BonRapprochement_COL);

          // Recherche si pas déjà importé.
          sID := GetValueBonRapprochementImp('ID');
          LRechID := Dm_Main.RechercheBonRapprochementID(sID, NbRech);

          // ID fournisseur.
          IDFourn := Dm_Main.GetFouID(GetValueBonRapprochementImp('ID_FOURN'));
          if IDFourn = -1 then
            raise Exception.Create('Erreur :  l''ancien fournisseur [ID = ' + GetValueBonRapprochementImp('ID_FOURN') + '] n''a pas de nouvel équivalent !');

          // Création si pas déjà créé.
          if(LRechID = -1) and (sID <> '') then
          begin
            if not Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.StartTransaction;

            // Traitement du bon de rapprochement.
            StProc_BonRapprochement.Close;
            StProc_BonRapprochement.ParamByName('DATE_CREATION').AsString := GetValueBonRapprochementImp('DATE_CREATION');
            StProc_BonRapprochement.ParamByName('DATE_FACTURE').AsString := GetValueBonRapprochementImp('DATE_FACTURE');
            StProc_BonRapprochement.ParamByName('DATE_ECHEANCE').AsString := GetValueBonRapprochementImp('DATE_ECHEANCE');
            StProc_BonRapprochement.ParamByName('MONTANT_FACTURE').AsString := GetValueBonRapprochementImp('MONTANT_FACTURE');
            StProc_BonRapprochement.ParamByName('FRAIS_PORT').AsString := GetValueBonRapprochementImp('FRAIS_PORT');
            StProc_BonRapprochement.ParamByName('FRAIS_ANNEXES').AsString := GetValueBonRapprochementImp('FRAIS_ANNEXES');
            StProc_BonRapprochement.ParamByName('CHRONO').AsString := GetValueBonRapprochementImp('CHRONO');
            StProc_BonRapprochement.ParamByName('NUM_FOURN_FACTURE').AsString := GetValueBonRapprochementImp('NUM_FOURN_FACTURE');
            StProc_BonRapprochement.ParamByName('ID_FOURN').AsInteger := IDFourn;
            StProc_BonRapprochement.ParamByName('REMISE_GLOBALE').AsString := GetValueBonRapprochementImp('REMISE_GLOBALE');
            StProc_BonRapprochement.ParamByName('MONTANT_TVA_REMISE_GLOBALE').AsString := GetValueBonRapprochementImp('MONTANT_TVA_REMISE_GLOBALE');
            StProc_BonRapprochement.ParamByName('MONTANT_TVA_FRAIS_PORT').AsString := GetValueBonRapprochementImp('MONTANT_TVA_FRAIS_PORT');
            StProc_BonRapprochement.ParamByName('MONTANT_TVA_FRAIS_ANNEXES').AsString := GetValueBonRapprochementImp('MONTANT_TVA_FRAIS_ANNEXES');
            StProc_BonRapprochement.ParamByName('CLOTURE').AsString := GetValueBonRapprochementImp('CLOTURE');
            StProc_BonRapprochement.ParamByName('EXPORTE').AsString := GetValueBonRapprochementImp('EXPORTE');
            StProc_BonRapprochement.ParamByName('CODE_MAG').AsString := GetValueBonRapprochementImp('CODE_MAG');
            StProc_BonRapprochement.ParamByName('DATE_EXPORT_COMPTABLE').AsString := GetValueBonRapprochementImp('DATE_EXPORT_COMPTABLE');
            StProc_BonRapprochement.ParamByName('COMMENTAIRE').AsString := GetValueBonRapprochementImp('COMMENTAIRE');
            StProc_BonRapprochement.ParamByName('ARCHIVE').AsString := GetValueBonRapprochementImp('ARCHIVE');
            StProc_BonRapprochement.ParamByName('CENTRALE').AsString := GetValueBonRapprochementImp('CENTRALE');
            StProc_BonRapprochement.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeBonRapprochementID(sID, StProc_BonRapprochement.FieldByName('RPEID').AsInteger);
            StProc_BonRapprochement.Close;

            Dm_Main.TransacBonR.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.Rollback;
            Result := False;
            sError := '(' + IntToStr(i) + ')' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;
      end;
    end;

    sEtat2 := '';
    iProgress := 0;
    Synchronize(UpdProgressFrm);
  finally
    Dm_Main.SaveListeBonRapprochementID;
    StProc_BonRapprochement.Close;
  end;
end;

function TBonRapprochement.TraiterBonRapprochementLien: Boolean;
var
  AvancePc, NbRech, i, IDBon, IDReception, IDRetour, LRechID: Integer;
  sIDBon, sIDReception, sIDRetour: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_BonRapprochementLien.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + BonRapprochementLien_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDBonRapprochementLien.Count;
  try
    for i:=1 to Pred(cds_BonRapprochementLien.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_BonRapprochementLien[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_BonRapprochementLien[i], BonRapprochementLien_COL);

          // IB bon de rapprochement.
          sIDBon := GetValueBonRapprochementLienImp('ID_BON');
          IDBon := Dm_Main.GetBonRapprochementID(sIDBon);
          if IDBon = -1 then
            raise Exception.Create('Erreur :  l''ancien bon de rapprochement [ID = ' + sIDBon + '] n''a pas de nouvel équivalent !');

          // ID réception.
          sIDReception := GetValueBonRapprochementLienImp('ID_RECEPTION');
//          if not TryStrToInt(sIDReception, IDReception) then
          IDReception := Dm_Main.GetReceptionID(sIDReception);
          if IDReception = -1 then
            IDReception := 0;

          // ID retour.
          sIDRetour := GetValueBonRapprochementLienImp('ID_RETOUR');
//          if not TryStrToInt(sIDRetour, IDRetour) then
          IDRetour := Dm_Main.GetRetourFouID(sIDRetour);
          if IDRetour = -1 then
            IDRetour := 0;

          if(IDReception = 0) and (IDRetour = 0) then
            raise Exception.Create('Erreur :  le lien réception [ancien ID = ' + sIDReception + '] - retour [ancien ID = ' + sIDRetour + '] du bon de rapprochement [ancien ID = ' + sIDBon + ' - nouvel ID = ' + IntToStr(IDBon) + '] n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          LRechID := Dm_Main.RechercheBonRapprochementLienID(sIDBon + sIDReception + sIDRetour, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sIDBon <> '') then
          begin
            if not Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.StartTransaction;

            // Traitement du lien du bon de rapprochement.
            StProc_BonRapprochementLien.Close;
            StProc_BonRapprochementLien.ParamByName('ID_BON').AsInteger := IDBon;
            StProc_BonRapprochementLien.ParamByName('ID_RECEPTION').AsInteger := IDReception;
            StProc_BonRapprochementLien.ParamByName('ID_RETOUR').AsInteger := IDRetour;
            StProc_BonRapprochementLien.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeBonRapprochementLienID(sIDBon + sIDReception + sIDRetour, StProc_BonRapprochementLien.FieldByName('RPRID').AsInteger);
            StProc_BonRapprochementLien.Close;

            Dm_Main.TransacBonR.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.Rollback;
            Result := False;
            sError := '(' + IntToStr(i) + ')' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;
      end;
    end;

    sEtat2 := '';
    iProgress := 0;
    Synchronize(UpdProgressFrm);
  finally
    Dm_Main.SaveListeBonRapprochementLienID;
    StProc_BonRapprochementLien.Close;
  end;
end;

function TBonRapprochement.TraiterBonRapprochementTVA: Boolean;
var
  AvancePc, NbRech, i, IDBon, IDTva, LRechID: Integer;
  Query: TIBQuery;
  sIDBon, sTauxTVA: String;
  dTauxTVA: Double;
begin
  Result := True;
  iMaxProgress := Pred(cds_BonRapprochementTVA.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + BonRapprochementTVA_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDBonRapprochementTVA.Count;
  Query := TIBQuery.Create(nil);
  try
    Query.Database := Dm_Main.DataBase;
    Query.Transaction := Dm_Main.TransacBonR;
    Query.ParamCheck := True;
    IDTva := 0;

    for i:=1 to Pred(cds_BonRapprochementTVA.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_BonRapprochementTVA[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_BonRapprochementTVA[i], BonRapprochementTVA_COL);

          // IB bon de rapprochement.
          sIDBon := GetValueBonRapprochementTVAImp('ID_BON');
          IDBon := Dm_Main.GetBonRapprochementID(sIDBon);
          if IDBon = -1 then
            raise Exception.Create('Erreur :  l''ancien bon de rapprochement [ID = ' + sIDBon + '] n''a pas de nouvel équivalent !');

          sTauxTVA := GetValueBonRapprochementTVAImp('TAUX_TVA');
          if not TryStrToFloat(sTauxTVA, dTauxTVA) then
            dTauxTVA := -1;

          // ID TVA.
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('select TVA_ID');
          Query.SQL.Add('from ARTTVA');
          Query.SQL.Add('join K on (K_ID = TVA_ID and K_ENABLED = 1)');
          Query.SQL.Add('where TVA_TAUX = :TAUX');
          try
            Query.ParamByName('TAUX').AsFloat := dTauxTVA;
            Query.Open;
          except
            on E: Exception do
            begin
              raise Exception.Create('Erreur :  la recherche de la TVA [Taux = ' + sTauxTVA + '] a échoué :  ' + E.Message);
            end;
          end;
          if Query.IsEmpty then
            raise Exception.Create('Erreur :  la TVA [Taux = ' + sTauxTVA + '] n''existe pas !')
          else
            IDTva := Query.FieldByName('TVA_ID').AsInteger;

          // Recherche si pas déjà importé.
          LRechID := Dm_Main.RechercheBonRapprochementTVAID(sIDBon + sTauxTVA, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sIDBon <> '') then
          begin
            if not Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.StartTransaction;

            // Traitement de la TVA du bon de rapprochement.
            StProc_BonRapprochementTVA.Close;
            StProc_BonRapprochementTVA.ParamByName('ID_BON').AsInteger := IDBon;
            StProc_BonRapprochementTVA.ParamByName('TVAID').AsInteger := IDTva;
            StProc_BonRapprochementTVA.ParamByName('TAUX_TVA').AsString := sTauxTVA;
            StProc_BonRapprochementTVA.ParamByName('MONTANT_TTC').AsString := GetValueBonRapprochementTVAImp('MONTANT_TTC');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_HT').AsString := GetValueBonRapprochementTVAImp('MONTANT_HT');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_BRUT_HT').AsString := GetValueBonRapprochementTVAImp('MONTANT_BRUT_HT');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_REMISE').AsString := GetValueBonRapprochementTVAImp('MONTANT_REMISE');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_NET_TTC').AsString := GetValueBonRapprochementTVAImp('MONTANT_NET_TTC');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_TVA_FRAIS_PORT').AsString := GetValueBonRapprochementTVAImp('MONTANT_TVA_FRAIS_PORT');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_TVA_FRAIS_ANNEXES').AsString := GetValueBonRapprochementTVAImp('MONTANT_TVA_FRAIS_ANNEXES');
            StProc_BonRapprochementTVA.ParamByName('MONTANT_TVA').AsString := GetValueBonRapprochementTVAImp('MONTANT_TVA');
            StProc_BonRapprochementTVA.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeBonRapprochementTVAID(sIDBon + sTauxTVA, StProc_BonRapprochementTVA.FieldByName('RPTID').AsInteger);
            StProc_BonRapprochementTVA.Close;

            Dm_Main.TransacBonR.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.Rollback;
            Result := False;
            sError := '(' + IntToStr(i) + ')' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;
      end;
    end;

    sEtat2 := '';
    iProgress := 0;
    Synchronize(UpdProgressFrm);
  finally
    FreeAndNil(Query);
    Dm_Main.SaveListeBonRapprochementTVAID;
    StProc_BonRapprochementTVA.Close;
  end;
end;

function TBonRapprochement.TraiterBonRapprochementLigneReception: Boolean;
var
  AvancePc, NbRech, i, IDBon, IDLigneReception, LRechID: Integer;
  QueTrigger: TIBQuery;
  sIDBon, sIDLigneReception: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_BonRapprochementLigneReception.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + BonRapprochementLigneReception_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  if Dm_Main.TransacBonR.InTransaction then
    Dm_Main.TransacBonR.Commit;

  QueTrigger := TIBQuery.Create(nil);
  try
    QueTrigger.Database := Dm_Main.DatabaseSysdba;
    QueTrigger.Transaction := Dm_Main.TransactionSysdba;
    try
      // Désactivation des triggers.
      QueTrigger.Close;
      QueTrigger.SQL.Clear;
      QueTrigger.SQL.Add('alter trigger "Maj_RAL_BR_U" inactive');
      try
        QueTrigger.Open;
      except
        on E: Exception do
        begin
          Result := False;
          sError := 'Erreur :  la désactivation du trigger "Maj_RAL_BR_U" a échoué :  ' + E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
          Exit;
        end;
      end;

      QueTrigger.Close;
      QueTrigger.SQL.Clear;
      QueTrigger.SQL.Add('alter trigger "MAJ_STKPUMP_BR_U" inactive');
      try
        QueTrigger.Open;
      except
        on E: Exception do
        begin
          Result := False;
          sError := 'Erreur :  la désactivation du trigger "MAJ_STKPUMP_BR_U" a échoué :  ' + E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
          Exit;
        end;
      end;

      // Reconnexion pour appliquer la désactivation.
      Dm_Main.Database.Close;
      Dm_Main.DatabaseSysdba.Close;
      try
        Dm_Main.Database.Open;
        Dm_Main.DatabaseSysdba.Open;
      except
        on E: Exception do
        begin
          Result := False;
          sError := 'Erreur :  la reconnexion a échoué :  ' + E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
          Exit;
        end;
      end;

      NbRech := Dm_Main.ListeIDBonRapprochementLigneReception.Count;
      try
        for i:=1 to Pred(cds_BonRapprochementLigneReception.Count) do
        begin
          // Maj de la fenêtre.
          sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
          Inc(iProgress);
          if(iProgress mod AvancePc) = 0 then
            Synchronize(UpdProgressFrm);

          if cds_BonRapprochementLigneReception[i] <> '' then
          begin
            try
              // Ajout ligne.
              AjoutInfoLigne(cds_BonRapprochementLigneReception[i], BonRapprochementLigneReception_COL);

              // IB bon de rapprochement.
              sIDBon := GetValueBonRapprochementLigneReceptionImp('ID_BON');
              IDBon := Dm_Main.GetBonRapprochementID(sIDBon);
              if IDBon = -1 then
                raise Exception.Create('Erreur :  l''ancien bon de rapprochement [ID = ' + sIDBon + '] n''a pas de nouvel équivalent !');

              // ID ligne réception.
              sIDLigneReception := GetValueBonRapprochementLigneReceptionImp('ID_LIGNE_RECEPTION') + GetValueBonRapprochementLigneReceptionImp('CODE_ART') + GetValueBonRapprochementLigneReceptionImp('CODE_TAILLE') + GetValueBonRapprochementLigneReceptionImp('CODE_COUL');
              IDLigneReception := Dm_Main.GetLigneReceptionID(sIDLigneReception);
              if IDLigneReception = -1 then
                raise Exception.Create('Erreur :  l''ancienne ligne de réception [ID = ' + sIDLigneReception + '] n''a pas de nouvel équivalent !');

              // Recherche si pas déjà importé.
              LRechID := Dm_Main.RechercheBonRapprochementLigneReceptionID(sIDBon + sIDLigneReception, NbRech);

              // Création si pas déjà créé.
              if(LRechID = -1) and (sIDBon <> '') then
              begin
                if not Dm_Main.TransacBonR.InTransaction then
                  Dm_Main.TransacBonR.StartTransaction;

                // Traitement du bon de rapprochement de la ligne de réception.
                StProc_BonRapprochementLigneReception.Close;
                StProc_BonRapprochementLigneReception.ParamByName('ID_LIGNE').AsInteger := IDLigneReception;
                StProc_BonRapprochementLigneReception.ParamByName('ID_BON').AsInteger := IDBon;
                StProc_BonRapprochementLigneReception.ExecQuery;

                // Récupération du nouvel ID.
                Dm_Main.AjoutInListeBonRapprochementLienID(sIDBon + sIDLigneReception, IDLigneReception);
                StProc_BonRapprochementLigneReception.Close;

                Dm_Main.TransacBonR.Commit;
              end;
            except
              on E: Exception do
              begin
                if Dm_Main.TransacBonR.InTransaction then
                  Dm_Main.TransacBonR.Rollback;
                Result := False;
                sError := '(' + IntToStr(i) + ')' + E.Message;
                DoLog(sError, logError);
                Synchronize(UpdProgressFrm);
                Synchronize(ErrorFrm);
              end;
            end;
          end;
        end;

        sEtat2 := '';
        iProgress := 0;
        Synchronize(UpdProgressFrm);
      finally
        Dm_Main.SaveListeBonRapprochementLigneReceptionID;
        StProc_BonRapprochementLigneReception.Close;
      end;
    finally
      if Dm_Main.DatabaseSysdba.Connected then
      begin
        // Réactivation des triggers.
        QueTrigger.Close;
        QueTrigger.SQL.Clear;
        QueTrigger.SQL.Add('alter trigger "Maj_RAL_BR_U" active');
        try
          QueTrigger.Open;
        except
          on E: Exception do
          begin
            Result := False;
            sError := 'Erreur :  la réactivation du trigger "Maj_RAL_BR_U" a échoué :  ' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;

        // Reconnexion pour appliquer la résactivation.
        Dm_Main.Database.Close;
        Dm_Main.DatabaseSysdba.Close;
        try
          Dm_Main.Database.Open;
          Dm_Main.DatabaseSysdba.Open;
        except
          on E: Exception do
          begin
            Result := False;
            sError := 'Erreur :  la reconnexion a échoué :  ' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;

        QueTrigger.Close;
        QueTrigger.SQL.Clear;
        QueTrigger.SQL.Add('alter trigger "MAJ_STKPUMP_BR_U" active');
        try
          QueTrigger.Open;
        except
          on E: Exception do
          begin
            Result := False;
            sError := 'Erreur :  la réactivation du trigger "MAJ_STKPUMP_BR_U" a échoué :  ' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;

        // Reconnexion pour appliquer la résactivation.
        Dm_Main.Database.Close;
        Dm_Main.DatabaseSysdba.Close;
        try
          Dm_Main.Database.Open;
          Dm_Main.DatabaseSysdba.Open;
        except
          on E: Exception do
          begin
            Result := False;
            sError := 'Erreur :  la reconnexion a échoué :  ' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;
      end;
    end;
  finally
    QueTrigger.Free;
  end;
end;

function TBonRapprochement.TraiterBonRapprochementLigneRetour: Boolean;
var
  AvancePc, NbRech, i, IDBon, IDLigneRetour, LRechID: Integer;
  sIDBon, sIDLigneRetour: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_BonRapprochementLigneRetour.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + BonRapprochementLigneRetour_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDBonRapprochementLigneRetour.Count;
  try
    for i:=1 to Pred(cds_BonRapprochementLigneRetour.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_BonRapprochementLigneRetour[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_BonRapprochementLigneRetour[i], BonRapprochementLigneRetour_COL);

          // IB bon de rapprochement.
          sIDBon := GetValueBonRapprochementLigneRetourImp('ID_BON');
          IDBon := Dm_Main.GetBonRapprochementID(sIDBon);
          if IDBon = -1 then
            raise Exception.Create('Erreur :  l''ancien bon de rapprochement [ID = ' + sIDBon + '] n''a pas de nouvel équivalent !');

          // ID ligne retour.
          sIDLigneRetour := GetValueBonRapprochementLigneRetourImp('NUM_BON_RETOUR') + GetValueBonRapprochementLigneRetourImp('CODE_ART') + GetValueBonRapprochementLigneRetourImp('CODE_TAILLE') + GetValueBonRapprochementLigneRetourImp('CODE_COUL');
          IDLigneRetour := Dm_Main.GetLigneRetourFouID(sIDLigneRetour);
          if IDLigneRetour = -1 then
            raise Exception.Create('Erreur :  l''ancienne ligne de retour fournisseur [ID = ' + sIDLigneRetour + '] n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          LRechID := Dm_Main.RechercheBonRapprochementLigneRetourID(sIDBon + sIDLigneRetour, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sIDBon <> '') then
          begin
            if not Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.StartTransaction;

            // Traitement du bon de rapprochement de la ligne de retour.
            StProc_BonRapprochementLigneRetour.Close;
            StProc_BonRapprochementLigneRetour.ParamByName('ID_LIGNE').AsInteger := IDLigneRetour;
            StProc_BonRapprochementLigneRetour.ParamByName('ID_BON').AsInteger := IDBon;
            StProc_BonRapprochementLigneRetour.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeBonRapprochementLienID(sIDBon + sIDLigneRetour, IDLigneRetour);
            StProc_BonRapprochementLigneRetour.Close;

            Dm_Main.TransacBonR.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacBonR.InTransaction then
              Dm_Main.TransacBonR.Rollback;
            Result := False;
            sError := '(' + IntToStr(i) + ')' + E.Message;
            DoLog(sError, logError);
            Synchronize(UpdProgressFrm);
            Synchronize(ErrorFrm);
          end;
        end;
      end;
    end;

    sEtat2 := '';
    iProgress := 0;
    Synchronize(UpdProgressFrm);
  finally
    Dm_Main.SaveListeBonRapprochementLigneRetourID;
    StProc_BonRapprochementLigneRetour.Close;
  end;
end;

procedure TBonRapprochement.AjoutInfoLigne(const ALigne: String; ADefColonne: Array of String);
var
  sLigne: String;
  NBre: Integer;
begin
  sLigneLecture := ALigne;
  sLigne := ALigne;
  if(bRetirePtVirg) and (sLigne <> '') and (sLigne[Length(sLigne)] = ';') then
    sLigne := Copy(sLigne, 1, Length(sLigne) - 1);

  if(sLigne <> '') and (sLigne[1] = '"') then
  begin
    Nbre := 1;
    while Pos('";"', sLigne) > 0 do
    begin
      sLigne := Copy(sLigne, Pos('";"', sLigne) + 2, Length(sLigne));
      Inc(Nbre);
    end;
  end
  else
  begin
    Nbre := 1;
    while Pos(';', sLigne) > 0 do
    begin
      sLigne := Copy(sLigne, Pos(';', sLigne) + 1, Length(sLigne));
      Inc(Nbre);
    end;
  end;

  if High(ADefColonne) <> (Nbre - 1) then
    raise Exception.Create('Nombre de champs invalide par rapport à l''entête :' + #13#10 +
                           '  - Moins de champ :  sûrement un retour chariot dans la ligne.' + #13#10 +
                           '  - Plus de champ :  sûrement un ; ou un " de trop dans la ligne.');
end;

function TBonRapprochement.GetValueBonRapprochementImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, BonRapprochement_COL, sLigneLecture, bRetirePtVirg);
end;

function TBonRapprochement.GetValueBonRapprochementLienImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, BonRapprochementLien_COL, sLigneLecture, bRetirePtVirg);
end;

function TBonRapprochement.GetValueBonRapprochementTVAImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, BonRapprochementTVA_COL, sLigneLecture, bRetirePtVirg);
end;

function TBonRapprochement.GetValueBonRapprochementLigneReceptionImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, BonRapprochementLigneReception_COL, sLigneLecture, bRetirePtVirg);
end;

function TBonRapprochement.GetValueBonRapprochementLigneRetourImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, BonRapprochementLigneRetour_COL, sLigneLecture, bRetirePtVirg);
end;

procedure TBonRapprochement.InitFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(11, bm);
    Frm_Load.img_BonRapprochement.Picture := nil;
    Frm_Load.img_BonRapprochement.Picture.Assign(bm);
    Frm_Load.img_BonRapprochement.Transparent := False;
    Frm_Load.img_BonRapprochement.Transparent := True;
  finally
    FreeAndNil(bm);
  end;

  Frm_Load.Lab_EtatBonR1.Caption := 'Initialisation';
  Frm_Load.Lab_EtatBonR2.Caption := '';
  Frm_Load.Lab_EtatBonR2.Hint := '';
end;

procedure TBonRapprochement.InitExecute;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(3, bm);
    Frm_Load.img_BonRapprochement.Picture := nil;
    Frm_Load.img_BonRapprochement.Picture.Assign(bm);
    Frm_Load.img_BonRapprochement.Transparent := False;
    Frm_Load.img_BonRapprochement.Transparent := True;
  finally
    FreeAndNil(bm);
  end;
end;

procedure TBonRapprochement.UpdateFrm;
begin
  Frm_Load.Lab_EtatBonR1.Caption := sEtat1;
  Frm_Load.Lab_EtatBonR2.Caption := sEtat2;
  Frm_Load.Lab_EtatBonR2.Hint := sEtat2;
end;

procedure TBonRapprochement.InitProgressFrm;
begin
  Frm_Load.pb_EtatBonR.Position := 0;
  Frm_Load.pb_EtatBonR.Max := iMaxProgress;
end;

procedure TBonRapprochement.UpdProgressFrm;
begin
  Frm_Load.Lab_EtatBonR2.Caption := sEtat2;
  Frm_Load.Lab_EtatBonR2.Hint := sEtat2;
  Frm_Load.pb_EtatBonR.Position := iProgress;
end;

procedure TBonRapprochement.ErrorFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(10, bm);
    Frm_Load.img_BonRapprochement.Picture := nil;
    Frm_Load.img_BonRapprochement.Picture.Assign(bm);
    Frm_Load.img_BonRapprochement.Transparent := False;
    Frm_Load.img_BonRapprochement.Transparent := True;
  finally
    FreeAndNil(bm);
  end;

  Frm_Load.DoErreurCli(sError);
end;

procedure TBonRapprochement.EndFrm;
var
  bm: tbitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(0, bm);
    Frm_Load.img_BonRapprochement.Picture := nil;
    Frm_Load.img_BonRapprochement.Picture.Assign(bm);
    Frm_Load.img_BonRapprochement.Transparent := False;
    Frm_Load.img_BonRapprochement.Transparent := True;
  finally
    FreeAndNil(bm);
  end;

  Frm_Load.Lab_EtatBonR1.Caption := 'Importation';
  Frm_Load.Lab_EtatBonR2.Caption := 'Terminé';
  Frm_Load.Lab_EtatBonR2.Hint := '';
end;

destructor TBonRapprochement.Destroy;
begin
  FreeAndNil(cds_BonRapprochement);
  FreeAndNil(cds_BonRapprochementLien);
  FreeAndNil(cds_BonRapprochementTVA);
  FreeAndNil(cds_BonRapprochementLigneReception);
  FreeAndNil(cds_BonRapprochementLigneRetour);

  FreeAndNil(StProc_BonRapprochement);
  FreeAndNil(StProc_BonRapprochementLien);
  FreeAndNil(StProc_BonRapprochementTVA);
  FreeAndNil(StProc_BonRapprochementLigneReception);
  FreeAndNil(StProc_BonRapprochementLigneRetour);

  inherited;
end;

end.


unit uAtelier;

interface

uses
  Classes, SysUtils, IBSQL, IBQuery, Graphics, DB, DBClient, uLog;

type
  TAtelier = class(TThread)
    private
      bRetirePtVirg: Boolean;
      sFichierSavTauxH: String;
      sFichierSavForfait: String;
      sFichierSavForfaitL: String;
      sFichierSavPt1: String;
      sFichierSavPt2: String;
      sFichierSavTypMat: String;
      sFichierSavType: String;
      sFichierSavMat: String;
      sFichierSavCb: String;
      sFichierSavFichee: String;
      sFichierSavFicheL: String;
      sFichierSavFicheArt: String;

      sEtat1, sEtat2, sError, sLigneLecture: String;
      iMaxProgress, iProgress, iTraitement, iNbTraitement: Integer;

      cds_Magasin : TClientDataSet;

      cds_SavTauxH: TStringList;
      cds_SavForfait: TStringList;
      cds_SavForfaitL: TStringList;
      cds_SavPt1: TStringList;
      cds_SavPt2: TStringList;
      cds_SavTypMat: TStringList;
      cds_SavType: TStringList;
      cds_SavMat: TStringList;
      cds_SavCb: TStringList;
      cds_SavFichee: TStringList;
      cds_SavFicheL: TStringList;
      cds_SavFicheArt: TStringList;

      StProc_SavTauxH: TIBSQL;
      StProc_SavForfait: TIBSQL;
      StProc_SavForfaitL: TIBSQL;
      StProc_SavPt1: TIBSQL;
      StProc_SavPt2: TIBSQL;
      StProc_SavTypMat: TIBSQL;
      StProc_SavType: TIBSQL;
      StProc_SavMat: TIBSQL;
      StProc_SavCb: TIBSQL;
      StProc_SavFichee: TIBSQL;
      StProc_SavFicheL: TIBSQL;
      StProc_SavFicheArt: TIBSQL;

      procedure DoLog(const sVal: String; const aLvl: TLogLevel);
      function LoadFile: Boolean;
      function TraiterSavTauxH: Boolean;
      function TraiterSavForfait: Boolean;
      function TraiterSavForfaitL: Boolean;
      function TraiterSavPt1: Boolean;
      function TraiterSavPt2: Boolean;
      function TraiterSavTypMat: Boolean;
      function TraiterSavType: Boolean;
      function TraiterSavMat: Boolean;
      function TraiterSavCb: Boolean;
      function TraiterSavFichee: Boolean;
      function TraiterSavFicheL: Boolean;
      function TraiterSavFicheArt: Boolean;
      procedure AjoutInfoLigne(const ALigne: String; ADefColonne: Array of String);
      function GetValueSavTauxHImp(const AChamp: String): String;
      function GetValueSavForfaitImp(const AChamp: String): String;
      function GetValueSavForfaitLImp(const AChamp: String): String;
      function GetValueSavPt1Imp(const AChamp: String): String;
      function GetValueSavPt2Imp(const AChamp: String): String;
      function GetValueSavTypMatImp(const AChamp: String): String;
      function GetValueSavTypeImp(const AChamp: String): String;
      function GetValueSavMatImp(const AChamp: String): String;
      function GetValueSavCbImp(const AChamp: String): String;
      function GetValueSavFicheeImp(const AChamp: String): String;
      function GetValueSavFicheLImp(const AChamp: String): String;
      function GetValueSavFicheArtImp(const AChamp: String): String;

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
      procedure InitThread(const aRetirePtVirg: Boolean; const aFichierSavTauxH, aFichierSavForfait, aFichierSavForfaitL,
        aFichierSavPt1, aFichierSavPt2, aFichierSavTypMat, aFichierSavType, aFichierSavMat, aFichierSavCb,
        aFichierSavFichee, aFichierSavFicheL, aFichierSavFicheArt: String);
      destructor Destroy;   override;
  end;

implementation

uses Main_Dm, uDefs, GinkoiaStyle_Dm, Load_Frm, uCommon;

{ TAtelier }

constructor TAtelier.Create(const aCreateSuspended, aEnabledProcess: Boolean);
begin
  inherited Create(aCreateSuspended);
  FreeOnTerminate := True;
  Priority := tpHigher;

  sEtat1 := '';      sEtat2 := '';      sError := '';
  bError := False;
  iNbTraitement := 12;

  // magasin en mémoire
  cds_Magasin := TClientDataSet.Create(nil);
  cds_Magasin.FieldDefs.Add('MAG_ID',ftInteger,0);
  cds_Magasin.FieldDefs.Add('MAG_CODEADH',ftString,32);
  cds_Magasin.CreateDataSet;
  cds_Magasin.LogChanges := False;
  cds_Magasin.Open;

  cds_SavTauxH := TStringList.Create;
  cds_SavForfait := TStringList.Create;
  cds_SavForfaitL := TStringList.Create;
  cds_SavPt1 := TStringList.Create;
  cds_SavPt2 := TStringList.Create;
  cds_SavTypMat := TStringList.Create;
  cds_SavType := TStringList.Create;
  cds_SavMat := TStringList.Create;
  cds_SavCb := TStringList.Create;
  cds_SavFichee := TStringList.Create;
  cds_SavFicheL := TStringList.Create;
  cds_SavFicheArt := TStringList.Create;

  Dm_Main.TransacAtelier.Active := True;

  // SavTauxH
  StProc_SavTauxH := TIBSQL.Create(nil);
  StProc_SavTauxH.Database := Dm_Main.Database;
  StProc_SavTauxH.Transaction := Dm_Main.TransacAtelier;
  StProc_SavTauxH.ParamCheck := True;
  StProc_SavTauxH.SQL.Add(cSql_MG10_SavTauxH);
  StProc_SavTauxH.Prepare;

  // SavForfait
  StProc_SavForfait := TIBSQL.Create(nil);
  StProc_SavForfait.Database := Dm_Main.Database;
  StProc_SavForfait.Transaction := Dm_Main.TransacAtelier;
  StProc_SavForfait.ParamCheck := True;
  StProc_SavForfait.SQL.Add(cSql_MG10_SavForfait);
  StProc_SavForfait.Prepare;

  // SavForfaitL
  StProc_SavForfaitL := TIBSQL.Create(nil);
  StProc_SavForfaitL.Database := Dm_Main.Database;
  StProc_SavForfaitL.Transaction := Dm_Main.TransacAtelier;
  StProc_SavForfaitL.ParamCheck := True;
  StProc_SavForfaitL.SQL.Add(cSql_MG10_SavForfaitL);
  StProc_SavForfaitL.Prepare;

  // SavPt1
  StProc_SavPt1 := TIBSQL.Create(nil);
  StProc_SavPt1.Database := Dm_Main.Database;
  StProc_SavPt1.Transaction := Dm_Main.TransacAtelier;
  StProc_SavPt1.ParamCheck := True;
  StProc_SavPt1.SQL.Add(cSql_MG10_SavPt1);
  StProc_SavPt1.Prepare;

  // SavPt2
  StProc_SavPt2 := TIBSQL.Create(nil);
  StProc_SavPt2.Database := Dm_Main.Database;
  StProc_SavPt2.Transaction := Dm_Main.TransacAtelier;
  StProc_SavPt2.ParamCheck := True;
  StProc_SavPt2.SQL.Add(cSql_MG10_SavPt2);
  StProc_SavPt2.Prepare;

  // SavTypMat
  StProc_SavTypMat := TIBSQL.Create(nil);
  StProc_SavTypMat.Database := Dm_Main.Database;
  StProc_SavTypMat.Transaction := Dm_Main.TransacAtelier;
  StProc_SavTypMat.ParamCheck := True;
  StProc_SavTypMat.SQL.Add(cSql_MG10_SavTypMat);
  StProc_SavTypMat.Prepare;

  // SavType
  StProc_SavType := TIBSQL.Create(nil);
  StProc_SavType.Database := Dm_Main.Database;
  StProc_SavType.Transaction := Dm_Main.TransacAtelier;
  StProc_SavType.ParamCheck := True;
  StProc_SavType.SQL.Add(cSql_MG10_SavType);
  StProc_SavType.Prepare;

  // SavMat
  StProc_SavMat := TIBSQL.Create(nil);
  StProc_SavMat.Database := Dm_Main.Database;
  StProc_SavMat.Transaction := Dm_Main.TransacAtelier;
  StProc_SavMat.ParamCheck := True;
  StProc_SavMat.SQL.Add(cSql_MG10_SavMat);
  StProc_SavMat.Prepare;

  // SavCb
  StProc_SavCb := TIBSQL.Create(nil);
  StProc_SavCb.Database := Dm_Main.Database;
  StProc_SavCb.Transaction := Dm_Main.TransacAtelier;
  StProc_SavCb.ParamCheck := True;
  StProc_SavCb.SQL.Add(cSql_MG10_SavCb);
  StProc_SavCb.Prepare;

  // SavFichee
  StProc_SavFichee := TIBSQL.Create(nil);
  StProc_SavFichee.Database := Dm_Main.Database;
  StProc_SavFichee.Transaction := Dm_Main.TransacAtelier;
  StProc_SavFichee.ParamCheck := True;
  StProc_SavFichee.SQL.Add(cSql_MG10_SavFichee);
  StProc_SavFichee.Prepare;

  // SavFicheL
  StProc_SavFicheL := TIBSQL.Create(nil);
  StProc_SavFicheL.Database := Dm_Main.Database;
  StProc_SavFicheL.Transaction := Dm_Main.TransacAtelier;
  StProc_SavFicheL.ParamCheck := True;
  StProc_SavFicheL.SQL.Add(cSql_MG10_SavFicheL);
  StProc_SavFicheL.Prepare;

  // SavFicheArt
  StProc_SavFicheArt := TIBSQL.Create(nil);
  StProc_SavFicheArt.Database := Dm_Main.Database;
  StProc_SavFicheArt.Transaction := Dm_Main.TransacAtelier;
  StProc_SavFicheArt.ParamCheck := True;
  StProc_SavFicheArt.SQL.Add(cSql_MG10_SavFicheArt);
  StProc_SavFicheArt.Prepare;
end;

procedure TAtelier.DoLog(const sVal: String; const aLvl: TLogLevel);
begin
  uLog.Log.Log('uAtelier', 'log', sVal, aLvl, False, -1, ltLocal);
end;

procedure TAtelier.InitThread(const aRetirePtVirg: Boolean; const aFichierSavTauxH, aFichierSavForfait, aFichierSavForfaitL,
                              aFichierSavPt1, aFichierSavPt2, aFichierSavTypMat, aFichierSavType, aFichierSavMat, aFichierSavCb,
                              aFichierSavFichee, aFichierSavFicheL, aFichierSavFicheArt: String);
begin
  Synchronize(InitFrm);

  bRetirePtVirg := aRetirePtVirg;

  sFichierSavTauxH := aFichierSavTauxH;
  sFichierSavForfait := aFichierSavForfait;
  sFichierSavForfaitL := aFichierSavForfaitL;
  sFichierSavPt1 := aFichierSavPt1;
  sFichierSavPt2 := aFichierSavPt2;
  sFichierSavTypMat := aFichierSavTypMat;
  sFichierSavType := aFichierSavType;
  sFichierSavMat := aFichierSavMat;
  sFichierSavCb := aFichierSavCb;
  sFichierSavFichee := aFichierSavFichee;
  sFichierSavFicheL := aFichierSavFicheL;
  sFichierSavFicheArt := aFichierSavFicheArt;
end;

procedure TAtelier.Execute;
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

    // Si pas de correspondances de client.
    if Dm_Main.ListeIDClient.Count = 0 then
    begin
      bError := True;
      sError := 'Erreur :  les clients n''ont pas été importées !';
    end
    else if Dm_Main.ListeIDArticle.Count = 0 then
    begin
      bError := True;
      sError := 'Erreur :  les articles n''ont pas été importés !';
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
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier - Chargement des fichiers: ' + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavTauxH
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavTauxH;
        tpListeDelai.Add('  Atelier SavTauxH: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavTauxH: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavForfait
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavForfait;
        tpListeDelai.Add('  Atelier SavForfait: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavForfait: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavForfaitL
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavForfaitL;
        tpListeDelai.Add('  Atelier SavForfaitL: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavForfaitL: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavPt1
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavPt1;
        tpListeDelai.Add('  Atelier SavPt1: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavPt1: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavPt2
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavPt2;
        tpListeDelai.Add('  Atelier SavPt2: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavPt2: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavTypMat
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavTypMat;
        tpListeDelai.Add('  Atelier SavTypMat: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavTypMat: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavType
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavType;
        tpListeDelai.Add('  Atelier SavType: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavType: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavMat
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavMat;
        tpListeDelai.Add('  Atelier SavMat: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavMat: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavCb
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavCb;
        tpListeDelai.Add('  Atelier SavCb: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavCb: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavFichee
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavFichee;
        tpListeDelai.Add('  Atelier SavFichee: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavFichee: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavFicheL
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavFicheL;
        tpListeDelai.Add('  Atelier SavFicheL: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavFicheL: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;

      // SavFicheArt
      if bContinue then
      begin
        tProc := Now;
        bContinue := TraiterSavFicheArt;
        tpListeDelai.Add('  Atelier SavFicheArt: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail, 'Atelier SavFicheArt: ' + #9#9 + FormatDateTime('hh:nn:ss:zzz', Now - tProc));
      end;
    end;

    if sError <> '' then
    begin
      tpListeDelai.Add(sError);
      if Dm_Main.GetDoMail(ErreurMail) then
        SendEmail(Dm_Main.GetMailLst, '[ALERT - ERREUR] - ' + Dm_Main.GetSubjectMail, 'Atelier - ' + sError);
    end;

    tpListeDelai.Add('');
    tpListeDelai.Add('');
    tpListeDelai.Add('Temps total: ' + FormatDateTime('hh:nn:ss:zzz', Now - tTot));
    if Dm_Main.GetDoMail(CliArtHistBonRAtelier) then
        SendEmail(Dm_Main.GetMailLst, '[Fin atelier] - ' + Dm_Main.GetSubjectMail, 'Atelier - Temps total: ' + FormatDateTime('hh:nn:ss:zzz', Now - tTot));

    try
      tpListeDelai.SaveToFile(Dm_Main.ReperBase + Dm_Main.GetSubjectMail + '_Delai_Import_Atelier_' + FormatDateTime('yyyy-mm-dd hhnnss', Now) + '.txt');
    except
    end;

    if bContinue then
      Synchronize(EndFrm);
  finally
    FreeAndNil(tpListeDelai);
    bError := not bContinue;
  end;
end;

function TAtelier.LoadFile: Boolean;
var
  Que_Tmp: TIBQuery;
begin
  Result := True;
  cds_SavTauxH.Clear;
  cds_SavForfait.Clear;
  cds_SavForfaitL.Clear;
  cds_SavPt1.Clear;
  cds_SavPt2.Clear;
  cds_SavTypMat.Clear;
  cds_SavType.Clear;
  cds_SavMat.Clear;
  cds_SavCb.Clear;
  cds_SavFichee.Clear;
  cds_SavFicheL.Clear;
  cds_SavFicheArt.Clear;
  sEtat1 := 'Chargement:';

  Que_Tmp := TIbQuery.Create(nil);
  try
    sEtat2 := 'Magasins en mémoire';
    Que_Tmp.Database := dm_Main.Database;

    // mise en mémoire de la liste des magasins
    with Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select MAG_ID, MAG_CODEADH from genmagasin');
      SQL.Add('  join k on k_id=mag_id and k_enabled=1');
      Open;
      First;
      While not(Eof) do
      begin
        cds_Magasin.Append;
        cds_Magasin.FieldByName('MAG_ID').AsInteger := FieldByName('MAG_ID').AsInteger;
        cds_Magasin.FieldByName('MAG_CODEADH').AsString := FieldByName('MAG_CODEADH').AsString;
        cds_Magasin.Post;
        Next;
      end;
      Close;
      cds_Magasin.IndexFieldNames := 'MAG_CODEADH';
    end;
  finally
    FreeAndNil(Que_Tmp);
  end;

  // Chargement SavTauxH.
  try
    sEtat2 := 'Fichier ' + SavTauxH_CSV;
    Synchronize(UpdateFrm);
    cds_SavTauxH.LoadFromFile(sFichierSavTauxH);
    Dm_Main.LoadListeSavTauxHID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavForfait.
  try
    sEtat2 := 'Fichier ' + SavForfait_CSV;
    Synchronize(UpdateFrm);
    cds_SavForfait.LoadFromFile(sFichierSavForfait);
    Dm_Main.LoadListeSavForfaitID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavForfaitL.
  try
    sEtat2 := 'Fichier ' + SavForfaitL_CSV;
    Synchronize(UpdateFrm);
    cds_SavForfaitL.LoadFromFile(sFichierSavForfaitL);
    Dm_Main.LoadListeSavForfaitLID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavPt1.
  try
    sEtat2 := 'Fichier ' + SavPt1_CSV;
    Synchronize(UpdateFrm);
    cds_SavPt1.LoadFromFile(sFichierSavPt1);
    Dm_Main.LoadListeSavPt1ID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavPt2.
  try
    sEtat2 := 'Fichier ' + SavPt2_CSV;
    Synchronize(UpdateFrm);
    cds_SavPt2.LoadFromFile(sFichierSavPt2);
    Dm_Main.LoadListeSavPt2ID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavTypMat.
  try
    sEtat2 := 'Fichier ' + SavTypMat_CSV;
    Synchronize(UpdateFrm);
    cds_SavTypMat.LoadFromFile(sFichierSavTypMat);
    Dm_Main.LoadListeSavTypMatID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavType.
  try
    sEtat2 := 'Fichier ' + SavType_CSV;
    Synchronize(UpdateFrm);
    cds_SavType.LoadFromFile(sFichierSavType);
    Dm_Main.LoadListeSavTypeID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavMat.
  try
    sEtat2 := 'Fichier ' + SavMat_CSV;
    Synchronize(UpdateFrm);
    cds_SavMat.LoadFromFile(sFichierSavMat);
    Dm_Main.LoadListeSavMatID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavCb.
  try
    sEtat2 := 'Fichier ' + SavCb_CSV;
    Synchronize(UpdateFrm);
    cds_SavCb.LoadFromFile(sFichierSavCb);
    Dm_Main.LoadListeSavCbID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavFichee.
  try
    sEtat2 := 'Fichier ' + SavFichee_CSV;
    Synchronize(UpdateFrm);
    cds_SavFichee.LoadFromFile(sFichierSavFichee);
    Dm_Main.LoadListeSavFicheeID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavFicheL.
  try
    sEtat2 := 'Fichier ' + SavFicheL_CSV;
    Synchronize(UpdateFrm);
    cds_SavFicheL.LoadFromFile(sFichierSavFicheL);
    Dm_Main.LoadListeSavFicheLID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;

  // Chargement SavFicheArt.
  try
    sEtat2 := 'Fichier ' + SavFicheArt_CSV;
    Synchronize(UpdateFrm);
    cds_SavFicheArt.LoadFromFile(sFichierSavFicheArt);
    Dm_Main.LoadListeSavFicheArtID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      Exit;
    end;
  end;
end;

function TAtelier.TraiterSavTauxH: Boolean;
var
  AvancePc, NbRech, i, LRechID: Integer;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavTauxH.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavTauxH_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavTauxH.Count;
  try
    for i:=1 to Pred(cds_SavTauxH.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavTauxH[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavTauxH[i], SavTauxH_COL);

          // Recherche si pas déjà importé.
          sID := GetValueSavTauxHImp('ID');
          LRechID := Dm_Main.RechercheSavTauxHID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sID <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavTauxH.
            StProc_SavTauxH.Close;
            StProc_SavTauxH.ParamByName('NOM').AsString := GetValueSavTauxHImp('NOM');
            StProc_SavTauxH.ParamByName('PRIX').AsString := GetValueSavTauxHImp('PRIX');
            StProc_SavTauxH.ParamByName('CENTRALE').AsString := GetValueSavTauxHImp('CENTRALE');
            StProc_SavTauxH.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavTauxHID(sID, StProc_SavTauxH.FieldByName('ID').AsInteger);
            StProc_SavTauxH.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavTauxHID;
    StProc_SavTauxH.Close;
  end;
end;

function TAtelier.TraiterSavForfait: Boolean;
var
  AvancePc, NbRech, i, LRechID: Integer;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavForfait.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavForfait_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavForfait.Count;
  try
    for i:=1 to Pred(cds_SavForfait.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavForfait[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavForfait[i], SavForfait_COL);

          // Recherche si pas déjà importé.
          sID := GetValueSavForfaitImp('ID');
          LRechID := Dm_Main.RechercheSavForfaitID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sID <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavForfait.
            StProc_SavForfait.Close;
            StProc_SavForfait.ParamByName('NOM').AsString := GetValueSavForfaitImp('NOM');
            StProc_SavForfait.ParamByName('PRIX').AsString := GetValueSavForfaitImp('PRIX');
            StProc_SavForfait.ParamByName('DUREE').AsString := GetValueSavForfaitImp('DUREE');
            StProc_SavForfait.ParamByName('CENTRALE').AsString := GetValueSavForfaitImp('CENTRALE');
            StProc_SavForfait.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavForfaitID(sID, StProc_SavForfait.FieldByName('ID').AsInteger);
            StProc_SavForfait.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavForfaitID;
    StProc_SavForfait.Close;
  end;
end;

function TAtelier.TraiterSavForfaitL: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDForfait, IDArticle, IDTaille, IDCouleur: Integer;
  sIDForfait, sIDArticle, sIDTaille, sIDCouleur: String;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavForfaitL.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavForfaitL_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavForfaitL.Count;
  try
    for i:=1 to Pred(cds_SavForfaitL.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavForfaitL[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavForfaitL[i], SavForfaitL_COL);

          // ID forfait
          sIDForfait := GetValueSavForfaitLImp('FORID');
          IDForfait := Dm_Main.GetSavForfaitID(sIDForfait);
          if IDForfait = -1 then
            raise Exception.Create('Erreur :  l''ancien forfait [ID = ' + sIDForfait + '] n''a pas de nouvel équivalent !');

          // ID article.
          sIDArticle := GetValueSavForfaitLImp('ARTID');
          IDArticle := Dm_Main.GetArtID(sIDArticle);
          if IDArticle = -1 then
            IDArticle := 0;

          // ID taille.
          sIDTaille := GetValueSavForfaitLImp('TGFID');
          IDTaille := Dm_Main.GetTgfID(sIDTaille);
          if IDTaille = -1 then
            IDTaille := 0;

          // ID couleur.
          sIDCouleur := GetValueSavForfaitLImp('COUID');
          IDCouleur := Dm_Main.GetCouID(sIDCouleur);
          if IDCouleur = -1 then
            IDCouleur := 0;

          if(IDArticle = 0) or (IDTaille = 0) or (IDCouleur = 0) then
            raise Exception.Create('Erreur :  la ligne - article [ancien ID = ' + sIDArticle + '] - taille [ancien ID = ' + sIDTaille + '] - couleur [ancien ID = ' + sIDCouleur + '] du forfait [ancien ID = ' + sIDForfait + ' - nouvel ID = ' + IntToStr(IDForfait) + '] n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          sID := GetValueSavForfaitLImp('ID');
          LRechID := Dm_Main.RechercheSavForfaitLID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sIDForfait <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavForfaitL.
            StProc_SavForfaitL.Close;
            StProc_SavForfaitL.ParamByName('FORID').AsInteger := IDForfait;
            StProc_SavForfaitL.ParamByName('ARTID').AsInteger := IDArticle;
            StProc_SavForfaitL.ParamByName('TGFID').AsInteger := IDTaille;
            StProc_SavForfaitL.ParamByName('COUID').AsInteger := IDCouleur;
            StProc_SavForfaitL.ParamByName('QTE').AsString := GetValueSavForfaitLImp('QTE');
            StProc_SavForfaitL.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavForfaitLID(sID, StProc_SavForfaitL.FieldByName('ID').AsInteger);
            StProc_SavForfaitL.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavForfaitLID;
    StProc_SavForfaitL.Close;
  end;
end;

function TAtelier.TraiterSavPt1: Boolean;
var
  AvancePc, NbRech, i, LRechID: Integer;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavPt1.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavPt1_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavPt1.Count;
  try
    for i:=1 to Pred(cds_SavPt1.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavPt1[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavPt1[i], SavPt1_COL);

          // Recherche si pas déjà importé.
          sID := GetValueSavPt1Imp('ID');
          LRechID := Dm_Main.RechercheSavPt1ID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sID <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavPt1.
            StProc_SavPt1.Close;
            StProc_SavPt1.ParamByName('PICTO').AsString := GetValueSavPt1Imp('PICTO');
            StProc_SavPt1.ParamByName('ORDREAFF').AsString := GetValueSavPt1Imp('ORDREAFF');
            StProc_SavPt1.ParamByName('NOM').AsString := GetValueSavPt1Imp('NOM');
            StProc_SavPt1.ParamByName('CENTRALE').AsString := GetValueSavPt1Imp('CENTRALE');
            StProc_SavPt1.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavPt1ID(sID, StProc_SavPt1.FieldByName('ID').AsInteger);
            StProc_SavPt1.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavPt1ID;
    StProc_SavPt1.Close;
  end;
end;

function TAtelier.TraiterSavPt2: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDPt1, IDForfait, IDTaux, IDArticle: Integer;
  sIDPt1, sIDForfait, sIDTaux, sIDArticle: String;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavPt2.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavPt2_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavPt2.Count;
  try
    for i:=1 to Pred(cds_SavPt2.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavPt2[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavPt2[i], SavPt2_COL);

          // ID SavPt1
          sIDPt1 := GetValueSavPt2Imp('PT1ID');
          IDPt1 := Dm_Main.GetSavPt1ID(sIDPt1);
          if IDPt1 = -1 then
            raise Exception.Create('Erreur :  l''ancienne famille [ID = ' + sIDPt1 + '] n''a pas de nouvel équivalent !');

          if GetValueSavPt2Imp('FORFAIT') = '1' then
          begin
            // ID forfait
            sIDForfait := GetValueSavPt2Imp('FORID');
            IDForfait := Dm_Main.GetSavForfaitID(sIDForfait);
            if IDForfait = -1 then
              raise Exception.Create('Erreur :  l''ancien forfait [ID = ' + sIDForfait + '] n''a pas de nouvel équivalent !');
          end
          else
            IDForfait := 0;

          // ID SavTauxH
          sIDTaux := GetValueSavPt2Imp('TXHID');
          IDTaux := Dm_Main.GetSavTauxHID(sIDTaux);
          if (IDTaux = -1) and (sIDTaux <> '0') then
            raise Exception.Create('Erreur :  l''ancien tauxH [ID = ' + sIDTaux + '] n''a pas de nouvel équivalent !')
          else
            IDTaux := 0;

          // ID article.
          sIDArticle := GetValueSavPt2Imp('ARTID');
          IDArticle := Dm_Main.GetArtID(sIDArticle);
          if IDArticle = -1 then
            raise Exception.Create('Erreur :  l''article [ancien ID = ' + sIDArticle + '] lié à la famille [ancien ID = ' + sIDPt1 + ' - nouvel ID = ' + IntToStr(IDPt1) + '] n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          sID := GetValueSavPt2Imp('ID');
          LRechID := Dm_Main.RechercheSavPt2ID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sIDPt1 <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavPt2.
            StProc_SavPt2.Close;
            StProc_SavPt2.ParamByName('PT1ID').AsInteger := IDPt1;
            StProc_SavPt2.ParamByName('NOM').AsString := GetValueSavPt2Imp('NOM');
            StProc_SavPt2.ParamByName('FORFAIT').AsString := GetValueSavPt2Imp('FORFAIT');
            StProc_SavPt2.ParamByName('FORID').AsInteger := IDForfait;
            StProc_SavPt2.ParamByName('DUREE').AsString := GetValueSavPt2Imp('DUREE');
            StProc_SavPt2.ParamByName('PICTO').AsString := GetValueSavPt2Imp('PICTO');
            StProc_SavPt2.ParamByName('TXHID').AsInteger := IDTaux;
            StProc_SavPt2.ParamByName('ARTID').AsInteger := IDArticle;
            StProc_SavPt2.ParamByName('ORDREAFF').AsString := GetValueSavPt2Imp('ORDREAFF');
            StProc_SavPt2.ParamByName('LIBELLE').AsString := GetValueSavPt2Imp('LIBELLE');
            StProc_SavPt2.ParamByName('CENTRALE').AsString := GetValueSavPt2Imp('CENTRALE');
            StProc_SavPt2.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavPt2ID(sID, StProc_SavPt2.FieldByName('ID').AsInteger);
            StProc_SavPt2.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavPt2ID;
    StProc_SavPt2.Close;
  end;
end;

function TAtelier.TraiterSavTypMat: Boolean;
var
  AvancePc, NbRech, i, LRechID: Integer;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavTypMat.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavTypMat_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavTypMat.Count;
  try
    for i:=1 to Pred(cds_SavTypMat.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavTypMat[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavTypMat[i], SavTypMat_COL);

          // Recherche si pas déjà importé.
          sID := GetValueSavTypMatImp('ID');
          LRechID := Dm_Main.RechercheSavTypMatID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sID <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavTypMat.
            StProc_SavTypMat.Close;
            StProc_SavTypMat.ParamByName('NOM').AsString := GetValueSavTypMatImp('NOM');
            StProc_SavTypMat.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavTypMatID(sID, StProc_SavTypMat.FieldByName('ID').AsInteger);
            StProc_SavTypMat.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavTypMatID;
    StProc_SavTypMat.Close;
  end;
end;

function TAtelier.TraiterSavType: Boolean;
var
  AvancePc, NbRech, i, LRechID: Integer;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavType.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavType_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavType.Count;
  try
    for i:=1 to Pred(cds_SavType.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavType[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavType[i], SavType_COL);

          // Recherche si pas déjà importé.
          sID := GetValueSavTypeImp('ID');
          LRechID := Dm_Main.RechercheSavTypeID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sID <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavType.
            StProc_SavType.Close;
            StProc_SavType.ParamByName('NOM').AsString := GetValueSavTypeImp('NOM');
            StProc_SavType.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavTypeID(sID, StProc_SavType.FieldByName('ID').AsInteger);
            StProc_SavType.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavTypeID;
    StProc_SavType.Close;
  end;
end;

function TAtelier.TraiterSavMat: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDClient, IDTypeMat, IDMarque, IDArticle, IDArticleLocation, IDMateriel: Integer;
  sIDClient, sIDTypeMat, sIDMarque, sIDArticle, sIDArticleLocation: String;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavMat.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavMat_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavMat.Count;
  try
    for i:=1 to Pred(cds_SavMat.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavMat[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavMat[i], SavMat_COL);

          // ID SavTypMat
          sIDTypeMat := GetValueSavMatImp('TYMID');
          IDTypeMat := Dm_Main.GetSavTypMatID(sIDTypeMat);
          if IDTypeMat = -1 then
            raise Exception.Create('Erreur :  l''ancien type de matériel [ID = ' + sIDTypeMat + '] n''a pas de nouvel équivalent !');

          // ID client.
          sIDClient := GetValueSavMatImp('CLTID');
          IDClient := Dm_Main.GetClientID(sIDClient);
          if IDClient = -1 then
            raise Exception.Create('Erreur :  le client [ancien ID = ' + sIDClient + '] n''a pas de nouvel équivalent !');

          // ID marque.
          sIDMarque := GetValueSavMatImp('MRKID');
          IDMarque := Dm_Main.GetMrkID(sIDMarque);
          if IDMarque = -1 then
            raise Exception.Create('Erreur :  la marque [ancien ID = ' + sIDMarque + '] n''a pas de nouvel équivalent !');

          // ID article.
          sIDArticle := GetValueSavMatImp('ARTID');
          IDArticle := Dm_Main.GetArtID(sIDArticle);
          if IDArticle = -1 then
             IDArticle := 0;

          // ID article location.
          sIDArticleLocation := GetValueSavMatImp('ARTID');
          IDArticleLocation := Dm_Main.GetArtID(sIDArticleLocation);
          if IDArticleLocation = -1 then
             IDArticleLocation := 0;

          // Recherche si pas déjà importé.
          sID := GetValueSavMatImp('ID');
          LRechID := Dm_Main.RechercheSavMatID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (sIDClient <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavMat.
            StProc_SavMat.Close;
            StProc_SavMat.ParamByName('CLTID').AsInteger := IDClient;
            StProc_SavMat.ParamByName('TYMID').AsInteger := IDTypeMat;
            StProc_SavMat.ParamByName('MRKID').AsInteger := IDMarque;
            StProc_SavMat.ParamByName('ARTID').AsInteger := IDArticle;
            StProc_SavMat.ParamByName('NOM').AsString := GetValueSavMatImp('NOM');
            StProc_SavMat.ParamByName('SERIE').AsString := GetValueSavMatImp('SERIE');
            StProc_SavMat.ParamByName('COULEUR').AsString := GetValueSavMatImp('COULEUR');
            StProc_SavMat.ParamByName('COMMENT').AsString := GetValueSavMatImp('COMMENT') + GetValueSavMatImp('OLDCHRONO');
            StProc_SavMat.ParamByName('DATEACHAT').AsString := GetValueSavMatImp('DATEACHAT');
            StProc_SavMat.ParamByName('REFMRK').AsString := GetValueSavMatImp('REFMRK');
            StProc_SavMat.ParamByName('ASSUR').AsString := GetValueSavMatImp('ASSUR');
            StProc_SavMat.ParamByName('CHRONO').AsString := GetValueSavMatImp('CHRONO');
            StProc_SavMat.ParamByName('ARLID').AsInteger := IDArticleLocation;
            StProc_SavMat.ExecQuery;

            // Récupération du nouvel ID.
            IDMateriel := StProc_SavMat.FieldByName('ID').AsInteger;
            Dm_Main.AjoutInListeSavMatID(sID, IDMateriel);
            StProc_SavMat.Close;

            // ajoute l'ancien chrono en tant que CB
            StProc_SavCb.Close;
            StProc_SavCb.ParamByName('MATID').AsInteger := IDMateriel;
            StProc_SavCb.ParamByName('CB').AsString := GetValueSavMatImp('OLDCHRONO');
            StProc_SavCb.ExecQuery;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavMatID;
    StProc_SavMat.Close;
  end;
end;

function TAtelier.TraiterSavCb: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDMateriel: Integer;
  sIDMateriel: String;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavCb.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavCb_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavCb.Count;
  try
    for i:=1 to Pred(cds_SavCb.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavCb[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavCb[i], SavCb_COL);

          // ID SavMat
          sIDMateriel := GetValueSavCbImp('MATID');
          IDMateriel := Dm_Main.GetSavMatID(sIDMateriel);
          if IDMateriel = -1 then
            raise Exception.Create('Erreur :  l''ancien matériel [ID = ' + sIDMateriel + '] n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          sID := GetValueSavCbImp('ID');
          LRechID := Dm_Main.RechercheSavCbID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) and (GetValueSavCbImp('CB') <> '') then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavMat.
            StProc_SavCb.Close;
            StProc_SavCb.ParamByName('MATID').AsInteger := IDMateriel;
            StProc_SavCb.ParamByName('CB').AsString := GetValueSavCbImp('CB');
            StProc_SavCb.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavCbID(sID, StProc_SavCb.FieldByName('ID').AsInteger);
            StProc_SavCb.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavCbID;
    StProc_SavCb.Close;
  end;
end;

function TAtelier.TraiterSavFichee: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDClient, IDMateriel, IDType, IDTaux, IDTicket: Integer;
  sIDClient, sIDMateriel, sIDType, sIDTaux, sIDTicket: String;
  sTmpMag : string;
  MagCode : String;
  iMagID : Integer;
  sID: String;
begin
  Result := True;
  MagCode := '';
  iMagID  := 0;

  iMaxProgress := Pred(cds_SavFichee.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavFichee_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavFichee.Count;
  try
    for i:=1 to Pred(cds_SavFichee.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavFichee[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavFichee[i], SavFichee_COL);

          // magasin
          sTmpMag := GetValueSavFicheeImp('CODE_MAG');
          if sTmpMag<>MagCode then
          begin
            MagCode := sTmpMag;
            iMagID := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID=0 then
            Raise Exception.Create('Atelier - Magasin non trouvé pour - CODE_MAG = '+MagCode);

          // ID client
          sIDClient := GetValueSavFicheeImp('CLTID');
          IDClient := Dm_Main.GetClientID(sIDClient);
          if IDClient = -1 then
            raise Exception.Create('Erreur :  le client [ID = ' + sIDClient + '] lié à la fiche de réparation n''a pas de nouvel équivalent !');

          // ID SavMat
          sIDMateriel := GetValueSavFicheeImp('MATID');
          IDMateriel := Dm_Main.GetSavMatID(sIDMateriel);
          if IDMateriel = -1 then
            raise Exception.Create('Erreur :  l''ancien matériel [ID = ' + sIDMateriel + '] lié à la fiche de réparation n''a pas de nouvel équivalent !');

          // ID SavType
          sIDType := GetValueSavFicheeImp('STYID');
          IDType := Dm_Main.GetSavTypeID(sIDType);
          if (IDType = -1) and (sIDType <> '0') then
            raise Exception.Create('Erreur :  l''ancien savtype [ID = ' + sIDType + '] lié à la fiche de réparation n''a pas de nouvel équivalent !');

          // ID Savtaux
          sIDTaux := GetValueSavFicheeImp('TXHID');
          IDTaux := Dm_Main.GetSavTauxHID(sIDTaux);
          if (IDTaux = -1) and (sIDTaux <> '0') then
            raise Exception.Create('Erreur :  l''ancien savtaux [ID = ' + sIDTaux + '] lié à la fiche de réparation n''a pas de nouvel équivalent !');

          // ID ticket
          sIDTicket := GetValueSavFicheeImp('TKEID');
          IDTicket := Dm_Main.GetCaisseID(sIDTicket);
          if IDTicket = -1 then
            IDTicket := 0;

          // Recherche si pas déjà importé.
          sID := GetValueSavFicheeImp('ID');
          LRechID := Dm_Main.RechercheSavFicheeID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavFichee.
            StProc_SavFichee.Close;
            StProc_SavFichee.ParamByName('CLTID').AsInteger := IDClient;
            StProc_SavFichee.ParamByName('MATID').AsInteger := IDMateriel;
            StProc_SavFichee.ParamByName('CHRONO').AsString := GetValueSavFicheeImp('CHRONO');
            StProc_SavFichee.ParamByName('DTCREATION').AsString := GetValueSavFicheeImp('DTCREATION');
            StProc_SavFichee.ParamByName('DEBUT').AsString := GetValueSavFicheeImp('DEBUT');
            StProc_SavFichee.ParamByName('FIN').AsString := GetValueSavFicheeImp('FIN');
            StProc_SavFichee.ParamByName('REMMO').AsString := GetValueSavFicheeImp('REMMO');
            StProc_SavFichee.ParamByName('REMART').AsString := GetValueSavFicheeImp('REMART');
            StProc_SavFichee.ParamByName('REM').AsString := GetValueSavFicheeImp('REM');
            StProc_SavFichee.ParamByName('IDENT').AsString := GetValueSavFicheeImp('IDENT');
            StProc_SavFichee.ParamByName('USRID').AsString := GetValueSavFicheeImp('USRID');
            StProc_SavFichee.ParamByName('LIMITE').AsString := GetValueSavFicheeImp('LIMITE');
            StProc_SavFichee.ParamByName('MAGID').AsInteger := iMagID;
            StProc_SavFichee.ParamByName('ETAT').AsString := GetValueSavFicheeImp('ETAT');
            StProc_SavFichee.ParamByName('DATEREPRISE').AsString := GetValueSavFicheeImp('DATEREPRISE');
            StProc_SavFichee.ParamByName('STYID').AsInteger := IDType;
            StProc_SavFichee.ParamByName('DATEPLANNING').AsString := GetValueSavFicheeImp('DATEPLANNING');
            StProc_SavFichee.ParamByName('COMMENT').AsString := GetValueSavFicheeImp('COMMENT');
            StProc_SavFichee.ParamByName('ORDREAFF').AsString := GetValueSavFicheeImp('ORDREAFF');
            StProc_SavFichee.ParamByName('DUREEGLOB').AsString := GetValueSavFicheeImp('DUREEGLOB');
            StProc_SavFichee.ParamByName('DUREE').AsString := GetValueSavFicheeImp('DUREE');
            StProc_SavFichee.ParamByName('TXHID').AsInteger := IDTaux;
            StProc_SavFichee.ParamByName('PXTAUX').AsString := GetValueSavFicheeImp('PXTAUX');
            StProc_SavFichee.ParamByName('TKEID').AsInteger := IDTicket;
            StProc_SavFichee.ParamByName('NEUF').AsString := GetValueSavFicheeImp('NEUF');
            StProc_SavFichee.ParamByName('PLACE').AsString := GetValueSavFicheeImp('PLACE');
            StProc_SavFichee.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavFicheeID(sID, StProc_SavFichee.FieldByName('ID').AsInteger);
            StProc_SavFichee.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavFicheeID;
    StProc_SavFichee.Close;
  end;
end;

function TAtelier.TraiterSavFicheL: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDSavFichee, IDPt2, IDForfait, IDTaux: Integer;
  sIDSavFichee, sIDPt2, sIDForfait, sIDTaux: String;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavFicheL.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavFicheL_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavFicheL.Count;
  try
    for i:=1 to Pred(cds_SavFicheL.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavFicheL[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavFicheL[i], SavFicheL_COL);

          // ID SavFichee
          sIDSavFichee := GetValueSavFicheLImp('SAVID');
          IDSavFichee := Dm_Main.GetSavFicheeID(sIDSavFichee);
          if IDSavFichee = -1 then
            raise Exception.Create('Erreur :  l''ancien entete [ID = ' + sIDSavFichee + '] lié à la ligne de la fiche de réparation n''a pas de nouvel équivalent !');

          // ID SavPt2
          sIDPt2 := GetValueSavFicheLImp('PT2ID');
          IDPt2 := Dm_Main.GetSavPt2ID(sIDPt2);
          if (IDPt2 = -1) and (sIDPt2 <> '0') then
            raise Exception.Create('Erreur :  l''ancien savpt2 [ID = ' + sIDPt2 + '] lié à la ligne de la fiche de réparation n''a pas de nouvel équivalent !');

          // ID Savforfait
          sIDForfait := GetValueSavFicheLImp('FORID');
          IDForfait := Dm_Main.GetSavForfaitID(sIDForfait);
          if (IDForfait = -1) and (sIDForfait <> '0') then
            raise Exception.Create('Erreur :  l''ancien forfait [ID = ' + sIDForfait + '] lié à la ligne de la fiche de réparation n''a pas de nouvel équivalent !');

          // ID Savtaux
          sIDTaux := GetValueSavFicheLImp('TXHID');
          IDTaux := Dm_Main.GetSavTauxHID(sIDTaux);
          if (IDTaux = -1) and (sIDTaux <> '0') then
            raise Exception.Create('Erreur :  l''ancien savtaux [ID = ' + sIDTaux + '] lié à la ligne de la fiche de réparation n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          sID := GetValueSavFicheLImp('ID');
          LRechID := Dm_Main.RechercheSavFicheLID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavFicheL.
            StProc_SavFicheL.Close;
            StProc_SavFicheL.ParamByName('SAVID').AsInteger := IDSavFichee;
            StProc_SavFicheL.ParamByName('PT2ID').AsInteger := IDPt2;
            StProc_SavFicheL.ParamByName('FORID').AsInteger := IDForfait;
            StProc_SavFicheL.ParamByName('NOM').AsString := GetValueSavFicheLImp('NOM');
            StProc_SavFicheL.ParamByName('COMMENT').AsString := GetValueSavFicheLImp('COMMENT');
            StProc_SavFicheL.ParamByName('DUREE').AsString := GetValueSavFicheLImp('DUREE');
            StProc_SavFicheL.ParamByName('TXHID').AsInteger := IDTaux;
            StProc_SavFicheL.ParamByName('REMISE').AsString := GetValueSavFicheLImp('REMISE');
            StProc_SavFicheL.ParamByName('PXTOT').AsString := GetValueSavFicheLImp('PXTOT');
            StProc_SavFicheL.ParamByName('TERMINE').AsString := GetValueSavFicheLImp('TERMINE');
            StProc_SavFicheL.ParamByName('PXBRUT').AsString := GetValueSavFicheLImp('PXBRUT');
            StProc_SavFicheL.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavFicheLID(sID, StProc_SavFicheL.FieldByName('ID').AsInteger);
            StProc_SavFicheL.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavFicheLID;
    StProc_SavFicheL.Close;
  end;
end;

function TAtelier.TraiterSavFicheArt: Boolean;
var
  AvancePc, NbRech, i, LRechID, IDArticle, IDTaille, IDCouleur, IDSavFichee, IDSavLigne: Integer;
  sIDArticle, sIDTaille, sIDCouleur, sIDSavFichee, sIDSavLigne: String;
  sID: String;
begin
  Result := True;
  iMaxProgress := Pred(cds_SavFicheArt.Count);
  iProgress := 0;
  AvancePc := Round((iMaxProgress / 100) * 2);
  if AvancePc <= 0 then
    AvancePc := 1;
  Inc(iTraitement);
  sEtat1 := 'Importation (' + IntToStr(iTraitement) + '/' + IntToStr(iNbTraitement) + ') "' + SavFicheArt_CSV + '":';
  sEtat2 := '0 / ' + FormatFloat(',##0', iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDSavFicheArt.Count;
  try
    for i:=1 to Pred(cds_SavFicheArt.Count) do
    begin
      // Maj de la fenêtre.
      sEtat2 := FormatFloat(',##0', iProgress) + ' / ' + FormatFloat(',##0', iMaxProgress);
      Inc(iProgress);
      if(iProgress mod AvancePc) = 0 then
        Synchronize(UpdProgressFrm);

      if cds_SavFicheArt[i] <> '' then
      begin
        try
          // Ajout ligne.
          AjoutInfoLigne(cds_SavFicheArt[i], SavFicheArt_COL);

          // ID article
          sIDArticle := GetValueSavFicheArtImp('ARTID');
          IDArticle := Dm_Main.GetArtID(sIDArticle);
          if IDArticle = -1 then
            raise Exception.Create('Erreur :  l''ancien article [ID = ' + sIDArticle + '] lié à la réparation n''a pas de nouvel équivalent !');

          // ID taille
          sIDTaille := GetValueSavFicheArtImp('TGFID');
          IDTaille := Dm_Main.GetTgfID(sIDTaille);
          if IDTaille = -1 then
            raise Exception.Create('Erreur :  l''ancienne taille d''article [ID = ' + sIDTaille + '] lié à la réparation n''a pas de nouvel équivalent !');

          // ID couleur
          sIDCouleur := GetValueSavFicheArtImp('COUID');
          IDCouleur := Dm_Main.GetCouID(sIDCouleur);
          if IDCouleur = -1 then
            raise Exception.Create('Erreur :  l''ancienne couleur d''article [ID = ' + sIDCouleur + '] lié à la réparation n''a pas de nouvel équivalent !');

          // ID SavFichee
          sIDSavFichee := GetValueSavFicheArtImp('SAVID');
          IDSavFichee := Dm_Main.GetSavFicheeID(sIDSavFichee);
          if (IDSavFichee = -1) and (sIDSavFichee <> '0') then
            raise Exception.Create('Erreur :  l''ancienne ficheSAV [ID = ' + sIDSavFichee + '] lié à la réparation n''a pas de nouvel équivalent !');

          // ID SavFicheL
          sIDSavLigne := GetValueSavFicheArtImp('SALID');
          IDSavLigne := Dm_Main.GetSavFicheLID(sIDSavLigne);
          if (IDSavLigne = -1) and (sIDSavLigne <> '0') then
            raise Exception.Create('Erreur :  l''ancienne ligne de ficheSAV [ID = ' + sIDSavLigne + '] lié à la réparation n''a pas de nouvel équivalent !');

          // Recherche si pas déjà importé.
          sID := GetValueSavFicheArtImp('ID');
          LRechID := Dm_Main.RechercheSavFicheArtID(sID, NbRech);

          // Création si pas déjà créé.
          if(LRechID = -1) then
          begin
            if not Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.StartTransaction;

            // Traitement SavFicheArt.
            StProc_SavFicheArt.Close;
            StProc_SavFicheArt.ParamByName('ARTID').AsInteger := IDArticle;
            StProc_SavFicheArt.ParamByName('TGFID').AsInteger := IDTaille;
            StProc_SavFicheArt.ParamByName('COUID').AsInteger := IDCouleur;
            StProc_SavFicheArt.ParamByName('SAVID').AsInteger := IDSavFichee;
            StProc_SavFicheArt.ParamByName('SALID').AsInteger := IDSavLigne;
            StProc_SavFicheArt.ParamByName('PU').AsString := GetValueSavFicheArtImp('PU');
            StProc_SavFicheArt.ParamByName('REMISE').AsString := GetValueSavFicheArtImp('REMISE');
            StProc_SavFicheArt.ParamByName('QTE').AsString := GetValueSavFicheArtImp('QTE');
            StProc_SavFicheArt.ParamByName('PXTOT').AsString := GetValueSavFicheArtImp('PXTOT');
            StProc_SavFicheArt.ParamByName('TYPID').AsString := GetValueSavFicheArtImp('TYPID');
            StProc_SavFicheArt.ExecQuery;

            // Récupération du nouvel ID.
            Dm_Main.AjoutInListeSavFicheArtID(sID, StProc_SavFicheArt.FieldByName('ID').AsInteger);
            StProc_SavFicheArt.Close;

            Dm_Main.TransacAtelier.Commit;
          end;
        except
          on E: Exception do
          begin
            if Dm_Main.TransacAtelier.InTransaction then
              Dm_Main.TransacAtelier.Rollback;
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
    Dm_Main.SaveListeSavFicheArtID;
    StProc_SavFicheArt.Close;
  end;
end;

procedure TAtelier.AjoutInfoLigne(const ALigne: String; ADefColonne: Array of String);
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

function TAtelier.GetValueSavTauxHImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavTauxH_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavForfaitImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavForfait_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavForfaitLImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavForfaitL_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavPt1Imp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavPt1_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavPt2Imp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavPt2_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavTypMatImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavTypMat_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavTypeImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavType_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavMatImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavMat_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavCbImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavCb_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavFicheeImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavFichee_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavFicheLImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavFicheL_COL, sLigneLecture, bRetirePtVirg);
end;

function TAtelier.GetValueSavFicheArtImp(const AChamp: String): String;
begin
  Result := GetValueImp(AChamp, SavFicheArt_COL, sLigneLecture, bRetirePtVirg);
end;

procedure TAtelier.InitFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(11, bm);
    Frm_Load.img_Atelier.Picture := nil;
    Frm_Load.img_Atelier.Picture.Assign(bm);
    Frm_Load.img_Atelier.Transparent := False;
    Frm_Load.img_Atelier.Transparent := True;
  finally
    FreeAndNil(bm);
  end;

  Frm_Load.Lab_EtatAtelier1.Caption := 'Initialisation';
  Frm_Load.Lab_EtatAtelier2.Caption := '';
  Frm_Load.Lab_EtatAtelier2.Hint := '';
end;

procedure TAtelier.InitExecute;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(3, bm);
    Frm_Load.img_Atelier.Picture := nil;
    Frm_Load.img_Atelier.Picture.Assign(bm);
    Frm_Load.img_Atelier.Transparent := False;
    Frm_Load.img_Atelier.Transparent := True;
  finally
    FreeAndNil(bm);
  end;
end;

procedure TAtelier.UpdateFrm;
begin
  Frm_Load.Lab_EtatAtelier1.Caption := sEtat1;
  Frm_Load.Lab_EtatAtelier2.Caption := sEtat2;
  Frm_Load.Lab_EtatAtelier2.Hint := sEtat2;
end;

procedure TAtelier.InitProgressFrm;
begin
  Frm_Load.pb_EtatAtelier.Position := 0;
  Frm_Load.pb_EtatAtelier.Max := iMaxProgress;
end;

procedure TAtelier.UpdProgressFrm;
begin
  Frm_Load.Lab_EtatAtelier2.Caption := sEtat2;
  Frm_Load.Lab_EtatAtelier2.Hint := sEtat2;
  Frm_Load.pb_EtatAtelier.Position := iProgress;
end;

procedure TAtelier.ErrorFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(10, bm);
    Frm_Load.img_Atelier.Picture := nil;
    Frm_Load.img_Atelier.Picture.Assign(bm);
    Frm_Load.img_Atelier.Transparent := False;
    Frm_Load.img_Atelier.Transparent := True;
  finally
    FreeAndNil(bm);
  end;

  Frm_Load.DoErreurAtelier(sError);
end;

procedure TAtelier.EndFrm;
var
  bm: tbitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(0, bm);
    Frm_Load.img_Atelier.Picture := nil;
    Frm_Load.img_Atelier.Picture.Assign(bm);
    Frm_Load.img_Atelier.Transparent := False;
    Frm_Load.img_Atelier.Transparent := True;
  finally
    FreeAndNil(bm);
  end;

  Frm_Load.Lab_EtatAtelier1.Caption := 'Importation';
  Frm_Load.Lab_EtatAtelier2.Caption := 'Terminé';
  Frm_Load.Lab_EtatAtelier2.Hint := '';
end;

destructor TAtelier.Destroy;
begin
  FreeAndNil(cds_SavTauxH);
  FreeAndNil(cds_SavForfait);
  FreeAndNil(cds_SavForfaitL);
  FreeAndNil(cds_SavPt1);
  FreeAndNil(cds_SavPt2);
  FreeAndNil(cds_SavTypMat);
  FreeAndNil(cds_SavType);
  FreeAndNil(cds_SavMat);
  FreeAndNil(cds_SavCb);
  FreeAndNil(cds_SavFichee);
  FreeAndNil(cds_SavFicheL);
  FreeAndNil(cds_SavFicheArt);

  FreeAndNil(StProc_SavTauxH);
  FreeAndNil(StProc_SavForfait);
  FreeAndNil(StProc_SavForfaitL);
  FreeAndNil(StProc_SavPt1);
  FreeAndNil(StProc_SavPt2);
  FreeAndNil(StProc_SavTypMat);
  FreeAndNil(StProc_SavType);
  FreeAndNil(StProc_SavMat);
  FreeAndNil(StProc_SavCb);
  FreeAndNil(StProc_SavFichee);
  FreeAndNil(StProc_SavFicheL);
  FreeAndNil(StProc_SavFicheArt);

  FreeAndNil(cds_Magasin);

  inherited;
end;

end.

